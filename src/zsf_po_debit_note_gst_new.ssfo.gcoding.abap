  DATA:
    lv_branch           TYPE j_1bbranch-branch,
    ls_material_doc     TYPE zmaterial_doc,
    ls_material_doc_hdr TYPE zmaterial_doc_hdr.

*BREAK fujiabap.
  READ TABLE gt_material_doc INTO ls_material_doc
                             INDEX 1.
  READ TABLE gt_material_doc_hdr INTO ls_material_doc_hdr
                              INDEX 1.
*break fujiabap.
  SELECT SINGLE j_1bbranch
          FROM  t001w
          INTO lv_branch
          WHERE werks = ls_material_doc-werks.

  SELECT SINGLE gstin
          FROM  j_1bbranch
          INTO  gv_gst_p
          WHERE bukrs  = ls_material_doc_hdr-bukrs
           AND  branch = lv_branch.
  IF gv_gst_p IS INITIAL.
    gv_gst_p = '27AACCD2898L1Z4'.
  ENDIF.

  SELECT bwart
         grund
         grtxt
    FROM t157e
    INTO TABLE gt_t157e
    FOR ALL ENTRIES IN GT_MATERIAL_DOC_HDR
    WHERE bwart = '161'
    AND   grund = GT_MATERIAL_DOC_HDR-grund
    AND   spras = sy-langu.

"Added by Snehal Rajale on 17.02.2021
*BREAK-POINT.
SELECT SINGLE *
FROM j_1ig_invrefnum
INTO gs_zeinv_response
WHERE docno = ls_material_doc_hdr-belnr AND
doc_year = ls_material_doc_hdr-gjahr.

  IF SY-SUBRC = 0.
    gv_irn_no = gs_zeinv_response-irn.

    gv_qrcode2 = gs_zeinv_response-signed_qrcode.
  ENDIF.

