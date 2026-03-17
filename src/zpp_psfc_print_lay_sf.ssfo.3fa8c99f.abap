DATA: LV_NAME TYPE THEAD-TDNAME.

*DATA: LT_LINES TYPE TABLE OF TLINE.
CLEAR : LV_FLAG.
LV_NAME = header-matnr.
*BREAK-POINT.
CALL FUNCTION 'READ_TEXT'
  EXPORTING
*   CLIENT                        = SY-MANDT
    id                            = 'GRUN'
    language                      = 'E'
    NAME                          = LV_NAME
    OBJECT                        = 'MATERIAL'
*   ARCHIVE_HANDLE                = 0
*   LOCAL_CAT                     = ' '
* IMPORTING
*   HEADER                        =
*   OLD_LINE_COUNTER              =
  TABLES
    lines                         = LT_LINES1
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
data : lv_word type string  VALUE 'OXYGEN CLEANING'.
data : lv_lines2 TYPE string.
data :lv_text1 TYPE string.

LOOP at lt_lines1 INTO lv_lines1.
  lv_lines2 = lv_lines1.

FIND lv_word in lv_lines2.
IF SY-SUBRC = 0.
  LV_FLAG = 1.
ENDIF.
ENDLOOP.
*BREAK-POINT.
  DELETE lt_lines1 WHERE tdline is INITIAL.
  append INITIAL LINE TO lt_lines1.
















































