
CLEAR :
  gv_amv,fri_val,gv_scq,cgst,gv_del_tax,sgst,igst,tot_tax,
  grand_tot,net_val,pfl_rate,kb_cgst,kb_sgst,kb_igst,ins_val,
  pfl_val.

DATA: ls_material_doc_hdr TYPE zmaterial_doc_hdr.
data : lv_tot1 TYPE KONV-KWERT.
DATA:
  lt_bset         TYPE tt_bset,
  ls_bset         TYPE t_bset,
  lt_material_doc TYPE zt_material_doc,
  ls_material_doc TYPE zmaterial_doc.

DATA: LS_KONV TYPE zmaterial_doc.

lt_material_doc[] = gt_material_doc[].



SELECT * FROM EKKO
         INTO CORRESPONDING FIELDS OF TABLE IT_EKKO
         WHERE EBELN = WA_MSEG01-EBELN.

SELECT * FROM konv
         INTO CORRESPONDING FIELDS OF TABLE IT_KONV
         FOR ALL ENTRIES IN IT_EKKO
         WHERE KNUMV = IT_EKKO-KNUMV.
  CLEAR LS_KONV.




LOOP AT IT_KONV INTO WA_KONV.
  CASE WA_KONV-kschl.
    WHEN 'ZINS'.
      ins_val = ins_val + WA_KONV-KWERT.
    WHEN 'ZPSA' OR 'ZPC1' OR 'ZPFL' OR 'ZPFV'.
      pfl_val = pfl_val + WA_KONV-KWERT.
    WHEN 'FRA1' OR 'ZRB1' OR 'ZRC1'.
      fri_val = fri_val + WA_KONV-KWERT.
    WHEN 'ZST1' OR 'ZSCQ' OR 'ZSCV' OR 'ZST%' OR 'ZSTQ' OR 'ZSTV'.
      gv_scq = gv_scq + WA_KONV-KWERT.
  ENDCASE.
ENDLOOP.

*BREAK-POINT.
  READ TABLE gt_material_doc_hdr INTO ls_material_doc_hdr INDEX 1.
SELECT bukrs
       belnr
       gjahr
       buzei
       hwste
       fwste
       kschl
       kbetr
  FROM bset
  INTO TABLE lt_bset
*  FOR ALL ENTRIES IN gt_material_doc_hdr
  WHERE bukrs = 'SU00'             ""ls_material_doc_hdr-bukrs
  AND   belnr = ls_material_doc_hdr-belnr
  AND   gjahr = ls_material_doc_hdr-gjahr.

*BREAK-POINT.
LOOP AT lt_bset INTO ls_bset.
  CASE ls_bset-kschl.
  WHEN 'MWVS'.
      IF P_WAERS = 'SAR'.
         cgst    = cgst + ls_bset-hwste.
      ELSE.
         cgst    = cgst + ls_bset-fwste.
      ENDIF.
  ENDCASE.
ENDLOOP.

lv_tot1 = ins_val + gv_tot_amt + gv_del_tax + gv_scq  + fri_val + pfl_val.
*tot_tax =  cgst .
tot_tax = ( lv_tot1 * 15 ) / 100.

grand_tot = tot_tax + ins_val + gv_tot_amt + gv_del_tax + gv_scq  + fri_val + pfl_val." +
*grand_tot = tot_tax + ins_val + gv_tot_amt + gv_del_ta + gv_scq  + fri_val + pfl_val." +

net_val  = grand_tot.
