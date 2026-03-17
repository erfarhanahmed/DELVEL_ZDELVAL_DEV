*&---------------------------------------------------------------------*
*& Report  ZGST_DATA_UPLOAD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZGST_DATA_UPLOAD.
SELECTION-SCREEN : BEGIN OF BLOCK A1 WITH FRAME TITLE TEXT-001.
  PARAMETERS     : A2 RADIOBUTTON GROUP r,
                   A3 RADIOBUTTON GROUP r,
                   A4 RADIOBUTTON GROUP r.
*                   A5 RADIOBUTTON GROUP r.

SELECTION-SCREEN : END OF BLOCK a1.

IF A2 EQ 'X'.
  SUBMIT ZMMB_XK02 VIA SELECTION-SCREEN AND RETURN.
ELSEIF A3 EQ 'X'.
  SUBMIT ZMMR_CHANGEMATERIALMASTER VIA SELECTION-SCREEN AND RETURN.
ELSEIF A4 EQ 'X'.
  SUBMIT ZSDB_XD02 VIA SELECTION-SCREEN AND RETURN.
*ELSEIF A5 EQ 'X'.
*  SUBMIT ZPM_BDC VIA SELECTION-SCREEN AND RETURN.
ENDIF.
