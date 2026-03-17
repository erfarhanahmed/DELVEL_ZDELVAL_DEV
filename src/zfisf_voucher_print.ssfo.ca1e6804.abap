
DATA : GRAND_TOTAL_TXT LIKE SPELL,
        amt  type MAXBT,
        v_int TYPE int4,
        v_num type n,
        amt_txt(200).

if gv_credit_total is INITIAL.
  amt = gv_debit_total. " WRITE gv_debit_total TO gv_debit.
else.
  amt = gv_credit_total." write gv_credit_total to gv_debit.
endif.

*WRITE amt to gv_debit.
*CONDENSE gv_debit NO-GAPS.
*
**GRAND_TOTAL_TXT
*CALL FUNCTION 'SPELL_AMOUNT'
* EXPORTING
*   AMOUNT          = amt
*   CURRENCY        = 'INR'
**   FILLER          = ' '
**   LANGUAGE        = SY-LANGU
* IMPORTING
*   IN_WORDS        = GRAND_TOTAL_TXT
* EXCEPTIONS
*   NOT_FOUND       = 1
*   TOO_LARGE       = 2
*   OTHERS          = 3
*          .
*IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ENDIF.
*
*v_int = amt." gv_debit_total.
*v_num = amt - v_int.  " gv_debit_total - v_int.
*IF v_num ne '0.00'.
*  CONCATENATE 'Rupees' GRAND_TOTAL_TXT-WORD 'And' GRAND_TOTAL_TXT-DECWORD 'Paise Only' INTO gv_debit_words SEPARATED BY ' '.
*else.
*  CONCATENATE 'Rupees' GRAND_TOTAL_TXT-WORD 'Only' INTO gv_debit_words SEPARATED BY ' '.
*ENDIF.
*
*perform CONVERT_TO_CAPITALISED changing gv_debit_words.

"..........................................................
WRITE amt to gv_debit.
CONDENSE gv_debit NO-GAPS.
CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  exporting AMT_IN_NUM = amt
  importing AMT_IN_WORDS = amt_txt
  EXCEPTIONS
  DATA_TYPE_MISMATCH = 1
  OTHERS             = 2.
IF sy-subrc = 0.
  find 'paise' in amt_txt ignoring case.
  IF sy-subrc = 0.
    replace 'Rupees' in amt_txt with 'And'.
  else.
    replace 'Rupees' in amt_txt with space.
  ENDIF.
  condense amt_txt.
  concatenate 'Rupees' amt_txt 'Only.' into gv_debit_words separated by space.
else.
  "GRAND_TOTAL_TXT
  CALL FUNCTION 'SPELL_AMOUNT'
   EXPORTING
     AMOUNT          = amt
     CURRENCY        = 'INR'
*     FILLER          = ' '
*     LANGUAGE        = SY-LANGU
   IMPORTING
     IN_WORDS        = GRAND_TOTAL_TXT
   EXCEPTIONS
     NOT_FOUND       = 1
     TOO_LARGE       = 2
     OTHERS          = 3
            .
  IF sy-subrc <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  v_num = amt - floor( amt ).
  IF v_num > 0.
    CONCATENATE 'Rupees' GRAND_TOTAL_TXT-WORD 'And' GRAND_TOTAL_TXT-DECWORD 'Paise Only' INTO gv_debit_words SEPARATED BY ' '.
  else.
    CONCATENATE 'Rupees' GRAND_TOTAL_TXT-WORD 'Only' INTO gv_debit_words SEPARATED BY ' '.
  ENDIF.
ENDIF.

perform CONVERT_TO_CAPITALISED changing gv_debit_words.

condense gv_debit_words.
