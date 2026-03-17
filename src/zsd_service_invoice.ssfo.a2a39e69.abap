
DATA : v_amt1 TYPE pc207-betrg.

*V_AMT = GS_HD_KOMK-FKWRT.
*V_AMT1 = V_AMT.

v_amt1 = gv_total.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num         = v_amt1
  IMPORTING
    amt_in_words       = amt_in_num
  EXCEPTIONS
    data_type_mismatch = 1
    OTHERS             = 2.

IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.


FIND 'Paise' IN amt_in_num.
IF sy-subrc = 0.
  REPLACE ALL OCCURRENCES OF 'Paise' IN amt_in_num WITH ' '.
  REPLACE ALL OCCURRENCES OF 'Rupees' IN amt_in_num WITH 'and Paise'.
ELSE.
  REPLACE ALL OCCURRENCES OF 'Rupees' IN amt_in_num WITH ' '.
ENDIF.
