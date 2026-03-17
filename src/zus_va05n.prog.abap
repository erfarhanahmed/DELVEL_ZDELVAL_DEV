*&---------------------------------------------------------------------*
*& Report ZUS_VA05N
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_VA05N.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
*xyz = 'ZUS_VA05N (USA)'(tt1).
AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT ZUS_VA05N_PENDING_SO VIA SELECTION-SCREEN AND RETURN.
  ELSEIF r2 = 'X'.
    SUBMIT  ZUS_VA05N_ALL_SO VIA SELECTION-SCREEN AND RETURN.
  ENDIF.

*INCLUDE ZUS_VA05N_SS.
*INCLUDE ZUS_VA05N_TOP.
*INCLUDE ZUS_VA05N_DATA.
*
*START-OF-SELECTION.
*PERFORM GET_DATA.
*
*AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-group1 = 'BU'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.
