*BREAK-POINT.
IF gv_qrcode2 IS NOT INITIAL.
  LV_DYNAMIC_LEN = STRLEN( GV_QRCODE2 ).
  IF LV_DYNAMIC_LEN GT 765.
    LV_LEN = LV_DYNAMIC_LEN - 765.
    gv_first = GV_QRCODE2(255).
    gv_second = GV_QRCODE2+255(255).
    gv_third = GV_QRCODE2+510(255).
    gv_fourth = GV_QRCODE2+765(lv_len).
  ENDIF.
ENDIF.





















