*&---------------------------------------------------------------------*
*&  Include           ZPAYMENT_ADVICE_F01
*&---------------------------------------------------------------------*

FORM get_vendor_data.

  SELECT lf~lifnr
         lf~name1
         lf~adrnr
         ad~street
        ad~city1
        ad~post_code1
       ad~str_suppl3
       ad~location
       ad~time_zone
    FROM lfa1 AS lf
    JOIN adrc AS ad ON lf~adrnr = ad~addrnumber
     INTO CORRESPONDING FIELDS OF TABLE it_lfa1
      FOR ALL ENTRIES IN gt_bseg
    WHERE lf~lifnr = gt_bseg-lifnr .


ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  GET_ACC_HEADER_DATA
*&---------------------------------------------------------------------*

FORM get_acc_header_data .
*  BREAK primus.
  SELECT belnr
          lifnr
          koart
          shkzg
          FROM bseg
          INTO TABLE gt_bseg
          WHERE bukrs = p_bukrs
          AND gjahr = p_gjahr
          AND belnr IN s_belnr
          AND koart = 'K' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_GROSS_DETAILS
*&---------------------------------------------------------------------*

FORM get_gross_details .
  SELECT bukrs,
         belnr,
         rebzg,
         rebzj,
         lifnr
        FROM bsik
        INTO  CORRESPONDING FIELDS OF TABLE @it_bsik
        WHERE bukrs = @p_bukrs AND belnr IN @s_belnr AND gjahr = @p_gjahr AND lifnr = @p_lifnr AND blart = 'KZ' .
*        WHERE bukrs = @p_bukrs AND belnr IN @s_belnr AND gjahr = @p_gjahr AND lifnr = @p_lifnr AND blart IN ( 'KZ' ,'KG' , 'KR' , 'RE' , 'KG' , 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' ) ..


  IF it_bsik IS NOT INITIAL.
    SELECT bukrs,gjahr,xblnr, budat,bldat ,blart,belnr
            FROM bkpf
            INTO CORRESPONDING FIELDS OF TABLE @it_bkpf
            FOR ALL ENTRIES IN @it_bsik
            WHERE bukrs = @it_bsik-bukrs AND  belnr = @it_bsik-rebzg AND gjahr = @it_bsik-rebzj.

    SELECT bukrs,gjahr, belnr ,buzei ,dmbtr ,bschl, koart ,augbl, ktosl
      FROM  bseg
      INTO CORRESPONDING FIELDS OF TABLE @it_gross
      FOR ALL ENTRIES IN @it_bsik
      WHERE bukrs = @it_bsik-bukrs AND  belnr = @it_bsik-rebzg AND gjahr = @it_bsik-rebzj
      AND shkzg = 'S' .

    SELECT bukrs,gjahr, belnr ,buzei ,dmbtr ,bschl, koart ,augbl, ktosl
      FROM  bseg
      INTO CORRESPONDING FIELDS OF TABLE @it_tds
      FOR ALL ENTRIES IN @it_bsik
      WHERE bukrs = @it_bsik-bukrs AND  belnr = @it_bsik-rebzg AND gjahr = @it_bsik-rebzj
      AND ktosl = 'WIT' .

    SELECT bukrs,belnr,augbl ,gjahr, dmbtr
            FROM bsak
            INTO CORRESPONDING FIELDS OF TABLE @gt_bsak
            FOR ALL ENTRIES IN @it_bkpf
            WHERE augbl = @it_bkpf-belnr AND bukrs = @it_bkpf-bukrs AND gjahr = @it_bkpf-gjahr  AND blart = 'KG' .
*            WHERE augbl = @it_bkpf-belnr AND bukrs = @it_bkpf-bukrs AND gjahr = @it_bkpf-gjahr  AND blart IN ( 'KG' , 'KR' , 'RE' , 'KG' , 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' ) .

    SELECT bukrs,belnr,gjahr,dmbtr,rebzg,rebzj
           FROM bsik
           INTO CORRESPONDING FIELDS OF TABLE @gt_bsik
*           FOR ALL ENTRIES IN @it_bkpf
           WHERE belnr IN @s_belnr AND bukrs = @p_bukrs AND gjahr = @p_gjahr .

  ENDIF.

  SELECT bukrs,belnr,augbl,gjahr,lifnr
         FROM bsak
         INTO CORRESPONDING FIELDS OF TABLE @it_bsak
*         WHERE bukrs = @p_bukrs AND augbl IN @s_belnr AND augdt = @p_budat AND lifnr = @p_lifnr AND blart = 'KG' .
         WHERE bukrs = @p_bukrs AND augbl IN @s_belnr  AND lifnr = @p_lifnr AND blart IN ( 'KR' , 'RE' , 'KG' , 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' ) .
*         WHERE bukrs = @p_bukrs AND augbl IN @s_belnr AND augdt = @p_budat AND lifnr = @p_lifnr AND blart IN ( 'KR' , 'RE' , 'KG' , 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' ) .

  IF it_bsak IS NOT INITIAL.
    SELECT bukrs,gjahr,xblnr,budat,bldat ,blart,belnr
        FROM bkpf
        INTO CORRESPONDING FIELDS OF  TABLE @it_bkpf01
        FOR ALL ENTRIES IN @it_bsak
        WHERE bukrs = @it_bsak-bukrs AND  belnr = @it_bsak-belnr AND gjahr = @it_bsak-gjahr.

    SELECT bukrs,gjahr, belnr ,buzei ,dmbtr ,bschl, koart ,augbl, ktosl
      FROM  bseg
       INTO CORRESPONDING FIELDS OF TABLE @it_gross01
      FOR ALL ENTRIES IN @it_bsak
     WHERE bukrs = @it_bsak-bukrs AND  belnr = @it_bsak-belnr AND gjahr = @it_bsak-gjahr ""AND lifnr = @it_bsak-lifnr
    AND shkzg = 'S' .

    SELECT bukrs,gjahr, belnr ,buzei ,dmbtr ,bschl, koart ,augbl, ktosl
    FROM  bseg
    INTO  CORRESPONDING FIELDS OF TABLE @it_tds01
    FOR ALL ENTRIES IN @it_bsak
    WHERE bukrs = @it_bsak-bukrs AND  belnr = @it_bsak-belnr AND gjahr = @it_bsak-gjahr  ""AND lifnr = @it_bsak-lifnr
    AND ktosl = 'WIT' .

    SELECT bukrs, belnr, augbl ,gjahr, dmbtr
            FROM bsak
            INTO CORRESPONDING FIELDS OF TABLE @gt_bsak01
            FOR ALL ENTRIES IN @it_bkpf01
            WHERE augbl = @it_bkpf01-belnr AND bukrs = @it_bkpf01-bukrs AND gjahr = @it_bkpf01-gjahr AND blart = 'KG'.
*            WHERE augbl = @it_bkpf01-belnr AND bukrs = @it_bkpf01-bukrs AND gjahr = @it_bkpf01-gjahr AND blart IN ( 'KG' , 'KR' , 'RE' , 'KG' , 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' ) .

    SELECT bukrs,belnr,gjahr,dmbtr
             FROM bsak
             INTO CORRESPONDING FIELDS OF TABLE @gt_bsik01
             FOR ALL ENTRIES IN @it_bkpf01
             WHERE belnr = @it_bkpf01-belnr AND bukrs = @it_bkpf01-bukrs AND gjahr = @it_bkpf01-gjahr.

  ENDIF.

  SELECT bukrs,gjahr, belnr ,buzei ,dmbtr ,bschl, koart ,augbl, ktosl,rebzg,augdt,rebzj
      FROM  bseg
       INTO CORRESPONDING FIELDS OF TABLE @it_gross_part
     WHERE bukrs = @p_bukrs AND  belnr IN @s_belnr AND gjahr = @p_gjahr ""AND lifnr = @it_bsak-lifnr
    AND shkzg = 'S' AND rebzg <> ' ' .





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TDS_DETAILS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  FINAL_DATA
*&---------------------------------------------------------------------*

FORM final_data .
  DATA wa_final TYPE zpayment_advice_str.
*  SORT it_bkpf ASCENDING BY belnr.
*  SORT it_gross ASCENDING BY belnr bschl.
*  SORT it_tds ASCENDING BY belnr.
*  DATA(it_bkpf_kg) = it_bkpf.
*  DELETE it_bkpf_kg WHERE blart NE 'KG'.

  SORT it_bsak BY belnr.
  SORT it_bsik BY rebzg.
*  BREAK-POINT.
  LOOP AT it_bsik INTO wa_bsik.


    READ TABLE  it_bkpf INTO wa_bkpf WITH  KEY belnr = wa_bsik-rebzg.
    IF wa_bkpf-blart <> 'KZ'.
      wa_final-xblnr = wa_bkpf-xblnr.
      wa_final-budat = wa_bkpf-budat.
      wa_final-blart = wa_bkpf-blart.
      wa_final-belnr = wa_bkpf-belnr.
      wa_final-bldat  = wa_bkpf-bldat.
      wa_final-augbl = wa_bsik-belnr.

      LOOP AT it_gross INTO wa_gross WHERE belnr = wa_bsik-rebzg.
        wa_final-gross_dmbtr = wa_final-gross_dmbtr + wa_gross-dmbtr.
      ENDLOOP.

      LOOP AT it_tds INTO wa_tds WHERE belnr = wa_bsik-rebzg.
        wa_final-tds_dmbtr =  wa_final-tds_dmbtr  + wa_tds-dmbtr.
      ENDLOOP.

      LOOP AT gt_bsak INTO gs_bsak WHERE belnr = wa_final-belnr.
        wa_final-rejection_dmbtr  = wa_final-rejection_dmbtr + gs_bsak-dmbtr.
      ENDLOOP.

      LOOP AT gt_bsik INTO gs_bsik WHERE rebzg = wa_final-belnr.
        wa_final-net_dmbtr = wa_final-net_dmbtr + gs_bsik-dmbtr.
      ENDLOOP.

*      wa_final-net_dmbtr = wa_final-gross_dmbtr - wa_final-tds_dmbtr - wa_final-rejection_dmbtr .

      wa_final-balance = wa_final-gross_dmbtr - wa_final-net_dmbtr - wa_final-tds_dmbtr - wa_final-rejection_dmbtr .

      APPEND wa_final TO it_final.
      CLEAR: wa_bkpf,wa_gross,wa_tds,wa_final,gs_bsik,gs_bsak .
    ENDIF.
  ENDLOOP.

  LOOP AT it_bsak INTO wa_bsak.

    READ TABLE  it_bkpf01 INTO wa_bkpf01 WITH  KEY belnr = wa_bsak-belnr.
    IF wa_bkpf01-blart <> 'KZ'.
      wa_final-xblnr = wa_bkpf01-xblnr.
      wa_final-budat = wa_bkpf01-budat.
      wa_final-blart = wa_bkpf01-blart.
      wa_final-belnr = wa_bkpf01-belnr.
      wa_final-bldat  = wa_bkpf01-bldat.
      wa_final-augbl = wa_bsak-augbl.

*      READ TABLE IT_GROSS_PART INTO WA_GROSS_PART WITH KEY AUGBL = wa_final-augbl.

      LOOP AT it_gross01 INTO wa_gross01 WHERE belnr = wa_bsak-belnr.
        wa_final-gross_dmbtr = wa_final-gross_dmbtr + wa_gross01-dmbtr.
      ENDLOOP.

      LOOP AT it_tds01 INTO wa_tds01 WHERE belnr = wa_bsak-belnr.
        wa_final-tds_dmbtr =  wa_final-tds_dmbtr  + wa_tds01-dmbtr.
      ENDLOOP.

      LOOP AT gt_bsak01 INTO gs_bsak01 WHERE belnr = wa_final-belnr.
        wa_final-rejection_dmbtr  = wa_final-rejection_dmbtr + gs_bsak01-dmbtr.
      ENDLOOP.


*      LOOP AT gt_bsik01 INTO gs_bsik01 WHERE belnr = wa_final-belnr.
*        wa_final-net_dmbtr = wa_final-net_dmbtr + gs_bsik01-dmbtr.
*      ENDLOOP.
      IF wa_final-blart = 'AB'.
        CLEAR wa_final-gross_dmbtr.
        LOOP AT gt_bsik01 INTO gs_bsik01 WHERE belnr = wa_final-belnr.
*        wa_final-net_dmbtr = wa_final-net_dmbtr + gs_bsik01-dmbtr.
          wa_final-gross_dmbtr = wa_final-gross_dmbtr + gs_bsik01-dmbtr.
        ENDLOOP.
        wa_final-gross_dmbtr = wa_final-gross_dmbtr * ( -1 ).
      ENDIF.

      IF wa_final-blart = 'KG'.
        wa_final-rejection_dmbtr  =  wa_final-gross_dmbtr  .
        CLEAR wa_final-gross_dmbtr .

      ENDIF.
*BREAK-POINT.
      wa_final-net_dmbtr = wa_final-gross_dmbtr - wa_final-tds_dmbtr - wa_final-rejection_dmbtr .
*      wa_final-balance = wa_final-gross_dmbtr - wa_final-tds_dmbtr - wa_final-rejection_dmbtr - wa_final-net_dmbtr .
      wa_final-balance =  wa_final-gross_dmbtr  - wa_final-tds_dmbtr - wa_final-rejection_dmbtr - wa_final-net_dmbtr   .

      APPEND wa_final TO it_final.
    ENDIF.
    CLEAR:wa_bkpf01,wa_gross01,wa_tds01,wa_final,gs_bsik01,gs_bsak01.
*    ENDIF.
  ENDLOOP.

*  FREE: it_bkpf, it_gross, it_tds.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS.
  DELETE ADJACENT DUPLICATES FROM gt_bseg COMPARING belnr.

  IT_FINAL01  = IT_FINAL.
  DELETE ADJACENT DUPLICATES FROM IT_FINAL01 COMPARING AUGBL.

  LOOP AT IT_FINAL01 INTO DATA(wa_final02).
    ON CHANGE OF wa_final02-augbl.
      LOOP AT it_gross_part INTO wa_gross_part WHERE BELNR = wa_final02-augbl  .
*        IF wa_final02-AUGBL = wa_gross_part-BELNR.

        wa_final02-belnr = wa_gross_part-rebzg.
        wa_final02-bldat =  wa_gross_part-augdt.
*        wa_final02-gross_dmbtr = wa_gross_part-dmbtr.

        SELECT SINGLE dmbtr FROM bseg INTO @DATA(lv_gross) WHERE bukrs = @wa_gross_part-bukrs
                                                           AND belnr = @wa_gross_part-rebzg AND gjahr = @wa_gross_part-rebzj AND koart = 'K' AND shkzg = 'H'.

        wa_final02-gross_dmbtr = lv_gross.

        SELECT SINGLE dmbtr FROM bseg INTO @DATA(lv_tds01) WHERE bukrs = @wa_gross_part-bukrs
                                                           AND belnr = @wa_gross_part-rebzg AND gjahr = @wa_gross_part-rebzj AND ktosl = 'WIT'.
        wa_final02-tds_dmbtr = lv_tds01 .

        wa_final02-gross_dmbtr = lv_gross + wa_final02-tds_dmbtr.

        wa_final02-net_dmbtr = wa_gross_part-dmbtr .         ""- wa_final02-tds_dmbtr .""- wa_final-rejection_dmbtr .

        wa_final02-balance =  wa_final02-gross_dmbtr - wa_final02-net_dmbtr - wa_final02-tds_dmbtr .  ""- wa_final-rejection_dmbtr
        APPEND wa_final02 TO it_final.
        CLEAR: wa_gross_part,lv_tds01,lv_gross.
*       ENDIF.
      ENDLOOP.
    ENDON.
  ENDLOOP.

  SORT it_final ASCENDING BY belnr.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING BELNR  .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_SMARTFORM
*&---------------------------------------------------------------------*

FORM display_smartform .

*  PERFORM get_sf_fm.

  DATA control_parameters   TYPE ssfctrlop.
  DATA output_options       TYPE ssfcompop.
  DATA job_output_info      TYPE ssfcrescl.

  DATA : ls_bil_invoice TYPE lbbil_invoice.
  DATA : gv_tot_lines      TYPE i,
         gs_con_settings   TYPE ssfctrlop,
         ls_composer_param TYPE ssfcompop.

CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS       = lwa_OUTPUTPARAMS
   EXCEPTIONS
     CANCEL                = 1
     USAGE_ERROR           = 2
     SYSTEM_ERROR          = 3
     INTERNAL_ERROR        = 4
     OTHERS                = 5
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    I_NAME                     = 'ZF_PAYMENT_ADVICE_PART'
 IMPORTING
   E_FUNCNAME                 = fm_name
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =
          .


  DESCRIBE TABLE gt_bseg LINES gv_tot_lines.
  LOOP AT gt_bseg INTO gs_bseg .
    IF sy-tabix = 1.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_false.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_false.
* CLOSE SPOOL AT THE LAST LOOP ONLY
      gs_con_settings-no_close  = abap_true.
    ELSE.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_true.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_true.
    ENDIF.
    IF sy-tabix = gv_tot_lines.
* CLOSE SPOOL
      gs_con_settings-no_close  = abap_false.
    ENDIF.

    PERFORM combine_header_details.

*    CALL FUNCTION fm_name
*      EXPORTING
*        control_parameters = gs_con_settings
*        output_options     = ls_composer_param
*        wa_header_details  = wa_header_details
*        p_belnr            = gs_bseg-belnr
*        dmbtr              = lv_dmbtr
*        p_gjahr            = p_gjahr
*      TABLES
*        it_final           = it_final.

CALL FUNCTION fm_name  "'/1BCDWB/SM00000089'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    it_final                 = it_final
    wa_header_details        = wa_header_details
    p_belnr                  = gs_bseg-belnr
    dmbtr                    = lv_dmbtr
    p_gjahr                  = p_gjahr
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

  ENDLOOP.

  CALL FUNCTION 'FP_JOB_CLOSE'
   IMPORTING
     E_RESULT             = lwa_result
   EXCEPTIONS
     USAGE_ERROR          = 1
     SYSTEM_ERROR         = 2
     INTERNAL_ERROR       = 3
     OTHERS               = 4
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_SF_FM
*&---------------------------------------------------------------------*

*FORM get_sf_fm .
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = 'ZPAYMENT_ADVICE_PART'
*    IMPORTING
*      fm_name            = fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
*    MESSAGE TEXT-e01 TYPE TEXT-t01.
*  ENDIF.
*ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PRINT_PDF
*&---------------------------------------------------------------------*

*FORM print_pdf .
*
*  PERFORM get_sf_fm .
*
*  ls_ctrlop-getotf = 'X'.
*  ls_ctrlop-no_dialog = 'X'.
*  ls_ctrlop-preview = 'X' . "space.
**
**      "Output Options
*  ls_outopt-tdnoprev = 'X'.
*  ls_outopt-tddest = 'LP01'.
*  ls_outopt-tdnoprint = 'X'.
*
*  LOOP AT gt_bseg INTO gs_bseg .
*
*    PERFORM combine_header_details.
*
*    CALL FUNCTION fm_name
*      EXPORTING
*        control_parameters = ls_ctrlop
*        output_options     = ls_outopt
*        user_settings      = 'X'
*        wa_header_details  = wa_header_details
*        p_belnr            = gs_bseg-belnr
*        dmbtr              = lv_dmbtr
*        p_gjahr            = p_gjahr
*      IMPORTING
*        job_output_info    = gv_job_output
*      TABLES
*        it_final           = it_final
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
*      MESSAGE TEXT-e01 TYPE TEXT-t01.
*    ENDIF.
**
*    CALL FUNCTION 'HR_IT_DISPLAY_WITH_PDF'
**     EXPORTING
**       IV_PDF          =
*      TABLES
*        otf_table = gv_job_output-otfdata.
*  ENDLOOP.
*ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  COMBINE_HEADER_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM combine_header_details .

  READ TABLE gt_bseg INTO gs_bseg WITH KEY koart = 'K' belnr = gs_bseg-belnr.
  wa_header_details-lifnr  = gs_bseg-lifnr.

  READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_header_details-lifnr.
  CONCATENATE wa_lfa1-street wa_lfa1-str_suppl3 wa_lfa1-location INTO lv_street SEPARATED BY space.

  wa_header_details-name1 = wa_lfa1-name1.
*  wa_header_details-street = wa_lfa1-street.
  wa_header_details-street = lv_street.
  wa_header_details-city1 = wa_lfa1-city1.
  wa_header_details-post_code1 = wa_lfa1-post_code1.
  wa_header_details-butxt = wa_t001-butxt.
  wa_header_details-time_zone = wa_lfa1-time_zone.
*  wa_header_details-augbl = p_belnr.

  READ TABLE it_bkpf INTO wa_bkpf INDEX 1.
  wa_header_details-augdt = wa_bkpf-budat.

  SELECT SINGLE dmbtr FROM bseg INTO lv_dmbtr WHERE bukrs = p_bukrs AND belnr = gs_bseg-belnr AND gjahr = p_gjahr AND  koart = 'S' AND shkzg = 'H'.
  wa_header_details-dmbtr = lv_dmbtr.

ENDFORM.
