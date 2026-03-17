
    gv_gst_p = '27AACCD2898L1Z4'.
data:
  lv_igst type char3,
  lv_cgst TYPE char3,
  lv_shkzg TYPE bseg-shkzg.


    SELECT SINGLE bukrs
                  belnr
                  gjahr
                  blart
                  budat
                  xblnr
                  bktxt
                  waers
                  kursf
             FROM bkpf
             INTO gs_accounting_doc_hdr
             WHERE belnr = belnr
             AND   gjahr = gjahr.

*BREAK-POINT.
IF gs_accounting_doc_hdr-blart = 'DG'.
  lv_igst = 'JII'.
  lv_cgst = 'JIC'.
  lv_shkzg = 'S'.
ELSEIF gs_accounting_doc_hdr-blart = 'DR'.
  lv_igst = 'JOI'.
  lv_cgst = 'JOC'.
  lv_shkzg = 'H'.
*------------------ANJALI DT:17.04.2018------------
ELSEIF gs_accounting_doc_hdr-blart = 'DV'.
  lv_igst = 'JOI'.
  lv_cgst = 'JOC'.
  lv_shkzg = 'H'.
ENDIF.
*--------------------------------------------------
***    SELECT bukrs
***           belnr
***           gjahr
***           buzei
***           shkzg
***           wrbtr
***           fwbas
***           sgtxt
***           kunnr
***           lifnr
***           vbel2
***           hsn_sac
***      FROM bseg
***      INTO TABLE gt_accounting_doc_item
***      WHERE belnr = gs_accounting_doc_hdr-belnr
***      AND   gjahr = gs_accounting_doc_hdr-gjahr
***      AND koart = 'S'
***      AND shkzg = lv_shkzg
***      AND ktosl = lv_cgst.
***
***IF gt_accounting_doc_item is INITIAL.
***    SELECT bukrs
***           belnr
***           gjahr
***           buzei
***           shkzg
***           wrbtr
***           fwbas
***           sgtxt
***           kunnr
***           lifnr
***           vbel2
***           hsn_sac
***      FROM bseg
***      INTO TABLE gt_accounting_doc_item
***      WHERE belnr = gs_accounting_doc_hdr-belnr
***      AND   gjahr = gs_accounting_doc_hdr-gjahr
***      AND koart = 'S'
***      AND shkzg = lv_shkzg
***      AND ktosl = lv_igst.
***ENDIF.

*IF gt_accounting_doc_item is INITIAL.
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
      INTO TABLE gt_accounting_doc_item
      WHERE belnr = gs_accounting_doc_hdr-belnr
      AND   gjahr = gs_accounting_doc_hdr-gjahr
      AND   koart = 'S'
      AND   ktosl = space.
*ENDIF.

*BREAK-POINT.
    SELECT SINGLE sgtxt
             INTO gv_sgtxt
             FROM bseg
             WHERE belnr = gs_accounting_doc_hdr-belnr
             AND   gjahr = gs_accounting_doc_hdr-gjahr
             AND   sgtxt NE space.

    SELECT SINGLE zuonr
              INTO gv_zuonr
              FROM bseg
              WHERE belnr = gs_accounting_doc_hdr-belnr
              AND   gjahr = gs_accounting_doc_hdr-gjahr
              AND   zuonr NE space.

*   BREAK primus.
SELECT SINGLE BUKRS
              BELNR
              GJAHR
              BUZEI
              rebzg
             INTO ls_bseg_inv
             FROM bseg
             WHERE belnr = gs_accounting_doc_hdr-belnr
             AND   gjahr = gs_accounting_doc_hdr-gjahr
             AND   rebzg NE space.

   SELECT SINGLE bldat
          INTO gv_bldat
          FROM bkpf
          WHERE belnr = ls_bseg_inv-rebzg
          and gjahr = ls_bseg_inv-gjahr
          AND BUKRS = ls_bseg_inv-bukrs.


"Added by Snehal Rajale on 29.12.2020
*BREAK-POINT.
SELECT SINGLE *
FROM j_1ig_invrefnum
INTO gs_zeinv_response
WHERE docno = gs_accounting_doc_hdr-belnr AND
      doc_year = gs_accounting_doc_hdr-gjahr.

IF SY-SUBRC = 0.
  gv_irn_no = gs_zeinv_response-irn.

  gv_qrcode2 = gs_zeinv_response-signed_qrcode.
ENDIF.
