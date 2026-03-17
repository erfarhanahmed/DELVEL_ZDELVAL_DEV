*BREAK-POINT.
SELECT COUNT(*) FROM cdhdr INTO gv_revcnt
  WHERE objectclas = 'EINKBELEG'
    AND objectid = xekko-ebeln
    AND ( tcode = 'ME23N'
       OR tcode = 'ME22N' ).

*******************added by jyoti on 08.01.2024***********
select single ZGREEN_FLD from
  ekpo INTO gv_zgreen_fld
  where ebeln = xekko-ebeln.
  if sy-subrc is INITIAL.
    if gv_zgreen_fld = 'YES'.
    GV_GREEN_CHANNAL = 'GREEN SUPPLY'.
    ENDIF.
  endif.
**********************************************************




















