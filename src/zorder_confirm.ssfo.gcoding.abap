
CLEAR: wa_final ,lv_total_amt, lv_cgst_tot,
       lv_sgst_tot,lv_igst_tot,lv_total_qty,
       lv_pf,lv_zin1,lv_zfr1,lv_zte1,lv_ztcs
.
BREAK-POINT.
READ TABLE it_final INTO wa_final INDEX 1.

SELECT adrnr,parvw  FROM vbpa
 INTO TABLE @DATA(lt_vbpa)
  WHERE vbeln = @LV_VBELN"@wa_final-vbeln
  AND      posnr = ' '
  AND ( parvw = 'AG' OR parvw = 'WE' ).

IF lt_vbpa IS NOT INITIAL.

  LOOP AT lt_vbpa ASSIGNING FIELD-SYMBOL(<f1>).

    CASE <f1>-parvw.
      WHEN 'AG'.
        SELECT SINGLE * FROM adrc INTO ls_adrc_ag
       WHERE addrnumber = <f1>-adrnr.
        IF ls_adrc_AG-COUNTRY = 'IN' .
         SELECT SINGLE bezei FROM zgst_region1
           INTO lv_state_ag
           WHERE region = ls_adrc_AG-region.
         ENDIF.
      WHEN 'WE'.
        SELECT SINGLE * FROM adrc INTO ls_adrc_we
              WHERE addrnumber = <f1>-adrnr.
        IF ls_adrc_we-COUNTRY = 'IN' .
           SELECT SINGLE bezei FROM zgst_region1
           INTO lv_state_we
           WHERE region = ls_adrc_we-region.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.

ENDIF.





CLEAR WA_FINAL.
