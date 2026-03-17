*&---------------------------------------------------------------------*
*&  Include           ZSU_DELIVERY_CHALLAN_DEC
*&---------------------------------------------------------------------*
TABLES: T001W,
        LFA1,
        MKPF,
        J_1IG_SUB_INV, MSEG,ZSU_CHALLANNO.


TYPES : BEGIN OF TY_MKPF,
          MBLNR TYPE MKPF-MBLNR,
          BUDAT TYPE MKPF-BUDAT,

        END OF TY_MKPF.

TYPES:BEGIN OF TY_MSEG,
        MBLNR      TYPE MSEG-MBLNR,
        MATNR      TYPE MATNR,
        MJAHR      TYPE MJAHR,
        ZEILE      TYPE MSEG-ZEILE,
        BWART      TYPE BWART,
        XAUTO      TYPE MSEG-XAUTO,
        WERKS      TYPE WERKS,
        SHKZG      TYPE SHKZG,
        MENGE      TYPE MSEG-MENGE,
        MEINS      TYPE MSEG-MEINS,
        EBELN      TYPE MSEG-EBELN,
        EBELP      TYPE MSEG-EBELP,
        LIFNR      TYPE MSEG-LIFNR,
        DMBTR      TYPE DMBTR,
        BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
        SOBKZ      TYPE SOBKZ,
        gjahr      TYPE mseg-gjahr,
      END OF TY_MSEG.

TYPES :BEGIN OF T_A994,
         KSCHL TYPE A994-KSCHL,
         MATNR TYPE A994-MATNR,
         WERKS TYPE A994-WERKS,
         KFRST TYPE A994-KFRST,
         DATBI TYPE A994-DATBI,
         DATAB TYPE A994-DATAB,
         KNUMH TYPE A994-KNUMH,
       END OF T_A994.


TYPES :BEGIN OF T_CONDITIONS,
    KNUMH TYPE KONP-KNUMH,
    KOPOS TYPE KONP-KOPOS,
    KSCHL TYPE KONP-KSCHL,
    KBETR TYPE KONP-KBETR,
  END OF T_CONDITIONS.


DATA: IT_MKPF TYPE TABLE OF TY_MKPF,
      WA_MKPF TYPE TY_MKPF.

DATA: IT_MSEG TYPE TABLE OF MSEG,
      WA_MSEG TYPE MSEG.
DATA: IT_LFA1 TYPE TABLE OF LFA1,
      WA_LFA1 TYPE LFA1.

DATA: IT_MSEG1 TYPE TABLE OF MSEG,
      WA_MSEG1 TYPE MSEG.

DATA : IT_SU_CHALL TYPE STANDARD TABLE OF ZSU_CHALLANNO,
       WA_SU_CHALL TYPE ZSU_CHALLANNO.

DATA: IT_A994 TYPE TABLE OF A994,
      WA_A994 TYPE A994.

DATA: IT_CONDITION TYPE TABLE OF T_CONDITIONS,
      WA_CONDITION TYPE T_CONDITIONS.
**********************added by primus jyoti on 23.01.2024
TYPES : BEGIN OF g_ty_msg,

type LIKE sy-msgty,

msg(120),

END OF g_ty_msg.

DATA: g_t_msg TYPE TABLE OF g_ty_msg,

g_r_msg TYPE g_ty_msg.
****************************************************************
TYPES  : BEGIN OF TY_FINAL,
           SELECT(1),
           MBLNR      TYPE MSEG-MBLNR,
           MATNR      TYPE MATNR,
           MJAHR      TYPE MJAHR,
           BWART      TYPE BWART,
           WERKS      TYPE MSEG-WERKS,
           SHKZG      TYPE SHKZG,
           MENGE      TYPE MSEG-MENGE,
           MEINS      TYPE MSEG-MEINS,
           LIFNR      TYPE LIFNR,
           NAME1      TYPE NAME1,
           DMBTR      TYPE DMBTR,
           BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
           SOBKZ      TYPE SOBKZ,
           XAUTO      TYPE XAUTO,
           EBELN      TYPE EBELN,
           EBELP      TYPE EBELP,
           CHALLANNO  TYPE ZSU_CHALLANNO-CHALLANNO,
           KSCHL      TYPE A994-KSCHL,
           KFRST      TYPE A994-KFRST,
           DATBI      TYPE A994-DATBI,
           DATAB      TYPE A994-DATAB,
           KNUMH      TYPE A994-KNUMH,
           KOPOS      TYPE KONP-KOPOS,
           KBETR      TYPE KONP-KBETR,
         END OF  TY_FINAL.


DATA: IT_FINAL1 TYPE STANDARD TABLE OF TY_FINAL,
      WA_FINAL1 TYPE TY_FINAL.
