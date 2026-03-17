CLEAR:wa_mara,old_code.
SELECT SINGLE * FROM mara INTO wa_mara
  WHERE matnr = header-matnr.

IF wa_mara-wrkst IS NOT INITIAL.
CONCATENATE '(' wa_mara-wrkst ')' INTO old_code.
ENDIF.




















