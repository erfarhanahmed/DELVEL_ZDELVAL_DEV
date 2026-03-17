*&---------------------------------------------------------------------*
*&  Include           ZXF04U01
*&---------------------------------------------------------------------*
FIELD-SYMBOLS : <fs_cin>  TYPE j_1imocust,
                <fs_cust> TYPE t020.

DATA: l_cin         TYPE string VALUE '(SAPLJ1I_MASTER)J_1IMOCUST',
      l_cust        TYPE string VALUE '(SAPMF02D)T020',
      va_j_1iexcicu LIKE j_1imocust-j_1iexcicu.

ASSIGN (l_cust) TO <fs_cust>.
IF sy-subrc EQ 0.
  ASSIGN (l_cin) TO <fs_cin>.
  IF sy-subrc EQ 0.
    IF sy-tcode EQ 'XD01' OR sy-tcode EQ 'XD02' OR sy-tcode EQ 'XD03'.
      IF <fs_cin>-j_1iexcicu IS INITIAL.
        SELECT SINGLE j_1iexcicu INTO va_j_1iexcicu FROM j_1imocust WHERE kunnr = i_kna1-kunnr.
*       IF sy-subrc EQ 0.
        IF va_j_1iexcicu NE 1.
*          MESSAGE 'Please maintain Excise Invoice Indicator for the customer' TYPE 'E'.
        ENDIF.
*       ENDIF.
*    <fs_cin>-j_1iexcicu = '1'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.


*************************************NOTE CODE ADDED *************************************************************************

DATA: it_kna1 TYPE TABLE OF kna1,
kunnr TYPE kna1-kunnr.
DATA: pan TYPE j_1imocust-j_1ipanno,
 l_ilen TYPE i.
DATA: wt_t059z TYPE t059z OCCURS 1 WITH HEADER LINE.
DATA : BEGIN OF wt_lfbw OCCURS 0.
INCLUDE STRUCTURE T_KNBW.
DATA : END OF wt_lfbw.
 FIELD-SYMBOLS :<fs_pgname1> TYPE j_1ipanno.
 ASSIGN ('(SAPLJ1I_MASTER)J_1IMOCUST-J_1IPANNO') TO <fs_pgname1> .
 if <fs_pgname1> IS not ASSIGNED.
 MESSAGE w000(8i) WITH 'PAN Number is not available.Please update PAN '.
 endif.
READ TABLE T_KNBW INDEX 1.
KUNNR = T_KNBW-KUNNR .
CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
EXPORTING
bukrs = T_KNBW-bukrs
component = 'IN'
EXCEPTIONS
component_not_active = 1
OTHERS = 2.
CHECK SY-SUBRC = 0.
pan = <fs_pgname1>.
l_ilen = strlen( pan ).
IF pan = ' '.
 MESSAGE w000(8i) WITH 'PAN Number is not available.Please update PAN '.
ELSEIF l_ilen NE 10 .
 MESSAGE 'Please enter 10 DIGIT PANCARD NO.' TYPE 'E'.
ELSEIF pan+0(5) CA '0123456789'
 OR "q
 pan+5(4) CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 OR
 pan+9(1) CA '0123456789'.
 MESSAGE 'PANCARD no should be in the format 1-5 char 6-9 numeric last char'
TYPE 'E'.
ENDIF.
