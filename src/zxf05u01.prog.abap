*&---------------------------------------------------------------------*
*&  Include           ZXF05U01
*&---------------------------------------------------------------------*
FIELD-SYMBOLS : <fs_cin>  TYPE j_1imovend,
                <fs_vend> TYPE t020.

DATA: l_cin         TYPE string VALUE '(SAPLJ1I_MASTER)J_1IMOVEND',
      l_vend        TYPE string VALUE '(SAPMF02K)T020',
      va_j_1iexcicu LIKE j_1imocust-j_1iexcicu,
      it_vend       TYPE STANDARD TABLE OF j_1imovend,
      wa_vend       TYPE j_1imovend,
      v_panno       TYPE char20,
      v_cstno       TYPE char20,
      v_lstno       TYPE char20,
      v_flag        TYPE c.

ASSIGN (l_vend) TO <fs_vend>.
IF sy-subrc EQ 0.
  ASSIGN (l_cin) TO <fs_cin>.
  IF sy-subrc EQ 0.
***    IF sy-tcode EQ 'XK01' OR sy-tcode EQ 'FK01'.
***      SELECT  SINGLE j_1ipanno j_1icstno  j_1ilstno  INTO (v_panno,v_cstno,v_lstno)
***                        FROM j_1imovend WHERE lifnr = i_lfa1-lifnr.
***      IF ( v_panno IS INITIAL OR v_cstno IS INITIAL OR v_lstno IS INITIAL ).
****              IF  <fs_cin>-J_1IPANNO IS INITIAL .
***        IF ( <fs_cin>-j_1ipanno IS INITIAL
***          OR <fs_cin>-j_1icstno IS INITIAL
***          OR <fs_cin>-j_1ilstno  IS INITIAL ).
***          MESSAGE 'Please maintain CIN Details for the Vendor' TYPE 'E'.
***        ENDIF.
***      ENDIF.
***    ENDIF.
***  ENDIF.
***ENDIF.

    IF sy-tcode EQ 'XK02' OR sy-tcode EQ 'FK02'.
      SELECT  SINGLE j_1ipanno j_1icstno  j_1ilstno
        INTO (v_panno,v_cstno,v_lstno)
        FROM j_1imovend
        WHERE lifnr = i_lfa1-lifnr.

      IF ( v_panno IS INITIAL OR v_cstno IS INITIAL OR v_lstno IS INITIAL ).

        IF ( <fs_cin>-j_1ipanno IS INITIAL
             OR <fs_cin>-j_1icstno IS INITIAL
             OR <fs_cin>-j_1ilstno  IS INITIAL ).
          MESSAGE 'Please maintain CIN Details for the Vendor' TYPE 'S'.
        ENDIF.
      ELSE .
        v_flag = 'X'.
      ENDIF.

      IF ( v_flag = ' '  AND ( <fs_cin>-j_1ipanno IS INITIAL OR <fs_cin>-j_1icstno IS INITIAL OR
       <fs_cin>-j_1ilstno  IS INITIAL ) ).
        MESSAGE 'Please maintain CIN Details for the Vendor' TYPE 'S'.
      ENDIF.

      IF ( v_flag = 'X' AND <fs_cin> IS NOT INITIAL ) .
        IF  ( <fs_cin>-j_1ipanno IS INITIAL
              OR <fs_cin>-j_1icstno IS INITIAL
              OR <fs_cin>-j_1ilstno  IS INITIAL ).
          MESSAGE 'Please maintain CIN Details for the Vendor' TYPE 'S'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
*              elseif sy-subrc = 0.
*              read table it_vend into wa_vend index 1.
*              IF ( wa_vend-J_1IPANNO IS INITIAL or wa_vend-J_1ICSTNO IS INITIAL or
*               wa_vend-J_1ILSTNO  IS INITIAL ).
*                MESSAGE 'Please maintain CIN Details for the Vendor' TYPE 'E'.
*              endif.
*        endif.
