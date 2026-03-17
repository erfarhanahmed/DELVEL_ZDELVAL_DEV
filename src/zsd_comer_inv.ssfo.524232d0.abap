CLEAR : gs_hd_ref.
MOVE-CORRESPONDING is_bil_invoice-hd_ref TO gs_hd_ref.

CLEAR : v_flag , gs_hd_gen.
MOVE-CORRESPONDING is_bil_invoice-hd_gen TO gs_hd_gen.

*SELECT  vbeln
*        posnr
*        parvw
*        adrnr
*        FROM vbpa INTO CORRESPONDING FIELDS OF TABLE it_vbpa
*        WHERE vbeln = gs_hd_ref-order_numb
*        AND   parvw = 'WE'.
*
*READ TABLE it_vbpa INTO wa_vbpa INDEX 1.

SELECT SINGLE adrnr FROM vbpa INTO l_adrnr
                      WHERE vbeln = gs_hd_ref-order_numb
                        AND parvw = 'WE'.

CLEAR wa_adrc .
SELECT SINGLE *
*     name1
*     street
*     sort1
*     city1
*     post_code1
*     tel_number
*     fax_number
*     country
FROM adrc INTO wa_adrc
*INTO CORRESPONDING FIELDS OF wa_adrc
*  FOR ALL ENTRIES IN IT_VBPA
WHERE addrnumber = l_adrnr.

SELECT SINGLE *
FROM t005t
INTO wa_t005t
WHERE land1 = wa_adrc-country
AND   spras = 'EN'.

SELECT SINGLE *
  FROM t005u
  INTO wa_t005u
  WHERE land1 = wa_adrc-country
  AND   bland = wa_adrc-region
  AND   spras = 'EN'.
