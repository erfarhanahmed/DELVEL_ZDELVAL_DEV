FORM get_text USING objname TYPE tdobname
      obj_typ
      txt_id
      lang TYPE spras
CHANGING txt.

  DATA : text_lines   TYPE TABLE OF tline,
        wa_text_line TYPE tline.

  IF lang IS INITIAL.
    lang = 'E'.
  ENDIF.

  CALL FUNCTION 'READ_TEXT'
  EXPORTING
*     CLIENT                  = SY-MANDT
    ID                      = txt_id
    LANGUAGE                = lang
    name                    = objname
    object                  = obj_typ
*     ARCHIVE_HANDLE          = 0
*     LOCAL_CAT               = ' '
*   IMPORTING
*     HEADER                  =
  TABLES
    LINES                   = text_lines
  EXCEPTIONS
    ID                      = 1
    LANGUAGE                = 2
    name                    = 3
    not_found               = 4
    object                  = 5
    reference_check         = 6
    wrong_access_to_archive = 7
    OTHERS                  = 8.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    DESCRIBE TABLE text_lines.
    IF sy-tfill <> 0.
      LOOP AT text_lines INTO wa_text_line.
        CONCATENATE txt wa_text_line-tdline INTO txt.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
























