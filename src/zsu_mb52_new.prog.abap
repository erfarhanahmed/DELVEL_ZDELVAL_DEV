*&---------------------------------------------------------------------*
*& Report ZMATERIAL_STORAGE_BIN
*&---------------------------------------------------------------------*
*&&Report: ZSU_MB52_NEW
*&Transaction: ZSU_MB52
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR:  DEVK912713
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
REPORT ZMATERIAL_STORAGE_BIN.

TABLES:MARD,MARA.

TYPES: BEGIN OF TY_MARA,
         MATNR   TYPE MARA-MATNR,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         BRAND   TYPE MARA-BRAND,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
         WRKST   TYPE MARA-WRKST,
       END OF TY_MARA,

       BEGIN OF TY_MARA_MARD,
         MATNR TYPE MARD-MATNR,
         WERKS TYPE MARD-WERKS,
         LGORT TYPE MARD-LGORT,
         LGPBE TYPE MARD-LGPBE,
         MTART TYPE MARA-MTART,
         MATKL TYPE MARA-MATKL,
       END OF TY_MARA_MARD,

       BEGIN OF TY_MARD,
         MATNR TYPE MARD-MATNR,
         WERKS TYPE MARD-WERKS,
         LGORT TYPE MARD-LGORT,
         LABST TYPE MARD-LABST,
         UMLME TYPE MARD-UMLME,
         INSME TYPE MARD-INSME,
         EINME TYPE MARD-EINME,
         SPEME TYPE MARD-SPEME,
         RETME TYPE MARD-RETME,
         VMLAB TYPE MARD-VMLAB,
         VMUML TYPE MARD-VMUML,
         VMINS TYPE MARD-VMINS,
         VMEIN TYPE MARD-VMEIN,
         VMSPE TYPE MARD-VMSPE,
         VMRET TYPE MARD-VMRET,
       END OF TY_MARD,

       BEGIN OF TY_MAKT,
         MATNR TYPE MAKT-MATNR,
         MAKTX TYPE MAKT-MAKTX,
       END OF TY_MAKT,

       BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         LBKUM TYPE MBEW-LBKUM,
         SALK3 TYPE MBEW-SALK3,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
       END OF TY_MBEW,

       BEGIN OF TY_EBEW,
         MATNR TYPE EBEW-MATNR,
         BWKEY TYPE EBEW-BWKEY,
         VBELN TYPE EBEW-VBELN,
         POSNR TYPE EBEW-POSNR,
         LBKUM TYPE EBEW-LBKUM,
         SALK3 TYPE EBEW-SALK3,
         VPRSV TYPE EBEW-VPRSV,
         VERPR TYPE EBEW-VERPR,
         STPRS TYPE EBEW-STPRS,
       END OF TY_EBEW,
       BEGIN OF TY_MSKU,
         MATNR TYPE MSKU-MATNR,
         WERKS TYPE MSKU-WERKS,
         CHARG TYPE MSKU-CHARG,
         SOBKZ TYPE MSKU-SOBKZ,
         KUNNR TYPE MSKU-KUNNR,
         KULAB TYPE MSKU-KULAB,
       END OF TY_MSKU,


       BEGIN OF TY_MSKA,
         MATNR TYPE MSKA-MATNR,
         WERKS TYPE MSKA-WERKS,
         LGORT TYPE MSKA-LGORT,
         SOBKZ TYPE MSKA-SOBKZ,
         VBELN TYPE MSKA-VBELN,
         POSNR TYPE MSKA-POSNR,
         KALAB TYPE MSKA-KALAB,
         KAINS TYPE MSKA-KAINS,
         KASPE TYPE MSKA-KASPE,
         KAVLA TYPE MSKA-KAVLA,
         KAVIN TYPE MSKA-KAVIN,
         KAVSP TYPE MSKA-KAVSP,
         KAVEI TYPE MSKA-KAVEI,
       END OF TY_MSKA,

       BEGIN OF TY_MSLB,
         MATNR TYPE MSLB-MATNR,
         WERKS TYPE MSLB-WERKS,
         CHARG TYPE MSLB-CHARG,
         SOBKZ TYPE MSLB-SOBKZ,
         LIFNR TYPE MSLB-LIFNR,
         LBLAB TYPE MSLB-LBLAB,
         LBINS TYPE MSLB-LBINS,
         LBVLA TYPE MSLB-LBVLA,
         LBVEI TYPE MSLB-LBVEI,
         LBUML TYPE MSLB-LBUML,
       END OF TY_MSLB,

       BEGIN OF TY_FINAL,
         MATNR    TYPE MARD-MATNR,
         MATTXT   TYPE TEXT255,
         WRKST    TYPE MARA-WRKST,
         BRAND    TYPE MARA-BRAND,
         ZSERIES  TYPE MARA-ZSERIES,
         ZSIZE    TYPE MARA-ZSIZE,
         MOC      TYPE MARA-MOC,
         TYPE     TYPE MARA-TYPE,
         MTART    TYPE MARA-MTART,
         MATKL    TYPE MARA-MATKL,
         WERKS    TYPE MARD-WERKS,
         LABST    TYPE MARD-LABST,
         UMLME    TYPE MARD-UMLME,
         INSME    TYPE MARD-INSME,
         KULAB    TYPE MSKU-KULAB,
         KALAB    TYPE MSKA-KALAB,
         KAINS    TYPE MSKA-KAINS,
         LBLAB    TYPE MSLB-LBLAB,
         SPEME    TYPE MARD-SPEME,
         RETME    TYPE MARD-RETME,
         TOTAL    TYPE MSEG-MENGE,
         MENGE    TYPE MSEG-MENGE,
         REF      TYPE CHAR15,
         SALK3    TYPE EBEW-SALK3,
         LGORT    TYPE MARD-LGORT,          "added by pankaj 21.03.2022
         VBELN    TYPE MSKA-VBELN,
         POSNR    TYPE MSKA-VBELN,
         STOCK_NO TYPE CHAR100,
         LIFNR    TYPE  MSLB-LIFNR,
         LGPBE    TYPE MARD-LGPBE,
         LBKUM    TYPE MBEW-LBKUM,
         VMLAB    TYPE MARD-VMLAB,
         VMUML    TYPE MARD-VMUML,
         VMINS    TYPE MARD-VMINS,
         VMEIN    TYPE MARD-VMEIN,
         VMSPE    TYPE MARD-VMSPE,
         VMRET    TYPE MARD-VMRET,
         PRICE    TYPE MBEW-STPRS, "p DECIMALS 2,"mbew-salk3,    "string,"
         RATE     TYPE F,
         QL_VAL   TYPE MBEW-SALK3,
       END OF TY_FINAL,

       BEGIN OF TY_STR,
         MATNR    TYPE MARD-MATNR,
         MATTXT   TYPE TEXT255,
         MTART    TYPE MARA-MTART,
         MATKL    TYPE MARA-MATKL,
         WERKS    TYPE MARD-WERKS,
         LABST    TYPE CHAR15,
         UMLME    TYPE CHAR15,
         INSME    TYPE CHAR15,
         KULAB    TYPE CHAR15,
         KALAB    TYPE CHAR15,
         SPEME    TYPE CHAR15,
         RETME    TYPE CHAR15,
         TOTAL    TYPE CHAR15,
         MENGE    TYPE CHAR15,
         SALK3    TYPE CHAR15,
         LGORT    TYPE MARD-LGORT,          "added by pankaj 21.03.2022
         KAINS    TYPE CHAR15,
         LBLAB    TYPE CHAR15,
         VBELN    TYPE CHAR10,
         STOCK_NO TYPE CHAR100,
         LIFNR    TYPE CHAR15,
         LGPBE    TYPE CHAR15,
         LBKUM    TYPE CHAR15,
         VMLAB    TYPE CHAR15,
         VMUML    TYPE CHAR15,
         VMINS    TYPE CHAR15,
         VMEIN    TYPE CHAR15,
         VMSPE    TYPE CHAR15,
         VMRET    TYPE CHAR15,
         PRICE    TYPE CHAR15,
         QL_VAL   TYPE CHAR15,
         REF      TYPE CHAR15,
         REF_TIME TYPE CHAR15,
       END OF TY_STR.


DATA:IT_MARA      TYPE TABLE OF TY_MARA,
     WA_MARA      TYPE          TY_MARA,

     IT_MAKT      TYPE TABLE OF TY_MAKT,
     WA_MAKT      TYPE          TY_MAKT,

     IT_MARD      TYPE TABLE OF TY_MARD,
     WA_MARD      TYPE          TY_MARD,

     IT_MARA_MARD TYPE TABLE OF TY_MARA_MARD,
     WA_MARA_MARD TYPE          TY_MARA_MARD,

     IT_MBEW      TYPE TABLE OF TY_MBEW,
     WA_MBEW      TYPE          TY_MBEW,

     IT_EBEW      TYPE TABLE OF TY_EBEW,
     WA_EBEW      TYPE          TY_EBEW,

     IT_MSKA      TYPE TABLE OF TY_MSKA,
     WA_MSKA      TYPE          TY_MSKA,

     IT_MSKU      TYPE TABLE OF TY_MSKU,
     WA_MSKU      TYPE          TY_MSKU,

     IT_MSLB      TYPE TABLE OF TY_MSLB,
     WA_MSLB      TYPE          TY_MSLB,

     IT_FINAL     TYPE TABLE OF TY_FINAL,
     WA_FINAL     TYPE          TY_FINAL,

     LT_FINAL     TYPE TABLE OF TY_STR,
     LS_FINAL     TYPE          TY_STR.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.

DATA : LV_VAR1 TYPE STRING VALUE 'ZMB52_SU01',
       LV_VAR2 TYPE STRING VALUE 'TPI_SUFG'.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MARD-MATNR,
                S_LGORT FOR MARD-LGORT,
                S_LGPBE FOR MARD-LGPBE,
                S_MTART FOR MARA-MTART.
PARAMETERS :    p_werks TYPE MARD-WERKS OBLIGATORY  DEFAULT 'SU01'  MODIF ID BU.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'."Saudi'.  "'/Delval/Saudi'."Saudi'.

SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.


AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM DET_FCAT.
  PERFORM GET_DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT A~MATNR
         A~WERKS
         A~LGORT
         A~LGPBE
         B~MTART
         B~MATKL
         INTO TABLE IT_MARA_MARD FROM MARD AS A
         INNER JOIN MARA AS B ON B~MATNR = A~MATNR
         WHERE A~MATNR IN S_MATNR
          AND  A~LGORT IN S_LGORT
          AND  A~LGPBE IN S_LGPBE
          AND  A~WERKS = P_WERKS
          AND  B~MTART IN S_MTART
          .



" (Added by Nilay B. on 28.11.2023)
* condition  for removing zeros for  LABST (Unrestricted-Use Stock),INSME (Stock in Quality Inspection) UMLME (Stock in transfer),INSME (Stock in Quality Inspection),
*  SPEME (Blocked Stock) , RETME (Blocked Stock Returns), VMLAB (Valuated unrestricted-use stock), VMUML (Stock in Transfer in Previous Period)
*  VMINS (Stock in Quality Inspection in Previous Period),VMEIN (Restricted-Use Stock in Previous Period),
*VMSPE (Blocked stock of previous period), VMRET (Blocked Stock Returns in Previous Period ).

  IF  IT_MARA_MARD IS NOT INITIAL .
    SELECT MATNR
           WERKS
           LGORT
           LABST
           UMLME
           INSME
           EINME
           SPEME
           RETME
           VMLAB
           VMUML
           VMINS
           VMEIN
           VMSPE
           VMRET
           FROM MARD INTO TABLE IT_MARD
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
           AND   LGORT IN S_LGORT
           AND   WERKS = IT_MARA_MARD-WERKS
           AND   ( LABST NE 0
           OR    UMLME NE 0
           OR    INSME NE 0
           OR    EINME NE 0
           OR    SPEME NE 0
           OR    RETME NE 0
           OR   VMLAB NE 0
           OR   VMUML NE 0
           OR   VMINS NE 0
           OR   VMEIN NE 0
           OR   VMSPE NE 0
           OR   VMRET NE 0 ) .
"Ended code by Nilay B. On 28.11.2023)



" (Added by Nilay B. on 28.11.2023
* condition  for removing zeros for KALAB (SO Allocated Stock), KAINS (SO  Quality Inspection Stock), KASPE (Blocked Stock),
*KAVLA (Valuated unrestricted-use stock in previous period), KAVIN (Stock in Quality Inspection in Previous Period,
*KAVSP (Blocked stock of previous period)   KAVEI (Restricted-Use Stock in Previous Period).

    SELECT MATNR
           WERKS
           LGORT
           SOBKZ
           VBELN
           POSNR
           KALAB
           KAINS
           KASPE
           KAVLA
           KAVIN
           KAVSP
           KAVEI FROM MSKA INTO TABLE IT_MSKA
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
           AND   LGORT IN S_LGORT
           AND   WERKS = IT_MARA_MARD-WERKS
           AND   ( KALAB NE 0
           OR   KAINS NE 0
           OR   KASPE NE 0
           OR   KAVLA NE 0
           OR   KAVIN NE 0
           OR   KAVSP NE 0
           OR   KAVEI NE 0 ).
*           AND   SOBKZ = 'E'.

"Ended code by Nilay B. On 28.11.2023)


" (Added by Nilay B. on 28.11.2023
* condition  for removing zeros for KULAB (Consignment Stock)

    SELECT    MATNR
              WERKS
              CHARG
              SOBKZ
              KUNNR
              KULAB FROM MSKU INTO TABLE IT_MSKU
              FOR ALL ENTRIES IN IT_MARA_MARD
              WHERE MATNR = IT_MARA_MARD-MATNR
              AND   WERKS = IT_MARA_MARD-WERKS.
"Ended code by Nilay B. On 28.11.2023)


" (Added by Nilay B. on 28.11.2023
* condition  for removing zeros for  LBLAB (Stock To Vendor , LBINS (Stock in Quality Inspection) ,
* LBVLA (Valuated unrestricted-use stock in previous period), LBVEI (Restricted-Use Stock in Previous Period),
*LBUML (Stock in Transfer for Subcontracting (Plant to Plant).

    SELECT MATNR
           WERKS
           CHARG
           SOBKZ
           LIFNR
           LBLAB
           LBINS
           LBVLA
           LBVEI
           LBUML FROM MSLB INTO TABLE IT_MSLB
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
           AND   WERKS = IT_MARA_MARD-WERKS
           AND  ( LBLAB  NE 0
           OR LBINS  NE 0
           OR LBVLA NE 0
           OR LBVEI NE 0
           OR LBUML NE 0 ).
"Ended code by Nilay B. On 28.11.2023)

    SELECT MATNR
           MAKTX FROM MAKT INTO TABLE IT_MAKT
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR.

" (Added by Nilay B. on 28.11.2023
* condition  for removing zeros for LBKUM ( Total Valuated Stock), SALK3 (Value of Total Valuated Stock), VERPR (Price))

    SELECT MATNR
           BWKEY
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS FROM MBEW INTO TABLE IT_MBEW
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
           AND   BWKEY = IT_MARA_MARD-WERKS
           AND   ( LBKUM NE 0
           OR   SALK3  NE 0
           OR   VERPR  NE 0 ).
  ENDIF.


" (Added by Nilay B. on 28.11.2023
* condition  for removing zeros for SALK3 (Value of Total Valuated Stock), VERPR (Price)
  IF IT_MSKA IS NOT INITIAL.
    SELECT MATNR
           BWKEY
           VBELN
           POSNR
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS FROM EBEW INTO TABLE IT_EBEW
           FOR ALL ENTRIES IN IT_MSKA
           WHERE MATNR = IT_MSKA-MATNR
           AND   BWKEY = IT_MSKA-WERKS
           AND   VBELN = IT_MSKA-VBELN
           AND   POSNR = IT_MSKA-POSNR
           AND   ( LBKUM NE 0
           OR    SALK3 NE 0
           OR    VERPR NE 0  ).

  ENDIF.



  SELECT MATNR
             ZSERIES
             ZSIZE
             BRAND
             MOC
             TYPE
             WRKST    FROM MARA INTO TABLE IT_MARA
             FOR ALL ENTRIES IN IT_MARA_MARD
             WHERE MATNR = IT_MARA_MARD-MATNR.

**************************************Logic for Store Stock********************************
  LOOP AT IT_MARA_MARD INTO WA_MARA_MARD.
    WA_FINAL-MATNR = WA_MARA_MARD-MATNR.
    WA_FINAL-WERKS = WA_MARA_MARD-WERKS.
    WA_FINAL-LGORT = WA_MARA_MARD-LGORT.
    WA_FINAL-LGPBE = WA_MARA_MARD-LGPBE.
    WA_FINAL-MTART = WA_MARA_MARD-MTART.
    WA_FINAL-MATKL = WA_MARA_MARD-MATKL.

    READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_MARA_MARD-MATNR.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MARA_MARD-MATNR BWKEY = WA_MARA_MARD-WERKS..
    IF  SY-SUBRC = 0.
      WA_FINAL-LBKUM = WA_MBEW-LBKUM.
      WA_FINAL-SALK3 = WA_MBEW-SALK3.                      "commented by Ganga 17.10.2018

      IF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-PRICE = WA_MBEW-STPRS.
      ELSEIF WA_MBEW-VPRSV = 'V'..
        WA_FINAL-PRICE = WA_MBEW-VERPR.

      ENDIF.

    ENDIF.
     LOOP AT IT_MSKU INTO WA_MSKU WHERE MATNR = WA_MARA_MARD-MATNR AND WERKS = WA_MARA_MARD-WERKS.
    IF SY-SUBRC = 0.
       WA_FINAL-KULAB = WA_FINAL-KULAB + WA_MSKU-KULAB.
    ENDIF.
    ENDLOOP.
    READ TABLE IT_MARD INTO WA_MARD WITH KEY MATNR = WA_MARA_MARD-MATNR LGORT = WA_MARA_MARD-LGORT WERKS = WA_MARA_MARD-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-LABST = WA_MARD-LABST.
      WA_FINAL-UMLME = WA_MARD-UMLME.
      WA_FINAL-INSME = WA_MARD-INSME.
*      WA_FINAL-EINME = WA_MARD-EINME.
      WA_FINAL-SPEME = WA_MARD-SPEME.
      WA_FINAL-RETME = WA_MARD-RETME.
      WA_FINAL-VMLAB = WA_MARD-VMLAB.
      WA_FINAL-VMUML = WA_MARD-VMUML.
      WA_FINAL-VMINS = WA_MARD-VMINS.
      WA_FINAL-VMEIN = WA_MARD-VMEIN.
      WA_FINAL-VMSPE = WA_MARD-VMSPE.
      WA_FINAL-VMRET = WA_MARD-VMRET.


    ENDIF.
    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARA_MARD-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-MATNR       = WA_MARA-MATNR.
      WA_FINAL-ZSERIES     = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE       = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND       = WA_MARA-BRAND   .
      WA_FINAL-MOC         = WA_MARA-MOC     .
      WA_FINAL-TYPE        = WA_MARA-TYPE    .
      WA_FINAL-WRKST       = WA_MARA-WRKST   .
    ENDIF.
    IF WA_FINAL-LBKUM NE 0.
      WA_FINAL-RATE  = WA_FINAL-SALK3 / WA_FINAL-LBKUM.
*      wa_final-un_val = wa_final-labst * wa_final-rate.
*      wa_final-salk3  =  wa_final-labst * wa_final-rate.
    ELSE.
      WA_FINAL-RATE  = WA_FINAL-PRICE.      "wa_final-salk3 / wa_final-lbkum.
*      wa_final-un_val = wa_final-labst * wa_final-rate.
*      wa_final-salk3  =  wa_final-labst * wa_final-rate.
    ENDIF.

    IF WA_FINAL-INSME NE 0.
      WA_FINAL-QL_VAL = WA_FINAL-INSME * WA_FINAL-RATE.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT.
    REFRESH LV_LINES.

    LV_NAME = WA_FINAL-MATNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LV_LINES
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-MATTXT WA_LINES-TDLINE INTO WA_FINAL-MATTXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-MATTXT.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.

    CLEAR: WA_FINAL,LS_FINAL.
  ENDLOOP.
***************************************************Logic for Sales Order Stock*****************
  LOOP AT IT_MSKA INTO WA_MSKA.
    WA_FINAL-MATNR = WA_MSKA-MATNR.
    WA_FINAL-WERKS = WA_MSKA-WERKS.
    WA_FINAL-LGORT = WA_MSKA-LGORT.
    WA_FINAL-VBELN = WA_MSKA-VBELN.
    WA_FINAL-POSNR = WA_MSKA-POSNR.
*    WA_FINAL-LABST = WA_MSKA-KALAB.
    WA_FINAL-KALAB = WA_MSKA-KALAB.
    WA_FINAL-INSME = WA_MSKA-KAINS.
    WA_FINAL-SPEME = WA_MSKA-KASPE.
    WA_FINAL-VMLAB = WA_MSKA-KAVLA.
    WA_FINAL-VMINS = WA_MSKA-KAVIN.
    WA_FINAL-VMEIN = WA_MSKA-KAVEI.
    WA_FINAL-VMSPE = WA_MSKA-KAVSP.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-VBELN
      IMPORTING
        OUTPUT = WA_FINAL-VBELN.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-POSNR
      IMPORTING
        OUTPUT = WA_FINAL-POSNR.


    IF WA_FINAL-VBELN IS NOT INITIAL.
      CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR  INTO WA_FINAL-STOCK_NO SEPARATED BY '/'.
    ENDIF.
    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MSKA-MATNR WERKS = WA_MSKA-WERKS LGORT = WA_MSKA-LGORT.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART..
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
    ENDIF.
    SELECT SINGLE MTART INTO WA_FINAL-MTART FROM MARA WHERE MATNR = WA_MSKA-MATNR.
    READ TABLE IT_EBEW INTO WA_EBEW WITH KEY MATNR = WA_MSKA-MATNR BWKEY = WA_MSKA-WERKS VBELN = WA_MSKA-VBELN POSNR = WA_MSKA-POSNR.
    IF  SY-SUBRC = 0.
      WA_FINAL-LBKUM = WA_EBEW-LBKUM.
      WA_FINAL-SALK3 = WA_EBEW-SALK3.

      IF WA_EBEW-VPRSV = 'S'.
        WA_FINAL-PRICE = WA_EBEW-STPRS.
      ELSEIF WA_EBEW-VPRSV = 'V'..
        WA_FINAL-PRICE = WA_EBEW-VERPR.

      ENDIF.

    ENDIF.
    IF WA_FINAL-LBKUM NE 0.
      WA_FINAL-RATE  = WA_FINAL-SALK3 / WA_FINAL-LBKUM.
      WA_FINAL-SALK3  =  WA_FINAL-LABST * WA_FINAL-RATE .
    ELSE.
      WA_FINAL-RATE  = WA_FINAL-PRICE.      "wa_final-salk3 / wa_final-lbkum.
      WA_FINAL-SALK3  =  WA_FINAL-LABST * WA_FINAL-RATE.

    ENDIF.
*
    IF WA_FINAL-INSME NE 0.
      WA_FINAL-QL_VAL = WA_FINAL-INSME * WA_FINAL-RATE.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LV_LINES
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-MATTXT WA_LINES-TDLINE INTO WA_FINAL-MATTXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-MATTXT.
    ENDIF.


    APPEND WA_FINAL TO IT_FINAL.
    CLEAR: WA_FINAL,LS_FINAL.
  ENDLOOP.


*****************************************Logic for Stock At Vendor*************************************
  LOOP AT IT_MSLB INTO WA_MSLB.

    WA_FINAL-MATNR = WA_MSLB-MATNR.
    WA_FINAL-WERKS = WA_MSLB-WERKS.
    WA_FINAL-LABST = WA_MSLB-LBLAB.
    WA_FINAL-LBLAB = WA_MSLB-LBLAB.
    WA_FINAL-UMLME = WA_MSLB-LBUML.
    WA_FINAL-INSME = WA_MSLB-LBINS.
    WA_FINAL-VMLAB = WA_MSLB-LBVLA.
    WA_FINAL-VMEIN = WA_MSLB-LBVEI.
    WA_FINAL-LIFNR = WA_MSLB-LIFNR.

    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MSLB-MATNR WERKS = WA_MSLB-WERKS .
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART..
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
    ENDIF.


    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MSLB-MATNR BWKEY = WA_MSLB-WERKS.
    IF  SY-SUBRC = 0.
      WA_FINAL-LBKUM = WA_MBEW-LBKUM.
      WA_FINAL-SALK3 = WA_MBEW-SALK3.

      IF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-PRICE = WA_MBEW-STPRS.
      ELSEIF WA_MBEW-VPRSV = 'V'..
        WA_FINAL-PRICE = WA_MBEW-VERPR.

      ENDIF.

    ENDIF.
*    READ TABLE IT_MSKU INTO WA_MSKU WITH KEY MATNR = WA_MARA_MARD-MATNR  WERKS = WA_MARA_MARD-WERKS.
*    IF SY-SUBRC = 0.
*       WA_FINAL-KULAB = WA_FINAL-KULAB + WA_MSKU-KULAB.
*    ENDIF.

    IF WA_FINAL-LBKUM NE 0.
      WA_FINAL-RATE  = WA_FINAL-SALK3 / WA_FINAL-LBKUM.
      WA_FINAL-SALK3  =  WA_FINAL-LABST * WA_FINAL-RATE.
    ELSE.
      WA_FINAL-RATE  = WA_FINAL-PRICE.      "wa_final-salk3 / wa_final-lbkum.
      WA_FINAL-SALK3  =  WA_FINAL-LABST * WA_FINAL-RATE.
    ENDIF.

    IF WA_FINAL-INSME NE 0.
      WA_FINAL-QL_VAL = WA_FINAL-INSME * WA_FINAL-RATE.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LV_LINES
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-MATTXT WA_LINES-TDLINE INTO WA_FINAL-MATTXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-MATTXT.
    ENDIF.


    APPEND WA_FINAL TO IT_FINAL.
    CLEAR: WA_FINAL,LS_FINAL.
  ENDLOOP.


   LOOP AT  IT_FINAL INTO WA_FINAL.
   WA_FINAL-TOTAL = WA_FINAL-LABST + WA_FINAL-INSME + + WA_FINAL-KALAB +  WA_FINAL-KAINS .

   MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING TOTAL.

ENDLOOP.


     DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING ALL FIELDS .





*********************************Downlaod File****************************

  LOOP AT IT_FINAL INTO WA_FINAL.


    LS_FINAL-MATNR = WA_FINAL-MATNR.
    LS_FINAL-MATTXT = WA_FINAL-MATTXT.
    LS_FINAL-MTART = WA_FINAL-MTART.
    LS_FINAL-MATKL = WA_FINAL-MATKL.
    LS_FINAL-WERKS = WA_FINAL-WERKS.
    LS_FINAL-LABST = WA_FINAL-LABST.
    LS_FINAL-UMLME = WA_FINAL-UMLME.
    LS_FINAL-INSME = WA_FINAL-INSME.
    LS_FINAL-KULAB = WA_FINAL-KULAB.
    LS_FINAL-KALAB = WA_FINAL-KALAB.
    LS_FINAL-SPEME = WA_FINAL-SPEME.
    LS_FINAL-RETME = WA_FINAL-RETME.
    LS_FINAL-TOTAL = WA_FINAL-TOTAL.
    LS_FINAL-MENGE = WA_FINAL-MENGE.
    LS_FINAL-SALK3 = WA_FINAL-SALK3.
    LS_FINAL-LGORT = WA_FINAL-LGORT.
    LS_FINAL-KAINS = WA_FINAL-KAINS.
    LS_FINAL-LBLAB = WA_FINAL-LBLAB.
    LS_FINAL-VBELN = WA_FINAL-VBELN.
    LS_FINAL-STOCK_NO = WA_FINAL-STOCK_NO.
    LS_FINAL-LIFNR = WA_FINAL-LIFNR.
    LS_FINAL-LGPBE = WA_FINAL-LGPBE.
    LS_FINAL-LBKUM = WA_FINAL-LBKUM.
    LS_FINAL-VMLAB = WA_FINAL-VMLAB.
    LS_FINAL-VMUML = WA_FINAL-VMUML.
    LS_FINAL-VMINS = WA_FINAL-VMINS.
    LS_FINAL-VMEIN = WA_FINAL-VMEIN.
    LS_FINAL-VMSPE = WA_FINAL-VMSPE.
    LS_FINAL-VMRET = WA_FINAL-VMRET.
    LS_FINAL-PRICE = WA_FINAL-PRICE.
    LS_FINAL-QL_VAL = WA_FINAL-QL_VAL.


    LS_FINAL-REF = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-REF
      IMPORTING
        OUTPUT = LS_FINAL-REF.

    CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                    INTO LS_FINAL-REF SEPARATED BY '-'.


    LS_FINAL-REF_TIME = SY-UZEIT.
    CONCATENATE LS_FINAL-REF_TIME+0(2) ':' LS_FINAL-REF_TIME+2(2)  INTO LS_FINAL-REF_TIME.


    APPEND LS_FINAL TO LT_FINAL.
    CLEAR LS_FINAL.
  ENDLOOP.
  SORT IT_FINAL BY MATNR.
  SORT LT_FINAL BY MATNR.



*  BREAK primus.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DET_FCAT .
  PERFORM FCAT USING : "mara table.
                          '1'  'MATNR'         'IT_FINAL'  'Material.No.'                                     '18' ,
                         '2'  'MATTXT'        'IT_FINAL'  'Material Desc'                                    '18',
*                         '3'  'WRKST'         'IT_FINAL'  'Old Materail Code'                                         '18' ,
*                         '4'  'BRAND  '       'IT_FINAL'  'Brand'                                            '10',
*                         '5'  'ZSERIES'       'IT_FINAL'  'Series'                                           '10',
*                         '6'  'ZSIZE  '       'IT_FINAL'  'Size'                                             '10',
*                         '7'  'MOC    '       'IT_FINAL'  'MOC'                                              '10',
*                         '8'  'TYPE   '       'IT_FINAL'  'Type'                                             '10',
                         '9'  'MTART'         'IT_FINAL'  'Material Type'                                    '18',
                        '10'  'MATKL'         'IT_FINAL'  'Material Group'                                   '18',
                        '11'  'WERKS'         'IT_FINAL'  'Plant'                                            '10',
                        '12'  'LABST'         'IT_FINAL'  'Unrestricted-Use Stock'                           '18',
                       '13'  'UMLME'         'IT_FINAL'  'Stock in transfer '                               '18',
                        '14'  'INSME'         'IT_FINAL'  'Stock in Quality Inspection'                      '18',
                        '15'  'KULAB'         'IT_FINAL'  'Consignment Stock'                                '18',
                        '16'  'KALAB'         'IT_FINAL'  'SO Allocated Stock'                               '18',
                        '17'  'SPEME'         'IT_FINAL'  'Blocked Stock'                                   '18',
                        '18'  'RETME'         'IT_FINAL'  'Blocked Stock Returns'                           '18',
                        '19'  'TOTAL'         'IT_FINAL'  'Total Stock '                                  '18',
                        '20'  'MENGE'         'IT_FINAL'  'In Transit Block'                                      '15',
                        '21'  'SALK3'         'IT_FINAL'  'VALUE OF TOTAL VALUATED STOCK'                     '20',
                        '23'  'LGORT'         'IT_FINAL'  'Storage Location'                                      '15',
                        '24'  'KAINS'         'IT_FINAL'  'SO  Quality Inspection Stock'                                      '15',
                        '25'  'LBLAB'         'IT_FINAL'  'Stock To Vendor'                                   '15',
                        '26'  'STOCK_NO'      'IT_FINAL'  'Special stock number'                            '20',
                        '27'  'VBELN'         'IT_FINAL'  'Sales Document'                                  '15',
                        '28'  'LIFNR'         'IT_FINAL'  'Subcon Vendor'                                   '15',
                        '29'  'LGPBE'         'IT_FINAL'  'Storage Bin'                                     '18',
                       '30'  'LBKUM'         'IT_FINAL'  'Total Valuated Stock'                            '18',
                       '31'  'VMLAB'         'IT_FINAL'  'Valuated unrestricted-use stock'                 '18',
                       '32'  'VMUML'         'IT_FINAL'  'Stock in Transfer in Previous Period'            '18',
                       '33'  'VMINS'         'IT_FINAL'  'Stock in Quality Inspection in Previous Period'  '18',
                       '34' 'VMEIN'         'IT_FINAL'  'Restricted-Use Stock in Previous Period'         '18',
                       '35'  'VMSPE'         'IT_FINAL'  'Blocked stock of previous period'                '18',
                       '36'  'VMRET'         'IT_FINAL'  'Blocked Stock Returns in Previous Period'        '18',
                       '37'  'PRICE'         'IT_FINAL'  'Price'                                           '18',
                       '38'  'QL_VAL'        'IT_FINAL'  'Value Of Quality Stock'                          '18'.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      I_CALLBACK_PROGRAM     = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      I_CALLBACK_TOP_OF_PAGE = 'TOP-OF-PAGE '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = 'TOP-OF-PAGE '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
*     IS_LAYOUT              =
      IT_FIELDCAT            = IT_FCAT
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = ' '
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      T_OUTTAB               = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.

ENDFORM.
FORM TOP-OF-PAGE.
*ALV HEADER DECLARATIONS
  DATA: LT_HEADER     TYPE SLIS_T_LISTHEADER,
        LS_HEADER     TYPE SLIS_LISTHEADER,
        LT_LINE       LIKE LS_HEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

* TITLE
  LS_HEADER-TYP  = 'H'.
  LS_HEADER-INFO = 'Saudi MB52 Report New'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

* DATE
  LS_HEADER-TYP  = 'S'.
  LS_HEADER-KEY  = 'RUN DATE :'.
  CONCATENATE LS_HEADER-INFO SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM(4) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER.

*TIME
  LS_HEADER-TYP  = 'S'.
  LS_HEADER-KEY  = 'RUN TIME :'.
  CONCATENATE LS_HEADER-INFO SY-TIMLO(2) '.' SY-TIMLO+2(2) '.' SY-TIMLO+4(2) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.
  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' LD_LINESC
     INTO LT_LINE SEPARATED BY SPACE.


  LS_HEADER-TYP  = 'A'.
  LS_HEADER-INFO = LT_LINE.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER, LT_LINE.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_HEADER.
ENDFORM.                    " TOP-OF-PAGE
*&---------------------------------------------------------------------*

*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0542   text
*      -->P_0543   text
*      -->P_0544   text
*      -->P_0545   text
*      -->P_0546   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*  wa_fcat-key       = .
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
      I_TAB_SAP_DATA       = LT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

  IF P_WERKS = 'SU01' AND SY-SLSET = LV_VAR1.
    LV_FILE = 'ZMB52_SU01.txt'.
*  ELSEIF s_lgort IN 'PL01' AND sy-slset = lv_var2.
**    lv_file = 'ZMB52_FGTPI.txt'.
*  ENDIF.

*  IF p_werks = 'PL01'.
*    lv_file = 'ZMB52_PL01.TXT'.
*  ELSEIF p_werks = 'US01'.
*    lv_file = 'ZMB52_US01.TXT'.
*  ELSEIF p_werks = 'US02'.
*    lv_file = 'ZMB52_US02.TXT'.
*  ENDIF.
*    CONCATENATE P_FOLDER '\' LV_FILE
    CONCATENATE P_FOLDER '/' LV_FILE
      INTO LV_FULLFILE.

    WRITE: / 'ZSU_MB52_NEW REPORT started on', SY-DATUM, 'at', SY-UZEIT.
    OPEN DATASET LV_FULLFILE
      FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
    IF SY-SUBRC = 0.
DATA lv_string_1113 TYPE string.
DATA lv_crlf_1113 TYPE string.
lv_crlf_1113 = cl_abap_char_utilities=>cr_lf.
lv_string_1113 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1113 lv_crlf_1113 wa_csv INTO lv_string_1113.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1113 TO lv_fullfile.
*TRANSFER lv_string_1113 TO lv_fullfile.
      CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
      MESSAGE LV_MSG TYPE 'S'.
    ENDIF.
  ELSE.
    CONCATENATE 'ZSU_MB52' S_LGORT '.TXT' INTO LV_FILE.    " ADDED bY nILAY b. o 07.04.2023

*    CONCATENATE P_FOLDER '\' LV_FILE
    CONCATENATE P_FOLDER '/' LV_FILE
      INTO LV_FULLFILE.

    WRITE: / 'ZSU_MB52_NEW REPORT started on', SY-DATUM, 'at', SY-UZEIT.
    OPEN DATASET LV_FULLFILE
      FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
    IF SY-SUBRC = 0.
DATA lv_string_1128 TYPE string.
DATA lv_crlf_1128 TYPE string.
lv_crlf_1128 = cl_abap_char_utilities=>cr_lf.
lv_string_1128 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1128 lv_crlf_1128 wa_csv INTO lv_string_1128.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_898 TO lv_fullfile.
TRANSFER lv_string_1128 TO lv_fullfile.
      CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
      MESSAGE LV_MSG TYPE 'S'.
    ENDIF.
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
  CONCATENATE  'Material.No.'
               'Material Desc'
               'Material Type'
               'Material Group'
               'Plant'
               'Unrestricted-Use Stock'
               'Stock in transfer '
               'Stock in Quality Inspection'
               'Consignment Stock'
               'SO Allocated Stock'
               'Blocked Stock'
               'Blocked Stock Returns'
               'Total Stock '
               'In Transit Block'
               'VALUE OF TOTAL VALUATED STOCK'
               'Storage Location'
               'SO  Quality Inspection Stock'
               'Stock To Vendor'
               'Special stock number'
               'Sales Document'
               'Subcon Vendor'
               'Storage Bin'
               'Total Valuated Stock'
               'Valuated unrestricted-use stock'
               'Stock in Transfer in Previous Period'
               'Stock in Quality Inspection in Previous Period'
               'Restricted-Use Stock in Previous Period'
               'Blocked stock of previous period'
               'Blocked Stock Returns in Previous Period'
               'Price'
               'Value Of Quality Stock'
               'Refresh File Date'
               'Refresh Time'
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
