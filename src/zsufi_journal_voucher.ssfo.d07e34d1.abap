



  "READ TABLE it_bseg into wa_bseg with key belnr = wa_final-belnr.

loop at it_bseg into wa_bseg." WHERE BELNR = BELNR.
  if wa_bseg-shkzg = 'S'.
  gv_tot = gv_tot + wa_bseg-dmbtr.
  endif.
  if wa_bseg-shkzg = 'H'.
    gv_tot1 = gv_tot1 + wa_bseg-dmbtr.
  ENDIF.
endloop.

















