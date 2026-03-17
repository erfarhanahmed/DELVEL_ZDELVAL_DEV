*&---------------------------------------------------------------------*
*&  Include           ZFI_PUR_REGISTER_01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
  DATA:
    LT_BSEG        TYPE TT_BSEG,
    LT_BSEG1       TYPE TT_BSEG,
    LS_BSEG        TYPE T_BSEG,
    LT_MAT_MAST    TYPE TT_MAT_MAST,
    LS_MAT_MAST    TYPE T_MAT_MAST,
    LT_ADRC        TYPE TT_ADRC,
    LS_ADRC        TYPE T_ADRC,
    LT_DD07T       TYPE TT_DD07T,
    LS_DD07T       TYPE T_DD07T,
    LT_ZGST_REGION TYPE TT_ZGST_REGION,
    LS_ZGST_REGION TYPE T_ZGST_REGION,
    LT_SKAT        TYPE TT_SKAT,
    LS_SKAT        TYPE T_SKAT,
    LT_MARC        TYPE TT_MARC,
    LS_MARC        TYPE T_MARC,
    LT_EKET        TYPE TT_EKET,
    LS_EKET        TYPE T_EKET,
    LT_T007S       TYPE TT_T007S,
    LS_T007S       TYPE T_T007S,
    LT_QALS        TYPE TT_QALS,
    LS_QALS        TYPE T_QALS,
    LT_QAMB        TYPE TT_QAMB,
    LS_QAMB        TYPE T_QAMB,
    LT_MSEG        TYPE TT_MSEG,
    LS_MSEG        TYPE T_MSEG,
    LT_T163Y       TYPE TT_T163Y,
    LS_T163Y       TYPE T_T163Y,
    LT_RSEG        LIKE GT_RSEG OCCURS 0 WITH HEADER LINE.
*    LV_HWBAS       TYPE BSEG-HWBAS.


  DATA:WA_EINE TYPE EINE.

  DATA:
    LV_INDEX TYPE SY-TABIX,
    LV_ID    TYPE THEAD-TDNAME,
    LT_LINES TYPE STANDARD TABLE OF TLINE,
    LS_LINES TYPE TLINE.

  DATA:
    LV_CGST TYPE BSET-HWSTE,
    LV_SGST TYPE BSET-HWSTE,
    LV_IGST TYPE BSET-HWSTE.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      TEXT       = 'Reading data...'(i01)
      PERCENTAGE = 1.

*Get Data from BKPF Table 'RE' Docs

  SELECT BUKRS
         BELNR
         GJAHR
         BLART
         BLDAT
         BUDAT
         XBLNR
         WAERS
         KURSF
         AWKEY
         TCODE
         XBLNR_ALT
         XMWST
  FROM BKPF
  INTO TABLE GT_BKPF
  WHERE GJAHR IN S_GJAHR "bukrs IN s_bukrs
*    AND gjahr IN s_gjahr
    AND BUDAT IN S_BUDAT
    AND BLART IN ('RE','RL','KG','KR','RX' , 'ZA' )
    AND BUKRS = '1000'.

  SORT GT_BKPF BY BELNR BLART.
  LOOP AT GT_BKPF.
    GT_BKPF-G_BELNR = GT_BKPF-AWKEY+0(10).
    GT_BKPF-G_GJAHR = GT_BKPF-AWKEY+10(4).
    IF SY-SUBRC EQ 0.
      MODIFY GT_BKPF TRANSPORTING G_BELNR G_GJAHR.
    ENDIF.
  ENDLOOP.


*** Getting MIGO no.
  IF GT_BKPF[] IS NOT INITIAL .


    SELECT BELNR
           GJAHR
           LIFNR
           BLART
           BLDAT
           XRECH
           STBLG
           ZUONR
           BKTXT

    FROM RBKP
    INTO TABLE GT_RBKP
    FOR ALL ENTRIES IN GT_BKPF
    WHERE BELNR = GT_BKPF-G_BELNR
      AND GJAHR = GT_BKPF-G_GJAHR
      AND TCODE IN ('MIRO','MIR7', 'MRRL')
      AND RBSTAT = '5'
      AND LIFNR IN S_LIFNR. "MODIFIED BY PJ " avinash bhagat

    IF NOT GT_RBKP[] IS INITIAL.
      SELECT LIFNR
             NAME1
             REGIO
             ORT01
             LAND1
             ADRNR
             STCD3
        FROM LFA1
        INTO TABLE GT_LFA1
        FOR ALL ENTRIES IN GT_RBKP
        WHERE LIFNR = GT_RBKP-LIFNR.
*        and lifnr in s_lifnr. " avinash bhagat

      IF GT_LFA1[] IS NOT INITIAL.
        SELECT LIFNR AKONT
          FROM LFB1
          INTO TABLE GT_LFB1
          FOR ALL ENTRIES IN GT_LFA1
          WHERE LIFNR = GT_LFA1-LIFNR.
*          and lifnr in s_lifnr. "avinash bhagat
*            AND bukrs IN s_bukrs.

      ENDIF.

      SELECT BELNR
             GJAHR
             BUZEI
             EBELN
             EBELP
             MATNR
             BUKRS
             WRBTR
             MENGE
             MEINS
             SHKZG
             MWSKZ
             BKLAS
             BNKAN
             KSCHL
             LFBNR
             LFGJA
             LFPOS
             WERKS
             STUNR
             EXKBE
             PSTYP
             XEKBZ
      FROM RSEG
      INTO TABLE GT_RSEG
      FOR ALL ENTRIES IN GT_RBKP
      WHERE BELNR = GT_RBKP-BELNR
        AND GJAHR = GT_RBKP-GJAHR
        AND WERKS IN S_WERKS
        AND EBELN IN S_EBELN.
*        and lifnr in s_lifnr.   " avinash bhagat
*        and bustw = 'RE01'.        " Added to Remove Auto Parked Invoices and not Posted
    ENDIF.
  ENDIF.
*********** Changing Document Item Numbering in RSEG based on BSET ***********

  GT_RSEG_V1[] = GT_RSEG[].
  LT_RSEG[] = GT_RSEG[].
  SORT GT_RSEG_V1 BY BELNR GJAHR.
  DELETE ADJACENT DUPLICATES FROM GT_RSEG_V1 COMPARING BELNR GJAHR.

  SORT GT_RSEG BY BELNR GJAHR BUZEI ASCENDING.
  DELETE LT_RSEG WHERE LFBNR IS INITIAL.
  IF NOT LT_RSEG[] IS INITIAL .
    LOOP AT LT_RSEG.
      CONCATENATE LT_RSEG-LFBNR LT_RSEG-LFGJA
             INTO LT_RSEG-AWKEY.
      IF SY-SUBRC EQ 0.
        MODIFY LT_RSEG TRANSPORTING AWKEY.
      ENDIF.
    ENDLOOP.

  ENDIF.
  DATA  : LV_BUZEI TYPE BUZEI.

  LOOP AT GT_RSEG_V1.
    CLEAR : LV_BUZEI.
    LOOP AT GT_RSEG WHERE BELNR = GT_RSEG_V1-BELNR
                      AND GJAHR = GT_RSEG_V1-GJAHR .
      LV_BUZEI      = LV_BUZEI + 1.
      GT_RSEG-BUZEI = LV_BUZEI.
      MODIFY GT_RSEG TRANSPORTING BUZEI.
    ENDLOOP.
  ENDLOOP.

  CLEAR : LV_BUZEI, GT_RSEG_V1[].
*******************************************

  GT_RSEG_V1[] = GT_RSEG[].
  SORT GT_RSEG_V1 BY BELNR GJAHR EBELN EBELP.
  SORT GT_RSEG BY BELNR GJAHR EBELN EBELP.
  DELETE ADJACENT DUPLICATES FROM GT_RSEG_V1 COMPARING BELNR GJAHR EBELN EBELP.

  DATA:
    LV_IND   TYPE SY-TABIX,
    LV_MENGE TYPE MSEG-MENGE.

  IF GT_RSEG_V1[] IS NOT INITIAL.
    LOOP AT GT_RSEG_V1.
      READ TABLE GT_RSEG WITH KEY BELNR = GT_RSEG_V1-BELNR
                                  GJAHR = GT_RSEG_V1-GJAHR
                                  EBELN = GT_RSEG_V1-EBELN
                                  EBELP = GT_RSEG_V1-EBELP.

      IF SY-SUBRC IS INITIAL AND GT_RSEG-LFBNR IS NOT INITIAL.
        LV_IND = SY-TABIX.
        LOOP AT GT_RSEG FROM LV_IND.
          IF GT_RSEG-BELNR = GT_RSEG_V1-BELNR AND GT_RSEG-GJAHR = GT_RSEG_V1-GJAHR AND GT_RSEG-LFBNR IS NOT INITIAL
          AND GT_RSEG-EBELN = GT_RSEG_V1-EBELN AND GT_RSEG-EBELP = GT_RSEG_V1-EBELP.
            LV_MENGE = LV_MENGE + GT_RSEG-MENGE.
          ELSE.
            EXIT.
          ENDIF.

        ENDLOOP.
        GT_RSEG_V1-MENGE = LV_MENGE.
        CLEAR LV_MENGE.
      ENDIF.
      CONCATENATE GT_RSEG_V1-LFBNR GT_RSEG_V1-LFGJA
             INTO GT_RSEG_V1-AWKEY.
      IF SY-SUBRC EQ 0.
        MODIFY GT_RSEG_V1 TRANSPORTING AWKEY MENGE.
      ENDIF.
    ENDLOOP.

    SELECT BUKRS
           BELNR
           GJAHR
           BLART
           BLDAT
           BUDAT
           XBLNR
           WAERS
           KURSF
           AWKEY
           TCODE
    FROM BKPF
    INTO TABLE GT_BKPF_WE
    FOR ALL ENTRIES IN GT_RSEG_V1
    WHERE AWKEY = GT_RSEG_V1-AWKEY.

    IF NOT LT_RSEG IS INITIAL.
      SELECT BUKRS
             BELNR
             GJAHR
             BLART
             BLDAT
             BUDAT
             XBLNR
             WAERS
             KURSF
             AWKEY
             TCODE
             XBLNR_ALT
      FROM BKPF
      APPENDING TABLE GT_BKPF_WE
      FOR ALL ENTRIES IN LT_RSEG
      WHERE AWKEY = LT_RSEG-AWKEY.
    ENDIF.
    IF NOT GT_BKPF_WE[] IS INITIAL.
      SELECT BUKRS
             BELNR
             GJAHR
             BUZEI
             SHKZG
             DMBTR
             KTOSL
             ANLN1
             ANLN2
             HKONT
             EBELN
             EBELP
        FROM BSEG
        INTO TABLE LT_BSEG
        FOR ALL ENTRIES IN GT_BKPF_WE
        WHERE BUKRS = GT_BKPF_WE-BUKRS
        AND   BELNR = GT_BKPF_WE-BELNR
        AND   GJAHR = GT_BKPF_WE-GJAHR.
    ENDIF.
  ENDIF.


********** Processing SERVICE ENTRY SHEETS

  GT_RSEG_SES[] = GT_RSEG[].
  SORT GT_RSEG_SES BY PSTYP.
  DELETE GT_RSEG_SES WHERE PSTYP NE '9'.
  SORT GT_RSEG_SES BY BELNR GJAHR LFBNR LFGJA EBELN EBELP.
  DELETE ADJACENT DUPLICATES FROM GT_RSEG_SES COMPARING BELNR GJAHR LFBNR LFGJA EBELN EBELP.

  IF GT_RSEG_SES[] IS NOT INITIAL.
    SELECT EBELN
           EBELP
           GJAHR
           BELNR
           XBLNR
           LFGJA
           LFBNR
           LFPOS
           LSMNG
    FROM EKBE
    INTO TABLE GT_EKBE
    FOR ALL ENTRIES IN GT_RSEG_SES
    WHERE EBELN EQ GT_RSEG_SES-EBELN
      AND EBELP EQ GT_RSEG_SES-EBELP
      AND LFGJA EQ GT_RSEG_SES-LFGJA
      AND LFBNR EQ GT_RSEG_SES-LFBNR
      AND BEWTP EQ 'E'
      AND BWART EQ '101'.

  ENDIF.

***DATA:
**   ls_ekbe LIKE gt_ekbe.
  IF GT_EKBE[] IS NOT INITIAL.
    SORT GT_EKBE.
    LOOP AT GT_EKBE.
****      READ TABLE gt_ekbe INTO ls_ekbe INDEX sy-tabix + 1.
****      IF gt_ekbe-belnr = ls_ekbe-belnr AND gt_ekbe-ebeln = ls_ekbe-belnr AND gt_ekbe-ebelp = ls_ekbe-ebelp.
****        gt_ekbe-lsmng = gt_ekbe-lsmng +
****      ENDIF.
      CONCATENATE GT_EKBE-BELNR GT_EKBE-GJAHR
             INTO GT_EKBE-AWKEY.
      IF SY-SUBRC EQ 0.
        MODIFY GT_EKBE TRANSPORTING AWKEY.
      ENDIF.
    ENDLOOP.

    SELECT BUKRS
           BELNR
           GJAHR
           BLART
           BLDAT
           BUDAT
           XBLNR
           WAERS
           KURSF
           AWKEY
           TCODE
           XBLNR_ALT
    FROM BKPF
    INTO TABLE GT_BKPF_SES
    FOR ALL ENTRIES IN GT_EKBE
    WHERE GJAHR = GT_EKBE-GJAHR
      AND AWKEY = GT_EKBE-AWKEY.


    IF NOT GT_BKPF_SES[] IS INITIAL.
      SELECT BUKRS
             BELNR
             GJAHR
             BUZEI
             SHKZG
             DMBTR
             KTOSL
             ANLN1
             ANLN2
             HKONT
             EBELN
             EBELP
        FROM BSEG
        APPENDING TABLE LT_BSEG
        FOR ALL ENTRIES IN GT_BKPF_SES
        WHERE BUKRS = GT_BKPF_SES-BUKRS
        AND   BELNR = GT_BKPF_SES-BELNR
        AND   GJAHR = GT_BKPF_SES-GJAHR.
    ENDIF.
  ENDIF.

********** Processing IMPORT PO's

  GT_RSEG_IMP[] = GT_RSEG[].
  SORT GT_RSEG_IMP BY LFBNR.
  DELETE GT_RSEG_IMP WHERE LFBNR IS NOT INITIAL.
  SORT GT_RSEG_IMP BY EBELN EBELP.
  DELETE ADJACENT DUPLICATES FROM GT_RSEG_IMP COMPARING EBELN EBELP.

  IF GT_RSEG_IMP[] IS NOT INITIAL.
    SELECT EBELN
           EBELP
           GJAHR
           BELNR
           XBLNR
           LFGJA
           LFBNR
           LFPOS
           LSMNG
    FROM EKBE
    INTO TABLE GT_EKBE_IMP
    FOR ALL ENTRIES IN GT_RSEG_IMP
    WHERE EBELN EQ GT_RSEG_IMP-EBELN
      AND EBELP EQ GT_RSEG_IMP-EBELP
      AND BEWTP EQ 'E'
      AND BWART EQ '101'.
  ENDIF.
  SORT GT_EKBE_IMP BY BELNR DESCENDING EBELN EBELP.
  DELETE ADJACENT DUPLICATES FROM GT_EKBE_IMP COMPARING BELNR EBELN EBELP.


  IF GT_EKBE_IMP[] IS NOT INITIAL.

    LOOP AT GT_EKBE_IMP.
      CONCATENATE GT_EKBE_IMP-BELNR GT_EKBE_IMP-GJAHR
             INTO GT_EKBE_IMP-AWKEY.
      IF SY-SUBRC EQ 0.
        MODIFY GT_EKBE_IMP TRANSPORTING AWKEY.
      ENDIF.
    ENDLOOP.



  ENDIF.

  IF GT_EKBE_IMP IS NOT INITIAL.
    SELECT BUKRS
           BELNR
           GJAHR
           BLART
           BLDAT
           BUDAT
           XBLNR
           WAERS
           KURSF
           AWKEY
           TCODE
           XBLNR_ALT
    FROM BKPF
    INTO TABLE GT_BKPF_IMP
    FOR ALL ENTRIES IN GT_EKBE_IMP
    WHERE AWKEY = GT_EKBE_IMP-AWKEY.
  ENDIF.

  IF NOT GT_BKPF_IMP[] IS INITIAL.
    SELECT BUKRS
           BELNR
           GJAHR
           BUZEI
           SHKZG
           DMBTR
           KTOSL
           ANLN1
           ANLN2
           HKONT
           EBELN
           EBELP
      FROM BSEG
      APPENDING TABLE LT_BSEG
      FOR ALL ENTRIES IN GT_BKPF_IMP
      WHERE BUKRS = GT_BKPF_IMP-BUKRS
      AND   BELNR = GT_BKPF_IMP-BELNR
      AND   GJAHR = GT_BKPF_IMP-GJAHR.
  ENDIF.

  SELECT BUKRS
         BELNR
         GJAHR
         TXGRP
         SHKZG
         MWSKZ
         HWBAS
         HWSTE
         KTOSL
         KSCHL
         KBETR
         BUZEI
         HKONT
         KNUMH
         TAXPS   """"""""""  nc
  FROM BSET
  INTO TABLE GT_BSET
  FOR ALL ENTRIES IN GT_BKPF
  WHERE BUKRS = GT_BKPF-BUKRS
    AND BELNR = GT_BKPF-BELNR
    AND GJAHR = GT_BKPF-GJAHR .



  IF GT_LFA1[] IS NOT INITIAL .
    SELECT * FROM T005U
    INTO TABLE GT_T005U
    FOR ALL ENTRIES IN GT_LFA1
    WHERE SPRAS = SY-LANGU
      AND LAND1 = GT_LFA1-LAND1
      AND BLAND = GT_LFA1-REGIO.

    SELECT GST_REGION
           BEZEI
      FROM ZGST_REGION
      INTO TABLE LT_ZGST_REGION
      FOR ALL ENTRIES IN GT_T005U
      WHERE BEZEI = GT_T005U-BEZEI.

    SELECT ADDRNUMBER
           NAME1
           CITY2
           POST_CODE1
           STREET
           STR_SUPPL3
           LOCATION
           COUNTRY
      FROM ADRC
      INTO TABLE LT_ADRC
      FOR ALL ENTRIES IN GT_LFA1
      WHERE ADDRNUMBER = GT_LFA1-ADRNR.

    SELECT LIFNR
           J_1ILSTNO
           J_1IPANNO
           J_1ISERN
           J_1ICSTNO
           J_1IEXCD
           VEN_CLASS
           J_1ISSIST
      FROM J_1IMOVEND
      INTO TABLE GT_J_1IMOVEND
      FOR ALL ENTRIES IN GT_LFA1
      WHERE LIFNR EQ GT_LFA1-LIFNR.
  ENDIF.
  IF NOT GT_J_1IMOVEND[] IS INITIAL.
    SELECT VALPOS
           DDTEXT
           DOMVALUE_L
      FROM DD07T
      INTO TABLE LT_DD07T
      FOR ALL ENTRIES IN GT_J_1IMOVEND
      WHERE DOMNAME    = 'J_1IGTAXKD'
      AND   DOMVALUE_L = GT_J_1IMOVEND-VEN_CLASS
      AND   DDLANGUAGE = SY-LANGU.


  ENDIF.
  IF GT_RSEG[] IS NOT INITIAL .
    SELECT MBLNR
           MJAHR
           ZEILE
           BWART
           LGORT
           INSMK
           EBELN
           EBELP
           MENGE
           LSMNG
      FROM MSEG
      INTO TABLE LT_MSEG
      FOR ALL ENTRIES IN GT_RSEG
      WHERE MJAHR = GT_RSEG-LFGJA
      AND   MBLNR = GT_RSEG-LFBNR
      AND   ZEILE = GT_RSEG-LFPOS
      AND   BWART = '101'
      AND   LGORT = 'RM01'.
*      AND   insmk = space.

    SELECT PRUEFLOS
             EBELN
             EBELP
             MJAHR
             MBLNR
             ZEILE
        FROM QALS
        INTO TABLE LT_QALS
        FOR ALL ENTRIES IN GT_RSEG
        WHERE MJAHR = GT_RSEG-LFGJA
        AND   MBLNR = GT_RSEG-LFBNR
        AND   ZEILE = GT_RSEG-LFPOS.
    IF NOT LT_QALS IS INITIAL.
      SELECT PRUEFLOS
             MBLNR
             MJAHR
             ZEILE
        FROM QAMB
        INTO TABLE LT_QAMB
        FOR ALL ENTRIES IN LT_QALS
        WHERE PRUEFLOS = LT_QALS-PRUEFLOS
        AND   TYP = '3'.

      IF NOT LT_QAMB IS INITIAL.
        SELECT MBLNR
               MJAHR
               ZEILE
               BWART
               LGORT
               INSMK
               EBELN
               EBELP
               MENGE
               LSMNG
          FROM MSEG
          APPENDING TABLE LT_MSEG
          FOR ALL ENTRIES IN LT_QAMB
          WHERE MBLNR = LT_QAMB-MBLNR
          AND   MJAHR = LT_QAMB-MJAHR
*          AND   zeile = lt_qamb-zeile
          AND   BWART = '321'
          AND   XAUTO = 'X'.

      ENDIF.
    ENDIF.
    SELECT MATNR
           MAKTX
      FROM MAKT
      INTO TABLE GT_MAKT
      FOR ALL ENTRIES IN GT_RSEG
      WHERE MATNR = GT_RSEG-MATNR
      AND SPRAS = 'EN'.

    SELECT MATNR
           MTART
           MEINS
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE
      FROM MARA
      INTO TABLE LT_MAT_MAST
      FOR ALL ENTRIES IN GT_RSEG
      WHERE MATNR = GT_RSEG-MATNR.

    SELECT MWSKZ
           TEXT1
      FROM T007S
      INTO TABLE LT_T007S
      FOR ALL ENTRIES IN GT_RSEG
      WHERE MWSKZ = GT_RSEG-MWSKZ
      AND   KALSM = 'ZTAXIN'.

    SELECT MATNR
           WERKS
           STEUC
      FROM MARC
      INTO TABLE LT_MARC
      FOR ALL ENTRIES IN GT_RSEG
      WHERE MATNR = GT_RSEG-MATNR
      AND   WERKS = GT_RSEG-WERKS.

    SELECT EBELN
           EKORG
           EKGRP
           BSART
           AEDAT
           REVNO
    FROM EKKO
    INTO TABLE GT_EKKO
     FOR ALL ENTRIES IN GT_RSEG
    WHERE EBELN = GT_RSEG-EBELN.

    SELECT EBELN
           EBELP
           MATNR
           WERKS
           MENGE
           NETPR
           PEINH
           NETWR
           MWSKZ
           PSTYP
           KNTTP
           INFNR
    FROM EKPO
    INTO TABLE GT_EKPO
     FOR ALL ENTRIES IN GT_RSEG
    WHERE EBELN = GT_RSEG-EBELN
      AND EBELP = GT_RSEG-EBELP.

    SELECT EBELN
           EBELP
           ETENR
           EINDT
      FROM EKET
      INTO TABLE LT_EKET
      FOR ALL ENTRIES IN GT_EKPO
      WHERE EBELN = GT_EKPO-EBELN
      AND   EBELP = GT_EKPO-EBELP.

    SELECT PSTYP
           EPSTP
      FROM T163Y
      INTO TABLE LT_T163Y
      FOR ALL ENTRIES IN GT_EKPO
      WHERE SPRAS = SY-LANGU
      AND PSTYP = GT_EKPO-PSTYP.

    SORT GT_EKPO BY KNTTP.
    LOOP AT GT_EKPO WHERE KNTTP = 'A'  .
      MOVE-CORRESPONDING GT_EKPO TO GT_EKPO1.
      APPEND GT_EKPO1.
      CLEAR  GT_EKPO1.
    ENDLOOP.
    SORT GT_EKPO BY EBELN EBELP KNTTP.
  ENDIF.

  IF GT_EKPO1[] IS NOT INITIAL.
    SELECT EBELN EBELP ANLN1 ANLN2 SAKTO
      FROM EKKN
      INTO TABLE GT_EKKN
      FOR ALL ENTRIES IN GT_EKPO1
      WHERE EBELN = GT_EKPO1-EBELN
        AND EBELP = GT_EKPO1-EBELP.

    IF GT_EKKN[] IS NOT INITIAL.
      SELECT ANLN1
             ANLN2
             INVNR
             TXT50
        FROM ANLA
        INTO TABLE GT_ANLA
        FOR ALL ENTRIES IN GT_EKKN
        WHERE ANLN1 = GT_EKKN-ANLN1"bukrs IN s_bukrs
*          AND anln1 = gt_ekkn-anln1
          AND ANLN2 = GT_EKKN-ANLN2.
    ENDIF.
  ENDIF.

*** Populating FINAL TABLE

  SORT GT_RSEG_V1 BY BELNR EBELN EBELP.
  SORT GT_RSEG    BY BELNR EBELN EBELP.



  DATA(GN_RSEG) = GT_RSEG[] .


  LOOP AT GN_RSEG INTO DATA(WN_RSEG).

    CONCATENATE WN_RSEG-BELNR WN_RSEG-GJAHR INTO WN_RSEG-AWKEY .

*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        INPUT  = WN_RSEG-AWKEY
*      IMPORTING
*        OUTPUT = WN_RSEG-AWKEY.


    MODIFY GN_RSEG FROM  WN_RSEG TRANSPORTING AWKEY .
    CLEAR WN_RSEG .

  ENDLOOP.

  TYPES: BEGIN OF TY_BKPF ,
           BUKRS TYPE BKPF-BUKRS,
           BELNR TYPE BKPF-BELNR,
           GJAHR TYPE BKPF-GJAHR,
           AWKEY TYPE BKPF-AWKEY,
           EBELN TYPE RSEG-EBELN,
           EBELP TYPE RSEG-EBELP,
           TXGRP TYPE BSEG-TXGRP,
         END OF TY_BKPF.


  TYPES: BEGIN OF TY_RSEG_NW ,
           BUKRS      TYPE BKPF-BUKRS,
           BELNR      TYPE RSEG-BELNR,
           GJAHR      TYPE RSEG-GJAHR,
           EBELN      TYPE RSEG-EBELN,
           EBELP      TYPE RSEG-EBELP,
           LFGJA      TYPE RSEG-LFGJA,
           BUZEI      TYPE RSEG-LFGJA,  """"""""""" ADDED BY NC 18.02.2026
           LFBNR      TYPE RSEG-LFBNR,
           LFPOS      TYPE RSEG-LFPOS,
           AWKEY      TYPE BKPF-AWKEY,
           TXGRP      TYPE BSEG-TXGRP,
           TAXPS      TYPE BSEG-TAXPS,
           BKPF_BUKRS TYPE BKPF-BUKRS,
           BKPF_BELNR TYPE BKPF-BELNR,
           BKPF_GJAHR TYPE BKPF-GJAHR,
           XREF3      TYPE BSEG-XREF3,



         END OF TY_RSEG_NW.

  DATA: GN_RSEG_NW TYPE TABLE OF TY_RSEG_NW,
        WN_RSEG_NW TYPE TY_RSEG_NW.



  DATA : GN_BKPF TYPE TABLE OF TY_BKPF.
  DATA : GN_BKPF1 TYPE TABLE OF TY_BKPF.


  SELECT  BUKRS, BELNR, GJAHR , AWKEY   """""""" step 2
    FROM BKPF
    INTO CORRESPONDING FIELDS OF  TABLE @GN_BKPF
      FOR ALL ENTRIES IN @GN_RSEG
        WHERE AWKEY = @GN_RSEG-AWKEY .

  LOOP AT  GN_RSEG INTO WN_RSEG   .
    READ TABLE GN_BKPF INTO DATA(WN_BKPF) WITH KEY AWKEY = WN_RSEG-AWKEY.
    MOVE-CORRESPONDING WN_RSEG TO WN_RSEG_NW .

    WN_RSEG_NW-BKPF_BUKRS = WN_BKPF-BUKRS .
    WN_RSEG_NW-BKPF_BELNR = WN_BKPF-BELNR .
    WN_RSEG_NW-BKPF_GJAHR = WN_BKPF-GJAHR .
*    WN_RSEG_NW-BKPF_GJAHR = WN_BKPF-LFGJA.


    WN_RSEG_NW-LFGJA  = WN_RSEG-LFGJA.
    WN_RSEG_NW-LFBNR  = WN_RSEG-LFBNR.
    WN_RSEG_NW-LFPOS  = WN_RSEG-LFPOS.

    IF  WN_RSEG_NW-LFGJA IS NOT INITIAL .

      CONCATENATE WN_RSEG_NW-LFGJA
                  WN_RSEG_NW-LFBNR
                  WN_RSEG_NW-LFPOS
       INTO   WN_RSEG_NW-XREF3 .
    ENDIF.

    APPEND WN_RSEG_NW TO GN_RSEG_NW .
    CLEAR : WN_RSEG_NW .

  ENDLOOP.







  IF  GN_RSEG_NW IS NOT INITIAL .
    SELECT TXGRP,EBELN,EBELP,BUKRS,BELNR, GJAHR,KTOSL,XREF3 """"""""""" step 3
      FROM BSEG
       FOR ALL ENTRIES IN @GN_RSEG_NW
        WHERE  BUKRS = @GN_RSEG_NW-BKPF_BUKRS
           AND BELNR = @GN_RSEG_NW-BKPF_BELNR
           AND GJAHR = @GN_RSEG_NW-BKPF_GJAHR
           AND EBELN = @GN_RSEG_NW-EBELN
           AND EBELP = @GN_RSEG_NW-EBELP
*           AND XREF3 = @GN_RSEG_NW-XREF3      """"""""""" CMT BY NC 18.02.2026
           INTO TABLE @DATA(GN_BSEG_NR).
  ENDIF.

  CLEAR: WN_RSEG_NW .
  LOOP AT GN_RSEG_NW INTO WN_RSEG_NW .
    READ TABLE GN_BSEG_NR INTO DATA(WA_BT) WITH KEY  BUKRS = WN_RSEG_NW-BKPF_BUKRS
                                                          BELNR = WN_RSEG_NW-BKPF_BELNR
                                                          GJAHR = WN_RSEG_NW-BKPF_GJAHR
                                                          EBELN = WN_RSEG_NW-EBELN
                                                          EBELP = WN_RSEG_NW-EBELP
                                                          TXGRP = WN_RSEG_NW-BUZEI .
*                                                          XREF3 = WN_RSEG_NW-XREF3 .



    IF SY-SUBRC EQ 0 .
      WN_RSEG_NW-TXGRP = WA_BT-TXGRP.
      MODIFY GN_RSEG_NW FROM WN_RSEG_NW TRANSPORTING TXGRP .

    ENDIF.
    CLEAR: WN_RSEG,WA_BT.
  ENDLOOP.



  SELECT * FROM BSET
     INTO TABLE @DATA(IT_BSET_NR)
      FOR ALL ENTRIES IN @GN_RSEG_NW
         WHERE BUKRS = @GN_RSEG_NW-BKPF_BUKRS
          AND  BELNR = @GN_RSEG_NW-BKPF_BELNR
          AND  GJAHR = @GN_RSEG_NW-BKPF_GJAHR
*          AND  EBELN = @GN_BSEG_NR-EBELN
*          AND  EBELP = @GN_BSEG_NR-EBELP
           AND  TXGRP = @GN_RSEG_NW-TXGRP .


  CLEAR : WN_BKPF .



  LOOP AT IT_BSET_NR INTO DATA(WA_BSET_NR) .
    MOVE-CORRESPONDING WA_BSET_NR TO GT_BSET1.

    READ TABLE GN_RSEG_NW INTO DATA(WA_BT1) WITH KEY   BKPF_BUKRS =  WA_BSET_NR-BUKRS
                                                BKPF_BELNR =  WA_BSET_NR-BELNR
                                                BKPF_GJAHR =  WA_BSET_NR-GJAHR
                                                TXGRP      =  WA_BSET_NR-TXGRP .



*      GT_BSET1-XEKBZ = WA_BSG-XEKBZ.
    GT_BSET1-EBELN = WA_BT1-EBELN.
    GT_BSET1-EBELP = WA_BT1-EBELP.
*    GT_BSET1-KTOSL = WA_BSET_NR-KTOSL.

    CASE GT_BSET1-KTOSL.
      WHEN 'JIC'.
        GT_BSET1-KSCHL = 'JICG'.
      WHEN 'JII'.
        GT_BSET1-KSCHL = 'JIIG'.
      WHEN 'JIS'.
        GT_BSET1-KSCHL = 'JISG'.
      WHEN 'JIM'.
        GT_BSET1-KSCHL = 'JIMD'.
      WHEN 'JRC'.
        GT_BSET1-KSCHL = 'JICR'.
      WHEN 'JRS'.
        GT_BSET1-KSCHL = 'JISR'.
      WHEN 'JRI'.
        GT_BSET1-KSCHL = 'JIIR'.

    ENDCASE.
    APPEND GT_BSET1.
    CLEAR  GT_BSET1.
  ENDLOOP.

*  SORT GN_RSEG BY BUKRS GJAHR  BELNR EBELN EBELP .
*  DELETE ADJACENT DUPLICATES FROM GN_RSEG COMPARING BUKRS GJAHR  BELNR EBELN EBELP .

*  SORT GN_BKPF1 BY BUKRS BELNR   GJAHR   EBELN EBELP.
*  DELETE ADJACENT DUPLICATES FROM GN_BKPF1 COMPARING BUKRS BELNR   GJAHR   EBELN  EBELP.


*
*  LOOP AT GN_RSEG INTO WN_RSEG.
*
*    READ TABLE  GN_BKPF1 INTO WN_BKPF  WITH KEY AWKEY = WN_RSEG-AWKEY .
*
*    IF SY-SUBRC EQ 0 .
*      READ TABLE  GN_BSEG_NR INTO DATA(WN_BSEG_NR) WITH KEY        BUKRS =  WN_BKPF-BUKRS
*                                                           BELNR =  WN_BKPF-BELNR
*                                                           GJAHR =  WN_BKPF-GJAHR
*                                                           EBELN =  WN_BKPF-EBELN
*                                                           EBELP =  WN_BKPF-EBELP .
*      IF SY-SUBRC EQ 0.
*        LOOP AT   GN_BSEG_NR1 INTO DATA(WN_BSEG_NR1) WHERE  GJAHR = WN_BSEG_NR-GJAHR
*                                                      AND  BUKRS = WN_BSEG_NR-BUKRS
*                                                      AND  BELNR = WN_BSEG_NR-BELNR
*                                                      AND  TXGRP = WN_BSEG_NR-TXGRP .
*
*
*          READ TABLE IT_BSET_NR INTO DATA(WN_BSET_NR) WITH KEY  BUKRS = WN_BSEG_NR-BUKRS
*                                                                BELNR = WN_BSEG_NR-BELNR
*                                                                GJAHR = WN_BSEG_NR-GJAHR
*                                                                TXGRP = WN_BSEG_NR-TXGRP.
*          IF SY-SUBRC EQ 0.
*            MOVE-CORRESPONDING WN_BSET_NR TO GT_BSET1.
**      GT_BSET1-XEKBZ = WA_BSG-XEKBZ.
*            GT_BSET1-EBELN = WN_BSEG_NR-EBELN.
*            GT_BSET1-EBELP = WN_BSEG_NR-EBELP.
*            GT_BSET1-KTOSL = WN_BSEG_NR1-KTOSL.
*
*            CASE GT_BSET1-KTOSL.
*              WHEN 'JIC'.
*                GT_BSET1-KSCHL = 'JICG'.
*              WHEN 'JII'.
*                GT_BSET1-KSCHL = 'JIIG'.
*              WHEN 'JIS'.
*                GT_BSET1-KSCHL = 'JISG'.
*              WHEN 'JIM'.
*                GT_BSET1-KSCHL = 'JIMD'.
*              WHEN 'JRC'.
*                GT_BSET1-KSCHL = 'JICR'.
*              WHEN 'JRS'.
*                GT_BSET1-KSCHL = 'JISR'.
*              WHEN 'JRI'.
*                GT_BSET1-KSCHL = 'JIIR'.
*
*            ENDCASE.
*
*
*
*
*            GT_BSET1-TXGRP = WN_BSEG_NR-TXGRP.
*
*            APPEND GT_BSET1.
*            CLEAR  GT_BSET1.
*
*          ENDIF.
*
**          CLEAR : WN_BSEG_NR1 .
*        ENDLOOP.
*      ENDIF.
**        CLEAR : WN_BSEG_NR .
**    ENDLOOP .
*
*    ENDIF.
*    CLEAR : WN_RSEG ,WN_BKPF.
*  ENDLOOP.


*  LOOP AT IT_BSET_NR INTO DATA(WA_BSET_NR) .
*
*    READ TABLE GN_BSEG_NR1 INTO DATA(WA_BSG) WITH KEY BUKRS = WA_BSET_NR-BUKRS
*                                                     BELNR = WA_BSET_NR-BELNR
*                                                     GJAHR = WA_BSET_NR-GJAHR
*                                                     TXGRP = WA_BSET_NR-TXGRP
*                                                     KTOSL = WA_BSET_NR-KTOSL .
*    IF SY-SUBRC EQ 0 .
*
*      MOVE-CORRESPONDING WA_BSET_NR TO GT_BSET1.
**      GT_BSET1-XEKBZ = WA_BSG-XEKBZ.
*      GT_BSET1-EBELN = WA_BSG-EBELN.
*      GT_BSET1-EBELP = WA_BSG-EBELP.
*      APPEND GT_BSET1.
*      CLEAR  GT_BSET1.
*    ENDIF.
*  ENDLOOP .

****** New Code for BSET
*  LOOP AT GT_RSEG.
*    READ TABLE GT_BKPF WITH KEY G_BELNR = GT_RSEG-BELNR
*                                G_GJAHR = GT_RSEG-GJAHR.
*    IF SY-SUBRC = 0 .
*      loop at  IT_BSEG_NR INTO DATA(WA_BSEG_NR) where       GJAHR =  GT_RSEG-GJAHR
*                                                 and        EBELN =  GT_RSEG-EBELN
*                                                 and        EBELP =  GT_RSEG-EBELP
*                                                 and        BELNR = GT_BKPF-BELNR
*                                                 and        BUKRS = GT_BKPF-BUKRS
*                                                 and        txgrp ne space .
*
*
*
*      IF SY-SUBRC = 0.
**      LOOP AT GT_BSET WHERE BELNR = GT_BKPF-BELNR
**                         AND txgrp = gt_rseg-buzei.
***                         AND TAXPS = GT_RSEG-BUZEI   """""
**                        AND MWSKZ  = GT_RSEG-MWSKZ    """""
**                        AND HWBAS  = GT_RSEG-WRBTR .  """""
*
*        LOOP AT GT_BSET WHERE   BELNR  = WA_BSEG_NR-BELNR
*                            AND TXGRP  = WA_BSEG_NR-TXGRP
*                            AND BUKRS  = WA_BSEG_NR-BUKRS
*                            AND GJAHR  = WA_BSEG_NR-GJAHR .
*
*
*
*
*          MOVE-CORRESPONDING GT_BSET TO GT_BSET1.
*
*          GT_BSET1-XEKBZ = GT_RSEG-XEKBZ.
*          GT_BSET1-EBELN = GT_RSEG-EBELN.
*          GT_BSET1-EBELP = GT_RSEG-EBELP.
*          APPEND GT_BSET1.
*          CLEAR  GT_BSET1.
**        ENDLOOP.
*        ENDLOOP.
**    APPEND gt_rseg.
*      ENDIF.
*      ENDLOOP .
*
*    ENDIF.
*  ENDLOOP.
****** End of New Code for BSET

*  DELETE GT_BSET1 WHERE  XEKBZ = 'X'.
*  SORT GT_BSET1 BY TXGRP HWBAS KTOSL  .   """" added by nc
*  DELETE ADJACENT DUPLICATES FROM GT_BSET1 COMPARING TXGRP HWBAS KTOSL   . """""  added by nc

  CLEAR : GT_FINAL[].

  SORT GT_BKPF    BY G_BELNR G_GJAHR.
  SORT GT_RSEG_V1 BY BELNR GJAHR EBELN EBELP.
  SORT GT_BSET1   BY BELNR EBELN EBELP.
  SORT LT_BSEG BY BELNR GJAHR BUZEI.
  DELETE ADJACENT DUPLICATES FROM LT_BSEG.
  SORT LT_QALS BY PRUEFLOS MBLNR MJAHR EBELN EBELP.
  SORT LT_QAMB BY PRUEFLOS.

  IF NOT LT_BSEG IS INITIAL.
    SELECT SAKNR
           TXT20
      FROM SKAT
      INTO TABLE LT_SKAT
      FOR ALL ENTRIES IN LT_BSEG
      WHERE SAKNR = LT_BSEG-HKONT
      AND   SPRAS = SY-LANGU
      AND   KTOPL = '1000'.
  ENDIF.



  LT_BSEG1 = LT_BSEG.
***  DELETE lt_bseg1 WHERE ktosl NE 'BSX'.
***  DELETE lt_bseg2 WHERE ktosl NE 'FRL'.
  SORT LT_BSEG1 BY BELNR GJAHR EBELN EBELP.
  SORT LT_MSEG BY MBLNR MJAHR EBELN EBELP.

  DATA : LV_FLG TYPE CHAR1.
*BREAK primus.
  LOOP AT GT_RSEG_V1.


    READ TABLE GT_BKPF WITH KEY G_BELNR = GT_RSEG_V1-BELNR
                                G_GJAHR = GT_RSEG_V1-GJAHR
                                TCODE   = 'MIRO'
                                XMWST   = 'X'.

    IF SY-SUBRC NE 0 .
      READ TABLE GT_BKPF WITH KEY G_BELNR = GT_RSEG_V1-BELNR
                                  G_GJAHR = GT_RSEG_V1-GJAHR
                                  TCODE   = 'MIR7'
                                    XMWST   = 'X'.
    ENDIF.
    IF SY-SUBRC NE 0 .
      READ TABLE GT_BKPF WITH KEY G_BELNR = GT_RSEG_V1-BELNR
                            G_GJAHR = GT_RSEG_V1-GJAHR
                            TCODE   = 'MRRL'
                             XMWST   = 'X'.
    ENDIF.


    IF SY-SUBRC NE 0 .
      READ TABLE GT_BKPF WITH KEY G_BELNR = GT_RSEG_V1-BELNR
                            G_GJAHR = GT_RSEG_V1-GJAHR
                            TCODE   = 'MIRO'
                            XMWST   = ' '.
    ENDIF.
    IF SY-SUBRC NE 0 .
      READ TABLE GT_BKPF WITH KEY G_BELNR = GT_RSEG_V1-BELNR
                                  G_GJAHR = GT_RSEG_V1-GJAHR
                                  TCODE   = 'MIR7'
                                    XMWST   = ' '.
    ENDIF.
    IF SY-SUBRC NE 0 .
      READ TABLE GT_BKPF WITH KEY G_BELNR = GT_RSEG_V1-BELNR
                            G_GJAHR = GT_RSEG_V1-GJAHR
                            TCODE   = 'MRRL'
                             XMWST   = ' '.
    ENDIF.

    IF SY-SUBRC = 0.
      READ TABLE GT_RBKP WITH KEY BELNR = GT_BKPF-G_BELNR
                                  GJAHR = GT_BKPF-G_GJAHR.
      IF SY-SUBRC = 0.
        GT_FINAL-MIRO_AC_DOC = GT_BKPF-BELNR.     " MIRO A/C Doc No
        GT_FINAL-BLART       = GT_BKPF-BLART.     " FI Doc Type


        IF GT_RBKP-BLDAT IS NOT INITIAL  AND GT_RBKP-BLDAT NE '00000000' .


          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              INPUT  = GT_RBKP-BLDAT
            IMPORTING
              OUTPUT = GT_FINAL-BLDAT.

          CONCATENATE GT_FINAL-BLDAT+0(2) GT_FINAL-BLDAT+2(3) GT_FINAL-BLDAT+5(4)
                     INTO GT_FINAL-BLDAT SEPARATED BY '-'.

        ENDIF.
*        IF NOT gt_bkpf-budat IS INITIAL.  commented by swati on 21.02.2019
**          CONCATENATE gt_bkpf-budat+6(2) gt_bkpf-budat+4(2) gt_bkpf-budat+0(4) INTO  gt_final-bill_dt SEPARATED BY '-'.
*        ELSE.
*          gt_final-bill_dt = 'NULL' .
*        ENDIF.
        GT_FINAL-BILL_DT     = GT_BKPF-BUDAT.
        GT_FINAL-AWKEY       = GT_BKPF-G_BELNR.   " Bill Booking No.
        GT_FINAL-INV_NO      = GT_BKPF-XBLNR.     " Inv/Bill No.
        GT_FINAL-XBLNR_ALT   = GT_BKPF-XBLNR_ALT. " ODN.

*        IF NOT gt_bkpf-bldat IS INITIAL.  "changed by swati on 21.02.2019
*          CONCATENATE gt_bkpf-bldat+6(2) gt_bkpf-bldat+4(2) gt_bkpf-bldat+0(4) INTO  gt_final-inv_dt SEPARATED BY '-'.
        GT_FINAL-INV_DT = GT_BKPF-BLDAT.
*        ELSE.
*          gt_final-inv_dt = 'NULL' .
*        ENDIF.
        GT_FINAL-TCODE       = GT_BKPF-TCODE.     " T-Code
        GT_FINAL-WAERS       = GT_BKPF-WAERS.     " Document Currency
        GT_FINAL-KURSF       = GT_BKPF-KURSF.     " Exchange rate
        GT_FINAL-LIFNR = GT_RBKP-LIFNR.      " Vendor
        GT_FINAL-ZUONR = GT_RBKP-ZUONR.      " Original Inv No.
        GT_FINAL-BKTXT = GT_RBKP-BKTXT.      " Original Inv Dt
        REPLACE ALL OCCURRENCES OF '.' IN GT_FINAL-BKTXT WITH '-'.
        READ TABLE GT_LFA1 WITH KEY LIFNR = GT_RBKP-LIFNR.
        IF SY-SUBRC = 0.
          GT_FINAL-NAME1 = GT_LFA1-NAME1.    " Vendor Name
          GT_FINAL-STCD3 = GT_LFA1-STCD3.
          READ TABLE GT_T005U WITH KEY BLAND = GT_LFA1-REGIO.
          IF SY-SUBRC = 0.
            GT_FINAL-BEZEI = GT_T005U-BEZEI. " State
          ENDIF.
          READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY BEZEI = GT_T005U-BEZEI.
          IF SY-SUBRC IS INITIAL.
            GT_FINAL-GST_REGION = LS_ZGST_REGION-GST_REGION.
          ENDIF.
          READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = GT_LFA1-ADRNR.
          IF SY-SUBRC IS INITIAL.
            IF NOT LS_ADRC-STREET IS INITIAL.
              CONCATENATE GT_FINAL-ADDRESS LS_ADRC-STREET INTO GT_FINAL-ADDRESS.
            ENDIF.

            IF NOT LS_ADRC-STR_SUPPL3 IS INITIAL.
              CONCATENATE GT_FINAL-ADDRESS LS_ADRC-STR_SUPPL3 INTO GT_FINAL-ADDRESS SEPARATED BY ','.
            ENDIF.
            IF NOT LS_ADRC-LOCATION IS INITIAL.
              CONCATENATE GT_FINAL-ADDRESS LS_ADRC-LOCATION INTO GT_FINAL-ADDRESS SEPARATED BY ','.
            ENDIF.

            IF NOT LS_ADRC-CITY2 IS INITIAL.
              CONCATENATE GT_FINAL-ADDRESS LS_ADRC-CITY2 INTO GT_FINAL-ADDRESS SEPARATED BY ','.
            ENDIF.
            IF NOT LS_ADRC-POST_CODE1 IS INITIAL.
              CONCATENATE GT_FINAL-ADDRESS 'PIN:' LS_ADRC-POST_CODE1 INTO GT_FINAL-ADDRESS SEPARATED BY ','.
            ENDIF.
            CONDENSE GT_FINAL-ADDRESS.

          ENDIF.

          READ TABLE GT_J_1IMOVEND WITH KEY LIFNR = GT_LFA1-LIFNR.
          IF SY-SUBRC = 0.
            GT_FINAL-TIN_NO =   GT_J_1IMOVEND-J_1ICSTNO.
            GT_FINAL-LST_NO =   GT_J_1IMOVEND-J_1ILSTNO.

            IF GT_J_1IMOVEND-J_1ISSIST = '1'.
              GT_FINAL-J_1ISSIST = 'Micro'.
            ELSEIF GT_J_1IMOVEND-J_1ISSIST = '2'.
              GT_FINAL-J_1ISSIST = 'Small'.
            ELSEIF GT_J_1IMOVEND-J_1ISSIST = '3'.
              GT_FINAL-J_1ISSIST = 'Medium'.
            ELSEIF GT_J_1IMOVEND-J_1ISSIST = '4'.
              GT_FINAL-J_1ISSIST = 'NA'.
            ENDIF.

          ENDIF.
          READ TABLE LT_DD07T INTO LS_DD07T WITH KEY DOMVALUE_L = GT_J_1IMOVEND-VEN_CLASS.
          IF SY-SUBRC IS INITIAL.
            GT_FINAL-GST_TXT = LS_DD07T-DDTEXT.
          ENDIF.
          READ TABLE GT_LFB1 WITH KEY LIFNR = GT_LFA1-LIFNR.
          IF SY-SUBRC = 0.
            GT_FINAL-AKONT = GT_LFB1-AKONT.
          ENDIF.
        ENDIF.


        READ TABLE GT_BKPF_WE WITH KEY AWKEY = GT_RSEG_V1-AWKEY.
        IF SY-SUBRC = 0.

          IF NOT GT_BKPF_WE-BUDAT IS INITIAL AND GT_BKPF_WE-BUDAT NE '00000000' .
            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                INPUT  = GT_BKPF_WE-BUDAT
              IMPORTING
                OUTPUT = GT_FINAL-BUDAT.

            CONCATENATE GT_FINAL-BUDAT+0(2) GT_FINAL-BUDAT+2(3) GT_FINAL-BUDAT+5(4)
                       INTO GT_FINAL-BUDAT SEPARATED BY '-'.


*            CONCATENATE gt_bkpf_we-budat+6(2) gt_bkpf_we-budat+4(2) gt_bkpf_we-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
          ELSE.
            GT_FINAL-BUDAT = 'NULL' .
          ENDIF.

          GT_FINAL-BELNR = GT_BKPF_WE-BELNR.    " FI document No.
          READ TABLE LT_BSEG1 INTO LS_BSEG WITH KEY BUKRS = GT_BKPF_WE-BUKRS
                                                    BELNR = GT_BKPF_WE-BELNR
                                                    GJAHR = GT_BKPF_WE-GJAHR
                                                    EBELP = GT_RSEG_V1-EBELP
                                                    KTOSL = 'BSX'.
          IF SY-SUBRC IS INITIAL.
            LV_INDEX = SY-TABIX.
            GT_FINAL-HKONT   = LS_BSEG-HKONT.
            LOOP AT LT_BSEG1 INTO LS_BSEG FROM LV_INDEX.
              IF LS_BSEG-BUKRS = GT_BKPF_WE-BUKRS AND LS_BSEG-BELNR = GT_BKPF_WE-BELNR AND LS_BSEG-KTOSL = 'BSX'
                AND LS_BSEG-GJAHR = GT_BKPF_WE-GJAHR AND LS_BSEG-EBELP = GT_RSEG_V1-EBELP.
                IF LS_BSEG-SHKZG = 'S'.
                  GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT + LS_BSEG-DMBTR.
                ELSE.
                  GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT - LS_BSEG-DMBTR.
                ENDIF.

              ENDIF.
            ENDLOOP.

          ELSE.
            READ TABLE LT_BSEG1 INTO LS_BSEG WITH KEY BUKRS = GT_BKPF_WE-BUKRS
                                                      BELNR = GT_BKPF_WE-BELNR
                                                      GJAHR = GT_BKPF_WE-GJAHR
                                                      EBELP = GT_RSEG_V1-EBELP
                                                      KTOSL = 'FRL'.
            IF SY-SUBRC IS INITIAL.
              LV_INDEX = SY-TABIX.
              GT_FINAL-HKONT   = LS_BSEG-HKONT.
              LOOP AT LT_BSEG1 INTO LS_BSEG FROM LV_INDEX.
                IF LS_BSEG-BUKRS = GT_BKPF_WE-BUKRS AND LS_BSEG-BELNR = GT_BKPF_WE-BELNR AND LS_BSEG-KTOSL = 'FRL'
                  AND LS_BSEG-GJAHR = GT_BKPF_WE-GJAHR AND LS_BSEG-EBELP = GT_RSEG_V1-EBELP.
                  GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT + LS_BSEG-DMBTR.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ELSE.
          READ TABLE LT_RSEG WITH KEY BELNR = GT_RSEG_V1-BELNR
                                      GJAHR = GT_RSEG_V1-GJAHR
                                      EBELN = GT_RSEG_V1-EBELN
                                      EBELP = GT_RSEG_V1-EBELP.
          IF SY-SUBRC IS INITIAL.
            CLEAR GT_BKPF_WE.
            READ TABLE GT_BKPF_WE WITH KEY AWKEY = LT_RSEG-AWKEY.
            IF SY-SUBRC = 0.
*              gt_final-budat = gt_bkpf_we-budat .   " MIGO Date.
              IF NOT GT_BKPF_WE-BUDAT IS INITIAL AND GT_BKPF_WE-BUDAT NE '00000000' .                 "ADDED BY SNEHAL RAJALE ON 2 APRIL 2021.
                CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                  EXPORTING
                    INPUT  = GT_BKPF_WE-BUDAT
                  IMPORTING
                    OUTPUT = GT_FINAL-BUDAT.

                CONCATENATE GT_FINAL-BUDAT+0(2) GT_FINAL-BUDAT+2(3) GT_FINAL-BUDAT+5(4)
                INTO GT_FINAL-BUDAT SEPARATED BY '-'.

*                CONCATENATE gt_bkpf_imp-budat+6(2) gt_bkpf_imp-budat+4(2) gt_bkpf_imp-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
              ELSE.
                GT_FINAL-BUDAT = 'NULL' .   " MIGO Date.
              ENDIF.

              GT_FINAL-BELNR = GT_BKPF_WE-BELNR.    " FI document No.

            ENDIF.
          ENDIF.
          READ TABLE LT_BSEG1 INTO LS_BSEG WITH KEY BUKRS = GT_BKPF_WE-BUKRS
                                                    BELNR = GT_BKPF_WE-BELNR
                                                    GJAHR = GT_BKPF_WE-GJAHR
                                                    EBELP = GT_RSEG_V1-EBELP
                                                    KTOSL = 'BSX'.
          IF SY-SUBRC IS INITIAL.
            LV_INDEX = SY-TABIX.
            GT_FINAL-HKONT   = LS_BSEG-HKONT.
            LOOP AT LT_BSEG1 INTO LS_BSEG FROM LV_INDEX.
              IF LS_BSEG-BUKRS = GT_BKPF_WE-BUKRS AND LS_BSEG-BELNR = GT_BKPF_WE-BELNR AND LS_BSEG-KTOSL = 'BSX'
                AND LS_BSEG-GJAHR = GT_BKPF_WE-GJAHR AND LS_BSEG-EBELP = GT_RSEG_V1-EBELP.
                GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT + LS_BSEG-DMBTR.
              ENDIF.
            ENDLOOP.
          ELSE.
            READ TABLE LT_BSEG1 INTO LS_BSEG WITH KEY BUKRS = GT_BKPF_WE-BUKRS
                                                    BELNR = GT_BKPF_WE-BELNR
                                                    GJAHR = GT_BKPF_WE-GJAHR
                                                    EBELP = GT_RSEG_V1-EBELP
                                                    KTOSL = 'FRL'.
            IF SY-SUBRC IS INITIAL.
              LV_INDEX = SY-TABIX.
              GT_FINAL-HKONT   = LS_BSEG-HKONT.
              LOOP AT LT_BSEG1 INTO LS_BSEG FROM LV_INDEX.
                IF LS_BSEG-BUKRS = GT_BKPF_WE-BUKRS AND LS_BSEG-BELNR = GT_BKPF_WE-BELNR AND LS_BSEG-KTOSL = 'FRL'
                  AND LS_BSEG-GJAHR = GT_BKPF_WE-GJAHR AND LS_BSEG-EBELP = GT_RSEG_V1-EBELP.
                  GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT + LS_BSEG-DMBTR.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
        GT_FINAL-EBELP = GT_RSEG_V1-EBELP.     " PO item
        GT_FINAL-EBELN = GT_RSEG_V1-EBELN.     " PO No.

        READ TABLE LT_EKET INTO LS_EKET WITH KEY EBELN = GT_FINAL-EBELN
                                                 EBELP = GT_FINAL-EBELP.
        IF SY-SUBRC IS INITIAL.
          IF NOT LS_EKET-EINDT IS INITIAL AND LS_EKET-EINDT NE '00000000'.
            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                INPUT  = LS_EKET-EINDT
              IMPORTING
                OUTPUT = GT_FINAL-EINDT.

            CONCATENATE GT_FINAL-EINDT+0(2) GT_FINAL-EINDT+2(3) GT_FINAL-EINDT+5(4)
                       INTO GT_FINAL-EINDT SEPARATED BY '-'.

*            CONCATENATE ls_eket-eindt+6(2) ls_eket-eindt+4(2) ls_eket-eindt+0(4) INTO gt_final-eindt SEPARATED BY '-'.
          ELSE.
            GT_FINAL-EINDT = 'NULL' .
          ENDIF.
        ELSE.
          GT_FINAL-EINDT = 'NULL' .
        ENDIF.
****** New Code for BSET
        CLEAR: LV_CGST,LV_SGST,LV_IGST.",LV_HWBAS.

        LOOP AT GT_BSET1 WHERE BELNR = GT_BKPF-BELNR
                           AND EBELN = GT_RSEG_V1-EBELN
                           AND EBELP = GT_RSEG_V1-EBELP.
*                           and hwbas = GT_RSEG_V1-wrbtr.
*                           and mwskz = GT_RSEG_V1-mwskz .
*                           AND TAXPS = GT_RSEG_v1-BUZEI  .   """"" nc
          "and gjahr = gt_bkpf-gjahr .


*          CLEAR: WA_BS .

*          READ TABLE GT_BSET1 INTO WA_BS WITH KEY       BELNR = GT_BKPF-BELNR
*                                                        EBELN = GT_RSEG_V1-EBELN
*                                                        EBELP = GT_RSEG_V1-EBELP
*                                                        XEKBZ = 'X'.


**          IF gt_bset1-kschl = 'JEC1' OR gt_bset1-kschl = 'JEC2' .
***          gt_final-ecs = gt_final-ecs + gt_bset-hwste.
***            gt_final-ecs = gt_final-ecs + gt_bset1-hwste.
**          ENDIF.
**          IF gt_bset1-kschl = 'JSEP' OR gt_bset1-kschl = 'JSEI' .
***          gt_final-hcess = gt_final-hcess + gt_bset-hwste.
**            gt_final-hcess = gt_final-hcess + gt_bset1-hwste.
**          ENDIF.

          IF GT_BSET1-KSCHL = 'JVCS'.
*          gt_final-cst_tax = gt_final-cst_tax + gt_bset-hwste.
            GT_FINAL-CST_TAX = GT_FINAL-CST_TAX + GT_BSET1-HWSTE.
            GT_FINAL-CST     = GT_BSET1-KBETR / 10.
            IF GT_FINAL-MWSKZ IS INITIAL AND GT_BSET1-HWSTE IS NOT INITIAL.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.
          IF GT_BSET1-KSCHL = 'JMOP' OR GT_BSET1-KSCHL = 'JMOQ' .
*          gt_final-bed = gt_final-bed + gt_bset-hwste.
            GT_FINAL-BED = GT_FINAL-BED + GT_BSET1-HWSTE.
            IF GT_FINAL-MWSKZ IS INITIAL AND GT_BSET1-HWSTE IS NOT INITIAL.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.
          IF GT_BSET1-KSCHL = 'JAOP' OR GT_BSET1-KSCHL = 'JAOQ' .
*          gt_final-aed = gt_final-aed + gt_bset-hwste.
            GT_FINAL-AED =  GT_FINAL-AED + GT_BSET1-HWSTE.
            IF GT_FINAL-MWSKZ IS INITIAL AND GT_BSET1-HWSTE IS NOT INITIAL.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.
          IF GT_BSET1-KSCHL = 'JVRD' OR GT_BSET1-KSCHL = 'JVRN'.
*          gt_final-vat_tax = gt_final-vat_tax + gt_bset-hwste.
            GT_FINAL-VAT_TAX = GT_FINAL-VAT_TAX + GT_BSET1-HWSTE.
            GT_FINAL-VAT     = GT_BSET1-KBETR / 10.
            IF GT_FINAL-MWSKZ IS INITIAL AND GT_BSET1-HWSTE IS NOT INITIAL.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.

          IF GT_BSET1-KSCHL = 'JICG' OR GT_BSET1-KSCHL = 'JICN'
          OR GT_BSET1-KSCHL = 'JICR' OR GT_BSET1-KSCHL = 'ZCRN'.
            IF GT_BSET1-SHKZG = 'H'.
              LV_CGST = LV_CGST - GT_BSET1-HWSTE.
            ELSE.
              LV_CGST = LV_CGST + GT_BSET1-HWSTE.
            ENDIF.

          ENDIF.

          IF GT_BSET1-KSCHL = 'JICG' OR GT_BSET1-KSCHL = 'JICN'.
*            OR gt_bset1-kschl = 'JICR' OR gt_bset1-kschl = 'ZCRN'.                               "CGST

*            IF    LV_HWBAS NE GT_BSET1-HWBAS .
*            IF WA_BS-XEKBZ = 'X'.
            GT_FINAL-CGST_TAX = GT_FINAL-CGST_TAX + GT_BSET1-HWSTE.  """""""" NC
*            ELSEIF  WA_BS-XEKBZ NE 'X'.
*              GT_FINAL-CGST_TAX =  GT_BSET1-HWSTE.
*            ENDIF.



            IF NOT GT_BSET1-KBETR IS INITIAL AND GT_BSET1-KSCHL = 'JICG'.
              GT_FINAL-CGST     = GT_BSET1-KBETR / 10.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.
          IF GT_BSET1-KSCHL = 'JISG' OR GT_BSET1-KSCHL = 'JISN'.
*            OR gt_bset1-kschl = 'JISR' OR gt_bset1-kschl = 'ZSRN'.                               "SGST

*            IF WA_BS-XEKBZ = 'X'.
            GT_FINAL-SGST_TAX = GT_FINAL-SGST_TAX + GT_BSET1-HWSTE.
*            ELSEIF  WA_BS-XEKBZ NE 'X'.
*              GT_FINAL-SGST_TAX =  GT_BSET1-HWSTE.
*            ENDIF.

            IF NOT GT_BSET1-KBETR IS INITIAL AND GT_BSET1-KSCHL = 'JISG'.
              GT_FINAL-SGST  = GT_BSET1-KBETR / 10.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.

          ENDIF.

          IF GT_BSET1-KSCHL = 'JISG' OR GT_BSET1-KSCHL = 'JISN'
          OR GT_BSET1-KSCHL = 'JISR' OR GT_BSET1-KSCHL = 'ZSRN'.
            IF GT_BSET1-SHKZG = 'H'.
              LV_SGST = LV_SGST - GT_BSET1-HWSTE.
            ELSE.
              LV_SGST = LV_SGST + GT_BSET1-HWSTE.
            ENDIF.
          ENDIF.

          IF GT_BSET1-KSCHL = 'JIIG' OR GT_BSET1-KSCHL = 'JIIN'
            OR GT_BSET1-KSCHL = 'JIMD' .                               "IGST
*            IF WA_BS-XEKBZ = 'X'.                                        """"""" NC
            GT_FINAL-IGST_TAX = GT_FINAL-IGST_TAX + GT_BSET1-HWSTE.
*            ELSEIF  WA_BS-XEKBZ NE 'X'.                                  """"""" NC
*              GT_FINAL-IGST_TAX =  GT_BSET1-HWSTE.
*            ENDIF.

            IF NOT GT_BSET1-KBETR IS INITIAL AND GT_BSET1-KSCHL = 'JIIG'.
              GT_FINAL-IGST     = GT_BSET1-KBETR / 10.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.
          IF GT_BSET1-KSCHL = 'JIIG' OR GT_BSET1-KSCHL = 'JIIN'
          OR GT_BSET1-KSCHL = 'ZIRN' OR GT_BSET1-KSCHL = 'JIMD'.
            IF GT_BSET1-SHKZG = 'H'.
              LV_IGST = LV_IGST - GT_BSET1-HWSTE.
            ELSE.
              LV_IGST = LV_IGST + GT_BSET1-HWSTE.
            ENDIF.
          ENDIF.

          IF GT_BSET1-KSCHL = 'JSER' OR GT_BSET1-KSCHL = 'JSVD' OR GT_BSET1-KSCHL = 'JSV2'.

            IF GT_BSET1-SHKZG = 'S'.
*            gt_final-ser_val_dr = gt_final-ser_val_dr + gt_bset-hwste.
              GT_FINAL-SER_VAL_DR = GT_FINAL-SER_VAL_DR + GT_BSET1-HWSTE.
            ELSEIF GT_BSET1-SHKZG = 'H'.
*            gt_final-ser_val_cr = gt_final-ser_val_cr + gt_bset-hwste.
              GT_FINAL-SER_VAL_DR = GT_FINAL-SER_VAL_DR - GT_BSET1-HWSTE.
            ENDIF.
            IF GT_FINAL-MWSKZ IS INITIAL.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.

          IF GT_BSET1-KSCHL = 'JSSB'.

            IF GT_BSET1-SHKZG = 'S'.
*            gt_final-sbc_dr = gt_final-sbc_dr + gt_bset-hwste.
              GT_FINAL-SBC_DR = GT_FINAL-SBC_DR + GT_BSET1-HWSTE.
            ELSEIF GT_BSET1-SHKZG = 'H'.
*            gt_final-sbc_cr = gt_final-sbc_cr + gt_bset-hwste.
              GT_FINAL-SBC_DR = GT_FINAL-SBC_DR - GT_BSET1-HWSTE.
            ENDIF.
            IF GT_FINAL-MWSKZ IS INITIAL.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.

          IF GT_BSET1-KSCHL = 'JKKP' OR GT_BSET1-KSCHL = 'ZKKR' OR GT_BSET1-KSCHL = 'JKKN' OR GT_BSET1-KSCHL = 'JSKK'
          OR GT_BSET1-KSCHL = 'JKK1' OR GT_BSET1-KSCHL = 'JKK2' OR GT_BSET1-KSCHL = 'JKK3' OR GT_BSET1-KSCHL = 'JKK4' .
            IF GT_BSET1-SHKZG = 'S'.
*            gt_final-kkc_dr = gt_final-kkc_dr + gt_bset-hwste.
              GT_FINAL-KKC_DR = GT_FINAL-KKC_DR + GT_BSET1-HWSTE.
            ELSEIF GT_BSET-SHKZG = 'H'.
*            gt_final-kkc_cr = gt_final-kkc_cr + gt_bset-hwste.
              GT_FINAL-KKC_DR = GT_FINAL-KKC_DR - GT_BSET1-HWSTE.
            ENDIF.
            IF GT_FINAL-MWSKZ IS INITIAL AND GT_BSET1-HWSTE IS NOT INITIAL.
              GT_FINAL-MWSKZ = GT_BSET1-MWSKZ.
            ENDIF.
          ENDIF.
*          LV_HWBAS = GT_BSET1-HWBAS .
        ENDLOOP.


**********          Service entry Sheet's MIGO No.
        IF GT_RSEG_V1-PSTYP = '9'.
          READ TABLE GT_EKBE WITH KEY EBELN = GT_RSEG_V1-EBELN
                                      EBELP = GT_RSEG_V1-EBELP
                                      LFBNR = GT_RSEG_V1-LFBNR .
          IF SY-SUBRC = 0.
            GT_FINAL-LFBNR = GT_EKBE-BELNR.   " MIGO No.
            CLEAR GT_BKPF_SES.
            READ TABLE GT_BKPF_SES WITH KEY GJAHR = GT_EKBE-GJAHR
                                            AWKEY = GT_EKBE-AWKEY.
            IF SY-SUBRC = 0.
*              gt_final-budat = gt_bkpf_ses-budat .   " MIGO Date.
              IF NOT GT_BKPF_SES-BUDAT IS INITIAL AND GT_BKPF_SES-BUDAT NE '00000000'.                 "ADDED BY SNEHAL RAJALE ON 2 APRIL 2021.
                CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                  EXPORTING
                    INPUT  = GT_BKPF_SES-BUDAT
                  IMPORTING
                    OUTPUT = GT_FINAL-BUDAT.

                CONCATENATE GT_FINAL-BUDAT+0(2) GT_FINAL-BUDAT+2(3) GT_FINAL-BUDAT+5(4)
                INTO GT_FINAL-BUDAT SEPARATED BY '-'.

*                CONCATENATE gt_bkpf_imp-budat+6(2) gt_bkpf_imp-budat+4(2) gt_bkpf_imp-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
              ELSE.
                GT_FINAL-BUDAT = 'NULL' .   " MIGO Date.
              ENDIF.

              GT_FINAL-BELNR = GT_BKPF_SES-BELNR.    " FI document No.


              READ TABLE LT_BSEG1 INTO LS_BSEG WITH KEY BUKRS = GT_BKPF_SES-BUKRS
                                                        BELNR = GT_BKPF_SES-BELNR
                                                        GJAHR = GT_BKPF_SES-GJAHR
                                                        EBELP = GT_RSEG_V1-EBELP
                                                        KTOSL = 'KBS'.
              IF SY-SUBRC IS INITIAL.
                LV_INDEX = SY-TABIX.
                GT_FINAL-HKONT   = LS_BSEG-HKONT.
                LOOP AT LT_BSEG1 INTO LS_BSEG FROM LV_INDEX.
                  IF LS_BSEG-BUKRS = GT_BKPF_SES-BUKRS AND LS_BSEG-BELNR = GT_BKPF_SES-BELNR AND LS_BSEG-KTOSL = 'KBS'
                    AND LS_BSEG-GJAHR = GT_BKPF_SES-GJAHR AND LS_BSEG-EBELP = GT_RSEG_V1-EBELP.

                    IF LS_BSEG-SHKZG = 'S'.
                      GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT + LS_BSEG-DMBTR.
                    ELSE.
                      GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT - LS_BSEG-DMBTR.
                    ENDIF.

                  ENDIF.
                ENDLOOP.
**              ELSE.
**                READ TABLE lt_bseg2 INTO ls_bseg WITH KEY bukrs = gt_bkpf_ses-bukrs
**                                                        belnr = gt_bkpf_ses-belnr
**                                                        gjahr = gt_bkpf_ses-gjahr
**                                                        ebelp = gt_rseg_v1-ebelp.
**                IF sy-subrc IS INITIAL.
**                  lv_index = sy-tabix.
**                  gt_final-hkont   = ls_bseg-hkont.
**                  LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
**                    IF ls_bseg-bukrs = gt_bkpf_ses-bukrs AND ls_bseg-belnr = gt_bkpf_ses-belnr
**                      AND ls_bseg-gjahr = gt_bkpf_ses-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
**
**                      IF ls_bseg-shkzg = 'S'.
**                        gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
**                      ELSE.
**                        gt_final-grn_amt = gt_final-grn_amt - ls_bseg-dmbtr.
**                      ENDIF.
**
**                    ENDIF.
**                  ENDLOOP.
**              ENDIF.
              ENDIF.

            ENDIF.
          ENDIF.
        ELSE.
          READ TABLE LT_RSEG WITH KEY BELNR = GT_RSEG_V1-BELNR
                                      GJAHR = GT_RSEG_V1-GJAHR
                                      EBELN = GT_RSEG_V1-EBELN
                                      EBELP = GT_RSEG_V1-EBELP.
          IF SY-SUBRC IS INITIAL.

*          gt_final-lfbnr = gt_rseg_v1-lfbnr.     " MIGO No.
            GT_FINAL-LFBNR = LT_RSEG-LFBNR.     " MIGO No.


            READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LT_RSEG-LFBNR
                                                       MJAHR = LT_RSEG-LFGJA
                                                       EBELN = LT_RSEG-EBELN
                                                       EBELP = LT_RSEG-EBELP
                                                       LGORT = 'RM01'
                                                       BWART = '101'.


            IF SY-SUBRC IS INITIAL.
              LV_INDEX = SY-TABIX.
              LOOP AT LT_MSEG INTO LS_MSEG FROM LV_INDEX.
                IF LS_MSEG-MBLNR = LT_RSEG-LFBNR AND LS_MSEG-MJAHR = LT_RSEG-LFGJA AND LS_MSEG-EBELN = LT_RSEG-EBELN
                  AND LS_MSEG-EBELP = LT_RSEG-EBELP AND LS_MSEG-LGORT = 'RM01' AND LS_MSEG-BWART = '101'.
*                    gt_final-acc_qty = gt_final-acc_qty + ls_mseg-menge .
                  GT_FINAL-LSMNG   = GT_FINAL-LSMNG + LS_MSEG-LSMNG.
                ENDIF.
              ENDLOOP.

            ENDIF.

            READ TABLE LT_QALS INTO LS_QALS WITH KEY MBLNR = LT_RSEG-LFBNR
                                                     MJAHR = LT_RSEG-LFGJA
                                                     EBELN = GT_RSEG_V1-EBELN
                                                     EBELP = GT_RSEG_V1-EBELP.
            IF SY-SUBRC IS INITIAL.
              LV_IND = SY-TABIX.
              LOOP AT LT_QALS INTO LS_QALS FROM LV_IND.
                IF LS_QALS-MBLNR = LT_RSEG-LFBNR AND LS_QALS-MJAHR = LT_RSEG-LFGJA
                AND LS_QALS-EBELN = GT_RSEG_V1-EBELN AND LS_QALS-EBELP = GT_RSEG_V1-EBELP.
                  READ TABLE LT_QAMB INTO LS_QAMB WITH KEY PRUEFLOS = LS_QALS-PRUEFLOS.
                  IF SY-SUBRC IS INITIAL.
                    LV_INDEX = SY-TABIX.
                    LOOP AT LT_QAMB INTO LS_QAMB FROM LV_INDEX.
                      IF LS_QAMB-PRUEFLOS = LS_QALS-PRUEFLOS.
                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                                 MJAHR = LS_QAMB-MJAHR
                                                                 EBELN = LT_RSEG-EBELN
                                                                 EBELP = LT_RSEG-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 LGORT = 'RM01'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-ACC_QTY = GT_FINAL-ACC_QTY + LS_MSEG-MENGE.

                        ENDIF.

                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                                 MJAHR = LS_QAMB-MJAHR
                                                                 EBELN = GT_RSEG_V1-EBELN
                                                                 EBELP = GT_RSEG_V1-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 LGORT = 'RJ01'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-REJ_QTY = GT_FINAL-REJ_QTY + LS_MSEG-MENGE.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                                 MJAHR = LS_QAMB-MJAHR
                                                                 EBELN = GT_RSEG_V1-EBELN
                                                                 EBELP = GT_RSEG_V1-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 LGORT = 'SCR1'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-SCP_QTY = GT_FINAL-SCP_QTY + LS_MSEG-MENGE.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                                 MJAHR = LS_QAMB-MJAHR
                                                                 EBELN = GT_RSEG_V1-EBELN
                                                                 EBELP = GT_RSEG_V1-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 LGORT = 'RWK1'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-REW_QTY = GT_FINAL-REW_QTY + LS_MSEG-MENGE.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.
                      ELSE.
                        EXIT.

                      ENDIF.
                    ENDLOOP.
                  ELSE.
                    EXIT.
                  ENDIF.
                ENDIF.
              ENDLOOP.
            ELSE.
              READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LT_RSEG-LFBNR
                                                       MJAHR = LT_RSEG-LFGJA
                                                       EBELN = LT_RSEG-EBELN
                                                       EBELP = LT_RSEG-EBELP
                                                       LGORT = 'RM01'
                                                       BWART = '101'.


              IF SY-SUBRC IS INITIAL.
                LV_INDEX = SY-TABIX.
                LOOP AT LT_MSEG INTO LS_MSEG FROM LV_INDEX.
                  IF LS_MSEG-MBLNR = LT_RSEG-LFBNR AND LS_MSEG-MJAHR = LT_RSEG-LFGJA AND LS_MSEG-EBELN = LT_RSEG-EBELN
                    AND LS_MSEG-EBELP = LT_RSEG-EBELP AND LS_MSEG-LGORT = 'RM01' AND LS_MSEG-BWART = '101'.
                    GT_FINAL-ACC_QTY = GT_FINAL-ACC_QTY + LS_MSEG-MENGE .
*                    gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                  ENDIF.
                ENDLOOP.

              ENDIF.

            ENDIF.


          ENDIF.
        ENDIF.
**********          Import PO's  MIGO No.
        IF GT_FINAL-LFBNR IS INITIAL AND GT_RSEG_V1-XEKBZ NE 'X'.
          READ TABLE GT_EKBE_IMP WITH KEY EBELN = GT_RSEG_V1-EBELN
                                          EBELP = GT_RSEG_V1-EBELP.
          IF SY-SUBRC = 0.
            GT_FINAL-LFBNR = GT_EKBE_IMP-BELNR.   " MIGO No.
            GT_FINAL-LSMNG = GT_EKBE_IMP-LSMNG.   " MIGO No.
            READ TABLE LT_QALS INTO LS_QALS WITH KEY MBLNR = GT_EKBE_IMP-LFBNR
                                                     MJAHR = GT_EKBE_IMP-LFGJA
                                                     EBELN = GT_RSEG_V1-EBELN
                                                     EBELP = GT_RSEG_V1-EBELP.
            IF SY-SUBRC IS INITIAL.
              LV_IND = SY-TABIX.
              LOOP AT LT_QALS INTO LS_QALS FROM LV_IND.
                IF LS_QALS-MBLNR = LT_RSEG-LFBNR AND LS_QALS-MJAHR = LT_RSEG-LFGJA
                AND LS_QALS-EBELN = GT_RSEG_V1-EBELN AND LS_QALS-EBELP = GT_RSEG_V1-EBELP.
                  IF SY-SUBRC IS INITIAL.
                    LV_INDEX = SY-TABIX.
                    LOOP AT LT_QAMB INTO LS_QAMB FROM LV_INDEX.
                      IF LS_QAMB-PRUEFLOS = LS_QALS-PRUEFLOS.
                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                             MJAHR = LS_QAMB-MJAHR
                                                             EBELN = GT_RSEG_V1-EBELN
                                                             EBELP = GT_RSEG_V1-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                             LGORT = 'RM01'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-ACC_QTY = GT_FINAL-ACC_QTY + LS_MSEG-MENGE.
                          GT_FINAL-LSMNG   = GT_FINAL-LSMNG + LS_MSEG-LSMNG.
                        ENDIF.

                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                                 MJAHR = LS_QAMB-MJAHR
                                                                 EBELN = GT_RSEG_V1-EBELN
                                                                 EBELP = GT_RSEG_V1-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 LGORT = 'RJ01'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-REJ_QTY = GT_FINAL-REJ_QTY + LS_MSEG-MENGE.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                                 MJAHR = LS_QAMB-MJAHR
                                                                 EBELN = GT_RSEG_V1-EBELN
                                                                 EBELP = GT_RSEG_V1-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 LGORT = 'SCR1'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-SCP_QTY = GT_FINAL-SCP_QTY + LS_MSEG-MENGE.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_QAMB-MBLNR
                                                                 MJAHR = LS_QAMB-MJAHR
                                                                 EBELN = GT_RSEG_V1-EBELN
                                                                 EBELP = GT_RSEG_V1-EBELP
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 LGORT = 'RWK1'.
                        IF SY-SUBRC IS INITIAL.
                          GT_FINAL-REW_QTY = GT_FINAL-REW_QTY + LS_MSEG-MENGE.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.
                      ELSE.
                        EXIT.

                      ENDIF.
                    ENDLOOP.
                  ELSE.
                    EXIT.

                  ENDIF.
                ENDIF.
              ENDLOOP.
*            ENDIF.
            ENDIF.
            CLEAR GT_BKPF_IMP.
            READ TABLE GT_BKPF_IMP WITH KEY ""gjahr = Gt_ekbe_imp-gjahr
                                            AWKEY = GT_EKBE_IMP-AWKEY.
            IF SY-SUBRC = 0.
              IF NOT GT_BKPF_IMP-BUDAT IS INITIAL AND GT_BKPF_IMP-BUDAT NE '00000000'.
                CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                  EXPORTING
                    INPUT  = GT_BKPF_IMP-BUDAT
                  IMPORTING
                    OUTPUT = GT_FINAL-BUDAT.

                CONCATENATE GT_FINAL-BUDAT+0(2) GT_FINAL-BUDAT+2(3) GT_FINAL-BUDAT+5(4)
                           INTO GT_FINAL-BUDAT SEPARATED BY '-'.

*                CONCATENATE gt_bkpf_imp-budat+6(2) gt_bkpf_imp-budat+4(2) gt_bkpf_imp-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
              ELSE.
                GT_FINAL-BUDAT = 'NULL' .   " MIGO Date.
              ENDIF.


              GT_FINAL-BELNR = GT_BKPF_IMP-BELNR.    " FI document No.


              READ TABLE LT_BSEG1 INTO LS_BSEG WITH KEY BUKRS = GT_BKPF_IMP-BUKRS
                                                        BELNR = GT_BKPF_IMP-BELNR
                                                        GJAHR = GT_BKPF_IMP-GJAHR
                                                        EBELP = GT_RSEG_V1-EBELP
                                                        KTOSL = 'BSX'.
              IF SY-SUBRC IS INITIAL.
                LV_INDEX = SY-TABIX.
                GT_FINAL-HKONT   = LS_BSEG-HKONT.
                LOOP AT LT_BSEG1 INTO LS_BSEG FROM LV_INDEX.
                  IF LS_BSEG-BUKRS = GT_BKPF_IMP-BUKRS AND LS_BSEG-BELNR = GT_BKPF_IMP-BELNR AND LS_BSEG-KTOSL = 'BSX'
                    AND LS_BSEG-GJAHR = GT_BKPF_IMP-GJAHR AND LS_BSEG-EBELP = GT_RSEG_V1-EBELP.
                    IF LS_BSEG-SHKZG = 'S'.
                      GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT + LS_BSEG-DMBTR.
                    ELSE.
                      GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT - LS_BSEG-DMBTR.
                    ENDIF.
                  ENDIF.
                ENDLOOP.
              ELSE.
                READ TABLE LT_BSEG1 INTO LS_BSEG WITH KEY BUKRS = GT_BKPF_IMP-BUKRS
                                                        BELNR = GT_BKPF_IMP-BELNR
                                                        GJAHR = GT_BKPF_IMP-GJAHR
                                                        EBELP = GT_RSEG_V1-EBELP
                                                        KTOSL = 'FRL'.
                IF SY-SUBRC IS INITIAL.
                  LV_INDEX = SY-TABIX.
                  GT_FINAL-HKONT   = LS_BSEG-HKONT.
                  LOOP AT LT_BSEG1 INTO LS_BSEG FROM LV_INDEX.
                    IF LS_BSEG-BUKRS = GT_BKPF_IMP-BUKRS AND LS_BSEG-BELNR = GT_BKPF_IMP-BELNR AND LS_BSEG-KTOSL = 'FRL'
                      AND LS_BSEG-GJAHR = GT_BKPF_IMP-GJAHR AND LS_BSEG-EBELP = GT_RSEG_V1-EBELP.
                      IF LS_BSEG-SHKZG = 'S'.
                        GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT + LS_BSEG-DMBTR.
                      ELSE.
                        GT_FINAL-GRN_AMT = GT_FINAL-GRN_AMT - LS_BSEG-DMBTR.
                      ENDIF.
                    ENDIF.
                  ENDLOOP.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        READ TABLE LT_SKAT INTO LS_SKAT WITH KEY SAKNR = GT_FINAL-HKONT.
        IF SY-SUBRC IS INITIAL.
          GT_FINAL-TXT20 = LS_SKAT-TXT20.
        ENDIF.

        SHIFT GT_FINAL-HKONT LEFT DELETING LEADING '0'.
        IF GT_FINAL-MWSKZ IS INITIAL.
          GT_FINAL-MWSKZ = GT_RSEG_V1-MWSKZ.
        ENDIF.
        GT_FINAL-MATNR = GT_RSEG_V1-MATNR.
        GT_FINAL-MENGE = GT_RSEG_V1-MENGE.
        GT_FINAL-WERKS = GT_RSEG_V1-WERKS.

        READ TABLE LT_T007S INTO LS_T007S WITH KEY MWSKZ = GT_FINAL-MWSKZ."gt_rseg_v1-mwskz.
        IF SY-SUBRC IS INITIAL.
          GT_FINAL-TEXT1 = LS_T007S-TEXT1.
        ENDIF.
        READ TABLE GT_MAKT WITH KEY MATNR = GT_RSEG_V1-MATNR.
        IF SY-SUBRC = 0.
          GT_FINAL-MAKTX = GT_MAKT-MAKTX.
        ENDIF.
        "Material Long Text
        LV_ID = GT_FINAL-MATNR.
        CLEAR: LT_LINES,LS_LINES.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'GRUN'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_ID
            OBJECT                  = 'MATERIAL'
          TABLES
            LINES                   = LT_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LT_LINES IS INITIAL.
          LOOP AT LT_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              REPLACE ALL OCCURRENCES OF '<&>' IN LS_LINES-TDLINE WITH '&'.
              CONCATENATE GT_FINAL-LONG_TXT LS_LINES-TDLINE INTO GT_FINAL-LONG_TXT SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
          CONDENSE GT_FINAL-LONG_TXT.
        ENDIF.

        READ TABLE LT_MARC INTO LS_MARC WITH KEY MATNR = GT_RSEG_V1-MATNR
                                                 WERKS = GT_RSEG_V1-WERKS.
        IF SY-SUBRC IS INITIAL.
          GT_FINAL-STEUC = LS_MARC-STEUC.
        ENDIF.
        READ TABLE LT_MAT_MAST INTO LS_MAT_MAST WITH KEY MATNR = GT_RSEG_V1-MATNR.
        IF SY-SUBRC IS INITIAL.
          GT_FINAL-MTART = LS_MAT_MAST-MTART.
          GT_FINAL-MEINS = LS_MAT_MAST-MEINS.

          GT_FINAL-ZSERIES = LS_MAT_MAST-ZSERIES.
          GT_FINAL-ZSIZE   = LS_MAT_MAST-ZSIZE.
          GT_FINAL-BRAND   = LS_MAT_MAST-BRAND.
          GT_FINAL-MOC     = LS_MAT_MAST-MOC.
          GT_FINAL-TYPE    = LS_MAT_MAST-TYPE.
        ENDIF.

        READ TABLE GT_EKKO WITH KEY EBELN = GT_RSEG_V1-EBELN.
        IF SY-SUBRC = 0.
          GT_FINAL-EKORG = GT_EKKO-EKORG.
          GT_FINAL-BSART = GT_EKKO-BSART.
          IF NOT GT_EKKO-AEDAT IS INITIAL AND GT_EKKO-AEDAT NE '00000000'.
            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                INPUT  = GT_EKKO-AEDAT
              IMPORTING
                OUTPUT = GT_FINAL-AEDAT.

            CONCATENATE GT_FINAL-AEDAT+0(2) GT_FINAL-AEDAT+2(3) GT_FINAL-AEDAT+5(4)
                       INTO GT_FINAL-AEDAT SEPARATED BY '-'.

*            CONCATENATE gt_ekko-aedat+6(2) gt_ekko-aedat+4(2) gt_ekko-aedat+0(4) INTO gt_final-aedat SEPARATED BY '-'.
          ELSE.
            GT_FINAL-AEDAT = 'NULL'.
          ENDIF.

        ENDIF.
        READ TABLE GT_EKPO WITH KEY EBELN = GT_RSEG_V1-EBELN
                                    EBELP = GT_RSEG_V1-EBELP .
        IF SY-SUBRC = 0.
          GT_FINAL-PO_QTY = GT_EKPO-MENGE.
          GT_FINAL-INFNR  = GT_EKPO-INFNR.
          GT_FINAL-KNTTP = GT_EKPO-KNTTP.
          IF GT_EKPO-PEINH IS NOT INITIAL.
            GT_FINAL-RATE = GT_EKPO-NETPR / GT_EKPO-PEINH.
          ENDIF.

          READ TABLE LT_T163Y INTO LS_T163Y WITH KEY PSTYP = GT_EKPO-PSTYP.
          IF SY-SUBRC IS INITIAL.
            GT_FINAL-PSTYP = LS_T163Y-EPSTP.
          ENDIF.

*********   Asset no. & Sub Asset No.
          READ TABLE GT_EKKN WITH KEY EBELN = GT_EKPO-EBELN
                                      EBELP = GT_EKPO-EBELP .
          IF SY-SUBRC = 0.
            GT_FINAL-ANLN1 = GT_EKKN-ANLN1.
            GT_FINAL-ANLN2 = GT_EKKN-ANLN2.
            GT_FINAL-SAKTO = GT_EKKN-SAKTO.
            READ TABLE GT_ANLA WITH KEY ANLN1 = GT_EKKN-ANLN1
                                        ANLN2 = GT_EKKN-ANLN2.
            IF SY-SUBRC = 0.
              GT_FINAL-INVNR = GT_ANLA-INVNR.
              GT_FINAL-TXT50 = GT_ANLA-TXT50.
            ENDIF.
            READ TABLE LT_BSEG INTO LS_BSEG WITH KEY EBELN = GT_EKPO-EBELN
                                                     EBELP = GT_EKPO-EBELP
                                                     ANLN1 = GT_EKKN-ANLN1
                                                     ANLN2 = GT_EKKN-ANLN2.
            IF SY-SUBRC IS INITIAL.
              GT_FINAL-ASS_AMT = LS_BSEG-DMBTR.
            ENDIF.
          ENDIF.
        ENDIF.

        IF NOT GT_RBKP-STBLG IS INITIAL.
          GT_FINAL-ACC_QTY = 0.
          GT_FINAL-REJ_QTY = 0.
          GT_FINAL-SCP_QTY = 0.
          GT_FINAL-REW_QTY = 0.
          GT_FINAL-MENGE   = 0.
        ENDIF.
*BREAK primus.
        LOOP AT GT_RSEG WHERE BELNR = GT_RBKP-BELNR
                          AND GJAHR = GT_RBKP-GJAHR
                          AND EBELN = GT_RSEG_V1-EBELN
                          AND EBELP = GT_RSEG_V1-EBELP.


*****  BASIC
          IF GT_RSEG-KSCHL = ''.
            GT_FINAL-BASIC = GT_FINAL-BASIC + GT_RSEG-WRBTR.
          ENDIF.

*****  PACKING
          IF GT_RSEG-KSCHL = 'ZPFL' OR GT_RSEG-KSCHL = 'ZPC1' OR GT_RSEG-KSCHL = 'ZPFV'.
            GT_FINAL-PACKING = GT_FINAL-PACKING + GT_RSEG-WRBTR.
          ENDIF.

*****  DISCOUNT
          IF GT_RSEG-KSCHL = 'R001' OR GT_RSEG-KSCHL = 'R002' OR GT_RSEG-KSCHL = 'R003'.
            GT_FINAL-DISCOUNT = GT_FINAL-DISCOUNT + GT_RSEG-WRBTR.
          ENDIF.

***** Basic Customs
          IF GT_RSEG-KSCHL = 'JCDB'.
            GT_FINAL-BASIC_CUST = GT_FINAL-BASIC_CUST + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

***** CVD
          IF GT_RSEG-KSCHL = 'JCV1'.
            GT_FINAL-CVD = GT_FINAL-CVD + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

***** Customs ECess
          IF GT_RSEG-KSCHL = 'JECV' OR GT_RSEG-KSCHL = 'JCZ2'.
            GT_FINAL-CUST_CESS = GT_FINAL-CUST_CESS + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

***** Socila Welfare
          IF GT_RSEG-KSCHL = 'ZSWS' .
            GT_FINAL-WRBTR = GT_RSEG-WRBTR.
*            gt_final-cust_cess = gt_final-cust_cess + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

***** Customs HECess
          IF GT_RSEG-KSCHL = 'JCZ4'.
*          if gt_rseg-kschl = 'JSED'.""Gt_rseg-kschl = 'JSDB'.
            GT_FINAL-CUST_HCESS = GT_FINAL-CUST_HCESS + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

***** Add. CVD
          IF GT_RSEG-KSCHL = 'JADC'.
            GT_FINAL-ADD_CVD = GT_FINAL-ADD_CVD + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

***** Freight
          IF GT_RSEG-KSCHL = 'ZRB1' OR GT_RSEG-KSCHL = 'ZRC1' OR GT_RSEG-KSCHL = 'FRA1'.
*          OR gt_rseg-kschl = 'ZFR1' OR gt_rseg-kschl = 'JOFV' OR gt_rseg-kschl = 'JOFP'.
            GT_FINAL-FREIGHT = GT_FINAL-FREIGHT + GT_RSEG-WRBTR .
          ENDIF.

***** LBT
          IF GT_RSEG-KSCHL = 'JOCM'.
            GT_FINAL-LBT = GT_FINAL-LBT + GT_RSEG-WRBTR .
          ENDIF.

*****Inspection Charge
          IF GT_RSEG-KSCHL = 'ZINS'.
            GT_FINAL-INSP = GT_FINAL-INSP + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

*****Setting Charge
          IF GT_RSEG-KSCHL = 'ZSCV' OR GT_RSEG-KSCHL = 'ZSCQ'.
            GT_FINAL-SET_VAL = GT_FINAL-SET_VAL + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.


*****Insurance
          IF GT_RSEG-KSCHL = 'ZINR'.
            GT_FINAL-INS = GT_FINAL-INS + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

*****Devlopment Charges
          IF GT_RSEG-KSCHL = 'ZDV%' OR GT_RSEG-KSCHL = 'ZDVQ' OR GT_RSEG-KSCHL = 'ZDVV'.
            GT_FINAL-DEV_CH = GT_FINAL-DEV_CH + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

*****Other Charges
          IF GT_RSEG-KSCHL = 'ZOCV' OR GT_RSEG-KSCHL = 'ZOCQ' OR GT_RSEG-KSCHL = 'ZOC%'.
            GT_FINAL-OTH_CH = GT_FINAL-OTH_CH + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

*****Comp Cess %
          IF GT_RSEG-KSCHL = 'ZCES'.
            GT_FINAL-COM_P = GT_FINAL-COM_P + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.

*****Comp Cess Val
          IF GT_RSEG-KSCHL = 'ZCEV'.
            GT_FINAL-COM_V = GT_FINAL-COM_V + ( GT_RSEG-WRBTR * GT_FINAL-KURSF ).
          ENDIF.
***** FORWARDING
***        if gt_rseg-kschl = ''.
***          gt_final-forwarding = gt_final-forwarding + gt_rseg-wrbtr .
***        endif.

**** CLEARING
          IF GT_RSEG-KSCHL = 'JCFA' OR GT_RSEG-KSCHL = 'ZCFA' OR GT_RSEG-KSCHL = 'JFR2'.
            GT_FINAL-CLEARING = GT_FINAL-CLEARING + GT_RSEG-WRBTR .
          ENDIF.
        ENDLOOP.



****** Check if debit or Credit
**    read table gt_rseg with key  belnr = gt_bkpf-g_belnr
**                                 gjahr = gt_bkpf-g_gjahr.
**    if sy-subrc = 0.
        IF GT_RSEG_V1-SHKZG = 'H'.
          GT_FINAL-BASIC = GT_FINAL-BASIC * -1.
          GT_FINAL-PACKING = GT_FINAL-PACKING * -1.
          GT_FINAL-INSP = GT_FINAL-INSP * -1.
          GT_FINAL-SET_VAL = GT_FINAL-SET_VAL * -1.
          GT_FINAL-INS = GT_FINAL-INS * -1.
          GT_FINAL-DEV_CH = GT_FINAL-DEV_CH * -1.
          GT_FINAL-OTH_CH = GT_FINAL-OTH_CH * -1.
          GT_FINAL-DISCOUNT = GT_FINAL-DISCOUNT * -1.
          GT_FINAL-BED      = GT_FINAL-BED * -1.
          GT_FINAL-AED = GT_FINAL-AED * -1.
*          gt_final-ecs = gt_final-ecs * -1.
*          gt_final-hcess = gt_final-hcess * -1.
*          gt_final-ecs_cr = gt_final-ecs_cr * -1.       "Benz, 25.11.2016
*          gt_final-hcess_cr = gt_final-hcess_cr * -1.   "Benz, 25.11.2016
          GT_FINAL-VAT_TAX = GT_FINAL-VAT_TAX * -1.
          GT_FINAL-CST_TAX = GT_FINAL-CST_TAX * -1.
*          gt_final-ser_val_cr = gt_final-ser_val_cr * -1. "Benz, 25.11.2016
*          gt_final-sbc_cr = gt_final-sbc_cr * -1.
*          gt_final-kkc_cr = gt_final-kkc_cr * -1.
**** B.O.C Bency 06.12.2016
**          gt_final-sertaxcess_cr  = gt_final-sertaxcess_cr * -1.
*          gt_final-hsertaxcess_cr = gt_final-hsertaxcess_cr * -1.
**** E.O.C Bency 06.12.2016
          GT_FINAL-BASIC_CUST = GT_FINAL-BASIC_CUST * -1.
          GT_FINAL-CVD = GT_FINAL-CVD * -1.
          GT_FINAL-CUST_CESS = GT_FINAL-CUST_CESS * -1.
          GT_FINAL-CUST_HCESS = GT_FINAL-CUST_HCESS * -1.
          GT_FINAL-ADD_CVD = GT_FINAL-ADD_CVD * -1.
          GT_FINAL-FREIGHT = GT_FINAL-FREIGHT * -1.

          GT_FINAL-CGST_TAX     = GT_FINAL-CGST_TAX * -1.
          GT_FINAL-SGST_TAX     = GT_FINAL-SGST_TAX * -1.
          GT_FINAL-IGST_TAX     = GT_FINAL-IGST_TAX * -1.
          GT_FINAL-COM_P        = GT_FINAL-COM_P * -1.
          GT_FINAL-COM_V        = GT_FINAL-COM_V * -1.
        ENDIF.

*** NET TOTAL
        GT_FINAL-NET_TOTAL = GT_FINAL-BASIC
                           + GT_FINAL-PACKING
                           + GT_FINAL-INSP
                           + GT_FINAL-SET_VAL
                           + GT_FINAL-INS
                           + GT_FINAL-DEV_CH
                           + GT_FINAL-OTH_CH
*                           - gt_final-discount
                           + GT_FINAL-BED
                           + GT_FINAL-AED
                           + GT_FINAL-ECS
                           + GT_FINAL-HCESS.


*** GROSS TOTAL
        GT_FINAL-GROSS_TOT = GT_FINAL-NET_TOTAL
                           + GT_FINAL-VAT_TAX
                           + GT_FINAL-CST_TAX
                           - GT_FINAL-ECS_CR
                           - GT_FINAL-HCESS_CR
                           - GT_FINAL-SER_VAL_CR
*                           - gt_final-sbc_cr
*                           - gt_final-kkc_cr
*                           - gt_final-sertaxcess_cr     "Added by Bency 06.12.2016
*                           - gt_final-hsertaxcess_cr    "Added by Bency 06.12.2016
                           + GT_FINAL-ECS_DR
                           + GT_FINAL-HCESS_DR
                           + GT_FINAL-SER_VAL_DR
                           + GT_FINAL-SBC_DR
                           + GT_FINAL-KKC_DR
*                           + gt_final-sertaxcess_dr     "Added by Bency 06.12.2016
*                           + gt_final-hsertaxcess_dr    "Added by Bency 06.12.2016

                           + GT_FINAL-BASIC_CUST
                           + GT_FINAL-CVD
                           + GT_FINAL-CUST_CESS
                           + GT_FINAL-CUST_HCESS
                           + GT_FINAL-ADD_CVD
                           + GT_FINAL-FREIGHT
                           + GT_FINAL-LBT
**                           + gt_final-forwarding
**                           + gt_final-clearing
**                           + gt_final-tds_dc
                           + LV_CGST "gt_final-cgst_tax
                           + LV_SGST "gt_final-sgst_tax
                           + LV_IGST "gt_final-igst_tax
                           + GT_FINAL-COM_P
                           + GT_FINAL-COM_V.
**                           + gt_final-cgst_ns_tax
**                           + gt_final-sgst_ns_tax
**                           + gt_final-igst_ns_tax
**                           + gt_final-igst_tax_im.
**                           + gt_final-cgst_rc_tax
**                           + gt_final-sgst_rc_tax
**                           + gt_final-cgst_nrc_tax
**                           + gt_final-sgst_nrc_tax.

*** GROSS TOTAL WITHOUT TDS
        GT_FINAL-GROSS_TOT_TDS = GT_FINAL-GROSS_TOT - GT_FINAL-TDS_DC.

        IF GT_FINAL-BASIC IS NOT INITIAL.
          GT_FINAL-BASIC_LC = GT_FINAL-BASIC * GT_FINAL-KURSF.
        ENDIF.

        IF GT_FINAL-PACKING IS NOT INITIAL.
          GT_FINAL-PACKING_LC = GT_FINAL-PACKING * GT_FINAL-KURSF.
        ENDIF.

***        IF gt_final-discount IS NOT INITIAL.
***          gt_final-discount_lc = gt_final-discount * gt_final-kursf.
***        ENDIF.

        IF GT_FINAL-FREIGHT IS NOT INITIAL.
          GT_FINAL-FREIGHT_LC = GT_FINAL-FREIGHT * GT_FINAL-KURSF.
        ENDIF.

***        IF gt_final-forwarding IS NOT INITIAL.
***          gt_final-forwarding_lc = gt_final-forwarding * gt_final-kursf.
***        ENDIF.

**        IF gt_final-clearing IS NOT INITIAL.
**          gt_final-clearing_lc = gt_final-clearing * gt_final-kursf.
**        ENDIF.


        IF NOT GT_RBKP-STBLG IS INITIAL.
          GT_FINAL-BASIC_LC = 0.
          GT_FINAL-PACKING_LC = 0.
          GT_FINAL-INSP = 0.
          GT_FINAL-SET_VAL = 0.
          GT_FINAL-INS = 0.
          GT_FINAL-FREIGHT_LC = 0.
          GT_FINAL-DEV_CH = 0.
          GT_FINAL-OTH_CH = 0.
          GT_FINAL-BED = 0.
          GT_FINAL-AED = 0.
          GT_FINAL-ECS = 0.
          GT_FINAL-HCESS = 0.
          GT_FINAL-CGST_TAX = 0.
          GT_FINAL-SGST_TAX = 0.
          GT_FINAL-IGST_TAX = 0.
          GT_FINAL-COM_P = 0.
          GT_FINAL-COM_V = 0.
          GT_FINAL-VAT_TAX = 0.
          GT_FINAL-CST_TAX = 0.
          GT_FINAL-GROSS_TOT = 0.
          GT_FINAL-SER_VAL_DR = 0.
          GT_FINAL-SBC_DR = 0.
          GT_FINAL-KKC_DR = 0.
        ENDIF.

*** Assessable GST (LC)
        GT_FINAL-NET_TOTAL_LC = GT_FINAL-BASIC_LC
                           + GT_FINAL-PACKING_LC
                           + GT_FINAL-INSP
                           + GT_FINAL-SET_VAL
                           + GT_FINAL-INS
                           + GT_FINAL-FREIGHT_LC
                           + GT_FINAL-DEV_CH
                           + GT_FINAL-OTH_CH
*                           - gt_final-discount_lc
                           + GT_FINAL-BED
                           + GT_FINAL-AED
                           + GT_FINAL-ECS
                           + GT_FINAL-HCESS.

*****Tot GST Amt
        GT_FINAL-GST_AMT =
                GT_FINAL-CGST_TAX + GT_FINAL-SGST_TAX
                + GT_FINAL-IGST_TAX + GT_FINAL-COM_P + GT_FINAL-COM_V.

********Total Tax Amount
        GT_FINAL-TOT_TAX = "gt_final-gst_amt
                LV_CGST + LV_SGST + LV_IGST + GT_FINAL-BASIC_CUST + GT_FINAL-CUST_CESS + GT_FINAL-CUST_HCESS + GT_FINAL-ADD_CVD
                + GT_FINAL-VAT_TAX + GT_FINAL-CST_TAX + GT_FINAL-SER_VAL_DR + GT_FINAL-SBC_DR + GT_FINAL-KKC_DR.

*** GROSS TOTAL (LC)
        GT_FINAL-GROSS_TOT_LC = GT_FINAL-TOT_TAX + GT_FINAL-NET_TOTAL_LC.



*** GROSS TOTAL WITHOUT TDS (LC)
        GT_FINAL-GROSS_TOT_LC_TDS = GT_FINAL-GROSS_TOT_LC - GT_FINAL-TDS_LC.


        SHIFT GT_FINAL-XBLNR_ALT LEFT DELETING LEADING '0'.
        SHIFT GT_FINAL-BELNR LEFT DELETING LEADING '0'.
        SHIFT GT_FINAL-AWKEY LEFT DELETING LEADING '0'.
        SHIFT GT_FINAL-MIRO_AC_DOC LEFT DELETING LEADING '0'.
        SHIFT GT_FINAL-AKONT LEFT DELETING LEADING '0'.
*BREAK primus.

*------------------Refreshable Date / Shift negative sign to left logic ------------------------------------------
        DATA : VAL1 TYPE STRING.
        VAL1 = GT_FINAL-WRBTR.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            VALUE = VAL1.
        GT_FINAL-WRBTR = VAL1.
        CLEAR VAL1.
        VAL1 = GT_FINAL-KWERT.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            VALUE = VAL1.
        GT_FINAL-KWERT = VAL1.
        CLEAR VAL1.
        VAL1  = GT_FINAL-MENGE.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            VALUE = VAL1.
        GT_FINAL-MENGE = VAL1.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = SY-DATUM
          IMPORTING
            OUTPUT = GT_FINAL-REF_DATE.

        CONCATENATE GT_FINAL-REF_DATE+0(2) GT_FINAL-REF_DATE+2(3) GT_FINAL-REF_DATE+5(4)
                   INTO GT_FINAL-REF_DATE SEPARATED BY '-'.
*inv_dt
        IF GT_FINAL-INV_DT IS NOT INITIAL AND GT_FINAL-INV_DT NE '00000000'.

          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              INPUT  = GT_FINAL-INV_DT
            IMPORTING
              OUTPUT = GT_FINAL-INV_DT.

          CONCATENATE GT_FINAL-INV_DT+0(2) GT_FINAL-INV_DT+2(3) GT_FINAL-INV_DT+5(4)
                      INTO GT_FINAL-INV_DT SEPARATED BY '-'.
        ENDIF.
*        aedat
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input  = gt_final-aedat
*          IMPORTING
*            output = gt_final-AEDAT.
*
*        CONCATENATE gt_final-aedat+0(2) gt_final-aedat+2(3) gt_final-aedat+5(4)
*                    into gt_final-aedat SEPARATED BY '-'.

*        budat
*      BREAK PRIMUS.
*      IF GT_FINAL-BUDAT IS NOT INITIAL.
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'                       "UNCOMMENTED BY SNEHAL RAJALE ON 2 APRIL 2021.
*          EXPORTING
*            input  = gt_final-budat
*          IMPORTING
*            output = gt_final-budat.
*
*       CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
*                   into gt_final-budat SEPARATED BY '-'.
*     ENDIF.
*         bill_dt

        IF GT_FINAL-BILL_DT IS NOT INITIAL AND GT_FINAL-BILL_DT NE '00000000'.

          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'    "comment out by swati on 21.02.2019
            EXPORTING
              INPUT  = GT_FINAL-BILL_DT
            IMPORTING
              OUTPUT = GT_FINAL-BILL_DT.

          CONCATENATE GT_FINAL-BILL_DT+0(2) GT_FINAL-BILL_DT+2(3) GT_FINAL-BILL_DT+5(4)
                      INTO GT_FINAL-BILL_DT SEPARATED BY '-'.

        ENDIF.

*       eindt
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input = gt_final-eindt
*          IMPORTING
*            output = gt_final-eindt.
*
*        CONCATENATE gt_final-eindt+0(2) gt_final-eindt+2(3) gt_final-eindt+5(4)
*                   into gt_final-eindt SEPARATED BY '-'.

*        SELECT SINGLE infnr INTO gt_final-infnr FROM eine WHERE ebeln = gt_final-ebeln AND ebelp = gt_final-ebelp.

        APPEND GT_FINAL.  "Commented 09.11.2016
*        CLEAR: gt_final,gt_rseg,lv_igst,lv_cgst,lv_igst.  "Commented 09.11.2016


        CLEAR :
          GT_FINAL, GT_WITH_ITEM, GT_RBKP, GT_LFA1,LV_IGST,LV_CGST,LV_IGST,GT_T005U, GT_J_1IMOVEND,LS_EKET,LS_BSEG,
          GT_RSEG_V1, GT_BKPF_WE,GT_RSEG, GT_EKBE_IMP, GT_BKPF_IMP, GT_MAKT,GT_EKKO, GT_EKPO, GT_BSET,LS_T163Y.



      ENDIF. "end gt_rbkp
    ENDIF. " end gt_bkpf   """  checking condn gt_rseg_v1

  ENDLOOP. "" *****      END RSEG
*BREAK primus.
  LOOP AT GT_FINAL.
    IT_FINAL-EKORG            = GT_FINAL-EKORG           .
    IT_FINAL-LIFNR            = GT_FINAL-LIFNR           .
    IT_FINAL-NAME1            = GT_FINAL-NAME1           .
    IT_FINAL-ADDRESS          = GT_FINAL-ADDRESS         .
    IT_FINAL-STCD3            = GT_FINAL-STCD3           .
    IT_FINAL-GST_TXT          = GT_FINAL-GST_TXT         .
    IT_FINAL-GST_REGION       = GT_FINAL-GST_REGION      .
    IT_FINAL-BEZEI            = GT_FINAL-BEZEI           .
    IT_FINAL-XBLNR_ALT        = GT_FINAL-XBLNR_ALT       .
    IT_FINAL-INV_NO           = GT_FINAL-INV_NO          .
    IT_FINAL-INV_DT           = GT_FINAL-INV_DT          .
    IT_FINAL-EBELN            = GT_FINAL-EBELN           .
    IT_FINAL-AEDAT            = GT_FINAL-AEDAT           .
    IT_FINAL-EBELP            = GT_FINAL-EBELP           .
    IT_FINAL-PSTYP            = GT_FINAL-PSTYP           .
    IT_FINAL-KNTTP            = GT_FINAL-KNTTP           .
    IT_FINAL-LFBNR            = GT_FINAL-LFBNR           .
    IT_FINAL-BUDAT            = GT_FINAL-BUDAT           .
    IT_FINAL-BELNR            = GT_FINAL-BELNR           .
    IT_FINAL-GRN_AMT          = GT_FINAL-GRN_AMT         .

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-GRN_AMT.

    IT_FINAL-ZUONR            = GT_FINAL-ZUONR           .
    IT_FINAL-BKTXT            = GT_FINAL-BKTXT           .
    IT_FINAL-AWKEY            = GT_FINAL-AWKEY           .
    IT_FINAL-MIRO_AC_DOC      = GT_FINAL-MIRO_AC_DOC     .
    IT_FINAL-BLART            = GT_FINAL-BLART           .
    IT_FINAL-BILL_DT          = GT_FINAL-BILL_DT         .
    IT_FINAL-HKONT            = GT_FINAL-HKONT           .
    IT_FINAL-TXT20            = GT_FINAL-TXT20           .
    IT_FINAL-STEUC            = GT_FINAL-STEUC           .
    IT_FINAL-MATNR            = GT_FINAL-MATNR           .
    IT_FINAL-LONG_TXT         = GT_FINAL-LONG_TXT        .
    IT_FINAL-MTART            = GT_FINAL-MTART           .
    IT_FINAL-EINDT            = GT_FINAL-EINDT           .
    IT_FINAL-PO_QTY           = GT_FINAL-PO_QTY          .
    IT_FINAL-LSMNG            = GT_FINAL-LSMNG           .
    IT_FINAL-MENGE            = GT_FINAL-MENGE           .
    IT_FINAL-ACC_QTY          = GT_FINAL-ACC_QTY         .
    IT_FINAL-REJ_QTY          = GT_FINAL-REJ_QTY         .
    IT_FINAL-SCP_QTY          = GT_FINAL-SCP_QTY         .
    IT_FINAL-REW_QTY          = GT_FINAL-REW_QTY         .
    IT_FINAL-WAERS            = GT_FINAL-WAERS           .
    IT_FINAL-KURSF            = GT_FINAL-KURSF           .
    IT_FINAL-RATE             = GT_FINAL-RATE            .
    IT_FINAL-BASIC            = GT_FINAL-BASIC           .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-BASIC.
    IT_FINAL-BASIC_LC         = GT_FINAL-BASIC_LC        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-BASIC_LC.
    IT_FINAL-PACKING_LC       = GT_FINAL-PACKING_LC      .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-PACKING_LC.
    IT_FINAL-INSP             = GT_FINAL-INSP            .
    IT_FINAL-SET_VAL          = GT_FINAL-SET_VAL         .
    IT_FINAL-FREIGHT_LC       = GT_FINAL-FREIGHT_LC      .
    IT_FINAL-INS              = GT_FINAL-INS             .
    IT_FINAL-OTH_CH           = GT_FINAL-OTH_CH          .
    IT_FINAL-DEV_CH           = GT_FINAL-DEV_CH          .
    IT_FINAL-NET_TOTAL_LC     = GT_FINAL-NET_TOTAL_LC    .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-NET_TOTAL_LC.
    IT_FINAL-MWSKZ            = GT_FINAL-MWSKZ           .
    IT_FINAL-TEXT1            = GT_FINAL-TEXT1           .
    IT_FINAL-BED              = GT_FINAL-BED             .
    IT_FINAL-AED              = GT_FINAL-AED             .
    IT_FINAL-VAT_TAX          = GT_FINAL-VAT_TAX         . ""**
    IT_FINAL-CST_TAX          = GT_FINAL-CST_TAX         .
    IT_FINAL-SER_VAL_DR       = GT_FINAL-SER_VAL_DR      .
    IT_FINAL-SBC_DR           = GT_FINAL-SBC_DR          .
    IT_FINAL-KKC_DR           = GT_FINAL-KKC_DR          . "" **
    IT_FINAL-CGST             = GT_FINAL-CGST            .

    IT_FINAL-CGST_TAX         = GT_FINAL-CGST_TAX        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-CGST_TAX.
    IT_FINAL-SGST             = GT_FINAL-SGST            .
    IT_FINAL-SGST_TAX         = GT_FINAL-SGST_TAX        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-SGST_TAX.
    IT_FINAL-IGST             = GT_FINAL-IGST            .
    IT_FINAL-IGST_TAX         = GT_FINAL-IGST_TAX        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-IGST_TAX.
    IT_FINAL-COM_P            = GT_FINAL-COM_P           .
    IT_FINAL-COM_V            = GT_FINAL-COM_V           .
    IT_FINAL-GST_AMT          = GT_FINAL-GST_AMT         .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-GST_AMT.
    IT_FINAL-BASIC_CUST       = GT_FINAL-BASIC_CUST      . "" **
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-BASIC_CUST.
    IT_FINAL-CVD              = GT_FINAL-CVD             .
    IT_FINAL-CUST_CESS        = GT_FINAL-CUST_CESS       .
    IT_FINAL-CUST_HCESS       = GT_FINAL-CUST_HCESS      .
    IT_FINAL-WRBTR            = GT_FINAL-WRBTR           .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-WRBTR.
    IT_FINAL-ADD_CVD          = GT_FINAL-ADD_CVD         .
    IT_FINAL-TOT_TAX          = GT_FINAL-TOT_TAX         . ""**
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-TOT_TAX.
    IT_FINAL-GROSS_TOT     = GT_FINAL-GROSS_TOT    .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-GROSS_TOT.
    IT_FINAL-GROSS_TOT_LC     = GT_FINAL-GROSS_TOT_LC    .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-GROSS_TOT_LC.
    IT_FINAL-ANLN1            = GT_FINAL-ANLN1           .
    IT_FINAL-ANLN2            = GT_FINAL-ANLN2           .
    IT_FINAL-INVNR            = GT_FINAL-INVNR           .
    IT_FINAL-TXT50            = GT_FINAL-TXT50           .
    IT_FINAL-SAKTO            = GT_FINAL-SAKTO           .
    IT_FINAL-ASS_AMT          = GT_FINAL-ASS_AMT         .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = IT_FINAL-ASS_AMT.
    IT_FINAL-ZSERIES          = GT_FINAL-ZSERIES         .
    IT_FINAL-ZSIZE            = GT_FINAL-ZSIZE           .
    IT_FINAL-BRAND            = GT_FINAL-BRAND           .
    IT_FINAL-MOC              = GT_FINAL-MOC             .
    IT_FINAL-TYPE             = GT_FINAL-TYPE            .
*    it_final-kwert            = gt_final-kwert           .
*    it_final-akont            = gt_final-akont           .
*    it_final-maktx            = gt_final-maktx           .
*    it_final-werks            = gt_final-werks           .
*    it_final-ecs              = gt_final-ecs             .
*    it_final-hcess            = gt_final-hcess           .
*    it_final-ecs_dr           = gt_final-ecs_dr          .
*    it_final-hcess_dr         = gt_final-hcess_dr        .
    IT_FINAL-VAT              = GT_FINAL-VAT             .
    IT_FINAL-CST              = GT_FINAL-CST             .

*    it_final-ecs_cr           = gt_final-ecs_cr          .
*    it_final-hcess_cr         = gt_final-hcess_cr        .
*    it_final-ser_val_cr       = gt_final-ser_val_cr      .
*    it_final-sbc_cr           = gt_final-sbc_cr          .
*    it_final-kkc_cr           = gt_final-kkc_cr          .
*    it_final-packing          = gt_final-packing         .
*    it_final-discount         = gt_final-discount        .
*    it_final-discount_lc      = gt_final-discount_lc     .
*    it_final-freight          = gt_final-freight         .
*    it_final-lbt              = gt_final-lbt             .
*    it_final-forwarding       = gt_final-forwarding      .
*    it_final-forwarding_lc    = gt_final-forwarding_lc   .
*    it_final-clearing         = gt_final-clearing        .
*    it_final-clearing_lc      = gt_final-clearing_lc     .
*    it_final-tds_dc           = gt_final-tds_dc          .
*    it_final-tds_lc           = gt_final-tds_lc          .
*    it_final-tds_flag         = gt_final-tds_flag        .
*    it_final-gross_tot        = gt_final-gross_tot       .
*    it_final-gross_tot_tds    = gt_final-gross_tot_tds   .
*    it_final-gross_tot_lc_tds = gt_final-gross_tot_lc_tds.
*    it_final-tin_no           = gt_final-tin_no          .
*    it_final-lst_no           = gt_final-lst_no          .
*    it_final-tcode            = gt_final-tcode           .
*    it_final-net_total        = gt_final-net_total       .
    IT_FINAL-REF_DATE         = GT_FINAL-REF_DATE        .
    IT_FINAL-BLDAT         = GT_FINAL-BLDAT        .
    IT_FINAL-MEINS         = GT_FINAL-MEINS        .
    IT_FINAL-BSART         = GT_FINAL-BSART        .
    IT_FINAL-INFNR         = GT_FINAL-INFNR.
    IT_FINAL-J_1ISSIST     = GT_FINAL-J_1ISSIST.
    APPEND IT_FINAL.
    CLEAR GT_FINAL.
  ENDLOOP.
*  BREAK primus.


  PERFORM F_LISTHEADER.
  PERFORM F_FIELDCATALOG.
  PERFORM F_LAYOUT.
  PERFORM F_DISPLAYGRID.

ENDFORM.                    " GET_DATA


*&---------------------------------------------------------------------*
*&      Form  f_listheader
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM F_LISTHEADER .

  DATA : FRMDT(10) TYPE C,
         TODT(10)  TYPE C,
         V_STR     TYPE STRING.


  GT_LISTHEADER-TYP = 'H'.
  GT_LISTHEADER-KEY = ' '.
  GT_LISTHEADER-INFO = 'Purchase Register'.
  APPEND GT_LISTHEADER.

  IF S_BUDAT-LOW NE '00000000' AND  S_BUDAT-HIGH NE '00000000'      .
    WRITE S_BUDAT-LOW  TO FRMDT USING EDIT MASK '__.__.____'.
    WRITE S_BUDAT-HIGH TO TODT  USING EDIT MASK '__.__.____'.
    CONCATENATE 'FROM'
                 FRMDT
                 'TO'
                 TODT
           INTO V_STR SEPARATED BY SPACE.
  ELSEIF S_BUDAT-LOW NE '00000000' AND  S_BUDAT-HIGH EQ '00000000'      .
    WRITE S_BUDAT-LOW  TO FRMDT USING EDIT MASK '__.__.____'.
    CONCATENATE 'ON'
                 FRMDT
           INTO V_STR SEPARATED BY SPACE.
  ELSEIF S_BUDAT-LOW EQ '00000000' AND  S_BUDAT-HIGH NE '00000000'      .
    WRITE S_BUDAT-HIGH  TO TODT USING EDIT MASK '__.__.____'.
    CONCATENATE 'ON'
                 TODT
           INTO V_STR SEPARATED BY SPACE.
  ENDIF.
  GT_LISTHEADER-TYP = 'S'.
  GT_LISTHEADER-KEY = ' '.
  GT_LISTHEADER-INFO = V_STR.
  APPEND GT_LISTHEADER.


ENDFORM. " f_listheader

*&---------------------------------------------------------------------*
*&      Form  f_fieldcatalog
*&---------------------------------------------------------------------*

FORM F_FIELDCATALOG .

****Purchase Org
  GT_FIELDCATALOG-FIELDNAME = 'EKORG'.
  GT_FIELDCATALOG-SELTEXT_L = 'Purchase Org'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 12. Vendor No.
  GT_FIELDCATALOG-FIELDNAME = 'LIFNR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Vendor'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
  GT_FIELDCATALOG-NO_ZERO   = 'X'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 13. Vendor Name
  GT_FIELDCATALOG-FIELDNAME = 'NAME1'.
  GT_FIELDCATALOG-SELTEXT_L = 'Vendor Name'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 13. Vendor Address
  GT_FIELDCATALOG-FIELDNAME = 'ADDRESS'.
  GT_FIELDCATALOG-SELTEXT_L = 'Address'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 13. Vendor GSTIN
  GT_FIELDCATALOG-FIELDNAME = 'STCD3'.
  GT_FIELDCATALOG-SELTEXT_L = 'GSTIN No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 13. Vendor GSTIN Regd.
  GT_FIELDCATALOG-FIELDNAME = 'GST_TXT'.
  GT_FIELDCATALOG-SELTEXT_L = 'REGD/URD /Comp'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 11. Vendor State
  GT_FIELDCATALOG-FIELDNAME = 'GST_REGION'.
  GT_FIELDCATALOG-SELTEXT_L = 'State Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '25'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 11. Vendor State
  GT_FIELDCATALOG-FIELDNAME = 'BEZEI'.
  GT_FIELDCATALOG-SELTEXT_L = 'Vendor State'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '25'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 7. Inv/Bill No.
  GT_FIELDCATALOG-FIELDNAME = 'XBLNR_ALT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Invoice No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 7. Inv/Bill No.
  GT_FIELDCATALOG-FIELDNAME = 'INV_NO'.
  GT_FIELDCATALOG-SELTEXT_L = 'Vendor Inv.No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 8. INV DATE TIME
  GT_FIELDCATALOG-FIELDNAME = 'INV_DT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Invoice Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 10. PO No.
  GT_FIELDCATALOG-FIELDNAME = 'EBELN'.
  GT_FIELDCATALOG-SELTEXT_L = 'PO No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  GT_FIELDCATALOG-HOTSPOT   = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 9. PO Date
  GT_FIELDCATALOG-FIELDNAME = 'AEDAT'.
  GT_FIELDCATALOG-SELTEXT_L = 'PO Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 9. PO Line Item
  GT_FIELDCATALOG-FIELDNAME = 'EBELP'.
  GT_FIELDCATALOG-SELTEXT_L = 'PO Line Item'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 9. Item Category
  GT_FIELDCATALOG-FIELDNAME = 'PSTYP'.
  GT_FIELDCATALOG-SELTEXT_L = 'Item Category'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 9. Account Assignment Category
  GT_FIELDCATALOG-FIELDNAME = 'KNTTP'.
  GT_FIELDCATALOG-SELTEXT_L = 'Acc.Assign.Category'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 1. Migo number
  GT_FIELDCATALOG-FIELDNAME = 'LFBNR'.
  GT_FIELDCATALOG-SELTEXT_L = 'GRN No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 2. Migo Date
  GT_FIELDCATALOG-FIELDNAME = 'BUDAT'.
  GT_FIELDCATALOG-SELTEXT_L = 'GRN Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 3. FI document No.
  GT_FIELDCATALOG-FIELDNAME = 'BELNR'.
  GT_FIELDCATALOG-SELTEXT_L = 'GRN FI Doc No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  GT_FIELDCATALOG-HOTSPOT       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 3. FI document No.
  GT_FIELDCATALOG-FIELDNAME = 'GRN_AMT'.
  GT_FIELDCATALOG-SELTEXT_L = 'GRN FI Doc.No.Amt'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 3. FI document No.
  GT_FIELDCATALOG-FIELDNAME = 'ZUONR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Original Inv.No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 3. FI document No.
  GT_FIELDCATALOG-FIELDNAME = 'BKTXT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Original Inv.Dt.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 4. Bill Booking No.
  GT_FIELDCATALOG-FIELDNAME = 'AWKEY'.
  GT_FIELDCATALOG-SELTEXT_L = 'Miro No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 5. MIRO A/c Doc No.
  GT_FIELDCATALOG-FIELDNAME = 'MIRO_AC_DOC'.
  GT_FIELDCATALOG-SELTEXT_L = 'FI Doc No.'.
  GT_FIELDCATALOG-HOTSPOT       = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 5. MIRO A/c Doc No.
  GT_FIELDCATALOG-FIELDNAME = 'BLART'.
  GT_FIELDCATALOG-SELTEXT_L = 'FI Doc.Type'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 6. Bill Booking Date
  GT_FIELDCATALOG-FIELDNAME = 'BILL_DT'.
  GT_FIELDCATALOG-SELTEXT_L = 'FI Doc Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> GR Ledger Code
  GT_FIELDCATALOG-FIELDNAME = 'HKONT'.
  GT_FIELDCATALOG-SELTEXT_L = 'GR Ledger Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> GR Ledger Description
  GT_FIELDCATALOG-FIELDNAME = 'TXT20'.
  GT_FIELDCATALOG-SELTEXT_L = 'GR Ledger Description'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> GR Ledger Description
  GT_FIELDCATALOG-FIELDNAME = 'STEUC'.
  GT_FIELDCATALOG-SELTEXT_L = 'HSN/SAC Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 15. Material
  GT_FIELDCATALOG-FIELDNAME = 'MATNR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Item Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '18'.
  GT_FIELDCATALOG-NO_ZERO = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 16. Material Description
  GT_FIELDCATALOG-FIELDNAME = 'LONG_TXT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Item Description (100 char)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> Material Type
  GT_FIELDCATALOG-FIELDNAME = 'MTART'.
  GT_FIELDCATALOG-SELTEXT_L = 'Material Type'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> Delivery Date
  GT_FIELDCATALOG-FIELDNAME = 'EINDT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Delivery Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> PO Qty
  GT_FIELDCATALOG-FIELDNAME = 'PO_QTY'.
  GT_FIELDCATALOG-SELTEXT_L = 'PO Qty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 17. Quantity
  GT_FIELDCATALOG-FIELDNAME = 'LSMNG'.
  GT_FIELDCATALOG-SELTEXT_L = 'Challan Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 17. Quantity
  GT_FIELDCATALOG-FIELDNAME = 'MENGE'.
  GT_FIELDCATALOG-SELTEXT_L = 'Recpt.Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 17. ACC Quantity
  GT_FIELDCATALOG-FIELDNAME = 'ACC_QTY'.
  GT_FIELDCATALOG-SELTEXT_L = 'Acc.Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 17. Rej Quantity
  GT_FIELDCATALOG-FIELDNAME = 'REJ_QTY'.
  GT_FIELDCATALOG-SELTEXT_L = 'Rejected Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 17. Scrap Quantity
  GT_FIELDCATALOG-FIELDNAME = 'SCP_QTY'.
  GT_FIELDCATALOG-SELTEXT_L = 'Scrap Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 17. Rewrk Quantity
  GT_FIELDCATALOG-FIELDNAME = 'Rew_QTY'.
  GT_FIELDCATALOG-SELTEXT_L = 'Rework Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 20. Document Currency
  GT_FIELDCATALOG-FIELDNAME = 'WAERS'.
  GT_FIELDCATALOG-SELTEXT_L = 'PO.Currency'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '5'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 21. Exchange Rate
  GT_FIELDCATALOG-FIELDNAME = 'KURSF'.
  GT_FIELDCATALOG-SELTEXT_L = 'Exchange Rate'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

***>>> 63. Rate Per Qty
  GT_FIELDCATALOG-FIELDNAME = 'RATE'.
  GT_FIELDCATALOG-SELTEXT_L = 'Rate'.
  APPEND  GT_FIELDCATALOG.
  CLEAR  GT_FIELDCATALOG.

***>>>Social Welfare
  GT_FIELDCATALOG-FIELDNAME = 'WRBTR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Social Welfare'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-do_sum    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 22. Basic (DC)
  GT_FIELDCATALOG-FIELDNAME = 'BASIC'.
  GT_FIELDCATALOG-SELTEXT_L = 'Basic(DC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 23. Basic (LC)
  GT_FIELDCATALOG-FIELDNAME = 'BASIC_LC'.
  GT_FIELDCATALOG-SELTEXT_L = 'Basic(LC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 25. Packing (LC)
  GT_FIELDCATALOG-FIELDNAME = 'PACKING_LC'.
  GT_FIELDCATALOG-SELTEXT_L = 'Packing'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 25. Packing (LC)
  GT_FIELDCATALOG-FIELDNAME = 'INSP'.
  GT_FIELDCATALOG-SELTEXT_L = 'Insp.Charge'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 25. Packing (LC)
  GT_FIELDCATALOG-FIELDNAME = 'SET_VAL'.
  GT_FIELDCATALOG-SELTEXT_L = 'Setting Charge'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 50. Freight(LC)
  GT_FIELDCATALOG-FIELDNAME = 'FREIGHT_LC'.
  GT_FIELDCATALOG-SELTEXT_L = 'Freight'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 25. Insurance (LC)
  GT_FIELDCATALOG-FIELDNAME = 'INS'.
  GT_FIELDCATALOG-SELTEXT_L = 'Insurance'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 25. Other Charges (LC)
  GT_FIELDCATALOG-FIELDNAME = 'OTH_CH'.
  GT_FIELDCATALOG-SELTEXT_L = 'Other Charges'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 25. Development Charges (LC)
  GT_FIELDCATALOG-FIELDNAME = 'DEV_CH'.
  GT_FIELDCATALOG-SELTEXT_L = 'Development Charges'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 33. Assessable GST
  GT_FIELDCATALOG-FIELDNAME = 'NET_TOTAL_LC'.
  GT_FIELDCATALOG-SELTEXT_L = 'Assessable Value (GST)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 14. Tax code
  GT_FIELDCATALOG-FIELDNAME = 'MWSKZ'.
  GT_FIELDCATALOG-SELTEXT_L = 'Tax Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '7'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 14. Tax code Description
  GT_FIELDCATALOG-FIELDNAME = 'TEXT1'.
  GT_FIELDCATALOG-SELTEXT_L = 'Tax Code Description'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '7'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 28. Basic Excise Duty
  GT_FIELDCATALOG-FIELDNAME = 'BED'.
  GT_FIELDCATALOG-SELTEXT_L = 'Basic Excise Duty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 29. Addl.Excise Duty
  GT_FIELDCATALOG-FIELDNAME = 'AED'.
  GT_FIELDCATALOG-SELTEXT_L = 'Addl.Excise Duty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 34. VAT Tax
  GT_FIELDCATALOG-FIELDNAME = 'VAT_TAX'.
  GT_FIELDCATALOG-SELTEXT_L = 'VAT Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 36. CST Tax
  GT_FIELDCATALOG-FIELDNAME = 'CST_TAX'.
  GT_FIELDCATALOG-SELTEXT_L = 'CST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 41. Service Tax (Dr)
  GT_FIELDCATALOG-FIELDNAME = 'SER_VAL_DR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Service Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 42. Swach Bharat Cess (Dr)
  GT_FIELDCATALOG-FIELDNAME = 'SBC_DR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Swach Bharat Cess(Dr)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 43. Krishi Kalyan Cess (Dr)
  GT_FIELDCATALOG-FIELDNAME = 'KKC_DR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Krishi Kalyan Cess(Dr)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.
****>>> 72. CGST
  GT_FIELDCATALOG-FIELDNAME = 'CGST'.
  GT_FIELDCATALOG-SELTEXT_L = 'CGST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 71. CGST Tax
  GT_FIELDCATALOG-FIELDNAME = 'CGST_TAX'.
  GT_FIELDCATALOG-SELTEXT_L = 'CGST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 74. SGST
  GT_FIELDCATALOG-FIELDNAME = 'SGST'.
  GT_FIELDCATALOG-SELTEXT_L = 'SGST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

***>>> 73. SGST Tax
  GT_FIELDCATALOG-FIELDNAME = 'SGST_TAX'.
  GT_FIELDCATALOG-SELTEXT_L = 'SGST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 76. IGST
  GT_FIELDCATALOG-FIELDNAME = 'IGST'.
  GT_FIELDCATALOG-SELTEXT_L = 'IGST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 75. IGST Tax
  GT_FIELDCATALOG-FIELDNAME = 'IGST_TAX'.
  GT_FIELDCATALOG-SELTEXT_L = 'IGST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> Comm Cess %
  GT_FIELDCATALOG-FIELDNAME = 'COM_P'.
  GT_FIELDCATALOG-SELTEXT_L = 'Comp. Cess %'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> Comm Cess Val
  GT_FIELDCATALOG-FIELDNAME = 'COM_V'.
  GT_FIELDCATALOG-SELTEXT_L = 'Comp. Cess Value'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> GST Total
  GT_FIELDCATALOG-FIELDNAME = 'GST_AMT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Total GST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 44. Basic Customs
  GT_FIELDCATALOG-FIELDNAME = 'BASIC_CUST'.
  GT_FIELDCATALOG-SELTEXT_L = 'Custom Duty Value'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 45. CVD
  GT_FIELDCATALOG-FIELDNAME = 'CVD'.
  GT_FIELDCATALOG-SELTEXT_L = 'CVD'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 46. Customs ECess
  GT_FIELDCATALOG-FIELDNAME = 'CUST_CESS'.
  GT_FIELDCATALOG-SELTEXT_L = 'Customs ECess'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 47. Customs HECess
  GT_FIELDCATALOG-FIELDNAME = 'CUST_HCESS'.
  GT_FIELDCATALOG-SELTEXT_L = 'Customs HECess'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.



****>>> 45. CVD
  GT_FIELDCATALOG-FIELDNAME = 'ADD_CVD'.
  GT_FIELDCATALOG-SELTEXT_L = 'Add.Custom Duty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM    = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> Total Tax Amt
  GT_FIELDCATALOG-FIELDNAME = 'TOT_TAX'.
  GT_FIELDCATALOG-SELTEXT_L = 'Total Tax Amt.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 59. GROSS TOTAL (LC)
  GT_FIELDCATALOG-FIELDNAME = 'GROSS_TOT_LC'.
  GT_FIELDCATALOG-SELTEXT_L = 'Gross Total(LC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


****>>> 65. Main Asset Number
  GT_FIELDCATALOG-FIELDNAME = 'ANLN1'.
  GT_FIELDCATALOG-SELTEXT_L = 'Main Asset Number'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND  GT_FIELDCATALOG.
  CLEAR   GT_FIELDCATALOG.

****>>> 66. Asset Subnumber
  GT_FIELDCATALOG-FIELDNAME = 'ANLN2'.
  GT_FIELDCATALOG-SELTEXT_L = 'Asset Subnumber'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
  APPEND  GT_FIELDCATALOG.
  CLEAR   GT_FIELDCATALOG.

****>>> 66. Asset Inventory No
  GT_FIELDCATALOG-FIELDNAME = 'INVNR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Asset Inventory No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
  APPEND  GT_FIELDCATALOG.
  CLEAR   GT_FIELDCATALOG.

****>>> 67. Asset description
  GT_FIELDCATALOG-FIELDNAME = 'TXT50'.
  GT_FIELDCATALOG-SELTEXT_L = 'Asset description'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '25'.
  APPEND  GT_FIELDCATALOG.
  CLEAR   GT_FIELDCATALOG.

****>>> 68. Reconciliation Account in General Ledger
  GT_FIELDCATALOG-FIELDNAME = 'SAKTO'.
  GT_FIELDCATALOG-SELTEXT_L = 'Reconciliation G/L Account'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND  GT_FIELDCATALOG.
  CLEAR   GT_FIELDCATALOG.

****>>> 68. Reconciliation Account in General Ledger
  GT_FIELDCATALOG-FIELDNAME = 'ASS_AMT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Gross Asset Amount'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND  GT_FIELDCATALOG.
  CLEAR   GT_FIELDCATALOG.
  GT_FIELDCATALOG-FIELDNAME = 'MOC'.
  GT_FIELDCATALOG-SELTEXT_L = 'MOC'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

  GT_FIELDCATALOG-FIELDNAME = 'BRAND'.
  GT_FIELDCATALOG-SELTEXT_L = 'Brand'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

  GT_FIELDCATALOG-FIELDNAME = 'ZSIZE'.
  GT_FIELDCATALOG-SELTEXT_L = 'Size'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

  GT_FIELDCATALOG-FIELDNAME = 'ZSERIES'.
  GT_FIELDCATALOG-SELTEXT_L = 'Series'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

  GT_FIELDCATALOG-FIELDNAME = 'TYPE'.
  GT_FIELDCATALOG-SELTEXT_L = 'Type'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 35. VAT
  GT_FIELDCATALOG-FIELDNAME = 'VAT'.
  GT_FIELDCATALOG-SELTEXT_L = 'VAT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

****>>> 37. CST
  GT_FIELDCATALOG-FIELDNAME = 'CST'.
  GT_FIELDCATALOG-SELTEXT_L = 'CST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


*  ****>>> 58. GROSS TOTAL (DC)
  GT_FIELDCATALOG-FIELDNAME = 'GROSS_TOT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Gross Total(DC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  GT_FIELDCATALOG-DO_SUM = 'X'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


  GT_FIELDCATALOG-FIELDNAME = 'BLDAT'.
  GT_FIELDCATALOG-SELTEXT_L = 'Ref.Doc.Date'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.
*

  GT_FIELDCATALOG-FIELDNAME = 'MEINS'.
  GT_FIELDCATALOG-SELTEXT_L = 'Unit of Measure'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

  GT_FIELDCATALOG-FIELDNAME = 'BSART'.
  GT_FIELDCATALOG-SELTEXT_L = 'Purchase Order Type'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.

  GT_FIELDCATALOG-FIELDNAME = 'INFNR'.
  GT_FIELDCATALOG-SELTEXT_L = 'Info Record'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.


  GT_FIELDCATALOG-FIELDNAME = 'J_1ISSIST'.
  GT_FIELDCATALOG-SELTEXT_L = 'MSME Status'.
  APPEND GT_FIELDCATALOG.
  CLEAR GT_FIELDCATALOG.
*
****>>>Social Welfare
*  gt_fieldcatalog-fieldname = 'WRBTR'.
*  gt_fieldcatalog-seltext_l = 'Social Welfare'.
*  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum    = 'X'.
*  APPEND gt_fieldcatalog.
*  CLEAR gt_fieldcatalog.

********* Changes by Bency, Req No. DEVK903608 ************
***
*******>>> 51. LBT
***  gt_fieldcatalog-fieldname = 'LBT'.
***  gt_fieldcatalog-seltext_l = 'LBT'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 18. Plant
***  gt_fieldcatalog-fieldname = 'WERKS'.
***  gt_fieldcatalog-seltext_l = 'Plant'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '7'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


******>>> 24. Packing (DC)
**  gt_fieldcatalog-fieldname = 'PACKING'.
**  gt_fieldcatalog-seltext_l = 'Packing(DC)'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.


******>>> 26. Discount (DC)
**  gt_fieldcatalog-fieldname = 'DISCOUNT'.
**  gt_fieldcatalog-seltext_l = 'Discount'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.

*******>>> 27. Discount (LC)
***  gt_fieldcatalog-fieldname = 'DISCOUNT_LC'.
***  gt_fieldcatalog-seltext_l = 'Discount'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

***
*******>>> 30. Edu.Excise
***  gt_fieldcatalog-fieldname = 'ECS_CR'.
***  gt_fieldcatalog-seltext_l = 'Edu.Excise(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 31. HCESS
***  gt_fieldcatalog-fieldname = 'HCESS_CR'.
***  gt_fieldcatalog-seltext_l = 'Higher Edu.Excise(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>>  Edu.Excise
***  gt_fieldcatalog-fieldname = 'ECS_DR'.
***  gt_fieldcatalog-seltext_l = 'Edu.Excise(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

****>>>  HCESS
***  gt_fieldcatalog-fieldname = 'HCESS_DR'.
***  gt_fieldcatalog-seltext_l = 'Higher Edu.Excise(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

****>>> 30. Edu.Excise
***  gt_fieldcatalog-fieldname = 'ECS'.
***  gt_fieldcatalog-seltext_l = 'Edu.Excise'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 31. HCESS
***  gt_fieldcatalog-fieldname = 'HCESS'.
***  gt_fieldcatalog-seltext_l = 'Higher Edu.Excise'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

********* End of Changes by Bency, Req No. DEVK903608 ************

******>>> 32. Net Total (DC)
**  gt_fieldcatalog-fieldname = 'NET_TOTAL'.
**  gt_fieldcatalog-seltext_l = 'Net Total(DC)'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum    = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.


*******>>> 77. CGST Tax NS
***  gt_fieldcatalog-fieldname = 'CGST_NS_TAX'.
***  gt_fieldcatalog-seltext_l = 'CGST Tax (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 78. CGST NS
***  gt_fieldcatalog-fieldname = 'CGST_NS'.
***  gt_fieldcatalog-seltext_l = 'CGST (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 79. SGST Tax NS
***  gt_fieldcatalog-fieldname = 'SGST_NS_TAX'.
***  gt_fieldcatalog-seltext_l = 'SGST Tax (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 80. SGST NS
***  gt_fieldcatalog-fieldname = 'SGST_NS'.
***  gt_fieldcatalog-seltext_l = 'SGST (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 81. IGST Tax NS
***  gt_fieldcatalog-fieldname = 'IGST_NS_TAX'.
***  gt_fieldcatalog-seltext_l = 'IGST Tax (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 82. IGST NS
***  gt_fieldcatalog-fieldname = 'IGST_NS'.
***  gt_fieldcatalog-seltext_l = 'IGST (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 83. IGST Tax IMP
***  gt_fieldcatalog-fieldname = 'IGST_TAX_IM'.
***  gt_fieldcatalog-seltext_l = 'IGST Tax (IMP)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 84. IGST IMP
***  gt_fieldcatalog-fieldname = 'IGST_IM'.
***  gt_fieldcatalog-seltext_l = 'IGST (IMP)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
*******>>> 38. Service Tax (Cr)
***  gt_fieldcatalog-fieldname = 'SER_VAL_CR'.
***  gt_fieldcatalog-seltext_l = 'Service Tax(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


****>>> 39. Swach Bharat Cess (Cr)
***  gt_fieldcatalog-fieldname = 'SBC_CR'.
***  gt_fieldcatalog-seltext_l = 'Swach Bharat Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
***
*******>>> 40. Krishi Kalyan Cess (Cr)
***  gt_fieldcatalog-fieldname = 'KKC_CR'.
***  gt_fieldcatalog-seltext_l = 'Krishi Kalyan Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 48. Add.CVD
***  gt_fieldcatalog-fieldname = 'ADD_CVD'.
***  gt_fieldcatalog-seltext_l = 'Add.CVD'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 49. Freight (DC)
***  gt_fieldcatalog-fieldname = 'FREIGHT'.
***  gt_fieldcatalog-seltext_l = 'Freight(DC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


**** B.O.C Bency 06.12.2016
*******>>>  Serv tax cess credit
***  gt_fieldcatalog-fieldname = 'SERTAXCESS_CR'.
***  gt_fieldcatalog-seltext_l = 'Service tax Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>>  Higher Serv tax cess credit
***  gt_fieldcatalog-fieldname = 'HSERTAXCESS_CR'.
***  gt_fieldcatalog-seltext_l = 'Higher Service tax Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>>  Serv tax cess debit
***  gt_fieldcatalog-fieldname = 'SERTAXCESS_DR'.
***  gt_fieldcatalog-seltext_l = 'Service tax Cess(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>>  Higher Serv tax cess debit
***  gt_fieldcatalog-fieldname = 'HSERTAXCESS_DR'.
***  gt_fieldcatalog-seltext_l = 'Higher Service tax Cess(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
**** E.O.C Bency 06.12.2016

****>>> 52. FORWARDING (DC)
*  gt_fieldcatalog-fieldname = 'FORWARDING'.
*  gt_fieldcatalog-seltext_l = 'Forwarding(DC)'.
*  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-do_sum    = 'X'.
*  append gt_fieldcatalog.
*  clear gt_fieldcatalog.

****>>> 53. FORWARDING (LC)
*  gt_fieldcatalog-fieldname = 'FORWARDING_LC'.
*  gt_fieldcatalog-seltext_l = 'Forwarding(LC)'.
*  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-do_sum    = 'X'.
*  append gt_fieldcatalog.
*  clear gt_fieldcatalog.

******>>> 54. CLEARING
**  gt_fieldcatalog-fieldname = 'CLEARING'.
**  gt_fieldcatalog-seltext_l = 'Clearing'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum    = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.

*******>>> 55. CLEARING (LC)
***  gt_fieldcatalog-fieldname = 'CLEARING_LC'.
***  gt_fieldcatalog-seltext_l = 'Clearing'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 56. TDS (DC)
***  gt_fieldcatalog-fieldname = 'TDS_DC'.
***  gt_fieldcatalog-seltext_l = 'TDS(DC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

***
*******>>> 57. TDS (LC)
***  gt_fieldcatalog-fieldname = 'TDS_LC'.
***  gt_fieldcatalog-seltext_l = 'TDS(LC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

******>>> 61. TIN No.
**  gt_fieldcatalog-fieldname = 'TIN_NO'.
**  gt_fieldcatalog-seltext_l = 'TIN No.'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
**  APPEND gt_fieldcatalog.
**
******>>> 62. LST No.
**  gt_fieldcatalog-fieldname = 'LST_NO'.
**  gt_fieldcatalog-seltext_l = 'LST No.'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.
**
******>>> 64. T-Code
**  gt_fieldcatalog-fieldname = 'TCODE'.
**  gt_fieldcatalog-seltext_l = 'T-Code'.
**  APPEND  gt_fieldcatalog.
**  CLEAR   gt_fieldcatalog.

*******>>> 69. GROSS TOTAL WITHOUT TDS (DC)
***  gt_fieldcatalog-fieldname = 'GROSS_TOT_TDS'.
***  gt_fieldcatalog-seltext_l = 'Gross Total Without TDS(DC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
***
*******>>> 70. GROSS TOTAL WITHOUT TDS (LC)
***  gt_fieldcatalog-fieldname = 'GROSS_TOT_LC_TDS'.
***  gt_fieldcatalog-seltext_l = 'Gross Total Without TDS(LC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

***
*******>>> 85. CGST Tax RC
***  gt_fieldcatalog-fieldname = 'CGST_RC_TAX'.
***  gt_fieldcatalog-seltext_l = 'CGST Tax (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 86. CGST RCM
***  gt_fieldcatalog-fieldname = 'CGST_RC'.
***  gt_fieldcatalog-seltext_l = 'CGST (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 87. SGST Tax RC
***  gt_fieldcatalog-fieldname = 'SGST_RC_TAX'.
***  gt_fieldcatalog-seltext_l = 'SGST Tax (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 88. SGST RCM
***  gt_fieldcatalog-fieldname = 'SGST_RC'.
***  gt_fieldcatalog-seltext_l = 'SGST (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 89. CGST Tax RC NS
***  gt_fieldcatalog-fieldname = 'CGST_NRC_TAX'.
***  gt_fieldcatalog-seltext_l = 'CGST Tax (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 90. CGST RCM NS
***  gt_fieldcatalog-fieldname = 'CGST_NRC'.
***  gt_fieldcatalog-seltext_l = 'CGST (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 91. SGST Tax RC NS
***  gt_fieldcatalog-fieldname = 'SGST_NRC_TAX'.
***  gt_fieldcatalog-seltext_l = 'SGST Tax (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 92. SGST RCM NS
***  gt_fieldcatalog-fieldname = 'SGST_NRC'.
***  gt_fieldcatalog-seltext_l = 'SGST (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


ENDFORM. " f_fieldcatalog



*&---------------------------------------------------------------------*
*&      Form  f_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM F_LAYOUT .

  GT_EVENT-NAME = SLIS_EV_TOP_OF_PAGE.
  GT_EVENT-FORM = 'TOP_OF_PAGE'.
  APPEND GT_EVENT.
  GT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
ENDFORM. " f_layout

*&---------------------------------------------------------------------*
*&      Form  f_displaygrid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM F_DISPLAYGRID .

*  BREAK primus.
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
**    PERFORM gui_download.

  ELSE.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        I_CALLBACK_PROGRAM      = SY-REPID
        I_CALLBACK_USER_COMMAND = 'USER_CMD'
        I_CALLBACK_TOP_OF_PAGE  = 'TOP_OF_PAGE'
        IS_LAYOUT               = GT_LAYOUT
        IT_FIELDCAT             = GT_FIELDCATALOG[]
        IT_SORT                 = GT_SORT[]
        IT_EVENTS               = GT_EVENT[]
        I_SAVE                  = 'A'
      TABLES
        T_OUTTAB                = GT_FINAL
      EXCEPTIONS
        PROGRAM_ERROR           = 1
        OTHERS                  = 2.
    IF SY-SUBRC <> 0.

* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
ENDFORM. " f_displaygrid

*&---------------------------------------------------------------------*
*&      Form  top_of_page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM TOP_OF_PAGE.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = GT_LISTHEADER[].

ENDFORM. "top_of_page

*&---------------------------------------------------------------------*
*&      Form  USER_CMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM USER_CMD USING R_UCOMM LIKE SY-UCOMM
                    RS_SELFIELD TYPE SLIS_SELFIELD.
  DATA:
     LV_BUKRS TYPE BKPF-BUKRS VALUE '1000'   .
  CASE R_UCOMM.
    WHEN '&IC1'. "for double click
      IF RS_SELFIELD-FIELDNAME = 'MIRO_AC_DOC'.
        SET PARAMETER ID 'BLN' FIELD RS_SELFIELD-VALUE.
        SET PARAMETER ID 'BUK' FIELD LV_BUKRS.
        SET PARAMETER ID 'GJR' FIELD S_GJAHR-LOW.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
      IF RS_SELFIELD-FIELDNAME = 'BELNR'.
        SET PARAMETER ID 'BLN' FIELD RS_SELFIELD-VALUE.
        SET PARAMETER ID 'BUK' FIELD LV_BUKRS.
        SET PARAMETER ID 'GJR' FIELD S_GJAHR-LOW.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
      IF RS_SELFIELD-FIELDNAME = 'EBELN'.
        SET PARAMETER ID 'BES' FIELD RS_SELFIELD-VALUE.
        CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
      ENDIF.
  ENDCASE.
ENDFORM.                    "USER_CMD
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).
*  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_FINAL "gt_final
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZPURCHASE_REG.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPurchase Download started on', SY-DATUM, 'at', SY-UZEIT.
  WRITE: / 'Dest. File:', LV_FULLFILE.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.

  """""""" ++ NC """"""""""""""""""""""
  IF SY-SUBRC = 0.
    DATA LV_STRING_263 TYPE STRING.
    DATA LV_CRLF_263 TYPE STRING.

*    TRANSFER hd_csv TO lv_fullfile.

    LV_CRLF_263   = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_263 = HD_CSV.

    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_263  LV_CRLF_263   WA_CSV INTO LV_STRING_263 .
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_263 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
  """""""" ++ NC """"""""""""""""""""""
*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*  CLOSE DATASET lv_fullfile.
*  CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*  MESSAGE lv_msg TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING     PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Purchase Org.'
              'Vendor'
              'Vendor Name'
              'Address'
              'GSTIN'
              'REGD/URD/Comp'
              'State Code'
              'State'
              'Invoice No.'
              'Vendor Inv.No.'
              'Inv.Dt.'
              'PO No.'
              'PO Dt.'
              'PO Line Item'
              'Item Category'
              'Acc.Assgn.Category'
              'GRN No.'
              'GRN Dt.'
              'GRN FI Doc.'
              'GRN FI Doc.Amt.'
              'Original Inv.No.'
              'Original Inv.Dt.'
              'MIRO No.'
              'FI Doc.No.'
              'FI Doc.Type'
              'FI Doc.Dt.'
              'GR Ledger Code'
              'GR Ledger Description'
              'HSN/SAC Code'
              'Item Code'
              'Long Description'
              'Material Type'
              'Delivery Date'
              'PO Qty.'
              'Challan Qty.'
              'Recpt.Qty.'
              'Accpt.Qty.'
              'Rejected Qty.'
              'Scrap Qty.'
              'Rework Qty.'
              'PO Currency'
              'Exchange Rate'
              'Rate'
              'Social Welfare'
              'Basic(DC)'
              'Basic(LC)'
              'Packing'
              'Insp.Charge'
              'Setting Charge'
              'Freight'
              'Insurance'
              'Other Charge'
              'Development Charge'
              'Assessable Value(GST)'
              'Tax Code'
              'Tax Code Description'
              'Basic Excise Duty'
              'Add.Exc.Duty'
              'VAT Tax'            " 'VAT TAX' By Abhishek
              'CST Tax'            " By Abhishek
              'Service Tax'
              'SBC'
              'KKC'
              'CGST%'
              'CGST'
              'SGST%'
              'SGST'
              'IGST%'
              'IGST'
              'Comp Cess%'
              'Comp Cess Val'
              'Total GST Amt'
              'BASIC CUSTOM'             " BY NAKUL  09.0402018 Basic Custom
              'CVD'
              'Customs Ecess'
              'Customs HEcess'
              'Add.Custom Duty'
              'Total Tax Amt'
              'GROSS_TOTAL (LC)'
              'Main Asset Number'
              'Asset Subnumber'
              'Asset Inventory No.'
              'Asset description'
              'Reconciliation Account'
              'Asset Gross Amount'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'Type'
              'VAT'
              'CST'
              'GROSS_TOTAL (LC)'
              'Refreshable Date'
              'Unit of Measure'
              'Ref.Doc.Date'
              'Purchase Order Type'
              'Info Record'
              'MSME Status'
              INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GUI_DOWNLOAD .
  DATA FILE TYPE STRING VALUE 'D:\ZPURCHASE_REG.TXT'.
  TYPES : BEGIN OF LS_FIELDNAME,
            FIELD_NAME(25),
          END OF LS_FIELDNAME.
  DATA : IT_FIELDNAME TYPE TABLE OF LS_FIELDNAME.
  DATA : WA_FIELDNAME TYPE LS_FIELDNAME.
*------------Heading------------------------
  WA_FIELDNAME-FIELD_NAME = 'Purchase Order'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Vendor'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Vendor Name'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Address'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GSTIN No'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'REGD/URD/Comp'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'State Code'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'State'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Invoice No'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Vendor Inv.No'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Inv. Dt.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'PO No.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'PO Date'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'PO Line Item'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Item Category'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Acc.Assgn.Category'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GRN No.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GRN Dt'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GRN FI Doc'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GRN FI Doc Amt'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Original Inv.No'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Original Inv.No Dt'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'MIRO No.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'FI Doc No'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'FI Doc Type'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'FI Doc.Dt.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GR Ledger Code'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GR Ledger Description'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'HSN/SAC Code'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Item Code'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Long Description'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Material Type'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Delivery Date'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'PO Qty.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Challan Qty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Recpt.Qty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Accpt.Qty.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Rejected Qty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Scrap Qty.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Rework Qty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'PO Currency'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Exchange Rate'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Rate'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Basic (DC).'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Basic (LC).'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Packing'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Inspection Charge'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Setting Charge'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Freight'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Insurance'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Other Charge'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Development Charge'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Assessable Value(GST)'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Tax Code'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Tax Code Description'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Basic Excise Duty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Add.Exc.Duty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'VAT'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'VAT TAX'.  " bY NAKUL 09.04.2018
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'CST'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'CST Tax'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Service Tax'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'SBC'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KKC'.        "" **
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'BASIC CUSTOME'.           " BY NAKUL 04.09.2018 (Changed by Abhishek Pisolkar (10.04.2018))
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'CVD'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Customs Ecess'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Customs HEcess'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Social Welfare'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Add.Custom Duty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  WA_FIELDNAME-FIELD_NAME = 'CGST%'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'CGST'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'SGST%'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'SGST'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'IGST%'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'IGST'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Com.Cess'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Com.Cess Val.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Total GST Amt'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

*  WA_FIELDNAME-FIELD_NAME = 'Basic Custom.'.      "" **
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Total Tax Amount'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GROSS TOTAL(DC)'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'GROSS TOTAL(LC)'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Main Asset Number'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Asset Subnumber'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Asset Inventory No.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Asset description'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Reconciliation Account'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Asset Gross Amount'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'MOC'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Brand'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Size'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Series'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Type'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Refreshable Date'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Invoice Date'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Unit Of Measure'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Purchase Order Type'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Info Record'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

*--------------------------------------------------------------------*
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE            =
      FILENAME                = FILE
      FILETYPE                = 'ASC'
*     APPEND                  = ' '
      WRITE_FIELD_SEPARATOR   = 'X'
    TABLES
      DATA_TAB                = IT_FINAL
      FIELDNAMES              = IT_FIELDNAME
    EXCEPTIONS
      FILE_WRITE_ERROR        = 1
      NO_BATCH                = 2
      GUI_REFUSE_FILETRANSFER = 3
      INVALID_TYPE            = 4
      NO_AUTHORITY            = 5
      UNKNOWN_ERROR           = 6
      HEADER_NOT_ALLOWED      = 7
      SEPARATOR_NOT_ALLOWED   = 8
      FILESIZE_NOT_ALLOWED    = 9
      HEADER_TOO_LONG         = 10
      DP_ERROR_CREATE         = 11
      DP_ERROR_SEND           = 12
      DP_ERROR_WRITE          = 13
      UNKNOWN_DP_ERROR        = 14
      ACCESS_DENIED           = 15
      DP_OUT_OF_MEMORY        = 16
      DISK_FULL               = 17
      DP_TIMEOUT              = 18
      FILE_NOT_FOUND          = 19
      DATAPROVIDER_EXCEPTION  = 20
      CONTROL_FLUSH_ERROR     = 21
      OTHERS                  = 22.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
