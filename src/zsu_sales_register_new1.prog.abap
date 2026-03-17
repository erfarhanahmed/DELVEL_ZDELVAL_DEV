*&---------------------------------------------------------------------*
*&Report: ZSU_SALES_REGISTER_NEW1
*&Transaction:  ZSU_SALES1
*&Functional Cosultant: Tejswini Kapadnis
*&Technical Consultant: jYOTI mAHAJAN
*&TR:
*&Date: 05.01.2024
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*& Report               ZSU_SALES_REGISTER_NEW1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_SALES_REGISTER_NEW1.

TYPE-POOLS:SLIS.

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
    BSTDK       TYPE VBAK-BSTDK,
    ZLDFROMDATE TYPE VBAK-ZLDFROMDATE,
    ZLDPERWEEK  TYPE VBAK-ZLDPERWEEK,
    ZLDMAX      TYPE VBAK-ZLDMAX,
  END OF T_SALES_ORD_HDR,
  TT_SALES_ORD_HDR TYPE STANDARD TABLE OF T_SALES_ORD_HDR.

TYPES : BEGIN OF TY_TVAKT,
          SPRAS TYPE TVAKT-SPRAS,
          AUART TYPE TVAKT-AUART,
          BEZEI TYPE TVAKT-BEZEI,
        END OF TY_TVAKT,
        IT_TVAKT TYPE STANDARD TABLE OF TY_TVAKT.

TYPES : BEGIN OF TY_TVKBT,
          SPRAS TYPE TVKBT-SPRAS,
          VKBUR TYPE TVKBT-VKBUR,
          BEZEI TYPE TVKBT-BEZEI,
        END OF TY_TVKBT,
        IT_TVKBT TYPE STANDARD TABLE OF TY_TVKBT.

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
    LAND1 TYPE KNA1-LAND1,
    NAME1 TYPE KNA1-NAME1,
    NAME2 TYPE KNA1-NAME2,
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

TYPES :
  BEGIN OF TY_T005T,
    SPRAS TYPE T005T-SPRAS,
    LAND1 TYPE T005T-LAND1,
    LANDX TYPE T005T-LANDX,
  END OF TY_T005T,
  TT_T005T TYPE STANDARD TABLE OF TY_T005T.

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
    KNUMV   TYPE prcd_elements-KNUMV,
    KPOSN   TYPE prcd_elements-KPOSN,
    KSCHL   TYPE prcd_elements-KSCHL,
    KBETR   TYPE prcd_elements-KBETR,
    MWSK1   TYPE prcd_elements-MWSK1,
    KWERT   TYPE prcd_elements-KWERT,
    KSTAT   TYPE prcd_elements-KSTAT,
    KWERT_K TYPE prcd_elements-KWERT_K,
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
    TXT50 TYPE SKAT-TXT50,
  END OF T_SKAT,
  TT_SKAT TYPE STANDARD TABLE OF T_SKAT.

TYPES : BEGIN OF TY_TVFKT,
          FKART TYPE TVFKT-FKART,
          VTEXT TYPE TVFKT-VTEXT,
          SPRAS TYPE TVFKT-SPRAS,
        END OF TY_TVFKT.

TYPES:
  BEGIN OF T_ADRC,
    ADDRNUMBER TYPE ADRC-ADDRNUMBER,
    NAME1      TYPE ADRC-NAME1,
    NAME2      TYPE ADRC-NAME2,
    CITY2      TYPE ADRC-CITY2,
    POST_CODE1 TYPE ADRC-POST_CODE1,
    STREET     TYPE ADRC-STREET,
    STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
    STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
    STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
    LOCATION   TYPE ADRC-LOCATION,
    COUNTRY    TYPE ADRC-COUNTRY,
    REGION     TYPE ADRC-REGION,
  END OF T_ADRC,
  TT_ADRC TYPE STANDARD TABLE OF T_ADRC.

TYPES :
  BEGIN OF T_SAL_TXT,

    SAL_TXT TYPE STRING,
*         INCLUDE STRUCTURE TLINE,

  END OF T_SAL_TXT,

  TT_SAL_TXT TYPE STANDARD TABLE OF T_SAL_TXT.


TYPES : BEGIN OF LS_FIELDNAME,
          FIELD_NAME(25),
        END OF LS_FIELDNAME.

DATA : IT_FIELDNAME TYPE TABLE OF LS_FIELDNAME.
DATA : WA_FIELDNAME TYPE LS_FIELDNAME.

DATA : IT_TVFKT TYPE TABLE OF TY_TVFKT,
       WA_TVFKT TYPE TY_TVFKT.


*****************************************
TYPES:
  BEGIN OF T_FINAL,
    WERKS         TYPE VBRP-WERKS,      "Plant
    VBELN         TYPE VBRK-VBELN,      "Inv No
    XBLNR         TYPE VBRK-XBLNR,      "ODN Number
    POSNR         TYPE VBRP-POSNR,      "Line Item
    FKART         TYPE VBRK-FKART,      "Billing Type
    VTEXT_NEW     TYPE TVFKT-VTEXT,      "billing order decription
    FKDAT         TYPE CHAR11, "vbrk-fkdat,      "Billing Date
    AUART         TYPE VBAK-AUART,      "Sales Order Type
    VTEXT_NEW1    TYPE TVAKT-BEZEI,   "Sales order type description
    VKBUR         TYPE VBAK-VKBUR,      "Sales Office
    BEZEI1        TYPE TVKBT-BEZEI,
    AUBEL         TYPE VBRP-AUBEL,      "Sales Order No
    AUPOS         TYPE VBRP-AUPOS,
    AUDAT         TYPE CHAR11, "vbak-audat,      "Sales Order Date
    VDATU         TYPE CHAR11, "vbak-vdatu,      "Req Delivery Date
    EDATU         TYPE CHAR11, "vbep-edatu,        "Delivery Date
    BSTNK         TYPE VBAK-BSTNK,      "Customer Ref No.
    BSTDK         TYPE CHAR11,
    KUNAG         TYPE VBRK-KUNAG,      "Customer Code
    NAME1         TYPE ADRC-name1,        "Customer Name
    NAME2         TYPE adrc-NAME2,        "Customer Name
    NAME          TYPE CHAR100,        "Customer Name
    MATNR         TYPE VBRP-MATNR,      "Material Code
    ARKTX         TYPE VBRP-ARKTX,      "Sales Text
    LONG_TXT      TYPE CHAR100,         "Long Text for Material
    FKIMG         TYPE CHAR10, "NUM, "vbrp-fkimg,      "Invoice Qty
    BASE_VAL      TYPE P DECIMALS 2, "CHAR100,        "Base Price
    WAERK         TYPE VBRK-WAERK,      "Currency
    KURSK         TYPE P DECIMALS 2, "VBRP-KURSK,      "Exchange Rate
    NETWR         TYPE VBRP-NETWR,
    VAL_INR       TYPE P DECIMALS 2, "CHAR10, "CHAR100,      "Amount in Local Currency
    PF_VAL        TYPE prcd_elements-kwert,"CHAR10, "char10,        "P&F
    DIS           TYPE prcd_elements-kwert,"CHAR10,        "Discount
    ASS_VAL       TYPE VBRP-NETWR,        "Assessable
    EXE_VAL       TYPE prcd_elements-kwert,"CHAR10,        "Excise Duty
    EDU_VAL       TYPE prcd_elements-kwert,"CHAR10,        "Education Cess Amount
    HSE_VAL       TYPE prcd_elements-kwert,"CHAR10,        "Higher Education Cess Amount
    VAT           TYPE prcd_elements-kwert,"CHAR10,        "VAT/CST
    FRT           TYPE prcd_elements-kwert,"CHAR10,        "Freight
    INS           TYPE prcd_elements-kwert,"CHAR10,        "Insurance
    MWAS          TYPE VBRP-NETWR,"CHAR10,
    ZDC1          TYPE prcd_elements-kwert,"CHAR10,        "
    K005          TYPE prcd_elements-kwert,"CHAR10,        "
    K007          TYPE prcd_elements-kwert,"CHAR10,        "
    OTHER         TYPE prcd_elements-kwert,"CHAR10,        "
    TOT           TYPE VBRP-NETWR," CHAR10,        "Grand Total
    PRODH         TYPE VBRP-PRODH,      "Product Heirarchy
    STEUC         TYPE MARC-STEUC,        "HSN Code
    VTEXT         TYPE TVKTT-VTEXT,       "Sales Type Text
    TRANS         TYPE CHAR30,            "Transporter Name
    LR_NO         TYPE CHAR20,            "L/R No.
    LR_DT         TYPE CHAR10,            "LR Date
    TRATY         TYPE CHAR20,        "Transport Type
    FRT_TYP       TYPE CHAR40,            "Freight Type
    INT_PR        TYPE prcd_elements-kwert,"CHAR100,             "Internal Price
    STPRS         TYPE prcd_elements-kwert,"CHAR100,        "Cost
    STPRS1        TYPE prcd_elements-kwert,"CHAR100,        "Cost
    ZSERIES       TYPE MARA-ZSERIES,      "Series
    ZSIZE         TYPE MARA-ZSIZE,        "Size
    BRAND         TYPE MARA-BRAND,              "Brand
    MOC           TYPE MARA-MOC,                "MOC
    TYPE          TYPE MARA-TYPE,               "Type
    LD_TG         TYPE CHAR20,                  "LD Tag
    ZLDFROMDATE   TYPE CHAR11, "vbak-zldfromdate,  "LD Date
    ZLDPERWEEK    TYPE VBAK-ZLDPERWEEK,
    ZLDMAX        TYPE VBAK-ZLDMAX,             "LD%
    VTEXT1        TYPE SKAT-TXT50,             "Sales Ledger Head
    STATUS        TYPE C,                       "Invoice Status
    KDMAT         TYPE VBAP-KDMAT,              "Customer Item Code
    STCD3         TYPE KNA1-STCD3,              "GSTIN No
    COUNTRY       TYPE ADRC-COUNTRY , "gst_region TYPE zgst_region-gst_region,
    LANDX         TYPE T005T-LANDX,
    REGION        TYPE ADRC-REGION,
    BEZEI         TYPE T005U-BEZEI,             "Region
    GST_REGION    TYPE ZGST_REGION-GST_REGION,  "State Code
    KUNNR         TYPE KNA1-KUNNR,              "Ship To Party
    NAME1_SH      TYPE CHAR100,
    NAME1_SH1     TYPE KNA1-NAME2,
    BEZEI_SH      TYPE T005U-BEZEI,             " Ship To Region
    GST_REGION_SH TYPE ZGST_REGION-GST_REGION,  "Ship To State Code
    VRKME         TYPE VBRP-VRKME,              "Unit
    NETPR         TYPE VBRP-NETWR, "CHAR100,              "Rate
    MWSKZ         TYPE prcd_elements-MWSK1,              "Taxcode
    TAX_TXT       TYPE T007S-TEXT1,             "Tax Code Description
    TES           TYPE prcd_elements-kwert,"CHAR10,              "Testing Charge
    ASS_GST       TYPE prcd_elements-kwert,"CHAR10,              "Assessable GST
    COM_CESS      TYPE prcd_elements-kwert,"CHAR100,              "Comp Cess%
    COM_CESS_V    TYPE prcd_elements-kwert,"CHAR100,              "Comp Cess Amt
    TCS_P         TYPE prcd_elements-kwert,"CHAR10,              "TCS Per
    TCS           TYPE prcd_elements-kwert,"CHAR20,              "TCS amt
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
    CGST_P        TYPE CHAR10,              "CGST %
    SGST_P        TYPE CHAR10,              "SGST %
    IGST_P        TYPE CHAR10,              "IGST %
    CURR_DATE     TYPE CHAR11,
    ADDRESS       TYPE STRING,      "" ** Address
    SAL_TXT       TYPE CHAR250,
    DELDATE       TYPE CHAR11,
    OFM_NO        TYPE STRING,
    INT_PR2       TYPE prcd_elements-KWERT,        " Added by Pranit 17.01.2024
    REF_DATE      TYPE STRING,            " Added By Abhishek Pisolkar (26.03.2018)
    TIME          TYPE STRING,            " Added By Abhishek Pisolkar (26.03.2018

  END OF T_FINAL,
  TT_FINAL TYPE STANDARD TABLE OF T_FINAL.

DATA:
  GT_FINAL TYPE TT_FINAL.

TYPES:
  BEGIN OF TY_FINAL,
    WERKS         TYPE VBRP-WERKS,      "Plant
    VBELN         TYPE VBRK-VBELN,      "Inv No
    XBLNR         TYPE VBRK-XBLNR,      "ODN Number
    STATUS        TYPE C,                       "Invoice Status
    POSNR         TYPE VBRP-POSNR,      "Line Item
    FKART         TYPE VBRK-FKART,      "Billing Type
    VTEXT_NEW     TYPE TVFKT-VTEXT,      "billing order decription
    FKDAT         TYPE CHAR11, "vbrk-fkdat,      "Billing Date
    AUART         TYPE VBAK-AUART,      "Sales Order Type
    VTEXT_NEW1    TYPE TVAKT-BEZEI,   "Sales order type description
    VKBUR         TYPE VBAK-VKBUR,      "Sales Office
    BEZEI1        TYPE TVKBT-BEZEI,
    AUBEL         TYPE VBRP-AUBEL,      "Sales Order No
    AUPOS         TYPE VBRP-AUPOS,
    AUDAT         TYPE CHAR11, "vbak-audat,      "Sales Order Date
    VDATU         TYPE CHAR11, "vbak-vdatu,      "Req Delivery Date
    EDATU         TYPE CHAR11, "vbep-edatu,        "Delivery Date
    BSTNK         TYPE VBAK-BSTNK,      "Customer Ref No.
    BSTDK         TYPE CHAR11,
    KUNAG         TYPE VBRK-KUNAG,      "Customer Code
    NAME          TYPE CHAR100,        "Customer Name
    ADDRESS       TYPE STRING,      "" ** Address
    VTEXT_TAX     TYPE TSKDT-VTEXT,             "Tax Classification
    STCD3         TYPE STRING,
    COUNTRY       TYPE STRING,
    LANDX         TYPE STRING,
    REGION        TYPE STRING, "zgst_region-gst_region,
    BEZEI         TYPE STRING,
    KUNNR         TYPE KNA1-KUNNR,              "Ship To Party
    NAME1_SH      TYPE KNA1-NAME1,              "Ship to name
    GST_REGION_SH TYPE ZGST_REGION-GST_REGION,  "Ship To State Code
    BEZEI_SH      TYPE T005U-BEZEI,             " Ship To Region
*    KUNNR         TYPE KNA1-KUNNR,              "Ship To Party
    MATNR         TYPE VBRP-MATNR,      "Material Code
    ARKTX         TYPE VBRP-ARKTX,      "Sales Text
    LONG_TXT      TYPE CHAR100,         "Long Text for Material
    KDMAT         TYPE VBAP-KDMAT,              "Customer Item Code
    FKIMG         TYPE CHAR15, "vbrp-fkimg,      "Invoice Qty
    VRKME         TYPE VBRP-VRKME,              "Unit
    NETPR         TYPE CHAR250,              "Rate
    BLART         TYPE BKPF-BLART,              "FI Document Type
    BELNR         TYPE BKPF-BELNR,              "FI Document No.
    MWSKZ         TYPE prcd_elements-MWSK1,              "Taxcode
    TAX_TXT       TYPE T007S-TEXT1,             "Tax Code Description
    BASE_VAL      TYPE CHAR100,        "Base Price
    WAERK         TYPE VBRK-WAERK,      "Currency
    KURSK         TYPE VBRP-KURSK,      "Exchange Rate
    VAL_INR       TYPE CHAR100,      "Amount in Local Currency
    PF_VAL        TYPE CHAR100,        "P&F
    DIS           TYPE CHAR100,        "Discount
    FRT           TYPE CHAR100,        "Freight
    INS           TYPE CHAR100,        "Insurance
    TES           TYPE CHAR100,              "Testing Charge
    ZDC1          TYPE CHAR100,        "
    K005          TYPE CHAR100,        "
    K007          TYPE CHAR100,        "
    MWAS          TYPE CHAR100,
    OTHER         TYPE CHAR100,        "
    ASS_VAL       TYPE CHAR100,        "Assessable
    TOT           TYPE CHAR10,        "Grand Total
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
    HKONT         TYPE BSEG-HKONT,              "Sales Ledger
    VTEXT1        TYPE SKAT-TXT50,             "Sales Ledger Head
    PORT_CD       TYPE CHAR50,                  "Port Code
    SHP_BIL       TYPE CHAR20,                  "Shipping Bill Number
    SHP_BL_DT     TYPE CHAR15,                  "Shipping Bill Dt
    DEL_PROOF     TYPE CHAR15,                  "Proof of Delivery
    CURR_DATE     TYPE CHAR11,
    SAL_TXT       TYPE CHAR250,
    DELDATE       TYPE CHAR11,
    OFM_NO        TYPE STRING,
     INT_PR2       TYPE char11,"KONV-KWERT,        " Added by Pranit 17.01.2024
*    ZUONR         TYPE VBRK-ZUONR,              "Original Invoice Number
*    KURRF_DAT     TYPE CHAR11, "vbrk-kurrf_dat,          "Invoice Date
    REF_DATE      TYPE CHAR11,            " Added By Abhishek Pisolkar (26.03.2018)
    TIME          TYPE STRING,

  END OF TY_FINAL.

DATA: IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE XYZ.
SELECT-OPTIONS: SO_VBELN FOR TMP_VBELN,
                SO_FKDAT FOR TMP_FKDAT, "OBLIGATORY DEFAULT '20170401' TO sy-datum,
                SO_ORD   FOR TMP_SO,
                SO_KUNNR FOR TMP_KUNNR.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE ABC .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."saudi'.
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
    LT_TVAKT               TYPE IT_TVAKT,
    LS_TVAKT               TYPE TY_TVKBT,
    LT_TVKBT               TYPE IT_TVKBT,
    LS_TVKBT               TYPE TY_TVAKT,
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
    LT_T005T               TYPE TT_T005T,
    LS_T005U               TYPE T_T005U,
    LS_T005T               TYPE TY_T005T,
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
      FROM VBRP
      INTO TABLE LT_SALES_INV_ITEM
      WHERE VBELN IN SO_VBELN
    AND   AUBEL IN SO_ORD
      AND WERKS = 'SU01'." ADDED BY MD

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
        AND   KUNAG IN SO_KUNNR
        AND  RFBSK = 'C'
        AND FKSTO NE 'X'
        AND FKART NOT IN ( 'SU05', 'SU06', 'SU07' , 'SU08', 'SU13', 'SU14','SS1','SS2' ) .

    ELSE.
      MESSAGE 'Data Not Found' TYPE 'I'.
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
      AND   FKART NOT IN ( 'ZF5','ZF8','F5','F8','ZSN','ZSP','ZS1','SU05', 'SU06', 'SU07' ,'SU08', 'SU13', 'SU14', 'SS1', 'SS2'   )
       AND FKSTO NE 'X'
       AND  RFBSK = 'C'.

  ENDIF.

  IF SO_FKDAT IS NOT INITIAL.
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
          WHERE FKDAT IN SO_FKDAT
            AND FKSTO NE 'X'
        AND  RFBSK = 'C'
      AND   KUNAG IN SO_KUNNR
      AND FKART NOT IN  ('SU05', 'SU06', 'SU07' , 'SU08', 'SU13', 'SU14' ,'SS1', 'SS2' ) .


  ENDIF.

  IF LT_SALES_INV_HDR IS NOT INITIAL.
    SELECT FKART
           VTEXT
           SPRAS
           FROM TVFKT
           INTO TABLE IT_TVFKT
           FOR ALL ENTRIES IN LT_SALES_INV_HDR
           WHERE FKART = LT_SALES_INV_HDR-FKART
           AND SPRAS = 'EN'.
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
       AND BUKRS = 'SU00'
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
       AND  BUKRS = LT_ACCOUNTING_DOC_ITEM-BUKRS
      AND   XBILK = SPACE
       .

      SELECT SAKNR
             TXT50
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
        AND   GJAHR = LT_ACCOUNTING_DOC_ITEM-GJAHR
        AND  BUKRS = LT_ACCOUNTING_DOC_ITEM-BUKRS.

    ENDIF.

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
    FROM VBRP
    INTO TABLE LT_SALES_INV_ITEM
    FOR ALL ENTRIES IN LT_SALES_INV_HDR
    WHERE VBELN = LT_SALES_INV_HDR-VBELN
      AND WERKS = 'SU01'.

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
         KWERT_K
      FROM prcd_elements
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
      AND   KALSM = 'ZTAXSA'.

    IF NOT LT_SALES_INV_ITEM IS INITIAL.

      SELECT VBELN
             AUDAT
             AUART
             VKBUR
             VDATU
             BSTNK
             BSTDK
             ZLDFROMDATE
             ZLDPERWEEK
             ZLDMAX
        FROM VBAK
        INTO TABLE LT_SALES_ORD_HDR
        FOR ALL ENTRIES IN LT_SALES_INV_ITEM
      WHERE VBELN = LT_SALES_INV_ITEM-AUBEL.

      IF LT_SALES_ORD_HDR IS NOT INITIAL.
        SELECT SPRAS
               AUART
               BEZEI
               FROM TVAKT
               INTO TABLE LT_TVAKT
               FOR ALL ENTRIES IN LT_SALES_ORD_HDR
               WHERE AUART = LT_SALES_ORD_HDR-AUART
               AND SPRAS = 'EN'.

        SELECT SPRAS
               VKBUR
               BEZEI
               FROM TVKBT
               INTO TABLE LT_TVKBT
               FOR ALL ENTRIES IN LT_SALES_ORD_HDR
               WHERE VKBUR = LT_SALES_ORD_HDR-VKBUR
               AND SPRAS = 'EN'.
      ENDIF.


      SELECT KUNNR
             LAND1
             NAME1
             NAME2
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
             LAND1
             NAME1
             NAME2
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
               NAME2
               CITY2
               POST_CODE1
               STREET
               STR_SUPPL1
               STR_SUPPL2
               STR_SUPPL3
               LOCATION
               COUNTRY
               REGION
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

        SELECT SPRAS
             LAND1
             LANDX
     FROM T005T
      INTO TABLE LT_T005T
      FOR ALL ENTRIES IN LT_CUST_INFO
      WHERE SPRAS = SY-LANGU
      AND   LAND1 = LT_CUST_INFO-LAND1.

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
      WHERE MATNR = LT_SALES_INV_ITEM-MATNR
        AND BWKEY = 'SU01'.

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

  IF LT_SALES_INV_ITEM IS INITIAL.
    MESSAGE 'Data Not Found' TYPE 'E'.

  ELSE.
    LOOP AT LT_SALES_INV_ITEM INTO LS_SALES_INV_ITEM.

      LS_FINAL-VBELN = LS_SALES_INV_ITEM-VBELN.
      LS_FINAL-POSNR = LS_SALES_INV_ITEM-POSNR.

      LS_FINAL-FKIMG = LS_SALES_INV_ITEM-FKIMG.
*      IF  LS_SALES_INV_ITEM  = 'DG'.
*        LS_FINAL-FKIMG  = LS_FINAL-FKIMG  * -1.
*      ENDIF.
      LS_FINAL-VRKME = LS_SALES_INV_ITEM-VRKME.
      LS_FINAL-AUBEL = LS_SALES_INV_ITEM-AUBEL.
      LS_FINAL-AUPOS = LS_SALES_INV_ITEM-AUPOS.
      LS_FINAL-MATNR = LS_SALES_INV_ITEM-MATNR.
      LS_FINAL-ARKTX = LS_SALES_INV_ITEM-ARKTX.
      LS_FINAL-PRODH = LS_SALES_INV_ITEM-PRODH.
      LS_FINAL-WERKS = LS_SALES_INV_ITEM-WERKS.
      LS_FINAL-VAL_INR = LS_SALES_INV_ITEM-KURSK * LS_FINAL-NETWR.
************************************************************************************************************************

**********************************************************************************************************************

      READ TABLE LT_SALES_ORD_HDR INTO LS_SALES_ORD_HDR WITH KEY VBELN = LS_SALES_INV_ITEM-AUBEL.
      IF SY-SUBRC IS INITIAL.
        IF NOT LS_SALES_ORD_HDR-AUDAT IS INITIAL.
          CONCATENATE LS_SALES_ORD_HDR-AUDAT+6(2) LS_SALES_ORD_HDR-AUDAT+4(2) LS_SALES_ORD_HDR-AUDAT+0(4)
             INTO LS_FINAL-AUDAT SEPARATED BY '-'.
        ENDIF.
        LS_FINAL-AUART       = LS_SALES_ORD_HDR-AUART.
        LS_FINAL-VKBUR       = LS_SALES_ORD_HDR-VKBUR.

*        ls_final-vdatu       = ls_sales_ord_hdr-vdatu.
        IF NOT LS_SALES_ORD_HDR-VDATU IS INITIAL.
          CONCATENATE LS_SALES_ORD_HDR-VDATU+6(2) LS_SALES_ORD_HDR-VDATU+4(2) LS_SALES_ORD_HDR-VDATU+0(4)
             INTO LS_FINAL-VDATU SEPARATED BY '-'.
*        ELSE.
*          ls_final-vdatu = 'NULL'.
        ENDIF.

        LS_FINAL-BSTNK       = LS_SALES_ORD_HDR-BSTNK.
*        LS_FINAL-BSTDK       = LS_SALES_ORD_HDR-BSTDK.

*        IF NOT LS_FINAL-BSTDK IS INITIAL.
        IF NOT LS_SALES_ORD_HDR-BSTDK IS INITIAL.

           CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                INPUT  = LS_SALES_ORD_HDR-BSTDK
              IMPORTING
                OUTPUT = LS_FINAL-BSTDK.


            CONCATENATE LS_FINAL-BSTDK+0(2) LS_FINAL-BSTDK+2(3) LS_FINAL-BSTDK+5(4)
                      INTO LS_FINAL-BSTDK  SEPARATED BY '-'.

          ELSE.
            LS_FINAL-BSTDK  = ' '.
       ENDIF.




        IF NOT LS_SALES_ORD_HDR-ZLDFROMDATE IS INITIAL.
          CONCATENATE LS_SALES_ORD_HDR-ZLDFROMDATE+6(2) LS_SALES_ORD_HDR-ZLDFROMDATE+4(2) LS_SALES_ORD_HDR-ZLDFROMDATE+0(4)
             INTO LS_FINAL-ZLDFROMDATE SEPARATED BY '-'.
*        ELSE.
*          ls_final-zldfromdate = 'NULL'.
        ENDIF.
        LS_FINAL-ZLDPERWEEK  = LS_SALES_ORD_HDR-ZLDPERWEEK.
        LS_FINAL-ZLDMAX      = LS_SALES_ORD_HDR-ZLDMAX.
      ENDIF.


      READ TABLE LT_TVAKT INTO LS_TVAKT WITH KEY AUART = LS_SALES_ORD_HDR-AUART.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-VTEXT_NEW1 = LS_TVAKT-BEZEI.
      ENDIF.

      READ TABLE LT_TVKBT INTO LS_TVKBT WITH KEY VKBUR = LS_SALES_ORD_HDR-VKBUR.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-BEZEI1 = LS_TVKBT-BEZEI.
      ENDIF.


      READ TABLE LT_SALES_INV_HDR INTO LS_SALES_INV_HDR WITH KEY VBELN = LS_SALES_INV_ITEM-VBELN.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-WAERK = LS_SALES_INV_HDR-WAERK.
        LS_FINAL-KURSK = LS_SALES_INV_HDR-KURRF.
*        ls_final-vtweg = ls_sales_inv_hdr-vtweg.
        IF NOT LS_SALES_INV_HDR-FKDAT IS INITIAL.
          CONCATENATE LS_SALES_INV_HDR-FKDAT+6(2) LS_SALES_INV_HDR-FKDAT+4(2) LS_SALES_INV_HDR-FKDAT+0(4)
             INTO LS_FINAL-FKDAT SEPARATED BY '-'.

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

*          IF NOT LS_SALES_INV_HDR-KURRF_DAT IS INITIAL.
*            CONCATENATE LS_SALES_INV_HDR-KURRF_DAT+6(2) LS_SALES_INV_HDR-KURRF_DAT+4(2) LS_SALES_INV_HDR-KURRF_DAT+0(4)
*               INTO LS_FINAL-KURRF_DAT SEPARATED BY '-'.
*
*            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*              EXPORTING
*                INPUT  = LS_SALES_INV_HDR-KURRF_DAT
*              IMPORTING
*                OUTPUT = WA_FINAL-KURRF_DAT.
*
*
*            CONCATENATE WA_FINAL-KURRF_DAT+0(2) WA_FINAL-KURRF_DAT+2(3) WA_FINAL-KURRF_DAT+5(4)
*                      INTO WA_FINAL-KURRF_DAT SEPARATED BY '-'.
*
**          ELSE.
**            ls_final-kurrf_dat = 'NULL'.
*          ENDIF.

        ENDIF.

        READ TABLE IT_TVFKT INTO WA_TVFKT WITH KEY FKART = LS_SALES_INV_HDR-FKART.
        IF SY-SUBRC IS INITIAL.

          LS_FINAL-VTEXT_NEW = WA_TVFKT-VTEXT.
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
            LS_FINAL-VTEXT1 = LS_SKAT-TXT50.
          ENDIF.
        ENDIF.
      ENDIF.
      READ TABLE LT_SALES_ORD_ITEM INTO LS_SALES_ORD_ITEM WITH KEY VBELN = LS_SALES_INV_ITEM-AUBEL
                                                                   POSNR = LS_SALES_INV_ITEM-AUPOS.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-KDMAT = LS_SALES_ORD_ITEM-KDMAT.
*        ls_final-deldate = ls_sales_ord_item-deldate .
        IF LS_SALES_ORD_ITEM-DELDATE IS NOT INITIAL.
          CONCATENATE LS_SALES_ORD_ITEM-DELDATE+6(2) LS_SALES_ORD_ITEM-DELDATE+4(2) LS_SALES_ORD_ITEM-DELDATE+0(4)
             INTO LS_FINAL-DELDATE SEPARATED BY '-'.
        ENDIF.

      ENDIF.
      READ TABLE LT_CUST_INFO INTO LS_CUST_INFO WITH KEY KUNNR = LS_SALES_INV_HDR-KUNAG.


      IF SY-SUBRC IS INITIAL.
        LS_FINAL-NAME1 = LS_CUST_INFO-NAME1.
        LS_FINAL-NAME2 = LS_CUST_INFO-NAME2.
        CONCATENATE LS_FINAL-NAME1 LS_FINAL-NAME2 INTO LS_FINAL-NAME SEPARATED BY SPACE.
        LS_FINAL-STCD3 = LS_CUST_INFO-STCD3.
      ENDIF.



      READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_CUST_INFO-ADRNR.
      IF SY-SUBRC IS INITIAL.

        ls_FINAL-NAME1 = LS_ADRC-NAME1.
        ls_FINAL-NAME2 = LS_ADRC-NAME2.

         CONCATENATE LS_FINAL-NAME1 LS_FINAL-NAME2 INTO LS_FINAL-NAME SEPARATED BY SPACE.
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

        IF NOT LS_ADRC-COUNTRY IS INITIAL.
          LS_FINAL-COUNTRY =  LS_ADRC-COUNTRY.
          LS_FINAL-REGION =  LS_ADRC-REGION.
        ENDIF.
      ENDIF.
      READ TABLE LT_T005T INTO LS_T005T WITH KEY LAND1 = LS_CUST_INFO-LAND1.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-LANDX = LS_T005T-LANDX.
      ENDIF.
      READ TABLE LT_T005U INTO LS_T005U WITH KEY LAND1 = LS_CUST_INFO-LAND1
                                                 BLAND = LS_CUST_INFO-REGIO.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-BEZEI = LS_T005U-BEZEI.
      ENDIF.

      IF LS_CUST_INFO-LAND1 = 'SAR'.
        READ TABLE LT_KNVI INTO LS_KNVI WITH KEY KUNNR = LS_CUST_INFO-KUNNR.
        IF SY-SUBRC IS INITIAL.
          IF LS_CUST_INFO-REGIO = ' '.
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
        LS_FINAL-NAME1_SH1 = LS_CUST_INFO-NAME2.

        CONCATENATE LS_FINAL-NAME1_SH LS_FINAL-NAME1_SH1 INTO LS_FINAL-NAME1_SH SEPARATED BY SPACE.

        LS_FINAL-KUNNR = LS_CUST_INFO-KUNNR.
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
          CONCATENATE LS_SCHEDULE_LINE-EDATU+6(2) LS_SCHEDULE_LINE-EDATU+4(2) LS_SCHEDULE_LINE-EDATU+0(4)
             INTO LS_FINAL-EDATU SEPARATED BY '-'.
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
      ENDIF.
      READ TABLE LT_MARC INTO LS_MARC WITH KEY MATNR = LS_SALES_INV_ITEM-MATNR.
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
                                                           KSCHL = 'ZPR0'.
      IF SY-SUBRC IS  INITIAL.
        LS_FINAL-BASE_VAL = LS_CONDITIONS-KWERT.
*        ls_final-val_inr  = ls_conditions-kwert * ls_sales_inv_item-kursk.
        LS_FINAL-VAL_INR  = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
        LS_FINAL-NETPR    = LS_FINAL-BASE_VAL / LS_FINAL-FKIMG.

      ENDIF.

      "Discount Price
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'ZDIS'
                                                           KSTAT = SPACE.
      IF SY-SUBRC IS  INITIAL.
        LS_FINAL-DIS = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-dis = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.


      "Internal Price
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'VPRS'.
*                                                           KSTAT = SPACE.
      IF SY-SUBRC IS  INITIAL.
        LS_FINAL-INT_PR = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-int_pr = ls_conditions-kwert * ls_sales_inv_item-kursk.
        LS_FINAL-INT_PR2 = LS_CONDITIONS-KWERT_K.                             """Added by Pranit 17.01.2023
      ENDIF.



      "Packing Forwarding Charge
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'ZPFO'
                                                           KSTAT = SPACE.
      IF SY-SUBRC IS  INITIAL.
        LS_FINAL-PF_VAL = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-pf_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
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

      LS_FINAL-MWSKZ = LS_CONDITIONS-MWSK1.

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



      "ZDC1
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'ZDC1'
                                                           KSTAT = SPACE.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-ZDC1 = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      IF LS_FINAL-ZDC1 < 0.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            VALUE = LS_FINAL-ZDC1.
      ENDIF.
      "K005

      DATA: GV_K005 TYPE prcd_elements-KWERT.
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'K005'
                                                           KSTAT = SPACE.
      IF SY-SUBRC IS INITIAL.
*        LS_FINAL-K005 = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
        GV_K005  = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.



*      LS_FINAL-K005 = Gv_k005.
      "K007
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'K007'
                                                           KSTAT = SPACE.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-K007 = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.


      "zoth
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'ZOTH'
                                                           KSTAT = SPACE.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-OTHER = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.



      "MWAS
      READ TABLE LT_CONDITIONS INTO LS_CONDITIONS WITH KEY KNUMV = LS_SALES_INV_HDR-KNUMV
                                                           KPOSN = LS_SALES_INV_ITEM-POSNR
                                                           KSCHL = 'MWAS'
                                                           KSTAT = SPACE.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-MWAS = LS_CONDITIONS-KWERT * LS_SALES_INV_HDR-KURRF.
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


      "Assessable Value
      LS_FINAL-ASS_VAL = LS_FINAL-VAL_INR + LS_FINAL-PF_VAL + LS_FINAL-DIS + LS_FINAL-FRT + LS_FINAL-INS + LS_FINAL-TES
                          + LS_FINAL-ZDC1 + LS_FINAL-K005 + LS_FINAL-K007 + LS_FINAL-OTHER.


*      IF NOT ls_final-cgst IS INITIAL OR
*        NOT ls_final-igst IS INITIAL.
      LS_FINAL-ASS_GST = LS_FINAL-ASS_VAL  .
*      ENDIF.

      IF LS_SALES_INV_HDR-FKSTO = 'X'.
        LS_FINAL-STATUS     = 'C'.
        LS_FINAL-BASE_VAL   = 0.
        LS_FINAL-VAL_INR    = 0.
        LS_FINAL-DIS        = 0.
        LS_FINAL-INT_PR     = 0.
        LS_FINAL-PF_VAL     = 0.
        LS_FINAL-ASS_VAL    = 0.
        LS_FINAL-VAT        = 0.
        LS_FINAL-FRT        = 0.
        LS_FINAL-INS        = 0.
        LS_FINAL-TES        = 0.
        LS_FINAL-ZDC1       = 0.
        LS_FINAL-K005       = 0.
        LS_FINAL-K007       = 0.
        LS_FINAL-OTHER       = 0.
        LS_FINAL-MWAS       = 0.


      ENDIF.
      LS_FINAL-TOT = LS_FINAL-ASS_VAL + LS_FINAL-MWAS .


*      IF ls_final-fkart = 'ZRE' OR ls_final-fkart = 'ZCR'.
      IF LS_FINAL-FKART = 'SU22' OR LS_FINAL-FKART = 'SU15' OR LS_FINAL-FKART = 'SU16' OR LS_FINAL-FKART = 'SU20'."
        if LS_FINAL-TOT < 0.
          LS_FINAL-TOT        = LS_FINAL-TOT.
        else.
        LS_FINAL-TOT        = LS_FINAL-TOT * -1.
        endif.

         if LS_FINAL-BASE_VAL < 0.
           LS_FINAL-BASE_VAL   = LS_FINAL-BASE_VAL.
           else.
        LS_FINAL-BASE_VAL   = LS_FINAL-BASE_VAL * -1.
      endif.
          if LS_FINAL-VAL_INR < 0.
          LS_FINAL-VAL_INR    = LS_FINAL-VAL_INR.
        else.
           LS_FINAL-VAL_INR    = LS_FINAL-VAL_INR * -1.
        endif.
        if LS_FINAL-ASS_VAL < 0.
          LS_FINAL-ASS_VAL    = LS_FINAL-ASS_VAL.
        else.
        LS_FINAL-ASS_VAL    = LS_FINAL-ASS_VAL * -1.
        endif.
          if LS_FINAL-FRT < 0.
            LS_FINAL-FRT        = LS_FINAL-FRT .
          else.
        LS_FINAL-FRT        = LS_FINAL-FRT * -1.
        endif.

         if LS_FINAL-INS < 0.
           LS_FINAL-INS        = LS_FINAL-INS.
         ELSE.
        LS_FINAL-INS        = LS_FINAL-INS * -1.
        ENDIF.

        if LS_FINAL-TES < 0.
          LS_FINAL-TES        = LS_FINAL-TES .
          ELSE.
        LS_FINAL-TES        = LS_FINAL-TES * -1.
        ENDIF.
        if LS_FINAL-ZDC1 < 0.
           LS_FINAL-ZDC1          = LS_FINAL-ZDC1.
        ELSE.
        LS_FINAL-ZDC1          = LS_FINAL-ZDC1 * -1.
        ENDIF.

         if LS_FINAL-K005 < 0.
           LS_FINAL-K005          = LS_FINAL-K005.
         ELSE.
        LS_FINAL-K005          = LS_FINAL-K005 * -1.
        ENDIF.

          if LS_FINAL-K007 < 0.
            LS_FINAL-K007          = LS_FINAL-K007 .
          ELSE.
        LS_FINAL-K007          = LS_FINAL-K007 * -1.
         ENDIF.
          if LS_FINAL-MWAS < 0.
            LS_FINAL-MWAS          = LS_FINAL-MWAS.
          ELSE.
        LS_FINAL-MWAS          = LS_FINAL-MWAS * -1.
        ENDIF.
         if LS_FINAL-OTHER < 0.
           LS_FINAL-OTHER          = LS_FINAL-OTHER.
         ELSE.
        LS_FINAL-OTHER          = LS_FINAL-OTHER * -1.
        ENDIF.
         if LS_FINAL-fkimg < 0.
           LS_FINAL-fkimg          = LS_FINAL-fkimg.
         ELSE.
        LS_FINAL-fkimg          = LS_FINAL-fkimg * -1.
         ENDIF.

      ENDIF.

      LV_ID = LS_FINAL-VBELN.
      IF LV_ID IS NOT INITIAL.
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
      ENDIF.

      IF LV_ID IS NOT INITIAL.
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

      ENDIF.

      IF LV_ID IS NOT INITIAL.
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
      ENDIF.
      IF LV_ID IS NOT INITIAL.
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

      ENDIF.
      IF LV_ID IS NOT INITIAL.
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

      ENDIF.

      IF LV_ID IS NOT INITIAL.
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

        ENDIF.

        IF LV_ID IS NOT INITIAL.
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
      ENDIF.

      LV_ID = LS_FINAL-VBELN.

      IF LV_ID IS NOT INITIAL.
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

      ENDIF.
      IF LV_ID IS NOT INITIAL.
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

      ENDIF.
      IF LV_ID IS NOT INITIAL.
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

      ENDIF.

      IF LV_ID IS NOT INITIAL.
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
      ENDIF.
      "Material Long Text
      LV_ID = LS_FINAL-MATNR.
      IF LV_ID IS NOT INITIAL.

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

      ENDIF.
      LV_ID = LS_FINAL-AUBEL.

      IF LV_ID IS NOT INITIAL.
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
      ENDIF.
      SHIFT LS_FINAL-VBELN LEFT DELETING LEADING '0'.
      SHIFT LS_FINAL-AUBEL LEFT DELETING LEADING '0'.
      SHIFT LS_FINAL-XBLNR LEFT DELETING LEADING '0'.
      SHIFT LS_FINAL-KUNAG LEFT DELETING LEADING '0'.
*BREAK fujiabap.
      LS_FINAL-CURR_DATE  = SY-DATUM.
      IF NOT LS_FINAL-CURR_DATE IS INITIAL.
        CONCATENATE LS_FINAL-CURR_DATE+6(2) LS_FINAL-CURR_DATE+4(2) LS_FINAL-CURR_DATE+0(4)
           INTO LS_FINAL-CURR_DATE SEPARATED BY '-'.
      ENDIF.

      LS_FINAL-REF_DATE = SY-DATUM.
      IF NOT LS_FINAL-REF_DATE IS INITIAL.
        CONCATENATE LS_FINAL-REF_DATE+6(2) LS_FINAL-REF_DATE+4(2) LS_FINAL-REF_DATE+0(4)
           INTO LS_FINAL-REF_DATE SEPARATED BY '-'.
      ENDIF.

      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO LS_FINAL-TIME SEPARATED BY ':'.
*      wa_final-curr_date     = ls_final-curr_date.
      WA_FINAL-WERKS         = LS_FINAL-WERKS.
      WA_FINAL-VBELN         = LS_FINAL-VBELN.
      WA_FINAL-XBLNR         = LS_FINAL-XBLNR.
*      WA_FINAL-ZUONR         = LS_FINAL-ZUONR.
      WA_FINAL-STATUS        = LS_FINAL-STATUS.
      WA_FINAL-POSNR         = LS_FINAL-POSNR.
      WA_FINAL-FKART         = LS_FINAL-FKART.
      WA_FINAL-VTEXT_NEW    = LS_FINAL-VTEXT_NEW.
      WA_FINAL-AUART         = LS_FINAL-AUART.
      WA_FINAL-VTEXT_NEW1    = LS_FINAL-VTEXT_NEW1.
      WA_FINAL-VKBUR         = LS_FINAL-VKBUR.
      WA_FINAL-BEZEI1        = LS_FINAL-BEZEI1.
      WA_FINAL-AUBEL         = LS_FINAL-AUBEL.
      WA_FINAL-AUPOS         = LS_FINAL-AUPOS.
      WA_FINAL-BSTNK         = LS_FINAL-BSTNK.
      WA_FINAL-BSTDK         = LS_FINAL-BSTDK.
      WA_FINAL-KUNAG         = LS_FINAL-KUNAG.
      WA_FINAL-NAME         = LS_FINAL-NAME.
      WA_FINAL-ADDRESS       = LS_FINAL-ADDRESS.
      WA_FINAL-VTEXT_TAX     = LS_FINAL-VTEXT_TAX.
      WA_FINAL-STCD3         = LS_FINAL-STCD3.
      WA_FINAL-COUNTRY     =     LS_FINAL-COUNTRY.
      WA_FINAL-LANDX     =     LS_FINAL-LANDX.
      WA_FINAL-REGION     =     LS_FINAL-REGION.
      WA_FINAL-BEZEI      =     LS_FINAL-BEZEI  .
      WA_FINAL-KUNNR         = LS_FINAL-KUNNR.
      WA_FINAL-NAME1_SH      = LS_FINAL-NAME1_SH.
      WA_FINAL-GST_REGION_SH = LS_FINAL-GST_REGION_SH.
      WA_FINAL-BEZEI_SH      = LS_FINAL-BEZEI_SH.
      WA_FINAL-MATNR         = LS_FINAL-MATNR.
      WA_FINAL-ARKTX         = LS_FINAL-ARKTX.
      WA_FINAL-LONG_TXT      = LS_FINAL-LONG_TXT.
      WA_FINAL-KDMAT         = LS_FINAL-KDMAT.
      WA_FINAL-FKIMG         = ABS( LS_FINAL-FKIMG ).
      WA_FINAL-VRKME         = LS_FINAL-VRKME.
      WA_FINAL-NETPR         = LS_FINAL-NETPR.
      WA_FINAL-BLART         = LS_FINAL-BLART.
      WA_FINAL-BELNR         = LS_FINAL-BELNR.
      WA_FINAL-MWSKZ         = LS_FINAL-MWSKZ.
      WA_FINAL-TAX_TXT       = LS_FINAL-TAX_TXT.
      WA_FINAL-BASE_VAL      = ABS( LS_FINAL-BASE_VAL ).

     IF LS_FINAL-FKART NE 'SU22' OR LS_FINAL-FKART NE 'SU15' OR LS_FINAL-FKART NE 'SU16' OR LS_FINAL-FKART NE 'SU20'."
      IF LS_FINAL-BASE_VAL < 0.
        CONDENSE WA_FINAL-BASE_VAL.
        CONCATENATE '-' WA_FINAL-BASE_VAL INTO WA_FINAL-BASE_VAL.
      ENDIF.
      WA_FINAL-WAERK         = LS_FINAL-WAERK.
      WA_FINAL-KURSK         = LS_FINAL-KURSK.
      WA_FINAL-VAL_INR       = ABS( LS_FINAL-VAL_INR ).

      """""""""""""""""   Added by Pranit 17.01.2024
      IF ls_FINAL-FKIMG < 0.
        CONDENSE WA_FINAL-FKIMG.
        CONCATENATE '-' WA_FINAL-FKIMG INTO WA_FINAL-FKIMG.

      ENDIF.
      """""""""""""""""

      IF LS_FINAL-VAL_INR < 0.
        CONDENSE WA_FINAL-VAL_INR.
        CONCATENATE '-' WA_FINAL-VAL_INR INTO WA_FINAL-VAL_INR.
      ENDIF.

      WA_FINAL-PF_VAL        = ABS( LS_FINAL-PF_VAL ).
      IF LS_FINAL-PF_VAL < 0.
        CONDENSE WA_FINAL-PF_VAL.
        CONCATENATE '-' WA_FINAL-PF_VAL INTO WA_FINAL-PF_VAL.
      ENDIF.

      WA_FINAL-DIS           = ABS( LS_FINAL-DIS ).
      IF LS_FINAL-DIS < 0.
        CONDENSE WA_FINAL-DIS.
        CONCATENATE '-' WA_FINAL-DIS INTO WA_FINAL-DIS.
      ENDIF.

      WA_FINAL-ASS_VAL       = ABS( LS_FINAL-ASS_VAL ).
      IF LS_FINAL-ASS_VAL < 0.
        CONDENSE WA_FINAL-ASS_VAL.
        CONCATENATE '-' WA_FINAL-ASS_VAL INTO WA_FINAL-ASS_VAL.
      ENDIF.

*      wa_final-exe_val       = abs( ls_final-exe_val ).
*      IF ls_final-exe_val < 0.
*        CONDENSE wa_final-exe_val.
*        CONCATENATE '-' wa_final-exe_val INTO wa_final-exe_val.
*      ENDIF.

*      wa_final-edu_val       = ls_final-edu_val.
*      IF ls_final-edu_val < 0.
*        CONDENSE wa_final-edu_val.
*        CONCATENATE '-' wa_final-edu_val INTO wa_final-edu_val.
*      ENDIF.
*
*      wa_final-hse_val       = abs( ls_final-hse_val ).
*      IF ls_final-hse_val < 0.
*        CONDENSE wa_final-hse_val.
*        CONCATENATE '-' wa_final-hse_val INTO wa_final-hse_val.
*      ENDIF.

*      wa_final-vat           = abs( ls_final-vat ).
*      IF ls_final-vat < 0.
*        CONDENSE wa_final-vat.
*        CONCATENATE '-' wa_final-vat INTO wa_final-vat.
*      ENDIF.

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

      WA_FINAL-ZDC1           = ABS( LS_FINAL-ZDC1 ).
      IF LS_FINAL-ZDC1 < 0.
        CONDENSE WA_FINAL-ZDC1.
        CONCATENATE '-' WA_FINAL-ZDC1 INTO WA_FINAL-ZDC1.
      ENDIF.

      WA_FINAL-K005           = ABS( LS_FINAL-K005 ).
      IF LS_FINAL-K005 < 0.
        CONDENSE WA_FINAL-K005.
        CONCATENATE '-' WA_FINAL-K005 INTO WA_FINAL-K005.
      ENDIF.
      WA_FINAL-K007           = ABS( LS_FINAL-K007 ).
      IF LS_FINAL-K007 < 0.
        CONDENSE WA_FINAL-K007.
        CONCATENATE '-' WA_FINAL-K005 INTO WA_FINAL-K007.
      ENDIF.

      WA_FINAL-MWAS           = ABS( LS_FINAL-MWAS ).
      IF LS_FINAL-MWAS < 0.
        CONDENSE WA_FINAL-MWAS.
        CONCATENATE '-' WA_FINAL-MWAS INTO WA_FINAL-MWAS.
      ENDIF.

      WA_FINAL-OTHER           = ABS( LS_FINAL-OTHER ).  "ADDED BY PRIMUS JYOTI ON 02.01.2024
      IF LS_FINAL-OTHER < 0.
        CONDENSE WA_FINAL-OTHER.
        CONCATENATE '-' WA_FINAL-OTHER INTO WA_FINAL-OTHER.
      ENDIF.


*      WA_FINAL-COM_CESS      = ABS( LS_FINAL-COM_CESS ).
*      IF LS_FINAL-COM_CESS < 0.
*        CONDENSE WA_FINAL-COM_CESS.
*        CONCATENATE '-' WA_FINAL-COM_CESS INTO WA_FINAL-COM_CESS.
*      ENDIF.
*
*      WA_FINAL-COM_CESS_V    = ABS( LS_FINAL-COM_CESS_V ).
*      IF LS_FINAL-COM_CESS_V < 0.
*        CONDENSE WA_FINAL-COM_CESS_V.
*        CONCATENATE '-' WA_FINAL-COM_CESS_V INTO WA_FINAL-COM_CESS_V.
*      ENDIF.
*
*      WA_FINAL-TCS_P         = LS_FINAL-TCS_P.
*
*      WA_FINAL-TCS           = ABS( LS_FINAL-TCS ).
*      IF LS_FINAL-TCS < 0.
*        CONDENSE WA_FINAL-TCS.
*        CONCATENATE '-' WA_FINAL-TCS INTO WA_FINAL-TCS.
*      ENDIF.

      WA_FINAL-TOT           = ABS( LS_FINAL-TOT ).
      IF LS_FINAL-TOT < 0.
        CONDENSE WA_FINAL-TOT.
        CONCATENATE '-' WA_FINAL-TOT INTO WA_FINAL-TOT.
*        CONDENSE LS_FINAL-FKIMG.
*        CONCATENATE '-' LS_FINAL-FKIMG INTO LS_FINAL-FKIMG.     "ADDED BY Shubhangi Sarode on dt 18.01.2024 inv qty negative if total is negative
*        SPLIT LS_FINAL-FKIMG AT '.' INTO DATA(LV_V1) DATA(LV_V2).
*        LS_FINAL-FKIMG = LV_V1.
      ENDIF.

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
*      WA_FINAL-ZDC1          = LS_FINAL-ZDC1.
*      WA_FINAL-K005          = LS_FINAL-K005.
*      WA_FINAL-K007          = LS_FINAL-K007.
*      WA_FINAL-K007          = LS_FINAL-K007.
*      WA_FINAL-MWAS          = LS_FINAL-MWAS.
*      WA_FINAL-OTHER          = LS_FINAL-OTHER.

      IF LS_SALES_ORD_HDR-ZLDFROMDATE IS NOT INITIAL .

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SALES_ORD_HDR-ZLDFROMDATE
          IMPORTING
            OUTPUT = WA_FINAL-ZLDFROMDATE.

        CONCATENATE WA_FINAL-ZLDFROMDATE+0(2) WA_FINAL-ZLDFROMDATE+2(3) WA_FINAL-ZLDFROMDATE+5(4)
                  INTO WA_FINAL-ZLDFROMDATE SEPARATED BY '-'.
      ENDIF.

      IF LS_SALES_ORD_HDR-AUDAT IS NOT INITIAL .

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SALES_ORD_HDR-AUDAT
          IMPORTING
            OUTPUT = WA_FINAL-AUDAT.
        CONCATENATE WA_FINAL-AUDAT+0(2) WA_FINAL-AUDAT+2(3) WA_FINAL-AUDAT+5(4)
                       INTO WA_FINAL-AUDAT SEPARATED BY '-'.


      ENDIF.
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


      IF LS_SCHEDULE_LINE-EDATU IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_SCHEDULE_LINE-EDATU
          IMPORTING
            OUTPUT = WA_FINAL-EDATU.
        CONCATENATE WA_FINAL-EDATU+0(2) WA_FINAL-EDATU+2(3) WA_FINAL-EDATU+5(4)
                       INTO WA_FINAL-EDATU SEPARATED BY '-'.

      ENDIF.

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

            CONCATENATE LS_FINAL-SAL_TXT LS1_LINES-TDLINE INTO LS_FINAL-SAL_TXT SEPARATED BY SPACE.

          ENDLOOP.

        ENDIF.

      ENDIF.

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

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_FINAL-REF_DATE.
      CONCATENATE WA_FINAL-REF_DATE+0(2) WA_FINAL-REF_DATE+2(3) WA_FINAL-REF_DATE+5(4)
                     INTO WA_FINAL-REF_DATE SEPARATED BY '-'.

      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO WA_FINAL-TIME SEPARATED BY ':'.

      WA_FINAL-SAL_TXT = LS_FINAL-SAL_TXT.
      WA_FINAL-INT_PR2 = LS_FINAL-INT_PR2.
      replace ',' with space into WA_FINAL-INT_PR2.
      condense WA_FINAL-INT_PR2 no-gaps.

      APPEND WA_FINAL TO IT_FINAL.

      APPEND LS_FINAL TO CT_FINAL.

      CLEAR:
         LS_FINAL,WA_FINAL, LS_SALES_INV_ITEM,LS_SALES_INV_HDR,LS_SALES_ORD_HDR,LS_TVKTT,LS_CUST_INFO,LS_MAT_MASTER,LS_MARC,LS_SCHEDULE_LINE,
         LS_SALES_BUSS,LT_LINES,LS_LINES,LT1_LINES,LS1_LINES,BLANK,DES,LS_SAL_TXT, LS_SAL_TXT,NAME,COUNT.


    ENDLOOP.

  ENDIF.

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
  LS_FIELDCAT-SELTEXT_M = 'Invoice No.'(101).
  LS_FIELDCAT-COL_POS   = GV_POS.
  LS_FIELDCAT-HOTSPOT   = 'X'.
  LS_FIELDCAT-NO_ZERO   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'XBLNR'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Reference No.'(102).
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
  LS_FIELDCAT-FIELDNAME = 'VTEXT_NEW'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Billing Order Decription'(320).
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
  LS_FIELDCAT-SELTEXT_M = 'Sales Order Type'(104).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VTEXT_NEW1'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Order Decription'(301).
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
  LS_FIELDCAT-FIELDNAME = 'BEZEI1'.
*  ls_fieldcat-outputlen = '9'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Office Description'(303).
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
  LS_FIELDCAT-SELTEXT_M = 'Del.Date'(109).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BSTNK'.
*  ls_fieldcat-outputlen = '16'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Po/Ref.No.'(110).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BSTDK'.
*  ls_fieldcat-outputlen = '16'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Po/Ref. Date.'(302).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KUNAG'.
*  ls_fieldcat-outputlen = 50.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Code'(111).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NAME'.
  LS_FIELDCAT-DDIC_OUTPUTLEN = 100.
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
  LS_FIELDCAT-SELTEXT_M = 'REGD/URD/GCC/DEEMED'(182).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STCD3'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer VAT Number'(161).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'COUNTRY'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Country'(309).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LANDX'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Country Descr.'(308).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'REGION'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Region'(306).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BEZEI'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Region Description'(310).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KUNNR'.
*  ls_fieldcat-outputlen = '14'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ship To Party Code'(311).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NAME1_SH'.
  LS_FIELDCAT-OUTPUTLEN = 60.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Ship To Name'(164).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'REGION'.
  LS_FIELDCAT-DDIC_OUTPUTLEN = '48'.
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
  LS_FIELDCAT-SELTEXT_M = 'Unit'(167).
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
  LS_FIELDCAT-SELTEXT_M = 'Basic Val(SAR)'(154).
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
  LS_FIELDCAT-FIELDNAME = 'FRT'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Freight charges'(128).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'INS'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Insurance Charges'(129).
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
  LS_FIELDCAT-FIELDNAME = 'ZDC1'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Document Charges'(123).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'K005'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Material'(124).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'K007'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Disco'(125).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MWAS'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Output Tax'(126).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'OTHER'.
*  ls_fieldcat-outputlen = '8'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Other Addition Charges'(127).
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
  LS_FIELDCAT-SELTEXT_M = 'HS Code'(134).
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


  GV_POS = GV_POS + 1.                          """Added by Pranit 17.01.2024
  LS_FIELDCAT-FIELDNAME = 'INT_PR2'.
*  ls_fieldcat-outputlen = '25'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_L = 'Tot Mat Cost'(200).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

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
  LV_FILE = 'ZSU_SALES_NEW.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_SALES Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_3700 TYPE string.
DATA lv_crlf_3700 TYPE string.
lv_crlf_3700 = cl_abap_char_utilities=>cr_lf.
lv_string_3700 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_3700 lv_crlf_3700 wa_csv INTO lv_string_3700.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_3700 TO lv_fullfile.
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
  LV_FILE = 'ZSU_SALES_NEW.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_SALES Download started on', SY-DATUM, 'at', SY-UZEIT.

  OPEN DATASET LV_FULLFILE
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_3740 TYPE string.
DATA lv_crlf_3740 TYPE string.
lv_crlf_3740 = cl_abap_char_utilities=>cr_lf.
lv_string_3740 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_3740 lv_crlf_3740 wa_csv INTO lv_string_3740.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_3740 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
*


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
              'Invoice No.'
              'Reference No.'
              'Status'
              'Item Line'
              'Billing Type'
              'Billing Type Description'
              'Inv. Date'
              'Sales Order Type'
              'Sales Order Type Description'
              'Sales Off'
              'Sales Off Description'
              'Sales Doc.No.'
              'SO Line Item'
              'SO Date'
              'Req.Del.Date'
              'Del.Date'
              'Customer PO Ref.No.'
              'Customer PO Ref. Date'
              'Customer Code'
              'Customer Name'
              'Customer Address'
              'REGD/URD/GCC/DEEMED'
              'Customer VAT Code'
              'Country'
              'Country Descr.'
              'Region'
              'Region Description'
              'Ship To Party Code'
              'Ship To Party Name'
              'Ship To Region'
              'Ship To State Code'
              'Item Code'
              'Sales Text'
              'Long Text'
              'Customer Item Code'
              'Inv.Qty.'
              'Unit'
              'Rate'
              'FI Document Type'
              'FI Document No.'
              'Taxcode'
              'Tax Code Description'
              'Basic Amt(D.C.)'
              'Curr'
              'Ex.Rate'
              'Basic Val(SAR)'
              'P&F Amt'
              'Discount'
              'Freight Charges'
              'Insurance Charges'
              'Testing Charges'
              'Document Charges'
              'Customer material'
              'Customer Discount'
              'Output Tax'
              'Other Additional Charges'
              'Ass. Val.'
              'Grand Total'
              'Prod. Category'
              'HS Code'
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
              'Sales Ledger'
              'Sales Ledger Head'
              'Port Code'
              'Shipping Bill Number'
              'Shipping Date'
              'Proof of Delivery'
              'FILE CREATE DATE'
              'Sales Item Text'
              'ADDL_Data_B_Date'
              'OFM Reference'
              'Tot Mat Cost'               " Added by Pranit 17.01.2024
              'Refreshable Date'    " By Abhishek Pisolkar (26.03.2018)
              'Refreshable Time'

 INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
