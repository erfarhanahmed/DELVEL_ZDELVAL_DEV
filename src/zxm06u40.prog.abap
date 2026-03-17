*&---------------------------------------------------------------------*
*&  Include           ZXM06U40
*&---------------------------------------------------------------------*
BREAK PRIMUSABAP.
*IF I_EKPO-EBELN IS NOT INITIAL.
*  SELECT SINGLE FRGZU FROM EKKO
*    INTO @DATA(GV_FRGZU) = I_EKPO-EBELN.
*ENDIF.
E_CI_EKPO-ZGREEN_FLD = ekpo_ci-zgreen_fld.
