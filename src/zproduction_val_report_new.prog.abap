*&---------------------------------------------------------------------*
*& Report ZPRODUCTION_VAL_REPORT_NEw
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*Production Valuation Report (Confirmation)
*Report for when production order is confirmed that production orders displayed in report
*Internal production order is not displayed in that report
*&Transaction - ZPRD_NEW
*&Report Name - ZPRODUCTION_VAL_REPORT_NEW
*&Functional Cosultant: Shahid Attar
*&Technical Consultant: Jyoti MAhajan
*&TR: 1. DEVK915345       PRIMUSABAP   PRIMUS:INDIA:101690:ZPRD_NEW:CONFIRMATION PRO ORD WISE
*     2. DEVK915367       PRIMUSABAP   PRIMUS:INDIA:101690:ZPRD_NEW:ADD IN SO PRODUCTION ORDER
*     3. DEVK915345       PRIMUSABAP   PRIMUS:INDIA:101690:ZPRD_NEW:CONFIRMATION PRO ORD WISE
*     4.  DEVK915367       PRIMUSABAP   PRIMUS:INDIA:101690:ZPRD_NEW:ADD IN SO PRODUCTION ORDER
*&Date: 1. 12/12/2024
*&Owner: DelVal Flow Controls
REPORT ZPRODUCTION_VAL_REPORT_NEW.

TYPE-POOLS:SLIS,
           OLE2,
           AUFK.

*******Temp Variable
DATA:
  TMP_BUDAT TYPE MSEG-BUDAT_MKPF,
  TMP_KDAUF TYPE MSEG-KDAUF,
  TMP_MAT   TYPE MSEG-MATNR,
  TMP_DAUAT TYPE AFPO-DAUAT,
  TMP_LGORT TYPE MSEG-LGORT.

*************************structure for mseg table
TYPES:
  BEGIN OF T_MAT_DOC,
    MBLNR      TYPE MSEG-MBLNR,
    MJAHR      TYPE MSEG-MJAHR,
    ZEILE      TYPE MSEG-ZEILE,
    BWART      TYPE MSEG-BWART,
    MATNR      TYPE MSEG-MATNR,
    WERKS      TYPE MSEG-WERKS,
    LGORT      TYPE MSEG-LGORT,
    KUNNR      TYPE MSEG-KUNNR,
    KDAUF      TYPE MSEG-KDAUF,
    KDPOS      TYPE MSEG-KDPOS,
    WAERS      TYPE MSEG-WAERS,
    MENGE      TYPE MSEG-MENGE,
    AUFNR      TYPE MSEG-AUFNR,
    BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
    MAT_KDAUF  TYPE MSEG-MAT_KDAUF,
    MAT_KDPOS  TYPE MSEG-MAT_KDPOS,

  END OF T_MAT_DOC,
  TT_MAT_DOC TYPE STANDARD TABLE OF T_MAT_DOC.

******************internal table for mseg for movement type 261
DATA: IT_MSEG_261 TYPE TABLE OF T_MAT_DOC,
      WA_MSEG_261 TYPE  T_MAT_DOC.

TYPES : BEGIN OF TY_COVP,
          KOKRS  TYPE COVP-KOKRS,
          BELNR  TYPE COVP-BELNR,
          BUZEI  TYPE COVP-BUZEI,
          WTGBTR TYPE COVP-WTGBTR,
          OBJNR  TYPE COVP-OBJNR,
          BEKNZ  TYPE COVP-BEKNZ,
          REFBN  TYPE COVP-REFBN,
        END OF TY_COVP.

******************internal table for covp
DATA: IT_COVP TYPE TABLE OF TY_COVP,
      WA_COVP TYPE  TY_COVP.

DATA: IT_COVP1 TYPE TABLE OF TY_COVP,
      WA_COVP1 TYPE  TY_COVP.



*****************************structure for aufm table
TYPES: BEGIN OF TY_AUFM,
         MBLNR TYPE AUFM-MBLNR,
         MJAHR TYPE AUFM-MJAHR,
         ZEILE TYPE AUFM-ZEILE,
         BWART TYPE AUFM-BWART,
         MATNR TYPE AUFM-MATNR,
         WERKS TYPE AUFM-WERKS,
         AUFNR TYPE AUFM-AUFNR,
         BUDAT TYPE AUFM-BUDAT,
         MENGE TYPE AUFM-MENGE,
         SHKZG TYPE AUFM-SHKZG,
         LGORT TYPE AUFM-LGORT,
       END OF TY_AUFM,
**************************************table type for aufm
       TT_AUFM TYPE STANDARD TABLE OF TY_AUFM.

**************************structure for vbkd table
TYPES:
  BEGIN OF T_VBKD,
    VBELN TYPE VBKD-VBELN,
    POSNR TYPE VBKD-POSNR,
    KURSK TYPE VBKD-KURSK,
    BSTKD TYPE VBKD-BSTKD,  "ADDED BY JYOTI ON 27.03.2025
  END OF T_VBKD,
*****************************table type for vbkd
  TT_VBKD TYPE STANDARD TABLE OF T_VBKD.

******************structure for coep table
TYPES:
  BEGIN OF T_COEP,
    KOKRS  TYPE COEP-KOKRS,
    BELNR  TYPE COEP-BELNR,
    BUZEI  TYPE COEP-BUZEI,
    WTGBTR TYPE COEP-WTGBTR,
    OBJNR  TYPE COEP-OBJNR,
    BEKNZ  TYPE COEP-BEKNZ,
  END OF T_COEP,
*****************************table type for coep
  TT_COEP TYPE STANDARD TABLE OF T_COEP.

*******************structure type for afpo table
TYPES:
  BEGIN OF T_ORDER_ITEM,
    AUFNR TYPE AFPO-AUFNR,
    POSNR TYPE AFPO-POSNR,
    DAUAT TYPE AFPO-DAUAT,
    PSMNG TYPE AFPO-PSMNG,
    PWERK TYPE AFPO-PWERK,
    LGORT TYPE AFPO-LGORT,
    OBJNR TYPE COEP-OBJNR,
  END OF T_ORDER_ITEM,
****************************table type for afpo
  TT_ORDER_ITEM TYPE STANDARD TABLE OF T_ORDER_ITEM.

*******************structure type for afko table
TYPES:
  BEGIN OF T_ORDER_HDR,
    AUFNR TYPE AFKO-AUFNR,
    FTRMI TYPE AFKO-FTRMI,
    GAMNG TYPE AFKO-GAMNG,
  END OF T_ORDER_HDR,
****************************table type for afko
  TT_ORDER_HDR TYPE STANDARD TABLE OF T_ORDER_HDR.

*******************structure type for vbak table
TYPES:
  BEGIN OF T_SALES_ORD_HDR,
    VBELN TYPE VBAK-VBELN,
    AUDAT TYPE VBAK-AUDAT,
    AUART TYPE VBAK-AUART,
    VKBUR TYPE VBAK-VKBUR,
    KNUMV TYPE VBAK-KNUMV,
    KUNNR TYPE VBAK-KUNNR,
    AEDAT TYPE VBAK-AEDAT,
    WAERK TYPE VBAK-WAERK,
  END OF T_SALES_ORD_HDR,
****************************table type for vbak
  TT_SALES_ORD_HDR TYPE STANDARD TABLE OF T_SALES_ORD_HDR.

TYPES:
  BEGIN OF T_SALES_ORD_ITEM,
    VBELN   TYPE VBAP-VBELN,
    POSNR   TYPE VBAP-POSNR,
    MATNR   TYPE VBAP-MATNR,
    KDMAT   TYPE VBAP-KDMAT,
    KWMENG  TYPE VBAP-KWMENG,
    DELDATE TYPE VBAP-DELDATE,
    KZWI1   TYPE VBAP-KZWI1,
    LGORT   TYPE VBAP-LGORT,
  END OF T_SALES_ORD_ITEM,
  TT_SALES_ORD_ITEM TYPE STANDARD TABLE OF T_SALES_ORD_ITEM.

TYPES:
  BEGIN OF T_MAT_MAST,
    MATNR   TYPE MARA-MATNR,
    ZSERIES TYPE MARA-ZSERIES,
    ZSIZE   TYPE MARA-ZSIZE,
    BRAND   TYPE MARA-BRAND,
    MOC     TYPE MARA-MOC,
    TYPE    TYPE MARA-TYPE,
  END OF T_MAT_MAST,
  TT_MAT_MAST TYPE STANDARD TABLE OF T_MAT_MAST.

TYPES:
  BEGIN OF T_MAT_DESC,
    MATNR TYPE MAKT-MATNR,
    MAKTX TYPE MAKT-MAKTX,
  END OF T_MAT_DESC,
  TT_MAT_DESC TYPE STANDARD TABLE OF T_MAT_DESC.

TYPES:
  BEGIN OF T_VBEP,
    VBELN TYPE VBEP-VBELN,
    POSNR TYPE VBEP-POSNR,
    EDATU TYPE VBEP-EDATU,
  END OF T_VBEP,
  TT_VBEP TYPE STANDARD TABLE OF T_VBEP.

TYPES:
  BEGIN OF T_CUST_INFO,
    KUNNR TYPE KNA1-KUNNR,
    NAME1 TYPE KNA1-NAME1,
    STCD3 TYPE KNA1-STCD3,
  END OF T_CUST_INFO,
  TT_CUST_INFO TYPE STANDARD TABLE OF T_CUST_INFO.

TYPES:
  BEGIN OF T_MARC,
    MATNR TYPE MARC-MATNR,
    WERKS TYPE MARC-WERKS,
    DISPO TYPE MARC-DISPO,
  END OF T_MARC,
  TT_MARC TYPE STANDARD TABLE OF T_MARC.

TYPES:
**************structure for standard cost
  BEGIN OF T_MBEW,
    MATNR TYPE MBEW-MATNR,
    BWKEY TYPE MBEW-BWKEY,
    VPRSV TYPE MBEW-VPRSV,
    VERPR TYPE MBEW-VERPR,
    STPRS TYPE MBEW-STPRS,
  END OF T_MBEW,
  TT_MBEW TYPE STANDARD TABLE OF T_MBEW.

TYPES:
  BEGIN OF T_QAMB,
    PRUEFLOS TYPE QAMB-PRUEFLOS,
    TYP      TYPE QAMB-TYP,
    MBLNR    TYPE QAMB-MBLNR,
    MJAHR    TYPE QAMB-MJAHR,
    ZEILE    TYPE QAMB-ZEILE,
  END OF T_QAMB,
  TT_QAMB TYPE STANDARD TABLE OF T_QAMB.
****************8structure for inspection lot
TYPES:
  BEGIN OF T_QALS,
    PRUEFLOS TYPE QALS-PRUEFLOS,
    AUFNR    TYPE QALS-AUFNR,
    MJAHR    TYPE QALS-MJAHR,
    MBLNR    TYPE QALS-MBLNR,
    LMENGE01 TYPE QALS-LMENGE01,
  END OF T_QALS,
  TT_QALS TYPE STANDARD TABLE OF T_QALS.

**TYPES:
**  BEGIN OF t_t005u,
**    land1 TYPE t005u-land1,
**    bland TYPE t005u-bland,
**    bezei TYPE t005u-bezei,
**  END OF t_t005u.
*****************final structure for alve output
TYPES:
  BEGIN OF T_FINAL,
    DISPO         TYPE MARC-DISPO,
    BRAND         TYPE MARA-BRAND,
    KDAUF         TYPE MSEG-KDAUF,
    KDPOS         TYPE MSEG-KDPOS,
    VKBUR         TYPE VBAK-VKBUR,
    MATNR         TYPE MSEG-MATNR,
    MAKTX         TYPE VBRP-ARKTX,
    LONG_TXT      TYPE CHAR100,
    DAUAT         TYPE AFPO-DAUAT,
    NAME1         TYPE KNA1-NAME1,
    EDATU         TYPE CHAR10, "vbep-edatu,
    KWMENG        TYPE VBAP-KWMENG,
    DELDATE       TYPE CHAR10, "vbap-deldate,
    KDMAT         TYPE VBAP-KDMAT,
    AUFNR         TYPE MSEG-AUFNR,
    MENGE         TYPE AFKO-GAMNG, "mseg-menge,
    MENGE_CONF    TYPE MSEG-MENGE,
    BUDAT_CON     TYPE CHAR10, "mseg-budat_mkpf,
    BUDAT_IN      TYPE CHAR10, "mseg-budat_mkpf,
    PRD_AMT       TYPE VBAP-NETWR,
    NETPR         TYPE VBAP-NETPR,
    STPRS         TYPE MBEW-STPRS,
    ZSERIES       TYPE MARA-ZSERIES,
    ZSIZE         TYPE CHAR3, "mara-zsize,
    MOC           TYPE MARA-MOC,
    TYPE          TYPE MARA-TYPE,
    LGORT         TYPE MSEG-LGORT,
    AEDAT         TYPE CHAR10, "vbak-aedat,
    FTRMI         TYPE CHAR10, "afko-ftrmi,
    WAERK         TYPE VBAK-WAERK,
    KURSK         TYPE VBKD-KURSK,
    S_VAL         TYPE PRCD_ELEMENTS-KWERT,
    S_VAL_LC      TYPE PRCD_ELEMENTS-KWERT,
    AUART         TYPE VBAK-AUART,
    SO_CURR       TYPE VBKD-KURSK,
    CURR_DATE     TYPE SY-DATUM,
    FST_ISH       TYPE CHAR11,
    LST_ISH       TYPE CHAR11,
    DEL_DAT       TYPE CHAR11,
    LGORT1        TYPE VBAP-LGORT,
    CREATED_DATE  TYPE CHAR11,
    CUSTOMER_CODE TYPE VBAK-KUNNR,
    PRD_AMT1      TYPE VBAP-NETWR,
    INSP_QTY      TYPE MSEG-MENGE,
    PRUEFLOS      TYPE QALS-PRUEFLOS,
    MBLNR_101     TYPE MSEG-MBLNR,
    MBLNR_321     TYPE MSEG-MBLNR,
    LMENGE01      TYPE QALS-LMENGE01, "ADDED BY JYOTION 26.03.2025
    BSTKD         TYPE VBKD-BSTKD , "ADDED BY JYOTI ON 27.03.2025
  END OF T_FINAL,
  TT_FINAL TYPE STANDARD TABLE OF T_FINAL.

**********below structue for refreshable file
TYPES:
  BEGIN OF TY_FINAL,
    DISPO         TYPE CHAR100,
    BRAND         TYPE CHAR100,
    KDAUF         TYPE CHAR100,
    KDPOS         TYPE STRING,
    VKBUR         TYPE CHAR100,
    MATNR         TYPE CHAR100,
    MAKTX         TYPE VBRP-ARKTX,
    LONG_TXT      TYPE CHAR100,
    DAUAT         TYPE CHAR100,
    NAME1         TYPE CHAR100,
    EDATU         TYPE CHAR11, "vbep-edatu,
    KWMENG        TYPE STRING,
    DELDATE       TYPE CHAR11, "vbap-deldate,
    KDMAT         TYPE CHAR100,
    AUFNR         TYPE CHAR100,
    MENGE         TYPE CHAR100,
    MENGE_CONF    TYPE CHAR100,
    BUDAT_CON     TYPE CHAR11, "mseg-budat_mkpf,
    BUDAT_IN      TYPE CHAR11, "mseg-budat_mkpf,
    PRD_AMT       TYPE STRING,
    NETPR         TYPE STRING,
    STPRS         TYPE STRING,
    ZSERIES       TYPE CHAR100,
    ZSIZE         TYPE CHAR3, "mara-zsize,
    MOC           TYPE CHAR100,
    TYPE          TYPE CHAR100,
    LGORT         TYPE CHAR100,
    AEDAT         TYPE CHAR11, "vbak-aedat,
    CREATED_DATE  TYPE STRING,
    FTRMI         TYPE CHAR11, "afko-ftrmi,
    WAERK         TYPE CHAR100,
    KURSK         TYPE STRING,
    S_VAL         TYPE STRING,
    S_VAL_LC      TYPE STRING,
    AUART         TYPE CHAR100,
    SO_CURR       TYPE CHAR100,
*    curr_date TYPE char11,
    FST_ISH       TYPE CHAR11,
    LST_ISH       TYPE CHAR11,
    DEL_DAT       TYPE CHAR11,
    LGORT1        TYPE CHAR100,
    CURR_DATE     TYPE STRING,
    REF_TIME      TYPE CHAR15,
    CUSTOMER_CODE TYPE STRING,
    PRD_AMT1      TYPE STRING,
    INSP_QTY      TYPE STRING,
    PRUEFLOS      TYPE STRING,
    MBLNR_101     TYPE STRING,
    MBLNR_321     TYPE STRING,
    LMENGE01      TYPE STRING,
    BSTKD         TYPE STRING , "ADDED BY JYOTI ON 27.03.2025
  END OF TY_FINAL.
*  tt_final TYPE STANDARD TABLE OF t_final.

DATA:
  GT_FINAL TYPE TT_FINAL,
  IT_FINAL TYPE TABLE OF TY_FINAL.

***********************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS: C_BUDAT     TYPE CHAR8 VALUE '20170401',
           C_PATH      TYPE CHAR50 VALUE    '/Delval/India',        "'/delval/temp',
           C_WERKS     TYPE CHAR4 VALUE 'PL01',
           C_BWART_101 TYPE CHAR3 VALUE '101',
           C_BWART_102 TYPE CHAR3 VALUE '102',
           C_BWART_261 TYPE CHAR3 VALUE '261',
           C_BWART_321 TYPE CHAR3 VALUE '321',
           C_BENKZ     TYPE CHAR1 VALUE 'S',
           C_BENKZ1    TYPE CHAR1 VALUE 'H',
           C_BENKZ2    TYPE CHAR1 VALUE 'L',
           C_SHKZG     TYPE CHAR1 VALUE 'S',
           C_TYP       TYPE CHAR1 VALUE '3'.

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE XYZ.
  SELECT-OPTIONS: SO_BUDAT FOR TMP_BUDAT DEFAULT C_BUDAT TO SY-DATUM,
                  SO_DAUAT FOR TMP_DAUAT NO INTERVALS,
                  SO_KDAUF FOR TMP_KDAUF,
                  SO_LGORT FOR TMP_LGORT NO INTERVALS,
                  SO_MATNR FOR TMP_MAT,
                  SO_ERDAT FOR TMP_BUDAT.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE ABC .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER TYPE RLGRAP-FILENAME DEFAULT C_PATH.
  PARAMETERS P_FILENM TYPE CHAR30.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

INITIALIZATION.
  XYZ = 'Select Options'(tt1).
  ABC = 'Download File'(tt2).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FOLDER.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
*     FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FOLDER.

AT SELECTION-SCREEN.
  IF SO_ERDAT[] IS NOT INITIAL AND  P_FILENM IS INITIAL.
    MESSAGE 'Please Enter File Name' TYPE 'E'.
  ENDIF.

    DATA lv_filename_upper TYPE string.
    DATA lv_len            TYPE i.
    DATA lv_offset         TYPE i.

    lv_filename_upper = to_upper( p_filenm ).
    lv_len    = strlen( lv_filename_upper ).
    lv_offset = lv_len - 4.

    " If user entered extension and it's not .TXT → error
    IF lv_len >= 4 AND lv_filename_upper+lv_offset(4) <> '.TXT'.
      SET CURSOR FIELD 'P_FILENM'.
      MESSAGE 'Only .TXT file is allowed.' TYPE 'E'.
    ENDIF.

START-OF-SELECTION.
  PERFORM FETCH_DATA CHANGING GT_FINAL.
  PERFORM DISPLAY USING GT_FINAL.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM FETCH_DATA  CHANGING CT_FINAL TYPE TT_FINAL.
  DATA:
    LT_MAT_DOC        TYPE TT_MAT_DOC,
    LS_MAT_DOC        TYPE T_MAT_DOC,
    LT_MAT_DOC1       TYPE TT_MAT_DOC,
    LS_MAT_DOC1       TYPE T_MAT_DOC,
    LT_MAT_DOC_101    TYPE TT_MAT_DOC,
    LS_MAT_DOC_101    TYPE T_MAT_DOC,
    LT_MAT_DOC_321    TYPE TT_MAT_DOC,
    LS_MAT_DOC_321    TYPE T_MAT_DOC,
    LT_ORDER_ITEM     TYPE TT_ORDER_ITEM,
    LS_ORDER_ITEM     TYPE T_ORDER_ITEM,
    LT_SALES_ORD_HDR  TYPE TT_SALES_ORD_HDR,
    LS_SALES_ORD_HDR  TYPE T_SALES_ORD_HDR,
    LT_SALES_ORD_ITEM TYPE TT_SALES_ORD_ITEM,
    LS_SALES_ORD_ITEM TYPE T_SALES_ORD_ITEM,
    LT_MAT_MAST       TYPE TT_MAT_MAST,
    LS_MAT_MAST       TYPE T_MAT_MAST,
    LT_MAT_DESC       TYPE TT_MAT_DESC,
    LS_MAT_DESC       TYPE T_MAT_DESC,
    LT_VBEP           TYPE TT_VBEP,
    LS_VBEP           TYPE T_VBEP,
    LT_CUST_INFO      TYPE TT_CUST_INFO,
    LS_CUST_INFO      TYPE T_CUST_INFO,
    LT_MARC           TYPE TT_MARC,
    LS_MARC           TYPE T_MARC,
    LT_MBEW           TYPE TT_MBEW,
    LS_MBEW           TYPE T_MBEW,
    LT_QAMB           TYPE TT_QAMB,
    LS_QAMB           TYPE T_QAMB,
    LT_QALS           TYPE TT_QALS,
    LS_QALS           TYPE T_QALS,
    LT_ORDER_HDR      TYPE TT_ORDER_HDR,
    LS_ORDER_HDR      TYPE T_ORDER_HDR,
    LT_COEP           TYPE TT_COEP,
    LS_COEP           TYPE T_COEP,
    LT_COEP1          TYPE TT_COEP,
    LS_COEP1          TYPE T_COEP,
    LT_VBKD           TYPE TT_VBKD,
    LS_VBKD           TYPE T_VBKD,
    LS_FINAL          TYPE T_FINAL,
    WA_FINAL          TYPE TY_FINAL,
    LT_AUFM           TYPE TT_AUFM,
    LS_AUFM           TYPE TY_AUFM,
    LT_AUFM_101       TYPE TT_AUFM,
    LS_AUFM_101       TYPE TY_AUFM,
    LT_AUFM_102       TYPE TT_AUFM,
    LS_AUFM_102       TYPE TY_AUFM,
    LT_AUFM_321       TYPE TT_AUFM,
    LS_AUFM_321       TYPE TY_AUFM.

  DATA:
    LV_ID        TYPE THEAD-TDNAME,
    LT_LINES     TYPE STANDARD TABLE OF TLINE,
    LS_LINES     TYPE TLINE,
    LV_INDEX     TYPE SY-TABIX,
    LV_COST      TYPE PRCD_ELEMENTS-KWERT,
    LV_COST1     TYPE PRCD_ELEMENTS-KWERT,
    LS_EXCH_RATE TYPE BAPI1093_0.

  DATA :
    GV_CON_DAT TYPE MKPF-BUDAT,
    GV_FST_ISH TYPE MKPF-BUDAT,
    GV_LST_ISH TYPE MKPF-BUDAT.

************BELOW LOFGIC FOR PRODUCTION ORDER TYPE WISE
*********MULTIPLE PRODUCTION ORDER AND STORAGE LOC
  IF NOT SO_DAUAT IS INITIAL OR SO_ERDAT IS NOT INITIAL.
*****************SOC by farhan on dated 09.02.2026
*    SELECT AUFNR
*           POSNR
*           DAUAT
*           PSMNG
*           PWERK
**           objnr
*           LGORT
*      FROM AFPO
*      INTO TABLE LT_ORDER_ITEM
*      WHERE DAUAT IN SO_DAUAT
*      AND PWERK = C_WERKS.

    SELECT
        A~AUFNR,
        A~POSNR,
        A~DAUAT,
        A~PSMNG,
        A~PWERK,
        A~LGORT
      FROM AFPO AS A
      INNER JOIN AUFK AS B
        ON A~AUFNR = B~AUFNR
      INTO TABLE @LT_ORDER_ITEM
      WHERE A~DAUAT IN @SO_DAUAT
        AND A~PWERK = @C_WERKS
        AND B~ERDAT IN @SO_ERDAT.

**************EOC by farhan on dated 09.02.2026


***********BELOW SELECT QUERY FOR MOVEMENT TYPR '101'
* ANDSALES OREDR,CUSTOMER MATERIAL PRODUCTION ORDER,QTY,
* CONFIRMATION DATE PICK FOROM MSEG
    IF NOT LT_ORDER_ITEM IS INITIAL.
      SELECT MBLNR
             MJAHR
             ZEILE
             BWART
             MATNR
             WERKS
             LGORT
             KUNNR
             KDAUF
             KDPOS
             WAERS
             MENGE
             AUFNR
             BUDAT_MKPF
             MAT_KDAUF
             MAT_KDPOS
        FROM MSEG
        INTO TABLE LT_MAT_DOC1
        FOR ALL ENTRIES IN LT_ORDER_ITEM
        WHERE AUFNR = LT_ORDER_ITEM-AUFNR
        AND   BUDAT_MKPF IN SO_BUDAT
        AND   BWART = C_BWART_101 "'101'
*        AND   xauto = 'X'
        AND   MATNR IN SO_MATNR
        AND   LGORT IN SO_LGORT
        AND   MAT_KDAUF IN SO_KDAUF
        AND   WERKS = LT_ORDER_ITEM-PWERK.
    ENDIF.
  ELSE.
*BELOW LOGIC WHEN ONLY CONFIRMATION DATE IS ENTERED ON SELECTION SCREEN
***********BELOW SELECT QUERY FOR MOVEMENT TYPR '101'
* ANDSALES OREDR,CUSTOMER MATERIAL PRODUCTION ORDER,QTY,
* CONFIRMATION DATE PICK FOROM MSEG
    SELECT MBLNR
           MJAHR
           ZEILE
           BWART
           MATNR
           WERKS
           LGORT
           KUNNR
           KDAUF
           KDPOS
           WAERS
           MENGE
           AUFNR
           BUDAT_MKPF
           MAT_KDAUF
           MAT_KDPOS
      FROM MSEG
      INTO TABLE LT_MAT_DOC1
      WHERE BUDAT_MKPF IN SO_BUDAT
      AND   BWART = C_BWART_101
*      AND   xauto = 'X'
      AND   MATNR IN SO_MATNR
      AND   LGORT IN SO_LGORT
      AND   MAT_KDAUF IN SO_KDAUF
      AND   AUFNR NE SPACE
      AND   WERKS = C_WERKS.


  ENDIF.
**BELOW LOGIC FOR INTERNAL ORDER IS NOT COMING IN REPORT
*  BREAK primusabap.
  IF LT_MAT_DOC1 IS NOT INITIAL.
    SELECT WABLNR,
           AUFNR,
           BUDAT,
           STOKZ,
           STZHL
           FROM AFRU
           INTO TABLE @DATA(LT_AFRU)
           FOR ALL ENTRIES IN @LT_MAT_DOC1
           WHERE AUFNR = @LT_MAT_DOC1-AUFNR
           AND WABLNR = @LT_MAT_DOC1-MBLNR
           AND STOKZ NE 'X'
           AND STZHL = ' '.

*    select wablnr,
*         aufnr,
*         budat,
*         stokz,
*          stzhl
*         FROM afru
*         INTO TABLE @DATA(lt_afru)
*         for ALL ENTRIES IN @lt_afru1
*         where aufnr = @lt_afru1-aufnr
*         and wablnr = @lt_afru1-wablnr
*         and stokz ne 'X'.

    SELECT MBLNR
           MJAHR
           ZEILE
           BWART
           MATNR
           WERKS
           LGORT
           KUNNR
           KDAUF
           KDPOS
           WAERS
           MENGE
           AUFNR
           BUDAT_MKPF
           MAT_KDAUF
           MAT_KDPOS
      FROM MSEG
      INTO TABLE LT_MAT_DOC
      FOR ALL ENTRIES IN LT_AFRU
      WHERE AUFNR = LT_AFRU-AUFNR
         AND MBLNR = LT_AFRU-WABLNR.
  ENDIF.

*BREAK primusabap.
*  sort lt_mat_doc by aufnr budat_mkpf DESCENDING.
*  delete ADJACENT DUPLICATES FROM lt_mat_doc COMPARING Aufnr.


***********************************************************************
*************IF DATA IS NOT IN INTERNAL TABLE THEN IT IS NOT EXECUTING
*********DISPLAY ERROR MESSAGE
  IF LT_MAT_DOC IS INITIAL.
*    MESSAGE 'Data Not Found' TYPE 'E'.
    MESSAGE E001(ZDELVAL_MESAGE).
  ELSE.
**************WHEN ONLY CONFIRMATION DATE IS ENTERD THEN
********PICK PRODUCTION ORDER TYPE FROM AFPO
    SELECT AUFNR
           POSNR
           DAUAT
           PSMNG
           PWERK
*           objnr
           LGORT
      FROM AFPO
      INTO TABLE LT_ORDER_ITEM
      FOR ALL ENTRIES IN LT_MAT_DOC
      WHERE AUFNR = LT_MAT_DOC-AUFNR.
*        and pwerk = c_werks.

******************logic for prod order  created date
    SELECT AUFNR,
           ERDAT
           FROM AUFK
           INTO TABLE @DATA(LT_AUFK)
           FOR ALL ENTRIES IN @LT_MAT_DOC
            WHERE AUFNR = @LT_MAT_DOC-AUFNR.

************BELOW LOGIC FOR CONCATENATE PRODUCTION ORDER AND 'OR'
**********IN OBJECT FIELD
    IF NOT LT_ORDER_ITEM IS INITIAL.
      LOOP AT LT_ORDER_ITEM INTO LS_ORDER_ITEM.
        CONCATENATE 'OR' LS_ORDER_ITEM-AUFNR INTO LS_ORDER_ITEM-OBJNR.
        MODIFY LT_ORDER_ITEM FROM LS_ORDER_ITEM TRANSPORTING OBJNR.
      ENDLOOP.

********************ACTUAL RELEASE DATELOGIC
      SELECT AUFNR
             FTRMI
             GAMNG
        FROM AFKO
        INTO TABLE LT_ORDER_HDR
        FOR ALL ENTRIES IN LT_ORDER_ITEM
        WHERE AUFNR = LT_ORDER_ITEM-AUFNR.

**************************LOGIC FOR INSPECTION LOT NO
*      SELECT prueflos
*             aufnr
*             mjahr
*             mblnr
*        FROM qals
*        INTO TABLE lt_qals
*        FOR ALL ENTRIES IN lt_order_item
*        WHERE aufnr = lt_order_item-aufnr

      SELECT PRUEFLOS
              AUFNR
              MJAHR
              MBLNR
              LMENGE01
         FROM QALS
         INTO TABLE LT_QALS
         FOR ALL ENTRIES IN LT_MAT_DOC
         WHERE AUFNR = LT_MAT_DOC-AUFNR
         AND MBLNR = LT_MAT_DOC-MBLNR.

***************LOGIC FOR INSPECTION DATE
      IF  LT_QALS IS NOT INITIAL.
        SELECT PRUEFLOS
               TYP
               MBLNR
               MJAHR
               ZEILE
          FROM QAMB
          INTO TABLE LT_QAMB
          FOR ALL ENTRIES IN LT_QALS
          WHERE PRUEFLOS = LT_QALS-PRUEFLOS
          AND   TYP      EQ C_TYP. " '3'.
      ENDIF.
      IF  LT_QAMB IS NOT INITIAL.

        SELECT MBLNR
                 MJAHR
                 ZEILE
                 BWART
                 MATNR
                 WERKS
                 LGORT
                 KUNNR
                 KDAUF
                 KDPOS
                 WAERS
                 MENGE
                 AUFNR
                 BUDAT_MKPF
                 MAT_KDAUF
                 MAT_KDPOS
            FROM MSEG
            INTO TABLE LT_MAT_DOC_321
            FOR ALL ENTRIES IN LT_QAMB
            WHERE MBLNR = LT_QAMB-MBLNR
            AND MJAHR = LT_QAMB-MJAHR
          AND BWART = C_BWART_321"'321'
          AND SHKZG = C_SHKZG."'S'.

      ENDIF.

*******LOGIC FOR objnr
      SELECT KOKRS
             BELNR
             BUZEI
             WTGBTR
             OBJNR
             BEKNZ
             REFBN
            INTO TABLE IT_COVP
            FROM COVP
*            FOR ALL ENTRIES IN lt_mat_doc
            FOR ALL ENTRIES IN LT_ORDER_ITEM
*            WHERE refbn = lt_mat_doc-mblnr
         WHERE OBJNR = LT_ORDER_ITEM-OBJNR
           AND BEKNZ IN ('S' , 'H')
*            AND  ( beknz = c_benkz
*            and  beknz = c_benkz1 )
            AND WERKS = C_WERKS."'S'.

      SELECT KOKRS
         BELNR
         BUZEI
         WTGBTR
         OBJNR
         BEKNZ
         REFBN
        INTO TABLE IT_COVP1
        FROM COVP
        FOR ALL ENTRIES IN LT_MAT_DOC
        WHERE REFBN = LT_MAT_DOC-MBLNR
       AND BEKNZ = C_BENKZ2"'L'
        AND WERKS = C_WERKS."'S'.

*
    ENDIF.

**********sales order header data
    SELECT VBELN
           AUDAT
           AUART
           VKBUR
           KNUMV
           KUNNR
           AEDAT
           WAERK
      FROM VBAK
      INTO TABLE LT_SALES_ORD_HDR
      FOR ALL ENTRIES IN LT_MAT_DOC
      WHERE VBELN = LT_MAT_DOC-MAT_KDAUF.

*************Sa;es order line item wise data
    SELECT VBELN
           POSNR
           MATNR
           KDMAT
           KWMENG
           DELDATE
           KZWI1
           LGORT
      FROM VBAP
      INTO TABLE LT_SALES_ORD_ITEM
      FOR ALL ENTRIES IN LT_MAT_DOC
      WHERE VBELN = LT_MAT_DOC-MAT_KDAUF
      AND   POSNR = LT_MAT_DOC-MAT_KDPOS.

********below logic exchange Rate **********************
    SELECT VBELN
           POSNR
           KURSK
           BSTKD
      FROM VBKD
      INTO TABLE LT_VBKD
      FOR ALL ENTRIES IN LT_SALES_ORD_ITEM
      WHERE VBELN = LT_SALES_ORD_ITEM-VBELN.

********below logic for material master data
    SELECT MATNR
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE
      FROM MARA
      INTO TABLE LT_MAT_MAST
      FOR ALL ENTRIES IN LT_MAT_DOC
      WHERE MATNR = LT_MAT_DOC-MATNR.

* ********logic for material dscription
    SELECT MATNR
           MAKTX
      FROM MAKT
      INTO TABLE LT_MAT_DESC
      FOR ALL ENTRIES IN LT_MAT_MAST
      WHERE MATNR = LT_MAT_MAST-MATNR
      AND   SPRAS = SY-LANGU.

*************logic for schedule line date
    SELECT VBELN
           POSNR
           EDATU
      FROM VBEP
      INTO TABLE LT_VBEP
      FOR ALL ENTRIES IN LT_MAT_DOC
      WHERE VBELN = LT_MAT_DOC-MAT_KDAUF
      AND   POSNR = LT_MAT_DOC-MAT_KDPOS.

**************logic for customer name
    SELECT KUNNR
           NAME1
           STCD3
      FROM KNA1
      INTO TABLE LT_CUST_INFO
      FOR ALL ENTRIES IN LT_SALES_ORD_HDR
      WHERE KUNNR = LT_SALES_ORD_HDR-KUNNR.

***********logic for plant against material MRP controller data
    SELECT MATNR
           WERKS
           DISPO
      FROM MARC
      INTO TABLE LT_MARC
      FOR ALL ENTRIES IN LT_MAT_DOC
      WHERE MATNR = LT_MAT_DOC-MATNR.

*********logic for standard cost
    SELECT MATNR
           BWKEY
           VPRSV
           VERPR
           STPRS
        FROM MBEW
      INTO TABLE LT_MBEW
      FOR ALL ENTRIES IN LT_MAT_DOC
      WHERE MATNR = LT_MAT_DOC-MATNR
         AND BWKEY = C_WERKS.

*********logic for movement type 101 data aginst production order
    IF NOT LT_MAT_DOC IS INITIAL.
      SELECT MBLNR
         MJAHR
         ZEILE
         BWART
         MATNR
         WERKS
         LGORT
         KUNNR
         KDAUF
         KDPOS
         WAERS
         MENGE
         AUFNR
         BUDAT_MKPF
    FROM MSEG
    INTO TABLE LT_MAT_DOC_101
    FOR ALL ENTRIES IN LT_MAT_DOC
    WHERE AUFNR = LT_MAT_DOC-AUFNR
    AND   BWART = C_BWART_101."'101'.
    ENDIF.
*    ENDIF.
  ENDIF.
  IF LT_MAT_DOC IS NOT INITIAL.
*********first release and last release date
    SELECT MBLNR
           MJAHR
           ZEILE
           BWART
           MATNR
           WERKS
           AUFNR
           BUDAT
           MENGE
           SHKZG
           LGORT
      FROM AUFM INTO TABLE LT_AUFM
    FOR ALL ENTRIES IN LT_MAT_DOC
    WHERE AUFNR = LT_MAT_DOC-AUFNR
    AND  WERKS  = LT_MAT_DOC-WERKS
    AND  BWART  = C_BWART_261."'261'.

    SELECT MBLNR
        MJAHR
        ZEILE
        BWART
        MATNR
        WERKS
        AUFNR
        BUDAT
        MENGE
        SHKZG
        LGORT
   FROM AUFM INTO TABLE LT_AUFM_101
 FOR ALL ENTRIES IN LT_MAT_DOC
 WHERE AUFNR = LT_MAT_DOC-AUFNR
 AND  WERKS  = LT_MAT_DOC-WERKS
 AND  BWART  = C_BWART_101."'101'.

    SELECT MBLNR
          MJAHR
          ZEILE
          BWART
          MATNR
          WERKS
          AUFNR
          BUDAT
          MENGE
          SHKZG
          LGORT
     FROM AUFM INTO TABLE LT_AUFM_102
   FOR ALL ENTRIES IN LT_MAT_DOC
   WHERE AUFNR = LT_MAT_DOC-AUFNR
   AND  WERKS  = LT_MAT_DOC-WERKS
   AND  BWART  = C_BWART_102."'102'.

    SELECT MBLNR
       MJAHR
       ZEILE
       BWART
       MATNR
       WERKS
       AUFNR
       BUDAT
       MENGE
      SHKZG
       LGORT
  FROM AUFM INTO TABLE LT_AUFM_321
FOR ALL ENTRIES IN LT_MAT_DOC
WHERE AUFNR = LT_MAT_DOC-AUFNR
AND  WERKS  = LT_MAT_DOC-WERKS
AND  BWART  = C_BWART_321."'321'.

  ENDIF.

  SORT LT_COEP BY OBJNR.
*  BREAK primusabap.
*******sales order and line item wise of inspecton lot no with production orderwise
  LOOP AT  LT_MAT_DOC INTO LS_MAT_DOC.""lt_mat_doc_101 INTO ls_mat_doc_101.
*  loop at lt_mat_Doc_321 INTO ls_mat_doc_321.
    """"""inspection qty logic
    LS_FINAL-AUFNR = LS_MAT_DOC-AUFNR.
    LS_FINAL-MBLNR_101 = LS_MAT_DOC-MBLNR.
    LS_MAT_DOC_101-MJAHR = LS_MAT_DOC-MJAHR.

    READ TABLE LT_QALS INTO LS_QALS WITH KEY AUFNR = LS_FINAL-AUFNR MBLNR =  LS_FINAL-MBLNR_101.
    IF  SY-SUBRC = 0.
      LS_FINAL-PRUEFLOS = LS_QALS-PRUEFLOS.
      LS_FINAL-LMENGE01 = LS_FINAL-LMENGE01 + LS_QALS-LMENGE01.
    ENDIF.

    """""""Inspection date
*    IF NOT ls_mat_doc_321-budat_mkpf IS INITIAL.
*      CONCATENATE ls_mat_doc_321-budat_mkpf+6(2) ls_mat_doc_321-budat_mkpf+4(2) ls_mat_doc_321-budat_mkpf+0(4)
*                INTO ls_final-budat_in SEPARATED BY '-'.
*    ELSE.
*      ls_final-budat_in = ' '.
*    ENDIF.

*    READ TABLE lt_qamb INTO ls_qamb WITH KEY mblnr = ls_mat_doc_321-mblnr
*                                             mjahr = ls_mat_doc_321-mjahr.
*    IF sy-subrc IS INITIAL.
*
*      READ TABLE lt_qals INTO ls_qals WITH KEY prueflos = ls_qamb-prueflos.
*
*      IF sy-subrc IS INITIAL.
*        """"""""inspection lot no
*        ls_final-prueflos = ls_qals-prueflos.
*
*      ENDIF.
*    ENDIF.
*  LOOP AT lt_mat_doc INTO ls_mat_doc.           "commented by jyoti on 23.12.2024
    READ TABLE LT_MAT_DOC INTO LS_MAT_DOC WITH KEY MBLNR = LS_QALS-MBLNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-KDAUF    = LS_MAT_DOC-MAT_KDAUF.
      LS_FINAL-KDPOS    = LS_MAT_DOC-MAT_KDPOS.
*    ls_final-aufnr    = ls_mat_doc-aufnr.
      LS_FINAL-MBLNR_101 = LS_MAT_DOC-MBLNR.
*ls_final-LGORT  = ls_mat_doc-LGORT.
    ENDIF.
*  READ TABLE lt_aufm_321 INTO ls_aufm_321 with key aufnr = ls_final-aufnr
**                                                      mblnr = ls_mat_doc-mblnr
*                                                        SHKZG = 'S'.
*  if sy-subrc IS INITIAL.
*    ls_final-lgort = ls_aufm_321-lgort.
*  endif.

**********  confirmation qty
*    loop at lt_aufm_101 INTO ls_aufm_101 WHERE aufnr = ls_final-aufnr.
    READ TABLE LT_AUFM_101 INTO LS_AUFM_101 WITH KEY AUFNR = LS_FINAL-AUFNR
                                                      MBLNR = LS_MAT_DOC-MBLNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-MENGE_CONF   =   LS_AUFM_101-MENGE.
*    ls_final-menge_conf   =  ls_final-menge_conf +  ls_aufm_101-menge.
*     IF  wa_final-lgort IS INITIAL.
*        wa_final-lgort = ls_aufm_101-lgort.
*      endif.
    ENDIF.
*    endloop.
    IF LS_FINAL-PRUEFLOS IS INITIAL.
      LS_FINAL-LMENGE01 = LS_FINAL-MENGE_CONF.
    ENDIF.

*    loop at lt_aufm_102 INTO ls_aufm_102 WHERE aufnr = ls_final-aufnr.
    READ TABLE LT_AUFM_102 INTO LS_AUFM_102 WITH KEY AUFNR = LS_FINAL-AUFNR
                                                     MBLNR = LS_MAT_DOC-MBLNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-MENGE_CONF   =  LS_FINAL-MENGE_CONF -  LS_AUFM_102-MENGE.
    ENDIF.
*    endloop.

**************production order created date*********************
    READ TABLE LT_AUFK INTO DATA(LS_AUFK) WITH KEY AUFNR = LS_FINAL-AUFNR.
    IF SY-SUBRC IS INITIAL.
      IF LS_AUFK-ERDAT IS NOT INITIAL.

        CONCATENATE LS_AUFK-ERDAT+6(2) LS_AUFK-ERDAT+4(2) LS_AUFK-ERDAT+0(4)
                  INTO LS_FINAL-CREATED_DATE SEPARATED BY '-'.
      ELSE.
        LS_FINAL-CREATED_DATE = ' '.
      ENDIF.
    ENDIF.


**********below logic for first and last release date***********************
    SORT LT_AUFM BY BUDAT ASCENDING .
    READ TABLE LT_AUFM INTO LS_AUFM WITH KEY AUFNR = LS_FINAL-AUFNR.
    IF NOT LS_AUFM-BUDAT IS INITIAL.
      GV_FST_ISH = LS_AUFM-BUDAT.
      CONCATENATE LS_AUFM-BUDAT+6(2) LS_AUFM-BUDAT+4(2) LS_AUFM-BUDAT+0(4)
      INTO LS_FINAL-FST_ISH SEPARATED BY '-'.
    ELSE.
      LS_FINAL-FST_ISH = ' '.
    ENDIF.


    SORT LT_AUFM BY BUDAT DESCENDING .
    READ TABLE LT_AUFM INTO LS_AUFM WITH KEY AUFNR = LS_FINAL-AUFNR.
    IF NOT LS_AUFM-BUDAT IS INITIAL.
      GV_LST_ISH = LS_AUFM-BUDAT.
      CONCATENATE LS_AUFM-BUDAT+6(2) LS_AUFM-BUDAT+4(2) LS_AUFM-BUDAT+0(4)
      INTO LS_FINAL-LST_ISH SEPARATED BY '-'.
    ELSE.
      LS_FINAL-LST_ISH = ' '.
    ENDIF.
*************************************************************************


    LS_FINAL-MATNR    = LS_MAT_DOC-MATNR.


    READ TABLE LT_MARC INTO LS_MARC WITH KEY MATNR = LS_MAT_DOC-MATNR
                                             WERKS = LS_MAT_DOC-WERKS.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-DISPO  = LS_MARC-DISPO.
    ENDIF.
    READ TABLE LT_ORDER_ITEM INTO LS_ORDER_ITEM WITH KEY AUFNR = LS_MAT_DOC-AUFNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-DAUAT  = LS_ORDER_ITEM-DAUAT.
*      ls_final-LGORT  = ls_order_item-LGORT.
    ENDIF.

    READ TABLE LT_ORDER_HDR INTO LS_ORDER_HDR WITH KEY AUFNR = LS_FINAL-AUFNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-MENGE    =  LS_ORDER_HDR-GAMNG.

      IF NOT LS_ORDER_HDR-FTRMI IS INITIAL.

        CONCATENATE LS_ORDER_HDR-FTRMI+6(2) LS_ORDER_HDR-FTRMI+4(2) LS_ORDER_HDR-FTRMI+0(4)
                INTO LS_FINAL-FTRMI SEPARATED BY '-'.
      ELSE.
        LS_FINAL-FTRMI = ' '.
      ENDIF.
    ELSE.
      LS_FINAL-FTRMI = ' '.
    ENDIF.
*************below logic for production amount********************************
*addition of total value in tranaction currency   d
    READ TABLE IT_COVP1 INTO WA_COVP1 WITH KEY REFBN = LS_MAT_DOC-MBLNR .

    IF SY-SUBRC IS INITIAL.
*      lv_cost1 = lv_cost1 + wa_covp1-wtgbtr.
      LS_FINAL-PRD_AMT = WA_COVP1-WTGBTR.
      LS_FINAL-PRD_AMT = LS_FINAL-PRD_AMT * -1.

    ENDIF.


    READ TABLE IT_COVP INTO WA_COVP WITH KEY OBJNR = LS_ORDER_ITEM-OBJNR..
    IF SY-SUBRC IS INITIAL.
*      lv_index = sy-tabix.
      CLEAR : LV_COST.
      LOOP AT IT_COVP INTO WA_COVP WHERE OBJNR = LS_ORDER_ITEM-OBJNR." FROM lv_index.
        IF WA_COVP-OBJNR = LS_ORDER_ITEM-OBJNR .
          LV_COST = LV_COST + WA_COVP-WTGBTR.
        ELSE.
          EXIT.
        ENDIF.

      ENDLOOP.
    ENDIF.

*    ls_final-prd_amt = ( lv_cost / ls_order_item-psmng )  * ls_final-menge.
    LS_FINAL-PRD_AMT1 = LV_COST.



    READ TABLE LT_SALES_ORD_ITEM INTO LS_SALES_ORD_ITEM WITH KEY VBELN = LS_MAT_DOC-MAT_KDAUF
                                                                 POSNR = LS_MAT_DOC-MAT_KDPOS.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-KDMAT   = LS_SALES_ORD_ITEM-KDMAT.
      LS_FINAL-KWMENG  = LS_SALES_ORD_ITEM-KWMENG.
      LS_FINAL-LGORT1  = LS_SALES_ORD_ITEM-LGORT.  "ADDED BY SG.
      IF NOT LS_SALES_ORD_ITEM-DELDATE IS INITIAL.

        CONCATENATE LS_SALES_ORD_ITEM-DELDATE+6(2) LS_SALES_ORD_ITEM-DELDATE+4(2) LS_SALES_ORD_ITEM-DELDATE+0(4)
                INTO LS_FINAL-DELDATE SEPARATED BY '-'.
      ELSE.
        LS_FINAL-DELDATE = ' '.
      ENDIF.
**************************rate ;logic
*sales order line items subtotal1 divivded by sales order line item wise order
      LS_FINAL-NETPR   = LS_SALES_ORD_ITEM-KZWI1 / LS_SALES_ORD_ITEM-KWMENG.


      LS_FINAL-S_VAL = LS_FINAL-NETPR * LS_FINAL-MENGE.
    ENDIF.
    READ TABLE LT_VBKD INTO LS_VBKD WITH KEY VBELN = LS_SALES_ORD_ITEM-VBELN.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-SO_CURR    = LS_VBKD-KURSK.
      LS_FINAL-BSTKD    = LS_VBKD-BSTKD.  "Added by jyoti o n27.03.2025
    ENDIF.

    READ TABLE LT_SALES_ORD_HDR INTO LS_SALES_ORD_HDR WITH KEY VBELN = LS_SALES_ORD_ITEM-VBELN.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-WAERK   = LS_SALES_ORD_HDR-WAERK.
      LS_FINAL-VKBUR   = LS_SALES_ORD_HDR-VKBUR.
      LS_FINAL-AUART   = LS_SALES_ORD_HDR-AUART.
      LS_FINAL-CUSTOMER_CODE = LS_SALES_ORD_HDR-KUNNR.

*****************logic for current exchange rate (to today )
      DATA : C_RATETYPE TYPE BAPI1093_1-RATE_TYPE VALUE 'M',
             C_CURRENCY TYPE BAPI1093_1-TO_CURRNCY VALUE 'INR'.

      CALL FUNCTION 'BAPI_EXCHANGERATE_GETDETAIL'
        EXPORTING
          RATE_TYPE  = C_RATETYPE
          FROM_CURR  = LS_FINAL-WAERK
          TO_CURRNCY = C_CURRENCY
          DATE       = SY-DATUM
        IMPORTING
          EXCH_RATE  = LS_EXCH_RATE
*         RETURN     =
        .

      LS_FINAL-KURSK    = LS_EXCH_RATE-EXCH_RATE.
      LS_FINAL-S_VAL_LC = LS_FINAL-S_VAL * LS_EXCH_RATE-EXCH_RATE.


      IF NOT LS_SALES_ORD_HDR-AEDAT IS INITIAL.

        CONCATENATE LS_SALES_ORD_HDR-AEDAT+6(2) LS_SALES_ORD_HDR-AEDAT+4(2) LS_SALES_ORD_HDR-AEDAT+0(4)
                INTO LS_FINAL-AEDAT SEPARATED BY '-'.
      ELSE.
        LS_FINAL-AEDAT = ' '.
      ENDIF.

    ELSE.
      LS_FINAL-AEDAT = ' '.
    ENDIF.
    READ TABLE LT_VBEP INTO LS_VBEP WITH KEY VBELN = LS_MAT_DOC-MAT_KDAUF
                                             POSNR = LS_MAT_DOC-MAT_KDPOS.
    IF SY-SUBRC IS INITIAL.
      IF NOT LS_VBEP-EDATU IS INITIAL.

        CONCATENATE LS_VBEP-EDATU+6(2) LS_VBEP-EDATU+4(2) LS_VBEP-EDATU+0(4)
                INTO LS_FINAL-EDATU SEPARATED BY '-'.
      ELSE.
        LS_FINAL-EDATU = ' '.
      ENDIF.
    ELSE.
      LS_FINAL-EDATU = ' '.
    ENDIF.
    READ TABLE LT_CUST_INFO INTO LS_CUST_INFO WITH KEY KUNNR = LS_SALES_ORD_HDR-KUNNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-NAME1 = LS_CUST_INFO-NAME1.
*      ls_final-stcd3 = ls_cust_info-stcd3.
    ENDIF.
    READ TABLE LT_MAT_MAST INTO LS_MAT_MAST WITH KEY MATNR = LS_FINAL-MATNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-ZSERIES = LS_MAT_MAST-ZSERIES.
      LS_FINAL-ZSIZE   = LS_MAT_MAST-ZSIZE.
      LS_FINAL-BRAND   = LS_MAT_MAST-BRAND.
      LS_FINAL-MOC     = LS_MAT_MAST-MOC.
      LS_FINAL-TYPE    = LS_MAT_MAST-TYPE.
    ENDIF.
    READ TABLE LT_MAT_DESC INTO LS_MAT_DESC WITH KEY MATNR = LS_FINAL-MATNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-MAKTX   = LS_MAT_DESC-MAKTX.

    ENDIF.

************standard cost against material
    READ TABLE LT_MBEW INTO LS_MBEW WITH KEY MATNR = LS_FINAL-MATNR.
    IF SY-SUBRC IS INITIAL.
*      if ls_mbew-VPRSV = 'V'.
*        ls_final-stprs   =  ls_mbew-verpr.
      CONSTANTS : C_VPRSV_S TYPE CHAR1 VALUE 'S'.
      IF LS_MBEW-VPRSV = C_VPRSV_S. "'S'.
        LS_FINAL-STPRS   = LS_MBEW-STPRS.
      ENDIF.
    ENDIF.



*******************latst confirmation date aginst production order so  sort on descending
*    sort lt_mat_doc_101 DESCENDING.
*   READ TABLE lt_mat_doc_101 INTO ls_mat_doc_101 WITH KEY aufnr = ls_mat_doc-aufnr.
    READ TABLE LT_AFRU INTO DATA(LS_AFRU) WITH KEY AUFNR = LS_MAT_DOC-AUFNR
                                                   WABLNR = LS_MAT_DOC-MBLNR.
    IF SY-SUBRC IS INITIAL.
*          IF NOT ls_mat_doc_101-budat_mkpf IS INITIAL.
      IF NOT LS_AFRU-BUDAT IS INITIAL.
*            gv_con_dat = ls_mat_doc_101-budat_mkpf.
        GV_CON_DAT = LS_AFRU-BUDAT.
        CONCATENATE LS_AFRU-BUDAT+6(2) LS_AFRU-BUDAT+4(2) LS_AFRU-BUDAT+0(4)
                INTO LS_FINAL-BUDAT_CON SEPARATED BY '-'.
      ELSE.
        LS_FINAL-BUDAT_CON = ' '.
      ENDIF.
    ENDIF.
*      ENDIF.
*    ENDIF.
    IF GV_LST_ISH IS NOT INITIAL.
      LS_FINAL-DEL_DAT = GV_CON_DAT - GV_LST_ISH .
    ENDIF.

**********    "Material Long Text
    DATA : C_ID     TYPE THEAD-TDID VALUE 'GRUN',
           C_OBJECT TYPE THEAD-TDOBJECT VALUE 'MATERIAL'.

    LV_ID = LS_FINAL-MATNR.
    CLEAR: LT_LINES,LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = C_ID
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = C_OBJECT
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
          CONCATENATE LS_FINAL-LONG_TXT LS_LINES-TDLINE INTO LS_FINAL-LONG_TXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-LONG_TXT.
    ENDIF.
    LS_FINAL-CURR_DATE = SY-DATUM.
*BREAK PRIMUS.

***************************************************new file download******************************


    IF LS_VBEP-EDATU IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_VBEP-EDATU
        IMPORTING
          OUTPUT = WA_FINAL-EDATU.
      CONCATENATE WA_FINAL-EDATU+0(2) WA_FINAL-EDATU+2(3) WA_FINAL-EDATU+5(4)
                      INTO WA_FINAL-EDATU SEPARATED BY '-'.
*CONCATENATE WA_FINAL-EDATU

    ENDIF.
    """""""""""""""""""""Delivery Date
    IF LS_SALES_ORD_ITEM-DELDATE IS NOT INITIAL.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SALES_ORD_ITEM-DELDATE
        IMPORTING
          OUTPUT = WA_FINAL-DELDATE.
      CONCATENATE WA_FINAL-DELDATE+0(2) WA_FINAL-DELDATE+2(3) WA_FINAL-DELDATE+5(4)
                      INTO WA_FINAL-DELDATE SEPARATED BY '-'.
    ENDIF.

    """""""""""""""created date
    IF LS_AUFK-ERDAT IS NOT INITIAL.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_AUFK-ERDAT
        IMPORTING
          OUTPUT = WA_FINAL-CREATED_DATE.
      CONCATENATE WA_FINAL-CREATED_DATE+0(2) WA_FINAL-CREATED_DATE+2(3) WA_FINAL-CREATED_DATE+5(4)
                      INTO WA_FINAL-CREATED_DATE SEPARATED BY '-'.
    ENDIF.


    """"""""""""""""""Confirmation Date
    IF LS_AFRU-BUDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_AFRU-BUDAT
        IMPORTING
          OUTPUT = WA_FINAL-BUDAT_CON.

      CONCATENATE WA_FINAL-BUDAT_CON+0(2) WA_FINAL-BUDAT_CON+2(3) WA_FINAL-BUDAT_CON+5(4)
                      INTO WA_FINAL-BUDAT_CON SEPARATED BY '-'.
    ENDIF.
    """""""""""""""""Inspection Date
    IF LS_MAT_DOC_321-BUDAT_MKPF IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_MAT_DOC_321-BUDAT_MKPF
        IMPORTING
          OUTPUT = WA_FINAL-BUDAT_IN.

      CONCATENATE WA_FINAL-BUDAT_IN+0(2) WA_FINAL-BUDAT_IN+2(3) WA_FINAL-BUDAT_IN+5(4)
                      INTO WA_FINAL-BUDAT_IN SEPARATED BY '-'.

    ENDIF.

    """""""""""""""MRp Date
    IF LS_SALES_ORD_HDR-AEDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SALES_ORD_HDR-AEDAT
        IMPORTING
          OUTPUT = WA_FINAL-AEDAT.

      CONCATENATE WA_FINAL-AEDAT+0(2) WA_FINAL-AEDAT+2(3) WA_FINAL-AEDAT+5(4)
                      INTO WA_FINAL-AEDAT SEPARATED BY '-'.
    ENDIF.

    IF LS_ORDER_HDR-FTRMI IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_ORDER_HDR-FTRMI
        IMPORTING
          OUTPUT = WA_FINAL-FTRMI.

      CONCATENATE WA_FINAL-FTRMI+0(2) WA_FINAL-FTRMI+2(3) WA_FINAL-FTRMI+5(4)
                      INTO WA_FINAL-FTRMI SEPARATED BY '-'.

    ENDIF.


    IF LS_FINAL-CURR_DATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-CURR_DATE
        IMPORTING
          OUTPUT = WA_FINAL-CURR_DATE.

      CONCATENATE WA_FINAL-CURR_DATE+0(2) WA_FINAL-CURR_DATE+2(3) WA_FINAL-CURR_DATE+5(4)
                      INTO WA_FINAL-CURR_DATE SEPARATED BY '-'.

    ENDIF.

    WA_FINAL-INSP_QTY = LS_FINAL-INSP_QTY.
    WA_FINAL-PRUEFLOS = LS_FINAL-PRUEFLOS.
    WA_FINAL-MBLNR_101 = LS_FINAL-MBLNR_101.
    WA_FINAL-MBLNR_321 = LS_FINAL-MBLNR_321.


    WA_FINAL-DISPO = LS_FINAL-DISPO.

    WA_FINAL-BRAND = LS_FINAL-BRAND.

    WA_FINAL-KDAUF = LS_FINAL-KDAUF.

    WA_FINAL-KDPOS = LS_FINAL-KDPOS.
    IF WA_FINAL-KDPOS = 0.
      WA_FINAL-KDPOS = ' '.
    ENDIF.

    WA_FINAL-AUART = LS_FINAL-AUART.

    WA_FINAL-VKBUR = LS_FINAL-VKBUR.

    WA_FINAL-MATNR = LS_FINAL-MATNR.

    WA_FINAL-PRD_AMT = LS_FINAL-PRD_AMT.

    WA_FINAL-PRD_AMT1 = LS_FINAL-PRD_AMT1.

    WA_FINAL-NETPR = LS_FINAL-NETPR.
    IF WA_FINAL-NETPR = '0.00'.
      WA_FINAL-NETPR = ' '.
    ENDIF.
    WA_FINAL-STPRS = LS_FINAL-STPRS.

    WA_FINAL-S_VAL = LS_FINAL-S_VAL.
    IF WA_FINAL-S_VAL = '0.00'.
      WA_FINAL-S_VAL = ' '.
    ENDIF.

    WA_FINAL-S_VAL_LC = LS_FINAL-S_VAL_LC.
    IF WA_FINAL-S_VAL_LC = '0.00'.
      WA_FINAL-S_VAL_LC = ' '.
    ENDIF.

    WA_FINAL-MAKTX = LS_FINAL-MAKTX.

    WA_FINAL-LONG_TXT = LS_FINAL-LONG_TXT.

    WA_FINAL-DAUAT = LS_FINAL-DAUAT.

    WA_FINAL-NAME1 = LS_FINAL-NAME1.

    WA_FINAL-KWMENG = LS_FINAL-KWMENG.
    IF WA_FINAL-KWMENG = '0.00'.
      WA_FINAL-KWMENG = ' '.
    ENDIF.

    WA_FINAL-KDMAT = LS_FINAL-KDMAT.

    WA_FINAL-AUFNR = LS_FINAL-AUFNR.

    WA_FINAL-MENGE = LS_FINAL-MENGE.
    WA_FINAL-MENGE_CONF = LS_FINAL-MENGE_CONF.

    WA_FINAL-WAERK = LS_FINAL-WAERK.

    WA_FINAL-SO_CURR = LS_FINAL-SO_CURR.

    WA_FINAL-BSTKD = LS_FINAL-BSTKD.

    IF WA_FINAL-SO_CURR = 0.
      WA_FINAL-SO_CURR = ' '.
    ENDIF.

    WA_FINAL-KURSK = LS_FINAL-KURSK.
    IF WA_FINAL-KURSK = 0.
      WA_FINAL-KURSK = ' '.
    ENDIF.

    WA_FINAL-ZSERIES = LS_FINAL-ZSERIES.

    WA_FINAL-ZSIZE = LS_FINAL-ZSIZE.

    WA_FINAL-TYPE = LS_FINAL-TYPE.

    WA_FINAL-MOC = LS_FINAL-MOC.

    WA_FINAL-LGORT = LS_FINAL-LGORT.
    WA_FINAL-LGORT1 = LS_FINAL-LGORT1.
    WA_FINAL-CUSTOMER_CODE = LS_FINAL-CUSTOMER_CODE.
*    *********ADDED BY SNEHAL*****
*WA_FINAL-FST_ISH = LS_FINAL-FST_ISH.

    IF GV_FST_ISH IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = GV_FST_ISH
        IMPORTING
          OUTPUT = WA_FINAL-FST_ISH.

      CONCATENATE WA_FINAL-FST_ISH+0(2) WA_FINAL-FST_ISH+2(3) WA_FINAL-FST_ISH+5(4)
                      INTO WA_FINAL-FST_ISH SEPARATED BY '-'.
    ENDIF.

    IF GV_LST_ISH IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = GV_LST_ISH
        IMPORTING
          OUTPUT = WA_FINAL-LST_ISH.

      CONCATENATE WA_FINAL-LST_ISH+0(2) WA_FINAL-LST_ISH+2(3) WA_FINAL-LST_ISH+5(4)
                      INTO WA_FINAL-LST_ISH SEPARATED BY '-'.
    ENDIF.

*WA_FINAL-LST_ISH = LS_FINAL-LST_ISH.

    WA_FINAL-DEL_DAT = LS_FINAL-DEL_DAT.
    CONDENSE WA_FINAL-DEL_DAT.
*   IF WA_FINAL-DEL_DAT < 0.
*      CONCATENATE '-' WA_FINAL-DEL_DAT INTO WA_FINAL-DEL_DAT.
*    ENDIF.
    "    BREAK primus.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-DEL_DAT.


    WA_FINAL-REF_TIME = SY-UZEIT.
    CONCATENATE  WA_FINAL-REF_TIME+0(2) ':'  WA_FINAL-REF_TIME+2(2)  INTO  WA_FINAL-REF_TIME.


********************************
*    APPEND wa_final TO it_final.

    APPEND LS_FINAL TO CT_FINAL.
    CLEAR: LS_FINAL,LS_MAT_DOC,LS_MAT_DOC_101,LS_QALS,LS_QAMB,LS_MBEW,LS_MAT_MAST,LS_CUST_INFO,LS_VBEP,LS_SALES_ORD_HDR,LS_SALES_ORD_ITEM,
           LS_ORDER_ITEM,LS_ORDER_HDR,LS_COEP,LS_VBKD,LV_COST,GV_LST_ISH,GV_CON_DAT,GV_FST_ISH,WA_FINAL, LS_AUFM,LS_QALS,  LS_AUFM_102,
            LS_AUFM_101,WA_COVP,WA_COVP1,LS_MAT_DOC_321,LS_FINAL-MBLNR_321,LV_INDEX.
  ENDLOOP.

*  SORT LT_QAMB BY prueflos MBLNR.
*break primusABAP.
  LOOP AT LT_MAT_DOC_321 INTO LS_MAT_DOC_321.

    READ TABLE LT_QAMB INTO LS_QAMB WITH KEY MBLNR = LS_MAT_DOC_321-MBLNR
                                                MJAHR = LS_MAT_DOC_321-MJAHR.

    READ TABLE CT_FINAL INTO LS_FINAL WITH KEY PRUEFLOS = LS_QAMB-PRUEFLOS.

    IF SY-SUBRC IS INITIAL.
      LS_FINAL-MBLNR_321    = LS_QAMB-MBLNR.
      LS_FINAL-INSP_QTY = LS_MAT_DOC_321-MENGE.
      IF NOT LS_MAT_DOC_321-BUDAT_MKPF IS INITIAL.
        CONCATENATE LS_MAT_DOC_321-BUDAT_MKPF+6(2) LS_MAT_DOC_321-BUDAT_MKPF+4(2) LS_MAT_DOC_321-BUDAT_MKPF+0(4)
                  INTO LS_FINAL-BUDAT_IN SEPARATED BY '-'.
      ELSE.
        LS_FINAL-BUDAT_IN = ' '.
      ENDIF.
      LS_FINAL-LGORT =  LS_MAT_DOC_321-LGORT.
    ENDIF.

    READ TABLE LT_ORDER_HDR INTO LS_ORDER_HDR WITH KEY AUFNR = LS_FINAL-AUFNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-MENGE    =  LS_ORDER_HDR-GAMNG.
    ENDIF.

    READ TABLE LT_ORDER_ITEM INTO LS_ORDER_ITEM WITH KEY AUFNR = LS_FINAL-AUFNR.

    READ TABLE IT_COVP INTO WA_COVP WITH KEY OBJNR = LS_ORDER_ITEM-OBJNR..
    IF SY-SUBRC IS INITIAL.
*      lv_index = sy-tabix.
      CLEAR : LV_COST.
      LOOP AT IT_COVP INTO WA_COVP WHERE OBJNR  = LS_ORDER_ITEM-OBJNR." FROM lv_index.
        IF WA_COVP-OBJNR = LS_ORDER_ITEM-OBJNR .
          LV_COST = LV_COST + WA_COVP-WTGBTR.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    LS_FINAL-PRD_AMT1 = LV_COST.

    READ TABLE IT_COVP1 INTO WA_COVP1 WITH KEY REFBN = LS_FINAL-MBLNR_101 .

    IF SY-SUBRC IS INITIAL.
*      lv_cost1 = lv_cost1 + wa_covp1-wtgbtr.
      LS_FINAL-PRD_AMT = WA_COVP1-WTGBTR.
      LS_FINAL-PRD_AMT = LS_FINAL-PRD_AMT * -1.

    ENDIF.

    APPEND LS_FINAL TO CT_FINAL.
    CLEAR : LS_QAMB,LS_ORDER_HDR, LS_MAT_DOC_321, LS_FINAL,WA_FINAL,WA_COVP1, WA_COVP,LS_ORDER_ITEM.
  ENDLOOP.
*BREAK-POINT.
  LOOP AT CT_FINAL INTO LS_FINAL WHERE MBLNR_321 IS NOT INITIAL.
    READ TABLE CT_FINAL INTO DATA(LS_FINAL1) WITH KEY MBLNR_101 = LS_FINAL-MBLNR_101.
    IF SY-SUBRC IS INITIAL.
      DELETE CT_FINAL WHERE MBLNR_101 = LS_FINAL1-MBLNR_101 AND
*                         ls_final1-menge is INITIAL and
                            INSP_QTY IS INITIAL AND
                            MBLNR_321 IS INITIAL  .
    ENDIF.

  ENDLOOP.


  LOOP AT CT_FINAL INTO LS_FINAL.

    WA_FINAL-INSP_QTY = LS_FINAL-INSP_QTY.
    WA_FINAL-PRUEFLOS = LS_FINAL-PRUEFLOS.
    WA_FINAL-MBLNR_101 = LS_FINAL-MBLNR_101.
    WA_FINAL-MBLNR_321 = LS_FINAL-MBLNR_321.


    WA_FINAL-DISPO = LS_FINAL-DISPO.

    WA_FINAL-BRAND = LS_FINAL-BRAND.

    WA_FINAL-KDAUF = LS_FINAL-KDAUF.

    WA_FINAL-KDPOS = LS_FINAL-KDPOS.
    IF WA_FINAL-KDPOS = 0.
      WA_FINAL-KDPOS = ' '.
    ENDIF.

    WA_FINAL-BSTKD = LS_FINAL-BSTKD.

    WA_FINAL-AUART = LS_FINAL-AUART.

    WA_FINAL-VKBUR = LS_FINAL-VKBUR.

    WA_FINAL-MATNR = LS_FINAL-MATNR.

    WA_FINAL-PRD_AMT = LS_FINAL-PRD_AMT.

    WA_FINAL-PRD_AMT1 = LS_FINAL-PRD_AMT1.

    WA_FINAL-NETPR = LS_FINAL-NETPR.
    IF WA_FINAL-NETPR = '0.00'.
      WA_FINAL-NETPR = ' '.
    ENDIF.
    WA_FINAL-STPRS = LS_FINAL-STPRS.

    WA_FINAL-S_VAL = LS_FINAL-S_VAL.
    IF WA_FINAL-S_VAL = '0.00'.
      WA_FINAL-S_VAL = ' '.
    ENDIF.

    WA_FINAL-LMENGE01 = LS_FINAL-LMENGE01.
    IF WA_FINAL-LMENGE01 = '0.00'.
      WA_FINAL-LMENGE01 = ' '.
    ENDIF.

    WA_FINAL-S_VAL_LC = LS_FINAL-S_VAL_LC.
    IF WA_FINAL-S_VAL_LC = '0.00'.
      WA_FINAL-S_VAL_LC = ' '.
    ENDIF.

    WA_FINAL-MAKTX = LS_FINAL-MAKTX.

    WA_FINAL-LONG_TXT = LS_FINAL-LONG_TXT.

    WA_FINAL-DAUAT = LS_FINAL-DAUAT.

    WA_FINAL-NAME1 = LS_FINAL-NAME1.

    WA_FINAL-KWMENG = LS_FINAL-KWMENG.
    IF WA_FINAL-KWMENG = '0.00'.
      WA_FINAL-KWMENG = ' '.
    ENDIF.

    WA_FINAL-KDMAT = LS_FINAL-KDMAT.

    WA_FINAL-AUFNR = LS_FINAL-AUFNR.

    WA_FINAL-MENGE = LS_FINAL-MENGE.
    WA_FINAL-MENGE_CONF = LS_FINAL-MENGE_CONF.

    WA_FINAL-WAERK = LS_FINAL-WAERK.

    WA_FINAL-SO_CURR = LS_FINAL-SO_CURR.
    IF WA_FINAL-SO_CURR = 0.
      WA_FINAL-SO_CURR = ' '.
    ENDIF.

    WA_FINAL-KURSK = LS_FINAL-KURSK.
    IF WA_FINAL-KURSK = 0.
      WA_FINAL-KURSK = ' '.
    ENDIF.

    WA_FINAL-ZSERIES = LS_FINAL-ZSERIES.

    WA_FINAL-ZSIZE = LS_FINAL-ZSIZE.

    WA_FINAL-TYPE = LS_FINAL-TYPE.

    WA_FINAL-MOC = LS_FINAL-MOC.
    WA_FINAL-BUDAT_CON = LS_FINAL-BUDAT_CON.
    WA_FINAL-BUDAT_IN = LS_FINAL-BUDAT_IN.
    WA_FINAL-AEDAT = LS_FINAL-AEDAT.
    WA_FINAL-FTRMI = LS_FINAL-FTRMI.
    WA_FINAL-CURR_DATE = LS_FINAL-CURR_DATE.

    IF LS_FINAL-CURR_DATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-CURR_DATE
        IMPORTING
          OUTPUT = WA_FINAL-CURR_DATE.

      CONCATENATE WA_FINAL-CURR_DATE+0(2) WA_FINAL-CURR_DATE+2(3) WA_FINAL-CURR_DATE+5(4)
                      INTO WA_FINAL-CURR_DATE SEPARATED BY '-'.

    ENDIF.
    WA_FINAL-EDATU = LS_FINAL-EDATU.
    WA_FINAL-FST_ISH = LS_FINAL-FST_ISH.
    WA_FINAL-LGORT = LS_FINAL-LGORT.
    WA_FINAL-BUDAT_IN = LS_FINAL-BUDAT_IN.
    WA_FINAL-DELDATE = LS_FINAL-DELDATE.

    WA_FINAL-CREATED_DATE = LS_FINAL-CREATED_DATE.

    WA_FINAL-LGORT = LS_FINAL-LGORT.
    WA_FINAL-LGORT1 = LS_FINAL-LGORT1.
    WA_FINAL-CUSTOMER_CODE = LS_FINAL-CUSTOMER_CODE.
*    *********ADDED BY SNEHAL*****
*WA_FINAL-FST_ISH = LS_FINAL-FST_ISH.

    IF LS_FINAL-FST_ISH IS NOT INITIAL.
      CONCATENATE LS_FINAL-FST_ISH+6(4)  LS_FINAL-FST_ISH+3(2) LS_FINAL-FST_ISH+0(2) INTO LS_FINAL-FST_ISH.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-FST_ISH
        IMPORTING
          OUTPUT = WA_FINAL-FST_ISH.

      CONCATENATE WA_FINAL-FST_ISH+0(2) WA_FINAL-FST_ISH+2(3) WA_FINAL-FST_ISH+5(4)
                      INTO WA_FINAL-FST_ISH SEPARATED BY '-'.
    ENDIF.

    IF LS_FINAL-LST_ISH IS NOT INITIAL.
      CONCATENATE LS_FINAL-LST_ISH+6(4)  LS_FINAL-LST_ISH+3(2) LS_FINAL-LST_ISH+0(2) INTO LS_FINAL-LST_ISH.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-LST_ISH
        IMPORTING
          OUTPUT = WA_FINAL-LST_ISH.

      CONCATENATE WA_FINAL-LST_ISH+0(2) WA_FINAL-LST_ISH+2(3) WA_FINAL-LST_ISH+5(4)
                      INTO WA_FINAL-LST_ISH SEPARATED BY '-'.
    ENDIF.

*WA_FINAL-LST_ISH = LS_FINAL-LST_ISH.

    WA_FINAL-DEL_DAT = LS_FINAL-DEL_DAT.
    CONDENSE WA_FINAL-DEL_DAT.
*   IF WA_FINAL-DEL_DAT < 0.
*      CONCATENATE '-' WA_FINAL-DEL_DAT INTO WA_FINAL-DEL_DAT.
*    ENDIF.
    "    BREAK primus.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-DEL_DAT.

    IF LS_FINAL-EDATU IS NOT INITIAL.
*        BREAK primusabap.
      CONCATENATE LS_FINAL-EDATU+6(4)  LS_FINAL-EDATU+3(2) LS_FINAL-EDATU+0(2) INTO LS_FINAL-EDATU.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-EDATU
        IMPORTING
          OUTPUT = WA_FINAL-EDATU.
      CONCATENATE WA_FINAL-EDATU+0(2) WA_FINAL-EDATU+2(3) WA_FINAL-EDATU+5(4)
                      INTO WA_FINAL-EDATU SEPARATED BY '-'.
*CONCATENATE WA_FINAL-EDATU

    ENDIF.
    """""""""""""""""""""Delivery Date
    IF LS_FINAL-DELDATE IS NOT INITIAL.
*          20240615
*      BREAK primusabap.
      CONCATENATE LS_FINAL-DELDATE+6(4)  LS_FINAL-DELDATE+3(2) LS_FINAL-DELDATE+0(2) INTO LS_FINAL-DELDATE.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-DELDATE
        IMPORTING
          OUTPUT = WA_FINAL-DELDATE.
      CONCATENATE WA_FINAL-DELDATE+0(2) WA_FINAL-DELDATE+2(3) WA_FINAL-DELDATE+5(4)
                      INTO WA_FINAL-DELDATE SEPARATED BY '-'.
    ENDIF.

    """""""""""""""created date
    IF LS_FINAL-CREATED_DATE IS NOT INITIAL.

      CONCATENATE LS_FINAL-CREATED_DATE+6(4)  LS_FINAL-CREATED_DATE+3(2) LS_FINAL-CREATED_DATE+0(2) INTO LS_FINAL-CREATED_DATE.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-CREATED_DATE
        IMPORTING
          OUTPUT = WA_FINAL-CREATED_DATE.
      CONCATENATE WA_FINAL-CREATED_DATE+0(2) WA_FINAL-CREATED_DATE+2(3) WA_FINAL-CREATED_DATE+5(4)
                      INTO WA_FINAL-CREATED_DATE SEPARATED BY '-'.
    ENDIF.


    """"""""""""""""""Confirmation Date
    IF LS_FINAL-BUDAT_CON IS NOT INITIAL.
      CONCATENATE LS_FINAL-BUDAT_CON+6(4)  LS_FINAL-BUDAT_CON+3(2) LS_FINAL-BUDAT_CON+0(2) INTO LS_FINAL-BUDAT_CON.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-BUDAT_CON
        IMPORTING
          OUTPUT = WA_FINAL-BUDAT_CON.

      CONCATENATE WA_FINAL-BUDAT_CON+0(2) WA_FINAL-BUDAT_CON+2(3) WA_FINAL-BUDAT_CON+5(4)
                      INTO WA_FINAL-BUDAT_CON SEPARATED BY '-'.
    ENDIF.
    """""""""""""""""Inspection Date
    IF LS_FINAL-BUDAT_IN IS NOT INITIAL.

      CONCATENATE LS_FINAL-BUDAT_IN+6(4)  LS_FINAL-BUDAT_IN+3(2) LS_FINAL-BUDAT_IN+0(2) INTO LS_FINAL-BUDAT_IN.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-BUDAT_IN
        IMPORTING
          OUTPUT = WA_FINAL-BUDAT_IN.

      CONCATENATE WA_FINAL-BUDAT_IN+0(2) WA_FINAL-BUDAT_IN+2(3) WA_FINAL-BUDAT_IN+5(4)
                      INTO WA_FINAL-BUDAT_IN SEPARATED BY '-'.

    ENDIF.

    """""""""""""""MRp Date
    IF LS_FINAL-AEDAT	 IS NOT INITIAL.
*      BREAK primusabap.
      CONCATENATE LS_FINAL-AEDAT+6(4)  LS_FINAL-AEDAT+3(2) LS_FINAL-AEDAT+0(2) INTO LS_FINAL-AEDAT.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-AEDAT
        IMPORTING
          OUTPUT = WA_FINAL-AEDAT.

      CONCATENATE WA_FINAL-AEDAT+0(2) WA_FINAL-AEDAT+2(3) WA_FINAL-AEDAT+5(4)
                      INTO WA_FINAL-AEDAT SEPARATED BY '-'.
    ENDIF.

    IF LS_FINAL-FTRMI IS NOT INITIAL.

      CONCATENATE LS_FINAL-FTRMI+6(4)  LS_FINAL-FTRMI+3(2) LS_FINAL-FTRMI+0(2) INTO LS_FINAL-FTRMI.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-FTRMI
        IMPORTING
          OUTPUT = WA_FINAL-FTRMI.

      CONCATENATE WA_FINAL-FTRMI+0(2) WA_FINAL-FTRMI+2(3) WA_FINAL-FTRMI+5(4)
                      INTO WA_FINAL-FTRMI SEPARATED BY '-'.

    ENDIF.


    IF LS_FINAL-CURR_DATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-CURR_DATE
        IMPORTING
          OUTPUT = WA_FINAL-CURR_DATE.

      CONCATENATE WA_FINAL-CURR_DATE+0(2) WA_FINAL-CURR_DATE+2(3) WA_FINAL-CURR_DATE+5(4)
                      INTO WA_FINAL-CURR_DATE SEPARATED BY '-'.

    ENDIF.


    WA_FINAL-REF_TIME = SY-UZEIT.
    CONCATENATE  WA_FINAL-REF_TIME+0(2) ':'  WA_FINAL-REF_TIME+2(2)  INTO  WA_FINAL-REF_TIME.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.

  ENDLOOP.

  SORT CT_FINAL BY AUFNR.

*  APPEND LINES OF CT_FINAL TO IT_FINAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM DISPLAY  USING    CT_FINAL TYPE TT_FINAL.
  DATA:
    LT_FIELDCAT     TYPE SLIS_T_FIELDCAT_ALV,
    LS_ALV_LAYOUT   TYPE SLIS_LAYOUT_ALV,
    L_CALLBACK_PROG TYPE SY-REPID.

  L_CALLBACK_PROG = SY-REPID.


  PERFORM PREPARE_DISPLAY CHANGING LT_FIELDCAT.
  CLEAR LS_ALV_LAYOUT.
  LS_ALV_LAYOUT-ZEBRA = 'X'.
  LS_ALV_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = L_CALLBACK_PROG
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      IS_LAYOUT          = LS_ALV_LAYOUT
      IT_FIELDCAT        = LT_FIELDCAT
      I_DEFAULT          = 'X'
      I_SAVE             = 'A'
    TABLES
      T_OUTTAB           = CT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM PREPARE_DISPLAY  CHANGING CT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.
  DATA:
    GV_POS      TYPE I,
    LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  REFRESH CT_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DISPO'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-100."'MRP Controller'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BRAND'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-101."'Brand'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KDAUF'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-102."'Sales Order No.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KDPOS'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-103."'Line Item'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AUART'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-132."'Order Type'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VKBUR'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-104."'Sales Office'."(104).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MATNR'.
*  ls_fieldcat-outputlen = '18'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-105."'Material No.'."(105).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MAKTX'.
*  ls_fieldcat-outputlen = '40'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-106."'Item Description'."(106).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LONG_TXT'.
*  ls_fieldcat-outputlen = '40'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-127."'Long Description'."(127).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DAUAT'.
*  ls_fieldcat-outputlen = '21'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-107."'Production Order Type'."(107).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NAME1'.
*  ls_fieldcat-outputlen = '30'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-125."'Customer Name'."(125).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'EDATU'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-126."'So Production Date'."(126).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KWMENG'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-108."'SO QTY.'."(108).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DELDATE'.
*  ls_fieldcat-outputlen = '13'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-109."'Delivery Date'."(109).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KDMAT'.
*  ls_fieldcat-outputlen = '18'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-110."'Customer Item Code'."(110).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AUFNR'.
*  ls_fieldcat-outputlen = '20'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-111."'Production Order No.'."(111).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MENGE'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-112."'QTY.'."(112).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MENGE_CONF'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-141."'QTY.'."(112).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BUDAT_CON'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-113."'Confirmation Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FST_ISH'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-135."'First Issue Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LST_ISH'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-137."'Last Issue Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DEL_DAT'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-138."'Delayed Days'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BUDAT_IN'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-114."'Inspection Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'PRD_AMT'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-115."'Production Amt.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'S_VAL'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-128."'Sales Value(DC)'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'WAERK'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-129."'Currency'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SO_CURR'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-131."'SO Exchange Rate'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KURSK'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-133."'Current Exchange Rate'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'S_VAL_LC'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-130."'Sales Value(LC)'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NETPR'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-116."'Rate'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STPRS'.
*  ls_fieldcat-outputlen = '13'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-117."'Standard Cost'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZSERIES'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-118."'Series'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZSIZE'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-119."'Size'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MOC'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-120."'MOC'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TYPE'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-121."'Type'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LGORT'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-122."'Storage Loc.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AEDAT'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-123."'MRP Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FTRMI'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-124."'Prod.Order Create Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CREATED_DATE'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-139."'Prod.Order Create Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CURR_DATE'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-136."'File Create Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LGORT1'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-134."'SO Storage Loc.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT."


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CUSTOMER_CODE'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-142."'SO Storage Loc.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT."

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'PRD_AMT1'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-143."'aCTUAL Production Amt.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'INSP_QTY'.
*  ls_fieldcat-outputlen = '16'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-144."'Inspection Qty'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'PRUEFLOS'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-145."'Inspection Lot No'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MBLNR_101'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-146."'Inspection Lot No'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MBLNR_321'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-147."'Inspection Lot No'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LMENGE01'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-148."'Inspection Lot No'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BSTKD'.
*  ls_fieldcat-outputlen = '17'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = TEXT-149."'Inspection Lot No'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


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
  IF P_FILENM IS NOT INITIAL.
    FIND '.TXT' IN P_FILENM.
    IF SY-SUBRC = 0.
      LV_FILE  = P_FILENM.
     ELSE.
      CONCATENATE P_FILENM '.TXT' INTO  LV_FILE .
      CONDENSE LV_FILE NO-GAPS.
    ENDIF.

  ELSE.
    LV_FILE = 'ZPRDCOPY_NEW.TXT'.
  ENDIF.

*  LV_FILE = 'ZPRDCOPY_NEW.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPRD Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_2453 TYPE STRING.
    DATA LV_CRLF_2453 TYPE STRING.
    LV_CRLF_2453 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_2453 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_2453 LV_CRLF_2453 WA_CSV INTO LV_STRING_2453.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_473 TO lv_fullfile.
    TRANSFER LV_STRING_2453 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

*************************************************SECOND FILE ***************************************


  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_FINAL
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
  IF P_FILENM IS NOT INITIAL.
    FIND '.TXT' IN P_FILENM.
    IF SY-SUBRC = 0.
      LV_FILE  = P_FILENM.
     ELSE.
      CONCATENATE P_FILENM '.TXT' INTO  LV_FILE .
      CONDENSE LV_FILE NO-GAPS.
    ENDIF.

  ELSE.
    LV_FILE = 'ZPRDCOPY_NEW.TXT'.
  ENDIF.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPRD Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_2490 TYPE STRING.
    DATA LV_CRLF_2490 TYPE STRING.
    LV_CRLF_2490 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_2490 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_2490 LV_CRLF_2490 WA_CSV INTO LV_STRING_2490.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_473 TO lv_fullfile.
    TRANSFER LV_STRING_2490 TO LV_FULLFILE.
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
**************************refresahable file column heading
  CONCATENATE TEXT-100
              TEXT-101
              TEXT-102
              TEXT-103
              TEXT-104
              TEXT-105
              TEXT-106
              TEXT-127
              TEXT-107
              TEXT-125
              TEXT-126
              TEXT-108
              TEXT-109
              TEXT-110
              TEXT-111
              TEXT-112
              TEXT-141
              TEXT-113
              TEXT-114
              TEXT-115
              TEXT-116
              TEXT-117
              TEXT-118
              TEXT-119
              TEXT-120
              TEXT-121
              TEXT-122
              TEXT-123
              TEXT-139
              TEXT-124
              TEXT-129
              TEXT-133
              TEXT-128
              TEXT-130
              TEXT-132
              TEXT-131
              TEXT-135
              TEXT-137
              TEXT-138
              TEXT-134
              TEXT-136
              TEXT-140
              TEXT-142
              TEXT-143
              TEXT-144
              TEXT-145
              TEXT-146
              TEXT-147
              TEXT-148
              TEXT-149
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
