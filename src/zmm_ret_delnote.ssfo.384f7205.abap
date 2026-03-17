DATA : LV_VBELN TYPE VBELN,
       LV_WERKS TYPE T001W-WERKS,
       LV_ADRNR TYPE ADRNR.


*BREAK SANSARI.

SELECT SINGLE VBELN WERKS FROM LIPS INTO (LV_VBELN , LV_WERKS)
  WHERE VBELN = IS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.
*  GS_IT_GEN-DELIV_NUMB."IT_LIKP-VBELN.
* CST and EXCISE NO HARDCODED.
LV_CST = 'CST NO: 27970515697 C'.
LV_EXCise = 'Excise No: AACCD2898LXM002'.

IF SY-SUBRC = 0.
  SELECT SINGLE ADRNR INTO LV_ADRNR
  FROM T001W
  WHERE WERKS = LV_WERKS.

  IF SY-SUBRC = 0.
    SELECT SINGLE A~ADDRNUMBER
                  A~NAME1
                  A~STR_SUPPL1
                  A~STR_SUPPL2
                  A~STREET
                  A~CITY1
                  A~POST_CODE1
                  B~BEZEI
      INTO BF_ADRC
      FROM ADRC AS A JOIN T005U AS B
      ON ( B~LAND1 = A~COUNTRY AND B~BLAND = A~REGION )
      WHERE ADDRNUMBER = LV_ADRNR.



*
*    SELECT SINGLE NAME1
*                  STR_SUPPL1
*                  STR_SUPPL2
*                  STREET
*                  CITY1
*                  POST_CODE1
**                  TEL_NUMBER
*                  "FAX_NUMBER
*                  "COUNTRY
*      FROM ADRC
*            INTO (G_NAME_P,
*                  G_STR_SUPPL1_P,
*                  G_STR_SUPPL2_P,
*                  G_STREET_P,
*                  G_CITY_P,
*                  G_POST_CODE_P
***                 " G_TEL_NUMBER_P
**                  "G_FAX_NUMBER_P,
**                  "L_COUNTRY
*      )
*            WHERE ADDRNUMBER = LV_ADRNR.
  ENDIF.
endif.
*======================================
* Code for Vendor CST / Excise no
*======================================

SELECT J_1ICSTNO
       J_1IEXRN
       J_1ILSTNO
  FROM J_1IMOCUST
  INTO (VEN_CST,
        VEN_EXCISE,
        VEN_LST)
  WHERE KUNNR = GS_HD_ADR-PARTN_NUMB.
ENDSELECT.

*  SELECT zebeln
*    from likp
*    into v_zebeln
*    where vbeln = IS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.
*  ENDSELECT.
*break-point.

SELECT SINGLE ZEBELN
  FROM LIKP
  INTO V_ZEbelN
  WHERE VBELN = IS_DLV_DELNOTE-HD_GEN-DELIV_NUMB."V_DCS_NO.

IF SY-SUBRC = 0.
*  SELECT  ebeln
*          ebelp
*          MATNR
*          menge
*          meins
*     FROM EKPO
*     INTO CORRESPONDING FIELDS OF wa_ekpo
*    WHERE EBELN = V_ZEBelN.
*  ENDSELECT.

  SELECT  ebeln
          ebelp
          MATNR
          menge
          meins
          netwr
          netpr
     FROM EKPO
     INTO table it_ekpo
    WHERE EBELN = V_ZEBelN.

  IF sy-subrc = 0.
    select matnr
           BAUGR
           ERFMG
           ebeln
           ebelp
    from resb
    into table it_resb
    for all entries in it_ekpo
    where BAUGR = it_ekpo-matnr
    and ebeln =  it_ekpo-ebeln
    and ebelp = it_ekpo-ebelp.
  ENDIF.

endif.

SELECT single EBELN
              AEDAT
        from  ekko
        into CORRESPONDING FIELDS OF wa_ekko
        where ebeln = V_ZEBELN.
