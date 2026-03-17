
*TRANSLATE wa_bsegtab-sgtxt TO LOWER CASE.
*TRANSLATE wa_bsegtab-kontl TO LOWER CASE.
*
*TRANSLATE wa_bsegtab-sgtxt+0(1) TO UPPER CASE.
*TRANSLATE wa_bsegtab-kontl+0(1) TO UPPER CASE.


*  to write it on the form converting to Text
*  or calculations wrbtr is used as itis.

*  Calculate the debit and credit total

WRITE wa_bsegtab-dmbtr TO wa_currency.
CONDENSE wa_currency NO-GAPS.

IF wa_bsegtab-shkzg EQ 'S'.
CONCATENATE wa_currency '(Dr)'into wa_currency SEPARATED BY SPACE.
  gv_debit_total = gv_debit_total + wa_bsegtab-dmbtr .
ELSE.
CONCATENATE wa_currency '(Cr)'into wa_currency SEPARATED BY SPACE.
  gv_credit_total = gv_credit_total + wa_bsegtab-dmbtr.
ENDIF.

* begin of code by sekhar on 01.01.2008
* for fetching material description
IF wa_bsegtab-matnr IS NOT INITIAL.
  SELECT SINGLE maktx
  FROM makt
  INTO g_maktx
  WHERE matnr = wa_bsegtab-matnr
  AND spras = 'EN'.
ENDIF.
* end of code by sekhar on 01.01.2008

WRITE wa_bsegtab-wrbtr TO wa_currency1.
CONDENSE wa_currency1 NO-GAPS.

*Code added by bhumika
IF wa_bsegtab-koart = 'D'.
  READ TABLE gltext INTO gw_gltext
             WITH KEY kunnr = wa_bsegtab-kunnr.
ELSEIF wa_bsegtab-koart = 'K'.
  READ TABLE gltext INTO gw_gltext
             WITH KEY lifnr = wa_bsegtab-lifnr.
ENDIF.












