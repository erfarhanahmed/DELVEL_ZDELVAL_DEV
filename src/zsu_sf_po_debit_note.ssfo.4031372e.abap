
*break primus.

SELECT SINGLE xblnr from bkpf
       into wa_xblnr
       where BUKRS = 'SU00'
       AND  belnr = GS_MATERIAL_DOC_HDR-belnr
       and   gjahr = GS_MATERIAL_DOC_HDR-gjahr .

SELECT SINGLE * FROM bseg
                    INTO ls_bseg11
                    where BUKRS = 'SU00'
                    AND belnr = GS_MATERIAL_DOC_HDR-belnr
                    and   gjahr = GS_MATERIAL_DOC_HDR-gjahr .














