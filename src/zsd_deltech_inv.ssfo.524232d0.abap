CLEAR : gs_hd_ref.
MOVE-CORRESPONDING is_bil_invoice-hd_ref TO gs_hd_ref.

CLEAR : v_flag , gs_hd_gen.
MOVE-CORRESPONDING is_bil_invoice-hd_gen TO gs_hd_gen.

SELECT  vbeln
        posnr
        parvw
        adrnr
        FROM vbpa INTO CORRESPONDING FIELDS OF TABLE it_vbpa
        WHERE vbeln = gs_hd_ref-order_numb
        AND   parvw = 'WE'.

SELECT SINGLE adrnr FROM vbpa INTO l_adrnr
                      WHERE vbeln = gs_hd_ref-order_numb
                        AND parvw = 'WE'.

CLEAR wa_adrc .
SELECT SINGLE *
FROM adrc INTO wa_adrc
WHERE addrnumber = l_adrnr.

SELECT SINGLE *
FROM t005t
INTO wa_t005t
WHERE land1 = wa_adrc-country
AND   spras = 'EN'.

SELECT SINGLE *
  FROM t005u
  INTO wa_t005u
  WHERE land1 = wa_adrc-country
  AND   bland = wa_adrc-region
  AND   spras = 'EN'.

SELECT SINGLE KUNNR FROM VBPA INTO @DATA(WA_VBPA1)
  WHERE VBELN = @IS_BIL_INVOICE-HD_GEN-BIL_NUMBER
  AND   PARVW EQ 'WE'.

  SELECT SINGLE ADRNR FROM KNA1 INTO @DATA(WA_KNA1)
    WHERE KUNNR = @WA_VBPA1.

  IF  IS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY EQ '0000300000'.
  IF IS_BIL_INVOICE-HD_GEN-BIL_EDATE GE '20240812'.
  WA_ADRC-STR_SUPPL1 = '6535 Industrial Dr, Ste 103'.
ENDIF.

IF WA_VBPA1 NE IS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY.

    SELECT SINGLE NAME_CO,STR_SUPPL1,STREET  FROM ADRC INTO @DATA(WA_ADRC1)
      WHERE ADDRNUMBER = @WA_KNA1.

        WA_ADRC-STR_SUPPL1     = WA_ADRC1-NAME_CO.
        WA_ADRC-STR_SUPPL2     = WA_ADRC1-STR_SUPPL1.
        WA_ADRC-CITY2          = WA_ADRC1-STREET.

   ENDIF.

ENDIF.
