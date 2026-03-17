
DATA : lv_lgort TYPE lgort_d.

SELECT SINGLE lgort
               FROM vbap
               INTO lv_lgort
               WHERE vbeln = wa_final-vbeln
               AND posnr = wa_final-kdpos.
IF lv_lgort IS NOT INITIAL.
  IF lv_lgort(1) = 'K'.
    lv_flag = abap_true.
  ENDIF.
ENDIF.


















