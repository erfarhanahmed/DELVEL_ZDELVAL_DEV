*----------------------------------------------------------------------*
*      Print of a invoice by SAPscript SMART FORMS               *
*----------------------------------------------------------------------*

REPORT ZSTO_CHALLAN_PROGRAM.

* declaration of data
INCLUDE RLB_INVOICE_DATA_DECLARE.
* definition of forms
*INCLUDE rlb_invoice_form01.
INCLUDE ZRLB_INVOICE_FORM02.

INCLUDE RLB_PRINT_FORMS.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM ENTRY USING RETURN_CODE US_SCREEN.

  DATA: LF_RETCODE TYPE SY-SUBRC.
  CLEAR RETCODE.
  XSCREEN = US_SCREEN.
  PERFORM PROCESSING USING US_SCREEN
                     CHANGING LF_RETCODE.
  IF LF_RETCODE NE 0.
    RETURN_CODE = 1.
  ELSE.
    RETURN_CODE = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM PROCESSING USING PROC_SCREEN
                CHANGING CF_RETCODE.

  DATA: LS_PRINT_DATA_TO_READ TYPE LBBIL_PRINT_DATA_TO_READ.
  DATA: LS_BIL_INVOICE TYPE LBBIL_INVOICE.
  DATA: LF_FM_NAME            TYPE RS38L_FNAM.
  DATA: LS_CONTROL_PARAM      TYPE SSFCTRLOP.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
  DATA: LS_RECIPIENT          TYPE SWOTOBJID.
  DATA: LS_SENDER             TYPE SWOTOBJID.
*  DATA: lf_formname           TYPE tdsfname.
  DATA: LF_FORMNAME           TYPE FPNAME.
  DATA: E_FUNCNM TYPE FUNCNAME.
  DATA: LS_ADDR_KEY           LIKE ADDR_KEY.
  DATA: LS_DLV-LAND           LIKE VBRK-LAND1.
  DATA: LS_JOB_INFO           TYPE SSFCRESCL.

* SmartForm from customizing table TNAPR
  LF_FORMNAME = TNAPR-SFORM.

* BEGIN: Country specific extension for Hungary
  DATA: LV_CCNUM TYPE IDHUCCNUM,
        LV_ERROR TYPE C.

* If a valid entry exists for the form in customizing view
* IDHUBILLINGOUT then the localized output shall be used.
*  SELECT SINGLE ccnum INTO lv_ccnum FROM idhubillingout WHERE
*    kschl = nast-kschl.

*  IF sy-subrc EQ 0.
  IF LV_CCNUM IS INITIAL.
    LV_CCNUM = 1.
  ENDIF.

  IF ( NAST-DELET IS INITIAL OR NAST-DIMME IS INITIAL ).

    NAST-DELET = 'X'.
    NAST-DIMME = 'X'.

    SY-MSGID = 'IDFIHU'.
    SY-MSGTY = 'W'.
    SY-MSGNO = 201.
    SY-MSGV1 = NAST-OBJKY.

    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        MSG_ARBGB = SY-MSGID
        MSG_NR    = SY-MSGNO
        MSG_TY    = SY-MSGTY
        MSG_V1    = SY-MSGV1
        MSG_V2    = ''
        MSG_V3    = ''
        MSG_V4    = ''
      EXCEPTIONS
        OTHERS    = 1.
  ENDIF.
*  ELSE.
*    CLEAR lv_ccnum.
*  ENDIF.
* END: Country specific extension for Hungary

* determine print data
*  PERFORM set_print_data_to_read USING    lf_formname
*                                 CHANGING ls_print_data_to_read
*                                 cf_retcode.
*
*  IF cf_retcode = 0.
* select print data
  PERFORM GET_DATA USING    LS_PRINT_DATA_TO_READ
                   CHANGING LS_ADDR_KEY
                            LS_DLV-LAND
                            LS_BIL_INVOICE
                            CF_RETCODE.
*  ENDIF.

  IF CF_RETCODE = 0.
    PERFORM SET_PRINT_PARAM USING    LS_ADDR_KEY
                                     LS_DLV-LAND
                            CHANGING LS_CONTROL_PARAM
                                     LS_COMPOSER_PARAM
                                     LS_RECIPIENT
                                     LS_SENDER
                                     CF_RETCODE.
  ENDIF.

  IF CF_RETCODE = 0.

    """""""""""""""""""""""""""""adobe*******************************************************


    DATA: LV_FM_NAME       TYPE FUNCNAME,
          LV_DOC_PARAMS    TYPE SFPDOCPARAMS,
          LV_OUTPUT_PARAMS TYPE SFPOUTPUTPARAMS,
*      lv_control_params TYPE sfpcontrol,
          LS_FORM_OUTPUT   TYPE FPFORMOUTPUT.
    " Name of the Function Module.


break dvbasis.
 LV_OUTPUT_PARAMS-DEVICE = 'PRINTER'.
 LV_OUTPUT_PARAMS-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.

 LV_OUTPUT_PARAMS-NODIALOG = 'X'.
 LV_OUTPUT_PARAMS-PREVIEW = ''.
 LV_OUTPUT_PARAMS-REQIMM = 'X'.

ELSE.
 LV_OUTPUT_PARAMS-NODIALOG = ''.
 LV_OUTPUT_PARAMS-PREVIEW = 'X'.

ENDIF.


    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        IE_OUTPUTPARAMS = LV_OUTPUT_PARAMS
      EXCEPTIONS
        CANCEL          = 1
        USAGE_ERROR     = 2
        SYSTEM_ERROR    = 3
        INTERNAL_ERROR  = 4
        OTHERS          = 5.

    IF SY-SUBRC <> 0.
      MESSAGE 'Error initializing Adobe form' TYPE 'E'.
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        I_NAME     = LF_FORMNAME  "" 'ZADOBE_SAMPLE_FORM'  " Your Adobe form name
      IMPORTING
        E_FUNCNAME = E_FUNCNM.

    IF SY-SUBRC <> 0.
*   error handling
      CF_RETCODE = SY-SUBRC.
      PERFORM PROTOCOL_UPDATE.
    ENDIF.
  ENDIF.

  IF CF_RETCODE = 0.
    DATA:LV_NO  TYPE STRING,
         LV_CAL TYPE STRING.
    IF NAST-KSCHL = 'ZPUN' OR NAST-KSCHL = 'ZJST'.
*break dvbasis.
      PERFORM CHECK_REPEAT.
      IF LV_OUTPUT_PARAMS-COPIES EQ 0.
*      nast_anzal = 1.
        LV_NO = 1.
      ELSE.
        LV_NO = LV_OUTPUT_PARAMS-COPIES.
*      nast_anzal = lv_output_params-copies.
      ENDIF.
*    ls_composer_param-tdcopies = 1.

      DO LV_NO TIMES.
* In case of repetition only one time archiving
        IF SY-INDEX > 1 AND NAST-TDARMOD = 3.
          NAST_TDARMOD = NAST-TDARMOD.
          NAST-TDARMOD = 1.
          LS_COMPOSER_PARAM-TDARMOD = 1.
        ENDIF.
        IF SY-INDEX NE 1 AND REPEAT IS INITIAL.
          REPEAT = 'X'.
        ENDIF.
* BEGIN: Country specific extension for Hungary
        IF LV_CCNUM IS NOT INITIAL.
          IF NAST-REPID IS INITIAL.
            NAST-REPID = 1.
          ELSE.
            NAST-REPID = NAST-REPID + 1.
          ENDIF.
          NAST-PFLD1 = LV_CCNUM.
        ENDIF.

        LV_CAL = LV_CAL + 1.

        CALL FUNCTION E_FUNCNM  "'/1BCDWB/SM00000085'
          EXPORTING
*          /1BCDWB/DOCPARAMS        = LS_COMPOSER_PARAM
            LV_NO            = LV_CAL
*           ARCHIVE_INDEX    =
*           ARCHIVE_INDEX_TAB        =
*           ARCHIVE_PARAMETERS       =
*           CONTROL_PARAMETERS       =
*           MAIL_APPL_OBJ    =
*           MAIL_RECIPIENT   =
*           MAIL_SENDER      =
*           OUTPUT_OPTIONS   = ls_composer_param
*           USER_SETTINGS    = 'X'
            LS_BIL_INVOICE   = LS_BIL_INVOICE
* IMPORTING
*           /1BCDWB/FORMOUTPUT       =
          EXCEPTIONS
            USAGE_ERROR      = 1
            SYSTEM_ERROR     = 2
            INTERNAL_ERROR   = 3
            FORMATTING_ERROR = 4
            SEND_ERROR       = 5
            USER_CANCELED    = 6
            OTHERS           = 7.
        IF SY-SUBRC <> 0.
*   error handling
          CF_RETCODE = SY-SUBRC.
          PERFORM PROTOCOL_UPDATE.
* get SmartForm protocoll and store it in the NAST protocoll
          PERFORM ADD_SMFRM_PROT.
        ENDIF.

      ENDDO.
    ELSE.

      PERFORM CHECK_REPEAT.
      IF LS_COMPOSER_PARAM-TDCOPIES EQ 0.
        NAST_ANZAL = 1.
      ELSE.
        NAST_ANZAL = LS_COMPOSER_PARAM-TDCOPIES.
      ENDIF.
      LS_COMPOSER_PARAM-TDCOPIES = 1.

      DO NAST_ANZAL TIMES.
* In case of repetition only one time archiving
        IF SY-INDEX > 1 AND NAST-TDARMOD = 3.
          NAST_TDARMOD = NAST-TDARMOD.
          NAST-TDARMOD = 1.
          LS_COMPOSER_PARAM-TDARMOD = 1.
        ENDIF.
        IF SY-INDEX NE 1 AND REPEAT IS INITIAL.
          REPEAT = 'X'.
        ENDIF.
* BEGIN: Country specific extension for Hungary
        IF LV_CCNUM IS NOT INITIAL.
          IF NAST-REPID IS INITIAL.
            NAST-REPID = 1.
          ELSE.
            NAST-REPID = NAST-REPID + 1.
          ENDIF.
          NAST-PFLD1 = LV_CCNUM.
        ENDIF.
        DATA LV_CNT TYPE CHAR1.
        DO LV_OUTPUT_PARAMS-COPIES TIMES.
          LV_CNT = LV_CNT + 1.

          CALL FUNCTION E_FUNCNM "'/1BCDWB/SM00000049'
            EXPORTING
*             /1BCDWB/DOCPARAMS        =
*             OUTPUT_OPTIONS   =
*             USER_SETTINGS    = 'X'
              LS_BIL_INVOICE   = LS_BIL_INVOICE
              LV_COUNT         = LV_CNT
* IMPORTING
*             /1BCDWB/FORMOUTPUT       =
            EXCEPTIONS
              USAGE_ERROR      = 1
              SYSTEM_ERROR     = 2
              INTERNAL_ERROR   = 3
              FORMATTING_ERROR = 4
              SEND_ERROR       = 5
              USER_CANCELED    = 6
              OTHERS           = 7.
          IF SY-SUBRC <> 0.
* Implement suitable error handling here
            CF_RETCODE = SY-SUBRC.
            PERFORM PROTOCOL_UPDATE.
* get SmartForm protocoll and store it in the NAST protocoll
            PERFORM ADD_SMFRM_PROT.
          ENDIF.


*          CALL FUNCTION E_FUNCNM  "'/1BCDWB/SM00000085'
*            EXPORTING
**             /1BCDWB/DOCPARAMS        =
**             ARCHIVE_INDEX    =
**             ARCHIVE_INDEX_TAB        =
**             ARCHIVE_PARAMETERS       =
**             CONTROL_PARAMETERS       =
**             MAIL_APPL_OBJ    =
**             MAIL_RECIPIENT   =
**             MAIL_SENDER      =
**             OUTPUT_OPTIONS   = ls_composer_param
**             USER_SETTINGS    = 'X'
*              LS_BIL_INVOICE   = LS_BIL_INVOICE
** IMPORTING
**             /1BCDWB/FORMOUTPUT       =
*            EXCEPTIONS
*              USAGE_ERROR      = 1
*              SYSTEM_ERROR     = 2
*              INTERNAL_ERROR   = 3
*              FORMATTING_ERROR = 4
*              SEND_ERROR       = 5
*              USER_CANCELED    = 6
*              OTHERS           = 7.
*          IF SY-SUBRC <> 0.
**   error handling
*            CF_RETCODE = SY-SUBRC.
*            PERFORM PROTOCOL_UPDATE.
** get SmartForm protocoll and store it in the NAST protocoll
*            PERFORM ADD_SMFRM_PROT.
*          ENDIF.
        ENDDO.
      ENDDO.
    ENDIF.
  ENDIF.
*  enddo.
  """""""""""""""""""""""""close



* determine smartform function module for invoice
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*      EXPORTING
*        formname           = lf_formname
**       variant            = ' '
**       direct_call        = ' '
*      IMPORTING
*        fm_name            = lf_fm_name
*      EXCEPTIONS
*        no_form            = 1
*        no_function_module = 2
*        OTHERS             = 3.
*    IF sy-subrc <> 0.
*   error handling
*      cf_retcode = sy-subrc.
*      PERFORM protocol_update.


*  IF cf_retcode = 0.
*    PERFORM check_repeat.
*    IF ls_composer_param-tdcopies EQ 0.
*      nast_anzal = 1.
*    ELSE.
*      nast_anzal = ls_composer_param-tdcopies.
*    ENDIF.
*    ls_composer_param-tdcopies = 1.
*
*    DO nast_anzal TIMES.
** In case of repetition only one time archiving
*      IF sy-index > 1 AND nast-tdarmod = 3.
*        nast_tdarmod = nast-tdarmod.
*        nast-tdarmod = 1.
*        ls_composer_param-tdarmod = 1.
*      ENDIF.
*      IF sy-index NE 1 AND repeat IS INITIAL.
*        repeat = 'X'.
*      ENDIF.
** BEGIN: Country specific extension for Hungary
*      IF lv_ccnum IS NOT INITIAL.
*        IF nast-repid IS INITIAL.
*          nast-repid = 1.
*        ELSE.
*          nast-repid = nast-repid + 1.
*        ENDIF.
*        nast-pfld1 = lv_ccnum.
*      ENDIF.

* END: Country specific extension for Hungary
* call smartform invoice
*BREAK-POINT .
*CALL FUNCTION lf_fm_name"'/1BCDWB/SF00000111'
*  EXPORTING
**   ARCHIVE_INDEX              =
**   ARCHIVE_INDEX_TAB          =
**   ARCHIVE_PARAMETERS         =
**   CONTROL_PARAMETERS         = ls_control_param
**   MAIL_APPL_OBJ              =
**   MAIL_RECIPIENT             =
**   MAIL_SENDER                =
*   OUTPUT_OPTIONS             = ls_composer_param
*   USER_SETTINGS              = space"'X'
*    ls_bil_invoice            = ls_bil_invoice
* IMPORTING
**   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            = ls_job_info"tab_otf_data
**   JOB_OUTPUT_OPTIONS         =
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

*
*      CALL FUNCTION lf_fm_name
*        EXPORTING
*          output_options   = ls_composer_param
*          user_settings    = space
*          ls_bil_invoice   = ls_bil_invoice
**     IMPORTING
**         DOCUMENT_OUTPUT_INFO       =
**         JOB_OUTPUT_INFO  =
**         JOB_OUTPUT_OPTIONS         =
*        EXCEPTIONS
*          formatting_error = 1
*          internal_error   = 2
*          send_error       = 3
*          user_canceled    = 4
*          OTHERS           = 5.
*
*      IF sy-subrc <> 0.
**   error handling
*        cf_retcode = sy-subrc.
*        PERFORM protocol_update.
** get SmartForm protocoll and store it in the NAST protocoll
*        PERFORM add_smfrm_prot.
*      ENDIF.


  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.

  IF SY-SUBRC <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.

* get SmartForm spoolid and store it in the NAST protocoll
  DATA LS_SPOOLID LIKE LINE OF LS_JOB_INFO-SPOOLIDS.
  LOOP AT LS_JOB_INFO-SPOOLIDS INTO LS_SPOOLID.
    IF LS_SPOOLID NE SPACE.
      PERFORM PROTOCOL_UPDATE_SPOOL USING '342' LS_SPOOLID
                                          SPACE SPACE SPACE.
    ENDIF.
  ENDLOOP.
  LS_COMPOSER_PARAM-TDCOPIES = NAST_ANZAL.
  IF NOT NAST_TDARMOD IS INITIAL.
    NAST-TDARMOD = NAST_TDARMOD.
    CLEAR NAST_TDARMOD.
  ENDIF.
*
*  ENDIF.

* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.

ENDFORM.                    "PROCESSING
