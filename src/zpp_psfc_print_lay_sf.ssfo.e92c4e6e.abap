
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

if gv_qty1 is INITIAL.
SELECT SINGLE kalab
        FROM mska
        INTO gv_qty1
        WHERE matnr = gs_comp-matnr
        AND werks = gs_comp-werks
        AND lgort = gv_lgort
        AND vbeln = gs_vbak-vbeln.
ENDIF.

CLEAR :gv_short_qty, gv_short_qty1.
IF gs_comp-bdmng > gv_qty."gs_mard-labst.
  gv_short_qty = gs_comp-bdmng - gv_qty."gs_mard-labst.
ENDIF.
IF gs_comp-bdmng > gv_qty1."gs_mard-labst.
  gv_short_qty1 = gs_comp-bdmng - gv_qty1."gs_mard-labst.
ENDIF.
if gv_lgort is INITIAL.
  clear : gv_qty1 .", gv_short_qty1.
endif.

















