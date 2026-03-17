*&---------------------------------------------------------------------*
*& Report ZSALES_REGISTER_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsales_register_main_new.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
xyz = 'Select Register'(tt1).
AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT zsales_register_new VIA SELECTION-SCREEN AND RETURN.
  ELSEIF r2 = 'X'.
    SUBMIT zfi_sales_register_new VIA SELECTION-SCREEN AND RETURN.
  ENDIF.
