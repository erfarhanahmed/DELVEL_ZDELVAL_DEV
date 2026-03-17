*MATERIAL *GRUN *ES
DATA: lv_name TYPE thead-tdname.
DATA: lt_lines TYPE TABLE OF tline.
CLEAR gv_note_x.

lv_name = wa_item-matnr.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
*   CLIENT                  = SY-MANDT
    id                      = 'GRUN'
    language                = 'S'
    name                    = lv_name
    object                  = 'MATERIAL'
*   ARCHIVE_HANDLE          = 0
*   LOCAL_CAT               = ' '
* IMPORTING
*   HEADER                  =
*   OLD_LINE_COUNTER        =
  TABLES
    lines                   = lt_lines
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
* Implement suitable error handling here
ELSE.
  gv_note_x = 'X'.
ENDIF.















































