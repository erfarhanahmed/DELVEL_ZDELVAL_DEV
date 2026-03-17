
LOOP AT it_final INTO wa_final.

lv_pf_amt   = lv_pf_amt   + wa_final-pf_amt.
lv_cgst_val = lv_cgst_val + wa_final-cgst_amt.
lv_sgst_val = lv_sgst_val + wa_final-sgst_amt.
lv_igst_val = lv_igst_val + wa_final-igst_amt.
lv_ins_val  = lv_ins_val  + wa_final-ins_amt.
lv_frg_val  = lv_frg_val  + wa_final-frg_amt.

ENDLOOP.





















