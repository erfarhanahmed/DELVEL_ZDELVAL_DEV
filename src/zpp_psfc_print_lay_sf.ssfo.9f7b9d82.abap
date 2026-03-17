LV_LINES3 = LV_LINES1-TDLINE.
 CLEAR lv_flag1.
data : lv_word type string VALUE 'OXYGEN CLEANING'.
FIND lv_word in lv_lines3.
if sy-subrc = 0.
*  BREAK-POINT.

  lv_flag1 = 2.
ENDIF.












































