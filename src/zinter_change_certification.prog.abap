*&---------------------------------------------------------------------*
*& Report ZINTER_CHANGE_CERTIFICATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZINTER_CHANGE_CERTIFICATION.


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
xyz = 'Select Interchange Certification'(tt1).
AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT ZINTER_CHANGE_CERT VIA SELECTION-SCREEN AND RETURN.
  ELSEIF r2 = 'X'.
    SUBMIT ZINTER_CHANGE_PURCH_CERT VIA SELECTION-SCREEN AND RETURN.
  ENDIF.
