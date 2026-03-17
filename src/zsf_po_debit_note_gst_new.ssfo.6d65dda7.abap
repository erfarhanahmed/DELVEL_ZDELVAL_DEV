
CLEAR :
  gv_amv,fri_val,gv_scq,cgst,gv_del_tax,sgst,igst,tot_tax,
  grand_tot,net_val,pfl_rate,kb_cgst,kb_sgst,kb_igst,ins_val,
  pfl_val.

DATA:
  lt_bset         TYPE tt_bset,
  ls_bset         TYPE t_bset,
  lt_material_doc TYPE zt_material_doc,
  ls_material_doc TYPE zmaterial_doc.

lt_material_doc[] = gt_material_doc[].
DELETE lt_material_doc WHERE kschl IS INITIAL.
LOOP AT lt_material_doc INTO ls_material_doc.
  CASE ls_material_doc-kschl.
    WHEN 'ZINS'.
      ins_val = ins_val + ls_material_doc-wrbtr.
    WHEN 'ZPFL'.
      pfl_val = pfl_val + ls_material_doc-wrbtr.
    WHEN 'ZRB1'.
      fri_val = fri_val + ls_material_doc-wrbtr.
    WHEN 'ZSCV'.
      gv_scq = gv_scq + ls_material_doc-wrbtr.
    WHEN 'ZAMV'.
      gv_amv = gv_amv + ls_material_doc-wrbtr.
  ENDCASE.

ENDLOOP.

**DATA:
**  t_mwdat  TYPE TABLE OF  rtax1u15,
**  ls_bset TYPE rtax1u15.
**
**
***"""""" CGST/IGST/SGST/CESS """""""""""""""""""""""""""""""""
***BREAK-POINT.
**CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
**  EXPORTING
**    i_bukrs           = gs_material_doc_hdr-bukrs
**    i_mwskz           = gs_material_doc_hdr-mwskz
***   I_TXJCD           = ' '
**    i_waers           = 'INR'
**    i_wrbtr           = gv_tot_amt "WA_RSEG1-WRBTR
***   I_ZBD1P           = 0
***   I_PRSDT           =
***   I_PROTOKOLL       =
***   I_TAXPS           =
***   I_ACCNT_EXT       =
***   I_ACCDATA         =
**  IMPORTING
***   E_FWNAV           =
***   E_FWNVV           =
**    e_fwste           = fwste
**    e_fwast           = fwast
**  TABLES
**    t_mwdat           = t_mwdat
**  EXCEPTIONS
**    bukrs_not_found   = 1
**    country_not_found = 2
**    mwskz_not_defined = 3
**    mwskz_not_valid   = 4
**    ktosl_not_found   = 5
**    kalsm_not_found   = 6
**    parameter_error   = 7
**    knumh_not_found   = 8
**    kschl_not_found   = 9
**    unknown_error     = 10
**    account_not_found = 11
**    txjcd_not_valid   = 12
**    OTHERS            = 13.
**IF sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSG  V2 SY-MSGV3 SY-MSGV4.
**ENDIF.

*BREAK X770202.

SELECT bukrs
       belnr
       gjahr
       buzei
       hwste
       kschl
       kbetr
  FROM bset
  INTO TABLE lt_bset
  FOR ALL ENTRIES IN gt_material_doc_hdr
  WHERE bukrs = gt_material_doc_hdr-bukrs
  AND   belnr = gt_material_doc_hdr-belnr
  AND   gjahr = gt_material_doc_hdr-gjahr.

*BREAK-POINT.
LOOP AT lt_bset INTO ls_bset.
  CASE ls_bset-kschl.
    WHEN 'JICG' OR 'JICN'.
      kb_cgst = ls_bset-kbetr / 10.
      cgst    = cgst + ls_bset-hwste.

    WHEN 'JISG' OR 'JISN'.
      kb_sgst = ls_bset-kbetr / 10.
      sgst    = sgst + ls_bset-hwste.

    WHEN 'JIIG' OR 'JIIN'.
      kb_igst = ls_bset-kbetr / 10.
      igst    = igst + ls_bset-hwste.

    WHEN 'JICR' OR 'ZCRN' OR 'JISR' OR 'ZSRN' OR 'ZIRN'.
      gv_del_tax = gv_del_tax + ls_bset-hwste.
  ENDCASE.
ENDLOOP.


tot_tax = igst + cgst + sgst.
grand_tot = tot_tax + ins_val + gv_tot_amt + gv_del_tax
       + gv_scq + gv_amv + fri_val + pfl_val." +

net_val   = grand_tot - gv_amv.
