*&---------------------------------------------------------------------*
*& Report ZUS_MIGO_103_105_F02_FB08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSA_MIGO_103_105_F02_FB08.

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:R1 RADIOBUTTON GROUP RG,"103
             R2 RADIOBUTTON GROUP RG."105
SELECTION-SCREEN:END OF BLOCK B1.

START-OF-SELECTION.
IF r1 = 'X'.

SUBMIT zsu_migo_103_f02 VIA SELECTION-SCREEN AND RETURN..
ELSE.

SUBMIT zsa_migo_105_fb08 VIA SELECTION-SCREEN AND RETURN..

ENDIF.
