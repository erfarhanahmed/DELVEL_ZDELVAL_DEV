

gv_username = bkpftab-USNAM.
TRANSLATE gv_username TO LOWER CASE.
TRANSLATE gv_username+0(1) TO UPPER CASE.

IF w_doc_type EQ 'BANK RECEIPT' OR w_doc_type EQ 'BANK PAYMENT'.
READ TABLE bsegtab WITH KEY belnr = BKPFTAB-belnr
bschl = '50'.

IF sy-subrc EQ 0 AND bsegtab-zuonr = ' '.
READ TABLE bsegtab WITH KEY belnr = BKPFTAB-belnr
bschl = '40'.
ENDIF.
ENDIF.

















