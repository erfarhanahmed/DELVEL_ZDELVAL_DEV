*&---------------------------------------------------------------------*
*& Report ZUPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zupload.


types : begin of ty_itab,
        mandt(003) type c,
        brand(003) TYPE c,
        ser_code(003) type c,
        ernam(12) type c,
        erdat(8) type c,
        short_text(40) type c,
        long_text(100) type c,
        end of ty_itab.

DATA : it_itab TYPE TABLE OF ty_itab,
       wa_itab TYPE ty_itab.

DATA : filename TYPE string.
DATA : lv_fname TYPE localfile.
DATA : it_excel TYPE TABLE OF alsmex_tabline.
DATA : wa_excel TYPE alsmex_tabline.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_file TYPE localfile OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.

  lv_fname = p_file.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_fname
      i_begin_col             = '1'
      i_begin_row             = '2'
      i_end_col               = '7'
      i_end_row               = '9999'
    TABLES
      intern                  = it_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* Format the data to the internal table
  LOOP AT it_excel INTO wa_excel.
    AT NEW row.
      CLEAR: wa_itab.
    ENDAT.
    CASE wa_excel-col.
      WHEN '0003'. wa_itab-ser_code = wa_excel-value.
      WHEN '0002'. wa_itab-brand = wa_excel-value.

    ENDCASE.
    AT END OF row.
      APPEND wa_itab TO it_itab.
    ENDAT.
  ENDLOOP.



  LOOP AT it_itab INTO wa_itab.

    MODIFY zmseries FROM wa_itab.

  ENDLOOP.
