DATA:
  lt_bset TYPE tt_bset,
  ls_bset TYPE t_bset.

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

LOOP AT it_rseg INTO wa_rseg.
  IF wa_rseg-kschl = 'ZPFL' OR wa_rseg-kschl = 'ZPFV' .
    pfl_val = pfl_val + wa_rseg-wrbtr.
  ENDIF.
  IF wa_rseg-kschl = 'ZRB1' OR wa_rseg-kschl = 'ZRC1'
    OR wa_rseg-kschl = 'FRA1'.
    fri_val = fri_val + wa_rseg-wrbtr.
  ENDIF.
  IF wa_rseg-kschl = 'ZINS'.
    ins_val = ins_val + wa_rseg-wrbtr .
  ENDIF.
  IF wa_rseg-kschl = 'ZSCV' OR wa_rseg-kschl = 'ZSCQ'.
    gv_scq = gv_scq + wa_rseg-wrbtr.
  ENDIF.

ENDLOOP.
tot_tax = igst + cgst + sgst.
grand_tot = tot_tax + ins_val + gv_tot_amt "+ gv_del_tax
       + gv_scq + gv_amv + fri_val + pfl_val." +

net_val   = grand_tot - gv_amv.
