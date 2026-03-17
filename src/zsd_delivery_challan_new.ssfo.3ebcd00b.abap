
DATA:
  lv_adrnr TYPE kna1-adrnr.

**SELECT SINGLE adrnr
**              stcd3
**         FROM kna1
**         INTO (lv_adrnr,gv_v_gst)
**         WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.

READ TABLE gt_mseg INTO data(gs_mseg) INDEX 1.
SELECT SINGLE adrnr
              stcd3
         FROM lfa1
         INTO (lv_adrnr,gv_v_gst)

         WHERE lifnr = gs_mseg-lifnr.

IF GV_V_GST = 'URP'.
  gV_RCM = 'YES'.
ENDIF.

SELECT SINGLE * FROM kna1 INTO wa_kna1
  WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.




SELECT SINGLE * FROM LFM1 INTO WA_LFM1
  WHERE LIFNR = gs_mseg-lifnr."ls_bil_invoice-hd_gen-sold_to_party.
*BREAK primus.
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
*BREAK primus.
if lv_name1 is INITIAL.
    LV_NAME1    = gs_ven-name1.
ENDIF.

if lv_street1 is INITIAL.
    concatenate gs_ven-STREET gs_ven-STR_SUPPL3  gs_ven-LOCATION
    into LV_STREET1 SEPARATED BY space.
 endif.
if LV_CITY is INITIAL.
    LV_CITY = gs_ven-city1.
endif.
 if LV_COUNT is INITIAL.

     CONCATENATE 'Pin:' GS_ven-POST_CODE1 GV_V_STATE GV_V_COUNTRY
     INTO  LV_COUNT SEPARATED BY SPACE.
 ENDIF.
 if LV_VAT01 is INITIAL.
    concatenate 'VAT NO. :' gv_v_gst INTO LV_VAT01 .
 ENDIF.
  if LV_CONTP is INITIAL.
    Concatenate 'Contact Person :' wa_lfm1-verkf into LV_CONTP
    SEPARATED BY space.
  ENDIF.
   if  LV_CONTN is INITIAL.
   CONCATENATE  'Contact No :' wa_lfm1-telf1 into LV_CONTN
    SEPARATED BY space.
    endif.
*  ENDCASE.
