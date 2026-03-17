IF WA_FINAL-MATNR IS NOT INITIAL.

*DATA CLIENT           TYPE SY-MANDT.
DATA ID               TYPE THEAD-TDID.
DATA LANGUAGE         TYPE THEAD-TDSPRAS.
DATA NAME             TYPE THEAD-TDNAME.
DATA OBJECT           TYPE THEAD-TDOBJECT.
DATA :LTEXT TYPE STANDARD TABLE OF TLINE,
          WA_LTEXT TYPE TLINE.

ID = 'GRUN'.
LANGUAGE = 'EN'.
NAME  = WA_FINAL-MATNR.
OBJECT = 'MATERIAL'.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
*   CLIENT                        = SY-MANDT
    ID                            = ID
    LANGUAGE                      = LANGUAGE
    NAME                          = NAME
    OBJECT                        = OBJECT
  TABLES
    LINES                         =  LTEXT
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
IF SY-SUBRC = 0.

 LOOP AT LTEXT INTO WA_LTEXT.
   IF WA_LTEXT-TDLINE IS NOT INITIAL.
     CONCATENATE LV_LTXT WA_LTEXT-TDLINE INTO LV_LTXT SEPARATED BY SPACE.
   ENDIF.
   ENDLOOP.

ENDIF.
ENDIF.



















