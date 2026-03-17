BREAK primus.
*
*READ TABLE LT_VBRK_J INTO LS_VBRK_J WITH KEY vbeln = P_vbeln.
*IF sy-subrc = 0 .
*
*IF LS_VBRK_J-fkart NE 'ZEXP'.

IF tcs IS NOT INITIAL.


SELECT SINGLE MWSBK INTO GV_MWSBK FROM vbrk WHERE vbeln = P_vbeln.

  gv_TCS = GV_MWSBK - GV_IGST - GV_CGST - GV_SGST.

ENDIF.
*ELSE.
*  gv_tcs = tcs.
*
*ENDIF.
*
*ENDIF.

















