*&---------------------------------------------------------------------*
*& Report ZCFR_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCFR_INFO.

SELECTION-SCREEN :BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS: R1 RADIOBUTTON GROUP rad1 user-command rad.
PARAMETERS: r2 RADIOBUTTON GROUP rad1.
PARAMETERS: r3 RADIOBUTTON GROUP rad1.
PARAMETERS: r4 RADIOBUTTON GROUP rad1.
PARAMETERS: r5 RADIOBUTTON GROUP rad1.
PARAMETERS: r6 RADIOBUTTON GROUP rad1.
SELECTION-SCREEN : END OF BLOCK B1 .



START-OF-SELECTION .
IF R1 = 'X' .
  CALL TRANSACTION  'ZCFR' .
  ENDIF.

  IF R2 = 'X' .
  CALL TRANSACTION  'ZCASHFLOW_HEAD' .
  ENDIF.

  IF R3 = 'X' .
  CALL TRANSACTION  'ZCASHFLOW_ITEM' .
  ENDIF.


  IF R4 = 'X' .
  CALL TRANSACTION  'ZCASHFLOW' .
  ENDIF.

  IF R5 = 'X' .
  CALL TRANSACTION  'ZBDC_CASHFLOW'.
  ENDIF.

    IF R6 = 'X' .
   CALL TRANSACTION 'ZGL_INFO' .
   endif.
