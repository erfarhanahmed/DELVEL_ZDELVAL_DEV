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
       MATNR
       WERKS
       MENGE
       MEINS
       EBELN
       EBELP
       LGORT
       BUDAT_MKPF
  FROM mseg INTO TABLE IT_MSEG
  where mblnr = gs_item-vgbel.

LOOP AT GT_ITEM INTO GS_ITEM.
  READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MBLNR = GS_ITEM-VGBEL XAUTO ='X' .
    IF SY-SUBRC = 0.
*     GV_FROM_LGORT = WA_MSEG-LGORT.
     GV_TO_LGORT = WA_MSEG-LGORT.
   ENDIF.

  ENDLOOP.





