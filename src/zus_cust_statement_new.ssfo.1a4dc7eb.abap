
SELECT SINGLE * FROM t001w INTO wa_t001w
  WHERE werks = 'US01'.


SELECT SINGLE * FROM adrc INTO wa_adrc
  WHERE ADDRNUMBER = wa_t001w-adrnr.

READ TABLE itab INTO wa_itab INDEX 1.


















