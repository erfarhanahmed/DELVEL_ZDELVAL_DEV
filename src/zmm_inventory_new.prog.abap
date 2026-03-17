*&---------------------------------------------------------------------*
*& Report ZMM_INVENTORY
*&---------------------------------------------------------------------*
*&Modification History
*& Date   |Code |
*&18.08.25|       | Performance Improvement
*&---------------------------------------------------------------------*
REPORT ZMM_INVENTORY_NEW MESSAGE-ID ZDEL.

TYPES : BEGIN OF T_MARA,
          MATNR   TYPE MATNR,     " Material Number
          MEINS	  TYPE MEINS,     "	Base Unit of Measure
          MTART   TYPE MTART,
          ZSERIES TYPE ZSER_CODE, "	series code
          ZSIZE	  TYPE ZSIZE,     "	Size
          BRAND	  TYPE ZBRAND,                              "	Brand1
          MOC	    TYPE ZMOC,      "	MOC
          TYPE    TYPE ZTYP,      " Type
        END OF T_MARA,

        BEGIN OF T_MARC,
          MATNR	TYPE MATNR,     "	Material Number
          WERKS	TYPE WERKS_D,   "	Plant
          EISBE	TYPE EISBE,     "	Safety Stock
*          BSTMI   TYPE BSTMI,    " Minimum Lot Size
        END OF T_MARC,

        TT_MARC TYPE TABLE OF T_MARC,

        BEGIN OF T_MAKT,
          MATNR TYPE MATNR,     " Material Number
          MAKTX TYPE MAKTX,     " Material Description (Short Text)
        END OF T_MAKT,

        BEGIN OF T_MBEW,
          MATNR	TYPE MATNR,     " Material Number
          BWKEY	TYPE BWKEY,     "	Valuation Area
          VPRSV TYPE VPRSV,     " Price Control Indicator
          VERPR TYPE VERPR,      "  Moving Average Price/Periodic Unit Price
          STPRS	TYPE STPRS,	          " Standard price
        END OF T_MBEW,

        BEGIN OF T_MSLB,
          MATNR TYPE MATNR  ,     " Material Number
          "WERKS  TYPE WERKS_D,   " Plant
          LBLAB TYPE LABST  ,     " Valuated Unrestricted-Use Stock
        END OF T_MSLB,

        TT_MSLB TYPE TABLE OF T_MSLB,

        BEGIN OF T_EKPO,
          EBELN  TYPE EBELN,     "  Purchasing Document Number
          EBELP  TYPE EBELP,     "  Item Number of Purchasing Document
          MATNR  TYPE MATNR,     " Material Number
          MENGE  TYPE BSTMG,     " Purchase Order Quantity
          PNDMNG TYPE BSTMG,     " Quantity of Goods Received
        END OF T_EKPO,

        TT_EKPO TYPE TABLE OF T_EKPO,

        BEGIN OF T_EKET,
          EBELN	TYPE EBELN,     "	Purchasing Document Number
          EBELP	TYPE EBELP,     "	Item Number of Purchasing Document
          WEMNG	TYPE WEEMG,     "	Quantity of Goods Received
        END OF T_EKET,

        BEGIN OF T_MSEG,
          MBLNR	     TYPE MBLNR,     " Number of Material Document
          MJAHR      TYPE MJAHR,
          ZEILE      TYPE MBLPO,
          BWART      TYPE BWART,     "  Movement Type (Inventory Management)
          MATNR      TYPE MATNR,
          MENGE      TYPE MENGE_D,   "  Quantity
          SMBLN      TYPE MBLNR,     "  Number of Material Document
          BUDAT_MKPF TYPE BUDAT,
        END OF T_MSEG,

        BEGIN OF T_MSEG1,
          MBLNR	TYPE STRING, "mblnr,     " Number of Material Document
          MJAHR TYPE STRING, "mjahr,
          MATNR TYPE STRING,
          MENGE	TYPE MENGE_D,   "	Quantity
*          smbln  TYPE mblnr,     " Number of Material Document
        END OF T_MSEG1,


        BEGIN OF T_MKPF,
          MBLNR	TYPE MBLNR,     "	Number of Material Document
          MJAHR TYPE MJAHR,
*          cpudt    TYPE cpudt,   " Day On Which Accounting Document Was Entered
          BUDAT TYPE BUDAT,     " Posting Date in the Document
          DSPAN TYPE INT4,
        END OF T_MKPF,

        BEGIN OF T_AFPO,
          AUFNR	TYPE AUFNR,       " Order Number
          PSMNG TYPE CO_PSMNG,    " Order item quantity
          WEMNG TYPE CO_WEMNG,    " Quantity of goods received for the order item
          MATNR	TYPE CO_MATNR,    "	Material Number for Order
        END OF T_AFPO,

        BEGIN OF T_MOQ,
          MATNR TYPE MATNR,       " Material Number
          MINBM TYPE MINBM,       " Minimum Order Quantity
          FLG   TYPE C LENGTH 1,
        END OF T_MOQ,

        BEGIN OF T_MARD,
          MATNR	TYPE MATNR,     "	Material Number
          LGORT TYPE LGORT_D,   " Storage Location
          LABST TYPE LABST,      "  Valuated Unrestricted-Use Stock
          INSME	TYPE INSME,     "	Stock in Quality Inspection
          SPEME TYPE SPEME,
          DISKZ TYPE MARD-DISKZ,
        END OF T_MARD,
*********************ADDED BY JYOTI ON 10.07.2024
        BEGIN OF T_MSKA,
          MATNR TYPE MSKA-MATNR,
          WERKS TYPE MSKA-WERKS,
          LGORT TYPE MSKA-LGORT,
          VBELN TYPE MSKA-VBELN,
          POSNR TYPE MSKA-POSNR,
          KALAB TYPE MSKA-KALAB,
          KAINS TYPE MSKA-KAINS,
          KASPE TYPE MSKA-KASPE,

        END OF T_MSKA,

        BEGIN OF T_RESULT,
          WERKS      TYPE WERKS_D,  " Plant
          MATNR      TYPE MATNR,     " Material Number
          MAKTX      TYPE MAKTX,     " Material Description (Short Text)
          MEINS      TYPE MEINS,     " Base Unit of Measure
*          BSTMI   TYPE ZBSTMI,   " Minimum Order Quantity
          MINBM      TYPE MINBM,     "  EINE-MINBM : Minimum PO Quantity
          TOTREQ     TYPE MENGE_D,   " Total requirement                      changes subodh 23 feb 2018
          SBCNTR     TYPE ZSBCNTRSTK, " Subcontractor Stock
*****          lgort      TYPE mard-lgort,
          MTART      TYPE MARA-MTART,
          ".........................................................
          SL1        TYPE MENGE_D,   " UR stock at storg. Loc. SL01
          SL2        TYPE MENGE_D,   " UR stock at storg. Loc. SL02
*****          sl3        TYPE menge_d,   " UR stock at storg. Loc. SL03
          SL4        TYPE MENGE_D,   " UR stock at storg. Loc. SL04
          SL5        TYPE MENGE_D,   " UR stock at storg. Loc. SL05
          SL6        TYPE MENGE_D,   " UR stock at storg. Loc. SL06
*****          sl7        TYPE menge_d,   " UR stock at storg. Loc. SL07
          SL8        TYPE MENGE_D,   " UR stock at storg. Loc. SL08
          SL9        TYPE MENGE_D,   " UR stock at storg. Loc. SL09
          SL10       TYPE MENGE_D,   " UR stock at storg. Loc. SL10
          SL11       TYPE MENGE_D,   " UR stock at storg. Loc. SL11
          SL12       TYPE MENGE_D,   " UR stock at storg. Loc. SL12
          SL13       TYPE MENGE_D,   " UR stock at storg. Loc. SL13
          SL14       TYPE MENGE_D,   " UR stock at storg. Loc. SL14
          SL15       TYPE MENGE_D,   " UR stock at storg. Loc. SL14
          SL16       TYPE MENGE_D,   " UR stock at storg. Loc. SL14
          SL17       TYPE MENGE_D,   " UR stock at storg. Loc. SL14
*-----------------------Commented By Abhishek Pisolkar (06.04.2018)------------------
*          sl14       TYPE menge_d,   " UR stock at storg. Loc. SL14
*          sl15       TYPE menge_d,   " UR stock at storg. Loc. SL15
*          sl16       TYPE menge_d,   " UR stock at storg. Loc. SL16
*          sl17       TYPE menge_d,   " UR stock at storg. Loc. SL17

*--------------------------------------------------------------------*
          ".........................................................
          UNRST      TYPE ZUNRST,    "  Unrestricted Stock
          INSME      TYPE INSME,     "  Stock in Quality Inspection
          TOTSTCK    TYPE MENGE_D,   " Total stock
          "STKQTY  TYPE ZSTCK,    " Stock Quantity
          SFQTY      TYPE EISBE,     " Safety Stock
          FRINV      TYPE MENGE_D,   " Free Inventory
          ZRATE      TYPE ZRATE,     " Rate

*          SOSTC   TYPE MC_MKABEST," Total sales order stock
*          REQQTY  TYPE BMENGE,    " Required Quantity
*          WIPQTY  TYPE ZWIPQTY,   " WIP Stock

*          FRQTY   TYPE ZFRQTY,    " Free Quantity
          "................................................................
          LT30       TYPE ZLT30,
          VLT30      TYPE ZPRICE,
          BT30_60    TYPE ZBT30_60,
          VBT30_60   TYPE ZPRICE,
          BT60_90    TYPE ZBT60_90,
          VBT60_90   TYPE ZPRICE,
          BT90_120   TYPE ZBT90_120,
          VBT90_120  TYPE ZPRICE,
          BT120_150  TYPE ZBT120_150,
          VBT120_150 TYPE ZPRICE,
          BT150_180  TYPE ZBT150_180,
          VBT150_180 TYPE ZPRICE,
          GT180      TYPE ZGT180,
          VGT180     TYPE ZPRICE,
          "................................................................
          VALUE      TYPE ZPRICE,
          ZSERIES    TYPE ZSER_CODE, " series code
          ZSIZE      TYPE ZSIZE,     " Size
          BRAND      TYPE ZBRAND,                              " Brand1
          MOC        TYPE ZMOC,      " Three-digit character field for IDocs
          TYPE       TYPE ZTYP,      " Three-digit character field for IDocs
*          ref_date TYPE string,         " Added By Abhishek Pisolkar (22.03.2018)
          BUDAT_MKPF TYPE STRING, "budat, " added by md
          SPEME      TYPE SPEME,
**********************ADDEDBY JYOTI ON 05.07.2024
          SL18       TYPE MENGE_D,   " UR stock at storg. Loc. SL18
          SL19       TYPE MENGE_D,   " UR stock at storg. Loc. SL19
          SL20       TYPE MENGE_D,   " UR stock at storg. Loc. SL20
          SL21       TYPE MENGE_D,   " UR stock at storg. Loc. SL21
          SL22       TYPE MENGE_D,   " UR stock at storg. Loc. SL22
          SL23       TYPE MENGE_D,   " UR stock at storg. Loc. SL23
          SL24       TYPE MENGE_D,   " UR stock at storg. Loc. SL24
          SL25       TYPE MENGE_D,   " UR stock at storg. Loc. SL25
          SL26       TYPE MENGE_D,   " UR stock at storg. Loc. SL26
          SL27       TYPE MENGE_D,   " UR stock at storg. Loc. SL27
          SL28       TYPE MENGE_D,   " UR stock at storg. Loc. SL28
          SL29       TYPE MENGE_D,   " UR stock at storg. Loc. SL29
          SL30       TYPE MENGE_D,   " UR stock at storg. Loc. SL30

        END OF T_RESULT,

        TT_RESULT TYPE TABLE OF T_RESULT,

        BEGIN OF T_SL_COL,
          LGORT TYPE LGORT_D,
          COL   TYPE CHAR4,
        END OF T_SL_COL,

        RNG_MATNR TYPE RANGE OF MATNR,
        SO_MATNR  TYPE TABLE OF RNG_MATNR,
        RNG_WERKS TYPE RANGE OF WERKS_D,
        RNG_DATUM TYPE RANGE OF SY-DATUM,
        RNG_LGORT TYPE RANGE OF LGORT_D,
        RNG_MTART TYPE RANGE OF MTART.

DATA : WA_RSLT TYPE T_RESULT,
       IT_RSLT TYPE TT_RESULT,
       SS      TYPE STRING.

FIELD-SYMBOLS : <FS> TYPE ANY.

DATA : LC_MSG    TYPE REF TO CX_SALV_MSG,
       ALV_OBJ   TYPE REF TO CL_SALV_TABLE,
       ALV_FNCTS TYPE REF TO CL_SALV_FUNCTIONS_LIST.
DATA : LV_TABIX TYPE SY-INDEX.

DATA : WA_MARA      TYPE T_MARA,
       WA_MARC      TYPE T_MARC,
       WA_MAKT      TYPE T_MAKT,
       WA_MBEW      TYPE T_MBEW,
       "wa_rslt TYPE t_result,
       WA_MDPS      TYPE MDPS,
       WA_MSEG      TYPE T_MSEG,
       WA_MKPF      TYPE T_MKPF,
       WA_AFPO      TYPE T_AFPO,
       WA_MSLB      TYPE T_MSLB,
       WA_EKPO      TYPE T_EKPO,
       WA_MOQ       TYPE T_MOQ,
       WA_MARD      TYPE T_MARD,
       WA_MSKA      TYPE T_MSKA, "added by  jyoti on 10.07.2024
       WA_SL_COL    TYPE T_SL_COL,

       IT_MARA      TYPE TABLE OF T_MARA,
       IT_MARC      TYPE TABLE OF T_MARC,
       IT_MAKT      TYPE TABLE OF T_MAKT,
       IT_MBEW      TYPE TABLE OF T_MBEW,
       IT_MDPS      TYPE TABLE OF MDPS,
       IT_MSEG      TYPE TABLE OF T_MSEG,
       IT_MSEG1     TYPE TABLE OF T_MSEG,
       IT_MKPF      TYPE TABLE OF T_MKPF,
       IT_AFPO      TYPE TABLE OF T_AFPO,
       "IT_mslb_tmp TYPE TABLE OF T_mslb,
       IT_MSLB      TYPE TABLE OF T_MSLB,
       IT_EKPO      TYPE TABLE OF T_EKPO,
       IT_MOQ_TMP   TYPE TABLE OF T_MOQ,
       IT_MOQ       TYPE TABLE OF T_MOQ,
       IT_MARD      TYPE TABLE OF T_MARD,
       it_mSKA      TYPE TABLE OF t_mSKA,
       IT_SL_COL    TYPE TABLE OF T_SL_COL,
       IT_MSEG3     TYPE TABLE OF T_MSEG1,
       IT_MSEG4     TYPE TABLE OF T_MSEG1,
       IT_MSEG_TEMP TYPE TABLE OF T_MSEG,
       WA_MSEG_TEMP TYPE T_MSEG.

DATA : TMP_QTY TYPE MENGE_D,
       DSPAN   TYPE INT4.
DATA : LS_MSEG3 TYPE T_MSEG1.
********************************************Structure For Download file************************************
*-------------------------------Added By AG DT:19.02.2018-------------------------------------------------
TYPES : BEGIN OF ITAB,
          WERKS      TYPE STRING, "char20,
          MATNR      TYPE STRING, "char100,
          MAKTX      TYPE STRING, "char20,
          MEINS      TYPE STRING, "char20,
          MINBM      TYPE STRING, "char20,
          TOTREQ     TYPE STRING, "char50,
          SBCNTR     TYPE STRING, "char20,
****        lgort      TYPE string,"CHAR15,        // date 06-june-2018 Parag nakhate
          MTART      TYPE STRING, "CHAR50,
          SL1        TYPE STRING, "CHAR50,             "'FINISHED GOODS'
          SL2        TYPE STRING, "CHAR50,             "'PRODUCTION'
*          sl3        TYPE string, "CHAR70,             "'REJECTION'
          SL4        TYPE STRING, "CHAR15,             "'RAW MATERIALS'
          SL5        TYPE STRING, "CHAR50,             "'REWORK'
          SL6        TYPE STRING, "CHAR15,             "'Subcon Stk Loc'
*          sl7        TYPE string, "CHAR50,             "'SCRAP'
          SL8        TYPE STRING, "CHAR10,             "FG Sales Return
          SL9        TYPE STRING, "CHAR10,             "''WIP ASSEMBLED''
          SL10       TYPE STRING, "CHAR20,             "'SPARES & CONSUM'
          SL11       TYPE STRING, "CHAR15,             "'SRN STORES'
          SL12       TYPE STRING, "CHAR5,              "'THIRD PARTY INSP'
          SL13       TYPE STRING, "CHAR50,             "'VALIDATION'
          SL14       TYPE STRING, "CHAR50,             "'QA OK STOCK SL'
          SL15       TYPE STRING, "CHAR50,             "'Planning'
*----------Commented By Abhishek Pisolkar (06.04.2018)-------------
*        sl14       TYPE string,"CHAR50,
*        sl15       TYPE string,"CHAR250,
*        sl16       TYPE string,"CHAR10,
*        sl17       TYPE string,"CHAR15,

*--------------------------------------------------------------------*
          UNRST      TYPE STRING, "CHAR10,
          INSME      TYPE STRING, "CHAR10,
          TOTSTCK    TYPE STRING, "CHAR50,
          SFQTY      TYPE STRING, "CHAR10,
          FRINV      TYPE STRING, "CHAR50,
          ZRATE      TYPE STRING, "CHAR50,
          LT30       TYPE STRING, "CHAR10,
          VLT30      TYPE STRING, "CHAR10,
          BT30_60    TYPE STRING, "CHAR10,
          VBT30_60   TYPE STRING, "CHAR20,
          BT60_90    TYPE STRING, "CHAR80,
          VBT60_90   TYPE STRING, "CHAR50,
          BT90_120   TYPE STRING, "CHAR50,
          VBT90_120  TYPE STRING, "CHAR50,
          BT120_150  TYPE STRING, "CHAR50,
          VBT120_150 TYPE STRING, "CHAR80,
          BT150_180  TYPE STRING, "CHAR80,
          VBT150_180 TYPE STRING, "CHAR80,
          GT180      TYPE STRING, "CHAR10,
          VGT180     TYPE STRING, "CHAR50,
          VALUE      TYPE STRING, "CHAR10,
          ZSERIES    TYPE STRING, "CHAR50,
          ZSIZE      TYPE STRING, "CHAR10,
          BRAND      TYPE STRING, "CHAR20,
          MOC        TYPE STRING, "CHAR15,
          TYPE       TYPE STRING, "CHAR15,
          REF        TYPE STRING, "CHAR15,
          BUDAT_MKPF TYPE STRING,
          SPEME      TYPE STRING,
          SL16       TYPE STRING, "CHAR50,             "'Planning'
          SL17       TYPE STRING, "CHAR50,             "'Planning'
**********************ADDED BY JYOTI ON 05.07.2024***************
          SL18       TYPE STRING, "CHAR20,
          SL19       TYPE STRING, "CHAR100,
          SL20       TYPE STRING, "CHAR100,
          SL21       TYPE STRING, "CHAR50,
          SL22       TYPE STRING, "CHAR10,
*        sl23       TYPE string,"CHAR50,
          SL24       TYPE STRING, "CHAR50,
          SL25       TYPE STRING, "CHAR15,
          SL26       TYPE STRING, "CHAR15,
          SL27       TYPE STRING, "CHAR10,
          SL28       TYPE STRING, "CHAR10,
          SL29       TYPE STRING, "CHAR50,
          SL30       TYPE STRING, "CHAR10,



        END OF ITAB.

DATA : LT_FINAL TYPE TABLE OF ITAB,
       LS_FINAL TYPE ITAB.
*--------------------Added By Abhishek Pisolkar (06.04.2018)-----------------------------------
DATA : IT_FLDCAT TYPE SLIS_T_FIELDCAT_ALV,
       WA_FLDCAT TYPE SLIS_FIELDCAT_ALV,
       WA_LAYOUT TYPE SLIS_LAYOUT_ALV,
       IT_EVENT  TYPE SLIS_T_EVENT,
       WA_EVENT  TYPE SLIS_ALV_EVENT.
*----------------------------------------------------------------------------------------------

INITIALIZATION.
  "SET PF-STATUS 'ZMM_FRINV_STAT1'.
  CLEAR : WA_MARA, WA_MARC, WA_MAKT, WA_MBEW, WA_MDPS, WA_MSLB,
          WA_RSLT, TMP_QTY, WA_MSEG, WA_MKPF, WA_AFPO, DSPAN,
          WA_EKPO, WA_MOQ, WA_MARD, WA_SL_COL.
  REFRESH : IT_MARA, IT_MARC, IT_MAKT, IT_MBEW, IT_MDPS, IT_EKPO,
            IT_MSEG, IT_MKPF, IT_AFPO, IT_MSLB, IT_MOQ, IT_MARD,
            IT_SL_COL.


  SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
    SELECT-OPTIONS V_MATNR FOR WA_RSLT-MATNR.
    PARAMETERS V_WERKS TYPE WERKS_D OBLIGATORY.
*  SELECT-OPTIONS v_lgort FOR wa_rslt-lgort NO INTERVALS.
    SELECT-OPTIONS V_MTART FOR WA_RSLT-MTART.
    "SELECT-OPTIONS V_DATE FOR SY-DATUM  OBLIGATORY.
  SELECTION-SCREEN END OF BLOCK B1.

  SELECTION-SCREEN : BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
    PARAMETERS P_DOWN AS CHECKBOX.
    PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.  " '/Delval/India'."temp'. "'C:/Users/user/Desktop/Delval'.
  SELECTION-SCREEN : END OF BLOCK B2.

  SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-010.
    SELECTION-SCREEN  COMMENT /1(60) TEXT-011.
  SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN .
  IF V_MTART IS INITIAL.
    MESSAGE 'Please Enter Material Type' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN ON V_MATNR.
  IF NOT V_MATNR-LOW IS INITIAL.
    SELECT SINGLE MATNR
      FROM MARA
      INTO WA_RSLT-MATNR
    WHERE MATNR = V_MATNR-LOW.
    IF SY-SUBRC <> 0.
      MESSAGE E011 WITH TEXT-002.
    ENDIF.
  ENDIF.
  IF NOT V_MATNR-HIGH IS INITIAL.
    SELECT SINGLE MATNR
      FROM MARA
      INTO WA_RSLT-MATNR
    WHERE MATNR = V_MATNR-HIGH.
    IF SY-SUBRC <> 0.
      MESSAGE E011 WITH TEXT-002.
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN ON V_WERKS.
  SELECT SINGLE WERKS
    FROM T001W
    INTO WA_RSLT-WERKS
  WHERE WERKS = V_WERKS.
  IF SY-SUBRC <> 0.
    MESSAGE E023.
  ENDIF.

START-OF-SELECTION.
  PERFORM GET_DATA USING V_MATNR[]
                   V_WERKS
*                   v_lgort[]                                              " 25/05/2018
                   V_MTART[]
                   "V_DATE[]
             CHANGING IT_RSLT.

  IF NOT IT_RSLT[] IS INITIAL.
*-----------------------Commented by Abhishek Pisolkar (06.04.2018)----------------
*    PERFORM generate_alv USING it_rslt[] CHANGING alv_obj.
*    PERFORM set_header USING v_matnr[]
*                             v_werks
*                             "V_DATE[]
*                             alv_obj.
*    alv_obj->display( ).
*--------------------------------------------------------------------*
*----------------Added By Abhishek Pisolkar (06.04.2018)-------------
    PERFORM FIELDCAT.
    IF  P_DOWN = 'X'.
      PERFORM DOWNLOAD.
      PERFORM GUI_DOWNLOAD.
    ENDIF.
    PERFORM DISPLAY.
*--------------------------------------------------------------------*
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_WERKS    text
*      -->P_RSLT     text
*----------------------------------------------------------------------*
FORM GET_DATA USING P_MATNR TYPE RNG_MATNR
                    P_WERKS TYPE WERKS_D
*                    p_lgort TYPE rng_lgort                       " 25/05/2018
                    P_MTART TYPE RNG_MTART
                   "P_DATE  TYPE RNG_DATUM
                 CHANGING P_RSLT TYPE TT_RESULT.
  CLEAR P_RSLT.
  " Get Material-Plant info

*BREAK-POINT.
  SELECT MATNR
           LGORT
           LABST
           INSME
           SPEME
           DISKZ  "Added by jyoti on 01.07.2024
      FROM MARD
      INTO TABLE IT_MARD
  WHERE MATNR IN P_MATNR AND WERKS = P_WERKS
    AND DISKZ NE '1'. "ADDED BY JYOTI ON 01.07.2024
* *************************ADDED BY JYOTI ON 10.07.2024
  SELECT MATNR
         WERKS
         LGORT
         VBELN
         POSNR
         KALAB   "inresticted stock
         KAINS   "quality inoection
         KASPE   "blocked stock
    FROM MSKA
    INTO TABLE IT_MSKA
     FOR ALL ENTRIES IN IT_MARD
      WHERE MATNR = IT_MARD-MATNR
    AND MATNR IN P_MATNR
    AND WERKS = P_WERKS.



  SELECT MATNR
         WERKS
         EISBE
*           BSTMI
      FROM MARC
      INTO TABLE IT_MARC
      FOR ALL ENTRIES IN IT_MARD
  WHERE MATNR = IT_MARD-MATNR AND MATNR IN P_MATNR AND WERKS = P_WERKS.

  IF SY-SUBRC = 0.

    " Get Material Details
    SELECT MATNR
         MEINS
         MTART
         ZSERIES
         ZSIZE
         BRAND
         MOC
         TYPE
    FROM MARA
    INTO TABLE IT_MARA
    FOR ALL ENTRIES IN IT_MARC
    WHERE MTART IN P_MTART AND MATNR = IT_MARC-MATNR.

    " get Material Texts
    SELECT MATNR
           MAKTX
      FROM MAKT
      INTO TABLE IT_MAKT
      FOR ALL ENTRIES IN IT_MARA
      WHERE MATNR = IT_MARA-MATNR
    AND SPRAS = SY-LANGU.
    SORT IT_MAKT BY MATNR.

    " Get respective Min.Order Quantities
    SELECT MATNR
           MINBM
      INTO TABLE IT_MOQ_TMP
      FROM EINA
      JOIN EINE ON EINE~INFNR = EINA~INFNR
      FOR ALL ENTRIES IN IT_MARC
      WHERE MATNR = IT_MARC-MATNR
        "and WERKS = it_marc-werks
    .
    IF SY-SUBRC = 0.
      SORT IT_MOQ BY MATNR MINBM DESCENDING.
*      LOOP AT it_moq_tmp INTO wa_moq.  "-- 0033
*        APPEND wa_moq TO it_moq.
*        DELETE it_moq_tmp WHERE matnr = wa_moq-matnr.
*      ENDLOOP.
*++ 003
      IT_MOQ = CORRESPONDING #( IT_MOQ_TMP MAPPING MATNR = MATNR
                                                   MINBM = MINBM ).
      CLEAR: IT_MOQ_TMP.
      SORT IT_MOQ_TMP BY MATNR.
*<<++003
      IF IT_MOQ IS NOT INITIAL.
        SORT IT_MOQ BY MATNR.
      ENDIF.
    ENDIF.

    " Fetch Rate related Info
    SELECT MATNR
           BWKEY
           VPRSV
           VERPR
           STPRS
      FROM MBEW
      INTO TABLE IT_MBEW
      FOR ALL ENTRIES IN IT_MARC
      WHERE MATNR = IT_MARC-MATNR
    AND BWKEY = IT_MARC-WERKS.
    SORT IT_MBEW BY MATNR BWKEY.
    " Get subcontractor-stock details
    PERFORM GET_SUBCONTRACT_STOCK TABLES IT_MARC IT_MSLB IT_EKPO.

    " Get Unrestricted stock Details
*    SELECT matnr
*           lgort
*           labst
*           insme
*      FROM mard
*      INTO TABLE it_mard
*      FOR ALL ENTRIES IN it_marc
*      WHERE matnr = it_marc-matnr
*        AND werks = it_marc-werks AND lgort IN p_lgort.
*    IF sy-subrc = 0.
***************************COMMENTED BY JYOTI IN 16.07.2024
*    DELETE it_mard WHERE lgort CS 'RJ0' OR lgort CS 'SCR' OR lgort CS 'SRN' OR lgort CS 'VLD'
*    or lgort CS 'SLR' OR lgort CS 'SPC'.
***************************ADDED BY JYOTI IN 16.07.2024
    DELETE IT_MARD WHERE LGORT EQ 'RJ01' OR LGORT EQ 'SCR1' OR LGORT EQ 'SRN1' OR LGORT EQ 'VLD1'
    OR LGORT EQ 'SLR1' OR LGORT EQ 'SPC1' OR LGORT EQ 'KRJ0' OR LGORT EQ 'KSCR' OR LGORT EQ 'KSRN'
     OR LGORT EQ 'KVLD'  OR LGORT EQ 'KSLR' .

    DELETE it_mSKA WHERE LGORT EQ 'RJ01' OR LGORT EQ 'SCR1' OR LGORT EQ 'SRN1' OR LGORT EQ 'VLD1'
OR LGORT EQ 'SLR1' OR LGORT EQ 'SPC1' OR LGORT EQ 'KRJ0' OR LGORT EQ 'KSCR' OR LGORT EQ 'KSRN'
 OR LGORT EQ 'KVLD'  OR LGORT EQ 'KSLR' .
*     DELETE it_mard WHERE lgort EQ 'KRJ0' OR lgort EQ 'KSCR' OR lgort EQ 'KSRN' OR lgort EQ 'KVLD'
*    OR lgort EQ 'KSLR' ."OR lgort EQ 'KSPC'.

    LOOP AT IT_MARD INTO WA_MARD.
      CLEAR WA_SL_COL.
      WA_SL_COL-LGORT = WA_MARD-LGORT.
      APPEND WA_SL_COL TO IT_SL_COL.
      CLEAR : WA_MARD.
    ENDLOOP.
*****************ADDED BY JYOTI ON 10.07.2024***
    LOOP AT IT_MSKA INTO WA_MSKA.
      CLEAR WA_SL_COL.
      WA_SL_COL-LGORT = WA_MSKA-LGORT.
      APPEND WA_SL_COL TO IT_SL_COL.
      CLEAR : WA_MSKA.
    ENDLOOP.
**************************************************
    IF IT_SL_COL IS NOT INITIAL.
      SORT IT_SL_COL BY LGORT.
      DELETE ADJACENT DUPLICATES FROM IT_SL_COL COMPARING ALL FIELDS.
    ENDIF.
    SORT IT_MARD BY MATNR LGORT.
  ENDIF.
*BREAK primus.
  " Prepare results
  LOOP AT IT_MARA INTO WA_MARA.
    WA_RSLT-MATNR   = WA_MARA-MATNR.
    WA_RSLT-MEINS   = WA_MARA-MEINS.
    WA_RSLT-MTART   = WA_MARA-MTART.                       " add subodh 22 feb 2018
    WA_RSLT-ZSERIES = WA_MARA-ZSERIES.
    WA_RSLT-ZSIZE   = WA_MARA-ZSIZE.
    WA_RSLT-BRAND   = WA_MARA-BRAND.
    WA_RSLT-MOC     = WA_MARA-MOC.
    WA_RSLT-TYPE    = WA_MARA-TYPE.

    READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_MARA-MATNR.
    IF SY-SUBRC = 0.
*      Replace all OCCURRENCES OF CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB in wa_makt-maktx with space.
      IF WA_MAKT-MAKTX CS '#'.
        CONCATENATE SPACE WA_MAKT-MAKTX INTO WA_RSLT-MAKTX RESPECTING BLANKS.
*      wa_rslt-maktx = wa_makt-maktx.
      ELSE.
        WA_RSLT-MAKTX = WA_MAKT-MAKTX.
      ENDIF.
      WA_RSLT-MAKTX = WA_MAKT-MAKTX.
    ENDIF.

    LOOP AT IT_MARC INTO WA_MARC WHERE MATNR = WA_MARA-MATNR..
      WA_RSLT-WERKS = WA_MARC-WERKS.
*            WA_RSLT-BSTMI = WA_MARC-BSTMI.

      " Minimum Order Quantity
      READ TABLE IT_MOQ INTO WA_MOQ WITH KEY MATNR = WA_MARC-MATNR.
      IF SY-SUBRC = 0.
        WA_RSLT-MINBM = WA_MOQ-MINBM.
      ENDIF.

      " Rate
      READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MARA-MATNR
                                               BWKEY = WA_MARC-WERKS.
      IF SY-SUBRC = 0.
        IF WA_MBEW-VPRSV = 'V'.
          WA_RSLT-ZRATE = WA_MBEW-VERPR.
        ELSEIF WA_MBEW-VPRSV = 'S'.
          WA_RSLT-ZRATE = WA_MBEW-STPRS.
        ENDIF.
      ENDIF.

      " Total Requirement
      REFRESH IT_MDPS.
      IF NOT WA_RSLT-WERKS IS INITIAL.
        CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
          EXPORTING
            MATNR                    = WA_RSLT-MATNR
            WERKS                    = WA_RSLT-WERKS
          TABLES
            MDPSX                    = IT_MDPS
          EXCEPTIONS
            MATERIAL_PLANT_NOT_FOUND = 1
            PLANT_NOT_FOUND          = 2
            OTHERS                   = 3.
        IF SY-SUBRC <> 0.
*                MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ELSEIF NOT IT_MDPS[] IS INITIAL.
          LOOP AT IT_MDPS INTO WA_MDPS.
            IF WA_MDPS-DELKZ = 'VC' OR WA_MDPS-DELKZ = 'SB'
              OR WA_MDPS-DELKZ = 'U1' OR WA_MDPS-DELKZ = 'U2'
              OR WA_MDPS-DELKZ = 'PP'
              OR ( WA_MDPS-DELKZ = 'BB' AND WA_MDPS-PLAAB <> 26 )
              OR ( WA_MDPS-DELKZ = 'AR' AND WA_MDPS-PLUMI <> '+' )
              OR ( WA_MDPS-DELKZ = 'KB' AND WA_MDPS-PLUMI <> 'B' ).
              WA_RSLT-TOTREQ = WA_RSLT-TOTREQ + WA_MDPS-MNG01.
            ENDIF.
            CLEAR WA_MDPS.
          ENDLOOP.
        ENDIF.
      ENDIF.

      " Subcontractor stock
      READ TABLE IT_MSLB INTO WA_MSLB WITH KEY MATNR = WA_MARC-MATNR.
      IF SY-SUBRC = 0.
        WA_RSLT-SBCNTR = WA_MSLB-LBLAB.
      ENDIF.

      LOOP AT IT_EKPO INTO WA_EKPO WHERE MATNR = WA_MARC-MATNR.
        WA_RSLT-SBCNTR = WA_RSLT-SBCNTR + WA_EKPO-PNDMNG.
        CLEAR WA_EKPO.
      ENDLOOP.
*-----------------------------------Added By Abhishek Pisolkar (04.04.2018)----------------
*      data : lv_lines TYPE i.
**      DESCRIBE TABLE it_mard LINES lv_lines.
*      LOOP AT it_mard INTO wa_mard WHERE matnr = wa_marc-matnr.
*      lv_lines = lv_lines + 1.
*      ENDLOOP.
*      if lv_lines > 1.
*      LOOP AT it_mard INTO wa_mard WHERE matnr = wa_marc-matnr and labst <> ' '.
**        if .
*        wa_rslt-lgort = wa_mard-lgort.
*        clear wa_mard.
**        ELSE.
**          wa_rslt-lgort = wa_mard-lgort.
**          ENDIF.
*       endloop.
*        ELSE.
*          READ TABLE it_mard INTO wa_mard WITH key matnr = wa_marc-matnr.
*          IF sy-subrc = 0.
*          wa_rslt-lgort = wa_mard-lgort.
*          CLEAR wa_mard.
*          ENDIF.
*        ENDIF.
*        clear lv_lines.
*--------------------------------------------------------------------*

      LOOP AT IT_MARD INTO WA_MARD WHERE MATNR = WA_MARC-MATNR.
*****        wa_rslt-lgort = wa_mard-lgort.                                            " add subodh 22 feb 2018

        " Unrestricted Stock
        CLEAR SS.
        READ TABLE IT_SL_COL INTO WA_SL_COL WITH KEY LGORT = WA_MARD-LGORT.
*--------------Commented by Abhishek Pisolkar (06.04.2018)------------
*        ss = sy-tabix."sy-index.
*        "concatenate 'WA_RSLT-SL' wa_mard-lgort into ss.
*        CONCATENATE 'WA_RSLT-SL' ss INTO ss.
*        ASSIGN (ss) TO <fs>.
*        <fs> = wa_mard-labst.
*--------------------------------------------------------------------*
*--------------------Added By Abhishek Pisolkar (06.04.2018)-------------
******************ADDED BY JYOTI ON 04.07.2024******************************
        IF WA_SL_COL-LGORT+0(1) = 'K'.

          IF WA_SL_COL-LGORT = 'KFG0'.           " Finished Goods
            WA_RSLT-SL18 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KPRD'.       " Production
            WA_RSLT-SL19 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KRJ0'.      " Rejection  NO need to dispaly
*****          wa_rslt-sl3 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'KRM0'.      " Raw Materials
            WA_RSLT-SL20 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KRWK'.      " Rework
            WA_RSLT-SL21 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KSC0'.      " Subcon
            WA_RSLT-SL22 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KSCR'.      " Scrap   NO need to dispaly
*****          wa_rslt-sl23 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'KSFG'.      " WIP assembled
            WA_RSLT-SL24 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KSLR'.      " FG Sales Return
            WA_RSLT-SL25 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KSPC'.      " Spares & Consum
            WA_RSLT-SL26 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KSRN'.      " SRN Stores
*****          wa_rslt-sl27 = wa_mard-labst.  commented to exclude SRN1 storage location
          ELSEIF WA_SL_COL-LGORT = 'KTPI'.      " Third Party
            WA_RSLT-SL28 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'KVLD'.      " Validation
*****          wa_rslt-sl29 = wa_mard-labst.  "commented to exclude VLD1 storage location
          ELSEIF WA_SL_COL-LGORT = 'KPR1'.      " KPR1
            WA_RSLT-SL30 = WA_MARD-LABST.
*        ELSEIF wa_sl_col-lgort = 'KPLG'.      " Planning            " 25/05/2018
*          wa_rslt-sl31 = wa_mard-labst.
*        ELSEIF wa_sl_col-lgort = 'SAN1'.      " Planning            " 25/05/2018
*          wa_rslt-sl32 = wa_mard-labst.
*         ELSEIF wa_sl_col-lgort = 'KMCN'.      " Planning            " 25/05/2018
*          wa_rslt-sl33 = wa_mard-labst.
          ENDIF.
*******************ENDED BY JYOTI ON 04.07.2024***************************************************
        ELSE.
          IF WA_SL_COL-LGORT = 'FG01'.           " Finished Goods
            WA_RSLT-SL1 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'PRD1'.       " Production
            WA_RSLT-SL2 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'RJ01'.      " Rejection
*****          wa_rslt-sl3 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'RM01'.      " Raw Materials
            WA_RSLT-SL4 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'RWK1'.      " Rework
            WA_RSLT-SL5 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'SC01'.      " Subcon
            WA_RSLT-SL6 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'SCR1'.      " Scrap
*****          wa_rslt-sl7 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'SFG1'.      " WIP assembled
            WA_RSLT-SL8 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'SLR1'.      " FG Sales Return
            WA_RSLT-SL9 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'SPC1'.      " Spares & Consum
            WA_RSLT-SL10 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'SRN1'.      " SRN Stores
*****          wa_rslt-sl11 = wa_mard-labst.  commented to exclude SRN1 storage location
          ELSEIF WA_SL_COL-LGORT = 'TPI1'.      " Third Party
            WA_RSLT-SL12 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'VLD1'.      " Validation
*****          wa_rslt-sl13 = wa_mard-labst.  "commented to exclude VLD1 storage location
          ELSEIF WA_SL_COL-LGORT = 'TR01'.      " QA OK STOCK SL            " 25/05/2018
            WA_RSLT-SL14 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'PLG1'.      " Planning            " 25/05/2018
            WA_RSLT-SL15 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'SAN1'.      " Planning            " 25/05/2018
            WA_RSLT-SL16 = WA_MARD-LABST.
          ELSEIF WA_SL_COL-LGORT = 'MCN1'.      " Planning            " 25/05/2018
            WA_RSLT-SL17 = WA_MARD-LABST.
          ENDIF.
        ENDIF.
*--------------------------------------------------------------------*

        WA_RSLT-UNRST = WA_RSLT-UNRST + WA_MARD-LABST.
        WA_RSLT-SPEME = WA_RSLT-SPEME + WA_MARD-SPEME.
        UNASSIGN <FS>.

        " Stock in Quality Inspection
        WA_RSLT-INSME = WA_RSLT-INSME + WA_MARD-INSME.
        CLEAR : WA_MARD,WA_SL_COL .
      ENDLOOP. "(05.04.2018)
*********************added by jyoti on 10.07.2024*****************************
      LOOP AT IT_MSKA INTO WA_MSKA WHERE MATNR = WA_MARC-MATNR.

        READ TABLE IT_SL_COL INTO WA_SL_COL WITH KEY LGORT = WA_MSKA-LGORT.

        IF WA_SL_COL-LGORT+0(1) = 'K'.

          IF WA_SL_COL-LGORT = 'KFG0'.           " Finished Goods
            WA_RSLT-SL18 =  WA_RSLT-SL18 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KPRD'.       " Production
            WA_RSLT-SL19 = WA_RSLT-SL19 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KRJ0'.      " Rejection  NO need to dispaly
*****          wa_rslt-sl3 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'KRM0'.      " Raw Materials
            WA_RSLT-SL20 =  WA_RSLT-SL20 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KRWK'.      " Rework
            WA_RSLT-SL21 = WA_RSLT-SL21 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KSC0'.      " Subcon
            WA_RSLT-SL22 = WA_RSLT-SL22 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KSCR'.      " Scrap   NO need to dispaly
*****          wa_rslt-sl23 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'KSFG'.      " WIP assembled
            WA_RSLT-SL24 = WA_RSLT-SL24 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KSLR'.      " FG Sales Return
            WA_RSLT-SL25 = WA_RSLT-SL25 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KSPC'.      " Spares & Consum
            WA_RSLT-SL26 = WA_RSLT-SL26 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KSRN'.      " SRN Stores
*****          wa_rslt-sl27 = wa_mard-labst.  commented to exclude SRN1 storage location
          ELSEIF WA_SL_COL-LGORT = 'KTPI'.      " Third Party
            WA_RSLT-SL28 =  WA_RSLT-SL28 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'KVLD'.      " Validation
*****          wa_rslt-sl29 = wa_mard-labst.  "commented to exclude VLD1 storage location
          ELSEIF WA_SL_COL-LGORT = 'KPR1'.      " KPR1
            WA_RSLT-SL30 = WA_RSLT-SL30 + WA_MSKA-KALAB.
*        ELSEIF wa_sl_col-lgort = 'KPLG'.      " Planning            " 25/05/2018
*          wa_rslt-sl31 = wa_mard-labst.
*        ELSEIF wa_sl_col-lgort = 'SAN1'.      " Planning            " 25/05/2018
*          wa_rslt-sl32 = wa_mard-labst.
*         ELSEIF wa_sl_col-lgort = 'KMCN'.      " Planning            " 25/05/2018
*          wa_rslt-sl33 = wa_mard-labst.
          ENDIF.
*******************ENDED BY JYOTI ON 04.07.2024***************************************************
        ELSE.
          IF WA_SL_COL-LGORT = 'FG01'.           " Finished Goods
            WA_RSLT-SL1 = WA_RSLT-SL1 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'PRD1'.       " Production
            WA_RSLT-SL2 = WA_RSLT-SL2 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'RJ01'.      " Rejection
*****          wa_rslt-sl3 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'RM01'.      " Raw Materials
            WA_RSLT-SL4 = WA_RSLT-SL4 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'RWK1'.      " Rework
            WA_RSLT-SL5 = WA_RSLT-SL5 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'SC01'.      " Subcon
            WA_RSLT-SL6 = WA_RSLT-SL6 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'SCR1'.      " Scrap
*****          wa_rslt-sl7 = wa_mard-labst.
          ELSEIF WA_SL_COL-LGORT = 'SFG1'.      " WIP assembled
            WA_RSLT-SL8 = WA_RSLT-SL6 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'SLR1'.      " FG Sales Return
            WA_RSLT-SL9 = WA_RSLT-SL9 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'SPC1'.      " Spares & Consum
            WA_RSLT-SL10 = WA_RSLT-SL9 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'SRN1'.      " SRN Stores
*****          wa_rslt-sl11 = wa_mard-labst.  commented to exclude SRN1 storage location
          ELSEIF WA_SL_COL-LGORT = 'TPI1'.      " Third Party
            WA_RSLT-SL12 =  WA_RSLT-SL12 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'VLD1'.      " Validation
*****          wa_rslt-sl13 = wa_mard-labst.  "commented to exclude VLD1 storage location
          ELSEIF WA_SL_COL-LGORT = 'TR01'.      " QA OK STOCK SL            " 25/05/2018
            WA_RSLT-SL14 = WA_RSLT-SL14 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'PLG1'.      " Planning            " 25/05/2018
            WA_RSLT-SL15 = WA_RSLT-SL15 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'SAN1'.      " Planning            " 25/05/2018
            WA_RSLT-SL16 = WA_RSLT-SL16 + WA_MSKA-KALAB.
          ELSEIF WA_SL_COL-LGORT = 'MCN1'.      " Planning            " 25/05/2018
            WA_RSLT-SL17 = WA_RSLT-SL17 + WA_MSKA-KALAB.
          ENDIF.
        ENDIF.



        WA_RSLT-UNRST = WA_RSLT-UNRST + WA_MSKA-KALAB.
        WA_RSLT-SPEME = WA_RSLT-SPEME + WA_MSKA-KASPE.
        " Stock in Quality Inspection
        WA_RSLT-INSME = WA_RSLT-INSME + WA_MSKA-KAINS.
        CLEAR WA_MSKA.
      ENDLOOP.
************************************************************************


      " Total Stock
      WA_RSLT-TOTSTCK = WA_RSLT-SBCNTR + WA_RSLT-UNRST + WA_RSLT-INSME.

      " Safety Stock
      WA_RSLT-SFQTY = WA_MARC-EISBE.

      " Free Inventory
      WA_RSLT-FRINV = WA_RSLT-TOTSTCK - WA_RSLT-TOTREQ.

      IF WA_RSLT-FRINV > 0.
        " Value
        WA_RSLT-VALUE = WA_RSLT-ZRATE * WA_RSLT-FRINV.

        " Free Stock Aging
        SELECT MBLNR
               MJAHR
               ZEILE
               BWART
               MATNR
               MENGE
               SMBLN
               BUDAT_MKPF
          FROM MSEG
          INTO TABLE IT_MSEG
          WHERE BWART IN ('101', '102', '561', '562' ,'531' ,'532',  '309' ,'311','411','412','501','653','701', 'Z11' ,'542','262',
          '602','301','413','344','Z42','202','343','312','544','166' )
              AND WERKS = WA_RSLT-WERKS
        AND MATNR = WA_RSLT-MATNR.
        IF SY-SUBRC = 0.
          SORT IT_MSEG BY MBLNR DESCENDING.
          LOOP AT IT_MSEG INTO WA_MSEG WHERE BWART = '102' OR BWART = '562' OR BWART = '532'
         OR BWART = '122' OR BWART = '161' OR BWART = '162'  OR BWART = '202' OR BWART = '261'
   OR BWART = '312' OR BWART = '322'  OR BWART = '532' OR BWART = '543' OR BWART = '562' OR BWART = '602' OR BWART = '702' OR BWART = '541'.
            DELETE IT_MSEG WHERE MBLNR = WA_MSEG-SMBLN OR MBLNR = WA_MSEG-MBLNR.
          ENDLOOP.
          IF NOT IT_MSEG[] IS INITIAL.
***            SORT it_mseg BY mblnr mjahr DESCENDING.
            CLEAR TMP_QTY.
            TMP_QTY = WA_RSLT-FRINV.

            LOOP AT IT_MSEG INTO DATA(LS_MSEG2).
              LS_MSEG3-MBLNR = LS_MSEG2-MBLNR.
              LS_MSEG3-MJAHR = LS_MSEG2-MJAHR.
              LS_MSEG3-MATNR = LS_MSEG2-MATNR.
              LS_MSEG3-MENGE = LS_MSEG2-MENGE.
*             ls_mseg3-budat_mkpf = ls_mseg2-budat_mkpf.
              APPEND LS_MSEG3 TO IT_MSEG3.
            ENDLOOP.

            SORT IT_MSEG3 BY MBLNR MJAHR MATNR DESCENDING.
            LOOP AT IT_MSEG3 INTO LS_MSEG3.
              COLLECT LS_MSEG3 INTO IT_MSEG4.
            ENDLOOP.
            FIELD-SYMBOLS : <F1> TYPE T_MSEG.

            DELETE ADJACENT DUPLICATES FROM IT_MSEG COMPARING MBLNR MJAHR.

            LOOP AT IT_MSEG ASSIGNING  <F1> .
              READ TABLE IT_MSEG4 INTO LS_MSEG3 WITH KEY MBLNR = <F1>-MBLNR MJAHR = <F1>-MJAHR MATNR = <F1>-MATNR.
              IF SY-SUBRC = 0.
                <F1>-MENGE = LS_MSEG3-MENGE.
              ENDIF.
            ENDLOOP.


            LOOP AT IT_MSEG INTO WA_MSEG.
              IF WA_MSEG-MENGE <= TMP_QTY.
                TMP_QTY = TMP_QTY - WA_MSEG-MENGE.

                """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                WA_MSEG_TEMP = WA_MSEG.                   "Added by swati on 08.01.2018
                APPEND WA_MSEG_TEMP TO IT_MSEG_TEMP.      "Added by swati on 08.01.20180
                """""""""""""""""""""""""""""""""""""""""""""""""""""'


                IF TMP_QTY = 0.
                  EXIT.
                ENDIF.
              ELSE.
                WA_MSEG-MENGE =  TMP_QTY.

                """"""""""""""""""""""""""""""""""""""""""""""""""""
                WA_MSEG_TEMP = WA_MSEG.               "Added by swati on 08.01.2018
                APPEND WA_MSEG_TEMP TO IT_MSEG_TEMP.   "Added by swati on 08.01.2018
                """""""""""""""""""""""""""""""""""""""""'


                MODIFY IT_MSEG FROM WA_MSEG TRANSPORTING MENGE WHERE MBLNR = WA_MSEG-MBLNR AND MJAHR = WA_MSEG-MJAHR ."and matnr = wa_mseg-matnr.
                EXIT.
              ENDIF.
              CLEAR WA_MSEG.
            ENDLOOP.
            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
*            *Added by swati on 08.1.2018
            LOOP AT IT_MSEG INTO WA_MSEG.
              LV_TABIX = SY-TABIX.
              READ TABLE IT_MSEG_TEMP INTO WA_MSEG_TEMP WITH  KEY MBLNR = WA_MSEG-MBLNR
                                                             ZEILE = WA_MSEG-ZEILE.
              IF SY-SUBRC <> 0.
                DELETE IT_MSEG INDEX LV_TABIX.
              ENDIF.
              CLEAR :WA_MSEG,WA_MSEG_TEMP.
            ENDLOOP.





***            DELETE it_mseg WHERE mblnr < wa_mseg-mblnr.

            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*           sort it_mseg by mblnr mjahr matnr.
*           delete ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr mjahr matnr.
            IF NOT IT_MSEG[] IS INITIAL.
              SELECT MBLNR
                     MJAHR
                     "cpudt
                     BUDAT
                FROM MKPF
                INTO TABLE IT_MKPF
                FOR ALL ENTRIES IN IT_MSEG
              WHERE MBLNR = IT_MSEG-MBLNR.
              IF SY-SUBRC = 0.
                LOOP AT IT_MKPF INTO WA_MKPF.
                  CLEAR : DSPAN, WA_MSEG.
                  READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MBLNR = WA_MKPF-MBLNR MJAHR = WA_MKPF-MJAHR.
                  "dspan = sy-datum - wa_mkpf-cpudt.
                  WA_RSLT-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF. " added by md
                  DSPAN = SY-DATUM - WA_MKPF-BUDAT.
                  IF DSPAN < 30.
                    WA_RSLT-LT30 = WA_RSLT-LT30 + WA_MSEG-MENGE.
                  ELSEIF DSPAN BETWEEN 30 AND 60.
                    WA_RSLT-BT30_60 = WA_RSLT-BT30_60 + WA_MSEG-MENGE.
                  ELSEIF DSPAN BETWEEN 60 AND 90.
                    WA_RSLT-BT60_90 = WA_RSLT-BT60_90 + WA_MSEG-MENGE.
                  ELSEIF DSPAN BETWEEN 90 AND 120.
                    WA_RSLT-BT90_120 = WA_RSLT-BT90_120 + WA_MSEG-MENGE.
                  ELSEIF DSPAN BETWEEN 120 AND 150.
                    WA_RSLT-BT120_150 = WA_RSLT-BT120_150 + WA_MSEG-MENGE.
                  ELSEIF DSPAN BETWEEN 150 AND 180.
                    WA_RSLT-BT150_180 = WA_RSLT-BT150_180 + WA_MSEG-MENGE.
                  ELSE.
                    WA_RSLT-GT180 = WA_RSLT-GT180 + WA_MSEG-MENGE.
                  ENDIF.
                  CLEAR WA_MKPF.
                ENDLOOP.

                WA_RSLT-VLT30     = WA_RSLT-ZRATE * WA_RSLT-LT30.
                WA_RSLT-VBT30_60  = WA_RSLT-ZRATE * WA_RSLT-BT30_60.
                WA_RSLT-VBT60_90  = WA_RSLT-ZRATE * WA_RSLT-BT60_90.
                WA_RSLT-VBT90_120 = WA_RSLT-ZRATE * WA_RSLT-BT90_120.
                WA_RSLT-VBT120_150 = WA_RSLT-ZRATE * WA_RSLT-BT120_150.
                WA_RSLT-VBT150_180 = WA_RSLT-ZRATE * WA_RSLT-BT150_180.
                WA_RSLT-VGT180     = WA_RSLT-ZRATE * WA_RSLT-GT180.

              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        CLEAR WA_RSLT-FRINV.

      ENDIF.

***********************************************Dowanload Data*********************************************
*-------------------------------Added By AG DT:19.02.2018-------------------------------------------------
      LS_FINAL-WERKS            =         WA_RSLT-WERKS       .
      LS_FINAL-MATNR            =         WA_RSLT-MATNR       .
      LS_FINAL-MAKTX            =         WA_RSLT-MAKTX       .
      LS_FINAL-MEINS            =         WA_RSLT-MEINS       .
      LS_FINAL-MINBM            =         WA_RSLT-MINBM       .
      LS_FINAL-TOTREQ           =         WA_RSLT-TOTREQ      .
      LS_FINAL-SBCNTR           =         WA_RSLT-SBCNTR      .
**       ls_FINAL-lgort            =         wa_rslt-lgort       .        Date 06 june 2018 Parag Nakhate

      LS_FINAL-MTART            =         WA_RSLT-MTART       .
      LS_FINAL-SL1              =         WA_RSLT-SL1         .          "'FINISHED GOODS'
      LS_FINAL-SL2              =         WA_RSLT-SL2         .          "'PRODUCTION'
*      ls_final-sl3              =         wa_rslt-sl3         .          "'REJECTION'
      LS_FINAL-SL4              =         WA_RSLT-SL4         .          "'RAW MATERIALS'
      LS_FINAL-SL5              =         WA_RSLT-SL5         .          "'REWORK'
      LS_FINAL-SL6              =         WA_RSLT-SL6         .          "'Subcon Stk Loc'
*      ls_final-sl7              =         wa_rslt-sl7         .          "'SCRAP'
      LS_FINAL-SL8              =         WA_RSLT-SL8         .          "'WIP ASSEMBLED'
      LS_FINAL-SL9              =         WA_RSLT-SL9         .          "'FG Sales Return'
      LS_FINAL-SL10             =         WA_RSLT-SL10        .          "'SPARES & CONSUM'
      LS_FINAL-SL11             =         WA_RSLT-SL11        .          "'SRN STORES'
      LS_FINAL-SL12             =         WA_RSLT-SL12        .          "'THIRD PARTY INSP'
      LS_FINAL-SL13             =         WA_RSLT-SL13        .          "'VALIDATION'
      LS_FINAL-SL14             =         WA_RSLT-SL14        .          "'QA OK STOCK SL'
      LS_FINAL-SL15             =         WA_RSLT-SL15        .          "'QA OK STOCK SL'
      LS_FINAL-SL16             =         WA_RSLT-SL16        .          "'QA OK STOCK SL'
      LS_FINAL-SL17             =         WA_RSLT-SL17        .          "'QA OK STOCK SL'

*       ls_FINAL-sl14             =         wa_rslt-sl14        .
*       ls_FINAL-sl15             =         wa_rslt-sl15        .
*       ls_FINAL-sl16             =         wa_rslt-sl16        .
*       ls_FINAL-sl17             =         wa_rslt-sl17        .

      LS_FINAL-UNRST            =         WA_RSLT-UNRST       .
      LS_FINAL-INSME            =         WA_RSLT-INSME       .
      LS_FINAL-TOTSTCK          =         WA_RSLT-TOTSTCK     .
      LS_FINAL-SFQTY            =         WA_RSLT-SFQTY       .
      LS_FINAL-FRINV            =         WA_RSLT-FRINV       .
      LS_FINAL-ZRATE            =         WA_RSLT-ZRATE       .
      LS_FINAL-LT30             =         WA_RSLT-LT30        .
      LS_FINAL-VLT30            =         WA_RSLT-VLT30       .
      LS_FINAL-BT30_60          =         WA_RSLT-BT30_60     .
      LS_FINAL-VBT30_60         =         WA_RSLT-VBT30_60    .
      LS_FINAL-BT60_90          =         WA_RSLT-BT60_90     .
      LS_FINAL-VBT60_90         =         WA_RSLT-VBT60_90    .
      LS_FINAL-BT90_120         =         WA_RSLT-BT90_120    .
      LS_FINAL-VBT90_120        =         WA_RSLT-VBT90_120   .
      LS_FINAL-BT120_150        =         WA_RSLT-BT120_150   .
      LS_FINAL-VBT120_150       =         WA_RSLT-VBT120_150  .
      LS_FINAL-BT150_180        =         WA_RSLT-BT150_180   .
      LS_FINAL-VBT150_180       =         WA_RSLT-VBT150_180  .
      LS_FINAL-GT180            =         WA_RSLT-GT180       .
      LS_FINAL-VGT180           =         WA_RSLT-VGT180      .
      LS_FINAL-VALUE            =         WA_RSLT-VALUE       .
      LS_FINAL-ZSERIES          =         WA_RSLT-ZSERIES     .
      LS_FINAL-ZSIZE            =         WA_RSLT-ZSIZE       .
      LS_FINAL-BRAND            =         WA_RSLT-BRAND       .
      LS_FINAL-MOC              =         WA_RSLT-MOC         .
      LS_FINAL-TYPE             =         WA_RSLT-TYPE        .

      CALL FUNCTION 'CONVERSION_EXIT_SDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_RSLT-BUDAT_MKPF
        IMPORTING
          OUTPUT = LS_FINAL-BUDAT_MKPF.

      REPLACE ALL OCCURRENCES OF '.' IN LS_FINAL-BUDAT_MKPF WITH '-'.

      WA_RSLT-BUDAT_MKPF = LS_FINAL-BUDAT_MKPF.


*      ls_final-budat_mkpf       =         wa_rslt-budat_mkpf . " added by md
      LS_FINAL-SPEME            =         WA_RSLT-SPEME.
      LS_FINAL-REF              =         SY-DATUM.



*BREAK-POINT.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-REF
        IMPORTING
          OUTPUT = LS_FINAL-REF.

      CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                      INTO LS_FINAL-REF SEPARATED BY '-'.

***********************added by jyoti on 05.07.2024*****************************
      ls_FINAL-SL18             =         WA_RSLT-SL18        .
      ls_FINAL-SL19             =         WA_RSLT-SL19        .
      ls_FINAL-SL20             =         WA_RSLT-SL20        .
      ls_FINAL-SL21             =         WA_RSLT-SL21        .
      ls_FINAL-SL22             =         WA_RSLT-SL22        .
*       ls_FINAL-sl23             =         wa_rslt-sl23        .
      ls_FINAL-SL24             =         WA_RSLT-SL24        .
      ls_FINAL-SL25             =         WA_RSLT-SL25        .
      ls_FINAL-SL26             =         WA_RSLT-SL26        .
      ls_FINAL-SL27             =         WA_RSLT-SL27        .
      ls_FINAL-SL28             =         WA_RSLT-SL28        .
      ls_FINAL-SL29             =         WA_RSLT-SL29        .
      ls_FINAL-SL30             =         WA_RSLT-SL30        .
*--------------------------------------------------------------------------------------------------
*BREAK-POINT.
      IF WA_RSLT-FRINV NE 0 . " No line item if free inventory is zero
        APPEND LS_FINAL TO LT_FINAL.       " Added By Abhishek Pisolkar (22.03.2018)
        APPEND WA_RSLT TO P_RSLT.
      ENDIF.
      CLEAR : WA_RSLT, WA_MSLB, WA_MBEW, WA_MOQ, LS_FINAL,LS_MSEG3.
    ENDLOOP.
*BREAK-POINT.
    CLEAR : WA_MARA, WA_MARC, WA_MAKT, WA_MBEW, WA_RSLT, LS_FINAL.
    REFRESH : IT_MSEG3, IT_MSEG4.
  ENDLOOP.
*  ENDIF.
ENDFORM.                    "GET_DATA

*&---------------------------------------------------------------------*
*&      Form  GENERATE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RSLT     text
*      -->ALV_OBJ    text
*----------------------------------------------------------------------*
FORM GENERATE_ALV USING P_RSLT TYPE TT_RESULT
                  CHANGING ALV_OBJ TYPE REF TO CL_SALV_TABLE.

  DATA : LV_COLUMNS TYPE REF TO CL_SALV_COLUMNS,
         LV_COLUMN  TYPE REF TO CL_SALV_COLUMN,
         O_LAYOUT   TYPE REF TO CL_SALV_LAYOUT,
         KEY        TYPE SALV_S_LAYOUT_KEY.

  IF NOT P_RSLT[] IS INITIAL.
    TRY.
        CALL METHOD CL_SALV_TABLE=>FACTORY
          IMPORTING
            R_SALV_TABLE = ALV_OBJ
          CHANGING
            T_TABLE      = P_RSLT[].
      CATCH CX_SALV_MSG INTO LC_MSG .
    ENDTRY.

    " Enable Save Layout Option
    O_LAYOUT = ALV_OBJ->GET_LAYOUT( ).
    KEY-REPORT = SY-REPID.
    O_LAYOUT->SET_KEY( KEY ).
    CALL METHOD O_LAYOUT->SET_SAVE_RESTRICTION
      EXPORTING
        VALUE = IF_SALV_C_LAYOUT=>RESTRICT_NONE.

    LV_COLUMNS = ALV_OBJ->GET_COLUMNS( ).
    LV_COLUMN = LV_COLUMNS->GET_COLUMN('TOTREQ').
    LV_COLUMN->SET_SHORT_TEXT( 'Tot.Req.' ).
    LV_COLUMN->SET_MEDIUM_TEXT( 'Tot Requirement' ).
    LV_COLUMN->SET_LONG_TEXT( 'Total Requirement' ).

    LV_COLUMN = LV_COLUMNS->GET_COLUMN('TOTSTCK').
    LV_COLUMN->SET_SHORT_TEXT( 'Total Stck' ).
    LV_COLUMN->SET_MEDIUM_TEXT( 'Total Stock' ).
    LV_COLUMN->SET_LONG_TEXT( 'Total Stock' ).

    LV_COLUMN = LV_COLUMNS->GET_COLUMN('FRINV').
    LV_COLUMN->SET_SHORT_TEXT( 'Free Invnt' ).
    LV_COLUMN->SET_MEDIUM_TEXT( 'Free Inventory' ).
    LV_COLUMN->SET_LONG_TEXT( 'Free Inventory' ).

    PERFORM DETERMINE_STRG_LOC_COLUMNS.

    " Default functions
    ALV_FNCTS = ALV_OBJ->GET_FUNCTIONS( ).
    ALV_FNCTS->SET_ALL( ABAP_TRUE ).
  ENDIF.
ENDFORM.                    "GENERATE_ALV

*&---------------------------------------------------------------------*
*&      Form  SET_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_WERKS    text
*      -->ALV_OBJ    text
*----------------------------------------------------------------------*
FORM SET_HEADER USING P_MATNR TYPE RNG_MATNR
                      P_WERKS TYPE WERKS_D
                      "P_DATE  TYPE RNG_DATUM
                      ALV_OBJ TYPE REF TO CL_SALV_TABLE.

  DATA : LYOT_TXT  TYPE REF TO CL_SALV_FORM_LAYOUT_GRID,
         LYOT_LBL  TYPE REF TO CL_SALV_FORM_LABEL,
         LYOT_FLOW TYPE REF TO CL_SALV_FORM_LAYOUT_FLOW,
         LINE      TYPE STRING,
         WA_MATNR  LIKE LINE OF P_MATNR,
         VAR_I     TYPE I.

  CREATE OBJECT LYOT_TXT.

  " Header Text (In Bold)
*    LYOT_LBL = LYOT_TXT->CREATE_LABEL( ROW = 1 COLUMN = 1 TEXT = 'Selection Criteria : ').
*
*    VAR_I = 2.
*    IF NOT P_MATNR IS INITIAL.
*      VAR_I = VAR_I + 1.
*      LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
*      LYOT_FLOW->CREATE_TEXT( TEXT = 'Material(s) : ' ).
*
*      LOOP AT P_MATNR INTO WA_MATNR.
*        LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
*        IF WA_MATNR-SIGN = 'E'.
*          LINE = 'Excluding -'.
*        ELSE.
*          LINE = 'Including -'.
*        ENDIF.
*        IF WA_MATNR-HIGH IS INITIAL.
*          CONCATENATE LINE WA_MATNR-LOW INTO LINE SEPARATED BY space.
*        ELSE.
*          CONCATENATE LINE WA_MATNR-LOW 'To' WA_MATNR-HIGH INTO LINE SEPARATED BY space.
*        ENDIF.
*        LYOT_FLOW->CREATE_TEXT( TEXT = LINE ).
*        VAR_I = VAR_I + 1.
*        CLEAR WA_MATNR.
*      ENDLOOP.
*    ENDIF.
*
*    VAR_I = VAR_I + 1.
*    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
*    LYOT_FLOW->CREATE_TEXT( TEXT = 'Plant : ' ).
*
*
*    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
*    LYOT_FLOW->CREATE_TEXT( TEXT = P_WERKS ).
*
*
*
**    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
**    LYOT_FLOW->CREATE_TEXT( TEXT = 'Duration : ' ).
**
**
**    LOOP AT P_DATE INTO WA_DATE.
**      LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
**      CONCATENATE WA_DATE-LOW ' - ' WA_DATE-HIGH INTO LINE.
**      LYOT_FLOW->CREATE_TEXT( TEXT = LINE ).
**      VAR_I = VAR_I + 1.
**      CLEAR WA_DATE.
**    ENDLOOP.
*
**    VAR_I = VAR_I + 1.
**    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
**    LYOT_FLOW->CREATE_TEXT( TEXT = '.' ).

  VAR_I = VAR_I + 1.
  LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
  LYOT_FLOW->CREATE_TEXT( TEXT = 'Date of Report Generation : ' ).

  LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
  LYOT_FLOW->CREATE_TEXT( TEXT = SY-DATUM ).
  VAR_I = VAR_I + 1.

  ALV_OBJ->SET_TOP_OF_LIST( LYOT_TXT ).

ENDFORM.                    "SET_HEADER
*&---------------------------------------------------------------------*
*&      Form  GET_SUBCONTRACT_STOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_SUBCONTRACT_STOCK TABLES PIT_MARC TYPE TT_MARC
                                  PIT_MSLB TYPE TT_MSLB
                                  PIT_EKPO TYPE TT_EKPO
                              .
  DATA : WA_MSLB     TYPE T_MSLB,
         IT_MSLB_TMP TYPE TABLE OF T_MSLB,
         WA_EKET     TYPE T_EKET,
         WA_EKPO     TYPE T_EKPO,
         IT_EKET     TYPE TABLE OF T_EKET
         .

  REFRESH : IT_MSLB_TMP, PIT_MSLB.
  SELECT MATNR
         LBLAB
    INTO TABLE IT_MSLB_TMP
    FROM MSLB
    FOR ALL ENTRIES IN PIT_MARC[]
    WHERE MATNR = PIT_MARC-MATNR
  AND WERKS = PIT_MARC-WERKS.
  IF SY-SUBRC = 0.
    SORT IT_MSLB_TMP BY MATNR.
    LOOP AT IT_MSLB_TMP INTO WA_MSLB.
      COLLECT WA_MSLB INTO PIT_MSLB.
      CLEAR WA_MSLB.
    ENDLOOP.
    REFRESH IT_MSLB_TMP.
    SORT PIT_MSLB BY MATNR.
  ENDIF.

*  select ebeln
*         ebelp
*         matnr
*         menge   " PNDMNG
*    into table pit_ekpo
*    from ekpo
*    for all entries in pit_marc
*    where matnr = pit_marc-matnr
*      and werks = pit_marc-werks
*      and ELIKZ  = space.
*  IF sy-subrc = 0.
*    select ebeln
*           ebelp
*           WEMNG
*      from eket
*      into table it_eket
*      for all entries in pit_ekpo
*      where ebeln = pit_ekpo-ebeln
*        and ebelp = pit_ekpo-ebelp.
*    IF sy-subrc = 0.
*      LOOP AT pit_ekpo into wa_ekpo.
*        wa_ekpo-pndmng = wa_ekpo-menge.
*        LOOP AT it_eket into wa_eket where ebeln = wa_ekpo-ebeln
*                                       and ebelp = wa_ekpo-ebelp.
*          wa_ekpo-pndmng = wa_ekpo-pndmng - WA_eket-WEMNG.
*          clear wa_eket.
*        ENDLOOP.
*        if WA_EKPO-pndmng > 0.
*          modify pit_ekpo from wa_ekpo
*            transporting pndmng
*            where ebeln = wa_ekpo-ebeln
*              and ebelp = wa_ekpo-ebelp.
*        endif.
*        clear wa_ekpo.
*      ENDLOOP.
*      IF sy-subrc = 0.
*        sort pit_ekpo by matnr.
*      ENDIF.
*    ENDIF.
*  ENDIF.
ENDFORM.                    " GET_SUBCONTRACT_STOCK
*&---------------------------------------------------------------------*
*&      Form  DETERMINE_STRG_LOC_COLUMNS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DETERMINE_STRG_LOC_COLUMNS.
  TYPES : BEGIN OF T_LGORT,
            LGORT TYPE LGORT_D, " Storage Location
            LGOBE	TYPE LGOBE,   " Description of Storage Location
          END OF T_LGORT.
  DATA : WA_LGORT    TYPE T_LGORT,
         WA_MARD     TYPE T_MARD,
         IT_LGORT    TYPE TABLE OF T_LGORT,
         LV_COLUMN   TYPE REF TO CL_SALV_COLUMN_TABLE,
         LV_COLUMNS  TYPE REF TO CL_SALV_COLUMNS_TABLE,
         COLUMNNAME	 TYPE LVC_FNAME,
         STR         TYPE STRING,
         STR_S       TYPE SCRTEXT_S,
         STR_M       TYPE SCRTEXT_M,
         O_COLOR     TYPE LVC_S_COLO,
         LVREC_COUNT TYPE I VALUE 0.

  O_COLOR-COL = 4.
  O_COLOR-INT = 1.
  O_COLOR-INV = 0.
*BREAK primus.
  SELECT DISTINCT
      LGORT
      LGOBE
    INTO TABLE IT_LGORT
    FROM T001L
  WHERE WERKS = V_WERKS.
  IF SY-SUBRC = 0.
    SORT IT_LGORT BY LGORT.
    LV_COLUMNS = ALV_OBJ->GET_COLUMNS( ).
  ENDIF.

*  DO 30 TIMES.         " Commented By Abhishek Pisolkar (06.04.2018)
  DO 13 TIMES.
    STR = SY-INDEX.
    CONCATENATE 'SL' STR INTO COLUMNNAME.
    TRY.
        LV_COLUMN ?= LV_COLUMNS->GET_COLUMN( COLUMNNAME ).
      CATCH CX_SALV_NOT_FOUND.
    ENDTRY.

    READ TABLE IT_SL_COL INTO WA_SL_COL INDEX SY-INDEX.
    IF SY-SUBRC = 0.
      IF LV_COLUMN IS NOT INITIAL.
        READ TABLE IT_LGORT INTO WA_LGORT
          WITH KEY LGORT = WA_SL_COL-LGORT.
        STR_S = WA_LGORT-LGORT.
        STR_M = WA_LGORT-LGOBE.
        LV_COLUMN->SET_SHORT_TEXT( STR_S ).
        LV_COLUMN->SET_MEDIUM_TEXT( STR_M ).
        "lv_column->set_long_text( str1 ).

        LV_COLUMN->SET_COLOR( O_COLOR ).
      ENDIF.
    ELSE.
      LV_COLUMN->SET_VISIBLE( SPACE ).
    ENDIF.
    CLEAR : WA_LGORT, WA_SL_COL, LV_COLUMN, COLUMNNAME.
  ENDDO.
  IF  P_DOWN = 'X'.
    PERFORM DOWNLOAD.
    PERFORM GUI_DOWNLOAD.
  ENDIF.

ENDFORM.                    " DETERMINE_STRG_LOC_COLUMNS
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*-------------------------------Added By AG DT:19.02.2018-------------------------------------------------

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
*BREAK primus.
  REFRESH IT_CSV.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    EXPORTING
      I_FIELD_SEPERATOR    = 'X'
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      I_TAB_SAP_DATA       = LT_FINAL    "it_rslt                  "LT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*  CALL FUNCTION 'SAP_CONVERT_TO_TEX_FORMAT'
*    EXPORTING
*      i_field_seperator          =  ','
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    tables
*      i_tab_sap_data             = lt_final
*   CHANGING
*     I_TAB_CONVERTED_DATA       = it_csv
*   EXCEPTIONS
*     CONVERSION_FAILED          = 1
*     OTHERS                     = 2
*            .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


  PERFORM CVS_HEADER USING HD_CSV.
  LV_FILE = 'ZMM_FRINVENTORY_NEW.TXT'.
*  CONCATENATE p_folder '\' lv_file
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.
*BREAK primus.
  WRITE: / 'ZMM_FRINVENTORY started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT .  "ENCODING UTF-8.                 "ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1581 TYPE STRING.
    DATA LV_CRLF_1581 TYPE STRING.
    LV_CRLF_1581 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1581 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1581 LV_CRLF_1581 WA_CSV INTO LV_STRING_1581.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_2634 TO lv_fullfile.
*TRANSFER lv_string_1332 TO lv_fullfile.
*TRANSFER lv_string_1332 TO lv_fullfile.
*TRANSFER lv_string_734 TO lv_fullfile.
    TRANSFER LV_STRING_1581 TO LV_FULLFILE.
  ENDIF.
  CLOSE DATASET LV_FULLFILE.
  CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
  MESSAGE LV_MSG TYPE 'S'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE   'Plant'                      "1
                'Material'                   "2
                'Material Description'       "3
                'Unit'                       "4
                'Minimum Order Qty'          "5
                'Total Requirement'          "6
                'Subcontractor Stck.'        "7
*              'Stor. Loc.'                 "8
                'Matl Type'                  "9
                'FINISHED GOODS'        "sl1 "10
                'PRODUCTION'
*                'REJECTION'
                'RAW MATERIALS'         "sl2  11
                'REWORK'                "sl3  12
                'Subcon Stk Loc'        "sl4  13
*                'SCRAP'
                'WIP ASSEMBLED'         "sl5  14
                'FG Sales Return'       "sl6  15
                'SPARES & CONSUM'
                'SRN STORES'
                'THIRD PARTY INSP'      "sl7  16
                'VALIDATION'
                'QA OK STOCK SL'                                       " 25/05/2018
                'Planning'                                             " 25/05/2018
                'Unrestricted Stock'          " 17
                'In Quality Insp.'            "18
                'Total Stock'                 " 19
                'Safety stock'                "20
                'Free Inventory'              "21
                'Rate'                           "24 45
                '< 30 Days'                      "46
                'Value'                          "47
                'Btwn 30-60 Days'                "48
                'Value'                          "49
                'Btwn 60-90 Days'                "50
                'Value'                          "51
                'Btwn 90-120 Days'               "52
                'Value'                          "53
                'Btwn 120-150 Days'              "54
                'Value'                          "55
                'Btwn 150-180 Days'              "56
                'Value'                          "57
                '> 180 Days'                     "58
                'Value'                          "59
                'Value'                          "60
                'seri code'                      "61
                'size'                           "62
                'Brand'                          "63
                'MOC'                            "64
                'Type'                           "65
                'Refresh Date'                   "66
                'Last usage date'                     " 67
                'Blocked Stock'                     " 68
                'Sangavi Stock'                " 68
                'Machine Stock'                " 68
*********************ADDED BY JYTO ION 05.07.2024*******************
                 'KPR FINISHED GOODS'
                 'KPR PRODUCTION'
                 'KPR RAW MATERIALS'
                 'KPR REWORK'
                 'KPR Subcon Stk Loc'
                 'KPR WIP ASSEMBLED'
                 'KPR FG Sales Return'
                 'KPR SPARES & CONSUM'
                 'KPR SRN STORES'
                 'KPR THIRD PARTY INSP'
                 'KPR VALIDATION'
                 'KPR1'
**********************************************************************
                INTO P_HD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
*-----------------------------------------------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GUI_DOWNLOAD .
  TYPES : BEGIN OF LS_FIELDNAME,
            FIELD_NAME(25),
          END OF LS_FIELDNAME.

  DATA : IT_FIELDNAME TYPE TABLE OF LS_FIELDNAME.
  DATA : WA_FIELDNAME TYPE LS_FIELDNAME.
*----------------Fieldnames---------------------------------------------------------
  WA_FIELDNAME-FIELD_NAME = 'Plant'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  CLEAR WA_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Material'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  CLEAR WA_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Material Description'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  CLEAR WA_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Unit'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  CLEAR WA_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Minimum Order Qty'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  CLEAR WA_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Total Requirement'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  CLEAR WA_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Subcontractor Stck.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Stor. Loc.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Matl Type'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'FINISHED GOODS'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'PRODUCTION'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  wa_fieldname-field_name = 'REJECTION'.
*  APPEND wa_fieldname TO it_fieldname.
  WA_FIELDNAME-FIELD_NAME = 'RAW MATERIALS'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
  WA_FIELDNAME-FIELD_NAME = 'REWORK'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Subcon Stk Loc'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

*  wa_fieldname-field_name = 'Scrap'.
*  APPEND wa_fieldname TO it_fieldname.
*
  WA_FIELDNAME-FIELD_NAME = 'WIP ASSEMBLED' .
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
  WA_FIELDNAME-FIELD_NAME = 'FG Sales Return'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'SPARES & CONSUM'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'SRN STORES'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
**--------------------------------------------------------------------*
  WA_FIELDNAME-FIELD_NAME = 'THIRD PARTY INSP'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'VALIDATION'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.


  WA_FIELDNAME-FIELD_NAME = 'QA OK STOCK SL'.             " 25/05/2018
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Planning'.                   " 25/05/2018
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

*--------------------------------------------------------------------*
  WA_FIELDNAME-FIELD_NAME = 'Unrestricted Stock'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'In Quality Insp'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Total Stock'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Safety Stock'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Free Inventory'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Rate'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = '< 30 Days'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Btwn 30-60 Days'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Btwn 60-90 Days'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Btwn 90-120 Days'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Btwn 120-150 Days'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Btwn 150-180 Days'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = '> 180 Days'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Value'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Seri Code.'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Size'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Brand'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'MOC'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Type'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Refreshable date'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Last usage date'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Blocked Stock'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'Sangavi Stock'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

**********************ADDED BYJYOTI  ON 05.07.2024************
  WA_FIELDNAME-FIELD_NAME = 'KPR FINISHED GOODS'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR PRODUCTION'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR RAW MATERIALS'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
  WA_FIELDNAME-FIELD_NAME = 'KPR REWORK'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR Subcon Stk Loc'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

*  wa_fieldname-field_name = 'Scrap'.
*  APPEND wa_fieldname TO it_fieldname.
*
  WA_FIELDNAME-FIELD_NAME = 'KPR WIP ASSEMBLED' .
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
  WA_FIELDNAME-FIELD_NAME = 'KPR FG Sales Return'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR SPARES & CONSUM'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR SRN STORES'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR THIRD PARTY INSP'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR VALIDATION'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  WA_FIELDNAME-FIELD_NAME = 'KPR1'.
  APPEND WA_FIELDNAME TO IT_FIELDNAME.
**--------------------------------------------------------------------*
*************************************************************
*  BREAK primus.
*--------------------------------------------------------------------*
  DATA FILE TYPE STRING VALUE 'F:\ZMMFRINV.TXT'.
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE            =
      FILENAME                = FILE
      FILETYPE                = 'ASC'
*     APPEND                  = ' '
      WRITE_FIELD_SEPARATOR   = 'X'
*     HEADER                  = '00'
*     TRUNC_TRAILING_BLANKS   = ' '
*     WRITE_LF                = 'X'
*     COL_SELECT              = ' '
*     COL_SELECT_MASK         = ' '
*     DAT_MODE                = ' '
*     CONFIRM_OVERWRITE       = ' '
*     NO_AUTH_CHECK           = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     WRITE_BOM               = ' '
*     TRUNC_TRAILING_BLANKS_EOL       = 'X'
*     WK1_N_FORMAT            = ' '
*     WK1_N_SIZE              = ' '
*     WK1_T_FORMAT            = ' '
*     WK1_T_SIZE              = ' '
*     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*     SHOW_TRANSFER_STATUS    = ABAP_TRUE
*     VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
* IMPORTING
*     FILELENGTH              =
    TABLES
      DATA_TAB                = LT_FINAL
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
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELDCAT .
  PERFORM CATALOG USING '' '' 'WERKS' 'IT_RSLT' 'Plant' ''.
  PERFORM CATALOG USING '' '' 'MATNR' 'IT_RSLT' 'Mateial No' ''.
  PERFORM CATALOG USING '' '' 'MAKTX' 'IT_RSLT' 'Description' ''.
  PERFORM CATALOG USING '' '' 'MEINS' 'IT_RSLT' 'Unit' ''.
  PERFORM CATALOG USING '' '' 'MINBM' 'IT_RSLT' 'PO Quantity' ''.
  PERFORM CATALOG USING '' '' 'TOTREQ' 'IT_RSLT' 'Total Requirment' ''.
  PERFORM CATALOG USING '' '' 'SBCNTR' 'IT_RSLT' 'Suncontractor Stock' ''.
*PERFORM catalog USING '' '' 'LGORT' 'IT_RSLT' 'Storage Location' ''.
  PERFORM CATALOG USING '' '' 'MTART' 'IT_RSLT' 'Material Type' ''.
  PERFORM CATALOG USING '' '' 'SL1' 'IT_RSLT' 'FINISHED GOODS' 'C100'.
  PERFORM CATALOG USING '' '' 'SL2' 'IT_RSLT' 'PRODUCTION' 'C100'.
*  PERFORM catalog USING '' '' 'SL3' 'IT_RSLT' 'REJECTION' 'C100'.
  PERFORM CATALOG USING '' '' 'SL4' 'IT_RSLT' 'RAW MATERIALS' 'C100'.
  PERFORM CATALOG USING '' '' 'SL5' 'IT_RSLT' 'REWORK' 'C100'.
  PERFORM CATALOG USING '' '' 'SL6' 'IT_RSLT' 'Subcon Stk Loc' 'C100'.
*  PERFORM catalog USING '' '' 'SL7' 'IT_RSLT' 'SCRAP' 'C100'.
  PERFORM CATALOG USING '' '' 'SL8' 'IT_RSLT' 'WIP ASSEMBELED' 'C100'.
  PERFORM CATALOG USING '' '' 'SL9' 'IT_RSLT' 'FG Sales Return' 'C100'.
  PERFORM CATALOG USING '' '' 'SL10' 'IT_RSLT' 'SPARES & CONSUM' 'C100'.
  PERFORM CATALOG USING '' '' 'SL11' 'IT_RSLT' 'SRN STORES' 'C100'.
  PERFORM CATALOG USING '' '' 'SL12' 'IT_RSLT' 'THIRD PARTY INSP' 'C100'.
  PERFORM CATALOG USING '' '' 'SL13' 'IT_RSLT' 'VALIDATION' 'C100'.
  PERFORM CATALOG USING '' '' 'SL14' 'IT_RSLT' 'QA OK STOCK SL' 'C100'.                      " 25/05/2018
  PERFORM CATALOG USING '' '' 'SL15' 'IT_RSLT' 'Planning' 'C100'.                            " 25/05/2018
  PERFORM CATALOG USING '' '' 'UNRST' 'IT_RSLT' 'Unrestricted Stock' ''.
  PERFORM CATALOG USING '' '' 'INSME' 'IT_RSLT' 'Stock in Quality Inspection' ''.
  PERFORM CATALOG USING '' '' 'TOTSTCK' 'IT_RSLT' 'Total Stock' ''.
  PERFORM CATALOG USING '' '' 'SFQTY' 'IT_RSLT' 'Safety Stock' ''.
  PERFORM CATALOG USING '' '' 'FRINV' 'IT_RSLT' 'Free Inventory' ''.
  PERFORM CATALOG USING '' '' 'ZRATE' 'IT_RSLT' 'Rate' ''.
  PERFORM CATALOG USING '' '' 'LT30' 'IT_RSLT' '<30 Days' ''.
  PERFORM CATALOG USING '' '' 'VLT30' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'BT30_60' 'IT_RSLT' 'Btwn 30-60 Days' ''.
  PERFORM CATALOG USING '' '' 'VBT30_60' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'BT60_90' 'IT_RSLT' 'Btwn 60-90 Days' ''.
  PERFORM CATALOG USING '' '' 'VBT60_90' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'BT90_120' 'IT_RSLT' 'Btwn 90-120 Days' ''.
  PERFORM CATALOG USING '' '' 'VBT90_120' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'BT120_150' 'IT_RSLT' 'Btwn 120-150 Days' ''.
  PERFORM CATALOG USING '' '' 'VBT120_150' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'BT150_180' 'IT_RSLT' 'Btwn 150-180 Days' ''.
  PERFORM CATALOG USING '' '' 'VBT150_180' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'GT180' 'IT_RSLT' '>180 Days' ''.
  PERFORM CATALOG USING '' '' 'VGT180' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'VALUE' 'IT_RSLT' 'Value' ''.
  PERFORM CATALOG USING '' '' 'ZSERIES' 'IT_RSLT' 'Seri Code' ''.
  PERFORM CATALOG USING '' '' 'ZSIZE' 'IT_RSLT' 'Size' ''.
  PERFORM CATALOG USING '' '' 'BRAND' 'IT_RSLT' 'Brand' ''.
  PERFORM CATALOG USING '' '' 'MOC' 'IT_RSLT' 'MOC' ''.
  PERFORM CATALOG USING '' '' 'TYPE' 'IT_RSLT' 'Type' ''.
  PERFORM CATALOG USING '' '' 'BUDAT_MKPF' 'IT_RSLT' 'Last usage date' ''.
  PERFORM CATALOG USING '' '' 'SPEME' 'IT_RSLT' 'Blocked Stock' ''.
  PERFORM CATALOG USING '' '' 'SL16' 'IT_RSLT' 'Sangavi Stock' 'C100'.                      " 13/09/2023
  PERFORM CATALOG USING '' '' 'SL17' 'IT_RSLT' 'Machine Stock' 'C100'.                            " 13/09/2023
******************************Addded by jyoti o n05.07.2024*****************************
  PERFORM CATALOG USING '' '' 'SL18' 'IT_RSLT' 'KPR FINISHED GOODS' 'C100'.
  PERFORM CATALOG USING '' '' 'SL19' 'IT_RSLT' 'KPRPRODUCTION' 'C100'.
*  PERFORM catalog USING '' '' 'SL3' 'IT_RSLT' 'REJECTION' 'C100'.
  PERFORM CATALOG USING '' '' 'SL20' 'IT_RSLT' 'KPR RAW MATERIALS' 'C100'.
  PERFORM CATALOG USING '' '' 'SL21' 'IT_RSLT' 'KPR REWORK' 'C100'.
  PERFORM CATALOG USING '' '' 'SL22' 'IT_RSLT' 'KPR Subcon Stk Loc' 'C100'.
*  PERFORM catalog USING '' '' 'SL7' 'IT_RSLT' 'SCRAP' 'C100'.
  PERFORM CATALOG USING '' '' 'SL24' 'IT_RSLT' 'KPR WIP ASSEMBELED' 'C100'.
  PERFORM CATALOG USING '' '' 'SL25' 'IT_RSLT' 'KPR FG Sales Return' 'C100'.
  PERFORM CATALOG USING '' '' 'SL26' 'IT_RSLT' 'KPR SPARES & CONSUM' 'C100'.
  PERFORM CATALOG USING '' '' 'SL27' 'IT_RSLT' 'KPR SRN STORES' 'C100'.
  PERFORM CATALOG USING '' '' 'SL28' 'IT_RSLT' 'KPR THIRD PARTY INSP' 'C100'.
  PERFORM CATALOG USING '' '' 'SL29' 'IT_RSLT' 'KPR VALIDATION' 'C100'.
  PERFORM CATALOG USING '' '' 'SL30' 'IT_RSLT' 'KPR1' 'C100'.
********************************************************************************************


  WA_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  WA_LAYOUT-ZEBRA = 'X'.


ENDFORM.
*&------------------------------------  ---------------------------------*
*&      Form  CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_3297   text
*      -->P_3298   text
*      -->P_3299   text
*      -->P_3300   text
*      -->P_3301   text
*----------------------------------------------------------------------*
FORM CATALOG  USING    VALUE(P1)
                       VALUE(P2)
                       VALUE(P3)
                       VALUE(P4)
                       VALUE(P5)
                       VALUE(P6).
  P1 = P1 + 1.
  WA_FLDCAT-COL_POS = P1.
  WA_FLDCAT-KEY = P2.
  WA_FLDCAT-FIELDNAME = P3.
  WA_FLDCAT-TABNAME = P4.
  WA_FLDCAT-SELTEXT_M = P5.
  WA_FLDCAT-EMPHASIZE = P6.
  APPEND WA_FLDCAT TO IT_FLDCAT.
  CLEAR WA_FLDCAT.

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
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      I_CALLBACK_PROGRAM     = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      I_CALLBACK_TOP_OF_PAGE = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      IS_LAYOUT              = WA_LAYOUT
      IT_FIELDCAT            = IT_FLDCAT[]
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
      I_SAVE                 = 'X'
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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      T_OUTTAB               = IT_RSLT[]
    EXCEPTIONS
      PROGRAM_ERROR          = 1
      OTHERS                 = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
FORM TOP_OF_PAGE.
  DATA: I_LISTHEADER TYPE SLIS_T_LISTHEADER WITH HEADER LINE,
        W_DATE(10)   TYPE C,
        MSG          TYPE STRING.
  CONCATENATE   SY-DATUM+6(2) '.'
                SY-DATUM+4(2) '.'
                SY-DATUM(4) INTO W_DATE RESPECTING BLANKS.
  CONCATENATE 'Date of Report Generation :    ' W_DATE INTO MSG SEPARATED BY SPACE.
  MOVE: 'S'   TO I_LISTHEADER-TYP,
        MSG   TO I_LISTHEADER-INFO.
  APPEND I_LISTHEADER.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = I_LISTHEADER[].
*      I_LOGO             = 'BLISS LOGO'.

ENDFORM.
