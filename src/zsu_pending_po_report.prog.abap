*&---------------------------------------------------------------------*
*&Report: ZSU_PENDING_PO_REPORT
*&Transaction: ZSU_PENDPO
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZSU_PENDING_PO_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_PENDING_PO_REPORT.
TYPE-POOLS: SLIS.
TABLES:EKKO,EKPO.



TYPES: BEGIN OF TY_EKKO,
         EBELN  TYPE EKKO-EBELN,
         BUKRS  TYPE EKKO-BUKRS,
         BSART  TYPE EKKO-BSART,
         EKORG  TYPE EKKO-EKORG,
         LIFNR  TYPE EKKO-LIFNR,
         AEDAT  TYPE EKKO-AEDAT,
         EKGRP  TYPE EKKO-EKGRP,
         WAERS  TYPE EKKO-WAERS,
         BEDAT  TYPE EKKO-BEDAT,
         ZTERM  TYPE EKKO-ZTERM,
         SUBMI  TYPE EKKO-SUBMI,
         WKURS  TYPE EKKO-WKURS,
         KNUMV  TYPE EKKO-KNUMV,
         FRGKE  TYPE EKKO-FRGKE,
         MEMORY TYPE EKKO-MEMORY,
       END OF TY_EKKO,

       BEGIN OF TY_EKPO,
         EBELN TYPE EKPO-EBELN,
         EBELP TYPE EKPO-EBELP,
         TXZ01 TYPE EKPO-TXZ01,
         LOEKZ TYPE EKPO-LOEKZ,
         MATNR TYPE EKPO-MATNR,
         MENGE TYPE EKPO-MENGE,
         PSTYP TYPE EKPO-PSTYP,
         KNTTP TYPE EKPO-KNTTP,
         MWSKZ TYPE EKPO-MWSKZ,
         NETWR TYPE EKPO-NETWR,
         NETPR TYPE EKPO-NETPR,
         ELIKZ TYPE EKPO-ELIKZ,
         WERKS TYPE EKPO-WERKS,
         BSTAE TYPE EKPO-BSTAE, " added by Nilay B. on 06.03.2023
         INFNR TYPE EKPO-INFNR, " added by Nilay B. on 06.03.2023
       END OF TY_EKPO,

       BEGIN OF TY_LFA1,
         LIFNR TYPE LFA1-LIFNR,
         LAND1 TYPE LFA1-LAND1,
         NAME1 TYPE LFA1-NAME1,
         REGIO TYPE LFA1-REGIO,
         STCD3 TYPE LFA1-STCD3,
         ADRNR TYPE LFA1-ADRNR,
       END OF TY_LFA1,

       BEGIN OF TY_T005U,
         SPRAS TYPE T005U-SPRAS,
         LAND1 TYPE T005U-LAND1,
         BLAND TYPE T005U-BLAND,
         BEZEI TYPE T005U-BEZEI,
       END OF TY_T005U,

       BEGIN OF TY_T007S,
         MWSKZ TYPE T007S-MWSKZ,
         KALSM TYPE T007S-KALSM,
         TEXT1 TYPE T007S-TEXT1,
       END OF TY_T007S,

       BEGIN OF TY_T052U,
         SPRAS TYPE T052U-SPRAS,
         ZTERM TYPE T052U-ZTERM,
         TEXT1 TYPE T052U-TEXT1,
       END OF TY_T052U,

       BEGIN OF TY_MARA,
         MATNR   TYPE MARA-MATNR,
         MTART   TYPE MARA-MTART,
         WRKST   TYPE MARA-WRKST,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         BRAND   TYPE MARA-BRAND,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
       END OF TY_MARA,

       BEGIN OF TY_MSEG,
         MBLNR      TYPE MSEG-MBLNR,
         EBELN      TYPE MSEG-EBELN,
         EBELP      TYPE MSEG-EBELP,
         BWART      TYPE MSEG-BWART,
         XAUTO      TYPE MSEG-XAUTO,
         LGORT      TYPE MSEG-LGORT,
         MENGE      TYPE MSEG-MENGE,
         ERFMG      TYPE MSEG-ERFMG,
         DMBTR      TYPE MSEG-DMBTR,
         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
       END OF TY_MSEG,

       BEGIN OF TY_GRN,
         MBLNR TYPE MSEG-MBLNR,
         EBELN TYPE MSEG-EBELN,
         EBELP TYPE MSEG-EBELP,
         BWART TYPE MSEG-BWART,
         SMBLN TYPE MSEG-SMBLN,
       END OF TY_GRN,

       BEGIN OF TY_QALS,
         PRUEFLOS TYPE QALS-PRUEFLOS,
         EBELN    TYPE QALS-EBELN,
         EBELP    TYPE QALS-EBELP,
         MBLNR    TYPE QALS-MBLNR,
       END OF TY_QALS,

       BEGIN OF TY_QAMB,
         PRUEFLOS TYPE QAMB-PRUEFLOS,
         MBLNR    TYPE QAMB-MBLNR,
         TYP      TYPE QAMB-TYP,
       END OF TY_QAMB,

       BEGIN OF TY_MKPF,
         MBLNR TYPE MKPF-MBLNR,
         BLDAT TYPE MKPF-BLDAT,
         XBLNR TYPE MKPF-XBLNR,
       END OF TY_MKPF,


       BEGIN OF TY_ADRC,
         ADDRNUMBER TYPE ADRC-ADDRNUMBER,
         NAME1      TYPE ADRC-NAME1,
         CITY2      TYPE ADRC-CITY2,
         POST_CODE1 TYPE ADRC-POST_CODE1,
         STREET     TYPE ADRC-STREET,
         STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
         LOCATION   TYPE ADRC-LOCATION,
       END OF TY_ADRC,

       BEGIN OF TY_MARC,
         MATNR TYPE MARC-MATNR,
         STEUC TYPE MARC-STEUC,
         WERKS TYPE MARC-WERKS,
       END OF TY_MARC,

       BEGIN OF TY_BKPF,
         BELNR     TYPE BKPF-BELNR,
         XBLNR     TYPE BKPF-XBLNR,
         XBLNR_ALT TYPE BKPF-XBLNR_ALT,
         BLDAT     TYPE BKPF-BLDAT,
         AWKEY     TYPE BKPF-AWKEY,
         BUDAT     TYPE BKPF-BUDAT,
       END OF TY_BKPF,

       BEGIN OF TY_RBKP,
         BELNR TYPE RBKP-BELNR,
         BKTXT TYPE RBKP-BKTXT,
         ZUONR TYPE RBKP-ZUONR,
         BUDAT TYPE RBKP-BUDAT,
       END OF TY_RBKP,

       BEGIN OF TY_EKET,
         EBELN TYPE EKET-EBELN,
         EBELP TYPE EKET-EBELN, " MODIFIED BY PJ 31-08-21
         EINDT TYPE EKET-EINDT,
       END OF TY_EKET,

       BEGIN OF TY_RSEG,
         BELNR TYPE RSEG-BELNR,
         EBELN TYPE RSEG-EBELN,
         EBELP TYPE RSEG-EBELP,
         GJAHR TYPE RSEG-GJAHR,
         MWSKZ TYPE RSEG-MWSKZ,
         WRBTR TYPE RSEG-WRBTR,
         MENGE TYPE RSEG-MENGE,
       END OF TY_RSEG,

       BEGIN OF TY_T163X,
         SPRAS TYPE T163X-SPRAS,
         PSTYP TYPE T163X-PSTYP,
         EPSTP TYPE T163X-EPSTP,
       END OF TY_T163X,



       BEGIN OF TY_J_1IMOVEND,
         LIFNR     TYPE J_1IMOVEND-LIFNR,
         VEN_CLASS TYPE J_1IMOVEND-VEN_CLASS,
       END OF TY_J_1IMOVEND,

       BEGIN OF TY_ZGST_REGION,
         REGION     TYPE ZGST_REGION-REGION,
         GST_REGION TYPE ZGST_REGION-GST_REGION,
       END OF TY_ZGST_REGION.

TYPES : BEGIN OF TY_EKPO_EKET,
          EBELN TYPE EKPO-EBELN,
          EBELP TYPE EKPO-EBELP,
          MATNR TYPE EKPO-MATNR,
          MENGE TYPE EKPO-MENGE,
          LOEKZ TYPE EKPO-LOEKZ,
          ELIKZ TYPE EKPO-ELIKZ,
          WERKS TYPE EKPO-WERKS,
          RETPO TYPE EKPO-RETPO,
          BRTWR TYPE EKPO-BRTWR,
          WEMNG TYPE EKET-WEMNG,
          NETWR TYPE EKPO-NETWR,
        END OF TY_EKPO_EKET.

DATA : IT_EKPO_EKET TYPE STANDARD TABLE OF TY_EKPO_EKET,
       WA_EKPO_EKET TYPE TY_EKPO_EKET.

TYPES: BEGIN OF TY_EKPO1,
         MATNR TYPE EKPO-MATNR,
         EBELN TYPE EKPO-EBELN,
         EBELP TYPE EKPO-EBELP,
         MENGE TYPE EKPO-MENGE,
         LOEKZ TYPE EKPO-LOEKZ,
         ELIKZ TYPE EKPO-ELIKZ,
         WERKS TYPE EKPO-WERKS,
         RETPO TYPE EKPO-RETPO,
         BRTWR TYPE EKPO-BRTWR,
         NETWR TYPE EKPO-NETWR,
       END OF TY_EKPO1.
*
*DATA : it_ekpo TYPE STANDARD TABLE OF ty_ekpo,
*       wa_ekpo TYPE ty_ekpo.
*
DATA : IT_EKPO1 TYPE STANDARD TABLE OF TY_EKPO1,
       WA_EKPO1 TYPE TY_EKPO1.

TYPES: BEGIN OF TY_KONV,
         KNUMV TYPE prcd_elements-KNUMV,
         KPOSN TYPE prcd_elements-KPOSN,
         KSCHL TYPE prcd_elements-KSCHL,
         KAWRT TYPE prcd_elements-KAWRT,
         KBETR TYPE prcd_elements-KBETR,
         KWERT TYPE prcd_elements-KWERT,
       END OF TY_KONV.

DATA : IT_KONV TYPE TABLE OF TY_KONV,
       WA_KONV TYPE          TY_KONV.

TYPES : BEGIN OF TY_A991,
          KSCHL TYPE A991-KSCHL,
          MWSKZ TYPE A991-MWSKZ,
          KNUMH TYPE A991-KNUMH,
        END OF TY_A991,

        BEGIN OF TY_KONP,
          KNUMH TYPE KONP-KNUMH,
          KSCHL TYPE KONP-KSCHL,
          KBETR TYPE KONP-KBETR,
        END OF TY_KONP,

        BEGIN OF TY_EIPA,
          EBELN TYPE EIPA-EBELN,
          EBELP TYPE EIPA-EBELP,
          INFNR TYPE EIPA-INFNR,
          ESOKZ TYPE EIPA-ESOKZ,
        END OF TY_EIPA,

        BEGIN OF TY_EINA,
          INFNR TYPE EINA-INFNR,
          URZZT TYPE EINA-URZZT,
        END OF TY_EINA.

DATA : IT_KONP TYPE TABLE OF TY_KONP,
       WA_KONP TYPE          TY_KONP,

       IT_A991 TYPE TABLE OF TY_A991,
       WA_A991 TYPE          TY_A991,

       IT_EIPA TYPE TABLE OF TY_EIPA,
       WA_EIPA TYPE          TY_EIPA,

       IT_EINA TYPE TABLE OF TY_EINA,
       WA_EINA TYPE          TY_EINA.

TYPES: BEGIN OF TY_FINAL,
         EBELN          TYPE EKKO-EBELN,
         EKORG          TYPE EKKO-EKORG,
         LIFNR          TYPE EKKO-LIFNR,
         AEDAT          TYPE EKKO-AEDAT,
         WAERS          TYPE EKKO-WAERS,
         ZTERM          TYPE EKKO-ZTERM,
         EKGRP          TYPE EKKO-EKGRP,
         SUBMI          TYPE EKKO-SUBMI,
         BSART          TYPE EKKO-BSART,
         EBELP          TYPE EKPO-EBELP,
         MATNR          TYPE EKPO-MATNR,
         MENGE          TYPE EKPO-MENGE,
         LOEKZ          TYPE EKPO-LOEKZ,
         KNTTP          TYPE EKPO-KNTTP,
         MWSKZ          TYPE EKPO-MWSKZ,
         NETWR          TYPE EKPO-NETWR,
         NETPR          TYPE EKPO-NETPR,
         ELIKZ          TYPE EKPO-ELIKZ,
         BSTAE          TYPE EKPO-BSTAE, "added by Nilasy B. on 06.03.2023
*         infnr       TYPE ekpo-infnr, " added by Nilay B. on 06.03.2023
         MBLNR          TYPE MSEG-MBLNR,
         BWART          TYPE MSEG-BWART,
         LGORT          TYPE MSEG-LGORT,
         ERFMG          TYPE MSEG-ERFMG,
         DMBTR          TYPE MSEG-DMBTR,
         BUDAT_MKPF     TYPE MSEG-BUDAT_MKPF,
         SMBLN          TYPE MSEG-SMBLN,
         NAME1          TYPE LFA1-NAME1,
         STCD3          TYPE LFA1-STCD3,
         BELNR          TYPE EKBE-BELNR,
         BEWTP          TYPE EKBE-BEWTP,
         LFBNR          TYPE EKBE-LFBNR,
         EINDT          TYPE EKET-EINDT,
         XBLNR          TYPE BKPF-XBLNR,
         XBLNR_ALT      TYPE BKPF-XBLNR_ALT,
         BLDAT          TYPE BKPF-BLDAT,
         AWKEY          TYPE BKPF-AWKEY,
         BUDAT          TYPE BKPF-BUDAT,
         BKTXT          TYPE RBKP-BKTXT,
         ZUONR          TYPE RBKP-ZUONR,
         MIRO_DATE      TYPE RBKP-BUDAT,
         MTART          TYPE MARA-MTART,
         WRKST          TYPE MARA-WRKST,
         ZSERIES        TYPE MARA-ZSERIES,
         ZSIZE          TYPE MARA-ZSIZE,
         BRAND          TYPE MARA-BRAND,
         MOC            TYPE MARA-MOC,
         TYPE           TYPE MARA-TYPE,
         STEUC          TYPE MARC-STEUC,
         VEN_CLASS      TYPE CHAR50,
         ADDRESS        TYPE CHAR100,
         GST_REGION     TYPE ZGST_REGION-GST_REGION,
         BEZEI          TYPE T005U-BEZEI,
         TEXT1          TYPE T007S-TEXT1,
         EPSTP          TYPE T163X-EPSTP,
         ACC_QTY        TYPE MSEG-MENGE,
         REJ_QTY        TYPE MSEG-MENGE,
         SCP_QTY        TYPE MSEG-MENGE,
         REW_QTY        TYPE MSEG-MENGE,
         GRN_QTY        TYPE MSEG-MENGE,
         MAT_TEXT       TYPE TEXT100,
         WRBTR          TYPE RSEG-WRBTR,
         INV_QTY        TYPE RSEG-MENGE,
         DEL_IND        TYPE CHAR2,
         TERM_DES       TYPE T052U-TEXT1,
         MENGE2         TYPE MSEG-MENGE,
         MENGE3         TYPE MSEG-MENGE,
         MENGE4         TYPE MSEG-MENGE,
         PO_VAL         TYPE MSEG-DMBTR,
         PO_VAL1        TYPE MSEG-DMBTR,
         PO_VAL2        TYPE MSEG-DMBTR,
         PEND_PO_QTY    TYPE MSEG-MENGE,
         PO_VALUE       TYPE MSEG-DMBTR,
         CUST_DET       TYPE TEXT100,
         CTBG           TYPE CHAR255,
         OLD_PO         TYPE CHAR255,
         WKURS          TYPE EKKO-WKURS,
         RATE           TYPE prcd_elements-KBETR,
         BASIC          TYPE MSEG-DMBTR,
         PF             TYPE MSEG-DMBTR,
         INSP           TYPE MSEG-DMBTR,
         SETTING        TYPE MSEG-DMBTR,
         FREIGHT        TYPE MSEG-DMBTR,
         FRE_SAR        TYPE MSEG-DMBTR,
         FRE_USD        TYPE MSEG-DMBTR,
*         FRE_INR        TYPE MSEG-DMBTR,
         DEVP           TYPE MSEG-DMBTR,
         INS_USD        TYPE MSEG-DMBTR,
         INS_INR        TYPE MSEG-DMBTR,
         OTHER          TYPE MSEG-DMBTR,
*         misc_usd    TYPE mseg-dmbtr,
*         misc_inr    TYPE mseg-dmbtr,
         ASS_VAL        TYPE MSEG-DMBTR,
         CUST           TYPE MSEG-DMBTR,
         CUST_VAL       TYPE MSEG-DMBTR,
         SOCIAL         TYPE MSEG-DMBTR,
         SOCIAL_VAL     TYPE MSEG-DMBTR,
         OTHER_CUST_VAL TYPE MSEG-DMBTR,
         CGST           TYPE prcd_elements-KBETR,
         CGST_VAL       TYPE prcd_elements-KBETR,
         SGST           TYPE prcd_elements-KBETR,
         SGST_VAL       TYPE prcd_elements-KBETR,
         IGST           TYPE prcd_elements-KBETR,
         IGST_VAL       TYPE prcd_elements-KBETR,
         CRCM           TYPE prcd_elements-KBETR,
         CRCM_VAL       TYPE prcd_elements-KBETR,
         SRCM           TYPE prcd_elements-KBETR,
         SRCM_VAL       TYPE prcd_elements-KBETR,
         IRCM           TYPE prcd_elements-KBETR,
         IRCM_VAL       TYPE prcd_elements-KBETR,
         MWVS           TYPE prcd_elements-KBETR,
         TAX_AMT        TYPE MSEG-DMBTR,
         GROSS          TYPE MSEG-DMBTR,
         FRGKE          TYPE  C LENGTH 15,
         MEMORY         TYPE CHAR5,
         INFNR          TYPE EIPA-INFNR,
         ESOKZ          TYPE EIPA-ESOKZ, " Added By Nilay B. 06.03.2023
         URZZT          TYPE EINA-URZZT,
         BEDAT          TYPE EKKO-BEDAT,
         ACIF           TYPE prcd_elements-KBETR,
       END OF TY_FINAL.


TYPES : BEGIN OF TY_DOWN,
          EKORG          TYPE EKKO-EKORG,
          EKGRP          TYPE EKKO-EKGRP,
          LIFNR          TYPE EKKO-LIFNR,
          NAME1          TYPE LFA1-NAME1,
          STCD3          TYPE CHAR15,
*          BEZEI          TYPE T005U-BEZEI,
          EBELN          TYPE EKKO-EBELN,
          AEDAT          TYPE CHAR15,
          EBELP          TYPE EKPO-EBELP,
          MATNR          TYPE EKPO-MATNR,
          MAT_TEXT       TYPE CHAR100,
          MTART          TYPE MARA-MTART,
          STEUC          TYPE CHAR15,
          EINDT          TYPE CHAR15,
          MENGE          TYPE CHAR15,
          PEND_PO_QTY    TYPE CHAR15,
          WAERS          TYPE EKKO-WAERS,
          WKURS          TYPE EKKO-WKURS,
          RATE           TYPE CHAR15,
          BASIC          TYPE CHAR15,
          PF             TYPE CHAR15,
          INSP           TYPE CHAR15,
          SETTING        TYPE CHAR15,
*          FREIGHT        TYPE CHAR15,
          FRE_SAR        TYPE CHAR15,
          FRE_USD        TYPE CHAR15,
*          FRE_INR        TYPE CHAR15,
          DEVP           TYPE CHAR15,
          INS_INR        TYPE CHAR15,
          OTHER          TYPE CHAR15,
*          MISC_USD       TYPE CHAR15,
*          MISC_INR       TYPE CHAR15,
          ASS_VAL        TYPE CHAR15,
          MWSKZ          TYPE EKPO-MWSKZ,
          TEXT1          TYPE CHAR50,
          CUST           TYPE CHAR15,
          CUST_VAL       TYPE CHAR15,
          SOCIAL         TYPE CHAR15,
          SOCIAL_VAL     TYPE CHAR15,
          OTHER_CUST_VAL TYPE CHAR15,
          TAX_AMT        TYPE CHAR15,
          GROSS          TYPE CHAR15,
          BRAND          TYPE MARA-BRAND,
          ZSIZE          TYPE MARA-ZSIZE,
          MOC            TYPE MARA-MOC,
          TYPE           TYPE MARA-TYPE,
          ZSERIES        TYPE MARA-ZSERIES,
          BSART          TYPE EKKO-BSART,
          FRGKE          TYPE C LENGTH 15,
          MEMORY         TYPE CHAR5,
          URZZT          TYPE EINA-URZZT,
          BSTAE          TYPE EKPO-BSTAE, " added by Nilay B. on 06.03.2023
          INFNR          TYPE EIPA-INFNR, " added by Nilay B. on 06.03.2023
          ESOKZ          TYPE EIPA-ESOKZ, " added by Nilay B. on 06.03.2023
          REF            TYPE CHAR15,
          TIME           TYPE CHAR10,
          BEDAT          TYPE CHAR15,
          ACIF           TYPE CHAR15,
        END OF TY_DOWN.

DATA: LT_FINAL TYPE TABLE OF TY_DOWN,
      LS_FINAL TYPE          TY_DOWN.

DATA: DOC      TYPE BKPF-AWKEY,
      LV_IND   TYPE SY-TABIX,
      LV_INDEX TYPE SY-TABIX.


DATA:

  IT_EKKO        TYPE TABLE OF TY_EKKO,
  WA_EKKO        TYPE          TY_EKKO,

  IT_EKPO        TYPE TABLE OF TY_EKPO,
  WA_EKPO        TYPE          TY_EKPO,

  IT_MSEG        TYPE TABLE OF TY_MSEG,
  WA_MSEG        TYPE          TY_MSEG,

  IT_QUAL        TYPE TABLE OF TY_MSEG, " QUANTITY
  WA_QUAL        TYPE          TY_MSEG,

  IT_GRN         TYPE TABLE OF TY_GRN, "102 MOVEMENT.
  WA_GRN         TYPE          TY_GRN,

  IT_MKPF        TYPE TABLE OF TY_MKPF,
  WA_MKPF        TYPE          TY_MKPF,

  IT_BKPF        TYPE TABLE OF TY_BKPF,
  WA_BKPF        TYPE          TY_BKPF,

  IT_LFA1        TYPE TABLE OF TY_LFA1,
  WA_LFA1        TYPE          TY_LFA1,

  IT_MARA        TYPE TABLE OF TY_MARA,
  WA_MARA        TYPE          TY_MARA,

  IT_MARC        TYPE TABLE OF TY_MARC,
  WA_MARC        TYPE          TY_MARC,

  IT_EKET        TYPE TABLE OF TY_EKET,
  WA_EKET        TYPE          TY_EKET,

  IT_RSEG        TYPE TABLE OF TY_RSEG,
  WA_RSEG        TYPE          TY_RSEG,

  IT_RBKP        TYPE TABLE OF TY_RBKP,
  WA_RBKP        TYPE          TY_RBKP,

  IT_ADRC        TYPE TABLE OF TY_ADRC,
  WA_ADRC        TYPE          TY_ADRC,

  IT_T005U       TYPE TABLE OF TY_T005U,
  WA_T005U       TYPE          TY_T005U,

  IT_T052U       TYPE TABLE OF TY_T052U,
  WA_T052U       TYPE          TY_T052U,

  IT_T007S       TYPE TABLE OF TY_T007S,
  WA_T007S       TYPE          TY_T007S,

  IT_T163X       TYPE TABLE OF TY_T163X,
  WA_T163X       TYPE          TY_T163X,

  IT_QALS        TYPE TABLE OF TY_QALS,
  WA_QALS        TYPE          TY_QALS,

  IT_QAMB        TYPE TABLE OF TY_QAMB,
  WA_QAMB        TYPE          TY_QAMB,

  IT_J_1IMOVEND  TYPE TABLE OF TY_J_1IMOVEND,
  WA_J_1IMOVEND  TYPE          TY_J_1IMOVEND,

  IT_ZGST_REGION TYPE TABLE OF TY_ZGST_REGION,
  WA_ZGST_REGION TYPE          TY_ZGST_REGION,

  IT_FINAL       TYPE TABLE OF TY_FINAL,
  WA_FINAL       TYPE          TY_FINAL.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_EBELN FOR EKKO-EBELN,
                S_LIFNR FOR EKKO-LIFNR,
                S_AEDAT FOR EKKO-AEDAT,
                S_EKGRP FOR EKKO-EKGRP ,
*                s_matnr FOR ekpo-matnr,
                S_BSART FOR EKKO-BSART.
PARAMETERS:     P_BUKRS TYPE EKKO-BUKRS   OBLIGATORY DEFAULT 'SU00' MODIF ID BU.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'."Saudi'. "'/Delval/Saudi'."Saudi'.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
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
  PERFORM GET_FCAT.
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


  SELECT EBELN
         BUKRS
         BSART
         EKORG
         LIFNR
         AEDAT
         EKGRP
         WAERS
         BEDAT
         ZTERM
         SUBMI
         WKURS
         KNUMV
         FRGKE
         MEMORY
          FROM EKKO INTO TABLE IT_EKKO
         WHERE EBELN IN S_EBELN
         AND   LIFNR IN S_LIFNR
         AND   AEDAT IN S_AEDAT
         AND   BSART IN S_BSART
         AND   EKGRP IN S_EKGRP
  AND   BUKRS = P_BUKRS.


  IF IT_EKKO IS NOT INITIAL.
    SELECT EBELN
           EBELP
           TXZ01
           LOEKZ
           MATNR
           MENGE
           PSTYP
           KNTTP
           MWSKZ
           NETWR
           NETPR
           ELIKZ
           WERKS
           BSTAE FROM EKPO INTO TABLE IT_EKPO
           FOR ALL ENTRIES IN IT_EKKO
           WHERE EBELN = IT_EKKO-EBELN
    AND  LOEKZ NE 'L'.
    DELETE IT_EKPO WHERE ELIKZ EQ 'X'.

    IF IT_EKPO[] IS NOT INITIAL.
      SELECT EBELN
             EBELP
             INFNR
             ESOKZ
        FROM EIPA
        INTO TABLE IT_EIPA
        FOR ALL ENTRIES IN IT_EKPO
      WHERE EBELN = IT_EKPO-EBELN.

      IF IT_EIPA[] IS NOT INITIAL.

        SELECT INFNR
               URZZT
          FROM EINA
          INTO TABLE IT_EINA
          FOR ALL ENTRIES IN IT_EIPA
        WHERE INFNR = IT_EIPA-INFNR.

      ENDIF.
    ENDIF.
********************* code added by shreya 09.05.22*************************

    SELECT KNUMV
           KPOSN
           KSCHL
           KAWRT
           KBETR
           KWERT FROM prcd_elements INTO TABLE IT_KONV
           FOR ALL ENTRIES IN IT_EKKO
    WHERE KNUMV = IT_EKKO-KNUMV.

    SELECT LIFNR
           LAND1
           NAME1
           REGIO
           STCD3
           ADRNR FROM LFA1 INTO TABLE IT_LFA1
           FOR ALL ENTRIES IN IT_EKKO
    WHERE LIFNR = IT_EKKO-LIFNR.


    SELECT EBELN
           EBELP " MODIFIED BY PJ 31-08-21
           EINDT FROM EKET INTO TABLE IT_EKET
           FOR ALL ENTRIES IN IT_EKKO
    WHERE EBELN = IT_EKKO-EBELN.

    SELECT SPRAS
           ZTERM
           TEXT1 FROM T052U INTO TABLE IT_T052U
           FOR ALL ENTRIES IN IT_EKKO
           WHERE SPRAS = 'E'
    AND ZTERM = IT_EKKO-ZTERM.


  ENDIF.

  IF  IT_EKPO IS NOT INITIAL.

    SELECT A~EBELN
           A~EBELP
           A~MATNR
           A~MENGE
           A~LOEKZ
           A~ELIKZ
           A~WERKS
           A~RETPO
           A~BRTWR
           B~WEMNG
           A~NETWR
           INTO TABLE IT_EKPO_EKET
           FROM EKPO AS A
           INNER JOIN EKET AS B
           ON A~EBELN = B~EBELN
           AND A~EBELP = B~EBELP
           FOR ALL ENTRIES IN IT_EKPO
           WHERE A~EBELN EQ IT_EKPO-EBELN AND A~EBELP EQ IT_EKPO-EBELP
    AND A~LOEKZ NE 'L' AND A~RETPO NE 'X'.

    SELECT MATNR
           EBELN
           EBELP
           MENGE
           LOEKZ
           ELIKZ
           WERKS
           RETPO
           BRTWR
           NETWR
           FROM EKPO
           INTO TABLE IT_EKPO1
           FOR ALL ENTRIES IN IT_EKPO
           WHERE EBELN EQ IT_EKPO-EBELN
             AND EBELP EQ IT_EKPO-EBELP
    AND RETPO EQ 'X'.




*    SELECT belnr
*           ebeln
*           ebelp
*           gjahr
*           mwskz
*           wrbtr
*           menge FROM rseg INTO TABLE it_rseg
*           FOR ALL ENTRIES IN it_ekpo
*           WHERE ebeln = it_ekpo-ebeln
*             AND ebelp = it_ekpo-ebelp.


    SELECT MATNR
           MTART
           WRKST
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE   FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_EKPO
    WHERE MATNR = IT_EKPO-MATNR.

    SELECT MBLNR
           EBELN
           EBELP
           BWART
           XAUTO
           LGORT
           MENGE
           ERFMG
           DMBTR
           BUDAT_MKPF FROM MSEG INTO TABLE IT_MSEG
           FOR ALL ENTRIES IN IT_EKPO
           WHERE EBELN = IT_EKPO-EBELN
           AND   EBELP = IT_EKPO-EBELP
    AND BWART IN ('101','105').



    SELECT MBLNR
           EBELN
           EBELP
           BWART
           XAUTO
           LGORT
           MENGE
           ERFMG
           DMBTR
           BUDAT_MKPF FROM MSEG INTO TABLE IT_QUAL
           FOR ALL ENTRIES IN IT_EKPO
           WHERE EBELN = IT_EKPO-EBELN
           AND   EBELP = IT_EKPO-EBELP
           AND BWART = '321'
    AND XAUTO = 'X'.



    SELECT MATNR
           STEUC
           WERKS FROM MARC INTO TABLE IT_MARC
           FOR ALL ENTRIES IN IT_EKPO
           WHERE MATNR = IT_EKPO-MATNR
    AND WERKS = IT_EKPO-WERKS.

    SELECT MWSKZ
           KALSM
           TEXT1 FROM T007S INTO TABLE IT_T007S
           FOR ALL ENTRIES IN IT_EKPO
           WHERE MWSKZ = IT_EKPO-MWSKZ
    AND   KALSM = 'ZTAXSA'.

    SELECT SPRAS
           PSTYP
           EPSTP FROM T163X INTO TABLE IT_T163X
           FOR ALL ENTRIES IN IT_EKPO
           WHERE SPRAS = SY-LANGU
    AND PSTYP = IT_EKPO-PSTYP.

    SELECT KSCHL
           MWSKZ
           KNUMH FROM A991 INTO TABLE IT_A991
           FOR ALL ENTRIES IN IT_EKPO
    WHERE MWSKZ = IT_EKPO-MWSKZ.



  ENDIF.

  IF IT_A991 IS NOT INITIAL.
    SELECT KNUMH
           KSCHL
           KBETR FROM KONP INTO TABLE IT_KONP
           FOR ALL ENTRIES IN IT_A991
           WHERE KSCHL = IT_A991-KSCHL
    AND KNUMH = IT_A991-KNUMH.




  ENDIF.

  IF IT_MSEG IS NOT INITIAL .

    SELECT MBLNR
           EBELN
           EBELP
           BWART
           SMBLN FROM MSEG INTO TABLE IT_GRN
           FOR ALL ENTRIES IN IT_MSEG
           WHERE SMBLN = IT_MSEG-MBLNR
            AND EBELN = IT_MSEG-EBELN
            AND EBELP = IT_MSEG-EBELP
    AND BWART IN ( '102' , '106' ).


    SELECT PRUEFLOS
           EBELN
           EBELP
           MBLNR   FROM QALS INTO TABLE IT_QALS
           FOR ALL ENTRIES IN IT_MSEG
    WHERE MBLNR = IT_MSEG-MBLNR.

  ENDIF.

  IF IT_QALS IS NOT INITIAL.

    SELECT PRUEFLOS
           MBLNR
           TYP    FROM QAMB INTO TABLE IT_QAMB
           FOR ALL ENTRIES IN IT_QALS
           WHERE PRUEFLOS = IT_QALS-PRUEFLOS
    AND   TYP = '3'.


  ENDIF.

  IF IT_QAMB IS NOT INITIAL.

    SELECT MBLNR
           EBELN
           EBELP
           BWART
           XAUTO
           LGORT
           MENGE
           ERFMG
           DMBTR
           BUDAT_MKPF FROM MSEG INTO TABLE IT_QUAL
           FOR ALL ENTRIES IN IT_QAMB
           WHERE MBLNR = IT_QAMB-MBLNR
           AND BWART = '321'
    AND XAUTO = 'X'.

  ENDIF.

*  IF  it_rseg IS NOT INITIAL.
*
*
*    SELECT belnr
*           bktxt
*           zuonr
*           budat FROM rbkp INTO TABLE it_rbkp
*           FOR ALL ENTRIES IN it_rseg
*           WHERE belnr = it_rseg-belnr.
*
*
*
*  ENDIF.

  IF  IT_LFA1 IS NOT INITIAL .
    SELECT LIFNR
           VEN_CLASS FROM J_1IMOVEND INTO TABLE IT_J_1IMOVEND
           FOR ALL ENTRIES IN IT_LFA1
    WHERE LIFNR = IT_LFA1-LIFNR.

    SELECT ADDRNUMBER
           NAME1
           CITY2
           POST_CODE1
           STREET
           STR_SUPPL3
           LOCATION   FROM ADRC INTO TABLE IT_ADRC
           FOR ALL ENTRIES IN IT_LFA1
    WHERE ADDRNUMBER = IT_LFA1-ADRNR.

    SELECT SPRAS
           LAND1
           BLAND
           BEZEI FROM T005U INTO TABLE IT_T005U
           FOR ALL ENTRIES IN IT_LFA1
           WHERE SPRAS = SY-LANGU
           AND   LAND1 = IT_LFA1-LAND1
    AND   BLAND = IT_LFA1-REGIO.

    SELECT REGION
           GST_REGION FROM ZGST_REGION INTO TABLE IT_ZGST_REGION
           FOR ALL ENTRIES IN IT_LFA1
    WHERE REGION = IT_LFA1-REGIO.


  ENDIF.

  IF IT_MSEG IS NOT INITIAL.

    SELECT MBLNR
           BLDAT
           XBLNR FROM MKPF INTO TABLE IT_MKPF
           FOR ALL ENTRIES IN IT_MSEG
    WHERE MBLNR = IT_MSEG-MBLNR.

  ENDIF.


  LOOP AT IT_EKPO INTO WA_EKPO.

    WA_FINAL-EBELN = WA_EKPO-EBELN.
    WA_FINAL-EBELP = WA_EKPO-EBELP.
    WA_FINAL-MATNR = WA_EKPO-MATNR.
    WA_FINAL-MENGE = WA_EKPO-MENGE.
*  WA_FINAL-PSTYP = WA_EKPO-PSTYP.
    WA_FINAL-KNTTP = WA_EKPO-KNTTP.
    WA_FINAL-MWSKZ = WA_EKPO-MWSKZ.
    WA_FINAL-NETWR = WA_EKPO-NETWR.
    WA_FINAL-NETPR = WA_EKPO-NETPR.
    WA_FINAL-ELIKZ = WA_EKPO-ELIKZ.
    WA_FINAL-BSTAE = WA_EKPO-BSTAE. "Added By Nilay B on 06.03.2023

    IF WA_EKPO-LOEKZ = 'L'.
      WA_FINAL-DEL_IND = 'X'.
    ENDIF.

    READ TABLE IT_EIPA INTO WA_EIPA WITH KEY EBELN = WA_EKPO-EBELN EBELP = WA_EKPO-EBELP. """'ADDED BY SHREYA 09.05.22
    WA_FINAL-INFNR = WA_EIPA-INFNR.
    WA_FINAL-ESOKZ = WA_EIPA-ESOKZ.
    READ TABLE IT_EINA INTO WA_EINA WITH KEY INFNR = WA_EIPA-INFNR. "ADDED BY SHREYA 09.05.2022
    WA_FINAL-URZZT = WA_EINA-URZZT.


    LOOP AT IT_MSEG INTO WA_MSEG WHERE EBELN = WA_EKPO-EBELN AND EBELP = WA_EKPO-EBELP.
      READ TABLE IT_GRN INTO WA_GRN WITH KEY SMBLN = WA_MSEG-MBLNR EBELN = WA_MSEG-EBELN EBELP = WA_MSEG-EBELP.
      IF SY-SUBRC = 4.
        WA_FINAL-GRN_QTY = WA_FINAL-GRN_QTY + WA_MSEG-MENGE.
        WA_FINAL-DMBTR  = WA_FINAL-DMBTR + WA_MSEG-DMBTR.
      ENDIF.
      CLEAR: WA_MSEG.
    ENDLOOP.

    LOOP AT IT_EKPO_EKET INTO WA_EKPO_EKET WHERE EBELN = WA_EKPO-EBELN AND EBELP = WA_EKPO-EBELP.
      IF WA_EKPO_EKET-ELIKZ NE 'X' OR WA_EKPO_EKET-WEMNG NE 0.

        WA_FINAL-MENGE2 = WA_FINAL-MENGE2 + WA_EKPO_EKET-MENGE.
        WA_FINAL-PO_VAL = WA_FINAL-PO_VAL + WA_EKPO_EKET-NETWR.

      ENDIF.

      WA_FINAL-MENGE3 = WA_FINAL-MENGE3 + WA_EKPO_EKET-WEMNG.
    ENDLOOP.

    LOOP AT IT_EKPO1 INTO WA_EKPO1 WHERE EBELN = WA_EKPO-EBELN AND EBELP = WA_EKPO-EBELP.

      WA_FINAL-MENGE4 = WA_FINAL-MENGE4 + WA_EKPO1-MENGE.
      WA_FINAL-PO_VAL1 = WA_FINAL-PO_VAL1 + WA_EKPO1-NETWR.

    ENDLOOP.

    CLEAR WA_FINAL-PEND_PO_QTY.
    WA_FINAL-PEND_PO_QTY = WA_FINAL-MENGE2 - WA_FINAL-MENGE3 - WA_FINAL-MENGE4.
    WA_FINAL-PO_VAL2 =  WA_FINAL-PO_VAL - WA_FINAL-PO_VAL1.

    WA_FINAL-PO_VALUE = WA_FINAL-PO_VAL2 - WA_FINAL-DMBTR.

    IF WA_FINAL-PEND_PO_QTY LT 0.
      WA_FINAL-PEND_PO_QTY = 0.
    ENDIF.

    IF WA_FINAL-PO_VALUE LT 0.
      WA_FINAL-PO_VALUE = 0.
    ENDIF.



    READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_EKPO-EBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-EKORG = WA_EKKO-EKORG.
      WA_FINAL-LIFNR = WA_EKKO-LIFNR.
      WA_FINAL-AEDAT = WA_EKKO-AEDAT.
      WA_FINAL-WAERS = WA_EKKO-WAERS.
      WA_FINAL-BEDAT = WA_EKKO-BEDAT.
      WA_FINAL-ZTERM = WA_EKKO-ZTERM.
      WA_FINAL-EKGRP = WA_EKKO-EKGRP.
      WA_FINAL-SUBMI = WA_EKKO-SUBMI.
      WA_FINAL-BSART = WA_EKKO-BSART.
      WA_FINAL-WKURS = WA_EKKO-WKURS.
      WA_FINAL-FRGKE = WA_EKKO-FRGKE.
      WA_FINAL-MEMORY = WA_EKKO-MEMORY.

      IF WA_FINAL-FRGKE = '2'.
        WA_FINAL-FRGKE = 'Released'.
      ELSE.
        WA_FINAL-FRGKE = 'Not Released'.

      ENDIF.

      IF WA_FINAL-MEMORY = 'X'.
        WA_FINAL-MEMORY = 'Hold'.

      ELSE.

        WA_FINAL-MEMORY = ''.
      ENDIF.


    ENDIF.


    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_EKPO-EBELP .
      IF WA_KONV-KSCHL = 'PB00'.
        WA_FINAL-RATE = WA_KONV-KBETR.
      ELSEIF WA_KONV-KSCHL = 'P000'.
        WA_FINAL-RATE = WA_KONV-KBETR.
      ELSEIF WA_KONV-KSCHL = 'PBXX'.
        WA_FINAL-RATE = WA_KONV-KBETR.
      ENDIF.
      CLEAR: WA_KONV.
    ENDLOOP.
    WA_FINAL-BASIC = ( WA_FINAL-PEND_PO_QTY * WA_FINAL-RATE ) * WA_FINAL-WKURS.


    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_EKPO-EBELP .

***********PFWD******
      IF WA_KONV-KSCHL = 'ZPSA'.
        WA_FINAL-PF = ( WA_KONV-KBETR / 10 ) * WA_FINAL-BASIC.
        WA_FINAL-PF = WA_FINAL-PF / 100.
      ELSEIF WA_KONV-KSCHL = 'ZPFV'.
        WA_FINAL-PF = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY .
      ENDIF.



***********Insp Charges******
      IF WA_KONV-KSCHL = 'ZINS'.
        WA_FINAL-INSP = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY .
      ENDIF.

***********Setting charges*****
      IF WA_KONV-KSCHL = 'ZSCQ'.
        WA_FINAL-SETTING = WA_KONV-KBETR * WA_FINAL-PEND_PO_QTY.
      ELSEIF WA_KONV-KSCHL = 'ZSCV'.
        WA_FINAL-SETTING = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY.
      ENDIF.

************Freight Dom charges*****
*      IF WA_KONV-KSCHL = 'ZRC1'.
*        WA_FINAL-FREIGHT = WA_KONV-KBETR * WA_FINAL-PEND_PO_QTY.
*      ELSEIF WA_KONV-KSCHL = 'ZRB1'.
*        WA_FINAL-FREIGHT = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY.
*      ENDIF.
*
************Freight USD charges*****
      IF WA_KONV-KSCHL = 'FRB2'.
        WA_FINAL-FRE_USD = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY.
      ENDIF.

*      ***********Freight SAR charges*****
      IF WA_KONV-KSCHL = 'FRB1'.
        WA_FINAL-FRE_SAR = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY.
      ENDIF.

*      ***********Freight ACIF charges*****
      IF WA_KONV-KSCHL = 'ACIF'.
        WA_FINAL-ACIF = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY.
      ENDIF.

***********Insurance in USD*****
      IF WA_KONV-KSCHL = 'ZINR'.
        WA_FINAL-INS_USD = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY.
      ENDIF.


************Misc Charges in USD*****
*      IF wa_konv-kschl = 'ZFOB'.
*        wa_final-misc_usd = ( wa_konv-kwert / wa_final-menge ) * wa_final-pend_po_qty.
*      ENDIF.

***********Custom Duty%*****
      IF WA_KONV-KSCHL = 'JCDB'.
        WA_FINAL-CUST =  WA_KONV-KBETR / 10.
      ENDIF.

***********Social Wel. Surcharge%*****
*      IF wa_konv-kschl = 'ZSWS'.
*        wa_final-social =  wa_konv-kbetr / 10.
*      ENDIF.
*
      IF WA_KONV-KSCHL = 'ZCSS'.
        WA_FINAL-SOCIAL =  WA_KONV-KBETR / 10.
      ENDIF.

*****Ither Custom charges
      IF WA_KONV-KSCHL = 'OTCC'.
        WA_FINAL-OTHER_CUST_VAL =  WA_KONV-KBETR .
      ENDIF.

      IF WA_KONV-KSCHL = 'JEXS'.
        WA_FINAL-MWVS =  WA_KONV-KBETR .
      ENDIF.
**     ***others****************
*      IF WA_KONV-KSCHL = 'ZOC%'.
*        IF SY-SUBRC = 0.
*        WA_FINAL-OTHER = ( WA_KONV-KBETR / 10 ) * ( WA_FINAL-BASIC + WA_FINAL-PF + WA_FINAL-INSP + WA_FINAL-SETTING + WA_FINAL-FREIGHT ) ." * wa_final-basic.
*        WA_FINAL-OTHER = WA_FINAL-OTHER / 100.
*      ELSEIF WA_KONV-KSCHL = 'ZOCQ'.
*        WA_FINAL-OTHER = WA_KONV-KBETR * WA_FINAL-PEND_PO_QTY.
*      ELSEIF WA_KONV-KSCHL = 'ZOCV'.
*        WA_FINAL-OTHER = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_FINAL-PEND_PO_QTY.
*      .
*      ENDIF.
*      ENDIF.
      CLEAR: WA_KONV.
    ENDLOOP.
    CLEAR:WA_FINAL-FREIGHT.
*   ENDIF
*    ***others****************

*    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_EKPO-EBELP AND ( KSCHL = 'ZRC1' OR KSCHL = 'ZRB1' ).
*
*      IF WA_KONV-KSCHL = 'ZRC1'.
*        WA_FINAL-FREIGHT = WA_KONV-KBETR * WA_FINAL-PEND_PO_QTY..
*      ELSEIF WA_KONV-KSCHL = 'ZRB1'.
**        WA_FINAL-FREIGHT = ( WA_KONV-KWERT / WA_EKPO-MENGE ) * WA_MSEG-MENGE.
*        WA_FINAL-FREIGHT = ( WA_KONV-KWERT / WA_EKPO-MENGE ) * WA_FINAL-PEND_PO_QTY.
*      ENDIF.
*      CLEAR: WA_KONV.
*    ENDLOOP.
************************Added By Nilay on 15.12.2023*********************
    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_EKPO-EBELP AND KSCHL = 'ZOC%' OR KSCHL = 'ZOCQ' OR  KSCHL = 'ZOCV'.
      IF WA_KONV-KSCHL = 'ZOC%'.
        WA_FINAL-OTHER = ( WA_KONV-KBETR / 10 ) * ( WA_FINAL-BASIC + WA_FINAL-PF + WA_FINAL-INSP + WA_FINAL-SETTING + WA_FINAL-FRE_SAR ).
        WA_FINAL-OTHER = WA_FINAL-OTHER / 100.
      ELSEIF WA_KONV-KSCHL = 'ZOCQ'.
        WA_FINAL-OTHER = WA_KONV-KBETR * WA_MSEG-MENGE.
      ELSEIF WA_KONV-KSCHL = 'ZOCV'.
        WA_FINAL-OTHER = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_MSEG-MENGE.
      ENDIF.
      CLEAR: WA_KONV.
    ENDLOOP.

************************Ended By Nilay on 15.12.2023*********************


************************Added By Nilay on 15.12.2023*********************
    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_EKPO-EBELP AND ( KSCHL = 'ZDV%' OR KSCHL = 'ZDVQ' OR KSCHL = 'ZDVV') .
***********DEVP Charges*****

      IF WA_KONV-KSCHL = 'ZDV%'.
        WA_FINAL-DEVP = ( WA_KONV-KBETR / 10 ) * ( WA_FINAL-BASIC + WA_FINAL-PF + WA_FINAL-INSP + WA_FINAL-SETTING + WA_FINAL-FRE_SAR + WA_FINAL-OTHER ).
        WA_FINAL-DEVP = WA_FINAL-DEVP / 100.
      ELSEIF WA_KONV-KSCHL = 'ZDVQ'.
        WA_FINAL-DEVP = WA_KONV-KBETR * WA_MSEG-MENGE.
      ELSEIF WA_KONV-KSCHL = 'ZDVV'.
        WA_FINAL-DEVP = ( WA_KONV-KWERT / WA_FINAL-MENGE ) * WA_MSEG-MENGE.
      ENDIF.

      CLEAR: WA_KONV.
    ENDLOOP.
    CLEAR:WA_KONV.

************************ENded By Nilay on 15.12.2023*********************

***** Freight in INR*******
*    WA_FINAL-FRE_INR = WA_FINAL-FRE_USD * WA_FINAL-WKURS.
******Insurance in INR******
    WA_FINAL-INS_INR = WA_FINAL-INS_USD * WA_FINAL-WKURS.
*********Misc Charges INR*****
*    wa_final-misc_inr = wa_final-misc_usd * wa_final-wkurs.
********Ass. Value*******
    WA_FINAL-ASS_VAL = WA_FINAL-BASIC + WA_FINAL-PF + WA_FINAL-INSP + WA_FINAL-SETTING
                     + WA_FINAL-FRE_SAR + WA_FINAL-DEVP + WA_FINAL-INS_INR + WA_FINAL-OTHER + WA_FINAL-ACIF.
*********Custom Value*****
    WA_FINAL-CUST_VAL = ( WA_FINAL-CUST * WA_FINAL-ASS_VAL ) / 100.
**********Social Wel. Surcharge*****
    WA_FINAL-SOCIAL_VAL = ( WA_FINAL-SOCIAL * WA_FINAL-CUST_VAL ) / 100.

    LOOP AT IT_A991 INTO WA_A991 WHERE MWSKZ = WA_EKPO-MWSKZ.
      READ TABLE IT_KONP INTO WA_KONP WITH KEY KNUMH = WA_A991-KNUMH KSCHL = WA_A991-KSCHL.
      IF SY-SUBRC = 0.
        CASE WA_KONP-KSCHL.
          WHEN 'JICG'.
            WA_FINAL-CGST = WA_KONP-KBETR / 10.
          WHEN 'JISG'.
            WA_FINAL-SGST = WA_KONP-KBETR / 10.
          WHEN 'JIIG'.
            WA_FINAL-IGST = WA_KONP-KBETR / 10.
          WHEN 'JICN'.
            WA_FINAL-CRCM = WA_KONP-KBETR / 10.
          WHEN 'JISN'.
            WA_FINAL-SRCM = WA_KONP-KBETR / 10.
          WHEN 'JIIN'.
            WA_FINAL-IRCM = WA_KONP-KBETR / 10.
          WHEN 'MWVS'.
            WA_FINAL-MWVS = WA_KONP-KBETR / 10.

        ENDCASE.
      ENDIF.
      CLEAR: WA_A991,WA_KONP.
    ENDLOOP.


    WA_FINAL-CGST_VAL = ( WA_FINAL-ASS_VAL * WA_FINAL-CGST ) / 100.
    WA_FINAL-SGST_VAL = ( WA_FINAL-ASS_VAL * WA_FINAL-SGST ) / 100.
    WA_FINAL-IGST_VAL = ( ( WA_FINAL-ASS_VAL + WA_FINAL-CUST_VAL + WA_FINAL-SOCIAL_VAL ) * WA_FINAL-IGST ) / 100.
    WA_FINAL-CRCM_VAL = ( WA_FINAL-ASS_VAL * WA_FINAL-CRCM ) / 100.
    WA_FINAL-SRCM_VAL = ( WA_FINAL-ASS_VAL * WA_FINAL-SRCM ) / 100.
    WA_FINAL-IRCM_VAL = ( WA_FINAL-ASS_VAL * WA_FINAL-IRCM ) / 100.


    WA_FINAL-TAX_AMT  =  WA_FINAL-CUST_VAL + WA_FINAL-SOCIAL_VAL + WA_FINAL-OTHER_CUST_VAL + WA_FINAL-MWVS.


    WA_FINAL-GROSS = WA_FINAL-TAX_AMT + WA_FINAL-ASS_VAL.


    READ TABLE IT_T052U INTO WA_T052U WITH KEY ZTERM = WA_EKKO-ZTERM.
    IF SY-SUBRC = 0.
      WA_FINAL-TERM_DES = WA_T052U-TEXT1.
      CLEAR: WA_T052U.
    ENDIF.

    READ TABLE IT_T163X INTO WA_T163X WITH KEY PSTYP = WA_EKPO-PSTYP.
    IF SY-SUBRC = 0.
      WA_FINAL-EPSTP = WA_T163X-EPSTP.
      CLEAR: WA_T052U.

    ENDIF.

    READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
    IF SY-SUBRC = 0.
      WA_FINAL-XBLNR = WA_MKPF-XBLNR.
      WA_FINAL-BLDAT = WA_MKPF-BLDAT.
      CLEAR: WA_MKPF.
    ENDIF.


    READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_EKKO-LIFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-NAME1 = WA_LFA1-NAME1.
      WA_FINAL-STCD3 = WA_LFA1-STCD3.
      CLEAR: WA_LFA1.
    ENDIF.
    READ TABLE IT_J_1IMOVEND INTO WA_J_1IMOVEND WITH KEY LIFNR = WA_LFA1-LIFNR.
    IF  SY-SUBRC = 0.
      CASE WA_J_1IMOVEND-VEN_CLASS.
        WHEN ' '.
          WA_FINAL-VEN_CLASS = 'Registered'.
        WHEN '0'.
          WA_FINAL-VEN_CLASS = 'Not Registered'.
        WHEN '1'.
          WA_FINAL-VEN_CLASS = 'Compounding Scheme'.
      ENDCASE.
      CLEAR: WA_MKPF.
    ENDIF.

    READ TABLE IT_ZGST_REGION INTO WA_ZGST_REGION WITH KEY REGION = WA_LFA1-REGIO.
    IF SY-SUBRC = 0.
      WA_FINAL-GST_REGION = WA_ZGST_REGION-GST_REGION.
      CLEAR: WA_MKPF.
    ENDIF.

    READ TABLE IT_T005U INTO WA_T005U WITH KEY LAND1 = WA_LFA1-LAND1 BLAND = WA_LFA1-REGIO.
    IF SY-SUBRC = 0.
      WA_FINAL-BEZEI = WA_T005U-BEZEI.
      CLEAR: WA_MKPF.
    ENDIF.
*
*    LOOP AT it_rseg INTO wa_rseg WHERE ebeln = wa_ekpo-ebeln AND ebelp = wa_ekpo-ebelp.
*      wa_final-wrbtr   = wa_final-wrbtr   + wa_rseg-wrbtr.
*      wa_final-inv_qty = wa_final-inv_qty + wa_rseg-menge.
*    ENDLOOP.


    READ TABLE IT_T007S INTO WA_T007S WITH KEY MWSKZ = WA_EKPO-MWSKZ.
    IF SY-SUBRC = 0.
      WA_FINAL-TEXT1 = WA_T007S-TEXT1.
      CLEAR: WA_T007S.
    ENDIF.

*    CONCATENATE wa_rseg-belnr wa_rseg-gjahr INTO doc.


    READ TABLE IT_EKET INTO WA_EKET WITH KEY EBELN = WA_EKPO-EBELN

                                          EBELP = WA_EKPO-EBELP.
    IF SY-SUBRC = 0.
      WA_FINAL-EINDT = WA_EKET-EINDT.
      CLEAR: WA_EKET.
    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_EKPO-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART    = WA_MARA-MTART  .
      WA_FINAL-WRKST    = WA_MARA-WRKST  .
      WA_FINAL-ZSERIES  = WA_MARA-ZSERIES.
      WA_FINAL-ZSIZE    = WA_MARA-ZSIZE  .
      WA_FINAL-BRAND    = WA_MARA-BRAND  .
      WA_FINAL-MOC      = WA_MARA-MOC    .
      WA_FINAL-TYPE     = WA_MARA-TYPE   .
      CLEAR: WA_MARA.
    ENDIF.

    READ TABLE IT_MARC INTO WA_MARC WITH KEY MATNR = WA_EKPO-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-STEUC = WA_MARC-STEUC.
      CLEAR: WA_MARC.
    ENDIF.


*    READ TABLE it_rbkp INTO wa_rbkp WITH KEY belnr = wa_rseg-belnr.
*    IF sy-subrc = 0.
*      wa_final-bktxt = wa_rbkp-bktxt.
*      wa_final-zuonr = wa_rbkp-zuonr.
*      wa_final-miro_date = wa_rbkp-budat.
*    ENDIF.

    READ TABLE IT_ADRC INTO WA_ADRC WITH KEY ADDRNUMBER = WA_LFA1-ADRNR.
    IF SY-SUBRC = 0.
      CONCATENATE WA_ADRC-NAME1 WA_ADRC-CITY2 WA_ADRC-STREET WA_ADRC-STR_SUPPL3 WA_ADRC-LOCATION 'PIN:' WA_ADRC-POST_CODE1
                  INTO WA_FINAL-ADDRESS SEPARATED BY ','.

      CLEAR: WA_ADRC.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT,WA_LINES,LV_NAME.
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
          CONCATENATE WA_FINAL-MAT_TEXT WA_LINES-TDLINE INTO WA_FINAL-MAT_TEXT SEPARATED BY SPACE.
        ENDIF.
        CLEAR: WA_LINES.
      ENDLOOP.

    ENDIF.

    IF WA_EKPO-PSTYP = '9'.
      WA_FINAL-MAT_TEXT = WA_EKPO-TXZ01.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,WA_LINES,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-EBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'F22'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'EKKO'
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
          CONCATENATE WA_FINAL-CUST_DET WA_LINES-TDLINE INTO WA_FINAL-CUST_DET SEPARATED BY SPACE.
        ENDIF.
        CLEAR: WA_LINES.
      ENDLOOP.

    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,WA_LINES,LV_NAME.
    REFRESH LV_LINES.
*      lv_name = wa_final-ebeln.
    CONCATENATE WA_FINAL-EBELN WA_FINAL-EBELP INTO LV_NAME.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'F08'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'EKPO'
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
          CONCATENATE WA_FINAL-CTBG WA_LINES-TDLINE INTO WA_FINAL-CTBG SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.

    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,WA_LINES,LV_NAME.
    REFRESH LV_LINES.
*      lv_name = wa_final-ebeln.
    CONCATENATE WA_FINAL-EBELN WA_FINAL-EBELP INTO LV_NAME.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'F07'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'EKPO'
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
          CONCATENATE WA_FINAL-OLD_PO WA_LINES-TDLINE INTO WA_FINAL-OLD_PO SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.

    ENDIF.


    APPEND WA_FINAL TO IT_FINAL.

    DELETE IT_FINAL WHERE PEND_PO_QTY IS INITIAL.


    CLEAR: DOC,WA_BKPF,WA_RSEG,WA_QAMB,WA_QALS,WA_QUAL,WA_MSEG,WA_MKPF,WA_KONV.
    CLEAR:WA_FINAL,WA_EKKO.
  ENDLOOP.


  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.

      LS_FINAL-EKORG = WA_FINAL-EKORG.
      LS_FINAL-EKGRP = WA_FINAL-EKGRP.
      LS_FINAL-LIFNR = WA_FINAL-LIFNR.
      LS_FINAL-NAME1 = WA_FINAL-NAME1.
      LS_FINAL-STCD3 = WA_FINAL-STCD3.
*      LS_FINAL-BEZEI = WA_FINAL-BEZEI.
      LS_FINAL-EBELN = WA_FINAL-EBELN.
      LS_FINAL-EBELP = WA_FINAL-EBELP.

      LS_FINAL-MATNR       = WA_FINAL-MATNR      .
      LS_FINAL-MAT_TEXT    = WA_FINAL-MAT_TEXT   .
      LS_FINAL-MTART       = WA_FINAL-MTART      .
      LS_FINAL-STEUC       = WA_FINAL-STEUC      .
      LS_FINAL-MENGE       = WA_FINAL-MENGE      .
      LS_FINAL-PEND_PO_QTY = WA_FINAL-PEND_PO_QTY.
      LS_FINAL-WAERS       = WA_FINAL-WAERS      .
      LS_FINAL-WKURS       = WA_FINAL-WKURS      .
      LS_FINAL-RATE        = WA_FINAL-RATE       .
      LS_FINAL-BASIC       = WA_FINAL-BASIC      .
      LS_FINAL-PF          = WA_FINAL-PF         .
      LS_FINAL-INSP        = WA_FINAL-INSP       .

      LS_FINAL-SETTING         = WA_FINAL-SETTING       .
*      LS_FINAL-FREIGHT         = WA_FINAL-FREIGHT       .
      LS_FINAL-FRE_SAR         = WA_FINAL-FRE_SAR       .
      LS_FINAL-FRE_USD         = WA_FINAL-FRE_USD       .
*      LS_FINAL-FRE_INR         = WA_FINAL-FRE_INR       .
      LS_FINAL-DEVP            = WA_FINAL-DEVP          .
*      LS_FINAL-INS_USD         = WA_FINAL-INS_USD       .
      LS_FINAL-INS_INR         = WA_FINAL-INS_INR       .
      LS_FINAL-OTHER           = WA_FINAL-OTHER         .
      LS_FINAL-ASS_VAL           = WA_FINAL-ASS_VAL         .
      LS_FINAL-MWSKZ             = WA_FINAL-MWSKZ           .
      LS_FINAL-TEXT1             = WA_FINAL-TEXT1           .
      LS_FINAL-CUST              = WA_FINAL-CUST            .
      LS_FINAL-CUST_VAL          = WA_FINAL-CUST_VAL        .
      LS_FINAL-SOCIAL            = WA_FINAL-SOCIAL          .
      LS_FINAL-SOCIAL_VAL        = WA_FINAL-SOCIAL_VAL      .
      LS_FINAL-OTHER_CUST_VAL    = WA_FINAL-OTHER_CUST_VAL      .
      LS_FINAL-TAX_AMT           = WA_FINAL-TAX_AMT         .
      LS_FINAL-GROSS              = WA_FINAL-GROSS            .
      LS_FINAL-BRAND              = WA_FINAL-BRAND            .
      LS_FINAL-ZSIZE              = WA_FINAL-ZSIZE            .
      LS_FINAL-MOC                = WA_FINAL-MOC              .
      LS_FINAL-TYPE               = WA_FINAL-TYPE             .
      LS_FINAL-ZSERIES            = WA_FINAL-ZSERIES          .
      LS_FINAL-BSART              = WA_FINAL-BSART            .

      IF WA_FINAL-AEDAT IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-AEDAT
          IMPORTING
            OUTPUT = LS_FINAL-AEDAT.

        CONCATENATE LS_FINAL-AEDAT+0(2) LS_FINAL-AEDAT+2(3) LS_FINAL-AEDAT+5(4)
                        INTO LS_FINAL-AEDAT SEPARATED BY '-'.

      ENDIF.

      IF WA_FINAL-EINDT IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-EINDT
          IMPORTING
            OUTPUT = LS_FINAL-EINDT.

        CONCATENATE LS_FINAL-EINDT+0(2) LS_FINAL-EINDT+2(3) LS_FINAL-EINDT+5(4)
                        INTO LS_FINAL-EINDT SEPARATED BY '-'.

      ENDIF.



      LS_FINAL-FRGKE = WA_FINAL-FRGKE.
      LS_FINAL-MEMORY = WA_FINAL-MEMORY.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = LS_FINAL-REF.

      CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                      INTO LS_FINAL-REF SEPARATED BY '-'.


      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO LS_FINAL-TIME SEPARATED BY ':'.

      "ls_final-infnr = wa_final-infnr.
      LS_FINAL-URZZT = WA_FINAL-URZZT.

      LS_FINAL-BSTAE = WA_FINAL-BSTAE.  "Added By Nilay B. 0n 06.03.2023
      LS_FINAL-INFNR = WA_FINAL-INFNR.  "Added By Nilay B. 0n 06.03.2023
      LS_FINAL-ESOKZ = WA_FINAL-ESOKZ.  "Added By Nilay B. 0n 06.03.2023


      IF WA_FINAL-BEDAT IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BEDAT
          IMPORTING
            OUTPUT = LS_FINAL-BEDAT.

        CONCATENATE LS_FINAL-BEDAT+0(2) LS_FINAL-BEDAT+2(3) LS_FINAL-BEDAT+5(4)
                        INTO LS_FINAL-BEDAT SEPARATED BY '-'.

      ENDIF.

      LS_FINAL-ACIF = WA_FINAL-ACIF.

      APPEND LS_FINAL TO LT_FINAL.
      CLEAR: LS_FINAL, WA_FINAL.
    ENDLOOP.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
  PERFORM FCAT USING : '1'   'EKORG'           'IT_FINAL'      'Purchase Org'                 '20' ,
                       '2'   'EKGRP'           'IT_FINAL'      'Purchasing Group '            '20' ,
                       '3'   'LIFNR'           'IT_FINAL'      'Vendor'                       '20',
                       '4'   'NAME1'           'IT_FINAL'      'Vendor Name'                  '20' ,
                       '5'   'STCD3'           'IT_FINAL'      'VAT Reg. Code'                     '10',
*                       '6'   'BEZEI'           'IT_FINAL'      'Vendor State'                 '20' ,
                       '7'   'EBELN'           'IT_FINAL'      'Purchasing Document'          '20',
                       '8'   'AEDAT'           'IT_FINAL'      'PO Date'                      '20',
                       '9'   'EBELP'           'IT_FINAL'      'PO Line Item'                 '20',
                       '10'  'MATNR'           'IT_FINAL'      'Item Code'                    '20',
                       '11'  'MAT_TEXT'        'IT_FINAL'      'Item Description '            '25',
                       '12'  'MTART'           'IT_FINAL'      'Material Type'                '20',
                       '13'  'STEUC'           'IT_FINAL'      'HS Code'                     '10',
                       '14'  'EINDT'           'IT_FINAL'      'Delivery Date'                '15',
                       '15'  'MENGE'           'IT_FINAL'      'PO Qty'                       '20',
                       '16'  'PEND_PO_QTY'     'IT_FINAL'      'Pending Po Quantity'          '20',
                       '17'  'WAERS'           'IT_FINAL'      'PO.Currency'                  '10',
                       '18'  'WKURS'           'IT_FINAL'      'Exchange Rate'                '10',
                       '19'  'RATE'            'IT_FINAL'      'Rate/Unit'                    '10',
                       '20'  'BASIC'           'IT_FINAL'      'Basic Amt(SAR)'                    '10',
                       '21'  'PF'              'IT_FINAL'      'PFwd'                         '10',
                       '22'  'INSP'            'IT_FINAL'      'Insp Charges'                 '10',
                       '23'  'SETTING'         'IT_FINAL'      'Setting Charges'              '10',
*                       '24'  'FREIGHT'         'IT_FINAL'      'Freight Dom'                  '10',
                       '25'  'FRE_USD'         'IT_FINAL'      'Freight in USD'               '10',
                       '26'  'FRE_SAR'         'IT_FINAL'      'Freight in SAR'               '10',
                       '27'  'DEVP'            'IT_FINAL'      'Devp. Charges'                '10',
                       '28'  'ACIF'            'IT_FINAL'      'ACIF Value'                          '10',
                       '29'  'INS_INR'         'IT_FINAL'      'Insurance in SAR'             '10',
                       '30'  'OTHER'           'IT_FINAL'      'Others'                       '10',
                       '33'  'ASS_VAL'         'IT_FINAL'      'Ass. Value'                   '10',
                       '34'  'MWSKZ'           'IT_FINAL'      'Tax Code'                     '10',
                       '35'  'TEXT1'           'IT_FINAL'      'Tax Code Desc.'               '18',
                       '36'  'CUST'            'IT_FINAL'      'In Basic Custom Duty%'                 '18',
                       '37'  'CUST_VAL'        'IT_FINAL'      'In Basic Custom Duty Value'            '18',
                       '38'  'SOCIAL'          'IT_FINAL'      'Cess On Custom Duty%'       '18',
                       '39'  'SOCIAL_VAL'      'IT_FINAL'      'Cess On Custom Duty Value'        '18',
                       '40'  'OTHER_CUST_VAL'  'IT_FINAL'      'Other Custom Charges'        '18',
                       '52'  'TAX_AMT'         'IT_FINAL'      'Tax Amount'                   '18',
                       '53'  'GROSS'           'IT_FINAL'      'Gross Amount'                 '18',
                       '54'  'BRAND'           'IT_FINAL'      'BRAND'                        '10',
                       '55'  'ZSIZE'           'IT_FINAL'      'SIZE'                         '10',
                       '56'  'MOC'             'IT_FINAL'      'MOC'                          '10',
                       '57'  'TYPE'            'IT_FINAL'      'TYPE'                         '10',
                       '58'  'ZSERIES'         'IT_FINAL'      'SERIES'                       '10',
                       '59'   'BSART'          'IT_FINAL'      'Purchase Order Type'          '20',
                       '60'   'FRGKE'          'IT_FINAL'      'Release Status'          '20',
                       '61'   'MEMORY'          'IT_FINAL'      'Hold Status'          '20',
                       '62'  'URZZT'          'IT_FINAL'      'Component Weight Column'       '20',
                        '63'  'INFNR'          'IT_FINAL'      'Info Record  '       '20',
                        '64'  'ESOKZ'          'IT_FINAL'      'Info Record Type'       '20',
                        '65'  'BSTAE'          'IT_FINAL'      'Confirmation control key'       '20',
                        '66'  'BEDAT'          'IT_FINAL'      'PO Creation Date'                  '20'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1083   text
*      -->P_1084   text
*      -->P_1085   text
*      -->P_1086   text
*      -->P_1087   text
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
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZSU_PENDPO.TXT'.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PENDPO REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1887 TYPE string.
DATA lv_crlf_1887 TYPE string.
lv_crlf_1887 = cl_abap_char_utilities=>cr_lf.
lv_string_1887 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1887 lv_crlf_1887 wa_csv INTO lv_string_1887.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_576 TO lv_fullfile.
TRANSFER lv_string_1887 TO lv_fullfile.
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZSU_PENDPO.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PENDPO REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1925 TYPE string.
DATA lv_crlf_1925 TYPE string.
lv_crlf_1925 = cl_abap_char_utilities=>cr_lf.
lv_string_1925 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1925 lv_crlf_1925 wa_csv INTO lv_string_1925.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_576 TO lv_fullfile.
TRANSFER lv_string_1925 TO lv_fullfile.
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
  CONCATENATE 'Purchase Org'
              'Purchasing Group '
              'Vendor'
              'Vendor Name'
              'VAT Reg. Code'
*              'Vendor State'
              'Purchasing Document'
              'PO Date'
              'PO Line Item'
              'Item Code'
              'Item Description '
              'Material Type'
              'HS Code'
              'Delivery Date'
              'PO Qty'
              'Pending Po Quantity'
              'PO.Currency'
              'Exchange Rate'
              'Rate/Unit'
              'Basic Amt(SAR)'
              'PFwd'
              'Insp Charges'
              'Setting Charges'
*              'Freight Dom'
              'Freight in SAR'
              'Freight in USD'
              'Devp. Charges'
              'Insurance'
              'Others'
              'Ass. Value'
              'Tax Code'
              'Tax Code Desc.'
              'In Basic Custom Duty%'
              'In Basic Custom Duty Value'
              'Cess Custom%'
              'Cess Custom Value'
              'Other Custom Charges'
              'Tax Amount'
              'Gross Amount'
              'BRAND'
              'SIZE'
              'MOC'
              'TYPE'
              'SERIES'
              'Purchase Order Type'
              'Release Status'
              'Hold Status'
              'Component Weight Column'
              'Confirmation Control Key'
              'Info Record'
              'Info Record Type'
              'Refresh Date'
              'Refresh Time'
              'Po Creation Date'
              'ACIF Value'
                INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
