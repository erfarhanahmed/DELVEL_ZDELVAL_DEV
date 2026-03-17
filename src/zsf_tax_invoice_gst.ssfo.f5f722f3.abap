DATA : LANG TYPE SPRAS,
      objname      TYPE tdobname.

  objname = ls_bil_invoice-hd_gen-bil_number.

LANG = 'E'.

CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'Z026'
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
      READ TABLE it_lines INTO wa_lines INDEX 1.
      IF sy-subrc = 0.
        lr_no = wa_lines-tdline.
      ENDIF.

      READ TABLE it_lines INTO wa_lines INDEX 2.
      IF sy-subrc = 0.
        lr_no1 = wa_lines-tdline.
      ENDIF.

      READ TABLE it_lines INTO wa_lines INDEX 3.
      IF sy-subrc = 0.
        lr_no2 = wa_lines-tdline.
      ENDIF.

      READ TABLE it_lines INTO wa_lines INDEX 4.
      IF sy-subrc = 0.
        lr_no3 = wa_lines-tdline.
      ENDIF.

      READ TABLE it_lines INTO wa_lines INDEX 5.
      IF sy-subrc = 0.
        lr_no4 = wa_lines-tdline.
      ENDIF.

    ENDIF.
  ENDIF.


















