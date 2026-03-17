DATA:
  lt_bset TYPE tt_bset,
  ls_bset TYPE t_bset.
CLEAR :
  gv_amv,fri_val,gv_scq,cgst,gv_del_tax,sgst,igst,tot_tax,
  grand_tot,net_val,pfl_rate,kb_cgst,kb_sgst,kb_igst,ins_val,
  pfl_val.

*BREAK-POINT.

LOOP AT GT_ACCOUNTING_DOC_ITEM INTO GS_ACCOUNTING_DOC_ITEM  .
IF GS_ACCOUNTING_DOC_ITEM-KOSTL IS NOT INITIAL .
IF P_WAERS = 'SAR' .
  gv_amt  = gs_accounting_doc_item-dmbtr.
ELSE.
   gv_amt  = gs_accounting_doc_item-wrbtr.

ENDIF.
ENDIF.

IF GS_ACCOUNTING_DOC_ITEM-SHKZG = 'S'.
 IF P_WAERS = 'SAR'.
    gv_tot_amt = gv_tot_amt + gs_accounting_doc_item-dmbtr.
ELSE.
    gv_tot_amt = gv_tot_amt + gs_accounting_doc_item-wrbtr.
ENDIF.
ENDIF.

ENDLOOP.



SELECT bukrs
       belnr
       gjahr
       hwste
       fwste
       kschl
       kbetr
  FROM bset
  INTO TABLE lt_bset
  WHERE belnr = gs_accounting_doc_hdr-belnr
  AND   gjahr = gs_accounting_doc_hdr-gjahr.

*BREAK-POINT.
LOOP AT lt_bset INTO ls_bset.
  CASE ls_bset-kschl.
*    WHEN 'JICG' OR 'JICN'.
    WHEN 'MWVS' .   "OR 'NLXA' OR 'NLXV'.
      IF P_WAERS = 'SAR'.

        cgst    = cgst + ls_bset-hwste.
      ELSE.

        cgst    = cgst + ls_bset-fwste.
      ENDIF.

  ENDCASE.
ENDLOOP.


tot_tax =  cgst .
*grand_tot = tot_tax + ins_val + gv_tot_amt + gv_del_tax
*       + gv_scq + gv_amv + fri_val + pfl_val." +

  grand_tot = gv_amt + tot_tax.



*net_val   = grand_tot - gv_amv.
