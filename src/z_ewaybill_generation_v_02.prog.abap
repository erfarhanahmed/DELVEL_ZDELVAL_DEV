*&---------------------------------------------------------------------*
*& Report Z_EWAYBILL_GENERATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ewaybill_generation_v_02.

INCLUDE z_ewaybill_generation_top_v02.
*INCLUDE z_ewaybill_generation_top.

TABLES : vbrk,vbrp,bkpf,bseg.

TYPES : BEGIN OF ty_res_tokan,
          header TYPE string,
          value  TYPE string,
        END OF ty_res_tokan.

DATA :lt_res_tokan TYPE STANDARD TABLE OF ty_res_tokan,
      ls_res_tokan TYPE ty_res_tokan.

DATA:lt_ein_tokan TYPE STANDARD TABLE OF ty_res_tokan,
     ls_ein_tokan TYPE ty_res_tokan.



SELECTION-SCREEN : BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
  PARAMETERS: b1 RADIOBUTTON GROUP s USER-COMMAND sel DEFAULT 'X',
              b2 RADIOBUTTON GROUP s,
              b3 RADIOBUTTON GROUP s..
SELECTION-SCREEN : END OF BLOCK b3.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS     : p_bukrs TYPE vbrk-bukrs MODIF ID gr1.
  SELECT-OPTIONS : s_vkorg FOR  vbrk-vkorg MODIF ID gr1,
                   s_fkdat FOR  vbrk-fkdat MODIF ID gr1,
                   s_werks FOR  vbrp-werks NO INTERVALS MODIF ID gr1,
                   s_vbeln FOR  vbrk-vbeln MODIF ID gr1,

                   s_bukrs FOR  bkpf-bukrs MODIF ID gr2,
                   s_gjahr FOR  bkpf-gjahr MODIF ID gr2,
                   s_bupla FOR  bseg-bupla MODIF ID gr2,
                   s_prctr FOR  bseg-prctr MODIF ID gr2,
                   s_belnr FOR  bkpf-belnr MODIF ID gr2,
                   s_budat FOR  bkpf-budat MODIF ID gr2.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: a1 RADIOBUTTON GROUP r MODIF ID gr1, " USER-COMMAND SEL,
              a2 RADIOBUTTON GROUP r MODIF ID gr1,
              a3 RADIOBUTTON GROUP r MODIF ID gr1.
SELECTION-SCREEN : END OF BLOCK b2.

AT SELECTION-SCREEN OUTPUT.
  IF b1 = 'X' OR b3 = 'X'.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'GR1'.
          screen-input = 1.
          screen-invisible = 0.
          MODIFY SCREEN.
        WHEN 'GR2'.
          screen-input = 0.
          screen-invisible = 1.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'GR1'.
          screen-input = 0.
          screen-invisible = 1.
          MODIFY SCREEN.
        WHEN 'GR2'.
          screen-input = 1.
          screen-invisible = 0.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.

  ENDIF.

AT SELECTION-SCREEN ON s_werks.

*  IF sy-ucomm = 'ONLI'.
*    LOOP AT s_werks INTO DATA(ls_werks).
*      AUTHORITY-CHECK OBJECT 'ZCOCKPIT'
*           ID 'WERKS' FIELD ls_werks-low.
*      IF sy-subrc <> 0.
*        CONCATENATE 'You have no Authorization for Plant' ls_werks-low INTO DATA(MSG) SEPARATED BY space.
*        MESSAGE msg TYPE 'E'.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.

AT SELECTION-SCREEN.
  IF sy-ucomm = 'ONLI'.
    IF b1 = 'X' OR b3 = 'X'.
      IF p_bukrs IS INITIAL.
        MESSAGE 'Please enter Company Code' TYPE 'E'.
      ELSEIF s_vkorg-low IS INITIAL.
        MESSAGE 'Please enter Sales Organisation' TYPE 'E'.
      ELSEIF s_fkdat-low IS INITIAL.
        MESSAGE 'Please enter Billing Date' TYPE 'E'.
      ELSEIF s_werks-low IS INITIAL.
        MESSAGE 'Please enter Plant' TYPE 'E'.
      ENDIF.
    ELSE.
      IF s_bukrs-low IS INITIAL.
        MESSAGE 'Please enter Company Code' TYPE 'E'.
      ELSEIF s_gjahr-low IS INITIAL.
        MESSAGE 'Please enter Fiscal Year' TYPE 'E'.
      ELSEIF s_bupla-low IS INITIAL.
        MESSAGE 'Please enter Business Place' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.




*----------------------------------------------------------------------*
*       CLASS lcl_events IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_events IMPLEMENTATION.
  METHOD handle_double_click.
    row = e_row.
    col = e_column.
*    DATA : wa LIKE LINE OF it_final.
  ENDMETHOD.
  "handle_double_click
  METHOD handle_f4.

  ENDMETHOD.

  METHOD handle_hot_spot.

    CASE e_column_id .
      WHEN 'VBELN'.
        READ TABLE lt_final ASSIGNING FIELD-SYMBOL(<lfs_read>) INDEX e_row_id.
        IF sy-subrc EQ 0.
          SET PARAMETER ID 'VF' FIELD <lfs_read>-vbeln.
          CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.


    DATA lw_lvc_s_stbl TYPE lvc_s_stbl.

    lw_lvc_s_stbl-row  =  'X'   .
    lw_lvc_s_stbl-col  =  'X'.

    CALL METHOD c_alvgd->refresh_table_display
      EXPORTING
        is_stable      = lw_lvc_s_stbl
        i_soft_refresh = 'X'
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    CLEAR :e_row_id,  "Type	LVC_S_ROW
    e_column_id,      "Type LVC_S_COL
    es_row_no .       "Type  LVC_S_ROID



  ENDMETHOD.

  METHOD handle_toolbar.

  ENDMETHOD.


ENDCLASS.                    "lcl_events IMPLEMENTATION

START-OF-SELECTION.
  IF b1 = 'X'.
    PERFORM get_data.
  ELSEIF b2 = 'X'.
    PERFORM get_data_prr.
  ELSEIF b3 = 'X'.
    PERFORM get_data_sale_ret.
  ENDIF.
  IF lt_final IS NOT INITIAL.
    CALL SCREEN 100.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*  BREAK primus.
  gv_vkorg = s_vkorg-low.
  IF s_fkdat-high IS INITIAL.
    CONCATENATE s_fkdat-low+6(2) s_fkdat-low+4(2) s_fkdat-low+0(4) INTO gv_date SEPARATED BY '/'.
  ELSE.
    CONCATENATE s_fkdat-low+6(2) '.' s_fkdat-low+4(2) '.' s_fkdat-low+0(4)
                '-' s_fkdat-high+6(2) '.'  s_fkdat-high+4(2) '.' s_fkdat-high+0(4)
                INTO gv_date.
  ENDIF.
  SELECT vbeln  fkart waerk vkorg
         kalsm knumv fkdat kurrf
         bukrs taxk6 netwr mwsbk kunag sfakn
         xblnr bupla land1
         FROM  vbrk
         INTO TABLE lt_vbrk_j
         WHERE  vbeln IN s_vbeln
         AND  vkorg IN s_vkorg
         AND  fkdat IN s_fkdat
  AND  bukrs = p_bukrs.
*         AND  fkart NE 'ZRE'.

  IF lt_vbrk_j IS NOT INITIAL.

    SELECT vbeln posnr  matnr arktx
           fkimg netwr meins aubel
           kursk werks vrkme
           FROM vbrp
           INTO TABLE lt_vbrp
           FOR ALL ENTRIES IN lt_vbrk_j
           WHERE vbeln = lt_vbrk_j-vbeln
    AND werks IN s_werks.

    SELECT bukrs,branch,gstin
           FROM j_1bbranch
           INTO TABLE @DATA(lt_j_1bbranch)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND branch = @lt_vbrk_j-bupla.

    SELECT *
           FROM zeway_number
           INTO TABLE @DATA(lt_zeway_number)
           FOR ALL ENTRIES IN @lt_vbrk_j
    WHERE vbeln = @lt_vbrk_j-vbeln.

    SORT lt_zeway_number BY vbeln.

    SELECT * FROM zewayextend
            INTO TABLE @DATA(lt_extend)
            FOR ALL ENTRIES IN @lt_zeway_number
    WHERE eway_bill = @lt_zeway_number-eway_bill.

    SORT lt_extend BY version DESCENDING.

    SELECT *
           FROM zeway_bill
           INTO TABLE @DATA(lt_ewaybill)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND vbeln = @lt_vbrk_j-vbeln.

    SELECT *
           FROM j_1ig_ewaybill
           INTO TABLE @DATA(lt_j_1ig_ewaybill)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND docno = @lt_vbrk_j-vbeln.

    SORT lt_j_1ig_ewaybill BY docno.

    SELECT bukrs,docno,irn
           FROM j_1ig_invrefnum
           INTO TABLE @DATA(lt_j_1ig_invrefnum)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND docno = @lt_vbrk_j-vbeln.
    SORT lt_j_1ig_invrefnum BY docno.

    SELECT kunnr
        name1
        locco
        stcd3
        ort01
        pstlz
        land1
        regio
        bahne
        adrnr
        werks
        FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbrk_j
    WHERE kunnr EQ lt_vbrk_j-kunag.
  ENDIF.



  LOOP AT lt_vbrk_j INTO ls_vbrk_j.

    IF a1 = 'X'.
      IF ls_vbrk_j-fkart NE 'ZSTM' AND ls_vbrk_j-fkart NE 'ZSN'.
        CONTINUE.
        CLEAR : ls_final.
      ENDIF.
    ENDIF.
    ls_final-bukrs                = ls_vbrk_j-bukrs.
    ls_final-vbeln                = ls_vbrk_j-vbeln.
    ls_final-fkart                = ls_vbrk_j-fkart.
    ls_final-fkdat                = ls_vbrk_j-fkdat.
    ls_final-cancel_doc           = ls_vbrk_j-sfakn.
    ls_final-bupla                = ls_vbrk_j-bupla.

    READ TABLE lt_vbrp INTO wa_vbrp WITH KEY vbeln = ls_vbrk_j-vbeln.
    IF sy-subrc = 0.
      ls_final-werks                = wa_vbrp-werks.
      CLEAR wa_vbrp.
    ELSE.
      CONTINUE.
      CLEAR : ls_final.
    ENDIF.

    READ TABLE lt_j_1bbranch ASSIGNING FIELD-SYMBOL(<lfs_branch>) WITH KEY bukrs = ls_vbrk_j-bukrs branch = ls_vbrk_j-bupla.
    IF sy-subrc EQ 0.
      ls_final-stcd3              = <lfs_branch>-gstin.
    ENDIF.

    READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag.
    IF sy-subrc EQ 0.
      ls_final-to_gstin              = wa_kna1-stcd3.
    ENDIF.

    IF a2 = 'X'.
      IF ls_final-to_gstin NE 'URD'.
        CONTINUE.
        CLEAR : ls_final.
      ENDIF.
    ENDIF.

    ls_final-process_status = TEXT-007. "'@5D\Q Not Processed@'.
    ls_final-status_description = TEXT-008."'Not Processed'.

    READ TABLE lt_zeway_number INTO DATA(ls_zeway_number) WITH KEY vbeln = ls_vbrk_j-vbeln  BINARY SEARCH.
    IF sy-subrc = 0.
      ls_final-eway_bil         = ls_zeway_number-eway_bill.
      ls_final-conway_bil       = ls_zeway_number-conewayno.
      ls_final-eway_dt          = ls_zeway_number-ewaybilldate.
      ls_final-vdfmtime         = ls_zeway_number-vdfmtime.
      ls_final-eway_dt_exp      = ls_zeway_number-validuptodate.
      ls_final-vdtotime         = ls_zeway_number-vdtotime.
      ls_final-message          = ls_zeway_number-message.
      ls_final-created_by       = ls_zeway_number-createdby.
      ls_final-created_dt       = ls_zeway_number-creationdt.
      ls_final-created_time     = ls_zeway_number-creationtime.

      CASE ls_zeway_number-canreason.
        WHEN 1.
          ls_final-canreason        = 'Duplicate'.
        WHEN 2.
          ls_final-canreason        = 'Order Cancelled'.
        WHEN 3.
          ls_final-canreason        = 'Data Entry mistake'.
        WHEN 4.
          ls_final-canreason        = 'Others'.
      ENDCASE.

      ls_final-canceldt         = ls_zeway_number-canceldt    .
      ls_final-cancelremark     = ls_zeway_number-cancelremark.


      CASE ls_zeway_number-zzstatus.
        WHEN 'C'.
          ls_final-process_status = TEXT-003. "'@08\Q Completly Processed@'.
          ls_final-status_description = TEXT-004. "'Completly Processed'.
        WHEN 'E'.
          ls_final-process_status = TEXT-009. "'@0A\Q Error!@'.
          ls_final-status_description = TEXT-010. "'Error'.
        WHEN 'U'.
          ls_final-process_status = TEXT-011. "'@3J\Q Under Process@'.
          ls_final-status_description = TEXT-011. "'Under Process'.
        WHEN 'S'.
          ls_final-process_status = TEXT-005. "'@F9\Q Eway Bill Cancelled@'.
          ls_final-status_description = TEXT-006. "'Eway Bill Cancelled'.
        WHEN OTHERS.
          ls_final-process_status = TEXT-007. "'@5D\Q Not Processed@'.
          ls_final-status_description = TEXT-008. "'Not Processed'.
      ENDCASE.


      READ TABLE lt_ewaybill INTO DATA(ls_ewaybill) WITH KEY bukrs = ls_vbrk_j-bukrs vbeln = ls_vbrk_j-vbeln.
      IF sy-subrc = 0.
        ls_final-veh_no = ls_ewaybill-vehical_no.
      ENDIF.

      READ TABLE lt_extend INTO DATA(ls_extend) WITH KEY eway_bill = ls_final-eway_bil.
      IF sy-subrc = 0.
        ls_final-eway_dt_exp      = ls_extend-validuptodate.
        ls_final-vdtotime         = ls_extend-validuptotime.
      ENDIF.
    ELSE.

      READ TABLE lt_j_1ig_ewaybill INTO DATA(ls_j_1ig_ewaybill) WITH KEY docno = ls_vbrk_j-vbeln BINARY SEARCH.
      IF sy-subrc = 0.
        ls_final-eway_bil         = ls_j_1ig_ewaybill-ebillno.
        ls_final-eway_dt          = ls_j_1ig_ewaybill-vdfmdate.
        ls_final-vdfmtime         = ls_j_1ig_ewaybill-vdfmtime.
        ls_final-eway_dt_exp      = ls_j_1ig_ewaybill-vdtodate.
        ls_final-vdtotime         = ls_j_1ig_ewaybill-vdtotime.

        CASE ls_j_1ig_ewaybill-status.
          WHEN 'A' OR 'E' OR 'P'.
            ls_final-process_status = TEXT-003 . "'@08\Q Completly Processed@'.
            ls_final-status_description = TEXT-004. "'Completly Processed'.
          WHEN 'C'.
            ls_final-process_status = TEXT-005. "'@F9\Q Eway Bill Cancelled@'.
            ls_final-status_description = TEXT-006. "'Eway Bill Cancelled'.
          WHEN OTHERS.
            ls_final-process_status = TEXT-007. "'@5D\Q Not Processed@'.
            ls_final-status_description = TEXT-008. "'Not Processed'.
        ENDCASE.

      ENDIF.
    ENDIF.

    READ TABLE lt_j_1ig_invrefnum INTO DATA(ls_j_1ig_invrefnum) WITH KEY bukrs = ls_vbrk_j-bukrs docno = ls_vbrk_j-vbeln BINARY SEARCH.
    IF sy-subrc = 0.
      ls_final-irn_no = ls_j_1ig_invrefnum-irn.
    ENDIF.

    ls_final-vkorg                = ls_vbrk_j-vkorg.

    APPEND ls_final TO lt_final.
    CLEAR : ls_final , ls_zeway_number.
  ENDLOOP.

  SORT lt_final BY vbeln.

  CREATE OBJECT g_app.
  IF c_ccont IS INITIAL.
    CREATE OBJECT c_ccont
      EXPORTING
        container_name = 'CCONT'.   "--Custom Container Object for Materials Display.

    CREATE OBJECT c_alvgd
      EXPORTING
        i_parent = c_ccont.
  ENDIF.

  SET HANDLER g_app->handle_double_click FOR c_alvgd.
  SET HANDLER g_app->handle_hot_spot FOR c_alvgd.
  SET HANDLER g_app->handle_toolbar FOR c_alvgd.
*  SET HANDLER g_app->

  PERFORM alv_build_fieldcat.
  PERFORM alv_report_layout.

  CHECK NOT c_alvgd IS INITIAL.


  ls_exclude = cl_gui_alv_grid=>mc_fc_excl_all .

  APPEND ls_exclude TO pt_exclude.


  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
      is_layout                     = it_layout
      i_save                        = 'A'
      it_toolbar_excluding          = pt_exclude
    CHANGING
      it_outtab                     = lt_final[]
      it_fieldcatalog               = it_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_PRR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_prr .
  REFRESH lt_awkey.

  SELECT belnr gjahr buzei ebeln 	ebelp	werks	matnr
         hsn_sac  menge meins wrbtr kschl xekbz lfbnr
         bukrs  xblnr mwskz FROM rseg INTO TABLE lt_rseg
         WHERE bukrs IN s_bukrs
         AND belnr IN s_belnr
*         AND werks IN s_werks
         AND gjahr IN s_gjahr
*         AND matnr IN s_matnr
  AND shkzg = 'H'.

  LOOP AT lt_rseg INTO ls_rseg.
    CONCATENATE ls_rseg-belnr ls_rseg-gjahr INTO ls_awkey.
    APPEND ls_awkey TO lt_awkey.
    CLEAR : ls_awkey.
  ENDLOOP.

  IF lt_awkey IS NOT INITIAL.
    SELECT  bukrs
            belnr
            gjahr
            bldat
            budat
            xblnr
            xblnr_alt
            blart
            stblg
            tcode
            cpudt
            cputm
            usnam
            awkey
     FROM bkpf
     INTO TABLE lt_bkpf
     FOR ALL ENTRIES IN lt_awkey
     WHERE awkey = lt_awkey-lv_awkey
     AND gjahr IN s_gjahr
     AND budat IN s_budat
    AND blart = 'KG'.
  ENDIF.


  IF lt_rseg IS NOT INITIAL.


    SELECT *
           FROM zeway_res_122
           INTO TABLE lt_zeway_res_122
           FOR ALL ENTRIES IN lt_rseg
    WHERE belnr = lt_rseg-belnr.

    SELECT  mblnr
            mjahr
         lfbnr
         ebeln
         ebelp
         bwart
        "added
        budat_mkpf
        menge
   FROM mseg INTO TABLE lt_mseg1
   FOR ALL ENTRIES IN lt_rseg
   WHERE lfbnr = lt_rseg-lfbnr
   AND ebeln = lt_rseg-ebeln
   AND ebelp = lt_rseg-ebelp
   AND bwart IN ( 122, 161 ).
*    AND budat_mkpf IN s_budat.


    DELETE ADJACENT DUPLICATES FROM lt_mseg1 COMPARING mblnr.

    IF lt_mseg1[] IS NOT INITIAL.

*  ***    SELECT *
*  ***      FROM zodn_122 INTO TABLE lt_data_122
*  ***      FOR ALL ENTRIES IN lt_mseg1
*  ***      WHERE mblnr = lt_mseg1-mblnr
*  ***      AND mjahr = lt_mseg1-mjahr.
*  ***
*  ***
*  ***    IF lt_data_122[] is NOT INITIAL.

****        SELECT * "mblnr,mjahr,xblnr,zzirn_no,zzack_no,zzack_date,zzerror_disc,zzstatus,zzuser,zzcdate,zztime
****               from  zeway_res_122
****          INTO TABLE lt_zeway_res_122
****          FOR ALL ENTRIES IN lt_mseg1
****          WHERE belnr = lt_mseg1-mblnr AND
****                gjahr = lt_mseg1-mjahr.
*  ***              xblnr = lt_data_122-xblnr.
*
****      ENDIF.
    ENDIF.
  ENDIF.

*  IF lt_zeway_res_122 IS NOT INITIAL.
*
*    SELECT * FROM ZEWAYEXTEND
*            INTO TABLE @DATA(lt_extend1)
*            FOR ALL ENTRIES IN lt_zeway_res_122
*            WHERE EWAY_BILL = lt_zeway_res_122-EWAY_BILL.
*
*
*    SORT lt_extend1 BY VERSION DESCENDING.
*  ENDIF.
  IF lt_bkpf IS NOT INITIAL.

    SELECT bukrs
           belnr
           gjahr
           lifnr
           txgrp
           sgtxt
           gvtyp
           dmbtr
           mwskz
           hkont
           kostl
           bupla
           prctr
           kunnr
           koart
      FROM bseg INTO TABLE lt_bseg
      FOR ALL ENTRIES IN lt_bkpf
      WHERE belnr = lt_bkpf-belnr
      AND bukrs = lt_bkpf-bukrs
      AND  gjahr = lt_bkpf-gjahr
      AND bupla IN s_bupla
    AND koart = 'K'.

  ENDIF.

  IF lt_bseg IS NOT INITIAL.
    SELECT lifnr
           name1
      FROM lfa1 INTO TABLE lt_lfa1
      FOR ALL ENTRIES IN lt_bseg
    WHERE lifnr = lt_bseg-lifnr.
  ENDIF.

  IF lt_bkpf IS NOT INITIAL.
****    SELECT * FROM zeinv_res_fb70
****             INTO TABLE lt_zeinv_response
****             FOR ALL ENTRIES IN lt_bkpf
****             WHERE belnr = lt_bkpf-belnr AND
****                   gjahr =  lt_bkpf-gjahr.

    SELECT
      bukrs branch gstin
       FROM j_1bbranch
            INTO TABLE lt_j_1bbranch
            FOR ALL ENTRIES IN lt_bseg
            WHERE bukrs = lt_bseg-bukrs AND
    branch = lt_bseg-bupla.

****    SELECT
****        bukrs
****        docno
****        odn
****        irn
****        ack_no
****        irn_status
****        ernam
****        erdat
****        erzet
****        signed_inv
****        signed_qrcode
****         FROM j_1ig_invrefnum INTO TABLE lt_j_1ig_invrefnum FOR ALL ENTRIES IN
****      lt_bkpf WHERE docno = lt_bkpf-belnr.

  ENDIF.

  SORT lt_bseg BY belnr.
  SORT lt_bkpf BY belnr.
****  SORT lt_j_1ig_invrefnum BY docno.

  FIELD-SYMBOLS : <lfs_bkpf>  TYPE lty_s_bkpf,
                  <lfs_final> TYPE lty_final,
                  <lfs_bseg>  TYPE lty_s_bseg.
****                  <lfs_zeinv_response> TYPE zeinv_res_fb70.

*  DELETE lt_bkpf WHERE stblg IS NOT INITIAL AND tcode <> 'FB70' AND tcode <> 'FB75'.
*
*  LOOP AT lt_rseg INTO ls_rseg.
*      ls_final-belnr = ls_rseg-belnr.
*    READ TABLE lt_awkey INTO ls_awkey WITH KEY  ls_rseg-belnr .
*    IF sy-subrc EQ 0.

  LOOP AT lt_bkpf ASSIGNING <lfs_bkpf> ." WITH KEY awkey = ls_awkey-lv_awkey gjahr = ls_rseg-gjahr..
*    IF sy-subrc EQ 0.

    ls_final2-gjahr = <lfs_bkpf>-gjahr.
    ls_final2-bukrs = <lfs_bkpf>-bukrs.
    ls_final2-blart = <lfs_bkpf>-blart.
    ls_final2-bldat = <lfs_bkpf>-bldat.
    ls_final2-cpudt = <lfs_bkpf>-cpudt.
    ls_final2-cputm = <lfs_bkpf>-cputm.
    ls_final2-usnam = <lfs_bkpf>-usnam.
    ls_final2-budat = <lfs_bkpf>-budat.
    ls_final2-belnr1 = <lfs_bkpf>-belnr.
*      ls_final2-xblnr = <lfs_bkpf>-xblnr.

    ls_final2-cancel_doc = <lfs_bkpf>-stblg.

*    ENDIF.

    READ TABLE lt_rseg INTO ls_rseg WITH KEY belnr =  <lfs_bkpf>-awkey+0(10)."4.
    IF sy-subrc EQ 0.
      ls_final2-belnr = ls_rseg-belnr.
    ENDIF.
    READ TABLE lt_bseg ASSIGNING <lfs_bseg> WITH KEY  belnr = <lfs_bkpf>-belnr
                                                      gjahr = <lfs_bkpf>-gjahr
                                                      bukrs = <lfs_bkpf>-bukrs
                                                     .
    IF sy-subrc EQ 0.
      ls_final2-bupla  = <lfs_bseg>-bupla.
      ls_final2-prctr  = <lfs_bseg>-prctr.
      ls_final2-kunnr  = <lfs_bseg>-lifnr.
    ELSE.
      CLEAR ls_final2.
      CONTINUE.
    ENDIF.

    READ TABLE lt_lfa1 INTO ls_lfa1 WITH KEY lifnr = <lfs_bseg>-lifnr.
    IF sy-subrc = 0.
      ls_final2-name1 = ls_lfa1-name1.
      ls_final2-gstin = ls_lfa1-stcd3.
    ENDIF.

****    READ TABLE lt_j_1bbranch INTO ls_j_1bbranch WITH KEY bukrs = <lfs_bseg>-bukrs branch = <lfs_bseg>-bupla.
****    IF sy-subrc IS INITIAL.
****      ls_final2-gstin  = ls_j_1bbranch-gstin.
****    ENDIF.


    READ TABLE lt_mseg1 INTO ls_mseg1 WITH KEY lfbnr = ls_rseg-lfbnr ebeln = ls_rseg-ebeln . "ebelp = ls_rseg-ebelp."menge = ls_rseg-menge.
    IF ls_mseg1-bwart IS NOT INITIAL.

****      READ TABLE lt_data_122 ASSIGNING FIELD-SYMBOL(<lfs_zodn_122>) WITH KEY mblnr = ls_mseg1-mblnr mjahr = ls_mseg1-mjahr.

****      IF  sy-subrc eq 0.
****       ls_final2-xblnr = <lfs_zodn_122>-xblnr.

      READ TABLE lt_zeway_res_122 ASSIGNING FIELD-SYMBOL(<lfs_122>) WITH KEY belnr = ls_final2-belnr
                                                                             gjahr = ls_final2-gjahr.
****                                                                             xblnr = <lfs_zodn_122>-xblnr.
      IF sy-subrc EQ 0.
****        ls_final2-zzstatus     = <lfs_122>-zzstatus.
        ls_final2-created_by   = <lfs_122>-createdby."zzuser.
        ls_final2-created_dt   = <lfs_122>-creationdt."zzcdate.
        ls_final2-created_time = <lfs_122>-creationtime."zztime.
        ls_final2-eway_bil     = <lfs_122>-eway_bill."zzirn_no.
        ls_final2-conewayno    = <lfs_122>-conewayno.
        ls_final2-ewaybilldate = <lfs_122>-ewaybilldate.
        ls_final2-vdfmtime     = <lfs_122>-vdfmtime.
        ls_final2-validuptodate  = <lfs_122>-validuptodate.
        ls_final2-vdtotime     = <lfs_122>-vdtotime.
        ls_final2-message      = <lfs_122>-message."zzerror_disc.
****        ls_final2-veh_no       = <lfs_122>-vehical_no.
        ls_final2-canreason    = <lfs_122>-canreason.
        ls_final2-canceldt     = <lfs_122>-canceldt .
        ls_final2-cancelremark = <lfs_122>-cancelremark.
****        ls_final2-zzack_no     = <lfs_122>-zzack_no.
****        ls_final2-zzqr_code    = <lfs_122>-zzqr_code.

        IF <lfs_122>-zzstatus EQ 'C'.
          ls_final2-process_status = '@5B\Q Completly Processed@'.
          ls_final2-status_description = 'Completly Processed'.
        ELSEIF <lfs_122>-zzstatus EQ 'E'.
          ls_final2-process_status = '@5C\Q Error!@'.
          ls_final2-status_description = 'Error'.
        ELSEIF <lfs_122>-zzstatus EQ 'U'.
          ls_final2-process_status = '@3J\Q Under Process@'.
          ls_final2-status_description = 'Under Process'.
        ELSEIF <lfs_122>-zzstatus EQ 'S'.
          ls_final2-process_status = '@F9\Q Eway Bill Cancelled@'.
          ls_final2-status_description = 'Eway Bill Cancelled'.
        ENDIF.
      ELSE.
        ls_final2-process_status = '@5D\Q Not Processed@'.
        ls_final2-status_description = 'Not Processed'.
      ENDIF.

      APPEND ls_final2 TO lt_final2.
*    ENDIF.
      CLEAR: ls_final2 , ls_zeinv_response , ls_zeinv_response , ls_j_1bbranch,ls_mseg1,ls_rseg,ls_bkpf,ls_lfa1.
****  ENDIF.
    ENDIF.
  ENDLOOP.

  LOOP AT lt_final2 INTO ls_final2.
    ls_final-bukrs              = ls_final2-bukrs.
    ls_final-selection          = ls_final2-selection.
    ls_final-process_status     = ls_final2-process_status.
    ls_final-status_description = ls_final2-status_description.
    ls_final-vbeln              = ls_final2-belnr.
    ls_final-gjahr              = ls_final2-gjahr.
    ls_final-fkart              = ls_final2-blart.
    ls_final-fkdat              = ls_final2-budat.
    ls_final-bupla              = ls_final2-bupla.
    ls_final-eway_bil           = ls_final2-eway_bil.
    ls_final-conway_bil         = ls_final2-conewayno.
    ls_final-eway_dt            = ls_final2-ewaybilldate.
    ls_final-vdfmtime           = ls_final2-vdfmtime.
    ls_final-eway_dt_exp        = ls_final2-validuptodate.
    ls_final-vdtotime           = ls_final2-vdtotime.
    ls_final-message            = ls_final2-message.
*    ls_final-veh_no             = ls_final2-veh_no.
    ls_final-canreason          = ls_final2-canreason.
    ls_final-canceldt           = ls_final2-canceldt.
    ls_final-werks              = ls_final2-bupla.
****    ls_final-vkorg              = ls_final2-.
    ls_final-created_by         = ls_final2-created_by.
    ls_final-created_dt         = ls_final2-created_dt.
    ls_final-created_time       = ls_final2-created_time.
    ls_final-cancelremark       = ls_final2-cancelremark.
    ls_final-cancel_doc         = ls_final2-cancel_doc.
*    ls_final-stcd3              = ls_final2-.
    ls_final-to_gstin           = ls_final2-gstin.
    ls_final-kunnr              = ls_final2-kunnr.
    ls_final-cust_name          = ls_final2-name1.
    ls_final-belnr1          = ls_final2-belnr1.
    APPEND ls_final TO lt_final.
    CLEAR : ls_final, ls_final2.
  ENDLOOP.

  SORT lt_final BY vbeln.

  CREATE OBJECT g_app.
  IF c_ccont IS INITIAL.
    CREATE OBJECT c_ccont
      EXPORTING
        container_name = 'CCONT'.   "--Custom Container Object for Materials Display.

    CREATE OBJECT c_alvgd
      EXPORTING
        i_parent = c_ccont.
  ENDIF.

  SET HANDLER g_app->handle_double_click FOR c_alvgd.
  SET HANDLER g_app->handle_hot_spot FOR c_alvgd.
  SET HANDLER g_app->handle_toolbar FOR c_alvgd.
*  SET HANDLER g_app->

  PERFORM alv_build_fieldcat.
  PERFORM alv_report_layout.

  CHECK NOT c_alvgd IS INITIAL.


  ls_exclude = cl_gui_alv_grid=>mc_fc_excl_all .

  APPEND ls_exclude TO pt_exclude.


  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
      is_layout                     = it_layout
      i_save                        = 'A'
      it_toolbar_excluding          = pt_exclude
    CHANGING
      it_outtab                     = lt_final[]
      it_fieldcatalog               = it_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  GET_DATA_SALE_RET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_sale_ret .
*BREAK primus.
  gv_vkorg = s_vkorg-low.
  IF s_fkdat-high IS INITIAL.
    CONCATENATE s_fkdat-low+6(2) s_fkdat-low+4(2) s_fkdat-low+0(4) INTO gv_date SEPARATED BY '/'.
  ELSE.
    CONCATENATE s_fkdat-low+6(2) '.' s_fkdat-low+4(2) '.' s_fkdat-low+0(4)
                '-' s_fkdat-high+6(2) '.'  s_fkdat-high+4(2) '.' s_fkdat-high+0(4)
                INTO gv_date.
  ENDIF.
  SELECT vbeln,
    fkart,
    waerk,
    vkorg,
         kalsm, knumv, fkdat, kurrf,
         bukrs, taxk6, netwr, mwsbk, kunag, sfakn,
         xblnr, bupla
         FROM  vbrk
         INTO TABLE @lt_vbrk_j
         WHERE  vbeln IN @s_vbeln
         AND  vkorg IN @s_vkorg
         AND  fkdat IN @s_fkdat
         AND  bukrs = @p_bukrs
         AND  fkart = 'ZRE'.

  IF lt_vbrk_j IS NOT INITIAL.

    SELECT vbeln posnr  matnr arktx
           fkimg netwr meins aubel
           kursk werks vrkme
           FROM vbrp
           INTO TABLE lt_vbrp
           FOR ALL ENTRIES IN lt_vbrk_j
           WHERE vbeln = lt_vbrk_j-vbeln
    AND werks IN s_werks.

    SELECT bukrs,branch,gstin
           FROM j_1bbranch
           INTO TABLE @DATA(lt_j_1bbranch)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND branch = @lt_vbrk_j-bupla.

    SELECT *
           FROM zeway_number
           INTO TABLE @DATA(lt_zeway_number)
           FOR ALL ENTRIES IN @lt_vbrk_j
    WHERE vbeln = @lt_vbrk_j-vbeln.

    SORT lt_zeway_number BY vbeln.

    SELECT * FROM zewayextend
            INTO TABLE @DATA(lt_extend)
            FOR ALL ENTRIES IN @lt_zeway_number
    WHERE eway_bill = @lt_zeway_number-eway_bill.

    SORT lt_extend BY version DESCENDING.

    SELECT *
           FROM zeway_bill
           INTO TABLE @DATA(lt_ewaybill)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND vbeln = @lt_vbrk_j-vbeln.

    SELECT *
           FROM j_1ig_ewaybill
           INTO TABLE @DATA(lt_j_1ig_ewaybill)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND docno = @lt_vbrk_j-vbeln.

    SORT lt_j_1ig_ewaybill BY docno.

    SELECT bukrs,docno,irn
           FROM j_1ig_invrefnum
           INTO TABLE @DATA(lt_j_1ig_invrefnum)
           FOR ALL ENTRIES IN @lt_vbrk_j
           WHERE bukrs = @lt_vbrk_j-bukrs
    AND docno = @lt_vbrk_j-vbeln.
    SORT lt_j_1ig_invrefnum BY docno.

    SELECT kunnr
        name1
        locco
        stcd3
        ort01
        pstlz
        land1
        regio
        bahne
        adrnr
        werks
        FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbrk_j
    WHERE kunnr EQ lt_vbrk_j-kunag.
  ENDIF.



  LOOP AT lt_vbrk_j INTO ls_vbrk_j.

    IF a1 = 'X'.
      IF ls_vbrk_j-fkart NE 'ZSTM' AND ls_vbrk_j-fkart NE 'ZSN'.
        CONTINUE.
        CLEAR : ls_final.
      ENDIF.
    ENDIF.
    ls_final-bukrs                = ls_vbrk_j-bukrs.
    ls_final-vbeln                = ls_vbrk_j-vbeln.
    ls_final-fkart                = ls_vbrk_j-fkart.
    ls_final-fkdat                = ls_vbrk_j-fkdat.
    ls_final-cancel_doc           = ls_vbrk_j-sfakn.
    ls_final-bupla                = ls_vbrk_j-bupla.

    READ TABLE lt_vbrp INTO wa_vbrp WITH KEY vbeln = ls_vbrk_j-vbeln.
    IF sy-subrc = 0.
      ls_final-werks                = wa_vbrp-werks.
      CLEAR wa_vbrp.
    ELSE.
      CONTINUE.
      CLEAR : ls_final.
    ENDIF.

    READ TABLE lt_j_1bbranch ASSIGNING FIELD-SYMBOL(<lfs_branch>) WITH KEY bukrs = ls_vbrk_j-bukrs branch = ls_vbrk_j-bupla.
    IF sy-subrc EQ 0.
      ls_final-stcd3              = <lfs_branch>-gstin.
    ENDIF.

    READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag.
    IF sy-subrc EQ 0.
      ls_final-to_gstin              = wa_kna1-stcd3.
    ENDIF.

    IF a2 = 'X'.
      IF ls_final-to_gstin NE 'URD'.
        CONTINUE.
        CLEAR : ls_final.
      ENDIF.
    ENDIF.

    ls_final-process_status = TEXT-007. "'@5D\Q Not Processed@'.
    ls_final-status_description = TEXT-008."'Not Processed'.

    READ TABLE lt_zeway_number INTO DATA(ls_zeway_number) WITH KEY vbeln = ls_vbrk_j-vbeln  BINARY SEARCH.
    IF sy-subrc = 0.
      ls_final-eway_bil         = ls_zeway_number-eway_bill.
      ls_final-conway_bil       = ls_zeway_number-conewayno.
      ls_final-eway_dt          = ls_zeway_number-ewaybilldate.
      ls_final-vdfmtime         = ls_zeway_number-vdfmtime.
      ls_final-eway_dt_exp      = ls_zeway_number-validuptodate.
      ls_final-vdtotime         = ls_zeway_number-vdtotime.
      ls_final-message          = ls_zeway_number-message.
      ls_final-created_by       = ls_zeway_number-createdby.
      ls_final-created_dt       = ls_zeway_number-creationdt.
      ls_final-created_time     = ls_zeway_number-creationtime.

      CASE ls_zeway_number-canreason.
        WHEN 1.
          ls_final-canreason        = 'Duplicate'.
        WHEN 2.
          ls_final-canreason        = 'Order Cancelled'.
        WHEN 3.
          ls_final-canreason        = 'Data Entry mistake'.
        WHEN 4.
          ls_final-canreason        = 'Others'.
      ENDCASE.

      ls_final-canceldt         = ls_zeway_number-canceldt    .
      ls_final-cancelremark     = ls_zeway_number-cancelremark.


      CASE ls_zeway_number-zzstatus.
        WHEN 'C'.
          ls_final-process_status = TEXT-003. "'@08\Q Completly Processed@'.
          ls_final-status_description = TEXT-004. "'Completly Processed'.
        WHEN 'E'.
          ls_final-process_status = TEXT-009. "'@0A\Q Error!@'.
          ls_final-status_description = TEXT-010. "'Error'.
        WHEN 'U'.
          ls_final-process_status = TEXT-011. "'@3J\Q Under Process@'.
          ls_final-status_description = TEXT-011. "'Under Process'.
        WHEN 'S'.
          ls_final-process_status = TEXT-005. "'@F9\Q Eway Bill Cancelled@'.
          ls_final-status_description = TEXT-006. "'Eway Bill Cancelled'.
        WHEN OTHERS.
          ls_final-process_status = TEXT-007. "'@5D\Q Not Processed@'.
          ls_final-status_description = TEXT-008. "'Not Processed'.
      ENDCASE.


      READ TABLE lt_ewaybill INTO DATA(ls_ewaybill) WITH KEY bukrs = ls_vbrk_j-bukrs vbeln = ls_vbrk_j-vbeln.
      IF sy-subrc = 0.
        ls_final-veh_no = ls_ewaybill-vehical_no.
      ENDIF.

      READ TABLE lt_extend INTO DATA(ls_extend) WITH KEY eway_bill = ls_final-eway_bil.
      IF sy-subrc = 0.
        ls_final-eway_dt_exp      = ls_extend-validuptodate.
        ls_final-vdtotime         = ls_extend-validuptotime.
      ENDIF.
    ELSE.

      READ TABLE lt_j_1ig_ewaybill INTO DATA(ls_j_1ig_ewaybill) WITH KEY docno = ls_vbrk_j-vbeln BINARY SEARCH.
      IF sy-subrc = 0.
        ls_final-eway_bil         = ls_j_1ig_ewaybill-ebillno.
        ls_final-eway_dt          = ls_j_1ig_ewaybill-vdfmdate.
        ls_final-vdfmtime         = ls_j_1ig_ewaybill-vdfmtime.
        ls_final-eway_dt_exp      = ls_j_1ig_ewaybill-vdtodate.
        ls_final-vdtotime         = ls_j_1ig_ewaybill-vdtotime.

        CASE ls_j_1ig_ewaybill-status.
          WHEN 'A' OR 'E' OR 'P'.
            ls_final-process_status = TEXT-003 . "'@08\Q Completly Processed@'.
            ls_final-status_description = TEXT-004. "'Completly Processed'.
          WHEN 'C'.
            ls_final-process_status = TEXT-005. "'@F9\Q Eway Bill Cancelled@'.
            ls_final-status_description = TEXT-006. "'Eway Bill Cancelled'.
          WHEN OTHERS.
            ls_final-process_status = TEXT-007. "'@5D\Q Not Processed@'.
            ls_final-status_description = TEXT-008. "'Not Processed'.
        ENDCASE.

      ENDIF.
    ENDIF.

    READ TABLE lt_j_1ig_invrefnum INTO DATA(ls_j_1ig_invrefnum) WITH KEY bukrs = ls_vbrk_j-bukrs docno = ls_vbrk_j-vbeln BINARY SEARCH.
    IF sy-subrc = 0.
      ls_final-irn_no = ls_j_1ig_invrefnum-irn.
    ENDIF.

    ls_final-vkorg                = ls_vbrk_j-vkorg.

    APPEND ls_final TO lt_final.
    CLEAR : ls_final , ls_zeway_number.
  ENDLOOP.

  SORT lt_final BY vbeln.

  CREATE OBJECT g_app.
  IF c_ccont IS INITIAL.
    CREATE OBJECT c_ccont
      EXPORTING
        container_name = 'CCONT'.   "--Custom Container Object for Materials Display.

    CREATE OBJECT c_alvgd
      EXPORTING
        i_parent = c_ccont.
  ENDIF.

  SET HANDLER g_app->handle_double_click FOR c_alvgd.
  SET HANDLER g_app->handle_hot_spot FOR c_alvgd.
  SET HANDLER g_app->handle_toolbar FOR c_alvgd.
*  SET HANDLER g_app->

  PERFORM alv_build_fieldcat.
  PERFORM alv_report_layout.

  CHECK NOT c_alvgd IS INITIAL.


  ls_exclude = cl_gui_alv_grid=>mc_fc_excl_all .

  APPEND ls_exclude TO pt_exclude.


  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
      is_layout                     = it_layout
      i_save                        = 'A'
      it_toolbar_excluding          = pt_exclude
    CHANGING
      it_outtab                     = lt_final[]
      it_fieldcatalog               = it_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat .

  DATA lv_fldcat TYPE lvc_s_fcat.
  CLEAR :lv_fldcat,it_fcat.


  lv_fldcat-fieldname = 'SELECTION'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 5.
  lv_fldcat-scrtext_m = 'Selection'.
  lv_fldcat-checkbox = abap_true.
  lv_fldcat-edit = 'X'.


  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PROCESS_STATUS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 5.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Status'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'STATUS_DESCRIPTION'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 20.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Status Description'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'BUKRS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Company Code'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  IF b1 = 'X' OR b3 = 'X'.
    lv_fldcat-fieldname = 'VBELN'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 10.
*    lv_fldcat-edit      = 'X'.
    lv_fldcat-scrtext_m = 'Billing Document'.
    lv_fldcat-hotspot = 'X'.
    lv_fldcat-key = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.
  ELSE.
    lv_fldcat-fieldname = 'VBELN'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 10.
*    lv_fldcat-edit      = 'X'.
    lv_fldcat-scrtext_m = 'Document No.'.
    lv_fldcat-hotspot = 'X'.
    lv_fldcat-key = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-fieldname = 'BELNR1'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 10.
*    lv_fldcat-edit      = 'X'.
    lv_fldcat-scrtext_m = 'Doc NO.'.
*    lv_fldcat-key = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

  ENDIF.


  lv_fldcat-fieldname = 'FKART'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
  lv_fldcat-scrtext_m = 'Document Type'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'FKDAT'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Posting Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  IF b1 = 'X' OR b3 = 'X'.
    lv_fldcat-fieldname = 'KUNNR'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 10.
    lv_fldcat-scrtext_m = 'Customer No.'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-fieldname = 'CUST_NAME'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 35.
    lv_fldcat-scrtext_m = 'Customer Name'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.
  ELSE.
    lv_fldcat-fieldname = 'KUNNR'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 10.
    lv_fldcat-scrtext_m = 'Vendor No.'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-fieldname = 'CUST_NAME'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 35.
    lv_fldcat-scrtext_m = 'Vendor Name'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.
  ENDIF.


  lv_fldcat-fieldname = 'EWAY_BIL'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 16.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'E-Way Bill'.

  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'CONWAY_BIL'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 16.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_l = 'Consolidated Eway Bill No'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'EWAY_DT'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_l = 'Eway Bill Generation Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'VDFMTIME'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_l = 'Eway Bill Generation Time'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'EWAY_DT_EXP'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_l = 'Eway Bill Exp Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'VDTOTIME'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_l = 'Eway Bill Expiry Time'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MESSAGE'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 65.
  lv_fldcat-scrtext_l = 'Message'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'IO_GSTIN'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 15.
  lv_fldcat-scrtext_m = 'To GSTIN'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'VEH_NO'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_l = 'Vehical No'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
  lv_fldcat-scrtext_m = 'Plant'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'VKORG'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
  lv_fldcat-scrtext_m = 'Sales Organization'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CREATED_DT'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Creation Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CREATED_TIME'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 08.
  lv_fldcat-scrtext_m = 'Creation Time'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CREATED_BY'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 12.
  lv_fldcat-scrtext_m = 'Created By'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'CANREASON'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 12.
  lv_fldcat-scrtext_m = 'Cancel Reason'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CANCELDT'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 12.
  lv_fldcat-scrtext_m = 'Cancel Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CANCELREMARK'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 12.
  lv_fldcat-scrtext_m = 'Cancel Remark'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CANCEL_DOC'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 12.
  lv_fldcat-scrtext_m = 'Cancel Doc. No.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  IF b1 = 'X'.
    lv_fldcat-fieldname = 'IRN_NO'.
    lv_fldcat-tabname   = 'LT_FINAL'.
    lv_fldcat-outputlen = 64.
    lv_fldcat-scrtext_m = 'IRN Number'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_report_layout .
  it_layout-zebra      = 'X'.
  it_layout-cwidth_opt = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZSTATUS'.
  SET TITLEBAR 'ZTITLE'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  LOAD_LOGO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE load_logo OUTPUT.

  CONSTANTS: cntl_true  TYPE i VALUE 1,
             cntl_false TYPE i VALUE 0.
  DATA:h_picture       TYPE REF TO cl_gui_picture,
       h_pic_container TYPE REF TO cl_gui_custom_container.
  DATA: graphic_url(255),
  graphic_refresh(1),
  g_result LIKE cntl_true.
  DATA: BEGIN OF graphic_table OCCURS 0,
          line(255) TYPE x,
        END OF graphic_table.
  DATA: graphic_size TYPE i.
  DATA: g_stxbmaps TYPE stxbitmaps,
        l_bytecnt  TYPE i,
        l_content  TYPE STANDARD TABLE OF bapiconten INITIAL SIZE 0.



  g_stxbmaps-tdobject = 'GRAPHICS'.
  g_stxbmaps-tdname = 'EUROPA_LOGO_EINV'.            "'ZJAI1_COL'.
  g_stxbmaps-tdid = 'BMAP'.
  g_stxbmaps-tdbtype = 'BCOL'.


  CALL FUNCTION 'SAPSCRIPT_GET_GRAPHIC_BDS'
    EXPORTING
      i_object       = g_stxbmaps-tdobject
      i_name         = g_stxbmaps-tdname
      i_id           = g_stxbmaps-tdid
      i_btype        = g_stxbmaps-tdbtype
    IMPORTING
      e_bytecount    = l_bytecnt
    TABLES
      content        = l_content
    EXCEPTIONS
      not_found      = 1
      bds_get_failed = 2
      bds_no_content = 3
      OTHERS         = 4.

  CALL FUNCTION 'SAPSCRIPT_CONVERT_BITMAP'
    EXPORTING
      old_format               = 'BDS'
      new_format               = 'BMP'
      bitmap_file_bytecount_in = l_bytecnt
    IMPORTING
      bitmap_file_bytecount    = graphic_size
    TABLES
      bds_bitmap_file          = l_content
      bitmap_file              = graphic_table
    EXCEPTIONS
      OTHERS                   = 1.

  CALL FUNCTION 'DP_CREATE_URL'
    EXPORTING
      type     = 'image'
      subtype  = cndp_sap_tab_unknown
      size     = graphic_size
      lifetime = cndp_lifetime_transaction
    TABLES
      data     = graphic_table
    CHANGING
      url      = graphic_url
    EXCEPTIONS
      OTHERS   = 4.

  CREATE OBJECT h_pic_container
    EXPORTING
      container_name = 'CLOGO'.

  CREATE OBJECT h_picture EXPORTING parent = h_pic_container.

  CALL METHOD h_picture->set_display_mode
    EXPORTING
      display_mode = cl_gui_picture=>display_mode_normal.

  CALL METHOD h_picture->load_picture_from_url
    EXPORTING
      url    = graphic_url
    IMPORTING
      result = g_result.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo OUTPUT.

  CLEAR : lv_lines.", lv_eway, lv_notp, lv_can, lv_error.
  lv_eway  = 0.
  lv_notp  = 0.
  lv_can   = 0.
  lv_error = 0.
  DESCRIBE TABLE lt_final LINES lv_lines.
  LOOP AT lt_final INTO ls_final.
    CASE ls_final-status_description.
      WHEN 'Completly Processed'.
        lv_eway = lv_eway + 1.
      WHEN 'Not Processed'.
        lv_notp = lv_notp + 1.
      WHEN 'Eway Bill Cancelled'.
        lv_can = lv_can + 1.
      WHEN 'Error'.
        lv_error = lv_error + 1.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

  DATA lw_lvc_s_stbl TYPE lvc_s_stbl.

  lw_lvc_s_stbl-row  =  'X'   .
  lw_lvc_s_stbl-col  =  'X'.

  CALL METHOD c_alvgd->refresh_table_display
    EXPORTING
      is_stable      = lw_lvc_s_stbl
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai INPUT.

  c_alvgd->check_changed_data( ).
*  BREAK primus.
  CASE sy-ucomm.
    WHEN '&TOKEN'.  "" PRINT
*      BREAK primusabap.
*      DATA(lt_final_cnt) = lt_final.
*      DELETE lt_final WHERE selection NE 'X'.
      IF b1 = 'X'.
        READ TABLE lt_final INTO ls_final WITH KEY selection = 'X'.
        IF sy-subrc = 0.
          IF ls_final-eway_bil IS NOT INITIAL.
            PERFORM print_ewaybill.
          ELSE.
            CONCATENATE 'Eway bill Number is not generated for this invoice' ls_final-vbeln INTO DATA(lv_msg_1) SEPARATED BY space.
            MESSAGE lv_msg_1 TYPE 'E'.
            LEAVE LIST-PROCESSING.
          ENDIF.
*     SUBMIT ZEWAY_BILL_PRINT WITH p_vbeln = ls_final-vbeln WITH p_bukrs = ls_final-bukrs AND RETURN.

        ELSE.
          MESSAGE 'Please select atleast 1 document' TYPE 'E'.
        ENDIF.
      ELSEIF b2 = 'X'.
        READ TABLE lt_final INTO ls_final WITH KEY selection = 'X'.
        IF sy-subrc = 0.
          IF ls_final-eway_bil IS NOT INITIAL.
            PERFORM print_ven_ewaybill.
          ELSE.
            CONCATENATE 'Eway bill Number is not generated for this invoice' ls_final-vbeln INTO DATA(lv_msg_2) SEPARATED BY space.
            MESSAGE lv_msg_2 TYPE 'E'.
            LEAVE LIST-PROCESSING.
          ENDIF.
*     SUBMIT ZEWAY_BILL_PRINT WITH p_vbeln = ls_final-vbeln WITH p_bukrs = ls_final-bukrs AND RETURN.

        ELSE.
          MESSAGE 'Please select atleast 1 document' TYPE 'E'.
        ENDIF.

      ELSEIF b3 = 'X'. "ZEWAY_BILL_SALE_PRINT
        READ TABLE lt_final INTO ls_final WITH KEY selection = 'X'.
        IF sy-subrc = 0.
          IF ls_final-eway_bil IS NOT INITIAL.
            PERFORM print_sale_ewaybill.
          ELSE.
            CONCATENATE 'Eway bill Number is not generated for this invoice' ls_final-vbeln INTO DATA(lv_msg_3) SEPARATED BY space.
            MESSAGE lv_msg_3 TYPE 'E'.
            LEAVE LIST-PROCESSING.
          ENDIF.
*     SUBMIT ZEWAY_BILL_PRINT WITH p_vbeln = ls_final-vbeln WITH p_bukrs = ls_final-bukrs AND RETURN.

        ELSE.
          MESSAGE 'Please select atleast 1 document' TYPE 'E'.
        ENDIF.
      ENDIF.

    WHEN 'EXIT' OR 'BACK'.
      SET SCREEN '0'.
      LEAVE SCREEN.
***    WHEN '&EDIT'.
***      CALL SCREEN 200 STARTING AT 05 05.
    WHEN '&EWAY'.
*      BREAK primusabap.
      DATA(lt_final_cnt) = lt_final.
      DELETE lt_final_cnt WHERE selection NE 'X'.
      DESCRIBE TABLE lt_final_cnt LINES lv_lines.
      IF lv_lines EQ 0.
        REFRESH lt_final_cnt.
        CLEAR lv_lines.
        MESSAGE 'Please select atleast 1 document' TYPE 'E'.
      ELSEIF lv_lines GT 1.
        REFRESH lt_final_cnt.
        CLEAR lv_lines.
        MESSAGE 'Please select maximum 1 document' TYPE 'E'.
      ENDIF.

      CLEAR zeway_bill.
      CALL SCREEN 200 STARTING AT 05 05.

      IF sy-ucomm = '&CAN' OR  sy-ucomm = 'CANCEL'.
        CLEAR zeway_bill.
        SET SCREEN '0100'.
        LEAVE SCREEN.
      ENDIF.
*      BREAK primus.
      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF ls_final-irn_no IS INITIAL.
          CONCATENATE 'IRN number is not generated for invoice no. ' ls_final-vbeln INTO DATA(lv_msg1) RESPECTING BLANKS.
*****          MESSAGE lv_msg1 TYPE 'E'.  Comment for testing
        ENDIF.
*****        IF ls_final-transmode IS INITIAL.
*****          CONCATENATE 'Transport mode is blank for invoice no. ' ls_final-vbeln INTO DATA(lv_msg5) RESPECTING BLANKS.
*****          MESSAGE lv_msg5 TYPE 'E'.
*****        ENDIF.
        DATA: status TYPE zeway_number-zzstatus.
        CLEAR status.
        IF b1 = 'X' OR b3 = 'X'.
          SELECT SINGLE zzstatus INTO status FROM zeway_number WHERE eway_bill = ls_final-eway_bil.
        ELSE.
          SELECT SINGLE zzstatus INTO status FROM zeway_res_122 WHERE eway_bill = ls_final-eway_bil.
        ENDIF.
        IF ls_final-eway_bil IS NOT INITIAL AND status = 'C'.
          CONCATENATE 'Eway Bill number already generated for ' ls_final-vbeln INTO DATA(lv_msg2) RESPECTING BLANKS.
          MESSAGE lv_msg2 TYPE 'E'.

        ELSE.
          CONCATENATE 'C:/desktop/' ls_final-vbeln '.json' INTO file_name.
          IF b1 = 'X' OR b3 = 'X'.
            SELECT SINGLE * FROM zeway_bill INTO @DATA(ls_eway_bill) WHERE bukrs = @ls_final-bukrs AND vbeln = @ls_final-vbeln.
            IF sy-subrc = 0.
              gs_ewaybill_details-bukrs        =    ls_eway_bill-bukrs.
              gs_ewaybill_details-vbeln        =    ls_eway_bill-vbeln.
              gs_ewaybill_details-trns_md      =    ls_eway_bill-trns_md.
              gs_ewaybill_details-trans_doc    =    ls_eway_bill-trans_doc.
              gs_ewaybill_details-lifnr        =    ls_eway_bill-lifnr.
              gs_ewaybill_details-doc_dt       =    ls_eway_bill-doc_dt.
              gs_ewaybill_details-trans_id     =    ls_eway_bill-trans_id.
              gs_ewaybill_details-trans_name   =    ls_eway_bill-trans_name.
              gs_ewaybill_details-vehical_no   =    ls_eway_bill-vehical_no.
              gs_ewaybill_details-vehical_type =    ls_eway_bill-vehical_type.
              gs_ewaybill_details-distance     =    ls_eway_bill-distance.
              APPEND gs_ewaybill_details TO gt_ewaybill_details.
            ENDIF.

          ELSE.
            SELECT SINGLE * FROM zeway_bill INTO @DATA(ls_eway_bill1) WHERE bukrs = @ls_final-bukrs AND vbeln = @ls_final-vbeln
            AND gjahr = @ls_final-gjahr.
            IF sy-subrc = 0.
              gs_ewaybill_details-bukrs        =    ls_eway_bill1-bukrs.
              gs_ewaybill_details-gjahr        =    ls_eway_bill1-gjahr.
              gs_ewaybill_details-vbeln        =    ls_eway_bill1-vbeln.
              gs_ewaybill_details-trns_md      =    ls_eway_bill1-trns_md.
              gs_ewaybill_details-trans_doc    =    ls_eway_bill1-trans_doc.
              gs_ewaybill_details-lifnr        =    ls_eway_bill1-lifnr.
              gs_ewaybill_details-doc_dt       =    ls_eway_bill1-doc_dt.
              gs_ewaybill_details-trans_id     =    ls_eway_bill1-trans_id.
              gs_ewaybill_details-trans_name   =    ls_eway_bill1-trans_name.
              gs_ewaybill_details-vehical_no   =    ls_eway_bill1-vehical_no.
              gs_ewaybill_details-vehical_type =    ls_eway_bill1-vehical_type.
              gs_ewaybill_details-distance     =    ls_eway_bill1-distance.
              APPEND gs_ewaybill_details TO gt_ewaybill_details.
            ENDIF.

          ENDIF.

*          BREAK primus.
          IF b1 = 'X'.
            PERFORM get_details_for_json_create USING ls_final-stcd3.
          ELSEIF b2 = 'X'.
            PERFORM get_details_for_json_create122 USING ls_final-vbeln
                                                       ls_final-gjahr.
          ELSEIF b3 = 'X'.
            PERFORM get_details_for_json_crt_sale USING ls_final-stcd3.
          ENDIF.
        ENDIF.

      ENDLOOP.




    WHEN '&EWAYCAN'.
      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.

        IF ls_final-eway_bil IS INITIAL.
          CONCATENATE 'Eway bill Number is not generated for this invoice' ls_final-vbeln INTO DATA(lv_msg3) SEPARATED BY space.
          MESSAGE lv_msg3 TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ELSE.
          CALL SCREEN 300 STARTING AT 05 05.
        ENDIF.

      ENDLOOP.

    WHEN '&UPDATE'.
      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.

        IF ls_final-eway_bil IS INITIAL.
          CONCATENATE 'Eway bill Number is not generated for this invoice' ls_final-vbeln INTO DATA(lv_msg4) SEPARATED BY space.
          MESSAGE lv_msg4 TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ELSE.
          CALL SCREEN 400 STARTING AT 05 05.
        ENDIF.

      ENDLOOP.

    WHEN '&CONS'.
      lt_final_cnt = lt_final.
      DELETE lt_final_cnt WHERE selection NE 'X'.
      DESCRIBE TABLE lt_final_cnt LINES lv_lines.
      IF lv_lines EQ 0.
        REFRESH lt_final_cnt.
        CLEAR lv_lines.
        MESSAGE 'Please select atleast 1 document' TYPE 'E'.
      ENDIF.
*      DESCRIBE TABLE lt_final LINES data(lv_mark) KIND

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF ls_final-eway_bil IS INITIAL.
          MESSAGE e001(zewaybill) WITH ls_final-vbeln.
        ENDIF.
      ENDLOOP.

      CALL SCREEN 500 STARTING AT 05 05.
      """""""""

    WHEN '&MULTI_VEH'.
      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF ls_final-eway_bil IS INITIAL.
          CONCATENATE 'Eway bill Number is not generated for this invoice' ls_final-vbeln INTO DATA(lv_msg5) SEPARATED BY space.
          MESSAGE lv_msg5 TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ELSE.
          CALL SCREEN 700 STARTING AT 05 05.
*           PERFORM MULTI_VEHICLE.
        ENDIF.
      ENDLOOP.

    WHEN '&EXTEND'.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF ls_final-eway_bil IS INITIAL.
          CONCATENATE 'Eway bill Number is not generated for this invoice' ls_final-vbeln INTO DATA(lv_msg6) SEPARATED BY space.
          MESSAGE lv_msg6 TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ELSE.
          CALL SCREEN 201 STARTING AT 05 05.
        ENDIF.
      ENDLOOP.

    WHEN OTHERS.
      SET SCREEN '0'.
      LEAVE SCREEN.

  ENDCASE.


ENDMODULE.

*&---------------------------------------------------------------------*
*&      Form  GET_DETAILS_FOR_JSON_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_details_for_json_create USING gstin TYPE stcd3.

  REFRESH : lt_vbrk_j, lt_vbrp, lt_vbfa, lt_vbfa_2,
            lt_vbak, lt_vbap, lt_marc, lt_prcd, lt_kna1,
            it_adrc, it_adrc_cust, it_adrct,lt_eway_number,
            it_json,lt_json_data,lt_vbrp,lt_final_temp.
  DATA: totinvvalue TYPE vbrk-netwr,
        total_val   TYPE vbrk-netwr,
        igst_v      TYPE vbrk-netwr.
  CLEAR : ls_str,zeway_bill,lv_ewaybill,lv_ewaybill_dt,lv_ewaybill_exdt,lv_temp,gs_ewaybill_details,total_val,totinvvalue.

  SELECT * FROM j_1istatecdm INTO TABLE lt_statecode.
  SELECT * FROM zbillingtypes INTO TABLE lt_billingtypes.
*  SELECT * FROM zplant_address INTO TABLE @DATA(lt_adress).

  lt_final_temp = lt_final.
  DELETE lt_final_temp WHERE selection <> 'X'.
*  BREAK primus.
  SELECT vbeln  fkart waerk vkorg
         kalsm knumv fkdat kurrf
         bukrs taxk6 netwr mwsbk kunag sfakn
         xblnr bupla land1
         FROM vbrk
         INTO TABLE lt_vbrk_j
         FOR ALL ENTRIES IN lt_final_temp
         WHERE vbeln = lt_final_temp-vbeln
         AND fkdat IN s_fkdat
         AND bukrs = p_bukrs
  AND vkorg IN s_vkorg.

  LOOP AT lt_vbrk_j INTO ls_vbrk_j.
    IF ls_vbrk_j-sfakn IS NOT INITIAL.
      DELETE lt_vbrk_j WHERE vbeln = ls_vbrk_j-sfakn.
      DELETE lt_vbrk_j WHERE vbeln = ls_vbrk_j-vbeln.
    ENDIF.
  ENDLOOP.

  IF lt_vbrk_j IS NOT INITIAL.

    SELECT vbeln posnr  matnr arktx
           fkimg netwr meins aubel
           kursk werks vrkme vgbel lgort
           FROM vbrp
           INTO TABLE lt_vbrp
           FOR ALL ENTRIES IN lt_vbrk_j
    WHERE vbeln = lt_vbrk_j-vbeln.
*           AND werks EQ s_plant.
*           AND werks IN s_plant
*           %_HINTS ORACLE 'INDEX("VBRP" "VBRP~ZD2")("VBRP" "VBRP~ZD3")'.

    LOOP AT lt_vbrk_j INTO ls_vbrk_j.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_vbrk_j-xblnr
        IMPORTING
          output = ls_vbrk_j-xblnr.
      MODIFY lt_vbrk_j FROM ls_vbrk_j TRANSPORTING xblnr.
      CLEAR ls_vbrk_j.
    ENDLOOP.

    SELECT knumv
           kposn
           kschl
           kwert
           kbetr
           kawrt
         FROM prcd_elements
         INTO TABLE lt_prcd
       FOR ALL ENTRIES IN lt_vbrk_j
         WHERE knumv = lt_vbrk_j-knumv
           AND kschl IN ('JOCG', 'JOSG', 'JOIG', 'JCOS', 'PR00', 'ZPR0', 'K004',
    'K005', 'K007', 'ZDIS', 'ZGSR', 'ZSUB', 'ZSTO', 'JTC1','JWTS', 'ZTCS', 'ZPFO', 'ZIN1', 'ZIN2', 'ZFR1', 'ZFR2' ,'ZTE1', 'ZTE2', 'VPRS').
    SELECT kunnr
        name1
        locco
        stcd3
        ort01
        pstlz
        land1
        regio
        bahne
        adrnr
        werks
        ktokd
        FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbrk_j
    WHERE kunnr EQ lt_vbrk_j-kunag.
  ELSE.
    MESSAGE 'No data found !' TYPE 'E'.
  ENDIF.

  IF lt_vbrp IS NOT INITIAL.
***********************addded by jyoti on 09.07.2024*****************************
    IF lt_vbrp IS NOT INITIAL.
      SELECT kschl
            kunnr
            matnr
            datbi
            datab
            knumh
       FROM a005
       INTO TABLE tt_a005
       FOR ALL ENTRIES IN lt_vbrp
       WHERE matnr = lt_vbrp-matnr
       AND kschl = 'ZSTO'
       AND datbi = '99991231'.
    ENDIF.
********ADDED BY PRIMUS JYOTI ON 01.12.2023*******
    IF tt_a005 IS NOT INITIAL.

      SELECT knumh
             kopos
             kschl
             kbetr
        FROM konp
        INTO TABLE tt_konp
        FOR ALL ENTRIES IN tt_a005
        WHERE knumh = tt_a005-knumh.

    ENDIF.
**************************************************

    SELECT  vbelv posnv vbeln
            posnn vbtyp_v matnr
            FROM vbfa
            INTO TABLE lt_vbfa
            FOR ALL ENTRIES IN lt_vbrp
            WHERE  vbeln = lt_vbrp-vbeln
            AND posnn = lt_vbrp-posnr
    AND vbtyp_v = 'J'.

    SELECT matnr
         werks
         steuc
         FROM marc
         INTO TABLE lt_marc
         FOR ALL ENTRIES IN lt_vbrp
    WHERE matnr EQ lt_vbrp-matnr.

    SELECT vbelv posnv vbeln
           posnn  vbtyp_v matnr
           FROM vbfa
           INTO TABLE lt_vbfa_2
           FOR ALL ENTRIES IN lt_vbrp
           WHERE  vbeln = lt_vbrp-vbeln
           AND posnn = lt_vbrp-posnr
    AND ( vbtyp_v = 'C' OR vbtyp_v = 'I' ) .

    IF lt_vbfa_2 IS NOT INITIAL.
      SELECT vbeln auart
             FROM vbak
             INTO TABLE lt_vbak
             FOR ALL ENTRIES IN lt_vbfa_2
      WHERE vbeln = lt_vbfa_2-vbelv.
    ENDIF.

    IF lt_vbak IS NOT INITIAL.
      SELECT vbeln posnr kdmat
             FROM vbap
             INTO TABLE lt_vbap
             FOR ALL ENTRIES IN lt_vbak
      WHERE vbeln = lt_vbak-vbeln.
    ENDIF.

    SELECT werks
           pstlz
           spras
           land1
           regio
           adrnr
           FROM t001w INTO TABLE it_t001w
           FOR ALL ENTRIES IN lt_vbrp
    WHERE werks = lt_vbrp-werks.
  ENDIF.

  IF it_t001w IS NOT INITIAL.
    SELECT spras
           land1
           bland
           bezei FROM t005u INTO TABLE it_t005u
           FOR ALL ENTRIES IN it_t001w
           WHERE spras = it_t001w-spras
          AND land1 = it_t001w-land1
    AND bland = it_t001w-regio.

    SELECT addrnumber
         name1
         street
         str_suppl1
         str_suppl2
         str_suppl3
         location
         country
         city1
         post_code1
         region
    FROM adrc INTO TABLE it_adrc
    FOR ALL ENTRIES IN it_t001w
    WHERE addrnumber = it_t001w-adrnr.
  ENDIF.

  IF lt_kna1 IS NOT INITIAL.
    SELECT addrnumber
           name1
           street
           str_suppl1
           str_suppl2
           str_suppl3
           location
           country
           city1
           post_code1
           region
           city2
           FROM adrc INTO TABLE it_adrc_cust
           FOR ALL ENTRIES IN lt_kna1
    WHERE addrnumber = lt_kna1-adrnr.

    SELECT addrnumber
       remark INTO TABLE it_adrct FROM adrct FOR ALL ENTRIES IN lt_kna1
    WHERE addrnumber = lt_kna1-adrnr.
  ENDIF.

  DATA : doc_no  TYPE thead-tdname,
         lines   LIKE tline OCCURS 0 WITH HEADER LINE,
         i_text  TYPE char100,
         e_text  TYPE char100,

         lv_id   TYPE  thead-tdid,
         lv_lang TYPE thead-tdspras VALUE 'E',
         lv_obj  TYPE thead-tdobject,
         lv_name TYPE thead-tdname.

  DATA: lt_tab TYPE STANDARD TABLE OF tline.
  DATA: ls_vbpa  TYPE vbpa,
        ls_kna1  TYPE kna1,
        ls_adrc  TYPE adrc,
        gv_kunag TYPE kunag,
        gv_fkart TYPE fkart.
*  BREAK primusabap.
  LOOP AT lt_vbrp INTO wa_vbrp.
    CLEAR:total_val,totinvvalue.
    ls_json_data-posnr = wa_vbrp-posnr.
    ls_json_data-material = wa_vbrp-matnr.
    ls_json_data-arktx = wa_vbrp-arktx.
    ls_json_data-uqc = wa_vbrp-vrkme.
    ls_json_data-taxable_value = wa_vbrp-netwr * wa_vbrp-kursk.
    READ TABLE lt_vbrk_j INTO ls_vbrk_j WITH KEY vbeln = wa_vbrp-vbeln.
    IF sy-subrc = '0'.
      ls_json_data-assess_value = ls_vbrk_j-netwr.
      gv_kunag                  = ls_vbrk_j-kunag.                        "added by aniket - 07.07.2023
      gv_fkart                  = ls_vbrk_j-fkart.                        "added by aniket - 07.07.2023
      READ TABLE lt_billingtypes INTO ls_billingtypes WITH KEY bukrs = ls_vbrk_j-bukrs vkorg = ls_vbrk_j-vkorg fkart = ls_vbrk_j-fkart.
      IF sy-subrc = 0.
        IF ls_vbrk_j-vbeln IS NOT INITIAL.
          ls_json_data-doc_no = ls_vbrk_j-vbeln.
        ELSE.
          ls_json_data-doc_no = 'null'.
        ENDIF.
        ls_json_data-xblnr = ls_vbrk_j-xblnr.            "
        ls_json_data-order_type = ls_vbrk_j-fkart.
        ls_json_data-supply_type  = ls_billingtypes-zsupply.
        ls_json_data-sub_type     = ls_billingtypes-zsubsupply.
        ls_json_data-doc_type     = ls_billingtypes-zdoctype.



        "Added By Nilay B. 05.09.2023
        IF ls_vbrk_j-fkart = 'ZDC'.
          ls_json_data-subsupplydesc     = 'Delivery Challan'.
        ENDIF.
        "Ended By Nilay B. 05.08.2023
        IF ls_vbrk_j-fkdat IS NOT INITIAL.
          CONCATENATE ls_vbrk_j-fkdat+6(2) '-' ls_vbrk_j-fkdat+4(2) '-' ls_vbrk_j-fkdat+0(4) INTO ls_json_data-doc_date.
        ELSE.
          ls_json_data-doc_date = 'null'.
        ENDIF.

        SELECT SINGLE gstin FROM j_1bbranch INTO ls_json_data-gstin WHERE bukrs = ls_vbrk_j-bukrs AND branch = ls_vbrk_j-bupla.

*
        SELECT SINGLE lgort FROM mseg INTO @DATA(gv_lgort) WHERE mblnr = @wa_vbrp-vgbel
                                                    AND xauto NE 'X'.
        BREAK primusabap.
******************************FROM ADDRESS
        IF ls_vbrk_j-fkart = 'ZDC' OR ls_vbrk_j-fkart = 'ZSN' . "ADDED BY JYOTI ON 16.06.2024
          IF gv_lgort = 'SAN1'. "ADDED BY JYOTI ON 16.06.2024
            ls_json_data-location  = 'SANGVI'."wa_adrc-city1.
            ls_json_data-name1      = 'DelVal Flow Controls Private Limited.'."wa_adrc-name1.
            ls_json_data-street     = 'Gat No 351,MILKAT NO.733,733/1,'."wa_adrc-str_suppl1.
            ls_json_data-str_suppl3 = '733/2 SHIRVAL NAIGAON ROAD'.
            ls_json_data-from_state = '13'."wa_adrc-region.
            ls_json_data-post_code1 = '412801'."wa_adrc-post_code1.

          ELSEIF gv_lgort = 'RM01' OR gv_lgort = 'FG01' OR gv_lgort = 'MCN1' OR gv_lgort = 'PLG1' " Commented BY pranit 21.10.24 OR GV_LGORT = 'PN01'
            OR gv_lgort = 'PRD1' OR gv_lgort = 'RJ01' OR gv_lgort = 'RWK1' OR gv_lgort = 'TPI1' OR  gv_lgort = 'VLD1'  OR  gv_lgort = 'SC01' OR  gv_lgort = 'SFG1'.
            READ TABLE it_t001w INTO wa_t001w WITH KEY werks = wa_vbrp-werks.
            IF sy-subrc = 0.
              READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_t001w-adrnr.
              IF sy-subrc = 0.
                ls_json_data-location = wa_adrc-city1.
                ls_json_data-name1 = wa_adrc-name1.
                ls_json_data-street = wa_adrc-str_suppl1.
                ls_json_data-str_suppl3 = wa_adrc-str_suppl2.
                ls_json_data-from_state = wa_adrc-region.
                ls_json_data-post_code1 = wa_adrc-post_code1.
              ENDIF.
            ENDIF.
          ELSEIF gv_lgort+0(1) = 'K'.
            SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad)
            WHERE werks = @wa_vbrp-werks AND lgort = 'KPR1'.
            IF wa_twlad IS NOT INITIAL.
              SELECT SINGLE street, city1, post_code1 FROM adrc
                  INTO @DATA(wa_adrc_t_1) WHERE addrnumber = @wa_twlad.
            ENDIF.
            IF wa_adrc_t_1 IS NOT INITIAL.
              ls_json_data-location = wa_adrc_t_1-city1.
              ls_json_data-name1  = 'DelVal Flow Controls Private Limited.'.
              ls_json_data-street = wa_adrc_t_1-street.
              ls_json_data-str_suppl3 = wa_adrc_t_1-city1.
              ls_json_data-from_state = '13'.
              ls_json_data-post_code1 = wa_adrc_t_1-post_code1.
            ENDIF.
*            ls_json_data-location = 'Shirwal'."wa_adrc-city1.
*            ls_json_data-name1 = 'DelVal Flow Controls Private Limited.'."wa_adrc-name1.
*            ls_json_data-street = 'Gat No 25,37,43/1A,AT-Kavathe,'."wa_adrc-str_suppl1.
**            ls_json_data-str_suppl3 = wa_adrc-str_suppl2.
*            ls_json_data-from_state = '13'."wa_adrc-region.
*            ls_json_data-post_code1 = '412801'."wa_adrc-post_code1.
          ELSEIF gv_lgort = 'PN01'.                         """"Added by Pranit 21.10.2024
*            BREAK primusabap.
            SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad1)
     WHERE werks = @wa_vbrp-werks AND lgort = 'PN01'.
            IF wa_twlad1 IS NOT INITIAL.
              SELECT SINGLE street, city1, post_code1 FROM adrc
                  INTO @DATA(wa_adrc_t_1_1) WHERE addrnumber = @wa_twlad1.
            ENDIF.
            IF wa_adrc_t_1_1 IS NOT INITIAL.
              ls_json_data-location = wa_adrc_t_1_1-city1.
              ls_json_data-name1  = 'DelVal Flow Controls Private Limited.'.
              ls_json_data-street = wa_adrc_t_1_1-street.
              ls_json_data-str_suppl3 = wa_adrc_t_1_1-city1.
              ls_json_data-from_state = '13'.
              ls_json_data-post_code1 = wa_adrc_t_1_1-post_code1.
            ENDIF.
          ENDIF.
        ELSE.
*            READ TABLE LT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = LS_VBRK_J-KUNAG."COMMENTED BY JYOTI ON 19.06.2024
*            ***********************ADDED BY JYOTI ON 19.06.2024*************
          READ TABLE it_t001w INTO wa_t001w WITH KEY werks = wa_vbrp-werks.
          IF sy-subrc = 0.
            READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_t001w-adrnr.
            IF sy-subrc = 0.
              ls_json_data-location = wa_adrc-city1.
              ls_json_data-name1 = wa_adrc-name1.
              ls_json_data-street = wa_adrc-str_suppl1.
              ls_json_data-str_suppl3 = wa_adrc-str_suppl2.
              ls_json_data-from_state = wa_adrc-region.
              ls_json_data-post_code1 = wa_adrc-post_code1.
            ENDIF.

          ENDIF.
          ls_json_data-gstin = ls_json_data-gstin.
          IF wa_vbrp-lgort+0(1) = 'K'.
            SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_1)
            WHERE werks = @wa_vbrp-werks AND lgort = 'KPR1'.
            IF wa_twlad_1 IS NOT INITIAL.
              SELECT SINGLE street, city1, post_code1 FROM adrc
                  INTO @DATA(wa_adrc_t) WHERE addrnumber = @wa_twlad_1.
            ENDIF.
            IF wa_adrc_t IS NOT INITIAL.
              ls_json_data-location = wa_adrc_t-city1.
              ls_json_data-name1  = 'DelVal Flow Controls Private Limited.'.
              ls_json_data-street = wa_adrc_t-street.
              ls_json_data-str_suppl3 = wa_adrc_t-city1.
              ls_json_data-from_state = '13'.
              ls_json_data-post_code1 = wa_adrc_t-post_code1.
            ENDIF.
          ELSEIF  wa_vbrp-lgort = 'PN01'.                         """"Added by Pranit 21.10.2024
            BREAK primusabap.
            SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad1_2)
     WHERE werks = @wa_vbrp-werks AND lgort = 'PN01'.
            IF wa_twlad1_2 IS NOT INITIAL.
              SELECT SINGLE street, city1, post_code1 FROM adrc
                  INTO @DATA(wa_adrc_t_1_2) WHERE addrnumber = @wa_twlad1_2.
            ENDIF.
            IF wa_adrc_t_1_2 IS NOT INITIAL.
              ls_json_data-location = wa_adrc_t_1_2-city1.
              ls_json_data-name1  = 'DelVal Flow Controls Private Limited.'.
              ls_json_data-street = wa_adrc_t_1_2-street.
              ls_json_data-str_suppl3 = wa_adrc_t_1_2-city1.
              ls_json_data-from_state = '13'.
              ls_json_data-post_code1 = wa_adrc_t_1_2-post_code1.
            ENDIF.

          ENDIF.

        ENDIF.
        REPLACE ALL OCCURRENCES OF  ',' IN ls_json_data-name1 WITH '  '.
        TRANSLATE ls_json_data-name1 TO UPPER CASE.
        REPLACE ALL OCCURRENCES OF  ',' IN ls_json_data-street WITH cl_abap_char_utilities=>horizontal_tab.
        REPLACE ALL OCCURRENCES OF  '&' IN ls_json_data-street WITH ' '.
        TRANSLATE ls_json_data-street TO UPPER CASE.
        REPLACE ALL OCCURRENCES OF  ',' IN ls_json_data-str_suppl3 WITH ''.
        TRANSLATE ls_json_data-str_suppl3 TO UPPER CASE.
        TRANSLATE ls_json_data-location TO UPPER CASE.
        TRANSLATE ls_json_data-country TO UPPER CASE.
        TRANSLATE ls_json_data-city TO UPPER CASE.
        TRANSLATE ls_json_data-from_state TO UPPER CASE.

*-------------------Start Remove Special Characters from Strings------------------------------------------

        MOVE ls_json_data-arktx TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-arktx.
        CLEAR : e_text, i_text.

        MOVE ls_json_data-name1 TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-name1.
        CLEAR : e_text, i_text.
        MOVE ls_json_data-street TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-street.
        CLEAR : e_text, i_text.
        MOVE ls_json_data-str_suppl3 TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-str_suppl3.
        CLEAR : i_text, e_text.
        MOVE ls_json_data-location TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-location.
        CLEAR : i_text, e_text.
        MOVE ls_json_data-country TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-country.
        CLEAR : i_text, e_text.
        MOVE ls_json_data-city TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-city.
        CLEAR : i_text, e_text.
        ls_json_data-line_item = 'ELECTRICAL & MECHANICAL'.
        ls_json_data-item_code  = wa_vbrp-arktx.
        MOVE ls_json_data-item_code TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-item_code.
        CLEAR : i_text, e_text.
*-------------------End Remove Special Characters from Strings------------------------------------------

        TRANSLATE ls_json_data-item_code TO UPPER CASE.
        ls_json_data-quantity  = wa_vbrp-fkimg.
        READ TABLE lt_marc INTO wa_marc WITH KEY matnr = wa_vbrp-matnr werks = wa_vbrp-werks.
        IF sy-subrc = '0'.
          ls_json_data-hsn_sac = wa_marc-steuc.
        ENDIF.


        READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag.
        IF sy-subrc = 0.
          ls_json_data-transport_id = wa_kna1-bahne.                    " Transporter ID
          READ TABLE it_adrc_cust INTO wa_adrc_cust WITH KEY addrnumber = wa_kna1-adrnr.
          IF ls_vbrk_j-waerk NE 'INR'.
            CLEAR:ls_vbpa.
*              SELECT SINGLE * FROM vbpa INTO ls_vbpa WHERE vbeln = ls_vbrk_j-vbeln AND parvw = 'PT'.
            DATA : gv_name  TYPE thead-tdname,
                   lv_lines TYPE STANDARD TABLE OF tline,
                   wa_lines LIKE tline,
                   kunnr    TYPE kna1-kunnr.

            CLEAR:kunnr,gv_name,lv_lines,wa_lines.
            gv_name = ls_vbrk_j-vbeln.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'Z350'
                language                = sy-langu
                name                    = gv_name
                object                  = 'VBBK'
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
*               MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
            ENDIF.

            IF NOT lv_lines IS INITIAL.
              READ TABLE lv_lines INTO wa_lines INDEX 1.
              IF NOT wa_lines-tdline IS INITIAL.
                kunnr = wa_lines-tdline .
              ENDIF.

            ENDIF.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = kunnr
              IMPORTING
                output = kunnr.


            IF kunnr IS NOT INITIAL .
              CLEAR : ls_kna1.
              SELECT SINGLE * FROM kna1 INTO ls_kna1 WHERE kunnr = kunnr.
              IF sy-subrc = 0.
                CLEAR : ls_adrc.
                SELECT SINGLE * FROM adrc INTO ls_adrc WHERE addrnumber = ls_kna1-adrnr.
              ENDIF.
            ENDIF.

            MOVE wa_kna1-name1 TO i_text.
            PERFORM es_remove_special_character USING i_text CHANGING e_text.
            MOVE e_text TO   ls_json_data-ship_to_party.
            CLEAR : i_text, e_text.
            ls_json_data-to_gstin   = 'URP'."wa_kna1-stcd3..
            IF ls_json_data-to_gstin = 'URD'.
              ls_json_data-to_gstin = 'URP'.
            ENDIF.
            CONCATENATE ls_adrc-str_suppl1 ls_adrc-street INTO i_text SEPARATED BY space.
            PERFORM es_remove_special_character USING i_text CHANGING e_text.
            MOVE e_text TO    ls_json_data-to_add1.
            CLEAR : i_text, e_text.
            CONCATENATE ls_adrc-str_suppl2 ls_adrc-city2 INTO i_text SEPARATED BY space.
            PERFORM es_remove_special_character USING i_text CHANGING e_text.
            MOVE e_text TO    ls_json_data-to_add2.
            CLEAR : i_text, e_text.
*             ls_json_data-TO_PLACE   = WA_KNA1-ORT01.
            MOVE ls_kna1-ort01 TO i_text.
            PERFORM es_remove_special_character USING i_text CHANGING e_text.
            MOVE e_text TO ls_json_data-to_place.
            CLEAR : i_text, e_text.
            ls_json_data-to_pincode = ls_kna1-pstlz.

            ls_json_data-distance_level   = ls_kna1-locco.
*              SELECT SINGLE bezei FROM t005u INTO  ls_json_data-to_state  WHERE spras = 'E' AND land1 = ls_kna1-land1 AND bland = ls_kna1-regio.
            ls_json_data-to_state   = ls_kna1-regio."'OTHER COUNTRIES '.
            TRANSLATE ls_json_data-to_state TO UPPER CASE.
            TRANSLATE ls_json_data-to_add1 TO UPPER CASE.
            TRANSLATE ls_json_data-to_place TO UPPER CASE.
          ELSE.
            DATA :bill_to    TYPE kna1-kunnr,
                  ship_to    TYPE kna1-kunnr,
                  ship_state TYPE kna1-regio.

            CLEAR: bill_to , ship_to.
            SELECT SINGLE kunnr FROM vbpa INTO bill_to WHERE vbeln = ls_vbrk_j-vbeln AND parvw = 'AG'.
            SELECT SINGLE kunnr FROM vbpa INTO ship_to WHERE vbeln = ls_vbrk_j-vbeln AND parvw = 'WE'.

            IF bill_to NE ship_to.
*                IF sy-subrc = 0.
              CLEAR : ls_kna1,ship_state.
              SELECT SINGLE * FROM kna1 INTO ls_kna1 WHERE kunnr = ship_to.
              IF sy-subrc = 0.
                CLEAR : ls_adrc.
                SELECT SINGLE * FROM adrc INTO ls_adrc WHERE addrnumber = ls_kna1-adrnr.
              ENDIF.
*                 ENDIF.

              MOVE wa_kna1-name1 TO i_text.
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-ship_to_party.
              CLEAR : i_text, e_text.
              ls_json_data-to_gstin   = wa_kna1-stcd3.


              CONCATENATE ls_adrc-str_suppl1 ls_adrc-street INTO i_text SEPARATED BY space.
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-to_add1.
              CLEAR : i_text, e_text.
              CONCATENATE ls_adrc-str_suppl2 ls_adrc-city2 INTO i_text SEPARATED BY space.
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-to_add2.
              CLEAR : i_text, e_text.

              MOVE ls_kna1-ort01 TO i_text.
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-to_place.
              CLEAR : i_text, e_text.

              ls_json_data-to_pincode = ls_kna1-pstlz.
              ls_json_data-distance_level   = wa_kna1-locco.
*  *            SELECT SINGLE bezei FROM t005u INTO  ls_json_data-to_state  WHERE spras = 'E' AND land1 = wa_kna1-land1 AND bland = wa_kna1-regio.

              ls_json_data-to_state = wa_kna1-regio.
              ship_state = ls_kna1-regio.
              TRANSLATE ls_json_data-to_state TO UPPER CASE.
              TRANSLATE ls_json_data-to_add1 TO UPPER CASE.
              TRANSLATE ls_json_data-to_place TO UPPER CASE.
            ELSE.
**********************************************************************
              BREAK primusabap.
              IF ls_vbrk_j-fkart = 'ZDC'. "ADDED BY JYOTI ON 16.06.2024
*            IF WA_VBRP-LGORT = 'RM01'. "ADDED BY JYOTI ON 16.06.2024
                IF wa_vbrp-lgort = 'RM01' OR wa_vbrp-lgort = 'FG01' OR wa_vbrp-lgort = 'MCN1' OR wa_vbrp-lgort = 'PLG1'  " Commented BY pranit 21.10.24OR wa_vbrp-lgort = 'PN01'
              OR wa_vbrp-lgort = 'PRD1' OR wa_vbrp-lgort = 'RJ01' OR wa_vbrp-lgort = 'RWK1' OR wa_vbrp-lgort = 'TPI1' OR wa_vbrp-lgort = 'VLD1' OR  wa_vbrp-lgort = 'SC01' OR  gv_lgort = 'SFG1'.
                  wa_kna1-name1 = 'DelVal Flow Controls Private Limited.'.
*              wa_adrc_cust-str_suppl1
                  wa_adrc_cust-street = 'Gat No 25,37,43/1A,,'. "'GAT NO. 289/1, KAPURHOLE'.
                  wa_adrc_cust-str_suppl2 = 'AT-Kavathe'."'TAL-BHOR'.
                  wa_adrc_cust-city2 = 'Shirwal'.
                  wa_kna1-ort01 = 'Shirwal'.
                  wa_kna1-pstlz = '412801'.
                  wa_kna1-regio = '13'.
                ELSEIF wa_vbrp-lgort = 'SAN1'.
                  CLEAR: wa_adrc_cust-str_suppl1. """ADDED BY PRANIT 21.10.2024
                  wa_kna1-name1 = 'DelVal Flow Controls Private Limited.'.
*              wa_adrc_cust-str_suppl1
                  wa_adrc_cust-street = 'Gat No 351,MILKAT NO.733,733/1,'. "'GAT NO. 289/1, KAPURHOLE'.
                  wa_adrc_cust-str_suppl2 = '733/2 SHIRVAL NAIGAON ROAD'."'TAL-BHOR'.
                  wa_adrc_cust-city2 = 'SANGVI'.
                  wa_kna1-ort01 = 'KHANDALA'.
                  wa_kna1-pstlz = '412801'.
                  wa_kna1-regio = '13'.

                ELSEIF wa_vbrp-lgort+0(1) = 'K'.
                  SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_new)
                  WHERE werks = @wa_vbrp-werks AND lgort = 'KPR1'.
                  IF wa_twlad_new IS NOT INITIAL.
                    SELECT SINGLE street, city1, post_code1 FROM adrc
                        INTO @DATA(wa_adrc_t_new) WHERE addrnumber = @wa_twlad_new.
                  ENDIF.
                  CLEAR :wa_adrc_cust-str_suppl1,wa_adrc_cust-str_suppl2.
                  IF wa_adrc_t_new IS NOT INITIAL.
                    wa_kna1-ort01 = wa_adrc_t_new-city1.
                    wa_kna1-name1   = 'DelVal Flow Controls Private Limited.'.
                    wa_adrc_cust-street  = wa_adrc_t_new-street.
*                   wa_adrc_cust-str_suppl2 = WA_ADRC_T_NEW-CITY1.
                    wa_adrc_cust-city2 = wa_adrc_t_new-city1.
                    wa_kna1-regio = '13'.
                    wa_kna1-pstlz = wa_adrc_t_new-post_code1.
                  ENDIF.
                ELSEIF wa_vbrp-lgort = 'PN01'.                         """"Added by Pranit 21.10.2024
                  SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_new_1)
                              WHERE werks = @wa_vbrp-werks AND lgort = 'PN01'.
                  IF wa_twlad_new_1 IS NOT INITIAL.
                    SELECT SINGLE street, city1, post_code1 FROM adrc
                        INTO @DATA(wa_adrc_t_new_f) WHERE addrnumber = @wa_twlad_new_1.
                  ENDIF.
                  CLEAR :wa_adrc_cust-str_suppl1,wa_adrc_cust-str_suppl2.
                  BREAK primusabap.
                  IF wa_adrc_t_new_f IS NOT INITIAL.
                    wa_kna1-ort01 = wa_adrc_t_new_f-city1.
                    wa_kna1-name1   = 'DelVal Flow Controls Private Limited.'.
                    wa_adrc_cust-street  = wa_adrc_t_new_f-street.
                    wa_adrc_cust-city2 = wa_adrc_t_new_f-city1.
                    wa_kna1-regio = '13'.
                    wa_kna1-pstlz = wa_adrc_t_new_f-post_code1.
                  ENDIF.
                ENDIF.
              ENDIF.
*******************************************************************************
              MOVE wa_kna1-name1 TO i_text."ADDED BY JYOTI ON 16.06.2024
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-ship_to_party.
              CLEAR : i_text, e_text.
              ls_json_data-to_gstin   = wa_kna1-stcd3.
              IF ls_json_data-to_gstin = 'URD'.
                ls_json_data-to_gstin = 'URP'.
              ENDIF.

*              IF  WA_VBRP-LGORT+0(1) = 'K' AND GV_LGORT+0(1) = 'K' .   """""""""""" NC 10.07.2025 """"""""
*
*                LS_JSON_DATA-SHIP_TO_PARTY  =  'DelVal Flow Controls Private Limited.'.
*                LS_JSON_DATA-TO_ADD1       =  'Gat No 25,37,43/1A,,'. "'GAT NO. 289/1, KAPURHOLE'.
*                LS_JSON_DATA-TO_ADD2       =  'AT-Kavathe'.
*                LS_JSON_DATA-TO_PLACE      =   'Shirwal'.
*                LS_JSON_DATA-TO_PINCODE    =   'Shirwal'.
**                LS_JSON_DATA-to_state      =
*
*
*              ELSE.


              CONCATENATE wa_adrc_cust-str_suppl1 wa_adrc_cust-street INTO i_text SEPARATED BY space.
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-to_add1.
              CLEAR : i_text, e_text.
              CONCATENATE wa_adrc_cust-str_suppl2 wa_adrc_cust-city2 INTO i_text SEPARATED BY space.
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-to_add2.
              CLEAR : i_text, e_text.

              MOVE wa_kna1-ort01 TO i_text.
              PERFORM es_remove_special_character USING i_text CHANGING e_text.
              MOVE e_text TO ls_json_data-to_place.
              CLEAR : i_text, e_text.

              ls_json_data-to_pincode = wa_kna1-pstlz.
*              ENDIF.

              ls_json_data-distance_level   = wa_kna1-locco.
*  *            SELECT SINGLE bezei FROM t005u INTO  ls_json_data-to_state  WHERE spras = 'E' AND land1 = wa_kna1-land1 AND bland = wa_kna1-regio.

              ls_json_data-to_state = wa_kna1-regio.

              TRANSLATE ls_json_data-to_state TO UPPER CASE.
              TRANSLATE ls_json_data-to_add1 TO UPPER CASE.
              TRANSLATE ls_json_data-to_place TO UPPER CASE.


*              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

*---------------------GST TAX AND RATE Calculations---------------------------------------------------------
        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOCG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          IF ls_prcd-kbetr <> 0.
            ls_json_data-cgst_rate =  floor( ls_prcd-kbetr )."ls_prcd-kbetr." / 10.
            ls_json_data-cgst_amt = ls_prcd-kwert.
          ENDIF.
        ENDIF.

        CLEAR ls_prcd.

        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOSG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          IF ls_prcd-kbetr <> 0.
            ls_json_data-sgst_rate = floor( ls_prcd-kbetr ). "ls_prcd-kbetr." / 10.
            ls_json_data-sgst_amt = ls_prcd-kwert.
            total_val = ls_prcd-kawrt * ls_vbrk_j-kurrf.
            ls_json_data-total_val = total_val." ls_prcd-kawrt * ls_vbrk_j-kurrf..
*            ls_json_data-total_val = ls_prcd-kawrt * ls_vbrk_j-kurrf..
          ENDIF.
        ENDIF.

        CLEAR ls_prcd.
        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOIG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          IF ls_prcd-kbetr <> 0.
            ls_json_data-igst_rate =  floor( ls_prcd-kbetr )."ls_prcd-kbetr." / 10.
            igst_v = ls_prcd-kwert * ls_vbrk_j-kurrf..
            ls_json_data-igst_amt = igst_v.    " ls_prcd-kwert * ls_vbrk_j-kurrf..ajay
*            ls_json_data-igst_amt = ls_prcd-kwert * ls_vbrk_j-kurrf..
            total_val = ls_prcd-kawrt * ls_vbrk_j-kurrf.
            ls_json_data-total_val = total_val." ls_prcd-kawrt * ls_vbrk_j-kurrf..
*            ls_json_data-total_val =  ls_prcd-kawrt * ls_vbrk_j-kurrf..
          ENDIF.
        ENDIF.
************************aDDED BY JYOTI ON 20.06.2024****************************************************
        IF ls_vbrk_j-fkart = 'ZDC'.
          ls_json_data-igst_rate = '0'.
          ls_json_data-sgst_rate = '0'.
          ls_json_data-cgst_rate = '0'.
        ENDIF.
*************************************************************************************************

*        BREAK primus.
        CLEAR ls_prcd.
        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZPR00' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          total_val = ls_prcd-kwert * ls_vbrk_j-kurrf.
          ls_json_data-total_val = total_val. "ls_prcd-kwert * ls_vbrk_j-kurrf..
*          ls_json_data-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
        ENDIF.

        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZSUB' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
          ls_json_data-total_val = total_val. "ls_prcd-kwert * ls_vbrk_j-kurrf..
*          ls_json_data-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
        ENDIF.

        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZSTO' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
          ls_json_data-total_val = total_val.     "ls_prcd-kwert * ls_vbrk_j-kurrf..
*          ls_json_data-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
        ENDIF.

        CLEAR ls_prcd.
*        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'K007' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'K004' OR kschl = 'K005' OR kschl = 'K007' OR kschl = 'ZDIS' OR kschl = 'ZGSR')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv.
*        IF sy-subrc = 0.
          IF ls_prcd-kwert < 0.
            ls_prcd-kwert = ls_prcd-kwert * -1.
          ENDIF.
          ls_json_data-discount = ls_prcd-kwert + ls_json_data-discount.
*        ENDIF.
          CLEAR ls_prcd.
        ENDLOOP.

        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'JTC1' OR kschl = 'JWTS')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  =  ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZIN1' OR kschl = 'ZIN2')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZFR1' OR kschl = 'ZFR2')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZTE1' OR kschl = 'ZTE2')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE  kschl = 'ZPFO'
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.


        IF ls_vbrk_j-fkart = 'ZEXP'.
          ls_json_data-othvalue = ls_json_data-othvalue * ls_vbrk_j-kurrf.
        ENDIF.

        IF ls_vbrk_j-fkart = 'ZEXP'.
          IF ls_vbrk_j-taxk6 = '5'.
            ls_json_data-igst_rate = '0'.
            ls_json_data-igst_amt = '0'.
          ENDIF.
        ENDIF.
****************************************ADDED BY JYOTI ON 18.06.2024***************************************
*   BREAK primusabap.
****************************************ADDED BY JYOTI ON 18.06.2024***************************************
*  IF ls_vbrk_j-fkart = 'ZDC'.
*
**        CLEAR ls_prcd.
**        LOOP AT lt_prcd INTO ls_prcd WHERE  kschl = 'VPRS'  AND knumv = ls_vbrk_j-knumv .
**         ls_json_data-total_val =  ls_json_data-total_val + ls_prcd-kwert.
**        ENDLOOP.
***********ADDED BY PRIMUS JYOTI ON 01.12.2023***********************
*READ TABLE TT_A005 INTO WA_A005 WITH KEY MATNR = wa_vbrp-matnr."ls_json_data-line_item .
**    IF WA_VBRK-FKDAT EQ WA_A005-DATAB.
**      WA_FINAL-KNUMH = WA_A005-KNUMH.
**    ENDIF.
*if sy-subrc IS INITIAL.
**   READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'VPRS'  knumv = ls_vbrk_j-knumv  kposn = wa_vbrp-posnr.
**       ls_json_data-total_val =   ls_json_data-total_val - ls_prcd-kwert.
*LOOP AT TT_KONP INTO WA_KONP WHERE knumH = WA_A005-KNUMH AND KSCHL = 'ZSTO'.
**                             AND kposn = wa_final-posnr.
*
*  IF  wa_konp-kschl = 'ZSTO'.
**    CLEAR : ls_json_data-total_val.
**    wa_final-RATE = WA_KONP-KBETR.
*
*    ls_json_data-total_val   =  ls_json_data-total_val + ( WA_KONP-KBETR  *  wa_vbrp-fkimg ) .
*
*  ENDIF.
*  ENDLOOP.
*else.
*   CLEAR ls_prcd.
*       READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'VPRS'  knumv = ls_vbrk_j-knumv  kposn = wa_vbrp-posnr.
*       ls_json_data-total_val =   ls_json_data-total_val + ls_prcd-kwert.
*endif.
*********************************************************
*   endif.
*********************************************************************************************************

*--------------------------------------------------------------------------------------------------------------
        ls_json_data-taxable_value = ls_json_data-total_val - ls_json_data-discount.      " Taxable value
        IF ls_vbrk_j-fkart = 'ZDC'.

          READ TABLE tt_a005 INTO wa_a005 WITH KEY matnr = wa_vbrp-matnr."ls_json_data-line_item .
          IF sy-subrc IS INITIAL.
            READ TABLE tt_konp INTO wa_konp WITH  KEY knumh = wa_a005-knumh.
            IF wa_konp-kschl = 'ZSTO'.
*               CLEAR : ls_json_data-taxable_value.
              ls_json_data-taxable_value =  wa_konp-kbetr *  wa_vbrp-fkimg.
            ENDIF.
*           ENDIF.

          ELSE.
            CLEAR ls_prcd.
            READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'VPRS'  knumv = ls_vbrk_j-knumv  kposn = wa_vbrp-posnr.
            ls_json_data-taxable_value =  ls_prcd-kwert.
*          endloop.

          ENDIF.
        ENDIF.

        IF ls_json_data-cgst_rate IS INITIAL.
          ls_json_data-cgst_rate = '0'.
          ls_json_data-sgst_rate = '0'.
        ENDIF.
        IF ls_json_data-igst_rate IS INITIAL.
          ls_json_data-igst_rate = '0'.
        ENDIF.
        IF ls_json_data-cess_rate IS INITIAL.
          ls_json_data-cess_rate = '0'.
        ENDIF.

        CONCATENATE  ls_json_data-cgst_rate '+' ls_json_data-sgst_rate '+' ls_json_data-igst_rate '+' ls_json_data-cess_rate INTO ls_json_data-total_gst_rate.
*        CONDENSE ls_json_data-total_gst_rate NO-GAPS.

*---------------Get Vehicle no------------------------------------------------------------*
        DATA : lv_lifnr TYPE lifnr.
        READ TABLE lt_vbfa INTO ls_vbfa WITH KEY vbeln = wa_vbrp-vbeln vbtyp_v = 'J'.
        IF sy-subrc = 0.
          SELECT SINGLE lifnr INTO lv_lifnr FROM vbpa WHERE vbeln = ls_vbfa-vbelv AND parvw = 'LF'.
        ENDIF.


*        BREAK-POINT.
        READ TABLE lt_vbfa_2 INTO ls_vbfa_2 WITH KEY vbeln = wa_vbrp-vbeln posnn = wa_vbrp-posnr.
        IF sy-subrc = 0.
          READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_vbfa_2-vbelv.
          IF sy-subrc = 0.
            CALL FUNCTION 'CONVERSION_EXIT_AUART_OUTPUT'
              EXPORTING
                input  = ls_vbak-auart
              IMPORTING
                output = ls_json_data-sales_order_type.
          ENDIF.

          READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_vbfa_2-vbelv posnr = ls_vbfa_2-posnv.
          IF sy-subrc = 0.
            ls_json_data-cust_mat = ls_vbap-kdmat.
          ENDIF.
        ENDIF.

        READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag ktokd = 'ZVEM'.
        IF sy-subrc = 0.
          SELECT SINGLE ebeln, ebelp FROM mseg INTO @DATA(ls_mseg) WHERE mblnr = @wa_vbrp-vgbel.
          IF sy-subrc = 0.
            lv_id   = 'F02'.
            lv_obj  = 'EKPO'.

            CONCATENATE ls_mseg-ebeln ls_mseg-ebelp INTO lv_name.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
*               CLIENT                  = SY-MANDT
                id                      = lv_id
                language                = lv_lang
                name                    = lv_name
                object                  = lv_obj
*               ARCHIVE_HANDLE          = 0
*               LOCAL_CAT               = ' '
*               IMPORTING
*               HEADER                  =
*               OLD_LINE_COUNTER        =
              TABLES
                lines                   = lt_tab
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
*        Implement suitable error handling here
            ELSE.
              READ TABLE lt_tab INTO DATA(ls_tab) INDEX 1.
              IF sy-subrc = 0.
                i_text = ls_tab-tdline.
                PERFORM es_remove_special_character USING i_text CHANGING e_text.
                MOVE e_text TO ls_json_data-to_add1.
                TRANSLATE ls_json_data-to_add1 TO UPPER CASE.
                CLEAR : i_text, e_text.
              ENDIF.
              READ TABLE lt_tab INTO ls_tab INDEX 2.
              IF sy-subrc = 0.
                i_text = ls_tab-tdline.
                PERFORM es_remove_special_character USING i_text CHANGING e_text.
                MOVE e_text TO ls_json_data-to_add2.
                CLEAR : i_text, e_text.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
*BREAK primus.

        IF ls_json_data-total_val LT 0.
          ls_json_data-total_val = ls_json_data-total_val * -1.
        ENDIF.

        APPEND ls_json_data TO lt_json_data.
        CLEAR :ls_json_data,ls_vbrk_j,wa_vbrp,wa_marc,lines[], wa_kna1, wa_adrc, wa_adrc_cust, ls_vbfa,wa_t001w, wa_zdistance,wa_konp.
      ENDIF.
    ENDIF.
    CLEAR :ls_json_data,ls_vbrk_j,wa_vbrp,wa_marc,lines[], wa_kna1, wa_adrc, wa_adrc_cust, ls_vbfa.

  ENDLOOP.
************************added by jyoti on 13.07.2024
*  BREAK PRIMUSABAP.
  READ TABLE lt_json_data INTO DATA(ls_json_data_1) INDEX 1.
  SELECT SINGLE fkart FROM vbrk INTO @DATA(lv_fkart_1) WHERE vbeln = @ls_json_data_1-doc_no.

  IF lv_fkart_1 = 'ZDC'.
    DATA : gv_total_value TYPE string.
    LOOP AT lt_json_data INTO ls_json_data.

      gv_total_value = gv_total_value + ls_json_data-taxable_value.
      ls_json_data-total_val = gv_total_value.


      MODIFY lt_json_data FROM ls_json_data."TRANSPORTING total_val.
    ENDLOOP.
  ENDIF. .

*----------------------Remove trailing zeroes from XBLNR----------------------------
  LOOP AT lt_json_data INTO ls_json_data.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = ls_json_data-xblnr
      IMPORTING
        output = ls_json_data-xblnr.
    MODIFY lt_json_data FROM ls_json_data TRANSPORTING xblnr.
    CLEAR ls_json_data.
  ENDLOOP.
*--------------------------------------------------------------------*

  LOOP AT lt_json_data ASSIGNING FIELD-SYMBOL(<f1>).
    READ TABLE gt_ewaybill_details INTO gs_ewaybill_details WITH KEY vbeln = <f1>-doc_no.
    IF sy-subrc = 0.
      <f1>-trans_mode         =  gs_ewaybill_details-trns_md.
      <f1>-trans_doc_no       =  gs_ewaybill_details-trans_doc.
*         <f1>-LIFNR           =  gs_ewaybill_details-LIFNR.
      <f1>-trans_date          =  gs_ewaybill_details-doc_dt.
      <f1>-trans_id        =  gs_ewaybill_details-trans_id.
      <f1>-transport_id    =  gs_ewaybill_details-trans_id.
      <f1>-trans_name      =  gs_ewaybill_details-trans_name.
      <f1>-vehicle_no      =  gs_ewaybill_details-vehical_no.
      <f1>-vehicletype     =  gs_ewaybill_details-vehical_type.
      <f1>-distance_level  =  gs_ewaybill_details-distance.
      <f1>-trans_date          = gs_ewaybill_details-doc_dt.
    ENDIF.
  ENDLOOP.

  """""""""""JSON Data collected""""""""""""
*  BREAK primusabap.
  LOOP AT lt_json_data INTO DATA(ls_final).
    " Comment due to Excelon
*    ls_final_eway-usergstin         = '29AAACW4202F1ZM' . "ls_final-gstin. for testing its hard coded. Excelon
*    IF ls_final_eway-usergstin IS INITIAL.
*      MESSAGE e001(zinv_message).
*    ENDIF.
    " End of comment excelon
    CLEAR:total_val,totinvvalue.
    ls_final_eway-zstyp = ls_final-supply_type.

*****************ADDED BY DIKSHA
    IF ls_vbrk_j-fkart = 'ZFOC' AND ls_vbrk_j-waerk <> 'INR' AND ls_vbrk_j-land1 <> 'IN'.
      ls_final_eway-subsupplytype = '3'.
    ELSEIF gv_fkart = 'ZDEX'.
      IF gv_kunag = '0000200178' OR gv_kunag = '0000200288' OR gv_kunag = '0000200364' OR gv_kunag = '0000200457' OR
         gv_kunag = '0000200488' OR gv_kunag = '0000200544' OR gv_kunag = '0000200594' OR gv_kunag = '0000200706' OR
         gv_kunag = '0000201213' OR gv_kunag = '0000201149' OR gv_kunag = '0000201094' OR gv_kunag = '0000201019' OR
         gv_kunag = '0000200097' OR gv_kunag = '0000200101' OR gv_kunag = '0000200533' OR gv_kunag = '0000201580' OR
         gv_kunag = '0000200575' OR gv_kunag = '0000200293' OR gv_kunag = '0000200544' OR gv_kunag = '0000200576' OR
         gv_kunag = '0000200941' OR gv_kunag = '0000200774' OR gv_kunag = '0000201011' OR gv_kunag = '0000201586' OR
         gv_kunag = '0000200249'.

        ls_final_eway-subsupplytype = '9'.
      ENDIF.
*************************************
    ELSE.
      ls_final_eway-subsupplytype = ls_final-sub_type.
    ENDIF.

    ls_final_eway-subsupplydesc = ''.

    "Ended By Nilay B. 05.08.2023

    ls_final_eway-doctype    = ls_final-doc_type.
    IF ls_final-xblnr IS NOT INITIAL.
      ls_final_eway-docno    = ls_final-xblnr.
    ELSE.
      ls_final_eway-docno    = ls_final-doc_no.
    ENDIF.
    SHIFT ls_final_eway-docno LEFT DELETING LEADING '0'.
    ls_final_eway-docdate           = ls_final-doc_date .
    REPLACE ALL OCCURRENCES OF '-' IN ls_final_eway-docdate WITH '/'.

    ls_final_eway-fromgstin                 = ls_final-gstin. "'05AAACG5222D1ZA'.
    ls_final_eway-dispatchfromgstin         =  ls_final-gstin.
*    BREAK primus.
    IF ls_final_eway-fromgstin IS INITIAL.
      MESSAGE e002(zinv_message).
    ENDIF.

    ls_final_eway-fromtrdname       = ls_final-name1.
    ls_final_eway-dispatchfromtradename       = ls_final-name1. "If kunag and kunnr is same.

    ls_final_eway-fromaddr1         = ls_final-street.
    ls_final_eway-fromaddr2         = ls_final-str_suppl3.
    ls_final_eway-fromplace         = ls_final-location.
    ls_final_eway-frompincode       = ls_final-post_code1.

    READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ls_final-from_state.
    IF sy-subrc = 0.
      ls_final_eway-fromstatecode     = ls_statecode-legal_state_code.  "'5'.
      ls_final_eway-actfromstatecode  =  ls_statecode-legal_state_code.

      IF ls_statecode-legal_state_code < 10.
        SHIFT ls_final_eway-fromstatecode LEFT DELETING LEADING '0'.
        SHIFT ls_final_eway-actfromstatecode LEFT DELETING LEADING '0'.
      ENDIF.

      CLEAR ls_statecode.
    ENDIF.

    IF ls_final_eway-fromstatecode IS INITIAL.
      MESSAGE e001(zinv_message).
    ENDIF.

    ls_final_eway-togstin           = ls_final-to_gstin. "For testing purpose hardcoded '29AAACW6874H1ZS'
    ls_final_eway-shiptogstin       = ls_final-to_gstin. "If kunag and kunnr is same. For testing purpose hardcoded '29AAACW6874H1ZS'.

    IF ls_final_eway-togstin IS INITIAL.
      MESSAGE e001(zinv_message).
    ENDIF.

    REPLACE ALL OCCURRENCES OF '&' IN ls_final-ship_to_party WITH ''.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-ship_to_party WITH ''.
    ls_final_eway-totrdname         = ls_final-ship_to_party.
    ls_final_eway-shiptotradename   = ls_final-ship_to_party. "If kunag and kunnr is same.
*    BREAK primus.
    ls_final_eway-toaddr1           = ls_final-to_add1.
    REPLACE ALL  OCCURRENCES OF ',' IN ls_final_eway-toaddr1 WITH space.
    REPLACE ALL  OCCURRENCES OF '\' IN ls_final_eway-toaddr1 WITH space.
    REPLACE ALL  OCCURRENCES OF '/' IN ls_final_eway-toaddr1 WITH space.
    REPLACE ALL  OCCURRENCES OF '&' IN ls_final_eway-toaddr1 WITH space.
    ls_final_eway-toaddr2           = ls_final-to_add2.
    REPLACE ALL  OCCURRENCES OF ',' IN ls_final_eway-toaddr2 WITH space.
    REPLACE ALL  OCCURRENCES OF '\' IN ls_final_eway-toaddr2 WITH space.
    REPLACE ALL  OCCURRENCES OF '/' IN ls_final_eway-toaddr2 WITH space.
    REPLACE ALL  OCCURRENCES OF '&' IN ls_final_eway-toaddr2 WITH space.
    ls_final_eway-toplace           = ls_final-to_place.  "For testing purpose hardcoded "'JALANDHAR'
    REPLACE ALL  OCCURRENCES OF ',' IN ls_final_eway-toplace WITH space.

* Commented on 22.12.2022 Start...
*     IF ls_vbrk_j-FKART = 'ZFOC' AND ls_vbrk_j-WAERK <> 'INR' AND ls_vbrk_j-LAND1 <> 'IN'.
*       ls_final_eway-topincode = '999999'.
*       ELSE.
* Commented on 22.12.2022 End...
    ls_final_eway-topincode         = ls_final-to_pincode. " For testing purpose hardcoded  '560009'.
* Commented on 22.12.2022 Start...
*     ENDIF.
* Commented on 22.12.2022 End...

    READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ls_final-to_state.
    IF sy-subrc = 0.

* Commented on 22.12.2022 Start...
*************************added by diksha
*      IF ls_vbrk_j-FKART = 'ZFOC' AND ls_vbrk_j-WAERK <> 'INR' AND ls_vbrk_j-LAND1 <> 'IN'.
*        ls_final_eway-tostatecode = '96'.
*         ls_final_eway-acttostatecode = '96'.
*         ELSE.
***********************
* Commented on 22.12.2022 End...
      ls_final_eway-tostatecode     = ls_statecode-legal_state_code. "29 For testing purpose hardcoded
      ls_final_eway-acttostatecode  =  ls_statecode-legal_state_code.  "29 For testing purpose hardcoded
* Commented on 22.12.2022 Start...
*      endif.
* Commented on 22.12.2022 End...

*      BREAK primus.
      SELECT SINGLE fkart FROM vbrk INTO @DATA(lv_fkart) WHERE vbeln = @ls_final-doc_no.

*      IF lv_fkart = 'ZDEX'.
*
*        ls_final_eway-tostatecode =  '37'.                       "'99'. (99 commented and 37 added )           " '96'.

      "Added By Nilay B. 05.09.2023
      IF lv_fkart = 'ZDC'.
        ls_final_eway-subsupplydesc    = 'Delivery Challan'.


      ENDIF.
*****************************************ADDED BY DIKSHA   "commented 18.10
*      ELSEIF lv_fkart = 'ZFOC' AND ls_vbrk_j-WAERK <> 'INR' AND ls_vbrk_j-LAND1 <> 'IN'.
*
*        ls_final_eway-tostatecode =  '96'.
***********************************************************
*      ENDIF.

      IF ls_statecode-legal_state_code < 10.
        SHIFT ls_final_eway-tostatecode LEFT DELETING LEADING '0'.
        SHIFT ls_final_eway-acttostatecode LEFT DELETING LEADING '0'.
      ENDIF.

      IF ship_state IS NOT INITIAL.
        READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ship_state.
        IF sy-subrc = 0.
          ls_final_eway-acttostatecode  =  ls_statecode-legal_state_code.  "29 For testing purpose hardcoded
        ENDIF.
      ENDIF.

      IF ls_statecode-legal_state_code < 10.
        SHIFT ls_final_eway-tostatecode LEFT DELETING LEADING '0'.
        SHIFT ls_final_eway-acttostatecode LEFT DELETING LEADING '0'.
      ENDIF.
      CLEAR ls_statecode.
    ENDIF.

    IF ls_final-order_type = 'ZEXP'.
      ls_final_eway-tostatecode = '99'.
*      ls_final_eway-acttostatecode = '96'.

***************ADDED BY DIKSHA   "commented 18.10
*     ELSEIF ls_final-order_type = 'ZFEX' AND ls_vbrk_j-WAERK <> 'INR' AND ls_vbrk_j-LAND1 <> 'IN'.
*        ls_final_eway-tostatecode = '96'.
    ENDIF.
*************************************

    ls_final_eway-totalvalue        = ls_final-total_val + ls_final_eway-totalvalue.
*******************ADDED BY JYOTI ON 18.062024
    IF ls_final-order_type = 'ZDC'.
      ls_final-total_val = gv_total_value.
      ls_final_eway-totalvalue        =  ls_final-total_val.
    ENDIF.
**************************************************************
*    IF ls_final-total_val IS INITIAL.
*      ls_final_eway-totalvalue        = 'null' .
*    ENDIF.
*
*    ls_final_eway-totinvvalue        = ls_final-total_val .
*    IF ls_final-total_val IS INITIAL.
*      ls_final_eway-totinvvalue        = 'null' .
*    ENDIF.


    ls_final_eway-othvalue          = ls_final_eway-othvalue + ls_final-othvalue.
    ls_final_eway-cgstvalue         = ls_final_eway-cgstvalue + ls_final-cgst_amt.
    ls_final_eway-sgstvalue         = ls_final_eway-sgstvalue + ls_final-sgst_amt.
    ls_final_eway-igstvalue         = ls_final_eway-igstvalue + ls_final-igst_amt.

    ls_final_eway-cessvalue         = ls_final-cess_amt.

*    IF ls_final_eway-cessvalue IS INITIAL.
*      ls_final_eway-cessvalue = 'null'.
*    ENDIF.
*
*    ls_final_eway-totnonadvolval    = 'null'. "ls_final-


    READ TABLE lt_vbrk_j INTO ls_vbrk_j WITH KEY vbeln = ls_final-doc_no.
    IF sy-subrc = 0.
      IF ls_vbrk_j-mwsbk LT 0 .
        ls_vbrk_j-mwsbk = ls_vbrk_j-mwsbk * -1.
      ENDIF.
*
      IF ls_vbrk_j-netwr LT 0.
        ls_vbrk_j-netwr = ls_vbrk_j-netwr * -1.
      ENDIF.
*ls_final_eway-KUNAG = ls_vbrk_j-KUNAG.                        "ADDED BY aNIKET 06.07.2023
      totinvvalue = ls_vbrk_j-mwsbk + ls_vbrk_j-netwr.
      ls_final_eway-totinvvalue    = totinvvalue. "ls_vbrk_j-mwsbk + ls_vbrk_j-netwr." + ls_final_eway-totinvvalue. "ls_final-
*      ls_final_eway-totinvvalue    = ls_vbrk_j-mwsbk + ls_vbrk_j-netwr." + ls_final_eway-totinvvalue. "ls_final-


      IF ls_final-order_type = 'ZFRS'.
        totinvvalue = ls_vbrk_j-netwr.
        ls_final_eway-totinvvalue       = totinvvalue.    " ls_vbrk_j-netwr.
*    ls_final_eway-totinvvalue       =  ls_vbrk_j-netwr.

      ENDIF.

      IF ls_final-order_type = 'ZEXP'.
        totinvvalue = totinvvalue * ls_vbrk_j-kurrf.
        ls_final_eway-totinvvalue =   totinvvalue.  " ls_final_eway-totinvvalue * ls_vbrk_j-kurrf.
*        ls_final_eway-totinvvalue = ls_final_eway-totinvvalue * ls_vbrk_j-kurrf.
      ENDIF.
*      ls_final_eway-totalvalue        = ls_vbrk_j-mwsbk + ls_vbrk_j-netwr. "ls_final-
*      CLEAR ls_vbrk_j.
**************************ADDED BY JYOTI ON 18.06.2024****************
      IF ls_final-order_type = 'ZDC'.
        totinvvalue = ls_final-total_val.
        ls_final_eway-totinvvalue =   totinvvalue.
      ENDIF.

*****************************************************************************
*****************************************************************************BR
* Code changes: Bug Fix for ZFOC Exports Scenario: 17.10.2022 Start...
      IF ls_vbrk_j-fkart EQ 'ZFOC' AND ls_vbrk_j-waerk NE 'INR' AND ls_vbrk_j-land1 NE 'IN'.
        ls_final_eway-subsupplytype  = '3'.
        ls_final_eway-tostatecode    = '99'.
*        ls_final_eway-doctype        = 'INV'.
*        ls_final_eway-acttostatecode = '96'.
*        ls_final_eway-topincode      = '999999'.
      ENDIF.
* Code changes: Bug Fix for ZFOC Exports Scenario: 17.10.2022 End...

    ENDIF.


    IF ls_final-order_type = 'ZEXP'.
      ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_final_eway-cgstvalue + ls_final_eway-sgstvalue + ls_final_eway-igstvalue." + ls_final_eway-othvalue.
    ENDIF.

    IF lv_fkart = 'ZDC'. "added by Nilay On 06.09.2023
      ls_final_eway-cgstvalue  = '0'.
      ls_final_eway-sgstvalue = '0'.
      ls_final_eway-igstvalue = '0'..

    ENDIF.

    ."1 = 'Road' 2 ='Rail 3 = Air 4 = Ship '
*    IF ls_final_eway-cgstvalue IS INITIAL.
*      ls_final_eway-cgstvalue = 'null'.
*      ls_final_eway-sgstvalue = 'null'.
*    ENDIF.

*    IF ls_final_eway-igstvalue IS INITIAL.
*      ls_final_eway-igstvalue = 'null'.
*    ENDIF.
*    IF ls_final_eway-othvalue IS INITIAL.
*      ls_final_eway-othvalue          = 'null'. "ls_final-
*    ENDIF.


*    BREAK primus.
    CASE ls_final-trans_mode.
      WHEN 'ROAD'.
        ls_final_eway-transmode         = '1' .
      WHEN 'RAIL'.
        ls_final_eway-transmode         = '2' .
      WHEN 'AIR'.
        ls_final_eway-transmode         = '3' .
      WHEN 'SHIP'.
        ls_final_eway-transmode         = '4' .
      WHEN OTHERS.
*        ls_final_eway-transmode         = 'null' .
        ls_final_eway-transmode         = '1' .
    ENDCASE.



    IF ls_final-distance_level IS NOT INITIAL.
      ls_final_eway-transdistance = round( val = ls_final-distance_level dec = 0 ).
      REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-transdistance WITH space.
      CONDENSE ls_final_eway-transdistance NO-GAPS.
    ELSE.
      ls_final_eway-transdistance     = 0.
    ENDIF.

    ls_final_eway-transportername   = ls_final-trans_name.
    ls_final_eway-transporterid     = ls_final-transport_id.
    ls_final_eway-transdocno        = ls_final-trans_doc_no.
    ls_final_eway-transdocdate      = ls_final-trans_date.

    IF ls_final-trans_date EQ '00000000' OR ls_final-trans_date IS INITIAL.
*      ls_final_eway-transdocdate     = 'null'.
      CLEAR ls_final_eway-transdocdate.
    ELSE.
*      ls_final_eway-transdocdate      = ls_final-trans_date.
*      CONCATENATE ls_final_eway-transdocdate+6(2) '/' ls_final_eway-transdocdate+4(2) '/' ls_final_eway-transdocdate+0(4)
      CONCATENATE ls_final_eway-transdocdate+6(2) '-' ls_final_eway-transdocdate+4(2) '-' ls_final_eway-transdocdate+0(4)
         INTO DATA(lv_date).
      ls_final_eway-transdocdate = lv_date.
    ENDIF.

    ls_final_eway-vehicleno         = ls_final-vehicle_no.
*    ls_final_eway-vehicletype       = ls_final-vehicletype.

    IF ls_final-vehicletype = 'Regular'.
      ls_final_eway-vehicletype = 'R'.
    ELSEIF ls_final-vehicletype = 'ODC'.
      ls_final_eway-vehicletype = 'O'.
    ENDIF.

    IF ls_final_eway-vehicleno IS NOT INITIAL.
*      ls_final_eway-vehicletype       = 'O'.
    ENDIF.
    ls_final_eway-transactiontype = '4'.


*    IF ls_final_eway-transportername IS INITIAL.
*      ls_final_eway-transportername = 'null'.
*    ENDIF.
*
*    IF ls_final_eway-transdocno IS INITIAL.
*      ls_final_eway-transdocno = 'null'.
*    ENDIF.
*
*    IF ls_final_eway-transdocdate IS INITIAL.
*      ls_final_eway-transdocdate = 'null'.
*    ENDIF.
*
*    IF ls_final_eway-vehicleno IS INITIAL.
*      ls_final_eway-vehicleno = 'null'.
*    ENDIF.
*
*    IF ls_final_eway-vehicletype IS INITIAL.
*      ls_final_eway-vehicletype  = 'null'.
*    ENDIF.
*    IF ls_final-transport_id IS NOT INITIAL.
*
*    ELSE.
*      ls_final_eway-transporterid     = 'null'.
*    ENDIF.

*    IF ls_final-trans_doc_no IS NOT INITIAL.
*      ls_final_eway-transdocno        = ls_final-trans_doc_no.
*    ELSE.
*      ls_final_eway-transdocno     = 'null'.
*    ENDIF.



*    IF ls_final_eway-portpin IS INITIAL.
*      ls_final_eway-portpin     = 'null'.
*    ENDIF.
*
*    IF ls_final_eway-portname IS INITIAL.
*      ls_final_eway-portname     = 'null'.
*    ENDIF.









    ls_final_eway-mainhsncode       = ls_final-hsn_sac.
    REPLACE ALL   OCCURRENCES OF '.' IN ls_final_eway-mainhsncode WITH space.
    CONDENSE ls_final_eway-mainhsncode NO-GAPS.

    LOOP AT lt_json_data INTO DATA(ls_final1) WHERE doc_no = ls_final-doc_no.

      ls_itemlist-itemno          = ls_final1-posnr.
      ls_itemlist-productname    = ls_final1-material.
      ls_itemlist-productdesc    = ls_final1-arktx.
      REPLACE ALL  OCCURRENCES OF ',' IN ls_itemlist-productdesc WITH space.
      REPLACE ALL  OCCURRENCES OF '\' IN ls_itemlist-productdesc WITH space.
      REPLACE ALL  OCCURRENCES OF '/' IN ls_itemlist-productdesc WITH space.
      REPLACE ALL  OCCURRENCES OF '&' IN ls_itemlist-productdesc WITH space.
      ls_itemlist-hsncode        = ls_final1-hsn_sac.
      REPLACE ALL OCCURRENCES OF '.' IN ls_itemlist-hsncode WITH space.
      CONDENSE ls_itemlist-hsncode NO-GAPS.

*      IF ls_itemlist-hsncode IS INITIAL.
*        ls_itemlist-hsncode = 'null'.
*      ENDIF.

      ls_itemlist-quantity       = ls_final1-quantity.
*      ls_itemlist-qtyunit        = ls_final1-uqc.
      CALL FUNCTION 'ZEINV_UNIT_CONVERT'
        EXPORTING
          vrkme = ls_final1-uqc
        IMPORTING
          unit  = ls_itemlist-qtyunit.
*                .


      ls_itemlist-taxableamount  = ls_final1-taxable_value.
      ls_itemlist-sgstrate       = ls_final1-sgst_rate.
      CONDENSE ls_itemlist-sgstrate NO-GAPS.
      ls_itemlist-cgstrate       = ls_final1-cgst_rate.
      CONDENSE ls_itemlist-cgstrate NO-GAPS.
      ls_itemlist-igstrate       = ls_final1-igst_rate.
      CONDENSE ls_itemlist-igstrate NO-GAPS.
      ls_itemlist-cessrate       = ls_final1-cess_rate.
      CONDENSE ls_itemlist-cessrate NO-GAPS.

*      ls_itemlist-cessnonadvol   = 'null'.
      IF lv_fkart = 'ZDEX'. "added by Ajay
        ls_itemlist-igstrate  = '0'.

      ENDIF.

*      BREAK primus.
      APPEND ls_itemlist TO lt_itemlist.
      CLEAR : ls_itemlist,gv_kunag,gv_fkart.

    ENDLOOP.

    ls_final_eway-itemlist = lt_itemlist.

    REFRESH lt_itemlist.

    IF lv_fkart = 'ZDEX'.
      ls_final_eway-igstvalue = '0'.

    ENDIF.

*     BREAK-POINT.
    IF lv_fkart = 'ZDC'. "added by Nilay On 06.09.2023
      ls_itemlist-igstrate  = '0'.
      ls_itemlist-cgstrate = '0'.
      ls_itemlist-sgstrate = '0'..

    ENDIF.

    APPEND ls_final_eway TO lt_final_eway.
    CLEAR : gv_kunag, gv_fkart.
  ENDLOOP.





  """""""End of JSON DATA"""""""""""""""""""
  DATA : lv_trex_json TYPE string.
  """"""""" Conversion of final to JSON format"""""""""""'

  CALL FUNCTION 'ZEWAY_BILL_JSON'
    EXPORTING
      data      = ls_final_eway
    IMPORTING
      trex_json = lv_trex_json.

  IF sy-subrc IS INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.

  DATA : lv_srno TYPE string VALUE 'itemno'.
*  DATA : lv_tax TYPE string VALUE 'supplytype'.
  DATA : lv_tax TYPE string VALUE 'zstyp'.
  DATA : cnt TYPE i VALUE 45.
  DATA : cnt_tax TYPE i VALUE 0.
  DATA : lv_flag(01) TYPE c.

  LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
    IF ls_json-line CS lv_tax.
      cnt_tax = 0.
      ls_json-tabix = cnt_tax.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_srno.
      cnt_tax = cnt_tax + 1.
      ls_json-tabix = cnt_tax.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.
    CLEAR ls_json.
*  clear <lfs_assign>.
  ENDLOOP.

  CLEAR :  sy-tabix , lv_flag .

  LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
    IF ls_json-line CS lv_srno.
      cnt = 46.
      ls_json-tabix = cnt.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_tax.
      cnt = cnt + 1.
      ls_json-tabix = cnt.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.
    CLEAR ls_json.
*  clear <lfs_assign>.
  ENDLOOP.
*  BREAK primus.
  """"""""""""""""""""""""""""""""""""""""""Commented by MT """"""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).
***    REPLACE all OCCURRENCES OF '",' in <lfs_json_main> WITH ',"'.
    CASE <lfs_json_main>-tabix.
*    CASE <lfs_json_main>-index.
*****      WHEN '1'. "Excelon
*****        REPLACE 'usergstin'            IN <lfs_json_main> WITH '"userGstin"'.
      WHEN '1'.
        REPLACE 'zstyp'           IN <lfs_json_main> WITH '"supplyType"'.
      WHEN '2'.
        " REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'subsupplytype'        IN <lfs_json_main> WITH '"subSupplyType"'.
      WHEN '3'.
        REPLACE 'subsupplydesc'        IN <lfs_json_main> WITH '"subSupplyDesc"'.

      WHEN '4'.
        REPLACE 'doctype'              IN <lfs_json_main> WITH '"docType"'.
      WHEN '5'.
        REPLACE 'docno'                IN <lfs_json_main> WITH '"docNo"'.
      WHEN '6'.
        REPLACE 'docdate'              IN <lfs_json_main> WITH '"docDate"'.
      WHEN '7'.
        REPLACE 'fromgstin'            IN <lfs_json_main> WITH '"fromGstin"'.
      WHEN '8'.
        REPLACE 'fromtrdname'          IN <lfs_json_main> WITH '"fromTrdName"'.
      WHEN '9'.
        REPLACE 'fromaddr1'            IN <lfs_json_main> WITH '"fromAddr1"'.
      WHEN '10'.
        REPLACE 'fromaddr2'            IN <lfs_json_main> WITH '"fromAddr2"'.
      WHEN '11'.
        REPLACE 'fromplace'            IN <lfs_json_main> WITH '"fromPlace"'.
      WHEN '12'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'frompincode'          IN <lfs_json_main> WITH '"fromPincode"'.
      WHEN '13'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'fromstatecode'        IN <lfs_json_main> WITH '"fromStateCode"'.
      WHEN '14'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'actfromstatecode'  IN <lfs_json_main> WITH '"actFromStateCode"'.
      WHEN '15'.
        REPLACE 'togstin'              IN <lfs_json_main> WITH '"toGstin"'.
      WHEN '16'.
        REPLACE 'totrdname'            IN <lfs_json_main> WITH '"toTrdName"'.
      WHEN '17'.
        REPLACE 'toaddr1'              IN <lfs_json_main> WITH '"toAddr1"'.
      WHEN '18'.
        REPLACE 'toaddr2'              IN <lfs_json_main> WITH '"toAddr2"'.
      WHEN '19'.
        REPLACE 'toplace'              IN <lfs_json_main> WITH '"toPlace"'.
      WHEN '20'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'topincode'            IN <lfs_json_main> WITH '"toPincode"'.
      WHEN '21'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'tostatecode'          IN <lfs_json_main> WITH '"toStateCode"'.
      WHEN '22'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'acttostatecode'    IN <lfs_json_main> WITH '"actToStateCode"'.
      WHEN '23'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totalvalue'           IN <lfs_json_main> WITH '"totalValue"'.
      WHEN '24'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'transactiontype'           IN <lfs_json_main> WITH '"transactionType"'.
      WHEN '25'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cgstvalue'            IN <lfs_json_main> WITH '"cgstValue"'.
      WHEN '26'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'sgstvalue'            IN <lfs_json_main> WITH '"sgstValue"'.
      WHEN '27'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'igstvalue'            IN <lfs_json_main> WITH '"igstValue"'.
      WHEN '28'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cessvalue'            IN <lfs_json_main> WITH '"cessValue"'.
      WHEN '29'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totnonadvolval'       IN <lfs_json_main> WITH '"TotNonAdvolVal"'.
      WHEN '30'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'othvalue'             IN <lfs_json_main> WITH '"OthValue"'.
      WHEN '31'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totinvvalue'          IN <lfs_json_main> WITH '"totInvValue"'.
      WHEN '32'.
*        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transmode'            IN <lfs_json_main> WITH '"transMode"'.
      WHEN '33'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transdistance'        IN <lfs_json_main> WITH '"transDistance"'.
      WHEN '34'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transportername'      IN <lfs_json_main> WITH '"transporterName"'.
      WHEN '35'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transporterid'        IN <lfs_json_main> WITH '"transporterId"'.
      WHEN '36'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transdocno'           IN <lfs_json_main> WITH '"transDocNo"'.
      WHEN '37'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transdocdate'         IN <lfs_json_main> WITH '"transDocDate"'.
      WHEN '38'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'vehicleno'            IN <lfs_json_main> WITH '"vehicleNo"'.
      WHEN '39'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'vehicletype'          IN <lfs_json_main> WITH '"vehicleType"'.
      WHEN '40'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE ALL OCCURRENCES OF '.' IN <lfs_json_main> WITH space.
        REPLACE 'mainhsncode'          IN <lfs_json_main> WITH '"mainHsnCode"'.
      WHEN '41'.
        REPLACE 'shiptogstin'          IN <lfs_json_main> WITH '"shipToGstin"'.

      WHEN '42'.
        REPLACE 'shiptotradename'          IN <lfs_json_main> WITH '"shipToTradename"'.

      WHEN '43'.
        REPLACE 'dispatchfromgstin'          IN <lfs_json_main> WITH '"dispatchFromGstin"'.

      WHEN '44'.
        REPLACE 'dispatchfromtradename'          IN <lfs_json_main> WITH '"dispatchFromTradename"'.

      WHEN '45'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'portpin'          IN <lfs_json_main> WITH '"portPin"'.

      WHEN '46'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'portname'          IN <lfs_json_main> WITH '"portName"'.

      WHEN '47'.
        REPLACE 'itemno'               IN <lfs_json_main> WITH '"itemNo"'.
        REPLACE 'itemlist'               IN <lfs_json_main> WITH '"itemList"'.
      WHEN '48'.
        REPLACE 'productname'          IN <lfs_json_main> WITH '"productName"'.
      WHEN '49'.
        REPLACE 'productdesc'          IN <lfs_json_main> WITH '"productDesc"'.
      WHEN '50'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE ALL OCCURRENCES OF '.' IN <lfs_json_main> WITH space.
        REPLACE 'hsncode'              IN <lfs_json_main> WITH '"hsnCode"'.
      WHEN '51'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'quantity'             IN <lfs_json_main> WITH '"quantity"'.
      WHEN '52'.
        REPLACE 'qtyunit'              IN <lfs_json_main> WITH '"qtyUnit"'.
      WHEN '53'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'taxableamount'        IN <lfs_json_main> WITH '"taxableAmount"'.
      WHEN '54'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'sgstrate'             IN <lfs_json_main> WITH '"sgstRate"'.
      WHEN '55'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cgstrate'             IN <lfs_json_main> WITH '"cgstRate"'.
      WHEN '56'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'igstrate'             IN <lfs_json_main> WITH '"igstRate"'.
      WHEN '57'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cessrate'             IN <lfs_json_main> WITH '"cessRate"'.
      WHEN '58'.
        "REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'cessnonadvol'         IN <lfs_json_main> WITH '"cessNonAdvol"'.

    ENDCASE.
  ENDLOOP.
  """"""""""""""""""""""""""""""""""""""""""""""""""""""" End """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  DATA : ls_str TYPE string.
  DATA : lv_gstin TYPE string.

  DATA :ewaybill_no   TYPE string,
        ewaybill_date TYPE string,
        valid_upto    TYPE string,
        status        TYPE char1,
        msg           TYPE string,
        alert         TYPE string.


  """"""""""""""""""""""""""""""""""""""""""""""' API  CODE """"""""""""""""""""""""""""""

  CLEAR : ls_str.
  REFRESH : lt_json_output.


  LOOP AT it_json INTO ls_json.

    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.
    CLEAR :  ls_json , ls_json_output.

  ENDLOOP.

  lv_gstin = gstin.

  CONDENSE ls_str NO-GAPS.

**DOWNLOAD FILE
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = file_name "'C:/desktop/E-INVOICE.json'
    CHANGING
      data_tab = lt_json_output "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
               TYPE 'I'.
  ENDIF.

  .
*  BREAK primus.
  CLEAR ls_final_eway.   "AJAY.....

  PERFORM auth.
*****  REPLACE ALL OCCURRENCES OF '"' IN ls_str WITH '\\\"'.

  CLEAR ls_json_output-line .

  CONCATENATE '{"action": "GENEWAYBILL", "data":' ls_str '}' INTO ls_str.
  REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
  CONCATENATE ls_str '}' INTO ls_str.
*REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
  CONDENSE ls_str.


  """"""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""

  DATA :tokan TYPE string.

  CLEAR :tokan.

  READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
  tokan = ls_ein_tokan-value.
  CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

  DATA xconn TYPE string.
  CLEAR: xconn.

*  xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'. """"""""""""" PRD
*  xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AAACG5222D1ZA'.
xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180519134451:27GSPMH2101G1Z2'. "DEV


  DATA lv_url TYPE string.

**  lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."DEV
*  lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'. """"""""" PRD
  lv_url = 'https://qa.gsthero.com/ewb/enc/v1.03/ewayapi'. """""""""

  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url
    IMPORTING
      client             = DATA(lo_http_client)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).


  lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json'.

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = tokan ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Action'
      value = 'GENEWAYBILL' ).


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'gstin'
*      value = '27AACCD2898L1Z4' ).  """"""" PRD
   value = '05AAACG5222D1ZA' ). "DEV

  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'X-Connector-Auth-Token'
      value = xconn ).


  lo_http_client->request->set_method(
    EXPORTING
      method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
    EXPORTING
      data = ls_str ).


  lo_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).

*  BREAK primus.
  CHECK sy-subrc = 0.
  DATA(lv_response) = lo_http_client->response->get_cdata( ).

  REPLACE ALL OCCURRENCES OF '{"data":{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{"error":[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.

  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 1000 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.

  READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
  IF sy-subrc EQ 0.
    lv_resp_status = ls_res-value.
  ENDIF.

  IF lv_resp_status = '1'.


    LOOP AT lt_res ASSIGNING FIELD-SYMBOL(<f2>).
*      REPLACE ALL  OCCURRENCES OF '\' IN <f2>-value WITH ''.
*      REPLACE ALL  OCCURRENCES OF '{' IN <f2>-value WITH ''.
*      REPLACE ALL  OCCURRENCES OF '/' IN <f2>-value WITH ''.

      IF <f2>-header CS 'ewayBillNo'.
        lv_ewaybill = <f2>-value.
      ENDIF.

      IF <f2>-header CS 'ewayBillDate'.
*  IF ewaybill_date IS NOT INITIAL.
        lv_ewaybill_dt = <f2>-value+0(10).
        CONCATENATE lv_ewaybill_dt+6(4) lv_ewaybill_dt+3(2) lv_ewaybill_dt+0(2) INTO lv_ewaybill_dt.

        lv_ewaybill_tm = <f2>-value+11(11).
        CONCATENATE lv_ewaybill_tm+0(2) lv_ewaybill_tm+3(2) lv_ewaybill_tm+6(2) INTO lv_ewaybill_time.
        MOVE lv_ewaybill_time TO lv_vdfmtime.
        IF lv_ewaybill_tm+9(2) = 'PM'.
          CALL FUNCTION 'HRVE_CONVERT_TIME'
            EXPORTING
              type_time       = 'B'
              input_time      = lv_vdfmtime
              input_am_pm     = 'PM'
            IMPORTING
              output_time     = lv_vdfmtime
            EXCEPTIONS
              parameter_error = 1
              OTHERS          = 2.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
        ENDIF.

      ENDIF.
*
*  ENDIF.
*      ENDIF.
*
      IF <f2>-header CS 'validUpto'.
        IF <f2>-value NE 'null'.
*  IF valid_upto IS NOT INITIAL.
          lv_ewaybill_exdt = <f2>-value+0(10).
          CONCATENATE lv_ewaybill_exdt+6(4) lv_ewaybill_exdt+3(2) lv_ewaybill_exdt+0(2) INTO lv_ewaybill_exdt.

          lv_ewaybill_extm = <f2>-value+11(11).
          CONCATENATE lv_ewaybill_extm+0(2) lv_ewaybill_extm+3(2) lv_ewaybill_extm+6(2) INTO lv_ewaybill_extime.



          MOVE lv_ewaybill_extime TO lv_vdtotime.
          IF lv_ewaybill_extm+9(2) = 'PM'.
            CALL FUNCTION 'HRVE_CONVERT_TIME'
              EXPORTING
                type_time       = 'B'
                input_time      = lv_vdtotime
                input_am_pm     = 'PM'
              IMPORTING
                output_time     = lv_vdtotime
              EXCEPTIONS
                parameter_error = 1
                OTHERS          = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*        ENDIF.
*      ENDIF.
*
    ENDLOOP.
*  ENDIF.  "commented by swati

  ELSE.
    READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.                "INDEX 5.
    IF sy-subrc EQ 0.
      msg = ls_res-value.
    ENDIF.
  ENDIF.
  LOOP AT lt_final ASSIGNING FIELD-SYMBOL(<f3>) WHERE selection = 'X'.

    IF lv_ewaybill IS NOT INITIAL.
      <f3>-process_status = TEXT-003. "'@08\Q Completly Processed@'.
      <f3>-status_description = TEXT-004. "'Completly Processed'.

      <f3>-eway_bil =   lv_ewaybill.
      <f3>-eway_dt  =   lv_ewaybill_dt.
      <f3>-vdfmtime = lv_vdfmtime.
      <f3>-eway_dt_exp = lv_ewaybill_exdt.
      <f3>-vdtotime   = lv_vdtotime.
      <f3>-message = ' Eway Bill Sucessfully Generated'.
      <f3>-veh_no = ls_eway_bill-vehical_no.
      <f3>-created_by = sy-uname.
      <f3>-created_dt = sy-datum.
      <f3>-created_time = sy-uzeit.

      ls_eway_number-vbeln          =  <f3>-vbeln.
      ls_eway_number-eway_bill      =  <f3>-eway_bil.
*      ls_eway_number-CONEWAYNO      =
      ls_eway_number-ewaybilldate   = <f3>-eway_dt.
      ls_eway_number-vdfmtime       = lv_vdfmtime.
      ls_eway_number-validuptodate  = <f3>-eway_dt_exp.
      ls_eway_number-vdtotime       = <f3>-vdtotime.
      ls_eway_number-zzstatus       = 'C'.
      ls_eway_number-message        =  <f3>-message.
      ls_eway_number-createdby      = <f3>-created_by.
      ls_eway_number-creationdt     = <f3>-created_dt.
      ls_eway_number-creationtime   = <f3>-created_time.
    ELSE.
      <f3>-process_status = TEXT-009. "'@0A\Q Error!@'.
      <f3>-status_description = TEXT-010. "'Error'.
      ls_eway_number-vbeln          = <f3>-vbeln.
      ls_eway_number-zzstatus       = 'E'.
      <f3>-message = msg.
      ls_eway_number-message        =  msg.
    ENDIF.

    APPEND ls_eway_number TO lt_eway_number.
    CLEAR : ls_eway_number.
  ENDLOOP.

  LOOP AT lt_eway_number INTO ls_eway_number.
    SELECT SINGLE vbeln FROM zeway_number INTO @DATA(ls_vbeln) WHERE vbeln = @ls_eway_number-vbeln .
    IF sy-subrc = 0.
      UPDATE zeway_number SET eway_bill = ls_eway_number-eway_bill
                               conewayno = ls_eway_number-conewayno
                               ewaybilldate = ls_eway_number-ewaybilldate
                               vdfmtime   = ls_eway_number-vdfmtime
                               validuptodate = ls_eway_number-validuptodate
                               vdtotime = ls_eway_number-vdtotime
                               createdby = ls_eway_number-createdby
                               creationdt = ls_eway_number-creationdt
                               creationtime = ls_eway_number-creationtime
                               zzstatus = ls_eway_number-zzstatus
                               canreason = ls_eway_number-canreason
                               canceldt = ls_eway_number-canceldt
                               cancelremark = ls_eway_number-cancelremark
                               message = ls_eway_number-message
                          WHERE vbeln = ls_eway_number-vbeln.

    ELSE.
      MODIFY zeway_number FROM ls_eway_number.
    ENDIF.
  ENDLOOP.




  REFRESH: lt_response,lt_res,lt_eway_number,it_json,lt_json_data,lt_vbrp,lt_final_temp,gt_ewaybill_details,lt_final_eway.
  CLEAR : ls_str,lv_gstin,ls_res,ls_final_eway ,lv_response ,ls_final."AJAY ADDED LS_FINAL
  CLEAR :lv_trex_json,zeway_bill,lv_ewaybill,lv_ewaybill_dt,lv_ewaybill_exdt,lv_temp,gs_ewaybill_details.


  """"""""""""""""""""""""""""""""""""""""""""""""""""""'
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DETAILS_FOR_JSON_CREATE122
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_FINAL_VBELN  text
*      -->P_LS_FINAL_GJAHR  text
*----------------------------------------------------------------------*
FORM get_details_for_json_create122 USING belnr TYPE belnr_d
                                          gjahr TYPE gjahr.
*  BREAK primus.
  DATA : go_einvoice_utility TYPE REF TO zcl_einvoice_utility.

  DATA : lt_sel_addr TYPE TABLE OF zeinv_adrc,
         ls_sel_addr TYPE zeinv_adrc,

         lt_dis_addr TYPE TABLE OF zeinv_adrc,
         ls_dis_addr TYPE zeinv_adrc,

         lt_buy_addr TYPE TABLE OF zeinv_adrc,
         ls_buy_addr TYPE zeinv_adrc,

         lt_shp_addr TYPE TABLE OF zeinv_adrc,
         ls_shp_addr TYPE zeinv_adrc.

  REFRESH : lt_rseg, lt_awkey,
            lt_bkpf, lt_kna1,
            it_adrc, it_adrc_cust, it_adrct,lt_eway_number,
            it_json,lt_json_data,lt_vbrp,lt_final_temp,lt_awkey.

  CREATE OBJECT go_einvoice_utility.

  CLEAR : ls_str,zeway_bill,lv_ewaybill,lv_ewaybill_dt,lv_ewaybill_exdt,lv_temp,gs_ewaybill_details.
  CLEAR : ls_rseg,ls_bkpf,ls_sel_addr,ls_dis_addr,ls_buy_addr,ls_shp_addr,ls_final_eway,ls_itemlist,ls_awkey, ls_rseg.
  DATA lc_belnr TYPE belnr_d.

  DATA : lv_date     TYPE string,
         lv_wrbtr    TYPE rseg-wrbtr,            ":100,
         lv_sgstrate TYPE p DECIMALS 9, "string,                                       ":5,
         lv_cgstrate TYPE p DECIMALS 9,                                         ":5,
         lv_igstrate TYPE p DECIMALS 9. "string,

  CLEAR :lv_date ,lv_wrbtr ,lv_sgstrate ,lv_cgstrate,lv_igstrate .





  lc_belnr = belnr.
*
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lc_belnr
    IMPORTING
      output = lc_belnr.


  SELECT belnr gjahr buzei ebeln 	ebelp	werks	matnr
         hsn_sac  menge meins wrbtr kschl xekbz lfbnr
         bukrs  xblnr mwskz FROM rseg INTO TABLE lt_rseg
*         WHERE bukrs IN s_bukrs
         WHERE belnr EQ lc_belnr
*         AND werks IN s_werks
         AND gjahr EQ gjahr
*         AND matnr IN s_matnr
  AND shkzg = 'H'.


  LOOP AT lt_rseg INTO ls_rseg.
    CONCATENATE ls_rseg-belnr ls_rseg-gjahr INTO ls_awkey.

    APPEND ls_awkey TO lt_awkey.
    CLEAR : ls_awkey.

    "added by sk: 22/11/2018
*      ls_belnr-lv_belnr = ls_rseg-belnr.
*    APPEND ls_belnr to lt_belnr.
*    CLEAR: ls_belnr.
  ENDLOOP.




  IF lt_awkey IS NOT INITIAL.
    SELECT  bukrs
            belnr
            gjahr
            blart
            budat
            bldat
            xblnr
            waers
            awkey
     FROM bkpf
     INTO CORRESPONDING FIELDS OF TABLE lt_bkpf
     FOR ALL ENTRIES IN lt_awkey
     WHERE awkey = lt_awkey-lv_awkey
    AND gjahr EQ gjahr.
*     AND budat IN s_budat .
  ENDIF.

*  "added : 22/11/2018
*  LOOP AT lt_bkpf INTO ls_bkpf.
*    ls_belnr-lv_belnr = ls_bkpf-awkey(10).
*    APPEND ls_belnr TO lt_belnr.
*    CLEAR ls_belnr.
*  ENDLOOP.
***********************


  IF lt_rseg IS NOT INITIAL.

    SELECT  mblnr,
            lfbnr,
            ebeln,
            bwart
      FROM mseg INTO TABLE @DATA(lt_mseg)
      FOR ALL ENTRIES IN @lt_rseg
      WHERE lfbnr = @lt_rseg-lfbnr
      AND ebeln = @lt_rseg-ebeln
    AND ebelp = @lt_rseg-ebelp.

    SELECT  mblnr
         lfbnr
         ebeln
         bwart
        "added
        budat_mkpf
        menge
   FROM mseg INTO CORRESPONDING FIELDS OF TABLE lt_mseg1
   FOR ALL ENTRIES IN lt_rseg
   WHERE lfbnr = lt_rseg-lfbnr
   AND ebeln = lt_rseg-ebeln
   AND ebelp = lt_rseg-ebelp
    AND bwart IN ( 122, 161 ).

    SELECT matnr,
           spras,
           maktx
      FROM makt INTO TABLE @DATA(lt_makt)
      FOR ALL ENTRIES IN @lt_rseg
      WHERE matnr = @lt_rseg-matnr
    AND spras = 'E'.

  ENDIF.
  IF lt_bkpf IS NOT INITIAL.

    SELECT bukrs, belnr, gjahr, buzei,
           buzid, koart, ktosl, txgrp, gsber,
           kunnr, matnr, werks, menge, meins,
           posn2, dmbtr, wrbtr, gvtyp, sgtxt, bupla, hsn_sac
           FROM bseg
           INTO TABLE @DATA(lt_bseg_122)
           FOR ALL ENTRIES IN @lt_bkpf
           WHERE belnr EQ @lt_bkpf-belnr
           AND   bukrs EQ @lt_bkpf-bukrs
    AND   gjahr EQ @lt_bkpf-gjahr.

    SELECT bukrs,
           belnr,
           lifnr,
           koart,
           gsber
      FROM bseg INTO TABLE @DATA(lt_bseg1)
      FOR ALL ENTRIES IN @lt_bkpf
      WHERE belnr = @lt_bkpf-belnr
      AND bukrs = @lt_bkpf-bukrs
      AND  gjahr = @lt_bkpf-gjahr
    AND koart = 'K'.

  ENDIF.

  IF lt_bseg1 IS NOT INITIAL.
    SELECT lifnr
           name1
      FROM lfa1 INTO TABLE lt_lfa1
      FOR ALL ENTRIES IN lt_bseg1
    WHERE lifnr = lt_bseg1-lifnr.
  ENDIF.

  IF lt_bseg_122  IS NOT INITIAL.
    SELECT *
      FROM bset
      INTO TABLE @DATA(lt_bset)
      FOR ALL ENTRIES IN  @lt_bseg_122
      WHERE belnr = @lt_bseg_122-belnr
        AND bukrs = @lt_bseg_122-bukrs
    AND gjahr = @lt_bseg_122-gjahr.

  ENDIF.

  IF lt_rseg IS NOT INITIAL.

    SELECT *
           FROM marc
           INTO TABLE @DATA(lt_marc)
         FOR ALL ENTRIES IN @lt_rseg
    WHERE matnr = @lt_rseg-matnr.

    SELECT matnr
           spras
           maktx
      FROM makt INTO TABLE lt_makt
      FOR ALL ENTRIES IN lt_rseg
      WHERE matnr = lt_rseg-matnr
    AND spras = 'E'.

  ENDIF.


  IF lt_bseg_122 IS NOT INITIAL.

    SELECT *
    FROM bset
    INTO TABLE lt_bset
    FOR ALL ENTRIES IN lt_bseg_122
    WHERE belnr = lt_bseg_122-belnr
    AND bukrs = lt_bseg_122-bukrs
    AND gjahr = lt_bseg_122-gjahr.



*    ENDIF.

*    IF lt_t005u IS NOT INITIAL.     "replaced by class
*      SELECT * FROM j_1istatecdm
*               INTO TABLE lt_j_1istatecdm
*               FOR ALL ENTRIES IN lt_t005u
*               WHERE land1  = lt_t005u-land1
*               AND std_state_code = lt_t005u-bland.
*
*    ENDIF.

*    IF lt_adrc IS NOT INITIAL.
*
*      SELECT * FROM adr2
*                INTO TABLE lt_adr2
*                FOR ALL ENTRIES IN lt_adrc
*                WHERE addrnumber = lt_adrc-addrnumber.
*
*      SELECT * FROM adr6
*               INTO TABLE lt_adr6
*               FOR ALL ENTRIES IN lt_adrc
*               WHERE addrnumber = lt_adrc-addrnumber.   "replaced by class
*    ENDIF.


  ELSE.
****    ls_retmsg-id = 'E'.
****    ls_retmsg-message = 'No Data Available'.
****    lv_error = 'X'.
****
****    APPEND ls_retmsg TO lt_retmsg.
****    CLEAR ls_retmsg.
    MESSAGE 'No item data Available' TYPE 'E'.
    EXIT.
    LEAVE LIST-PROCESSING.

  ENDIF.

*  ELSE.
*
*    ls_retmsg-id = 'E'.
*    ls_retmsg-message = 'No Data Available'.
*    lv_error = 'X'.
*    APPEND ls_retmsg TO lt_retmsg.
*    CLEAR ls_retmsg.
*    EXIT.
*    LEAVE LIST-PROCESSING.
*
*ENDIF.
  "=================================================Read Data==========================================="
*


*  LOOP AT lt_rseg INTO ls_rseg.

  SORT lt_bseg_122 BY buzei .
*  BREAK primus.
  LOOP AT lt_bkpf INTO ls_bkpf ."WITH KEY awkey = ls_awkey-lv_awkey gjahr = ls_rseg-gjahr.


    ls_final_eway-docno = ls_bkpf-belnr.
    "--INR Details

****    ls_final-version = '1.1'.
****    ls_final-irn = ''.



*trandtls
    "--TranDtls (Transaction Details)---------

****    ls_final-trandtls-taxsch = lc_taxsch.
****    ls_final-trandtls-suptyp = lc_catg.
****    ls_final-trandtls-regrev =  'N'.
****    ls_final-trandtls-ecmgstin = lc_null.           "'N'.

    "--DocDtls (Document Details)-----
*ztyp
    ls_final_eway-zstyp = 'O'.
    ls_final_eway-subsupplytype  = '1'.

****    IF ls_bkpf-blart = 'DG'.
    ls_final_eway-doctype = 'INV'.
****    ELSE.
****      ls_final-zdocdtls-ztyp = lc_doctyp_dr.
****    ENDIF.

*zno
****    IF lv_mode = 'M'.
    CLEAR ls_rseg.
    READ TABLE lt_rseg INTO ls_rseg WITH KEY belnr  = ls_bkpf-awkey+0(10) gjahr = ls_bkpf-gjahr.
    IF sy-subrc EQ 0.


      IF ls_bkpf-budat IS NOT INITIAL.
        CONCATENATE ls_bkpf-budat+6(02) '/' ls_bkpf-budat+4(02) '/' ls_bkpf-budat(04)  INTO lv_date. " ??????????????????????????????
        ls_final_eway-docdate = lv_date.



      ENDIF.

    ENDIF.




    READ TABLE lt_bseg_122 INTO DATA(ls_bseg_122) WITH KEY belnr = ls_bkpf-belnr." txgrp = ls_rseg-buzei+3(3).

    READ TABLE lt_bseg1 INTO DATA(ls_bseg1) WITH  KEY belnr = ls_bkpf-belnr.
    IF sy-subrc = 0.


      CALL METHOD go_einvoice_utility->get_adrc_data
        EXPORTING
          iv_werks    = ls_bseg_122-bupla
          iv_kunnr    = ls_bseg1-lifnr
*         is_likp     =
*         iv_invtyp   =
          iv_bukrs    = ls_bseg_122-bukrs
          iv_bupla    = ls_bseg1-gsber
        CHANGING
          es_sel_addr = ls_sel_addr
          es_dis_addr = ls_dis_addr
          es_buy_addr = ls_buy_addr
          es_shp_addr = ls_shp_addr.

    ENDIF.
*Sellerdtls
*    gstin


    IF sy-mandt = '020' OR sy-mandt = '050' ."OR sy-mandt = '300'.
      ls_final_eway-fromgstin = '27AACCD2898L1Z4'."'05AAACG5222D1ZA'.
    ELSE.
      ls_final_eway-fromgstin =  '27AACCD2898L1Z4'. "ls_sel_addr-gstin .
    ENDIF.

*lglnm
****    ls_final_eway-lglnm = ls_sel_addr-butxt.
* trdnm
    ls_final_eway-fromtrdname =  ls_sel_addr-name1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromtrdname WITH ''.
    TRANSLATE ls_final_eway-fromtrdname TO UPPER CASE.
* addr1
    ls_final_eway-fromaddr1 = ls_sel_addr-str_suppl1.                                        "ls_adrc-street.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromaddr1 WITH ''.
    TRANSLATE ls_final_eway-fromaddr1 TO UPPER CASE.
*  addr2
    ls_final_eway-fromaddr2 = ls_sel_addr-str_suppl2.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromaddr2 WITH ''.
    TRANSLATE ls_final_eway-fromaddr2 TO UPPER CASE.

    IF ls_final_eway-fromaddr2 IS INITIAL.
      ls_final_eway-fromaddr2 = lc_null.
    ENDIF.

* loc
    ls_final_eway-fromplace = ls_sel_addr-sort1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromplace WITH ''.
    TRANSLATE ls_final_eway-fromplace TO UPPER CASE.

    IF ls_final_eway-fromplace IS INITIAL.
      ls_final_eway-fromplace = lc_null.
    ENDIF.

* pin
    ls_final_eway-frompincode = ls_sel_addr-post_code1.
* stcd
    ls_final_eway-fromstatecode = ls_sel_addr-region. "'5'.
    ls_final_eway-actfromstatecode = ls_sel_addr-region.
*  Ph
    IF ls_sel_addr-region < 10.
      SHIFT ls_final_eway-fromstatecode LEFT DELETING LEADING '0'.
      SHIFT ls_final_eway-actfromstatecode LEFT DELETING LEADING '0'.
    ENDIF.



    "--BuyerDtls (Buyers Details)------
*gstin




    ls_final_eway-togstin      = ls_buy_addr-gstin.
    IF ls_final_eway-togstin = 'URD'.
      ls_final_eway-togstin = 'URP'.
    ENDIF.
****    ENDIF.

*lglnm
****    ls_final-buyerdtls-lglnm = ls_buy_addr-name1.
*trdnm
    ls_final_eway-totrdname = ls_buy_addr-name1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-totrdname WITH ''.
    TRANSLATE ls_final_eway-totrdname TO UPPER CASE.
* pos
    ls_final_eway-tostatecode = ls_buy_addr-region.
    ls_final_eway-acttostatecode = ls_buy_addr-region.

    IF ls_buy_addr-region < 10.
      SHIFT ls_final_eway-tostatecode LEFT DELETING LEADING '0'.
      SHIFT ls_final_eway-acttostatecode LEFT DELETING LEADING '0'.
    ENDIF.
* addr1
    ls_final_eway-toaddr1 = ls_buy_addr-street.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-toaddr1 WITH ''.
    TRANSLATE ls_final_eway-toaddr1 TO UPPER CASE.
* addr2
    IF ls_buy_addr-str_suppl2 IS INITIAL.
      ls_final_eway-toaddr2 =  lc_null.
    ELSE.
      ls_final_eway-toaddr2 =  ls_buy_addr-str_suppl2.                  "addr2_buyer.
    ENDIF.

    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-toaddr2 WITH ''.
    TRANSLATE ls_final_eway-toaddr2 TO UPPER CASE.


*loc
    ls_final_eway-toplace =   ls_buy_addr-city1.                 " 'ABC' ."ls_adrc_re-city1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-toplace WITH ''.
    TRANSLATE ls_final_eway-toplace TO UPPER CASE.
* pin
    ls_final_eway-topincode = ls_buy_addr-post_code1.
* state
****    ls_final_eway-tostatecode = ls_buy_addr-region.

    ls_final_eway-shiptogstin = ls_final_eway-togstin.
    IF ls_final_eway-togstin = 'URD'.
      ls_final_eway-togstin = 'URP'.
    ENDIF.
    ls_final_eway-shiptotradename = ls_final_eway-totrdname.
    ls_final_eway-dispatchfromgstin = ls_final_eway-fromgstin.
    ls_final_eway-dispatchfromtradename = ls_final_eway-fromtrdname.
* Ph
****
****    IF ls_final-buyerdtls-zph IS INITIAL.
****      ls_final-buyerdtls-zph = lc_null.
****    ELSE.
****      ls_final-buyerdtls-zph = lc_null."ls_buy_addr-tel_number.
****    ENDIF.
****
*****Email
****    IF ls_buy_addr-smtp_addr IS INITIAL.
****      ls_final-buyerdtls-zem = lc_null.
****    ELSE.
****      ls_final-buyerdtls-zem = lc_null."ls_buy_addr-smtp_addr.
****    ENDIF.


*    ENDIF.
    ls_final_eway-transactiontype = '4'.
*    BREAK primus.
    READ TABLE gt_ewaybill_details INTO gs_ewaybill_details WITH KEY vbeln = ls_rseg-belnr."ls_final_eway-docno.
    IF sy-subrc = 0.
      ls_final_eway-transportername = gs_ewaybill_details-trans_name.
      ls_final_eway-transdistance   = gs_ewaybill_details-distance.
      ls_final_eway-transdocdate    = gs_ewaybill_details-doc_dt.
      ls_final_eway-transdocno      = gs_ewaybill_details-trans_doc.
      ls_final_eway-transmode       = gs_ewaybill_details-trns_md.
      ls_final_eway-transporterid   = gs_ewaybill_details-trans_id.
      ls_final_eway-vehicleno       = gs_ewaybill_details-vehical_no.
      ls_final_eway-vehicletype     = gs_ewaybill_details-vehical_type.
    ENDIF.

    IF ls_final_eway-vehicletype = 'Regular'.
      ls_final_eway-vehicletype = 'R'.
    ELSEIF ls_final_eway-vehicletype = 'ODC'.
      ls_final_eway-vehicletype = 'O'.
    ENDIF.

    IF ls_final_eway-transdistance IS NOT INITIAL.
      ls_final_eway-transdistance = round( val = ls_final_eway-transdistance dec = 0 ).
      REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-transdistance WITH space.
      CONDENSE ls_final_eway-transdistance NO-GAPS.
    ELSE.
      ls_final_eway-transdistance     = 0.
    ENDIF.

    IF ls_final_eway-transdocdate = '00000000' OR ls_final_eway-transdocdate IS INITIAL.
      ls_final_eway-transdocdate = lc_null.
    ELSE.
      CONCATENATE ls_final_eway-transdocdate+6(02) '/' ls_final_eway-transdocdate+4(02) '/' ls_final_eway-transdocdate(04)  INTO lv_date.
      ls_final_eway-transdocdate = lv_date.
      CLEAR lv_date.
    ENDIF.

    IF ls_final_eway-transdocno IS INITIAL.
      ls_final_eway-transdocno = lc_null.
    ENDIF.
*    BREAK primus.
    IF ls_final_eway-transporterid IS INITIAL.
      ls_final_eway-transporterid = lc_null.
    ENDIF.

    IF ls_final_eway-totnonadvolval IS INITIAL.
      ls_final_eway-totnonadvolval = lc_null.
    ENDIF.

    IF ls_final_eway-othvalue IS INITIAL.
      ls_final_eway-othvalue = lc_null.
    ENDIF.

    IF ls_final_eway-portpin IS INITIAL.
      ls_final_eway-portpin = lc_null.
    ENDIF.

    IF ls_final_eway-portname IS INITIAL.
      ls_final_eway-portname = lc_null.
    ENDIF.

    CASE ls_final_eway-transmode.
      WHEN 'ROAD'.
        ls_final_eway-transmode         = '1' .
      WHEN 'RAIL'.
        ls_final_eway-transmode         = '2' .
      WHEN 'AIR'.
        ls_final_eway-transmode         = '3' .
      WHEN 'SHIP'.
        ls_final_eway-transmode         = '4' .
      WHEN OTHERS.
        ls_final_eway-transmode         = '1' .
    ENDCASE.

    LOOP AT lt_bseg_122 INTO ls_bseg_122 WHERE belnr  = ls_bkpf-belnr AND gjahr = ls_bkpf-gjahr AND buzid = 'W'.
*slno
      CONCATENATE '000' ls_bseg_122-txgrp INTO ls_itemlist-itemno.
*        isservc
****      IF ls_bseg-hsn_sac+0(1) = '4' OR  ls_bseg-hsn_sac+0(2) = '99'..
****        ls_itemlist-isservc  = 'Y'.
****      ELSE.
****        ls_itemlist-isservc  = 'N'.
****      ENDIF.
*     prddesc

      IF ls_bseg_122-matnr IS INITIAL.
        ls_itemlist-productname = ls_bseg_122-matnr.
        ls_itemlist-productdesc = ls_bseg_122-sgtxt.
        REPLACE ALL OCCURRENCES OF ',' IN ls_bseg_122-sgtxt WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN ls_bseg_122-sgtxt WITH ''.
        ls_itemlist-hsncode = ls_bseg_122-hsn_sac."(04).
      ELSE.
        ls_itemlist-productname = ls_bseg_122-matnr.
        READ TABLE lt_makt INTO DATA(ls_makt) WITH KEY matnr = ls_bseg_122-matnr.
        IF sy-subrc  = 0.
          REPLACE ALL OCCURRENCES OF '&' IN ls_makt-maktx WITH ''.
          REPLACE ALL OCCURRENCES OF ',' IN ls_makt-maktx WITH ''.
          ls_itemlist-productdesc = ls_makt-maktx.
        ENDIF.

*hsncd

        READ TABLE lt_marc INTO DATA(ls_marc) WITH KEY matnr = ls_bseg_122-matnr werks = ls_bseg_122-werks.
        IF sy-subrc EQ 0.
          ls_itemlist-hsncode = ls_marc-steuc."(04).     " '23099010'.
        ENDIF.
      ENDIF.

      IF ls_itemlist-hsncode IS NOT INITIAL.
        ls_final_eway-mainhsncode = ls_itemlist-hsncode.
      ENDIF.
*Qty
      ls_itemlist-quantity = ls_bseg_122-menge.
      CONDENSE  ls_itemlist-quantity.
****      ls_itemlist-barcde               =   lc_null.
*   freeqty

********      ls_itemlist-freeqty = '0' ."ls_bseg-menge.
********      CONDENSE  ls_itemlist-freeqty.


*********barcde
********      ls_itemlist-barcde               =   lc_null.
*Unit
      IF ls_bseg_122-meins IS INITIAL.
        ls_itemlist-qtyunit = lc_null.
      ELSE.
        CALL FUNCTION 'ZEINV_UNIT_CONVERT'
          EXPORTING
            vrkme = ls_bseg_122-meins
          IMPORTING
            unit  = ls_itemlist-qtyunit.
      ENDIF.

*********unitprice
********      IF ls_rseg-menge IS INITIAL.
********        ls_itemlist-unitprice = ls_rseg-wrbtr .           "'null'.
********      ELSE.
********        ls_itemlist-unitprice = ls_rseg-wrbtr / ls_rseg-menge.            "'null'.
********      ENDIF.
*********valdtls-assval
********      ls_final-valdtls-assval = ls_final-valdtls-assval + ls_rseg-wrbtr.
*taxable amount
      CONCATENATE '000' ls_bseg_122-txgrp INTO DATA(lv_txgrp).
      READ TABLE lt_rseg INTO ls_rseg WITH KEY belnr  = ls_bkpf-awkey+0(10) gjahr = ls_bkpf-gjahr buzei = lv_txgrp.
      IF sy-subrc EQ 0.
*        lv_wrbtr = lv_wrbtr + ls_rseg-wrbtr.
* total value
        ls_final_eway-totalvalue = ls_final_eway-totalvalue + ls_rseg-wrbtr.
        ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_rseg-wrbtr.
      ENDIF.
*      CLEAR lv_txgrp.
*********    discount
********      ls_itemlist-discount =   '0.00'.
********* pretaxval
********      ls_itemlist-pretaxval            ='0.00'.
*********   assamt
********      ls_itemlist-assamt = ls_rseg-wrbtr.

      ls_itemlist-taxableamount = ls_rseg-wrbtr.
      LOOP AT lt_bset INTO DATA(ls_bset) WHERE belnr = ls_bkpf-belnr AND gjahr = ls_rseg-gjahr AND txgrp = ls_bseg_122-txgrp.
        CASE ls_bset-kschl.
          WHEN  'JICG' OR 'JOCG' OR 'JICN'. .
*    cgstrt
            ls_itemlist-cgstrate =   ls_itemlist-cgstrate + ( ls_bset-kbetr / 10 ).
            lv_cgstrate = ls_itemlist-cgstrate.
            ls_itemlist-cgstrate = lv_cgstrate.
*********    cgstamt
********            ls_itemlist-cgstamt =   ls_bset-fwste.
*********    cgstval
            ls_final_eway-cgstvalue   = ls_final_eway-cgstvalue + ls_bset-fwste.
            ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_bset-fwste.
          WHEN 'JISG' OR 'JOSG' OR 'JISN'..
*     sgstrt
            ls_itemlist-sgstrate =   ls_itemlist-sgstrate + ( ls_bset-kbetr / 10 ).
            lv_sgstrate = ls_itemlist-sgstrate.
            ls_itemlist-sgstrate = lv_sgstrate.
*********     sgstamt
********            ls_itemlist-sgstamt =   ls_bset-fwste.
*********     sgstval
*********     sgstval
            ls_final_eway-sgstvalue   = ls_final_eway-sgstvalue + ls_bset-fwste.
            ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_bset-fwste.
          WHEN  'JIIG' OR 'JOIG' OR 'JIIN'.
*     igstrt
            ls_itemlist-igstrate =   ls_itemlist-igstrate + ( ls_bset-kbetr / 10 ).
            lv_igstrate = ls_itemlist-igstrate.
            ls_itemlist-igstrate = lv_igstrate.
*********     igstamt
********            ls_itemlist-igstamt =   ls_bset-fwste.
*********     igstval
            ls_final_eway-igstvalue   = ls_final_eway-igstvalue + ls_bset-fwste.
            ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_bset-fwste.
        ENDCASE.
        CLEAR : ls_bset.
      ENDLOOP.


      IF ls_itemlist-cgstrate IS INITIAL.
        ls_itemlist-cgstrate = '0'.
        ls_itemlist-sgstrate = '0'.
        ls_final_eway-cgstvalue   = lc_null.
        ls_final_eway-sgstvalue   = lc_null.
      ENDIF.

      IF ls_itemlist-igstrate IS INITIAL.
        ls_itemlist-igstrate = '0'.
        ls_final_eway-igstvalue   = lc_null.
      ENDIF.

      IF ls_itemlist-cessrate IS INITIAL.
        ls_itemlist-cessrate = '0'.
        ls_final_eway-cessvalue = lc_null.
      ENDIF.

      IF ls_itemlist-cessnonadvol IS INITIAL.
        ls_itemlist-cessnonadvol = lc_null.
      ENDIF.
*      ls_itemlist-totitemval = ls_itemlist-assamt + ls_itemlist-camt + ls_itemlist-samt + ls_itemlist-iamt.
********      lv_invtotal = lv_invtotal + ls_itemlist-totitemval.
********      AT END OF belnr.
********        ls_final-valdtls-cgstval = lv_cgstval.
********        ls_final-valdtls-sgstval = lv_sgstval.
********        ls_final-valdtls-igstval = lv_igstval.
********        ls_final-valdtls-zcesval = ''.
********        ls_final-valdtls-stcesval = ''.
********        ls_final-valdtls-rndoffamt = ''.
********        ls_final-valdtls-ztotinvval = lv_invtotal .
********        ls_final-valdtls-totinvvalfc  = ''.
********
********        CLEAR : lv_cgstval,lv_sgstval,lv_igstval,lv_invtotal.
********      ENDAT.
*********ENDloop.
********
********      IF ls_itemlist-discount IS NOT INITIAL.
********        ls_itemlist-discount = ls_itemlist-discount * -1.
********      ENDIF.
********
********      ls_itemlist-zcesrt               = '0.00'.
********      ls_itemlist-zcesamt              = '0.00'.
********      ls_itemlist-zcesnonadvlamt       = '0.00'.
********      ls_itemlist-statecesrt           = '0.00'.
********      ls_itemlist-statecesamt          = '0.00'.
********      ls_itemlist-statecesnonadvlamt   = '0.00'.
********
********      ls_itemlist-ordlineref    =  '0.00'.
********      ls_itemlist-orgcntry      =  lc_null.
********      ls_itemlist-prdslno       =  lc_null.
********
********      "--bchdtl (Batch Details)------------------
*******************************************************************
********      ls_itemlist-bchdtls-znm          = ''.
********      ls_itemlist-bchdtls-zexpdt       = lc_null.
********      ls_itemlist-bchdtls-wrdt         = lc_null.
********
****************************** attribdtls***********************
********      ls_attribdtls-znm         =  lc_null.
********      ls_attribdtls-zvalu        =  lc_null.
********
********      APPEND ls_attribdtls TO lt_attribdtls.
********      ls_itemlist-attribdtls  = lt_attribdtls.

      APPEND ls_itemlist TO lt_itemlist.
      CLEAR : ls_itemlist,ls_marc,ls_makt."ls_attribdtls.
********      REFRESH : lt_attribdtls.
    ENDLOOP.

    ls_final_eway-itemlist = lt_itemlist.
    REFRESH: lt_itemlist.
*********    ***********************************************************
********    "--RefDtls (Ref Details)----------------------
*******************************************************************
********
********    DATA :
********      lv_curry    TYPE vbrk-gjahr,
********      lv_fy(4)    TYPE c,
********      lv_periv    TYPE periv VALUE 'V3',
********      lv_invstdt  TYPE sy-datum,
********      lv_invenddt TYPE sy-datum.
********
********
********    CALL FUNCTION 'GM_GET_FISCAL_YEAR'
********      EXPORTING
********        i_date                     = ls_bkpf-budat
********        i_fyv                      = lv_periv
********      IMPORTING
********        e_fy                       = lv_fy
********      EXCEPTIONS
********        fiscal_year_does_not_exist = 1
********        not_defined_for_date       = 2
********        OTHERS                     = 3.
********    IF sy-subrc <> 0.
********* Implement suitable error handling here
********    ENDIF.
********
********    MOVE lv_fy TO lv_curry.
********
********    CALL FUNCTION 'FIRST_AND_LAST_DAY_IN_YEAR_GET'
********      EXPORTING
********        i_gjahr        = lv_curry
********        i_periv        = lv_periv
********      IMPORTING
********        e_first_day    = lv_invstdt
********        e_last_day     = lv_invenddt
********      EXCEPTIONS
********        input_false    = 1
********        t009_notfound  = 2
********        t009b_notfound = 3
********        OTHERS         = 4.
********    IF sy-subrc <> 0.
********* Implement suitable error handling here
********    ENDIF.
*********
********    CONCATENATE lv_invstdt+6(02) '/' lv_invstdt+4(02) '/' lv_invstdt(04)  INTO ls_final-refdtls-docperddtls-invstdt.
********    CONCATENATE lv_invenddt+6(02) '/' lv_invenddt+4(02) '/' lv_invenddt(04)  INTO ls_final-refdtls-docperddtls-invenddt.
********
********
********    ls_final-refdtls-invrm        = lc_null.
********
********    ls_precdocdtls-invno          = ''.
********    ls_precdocdtls-invdt          = lc_null.
********    ls_precdocdtls-othrefno       = lc_null.
*********      IF ls_precdocdtls-invno IS NOT INITIAL.
*********        ls_update-precdocdtls = ' '.
*********      ENDIF.
********    ls_contrdtls-recadvrefr       = lc_null.
********    ls_contrdtls-recadvdt         = lc_null.
********    ls_contrdtls-tendrefr         = lc_null.
********    ls_contrdtls-contrrefr        = lc_null.
********    ls_contrdtls-extrefr          = lc_null.
********    ls_contrdtls-projrefr         = lc_null.
********    ls_contrdtls-porefr           = lc_null.
********    ls_contrdtls-porefdt          = lc_null.
*********      IF ls_contrdtls-recadvrefr  IS NOT INITIAL.
*********        ls_update-contrdtls = ' '.
*********      ENDIF.
********    APPEND ls_contrdtls TO lt_contrdtls.
********    ls_final-refdtls-contrdtls  = lt_contrdtls.
*********      ls_final-refdtls-contrdtls    = ls_contrdtls.
********
********    APPEND ls_precdocdtls TO lt_precdocdtls.
********    ls_final-refdtls-precdocdtls  = lt_precdocdtls.
*********      ls_final-refdtls-precdocdtls  = ls_precdocdtls.
********
********    CLEAR: lt_precdocdtls,lt_contrdtls,ls_contrdtls,ls_precdocdtls.
********
********    IF ls_final-refdtls-docperddtls-invstdt IS NOT INITIAL.
*********        ls_update-refdtls = 'X'.              ???????????????????????????
********    ENDIF.
*********
********    CLEAR: lt_precdocdtls,lt_contrdtls,ls_contrdtls,ls_precdocdtls.

    APPEND ls_final_eway TO lt_final_eway.

    CLEAR : ls_bkpf,ls_bseg_122,ls_j_1bbranch,wa_t001w,ls_rseg,lv_wrbtr.",ls_adrc,ls_bseg_ref,ls_vbrk_ref.
    REFRESH: lt_itemlist.
  ENDLOOP.

  CLEAR : ls_sel_addr,ls_dis_addr,ls_dis_addr,ls_shp_addr.

********  it_final = lt_final_eway.
  """""""End of JSON DATA"""""""""""""""""""
  DATA : lv_trex_json1 TYPE string.
  """"""""" Conversion of final to JSON format"""""""""""'

  CALL FUNCTION 'ZEWAY_BILL_JSON'
    EXPORTING
      data      = ls_final_eway
    IMPORTING
      trex_json = lv_trex_json1.

  IF sy-subrc IS INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json1 WITH ',#'.
    SPLIT lv_trex_json1 AT '#' INTO TABLE it_json .
  ENDIF.



  DATA : lv_srno TYPE string VALUE 'itemno'.
*  DATA : lv_tax TYPE string VALUE 'supplytype'.
  DATA : lv_tax TYPE string VALUE 'zstyp'.
  DATA : cnt TYPE i VALUE 45.
  DATA : cnt_tax TYPE i VALUE 0.
  DATA : lv_flag(01) TYPE c.

  LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
    IF ls_json-line CS lv_tax.
      cnt_tax = 0.
      ls_json-tabix = cnt_tax.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_srno.
      cnt_tax = cnt_tax + 1.
      ls_json-tabix = cnt_tax.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.
    CLEAR ls_json.
*  clear <lfs_assign>.
  ENDLOOP.

  CLEAR :  sy-tabix , lv_flag .

  LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
    IF ls_json-line CS lv_srno.
      cnt = 46.
      ls_json-tabix = cnt.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_tax.
      cnt = cnt + 1.
      ls_json-tabix = cnt.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.
    CLEAR ls_json.
*  clear <lfs_assign>.
  ENDLOOP.

  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).
***    REPLACE all OCCURRENCES OF '",' in <lfs_json_main> WITH ',"'.
    CASE <lfs_json_main>-tabix.
*****      WHEN '1'. "Excelon
*****        REPLACE 'usergstin'            IN <lfs_json_main> WITH '"userGstin"'.
      WHEN '1'.
        REPLACE 'zstyp'           IN <lfs_json_main> WITH '"supplyType"'.
      WHEN '2'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'subsupplytype'        IN <lfs_json_main> WITH '"subSupplyType"'.
      WHEN '3'.
        REPLACE 'subsupplydesc'        IN <lfs_json_main> WITH '"subSupplyDesc"'.

      WHEN '4'.
        REPLACE 'doctype'              IN <lfs_json_main> WITH '"docType"'.
      WHEN '5'.
        REPLACE 'docno'                IN <lfs_json_main> WITH '"docNo"'.
      WHEN '6'.
        REPLACE 'docdate'              IN <lfs_json_main> WITH '"docDate"'.
      WHEN '7'.
        REPLACE 'fromgstin'            IN <lfs_json_main> WITH '"fromGstin"'.
      WHEN '8'.
        REPLACE 'fromtrdname'          IN <lfs_json_main> WITH '"fromTrdName"'.
      WHEN '9'.
        REPLACE 'fromaddr1'            IN <lfs_json_main> WITH '"fromAddr1"'.
      WHEN '10'.
        REPLACE 'fromaddr2'            IN <lfs_json_main> WITH '"fromAddr2"'.
      WHEN '11'.
        REPLACE 'fromplace'            IN <lfs_json_main> WITH '"fromPlace"'.
      WHEN '12'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'frompincode'          IN <lfs_json_main> WITH '"fromPincode"'.
      WHEN '13'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'fromstatecode'        IN <lfs_json_main> WITH '"fromStateCode"'.
      WHEN '14'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'actfromstatecode'  IN <lfs_json_main> WITH '"actFromStateCode"'.
      WHEN '15'.
        REPLACE 'togstin'              IN <lfs_json_main> WITH '"toGstin"'.
      WHEN '16'.
        REPLACE 'totrdname'            IN <lfs_json_main> WITH '"toTrdName"'.
      WHEN '17'.
        REPLACE 'toaddr1'              IN <lfs_json_main> WITH '"toAddr1"'.
      WHEN '18'.
        REPLACE 'toaddr2'              IN <lfs_json_main> WITH '"toAddr2"'.
      WHEN '19'.
        REPLACE 'toplace'              IN <lfs_json_main> WITH '"toPlace"'.
      WHEN '20'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'topincode'            IN <lfs_json_main> WITH '"toPincode"'.
      WHEN '21'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'tostatecode'          IN <lfs_json_main> WITH '"toStateCode"'.
      WHEN '22'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'acttostatecode'    IN <lfs_json_main> WITH '"actToStateCode"'.
      WHEN '23'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totalvalue'           IN <lfs_json_main> WITH '"totalValue"'.
      WHEN '24'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'transactiontype'           IN <lfs_json_main> WITH '"transactionType"'.
      WHEN '25'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cgstvalue'            IN <lfs_json_main> WITH '"cgstValue"'.
      WHEN '26'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'sgstvalue'            IN <lfs_json_main> WITH '"sgstValue"'.
      WHEN '27'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'igstvalue'            IN <lfs_json_main> WITH '"igstValue"'.
      WHEN '28'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cessvalue'            IN <lfs_json_main> WITH '"cessValue"'.
      WHEN '29'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totnonadvolval'       IN <lfs_json_main> WITH '"TotNonAdvolVal"'.
      WHEN '30'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'othvalue'             IN <lfs_json_main> WITH '"OthValue"'.
      WHEN '31'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totinvvalue'          IN <lfs_json_main> WITH '"totInvValue"'.
      WHEN '32'.
*        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transmode'            IN <lfs_json_main> WITH '"transMode"'.
      WHEN '33'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transdistance'        IN <lfs_json_main> WITH '"transDistance"'.
      WHEN '34'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transportername'      IN <lfs_json_main> WITH '"transporterName"'.
      WHEN '35'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transporterid'        IN <lfs_json_main> WITH '"transporterId"'.
      WHEN '36'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transdocno'           IN <lfs_json_main> WITH '"transDocNo"'.
      WHEN '37'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transdocdate'         IN <lfs_json_main> WITH '"transDocDate"'.
      WHEN '38'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'vehicleno'            IN <lfs_json_main> WITH '"vehicleNo"'.
      WHEN '39'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'vehicletype'          IN <lfs_json_main> WITH '"vehicleType"'.
      WHEN '40'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE ALL OCCURRENCES OF '.' IN <lfs_json_main> WITH space.
        REPLACE 'mainhsncode'          IN <lfs_json_main> WITH '"mainHsnCode"'.
      WHEN '41'.
        REPLACE 'shiptogstin'          IN <lfs_json_main> WITH '"shipToGstin"'.

      WHEN '42'.
        REPLACE 'shiptotradename'          IN <lfs_json_main> WITH '"shipToTradename"'.

      WHEN '43'.
        REPLACE 'dispatchfromgstin'          IN <lfs_json_main> WITH '"dispatchFromGstin"'.

      WHEN '44'.

        REPLACE 'dispatchfromtradename'          IN <lfs_json_main> WITH '"dispatchFromTradename"'.

      WHEN '45'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'portpin'          IN <lfs_json_main> WITH '"portPin"'.

      WHEN '46'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'portname'          IN <lfs_json_main> WITH '"portName"'.

      WHEN '47'.
        REPLACE 'itemno'               IN <lfs_json_main> WITH '"itemNo"'.
        REPLACE 'itemlist'               IN <lfs_json_main> WITH '"itemList"'.
      WHEN '48'.
        REPLACE 'productname'          IN <lfs_json_main> WITH '"productName"'.
      WHEN '49'.
        REPLACE 'productdesc'          IN <lfs_json_main> WITH '"productDesc"'.
      WHEN '50'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE ALL OCCURRENCES OF '.' IN <lfs_json_main> WITH space.
        REPLACE 'hsncode'              IN <lfs_json_main> WITH '"hsnCode"'.
      WHEN '51'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'quantity'             IN <lfs_json_main> WITH '"quantity"'.
      WHEN '52'.
        REPLACE 'qtyunit'              IN <lfs_json_main> WITH '"qtyUnit"'.
      WHEN '53'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'taxableamount'        IN <lfs_json_main> WITH '"taxableAmount"'.
      WHEN '54'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'sgstrate'             IN <lfs_json_main> WITH '"sgstRate"'.
      WHEN '55'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cgstrate'             IN <lfs_json_main> WITH '"cgstRate"'.
      WHEN '56'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'igstrate'             IN <lfs_json_main> WITH '"igstRate"'.
      WHEN '57'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cessrate'             IN <lfs_json_main> WITH '"cessRate"'.
      WHEN '58'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'cessnonadvol'         IN <lfs_json_main> WITH '"cessNonAdvol"'.

    ENDCASE.
  ENDLOOP.


  DATA : ls_str TYPE string.
  DATA : lv_gstin TYPE string.

  DATA :ewaybill_no   TYPE string,
        ewaybill_date TYPE string,
        valid_upto    TYPE string,
        status        TYPE char1,
        msg           TYPE string,
        alert         TYPE string.


  CLEAR : ls_str.
  REFRESH : lt_json_output.


  LOOP AT it_json INTO ls_json.

    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.
    CLEAR :  ls_json , ls_json_output.

  ENDLOOP.

*  lv_gstin = gstin.

  CONDENSE ls_str NO-GAPS.

**DOWNLOAD FILE
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = file_name "'C:/desktop/E-INVOICE.json'
    CHANGING
      data_tab = lt_json_output "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
               TYPE 'I'.
  ENDIF.


  PERFORM auth.
*****  REPLACE ALL OCCURRENCES OF '"' IN ls_str WITH '\\\"'.

  CLEAR ls_json_output-line .

  CONCATENATE '{"action": "GENEWAYBILL", "data":' ls_str '}' INTO ls_str.
  REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
  CONCATENATE ls_str '}' INTO ls_str.
*REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
  CONDENSE ls_str.


  """"""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""

  DATA :tokan TYPE string.

  CLEAR :tokan.

  READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
  tokan = ls_ein_tokan-value.
  CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

  DATA xconn TYPE string.
  CLEAR: xconn.

*  xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180607093257:27GSPMH2101G1Z2'."DEV

  xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.

  DATA lv_url TYPE string.

*  lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."DEV
  lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'.

  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url
    IMPORTING
      client             = DATA(lo_http_client)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).


  lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json'.


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = tokan ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Action'
      value = 'GENEWAYBILL' ).


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'gstin'
      value = '27AACCD2898L1Z4' ).
*   value = '05AAACG5222D1ZA' )."DEV


  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'X-Connector-Auth-Token'
      value = xconn ).


  lo_http_client->request->set_method(
    EXPORTING
      method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
    EXPORTING
      data = ls_str ).


  lo_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).

*  BREAK primus.
  CHECK sy-subrc = 0.
  DATA(lv_response) = lo_http_client->response->get_cdata( ).

  REPLACE ALL OCCURRENCES OF '{"data":{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{"error":[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.

  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 1000 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.

  READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
  IF sy-subrc EQ 0.
    lv_resp_status = ls_res-value.
  ENDIF.

  IF lv_resp_status = '1'.


    LOOP AT lt_res ASSIGNING FIELD-SYMBOL(<f2>).
*      REPLACE ALL  OCCURRENCES OF '\' IN <f2>-value WITH ''.
*      REPLACE ALL  OCCURRENCES OF '{' IN <f2>-value WITH ''.
*      REPLACE ALL  OCCURRENCES OF '/' IN <f2>-value WITH ''.

      IF <f2>-header CS 'ewayBillNo'.
        lv_ewaybill = <f2>-value.
      ENDIF.

      IF <f2>-header CS 'ewayBillDate'.
*  IF ewaybill_date IS NOT INITIAL.
        lv_ewaybill_dt = <f2>-value+0(10).
        CONCATENATE lv_ewaybill_dt+6(4) lv_ewaybill_dt+3(2) lv_ewaybill_dt+0(2) INTO lv_ewaybill_dt.

        lv_ewaybill_tm = <f2>-value+11(11).
        CONCATENATE lv_ewaybill_tm+0(2) lv_ewaybill_tm+3(2) lv_ewaybill_tm+6(2) INTO lv_ewaybill_time.
        MOVE lv_ewaybill_time TO lv_vdfmtime.
        IF lv_ewaybill_tm+9(2) = 'PM'.
          CALL FUNCTION 'HRVE_CONVERT_TIME'
            EXPORTING
              type_time       = 'B'
              input_time      = lv_vdfmtime
              input_am_pm     = 'PM'
            IMPORTING
              output_time     = lv_vdfmtime
            EXCEPTIONS
              parameter_error = 1
              OTHERS          = 2.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
        ENDIF.

      ENDIF.
*
*  ENDIF.
*      ENDIF.
*
      IF <f2>-header CS 'validUpto'.
        IF <f2>-value NE 'null'.
*  IF valid_upto IS NOT INITIAL.
          lv_ewaybill_exdt = <f2>-value+0(10).
          CONCATENATE lv_ewaybill_exdt+6(4) lv_ewaybill_exdt+3(2) lv_ewaybill_exdt+0(2) INTO lv_ewaybill_exdt.

          lv_ewaybill_extm = <f2>-value+11(11).
          CONCATENATE lv_ewaybill_extm+0(2) lv_ewaybill_extm+3(2) lv_ewaybill_extm+6(2) INTO lv_ewaybill_extime.



          MOVE lv_ewaybill_extime TO lv_vdtotime.
          IF lv_ewaybill_extm+9(2) = 'PM'.
            CALL FUNCTION 'HRVE_CONVERT_TIME'
              EXPORTING
                type_time       = 'B'
                input_time      = lv_vdtotime
                input_am_pm     = 'PM'
              IMPORTING
                output_time     = lv_vdtotime
              EXCEPTIONS
                parameter_error = 1
                OTHERS          = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*        ENDIF.
*      ENDIF.
*
    ENDLOOP.
*  ENDIF.  "commented by swati

  ELSE.
    READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.                "INDEX 5.
    IF sy-subrc EQ 0.
      msg = ls_res-value.
    ENDIF.
  ENDIF.
  LOOP AT lt_final ASSIGNING FIELD-SYMBOL(<f3>) WHERE selection = 'X'.

    IF lv_ewaybill IS NOT INITIAL.
      <f3>-process_status = TEXT-003. "'@08\Q Completly Processed@'.
      <f3>-status_description = TEXT-004. "'Completly Processed'.

      <f3>-eway_bil =   lv_ewaybill.
      <f3>-eway_dt  =   lv_ewaybill_dt.
      <f3>-vdfmtime = lv_vdfmtime.
      <f3>-eway_dt_exp = lv_ewaybill_exdt.
      <f3>-vdtotime   = lv_vdtotime.
      <f3>-message = ' Eway Bill Sucessfully Generated'.
      <f3>-veh_no = ls_eway_bill-vehical_no.
      <f3>-created_by = sy-uname.
      <f3>-created_dt = sy-datum.
      <f3>-created_time = sy-uzeit.

      ls_eway_number-vbeln          =  <f3>-vbeln.
      ls_eway_number-eway_bill      =  <f3>-eway_bil.
*      ls_eway_number-CONEWAYNO      =
      ls_eway_number-ewaybilldate   = <f3>-eway_dt.
      ls_eway_number-vdfmtime       = lv_vdfmtime.
      ls_eway_number-validuptodate  = <f3>-eway_dt_exp.
      ls_eway_number-vdtotime       = <f3>-vdtotime.
      ls_eway_number-zzstatus       = 'C'.
      ls_eway_number-message        =  <f3>-message.
      ls_eway_number-createdby      = <f3>-created_by.
      ls_eway_number-creationdt     = <f3>-created_dt.
      ls_eway_number-creationtime   = <f3>-created_time.
    ELSE.
      <f3>-process_status = TEXT-009. "'@0A\Q Error!@'.
      <f3>-status_description = TEXT-010. "'Error'.
      ls_eway_number-vbeln          = <f3>-vbeln.
      ls_eway_number-zzstatus       = 'E'.
      <f3>-message = msg.
      ls_eway_number-message        =  msg.
    ENDIF.
    MOVE-CORRESPONDING ls_eway_number TO ls_zeway_res_122.
    ls_zeway_res_122-gjahr = <f3>-gjahr.
    ls_zeway_res_122-belnr = <f3>-vbeln.
    APPEND ls_zeway_res_122 TO lt_zeway_res_122.
    CLEAR : ls_zeway_res_122.

  ENDLOOP.

  LOOP AT lt_zeway_res_122 INTO ls_zeway_res_122.
    SELECT SINGLE COUNT(*) FROM zeway_res_122 WHERE belnr = ls_zeway_res_122-belnr.
    IF sy-subrc = 0.

      UPDATE zeway_res_122 SET eway_bill = ls_zeway_res_122-eway_bill
                               conewayno = ls_zeway_res_122-conewayno
                               ewaybilldate = ls_zeway_res_122-ewaybilldate
                               vdfmtime   = ls_zeway_res_122-vdfmtime
                               validuptodate = ls_zeway_res_122-validuptodate
                               vdtotime = ls_zeway_res_122-vdtotime
                               createdby = ls_zeway_res_122-createdby
                               creationdt = ls_zeway_res_122-creationdt
                               creationtime = ls_zeway_res_122-creationtime
                               zzstatus = ls_zeway_res_122-zzstatus
                               canreason = ls_zeway_res_122-canreason
                               canceldt = ls_zeway_res_122-canceldt
                               cancelremark = ls_zeway_res_122-cancelremark
                               message = ls_zeway_res_122-message
                          WHERE belnr = ls_zeway_res_122-belnr
                            AND gjahr = ls_zeway_res_122-gjahr.

    ELSE.
      MODIFY zeway_res_122 FROM ls_zeway_res_122.
    ENDIF.
  ENDLOOP.




  REFRESH: lt_response,lt_res,lt_eway_number,it_json,lt_json_data,lt_vbrp,lt_final_temp,gt_ewaybill_details,lt_final_eway.
  CLEAR : ls_str,lv_gstin,ls_res,ls_final_eway ,lv_response.
  CLEAR :lv_trex_json1,zeway_bill,lv_ewaybill,lv_ewaybill_dt,lv_ewaybill_exdt,lv_temp,gs_ewaybill_details.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DETAILS_FOR_JSON_CRT_SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_FINAL_STCD3  text
*----------------------------------------------------------------------*
FORM get_details_for_json_crt_sale  USING gstin TYPE stcd3.

  REFRESH : lt_vbrk_j, lt_vbrp, lt_vbfa, lt_vbfa_2,
            lt_vbak, lt_vbap, lt_marc, lt_prcd, lt_kna1,
            it_adrc, it_adrc_cust, it_adrct,lt_eway_number,
            it_json,lt_json_data,lt_vbrp,lt_final_temp.

  CLEAR : ls_str,zeway_bill,lv_ewaybill,lv_ewaybill_dt,lv_ewaybill_exdt,lv_temp,gs_ewaybill_details.

  SELECT * FROM j_1istatecdm INTO TABLE lt_statecode.
  SELECT * FROM zbillingtypes INTO TABLE lt_billingtypes.
*  SELECT * FROM zplant_address INTO TABLE @DATA(lt_adress).

  lt_final_temp = lt_final.
  DELETE lt_final_temp WHERE selection <> 'X'.
*  BREAK primus.
  SELECT vbeln  fkart waerk vkorg
         kalsm knumv fkdat kurrf
         bukrs taxk6 netwr mwsbk kunag sfakn
         xblnr bupla
         FROM vbrk
         INTO TABLE lt_vbrk_j
         FOR ALL ENTRIES IN lt_final_temp
         WHERE vbeln = lt_final_temp-vbeln
         AND fkdat IN s_fkdat
         AND bukrs = p_bukrs
  AND vkorg IN s_vkorg.

  LOOP AT lt_vbrk_j INTO ls_vbrk_j.
    IF ls_vbrk_j-sfakn IS NOT INITIAL.
      DELETE lt_vbrk_j WHERE vbeln = ls_vbrk_j-sfakn.
      DELETE lt_vbrk_j WHERE vbeln = ls_vbrk_j-vbeln.
    ENDIF.
  ENDLOOP.

  IF lt_vbrk_j IS NOT INITIAL.

    SELECT vbeln posnr  matnr arktx
           fkimg netwr meins aubel
           kursk werks vrkme vgbel
           FROM vbrp
           INTO TABLE lt_vbrp
           FOR ALL ENTRIES IN lt_vbrk_j
    WHERE vbeln = lt_vbrk_j-vbeln.
*           AND werks EQ s_plant.
*           AND werks IN s_plant
*           %_HINTS ORACLE 'INDEX("VBRP" "VBRP~ZD2")("VBRP" "VBRP~ZD3")'.

    LOOP AT lt_vbrk_j INTO ls_vbrk_j.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_vbrk_j-xblnr
        IMPORTING
          output = ls_vbrk_j-xblnr.
      MODIFY lt_vbrk_j FROM ls_vbrk_j TRANSPORTING xblnr.
      CLEAR ls_vbrk_j.
    ENDLOOP.

    SELECT knumv
           kposn
           kschl
           kwert
           kbetr
           kawrt
         FROM prcd_elements
         INTO TABLE lt_prcd
       FOR ALL ENTRIES IN lt_vbrk_j
         WHERE knumv = lt_vbrk_j-knumv
           AND kschl IN ('JOCG', 'JOSG', 'JOIG', 'JCOS', 'PR00', 'ZPR0', 'K004',
    'K005', 'K007', 'ZDIS', 'ZGSR', 'ZSUB', 'ZSTO', 'JTC1','JWTS', 'ZTCS', 'ZPFO', 'ZIN1', 'ZIN2', 'ZFR1', 'ZFR2' ,'ZTE1', 'ZTE2', 'VPRS').
***********************addded by jyoti on 09.07.2024*****************************
    IF lt_vbrp IS NOT INITIAL.
      SELECT kschl
            kunnr
            matnr
            datbi
            datab
            knumh
       FROM a005
       INTO TABLE tt_a005
       FOR ALL ENTRIES IN lt_vbrp
       WHERE matnr = lt_vbrp-matnr
       AND kschl = 'ZSTO'
       AND datbi = '99991231'.
    ENDIF.
********ADDED BY PRIMUS JYOTI ON 01.12.2023*******
    IF tt_a005 IS NOT INITIAL.

      SELECT knumh
             kopos
             kschl
             kbetr
        FROM konp
        INTO TABLE tt_konp
        FOR ALL ENTRIES IN tt_a005
        WHERE knumh = tt_a005-knumh.

    ENDIF.
**************************************************
*****************************************************************************



    SELECT kunnr
        name1
        locco
        stcd3
        ort01
        pstlz
        land1
        regio
        bahne
        adrnr
        werks
        ktokd
        FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbrk_j
    WHERE kunnr EQ lt_vbrk_j-kunag.
  ELSE.
    MESSAGE 'No data found !' TYPE 'E'.
  ENDIF.

  IF lt_vbrp IS NOT INITIAL.

    SELECT  vbelv posnv vbeln
            posnn vbtyp_v matnr
            FROM vbfa
            INTO TABLE lt_vbfa
            FOR ALL ENTRIES IN lt_vbrp
            WHERE  vbeln = lt_vbrp-vbeln
            AND posnn = lt_vbrp-posnr
    AND vbtyp_v = 'J'.

    SELECT matnr
         werks
         steuc
         FROM marc
         INTO TABLE lt_marc
         FOR ALL ENTRIES IN lt_vbrp
    WHERE matnr EQ lt_vbrp-matnr.

    SELECT vbelv posnv vbeln
           posnn  vbtyp_v matnr
           FROM vbfa
           INTO TABLE lt_vbfa_2
           FOR ALL ENTRIES IN lt_vbrp
           WHERE  vbeln = lt_vbrp-vbeln
           AND posnn = lt_vbrp-posnr
    AND ( vbtyp_v = 'C' OR vbtyp_v = 'I' ) .

    IF lt_vbfa_2 IS NOT INITIAL.
      SELECT vbeln auart
             FROM vbak
             INTO TABLE lt_vbak
             FOR ALL ENTRIES IN lt_vbfa_2
      WHERE vbeln = lt_vbfa_2-vbelv.
    ENDIF.

    IF lt_vbak IS NOT INITIAL.
      SELECT vbeln posnr kdmat
             FROM vbap
             INTO TABLE lt_vbap
             FOR ALL ENTRIES IN lt_vbak
      WHERE vbeln = lt_vbak-vbeln.
    ENDIF.

    SELECT werks
           pstlz
           spras
           land1
           regio
           adrnr
           FROM t001w INTO TABLE it_t001w
           FOR ALL ENTRIES IN lt_vbrp
    WHERE werks = lt_vbrp-werks.
  ENDIF.

  IF it_t001w IS NOT INITIAL.
    SELECT spras
           land1
           bland
           bezei FROM t005u INTO TABLE it_t005u
           FOR ALL ENTRIES IN it_t001w
           WHERE spras = it_t001w-spras
          AND land1 = it_t001w-land1
    AND bland = it_t001w-regio.

    SELECT addrnumber
           name1
           street
           str_suppl1
           str_suppl2
           str_suppl3
           location
           country
           city1
           post_code1
           region
           city2
           FROM adrc INTO TABLE it_adrc_cust
           FOR ALL ENTRIES IN it_t001w
           WHERE addrnumber = it_t001w-adrnr.



  ENDIF.

  IF lt_kna1 IS NOT INITIAL.
    SELECT addrnumber
            name1
            street
            str_suppl1
            str_suppl2
            str_suppl3
            location
            country
            city1
            post_code1
            region
       FROM adrc INTO TABLE it_adrc
       FOR ALL ENTRIES IN lt_kna1
       WHERE addrnumber = lt_kna1-adrnr.

    SELECT addrnumber
       remark INTO TABLE it_adrct FROM adrct FOR ALL ENTRIES IN lt_kna1
    WHERE addrnumber = lt_kna1-adrnr.
  ENDIF.

  DATA : doc_no  TYPE thead-tdname,
         lines   LIKE tline OCCURS 0 WITH HEADER LINE,
         i_text  TYPE char100,
         e_text  TYPE char100,

         lv_id   TYPE  thead-tdid,
         lv_lang TYPE thead-tdspras VALUE 'E',
         lv_obj  TYPE thead-tdobject,
         lv_name TYPE thead-tdname.

  DATA: lt_tab TYPE STANDARD TABLE OF tline.
  DATA: ls_vbpa TYPE vbpa,
        ls_kna1 TYPE kna1,
        ls_adrc TYPE adrc.
*  BREAK primusabap.
  LOOP AT lt_vbrp INTO wa_vbrp.
    ls_json_data-posnr = wa_vbrp-posnr.
    ls_json_data-material = wa_vbrp-matnr.
    ls_json_data-arktx = wa_vbrp-arktx.
    ls_json_data-uqc = wa_vbrp-vrkme.
    ls_json_data-taxable_value = wa_vbrp-netwr * wa_vbrp-kursk.
    READ TABLE lt_vbrk_j INTO ls_vbrk_j WITH KEY vbeln = wa_vbrp-vbeln.
    IF sy-subrc = '0'.
      ls_json_data-assess_value = ls_vbrk_j-netwr.
      READ TABLE lt_billingtypes INTO ls_billingtypes WITH KEY bukrs = ls_vbrk_j-bukrs vkorg = ls_vbrk_j-vkorg fkart = ls_vbrk_j-fkart.
      IF sy-subrc = 0.
        IF ls_vbrk_j-vbeln IS NOT INITIAL.
          ls_json_data-doc_no = ls_vbrk_j-vbeln.
        ELSE.
          ls_json_data-doc_no = 'null'.
        ENDIF.
        ls_json_data-xblnr = ls_vbrk_j-xblnr.            "
        ls_json_data-order_type = ls_vbrk_j-fkart.
        ls_json_data-supply_type  = ls_billingtypes-zsupply.
        ls_json_data-sub_type     = ls_billingtypes-zsubsupply.
        ls_json_data-doc_type     = ls_billingtypes-zdoctype.

        IF ls_vbrk_j-fkdat IS NOT INITIAL.
          CONCATENATE ls_vbrk_j-fkdat+6(2) '-' ls_vbrk_j-fkdat+4(2) '-' ls_vbrk_j-fkdat+0(4) INTO ls_json_data-doc_date.
        ELSE.
          ls_json_data-doc_date = 'null'.
        ENDIF.

*        SELECT SINGLE gstin FROM j_1bbranch INTO ls_json_data-gstin WHERE bukrs = ls_vbrk_j-bukrs AND branch = ls_vbrk_j-bupla.

*        READ TABLE it_t001w INTO wa_t001w WITH KEY werks = wa_vbrp-werks.
*        BREAK primus.
        READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag.
        IF sy-subrc = 0.
          READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_kna1-adrnr.
          IF sy-subrc = 0.
            ls_json_data-location = wa_adrc-city1.
            ls_json_data-name1 = wa_adrc-name1.
            ls_json_data-street = wa_adrc-str_suppl1.
            ls_json_data-str_suppl3 = wa_adrc-str_suppl2.
            ls_json_data-from_state = wa_adrc-region.
            ls_json_data-post_code1 = wa_adrc-post_code1.
          ENDIF.
          ls_json_data-gstin = wa_kna1-stcd3.
        ENDIF.
        REPLACE ALL OCCURRENCES OF  ',' IN ls_json_data-name1 WITH '  '.
        TRANSLATE ls_json_data-name1 TO UPPER CASE.
        REPLACE ALL OCCURRENCES OF  ',' IN ls_json_data-street WITH cl_abap_char_utilities=>horizontal_tab.
        REPLACE ALL OCCURRENCES OF  '&' IN ls_json_data-street WITH ' '.
        TRANSLATE ls_json_data-street TO UPPER CASE.
        REPLACE ALL OCCURRENCES OF  ',' IN ls_json_data-str_suppl3 WITH ''.
        TRANSLATE ls_json_data-str_suppl3 TO UPPER CASE.
        TRANSLATE ls_json_data-location TO UPPER CASE.
        TRANSLATE ls_json_data-country TO UPPER CASE.
        TRANSLATE ls_json_data-city TO UPPER CASE.
        TRANSLATE ls_json_data-from_state TO UPPER CASE.

*-------------------Start Remove Special Characters from Strings------------------------------------------

        MOVE ls_json_data-arktx TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-arktx.
        CLEAR : e_text, i_text.

        MOVE ls_json_data-name1 TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-name1.
        CLEAR : e_text, i_text.
        MOVE ls_json_data-street TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-street.
        CLEAR : e_text, i_text.
        MOVE ls_json_data-str_suppl3 TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-str_suppl3.
        CLEAR : i_text, e_text.
        MOVE ls_json_data-location TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-location.
        CLEAR : i_text, e_text.
        MOVE ls_json_data-country TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-country.
        CLEAR : i_text, e_text.
        MOVE ls_json_data-city TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-city.
        CLEAR : i_text, e_text.
        ls_json_data-line_item = 'ELECTRICAL & MECHANICAL'.
        ls_json_data-item_code  = wa_vbrp-arktx.
        MOVE ls_json_data-item_code TO i_text.
        PERFORM es_remove_special_character USING i_text CHANGING e_text.
        MOVE e_text TO ls_json_data-item_code.
        CLEAR : i_text, e_text.
*-------------------End Remove Special Characters from Strings------------------------------------------

        TRANSLATE ls_json_data-item_code TO UPPER CASE.
        ls_json_data-quantity  = wa_vbrp-fkimg.
        READ TABLE lt_marc INTO wa_marc WITH KEY matnr = wa_vbrp-matnr werks = wa_vbrp-werks.
        IF sy-subrc = '0'.
          ls_json_data-hsn_sac = wa_marc-steuc.
        ENDIF.

        READ TABLE it_t001w INTO wa_t001w WITH KEY werks = wa_vbrp-werks.
*        READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag.
        IF sy-subrc = 0.
          ls_json_data-transport_id = wa_kna1-bahne.                    " Transporter ID
          READ TABLE it_adrc_cust INTO wa_adrc_cust WITH KEY addrnumber = wa_t001w-adrnr.

          MOVE wa_adrc_cust-name1 TO i_text.
          PERFORM es_remove_special_character USING i_text CHANGING e_text.
          MOVE e_text TO ls_json_data-ship_to_party.
          CLEAR : i_text, e_text.

          SELECT SINGLE gstin FROM j_1bbranch INTO ls_json_data-to_gstin WHERE bukrs = ls_vbrk_j-bukrs AND branch = ls_vbrk_j-bupla.
*              ls_json_data-to_gstin   = wa_kna1-stcd3.
          IF ls_json_data-to_gstin = 'URD'.
            ls_json_data-to_gstin = 'URP'.
          ENDIF.

          CONCATENATE wa_adrc_cust-str_suppl1 wa_adrc_cust-street INTO i_text SEPARATED BY space.
          PERFORM es_remove_special_character USING i_text CHANGING e_text.
          MOVE e_text TO ls_json_data-to_add1.
          CLEAR : i_text, e_text.
          CONCATENATE wa_adrc_cust-str_suppl2 wa_adrc_cust-city2 INTO i_text SEPARATED BY space.
          PERFORM es_remove_special_character USING i_text CHANGING e_text.
          MOVE e_text TO ls_json_data-to_add2.
          CLEAR : i_text, e_text.

          MOVE wa_kna1-ort01 TO i_text.
          PERFORM es_remove_special_character USING i_text CHANGING e_text.
          MOVE e_text TO ls_json_data-to_place.
          CLEAR : i_text, e_text.

          ls_json_data-to_pincode = wa_adrc_cust-post_code1.
          ls_json_data-distance_level   = wa_kna1-locco.
*  *            SELECT SINGLE bezei FROM t005u INTO  ls_json_data-to_state  WHERE spras = 'E' AND land1 = wa_kna1-land1 AND bland = wa_kna1-regio.

          ls_json_data-to_state = wa_adrc_cust-region.

          TRANSLATE ls_json_data-to_state TO UPPER CASE.
          TRANSLATE ls_json_data-to_add1 TO UPPER CASE.
          TRANSLATE ls_json_data-to_place TO UPPER CASE.






        ENDIF.


*        BREAK primus.

*---------------------GST TAX AND RATE Calculations---------------------------------------------------------
        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOCG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          IF ls_prcd-kbetr <> 0.
            ls_json_data-cgst_rate =  ls_prcd-kbetr / 10.
            ls_json_data-cgst_amt = ls_prcd-kwert.
          ENDIF.
        ENDIF.

        CLEAR ls_prcd.

        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOSG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          IF ls_prcd-kbetr <> 0.
            ls_json_data-sgst_rate =  ls_prcd-kbetr / 10.
            ls_json_data-sgst_amt = ls_prcd-kwert.
            ls_json_data-total_val = ls_prcd-kawrt * ls_vbrk_j-kurrf..
          ENDIF.
        ENDIF.

        CLEAR ls_prcd.
        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOIG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          IF ls_prcd-kbetr <> 0.
            ls_json_data-igst_rate =  ls_prcd-kbetr / 10.
*            igst_v = ls_prcd-kwert * ls_vbrk_j-kurrf..
*            ls_json_data-igst_amt = igst_v.        "ls_prcd-kwert * ls_vbrk_j-kurrf.."ajay
            ls_json_data-igst_amt = ls_prcd-kwert * ls_vbrk_j-kurrf..
            ls_json_data-total_val = ls_prcd-kawrt * ls_vbrk_j-kurrf..
          ENDIF.
        ENDIF.
*        BREAK primus.
        CLEAR ls_prcd.
        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZPR00' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          ls_json_data-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
        ENDIF.

        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZSUB' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          ls_json_data-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
        ENDIF.

        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZSTO' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        IF sy-subrc = 0.
          ls_json_data-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
        ENDIF.


        CLEAR ls_prcd.
*        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'K007' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'K004' OR kschl = 'K005' OR kschl = 'K007' OR kschl = 'ZDIS' OR kschl = 'ZGSR')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv.
*        IF sy-subrc = 0.
          IF ls_prcd-kwert < 0.
            ls_prcd-kwert = ls_prcd-kwert * -1.
          ENDIF.
          ls_json_data-discount = ls_prcd-kwert + ls_json_data-discount.
*        ENDIF.
          CLEAR ls_prcd.
        ENDLOOP.

        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'JTC1' OR kschl = 'JWTS')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  =  ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZIN1' OR kschl = 'ZIN2')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZFR1' OR kschl = 'ZFR2')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZTE1' OR kschl = 'ZTE2')
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.

        CLEAR:ls_prcd.
        LOOP AT lt_prcd INTO ls_prcd WHERE  kschl = 'ZPFO'
                                       AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
          ls_json_data-othvalue  = ls_json_data-othvalue + ls_prcd-kwert.
        ENDLOOP.


        IF ls_vbrk_j-fkart = 'ZEXP'.
          ls_json_data-othvalue = ls_json_data-othvalue * ls_vbrk_j-kurrf.
        ENDIF.

        IF ls_vbrk_j-fkart = 'ZEXP'.
          IF ls_vbrk_j-taxk6 = '5'.
            ls_json_data-igst_rate = '0'.
            ls_json_data-igst_amt = '0'.
          ENDIF.
        ENDIF.
*--------------------------------------------------------------------------------------------------------------
        ls_json_data-taxable_value = ls_json_data-total_val - ls_json_data-discount.      " Taxable value


*        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZPR0' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
*        IF sy-subrc = 0.
*          ls_json_data-taxable_value = ls_prcd-kwert.
*        ENDIF.

        IF ls_json_data-cgst_rate IS INITIAL.
          ls_json_data-cgst_rate = '0'.
          ls_json_data-sgst_rate = '0'.
        ENDIF.
        IF ls_json_data-igst_rate IS INITIAL.
          ls_json_data-igst_rate = '0'.
        ENDIF.
        IF ls_json_data-cess_rate IS INITIAL.
          ls_json_data-cess_rate = '0'.
        ENDIF.

        CONCATENATE  ls_json_data-cgst_rate '+' ls_json_data-sgst_rate '+' ls_json_data-igst_rate '+' ls_json_data-cess_rate INTO ls_json_data-total_gst_rate.
        CONDENSE ls_json_data-total_gst_rate NO-GAPS.

*---------------Get Vehicle no------------------------------------------------------------*
        DATA : lv_lifnr TYPE lifnr.
        READ TABLE lt_vbfa INTO ls_vbfa WITH KEY vbeln = wa_vbrp-vbeln vbtyp_v = 'J'.
        IF sy-subrc = 0.
          SELECT SINGLE lifnr INTO lv_lifnr FROM vbpa WHERE vbeln = ls_vbfa-vbelv AND parvw = 'LF'.
        ENDIF.


*        BREAK-POINT.
        READ TABLE lt_vbfa_2 INTO ls_vbfa_2 WITH KEY vbeln = wa_vbrp-vbeln posnn = wa_vbrp-posnr.
        IF sy-subrc = 0.
          READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_vbfa_2-vbelv.
          IF sy-subrc = 0.
            CALL FUNCTION 'CONVERSION_EXIT_AUART_OUTPUT'
              EXPORTING
                input  = ls_vbak-auart
              IMPORTING
                output = ls_json_data-sales_order_type.
          ENDIF.

          READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_vbfa_2-vbelv posnr = ls_vbfa_2-posnv.
          IF sy-subrc = 0.
            ls_json_data-cust_mat = ls_vbap-kdmat.
          ENDIF.
        ENDIF.

        READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag ktokd = 'ZVEM'.
        IF sy-subrc = 0.
          SELECT SINGLE ebeln, ebelp FROM mseg INTO @DATA(ls_mseg) WHERE mblnr = @wa_vbrp-vgbel.
          IF sy-subrc = 0.
            lv_id   = 'F02'.
            lv_obj  = 'EKPO'.

            CONCATENATE ls_mseg-ebeln ls_mseg-ebelp INTO lv_name.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
*               CLIENT                  = SY-MANDT
                id                      = lv_id
                language                = lv_lang
                name                    = lv_name
                object                  = lv_obj
*               ARCHIVE_HANDLE          = 0
*               LOCAL_CAT               = ' '
*               IMPORTING
*               HEADER                  =
*               OLD_LINE_COUNTER        =
              TABLES
                lines                   = lt_tab
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
*        Implement suitable error handling here
            ELSE.
              READ TABLE lt_tab INTO DATA(ls_tab) INDEX 1.
              IF sy-subrc = 0.
                i_text = ls_tab-tdline.
                PERFORM es_remove_special_character USING i_text CHANGING e_text.
                MOVE e_text TO ls_json_data-to_add1.
                TRANSLATE ls_json_data-to_add1 TO UPPER CASE.
                CLEAR : i_text, e_text.
              ENDIF.
              READ TABLE lt_tab INTO ls_tab INDEX 2.
              IF sy-subrc = 0.
                i_text = ls_tab-tdline.
                PERFORM es_remove_special_character USING i_text CHANGING e_text.
                MOVE e_text TO ls_json_data-to_add2.
                CLEAR : i_text, e_text.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
*BREAK primus.

        IF ls_json_data-total_val LT 0.
          ls_json_data-total_val = ls_json_data-total_val * -1.
        ENDIF.

        APPEND ls_json_data TO lt_json_data.
        CLEAR :ls_json_data,ls_vbrk_j,wa_vbrp,wa_marc,lines[], wa_kna1, wa_adrc, wa_adrc_cust, ls_vbfa,wa_t001w, wa_zdistance.
      ENDIF.
    ENDIF.
    CLEAR :ls_json_data,ls_vbrk_j,wa_vbrp,wa_marc,lines[], wa_kna1, wa_adrc, wa_adrc_cust, ls_vbfa.

  ENDLOOP.
*----------------------Remove trailing zeroes from XBLNR----------------------------
  LOOP AT lt_json_data INTO ls_json_data.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = ls_json_data-xblnr
      IMPORTING
        output = ls_json_data-xblnr.
    MODIFY lt_json_data FROM ls_json_data TRANSPORTING xblnr.
    CLEAR ls_json_data.
  ENDLOOP.
*--------------------------------------------------------------------*

  LOOP AT lt_json_data ASSIGNING FIELD-SYMBOL(<f1>).
    READ TABLE gt_ewaybill_details INTO gs_ewaybill_details WITH KEY vbeln = <f1>-doc_no.
    IF sy-subrc = 0.
      <f1>-trans_mode         =  gs_ewaybill_details-trns_md.
      <f1>-trans_doc_no       =  gs_ewaybill_details-trans_doc.
*         <f1>-LIFNR           =  gs_ewaybill_details-LIFNR.
      <f1>-trans_date          =  gs_ewaybill_details-doc_dt.
      <f1>-trans_id        =  gs_ewaybill_details-trans_id.
      <f1>-transport_id    =  gs_ewaybill_details-trans_id.
      <f1>-trans_name      =  gs_ewaybill_details-trans_name.
      <f1>-vehicle_no      =  gs_ewaybill_details-vehical_no.
      <f1>-vehicletype     =  gs_ewaybill_details-vehical_type.
      <f1>-distance_level  =  gs_ewaybill_details-distance.
      <f1>-trans_date          = gs_ewaybill_details-doc_dt.
    ENDIF.
  ENDLOOP.

  """""""""""JSON Data collected""""""""""""

  LOOP AT lt_json_data INTO DATA(ls_final).
    " Comment due to Excelon
*    ls_final_eway-usergstin         = '29AAACW4202F1ZM' . "ls_final-gstin. for testing its hard coded. Excelon
*    IF ls_final_eway-usergstin IS INITIAL.
*      MESSAGE e001(zinv_message).
*    ENDIF.
    " End of comment excelon

    ls_final_eway-zstyp = ls_final-supply_type.
    ls_final_eway-subsupplytype = ls_final-sub_type.
    ls_final_eway-subsupplydesc = ''.
    ls_final_eway-doctype    = ls_final-doc_type.
    IF ls_final-xblnr IS NOT INITIAL.
      ls_final_eway-docno    = ls_final-xblnr.
    ELSE.
      ls_final_eway-docno    = ls_final-doc_no.
    ENDIF.
    SHIFT ls_final_eway-docno LEFT DELETING LEADING '0'.
    ls_final_eway-docdate           = ls_final-doc_date .
    REPLACE ALL OCCURRENCES OF '-' IN ls_final_eway-docdate WITH '/'.

    ls_final_eway-fromgstin                 = ls_final-gstin.
    ls_final_eway-dispatchfromgstin         =  ls_final-gstin.
*    BREAK primus.
    IF ls_final_eway-fromgstin IS INITIAL.
      MESSAGE e002(zinv_message).
    ENDIF.

    ls_final_eway-fromtrdname       = ls_final-name1.
    ls_final_eway-dispatchfromtradename       = ls_final-name1. "If kunag and kunnr is same.

    ls_final_eway-fromaddr1         = ls_final-street.
    ls_final_eway-fromaddr2         = ls_final-str_suppl3.
    ls_final_eway-fromplace         = ls_final-location.
    ls_final_eway-frompincode       = ls_final-post_code1.

    READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ls_final-from_state.
    IF sy-subrc = 0.
      ls_final_eway-fromstatecode     =  ls_statecode-legal_state_code.
      ls_final_eway-actfromstatecode  =  ls_statecode-legal_state_code.

      IF ls_statecode-legal_state_code < 10.
        SHIFT ls_final_eway-fromstatecode LEFT DELETING LEADING '0'.
        SHIFT ls_final_eway-actfromstatecode LEFT DELETING LEADING '0'.
      ENDIF.

      CLEAR ls_statecode.
    ENDIF.

*    IF ls_final_eway-fromstatecode IS INITIAL.
*      MESSAGE e001(zinv_message).
*    ENDIF.


    ls_final_eway-togstin           = ls_final-to_gstin.  "'05AAACG5222D1ZA'.  "For testing purpose hardcoded '29AAACW6874H1ZS'
    ls_final_eway-shiptogstin       = ls_final-to_gstin. "If kunag and kunnr is same. For testing purpose hardcoded '29AAACW6874H1ZS'.

*    IF ls_final_eway-togstin IS INITIAL.
*      MESSAGE e001(zinv_message).
*    ENDIF.

    REPLACE ALL OCCURRENCES OF '&' IN ls_final-ship_to_party WITH ''.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-ship_to_party WITH ''.
    ls_final_eway-totrdname         = ls_final-ship_to_party.
    ls_final_eway-shiptotradename   = ls_final-ship_to_party. "If kunag and kunnr is same.
*    BREAK primus.
    ls_final_eway-toaddr1           = ls_final-to_add1.
    REPLACE ALL  OCCURRENCES OF ',' IN ls_final_eway-toaddr1 WITH space.
    REPLACE ALL  OCCURRENCES OF '\' IN ls_final_eway-toaddr1 WITH space.
    REPLACE ALL  OCCURRENCES OF '/' IN ls_final_eway-toaddr1 WITH space.
    REPLACE ALL  OCCURRENCES OF '&' IN ls_final_eway-toaddr1 WITH space.
    ls_final_eway-toaddr2           = ls_final-to_add2.
    REPLACE ALL  OCCURRENCES OF ',' IN ls_final_eway-toaddr2 WITH space.
    ls_final_eway-toplace           = ls_final-to_place.  "For testing purpose hardcoded "'JALANDHAR'
    REPLACE ALL  OCCURRENCES OF ',' IN ls_final_eway-toplace WITH space.
    ls_final_eway-topincode         = ls_final-to_pincode. " For testing purpose hardcoded  '560009'.


    READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ls_final-to_state.
    IF sy-subrc = 0.
      ls_final_eway-tostatecode     = '5'." ls_statecode-legal_state_code. "29 For testing purpose hardcoded
      ls_final_eway-acttostatecode  =  ls_statecode-legal_state_code.  "29 For testing purpose hardcoded

      IF ls_statecode-legal_state_code < 10.
        SHIFT ls_final_eway-tostatecode LEFT DELETING LEADING '0'.
        SHIFT ls_final_eway-acttostatecode LEFT DELETING LEADING '0'.
      ENDIF.

*      IF ship_state IS NOT INITIAL.
*        READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ship_state.
*        IF sy-subrc = 0.
*          ls_final_eway-acttostatecode  =  ls_statecode-legal_state_code.  "29 For testing purpose hardcoded
*        ENDIF.
*      ENDIF.


      IF ls_statecode-legal_state_code < 10.
        SHIFT ls_final_eway-tostatecode LEFT DELETING LEADING '0'.
        SHIFT ls_final_eway-acttostatecode LEFT DELETING LEADING '0'.
      ENDIF.
      CLEAR ls_statecode.
    ENDIF.

    IF ls_final-order_type = 'ZEXP'.
      ls_final_eway-tostatecode = '99'.
*      ls_final_eway-acttostatecode = '96'.
    ENDIF.


    ls_final_eway-totalvalue        = ls_final-total_val + ls_final_eway-totalvalue.
    IF ls_final-total_val IS INITIAL.
      ls_final_eway-totalvalue        = 'null' .
    ENDIF.

    ls_final_eway-totinvvalue        = ls_final-total_val .
    IF ls_final-total_val IS INITIAL.
      ls_final_eway-totinvvalue        = 'null' .
    ENDIF.


    ls_final_eway-othvalue          = ls_final_eway-othvalue + ls_final-othvalue.
    ls_final_eway-cgstvalue         = ls_final_eway-cgstvalue + ls_final-cgst_amt.
    ls_final_eway-sgstvalue         = ls_final_eway-sgstvalue + ls_final-sgst_amt.
    ls_final_eway-igstvalue         = ls_final_eway-igstvalue + ls_final-igst_amt.

    ls_final_eway-cessvalue         = ls_final-cess_amt.

    IF ls_final_eway-cessvalue IS INITIAL.
      ls_final_eway-cessvalue = 'null'.
    ENDIF.

    ls_final_eway-totnonadvolval    = 'null'. "ls_final-


    READ TABLE lt_vbrk_j INTO ls_vbrk_j WITH KEY vbeln = ls_final-doc_no.
    IF sy-subrc = 0.
      IF ls_vbrk_j-mwsbk LT 0 .
        ls_vbrk_j-mwsbk = ls_vbrk_j-mwsbk * -1.
      ENDIF.
*
      IF ls_vbrk_j-netwr LT 0.
        ls_vbrk_j-netwr = ls_vbrk_j-netwr * -1.
      ENDIF.

      ls_final_eway-totinvvalue       = ls_vbrk_j-mwsbk + ls_vbrk_j-netwr." + ls_final_eway-totinvvalue. "ls_final-
      IF ls_final-order_type = 'ZEXP'.
        ls_final_eway-totinvvalue = ls_final_eway-totinvvalue * ls_vbrk_j-kurrf.
      ENDIF.
*      ls_final_eway-totalvalue        = ls_vbrk_j-mwsbk + ls_vbrk_j-netwr. "ls_final-
*      CLEAR ls_vbrk_j.
    ENDIF.


    IF ls_final-order_type = 'ZEXP'.
      ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_final_eway-cgstvalue + ls_final_eway-sgstvalue + ls_final_eway-igstvalue." + ls_final_eway-othvalue.
    ENDIF.


    ."1 = 'Road' 2 ='Rail 3 = Air 4 = Ship '
    IF ls_final_eway-cgstvalue IS INITIAL.
      ls_final_eway-cgstvalue = 'null'.
      ls_final_eway-sgstvalue = 'null'.
    ENDIF.

    IF ls_final_eway-igstvalue IS INITIAL.
      ls_final_eway-igstvalue = 'null'.
    ENDIF.
    IF ls_final_eway-othvalue IS INITIAL.
      ls_final_eway-othvalue          = 'null'. "ls_final-
    ENDIF.


*    BREAK primus.
    CASE ls_final-trans_mode.
      WHEN 'ROAD'.
        ls_final_eway-transmode         = '1' .
      WHEN 'RAIL'.
        ls_final_eway-transmode         = '2' .
      WHEN 'AIR'.
        ls_final_eway-transmode         = '3' .
      WHEN 'SHIP'.
        ls_final_eway-transmode         = '4' .
      WHEN OTHERS.
*        ls_final_eway-transmode         = 'null' .
        ls_final_eway-transmode         = '1' .
    ENDCASE.



    IF ls_final-distance_level IS NOT INITIAL.
      ls_final_eway-transdistance = round( val = ls_final-distance_level dec = 0 ).
      REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-transdistance WITH space.
      CONDENSE ls_final_eway-transdistance NO-GAPS.
    ELSE.
      ls_final_eway-transdistance     = 0.
    ENDIF.

    ls_final_eway-transportername   = ls_final-trans_name.
    ls_final_eway-transporterid     = ls_final-transport_id.
    ls_final_eway-transdocno        = ls_final-trans_doc_no.
    ls_final_eway-transdocdate      = ls_final-trans_date.

    IF ls_final-trans_date EQ '00000000' OR ls_final-trans_date IS INITIAL.
*      ls_final_eway-transdocdate     = 'null'.
      CLEAR ls_final_eway-transdocdate.
    ELSE.
*      ls_final_eway-transdocdate      = ls_final-trans_date.
      CONCATENATE ls_final_eway-transdocdate+6(2) '/' ls_final_eway-transdocdate+4(2) '/' ls_final_eway-transdocdate+0(4)
         INTO DATA(lv_date).
      ls_final_eway-transdocdate = lv_date.
    ENDIF.

    ls_final_eway-vehicleno         = ls_final-vehicle_no.
*    ls_final_eway-vehicletype       = ls_final-vehicletype.

    IF ls_final-vehicletype = 'Regular'.
      ls_final_eway-vehicletype = 'R'.
    ELSEIF ls_final-vehicletype = 'ODC'.
      ls_final_eway-vehicletype = 'O'.
    ENDIF.

    IF ls_final_eway-vehicleno IS NOT INITIAL.
*      ls_final_eway-vehicletype       = 'O'.
    ENDIF.
    ls_final_eway-transactiontype = '4'.


    IF ls_final_eway-transportername IS INITIAL.
      ls_final_eway-transportername = 'null'.
    ENDIF.

    IF ls_final_eway-transdocno IS INITIAL.
      ls_final_eway-transdocno = 'null'.
    ENDIF.

    IF ls_final_eway-transdocdate IS INITIAL.
      ls_final_eway-transdocdate = 'null'.
    ENDIF.

    IF ls_final_eway-vehicleno IS INITIAL.
      ls_final_eway-vehicleno = 'null'.
    ENDIF.

    IF ls_final_eway-vehicletype IS INITIAL.
      ls_final_eway-vehicletype  = 'null'.
    ENDIF.
*    IF ls_final-transport_id IS NOT INITIAL.
*
*    ELSE.
*      ls_final_eway-transporterid     = 'null'.
*    ENDIF.

*    IF ls_final-trans_doc_no IS NOT INITIAL.
*      ls_final_eway-transdocno        = ls_final-trans_doc_no.
*    ELSE.
*      ls_final_eway-transdocno     = 'null'.
*    ENDIF.



    IF ls_final_eway-portpin IS INITIAL.
      ls_final_eway-portpin     = 'null'.
    ENDIF.

    IF ls_final_eway-portname IS INITIAL.
      ls_final_eway-portname     = 'null'.
    ENDIF.









    ls_final_eway-mainhsncode       = ls_final-hsn_sac.
    REPLACE ALL   OCCURRENCES OF '.' IN ls_final_eway-mainhsncode WITH space.
    CONDENSE ls_final_eway-mainhsncode NO-GAPS.

    LOOP AT lt_json_data INTO DATA(ls_final1) WHERE doc_no = ls_final-doc_no.

      ls_itemlist-itemno          = ls_final1-posnr.
      ls_itemlist-productname    = ls_final1-material.
      ls_itemlist-productdesc    = ls_final1-arktx.
      REPLACE ALL  OCCURRENCES OF ',' IN ls_itemlist-productdesc WITH space.
      ls_itemlist-hsncode        = ls_final1-hsn_sac.
      REPLACE ALL OCCURRENCES OF '.' IN ls_itemlist-hsncode WITH space.
      CONDENSE ls_itemlist-hsncode NO-GAPS.
      IF ls_itemlist-hsncode IS INITIAL.
        ls_itemlist-hsncode = 'null'.
      ENDIF.

      ls_itemlist-quantity       = ls_final1-quantity.
*      ls_itemlist-qtyunit        = ls_final1-uqc.
      CALL FUNCTION 'ZEINV_UNIT_CONVERT'
        EXPORTING
          vrkme = ls_final1-uqc
        IMPORTING
          unit  = ls_itemlist-qtyunit.
*                .


      ls_itemlist-taxableamount  = ls_final1-taxable_value.
      ls_itemlist-sgstrate       = ls_final1-sgst_rate.
      CONDENSE ls_itemlist-sgstrate NO-GAPS.
      ls_itemlist-cgstrate       = ls_final1-cgst_rate.
      CONDENSE ls_itemlist-cgstrate NO-GAPS.
      ls_itemlist-igstrate       = ls_final1-igst_rate.
      CONDENSE ls_itemlist-igstrate NO-GAPS.
      ls_itemlist-cessrate       = ls_final1-cess_rate.
      CONDENSE ls_itemlist-cessrate NO-GAPS.
**        ls_final_eway-item_list-cessnonadvol   = ls_final1-
      ls_itemlist-cessnonadvol   = 'null'.


      APPEND ls_itemlist TO lt_itemlist.
      CLEAR ls_itemlist.

    ENDLOOP.

    ls_final_eway-itemlist = lt_itemlist.

    REFRESH lt_itemlist.

    APPEND ls_final_eway TO lt_final_eway.
*    CLEAR ls_final_eway.
  ENDLOOP.
*  BREAK primus.
  """""""End of JSON DATA"""""""""""""""""""
  DATA : lv_trex_json TYPE string.
  """"""""" Conversion of final to JSON format"""""""""""'

  CALL FUNCTION 'ZEWAY_BILL_JSON'
    EXPORTING
      data      = ls_final_eway
    IMPORTING
      trex_json = lv_trex_json.

  IF sy-subrc IS INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.

  DATA : lv_srno TYPE string VALUE 'itemno'.
*  DATA : lv_tax TYPE string VALUE 'supplytype'.
  DATA : lv_tax TYPE string VALUE 'zstyp'.
  DATA : cnt TYPE i VALUE 45.
  DATA : cnt_tax TYPE i VALUE 0.
  DATA : lv_flag(01) TYPE c.

  LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
    IF ls_json-line CS lv_tax.
      cnt_tax = 0.
      ls_json-tabix = cnt_tax.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_srno.
      cnt_tax = cnt_tax + 1.
      ls_json-tabix = cnt_tax.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.
    CLEAR ls_json.
*  clear <lfs_assign>.
  ENDLOOP.

  CLEAR :  sy-tabix , lv_flag .

  LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
    IF ls_json-line CS lv_srno.
      cnt = 46.
      ls_json-tabix = cnt.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_tax.
      cnt = cnt + 1.
      ls_json-tabix = cnt.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.
    CLEAR ls_json.
*  clear <lfs_assign>.
  ENDLOOP.
*  BREAK primus.
  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).
***    REPLACE all OCCURRENCES OF '",' in <lfs_json_main> WITH ',"'.
    CASE <lfs_json_main>-tabix.
*    CASE <lfs_json_main>-index.
*****      WHEN '1'. "Excelon
*****        REPLACE 'usergstin'            IN <lfs_json_main> WITH '"userGstin"'.
      WHEN '1'.
        REPLACE 'zstyp'           IN <lfs_json_main> WITH '"supplyType"'.
      WHEN '2'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'subsupplytype'        IN <lfs_json_main> WITH '"subSupplyType"'.
      WHEN '3'.
        REPLACE 'subsupplydesc'        IN <lfs_json_main> WITH '"subSupplyDesc"'.

      WHEN '4'.
        REPLACE 'doctype'              IN <lfs_json_main> WITH '"docType"'.
      WHEN '5'.
        REPLACE 'docno'                IN <lfs_json_main> WITH '"docNo"'.
      WHEN '6'.
        REPLACE 'docdate'              IN <lfs_json_main> WITH '"docDate"'.
      WHEN '7'.
        REPLACE 'fromgstin'            IN <lfs_json_main> WITH '"fromGstin"'.
      WHEN '8'.
        REPLACE 'fromtrdname'          IN <lfs_json_main> WITH '"fromTrdName"'.
      WHEN '9'.
        REPLACE 'fromaddr1'            IN <lfs_json_main> WITH '"fromAddr1"'.
      WHEN '10'.
        REPLACE 'fromaddr2'            IN <lfs_json_main> WITH '"fromAddr2"'.
      WHEN '11'.
        REPLACE 'fromplace'            IN <lfs_json_main> WITH '"fromPlace"'.
      WHEN '12'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'frompincode'          IN <lfs_json_main> WITH '"fromPincode"'.
      WHEN '13'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'fromstatecode'        IN <lfs_json_main> WITH '"fromStateCode"'.
      WHEN '14'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'actfromstatecode'  IN <lfs_json_main> WITH '"actFromStateCode"'.
      WHEN '15'.
        REPLACE 'togstin'              IN <lfs_json_main> WITH '"toGstin"'.
      WHEN '16'.
        REPLACE 'totrdname'            IN <lfs_json_main> WITH '"toTrdName"'.
      WHEN '17'.
        REPLACE 'toaddr1'              IN <lfs_json_main> WITH '"toAddr1"'.
      WHEN '18'.
        REPLACE 'toaddr2'              IN <lfs_json_main> WITH '"toAddr2"'.
      WHEN '19'.
        REPLACE 'toplace'              IN <lfs_json_main> WITH '"toPlace"'.
      WHEN '20'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'topincode'            IN <lfs_json_main> WITH '"toPincode"'.
      WHEN '21'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'tostatecode'          IN <lfs_json_main> WITH '"toStateCode"'.
      WHEN '22'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'acttostatecode'    IN <lfs_json_main> WITH '"actToStateCode"'.
      WHEN '23'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totalvalue'           IN <lfs_json_main> WITH '"totalValue"'.
      WHEN '24'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'transactiontype'           IN <lfs_json_main> WITH '"transactionType"'.
      WHEN '25'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cgstvalue'            IN <lfs_json_main> WITH '"cgstValue"'.
      WHEN '26'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'sgstvalue'            IN <lfs_json_main> WITH '"sgstValue"'.
      WHEN '27'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'igstvalue'            IN <lfs_json_main> WITH '"igstValue"'.
      WHEN '28'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cessvalue'            IN <lfs_json_main> WITH '"cessValue"'.
      WHEN '29'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totnonadvolval'       IN <lfs_json_main> WITH '"TotNonAdvolVal"'.
      WHEN '30'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'othvalue'             IN <lfs_json_main> WITH '"OthValue"'.
      WHEN '31'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'totinvvalue'          IN <lfs_json_main> WITH '"totInvValue"'.
      WHEN '32'.
*        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transmode'            IN <lfs_json_main> WITH '"transMode"'.
      WHEN '33'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transdistance'        IN <lfs_json_main> WITH '"transDistance"'.
      WHEN '34'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transportername'      IN <lfs_json_main> WITH '"transporterName"'.
      WHEN '35'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transporterid'        IN <lfs_json_main> WITH '"transporterId"'.
      WHEN '36'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'transdocno'           IN <lfs_json_main> WITH '"transDocNo"'.
      WHEN '37'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'transdocdate'         IN <lfs_json_main> WITH '"transDocDate"'.
      WHEN '38'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'vehicleno'            IN <lfs_json_main> WITH '"vehicleNo"'.
      WHEN '39'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        ENDIF.
        REPLACE 'vehicletype'          IN <lfs_json_main> WITH '"vehicleType"'.
      WHEN '40'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE ALL OCCURRENCES OF '.' IN <lfs_json_main> WITH space.
        REPLACE 'mainhsncode'          IN <lfs_json_main> WITH '"mainHsnCode"'.
      WHEN '41'.
        REPLACE 'shiptogstin'          IN <lfs_json_main> WITH '"shipToGstin"'.

      WHEN '42'.
        REPLACE 'shiptotradename'          IN <lfs_json_main> WITH '"shipToTradename"'.

      WHEN '43'.
        REPLACE 'dispatchfromgstin'          IN <lfs_json_main> WITH '"dispatchFromGstin"'.

      WHEN '44'.
        REPLACE 'dispatchfromtradename'          IN <lfs_json_main> WITH '"dispatchFromTradename"'.

      WHEN '45'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'portpin'          IN <lfs_json_main> WITH '"portPin"'.

      WHEN '46'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'portname'          IN <lfs_json_main> WITH '"portName"'.

      WHEN '47'.
        REPLACE 'itemno'               IN <lfs_json_main> WITH '"itemNo"'.
        REPLACE 'itemlist'               IN <lfs_json_main> WITH '"itemList"'.
      WHEN '48'.
        REPLACE 'productname'          IN <lfs_json_main> WITH '"productName"'.
      WHEN '49'.
        REPLACE 'productdesc'          IN <lfs_json_main> WITH '"productDesc"'.
      WHEN '50'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE ALL OCCURRENCES OF '.' IN <lfs_json_main> WITH space.
        REPLACE 'hsncode'              IN <lfs_json_main> WITH '"hsnCode"'.
      WHEN '51'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'quantity'             IN <lfs_json_main> WITH '"quantity"'.
      WHEN '52'.
        REPLACE 'qtyunit'              IN <lfs_json_main> WITH '"qtyUnit"'.
      WHEN '53'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'taxableamount'        IN <lfs_json_main> WITH '"taxableAmount"'.
      WHEN '54'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'sgstrate'             IN <lfs_json_main> WITH '"sgstRate"'.
      WHEN '55'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cgstrate'             IN <lfs_json_main> WITH '"cgstRate"'.
      WHEN '56'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'igstrate'             IN <lfs_json_main> WITH '"igstRate"'.
      WHEN '57'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
        REPLACE 'cessrate'             IN <lfs_json_main> WITH '"cessRate"'.
      WHEN '58'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'cessnonadvol'         IN <lfs_json_main> WITH '"cessNonAdvol"'.

    ENDCASE.
  ENDLOOP.

  DATA : ls_str TYPE string.
  DATA : lv_gstin TYPE string.

  DATA :ewaybill_no   TYPE string,
        ewaybill_date TYPE string,
        valid_upto    TYPE string,
        status        TYPE char1,
        msg           TYPE string,
        alert         TYPE string.


  """"""""""""""""""""""""""""""""""""""""""""""' API  CODE """"""""""""""""""""""""""""""

  CLEAR : ls_str.
  REFRESH : lt_json_output.


  LOOP AT it_json INTO ls_json.

    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.
    CLEAR :  ls_json , ls_json_output.

  ENDLOOP.

  lv_gstin = gstin.

  CONDENSE ls_str NO-GAPS.

**DOWNLOAD FILE
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = file_name "'C:/desktop/E-INVOICE.json'
    CHANGING
      data_tab = lt_json_output "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
               TYPE 'I'.
  ENDIF.


  PERFORM auth.
*****  REPLACE ALL OCCURRENCES OF '"' IN ls_str WITH '\\\"'.

  CLEAR ls_json_output-line .

  CONCATENATE '{"action": "GENEWAYBILL", "data":' ls_str '}' INTO ls_str.
  REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
  CONCATENATE ls_str '}' INTO ls_str.
*REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
  CONDENSE ls_str.


  """"""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""

  DATA :tokan TYPE string.

  CLEAR :tokan.

  READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
  tokan = ls_ein_tokan-value.
  CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

  DATA xconn TYPE string.
  CLEAR: xconn.

*  xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180607093257:27GSPMH2101G1Z2'."DEV
  xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.



  DATA lv_url TYPE string.

  lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'.

  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url
    IMPORTING
      client             = DATA(lo_http_client)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).


  lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json'.


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = tokan ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Action'
      value = 'GENEWAYBILL' ).


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'gstin'
      value = '27AACCD2898L1Z4' ).
*   value = '05AAACG5222D1ZA' )."DEV


  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'X-Connector-Auth-Token'
      value = xconn ).


  lo_http_client->request->set_method(
    EXPORTING
      method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
    EXPORTING
      data = ls_str ).


  lo_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).

*  BREAK primus.
  CHECK sy-subrc = 0.
  DATA(lv_response) = lo_http_client->response->get_cdata( ).

  REPLACE ALL OCCURRENCES OF '{"data":{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{"error":[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.

  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 1000 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.

  READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
  IF sy-subrc EQ 0.
    lv_resp_status = ls_res-value.
  ENDIF.

  IF lv_resp_status = '1'.


    LOOP AT lt_res ASSIGNING FIELD-SYMBOL(<f2>).
*      REPLACE ALL  OCCURRENCES OF '\' IN <f2>-value WITH ''.
*      REPLACE ALL  OCCURRENCES OF '{' IN <f2>-value WITH ''.
*      REPLACE ALL  OCCURRENCES OF '/' IN <f2>-value WITH ''.

      IF <f2>-header CS 'ewayBillNo'.
        lv_ewaybill = <f2>-value.
      ENDIF.

      IF <f2>-header CS 'ewayBillDate'.
*  IF ewaybill_date IS NOT INITIAL.
        lv_ewaybill_dt = <f2>-value+0(10).
        CONCATENATE lv_ewaybill_dt+6(4) lv_ewaybill_dt+3(2) lv_ewaybill_dt+0(2) INTO lv_ewaybill_dt.

        lv_ewaybill_tm = <f2>-value+11(11).
        CONCATENATE lv_ewaybill_tm+0(2) lv_ewaybill_tm+3(2) lv_ewaybill_tm+6(2) INTO lv_ewaybill_time.
        MOVE lv_ewaybill_time TO lv_vdfmtime.
        IF lv_ewaybill_tm+9(2) = 'PM'.
          CALL FUNCTION 'HRVE_CONVERT_TIME'
            EXPORTING
              type_time       = 'B'
              input_time      = lv_vdfmtime
              input_am_pm     = 'PM'
            IMPORTING
              output_time     = lv_vdfmtime
            EXCEPTIONS
              parameter_error = 1
              OTHERS          = 2.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
        ENDIF.

      ENDIF.
*
*  ENDIF.
*      ENDIF.
*
      IF <f2>-header CS 'validUpto'.
        IF <f2>-value NE 'null'.
*  IF valid_upto IS NOT INITIAL.
          lv_ewaybill_exdt = <f2>-value+0(10).
          CONCATENATE lv_ewaybill_exdt+6(4) lv_ewaybill_exdt+3(2) lv_ewaybill_exdt+0(2) INTO lv_ewaybill_exdt.

          lv_ewaybill_extm = <f2>-value+11(11).
          CONCATENATE lv_ewaybill_extm+0(2) lv_ewaybill_extm+3(2) lv_ewaybill_extm+6(2) INTO lv_ewaybill_extime.



          MOVE lv_ewaybill_extime TO lv_vdtotime.
          IF lv_ewaybill_extm+9(2) = 'PM'.
            CALL FUNCTION 'HRVE_CONVERT_TIME'
              EXPORTING
                type_time       = 'B'
                input_time      = lv_vdtotime
                input_am_pm     = 'PM'
              IMPORTING
                output_time     = lv_vdtotime
              EXCEPTIONS
                parameter_error = 1
                OTHERS          = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*        ENDIF.
*      ENDIF.
*
    ENDLOOP.
*  ENDIF.  "commented by swati

  ELSE.
    READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.                "INDEX 5.
    IF sy-subrc EQ 0.
      msg = ls_res-value.
    ENDIF.
  ENDIF.
  LOOP AT lt_final ASSIGNING FIELD-SYMBOL(<f3>) WHERE selection = 'X'.

    IF lv_ewaybill IS NOT INITIAL.
      <f3>-process_status = TEXT-003. "'@08\Q Completly Processed@'.
      <f3>-status_description = TEXT-004. "'Completly Processed'.

      <f3>-eway_bil =   lv_ewaybill.
      <f3>-eway_dt  =   lv_ewaybill_dt.
      <f3>-vdfmtime = lv_vdfmtime.
      <f3>-eway_dt_exp = lv_ewaybill_exdt.
      <f3>-vdtotime   = lv_vdtotime.
      <f3>-message = ' Eway Bill Sucessfully Generated'.
      <f3>-veh_no = ls_eway_bill-vehical_no.
      <f3>-created_by = sy-uname.
      <f3>-created_dt = sy-datum.
      <f3>-created_time = sy-uzeit.

      ls_eway_number-vbeln          =  <f3>-vbeln.
      ls_eway_number-eway_bill      =  <f3>-eway_bil.
*      ls_eway_number-CONEWAYNO      =
      ls_eway_number-ewaybilldate   = <f3>-eway_dt.
      ls_eway_number-vdfmtime       = lv_vdfmtime.
      ls_eway_number-validuptodate  = <f3>-eway_dt_exp.
      ls_eway_number-vdtotime       = <f3>-vdtotime.
      ls_eway_number-zzstatus       = 'C'.
      ls_eway_number-message        =  <f3>-message.
      ls_eway_number-createdby      = <f3>-created_by.
      ls_eway_number-creationdt     = <f3>-created_dt.
      ls_eway_number-creationtime   = <f3>-created_time.
    ELSE.
      <f3>-process_status = TEXT-009. "'@0A\Q Error!@'.
      <f3>-status_description = TEXT-010. "'Error'.
      ls_eway_number-vbeln          = <f3>-vbeln.
      ls_eway_number-zzstatus       = 'E'.
      <f3>-message = msg.
      ls_eway_number-message        =  msg.
    ENDIF.

    APPEND ls_eway_number TO lt_eway_number.
    CLEAR : ls_eway_number.
  ENDLOOP.

  LOOP AT lt_eway_number INTO ls_eway_number.
    SELECT SINGLE vbeln FROM zeway_number INTO @DATA(ls_vbeln) WHERE vbeln = @ls_eway_number-vbeln .
    IF sy-subrc = 0.
      UPDATE zeway_number SET eway_bill = ls_eway_number-eway_bill
                               conewayno = ls_eway_number-conewayno
                               ewaybilldate = ls_eway_number-ewaybilldate
                               vdfmtime   = ls_eway_number-vdfmtime
                               validuptodate = ls_eway_number-validuptodate
                               vdtotime = ls_eway_number-vdtotime
                               createdby = ls_eway_number-createdby
                               creationdt = ls_eway_number-creationdt
                               creationtime = ls_eway_number-creationtime
                               zzstatus = ls_eway_number-zzstatus
                               canreason = ls_eway_number-canreason
                               canceldt = ls_eway_number-canceldt
                               cancelremark = ls_eway_number-cancelremark
                               message = ls_eway_number-message
                          WHERE vbeln = ls_eway_number-vbeln.

    ELSE.
      MODIFY zeway_number FROM ls_eway_number.
    ENDIF.
  ENDLOOP.




  REFRESH: lt_response,lt_res,lt_eway_number,it_json,lt_json_data,lt_vbrp,lt_final_temp,gt_ewaybill_details,lt_final_eway.
  CLEAR : ls_str,lv_gstin,ls_res,ls_final_eway ,lv_response.
  CLEAR :lv_trex_json,zeway_bill,lv_ewaybill,lv_ewaybill_dt,lv_ewaybill_exdt,lv_temp,gs_ewaybill_details.
ENDFORM.



INCLUDE zewaybill_screen_200_v02.
*INCLUDE zewaybill_screen_200. "Input Screen for Transport details
INCLUDE zewaybill_screen_300_v02.
*INCLUDE zewaybill_screen_300. "Input screen for Cancel eway bill request.
INCLUDE zewaybill_screen_400_v02.
*INCLUDE zewaybill_screen_400. "Input screen for update vehical numberfor  eway bill request.

INCLUDE z_ewaybill_generation_v02.
*INCLUDE z_ewaybill_generation_es_ref01.
*&---------------------------------------------------------------------*
*&      Form  ES_REMOVE_SPECIAL_CHARACTER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_TEXT  text
*      <--P_E_TEXT  text
*----------------------------------------------------------------------*
FORM es_remove_special_character  USING    p_i_text
                                  CHANGING p_e_text.

  CALL FUNCTION 'ES_REMOVE_SPECIAL_CHARACTER'
    EXPORTING
      text1       = p_i_text
    IMPORTING
      corr_string = p_e_text.


ENDFORM.

INCLUDE zewaybill_screen_500_v02.
*INCLUDE zewaybill_screen_500.

INCLUDE z_ewaybill_generation_v_02_i01.

INCLUDE z_ewaybill_generation_v_02_i02.

INCLUDE z_ewaybill_generation_v_02_i03.

INCLUDE z_ewaybill_generation_v_02_i04.

INCLUDE z_ewaybill_generation_v_02_i05.

INCLUDE z_ewaybill_generation_v_02_i06.
*&---------------------------------------------------------------------*
*&      Module  INPUT_STATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE input_state INPUT.

  DATA: ls_state_ret1 TYPE ddshretval,
        lt_state_ret1 TYPE TABLE OF ddshretval.



  SELECT zstcode,zstdecr FROM zstate_code INTO TABLE @DATA(lt_state2).
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'ZSTCODE' "internal table field
      dynpprog        = 'Z_EWAYBILL_GENERATION' "program name
      dynpnr          = '0700' "screen number
      dynprofield     = 'ZEWAY_MULTI_VEH-FROMSTATECODE' "screen field name
      value_org       = 'S'
    TABLES
      value_tab       = lt_state2 "internal table
      return_tab      = lt_state_ret1
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    READ TABLE lt_state_ret1 INTO ls_state_ret1 INDEX 1.
    IF sy-subrc = 0.
      zeway_multi_veh-fromstatecode = ls_state_ret1-fieldval.
    ENDIF.
  ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INPUT_STATE1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE input_state1 INPUT.

  DATA: ls_state_ret3 TYPE ddshretval,
        lt_state_ret3 TYPE TABLE OF ddshretval.



  SELECT zstcode,zstdecr FROM zstate_code INTO TABLE @DATA(lt_state3).
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'ZSTCODE' "internal table field
      dynpprog        = 'Z_EWAYBILL_GENERATION' "program name
      dynpnr          = '0700' "screen number
      dynprofield     = 'ZEWAY_BILL-TO_STATE' "screen field name
      value_org       = 'S'
    TABLES
      value_tab       = lt_state3 "internal table
      return_tab      = lt_state_ret3
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    READ TABLE lt_state_ret3 INTO ls_state_ret3 INDEX 1.
    IF sy-subrc = 0.
      zeway_multi_veh-to_state = ls_state_ret3-fieldval.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SCREEN_LAYOUT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE screen_layout OUTPUT.
  CLEAR :zeway_multi_veh.
  IF r1 IS INITIAL AND r2 IS INITIAL AND r3 IS INITIAL.
    r1 = 'X'.
  ENDIF.
  IF r1 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'AH' OR  screen-group1 = 'CH'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN .
    ENDLOOP.
  ELSEIF r2 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'MV' OR  screen-group1 = 'CH'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN .
    ENDLOOP.

  ELSEIF r3 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'AH' OR  screen-group1 = 'MV'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN .
    ENDLOOP.
  ENDIF.

  IF zeway_multi_veh-trns_md IS INITIAL.
    zeway_multi_veh-trns_md = 'ROAD'.
  ENDIF.

ENDMODULE.

INCLUDE zewaybill_screen_201_v02.
*&---------------------------------------------------------------------*
*&      Module  INPUT_GROUP1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE input_group1 INPUT.
  DATA: ls_state_ret5 TYPE ddshretval,
        lt_state_ret5 TYPE TABLE OF ddshretval.

  TYPES : BEGIN OF ty_veh,
            eway_bill TYPE zeway_multi_veh-eway_bill,
            group1    TYPE zeway_multi_veh-group1,
            fromplace TYPE zeway_multi_veh-fromplace,
            to_place  TYPE zeway_multi_veh-to_place,
            tot_qty   TYPE zeway_multi_veh-tot_qty,
            unit      TYPE zeway_multi_veh-unit,
          END OF ty_veh.

  DATA : it_veh TYPE TABLE OF ty_veh,
         wa_veh TYPE ty_veh.

  TYPES : BEGIN OF ty_group,
            group1    TYPE zeway_multi_veh-group1,
            fromplace TYPE zeway_multi_veh-fromplace,
            to_place  TYPE zeway_multi_veh-to_place,
          END OF ty_group.


  DATA : gt_gr TYPE TABLE OF ty_group,
         gs_gr TYPE ty_group.
  DATA : lt_return1 TYPE TABLE OF  ddshretval,
         wa_return1 TYPE  ddshretval.

  DATA: lv_qty TYPE string.
*
*  BREAK primus.
  SELECT eway_bill group1 fromplace to_place tot_qty unit FROM zeway_multi_veh INTO TABLE it_veh
                                         WHERE  eway_bill = ls_final-eway_bil.
*                                          AND fromplace = zeway_multi_veh-fromplace
*  AND to_state   = zeway_multi_veh-to_state.

*  READ TABLE it_veh INTO wa_veh INDEX 1.
  LOOP AT it_veh INTO wa_veh.
    lv_qty =  wa_veh-tot_qty.
    gs_gr-group1    =  wa_veh-group1   .
    gs_gr-fromplace =  wa_veh-fromplace.
    gs_gr-to_place  =  wa_veh-to_place .
*  CONCATENATE wa_veh-fromplace wa_veh-to_place lv_qty wa_veh-unit INTO gs_gr-group1.
    APPEND gs_gr TO gt_gr.
    CLEAR : gs_gr.
  ENDLOOP.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      retfield        = 'GROUP1'
*     PVALKEY         = ' '
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZEWAY_MULTI_VEH-GROUP1'
      value_org       = 'S'
    TABLES
      value_tab       = gt_gr[]
*     FIELD_TAB       =
      return_tab      = lt_return1[]
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    READ TABLE lt_return1 INTO wa_return1 INDEX 1.
    IF sy-subrc = 0.
      zeway_multi_veh-group1 =  wa_return1-fieldval.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  MULTI_VEHICAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM multi_vehical .
  IF r1 = 'X' .
    gs_eway_multi_init-ewbno           =    <ls_final>-eway_bil.
    gs_eway_multi_init-reasoncode      =    zeway_multi_veh-reasoncode.
    gs_eway_multi_init-reason          =    zeway_multi_veh-reason.
    gs_eway_multi_init-fromplace       =    zeway_multi_veh-fromplace.
    gs_eway_multi_init-fromstate   =    zeway_multi_veh-fromstatecode.
    gs_eway_multi_init-toplace        =    zeway_multi_veh-to_place.
    gs_eway_multi_init-tostate        =    zeway_multi_veh-to_state.

    IF gs_eway_multi_init-tostate < 10.
      SHIFT gs_eway_multi_init-tostate LEFT DELETING LEADING '0'.
      SHIFT gs_eway_multi_init-tostate LEFT DELETING LEADING '0'.
    ENDIF.

    IF gs_eway_multi_init-fromstate < 10.
      SHIFT gs_eway_multi_init-fromstate LEFT DELETING LEADING '0'.
      SHIFT gs_eway_multi_init-fromstate LEFT DELETING LEADING '0'.
    ENDIF.

    gs_eway_multi_init-trnsmd         =    zeway_multi_veh-trns_md.

    CASE gs_eway_multi_init-trnsmd.
      WHEN 'ROAD'.
        gs_eway_multi_init-trnsmd         = '1' .
      WHEN 'RAIL'.
        gs_eway_multi_init-trnsmd         = '2' .
      WHEN 'AIR'.
        gs_eway_multi_init-trnsmd         = '3' .
      WHEN 'SHIP'.
        gs_eway_multi_init-trnsmd         = '4' .
      WHEN OTHERS.
*        ls_final_eway-transmode         = 'null' .
        gs_eway_multi_init-trnsmd         = '1' .
    ENDCASE.

    gs_eway_multi_init-totqty         =    zeway_multi_veh-tot_qty.
    gs_eway_multi_init-unit            =    zeway_multi_veh-unit.



    DATA : lv_trex_json TYPE string.
    CLEAR :lv_trex_json.
    CALL FUNCTION 'ZEWAY_BILL_JSON'
      EXPORTING
        data      = gs_eway_multi_init
      IMPORTING
        trex_json = lv_trex_json.

    REFRESH it_json.

    IF sy-subrc IS INITIAL.
      REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
      SPLIT lv_trex_json AT '#' INTO TABLE it_json .
    ENDIF.



    DATA : cnt TYPE i VALUE 0.

    CLEAR :  cnt.


    LOOP AT it_json ASSIGNING FIELD-SYMBOL(<ls_json>).
      cnt = cnt + 1.
      <ls_json>-tabix = cnt.
    ENDLOOP.



    LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).

      CASE <lfs_json_main>-tabix.
        WHEN '1'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
          REPLACE 'ewbno'  IN <lfs_json_main> WITH '"ewbNo"'.
        WHEN '2'.
          REPLACE 'reasoncode'  IN <lfs_json_main> WITH '"reasonCode"'.
        WHEN '3'.
          REPLACE 'reason'  IN <lfs_json_main> WITH '"reasonRem"'.   "fromplace
        WHEN '4'.
          REPLACE 'fromplace'  IN <lfs_json_main> WITH '"fromPlace"'.
        WHEN '5'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
          REPLACE 'fromstate'  IN <lfs_json_main> WITH '"fromState"'.
        WHEN '6'.
          REPLACE 'toplace'  IN <lfs_json_main> WITH '"toPlace"'.
        WHEN '7'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
          REPLACE 'tostate'  IN <lfs_json_main> WITH '"toState"'.
        WHEN '8'.
          REPLACE 'trnsmd'  IN <lfs_json_main> WITH '"transMode"'.
        WHEN '9'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
          REPLACE 'totqty'  IN <lfs_json_main> WITH '"totalQuantity"'.
        WHEN '10'.
          REPLACE 'unit'  IN <lfs_json_main> WITH '"unitCode"'.
      ENDCASE.


    ENDLOOP.

    CLEAR : ls_str.

    LOOP AT it_json INTO ls_json.

      ls_json_output-line = ls_json-line.
      CONCATENATE  ls_str ls_json-line  INTO ls_str.
      APPEND ls_json_output TO lt_json_output.
      CLEAR :  ls_json . ", ls_json_output.

    ENDLOOP.

    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename = 'C:/desktop/multi.json'
      CHANGING
        data_tab = lt_json_output "lv_json "
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc EQ 0.

      MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
                 TYPE 'I'.
    ENDIF.

    CONDENSE ls_str NO-GAPS.



    CLEAR : gv_ewaybill_no,gv_updated_date,gv_valid_upto,gv_status,gv_mesg.



    PERFORM auth.

    CONCATENATE '{"action": "MULTIVEHMOVINT", "data":' ls_str '}' INTO ls_str.
    REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
    CONCATENATE ls_str '}' INTO ls_str.
*REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
    CONDENSE ls_str.

    """"""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""

    DATA :tokan TYPE string.

    CLEAR :tokan.

    READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
    tokan = ls_ein_tokan-value.
    CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

    DATA xconn TYPE string.
    CLEAR: xconn.

*xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180607093257:27GSPMH2101G1Z2'."DEV
    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.""""""""" PRD
**    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AAACG5222D1ZA'.



    DATA lv_url TYPE string.
*lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."DEV
*    lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'.  """""""""""" PRD
    lv_url = 'https://qa.gsthero.com/ewb/enc/v1.03/ewayapi'.  """""""""""" Dev

    cl_http_client=>create_by_url(
      EXPORTING
        url                = lv_url
      IMPORTING
        client             = DATA(lo_http_client)
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4 ).


    lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

    lo_http_client->request->set_method(
      EXPORTING
        method = 'POST' ).     "if_http_entity=>co_request_method_post


    lo_http_client->request->set_content_type(
      EXPORTING
        content_type = if_rest_media_type=>gc_appl_json ).

    CALL METHOD lo_http_client->request->set_header_field
      EXPORTING
        name  = 'Content-Type'
        value = 'application/json'.


    lo_http_client->request->set_header_field(            "
      EXPORTING
        name  = 'Authorization'
        value = tokan ).

    lo_http_client->request->set_header_field(            "
      EXPORTING
        name  = 'Action'
        value = 'MULTIVEHMOVINT' ).


    lo_http_client->request->set_header_field(            "
      EXPORTING
        name  = 'gstin'
        value = '27AACCD2898L1Z4' ).  """ PRD
*   value = '05AAACG5222D1ZA' )."DEV


    lo_http_client->request->set_header_field(
      EXPORTING
        name  = 'Accept'
        value = 'application/json' ).

    lo_http_client->request->set_header_field(            "
      EXPORTING
        name  = 'X-Connector-Auth-Token'
        value = xconn ).


    lo_http_client->request->set_method(
      EXPORTING
        method = if_http_entity=>co_request_method_post ).


    lo_http_client->request->set_content_type(
      EXPORTING
        content_type = if_rest_media_type=>gc_appl_json ).


    lo_http_client->request->set_cdata(
      EXPORTING
        data = ls_str ).


    lo_http_client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2 ).


    CHECK sy-subrc = 0.
    lo_http_client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3 ).

*    BREAK primus.
    CLEAR:ls_response,lt_response,ls_res,lt_res,lv_resp_status.
    CHECK sy-subrc = 0.
    DATA(lv_response) = lo_http_client->response->get_cdata( ).

    REPLACE ALL OCCURRENCES OF '{"data":{' IN lv_response WITH ' '.
    REPLACE ALL OCCURRENCES OF '{"error":[{' IN lv_response WITH ' '.
    REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
    REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
    REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
    REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
    SPLIT lv_response AT ',' INTO TABLE lt_response.

    LOOP AT  lt_response INTO ls_response.
      REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
      SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

      IF sy-tabix LE 1000 .
        APPEND ls_res TO lt_res.
        CLEAR ls_res.
      ENDIF.

    ENDLOOP.

    READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
    IF sy-subrc EQ 0.
      lv_resp_status = ls_res-value.
    ENDIF.

    IF lv_resp_status = '1'.
      CLEAR :gs_eway_multi_veh.
      REFRESH :gt_eway_multi_veh.
      SELECT MAX( sr_no ) INTO @DATA(lv_no) FROM zeway_multi_veh.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF lv_no IS INITIAL .
          gs_eway_multi_veh-sr_no            =    1.
        ENDIF.
        gs_eway_multi_veh-sr_no           =    lv_no + 1.
        gs_eway_multi_veh-bukrs           =    <ls_final>-bukrs.
        gs_eway_multi_veh-vbeln           =    <ls_final>-vbeln.
        gs_eway_multi_veh-reasoncode      =    zeway_multi_veh-reasoncode.
        gs_eway_multi_veh-fromplace       =    zeway_multi_veh-fromplace.
        gs_eway_multi_veh-fromstatecode   =    zeway_multi_veh-fromstatecode.
        gs_eway_multi_veh-trns_md         =    zeway_multi_veh-trns_md.
        gs_eway_multi_veh-unit            =    zeway_multi_veh-unit.
        gs_eway_multi_veh-reason          =    zeway_multi_veh-reason.
        gs_eway_multi_veh-to_place        =    zeway_multi_veh-to_place.
        gs_eway_multi_veh-to_state        =    zeway_multi_veh-to_state.
        gs_eway_multi_veh-tot_qty         =    zeway_multi_veh-tot_qty.
        gs_eway_multi_veh-lifnr           =    zeway_bill-lifnr.
        gs_eway_multi_veh-eway_bill       =    <ls_final>-eway_bil.
*        gs_eway_multi_veh-GROUP1          =    zeway_multi_veh-GROUP1.
        gs_eway_multi_veh-vehical_no      =   zeway_multi_veh-vehical_no.
        gs_eway_multi_veh-trans_doc       =   zeway_multi_veh-trans_doc.
        gs_eway_multi_veh-doc_dt          =   zeway_multi_veh-doc_dt.
        gs_eway_multi_veh-qty             =   zeway_multi_veh-qty.
        gs_eway_multi_veh-old_vehical     =    zeway_multi_veh-old_vehical.
        gs_eway_multi_veh-new_vehical     =    zeway_multi_veh-new_vehical.
        gs_eway_multi_veh-old_trans_no    =    zeway_multi_veh-old_trans_no.
        gs_eway_multi_veh-new_trans_no    =    zeway_multi_veh-new_trans_no..
        APPEND gs_eway_multi_veh TO gt_eway_multi_veh.
      ENDLOOP.

      CLEAR ls_res.
      LOOP AT lt_res INTO ls_res..

        IF ls_res-header CS 'ewbNo'.
          gs_eway_multi_veh-multi_eway = ls_res-value.
        ENDIF.

        IF ls_res-header CS 'groupNo'.
          gs_eway_multi_veh-group1 = ls_res-value.
        ENDIF.

        IF ls_res-header CS 'createdDate'.
          IF ls_res-value NE 'null'.


            lv_ewaybill_dt = ls_res-value+0(10).
            CONCATENATE lv_ewaybill_dt+6(4) lv_ewaybill_dt+3(2) lv_ewaybill_dt+0(2) INTO lv_ewaybill_dt.

            lv_ewaybill_tm = ls_res-value+11(11).
            CONCATENATE lv_ewaybill_tm+0(2) lv_ewaybill_tm+3(2) lv_ewaybill_tm+6(2) INTO lv_ewaybill_time.

            MOVE lv_ewaybill_time TO lv_vdtotime.
            IF lv_ewaybill_tm+9(2) = 'PM'.
              CALL FUNCTION 'HRVE_CONVERT_TIME'
                EXPORTING
                  type_time       = 'B'
                  input_time      = lv_vdtotime
                  input_am_pm     = 'PM'
                IMPORTING
                  output_time     = lv_vdtotime
                EXCEPTIONS
                  parameter_error = 1
                  OTHERS          = 2.
              IF sy-subrc <> 0.
*              * Implement suitable error handling here
              ENDIF.

            ENDIF.

            MOVE lv_vdtotime TO gs_eway_multi_veh-cr_time.
            MOVE lv_ewaybill_dt	TO gs_eway_multi_veh-cr_date.
          ENDIF.
        ENDIF.

      ENDLOOP.


      IF gt_eway_multi_veh IS NOT INITIAL.
        MESSAGE 'Eway Bill Sucessfully Multi-Vehicle Initiate' TYPE 'I'.
        <ls_final>-message     = 'Eway Bill Sucessfully Multi-Vehicle Initiate'.
        MODIFY zeway_multi_veh FROM gs_eway_multi_veh.
      ENDIF.


    ELSE.
      CLEAR ls_res.
      READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.

      IF sy-subrc = 0.
        MESSAGE ls_res-value TYPE 'I'.
        <ls_final>-message     = ls_res-value ."'Eway Bill not Updated'.
      ELSE.
        MESSAGE 'Eway Bill Multi-Vehicle Not Initiate' TYPE 'I'.
        <ls_final>-message     = 'Eway Bill Multi-Vehicle Not Initiate'.
      ENDIF.


    ENDIF.

  ENDIF.



ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MULTI_VEHICAL_ADD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM multi_vehical_add .

  IF r2 = 'X' .
*    BREAK primus.
    gs_eway_multi_add-ewbno           =    <ls_final>-eway_bil.
    gs_eway_multi_add-group            =    zeway_multi_veh-group1.
    gs_eway_multi_add-qty             =   zeway_multi_veh-qty.
    gs_eway_multi_add-transdate        =   zeway_multi_veh-doc_dt.
    gs_eway_multi_add-transdocno       =   zeway_multi_veh-trans_doc.
    gs_eway_multi_add-vehicle       =   zeway_multi_veh-vehical_no.

    IF zeway_multi_veh-doc_dt EQ '00000000' OR zeway_multi_veh-doc_dt IS INITIAL.
*      ls_final_eway-transdocdate     = 'null'.
      CLEAR gs_eway_multi_add-transdate.
    ELSE.
*      ls_final_eway-transdocdate      = ls_final-trans_date.
      CONCATENATE zeway_multi_veh-doc_dt+6(2) '/' zeway_multi_veh-doc_dt+4(2) '/' zeway_multi_veh-doc_dt+0(4)
         INTO DATA(lv_date).
      gs_eway_multi_add-transdate = lv_date.
    ENDIF.

    DATA : lv_trex_json TYPE string.
    CLEAR :lv_trex_json.

    CALL FUNCTION 'ZEWAY_BILL_JSON'
      EXPORTING
        data      = gs_eway_multi_add
      IMPORTING
        trex_json = lv_trex_json.


    REFRESH it_json.

    IF sy-subrc IS INITIAL.
      REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
      SPLIT lv_trex_json AT '#' INTO TABLE it_json .
    ENDIF.


    DATA : cnt TYPE i VALUE 0.

    CLEAR :  cnt.


    LOOP AT it_json ASSIGNING FIELD-SYMBOL(<ls_json1>).
      cnt = cnt + 1.
      <ls_json1>-tabix = cnt.
    ENDLOOP.



    LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main1>).

      CASE <lfs_json_main1>-tabix.
        WHEN '1'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main1> WITH ''.
          REPLACE 'ewbno'  IN <lfs_json_main1> WITH '"ewbNo"'.
        WHEN '2'.
          REPLACE 'group'  IN <lfs_json_main1> WITH '"groupNo"'.
        WHEN '3'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main1> WITH space.
          REPLACE 'qty'  IN <lfs_json_main1> WITH '"quantity"'.   "fromplace
        WHEN '4'.
          REPLACE 'transdate'  IN <lfs_json_main1> WITH '"transDocDate"'.
        WHEN '5'.
          REPLACE 'transdocno'  IN <lfs_json_main1> WITH '"transDocNo"'.
        WHEN '6'.
          REPLACE 'vehicle'  IN <lfs_json_main1> WITH '"vehicleNo"'.

      ENDCASE.


    ENDLOOP.

    CLEAR : ls_str.

    LOOP AT it_json INTO ls_json.

      ls_json_output-line = ls_json-line.
      CONCATENATE  ls_str ls_json-line  INTO ls_str.
      APPEND ls_json_output TO lt_json_output.
      CLEAR :  ls_json . ", ls_json_output.

    ENDLOOP.

    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename = 'C:/desktop/multiadd.json'
      CHANGING
        data_tab = lt_json_output "lv_json "
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc EQ 0.

      MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
                 TYPE 'I'.
    ENDIF.

    CONDENSE ls_str NO-GAPS.



    CLEAR : gv_ewaybill_no,gv_updated_date,gv_valid_upto,gv_status,gv_mesg.

    PERFORM auth.

    CONCATENATE '{"action": "MULTIVEHADD", "data":' ls_str '}' INTO ls_str.
    REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
    CONCATENATE ls_str '}' INTO ls_str.
*REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
    CONDENSE ls_str.

    """"""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""

    DATA :tokan TYPE string.

    CLEAR :tokan.

    READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
    tokan = ls_ein_tokan-value.
    CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

    DATA xconn TYPE string.
    CLEAR: xconn.

*xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180607093257:27GSPMH2101G1Z2'."DEV
*    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'. """""""" PRD
    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AAACG5222D1ZA'.



    DATA lv_url TYPE string.

*lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."DEV

    lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'.   """""" PRD

    IF sy-sysid = 'DEV'.
      lv_url = 'https://qa.gsthero.com/ewb/enc/v1.03/ewayapi'.
    ENDIF.

    cl_http_client=>create_by_url(
      EXPORTING
        url                = lv_url
      IMPORTING
        client             = DATA(lo_http_client1)
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4 ).


    lo_http_client1->propertytype_logon_popup = if_http_client=>co_disabled.

    lo_http_client1->request->set_method(
      EXPORTING
        method = 'POST' ).     "if_http_entity=>co_request_method_post


    lo_http_client1->request->set_content_type(
      EXPORTING
        content_type = if_rest_media_type=>gc_appl_json ).

    CALL METHOD lo_http_client1->request->set_header_field
      EXPORTING
        name  = 'Content-Type'
        value = 'application/json'.


    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'Authorization'
        value = tokan ).

    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'Action'
        value = 'MULTIVEHADD' ).


    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'gstin'
*        value = '27AACCD2898L1Z4' ).  """""" PRD
   value = '05AAACG5222D1ZA' )."DEV


    lo_http_client1->request->set_header_field(
      EXPORTING
        name  = 'Accept'
        value = 'application/json' ).

    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'X-Connector-Auth-Token'
        value = xconn ).


    lo_http_client1->request->set_method(
      EXPORTING
        method = if_http_entity=>co_request_method_post ).


    lo_http_client1->request->set_content_type(
      EXPORTING
        content_type = if_rest_media_type=>gc_appl_json ).


    lo_http_client1->request->set_cdata(
      EXPORTING
        data = ls_str ).


    lo_http_client1->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2 ).


    CHECK sy-subrc = 0.
    lo_http_client1->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3 ).

*    BREAK primus.
    CLEAR:ls_response,lt_response,ls_res,lt_res,lv_resp_status.
    CHECK sy-subrc = 0.
    DATA(lv_response1) = lo_http_client1->response->get_cdata( ).

    REPLACE ALL OCCURRENCES OF '{"data":{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '{"error":[{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '[{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '}]' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '}' IN lv_response1 WITH ' '.
    SPLIT lv_response1 AT ',' INTO TABLE lt_response.

    LOOP AT  lt_response INTO ls_response.
      REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
      SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

      IF sy-tabix LE 1000 .
        APPEND ls_res TO lt_res.
        CLEAR ls_res.
      ENDIF.

    ENDLOOP.

    READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
    IF sy-subrc EQ 0.
      lv_resp_status = ls_res-value.
    ENDIF.

    IF lv_resp_status = '1'.
      DATA: lv_version TYPE zeway_multi_add-version.
      CLEAR :gs_eway_multi_veh_add,lv_version.
      REFRESH :gt_eway_multi_veh.
      SELECT MAX( version ) INTO lv_version FROM zeway_multi_add WHERE eway_bill = <ls_final>-eway_bil.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF lv_version IS INITIAL .
          gs_eway_multi_veh_add-version            =    1.
        ENDIF.
        gs_eway_multi_veh_add-version           =    lv_version + 1.
        gs_eway_multi_veh_add-eway_bill       =    <ls_final>-eway_bil.
        gs_eway_multi_veh_add-vehical_no      =   zeway_multi_veh-vehical_no.
        gs_eway_multi_veh_add-trans_doc       =   zeway_multi_veh-trans_doc.
        gs_eway_multi_veh_add-doc_dt          =   zeway_multi_veh-doc_dt.
        gs_eway_multi_veh_add-qty             =   zeway_multi_veh-qty.
        APPEND gs_eway_multi_veh_add TO gt_eway_multi_veh_add.
      ENDLOOP.

      CLEAR ls_res.
      LOOP AT lt_res INTO ls_res..

        IF ls_res-header CS 'ewbNo'.
          gs_eway_multi_veh_add-multi_eway = ls_res-value.
        ENDIF.

        IF ls_res-header CS 'groupNo'.
          gs_eway_multi_veh_add-group1 = ls_res-value.
        ENDIF.

        IF ls_res-header CS 'vehAddedDate'.
          IF ls_res-value NE 'null'.


            lv_ewaybill_dt = ls_res-value+0(10).
            CONCATENATE lv_ewaybill_dt+6(4) lv_ewaybill_dt+3(2) lv_ewaybill_dt+0(2) INTO lv_ewaybill_dt.

            lv_ewaybill_tm = ls_res-value+11(11).
            CONCATENATE lv_ewaybill_tm+0(2) lv_ewaybill_tm+3(2) lv_ewaybill_tm+6(2) INTO lv_ewaybill_time.

            MOVE lv_ewaybill_time TO lv_vdtotime.
            IF lv_ewaybill_tm+9(2) = 'PM'.
              CALL FUNCTION 'HRVE_CONVERT_TIME'
                EXPORTING
                  type_time       = 'B'
                  input_time      = lv_vdtotime
                  input_am_pm     = 'PM'
                IMPORTING
                  output_time     = lv_vdtotime
                EXCEPTIONS
                  parameter_error = 1
                  OTHERS          = 2.
              IF sy-subrc <> 0.
*              * Implement suitable error handling here
              ENDIF.

            ENDIF.

            MOVE lv_vdtotime TO gs_eway_multi_veh_add-vehaddedtime.
            MOVE lv_ewaybill_dt	TO gs_eway_multi_veh_add-vehaddeddate.
            MOVE sy-datum TO  gs_eway_multi_veh_add-cr_date.
          ENDIF.
        ENDIF.

      ENDLOOP.


      IF gt_eway_multi_veh_add IS NOT INITIAL.
        MESSAGE 'Eway Bill Sucessfully Multi-Vehicle Added' TYPE 'I'.
        <ls_final>-message     = 'Eway Bill Sucessfully Multi-Vehicle Added'.
        MODIFY zeway_multi_add FROM gs_eway_multi_veh_add.
      ENDIF.


    ELSE.
      CLEAR ls_res.
      READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.

      IF sy-subrc = 0.
        MESSAGE ls_res-value TYPE 'I'.
        <ls_final>-message     = ls_res-value ."'Eway Bill not Updated'.
      ELSE.
        MESSAGE 'Eway Bill Multi-Vehicle Not Added' TYPE 'I'.
        <ls_final>-message     = 'Eway Bill Multi-Vehicle Not Added'.
      ENDIF.


    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MULTI_VEHICAL_CHNG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM multi_vehical_chng .
  IF r3 = 'X' .
    DATA : group TYPE zeway_multi_chng-group1.
    gs_eway_multi_chng-ewbno           =    <ls_final>-eway_bil.
    gs_eway_multi_chng-fromplace       =   zeway_multi_veh-from_place.
    gs_eway_multi_chng-fromstate       =   zeway_multi_veh-from_state.

    IF gs_eway_multi_chng-fromstate < 10.
      SHIFT gs_eway_multi_chng-fromstate LEFT DELETING LEADING '0'.
      SHIFT gs_eway_multi_chng-fromstate LEFT DELETING LEADING '0'.
    ENDIF.

    CLEAR :group.
    SELECT SINGLE group1 INTO group FROM zeway_multi_add WHERE eway_bill = <ls_final>-eway_bil AND vehical_no = zeway_multi_veh-old_vehical.

    gs_eway_multi_chng-group           =   group.
    gs_eway_multi_chng-newtrans        =   zeway_multi_veh-new_trans_no.
    gs_eway_multi_chng-newvehicle      =   zeway_multi_veh-new_vehical.
    gs_eway_multi_chng-oldtrans        =   zeway_multi_veh-old_trans_no.
    gs_eway_multi_chng-oldvehicle      =   zeway_multi_veh-old_vehical.
    gs_eway_multi_chng-reasoncode      =   zeway_multi_veh-r_code.
    gs_eway_multi_chng-reason          =   zeway_multi_veh-r_remark.


    DATA : lv_trex_json TYPE string.
    CLEAR :lv_trex_json.
    CALL FUNCTION 'ZEWAY_BILL_JSON'
      EXPORTING
        data      = gs_eway_multi_chng
      IMPORTING
        trex_json = lv_trex_json.

    REFRESH it_json.

    IF sy-subrc IS INITIAL.
      REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
      SPLIT lv_trex_json AT '#' INTO TABLE it_json .
    ENDIF.



    DATA : cnt TYPE i VALUE 0.

    CLEAR :  cnt.


    LOOP AT it_json ASSIGNING FIELD-SYMBOL(<ls_json>).
      cnt = cnt + 1.
      <ls_json>-tabix = cnt.
    ENDLOOP.



    LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).

      CASE <lfs_json_main>-tabix.
        WHEN '1'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ''.
          REPLACE 'ewbno'  IN <lfs_json_main> WITH '"ewbNo"'.
        WHEN '2'.
          REPLACE 'fromplace'  IN <lfs_json_main> WITH '"fromPlace"'.
        WHEN '3'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
          REPLACE 'fromstate'  IN <lfs_json_main> WITH '"fromState"'.   "fromplace
        WHEN '4'.
          REPLACE 'group'  IN <lfs_json_main> WITH '"groupNo"'.
        WHEN '5'.
          REPLACE 'newtrans'  IN <lfs_json_main> WITH '"newTranNo"'.
        WHEN '6'.
          REPLACE 'newvehicle'  IN <lfs_json_main> WITH '"newVehicleNo"'.
        WHEN '7'.
          REPLACE 'oldtrans'  IN <lfs_json_main> WITH '"oldTranNo"'.
        WHEN '8'.
          REPLACE 'oldvehicle'  IN <lfs_json_main> WITH '"oldvehicleNo"'.
        WHEN '9'.
          REPLACE 'reasoncode'  IN <lfs_json_main> WITH '"reasonCode"'.
        WHEN '10'.
          REPLACE 'reason'  IN <lfs_json_main> WITH '"reasonRem"'.
      ENDCASE.


    ENDLOOP.

    CLEAR : ls_str.

    LOOP AT it_json INTO ls_json.

      ls_json_output-line = ls_json-line.
      CONCATENATE  ls_str ls_json-line  INTO ls_str.
      APPEND ls_json_output TO lt_json_output.
      CLEAR :  ls_json . ", ls_json_output.

    ENDLOOP.

    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename = 'C:/desktop/multichng.json'
      CHANGING
        data_tab = lt_json_output "lv_json "
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc EQ 0.

      MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
                 TYPE 'I'.
    ENDIF.

    CONDENSE ls_str NO-GAPS.



    CLEAR : gv_ewaybill_no,gv_updated_date,gv_valid_upto,gv_status,gv_mesg.

    PERFORM auth.

    CONCATENATE '{"action": "MULTIVEHUPD", "data":' ls_str '}' INTO ls_str.
    REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
    CONCATENATE ls_str '}' INTO ls_str.
*REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
    CONDENSE ls_str.

    """"""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""

    DATA :tokan TYPE string.

    CLEAR :tokan.

    READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
    tokan = ls_ein_tokan-value.
    CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

    DATA xconn TYPE string.
    CLEAR: xconn.

*xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180607093257:27GSPMH2101G1Z2'."DEV
    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.   """"" PRD
*    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AAACG5222D1ZA'.   """"" PRD



    DATA lv_url TYPE string.

*lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."DEV
    lv_url = 'https://qa.gsthero.com/ewb/enc/v1.03/ewayapi'.

    cl_http_client=>create_by_url(
      EXPORTING
        url                = lv_url
      IMPORTING
        client             = DATA(lo_http_client1)
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4 ).


    lo_http_client1->propertytype_logon_popup = if_http_client=>co_disabled.

    lo_http_client1->request->set_method(
      EXPORTING
        method = 'POST' ).     "if_http_entity=>co_request_method_post


    lo_http_client1->request->set_content_type(
      EXPORTING
        content_type = if_rest_media_type=>gc_appl_json ).

    CALL METHOD lo_http_client1->request->set_header_field
      EXPORTING
        name  = 'Content-Type'
        value = 'application/json'.


    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'Authorization'
        value = tokan ).

    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'Action'
        value = 'MULTIVEHUPD' ).


    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'gstin'
        value = '27AACCD2898L1Z4' ).  """"""""" PRD
*   value = '05AAACG5222D1ZA' )."DEV


    lo_http_client1->request->set_header_field(
      EXPORTING
        name  = 'Accept'
        value = 'application/json' ).

    lo_http_client1->request->set_header_field(            "
      EXPORTING
        name  = 'X-Connector-Auth-Token'
        value = xconn ).


    lo_http_client1->request->set_method(
      EXPORTING
        method = if_http_entity=>co_request_method_post ).


    lo_http_client1->request->set_content_type(
      EXPORTING
        content_type = if_rest_media_type=>gc_appl_json ).


    lo_http_client1->request->set_cdata(
      EXPORTING
        data = ls_str ).


    lo_http_client1->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2 ).


    CHECK sy-subrc = 0.
    lo_http_client1->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3 ).

*    BREAK primus.
    CLEAR:ls_response,lt_response,ls_res,lt_res,lv_resp_status.
    CHECK sy-subrc = 0.
    DATA(lv_response1) = lo_http_client1->response->get_cdata( ).

    REPLACE ALL OCCURRENCES OF '{"data":{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '{"error":[{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '[{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '}]' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '{' IN lv_response1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '}' IN lv_response1 WITH ' '.
    SPLIT lv_response1 AT ',' INTO TABLE lt_response.

    LOOP AT  lt_response INTO ls_response.
      REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
      SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

      IF sy-tabix LE 1000 .
        APPEND ls_res TO lt_res.
        CLEAR ls_res.
      ENDIF.

    ENDLOOP.

    READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
    IF sy-subrc EQ 0.
      lv_resp_status = ls_res-value.
    ENDIF.

    IF lv_resp_status = '1'.
      DATA: lv_version TYPE zeway_multi_chng-version.
      CLEAR :gs_eway_multi_veh_chng,lv_version.
      REFRESH :gt_eway_multi_veh.
      SELECT MAX( version ) INTO lv_version FROM zeway_multi_chng WHERE eway_bill = <ls_final>-eway_bil.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF lv_version IS INITIAL .
          gs_eway_multi_veh_chng-version            =    1.
        ENDIF.
        gs_eway_multi_veh_chng-version           =    lv_version + 1.
        gs_eway_multi_veh_chng-eway_bill       =  <ls_final>-eway_bil.
        gs_eway_multi_veh_chng-from_place      =   zeway_multi_veh-from_place.
        gs_eway_multi_veh_chng-from_state      =   zeway_multi_veh-from_state.
        gs_eway_multi_veh_chng-new_trans_no    =   zeway_multi_veh-new_trans_no.
        gs_eway_multi_veh_chng-new_vehical     =   zeway_multi_veh-new_vehical.
        gs_eway_multi_veh_chng-old_trans_no    =   zeway_multi_veh-old_trans_no.
        gs_eway_multi_veh_chng-old_vehical     =   zeway_multi_veh-old_vehical.
        gs_eway_multi_veh_chng-r_code          =   zeway_multi_veh-r_code.
        gs_eway_multi_veh_chng-r_remark        =   zeway_multi_veh-r_remark.
        APPEND gs_eway_multi_veh_chng TO gt_eway_multi_veh_chng.
      ENDLOOP.

      CLEAR ls_res.
      LOOP AT lt_res INTO ls_res..

        IF ls_res-header CS 'ewbNo'.
          gs_eway_multi_veh_chng-multi_eway = ls_res-value.
        ENDIF.

        IF ls_res-header CS 'groupNo'.
          gs_eway_multi_veh_chng-group1 = ls_res-value.
        ENDIF.

        IF ls_res-header CS 'vehUpdDate'.
          IF ls_res-value NE 'null'.


            lv_ewaybill_dt = ls_res-value+0(10).
            CONCATENATE lv_ewaybill_dt+6(4) lv_ewaybill_dt+3(2) lv_ewaybill_dt+0(2) INTO lv_ewaybill_dt.

            lv_ewaybill_tm = ls_res-value+11(11).
            CONCATENATE lv_ewaybill_tm+0(2) lv_ewaybill_tm+3(2) lv_ewaybill_tm+6(2) INTO lv_ewaybill_time.

            MOVE lv_ewaybill_time TO lv_vdtotime.
            IF lv_ewaybill_tm+9(2) = 'PM'.
              CALL FUNCTION 'HRVE_CONVERT_TIME'
                EXPORTING
                  type_time       = 'B'
                  input_time      = lv_vdtotime
                  input_am_pm     = 'PM'
                IMPORTING
                  output_time     = lv_vdtotime
                EXCEPTIONS
                  parameter_error = 1
                  OTHERS          = 2.
              IF sy-subrc <> 0.
*              * Implement suitable error handling here
              ENDIF.

            ENDIF.

            MOVE lv_vdtotime TO gs_eway_multi_veh_chng-vehupdtime.
            MOVE lv_ewaybill_dt	TO gs_eway_multi_veh_chng-vehupddate.
            MOVE sy-datum TO  gs_eway_multi_veh_chng-cr_date.
          ENDIF.
        ENDIF.

      ENDLOOP.


      IF gt_eway_multi_veh_chng IS NOT INITIAL.
        MESSAGE 'Eway Bill Sucessfully Multi-Vehicle Change' TYPE 'I'.
        <ls_final>-message     = 'Eway Bill Sucessfully Multi-Vehicle Change'.
        MODIFY zeway_multi_chng FROM gs_eway_multi_veh_chng.
      ENDIF.


    ELSE.
      CLEAR ls_res.
      READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.

      IF sy-subrc = 0.
        MESSAGE ls_res-value TYPE 'I'.
        <ls_final>-message     = ls_res-value ."'Eway Bill not Updated'.
      ELSE.
        MESSAGE 'Eway Bill Multi-Vehicle Not Chnage' TYPE 'I'.
        <ls_final>-message     = 'Eway Bill Multi-Vehicle Not Change'.
      ENDIF.


    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM auth .
  DATA : ls_zeinv_res TYPE zeinv_res.
  DATA : ls_h1     TYPE string,
         ls_h2     TYPE string,
         ls_header TYPE zeinv_api.
  DATA: lv_header TYPE string.
  TYPES : BEGIN OF ty_auth,
            auth   TYPE string,
            accept TYPE string,
            gstin  TYPE string,
          END OF ty_auth.
  DATA : ls_auth TYPE ty_auth.

  TYPES : BEGIN OF ty_auth1,
            action   TYPE string,
            username TYPE string,
            password TYPE string,
          END OF ty_auth1.
  DATA : it_auth TYPE TABLE OF ty_auth1,
         wa_auth TYPE          ty_auth1.

  TYPES : BEGIN OF ty_response_tokan,
            line(255) TYPE c,
          END OF ty_response_tokan.

  DATA: lt_response_tokan TYPE STANDARD TABLE OF ty_response_tokan,
        ls_response_tokan TYPE ty_response_tokan.

  DATA: lt_einres_tokan TYPE STANDARD TABLE OF ty_response_tokan,
        ls_einres_tokan TYPE ty_response_tokan.


  CLEAR :lt_res_tokan ,ls_res_tokan, wa_auth , it_auth, ls_ein_tokan , lt_ein_tokan ,lt_response_tokan ,ls_response_tokan,lt_einres_tokan,ls_einres_tokan.
  REFRESH : lt_res_tokan,it_auth,lt_ein_tokan,lt_response_tokan,lt_einres_tokan.


  LOOP AT lt_jsonfile INTO ls_jsonfile.
    IF ls_jsonfile-line CS 'SellerDtls'.
      REPLACE ALL OCCURRENCES OF '"' IN ls_jsonfile-line WITH ' '.
      SPLIT ls_jsonfile-line AT ':' INTO ls_h1 ls_h2.
      SPLIT ls_h2 AT ':' INTO ls_h1 ls_h2.
      REPLACE ALL OCCURRENCES OF ',' IN ls_h2 WITH ' '.
      CONDENSE ls_h2.
    ENDIF.
  ENDLOOP.
  SELECT SINGLE * FROM zeinv_api
  INTO ls_header WHERE gstin EQ ls_h2.


*  BREAK primus.
**********************************************************GST Hero Tokan**********************************

  ls_auth-auth = 'Basic dGVzdGVycGNsaWVudDpBZG1pbkAxMjM='. " DEV
  ls_auth-accept = 'application/json'.                     " DEV
  ls_auth-gstin = '05AAACG5222D1ZA'. "ls_H2                " DEV

  """""""""""""""" PRD """""""""""""""""""""""""""""
*  ls_auth-auth = 'Basic NDg3YWM4MGEwN2Y2MDM5YzEyOWZlN2MyN2IxMmNiY2Y6ZWtKVU5USHpZSw=='.
*  ls_auth-accept = 'application/json'.
*  ls_auth-gstin = '27AACCD2898L1Z4'. "ls_H2

  DATA lv_url1 TYPE string.
*  lv_url1 = 'http://35.154.208.8:8080/auth-server/oauth/token'. " DEV
  lv_url1 = 'https://qa.gsthero.com/auth-server/oauth/token'. " DEV
*  lv_url1 = 'https://gsthero.com/auth-server/oauth/token'. """"""""" PRD

  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url1
    IMPORTING
      client             = DATA(lo_http_client)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).

  DATA gv_auth_val TYPE string.
  CHECK lo_http_client IS BOUND.

  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Accept'
      value = 'application/json'.

  lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
    EXPORTING
      method = 'POST' ).

  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Content-Type'
      value = 'application/x-www-form-urlencoded' ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = ls_auth-auth ).


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'gstin'
      value = ls_auth-gstin ).

  DATA:pay TYPE string.


   pay = 'grant_type=password&username=erp1@perennialsys.com&password=einv12345&client_id=testerpclient&scope=ewbauth'. "DEV
*pay = 'grant_type=password&username=stathe@delvalflow.com&password=India@12345&client_id=487ac80a07f6039c129fe7c27b12cbcf&scope=einvauth'.
*  pay = 'grant_type=password&username=stathe@delvalflow.com&password=India@12345&client_id=487ac80a07f6039c129fe7c27b12cbcf'.  """""""""""" PRD NC

  lo_http_client->request->set_cdata(
    EXPORTING
      data = pay ).

  lo_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).


  CHECK sy-subrc = 0.
  DATA(lv_response_tokan) = lo_http_client->response->get_cdata( ).

  REPLACE ALL OCCURRENCES OF '[{' IN lv_response_tokan WITH ' '.
  SPLIT lv_response_tokan AT ',' INTO TABLE lt_response_tokan.


  LOOP AT  lt_response_tokan INTO ls_response_tokan.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response_tokan WITH ' '.
    SPLIT ls_response_tokan AT ':' INTO ls_res_tokan-header ls_res_tokan-value.

    IF sy-tabix LE 10 .
      APPEND ls_res_tokan TO lt_res_tokan.
      CLEAR ls_res_tokan.
    ENDIF.

  ENDLOOP.


****************************************************************************************************

******************************************************Eway Tokan***********************************

  DATA lv_url2 TYPE string.
*  lv_url2 = 'http://35.154.208.8:8080/ewb/enc/v1.03/authentication'."DEV
  lv_url2 = 'https://qa.gsthero.com/ewb/enc/v1.03/authentication'."DEV
*  lv_url2 = 'https://gsthero.com/ewb/enc/v1.03/authentication'.   """""""""" PRD
  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url2
    IMPORTING
      client             = DATA(lo_http_client1)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).

  DATA gv_auth_val1 TYPE string.
  CHECK lo_http_client1 IS BOUND.


  lo_http_client1->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client1->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post

  lo_http_client1->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json' ).


  DATA :auth TYPE string.

  DATA xconn TYPE string.
  CLEAR :xconn,auth.

*  xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180622093257:27GSPMH2101G1Z2'. "DEV

*CONCATENATE 'l7xxba7aa16e968646b992298b377e955e7c:20180622093257:' ls_auth-gstin INTO xconn .
  xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180622093257:27GSPMH2101G1Z2'. "DEV
*  xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.  """"""""""" PRD

  READ TABLE lt_res_tokan INTO ls_res_tokan INDEX 1 .
  auth = ls_res_tokan-value.
  READ TABLE lt_res_tokan INTO ls_res_tokan INDEX 2 .
  CONCATENATE 'Bearer' auth INTO auth SEPARATED BY space.
*CONDENSE auth.

  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = auth ).


  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'X-Connector-Auth-Token'
      value = xconn ).


  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'Action'
      value = 'ACCESSTOKEN' ).

  lo_http_client1->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'gstin'
      value = ls_auth-gstin ).


  DATA:aut_tokan TYPE string.
  DATA ls_json TYPE string.

  CLEAR: aut_tokan,ls_json.
*aut_tokan = '{"action":"ACCESSTOKEN","username":"perennialsystems","password":"p3r3nn!@1"}'.

  wa_auth-action   = 'ACCESSTOKEN'.    "DEV
  wa_auth-username = '05AAACG5222D1ZA'. "DEV
  wa_auth-password = 'abc123@@'. "DEV
  APPEND wa_auth TO it_auth." DEV


*  wa_auth-action   = 'ACCESSTOKEN'.   """"""""""" PRD
*  wa_auth-username = 'DELVALFLOW_API_123'.
*  wa_auth-password = 'gsthero@12345'.
*  APPEND wa_auth TO it_auth.

*  wa_auth-action   = 'ACCESSTOKEN'.   """"""""""" NC
*  wa_auth-username = '05AAACG5222D1ZA'.
*   wa_auth-password = 'abc123@@'.
*   APPEND wa_auth TO it_auth.



  ls_json = /ui2/cl_json=>serialize( data = it_auth compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
  CLEAR it_auth.
  /ui2/cl_json=>deserialize( EXPORTING json = ls_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = it_auth ).

  REPLACE ALL OCCURRENCES OF '[' IN ls_json WITH space.
  REPLACE ALL OCCURRENCES OF ']' IN ls_json WITH space.
  CONDENSE ls_json.

  lo_http_client1->request->set_cdata(
    EXPORTING
      data = ls_json ).

  lo_http_client1->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client1->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).


  CHECK sy-subrc = 0.
  DATA(lv_einres_tokan) = lo_http_client1->response->get_cdata( ).

  REPLACE ALL OCCURRENCES OF '[{' IN lv_einres_tokan WITH ' '.
  SPLIT lv_einres_tokan AT ',' INTO TABLE lt_einres_tokan.


  LOOP AT  lt_einres_tokan INTO ls_einres_tokan.
    REPLACE ALL OCCURRENCES OF '"' IN ls_einres_tokan WITH ' '.
    SPLIT ls_einres_tokan AT ':' INTO ls_ein_tokan-header ls_ein_tokan-value.

    IF sy-tabix LE 10 .
      APPEND ls_ein_tokan TO lt_ein_tokan.
      CLEAR ls_ein_tokan.
    ENDIF.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT_EWAYBILL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_ewaybill .

  DATA: lv_sf     TYPE tdsfname,
        lv_sf1    TYPE tdsfname,
        lv_fname1 TYPE rs38l_fnam,
        lv_fname  TYPE rs38l_fnam,
        lv_count  TYPE i.
  DATA: gd_ssfctrlop LIKE ssfctrlop,
        gd_count     TYPE i.
  lv_sf = 'ZEWAY_BILL_PRINT'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_sf
    IMPORTING
      fm_name            = lv_fname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

    CLEAR: gd_ssfctrlop,
           gd_count,
           lv_count.

*    lt_final1[] = lt_final[].

    DELETE lt_final WHERE selection  NE 'X'.

    DESCRIBE TABLE lt_final LINES gd_count.

    LOOP AT lt_final INTO ls_final.
      lv_count = lv_count + 1.

      IF gd_count = 1.
        gd_ssfctrlop-no_open  = ''.
        gd_ssfctrlop-no_close = ''.
      ELSEIF lv_count EQ gd_count.
        gd_ssfctrlop-no_open  = 'X'.
        gd_ssfctrlop-no_close = ''.
      ELSEIF lv_count > sy-index.
        gd_ssfctrlop-no_open  = 'X'.
        gd_ssfctrlop-no_close = 'X'.
      ELSE.
        gd_ssfctrlop-no_open  = ''.
        gd_ssfctrlop-no_close = 'X'.
      ENDIF."IF gd_count = 1.


*  CALL FUNCTION lv_fname
*    EXPORTING
**     ARCHIVE_INDEX              =
**     ARCHIVE_INDEX_TAB          =
**     ARCHIVE_PARAMETERS         =
**     CONTROL_PARAMETERS         =
**     MAIL_APPL_OBJ              =
**     MAIL_RECIPIENT             =
**     MAIL_SENDER                =
**     OUTPUT_OPTIONS             =
**     USER_SETTINGS              = 'X'
*      p_vbeln                    = ls_final-bukrs
*      p_bukrs                    = ls_final-vbeln
*      p_ebillno                  = ls_final-eway_bil
**   IMPORTING
**     DOCUMENT_OUTPUT_INFO       =
**     JOB_OUTPUT_INFO            =
**     JOB_OUTPUT_OPTIONS         =
**   EXCEPTIONS
**     FORMATTING_ERROR           = 1
**     INTERNAL_ERROR             = 2
**     SEND_ERROR                 = 3
**     USER_CANCELED              = 4
**     OTHERS                     = 5
*            .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


*
      CALL FUNCTION lv_fname
        EXPORTING
*         ARCHIVE_INDEX    =
*         ARCHIVE_INDEX_TAB          =
*         ARCHIVE_PARAMETERS         =
*         CONTROL_PARAMETERS         =
*         MAIL_APPL_OBJ    =
*         MAIL_RECIPIENT   =
*         MAIL_SENDER      =
*         OUTPUT_OPTIONS   =
*         USER_SETTINGS    = 'X'
          p_bukrs          = ls_final-bukrs
          p_vbeln          = ls_final-vbeln
          p_ebillno        = ls_final-eway_bil
*   IMPORTING
*         DOCUMENT_OUTPUT_INFO       =
*         JOB_OUTPUT_INFO  =
*         JOB_OUTPUT_OPTIONS         =
        EXCEPTIONS
          formatting_error = 1
          internal_error   = 2
          send_error       = 3
          user_canceled    = 4
          OTHERS           = 5.
      IF sy-subrc <> 0.
* Implement suitable error handling here
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.




*
*
*      CALL FUNCTION lv_fname
*        EXPORTING
*          control_parameters = gd_ssfctrlop
*          im_bukrs           = ls_final-bukrs
*          im_vbeln           = ls_final-vbeln
*          im_ebillno         = ls_final-eway_bil
*        EXCEPTIONS
*          formatting_error   = 1
*          internal_error     = 2
*          send_error         = 3
*          user_canceled      = 4
*          OTHERS             = 5.
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF."IF sy-subrc <> 0.

      CLEAR : ls_final.
    ENDLOOP."loop at it_output1
  ENDIF."IF sy-subrc <> 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT_VEN_EWAYBILL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_ven_ewaybill .
  DATA: lv_sf     TYPE tdsfname,
        lv_sf1    TYPE tdsfname,
        lv_fname1 TYPE rs38l_fnam,
        lv_fname  TYPE rs38l_fnam,
        lv_count  TYPE i.
  DATA: gd_ssfctrlop LIKE ssfctrlop,
        gd_count     TYPE i.
  lv_sf = 'ZEWAY_VENDOR_PRINT'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_sf
    IMPORTING
      fm_name            = lv_fname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

    CLEAR: gd_ssfctrlop,
           gd_count,
           lv_count.

*    lt_final1[] = lt_final[].

    DELETE lt_final WHERE selection  NE 'X'.

    DESCRIBE TABLE lt_final LINES gd_count.

    LOOP AT lt_final INTO ls_final.
      lv_count = lv_count + 1.

      IF gd_count = 1.
        gd_ssfctrlop-no_open  = ''.
        gd_ssfctrlop-no_close = ''.
      ELSEIF lv_count EQ gd_count.
        gd_ssfctrlop-no_open  = 'X'.
        gd_ssfctrlop-no_close = ''.
      ELSEIF lv_count > sy-index.
        gd_ssfctrlop-no_open  = 'X'.
        gd_ssfctrlop-no_close = 'X'.
      ELSE.
        gd_ssfctrlop-no_open  = ''.
        gd_ssfctrlop-no_close = 'X'.
      ENDIF."IF gd_count = 1.


*
      CALL FUNCTION lv_fname
        EXPORTING
*         ARCHIVE_INDEX    =
*         ARCHIVE_INDEX_TAB          =
*         ARCHIVE_PARAMETERS         =
*         CONTROL_PARAMETERS         =
*         MAIL_APPL_OBJ    =
*         MAIL_RECIPIENT   =
*         MAIL_SENDER      =
*         OUTPUT_OPTIONS   =
*         USER_SETTINGS    = 'X'
          p_bukrs          = ls_final-bukrs
          p_vbeln          = ls_final-vbeln
          p_ebillno        = ls_final-eway_bil
          p_gjahr          = ls_final-gjahr
*   IMPORTING
*         DOCUMENT_OUTPUT_INFO       =
*         JOB_OUTPUT_INFO  =
*         JOB_OUTPUT_OPTIONS         =
        EXCEPTIONS
          formatting_error = 1
          internal_error   = 2
          send_error       = 3
          user_canceled    = 4
          OTHERS           = 5.
      IF sy-subrc <> 0.
* Implement suitable error handling here
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.



      CLEAR : ls_final.
    ENDLOOP."loop at it_output1
  ENDIF."IF sy-subrc <> 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT_SALE_EWAYBILL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_sale_ewaybill .
  DATA: lv_sf     TYPE tdsfname,
        lv_sf1    TYPE tdsfname,
        lv_fname1 TYPE rs38l_fnam,
        lv_fname  TYPE rs38l_fnam,
        lv_count  TYPE i.
  DATA: gd_ssfctrlop LIKE ssfctrlop,
        gd_count     TYPE i.
  lv_sf = 'ZEWAY_BILL_SALE_PRINT'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_sf
    IMPORTING
      fm_name            = lv_fname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

    CLEAR: gd_ssfctrlop,
           gd_count,
           lv_count.

*    lt_final1[] = lt_final[].

    DELETE lt_final WHERE selection  NE 'X'.

    DESCRIBE TABLE lt_final LINES gd_count.

    LOOP AT lt_final INTO ls_final.
      lv_count = lv_count + 1.

      IF gd_count = 1.
        gd_ssfctrlop-no_open  = ''.
        gd_ssfctrlop-no_close = ''.
      ELSEIF lv_count EQ gd_count.
        gd_ssfctrlop-no_open  = 'X'.
        gd_ssfctrlop-no_close = ''.
      ELSEIF lv_count > sy-index.
        gd_ssfctrlop-no_open  = 'X'.
        gd_ssfctrlop-no_close = 'X'.
      ELSE.
        gd_ssfctrlop-no_open  = ''.
        gd_ssfctrlop-no_close = 'X'.
      ENDIF."IF gd_count = 1.


*
      CALL FUNCTION lv_fname
        EXPORTING
*         ARCHIVE_INDEX    =
*         ARCHIVE_INDEX_TAB          =
*         ARCHIVE_PARAMETERS         =
*         CONTROL_PARAMETERS         =
*         MAIL_APPL_OBJ    =
*         MAIL_RECIPIENT   =
*         MAIL_SENDER      =
*         OUTPUT_OPTIONS   =
*         USER_SETTINGS    = 'X'
          p_bukrs          = ls_final-bukrs
          p_vbeln          = ls_final-vbeln
          p_ebillno        = ls_final-eway_bil
          p_gjahr          = ls_final-gjahr
*   IMPORTING
*         DOCUMENT_OUTPUT_INFO       =
*         JOB_OUTPUT_INFO  =
*         JOB_OUTPUT_OPTIONS         =
        EXCEPTIONS
          formatting_error = 1
          internal_error   = 2
          send_error       = 3
          user_canceled    = 4
          OTHERS           = 5.
      IF sy-subrc <> 0.
* Implement suitable error handling here
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.



      CLEAR : ls_final.
    ENDLOOP."loop at it_output1
  ENDIF."IF sy-subrc <> 0.
ENDFORM.
