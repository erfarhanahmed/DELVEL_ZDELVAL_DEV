*&---------------------------------------------------------------------*
*& Report ZMM_UPLD_MAT_400C_TXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_upld_mat_400c_txt.


TYPE-POOLS: slis.

*Data Declaration
*&--- Type for file upload
TYPES : BEGIN OF t_file,
          matnr     TYPE matnr,       "1 Material code
          fld2      TYPE c,
          text_line TYPE text8192,   "string,      "2 Long text
        END OF t_file .

DATA:
  i_file  TYPE TABLE OF t_file,
  wa_file TYPE t_file,
  vv_file TYPE ibipparms-path.

**DATA : it_excel TYPE TABLE OF zalsmex_tabline.
**DATA : wa_excel TYPE zalsmex_tabline.

*>>
SELECTION-SCREEN BEGIN OF BLOCK blk6 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK blk6 .


*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = vv_file.
  p_file = vv_file .

*>>
START-OF-SELECTION.
  PERFORM read_file.
*  PERFORM get_data_fore.
  PERFORM write_text.

*&---------------------------------------------------------------------*
*&      Form  WRITE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_text .

  DATA : it_header  TYPE TABLE OF thead WITH HEADER LINE,
         it_line    TYPE TABLE OF tline WITH HEADER LINE,
         l_name(70).

  TYPES: BEGIN OF ty_split,
           tdline TYPE tline-tdline,
         END OF ty_split.
  DATA: lt_split TYPE TABLE OF ty_split,
        ls_split TYPE ty_split,
        ls_mara  TYPE mara.


  LOOP AT i_file INTO wa_file.

    MOVE  wa_file-matnr TO l_name.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = l_name
      IMPORTING
        output = l_name.

    SELECT SINGLE * FROM mara INTO ls_mara
      WHERE matnr = l_name.

    IF sy-subrc NE 0.
      WRITE : / wa_file-matnr, 'Material code NOT available'.

    ELSE.

      REFRESH: lt_split, it_line.
*      SPLIT wa_file-text_line AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_split IN CHARACTER MODE.
*      SPLIT wa_file-text_line AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_split IN CHARACTER MODE.
      SPLIT wa_file-text_line AT '~' INTO TABLE lt_split IN CHARACTER MODE.
*cl_abap_char_utilities=>cr_lf      NEWLINE
      LOOP AT lt_split INTO ls_split.

        it_line-tdformat = '*'.    "'ST'.
        it_line-tdline = ls_split-tdline.   "wa_file-text_line.
        APPEND it_line.
        CLEAR it_line.
      ENDLOOP.
*    READ TABLE it_header.
*    READ TABLE it_line.

      CALL FUNCTION 'CREATE_TEXT'
        EXPORTING
          fid         = 'GRUN' "L_ID
          flanguage   = 'S'     "sy-langu
          fname       = l_name
          fobject     = 'MATERIAL' "W_OBJECT
          save_direct = 'X'
*         FFORMAT     = '*'
        TABLES
          flines      = it_line
        EXCEPTIONS
          no_init     = 1
          no_save     = 2
          OTHERS      = 3.


      WRITE : / wa_file-matnr, 'Note updated ....'.

    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_file .

  DATA lv_filename       TYPE string.

  lv_filename = p_file.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_filename
      filetype                = 'ASC'
      has_field_separator     = 'X'
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
*   IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      data_tab                = i_file
*   CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
