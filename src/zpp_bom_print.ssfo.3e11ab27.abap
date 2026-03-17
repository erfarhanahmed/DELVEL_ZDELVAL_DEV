DATA: LV_NAME TYPE THEAD-TDNAME.
DATA: LT_LINES TYPE TABLE OF TLINE.
clear gv_note_x.

LV_NAME = WA_STPOX-IDNRK.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
*   CLIENT                        = SY-MANDT
    id                            = 'GRUN'
    language                      = 'S'
    NAME                          = LV_NAME
    OBJECT                        = 'MATERIAL'
*   ARCHIVE_HANDLE                = 0
*   LOCAL_CAT                     = ' '
* IMPORTING
*   HEADER                        =
*   OLD_LINE_COUNTER              =
  TABLES
    lines                         = LT_LINES
 EXCEPTIONS
   ID                            = 1
   LANGUAGE                      = 2
   NAME                          = 3
   NOT_FOUND                     = 4
   OBJECT                        = 5
   REFERENCE_CHECK               = 6
   WRONG_ACCESS_TO_ARCHIVE       = 7
   OTHERS                        = 8
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    GV_NOTE_X = 'X'.
ENDIF.
























