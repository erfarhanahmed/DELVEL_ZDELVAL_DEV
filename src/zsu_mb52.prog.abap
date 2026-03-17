*&---------------------------------------------------------------------*
*&Report: ZSU_MB52
*&Transaction: ZSU_MB52
*&Functional Cosultant: Devshree kalamkar/Subhashish Pande
*&Technical Consultant: SUPRIYA JAGTAP
*&TR: DEVK912309
*&Date: 16.08.2024
*&Owner: DelVal Flow Controls

*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_MB52.

TABLES:MARD,MARA.

TYPES: BEGIN OF TY_MARA,
         MATNR   TYPE MARA-MATNR,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         BRAND   TYPE MARA-BRAND,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
         WRKST   TYPE MARA-WRKST,
         MEINS   TYPE MARA-MEINS,
       END OF TY_MARA,

       BEGIN OF TY_TRASNIT,
         MATNR    TYPE MARA-MATNR,
*         WRKST    TYPE MARA-WRKST,
*         ZSERIES  TYPE MARA-ZSERIES,
*         ZSIZE    TYPE MARA-ZSIZE,
*         BRAND    TYPE MARA-BRAND,
*         MOC      TYPE MARA-MOC,
*         TYPE     TYPE MARA-TYPE,
**      maktx       TYPE makt-maktx,
*         DESC     TYPE CHAR100,
         EBELN    TYPE EKPO-EBELN,
         EBELP    TYPE EKPO-EBELP,
*         MENGE    TYPE EKPO-MENGE,
*         LIFNR    TYPE LFA1-LIFNR,
*         NAME1    TYPE LFA1-NAME1,
*         VBELN    TYPE VBAP-VBELN,
*         POSNR    TYPE VBAP-POSNR,
*         KWMENG   TYPE VBAP-KWMENG,
*         INV_NO   TYPE VBRP-VBELN,
*         INV_LINE TYPE VBRP-POSNR,
         FKIMG    TYPE VBRP-FKIMG,
*         FKDAT    TYPE VBRK-FKDAT,
*         XBLNR    TYPE VBRK-XBLNR,
*         KBETR    TYPE KONV-KBETR,
*         KWERT    TYPE KONV-KWERT,
*         PONO     TYPE CHAR15,
*         BEZEI    TYPE ZTRANSIT-BEZEI,
*         ARRIVAL  TYPE SY-DATUM,
*         DUE      TYPE SY-DATUM,
*         PORT     TYPE CHAR100,
*         PLACE    TYPE STRING,
*         STOCK    TYPE MARD-LABST,
*         PEND     TYPE VBRP-FKIMG,
*         MBLNR    TYPE MSEG-MBLNR,
         VBELN_IM TYPE MSEG-VBELN_IM,
*         BELNR    TYPE BKPF-BELNR,
         WERKS    TYPE EKPO-WERKS,
       END OF TY_TRASNIT,

       BEGIN OF TY_VBAP,
         VBELN  TYPE VBUP-VBELN,
         POSNR  TYPE VBUP-POSNR,
         LFSTA  TYPE VBUP-LFSTA,
         LFGSA  TYPE VBUP-LFGSA,
         MATNR  TYPE VBAP-MATNR,  "
         KWMENG TYPE VBAP-KWMENG, "
         POSEX  TYPE VBAP-POSEX,  "
       END OF TY_VBAP,

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
         LVORM TYPE MARD-LVORM,
         LGPBE TYPE MARD-LGPBE, " ADDED 20.08.24
*         VMLAB TYPE MARD-VMLAB,
       END OF TY_MARD,

       BEGIN OF TY_T001,
         BUKRS TYPE T001-BUKRS,
         WAERS TYPE T001-WAERS,
       END OF TY_T001,

       BEGIN OF TY_T001W,
         WERKS TYPE WERKS,
         NAME1 TYPE NAME1,
       END OF TY_T001W,

       BEGIN OF TY_T001L,
         LGORT TYPE T001L-LGORT,
         LGOBE TYPE T001L-LGOBE,
       END OF TY_T001L,

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
         BKLAS TYPE MBEW-BKLAS,
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

       BEGIN OF TY_VBUP_1,
         MATNR TYPE MSKA-MATNR,
         WERKS TYPE MSKA-WERKS,
         LGORT TYPE MSKA-LGORT,
         SOBKZ TYPE MSKA-SOBKZ,
         KALAB TYPE MSKA-KALAB,
         KAINS TYPE MSKA-KAINS,
         KASPE TYPE MSKA-KASPE,
         KAVLA TYPE MSKA-KAVLA,
         KAVIN TYPE MSKA-KAVIN,
         KAVSP TYPE MSKA-KAVSP,
         KAVEI TYPE MSKA-KAVEI,
         VBELN TYPE VBUP-VBELN,
         POSNR TYPE VBUP-POSNR,
         LFSTA TYPE VBUP-LFSTA,
         LFGSA TYPE VBUP-LFGSA,
       END  OF TY_VBUP_1,

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
         LBLAB TYPE MSLB-LBLAB,
         LBINS TYPE MSLB-LBINS,
         LBVLA TYPE MSLB-LBVLA,
         LBVEI TYPE MSLB-LBVEI,
         LBUML TYPE MSLB-LBUML,
         SOBKZ TYPE MSLB-SOBKZ,
         LIFNR TYPE MSLB-LIFNR,
       END OF TY_MSLB,

       BEGIN OF TY_MSKU,
         MATNR TYPE MSKU-MATNR,
         WERKS TYPE MSKU-WERKS,
         CHARG TYPE MSKU-CHARG,
         SOBKZ TYPE MSKU-SOBKZ,
         KUNNR TYPE MSKU-KUNNR,
         KULAB TYPE MSKU-KULAB,
       END OF TY_MSKU,

       BEGIN OF TY_MCHB,
         MATNR    TYPE MCHB-MATNR,
         WERKS    TYPE MCHB-WERKS,
         SGT_SCAT TYPE MCHB-SGT_SCAT,
       END OF TY_MCHB,

       BEGIN OF TY_MSEG,
         MBLNR(16),
         ZEILE      TYPE MSEG-ZEILE,
         LINE_ID    TYPE MSEG-LINE_ID,
         BWART      TYPE MSEG-BWART,
         MATNR      TYPE MSEG-MATNR,
         WERKS      TYPE MSEG-WERKS,
         MENGE      TYPE MSEG-MENGE,
         SMBLN      TYPE MSEG-SMBLN,
         BUKRS      TYPE MSEG-BUKRS,
         XBLNR_MKPF TYPE MSEG-XBLNR_MKPF,
         VBELP_IM   TYPE MSEG-VBELP_IM,
         VBELN_IM   TYPE MSEG-VBELN_IM,
       END OF TY_MSEG,

       BEGIN OF TY_MSEG1,
         MBLNR(16),
         ZEILE       TYPE MSEG-ZEILE,
         LINE_ID     TYPE MSEG-LINE_ID,
         BWART       TYPE MSEG-BWART,
         MATNR       TYPE MSEG-MATNR,
         WERKS       TYPE MSEG-WERKS,
         MENGE       TYPE MSEG-MENGE,
         MENGE1      TYPE MSEG-MENGE,
         FINAL_MENGE TYPE MSEG-MENGE,
         SMBLN       TYPE MSEG-SMBLN,
         BUKRS       TYPE MSEG-BUKRS,
         XBLNR_MKPF  TYPE MSEG-XBLNR_MKPF,
       END OF TY_MSEG1,

       BEGIN OF TY_MSEG2,
         MBLNR(16),
         ZEILE       TYPE MSEG-ZEILE,
         LINE_ID     TYPE MSEG-LINE_ID,
         BWART       TYPE MSEG-BWART,
         MATNR       TYPE MSEG-MATNR,
         WERKS       TYPE MSEG-WERKS,
         MENGE       TYPE MSEG-MENGE,
         MENGE1      TYPE MSEG-MENGE,
         FINAL_MENGE TYPE MSEG-MENGE,
         SMBLN       TYPE MSEG-SMBLN,
         BUKRS       TYPE MSEG-BUKRS,
         XBLNR_MKPF  TYPE MSEG-XBLNR_MKPF,
       END OF TY_MSEG2,

       BEGIN OF TY_T001K,
         BWKEY TYPE T001K-BWKEY,
         BUKRS TYPE T001K-BUKRS,
       END OF TY_T001K,

       BEGIN OF TY_MSSA,
         MATNR TYPE MSSA-MATNR,
         WERKS TYPE MSSA-WERKS,
         KZBWS TYPE MSSA-KZBWS,
       END OF TY_MSSA,

*  ***  for In Transit QTY
       BEGIN OF TY_VBAK,
         VBELN TYPE VBAK-VBELN,
         BSTNK TYPE VBAK-BSTNK,
       END OF TY_VBAK,

*      BEGIN OF ty_vbap,
*        vbeln  TYPE vbap-vbeln,
*        posnr  TYPE vbap-posnr,
*        matnr  TYPE vbap-matnr,
*        kwmeng TYPE vbap-kwmeng,
*        POSEX  TYPE vbap-POSEX,
*      END OF ty_vbap,

       BEGIN OF TY_VBRP,
         MATNR TYPE  VBRP-MATNR,
         WERKS TYPE VBRP-WERKS,
         VGBEL TYPE CHAR35,
         FKIMG TYPE VBRP-FKIMG,
       END OF TY_VBRP,

       BEGIN OF TY_VBRP_1,
         VGBEL TYPE CHAR10,
         AUBEL TYPE VBRP-AUBEL,
         AUPOS TYPE VBRP-AUPOS,
         MATNR TYPE VBRP-MATNR,
         WERKS TYPE VBRP-WERKS,
         FKIMG TYPE VBRP-FKIMG,
         VBELN TYPE VBRP-VBELN,
         POSNR TYPE VBRP-POSNR,
       END OF TY_VBRP_1,

       BEGIN OF TY_VBRP_2,
         VBELN TYPE  VBELN,
         POSNR TYPE  POSNR,
         VGBEL TYPE  CHAR35,
         VGPOS TYPE  VGPOS,
         MATNR TYPE  MATNR,
       END OF TY_VBRP_2,

       BEGIN OF TY_LIKP_1,
*         VERUR TYPE  LIKP-VERUR,
         VERUR TYPE  CHAR10,
       END OF TY_LIKP_1,

       BEGIN OF TY_LIKP,
         VBELN TYPE LIKP-VBELN,
         VERUR TYPE LIKP-VERUR,
         TRSPG TYPE LIKP-TRSPG,
       END OF TY_LIKP,

       BEGIN OF TY_VAPMA,
         MATNR TYPE VAPMA-MATNR,
         VKORG TYPE VAPMA-VKORG,
         BSTNK TYPE VAPMA-BSTNK,
         VBELN TYPE VAPMA-VBELN,
         POSNR TYPE VAPMA-POSNR,
         WERKS TYPE VAPMA-WERKS,
       END OF TY_VAPMA,

       BEGIN OF TY_VBRP_VAPMA,
         VBELN TYPE VBRP-VBELN,
         POSNR TYPE VBRP-POSNR,
         FKIMG TYPE VBRP-FKIMG,
         VGBEL TYPE CHAR35, "CHAR16,
         VGPOS TYPE VBRP-VGPOS,
         AUBEL TYPE VBRP-AUBEL,
         AUPOS TYPE VBRP-AUPOS,
         MATNR TYPE VBRP-MATNR,
         WERKS TYPE VBRP-WERKS,
         VKORG TYPE VAPMA-VKORG,
         BSTNK TYPE VAPMA-BSTNK,
         KUNNR TYPE VAPMA-KUNNR,
       END OF TY_VBRP_VAPMA,

       BEGIN OF STR_VBAP,
         VBELN  TYPE VBAP-VBELN,
         POSNR  TYPE VBAP-POSNR,
         MATNR  TYPE VBAP-MATNR,
         KWMENG TYPE VBAP-KWMENG,
         POSEX  TYPE VBAP-POSEX,
       END OF STR_VBAP,

*       BEGIN OF TY_FINAL,
*         MATNR      TYPE MARD-MATNR,
*         MATTXT     TYPE TEXT255,
*         WRKST      TYPE MARA-WRKST,
*         BRAND      TYPE MARA-BRAND,
*         ZSERIES    TYPE MARA-ZSERIES,
*         ZSIZE      TYPE MARA-ZSIZE,
*         MOC        TYPE MARA-MOC,
*         TYPE       TYPE MARA-TYPE,
*         MTART      TYPE MARA-MTART,
*         MATKL      TYPE MARA-MATKL,             "created by priyanka Jagtap on 19.08.2024
*         WERKS      TYPE MARD-WERKS,
*         LABST      TYPE MARD-LABST,
*         UMLME      TYPE MARD-UMLME,
*         INSME      TYPE MARD-INSME,
*         KULAB      TYPE MSKU-KULAB,
*         KALAB      TYPE MSKA-KALAB,
*         SPEME      TYPE MARD-SPEME,
*         RETME      TYPE MARD-RETME,
*         TOTAL      TYPE MSEG-MENGE,
*         MENGE      TYPE MSEG-MENGE,
*         LV_TVSTOCK TYPE P LENGTH 16 DECIMALS 4,
*         SALK3      TYPE MBEW-SALK3,       "added by priyanka
*         LGORT      TYPE MARD-LGORT,
*         KUNNR      TYPE MSKU-KUNNR,
*         VBELN      TYPE VBAP-VBELN,
*         LIFNR      TYPE MSLB-LIFNR,
*         LGPBE      TYPE MARD-LGPBE,
*         LBKUM      TYPE MBEW-LBKUM,
*         VMLAB      TYPE MARD-VMLAB,
*         VMUML      TYPE MARD-VMUML,
*         VMINS      TYPE MARD-VMINS,
*         VMEIN      TYPE MARD-VMEIN,
*         VMSPE      TYPE MARD-VMSPE,
*         VMRET      TYPE MARD-VMRET,
*         VPRSV      TYPE MBEW-VPRSV,
*         SOBKZ      TYPE MSKU-SOBKZ,
*         LV_LIFNR   TYPE STRING,
*         LV_CON     TYPE P DECIMALS 2,
*         LV_TOTAL   TYPE P DECIMALS 5,
*         LV_QAS     TYPE P DECIMALS 2,
*         TOTAL1 TYPE P LENGTH 16 DECIMALS 4,
*         REF        TYPE CHAR15,
*       END OF TY_FINAL,

       BEGIN OF TY_FINAL,
         MATNR      TYPE MARD-MATNR,
         MATTXT     TYPE TEXT255,
         WRKST      TYPE MARA-WRKST,
         BRAND      TYPE MARA-BRAND,
         ZSERIES    TYPE MARA-ZSERIES,
         ZSIZE      TYPE MARA-ZSIZE,
         MOC        TYPE MARA-MOC,
         TYPE       TYPE MARA-TYPE,
         MTART      TYPE MARA-MTART,
         MATKL      TYPE MARA-MATKL,             "created by priyanka Jagtap on 23.08.2024
         WERKS      TYPE MARD-WERKS,
         LABST      TYPE MARD-LABST,
         KUNNR      TYPE MSKU-KUNNR,
         LV_LIFNR   TYPE STRING,
         LBLAB      TYPE MSLB-LBLAB,
         KULAB      TYPE MSKU-KULAB,
         VBELN      TYPE VBAP-VBELN,
         KALAB      TYPE MSKA-KALAB,
         KAINS      TYPE MSKA-KAINS,
         INSME      TYPE MARD-INSME,
         LV_TOTAL   TYPE P DECIMALS 5,
         SPEME      TYPE MARD-SPEME,
         RETME      TYPE MARD-RETME,
         TOTAL      TYPE MSEG-MENGE,
         LV_TVSTOCK TYPE P LENGTH 16 DECIMALS 4,
         TOTAL1     TYPE P LENGTH 16 DECIMALS 4,
*         MENGE      TYPE MSEG-MENGE,
         FKIMG      TYPE VBRP-FKIMG,
         UMLME      TYPE MARD-UMLME,
         LV_CON     TYPE P DECIMALS 2,
         LGORT      TYPE MARD-LGORT,
         LGPBE      TYPE MARD-LGPBE,
         VMLAB      TYPE P LENGTH 16 DECIMALS 4,
         VMUML      TYPE MARD-VMUML,
         VMINS      TYPE MARD-VMINS,
         VMEIN      TYPE MARD-VMEIN,
         VMSPE      TYPE MARD-VMSPE,
         VMRET      TYPE MARD-VMRET,
*         REF        TYPE CHAR15,
*         VPRSV      TYPE MBEW-VPRSV,
*         SALK3      TYPE MBEW-SALK3,       "added by priyanka
*         LIFNR      TYPE MSLB-LIFNR,
*         LBKUM      TYPE MBEW-LBKUM,
*         SOBKZ      TYPE MSKU-SOBKZ,

       END OF TY_FINAL,

       BEGIN OF TY_STR,
         MATNR      TYPE MARD-MATNR,
         MATTXT     TYPE TEXT255,
*         WRKST      TYPE MARA-WRKST,
*         BRAND      TYPE MARA-BRAND,
*         ZSERIES    TYPE MARA-ZSERIES,
*         ZSIZE      TYPE MARA-ZSIZE,
*         MOC        TYPE MARA-MOC,
*         TYPE       TYPE MARA-TYPE,
         MTART      TYPE MARA-MTART,
         MATKL      TYPE MARA-MATKL,             "created by priyanka Jagtap on 23.08.2024
         WERKS      TYPE MARD-WERKS,
         LABST      TYPE STRING,
         KUNNR      TYPE MSKU-KUNNR,
         LV_LIFNR   TYPE STRING,
         LBLAB      TYPE STRING,
         KULAB      TYPE STRING,
         VBELN      TYPE VBAP-VBELN,
         KALAB      TYPE STRING,
         KAINS      TYPE STRING,
         INSME      TYPE STRING,
*         LV_TOTAL   TYPE P DECIMALS 5,
         LV_TOTAL   TYPE STRING,
         SPEME      TYPE STRING,
         RETME      TYPE STRING,
         TOTAL      TYPE STRING,
*         LV_TVSTOCK TYPE P LENGTH 16 DECIMALS 4,
         LV_TVSTOCK TYPE STRING,
*         TOTAL1 TYPE P LENGTH 16 DECIMALS 4,
         TOTAL1     TYPE STRING,
*         MENGE      TYPE MSEG-MENGE,
         FKIMG      TYPE CHAR15,
         UMLME      TYPE MARD-UMLME,
*         LV_CON     TYPE P DECIMALS 2,
         LV_CON     TYPE STRING,
         LGORT      TYPE MARD-LGORT,
         LGPBE      TYPE MARD-LGPBE,
         VMLAB      TYPE STRING,
         VMUML      TYPE STRING,
         VMINS      TYPE STRING,
         VMEIN      TYPE STRING,
         VMSPE      TYPE STRING,
         VMRET      TYPE STRING,
         REF        TYPE CHAR15,
         REF_TIME   TYPE CHAR15,
*         VPRSV      TYPE MBEW-VPRSV,
*         SALK3      TYPE MBEW-SALK3,       "added by priyanka
*         LIFNR      TYPE MSLB-LIFNR,
*         LBKUM      TYPE MBEW-LBKUM,
*         SOBKZ      TYPE MSKU-SOBKZ,
       END OF TY_STR,

*       BEGIN OF TY_STR,
*         MATNR      TYPE MARD-MATNR,
*         MATTXT     TYPE TEXT255,
*         WRKST      TYPE MARA-WRKST,
*         BRAND      TYPE MARA-BRAND,
*         ZSERIES    TYPE MARA-ZSERIES,
*         ZSIZE      TYPE MARA-ZSIZE,
*         MOC        TYPE MARA-MOC,
*         TYPE       TYPE MARA-TYPE,
*         MTART      TYPE MARA-MTART,
*         MATKL      TYPE MARA-MATKL,             "created by priyanka Jagtap on 19.08.2024
*         WERKS      TYPE MARD-WERKS,
*         LABST      TYPE MARD-LABST,
*         UMLME      TYPE MARD-UMLME,
*         INSME      TYPE MARD-INSME,
*         KULAB      TYPE MSKU-KULAB,
*         KALAB      TYPE MSKA-KALAB,
*         SPEME      TYPE MARD-SPEME,
*         RETME      TYPE MARD-RETME,
*         TOTAL      TYPE MSEG-MENGE,
*         MENGE      TYPE MSEG-MENGE,
*         SALK3      TYPE CHAR15,
*         LV_TVSTOCK TYPE P LENGTH 16 DECIMALS 4,
*         LGORT      TYPE MARD-LGORT,
*         KUNNR      TYPE MSKU-KUNNR,
*         VBELN      TYPE VBAP-VBELN,
*         LIFNR      TYPE  MSLB-LIFNR,
*
*         LGPBE      TYPE MARD-LGPBE,
*         LBKUM      TYPE MBEW-LBKUM,
*         VMLAB      TYPE MARD-VMLAB,
*         VMUML      TYPE MARD-VMUML,
*         VMINS      TYPE MARD-VMINS,
*         VMEIN      TYPE MARD-VMEIN,
*         VMSPE      TYPE MARD-VMSPE,
*         VMRET      TYPE MARD-VMRET,
*
*         VPRSV      TYPE MBEW-VPRSV,
*         SOBKZ      TYPE MSKU-SOBKZ,     "
*         LV_LIFNR   TYPE STRING,         "
*         LV_CON     TYPE P DECIMALS 2,        "
*         LV_TOTAL   TYPE P DECIMALS 5,           "added by priyanka 19.08.2024
*         TOTAL1 TYPE P LENGTH 16 DECIMALS 4,
**        SALK3      TYPE CHAR15,
**         LV_CON   TYPE CHAR15,
*         POSNR      TYPE VBAP-POSNR,
*         LV_ALL     TYPE CHAR15,
*         LV_QAS     TYPE CHAR15,
*         LV_SPEME   TYPE CHAR15,
*
*         NAME1      TYPE T001W-NAME1,
*         LGOBE      TYPE T001L-LGOBE,
**        LVORM    TYPE MARD-LVORM,
*         MEINS      TYPE MARA-MEINS,
*         WAERS      TYPE T001-WAERS,
*         EINME      TYPE CHAR15,
*         LV_REST    TYPE CHAR15,
*         LV_RETS    TYPE STRING,
*         BWESB      TYPE CHAR15,
*         LV_GR      TYPE STRING,
*         GLGMG      TYPE CHAR15,
*         LV_TIE     TYPE STRING,
*         KZBWS      TYPE MSSA-KZBWS,
*         SGT_SCAT   TYPE CHAR15,
*         TRAME      TYPE CHAR15,
*         LV_TRA     TYPE CHAR15,
**         UMLMC    TYPE CHAR15,
*         LV_TFR     TYPE CHAR15,
*         REF        TYPE CHAR15,
*         REF_TIME   TYPE CHAR15,
*       END OF TY_STR,

       BEGIN OF TY_VBRK,
         VBELN  TYPE VBRK-VBELN,
         FKART  TYPE VBRK-FKART,
         FKDAT  TYPE VBRK-FKDAT,
         KNUMV  TYPE VBRK-KNUMV,
         RFBSK  TYPE VBRK-RFBSK,
         KUNAG  TYPE VBRK-KUNAG,
         EXNUM  TYPE VBRK-EXNUM,
         XBLNR  TYPE VBRK-XBLNR,
         LOGSYS TYPE VBRK-LOGSYS,
         FKSTO  TYPE VBRK-FKSTO,
       END OF TY_VBRK,

       BEGIN OF TY_MSEG_NEW,
         MBLNR(16)," TYPE mseg-mblnr,
         MJAHR      TYPE MSEG-MJAHR,
         BWART      TYPE MSEG-BWART,
         MATNR      TYPE MSEG-MATNR,
         WERKS      TYPE MSEG-WERKS,
         SMBLN      TYPE MSEG-SMBLN,
         XBLNR_MKPF TYPE MSEG-XBLNR_MKPF,
         VBELN_IM   TYPE MSEG-VBELN_IM,
         VBELP_IM   TYPE MSEG-VBELP_IM,
         MENGE      TYPE MSEG-MENGE,
       END OF TY_MSEG_NEW,

       BEGIN OF TY_VBRP_NEW,
         VBELN TYPE VBELN,
         FKIMG TYPE FKIMG,
         VGBEL TYPE CHAR16,
         VGPOS TYPE VGPOS,
         MATNR TYPE MATNR,
       END OF TY_VBRP_NEW,

       BEGIN OF TY_EKPO,
         EBELN TYPE VBAK-BSTNK, "ekpo-ebeln,
         EBELP TYPE EKPO-EBELP,
         WERKS TYPE EKPO-WERKS,
         MENGE TYPE EKPO-MENGE,
         MATNR TYPE EKPO-MATNR,
       END OF TY_EKPO,

       BEGIN OF TY_TRANS,
         MATNR TYPE MARA-MATNR,
         FKIMG TYPE VBRP-FKIMG,
       END OF TY_TRANS,

       BEGIN OF TY_MARC,
         MATNR TYPE MATNR,
         WERKS TYPE WERKS,
         BWESB TYPE BWESB,
         GLGMG TYPE GLGMG,
         TRAME TYPE TRAME,
         UMLMC TYPE MARC-UMLMC,
       END OF TY_MARC.


DATA: IT_MARA       TYPE TABLE OF TY_MARA,
      WA_MARA       TYPE          TY_MARA,

      IT_MSEG_NEW11 TYPE TABLE OF TY_MSEG_NEW,
      WA_MSEG_NEW11 TYPE          TY_MSEG_NEW,

      IT_TRANS      TYPE TABLE OF TY_TRANS,
      WA_TRANS      TYPE          TY_TRANS,

      LT_VBAP       TYPE TABLE OF STR_VBAP,
      LS_VBAP       TYPE          STR_VBAP,

      IT_VBRP_12    TYPE TABLE OF TY_VBRP_NEW,
      WA_VBRP_12    TYPE          TY_VBRP_NEW,

      IT_TRASNIT    TYPE TABLE OF TY_TRASNIT,
      WA_TRASNIT    TYPE          TY_TRASNIT,

      IT_MARC       TYPE TABLE OF TY_MARC,
      WA_MARC       TYPE          TY_MARC,

      IT_VBAP       TYPE TABLE OF TY_VBAP,
      WA_VBAP       TYPE          TY_VBAP,

      IT_VBAK       TYPE TABLE OF TY_VBAK,
      WA_VBAK       TYPE          TY_VBAK,

      IT_VBRP       TYPE TABLE OF TY_VBRP,
      WA_VBRP       TYPE          TY_VBRP,

      IT_VBRP1      TYPE TABLE OF TY_VBRP,
      WA_VBRP1      TYPE          TY_VBRP,

      IT_VBRP_NEW   TYPE TABLE OF TY_VBRP,
      WA_VBRP_NEW   TYPE          TY_VBRP,

      IT_VBRK       TYPE TABLE OF TY_VBRK,
      WA_VBRK       TYPE          TY_VBRK,

      IT_LIKP       TYPE TABLE OF TY_LIKP,
      WA_LIKP       TYPE          TY_LIKP,

      IT_EKPO       TYPE TABLE OF TY_EKPO,
      WA_EKPO       TYPE          TY_EKPO,

      IT_VBRP_1     TYPE TABLE OF TY_VBRP_2,
      WA_VBRP_1     TYPE          TY_VBRP_2,

      IT_VBRP_2     TYPE TABLE OF TY_VBRP_1,
      WA_VBRP_2     TYPE          TY_VBRP_1,

      IT_VBRP_3     TYPE TABLE OF TY_VBRP_1,
      WA_VBRP_3     TYPE          TY_VBRP_1,

      IT_VAPMA      TYPE TABLE OF TY_VAPMA,
      WA_VAPMA      TYPE          TY_VAPMA,

      IT_VBRP_VAPMA TYPE TABLE OF TY_VBRP_VAPMA,
      WA_VBRP_VAPMA TYPE TY_VBRP_VAPMA,

      IT_MAKT       TYPE TABLE OF TY_MAKT,
      WA_MAKT       TYPE          TY_MAKT,

      IT_MARD       TYPE TABLE OF TY_MARD,
      WA_MARD       TYPE          TY_MARD,

      IT_MARA_MARD  TYPE TABLE OF TY_MARA_MARD,
      WA_MARA_MARD  TYPE          TY_MARA_MARD,

      IT_MBEW       TYPE TABLE OF TY_MBEW,
      WA_MBEW       TYPE          TY_MBEW,

      IT_EBEW       TYPE TABLE OF TY_EBEW,
      WA_EBEW       TYPE          TY_EBEW,

      IT_MSKA       TYPE TABLE OF TY_MSKA,
      WA_MSKA       TYPE          TY_MSKA,

      IT_MSKU       TYPE TABLE OF TY_MSKU,
      WA_MSKU       TYPE          TY_MSKU,

      IT_MCHB       TYPE TABLE OF TY_MCHB,
      WA_MCHB       TYPE          TY_MCHB,

      IT_MSLB       TYPE TABLE OF TY_MSLB,
      WA_MSLB       TYPE          TY_MSLB,

      IT_MSEG       TYPE TABLE OF TY_MSEG,
      WA_MSEG       TYPE          TY_MSEG,

      IT_MSEG_NEW   TYPE TABLE OF TY_MSEG1,
      WA_MSEG_NEW   TYPE          TY_MSEG1,

      IT_MSEG_NEW1  TYPE TABLE OF TY_MSEG2,
      WA_MSEG_NEW1  TYPE          TY_MSEG2,

      IT_MSEG1      TYPE TABLE OF TY_MSEG,
      WA_MSEG1      TYPE          TY_MSEG,

      IT_MSSA       TYPE TABLE OF TY_MSSA,
      WA_MSSA       TYPE          TY_MSSA,

      IT_MSEG2      TYPE TABLE OF TY_MSEG,
      WA_MSEG2      TYPE          TY_MSEG,

      IT_T001       TYPE TABLE OF TY_T001,
      WA_T001       TYPE          TY_T001,

      IT_REV        TYPE TABLE OF TY_MSEG,
      WA_REV        TYPE          TY_MSEG,

      IT_REV1       TYPE TABLE OF TY_MSEG,
      WA_REV1       TYPE          TY_MSEG,

      IT_REV2       TYPE TABLE OF TY_MSEG,
      WA_REV2       TYPE          TY_MSEG,

      IT_FINAL      TYPE TABLE OF TY_FINAL,
      WA_FINAL      TYPE          TY_FINAL,

      LT_FINAL      TYPE TABLE OF TY_STR,
      LS_FINAL      TYPE          TY_STR,

      LT_T001W      TYPE TABLE OF TY_T001W,
      LS_T001W      TYPE          TY_T001W,

      LT_T001K      TYPE TABLE OF TY_T001K,
      LS_T001K      TYPE          TY_T001K,

      IT_VBUP_1     TYPE TABLE OF TY_VBUP_1,
      WA_VBUP_1     TYPE          TY_VBUP_1,

      IT_LIKP_1     TYPE TABLE OF TY_LIKP_1,
      WA_LIKP_1     TYPE          TY_LIKP_1,

      LT_T001L      TYPE TABLE OF TY_T001L,
      LS_T001L      TYPE          TY_T001L.

DATA : LV_DIFF TYPE STRING.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
      GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
      I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
      WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV..            " LAYOUT WORKAREA
DATA T_SORT TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.



DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.



SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MARD-MATNR,
                S_LGORT FOR MARD-LGORT, "
                S_LGPBE FOR MARD-LGPBE,
                S_MTART FOR MARA-MTART,
                S_WERKS FOR MARD-WERKS. " NO INTERVALS MODIF ID BU.
*PARAMETERS :
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  'saudi'.    "'E:\delval\saudi' .
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

*AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
*LOOP AT SCREEN.
*  IF SCREEN-GROUP1 = 'BU'.
*    SCREEN-INPUT = '0'.
*    MODIFY SCREEN.
* ENDIF.
*ENDLOOP.

INITIALIZATION.
  S_WERKS-SIGN = 'I'.
  S_WERKS-OPTION = 'EQ' .
  S_WERKS-LOW = 'SU01'.
  APPEND S_WERKS .
  CLEAR:S_WERKS.
*  S_WERKS-LOW = 'US02'.
*  APPEND S_WERKS.
*CLEAR:s_werks.
*  S_WERKS-LOW = 'US03'.
*  APPEND S_WERKS.
*CLEAR:s_werks.

  "Added BY Nilay B. On Date:27.11.2023" " Tr NO. DEVK912688

AT SELECTION-SCREEN ON S_WERKS.
  IF S_WERKS-LOW = 'PL01' OR  S_WERKS-LOW = 'US01'  .

    MESSAGE 'You are not authorise for plant' TYPE 'E' DISPLAY LIKE 'E'.

  ENDIF.
  "Ended By NilaY B .



START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM SORT_DATA.
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


  SELECT   A~MATNR
           A~WERKS
           A~LGORT
           A~LGPBE
           B~MTART
           B~MATKL
           INTO TABLE IT_MARA_MARD FROM MARD AS A
           INNER JOIN MARA AS B ON B~MATNR = A~MATNR
           WHERE A~MATNR IN S_MATNR
           AND  A~LGORT IN S_LGORT   "
           AND  A~LGPBE IN S_LGPBE   "
           AND  B~MTART IN S_MTART
  AND  A~WERKS IN S_WERKS.


  SORT IT_MARA_MARD BY MATNR WERKS.
**  DELETE ADJACENT DUPLICATES FROM it_mara_mard COMPARING matnr werks.
**  DELETE it_mara_mard WHERE werks IN  ( 'PL01' , 'US01' ).

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
           LVORM
           LGPBE  FROM MARD INTO TABLE IT_MARD
            FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
*           AND    LGORT IS NOT NULL
           AND   LGORT = IT_MARA_MARD-LGORT  "
*           AND   LGPBE = IT_MARA_MARD-LGPBE  "  CHECK NEED
           AND   WERKS IN S_WERKS. "

*      DELETE IT_MARD WHERE labst EQ 0 AND insme EQ 0 AND  einme EQ 0 AND speme EQ 0   ""check
*         AND retme EQ 0.

    SELECT WERKS
           NAME1
      FROM T001W
      INTO TABLE LT_T001W
      FOR ALL ENTRIES IN IT_MARD
      WHERE WERKS = IT_MARD-WERKS.

    SELECT MATNR
           WERKS
           KZBWS
      FROM MSSA
      INTO TABLE IT_MSSA
      FOR ALL ENTRIES IN IT_MARD
      WHERE MATNR = IT_MARD-MATNR
      AND   WERKS = IT_MARD-WERKS.

    SELECT MATNR
           WERKS
           BWESB
           GLGMG
           TRAME
           UMLMC
      FROM MARC
      INTO TABLE IT_MARC
      FOR ALL ENTRIES IN IT_MARD
      WHERE MATNR = IT_MARD-MATNR
      AND   WERKS = IT_MARD-WERKS.

    SELECT LGORT
     LGOBE
FROM T001L
INTO TABLE LT_T001L
FOR ALL ENTRIES IN IT_MARD
WHERE LGORT = IT_MARD-LGORT.


    SELECT MATNR
           WERKS
           SGT_SCAT
      FROM MCHB
      INTO TABLE IT_MCHB
      FOR ALL ENTRIES IN IT_MARD
            WHERE MATNR = IT_MARD-MATNR
            AND   WERKS = IT_MARD-WERKS.

*    DELETE it_mard WHERE werks = 'SU01'.
    IF S_LGORT IS NOT INITIAL.   "ADDED FOR STORAGE LOCATION AND BIN
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
             WHERE MATNR IN S_MATNR
             AND   LGORT IN S_LGORT
             AND   WERKS = S_WERKS.
    ELSE.
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
               AND WERKS IN S_WERKS
               AND   LGORT IN S_LGORT.
    ENDIF.
*           AND   WERKS = IT_MARA_MARD-WERKS.


*    DELETE IT_MSKA WHERE  kalab EQ 0 AND kains EQ 0 AND  kaspe EQ 0 AND kavla EQ 0    "" check
*     AND kavin EQ 0 AND kavsp EQ 0 AND kavei EQ 0.

    IF IT_MSKA IS NOT INITIAL.
      SELECT VBELN
             POSNR
             LFSTA
             LFGSA
        FROM VBUP
        INTO TABLE IT_VBAP
        FOR ALL ENTRIES IN IT_MSKA
        WHERE VBELN = IT_MSKA-VBELN
        AND   POSNR = IT_MSKA-POSNR
        AND   LFSTA NE 'C'.
*        AND   LFGSA NE 'C' .
    ENDIF.

    SELECT A~MATNR
           A~WERKS
           A~LGORT
           A~SOBKZ
           A~KALAB
           A~KAINS
           A~KASPE
           A~KAVLA
           A~KAVIN
           A~KAVSP
           A~KAVEI
           B~VBELN
           B~POSNR
           B~LFSTA
           B~LFGSA
          FROM MSKA AS A INNER JOIN VBUP AS B
          ON  A~VBELN EQ B~VBELN
          AND A~POSNR EQ B~POSNR
          INTO TABLE IT_VBUP_1
          FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE A~MATNR = IT_MARA_MARD-MATNR
           AND   A~WERKS IN S_WERKS
           AND   A~LGORT IN S_LGORT  "" ADDED
           AND   B~LFSTA NE 'C'.
*           AND   B~LFGSA NE 'C' .

    SELECT MATNR
           WERKS
           CHARG
           SOBKZ
           KUNNR
           KULAB FROM MSKU INTO TABLE IT_MSKU
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
    AND   WERKS = IT_MARA_MARD-WERKS.

    SELECT MATNR
           WERKS
           LBLAB
           LBINS
           LBVLA
           LBVEI
           LBUML
           SOBKZ
           LIFNR
           FROM MSLB INTO TABLE IT_MSLB
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
    AND   WERKS = IT_MARA_MARD-WERKS.

    DELETE IT_MSLB WHERE LBLAB EQ 0 AND LBINS EQ 0 AND LBVLA EQ 0 AND LBVEI EQ 0   "" need to check
      AND LBUML EQ 0 .

    SELECT MATNR
           MAKTX FROM MAKT INTO TABLE IT_MAKT
           FOR ALL ENTRIES IN IT_MARA_MARD
    WHERE MATNR = IT_MARA_MARD-MATNR.


    SELECT MATNR
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE
           WRKST
           MEINS       FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_MARA_MARD
    WHERE MATNR = IT_MARA_MARD-MATNR.

*    SELECT MBLNR
*           ZEILE
*           LINE_ID
*           BWART
*           MATNR
*           WERKS
*           MENGE
*           SMBLN
*           BUKRS  FROM MSEG INTO TABLE IT_MSEG
*           FOR ALL ENTRIES IN IT_MARA_MARD
*           WHERE MATNR = IT_MARA_MARD-MATNR
*           AND   WERKS = IT_MARA_MARD-WERKS
**           AND   BWART = '103'.
*           AND   BWART IN ('103','106').

    SELECT BWKEY
           BUKRS
           FROM T001K INTO TABLE LT_T001K
           FOR ALL ENTRIES IN IT_MARD
           WHERE BWKEY = IT_MARD-WERKS.

    SELECT BUKRS
           WAERS
      FROM T001 INTO TABLE IT_T001
      FOR ALL ENTRIES IN LT_T001K
      WHERE BUKRS = LT_T001K-BUKRS."'US00'.

  ENDIF.

  IF IT_MARA_MARD[] IS NOT INITIAL.
    SELECT MATNR
           BWKEY
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS
           BKLAS
           FROM MBEW
           INTO TABLE IT_MBEW
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
           AND   BWKEY = IT_MARA_MARD-WERKS.
  ENDIF.

*  ******************for transit block*****************

  SELECT VBELN
     FKART
     FKDAT
     KNUMV
     RFBSK
     KUNAG
     EXNUM
     XBLNR
     LOGSYS
     FKSTO
     FROM VBRK INTO TABLE IT_VBRK
     WHERE KUNAG = '0000300315'
       AND FKSTO NE 'X'
       AND FKART NE 'ZS1'  AND FKART NE 'ZF5'
       AND LOGSYS NE ' '.

  IF IT_VBRK IS NOT INITIAL.
    SELECT A~VBELN
             A~POSNR
             A~FKIMG
             VGBEL
             A~VGPOS
             A~AUBEL
             A~AUPOS
             A~MATNR
             A~WERKS
             B~VKORG
             B~BSTNK
             B~KUNNR
         INTO TABLE IT_VBRP_VAPMA
            FROM VBRP AS A
            JOIN VAPMA AS B
            ON ( B~VBELN = A~AUBEL
            AND B~POSNR = A~AUPOS
            AND A~MATNR = B~MATNR )
           FOR ALL ENTRIES IN IT_VBRK
           WHERE A~VBELN  = IT_VBRK-VBELN
*           AND   A~WERKS = 'PL01'
           AND B~KUNNR = '0000300315'.
  ENDIF.

    SELECT MBLNR
           MJAHR
           BWART
           MATNR
           WERKS
           SMBLN
           XBLNR_MKPF
           VBELN_IM
           VBELP_IM
           MENGE
     FROM MSEG
     INTO TABLE IT_MSEG_NEW11
     FOR ALL ENTRIES IN IT_VBRP_VAPMA
     WHERE XBLNR_MKPF = IT_VBRP_VAPMA-VGBEL+(16)
     AND BWART EQ '101'.

  SORT IT_MSEG_NEW11 DESCENDING BY MBLNR.

  SELECT MBLNR
         ZEILE
         LINE_ID
         BWART
         MATNR
         WERKS
         MENGE
         SMBLN
         BUKRS
         XBLNR_MKPF
         VBELP_IM
         VBELN_IM  FROM MSEG INTO TABLE IT_MSEG1
         FOR ALL ENTRIES IN IT_MSEG_NEW11
     WHERE SMBLN = IT_MSEG_NEW11-MBLNR+0(10).

  LOOP AT  IT_MSEG1 INTO DATA(WA).
    DELETE IT_MSEG_NEW11 WHERE MBLNR = WA-SMBLN.
  ENDLOOP.

  SELECT VBELN
         VERUR
         TRSPG
        FROM LIKP
        INTO TABLE IT_LIKP
        FOR ALL ENTRIES IN IT_VBRP_VAPMA
        WHERE VERUR = IT_VBRP_VAPMA-VGBEL.

  SELECT VBELN
            POSNR
            MATNR
            KWMENG
            POSEX FROM VBAP INTO TABLE LT_VBAP
             FOR ALL ENTRIES IN IT_VBRP_VAPMA
            WHERE VBELN = IT_VBRP_VAPMA-AUBEL
              AND POSNR = IT_VBRP_VAPMA-AUPOS.

  SELECT EBELN
       EBELP
       WERKS
       MENGE
       MATNR FROM EKPO INTO TABLE IT_EKPO
  FOR ALL ENTRIES IN IT_VBRP_VAPMA
         WHERE EBELN = IT_VBRP_VAPMA-BSTNK+0(10).

  LOOP AT IT_VBRP_VAPMA INTO WA_VBRP_VAPMA WHERE VGBEL NE SPACE.

    WA_TRASNIT-FKIMG = WA_VBRP_VAPMA-FKIMG.
    WA_TRASNIT-MATNR = WA_VBRP_VAPMA-MATNR.

    READ TABLE IT_LIKP INTO WA_LIKP WITH KEY VERUR = WA_VBRP_VAPMA-VGBEL.
    IF SY-SUBRC = 0.
      WA_TRASNIT-VBELN_IM    =   WA_LIKP-VBELN.
    ENDIF.

    READ TABLE LT_VBAP INTO LS_VBAP WITH KEY VBELN = WA_VBRP_VAPMA-AUBEL POSNR = WA_VBRP_VAPMA-AUPOS. "vbeln = wa_vapma-vbeln posnr = wa_vapma-posnr.
    IF SY-SUBRC = 0.
    ENDIF.

    READ TABLE IT_EKPO INTO WA_EKPO WITH KEY MATNR = WA_VBRP_VAPMA-MATNR.
    IF SY-SUBRC = 0.
      WA_TRASNIT-EBELN = WA_EKPO-EBELN.
      WA_TRASNIT-WERKS = WA_EKPO-WERKS.
    ENDIF.

    READ TABLE IT_MSEG_NEW11 INTO WA_MSEG_NEW11 WITH KEY VBELN_IM = WA_LIKP-VBELN VBELP_IM = WA_VBRP_VAPMA-VGPOS.
    IF SY-SUBRC = 0.
      WA_TRASNIT-FKIMG    =    WA_TRASNIT-FKIMG - WA_MSEG_NEW11-MENGE.
    ENDIF.
       READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY smbln = WA_MSEG_NEW11-mblnr.
      IF sy-subrc = 4.
    IF WA_LIKP-TRSPG NE '03'.
      IF WA_TRASNIT-FKIMG <> 0.
        APPEND WA_TRASNIT TO IT_TRASNIT.
      ENDIF.
    ENDIF.
    ENDIF.
    CLEAR WA_TRASNIT.
  ENDLOOP.

  DELETE IT_TRASNIT WHERE EBELN  = ' '.
  DELETE IT_TRASNIT WHERE VBELN_IM  = ' '.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""
  SELECT MATNR
          WERKS FROM MARC INTO TABLE IT_MARC
          FOR ALL ENTRIES IN IT_TRASNIT
          WHERE MATNR = IT_TRASNIT-MATNR
            AND WERKS = IT_TRASNIT-WERKS.

  LOOP AT IT_MARC INTO WA_MARC.
    WA_TRANS-MATNR = WA_MARC-MATNR.
    LOOP AT IT_TRASNIT INTO WA_TRASNIT WHERE MATNR = WA_MARC-MATNR.

      WA_TRANS-FKIMG = WA_TRANS-FKIMG + WA_TRASNIT-FKIMG.
    ENDLOOP.
    APPEND WA_TRANS TO IT_TRANS.
    CLEAR WA_TRANS.
  ENDLOOP.


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

  LOOP AT IT_MARD INTO WA_MARD.

*    IF wa_mard-labst IS NOT INITIAL.     "" Commented by Pranit 30.07.2024 bcz value do not display.
    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MARD-MATNR LGORT = WA_MARD-LGORT WERKS = WA_MARD-WERKS.
    WA_FINAL-MATNR = WA_MARA_MARD-MATNR.
    WA_FINAL-WERKS = WA_MARA_MARD-WERKS.
    WA_FINAL-LGORT = WA_MARA_MARD-LGORT.
    WA_FINAL-LGPBE = WA_MARA_MARD-LGPBE.
    WA_FINAL-MTART = WA_MARA_MARD-MTART.
    WA_FINAL-MATKL = WA_MARA_MARD-MATKL.

    READ TABLE IT_MARC INTO WA_MARC WITH KEY MATNR = WA_MARD-MATNR WERKS = WA_MARD-WERKS.
    IF  SY-SUBRC = 0.
*      WA_FINAL-BWESB = WA_MARC-BWESB.
*      WA_FINAL-GLGMG = WA_MARC-GLGMG.
*      WA_FINAL-TRAME = WA_MARC-TRAME.
*      WA_FINAL-UMLMC = WA_MARC-UMLMC.
    ENDIF.

    READ TABLE IT_MCHB INTO WA_MCHB WITH KEY MATNR = WA_MARD-MATNR WERKS = WA_MARD-WERKS.
    IF  SY-SUBRC = 0.
*      WA_FINAL-SGT_SCAT = WA_MCHB-SGT_SCAT.
    ENDIF.

    READ TABLE IT_MSSA INTO WA_MSSA WITH  KEY MATNR = WA_MARD-MATNR WERKS = WA_MARD-WERKS.
    IF SY-SUBRC = 0.
*      WA_FINAL-KZBWS = WA_MSSA-KZBWS.
    ENDIF.


*    WA_FINAL-LGORT = WA_MARD-LGORT.            "added by pankaj 21.03.2022
    WA_FINAL-LABST = WA_MARD-LABST.
    WA_FINAL-UMLME = WA_MARD-UMLME.  "
    WA_FINAL-INSME = WA_MARD-INSME.
    WA_FINAL-SPEME = WA_MARD-SPEME.
    WA_FINAL-RETME = WA_MARD-RETME.
*    WA_FINAL-LGPBE = WA_MARD-LGPBE.
    WA_FINAL-VMUML = WA_MARD-VMUML.
    WA_FINAL-VMINS = WA_MARD-VMINS.
    WA_FINAL-VMEIN = WA_MARD-VMEIN.
    WA_FINAL-VMSPE = WA_MARD-VMSPE.
    WA_FINAL-VMRET = WA_MARD-VMRET.
*    WA_FINAL-LVORM = WA_MARD-LVORM.
*    WA_FINAL-EINME = WA_MARD-EINME.

    WA_FINAL-TOTAL1  = WA_MARD-INSME + WA_MARD-LABST + WA_MARD-UMLME. "ADDED FOR TOTAL STOCK 22.08.24


*    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MARD-MATNR
*                                                       WERKS = WA_MARD-WERKS.
*    IF SY-SUBRC = 0.
*      WA_FINAL-MTART = WA_MARA_MARD-MTART.
*      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
*      WA_FINAL-WERKS = WA_MARA_MARD-WERKS.
*    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARA_MARD-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-MATNR       = WA_MARA-MATNR.
      WA_FINAL-ZSERIES     = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE       = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND       = WA_MARA-BRAND   .
      WA_FINAL-MOC         = WA_MARA-MOC     .
      WA_FINAL-TYPE        = WA_MARA-TYPE    .
      WA_FINAL-WRKST       = WA_MARA-WRKST   .
*      WA_FINAL-MEINS       = WA_MARA-MEINS   .
    ENDIF.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MARA_MARD-MATNR BWKEY = WA_MARA_MARD-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-TOTAL = WA_FINAL-LABST + WA_FINAL-KULAB  + WA_FINAL-KALAB.
      LV_DIFF = WA_MBEW-SALK3 / WA_MBEW-LBKUM.
*      WA_FINAL-SALK3 = LV_DIFF * LV_LABST.
      WA_FINAL-LV_TVSTOCK =  LV_DIFF * WA_FINAL-TOTAL.

      IF WA_MBEW-VPRSV = 'V'.
        WA_FINAL-LV_CON = WA_MBEW-VERPR.
        WA_FINAL-LV_TOTAL = WA_MBEW-VERPR  * WA_FINAL-INSME.
      ELSE.
        WA_MBEW-VPRSV = 'S'.
        WA_FINAL-LV_CON = WA_MBEW-STPRS.
        WA_FINAL-LV_TOTAL = WA_MBEW-STPRS * WA_FINAL-INSME.
      ENDIF.
    ENDIF.
    CLEAR : LV_LINES, LS_MATTXT.
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

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-MATTXT WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-MATTXT WITH SPACE.

*    WA_FINAL-REF = SY-DATUM.

*    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*      EXPORTING
*        INPUT  = WA_FINAL-REF
*      IMPORTING
*        OUTPUT = WA_FINAL-REF.
*
*    CONCATENATE WA_FINAL-REF+0(2) WA_FINAL-REF+2(3) WA_FINAL-REF+5(4)
*                    INTO WA_FINAL-REF SEPARATED BY '-'.


    READ TABLE LT_T001W INTO LS_T001W WITH KEY WERKS = WA_FINAL-WERKS.
    IF  SY-SUBRC = 0.
*      WA_FINAL-NAME1 = LS_T001W-NAME1.
    ENDIF.

    READ TABLE LT_T001L INTO LS_T001L WITH KEY LGORT = WA_FINAL-LGORT.
    IF  SY-SUBRC = 0.
*      WA_FINAL-LGOBE = LS_T001L-LGOBE.
    ENDIF.

*    READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MATNR = WA_MARA_MARD-MATNR WERKS = WA_MARA_MARD-WERKS.

    READ TABLE IT_T001 INTO WA_T001 INDEX 1." WITH KEY WERKS = WA_FINAL-WERKS .
    IF SY-SUBRC = 0.
*      WA_FINAL-WAERS = WA_T001-WAERS.
    ENDIF.

*    WA_FINAL-TOTAL = WA_FINAL-LABST + WA_FINAL-UMLME + WA_FINAL-INSME + WA_FINAL-KULAB         """TOTAL STOCK
*                     + WA_FINAL-KALAB + WA_FINAL-SPEME + WA_FINAL-RETME.

    WA_FINAL-TOTAL = WA_FINAL-LABST + WA_FINAL-KULAB  + WA_FINAL-KALAB .
*    WA_FINAL-LV_TVSTOCK = WA_FINAL-TOTAL * WA_FINAL-LV_CON.    "ADDED BY PRIYANKA J 21-08-24

        WA_FINAL-VMLAB = WA_FINAL-LV_CON * WA_FINAL-LABST.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""In transit Block
*        LOOP AT IT_MSEG INTO WA_MSEG WHERE MATNR = WA_MARA-MATNR AND  WERKS = WA_MARA_MARD-WERKS..
*      READ TABLE IT_REV INTO WA_REV WITH KEY SMBLN = WA_MSEG-MBLNR MATNR = WA_MSEG-MATNR.
*      IF SY-SUBRC = 4.
*        WA_FINAL-MENGE = WA_FINAL-MENGE  + WA_MSEG-MENGE.
*      ENDIF.
*      WA_FINAL-WERKS = WA_MSEG-WERKS.
*
*    ENDLOOP.
*
*    LOOP AT IT_MSEG1 INTO WA_MSEG1 WHERE MATNR = WA_MARA-MATNR AND  WERKS = WA_MARA_MARD-WERKS.
** wa_final-werks = wa_mseg-werks.
*      READ TABLE IT_REV1 INTO WA_REV1 WITH KEY SMBLN = WA_MSEG1-MBLNR MATNR = WA_MSEG1-MATNR.
*      IF SY-SUBRC = 4.
*        WA_FINAL-MENGE = WA_FINAL-MENGE  - WA_MSEG1-MENGE.
*      ENDIF.
*    ENDLOOP.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.

  LOOP AT IT_MSKU INTO WA_MSKU .                         """""FOR CUSTOMER VALUE
    WA_FINAL-MATNR = WA_MSKU-MATNR.
    WA_FINAL-WERKS = WA_MSKU-WERKS.
    WA_FINAL-KUNNR = WA_MSKU-KUNNR.
    WA_FINAL-KULAB = WA_MSKU-KULAB.
*    WA_FINAL-SOBKZ = WA_MSKU-SOBKZ.

    WA_FINAL-TOTAL1 = WA_MSKU-KULAB.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_FINAL-MATNR BWKEY = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.
      LV_DIFF = WA_MBEW-SALK3 / WA_MBEW-LBKUM.
      WA_FINAL-TOTAL = WA_FINAL-KULAB .
      WA_FINAL-LV_TVSTOCK =  LV_DIFF * WA_FINAL-TOTAL.    "Total Valuated Stock 22.08.24
      IF WA_MBEW-VPRSV = 'V'.
        WA_FINAL-LV_CON = WA_MBEW-VERPR.
      ELSEIF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-LV_CON = WA_MBEW-STPRS.
      ENDIF.
    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MSKU-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-WRKST       = WA_MARA-WRKST   .
      WA_FINAL-ZSERIES     = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE       = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND       = WA_MARA-BRAND   .
      WA_FINAL-MOC         = WA_MARA-MOC     .
      WA_FINAL-TYPE        = WA_MARA-TYPE    .
*      WA_FINAL-MEINS       = WA_MARA-MEINS   .
    ENDIF.

    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MSKU-MATNR WERKS = WA_MSKU-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART.
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
      WA_FINAL-WERKS = WA_MARA_MARD-WERKS.
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
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-MATTXT WA_LINES-TDLINE INTO WA_FINAL-MATTXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-MATTXT.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-MATTXT WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-MATTXT WITH SPACE.

    READ TABLE LT_T001W INTO LS_T001W WITH KEY WERKS = WA_MARD-WERKS.
    IF  SY-SUBRC = 0.
*      WA_FINAL-NAME1 = LS_T001W-NAME1.
    ENDIF.

*    READ TABLE LT_T001 INTO LS_T001 WITH KEY BUKRS = WA_MSEG-BUKRS .
    READ TABLE IT_T001 INTO WA_T001 INDEX 1.
    IF SY-SUBRC = 0.
*      WA_FINAL-WAERS = WA_T001-WAERS.
    ENDIF.

***for unrestricted use stock******
    READ TABLE IT_MARD INTO WA_MARD WITH KEY MATNR = WA_MSKU-MATNR ." WERKS = WA_MSKU-WERKS.
    IF  SY-SUBRC = 0.
*     WA_FINAL-LVORM = WA_MARD-LVORM.
*      WA_FINAL-LABST = WA_MARD-LABST.

    ENDIF.

    READ TABLE IT_MSSA INTO WA_MSSA WITH KEY MATNR = WA_MSKU-MATNR WERKS = WA_MSKU-WERKS.
    IF SY-SUBRC = 0.
*      WA_FINAL-KZBWS = WA_MSSA-KZBWS.
    ENDIF.

*    WA_FINAL-LV_TVSTOCK = WA_FINAL-TOTAL * WA_FINAL-LV_CON.  "ADDED BY PRIYANKA JAGTAP 21.08.24

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR: WA_FINAL.
  ENDLOOP.

  LOOP AT IT_VBUP_1 INTO WA_VBUP_1.                  "" FOR SALES ORDER VALUE
    WA_FINAL-VBELN = WA_VBUP_1-VBELN.
*    WA_FINAL-POSNR = WA_VBUP_1-POSNR.
    WA_FINAL-MATNR = WA_VBUP_1-MATNR.
    WA_FINAL-WERKS = WA_VBUP_1-WERKS.


    WA_FINAL-INSME = WA_VBUP_1-KAINS.
    WA_FINAL-KAINS = WA_VBUP_1-KAINS.

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

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-MATTXT WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-MATTXT WITH SPACE.

*    READ TABLE IT_MSKA INTO WA_MSKA WITH KEY VBELN = WA_VBUP_1-VBELN POSNR = WA_VBUP_1-POSNR.
*    IF  SY-SUBRC = 0.
*      WA_FINAL-KALAB  = WA_MSKA-KALAB.
**      WA_FINAL-SOBKZ  = WA_MSKA-SOBKZ.

*      WA_FINAL-TOTAL1 =   WA_MSKA-KALAB + WA_FINAL-kains.
    WA_FINAL-TOTAL = WA_VBUP_1-KALAB.
    WA_FINAL-TOTAL1 =  WA_FINAL-TOTAL + WA_FINAL-KULAB + WA_FINAL-KAINS. "KALAB FROM MSKA 22.08.24
*    ENDIF.

*    ********CHANGES FOR Unrestricted use stock
*    READ TABLE IT_MSKA INTO WA_MSKA WITH KEY MATNR = WA_VBUP_1-MATNR LGORT =  WA_VBUP_1-LGORT WERKS = WA_VBUP_1-WERKS .
*    IF  SY-SUBRC = 0.
*      WA_FINAL-LABST = WA_MSKA-KALAB.
*    ENDIF.


    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_VBUP_1-MATNR. "WERKS = WA_VBUP_1-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART.
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
    ENDIF.



    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY  MATNR = WA_VBUP_1-MATNR BWKEY = WA_FINAL-WERKS.
    IF  SY-SUBRC = 0.
      LV_DIFF = WA_MBEW-SALK3 / WA_MBEW-LBKUM.
      WA_FINAL-LV_TVSTOCK =  LV_DIFF * WA_FINAL-TOTAL.    "Total Valuated Stock 22.08.24

      IF WA_MBEW-VPRSV = 'V'.
        WA_FINAL-LV_CON = WA_MBEW-VERPR.
*        WA_FINAL-LV_ALL = WA_MBEW-VERPR * WA_FINAL-KALAB.

      ELSEIF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-LV_CON = WA_MBEW-STPRS.
*        WA_FINAL-LV_ALL = WA_MBEW-STPRS * WA_FINAL-KALAB.
      ENDIF.
    ENDIF.
*    WA_FINAL-LV_TVSTOCK = WA_FINAL-TOTAL * WA_FINAL-LV_CON.  "ADDED BY PRIYANKA JAGTAP 21.08.24

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_VBUP_1-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-WRKST       = WA_MARA-WRKST   .
      WA_FINAL-ZSERIES     = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE       = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND       = WA_MARA-BRAND   .
      WA_FINAL-MOC         = WA_MARA-MOC     .
      WA_FINAL-TYPE        = WA_MARA-TYPE    .
*      WA_FINAL-MEINS       = WA_MARA-MEINS   .
    ENDIF.

    READ TABLE IT_MARD INTO WA_MARD WITH KEY MATNR = WA_VBUP_1-MATNR WERKS = WA_VBUP_1-WERKS LGORT =  WA_VBUP_1-LGORT.
    IF  SY-SUBRC = 0.
      WA_FINAL-LGORT = WA_MARD-LGORT.
      WA_FINAL-KALAB = WA_VBUP_1-KALAB.
    ENDIF.

    READ TABLE LT_T001W INTO LS_T001W WITH KEY WERKS = WA_VBUP_1-WERKS.
    IF  SY-SUBRC = 0.
*      WA_FINAL-NAME1 = LS_T001W-NAME1.
    ENDIF.

    READ TABLE LT_T001L INTO LS_T001L WITH KEY LGORT = WA_FINAL-LGORT.
    IF  SY-SUBRC = 0.
*      WA_FINAL-LGOBE = LS_T001L-LGOBE.
    ENDIF.

*    READ TABLE LT_T001 INTO LS_T001 WITH KEY BUKRS = WA_MSEG-BUKRS .
    READ TABLE IT_T001 INTO WA_T001 INDEX 1.
    IF SY-SUBRC = 0.
*      WA_FINAL-WAERS = WA_T001-WAERS.
    ENDIF.

    READ TABLE IT_MSSA INTO WA_MSSA WITH KEY MATNR = WA_VBUP_1-MATNR WERKS = WA_VBUP_1-WERKS.
    IF SY-SUBRC = 0.
*      WA_FINAL-KZBWS = WA_MSSA-KZBWS.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR:WA_FINAL.
  ENDLOOP.

***IF MSLB-SOBKZ=O PICK MSLB-LIFNR

  LOOP AT IT_MSLB INTO WA_MSLB.
    WA_FINAL-MATNR = WA_MSLB-MATNR.
    WA_FINAL-WERKS = WA_MSLB-WERKS.
*    WA_FINAL-KULAB = WA_MSLB-LBLAB. "comment on 25.08.24
    WA_FINAL-TOTAL = WA_MSLB-LBLAB.
*    WA_FINAL-SOBKZ = WA_MSLB-SOBKZ.
*    WA_FINAL-KUNNR = WA_MSLB-LIFNR.
    WA_FINAL-LBLAB = WA_MSLB-LBLAB.

    WA_FINAL-TOTAL1 = WA_MSLB-LBLAB.
*    WA_FINAL-LV_TVSTOCK = WA_FINAL-TOTAL * WA_FINAL-LV_CON.  "ADDED BY PRIYANKA JAGTAP 21.08.24

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_FINAL-MATNR BWKEY = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.

      IF WA_MBEW-VPRSV = 'V'.
        WA_FINAL-LV_CON = WA_MBEW-VERPR.
      ELSEIF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-LV_CON = WA_MBEW-STPRS.
      ENDIF.
      WA_FINAL-LV_TVSTOCK = WA_FINAL-TOTAL * WA_FINAL-LV_CON.  "ADDED BY PRIYANKA JAGTAP 21.08.24

      IF WA_MSLB-SOBKZ = 'O'."  PICK MSLB-LIFNR
        WA_FINAL-LV_LIFNR =  WA_MSLB-LIFNR.
      ENDIF.
    ENDIF.


    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_FINAL-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-WRKST       = WA_MARA-WRKST   .
      WA_FINAL-ZSERIES     = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE       = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND       = WA_MARA-BRAND   .
      WA_FINAL-MOC         = WA_MARA-MOC     .
      WA_FINAL-TYPE        = WA_MARA-TYPE    .
*      WA_FINAL-MEINS       = WA_MARA-MEINS   .
    ENDIF.

*    READ TABLE IT_MARD INTO WA_MARD WITH KEY MATNR = WA_FINAL-MATNR.
*    IF  SY-SUBRC = 0.
*      WA_FINAL-LGORT = WA_MARD-LGORT.
*    ENDIF.

    READ TABLE LT_T001W INTO LS_T001W WITH KEY WERKS = WA_FINAL-WERKS.
    IF  SY-SUBRC = 0.
*      WA_FINAL-NAME1 = LS_T001W-NAME1.
    ENDIF.

    READ TABLE LT_T001L INTO LS_T001L WITH KEY LGORT = WA_FINAL-LGORT.
    IF  SY-SUBRC = 0.
*      WA_FINAL-LGOBE = LS_T001L-LGOBE.
    ENDIF.

    READ TABLE IT_T001 INTO WA_T001 INDEX 1.
    IF SY-SUBRC = 0.
*      WA_FINAL-WAERS = WA_T001-WAERS.
    ENDIF.

    READ TABLE IT_MSSA INTO WA_MSSA WITH KEY MATNR = WA_FINAL-MATNR WERKS = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.
*      WA_FINAL-KZBWS = WA_MSSA-KZBWS.
    ENDIF.

    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_FINAL-MATNR WERKS = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART.
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
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

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-MATTXT WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-MATTXT WITH SPACE.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.

  LOOP AT IT_MARD INTO WA_MARD.

    WA_FINAL-WERKS = WA_MARD-WERKS.
    WA_FINAL-MATNR = WA_MARD-MATNR.
    READ TABLE IT_TRANS INTO WA_TRANS WITH KEY MATNR =  WA_MARD-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-FKIMG = WA_TRANS-FKIMG.

    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_FINAL-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-WRKST       = WA_MARA-WRKST   .
      WA_FINAL-ZSERIES     = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE       = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND       = WA_MARA-BRAND   .
      WA_FINAL-MOC         = WA_MARA-MOC     .
      WA_FINAL-TYPE        = WA_MARA-TYPE    .
*      WA_FINAL-MEINS       = WA_MARA-MEINS   .
    ENDIF.

*    READ TABLE LT_T001W INTO LS_T001W WITH KEY WERKS = WA_FINAL-WERKS.
*    IF  SY-SUBRC = 0.
*      WA_FINAL-NAME1 = LS_T001W-NAME1.
*    ENDIF.

*    READ TABLE IT_T001 INTO WA_T001 INDEX 1.
*    IF SY-SUBRC = 0.
*      WA_FINAL-WAERS = WA_T001-WAERS.
*    ENDIF.
*
*    READ TABLE IT_MSSA INTO WA_MSSA WITH KEY MATNR = WA_FINAL-MATNR WERKS = WA_FINAL-WERKS.
*    IF SY-SUBRC = 0.
*      WA_FINAL-KZBWS = WA_MSSA-KZBWS.
*    ENDIF.

    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_FINAL-MATNR WERKS = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART.
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
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
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-MATTXT WA_LINES-TDLINE INTO WA_FINAL-MATTXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-MATTXT.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-MATTXT WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-MATTXT WITH SPACE.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.
  IF S_LGORT IS NOT INITIAL.
    DELETE IT_FINAL WHERE LGORT EQ ''.
  ENDIF.
  DELETE IT_FINAL WHERE MATNR EQ SPACE.
  SORT IT_FINAL BY MATNR.


  IF  P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      LS_FINAL-MATNR    = WA_FINAL-MATNR   .
      LS_FINAL-MATTXT   = WA_FINAL-MATTXT  .
      LS_FINAL-MTART    = WA_FINAL-MTART   .
      LS_FINAL-MATKL    = WA_FINAL-MATKL   .
      LS_FINAL-WERKS    = WA_FINAL-WERKS   .
      LS_FINAL-LABST    = WA_FINAL-LABST   .
      LS_FINAL-KUNNR   = WA_FINAL-KUNNR    .
      LS_FINAL-LV_LIFNR = WA_FINAL-LV_LIFNR.
      LS_FINAL-LBLAB  =   WA_FINAL-LBLAB  .
      LS_FINAL-KULAB    = WA_FINAL-KULAB   .
      LS_FINAL-VBELN    = WA_FINAL-VBELN  .
      LS_FINAL-KALAB    = WA_FINAL-KALAB   .
      LS_FINAL-KAINS    = WA_FINAL-KAINS   .
      LS_FINAL-INSME    = WA_FINAL-INSME   .
      LS_FINAL-LV_TOTAL = WA_FINAL-LV_TOTAL  .
      LS_FINAL-SPEME    = WA_FINAL-SPEME   .
      LS_FINAL-RETME    = WA_FINAL-RETME   .
      LS_FINAL-TOTAL    = WA_FINAL-TOTAL   .
      LS_FINAL-LV_TVSTOCK = WA_FINAL-LV_TVSTOCK.
      LS_FINAL-TOTAL1 =   WA_FINAL-TOTAL1.
*      LS_FINAL-MENGE    = WA_FINAL-MENGE   .
      LS_FINAL-FKIMG    =  WA_FINAL-FKIMG.
      LS_FINAL-UMLME    = WA_FINAL-UMLME   .
      LS_FINAL-LV_CON   = WA_FINAL-LV_CON     .
      LS_FINAL-LGORT    = WA_FINAL-LGORT     .
      LS_FINAL-LGPBE =    WA_FINAL-LGPBE.
      LS_FINAL-VMLAB  =   WA_FINAL-VMLAB.
      LS_FINAL-VMUML =    WA_FINAL-VMUML.
      LS_FINAL-VMINS =     WA_FINAL-VMINS.
      LS_FINAL-VMEIN  =    WA_FINAL-VMEIN.
      LS_FINAL-VMSPE  =    WA_FINAL-VMSPE.
      LS_FINAL-VMRET =     WA_FINAL-VMRET.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = LS_FINAL-REF.
      CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
     INTO LS_FINAL-REF SEPARATED BY '-'.

      LS_FINAL-REF_TIME = SY-UZEIT.
      CONCATENATE LS_FINAL-REF_TIME+0(2) ':' LS_FINAL-REF_TIME+2(2)  INTO LS_FINAL-REF_TIME.
      APPEND LS_FINAL TO LT_FINAL.
      CLEAR LS_FINAL.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DET_FCAT
*&---------------------------------------------------------------------*
*       text
*-----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DET_FCAT.
  PERFORM FCAT USING :
                       '1'   'MATNR'         'IT_FINAL'  'Material.No.'                                    '18',
                       '2'   'MATTXT'        'IT_FINAL'  'Material Desc'                                   '18',
                       '9'   'MTART'         'IT_FINAL'  'Material Type'                                   '18',
                       '10'  'MATKL'         'IT_FINAL'  'Material Group'                                  '20',
                       '11'  'WERKS'         'IT_FINAL'  'Plant'                                           '8',
                       '12'  'LABST'         'IT_FINAL'  'Unrestricted-Use Stock'                          '20',
                       '13'  'KUNNR'         'IT_FINAL'  'Special Stock No.'                               '18',
                       '14'  'LV_LIFNR'      'IT_FINAL'  'Subcon Vendor'                                   '15',
                       '15'  'LBLAB'         'IT_FINAL'  'Stock To Vendor'                                 '15',
                       '16'  'KULAB'         'IT_FINAL'  'Consignment Stock'                               '15',
                       '17'  'VBELN'         'IT_FINAL'  'Sales Document'                                  '10',
                       '18'  'KALAB'         'IT_FINAL'  'SO Allocated Stock'                              '15',
                       '19'  'KAINS'         'IT_FINAL'   'SO Quality Inspection Stock '                 '15',
                       '20'  'INSME'         'IT_FINAL'  'Stock In Quality Inspection'                     '30',
                       '21'  'LV_TOTAL'      'IT_FINAL'  'Value Of Stock In Quality Inspection'            '30',
                       '22'  'SPEME'         'IT_FINAL'  'Blocked Stock'                                   '10',
                       '23'  'RETME'         'IT_FINAL'  'Blocked Stock Returns'                           '20',
                       '24'  'TOTAL'         'IT_FINAL'  'Total Valuated Stock'                            '10',
                       '25'  'LV_TVSTOCK'    'IT_FINAL'   'Value Of Total Valuated Stock'                  '30',
                       '26'  'TOTAL1'        'IT_FINAL'  'Total Stock'                                     '18',
                       '27'  'FKIMG'         'IT_FINAL'  'In Transit QTY'                                  '15',
                       '28'  'UMLME'         'IT_FINAL'  'Stock in transfer'                               '18',
                       '29'  'LV_CON'        'IT_FINAL'  'Price'                                           '18',
                       '30'  'LGORT'         'IT_FINAL'  'Storage Location'                                '10',
                       '31'  'LGPBE'         'IT_FINAL'   'Storage Bin'                                    '18',
                       '32'  'VMLAB'         'IT_FINAL'  'Valuated unrestricted-use stock'                 '30',
                       '33'  'VMUML'         'IT_FINAL'  'Stock in Transfer in Previous Period'            '40',
                       '34'  'VMINS'         'IT_FINAL'  'Stock in Quality Inspection in Previous Period'  '45',
                       '35'  'VMEIN'         'IT_FINAL'  'Restricted-Use Stock in Previous Period'         '30',
                       '36'  'VMSPE'         'IT_FINAL'  'Blocked stock of previous period'                '30',
                       '37'  'VMRET'         'IT_FINAL'  'Blocked Stock Returns in Previous Period'        '30'.

ENDFORM.

******************************************************************************************
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1435   text
*      -->P_1436   text
*      -->P_1437   text
*      -->P_1438   text
*      -->P_1439   text
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
  IF P2 = 'LV_TVSTOCK'.
    WA_FCAT-DO_SUM =  'X'.
  ENDIF.
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
      I_CALLBACK_PROGRAM     = SY-REPID
      I_CALLBACK_TOP_OF_PAGE = 'TOP-OF-PAGE'
      IS_LAYOUT              = WA_LAYOUT
      IT_FIELDCAT            = IT_FCAT
      IT_SORT                = T_SORT[]
      I_SAVE                 = 'X'
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
  LS_HEADER-INFO = 'SAUDI MB52 Report New'.
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
    EXPORTING
*     I_FIELD_SEPERATOR    =
*     I_LINE_HEADER        =
      I_FILENAME           = 'DAT'
*     I_APPL_KEEP          = ' '
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


  LV_FILE = 'ZSU_MB52_NEW.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'SAUDI MB52 NEW REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_2162 TYPE string.
DATA lv_crlf_2162 TYPE string.
lv_crlf_2162 = cl_abap_char_utilities=>cr_lf.
lv_string_2162 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_2162 lv_crlf_2162 wa_csv INTO lv_string_2162.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_2162 TO lv_fullfile.
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


  LV_FILE = 'ZSU_MB52_NEW.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSAUDI MB52 NEW REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_2199 TYPE string.
DATA lv_crlf_2199 TYPE string.
lv_crlf_2199 = cl_abap_char_utilities=>cr_lf.
lv_string_2199 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_2199 lv_crlf_2199 wa_csv INTO lv_string_2199.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_2199 TO lv_fullfile.
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
  CONCATENATE
                'Material.No.'
                'Material Desc'
                 'Material Type'
                 'Material Group'
                 'Plant'
                 'Unrestricted-Use Stock'
                 'Special Stock No.'
                  'Subcon Vendor'
                  'Stock To Vendor'
                  'Consignment Stock'
                  'Sales Document'
                  'SO Allocated Stock'
                  'SO Quality Inspection Stock'
                  'Stock In Quality Inspection'
                  'Value Of Stock In Quality Inspection'
                  'Blocked Stock'
                  'Blocked Stock Returns'
                  'Total Valuated Stock'
                  'Value Of Total Valuated Stock'
                  'Total Stock'
                  'In Transit QTY'
                  'Stock in transfer'
                  'Price'
                  'Storage Location'
                   'Storage Bin'
                  'Valuated unrestricted-use stock'
                  'Stock in Transfer in Previous Period'
                  'Stock in Quality Inspection in Previous Period'
                  'Restricted-Use Stock in Previous Period'
                  'Blocked stock of previous period'
                  'Blocked Stock Returns in Previous Period'
                  'Refresh Date'
                  'Refresh Time'

                INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
