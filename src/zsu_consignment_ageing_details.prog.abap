*&---------------------------------------------------------------------*
*&Report: ZSU_CONSIGNMENT_AGEING_DETAILS
*&Transaction: ZSU_CON_AGE
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 04.11.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZUS_INVENTORY_AGEING_DETAILS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_CONSIGNMENT_AGEING_DETAILS.

TABLES:MARA,MARD.
TYPE-POOLS: SLIS.

TYPES:BEGIN OF TY_MARA ,
        MATNR TYPE MARA-MATNR,
*        mtart TYPE mara-mtart,
*        werks TYPE mard-werks,
*        lgort TYPE mard-lgort,
*        labst TYPE mard-labst,
        WRKST TYPE MARA-WRKST, "Added by sarika Thange 09.05.2019
      END OF TY_MARA,

*      BEGIN OF ty_mard,
*        matnr TYPE mard-matnr,
*        werks TYPE mard-werks,
*        lgort TYPE mard-lgort,
*        labst TYPE mard-labst,
*      END OF ty_mard,

      BEGIN OF TY_MSKU,
        MATNR TYPE MSKU-MATNR,
        WERKS TYPE MSKU-WERKS,
        KULAB TYPE MSKU-KULAB,
        KUNNR TYPE MSKU-KUNNR,
      END OF TY_MSKU,

      BEGIN OF TY_MAKT,
        MATNR TYPE MAKT-MATNR,
        MAKTX TYPE MAKT-MAKTX,
      END OF TY_MAKT,

      BEGIN OF TY_MSEG,
        MBLNR      TYPE MSEG-MBLNR,
        ZEILE      TYPE MSEG-ZEILE,
        BWART      TYPE MSEG-BWART,
        MATNR      TYPE MSEG-MATNR,
        WERKS      TYPE MSEG-WERKS,
        LGORT      TYPE MSEG-LGORT,
        SOBKZ      TYPE MSEG-SOBKZ,
        LIFNR      TYPE MSEG-LIFNR,
        SHKZG      TYPE MSEG-SHKZG,
        DMBTR      TYPE MSEG-DMBTR,
        MENGE      TYPE MSEG-MENGE,
        BUKRS      TYPE MSEG-BUKRS,
        BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
        KUNNR      TYPE MSEG-KUNNR,
        VBELN_IM   TYPE MSEG-VBELN_IM, "Modified on 21-07-21 by PJ
      END OF TY_MSEG,

      BEGIN OF TY_T156T,
        SPRAS TYPE T156T-SPRAS,
        BWART TYPE T156T-BWART,
        SOBKZ TYPE T156T-SOBKZ,
        KZBEW TYPE T156T-KZBEW,
        KZZUG TYPE T156T-KZZUG,
        KZVBR TYPE T156T-KZVBR,
        BTEXT TYPE T156T-BTEXT,
      END OF TY_T156T,

      BEGIN OF TY_MBEW,
        MATNR TYPE MATNR,     " MATERIAL NUMBER
        BWKEY TYPE MBEW-BWKEY,
        LBKUM TYPE MBEW-LBKUM,
        SALK3 TYPE MBEW-SALK3,
        VPRSV TYPE VPRSV,     " PRICE CONTROL INDICATOR
        VERPR TYPE VERPR,      "  MOVING AVERAGE PRICE/PERIODIC UNIT PRICE
        STPRS TYPE STPRS,            " STANDARD PRICE
      END OF TY_MBEW,


      BEGIN OF TY_FINAL,
        MBLNR TYPE MSEG-MBLNR,
        ZEILE TYPE MSEG-ZEILE,
        BWART TYPE MSEG-BWART,
        MATNR TYPE MSEG-MATNR,
        WERKS TYPE MSEG-WERKS,
        LGORT TYPE MSEG-LGORT,
        LIFNR TYPE MSEG-LIFNR,
        DMBTR TYPE MSEG-DMBTR,
        MENGE TYPE MSEG-MENGE,
*        menge_new TYPE mseg-menge,
        BUKRS TYPE MSEG-BUKRS,
        DATE  TYPE MKPF-BUDAT,
        DAY   TYPE INT4,
        QTY   TYPE MSEG-MENGE,
        TOTAL TYPE MSEG-MENGE,
        TEXT  TYPE STRING,
        WRKST TYPE MARA-WRKST,
        BTEXT TYPE T156T-BTEXT,
        KUNNR TYPE MSEG-KUNNR,
        NAME1 TYPE KNA1-NAME1,
        LAND1 TYPE KNA1-LAND1, "Modified on 21-07-21 by PJ
        ORT01 TYPE KNA1-ORT01, "Modified on 21-07-21 by PJ
        REGIO TYPE KNA1-REGIO, "Modified on 23-07-21 by PJ
      END OF TY_FINAL,

      BEGIN OF TY_DOWN,
        MBLNR TYPE MSEG-MBLNR,
        MATNR TYPE MSEG-MATNR,
        TEXT  TYPE STRING,
        WERKS TYPE MSEG-WERKS,
        BWART TYPE MSEG-BWART,
        BTEXT TYPE CHAR25,
        QTY   TYPE CHAR15,
        DMBTR TYPE CHAR15,
        TOTAL TYPE CHAR15,
        DAY   TYPE CHAR15,
        DATE  TYPE CHAR15,
        KUNNR TYPE MSEG-KUNNR,
        NAME1 TYPE KNA1-NAME1,
        LAND1 TYPE KNA1-LAND1, "Modified on 21-07-21 by PJ
        ORT01 TYPE KNA1-ORT01, "Modified on 21-07-21 by PJ
*        REGIO TYPE KNA1-REGIO, "Modified on 23-07-21 by PJ
        REF   TYPE CHAR15,
        TIME  TYPE CHAR15, "Addded By Shubhangi Sarode on dt 20.02.2024
***        MENGE TYPE CHAR15,
***
***
***
***
***        WRKST TYPE MARA-WRKST,
***
      END OF TY_DOWN.

TYPES:BEGIN OF TY_TEMP,
        MATNR TYPE MSEG-MATNR,
        KUNNR TYPE MSEG-KUNNR,
        MENGE TYPE MSEG-MENGE,
      END OF TY_TEMP.

DATA: LT_TEMP TYPE TABLE OF TY_TEMP,
      LS_TEMP TYPE TY_TEMP.


DATA: IT_MARA  TYPE TABLE OF TY_MARA,
      WA_MARA  TYPE          TY_MARA,

      IT_VBAP  TYPE TABLE OF VBAP,
      WA_VBAP  TYPE          VBAP,

      IT_VBAP1 TYPE TABLE OF VBAP,
      WA_VBAP1 TYPE          VBAP,

      IT_VBAK  TYPE TABLE OF VBAK,
      WA_VBAK  TYPE          VBAK,

      IT_KONV  TYPE TABLE OF PRCD_ELEMENTS,
      WA_KONV  TYPE          PRCD_ELEMENTS,

      IT_MSEG  TYPE TABLE OF TY_MSEG,
      WA_MSEG  TYPE          TY_MSEG,

*      it_mard  TYPE TABLE OF ty_mard,
*      wa_mard  TYPE          ty_mard,

      IT_T156T TYPE TABLE OF TY_T156T,
      WA_T156T TYPE          TY_T156T,

      IT_MBEW  TYPE TABLE OF TY_MBEW,
      WA_MBEW  TYPE          TY_MBEW,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL,

      IT_DOWN  TYPE TABLE OF TY_DOWN,
      WA_DOWN  TYPE          TY_DOWN,

      IT_MAKT  TYPE TABLE OF TY_MAKT,
      WA_MAKT  TYPE          TY_MAKT,

      IT_MSKU  TYPE TABLE OF TY_MSKU,
      WA_MSKU  TYPE          TY_MSKU,

      IT_MSKU1 TYPE TABLE OF TY_MSKU,
      WA_MSKU1 TYPE          TY_MSKU.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA : LV_TEXT TYPE TDOBNAME.
DATA : LT_LINES TYPE TABLE OF TLINE,
       LS_LINES TYPE TLINE.
**********Modified on 21-07-21 by PJ
TYPES: BEGIN OF TY_LIKP,
         VBELN TYPE LIKP-VBELN,
         KUNNR TYPE LIKP-KUNNR,
       END OF TY_LIKP.

TYPES: BEGIN OF TY_KNA1,
         KUNNR TYPE KNA1-KUNNR,
         LAND1 TYPE KNA1-LAND1,
         ORT01 TYPE KNA1-ORT01,
         REGIO TYPE KNA1-REGIO,
       END OF TY_KNA1.

DATA: IT_LIKP  TYPE TABLE OF  TY_LIKP,
      WA_LIKP  TYPE          TY_LIKP,
      IT_LIPS  TYPE TABLE OF  LIPS,
      WA_LIPS  TYPE          LIPS,
      IT_LIPS1 TYPE TABLE OF  LIPS,
      WA_LIPS1 TYPE          LIPS,
      IT_KNA1  TYPE TABLE OF  TY_KNA1,
      WA_KNA1  TYPE          TY_KNA1,
      IT_LIKP1 TYPE TABLE OF  TY_LIKP,
      WA_LIKP1 TYPE          TY_LIKP.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MARA-MATNR.

PARAMETERS    : P_LGORT TYPE MARD-LGORT.
*                s_werks TYPE mard-werks OBLIGATORY DEFAULT 'SU01' NO INTERVALS MODIF ID BU .

PARAMETERS: S_WERKS TYPE MARD-WERKS OBLIGATORY DEFAULT 'SU01'  MODIF ID ABC . " ADDED BY OMKAR GAVALI

SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT   '/Delval/Saudi'."Saudi'."Saudi'."saudi'.
  "'/delval/Saudi'.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.


AT SELECTION-SCREEN OUTPUT. " ADDED BY OMKAR GAVALI
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'ABC'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.




START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM SORT_DATA.
  PERFORM DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT MATNR
  WERKS
  KULAB
  KUNNR FROM MSKU INTO TABLE IT_MSKU
  WHERE MATNR IN S_MATNR
*    AND lgort = p_lgort
  AND WERKS = S_WERKS.

  DELETE IT_MSKU WHERE WERKS = 'PL01'.

  IF IT_MSKU IS NOT INITIAL.
    SELECT MATNR
    WRKST
    FROM MARA
    INTO TABLE IT_MARA
    FOR ALL ENTRIES IN IT_MSKU
    WHERE MATNR = IT_MSKU-MATNR.



    SELECT MATNR
    BWKEY
    LBKUM
    SALK3
    VPRSV
    VERPR
    STPRS
    FROM MBEW
    INTO TABLE IT_MBEW
    FOR ALL ENTRIES IN IT_MSKU
    WHERE MATNR = IT_MSKU-MATNR
    AND BWKEY = IT_MSKU-WERKS.



  ENDIF.

  IF  IT_MARA IS NOT INITIAL.
    SELECT MATNR
           MAKTX
           FROM MAKT
           INTO TABLE IT_MAKT
           FOR ALL ENTRIES IN IT_MARA
           WHERE MATNR = IT_MARA-MATNR.
  ENDIF.

  IF IT_MSKU IS NOT INITIAL.
    SELECT MBLNR
    ZEILE
    BWART
    MATNR
    WERKS
    LGORT
    SOBKZ
    LIFNR
    SHKZG
    DMBTR
    MENGE
    BUKRS
    BUDAT_MKPF
    KUNNR
    VBELN_IM  FROM MSEG INTO TABLE IT_MSEG" modified by PJ on 21-07-21
    FOR ALL ENTRIES IN IT_MSKU
    WHERE MATNR = IT_MSKU-MATNR
*    AND lgort = it_msku-lgort
    AND LGORT = ' '
    AND SMBLN = ' '
    AND SMBLP = ' '
    AND BUKRS = 'SU00'
    AND WERKS = IT_MSKU-WERKS
*    AND bwart IN ('631', '634','633').
    AND BWART IN ('631','632','633', '634').

*    AND sobkz <> 'E'
*    AND shkzg = 'H'.
*    AND shkzg = 'S'.
  ENDIF.
****Modifies by PJ on 21-07-21
  IF IT_MSEG IS NOT INITIAL.

    SELECT VBELN
           KUNNR FROM LIKP
      INTO TABLE IT_LIKP
      FOR ALL ENTRIES IN IT_MSEG
      WHERE VBELN = IT_MSEG-VBELN_IM.

    SELECT * FROM LIPS
  INTO TABLE IT_LIPS
  FOR ALL ENTRIES IN IT_MSEG
  WHERE VBELN = IT_MSEG-VBELN_IM.

  ENDIF.
*
  IF IT_LIKP IS NOT INITIAL.

    SELECT KUNNR LAND1 ORT01 REGIO FROM KNA1
      INTO TABLE IT_KNA1
    FOR ALL ENTRIES IN IT_LIKP
  WHERE KUNNR = IT_LIKP-KUNNR.
  ENDIF.

*    ENDIF.
  IF IT_LIPS IS NOT INITIAL.
    SELECT * FROM VBAP
   INTO TABLE IT_VBAP
   FOR ALL ENTRIES IN IT_LIPS
   WHERE VBELN = IT_LIPS-VGBEL
      AND POSNR = IT_LIPS-VGPOS.

*         SELECT vbeln
*             kunnr FROM likp
*        INTO TABLE it_likp1
*        FOR ALL ENTRIES IN it_lips
*        WHERE vbeln = it_lips-vbeln.

  ENDIF.
  IF IT_VBAP IS NOT INITIAL.
    SELECT * FROM VBAK
      INTO TABLE IT_VBAK
      FOR ALL ENTRIES IN IT_VBAP
      WHERE VBELN = IT_VBAP-VBELN.
  ENDIF.
  IF IT_VBAK IS NOT INITIAL.
   SELECT *
   FROM PRCD_ELEMENTS
   INTO TABLE IT_KONV
    FOR ALL ENTRIES IN IT_VBAK
    WHERE KNUMV = IT_VBAK-KNUMV
     AND KSCHL = 'ZPR0'.
  ENDIF.

  SORT IT_MSEG BY MATNR.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_DATA .
  DATA :TMP_QTY TYPE MARD-LABST.
  DATA :TMP_QTY2 TYPE MARD-LABST.
  DATA : ZRATE   TYPE ZRATE.
  DATA : RATE TYPE P DECIMALS 5.
  DATA: LV_MENGE TYPE MSEG-MENGE.
  DATA: LV_MENGE2 TYPE MSEG-MENGE,
        LV_FLAG   TYPE CHAR1.

  SORT IT_MSEG BY MBLNR DESCENDING.

  LOOP AT IT_MSEG INTO WA_MSEG.
    CLEAR:RATE.

*    ON CHANGE OF wa_mseg-matnr.
    CLEAR: TMP_QTY,ZRATE .

*      LOOP AT it_msku INTO wa_msku WHERE matnr = wa_mseg-matnr.
    READ TABLE IT_MSKU INTO WA_MSKU WITH KEY MATNR = WA_MSEG-MATNR.
    TMP_QTY = TMP_QTY + WA_MSKU-KULAB.
*      ENDLOOP.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MSEG-MATNR."wa_msku-matnr.
    IF SY-SUBRC = 0.
      IF WA_MBEW-VPRSV = 'V'.
        ZRATE = WA_MBEW-VERPR.
      ELSEIF WA_MBEW-VPRSV = 'S'.
        ZRATE = WA_MBEW-STPRS.
      ENDIF.
    ENDIF.
***      wa_final-dmbtr = tmp_qty * zrate .  " Hide By Milind 04.01.2021
*    ENDON.
    WA_FINAL-MBLNR = WA_MSEG-MBLNR.
    WA_FINAL-ZEILE = WA_MSEG-ZEILE.
    WA_FINAL-BWART = WA_MSEG-BWART.
    WA_FINAL-MATNR = WA_MSEG-MATNR.
    WA_FINAL-WERKS = WA_MSEG-WERKS.
    WA_FINAL-LGORT = WA_MSEG-LGORT.
    WA_FINAL-LIFNR = WA_MSEG-LIFNR.
    WA_FINAL-KUNNR = WA_MSEG-KUNNR.
*    wa_final-dmbtr = wa_mseg-dmbtr.

    SELECT SINGLE NAME1 INTO WA_FINAL-NAME1 FROM KNA1 WHERE KUNNR = WA_MSEG-KUNNR.
    RATE = WA_MBEW-SALK3 / WA_MBEW-LBKUM.
*    IF wa_mseg-menge > tmp_qty.

*      wa_final-menge = tmp_qty.
*      wa_final-dmbtr = tmp_qty * rate." * wa_mbew-verpr.  " Added By Milind 04.01.2021
*      CLEAR tmp_qty.
*    ELSE.
*      wa_final-menge = wa_mseg-menge.

*      tmp_qty = tmp_qty - wa_mseg-menge.
*      wa_final-dmbtr = wa_mseg-menge * rate ."wa_mbew-verpr.  " Added By Milind 04.01.2021
*    ENDIF .
******    modified by PJ on 21-07-21

    READ TABLE IT_LIKP INTO WA_LIKP WITH KEY VBELN = WA_MSEG-VBELN_IM.

    IF SY-SUBRC = 0.

      READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_LIKP-KUNNR.
      IF SY-SUBRC = 0.
        WA_FINAL-LAND1 = WA_KNA1-LAND1.
        WA_FINAL-ORT01 = WA_KNA1-ORT01.
        WA_FINAL-REGIO = WA_KNA1-REGIO. "on 23-07-21 by PJ
      ENDIF.

    ENDIF.
    IT_VBAP1 = IT_VBAP.
    IT_LIPS1 = IT_LIPS.


    READ TABLE IT_LIPS1 INTO WA_LIPS1  WITH KEY VBELN = WA_MSEG-VBELN_IM.
    READ TABLE IT_VBAP1 INTO WA_VBAP1 WITH KEY VBELN =  WA_LIPS1-VGBEL.
*READ TABLE  it_lips INTO wa_lips  with KEY vbeln = wa_mseg-vbeln_im.
    LOOP AT  IT_LIPS INTO WA_LIPS  WHERE VGBEL = WA_VBAP1-VBELN.
      WA_FINAL-MENGE   = WA_FINAL-MENGE + WA_LIPS-LFIMG.
* wa_final-menge   =  wa_lips-lfimg.
    ENDLOOP.
    DATA : GV_MENGE_633 TYPE MSEG-MENGE,
           GV_MENGE     TYPE MSEG-MENGE,
           GV_MENGE_631 TYPE MSEG-MENGE.
    IF WA_FINAL-BWART = '633'.
      GV_MENGE_633  = WA_FINAL-MENGE.
    ENDIF.

    IF WA_FINAL-BWART = '632' .
*          wa_final-menge_new = gv_menge - wa_final-menge.
      GV_MENGE =  WA_FINAL-MENGE.
**          wa_final-menge_new = gv_menge - gv_menge1.
*           MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING menge_new BWART.
    ENDIF.


    IF WA_FINAL-BWART = '631'.

      GV_MENGE_631  = WA_FINAL-MENGE.
      IF LV_FLAG = ''." or  LV_FLAG = '1'.
        WA_FINAL-MENGE = GV_MENGE_631 - GV_MENGE_633 - GV_MENGE.
        "LV_FLAG = '1'.
        GV_MENGE = 0.
      ELSE .

        WA_FINAL-MENGE = GV_MENGE_631 - GV_MENGE_633.
        LV_FLAG = 1.

      ENDIF.
    ENDIF.
    READ TABLE IT_VBAP INTO WA_VBAP  WITH KEY VBELN = WA_LIPS-VGBEL
                                              POSNR = WA_LIPS-VGPOS.

***************************END*******************************************

    WA_FINAL-QTY   = WA_VBAP-KWMENG.
    WA_FINAL-BUKRS = WA_MSEG-BUKRS.
    WA_FINAL-DATE  = WA_MSEG-BUDAT_MKPF .
    WA_FINAL-DAY   = SY-DATUM - WA_MSEG-BUDAT_MKPF .
*     wa_final-menge  = wa_final-qty - wa_final-menge."commented by primus jyoti on 07.02.2024

    READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_VBAP-VBELN.

    READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBAK-KNUMV.
*    WA_FINAL-DMBTR = WA_FINAL-MENGE * WA_KONV-KBETR.
    WA_FINAL-DMBTR = WA_KONV-KBETR.

    IF WA_FINAL-LAND1 IS INITIAL.
      SELECT SINGLE LAND1 INTO WA_FINAL-LAND1 FROM KNA1 WHERE KUNNR = WA_MSEG-KUNNR.
    ENDIF.

    IF WA_FINAL-ORT01 IS INITIAL.
      SELECT SINGLE ORT01 INTO WA_FINAL-ORT01 FROM KNA1 WHERE KUNNR = WA_MSEG-KUNNR.
    ENDIF.

    IF WA_FINAL-REGIO IS INITIAL." modified by PJ on 23-07-21
      SELECT SINGLE REGIO INTO WA_FINAL-REGIO FROM KNA1 WHERE KUNNR = WA_MSEG-KUNNR.
    ENDIF.
********end

    CASE WA_FINAL-BWART.
      WHEN '101'.
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND KZBEW = 'B' AND KZZUG = ' '.
      WHEN '262'.
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND KZBEW = 'L'." AND kzzug = ' '.
      WHEN OTHERS .
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND SOBKZ = ' ' AND KZVBR = ' '.
    ENDCASE.




    READ TABLE IT_MARA INTO WA_MARA WITH  KEY MATNR = WA_MSEG-MATNR.
    WA_FINAL-WRKST = WA_MARA-WRKST.

    LV_TEXT = WA_FINAL-MATNR .

    IF LV_TEXT IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = 'E'
          NAME                    = LV_TEXT
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

      IF LT_LINES IS NOT INITIAL.
        LOOP AT  LT_LINES INTO LS_LINES.
          CONCATENATE WA_FINAL-TEXT  LS_LINES-TDLINE INTO WA_FINAL-TEXT SEPARATED BY SPACE.
        ENDLOOP.
      ELSE.
        READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_MARA-MATNR.
        WA_FINAL-TEXT = WA_MAKT-MAKTX.
      ENDIF.

    ENDIF.
    IF WA_FINAL-BWART = '631' ."OR WA_FINAL-BWART = '634'. "Commented by shubhangi sarode on dt 19.02.2024 as per user requirment
      APPEND WA_FINAL TO IT_FINAL.
      "  CLEAR : LV_FLAG.
    ENDIF.
    CLEAR :WA_FINAL,WA_MARA,WA_MARA,LV_TEXT,RATE,WA_MSKU,LS_TEMP,TMP_QTY2,LV_MENGE,WA_LIPS.

  ENDLOOP.
  SORT IT_FINAL[] BY MATNR KUNNR MENGE BWART.
  DELETE ADJACENT DUPLICATES FROM IT_FINAL[] COMPARING MATNR KUNNR MENGE.
*****************************************************************"added by shubhangi sarode on dt 19.02.2024

  SORT IT_FINAL[] DESCENDING BY DATE KUNNR.


  DATA  : LV_STOCK      TYPE MSKU-KULAB,
          LV_STOCK_TEMP TYPE MSKU-KULAB,
          LV_DIFFER     TYPE MSKU-KULAB.


  LOOP AT IT_MARA INTO WA_MARA .
    ON CHANGE OF WA_MARA-MATNR.
      LOOP AT IT_FINAL INTO WA_FINAL WHERE BWART = '631' .

        ON CHANGE OF WA_FINAL-KUNNR.
          CLEAR WA_MSKU.
          LOOP AT IT_MSKU INTO WA_MSKU WHERE MATNR = WA_FINAL-MATNR AND KUNNR = WA_FINAL-KUNNR.

            LV_STOCK = LV_STOCK + WA_MSKU-KULAB.
            LV_STOCK_TEMP = LV_STOCK.

          ENDLOOP.

        ENDON.

        IF LV_STOCK > 0.
          IF LV_STOCK > WA_FINAL-QTY.
            LV_DIFFER = LV_STOCK - WA_FINAL-QTY.
            LV_STOCK = LV_DIFFER.
          ELSE .
            LV_DIFFER =  WA_FINAL-QTY - LV_STOCK.
            WA_FINAL-QTY = LV_STOCK.
            LV_STOCK = 0.

            MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING QTY WHERE MBLNR = WA_FINAL-MBLNR.

            SKIP.
          ENDIF.
          WA_FINAL-TOTAL = WA_FINAL-QTY * WA_FINAL-DMBTR.
          MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING TOTAL WHERE MBLNR = WA_FINAL-MBLNR.
          CLEAR : WA_FINAL.

        ELSE.
          DELETE IT_FINAL WHERE MBLNR = WA_FINAL-MBLNR.

        ENDIF.





      ENDLOOP.
    ENDON.
  ENDLOOP.

*************************************************************  End code


*****************commented on 09.02.2024********************************
*  SORT IT_FINAL BY BWART.
*     Data : gv_menge_633 type mseg-menge,
*             gv_menge_631 type mseg-menge,
*             gv_menge type mseg-menge,
*             gv_menge1 type mseg-menge.
*      CLEAR :gv_menge_633.
*       LOOP AT IT_FINAL INTO WA_FINAL WHERE BWART = '633' .
*        gv_menge_633 = gv_menge_633 + wa_final-menge..
***        wa_final-menge_new =  gv_menge_631 - wa_final-menge.
***         gv_menge_631 = wa_final-menge_new.
***         MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING menge_new BWART.
*  ENDLOOP.
*
*      CLEAR :gv_menge_631.
*  LOOP AT IT_FINAL INTO WA_FINAL WHERE BWART = '631' .
**    wa_final-menge_new = wa_final-menge.
*     gv_menge_631 = gv_menge_631 + wa_final-menge.
*       wa_final-menge = gv_menge_631 - gv_menge_633.
*     MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING menge BWART.
*  ENDLOOP.
**    LOOP AT IT_FINAL INTO WA_FINAL WHERE BWART = '633' .
***        gv_menge_633 = gv_menge_633 + wa_final-menge..
**        wa_final-menge_new =  gv_menge_631 - wa_final-menge.
**         gv_menge_631 = wa_final-menge_new.
**         MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING menge_new BWART.
*  ENDLOOP.
*  CLEAR :gv_menge.
*  LOOP AT IT_FINAL INTO WA_FINAL WHERE BWART = '634' .
*     wa_final-menge_new = wa_final-menge.
*       gv_menge = gv_menge + wa_final-menge.
*       MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING menge_new BWART.
*  ENDLOOP.
************commented ended by 09.02.2024 ***********************************
*  LOOP AT IT_FINAL INTO WA_FINAL WHERE BWART = '632' .
*          wa_final-menge_new = gv_menge - wa_final-menge.
*           gv_menge =  wa_final-menge_new.
**          wa_final-menge_new = gv_menge - gv_menge1.
*           MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING menge_new BWART.
*  ENDLOOP.
*  LOOP AT IT_FINAL INTO WA_FINAL .
*      IF WA_FINAL-BWART = '631'.
*          wa_final-menge_new =  wa_final-menge_new.
*     ENDIF.
*      IF WA_FINAL-BWART = '633'.
*          wa_final-menge_new = gv_menge_633.
*        ENDIF.
*         IF WA_FINAL-BWART = '634'.
*          wa_final-menge_new =  wa_final-menge_new.
*     ENDIF.
*
*     IF WA_FINAL-BWART = '632'.
*          wa_final-menge_new = gv_menge1.
*     ENDIF.
*
*      MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING menge_new BWART.
* ENDLOOP.




*  DELETE it_final WHERE menge = 0.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MBLNR = WA_FINAL-MBLNR.
      WA_DOWN-MATNR = WA_FINAL-MATNR.
      WA_DOWN-TEXT   = WA_FINAL-TEXT.
      WA_DOWN-WERKS = WA_FINAL-WERKS.
      WA_DOWN-BWART = WA_FINAL-BWART.
      WA_DOWN-BTEXT   = WA_FINAL-BTEXT.
      WA_DOWN-QTY = WA_FINAL-QTY.
      WA_DOWN-DMBTR = WA_FINAL-DMBTR.
      WA_DOWN-TOTAL = WA_FINAL-TOTAL.
      WA_DOWN-DAY   = WA_FINAL-DAY.
      IF WA_FINAL-DATE IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-DATE
          IMPORTING
            OUTPUT = WA_DOWN-DATE.

        CONCATENATE WA_DOWN-DATE+0(2) WA_DOWN-DATE+2(3) WA_DOWN-DATE+5(4)
                        INTO WA_DOWN-DATE SEPARATED BY '-'.
      ENDIF.
      WA_DOWN-KUNNR   = WA_FINAL-KUNNR.
      WA_DOWN-NAME1   = WA_FINAL-NAME1.
      WA_DOWN-LAND1   = WA_FINAL-LAND1."Modifies by PJ on 21-07-21
      WA_DOWN-ORT01   = WA_FINAL-ORT01."Modifies by PJ on 21-07-21

***      WA_DOWN-MENGE = WA_FINAL-MENGE.
***
***
***
***
***      WA_DOWN-WRKST   = WA_FINAL-WRKST.
*      WA_DOWN-REGIO   = WA_FINAL-REGIO."Modifies by PJ on 23-07-21
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.
      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.
      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO WA_DOWN-TIME SEPARATED BY ':'.    "Added by Shubhangi Sarode on dt 20.02.2024
      APPEND WA_DOWN TO IT_DOWN.
      CLEAR :WA_DOWN,RATE.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .
  PERFORM FCAT USING :   '1'   'MBLNR'           'IT_FINAL'      'Document No'                 '20' ,
                         '2'   'MATNR'           'IT_FINAL'      'Material No '                '20' ,
                         '3'   'TEXT'            'IT_FINAL'      'Material Description'        '100' ,
                         '4'   'WERKS'           'IT_FINAL'      'Plant '                      '05' ,
                         '5'   'BWART'           'IT_FINAL'      'Movement Type '              '15' ,
                         '6'   'BTEXT'           'IT_FINAL'      'Mov Type Desc'              '15' ,
                         '7'   'QTY'             'IT_FINAL'      'Quantity '                   '15' ,
                         '8'   'DMBTR'           'IT_FINAL'      'Rate '                     '15' ,
                         '9'   'TOTAL'           'IT_FINAL'      'Amount '                     '15' ,
                         '10'   'DAY'             'IT_FINAL'      'Aging Days '                  '15' ,
                         '11'   'DATE'            'IT_FINAL'      'Posting Date '               '15' ,
                         '12'   'KUNNR'           'IT_FINAL'      'Customer Code'               '15' ,
                         '13'   'NAME1'           'IT_FINAL'      'Customer Name'               '15' ,
                         '14'   'LAND1'           'IT_FINAL'      'Country'                     '15' ,
                         '15'   'ORT01'           'IT_FINAL'      'City'                        '15' .
*                         '6'   'LGORT'           'IT_FINAL'      'Storage Loc '                '15' ,
*                         '8'   'QTY'           'IT_FINAL'      'Allocated Quantity '         '15' ,
*                         '8'   'MENGE'           'IT_FINAL'      'Allocated Quantity '         '15' ,
*                         '9'   'MENGE_new'      'IT_FINAL'      'Diffrence Quantity '         '15' ,
*
*                        '14'   'WRKST'           'IT_FINAL'      'Saudi Code'                    '15' ,
*                       '19'   'REGIO'           'IT_FINAL'      'Region'                      '15'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0383   text
*      -->P_0384   text
*      -->P_0385   text
*      -->P_0386   text
*      -->P_0387   text
*----------------------------------------------------------------------*
FORM FCAT USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
ENDFORM.
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


  """""""""""""""""""uncomment by snehal R. on 12/2/21""""""""""""""""""""""""""""""""""""""""

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
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


*  lv_file = 'ZUS_INVAG_DET.TXT'.

*  CONCATENATE S_WERKS 'ZUS_INVAG_DET.TXT' INTO LV_FILE.
  CONCATENATE  'ZSU_CON_AGE' S_WERKS '.TXT' INTO LV_FILE.
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_CON_AGE REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_955 TYPE string.
DATA lv_crlf_955 TYPE string.
lv_crlf_955 = cl_abap_char_utilities=>cr_lf.
lv_string_955 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_955 lv_crlf_955 wa_csv INTO lv_string_955.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1495 TO lv_fullfile.
TRANSFER lv_string_955 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
  """""""""""""""""""uncomment end by snehal R. on 12/2/21""""""""""""""""""""""""""""""""""""""""




  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
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


*  lv_file = 'ZUS_INVAG_DET.TXT'.

*CONCATENATE S_WERKS 'ZUS_INVAG_DET.TXT' INTO LV_FILE.
  CONCATENATE  'ZSU_CON_AGE' S_WERKS '.TXT' INTO LV_FILE.
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_CON_AGE REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_998 TYPE string.
DATA lv_crlf_998 TYPE string.
lv_crlf_998 = cl_abap_char_utilities=>cr_lf.
lv_string_998 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_998 lv_crlf_998 wa_csv INTO lv_string_998.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1495 TO lv_fullfile.
TRANSFER lv_string_998 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Document No'
              'Material No '
              'Material Description '
              'Plant '
              'Movement Type '
              'Movement Type Description'
              'Quantity '
              'Rate '
              'Total '
              'Aging Day '
              'Posting Date '
              'Customer Code'
              'Customer Name'
              'Country'         "Modifies by PJ on 21-07-21
              'City '            "Modifies by PJ on 21-07-21
              'Refresh Date '
              'Refresh Time '
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
