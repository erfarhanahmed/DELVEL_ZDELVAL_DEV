SELECT SINGLE * FROM VBrk INTO WA_VBrk
  WHERE VBELN = wa_hdr-BIL_NUMBER.

READ TABLE it_vbrk into wa_vbrk with key vbeln = wa_hdr-BIL_NUMBER.
gv_amt1   = gv_amt.
gv_sub1   = gv_sub.
gv_usta1  = gv_usta.
gv_uloc1  = gv_uloc.
gv_ucou1  = gv_ucou.
gv_uoth1  = gv_uoth.
gv_uhf1_1 = GV_UHF1.
GV_USC1_1 = GV_USC1.
GV_UMC1_1 = GV_UMC1.
gv_tot1   = gv_tot.

if wa_vbrk-fkart = 'US11' and wa_vbrk-fkart_rl = 'LG'.
    "gv_amt1 = -1 * wa_konv-kwert.
    CONCATENATE '-' '$' gv_amt1 into gv_amt1.
    cONCATENATE '-' '$' gv_sub1 into gv_sub1.
    CONCATENATE '-' '$' gv_usta1 into gv_usta1.
    CONCATENATE '-' '$' gv_uloc1 into gv_uloc1.
    CONCATENATE '-' '$' gv_ucou1 into gv_ucou1.
    CONCATENATE '-' '$' gv_uoth1 into gv_uoth1.
    CONCATENATE '-' '$' gv_uhf1_1 into gv_uhf1_1.
    CONCATENATE '-' '$' GV_USC1_1 INTO GV_USC1_1.
    CONCATENATE '-' '$' GV_UmC1_1 INTO GV_UmC1_1.
    CONCATENATE '-' '$' GV_tot1 INTO GV_tot1.
   " CONCATENATE '-' '$' GV_rate1 INTO GV_rate1.

    else .

      CONCATENATE '$' gv_amt1 into gv_amt1.
      cONCATENATE '$' gv_sub1 into gv_sub1.
      CONCATENATE '$' gv_usta1 into gv_usta1.
      CONCATENATE '$' gv_uloc1 into gv_uloc1.
      CONCATENATE '$' gv_ucou1 into gv_ucou1.
      CONCATENATE '$' gv_uoth1 into gv_uoth1.
      CONCATENATE '$' gv_uhf1_1 into gv_uhf1_1.
      CONCATENATE '$' GV_USC1_1 INTO GV_USC1_1.
      CONCATENATE '$' GV_UmC1_1 INTO GV_UmC1_1.
       CONCATENATE '$' GV_tot1 INTO GV_tot1.
       "CONCATENATE '-' '$' GV_rate1 INTO GV_rate1.


ENDIF.












