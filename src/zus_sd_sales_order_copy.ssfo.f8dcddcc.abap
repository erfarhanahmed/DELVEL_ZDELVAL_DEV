""Added by Pranit 16.08.2024
DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.

CLEAR: lv_lines, ls_mattxt,GV_REMARK.
      REFRESH lv_lines.
      lv_name = IS_VBDKA-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U005'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
             replace all occurences of '<(>&<)>' in wa_lines-tdline with '& '.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE GV_REMARK wa_lines-tdline  INTO GV_REMARK SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_REMARK.
      ENDIF.




















