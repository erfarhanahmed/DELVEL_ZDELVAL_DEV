
*break primus.

SELECT SINGLE xblnr from bkpf
       into wa_xblnr
       where belnr = GS_MATERIAL_DOC_HDR-belnr
       and   gjahr = GS_MATERIAL_DOC_HDR-gjahr .






















