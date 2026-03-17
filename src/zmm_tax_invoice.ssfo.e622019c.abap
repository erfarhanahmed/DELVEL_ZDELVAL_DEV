

data : gv_amt TYPE PC207-BETRG.
*data : gv_amt1 TYPE konv-kbetr.
clear gv_amt.
gv_amt = wa_final-cenvat. "/ 100.

****
****CALL FUNCTION 'SPELL_AMOUNT'
**** EXPORTING
****   AMOUNT          = gv_amt
****   CURRENCY        = ' '
****   FILLER          = ' '
****   LANGUAGE        = SY-LANGU
**** IMPORTING
****   IN_WORDS        = v_text
****
**** EXCEPTIONS
****   NOT_FOUND       = 1
****   TOO_LARGE       = 2
****   OTHERS          = 3
****          .
****IF sy-subrc <> 0.
***** Implement suitable error handling here
****ENDIF.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num               = gv_amt
 IMPORTING
   AMT_IN_WORDS             = v_text
 EXCEPTIONS
   DATA_TYPE_MISMATCH       = 1
   OTHERS                   = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
