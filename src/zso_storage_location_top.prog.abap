*&---------------------------------------------------------------------*
*&  Include           ZSO_STORAGE_LOCATION_TOP
*&---------------------------------------------------------------------*
TABLES: VBAP.

TYPES : BEGIN OF TY_VBAP,
          VBELN TYPE VBAP-VBELN,
          POSNR TYPE VBAP-POSNR,
          MATNR TYPE VBAP-MATNR,
          LGORT TYPE VBAP-LGORT,
        END OF TY_VBAP.

DATA : LT_VBAP TYPE STANDARD TABLE OF TY_VBAP.

DATA : LT_FINAL TYPE TABLE OF ZSO_STORAGE_LOC,
       LW_FINAL TYPE ZSO_STORAGE_LOC.

DATA : LV_DATE TYPE SY-DATUM,
       LV_TIME TYPE SY-UZEIT.

DATA : LT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
       LW_FCAT TYPE SLIS_FIELDCAT_ALV.

DATA : LS_LAYOUT TYPE SLIS_LAYOUT_ALV.
