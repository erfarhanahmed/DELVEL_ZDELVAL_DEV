data w_i type i.

  clear gv_total1.

  gv_total1 = gv_total  + wa_final-cenvat + wa_final-vat +
  wa_final-cst + wa_final-zpnf.



 data : gv_amt1 TYPE PC207-BETRG.
clear gv_amt1.
gv_amt1 = gv_total1 .
***break fujiabap.
CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num               = gv_amt1
 IMPORTING
   AMT_IN_WORDS             = v_text1
 EXCEPTIONS
   DATA_TYPE_MISMATCH       = 1
   OTHERS                   = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
****
****w_i = strlen( v_text1 ).
****subtract 7 from w_i.
****v_text1 = v_text1+0(w_i).
********
****CALL FUNCTION 'SPELL_AMOUNT'
**** EXPORTING
****   AMOUNT          = gv_amt1
****   CURRENCY        = ' '
****   FILLER          = ' '
****   LANGUAGE        = SY-LANGU
**** IMPORTING
****   IN_WORDS        = v_text1
****
**** EXCEPTIONS
****   NOT_FOUND       = 1
****   TOO_LARGE       = 2
****   OTHERS          = 3
****          .
****IF sy-subrc <> 0.
***** Implement suitable error handling here
****ENDIF.














