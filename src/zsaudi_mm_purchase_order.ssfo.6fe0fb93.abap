
*PERFORM get_text USING OBJNAME 'VBBP' 'Z888' 'E' CHANGING WA_ITEM-ADTXT.



*form get_text USING OBJNAME TYPE TDOBNAME
*                    OBJ_TYP
*                    TXT_ID
*                    LANG TYPE SPRAS
*              CHANGING TXT.

*  DATA :  TEXT_LINES1   TYPE TABLE OF TLINE,
*          WA_TEXT_LINE1 TYPE          TLINE,
    DATA:      OBJNAME       TYPE          TDOBNAME.
*          TXT1           TYPE          STRING.

  OBJNAME = WA_ITEM-MATNR.

*  IF LANG IS INITIAL.
*    LANG = 'E'.
*  ENDIF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'GRUN'
      language                      = 'E'
      name                          = OBJNAME
      object                        = 'MATERIAL'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = TEXT_LINES1
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
**
**  IF sy-subrc <> 0.
***   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  ELSE.
***    DESCRIBE TABLE TEXT_LINES1.
***    IF SY-TFILL <> 0.
***      LOOP AT TEXT_LINES1 INTO WA_TEXT_LINE1.
***        CONCATENATE TXT1 WA_TEXT_LINE1-TDLINE INTO TXT1 SEPARATED BY SPACE.
***      ENDLOOP.
***    ENDIF.
**  ENDIF.
***  BREAK KANKIT.
***ENDFORM.
















