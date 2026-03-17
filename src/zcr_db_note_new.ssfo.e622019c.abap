*BREAK primus.

*gv_qty = gs_material_doc-menge.
*gv_rate = gs_material_doc-wrbtr / gs_material_doc-menge.
IF NOT gs_accounting_doc_item-vbel2 IS INITIAL.
  gv_vbeln = gs_accounting_doc_item-vbel2.
ENDIF.

*IF NOT gs_accounting_doc_item-fwbas is INITIAL.
*  gv_amt  = gs_accounting_doc_item-fwbas.
*ELSE.
  gv_amt  = gs_accounting_doc_item-wrbtr.
*ENDIF.

IF gs_accounting_doc_item-shkzg = 'S'.
  gv_tot_amt = gv_tot_amt + gv_amt.
ELSE.
  gv_tot_amt = gv_tot_amt - gv_amt.
  gv_amt = gv_amt * -1.

ENDIF.

*gv_tot_qty = gv_tot_qty + gs_material_doc-menge.
**
**
