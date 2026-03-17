*DATA: rate TYPE p DECIMALS 3.
*DATA:
*      ls_conditions TYPE t_conditions.
*
*READ TABLE gt_conditions INTO ls_conditions
*WITH KEY kposn = gs_item-posnr
*kschl = 'ZTCS'.
*IF sy-subrc IS INITIAL.
*  gv_tcs  = gv_tcs + ls_conditions-kwert.
*  gv_tcs_rt = ls_conditions-kbetr / 10.
*ENDIF.
*
*
*READ TABLE gt_conditions INTO ls_conditions
*WITH KEY kposn = gs_item-posnr
*kschl = 'JTC1'.
*IF sy-subrc IS INITIAL.
*  gv_tcs  = gv_tcs + ls_conditions-kwert.
*  gv_tcs_rt = ls_conditions-kbetr / 10.
*ENDIF.
*
*READ TABLE gt_conditions INTO ls_conditions
*WITH KEY kposn = gs_item-posnr
*kschl = 'JTC2'.
*IF sy-subrc IS INITIAL.
*  gv_tcs  = gv_tcs + ls_conditions-kwert.
*  gv_tcs_rt = ls_conditions-kbetr / 10.
*
*ENDIF.

*DATA:
*      lv_amt TYPE pc207-betrg.

lv_amt = gv_tcs.
CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
EXPORTING
  amt_in_num         = lv_amt
IMPORTING
  amt_in_words       = gv_tcs_wrd
EXCEPTIONS
  data_type_mismatch = 1
  OTHERS             = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

*CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
*EXPORTING
*  input_string        = gv_tcs_wrd
*  SEPARATORS          = ' '
*IMPORTING
*  OUTPUT_STRING       = gv_tcs_wrd
  .


















