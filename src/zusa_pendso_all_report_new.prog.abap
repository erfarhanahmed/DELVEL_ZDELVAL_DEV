*&---------------------------------------------------------------------*
*& Report ZUSA_PENDSO_ALL_REPORT_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUSA_PENDSO_ALL_REPORT_NEW.

SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE   TEXT-001.
  PARAMETERS     : A1 RADIOBUTTON GROUP r,      "Pending so
                   A2 RADIOBUTTON GROUP r.      "Pending So All
SELECTION-SCREEN : END OF BLOCK B1.


AT SELECTION-SCREEN.

IF A1 EQ 'X'.
  SUBMIT ZUSA_PEND_SO_new VIA SELECTION-SCREEN AND RETURN.
ELSEIF A2 EQ 'X'.
  SUBMIT ZUSA_PEND_SO_ALL_new VIA SELECTION-SCREEN AND RETURN.
ENDIF.
