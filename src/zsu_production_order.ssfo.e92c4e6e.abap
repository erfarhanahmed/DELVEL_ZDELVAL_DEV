
*CLEAR gv_qty.
if gv_qty is INITIAL.
SELECT SINGLE kalab
        FROM mska
        INTO gv_qty
        WHERE matnr = gs_comp-matnr
        AND werks = gs_comp-werks
        AND lgort = gs_comp-lgort
        AND vbeln = gs_vbak-vbeln.
ENDIF.

CLEAR gv_short_qty.
IF gs_comp-bdmng > gv_qty."gs_mard-labst.
  gv_short_qty = gs_comp-bdmng - gv_qty."gs_mard-labst.
ENDIF.




















