*BREAK fujiabap.
*BREAK-POINT.
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

IF NOT gt_item IS INITIAL.

  SELECT matnr
         werks
         steuc
    FROM marc
    INTO TABLE gt_marc
    FOR ALL ENTRIES IN gt_item
    WHERE matnr = gt_item-matnr
      AND werks = gt_item-werks.




ENDIF.
