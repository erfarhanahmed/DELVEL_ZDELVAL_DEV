clear gv_amv.
READ TABLE gt_final INTO wa_final1 with key kschl = 'ZAMV'.
if sy-subrc = 0.
  gv_amv = wa_final1-kbetr.
 endif.


















