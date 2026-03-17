*&---------------------------------------------------------------------*
*& Report ZUS_VA05N
*&---------------------------------------------------------------------*
*&Transaction

*&Functional Cosultant: Tejaswini / Jyotikrishna

*&Technical Consultant: Pranit Chavan

*&TR: 1.     DEVK915158       PRIMUSABAP   PRIMUS:USA:102175:ZUS_VA05N:NEW REPORT

*     2.     DEVK915303       PRIMUSABAP   PRIMUS:USA:102175:ZUS_VA05N:NAMING CONVENTIONS

"Created Date : 27.11.2024
*&Owner: DelVal Flow Controls

*&
*&---------------------------------------------------------------------*
REPORT ZUS_VA05N_PENDING_SO.

INCLUDE ZUS_VA05N_TOP.
INCLUDE ZUS_VA05N_SS.
INCLUDE ZUS_VA05N_DATA.

START-OF-SELECTION.
PERFORM GET_DATA.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
