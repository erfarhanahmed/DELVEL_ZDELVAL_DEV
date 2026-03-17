*&---------------------------------------------------------------------*
*& Report ZPP_BOM_PRINT_DRVR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpp_bom_print_drvr.

DATA : fm_name TYPE rs38l_fnam.

*>>
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_matnr TYPE mara-matnr OBLIGATORY,
             p_werks TYPE marc-werks OBLIGATORY DEFAULT 'PL01',
             p_stlan TYPE stzu-stlan OBLIGATORY DEFAULT 1,
             p_valdt TYPE sy-datum DEFAULT sy-datum.
PARAMETERS : P_RAD1 RADIOBUTTON GROUP RAD,             "added by Ganga
             P_RAD2 RADIOBUTTON GROUP RAD.             "added by Ganga

SELECTION-SCREEN END OF BLOCK b1.

DATA : LV_INDICATOR TYPE CHAR1.                       "added by Ganga

IF P_RAD1 = 'X'.
  LV_INDICATOR = 'S'.                                       "added by ganga
  ELSE.
    LV_INDICATOR = 'M'.
    ENDIF.
*>>
AT SELECTION-SCREEN.
  SELECT SINGLE
    matnr
    FROM marc
    INTO p_matnr
    WHERE matnr = p_matnr
      AND werks = p_werks.
  IF sy-subrc <> 0.
    MESSAGE 'Invalid input data.' TYPE 'E'.
    EXIT.
  ENDIF.

*>>
START-OF-SELECTION.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZPP_BOM_PRINT'
*    *     VARIANT                  = ' '
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
    CALL FUNCTION fm_name
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
        p_matnr          = p_matnr
        p_werks          = p_werks
        p_validity_dt    = p_valdt
        p_stlan          = p_stlan
        GV_INDICATOR     = LV_INDICATOR
*     IMPORTING
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
