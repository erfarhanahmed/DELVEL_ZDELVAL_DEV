

READ TABLE it_final INTO wa_final INDEX 1.


DATA:lv_clint   LIKE sy-mandt,
  lv_id      LIKE thead-tdid,
  lv_lang    LIKE thead-tdspras,
  lv_name    LIKE thead-tdname,
  lv_object  LIKE thead-tdobject.
*  LV_BUDAT   TYPE BUDAT.

lv_clint = sy-mandt.
lv_lang = 'EN'.
lv_id = 'QAVE'.
lv_object = 'QPRUEFLOS'.

*BREAK PRIMUS.

IF WA_cpudt IS NOT INITIAL.
  lv_BUDAT = WA_cpudt.
  ELSE.
  lv_BUDAT = SY-DATUM.
ENDIF.

CONCATENATE lv_clint wa_final-prueflos 'L' INTO lv_name.

CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = lv_clint
        id                      = lv_id
        language                = lv_lang
        name                    = lv_name
        object                  = lv_object
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*   IMPORTING
*       HEADER                  =
      TABLES
        lines                   = it_line[]
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.







