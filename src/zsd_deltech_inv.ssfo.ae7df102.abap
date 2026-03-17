

komk-waerk = is_bil_invoice-hd_gen-bil_waerk.
CLEAR gs_hd_komk.

gs_hd_komk-supos   = is_bil_invoice-hd_komk-supos.
gs_hd_komk-fkwrt   = is_bil_invoice-hd_komk-fkwrt.

SELECT SINGLE * FROM likp INTO gs_likp
  WHERE vbeln = is_bil_invoice-hd_ref-deliv_numb.

IF is_bil_invoice-hd_ref-deliv_numb IS NOT INITIAL.
SELECT vbeln
       VKORG
       VERUR FROM likp INTO TABLE it_likp
       WHERE VERUR = is_bil_invoice-hd_ref-deliv_numb.
ENDIF.



SORT it_likp DESCENDING BY vbeln.

READ TABLE it_likp INTO wa_likp INDEX 1.
IF sy-subrc = 0.
 inbound = wa_likp-vbeln.
ENDIF.
