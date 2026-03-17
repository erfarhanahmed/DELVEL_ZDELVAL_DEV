*&---------------------------------------------------------------------*
*& Report ZMM_UPLOAD_MAT_400C_TXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_upload_mat_400c_txt.


TYPE-POOLS: slis.

*Data Declaration
*&--- Type for file upload
TYPES : BEGIN OF t_file,
          matnr     TYPE matnr,       "1 Material code
          text_line TYPE string,      "2 Long text
        END OF t_file .

DATA:
  i_file  TYPE TABLE OF t_file,
  wa_file TYPE t_file,
  vv_file TYPE ibipparms-path.

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
  PERFORM get_data_fore.
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
      SPLIT wa_file-text_line AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_split IN CHARACTER MODE.
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
*&      Form  GET_DATA_FORE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_fore .
  DATA:
    vv_file TYPE ibipparms-path,
    v_str   TYPE string,
    v_bool  TYPE c,
    v_pstat TYPE pstat_d.

  TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.

  DATA : rawdata TYPE truxs_t_text_data.

*Read the upload file
  v_str = p_file .
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = v_str
    RECEIVING
      result = v_bool.

  IF v_bool IS NOT INITIAL .
*    v_file_up = p_file .
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
*       I_LINE_HEADER        =
        i_tab_raw_data       = rawdata
        i_filename           = p_file
      TABLES
        i_tab_converted_data = i_file
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
ENDFORM.
