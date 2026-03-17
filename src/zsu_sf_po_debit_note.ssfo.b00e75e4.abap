data : ls_item type ZMATERIAL_DOC.
*BREAK-POINT.
READ TABLE GT_MATERIAL_DOC[] INTO ls_item INDEX 1.
IF sy-subrc = 0.
SELECT * from mseg
  INTO CORRESPONDING FIELDS OF TABLE LT_MSEG01
  WHERE mblnr = WA_MSEG01-mblnr and mjahr = WA_MSEG01-mjahr
*  and ebeln = ls_item-ebeln AND ebelp = ls_item-ebelp
  and bwart = '161'.
ENDIF.


















