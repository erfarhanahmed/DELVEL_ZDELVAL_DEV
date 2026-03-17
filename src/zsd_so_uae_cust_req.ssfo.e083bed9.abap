
DATA:
  lv_kunnr TYPE kna1-kunnr,
  lv_adrnr1 TYPE kna1-adrnr.


SELECT SINGLE adrnr
        FROM  kna1
        INTO lv_adrnr1
        WHERE kunnr = wa_final-kunnr1.
SELECT SINGLE smtp_addr
        FROM  adr6
        INTO  gv_email_S
        WHERE addrnumber = lv_adrnr1.


SELECT SINGLE * FROM vbak INTO gv_vbak
  WHERE vbeln = lv_vbeln.

SELECT SINGLE * FROM vbkd INTO gv_vbkd
  WHERE vbeln = lv_vbeln.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline.

*BREAK-POINT.
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
*BREAK-POINT.
DATA : VDT(2) TYPE C,VMN(2) TYPE C,VYR(4) TYPE C.

 VDT = GV_VBAK-AUDAT+6(2).
 VMN = GV_VBAK-AUDAT+4(2).
 VYR = GV_VBAK-AUDAT+0(4).

 CONCATENATE VYR '-' VMN '-' VDT INTO GVORDDT.
*BREAK-POINT.
*DATA : GV_PAYTERM1(32) TYPE C.
*DATA : GV_PAYTERM2(50) TYPE C.
CLEAR GV_PAYTERM.
SELECT SINGLE TEXT1 INTO GV_PAYTERM FROM T052U WHERE ZTERM = GV_VBKD-ZTERM.
GV_PAYTERM1 = GV_PAYTERM+0(32).
GV_PAYTERM2 = GV_PAYTERM+33(17).

"for sales persone name
CLEAR: lv_lines,  lv_name.
REFRESH lv_lines.

lv_name = GV_VBAK-VBELN.

CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z102'
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

   IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
*            CONCATENATE LV_SALESPERSON wa_lines-tdline INTO LV_SALESPERSON SEPARATED BY space.
            LV_SALESPERSON = wa_lines-tdline.
          ENDIF.
        ENDLOOP.
        CONDENSE LV_SALESPERSON.
      ENDIF.
