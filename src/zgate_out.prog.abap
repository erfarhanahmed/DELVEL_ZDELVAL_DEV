*&---------------------------------------------------------------------*
*& Report ZGATE_OUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGATE_OUT.

INCLUDE ZGATE_OUT_SS.
INCLUDE ZGATE_OUT_TOP.
INCLUDE ZGATE_OUT_DATA.
INCLUDE ZGATE_OUT_PBO.


AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-group1 = 'NEE'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.
  PERFORM screen_modify.

START-OF-SELECTION.
PERFORM get_entry.
