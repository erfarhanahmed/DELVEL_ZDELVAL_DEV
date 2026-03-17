TABLES : VBRK,VBRP,KONV,VBAK,VBAP,J_1IMOCUST, TVKTT.

TYPES : BEGIN OF STR_DATA,
         ledger        TYPE i , "vbrk-ktgrd,              "LEDGER
         VBELN         LIKE VBRK-VBELN,
          KTGRD         TYPE TVKTT-VTEXT,              "LEDGER
          VTWEG(20)     TYPE C,
          KUNRG         LIKE VBRK-KUNRG,
          NAME1         TYPE NAME1_GP,
          SPART         TYPE VTXTK,
          FKDAT         LIKE VBRK-ERDAT,
          POSNR         LIKE VBRP-POSNR,
          FKIMG         LIKE VBRP-FKIMG,
          MATNR         LIKE VBRP-MATNR,
          MAKTX         LIKE MAKT-MAKTX,
          VKBUR         TYPE BEZEI20,
          NETPRICE      TYPE KWERT,              " NET PRICE
          ASSEBLE       TYPE KWERT,               " ASSESSBLE VALUE
          DCOUNT        TYPE KWERT,                " DISCOUNT
          EXCISE        TYPE KWERT,                " EXCISE DUTY
          ECESS         TYPE KWERT,               " E.CESS
          STAX          TYPE KWERT,                " SERVICE TAX
          ECESER        TYPE KWERT,                " ECESS SERVICE
          CSALTAX       TYPE KWERT,               " CENTRAL SALES TAX
          KBETR1        TYPE KWERT,               " CST RATE
          VAT           TYPE KWERT,                   " VAT
          KBETR         TYPE KBETR,                 " RATE
          FRT           TYPE KWERT,                " FREIGHT
      N_TAX_FRT         TYPE KWERT,                " FREIGHT NON TAXABLE
          PFCRG         TYPE KWERT,                " PACKING/FORWARDING
          INSU          TYPE KWERT,                " INSURACE
          OTHER         TYPE KWERT,                 " OTHER CHARGES
          ITAX          TYPE KWERT,                 " INCOM TAX
          EANDC         TYPE KWERT,                 " E & C CHARGES
          LOCAL         TYPE KWERT,                 " LOCAL CONVANCE
          TOANDFRO      TYPE KWERT,              " TO & FROFARE
          TCS           TYPE KWERT,              " TO & FROFARE
          GR_AMT        TYPE NETWR,                " GROSS AMT
          AUBEL         LIKE VBRP-AUBEL,            " SALES ORDER NO
          AUPOS         LIKE VBRP-AUPOS,            " SALES ORDER ITEM NO
          CHAPID        LIKE J_1IMTCHID-J_1ICHID,  " CHAPTER ID
          BOLNR         LIKE LIKP-BOLNR,            " NAME OF THE COURIER
          TRAID         LIKE LIKP-TRAID,            " COURIER NO
          REPR          TYPE KWERT,                  " REPAIRING CHARGES
          SHCESS        TYPE KWERT,                " SH CESS
          KBETR2        TYPE KWERT,               " SH CESS RATE
          SHCESS1       TYPE KWERT,               "S&H CESS ON SERVICE TAX
          ECESS1        TYPE KWERT,                "E CESS ON SERVICE TAX
          BSTKD         TYPE VBKD-BSTKD,          "PO NO
          BEDRATE       TYPE KBETR,
          ECESSRATE     TYPE KBETR,
          ECESSRATESER  TYPE KBETR,
          SECESSRATESER TYPE KBETR,
          STAXRATE      TYPE KBETR,
          TST_CHR       TYPE konv-KWERT,
          EXNUM         TYPE J_1IEXCHDR-EXNUM,
          EXDAT         TYPE J_1IEXCHDR-EXDAT,
          ASSCSTVAT     TYPE KWERT,
          CSTNO         LIKE J_1IMOCUST-J_1ICSTNO,
          LSTNO         LIKE J_1IMOCUST-J_1ILSTNO,
          ADRNR         TYPE KNA1-ADRNR,              "ADDRESS NUMBER
          ADDRESS       TYPE CHAR100,                       "COMPLETE ADDRESS FROM ADRC
          TAX(20)       TYPE C,
          TAX_AMT       TYPE KWERT,
          GROSS_AMT     TYPE KWERT,
*********************************************************************************
          BELNR         TYPE BKPF-BELNR,
          END OF STR_DATA,

*&-- STRUCTURE FOR SALES DATA---------------------------*
       BEGIN OF STR_SALE,
           VBELN LIKE VBRK-VBELN,    "Billing Document
           VBTYP LIKE VBRK-VBTYP,   "SD document category
           WAERK LIKE VBRK-WAERK,    "SD Document Currency
*           VKORG LIKE VBRK-VKORG,    "Sales Organization
           KNUMV LIKE VBRK-KNUMV,    "Number of the document condition
           FKDAT LIKE VBRK-ERDAT,    "Billing date
           KURRF LIKE VBRK-KURRF,    "Exchange rate for FI postings
           KTGRD  TYPE VBRK-KTGRD,   "Account assignment group for this customer
           NETWR LIKE VBRK-NETWR,    "Net Value in Document Currency
           KUNRG LIKE VBRK-KUNRG,    "Payer
           KUNAG LIKE VBRK-KUNAG,    "Sold-to party
           VTWEG LIKE VBRK-VTWEG,    "Distribution Channel  ?
           SPART LIKE VBRK-SPART,    "Division ?
           MWSBK LIKE VBRK-MWSBK,    "Tax amount in document currency
           POSNR LIKE VBRP-POSNR,    "Billing item
           FKIMG LIKE VBRP-FKIMG,    "Actual Invoiced Quantity
           VGBEL LIKE VBRP-VGBEL,    "Document number of the reference document
           AUBEL LIKE VBRP-AUBEL,    "Sales Document
           AUPOS LIKE VBRP-AUPOS,    "Sales Document Item
           MATNR LIKE VBRP-MATNR,    "Material Number
           VKGRP LIKE VBRP-VKGRP,    "Sales Group
           VKBUR LIKE VBRP-VKBUR,    "Sales Office
           SHCESS TYPE KWERT,     " SH CESS
           KBETR2 TYPE KWERT,    " SH CESS RATE
           SHCESS1 TYPE KWERT,    "S&H CESS ON SERVICE TAX
           BSTKD  TYPE VBKD-BSTKD, "PO NO
           ADRNR  TYPE KNA1-ADRNR,
           TAX(20)   TYPE C,
           TAX_AMT   TYPE KWERT,
           GROSS_AMT TYPE KWERT,
        END OF STR_SALE,
*&-- STRUCTURE FOR MATERIAL DESCRIPTION---------------------------*
        BEGIN OF STR_MAKT,
          MATNR  TYPE MATNR,
          MAKTX  TYPE MAKTX,
        END OF STR_MAKT,
*&-- STRUCTURE FOR CUSTOMER NAME---------------------------*
        BEGIN OF STR_KNA1,
          KUNNR TYPE KUNNR,
          LAND1 TYPE LAND1_GP,
          NAME1 TYPE NAME1_GP,
          ORT01 TYPE ORT01_GP,
          PSTLZ TYPE PSTLZ,
          REGIO TYPE REGIO,
          STRAS TYPE STRAS_GP,
          ADRNR TYPE ADRNR,
        END OF STR_KNA1,
*&-- STRUCTURE FOR TAX TYPE---------------------------*
        BEGIN OF STR_T685T,
          SPRAS TYPE SPRAS,
          KSCHL TYPE KSCHL,
          VTEXT TYPE VTEXT,
        END OF STR_T685T,

*&-- STRUCTURE FOR TAX TYPE---------------------------*
        BEGIN OF STR_TVKTT,
          SPRAS TYPE SPRAS,
          KTGRD TYPE VBRK-KTGRD,
          VTEXT(20) TYPE C,
        END OF STR_TVKTT,
*&-- STRUCTURE FOR TAX TYPE---------------------------*
         BEGIN OF STR_ADRC,
            ADDRNUMBER      TYPE ADRC-ADDRNUMBER,
            NAME1           TYPE ADRC-NAME1,
            CITY1           TYPE ADRC-CITY1,
            POST_CODE1      TYPE ADRC-POST_CODE1,
            STREET          TYPE ADRC-STREET,
            STR_SUPPL1      TYPE ADRC-STR_SUPPL1,
            STR_SUPPL2      TYPE ADRC-STR_SUPPL2,
        END OF  STR_ADRC.



*&---------------------------------------------------------------------*
*& TYPE POOLS - USED FOR ALL ALV RELATED OBJECT DECLARATION
*&---------------------------------------------------------------------*
TYPE-POOLS : SLIS.

*&---------------------------------------------------------------------*
*& DATA  - USED TO DEFINE INTERNAL TABLES AND VARIABLES
*&---------------------------------------------------------------------*
DATA : IT_DATA TYPE STR_DATA OCCURS 0,
       IT_DATA1 TYPE STANDARD TABLE OF STR_DATA,
       IT_DATA1_new TYPE STANDARD TABLE OF STR_DATA,
       WA_DATA TYPE STR_DATA,
       WA_DATA1 TYPE STR_DATA,
       WA_DATA1_new TYPE STR_DATA,
       TIN_NO TYPE konv-KSCHL,
       ADDRESS TYPE CHAR100,

       IT_SALE TYPE STR_SALE OCCURS 0,
       WA_SALE TYPE STR_SALE,
       IT_MOCUST LIKE TABLE OF J_1IMOCUST WITH HEADER LINE,
       IT_MAKT TYPE STR_MAKT OCCURS 0 WITH HEADER LINE,
       IT_KNA1 TYPE STR_KNA1 OCCURS 0 WITH HEADER LINE,
       WA_KNA1 TYPE STR_KNA1,
       IT_EXCHDR LIKE  TABLE OF J_1IEXCHDR  WITH HEADER LINE,
       IT_TSPAT TYPE TSPAT OCCURS 0 WITH HEADER LINE, "- DIVISION
       IT_TVKBT TYPE TVKBT OCCURS 0 WITH HEADER LINE, "- SALES OFFICE
       IT_TVGRT TYPE TVGRT OCCURS 0 WITH HEADER LINE, "- SALES GROUP
       IT_TVTWT TYPE TVTWT OCCURS 0 WITH HEADER LINE, "DISTRIBUTION CHANNEL

       IT_TVAUT TYPE TVAUT OCCURS 0 WITH HEADER LINE, "-ORDER REASON
       IT_TVLVT TYPE TVLVT OCCURS 0 WITH HEADER LINE, "-USAGE TEXT
       IT_TVAGT TYPE TVAGT OCCURS 0 WITH HEADER LINE,"-REJ REASON

       IT_VBKD TYPE VBKD OCCURS 0 WITH HEADER LINE,"-SALES DISTRICT

       IT_KONP TYPE STANDARD TABLE OF KONP,

       IT_T685T TYPE STANDARD TABLE OF STR_T685T,  "---STRUCTURE FOR T685T TABLE
       WA_T685T TYPE STR_T685T,


       IT_ADRC     TYPE STANDARD TABLE OF STR_ADRC,  "
       WA_ADRC     TYPE STR_ADRC,

       IT_TVKTT TYPE STANDARD TABLE OF STR_TVKTT,
       WA_TVKTT TYPE STR_TVKTT.

*       GR_TABLE TYPE REF TO CL_SALV_TABLE.

DATA:  BEGIN OF IT_KONV OCCURS 0,
         KNUMV LIKE konv-KNUMV,
         KPOSN LIKE konv-KPOSN,
         KSCHL LIKE konv-KSCHL,
         KBETR LIKE konv-KBETR,
         KSTAT LIKE konv-KSTAT,
         KWERT LIKE konv-KWERT,
       END OF IT_KONV.

*--- OBJECT AND VARIABLE LIST FOR ALV GRID DISPLAY-------*
DATA : T_LISTHEADER TYPE SLIS_T_LISTHEADER WITH HEADER LINE,
       T_FIELDCATALOG TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
       FS_LAYOUT TYPE SLIS_LAYOUT_ALV,
       T_EVENT TYPE SLIS_T_EVENT WITH HEADER LINE.

DATA: BEGIN OF GT_INV OCCURS 50,
          VBELN LIKE VBRP-VBELN,
          ERDAT LIKE VBRP-ERDAT,
        END OF GT_INV.

DATA: BEGIN OF GT_GROSS OCCURS 50,
        VBELN LIKE VBRK-VBELN,
        ERDAT LIKE VBRK-ERDAT,
        NETWR LIKE VBRK-NETWR,
        MWSBK LIKE VBRK-MWSBK,
        AUBEL LIKE VBRP-AUBEL,
        AUPOS LIKE VBRP-POSNR,
      END OF GT_GROSS,

      BEGIN OF IT_CHPT OCCURS 0,
        MATNR LIKE J_1IMTCHID-MATNR,
        CHAPID LIKE J_1IMTCHID-J_1ICHID,
      END OF IT_CHPT,

      BEGIN OF IT_LIKP OCCURS 0,
        VBELN LIKE LIKP-VBELN,
        BOLNR LIKE LIKP-BOLNR,
        TRAID LIKE LIKP-TRAID,
      END OF IT_LIKP,

"Sum variables for it_data1.
      SUM_BASIC_AMT  TYPE KWERT,
      SUM_PFCRG      TYPE KWERT,
      SUM_EXCISE     TYPE KWERT,
      SUM_ECESS      TYPE KWERT,
      SUM_SHCESS     TYPE KWERT,
      SUM_ASSESS      TYPE KWERT,
      SUM_ASSCSTVAT  TYPE KWERT,
      SUM_TAX_AMT    TYPE KWERT,
      SUM_TAX_AMT2    TYPE KWERT,
      SUM_INSU       TYPE KWERT,
      SUM_DCOUNT     TYPE KWERT,
      SUM_FRT        TYPE KWERT,
      SUM_SUB_TOT    TYPE KWERT,
      SUM_N_FRT      TYPE KWERT,
      SUM_TCS        TYPE KWERT,
      SUM_TST_CHR    TYPE KWERT,
      SUM_GROSS_AMT  TYPE KWERT,


"Sum variables for it_data1_final.
      SUM_BASIC_AMT1  TYPE KWERT,
      SUM_PFCRG1      TYPE KWERT,
      SUM_EXCISE1     TYPE KWERT,
      SUM_ECESS1      TYPE KWERT,
      SUM_SHCESS1     TYPE KWERT,
      SUM_KBETR1_v    TYPE KWERT,
      SUM_ASSCSTVAT1  TYPE KWERT,
      SUM_TAX_AMT1    TYPE KWERT,
      SUM_INSU1       TYPE KWERT,
      SUM_DCOUNT1     TYPE KWERT,
      SUM_FRT1        TYPE KWERT,
      SUM_GROSS_AMT1  TYPE KWERT.

***************************************************


TYPES:  BEGIN OF SALE_DATA, " SALES REGISTER DATA
*        LEDGER         TYPE TVKTT-VTEXT,            "LEDGER text
        ACC_DOC        TYPE BKPF-BELNR,             "Accounting DOC NUMBER
           vbeln        TYPE vbrk-vbeln,         "invoice
*         ledger        TYPE i , "vbrk-ktgrd,         "LEDGER
         FKDAT         TYPE VBRK-FKDAT,             " VHR DATE
*        ACC_DOC        TYPE BKPF-BELNR,             "Accounting DOC NUMBER
        TAX_INV_NO     TYPE J_1IEXCDTL-EXNUM,       "TAX INV NO.
        INV_Dt         TYPE J_1IEXCDTL-EXDAT,       "INV DATE.
      SALE_ORD         LIKE VBRP-AUBEL,            " SALES ORDER
         LEDGER         TYPE TVKTT-VTEXT,            "LEDGER text
*          KUNRG         LIKE VBRK-KUNRG,           "customer
         NAME1         TYPE NAME1_GP,             "customer name
         CUST_ADD         TYPE CHAR100,             "customer ADDRESS
         VAT_NO        TYPE CHAR40,           " VAT TIN No
*         VAT_WEF       TYPE DATS,            " TIN No W.E.F
*         VAT_WEF       TYPE VBRK-FKDAT,            " TIN No W.E.F
         VAT_WEF       TYPE char10,            " TIN No W.E.F
         BASIC         TYPE konv-KWERT,   "BASIC
         P_F           TYPE konv-KWERT,   " P & F Charges
         Discount      TYPE konv-KWERT,   " Discount
         ASS_VALUE     TYPE konv-KWERT,   " Assessable Value
         EXCISE        TYPE konv-KWERT,   " EXCISE VALUE
         E_Cess        TYPE konv-KWERT,   " EDUCAITON CESS
         HE_Cess       TYPE konv-KWERT,   " EDUCAITON CESS
         FRIGHT        TYPE konv-KWERT,   "HIGHER EDUCAITON CESS
         SUB_TOT       TYPE konv-KWERT,   "SUBTOTAL
         VAT_CST       TYPE konv-KBETR,   "VAT/CST %
         TAX_AMT       TYPE konv-KWERT,   "TAX AMT
         TAX_TYP       TYPE T685T-VTEXT,  "TAX TYPE
         Insurance     TYPE konv-KWERT,  "iNSURANCE
         N_TAX_FRT     TYPE konv-KWERT,  "NON Taxable Freight
         TCS           TYPE konv-KWERT,   " TCS
         TST_CHR     TYPE konv-KWERT,   " TESTING & CERTIFICATION CHARGES
         GROSS_AMT     TYPE KWERT,
       END OF SALE_DATA.

TYPES:  BEGIN OF SUMMARY_DATA, " summary DATA
          LEDGER        TYPE TVKTT-VTEXT,            "LEDGER text
          VAT_CST       TYPE konv-KBETR,   "VAT/CST %
          BASIC         TYPE konv-KWERT,   "BASIC
          P_F           TYPE konv-KWERT,   " P & F Charges
          ASS_VALUE     TYPE konv-KWERT,   " Assessable Value
          EXCISE        TYPE konv-KWERT,   " EXCISE VALUE
          E_Cess        TYPE konv-KWERT,   " EDUCAITON CESS
          HE_Cess       TYPE konv-KWERT,   " EDUCAITON CESS
          FRIGHT        TYPE konv-KWERT,   "HIGHER EDUCAITON CESS
          SUB_TOT       TYPE konv-KWERT,   "SUBTOTAL
*          VAT_CST       TYPE KONV-KBETR,   "VAT/CST %
          TAX_AMT       TYPE konv-KWERT,   "TAX AMT
          TAX_TYP       TYPE T685T-VTEXT,  "TAX TYPE
          Insurance     TYPE konv-KWERT,  "TAX TYPE
          Discount      TYPE konv-KWERT,   " Discount
          TCS           TYPE konv-KWERT,   " TCS
          TST_CHARG     TYPE konv-KWERT,   " TESTING & CERTIFICATION CHARGES
          GROSS_AMT     TYPE KWERT,
        END OF SUMMARY_DATA.

*table type with space
TYPES:  BEGIN OF SPACE_SUMMARY_DATA, " summary DATA
          POS(150)      TYPE C,   " Space for position
          LEDGER        TYPE TVKTT-VTEXT,            "LEDGER text
          BASIC         TYPE konv-KWERT,   "BASIC
          P_F           TYPE konv-KWERT,   " P & F Charges
          ASS_VALUE     TYPE konv-KWERT,   " Assessable Value
          EXCISE        TYPE konv-KWERT,   " EXCISE VALUE
          E_Cess        TYPE konv-KWERT,   " EDUCAITON CESS
          HE_Cess       TYPE konv-KWERT,   " EDUCAITON CESS
          FRIGHT        TYPE konv-KWERT,   "HIGHER EDUCAITON CESS
          SUB_TOT       TYPE konv-KWERT,   "SUBTOTAL
          VAT_CST       TYPE konv-KBETR,   "VAT/CST %
          TAX_AMT       TYPE konv-KWERT,   "TAX AMT
          TAX_TYP       TYPE T685T-VTEXT,  "TAX TYPE
          Insurance     TYPE konv-KWERT,  "TAX TYPE
          Discount      TYPE konv-KWERT,   " Discount
          TCS           TYPE konv-KWERT,   " TCS
          TST_CHARG     TYPE konv-KWERT,   " TESTING & CERTIFICATION CHARGES
          GROSS_AMT     TYPE KWERT,
        END OF SPACE_SUMMARY_DATA.


TYPES:  BEGIN OF DBT_CREDIT, " Debit/Credit data
         FKDAT         TYPE VBRK-FKDAT,             " VHR DATE
         DB_CR         TYPE VBRK-VBELN,             "Debit/Credit Memo
         VBELN         LIKE VBRK-VBELN,            " SALES ORDER/REF No.
        TAX_INV_NO     TYPE J_1IEXCDTL-RDOC2,       "TAX INV NO.
        INV_Dt         TYPE J_1IEXCDTL-EXDAT,       "INV DATE.
         KTGRD         TYPE TVKTT-VTEXT,            "LEDGER text
*          KUNRG         LIKE VBRK-KUNRG,           "customer
         NAME1         TYPE NAME1_GP,             "customer name
      CUST_ADD         TYPE CHAR151,             "customer ADDRESS
         VAT_NO        TYPE CHAR40,           " VAT TIN No
         VAT_WEF       TYPE DATS,            " TIN No W.E.F
         BASIC         TYPE konv-KWERT,   "BASIC
         P_F           TYPE konv-KWERT,   " P & F Charges
         ASS_VALUE     TYPE konv-KWERT,   " Assessable Value
         EXCISE        TYPE konv-KWERT,   " EXCISE VALUE
         E_Cess        TYPE konv-KWERT,   " EDUCAITON CESS
         HE_Cess       TYPE konv-KWERT,   " EDUCAITON CESS
         FRIGHT        TYPE konv-KWERT,   "HIGHER EDUCAITON CESS
         SUB_TOT       TYPE konv-KWERT,   "SUBTOTAL
         VAT_CST       TYPE konv-KBETR,   "VAT/CST %
         TAX_AMT       TYPE konv-KWERT,   "TAX AMT
         TAX_TYP       TYPE T685T-VTEXT,  "TAX TYPE
         Insurance     TYPE konv-KWERT,  "TAX TYPE
         Discount      TYPE konv-KWERT,   " Discount
         TCS           TYPE konv-KWERT,   " TCS
         TST_CHARG     TYPE konv-KWERT,   " TESTING & CERTIFICATION CHARGES
         GROSS_AMT     TYPE KWERT,
       END OF DBT_CREDIT.

TYPES:  BEGIN OF ACC_DOC,
          BELNR     TYPE BELNR_D,
        END OF ACC_DOC.


DATA:    IT_SALE_DATA TYPE STANDARD TABLE OF SALE_DATA.
DATA:    IT_SALE_CREDIT TYPE STANDARD TABLE OF SALE_DATA.
DATA:    IT_SALE_DEBIT TYPE STANDARD TABLE OF SALE_DATA.
DATA:    IT_2SALE_DATA TYPE STANDARD TABLE OF SALE_DATA.
DATA:    IT_2SALE_CREDIT TYPE STANDARD TABLE OF SALE_DATA.
DATA:    IT_2SALE_DEBIT TYPE STANDARD TABLE OF SALE_DATA.
DATA:    WA_SALE_DATA TYPE SALE_DATA.
DATA:    WA_2SALE_DATA TYPE SALE_DATA.
DATA:    WA_3SALE_DATA TYPE SALE_DATA.

DATA:    IT_SUMMARY TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    WA_SUMMARY TYPE  SUMMARY_DATA.
DATA:    IT_SPACE_SUMMARY TYPE STANDARD TABLE OF SPACE_SUMMARY_DATA.
DATA:    IT_SPACE_DB_SUMMARY TYPE STANDARD TABLE OF SPACE_SUMMARY_DATA.
DATA:    IT_SPACE_CR_SUMMARY TYPE STANDARD TABLE OF SPACE_SUMMARY_DATA.
DATA:    IT_SPACE_FINAL_SUMMARY TYPE STANDARD TABLE OF SPACE_SUMMARY_DATA.

DATA:    WA_SPACE_SUMMARY TYPE  SPACE_SUMMARY_DATA.
DATA:    IT2_SUMMARY TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    WA2_SUMMARY TYPE  SUMMARY_DATA.
DATA:    IT_DEBIT TYPE STANDARD TABLE OF DBT_CREDIT.
DATA:    WA_DEBIT TYPE DBT_CREDIT.
DATA:    IT_DB_SUMMARY TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    WA_DB_SUMMARY TYPE SUMMARY_DATA.
DATA:    IT_CREDIT TYPE STANDARD TABLE OF DBT_CREDIT.
DATA:    WA_CREDIT TYPE DBT_CREDIT.
DATA:    IT_CR_SUMMARY TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    WA_CR_SUMMARY TYPE SUMMARY_DATA.
DATA:    IT_FINAL_SUMMARY TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    WA_FINAL_SUMMARY TYPE SUMMARY_DATA.
DATA:    IT_ACC_DOC TYPE STANDARD TABLE OF ACC_DOC.
DATA:    WA_J_1IEXCDTL TYPE J_1IEXCDTL.
DATA:    IT_T005U TYPE STANDARD TABLE OF T005U.
DATA:    WA_T005U TYPE T005U.
DATA:    IT_SUMMARY2 TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    IT_DB_SUMMARY2 TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    IT_CR_SUMMARY2 TYPE STANDARD TABLE OF SUMMARY_DATA.
DATA:    WA_PLADDR  LIKE WISO_PLADDR.
DATA:    WA_BAPI_RT LIKE BAPIRETURN1.
DATA:    WA_vbrk LIKE VBRK.


DATA: WA_ACC_DOC TYPE  ACC_DOC.
DATA: LV_AWKEY  TYPE AWKEY.
DATA: NTAX_INSU  TYPE KWERT.
DATA: LV_RDOC2  TYPE AWKEY.
DATA: LV_ADDRES TYPE CHAR100.
DATA: LV_TAX_AMT TYPE KWERT.
DATA: TOT_TAX_AMT TYPE KWERT.
DATA: TOT_TAX_AMT2 TYPE KWERT.
DATA: LV_TCS TYPE KWERT.
DATA: LV_TXT TYPE CHAR40.
DATA: LV_DT1(50) TYPE C.
DATA: LV_DT2(50) TYPE C.
*    DATA: LV_FDPOS(10)." TYPE CHAR.
DATA: LV_FDPOS TYPE COUNT." TYPE CHAR.
DATA: LV_VGBEL TYPE VBRP-VGBEL." SALES ORDER


***address data***
data : lv_name type CHAR28.
data : lv_STR_SUPPL1 type CHAR21.
data : lv_STR_SUPPL2 type CHAR8.
data : lv_street type CHAR18.
data : lv_taluka type CHAR9.
data : lv_district type CHAR4.
data : lv_pincode type CHAR6.


***************************A L  V    Data***************************
TYPE-POOLS: SLIS.
DATA: V_REPID TYPE SY-REPID,
*      WA_EVENTS TYPE SLIS_ALV_EVENT,
      WA_SALE_CAT TYPE SLIS_FIELDCAT_ALV,
      IT_SALE_FIELD TYPE SLIS_T_FIELDCAT_ALV,
      WA_SALE_SUMMARY_CAT TYPE SLIS_FIELDCAT_ALV,
      IT_SALE_SUMMARY_FIELD TYPE SLIS_T_FIELDCAT_ALV,
      WA_DEBIT_DATA_CAT TYPE SLIS_FIELDCAT_ALV,
      IT_DEBIT_FIELD TYPE SLIS_T_FIELDCAT_ALV,
      WA_DEBIT_SUMMARY_CAT TYPE SLIS_FIELDCAT_ALV,
      IT_DEBIT_SUMMARY_FIELD TYPE SLIS_T_FIELDCAT_ALV,
      WA_CREDIT_DATA_CAT TYPE SLIS_FIELDCAT_ALV,
      IT_CREDIT_FIELD TYPE SLIS_T_FIELDCAT_ALV,
      WA_CREDIT_SUMMARY_CAT TYPE SLIS_FIELDCAT_ALV,
      IT_CREDIT_SUMMARY_FIELD TYPE SLIS_T_FIELDCAT_ALV,
      WA_FINAL_SUMMARY_CAT TYPE SLIS_FIELDCAT_ALV,
      IT_FINAL_SUMMARY_FIELD TYPE SLIS_T_FIELDCAT_ALV,
      WA_SORT  TYPE SLIS_SORTINFO_ALV,
      IT_SORT  TYPE SLIS_T_SORTINFO_ALV .

DATA: V_LAYOUT TYPE SLIS_LAYOUT_ALV,
      V_LAYOUT1 TYPE SLIS_LAYOUT_ALV,
      WA_LAYOUT TYPE SLIS_LAYOUT_ALV,
      IT_EVENTS  TYPE SLIS_T_EVENT,
      IT_EVENTS1  TYPE SLIS_T_EVENT,
      IT_EVENTS2 TYPE SLIS_T_EVENT,
      IT_EVENTS3 TYPE SLIS_T_EVENT,
      IT_EVENTS4 TYPE SLIS_T_EVENT,
      IT_EVENTS5 TYPE SLIS_T_EVENT,
      IT_EVENTS6 TYPE SLIS_T_EVENT,
      IT_EVENTS7 TYPE SLIS_T_EVENT,
      WA_EVENTS TYPE SLIS_ALV_EVENT.

DATA: c_s TYPE c VALUE 'S',
i_list_top_of_page TYPE slis_t_listheader,   " Top-of-page
LF_LINE       TYPE SLIS_LISTHEADER, "Work Area
lv_var1      TYPE CHAR30, "Work Area
lv_var2      TYPE CHAR20. "Work Area
