
SELECT SINGLE * FROM VBAK INTO WA_VBAK
  WHERE VBELN = wa_final-vbelv.

DATA: lv_name   TYPE thead-tdname.
  CLEAR: it_lines,wa_LINES.
      REFRESH it_lines.
CONCATENATE wa_vbak-vbeln wa_final-posnr INTO lv_name.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0001'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
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
*LOOP AT it_lines INTO wa_lines.
READ TABLE it_lines INTO wa_lines INDEX 1.
IF NOT wa_lines-tdline IS INITIAL.
  PO_NO = wa_lines-tdline.
ENDIF.

ENDIF.






















