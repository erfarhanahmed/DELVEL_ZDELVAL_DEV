
SELECT SINGLE * FROM vbak INTO gv_vbak
  WHERE vbeln = lv_vbeln.

SELECT SINGLE * FROM vbkd INTO gv_vbkd
  WHERE vbeln = lv_vbeln.

*************Sale Order Date

CONCATENATE  gv_vbak-ERDAT+6(2) gv_vbak-ERDAT+4(2) gv_vbak-ERDAT+0(4)
                INTO GV_SALE_DT SEPARATED BY '-'.

**************PO DATE

CONCATENATE  GV_VBKD-BSTDK+6(2) GV_VBKD-BSTDK+4(2) GV_VBKD-BSTDK+0(4)
                INTO GV_PO_DT SEPARATED BY '-'.

************CDD Date

CONCATENATE GV_VBAK-VDATU+6(2) GV_VBAK-VDATU+4(2) GV_VBAK-VDATU+0(4)
            INTO GV_CDD_DT SEPARATED BY '-'.

************OFM Date

MOVE WA_FINAL-LV_LINES1 TO GV_OFM_DT.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline.


CLEAR: lv_lines,  lv_name.
REFRESH lv_lines.
lv_name = GV_VBAK-VBELN.
CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'ZZ99' "'0009'
          language                = 'E' "'S'
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
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE GV_PO wa_lines-tdline INTO GV_PO SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_PO.
      ENDIF.
