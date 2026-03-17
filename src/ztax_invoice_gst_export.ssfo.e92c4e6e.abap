CLEAR:gv_type,lv_steuc,lv_qty,GV_MAKTX.
SELECT SINGLE type INTO gv_type FROM mara WHERE matnr = wa_stpo-idnrk.
SELECT SINGLE maktx INTO GV_MAKTX FROM makt WHERE matnr = wa_stpo-idnrk.

SELECT SINGLE steuc
            FROM marc
            INTO lv_steuc
            WHERE matnr = wa_stpo-idnrk.

lv_qty = gv_qty * wa_stpo-menge.

















