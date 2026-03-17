
DATA:
  lv_adrnr TYPE kna1-adrnr.

BREAK primusabap..
SELECT SINGLE adrnr
              stcd3
         FROM kna1
         INTO (lv_adrnr,gv_v_gst)
         WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.

SELECT SINGLE * FROM LFM1 INTO WA_LFM1
  WHERE LIFNR = ls_bil_invoice-hd_gen-sold_to_party.



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













