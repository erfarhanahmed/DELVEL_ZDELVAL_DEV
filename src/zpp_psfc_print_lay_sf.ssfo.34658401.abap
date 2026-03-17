SELECT SINGLE * FROM mara INTO gs_mara
  WHERE matnr = header-matnr.

  SELECT SINGLE matnr FROM afpo
    INTO LV_MATNR WHERE AUFNR = header-AUFNR.



















