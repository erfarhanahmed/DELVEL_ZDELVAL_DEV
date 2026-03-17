*----------------------------------------------------------------------*
***INCLUDE ZPUR_REGISTER_DD.
*----------------------------------------------------------------------*


TYPE-POOLS : SLIS.

** TABLES DECLARATION
TABLES : BKPF, RSEG ,LFA1,LFB1.


DATA : BEGIN OF GT_BKPF OCCURS 0,
         BUKRS     LIKE BKPF-BUKRS,
         BELNR     LIKE BKPF-BELNR,
         GJAHR     LIKE BKPF-GJAHR,
         BLART     LIKE BKPF-BLART,
         BLDAT     LIKE BKPF-BLDAT,
         BUDAT     LIKE BKPF-BUDAT,
         XBLNR     LIKE BKPF-XBLNR,
         WAERS     LIKE BKPF-WAERS,
         KURSF     LIKE BKPF-KURSF,
         AWKEY     LIKE BKPF-AWKEY,
         TCODE     LIKE BKPF-TCODE,
         XBLNR_ALT LIKE BKPF-XBLNR_ALT,
         G_BELNR   LIKE RSEG-BELNR, "GR Inv No
         G_GJAHR   LIKE RSEG-GJAHR, "GR Inv Year

       END OF GT_BKPF.

TYPES:
  BEGIN OF T_BSEG,
    BUKRS TYPE BSEG-BUKRS,
    BELNR TYPE BSEG-BELNR,
    GJAHR TYPE BSEG-GJAHR,
    BUZEI TYPE BSEG-BUZEI,
    SHKZG TYPE BSEG-SHKZG,
    DMBTR TYPE BSEG-DMBTR,
    KTOSL TYPE BSEG-KTOSL,
    ANLN1 TYPE BSEG-ANLN1,
    ANLN2 TYPE BSEG-ANLN2,
    HKONT TYPE BSEG-HKONT,
    EBELN TYPE BSEG-EBELN,
    EBELP TYPE BSEG-EBELP,
    TXBHW TYPE BSEG-TXBHW,
  END OF T_BSEG,
  TT_BSEG TYPE STANDARD TABLE OF T_BSEG.


DATA : BEGIN OF GT_EKBE OCCURS 0,
         EBELN TYPE EKBE-EBELN,
         EBELP TYPE EKBE-EBELP,
         GJAHR TYPE EKBE-GJAHR,
         BELNR TYPE EKBE-BELNR,
         XBLNR TYPE EKBE-XBLNR,
         LFGJA TYPE EKBE-LFGJA,
         LFBNR TYPE EKBE-LFBNR,
         LFPOS TYPE EKBE-LFPOS,
         LSMNG TYPE EKBE-LSMNG,
         AWKEY TYPE BKPF-AWKEY, "Benz
       END OF GT_EKBE.

DATA : GT_EKBE_IMP LIKE GT_EKBE OCCURS 0 WITH HEADER LINE,
       GT_BKPF_WE  LIKE GT_BKPF OCCURS 0 WITH HEADER LINE,
       GT_BKPF_SES LIKE GT_BKPF OCCURS 0 WITH HEADER LINE,
       GT_BKPF_IMP LIKE GT_BKPF OCCURS 0 WITH HEADER LINE.

DATA : BEGIN OF GT_RSEG OCCURS 0,
         BELNR      LIKE RSEG-BELNR,
         GJAHR      LIKE RSEG-GJAHR,
         BUZEI      LIKE RSEG-BUZEI,
         EBELN      LIKE RSEG-EBELN,
         EBELP      LIKE RSEG-EBELP,
         MATNR      LIKE RSEG-MATNR,
         BUKRS      LIKE RSEG-BUKRS,
         WRBTR      LIKE RSEG-WRBTR,      " Amount in document currency  " Nakul N
         MENGE      LIKE RSEG-MENGE,
         MEINS      LIKE RSEG-MEINS,
         SHKZG      LIKE RSEG-SHKZG,
         MWSKZ      LIKE RSEG-MWSKZ,
         BKLAS      LIKE RSEG-BKLAS,
         BNKAN      LIKE RSEG-BNKAN,
         KSCHL      LIKE RSEG-KSCHL, "Condition type in RSEG
         LFBNR      LIKE RSEG-LFBNR, "Reference Document
         LFGJA      LIKE RSEG-LFGJA,  " Benz
         LFPOS      LIKE RSEG-LFPOS, "Reference Documenet item
         WERKS      LIKE RSEG-WERKS,
         STUNR      LIKE RSEG-STUNR,
         EXKBE      LIKE RSEG-EXKBE,
         PSTYP      LIKE RSEG-PSTYP, " Item category to check for SES " Benz
         XEKBZ      LIKE RSEG-XEKBZ, " Delivery Costs Indicator       " Benz
         LIFNR      LIKE RSEG-LIFNR,
         BELNR1     LIKE BKPF-BELNR,
*         lifnr      LIKE rbkp-lifnr,     " avinash bhagat
         BLART      LIKE RBKP-BLART,
         LTEXT      LIKE T003T-LTEXT,
         NAME1      LIKE LFA1-NAME1,
         REGIO      LIKE LFA1-REGIO,
         ORT01      LIKE LFA1-ORT01,
         LAND1      LIKE LFA1-LAND1, "lifnr name1 regio ort01 land1
         BUKRS1     LIKE BKPF-BUKRS,
         BUDAT      LIKE BKPF-BUDAT,
         GJAHR1     LIKE BKPF-GJAHR,
         GSBER      LIKE BSEG-GSBER,
         COUNT1(4)  TYPE N,
         MTART      LIKE MARA-MTART,
         MATKL      LIKE MARA-MATKL,
         TXGRP      LIKE BSET-TXGRP,
         AWKEY      LIKE BKPF-AWKEY,
         ADD        LIKE RSEG-BELNR,
         BSEG_BUZEI TYPE BSEG-BUZEI,

       END OF GT_RSEG.

DATA : GT_RSEG_V1  LIKE GT_RSEG OCCURS 0 WITH HEADER LINE,
       GT_RSEG_SES LIKE GT_RSEG OCCURS 0 WITH HEADER LINE,
       GT_RSEG_IMP LIKE GT_RSEG OCCURS 0 WITH HEADER LINE.

DATA : BEGIN OF GT_RBKP OCCURS 0,
         BELNR   TYPE RBKP-BELNR,
         GJAHR   TYPE RBKP-GJAHR,
         LIFNR   TYPE RBKP-LIFNR,
         BLART   TYPE RBKP-BLART,
         BLDAT   TYPE RBKP-BLDAT,
         XRECH   TYPE RBKP-XRECH,
         STBLG   TYPE RBKP-STBLG,
         ZUONR   TYPE RBKP-ZUONR,
         BKTXT   TYPE RBKP-BKTXT,
         G_BELNR TYPE RSEG-BELNR,
       END OF GT_RBKP.

DATA : BEGIN OF GT_LFA1 OCCURS 0,
         LIFNR LIKE LFA1-LIFNR,
         NAME1 LIKE LFA1-NAME1,
         REGIO LIKE LFA1-REGIO,
         ORT01 LIKE LFA1-ORT01,
         LAND1 LIKE LFA1-LAND1,
         ADRNR LIKE LFA1-ADRNR,
         STCD3 LIKE LFA1-STCD3,
       END OF GT_LFA1.

DATA : BEGIN OF GT_LFB1 OCCURS 0,
         LIFNR LIKE LFB1-LIFNR,
         AKONT LIKE LFB1-AKONT,
       END OF GT_LFB1.

DATA : BEGIN OF GT_BSET OCCURS 0,
         BUKRS     LIKE BSET-BUKRS,
         BELNR     LIKE BSET-BELNR,
         GJAHR     LIKE BSET-GJAHR,
         TXGRP(4)  TYPE N, " like bset-txgrp, "GR Invoice item
         SHKZG     LIKE BSET-SHKZG, "Debit/Credit Indicator
         MWSKZ     LIKE BSET-MWSKZ, "Tax Code
         HWBAS     LIKE BSET-HWBAS, "Tax Base amount in local currency
         HWSTE     LIKE BSET-HWSTE, "Tax Amount in local currency
         KTOSL     LIKE BSET-KTOSL, "Transaction key
         KSCHL     LIKE BSET-KSCHL, "Condition Type
         KBETR     LIKE BSET-KBETR, "Tax Rate
         BUZEI     TYPE BSET-BUZEI,
         HKONT     TYPE BSET-HKONT,
         KNUMH     TYPE BSET-KNUMH,

         COUNT     TYPE SY-TABIX,
         EBELN     TYPE EBELN,
         EBELP     TYPE EBELP,
         AWKEY     TYPE BKPF-AWKEY,
         LFBNR     TYPE MSEG-LFBNR,
         STUNR     TYPE RSEG-STUNR,
         SER_TAX   TYPE BSET-HWSTE,
         E_SER_TAX TYPE BSET-HWSTE,
         S_SER_TAX TYPE BSET-HWSTE,
       END OF GT_BSET.

DATA : BEGIN OF GT_MAKT OCCURS 0,
         MATNR LIKE MAKT-MATNR,
         MAKTX LIKE MAKT-MAKTX,
       END OF GT_MAKT.

DATA : BEGIN OF GT_J_1IMOVEND OCCURS 0,
         LIFNR     TYPE LIFNR,                "Vendor
         J_1ILSTNO TYPE J_1ILSTNO,            "LST No (TIN No)
         J_1IPANNO TYPE J_1IPANNO,            "PAN No
         J_1ISERN  TYPE J_1ISERN,             "Service Tax Registration Number
         J_1ICSTNO TYPE J_1ICSTNO,            "CST No
         J_1IEXCD  TYPE J_1IEXCD,
         VEN_CLASS TYPE DD07T-DOMVALUE_L,
         J_1ISSIST TYPE J_1ISSIST,
       END OF GT_J_1IMOVEND.


** Region Description
DATA  : BEGIN OF GT_T005U OCCURS 0,
          MANDT TYPE T005U-MANDT,
          SPRAS TYPE T005U-SPRAS,
          LAND1 TYPE T005U-LAND1,
          BLAND TYPE T005U-BLAND,
          BEZEI TYPE ZGST_REGION-BEZEI.
DATA  : END OF GT_T005U.

DATA:BEGIN OF GT_EKKO OCCURS 0,
       EBELN TYPE EKKO-EBELN,
       EKORG TYPE EKKO-EKORG,
       EKGRP TYPE EKKO-EKGRP,
       BSART TYPE EKKO-BSART,         " Purchasing Document Type
       AEDAT TYPE EKKO-AEDAT,
*       knumv        TYPE ekko-knumv,
*       doc_typ_desc TYPE text30,
       REVNO TYPE REVNO,
       KNUMV TYPE EKKO-KNUMV,    """Added by Pranit 23.07.2024
     END OF GT_EKKO.


DATA : BEGIN OF IT_KONV ,
         KSCHL TYPE prcd_elements-KSCHL,
         KPOSN TYPE prcd_elements-KPOSN,
         KWERT TYPE prcd_elements-KWERT,
       END OF IT_KONV.
DATA: BEGIN OF GT_EKPO OCCURS 0,
        EBELN TYPE EKPO-EBELN,
        EBELP TYPE EKPO-EBELP,
        MATNR TYPE EKPO-MATNR,
        WERKS TYPE EKPO-WERKS,
        MENGE TYPE EKPO-MENGE,
        NETPR TYPE EKPO-NETPR,
        PEINH TYPE EKPO-PEINH,
        NETWR TYPE EKPO-NETWR,
        MWSKZ TYPE EKPO-MWSKZ,
        PSTYP TYPE EKPO-PSTYP,
        KNTTP TYPE EKPO-KNTTP,
        INFNR TYPE EKPO-INFNR,
        EFFWR TYPE EKPO-EFFWR,   """Added by Pranit 23.07.2024
      END OF GT_EKPO.

TYPES:
  BEGIN OF T_EKET,
    EBELN TYPE EKET-EBELN,
    EBELP TYPE EKET-EBELP,
    ETENR TYPE EKET-ETENR,
    EINDT TYPE EKET-EINDT,
  END OF T_EKET,
  TT_EKET TYPE STANDARD TABLE OF T_EKET.

TYPES:
  BEGIN OF T_QALS,
    PRUEFLOS TYPE QALS-PRUEFLOS,
    EBELN    TYPE QALS-EBELN,
    EBELP    TYPE QALS-EBELP,
    MJAHR    TYPE QALS-MJAHR,
    MBLNR    TYPE QALS-MBLNR,
    ZEILE    TYPE QALS-ZEILE,
    LMENGE02 TYPE QALS-LMENGE02,
    LMENGE04 TYPE QALS-LMENGE04,
  END OF T_QALS,
  TT_QALS TYPE STANDARD TABLE OF T_QALS.

TYPES:
  BEGIN OF T_QAMB,
    PRUEFLOS TYPE QAMB-PRUEFLOS,
    MBLNR    TYPE QAMB-MBLNR,
    MJAHR    TYPE QAMB-MJAHR,
    ZEILE    TYPE QAMB-ZEILE,
  END OF T_QAMB,
  TT_QAMB TYPE STANDARD TABLE OF T_QAMB.

TYPES:
  BEGIN OF T_MSEG,
    MBLNR TYPE MSEG-MBLNR,
    MJAHR TYPE MSEG-MJAHR,
    ZEILE TYPE MSEG-ZEILE,
    BWART TYPE MSEG-BWART,
    LGORT TYPE MSEG-LGORT,
    INSMK TYPE MSEG-INSMK,
    EBELN TYPE MSEG-EBELN,
    EBELP TYPE MSEG-EBELP,
    MENGE TYPE MSEG-MENGE,
    LSMNG TYPE MSEG-LSMNG,
  END OF T_MSEG,
  TT_MSEG TYPE STANDARD TABLE OF T_MSEG.

DATA: BEGIN OF GT_EKKN OCCURS 0,
        EBELN TYPE EKKN-EBELN,
        EBELP TYPE EKKN-EBELP,
        ANLN1 TYPE EKKN-ANLN1,
        ANLN2 TYPE EKKN-ANLN2,
        SAKTO TYPE EKKN-SAKTO,
      END OF GT_EKKN.

DATA: BEGIN OF GT_ANLA OCCURS 0,
        ANLN1 TYPE ANLA-ANLN1,
        ANLN2 TYPE ANLA-ANLN2,
        INVNR TYPE ANLA-INVNR,
        TXT50 TYPE ANLA-TXT50,
      END OF GT_ANLA.

DATA : BEGIN OF GT_BSET1 OCCURS 0,
         COUNT     TYPE SY-TABIX,
         BUKRS     LIKE BSET-BUKRS,
         BELNR     LIKE BSET-BELNR,
         GJAHR     LIKE BSET-GJAHR,
         TXGRP(4)  TYPE N, " like bset-txgrp, "GR Invoice item
         SHKZG     LIKE BSET-SHKZG, "Debit/Credit Indicator
         MWSKZ     LIKE BSET-MWSKZ, "Tax Code
         HWBAS     LIKE BSET-HWBAS, "Tax Base amount in local currency
         HWSTE     LIKE BSET-HWSTE, "Tax Amount in local currency
         KTOSL     LIKE BSET-KTOSL, "Transaction key
         KSCHL     LIKE BSET-KSCHL, "Condition Type
         KBETR     LIKE BSET-KBETR, "Tax Rate
         EBELN     TYPE EBELN,
         EBELP     TYPE EBELP,
         AWKEY     TYPE BKPF-AWKEY,
         BUZEI     TYPE BSET-BUZEI,
         HKONT     TYPE BSET-HKONT,
         KNUMH     TYPE BSET-KNUMH,
         LFBNR     TYPE MSEG-LFBNR,
         STUNR     TYPE RSEG-STUNR,
         SER_TAX   TYPE BSET-HWSTE,
         E_SER_TAX TYPE BSET-HWSTE,
         S_SER_TAX TYPE BSET-HWSTE,
         VALUES    TYPE STRING,
       END OF GT_BSET1.

DATA : BEGIN OF GT_RSEG1 OCCURS 0,
         EBELN  LIKE RSEG-EBELN,
         EBELP  LIKE RSEG-EBELP,
         BELNR  LIKE RSEG-BELNR,
         GJAHR  LIKE RSEG-GJAHR,
         BUZEI  LIKE RSEG-BUZEI,
         MATNR  LIKE RSEG-MATNR,
         BUKRS  LIKE RSEG-BUKRS,
         WRBTR  LIKE RSEG-WRBTR,
         SHKZG  LIKE RSEG-SHKZG,
         MWSKZ  LIKE RSEG-MWSKZ,
         KSCHL  LIKE RSEG-KSCHL, "Condition type in RSEG
         LFPOS  LIKE RSEG-LFPOS, "Reference Documenet item
         LIFNR  LIKE RBKP-LIFNR,
         NAME1  LIKE LFA1-NAME1,
         BUKRS1 LIKE BKPF-BUKRS,
         BELNR1 LIKE BKPF-BELNR,
         GJAHR1 LIKE BKPF-GJAHR,
       END OF GT_RSEG1.

DATA : BEGIN OF GT_WITH_ITEM OCCURS 0,
         BUKRS      TYPE WITH_ITEM-BUKRS,
         BELNR      TYPE WITH_ITEM-BELNR,
         GJAHR      TYPE WITH_ITEM-GJAHR,
         WT_WITHCD  TYPE WITH_ITEM-WT_WITHCD,
         WT_QBSHB   TYPE WITH_ITEM-WT_QBSHB,     "Withholding tax amount in document currency
         WT_OPOWTPD TYPE WITH_ITEM-WT_OPOWTPD,   "Indicator: Entry posted as a debit/credit
       END OF GT_WITH_ITEM.

TYPES:
  BEGIN OF T_ADRC,
    ADDRNUMBER TYPE ADRC-ADDRNUMBER,
    NAME1      TYPE ADRC-NAME1,
    CITY2      TYPE ADRC-CITY2,
    POST_CODE1 TYPE ADRC-POST_CODE1,
    STREET     TYPE ADRC-STREET,
    STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
    LOCATION   TYPE ADRC-LOCATION,
    COUNTRY    TYPE ADRC-COUNTRY,
    REGION     TYPE ADRC-REGION,
  END OF T_ADRC,
  TT_ADRC TYPE STANDARD TABLE OF T_ADRC.

TYPES:
  BEGIN OF T_DD07T,
    VALPOS     TYPE DD07T-VALPOS,
    DDTEXT     TYPE DD07T-DDTEXT,
    DOMVALUE_L TYPE DD07T-DOMVALUE_L,
  END OF T_DD07T,
  TT_DD07T TYPE STANDARD TABLE OF T_DD07T.


TYPES:
  BEGIN OF T_SKAT,
    SAKNR TYPE SKAT-SAKNR,
    TXT20 TYPE SKAT-TXT20,
  END OF T_SKAT,
  TT_SKAT TYPE STANDARD TABLE OF T_SKAT.

TYPES :
  BEGIN OF TY_T005T,
    SPRAS TYPE T005T-SPRAS,
    LAND1 TYPE T005T-LAND1,
    LANDX TYPE T005T-LANDX,
  END OF TY_T005T,
  TT_T005T TYPE STANDARD TABLE OF TY_T005T.

TYPES:
  BEGIN OF T_ZGST_REGION,
    GST_REGION TYPE ZGST_REGION-GST_REGION,
    BEZEI      TYPE ZGST_REGION-BEZEI,
  END OF T_ZGST_REGION,
  TT_ZGST_REGION TYPE STANDARD TABLE OF T_ZGST_REGION.

TYPES:
  BEGIN OF T_MARC,
    MATNR TYPE MARC-MATNR,
    WERKS TYPE MARC-WERKS,
    STEUC TYPE MARC-STEUC,
  END OF T_MARC,
  TT_MARC TYPE STANDARD TABLE OF T_MARC.

TYPES:
  BEGIN OF T_T007S,
    MWSKZ TYPE T007S-MWSKZ,
    TEXT1 TYPE T007S-TEXT1,
  END OF T_T007S,
  TT_T007S TYPE STANDARD TABLE OF T_T007S.

TYPES:
  BEGIN OF T_T163Y,
    PSTYP TYPE T163Y-PSTYP,
    PTEXT TYPE T163Y-PTEXT,
    EPSTP TYPE T163Y-EPSTP,
  END OF T_T163Y,
  TT_T163Y TYPE STANDARD TABLE OF T_T163Y.

TYPES:
  BEGIN OF T_T163I,
    SPRAS TYPE T163I-SPRAS,
    KNTTP TYPE T163I-KNTTP,
    KNTTX TYPE T163I-KNTTX,
  END OF T_T163I,
  TT_T163I TYPE STANDARD TABLE OF T_T163I.


TYPES :
  BEGIN OF TY_T003T,
    SPRAS TYPE T003T-SPRAS,
    BLART TYPE T003T-BLART,
    LTEXT TYPE T003T-LTEXT,
  END OF TY_T003T,
  TT_T003T TYPE STANDARD TABLE OF TY_T003T.
TYPES:
  BEGIN OF TY_T161T,
    SPRAS TYPE T161T-SPRAS,
    BSART TYPE T161T-BSART,
    BATXT TYPE T161T-BATXT,
  END OF TY_T161T,
  TT_T161T TYPE STANDARD TABLE OF TY_T161T.

TYPES:
  BEGIN OF TY_KONV,
    SPRAS TYPE KSCHL,
    KPOSN TYPE KPOSN,
    KWERT TYPE KWERT,
    KNUMV TYPE KNUMV,
  END OF TY_KONV,
  TT_KONV TYPE STANDARD TABLE OF TY_KONV.

*TYPES : IT_KONV TYPE TABLE OF IT_KONV.
DATA:
  BEGIN OF GT_FINAL OCCURS 0,
    EKORG            TYPE EKKO-EKORG,  "" ** PURCHASE_ORG
    LIFNR            TYPE LFA1-LIFNR,  "" ** Vendor
    NAME1            TYPE LFA1-NAME1,  "" ** Vendor Name
    ADDRESS          TYPE STRING,      "" ** Address
    STCD3            TYPE LFA1-STCD3,  "" ** GSTIN
    GST_TXT          TYPE CHAR30,            "Vendor GST
    COUNTRY          TYPE ADRC-COUNTRY , "gst_region TYPE zgst_region-gst_region,
    LANDX            TYPE T005T-LANDX, "gst_region TYPE zgst_region-gst_region,
    REGION           TYPE ADRC-REGION, " bezei      TYPE zgst_region-bezei,
    BEZEI            TYPE T005U-BEZEI, " bezei      TYPE zgst_region-bezei,
    XBLNR_ALT        TYPE BKPF-XBLNR_ALT,  "" **ODN
    INV_NO           TYPE BKPF-XBLNR,  "" ** Inv/BILL_NO
    INV_DT           TYPE STRING, "bkpf-bldat,  "" ** INV DATE TIME
    EBELN            TYPE EKBE-EBELN,  "" ** PO No.
    AEDAT            TYPE STRING, "ekko-aedat,
    EBELP            TYPE EKBE-EBELP,  "" ** PO Line item
    PSTYP            TYPE T163Y-EPSTP, "ekpo-pstyp,
    PTEXT            TYPE T163Y-PTEXT,
    KNTTP            TYPE EKPO-KNTTP,
    KNTTX            TYPE T163I-KNTTX,
    LFBNR            TYPE EKBE-LFBNR,  "" ** Migo number
    BUDAT            TYPE CHAR18, "bkpf-budat,  "" ** Migo date
    BELNR            TYPE BKPF-BELNR,  "" ** Fi document No. (Migo Posting)
    GRN_AMT          TYPE BSEG-DMBTR,  "" ** FI Doc Amt.(GRN)
    ZUONR            TYPE RBKP-ZUONR,
    BKTXT            TYPE RBKP-BKTXT,
    AWKEY            TYPE BKPF-AWKEY,  "" ** BILL_BOOKING_NO
    MIRO_AC_DOC      TYPE BKPF-BELNR,  "" ** MIRO A/c Doc No
    BLART            TYPE BKPF-BLART,  "" ** FI Doc Type
    LTEXT            LIKE T003T-LTEXT,
    BILL_DT          TYPE STRING, "bkpf-budat,  "" ** Bill Booking Date
    HKONT            TYPE BSEG-HKONT,  "" ** GR Legder Code
    TXT20            TYPE SKAT-TXT20,  "" ** GR Ledger Description
    STEUC            TYPE MARC-STEUC,  "" ** HSN/SAC Code
    MATNR            TYPE RSEG-MATNR,  "" ** Material
    LONG_TXT         TYPE CHAR100,     "" **Long Text for Material
    MTART            TYPE MARA-MTART,  "" ** Material Type
    MTBEZ            TYPE T134T-MTBEZ,
    EINDT            TYPE STRING, "eket-eindt,  "" ** Delivery Date
    PO_QTY           TYPE EKPO-MENGE,  "" ** PO Qty
    LSMNG            TYPE MSEG-LSMNG,     " challan
    MENGE            TYPE RSEG-MENGE,  "" ** Quantity
    ACC_QTY          TYPE MSEG-MENGE,  "" ** Accept Qty
    REJ_QTY          TYPE MSEG-MENGE,  "" ** Rej Qty
    SCP_QTY          TYPE MSEG-MENGE,  "" ** Scrap Qty
*    rew_qty          TYPE mseg-menge,  "" ** Rewrk Qty      " commented by supriya
    WAERS            TYPE BKPF-WAERS,  "" ** Document Currency
    KURSF            TYPE BKPF-KURSF,  "" ** Exchange Rate
    RATE             TYPE KWERT,       "" ** Rate Per Qty
    WRBTR            TYPE RSEG-WRBTR,  "" ** Amount in document currency   " Nakul N 27.03.2018
    BASIC            TYPE RSEG-WRBTR,  "" ** BASIC(DC)
    BASIC_LC         TYPE RSEG-WRBTR,  "" ** BASIC(LC)
    PACKING_LC       TYPE RSEG-WRBTR,  "" ** PACKING(LC)
    INSP             TYPE RSEG-WRBTR,  "" ** Inspection Charges
    INSP_LC          TYPE RSEG-WRBTR,  "" ** Inspection Charges
    SET_VAL          TYPE RSEG-WRBTR,  "" ** Setting Charges
    SET_VAL_LC       TYPE RSEG-WRBTR,  "" ** Setting Charges
    FREIGHT_LC       TYPE BSEG-WRBTR,  "" ** Freight (LC)
    INS              TYPE RSEG-WRBTR,  "" ** Insurance Charges
    OTH_CH           TYPE RSEG-WRBTR,  "" ** Other Charges
    OTH_CH_LC        TYPE RSEG-WRBTR,  "" ** Other Charges
    DEV_CH           TYPE RSEG-WRBTR,  "" ** Devlopment Charges
    DEV_CH_LC        TYPE RSEG-WRBTR,  "" ** Devlopment Charges
    NET_TOTAL        TYPE KWERT,       "" ** Assessable Val GST   "add by supriya 15.07.2024
    NET_TOTAL_LC     TYPE KWERT,       "" ** Assessable Val GST
    MWSKZ            TYPE RSEG-MWSKZ,  "" ** Tax Code
    TEXT1            TYPE T007S-TEXT1, "" ** Tax Code Description
*    VAT_TAX          TYPE KWERT,       "" ** VAT TAX
    VAT_TAX          TYPE bset-hwste,       "" ** VAT TAX
    SER_VAL_DR       TYPE KWERT,       "" ** Service Tax Value Credit
    CGST_P           TYPE  prcd_elements-KBETR,              "CGST %                              char15,
    CGST             TYPE  prcd_elements-KWERT,
    BASIC_CUST       TYPE WRBTR,       "" ** Basic Customs
    ADD_CVD          TYPE WRBTR,       "" ** ADD CVD

    OTHER_CHARGES    TYPE WRBTR,
    TOT_TAX          TYPE WRBTR,       "" ** Total Tax Amt
    TOT_TAX_DC       TYPE WRBTR,       "" ** Total Tax Amt
    GROSS_TOT_LC     TYPE WRBTR,       "" ** GROSS_TOTAL (LC)
    ANLN1            TYPE EKKN-ANLN1,  ""  ** Main Asset Number
    ANLN2            TYPE EKKN-ANLN2,  ""  ** Asset Subnumber
    INVNR            TYPE ANLA-INVNR,  ""  ** Asset Inventory No.
    TXT50            TYPE ANLA-TXT50,  ""  ** Asset description
    SAKTO            TYPE EKKN-SAKTO,  ""  ** Asset Reconcilation
    ASS_AMT          TYPE BSEG-DMBTR,  ""  ** Asset Gross Amount
    ZSERIES          TYPE MARA-ZSERIES,      "Series
    ZSIZE            TYPE MARA-ZSIZE,        "Size
    BRAND            TYPE MARA-BRAND,        "Brand
    MOC              TYPE MARA-MOC,          "MOC
    TYPE             TYPE MARA-TYPE,         "Type
    VAT              TYPE KBETR,       "" ** VAT
    CST              TYPE KBETR,       "" ** CST

    GROSS_TOT        TYPE WRBTR,       "" ** GROSS_TOTAL (DC)

    BLDAT            TYPE STRING,
    MEINS            TYPE MARA-MEINS,
    KWERT            TYPE KWERT,
    AKONT            TYPE LFB1-AKONT,  ""  ** Reconciliation Account in General Ledger
    MAKTX            TYPE MAKT-MAKTX,  "" ** Material Description
    WERKS            TYPE RSEG-WERKS,  "" ** PLANT_CODE
    ECS              TYPE KWERT,       "" ** Edu.Excise
    HCESS            TYPE KWERT,       "" ** Higher Edu.Excise
    ECS_DR           TYPE KWERT,       "" ** Edu.Excise Credit
    HCESS_DR         TYPE KWERT,       "" ** Higher Edu.Excise Credit
    ECS_CR           TYPE KWERT,       "" ** Edu.Excise Debit
    HCESS_CR         TYPE KWERT,       "" ** Higher Edu.Excise Debit
    SER_VAL_CR       TYPE KWERT,       "" ** Service Tax Value Debit
*    sbc_cr           TYPE kwert,       "" ** Swach Bharat Cess Debit
*    kkc_cr           TYPE kwert,       "" ** Krishi Kalyan Cess Debit
    PACKING          TYPE RSEG-WRBTR,  "" ** PACKING(DC)
    DISCOUNT         TYPE RSEG-WRBTR,  "" ** DISCOUNT(DC)
    DISCOUNT_LC      TYPE RSEG-WRBTR,  "" ** DISCOUNT(LC)
    FREIGHT          TYPE BSEG-WRBTR,  "" ** Freight (DC)
*    lbt              TYPE wrbtr,       "" ** CESS/LBT
    FORWARDING       TYPE WRBTR,       "" ** FORWARDING (DC)
    FORWARDING_LC    TYPE WRBTR,       "" ** FORWARDING (LC)
    CLEARING         TYPE WRBTR,       "" ** CLEARING (DC)
    CLEARING_LC      TYPE WRBTR,       "" ** CLEARING (LC)
    TDS_DC           TYPE WT_BS1,      "" ** TDS (DC)
    TDS_LC           TYPE WT_BS1,      "" ** TDS (LC)
    TDS_FLAG         TYPE C,           "" ** TDS FLAG
    GROSS_TOT_TDS    TYPE WRBTR,       ""  ** GROSS TOTAL WITHOUT TDS (DC)
    GROSS_TOT_LC_TDS TYPE WRBTR,       ""  ** GROSS TOTAL WITHOUT TDS (LC)
    TIN_NO           TYPE J_1IMOVEND-J_1ICSTNO, "" **TIN_NO
    LST_NO           TYPE J_1IMOVEND-J_1ILSTNO, "" **LST_NO
    TCODE            TYPE BKPF-TCODE,  "" ** Transaction Code
*    net_total        TYPE kwert,       "" ** NET TOTAL (DC)
    REF_DATE         TYPE STRING,      " Abhishek Pisolkar (27.03.2018)
    BSART            TYPE EKKO-BSART,
    BATXT            TYPE T161T-BATXT,
    INFNR            TYPE EINE-INFNR,
    J_1ISSIST        TYPE STRING,
    TXBHW            TYPE BSEG-TXBHW,
    HWBAS            TYPE BSET-HWBAS,
* TOT              TYPE  KONV-KWERT,
 TOT              TYPE   BSEG-TXBHW ,

  END OF GT_FINAL.

*----------------------------------For File Download----------------------------------------

*DATA:
*  BEGIN OF IT_FINAL OCCURS 0,
*    EKORG        TYPE EKKO-EKORG,                      "" ** PURCHASE_ORG
*    LIFNR        TYPE LFA1-LIFNR,                      "" ** Vendor
*    NAME1        TYPE LFA1-NAME1,                      "" ** Vendor Name
*    ADDRESS      TYPE STRING,                          "" ** Address
*    STCD3        TYPE LFA1-STCD3,                      "" ** Vat reg codeGSTIN.
*    COUNTRY      TYPE STRING,
*    LANDX        TYPE STRING,
*    REGION       TYPE STRING, "zgs_region-gst_region,
*    BEZEI        TYPE STRING, "zgst_region-bezei,
*    INV_NO       TYPE BKPF-XBLNR,  "" ** Inv/BILL_NO
*    INV_DT       TYPE STRING, "char10, "bkpf-bldat,  "" ** INV DATE TIME
*    EBELN        TYPE EKBE-EBELN,  "" ** PO No.
*    AEDAT        TYPE STRING, "char10, "ekko-aedat,
*    EBELP        TYPE EKBE-EBELP,  "" ** PO Line item
*    PSTYP        TYPE T163Y-EPSTP, "ekpo-pstyp,
*    PTEXT        TYPE T163Y-PTEXT,
*    KNTTP        TYPE EKPO-KNTTP,
*    KNTTX        TYPE T163I-KNTTX,
*    LFBNR        TYPE EKBE-LFBNR,  "" ** Migo number
*    BUDAT        TYPE CHAR18, "char10, "bkpf-budat,  "" ** Migo date
*    BELNR        TYPE BKPF-BELNR,  "" ** Fi document No. (Migo Posting)
*    GRN_AMT      TYPE STRING, "bseg-dmbtr,  "" ** FI Doc Amt.(GRN)
*    AWKEY        TYPE BKPF-AWKEY,  "" ** BILL_BOOKING_NO
*    MIRO_AC_DOC  TYPE BKPF-BELNR,  "" ** MIRO A/c Doc No
*    BLART        TYPE BKPF-BLART,  "" ** FI Doc Type
*    LTEXT        LIKE T003T-LTEXT,
*    BILL_DT      TYPE STRING, "char10, "bkpf-budat,  "" ** Bill Booking Date
*    HKONT        TYPE BSEG-HKONT,  "" ** GR Legder Code
*    TXT20        TYPE SKAT-TXT20,  "" ** GR Ledger Description
*    STEUC        TYPE MARC-STEUC,  "" ** HSN/SAC Code
*    MATNR        TYPE RSEG-MATNR,  "" ** Material
*    LONG_TXT     TYPE CHAR100,     "" **Long Text for Material
*    MTART        TYPE MARA-MTART,  "" ** Material Type
*    MTBEZ        TYPE T134T-MTBEZ,
*    EINDT        TYPE STRING, "char10, "eket-eindt,  "" ** Delivery Date
*    PO_QTY       TYPE STRING, "ekpo-menge,  "" ** PO Qty
*    LSMNG        TYPE STRING, "mseg-lsmng,
*    MENGE        TYPE STRING, "rseg-menge,  "" ** Quantity
*    ACC_QTY      TYPE STRING, "mseg-menge,  "" ** Accept Qty
*    REJ_QTY      TYPE STRING, "mseg-menge,  "" ** Rej Qty
*    SCP_QTY      TYPE STRING, "mseg-menge,  "" ** Scrap Qty
**    rew_qty      TYPE string, "mseg-menge,  "" ** Rewrk Qty    " comment supriya
*    WAERS        TYPE BKPF-WAERS,  "" ** Document Currency
*    KURSF        TYPE STRING, "bkpf-kursf,  "" ** Exchange Rate
*    RATE         TYPE STRING, "kwert,       "" ** Rate Per Qty
*    BASIC        TYPE STRING, "rseg-wrbtr,  "" ** BASIC(DC)
*    BASIC_LC     TYPE STRING, "rseg-wrbtr,  "" ** BASIC(LC)
*    PACKING_LC   TYPE STRING, "rseg-wrbtr,  "" ** PACKING(LC)
*    INSP         TYPE STRING, "rseg-wrbtr,  "" ** Inspection Charges
*    SET_VAL      TYPE STRING, "rseg-wrbtr,  "" ** Setting Charges
*    FREIGHT_LC   TYPE STRING, "bseg-wrbtr,  "" ** Freight (LC)
*    INS          TYPE STRING, "rseg-wrbtr,  "" ** Insurance Charges
*    OTH_CH       TYPE STRING, "rseg-wrbtr,  "" ** Other Charges
*    DEV_CH       TYPE STRING, "rseg-wrbtr,  "" ** Devlopment Charges
**    net_total_lc TYPE string, "kwert,       "" ** Assessable Val GST        " comment by supriya
*    NET_TOTAL    TYPE STRING, "kwert,       "" ** Assessable Val GST         "add by supriya 15.07.2024
*    NET_TOTAL_LC TYPE STRING, "kwert,       "" ** Assessable Val GST          "add by supriya 15.07.2024
*    MWSKZ        TYPE RSEG-MWSKZ,  "" ** Tax Code
*    TEXT1        TYPE T007S-TEXT1, "" ** Tax Code Description
*    BASIC_CUST   TYPE STRING, "wrbtr,       "" ** Basic Customs
*    ADD_CVD      TYPE STRING, "wrbtr,       "" ** ADD CVD
*    TOT_TAX      TYPE STRING, "wrbtr,       "" ** Total Tax Amt
*    GROSS_TOT_LC TYPE STRING, "wrbtr,       "" ** GROSS_TOTAL (LC)
*    ANLN1        TYPE EKKN-ANLN1,  ""  ** Main Asset Number
*    ANLN2        TYPE EKKN-ANLN2,  ""  ** Asset Subnumber
*    INVNR        TYPE ANLA-INVNR,  ""  ** Asset Inventory No.
*    TXT50        TYPE ANLA-TXT50,  ""  ** Asset description
*    SAKTO        TYPE EKKN-SAKTO,  ""  ** Asset Reconcilation
*    ASS_AMT      TYPE STRING, "bseg-dmbtr,  ""  ** Asset Gross Amount
*    MOC          TYPE MARA-MOC,          "MOC
*    BRAND        TYPE MARA-BRAND,        "Brand
*    ZSIZE        TYPE MARA-ZSIZE,        "Size
*    ZSERIES      TYPE MARA-ZSERIES,      "Series
*    TYPE         TYPE MARA-TYPE,         "Type
*    GROSS_TOT    TYPE STRING, "wrbtr,       "" ** GROSS_TOTAL (DC)
*    MEINS        TYPE MARA-MEINS,
*    BLDAT        TYPE STRING,
*    BSART        TYPE EKKO-BSART,
*    BATXT        TYPE T161T-BATXT,
*    INFNR        TYPE STRING,
*    REF_DATE     TYPE STRING,      " Abhishek Pisolkar (27.03.2018)
*  END OF IT_FINAL.

DATA:
  BEGIN OF IT_FINAL OCCURS 0,
    EKORG        TYPE EKKO-EKORG,
    LIFNR        TYPE LFA1-LIFNR,
    NAME1        TYPE LFA1-NAME1,
    ADDRESS      TYPE STRING,
    STCD3        TYPE LFA1-STCD3,
    COUNTRY      TYPE STRING,
    LANDX        TYPE STRING,
    REGION       TYPE STRING,
    BEZEI        TYPE STRING,
    INV_NO       TYPE BKPF-XBLNR,
    INV_DT       TYPE STRING,
    BSART        TYPE EKKO-BSART,
    BATXT        TYPE T161T-BATXT,
    EBELN        TYPE EKBE-EBELN,
    EBELP        TYPE EKBE-EBELP,
    AEDAT        TYPE STRING,
    KNTTP        TYPE EKPO-KNTTP,
    KNTTX        TYPE T163I-KNTTX,
    PSTYP        TYPE T163Y-EPSTP,
    PTEXT        TYPE T163Y-PTEXT,
    LFBNR        TYPE EKBE-LFBNR,
    BUDAT        TYPE CHAR18,
    BELNR        TYPE BKPF-BELNR,
    GRN_AMT      TYPE STRING,
    AWKEY        TYPE BKPF-AWKEY,
    MIRO_AC_DOC  TYPE BKPF-BELNR,
    BLART        TYPE BKPF-BLART,
    LTEXT        LIKE T003T-LTEXT,
    BILL_DT      TYPE STRING,
    HKONT        TYPE BSEG-HKONT,
    TXT20        TYPE SKAT-TXT20,
    STEUC        TYPE MARC-STEUC,
    MATNR        TYPE RSEG-MATNR,
    LONG_TXT     TYPE CHAR100,
    MEINS        TYPE MARA-MEINS,
    "BLDAT         TYPE STRING,
    EINDT        TYPE STRING,
    PO_QTY       TYPE STRING,
    LSMNG        TYPE STRING,
    MENGE        TYPE STRING,
    ACC_QTY      TYPE STRING,
    REJ_QTY      TYPE STRING,
    SCP_QTY      TYPE STRING,
    WAERS        TYPE BKPF-WAERS,
    KURSF        TYPE STRING,
    RATE         TYPE STRING,
    BASIC        TYPE STRING,
    PACKING_LC   TYPE STRING,
    INSP         TYPE STRING,
    SET_VAL      TYPE STRING,
    FREIGHT_LC   TYPE STRING,
    INS          TYPE STRING,
    OTH_CH       TYPE STRING,
    DEV_CH       TYPE STRING,
    NET_TOTAL    TYPE STRING,
    TOT_TAX_DC   TYPE STRING,
    GROSS_TOT    TYPE STRING,
    MWSKZ        TYPE RSEG-MWSKZ,
    TEXT1        TYPE T007S-TEXT1,
    BASIC_CUST   TYPE STRING,
    ADD_CVD      TYPE STRING,
    BASIC_LC     TYPE STRING,
    NET_TOTAL_LC TYPE STRING,
    TOT_TAX      TYPE STRING,
    GROSS_TOT_LC TYPE STRING,
    INFNR        TYPE STRING,
    ANLN1        TYPE EKKN-ANLN1,
    ANLN2        TYPE EKKN-ANLN2,
    INVNR        TYPE ANLA-INVNR,
    TXT50        TYPE ANLA-TXT50,
    SAKTO        TYPE EKKN-SAKTO,
    ASS_AMT      TYPE STRING,
    MTART        TYPE MARA-MTART,
    MTBEZ        TYPE T134T-MTBEZ,
    MOC          TYPE MARA-MOC,
    BRAND        TYPE MARA-BRAND,
    ZSIZE        TYPE MARA-ZSIZE,
    ZSERIES      TYPE MARA-ZSERIES,
    TYPE         TYPE MARA-TYPE,
    BLDAT        TYPE STRING,
    REF_DATE     TYPE STRING,

  END OF IT_FINAL.
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF T_MAT_MAST,
    MATNR   TYPE MARA-MATNR,
    MTART   TYPE MARA-MTART,
    MEINS   TYPE MARA-MEINS,
    ZSERIES TYPE MARA-ZSERIES,
    ZSIZE   TYPE MARA-ZSIZE,
    BRAND   TYPE MARA-BRAND,
    MOC     TYPE MARA-MOC,
    TYPE    TYPE MARA-TYPE,
  END OF T_MAT_MAST,
  TT_MAT_MAST TYPE STANDARD TABLE OF T_MAT_MAST.

TYPES :
  BEGIN OF TY_T134T,
    SPRAS TYPE T134T-SPRAS,
    MTART TYPE T134T-MTART,
    MTBEZ TYPE T134T-MTBEZ,
  END OF TY_T134T,
  TT_T134T TYPE STANDARD TABLE OF TY_T134T.
DATA : GT_EKPO1 LIKE GT_EKPO OCCURS 0 WITH HEADER LINE.

DATA: LV_TTAXOF15 TYPE P DECIMALS 2.
DATA: LV_TTAXOF15_DC TYPE P DECIMALS 2.

DATA : GT_LISTHEADER   TYPE SLIS_T_LISTHEADER   WITH HEADER LINE,
       GT_FIELDCATALOG TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
       GT_EVENT        TYPE SLIS_T_EVENT        WITH HEADER LINE,
       GT_LAYOUT       TYPE SLIS_LAYOUT_ALV,
       GT_SORT         TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.

DATA : GT_AUTH_BUKRS TYPE RANGE OF T001-BUKRS,           " DECLARATION FOR AUTHORIZATION
       GT_AUTH_WERKS TYPE RANGE OF T001W-WERKS.          " DECLARATION FOR AUTHORIZATION

******************************************************************************

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : "s_bukrs FOR bkpf-bukrs OBLIGATORY NO INTERVALS NO-EXTENSION,
                 S_EBELN FOR RSEG-EBELN,
                 S_BUDAT FOR BKPF-BUDAT, "OBLIGATORY,
                 S_GJAHR FOR BKPF-GJAHR OBLIGATORY ,"DEFAULT '2017',
                 S_WERKS FOR RSEG-WERKS OBLIGATORY DEFAULT 'SU01' MODIF ID WER." ADDED BY MD
SELECT-OPTIONS: S_LIFNR FOR LFB1-LIFNR.

*                 s_lifnr FOR lfa1-lifnr.        "Added By Avinash Bhagat 29.10.2018

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-002.
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/Saudi'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'WER'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
