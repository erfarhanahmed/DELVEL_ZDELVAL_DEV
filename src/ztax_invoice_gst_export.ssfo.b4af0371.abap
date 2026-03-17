
gv_item = gs_item-posnr.
SHIFT gv_item LEFT DELETING LEADING '0'.
CONDENSE gv_item.

CLEAR : gv_plant,wa_mast.
SELECT SINGLE werks INTO gv_plant FROM vbrp WHERE vbeln = gs_item-vbeln.

SELECT SINGLE * FROM mast INTO wa_mast WHERE matnr = gs_item-matnr
                                       AND werks = gv_plant.
SELECT STLTY
       STLNR
       STLKN
       STPOZ
       aennr
       LKENZ
       IDNRK
       menge FROM stpo INTO TABLE it_stpo
       WHERE stlnr = wa_mast-stlnr
         AND LKENZ NE 'X'
         AND aennr = ' '.



















