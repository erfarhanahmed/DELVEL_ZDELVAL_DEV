
CLEAR:wa_adr6,gv_email.
SELECT SINGLE * FROM vbpa INTO wa_vbpa
  WHERE vbeln = IS_VBDKA-vbeln AND parvw = 'WE'.

SELECT SINGLE * FROM kna1 INTO wa_kna1
  WHERE kunnr = wa_vbpa-kunnr.

SELECT SINGLE * FROM adrc INTO wa_shipto
  WHERE ADDRNUMBER = wa_kna1-adrnr.

SELECT ADDRNUMBER
       CONSNUMBER
       SMTP_ADDR  FROM adr6 INTO TABLE it_adr6
       WHERE ADDRNUMBER = wa_kna1-adrnr.
SORT it_adr6 by CONSNUMBER.
LOOP AT it_adr6 INTO wa_adr6.
CONCATENATE gv_email wa_adr6-smtp_addr ','  INTO gv_email SEPARATED BY space.
ENDLOOP.
*









