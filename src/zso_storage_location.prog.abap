*&---------------------------------------------------------------------*
*& Report ZSO_STORAGE_LOCATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSO_STORAGE_LOCATION.
*&---------------------------------------------------------------------*
* 1.PROGRAM OWNER           : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : SO STORAGE LOCATION REPORT DEVLOPMENT
* 3.PROGRAM NAME            : ZSO_STORAGE_LOCATION
* 4.TRANS CODE              : ZSO_SLOC
* 5.MODULE NAME             : SD.
* 6.REQUEST NO              : DEVK914338   PRIMUS:INDIA:101035:SO Storage Location
* 7.CREATION DATE           : 26.06.2024.
* 8.CREATED BY              : SAKSHI DALVI
* 9.FUNCTIONAL CONSULTANT   : TEJASWINI KAPADNIS
* 10.BUSINESS OWNER         : DELVAL.
*&---------------------------------------------------------------------*
INCLUDE ZSO_STORAGE_LOCATION_TOP.    " Data Declarations

INCLUDE ZSO_STORAGE_LOCATION_SCREEN.  " Selection Screen

INCLUDE ZSO_STORAGE_LOCATION_LOGIC.   " Business Logic

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM READ_DATA.
  PERFORM GET_FCAT.
  PERFORM DISPLAY_DATA.
