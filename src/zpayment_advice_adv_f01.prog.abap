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
    FROM lfa1 AS lf
    JOIN adrc AS ad ON lf~adrnr = ad~addrnumber
    INTO CORRESPONDING FIELDS OF wa_lfa1 UP TO 1 ROWS
    WHERE lf~lifnr = p_lifnr .

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_lfa1-adrnr
      IMPORTING
        output = wa_lfa1-adrnr.

    SELECT SINGLE * FROM adrc INTO @DATA(ls_adrc)  WHERE addrnumber  = @wa_lfa1-adrnr.

    CONCATENATE ls_adrc-street ls_adrc-str_suppl3 ls_adrc-location INTO lv_street SEPARATED BY space.
    lv_timezone = ls_adrc-time_zone.


    SELECT * FROM bkpf INTO TABLE lt_bkpf WHERE belnr IN s_belnr AND bukrs = p_bukrs AND gjahr = s_gjahr AND blart = 'KZ'.

  ENDSELECT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BANK_DETAILS
*&---------------------------------------------------------------------*

FORM get_bank_details .
  SELECT SINGLE bukrs
         butxt
    FROM t001
    INTO wa_t001
    WHERE bukrs = p_bukrs.

  SELECT lifnr
         banks
         bankl
         bankn
    FROM lfbk
    INTO CORRESPONDING FIELDS OF wa_lfbk
    WHERE lifnr = p_lifnr.
  ENDSELECT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COMBINE_HEADER_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM combine_header_details .

  wa_header_details-lifnr  = wa_lfa1-lifnr.
  wa_header_details-name1 = wa_lfa1-name1.
*  wa_header_details-street = wa_lfa1-street.
  wa_header_details-street = lv_street.
  wa_header_details-city1 = wa_lfa1-city1.
  wa_header_details-post_code1 = wa_lfa1-post_code1.
  wa_header_details-butxt = wa_t001-butxt.
*  wa_header_details-augbl = p_augbl.
  wa_header_details-time_zone = lv_timezone.
  wa_header_details-bankl = wa_lfbk-bankl.
  wa_header_details-bankn = wa_lfbk-bankn.
  READ TABLE lt_bkpf INTO ls_bkpf INDEX 1.
  wa_header_details-xblnr = ls_bkpf-xblnr.

  READ TABLE it_bkpf INTO DATA(wa_bkpf) INDEX 1.
  wa_header_details-augdt = wa_bkpf-augdt.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ACC_HEADER_DATA
*&---------------------------------------------------------------------*


FORM get_gross_details .

  SELECT bukrs, belnr ,gjahr, lifnr, buzei,dmbtr, bschl, koart, augbl, ktosl,sgtxt
     FROM bseg
    INTO CORRESPONDING FIELDS OF TABLE @gt_gross
                      WHERE bukrs = @p_bukrs
                      AND   belnr IN @s_belnr
                      AND   gjahr = @s_gjahr
                       AND   lifnr = @p_lifnr
                      AND   koart = 'K'.

  SELECT bukrs, belnr,budat
                FROM bkpf
                INTO CORRESPONDING FIELDS OF TABLE @gt_bkpf
                      WHERE bukrs = @p_bukrs
                      AND   belnr IN @s_belnr
                      AND   gjahr = @s_gjahr
                      AND   blart = 'KZ'.



*  it_gross2[] = it_gross[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TDS_DETAILS
*&---------------------------------------------------------------------*
FORM get_tds_details .
  SELECT bukrs ,belnr,buzei,wt_qsshh, wt_qbshh
                    FROM with_item
                    INTO CORRESPONDING FIELDS OF TABLE @gt_with_item
                    FOR ALL ENTRIES IN @gt_gross
                    WHERE bukrs = @gt_gross-bukrs
                    AND   belnr = @gt_gross-belnr
                    AND   gjahr = @gt_gross-gjahr
                    AND   buzei = @gt_gross-buzei. "#EC CI_NO_TRANSFORM

  delete gt_with_item WHERE wt_qsshh is INITIAL AND wt_qbshh IS INITIAL.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FINAL_DATA
*&---------------------------------------------------------------------*

FORM final_data .
  DATA wa_final TYPE zpayment_advice_str.
  SORT gt_gross ASCENDING BY belnr bschl.

  LOOP AT gt_gross INTO gs_gross.
    wa_final-belnr = gs_gross-belnr.
    ls_final-bukrs  = gs_gross-bukrs.
    ls_final-gjahr = gs_gross-gjahr.
    ls_final-lifnr = gs_gross-lifnr.
    wa_final-gross_dmbtr = gs_gross-dmbtr.
    ls_final-belnr = wa_final-belnr.
    wa_final-sgtxt = gs_gross-sgtxt.
    READ TABLE gt_with_item INTO gs_with_item WITH KEY belnr = wa_final-belnr   buzei = gs_gross-buzei.    ""wt_qsshh = wa_final-gross_dmbtr
    wa_final-tds_dmbtr = gs_with_item-wt_qbshh.

    wa_final-net_dmbtr = wa_final-gross_dmbtr -  wa_final-tds_dmbtr.

    READ TABLE gt_bkpf INTO gs_bkpf WITH  KEY belnr = wa_final-belnr.
    wa_final-budat = gs_bkpf-budat.

    APPEND wa_final TO it_final.
    APPEND ls_final TO lt_final.
    CLEAR:gs_gross,gs_with_item ,gs_bkpf.
  ENDLOOP.

  SORT it_final BY belnr.
*  lt_final = it_final.
  DELETE ADJACENT DUPLICATES FROM lt_final COMPARING belnr.

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
  DATA: fm_name TYPE funcname.


lwa_outputparams-DEVICE = 'PRINTER'.
lwa_outputparams-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
lwa_outputparams-NODIALOG = 'X'.
lwa_outputparams-PREVIEW = ''.
lwa_outputparams-REQIMM = 'X'.
ELSE.
lwa_outputparams-NODIALOG = ''.
lwa_outputparams-PREVIEW = 'X'.
ENDIF.





  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lwa_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZF_PAYMENT_ADVICE_ADV_SFP'
    IMPORTING
      e_funcname = fm_name
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
    .

  DESCRIBE TABLE lt_final LINES gv_tot_lines.


  LOOP AT lt_final INTO ls_final .

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

CALL FUNCTION fm_name " '/1BCDWB/SM00000083'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    it_final                 = it_final
    p_belnr                  = ls_final-belnr
    p_gjahr                  = ls_final-gjahr
    p_lifnr                  = ls_final-lifnr
    p_bukrs                  = ls_final-bukrs
    wa_header_details        = wa_header_details
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
 EXCEPTIONS
   USAGE_ERROR              = 1
   SYSTEM_ERROR             = 2
   INTERNAL_ERROR           = 3
   OTHERS                   = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


*    CALL FUNCTION fm_name     "'/1BCDWB/SF00000256'
*      EXPORTING
*        control_parameters = gs_con_settings
*        output_options     = ls_composer_param
*        wa_header_details  = wa_header_details
*        p_bukrs            = ls_final-bukrs
*        p_lifnr            = ls_final-lifnr
*        p_gjahr            = ls_final-gjahr
*        p_belnr            = ls_final-belnr
*      TABLES
*        it_final           = it_final
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.


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
*
**  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
**    EXPORTING
**      formname           = 'ZPAYMENT_ADVICE_ADV'
**    IMPORTING
**      fm_name            = fm_name
**    EXCEPTIONS
**      no_form            = 1
**      no_function_module = 2
**      OTHERS             = 3.
**  IF sy-subrc <> 0.
**    MESSAGE TEXT-e01 TYPE TEXT-t01.
**  ENDIF.
*
*ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PRINT_PDF
*&---------------------------------------------------------------------*

*FORM print_pdf .
*
**  PERFORM get_sf_fm .
**
**
**  ls_ctrlop-getotf = 'X'.
**  ls_ctrlop-no_dialog = 'X'.
**  ls_ctrlop-preview = 'X' . "space.
***
***      "Output Options
**  ls_outopt-tdnoprev = 'X'.
**  ls_outopt-tddest = 'LP01'.
**  ls_outopt-tdnoprint = 'X'.
**
**
**
**  LOOP AT lt_gross INTO ls_gross.
**    CALL FUNCTION fm_name                    ""'/1BCDWB/SF00000256'
**      EXPORTING
**        control_parameters = ls_ctrlop
**        output_options     = ls_outopt
**        user_settings      = 'X'
**        wa_header_details  = wa_header_details
**        p_bukrs            = p_bukrs
**        p_lifnr            = p_lifnr
**        p_gjahr            = s_gjahr
***       p_augbl            = p_augbl
**        p_belnr            = ls_gross-belnr
**      IMPORTING
***       DOCUMENT_OUTPUT_INFO       = DOCUMENT_OUTPUT_INFO
**        job_output_info    = gv_job_output
***       dmbtr              = lv_dmbtr
***       JOB_OUTPUT_OPTIONS = JOB_OUTPUT_OPTIONS
***      TABLES
***       it_final           = it_final
**      EXCEPTIONS
**        formatting_error   = 1
**        internal_error     = 2
**        send_error         = 3
**        user_canceled      = 4
**        OTHERS             = 5.
**    IF sy-subrc <> 0.
*** Implement suitable error handling here
**    ENDIF.
**
**
**
**    CALL FUNCTION 'HR_IT_DISPLAY_WITH_PDF'
***     EXPORTING
***       IV_PDF          =
**      TABLES
**        otf_table = gv_job_output-otfdata.
**  ENDLOOP.
*ENDFORM.
