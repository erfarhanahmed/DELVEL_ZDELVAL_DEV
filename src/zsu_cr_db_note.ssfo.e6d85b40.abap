
LOOP AT GT_ACCOUNTING_DOC_ITEM     INTO GS_ACCOUNTING_DOC_ITEM    .
IF NOT gs_accounting_doc_item-vbel2 IS INITIAL.
  gv_vbeln = gs_accounting_doc_item-vbel2.
ENDIF.

IF P_WAERS = 'SAR'.
gv_amt  = gs_accounting_doc_item-wrbtr.

ELSE .
  gv_amt  = gs_accounting_doc_item-wrbtr.
ENDIF.



IF gs_accounting_doc_item-shkzg = 'S'.
  gv_tot_amt = gv_tot_amt + gv_amt.
ELSE.
  gv_tot_amt = gv_tot_amt - gv_amt.
  gv_amt = gv_amt * -1.

ENDIF.
ENDLOOP.



















