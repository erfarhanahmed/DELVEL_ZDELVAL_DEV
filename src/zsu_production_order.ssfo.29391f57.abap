
 CLEAR: gs_mard, gv_qty.
 SELECT SINGLE * FROM mard INTO gs_mard
   WHERE matnr = gs_comp-matnr
     AND werks = gs_comp-werks
     AND lgort = gs_comp-lgort.

CLEAR gv_maktx.
 SELECT SINGLE maktx INTO gv_maktx
   FROM makt
   WHERE matnr = gs_comp-matnr
     AND spras = sy-langu.

gv_qty = gs_mard-labst.

CLEAR :wa_mara,old_code.


SELECT SINGLE * FROM mara INTO wa_mara
  WHERE matnr = gs_comp-matnr.

IF wa_mara-wrkst IS NOT INITIAL.
CONCATENATE '(' wa_mara-wrkst ')' INTO old_code.
ENDIF.



