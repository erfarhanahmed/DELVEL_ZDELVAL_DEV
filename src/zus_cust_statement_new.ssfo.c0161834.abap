
*ORIGINAL = wa_itab-debit.
CLEAR : ORIGINAL,ORIGINAL1.
IF wa_itab-debit < 0.
  ORIGINAL = wa_itab-debit * -1.
*CONCATENATE '(' ORIGINAL ')' INTO ORIGINAL.
ELSE.
  ORIGINAL1 = wa_itab-debit.
ENDIF.
















