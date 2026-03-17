
DATA:
  lv_amt TYPE pc207-betrg.

CLEAR: GV_GST_WRD,GV_TOT_WRD.

lv_amt = tot_tax.
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

CALL FUNCTION 'FI_CONVERT_FIRSTCHARS_TOUPPER'
EXPORTING
  input_string        = gv_gst_wrd
  SEPARATORS          = ' '
IMPORTING
  OUTPUT_STRING       = gv_gst_wrd
  .

CLEAR lv_amt.
lv_amt = net_val.
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

CALL FUNCTION 'FI_CONVERT_FIRSTCHARS_TOUPPER'
EXPORTING
  input_string        = gv_tot_wrd
  SEPARATORS          = ' '
IMPORTING
  OUTPUT_STRING       = gv_tot_wrd
  .







