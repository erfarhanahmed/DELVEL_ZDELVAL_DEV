if w_doc_type NE 'JOURNAL VOUCHER'.
  IF gv_narration IS INITIAL.
    gv_narration = wa_bsegtab-sgtxt.
    CLEAR wa_bsegtab.
  ENDIF.
endif.
*---------------------------------------

if W_DOC_TYPE EQ 'CASH RECEIPT' OR
 W_DOC_TYPE EQ 'CASH PAYMENT' or
 W_DOC_TYPE eq 'DEBIT NOTE' or
 W_DOC_TYPE eq 'CREDIT NOTE'.
  SELECT SINGLE SGTXT
    FROM BSEG
    INTO gv_narration
    WHERE BELNR = bkpftab-belnr.
ELSE.
  gv_narration = bkpftab-bktxt.
ENDIF.

*---------------------------------------
*clear G_BNK_TXT.
*IF w_doc_type EQ 'BANK RECEIPT'.
*G_BNK_TXT = 'Cheque/Draft subject to Vadodara Jurisdiction Part/Full Payment'.
*endif.

