
CASE wa_final-auart.
  WHEN 'ZEXP' OR 'ZDEX'.
  WA_FINAL-GRAND = LV_TOTAL_AMT .
  WHEN OTHERS.
    WA_FINAL-GRAND = LV_TOTAL_AMT + LV_CGST_TOT
                + LV_SGST_TOT + LV_IGST_TOT.
ENDCASE.























