
    gv_gst_p = '27AACCD2898L1Z4'.


    SELECT SINGLE bukrs
                  belnr
                  gjahr
                  budat
                  blart
                  xblnr
                  bktxt
                  waers
                  kursf
             FROM bkpf
             INTO gs_accounting_doc_hdr
             WHERE belnr = belnr
             AND   gjahr = gjahr.

*BREAK-POINT.
SELECT bukrs
       belnr
       gjahr
       buzei
       dmbtr
       sgtxt
       kunnr
       lifnr
  FROM bseg
  INTO TABLE GT_ACCOUNTING_DOC_ITEM
  WHERE belnr = gs_accounting_doc_hdr-belnr
  AND   gjahr = gs_accounting_doc_hdr-gjahr
  AND   kostl ne space.
*BREAK-POINT.
  SELECT SINGLE SGTXT
           INTO GV_SGTXT
           from bseg
           WHERE belnr = gs_accounting_doc_hdr-belnr
           AND   gjahr = gs_accounting_doc_hdr-gjahr
           AND   SGTXT ne space.
