*BREAK-POINT.

GV_IS = GV_IS + 1.
CONCATENATE GV_SR gV_IS INTO GV_SR01 SEPARATED BY '.'.
READ TABLE gt_marc INTO gs_marc
             WITH KEY matnr = wa_final-matnr.
*CONCATENATE GV_SR'.'GV_IS INTO GV_SR01.

CLEAR GV_ZEINR.
SELECT SINGLE ZEINR
        FROM mara
        INTO GV_ZEINR
        WHERE matnr = wa_final-matnr.


tax_amt = wa_final-netwr + tax_amt.
cgst_tot = wa_final-cgst_amt + cgst_tot.
sgst_tot = wa_final-sgst_amt + sgst_tot.
