*----------------------------------------------------------------------*
*      Print of a invoice by SAPscript SMART FORMS               *
*----------------------------------------------------------------------*

REPORT zsd_excise_invoice_drvr_gst.
INCLUDE rlb_invoice_data_declare.
INCLUDE rlb_invoice_form01.
INCLUDE rlb_print_forms.
*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM entry USING return_code us_screen.

  DATA: lf_retcode TYPE sy-subrc.
  CLEAR retcode.
  xscreen = us_screen.
  PERFORM processing USING us_screen
                     CHANGING lf_retcode.
  IF lf_retcode NE 0.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM processing USING proc_screen
                CHANGING cf_retcode.

  DATA: ls_print_data_to_read TYPE lbbil_print_data_to_read.
  DATA: ls_bil_invoice TYPE lbbil_invoice.
  DATA: lf_fm_name            TYPE rs38l_fnam.
  DATA: ls_control_param      TYPE ssfctrlop.
  DATA: ls_composer_param     TYPE ssfcompop.
  DATA: ls_recipient          TYPE swotobjid.
  DATA: ls_sender             TYPE swotobjid.
  DATA: lf_formname           TYPE tdsfname.
  DATA: ls_addr_key           LIKE addr_key.
  DATA: ls_dlv-land           LIKE vbrk-land1.
  DATA: ls_job_info           TYPE ssfcrescl.
  DATA:LV_CNT                 TYPE CHAR1.

* SmartForm from customizing table TNAPR
  lf_formname = tnapr-sform.

* BEGIN: Country specific extension for Hungary
  DATA: lv_ccnum TYPE IDHUCCNUM,
        lv_error TYPE c.

* If a valid entry exists for the form in customizing view
* IDHUBILLINGOUT then the localized output shall be used.
  SELECT SINGLE ccnum INTO lv_ccnum FROM IDHUBILLINGOUT WHERE
    kschl = nast-kschl.

  IF sy-subrc EQ 0.
    IF lv_ccnum IS INITIAL.
      lv_ccnum = 1.
    ENDIF.
***
    IF ( nast-delet IS INITIAL OR nast-dimme IS INITIAL ).

      nast-delet = 'X'.
      nast-dimme = 'X'.

      sy-msgid = 'IDFIHU'.
      sy-msgty = 'W'.
      sy-msgno = 201.
      sy-msgv1 = nast-objky.

      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
        MSG_ARBGB = sy-msgid
        MSG_NR    = sy-msgno
        MSG_TY    = sy-msgty
        MSG_V1    = sy-msgv1
        MSG_V2    = ''
        MSG_V3    = ''
        MSG_V4    = ''
      EXCEPTIONS
        OTHERS    = 1.
    ENDIF.
  ELSE.
    CLEAR lv_ccnum.
  ENDIF.
**** END: Country specific extension for Hungary
***
**** determine print data
  PERFORM set_print_data_to_read USING    lf_formname
                                 CHANGING ls_print_data_to_read
                                 cf_retcode.

***  IF cf_retcode = 0.
**** select print data
    PERFORM get_data USING    ls_print_data_to_read
                     CHANGING ls_addr_key
                              ls_dlv-land
                              ls_bil_invoice
                              cf_retcode.
***  ENDIF.
***
***  IF cf_retcode = 0.
    PERFORM set_print_param USING    ls_addr_key
                                     ls_dlv-land
                            CHANGING ls_control_param
                                     ls_composer_param
                                     ls_recipient
                                     ls_sender
                                     cf_retcode.
***  ENDIF.

*  IF cf_retcode = 0.
* determine smartform function module for invoice
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*         EXPORTING  formname           = lf_formname
**                 variant            = ' '
**                 direct_call        = ' '
*         IMPORTING  fm_name            = lf_fm_name
*         EXCEPTIONS no_form            = 1
*                    no_function_module = 2
*                    OTHERS             = 3.
*    IF sy-subrc <> 0.
**   error handling
*      cf_retcode = sy-subrc.
*      PERFORM protocol_update.
*    ENDIF.
**  ENDIF.

DATA: lv_fm_name TYPE funcname,
      lv_doc_params TYPE sfpdocparams,
      lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
      ls_form_output  TYPE fpformoutput.


*lv_output_params-DEVICE = 'PRINTER'.
*lv_output_params-DEST = 'LP01'.
*IF SY-UCOMM = 'PRNT'.
*
*lv_output_params-NODIALOG = 'X'.
*lv_output_params-PREVIEW = ''.
*lv_output_params-REQIMM = 'X'.
*
*ELSE.
*lv_output_params-NODIALOG = ''.
*lv_output_params-PREVIEW = 'X'.
*
*ENDIF.

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
    ie_outputparams       = lv_output_params
 EXCEPTIONS
   CANCEL                = 1
   USAGE_ERROR           = 2
   SYSTEM_ERROR          = 3
   INTERNAL_ERROR        = 4
   OTHERS                = 5
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name                     = lf_formname
 IMPORTING
   E_FUNCNAME                 = lv_fm_name
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =

 .
data: lv_out TYPE string.
 lv_out = lv_output_params-COPIES ."001.Commented By Sarfaraj Temporary
*BREAK DVBASIS.
DO lv_out TIMES.
  LV_CNT = LV_CNT + 1.


  CALL FUNCTION lv_fm_name  "'/1BCDWB/SM00000051'
    EXPORTING
*     /1BCDWB/DOCPARAMS        =
      ls_bil_invoice           = ls_bil_invoice
      output_options           = ls_composer_param
*     USER_SETTINGS            = 'X'
      lv_count                 = LV_CNT
*   IMPORTING
*     /1BCDWB/FORMOUTPUT       =
  EXCEPTIONS
     USAGE_ERROR              = 1
     SYSTEM_ERROR             = 2
     INTERNAL_ERROR           = 3
     OTHERS                   = 4
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
**error handling
       cf_retcode = sy-subrc.
        PERFORM protocol_update.
* get SmartForm protocoll and store it in the NAST protocoll
        PERFORM add_smfrm_prot.
  ENDIF.
  ENDDO.





*CALL FUNCTION lv_fm_name "'/1BCDWB/SM00000051'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
*    ls_bil_invoice           = ls_bil_invoice
*    output_options           = ls_composer_param
*   USER_SETTINGS            = Space
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
**error handling
*        cf_retcode = sy-subrc.
*        PERFORM protocol_update.
** get SmartForm protocoll and store it in the NAST protocoll
*        PERFORM add_smfrm_prot.
*
*ENDIF.

CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
 EXCEPTIONS
   USAGE_ERROR          = 1
   SYSTEM_ERROR         = 2
   INTERNAL_ERROR       = 3
   OTHERS               = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.





***  IF cf_retcode = 0.
***    PERFORM check_repeat.
***    IF ls_composer_param-tdcopies EQ 0.
***      nast_anzal = 1.
***    ELSE.
***      nast_anzal = ls_composer_param-tdcopies.
***    ENDIF.
*    ls_composer_param-tdcopies = 5.
***
***    DO nast_anzal TIMES.
**** In case of repetition only one time archiving
***      IF sy-index > 1 AND nast-tdarmod = 3.
***        nast_tdarmod = nast-tdarmod.
***        nast-tdarmod = 1.
***        ls_composer_param-tdarmod = 1.
***      ENDIF.
***      IF sy-index NE 1 AND repeat IS INITIAL.
***        repeat = 'X'.
***      ENDIF.
**** BEGIN: Country specific extension for Hungary
***    IF lv_ccnum IS NOT INITIAL.
***      IF nast-repid IS INITIAL.
***        nast-repid = 1.
***      ELSE.
***        nast-repid = nast-repid + 1.
***      ENDIF.
***      nast-pfld1 = lv_ccnum.
***    ENDIF.
* END: Country specific extension for Hungary
* call smartform invoice
*    CALL FUNCTION lf_fm_name
*      EXPORTING
*        OUTPUT_OPTIONS             = ls_composer_param
*        USER_SETTINGS              = space
*        ls_bil_invoice             = ls_bil_invoice
*      IMPORTING
*        JOB_OUTPUT_INFO            = ls_job_info
*      EXCEPTIONS
*        FORMATTING_ERROR           = 1
*        INTERNAL_ERROR             = 2
*        SEND_ERROR                 = 3
*        USER_CANCELED              = 4
*        OTHERS                     = 5
*              .
*
*      IF sy-subrc <> 0.
**   error handling
*        cf_retcode = sy-subrc.
*        PERFORM protocol_update.
** get SmartForm protocoll and store it in the NAST protocoll
*        PERFORM add_smfrm_prot.
*      ENDIF.
**    ENDDO.
* get SmartForm spoolid and store it in the NAST protocoll
***    DATA ls_spoolid LIKE LINE OF ls_job_info-spoolids.
***    LOOP AT ls_job_info-spoolids INTO ls_spoolid.
***      IF ls_spoolid NE space.
***        PERFORM protocol_update_spool USING '342' ls_spoolid
***                                            space space space.
***      ENDIF.
***    ENDLOOP.
***    ls_composer_param-tdcopies = nast_anzal.
***    IF NOT nast_tdarmod IS INITIAL.
***      nast-tdarmod = nast_tdarmod.
***      CLEAR nast_tdarmod.
***    ENDIF.
***
***  ENDIF.
***
* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.

ENDFORM.                    "PROCESSING
