CLEAR : GV_MATNR,
        GV_ARKTX,
        GV_FKIMG.

DATA: L_WERKS   TYPE WERKS_D,
      L_ADRNR   TYPE ADRNR,
      L_COUNTRY TYPE LAND1,
      L_FKIMG   TYPE FKIMG.

SELECT SINGLE
              WERKS
              MATNR
              ARKTX
              FKIMG
              NTGEW
              BRGEW
         FROM VBRP
         INTO (L_WERKS,
               GV_MATNR,
               GV_ARKTX,
               L_FKIMG,
               GV_NTGEW,
               GV_BRGEW)
WHERE VBELN = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.


IF SY-SUBRC = 0.
  SELECT SINGLE ADRNR INTO L_ADRNR
  FROM T001W
  WHERE WERKS = L_WERKS.
  IF SY-SUBRC = 0.

    SELECT SINGLE NAME1
                  STR_SUPPL1
                  STR_SUPPL2
                  STREET
                  CITY1
                  POST_CODE1
                  TEL_NUMBER
                  FAX_NUMBER
                  COUNTRY FROM ADRC
            INTO (G_NAME_P,
                  G_STR_SUPPL1_P,
                  G_STR_SUPPL2_P,
                  G_STREET_P,
                  G_CITY_P,
                  G_POST_CODE_P,
                  G_TEL_NUMBER_P,
                  G_FAX_NUMBER_P,
                  L_COUNTRY)
    WHERE ADDRNUMBER = L_ADRNR.
  ENDIF.
  IF SY-SUBRC = 0.
    SELECT SINGLE LANDX FROM T005T INTO G_LANDX_P
    WHERE LAND1 = L_COUNTRY AND
    SPRAS = 'EN'.
  ENDIF.
ENDIF.

SELECT SINGLE J_1IEXCD FROM J_1IMOCOMP INTO GV_J_1IEXCD
    WHERE WERKS = L_WERKS.
