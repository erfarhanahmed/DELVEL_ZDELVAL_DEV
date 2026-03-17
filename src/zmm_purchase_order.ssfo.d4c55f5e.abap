
SELECT COUNT(*) FROM cdhdr INTO gv_revcnt
  WHERE objectclas = 'EINKBELEG'
    AND objectid = xekko-ebeln
    AND ( tcode = 'ME23N'
       OR tcode = 'ME22N' ).


*DATA: RETURN_NO TYPE C.
*BREAK FUJIABAP.



















