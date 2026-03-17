READ TABLE itab INTO wa_itab INDEX 1.

SELECT SINGLE * FROM kna1 INTO wa_kna1
  WHERE kunnr = kunnr."wa_itab-kunnr.

SELECT addrnumber
       smtp_addr FROM adr6 INTO TABLE it_adr6
       WHERE addrnumber = wa_kna1-adrnr.


READ TABLE it_adr6 INTO wa_adr6 INDEX 1.
IF sy-subrc = 0.
email = wa_adr6-smtp_addr.
ENDIF.
READ TABLE it_adr6 INTO wa_adr6 INDEX 2.
IF sy-subrc = 0.
email1 = wa_adr6-smtp_addr.
ENDIF.
READ TABLE it_adr6 INTO wa_adr6 INDEX 3.
IF sy-subrc = 0.
email2 = wa_adr6-smtp_addr.
ENDIF.

CONCATENATE email1 email2 INTO mail SEPARATED BY ','.










