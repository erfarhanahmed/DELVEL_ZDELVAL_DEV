*BREAK-POINT.
IF GS_PURCHASING-EBELN IS NOT INITIAL.

  SELECT SINGLE LIFNR
         FROM EKKO
         INTO WA_LIFNR
         WHERE EBELN  = GS_PURCHASING-EBELN.

*DATA CLIENT           TYPE SY-MANDT.
  DATA ID               TYPE THEAD-TDID.
  DATA LANGUAGE         TYPE THEAD-TDSPRAS.
  DATA NAME             TYPE THEAD-TDNAME.
  DATA OBJECT           TYPE THEAD-TDOBJECT.

  DATA: LINES    TYPE TABLE OF TLINE,
        WA_LINES TYPE TLINE.

  ID = 'F14'.
  LANGUAGE = 'EN' .
  NAME  = GS_PURCHASING-EBELN.
  OBJECT  = 'EKKO'.
*BREAK primus.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*     CLIENT                        = SY-MANDT
        ID                            = ID
        LANGUAGE                      = LANGUAGE
        NAME                          = NAME
        OBJECT                        = OBJECT
      TABLES
        LINES                         = LINES
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

LOOP AT LINES INTO WA_LINES.
  CASE SY-TABIX.
    WHEN '1'.
    LV_NAME1    =  WA_LINES-TDLINE.
    WHEN '2'.
    LV_STREET1 =  WA_LINES-TDLINE.
    WHEN '3'.
    LV_CITY = WA_LINES-TDLINE.
    WHEN '4'.
    LV_COUNT = WA_LINES-TDLINE.
    WHEN '5'.
    LV_VAT01 = WA_LINES-TDLINE.
    WHEN '6'.
    LV_CONTP = WA_LINES-TDLINE.
    WHEN '7'.
    LV_CONTN = WA_LINES-TDLINE..
  ENDCASE.







  ENDLOOP.

  ENDIF.


ENDIF.


**
**  SELECT FROM mseg as a INNER JOIN lfa1 as b
**              on a~lifnr eq b~LIFNR
**    FIELDS b~NAME1,b~Street
**      WHERE mblnr in S_MBLNR
**      INTO TABLE @data(it_to).








