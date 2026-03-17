*&---------------------------------------------------------------------*
*&  Include           ZXCO1U06
*&---------------------------------------------------------------------*

DATA: ID TYPE STRING.
*DATA: ID1 TYPE STRING.
data : it_stpox type TABLE OF stpox.
data :gv_msg TYPE string.
*BREAK PRIMUSABAP.
*IF ( SY-TCODE EQ 'CO01' OR SY-TCODE EQ 'CO02' ) AND SY-UCOMM EQ 'BU' AND HEADER_IMP-WERKS = 'PL01'.

IF SY-TCODE EQ 'CO01' AND SY-UCOMM EQ 'BU' AND HEADER_IMP-WERKS = 'PL01'.

*BREAK PRIMUSABAP.
  ID = '(SAPLCOKO1)AFPOD-LGORT'.

*  it_stpox = '(SAPLCOMK)-KOMP_INT'.

  ASSIGN (ID) TO FIELD-SYMBOL(<LGORT>).
    IF <LGORT> IS ASSIGNED.
       IF <LGORT> IS INITIAL.
          NO_UPDATE = 'X'.  " ENABLE FLAG
          MESSAGE 'Please Enter Storage Location' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
     ENDIF.
     if HEADER_IMP-auart+0(1) = 'K'.
         IF <LGORT> IS ASSIGNED.
           IF <LGORT> IS NOT INITIAL.
             if <LGORT>+0(1) NE 'K'.
                NO_UPDATE = 'X'.
               MESSAGE 'Please Enter Storage Location for KPR' TYPE 'E'.
*             else.
*                 MESSAGE 'Please Enter storage location for PL01' TYPE 'E'.
             endif.

           endif.
         endif.
       else.
         IF <LGORT> IS ASSIGNED.
           IF <LGORT> IS NOT INITIAL.
             if <LGORT>+0(1) EQ  'K'.
                NO_UPDATE = 'X'.
               MESSAGE 'Please Enter Storage Location for PL01' TYPE 'E'.
             endif.
           endif.
         endif.

     endif.

ENDIF.
*ENDIF.
