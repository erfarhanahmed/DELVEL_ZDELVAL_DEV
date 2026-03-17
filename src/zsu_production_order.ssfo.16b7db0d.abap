
SELECT SINGLE * FROM vbap INTO gs_vbap
  WHERE vbeln = header-vbeln
    AND posnr = header-vbelp.

SELECT SINGLE * FROM vbak INTO gs_vbak
  WHERE vbeln = gs_vbap-vbeln.

*SELECT SINGLE * FROM knmt INTO gs_knmt
*  WHERE vkorg = ls_vbak-vkorg
*    AND vtweg = ls_vbak-vtweg
*    AND kunnr = header-kunum
*    AND matnr = header-matnr.




















