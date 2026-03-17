*&---------------------------------------------------------------------*
*& Report ZMM_DELIVERY_NOTE_DRVR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_delivery_note_drvr.

DATA: xscreen(1) TYPE c,
      retco      LIKE sy-subrc.

DATA : lv_year TYPE mseg-mjahr.

DATA : lv_currm TYPE bkpf-monat,
       lv_curry TYPE bkpf-gjahr,
       lv_prevm TYPE bkpf-monat,
       lv_prevy TYPE bkpf-gjahr.
DATA : lv_year1 TYPE bkpf-gjahr.

TABLES nast.

DATA: BEGIN OF nast_key,
        mblnr LIKE mkpf-mblnr,
        mjahr LIKE mkpf-mjahr,
        zeile LIKE mseg-zeile,
      END OF nast_key.
DATA: gs_mkpf TYPE mkpf,
      gs_mseg TYPE mseg.

DATA gv_xblnr TYPE mkpf-xblnr.

FORM entry USING ent_retco ent_screen.
  xscreen = ent_screen.
  CLEAR ent_retco.
  PERFORM get_data USING nast-objky.
  ent_retco = retco.
  PERFORM print_note.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data  USING    objky.

  nast_key = objky.
  CLEAR retco.

  SELECT SINGLE * FROM mkpf
   INTO gs_mkpf
   WHERE mblnr = nast_key-mblnr
     AND mjahr = nast_key-mjahr.

  SELECT SINGLE * FROM mseg
    INTO gs_mseg
    WHERE mblnr = gs_mkpf-mblnr
      AND zeile = nast_key-zeile
      AND mjahr = gs_mkpf-mjahr.

  IF sy-subrc NE 0.
    retco = sy-subrc.
    EXIT.
  ELSE.

    CALL FUNCTION 'GET_CURRENT_YEAR'
      EXPORTING
        bukrs = 'PL01'
        date  = gs_mkpf-budat
      IMPORTING
        currm = lv_currm
        curry = lv_curry
        prevm = lv_prevm
        prevy = lv_prevy.

    IF lv_currm GT 3.

      lv_year1 = lv_curry.

    ELSE.

      lv_year1 = lv_prevy.

    ENDIF.



    IF gs_mkpf-xblnr IS INITIAL.
      CLEAR gv_xblnr.

      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'
          object                  = 'ZMM_DCNO'
*         QUANTITY                = '1'
          subobject               = gs_mseg-werks
          toyear                  = lv_year1
*         IGNORE_BUFFER           = ' '
        IMPORTING
          number                  = gv_xblnr
*         QUANTITY                =
*         RETURNCODE              =
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
        retco = sy-subrc.
        EXIT.
      ELSE.
        UPDATE mkpf SET xblnr = gv_xblnr
          WHERE mblnr = gs_mkpf-mblnr
            AND mjahr = gs_mkpf-mjahr.
      ENDIF.
    ELSE.
      gv_xblnr = gs_mkpf-xblnr.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT_NOTE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_note .

  DATA : lv_fm_name TYPE rs38l_fnam.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZMM_DELIVERY_NOTE'
*    *     VARIANT                  = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = lv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

    CALL FUNCTION lv_fm_name      "'/1BCDWB/SF00000021'
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
*       i_mseg           = gs_mseg
        i_mkpf           = gs_mkpf
        i_xblnr          = gv_xblnr
*   IMPORTING
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
* Implement suitable error handling here
    ENDIF.
  ENDIF.

ENDFORM.
