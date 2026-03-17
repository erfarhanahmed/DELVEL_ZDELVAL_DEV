DATA lv_adrnr TYPE adrc-addrnumber.
lv_adrnr = WA_HDR-V_ADRNR.



SELECT SINGLE * FROM adrc INTO gs_adrc
  WHERE addrnumber = lv_adrnr.
SELECT SINGLE * FROM t005t
  INTO gs_t005t
  WHERE land1 = gs_adrc-country
    AND spras = sy-langu.
SELECT SINGLE * FROM t005u INTO gs_t005u
  WHERE spras = sy-langu
    AND land1 = gs_adrc-country
    AND bland = gs_adrc-region.

SELECT SINGLE bezei FROM t005u INTO bezei
   WHERE spras eq 'E' AND
         LAND1 EQ gs_adrc-country.

*IF bezei IS NOT INITIAL.
SELECT SINGLE gst_REGION FROM ZGST_REGION
  INTO GS_REGION
  WHERE BEZEI EQ GS_T005U-BEZEI.
* ENDIF.















