SELECT SINGLE * FROM MAKT INTO WA_MAKT
  WHERE MATNR = WA_ITEM-MATERIAL.


READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'ZPR0' kinak = ' '.

IF sy-subrc IS INITIAL.
  gv_rate = WA_KONV-kwert / WA_item-fkimg.
  gv_amt  = WA_KONV-kwert.
  gv_qty = gv_qty + WA_ITEM-fkimg.
ENDIF.

IF WA_HDR-BIL_TYPE = 'US08'.
  gv_rate = 0.
  gv_amt  = 0.
ENDIF.

READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'ULOC'.
IF SY-SUBRC = 0.
  GV_ULOC = GV_ULOC + WA_KONV-KWERT.

ENDIF.

READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'USTA'.
IF SY-SUBRC = 0.
  GV_USTA = GV_USTA + WA_KONV-KWERT.

ENDIF.

READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'UCOU'.
IF SY-SUBRC = 0.
  GV_UCOU = GV_UCOU + WA_KONV-KWERT.

ENDIF.

READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'UHF1'.
IF SY-SUBRC = 0.
  GV_UHF1 = GV_UHF1 + WA_KONV-KWERT.

ENDIF.

READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'USC1'.

IF SY-SUBRC = 0.
  GV_USC1 = GV_USC1 + WA_KONV-KWERT.

ENDIF.

READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'UMC1'.
IF SY-SUBRC = 0.
  GV_UMC1 = GV_UMC1 + WA_KONV-KWERT.

ENDIF.

READ TABLE IT_KONV INTO WA_KONV
              WITH KEY kposn = WA_item-ITM_NUMBER
                       kschl = 'UOTH'.
IF SY-SUBRC = 0.
  GV_UOTH = GV_UOTH + WA_KONV-KWERT.

ENDIF.

GV_SUB = gv_amt + GV_SUB.

GV_TOT = GV_SUB + GV_UHF1 + GV_UCOU + GV_USTA +
         GV_ULOC + GV_UMC1 + GV_USC1 +  GV_UOTH.

