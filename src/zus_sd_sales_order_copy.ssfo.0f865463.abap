clear: wa_vbpa,wa_kna1.
SELECT SINGLE * FROM vbpa INTO wa_vbpa
  WHERE vbeln = IS_VBDKA-vbeln AND parvw = 'UR'.

SELECT SINGLE * FROM kna1 INTO wa_kna1
  WHERE kunnr = wa_vbpa-kunnr.






















