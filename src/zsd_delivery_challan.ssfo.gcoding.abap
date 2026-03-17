*BREAK fujiabap.
*break primusabap.
SELECT vbeln
       posnr
       vgbel
       vgpos
       matnr
       arktx
       fkimg
       vrkme
       netwr
       werks
       lgort "added by jyotion 13.06.2024
  FROM vbrp
  INTO TABLE gt_item
  WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.

IF NOT gt_item IS INITIAL.
  SELECT vbeln
         knumv FROM vbrk INTO TABLE it_vbrk
         FOR ALL ENTRIES IN gt_item
         WHERE vbeln = gt_item-vbeln.
  SELECT matnr
         werks
         steuc
         dispo
    FROM marc
    INTO TABLE gt_marc
    FOR ALL ENTRIES IN gt_item
    WHERE matnr = gt_item-matnr
      AND werks = gt_item-werks.
ENDIF.
IF it_vbrk IS NOT INITIAL.
SELECT knumv
       kposn
       kschl
       kawrt
       kbetr
       kwert FROM konv INTO TABLE it_konv
       FOR ALL ENTRIES IN it_vbrk
       WHERE knumv = it_vbrk-knumv.
ENDIF.

********added by jyoti on 14.06.2024***********
DATA:
  lt_j_1ig_subcon TYPE tt_j_1ig_subcon,
  ls_j_1ig_subcon TYPE t_j_1ig_subcon.
*BREAK primus.
**BREAK-POINT.
SELECT bukrs
       mblnr
       mjahr
       zeile
       chln_inv
       bwart     "added by pankaj 12.10.2021
       item
       menge
       meins
       matnr
  FROM j_1ig_subcon
  INTO TABLE gt_j_1ig_subcon
  FOR ALL ENTRIES IN gt_item
  WHERE chln_inv = gt_item-vbeln.


  IF NOT gt_j_1ig_subcon is INITIAL.
    SELECT mblnr
           mjahr
           zeile
           bwart    "added by pankaj 12.10.2021
           matnr    "added by pankaj 12.10.2021
           ebeln
           ebelp
           lgort
      FROM mseg
      INTO TABLE gt_mat_doc
      FOR ALL ENTRIES IN gt_j_1ig_subcon
      WHERE mblnr = gt_j_1ig_subcon-mblnr
      AND   mjahr = gt_j_1ig_subcon-mjahr
*      AND   zeile = gt_j_1ig_subcon-zeile
      "code added by panka 12.10.2021
      AND   bwart = '541'  "Commented by Pankaj 10.11.21 '543'   "gt_j_1ig_subcon-bwart
      AND   matnr = gt_j_1ig_subcon-matnr
      and xauto ne 'X'.
endif.
*********************************************
*READ TABLE at gt_mat_doc into DAta(gs_mat_doc).
*   S_LGORT = gs_item-LGORT.
**  S_werks = gs_item-werks..
*endloop.


LOOP AT gt_item INTO GS_ITEM.
wa_final-vbeln   = gs_item-vbeln.
wa_final-posnr   = gs_item-posnr.
wa_final-vgbel   = gs_item-vgbel.
wa_final-vgpos   = gs_item-vgpos.
wa_final-matnr   = gs_item-matnr.
wa_final-arktx   = gs_item-arktx.
wa_final-fkimg   = gs_item-fkimg.
wa_final-vrkme   = gs_item-vrkme.
wa_final-netwr   = gs_item-netwr.
wa_final-werks   = gs_item-werks.
READ TABLE gt_j_1ig_subcon INTO DATA(gs_j_1ig_subcon) with key
                                   chln_inv = wa_final-vbeln.
READ TABLE gt_mat_doc into DAta(gs_mat_doc) with key mblnr = gs_j_1ig_subcon-mblnr
                                                     lgort+0(1) = 'K'.
   S_LGORT = gs_mat_doc-LGORT.

READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_final-vbeln.
IF sy-subrc = 0.

ENDIF.


*READ TABLE gt_marc INTO gs_marc WITH KEY matnr = wa_final-matnr
*                                         werks = wa_final-werks.
*  IF sy-subrc = 0.
*
*  ENDIF.

LOOP AT it_konv INTO wa_konv WHERE knumv = wa_vbrk-knumv AND kposn = wa_final-posnr.
CASE wa_konv-kschl.
  WHEN 'JOCG'.
    wa_final-cgst = wa_konv-kbetr / 10.
    wa_final-cgst_amt = wa_konv-kwert.
  WHEN 'JOSG'.
    wa_final-sgst = wa_konv-kbetr / 10.
    wa_final-sgst_amt = wa_konv-kwert.
  WHEN 'JOIG'.
    wa_final-igst = wa_konv-kbetr / 10.
    wa_final-igst_amt = wa_konv-kwert.
ENDCASE.
ENDLOOP.
**********added by jyoti on 13.06.2024
*  S_LGORT = gs_item-LGORT.
  S_werks = gs_item-werks..
*****************************************
APPEND wa_final TO it_final.
CLEAR wa_final.
ENDLOOP.
