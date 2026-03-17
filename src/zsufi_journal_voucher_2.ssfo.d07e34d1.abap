



  "READ TABLE it_bseg into wa_bseg with key belnr = wa_final-belnr.
*BREAK-POINT.
loop at it_bseg into wa_bseg." WHERE BELNR = BELNR.
  if wa_bseg-shkzg = 'S'.
    IF WAERS NE 'SAR'.
  gv_tot = gv_tot + wa_bseg-WRBTR.
  ELSE.
  gv_tot = gv_tot + wa_bseg-dmbtr.
  ENDIF.
  endif.
  if wa_bseg-shkzg = 'H'.
    IF WAERS NE 'SAR'.
  gv_tot1 = gv_tot1 + wa_bseg-WRBTR.
  ELSE.
  gv_tot1 = gv_tot1 + wa_bseg-dmbtr.
  ENDIF.
  ENDIF.
endloop.













