
SELECT * FROM QALS INTO TABLE it_QALS
  WHERE PRUEFLOS = P_LOT.

    SELECT * FROM qamb INTO TABLE it_qamb
      FOR ALL ENTRIES IN it_qals
      WHERE prueflos EQ it_qals-prueflos
        AND typ EQ '3'.

  IF it_qamb IS NOT INITIAL .

    SELECT
             mblnr
             mjahr
             zeile
             lgort
             menge
             sgtxt
             matnr
                    FROM mseg INTO TABLE it_mseg
                    FOR ALL ENTRIES IN it_qamb
                    WHERE mblnr = it_qamb-mblnr
                      AND mjahr = it_qamb-mjahr
                      AND xauto = 'X'
                      AND bwart = '321'.

  ENDIF.

IF IT_MSEG IS NOT INITIAL .
SELECT MATNR
       LGORT
       LGPBE
  FROM MARD INTO TABLE IT_MARD
  FOR ALL ENTRIES IN IT_MSEG
  WHERE MATNR = IT_MSEG-MATNR
  AND   LGORT = IT_MSEG-LGORT.
ENDIF.

LOOP AT  it_qals INTO wa_qals.
  wa_final-prueflos = wa_qals-prueflos.
  wa_final-matnr = wa_qals-matnr.

*BREAK PRIMUS.


  SELECT SINGLE * FROM MARA
    INTO WA_MARA
    WHERE matnr = wa_qals-matnr.

    SELECT SINGLE * FROM ZMOC_DES
      INTO WA_MOCDES
      WHERE MOC = WA_MARA-MOC.

*SELECT SINGLE BUDAT FROM QALS
*        INTO WA_BUDAT
*        WHERE PRUEFLOS = P_LOT.
*BREAK PRIMUS.

SELECT SINGLE MAKTX FROM MAKT
       INTO WA_MAKTX
       WHERE MATNR = WA_QALS-MATNR.


LOOP AT it_qamb INTO wa_qamb WHERE prueflos = wa_qals-prueflos .

wa_cpudt = wa_qamb-cpudt.

*      READ TABLE it_mseg INTO wa_mseg WITH KEY mblnr = wa_qamb-mblnr  mjahr = wa_qamb-mjahr.

* created by supriya jagtap : 102423 : 21-06-2024
READ TABLE it_mseg INTO wa_mseg WITH KEY mblnr = wa_qamb-mblnr  mjahr = wa_qamb-mjahr.


*   BREAK PRIMUS.
*     LV_MENGE1 = WA_MSEG-MENGE.            "ADDED BY GANGA TO DELETE DECIMALS

      IF sy-subrc = 0.
*        wa_final-sgtxt      = wa_mseg-sgtxt.
*        wa_final-lgort      = wa_mseg-lgort.
*        IF wa_mseg-lgort = 'RM01'.
*          wa_final-rm01_menge = wa_mseg-menge.
*
*        ENDIF.
**        IF wa_mseg-lgort = 'TPI1'.
**          wa_final-tpi1_menge = wa_mseg-menge.
**        ENDIF.
*        IF wa_mseg-lgort = 'RJ01'.
*          wa_final-rj01_menge = wa_mseg-menge.
**        lv_menge2 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'RWK1'.
*          wa_final-rwk1_menge = wa_mseg-menge.
**        lv_menge3 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'SCR1'.
*          wa_final-scr1_menge =  wa_mseg-menge.
**        lv_menge4 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'SRN1'.
*          wa_final-srn1_menge = wa_mseg-menge.
**        lv_menge5 = wa_final-rm01_menge.
*        ENDIF.
    ENDIF.

* CREATED BY SUPRIYA JAGTAP: 102423 : 21/06/2024

  IF wa_mseg-LGORT = 'SAN1'.
     GV_FROMPLACE = 'Sangavi'.
  ELSEIF wa_mseg-LGORT+0(1) = 'K'.
    GV_FROMPLACE = 'Kapurhol'.
    IF wa_mseg-lgort = 'KRM0'.
          wa_final-rm01_menge = wa_mseg-menge.

        ENDIF.
*        IF wa_mseg-lgort = 'TPI1'.
*          wa_final-tpi1_menge = wa_mseg-menge.
*        ENDIF.
        IF wa_mseg-lgort = 'KRJ0'.
          wa_final-rj01_menge = wa_mseg-menge.
*        lv_menge2 = wa_final-rm01_menge.
        ENDIF.
        IF wa_mseg-lgort = 'KRWK'.
          wa_final-rwk1_menge = wa_mseg-menge.
*        lv_menge3 = wa_final-rm01_menge.
        ENDIF.
        IF wa_mseg-lgort = 'KSCR'.
          wa_final-scr1_menge =  wa_mseg-menge.
*        lv_menge4 = wa_final-rm01_menge.
        ENDIF.
        IF wa_mseg-lgort = 'KSRN'.
          wa_final-srn1_menge = wa_mseg-menge.
*        lv_menge5 = wa_final-rm01_menge.
        ENDIF.
  ELSEIF wa_mseg-LGORT = 'RM01' OR wa_mseg-LGORT = 'FG01' OR
     wa_mseg-LGORT = 'MCN1' OR wa_mseg-LGORT = 'PLG1' OR wa_mseg-LGORT = 'PN01'
     OR wa_mseg-LGORT = 'PRD1' OR wa_mseg-LGORT = 'RJ01'
     OR wa_mseg-LGORT = 'RWK1' OR wa_mseg-LGORT = 'TPI1' OR  wa_mseg-LGORT = 'VLD1' OR wa_mseg-lgort = 'SRN1' or
     wa_mseg-lgort = 'SCR1'.
     GV_FROMPLACE = 'Kavathe,Satara'.
     IF wa_mseg-lgort = 'RM01'.
          wa_final-rm01_menge = wa_mseg-menge.
          ENDIF.
*        IF wa_mseg-lgort = 'TPI1'.
*          wa_final-tpi1_menge = wa_mseg-menge.
*        ENDIF.
*        ENDIF.

        IF wa_mseg-lgort = 'RJ01'.
          wa_final-rj01_menge = wa_mseg-menge.
*        lv_menge2 = wa_final-rm01_menge.
        ENDIF.
        IF wa_mseg-lgort = 'RWK1'.
          wa_final-rwk1_menge = wa_mseg-menge.
*        lv_menge3 = wa_final-rm01_menge.
        ENDIF.
        IF wa_mseg-lgort = 'SCR1'.
          wa_final-scr1_menge =  wa_mseg-menge.
*        lv_menge4 = wa_final-rm01_menge.
        ENDIF.
        IF wa_mseg-lgort = 'SRN1'.
          wa_final-srn1_menge = wa_mseg-menge.
*        lv_menge5 = wa_final-rm01_menge.
        ENDIF.
  endif.

READ TABLE IT_MARD INTO WA_MARD WITH KEY MATNR = WA_MSEG-MATNR LGORT = WA_MSEG-LGORT.
IF SY-SUBRC = 0.
  WA_FINAL-LGPBE = WA_MARD-LGPBE.
ENDIF.
      CLEAR :wa_mseg.
    ENDLOOP.
    CLEAR : wa_qamb.
    APPEND wa_final TO it_final.
* lv_menge1 = wa_final-rm01_menge.
ENDLOOP.
*BREAK primus.
