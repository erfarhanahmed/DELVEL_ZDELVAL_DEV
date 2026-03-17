*&---------------------------------------------------------------------*
*& Report ZPURCHASE1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPURCHASE1.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
  xyz = 'Select Register'(tt1).

AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT zap_purchase_register VIA SELECTION-SCREEN AND RETURN.
  ELSEIF r2 = 'X'.
    SUBMIT zpurchase_register_fi VIA SELECTION-SCREEN AND RETURN.
  ENDIF.
