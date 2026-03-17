DATA : GRAND_TOTAL_TXT LIKE SPELL,
        amt type MAXBT,
        v_num type p decimals 2,
        amt_txt(200).

data : tran_type.
clear : amt, tran_type, amt_txt.

CASE BKPFTAB-BLART.
  WHEN 'KZ'. "'CASH RECEIPT'
    tran_type = 'H'.
  WHEN 'DZ'. " 'CASH PAYMENT'.
    tran_type = 'S'.
  WHEN 'BR'."'BANK RECEIPT' / "'CONTRA VOUCHER'.
    tran_type = 'S'.
  WHEN 'BP'. "'BANK PAYMENT'
    tran_type = 'H'.
  WHEN 'DG'." 'DEBIT NOTE'
    tran_type = 'H'.
  WHEN 'KG'." 'CREDIT NOTE'
    tran_type = 'H'.
*  WHEN 'JV'." 'JOURNAL VOUCHER'
*    tran_type = 'H'.
  WHEN 'SA'." 'JOURNAL / EXPENSE VOUCHER'
    tran_type = 'H'.
  WHEN 'AA'." 'ASSET PURCHASES'
    tran_type = 'H'.
  WHEN 'AB'." 'ASSET PURCHASES'
    read table bsegtab into wa_bsegtab with key buzei = 1.
    IF sy-subrc = 0.
      tran_type = wa_bsegtab-shkzg.
    ENDIF.
ENDCASE.

" Extract the GL account transaction record
loop at bsegtab INTO WA_BSEGTAB where koart = 'S'
                                  and shkzg = tran_type.
*  amt = amt + WA_BSEGTAB-WRBTR. " Amount in document Currency
  amt = amt + WA_BSEGTAB-DMBTR."amt in local currency
endloop.
if amt is initial.
  if gv_credit_total is INITIAL.
    amt = gv_debit_total. " WRITE gv_debit_total TO gv_debit.
  else.
    amt = gv_credit_total." write gv_credit_total to gv_debit.
  endif.
ENDIF.
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

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
