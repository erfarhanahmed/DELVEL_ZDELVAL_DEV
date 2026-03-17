
v_text = wa_item-netpr.
SHIFT v_text LEFT DELETING LEADING ' '.
**DATA : it_xkomv TYPE komv OCCURS 0 WITH HEADER LINE.
**DATA : it_taxcom TYPE taxcom.
**
***BREAK fujiabap.
**it_taxcom-bukrs	= wa_hdr-bukrs.
**it_taxcom-budat	= wa_hdr-aedat.
**it_taxcom-bldat	= wa_hdr-aedat.
**it_taxcom-waers	= wa_hdr-waers.
**it_taxcom-hwaer	= wa_hdr-waers.
**it_taxcom-wrbtr = wa_item-netwr.
**it_taxcom-mwskz = wa_item-mwskz.
**it_taxcom-lifnr	= wa_hdr-lifnr.
**it_taxcom-ekorg = wa_hdr-ekorg.
**it_taxcom-ebeln = wa_hdr-ebeln.
**it_taxcom-ebelp	= wa_item-ebelp.
**it_taxcom-kposn	= wa_item-ebelp.
**
**
**
**CALL FUNCTION 'CALCULATE_TAX_ITEM'
**  EXPORTING
**    dialog              = 'DIAKZ'
**    display_only        = 'X'
**    i_taxcom            = it_taxcom
**  TABLES
**    t_xkomv             = it_xkomv
**  EXCEPTIONS
**    mwskz_not_defined   = 1
**    mwskz_not_found     = 2
**    mwskz_not_valid     = 3
**    steuerbetrag_falsch = 4
**    country_not_found   = 5
**    txjcd_not_valid     = 6
**    OTHERS              = 7.
**IF sy-subrc <> 0.
*** Implement suitable error handling here
**ENDIF.
**
**
**
**READ TABLE it_xkomv WITH KEY kschl = 'JCIG'. " AND
**IF sy-subrc IS INITIAL.
***        it_xkomv-kposn = itabs-ebelp.
**  cgst = cgst + it_xkomv-kwert.
**  kb_cgst = it_xkomv-kbetr.
**
**ENDIF.
**
**READ TABLE it_xkomv WITH KEY kschl = 'JSIG'. " AND
**IF sy-subrc IS INITIAL.
***        it_xkomv-kposn = itabs-ebelp.
**  sgst = sgst + it_xkomv-kwert.
**  kb_sgst = it_xkomv-kbetr.
**ENDIF.
***BREAK-POINT.
**READ TABLE it_xkomv WITH KEY kschl = 'JIIG'. " AND
**IF sy-subrc IS INITIAL.
***        it_xkomv-kposn = itabs-ebelp.
**  igst = igst + it_xkomv-kwert.
**  kb_igst = it_xkomv-kbetr.
**ENDIF.
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
