*&---------------------------------------------------------------------*
*& Report  ZMM_REQUISITION_DELETE
*& Description: Purchase Requistion Deletion
*& Developed by: Saumitra Mani Tiwari
*& Date:- 24 Aug 2012
*&---------------------------------------------------------------------*
*& Project:- Delval        ||   Version 1.0
*&
*&---------------------------------------------------------------------*
REPORT ZMM_REQUISITION_DELETE.

" INLCUDE FOR DATA DECLARATION "
INCLUDE ZMM_REQUISITION_DELETE_TOP.

" INCLUDE FOR SELECTION SCREEN "
INCLUDE ZMM_REQUISITION_DELETE_SEL.

*" INCLUDE FOR SUBROUTINES"
INCLUDE ZMM_REQUISITION_DELETE_FORM.

"----- START OF SELECTION EVENT----- "
START-OF-SELECTION.

" SUBROUTINE TO CLEAR DATA "
PERFORM CLEAR_DATA.

" SUBROUTINE TO CLEAR DATA "
PERFORM GET_DATA.

" SUBROUTINE TO DISPLAY DATA "
PERFORM DISPLAY_DATA.
