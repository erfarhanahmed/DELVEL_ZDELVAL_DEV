*&---------------------------------------------------------------------*
*&Report: ZSU_INVENTORY_AGEING_DETAILS
*&Transaction: ZSU_INVAG_DET
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&

*&---------------------------------------------------------------------*
REPORT ZSU_INVENTORY_AGEING_DETAILS.

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

      BEGIN OF TY_MARD,
        MATNR TYPE MARD-MATNR,
        WERKS TYPE MARD-WERKS,
        LGORT TYPE MARD-LGORT,
        LABST TYPE MARD-LABST,
        INSME TYPE MARD-INSME,
      END OF TY_MARD,

      BEGIN OF TY_MSKA,
        MATNR TYPE MSKA-MATNR,
        WERKS TYPE MSKA-WERKS,
        LGORT TYPE MSKA-LGORT,
        SOBKZ TYPE MSKA-SOBKZ,
        KALAB TYPE MSKA-KALAB,
        KAINS TYPE MSKA-KAINS,
      END OF TY_MSKA,

      BEGIN OF TY_MSLB,
        MATNR TYPE MSLB-MATNR,
        WERKS TYPE MSLB-WERKS,
        SOBKZ TYPE MSLB-SOBKZ,
        LBLAB TYPE MSLB-LBLAB,
      END OF TY_MSLB,

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
      END OF TY_MSEG,

      BEGIN OF ST_MSEG,
        MBLNR TYPE MSEG-MBLNR,
        ZEILE TYPE MSEG-ZEILE,
        BWART TYPE MSEG-BWART,
        MATNR TYPE MSEG-MATNR,
        WERKS TYPE MSEG-WERKS,
        SMBLN TYPE MSEG-SMBLN,
      END OF ST_MSEG,

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
        STPRS TYPE STPRS,       " STANDARD PRICE
      END OF TY_MBEW,

      BEGIN OF TY_EBEW,
        MATNR TYPE MATNR,     " MATERIAL NUMBER
        BWKEY TYPE EBEW-BWKEY,
        VBELN TYPE EBEW-VBELN,
        POSNR TYPE EBEW-POSNR,
        LBKUM TYPE EBEW-LBKUM,
        SALK3 TYPE EBEW-SALK3,
        VPRSV TYPE VPRSV,     " PRICE CONTROL INDICATOR
        VERPR TYPE VERPR,      "  MOVING AVERAGE PRICE/PERIODIC UNIT PRICE
        STPRS TYPE STPRS,       " STANDARD PRICE
      END OF TY_EBEW,


      BEGIN OF TY_FINAL,
        MBLNR    TYPE MSEG-MBLNR,
        ZEILE    TYPE MSEG-ZEILE,
        BWART    TYPE MSEG-BWART,
        MATNR    TYPE MSEG-MATNR,
        WERKS    TYPE MSEG-WERKS,
        LGORT    TYPE MSEG-LGORT,
        LIFNR    TYPE MSEG-LIFNR,
        DMBTR    TYPE MSEG-DMBTR,
        DMBTR_SO TYPE MSEG-DMBTR,
        MENGE    TYPE MSEG-MENGE,
        MENGE_SO TYPE MSEG-MENGE,
        BUKRS    TYPE MSEG-BUKRS,
        DATE     TYPE MKPF-BUDAT,
        BLDAT    TYPE MKPF-BLDAT,
        DAY      TYPE INT4,
        QTY      TYPE MSEG-MENGE,
        TEXT     TYPE STRING,
        WRKST    TYPE MARA-WRKST,
        BTEXT    TYPE T156T-BTEXT,
      END OF TY_FINAL,

      BEGIN OF TY_DOWN,
        MBLNR    TYPE MSEG-MBLNR,
        MATNR    TYPE MSEG-MATNR,
        BWART    TYPE MSEG-BWART,
        BTEXT    TYPE CHAR25,
        WERKS    TYPE MSEG-WERKS,
        LGORT    TYPE MSEG-LGORT,
        QTY      TYPE CHAR15,
        MENGE    TYPE CHAR15,
        MENGE_SO TYPE CHAR15,
        DMBTR    TYPE CHAR15,
        DMBTR_SO TYPE CHAR15,
        DATE     TYPE CHAR15,
        DAY      TYPE CHAR15,
        WRKST    TYPE MARA-WRKST,
        BLDAT    TYPE CHAR15,
        TEXT     TYPE STRING,
        REF      TYPE CHAR15,
        REF_TIME TYPE CHAR20,
      END OF TY_DOWN.




DATA: IT_MARA    TYPE TABLE OF TY_MARA,
      WA_MARA    TYPE          TY_MARA,

      IT_MSEG    TYPE TABLE OF TY_MSEG,
      WA_MSEG    TYPE          TY_MSEG,

      IT_MSEG_SO TYPE TABLE OF TY_MSEG,
      WA_MSEG_SO TYPE          TY_MSEG,

      GT_MSEG    TYPE TABLE OF ST_MSEG,
      GS_MSEG    TYPE          ST_MSEG,

      GT_MSEG_SO TYPE TABLE OF ST_MSEG,
      GS_MSEG_SO TYPE          ST_MSEG,

      IT_MARD    TYPE TABLE OF TY_MARD,
      WA_MARD    TYPE          TY_MARD,

      IT_MSLB    TYPE TABLE OF TY_MSLB,
      WA_MSLB    TYPE          TY_MSLB,

      IT_MSKA    TYPE TABLE OF TY_MSKA,
      WA_MSKA    TYPE          TY_MSKA,

      IT_T156T   TYPE TABLE OF TY_T156T,
      WA_T156T   TYPE          TY_T156T,

      IT_MBEW    TYPE TABLE OF TY_MBEW,
      WA_MBEW    TYPE          TY_MBEW,

      IT_EBEW    TYPE TABLE OF TY_EBEW,
      WA_EBEW    TYPE          TY_EBEW,

      IT_FINAL   TYPE TABLE OF TY_FINAL,
      WA_FINAL   TYPE          TY_FINAL,

      IT_DOWN    TYPE TABLE OF TY_DOWN,
      WA_DOWN    TYPE          TY_DOWN,

      IT_MAKT    TYPE TABLE OF TY_MAKT,
      WA_MAKT    TYPE          TY_MAKT.

DATA : LS_QAMB TYPE QAMB,
       WA_QAMB TYPE QAMB.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA : LV_TEXT TYPE TDOBNAME.
DATA : LT_LINES TYPE TABLE OF TLINE,
       LS_LINES TYPE TLINE.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MARA-MATNR,
                S_WERKS FOR MARD-WERKS OBLIGATORY DEFAULT 'SU01'NO INTERVALS MODIF ID BU.
PARAMETERS    : P_LGORT TYPE MARD-LGORT ."OBLIGATORY.

SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'."Saudi'. "'/Delval/Saudi'."Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-006.
SELECTION-SCREEN END OF LINE.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


*AT SELECTION-SCREEN ON S_LGORT.
*  PERFORM validate_LGORT .
*
*  FORM validate_LGORT.
*   SELECT  werks lgort FROM mard INTO TABLE  IT_MARD
*  WHERE LGORT IN s_lgort AND WERKS = 'SU01'.
*
*IF sy-subrc NE 0.
*  MESSAGE 'You are not authorise for Storage Location' TYPE 'E' DISPLAY LIKE 'E'.
*  ENDIF.
*
*
*
*ENDFORM.


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
  IF P_LGORT IS NOT INITIAL.
    SELECT MATNR
           WERKS
           LGORT
           LABST
           INSME FROM MARD INTO TABLE IT_MARD
           WHERE MATNR IN S_MATNR
             AND LGORT = P_LGORT
             AND WERKS IN S_WERKS.


    SELECT MATNR
           WERKS
           LGORT
           SOBKZ
           KALAB
           KAINS FROM MSKA INTO TABLE IT_MSKA
           WHERE MATNR IN S_MATNR
             AND LGORT = P_LGORT
             AND WERKS IN S_WERKS
             AND SOBKZ = 'E'.
  ELSE.
    SELECT MATNR
           WERKS
           LGORT
           LABST
           INSME FROM MARD INTO TABLE IT_MARD
           WHERE MATNR IN S_MATNR
             AND WERKS IN S_WERKS.

    SELECT MATNR
           WERKS
           LGORT
           SOBKZ
           KALAB
           KAINS FROM MSKA INTO TABLE IT_MSKA
           WHERE MATNR IN S_MATNR
             AND WERKS IN S_WERKS
             AND SOBKZ = 'E'.



  ENDIF.


*DELETE it_mard WHERE werks = 'PL01'.
  IF IT_MARD IS NOT INITIAL.
    SELECT MATNR
           WRKST
           FROM MARA
           INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_MARD
           WHERE MATNR = IT_MARD-MATNR.

    SELECT MATNR
           BWKEY
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS
      FROM MBEW
      INTO TABLE IT_MBEW
      FOR ALL ENTRIES IN IT_MARD
      WHERE MATNR = IT_MARD-MATNR
        AND BWKEY = IT_MARD-WERKS.



  ENDIF.

  IF  IT_MARA IS NOT INITIAL.
    SELECT MATNR
           MAKTX
           FROM MAKT
           INTO TABLE IT_MAKT
           FOR ALL ENTRIES IN IT_MARA
           WHERE MATNR = IT_MARA-MATNR.
  ENDIF.


  IF IT_MARD IS NOT INITIAL.

*    SELECT matnr
*           werks
*           sobkz
*           lblab FROM mslb INTO TABLE it_mslb
*           WHERE matnr IN s_matnr
*            AND werks IN s_werks
*            AND sobkz = 'O'.


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
           BUDAT_MKPF FROM MSEG INTO TABLE IT_MSEG
           FOR ALL ENTRIES IN IT_MARD
           WHERE MATNR = IT_MARD-MATNR
             AND LGORT = IT_MARD-LGORT
             AND BUKRS = 'SU00'
             AND BWART IN ('101','105','561','309','311','321','411','412','501','531','653','701','Z11','542','262',
                           '602','301','413','344','Z42','202','343','312','544','166')
             AND SOBKZ <> 'E'
             AND SHKZG = 'S'.

  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
    SELECT MBLNR
           ZEILE
           BWART
           MATNR
           WERKS
           SMBLN FROM MSEG INTO TABLE GT_MSEG
           FOR ALL ENTRIES IN IT_MSEG
           WHERE SMBLN = IT_MSEG-MBLNR
             AND BWART = '322'.

  ENDIF.

  IF IT_MSKA IS NOT INITIAL.

    SELECT MATNR
           BWKEY
           VBELN
           POSNR
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS
      FROM EBEW
      INTO TABLE IT_EBEW
      FOR ALL ENTRIES IN IT_MSKA
      WHERE MATNR = IT_MSKA-MATNR
        AND BWKEY = IT_MSKA-WERKS.

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
           BUDAT_MKPF FROM MSEG INTO TABLE IT_MSEG_SO
           FOR ALL ENTRIES IN IT_MSKA
           WHERE MATNR = IT_MSKA-MATNR
             AND LGORT = IT_MSKA-LGORT
             AND BUKRS = 'SU00'
             AND BWART IN ('101','105','561','309','311','321','411','412','501','531','653','701','Z11','542','262',
                           '602','301','413','344','Z42','202','343','312','544','166')
             AND SOBKZ = 'E'
             AND SHKZG = 'S'.
  ENDIF.

  IF IT_MSEG_SO IS NOT INITIAL.
    SELECT MBLNR
           ZEILE
           BWART
           MATNR
           WERKS
           SMBLN FROM MSEG INTO TABLE GT_MSEG_SO
           FOR ALL ENTRIES IN IT_MSEG_SO
           WHERE SMBLN = IT_MSEG_SO-MBLNR
             AND BWART = '322'.
  ENDIF.


  LOOP AT IT_MSEG INTO WA_MSEG WHERE BWART = '321'.
    READ TABLE GT_MSEG INTO GS_MSEG WITH KEY SMBLN = WA_MSEG-MBLNR.
    IF SY-SUBRC = 0.
      DELETE IT_MSEG WHERE MBLNR = WA_MSEG-MBLNR.
    ENDIF.
  ENDLOOP.

  LOOP AT IT_MSEG_SO INTO WA_MSEG_SO WHERE BWART = '321'.
    READ TABLE GT_MSEG_SO INTO GS_MSEG_SO WITH KEY SMBLN = WA_MSEG_SO-MBLNR.
    IF SY-SUBRC = 0.
      DELETE IT_MSEG_SO WHERE MBLNR = WA_MSEG-MBLNR.
    ENDIF.
  ENDLOOP.

  LOOP AT IT_MSEG INTO WA_MSEG WHERE BWART = '321'.
    SELECT SINGLE * FROM QAMB INTO WA_QAMB WHERE MBLNR = WA_MSEG-MBLNR.
    IF SY-SUBRC = 0.
      SELECT SINGLE * FROM QAMB INTO LS_QAMB WHERE PRUEFLOS = WA_QAMB-PRUEFLOS AND TYP NE '3'.
      IF SY-SUBRC = 0.
        DELETE IT_MSEG WHERE MBLNR = LS_QAMB-MBLNR AND ZEILE = LS_QAMB-ZEILE.
      ENDIF.
    ENDIF.
  ENDLOOP.
  CLEAR :WA_QAMB,LS_QAMB.
  LOOP AT IT_MSEG_SO INTO WA_MSEG_SO WHERE BWART = '321'.
    SELECT SINGLE * FROM QAMB INTO WA_QAMB WHERE MBLNR = WA_MSEG_SO-MBLNR.
    IF SY-SUBRC = 0.
      SELECT SINGLE * FROM QAMB INTO LS_QAMB WHERE PRUEFLOS = WA_QAMB-PRUEFLOS AND TYP NE '3'.
      IF SY-SUBRC = 0.
        DELETE IT_MSEG_SO WHERE MBLNR = LS_QAMB-MBLNR  AND ZEILE = LS_QAMB-ZEILE.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SORT IT_MSEG BY MATNR BUDAT_MKPF DESCENDING.
  SORT IT_MSEG_SO BY MATNR BUDAT_MKPF DESCENDING.
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
*  DATA : zrate   TYPE zrate.
  DATA : ZRATE   TYPE P DECIMALS 6.
  DATA : VALUE   TYPE EBEW-SALK3.
  DATA: STOCK TYPE EBEW-LBKUM.
  LOOP AT IT_MSEG INTO WA_MSEG.

    ON CHANGE OF WA_MSEG-MATNR.
      CLEAR: TMP_QTY,ZRATE .
      LOOP AT IT_MARD INTO WA_MARD WHERE MATNR = WA_MSEG-MATNR.
        TMP_QTY = TMP_QTY + WA_MARD-LABST.
        TMP_QTY = TMP_QTY + WA_MARD-INSME.
      ENDLOOP.

*      LOOP AT it_mska INTO wa_mska WHERE matnr = wa_mseg-matnr.
*        tmp_qty = tmp_qty + wa_mska-kalab.
*        tmp_qty = tmp_qty + wa_mska-kains.
*      ENDLOOP.

*      LOOP AT it_mslb INTO wa_mslb WHERE matnr = wa_mseg-matnr.
*        tmp_qty = tmp_qty + wa_mslb-lblab.
*      ENDLOOP.

      READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MARD-MATNR.
      IF SY-SUBRC = 0.
        ZRATE = WA_MBEW-SALK3 / WA_MBEW-LBKUM.
      ENDIF.
*      IF sy-subrc = 0.                                "commented by snehal rajale on 25.01.2021
*        IF wa_mbew-vprsv = 'V'.
*          zrate = wa_mbew-verpr.
*        ELSEIF wa_mbew-vprsv = 'S'.
*          zrate = wa_mbew-stprs.
*        ENDIF.
*      ENDIF.
*      wa_final-dmbtr = tmp_qty * zrate .
    ENDON.

    WA_FINAL-MBLNR = WA_MSEG-MBLNR.
    WA_FINAL-ZEILE = WA_MSEG-ZEILE.
    WA_FINAL-BWART = WA_MSEG-BWART.
    WA_FINAL-MATNR = WA_MSEG-MATNR.
    WA_FINAL-WERKS = WA_MSEG-WERKS.
    WA_FINAL-LGORT = WA_MSEG-LGORT.
    WA_FINAL-LIFNR = WA_MSEG-LIFNR.
*    wa_final-dmbtr = wa_mseg-dmbtr.

    IF WA_MSEG-MENGE > TMP_QTY.

      WA_FINAL-MENGE = TMP_QTY.
      CLEAR TMP_QTY.
    ELSE.
      WA_FINAL-MENGE = WA_MSEG-MENGE.
      TMP_QTY = TMP_QTY - WA_MSEG-MENGE.
    ENDIF .
    WA_FINAL-DMBTR = WA_FINAL-MENGE * ZRATE .
    WA_FINAL-QTY  = WA_MSEG-MENGE.
    WA_FINAL-BUKRS = WA_MSEG-BUKRS.
    WA_FINAL-DATE  = WA_MSEG-BUDAT_MKPF .
    WA_FINAL-DAY   = SY-DATUM - WA_MSEG-BUDAT_MKPF .


    CASE WA_FINAL-BWART.
      WHEN '101'.
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND KZBEW = 'B' AND KZZUG = ' '.
      WHEN '262'.
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND KZBEW = 'L'." AND kzzug = ' '.
      WHEN '561'.
        SELECT SINGLE BLDAT INTO WA_FINAL-BLDAT FROM MKPF WHERE MBLNR = WA_FINAL-MBLNR.
          SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART .
            SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART .

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

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR :WA_FINAL,WA_MARA,WA_MARA,LV_TEXT.
    CLEAR:LT_LINES,LS_LINES.
  ENDLOOP.

********So Aging*********************
  CLEAR :ZRATE.

  LOOP AT IT_MSEG_SO INTO WA_MSEG_SO.

    ON CHANGE OF WA_MSEG_SO-MATNR.
      CLEAR: TMP_QTY,ZRATE ,VALUE,STOCK.


      LOOP AT IT_MSKA INTO WA_MSKA WHERE MATNR = WA_MSEG_SO-MATNR.
        TMP_QTY = TMP_QTY + WA_MSKA-KALAB.
        TMP_QTY = TMP_QTY + WA_MSKA-KAINS.
      ENDLOOP.

*      LOOP AT it_mslb INTO wa_mslb WHERE matnr = wa_mseg-matnr.
*        tmp_qty = tmp_qty + wa_mslb-lblab.
*      ENDLOOP.

*      READ TABLE it_ebew INTO wa_ebew WITH KEY matnr = wa_mska-matnr.
*      IF sy-subrc = 0.
*        IF wa_ebew-vprsv = 'V'.
*          zrate = wa_ebew-verpr.
*        ELSEIF wa_ebew-vprsv = 'S'.
*          zrate = wa_ebew-stprs.
*        ENDIF.
*      ENDIF.

      LOOP AT IT_EBEW INTO WA_EBEW WHERE MATNR = WA_MSKA-MATNR.
        VALUE = VALUE + WA_EBEW-SALK3.
        STOCK = STOCK + WA_EBEW-LBKUM.
      ENDLOOP.
*      wa_final-dmbtr = tmp_qty * zrate .
*      IF tmp_qty NE 0.
      ZRATE = VALUE /  STOCK.
*      ENDIF.

    ENDON.

*    LOOP AT it_mska INTO wa_mska WHERE matnr = wa_mseg_so-matnr.
    WA_FINAL-MBLNR = WA_MSEG_SO-MBLNR.
    WA_FINAL-ZEILE = WA_MSEG_SO-ZEILE.
    WA_FINAL-BWART = WA_MSEG_SO-BWART.
    WA_FINAL-MATNR = WA_MSEG_SO-MATNR.
    WA_FINAL-WERKS = WA_MSEG_SO-WERKS.
    WA_FINAL-LGORT = WA_MSEG_SO-LGORT.
    WA_FINAL-LIFNR = WA_MSEG_SO-LIFNR.
*    wa_final-dmbtr = wa_mseg-dmbtr.

    IF WA_MSEG_SO-MENGE > TMP_QTY.

      WA_FINAL-MENGE_SO = TMP_QTY.
      CLEAR TMP_QTY.
    ELSE.
      WA_FINAL-MENGE_SO = WA_MSEG_SO-MENGE.
      TMP_QTY = TMP_QTY - WA_MSEG_SO-MENGE.
    ENDIF .
    WA_FINAL-DMBTR_SO = WA_FINAL-MENGE_SO * ZRATE .
    WA_FINAL-QTY  = WA_MSEG_SO-MENGE.
    WA_FINAL-BUKRS = WA_MSEG_SO-BUKRS.
    WA_FINAL-DATE  = WA_MSEG_SO-BUDAT_MKPF .
    WA_FINAL-DAY   = SY-DATUM - WA_MSEG_SO-BUDAT_MKPF .
*    ENDLOOP.

    CASE WA_FINAL-BWART.
      WHEN '101'.
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND KZBEW = 'B' AND KZZUG = ' '.
      WHEN '262'.
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND KZBEW = 'L'." AND kzzug = ' '.
      WHEN '561'.
        SELECT SINGLE BLDAT INTO WA_FINAL-BLDAT FROM MKPF WHERE MBLNR = WA_FINAL-MBLNR.
          SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART .
      WHEN OTHERS .
        SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'E' AND BWART = WA_FINAL-BWART AND SOBKZ = ' ' AND KZVBR = ' '.
    ENDCASE.




    READ TABLE IT_MARA INTO WA_MARA WITH  KEY MATNR = WA_MSEG_SO-MATNR.
    WA_FINAL-WRKST = WA_MARA-WRKST.

    LV_TEXT = WA_FINAL-MATNR .
    CLEAR:LT_LINES,LS_LINES.
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

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR :WA_FINAL,WA_MARA,WA_MARA,LV_TEXT,VALUE,STOCK.

  ENDLOOP.


  DELETE IT_FINAL WHERE MENGE = 0 AND MENGE_SO = 0.
  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MBLNR = WA_FINAL-MBLNR.
      WA_DOWN-MATNR = WA_FINAL-MATNR.
      WA_DOWN-BWART = WA_FINAL-BWART.
      WA_DOWN-WERKS = WA_FINAL-WERKS.
      WA_DOWN-LGORT = WA_FINAL-LGORT.
      WA_DOWN-QTY = WA_FINAL-QTY.
      WA_DOWN-MENGE = WA_FINAL-MENGE.
      WA_DOWN-MENGE_SO = WA_FINAL-MENGE_SO.
      WA_DOWN-DMBTR = WA_FINAL-DMBTR.
      WA_DOWN-DMBTR_SO = WA_FINAL-DMBTR_SO.
      WA_DOWN-DAY   = WA_FINAL-DAY.
      WA_DOWN-TEXT   = WA_FINAL-TEXT.
      WA_DOWN-WRKST   = WA_FINAL-WRKST.
      WA_DOWN-BTEXT   = WA_FINAL-BTEXT.

      IF WA_FINAL-DATE IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-DATE
          IMPORTING
            OUTPUT = WA_DOWN-DATE.

        CONCATENATE WA_DOWN-DATE+0(2) WA_DOWN-DATE+2(3) WA_DOWN-DATE+5(4)
                        INTO WA_DOWN-DATE SEPARATED BY '-'.

      ENDIF.

      IF WA_FINAL-BLDAT IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BLDAT
          IMPORTING
            OUTPUT = WA_DOWN-BLDAT.

        CONCATENATE WA_DOWN-BLDAT+0(2) WA_DOWN-BLDAT+2(3) WA_DOWN-BLDAT+5(4)
                        INTO WA_DOWN-BLDAT SEPARATED BY '-'.

      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
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
                         '3'   'BWART'           'IT_FINAL'      'Movement Type '              '15' ,
                         '4'   'BTEXT'           'IT_FINAL'      'Mov Type Desc'              '15' ,
                         '5'   'WERKS'           'IT_FINAL'      'Plant '                      '05' ,
                         '6'   'LGORT'           'IT_FINAL'      'Storage Loc '                '15' ,
                         '7'   'QTY'             'IT_FINAL'      'Quantity '                   '15' ,
                         '8'   'MENGE'           'IT_FINAL'      'UR Allocated Quantity '         '15' ,
                         '9'   'MENGE_SO'           'IT_FINAL'   'SO Allocated Quantity '         '15' ,
                        '10'   'DMBTR'           'IT_FINAL'      'UR Amount '                     '15' ,
                        '11'   'DMBTR_SO'           'IT_FINAL'      'SO Amount '                     '15' ,
                        '12'   'DATE'            'IT_FINAL'      'Posting Date '               '15' ,
                        '13'   'DAY'             'IT_FINAL'      'Aging Day '                  '15' ,
                        '14'   'TEXT'            'IT_FINAL'      'Material Description'        '100' ,
                        '15'   'WRKST'           'IT_FINAL'      'SA Code'                    '15' ,
                        '16'   'BLDAT'           'IT_FINAL'      'Document Date'                    '15' .


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
*  BREAK PRIMUSABAP.
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


*  lv_file = 'ZINVAG_DET.TXT'.
  CONCATENATE 'ZSU_INVAG_DET' P_LGORT '.TXT' INTO LV_FILE.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_INVAG_DET REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_976 TYPE string.
DATA lv_crlf_976 TYPE string.
lv_crlf_976 = cl_abap_char_utilities=>cr_lf.
lv_string_976 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_976 lv_crlf_976 wa_csv INTO lv_string_976.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_441 TO lv_fullfile.
TRANSFER lv_string_976 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
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


*  lv_file = 'ZINVAG_DET.TXT'.
  CONCATENATE 'ZSU_INVAG_DET' P_LGORT '.TXT' INTO LV_FILE.

*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_INVAG_DET REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1014 TYPE string.
DATA lv_crlf_1014 TYPE string.
lv_crlf_1014 = cl_abap_char_utilities=>cr_lf.
lv_string_1014 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1014 lv_crlf_1014 wa_csv INTO lv_string_1014.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_441 TO lv_fullfile.
TRANSFER lv_string_1014 TO lv_fullfile.
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
              'Movement Type '
              'Mov Type Desc'
              'Plant '
              'Storage Loc '
              'Quantity '
              'UR Allocated Quantity '
              'SO Allocated Quantity '
              'UR Amount '
              'SO Amount '
              'Posting Date '
              'Aging Day '
              'SA Code'
              'Document Date'
              'Material Description'
              'Refresh Date'
              'Refresh Time'
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
