DATA:
  ls_accounting_doc_item TYPE t_accounting_doc_item,
*  lv_lifnr               TYPE lfa1-lifnr,
  lv_adrnr               TYPE lfa1-adrnr.

SELECT SINGLE lifnr
        FROM  bseg
        INTO  gv_lifnr
        WHERE belnr = gs_accounting_doc_hdr-belnr
        AND   gjahr = gs_accounting_doc_hdr-gjahr
        AND   lifnr ne space.
*****Vendor
SELECT SINGLE adrnr
              stcd3
        FROM  lfa1
        INTO (lv_adrnr,gv_gst)
        WHERE lifnr = gv_lifnr.

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

gv_gst_c = gv_gst.

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






