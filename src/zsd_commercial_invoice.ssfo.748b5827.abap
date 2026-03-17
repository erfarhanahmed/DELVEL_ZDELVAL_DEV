DATA : LANG TYPE SPRAS,
      objname      TYPE tdobname.

  objname = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.

LANG = 'E'.

CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'Z026'
*      id                            = 'Z012'
      language                      = LANG
      name                          = OBJNAME
      object                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = IT_LINES
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
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
*    DESCRIBE TABLE TEXT_LINES.
*    IF SY-TFILL <> 0.

    IF IT_LINES IS NOT INITIAL.
      LOOP AT it_lines INTO wa_lines.
       IF WA_LINES-TDLINE IS NOT INITIAL.
         CONCATENATE LR_NO WA_LINES-TDLINE INTO LR_NO SEPARATED BY space.
       ENDIF.

      ENDLOOP.
      CONDENSE lr_no.
    ENDIF.
ENDIF.

CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
*      id                            = 'Z026'
      id                            = 'Z012'
      language                      = LANG
      name                          = OBJNAME
      object                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = IT_LINES1
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
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
*    DESCRIBE TABLE TEXT_LINES.
*    IF SY-TFILL <> 0.

    IF IT_LINES1 IS NOT INITIAL.
      LOOP AT it_lines1 INTO wa_lines1.
       IF WA_LINES1-TDLINE IS NOT INITIAL.
         CONCATENATE LR_NO WA_LINES1-TDLINE INTO LR_NO SEPARATED BY space.
       ENDIF.

      ENDLOOP.
      CONDENSE lr_no.
    ENDIF.
ENDIF.
