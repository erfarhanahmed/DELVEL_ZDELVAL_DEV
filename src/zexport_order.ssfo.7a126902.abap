
"TAG Applicable
  CLEAR: it_lines,wa_LINES,lv_name.
  lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z039'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE GV_TAG wa_lines-tdline INTO GV_TAG SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

"TPI Applicable
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z999'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE GV_TPI wa_lines-tdline INTO GV_TPI SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

"Insurance
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z017'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_insurance wa_lines-tdline INTO GV_insurance SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

"Mode of Despatch
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z018'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_mode_desp wa_lines-tdline INTO gv_mode_desp SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

"LD Applicable
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z038'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_ld_ap wa_lines-tdline INTO gv_ld_ap SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

"Incoterms
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z019'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_inco wa_lines-tdline INTO gv_inco SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z012'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_pack_d wa_lines-tdline INTO gv_pack_d SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z047'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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
IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_part_d wa_lines-tdline INTO gv_part_d SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.









