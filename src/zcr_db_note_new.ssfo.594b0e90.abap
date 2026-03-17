DATA:
  lt_bset                TYPE tt_bset,
  ls_bset                TYPE t_bset,
  lt_accounting_doc_item TYPE tt_accounting_doc_item,
  ls_accounting_doc_item TYPE t_accounting_doc_item.
CLEAR :
  gv_amv,fri_val,gv_scq,cgst,gv_del_tax,sgst,igst,tot_tax,
  grand_tot,net_val,pfl_rate,kb_cgst,kb_sgst,kb_igst,ins_val,
  pfl_val,gv_tcs.

SELECT bukrs
       belnr
       gjahr
       buzei
       shkzg
       wrbtr
       fwbas
       sgtxt
       kunnr
       lifnr
       vbel2
       hsn_sac
  FROM bseg
  INTO TABLE lt_accounting_doc_item
  WHERE belnr = gs_accounting_doc_hdr-belnr
  AND   gjahr = gs_accounting_doc_hdr-gjahr
  AND   xbilk NE space
  AND   ktosl EQ 'WIT'.

LOOP AT lt_accounting_doc_item INTO ls_accounting_doc_item.
  gv_tds = gv_tds + ls_accounting_doc_item-wrbtr.
ENDLOOP.

SELECT bukrs
       belnr
       gjahr
       buzei
       shkzg
       hwbas
       fwbas
       hwste
       fwste
       kschl
       kbetr
       mwskz
  FROM bset
  INTO TABLE lt_bset
  WHERE belnr = gs_accounting_doc_hdr-belnr
  AND   gjahr = gs_accounting_doc_hdr-gjahr.

*BREAK X770202.
LOOP AT lt_bset INTO ls_bset.
  CASE ls_bset-kschl.
    WHEN 'JOCG'.
      IF kb_cgst IS INITIAL.
        kb_cgst = ls_bset-kbetr / 10.
      ENDIF.
      IF ls_bset-shkzg = 'S'.
        cgst    = cgst - ls_bset-hwste.
      ELSE.
        cgst    = cgst + ls_bset-hwste.
      ENDIF.
    WHEN 'JICG'.
      IF kb_cgst IS INITIAL.
        kb_cgst = ls_bset-kbetr / 10.
      ENDIF.
      IF ls_bset-shkzg = 'H'.
        cgst    = cgst - ls_bset-hwste.
      ELSE.
        cgst    = cgst + ls_bset-hwste.
      ENDIF.
    WHEN 'JOSG'.
      IF kb_sgst IS INITIAL.
        kb_sgst = ls_bset-kbetr / 10.
      ENDIF.

      IF ls_bset-shkzg = 'S'.
        sgst    = sgst - ls_bset-hwste.
      ELSE.
        sgst    = sgst + ls_bset-hwste.
      ENDIF.

    WHEN 'JISG'.
      IF kb_sgst IS INITIAL.
        kb_sgst = ls_bset-kbetr / 10.
      ENDIF.

      IF ls_bset-shkzg = 'H'.
        sgst    = sgst - ls_bset-hwste.
      ELSE.
        sgst    = sgst + ls_bset-hwste.
      ENDIF.
    WHEN 'JOIG'.
      IF kb_igst IS INITIAL.
        kb_igst = ls_bset-kbetr / 10.
      ENDIF.
*break primus.
      IF ls_bset-shkzg = 'S'.
        igst    = igst - ls_bset-fwste.
      ELSE.
        igst    = igst + ls_bset-fwste.
      ENDIF.
    WHEN 'JIIG'.
      IF kb_igst IS INITIAL.
        kb_igst = ls_bset-kbetr / 10.
      ENDIF.

      IF ls_bset-shkzg = 'H'.
        igst    = igst - ls_bset-hwste.
      ELSE.
        igst    = igst + ls_bset-hwste.
      ENDIF.

    WHEN 'JTC1'.
*      IF ls_bset-shkzg = 'S'.
*        gv_tcs = gv_tcs - ls_bset-hwste.
*      ELSE.
*        gv_tcs = gv_tcs + ls_bset-hwste.
*      ENDIF.
      gv_tcs = gv_tcs + ls_bset-hwste.

  ENDCASE.

*  IF ls_bset-shkzg = 'S'.
*    tot_tax = tot_Tax + cgst + sgst - igst.
*  ELSE.
*    tot_tax = tot_tax + cgst + sgst + igst.
*  ENDIF.

ENDLOOP.
*break primus.
gv_shkzg = ls_bset-shkzg.
tot_tax = igst + cgst + sgst.

IF ls_bset-shkzg = 'S'.
*grand_tot = tot_tax + ins_val + gv_tot_amt + gv_del_tax
*       + gv_scq + fri_val + pfl_val." +
  grand_tot =  ins_val + gv_tot_amt + gv_del_tax
         + gv_scq + fri_val + pfl_val - tot_tax ." +
  gv_amv = grand_tot + tot_tax.

  IGST = IGST * ( -1 ).
  sgst = sgst * ( -1 ).
  cgst = cgst * ( -1 ).
  TOT_TAX = TOT_TAX * ( -1 ).
 else.
   grand_tot =  ins_val + gv_tot_amt + gv_del_tax
         + gv_scq + fri_val + pfl_val + tot_tax ." +

   gv_amv = grand_tot - tot_tax.
ENDIF.

*gv_amv = grand_tot - tot_tax.
net_val   = grand_tot - gv_tds + gv_tcs.
