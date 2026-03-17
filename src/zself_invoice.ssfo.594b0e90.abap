DATA:
  lt_bset TYPE tt_bset,
  ls_bset TYPE t_bset.
CLEAR :
  gv_amv,fri_val,gv_scq,cgst,gv_del_tax,sgst,igst,tot_tax,
  grand_tot,net_val,pfl_rate,kb_cgst,kb_sgst,kb_igst,ins_val,
  pfl_val.

SELECT bukrs
       belnr
       gjahr
       hwste
       kschl
       kbetr
  FROM bset
  INTO TABLE lt_bset
  WHERE belnr = gs_accounting_doc_hdr-belnr
  AND   gjahr = gs_accounting_doc_hdr-gjahr.

*BREAK X770202.
LOOP AT lt_bset INTO ls_bset.
  CASE ls_bset-kschl.
    WHEN 'JICG'." OR 'JICN'.
      kb_cgst = ls_bset-kbetr / 10.
      cgst    = cgst + ls_bset-hwste.

    WHEN 'JISG'." OR 'JISN'.
      kb_sgst = ls_bset-kbetr / 10.
      sgst    = sgst + ls_bset-hwste.

    WHEN 'JIIG'." OR 'JIIN'.
      kb_igst = ls_bset-kbetr / 10.
      igst    = igst + ls_bset-hwste.

**    WHEN 'JICR' OR 'ZCRN' OR 'JISR' OR 'ZSRN' OR 'ZIRN'.
**      gv_del_tax = gv_del_tax + ls_bset-hwste.
  ENDCASE.
ENDLOOP.


tot_tax = igst + cgst + sgst.
grand_tot = tot_tax + ins_val + gv_tot_amt "+ gv_del_tax
       + gv_scq + gv_amv + fri_val + pfl_val." +

net_val   = grand_tot - gv_amv.



