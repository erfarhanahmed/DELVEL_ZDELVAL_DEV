CLEAR : wa_bseg,
        wa_lfa1,
        wa_kna1, wa_skat, wa_anla, gv_tot,gv_tot1.

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
   from bseg
   into table it_bseg
  WHERE belnr = belnr
    AND gjahr = gjahr
    AND BUKRS = WA_FINAL1-BUKRS.

wa_final = wa_final1.
