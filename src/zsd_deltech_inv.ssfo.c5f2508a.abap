
SELECT vbeln  posnr  matnr  matkl  arktx
       lfimg  vgbel  vgpos
  FROM lips INTO CORRESPONDING FIELDS OF TABLE it_lips
  WHERE vbeln = is_bil_invoice-hd_ref-deliv_numb
  AND   pstyv = 'ZTAN'.

IF sy-subrc = 0.
  SELECT SINGLE TEXT1 FROM T052U INTO G_TEXT2 WHERE zterm = g_term AND   spras = 'EN'.
  READ TABLE it_lips INTO wa_lips INDEX 1.

  SELECT SINGLE
            zterm
            bstkd
       FROM vbkd
       INTO (g_term, g_bstkd)
       WHERE vbeln = wa_lips-vgbel. "IS_BIL_INVOICE-HD_REF-ORDER_NUMB.

  SELECT SINGLE vtext FROM tvzbt INTO
   g_text1 WHERE zterm = g_term
           AND   spras = 'EN'.
 SELECT SINGLE TEXT1 FROM T052U INTO G_TEXT2 WHERE zterm = g_term AND   spras = 'EN'.
ENDIF.

SELECT SINGLE waerk inco1 inco2 kurrf FROM vbrk INTO
(g_waerk, g_inco1, g_inco2, g_kurrf) WHERE vbeln = is_bil_invoice-hd_gen-bil_number.

CLEAR g_inco2 .
SELECT SINGLE inco2 FROM vbkd INTO g_inco2
           WHERE vbeln = is_bil_invoice-hd_ref-order_numb.
