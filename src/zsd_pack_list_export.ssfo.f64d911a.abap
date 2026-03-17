CLEAR:gv_type,gv_maktx.
SELECT SINGLE type INTO gv_type FROM mara WHERE matnr = wa_stpo-idnrk.
SELECT SINGLE maktx INTO GV_MAKTX FROM makt WHERE matnr = wa_stpo-idnrk.





















