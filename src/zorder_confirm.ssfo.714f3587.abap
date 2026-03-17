*data : lt_tline  TYPE TABLE OF tline,
*       ls_tline  TYPE tline.

*DATA : name TYPE THEAD-TDNAME,
*        LANGUAGE TYPE THEAD-TDSPRAS.

*BREAK-POINT.
name = lv_vbeln.


CALL FUNCTION 'READ_TEXT'
    EXPORTING
     CLIENT                        = SY-MANDT
      id                            = 'Z101'
      language                      =  'E' "sy-langu
      NAME                          = NAME
      OBJECT                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =  LV_HEADER
*     OLD_LINE_COUNTER              =
    TABLES
      lines                         = lt_tline
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
** Implement suitable error handling here
    ENDIF.


*     if lt_tline is INITIAL.
     LOOP AT lt_tline INTO ls_tline.
      if gv_vtext IS INITIAL.
*         wa_final-vtext = ls_tline-tdline.
        gv_vtext = ls_tline-tdline.
        else.

       CONCATENATE gv_vtext ls_tline-tdline
        INTO gv_vtext SEPARATED BY space.
*     gv_vtext = ls_tline-tdline.
     endif.
     endloop.

      refresh lt_tline.

name = lv_vbeln.


CALL FUNCTION 'READ_TEXT'
    EXPORTING
     CLIENT                        = SY-MANDT
      id                            = 'Z039'
      language                      =  'E' "sy-langu
      NAME                          = NAME
      OBJECT                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =  LV_HEADER
*     OLD_LINE_COUNTER              =
    TABLES
      lines                         = lt_tline
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
** Implement suitable error handling here
    ENDIF.


*     if lt_tline is INITIAL.
     LOOP AT lt_tline INTO ls_tline.
      if gv_tag_req IS INITIAL.
*         wa_final-vtext = ls_tline-tdline.
        gv_tag_req = ls_tline-tdline.
        else.

       CONCATENATE gv_tag_req ls_tline-tdline
        INTO gv_tag_req SEPARATED BY space.
*     gv_vtext = ls_tline-tdline.
     endif.
     endloop.

     refresh lt_tline.
     name = lv_vbeln.


CALL FUNCTION 'READ_TEXT'
    EXPORTING
     CLIENT                        = SY-MANDT
      id                            = 'Z999'
      language                      =  'E' "sy-langu
      NAME                          = NAME
      OBJECT                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =  LV_HEADER
*     OLD_LINE_COUNTER              =
    TABLES
      lines                         = lt_tline
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
** Implement suitable error handling here
    ENDIF.


*     if lt_tline is INITIAL.
     LOOP AT lt_tline INTO ls_tline.
      if gv_tpi_req IS INITIAL.
*         wa_final-vtext = ls_tline-tdline.
        gv_tpi_req = ls_tline-tdline.
        else.

       CONCATENATE gv_tpi_req ls_tline-tdline
        INTO gv_tpi_req SEPARATED BY space.
*     gv_vtext = ls_tline-tdline.
     endif.
     endloop.

      refresh lt_tline.

 name = lv_vbeln.


CALL FUNCTION 'READ_TEXT'
    EXPORTING
     CLIENT                        = SY-MANDT
      id                            = 'Z012'
      language                      =  'E' "sy-langu
      NAME                          = NAME
      OBJECT                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =  LV_HEADER
*     OLD_LINE_COUNTER              =
    TABLES
      lines                         = lt_tline
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
** Implement suitable error handling here
    ENDIF.


*     if lt_tline is INITIAL.
     LOOP AT lt_tline INTO ls_tline.
      if gv_pack_d IS INITIAL.
*         wa_final-vtext = ls_tline-tdline.
        gv_pack_d = ls_tline-tdline.
        else.

       CONCATENATE gv_pack_d ls_tline-tdline
        INTO gv_pack_d SEPARATED BY space.
*     gv_vtext = ls_tline-tdline.
     endif.
     endloop.

      refresh lt_tline.

       name = lv_vbeln.


CALL FUNCTION 'READ_TEXT'
    EXPORTING
     CLIENT                        = SY-MANDT
      id                            = 'Z047'
      language                      =  'E' "sy-langu
      NAME                          = NAME
      OBJECT                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =  LV_HEADER
*     OLD_LINE_COUNTER              =
    TABLES
      lines                         = lt_tline
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
** Implement suitable error handling here
    ENDIF.


*     if lt_tline is INITIAL.
     LOOP AT lt_tline INTO ls_tline.
      if gv_part_d IS INITIAL.
*         wa_final-vtext = ls_tline-tdline.
        gv_part_d = ls_tline-tdline.
        else.

       CONCATENATE gv_part_d ls_tline-tdline
        INTO gv_part_d SEPARATED BY space.
*     gv_vtext = ls_tline-tdline.
     endif.
     endloop.

      refresh lt_tline.





















