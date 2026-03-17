*&---------------------------------------------------------------------*
*& Report ZPUT_USE_DATE_CERTIFICATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPUT_USE_DATE_CERTIFICATE.
*CREATED BY SUPRIYA JAGTAP : 102423:20/06/2024
INCLUDE ZPUT_USE_DATE_CERTIFICATE_TOP.
INCLUDE ZPUT_USE_DATE_CERTIFICATE_SS.
INCLUDE ZPUT_USE_DATE_CERTIFICATE_F01.

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM PRINT_SMARTFORMS1.
* end-of-SELECTION.

*  PERFORM PRINT_SMARTFORMS.
*&---------------------------------------------------------------------*
*&      Form  PRINT_SMARTFORMS1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PRINT_SMARTFORMS1 .
* created by supriya: 18:06:2024
  CONSTANTS LC_SFNAME TYPE TDSFNAME VALUE  'ZPUT_DATE_CERTIFICATE'.
  DATA : LV_FM_NAME TYPE RS38L_FNAM .
  DATA : V_MBLNR TYPE MSEG-MBLNR.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME           = LC_SFNAME
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      FM_NAME            = LV_FM_NAME
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*
* CREATE BY SUPRIYA J : 19:06:2024

*    IF v_mblnr NE wa_final-mblnr


*    CALL FUNCTION lv_fm_name                                       "'/1BCDWB/SF00000088'
*      EXPORTING
**       ARCHIVE_INDEX    =
**       ARCHIVE_INDEX_TAB          =
**       ARCHIVE_PARAMETERS         =
**       CONTROL_PARAMETERS         =
**       MAIL_APPL_OBJ    =
**       MAIL_RECIPIENT   =
**       MAIL_SENDER      =
**       OUTPUT_OPTIONS   =
*        user_settings    = 'X'
**        p_ebeln          = wa_final-ebeln
*      IMPORTING
**       DOCUMENT_OUTPUT_INFO       =
*        job_output_info  = gv_job_output
**       JOB_OUTPUT_OPTIONS         =
*      TABLES
*        it_final         = it_final
*      EXCEPTIONS
*        formatting_error = 1
*        internal_error   = 2
*        send_error       = 3
*        user_canceled    = 4
*        OTHERS           = 5.
*    IF sy-subrc <> 0.
**
*    ENDIF.
  DATA: CONTROL_PARAMETERS   TYPE SSFCTRLOP,
*        LS_OUTPUT TYPE SSFCOMPOP.
*       ls_ctrl   TYPE ssfctrlop,
        LS_OUTPUT TYPE SSFCOMPOP.
  data : W_CNT              TYPE I,
        w_cnt2 TYPE i.

*  LS_CTRL-NO_DIALOG = 'X'.    "No popup for every iteration
*  LS_CTRL-PREVIEW   = 'X'.
DESCRIBE TABLE IT_FINAL LINES W_CNT.
  LOOP AT IT_FINAL INTO WA_FINAL.
     W_CNT2 = SY-TABIX .
  IF W_CNT = 1 .
    CONTROL_PARAMETERS-NO_OPEN   = SPACE .
    CONTROL_PARAMETERS-NO_CLOSE  = SPACE .
  ELSE.

    CASE W_CNT2.
      WHEN 1.
        CONTROL_PARAMETERS-NO_OPEN   = SPACE .
        CONTROL_PARAMETERS-NO_CLOSE  = 'X' .
      WHEN W_CNT .
        CONTROL_PARAMETERS-NO_OPEN   = 'X' .
        CONTROL_PARAMETERS-NO_CLOSE  = SPACE .
      WHEN OTHERS.
        CONTROL_PARAMETERS-NO_OPEN   = 'X' .
        CONTROL_PARAMETERS-NO_CLOSE  = 'X' .
    ENDCASE.
  ENDIF.

    CALL FUNCTION LV_FM_NAME "'/1BCDWB/SF00000139'
      EXPORTING
*       ARCHIVE_INDEX      =
*       ARCHIVE_INDEX_TAB  =
*       ARCHIVE_PARAMETERS =
        CONTROL_PARAMETERS = CONTROL_PARAMETERS
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
*       OUTPUT_OPTIONS     =
        USER_SETTINGS      = 'X'
        WA_FINAL2          = WA_FINAL
*     IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO    =
*       JOB_OUTPUT_OPTIONS =
*      TABLES
*        IT_FINAL           = IT_FINAL
      EXCEPTIONS
        FORMATTING_ERROR   = 1
        INTERNAL_ERROR     = 2
        SEND_ERROR         = 3
        USER_CANCELED      = 4
        OTHERS             = 5.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

*    ENDIF.

*    v_mblnr = wa_final-mblnr.

  ENDLOOP.


ENDFORM.
