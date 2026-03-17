*&---------------------------------------------------------------------*
*& Report ZUSA_PEND_SO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUSA_PEND_SO_NEW.


TABLES: VBRP,VBAK,VBAP.

TYPES: BEGIN OF TY_DATA,
         VBELN  TYPE VBELN,
         POSNR  TYPE POSNR,
         ZBSTKD TYPE ZBSTKD,
         ZPOSEX TYPE ZPOSEX,

       END OF TY_DATA.

TYPES : BEGIN OF TY_VBAKP,
          VBELN    TYPE VBAK-VBELN,
          POSNR_I  TYPE VBAP-POSNR,
          ERDAT    TYPE VBAK-ERDAT,
          ERNAM    TYPE VBAK-ERNAM,
          AUDAT    TYPE VBAK-AUDAT,
          VBTYP    TYPE VBAK-VBTYP,
          AUART    TYPE VBAK-AUART,
          NETWR    TYPE VBAK-NETWR,
          WAERK    TYPE VBAK-WAERK,
          VKORG    TYPE VBAK-VKORG,
          VTWEG    TYPE VBAK-VTWEG,
          VKBUR    TYPE VBAK-VKBUR,
          KNUMV    TYPE VBAK-KNUMV,
          VDATU    TYPE VBAK-VDATU,
          BSTNK    TYPE VBAK-BSTNK,
          BSTDK    TYPE VBAK-BSTDK,
          BNAME    TYPE VBAK-BNAME,
          KUNNR    TYPE VBAK-KUNNR,
          VGBEL    TYPE VBAK-VGBEL,
          OBJNR    TYPE VBAK-OBJNR,
          MATNR_I  TYPE VBAP-MATNR,
          MATKL_I  TYPE VBAP-MATKL,
          ARKTX_I  TYPE VBAP-ARKTX,
          ABGRU_I  TYPE VBAP-ABGRU,
          KWMENG_I TYPE VBAP-KWMENG,
          WERKS_I  TYPE VBAP-WERKS,
        END OF TY_VBAKP,

        BEGIN OF TY_VBAP,
          VBELN          TYPE VBAP-VBELN,
          POSNR          TYPE VBAP-POSNR,
          MATNR          TYPE VBAP-MATNR,
          HOLDDATE       TYPE VBAP-HOLDDATE,
          HOLDRELDATE    TYPE VBAP-HOLDRELDATE,
          CANCELDATE     TYPE VBAP-CANCELDATE,
          DELDATE        TYPE VBAP-DELDATE,
          CUSTDELDATE    TYPE VBAP-CUSTDELDATE,
          POSEX          TYPE VBAP-POSEX,
          ERNAM          TYPE VBAP-ERNAM,
          ERDAT1         TYPE VBAP-ERDAT,
*          zmrp_delay  TYPE vbap-zmrp_delay,
          ZWHSE_BACK     TYPE VBAP-ZWHSE_BACK,
          ZASSM_BACK     TYPE VBAP-ZASSM_BACK,
          ZTRAN_DELAY    TYPE VBAP-ZTRAN_DELAY,
          ZLCL_DELAYS    TYPE VBAP-ZLCL_DELAYS,
          ZOTHER_COMMENT TYPE VBAP-ZOTHER_COMMENT,
          ZOTHER_REMARK  TYPE VBAP-ZOTHER_REMARK,
        END OF TY_VBAP,

        BEGIN OF TY_KONV,
          KNUMV TYPE PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE PRCD_ELEMENTS-KPOSN,
          KSCHL TYPE PRCD_ELEMENTS-KSCHL,
          KBETR TYPE PRCD_ELEMENTS-KBETR,
          WAERS TYPE PRCD_ELEMENTS-WAERS,
          KINAK TYPE PRCD_ELEMENTS-KINAK,
          KGRPE TYPE PRCD_ELEMENTS-KGRPE,
        END OF TY_KONV,

        BEGIN OF TY_KNA1,
          KUNNR TYPE KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
          ADRNR TYPE KNA1-ADRNR,
          BRSCH TYPE KNA1-BRSCH,
        END OF TY_KNA1,

        BEGIN OF TY_SHIP,
          KUNNR TYPE KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
          STRAS TYPE KNA1-STRAS,
          PSTLZ TYPE KNA1-PSTLZ,
          ORT01 TYPE KNA1-ORT01,
          REGIO TYPE KNA1-REGIO,
          LAND1 TYPE KNA1-LAND1,
        END OF TY_SHIP,

        BEGIN OF TY_T005U,
          SPRAS TYPE T005U-SPRAS,
          LAND1 TYPE T005U-LAND1,
          BLAND TYPE T005U-BLAND,
          BEZEI TYPE T005U-BEZEI,
        END OF TY_T005U,

        BEGIN OF TY_T005T,
          SPRAS TYPE T005T-SPRAS,
          LAND1 TYPE T005T-LAND1,
          LANDX TYPE T005T-LANDX,
        END OF TY_T005T,

        BEGIN OF TY_VBRK,
          VBELN TYPE VBRK-VBELN,
          FKART TYPE VBRK-FKART,
          FKTYP TYPE VBRK-FKTYP,
          VKORG TYPE VBRK-VKORG,
          VTWEG TYPE VBRK-VTWEG,
          FKDAT TYPE VBRK-FKDAT,
          FKSTO TYPE VBRK-FKSTO,
        END OF TY_VBRK,

        BEGIN OF TY_VBPA,
          VBELN TYPE VBPA-VBELN,
          POSNR TYPE VBPA-POSNR,
          KUNNR TYPE VBPA-KUNNR,
          PARVW TYPE VBPA-PARVW,
        END OF TY_VBPA,

        BEGIN OF TY_VBFA,
          VBELV   TYPE VBFA-VBELV,
          POSNV   TYPE VBFA-POSNV,
          VBELN   TYPE VBFA-VBELN,
          VBTYP_N TYPE VBFA-VBTYP_N,
          ERDAT   TYPE VBFA-ERDAT,
        END OF TY_VBFA,

        BEGIN OF TY_VBKD,
          VBELN TYPE VBKD-VBELN,
          POSNR TYPE VBKD-POSNR,
          INCO1 TYPE VBKD-INCO1,
          INCO2 TYPE VBKD-INCO2,
          ZTERM TYPE VBKD-ZTERM,
          KURSK TYPE VBKD-KURSK,
          BSTKD TYPE VBKD-BSTKD,
        END OF TY_VBKD,


        BEGIN OF TY_KNVV,
          KUNNR TYPE KNVV-KUNNR,
          KDGRP TYPE KNVV-KDGRP,
          BZIRK TYPE KNVV-BZIRK,
          VKBUR TYPE KNVV-VKBUR,
        END OF TY_KNVV,

        BEGIN OF TY_T151T,
          SPRAS TYPE T151T-SPRAS,
          KDGRP TYPE T151T-KDGRP,
          KTEXT TYPE T151T-KTEXT,
        END OF TY_T151T,

        BEGIN OF TY_T016T,
          SPRAS TYPE T016T-SPRAS,
          BRSCH TYPE T016T-BRSCH,
          BRTXT TYPE T016T-BRTXT,
        END OF TY_T016T,

        BEGIN OF TY_JEST,
          OBJNR TYPE JEST-OBJNR,
          STAT  TYPE JEST-STAT,
          CHGNR TYPE JEST-CHGNR,
          INACT TYPE JEST-INACT,
        END OF TY_JEST,

        BEGIN OF TY_TJ30T,
          STSMA TYPE TJ30T-STSMA,
          ESTAT TYPE TJ30T-ESTAT,
          SPRAS TYPE TJ30T-SPRAS,
          TXT30 TYPE TJ30T-TXT30,
        END OF TY_TJ30T,

        BEGIN OF TY_MARA,
          MATNR   TYPE MARA-MATNR,
          MTART   TYPE MARA-MTART,
          MATKL   TYPE MARA-MATKL,
          WRKST   TYPE MARA-WRKST,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          BRAND   TYPE MARA-BRAND,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
        END OF TY_MARA,

        BEGIN OF TY_MBEW ,
          MATNR TYPE MBEW-MATNR,
          BWKEY TYPE MBEW-BWKEY,
          LBKUM TYPE MBEW-LBKUM,
          SALK3 TYPE MBEW-SALK3,
          VPRSV TYPE MBEW-VPRSV,
          VERPR TYPE MBEW-VERPR,
          STPRS TYPE MBEW-STPRS,
          BKLAS TYPE MBEW-BKLAS,
        END OF TY_MBEW,

        BEGIN OF TY_MARC,
          MATNR TYPE MARC-MATNR,
          WERKS TYPE MARC-WERKS,
          DISPO TYPE MARC-DISPO,
        END OF TY_MARC,

        BEGIN OF TY_VBEP,
          VBELN TYPE VBEP-VBELN,
          POSNR TYPE VBEP-POSNR,
          ETENR TYPE VBEP-ETENR,
          ETTYP TYPE VBEP-ETTYP,
          EDATU TYPE VBEP-EDATU,
        END OF TY_VBEP,

        BEGIN OF TY_TVZBT,
          SPRAS TYPE TVZBT-SPRAS,
          ZTERM TYPE TVZBT-ZTERM,
          VTEXT TYPE TVZBT-VTEXT,
        END OF TY_TVZBT,

        BEGIN OF TY_TVAGT,
          SPRAS TYPE  TVAGT-SPRAS,
          ABGRU TYPE  TVAGT-ABGRU,
          BEZEI TYPE  TVAGT-BEZEI,
        END OF TY_TVAGT,

        BEGIN OF TY_LIPS,
          VBELN TYPE LIPS-VBELN,
          POSNR TYPE LIPS-POSNR,
          VGBEL TYPE LIPS-VGBEL,
          MBDAT TYPE LIPS-MBDAT,
        END OF TY_LIPS,




        BEGIN OF TY_FINAL,
          WERKS             TYPE VBAP-WERKS,
          AUART             TYPE VBAK-AUART,
          BSTNK             TYPE VBAK-BSTNK,
          BSTDK             TYPE VBAK-BSTDK,
          KUNNR             TYPE VBAK-KUNNR,
          NAME1             TYPE KNA1-NAME1,
          PARTNER           TYPE KNA1-KUNNR,
          PART_NAME         TYPE KNA1-NAME1,
          KDGRP             TYPE KNVV-KDGRP,
          KTEXT             TYPE T151T-KTEXT,
          BRSCH             TYPE T016T-BRSCH,
          BRTXT             TYPE T016T-BRTXT,
          VKBUR             TYPE VBAK-VKBUR,
          VBELN             TYPE VBAK-VBELN,
          ERDAT             TYPE VBAK-ERDAT,
          VDATU             TYPE VBAK-VDATU,
          STATUS            TYPE TJ30T-TXT30,
          HOLDDATE          TYPE VBAP-HOLDDATE,
          HOLDRELDATE       TYPE VBAP-HOLDRELDATE,
          CANCELDATE        TYPE VBAP-CANCELDATE,
          DELDATE           TYPE VBFA-ERDAT, "vbap-deldate,
          TPI               TYPE CHAR100,
          TAG_REQ           TYPE CHAR100,
          LD_TXT            TYPE STRING,
          MATNR             TYPE MARA-MATNR,
          WRKST             TYPE MARA-WRKST,
          BKLAS             TYPE MBEW-BKLAS,
          POSNR             TYPE VBAP-POSNR,
          ARKTX             TYPE VBAP-ARKTX,
          MATTXT            TYPE TEXT100,
          KWMENG            TYPE VBAP-KWMENG,
          LFIMG             TYPE LIPS-LFIMG,
          FKIMG             TYPE VBRP-FKIMG,
          PND_QTY           TYPE VBRP-FKIMG,
          ETTYP             TYPE VBEP-ETTYP,
          EDATU             TYPE VBEP-EDATU,
          ETENR             TYPE VBEP-ETENR,
          KBETR             TYPE PRCD_ELEMENTS-KBETR,
          WAERK             TYPE VBAK-WAERK,
          AMONT             TYPE KBETR,
          ORDR_AMT          TYPE KBETR,
          STPRS             TYPE MBEW-STPRS,
          ZSERIES           TYPE MARA-ZSERIES,
          ZSIZE             TYPE MARA-ZSIZE,
          BRAND             TYPE MARA-BRAND,
          MOC               TYPE MARA-MOC,
          TYPE              TYPE MARA-TYPE,
          MTART             TYPE MARA-MTART,
          DISPO             TYPE MARC-DISPO,
          ZTERM             TYPE VBKD-ZTERM,
          TEXT1             TYPE T052U-TEXT1,
          INCO1             TYPE VBKD-INCO1,
          INCO2             TYPE VBKD-INCO2,
          CUSTDELDATE       TYPE VBAP-CUSTDELDATE,
          BNAME             TYPE VBAK-BNAME,
          ECCN              TYPE CHAR100,
          ABGRU             TYPE VBAP-ABGRU,
          BEZEI             TYPE  TVAGT-BEZEI,
          SHIP_CODE         TYPE KNA1-KUNNR,
          SHIP_NAME         TYPE KNA1-NAME1,
          STRAS             TYPE KNA1-STRAS,
          PSTLZ             TYPE KNA1-PSTLZ,
          ORT01             TYPE KNA1-ORT01,
          SHIP_RIG          TYPE T005U-BEZEI,
          SHIP_LAND         TYPE T005T-LANDX,
          UHF1              TYPE PRCD_ELEMENTS-KBETR,
          USC1              TYPE PRCD_ELEMENTS-KBETR,
          UMC1              TYPE PRCD_ELEMENTS-KBETR,
          HUHF1             TYPE PRCD_ELEMENTS-KBETR,
          HUSC1             TYPE PRCD_ELEMENTS-KBETR,
          HUMC1             TYPE PRCD_ELEMENTS-KBETR,
          SPL_INS           TYPE CHAR100,
          TAG_NO            TYPE CHAR100,             "added by pankaj 12.01.2022
          SHIP_FROM         TYPE CHAR100, "added by shreya 15-02-2022
          OFM_DATE_NEW      TYPE CHAR20, "added by shreya 17-03-2022
          MBDAT             TYPE LIPS-MBDAT,
          DELOYED_REMARK    TYPE STRING, """Added by Pranit 23.01.2024
          BSTKD             TYPE VBKD-BSTKD,      """Added by Pranit 04.02.2024
          POSEX             TYPE VBAP-POSEX,      """Added by Pranit 04.02.2024
          ZBSTKD            TYPE VBAP-ZBSTKD, """Added by Pranit 21.02.2024
          ZPOSEX            TYPE VBAP-ZPOSEX,  """Added by Pranit 21.02.2024
*          remark         TYPE char35,  """Added by Pranit 01.03.2024
          ERNAM             TYPE VBAP-ERNAM,  """Added by Pranit 27.03.2024
          ERDAT1            TYPE VBAP-ERDAT,  """Added by Pranit 27.03.2024
          REASON_HC         TYPE  CHAR20,                """added by supriya 17:06:2024
          DELAY_ITEM_REMARK TYPE STRING,      "added by aakashk 05.08.2024
          ZMRP_DELAY        TYPE CHAR250,
        END OF TY_FINAL,

        BEGIN OF TY_DOWN,
          WERKS             TYPE VBAP-WERKS,
          AUART             TYPE VBAK-AUART,
          BSTNK             TYPE VBAK-BSTNK,
          BSTDK             TYPE CHAR15,
          KUNNR             TYPE VBAK-KUNNR,
          NAME1             TYPE KNA1-NAME1,
          PARTNER           TYPE KNA1-KUNNR,
          PART_NAME         TYPE KNA1-NAME1,
          KDGRP             TYPE KNVV-KDGRP,
          KTEXT             TYPE T151T-KTEXT,
          BRSCH             TYPE T016T-BRSCH,
          BRTXT             TYPE T016T-BRTXT,
          VKBUR             TYPE VBAK-VKBUR,
          VBELN             TYPE VBAK-VBELN,
          ERDAT             TYPE CHAR15,
          VDATU             TYPE CHAR15,
          STATUS            TYPE TJ30T-TXT30,
          HOLDDATE          TYPE CHAR15,
          HOLDRELDATE       TYPE CHAR15,
          CANCELDATE        TYPE CHAR15,
          DELDATE           TYPE CHAR15,
          TPI               TYPE CHAR100,
          TAG_REQ           TYPE CHAR100,
          LD_TXT            TYPE CHAR250,
          MATNR             TYPE MARA-MATNR,
          WRKST             TYPE MARA-WRKST,
          BKLAS             TYPE MBEW-BKLAS,
          POSNR             TYPE VBAP-POSNR,
          ARKTX             TYPE VBAP-ARKTX,
          MATTXT            TYPE TEXT100,
          KWMENG            TYPE CHAR15,
          LFIMG             TYPE CHAR15,
          FKIMG             TYPE CHAR15,
          PND_QTY           TYPE CHAR15,
          ETTYP             TYPE VBEP-ETTYP,
          KBETR             TYPE CHAR15,
          WAERK             TYPE VBAK-WAERK,
          AMONT             TYPE CHAR15,
          ORDR_AMT          TYPE CHAR15,
          STPRS             TYPE CHAR15,
          ZSERIES           TYPE MARA-ZSERIES,
          ZSIZE             TYPE MARA-ZSIZE,
          BRAND             TYPE MARA-BRAND,
          MOC               TYPE MARA-MOC,
          TYPE              TYPE MARA-TYPE,
          DISPO             TYPE MARC-DISPO,
          MTART             TYPE MARA-MTART,
          ZTERM             TYPE VBKD-ZTERM,
          TEXT1             TYPE T052U-TEXT1,
          INCO1             TYPE VBKD-INCO1,
          INCO2             TYPE VBKD-INCO2,
          CUSTDELDATE       TYPE CHAR15,
          BNAME             TYPE VBAK-BNAME,
          ECCN              TYPE CHAR100,
          ABGRU             TYPE VBAP-ABGRU,
          BEZEI             TYPE  TVAGT-BEZEI,
          SHIP_CODE         TYPE KNA1-KUNNR,
          SHIP_NAME         TYPE KNA1-NAME1,
          STRAS             TYPE KNA1-STRAS,
          PSTLZ             TYPE KNA1-PSTLZ,
          ORT01             TYPE KNA1-ORT01,
          SHIP_RIG          TYPE T005U-BEZEI,
          SHIP_LAND         TYPE T005T-LANDX,
          UHF1              TYPE CHAR15,
          USC1              TYPE CHAR15,
          UMC1              TYPE CHAR15,
          HUHF1             TYPE CHAR15,
          HUSC1             TYPE CHAR15,
          HUMC1             TYPE CHAR15,
          SPL_INS           TYPE CHAR250,
          REF               TYPE CHAR15,
          REF_TIME          TYPE CHAR18,
          TAG_NO            TYPE CHAR250,             "added by pankaj 12.01.2022
          SHIP_FROM         TYPE CHAR250 ,          "added by shreya 15-02-2022
          OFM_DATE_NEW      TYPE CHAR20, "added by shreya 17-03-2022
          MBDAT             TYPE CHAR30,
          DELOYED_REMARK    TYPE STRING,     """Added by Pranit 23.01.2024 added by aakashk 05.08.2024
          BSTKD             TYPE VBKD-BSTKD, """Added by Pranit 04.02.2024
          POSEX             TYPE VBAP-POSEX, """Added by Pranit 04.02.2024
          ZBSTKD            TYPE VBAP-ZBSTKD,
          ZPOSEX            TYPE VBAP-ZPOSEX,
*          remark         TYPE char35,
          ERNAM             TYPE CHAR15,   """Added by Pranit 27.02.2024
          ERDAT1            TYPE CHAR15,   """Added by Pranit 27.02.2024
          REASON_HC         TYPE  CHAR20,                """added by supriya 17:06:2024
          DELAY_ITEM_REMARK TYPE STRING,    "added by aakashk 05.08.2024
          ZMRP_DELAY        TYPE STRING,    "added by PRANIT 19.11.2024

        END OF TY_DOWN.

DATA: IT_VBAKP   TYPE TABLE OF TY_VBAKP,
      WA_VBAKP   TYPE TY_VBAKP,

      IT_VBAP    TYPE TABLE OF TY_VBAP,
      WA_VBAP    TYPE          TY_VBAP,

      IT_KONV    TYPE TABLE OF TY_KONV,
      WA_KONV    TYPE  TY_KONV,

      IT_VBPA    TYPE TABLE OF TY_VBPA,
      WA_VBPA    TYPE TY_VBPA,

      IT_VBFA    TYPE TABLE OF TY_VBFA,
      WA_VBFA    TYPE  TY_VBFA,

      IT_VBRK    TYPE TABLE OF TY_VBRK,
      WA_VBRK    TYPE  TY_VBRK,

      IT_VBEP    TYPE TABLE OF TY_VBEP,
      WA_VBEP    TYPE TY_VBEP,

      IT_KNA1    TYPE TABLE OF TY_KNA1,
      WA_KNA1    TYPE          TY_KNA1,

      IT_TVAGT   TYPE TABLE OF TY_TVAGT,
      WA_TVAGT   TYPE TY_TVAGT,

      IT_PARTNER TYPE TABLE OF TY_KNA1,
      WA_PARTNER TYPE TY_KNA1,

      IT_MARA    TYPE TABLE OF TY_MARA,
      WA_MARA    TYPE          TY_MARA,

      IT_MBEW    TYPE TABLE OF TY_MBEW,
      WA_MBEW    TYPE          TY_MBEW,

      IT_MARC    TYPE TABLE OF TY_MARC,
      WA_MARC    TYPE          TY_MARC,

      IT_SHIP    TYPE TABLE OF TY_SHIP,
      WA_SHIP    TYPE TY_SHIP,

      IT_VBKD    TYPE TABLE OF TY_VBKD,
      WA_VBKD    TYPE  TY_VBKD,

      IT_T005U   TYPE TABLE OF TY_T005U,
      WA_T005U   TYPE TY_T005U,

      IT_T005T   TYPE TABLE OF TY_T005T,
      WA_T005T   TYPE TY_T005T,

      IT_KNVV    TYPE TABLE OF TY_KNVV,
      WA_KNVV    TYPE          TY_KNVV,

      IT_T151T   TYPE TABLE OF TY_T151T,
      WA_T151T   TYPE          TY_T151T,

      IT_T016T   TYPE TABLE OF TY_T016T,
      WA_T016T   TYPE          TY_T016T,

      IT_JEST    TYPE TABLE OF TY_JEST,
      WA_JEST    TYPE TY_JEST,

      IT_TJ30T   TYPE TABLE OF TY_TJ30T,
      WA_TJ30T   TYPE TY_TJ30T,

      IT_TVZBT   TYPE TABLE OF TY_TVZBT,
      WA_TVZBT   TYPE          TY_TVZBT,

      IT_LIPS    TYPE TABLE OF TY_LIPS,
      WA_LIPS    TYPE TY_LIPS,

      IT_DATA    TYPE STANDARD TABLE OF TY_DATA,
      WA_DATA    TYPE TY_DATA,

      IT_DELETE  TYPE STANDARD TABLE OF TY_DATA,
      WA_DELETE  TYPE TY_DATA,

      IT_DOWN    TYPE TABLE OF TY_DOWN,
      WA_DOWN    TYPE          TY_DOWN,

      IT_FINAL   TYPE TABLE OF TY_FINAL,
      WA_FINAL   TYPE          TY_FINAL.


DATA :LV_LINES TYPE STANDARD TABLE OF TLINE,
      WA_LINES LIKE TLINE,
      LV_NAME  TYPE THEAD-TDNAME.

DATA : WA_LFIMG     TYPE LIPS-LFIMG,
       WA_LFIMG_SUM TYPE LIPS-LFIMG,
       WA_FKIMG     TYPE LIPS-LFIMG,
       WA_FKIMG_SUM TYPE LIPS-LFIMG.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
      GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
      I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
      WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV..            " LAYOUT WORKAREA
DATA T_SORT TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .
    SELECT-OPTIONS   :  S_DATE FOR VBAK-ERDAT OBLIGATORY ,
                        S_MATNR FOR VBAP-MATNR,
                        S_KUNNR FOR VBAK-KUNNR,
                        S_VBELN FOR VBAP-VBELN,
                        S_DDATE FOR VBAP-CUSTDELDATE,
                        S_WERKS FOR VBAP-WERKS OBLIGATORY DEFAULT 'US01'.
*PARAMETERS : s_werks TYPE vbap-werks OBLIGATORY DEFAULT 'US01'.
  SELECTION-SCREEN END OF BLOCK B2.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/USA'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


START-OF-SELECTION .
  PERFORM GET_DATA.
  PERFORM SORT_DATA.
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

  SELECT A~VBELN A~POSNR A~ZBSTKD A~ZPOSEX
  INTO TABLE IT_DATA
  FROM  VBAP AS A
  JOIN  VBAP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
  WHERE A~ERDAT  IN S_DATE
  AND   A~MATNR  IN S_MATNR
  AND   A~WERKS  IN S_WERKS
  AND   A~VBELN  IN S_VBELN
  AND   A~CUSTDELDATE IN S_DDATE
  AND   B~LFSTA  NE 'C'.

  SELECT A~VBELN A~POSNR
          INTO TABLE IT_DELETE
          FROM  VBAP AS A
          JOIN  VBAP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
          JOIN VBAK AS C ON ( C~VBELN = A~VBELN )
          WHERE A~ERDAT  IN S_DATE
          AND   A~MATNR  IN S_MATNR
          AND   A~WERKS  IN S_WERKS
          AND   A~VBELN  IN S_VBELN
          AND   A~CUSTDELDATE IN S_DDATE
          AND   B~GBSTA  = 'C'
          AND   C~AUART IN ( 'US04', 'US05', 'US06' ).


  LOOP AT IT_DELETE INTO WA_DELETE .
    DELETE IT_DATA WHERE VBELN = WA_DELETE-VBELN AND POSNR = WA_DELETE-POSNR.
  ENDLOOP.

  SELECT A~VBELN A~POSNR
     APPENDING TABLE IT_DATA
     FROM  VBAP AS A
     JOIN  LIPSUP AS C ON ( C~VGBEL = A~VBELN  AND C~VGPOS = A~POSNR )
     WHERE A~ERDAT  IN S_DATE
     AND   A~MATNR  IN S_MATNR
     AND   A~WERKS  IN S_WERKS
     AND   A~VBELN  IN S_VBELN
     AND   A~CUSTDELDATE IN S_DDATE
     AND C~GBSTA NE 'C'.

  IF  IT_DATA IS NOT INITIAL .
    SELECT VBELN
           POSNR_I
           ERDAT
           ERNAM
           AUDAT
           VBTYP
           AUART
           NETWR
           WAERK
           VKORG
           VTWEG
           VKBUR
           KNUMV
           VDATU
           BSTNK
           BSTDK
           BNAME
           KUNNR
           VGBEL
           OBJNR
           MATNR_I
           MATKL_I
           ARKTX_I
           ABGRU_I
           KWMENG_I
           WERKS_I FROM WB2_V_VBAK_VBAP2 INTO TABLE IT_VBAKP
           FOR ALL ENTRIES IN IT_DATA
           WHERE VBELN = IT_DATA-VBELN
             AND POSNR_I = IT_DATA-POSNR.

  ENDIF.

  IF IT_VBAKP IS NOT INITIAL.


    SELECT VBELN
           POSNR
           MATNR
           HOLDDATE
           HOLDRELDATE
           CANCELDATE
           DELDATE
           CUSTDELDATE
           POSEX                    """Added by Pranit 04.02.2024
           ERNAM
           ERDAT
*           zmrp_delay
           ZWHSE_BACK
           ZASSM_BACK
           ZTRAN_DELAY
           ZLCL_DELAYS
           ZOTHER_COMMENT
           ZOTHER_REMARK
           FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE VBELN = IT_VBAKP-VBELN
             AND POSNR = IT_VBAKP-POSNR_I.

    SELECT VBELN
           POSNR
           VGBEL
           MBDAT
           FROM LIPS INTO TABLE IT_LIPS FOR ALL ENTRIES IN IT_VBAP WHERE VGBEL = IT_VBAP-VBELN
                                                                      AND POSNR = IT_VBAP-POSNR.



    SELECT KNUMV
           KPOSN
           KSCHL
           KBETR
           WAERS
           KINAK
           KGRPE
           FROM PRCD_ELEMENTS INTO TABLE IT_KONV
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE  KNUMV = IT_VBAKP-KNUMV
           AND KSCHL IN ( 'ZPR0' , 'VPRS' , 'ZESC', 'UHF1', 'USC1', 'UMC1' ).


    SELECT VBELN
           POSNR
           KUNNR
           PARVW
      FROM VBPA
      INTO TABLE IT_VBPA
      FOR ALL ENTRIES IN IT_VBAKP
      WHERE VBELN = IT_VBAKP-VBELN.

    SELECT VBELN
           POSNR
           INCO1
           INCO2
           ZTERM
           KURSK
           BSTKD
           FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE VBELN = IT_VBAKP-VBELN.





    SELECT VBELV
           POSNV
           VBELN
           VBTYP_N
           ERDAT
           FROM VBFA INTO TABLE IT_VBFA
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE VBELV = IT_VBAKP-VBELN
*             AND ( VBTYP_N = 'J' OR  VBTYP_N = 'M' ).
             AND  VBTYP_N IN ( 'J', 'M' ,'T' , 'O' ).

    SELECT KUNNR
           NAME1
           ADRNR
           BRSCH
           FROM KNA1 INTO TABLE IT_KNA1
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE KUNNR = IT_VBAKP-KUNNR.

    SELECT OBJNR
           STAT
           CHGNR
           INACT FROM JEST INTO TABLE IT_JEST
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE OBJNR = IT_VBAKP-OBJNR
             AND STAT IN ( 'E0001', 'E0002','E0003' )
             AND INACT NE 'X'.

    SELECT MATNR
           MTART
           MATKL
           WRKST
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE   FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE MATNR = IT_VBAKP-MATNR_I.

    SELECT MATNR
           BWKEY
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS
           BKLAS FROM MBEW INTO TABLE IT_MBEW
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE MATNR = IT_VBAKP-MATNR_I
            AND  BWKEY = IT_VBAKP-WERKS_I.

    SELECT MATNR
           WERKS
           DISPO FROM MARC INTO TABLE IT_MARC
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE MATNR = IT_VBAKP-MATNR_I
             AND WERKS = IT_VBAKP-WERKS_I.




    SELECT VBELN
           POSNR
           ETENR
           ETTYP
           EDATU
           FROM VBEP INTO TABLE IT_VBEP
           FOR ALL ENTRIES IN IT_VBAKP WHERE VBELN = IT_VBAKP-VBELN
                                       AND  POSNR = IT_VBAKP-POSNR_I.
    SORT IT_VBEP BY VBELN POSNR ETENR.

    SELECT SPRAS
           ABGRU
           BEZEI
           FROM TVAGT INTO TABLE IT_TVAGT
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE  ABGRU = IT_VBAKP-ABGRU_I
             AND SPRAS = 'E'.


  ENDIF.

  IF IT_VBPA IS NOT INITIAL.

    SELECT KUNNR
           NAME1
           ADRNR
           BRSCH
           FROM KNA1 INTO TABLE IT_PARTNER
           FOR ALL ENTRIES IN IT_VBPA
           WHERE KUNNR = IT_VBPA-KUNNR.

    SELECT  KUNNR
            NAME1
            STRAS
            PSTLZ
            ORT01
            REGIO
            LAND1 FROM KNA1 INTO TABLE IT_SHIP
            FOR ALL ENTRIES IN IT_VBPA
            WHERE KUNNR = IT_VBPA-KUNNR.

  ENDIF.

  IF IT_SHIP IS NOT INITIAL.
    SELECT SPRAS
           LAND1
           BLAND
           BEZEI FROM T005U INTO TABLE IT_T005U
           FOR ALL ENTRIES IN IT_SHIP
           WHERE SPRAS = 'EN'
            AND  LAND1 = IT_SHIP-LAND1
            AND  BLAND = IT_SHIP-REGIO.

    SELECT SPRAS
           LAND1
           LANDX FROM T005T INTO TABLE IT_T005T
           FOR ALL ENTRIES IN IT_SHIP
           WHERE SPRAS = 'EN'
            AND  LAND1 = IT_SHIP-LAND1.


  ENDIF.
  IF IT_KNA1 IS NOT INITIAL.
    SELECT KUNNR
           KDGRP
           BZIRK
           VKBUR FROM KNVV INTO TABLE IT_KNVV
           FOR ALL ENTRIES IN IT_KNA1
           WHERE KUNNR = IT_KNA1-KUNNR.

    SELECT SPRAS
           BRSCH
           BRTXT FROM T016T INTO TABLE IT_T016T
           FOR ALL ENTRIES IN IT_KNA1
           WHERE BRSCH = IT_KNA1-BRSCH.
  ENDIF.

  IF IT_KNVV IS NOT INITIAL.
    SELECT SPRAS
           KDGRP
           KTEXT FROM T151T INTO TABLE IT_T151T
           FOR ALL ENTRIES IN IT_KNVV
           WHERE SPRAS = 'E'
            AND  KDGRP = IT_KNVV-KDGRP.
  ENDIF.
  IF IT_JEST IS NOT INITIAL.
    SELECT STSMA
           ESTAT
           SPRAS
           TXT30 FROM TJ30T INTO TABLE IT_TJ30T
           FOR ALL ENTRIES IN IT_JEST
           WHERE ESTAT = IT_JEST-STAT
           AND STSMA  = 'OR_ITEM' .


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
             AND FKSTO NE 'X'.
  ENDIF.

  IF IT_VBKD IS NOT INITIAL.
    SELECT SPRAS
           ZTERM
           VTEXT FROM TVZBT INTO TABLE IT_TVZBT
           FOR ALL ENTRIES IN IT_VBKD
           WHERE ZTERM = IT_VBKD-ZTERM
            AND SPRAS = 'EN'.

  ENDIF.

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
  SORT IT_VBAKP BY VBELN POSNR_I.
  LOOP AT IT_VBAKP INTO WA_VBAKP.
    WA_FINAL-WERKS       = WA_VBAKP-WERKS_I.
    WA_FINAL-AUART       = WA_VBAKP-AUART.
    WA_FINAL-BSTNK       = WA_VBAKP-BSTNK.
    WA_FINAL-BSTDK       = WA_VBAKP-BSTDK.
    WA_FINAL-KUNNR       = WA_VBAKP-KUNNR.
    WA_FINAL-VKBUR       = WA_VBAKP-VKBUR.
    WA_FINAL-ERDAT       = WA_VBAKP-ERDAT.
    WA_FINAL-VDATU       = WA_VBAKP-VDATU.
    WA_FINAL-MATNR       = WA_VBAKP-MATNR_I.
    WA_FINAL-POSNR       = WA_VBAKP-POSNR_I.
    WA_FINAL-ARKTX       = WA_VBAKP-ARKTX_I.
    WA_FINAL-KWMENG      = WA_VBAKP-KWMENG_I.
    WA_FINAL-WAERK       = WA_VBAKP-WAERK.
    WA_FINAL-BNAME       = WA_VBAKP-BNAME.
    WA_FINAL-ABGRU       = WA_VBAKP-ABGRU_I.
    WA_FINAL-VBELN       = WA_VBAKP-VBELN.


    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_VBAKP-VBELN POSNR = WA_VBAKP-POSNR_I.
    IF SY-SUBRC = 0.
      WA_FINAL-HOLDDATE     =  WA_VBAP-HOLDDATE   .
      WA_FINAL-HOLDRELDATE  =  WA_VBAP-HOLDRELDATE.
      WA_FINAL-CANCELDATE   =  WA_VBAP-CANCELDATE .
      WA_FINAL-DELDATE      =  WA_VBAP-DELDATE    .
      WA_FINAL-CUSTDELDATE  =  WA_VBAP-CUSTDELDATE .
      WA_FINAL-POSEX        =  WA_VBAP-POSEX .
      WA_FINAL-ERNAM        =  WA_VBAP-ERNAM  .       ""Added by Pranit 27.03.2024
      WA_FINAL-ERDAT1       =  WA_VBAP-ERDAT1 .       ""Added by Pranit 27.03.2024

*      IF wa_vbap-zmrp_delay EQ 'WHSE_BACK'.           ""Added by Pranit 19.11.2024
*        wa_final-zmrp_delay = 'Whse Backlog'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'ASSEM_BACK'.
*        wa_final-zmrp_delay = 'Assembly Backlog'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'TRAN_DELAY'.
*        wa_final-zmrp_delay = 'Transit Delays'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'LCL_DELAY'.
*        wa_final-zmrp_delay = 'LCL Delays'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'OTHER'.
*        wa_final-zmrp_delay = 'Other w/c Comments'.
*      ENDIF.
*
*
      IF WA_VBAP-ZWHSE_BACK EQ 'X'.       """Added by Pranit 18.11.2024
        DATA(GV_WHSE) = 'Whse Backlog'.
        CONCATENATE  GV_WHSE WA_FINAL-ZMRP_DELAY INTO WA_FINAL-ZMRP_DELAY SEPARATED BY ''.
      ENDIF.
      IF WA_VBAP-ZASSM_BACK EQ 'X'.
        DATA(GV_ASSM) = 'Assembly Backlog'.
        CONCATENATE WA_FINAL-ZMRP_DELAY GV_ASSM INTO WA_FINAL-ZMRP_DELAY SEPARATED BY ','.
      ENDIF.
      IF WA_VBAP-ZTRAN_DELAY EQ 'X'.
        DATA(GV_TRANS) = 'Transit Delays'.
        CONCATENATE WA_FINAL-ZMRP_DELAY GV_TRANS INTO WA_FINAL-ZMRP_DELAY SEPARATED BY ','.
      ENDIF.
      IF WA_VBAP-ZLCL_DELAYS EQ 'X'.
        DATA(GV_LCL) = 'LCL Delays'.
        CONCATENATE WA_FINAL-ZMRP_DELAY GV_LCL INTO WA_FINAL-ZMRP_DELAY SEPARATED BY ','.
      ENDIF.
      IF WA_VBAP-ZOTHER_COMMENT EQ 'X'.
        DATA(GV_OTHER) = WA_VBAP-ZOTHER_REMARK.
        CONCATENATE WA_FINAL-ZMRP_DELAY GV_OTHER INTO WA_FINAL-ZMRP_DELAY SEPARATED BY ','.
      ENDIF.

*      CONCATENATE GV_WHSE GV_ASSM GV_TRANS GV_LCL GV_OTHER INTO wa_final-zmrp_delay SEPARATED BY ','.


      IF WA_FINAL-ZMRP_DELAY IS NOT INITIAL.
        DATA(LV_STR) = STRLEN( WA_FINAL-ZMRP_DELAY ).
        DATA(LV_COUNT) = LV_STR - 1.
        IF WA_FINAL-ZMRP_DELAY+0(1) = ','.
          WA_FINAL-ZMRP_DELAY+0(1) = ' '.
        ENDIF.

*   if wa_final-zmrp_delay+LV_count(1) = ','.
*     wa_final-zmrp_delay+LV_count(1) = ' '.
*   endif.
      ENDIF.

    ENDIF.

    READ TABLE IT_LIPS INTO WA_LIPS WITH KEY VGBEL = WA_VBAP-VBELN POSNR = WA_VBAP-POSNR.
    IF SY-SUBRC = 0.
      WA_FINAL-MBDAT = WA_LIPS-MBDAT.
    ENDIF.


    READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBAKP-KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
    ENDIF.

    READ TABLE IT_KNVV INTO WA_KNVV WITH KEY KUNNR = WA_KNA1-KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-KDGRP      = WA_KNVV-KDGRP.

    ENDIF.

    READ TABLE IT_T151T INTO WA_T151T WITH KEY KDGRP = WA_KNVV-KDGRP.
    IF SY-SUBRC = 0.
      WA_FINAL-KTEXT = WA_T151T-KTEXT.
    ENDIF.

    READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_VBAKP-VBELN PARVW = 'UR'.
    IF SY-SUBRC = 0.
      WA_FINAL-PARTNER = WA_VBPA-KUNNR.
    ENDIF.

    READ TABLE IT_PARTNER INTO WA_PARTNER WITH KEY KUNNR = WA_FINAL-PARTNER.
    IF SY-SUBRC = 0.
      WA_FINAL-PART_NAME = WA_PARTNER-NAME1.
    ENDIF.

    READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_VBAKP-VBELN PARVW = 'WE'.
    IF SY-SUBRC = 0.
      READ TABLE IT_SHIP INTO WA_SHIP WITH KEY KUNNR = WA_VBPA-KUNNR.
      IF SY-SUBRC = 0.
        WA_FINAL-SHIP_NAME = WA_SHIP-NAME1.
        WA_FINAL-SHIP_CODE = WA_SHIP-KUNNR.
        WA_FINAL-STRAS     = WA_SHIP-STRAS.
        WA_FINAL-PSTLZ     = WA_SHIP-PSTLZ.
        WA_FINAL-ORT01     = WA_SHIP-ORT01.

      ENDIF.

    ENDIF.

    READ TABLE IT_T005U INTO WA_T005U WITH KEY SPRAS = 'EN' LAND1 = WA_SHIP-LAND1 BLAND = WA_SHIP-REGIO.
    IF SY-SUBRC = 0.
      WA_FINAL-SHIP_RIG = WA_T005U-BEZEI.
    ENDIF.

    READ TABLE IT_T005T INTO WA_T005T WITH KEY SPRAS = 'EN' LAND1 = WA_SHIP-LAND1 .
    IF SY-SUBRC = 0.
      WA_FINAL-SHIP_LAND = WA_T005T-LANDX.
    ENDIF.


    READ TABLE IT_T016T INTO WA_T016T WITH KEY BRSCH = WA_KNA1-BRSCH.
    IF SY-SUBRC = 0.
      WA_FINAL-BRSCH = WA_T016T-BRSCH.
      WA_FINAL-BRTXT = WA_T016T-BRTXT.

    ENDIF.

    READ TABLE IT_JEST INTO WA_JEST WITH KEY OBJNR = WA_VBAKP-OBJNR.
    IF SY-SUBRC = 0.
      READ TABLE IT_TJ30T INTO WA_TJ30T WITH  KEY ESTAT = WA_JEST-STAT
                                               STSMA  = 'OR_ITEM'
                                               SPRAS  = 'EN'.
      IF SY-SUBRC = 0.
        WA_FINAL-STATUS      = WA_TJ30T-TXT30.          "Hold/Unhold
      ENDIF.
    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_VBAKP-MATNR_I.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART   = WA_MARA-MTART.
      WA_FINAL-WRKST   = WA_MARA-WRKST.
      WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
      WA_FINAL-ZSIZE   = WA_MARA-ZSIZE.
      WA_FINAL-BRAND   = WA_MARA-BRAND.
      WA_FINAL-MOC     = WA_MARA-MOC.
      WA_FINAL-TYPE    = WA_MARA-TYPE   .
    ENDIF.


    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_VBAKP-MATNR_I BWKEY = WA_VBAKP-WERKS_I.
    IF SY-SUBRC = 0.
      WA_FINAL-BKLAS = WA_MBEW-BKLAS.
      WA_FINAL-STPRS = WA_MBEW-STPRS.
    ENDIF.

    READ TABLE IT_MARC INTO WA_MARC WITH KEY MATNR = WA_FINAL-MATNR WERKS = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-DISPO = WA_MARC-DISPO.
    ENDIF.

    READ TABLE IT_VBEP INTO WA_VBEP WITH KEY VBELN = WA_FINAL-VBELN
                                               POSNR = WA_FINAL-POSNR
                                               ETENR = '0001'.
    IF SY-SUBRC = 0.
      WA_FINAL-ETTYP       = WA_VBEP-ETTYP.           "So Status
      WA_FINAL-EDATU       = WA_VBEP-EDATU.           "delivary Date
      WA_FINAL-ETENR       = WA_VBEP-ETENR.           "Schedule line no.
    ENDIF.

    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_FINAL-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-BSTKD       = WA_VBKD-BSTKD.           "Cust Ref No.                       """Added by Pranit 04.01.2024
      WA_FINAL-ZTERM       = WA_VBKD-ZTERM.           "payment terms
      WA_FINAL-INCO1       = WA_VBKD-INCO1.           "inco terms
      WA_FINAL-INCO2       = WA_VBKD-INCO2.           "inco terms description
    ENDIF.

    READ TABLE IT_TVZBT INTO WA_TVZBT WITH KEY ZTERM = WA_FINAL-ZTERM.
    IF SY-SUBRC = 0.
      WA_FINAL-TEXT1  = WA_TVZBT-VTEXT.
    ENDIF.

    READ TABLE IT_TVAGT INTO WA_TVAGT WITH KEY  ABGRU = WA_VBAKP-ABGRU_I  SPRAS = 'E'.
    IF SY-SUBRC = 0.
      WA_FINAL-BEZEI   =  WA_TVAGT-BEZEI.
    ENDIF.

    READ TABLE IT_DATA INTO DATA(WA_DATA) WITH KEY VBELN = WA_VBAKP-VBELN POSNR = WA_VBAKP-POSNR_I.                 """Added by Pranit 21.02.2024
    WA_FINAL-ZBSTKD = WA_DATA-ZBSTKD.
    WA_FINAL-ZPOSEX = WA_DATA-ZPOSEX.



    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U001'
        LANGUAGE                = 'E'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.



    READ TABLE LV_LINES INTO WA_LINES INDEX 1.
    IF WA_LINES IS NOT INITIAL.
      WA_FINAL-TPI = WA_LINES-TDLINE.
    ENDIF.



*LD Req Text

    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U005'
        LANGUAGE                = 'E'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

*    READ TABLE lv_lines INTO wa_lines INDEX 1.
*    IF wa_lines IS NOT INITIAL.
*      wa_final-ld_txt = wa_lines-tdline.
*    ENDIF.

    LOOP AT LV_LINES INTO WA_LINES.
      IF NOT WA_LINES-TDLINE IS INITIAL.
        CONCATENATE WA_FINAL-LD_TXT WA_LINES-TDLINE  INTO WA_FINAL-LD_TXT ." SEPARATED BY space.
        CLEAR WA_LINES-TDLINE.
      ENDIF.
    ENDLOOP.


*Tag Required
    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U006'
        LANGUAGE                = 'E'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    READ TABLE LV_LINES INTO WA_LINES INDEX 1.
    IF WA_LINES IS NOT INITIAL.
      WA_FINAL-TAG_REQ = WA_LINES-TDLINE.
    ENDIF.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Pranit 23.01.2024

    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U008'
        LANGUAGE                = 'E'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    LOOP AT LV_LINES INTO WA_LINES.         "added by aakashk 05.08.2024
      IF NOT WA_LINES-TDLINE IS INITIAL.
        CONCATENATE WA_FINAL-DELOYED_REMARK WA_LINES-TDLINE  INTO WA_FINAL-DELOYED_REMARK SEPARATED BY SPACE.
*           wa_final-delay_item_remark = wa_lines-tdline.
*      wa_final-tpi = wa_lines-tdline.
      ENDIF.
    ENDLOOP.

*    READ TABLE lv_lines INTO wa_lines INDEX 1.       "commented by aakashk 05.08.2024 1178
*    IF wa_lines IS NOT INITIAL.
*      wa_final-deloyed_remark = wa_lines-tdline.
*    ENDIF.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*Material Long Text
    CLEAR: LV_LINES, WA_LINES.
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

    READ TABLE LV_LINES INTO WA_LINES INDEX 1.
    IF WA_LINES IS NOT INITIAL.
      WA_FINAL-MATTXT = WA_LINES-TDLINE.
    ENDIF.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Pranit 01.03.2024 2
*    CLEAR: lv_lines, wa_lines.
*    REFRESH lv_lines.
*    lv_name = wa_final-vbeln.
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'U005'
*        language                = 'E'
*        name                    = lv_name
*        object                  = 'VBBK'
*      TABLES
*        lines                   = lv_lines
*      EXCEPTIONS
*        id                      = 1
*        language                = 2
*        name                    = 3
*        not_found               = 4
*        object                  = 5
*        reference_check         = 6
*        wrong_access_to_archive = 7
*        OTHERS                  = 8.
*    IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    READ TABLE lv_lines INTO wa_lines INDEX 1.
*    IF wa_lines IS NOT INITIAL.
*      wa_final-remark = wa_lines-tdline.
*
*    ENDIF.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" ENDED BY 01.03.2024 2


**ECCN
    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U002'
        LANGUAGE                = 'E'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

*      READ TABLE lv_lines INTO wa_lines INDEX 1.

    LOOP AT LV_LINES INTO WA_LINES.
      IF NOT WA_LINES-TDLINE IS INITIAL..


        CONCATENATE WA_FINAL-ECCN WA_LINES-TDLINE  INTO WA_FINAL-ECCN SEPARATED BY SPACE.

      ENDIF.
    ENDLOOP.


    """"""""""""""""""""""""""""""""""""""""""""ADD BY SUPRIYA JAGTAP 17:06:2024


    CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
*    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z109'
        LANGUAGE                = 'E'
        NAME                    = LV_NAME
        OBJECT                  = 'VBBP'
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

    READ TABLE LV_LINES  INTO WA_LINES INDEX 1.
    IF WA_LINES-TDLINE IS NOT INITIAL .
      WA_FINAL-REASON_HC = WA_LINES-TDLINE.
    ENDIF.


    """"""""""""""""""""""""""""""""""""""""""""

    "ADDED BY AAKASHK 05.08.2024''''''''''''''''''''''''''''''''''''''''''''''''''''

    CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
    CLEAR: LV_LINES, WA_LINES.         "commented by aakashk 05.08.2024
    REFRESH LV_LINES.
*   lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U008'
        LANGUAGE                = 'E'
        NAME                    = LV_NAME
        OBJECT                  = 'VBBP'
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
    LOOP AT LV_LINES INTO WA_LINES.
      IF NOT WA_LINES-TDLINE IS INITIAL.
        CONCATENATE WA_FINAL-DELAY_ITEM_REMARK WA_LINES-TDLINE  INTO WA_FINAL-DELAY_ITEM_REMARK SEPARATED BY SPACE.
*           wa_final-delay_item_remark = wa_lines-tdline.
*      wa_final-tpi = wa_lines-tdline.
      ENDIF.
    ENDLOOP.
    "END ADD BY AAKASHK.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

    CLEAR: LV_LINES, WA_LINES,LV_NAME.
    REFRESH LV_LINES.
    CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z888'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'VBBP'
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
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL..


          CONCATENATE WA_FINAL-SPL_INS WA_LINES-TDLINE  INTO WA_FINAL-SPL_INS SEPARATED BY SPACE.

        ENDIF.
      ENDLOOP.
    ENDIF.


    CLEAR: WA_VBFA, WA_LFIMG, WA_LFIMG_SUM.

    LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_FINAL-VBELN
                                 AND POSNV = WA_FINAL-POSNR
                                 AND VBTYP_N = 'J'.

      WA_FINAL-DELDATE = WA_VBFA-ERDAT.

      CLEAR WA_LFIMG.
      SELECT SINGLE LFIMG FROM LIPS INTO  WA_LFIMG  WHERE VBELN = WA_VBFA-VBELN
                                                    AND   PSTYV = 'ZTAN'
                                                    AND   VGBEL = WA_FINAL-VBELN
*                                                    AND   WBSTA ne 'A'
                                                    AND   VGPOS = WA_FINAL-POSNR.
      WA_LFIMG_SUM = WA_LFIMG_SUM + WA_LFIMG .

    ENDLOOP.


*INVOICE QTY
    CLEAR: WA_VBFA, WA_FKIMG, WA_FKIMG_SUM.
    LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_FINAL-VBELN
                                   AND POSNV = WA_FINAL-POSNR
                                   AND VBTYP_N = 'M'.

      CLEAR WA_VBRK.
      READ TABLE IT_VBRK INTO WA_VBRK WITH KEY   VBELN = WA_VBFA-VBELN.
      IF SY-SUBRC = 0.


        CLEAR WA_FKIMG.
        SELECT SINGLE FKIMG FROM VBRP INTO  WA_FKIMG  WHERE VBELN = WA_VBRK-VBELN
                                                      AND   AUBEL = WA_FINAL-VBELN
                                                      AND   AUPOS = WA_FINAL-POSNR.
        WA_FKIMG_SUM = WA_FKIMG_SUM + WA_FKIMG .
      ENDIF.
    ENDLOOP.

****

******************Logic For US03 Order Type****************************************
    IF WA_FINAL-AUART = 'US03'.
      CLEAR: WA_VBFA, WA_LFIMG, WA_LFIMG_SUM.

      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_FINAL-VBELN
                                   AND POSNV = WA_FINAL-POSNR
                                   AND VBTYP_N = 'T'.

        CLEAR WA_LFIMG.
        SELECT SINGLE LFIMG FROM LIPS INTO  WA_LFIMG  WHERE VBELN = WA_VBFA-VBELN
                                                      AND   PSTYV = 'UREN'   "'ZTAN'
                                                      AND   VGBEL = WA_FINAL-VBELN
                                                      AND   VGPOS = WA_FINAL-POSNR.
        WA_LFIMG_SUM = WA_LFIMG_SUM + WA_LFIMG .

      ENDLOOP.

      CLEAR: WA_VBFA, WA_FKIMG, WA_FKIMG_SUM.
      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_FINAL-VBELN
                                     AND POSNV = WA_FINAL-POSNR
                                     AND VBTYP_N = 'O'.

        CLEAR WA_VBRK.
        READ TABLE IT_VBRK INTO WA_VBRK WITH KEY   VBELN = WA_VBFA-VBELN.
        IF SY-SUBRC = 0.


          CLEAR WA_FKIMG.
          SELECT SINGLE FKIMG FROM VBRP INTO  WA_FKIMG  WHERE VBELN = WA_VBRK-VBELN
                                                        AND   AUBEL = WA_FINAL-VBELN
                                                        AND   AUPOS = WA_FINAL-POSNR.
          WA_FKIMG_SUM = WA_FKIMG_SUM + WA_FKIMG .
        ENDIF.
      ENDLOOP.
    ENDIF.

    WA_FINAL-LFIMG       = WA_LFIMG_SUM.                "del qty
    WA_FINAL-FKIMG       = WA_FKIMG_SUM.                "inv qty
    WA_FINAL-PND_QTY     = WA_FINAL-KWMENG - WA_FINAL-FKIMG.  "Pending Qty


    CLEAR: WA_KONV.
    READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAKP-KNUMV
                                                      KPOSN = WA_VBAKP-POSNR_I
                                                      KSCHL = 'ZPR0'  KINAK = ' '.

    IF SY-SUBRC EQ 0.
      WA_FINAL-KBETR       = WA_KONV-KBETR.           "Rate
    ENDIF.


    CLEAR: WA_KONV .
    READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAKP-KNUMV
                                                  KPOSN = WA_VBAKP-POSNR_I
                                                  KSCHL = 'UHF1' .
    IF SY-SUBRC EQ 0.

      IF WA_KONV-KGRPE = 'X'.
        ON CHANGE OF WA_VBAKP-KNUMV.
          WA_FINAL-HUHF1       = WA_KONV-KBETR.           "Rate
        ENDON.
      ELSE.
        WA_FINAL-UHF1       = WA_KONV-KBETR.           "Rate
      ENDIF.

    ENDIF.

    CLEAR: WA_KONV .
    READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAKP-KNUMV
                                                   KPOSN = WA_VBAKP-POSNR_I
                                                   KSCHL = 'USC1' .
    IF SY-SUBRC EQ 0.
      IF WA_KONV-KGRPE = 'X'.
        ON CHANGE OF WA_VBAKP-KNUMV.
          WA_FINAL-HUSC1       = WA_KONV-KBETR.           "Rate
        ENDON.
      ELSE.
        WA_FINAL-USC1       = WA_KONV-KBETR.           "Rate
      ENDIF.

    ENDIF.

    CLEAR: WA_KONV .
    READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAKP-KNUMV
                                                  KPOSN = WA_VBAKP-POSNR_I
                                                  KSCHL = 'UMC1' .

    IF SY-SUBRC EQ 0.
      IF WA_KONV-KGRPE = 'X'.
        ON CHANGE OF WA_VBAKP-KNUMV.
          WA_FINAL-HUMC1       = WA_KONV-KBETR.           "Rate
        ENDON.
      ELSE.
        WA_FINAL-UMC1       = WA_KONV-KBETR.           "Rate
      ENDIF.

    ENDIF.

    IF WA_FINAL-AUART = 'US03'.
      WA_FINAL-PND_QTY = WA_FINAL-PND_QTY * -1.
    ENDIF.

    WA_FINAL-AMONT       = WA_FINAL-PND_QTY * WA_FINAL-KBETR .
    WA_FINAL-ORDR_AMT    = WA_FINAL-KWMENG * WA_FINAL-KBETR .




    IF WA_FINAL-AUART = 'US03'.
      WA_FINAL-KWMENG    = WA_FINAL-KWMENG * -1.
      WA_FINAL-LFIMG     = WA_FINAL-LFIMG * -1.
      WA_FINAL-FKIMG     = WA_FINAL-FKIMG * -1.
      WA_FINAL-ORDR_AMT  = WA_FINAL-ORDR_AMT * -1.
    ENDIF.

    IF WA_FINAL-AUART = 'US12' .
      WA_FINAL-KWMENG    = WA_FINAL-KWMENG * -1.
      WA_FINAL-PND_QTY   = WA_FINAL-PND_QTY * -1.
      WA_FINAL-AMONT     = WA_FINAL-AMONT * -1.
      WA_FINAL-ORDR_AMT  = WA_FINAL-ORDR_AMT * -1.
    ENDIF.


    """""""""""""code added by pankaj 12.01.2022

    CLEAR: LV_LINES, WA_LINES,LV_NAME.
    REFRESH LV_LINES.
    CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0001'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'VBBP'
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
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL..


          CONCATENATE WA_FINAL-TAG_NO WA_LINES-TDLINE  INTO WA_FINAL-TAG_NO SEPARATED BY SPACE.

        ENDIF.
      ENDLOOP.
    ENDIF.



    CLEAR: LV_LINES, WA_LINES,LV_NAME.
    REFRESH LV_LINES.
    CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z108'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'VBBP'
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
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL..


          CONCATENATE WA_FINAL-SHIP_FROM WA_LINES-TDLINE  INTO WA_FINAL-SHIP_FROM SEPARATED BY SPACE.

        ENDIF.
      ENDLOOP.
    ENDIF.




    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U007'
        LANGUAGE                = 'E'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

*      READ TABLE lv_lines INTO wa_lines INDEX 1.

    LOOP AT LV_LINES INTO WA_LINES.
      IF NOT WA_LINES-TDLINE IS INITIAL..


        CONCATENATE WA_FINAL-OFM_DATE_NEW WA_LINES-TDLINE  INTO WA_FINAL-OFM_DATE_NEW SEPARATED BY SPACE.

      ENDIF.
    ENDLOOP.




    """"""""ednded """"""""""""""""""""""""""""""""""""""""""


    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.
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

  PERFORM FCAT USING : '1'    'WERKS'       'IT_FINAL'  'Plant'                    '15' ,
                        '2'    'AUART'       'IT_FINAL'  'Order Type'                    '15' ,
                        '3'    'BSTNK'       'IT_FINAL'  'Customer PO No'                    '15' ,
                        '4'    'BSTDK'       'IT_FINAL'  'Customer PO Date'                    '15' ,
                        '5'    'KUNNR'       'IT_FINAL'  'Customer Code'                    '15' ,
                        '6'    'NAME1'       'IT_FINAL'  'Customer Name'                    '15' ,
                        '7'    'PARTNER'     'IT_FINAL'  'Sales Rep. No'                    '15' ,
                        '8'    'PART_NAME'   'IT_FINAL'  'Sales Rep. Name'                    '15' ,
                        '9'    'KDGRP'       'IT_FINAL'  'Customer Group'                    '15' ,
                        '10'    'KTEXT'       'IT_FINAL'  'Customer Group Desc'                    '15' ,
                        '11'    'BRSCH'       'IT_FINAL'  'Industry Sector'                    '15' ,
                        '12'    'BRTXT'       'IT_FINAL'  'Industry Sector Desc'                    '15' ,
                        '13'    'VKBUR'       'IT_FINAL'  'Sales Office'                    '15' ,
                        '14'    'VBELN'       'IT_FINAL'  'Sales Doc No'                    '15' ,
                        '15'    'ERDAT'       'IT_FINAL'  'So Date'                    '15' ,
                        '16'    'VDATU'       'IT_FINAL'  'Required Delivery Dt'                    '15' ,
                        '17'    'STATUS'       'IT_FINAL'  'Hold/Unhold'                    '15' ,

                        '18'    'HOLDDATE'         'IT_FINAL'  'Hold Date'                          '15' ,
                        '19'    'HOLDRELDATE'          'IT_FINAL'  'Release Date'                       '15' ,
                        '20'    'CANCELDATE'       'IT_FINAL'  'Cancelled Date'                     '15' ,
                        '21'    'DELDATE'          'IT_FINAL'  'Delivery Date'                      '15' ,
                        '22'    'TPI'              'IT_FINAL'  'Shipping Method'                    '15' ,
                        '23'    'TAG_REQ'          'IT_FINAL'  'Service Charge'                     '15' ,
                        '24'    'LD_TXT'           'IT_FINAL'  'Remark'                             '50' ,
                        '25'    'MATNR'            'IT_FINAL'   'Item Code'                         '15' ,
                        '26'    'WRKST'            'IT_FINAL'   'USA Code'                          '15' ,
                        '27'    'BKLAS'            'IT_FINAL'   'Valuation Class'                   '15' ,
                        '28'    'POSNR'            'IT_FINAL'   'Line Item'                         '15' ,
                        '29'    'ARKTX'            'IT_FINAL'   'Item Description'                  '15' ,
                        '30'    'MATTXT'           'IT_FINAL'   'Material long Text'                '15' ,
                        '31'    'KWMENG'           'IT_FINAL'   'SO QTY'                            '15' ,
                        '32'    'LFIMG'            'IT_FINAL'   'Delivary Qty'                      '15' ,
                        '33'    'FKIMG'            'IT_FINAL'   'Invoice Quantity'                  '15' ,
                        '34'    'PND_QTY'          'IT_FINAL'   'Pending Qty'                       '15' ,
                        '35'    'ETTYP'            'IT_FINAL'   'SO Status'                         '15' ,
                        '36'    'KBETR'            'IT_FINAL'   'Rate'                              '15' ,
                        '37'    'WAERK'            'IT_FINAL'   'Currency Type'                      '15' ,

                        '38'    'AMONT'            'IT_FINAL'   'Pending SO Amount'                      '15' ,
                        '39'    'ORDR_AMT'         'IT_FINAL'   'Order Amount'                      '15' ,
                        '40'    'STPRS'            'IT_FINAL'   'Standard Cost'                      '15' ,
                        '41'    'ZSERIES'          'IT_FINAL'   'Series'                    '15' ,
                        '42'    'ZSIZE'            'IT_FINAL'   'Size'                    '15' ,
                        '43'    'BRAND'            'IT_FINAL'   'Brand'                    '15' ,
                        '44'    'MOC'              'IT_FINAL'   'MOC'                    '15' ,
                        '45'    'TYPE'             'IT_FINAL'   'Type'                    '15' ,
                        '46'    'DISPO'            'IT_FINAL'    'MRP Controller'                    '15' ,
                        '47'    'MTART'            'IT_FINAL'    'MAT TYPE'                    '15' ,
                        '48'    'ZTERM'            'IT_FINAL'    'Payment Terms'                    '15' ,
                        '49'    'TEXT1'            'IT_FINAL'    'Payment Terms Text'                    '15' ,
                        '50'    'INCO1'            'IT_FINAL'    'Inco Terms'                    '15' ,
                        '51'    'INCO2'            'IT_FINAL'    'Inco Terms Descr'                    '15' ,
                        '52'    'CUSTDELDATE'      'IT_FINAL'    'Customer Delivery Date'                   '15' ,
                        '53'    'BNAME'            'IT_FINAL'    'Contact Person'                   '15' ,
                        '54'    'ECCN'             'IT_FINAL'    'ECCN'                   '15' ,
                        '55'    'ABGRU'            'IT_FINAL'    'Rejection Reason Code'                     '15' ,
                        '56'    'BEZEI'            'IT_FINAL'    'Rejection Reason Description'                     '15' ,
                        '57'    'SHIP_CODE'        'IT_FINAL'    'Ship To Party Code'                     '15' ,
                        '58'    'SHIP_NAME'        'IT_FINAL'    'Ship To Party Name'                     '15' ,
                        '59'    'STRAS'            'IT_FINAL'    'Ship To Party House No'                     '15' ,
                        '60'    'PSTLZ'            'IT_FINAL'    'Ship To Party Postal Code'                     '15' ,
                        '61'    'ORT01'            'IT_FINAL'    'Ship To Party City'                     '15' ,
                        '62'    'SHIP_RIG'         'IT_FINAL'    'Ship To Party Region'                     '15' ,
                        '63'    'SHIP_LAND'        'IT_FINAL'    'Ship To Party Country'                     '15' ,
                        '64'    'UHF1'             'IT_FINAL'    'Handling Charges '                    '15' ,
                        '65'    'USC1'             'IT_FINAL'    'Service Charges'                    '15' ,
                        '66'    'UMC1'             'IT_FINAL'    'Mounting Charges'                    '15' ,
                        '67'    'HUHF1'            'IT_FINAL'    'Hed.Handling Charges '                    '15' ,
                        '68'    'HUSC1'            'IT_FINAL'    'Hed.Service Charges'                    '15' ,
                        '69'    'HUMC1'            'IT_FINAL'    'Hed.Mounting Charges'                    '15' ,
                        '70'    'SPL_INS'          'IT_FINAL'    'Special Instruction'                    '15' ,
                        '71'    'TAG_NO'           'IT_FINAL'    'Tag No Details'                    '15' ,  "added by pankaj 12.01.2022
                        '72'    'SHIP_FROM'        'IT_FINAL'    'Shipping From'                    '15',    "added by shreya 15-02-2022
                        '73'    'OFM_DATE_NEW'     'IT_FINAL'    'OFM Date'                         '15',    "added by shreya 15-02-2022
                        '74'    'MBDAT'            'IT_FINAL'    'Material Avail Date'              '15',
                        '75'    'DELOYED_REMARK'   'IT_FINAL'    'Delayed SO Remark'                '15',    """Added by Pranit 23.01.2024  "ADDED BY AAKASHK 05.08.2024
                        '76'    'BSTKD'            'IT_FINAL'    'PO Number'                        '15',    """Added by Pranit 04.02.2024
                        '77'    'POSEX'            'IT_FINAL'    'PO Line Item Number'              '15',    """Added by Pranit 04.02.2024
                        '78'    'ZBSTKD'           'IT_FINAL'    'DV IND PO Number'                 '15',    """Added by Pranit 21.02.2024
                        '79'    'ZPOSEX'           'IT_FINAL'    'DV IND PO Line Item Number'       '15',    """Added by Pranit 21.02.2024
*                       '80'    'REMARK'           'IT_FINAL'    'So Remark'                       '15',    """Added by Pranit 01.03.2024
                        '80'    'ERNAM'            'IT_FINAL'    'Created By'                       '15',    """Added by Pranit 27.03.2024
                        '81'    'ERDAT'            'IT_FINAL'    'Created On'                      '15',    """Added by Pranit 27.03.2024
                        '82'    'REASON_HC '       'IT_FINAL'    'Reason for Hold/Cancelled'       '15',   """Added by supriya Jagtap    17.06.2024
                        '83'    'DELAY_ITEM_REMARK' 'IT_FINAL'   'Delay Item Remark'              '20',     "added by aakashk 05.08.2024
                        '84'    'ZMRP_DELAY'        'IT_FINAL'   'Target Date Delay(Reason)'              '20'.     "added by PRANIT 19.11.2024
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_3532   text
*      -->P_3533   text
*      -->P_3534   text
*      -->P_3535   text
*      -->P_3536   text
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
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      I_CALLBACK_PROGRAM      = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'USER_CMD'
      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      IS_LAYOUT               = WA_LAYOUT
      IT_FIELDCAT             = IT_FCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
      IT_SORT                 = T_SORT[]
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      I_SAVE                  = 'X'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      T_OUTTAB                = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
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
  LS_HEADER-INFO = 'Pending So Report'.
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
ENDFORM.                    " TOP-OF-
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .
  LOOP AT IT_FINAL INTO WA_FINAL.
    WA_DOWN-WERKS       = WA_FINAL-WERKS.
    WA_DOWN-AUART       = WA_FINAL-AUART.
    WA_DOWN-BSTNK       = WA_FINAL-BSTNK.
    WA_DOWN-KUNNR       = WA_FINAL-KUNNR.
    WA_DOWN-NAME1       = WA_FINAL-NAME1.
    WA_DOWN-PARTNER     = WA_FINAL-PARTNER.
    WA_DOWN-PART_NAME   = WA_FINAL-PART_NAME.
    WA_DOWN-KDGRP       = WA_FINAL-KDGRP.
    WA_DOWN-KTEXT       = WA_FINAL-KTEXT.
    WA_DOWN-BRSCH       = WA_FINAL-BRSCH.
    WA_DOWN-BRTXT       = WA_FINAL-BRTXT.
    WA_DOWN-VKBUR       = WA_FINAL-VKBUR.
    WA_DOWN-VBELN       = WA_FINAL-VBELN.
    WA_DOWN-STATUS      = WA_FINAL-STATUS.

    WA_DOWN-TPI         = WA_FINAL-TPI.
    WA_DOWN-TAG_REQ     = WA_FINAL-TAG_REQ.
    WA_DOWN-LD_TXT      = WA_FINAL-LD_TXT.
    WA_DOWN-MATNR       = WA_FINAL-MATNR.
    WA_DOWN-WRKST       = WA_FINAL-WRKST.
    WA_DOWN-BKLAS       = WA_FINAL-BKLAS.
    WA_DOWN-POSNR       = WA_FINAL-POSNR.
    WA_DOWN-ARKTX       = WA_FINAL-ARKTX.

    WA_DOWN-MATTXT      = WA_FINAL-MATTXT.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN WA_DOWN-MATTXT WITH ' & '.

    WA_DOWN-KWMENG      = ABS( WA_FINAL-KWMENG ).
    WA_DOWN-LFIMG       = ABS( WA_FINAL-LFIMG ).
    WA_DOWN-FKIMG       = ABS( WA_FINAL-FKIMG ).
    WA_DOWN-PND_QTY     = ABS( WA_FINAL-PND_QTY ).
    WA_DOWN-AMONT       = ABS( WA_FINAL-AMONT ).
    WA_DOWN-ORDR_AMT    = ABS( WA_FINAL-ORDR_AMT ).
    WA_DOWN-STPRS       = ABS( WA_FINAL-STPRS ).
    WA_DOWN-UHF1        = ABS( WA_FINAL-UHF1 ).
    WA_DOWN-USC1        = ABS( WA_FINAL-USC1 ).
    WA_DOWN-UMC1        = ABS( WA_FINAL-UMC1 ).
    WA_DOWN-HUHF1       = ABS( WA_FINAL-HUHF1 ).
    WA_DOWN-HUSC1       = ABS( WA_FINAL-HUSC1 ).
    WA_DOWN-HUMC1       = ABS( WA_FINAL-HUMC1 ).
    WA_DOWN-KBETR       = ABS( WA_FINAL-KBETR ).

    CONDENSE WA_DOWN-UHF1.
    IF WA_FINAL-UHF1 < 0.
      CONCATENATE '-' WA_DOWN-UHF1 INTO WA_DOWN-UHF1.
    ENDIF.

    CONDENSE WA_DOWN-USC1.
    IF WA_FINAL-USC1 < 0.
      CONCATENATE '-' WA_DOWN-USC1 INTO WA_DOWN-USC1.
    ENDIF.

    CONDENSE WA_DOWN-UMC1.
    IF WA_FINAL-UMC1 < 0.
      CONCATENATE '-' WA_DOWN-UMC1 INTO WA_DOWN-UMC1.
    ENDIF.


    CONDENSE WA_DOWN-HUHF1.
    IF WA_FINAL-HUHF1 < 0.
      CONCATENATE '-' WA_DOWN-HUHF1 INTO WA_DOWN-HUHF1.
    ENDIF.

    CONDENSE WA_DOWN-HUSC1.
    IF WA_FINAL-HUSC1 < 0.
      CONCATENATE '-' WA_DOWN-HUSC1 INTO WA_DOWN-HUSC1.
    ENDIF.

    CONDENSE WA_DOWN-HUMC1.
    IF WA_FINAL-HUMC1 < 0.
      CONCATENATE '-' WA_DOWN-HUMC1 INTO WA_DOWN-HUMC1.
    ENDIF.

    CONDENSE WA_DOWN-KWMENG.
    IF WA_FINAL-KWMENG < 0.
      CONCATENATE '-' WA_DOWN-KWMENG INTO WA_DOWN-KWMENG.
    ENDIF.


    CONDENSE WA_DOWN-LFIMG.
    IF WA_FINAL-LFIMG < 0.
      CONCATENATE '-' WA_DOWN-LFIMG INTO WA_DOWN-LFIMG.
    ENDIF.

    CONDENSE WA_DOWN-FKIMG.
    IF WA_FINAL-FKIMG < 0.
      CONCATENATE '-' WA_DOWN-FKIMG INTO WA_DOWN-FKIMG.
    ENDIF.

    CONDENSE WA_DOWN-PND_QTY.
    IF WA_FINAL-PND_QTY < 0.
      CONCATENATE '-' WA_DOWN-PND_QTY INTO WA_DOWN-PND_QTY.
    ENDIF.

    CONDENSE WA_DOWN-KBETR.
    IF WA_FINAL-KBETR < 0.
      CONCATENATE '-' WA_DOWN-KBETR INTO WA_DOWN-KBETR.
    ENDIF.

    CONDENSE WA_DOWN-AMONT.
    IF WA_FINAL-AMONT < 0.
      CONCATENATE '-' WA_DOWN-AMONT INTO WA_DOWN-AMONT.
    ENDIF.

    CONDENSE WA_DOWN-ORDR_AMT.
    IF WA_FINAL-ORDR_AMT < 0.
      CONCATENATE '-' WA_DOWN-ORDR_AMT INTO WA_DOWN-ORDR_AMT.
    ENDIF.

    CONDENSE WA_DOWN-STPRS.
    IF WA_FINAL-STPRS < 0.
      CONCATENATE '-' WA_DOWN-STPRS INTO WA_DOWN-STPRS.
    ENDIF.

    WA_DOWN-ETTYP       = WA_FINAL-ETTYP.
    WA_DOWN-WAERK       = WA_FINAL-WAERK.
    WA_DOWN-ZSERIES     = WA_FINAL-ZSERIES.
    WA_DOWN-ZSIZE       = WA_FINAL-ZSIZE.
    WA_DOWN-BRAND       = WA_FINAL-BRAND.
    WA_DOWN-MOC         = WA_FINAL-MOC.
    WA_DOWN-TYPE        = WA_FINAL-TYPE.
    WA_DOWN-DISPO       = WA_FINAL-DISPO.
    WA_DOWN-MTART       = WA_FINAL-MTART.
    WA_DOWN-ZTERM       = WA_FINAL-ZTERM.
    WA_DOWN-INCO1       = WA_FINAL-INCO1.
    WA_DOWN-INCO2       = WA_FINAL-INCO2.
    WA_DOWN-TEXT1       = WA_FINAL-TEXT1.
    WA_DOWN-BNAME       = WA_FINAL-BNAME.
    WA_DOWN-ECCN        = WA_FINAL-ECCN.
    WA_DOWN-ABGRU       = WA_FINAL-ABGRU.
    WA_DOWN-BEZEI       = WA_FINAL-BEZEI.
    WA_DOWN-SHIP_CODE   = WA_FINAL-SHIP_CODE.
    WA_DOWN-SHIP_NAME   = WA_FINAL-SHIP_NAME.
    WA_DOWN-STRAS       = WA_FINAL-STRAS    .
    WA_DOWN-PSTLZ       = WA_FINAL-PSTLZ    .
    WA_DOWN-ORT01       = WA_FINAL-ORT01    .
    WA_DOWN-SHIP_RIG    = WA_FINAL-SHIP_RIG.
    WA_DOWN-SHIP_LAND   = WA_FINAL-SHIP_LAND.


    IF WA_FINAL-BSTDK IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BSTDK
        IMPORTING
          OUTPUT = WA_DOWN-BSTDK.


      CONCATENATE WA_DOWN-BSTDK+0(2) WA_DOWN-BSTDK+2(3) WA_DOWN-BSTDK+5(4)
                     INTO WA_DOWN-BSTDK SEPARATED BY '-'.

    ENDIF.

    IF WA_FINAL-ERDAT IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-ERDAT
        IMPORTING
          OUTPUT = WA_DOWN-ERDAT.


      CONCATENATE WA_DOWN-ERDAT+0(2) WA_DOWN-ERDAT+2(3) WA_DOWN-ERDAT+5(4)
                     INTO WA_DOWN-ERDAT SEPARATED BY '-'.

    ENDIF.

    IF WA_FINAL-VDATU IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-VDATU
        IMPORTING
          OUTPUT = WA_DOWN-VDATU.

      CONCATENATE WA_DOWN-VDATU+0(2) WA_DOWN-VDATU+2(3) WA_DOWN-VDATU+5(4)
                     INTO WA_DOWN-VDATU SEPARATED BY '-'.

    ENDIF.

    IF WA_FINAL-HOLDDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-HOLDDATE
        IMPORTING
          OUTPUT = WA_DOWN-HOLDDATE.


      CONCATENATE WA_DOWN-HOLDDATE+0(2) WA_DOWN-HOLDDATE+2(3) WA_DOWN-HOLDDATE+5(4)
                     INTO WA_DOWN-HOLDDATE SEPARATED BY '-'.

    ENDIF.

    IF WA_FINAL-HOLDRELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-HOLDRELDATE
        IMPORTING
          OUTPUT = WA_DOWN-HOLDRELDATE.


      CONCATENATE WA_DOWN-HOLDRELDATE+0(2) WA_DOWN-HOLDRELDATE+2(3) WA_DOWN-HOLDRELDATE+5(4)
                     INTO WA_DOWN-HOLDRELDATE SEPARATED BY '-'.

    ENDIF.

    IF WA_FINAL-CANCELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-CANCELDATE
        IMPORTING
          OUTPUT = WA_DOWN-CANCELDATE.


      CONCATENATE WA_DOWN-CANCELDATE+0(2) WA_DOWN-CANCELDATE+2(3) WA_DOWN-CANCELDATE+5(4)
                     INTO WA_DOWN-CANCELDATE SEPARATED BY '-'.

    ENDIF.

    IF WA_FINAL-DELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-DELDATE
        IMPORTING
          OUTPUT = WA_DOWN-DELDATE.

      CONCATENATE WA_DOWN-DELDATE+0(2) WA_DOWN-DELDATE+2(3) WA_DOWN-DELDATE+5(4)
                     INTO WA_DOWN-DELDATE SEPARATED BY '-'.

    ENDIF.

    IF WA_FINAL-CUSTDELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-CUSTDELDATE
        IMPORTING
          OUTPUT = WA_DOWN-CUSTDELDATE.
      CONCATENATE WA_DOWN-CUSTDELDATE+0(2) WA_DOWN-CUSTDELDATE+2(3) WA_DOWN-CUSTDELDATE+5(4)
                     INTO WA_DOWN-CUSTDELDATE SEPARATED BY '-'.
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

    WA_DOWN-TAG_NO   = WA_FINAL-TAG_NO.       "code added by pankaj 12.01.2022
    WA_DOWN-SHIP_FROM = WA_FINAL-SHIP_FROM. "code added by shreya 15-02-2022
    WA_DOWN-OFM_DATE_NEW = WA_FINAL-OFM_DATE_NEW.
    WA_DOWN-DELOYED_REMARK = WA_FINAL-DELOYED_REMARK. """Added by Pranit 24.01.2024
    WA_DOWN-BSTKD = WA_FINAL-BSTKD.                   """Added by Pranit 04.02.2024
    WA_DOWN-POSEX = WA_FINAL-POSEX.                   """Added by Pranit 04.02.2024
    WA_DOWN-ZBSTKD = WA_FINAL-ZBSTKD.                 """Added by Pranit 21.02.2024
    WA_DOWN-ZPOSEX = WA_FINAL-ZPOSEX.                 """Added by Pranit 21.02.2024
*    wa_down-remark = wa_final-remark.                 """Added by Pranit 21.02.2024
    WA_DOWN-ERNAM  = WA_FINAL-ERNAM.                 """Added by Pranit 27.02.2024

    WA_DOWN-ERDAT1 = WA_DOWN-ERDAT.                 """Added by Pranit 27.02.2024
    WA_DOWN-REASON_HC = WA_FINAL-REASON_HC .                  """added by supriya 17:06:2024
    WA_DOWN-DELAY_ITEM_REMARK = WA_FINAL-DELAY_ITEM_REMARK.   "added by aakashk 05.08.2024
    WA_DOWN-ZMRP_DELAY = WA_FINAL-ZMRP_DELAY .   "added by PRANIT 19.11.2024

    IF WA_FINAL-MBDAT IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-MBDAT
        IMPORTING
          OUTPUT = WA_DOWN-MBDAT.
      CONCATENATE WA_DOWN-MBDAT+0(2) WA_DOWN-MBDAT+2(3) WA_DOWN-MBDAT+5(4)
                     INTO WA_DOWN-MBDAT SEPARATED BY '-'.
    ENDIF.


    APPEND WA_DOWN TO IT_DOWN.
    CLEAR WA_DOWN.

  ENDLOOP.


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
*  BREAK primus.
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
  LV_FILE = 'ZUSANEWPENDSO.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
  INTO LV_FULLFILE.
*  BREAK primus.
  WRITE: / 'ZUSANEWPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_263 TYPE STRING.
    DATA LV_CRLF_263 TYPE STRING.
    LV_CRLF_263   = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_263 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_263  LV_CRLF_263   WA_CSV INTO LV_STRING_263 .
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_263 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
*************************************
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
  LV_FILE = 'ZUSANEWPENDSO.TXT'.

  CONCATENATE P_FOLDER '/'  LV_FILE
  INTO LV_FULLFILE.
*  BREAK primus.
  WRITE: / 'ZUSANEWPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    CLEAR: LV_STRING_263 ,LV_CRLF_263 .
    LV_CRLF_263   = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_263 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_263  LV_CRLF_263   WA_CSV INTO LV_STRING_263 .
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_263 TO LV_FULLFILE.
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
FORM CVS_HEADER   USING    PD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE 'Plant'
              'Order Type'
              'Customer PO No'
              'Customer PO Date'
              'Customer Code'
              'Customer Name'
              'Sales Rep. No'
              'Sales Rep. Name'
              'Customer Group'
              'Customer Group Desc'
              'Industry Sector'
              'Industry Sector Desc'
              'Sales Office'
              'Sales Doc No'
              'So Date'
              'Required Delivery Dt'
              'Hold/Unhold'
              'Hold Date'
              'Release Date'
              'Cancelled Date'
              'Delivery Date'
              'Shipping Method'
              'Service Charge'
              'Remark'
              'Item Code'
              'USA Code'
              'Valuation Class'
              'Line Item'
              'Item Description'
              'Material long Text'
              'SO QTY'
              'Delivary Qty'
              'Invoice Quantity'
              'Pending Qty'
              'SO Status'
              'Rate'
              'Currency Type'
              'Pending SO Amount'
              'Order Amount'
              'Standard Cost'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'Type'
              'MRP Controller'
              'MAT TYPE'
              'Payment Terms'
              'Payment Terms Text'
              'Inco Terms'
              'Inco Terms Descr'
              'Customer Delivery Date'
              'Contact Person'
              'ECCN'
              'Rejection Reason Code'
              'Rejection Reason Description'
              'Ship To Party Code'
              'Ship To Party Name'
              'Ship To Party House No'
              'Ship To Party Postal Code'
              'Ship To Party City'
              'Ship To Party Region'
              'Ship To Party Country'
              'Handling Charges '
              'Service Charges'
              'Mounting Charges'
              'Hed.Handling Charges '
              'Hed.Service Charges'
              'Hed.Mounting Charges'
              'Special Instruction'
              'Refresh Date'
              'Refresh Time'
              'Tag No Details'
              'Shipping From'
              'OFM Date'
              'Material Avail Date'
              'Delayed SO Remark'        """Added by Pranit 23.01.2024
              'PO Number'            """Added by Pranit 04.02.2024
              'PO Line Item Number'  """Added by Pranit 04.02.2024
              'DV IND PO Number'           """Added by Pranit 21.02.2024
              'DV IND PO Line Item Number' """Added by Pranit 21.02.2024
*              'Remark'                     """Added by Pranit 01.03.2024
              'Created By'                 """Added by Pranit 27.03.2024
              'Created On'                 """Added by Pranit 27.03.2024
              'Reason for Hold/Cancelled'                     """added by supriya 17:06:2024
              'Delay Item Remarks'         "added by aakashk 05.08.2024
              'Target Date Delay(Reason)'
  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
