  DATA:
    lv_branch           TYPE j_1bbranch-branch,
    ls_material_doc     TYPE zmaterial_doc,
    ls_material_doc_hdr TYPE zmaterial_doc_hdr.

  DATA : LV_BUKRS TYPE BUKRS VALUE 'SU00'.

*BREAK-POINT.
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

SELECT SINGLE * FROM BKPF
                    INTO CORRESPONDING FIELDS OF WA_BKPF
                    WHERE BELNR = ls_material_doc_hdr-belnr
                    AND GJAHR = ls_material_doc_hdr-gjahr
                    AND BUKRS =  LV_BUKRS .

IF WA_BKPF-AWKEY IS NOT INITIAL.

SELECT SINGLE * FROM RSEG
                INTO WA_RSEG
                WHERE BELNR = WA_BKPF-AWKEY.
ENDIF.

IF WA_RSEG IS NOT INITIAL.
    SELECT SINGLE BELNR FROM EKBE
                        INTO @DATA(LV_BELNR)
                        WHERE EBELN = @WA_RSEG-EBELN
                        AND EBELP = @WA_RSEG-EBELP
                        AND BWART = '161' .
    SELECT SINGLE * FROM MSEG
                    INTO WA_MSEG01
                    WHERE MBLNR = LV_BELNR.

    SELECT SINGLE * FROM MKPF
                    INTO WA_MKPF
                    WHERE MBLNR = WA_MSEG01-MBLNR.
ENDIF.
