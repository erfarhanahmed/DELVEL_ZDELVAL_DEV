
DATA lv_tdname TYPE thead-tdname.
DATA lt_lins   TYPE TABLE OF tline.

lv_tdname = gs_mseg-matnr.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
*   CLIENT                  = SY-MANDT
    id                      = 'GRUN'
    language                = sy-langu
    name                    = lv_tdname
    object                  = 'MATERIAL'
*   ARCHIVE_HANDLE          = 0
*   LOCAL_CAT               = ' '
* IMPORTING
*   HEADER                  =
*   OLD_LINE_COUNTER        =
  TABLES
    lines                   = lt_lins
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
  CLEAR gv_long_exist.
* Implement suitable error handling here
ELSE.
  gv_long_exist = 'X'.

ENDIF.





















