
*DATA : V_DESC(255) TYPE C.
*CLEAR V_DESC.
*BREAK-POINT.
*SELECT SINGLE MAKTX INTO V_DESC FROM MAKT
*  WHERE MATNR = WA_FINAL-MATNR.



DATA: lv_name   TYPE thead-tdname.

  CLEAR: it_lines,wa_LINES,WA_MAT_TEXT.
      REFRESH it_lines.
      lv_name = wa_final-matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name
          object                  = 'MATERIAL'
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
 CONCATENATE WA_MAT_TEXT wa_lines-tdline INTO WA_MAT_TEXT SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.











