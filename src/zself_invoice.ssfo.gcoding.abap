
    gv_gst_p = '27AACCD2898L1Z4'.


    SELECT SINGLE bukrs
                  belnr
                  gjahr
                  bldat
                  budat
                  blart
                  xblnr
                  bktxt
                  waers
                  kursf
                  xblnr_alt
             FROM bkpf
             INTO gs_accounting_doc_hdr
             WHERE belnr = belnr
             AND   gjahr = gjahr.

SHIFT gs_accounting_doc_hdr-xblnr_alt LEFT DELETING LEADING '0'.
*BREAK-POINT.
SELECT bukrs
       belnr
       gjahr
       buzei
       dmbtr
       sgtxt
       kunnr
       lifnr
       hsn_sac
  FROM bseg
  INTO TABLE GT_ACCOUNTING_DOC_ITEM
  WHERE belnr = gs_accounting_doc_hdr-belnr
  AND   gjahr = gs_accounting_doc_hdr-gjahr
  AND   ktosl eq space.
*BREAK-POINT.
  SELECT SINGLE SGTXT
           INTO GV_SGTXT
           from bseg
           WHERE belnr = gs_accounting_doc_hdr-belnr
           AND   gjahr = gs_accounting_doc_hdr-gjahr
           AND   SGTXT ne space.
