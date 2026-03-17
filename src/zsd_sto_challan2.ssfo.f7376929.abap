
DATA:
  lv_adrnr TYPE kna1-adrnr.

SELECT SINGLE adrnr
              stcd3
         FROM kna1
         INTO (lv_adrnr,gv_v_gst)
         WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.

SELECT SINGLE * FROM kna1 INTO wa_kna1
  WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.

SELECT SINGLE * FROM LFM1 INTO WA_LFM1
  WHERE LIFNR = wa_kna1-lifnr."ls_bil_invoice-hd_gen-sold_to_party.

SELECT SINGLE *
         FROM adrc
         INTO gs_ven
         WHERE addrnumber = lv_adrnr.

SELECT SINGLE landx
         FROM t005t
         INTO gv_v_country
         WHERE spras = sy-langu
           AND land1 = gs_ven-country.


SELECT SINGLE bezei
         FROM t005u
         INTO gv_v_state
         WHERE spras = sy-langu
           AND land1 = gs_ven-country
           AND bland = gs_ven-region.

IF NOT gv_v_state IS INITIAL.
  SELECT SINGLE gst_region
          FROM  zgst_region
          INTO  gv_gst_v_reg
          WHERE bezei = gv_v_state.
ENDIF.

SELECT vbeln
       posnr
       vgbel
       vgpos
       matnr
       arktx
       fkimg
       vrkme
       netwr
       werks
  FROM vbrp
  INTO TABLE gt_item
  WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.
*BREAK-POINT.

SELECT mblnr
       MJAHR
       ZEILE
       BWART
       XAUTO
       MATNR
       WERKS
       MENGE
       MEINS
       EBELN
       EBELP
       LGORT
  FROM mseg INTO TABLE IT_MSEG_1
  where mblnr = gs_item-vgbel.

SELECT
   VBELN
   EWAY_BILL FROM ZEWAY_NUMBER
  INTO TABLE IT_ZEWAY
   WHERE VBELN = GS_ITEM-VBELN.

   SELECT
       VBELN
       VEHICAL_NO
       TRANS_NAME
       VEHICAL_TYPE FROM ZEWAY_BILL
       INTO CORRESPONDING FIELDS OF TABLE IT_ZEWAY_BILL
       WHERE VBELN = GS_ITEM-VBELN.



LOOP AT GT_ITEM INTO GS_ITEM.
  READ TABLE IT_MSEG_1 INTO WA_MSEG_1 WITH KEY MBLNR = GS_ITEM-VGBEL XAUTO = ''..
   IF SY-SUBRC = 0.
     wa_final-mblnr = wa_mseg_1-mblnr.
     wa_final-MJAHR = wa_mseg_1-mjahr.
     wa_final-ZEILE = wa_mseg_1-zeile.
     wa_final-BWART = wa_mseg_1-bwart.
     wa_final-XAUTO = wa_mseg_1-xauto.
     wa_final-LGORT = wa_mseg_1-LGORT.

*     GV_TO_LGORT = wa_mseg_1-LGORT.
     GV_FROM_LGORT = wa_mseg_1-LGORT.
ENDIF.

READ TABLE IT_ZEWAY INTO WA_ZEWAY WITH KEY VBELN = GS_ITEM-VBELN.
IF SY-SUBRC = 0.
 wa_final-EWAY_BILL = WA_ZEWAY-EWAY_BILL.

ENDIF.
READ TABLE IT_ZEWAY_BILL INTO WA_ZEWAY_BILL WITH KEY VBELN = GS_ITEM-VBELN.
IF SY-SUBRC = 0.
wa_final-TRANS_NAME = WA_ZEWAY_BILL-TRANS_NAME.
wa_final-VEHICAL_NO = WA_ZEWAY_BILL-VEHICAL_NO.
wa_final-VEHICAL_TYPE = WA_ZEWAY_BILL-VEHICAL_TYPE.
ENDIF.

  ENDLOOP.
