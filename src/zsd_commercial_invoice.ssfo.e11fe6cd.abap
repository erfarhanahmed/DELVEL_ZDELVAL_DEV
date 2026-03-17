DATA: l_werks   TYPE werks_d,
      l_adrnr   TYPE adrnr,
      l_country TYPE land1,
      ls_vbrp   TYPE vbrp.

IF is_bil_invoice-hd_ref-deliv_numb IS NOT INITIAL.
  SELECT SINGLE werks INTO l_werks
  FROM lips
  WHERE vbeln = is_bil_invoice-hd_ref-deliv_numb.
ELSE.
  SELECT SINGLE * FROM vbrp INTO ls_vbrp
    WHERE vbeln = is_bil_invoice-hd_gen-bil_number.
  l_werks = ls_vbrp-werks.
ENDIF.

***************************************************
SELECT SINGLE vbeln, posnr, lgort
  FROM vbrp INTO CORRESPONDING FIELDS OF @LW_vbrp
   WHERE VBELN = @IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
****************************************************
SELECT SINGLE adrnr INTO l_adrnr
FROM t001w
WHERE werks = l_werks.

SELECT SINGLE *
FROM adrc
INTO plant_add
WHERE addrnumber = l_adrnr.
*GS_T005T
*GS_ADR6
*GS_ADRCT
  SELECT SINGLE * from t005t INTO gs_t005t
    WHERE spras = sy-langu
      AND land1 = plant_add-country.

  SELECT SINGLE * FROM adr6
    INTO gs_adr6    "wa_adrc-smtp_addr
    WHERE addrnumber = l_adrnr.  "lv_adrnr.

  SELECT SINGLE * FROM adrct
    INTO gs_adrct
    WHERE addrnumber = l_adrnr.
