data : ls_item type ZMATERIAL_DOC.
*BREAK primus.
READ TABLE GT_MATERIAL_DOC[] INTO ls_item INDEX 1.
IF sy-subrc = 0.
SELECT SINGLE * from mseg INTO wa_mseg
  WHERE mblnr = ls_item-mblnr and mjahr = ls_item-mjahr
  and ebeln = ls_item-ebeln AND ebelp = ls_item-ebelp
  and bwart = '101'.
ENDIF.





















