*BREAK primus.

*gv_qty = gs_material_doc-menge.
*gv_rate = gs_material_doc-wrbtr / gs_material_doc-menge.
gv_amt  = gs_accounting_doc_item-dmbtr.

gv_tot_amt = gv_tot_amt + gs_accounting_doc_item-dmbtr.
*gv_tot_qty = gv_tot_qty + gs_material_doc-menge.
**
**
