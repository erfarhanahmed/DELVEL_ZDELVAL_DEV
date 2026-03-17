DATA: LV_NAME TYPE THEAD-TDNAME.
*DATA: LT_LINES TYPE TABLE OF TLINE.
clear gv_note_x.

LV_NAME = header-matnr.

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
    data : lv_word type string VALUE 'OXYGEN CLEANING'.
DATA : LV_LINES2 TYPE STRING.
LOOP at lt_lines INTO lv_lines1.
  lv_lines2 = lv_lines1.

FIND lv_word in lv_lines2.
IF SY-SUBRC = 0.
  LV_FLAG1 = 1.
ENDIF.
ENDLOOP.

if lv_flag1 ne 1.
    GV_NOTE_X = 'X'.
refresh lt_lines.
else.
  DELETE lt_lines WHERE tdline is INITIAL.
  append INITIAL LINE TO lt_lines.
ENDIF.
endif.














