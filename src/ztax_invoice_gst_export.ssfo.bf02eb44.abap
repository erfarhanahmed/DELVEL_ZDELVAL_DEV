



gv_sub_tot = gv_pf + gv_fri + gv_ins
            + gv_test + gv_tot_amt.

gv_t_gst = gv_cgst + gv_sgst + gv_igst.

gv_grand_tot = gv_sub_tot + gv_t_gst + gv_tcs.

DATA:
  lv_amt TYPE pc207-betrg.

lv_amt = gv_t_gst.
CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num         = lv_amt
  IMPORTING
    amt_in_words       = gv_gst_wrd
  EXCEPTIONS
    data_type_mismatch = 1
    OTHERS             = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

CLEAR lv_amt.
lv_amt = gv_grand_tot.
CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num         = lv_amt
  IMPORTING
    amt_in_words       = gv_tot_wrd
  EXCEPTIONS
    data_type_mismatch = 1
    OTHERS             = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.














