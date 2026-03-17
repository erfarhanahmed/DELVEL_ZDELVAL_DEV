data : lv_percentage type p decimals 2.
lv_percentage = GV_TOTAL_VALUE * GV_disc / 100.


*TOT_DISC = GV_TOTAL_VALUE - lv_percentage.
TOT_DISC =  lv_percentage.
*concatenate '$' TOT_DISC INTO TOT_DISC.















