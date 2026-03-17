*---------------ANJALI DT:17.04.2018----------------
IF NOT gs_accounting_doc_item-vbel2 IS INITIAL.
  gv_vbeln = gs_accounting_doc_item-vbel2.
ENDIF.

gv_amt  = gs_accounting_doc_item-wrbtr.

IF gs_accounting_doc_item-shkzg = 'H'.
  gv_tot_amt = gv_tot_amt + gv_amt.
ELSE.
  gv_tot_amt = gv_tot_amt - gv_amt.
  gv_amt = gv_amt * -1.
ENDIF.
*----------------------------------------------------




















