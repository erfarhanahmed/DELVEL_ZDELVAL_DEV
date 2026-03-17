*BREAK-POINT.
if wa_final-kbetr6 is NOT INITIAL.
GV_STAXRATE = WA_FINAL-kbetr6.
else.
 GV_STAXRATE = 0.
ENDIF.

if wa_final-ZSATAXAMT is NOT INITIAL.
GV_STAXQTY = WA_FINAL-ZSATAXAMT.
else.
 GV_STAXQTY = 0.
ENDIF.




















