*&---------------------------------------------------------------------*
*& Report ZSALES_REGISTER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSALES_REGISTER_NEW.

TYPE-POOLS:SLIS.
DATA DISAMT2 TYPE STRING .
DATA DISAMT TYPE STRING .
DATA:
  TMP_VBELN TYPE VBRK-VBELN,
  TMP_FKDAT TYPE VBRK-FKDAT,
  TMP_SO    TYPE VBAK-VBELN,
  TMP_KUNNR TYPE KNA1-KUNNR,
  DMP_VBELN TYPE VBRK-VBELN,
  DMP_ORD   TYPE VBAK-VBELN.


TYPES:
  BEGIN OF T_SALES_INV_HDR,
    VBELN     TYPE VBRK-VBELN,
    FKART     TYPE VBRK-FKART,
    FKTYP     TYPE VBRK-FKTYP,
    WAERK     TYPE VBRK-WAERK,
    VKORG     TYPE VBRK-VKORG,
    VTWEG     TYPE VBRK-VTWEG,
    KNUMV     TYPE VBRK-KNUMV,
    FKDAT     TYPE VBRK-FKDAT,
    KUNAG     TYPE VBRK-KUNAG,
    KTGRD     TYPE VBRK-KTGRD,
    FKSTO     TYPE VBRK-FKSTO,
    XBLNR     TYPE VBRK-XBLNR,
    ZUONR     TYPE VBRK-ZUONR,
    KURRF_DAT TYPE VBRK-KURRF_DAT,
    KURRF     TYPE VBRK-KURRF,
  END OF T_SALES_INV_HDR,
  TT_SALES_INV_HDR TYPE STANDARD TABLE OF T_SALES_INV_HDR.

TYPES:
  BEGIN OF T_SALES_INV_ITEM,
    VBELN TYPE VBRP-VBELN,
    POSNR TYPE VBRP-POSNR,
    FKIMG TYPE VBRP-FKIMG,
    VRKME TYPE VBRP-VRKME,
    KURSK TYPE VBRP-KURSK,
    NETWR TYPE VBRP-NETWR,
    VGBEL TYPE VBRP-VGBEL,
    VGPOS TYPE VBRP-VGPOS,
    VGTYP TYPE VBRP-VGTYP,
    AUBEL TYPE VBRP-AUBEL,
    AUPOS TYPE VBRP-AUPOS,
    MATNR TYPE VBRP-MATNR,
    ARKTX TYPE VBRP-ARKTX,
    CHARG TYPE VBRP-CHARG,
    PRODH TYPE VBRP-PRODH,
    WERKS TYPE VBRP-WERKS,
    LGORT TYPE VBRP-LGORT, "added by jyoti on 11.06.2024
  END OF T_SALES_INV_ITEM,
  TT_SALES_INV_ITEM TYPE STANDARD TABLE OF T_SALES_INV_ITEM.

TYPES:
  BEGIN OF T_SALES_ORD_HDR,
    VBELN       TYPE VBAK-VBELN,
    AUDAT       TYPE VBAK-AUDAT,
    AUART       TYPE VBAK-AUART,
    VKBUR       TYPE VBAK-VKBUR,
    VDATU       TYPE VBAK-VDATU,
    BSTNK       TYPE VBAK-BSTNK,
    ZLDFROMDATE TYPE VBAK-ZLDFROMDATE,
    ZLDPERWEEK  TYPE VBAK-ZLDPERWEEK,
    ZLDMAX      TYPE VBAK-ZLDMAX,
  END OF T_SALES_ORD_HDR,
  TT_SALES_ORD_HDR TYPE STANDARD TABLE OF T_SALES_ORD_HDR.

TYPES:
  BEGIN OF T_SALES_PARTNER,
    VBELN TYPE VBPA-VBELN,
    KUNNR TYPE VBPA-KUNNR,
  END OF T_SALES_PARTNER,
  TT_SALES_PARTNER TYPE STANDARD TABLE OF T_SALES_PARTNER.

TYPES:
  BEGIN OF T_SALES_ORD_ITEM,
    VBELN   TYPE VBAP-VBELN,
    POSNR   TYPE VBAP-POSNR,
    MATNR   TYPE VBAP-MATNR,
    KDMAT   TYPE VBAP-KDMAT,
    DELDATE TYPE VBAP-DELDATE,
  END OF T_SALES_ORD_ITEM,
  TT_SALES_ORD_ITEM TYPE STANDARD TABLE OF T_SALES_ORD_ITEM.

TYPES:
  BEGIN OF T_CUST_INFO,
    KUNNR TYPE KNA1-KUNNR,
    NAME1 TYPE KNA1-NAME1,
    LAND1 TYPE KNA1-LAND1,
    REGIO TYPE KNA1-REGIO,
    ADRNR TYPE KNA1-ADRNR,
    STCD3 TYPE KNA1-STCD3,
  END OF T_CUST_INFO,
  TT_CUST_INFO TYPE STANDARD TABLE OF T_CUST_INFO.

TYPES:
  BEGIN OF T_T005U,
    LAND1 TYPE T005U-LAND1,
    BLAND TYPE T005U-BLAND,
    BEZEI TYPE ZGST_REGION-BEZEI,
  END OF T_T005U,
  TT_T005U TYPE STANDARD TABLE OF T_T005U.

TYPES:
  BEGIN OF T_ZGST_REGION,
    GST_REGION TYPE ZGST_REGION-GST_REGION,
    BEZEI      TYPE ZGST_REGION-BEZEI,
  END OF T_ZGST_REGION,
  TT_ZGST_REGION TYPE STANDARD TABLE OF T_ZGST_REGION.

TYPES:
  BEGIN OF T_KNVI,
    KUNNR TYPE KNVI-KUNNR,
    TAXKD TYPE KNVI-TAXKD,
  END OF T_KNVI,
  TT_KNVI TYPE STANDARD TABLE OF T_KNVI.

TYPES:
  BEGIN OF T_TSKDT,
    TATYP TYPE TSKDT-TATYP,
    TAXKD TYPE TSKDT-TAXKD,
    VTEXT TYPE TSKDT-VTEXT,
  END OF T_TSKDT,
  TT_TSKDT TYPE STANDARD TABLE OF T_TSKDT.

TYPES:
  BEGIN OF T_SCHEDULE_LINE,
    VBELN TYPE VBEP-VBELN,
    POSNR TYPE VBEP-POSNR,
    EDATU TYPE VBEP-EDATU,
  END OF T_SCHEDULE_LINE,
  TT_SCHEDULE_LINE TYPE STANDARD TABLE OF T_SCHEDULE_LINE.

TYPES:
  BEGIN OF T_TVKTT,
    KTGRD TYPE TVKTT-KTGRD,
    VTEXT TYPE TVKTT-VTEXT,
  END OF T_TVKTT,
  TT_TVKTT TYPE STANDARD TABLE OF T_TVKTT.

TYPES:
  BEGIN OF T_CONDITIONS,
    KNUMV TYPE PRCD_ELEMENTS-KNUMV,
    KPOSN TYPE PRCD_ELEMENTS-KPOSN,
    KSCHL TYPE PRCD_ELEMENTS-KSCHL,
    KBETR TYPE PRCD_ELEMENTS-KBETR,
    MWSK1 TYPE PRCD_ELEMENTS-MWSK1,
    KWERT TYPE PRCD_ELEMENTS-KWERT,
    KSTAT TYPE PRCD_ELEMENTS-KSTAT,
    KINAK TYPE PRCD_ELEMENTS-KINAK,
  END OF T_CONDITIONS,
  TT_CONDITIONS TYPE STANDARD TABLE OF T_CONDITIONS.

TYPES:
  BEGIN OF T_T007S,
    MWSKZ TYPE T007S-MWSKZ,
    TEXT1 TYPE T007S-TEXT1,
  END OF T_T007S,
  TT_T007S TYPE STANDARD TABLE OF T_T007S.

TYPES:
  BEGIN OF T_ACCOUNTING_DOC_ITEM,
    BUKRS TYPE BSEG-BUKRS,
    BELNR TYPE BSEG-BELNR,
    GJAHR TYPE BSEG-GJAHR,
    BUZEI TYPE BSEG-BUZEI,
    VBELN TYPE BSEG-VBELN,
    VBEL2 TYPE BSEG-VBEL2,
    POSN2 TYPE BSEG-POSN2,
    HKONT TYPE BSEG-HKONT,
    KUNNR TYPE BSEG-KUNNR,
    ZFBDT TYPE BSEG-ZFBDT,
    MWSK1 TYPE BSEG-MWSK1,
    DMBT1 TYPE BSEG-DMBT1,
    REBZG TYPE BSEG-REBZG,
    REBZJ TYPE BSEG-REBZJ,
  END OF T_ACCOUNTING_DOC_ITEM,
  TT_ACCOUNTING_DOC_ITEM TYPE STANDARD TABLE OF T_ACCOUNTING_DOC_ITEM.

TYPES:
  BEGIN OF T_ACCOUNTING_DOC_HDR,
    BUKRS TYPE BKPF-BUKRS,
    BELNR TYPE BKPF-BELNR,
    GJAHR TYPE BKPF-GJAHR,
    BLART TYPE BKPF-BLART,
    XBLNR TYPE BKPF-XBLNR,
    BKTXT TYPE BKPF-BKTXT,
  END OF T_ACCOUNTING_DOC_HDR,
  TT_ACCOUNTING_DOC_HDR TYPE STANDARD TABLE OF T_ACCOUNTING_DOC_HDR.

TYPES:
  BEGIN OF T_MAT_MASTER,
    MATNR   TYPE MARA-MATNR,
    ZSERIES TYPE MARA-ZSERIES,
    ZSIZE   TYPE MARA-ZSIZE,
    BRAND   TYPE MARA-BRAND,
    MOC     TYPE MARA-MOC,
    TYPE    TYPE MARA-TYPE,
  END OF T_MAT_MASTER,
  TT_MAT_MASTER TYPE STANDARD TABLE OF T_MAT_MASTER.

TYPES:
  BEGIN OF T_MATERIAL_VAL,
    MATNR TYPE MBEW-MATNR,
    BWKEY TYPE MBEW-BWKEY,
    BWTAR TYPE MBEW-BWTAR,
    STPRS TYPE MBEW-STPRS,
  END OF T_MATERIAL_VAL,
  TT_MATERIAL_VAL TYPE STANDARD TABLE OF T_MATERIAL_VAL.

TYPES:
  BEGIN OF T_MARC,
    MATNR TYPE MARC-MATNR,
    WERKS TYPE MARC-WERKS,
    STEUC TYPE MARC-STEUC,
  END OF T_MARC,
  TT_MARC TYPE STANDARD TABLE OF T_MARC.

TYPES:
  BEGIN OF T_SALES_BUSS,
    VBELN TYPE VBKD-VBELN,
    POSNR TYPE VBKD-POSNR,
    TRATY TYPE VBKD-TRATY,
  END OF T_SALES_BUSS,
  TT_SALES_BUSS TYPE STANDARD TABLE OF T_SALES_BUSS.

TYPES:
  BEGIN OF T_SKAT,
    SAKNR TYPE SKAT-SAKNR,
    TXT20 TYPE SKAT-TXT20,
  END OF T_SKAT,
  TT_SKAT TYPE STANDARD TABLE OF T_SKAT.

TYPES:
  BEGIN OF T_ADRC,
    ADDRNUMBER TYPE ADRC-ADDRNUMBER,
    NAME1      TYPE ADRC-NAME1,
    CITY2      TYPE ADRC-CITY2,
    POST_CODE1 TYPE ADRC-POST_CODE1,
    STREET     TYPE ADRC-STREET,
    STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
    STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
    STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
    LOCATION   TYPE ADRC-LOCATION,
    COUNTRY    TYPE ADRC-COUNTRY,
  END OF T_ADRC,
  TT_ADRC TYPE STANDARD TABLE OF T_ADRC.

TYPES :
  BEGIN OF T_SAL_TXT,

    SAL_TXT TYPE STRING,
*         INCLUDE STRUCTURE TLINE,

  END OF T_SAL_TXT,

  TT_SAL_TXT TYPE STANDARD TABLE OF T_SAL_TXT.

*********************************************

TYPES : BEGIN OF LS_FIELDNAME,
          FIELD_NAME(25),
        END OF LS_FIELDNAME.

DATA : IT_FIELDNAME TYPE TABLE OF LS_FIELDNAME.
DATA : WA_FIELDNAME TYPE LS_FIELDNAME.

DATA : VAL_INR2       TYPE P DECIMALS 2 , "CHAR100,      "Amount in Local Currency
       DIS3           TYPE  P DECIMALS 2, "CHAR100,        "Discount
       DIS2           TYPE  CHAR100,        "Discount
       DIS_AMT3       TYPE P DECIMALS 2, "        "Discount
       DIS_AMT2       TYPE STRING , "PRCD_ELEMENTS-KWERT, "        "Discount
       DIS_UNIT_RATE2 TYPE P DECIMALS 2, "PRCD_ELEMENTS-KWERT,
       TOT_ASS        TYPE STRING, "PRCD_ELEMENTS-KBETR,        "Discount
       ASS2_VAL       TYPE STRING, "PRCD_ELEMENTS-KWERT,
       ASS_VAL2       TYPE P DECIMALS 2, "CHAR100,        "Assessable
       TOT2           TYPE  P DECIMALS 2, "CHAR100,        "Grand Total
       ASS_GST2       TYPE P DECIMALS 2.              "Assessable GST
*****************************************
TYPES:
  BEGIN OF T_FINAL,
    WERKS         TYPE VBRP-WERKS,      "Plant
    VBELN         TYPE VBRK-VBELN,      "Inv No
    XBLNR         TYPE VBRK-XBLNR,      "ODN Number
    POSNR         TYPE VBRP-POSNR,      "Line Item
    FKART         TYPE VBRK-FKART,      "Billing Type
    FKDAT         TYPE CHAR11, "vbrk-fkdat,      "Billing Date
    AUART         TYPE VBAK-AUART,      "Sales Order Type
    VKBUR         TYPE VBAK-VKBUR,      "Sales Office
    AUBEL         TYPE VBRP-AUBEL,      "Sales Order No
    AUDAT         TYPE CHAR11, "vbak-audat,      "Sales Order Date
    VDATU         TYPE CHAR11, "vbak-vdatu,      "Req Delivery Date
    EDATU         TYPE CHAR11, "vbep-edatu,        "Delivery Date
    BSTNK         TYPE VBAK-BSTNK,      "Customer Ref No.
    KUNAG         TYPE VBRK-KUNAG,      "Customer Code
    NAME1         TYPE KNA1-NAME1,        "Customer Name
    MATNR         TYPE VBRP-MATNR,      "Material Code
    ARKTX         TYPE VBRP-ARKTX,      "Sales Text
    LONG_TXT      TYPE CHAR100,         "Long Text for Material
    FKIMG         TYPE CHAR15, "vbrp-fkimg,      "Invoice Qty
    BASE_VAL      TYPE CHAR100,        "Base Price
    WAERK         TYPE VBRK-WAERK,      "Currency
    KURSK         TYPE VBRP-KURSK,      "Exchange Rate
    VAL_INR       TYPE string ,"CHAR100,      "Amount in Local Currency
    PF_VAL        TYPE CHAR100,        "P&F
    DIS           TYPE STRING, " CHAR100,        "Discount
*    DIS_AMT       TYPE STRING, "        "Discount
*    DIS_UNIT_RATE TYPE STRING , "PRCD_ELEMENTS-KWERT,
**    DIS_RATE      TYPE PRCD_ELEMENTS-KBETR,        "Discount
*    DIS_RATE      TYPE P DECIMALS 2,
    ASS_VAL       TYPE STRING, "CHAR100,        "Assessable
    EXE_VAL       TYPE STRING, "CHAR100,        "Excise Duty
    EDU_VAL       TYPE STRING, "STRING,"CHAR100,        "Education Cess Amount
    HSE_VAL       TYPE STRING, "CHAR100,        "Higher Education Cess Amount
    VAT           TYPE CHAR100,        "VAT/CST
    FRT           TYPE CHAR100,        "Freight
    INS           TYPE CHAR100,        "Insurance
    CGST          TYPE CHAR100,        "CGST
    SGST          TYPE CHAR100,        "SGST
    IGST          TYPE CHAR100,        "JOIG
    TOT           TYPE STRING, "CHAR100,        "Grand Total
    PRODH         TYPE VBRP-PRODH,      "Product Heirarchy
    STEUC         TYPE MARC-STEUC,        "HSN Code
    VTEXT         TYPE TVKTT-VTEXT,       "Sales Type Text
    TRANS         TYPE CHAR30,            "Transporter Name
    LR_NO         TYPE CHAR20,            "L/R No.
    LR_DT         TYPE CHAR10,            "LR Date
    TRATY         TYPE CHAR20,        "Transport Type
    FRT_TYP       TYPE CHAR40,            "Freight Type
    INT_PR        TYPE CHAR100,             "Internal Price
    STPRS         TYPE CHAR100,        "Cost
    STPRS1        TYPE CHAR100,        "Cost
    ZSERIES       TYPE MARA-ZSERIES,      "Series
    ZSIZE         TYPE MARA-ZSIZE,        "Size
    BRAND         TYPE MARA-BRAND,              "Brand
    MOC           TYPE MARA-MOC,                "MOC
    TYPE          TYPE MARA-TYPE,               "Type
    LD_TG         TYPE CHAR20,                  "LD Tag
    ZLDFROMDATE   TYPE CHAR11, "vbak-zldfromdate,  "LD Date
    ZLDPERWEEK    TYPE VBAK-ZLDPERWEEK,
    ZLDMAX        TYPE VBAK-ZLDMAX,             "LD%
    VTEXT1        TYPE SKAT-TXT20,             "Sales Ledger Head
    STATUS        TYPE C,                       "Invoice Status
    KDMAT         TYPE VBAP-KDMAT,              "Customer Item Code
    STCD3         TYPE KNA1-STCD3,              "GSTIN No
    BEZEI         TYPE T005U-BEZEI,             "Region
    GST_REGION    TYPE ZGST_REGION-GST_REGION,  "State Code
    KUNNR         TYPE KNA1-KUNNR,              "Ship To Party
    NAME1_SH      TYPE KNA1-NAME1,
    BEZEI_SH      TYPE T005U-BEZEI,             " Ship To Region
    GST_REGION_SH TYPE ZGST_REGION-GST_REGION,  "Ship To State Code
    VRKME         TYPE VBRP-VRKME,              "Unit
    NETPR         TYPE CHAR100,              "Rate
    MWSKZ         TYPE PRCD_ELEMENTS-MWSK1,              "Taxcode
    TAX_TXT       TYPE T007S-TEXT1,             "Tax Code Description
    TES           TYPE CHAR100,              "Testing Charge
    ASS_GST       TYPE STRING, "CHAR100,              "Assessable GST

    COM_CESS      TYPE CHAR100,              "Comp Cess%
    COM_CESS_V    TYPE CHAR100,              "Comp Cess Amt
*    tcs_p         TYPE prcd_elements-kbetr,              "TCS Per
    TCS_P         TYPE P DECIMALS 2,              "TCS Per
    TCS           TYPE CHAR20,              "TCS amt
    HKONT         TYPE BSEG-HKONT,              "Sales Ledger
    PORT_CD       TYPE CHAR50,                  "Port Code
    SHP_BIL       TYPE CHAR20,                  "Shipping Bill Number
    SHP_BL_DT     TYPE CHAR15,                  "Shipping Bill Dt
    DEL_PROOF     TYPE CHAR15,                  "Proof of Delivery
    VTEXT_TAX     TYPE TSKDT-VTEXT,             "Tax Classification
    ZUONR         TYPE VBRK-ZUONR,              "Original Invoice Number
    KURRF_DAT     TYPE CHAR11, "vbrk-kurrf_dat,          "Invoice Date
    BELNR         TYPE BKPF-BELNR,              "FI Document No.
    BLART         TYPE BKPF-BLART,              "FI Document Type
*    cgst_p        TYPE prcd_elements-kbetr,              "CGST %
    CGST_P        TYPE P DECIMALS 2,              "CGST %
*    sgst_p        TYPE prcd_elements-kbetr,              "SGST %
    SGST_P        TYPE P DECIMALS 2,              "SGST %
*    igst_p        TYPE prcd_elements-kbetr,              "IGST %
    IGST_P        TYPE P DECIMALS 2,              "IGST %
    CURR_DATE     TYPE CHAR11,
    ADDRESS       TYPE STRING,      "" ** Address
    SAL_TXT       TYPE CHAR250,
    DELDATE       TYPE CHAR11,
    REF_DATE      TYPE STRING,            " Added By Abhishek Pisolkar (26.03.2018)
    OFM_NO        TYPE STRING,
    AUPOS         TYPE VBRP-AUPOS,
    LGORT         TYPE VBRP-LGORT, "added by jyoti on 11.06.2024
    LGORT1        TYPE LIPS-LGORT, "added by jyoti on 11.06.2024
    DIS_RATE      TYPE CHAR100,        "Discount
    DIS_AMT       TYPE STRING, "P DECIMALS 2, "string,"PRCD_ELEMENTS-KWERT,        "Discount
    DIS_UNIT_RATE TYPE STRING, "P DECIMALS 2,STRING,"PRCD_ELEMENTS-KWERT,

*    Rep_Date      type char10,

*    deldate       TYPE vbap-deldate,
*    kunnr         TYPE kna1-kunnr,              "Ship To Party


*    mwskz         TYPE konv-mwsk1,              "Taxcode
*    tax_txt       TYPE t007s-text1,             "Tax Code Description








*    **    vkorg       TYPE vbrk-vkorg,      "Sales Org.
**    vtweg       TYPE vbrk-vtweg,      "Distribution Chanel


**    netwr       TYPE vbrp-netwr,      "Amount in doc currrency
**    vgbel       TYPE vbrp-vgbel,      "Delivery No.
*    vgpos       TYPE vbrp-vgpos,      "Delivery Item
**    vgtyp       TYPE vbrp-vgtyp,
**    aupos       TYPE vbrp-aupos,      "Sales Item
  END OF T_FINAL,
  TT_FINAL TYPE STANDARD TABLE OF T_FINAL.

DATA:
  GT_FINAL TYPE TT_FINAL.

TYPES:
  BEGIN OF TY_FINAL,
    WERKS         TYPE VBRP-WERKS,      "Plant
    VBELN         TYPE VBRK-VBELN,      "Inv No
    XBLNR         TYPE VBRK-XBLNR,      "ODN Number
    POSNR         TYPE VBRP-POSNR,      "Line Item
    FKART         TYPE VBRK-FKART,      "Billing Type
    FKDAT         TYPE CHAR11, "vbrk-fkdat,      "Billing Date
    AUART         TYPE VBAK-AUART,      "Sales Order Type
    VKBUR         TYPE VBAK-VKBUR,      "Sales Office
    AUBEL         TYPE VBRP-AUBEL,      "Sales Order No
    AUDAT         TYPE CHAR11, "vbak-audat,      "Sales Order Date
    VDATU         TYPE CHAR11, "vbak-vdatu,      "Req Delivery Date
    EDATU         TYPE CHAR11, "vbep-edatu,        "Delivery Date
    BSTNK         TYPE VBAK-BSTNK,      "Customer Ref No.
    KUNAG         TYPE VBRK-KUNAG,      "Customer Code
    NAME1         TYPE KNA1-NAME1,        "Customer Name
    MATNR         TYPE VBRP-MATNR,      "Material Code
    ARKTX         TYPE VBRP-ARKTX,      "Sales Text
    LONG_TXT      TYPE CHAR100,         "Long Text for Material
    FKIMG         TYPE CHAR15, "vbrp-fkimg,      "Invoice Qty
    BASE_VAL      TYPE CHAR100,        "Base Price
    WAERK         TYPE VBRK-WAERK,      "Currency
    KURSK         TYPE VBRP-KURSK,      "Exchange Rate
    VAL_INR       TYPE CHAR100,      "Amount in Local Currency
    PF_VAL        TYPE CHAR100,        "P&F
*    DIS2          TYPE CHAR100,        "Discount
    DIS           TYPE  STRING, " P DECIMALS 2, "CHAR100,        "Discount
    ASS_VAL       TYPE STRING, "P DECIMALS 2,CHAR100,        "Assessable
    EXE_VAL       TYPE CHAR100,        "Excise Duty
    EDU_VAL       TYPE CHAR100,        "Education Cess Amount
    HSE_VAL       TYPE CHAR100,        "Higher Education Cess Amount
    VAT           TYPE CHAR100,        "VAT/CST
    FRT           TYPE CHAR100,        "Freight
    INS           TYPE CHAR100,        "Insurance
    CGST          TYPE CHAR100,        "CGST
    SGST          TYPE CHAR100,        "SGST
    IGST          TYPE CHAR100,        "JOIG
    TOT           TYPE STRING, "CHAR100,        "Grand Total
    PRODH         TYPE VBRP-PRODH,      "Product Heirarchy
    STEUC         TYPE MARC-STEUC,        "HSN Code
    VTEXT         TYPE TVKTT-VTEXT,       "Sales Type Text
    TRANS         TYPE CHAR30,            "Transporter Name
    LR_NO         TYPE CHAR20,            "L/R No.
    LR_DT         TYPE CHAR10,            "LR Date
    TRATY         TYPE CHAR20,        "Transport Type
    FRT_TYP       TYPE CHAR40,            "Freight Type
    INT_PR        TYPE CHAR100,             "Internal Price
    STPRS         TYPE CHAR100,        "Cost
    STPRS1        TYPE CHAR100,        "Cost
    ZSERIES       TYPE MARA-ZSERIES,      "Series
    ZSIZE         TYPE MARA-ZSIZE,        "Size
    BRAND         TYPE MARA-BRAND,              "Brand
    MOC           TYPE MARA-MOC,                "MOC
    TYPE          TYPE MARA-TYPE,               "Type
    LD_TG         TYPE CHAR20,                  "LD Tag
    ZLDFROMDATE   TYPE CHAR11, "vbak-zldfromdate,  "LD Date
    ZLDPERWEEK    TYPE VBAK-ZLDPERWEEK,
    ZLDMAX        TYPE VBAK-ZLDMAX,             "LD%
    VTEXT1        TYPE SKAT-TXT20,             "Sales Ledger Head
    STATUS        TYPE C,                       "Invoice Status
    KDMAT         TYPE VBAP-KDMAT,              "Customer Item Code
    STCD3         TYPE KNA1-STCD3,              "GSTIN No
    BEZEI         TYPE T005U-BEZEI,             "Region
    GST_REGION    TYPE ZGST_REGION-GST_REGION,  "State Code
    KUNNR         TYPE KNA1-KUNNR,              "Ship To Party
    NAME1_SH      TYPE KNA1-NAME1,
    BEZEI_SH      TYPE T005U-BEZEI,             " Ship To Region
    GST_REGION_SH TYPE ZGST_REGION-GST_REGION,  "Ship To State Code
    VRKME         TYPE VBRP-VRKME,              "Unit
    NETPR         TYPE CHAR100,              "Rate
    MWSKZ         TYPE PRCD_ELEMENTS-MWSK1,              "Taxcode
    TAX_TXT       TYPE T007S-TEXT1,             "Tax Code Description
    TES           TYPE CHAR100,              "Testing Charge
    ASS_GST       TYPE CHAR100,              "Assessable GST
    COM_CESS      TYPE CHAR100,              "Comp Cess%
    COM_CESS_V    TYPE CHAR100,              "Comp Cess Amt
*    tcs_p         TYPE prcd_elements-kbetr,              "TCS Per
    TCS_P         TYPE P DECIMALS 2,              "TCS Per
    TCS           TYPE CHAR20,              "TCS amt
    HKONT         TYPE BSEG-HKONT,              "Sales Ledger
    PORT_CD       TYPE CHAR50,                  "Port Code
    SHP_BIL       TYPE CHAR20,                  "Shipping Bill Number
    SHP_BL_DT     TYPE CHAR15,                  "Shipping Bill Dt
    DEL_PROOF     TYPE CHAR15,                  "Proof of Delivery
    VTEXT_TAX     TYPE TSKDT-VTEXT,             "Tax Classification
    ZUONR         TYPE VBRK-ZUONR,              "Original Invoice Number
    KURRF_DAT     TYPE CHAR11, "vbrk-kurrf_dat,          "Invoice Date
    BELNR         TYPE BKPF-BELNR,              "FI Document No.
    BLART         TYPE BKPF-BLART,              "FI Document Type
*    cgst_p        TYPE prcd_elements-kbetr,              "CGST %
    CGST_P        TYPE P DECIMALS 2,              "CGST %
*    sgst_p        TYPE prcd_elements-kbetr,              "SGST %
    SGST_P        TYPE P DECIMALS 2,              "SGST %
*    igst_p        TYPE prcd_elements-kbetr,              "IGST %
    IGST_P        TYPE P DECIMALS 2,              "IGST %
    CURR_DATE     TYPE CHAR11,
    ADDRESS       TYPE STRING,      "" ** Address
    SAL_TXT       TYPE CHAR250,
    DELDATE       TYPE CHAR11,
    REF_DATE      TYPE CHAR11,            " Added By Abhishek Pisolkar (26.03.2018)
    OFM_NO        TYPE STRING,
    AUPOS         TYPE VBRP-AUPOS,
    LGORT         TYPE VBRP-LGORT, "added by jyoti on 11.06.2024
    LGORT1        TYPE LIPS-LGORT, "added by NC 05.09.2025
    DIS_RATE      TYPE CHAR100, "P DECIMALS 2, "CHAR100,        "Discount
    DIS_AMT       TYPE CHAR100, "P DECIMALS 2, "string,"PRCD_ELEMENTS-KWERT,        "Discount
    DIS_UNIT_RATE TYPE CHAR100, "P DECIMALS 2, "string,"PRCD_ELEMENTS-KWERT,
**    vkorg       TYPE vbrk-vkorg,      "Sales Org.
**    vtweg       TYPE vbrk-vtweg,      "Distribution Chanel


**    netwr       TYPE vbrp-netwr,      "Amount in doc currrency
**    vgbel       TYPE vbrp-vgbel,      "Delivery No.
*    vgpos       TYPE vbrp-vgpos,      "Delivery Item
**    vgtyp       TYPE vbrp-vgtyp,
**    aupos       TYPE vbrp-aupos,      "Sales Item
  END OF TY_FINAL.
DATA : LVDIS  TYPE P DECIMALS 2.
DATA : LVASSVAL  TYPE P DECIMALS 2.

DATA: IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL.
DATA : GV_KBETR2 TYPE PRCD_ELEMENTS-KBETR.
DATA : GV_KBETR3 TYPE PRCD_ELEMENTS-KBETR.
DATA : GV_KBETR TYPE PRCD_ELEMENTS-KBETR.
DATA : GV_KWERT TYPE PRCD_ELEMENTS-KWERT.
DATA : GV_KWERT2 TYPE PRCD_ELEMENTS-KWERT.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE XYZ.
  SELECT-OPTIONS: SO_VBELN FOR TMP_VBELN,
                  SO_FKDAT FOR TMP_FKDAT OBLIGATORY DEFAULT '20170401' TO SY-DATUM,
                  SO_ORD   FOR TMP_SO,
                  SO_KUNNR FOR TMP_KUNNR.

  PARAMETERS : P_LGORT TYPE VBRP-LGORT. "ADDED BY JYOTI ON 13.06.2024
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE ABC .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'. "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.


*SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE pqr .
*PARAMETERS p_own AS CHECKBOX.
**PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
*SELECTION-SCREEN END OF BLOCK b6.

INITIALIZATION.
  XYZ = 'Select Options'(tt1).
  ABC = 'Download File'(tt2).
*  pqr = 'Download File to Own PC'(tt3).

AT SELECTION-SCREEN.
  IF NOT SO_VBELN IS INITIAL.
    SELECT SINGLE VBELN
            FROM  VBRK
            INTO  DMP_VBELN
            WHERE VBELN IN SO_VBELN.
    IF NOT SY-SUBRC IS  INITIAL.
      MESSAGE 'Please Check Billing Document No.' TYPE 'E'.
    ENDIF.

  ENDIF.

  IF NOT SO_ORD IS INITIAL.
    SELECT SINGLE AUBEL
            FROM  VBRP
            INTO  DMP_ORD
            WHERE AUBEL IN SO_ORD.
    IF NOT SY-SUBRC IS  INITIAL.
      MESSAGE 'Please Check Sales Order No.' TYPE 'E'.
    ENDIF.

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
    LT_SALES_INV_HDR       TYPE TT_SALES_INV_HDR,
    LS_SALES_INV_HDR       TYPE T_SALES_INV_HDR,
    LT_SALES_INV_ITEM      TYPE TT_SALES_INV_ITEM,
    LS_SALES_INV_ITEM      TYPE T_SALES_INV_ITEM,
    LT_SALES_ORD_HDR       TYPE TT_SALES_ORD_HDR,
    LS_SALES_ORD_HDR       TYPE T_SALES_ORD_HDR,
    LT_SALES_ORD_ITEM      TYPE TT_SALES_ORD_ITEM,
    LS_SALES_ORD_ITEM      TYPE T_SALES_ORD_ITEM,
    LT_SALES_PARTNER       TYPE TT_SALES_PARTNER,
    LS_SALES_PARTNER       TYPE T_SALES_PARTNER,
    LT_CUST_INFO           TYPE TT_CUST_INFO,
    LS_CUST_INFO           TYPE T_CUST_INFO,
    LT_SCHEDULE_LINE       TYPE TT_SCHEDULE_LINE,
    LS_SCHEDULE_LINE       TYPE T_SCHEDULE_LINE,
    LT_TVKTT               TYPE TT_TVKTT,
    LS_TVKTT               TYPE T_TVKTT,
    LT_CONDITIONS          TYPE TT_CONDITIONS,
    LS_CONDITIONS          TYPE T_CONDITIONS,
    LT_MAT_MASTER          TYPE TT_MAT_MASTER,
    LS_MAT_MASTER          TYPE T_MAT_MASTER,
    LT_MATERIAL_VAL        TYPE TT_MATERIAL_VAL,
    LS_MATERIAL_VAL        TYPE T_MATERIAL_VAL,
    LT_MARC                TYPE TT_MARC,
    LS_MARC                TYPE T_MARC,
    LT_SALES_BUSS          TYPE TT_SALES_BUSS,
    LS_SALES_BUSS          TYPE T_SALES_BUSS,
    LT_T005U               TYPE TT_T005U,
    LS_T005U               TYPE T_T005U,
    LT_ZGST_REGION         TYPE TT_ZGST_REGION,
    LS_ZGST_REGION         TYPE T_ZGST_REGION,
    LT_T007S               TYPE TT_T007S,
    LS_T007S               TYPE T_T007S,
    LT_KNVI                TYPE TT_KNVI,
    LS_KNVI                TYPE T_KNVI,
    LT_TSKDT               TYPE TT_TSKDT,
    LS_TSKDT               TYPE T_TSKDT,
    LT_ACCOUNTING_DOC_ITEM TYPE TT_ACCOUNTING_DOC_ITEM,
    LT_ACCOUNTING_DOC_ITM1 TYPE TT_ACCOUNTING_DOC_ITEM,   "For GL Account
    LS_ACCOUNTING_DOC_ITEM TYPE T_ACCOUNTING_DOC_ITEM,
    LT_ACCOUNTING_DOC_HDR  TYPE TT_ACCOUNTING_DOC_HDR,
    LS_ACCOUNTING_DOC_HDR  TYPE T_ACCOUNTING_DOC_HDR,
    LT_SKAT                TYPE TT_SKAT,
    LS_SKAT                TYPE T_SKAT,
    LS_FINAL               TYPE T_FINAL,
    LT_ADRC                TYPE TT_ADRC,
    LS_ADRC                TYPE T_ADRC,
    LS_SAL_TXT             TYPE T_SAL_TXT.

  DATA:
    LV_ID    TYPE THEAD-TDNAME,
    LT_LINES TYPE STANDARD TABLE OF TLINE,
    LS_LINES TYPE TLINE.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      TEXT       = 'Reading data...'(i01)
      PERCENTAGE = 1.

  "Fetch Data for Invoice Header
  IF NOT SO_ORD IS INITIAL.
    IF P_LGORT IS NOT INITIAL. "ADDED BY JYOTI ON 13.06.2024
      SELECT VBELN
             POSNR
             FKIMG
             VRKME
             KURSK
             NETWR
             VGBEL
             VGPOS
             VGTYP
             AUBEL
             AUPOS
             MATNR
             ARKTX
             CHARG
             PRODH
             WERKS
             LGORT   "ADDED by jyoti on 11.06.2024
        FROM VBRP
        INTO TABLE LT_SALES_INV_ITEM
        WHERE VBELN IN SO_VBELN
      AND   AUBEL IN SO_ORD
        AND LGORT = P_LGORT "ADDED BY JYOTI ON 13.06.2024
        AND WERKS = 'PL01'." ADDED BY MD
    ELSE.
      SELECT VBELN
       POSNR
       FKIMG
       VRKME
       KURSK
       NETWR
       VGBEL
       VGPOS
       VGTYP
       AUBEL
       AUPOS
       MATNR
       ARKTX
       CHARG
       PRODH
       WERKS
       LGORT   "ADDED by jyoti on 11.06.2024
  FROM VBRP
  INTO TABLE LT_SALES_INV_ITEM
  WHERE VBELN IN SO_VBELN
AND   AUBEL IN SO_ORD
*      AND LGORT = P_LGORT "ADDED BY JYOTI ON 13.06.2024
  AND WERKS = 'PL01'." ADDED BY MD
    ENDIF.

    IF SY-SUBRC IS INITIAL.

      SELECT VBELN
             FKART
             FKTYP
             WAERK
             VKORG
             VTWEG
             KNUMV
             FKDAT
             KUNAG
             KTGRD
             FKSTO
             XBLNR
             ZUONR
             KURRF_DAT
             KURRF
        FROM VBRK
        INTO TABLE LT_SALES_INV_HDR
        FOR ALL ENTRIES IN LT_SALES_INV_ITEM
        WHERE VBELN = LT_SALES_INV_ITEM-VBELN
        AND   FKDAT IN SO_FKDAT
        AND   KUNAG IN SO_KUNNR.

    ELSE.
*      MESSAGE 'Data Not Found' TYPE 'I'.
      MESSAGE 'Data Not Found' TYPE 'I' DISPLAY LIKE 'E'.. "ADDED BY PRIMUS JYOTI ON 10.04.2024
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    SELECT VBELN
           FKART
           FKTYP
           WAERK
           VKORG
           VTWEG
           KNUMV
           FKDAT
           KUNAG
           KTGRD
           FKSTO
           XBLNR
           ZUONR
           KURRF_DAT
            KURRF
      FROM VBRK
      INTO TABLE LT_SALES_INV_HDR
      WHERE VBELN IN SO_VBELN
      AND   FKDAT IN SO_FKDAT
      AND   KUNAG IN SO_KUNNR
      AND   FKART NOT IN ('ZF5','ZF8','F5','F8','ZSN','ZSP','ZS1').

  ENDIF.

***  DELETE lt_sales_inv_hdr WHERE fkart ='ZSN'. " Challan Skip
***  DELETE lt_sales_inv_hdr WHERE fkart = 'ZSP'. " Challan Skip
***  DELETE lt_sales_inv_hdr WHERE fkart = 'ZS1'. " Cancel Invoice Skip

  IF NOT LT_SALES_INV_HDR IS INITIAL.
    SELECT BUKRS
           BELNR
           GJAHR
           BUZEI
           VBELN
           VBEL2
           POSN2
           HKONT
           KUNNR
           ZFBDT
           MWSK1
           DMBT1
           REBZG
           REBZJ
      FROM BSEG
      INTO TABLE LT_ACCOUNTING_DOC_ITEM
      FOR ALL ENTRIES IN LT_SALES_INV_HDR
      WHERE VBELN = LT_SALES_INV_HDR-VBELN
      %_HINTS ORACLE 'INDEX("BSEG""BSEG~ZVB")'.

    SORT LT_ACCOUNTING_DOC_ITEM BY BELNR.
    DELETE ADJACENT DUPLICATES FROM LT_ACCOUNTING_DOC_ITEM.
    IF NOT LT_ACCOUNTING_DOC_ITEM IS INITIAL.
      SELECT BUKRS
           BELNR
           GJAHR
           BUZEI
           VBELN
           VBEL2
           POSN2
           HKONT
           KUNNR
           ZFBDT
           MWSK1
           DMBT1
           REBZG
           REBZJ
      FROM BSEG
      INTO TABLE LT_ACCOUNTING_DOC_ITM1
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_ITEM
      WHERE BELNR = LT_ACCOUNTING_DOC_ITEM-BELNR
      AND   GJAHR = LT_ACCOUNTING_DOC_ITEM-GJAHR
      AND   XBILK = SPACE.

      SELECT SAKNR
             TXT20
        FROM SKAT
        INTO TABLE LT_SKAT
        FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_ITM1
        WHERE SAKNR = LT_ACCOUNTING_DOC_ITM1-HKONT
        AND   SPRAS = SY-LANGU
        AND   KTOPL = '1000'.

      SELECT BUKRS
             BELNR
             GJAHR
             BLART
             XBLNR
             BKTXT
        FROM BKPF
        INTO TABLE LT_ACCOUNTING_DOC_HDR
        FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_ITEM
        WHERE BELNR = LT_ACCOUNTING_DOC_ITEM-BELNR
        AND   GJAHR = LT_ACCOUNTING_DOC_ITEM-GJAHR.

    ENDIF.
    IF P_LGORT IS INITIAL.
      SELECT VBELN
           POSNR
           FKIMG
           VRKME
           KURSK
           NETWR
           VGBEL
           VGPOS
           VGTYP
           AUBEL
           AUPOS
           MATNR
           ARKTX
           CHARG
           PRODH
           WERKS
           LGORT   "added by jyoti on 11.06.2024
      FROM VBRP
      INTO TABLE LT_SALES_INV_ITEM
      FOR ALL ENTRIES IN LT_SALES_INV_HDR
      WHERE VBELN = LT_SALES_INV_HDR-VBELN
*      AND LGORT = P_LGORT "ADDED BY JYOTI ON 13.06.2024
        AND WERKS = 'PL01'.
    ELSE.
      SELECT VBELN
        POSNR
        FKIMG
        VRKME
        KURSK
        NETWR
        VGBEL
        VGPOS
        VGTYP
        AUBEL
        AUPOS
        MATNR
        ARKTX
        CHARG
        PRODH
        WERKS
        LGORT   "added by jyoti on 11.06.2024
   FROM VBRP
   INTO TABLE LT_SALES_INV_ITEM
   FOR ALL ENTRIES IN LT_SALES_INV_HDR
   WHERE VBELN = LT_SALES_INV_HDR-VBELN
     AND LGORT = P_LGORT "ADDED BY JYOTI ON 13.06.2024
     AND WERKS = 'PL01'.
    ENDIF.

    SELECT VBELN
           POSNR
           MATNR
           KDMAT
           DELDATE
      FROM VBAP
      INTO TABLE LT_SALES_ORD_ITEM
      FOR ALL ENTRIES IN LT_SALES_INV_ITEM
      WHERE VBELN = LT_SALES_INV_ITEM-AUBEL
      AND   POSNR = LT_SALES_INV_ITEM-AUPOS.

    SELECT KTGRD
           VTEXT
      FROM TVKTT
      INTO TABLE LT_TVKTT
      FOR ALL ENTRIES IN LT_SALES_INV_HDR
      WHERE KTGRD = LT_SALES_INV_HDR-KTGRD
      AND   SPRAS = SY-LANGU.


    SELECT KNUMV
           KPOSN
           KSCHL
           KBETR
           MWSK1
           KWERT
           KSTAT
           KINAK
      FROM PRCD_ELEMENTS  "konv
      INTO TABLE LT_CONDITIONS
      FOR ALL ENTRIES IN LT_SALES_INV_HDR
      WHERE KNUMV = LT_SALES_INV_HDR-KNUMV
      AND   KINAK = SPACE.

    SELECT MWSKZ
           TEXT1
      FROM T007S
      INTO TABLE LT_T007S
      FOR ALL ENTRIES IN LT_CONDITIONS
      WHERE MWSKZ = LT_CONDITIONS-MWSK1
      AND   KALSM = 'ZTAXIN'.

    IF NOT LT_SALES_INV_ITEM IS INITIAL.

      SELECT VBELN
             AUDAT
             AUART
             VKBUR
             VDATU
             BSTNK
             ZLDFROMDATE
             ZLDPERWEEK
             ZLDMAX
        FROM VBAK
        INTO TABLE LT_SALES_ORD_HDR
        FOR ALL ENTRIES IN LT_SALES_INV_ITEM
      WHERE VBELN = LT_SALES_INV_ITEM-AUBEL.

      SELECT KUNNR
             NAME1
             LAND1
             REGIO
             ADRNR
             STCD3
        FROM KNA1
        INTO TABLE LT_CUST_INFO
        FOR ALL ENTRIES IN LT_SALES_INV_HDR
        WHERE KUNNR = LT_SALES_INV_HDR-KUNAG.


      SELECT VBELN
             KUNNR
        FROM VBPA
        INTO TABLE LT_SALES_PARTNER
        FOR ALL ENTRIES IN LT_SALES_ORD_HDR
        WHERE VBELN = LT_SALES_ORD_HDR-VBELN
        AND   PARVW IN ('SH','WE').

      SELECT KUNNR
             NAME1
             LAND1
             REGIO
             ADRNR
             STCD3
        FROM KNA1
        APPENDING TABLE LT_CUST_INFO
        FOR ALL ENTRIES IN LT_SALES_PARTNER
        WHERE KUNNR = LT_SALES_PARTNER-KUNNR.

      SORT LT_CUST_INFO BY KUNNR.
      DELETE ADJACENT DUPLICATES FROM LT_CUST_INFO.
      IF NOT LT_CUST_INFO IS INITIAL.
        SELECT ADDRNUMBER
               NAME1
               CITY2
               POST_CODE1
               STREET
               STR_SUPPL1
               STR_SUPPL2
               STR_SUPPL3
               LOCATION
               COUNTRY
          FROM ADRC
          INTO TABLE LT_ADRC
          FOR ALL ENTRIES IN LT_CUST_INFO
          WHERE ADDRNUMBER = LT_CUST_INFO-ADRNR.

        SELECT KUNNR
               TAXKD
          FROM KNVI
          INTO TABLE LT_KNVI
          FOR ALL ENTRIES IN LT_CUST_INFO
          WHERE KUNNR = LT_CUST_INFO-KUNNR
          AND   TATYP IN ('JOCG','JOIG').


        IF SY-SUBRC IS INITIAL.
          SELECT TATYP
                 TAXKD
                 VTEXT
            FROM TSKDT
            INTO TABLE LT_TSKDT
            FOR ALL ENTRIES IN LT_KNVI
            WHERE TAXKD = LT_KNVI-TAXKD
            AND   SPRAS = SY-LANGU.


        ENDIF.
        SELECT LAND1
               BLAND
               BEZEI
          FROM T005U
          INTO TABLE LT_T005U
          FOR ALL ENTRIES IN LT_CUST_INFO
          WHERE SPRAS = SY-LANGU
          AND   LAND1 = LT_CUST_INFO-LAND1
          AND   BLAND = LT_CUST_INFO-REGIO.

        SELECT GST_REGION
               BEZEI
          FROM ZGST_REGION
          INTO TABLE LT_ZGST_REGION
          FOR ALL ENTRIES IN LT_T005U
          WHERE BEZEI = LT_T005U-BEZEI.

      ENDIF.
      SELECT VBELN
             POSNR
             EDATU
        FROM VBEP
        INTO TABLE LT_SCHEDULE_LINE
        FOR ALL ENTRIES IN LT_SALES_ORD_HDR
      WHERE VBELN = LT_SALES_ORD_HDR-VBELN.

      SELECT MATNR
             ZSERIES
             ZSIZE
             BRAND
             MOC
             TYPE
        FROM MARA
        INTO TABLE LT_MAT_MASTER
        FOR ALL ENTRIES IN LT_SALES_INV_ITEM
      WHERE MATNR = LT_SALES_INV_ITEM-MATNR.

      SELECT MATNR
             BWKEY
             BWTAR
             STPRS
        FROM MBEW
        INTO TABLE LT_MATERIAL_VAL
        FOR ALL ENTRIES IN LT_SALES_INV_ITEM
      WHERE MATNR = LT_SALES_INV_ITEM-MATNR.

      SELECT MATNR
             WERKS
             STEUC
        FROM MARC
        INTO TABLE LT_MARC
        FOR ALL ENTRIES IN LT_SALES_INV_ITEM
      WHERE MATNR = LT_SALES_INV_ITEM-MATNR.

      SELECT VBELN
             POSNR
             TRATY
        FROM VBKD
        INTO TABLE LT_SALES_BUSS
        FOR ALL ENTRIES IN LT_SALES_INV_ITEM
        WHERE VBELN = LT_SALES_INV_ITEM-AUBEL
      AND   POSNR = LT_SALES_INV_ITEM-AUPOS.

    ENDIF.
  ENDIF.

*  IF lt_sales_inv_item IS INITIAL.
**    MESSAGE 'Data Not Found' TYPE 'E'.
*     MESSAGE 'Data Not Found' TYPE 'I' DISPLAY LIKE 'E'..
*      LEAVE LIST-PROCESSING.
*
*  ELSE.

  IF LT_SALES_INV_ITEM IS NOT INITIAL .
    SELECT VBELN , VBELV , POSNV
      FROM VBFA
      INTO TABLE @DATA(IT_VBFA)
        FOR ALL ENTRIES IN @LT_SALES_INV_ITEM
          WHERE VBELN = @LT_SALES_INV_ITEM-VBELN
           AND  POSNV = @LT_SALES_INV_ITEM-POSNR
           AND  VBTYP_V = 'J'.

    IF IT_VBFA IS NOT INITIAL .
      SELECT LGORT , VBELN , POSNR
        FROM LIPS
          INTO TABLE @DATA(IT_LIPS)
           FOR ALL ENTRIES IN @IT_VBFA
            WHERE VBELN = @IT_VBFA-VBELV
             AND  POSNR = @IT_VBFA-POSNV.
    ENDIF.
  ENDIF.

  LOOP AT LT_SALES_INV_ITEM INTO LS_SALES_INV_ITEM.

    READ TABLE IT_VBFA INTO DATA(WA_VBFA) WITH KEY VBELN = LS_SALES_INV_ITEM-VBELN
                                                   POSNV = LS_SALES_INV_ITEM-POSNR.
    IF SY-SUBRC EQ 0 .
      READ TABLE IT_LIPS INTO DATA(WA_LIPS) WITH KEY VBELN = WA_VBFA-VBELV
                                                     POSNR = WA_VBFA-POSNV.
      IF SY-SUBRC EQ 0 .

        LS_FINAL-LGORT1   = WA_LIPS-LGORT .

      ENDIF.
    ENDIF.

    LS_FINAL-VBELN = LS_SALES_INV_ITEM-VBELN.
    LS_FINAL-POSNR = LS_SALES_INV_ITEM-POSNR.
    LS_FINAL-FKIMG = LS_SALES_INV_ITEM-FKIMG.
    IF LS_FINAL-FKIMG IS INITIAL.
      LS_FINAL-FKIMG = '0'.
    ENDIF.
    LS_FINAL-VRKME = LS_SALES_INV_ITEM-VRKME.
*      IF ls_sales_inv_item-netwr LT 0.
*        ls_final-netwr = ls_sales_inv_item-netwr * -1.
*      ELSE.
*        ls_final-netwr = ls_sales_inv_item-netwr.
*      ENDIF.

*      ls_final-vgbel = ls_sales_inv_item-vgbel.
*      ls_final-vgpos = ls_sales_inv_item-vgpos. """""
*      ls_final-vgtyp = ls_sales_inv_item-vgtyp.
    LS_FINAL-AUBEL = LS_SALES_INV_ITEM-AUBEL.
    LS_FINAL-AUPOS = LS_SALES_INV_ITEM-AUPOS.
    LS_FINAL-MATNR = LS_SALES_INV_ITEM-MATNR.
    LS_FINAL-ARKTX = LS_SALES_INV_ITEM-ARKTX.
    LS_FINAL-PRODH = LS_SALES_INV_ITEM-PRODH.
    LS_FINAL-WERKS = LS_SALES_INV_ITEM-WERKS.
    LS_FINAL-LGORT = LS_SALES_INV_ITEM-LGORT."added by jyoti on 11.06.2024
*      ls_final-kursk = ls_sales_inv_item-kursk.
*      ls_final-val_inr = ls_sales_inv_item-kursk * ls_final-netwr.
************************************************************************************************************************

**********************************************************************************************************************

    READ TABLE LT_SALES_ORD_HDR INTO LS_SALES_ORD_HDR WITH KEY VBELN = LS_SALES_INV_ITEM-AUBEL.
    IF SY-SUBRC IS INITIAL.
      IF NOT LS_SALES_ORD_HDR-AUDAT IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SALES_ORD_HDR-AUDAT
          IMPORTING
            OUTPUT = LS_FINAL-AUDAT.

        CONCATENATE  LS_FINAL-AUDAT+0(2)  LS_FINAL-AUDAT+2(3)  LS_FINAL-AUDAT+5(4)
                        INTO  LS_FINAL-AUDAT SEPARATED BY '-'.
*
*        CONCATENATE LS_SALES_ORD_HDR-AUDAT+6(2) LS_SALES_ORD_HDR-AUDAT+4(2) LS_SALES_ORD_HDR-AUDAT+0(4)
*           INTO LS_FINAL-AUDAT SEPARATED BY '-'.
*        ELSE.
*          ls_final-audat = 'NULL'.
      ENDIF.
      LS_FINAL-AUART       = LS_SALES_ORD_HDR-AUART.
      LS_FINAL-VKBUR       = LS_SALES_ORD_HDR-VKBUR.

*        ls_final-vdatu       = ls_sales_ord_hdr-vdatu.
      IF NOT LS_SALES_ORD_HDR-VDATU IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SALES_ORD_HDR-VDATU
          IMPORTING
            OUTPUT = LS_FINAL-VDATU.

        CONCATENATE  LS_FINAL-VDATU+0(2)  LS_FINAL-VDATU+2(3)  LS_FINAL-VDATU+5(4)
                INTO  LS_FINAL-VDATU SEPARATED BY '-'.

*        CONCATENATE LS_SALES_ORD_HDR-VDATU+6(2) LS_SALES_ORD_HDR-VDATU+4(2) LS_SALES_ORD_HDR-VDATU+0(4)
*           INTO LS_FINAL-VDATU SEPARATED BY '-'.
*        ELSE.
*          ls_final-vdatu = 'NULL'.
      ENDIF.

      LS_FINAL-BSTNK       = LS_SALES_ORD_HDR-BSTNK.

      IF NOT LS_SALES_ORD_HDR-ZLDFROMDATE IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SALES_ORD_HDR-ZLDFROMDATE
          IMPORTING
            OUTPUT = LS_FINAL-ZLDFROMDATE.
        CONCATENATE LS_FINAL-ZLDFROMDATE+0(2) LS_FINAL-ZLDFROMDATE+2(3) LS_FINAL-ZLDFROMDATE+5(4)
                       INTO LS_FINAL-ZLDFROMDATE SEPARATED BY '-'.

*        CONCATENATE LS_SALES_ORD_HDR-ZLDFROMDATE+6(2) LS_SALES_ORD_HDR-ZLDFROMDATE+4(2) LS_SALES_ORD_HDR-ZLDFROMDATE+0(4)
*           INTO LS_FINAL-ZLDFROMDATE SEPARATED BY '-'.
*        ELSE.
*          ls_final-zldfromdate = 'NULL'.
      ENDIF.
      LS_FINAL-ZLDPERWEEK  = LS_SALES_ORD_HDR-ZLDPERWEEK.
      LS_FINAL-ZLDMAX      = LS_SALES_ORD_HDR-ZLDMAX.
    ENDIF.
    READ TABLE LT_SALES_INV_HDR INTO LS_SALES_INV_HDR WITH KEY VBELN = LS_SALES_INV_ITEM-VBELN.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-WAERK = LS_SALES_INV_HDR-WAERK.
      LS_FINAL-KURSK = LS_SALES_INV_HDR-KURRF.
*        ls_final-vtweg = ls_sales_inv_hdr-vtweg.
      IF NOT LS_SALES_INV_HDR-FKDAT IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SALES_INV_HDR-FKDAT
          IMPORTING
            OUTPUT = LS_FINAL-FKDAT.

        CONCATENATE  LS_FINAL-FKDAT+0(2)  LS_FINAL-FKDAT+2(3)  LS_FINAL-FKDAT+5(4)
                        INTO  LS_FINAL-FKDAT SEPARATED BY '-'.

*        CONCATENATE LS_SALES_INV_HDR-FKDAT+6(2) LS_SALES_INV_HDR-FKDAT+4(2) LS_SALES_INV_HDR-FKDAT+0(4)
*           INTO LS_FINAL-FKDAT SEPARATED BY '-'.

*        ELSE.
*          ls_final-fkdat = 'NULL'.
      ENDIF.
      LS_FINAL-FKART = LS_SALES_INV_HDR-FKART.
      LS_FINAL-KUNAG = LS_SALES_INV_HDR-KUNAG.
      LS_FINAL-XBLNR = LS_SALES_INV_HDR-XBLNR.
*        ls_final-ktgrd = ls_sales_inv_hdr-ktgrd.
      IF LS_FINAL-FKART = 'ZDR' OR LS_FINAL-FKART = 'ZCR'.
        LS_FINAL-ZUONR     = LS_SALES_INV_HDR-ZUONR.
        IF LS_FINAL-ZUONR IS INITIAL.
          LS_FINAL-ZUONR = LS_FINAL-XBLNR.
        ENDIF.

        IF NOT LS_SALES_INV_HDR-KURRF_DAT IS INITIAL.
          CONCATENATE LS_SALES_INV_HDR-KURRF_DAT+6(2) LS_SALES_INV_HDR-KURRF_DAT+4(2) LS_SALES_INV_HDR-KURRF_DAT+0(4)
             INTO LS_FINAL-KURRF_DAT SEPARATED BY '-'.

          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              INPUT  = LS_SALES_INV_HDR-KURRF_DAT
            IMPORTING
              OUTPUT = WA_FINAL-KURRF_DAT.


          CONCATENATE WA_FINAL-KURRF_DAT+0(2) WA_FINAL-KURRF_DAT+2(3) WA_FINAL-KURRF_DAT+5(4)
                    INTO WA_FINAL-KURRF_DAT SEPARATED BY '-'.

*          ELSE.
*            ls_final-kurrf_dat = 'NULL'.
        ENDIF.

      ENDIF.

    ENDIF.
    READ TABLE LT_ACCOUNTING_DOC_ITEM INTO LS_ACCOUNTING_DOC_ITEM WITH KEY VBELN = LS_SALES_INV_HDR-VBELN.
    IF SY-SUBRC IS INITIAL.

      READ TABLE LT_ACCOUNTING_DOC_HDR INTO LS_ACCOUNTING_DOC_HDR WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                                                           GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-BELNR = LS_ACCOUNTING_DOC_HDR-BELNR.
        LS_FINAL-BLART = LS_ACCOUNTING_DOC_HDR-BLART.
      ENDIF.
      READ TABLE LT_ACCOUNTING_DOC_ITM1 INTO LS_ACCOUNTING_DOC_ITEM WITH KEY BELNR = LS_ACCOUNTING_DOC_HDR-BELNR
                                                                             GJAHR = LS_ACCOUNTING_DOC_HDR-GJAHR.
*                                                                               vbel2 = ls_sales_inv_item-aubel
*                                                                               posn2 = ls_sales_inv_item-aupos.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-HKONT   = LS_ACCOUNTING_DOC_ITEM-HKONT.

        READ TABLE LT_SKAT INTO LS_SKAT WITH KEY SAKNR = LS_ACCOUNTING_DOC_ITEM-HKONT.
        IF SY-SUBRC IS INITIAL.
          LS_FINAL-VTEXT1 = LS_SKAT-TXT20.
        ENDIF.
      ENDIF.
    ENDIF.
    READ TABLE LT_SALES_ORD_ITEM INTO LS_SALES_ORD_ITEM WITH KEY VBELN = LS_SALES_INV_ITEM-AUBEL
                                                                 POSNR = LS_SALES_INV_ITEM-AUPOS.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-KDMAT = LS_SALES_ORD_ITEM-KDMAT.
*        ls_final-deldate = ls_sales_ord_item-deldate .
      IF LS_SALES_ORD_ITEM-DELDATE IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SALES_ORD_ITEM-DELDATE
          IMPORTING
            OUTPUT = LS_FINAL-DELDATE.
        CONCATENATE LS_FINAL-DELDATE+0(2) LS_FINAL-DELDATE+2(3) LS_FINAL-DELDATE+5(4)
                       INTO LS_FINAL-DELDATE SEPARATED BY '-'.

*        CONCATENATE LS_SALES_ORD_ITEM-DELDATE+6(2) LS_SALES_ORD_ITEM-DELDATE+4(2) LS_SALES_ORD_ITEM-DELDATE+0(4)
*           INTO LS_FINAL-DELDATE SEPARATED BY '-'.
      ENDIF.

    ENDIF.
    READ TABLE LT_CUST_INFO INTO LS_CUST_INFO WITH KEY KUNNR = LS_SALES_INV_HDR-KUNAG.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-NAME1 = LS_CUST_INFO-NAME1.
      LS_FINAL-STCD3 = LS_CUST_INFO-STCD3.
    ENDIF.
    READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_CUST_INFO-ADRNR.
    IF SY-SUBRC IS INITIAL.
      IF NOT LS_ADRC-STR_SUPPL1 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STR_SUPPL1 INTO LS_FINAL-ADDRESS.
      ENDIF.

      IF NOT LS_ADRC-STR_SUPPL2 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STR_SUPPL2 INTO LS_FINAL-ADDRESS.
      ENDIF.

      IF NOT LS_ADRC-STREET IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STREET INTO LS_FINAL-ADDRESS.
      ENDIF.

      IF NOT LS_ADRC-STR_SUPPL3 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STR_SUPPL3 INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.
      IF NOT LS_ADRC-LOCATION IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-LOCATION INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.

      IF NOT LS_ADRC-CITY2 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-CITY2 INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.
      IF NOT LS_ADRC-POST_CODE1 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS 'PIN:' LS_ADRC-POST_CODE1 INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.
      CONDENSE LS_FINAL-ADDRESS.

    ENDIF.
    READ TABLE LT_T005U INTO LS_T005U WITH KEY LAND1 = LS_CUST_INFO-LAND1
                                               BLAND = LS_CUST_INFO-REGIO.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-BEZEI = LS_T005U-BEZEI.
    ENDIF.

    IF LS_CUST_INFO-LAND1 = 'IN'.
      READ TABLE LT_KNVI INTO LS_KNVI WITH KEY KUNNR = LS_CUST_INFO-KUNNR.
      IF SY-SUBRC IS INITIAL.
        IF LS_CUST_INFO-REGIO = '13'.
          READ TABLE LT_TSKDT INTO LS_TSKDT WITH KEY TATYP = 'JOCG'.
          IF SY-SUBRC IS INITIAL.
            LS_FINAL-VTEXT_TAX = LS_TSKDT-VTEXT.
          ENDIF.
        ELSE.
          READ TABLE LT_TSKDT INTO LS_TSKDT WITH KEY TATYP = 'JOIG'.
          IF SY-SUBRC IS INITIAL.
            LS_FINAL-VTEXT_TAX = LS_TSKDT-VTEXT.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY BEZEI = LS_T005U-BEZEI.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-GST_REGION = LS_ZGST_REGION-GST_REGION.
    ENDIF.


    READ TABLE LT_SALES_PARTNER INTO LS_SALES_PARTNER WITH KEY VBELN = LS_SALES_ORD_HDR-VBELN.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-KUNNR  = LS_SALES_PARTNER-KUNNR.
    ENDIF.

    CLEAR:LS_CUST_INFO,LS_T005U,LS_ZGST_REGION.
    READ TABLE LT_CUST_INFO INTO LS_CUST_INFO WITH KEY KUNNR = LS_SALES_PARTNER-KUNNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-NAME1_SH = LS_CUST_INFO-NAME1.
*        ls_final-stcd3 = ls_cust_info-stcd3.
    ENDIF.

    READ TABLE LT_T005U INTO LS_T005U WITH KEY LAND1 = LS_CUST_INFO-LAND1
                                               BLAND = LS_CUST_INFO-REGIO.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-BEZEI_SH = LS_T005U-BEZEI.
    ENDIF.
    READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY BEZEI = LS_T005U-BEZEI.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-GST_REGION_SH = LS_ZGST_REGION-GST_REGION.
    ENDIF.

    READ TABLE LT_SCHEDULE_LINE INTO LS_SCHEDULE_LINE WITH KEY VBELN = LS_SALES_INV_ITEM-AUBEL
                                                               POSNR = LS_SALES_INV_ITEM-AUPOS.
    IF SY-SUBRC IS INITIAL.
      IF NOT LS_SCHEDULE_LINE-EDATU IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SCHEDULE_LINE-EDATU
          IMPORTING
            OUTPUT = LS_FINAL-EDATU.
        CONCATENATE LS_FINAL-EDATU+0(2) LS_FINAL-EDATU+2(3) LS_FINAL-EDATU+5(4)
                       INTO LS_FINAL-EDATU SEPARATED BY '-'.
*
*        CONCATENATE LS_SCHEDULE_LINE-EDATU+6(2) LS_SCHEDULE_LINE-EDATU+4(2) LS_SCHEDULE_LINE-EDATU+0(4)
*           INTO LS_FINAL-EDATU SEPARATED BY '-'.
*        ELSE.
*          ls_final-edatu = 'NULL'.
      ENDIF.
*      ELSE.
*        ls_final-edatu = 'NULL'.
    ENDIF.

    READ TABLE LT_TVKTT INTO LS_TVKTT WITH KEY KTGRD = LS_SALES_INV_HDR-KTGRD.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-VTEXT = LS_TVKTT-VTEXT.
*        ls_final-vtext1 = ls_tvktt-vtext.
    ENDIF.

    READ TABLE LT_MAT_MASTER INTO LS_MAT_MASTER WITH KEY MATNR = LS_SALES_INV_ITEM-MATNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-ZSERIES = LS_MAT_MASTER-ZSERIES.
      LS_FINAL-ZSIZE   = LS_MAT_MASTER-ZSIZE.
      LS_FINAL-BRAND   = LS_MAT_MASTER-BRAND.
      LS_FINAL-MOC     = LS_MAT_MASTER-MOC.
      LS_FINAL-TYPE    = LS_MAT_MASTER-TYPE.
    ENDIF.

    READ TABLE LT_MATERIAL_VAL INTO LS_MATERIAL_VAL WITH KEY MATNR = LS_SALES_INV_ITEM-MATNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-STPRS  = LS_MATERIAL_VAL-STPRS.
      LS_FINAL-STPRS1 = LS_MATERIAL_VAL-STPRS.
    ELSE.
      LS_FINAL-STPRS  = '0'.
      LS_FINAL-STPRS1 = '0'.
    ENDIF.
    READ TABLE LT_MARC INTO LS_MARC WITH KEY MATNR = LS_SALES_INV_ITEM-MATNR  WERKS ='PL01'.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-STEUC = LS_MARC-STEUC.
    ENDIF.
***      READ TABLE lt_sales_buss INTO ls_sales_buss WITH KEY vbeln = ls_sales_inv_item-aubel
***                                                           posnr = ls_sales_inv_item-aupos.
***      IF sy-subrc IS INITIAL.
***        ls_final-traty = ls_sales_buss-traty.
***      ENDIF.

    "Base Price
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZPR0'
                                                         KINAK = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-BASE_VAL = LS_CONDITIONS-KWERT.
*        ls_final-val_inr  = ls_conditions-kwert * ls_sales_inv_item-kursk.
      VAL_INR2  = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
      LS_FINAL-VAL_INR = VAL_INR2.
      LS_FINAL-NETPR    = LS_FINAL-BASE_VAL / LS_FINAL-FKIMG.
    ENDIF.

    "Discount Price
    READ TABLE LT_CONDITIONS INTO DATA(LS_CONDITIONS2) WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZDIS'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      DIS3 = LS_CONDITIONS2-KWERT * LS_SALES_INV_HDR-KURRF.
      LS_FINAL-DIS = DIS3.
      CONDENSE LS_FINAL-DIS.
*        ls_final-dis = ls_conditions-kwert * ls_sales_inv_item-kursk.
      LS_FINAL-DIS_RATE = ABS( LS_CONDITIONS2-KBETR )."ADDED BY MAHADEV SACHIN ON 08/12/2025
      GV_KBETR2 = LS_CONDITIONS-KBETR * LS_CONDITIONS2-KBETR / 100  . "ADDED BY MAHADEV SACHIN ON 08/12/2025
      GV_KBETR = GV_KBETR2 - ( - LS_CONDITIONS-KBETR ). "ADDED BY MAHADEV SACHIN ON 08/12/2025

      GV_KWERT = LS_CONDITIONS2-KWERT.
*      LS_FINAL-DIS_AMT  = abs( LS_CONDITIONS2-KWERT ).
      DIS_AMT3  = ABS( GV_KBETR2 ).
      LS_FINAL-DIS_AMT = DIS_AMT3.
    ELSE.
      DIS_UNIT_RATE2  = LS_CONDITIONS-KBETR.
      LS_FINAL-DIS_UNIT_RATE  = DIS_UNIT_RATE2.
      LS_FINAL-DIS_AMT = '0'.
      LS_FINAL-DIS_RATE = '0'.
      LS_FINAL-DIS = '0'.
    ENDIF.
*     LS_FINAL-DIS_UNIT_RATE  = LS_FINAL-BASE_VAL - ( - LS_CONDITIONS2-KWERT ) .
    IF GV_KBETR IS NOT INITIAL.
      DIS_UNIT_RATE2  = GV_KBETR .
      LS_FINAL-DIS_UNIT_RATE = DIS_UNIT_RATE2.
    ENDIF.

    "Internal Price
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'VPRS'.
*                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-INT_PR = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-int_pr = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ELSE.
      LS_FINAL-INT_PR = '0' .
    ENDIF.

    "Packing Forwarding Charge
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZPFO'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-PF_VAL = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-pf_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ELSE.
      LS_FINAL-PF_VAL = '0'.
    ENDIF.

    "Assessable Value
    ASS_VAL2 = LS_FINAL-VAL_INR + LS_FINAL-PF_VAL + LS_FINAL-DIS.
    LS_FINAL-ASS_VAL = ASS_VAL2.
    CONDENSE LS_FINAL-ASS_VAL.
    "Excise Duty
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZEXP'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-EXE_VAL = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-exe_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
      LS_FINAL-MWSKZ = LS_CONDITIONS-MWSK1.
    ELSE.
      LS_FINAL-EXE_VAL = '0'.
    ENDIF.

    "Education Cess Amount
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZCEP'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-EDU_VAL = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-edu_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ELSE.
      LS_FINAL-EDU_VAL = '0'.
    ENDIF.

    "Higher Education Cess Amount
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZCEH'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-HSE_VAL = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-hse_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ELSE.
      LS_FINAL-HSE_VAL =  '0'.
    ENDIF.

    "VAT
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZCST'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-VAT = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ELSE.
      LS_FINAL-VAT = '0'.
    ENDIF.

    "Testing Charge
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZTE1'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-TES = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-tes = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ENDIF.


    "LST
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZLST'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-VAT = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ENDIF.

    "CGST
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'JOCG'
                                                         KSTAT = SPACE.

**********************change in code by madhavi for (cgst_p,sgst_p,igst_p,tcs_p)
    IF SY-SUBRC IS  INITIAL.
*        ls_final-cgst_p = ls_conditions-kbetr / 10.
      LS_FINAL-CGST_P = LS_CONDITIONS-KBETR .
      LS_FINAL-CGST   = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-cgst   = ls_conditions-kwert * ls_sales_inv_item-kursk.
      LS_FINAL-MWSKZ  = LS_CONDITIONS-MWSK1.
    ELSE.
      LS_FINAL-CGST   = '0'.
    ENDIF.

    "SGST
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'JOSG'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
*        ls_final-sgst_p = ls_conditions-kbetr / 10.
      LS_FINAL-SGST_P = LS_CONDITIONS-KBETR .
*        ls_final-sgst   = ls_conditions-kwert * ls_sales_inv_item-kursk.
      LS_FINAL-SGST   = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
    ELSE.
      LS_FINAL-SGST  =  '0'.
    ENDIF.

    "IGST
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'JOIG'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
*        ls_final-igst_p = ls_conditions-kbetr / 10.
      LS_FINAL-IGST_P = LS_CONDITIONS-KBETR .
      LS_FINAL-IGST   = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-igst   = ls_conditions-kwert * ls_sales_inv_item-kursk.
      LS_FINAL-MWSKZ  = LS_CONDITIONS-MWSK1.
    ELSE.
      LS_FINAL-IGST   = '0'.
    ENDIF.

    READ TABLE LT_T007S INTO LS_T007S WITH KEY MWSKZ = LS_FINAL-MWSKZ.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-TAX_TXT = LS_T007S-TEXT1.
    ENDIF.
    "Freight
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZFR1'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-FRT = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-frt = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ELSE.
      LS_FINAL-FRT = '0'.
    ENDIF.
    "Freight
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZFR2'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-FRT = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-frt = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ENDIF.
    "Freight
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZFRP'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-FRT = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-frt = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ENDIF.

    "Insurance
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZIN1'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-INS = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ELSE.
      LS_FINAL-INS = '0'.
    ENDIF.

    "Insurance
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZIN2'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-INS = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ENDIF.

    "Insurance
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZIPP'
                                                         KSTAT = SPACE.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-INS = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
    ENDIF.

    "TCS
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZTCS'.
*                                                           kstat = space.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-TCS   = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-tcs   = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
      LS_FINAL-TCS_P = LS_CONDITIONS-KBETR .
    ENDIF.

    "Compensation Cess
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZCES'.
*                                                           kstat = space.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-COM_CESS   = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-com_cess   = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
    ENDIF.

    "Compensation Cess
    READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                         KPOSN = LS_SALES_INV_ITEM-POSNR
                                                         KSCHL = 'ZCEV'.
*                                                           kstat = space.
    IF SY-SUBRC IS  INITIAL.
      LS_FINAL-COM_CESS_V  = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-com_cess_v  = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
    ENDIF.

*      IF NOT ls_final-cgst IS INITIAL OR
*        NOT ls_final-igst IS INITIAL.
    ASS_GST2 = ASS_VAL2 + LS_FINAL-FRT + LS_FINAL-INS + LS_FINAL-TES.
    LS_FINAL-ASS_GST = ASS_GST2.
*      ENDIF.


    IF LS_SALES_INV_HDR-FKSTO = 'X'.
      LS_FINAL-STATUS     = 'C'.
      LS_FINAL-BASE_VAL   = 0.
      LS_FINAL-VAL_INR    = 0.
      LS_FINAL-DIS        = 0.
      LS_FINAL-INT_PR     = 0.
      LS_FINAL-PF_VAL     = 0.
      LS_FINAL-ASS_VAL    = 0.
      LS_FINAL-EXE_VAL    = 0.
      LS_FINAL-EDU_VAL    = 0.
      LS_FINAL-HSE_VAL    = 0.
      LS_FINAL-VAT        = 0.
      LS_FINAL-CGST       = 0.
      LS_FINAL-SGST       = 0.
      LS_FINAL-IGST       = 0.
      LS_FINAL-FRT        = 0.
      LS_FINAL-INS        = 0.
      LS_FINAL-TES        = 0.
      LS_FINAL-ASS_GST    = 0.
      LS_FINAL-COM_CESS   = 0.
      LS_FINAL-COM_CESS_V = 0.
      LS_FINAL-TCS_P      = 0.
      LS_FINAL-TCS        = 0.

    ENDIF.

    TOT2 =
           LS_FINAL-ASS_VAL + LS_FINAL-EXE_VAL + LS_FINAL-EDU_VAL + LS_FINAL-HSE_VAL + LS_FINAL-VAT + LS_FINAL-CGST + LS_FINAL-SGST
           + LS_FINAL-IGST + LS_FINAL-FRT + LS_FINAL-INS + LS_FINAL-TES + LS_FINAL-COM_CESS + LS_FINAL-COM_CESS_V + LS_FINAL-TCS.
    LS_FINAL-TOT = TOT2 .


    IF LS_FINAL-FKART = 'ZRE' OR LS_FINAL-FKART = 'ZCR'.
      LS_FINAL-TOT        = LS_FINAL-TOT * -1.
      LS_FINAL-BASE_VAL   = LS_FINAL-BASE_VAL * -1.
      LS_FINAL-VAL_INR    = LS_FINAL-VAL_INR * -1.
      LS_FINAL-ASS_VAL    = LS_FINAL-ASS_VAL * -1.
      LS_FINAL-EXE_VAL    = LS_FINAL-EXE_VAL * -1.
      LS_FINAL-EDU_VAL    = LS_FINAL-EDU_VAL * -1.
      LS_FINAL-HSE_VAL    = LS_FINAL-HSE_VAL * -1.
      LS_FINAL-VAT        = LS_FINAL-VAT * -1.
      LS_FINAL-CGST       = LS_FINAL-CGST * -1.
      LS_FINAL-SGST       = LS_FINAL-CGST * -1.
      LS_FINAL-IGST       = LS_FINAL-IGST * -1.
      LS_FINAL-FRT        = LS_FINAL-FRT * -1.
      LS_FINAL-INS        = LS_FINAL-INS * -1.
      LS_FINAL-TES        = LS_FINAL-TES * -1.
      LS_FINAL-ASS_GST    = LS_FINAL-ASS_GST * -1.
      LS_FINAL-COM_CESS   = LS_FINAL-COM_CESS * -1.
      LS_FINAL-COM_CESS_V = LS_FINAL-COM_CESS_V * -1.
      LS_FINAL-TCS        = LS_FINAL-TCS * -1.

    ENDIF.

    LV_ID = LS_FINAL-VBELN.

    "Transporter Name Text
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z002'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-TRANS LS_LINES-TDLINE INTO LS_FINAL-TRANS SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-TRANS.
    ENDIF.

    "LR No.
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z026'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-LR_NO LS_LINES-TDLINE INTO LS_FINAL-LR_NO SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-LR_NO.
    ENDIF.

    "LR Date.
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z012'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-LR_DT LS_LINES-TDLINE INTO LS_FINAL-LR_DT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-LR_DT.
    ENDIF.

    "Transport Type
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z013'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-TRATY LS_LINES-TDLINE INTO LS_FINAL-TRATY SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-TRATY.
    ENDIF.

    "Freight Type.
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z005'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-FRT_TYP LS_LINES-TDLINE INTO LS_FINAL-FRT_TYP SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-FRT_TYP.
    ENDIF.

    "LD Tag.
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z038'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-LD_TG LS_LINES-TDLINE INTO LS_FINAL-LD_TG SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-LD_TG.
    ELSE.
      LV_ID = LS_FINAL-AUBEL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z038'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_ID
          OBJECT                  = 'VBBK'
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
            CONCATENATE LS_FINAL-LD_TG LS_LINES-TDLINE INTO LS_FINAL-LD_TG SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
        CONDENSE LS_FINAL-LD_TG.
      ENDIF.
    ENDIF.


    LV_ID = LS_FINAL-VBELN.
    "Port Code
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z350'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-PORT_CD LS_LINES-TDLINE INTO LS_FINAL-PORT_CD SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-PORT_CD.
    ENDIF.

    "Shipping Bill Number
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z360'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-SHP_BIL LS_LINES-TDLINE INTO LS_FINAL-SHP_BIL SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-SHP_BIL.
    ENDIF.

    "Shipping Bill Date
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z370'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-SHP_BL_DT LS_LINES-TDLINE INTO LS_FINAL-SHP_BL_DT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-SHP_BL_DT.
    ENDIF.

    "Proof of Delivery
    CLEAR: LT_LINES[],LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z380'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-SHP_BL_DT LS_LINES-TDLINE INTO LS_FINAL-SHP_BL_DT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-SHP_BL_DT.
    ENDIF.

    "Material Long Text
    LV_ID = LS_FINAL-MATNR.
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
          CONCATENATE LS_FINAL-LONG_TXT LS_LINES-TDLINE INTO LS_FINAL-LONG_TXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-LONG_TXT.
    ENDIF.

    CLEAR: LT_LINES,LS_LINES,LV_ID.
    LV_ID = LS_FINAL-AUBEL.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z015'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'VBBK'
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
          CONCATENATE LS_FINAL-OFM_NO LS_LINES-TDLINE INTO LS_FINAL-OFM_NO SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-OFM_NO.
    ENDIF.

    SHIFT LS_FINAL-VBELN LEFT DELETING LEADING '0'.
    SHIFT LS_FINAL-AUBEL LEFT DELETING LEADING '0'.
    SHIFT LS_FINAL-XBLNR LEFT DELETING LEADING '0'.
    SHIFT LS_FINAL-KUNAG LEFT DELETING LEADING '0'.
*BREAK fujiabap.
    LS_FINAL-CURR_DATE  = SY-DATUM.
    IF NOT LS_FINAL-CURR_DATE IS INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-CURR_DATE
        IMPORTING
          OUTPUT = LS_FINAL-CURR_DATE.
      CONCATENATE LS_FINAL-CURR_DATE+0(2) LS_FINAL-CURR_DATE+2(3) LS_FINAL-CURR_DATE+5(4)
                     INTO LS_FINAL-CURR_DATE SEPARATED BY '-'.

*      CONCATENATE LS_FINAL-CURR_DATE+6(2) LS_FINAL-CURR_DATE+4(2) LS_FINAL-CURR_DATE+0(4)
*         INTO LS_FINAL-CURR_DATE SEPARATED BY '-'.
    ENDIF.

    LS_FINAL-REF_DATE = SY-DATUM.
    IF NOT LS_FINAL-REF_DATE IS INITIAL.
      CONCATENATE LS_FINAL-REF_DATE+6(2) LS_FINAL-REF_DATE+4(2) LS_FINAL-REF_DATE+0(4)
         INTO LS_FINAL-REF_DATE SEPARATED BY '-'.
    ENDIF.
*      wa_final-curr_date     = ls_final-curr_date.
    WA_FINAL-WERKS         = LS_FINAL-WERKS.
    WA_FINAL-VBELN         = LS_FINAL-VBELN.
    WA_FINAL-XBLNR         = LS_FINAL-XBLNR.
    WA_FINAL-ZUONR         = LS_FINAL-ZUONR.
    WA_FINAL-STATUS        = LS_FINAL-STATUS.
    WA_FINAL-POSNR         = LS_FINAL-POSNR.
    WA_FINAL-FKART         = LS_FINAL-FKART.
    WA_FINAL-AUART         = LS_FINAL-AUART.
    WA_FINAL-VKBUR         = LS_FINAL-VKBUR.
    WA_FINAL-AUBEL         = LS_FINAL-AUBEL.
    WA_FINAL-AUPOS         = LS_FINAL-AUPOS.
    WA_FINAL-BSTNK         = LS_FINAL-BSTNK.
    WA_FINAL-KUNAG         = LS_FINAL-KUNAG.
    WA_FINAL-NAME1         = LS_FINAL-NAME1.
    WA_FINAL-ADDRESS       = LS_FINAL-ADDRESS.
    WA_FINAL-VTEXT_TAX     = LS_FINAL-VTEXT_TAX.
    WA_FINAL-STCD3         = LS_FINAL-STCD3.
    WA_FINAL-GST_REGION    = LS_FINAL-GST_REGION.
    WA_FINAL-BEZEI         = LS_FINAL-BEZEI.
    WA_FINAL-KUNNR         = LS_FINAL-KUNNR.
    WA_FINAL-NAME1_SH      = LS_FINAL-NAME1_SH.
    WA_FINAL-GST_REGION_SH = LS_FINAL-GST_REGION_SH.
    WA_FINAL-BEZEI_SH      = LS_FINAL-BEZEI_SH.
    WA_FINAL-MATNR         = LS_FINAL-MATNR.
    WA_FINAL-ARKTX         = LS_FINAL-ARKTX.
    WA_FINAL-LONG_TXT      = LS_FINAL-LONG_TXT.
    WA_FINAL-KDMAT         = LS_FINAL-KDMAT.
    WA_FINAL-FKIMG         = LS_FINAL-FKIMG.
    WA_FINAL-VRKME         = LS_FINAL-VRKME.
    WA_FINAL-NETPR         = LS_FINAL-NETPR.
    WA_FINAL-BLART         = LS_FINAL-BLART.
    WA_FINAL-BELNR         = LS_FINAL-BELNR.
    WA_FINAL-MWSKZ         = LS_FINAL-MWSKZ.
    WA_FINAL-TAX_TXT       = LS_FINAL-TAX_TXT.
    WA_FINAL-BASE_VAL      = ABS( LS_FINAL-BASE_VAL ).
    IF LS_FINAL-BASE_VAL < 0.
      CONDENSE WA_FINAL-BASE_VAL.
      CONCATENATE '-' WA_FINAL-BASE_VAL INTO WA_FINAL-BASE_VAL.
    ENDIF.
    WA_FINAL-WAERK         = LS_FINAL-WAERK.
    WA_FINAL-KURSK         = LS_FINAL-KURSK.
    WA_FINAL-VAL_INR       = ABS( LS_FINAL-VAL_INR ).

    IF LS_FINAL-VAL_INR < 0.
      CONDENSE WA_FINAL-VAL_INR.
      CONCATENATE '-' WA_FINAL-VAL_INR INTO WA_FINAL-VAL_INR.
    ENDIF.

    WA_FINAL-PF_VAL        = ABS( LS_FINAL-PF_VAL ).
    IF LS_FINAL-PF_VAL < 0.
      CONDENSE WA_FINAL-PF_VAL.
      CONCATENATE '-' WA_FINAL-PF_VAL INTO WA_FINAL-PF_VAL.
    ENDIF.

    WA_FINAL-DIS    = ABS( LS_FINAL-DIS ).

*    IF LS_FINAL-DIS2 < 0.
*      CONDENSE LS_FINAL-DIS2.
*      CONCATENATE '-' LS_FINAL-DIS2 INTO LS_FINAL-DIS2.
*    ENDIF.
*
*    LS_FINAL-DIS2 = LS_FINAL-DIS2.
*BREAK CTPL.
    WA_FINAL-ASS_VAL  = ABS( ASS_VAL2 ).

*    IF LS_FINAL-ASS_VAL < 0.
*      CONDENSE WA_FINAL-ASS_VAL.
*      CONCATENATE '-' WA_FINAL-ASS_VAL INTO WA_FINAL-ASS_VAL.
*    ENDIF.

    WA_FINAL-EXE_VAL       = ABS( LS_FINAL-EXE_VAL ).
    IF LS_FINAL-EXE_VAL < 0.
      CONDENSE WA_FINAL-EXE_VAL.
      CONCATENATE '-' WA_FINAL-EXE_VAL INTO WA_FINAL-EXE_VAL.
    ENDIF.

    WA_FINAL-EDU_VAL       = LS_FINAL-EDU_VAL.
    IF LS_FINAL-EDU_VAL < 0.
      CONDENSE WA_FINAL-EDU_VAL.
      CONCATENATE '-' WA_FINAL-EDU_VAL INTO WA_FINAL-EDU_VAL.
    ENDIF.

    WA_FINAL-HSE_VAL       = ABS( LS_FINAL-HSE_VAL ).
    IF LS_FINAL-HSE_VAL < 0.
      CONDENSE WA_FINAL-HSE_VAL.
      CONCATENATE '-' WA_FINAL-HSE_VAL INTO WA_FINAL-HSE_VAL.
    ENDIF.

    WA_FINAL-VAT           = ABS( LS_FINAL-VAT ).
    IF LS_FINAL-VAT < 0.
      CONDENSE WA_FINAL-VAT.
      CONCATENATE '-' WA_FINAL-VAT INTO WA_FINAL-VAT.
    ENDIF.

    WA_FINAL-FRT           = ABS( LS_FINAL-FRT ).
    IF LS_FINAL-FRT < 0.
      CONDENSE WA_FINAL-FRT.
      CONCATENATE '-' WA_FINAL-FRT INTO WA_FINAL-FRT.
    ENDIF.

    WA_FINAL-INS           = ABS( LS_FINAL-INS ).
    IF LS_FINAL-INS < 0.
      CONDENSE WA_FINAL-INS.
      CONCATENATE '-' WA_FINAL-INS INTO WA_FINAL-INS.
    ENDIF.

    WA_FINAL-TES           = ABS( LS_FINAL-TES ).
    IF LS_FINAL-TES < 0.
      CONDENSE WA_FINAL-TES.
      CONCATENATE '-' WA_FINAL-TES INTO WA_FINAL-TES.
    ENDIF.

    WA_FINAL-ASS_GST       = ABS( LS_FINAL-ASS_GST ).
    IF LS_FINAL-ASS_GST < 0.
      CONDENSE WA_FINAL-ASS_GST.
      CONCATENATE '-' WA_FINAL-ASS_GST INTO WA_FINAL-ASS_GST.
    ENDIF.

    WA_FINAL-CGST_P        = LS_FINAL-CGST_P.

    WA_FINAL-CGST          = ABS( LS_FINAL-CGST ).
    IF LS_FINAL-CGST < 0.
      CONDENSE WA_FINAL-CGST.
      CONCATENATE '-' WA_FINAL-CGST INTO WA_FINAL-CGST.
    ENDIF.

    WA_FINAL-SGST_P        = LS_FINAL-SGST_P.

    WA_FINAL-SGST          = ABS( LS_FINAL-SGST ).
    IF LS_FINAL-SGST < 0.
      CONDENSE WA_FINAL-SGST.
      CONCATENATE '-' WA_FINAL-SGST INTO WA_FINAL-SGST.
    ENDIF.

    WA_FINAL-IGST_P        = LS_FINAL-IGST_P.

    WA_FINAL-IGST          = ABS( LS_FINAL-IGST ).
    IF LS_FINAL-IGST < 0.
      CONDENSE WA_FINAL-IGST.
      CONCATENATE '-' WA_FINAL-IGST INTO WA_FINAL-IGST.
    ENDIF.

    WA_FINAL-COM_CESS      = ABS( LS_FINAL-COM_CESS ).
    IF LS_FINAL-COM_CESS < 0.
      CONDENSE WA_FINAL-COM_CESS.
      CONCATENATE '-' WA_FINAL-COM_CESS INTO WA_FINAL-COM_CESS.
    ENDIF.

    WA_FINAL-COM_CESS_V    = ABS( LS_FINAL-COM_CESS_V ).
    IF LS_FINAL-COM_CESS_V < 0.
      CONDENSE WA_FINAL-COM_CESS_V.
      CONCATENATE '-' WA_FINAL-COM_CESS_V INTO WA_FINAL-COM_CESS_V.
    ENDIF.

    WA_FINAL-TCS_P         = LS_FINAL-TCS_P.

    WA_FINAL-TCS           = ABS( LS_FINAL-TCS ).
    IF LS_FINAL-TCS < 0.
      CONDENSE WA_FINAL-TCS.
      CONCATENATE '-' WA_FINAL-TCS INTO WA_FINAL-TCS.
    ENDIF.

    WA_FINAL-TOT           = ABS( LS_FINAL-TOT ).
    IF LS_FINAL-TOT < 0.
      CONDENSE WA_FINAL-TOT.
      CONCATENATE '-' WA_FINAL-TOT INTO WA_FINAL-TOT.
    ENDIF.

    WA_FINAL-PRODH         = LS_FINAL-PRODH.
    WA_FINAL-STEUC         = LS_FINAL-STEUC.
    WA_FINAL-VTEXT         = LS_FINAL-VTEXT.
    WA_FINAL-TRANS         = LS_FINAL-TRANS.
    WA_FINAL-LR_NO         = LS_FINAL-LR_NO.
    WA_FINAL-TRATY         = LS_FINAL-TRATY.
    WA_FINAL-FRT_TYP       = LS_FINAL-FRT_TYP.
    WA_FINAL-INT_PR        = LS_FINAL-INT_PR.
    WA_FINAL-STPRS         = LS_FINAL-STPRS.
    WA_FINAL-STPRS1        = LS_FINAL-STPRS1.
    WA_FINAL-ZSERIES       = LS_FINAL-ZSERIES.
    WA_FINAL-ZSIZE         = LS_FINAL-ZSIZE.
    WA_FINAL-BRAND         = LS_FINAL-BRAND.
    WA_FINAL-MOC           = LS_FINAL-MOC.
    WA_FINAL-TYPE          = LS_FINAL-TYPE.
    WA_FINAL-LD_TG         = LS_FINAL-LD_TG.
    WA_FINAL-ZLDPERWEEK    = LS_FINAL-ZLDPERWEEK.
    WA_FINAL-ZLDMAX        = LS_FINAL-ZLDMAX.
    WA_FINAL-HKONT         = LS_FINAL-HKONT.
    WA_FINAL-VTEXT1        = LS_FINAL-VTEXT1.
    WA_FINAL-PORT_CD       = LS_FINAL-PORT_CD.
    WA_FINAL-SHP_BIL       = LS_FINAL-SHP_BIL.
    WA_FINAL-DEL_PROOF     = LS_FINAL-DEL_PROOF.
    WA_FINAL-LR_DT         = LS_FINAL-LR_DT.
    WA_FINAL-OFM_NO        = LS_FINAL-OFM_NO.
    WA_FINAL-LGORT         = LS_FINAL-LGORT."added by jyoti on 11.06.2024

    IF LS_FINAL-DIS_AMT < 0.
*      CONDENSE LS_FINAL-DIS_AMT.
      CONCATENATE '-' DIS_AMT2 INTO DISAMT.
      WA_FINAL-DIS_AMT = DISAMT.
    ENDIF.
    WA_FINAL-DIS_AMT       = LS_FINAL-DIS_AMT.
    IF LS_FINAL-DIS_RATE < 0.
      DISAMT2 =  LS_FINAL-DIS_RATE * ( -1 ).
      CONCATENATE '-' DISAMT2 INTO DATA(DIS_RATE).
      WA_FINAL-DIS_RATE  = DIS_RATE .
    ELSE.
      WA_FINAL-DIS_RATE = LS_FINAL-DIS_RATE.
    ENDIF.
*    WA_FINAL-DIS_RATE      = LS_FINAL-DIS_RATE.
    WA_FINAL-DIS_UNIT_RATE = LS_FINAL-DIS_UNIT_RATE.
*    wa_final-SHP_BL_DT     .


*    wa_final-KURRF_DAT     = ls_final-KURRF_DAT.

*      IF ls_sales_ord_hdr-kurrf_dat IS NOT INITIAL.

*      ENDIF.

* wa_final-ZLDFROMDATE   = ls_final-ZLDFROMDATE.
    IF LS_SALES_ORD_HDR-ZLDFROMDATE IS NOT INITIAL .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SALES_ORD_HDR-ZLDFROMDATE
        IMPORTING
          OUTPUT = WA_FINAL-ZLDFROMDATE.


      CONCATENATE WA_FINAL-ZLDFROMDATE+0(2) WA_FINAL-ZLDFROMDATE+2(3) WA_FINAL-ZLDFROMDATE+5(4)
                INTO WA_FINAL-ZLDFROMDATE SEPARATED BY '-'.

    ENDIF.

*    wa_final-AUDAT         = ls_final-AUDAT.

    IF LS_SALES_ORD_HDR-AUDAT IS NOT INITIAL .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SALES_ORD_HDR-AUDAT
        IMPORTING
          OUTPUT = WA_FINAL-AUDAT.
      CONCATENATE WA_FINAL-AUDAT+0(2) WA_FINAL-AUDAT+2(3) WA_FINAL-AUDAT+5(4)
                     INTO WA_FINAL-AUDAT SEPARATED BY '-'.


    ENDIF.


*    wa_final-FKDAT         = ls_final-FKDAT.

    IF LS_SALES_INV_HDR-FKDAT IS NOT INITIAL .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SALES_INV_HDR-FKDAT
        IMPORTING
          OUTPUT = WA_FINAL-FKDAT.
      CONCATENATE WA_FINAL-FKDAT+0(2) WA_FINAL-FKDAT+2(3) WA_FINAL-FKDAT+5(4)
                     INTO WA_FINAL-FKDAT SEPARATED BY '-'.

    ENDIF.


* wa_final-VDATU         = ls_final-VDATU.

    IF LS_SALES_ORD_HDR-VDATU IS NOT INITIAL .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SALES_ORD_HDR-VDATU
        IMPORTING
          OUTPUT = WA_FINAL-VDATU.
      CONCATENATE WA_FINAL-VDATU+0(2) WA_FINAL-VDATU+2(3) WA_FINAL-VDATU+5(4)
                     INTO WA_FINAL-VDATU SEPARATED BY '-'.

    ENDIF.



*    wa_final-EDATU         = ls_final-EDATU.

    IF LS_SCHEDULE_LINE-EDATU IS NOT INITIAL .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SCHEDULE_LINE-EDATU
        IMPORTING
          OUTPUT = WA_FINAL-EDATU.
      CONCATENATE WA_FINAL-EDATU+0(2) WA_FINAL-EDATU+2(3) WA_FINAL-EDATU+5(4)
                     INTO WA_FINAL-EDATU SEPARATED BY '-'.

    ENDIF.
*BREAK fujiabap.
    IF LS_FINAL-CURR_DATE IS NOT INITIAL .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_FINAL-CURR_DATE.
      CONCATENATE WA_FINAL-CURR_DATE+0(2) WA_FINAL-CURR_DATE+2(3) WA_FINAL-CURR_DATE+5(4)
                     INTO WA_FINAL-CURR_DATE SEPARATED BY '-'.

    ENDIF.
*******************************************************************************************************************

    IF  LS_SALES_INV_ITEM-AUBEL  IS NOT INITIAL.


      DATA:
        NAME      TYPE THEAD-TDNAME,
        BLANK     TYPE TLINE-TDFORMAT,
        DES       TYPE TLINE-TDLINE,
        COUNT     TYPE NUM VALUE '1',
        LT1_LINES TYPE STANDARD TABLE OF TLINE,
        LS1_LINES TYPE TLINE.



      CONCATENATE LS_SALES_INV_ITEM-AUBEL  LS_SALES_INV_ITEM-VGPOS INTO LS_FINAL-SAL_TXT.
      CONCATENATE LS_SALES_INV_ITEM-AUBEL  '000010' INTO LS_FINAL-SAL_TXT.

      NAME = LS_FINAL-SAL_TXT.


      CLEAR: LT1_LINES[],LS1_LINES.
*BREAK primus.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = '0001'
          LANGUAGE                = 'E'
          NAME                    = NAME
          OBJECT                  = 'VBBP'
        TABLES
          LINES                   = LT1_LINES
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


      CLEAR LS_FINAL-SAL_TXT.
      IF LT1_LINES IS NOT INITIAL.


        LOOP AT LT1_LINES INTO LS1_LINES .
*  COUNT = COUNT + 1.
*   BLANK  = LS1_LINES-TDFORMAT.
*   DES  = LS1_lines-tdline.
*
*   IF COUNT = '2'.
*   EXIT.
*
*  ENDIF.
          CONCATENATE LS_FINAL-SAL_TXT LS1_LINES-TDLINE INTO LS_FINAL-SAL_TXT SEPARATED BY SPACE.

        ENDLOOP.

      ENDIF.

    ENDIF.
*clear ls_final-sal_txt.
* LS_FINAL-SAL_TXT = DES.

*gt_final-sal_txt = ls_final-sal_txt.
    WA_FINAL-SAL_TXT = LS_FINAL-SAL_TXT.
*      wa_final-deldate   =  ls_final-deldate .
*      BREAK-POINT.
    "   *------------Added By sarika talekar(18.06.2018)--------------------------

    IF LS_SALES_ORD_ITEM-DELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_SALES_ORD_ITEM-DELDATE
        IMPORTING
          OUTPUT = WA_FINAL-DELDATE.
      IF WA_FINAL-DELDATE IS NOT INITIAL .
        CONCATENATE   WA_FINAL-DELDATE+0(2) WA_FINAL-DELDATE+2(3)  WA_FINAL-DELDATE+5(4)
                       INTO  WA_FINAL-DELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.
*--------------------------------------------------------------------*
*------------Added By Abhishek Pisolkar (26.03.2018)--------------------------
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_FINAL-REF_DATE.
    CONCATENATE WA_FINAL-REF_DATE+0(2) WA_FINAL-REF_DATE+2(3) WA_FINAL-REF_DATE+5(4)
                   INTO WA_FINAL-REF_DATE SEPARATED BY '-'.
*--------------------------------------------------------------------*
********************************************************************************************************************
*
*
*BREAK primus.


    WA_FINAL-LGORT1  = LS_FINAL-LGORT1 .
    APPEND WA_FINAL TO IT_FINAL.

*CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+0(4)
*             INTO ls_final-rep_date SEPARATED BY '-'.

    APPEND LS_FINAL TO CT_FINAL.

    CLEAR:
       LS_FINAL,WA_FINAL, LS_SALES_INV_ITEM,LS_SALES_INV_HDR,LS_SALES_ORD_HDR,LS_TVKTT,LS_CUST_INFO,LS_MAT_MASTER,LS_MARC,LS_SCHEDULE_LINE,
       LS_SALES_BUSS,LT_LINES,LS_LINES,LT1_LINES,LS1_LINES,BLANK,DES,LS_SAL_TXT, LS_SAL_TXT,NAME,COUNT.


  ENDLOOP.

*  ENDIF.

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

* if p_own = 'X'.
**   PERFORM FIELDNAMES.
**  PERFORM DOWNLOAD_LOG.
*  ENDIF.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = L_CALLBACK_PROG
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      IS_LAYOUT               = LS_ALV_LAYOUT
      IT_FIELDCAT             = LT_FIELDCAT
      I_SAVE                  = 'X'
    TABLES
      T_OUTTAB                = CT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
*    BREAK-POINT.
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
  LS_FIELDCAT-FIELDNAME = 'WERKS'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Plant'(100).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VBELN'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Billing No.'(101).
  LS_FIELDCAT-COL_POS   = GV_POS.
  LS_FIELDCAT-HOTSPOT   = 'X'.
  LS_FIELDCAT-NO_ZERO   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'XBLNR'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Invoice No.'(102).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZUONR'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Original Invoice No.'(183).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KURRF_DAT'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Original Invoice Dt.'(184).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STATUS'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Status'(159).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'POSNR'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Item Line'(114).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FKART'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Billing Type'(156).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FKDAT'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Inv. Date'(103).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AUART'.
*  ls_fieldcat-outputlen = '9'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ord. Type'(104).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VKBUR'.
*  ls_fieldcat-outputlen = '9'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Off'(105).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AUBEL'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Doc.No.'(106).
  LS_FIELDCAT-COL_POS   = GV_POS.
  LS_FIELDCAT-HOTSPOT   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AUPOS'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'SO Line Item'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AUDAT'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'SO Date'(107).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VDATU'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Req.Del.Date'(108).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'EDATU'.
*  ls_fieldcat-outputlen = '9'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
*  ls_fieldcat-seltext_m = 'Del.Date'(109). "commented by jyoti requested by yjoshi
  LS_FIELDCAT-SELTEXT_M = 'Production Date'(109)."ADDED BY JYOTI ON 18.03.2025 requested by yjoshi
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BSTNK'.
*  ls_fieldcat-outputlen = '16'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Ref.No.'(110).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KUNAG'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Code'(111).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NAME1'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Name'(112).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ADDRESS'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Address'(190).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VTEXT_TAX'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'REGD/URD/SEZ/DEEMED/GOV'(182).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STCD3'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer GSTIN'(161).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'GST_REGION'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer State Code'(162).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BEZEI'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer State Name'(163).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NAME1_SH'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ship To Name'(164).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'GST_REGION_SH'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ship To Party State Code'(165).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BEZEI_SH'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ship To Party State'(166).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MATNR'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Item Code'(113).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ARKTX'.
*  ls_fieldcat-outputlen = '30'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Text'(115).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LONG_TXT'.
*  ls_fieldcat-outputlen = '50'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Long Text'(158).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KDMAT'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Item Code'(160).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FKIMG'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Inv.Qty.'(117).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VRKME'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'UOM'(167).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NETPR'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Rate'(168).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BLART'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'FI Doc.Type'(185).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BELNR'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'FI Doc.No.'(186).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MWSKZ'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Tax Code'(169).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TAX_TXT'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Tax Code Description'(170).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BASE_VAL'.
*  ls_fieldcat-outputlen = '15'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_L = 'Basic Amt(D.C.)'(118).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-do_sum    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'WAERK'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Curr'(131).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KURSK'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ex.Rate'(132).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VAL_INR'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Basic Val(INR)'(154).
  LS_FIELDCAT-COL_POS   = GV_POS.
  LS_FIELDCAT-DO_SUM    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'PF_VAL'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'P&F Amt'(119).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DIS'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Discount'(157).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ASS_VAL'.
*  ls_fieldcat-outputlen = '9'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ass. Val.'(120).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'EXE_VAL'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Exe Duty Amt.'(121).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'EDU_VAL'.
*  ls_fieldcat-outputlen = '13'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Edu. Cess Amt'(122).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'HSE_VAL'.
*  ls_fieldcat-outputlen = '13'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'H.E. Cess Amt'(123).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VAT'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'VAT/CST'(124).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FRT'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Freight'(128).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'INS'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Insurance'(129).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TES'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Testing Charge'(171).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ASS_GST'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Assessable GST'(172).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CGST_P'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'CGST%'(187).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CGST'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'CGST'(125).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SGST_P'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'SGST%'(188).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SGST'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'SGST'(126).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'IGST_P'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'IGST%'(189).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'IGST'.
*  ls_fieldcat-outputlen = '7'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'IGST'(127).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'COM_CESS'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Com.Cess'(173).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'COM_CESS_V'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Com.Cess Amt.'(174).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TCS_P'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'TCS%'(175).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TCS'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'TCS Amt.'(176).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TOT'.
*  ls_fieldcat-outputlen = '02'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Grand Total'(130).
  LS_FIELDCAT-COL_POS   = GV_POS.
  LS_FIELDCAT-DO_SUM    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'PRODH'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Prod. Category'(133).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STEUC'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'HSN Code'(134).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VTEXT'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Type'(135).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TRANS'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Transporter Name'(136).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LR_NO'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'LR No.'(137).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LR_DT'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'LR Date'(138).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TRATY'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Transport Type'(139).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FRT_TYP'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Freight Type'(140).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'INT_PR'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Internal Price'(141).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STPRS'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Est. Cost'(142).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STPRS1'.
*  ls_fieldcat-outputlen = '9'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Std. Cost'(143).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZSERIES'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Series'(144).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZSIZE'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Size'(145).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BRAND'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Brand'(146).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MOC'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'MOC'(147).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TYPE'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Type'(148).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LD_TG'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'LD Tag'(149).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZLDFROMDATE'.
*  ls_fieldcat-outputlen = '12'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'LD Date'(150).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZLDPERWEEK'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'LD% Min'(155).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ZLDMAX'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'LD% Max'(151).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'HKONT'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Ledger Code'(177).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VTEXT1'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Ledger Head'(152).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'PORT_CD'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Port Code'(178).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SHP_BIL'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Shipping Bill Number'(179).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SHP_BL_DT'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Shipping Bill Date'(180).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DEL_PROOF'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Proof of Delivery'(181).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CURR_DATE'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'File Create Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SAL_TXT'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Item Text'(191).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  """""""""""""ADDED BY SARIKA TALEKAR """""""
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DELDATE'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'ADDL_Data_B_Date'(191).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.
  """"""""""""""""""""""""""
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'OFM_NO'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_L = 'OFM Reference'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

***************added by jyoti on 11.06.2024**************
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LGORT'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_L = 'Storage Location'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

*  ********************************************

***************added by jyoti on 11.06.2024**************   """"""""""""""  NC ++ 05.09.2025
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LGORT1'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_L = 'Billing from'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.                                                       "added by mahadev sachin 09.12.2025
  LS_FIELDCAT-FIELDNAME = 'DIS_RATE'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Dis %'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.                                                       "added by mahadev sachin 09.12.2025
  LS_FIELDCAT-FIELDNAME = 'DIS_AMT'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Discount Amount'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.                                                       "added by mahadev sachin 09.12.2025
  LS_FIELDCAT-FIELDNAME = 'DIS_UNIT_RATE'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Discount Unit Rate'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.
*  ********************************************


*   gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'REP_DATE'.
*  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_m = 'Report Ececuted Date'(191).
*  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UCOMM
*&---------------------------------------------------------------------*
*       Handlung of Commands on ALV
*----------------------------------------------------------------------*
*      -->U_UCOMM        USER COMMAND
*      -->U_SELFIELD     SELECT FIELD
*----------------------------------------------------------------------*
FORM UCOMM_ON_ALV
     USING U_UCOMM    TYPE SY-UCOMM "#EC CALLED       "Form ucomm is called indirectly.
           U_SELFIELD TYPE SLIS_SELFIELD .

  DATA:
    LS_FINAL      TYPE T_FINAL,
    L_INV_DISPLAY TYPE TCODE VALUE 'VF03',
    L_ORD_DISPLAY TYPE TCODE VALUE 'VA03'.


  IF U_UCOMM = '&IC1'.  "Klick on field

    READ TABLE GT_FINAL
         INDEX U_SELFIELD-TABINDEX
          INTO LS_FINAL.
*   Code to Display Selected purchase order in report
    IF U_SELFIELD-FIELDNAME = 'VBELN' .
      IF U_SELFIELD-VALUE IS NOT INITIAL.
        SET PARAMETER ID 'VF'
            FIELD U_SELFIELD-VALUE.
        CALL TRANSACTION  L_INV_DISPLAY AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.
    IF U_SELFIELD-FIELDNAME = 'AUBEL' .
      IF U_SELFIELD-VALUE IS NOT INITIAL.
        SET PARAMETER ID 'AUN'
            FIELD U_SELFIELD-VALUE.
        CALL TRANSACTION  L_ORD_DISPLAY AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.
  ENDIF.
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

*  TYPE-POOLS truxs.
*  DATA: it_csv TYPE truxs_t_text_data,
*        wa_csv TYPE LINE OF truxs_t_text_data,
*        hd_csv TYPE LINE OF truxs_t_text_data.
*
**  DATA: lv_folder(150).
*  DATA: lv_file(30).
*  DATA: lv_fullfile TYPE string,
*        lv_dat(10),
*        lv_tim(4).
*  DATA: lv_msg(80).
****************************************************************************************
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = gt_final
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZSALES.TXT'.
*
*  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*
*******************************************************new file zsales **********************************
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_final
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZSALES'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ELSE.
*     lv_file = 'ZSALE.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*
*  ENDIF.


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
      I_TAB_SAP_DATA       = GT_FINAL
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
  LV_FILE = 'ZSALES_NEW.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSALES Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_3714 TYPE STRING.
    DATA LV_CRLF_3714 TYPE STRING.
    LV_CRLF_3714 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_3714 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_3714 LV_CRLF_3714 WA_CSV INTO LV_STRING_3714.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_3714 TO LV_FULLFILE.
    CLOSE DATASET LV_FULLFILE.            " Abhishek Pisolkar (26.03.2018)
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


******************************************************new file zsales **********************************
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
  .

*BREAK primus.
  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZSALES_NEW.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSALES Download started on', SY-DATUM, 'at', SY-UZEIT.

  """"""""""""""""""''temp download code for testing
**CALL FUNCTION 'GUI_DOWNLOAD'
**  EXPORTING
**    FILENAME                = lv_fullfile
**    FILETYPE                = 'ASC'
**    WRITE_FIELD_SEPARATOR   = 'X'
**  TABLES
**    DATA_TAB                = it_FINAL
***    FIELDNAMES              = hd_csv
**  EXCEPTIONS
**    FILE_WRITE_ERROR        = 1
**    NO_BATCH                = 2
**    GUI_REFUSE_FILETRANSFER = 3
**    INVALID_TYPE            = 4
**    NO_AUTHORITY            = 5
**    UNKNOWN_ERROR           = 6
**    HEADER_NOT_ALLOWED      = 7
**    SEPARATOR_NOT_ALLOWED   = 8
**    FILESIZE_NOT_ALLOWED    = 9
**    HEADER_TOO_LONG         = 10
**    DP_ERROR_CREATE         = 11
**    DP_ERROR_SEND           = 12
**    DP_ERROR_WRITE          = 13
**    UNKNOWN_DP_ERROR        = 14
**    ACCESS_DENIED           = 15
**    DP_OUT_OF_MEMORY        = 16
**    DISK_FULL               = 17
**    DP_TIMEOUT              = 18
**    FILE_NOT_FOUND          = 19
**    DATAPROVIDER_EXCEPTION  = 20
**    CONTROL_FLUSH_ERROR     = 21
**    OTHERS                  = 22.
**
**  IF SY-SUBRC <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  ELSE.
**    MESSAGE 'Please check Status File' TYPE 'S'.
**  ENDIF.
  OPEN DATASET LV_FULLFILE
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_3793 TYPE STRING.
    DATA LV_CRLF_3793 TYPE STRING.
    LV_CRLF_3793 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_3793 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_3793 LV_CRLF_3793 WA_CSV INTO LV_STRING_3793.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_3793 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
*

*  ELSE.
*     lv_file = 'ZSALE.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.

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
  CONCATENATE 'Plant'
              'Billing No.'
              'Invoice No.'
              'Item Line'
              'Billing Type'
              'Inv. Date'
              'Ord. Type'
              'Sales Off'
              'Sales Doc.No.'
              'SO Date'
              'Req.Del.Date'
*              'Del.Date'   "commented by jyoti on 18.03.2025 requested by yjoshi
              'Production Date' "added by jyoti on 18.03.2025 requested by yjoshi
              'Customer Ref.No.'
              'Customer Code'
              'Customer Name'
              'Item Code'
              'Sales Text'
              'Long Text'
              'Inv.Qty.'
              'Basic Amt(D.C.)'
              'Curr'
              'Ex.Rate'
              'Basic Val(INR)'
              'P&F Amt'
              'Discount'
              'Ass. Val.'
              'Exe Duty Amt.'
              'Edu. Cess Amt'
              'H.E. Cess Amt'
              'VAT/CST'
              'Freight'
              'Insurance'
              'CGST'
              'SGST'
              'IGST'
              'Grand Total'
              'Prod. Category'
              'HSN Code'
              'Sales Type'
              'Transporter Name'
              'LR No.'
              'LR Date'
              'Transport Type'
              'Freight Type'
              'Internal Price'
              'Est. Cost'
              'Std. Cost'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'Type'
              'LD Tag'
              'LD Date'
              'LD% Min'
              'LD% Max'
              'Sales Ledger Head'
              'Status'
              'Customer Item Code'
              'GSTIN No'
              'Region'
              'State Code'
              'Ship To Party'
              'Ship To Party Name'
              'Ship To Region'
              'Ship To State Code'
              'Unit'
              'Rate'
              'Taxcode'
              'Tax Code Description'
              'Testing Charge'
              'Assessable GST'
              'Comp Cess%'
              'Comp Cess Amt'
              'TCS%'
              'TCS amt'
              'Sales Ledger'
              'Port Code'
              'Shipping Bill Number'
              'Shipping Bill Dt'
              'Proof of Delivery'
              'Tax Classification'
              'Original Invoice Number'
              'Invoice Date'
              'FI Document No.'
              'FI Document Type'
              'CGST%'
              'SGST%'
              'IGST%'
              'FILE CREATE DATE'
              'Customer Address'
              'Sales Item Text'
              'ADDL_Data_B_Date'  "sarika talekar
              'Refeshable Date'    " By Abhishek Pisolkar (26.03.2018)
              'OFM Reference'
              'SO Line Item'
              'Storage Location'
              'Billing from'
              'Dis %'                        "added by mahadev 17.12.2025
              'Discount Amount'               "added by mahadev 17.12.2025
              'Discount Unit Rate'               "added by mahadev 17.12.2025
  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
**************************************************************************************************************************
*PERFORM FIELDNAMES.
*PERFORM DOWNLOAD_LOG.

*  FORM FIELDNAMES.
*
*  WA_FIELDNAME-FIELD_NAME = 'Plant'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Billing No.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Invoice No.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  WA_FIELDNAME-FIELD_NAME = 'Original Invoice No.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  WA_FIELDNAME-FIELD_NAME = 'Original Invoice Dt.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  WA_FIELDNAME-FIELD_NAME = 'Status'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Item Line'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Billing Type'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Inv. Date.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  WA_FIELDNAME-FIELD_NAME = 'Ord. Type'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  WA_FIELDNAME-FIELD_NAME = 'Sales Off'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  WA_FIELDNAME-FIELD_NAME = 'Sales Doc.No.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*   WA_FIELDNAME-FIELD_NAME = 'SO Date'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Req.Del.Date'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Del.Date'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Customer Ref.No.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Customer Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Customer Name'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'ADDRESS'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'REGD/URD/SEZ/DEEMED/GOV'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Customer GSTIN'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Customer State Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Customer State Name'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Ship To Name'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*
*
*  WA_FIELDNAME-FIELD_NAME = 'Ship To Party State Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Ship To Party State'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Item Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Sales Text'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Long Text'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Customer Item Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Inv.Qty.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'UOM'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Rate'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'FI Doc.Type'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'FI Doc.No.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Tax Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*   WA_FIELDNAME-FIELD_NAME = 'Tax Code Description'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Basic Amt(D.C.)'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Curr.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Ex.Rate'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Basic Val(INR)'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'P&F Amt'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Discount'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
**
**  WA_FIELDNAME-FIELD_NAME = 'Est. Cost'.
**  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Ass. Val.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Exe Duty Amt.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Edu. Cess Am'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'H.E. Cess Amt'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*   WA_FIELDNAME-FIELD_NAME = 'VAT/CST'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Freight'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Insurance'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Testing Charge'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Assessable GST'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'CGST%'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*   WA_FIELDNAME-FIELD_NAME = 'CGST'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'SGST%'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'SGST'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'IGST%'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'IGST'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Com.Cess'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Com.Cess Amt.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'TCS%'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'TCS Amt.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Grand Total'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Prod. Category'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'HSN Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*   WA_FIELDNAME-FIELD_NAME = 'Sales Type'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Transporter Name'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'LR No.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'LR Date'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Transport Type'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Freight Type'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*   WA_FIELDNAME-FIELD_NAME = 'Internal Price'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Est. Cost'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Std. Cost'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Series'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Size'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Brand'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'MOC'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Type'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'LD Tag'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'LD Date'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'LD% Min'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'LD% Max'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*   WA_FIELDNAME-FIELD_NAME = 'Sales Ledger Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Sales Ledger Head'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Port Code'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Shipping Bill Number'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Shipping Bill Date'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  WA_FIELDNAME-FIELD_NAME = 'Proof of Delivery'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
****
*  WA_FIELDNAME-FIELD_NAME = 'File Create Date'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*WA_FIELDNAME-FIELD_NAME = 'PO DOCUMENT NO'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*WA_FIELDNAME-FIELD_NAME = 'REFRESHABLE DATE'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
**WA_FIELDNAME-FIELD_NAME = 'REP_DATE'.
**  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*
*ENDFORM.

*FORM DOWNLOAD_LOG.
*
*  DATA : V_FULLPATH      TYPE STRING.
*
*  CALL FUNCTION 'GUI_FILE_SAVE_DIALOG'
*
*  EXPORTING
*
*    WINDOW_TITLE      = 'STATUS RECORD FILE'
*    DEFAULT_EXTENSION = '.xls'
*
*  IMPORTING
**     filename          = v_efile
*    FULLPATH          = V_FULLPATH.
*
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*  EXPORTING
*    FILENAME                = V_FULLPATH
*    FILETYPE                = 'ASC'
*    WRITE_FIELD_SEPARATOR   = 'X'
*  TABLES
*    DATA_TAB                = it_FINAL
*    FIELDNAMES              = IT_FIELDNAME
*  EXCEPTIONS
*    FILE_WRITE_ERROR        = 1
*    NO_BATCH                = 2
*    GUI_REFUSE_FILETRANSFER = 3
*    INVALID_TYPE            = 4
*    NO_AUTHORITY            = 5
*    UNKNOWN_ERROR           = 6
*    HEADER_NOT_ALLOWED      = 7
*    SEPARATOR_NOT_ALLOWED   = 8
*    FILESIZE_NOT_ALLOWED    = 9
*    HEADER_TOO_LONG         = 10
*    DP_ERROR_CREATE         = 11
*    DP_ERROR_SEND           = 12
*    DP_ERROR_WRITE          = 13
*    UNKNOWN_DP_ERROR        = 14
*    ACCESS_DENIED           = 15
*    DP_OUT_OF_MEMORY        = 16
*    DISK_FULL               = 17
*    DP_TIMEOUT              = 18
*    FILE_NOT_FOUND          = 19
*    DATAPROVIDER_EXCEPTION  = 20
*    CONTROL_FLUSH_ERROR     = 21
*    OTHERS                  = 22.
*
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ELSE.
*    MESSAGE 'Please check Status File' TYPE 'S'.
*  ENDIF.



*ENDFORM.

**&---------------------------------------------------------------------*
**&      Form  CVS_HEADER
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_HD_CSV  text
**----------------------------------------------------------------------*
*FORM cvs_header  USING    pd_csv.
*  DATA: l_field_seperator.
*  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
*  CONCATENATE 'Plant'
*              'Billing No.'
*              'Invoice No.'
*              'Item Line'
*              'Billing Type'
*              'Inv. Date'
*              'Ord. Type'
*              'Sales Off'
*              'Sales Doc.No.'
*              'SO Date'
*              'Req.Del.Date'
*              'Del.Date'
*              'Customer Ref.No.'
*              'Customer Code'
*              'Customer Name'
*              'Item Code'
*              'Sales Text'
*              'Long Text'
*              'Inv.Qty.'
*              'Basic Amt(D.C.)'
*              'Curr'
*              'Ex.Rate'
*              'Basic Val(INR)'
*              'P&F Amt'
*              'Discount'
*              'Ass. Val.'
*              'Exe Duty Amt.'
*              'Edu. Cess Amt'
*              'H.E. Cess Amt'
*              'VAT/CST'
*              'Freight'
*              'Insurance'
*              'CGST'
*              'SGST'
*              'IGST'
*              'Grand Total'
*              'Prod. Category'
*              'HSN Code'
*              'Sales Type'
*              'Transporter Name'
*              'LR No.'
*              'LR Date'
*              'Transport Type'
*              'Freight Type'
*              'Internal Price'
*              'Est. Cost'
*              'Std. Cost'
*              'Series'
*              'Size'
*              'Brand'
*              'MOC'
*              'Type'
*              'LD Tag'
*              'LD Date'
*              'LD% Min'
*              'LD% Max'
*              'Sales Ledger Head'
*              'Status'
*              'Customer Item Code'
*              'GSTIN No'
*              'Region'
*              'State Code'
*              'Ship To Party'
*              'Ship To Party Name'
*              'Ship To Region'
*              'Ship To State Code'
*              'Unit'
*              'Rate'
*              'Taxcode'
*              'Tax Code Description'
*              'Testing Charge'
*              'Assessable GST'
*              'Comp Cess%'
*              'Comp Cess Amt'
*              'TCS%'
*              'TCS amt'
*              'Sales Ledger'
*              'Port Code'
*              'Shipping Bill Number'
*              'Shipping Bill Dt'
*              'Proof of Delivery'
*              'Tax Classification'
*              'Original Invoice Number'
*              'Invoice Date'
*              'FI Document No.'
*              'FI Document Type'
*              'CGST%'
*              'SGST%'
*              'IGST%'
*              'FILE CREATE DATE'
*              'Customer Address'
*              'Sales Item Text'
*  INTO pd_csv
*  SEPARATED BY l_field_seperator.
*
*ENDFORM.
