
REPORT zmat_long_text_change_bdc.

TYPES: BEGIN OF ty_itab ,
         matnr(18)    TYPE c,
         mtart(04)    TYPE c,
         werks(04)    TYPE c,
         lmaktx(2500) TYPE c,
         row          TYPE i,
         tsize        TYPE i,
       END OF ty_itab.

TYPES : BEGIN OF ty_text,
           text(600) TYPE  c,
*          text TYPE char255,
        END OF ty_text.

DATA : lt_text TYPE TABLE OF ty_text,
       ls_text TYPE ty_text.

DATA : BEGIN OF i_error OCCURS 0 ,
         matnr     TYPE matnr,
         l_mstring TYPE string,
         msg       TYPE char20,
         ref       TYPE char15,
         time      TYPE char10,
       END OF i_error .

DATA : lv_matnr TYPE mara-matnr,
       lv_mtart TYPE mara-mtart,
       wa_mara  TYPE mara.

DATA: lv_name  TYPE thead-tdname,
      lv_lines TYPE STANDARD TABLE OF tline.

*  Data Declarations - Internal Tables
DATA: i_tab     TYPE STANDARD TABLE OF ty_itab  INITIAL SIZE 0,
      wa        TYPE ty_itab,
      it_exload LIKE zalsmex_tabline  OCCURS 0 WITH HEADER LINE.

DATA: size TYPE i.

DATA: it_lines       LIKE STANDARD TABLE OF tline WITH HEADER LINE,
      it_text_header LIKE STANDARD TABLE OF thead WITH HEADER LINE,
      p_error        TYPE  sy-lisel,
      len            TYPE i.

DATA:gt_fldcat  TYPE STANDARD TABLE OF slis_fieldcat_alv,
     gwa_fldcat TYPE slis_fieldcat_alv.

*    Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-002.
PARAMETERS:pfile TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

*SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
*PARAMETERS P_DOWN AS CHECKBOX DEFAULT 'X'.
*PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT 'E:\delval\temp\item_master'.
*SELECTION-SCREEN END OF BLOCK B2.

AT SELECTION-SCREEN.
  IF pfile IS INITIAL.
    MESSAGE s368(00) WITH 'Please input filename'. STOP.
  ENDIF.

AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-name EQ 'P_DOWN'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*
*    IF screen-name EQ 'P_FOLDER'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.

START-OF-SELECTION.

  REFRESH:i_tab.

  PERFORM excel_data_int_table.
  PERFORM excel_to_int.
  PERFORM error_log .
  PERFORM error_display.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pfile.
  PERFORM f4_filename.
*&---------------------------------------------------------------------*
*&      Form  F4_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_filename .

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = pfile.
ENDFORM.                    " F4_FILENAME
*&---------------------------------------------------------------------*
*&      Form  EXCEL_DATA_INT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM excel_data_int_table .

  CALL FUNCTION 'ZALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename    = pfile
      i_begin_col = '0001'
      i_begin_row = '0002'
      i_end_col   = '0004'
      i_end_row   = '0501'                                   "65536
    TABLES
      intern      = it_exload.

ENDFORM.                    " EXCEL_DATA_INT_TABLE
*&---------------------------------------------------------------------*
*&      Form  EXCEL_TO_INT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM excel_to_int .

  LOOP AT it_exload .
    CASE  it_exload-col.
      WHEN '0001'.
        wa-matnr   = it_exload-value.
      WHEN '0002'.
        wa-mtart   = it_exload-value.
      WHEN '0003'.
        wa-werks   = it_exload-value.
      WHEN '0004'.
        wa-lmaktx   = it_exload-value.
    ENDCASE.
    AT END OF row.
      wa-tsize = strlen( wa-lmaktx ) .
      wa-row = it_exload-row .
      APPEND wa TO i_tab.
      CLEAR wa .
    ENDAT.
  ENDLOOP.

  LOOP AT i_tab INTO wa.

    SELECT SINGLE matnr FROM mara INTO lv_matnr
        WHERE matnr = wa-matnr.

  IF sy-subrc = 0.

*    SELECT SINGLE * FROM mara INTO wa_mara
*      WHERE matnr = wa-matnr AND mtart = wa-mtart.

    CLEAR: lv_lines,lv_name.
    REFRESH lv_lines.

    lv_name = wa-matnr.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = 'E' "sy-langu"S'
        name                    = lv_name
        object                  = 'MATERIAL'
      TABLES
        lines                   = lv_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    IF lv_lines IS NOT INITIAL.
*    IF lv_lines IS INITIAL.

      SPLIT wa-lmaktx AT cl_abap_char_utilities=>newline INTO TABLE lt_text .

      it_text_header-tdid     = 'GRUN'.
      it_text_header-tdspras  = 'E'."'S' .
      it_text_header-tdname   = wa-matnr.
      it_text_header-tdobject = 'MATERIAL'.

      LOOP AT lt_text INTO ls_text.
**************ADDED BY JYOTI ON 12.02.2025************
         DATA LEN TYPE I.
         LEN = STRLEN( ls_text-text ).
        MOVE '*' TO it_lines-tdformat.
        MOVE  ls_text-text TO it_lines-tdline .
        SHIFT it_lines-tdline LEFT DELETING LEADING ' '.

        SHIFT it_lines-tdline LEFT DELETING LEADING ' " '.
        SHIFT it_lines-tdline RIGHT DELETING TRAILING ' " '.
        CONDENSE it_lines-tdline.

        APPEND it_lines.
        CLEAR it_lines .

********************aDDED BY JYOTI ON 12.02.2025*********************
         IF LEN >= '132'.
        MOVE  ls_text-text+132 TO it_lines-tdline .
*        MOVE  ls_text-text+392 TO it_lines-tdline .
        SHIFT it_lines-tdline LEFT DELETING LEADING ' '.

        SHIFT it_lines-tdline LEFT DELETING LEADING ' " '.
        SHIFT it_lines-tdline RIGHT DELETING TRAILING ' " '.
        CONDENSE it_lines-tdline.

        APPEND it_lines.
        CLEAR it_lines .

        MOVE  ls_text-text+264 TO it_lines-tdline .
        SHIFT it_lines-tdline LEFT DELETING LEADING ' '.

        SHIFT it_lines-tdline LEFT DELETING LEADING ' " '.
        SHIFT it_lines-tdline RIGHT DELETING TRAILING ' " '.
        CONDENSE it_lines-tdline.

        APPEND it_lines.
        CLEAR it_lines .
        ENDIF.


      ENDLOOP.

      CALL FUNCTION 'SAVE_TEXT'
        EXPORTING
          client          = sy-mandt
          header          = it_text_header
          insert          = ' '
          savemode_direct = 'X'
        TABLES
          lines           = it_lines
        EXCEPTIONS
          id              = 1
          language        = 2
          name            = 3
          object          = 4
          OTHERS          = 5.

      IF SY-SUBRC = 0.
         MOVE wa-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material Changed'.
           i_error-msg       = 'Changed'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.

                 APPEND i_error .
           CLEAR i_error.

      ENDIF.

    ENDIF.

  ELSE.
          MOVE wa-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material Not Changed'.
           i_error-msg       = 'Error'.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.

           APPEND i_error .
           CLEAR i_error.

  ENDIF.

  REFRESH it_lines.

  ENDLOOP.

*  IF sy-subrc = 0.
*    WRITE:/ ' Material Changed Successfully'.
*  ENDIF.

ENDFORM.                    " EXCEL_TO_INT

*&---------------------------------------------------------------------*
*&      Form  ERROR_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ERROR_LOG .
REFRESH: gt_fldcat.

  gwa_fldcat-COL_POS    = '1'.
  gwa_fldcat-fieldname  = 'MATNR'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Material'.
  gwa_fldcat-seltext_m  = 'Material'.
  gwa_fldcat-seltext_s  = 'Material'.
  gwa_fldcat-outputlen  = '000018'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.
  gwa_fldcat-COL_POS    = '2'.
  gwa_fldcat-fieldname  = 'L_MSTRING'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = ' Message'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000030'.
  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.

  gwa_fldcat-COL_POS    = '3'.
  gwa_fldcat-fieldname  = 'MSG'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Status'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000020'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.

  gwa_fldcat-COL_POS    = '4'.
  gwa_fldcat-fieldname  = 'REF'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Refresh Date'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000020'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.

  gwa_fldcat-COL_POS    = '5'.
  gwa_fldcat-fieldname  = 'TIME'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Time'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000010'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ERROR_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ERROR_DISPLAY .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     is_layout   = gwa_layout_col
      I_CALLBACK_PROGRAM = SY-REPID
      it_fieldcat = gt_fldcat
    TABLES
      t_outtab    = i_error.

*IF P_DOWN = 'X'.
*  PERFORM download.
* ENDIF.

ENDFORM.
