
GV_IS = GV_IS + 1.

SELECT SINGLE steuc INTO GV_STEUC FROM marc
  WHERE matnr = wa_final-matnr.





tax_amt = wa_final-netwr + tax_amt.
cgst_tot = wa_final-cgst_amt + cgst_tot.
sgst_tot = wa_final-sgst_amt + sgst_tot.








