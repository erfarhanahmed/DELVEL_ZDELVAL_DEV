
gv_tot = gv_tot + WA_ITAB-netbal .

gv_tot0_30 = gv_tot0_30 + wa_itab-NETB30 + wa_itab-NETB60 .

gv_tot31_60 = gv_tot31_60 + wa_itab-NETB90 .

gv_tot61_90 = gv_tot61_90 + wa_itab-NETB120 .

gv_totall = gv_totall + wa_itab-NETB180 + wa_itab-NETB360 + wa_itab-NETB720 + wa_itab-NETB1000.


*TOTAL = WA_ITAB-netbal.
CLEAR: TOTAL, TOTAL1.
IF WA_ITAB-netbal < 0.
  TOTAL = WA_ITAB-netbal * -1.
*CONCATENATE '(' TOTAL ')' INTO TOTAL.
ELSE.
  total1 = WA_ITAB-netbal.
ENDIF.












