data:  lv_cgst TYPE char3,
       lv_shkzg TYPE bseg-shkzg.

*BREAK-POINT.
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


IF gs_accounting_doc_hdr-blart =  'KG' OR gs_accounting_doc_hdr-blart = 'RE'.

  lv_cgst = 'VST'.
  lv_shkzg = 'S'.
ELSEIF gs_accounting_doc_hdr-blart = 'KR' OR gs_accounting_doc_hdr-blart = 'RE'.

  lv_cgst = 'ESA'.
  lv_shkzg = 'H'.

ENDIF.



SELECT bukrs
       belnr
       gjahr
       buzei
       BUZID
       SHKZG
       dmbtr
       KOSTL
       WRBTR
       sgtxt
       kunnr
       lifnr
       PRCTR
  FROM bseg
  INTO CORRESPONDING FIELDS OF TABLE GT_ACCOUNTING_DOC_ITEM
  WHERE belnr = gs_accounting_doc_hdr-belnr
  AND   gjahr = gs_accounting_doc_hdr-gjahr.
*  AND   KOART = 'K'.
*  AND   kostl ne space.
*BREAK-POINT.

  SELECT SINGLE SGTXT
           INTO GV_SGTXT
           from bseg
           WHERE belnr = gs_accounting_doc_hdr-belnr
           AND   gjahr = gs_accounting_doc_hdr-gjahr
           AND   SGTXT ne space.
