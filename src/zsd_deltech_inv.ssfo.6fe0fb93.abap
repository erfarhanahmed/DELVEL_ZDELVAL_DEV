DATA : wa_price TYPE lbbil_it_price,
       lv_kbetr TYPE kbetr.
DATA: w_vbrk TYPE vbrk.
DATA: l_knumv1 TYPE knumv.
lv_kbetr = gv_kbetr.
CLEAR : wa_price, gv_amt, gv_kbetr.

READ TABLE is_bil_invoice-it_price
  INTO wa_price WITH KEY itm_number = gs_it_gen-itm_number.

SELECT SINGLE knumv
         FROM vbrk
         INTO l_knumv1
        WHERE vbeln = gs_it_gen-bil_number.

CLEAR w_konv.
SELECT SINGLE * INTO w_konv
  FROM konv WHERE knumv = l_knumv1
  AND kposn = gs_it_gen-itm_number AND kschl = 'ZPR0'.

IF sy-subrc = 0.
*  GV_AMT = WA_PRICE-NETWR.
  gv_amt = w_konv-kwert.
*  TG_AMT = TG_AMT + GV_AMT .
  gv_kbetr = w_konv-kbetr.

  gv_total = gv_total + gv_amt .
*  GV_KBETR = WA_PRICE-NETWR / GS_IT_GEN-FKIMG.
ENDIF.


*BREAK primus.

*gs_total-kwert = gs_total-kwert + w_konv-kwert.
*
*MODIFY gt_total from gs_total INDEX 1 TRANSPORTING kwert .

