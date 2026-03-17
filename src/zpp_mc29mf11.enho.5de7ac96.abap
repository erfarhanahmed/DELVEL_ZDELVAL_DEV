"Name: \PR:SAPMC29M\FO:CUA_SETZEN_D0600\SE:BEGIN\EI
ENHANCEMENT 0 ZPP_MC29MF11.
*
  LOOP AT SCREEN.
   if screen-name = 'RC29N-AENNR'.
     screen-required = 1.
     modify screen.
   endif.

  ENDLOOP.
ENDENHANCEMENT.
