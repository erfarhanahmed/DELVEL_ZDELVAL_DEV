BREAK FUJIABAP.
I_ID = 'GRUN'.
I_LANGUAGE = SY-LANGU.
I_NAME = WA_item-MATNR.
I_OBJECT = 'MATERIAL'.


CALL FUNCTION 'READ_TEXT'
  EXPORTING
    ID                      = I_ID
    LANGUAGE                = I_LANGUAGE
    NAME                    = I_NAME
    OBJECT                  = I_OBJECT
  IMPORTING
    HEADER                  = I_HEADER
  TABLES
    LINES                   = I_LINES
  EXCEPTIONS
    ID                      = 1
    LANGUAGE                = 2
    NAME                    = 3
    NOT_FOUND               = 4
    OBJECT                  = 5
    REFERENCE_CHECK         = 6
    WRONG_ACCESS_TO_ARCHIVE = 7
    OTHERS                  = 8.


READ TABLE I_LINES INTO WA_LINES INDEX 1.












































