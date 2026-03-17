*&---------------------------------------------------------------------*
*& Report ZFG_RACK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&Report: ZFG_RACK
*&Transaction
*&Functional Cosultant: Tejaswini Kapadnis
*&Technical Consultant: Jyoti MAhajan
*&TR: 1. DEVK915104       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:DISPATCH FG RACK LOCATION
*     2. DEVK915135       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:NEW REQUIREMENT CHANGE PROD ORD
*     3. DEVK915141       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:CHANGES IN DISPATCH REPORT
*     4. DEVK915190       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:ADDED 2 COLUMNS
*     5. DEVK915219       PRIMUSABAP   PRIMUS:INDIA:102175:ZFG_RACK:CHANGES IN WEIGHT COLMN
*     6. DEVK915255       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:CHANGES IN PROD ORD DATE
*     7. DEVK915260       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:TECHO IS NOT COMING
*     8. DEVK915286       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:TECHO PROD ORD NOT COMING
*     9. DEVK915290       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:LOGIC CHANGE FOR PROD ORDER
*    10. DEVK915301       PRIMUSABAP   PERIMUS:INDIA:101690:ZFG_RACK:MULTIPLE PROD ORDER AGAINST SO
*&Date: 1. 12/11/2024
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFG_RACK.

TABLES :VBAK,VBAP,KNA1,MARA.

TYPES : BEGIN OF TY_VBAK,
          VBELN TYPE VBAK-VBELN,
          ERDAT TYPE VBAK-ERDAT,
          AUDAT TYPE VBAK-AUDAT,
          AUART TYPE VBAK-AUART,
          NETWR TYPE VBAK-NETWR,
          WAERK TYPE VBAK-WAERK,
          KUNNR TYPE VBAK-KUNNR,
          KNUMV TYPE VBAK-KNUMV,
          VKBUR TYPE VBAK-VKBUR,
        END OF TY_VBAK.

TYPES : BEGIN OF TY_VBAP,
          VBELN  TYPE VBAP-VBELN,
          POSNR  TYPE VBAP-POSNR,
          MATNR  TYPE VBAP-MATNR,
          MATKL  TYPE VBAP-MATKL,
          KWMENG TYPE VBAP-KWMENG,
          VGBEL  TYPE VBAP-VGBEL,
          VGPOS  TYPE VBAP-VGPOS,
          WERKS  TYPE VBAP-WERKS,
          ABGRU  TYPE VBAP-ABGRU,
        END OF TY_VBAP.

TYPES : BEGIN OF TY_VBRP,
          VBELN TYPE VBRP-VBELN,
          POSNR TYPE VBRP-POSNR,
          FKIMG TYPE VBRP-FKIMG,
          AUBEL TYPE VBRP-AUBEL,
          AUPOS TYPE VBRP-AUPOS,
          MATNR TYPE VBRP-MATNR,
          WERKS TYPE VBRP-WERKS,
        END OF TY_VBRP,

        BEGIN OF TY_QALS,
          PRUEFLOS  TYPE QALS-PRUEFLOS,
          WERK      TYPE QALS-WERK,
          AUFNR     TYPE QALS-AUFNR,
          KDAUF     TYPE QALS-KDAUF,
          KDPOS     TYPE QALS-KDPOS,
          LMENGEZUB TYPE QALS-LMENGEZUB,
        END OF TY_QALS,



        BEGIN OF TY_KONV,
          KNUMV TYPE PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE PRCD_ELEMENTS-KPOSN,
          KSCHL TYPE PRCD_ELEMENTS-KSCHL,
          KBETR TYPE PRCD_ELEMENTS-KBETR,
          WAERS TYPE PRCD_ELEMENTS-WAERS,
          KWERT TYPE PRCD_ELEMENTS-KWERT,
        END OF TY_KONV.

TYPES : BEGIN OF TY_AFPO,
          AUFNR TYPE AFPO-AUFNR,
          POSNR TYPE AFPO-POSNR,
          KDAUF TYPE AFPO-KDAUF,
          KDPOS TYPE AFPO-KDPOS,
          MATNR TYPE AFPO-MATNR,
          PGMNG TYPE AFPO-PGMNG,
          PSMNG TYPE AFPO-PSMNG,
          WEMNG TYPE AFPO-WEMNG,
        END OF TY_AFPO.

TYPES : BEGIN OF TY_AUFM,
          MBLNR TYPE AUFM-MBLNR,
          BUDAT TYPE AUFM-BUDAT,
          WERKS TYPE AUFM-WERKS,
          AUFNR TYPE AUFM-AUFNR,
          LGORT TYPE AUFM-LGORT,
          KDAUF TYPE AUFM-KDAUF,
          KDPOS TYPE AUFM-KDPOS,
          BWART TYPE AUFM-BWART,
          SHKZG TYPE AUFM-SHKZG,
          MENGE TYPE AUFM-MENGE,
        END OF TY_AUFM.


TYPES : BEGIN OF TY_CAUFV,
          AUFNR TYPE CAUFV-AUFNR,
          OBJNR TYPE CAUFV-OBJNR,
          KDAUF TYPE CAUFV-KDAUF,
          KDPOS TYPE CAUFV-KDPOS,
          IGMNG TYPE CAUFV-IGMNG,
        END OF TY_CAUFV .

TYPES : BEGIN OF TY_AFRU,
          BUDAT TYPE AFRU-BUDAT,
          AUFNR TYPE AFRU-AUFNR,
          STOKZ TYPE AFRU-STOKZ,
          STZHL TYPE AFRU-STZHL,

        END OF TY_AFRU.

TYPES : BEGIN OF TY_JEST,
          OBJNR TYPE JEST-OBJNR,
          STAT  TYPE JEST-STAT,
        END OF TY_JEST.

TYPES : BEGIN OF TY_MARA,
          MATNR   TYPE MARA-MATNR,
          NTGEW   TYPE MARA-NTGEW,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          BRAND   TYPE MARA-BRAND,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
          WRKST   TYPE MARA-WRKST,
        END OF TY_MARA.

TYPES : BEGIN OF TY_VBKD,
          VBELN TYPE VBKD-VBELN,
          POSNR TYPE VBKD-POSNR, "added by jyoti on 16.04.2024
          INCO1 TYPE VBKD-INCO1,
          INCO2 TYPE VBKD-INCO2,
          ZTERM TYPE VBKD-ZTERM,
          KTGRD TYPE VBKD-KTGRD,                  "added by pankaj 04.02.2022
          KURSK TYPE VBKD-KURSK,
          BSTKD TYPE VBKD-BSTKD,
          PRSDT TYPE VBKD-PRSDT,

        END OF TY_VBKD.

TYPES: BEGIN OF TY_T052U,
         SPRAS TYPE T052U-SPRAS,
         ZTERM TYPE T052U-ZTERM,
         TEXT1 TYPE T052U-TEXT1,
       END OF TY_T052U.

TYPES : BEGIN OF TY_DATA,
          VBELN TYPE VBELN,
          POSNR TYPE POSNR,
          MATNR TYPE MATNR,
          LGORT TYPE VBAP-LGORT,
          WERKS TYPE VBAP-WERKS,
          LFSTA TYPE VBUP-LFSTA,
          LFGSA TYPE VBUP-LFGSA,
          FKSTA TYPE VBUP-FKSTA,
          ABSTA TYPE VBUP-ABSTA,
          GBSTA TYPE VBUP-GBSTA,
          AUFNR TYPE AFPO-AUFNR,
          PSMNG TYPE AFPO-PSMNG,
          WEMNG TYPE AFPO-WEMNG,
          EBELN TYPE EKKN-EBELN,
          EBELP TYPE EKKN-EBELP,
          MENGE TYPE EKKN-MENGE,
        END OF TY_DATA.

TYPES : BEGIN OF TY_MSEG,
          MBLNR      TYPE MSEG-MBLNR,
          BWART      TYPE MSEG-BWART,
          MATNR      TYPE MSEG-MATNR,
          WERKS      TYPE MSEG-WERKS,
          LGORT      TYPE MSEG-LGORT,
          KDAUF      TYPE MSEG-KDAUF,
          KDPOS      TYPE MSEG-KDPOS,
          SMBLN      TYPE MSEG-SMBLN,
          AUFNR      TYPE MSEG-AUFNR,
          EBELN      TYPE MSEG-EBELN,
          XAUTO      TYPE MSEG-XAUTO,
          MENGE      TYPE MSEG-MENGE,
          BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
          EBELP      TYPE MSEG-EBELP,
        END OF TY_MSEG.

TYPES : BEGIN OF TY_VBRK,
          VBELN TYPE VBRK-VBELN,
          FKART TYPE VBRK-FKART,
          FKTYP TYPE VBRK-FKTYP,
          VKORG TYPE VBRK-VKORG,
          VTWEG TYPE VBRK-VTWEG,
          FKDAT TYPE VBRK-FKDAT,
          FKSTO TYPE VBRK-FKSTO,
        END OF TY_VBRK.

TYPES : BEGIN OF TY_VBFA,
          VBELV   TYPE VBFA-VBELV,
          POSNV   TYPE VBFA-POSNV,
          VBELN   TYPE VBFA-VBELN,
          VBTYP_N TYPE VBFA-VBTYP_N,
        END OF TY_VBFA.

TYPES : BEGIN OF TY_KNA1,
          KUNNR TYPE KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
          ADRNR TYPE KNA1-ADRNR,
        END OF TY_KNA1,

        BEGIN OF TY_MSKA,
          MATNR TYPE MSKA-MATNR,
          WERKS TYPE MSKA-WERKS,
          LGORT TYPE MSKA-LGORT,
          VBELN TYPE MSKA-VBELN,
          POSNR TYPE MSKA-POSNR,
          KALAB TYPE MSKA-KALAB,
          KAINS TYPE MSKA-KAINS,
        END OF TY_MSKA,

        BEGIN OF TY_MARD,
          MATNR TYPE MARD-MATNR,
          WERKS TYPE MARD-WERKS,
          LGORT TYPE MARD-LGORT,
          LABST TYPE MARD-LABST,
          INSME TYPE MARD-INSME,
          DISKZ TYPE MARD-DISKZ,
        END OF TY_MARD,


        BEGIN OF TY_VBPA,
          VBELN TYPE VBPA-VBELN,
          POSNR TYPE VBPA-POSNR,
          PARVW TYPE VBPA-PARVW,
          KUNNR TYPE VBPA-KUNNR,
          ADRNR TYPE VBPA-ADRNR,
          LAND1 TYPE VBPA-LAND1,
        END OF TY_VBPA,

        BEGIN OF TY_AUFK,
          AUFNR TYPE AUFK-AUFNR,
          KDAUF TYPE AUFK-KDAUF,
          KDPOS TYPE AUFK-KDPOS,
        END OF TY_AUFK,

        BEGIN OF TY_AUFK1,
          AUFNR TYPE AUFK-AUFNR,
          LOEKZ TYPE AUFK-LOEKZ,
        END OF TY_AUFK1,

        BEGIN OF TY_RACK,
          VBELN          TYPE ZFG_RACK-VBELN,
          POSNR          TYPE ZFG_RACK-POSNR,
          MATNR          TYPE ZFG_RACK-MATNR,
          ZRACK_LOC      TYPE ZFG_RACK-ZRACK_LOC,
          ZMAT_REMARK    TYPE ZFG_RACK-ZMAT_REMARK,
          ZFG_WEIGHT     TYPE ZFG_RACK-ZFG_WEIGHT,
          ZPROD_PLAN_NEW TYPE ZFG_RACK-ZPROD_PLAN_NEW,
          ZPROD_QTY      TYPE ZFG_RACK-ZPROD_QTY,
          EBELN          TYPE ZFG_RACK-EBELN,
          AUFNR          TYPE ZFG_RACK-AUFNR,

        END OF TY_RACK,

        BEGIN OF TY_RACK_WEIGHT,
          MATNR      TYPE ZFG_RACK_WEIGHT-MATNR,
          ZFG_WEIGHT TYPE ZFG_RACK_WEIGHT-ZFG_WEIGHT,
        END OF TY_RACK_WEIGHT,

        BEGIN OF TY_RACK_PLANQTY,
          VBELN     TYPE ZFG_RACK_PLANQTY-VBELN,
          POSNR     TYPE ZFG_RACK_PLANQTY-POSNR,
          ZPROD_QTY TYPE ZFG_RACK_PLANQTY-ZPROD_QTY,
        END OF TY_RACK_PLANQTY.

TYPES : BEGIN OF TY_FINAL,
          VBELN           TYPE VBAK-VBELN,
          POSNR           TYPE VBAP-POSNR,
          KUNNR           TYPE KNA1-KUNNR,
          NAME1           TYPE KNA1-NAME1,
          MATNR           TYPE VBAP-MATNR,
          MATTXT          TYPE TEXT100, "material description
          KWMENG          TYPE VBAP-KWMENG,
          FKIMG           TYPE VBRP-FKIMG,
          PND_QTY         LIKE VBRP-FKIMG,
          WIP             TYPE VBRP-FKIMG,
          QMQTY           TYPE MSKA-KAINS,
          STOCK_QTY       TYPE MSKA-KALAB,
          KBETR           TYPE PRCD_ELEMENTS-KBETR,
          AMONT           TYPE CHAR15,
          SO_EXC          TYPE UKURSP,
          TPI             TYPE CHAR50,
          INCO1           TYPE VBKD-INCO1,
          INCO2           TYPE VBKD-INCO2,
          ZSIZE           TYPE MARA-ZSIZE,
          ZSERIES         TYPE MARA-ZSERIES,
          SHIP_KUNNR      TYPE KUNNR,            "ship to party code
          SHIP_KUNNR_N    TYPE AD_NAME1,       "ship to party desctiption
          NTGEW           TYPE MARA-NTGEW,
          AUFNR           TYPE AUFM-AUFNR,
          BUDAT           TYPE AUFM-BUDAT,
          LGORT           TYPE MSKA-LGORT,
          US_CUST         TYPE CHAR250,
          ZRACK_LOC       TYPE CHAR80,
          ZMAT_REMARK     TYPE CHAR80,
          ZFG_WEIGHT      TYPE ZFG_RACK-ZFG_WEIGHT,
*          GEWEI   TYPE zfg_rack-GEWEI,
          ZPROD_PLAN      TYPE CHAR40,
          ZPROD_QTY       TYPE AFPO-PSMNG,
          STOCK_QTY1      TYPE MARD-LABST,
          LGORT1          TYPE CHAR50,
          BSTKD           TYPE BSTKD,
          VKBUR           TYPE VKBUR,
          WRKST           TYPE WRKST,
          SHIP_KUNNR_NAME TYPE NAME1,
          EBELN           TYPE EBELN,
          EBELP           TYPE EBELP,
          MENGE           TYPE AUFM-MENGE,
          AUART           TYPE AUART,
          KALAB           TYPE MSKA-KALAB,
          LOEKZ           TYPE AUFK-LOEKZ,
          PSMNG           TYPE AFPO-PSMNG,
          WEMNG           TYPE AFPO-WEMNG,
          MENGE1          TYPE EKKN-MENGE,
          MENGE_101       TYPE EKKN-MENGE,
          MENGE_102       TYPE EKKN-MENGE,
          MENGE_122       TYPE EKKN-MENGE,
          MENGE2          TYPE EKKN-MENGE,
          MENGE_MSEG      TYPE MSEG-MENGE,
          BUDAT_MKPF      TYPE MSEG-BUDAT_MKPF,
          GRN_DATE        TYPE MSEG-BUDAT_MKPF,
          FG01            TYPE MSKA-KALAB,
          TPI1            TYPE MSKA-KALAB,
          KFG0            TYPE MSKA-KALAB,
          KTPI            TYPE MSKA-KALAB,
*********************************************
*          curr_con     TYPE ukursp,
*          lfimg        TYPE lips-lfimg,
        END OF TY_FINAL.

TYPES : BEGIN OF TY_DOWN,
          VBELN           TYPE STRING,
          POSNR           TYPE STRING,
          NAME1           TYPE STRING,
          KUNNR           TYPE STRING,
          MATNR           TYPE STRING,
          MATTXT          TYPE STRING,
          KWMENG          TYPE STRING,
          FKIMG           TYPE STRING,
          PND_QTY         TYPE STRING,
          WIP             TYPE STRING,
          QMQTY           TYPE STRING,
          STOCK_QTY       TYPE STRING,
          KBETR           TYPE STRING,
          AMONT           TYPE STRING,
          SO_EXC          TYPE STRING,
          TPI             TYPE STRING,
          INCO1           TYPE STRING,
          INCO2           TYPE STRING,
          SHIP_KUNNR      TYPE STRING,
          SHIP_KUNNR_NAME TYPE STRING,
          ZSIZE           TYPE STRING,
          ZSERIES         TYPE STRING,
          NTGEW           TYPE STRING,
          AUFNR           TYPE STRING,
          BUDAT           TYPE STRING,
*          lgort           TYPE string,
          US_CUST         TYPE STRING,
          BSTKD           TYPE STRING,
          VKBUR           TYPE STRING,
          WRKST           TYPE STRING,
          ZRACK_LOC       TYPE STRING,
          ZMAT_REMARK     TYPE STRING,
          ZFG_WEIGHT      TYPE STRING,
          ZPROD_PLAN      TYPE STRING,
          ZPROD_QTY       TYPE STRING,
          STOCK_QTY1      TYPE STRING,
          LGORT1          TYPE STRING,
          REF_DATE        TYPE STRING,
          REF_TIME        TYPE STRING,
          EBELN           TYPE STRING,
*          kalab           TYPE string,
          PSMNG           TYPE STRING,
          WEMNG           TYPE STRING,
          MENGE1          TYPE STRING,
          MENGE2          TYPE STRING,
          LOEKZ           TYPE STRING,
          MENGE_MSEG      TYPE STRING,
          BUDAT_MKPF      TYPE STRING,
          GRN_DATE        TYPE STRING,
          FG01            TYPE STRING,
          TPI1            TYPE STRING,
          KFG0            TYPE STRING,
          KTPI            TYPE STRING,
          EBELP           TYPE STRING,
        END OF TY_DOWN.

TYPES : BEGIN OF IT_NEW,
          KDAUF TYPE KDAUF,
          KDPOS TYPE KDPOS,
          AUFNR TYPE AUFNR,
        END OF IT_NEW.

TYPES : BEGIN OF TY_KNA1_NEW,
          KUNNR TYPE KUNNR,
          NAME1 TYPE NAME1,
        END OF TY_KNA1_NEW.

TYPES : BEGIN OF TY_TCURR,
          KURST TYPE TCURR-KURST,
          FCURR TYPE TCURR-FCURR,
          TCURR TYPE TCURR-TCURR,
          GDATU TYPE STRING,
          UKURS TYPE TCURR-UKURS,
        END OF TY_TCURR.

TYPES : BEGIN OF TY_EKBE,
          EBELN TYPE EKBE-EBELN,
          EBELP TYPE EKBE-EBELP,
          BELNR TYPE EKBE-BELNR,
          MENGE TYPE EKBE-MENGE,
          BWART TYPE EKBE-BWART,
          BUZEI TYPE EKBE-BUZEI,
          MATNR TYPE EKBE-MATNR,
        END OF TY_EKBE.

DATA : IT_VBAK         TYPE TABLE OF TY_VBAK,
       WA_VBAK         TYPE TY_VBAK,

       IT_RACK         TYPE TABLE OF TY_RACK,
       WA_RACK         TYPE  TY_RACK,

       IT_RACK_WEIGHT  TYPE TABLE OF TY_RACK_WEIGHT,
       WA_RACK_WEIGHT  TYPE  TY_RACK_WEIGHT,

       	  IT_RACK_PLANQTY TYPE TABLE OF TY_RACK_PLANQTY,
       WA_RACK_PLANQTY TYPE  TY_RACK_PLANQTY,


       IT_EKBE         TYPE TABLE OF TY_EKBE,
       WA_EKBE         TYPE  TY_EKBE,

       IT_KNA1_NEW     TYPE TABLE OF TY_KNA1_NEW,
       WA_KNA1_NEW     TYPE  TY_KNA1_NEW,

       IT_DATA_NEW     TYPE TABLE OF IT_NEW,
       WA_DATA_NEW     TYPE  IT_NEW,

       IT_KONV1        TYPE TABLE OF TY_KONV,
       WA_KONV1        TYPE  TY_KONV,

       IT_MSEG         TYPE TABLE OF TY_MSEG,
       WA_MSEG         TYPE  TY_MSEG,

       IT_MSEG1        TYPE TABLE OF TY_MSEG,
       WA_MSEG1        TYPE  TY_MSEG,

       IT_KNA1         TYPE TABLE OF TY_KNA1,
       WA_KNA1         TYPE  TY_KNA1,

       IT_VBAP         TYPE TABLE OF TY_VBAP,
       WA_VBAP         TYPE TY_VBAP,

       IT_AFRU         TYPE TABLE OF TY_AFRU,
       WA_AFRU         TYPE TY_AFRU,

       IT_VBRP         TYPE TABLE OF TY_VBRP,
       WA_VBRP         TYPE TY_VBRP,

       IT_VBRK         TYPE TABLE OF TY_VBRK,
       WA_VBRK         TYPE TY_VBRK,

       IT_VBFA         TYPE TABLE OF TY_VBFA,
       WA_VBFA         TYPE TY_VBFA,

       IT_AFPO         TYPE TABLE OF TY_AFPO,
       WA_AFPO         TYPE TY_AFPO,

       IT_QALS         TYPE TABLE OF TY_QALS,
       WA_QALS         TYPE TY_QALS,

       IT_JEST2        TYPE TABLE OF TY_JEST,
       WA_JEST2        TYPE TY_JEST,

       IT_CAUFV        TYPE TABLE OF TY_CAUFV,
       WA_CAUFV        TYPE TY_CAUFV,

       IT_JEST         TYPE TABLE OF TY_JEST,
       WA_JEST         TYPE TY_JEST,

       IT_VBKD         TYPE TABLE OF TY_VBKD,
       WA_VBKD         TYPE TY_VBKD,

       IT_T052U        TYPE TABLE OF TY_T052U,
       WA_T052U        TYPE T052U,

       IT_DATA         TYPE STANDARD TABLE OF TY_DATA,
       WA_DATA         TYPE TY_DATA,

       IT_DATA1        TYPE STANDARD TABLE OF TY_DATA,
       WA_DATA1        TYPE TY_DATA,

       IT_DATA2        TYPE STANDARD TABLE OF TY_DATA,
       WA_DATA2        TYPE TY_DATA,

       IT_DATA3        TYPE STANDARD TABLE OF TY_DATA,
       WA_DATA3        TYPE TY_DATA,

       IT_TCURR        TYPE STANDARD TABLE OF TY_TCURR,
       WA_TCURR        TYPE TY_TCURR,

       IT_MARA         TYPE TABLE OF TY_MARA,
       WA_MARA         TYPE TY_MARA,

       IT_MSKA         TYPE TABLE OF TY_MSKA,
       WA_MSKA         TYPE  TY_MSKA,

       IT_MARD         TYPE TABLE OF TY_MARD,
       WA_MARD         TYPE  TY_MARD,

       IT_ADRC         TYPE TABLE OF ADRC,
       WA_ADRC         TYPE ADRC,

       IT_VBPA         TYPE TABLE OF TY_VBPA,
       WA_VBPA         TYPE TY_VBPA,

       IT_AUFM         TYPE TABLE OF TY_AUFM,
       WA_AUFM         TYPE TY_AUFM,

       IT_FINAL        TYPE TABLE OF TY_FINAL,
       IT_FINAL1       TYPE TABLE OF TY_FINAL,
       WA_FINAL        TYPE TY_FINAL,

       IT_DOWN         TYPE TABLE OF TY_DOWN,
       WA_DOWN         TYPE TY_DOWN,

       IT_AUFK         TYPE TABLE OF TY_AUFK,
       WA_AUFK         TYPE TY_AUFK,

       IT_AUFK1        TYPE TABLE OF TY_AUFK1,
       WA_AUFK1        TYPE TY_AUFK1,


       IT_FCAT         TYPE SLIS_T_FIELDCAT_ALV,
       WA_FCAT         TYPE LINE OF SLIS_T_FIELDCAT_ALV.

DATA : LV_LINES           TYPE STANDARD TABLE OF TLINE,
       WA_LINES           LIKE TLINE,
       LS_LINES           LIKE TLINE,
       LS_MATTXT          TYPE TLINE,
       WA_TEXT1           TYPE CHAR50,
       LV_NAME            TYPE THEAD-TDNAME,
       LV_INDEX           TYPE SY-TABIX,


       I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
       GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
       I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
       WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV...

*data for bapi to convert currency

DATA: BEGIN OF LS_FR_CURR OCCURS 0.
        INCLUDE STRUCTURE BAPI1093_3.
DATA: END OF LS_FR_CURR.

DATA: BEGIN OF LS_TO_CURR OCCURS 0.
        INCLUDE STRUCTURE BAPI1093_4.
DATA: END OF LS_TO_CURR.

DATA: BEGIN OF LS_EX_RATE OCCURS 0.
        INCLUDE STRUCTURE BAPI1093_0.
DATA: END OF LS_EX_RATE.

DATA: LV_EX_RATE TYPE BAPI1093_0.

DATA: BEGIN OF LS_RETURN OCCURS 0.
        INCLUDE STRUCTURE BAPIRET1.
DATA: END OF LS_RETURN.


LS_FR_CURR-SIGN   = 'I'.
LS_FR_CURR-OPTION = 'EQ'.
*LV_FR_CURR-LOW = 'EQ'.

LS_TO_CURR-SIGN   = 'I'.
LS_TO_CURR-OPTION = 'EQ'.
LS_TO_CURR-LOW = 'INR'.
APPEND LS_TO_CURR .


***********************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  C_FORMNAME_TOP_OF_PAGE   TYPE SLIS_FORMNAME
                                   VALUE 'TOP_OF_PAGE',
  C_FORMNAME_PF_STATUS_SET TYPE SLIS_FORMNAME
                                 VALUE 'PF_STATUS_SET',
  C_S                      TYPE C VALUE 'S',
  C_H                      TYPE C VALUE 'H',
  C_PLANT                  TYPE CHAR4 VALUE 'PL01',
  C_LFSTA                  TYPE C VALUE 'C',
  C_LFGSA                  TYPE C VALUE 'C',
  C_FKSTA                  TYPE C VALUE 'C',
  C_GBSTA                  TYPE C VALUE 'C',
  C_ABSTA                  TYPE C VALUE 'C',
  C_ETTYP                  TYPE CHAR2 VALUE 'CP',
  C_PATH                   TYPE CHAR50 VALUE  '/Delval/India'  ,         "'/delval/temp',
  C_VBTYP_N                TYPE CHAR1 VALUE 'J',
  C_VBTYP_N1               TYPE CHAR1 VALUE 'M',
  C_FKSTO                  TYPE CHAR1 VALUE 'X',
  C_SPRAS                  TYPE CHAR2 VALUE 'EN',
  C_SOBKZ                  TYPE CHAR1 VALUE 'E',
  C_DISKZ                  TYPE CHAR1 VALUE ' ',
  C_KURST                  TYPE CHAR1 VALUE 'B'.

INITIALIZATION.

  SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
    SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .
      PARAMETERS : P_WERKS TYPE VBAP-WERKS OBLIGATORY DEFAULT C_PLANT MODIF ID BU.
      SELECT-OPTIONS   :  S_VBELN FOR VBAP-VBELN,
                          S_POSNR FOR VBAP-POSNR,
                          S_MATNR FOR VBAP-MATNR,
                          S_LGORT FOR VBAP-LGORT.
      .
    SELECTION-SCREEN END OF BLOCK B2.
  SELECTION-SCREEN END OF BLOCK B1.

  SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-002.
    PARAMETERS UPLOAD  RADIOBUTTON GROUP CODE DEFAULT 'X' .
    PARAMETERS DISPLAY  RADIOBUTTON GROUP CODE.
  SELECTION-SCREEN END OF BLOCK B3.

  SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
    PARAMETERS P_DOWN AS CHECKBOX.
    PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT C_PATH.
  SELECTION-SCREEN END OF BLOCK B5.

  SELECTION-SCREEN BEGIN OF BLOCK B6 WITH FRAME TITLE TEXT-005.
    SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN END OF BLOCK B6.

**********below logic for gray out the default valuse
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM FILL_TABLES. "perform use for fetch the data
  PERFORM PROCESS_FOR_OUTPUT."perform for logic to line item wise
  PERFORM ALV_FOR_OUTPUT."alve output(filedcatlog)

*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

FORM FILL_TABLES .
*  BREAK primusabap.
*************below logic for pending sales orderwise multiple production order
*  SELECT a~vbeln
*         a~posnr
*         a~matnr
*         a~lgort
*         a~werks
*         b~lfsta
*         b~lfgsa
*         b~fksta
*         b~absta
*         b~gbsta
*         c~aufnr
*         d~ettyp
*  INTO TABLE it_data1
*  FROM  vbap AS a
*  JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
* JOIN afpo AS c ON  ( c~kdauf = a~vbeln  AND c~kdpos = a~posnr )
** JOIN aufk AS c ON  ( c~kdauf = a~vbeln  AND c~kdpos = a~posnr )
*    JOIN vbep AS d ON d~vbeln = a~vbeln
*                       AND d~posnr = a~posnr
**    JOIN  vbak AS C ON a~vbeln = c~vbeln
*  WHERE  a~matnr  IN s_matnr
*  AND   a~vbeln  IN s_vbeln
*  AND   a~posnr  IN s_posnr
*  AND   a~lgort IN s_lgort
*  AND   a~werks = p_werks
*  AND   b~lfsta  NE C_lfsta
*  AND   b~lfgsa  NE C_lfgsa
*  AND   b~fksta  NE C_fksta
*  AND   b~gbsta  NE C_gbsta
*  AND   C~ELIKZ EQ 'X'
*  AND    d~ettyp = C_ettyp  .


  SELECT A~VBELN
      A~POSNR
      A~MATNR
      A~LGORT
      A~WERKS
      B~LFSTA
      B~LFGSA
*      b~fksta
      B~ABSTA
      B~GBSTA
INTO CORRESPONDING FIELDS OF TABLE IT_DATA2
FROM  VBAP AS A
*JOIN vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
JOIN VBAP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
    WHERE  A~MATNR  IN S_MATNR
AND   A~VBELN  IN S_VBELN
AND   A~POSNR  IN S_POSNR
AND   A~LGORT IN S_LGORT
AND   A~WERKS = P_WERKS
AND   B~LFSTA  NE C_LFSTA
AND   B~LFGSA  NE C_LFGSA
*AND   b~fksta  NE c_fksta
AND   B~GBSTA  NE C_GBSTA.

  SELECT A~VBELN
         A~POSNR
         A~MATNR
         A~LGORT
         A~WERKS
         B~LFSTA
         B~LFGSA
*         b~fksta
         B~ABSTA
         B~GBSTA
         C~AUFNR
         C~PSMNG
         C~WEMNG
*        d~ebeln
*        d~menge
*        d~ettyp
  INTO CORRESPONDING FIELDS OF TABLE IT_DATA1
  FROM  VBAP AS A
*  JOIN vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
  JOIN VBAP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
  JOIN AFPO AS C ON ( C~KDAUF = A~VBELN  AND C~KDPOS = A~POSNR     AND C~MATNR = A~MATNR )
*  JOIN ekkn AS d ON  ( d~vbeln = a~vbeln  AND d~vbelp = a~posnr  )
* JOIN aufk AS c ON  ( c~kdauf = a~vbeln  AND c~kdpos = a~posnr )
*    JOIN vbep AS d ON d~vbeln = a~vbeln
*                       AND d~posnr = a~posnr
*    JOIN  vbak AS C ON a~vbeln = c~vbeln
  WHERE  A~MATNR  IN S_MATNR
  AND   A~VBELN  IN S_VBELN
  AND   A~POSNR  IN S_POSNR
  AND   A~LGORT IN S_LGORT
  AND   A~WERKS = P_WERKS
  AND   B~LFSTA  NE C_LFSTA
  AND   B~LFGSA  NE C_LFGSA
*  AND   b~fksta  NE c_fksta
  AND   B~GBSTA  NE C_GBSTA.
*  AND   C~ELIKZ EQ 'X'.
*  AND    d~ettyp = C_ettyp  .

  SELECT A~VBELN
         A~POSNR
         A~MATNR
         A~LGORT
         A~WERKS
         B~LFSTA
         B~LFGSA
*         B~FKSTA
         B~ABSTA
         B~GBSTA
         D~EBELN
         D~EBELP
         D~MENGE
      APPENDING CORRESPONDING FIELDS OF TABLE IT_DATA1
      FROM  VBAP AS A
*      JOIN  vbup AS b ON  ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
      JOIN  VBAP AS B ON  ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
      JOIN  EKKN AS D ON  ( D~VBELN = A~VBELN  AND D~VBELP = A~POSNR  )
      JOIN  EKPO AS C ON  ( C~EBELN = D~EBELN  AND C~EBELP = D~EBELP AND C~MATNR = A~MATNR )
      WHERE  A~MATNR IN S_MATNR
      AND   A~VBELN  IN S_VBELN
      AND   A~POSNR  IN S_POSNR
      AND   A~LGORT  IN S_LGORT
      AND   A~WERKS = P_WERKS
      AND   B~LFSTA  NE C_LFSTA
      AND   B~LFGSA  NE C_LFGSA
*      AND   B~FKSTA  NE C_FKSTA
      AND   B~GBSTA  NE C_GBSTA
      AND   C~LOEKZ  NE 'L'.

****************if multiple records against same sales order and all data
  SORT IT_DATA1.
  DELETE ADJACENT DUPLICATES FROM IT_DATA1 COMPARING ALL FIELDS.

  LOOP AT IT_DATA2 INTO WA_DATA2.
    READ TABLE IT_DATA1 INTO WA_DATA1 WITH KEY VBELN = WA_DATA2-VBELN
                                                POSNR = WA_DATA2-POSNR.
    IF SY-SUBRC IS NOT INITIAL.
      APPEND WA_DATA2 TO IT_DATA1.
      CLEAR : WA_DATA2,WA_DATA1.
    ENDIF.
  ENDLOOP.

  REFRESH : IT_DATA2.

****************below logic for rejection status for sales order line item wise
  LOOP AT IT_DATA1 INTO WA_DATA.
*    IF wa_data-absta = 'C'.
    IF WA_DATA-ABSTA = C_ABSTA.
      IF WA_DATA-LFSTA = ' ' AND WA_DATA-LFGSA = ' ' AND WA_DATA-FKSTA = ' ' AND WA_DATA-GBSTA = ' '.
        IF SY-SUBRC = 0.
*            delete it_data[] from ls_data.
          DELETE IT_DATA1[]  WHERE VBELN = WA_DATA-VBELN AND POSNR = WA_DATA-POSNR.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
*  BREAK primusabap.

  IT_DATA2  =  IT_DATA1 .
  IT_DATA3  =  IT_DATA1 .

  DELETE IT_DATA2 WHERE AUFNR = SPACE.
  DELETE IT_DATA3 WHERE EBELN = SPACE.
*  BREAK primusabap.
  IF IT_DATA2 IS NOT INITIAL.
    SELECT MBLNR
       BWART
       MATNR
       WERKS
       LGORT
       KDAUF
       KDPOS
       SMBLN
       AUFNR
       MENGE
       BUDAT_MKPF
  FROM MSEG
  INTO CORRESPONDING FIELDS OF TABLE IT_MSEG
  FOR ALL ENTRIES IN IT_DATA2
  WHERE AUFNR = IT_DATA2-AUFNR
  AND   KDAUF = IT_DATA2-VBELN
  AND   KDPOS = IT_DATA2-POSNR
  AND   BWART IN ('321' ,'322')
  AND   XAUTO = 'X'.

    LOOP AT IT_MSEG INTO WA_MSEG WHERE SMBLN IS NOT INITIAL .
      READ TABLE IT_MSEG INTO DATA(WA_MSEG1) WITH KEY MBLNR = WA_MSEG-SMBLN.
      IF SY-SUBRC IS INITIAL.
        DELETE IT_MSEG WHERE MBLNR = WA_MSEG-SMBLN.
        DELETE IT_MSEG WHERE SMBLN = WA_MSEG-SMBLN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF IT_DATA3 IS  NOT INITIAL.
    SELECT MBLNR
          BWART
          MATNR
          WERKS
          LGORT
          KDAUF
          KDPOS
          SMBLN
          AUFNR
          EBELN
          XAUTO
          MENGE
          BUDAT_MKPF
          EBELP
    FROM MSEG
    INTO CORRESPONDING FIELDS OF TABLE IT_MSEG1
    FOR ALL ENTRIES IN IT_DATA3
    WHERE EBELN = IT_DATA3-EBELN
    AND   KDAUF = IT_DATA3-VBELN
    AND   KDPOS = IT_DATA3-POSNR
    AND   BWART IN ('321' ,'322', '101' ,'102' ,'122').
*    AND   xauto = 'X'.


    LOOP AT IT_MSEG1 INTO WA_MSEG1 WHERE SMBLN IS NOT INITIAL .
      READ TABLE IT_MSEG1 INTO DATA(WA_MSEG2) WITH KEY MBLNR = WA_MSEG1-SMBLN.
      IF SY-SUBRC IS INITIAL.
        DELETE IT_MSEG1 WHERE MBLNR = WA_MSEG1-SMBLN.
        DELETE IT_MSEG1 WHERE SMBLN = WA_MSEG1-SMBLN.
      ENDIF.
    ENDLOOP.
    SORT IT_MSEG1 BY BWART XAUTO.
    DELETE IT_MSEG1 WHERE XAUTO NE 'X' AND BWART = '321'.
    SORT IT_MSEG1 BY BUDAT_MKPF DESCENDING.
  ENDIF.

  SELECT EBELN
         EBELP
         BELNR
         MENGE
         BWART
         BUZEI
         MATNR
    FROM EKBE
    INTO TABLE IT_EKBE
    FOR ALL ENTRIES IN IT_DATA1
    WHERE EBELN = IT_DATA1-EBELN
    AND BWART IN ('101' , '102', '122' ).

  CONSTANTS : C_TCURR TYPE CHAR3 VALUE 'INR'.
  SELECT KURST
         FCURR
         TCURR
         GDATU
         UKURS
    FROM TCURR
    INTO TABLE IT_TCURR
    WHERE KURST = C_KURST"'B'
    AND   TCURR = C_TCURR."'INR'.

  SORT IT_TCURR BY GDATU ASCENDING.
  DATA LV_GDATU TYPE CHAR11.
  LOOP AT IT_TCURR INTO WA_TCURR.

    CALL FUNCTION 'CONVERSION_EXIT_INVDT_OUTPUT'
      EXPORTING
        INPUT  = WA_TCURR-GDATU
      IMPORTING
        OUTPUT = LV_GDATU.

    WA_TCURR-GDATU = LV_GDATU.
    MODIFY IT_TCURR FROM WA_TCURR  TRANSPORTING GDATU.

  ENDLOOP.
*  BREAK primusabap.

  IF IT_DATA1[] IS NOT INITIAL.
*    BREAK primusabap.
    SELECT AUFNR
           LOEKZ
      FROM AUFK
      INTO TABLE IT_AUFK1
      FOR ALL ENTRIES IN IT_DATA1
      WHERE AUFNR = IT_DATA1-AUFNR.

    SELECT BUDAT
           AUFNR
           STOKZ
           STZHL
     FROM AFRU
    INTO TABLE IT_AFRU
    FOR ALL ENTRIES IN IT_DATA1
    WHERE AUFNR = IT_DATA1-AUFNR
      AND STOKZ NE 'X'
      AND STZHL EQ ''.

    SELECT PRUEFLOS
           WERK
           AUFNR
           KDAUF
           KDPOS
           LMENGEZUB
           FROM QALS
           INTO TABLE IT_QALS
           FOR ALL ENTRIES IN IT_DATA1
           WHERE AUFNR = IT_DATA1-AUFNR
           AND KDAUF = IT_DATA1-VBELN
           AND KDPOS = IT_DATA1-POSNR.


************sals order line item wise data
    SELECT VBELN
           POSNR
           MATNR
           MATKL
           KWMENG
           VGBEL
           VGPOS
           WERKS
           ABGRU
    FROM VBAP
    INTO CORRESPONDING FIELDS OF TABLE IT_VBAP
    FOR ALL ENTRIES IN IT_DATA1
    WHERE VBELN = IT_DATA1-VBELN
      AND POSNR = IT_DATA1-POSNR
      AND WERKS = P_WERKS."'PL01'.

**************prodoution oreder qunatity

    SELECT AUFNR
         POSNR
         KDAUF
         KDPOS
         MATNR
         PGMNG
         PSMNG
         WEMNG
    FROM AFPO
    INTO TABLE IT_AFPO
    FOR ALL ENTRIES IN IT_DATA1
    WHERE AUFNR = IT_DATA1-AUFNR.
    IF IT_AFPO IS NOT INITIAL.
*******************confirmsation date
      SELECT MBLNR
             BUDAT
             WERKS
             AUFNR
             LGORT
             KDAUF
             KDPOS
             BWART
             SHKZG
             MENGE
       FROM AUFM
       INTO TABLE IT_AUFM
       FOR ALL ENTRIES IN IT_AFPO
        WHERE AUFNR = IT_AFPO-AUFNR
        AND   KDAUF = IT_AFPO-KDAUF
        AND   KDPOS = IT_AFPO-KDPOS.


      SELECT AUFNR
             OBJNR
             KDAUF
             KDPOS
             IGMNG
        FROM CAUFV
        INTO TABLE IT_CAUFV
        FOR ALL ENTRIES IN IT_AFPO
        WHERE AUFNR = IT_AFPO-AUFNR
        AND   KDAUF = IT_AFPO-KDAUF
        AND   KDPOS = IT_AFPO-KDPOS
        AND   LOEKZ = SPACE.

    ENDIF.

  ENDIF.

  IF IT_VBAP IS NOT INITIAL.
***********mannual updated data
    SELECT VBELN
           POSNR
           MATNR
           ZRACK_LOC
           ZMAT_REMARK
           ZFG_WEIGHT
           ZPROD_PLAN_NEW
           ZPROD_QTY
           EBELN
           AUFNR
       FROM ZFG_RACK
      INTO TABLE IT_RACK
      FOR ALL ENTRIES IN IT_VBAP
      WHERE VBELN = IT_VBAP-VBELN.

    SELECT
           MATNR
           ZFG_WEIGHT
       FROM ZFG_RACK_WEIGHT
       INTO TABLE IT_RACK_WEIGHT
       FOR ALL ENTRIES IN IT_DATA1
       WHERE MATNR = IT_DATA1-MATNR.

    SELECT
         VBELN
         POSNR
         ZPROD_QTY
     FROM ZFG_RACK_PLANQTY
     INTO TABLE IT_RACK_PLANQTY
     FOR ALL ENTRIES IN IT_VBAP
    WHERE VBELN = IT_VBAP-VBELN
      AND POSNR = IT_VBAP-POSNR.

    SELECT VBELN
           ERDAT
           AUDAT
           AUART
           NETWR
           WAERK
           KUNNR
           KNUMV
           VKBUR
    FROM VBAK
    INTO TABLE IT_VBAK
    FOR ALL ENTRIES IN IT_VBAP
    WHERE VBELN = IT_VBAP-VBELN.

    SELECT VBELN
          POSNR
          PARVW
          KUNNR
          ADRNR
          LAND1
          FROM VBPA INTO TABLE IT_VBPA
          FOR ALL ENTRIES IN IT_VBAP
          WHERE VBELN = IT_VBAP-VBELN.

    SELECT KUNNR
           NAME1
      FROM KNA1
      INTO TABLE IT_KNA1_NEW
      FOR ALL ENTRIES IN IT_VBPA
      WHERE KUNNR = IT_VBPA-KUNNR.

    SELECT MATNR
            WERKS
            LGORT
            VBELN
            POSNR
            KALAB
            KAINS
            FROM MSKA INTO TABLE IT_MSKA
            FOR ALL ENTRIES IN IT_VBAP
            WHERE VBELN = IT_VBAP-VBELN
              AND POSNR = IT_VBAP-POSNR
              AND MATNR = IT_VBAP-MATNR
              AND WERKS = P_WERKS
             AND SOBKZ = C_SOBKZ.
*             AND kains NE 0
*             AND KALAB NE 0." 'PL01'.

    SELECT MATNR
           WERKS
           LGORT
           LABST
           INSME
           DISKZ FROM MARD INTO TABLE IT_MARD
            FOR ALL ENTRIES IN IT_VBAP
            WHERE MATNR = IT_VBAP-MATNR
            AND WERKS = P_WERKS
            AND DISKZ = C_DISKZ
            AND LGORT IN ( 'FG01', 'TPI1', 'KFG0', 'KTPI' ).

**************** Reject Service Sale Order Remove From Pending So
    LOOP AT IT_VBAK INTO WA_VBAK WHERE AUART = 'ZESS' OR AUART = 'ZSER'.
      LOOP AT IT_VBAP INTO WA_VBAP WHERE VBELN = WA_VBAK-VBELN AND ABGRU NE ' '.
        DELETE IT_VBAP WHERE VBELN = WA_VBAP-VBELN AND POSNR = WA_VBAP-POSNR.
      ENDLOOP.
    ENDLOOP.
**************************************************************************
    IF IT_VBAK IS NOT INITIAL.

      SELECT KUNNR
         NAME1
         ADRNR
         FROM KNA1 INTO TABLE IT_KNA1
         FOR ALL ENTRIES IN IT_VBAK
         WHERE KUNNR = IT_VBAK-KUNNR.


      SELECT VBELV
            POSNV
            VBELN
            VBTYP_N
            FROM VBFA INTO TABLE IT_VBFA
            FOR ALL ENTRIES IN IT_VBAK
            WHERE VBELV = IT_VBAK-VBELN
              AND ( VBTYP_N = C_VBTYP_N OR  VBTYP_N = C_VBTYP_N1 ).

      SELECT KNUMV
             KPOSN
             KSCHL
             KBETR
             WAERS
             KWERT
             FROM PRCD_ELEMENTS INTO TABLE IT_KONV1
             FOR ALL ENTRIES IN IT_VBAK
             WHERE KNUMV = IT_VBAK-KNUMV.

    ENDIF.
    IF IT_VBPA IS NOT INITIAL.
      SELECT * FROM ADRC
        INTO TABLE IT_ADRC
        FOR ALL ENTRIES IN IT_VBPA
        WHERE ADDRNUMBER = IT_VBPA-ADRNR." AND country = 'IN'.

    ENDIF.

    IF IT_VBFA IS NOT INITIAL.
      SELECT VBELN
             FKART
             FKTYP
             VKORG
             VTWEG
             FKDAT
             FKSTO
             FROM VBRK INTO TABLE IT_VBRK
             FOR ALL ENTRIES IN IT_VBFA
             WHERE VBELN = IT_VBFA-VBELN
               AND FKSTO NE C_FKSTO.
    ENDIF.

    IF IT_VBRK IS NOT INITIAL.
      SELECT VBELN
             POSNR
             FKIMG
             AUBEL
             AUPOS
             MATNR
             WERKS
             FROM VBRP INTO TABLE IT_VBRP
             FOR ALL ENTRIES IN IT_VBRK
             WHERE VBELN = IT_VBRK-VBELN.
    ENDIF.

    SELECT MATNR
           NTGEW
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE
           WRKST
    FROM MARA
    INTO TABLE IT_MARA
    FOR ALL ENTRIES IN IT_VBAP
    WHERE MATNR = IT_VBAP-MATNR.

    SELECT VBELN
           POSNR
           INCO1
           INCO2
           ZTERM
           KTGRD
           KURSK
           BSTKD
           PRSDT
           FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VBAP
           WHERE VBELN = IT_VBAP-VBELN.

    IF IT_VBKD IS NOT INITIAL.
      SELECT SPRAS
             ZTERM
             TEXT1
             FROM T052U INTO TABLE IT_T052U
             FOR ALL ENTRIES IN IT_VBKD
             WHERE SPRAS = C_SPRAS"'EN'
             AND ZTERM = IT_VBKD-ZTERM.
    ENDIF.




  ENDIF.

ENDFORM.                    " FILL_TABLES

*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM PROCESS_FOR_OUTPUT .

  SORT IT_VBAP BY VBELN POSNR MATNR WERKS.
*  BREAK primusabap.

  LOOP AT IT_DATA1 INTO WA_DATA1 .

    READ TABLE IT_AUFK1 INTO WA_AUFK1 WITH KEY AUFNR = WA_DATA1-AUFNR.
    IF SY-SUBRC = 0 ."AND wa_aufk1-loekz NE 'X'.
      WA_FINAL-AUFNR = WA_DATA1-AUFNR.
      WA_FINAL-WEMNG = WA_DATA1-WEMNG.
      WA_FINAL-PSMNG = WA_DATA1-PSMNG.
      WA_FINAL-LOEKZ = WA_AUFK1-LOEKZ.
    ENDIF.

    READ TABLE IT_AUFM INTO WA_AUFM WITH KEY AUFNR = WA_FINAL-AUFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-MENGE = WA_AUFM-MENGE.
    ENDIF.

    WA_FINAL-EBELN = WA_DATA1-EBELN.
    WA_FINAL-EBELP = WA_DATA1-EBELP.
    WA_FINAL-MENGE2 = WA_DATA1-MENGE.

    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_DATA1-VBELN POSNR = WA_DATA1-POSNR.
*  LOOP AT it_vbap INTO wa_vbap.
    WA_FINAL-VBELN = WA_VBAP-VBELN.
    WA_FINAL-POSNR = WA_VBAP-POSNR.
    WA_FINAL-MATNR = WA_VBAP-MATNR.
    WA_FINAL-KWMENG = WA_VBAP-KWMENG.
    READ TABLE IT_RACK INTO WA_RACK WITH KEY VBELN = WA_VBAP-VBELN
                                             POSNR = WA_VBAP-POSNR
                                             EBELN =  WA_FINAL-EBELN
                                             AUFNR  = WA_FINAL-AUFNR .
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-ZRACK_LOC   = WA_RACK-ZRACK_LOC.
      WA_FINAL-ZMAT_REMARK = WA_RACK-ZMAT_REMARK.
      WA_FINAL-ZPROD_PLAN = WA_RACK-ZPROD_PLAN_NEW.
*      wa_final-zprod_qty =  wa_rack-zprod_qty.
    ENDIF.

    READ TABLE IT_RACK_PLANQTY INTO WA_RACK_PLANQTY WITH KEY VBELN = WA_VBAP-VBELN
                                             POSNR = WA_VBAP-POSNR.

    IF SY-SUBRC IS INITIAL.
      WA_FINAL-ZPROD_QTY =  WA_RACK_PLANQTY-ZPROD_QTY.
    ENDIF.

*    IF wa_final-ebeln IS NOT INITIAL.
    READ TABLE IT_RACK_WEIGHT INTO WA_RACK_WEIGHT WITH KEY MATNR = WA_FINAL-MATNR.
*                                               vbeln = wa_vbap-vbeln
*                                               posnr = wa_vbap-posnr.
*                                               ebeln =  wa_final-ebeln.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-ZFG_WEIGHT = WA_RACK_WEIGHT-ZFG_WEIGHT.
    ENDIF.
*    ENDIF.
*    IF wa_final-aufnr IS NOT INITIAL.
*      READ TABLE it_rack INTO wa_rack WITH KEY matnr = wa_final-matnr
*                                               aufnr =  wa_final-aufnr.
*      IF sy-subrc IS INITIAL.
*        wa_final-zfg_weight = wa_rack-zfg_weight.
*      ENDIF.
*    ENDIF.

*    BREAK primusabap.
    LOOP AT IT_EKBE INTO WA_EKBE WHERE EBELN = WA_FINAL-EBELN AND  EBELP = WA_FINAL-EBELP AND MATNR = WA_FINAL-MATNR.
      IF WA_EKBE-BWART = '101'.
        WA_FINAL-MENGE_101 = WA_FINAL-MENGE_101 + WA_EKBE-MENGE.
      ELSEIF WA_EKBE-BWART = '102'.
        WA_FINAL-MENGE_102 = WA_FINAL-MENGE_102 + WA_EKBE-MENGE.
      ELSEIF WA_EKBE-BWART = '122'.
        WA_FINAL-MENGE_122 = WA_FINAL-MENGE_122 + WA_EKBE-MENGE.
      ENDIF.
    ENDLOOP.

    IF WA_FINAL-EBELN IS NOT INITIAL.
      WA_FINAL-MENGE1 = WA_FINAL-MENGE_101 - WA_FINAL-MENGE_102 - WA_FINAL-MENGE_122.
    ENDIF.


*    BREAK primusabap.
    READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_VBAP-VBELN.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-KUNNR = WA_VBAK-KUNNR.
      WA_FINAL-VKBUR = WA_VBAK-VKBUR.
      WA_FINAL-AUART = WA_VBAK-AUART.
    ENDIF.

    READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZPR0'  KPOSN = WA_VBAP-POSNR.
    WA_FINAL-KBETR       = WA_KONV1-KBETR.

    READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBAK-KUNNR.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-NAME1       = WA_KNA1-NAME1.           "Cust Name
    ENDIF.

*    READ TABLE it_data1 INTO wa_data1 WITH KEY vbeln = wa_vbap-vbeln posnr = wa_vbap-posnr.     """Added by Pranit 10.06.2024
*    IF sy-subrc IS INITIAL.
*      wa_final-lgort = wa_data-lgort.
*    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_VBAP-MATNR.
    IF SY-SUBRC IS INITIAL.
      IF  WA_FINAL-NTGEW IS INITIAL.
        WA_FINAL-NTGEW = WA_MARA-NTGEW.
      ENDIF.
      WA_FINAL-ZSIZE = WA_MARA-ZSIZE.
      WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
      WA_FINAL-WRKST = WA_MARA-WRKST.
    ENDIF.

***    *Material text
    CLEAR: LV_LINES, LS_MATTXT.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.
    IF LV_NAME IS NOT INITIAL.
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
    ENDIF.
    READ TABLE LV_LINES INTO LS_MATTXT INDEX 1.
    WA_FINAL-MATTXT = LS_MATTXT-TDLINE.


    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_FINAL-VBELN.
    IF SY-SUBRC IS INITIAL.
*      wa_final-so_exc      = wa_vbkd-kursk.
      WA_FINAL-INCO1       = WA_VBKD-INCO1.           "inco terms
      WA_FINAL-INCO2       = WA_VBKD-INCO2.           "inco terms description
      WA_FINAL-BSTKD       = WA_VBKD-BSTKD.           "PO Number
    ENDIF.

*************USA CUSTOMER CODE
    CLEAR :LV_LINES,LS_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    IF LV_NAME  IS NOT INITIAL .
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'ZZ90'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
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
* Implement suitable error handling here
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_FINAL-US_CUST LS_LINES-TDLINE INTO WA_FINAL-US_CUST SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

*DELIVARY QTY
    DATA : WA_LFIMG     TYPE LIPS-LFIMG,
           WA_LFIMG_SUM TYPE LIPS-LFIMG.
    CLEAR: WA_VBFA, WA_LFIMG, WA_LFIMG_SUM.
    LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_FINAL-VBELN
                                   AND POSNV = WA_FINAL-POSNR
                                   AND VBTYP_N = C_VBTYP_N."'J'.

      CLEAR WA_LFIMG.
      SELECT SINGLE LFIMG FROM LIPS INTO  WA_LFIMG  WHERE VBELN = WA_VBFA-VBELN
                                                    AND   PSTYV = 'ZTAN'
                                                    AND   VGBEL = WA_FINAL-VBELN
                                                    AND   VGPOS = WA_FINAL-POSNR.
      WA_LFIMG_SUM = WA_LFIMG_SUM + WA_LFIMG .

    ENDLOOP.


*INVOICE QTY


    DATA : WA_FKIMG     TYPE VBRP-FKIMG,
           WA_FKIMG_SUM TYPE VBRP-FKIMG.

    CLEAR: WA_VBFA, WA_FKIMG, WA_FKIMG_SUM.
    LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_FINAL-VBELN
                                   AND POSNV = WA_FINAL-POSNR
                                   AND VBTYP_N = C_VBTYP_N1."'M'.

      CLEAR WA_VBRK.
      READ TABLE IT_VBRK INTO WA_VBRK WITH KEY   VBELN = WA_VBFA-VBELN.

      CLEAR WA_FKIMG.
      SELECT SINGLE FKIMG FROM VBRP INTO  WA_FKIMG  WHERE VBELN = WA_VBRK-VBELN
                                                    AND   AUBEL = WA_FINAL-VBELN
                                                    AND   AUPOS = WA_FINAL-POSNR.
      WA_FKIMG_SUM = WA_FKIMG_SUM + WA_FKIMG .
    ENDLOOP.

*currency conversion
    REFRESH LS_FR_CURR.
    CLEAR LS_FR_CURR.
    LS_FR_CURR-SIGN   = 'I'.
    LS_FR_CURR-OPTION = 'EQ'.
    LS_FR_CURR-LOW = WA_VBAK-WAERK.
    APPEND LS_FR_CURR.
    CLEAR: LS_EX_RATE,LV_EX_RATE, LS_RETURN.
    REFRESH: LS_EX_RATE, LS_RETURN.
    IF LS_TO_CURR-LOW <> LS_FR_CURR-LOW.

      CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
        EXPORTING
          DATE             = SY-DATUM
          DATE_TYPE        = 'V'
          RATE_TYPE        = 'B'
        TABLES
          FROM_CURR_RANGE  = LS_FR_CURR
          TO_CURRNCY_RANGE = LS_TO_CURR
          EXCH_RATE_LIST   = LS_EX_RATE
          RETURN           = LS_RETURN.

      CLEAR LV_EX_RATE.
      READ TABLE LS_EX_RATE INTO LV_EX_RATE INDEX 1.
    ELSE.
      LV_EX_RATE-EXCH_RATE = 1.
    ENDIF.

*    wa_final-curr_con     = lv_ex_rate-exch_rate.    "Currency conversion


*    wa_final-lfimg       = wa_lfimg_sum.                "del qty
    WA_FINAL-FKIMG       = WA_FKIMG_SUM.                "inv qty
    WA_FINAL-PND_QTY     = WA_FINAL-KWMENG - WA_FINAL-FKIMG.  "Pending Qty

    IF LV_EX_RATE-EXCH_RATE IS NOT INITIAL.
      WA_FINAL-AMONT       = WA_FINAL-PND_QTY * WA_FINAL-KBETR *
                              LV_EX_RATE-EXCH_RATE.    "Amount
    ELSEIF LV_EX_RATE-EXCH_RATE IS INITIAL.
      WA_FINAL-AMONT       = WA_FINAL-PND_QTY * WA_FINAL-KBETR .
    ENDIF.


**TPI TEXT

    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CONSTANTS : C_TPI_ID     TYPE THEAD-TDID VALUE 'Z999',
                C_TPI_LANG   TYPE THEAD-TDSPRAS VALUE 'E',
                C_TPI_OBJECT TYPE THEAD-TDOBJECT VALUE 'VBBK'.

    IF LV_NAME  IS NOT INITIAL .
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = C_TPI_ID
          LANGUAGE                = C_TPI_LANG
          NAME                    = LV_NAME
          OBJECT                  = C_TPI_OBJECT
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
    ENDIF.
    READ TABLE LV_LINES INTO WA_LINES INDEX 1.

    CLEAR WA_TEXT1.
    WA_TEXT1 = WA_LINES-TDLINE(50).
    TRANSLATE WA_TEXT1 TO UPPER CASE .
    WA_FINAL-TPI         = WA_TEXT1.     "TPI Required
*********unresteicted stock qty
*    BREAK PRIMUSABAP.
    LOOP AT IT_MARD INTO WA_MARD WHERE MATNR = WA_FINAL-MATNR.

      IF WA_MARD-LABST IS NOT INITIAL.
        WA_FINAL-STOCK_QTY1 = WA_FINAL-STOCK_QTY1 + WA_MARD-LABST.
        IF WA_MARD-LGORT = 'FG01' .
          DATA(GV_FG01) = WA_MARD-LGORT.
          CONCATENATE GV_FG01 WA_FINAL-LGORT1 INTO WA_FINAL-LGORT1 SEPARATED BY ' '.
        ENDIF.
        IF WA_MARD-LGORT = 'TPI1'.
          DATA(GV_TPI1) = WA_MARD-LGORT.
          CONCATENATE WA_FINAL-LGORT1 GV_TPI1 INTO WA_FINAL-LGORT1 SEPARATED BY ','.
        ENDIF.
        IF WA_MARD-LGORT = 'KFG0'.
          DATA(GV_KFG0) = WA_MARD-LGORT.
          CONCATENATE WA_FINAL-LGORT1 GV_KFG0 INTO WA_FINAL-LGORT1 SEPARATED BY ','.
        ENDIF.
        IF WA_MARD-LGORT ='KTPI'.
          DATA(GV_KTPI) = WA_MARD-LGORT.
          CONCATENATE WA_FINAL-LGORT1 GV_KTPI INTO WA_FINAL-LGORT1 SEPARATED BY ','.
        ENDIF.

      ENDIF.

    ENDLOOP.
    IF WA_FINAL-LGORT1 IS NOT INITIAL.
      DATA(LV_STR) = STRLEN( WA_FINAL-LGORT1 ).
      DATA(LV_COUNT) = LV_STR - 1.
      IF WA_FINAL-LGORT1+0(1) = ','.
        WA_FINAL-LGORT1+0(1) = ' '.
      ENDIF.
    ENDIF.

    LOOP AT IT_MSKA INTO WA_MSKA WHERE VBELN = WA_FINAL-VBELN AND
                                        POSNR = WA_FINAL-POSNR AND
                                        MATNR = WA_FINAL-MATNR AND
                                        WERKS = C_PLANT.

      CASE WA_MSKA-LGORT.
        WHEN 'FG01'.
*          data(gv_fg01) = wa_mska-lgort.
*           CONCATENATE gv_fg01 wa_final-lgort INTO wa_final-lgort SEPARATED BY ' '.
*          wa_final-lgort = wa_mska-lgort.
          WA_FINAL-STOCK_QTY = WA_FINAL-STOCK_QTY + WA_MSKA-KALAB.
        WHEN 'TPI1'.
*         data(gv_TPI1) = wa_mska-lgort.
*         CONCATENATE wa_final-lgort gv_TPI1 INTO wa_final-lgort SEPARATED BY ' '.
*          wa_final-lgort = wa_mska-lgort.
          WA_FINAL-STOCK_QTY = WA_FINAL-STOCK_QTY + WA_MSKA-KALAB.
*        WHEN 'PRD1'.
**          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'RM01'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'RWK1'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'SC01'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'SFG1'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'SPC1'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'SRN1'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'VLD1'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'SLR1'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
        WHEN 'KFG0'.
*          data(gv_kfg0) = wa_mska-lgort.
*           CONCATENATE wa_final-lgort gv_kfg0 INTO wa_final-lgort SEPARATED BY ' '.
*          wa_final-lgort = wa_mska-lgort.
          WA_FINAL-STOCK_QTY = WA_FINAL-STOCK_QTY + WA_MSKA-KALAB.
*        WHEN 'KMCN'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KNDT'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KPLG'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KPR1'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KPRD'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KRJ0'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KRM0'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KRWK'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KSC0'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KSCR'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KSFG'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KSLR'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KSPC'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
*        WHEN 'KSRN'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
        WHEN 'KTPI'.
*          data(gv_KTPI) = wa_mska-lgort.
*         CONCATENATE wa_final-lgort gv_KTPI INTO wa_final-lgort SEPARATED BY ' '.
*          wa_final-lgort = wa_mska-lgort.
          WA_FINAL-STOCK_QTY = WA_FINAL-STOCK_QTY + WA_MSKA-KALAB.
*        WHEN 'KVLD'.
*          wa_final-stock_qty = wa_final-stock_qty + wa_mska-kalab.
      ENDCASE.
      IF SY-SUBRC = 0.

      ENDIF.
    ENDLOOP.
    """"""""""""QM Quantity
    DATA LV_QMQTY TYPE MSKA-KAINS.
    CLEAR LV_QMQTY.
*
*    loop at it_qals INTO wa_qals where aufnr = wa_final-aufnr.""kdauf = wa_vbap-vbeln
*                                " and   kdpos = wa_vbap-posnr
*                                 "and   aufnr = wa_data1-aufnr.
*         LV_QMQTY =  wa_qals-lmengezub + lv_qmqty.
*    endloop.
*   wa_final-qmqty = lv_qmqty.

    READ TABLE IT_MSKA INTO WA_MSKA WITH KEY VBELN = WA_VBAP-VBELN
                                             POSNR = WA_VBAP-POSNR
                                             MATNR = WA_VBAP-MATNR.
*                                               WERKS = WA_VBAP-WERKS.
    IF SY-SUBRC IS INITIAL.
      LV_INDEX = SY-TABIX.
      LOOP AT IT_MSKA INTO WA_MSKA FROM LV_INDEX.
        IF WA_MSKA-VBELN = WA_VBAP-VBELN AND WA_MSKA-POSNR = WA_VBAP-POSNR
         AND WA_MSKA-MATNR = WA_VBAP-MATNR AND WA_MSKA-WERKS = WA_VBAP-WERKS.
*            LV_QMQTY = WA_MSKA-KAINS - LV_QMQTY.
          LV_QMQTY = WA_MSKA-KAINS + LV_QMQTY.
        ELSE.
          CLEAR LV_INDEX.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

    WA_FINAL-QMQTY = LV_QMQTY.

    REFRESH : IT_JEST2 , IT_JEST2[] .
    CLEAR : WA_AFPO , WA_CAUFV.

    LOOP AT IT_AFPO INTO WA_AFPO WHERE KDAUF = WA_VBAP-VBELN
                                   AND KDPOS = WA_VBAP-POSNR
                                   AND MATNR = WA_VBAP-MATNR
                                   AND AUFNR = WA_DATA1-AUFNR.

      READ TABLE IT_CAUFV INTO WA_CAUFV WITH KEY AUFNR = WA_AFPO-AUFNR
                                                 KDAUF = WA_AFPO-KDAUF
                                                 KDPOS = WA_AFPO-KDPOS.
      IF SY-SUBRC = 0.
        SELECT OBJNR STAT FROM JEST INTO TABLE IT_JEST2
                              WHERE OBJNR = WA_CAUFV-OBJNR
                                AND INACT = ' '.

        CLEAR WA_JEST2 .
        READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0012' BINARY SEARCH .
        IF SY-SUBRC NE 0.
          CLEAR WA_JEST2 .
          READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0009' BINARY SEARCH .
          IF SY-SUBRC NE 0.
            CLEAR WA_JEST2 .
            READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0002' BINARY SEARCH .
            IF SY-SUBRC = 0.
              WA_FINAL-WIP = WA_FINAL-WIP + WA_AFPO-PSMNG - WA_CAUFV-IGMNG ."wa_afpo-pgmng
            ENDIF.
          ENDIF.
        ENDIF.


      ENDIF.

    ENDLOOP.

    IF WA_FINAL-AUFNR IS NOT INITIAL.
      READ TABLE IT_MSEG INTO WA_MSEG WITH KEY AUFNR = WA_FINAL-AUFNR .
      IF SY-SUBRC = 0.
        WA_FINAL-LGORT      =   WA_MSEG-LGORT.
        WA_FINAL-BUDAT_MKPF =   WA_MSEG-BUDAT_MKPF.
      ENDIF.
    ELSEIF WA_FINAL-EBELN IS NOT INITIAL.
      READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY EBELN = WA_FINAL-EBELN
                                                 EBELP = WA_FINAL-EBELP
                                                 MATNR = WA_FINAL-MATNR
                                                 BWART = '321'.
      IF SY-SUBRC IS INITIAL.
        WA_FINAL-LGORT =   WA_MSEG1-LGORT.
        WA_FINAL-BUDAT_MKPF =   WA_MSEG1-BUDAT_MKPF.
      ENDIF.
      IF WA_FINAL-LGORT IS INITIAL.
        READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY EBELN = WA_FINAL-EBELN
                                                   BWART = '101'.
        IF SY-SUBRC IS INITIAL.
          WA_FINAL-LGORT =   WA_MSEG1-LGORT.
        ENDIF.
      ENDIF  .

    ENDIF.

    READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY EBELN = WA_FINAL-EBELN
                                                  EBELP = WA_FINAL-EBELP
                                                  MATNR = WA_FINAL-MATNR
                                                  BWART = '101'.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-GRN_DATE =   WA_MSEG1-BUDAT_MKPF.
    ENDIF.


**************commented by jyotion requested by shahid fro confirmation date
    READ TABLE IT_AUFM INTO WA_AUFM WITH KEY   KDAUF = WA_FINAL-VBELN
                                               KDPOS = WA_FINAL-POSNR
                                               AUFNR = WA_FINAL-AUFNR
                                               BWART = '321'
                                               SHKZG = 'S'.
*
    IF SY-SUBRC IS INITIAL.
**      wa_final-aufnr = wa_aufm-aufnr.
**      IF line_exists( it_aufm[ kdauf = wa_final-vbeln kdpos = wa_final-posnr aufnr = wa_final-aufnr bwart = 102 ] ) .   """logic added by pranit
**        DATA(lv_budat) = it_aufm[ kdauf = wa_final-vbeln kdpos = wa_final-posnr aufnr = wa_final-aufnr bwart = 102 ]-budat.
**      ENDIF.
*       IF line_exists( it_aufm[ kdauf = wa_final-vbeln kdpos = wa_final-posnr aufnr = wa_final-aufnr bwart = 101 ] ) .   """logic added by pranit
*        DATA(lv_budat) = it_aufm[ kdauf = wa_final-vbeln kdpos = wa_final-posnr aufnr = wa_final-aufnr bwart = 101 ]-budat.
*      ENDIF.
*      IF lv_budat IS INITIAL.
*        wa_final-budat = wa_aufm-budat.
*      ENDIF.

*      wa_final-lgort = wa_aufm-lgort.
    ENDIF.
**************Added by jyoti on 22.01.2024 requested by shahid attar**********************
    SORT IT_AFRU[] DESCENDING.
    READ TABLE IT_AFRU INTO WA_AFRU WITH KEY AUFNR = WA_FINAL-AUFNR.
    IF SY-SUBRC IS INITIAL.
*    if wa_Afru-stzhl = '00000000'.
*      wa_Afru-stzhl = ' '.
*    endif.
*     if wa_afru-stokz IS INITIAL and wa_Afru-stzhl is INITIAL."wa_Afru-stzhl = '00000000'.
      WA_FINAL-BUDAT = WA_AFRU-BUDAT.
*   endif.
    ENDIF.
***************************************************************************************
*
*    READ TABLE it_aufm INTO DATA(wa_aufm1) WITH KEY   kdauf = wa_data1-vbeln
*                                               kdpos = wa_data1-posnr
*                                              aufnr = wa_data1-aufnr
*                                               BWART = '321'
*                                               SHKZG = 'S'.
*     IF sy-subrc IS INITIAL.
*       if  wa_aufm1-lgort = 'FG01' or wa_aufm1-lgort = 'TPI1' or wa_aufm1-lgort = 'KFG0'
*         or wa_aufm1-lgort = 'KTPI' .
*         wa_final-lgort = wa_aufm1-lgort.
*       endif.
*      ENDIF.
*      IF  wa_final-lgort IS INITIAL.
*      READ TABLE it_aufm INTO wa_aufm1 WITH KEY   kdauf = wa_data1-vbeln
*                                               kdpos = wa_data1-posnr
*                                              aufnr = wa_data1-aufnr
*                                               BWART = '101'
*                                               SHKZG = 'S'.
*     IF sy-subrc IS INITIAL.
*        if  wa_aufm1-lgort = 'FG01' or wa_aufm1-lgort = 'TPI1' or wa_aufm1-lgort = 'KFG0'
*         or wa_aufm1-lgort = 'KTPI' .
*         wa_final-lgort = wa_aufm1-lgort.
*         endif.
*      ENDIF.
*      ENDIF.
*    IF wa_final-lgort = ' '.
*      CLEAR : wa_final-stock_qty, wa_final-qmqty.
*    ENDIF.
    """ Ship to party logic

    READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_VBAP-VBELN POSNR = WA_VBAP-POSNR PARVW = 'WE'.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-SHIP_KUNNR = WA_VBPA-KUNNR.
    ELSE.
      READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_VBAP-VBELN POSNR = ' ' PARVW = 'WE'.
      WA_FINAL-SHIP_KUNNR = WA_VBPA-KUNNR.
    ENDIF.

    READ TABLE IT_KNA1_NEW INTO WA_KNA1_NEW WITH KEY KUNNR = WA_FINAL-SHIP_KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-SHIP_KUNNR_NAME = WA_KNA1_NEW-NAME1.
    ENDIF.

    READ TABLE IT_ADRC INTO WA_ADRC WITH KEY ADDRNUMBER = WA_VBPA-ADRNR.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-SHIP_KUNNR_N = WA_ADRC-NAME1.
    ENDIF.

    IF WA_FINAL-AUART = 'ZDEX' OR WA_FINAL-AUART = 'ZERO' OR WA_FINAL-AUART = 'ZESP' OR WA_FINAL-AUART = 'ZESS' OR WA_FINAL-AUART = 'ZFER'
      OR WA_FINAL-AUART = 'ZFEX' OR  WA_FINAL-AUART ='ZEXP'.
      READ TABLE IT_TCURR INTO WA_TCURR WITH KEY FCURR = WA_VBAK-WAERK.
      IF SY-SUBRC = 0.
        WA_FINAL-SO_EXC = WA_TCURR-UKURS.
      ENDIF.
    ELSE.
      READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_FINAL-VBELN.
      IF SY-SUBRC IS INITIAL.
        WA_FINAL-SO_EXC      = WA_VBKD-KURSK.
      ENDIF.
    ENDIF.

    LOOP AT IT_MSEG INTO WA_MSEG WHERE AUFNR = WA_FINAL-AUFNR.
      WA_FINAL-MENGE_MSEG = WA_FINAL-MENGE_MSEG + WA_MSEG-MENGE.
    ENDLOOP.

    LOOP AT IT_MSEG1 INTO WA_MSEG1 WHERE EBELN = WA_FINAL-EBELN AND EBELP = WA_FINAL-EBELP AND MATNR = WA_FINAL-MATNR AND  BWART = '321'.
      WA_FINAL-MENGE_MSEG = WA_FINAL-MENGE_MSEG + WA_MSEG1-MENGE.
    ENDLOOP.

    IF LINE_EXISTS( IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'FG01' ] ) .
      WA_FINAL-FG01 = IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'FG01' ]-KALAB.
    ENDIF.

    IF LINE_EXISTS( IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'TPI1' ] ) .
      WA_FINAL-TPI1 = IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'TPI1' ]-KALAB.
    ENDIF.

    IF LINE_EXISTS( IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'KFG0' ] ) .
      WA_FINAL-KFG0 = IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'KFG0' ]-KALAB.
    ENDIF.

    IF LINE_EXISTS( IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'KTPI' ] ) .
      WA_FINAL-KTPI = IT_MSKA[ VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR LGORT = 'KTPI' ]-KALAB.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR :WA_FINAL,WA_VBAK-WAERK,WA_RACK_PLANQTY .

  ENDLOOP.
  SORT IT_FINAL.
  DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING ALL FIELDS.
*  DELETE it_final WHERE aufnr IS INITIAL.
  SORT IT_FINAL BY VBELN POSNR AUFNR.

*  DELETE it_final WHERE loekz EQ 'X'.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-VBELN         =               WA_FINAL-VBELN       .
      WA_DOWN-POSNR         =               WA_FINAL-POSNR       .
*      wa_down-kunnr         =               wa_final-kunnr       .
      WA_DOWN-NAME1         =               WA_FINAL-NAME1       .
      WA_DOWN-MATNR         =               WA_FINAL-MATNR       .
      WA_DOWN-MATTXT        =               WA_FINAL-MATTXT      .
      WA_DOWN-KWMENG        =               WA_FINAL-KWMENG      .
      WA_DOWN-BSTKD        =               WA_FINAL-BSTKD      .
      WA_DOWN-VKBUR        =               WA_FINAL-VKBUR      .
      WA_DOWN-WRKST        =               WA_FINAL-WRKST      .

      CONDENSE WA_DOWN-KWMENG .
      IF WA_FINAL-KWMENG < 0.
        CONCATENATE '-' WA_DOWN-KWMENG INTO WA_DOWN-KWMENG.
      ENDIF.
      WA_DOWN-FKIMG         =               WA_FINAL-FKIMG       .
      CONDENSE WA_DOWN-FKIMG .
      IF WA_FINAL-FKIMG  < 0.
        CONCATENATE '-' WA_DOWN-FKIMG INTO WA_DOWN-FKIMG.
      ENDIF.
      WA_DOWN-PND_QTY       =               WA_FINAL-PND_QTY     .
      CONDENSE  WA_DOWN-PND_QTY .
      IF WA_FINAL-FKIMG  < 0.
        CONCATENATE '-' WA_DOWN-PND_QTY INTO WA_DOWN-PND_QTY .
      ENDIF.
      WA_DOWN-WIP           =               WA_FINAL-WIP         .
      CONDENSE WA_DOWN-WIP .
      IF WA_FINAL-WIP  < 0.
        CONCATENATE '-'  WA_DOWN-WIP INTO  WA_DOWN-WIP .
      ENDIF.
      WA_DOWN-STOCK_QTY     =               WA_FINAL-STOCK_QTY   .
      CONDENSE WA_DOWN-STOCK_QTY .
      IF WA_FINAL-STOCK_QTY  < 0.
        CONCATENATE '-'  WA_DOWN-STOCK_QTY  INTO WA_DOWN-STOCK_QTY  .
      ENDIF.

      WA_DOWN-STOCK_QTY1     =               WA_FINAL-STOCK_QTY1   .
      CONDENSE WA_DOWN-STOCK_QTY1 .
      IF WA_FINAL-STOCK_QTY1  < 0.
        CONCATENATE '-'  WA_DOWN-STOCK_QTY1  INTO WA_DOWN-STOCK_QTY1  .
      ENDIF.



      WA_DOWN-KBETR         =               WA_FINAL-KBETR       .
      CONDENSE WA_DOWN-KBETR .
      IF WA_FINAL-KBETR   < 0.
        CONCATENATE '-' WA_DOWN-KBETR INTO WA_DOWN-KBETR  .
      ENDIF.
      WA_DOWN-AMONT         =               WA_FINAL-AMONT       .
      CONDENSE WA_DOWN-AMONT .
      IF WA_FINAL-AMONT   < 0.
        CONCATENATE '-' WA_DOWN-AMONT INTO WA_DOWN-AMONT  .
      ENDIF.

      WA_DOWN-QMQTY         =               WA_FINAL-QMQTY       .
      CONDENSE WA_DOWN-QMQTY .
      IF WA_FINAL-QMQTY   < 0.
        CONCATENATE '-' WA_DOWN-QMQTY INTO WA_DOWN-QMQTY.
      ENDIF.

      WA_DOWN-ZPROD_QTY        =               WA_FINAL-ZPROD_QTY     .
      IF WA_FINAL-ZPROD_QTY   < 0.
        CONCATENATE '-' WA_DOWN-ZPROD_QTY INTO WA_DOWN-ZPROD_QTY.
      ENDIF.

      WA_DOWN-SO_EXC        =               WA_FINAL-SO_EXC      .
      WA_DOWN-TPI           =               WA_FINAL-TPI         .
      WA_DOWN-INCO1         =               WA_FINAL-INCO1       .
      WA_DOWN-INCO2         =               WA_FINAL-INCO2       .
      WA_DOWN-ZSIZE         =               WA_FINAL-ZSIZE       .
      WA_DOWN-ZSERIES       =               WA_FINAL-ZSERIES     .
      WA_DOWN-SHIP_KUNNR    =               WA_FINAL-SHIP_KUNNR  .
*      wa_down-ship_kunnr_n  =               wa_final-ship_kunnr_n.
      WA_DOWN-NTGEW         =               WA_FINAL-NTGEW       .
      WA_DOWN-AUFNR         =               WA_FINAL-AUFNR       .
*      wa_down-budat         =               wa_final-budat       .
      IF WA_FINAL-BUDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BUDAT
          IMPORTING
            OUTPUT = WA_DOWN-BUDAT.

        CONCATENATE WA_DOWN-BUDAT+0(2) WA_DOWN-BUDAT+2(3) WA_DOWN-BUDAT+5(4)
                        INTO WA_DOWN-BUDAT SEPARATED BY '-'.
      ENDIF.
*      wa_down-lgort         =               wa_final-lgort       .
      WA_DOWN-LGORT1        =               WA_FINAL-LGORT1       .
      WA_DOWN-US_CUST       =               WA_FINAL-US_CUST  .
      WA_DOWN-ZRACK_LOC     =               WA_FINAL-ZRACK_LOC  .
      WA_DOWN-ZMAT_REMARK   =               WA_FINAL-ZMAT_REMARK  .
      WA_DOWN-ZFG_WEIGHT    =               WA_FINAL-ZFG_WEIGHT  .
*      wa_down-GEWEI        =               wa_final-GEWEI  .
      WA_DOWN-ZPROD_PLAN    =               WA_FINAL-ZPROD_PLAN  .
      WA_DOWN-BSTKD         =               WA_FINAL-BSTKD  .
      WA_DOWN-SHIP_KUNNR_NAME         =     WA_FINAL-SHIP_KUNNR_NAME  .
      WA_DOWN-KUNNR         =               WA_FINAL-KUNNR  .
      WA_DOWN-EBELN         =               WA_FINAL-EBELN  .
      WA_DOWN-PSMNG          =               WA_FINAL-PSMNG   .
      WA_DOWN-WEMNG          =               WA_FINAL-WEMNG   .
      WA_DOWN-MENGE1         =               WA_FINAL-MENGE1  .
      WA_DOWN-MENGE2         =               WA_FINAL-MENGE2  .
      WA_DOWN-LOEKZ         =               WA_FINAL-LOEKZ  .
      WA_DOWN-MENGE_MSEG    =               WA_FINAL-MENGE_MSEG  .
      WA_DOWN-FG01    =               WA_FINAL-FG01  .
      WA_DOWN-TPI1    =               WA_FINAL-TPI1  .
      WA_DOWN-KFG0    =               WA_FINAL-KFG0  .
      WA_DOWN-KTPI    =               WA_FINAL-KTPI  .
*      wa_down-budat_mkpf    =               wa_final-budat_mkpf  .

      IF WA_FINAL-BUDAT_MKPF IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BUDAT_MKPF
          IMPORTING
            OUTPUT = WA_DOWN-BUDAT_MKPF.

        CONCATENATE WA_DOWN-BUDAT_MKPF+0(2) WA_DOWN-BUDAT_MKPF+2(3) WA_DOWN-BUDAT_MKPF+5(4)
                        INTO WA_DOWN-BUDAT_MKPF SEPARATED BY '-'.
      ENDIF.
*      wa_down-GRN_DATE      =               wa_final-GRN_DATE    .

      IF WA_FINAL-GRN_DATE IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-GRN_DATE
          IMPORTING
            OUTPUT = WA_DOWN-GRN_DATE.

        CONCATENATE WA_DOWN-GRN_DATE+0(2) WA_DOWN-GRN_DATE+2(3) WA_DOWN-GRN_DATE+5(4)
                        INTO WA_DOWN-GRN_DATE SEPARATED BY '-'.
      ENDIF.
*      wa_down-kalab         =               wa_final-kalab  .






      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF_DATE.

      CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
                      INTO WA_DOWN-REF_DATE SEPARATED BY '-'.

      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      APPEND WA_DOWN TO IT_DOWN.
      CLEAR :WA_DOWN, WA_FINAL.

      .

    ENDLOOP.
  ENDIF.
  IT_FINAL1 = IT_FINAL.

ENDFORM.                    " PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM ALV_FOR_OUTPUT .
*  *ADDING TOP OF PAGE FEATURE
*  PERFORM stp3_eventtab_build   CHANGING gt_events[].
*  PERFORM comment_build         CHANGING i_list_top_of_page[].
*  PERFORM top_of_page.
  PERFORM LAYOUT_BUILD          CHANGING WA_LAYOUT.
**************************************************************************

  PERFORM BUILD_FIELDCAT USING 'VBELN'          'X' '1'     TEXT-003     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'POSNR'          'X' '2'     TEXT-004     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'NAME1'          'X' '3'     TEXT-006     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'KUNNR'          'X' '4'     TEXT-041     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'MATNR'          'X' '5'     TEXT-007     '18'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'MATTXT'         'X' '6'     TEXT-008     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'KWMENG'         'X' '7'     TEXT-009     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'FKIMG'          'X' '8'     TEXT-010     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'PND_QTY'        'X' '9'     TEXT-011     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'WIP'            'X' '10'    TEXT-012     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'QMQTY'          'X' '11'    TEXT-013     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'STOCK_QTY'      'X' '12'    TEXT-014     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'KBETR'          'X' '13'    TEXT-015     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'AMONT'          'X' '14'    TEXT-016     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'SO_EXC'         'X' '15'    TEXT-017     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'TPI'            'X' '16'    TEXT-018     '50'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'INCO1'          'X' '17'    TEXT-019     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'INCO2'          'X' '18'    TEXT-020     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'SHIP_KUNNR'     'X' '19'    TEXT-021     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'SHIP_KUNNR_NAME' 'X' '20'   TEXT-044     '15'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'ZSIZE'          'X' '21'    TEXT-022     '15'     '' ''   ''.
  PERFORM BUILD_FIELDCAT USING 'ZSERIES'        'X' '22'    TEXT-023     '15'     '' ''   ''.
  PERFORM BUILD_FIELDCAT USING 'NTGEW'          'X' '23'    TEXT-024     '15'     '' ''   ''.
  PERFORM BUILD_FIELDCAT USING 'AUFNR'          'X' '24'    TEXT-025     '15'     '' ''   ''.
  PERFORM BUILD_FIELDCAT USING 'BUDAT'          'X' '25'    TEXT-026     '15'     '' ''   ''.
*  PERFORM build_fieldcat USING 'LGORT'          'X' '26'    TEXT-027     '15'     '' ''   ''.
  PERFORM BUILD_FIELDCAT USING 'US_CUST'        'X' '27'    TEXT-028     '15'     '' ''   ''.
  PERFORM BUILD_FIELDCAT USING 'BSTKD'         'X' '28'     TEXT-038     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'VKBUR'         'X' '29'     TEXT-039     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'WRKST'         'X' '30'     TEXT-040     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'EBELN'         'X' '31'     TEXT-045     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'PSMNG'         'X' '32'     TEXT-047     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'WEMNG'         'X' '33'     TEXT-048     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'MENGE1'         'X' '34'    TEXT-049     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'MENGE2'         'X' '35'    TEXT-050     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'LOEKZ'         'X' '36'     TEXT-051     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'MENGE_MSEG'    'X' '37'     TEXT-052     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'BUDAT_MKPF'    'X' '38'     TEXT-053     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'GRN_DATE'      'X' '39'     TEXT-054     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'FG01'          'X' '40'     TEXT-055     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'TPI1'          'X' '41'     TEXT-056     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'KFG0'          'X' '42'     TEXT-057     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'KTPI'          'X' '43'     TEXT-058     '25'     ''   ''   '' .
  PERFORM BUILD_FIELDCAT USING 'EBELP'          'X' '44'     TEXT-059     '25'     ''   ''   '' .
  IF UPLOAD = 'X'.
    PERFORM BUILD_FIELDCAT USING 'ZRACK_LOC'      'X' '31'  TEXT-029     '80'     'X' ''   ''.
    PERFORM BUILD_FIELDCAT USING 'ZMAT_REMARK'    'X' '32'  TEXT-030     '80'     'X' ''   ''.
    PERFORM BUILD_FIELDCAT USING 'ZFG_WEIGHT'     'X' '33'  TEXT-031     '15'     'X' 'NTGEW'   'MARA'.
    PERFORM BUILD_FIELDCAT USING 'ZPROD_PLAN'     'X' '34'  TEXT-032     '40'     'X' ''   ''.
    PERFORM BUILD_FIELDCAT USING 'ZPROD_QTY'      'X' '35'  TEXT-035     '15'     'X' 'PSMNG'   'AFPO'.
    PERFORM BUILD_FIELDCAT USING 'STOCK_QTY1'     'X' '36'  TEXT-036     '15'     ''   ''   '' .
    PERFORM BUILD_FIELDCAT USING 'LGORT1'         'X' '37'  TEXT-037     '25'     ''   ''   '' .
  ELSEIF DISPLAY = 'X'.
    PERFORM BUILD_FIELDCAT USING 'ZRACK_LOC'      'X' '31'  TEXT-029     '80'     '' ''   ''.
    PERFORM BUILD_FIELDCAT USING 'ZMAT_REMARK'    'X' '32'  TEXT-030     '80'     '' ''   ''.
    PERFORM BUILD_FIELDCAT USING 'ZFG_WEIGHT'     'X' '33'  TEXT-031     '15'     '' 'NTGEW'   'MARA'.
    PERFORM BUILD_FIELDCAT USING 'ZPROD_PLAN'     'X' '34'  TEXT-032     '40'     '' ''   ''.
    PERFORM BUILD_FIELDCAT USING 'ZPROD_QTY'      'X' '35'  TEXT-035     '15'     '' 'PSMNG'   'AFPO'.
    PERFORM BUILD_FIELDCAT USING 'STOCK_QTY1'    'X'  '36'  TEXT-036     '15'     ''   ''   '' .
    PERFORM BUILD_FIELDCAT USING 'LGORT1'        'X'  '37'  TEXT-037     '25'     ''   ''   '' .
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
*     i_structure_name         = 'OUTPUT'
      IS_LAYOUT                = WA_LAYOUT
      IT_FIELDCAT              = IT_FCAT
      IT_SORT                  = I_SORT
      I_CALLBACK_PF_STATUS_SET = 'PF_STATUS_SET'
      I_CALLBACK_USER_COMMAND  = 'USER_COMMAND'
*     i_default                = 'A'
*     i_save                   = 'A'
      I_SAVE                   = 'X'
      IT_EVENTS                = GT_EVENTS[]
    TABLES
      T_OUTTAB                 = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR            = 1
      OTHERS                   = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



  IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.
  ENDIF.

ENDFORM.
FORM PF_STATUS_SET USING EXTAB TYPE SLIS_T_EXTAB.
  SET PF-STATUS 'STANDARD'.
ENDFORM.
*FOR USER COMMAND
FORM USER_COMMAND USING P_UCOMM TYPE SY-UCOMM
      P_SELFIELD TYPE SLIS_SELFIELD.

  DATA : G_GRID_I   TYPE REF TO	CL_GUI_ALV_GRID,
         LV_REFRESH TYPE FLAG.


  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      E_GRID = G_GRID_I.

  IF G_GRID_I IS NOT INITIAL .

    LV_REFRESH = 'X'.


    CALL METHOD G_GRID_I->CHECK_CHANGED_DATA
      CHANGING
        C_REFRESH = LV_REFRESH.

  ENDIF.

  CASE P_UCOMM.
    WHEN '&DATA_SAVE'.
*      BREAK-POINT.
      PERFORM F_SAVE_DATA.
      MESSAGE 'Data Save successfully!' TYPE 'S'.
    WHEN OTHERS.

  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

FORM STP3_EVENTTAB_BUILD  CHANGING P_GT_EVENTS TYPE SLIS_T_EVENT.

  DATA: LF_EVENT TYPE SLIS_ALV_EVENT. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE     = 0
    IMPORTING
      ET_EVENTS       = P_GT_EVENTS
    EXCEPTIONS
      LIST_TYPE_WRONG = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  MOVE C_FORMNAME_TOP_OF_PAGE TO LF_EVENT-FORM.
  MODIFY P_GT_EVENTS  FROM  LF_EVENT INDEX 3 TRANSPORTING FORM."TO P_I_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM COMMENT_BUILD CHANGING I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER.
  DATA: LF_LINE       TYPE SLIS_LISTHEADER. "WORK AREA

*  CONSTANTS:
*  c_formname_top_of_page   TYPE slis_formname
*                                   VALUE 'TOP_OF_PAGE',
*  c_formname_pf_status_set TYPE slis_formname
*                                 VALUE 'PF_STATUS_SET',
*  c_s                      TYPE c VALUE 'S',
*  c_h                      TYPE c VALUE 'H'.

*--LIST HEADING -  TYPE H
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_H.
  LF_LINE-INFO =  ''(042).
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.
*--HEAD INFO: TYPE S
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_S.
  LF_LINE-KEY  = TEXT-043.
  LF_LINE-INFO = SY-DATUM.
  WRITE SY-DATUM TO LF_LINE-INFO USING EDIT MASK '__.__.____'.
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = I_LIST_TOP_OF_PAGE[]. "INTERNAL TABLE WITH


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM LAYOUT_BUILD  CHANGING P_WA_LAYOUT TYPE SLIS_LAYOUT_ALV.

*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  WA_LAYOUT-ZEBRA          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  P_WA_LAYOUT-ZEBRA          = 'X'.
  P_WA_LAYOUT-NO_COLHEAD        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM BUILD_FIELDCAT  USING    V1  V2 V3 V4 V5 V6 V7 V8.
  WA_FCAT-FIELDNAME   = V1 ." 'VBELN'.
  WA_FCAT-TABNAME     = 'IT_FINAL'.  "'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
  WA_FCAT-KEY         =  V2 ."  'X'.
  WA_FCAT-SELTEXT_L   =  V4.
  WA_FCAT-OUTPUTLEN   =  V5." 20.
*  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.
  WA_FCAT-COL_POS     =  V3.
  WA_FCAT-EDIT     =  V6.
  WA_FCAT-REF_FIELDNAME = V7.
  WA_FCAT-REF_TABNAME = V8.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.                    " BUILD_FIELDCAT
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

  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
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

  LV_FILE = 'ZFG_RACK.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
     INTO LV_FULLFILE.

  WRITE: / 'ZFG_RACK.TXT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
**DATA lv_string_2334 TYPE string.
**DATA lv_crlf_2334 TYPE string.
**lv_crlf_2334 = cl_abap_char_utilities=>cr_lf.
**lv_string_2334 = hd_csv.
**CONCATENATE lv_string_2334 lv_crlf_2334 wa_csv INTO lv_string_2334.
**  CLEAR: wa_csv.
**ENDLOOP.
**TRANSFER lv_string_2334 TO lv_fullfile.
    DATA LV_STRING_2371 TYPE STRING.
    DATA LV_CRLF_2371 TYPE STRING.
    LV_CRLF_2371 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_2371 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_2371 LV_CRLF_2371 WA_CSV INTO LV_STRING_2371.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_2371 TO LV_FULLFILE.
*    CLOSE DATASET lv_fullfile.           " COMMENTED BY SIMRAN
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
FORM CVS_HEADER  USING    P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE         TEXT-003
                      TEXT-004
                      TEXT-006
                      TEXT-041
                      TEXT-007
                      TEXT-008
                      TEXT-009
                      TEXT-010
                      TEXT-011
                      TEXT-012
                      TEXT-013
                      TEXT-014
                      TEXT-015
                      TEXT-016
                      TEXT-017
                      TEXT-018
                      TEXT-019
                      TEXT-020
                      TEXT-021
                      TEXT-044
                      TEXT-022
                      TEXT-023
                      TEXT-024
                      TEXT-025
                      TEXT-026
*                      TEXT-027
                      TEXT-028
                      TEXT-038
                      TEXT-039
                      TEXT-040
                      TEXT-029
                      TEXT-030
                      TEXT-031
                      TEXT-032
                      TEXT-035
                      TEXT-036
                      TEXT-037
                      TEXT-033
                      TEXT-034
                      TEXT-045
*                      TEXT-046
                      TEXT-047
                      TEXT-048
                      TEXT-049
                      TEXT-050
                      TEXT-051
                      TEXT-052
                      TEXT-053
                      TEXT-054
                      TEXT-055
                      TEXT-056
                      TEXT-057
                      TEXT-058
                      TEXT-059
               INTO P_HD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_SAVE_DATA .

  DATA : WA_ZFG_RACK TYPE ZFG_RACK.
  DATA : WA_ZFG_RACK_WEIGHT TYPE ZFG_RACK_WEIGHT.
  DATA : WA_ZFG_RACK_PLANQTY TYPE ZFG_RACK_PLANQTY.  " added by sonu
*  DELETE it_final WHERE zrack_loc IS INITIAL AND zmat_remark IS INITIAL.

  LOOP AT IT_FINAL INTO WA_FINAL.
    WA_ZFG_RACK-VBELN       = WA_FINAL-VBELN.
    WA_ZFG_RACK-POSNR       = WA_FINAL-POSNR.
    WA_ZFG_RACK-ZRACK_LOC   = WA_FINAL-ZRACK_LOC.
    WA_ZFG_RACK-ZMAT_REMARK = WA_FINAL-ZMAT_REMARK.
*    wa_zfg_rack-zfg_weight       = wa_final-zfg_weight.
*    wa_zfg_rack-gewei       = wa_final-gewei.
    WA_ZFG_RACK-ZPROD_PLAN_NEW       = WA_FINAL-ZPROD_PLAN.
    WA_ZFG_RACK-MATNR      = WA_FINAL-MATNR.
    WA_ZFG_RACK-ZPROD_QTY      = WA_FINAL-ZPROD_QTY.
    WA_ZFG_RACK-EBELN      = WA_FINAL-EBELN.
    WA_ZFG_RACK-AUFNR      = WA_FINAL-AUFNR.

    IF WA_FINAL-PND_QTY LT WA_ZFG_RACK-ZPROD_QTY AND WA_FINAL-AUFNR IS INITIAL..
      MESSAGE 'Production Plan Qty is greater than Pending Qty' &&'-' && WA_FINAL-VBELN &&'-' && WA_FINAL-POSNR  TYPE 'E'.
    ENDIF.

**    IF  wa_final-menge LT  wa_zfg_rack-zprod_qty  AND wa_final-aufnr IS NOT INITIAL. " commented by sonu
    IF  WA_FINAL-KWMENG LT  WA_ZFG_RACK-ZPROD_QTY  AND WA_FINAL-AUFNR IS NOT INITIAL.  " added by sonu
      MESSAGE |Production Plan Qty is greater than Prod Order Qty.| &&'-' && WA_FINAL-VBELN &&'-' && WA_FINAL-POSNR TYPE 'E'.
    ENDIF.

    MODIFY ZFG_RACK FROM  WA_ZFG_RACK.

*    if wa_final-zfg_weight is NOT INITIAl  .

    DELETE ADJACENT DUPLICATES FROM IT_FINAL1 COMPARING MATNR .
*      READ TABLE it_final1 INTO data(wa_final1) with key matnr = wa_final-matnr.
*      if sy-subrc is INITIAL.
*          wa_zfg_rack_weight-zfg_weight       = wa_final1-zfg_weight.
*      wa_zfg_rack_weight-matnr        = wa_final1-matnr.
*      MODIFY zfg_rack_weight FROM  wa_zfg_rack_weight.
*
*    endif.
*


*
*    endif.
    LOOP AT IT_FINAL1 INTO DATA(WA_FINAL1) WHERE MATNR = WA_FINAL-MATNR.
      IF WA_FINAL1-ZFG_WEIGHT NE WA_FINAL-ZFG_WEIGHT.
        ON CHANGE OF WA_FINAL-MATNR.
          WA_ZFG_RACK_WEIGHT-ZFG_WEIGHT       = WA_FINAL-ZFG_WEIGHT.
          WA_ZFG_RACK_WEIGHT-MATNR        = WA_FINAL-MATNR.
          IF WA_ZFG_RACK_WEIGHT IS NOT INITIAL.
            MODIFY ZFG_RACK_WEIGHT FROM  WA_ZFG_RACK_WEIGHT.
          ENDIF.
        ENDON.
      ENDIF.
    ENDLOOP.

    LOOP AT IT_FINAL1 INTO DATA(WA_FINAL2) WHERE VBELN = WA_FINAL-VBELN
                                          AND POSNR = WA_FINAL-POSNR.
      IF WA_FINAL2-ZPROD_QTY NE WA_FINAL-ZPROD_QTY.
        ON CHANGE OF WA_FINAL-POSNR.
          WA_ZFG_RACK_PLANQTY-ZPROD_QTY     = WA_FINAL-ZPROD_QTY.
          WA_ZFG_RACK_PLANQTY-VBELN       = WA_FINAL-VBELN.
          WA_ZFG_RACK_PLANQTY-POSNR       = WA_FINAL-POSNR.
          IF WA_ZFG_RACK_PLANQTY IS NOT INITIAL.
            MODIFY ZFG_RACK_PLANQTY FROM  WA_ZFG_RACK_PLANQTY.
          ENDIF.
        ENDON.
      ENDIF.
    ENDLOOP.

    CLEAR : WA_FINAL.
  ENDLOOP.

ENDFORM.
