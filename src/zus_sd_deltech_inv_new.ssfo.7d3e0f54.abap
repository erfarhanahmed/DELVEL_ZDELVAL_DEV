BREAK primus.
CLEAR : wa_mara, tg_amt, gv_amt, v_rec_count." WA_MARA, GV_TXT, GV_AMT, GV_KBETR.

DESCRIBE TABLE is_bil_invoice-it_gen LINES v_rec_count.

SELECT SINGLE knumv
         FROM vbrk
         INTO l_knumv
        WHERE vbeln = is_bil_invoice-hd_gen-bil_number.

IF is_bil_invoice-hd_gen-BIL_WAERK = 'USD'.
  CURR = 'USD'.
ELSEIF is_bil_invoice-hd_gen-BIL_WAERK = 'EUR'.
  CURR = 'EURO'.
ENDIF.

*break primus.
*if sfsy-page = sfsy-formpages.
*  gk = 'P'.
*  endif.
