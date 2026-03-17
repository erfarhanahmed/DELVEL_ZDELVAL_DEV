*BREAK primus.

gv_qty = gs_material_doc-menge.
gv_rate = gs_material_doc-wrbtr / gs_material_doc-menge.
gv_amt  = gs_material_doc-wrbtr.

IF gs_material_doc-kschl IS INITIAL.
  gv_tot_amt = gv_tot_amt + gs_material_doc-wrbtr.
  gv_tot_qty = gv_tot_qty + gs_material_doc-menge.
ENDIF.
**
**
