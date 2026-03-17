*&---------------------------------------------------------------------*
*&  Include           ZPROFARMA_INVC
*&---------------------------------------------------------------------*
 TYPES : BEGIN OF ty_vbRK,

           VBELN     TYPE VBELN_VF,
           knumv       TYPE VBRK-KNUMV,
           KUNRG       TYPE VBRK-KUNRG,
           BSTNK_VF       TYPE vbRk-BSTNK_VF,
           FKDAT TYPE VBRK-FKDAT,

         END OF ty_vbRK.

 DATA : it_vbRK TYPE STANDARD TABLE OF ty_vbRK,
        wa_vbRK TYPE ty_vbRK.

 TYPES : BEGIN OF ty_kna1,   " FOR CUSTOMER ADDRESS

           kunnr TYPE kna1-kunnr,
           name1 TYPE  kna1-name1,
           name2 TYPE  kna1-name2,
           telf1 TYPE  kna1-telf1,
           pstlz TYPE  kna1-pstlz,
           STRAS TYPE  kna1-STRAS,
           ort01 TYPE  kna1-ort01,
           stcd3 TYPE  kna1-stcd3,  " CUSTOMER GST NUMBER

         END OF ty_kna1.

 DATA : it_kna1 TYPE STANDARD TABLE OF ty_kna1,
        wa_kna1 TYPE ty_kna1.

 TYPES : BEGIN OF ty_kna12,   " FOR CUSTOMER ADDRESS

           kunnr  TYPE  kna1-kunnr,
           name1 TYPE  kna1-name1,
           telf1 TYPE kna1-telf1,
           pstlz TYPE  kna1-pstlz,
           STRAS TYPE  kna1-STRAS,
           ort01 TYPE  kna1-ort01,
           stcd3 TYPE  kna1-stcd3,

         END OF ty_kna12.

 DATA : it_kna12 TYPE STANDARD TABLE OF ty_kna12,
        wa_kna12 TYPE ty_kna12.



 TYPES : BEGIN OF ty_vbkd,

           vbeln TYPE  vbkd-vbeln,
           bstkd TYPE  vbkd-bstkd,  " CUSTOMER PO NUMBER
           bstdk TYPE vbkd-bstdk,    "PO REF  DATE
           INCO1 TYPE VBKD-INCO1,
           zterm TYPE vbkd-zterm,
           AUBEL TYPE VBRP-AUBEL,

         END OF ty_vbkd.

 DATA : it_vbkd TYPE STANDARD TABLE OF ty_vbkd,
        wa_vbkd TYPE ty_vbkd.

 TYPES : BEGIN OF ty_vbap,
           vbeln   TYPE vbap-vbeln  ,   "SALES DOC NO
           posnr   TYPE vbap-posnr,
           matnr   TYPE vbap-matnr  ,   "MATERIAL CODE
           arktx   TYPE vbap-arktx  ,   "DESCRIPTION
           meins   TYPE vbap-meins  ,    "UNIT
           kwmeng  TYPE vbap-kwmeng ,    "QTY
           zmeng  TYPE  vbap-zmeng ,    "QTY
           deldate TYPE vbap-deldate,    "DELIVERY DATE
           netpr   TYPE vbap-netpr  ,     "PRICE/UNIT
           netwr   TYPE vbap-netwr  ,     "VALUE
           abgru   TYPE vbap-abgru ,      "Reason for rejection of quotations and sales orders
           posex   TYPE vbap-posex,
         END OF ty_vbap.

 DATA : it_vbap TYPE STANDARD TABLE OF ty_vbap,
        wa_vbap TYPE ty_vbap.

* TYPES : BEGIN OF ty_vbrk,
*           vbeln TYPE vbrk-vbeln,
*           knumv TYPE vbrk-knumv,
*         END OF ty_vbrk.
*
* DATA : it_vbrk TYPE STANDARD TABLE OF ty_vbrk,
*        wa_vbrk TYPE ty_vbrk.

 TYPES : BEGIN OF ty_konv,
           kunnr TYPE PRCD_ELEMENTS-KUNNR,
           knumv TYPE PRCD_ELEMENTS-knumv,
           kposn TYPE PRCD_ELEMENTS-kposn,
           kschl TYPE PRCD_ELEMENTS-kschl,
           kbetr TYPE PRCD_ELEMENTS-kbetr,
           kntyp TYPE PRCD_ELEMENTS-kntyp,
           kwert TYPE PRCD_ELEMENTS-kwert,
*           kwert1 TYPE PRCD_ELEMENTS-kwert,
           KAWRT TYPE PRCD_ELEMENTS-KAWRT,

         END OF ty_konv.

 DATA : it_konv TYPE STANDARD TABLE OF ty_konv,
        wa_konv TYPE ty_konv.

 TYPES : BEGIN OF ty_konv1,
           knumv TYPE PRCD_ELEMENTS-knumv,
           kschl TYPE PRCD_ELEMENTS-kschl,
           kbetr TYPE PRCD_ELEMENTS-kbetr,
           kntyp TYPE PRCD_ELEMENTS-kntyp,
           kwert TYPE PRCD_ELEMENTS-kwert,
         END OF ty_konv1.

 DATA : it_konv1 TYPE STANDARD TABLE OF ty_konv1,
        wa_konv1 TYPE ty_konv1.

TYPES: BEGIN OF TY_VBRP,
       vbeln type vbrp-vbeln,
       posnr TYPE vbrp-posnr,
       ARKTX TYPE ARKTX,
       FKIMG TYPE FKIMG,
       matnr type vbrp-matnr,
       AUBEL type vbrp-AUBEL,
  END OF TY_VBRP.

  DATA: IT_VBRP TYPE TABLE OF TY_VBRP,
        WA_VBRP TYPE TY_VBRP.


* TYPES : BEGIN OF ty_vbkd1,
*           vbeln TYPE vbkd-vbeln,
*           zterm TYPE vbkd-zterm,
*           INCO1 TYPE INCO1,
*         END OF ty_vbkd1.
*
* DATA : it_vbkd1 TYPE STANDARD TABLE OF ty_vbkd1,
*        wa_vbkd1 TYPE ty_vbkd1.

 TYPES : BEGIN OF ty_tvzbt,
           zterm TYPE tvzbt-zterm,
           vtext TYPE tvzbt-vtext,
           spras TYPE tvzbt-SPRAS,
         END OF ty_tvzbt.

 DATA : it_tvzbt TYPE STANDARD TABLE OF ty_tvzbt,
        wa_tvzbt TYPE ty_tvzbt.

 TYPES : BEGIN OF ty_vbfa,
           vbelv   TYPE vbfa-vbelv,
           vbeln1  TYPE vbfa-vbeln,
           vbtyp_n TYPE vbfa-vbtyp_n,
         END OF ty_vbfa.

 DATA : it_vbfa TYPE STANDARD TABLE OF ty_vbfa,
        wa_vbfa TYPE ty_vbfa.

 TYPES : BEGIN OF ty_vbpa,
           vbeln  TYPE vbpa-vbeln,
           kunnr1 TYPE vbpa-kunnr,
           parvw  TYPE vbpa-parvw,
         END OF ty_vbpa.

 DATA : it_vbpa TYPE STANDARD TABLE OF ty_vbpa,
        wa_vbpa TYPE ty_vbpa.

 TYPES : BEGIN OF ty_vbpa1,
           vbeln  TYPE vbpa-vbeln,
           kunnr3 TYPE vbpa-vbeln,
           parvw  TYPE vbpa-parvw,
         END OF ty_vbpa1.

TYPES : BEGIN OF TY_MARC,
     matnr type marc-matnr,
     steuc type marc-steuc,
  END OF TY_MARC.

  DATA: IT_MARC TYPE TABLE OF TY_MARC,
        WA_MARC TYPE TY_MARC.




 DATA : it_vbpa1 TYPE STANDARD TABLE OF ty_vbpa1,
        wa_vbpa1 TYPE ty_vbpa1.

 DATA : it_final TYPE  TABLE OF zsalesorder_str_01,
        wa_final TYPE zsalesorder_str_01.

 DATA : it_final1 TYPE TABLE OF zsalesorder_str_01,
        wa_final1 TYPE zsalesorder_str_01.

 DATA : gt_lines TYPE TABLE OF tline,
        ls_lines TYPE tline.


 DATA:  fm_name TYPE rs38l_fnam.             " Name of the Function Module

************************************************************************
* Constant Declaration
************************************************************************

 CONSTANTS : sf_name TYPE tdsfname VALUE 'ZSD_PROFARMA_INVC'.
