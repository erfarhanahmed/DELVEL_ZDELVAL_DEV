*MATERIAL *GRUN *ES
DATA: lv_name TYPE thead-tdname.
*DATA: lt_lines TYPE TABLE OF tline.
*      ls_line TYPE tline.
*data : lf TYPE c.
*lf = |\n|.

*data : l_cr(1) type c value cl_abap_char_utilites=>cr_lf.
CLEAR :lv_name,lt_lines,ls_line,gv_note_x.

lv_name = GS_PURCHASING-MATNR.
*BREAK-POINT.
CALL FUNCTION 'READ_TEXT'
EXPORTING
*   CLIENT                  = SY-MANDT
  ID                      = 'GRUN'
  LANGUAGE                = 'S'
  name                    = lv_name
  object                  = 'MATERIAL'
*   ARCHIVE_HANDLE          = 0
*   LOCAL_CAT               = ' '
* IMPORTING
*   HEADER                  =
*   OLD_LINE_COUNTER        =
TABLES
  LINES                   = lt_lines
EXCEPTIONS
  ID                      = 1
  LANGUAGE                = 2
  name                    = 3
  not_found               = 4
  object                  = 5
  reference_check         = 6
  wrong_access_to_archive = 7
  OTHERS                  = 8.
IF sy-subrc <> 0.
* Implement suitable error handling here
ELSE.
*  DESCRIBE TABLE lt_lines.
*  IF sy-tfill <> 0.
*    LOOP AT lt_lines INTO ls_line.
**      CONCATENATE txt wa_text_line-tdline INTO txt SEPARATED BY l_cr.
**      TXT = 'TXT&&lf&&wa_text_line-tdline&&lf'.
*    ENDLOOP.
*  ENDIF.
ENDIF.
















