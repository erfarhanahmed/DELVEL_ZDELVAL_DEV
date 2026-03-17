
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

SELECT SINGLE TEXT1 INTO GV_PAYTERM FROM T052U WHERE ZTERM = GV_VBKD-ZTERM.

  CLEAR wa_vbap.
SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE vbeln = wa_final-vbeln AND posnr = wa_final-posnr.

CLEAR: CUST_DT.
IF WA_vbap-CUSTDELDATE IS NOT INITIAL.

CONCATENATE  WA_vbap-CUSTDELDATE+0(4) WA_vbap-CUSTDELDATE+4(2) WA_vbap-CUSTDELDATE+6(2)
                INTO CUST_DT SEPARATED BY '-'.
ENDIF.

SELECT SINGLE *
              FROM ADRC
              INTO LV_KNA11
              WHERE ADDRNUMBER = LV_ADRNR1.

  SELECT FROM ADRC AS A INNER JOIN T005T AS B
          ON   A~COUNTRY EQ B~LAND1
            FIELDS B~LANDX
       WHERE ADDRNUMBER = @LV_ADRNR1
       AND SPRAS EQ 'E'
      INTO CORRESPONDING FIELDS OF @LV_T005T1.
    ENDSELECT.
