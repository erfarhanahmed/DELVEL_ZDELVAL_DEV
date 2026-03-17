*BREAK primus.

DATA: LV_NAME TYPE THEAD-TDNAME.
DATA: LT_LINES TYPE TABLE OF TLINE.
*DATA: Ls_LINES TYPE lt_lines.
clear gv_note_x.

LV_NAME = WA_HDMAT-MATNR.

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

*BREAK PRIMUS.
*READ TABLE lt_lines into ls_lines INDEX 1.

""""""Added By Ganga 04.08.2018
delete lt_lines where tdline is initial.
*BREAK-POINT.
IF lt_lines IS NOT INITIAL.
        LOOP AT  lt_lines INTO ls_lines.
      replace all occurences of '<(>&<)>' in Ls_lines-tdline with '&'.
         condense Ls_lines-tdline .
         SHIFT ls_lines-tdline RIGHT DELETING TRAILING '* '.
*          CONCATENATE  Ls_lines-tdline '' INTO ls_text-lv_lines.
          ls_text-lv_lines = ls_lines-tdline.
*          CONDENSE ls_text-lv_lines .
*           replace all occurences of space in
*           ls_text-lv_lines with ''.
         APPEND ls_text to lt_text.
          CLEAR ls_text.
        ENDLOOP.

ENDIF.
*break primus.

*condense Ls_lines-tdline.

**Ended By Ganga 04.08.2018
