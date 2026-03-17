
clear gv_amt.
gv_amt = gv_tot.

CALL FUNCTION 'SPELL_AMOUNT'
 EXPORTING
   AMOUNT          = gv_tot
   CURRENCY        = 'USD'
*   FILLER          = ' '
   LANGUAGE        = SY-LANGU
 IMPORTING
   IN_WORDS        = gv_wrd
* EXCEPTIONS
*   NOT_FOUND       = 1
*   TOO_LARGE       = 2
*   OTHERS          = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

IF gv_wrd-DECWORD NE 'ZERO'.
  CONCATENATE gv_wrd-WORD 'DOLLAR' gv_wrd-DECWORD 'CENTS ONLY'
  INTO gv_amt_wrd SEPARATED BY space.
ELSE.
  CONCATENATE gv_wrd-WORD 'DOLLAR ONLY'
  INTO gv_amt_wrd SEPARATED BY space.
ENDIF.

*CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
*  EXPORTING
*    amt_in_num               = gv_amt
* IMPORTING
*   AMT_IN_WORDS             = gv_amt_wrd
** EXCEPTIONS
**   DATA_TYPE_MISMATCH       = 1
**   OTHERS                   = 2
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*
*
*
*REPLACE 'Rupees' IN gv_amt_wrd with 'DOLLAR'.
*REPLACE 'Paise'  IN gv_amt_wrd with 'CENTS ONLY'.
*REPLACE 'LAKH' IN gv_amt_wrd with ''.
*
















