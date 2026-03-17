*BREAK primus.
data:
  ls_ekpo TYPE t_ekpo.
READ TABLE gt_makt INTO gs_makt
                   with KEY matnr = wa_rseg-matnr.

CLEAR ls_ekpo.
READ TABLE gt_ekpo INTO ls_ekpo
                   with KEY ebeln = wa_rseg-ebeln
                            ebelp = wa_rseg-ebelp.
gv_rate = ls_ekpo-netpr.

gv_tot_amt = gv_tot_amt + wa_rseg-wrbtr.
