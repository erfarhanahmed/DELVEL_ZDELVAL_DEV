*----------------------------------------------------------------------*
***INCLUDE ZSD_REP_TECHNICAL_REVIEW_PRF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  PRINT_TR_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PRINT_TR_FORM .
  data : l_fm type RS38L_FNAM.
  DATA: CONTROL_PARAMETERS TYPE SSFCTRLOP,
        output type SSFCOMPOP.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME                 = 'ZSD_SF_TECH_REVIEW'
*     VARIANT                  = ' '
*     DIRECT_CALL              = ' '
   IMPORTING
     FM_NAME                  = l_fm
   EXCEPTIONS
     NO_FORM                  = 1
     NO_FUNCTION_MODULE       = 2
     OTHERS                   = 3
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CONTROL_PARAMETERS-NO_DIALOG = 'X'.
  CONTROL_PARAMETERS-preview = 'X'.
  output-TDDEST = 'LOCL'.
*  output-TDNOPREV = 'X'.
  CALL FUNCTION L_FM
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
     CONTROL_PARAMETERS         = CONTROL_PARAMETERS
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
      OUTPUT_OPTIONS             = output
*     USER_SETTINGS              = 'X'
*   IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
    tables
      LT_ZTECH_REVIEW            = LT_ZTECH_REVIEW[]

   EXCEPTIONS
     FORMATTING_ERROR           = 1
     INTERNAL_ERROR             = 2
     SEND_ERROR                 = 3
     USER_CANCELED              = 4
     OTHERS                     = 5
            .
  IF sy-subrc <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



ENDFORM.                    " PRINT_TR_FORM
*&---------------------------------------------------------------------*
*&      Form  PRINT_CR_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PRINT_CR_FORM .
  data : l_fm type RS38L_FNAM.
  DATA: CONTROL_PARAMETERS TYPE SSFCTRLOP,
        output type SSFCOMPOP.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME                 = 'ZSD_SF_COMM_REVIEW'
*     VARIANT                  = ' '
*     DIRECT_CALL              = ' '
   IMPORTING
     FM_NAME                  = l_fm
   EXCEPTIONS
     NO_FORM                  = 1
     NO_FUNCTION_MODULE       = 2
     OTHERS                   = 3
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CONTROL_PARAMETERS-NO_DIALOG = 'X'.
  CONTROL_PARAMETERS-preview = 'X'.
  output-TDDEST = 'LOCL'.
*  output-TDNOPREV = 'X'.
  CALL FUNCTION L_FM
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
     CONTROL_PARAMETERS         = CONTROL_PARAMETERS
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
      OUTPUT_OPTIONS             = output
*     USER_SETTINGS              = 'X'
*   IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
    tables
      LT_ZCOMM_REVIEW            = LT_ZCOMM_REVIEW[]

   EXCEPTIONS
     FORMATTING_ERROR           = 1
     INTERNAL_ERROR             = 2
     SEND_ERROR                 = 3
     USER_CANCELED              = 4
     OTHERS                     = 5
            .
  IF sy-subrc <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " PRINT_CR_FORM
