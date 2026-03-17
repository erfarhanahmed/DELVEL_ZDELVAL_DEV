
*break sansari.

*Types : begin of tt_ekpo,
*          ebeln TYPE ekpo-ebeln,
*          ebelp TYPE ekpo-ebelp,
*          netwr type ekpo-netwr,
*        end of tt_ekpo,
Types : begin of tt_ekpo,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          MATNR TYPE ekpo-matnr,
          menge TYPE ekpo-menge,
          meins TYPE ekpo-meins,
          netwr type ekpo-netwr,
          netpr type ekpo-netpr,
        end of tt_ekpo,

        begin of tt_likp,
          vbeln TYPE likp-vbeln,
          zebeln  TYPE likp-zebeln,
          lfart TYPE likp-lfart,
         END OF tt_likp.

Data: it_ekpo type STANDARD TABLE OF tt_ekpo   ,
*      wa_ekpo type tt_ekpo,

      it_likp TYPE STANDARD TABLE OF tt_likp.
*      wa_likp TYPE tt_likp.

select vbeln zebeln lfart from likp
  into table it_likp
  where vbeln =  IS_DLV_DELNOTE-HD_GEN-DELIV_NUMB
          and lfart = 'LB'.

  If not it_likp is INITIAL.
    select ebeln ebelp matnr menge meins netwr netpr from ekpo
      into TABLE it_ekpo
      FOR ALL ENTRIES IN it_likp
      where ebeln = it_likp-zebeln.
  ENDIF.

   if sy-subrc = 0.
     sort it_ekpo by ebeln ebelp.
   endif.
*====================================================
*   Code for Processed Material.
*----------------------------------------------------
   SELECT SINGLE ZEBELN
  FROM LIKP
  INTO V_ZEbelN
  WHERE VBELN = IS_DLV_DELNOTE-HD_GEN-DELIV_NUMB."V_DCS_NO.
  IF SY-SUBRC = 0.
    SELECT SINGLE MATNR netpr
    FROM EKPO
    INTO (V_MATNR, v_rate)
    WHERE EBELN = V_ZEBelN.

*    IF SY-SUBRC = 0.
*      SELECT SINGLE MAKTX
*     FROM MAKT
*     INTO V_MAKTX
*     WHERE MATNR = V_MATNR.
*    ENDIF.
  ENDIF.

   read table it_EKPO into wa_EKPO index 1.


* ===================================================
*   Code for Drawing Material for processed material.
*----------------------------------------------------
*
*SELECT SINGLE zeinr
*     FROM mara
*     INTO V_zeinr
*     WHERE MATNR = V_MATNR.

*------------------------------------------
* ===================================================
*   Code for Drawing Material for header material.
*----------------------------------------------------

SELECT SINGLE zeinr
     FROM mara
     INTO V_zeinr1
     WHERE MATNR = v_matnr_hd.

 "IS_DLV_DELNOTE-IT_GEN.

"
