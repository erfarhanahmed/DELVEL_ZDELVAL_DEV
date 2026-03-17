CLEAR : wa_bseg,
        wa_lfa1,
        wa_kna1, wa_skat, wa_anla, gv_tot,gv_tot1.
*BREAK-POINTT.
select  bukrs
        gjahr
        belnr
        koart
        hkont
        lifnr
        kunnr
        anln1
        dmbtr
        shkzg
        wrbtr
        sgtxt
   from bseg
   into table it_bseg
  WHERE belnr = belnr
    AND gjahr = gjahr
    AND BUKRS = WA_FINAL1-BUKRS.

wa_final = wa_final1.

*DATA:str TYPE char255.
*str = 'شركة دلفال فلو كونترولز الشرق الأوسط المحدودة'.
*CALL FUNCTION 'STRING_REVERSE'
*  EXPORTING
*    STRING          = str
*    LANG            = 'A'
* IMPORTING
*   RSTRING         = lv_invno.
*
*lv_invno = lv_invno.
