
DATA:
  lv_amt TYPE pc207-betrg.

CLEAR: GV_amount3,GV_TOT_WRD.
*BREAK primus.

  lv_amt = net_val.
  CLEAR gv_amount1.
  CLEAR AMOUNT.
  gv_amount1 = LV_AMT.
  amount = LV_AMT.

  split AMOUNT at '.' Into amt1 Amt2." AMT3.

  CALL FUNCTION 'SPELL_AMOUNT'
  EXPORTING
    AMOUNT          = GV_AMOUNT1
    CURRENCY        = gs_accounting_doc_hdr-waers
*   FILLER          = ' '
    LANGUAGE        = SY-LANGU
  IMPORTING
    IN_WORDS        = gv_AMOUNT2
* EXCEPTIONS
*   NOT_FOUND       = 1
*   TOO_LARGE       = 2
*   OTHERS          = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

GV_AMOUNT3 = GV_AMOUNT2-WORD.
amt2       = GV_AMOUNT2-DECWORD.
CALL FUNCTION 'FI_CONVERT_FIRSTCHARS_TOUPPER'
EXPORTING
  input_string        = gv_AMOUNT3
  SEPARATORS          = ' '
IMPORTING
  OUTPUT_STRING       = gv_AMOUNT3
  .
CALL FUNCTION 'FI_CONVERT_FIRSTCHARS_TOUPPER'
EXPORTING
  input_string        = amt2
  SEPARATORS          = ' '
IMPORTING
  OUTPUT_STRING       = amt2.

if gs_accounting_doc_hdr-waers = 'USD'.
CONCATENATE 'USD:' GV_AMOUNT3 'and Cents' amt2 into net_amount SEPARATED BY space.
ELSEIF gs_accounting_doc_hdr-waers = 'INR'.
 CONCATENATE GV_AMOUNT3 'Rupees' amt2 'Paise' into net_amount SEPARATED BY space.
ELSEIF gs_accounting_doc_hdr-waers = 'EUR'.
 CONCATENATE 'EUR:' GV_AMOUNT3 'and Cents' amt2 into net_amount SEPARATED BY space.
endif.

clear : lv_Amt,AMT1,AMT2.
lv_amt = tot_tax.
CLEAR gv_amount1.
CLEAR AMOUNT.
gv_amount1 = LV_AMT.
amount = LV_AMT.

SPLIT AMOUNT AT '.' INTO amt1 Amt2." AMT3.

CALL FUNCTION 'SPELL_AMOUNT'
EXPORTING
  AMOUNT          = GV_AMOUNT1
  CURRENCY        = gs_accounting_doc_hdr-waers
*   FILLER          = ' '
  LANGUAGE        = SY-LANGU
IMPORTING
  IN_WORDS        = gv_AMOUNT4
* EXCEPTIONS
*   NOT_FOUND       = 1
*   TOO_LARGE       = 2
*   OTHERS          = 3
  .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
GV_AMOUNT5 = GV_AMOUNT4-WORD.
amt2       = GV_AMOUNT4-DECWORD.

CALL FUNCTION 'FI_CONVERT_FIRSTCHARS_TOUPPER'
EXPORTING
  input_string        = gv_AMOUNT5
  SEPARATORS          = ' '
IMPORTING
  OUTPUT_STRING       = gv_AMOUNT5
  .

CALL FUNCTION 'FI_CONVERT_FIRSTCHARS_TOUPPER'
EXPORTING
  input_string        = amt2
  SEPARATORS          = ' '
IMPORTING
  OUTPUT_STRING       = amt2
  .

if gs_accounting_doc_hdr-waers = 'USD'.
*CONCATENATE GV_AMOUNT5 'Dollars' amt2 'Cents' into tax_amount SEPARATED BY space.
CONCATENATE 'USD:' GV_AMOUNT5 'and Cents' amt2 into tax_amount SEPARATED BY space.
ELSEIF gs_accounting_doc_hdr-waers = 'INR'.
CONCATENATE GV_AMOUNT5 'Rupees' amt2 'Paise' INTO tax_amount SEPARATED BY space.
ELSEIF gs_accounting_doc_hdr-waers = 'EUR'.
  CONCATENATE 'EUR:' GV_AMOUNT5 'and Cents' amt2 INTO tax_amount SEPARATED BY space.
ENDIF.
