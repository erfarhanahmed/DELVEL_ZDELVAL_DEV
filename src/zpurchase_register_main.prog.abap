*&---------------------------------------------------------------------*
*& Report ZPURCHASE_REGISTER_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpurchase_register_main.
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc,
            r3 RADIOBUTTON GROUP abc.

SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
  xyz = 'Select Register'(tt1).

AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT zpurchase_register VIA SELECTION-SCREEN AND RETURN.
  ELSEIF r2 = 'X'.
    SUBMIT zpurchase_register_fi VIA SELECTION-SCREEN AND RETURN.
    ELSEIF r3 = 'X'.
    SUBMIT ZGRN_PENDING_INVOICE VIA SELECTION-SCREEN AND RETURN.
  ENDIF.
