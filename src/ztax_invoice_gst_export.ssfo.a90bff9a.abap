DATA:
  lv_kunnr  TYPE kna1-kunnr,
  lv_adrnr  TYPE kna1-adrnr,
  ls_hd_adr TYPE lbbil_hd_adr.
*****Customer
SELECT SINGLE adrnr
              stcd3
        FROM  kna1
        INTO (lv_adrnr,gv_gst)
        WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.


SELECT SINGLE *
       FROM adrc
       INTO gs_adrc
       WHERE addrnumber = lv_adrnr.

SELECT SINGLE landx
         FROM t005t
         INTO gv_country
         WHERE land1 = gs_adrc-country
          AND  spras = sy-langu.

SELECT SINGLE bezei
         FROM t005u
         INTO gv_reg
         WHERE land1 = gs_adrc-country
          AND  bland = gs_adrc-region
          AND  spras = sy-langu.

*BREAK primus.
SELECT SINGLE gst_region
       FROM   zgst_region
       INTO   gv_gst_reg
       WHERE  bezei = gv_reg.

SELECT SINGLE smtp_addr
        FROM  adr6
        INTO  gv_email
        WHERE addrnumber = lv_adrnr.


**lv_kunnr = ls_bil_invoice-hd_gen-ship_to_party.
**IF lv_kunnr IS INITIAL.
**  lv_kunnr = ls_bil_invoice-hd_gen-sold_to_party.
**ENDIF.
* get customer adress number
SELECT SINGLE adrnr FROM vbpa INTO lv_adrnr
                      WHERE vbeln = LS_BIL_INVOICE-hd_ref-order_numb
                        AND parvw = 'WE'.
*****Consignee
SELECT SINGLE kunnr
              stcd3
        FROM  kna1
        INTO (lv_kunnr,gv_gst_c)
        WHERE adrnr = lv_adrnr.

SELECT SINGLE *
       FROM adrc
       INTO gs_adrc_c
       WHERE addrnumber = lv_adrnr.

SELECT SINGLE landx
         FROM t005t
         INTO gv_country_c
         WHERE land1 = gs_adrc_c-country
          AND  spras = sy-langu.

SELECT SINGLE bezei
         FROM t005u
         INTO gv_reg_c
         WHERE land1 = gs_adrc_c-country
          AND  bland = gs_adrc_c-region
          AND  spras = sy-langu.

SELECT SINGLE gst_region
       FROM   zgst_region
       INTO   gv_gst_reg_c
       WHERE  bezei = gv_reg_c.



SELECT SINGLE smtp_addr
        FROM  adr6
        INTO  gv_email_c
        WHERE addrnumber = lv_adrnr.














