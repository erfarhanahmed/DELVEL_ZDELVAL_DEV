*&---------------------------------------------------------------------*
*& REPORT  ZSD_PENDINGFORMS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zsd_pendingforms.

DATA : tmp_vbeln TYPE vbeln.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_kunnr  TYPE kunnr OBLIGATORY,
             p_frmtyp TYPE taxk1.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN.
  IF p_frmtyp IS INITIAL.
    p_frmtyp = 'C'.
  ENDIF.
*  IF P_KUNNR IS INITIAL.
*    MESSAGE 'Plz provide some valid input.' TYPE 'E'.
*  ENDIF.

START-OF-SELECTION.
  SELECT SINGLE vbeln
       FROM vbrk
       INTO tmp_vbeln
       WHERE kunag = p_kunnr AND taxk1 = p_frmtyp.

  IF sy-subrc = 0.
    PERFORM generate_form USING p_kunnr.
  ELSE.
    MESSAGE 'No pending forms for this selection criteria.' TYPE 'I'.
    LEAVE TO CURRENT TRANSACTION.
  ENDIF.

******************************************************
*                    SUBROUTINES                     *
******************************************************
FORM generate_form USING p_kunnr TYPE kunnr.
  DATA fm_name TYPE rs38l_fnam.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSD_PNDNG_FRMS'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CALL FUNCTION fm_name    "/1BCDWB/SF00000065
      EXPORTING
*       ARCHIVE_INDEX    =
*       ARCHIVE_INDEX_TAB          =
*       ARCHIVE_PARAMETERS         =
*       CONTROL_PARAMETERS         =
*       MAIL_APPL_OBJ    =
*       MAIL_RECIPIENT   =
*       MAIL_SENDER      =
*       OUTPUT_OPTIONS   =
*       USER_SETTINGS    = 'X'
        p_kunnr          = p_kunnr
        p_taxk1          = p_frmtyp
*    IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO  =
*       JOB_OUTPUT_OPTIONS         =
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.
