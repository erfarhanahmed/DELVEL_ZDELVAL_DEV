*&---------------------------------------------------------------------*
*& Report ZUSA_PENDSO_ALL_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUSA_PENDSO_ALL_REPORT.


SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE GITL."  TEXT-001.
  PARAMETERS     : A1 RADIOBUTTON GROUP r,      "Pending so
                   A2 RADIOBUTTON GROUP r.      "Pending So All
SELECTION-SCREEN : END OF BLOCK B1.


AT SELECTION-SCREEN.

IF A1 EQ 'X'.
  SUBMIT ZUSA_PEND_SO VIA SELECTION-SCREEN AND RETURN.
ELSEIF A2 EQ 'X'.
  SUBMIT ZUSA_PEND_SO_ALL VIA SELECTION-SCREEN AND RETURN.
ENDIF.
