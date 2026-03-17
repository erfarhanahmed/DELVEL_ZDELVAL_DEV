DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE.



CLEAR: LV_LINES, LV_NAME,GV_ENG.
REFRESH LV_LINES.

*BREAK-POINT.
*CONCATENATE WA_VEPO- INTO lv_name.

lv_name = V_MATNR1.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
    CLIENT                  = SY-MANDT
    ID                      = 'GRUN'
    LANGUAGE                = 'E' "'S'
    NAME                    = LV_NAME
    OBJECT                  = 'MATERIAL'
  TABLES
    LINES                   = LV_LINES
  EXCEPTIONS
    ID                      = 1
    LANGUAGE                = 2
    NAME                    = 3
    NOT_FOUND               = 4
    OBJECT                  = 5
    REFERENCE_CHECK         = 6
    WRONG_ACCESS_TO_ARCHIVE = 7
    OTHERS                  = 8.
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
IF NOT LV_LINES IS INITIAL.
  LOOP AT LV_LINES INTO WA_LINES.
    IF NOT WA_LINES-TDLINE IS INITIAL.
      CONCATENATE GV_ENG WA_LINES-TDLINE INTO GV_ENG SEPARATED BY SPACE.
    ENDIF.
  ENDLOOP.
  CONDENSE GV_ENG.
ENDIF.

if GV_ENG is INITIAL.
 gv_maktx = wa_makt1-maktx.
ENDIF.















