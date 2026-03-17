*&---------------------------------------------------------------------*
*& Report ZME12_BDC_PROGRAMS
*&---------------------------------------------------------------------*
*&         0. PROGRAM OWNER          : PRIMUS TECHSYSTEMS PVT LTD.
*&         1. FS NO                  :
*&         2. PROJECT                : Delval
*&         3. PROGRAM NAME           : ZME12_BDC_PROGRAMS
*&         4. TRANS CODE             : ZMOQ_Upload
*&         5. MODULE NAME            :
*&         7. CREATION DATE          : 01/01/2021
*&         8. DEVELOPER NAME         : SNEHAL RAJALE
*&         9. FUNCTIONAL CONSULTANT  : VAIBHAV VAANMANE
*&---------------------------------------------------------------------*
REPORT zme12_bdc_programs.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_std RADIOBUTTON GROUP rb1,
             p_sub RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK b1.

IF p_std = 'X'.
*  SUBMIT zme12_bdc VIA SELECTION-SCREEN AND RETURN.         "Program for Standard info record.
  SUBMIT zme12_bdc12 VIA SELECTION-SCREEN AND RETURN.         "Program for Standard info record.
ELSEIF p_sub = 'X'.
*  SUBMIT zme12_subcon_bdc VIA SELECTION-SCREEN AND RETURN.  "Program for Subcontracting info record.
  SUBMIT zme12_subcon_bdc12 VIA SELECTION-SCREEN AND RETURN.  "Program for Subcontracting info record.
ENDIF.
