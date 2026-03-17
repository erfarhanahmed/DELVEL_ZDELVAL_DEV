

IF gs_total-srno = '5'.
gs_total-kwert = lv_total.

ENDIF.
IF gs_total-srno = '1'.
gs_total-kwert = lv_total.
*MODIFY gt_total from gs_total INDEX 1 TRANSPORTING kwert .
ENDIF.
