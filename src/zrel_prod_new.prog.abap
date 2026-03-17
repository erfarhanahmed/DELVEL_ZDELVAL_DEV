*&---------------------------------------------------------------------*
*& Report ZREL_PROD_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREL_PROD_NEW.


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
xyz = 'Release Production Order'(tt1).
AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT ZREL_PRODUCTION_ORDER VIA SELECTION-SCREEN AND RETURN.
  ELSEIF r2 = 'X'.
    SUBMIT ZREL_PROD_COMP  VIA SELECTION-SCREEN AND RETURN.
  ENDIF.
