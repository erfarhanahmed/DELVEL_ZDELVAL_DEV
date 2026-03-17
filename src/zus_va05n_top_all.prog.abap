*&---------------------------------------------------------------------*
*&  Include           ZUS_VA05N_TOP_ALL
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_str,                            """"Structure for ALV
         vbeln       TYPE vbak-vbeln,
         ernam       TYPE vbak-ernam,
         erdat       TYPE vbak-erdat,
         bstdk       TYPE vbak-bstdk,
         bstnk       TYPE vbak-bstnk,
         vkbur       TYPE vbak-vkbur,
         auart       TYPE vbak-auart,
         inco1       TYPE vbkd-inco1,
         inco2       TYPE vbkd-inco2,
         zterm       TYPE vbkd-zterm,
         kunnr       TYPE vbpa-kunnr,
         name1       TYPE adrc-name1,
         kunnr_sh    TYPE vbpa-kunnr,
         name1_sh    TYPE adrc-name1,
         street      TYPE adrc-street,
         post_code1  TYPE adrc-post_code1,
         city1       TYPE adrc-city1,
         kunnr_ur    TYPE vbpa-kunnr,
         name1_ur    TYPE adrc-name1,
         vtext       TYPE tvzbt-vtext,
         werks       TYPE vbap-werks,
         custdeldate TYPE vbap-custdeldate,
         sh_region   TYPE adrc-region,
         bezei       TYPE t005u-bezei,
         ofm_date    TYPE string,
         order_amt   TYPE string,
         LANDX       TYPE T005T-LANDX,
         vdatu       TYPE vbak-vdatu,
         Pendso_amt  TYPE string,
         NET_VALUE   TYPE STRING,
         DEL_REMARK  TYPE string,
         deldate     TYPE vbap-deldate,
       END OF ty_str.

DATA : lv_ord_amt  TYPE string,
       lv_pend_amt TYPE string.

DATA : it_final TYPE TABLE OF ty_str,
       wa_final TYPE ty_str.

TYPES : BEGIN OF ty_down,                                 ""Structure for ref file
          VBELN       TYPE string,
          ERDAT       TYPE string,
          ERNAM       TYPE string,
          AUART       TYPE string,
          BSTDK       TYPE string,
          BSTNK       TYPE string,
          VKBUR       TYPE string,
          INCO1       TYPE string,
          INCO2       TYPE string,
          ZTERM       TYPE string,
          KUNNR       TYPE string,
          NAME1       TYPE string,
          KUNNR_SH    TYPE string,
          NAME1_SH    TYPE string,
          STREET      TYPE string,
          POST_CODE1  TYPE string,
          CITY1       TYPE string,
          KUNNR_UR    TYPE string,
          NAME1_UR    TYPE string,
          VTEXT       TYPE string,
          WERKS       TYPE string,
          CUSTDELDATE TYPE string,
          BEZEI       TYPE string,
          OFM_DATE    TYPE string,
          NET_VALUE   TYPE string,
          PENDSO_AMT  TYPE string,
          LANDX       TYPE string,
          VDATU       TYPE string,
          DEL_REMARK  TYPE string,
          deldate     TYPE string,
          REF_DATE    TYPE STRING,
          REF_TIME    TYPE STRING,
        END OF ty_down.

DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE ty_down.

TYPES : BEGIN OF ty_data,
          vbeln      TYPE vbak-vbeln,
          posnr      TYPE vbap-posnr,
          pendso_amt TYPE string,
        END OF ty_data.

DATA : it_data1 TYPE TABLE OF ty_data,
       wa_data1 TYPE ty_data.

DATA : gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gs_fieldcat TYPE slis_fieldcat_alv.

DATA : fs_layout TYPE slis_layout_alv.

DATA : lv_lines TYPE STANDARD TABLE OF tline,
       wa_lines LIKE tline,
       ls_lines LIKE tline.

DATA :  lv_name   TYPE thead-tdname.

constantS :  c_VKORG  TYPE char4 VALUE 'US00',
             C_PATH   TYPE CHAR50 VALUE 'E:\delval\usa',
             C        TYPE c VALUE 'C',
             c_spras  TYPE c VALUE 'E',
             c_land   TYPE cHAR2 VALUE 'US',
             c_INDIA  TYPE CHAR4 VALUE 'PL01',
             c_SAUDI  TYPE CHAR4 VALUE 'SU01'.
