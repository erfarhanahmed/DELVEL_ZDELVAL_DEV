*BREAK-POINT.
SELECT SINGLE lifnr
       from ekko
       into wa_lifnr
       where ebeln  = gs_purchasing-ebeln.

  SELECT vbeln
       posnr
       vgbel
       vgpos
       matnr
       arktx
       fkimg
       vrkme
       netwr
       werks
  FROM vbrp
  INTO TABLE gt_item
  WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.


SELECT mblnr
       MJAHR
       ZEILE
       BWART
       XAUTO
       LGORT
       BUDAT_MKPF
  FROM mseg INTO TABLE IT_MSEG
  where mblnr = gs_item-vgbel.



LOOP AT GT_ITEM INTO GS_ITEM.
  READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MBLNR = GS_ITEM-VGBEL XAUTO ='X' .
    IF SY-SUBRC = 0.
     wa_final-mblnr = wa_mseg-mblnr.
     wa_final-MJAHR = wa_mseg-mjahr.
     wa_final-ZEILE = wa_mseg-zeile.
     wa_final-BWART = wa_mseg-bwart.
     wa_final-XAUTO = wa_mseg-xauto.
     wa_final-LGORT = wa_mseg-LGORT.
     wa_final-budat_mkpf = wa_mseg-budat_mkpf.
   ENDIF.

  ENDLOOP.








