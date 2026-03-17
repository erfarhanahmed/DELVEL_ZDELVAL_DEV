
DATA : lv_lgort TYPE lgort_d.
*BREAK-POINT.
SELECT SINGLE lgort
               FROM vbap
               INTO lv_lgort
               WHERE vbeln = wa_final-vbeln
               AND posnr = wa_final-vbelp.
IF lv_lgort IS NOT INITIAL.
  IF lv_lgort(1) = 'K'.
    lv_flag = abap_true.
  ENDIF.
ENDIF.















