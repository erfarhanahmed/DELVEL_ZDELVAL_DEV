
DATA: CID(4) TYPE C.

DATA : TNAME LIKE THEAD-TDNAME.

TNAME = XEKKO-EBELN.
CALL FUNCTION 'READ_TEXT'
       EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'F14'
          LANGUAGE                = 'E'
          NAME                    = TNAME
          OBJECT                  = 'EKKO'
*         ARCHIVE_HANDLE          = 0
     TABLES
          LINES                   = IT_TEXT
     EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
*LOOP AT IT_TEXT INTO WA_TEXT.

IF SY-SUBRC EQ 0.

  ENDIF.







