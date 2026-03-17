data: rate TYPE p DECIMALS 3.
DATA:
  ls_conditions TYPE t_conditions.
*BREAK-POINT.
READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'K005' .
IF sy-subrc IS INITIAL.
  GV_CUSTMAT_AMT  = GV_CUSTMAT_AMT + ls_conditions-kwert.
ENDIF.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'K007' .
IF sy-subrc IS INITIAL.
  GV_DISC_AMT  = GV_DISC_AMT + ls_conditions-kwert.
ENDIF.


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

"Added Sanjay
READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'MWAS'.
IF sy-subrc IS INITIAL.
*  gv_taxrate = ls_conditions-kwert / gs_item-fkimg.
*  gv_taxamt  = ls_conditions-kwert.
  gv_mwas  = gv_mwas + ls_conditions-kwert.
  gv_mwas_rate = ls_conditions-kbetr / 10.
ENDIF.
"Ended Sanjay


READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZPFO'.
IF sy-subrc IS INITIAL.
  gv_pf  = gv_pf + ls_conditions-kwert.
  gv_pf_rate = ls_conditions-kbetr / 10.
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
                       kschl = 'ZDC1'.
IF sy-subrc IS INITIAL.
  gv_dc  = gv_dc + ls_conditions-kwert.
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
                       kschl = 'ZOTH'.
IF sy-subrc IS INITIAL.
  gv_OTH  = gv_OTH + ls_conditions-kwert.
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
