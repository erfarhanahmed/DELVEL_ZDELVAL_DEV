"Name: \PR:SAPLCOKO1\FO:CHECK_BWTAR\SE:BEGIN\EI
ENHANCEMENT 0 ZCO02_LGORT_CHECK.
  IF AFPOD-PWERK = 'PL01' AND SY-TCODE = 'CO40'.
    IF AFPOD-AUFNR IS NOT INITIAL.
    endif.
    endif.


  IF AFPOD-PWERK = 'PL01' AND ( SY-TCODE = 'CO01' or SY-TCODE = 'CO02' or SY-TCODE = 'CO40' ) AND ( SY-UCOMM = 'BU' OR SY-UCOMM = 'BACK' OR SY-UCOMM = 'END' ).
*  IF SY-UCOMM = 'BU' OR SY-UCOMM = 'BACK' OR SY-UCOMM = 'END'.

  IF afpod-lgort = ''.

    MESSAGE 'Enter the Storage Location' type 'E'.
  else.
  if afpod-DAUAT+0(1) = 'K'.
    if afpod-lgort+0(1) NE 'K'.
      MESSAGE 'Please Enter Storage Location for KPR' TYPE 'E'.
    endif.
  else.
     if afpod-lgort+0(1) EQ 'K'.
       MESSAGE 'Please Enter Storage Location for PL01' TYPE 'E'.
     endif.
  ENDIF.
  ENDIF.


  ENDIF.
*  ENDIF.


ENDENHANCEMENT.
