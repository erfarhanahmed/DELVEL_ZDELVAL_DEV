*DATA :  TEXT_LINES TYPE TABLE OF TLINE,
*        WA_TEXT_LINE TYPE TLINE,
*        OBJNAME TYPE TDOBNAME.
*OBJNAME = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
*
*CALL FUNCTION 'READ_TEXT'
*    EXPORTING
**     CLIENT                        = SY-MANDT
*      id                            = 'Z014'
*      language                      = 'E'
*      name                          = OBJNAME
*      object                        = 'VBBK'
**     ARCHIVE_HANDLE                = 0
**     LOCAL_CAT                     = ' '
**   IMPORTING
**     HEADER                        =
*    TABLES
*      LINES                         = TEXT_LINES
*   EXCEPTIONS
*     ID                            = 1
*     LANGUAGE                      = 2
*     NAME                          = 3
*     NOT_FOUND                     = 4
*     OBJECT                        = 5
*     REFERENCE_CHECK               = 6
*     WRONG_ACCESS_TO_ARCHIVE       = 7
*     OTHERS                        = 8
*     .
**IF sy-subrc <> 0.
**  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**ELSE.
*  DESCRIBE TABLE TEXT_LINES.
*  IF SY-TFILL <> 0.
*    LOOP AT TEXT_LINES INTO WA_TEXT_LINE.
*      CONCATENATE TXT WA_TEXT_LINE-TDLINE INTO TXT.
*    ENDLOOP.
*  ENDIF.
**ENDIF.
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
