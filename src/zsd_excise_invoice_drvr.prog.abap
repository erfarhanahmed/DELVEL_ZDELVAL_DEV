*&---------------------------------------------------------------------*
*& Report  ZSD_EXCISE_INVOICE_DRVR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZSD_EXCISE_INVOICE_DRVR.

TABLES NAST.
*changes "

FORM ENTRY  USING RETURNCODE
                  US_SCREEN.

  DATA : FM_NAME TYPE RS38L_FNAM,
        V_VBELN TYPE VBRK-VBELN.
*        nast type nast.

  V_VBELN = NAST-OBJKY.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname                 = 'ZSF_TAX_INVOICE'
*     VARIANT                  = ' '
*     DIRECT_CALL              = ' '
   IMPORTING
     FM_NAME                  = FM_NAME
   EXCEPTIONS
     NO_FORM                  = 1
     NO_FUNCTION_MODULE       = 2
     OTHERS                   = 3
            .
  IF sy-subrc <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  CALL FUNCTION FM_NAME
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
*     OUTPUT_OPTIONS             =
*     USER_SETTINGS              = 'X'
     I_VBELN                    = V_VBELN
     i_nast                     = NAST
*   IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
   EXCEPTIONS
     FORMATTING_ERROR           = 1
     INTERNAL_ERROR             = 2
     SEND_ERROR                 = 3
     USER_CANCELED              = 4
     OTHERS                     = 5
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.





ENDFORM.
