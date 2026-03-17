*&---------------------------------------------------------------------*
*&  Include           ZGATE_OUT_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
DATA : GO_CONT_IMAGE TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       PICTURE       TYPE REF TO CL_GUI_PICTURE.

DATA: LV_NAME  TYPE THEAD-TDNAME,
      LV_LINES TYPE STANDARD TABLE OF tline,
      WA_LINES LIKE tline.

DATA OBJID    TYPE W3OBJID VALUE 'ZDELVAL'.
DATA URL      TYPE CNDP_URL.

CONTROLS TAB TYPE TABLEVIEW USING SCREEN 0100.

DATA: LS_LAYOUT  TYPE SLIS_LAYOUT_ALV,
      IT_FCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT    TYPE SLIS_FIELDCAT_ALV,
      LV_VARIANT TYPE DISVARIANT.


DATA : GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
       GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

DATA : FS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA FLAG TYPE C.


TYPES : BEGIN OF TY_DATA,
          VBELN      TYPE VBRP-VBELN,       "Added by supriya on 08.07.2024
          POSNR      TYPE VBRP-POSNR,
          VGBEL      TYPE VBRP-VGBEL,       "Added by supriya on 08.07.2024
          ARKTX      TYPE VBRP-ARKTX,
          VRKME      TYPE VBRP-VRKME,
          NETWR      TYPE VBRP-NETWR,
          MATNR      TYPE VBRP-MATNR,
          VKORG_AUFT TYPE VBRP-VKORG_AUFT,
          MWSBP      TYPE VBRP-MWSBP,
          WERKS      TYPE VBRP-WERKS,
          AUBEL      TYPE VBRP-AUBEL,
          FKIMG      TYPE VBRP-FKIMG,
          kunag      TYPE VBRk-kunag,
          LV_GROSS   TYPE VBRP-NETWR,
          Base_Price TYPE VBRP-NETWR,
          lv_sum     TYPE PRCD_ELEMENTS-KWERT,
          lv_base    TYPE PRCD_ELEMENTS-KWERT,
          LV_OTH     TYPE PRCD_ELEMENTS-KWERT,
          LV_DC     TYPE PRCD_ELEMENTS-KWERT,
        END OF TY_DATA.

**********************************"ADDED BY SUPRIYA ON 08.07.2024***********

*TYPES :BEGIN OF TY_MSEG,
*           MBLNR  TYPE MBLNR,
**           MJAHR  TYPE MJAHR,
*           LGORT  TYPE LGORT,
*           XAUTO  TYPE XAUTO,
*      END OF TY_MSEG.
*
*DATA : IT_MSEG TYPE TABLE OF TY_MSEG,
*       WA_MSEG TYPE TY_MSEG.
************************************


DATA : IT_DATA TYPE TABLE OF TY_DATA,
       WA_DATA TYPE TY_DATA.
**************STRUCTURE FOR NREFRESHABLE FILE
 TYPES : BEGIN OF TY_REF,
              ZNUMBER_01     TYPE  ZGATE_OUT-ZNUMBER_01,"ZGATE_OUT-ZV_DATE,
              ZV_DATE        TYPE  CHAR15,"ZGATE_OUT-ZVEH_NUM,
              ZINVOICE_NO    TYPE  CHAR15,"ZGATE_OUT-ZOUT_TIME,
              zrefe_no       TYPE  CHAR15,"ZGATE_OUT-zrefe_no
              FKDAT          TYPE  CHAR15,"ZGATE_OUT-ZOUT_DATE,
              KUNAG          TYPE  CHAR15,
              POSNR          TYPE  VBRP-POSNR,"ZGATE_OUT-ZV_DRIVER_NAME,
              MATNR          TYPE  CHAR18,"ZGATE_OUT-ZTRANS_NAME,
              ARKTX          TYPE  CHAR250,"ZGATE_OUT-ZINVOICE_NO,
              FKIMG          TYPE  CHAR15,"ZGATE_OUT-ZCRETED_BY,
              ZVEH_NUM       TYPE  CHAR15,"GATE_OUT-ZV_REMARK,
              ZV_DRIVER_NAME TYPE  CHAR50,
              ZTRANS_NAME    TYPE  CHAR50,"ZGATE_OUT-ZSEC_NAME,
              ZOUT_TIME      TYPE  ZGATE_OUT-ZOUT_TIME,"ZGATE_OUT-zchange_remark,
              ZCRETED_BY     TYPE   CHAR15,
              ZSEC_NAME      TYPE  CHAR50,",
              ZV_REMARK      TYPE  CHAR15,",
              zchange_remark TYPE  CHAR50,
              ZCHANG_NAME    TYPE  char15,
              ZCHANG_DATE    type  char15,
              ZCHANG_TIME    TYPE  char15,
              zdelete_ind    TYPE  CHAR1,
              ZDELETE_NAME   TYPE  char15,
              ZDELETE_DATE   type  char15,
              ZDELETE_TIME   TYPE  char15,
              Ref_date       TYPE  CHAR15,
              Ref_time       TYPE  CHAR15,
              ZFSTORAGE_LOC  TYPE  ZGATE_OUT-ZFSTORAGE_LOC,"CHAR15,  "ADDED BY SUPRIYA ON 08.07.2024
              ZTSTORAGE_LOC  TYPE  ZGATE_OUT-ZTSTORAGE_LOC,"CHAR15,  "ADDED BY SUPRIYA ON 08.07.2024

            END OF TY_REF.

DATA : IT_DOWN  TYPE TABLE OF TY_REF ,
       WA_DOWN  TYPE TY_REF.

TYPES : BEGIN OF TY_BASE,
          KPOSN    TYPE PRCD_ELEMENTS-KPOSN,
          KSCHL    TYPE PRCD_ELEMENTS-KSCHL,
          KWERT    TYPE PRCD_ELEMENTS-KWERT,
          KWERT1   TYPE PRCD_ELEMENTS-KWERT,
          KWERT2   TYPE PRCD_ELEMENTS-KWERT,
          lv_sum   TYPE PRCD_ELEMENTS-KWERT,
          LV_DC   TYPE PRCD_ELEMENTS-KWERT,
        END OF TY_BASE.

DATA : IT_BASE TYPE TABLE OF TY_BASE,
       WA_BASE TYPE TY_BASE.
