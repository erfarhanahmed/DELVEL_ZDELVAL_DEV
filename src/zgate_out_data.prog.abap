*&---------------------------------------------------------------------*
*&  Include           ZGATE_OUT_DATA
*&---------------------------------------------------------------------*

START-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  GET_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_entry .

  CASE abap_true.
    WHEN r_create.
      PERFORM create_entry.
      CALL SCREEN 0100.
    WHEN r_disply.
      PERFORM display_entry.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM
  create_entry .

  IF r_create IS NOT INITIAL.

    zgate_out-zv_date    = sy-datum.
    zgate_out-zcreted_by = sy-uname.
    zgate_out-zout_time  = sy-uzeit.
    zgate_out-zout_date  = sy-datum.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK_0100'.
      LEAVE TO SCREEN 0.
    WHEN 'CLOSE_0100'.
      LEAVE TO SCREEN 0.
    WHEN 'BACK_0100'.
      LEAVE TO SCREEN 0.
    WHEN '&SAVE_0111'.
      PERFORM save_data.
    WHEN '/&CLEAR_011'.
      PERFORM clear_data.
    WHEN ''.

      DATA : lv_gross      TYPE vbrp-netwr,
             sum_mwsbp     TYPE vbrp-mwsbp,
             sum_tax       TYPE vbrp-netwr,
             lv_base_price TYPE PRCD_ELEMENTS-kwert,
             tax_amt       TYPE PRCD_ELEMENTS-kwert,
             invoice_amt   TYPE PRCD_ELEMENTS-kwert,
             lv_base       TYPE PRCD_ELEMENTS-kwert,
             lv_dc         TYPE PRCD_ELEMENTS-kwert,
             lv_oth        TYPE PRCD_ELEMENTS-kwert.

      DATA : lv_inv    TYPE zgate_out-zinvoice_no.
      DATA : lv_ref    TYPE zgate_out-zrefe_no.
      DATA : lv_xblnr  TYPE xblnr.
      DATA : lv_vbeln  TYPE vbeln.

      lv_ref =  zgate_out-zrefe_no.

      IF lv_ref IS NOT INITIAL.

        SELECT SINGLE xblnr ,vbeln
        FROM vbrk INTO @DATA(wa_vbrk1)
        WHERE xblnr = @lv_ref.

        lv_xblnr = wa_vbrk1-xblnr.
        lv_vbeln = wa_vbrk1-vbeln.

        IF wa_vbrk1 IS INITIAL.

          DATA input  TYPE vbrk-xblnr.
          DATA output TYPE char12.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_ref
            IMPORTING
              output = output.

          lv_xblnr = output.

          SELECT SINGLE xblnr ,vbeln
         FROM vbrk INTO @DATA(wa_vbrk2)
         WHERE xblnr = @lv_xblnr.

          lv_xblnr = wa_vbrk2-xblnr.
          lv_vbeln = wa_vbrk2-vbeln.
        ENDIF.

        SELECT posnr,
               arktx,
               vrkme,
               netwr ,
               matnr,
               vkorg_auft,
               mwsbp,
               werks,
               aubel,
               fkimg
          FROM vbrp
          INTO TABLE @DATA(it_data_n)
          WHERE vbeln = @lv_vbeln.

        IF it_data_n IS INITIAL .
          MESSAGE |Invalid Invoice No| TYPE 'E'.
        ENDIF.

        IF it_data_n IS NOT INITIAL.
          SELECT SINGLE zinvoice_no FROM zgate_out
          INTO @DATA(wa_gate)
          WHERE zrefe_no = @lv_xblnr
          AND zdelete_ind NE 'X'  .

          IF  wa_gate IS NOT  INITIAL.
            MESSAGE |Invoice No. already used. Please choose another one .| TYPE 'E'.
          ENDIF.
        ENDIF.

        SELECT SINGLE vbeln, knumv ,kunag,fkart FROM vbrk
          INTO @DATA(wa_vbrk)
          WHERE vbeln = @lv_vbeln.

        SELECT knumv,kposn,kschl,
           kwert
          FROM PRCD_ELEMENTS
          WHERE knumv = @wa_vbrk-knumv
          AND kinak NE 'M'
          INTO TABLE @DATA(it_konv).
        SORT it_konv BY kposn.
        LOOP AT it_konv ASSIGNING FIELD-SYMBOL(<wa_konv>).
*          TRY .
*          ON CHANGE OF <wa_konv>-kposn .

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'ZPFO' ] ) .
            DATA(lv_zpfo) = it_konv[ kposn = <wa_konv>-kposn kschl = 'ZPFO' ]-kwert.
          ENDIF.

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'ZIN1' ] ) .
            DATA(lv_zin1) = it_konv[ kposn = <wa_konv>-kposn kschl = 'ZIN1' ]-kwert.
          ENDIF.

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'ZFR1' ] ) .
            DATA(lv_zfr1) = it_konv[ kposn = <wa_konv>-kposn kschl = 'ZFR1' ]-kwert.
          ENDIF.

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'ZTE1' ] ) .
            DATA(lv_zte1) = it_konv[ kposn = <wa_konv>-kposn kschl = 'ZTE1' ]-kwert.
          ENDIF.

          DATA lv_sum TYPE  prcd_elements-kwert.
          IF lv_sum IS INITIAL.
            lv_sum = lv_zpfo + lv_zin1 + lv_zfr1 + lv_zte1. "+ LV_ZDIS, LV_ZOCL, lv_ZTC1."
          ENDIF.

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'ZPR0' ] ) .                          """"FOR BASE PRICE
            lv_base_price = it_konv[ kschl = 'ZPR0' ]-kwert.
            wa_base-kwert = lv_base_price.
          ENDIF.

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'JOIG' ] ) .   """FOR TAX AMOUNT
            tax_amt  = it_konv[ kposn = <wa_konv>-kposn kschl = 'JOIG' ]-kwert.
            wa_base-kwert1 = tax_amt.
          ENDIF.

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'JTC1' ] ) .   """FOR TAX AMOUNT
            tax_amt  = it_konv[ kposn = <wa_konv>-kposn kschl = 'JTC1' ]-kwert.
            wa_base-kwert1 = tax_amt.
          ENDIF.

          IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'ZTCS' ] ) .   """FOR TAX AMOUNT
            tax_amt  = it_konv[ kposn = <wa_konv>-kposn kschl = 'ZTCS' ]-kwert.
            wa_base-kwert1 = tax_amt.
          ENDIF.

          IF  wa_vbrk-fkart EQ 'ZDC'.
            IF line_exists( it_konv[ kposn = <wa_konv>-kposn kschl = 'VPRS' ] ) .
              lv_dc  = it_konv[ kposn = <wa_konv>-kposn kschl = 'VPRS' ]-kwert.
              wa_base-lv_dc = lv_dc.
            ENDIF.
          ENDIF.

          IF wa_base-kwert1 IS INITIAL.
            wa_base-kwert1 = tax_amt.
          ENDIF.

          wa_base-lv_sum  = lv_sum.

          wa_base-kposn = <wa_konv>-kposn.
          APPEND wa_base TO it_base.

          CLEAR : wa_base,<wa_konv>,lv_base_price,tax_amt,invoice_amt,lv_zpfo,lv_zin1,lv_zfr1,
          lv_zte1,lv_sum.

        ENDLOOP.

        IF it_data_n IS INITIAL.

          MESSAGE ' Invoice/Challan No. does not exist :' && lv_inv   TYPE 'I' DISPLAY LIKE 'E' .

        ENDIF.
      ENDIF.

      SELECT FROM vbrk AS a INNER JOIN vbrp AS b
            ON a~vbeln EQ b~vbeln
        INNER JOIN mseg AS c
            ON b~vgbel EQ c~mblnr
        FIELDS a~vbeln ,c~ebeln
        WHERE  a~vbeln  = @lv_vbeln
        INTO TABLE @DATA(it_mseg).

      CLEAR lv_inv.
      IF it_data_n[] IS NOT INITIAL.
        IF flag IS INITIAL.
          LOOP AT it_data_n INTO DATA(wa_data_n).

            wa_data-posnr      =  wa_data_n-posnr.
            wa_data-arktx      =  wa_data_n-arktx.
            wa_data-vrkme      =  wa_data_n-vrkme.
            wa_data-netwr      =  wa_data_n-netwr.
            wa_data-matnr      =  wa_data_n-matnr.
            wa_data-vkorg_auft =  wa_data_n-vkorg_auft.
            wa_data-mwsbp      =  wa_data_n-mwsbp.
            wa_data-werks      =  wa_data_n-werks.
            wa_data-aubel      =  wa_data_n-aubel.


            IF wa_data_n-aubel IS INITIAL.
              READ TABLE it_mseg INTO DATA(wa_mseg) WITH KEY vbeln = lv_vbeln.
              wa_data-aubel      =  wa_mseg-ebeln.
            ENDIF.

            wa_data-fkimg      =  wa_data_n-fkimg.
            wa_data-lv_gross   =  wa_data_n-netwr + wa_data_n-mwsbp.

            wa_data-kunag      =  wa_vbrk-kunag.

            READ TABLE it_base INTO  wa_base WITH KEY  kposn = wa_data-posnr.

            wa_data-lv_sum     =  wa_base-lv_sum.
            wa_data-lv_base    =  wa_base-kwert.

            IF  wa_vbrk-fkart EQ 'ZDC' AND wa_data-lv_base EQ 0 .         """""""""logic Only for billing type(ZDC)
              wa_data-lv_base = wa_base-lv_dc.
            ENDIF.

            wa_data-lv_dc      =  wa_base-lv_dc.

            wa_data-lv_oth     =  wa_data-lv_sum + wa_data-lv_base + wa_data-mwsbp.

            APPEND wa_data TO it_data.
          ENDLOOP.
          flag = 'X' .
        ENDIF.

        IF  wa_vbrk-fkart EQ 'ZDC'.
          CLEAR : lv_dc, lv_oth.
        ENDIF.

        IF lv_gross IS INITIAL.
          LOOP AT it_data INTO DATA(wa_sum).
            lv_gross   =  lv_gross  + wa_sum-lv_gross.
            sum_mwsbp  =  sum_mwsbp + wa_sum-mwsbp.
            sum_tax    =  sum_tax   + wa_sum-netwr.
            lv_sum     =  lv_sum    + wa_sum-lv_sum.
            lv_base    =  lv_base   + wa_sum-lv_base.
            lv_oth     =  lv_oth    + wa_sum-lv_oth.
            lv_dc      =  lv_dc     + wa_sum-lv_dc.
          ENDLOOP.
          CLEAR : wa_data,wa_base,it_base.
        ENDIF.

        IF  wa_vbrk-fkart EQ 'ZDC' AND lv_oth EQ '0' .  """""""""logic Only for billing type(ZDC)
          lv_oth = lv_dc.
        ENDIF.

      ENDIF.
  ENDCASE.

ENDMODULE.

MODULE ztrans_name.

  IF  zgate_out-ztrans_name IS NOT INITIAL.

    SELECT
           ztrans_name_01
      FROM ztransportercode
      WHERE ztrans_name_01 = @zgate_out-ztrans_name
      INTO @DATA(wa_trans).
    ENDSELECT.

    IF  wa_trans NE zgate_out-ztrans_name .

      MESSAGE 'Invalid Transporter Name' TYPE 'E' .
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_data .

  DATA lv_inv1 TYPE zgate_out-zinvoice_no .

  lv_inv1 = lv_vbeln.

* IF FKART EQ ZDC OR ZSN OR ZSP .   "ADD BY SUPRIYA
  SELECT SINGLE vbeln,
         xblnr,
         fkdat,
         FKART
   FROM vbrk
   INTO @DATA(wa_vbrk)
*   WHERE vbeln = @lv_inv1.
    WHERE vbeln = @lv_inv1.

************************************ADDED BY SUPRIYA
* Start Added by supriya on 06.07.2024
  SELECT VBELN,
         POSNR,
         VGBEL,
         LGORT
    FROM VBRP
    INTO TABLE @DATA(IT_VBRP)
    WHERE VBELN = @lv_inv1.                        " @ZGATE_OUT-ZINVOICE_NO.

 IF WA_VBRK-FKART EQ 'ZDC' OR WA_VBRK-FKART EQ 'ZSN' OR WA_VBRK-FKART EQ 'ZSP'.
 IF IT_VBRP IS NOT INITIAL.
    SELECT  MBLNR,
            MJAHR,
            ZEILE,
            LGORT,
            XAUTO
      FROM MSEG FOR ALL ENTRIES IN @IT_VBRP
      WHERE MBLNR = @IT_VBRP-VGBEL
      INTO TABLE @DATA(LT_MSEG).

 READ TABLE IT_VBRP INTO DATA(LS_VBRP) WITH KEY VBELN = lv_inv1.       "ZGATE_OUT-ZINVOICE_NO.
    IF SY-SUBRC = 0.
      LOOP AT LT_MSEG INTO DATA(LS_MSEG) WHERE MBLNR = LS_VBRP-VGBEL.
        IF LS_MSEG-XAUTO IS INITIAL.
          ZGATE_OUT-ZFSTORAGE_LOC = LS_MSEG-LGORT.
        ELSEIF LS_MSEG-XAUTO IS NOT INITIAL.

          IF LS_MSEG-LGORT IS NOT INITIAL.
            ZGATE_OUT-ZTSTORAGE_LOC = LS_MSEG-LGORT.
          ELSEIF LS_MSEG-LGORT IS INITIAL.
            ZGATE_OUT-ZTSTORAGE_LOC = 'Other'.
          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ELSEIF WA_VBRK-FKART NE 'ZDC' OR WA_VBRK-FKART NE 'ZSN' OR WA_VBRK-FKART NE 'ZSP'.
 READ TABLE IT_VBRP INTO LS_VBRP WITH KEY VBELN = lv_inv1.
 ZGATE_OUT-ZFSTORAGE_LOC = LS_VBRP-LGORT.
 ZGATE_OUT-ZTSTORAGE_LOC = 'Other'.
* ZGATE_OUT-ZTSTORAGE_LOC = ' '.
ENDIF.




*****************************************************************
  zgate_out-zv_date        = sy-datum.
  wa_final-zveh_num        = zgate_out-zveh_num.
  wa_final-zv_driver_name  = zgate_out-zv_driver_name.
  wa_final-ztrans_name     = zgate_out-ztrans_name.
  wa_final-ZFSTORAGE_LOC   = zgate_out-ZFSTORAGE_LOC.      " ADD BY SUPRIYA 05.07.2024
  wa_final-ZTSTORAGE_LOC   = zgate_out-ZTSTORAGE_LOC.      " ADD BY SUPRIYA 05.07.2024
  zgate_out-zinvoice_no    = lv_vbeln.
  zgate_out-zrefe_no       = lv_xblnr.
  wa_final-zcreted_by      = sy-uname.
  wa_final-zv_remark       = zgate_out-zv_remark.
  zgate_out-zout_date       = sy-datum.
  zgate_out-zout_time       = sy-uzeit.
  wa_final-zrefe_no        = wa_vbrk1-xblnr.
  zgate_out-zser_no        = zgate_out-zser_no + 1.

  DATA nr_range_nr TYPE inri-nrrangenr.
  DATA object      TYPE inri-object.
  DATA quantity    TYPE inri-quantity.
  DATA   lv_condate LIKE inri-toyear.
  DATA   number TYPE string.
  DATA   lv_number TYPE char10.
  DATA   lv_inv  TYPE vbeln.
*
  lv_condate = wa_vbrk-fkdat+0(4) .

  DATA i_date TYPE budat.
  DATA i_fyv  TYPE periv.
  DATA e_fy   TYPE char4.

  CALL FUNCTION 'GM_GET_FISCAL_YEAR'
    EXPORTING
      i_date                     = wa_vbrk-fkdat
*     I_FYV                      = 'I_FYV'
      i_fyv                      = 'V3'
    IMPORTING
      e_fy                       = e_fy
    EXCEPTIONS
      fiscal_year_does_not_exist = 1
      not_defined_for_date       = 2
      OTHERS                     = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  DATA lv_gjahr  TYPE inri-toyear.
  lv_gjahr = e_fy.


  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING

      nr_range_nr             = '01'
      object                  = 'ZGATEOUT'
      quantity                = '00000000000000000001'
*     SUBOBJECT               = ' '
      toyear                  = lv_gjahr
*     IGNORE_BUFFER           = ' '
    IMPORTING
      number                  = number
*     QUANTITY                = QUANTITY
*     RETURNCODE              = RETURNCODE
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  lv_number =  number.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
CLEAR e_fy.
CALL FUNCTION 'GM_GET_FISCAL_YEAR'
    EXPORTING
      i_date                     = SY-DATUM
*     I_FYV                      = 'I_FYV'
      i_fyv                      = 'V3'
    IMPORTING
      e_fy                       = e_fy
    EXCEPTIONS
      fiscal_year_does_not_exist = 1
      not_defined_for_date       = 2
      OTHERS                     = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*
IF LV_GJAHR NE E_FY.
  MESSAGE |This invoice belongs to another fiscal year| TYPE 'E'.
ENDIF.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  wa_final-znumber_01   = lv_number.
  zgate_out-znumber_01  = lv_number.
  wa_final-znumber_01   = zgate_out-znumber_01.

  zgate_out-zcreted_by = sy-uname.
  MODIFY zgate_out FROM zgate_out .
  COMMIT WORK AND WAIT.
  CLEAR  zgate_out.

*  zgate_out-zv_date    = sy-datum.


  IF sy-subrc = 0.
    MESSAGE ' Gateout Entry Save Sucessfully : ' && wa_final-znumber_01   TYPE 'I' DISPLAY LIKE 'S' .
  ENDIF.
  CLEAR : it_data,flag,lv_gross,lv_base,lv_sum,sum_mwsbp,lv_oth,wa_gate.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_entry .

  IF  r_disply IS NOT INITIAL.
    DATA lv_longtxt TYPE char250.
    TYPES : BEGIN OF ty_new,
              zv_date        TYPE  zgate_out-zv_date,
              zveh_num       TYPE  zgate_out-zveh_num,
              zout_time      TYPE  zgate_out-zout_time,
              zout_date      TYPE  zgate_out-zout_date,
              zser_no        TYPE  zgate_out-zser_no,
              zv_driver_name TYPE  zgate_out-zv_driver_name,
              ztrans_name    TYPE  zgate_out-ztrans_name,
              zinvoice_no    TYPE  zgate_out-zinvoice_no,
              zcreted_by     TYPE  zgate_out-zcreted_by,
              zv_remark      TYPE  zgate_out-zv_remark,
              znumber_01     TYPE  zgate_out-znumber_01,
              zsec_name      TYPE  zgate_out-zsec_name,
              zchange_remark TYPE  zgate_out-zchange_remark,
              zdelete_ind    TYPE  zgate_out-zdelete_ind,
              zrefe_no       TYPE  zgate_out-zrefe_no,
              zchang_name    TYPE  zgate_out-zchang_name,
              zchang_date    TYPE  zgate_out-zchang_date,
              zchang_time    TYPE  zgate_out-zchang_time,
              zdelete_name   TYPE  zgate_out-zdelete_name,
              zdelete_date   TYPE  zgate_out-zdelete_date,
              zdelete_time   TYPE  zgate_out-zdelete_time,
              fkimg          TYPE  vbrp-fkimg,
              matnr          TYPE  vbrp-matnr,
*             Arktx          TYPE  vbrp-arktx,
              desc           TYPE  char250,
              posnr          TYPE  vbrp-posnr,
              kunag          TYPE  vbrk-kunag,
              fkdat          TYPE  vbrk-fkdat,
              xblnr          TYPE  vbrk-xblnr,
              zfstorage_loc TYPE  zgate_out-zfstorage_loc,  "a~zfstorage_loc,a~ztstorage_loc
              ztstorage_loc  type  zgate_out-ztstorage_loc,
            END OF ty_new.

    DATA : it_new TYPE STANDARD TABLE OF ty_new,
           wa_new TYPE  ty_new.

    SELECT znumber_01,
           zv_date,
           zinvoice_no,
      MAX( zser_no ) AS zser_no
      FROM zgate_out
      WHERE zv_date     IN @p_date
      GROUP BY znumber_01 ,zv_date,zinvoice_no
      INTO TABLE @DATA(it_max).

    IF it_max IS INITIAL .

      MESSAGE |Data Not Found | TYPE 'E'.

    ENDIF.

*    SELECT FROM zgate_out AS a  INNER JOIN vbrp AS b    ""Comented by pranit 15.04.2024
*                ON a~zinvoice_no EQ b~vbeln
*              INNER JOIN vbrk AS c
*                ON b~vbeln EQ c~vbeln
*      FIELDS a~zv_date,a~zveh_num,a~zout_time,a~zser_no , a~zv_driver_name,a~ztrans_name,a~zinvoice_no,a~zcreted_by,a~zv_remark,a~znumber_01, a~zsec_name,
*      a~zchange_remark,zdelete_ind,a~zchang_name,a~zchang_date,a~zchang_time,
*             b~fkimg,b~matnr,b~arktx,b~posnr,
*             c~kunag,c~fkdat,c~xblnr
*      FOR ALL ENTRIES IN @it_max
*      WHERE a~znumber_01 = @it_max-znumber_01
*      AND a~zv_date      = @it_max-zv_date
*      AND a~zinvoice_no  = @it_max-zinvoice_no
*      AND a~zser_no      = @it_max-zser_no
*      INTO TABLE @DATA(it_new_n).

        SELECT FROM zgate_out AS a  INNER JOIN vbrp AS b
                ON a~zinvoice_no EQ b~vbeln

              INNER JOIN vbrk AS c
                ON b~vbeln EQ c~vbeln
      FIELDS a~zv_date,a~zveh_num,a~zout_time,a~zser_no , a~zv_driver_name,a~ztrans_name,a~zinvoice_no,a~zcreted_by,a~zv_remark,a~znumber_01, a~zsec_name,a~zrefe_no,
      a~zchange_remark,zdelete_ind,a~zchang_name,a~zchang_date,a~zchang_time, a~zfstorage_loc,a~ztstorage_loc ,
             b~fkimg,b~matnr,b~arktx,b~posnr,
             c~kunag,c~fkdat  ",c~xblnr
      FOR ALL ENTRIES IN @it_max
      WHERE a~znumber_01 = @it_max-znumber_01
      AND a~zv_date      = @it_max-zv_date
      AND a~zinvoice_no  = @it_max-zinvoice_no
      AND a~zser_no      = @it_max-zser_no
      INTO TABLE @DATA(it_new_n).

    SELECT znumber_01,
           zdelete_name,
           zdelete_date,
           zdelete_time FROM zgate_out
           INTO TABLE @DATA(it_out)
           FOR ALL ENTRIES IN @it_new_n
           WHERE znumber_01 = @it_new_n-znumber_01
           AND zser_no EQ ''.
  sort it_new_n.
 DELETE ADJACENT DUPLICATES FROM it_new_n COMPARING ALL FIELDS .

    LOOP AT it_new_n INTO DATA(wa_new_n) .

      wa_new-zv_date        = wa_new_n-zv_date.
      wa_new-zveh_num       = wa_new_n-zveh_num.
      wa_new-zv_driver_name = wa_new_n-zv_driver_name.
      wa_new-ztrans_name    = wa_new_n-ztrans_name.
      wa_new-zinvoice_no    = wa_new_n-zinvoice_no.
      wa_new-posnr          = wa_new_n-posnr.
      wa_new-fkimg          = wa_new_n-fkimg.
      wa_new-matnr          = wa_new_n-matnr.

      CLEAR: lv_lines, lv_name,wa_lines,lv_longtxt.
      REFRESH lv_lines.
      lv_name = wa_new_n-matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = 'E'
          name                    = lv_name
          object                  = 'MATERIAL'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE lv_longtxt wa_lines-tdline INTO lv_longtxt SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE lv_longtxt.
      ENDIF.

      wa_new-desc =  lv_longtxt.
      """""""""""""""""""""""
      wa_new-zcreted_by     = wa_new_n-zcreted_by.
      wa_new-zv_remark      = wa_new_n-zv_remark.
      wa_new-znumber_01     = wa_new_n-znumber_01.
      wa_new-fkdat          = wa_new_n-fkdat.
      wa_new-kunag          = wa_new_n-kunag.
      wa_new-zout_time      = wa_new_n-zout_time.
      wa_new-zsec_name      = wa_new_n-zsec_name.
      wa_new-zchange_remark = wa_new_n-zchange_remark.
      wa_new-zchang_name    = wa_new_n-zchang_name.
      wa_new-zchang_date    = wa_new_n-zchang_date.
      wa_new-zchang_time    = wa_new_n-zchang_time.
      wa_new-zfstorage_loc = wa_new_n-zfstorage_loc.
      wa_new-ztstorage_loc = wa_new_n-ztstorage_loc.
      READ TABLE it_out INTO DATA(wa_out) WITH KEY znumber_01 = wa_new_n-znumber_01.
      IF sy-subrc IS INITIAL.
        wa_new-zdelete_name    = wa_out-zdelete_name.
        wa_new-zdelete_date    = wa_out-zdelete_date.
        wa_new-zdelete_time    = wa_out-zdelete_time.
      ENDIF.

      wa_new-zdelete_ind    = wa_new_n-zdelete_ind.
*      wa_new-zrefe_no       = wa_new_n-xblnr.   ""Comented by pranit 15.04.2024
      wa_new-zrefe_no       = wa_new_n-zrefe_no.  ""add by pranit 15.04.2024


      APPEND wa_new TO it_new.
      CLEAR : wa_new.
    ENDLOOP.

    PERFORM fct.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        is_layout          = fs_layout
        it_fieldcat        = gt_fieldcat[]
      TABLES
        t_outtab           = it_new.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

  IF p_down EQ 'X'.

    LOOP AT it_new INTO wa_new.

      wa_down-znumber_01       = wa_new-znumber_01     .
      wa_down-zv_date        =   wa_new-zv_date    .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_new-zv_date
        IMPORTING
          output = wa_down-zv_date.

      CONCATENATE wa_down-zv_date+0(2) wa_down-zv_date+2(3) wa_down-zv_date+5(4)
                      INTO wa_down-zv_date SEPARATED BY '-'.
      wa_down-zinvoice_no    =   wa_new-zinvoice_no    .
      wa_down-fkdat            = wa_new-fkdat          .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_new-fkdat
        IMPORTING
          output = wa_down-fkdat.
      CONCATENATE wa_down-fkdat+0(2) wa_down-fkdat+2(3) wa_down-fkdat+5(4)
                      INTO wa_down-fkdat SEPARATED BY '-'.

      wa_down-kunag           =  wa_new-kunag          .
      wa_down-posnr           =  wa_new-posnr          .
      wa_down-matnr           =  wa_new-matnr          .
      wa_down-arktx           =  wa_new-desc           .
      wa_down-fkimg           =  wa_new-fkimg          .
      wa_down-zveh_num        =  wa_new-zveh_num       .
      wa_down-zv_driver_name  =  wa_new-zv_driver_name .
      wa_down-ztrans_name     =  wa_new-ztrans_name    .
      wa_down-zout_time       =  wa_new-zout_time      .
      wa_down-zcreted_by      =  wa_new-zcreted_by     .
      wa_down-zsec_name       =  wa_new-zsec_name      .
      wa_down-zv_remark       =  wa_new-zv_remark      .
      wa_down-zchange_remark  =  wa_new-zchange_remark .
      wa_down-zchang_name     =  wa_new-zchang_name    .
      wa_down-zchang_date     =  wa_new-zchang_date    .
      wa_down-ZFSTORAGE_LOC   =  wa_new-ZFSTORAGE_LOC.       " add by supriya
      wa_down-ZTSTORAGE_LOC   =  wa_new-ZTSTORAGE_LOC.       " add by supriya

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_new-zchang_date
        IMPORTING
          output = wa_down-zchang_date.
    IF wa_new-zv_date is  INITIAL.
      CONCATENATE wa_down-zchang_date+0(2) wa_down-zchang_date+2(3) wa_down-zchang_date+5(4)
      INTO wa_down-zchang_date SEPARATED BY '-'.
    ENDIF.
      wa_down-zchang_time     =  wa_new-zchang_time    .

      CONCATENATE wa_down-zchang_time+0(2) ':' wa_down-zchang_time+2(2)  INTO wa_down-zchang_time.

      wa_down-zdelete_ind     =  wa_new-zdelete_ind    .
      wa_down-zdelete_name    =  wa_new-zdelete_name   .
      wa_down-zdelete_date    =  wa_new-zdelete_date   .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_new-zdelete_date
        IMPORTING
          output = wa_down-zdelete_date.
    IF wa_new-zv_date is  INITIAL.
      CONCATENATE wa_down-zdelete_date+0(2) wa_down-zdelete_date+2(3) wa_down-zdelete_date+5(4)
      INTO wa_down-zdelete_date SEPARATED BY '-'.
    ENDIF.
      wa_down-zdelete_time    =  wa_new-zdelete_time   .

      CONCATENATE wa_down-zdelete_time+0(2) ':' wa_down-zdelete_time+2(2)  INTO wa_down-zdelete_time.

      wa_down-zrefe_no        =  wa_new-zrefe_no       .
      wa_down-ref_date        =  sy-datum              .
      wa_down-ref_time        =  sy-uzeit              .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.
      CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
      INTO wa_down-ref_date SEPARATED BY '-'.
      wa_down-ref_time = sy-uzeit.
      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

      APPEND wa_down TO it_down.
    ENDLOOP.

    PERFORM download.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SCREEN_MODIFY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM screen_modify .

  IF r_create = 'X' .

    LOOP AT SCREEN.
      IF screen-group1 = 'DIS'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_data .
  CLEAR : it_data,flag,wa_final,zgate_out,lv_gross,sum_tax,sum_mwsbp,lv_base,lv_oth,lv_sum,wa_vbrk1,lv_ref,lv_xblnr,lv_vbeln,wa_vbrk2,lv_dc,wa_gate.

  zgate_out-zv_date = sy-datum.
*  zgate_out-zcreted_by = sy-uname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fct .

  REFRESH gt_fieldcat.
  PERFORM gt_fieldcatlog USING :

         'ZNUMBER_01'        'IT_NEW'     'Gate Entry No.'                   '1',
         'ZV_DATE'           'IT_NEW'     'Date'                             '2',
         'ZINVOICE_NO'       'IT_NEW'     'Billing Document No.'             '3',
         'zrefe_no'          'IT_NEW'     'Invoice./Challan No.'             '4',
         'FKDAT'             'IT_NEW'     'Invoice./Challan Date'            '5',
         'KUNAG'             'IT_NEW'     'Supplier Name'                    '6',
         'POSNR'             'IT_NEW'     'Line Item'                        '7',
         'MATNR'             'IT_NEW'     'Material Code'                    '8',
         'DESC'              'IT_NEW'     'Material Description'             '9',
         'FKIMG'             'IT_NEW'     'Quantity'                         '10',
         'ZVEH_NUM'          'IT_NEW'     'Vehicle Number'                   '11',
         'ZV_DRIVER_NAME'    'IT_NEW'     'Driver Name'                      '12',
         'ZTRANS_NAME'       'IT_NEW'     'Transporter Name'                 '13',
         'ZOUT_TIME'         'IT_NEW'     'Out Time'                         '14',
         'ZCRETED_BY'        'IT_NEW'     'User Name'                        '15',
         'ZSEC_NAME '        'IT_NEW'     'Security Name'                    '16',
         'ZV_REMARK'         'IT_NEW'     'Remark'                           '17',
         'ZCHANGE_REMARK'    'IT_NEW'     'Change Remark'                    '18',
         'ZCHANG_NAME'       'IT_NEW'     'Change Name'                      '19',
         'ZCHANG_DATE'       'IT_NEW'     'Change Date'                      '20',
         'zchang_time'       'IT_NEW'     'Change Time'                      '21',
         'ZDELETE_NAME'      'IT_NEW'     'Delete Name'                      '22',
         'ZDELETE_DATE'      'IT_NEW'     'Delete Date'                      '23',
         'ZDELETE_TIME'      'IT_NEW'     'Delete Time'                      '24',
         'zdelete_ind'       'IT_NEW'     'Deletion Remark'                  '25',
         'ZFSTORAGE_LOC'     'IT_NEW'     'From Storage location'            '25', "added by supriya on 08.07.2024
         'ZTSTORAGE_LOC'    'IT_NEW'      'TO Storage location '             '25'. "added by supriya on 08.07.2024

  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra = 'X'.

  IF p_down = 'X'.
    r_create = '' .
    r_disply = ''.

    PERFORM download.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GT_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ENDFORM  text
*----------------------------------------------------------------------*
FORM gt_fieldcatlog  USING    v1 v2 v3 v4.

  gs_fieldcat-fieldname   = v1.
  gs_fieldcat-tabname     = v2.
  gs_fieldcat-seltext_l   = v3.
  gs_fieldcat-col_pos     = v4.
* gt_fieldcat-do_sum     =  v5.
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR  gs_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  ZINVOICE_NO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zinvoice_no INPUT.

  SELECT SINGLE vbeln,
         werks
    FROM vbrp
    INTO @DATA(wa_vbrp)
    WHERE vbeln = @zgate_out-zinvoice_no.
****************************************************
*  SELECT VBELN,
*         POSNR,
*         VGBEL
*    FROM VBRP
*    INTO TABLE @DATA(IT_VBRP)
*    WHERE VBELN = @ZGATE_OUT-ZINVOICE_NO.


***************************************************



****************************************************
  IF  wa_vbrp-werks NE 'PL01'.

    MESSAGE 'Invoice Belongs to Plant : '  && wa_vbrp-werks TYPE 'E'.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZVEH_NUM  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zveh_num INPUT.

  DATA  lv_qr TYPE char50.

  DATA(lv_str) = strlen( lv_qr ).

  DATA(lv_count) = strlen( zgate_out-zveh_num ).

  IF lv_count LT 10.
    MESSAGE |Vehicle number is less than 10 characterstics.| TYPE 'E'.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

  lv_file = 'ZGATEOUT.TXT'.

  CONCATENATE p_folder '/'  lv_file
    INTO lv_fullfile.

  WRITE: / 'ZGATEOUT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CLOSE DATASET lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE 'Gate Entry No.'
              'Date'
              'Billing Document No.'
              'Invoice./Challan No.'
              'Invoice./Challan Date'
              'Supplier Name'
              'Line Item'
              'Material Code'
              'Material Description'
              'Quantity'
              'Vehicle Number'
              'Driver Name'
              'Transporter Name'
              'Out Time'
              'User Name'
              'Security Name'
              'Remark'
              'Change Remark'
              'Change Name'
              'Change Date'
              'Change Time'
              'Deletion Remark'
              'Delete Name'
              'Delete Date'
              'Delete Time'
              'Refreshable Date'
              'Refreshable Time'
              'From Storage location' " add by supriya
              'TO Storage location'   "add by supriya

       INTO pd_csv SEPARATED BY l_field_seperator.
ENDFORM.
