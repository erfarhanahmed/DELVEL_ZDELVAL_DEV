*&---------------------------------------------------------------------*
*&  Include           ZCOOIS_COMP_ISSUE_TOP
*&---------------------------------------------------------------------*

TABLES : aufm,afpo,afru,resb,caufv,vbak,KNA1.

DATA : lv_lines TYPE STANDARD TABLE OF tline,
       wa_lines LIKE tline,
       ls_lines LIKE tline.

DATA:  name TYPE thead-tdname.

TYPES : BEGIN OF ty_data,
          aufnr    TYPE resb-aufnr,
          matnr    TYPE resb-matnr,
          budat    TYPE afru-budat,
          enmng    TYPE resb-enmng,
          enmng1   TYPE string,
          bdmng    TYPE resb-bdmng,
          bdmng1   TYPE string,
          meins    TYPE resb-meins,
          maktx    TYPE string,
          gamng    TYPE afko-gamng,
          kdauf    TYPE caufv-kdauf,
          kdpos    TYPE caufv-kdpos,
          h_matnr  TYPE afpo-matnr,
          h_maktx  TYPE string,
          so_matnr TYPE matnr,
          kunnr    TYPE kunnr,
          name1    TYPE name1,
          to_be    TYPE bdmng,
          rate     TYPE verpr,
          value    TYPE string,
          status   TYPE string,
          auart    TYPE auart,
          WEMNG    TYPE WEMNG,
        END OF   ty_data.

TYPES : BEGIN OF ty_down,
          aufnr    TYPE string,
          h_matnr  TYPE string,
          h_maktx  TYPE string,
          matnr    TYPE string,
          maktx    TYPE string,
          budat    TYPE string,
          bdmng    TYPE string,
          enmng    TYPE string,
          gamng    TYPE string,
          meins    TYPE string,
          kdauf    TYPE string,
          kdpos    TYPE string,
          so_matnr TYPE string,
          kunnr    TYPE string,
          name1    TYPE string,
          to_be    TYPE string,
          rate     TYPE string,
          value    TYPE string,
          status   TYPE string,
          auart    TYPE string,
          WEMNG    TYPE STRING,
          ref_date TYPE string,
          ref_time TYPE string,
        END OF   ty_down.

TYPES : BEGIN OF ty_main,
          aufnr TYPE resb-aufnr,
          matnr TYPE resb-matnr,
        END OF ty_main.

DATA : iT_main TYPE TABLE OF ty_main,
       wa_main TYPE ty_main.

DATA : it_final TYPE TABLE OF ty_data,
       wa_final TYPE ty_data.

DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE ty_down.

DATA : gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gs_fieldcat TYPE slis_fieldcat_alv.

DATA : fs_layout TYPE slis_layout_alv.

DATA: grid1      TYPE REF TO cl_gui_alv_grid,
      gt_sflight TYPE TABLE OF sflight.

DATA objnr             TYPE jest-objnr.
DATA line              TYPE bsvx-sttxt.
