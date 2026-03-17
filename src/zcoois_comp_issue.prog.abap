*&---------------------------------------------------------------------*
*& Report ZCOOIS_COMP_ISSUE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&Transaction : ZCOOIS_COMP_NEW
*&Functional Cosultant: Shahid Attar
*&Technical Consultant: Jyoti MAhajan
*&TR: 1. DEVK915626       PRIMUSABAP   PRIMUS:INDIA:102175:ZCOOIS_NEW_ISSUE:NEW DEVELOPMENT
*     2.  DEVK915646       PRIMUSABAP   PRIMUS:INDIA:101690:ZCOOIS_COMP_ISSUE:CHANGES IN REF FILE
*&Date: 1. 0/07/2025
*&Owner: DelVal Flow Controls
REPORT ZCOOIS_COMP_ISSUE.

INCLUDE ZCOOIS_COMP_ISSUE_TOP.
INCLUDE ZCOOIS_COMP_ISSUE_SS.
INCLUDE ZCOOIS_COMP_ISSUE_DATA.

START-OF-SELECTION.
PERFORM Get_data.
