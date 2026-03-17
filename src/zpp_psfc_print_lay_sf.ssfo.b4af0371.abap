
      DATA: lv_name  TYPE thead-tdname,
            lv_lines TYPE STANDARD TABLE OF tline,
            wa_lines LIKE tline.
      CLEAR gv_LD.
      lv_name = gs_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z038'
          language                = 'E'
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
      ELSE.

        READ TABLE lv_lines INTO wa_lines INDEX 1.
        gv_LD = wa_lines.
      ENDIF.























