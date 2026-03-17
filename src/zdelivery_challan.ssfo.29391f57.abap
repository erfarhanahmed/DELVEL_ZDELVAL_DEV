**BREAK-POINT.
GV_IS = GV_IS + 1.
READ TABLE gt_marc INTO gs_marc
             WITH KEY matnr = gs_item-matnr.

CLEAR GV_ZEINR.
SELECT SINGLE ZEINR
        FROM mara
        INTO GV_ZEINR
        WHERE matnr = gs_item-matnr.

















