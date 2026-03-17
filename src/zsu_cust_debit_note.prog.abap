*&---------------------------------------------------------------------*
*& Report ZCUST_DEBIT_NOTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsu_cust_debit_note.
DATA:
  tmp_belnr TYPE bkpf-belnr,
  tmp_budat TYPE bkpf-budat.
TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs   TYPE bkpf-bukrs,
    belnr   TYPE bkpf-belnr,
    gjahr   TYPE bkpf-gjahr,
    bldat   TYPE bkpf-bldat,
    budat   TYPE bkpf-budat,
    xblnr   TYPE bkpf-xblnr,
    bktxt   TYPE bkpf-bktxt,
    awkey   TYPE bkpf-awkey,
    belnr_r TYPE rseg-belnr,
  END OF t_accounting_doc_hdr,
  tt_accounting_doc_hdr TYPE STANDARD TABLE OF t_accounting_doc_hdr.

TYPES:
  BEGIN OF t_accounting_doc_item,
    bukrs TYPE bseg-bukrs,
    belnr TYPE bseg-belnr,
    gjahr TYPE bseg-gjahr,
    buzei TYPE bseg-buzei,
    dmbtr TYPE bseg-dmbtr,
    wrbtr TYPE bseg-wrbtr,
    sgtxt TYPE bseg-sgtxt,
    hkont TYPE bseg-hkont,
    lifnr TYPE bseg-lifnr,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
  PARAMETERS : p_bukrs TYPE bkpf-bukrs DEFAULT 'SU00' MODIF ID bu,
               p_waers TYPE bkpf-waers OBLIGATORY.
  SELECT-OPTIONS: so_belnr FOR tmp_belnr,
                  so_budat FOR tmp_budat.
  PARAMETERS: p_gjahr TYPE bkpf-gjahr  OBLIGATORY.                   "DEFAULT '2017' OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK b1.

INITIALIZATION.
  xyz = 'Select Options'(tt1).

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
*      IF SCREEN-GROUP1 = 'HW'.
*      SCREEN-INPUT = '0'.
*      MODIFY SCREEN.
*    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  DATA:
  lt_accounting_doc_hdr  TYPE tt_accounting_doc_hdr.


  SELECT bukrs
         belnr
         gjahr
         bldat
         budat
         xblnr
         bktxt
         awkey
    FROM bkpf
    INTO TABLE lt_accounting_doc_hdr
    WHERE belnr IN so_belnr
    AND   gjahr = p_gjahr
  AND   budat IN so_budat
  AND   blart IN ('DG','DR','DV').  " added doc type DV

  IF NOT sy-subrc IS INITIAL.
    MESSAGE 'Please Check Input Data' TYPE 'E'.
  ENDIF.

 "PERFORM layout_display USING lt_accounting_doc_hdr.   "Commented BY Snehal on 18.05.2025

** -- SOC BY Snehal on 18.05.2025              --  **
  "Requirement to convert smartform into Adobe form
  PERFORM form_print USING lt_accounting_doc_hdr.
** -- EOC BY Snehal on 18.05.2025              --  **


*&---------------------------------------------------------------------*
*&      Form  LAYOUT_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ACCOUNTING_DOC_HDR  text
*----------------------------------------------------------------------*
*FORM layout_display  USING    ct_accounting_doc_hdr TYPE tt_accounting_doc_hdr.
*  DATA:
*    ls_accounting_doc_hdr TYPE t_accounting_doc_hdr,
*    lv_fname              TYPE tdsfname VALUE 'ZSU_CR_DB_NOTE',
*    gv_tot_lines          TYPE i,
*    lv_form               TYPE rs38l_fnam,
*    ls_composer_param     TYPE ssfcompop,
*    gs_con_settings       TYPE ssfctrlop.          "CONTROL SETTINGS FOR SMART FORMS
*
*
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = lv_fname
**     VARIANT            = ' '
**     DIRECT_CALL        = ' '
*    IMPORTING
*      fm_name            = lv_form
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*  ls_composer_param-tdcopies = '5'.
*
*  DESCRIBE TABLE ct_accounting_doc_hdr LINES gv_tot_lines.
*
*  LOOP AT ct_accounting_doc_hdr INTO ls_accounting_doc_hdr.
*
*    IF sy-tabix = 1.
** DIALOG AT FIRST LOOP ONLY
*      gs_con_settings-no_dialog = abap_false.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*      gs_con_settings-no_open   = abap_false.
** CLOSE SPOOL AT THE LAST LOOP ONLY
*      gs_con_settings-no_close  = abap_true.
*    ELSE.
** DIALOG AT FIRST LOOP ONLY
*      gs_con_settings-no_dialog = abap_true.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*      gs_con_settings-no_open   = abap_true.
*    ENDIF.
*
*    IF sy-tabix = gv_tot_lines.
** CLOSE SPOOL
*      gs_con_settings-no_close  = abap_false.
*    ENDIF.
*
**    CALL FUNCTION lv_form "'/1BCDWB/SF00000061'
**      EXPORTING
**        control_parameters = gs_con_settings
**        output_options     = ls_composer_param
**        user_settings      = space
**        belnr              = ls_accounting_doc_hdr-belnr
**        gjahr              = ls_accounting_doc_hdr-gjahr
**      EXCEPTIONS
**        formatting_error   = 1
**        internal_error     = 2
**        send_error         = 3
**        user_canceled      = 4
**        OTHERS             = 5.
**    IF sy-subrc <> 0.
*** Implement suitable error handling here
**    ENDIF.
*
*
*    CALL FUNCTION lv_form   ""'/1BCDWB/SF00000242'
*      EXPORTING
*        control_parameters = gs_con_settings
*        output_options     = ls_composer_param
*        user_settings      = space
*        belnr              = ls_accounting_doc_hdr-belnr
*        gjahr              = ls_accounting_doc_hdr-gjahr
*        p_waers            = p_waers
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*
*
*
*
*
*
*
*  ENDLOOP.
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form form_print
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_ACCOUNTING_DOC_HDR
*&---------------------------------------------------------------------*
FORM form_print  USING ct_accounting_doc_hdr TYPE tt_accounting_doc_hdr.

** -- SOC BY Snehal on 18.05.2025              --  **

  TYPES:
    ty_outputparams TYPE sfpoutputparams, "Form Parameters for Form Processing
    ty_docparams    TYPE sfpdocparams.    "Form Processing Output Parameter
  DATA:
    wa_outputparams TYPE sfpoutputparams,
    wa_docparams    TYPE sfpdocparams,
    gv_fm_name      TYPE rs38l_fnam,
    lv_form         TYPE tdsfname,
    gv_page         TYPE char30.


  DATA :  ls_accounting_doc_hdr TYPE t_accounting_doc_hdr.
  lv_form = 'ZSD_CR_DB_NOTE_FORM_1'.


  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = wa_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    " <error handling>
  ENDIF.

  " Get the name of the generated function module
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = lv_form "'ZSD_CR_DB_NOTE_FORM'
    IMPORTING
      e_funcname = gv_fm_name.
  IF sy-subrc <> 0.
    "<error handling>
  ENDIF.

  LOOP AT ct_accounting_doc_hdr INTO ls_accounting_doc_hdr.

    DO 5 TIMES.
*  *** -- COPY RECEIPT
      IF sy-index = 001.
        gv_page = 'ORIGINAL FOR RECIPIENT'.
      ELSEIF sy-index = 002.
        gv_page = 'DUPLICATE FOR TRANSPORTER'.
      ELSEIF sy-index = 003.
        gv_page = 'TRIPLICATE FOR SUPPLIER'.
      ELSEIF sy-index = 004.
        gv_page = 'QUADRUPLICATE FOR ACCOUNT COPY'.
      ELSEIF sy-index = 005.
        gv_page = 'SECURITY COPY'.
      ENDIF.


      CALL FUNCTION gv_fm_name   "'/1BCDWB/SM00000115'
        EXPORTING
*         /1BCDWB/DOCPARAMS        =
          gv_page        = gv_page
          belnr          = ls_accounting_doc_hdr-belnr
          gjahr          = ls_accounting_doc_hdr-gjahr
          p_waers        = p_waers
* IMPORTING
*         /1BCDWB/FORMOUTPUT       =
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.


    ENDDO.
  ENDLOOP.


  " Close the spool job
  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
    " <error handling>
  ENDIF.

** -- EOC BY Snehal on 18.05.2025              --  **
ENDFORM.
