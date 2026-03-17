data: rate TYPE p DECIMALS 3.
DATA:
  ls_conditions TYPE t_conditions.


READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'JOIG' kstat = ' '.
IF sy-subrc IS INITIAL.
  gv_igst  = gv_igst + ls_conditions-kwert.
  gv_i_rate = ls_conditions-kbetr / 10.
ENDIF.
READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'JOCG'.
IF sy-subrc IS INITIAL.
  gv_cgst  = gv_cgst + ls_conditions-kwert.
  gv_c_rate = ls_conditions-kbetr / 10.
ENDIF.
READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'JOSG'.
IF sy-subrc IS INITIAL.
  gv_sgst  = gv_sgst + ls_conditions-kwert.
  gv_s_rate = ls_conditions-kbetr / 10.
ENDIF.
READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZPFO'.
IF sy-subrc IS INITIAL.
  gv_pf  = gv_pf + ls_conditions-kwert.
*  gv_s_rate = ls_conditions-kbetr / 10.
ENDIF.
READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZFR1'.
IF sy-subrc IS INITIAL.
  gv_fri  = gv_fri + ls_conditions-kwert.
*  gv_s_rate = ls_conditions-kbetr / 10.
ENDIF.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZFR2'.
IF sy-subrc IS INITIAL.
  gv_fri  = gv_fri + ls_conditions-kwert.
*  gv_s_rate = ls_conditions-kbetr / 10.
ENDIF.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZIN1'.
IF sy-subrc IS INITIAL.
  gv_ins  = gv_ins + ls_conditions-kwert.
*  gv_s_rate = ls_conditions-kbetr / 10.
ENDIF.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZIN2'.
IF sy-subrc IS INITIAL.
  gv_ins  = gv_ins + ls_conditions-kwert.
*  gv_s_rate = ls_conditions-kbetr / 10.
ENDIF.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZTE1'.
IF sy-subrc IS INITIAL.
  gv_test  = gv_test + ls_conditions-kwert.
*  gv_s_rate = ls_conditions-kbetr / 10.
ENDIF.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZTCS'.
IF sy-subrc IS INITIAL.
*  gv_tcs  = gv_tcs + ls_conditions-kwert.
  gv_tcs_rt = ls_conditions-kbetr / 10.
ENDIF.


READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'JTC1'.
IF sy-subrc IS INITIAL.
*  gv_tcs  = gv_tcs + ls_conditions-kwert.
  gv_tcs_rt = ls_conditions-kbetr / 10.
ENDIF.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'JTC2'.
IF sy-subrc IS INITIAL.
*  gv_tcs  = gv_tcs + ls_conditions-kwert.
  gv_tcs_rt = ls_conditions-kbetr / 10.

ENDIF.







