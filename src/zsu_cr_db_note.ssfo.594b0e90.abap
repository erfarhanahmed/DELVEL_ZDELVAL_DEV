DATA:
  lt_bset                TYPE tt_bset,
  ls_bset                TYPE t_bset,
  lt_accounting_doc_item TYPE tt_accounting_doc_item,
  ls_accounting_doc_item TYPE t_accounting_doc_item.
CLEAR :
  gv_amv,fri_val,gv_scq,cgst,gv_del_tax,sgst,igst,tot_tax,
  grand_tot,net_val,pfl_rate,kb_cgst,kb_sgst,kb_igst,ins_val,
  pfl_val,gv_tcs.

*BREAK-POINT.

SELECT bukrs
       belnr
       gjahr
       buzei
       shkzg
       DMBTR
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

    WHEN 'MWAS'.
    IF P_WAERS = 'SAR'.
         IF kb_cgst IS INITIAL.
        kb_cgst = ls_bset-kbetr / 10.
      ENDIF.
      IF ls_bset-shkzg = 'H'.
        cgst    =  cgst - ls_bset-hwste  .
      ELSE.
        cgst    = cgst + ls_bset-hwste.
      ENDIF.
    ELSE.
       IF kb_cgst IS INITIAL.
        kb_cgst = ls_bset-kbetr / 10.
      ENDIF.
      IF ls_bset-shkzg = 'H'.
        cgst    =  cgst - ls_bset-hwste  .
      ELSE.
        cgst    = cgst + ls_bset-FWSTE.
      ENDIF.

    ENDIF.

  ENDCASE.

ENDLOOP.
*break primus.
gv_shkzg = ls_bset-shkzg.
tot_tax = igst + cgst + sgst.

IF ls_bset-shkzg = 'H'.
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

IF P_WAERS = 'SAR'.

net_val = GS_ACCOUNTING_DOC_ITEM-WRBTR + tot_tax.
ELSE.
net_val = GS_ACCOUNTING_DOC_ITEM-DMBTR + tot_tax.
ENDIF.
