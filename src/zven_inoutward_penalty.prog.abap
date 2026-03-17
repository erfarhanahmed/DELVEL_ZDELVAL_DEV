*&---------------------------------------------------------------------*
*& Report ZVEN_INOUTWARD_PENALTY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVEN_INOUTWARD_PENALTY.

SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE GITL."  TEXT-001.
  PARAMETERS     : A1 RADIOBUTTON GROUP r,      "Inward
                   A2 RADIOBUTTON GROUP r,      "Outward
                   A3 RADIOBUTTON GROUP r.      "Penalty

SELECTION-SCREEN : END OF BLOCK B1.


AT SELECTION-SCREEN.


IF A1 EQ 'X'.
  SUBMIT ZVENDOR_INWARD_REPORT VIA SELECTION-SCREEN AND RETURN.
ELSEIF A2 EQ 'X'.
  SUBMIT ZVENDOR_OUTWARD_REPORT VIA SELECTION-SCREEN AND RETURN.
ELSEIF A3 EQ 'X'.
  SUBMIT ZVENDOR_PENALTY_REPORT VIA SELECTION-SCREEN AND RETURN.
ENDIF.
