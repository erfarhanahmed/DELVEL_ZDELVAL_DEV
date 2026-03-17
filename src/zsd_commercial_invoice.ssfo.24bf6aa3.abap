
CLEAR GS_HD_ADR.
* get customer adress number
READ TABLE IS_BIL_INVOICE-HD_ADR INTO GS_HD_ADR
           WITH KEY BIL_NUMBER = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER
                    PARTN_ROLE = IS_NAST-PARVW.
ADRNR = GS_HD_ADR-ADDR_NO.

    SELECT SINGLE NAME1
                  STR_SUPPL1
                  STR_SUPPL2
                  STREET
                  CITY1
                  POST_CODE1
                  TEL_NUMBER
                  FAX_NUMBER
                  FROM ADRC
            INTO (G_NAME_P,
                  G_STR_SUPPL1_P,
                  G_STR_SUPPL2_P,
                  G_STREET_P,
                  G_CITY_P,
                  G_POST_CODE_P,
                  G_TEL_NUMBER_P,
                  G_FAX_NUMBER_P
                  )
    WHERE ADDRNUMBER = ADRNR.

*  IF SY-SUBRC = 0.
*    SELECT SINGLE LANDX FROM T005T INTO G_LANDX_P
*    WHERE LAND1 = L_COUNTRY AND
*    SPRAS = 'EN'.
*  ENDIF.


*SELECT SINGLE J_1IEXCD FROM J_1IMOCOMP INTO GV_J_1IEXCD
*    WHERE WERKS = L_WERKS.
