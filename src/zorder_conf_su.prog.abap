*&---------------------------------------------------------------------*
*&  Include           ZORDER_CONFIRM
*&---------------------------------------------------------------------*



 TYPES : BEGIN OF ty_vbak,

           vbeln       TYPE vbak-vbeln,
           kunnr       TYPE vbak-kunnr,
           erdat       TYPE vbak-erdat,  " PO REFRANCE DATE
           vdatu       TYPE vbak-vdatu,  " CDD DATE
           waerk       TYPE vbak-waerk,  " DOC CURRENCY
           auart       TYPE vbak-auart,
           knumv       TYPE vbak-knumv,
           zldfromdate TYPE vbak-zldfromdate, "LD date

         END OF ty_vbak.

 DATA : it_vbak TYPE STANDARD TABLE OF ty_vbak,
        wa_vbak TYPE ty_vbak.

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

           kunnr1 TYPE  kna1-kunnr,
           name12 TYPE  kna1-name1,
           telf12 TYPE kna1-telf1,
           pstlz1 TYPE  kna1-pstlz,
           STRAS1 TYPE  kna1-STRAS,
           ort012 TYPE  kna1-ort01,
           stcd31 TYPE  kna1-stcd3,

         END OF ty_kna12.

 DATA : it_kna12 TYPE STANDARD TABLE OF ty_kna12,
        wa_kna12 TYPE ty_kna12.



 TYPES : BEGIN OF ty_vbkd,

           vbeln TYPE  vbkd-vbeln,
           bstkd TYPE  vbkd-bstkd,  " CUSTOMER PO NUMBER
           bstdk TYPE vbkd-bstdk,    "PO REF  DATE


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
           knumv TYPE prcd_elements-knumv,
           kposn TYPE prcd_elements-kposn,
           kschl TYPE prcd_elements-kschl,
           kbetr TYPE prcd_elements-kbetr,
           kntyp TYPE prcd_elements-kntyp,
           kwert TYPE prcd_elements-kwert,
         END OF ty_konv.

 DATA : it_konv TYPE STANDARD TABLE OF ty_konv,
        wa_konv TYPE ty_konv.

 TYPES : BEGIN OF ty_konv1,
           knumv TYPE prcd_elements-knumv,
           kschl TYPE prcd_elements-kschl,
           kbetr TYPE prcd_elements-kbetr,
           kntyp TYPE prcd_elements-kntyp,
           kwert TYPE prcd_elements-kwert,
         END OF ty_konv1.

 DATA : it_konv1 TYPE STANDARD TABLE OF ty_konv1,
        wa_konv1 TYPE ty_konv1.


 TYPES : BEGIN OF ty_vbkd1,
           vbeln TYPE vbkd-vbeln,
           zterm TYPE vbkd-zterm,
         END OF ty_vbkd1.

 DATA : it_vbkd1 TYPE STANDARD TABLE OF ty_vbkd1,
        wa_vbkd1 TYPE ty_vbkd1.

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
           kunnr1 TYPE vbpa-vbeln,
           parvw  TYPE vbpa-parvw,
         END OF ty_vbpa.

 DATA : it_vbpa TYPE STANDARD TABLE OF ty_vbpa,
        wa_vbpa TYPE ty_vbpa.

 TYPES : BEGIN OF ty_vbpa1,
           vbeln  TYPE vbpa-vbeln,
           kunnr3 TYPE vbpa-vbeln,
           parvw  TYPE vbpa-parvw,
         END OF ty_vbpa1.

 DATA : it_vbpa1 TYPE STANDARD TABLE OF ty_vbpa1,
        wa_vbpa1 TYPE ty_vbpa1.

 DATA : it_final TYPE STANDARD TABLE OF zsalesorder_str,
        wa_final TYPE zsalesorder_str.

 DATA : it_final1 TYPE STANDARD TABLE OF zsalesorder_str,
        wa_final1 TYPE zsalesorder_str.

 DATA : gt_lines TYPE TABLE OF tline,
        ls_lines TYPE tline.


 DATA:  fm_name TYPE rs38l_fnam.             " Name of the Function Module

************************************************************************
* Constant Declaration
************************************************************************

 CONSTANTS : sf_name TYPE tdsfname VALUE 'ZSD_SO_UAE'.
