*&---------------------------------------------------------------------*
*&  Include           ZSU_FI_PAYMENT_VOUCHER_DATA
*&---------------------------------------------------------------------*

FORM get_data .             """""" FOR FULL PAYMENT

  IF p_waers NE 'SAR'.
    SELECT  bukrs
            belnr
            gjahr
            blart
            bldat
            budat
            xblnr
            usnam
            waers
            hwaer
       FROM bkpf
      INTO TABLE it_bkpf
      WHERE belnr IN s_belnr
      AND gjahr IN s_gjahr
      AND waers EQ p_waers
      AND BUKRS EQ P_BUKRS..    " added by sonu

  ELSE.

    SELECT  bukrs
        belnr
        gjahr
        blart
        bldat
        budat
        xblnr
        usnam
        waers
        hwaer
   FROM bkpf
  INTO TABLE it_bkpf
  WHERE belnr IN s_belnr
  AND gjahr IN s_gjahr
  AND hwaer EQ p_waers
      AND BUKRS EQ P_BUKRS.                          " added by sonu

  ENDIF.
  SELECT bukrs
         belnr
         gjahr
         buzei
         buzid
         augbl
         koart
         lifnr
         zlsch
         dmbtr
         wrbtr
    FROM bseg
    INTO TABLE it_bseg
    WHERE koart EQ 'K'
    AND  bukrs EQ p_bukrs
    AND belnr IN s_belnr
    AND gjahr IN s_gjahr.

  SELECT lifnr
         land1
         name1
         ort01
         stras
         pstlz
    FROM lfa1
    INTO TABLE it_lfa1
    FOR ALL ENTRIES IN it_bseg
    WHERE lifnr = it_bseg-lifnr.

  SELECT bukrs
         lifnr
         augbl
         gjahr
         belnr
         blart
    SUM( dmbtr )
         budat
    FROM bsak
    INTO TABLE it_bsak
    WHERE blart IN ('KR','RE','KG')
    AND augbl IN s_belnr
    AND gjahr IN s_gjahr
    AND bukrs EQ p_bukrs
    GROUP BY augbl bukrs lifnr gjahr belnr blart budat.


  SELECT lifnr
         banks
         bankl
         bankn
    FROM lfbk
    INTO TABLE it_lfbk
    FOR ALL ENTRIES IN it_bseg
    WHERE lifnr = it_bseg-lifnr.

  IF it_bsak IS NOT INITIAL.

    SELECT *
*           ZLSCH
      FROM bseg
      INTO  @DATA(pay_mode)
      FOR ALL ENTRIES IN @it_bsak
      WHERE koart = 'K'
      AND   bukrs = @it_bsak-bukrs
      AND   gjahr = @it_bsak-gjahr
      AND   belnr = @it_bsak-belnr.
    ENDSELECT.

  ENDIF.

  IF pay_mode IS NOT INITIAL. " added by sonu

  SELECT land1
         zlsch
         text1
    FROM t042z
    INTO TABLE it_t042z
    WHERE land1 EQ 'SA'
    AND zlsch = pay_mode-zlsch.
    endif.
  IF  sy-subrc IS INITIAL .

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PERFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
* -->  p1        text
* <--  p2        text
*----------------------------------------------------------------------*
FORM perform .

  LOOP AT it_bseg INTO wa_bseg .
* LOOP AT IT_BSAK INTO WA_BSAK .


*rEAD TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSAK-AUGBL.
    wa_final-belnr1 = wa_bsak-belnr.
    wa_final-belnr = wa_bseg-belnr.
    wa_final-lifnr = wa_bseg-lifnr.
    wa_final-wrbtr = wa_bseg-wrbtr.

    READ TABLE it_bkpf INTO wa_bkpf WITH KEY belnr = wa_bseg-belnr.

    wa_final-budat  = wa_bkpf-budat.
    wa_final-gjahr  = wa_bkpf-gjahr.
    wa_final-xblnr  = wa_bkpf-xblnr.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_bseg-lifnr.

    wa_final-name1 = wa_lfa1-name1.
    wa_final-stras = wa_lfa1-stras.
    wa_final-ort01 = wa_lfa1-ort01.
    wa_final-pstlz = wa_lfa1-pstlz.

    READ TABLE it_lfbk INTO wa_lfbk WITH KEY lifnr = wa_bseg-lifnr.

    wa_final-bankl  = wa_lfbk-bankl.
    wa_final-bankn  = wa_lfbk-bankn.

*    READ TABLE IT_BSAK INTO WA_BSAK WITH KEY AUGBL = WA_BSEG-BELNR.
*    WA_FINAL-BELNR1 = WA_BSAK-BELNR.

    READ TABLE it_t042z INTO wa_t042z INDEX 1.
    wa_final-text1 = wa_t042z-text1.
    wa_final-curr = p_waers.

    APPEND wa_final TO it_final.
    CLEAR wa_final.

  ENDLOOP.

ENDFORM.

FORM call_smartform  .

  DATA formname    TYPE tdsfname VALUE 'ZSU_FI_PAYMENT_VOUCHER_NEW'.
  DATA fm_name     TYPE rs38l_fnam.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Adobe """""""""""""""""""""""""""""""""""""""""""""""""""


DATA: lv_fm_name TYPE funcname,
      lv_doc_params TYPE sfpdocparams,
      lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
      ls_form_output  TYPE fpformoutput.
 DATA:       E_FUNCNM TYPE FUNCNAME .             " Name of the Function Module
 CONSTANTS : sf_name1 TYPE FPNAME VALUE 'ZSU_FI_PAYMENT_VOUCHER_NEW_SFP'.


lv_output_params-DEVICE = 'PRINTER'.
lv_output_params-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
lv_output_params-NODIALOG = 'X'.
lv_output_params-PREVIEW = ''.
lv_output_params-REQIMM = 'X'.
ELSE.
lv_output_params-NODIALOG = ''.
lv_output_params-PREVIEW = 'X'.
ENDIF.


CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lv_output_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.

*  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*    EXPORTING
*      i_name     = sf_name1 "" 'ZADOBE_SAMPLE_FORM'  " Your Adobe form name
*    IMPORTING
*      e_funcname = E_FUNCNM.


CLEAR : E_FUNCNM.
CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name                     = 'ZSU_FI_PAYMENT_VOUCHER_NEW_SFP'
 IMPORTING
   E_FUNCNAME                 = E_FUNCNM
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =
          .







*DATA control_parameters   TYPE ssfctrlop.
*  DATA output_options       TYPE ssfcompop.
*  DATA job_output_info      TYPE ssfcrescl.
*
  DATA : ls_bil_invoice TYPE lbbil_invoice.
  DATA : gv_tot_lines      TYPE i,
         gs_con_settings   TYPE ssfctrlop,
         ls_composer_param TYPE ssfcompop.
  DESCRIBE TABLE it_final LINES gv_tot_lines.




LOOP AT it_final INTO wa_final.

  IF SY-TABIX = 1.
* DIALOG AT FIRST LOOP ONLY
      GS_CON_SETTINGS-NO_DIALOG = ABAP_FALSE.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      GS_CON_SETTINGS-NO_OPEN   = ABAP_FALSE.
* CLOSE SPOOL AT THE LAST LOOP ONLY
      GS_CON_SETTINGS-NO_CLOSE  = ABAP_TRUE.
    ELSE.
* DIALOG AT FIRST LOOP ONLY
      GS_CON_SETTINGS-NO_DIALOG = ABAP_TRUE.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      GS_CON_SETTINGS-NO_OPEN   = ABAP_TRUE.
    ENDIF.

    IF SY-TABIX = GV_TOT_LINES.
* CLOSE SPOOL
      GS_CON_SETTINGS-NO_CLOSE  = ABAP_FALSE.
    ENDIF.




CALL FUNCTION   E_FUNCNM  "'/1BCDWB/SM00000071'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    wa_final1                = wa_final
    belnr                    = wa_final-belnr
    waers                    = p_waers
    it_final                 = it_final
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



*
*CALL FUNCTION   E_FUNCNM  "'/1BCDWB/SM00000071'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
*    control_parameters       = gs_con_settings
*    output_options           = ls_composer_param
*    user_settings            =  space
*    wa_final1                = wa_final
*    belnr                    = wa_final-belnr
*    waers                    = p_waers
*    it_final                 = it_final
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.




*CALL FUNCTION E_FUNCNM "'/1BCDWB/SM00000073'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
*    control_parameters       = gs_con_settings
**    mail_appl_obj            =
**    mail_recipient           =
**    mail_sender              =
*    output_options           = ls_composer_param
*    user_settings            = space
*    wa_final1                = wa_final
*    belnr                    = wa_final-belnr
*    waers                    = p_waers
*    it_final                 = it_final
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.




*
*
*CALL FUNCTION   E_FUNCNM  ""'/1BCDWB/SM00000071'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
*    control_parameters       = gs_con_settings
*    output_options           = ls_composer_param
*    user_settings            =  space
*    wa_final1                = wa_final
*    belnr                    = wa_final-belnr
*    waers                    = p_waers
*    it_final                 = it_final
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*

  ENDLOOP.

  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  IF sy-subrc <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.



"""""""""""""""""""""""""""""""""""""""""""""""""""""""Adobe Close"""""""""""""""""""""""""""""""""""""""""""""""""""

*
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = formname
*      variant            = ' '
*      direct_call        = ' '
*    IMPORTING
*      fm_name            = fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
**
*  DATA control_parameters   TYPE ssfctrlop.
*  DATA output_options       TYPE ssfcompop.
*  DATA job_output_info      TYPE ssfcrescl.
**
*  DATA : ls_bil_invoice TYPE lbbil_invoice.
*  DATA : gv_tot_lines      TYPE i,
*         gs_con_settings   TYPE ssfctrlop,
*         ls_composer_param TYPE ssfcompop.
***
*  DESCRIBE TABLE it_final LINES gv_tot_lines.
**
*
*  LOOP AT it_final INTO wa_final.
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
*    IF sy-tabix = gv_tot_lines.
** CLOSE SPOOL
*      gs_con_settings-no_close  = abap_false.
*    ENDIF.
*
*    CALL FUNCTION fm_name "'/1BCDWB/SF00000220'
*      EXPORTING
**       ARCHIVE_INDEX      = ARCHIVE_INDEX
**       ARCHIVE_INDEX_TAB  = ARCHIVE_INDEX_TAB
**       ARCHIVE_PARAMETERS = ARCHIVE_PARAMETERS
*        control_parameters = gs_con_settings
**       MAIL_APPL_OBJ      = MAIL_APPL_OBJ
**       MAIL_RECIPIENT     = MAIL_RECIPIENT
**       MAIL_SENDER        = MAIL_SENDER
*        output_options     = ls_composer_param
**       USER_SETTINGS      = 'X'
*        wa_final1          = wa_final
*        belnr              = wa_final-belnr
*        waers              = p_waers
**       P_GJAHR            = P_GJAHR
** IMPORTING
**       DOCUMENT_OUTPUT_INFO       = DOCUMENT_OUTPUT_INFO
**       JOB_OUTPUT_INFO    = JOB_OUTPUT_INFO
**       JOB_OUTPUT_OPTIONS = JOB_OUTPUT_OPTIONS
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
*
*  ENDLOOP.

ENDFORM.

FORM get_data_r_adv .                                   """"""""""""" FOR ADVANCE PAYMENT


  IF p_waers NE 'SAR'.
    SELECT  bukrs
            belnr
            gjahr
            blart
            bldat
            budat
            xblnr
            usnam
            waers
            hwaer
       FROM bkpf
      INTO TABLE it_bkpf
      WHERE belnr IN s_belnr
      AND gjahr IN s_gjahr
      AND waers EQ p_waers
      AND BUKRS EQ P_BUKRS.    " added by sonu

  ELSE.

    SELECT  bukrs
        belnr
        gjahr
        blart
        bldat
        budat
        xblnr
        usnam
        waers
        hwaer
   FROM bkpf
  INTO TABLE it_bkpf
  WHERE belnr IN s_belnr
  AND gjahr IN s_gjahr
  AND hwaer EQ p_waers
      AND BUKRS EQ P_BUKRS.   " added by sonu

  ENDIF.
*BREAK-POINT.
  SELECT bukrs
         belnr
         gjahr
         buzei
         buzid
         augbl
         koart
         lifnr
         zlsch
         dmbtr
         wrbtr
         sgtxt
    FROM bseg
    INTO TABLE it_bseg
    WHERE koart EQ 'K'
    AND belnr IN s_belnr
    AND gjahr IN s_gjahr
    AND bukrs EQ p_bukrs.

  SELECT lifnr
         land1
         name1
         ort01
         stras
         pstlz
    FROM lfa1
    INTO TABLE it_lfa1
    FOR ALL ENTRIES IN it_bseg
    WHERE lifnr = it_bseg-lifnr.

  SELECT bukrs
         lifnr
         augbl
         gjahr
         belnr
         blart
    SUM( dmbtr )
         budat
    FROM bsak
    INTO TABLE it_bsak
    WHERE blart IN ('KR','RE','KG')
    AND augbl IN s_belnr
    AND gjahr  IN s_gjahr
    GROUP BY augbl bukrs lifnr gjahr belnr blart budat.


  SELECT lifnr
         banks
         bankl
         bankn
    FROM lfbk
    INTO TABLE it_lfbk
    FOR ALL ENTRIES IN it_bseg
    WHERE lifnr = it_bseg-lifnr.


*  SELECT *
**           ZLSCH
*    FROM BSEG
*    INTO  @DATA(PAY_MODE)
*    FOR ALL ENTRIES IN @IT_BSAK
*    WHERE KOART = 'K'
*    AND   BUKRS = @IT_BSAK-BUKRS
*    AND   GJAHR = @IT_BSAK-GJAHR
*    AND   BELNR = @IT_BSAK-BELNR.
*  ENDSELECT.
*
*  SELECT LAND1
*         ZLSCH
*         TEXT1
*    FROM T042Z
*    INTO TABLE IT_T042Z
*    WHERE LAND1 EQ 'SA'
*    AND ZLSCH = PAY_MODE-ZLSCH.
*  IF  SY-SUBRC IS INITIAL .
*
*  ENDIF.

  LOOP AT it_bseg INTO wa_bseg .
* LOOP AT IT_BSAK INTO WA_BSAK .
*rEAD TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSAK-AUGBL.
    wa_final-belnr1 = wa_bsak-belnr.
    wa_final-gjahr  = wa_bseg-gjahr.

    wa_final-belnr = wa_bseg-belnr.
    wa_final-lifnr = wa_bseg-lifnr.
    wa_final-dmbtr = wa_bseg-dmbtr.
    wa_final-wrbtr = wa_bseg-wrbtr.
    wa_final-sgtxt = wa_bseg-sgtxt.

    READ TABLE it_bkpf INTO wa_bkpf WITH KEY belnr = wa_bseg-belnr.

    wa_final-budat = wa_bkpf-budat.
    wa_final-xblnr  = wa_bkpf-xblnr.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_bseg-lifnr.

    wa_final-name1 = wa_lfa1-name1.
    wa_final-stras = wa_lfa1-stras.
    wa_final-ort01 = wa_lfa1-ort01.
    wa_final-pstlz = wa_lfa1-pstlz.

    READ TABLE it_lfbk INTO wa_lfbk WITH KEY lifnr = wa_bseg-lifnr.

    wa_final-bankl  = wa_lfbk-bankl.
    wa_final-bankn  = wa_lfbk-bankn.

*    READ TABLE IT_BSAK INTO WA_BSAK WITH KEY AUGBL = WA_BSEG-BELNR.
*    WA_FINAL-BELNR1 = WA_BSAK-BELNR.

    READ TABLE it_t042z INTO wa_t042z INDEX 1.
    wa_final-text1 = wa_t042z-text1.
    wa_final-curr = p_waers.

    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALL_SMARTFORM_R_ADV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_smartform_r_adv .

  DATA formname    TYPE tdsfname VALUE 'ZSU_FI_PAYMENT_VOUCHER_AD'.
  DATA fm_name     TYPE rs38l_fnam.

DATA: lv_fm_name TYPE funcname,
      lv_doc_params TYPE sfpdocparams,
      lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
      ls_form_output  TYPE fpformoutput.
 DATA:       E_FUNCNM TYPE FUNCNAME .             " Name of the Function Module
 CONSTANTS : sf_name1 TYPE FPNAME VALUE 'ZSU_FI_PAYMENT_VOUCHER_AD_SFP'.
DATA : gv_tot_lines      TYPE i.

lv_output_params-DEVICE = 'PRINTER'.
lv_output_params-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
lv_output_params-NODIALOG = 'X'.
lv_output_params-PREVIEW = ''.
lv_output_params-REQIMM = 'X'.
ELSE.
lv_output_params-NODIALOG = ''.
lv_output_params-PREVIEW = 'X'.
ENDIF.



CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lv_output_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = sf_name1 "" 'ZADOBE_SAMPLE_FORM'  " Your Adobe form name
    IMPORTING
      e_funcname = E_FUNCNM.


 LOOP AT it_final INTO wa_final.

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



CALL FUNCTION  E_FUNCNM "'/1BCDWB/SM00000079'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    wa_final1                = wa_final
    belnr                    = wa_final-belnr
    waers                    = p_waers
    it_final                 = it_final
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


*   CALL FUNCTION  E_FUNCNM  " '/1BCDWB/SM00000079'
*     EXPORTING
**      /1BCDWB/DOCPARAMS        =
*       control_parameters       = gs_con_settings
*       mail_appl_obj            =
*       mail_recipient           =
*       mail_sender              =
*       output_options           =
*       user_settings            =
*       wa_final1                =  wa_final
*       belnr                    =  wa_final-belnr
*       waers                    =  p_waers
*       it_final                 =  it_final
**    IMPORTING
**      /1BCDWB/FORMOUTPUT       =
*    EXCEPTIONS
*      USAGE_ERROR              = 1
*      SYSTEM_ERROR             = 2
*      INTERNAL_ERROR           = 3
*      OTHERS                   = 4
*             .
*   IF sy-subrc <> 0.
** Implement suitable error handling here
*   ENDIF.


    ENDLOOP.




  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  IF sy-subrc <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.


"**********************************************************Adobe close *********************************************





*
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = formname
*      variant            = ' '
*      direct_call        = ' '
*    IMPORTING
*      fm_name            = fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*
*  DATA control_parameters   TYPE ssfctrlop.
*  DATA output_options       TYPE ssfcompop.
*  DATA job_output_info      TYPE ssfcrescl.
*
*  DATA : ls_bil_invoice TYPE lbbil_invoice.
*  DATA : gv_tot_lines      TYPE i,
*         gs_con_settings   TYPE ssfctrlop,
*         ls_composer_param TYPE ssfcompop.
**
*  DESCRIBE TABLE it_final LINES gv_tot_lines.
*
*
*  LOOP AT it_final INTO wa_final.
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
*    IF sy-tabix = gv_tot_lines.
** CLOSE SPOOL
*      gs_con_settings-no_close  = abap_false.
*    ENDIF.
*
*    CALL FUNCTION fm_name "'/1BCDWB/SF00000220'
*      EXPORTING
**       ARCHIVE_INDEX      = ARCHIVE_INDEX
**       ARCHIVE_INDEX_TAB  = ARCHIVE_INDEX_TAB
**       ARCHIVE_PARAMETERS = ARCHIVE_PARAMETERS
*        control_parameters = gs_con_settings
**       MAIL_APPL_OBJ      = MAIL_APPL_OBJ
**       MAIL_RECIPIENT     = MAIL_RECIPIENT
**       MAIL_SENDER        = MAIL_SENDER
*        output_options     = ls_composer_param
**       USER_SETTINGS      = 'X'
*        wa_final1          = wa_final
*        belnr              = wa_final-belnr
*        waers              = p_waers
**       P_GJAHR            = P_GJAHR
** IMPORTING
**       DOCUMENT_OUTPUT_INFO       = DOCUMENT_OUTPUT_INFO
**       JOB_OUTPUT_INFO    = JOB_OUTPUT_INFO
**       JOB_OUTPUT_OPTIONS = JOB_OUTPUT_OPTIONS
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
*
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_PART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_part .                                            """"" FOR PARTIAL PAYMENT


  IF p_waers NE 'SAR'.
    SELECT  bukrs
            belnr
            gjahr
            blart
            bldat
            budat
            xblnr
            usnam
            waers
            hwaer
       FROM bkpf
      INTO TABLE it_bkpf
      WHERE belnr IN s_belnr
      AND gjahr IN s_gjahr
      AND waers EQ p_waers
       AND BUKRS EQ P_BUKRS..   " added by sonu

  ELSE.

    SELECT  bukrs
        belnr
        gjahr
        blart
        bldat
        budat
        xblnr
        usnam
        waers
        hwaer
   FROM bkpf
  INTO TABLE it_bkpf
  WHERE belnr IN s_belnr
  AND gjahr IN s_gjahr
  AND hwaer EQ p_waers
      AND BUKRS EQ P_BUKRS.   "added by sonu

  ENDIF.

  SELECT bukrs
         belnr
         gjahr
         buzei
         buzid
         augbl
         koart
         lifnr
         zlsch
         dmbtr
         wrbtr
      FROM bseg
    INTO TABLE it_bseg
    WHERE koart EQ 'K'
    AND belnr IN s_belnr
    AND gjahr IN s_gjahr
    AND BUKRS EQ P_BUKRS..   "added by sonu

  LOOP AT it_bseg INTO wa_bseg.
    lv_amount = lv_amount + wa_bseg-dmbtr.
  ENDLOOP.



  SELECT lifnr
         land1
         name1
         ort01
         stras
         pstlz
    FROM lfa1
    INTO TABLE it_lfa1
    FOR ALL ENTRIES IN it_bseg
    WHERE lifnr = it_bseg-lifnr.

  SELECT bukrs
         lifnr
         augbl
         gjahr
         belnr
         blart
    SUM( dmbtr )
         budat
    FROM bsak
    INTO TABLE it_bsak
    WHERE blart IN ('KR','RE','KG')
    AND augbl IN s_belnr
    AND gjahr IN s_gjahr
    GROUP BY augbl bukrs lifnr gjahr belnr blart budat.


  SELECT lifnr
         banks
         bankl
         bankn
    FROM lfbk
    INTO TABLE it_lfbk
    FOR ALL ENTRIES IN it_bseg
    WHERE lifnr = it_bseg-lifnr.

*BREAK-POINT.
  SELECT bukrs                      """"""BILL NO
         belnr
         gjahr
         budat
         dmbtr
         augbl
         blart
         rebzg
         wrbtr
         REBZJ                        " added by sonu
    FROM bsik
    INTO TABLE it_bsik
    WHERE belnr IN s_belnr
    AND gjahr IN s_gjahr.

  SELECT belnr,
         zlsch
    FROM bseg
    INTO TABLE @DATA(it_pay_mode)
    FOR ALL ENTRIES IN @it_bsik
    WHERE belnr = @it_bsik-rebzg
    AND bukrs = @it_bsik-bukrs
    AND koart EQ 'K'.

  SELECT
         text1                                """"""" PAYMENT MODE
    FROM t042z
    INTO TABLE @DATA(it_pay)
    FOR ALL ENTRIES IN @it_pay_mode
    WHERE zlsch = @it_pay_mode-zlsch
    AND   land1 EQ 'SA'.

  SELECT                            """"""BILL AMOUNT,BILL DATE
         belnr,
         bukrs,
         dmbtr,
         wrbtr,
         budat
    FROM bsik
    INTO TABLE @DATA(it_bsik1)
    FOR ALL ENTRIES IN @it_bsik
    WHERE belnr = @it_bsik-rebzg
    AND bukrs = @it_bsik-bukrs     " added by sonu
    AND gjahr = @it_bsik-REBZJ.    " added by sonu


  SELECT dmbtr                      """""Other adjestment
      FROM bsik
    INTO TABLE @DATA(it_adj)
    FOR ALL ENTRIES IN @it_bsik
    WHERE belnr = @it_bsik-augbl
    AND blart = 'KG'
    AND gjahr IN @s_gjahr.

  LOOP AT it_bseg INTO wa_bseg .
* LOOP AT IT_BSAK INTO WA_BSAK .

    wa_final-amount = lv_amount.

*rEAD TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSAK-AUGBL.
    wa_final-belnr1 = wa_bsak-belnr.

    wa_final-belnr = wa_bseg-belnr.
    wa_final-lifnr = wa_bseg-lifnr.


    READ TABLE it_bkpf INTO wa_bkpf WITH KEY belnr = wa_bseg-belnr.
    wa_final-gjahr  = wa_bkpf-gjahr.
    wa_final-budat  = wa_bkpf-budat.
    wa_final-xblnr  = wa_bkpf-xblnr.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_bseg-lifnr.

    wa_final-name1 = wa_lfa1-name1.
    wa_final-stras = wa_lfa1-stras.
    wa_final-ort01 = wa_lfa1-ort01.
    wa_final-pstlz = wa_lfa1-pstlz.

    READ TABLE it_lfbk INTO wa_lfbk WITH KEY lifnr = wa_bseg-lifnr.

    wa_final-bankl  = wa_lfbk-bankl.
    wa_final-bankn  = wa_lfbk-bankn.

*    READ TABLE IT_BSAK INTO WA_BSAK WITH KEY AUGBL = WA_BSEG-BELNR.
*    WA_FINAL-BELNR1 = WA_BSAK-BELNR.

    READ TABLE it_t042z INTO wa_t042z INDEX 1.
    wa_final-text1 = wa_t042z-text1.

    READ TABLE it_bsik INTO wa_bsik WITH KEY belnr = wa_bseg-belnr.
    wa_final-rebzg  = wa_bsik-rebzg.
    wa_final-budat  = wa_bsik-budat.
*    IF wa_bsik-wrbtr IS NOT INITIAL.
    wa_final-wrbtr1 = wa_bsik-wrbtr.
*    ENDIF.

    READ TABLE it_pay INTO DATA(wa_pay) INDEX 1.
    wa_final-text1 = wa_pay-text1.

    READ TABLE it_bsik1 INTO DATA(wa_bsik1) WITH KEY belnr = wa_bsik-rebzg.
    wa_final-dmbtr = wa_bsik1-dmbtr.
    wa_final-wrbtr = wa_bsik1-wrbtr.

    wa_final-curr = p_waers.

    APPEND wa_final TO it_final.
    CLEAR wa_final.

  ENDLOOP.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALL_SMARTFORM_PART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_smartform_part .

  DATA formname    TYPE tdsfname VALUE 'ZSU_FI_PAYMENT_VOUCHER_PAR'.
  DATA fm_name     TYPE rs38l_fnam.




DATA: lv_fm_name TYPE funcname,
      lv_doc_params TYPE sfpdocparams,
      lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
      ls_form_output  TYPE fpformoutput.
 DATA:       E_FUNCNM TYPE FUNCNAME .             " Name of the Function Module
 CONSTANTS : sf_name1 TYPE FPNAME VALUE 'ZSU_FI_PAYMENT_VOUCHER_PAR_SFP'.



CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lv_output_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = sf_name1 "" 'ZADOBE_SAMPLE_FORM'  " Your Adobe form name
    IMPORTING
      e_funcname = E_FUNCNM.


  DATA control_parameters   TYPE ssfctrlop.
  DATA output_options       TYPE ssfcompop.
  DATA job_output_info      TYPE ssfcrescl.

  DATA : ls_bil_invoice TYPE lbbil_invoice.
  DATA : gv_tot_lines      TYPE i,
         gs_con_settings   TYPE ssfctrlop,
         ls_composer_param TYPE ssfcompop.
*
  DESCRIBE TABLE it_final LINES gv_tot_lines.


  LOOP AT it_final INTO wa_final.

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

CALL FUNCTION  E_FUNCNM ""'/1BCDWB/SM00000082'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    wa_final1                = wa_final
    belnr                    = wa_final-belnr
    waers                    = p_waers
    it_final                 = it_final

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
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  IF sy-subrc <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.





""""""""""""""""""""""""""""""""""""""""""""""""""ADOBE CLOSE"""""""""""""""""""""""""""""""""""""""










*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = formname
*      variant            = ' '
*      direct_call        = ' '
*    IMPORTING
*      fm_name            = fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*
*  DATA control_parameters   TYPE ssfctrlop.
*  DATA output_options       TYPE ssfcompop.
*  DATA job_output_info      TYPE ssfcrescl.
*
*  DATA : ls_bil_invoice TYPE lbbil_invoice.
*  DATA : gv_tot_lines      TYPE i,
*         gs_con_settings   TYPE ssfctrlop,
*         ls_composer_param TYPE ssfcompop.
**
*  DESCRIBE TABLE it_final LINES gv_tot_lines.
*
*
*  LOOP AT it_final INTO wa_final.
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
*    IF sy-tabix = gv_tot_lines.
** CLOSE SPOOL
*      gs_con_settings-no_close  = abap_false.
*    ENDIF.
*
*    CALL FUNCTION fm_name "'/1BCDWB/SF00000220'
*      EXPORTING
**       ARCHIVE_INDEX      = ARCHIVE_INDEX
**       ARCHIVE_INDEX_TAB  = ARCHIVE_INDEX_TAB
**       ARCHIVE_PARAMETERS = ARCHIVE_PARAMETERS
*        control_parameters = gs_con_settings
**       MAIL_APPL_OBJ      = MAIL_APPL_OBJ
**       MAIL_RECIPIENT     = MAIL_RECIPIENT
**       MAIL_SENDER        = MAIL_SENDER
*        output_options     = ls_composer_param
**       USER_SETTINGS      = 'X'
*        wa_final1          = wa_final
*        belnr              = wa_final-belnr
*        waers              = p_waers
**       P_GJAHR            = P_GJAHR
** IMPORTING
**       DOCUMENT_OUTPUT_INFO       = DOCUMENT_OUTPUT_INFO
**       JOB_OUTPUT_INFO    = JOB_OUTPUT_INFO
**       JOB_OUTPUT_OPTIONS = JOB_OUTPUT_OPTIONS
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
*
*  ENDLOOP.
*


ENDFORM.
