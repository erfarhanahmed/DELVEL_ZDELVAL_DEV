*&---------------------------------------------------------------------*
*& Report ZPAYMENT_ADVICE_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpayment_advice_main.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc,
            r3 RADIOBUTTON GROUP abc.

SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
  xyz = 'Payment Advice'(tt1).

AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT zpayment_advice  VIA SELECTION-SCREEN AND RETURN.            ""For Full Payment
*    SUBMIT zzpayment_advice  VIA SELECTION-SCREEN AND RETURN.            ""For Full Payment
  ELSEIF r2 = 'X'.
    SUBMIT zpayment_advice_adv VIA SELECTION-SCREEN AND RETURN.         ""For Advance Payment
  ELSEIF r3 = 'X'.
    SUBMIT  zpayment_advice_par VIA SELECTION-SCREEN AND RETURN.        ""For Partial Payment
  ENDIF.
