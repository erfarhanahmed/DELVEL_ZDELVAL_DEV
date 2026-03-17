DATA: lv_name   TYPE thead-tdname.
  CLEAR: it_lines,wa_LINES.
      REFRESH it_lines.
      lv_name = ls_bil_invoice-hd_gen-bil_number.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z041'
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
  CONCATENATE gv_comm wa_lines-tdline INTO gv_comm SEPARATED BY SPACE.
ENDIF.
ENDLOOP.
ENDIF.




















