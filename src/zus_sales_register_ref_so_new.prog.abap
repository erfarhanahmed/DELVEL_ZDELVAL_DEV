*&---------------------------------------------------------------------*
*& Report ZUS_SALES_REGISTER_REF_SO_N2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_sales_register_ref_so_new.

TABLES:vbrp.
TYPE-POOLS:slis.

DATA:
  tmp_vbeln TYPE vbrk-vbeln,
  tmp_fkdat TYPE vbrk-fkdat,
  tmp_so    TYPE vbak-vbeln,
  tmp_kunnr TYPE kna1-kunnr,
  dmp_vbeln TYPE vbrk-vbeln,
  dmp_ord   TYPE vbak-vbeln,
  tmp_werks TYPE vbrp-werks.


TYPES:
  BEGIN OF t_sales_inv_hdr,
    vbeln     TYPE vbrk-vbeln,
    fkart     TYPE vbrk-fkart,
    fktyp     TYPE vbrk-fktyp,
    waerk     TYPE vbrk-waerk,
    vkorg     TYPE vbrk-vkorg,
    vtweg     TYPE vbrk-vtweg,
    knumv     TYPE vbrk-knumv,
    fkdat     TYPE vbrk-fkdat,
    kunag     TYPE vbrk-kunag,
    ktgrd     TYPE vbrk-ktgrd,
    fksto     TYPE vbrk-fksto,
    xblnr     TYPE vbrk-xblnr,
    zuonr     TYPE vbrk-zuonr,
    kurrf_dat TYPE vbrk-kurrf_dat,
    kurrf     TYPE vbrk-kurrf,
    kunrg     TYPE vbrk-kunrg,
    kidno     TYPE vbrk-kidno,
    bukrs     TYPE vbrk-bukrs,
    fkart_rl TYPE vbrk-fkart_rl,
  END OF t_sales_inv_hdr,
  tt_sales_inv_hdr TYPE STANDARD TABLE OF t_sales_inv_hdr.

TYPES:
  BEGIN OF t_sales_inv_item,
    vbeln TYPE vbrp-vbeln,
    posnr TYPE vbrp-posnr,
    fkimg TYPE vbrp-fkimg,
    vrkme TYPE vbrp-vrkme,
    kursk TYPE vbrp-kursk,
    netwr TYPE vbrp-netwr,
    vgbel TYPE vbrp-vgbel,
    vgpos TYPE vbrp-vgpos,
    vgtyp TYPE vbrp-vgtyp,
    aubel TYPE vbrp-aubel,
    aupos TYPE vbrp-aupos,
    matnr TYPE vbrp-matnr,
    arktx TYPE vbrp-arktx,
    charg TYPE vbrp-charg,
    prodh TYPE vbrp-prodh,
    werks TYPE vbrp-werks,
  END OF t_sales_inv_item,
  tt_sales_inv_item TYPE STANDARD TABLE OF t_sales_inv_item.

TYPES:
  BEGIN OF t_sales_ord_hdr,
    vbeln       TYPE vbak-vbeln,
    audat       TYPE vbak-audat,
    auart       TYPE vbak-auart,
    vkbur       TYPE vbak-vkbur,
    vdatu       TYPE vbak-vdatu,
    bstnk       TYPE vbak-bstnk,
    zldfromdate TYPE vbak-zldfromdate,
    zldperweek  TYPE vbak-zldperweek,
    zldmax      TYPE vbak-zldmax,
  END OF t_sales_ord_hdr,
  tt_sales_ord_hdr TYPE STANDARD TABLE OF t_sales_ord_hdr.

TYPES:
  BEGIN OF t_sales_partner,
    vbeln TYPE vbpa-vbeln,
    kunnr TYPE vbpa-kunnr,
    parvw TYPE vbpa-parvw,
  END OF t_sales_partner,
  tt_sales_partner TYPE STANDARD TABLE OF t_sales_partner.

TYPES:
  BEGIN OF t_sales_ord_item,
    vbeln   TYPE vbap-vbeln,
    posnr   TYPE vbap-posnr,
    matnr   TYPE vbap-matnr,
    kdmat   TYPE vbap-kdmat,
    deldate TYPE vbap-deldate,
  END OF t_sales_ord_item,
  tt_sales_ord_item TYPE STANDARD TABLE OF t_sales_ord_item.

TYPES:
  BEGIN OF t_cust_info,
    kunnr TYPE kna1-kunnr,
    name1 TYPE kna1-name1,
    ort01 TYPE kna1-ort01,
    land1 TYPE kna1-land1,
    regio TYPE kna1-regio,
    adrnr TYPE kna1-adrnr,
    stcd3 TYPE kna1-stcd3,
    brsch TYPE kna1-brsch,
    pstlz TYPE kna1-pstlz,
  END OF t_cust_info,
  tt_cust_info TYPE STANDARD TABLE OF t_cust_info.

TYPES:BEGIN OF ty_knvv,
        kunnr TYPE knvv-kunnr,
        kdgrp TYPE knvv-kdgrp,
        bzirk TYPE knvv-bzirk,
        vkbur TYPE knvv-vkbur,
      END OF ty_knvv.

TYPES:BEGIN OF ty_t016t,
        spras TYPE t016t-spras,
        brsch TYPE t016t-brsch,
        brtxt TYPE t016t-brtxt,
      END OF ty_t016t,

      BEGIN OF ty_tvkbt,
        spras TYPE tvkbt-spras,
        vkbur TYPE tvkbt-vkbur,
        bezei TYPE tvkbt-bezei,
      END OF ty_tvkbt,

      BEGIN OF ty_t171t,
        spras TYPE t171t-spras,
        bzirk TYPE t171t-bzirk,
        bztxt TYPE t171t-bztxt,
      END OF ty_t171t,

      BEGIN OF ty_t151t,
        spras TYPE t151t-spras,
        kdgrp TYPE t151t-kdgrp,
        ktext TYPE t151t-ktext,
      END OF ty_t151t,

      BEGIN OF ty_vbfa,
        vbelv TYPE vbfa-vbelv,
        vbeln TYPE vbfa-vbeln,
        erdat TYPE vbfa-erdat,
        mjahr TYPE vbfa-mjahr,
      END OF ty_vbfa,

      BEGIN OF ty_vbfa2,
        vbelv TYPE vbfa-vbelv,
        vbeln TYPE vbfa-vbeln,
        erdat TYPE vbfa-erdat,
        mjahr TYPE vbfa-mjahr,
      END OF ty_vbfa2.

TYPES:
  BEGIN OF t_t005u,
    land1 TYPE t005u-land1,
    bland TYPE t005u-bland,
    bezei TYPE zgst_region-bezei,
  END OF t_t005u,
  tt_t005u TYPE STANDARD TABLE OF t_t005u.

TYPES:
  BEGIN OF t_zgst_region,
    gst_region TYPE zgst_region-gst_region,
    bezei      TYPE zgst_region-bezei,
  END OF t_zgst_region,
  tt_zgst_region TYPE STANDARD TABLE OF t_zgst_region.

TYPES:
  BEGIN OF t_knvi,
    kunnr TYPE knvi-kunnr,
    taxkd TYPE knvi-taxkd,
  END OF t_knvi,
  tt_knvi TYPE STANDARD TABLE OF t_knvi.

TYPES:
  BEGIN OF t_tskdt,
    tatyp TYPE tskdt-tatyp,
    taxkd TYPE tskdt-taxkd,
    vtext TYPE tskdt-vtext,
  END OF t_tskdt,
  tt_tskdt TYPE STANDARD TABLE OF t_tskdt.

TYPES:
  BEGIN OF t_schedule_line,
    vbeln TYPE vbep-vbeln,
    posnr TYPE vbep-posnr,
    edatu TYPE vbep-edatu,
  END OF t_schedule_line,
  tt_schedule_line TYPE STANDARD TABLE OF t_schedule_line.

TYPES:
  BEGIN OF t_tvktt,
    ktgrd TYPE tvktt-ktgrd,
    vtext TYPE tvktt-vtext,
  END OF t_tvktt,
  tt_tvktt TYPE STANDARD TABLE OF t_tvktt.

TYPES:
  BEGIN OF t_conditions,
    knumv   TYPE PRCD_ELEMENTS-knumv,
    kposn   TYPE PRCD_ELEMENTS-kposn,
    kschl   TYPE PRCD_ELEMENTS-kschl,
    kbetr   TYPE PRCD_ELEMENTS-kbetr,
    mwsk1   TYPE PRCD_ELEMENTS-mwsk1,
    kwert   TYPE PRCD_ELEMENTS-kwert,
    kstat   TYPE PRCD_ELEMENTS-kstat,
    kwert_k TYPE PRCD_ELEMENTS-kwert_k,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

TYPES:
  BEGIN OF t_t007s,
    mwskz TYPE t007s-mwskz,
    text1 TYPE t007s-text1,
  END OF t_t007s,
  tt_t007s TYPE STANDARD TABLE OF t_t007s.

TYPES:
  BEGIN OF t_accounting_doc_item,
    bukrs TYPE bseg-bukrs,
    belnr TYPE bseg-belnr,
    gjahr TYPE bseg-gjahr,
    buzei TYPE bseg-buzei,
    vbeln TYPE bseg-vbeln,
    vbel2 TYPE bseg-vbel2,
    posn2 TYPE bseg-posn2,
    hkont TYPE bseg-hkont,
    kunnr TYPE bseg-kunnr,
    zfbdt TYPE bseg-zfbdt,
    mwsk1 TYPE bseg-mwsk1,
    dmbt1 TYPE bseg-dmbt1,
    rebzg TYPE bseg-rebzg,
    rebzj TYPE bseg-rebzj,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

TYPES:
  BEGIN OF t_accounting_mdoc_item,
    bukrs TYPE bseg-bukrs,
    belnr TYPE bseg-belnr,
    gjahr TYPE bseg-gjahr,
    buzei TYPE bseg-buzei,
    buzid TYPE bseg-buzid,
    shkzg TYPE bseg-shkzg,
    dmbtr TYPE bseg-dmbtr,
    menge TYPE bseg-menge,
  END OF t_accounting_mdoc_item,
  tt_accounting_mdoc_item TYPE STANDARD TABLE OF t_accounting_mdoc_item.

TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs TYPE bkpf-bukrs,
    belnr TYPE bkpf-belnr,
    gjahr TYPE bkpf-gjahr,
    blart TYPE bkpf-blart,
    xblnr TYPE bkpf-xblnr,
    bktxt TYPE bkpf-bktxt,
  END OF t_accounting_doc_hdr,
  tt_accounting_doc_hdr TYPE STANDARD TABLE OF t_accounting_doc_hdr.

TYPES:
  BEGIN OF t_mat_master,
    matnr   TYPE mara-matnr,
    wrkst   TYPE mara-wrkst,
    zseries TYPE mara-zseries,
    zsize   TYPE mara-zsize,
    brand   TYPE mara-brand,
    moc     TYPE mara-moc,
    type    TYPE mara-type,
  END OF t_mat_master,
  tt_mat_master TYPE STANDARD TABLE OF t_mat_master.

TYPES:
  BEGIN OF t_material_val,
    matnr TYPE mbew-matnr,
    bwkey TYPE mbew-bwkey,
    bwtar TYPE mbew-bwtar,
    stprs TYPE mbew-stprs,
    bklas TYPE mbew-bklas,
  END OF t_material_val,
  tt_material_val TYPE STANDARD TABLE OF t_material_val.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    steuc TYPE marc-steuc,
  END OF t_marc,
  tt_marc TYPE STANDARD TABLE OF t_marc.

TYPES:
  BEGIN OF t_sales_buss,
    vbeln TYPE vbkd-vbeln,
    posnr TYPE vbkd-posnr,
    traty TYPE vbkd-traty,
  END OF t_sales_buss,
  tt_sales_buss TYPE STANDARD TABLE OF t_sales_buss.

TYPES:
  BEGIN OF t_skat,
    saknr TYPE skat-saknr,
    txt20 TYPE skat-txt20,
  END OF t_skat,
  tt_skat TYPE STANDARD TABLE OF t_skat.

TYPES:
  BEGIN OF t_adrc,
    addrnumber TYPE adrc-addrnumber,
    name1      TYPE adrc-name1,
    city1      TYPE adrc-city1,
    city2      TYPE adrc-city2,
    post_code1 TYPE adrc-post_code1,
    street     TYPE adrc-street,
    str_suppl1 TYPE adrc-str_suppl1,
    str_suppl2 TYPE adrc-str_suppl2,
    str_suppl3 TYPE adrc-str_suppl3,
    location   TYPE adrc-location,
    country    TYPE adrc-country,
    house_num1 TYPE adrc-house_num1,
  END OF t_adrc,
  tt_adrc TYPE STANDARD TABLE OF t_adrc.

TYPES:BEGIN OF ty_vbpa,
        vbeln TYPE vbpa-vbeln,
        kunnr TYPE vbpa-kunnr,
        parvw TYPE vbpa-parvw,
      END OF ty_vbpa,

      BEGIN OF ty_kna1,
        kunnr TYPE kna1-kunnr,
        name1 TYPE kna1-name1,
      END OF ty_kna1.

DATA : it_vbpa  TYPE TABLE OF ty_vbpa,
       wa_vbpa  TYPE          ty_vbpa,

       it_kna1  TYPE TABLE OF ty_kna1,
       wa_kna1  TYPE          ty_kna1,

       it_vbfa  TYPE TABLE OF ty_vbfa,
       wa_vbfa  TYPE          ty_vbfa,

       it_vbfa2 TYPE TABLE OF ty_vbfa2,
       wa_vbfa2 TYPE          ty_vbfa2.

TYPES :
  BEGIN OF t_sal_txt,
    sal_txt TYPE string,
  END OF t_sal_txt,
  tt_sal_txt TYPE STANDARD TABLE OF t_sal_txt.

*********************************************

****************************25-11-2019  AP ***********************

TYPES : BEGIN OF ty_bkpf,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          xblnr TYPE bkpf-xblnr,
        END OF ty_bkpf.

DATA : it_bkpf TYPE STANDARD TABLE OF ty_bkpf,
       wa_bkpf TYPE ty_bkpf.


DATA : it_bkpf1 TYPE STANDARD TABLE OF t_accounting_doc_hdr,
       wa_bkpf1 TYPE t_accounting_doc_hdr.



TYPES : BEGIN OF ls_fieldname,
          field_name(40),
        END OF ls_fieldname.

DATA : it_fieldname TYPE TABLE OF ls_fieldname,
       wa_fieldname TYPE ls_fieldname,
       gv_gjahr     TYPE bseg-gjahr,
       gv_gjahr2    TYPE bseg-gjahr,
       gv_belnr     TYPE bseg-belnr,
       gv_dmbtr     TYPE bseg-dmbtr,
       gv_vbeln     TYPE bseg-vbeln,
       gv_dmbtr2    TYPE bseg-dmbtr,
       gv_shkzg     TYPE bseg-shkzg.




*****************************************
TYPES:
  BEGIN OF t_final,
    werks        TYPE vbrp-werks,      "Plant
    vbeln        TYPE vbrk-vbeln,      "Inv No
    orig_no      TYPE vbfa-vbeln,
    orig_dt      TYPE vbfa-erdat,
    status       TYPE c,                       "Invoice Status
    posnr        TYPE vbrp-posnr,      "Line Item
    fkart        TYPE vbrk-fkart,      "Billing Type
    fkdat        TYPE vbrk-fkdat,
    auart        TYPE vbak-auart,      "Sales Order Type
    vkbur        TYPE vbak-vkbur,      "Sales Office
    aubel        TYPE vbrp-aubel,      "Sales Order No
    audat        TYPE vbak-audat,      "Sales Order Date
    vdatu        TYPE vbak-vdatu,      "Req Delivery Date
    edatu        TYPE vbep-edatu,        "Delivery Date
    bstnk        TYPE vbak-bstnk,      "Customer Ref No.
    kunag        TYPE kna1-kunnr,      "Customer Code
    name1        TYPE kna1-name1,        "Customer Name
    address      TYPE string,      "" ** Address
    partner      TYPE kna1-kunnr,
    part_name    TYPE kna1-name1,
    kdgrp        TYPE knvv-kdgrp,
    ktext        TYPE char25,
    sale_off     TYPE knvv-vkbur,
    org_unit     TYPE char25,
    bzirk        TYPE knvv-bzirk,
    bztxt        TYPE char25,
    brsch        TYPE kna1-brsch,
    brtxt        TYPE char25,
    gst_region   TYPE zgst_region-gst_region,  "State Code
    bezei        TYPE t005u-bezei,             "Region
    name1_sh     TYPE kna1-name1,
*    gst_region_sh TYPE zgst_region-gst_region,  "Ship To State Code
    bezei_sh     TYPE t005u-bezei,             " Ship To Region
    matnr        TYPE vbrp-matnr,      "Material Code
    wrkst        TYPE mara-wrkst,      "Series
    arktx        TYPE vbrp-arktx,      "Sales Text
    long_txt     TYPE char100,         "Long Text for Material
    bklas        TYPE mbew-bklas,
    kdmat        TYPE vbap-kdmat,              "Customer Item Code
    fkimg        TYPE vbrp-fkimg,      "Invoice Qty char15, "
    vrkme        TYPE vbrp-vrkme,              "Unit
    netpr        TYPE char100,              "Rate
    blart        TYPE bkpf-blart,              "FI Document Type
    belnr        TYPE bkpf-belnr,              "FI Document No.
    mwskz        TYPE PRCD_ELEMENTS-mwsk1,              "Taxcode
    tax_txt      TYPE t007s-text1,             "Tax Code Description
    base_val     TYPE dmbtr,   "char100,        "Base Price
    waerk        TYPE vbrk-waerk,      "Currency
    dis          TYPE dmbtr, "char100,        "Discount
    val_inr      TYPE dmbtr,      "Amount in Local Currency
    uloc_p       TYPE PRCD_ELEMENTS-kbetr,              "ULOC %
    uloc         TYPE dmbtr,        "ULOC
    usta_p       TYPE PRCD_ELEMENTS-kbetr,              "USTA %
    usta         TYPE dmbtr,        "USTA
    ucou_p       TYPE PRCD_ELEMENTS-kbetr,              "UCOU %
    ucou         TYPE dmbtr,        "JOIG
    pf_val       TYPE dmbtr,        "P&F
    frt          TYPE dmbtr,        "Freight
    tes          TYPE dmbtr,              "Testing Charge
    ass_val      TYPE dmbtr,        "Assessable
    vtext        TYPE tvktt-vtext,       "Sales Type Text
*    stprs         TYPE char100,        "Cost
*    stprs1        TYPE char100,        "Cost
    zseries      TYPE mara-zseries,      "Series
    zsize        TYPE mara-zsize,        "Size
    brand        TYPE mara-brand,              "Brand
    moc          TYPE mara-moc,                "MOC
    type         TYPE mara-type,               "Type
    ref_date     TYPE string,
    pstlz        TYPE kna1-pstlz,
    track        TYPE char50,
    int_pr2      TYPE PRCD_ELEMENTS-kwert,
    fi_des       TYPE char100,
    bill_street  TYPE char100,
    bill_str1    TYPE adrc-str_suppl1,
    bill_str2    TYPE adrc-str_suppl2,
    bill_post    TYPE adrc-post_code1,
    bill_city    TYPE adrc-city1,
    bill_reg     TYPE char50,
    bill_country TYPE char20,
    ship_code    TYPE kna1-kunnr,
    ship_state   TYPE zgst_region-gst_region,
    uoth_p       TYPE PRCD_ELEMENTS-kbetr,              "othr tax%
    uoth         TYPE dmbtr,        "othr tax
    ort01        TYPE kna1-ort01,
*****    XBLNR        TYPE MKPF-XBLNR, "AP
*****    MBLNR        TYPE MKPF-MBLNR, "AP
*****    MJAHR        TYPE MKPF-MJAHR, "AP
    belnr1       TYPE bkpf-belnr,
    int_pr3      TYPE PRCD_ELEMENTS-kwert,
    fkart_rl TYPE vbrk-fkart_rl,
    gv_cogs TYPE PRCD_ELEMENTS-kwert,"string,
    GV_GROSS TYPE dmbtr,"STRING,
    GV_INV_QTY TYPE p DECIMALS 0,"vbrp-fkimg,"STRING,
    GV_RATE TYPE dmbtr, "char100, "string,
    GV_NET_V TYPE dmbtr, "STRING,
    GV_HAND TYPE dmbtr, "STRING,
    GV_MOUNT TYPE dmbtr, "STRING,
    GV_SER TYPE dmbtr, "STRING,
    GV_TOT_MAT TYPE PRCD_ELEMENTS-kwert, "string,
    gv_local TYPE dmbtr, "string,
    gv_country TYPE dmbtr, "string,
    gv_state TYPE dmbtr, "string,
    gv_other TYPE dmbtr, "string,
    gv_basic TYPE dmbtr, "string,
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.
"data : gv_cogs TYPE string.
DATA:
  gt_final TYPE tt_final.

TYPES:
  BEGIN OF ty_final,
    werks        TYPE vbrp-werks,      "Plant
    vbeln        TYPE vbrk-vbeln,      "Inv No
    orig_no      TYPE vbfa-vbeln,
    orig_dt      TYPE char11,
    status       TYPE c,                       "Invoice Status
    posnr        TYPE vbrp-posnr,      "Line Item
    fkart        TYPE vbrk-fkart,      "Billing Type
    fkdat        TYPE char11,
    auart        TYPE vbak-auart,      "Sales Order Type
    vkbur        TYPE vbak-vkbur,      "Sales Office
    aubel        TYPE vbrp-aubel,      "Sales Order No
    audat        TYPE char11, "vbak-audat,      "Sales Order Date
    vdatu        TYPE char11, "vbak-vdatu,      "Req Delivery Date
    edatu        TYPE char11, "vbep-edatu,        "Delivery Date
    bstnk        TYPE vbak-bstnk,      "Customer Ref No.
    kunag        TYPE kna1-kunnr,      "Customer Code
    name1        TYPE kna1-name1,        "Customer Name
    address      TYPE string,      "" ** Address
    partner      TYPE kna1-kunnr,
    part_name    TYPE kna1-name1,
    kdgrp        TYPE knvv-kdgrp,
    ktext        TYPE char25,
    sale_off     TYPE knvv-vkbur,
    org_unit     TYPE char25,
    bzirk        TYPE knvv-bzirk,
    bztxt        TYPE char25,
    brsch        TYPE kna1-brsch,
    brtxt        TYPE char25,
    gst_region   TYPE zgst_region-gst_region,  "State Code
    bezei        TYPE t005u-bezei,             "Region
    name1_sh     TYPE kna1-name1,
*    gst_region_sh TYPE zgst_region-gst_region,  "Ship To State Code
    bezei_sh     TYPE t005u-bezei,             " Ship To Region
    matnr        TYPE vbrp-matnr,      "Material Code
    wrkst        TYPE mara-wrkst,
    arktx        TYPE vbrp-arktx,      "Sales Text
    long_txt     TYPE char100,         "Long Text for Material
    bklas        TYPE mbew-bklas,
    kdmat        TYPE vbap-kdmat,              "Customer Item Code
    GV_INV_QTY TYPE char15,"fkimg        TYPE char15, "vbrp-fkimg,      "Invoice Qty
    vrkme        TYPE vbrp-vrkme,              "Unit
    GV_RATE TYPE char100,"netpr        TYPE char100,              "Rate
    blart        TYPE bkpf-blart,              "FI Document Type
    belnr        TYPE bkpf-belnr,              "FI Document No.
    mwskz        TYPE PRCD_ELEMENTS-mwsk1,              "Taxcode
    tax_txt      TYPE t007s-text1,             "Tax Code Description
    GV_BASIC     TYPE char100," base_val     TYPE char100,        "Base Price
    waerk        TYPE vbrk-waerk,      "Currency
    dis          TYPE char100,        "Discount
    GV_NET_V TYPE char100,"val_inr      TYPE char100,      "Amount in Local Currency
    uloc_p       TYPE char15,    "konv-kbetr,              "ULOC %
    gv_local  type char100," uloc         TYPE char100,        "ULOC
    usta_p       TYPE char15,    "konv-kbetr,              "USTA %
    GV_STATE   TYPE char100, "  usta         TYPE char100,        "USTA
    ucou_p       TYPE char15,    "konv-kbetr,              "UCOU %
   GV_COUNTRY    TYPE char100," ucou         TYPE char100,        "JOIG
     GV_HAND TYPE char100,"pf_val       TYPE char100,        "P&F
   GV_MOUNT TYPE char100," frt          TYPE char100,        "Freight
    GV_SER TYPE char100,"tes          TYPE char100,              "Testing Charge
    GV_GROSS TYPE char100,"ass_val      TYPE char100,        "Assessable
    vtext        TYPE tvktt-vtext,       "Sales Type Text
*    stprs         TYPE char100,        "Cost
*    stprs1        TYPE char100,        "Cost
    zseries      TYPE mara-zseries,      "Series
    zsize        TYPE mara-zsize,        "Size
    brand        TYPE mara-brand,              "Brand
    moc          TYPE mara-moc,                "MOC
    type         TYPE mara-type,               "Type
    ref_date     TYPE char11,
    pstlz        TYPE kna1-pstlz,
    track        TYPE char50,

    GV_TOT_MAT TYPE char20,"int_pr2      TYPE char15,
    fi_des       TYPE char100,
    bill_street  TYPE char100,
    bill_str1    TYPE char50,
    bill_str2    TYPE char50,
    bill_post    TYPE char20,
    bill_city    TYPE char50,
    bill_reg     TYPE char50,
    bill_country TYPE char20,
    ship_code    TYPE char20,
    ship_state   TYPE char10,
    uoth_p       TYPE char15,               "othr tax%
   GV_OTHER      TYPE char100, " uoth         TYPE char100,   "othr tax
    ort01        TYPE char50,
    belnr1       TYPE char10,
    gv_cogs TYPE char100,
    int_pr3      TYPE char15,
    "fkart_rl TYPE vbrk-fkart_rl

  END OF ty_final.

DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.

DATA: ls_vbfa TYPE vbfa.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
SELECT-OPTIONS: so_vbeln FOR tmp_vbeln,
                so_fkdat FOR tmp_fkdat OBLIGATORY DEFAULT '20190101' TO sy-datum,
                so_ord   FOR tmp_so,
                so_kunnr FOR tmp_kunnr,
                so_werks FOR vbrp-werks OBLIGATORY  DEFAULT 'US01'.
*PARAMETERS : SO_WERKS TYPE VBRP-WERKS OBLIGATORY  DEFAULT 'US01'.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE abc .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\usa'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK b3.

*SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE pqr .
*PARAMETERS p_own AS CHECKBOX.
**PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
*SELECTION-SCREEN END OF BLOCK b6.

INITIALIZATION.
  xyz = 'Select Options'(tt1).
  abc = 'Download File'(tt2).
*  pqr = 'Download File to Own PC'(tt3).

AT SELECTION-SCREEN.
  IF NOT so_vbeln IS INITIAL.
    SELECT SINGLE vbeln
            FROM  vbrk
            INTO  dmp_vbeln
            WHERE vbeln IN so_vbeln.
    IF NOT sy-subrc IS  INITIAL.
      MESSAGE 'Please Check Billing Document No.' TYPE 'E'.
    ENDIF.

  ENDIF.

  IF NOT so_ord IS INITIAL.
    SELECT SINGLE aubel
            FROM  vbrp
            INTO  dmp_ord
            WHERE aubel IN so_ord.
    IF NOT sy-subrc IS  INITIAL.
      MESSAGE 'Please Check Sales Order No.' TYPE 'E'.
    ENDIF.

  ENDIF.

START-OF-SELECTION.

  PERFORM fetch_data CHANGING gt_final.
  PERFORM display USING gt_final.







*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM fetch_data  CHANGING ct_final TYPE tt_final.
  DATA:
    lt_sales_inv_hdr        TYPE tt_sales_inv_hdr,
    ls_sales_inv_hdr        TYPE t_sales_inv_hdr,
    ls_sales_inv_hdr_n      TYPE t_sales_inv_hdr,
    ls_sales_inv_hdr_n1     TYPE t_sales_inv_hdr,
    lt_sales_inv_item       TYPE tt_sales_inv_item,
    ls_sales_inv_item       TYPE t_sales_inv_item,
    lt_sales_ord_hdr        TYPE tt_sales_ord_hdr,
    ls_sales_ord_hdr        TYPE t_sales_ord_hdr,
    lt_sales_ord_item       TYPE tt_sales_ord_item,
    ls_sales_ord_item       TYPE t_sales_ord_item,
    lt_sales_partner        TYPE tt_sales_partner,
    ls_sales_partner        TYPE t_sales_partner,
    lt_cust_info            TYPE tt_cust_info,
    ls_cust_info            TYPE t_cust_info,
    lt_bill_to              TYPE tt_cust_info,
    ls_bill_to              TYPE t_cust_info,
    lt_schedule_line        TYPE tt_schedule_line,
    ls_schedule_line        TYPE t_schedule_line,
    lt_tvktt                TYPE tt_tvktt,
    ls_tvktt                TYPE t_tvktt,
    lt_conditions           TYPE tt_conditions,
    ls_conditions           TYPE t_conditions,
    lt_mat_master           TYPE tt_mat_master,
    ls_mat_master           TYPE t_mat_master,
    lt_material_val         TYPE tt_material_val,
    ls_material_val         TYPE t_material_val,
    lt_marc                 TYPE tt_marc,
    ls_marc                 TYPE t_marc,
    lt_sales_buss           TYPE tt_sales_buss,
    ls_sales_buss           TYPE t_sales_buss,
    lt_t005u                TYPE tt_t005u,
    ls_t005u                TYPE t_t005u,
    lt_zgst_region          TYPE tt_zgst_region,
    ls_zgst_region          TYPE t_zgst_region,
    lt_t007s                TYPE tt_t007s,
    ls_t007s                TYPE t_t007s,
    lt_knvi                 TYPE tt_knvi,
    ls_knvi                 TYPE t_knvi,
    lt_tskdt                TYPE tt_tskdt,
    ls_tskdt                TYPE t_tskdt,
    lt_accounting_doc_item  TYPE tt_accounting_doc_item,
    lt_accounting_mdoc_item TYPE tt_accounting_mdoc_item,
    lt_accounting_doc_itm1  TYPE tt_accounting_doc_item,   "For GL Account
    ls_accounting_doc_item  TYPE t_accounting_doc_item,
    lt_accounting_doc_hdr   TYPE tt_accounting_doc_hdr,
    ls_accounting_doc_hdr   TYPE t_accounting_doc_hdr,
    lt_skat                 TYPE tt_skat,
    ls_skat                 TYPE t_skat,
    ls_final                TYPE t_final,
    ws_final                TYPE t_final,
    lt_adrc                 TYPE tt_adrc,
    ls_adrc                 TYPE t_adrc,
    lt_bill_adrc            TYPE tt_adrc,
    ls_bill_adrc            TYPE t_adrc,
    ls_sal_txt              TYPE t_sal_txt.

  DATA : ls_accounting_mdoc_item TYPE t_accounting_mdoc_item.

  DATA:it_knvv  TYPE TABLE OF ty_knvv,
       wa_knvv  TYPE          ty_knvv,

       it_t016t TYPE TABLE OF ty_t016t,
       wa_t016t TYPE          ty_t016t,

       it_tvkbt TYPE TABLE OF ty_tvkbt,
       wa_tvkbt TYPE          ty_tvkbt,

       it_t171t TYPE TABLE OF ty_t171t,
       wa_t171t TYPE          ty_t171t,

       it_t151t TYPE TABLE OF ty_t151t,
       wa_t151t TYPE          ty_t151t.

  DATA:
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text       = 'Reading data...'(i01)
      percentage = 1.

  IF NOT so_ord IS INITIAL.

    SELECT vbeln
           posnr
           fkimg
           vrkme
           kursk
           netwr
           vgbel
           vgpos
           vgtyp
           aubel
           aupos
           matnr
           arktx
           charg
           prodh
           werks
      FROM vbrp
      INTO TABLE lt_sales_inv_item
      WHERE vbeln IN so_vbeln
    AND   aubel IN so_ord
    AND  werks IN so_werks.


    IF sy-subrc IS INITIAL.

      SELECT vbeln
             fkart
             fktyp
             waerk
             vkorg
             vtweg
             knumv
             fkdat
             kunag
             ktgrd
             fksto
             xblnr
             zuonr
             kurrf_dat
             kurrf
             kunrg
             kidno
             bukrs
        FROM vbrk
        INTO TABLE lt_sales_inv_hdr
        FOR ALL ENTRIES IN lt_sales_inv_item
        WHERE vbeln = lt_sales_inv_item-vbeln
        AND   fkdat IN so_fkdat
        AND   kunag IN so_kunnr.

    ELSE.
      MESSAGE 'Data Not Found' TYPE 'I'.
    ENDIF.
  ELSE.
    SELECT vbeln
           fkart
           fktyp
           waerk
           vkorg
           vtweg
           knumv
           fkdat
           kunag
           ktgrd
           fksto
           xblnr
           zuonr
           kurrf_dat
            kurrf
            kunrg
            kidno
            bukrs
            fkart_rl
      FROM vbrk
      INTO TABLE lt_sales_inv_hdr
      WHERE vbeln IN so_vbeln
      AND   fkdat IN so_fkdat
      AND   kunag IN so_kunnr
      AND   fkart NOT IN ('ZF5','ZF8','F5','F8','ZSN','ZSP','ZS1').

  ENDIF.

  IF NOT lt_sales_inv_hdr IS INITIAL.
    SELECT bukrs
           belnr
           gjahr
           buzei
           vbeln
           vbel2
           posn2
           hkont
           kunnr
           zfbdt
           mwsk1
           dmbt1
           rebzg
           rebzj
      FROM bseg
      INTO TABLE lt_accounting_doc_item
      FOR ALL ENTRIES IN lt_sales_inv_hdr
      WHERE vbeln = lt_sales_inv_hdr-vbeln
      %_HINTS ORACLE 'INDEX("BSEG""BSEG~ZVB")'.

    SORT lt_accounting_doc_item BY belnr.
    DELETE ADJACENT DUPLICATES FROM lt_accounting_doc_item.
    IF NOT lt_accounting_doc_item IS INITIAL.
      SELECT bukrs
           belnr
           gjahr
           buzei
           vbeln
           vbel2
           posn2
           hkont
           kunnr
           zfbdt
           mwsk1
           dmbt1
           rebzg
           rebzj
      FROM bseg
      INTO TABLE lt_accounting_doc_itm1
      FOR ALL ENTRIES IN lt_accounting_doc_item
      WHERE belnr = lt_accounting_doc_item-belnr
      AND   gjahr = lt_accounting_doc_item-gjahr
      AND   xbilk = space.

      SELECT saknr
             txt20
        FROM skat
        INTO TABLE lt_skat
        FOR ALL ENTRIES IN lt_accounting_doc_itm1
        WHERE saknr = lt_accounting_doc_itm1-hkont
        AND   spras = sy-langu
        AND   ktopl = '1000'.

      SELECT bukrs
             belnr
             gjahr
             blart
             xblnr
             bktxt
        FROM bkpf
        INTO TABLE lt_accounting_doc_hdr
        FOR ALL ENTRIES IN lt_accounting_doc_item
        WHERE belnr = lt_accounting_doc_item-belnr
        AND   gjahr = lt_accounting_doc_item-gjahr.

    ENDIF.

    SELECT vbeln
         posnr
         fkimg
         vrkme
         kursk
         netwr
         vgbel
         vgpos
         vgtyp
         aubel
         aupos
         matnr
         arktx
         charg
         prodh
         werks
    FROM vbrp
    INTO TABLE lt_sales_inv_item
    FOR ALL ENTRIES IN lt_sales_inv_hdr
    WHERE vbeln = lt_sales_inv_hdr-vbeln
      AND  werks IN so_werks.

    SELECT vbelv
           vbeln
           erdat
           mjahr
            FROM vbfa
           INTO TABLE it_vbfa
           FOR ALL ENTRIES IN lt_sales_inv_hdr
           WHERE vbelv = lt_sales_inv_hdr-vbeln.

    SELECT vbelv
           vbeln
           erdat
           mjahr
            FROM vbfa
           INTO TABLE it_vbfa2
           FOR ALL ENTRIES IN lt_sales_inv_item
           WHERE vbelv = lt_sales_inv_item-vgbel
           AND vbtyp_n = 'T'.

    SELECT vbeln
           posnr
           matnr
           kdmat
           deldate
      FROM vbap
      INTO TABLE lt_sales_ord_item
      FOR ALL ENTRIES IN lt_sales_inv_item
      WHERE vbeln = lt_sales_inv_item-aubel
      AND   posnr = lt_sales_inv_item-aupos.

    SELECT ktgrd
           vtext
      FROM tvktt
      INTO TABLE lt_tvktt
      FOR ALL ENTRIES IN lt_sales_inv_hdr
      WHERE ktgrd = lt_sales_inv_hdr-ktgrd
      AND   spras = sy-langu.


    SELECT knumv
           kposn
           kschl
           kbetr
           mwsk1
           kwert
           kstat
           kwert_k
      FROM PRCD_ELEMENTS
      INTO TABLE lt_conditions
      FOR ALL ENTRIES IN lt_sales_inv_hdr
      WHERE knumv = lt_sales_inv_hdr-knumv
      AND   kinak = space.

    SELECT mwskz
           text1
      FROM t007s
      INTO TABLE lt_t007s
      FOR ALL ENTRIES IN lt_conditions
      WHERE mwskz = lt_conditions-mwsk1
      AND   kalsm = 'ZTAXUS'.

    IF NOT lt_sales_inv_item IS INITIAL.

      SELECT vbeln
             audat
             auart
             vkbur
             vdatu
             bstnk
             zldfromdate
             zldperweek
             zldmax
        FROM vbak
        INTO TABLE lt_sales_ord_hdr
        FOR ALL ENTRIES IN lt_sales_inv_item
      WHERE vbeln = lt_sales_inv_item-aubel.

      SELECT kunnr
             name1
             ort01
             land1
             regio
             adrnr
             stcd3
             brsch
             pstlz
        FROM kna1
        INTO TABLE lt_cust_info
        FOR ALL ENTRIES IN lt_sales_inv_hdr
        WHERE kunnr = lt_sales_inv_hdr-kunag.

      SELECT kunnr
           name1
           ort01
           land1
           regio
           adrnr
           stcd3
           brsch
           pstlz
      FROM kna1
      INTO TABLE lt_bill_to
      FOR ALL ENTRIES IN lt_sales_inv_hdr
      WHERE kunnr = lt_sales_inv_hdr-kunrg.


      SELECT vbeln
             kunnr
            parvw
        FROM vbpa
        INTO TABLE lt_sales_partner
        FOR ALL ENTRIES IN lt_sales_ord_hdr
        WHERE vbeln = lt_sales_ord_hdr-vbeln
        AND   parvw IN ('SH','WE').


      SELECT vbeln
             kunnr
             parvw
        FROM vbpa
        INTO TABLE it_vbpa
        FOR ALL ENTRIES IN lt_sales_ord_hdr
        WHERE vbeln = lt_sales_ord_hdr-vbeln.


      SELECT kunnr
             name1
             FROM kna1 INTO TABLE it_kna1
             FOR ALL ENTRIES IN it_vbpa
             WHERE kunnr = it_vbpa-kunnr.


      SELECT kunnr
             name1
             ort01
             land1
             regio
             adrnr
             stcd3
             brsch
             pstlz
        FROM kna1
        APPENDING TABLE lt_cust_info
        FOR ALL ENTRIES IN lt_sales_partner
        WHERE kunnr = lt_sales_partner-kunnr.

      SORT lt_cust_info BY kunnr.
      DELETE ADJACENT DUPLICATES FROM lt_cust_info.
      IF NOT lt_cust_info IS INITIAL.

        SELECT kunnr
               kdgrp
               bzirk
               vkbur FROM knvv INTO TABLE it_knvv
               FOR ALL ENTRIES IN lt_cust_info
               WHERE kunnr = lt_cust_info-kunnr.

        SELECT spras
               brsch
               brtxt FROM t016t INTO TABLE it_t016t
               FOR ALL ENTRIES IN lt_cust_info
               WHERE brsch = lt_cust_info-brsch.

        SELECT addrnumber
               name1
               city1
               city2
               post_code1
               street
               str_suppl1
               str_suppl2
               str_suppl3
               location
               country
               house_num1
          FROM adrc
          INTO TABLE lt_adrc
          FOR ALL ENTRIES IN lt_cust_info
          WHERE addrnumber = lt_cust_info-adrnr.

        SELECT addrnumber
             name1
             city1
             city2
             post_code1
             street
             str_suppl1
             str_suppl2
             str_suppl3
             location
             country
             house_num1
        FROM adrc
        INTO TABLE lt_bill_adrc
        FOR ALL ENTRIES IN lt_bill_to
        WHERE addrnumber = lt_bill_to-adrnr.

        SELECT kunnr
               taxkd
          FROM knvi
          INTO TABLE lt_knvi
          FOR ALL ENTRIES IN lt_cust_info
          WHERE kunnr = lt_cust_info-kunnr
          AND   tatyp IN ('UCOU','USTA','ULOC').


        IF sy-subrc IS INITIAL.
          SELECT tatyp
                 taxkd
                 vtext
            FROM tskdt
            INTO TABLE lt_tskdt
            FOR ALL ENTRIES IN lt_knvi
            WHERE taxkd = lt_knvi-taxkd
            AND   spras = sy-langu.


        ENDIF.
        SELECT land1
               bland
               bezei
          FROM t005u
          INTO TABLE lt_t005u
          FOR ALL ENTRIES IN lt_cust_info
          WHERE spras = sy-langu
          AND   land1 = lt_cust_info-land1
          AND   bland = lt_cust_info-regio.

        SELECT gst_region
               bezei
          FROM zgst_region
          INTO TABLE lt_zgst_region
          FOR ALL ENTRIES IN lt_t005u
          WHERE bezei = lt_t005u-bezei.

      ENDIF.

      IF it_knvv IS NOT INITIAL.
        SELECT spras
               kdgrp
               ktext FROM t151t INTO TABLE it_t151t
               FOR ALL ENTRIES IN it_knvv
               WHERE spras = 'E'
                AND  kdgrp = it_knvv-kdgrp.

        SELECT spras
               bzirk
               bztxt FROM t171t INTO TABLE it_t171t
               FOR ALL ENTRIES IN it_knvv
               WHERE spras = 'E'
                 AND bzirk = it_knvv-bzirk.

        SELECT spras
               vkbur
               bezei FROM tvkbt INTO TABLE it_tvkbt
               FOR ALL ENTRIES IN it_knvv
               WHERE spras = 'E'
                 AND vkbur = it_knvv-vkbur.

      ENDIF.

      SELECT vbeln
             posnr
             edatu
        FROM vbep
        INTO TABLE lt_schedule_line
        FOR ALL ENTRIES IN lt_sales_ord_hdr
      WHERE vbeln = lt_sales_ord_hdr-vbeln.

      SELECT matnr
             wrkst
             zseries
             zsize
             brand
             moc
             type
        FROM mara
        INTO TABLE lt_mat_master
        FOR ALL ENTRIES IN lt_sales_inv_item
      WHERE matnr = lt_sales_inv_item-matnr.

      SELECT matnr
             bwkey
             bwtar
             stprs
             bklas
        FROM mbew
        INTO TABLE lt_material_val
        FOR ALL ENTRIES IN lt_sales_inv_item
      WHERE matnr = lt_sales_inv_item-matnr
        AND bwkey = lt_sales_inv_item-werks.


      SELECT matnr
             werks
             steuc
        FROM marc
        INTO TABLE lt_marc
        FOR ALL ENTRIES IN lt_sales_inv_item
      WHERE matnr = lt_sales_inv_item-matnr.

      SELECT vbeln
             posnr
             traty
        FROM vbkd
        INTO TABLE lt_sales_buss
        FOR ALL ENTRIES IN lt_sales_inv_item
        WHERE vbeln = lt_sales_inv_item-aubel
      AND   posnr = lt_sales_inv_item-aupos.

    ENDIF.
  ENDIF.
"BREAK-POINT.
  IF lt_sales_inv_item IS INITIAL.
    MESSAGE 'Data Not Found' TYPE 'E'.

  ELSE.
    LOOP AT lt_sales_inv_item INTO ls_sales_inv_item WHERE werks NE 'PL01'.

      ls_final-vbeln = ls_sales_inv_item-vbeln.
      ls_final-posnr = ls_sales_inv_item-posnr.
      ls_final-fkimg = ls_sales_inv_item-fkimg.
      ls_final-vrkme = ls_sales_inv_item-vrkme.
*      IF ls_sales_inv_item-netwr LT 0.
*        ls_final-netwr = ls_sales_inv_item-netwr * -1.
*      ELSE.
*        ls_final-netwr = ls_sales_inv_item-netwr.
*      ENDIF.

*      ls_final-vgbel = ls_sales_inv_item-vgbel.
*      ls_final-vgpos = ls_sales_inv_item-vgpos. """""
*      ls_final-vgtyp = ls_sales_inv_item-vgtyp.
      ls_final-aubel = ls_sales_inv_item-aubel.
*      ls_final-aupos = ls_sales_inv_item-aupos.
      ls_final-matnr = ls_sales_inv_item-matnr.
      ls_final-arktx = ls_sales_inv_item-arktx.
*      ls_final-prodh = ls_sales_inv_item-prodh.
      ls_final-werks = ls_sales_inv_item-werks.
*      ls_final-kursk = ls_sales_inv_item-kursk.
*      ls_final-val_inr = ls_sales_inv_item-kursk * ls_final-netwr.
************************************************************************************************************************

**********************************************************************************************************************

      READ TABLE lt_sales_ord_hdr INTO ls_sales_ord_hdr WITH KEY vbeln = ls_sales_inv_item-aubel.
      IF sy-subrc IS INITIAL.
        ls_final-audat       = ls_sales_ord_hdr-audat.
        ls_final-auart       = ls_sales_ord_hdr-auart.
        ls_final-vkbur       = ls_sales_ord_hdr-vkbur.
        ls_final-vdatu       = ls_sales_ord_hdr-vdatu.
        ls_final-bstnk       = ls_sales_ord_hdr-bstnk.
      ENDIF.
      READ TABLE lt_sales_inv_hdr INTO ls_sales_inv_hdr WITH KEY vbeln = ls_sales_inv_item-vbeln.
      IF sy-subrc IS INITIAL.
        ls_final-waerk = ls_sales_inv_hdr-waerk.

        ls_final-fkdat  = ls_sales_inv_hdr-fkdat.

        ls_final-fkart = ls_sales_inv_hdr-fkart.
        ls_final-kunag = ls_sales_inv_hdr-kunag.

        IF ls_final-fkart = 'US04' OR ls_final-fkart = 'US05'.

        ENDIF.

      ENDIF.
      READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_item WITH KEY vbeln = ls_sales_inv_hdr-vbeln.
      IF sy-subrc IS INITIAL.

        READ TABLE lt_accounting_doc_hdr INTO ls_accounting_doc_hdr WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                             gjahr = ls_accounting_doc_item-gjahr.
        IF sy-subrc IS INITIAL.
          ls_final-belnr = ls_accounting_doc_hdr-belnr.
          ls_final-blart = ls_accounting_doc_hdr-blart.
        ENDIF.

        IF ls_final-blart = 'RV'.
          ls_final-fi_des = 'Billing Invoice'.
        ELSEIF ls_final-blart = 'AB'.
          ls_final-fi_des = 'Reverse Invoice'.
        ELSEIF ls_final-blart = 'DG'.
          ls_final-fi_des = 'Credit Memo'.
        ELSEIF ls_final-blart = 'DA'.
          ls_final-fi_des = 'Customer Document'.
        ELSEIF ls_final-blart = 'UE'.
          ls_final-fi_des = 'Initial Upload'.
        ENDIF.
        READ TABLE it_vbfa INTO wa_vbfa WITH KEY vbelv = ls_sales_inv_hdr-vbeln.
        IF sy-subrc = 0.
          ls_final-orig_no = wa_vbfa-vbeln.
          ls_final-orig_dt = wa_vbfa-erdat.
        ENDIF.

**************************** sagar dev
        SELECT bukrs belnr gjahr xblnr INTO CORRESPONDING FIELDS OF TABLE it_bkpf FROM bkpf WHERE xblnr = ls_sales_inv_item-vgbel AND gjahr = ls_accounting_doc_item-gjahr
           AND bukrs = ls_accounting_doc_item-bukrs.
        CLEAR: ws_final,wa_bkpf,ws_final.
        IF it_bkpf IS NOT INITIAL.

         " BREAK-POINT.
          LOOP AT it_bkpf INTO wa_bkpf.
           CLEAR: ls_accounting_mdoc_item,lt_accounting_mdoc_item."gv_dmbtr.   "commented by shreya 06-10-2022
            SELECT bukrs
                   belnr
                   gjahr
                   buzei
                   buzid
                   shkzg
                   dmbtr
                   menge
              FROM bseg
              INTO TABLE lt_accounting_mdoc_item
              WHERE belnr = wa_bkpf-belnr
              AND   gjahr = wa_bkpf-gjahr
              AND   bukrs = wa_bkpf-bukrs
              AND   matnr = ls_final-matnr
              AND   posn2 = ls_final-posnr
              AND   menge = ls_final-fkimg
              AND   koart = 'S'.
            LOOP AT lt_accounting_mdoc_item INTO ls_accounting_mdoc_item.
              gv_dmbtr = gv_dmbtr + ls_accounting_mdoc_item-dmbtr.
            ENDLOOP.
            IF ls_accounting_mdoc_item-shkzg = 'H'.
              gv_dmbtr = gv_dmbtr * -1.
            ENDIF.
            IF ls_sales_inv_hdr-fkart = 'US1'.
              gv_dmbtr = gv_dmbtr * -1.
            ENDIF.
            ls_final-int_pr3 = gv_dmbtr.
            ls_final-belnr1  = wa_bkpf-belnr.
            CLEAR:  wa_bkpf,ws_final.

          ENDLOOP.
          CLEAR : gv_dmbtr. "added by shreya 14-10-22
        ENDIF.
        IF ls_sales_inv_item-vgbel = ls_sales_inv_item-aubel.
          READ TABLE it_vbfa2 INTO wa_vbfa2 WITH KEY vbelv = ls_sales_inv_item-vgbel.
          IF sy-subrc = 0.
            SELECT bukrs belnr gjahr xblnr INTO CORRESPONDING FIELDS OF TABLE it_bkpf FROM bkpf WHERE xblnr = wa_vbfa2-vbeln AND gjahr = ls_accounting_doc_item-gjahr
                AND bukrs = ls_accounting_doc_item-bukrs.
            CLEAR: ws_final,wa_bkpf,ws_final.
            IF it_bkpf IS NOT INITIAL.
              LOOP AT it_bkpf INTO wa_bkpf.
               CLEAR: ls_accounting_mdoc_item,lt_accounting_mdoc_item."gv_dmbtr. "commented by shreya 06-10-22
                SELECT bukrs
                       belnr
                       gjahr
                       buzei
                       buzid
                       shkzg
                       dmbtr
                       menge
                  FROM bseg
                  INTO TABLE lt_accounting_mdoc_item
                  WHERE belnr = wa_bkpf-belnr
                  AND   gjahr = wa_bkpf-gjahr
                  AND   bukrs = wa_bkpf-bukrs
                  AND   matnr = ls_final-matnr
                  AND   posn2 = ls_final-posnr
                  AND   menge = ls_final-fkimg
                  AND   koart = 'S'.
                LOOP AT lt_accounting_mdoc_item INTO ls_accounting_mdoc_item.
                  gv_dmbtr = gv_dmbtr + ls_accounting_mdoc_item-dmbtr.
                ENDLOOP.
                IF ls_accounting_mdoc_item-shkzg = 'H'.
                  gv_dmbtr = gv_dmbtr * -1.
                ENDIF.
                IF ls_sales_inv_hdr-fkart = 'US1'.
                  gv_dmbtr = gv_dmbtr * -1.
                ENDIF.
                ls_final-int_pr3 = gv_dmbtr.
                ls_final-belnr1  = wa_bkpf-belnr.
                CLEAR:  wa_bkpf,ws_final.
              ENDLOOP.
               CLEAR : gv_dmbtr. "added by shreya 14-10-22
            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR: gv_vbeln.
        SELECT SINGLE vbeln INTO gv_vbeln FROM vbrk WHERE vbeln = ls_final-orig_no.
        IF gv_vbeln IS INITIAL.
        ELSE.
          IF ls_final-orig_no <> ''.
            ls_final-belnr1 = ''.
            ls_final-int_pr3 = ''.
          ENDIF.
        ENDIF.


        READ TABLE lt_accounting_doc_itm1 INTO ls_accounting_doc_item WITH KEY belnr = ls_accounting_doc_hdr-belnr
                                                                               gjahr = ls_accounting_doc_hdr-gjahr.
*                                                                               vbel2 = ls_sales_inv_item-aubel
*                                                                               posn2 = ls_sales_inv_item-aupos.
        IF sy-subrc IS INITIAL.
*          ls_final-hkont   = ls_accounting_doc_item-hkont.

          READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_accounting_doc_item-hkont.
          IF sy-subrc IS INITIAL.
*            ls_final-vtext1 = ls_skat-txt20.
          ENDIF.
        ENDIF.

      ELSE.
************************        SAGAR DEV

        CALL FUNCTION 'DETERMINE_PERIOD'
          EXPORTING
            date    = ls_sales_inv_hdr-fkdat
*           PERIOD_IN                 = '000'
            version = 'V3'
          IMPORTING
*           PERIOD  =
            year    = gv_gjahr2
*         EXCEPTIONS
*           PERIOD_IN_NOT_VALID       = 1
*           PERIOD_NOT_ASSIGNED       = 2
*           VERSION_UNDEFINED         = 3
*           OTHERS  = 4
          .
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

*        clear: GV_GJAHR2.
*        GV_GJAHR2 = LS_SALES_INV_HDR-fkdat.
        SELECT bukrs belnr gjahr xblnr INTO CORRESPONDING FIELDS OF TABLE it_bkpf FROM bkpf WHERE xblnr = ls_sales_inv_item-vgbel AND gjahr = gv_gjahr2
           AND bukrs = ls_sales_inv_hdr-bukrs.
        CLEAR: ws_final,wa_bkpf,ws_final.
        LOOP AT it_bkpf INTO wa_bkpf.
          CLEAR: ls_accounting_mdoc_item,lt_accounting_mdoc_item."gv_dmbtr.   commented by shreya 06-10-22
          SELECT bukrs
                 belnr
                 gjahr
                 buzei
                 buzid
                 shkzg
                 dmbtr
                 menge
            FROM bseg
            INTO TABLE lt_accounting_mdoc_item
            WHERE belnr = wa_bkpf-belnr
            AND   gjahr = wa_bkpf-gjahr
            AND   bukrs = wa_bkpf-bukrs
            AND   matnr = ls_final-matnr
            AND   posn2 = ls_final-posnr
            AND   menge = ls_final-fkimg
            AND   koart = 'S'.
          LOOP AT lt_accounting_mdoc_item INTO ls_accounting_mdoc_item.
            gv_dmbtr = gv_dmbtr + ls_accounting_mdoc_item-dmbtr.
          ENDLOOP.
          IF ls_accounting_mdoc_item-shkzg = 'H'.
            gv_dmbtr = gv_dmbtr * -1.
          ENDIF.
*          READ TABLE CT_FINAL INTO WS_FINAL WITH KEY BELNR1 = LS_FINAL-BELNR1 ORIG_NO = ''.
*          IF SY-SUBRC = 0.
          IF ls_sales_inv_hdr-fksto = 'X'.
            ls_final-int_pr3 = ''.
            ls_final-belnr1  = ''.
          ELSE.
            ls_final-int_pr3 = gv_dmbtr.
            ls_final-belnr1  = wa_bkpf-belnr.
          ENDIF.

          CLEAR:  wa_bkpf,ws_final.
*          ENDIF.
        ENDLOOP.
         CLEAR : gv_dmbtr. "added by shreya 14-10-22
      ENDIF.
      READ TABLE lt_sales_ord_item INTO ls_sales_ord_item WITH KEY vbeln = ls_sales_inv_item-aubel
                                                                   posnr = ls_sales_inv_item-aupos.
      IF sy-subrc IS INITIAL.
        ls_final-kdmat = ls_sales_ord_item-kdmat.
      ENDIF.
      READ TABLE lt_cust_info INTO ls_cust_info WITH KEY kunnr = ls_sales_inv_hdr-kunag.
      IF sy-subrc IS INITIAL.
        ls_final-name1 = ls_cust_info-name1.
        ls_final-pstlz = ls_cust_info-pstlz.
        ls_final-brsch = ls_cust_info-brsch.
        ls_final-gst_region =  ls_cust_info-regio.
      ENDIF.

      READ TABLE it_t016t INTO wa_t016t WITH KEY brsch = ls_cust_info-brsch.
      IF sy-subrc = 0.
        ls_final-brtxt = wa_t016t-brtxt.

      ENDIF.

      READ TABLE it_knvv INTO wa_knvv WITH KEY kunnr = ls_cust_info-kunnr.
      IF sy-subrc = 0.
        ls_final-kdgrp      = wa_knvv-kdgrp.
        ls_final-sale_off   = wa_knvv-vkbur.
        ls_final-bzirk      = wa_knvv-bzirk.
      ENDIF.
      READ TABLE it_t151t INTO wa_t151t WITH KEY kdgrp = wa_knvv-kdgrp.
      IF sy-subrc = 0.
        ls_final-ktext = wa_t151t-ktext.

      ENDIF.

      READ TABLE it_t171t INTO wa_t171t WITH KEY bzirk = wa_knvv-bzirk.
      IF sy-subrc = 0.
        ls_final-bztxt = wa_t171t-bztxt.

      ENDIF.

      READ TABLE it_tvkbt INTO wa_tvkbt WITH KEY vkbur = wa_knvv-vkbur.
      IF sy-subrc = 0.
        ls_final-org_unit = wa_tvkbt-bezei.

      ENDIF.


      READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_cust_info-adrnr.
      IF sy-subrc IS INITIAL.
        IF NOT ls_adrc-street IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-street INTO ls_final-address.
        ENDIF.

        IF NOT ls_adrc-str_suppl1 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-str_suppl1 INTO ls_final-address SEPARATED BY ','.
        ENDIF.

        IF NOT ls_adrc-str_suppl2 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-str_suppl2 INTO ls_final-address SEPARATED BY ','.
        ENDIF.



        IF NOT ls_adrc-str_suppl3 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-str_suppl3 INTO ls_final-address SEPARATED BY ','.
        ENDIF.
        IF NOT ls_adrc-location IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-location INTO ls_final-address SEPARATED BY ','.
        ENDIF.

        IF NOT ls_adrc-city1 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-city1 INTO ls_final-address SEPARATED BY ','.
        ENDIF.
        IF NOT ls_adrc-post_code1 IS INITIAL.
          CONCATENATE ls_final-address 'PIN:' ls_adrc-post_code1 INTO ls_final-address SEPARATED BY ','.
        ENDIF.
        CONDENSE ls_final-address.

      ENDIF.

      READ TABLE lt_bill_to INTO ls_bill_to WITH KEY kunnr = ls_sales_inv_hdr-kunrg.
      IF sy-subrc = 0.

      ENDIF.

      READ TABLE lt_bill_adrc INTO ls_bill_adrc WITH KEY addrnumber = ls_bill_to-adrnr.
      IF sy-subrc = 0.
        ls_final-bill_street   = ls_bill_adrc-street.
        IF ls_bill_adrc-house_num1 IS NOT INITIAL.
          CONCATENATE ls_final-bill_street ls_bill_adrc-house_num1 INTO ls_final-bill_street SEPARATED BY '/'.
        ENDIF.

        ls_final-bill_str1     = ls_bill_adrc-str_suppl1.
        ls_final-bill_str2     = ls_bill_adrc-str_suppl2.
        ls_final-bill_post     = ls_bill_adrc-post_code1  .
        ls_final-bill_city     = ls_bill_adrc-city1.

      ENDIF.

      SELECT SINGLE landx INTO ls_final-bill_country FROM t005t WHERE spras = 'EN' AND land1 = ls_bill_adrc-country.
      SELECT SINGLE bezei INTO ls_final-bill_reg FROM t005u WHERE spras = 'EN' AND bland = ls_bill_to-regio AND land1 = ls_bill_adrc-country.


      READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_cust_info-land1
                                                 bland = ls_cust_info-regio.
      IF sy-subrc IS INITIAL.
        ls_final-bezei = ls_t005u-bezei.
      ENDIF.

      IF ls_cust_info-land1 = 'US'.
        READ TABLE lt_knvi INTO ls_knvi WITH KEY kunnr = ls_cust_info-kunnr.
        IF sy-subrc IS INITIAL.
          IF ls_cust_info-regio = '13'.
            READ TABLE lt_tskdt INTO ls_tskdt WITH KEY tatyp = 'JOCG'.
            IF sy-subrc IS INITIAL.
*              ls_final-vtext_tax = ls_tskdt-vtext.
            ENDIF.
          ELSE.
            READ TABLE lt_tskdt INTO ls_tskdt WITH KEY tatyp = 'JOIG'.
            IF sy-subrc IS INITIAL.
*              ls_final-vtext_tax = ls_tskdt-vtext.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*      READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = ls_t005u-bezei.
*      IF sy-subrc IS INITIAL.
*        ls_final-gst_region = ls_zgst_region-gst_region.
*      ENDIF.


      READ TABLE lt_sales_partner INTO ls_sales_partner WITH KEY vbeln = ls_sales_ord_hdr-vbeln.
      IF sy-subrc IS INITIAL.
*        ls_final-kunnr  = ls_sales_partner-kunnr.
      ENDIF.

      READ TABLE it_vbpa INTO wa_vbpa WITH KEY vbeln = ls_sales_ord_hdr-vbeln parvw = 'UR'.
      IF sy-subrc = 0.
        ls_final-partner = wa_vbpa-kunnr.
      ENDIF.

      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = ls_final-partner.
      IF sy-subrc = 0.
        ls_final-part_name = wa_kna1-name1.
      ENDIF.



      CLEAR:ls_cust_info,ls_t005u,ls_zgst_region.
      READ TABLE lt_sales_partner INTO ls_sales_partner WITH KEY vbeln = ls_sales_ord_hdr-vbeln parvw = 'WE'.
      IF sy-subrc IS INITIAL.
*        ls_final-kunnr  = ls_sales_partner-kunnr.
      ENDIF.
      READ TABLE lt_cust_info INTO ls_cust_info WITH KEY kunnr = ls_sales_partner-kunnr.
      IF sy-subrc IS INITIAL.
        ls_final-ship_code  = ls_cust_info-kunnr.
        ls_final-ort01      = ls_cust_info-ort01.
        ls_final-name1_sh = ls_cust_info-name1.
        ls_final-pstlz = ls_cust_info-pstlz.
        ls_final-ship_state = ls_cust_info-regio.
*        ls_final-stcd3 = ls_cust_info-stcd3.
*        ls_final-brsch = ls_cust_info-brsch.
      ENDIF.

      READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_cust_info-land1
                                                 bland = ls_cust_info-regio.
      IF sy-subrc IS INITIAL.
        ls_final-bezei_sh = ls_t005u-bezei.

      ENDIF.
      READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = ls_t005u-bezei.
      IF sy-subrc IS INITIAL.
*        ls_final-gst_region_sh = ls_zgst_region-gst_region.
      ENDIF.

      READ TABLE lt_schedule_line INTO ls_schedule_line WITH KEY vbeln = ls_sales_inv_item-aubel
                                                                 posnr = ls_sales_inv_item-aupos.
      IF sy-subrc IS INITIAL.
        ls_final-edatu = ls_schedule_line-edatu.
*        IF NOT ls_schedule_line-edatu IS INITIAL.
*          CONCATENATE ls_schedule_line-edatu+6(2) ls_schedule_line-edatu+4(2) ls_schedule_line-edatu+0(4)
*             INTO ls_final-edatu SEPARATED BY '-'.
**        ELSE.
**          ls_final-edatu = 'NULL'.
*        ENDIF.
*      ELSE.
*        ls_final-edatu = 'NULL'.
      ENDIF.

      READ TABLE lt_tvktt INTO ls_tvktt WITH KEY ktgrd = ls_sales_inv_hdr-ktgrd.
      IF sy-subrc IS INITIAL.
        ls_final-vtext = ls_tvktt-vtext.
*        ls_final-vtext1 = ls_tvktt-vtext.
      ENDIF.

      READ TABLE lt_mat_master INTO ls_mat_master WITH KEY matnr = ls_sales_inv_item-matnr.
      IF sy-subrc IS INITIAL.
        ls_final-wrkst = ls_mat_master-wrkst.
        ls_final-zseries = ls_mat_master-zseries.
        ls_final-zsize   = ls_mat_master-zsize.
        ls_final-brand   = ls_mat_master-brand.
        ls_final-moc     = ls_mat_master-moc.
        ls_final-type    = ls_mat_master-type.
      ENDIF.

      READ TABLE lt_material_val INTO ls_material_val WITH KEY matnr = ls_sales_inv_item-matnr.
      IF sy-subrc IS INITIAL.
*        ls_final-stprs  = ls_material_val-stprs.
*        ls_final-stprs1 = ls_material_val-stprs.
        ls_final-bklas = ls_material_val-bklas.
      ENDIF.
      READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_sales_inv_item-matnr.
      IF sy-subrc IS INITIAL.
*        ls_final-steuc = ls_marc-steuc.
      ENDIF.
***      READ TABLE lt_sales_buss INTO ls_sales_buss WITH KEY vbeln = ls_sales_inv_item-aubel
***                                                           posnr = ls_sales_inv_item-aupos.
***      IF sy-subrc IS INITIAL.
***        ls_final-traty = ls_sales_buss-traty.
***      ENDIF.

      "Base Price
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZPR0'.

      IF sy-subrc IS  INITIAL.
        ls_final-base_val = ls_conditions-kwert.
*        ls_final-val_inr  = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-val_inr  = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
        ls_final-netpr    = ls_final-base_val / ls_final-fkimg.
      ENDIF.

      "Discount Price
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'U007'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-dis = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-dis = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Internal Price
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'VPRS'.
*                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-int_pr = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-int_pr = ls_conditions-kwert * ls_sales_inv_item-kursk.
        IF ls_sales_inv_hdr-waerk = 'USD'.
*        ls_final-int_pr = ls_conditions-KBETR * ls_sales_inv_hdr-kurrf.
          ls_final-int_pr2 = ls_conditions-kwert_k.
        ELSE.
*        ls_final-int_pr = ls_conditions-KBETR.
          ls_final-int_pr2 = ls_conditions-kwert_k.
        ENDIF.


      ENDIF.

      "Packing Forwarding Charge
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'UHF1'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-pf_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-pf_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Assessable Value
*      ls_final-ass_val = ls_final-val_inr + ls_final-pf_val + ls_final-dis.

      "Excise Duty
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZEXP'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-exe_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-exe_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-mwskz = ls_conditions-mwsk1.
      ENDIF.

      "Education Cess Amount
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCEP'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-edu_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-edu_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Higher Education Cess Amount
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCEH'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-hse_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-hse_val = ls_conditions-kwert * ls_sales_inv_item-kursk.

      ENDIF.

      "VAT
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCST'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Testing Charge
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'USC1'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-tes = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-tes = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.


      "LST
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZLST'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "ULOC
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ULOC'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-uloc_p = ls_conditions-kbetr / 10.
        ls_final-uloc   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-ULOC   = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-mwskz  = ls_conditions-mwsk1.
      ENDIF.

      "USTA
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'USTA'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-usta_p = ls_conditions-kbetr / 10.
*        ls_final-USTA   = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-usta   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
      ENDIF.

      "UOTH
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                          kposn = ls_sales_inv_item-posnr
                                                          kschl = 'UOTH'
                                                          kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-uoth_p = ls_conditions-kbetr / 10.
*        ls_final-USTA   = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-uoth   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
      ENDIF.

      "UCOU
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'UCOU'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-ucou_p = ls_conditions-kbetr / 10.
        ls_final-ucou   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-UCOU   = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-mwskz  = ls_conditions-mwsk1.
      ENDIF.

      READ TABLE lt_t007s INTO ls_t007s WITH KEY mwskz = ls_final-mwskz.
      IF sy-subrc IS INITIAL.
        ls_final-tax_txt = ls_t007s-text1.
      ENDIF.
      "Freight
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'UMC1'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-frt = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-frt = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.
      "Freight
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZFR2'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-frt = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-frt = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.
      "Freight
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZFRP'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-frt = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-frt = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Insurance
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZIN1'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Insurance
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZIN2'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Insurance
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZIPP'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "TCS
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZTCS'.
*                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-tcs   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-tcs   = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
      ENDIF.

      "Compensation Cess
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCES'.
*                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-com_cess   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-com_cess   = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
      ENDIF.

      "Compensation Cess
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCEV'.
*                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-com_cess_v  = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-com_cess_v  = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
      ENDIF.

*      IF NOT ls_final-ULOC IS INITIAL OR
*        NOT ls_final-UCOU IS INITIAL.
*      ls_final-ass_gst = ls_final-ass_val + ls_final-frt  + ls_final-tes." + ls_final-ins.
*      ENDIF.
***    Net Value calculation.
      ls_final-val_inr = ls_final-base_val + ls_final-dis.
***   Gross Amount
      ls_final-ass_val =   ls_final-val_inr + ls_final-uloc + ls_final-usta + ls_final-ucou + ls_final-uoth
                         + ls_final-pf_val + ls_final-frt + ls_final-tes.

*      IF ls_sales_inv_hdr-fksto = 'X' .
*        ls_final-status     = 'C'.
*        ls_final-base_val   = 0.
*        ls_final-val_inr    = 0.
*        ls_final-dis        = 0.
**        ls_final-int_pr     = 0.
*        ls_final-pf_val     = 0.
*        ls_final-ass_val    = 0.
**        ls_final-exe_val    = 0.
**        ls_final-edu_val    = 0.
**        ls_final-hse_val    = 0.
**        ls_final-vat        = 0.
*        ls_final-ULOC       = 0.
*        ls_final-USTA       = 0.
*        ls_final-UCOU       = 0.
*        ls_final-UOTH      = 0.
*        ls_final-frt        = 0.
**        ls_final-ins        = 0.
*        ls_final-tes        = 0.
**        ls_final-ass_gst    = 0.
**        ls_final-com_cess   = 0.
**        ls_final-com_cess_v = 0.
**        ls_final-tcs_p      = 0.
**        ls_final-tcs        = 0.
*
*      ENDIF.

      IF ls_final-fkart = 'US08'.
        ls_final-status     = 'F'.
        ls_final-base_val   = 0.
        ls_final-val_inr    = 0.
        ls_final-dis        = 0.
        ls_final-pf_val     = 0.
        ls_final-ass_val    = 0.
        ls_final-uloc       = 0.
        ls_final-usta       = 0.
        ls_final-ucou       = 0.
        ls_final-uoth       = 0.
        ls_final-frt        = 0.
        ls_final-tes        = 0.

      ENDIF.

      IF ls_final-fkart = 'US03' OR ls_final-fkart = 'US05' OR ls_final-fkart = 'US1'." OR ls_final-fkart = 'US2'.
        ls_final-int_pr2 = - ls_final-int_pr2.
      ENDIF.

      IF ls_final-fkart = 'US03' OR ls_final-fkart = 'US05' .
        ls_final-base_val = - ls_final-base_val.
        ls_final-val_inr = - ls_final-val_inr.
        ls_final-uloc = - ls_final-uloc.
        ls_final-usta = - ls_final-usta.
        ls_final-ucou = - ls_final-ucou.
        ls_final-uoth = - ls_final-uoth.
        ls_final-pf_val = - ls_final-pf_val.
        ls_final-frt = - ls_final-frt.
        ls_final-tes = - ls_final-tes.
        ls_final-ass_val = - ls_final-ass_val.
        ls_final-fkimg = - ls_final-fkimg.
      ENDIF.

*       IF ( ls_final-fkart = 'US1' OR ls_final-fkart = 'US2' ).
      IF ls_final-fkart = 'US1' .
        ls_final-status     = 'C'.
        ls_final-base_val   = ls_final-base_val * -1 .
        ls_final-val_inr    = ls_final-val_inr  * -1.
        ls_final-dis        = ls_final-dis      * -1.
        ls_final-pf_val     = ls_final-pf_val   * -1.
        ls_final-ass_val    = ls_final-ass_val  * -1.
        ls_final-uloc       = ls_final-uloc     * -1.
        ls_final-usta       = ls_final-usta     * -1.
        ls_final-ucou       = ls_final-ucou     * -1.
        ls_final-uoth       = ls_final-uoth     * -1.
        ls_final-frt        = ls_final-frt      * -1.
        ls_final-tes        = ls_final-tes      * -1.
        ls_final-fkimg      =  ls_final-fkimg * -1.
      ENDIF.
      IF ls_final-status     = 'C'.
        ls_final-belnr1 = ''.
        ls_final-int_pr3 = ''.
      ENDIF.

      IF ls_final-fkart = 'US2' .
        ls_final-belnr1 = ''.
        ls_final-int_pr3 = ''.
      ENDIF.

*      ls_final-tot =
*             ls_final-ass_val     + ls_final-ULOC + ls_final-USTA
*             + ls_final-UCOU + ls_final-frt  + ls_final-tes  .
      "+ ls_final-exe_val + ls_final-edu_val + ls_final-hse_val + ls_final-vat + ls_final-ins + ls_final-com_cess
      "+ ls_final-com_cess_v  + ls_final-tcs
      IF ls_final-fkart = 'ZRE' OR ls_final-fkart = 'ZCR'.
*        ls_final-tot        = ls_final-tot * -1.
        ls_final-base_val   = ls_final-base_val * -1.
        ls_final-val_inr    = ls_final-val_inr * -1.
        ls_final-ass_val    = ls_final-ass_val * -1.
*        ls_final-exe_val    = ls_final-exe_val * -1.
*        ls_final-edu_val    = ls_final-edu_val * -1.
*        ls_final-hse_val    = ls_final-hse_val * -1.
*        ls_final-vat        = ls_final-vat * -1.
        ls_final-uloc       = ls_final-uloc * -1.
        ls_final-usta       = ls_final-uloc * -1.
        ls_final-ucou       = ls_final-ucou * -1.
        ls_final-uoth       = ls_final-uoth * -1.
        ls_final-frt        = ls_final-frt * -1.
*        ls_final-ins        = ls_final-ins * -1.
        ls_final-tes        = ls_final-tes * -1.
*        ls_final-ass_gst    = ls_final-ass_gst * -1.
*        ls_final-com_cess   = ls_final-com_cess * -1.
*        ls_final-com_cess_v = ls_final-com_cess_v * -1.
*        ls_final-tcs        = ls_final-tcs * -1.

      ENDIF.

      lv_id = ls_final-vbeln.

      READ TABLE it_vbfa INTO wa_vbfa WITH KEY vbelv = ls_sales_inv_hdr-vbeln.
      IF sy-subrc = 0.
        ls_final-orig_no = wa_vbfa-vbeln.
        ls_final-orig_dt = wa_vbfa-erdat.
      ENDIF.

      SELECT SINGLE * FROM vbfa INTO ls_vbfa WHERE vbeln = ls_sales_inv_hdr-vbeln AND vbtyp_n IN ('N' ,'S').
      IF sy-subrc = 0.
        ls_final-orig_no = ls_vbfa-vbeln.
        ls_final-orig_dt = ls_vbfa-erdat.
      ENDIF.


* *****     *************added by shreya 15_07_22***************
          " BREAK-POINT.
            LS_FINAL-gv_cogs = ls_final-int_pr3.
            LS_FINAL-gv_gross = LS_FINAL-ass_val.
            LS_FINAL-gv_inv_qty = LS_FINAL-fkimg.
            LS_FINAL-gv_rate = LS_FINAL-netpr.
            LS_FINAL-gv_net_v = LS_FINAL-val_inr.
            LS_FINAL-gv_hand = LS_FINAL-pf_val.
            LS_FINAL-GV_MOUNT = LS_FINAL-FRT.
            LS_FINAL-gv_ser = LS_FINAL-tes.
            LS_FINAL-GV_TOT_MAT = LS_FINAL-int_pr2.
            ls_final-gv_local = ls_final-uloc.
            ls_final-gv_country = ls_final-ucou.
            ls_final-gv_state = ls_final-usta.
            ls_final-gv_other = ls_final-uoth.
            ls_final-gv_basic = ls_final-base_val.


            if ls_sales_inv_hdr-fkart = 'US11' and ls_sales_inv_hdr-fkart_rl = 'LG'.
              "ls_final-int_pr3 = -1 * ls_final-int_pr3.
              IF ls_accounting_mdoc_item-shkzg NE 'H'.
              LS_FINAL-gv_cogs = LS_FINAL-gv_cogs * -1. "CONCATENATE  LS_FINAL-gv_cogs    '-'   into LS_FINAL-gv_cogs.
              ENDIF.
              LS_FINAL-GV_GROSS = LS_FINAL-GV_GROSS * -1. "CONCATENATE  ls_final-gv_gross   '-'   INTO LS_FINAL-GV_GROSS.
              LS_FINAL-GV_INV_QTY = LS_FINAL-GV_INV_QTY * -1."CONCATENATE  ls_final-GV_INV_QTY '-'   INTO LS_FINAL-GV_INV_QTY.
              LS_FINAL-GV_RATE = LS_FINAL-GV_RATE * -1."CONCATENATE  ls_final-GV_RATE    '-'   INTO LS_FINAL-GV_RATE.
              LS_FINAL-GV_NET_V = LS_FINAL-GV_NET_V * -1."CONCATENATE  ls_final-GV_NET_V   '-'   INTO LS_FINAL-GV_NET_V.
              LS_FINAL-GV_HAND = LS_FINAL-GV_HAND * -1."CONCATENATE  ls_final-GV_HAND    '-'   INTO LS_FINAL-GV_HAND.
              LS_FINAL-GV_MOUNT = LS_FINAL-GV_MOUNT * -1."CONCATENATE  ls_final-GV_MOUNT   '-'   INTO LS_FINAL-GV_MOUNT.
              LS_FINAL-GV_SER = LS_FINAL-GV_SER * -1."CONCATENATE  ls_final-GV_SER     '-'   INTO LS_FINAL-GV_SER.
              LS_FINAL-GV_TOT_MAT = LS_FINAL-GV_TOT_MAT * -1."CONCATENATE  ls_final-GV_TOT_MAT '-'   INTO LS_FINAL-GV_TOT_MAT.
              LS_FINAL-gv_local = LS_FINAL-gv_local * -1."CONCATENATE  ls_final-gv_local   '-'   INTO LS_FINAL-gv_local.
              LS_FINAL-gv_country = LS_FINAL-gv_country * -1." CONCATENATE  ls_final-gv_country '-'   INTO LS_FINAL-gv_country.
              LS_FINAL-gv_state = LS_FINAL-gv_state * -1."CONCATENATE  ls_final-gv_state   '-'   INTO LS_FINAL-gv_state.
              ls_final-gv_other = ls_final-gv_other * -1."CONCATENATE  ls_final-gv_other   '-'   INTO LS_FINAL-gv_other.
              LS_FINAL-gv_basic = LS_FINAL-gv_basic * -1."CONCATENATE  ls_final-gv_basic   '-'   INTO LS_FINAL-gv_basic.
            ENDIF.

*************added by shreya 15_07_22***************
*IF ls_final-orig_dt IS INITIAL .
*ls_final-orig_dt = ' '.
*
*ENDIF.
*IF ls_final-orig_no IS NOT INITIAL OR ls_final-fkart = 'US03' OR ls_final-fkart = 'US05' .


      "Transporter Name Text
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z002'
*          language                = sy-langu
*          name                    = lv_id
*          object                  = 'VBBK'
*        TABLES
*          lines                   = lt_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-trans ls_lines-tdline INTO ls_final-trans SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-trans.
*      ENDIF.

      "LR No.
*      CLEAR: lt_lines[],ls_lines.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z026'
*          language                = sy-langu
*          name                    = lv_id
*          object                  = 'VBBK'
*        TABLES
*          lines                   = lt_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-lr_no ls_lines-tdline INTO ls_final-lr_no SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-lr_no.
*      ENDIF.

      "LR Date.
*      CLEAR: lt_lines[],ls_lines.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z012'
*          language                = sy-langu
*          name                    = lv_id
*          object                  = 'VBBK'
*        TABLES
*          lines                   = lt_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-lr_dt ls_lines-tdline INTO ls_final-lr_dt SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-lr_dt.
*      ENDIF.

      "Transport Type
*      CLEAR: lt_lines[],ls_lines.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z013'
*          language                = sy-langu
*          name                    = lv_id
*          object                  = 'VBBK'
*        TABLES
*          lines                   = lt_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-traty ls_lines-tdline INTO ls_final-traty SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-traty.
*      ENDIF.

      "Freight Type.
*      CLEAR: lt_lines[],ls_lines.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z005'
*          language                = sy-langu
*          name                    = lv_id
*          object                  = 'VBBK'
*        TABLES
*          lines                   = lt_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-frt_typ ls_lines-tdline INTO ls_final-frt_typ SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-frt_typ.
*      ENDIF.

      "LD Tag.
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z038'
          language                = sy-langu
          name                    = lv_id
          object                  = 'VBBK'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-ld_tg ls_lines-tdline INTO ls_final-ld_tg SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-ld_tg.
      ELSE.
        lv_id = ls_final-aubel.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z038'
            language                = sy-langu
            name                    = lv_id
            object                  = 'VBBK'
          TABLES
            lines                   = lt_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT lt_lines IS INITIAL.
*          LOOP AT lt_lines INTO ls_lines.
*            IF NOT ls_lines-tdline IS INITIAL.
*              CONCATENATE ls_final-ld_tg ls_lines-tdline INTO ls_final-ld_tg SEPARATED BY space.
*            ENDIF.
*          ENDLOOP.
*          CONDENSE ls_final-ld_tg.
        ENDIF.
      ENDIF.


      lv_id = ls_final-vbeln.
      "Port Code
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z350'
          language                = sy-langu
          name                    = lv_id
          object                  = 'VBBK'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-port_cd ls_lines-tdline INTO ls_final-port_cd SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-port_cd.
      ENDIF.

      "Shipping Bill Number
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z360'
          language                = sy-langu
          name                    = lv_id
          object                  = 'VBBK'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-shp_bil ls_lines-tdline INTO ls_final-shp_bil SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-shp_bil.
      ENDIF.

      "Shipping Bill Date
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z370'
          language                = sy-langu
          name                    = lv_id
          object                  = 'VBBK'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-shp_bl_dt ls_lines-tdline INTO ls_final-shp_bl_dt SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-shp_bl_dt.
      ENDIF.

      "Proof of Delivery
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z380'
          language                = sy-langu
          name                    = lv_id
          object                  = 'VBBK'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-shp_bl_dt ls_lines-tdline INTO ls_final-shp_bl_dt SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-shp_bl_dt.
      ENDIF.

      DATA: lv_name   TYPE thead-tdname.
      REFRESH lt_lines.
      CLEAR: ls_lines,lv_name.
      lv_name = ls_sales_inv_hdr-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U003'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
      ENDIF.
      LOOP AT lt_lines INTO ls_lines.
*      lv_lines1 = ls_lines-tdline.
        ls_final-track = ls_lines-tdline .

      ENDLOOP.




      "Material Long Text
      lv_id = ls_final-matnr.
      CLEAR: lt_lines,ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_id
          object                  = 'MATERIAL'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-long_txt ls_lines-tdline INTO ls_final-long_txt SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-long_txt.
      ENDIF.

      REPLACE ALL OCCURRENCES OF '<(>' IN ls_final-long_txt WITH space.
      REPLACE ALL OCCURRENCES OF '<)>' IN ls_final-long_txt WITH space.

      SHIFT ls_final-vbeln LEFT DELETING LEADING '0'.
      SHIFT ls_final-aubel LEFT DELETING LEADING '0'.

      ls_final-ref_date = sy-datum.
      IF NOT ls_final-ref_date IS INITIAL.
        CONCATENATE ls_final-ref_date+6(2) ls_final-ref_date+4(2) ls_final-ref_date+0(4)
           INTO ls_final-ref_date SEPARATED BY '-'.
      ENDIF.



      wa_final-werks         = ls_final-werks.
      wa_final-vbeln         = ls_final-vbeln.
      wa_final-status        = ls_final-status.
      wa_final-posnr         = ls_final-posnr.
      wa_final-fkart         = ls_final-fkart.
      wa_final-auart         = ls_final-auart.
      wa_final-vkbur         = ls_final-vkbur.
      wa_final-aubel         = ls_final-aubel.
      wa_final-bstnk         = ls_final-bstnk.
      wa_final-kunag         = ls_final-kunag.
      wa_final-name1         = ls_final-name1.
      wa_final-address       = ls_final-address.
*      wa_final-vtext_tax     = ls_final-vtext_tax.
*      wa_final-stcd3         = ls_final-stcd3.
      wa_final-gst_region    = ls_final-gst_region.
      wa_final-bezei         = ls_final-bezei.
*      wa_final-kunnr         = ls_final-kunnr.
      wa_final-name1_sh      = ls_final-name1_sh.
*      wa_final-gst_region_sh = ls_final-gst_region_sh.
      wa_final-bezei_sh      = ls_final-bezei_sh.
      wa_final-matnr         = ls_final-matnr.
      wa_final-arktx         = ls_final-arktx.
      wa_final-long_txt      = ls_final-long_txt.
      wa_final-kdmat         = ls_final-kdmat.
      wa_final-GV_INV_QTY         = LS_FINAL-GV_INV_QTY. "ls_final-fkimg.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = wa_final-GV_INV_QTY.

      wa_final-vrkme         = ls_final-vrkme.
      wa_final-GV_RATE        = LS_FINAL-GV_RATE."ls_final-netpr.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = wa_final-GV_RATE.

      wa_final-blart         = ls_final-blart.
      wa_final-fi_des        = ls_final-fi_des.
      wa_final-belnr         = ls_final-belnr.
      wa_final-mwskz         = ls_final-mwskz.
      wa_final-tax_txt       = ls_final-tax_txt.
      WA_FINAL-GV_BASIC      =  abs( LS_FINAL-GV_BASIC ). "wa_final-base_val      = abs( ls_final-base_val ).
      IF ls_final-gv_basic <= 0.
        CONDENSE wa_final-gv_basic.
        CONCATENATE '-' wa_final-GV_BASIC INTO wa_final-GV_BASIC.
      ENDIF.
      wa_final-bklas         = ls_final-bklas.
      wa_final-ktext         = ls_final-ktext    .
      wa_final-bztxt         = ls_final-bztxt    .
      wa_final-org_unit      = ls_final-org_unit .
      wa_final-brtxt         = ls_final-brtxt    .
      wa_final-brsch         = ls_final-brsch.
      wa_final-kdgrp         = ls_final-kdgrp   .
      wa_final-sale_off      = ls_final-sale_off.
      wa_final-bzirk         = ls_final-bzirk   .
      wa_final-orig_no       = ls_final-orig_no   .
      wa_final-partner       = ls_final-partner   .
      wa_final-part_name     = ls_final-part_name .
      wa_final-wrkst         = ls_final-wrkst .
      wa_final-pstlz         = ls_final-pstlz .
      wa_final-track         = ls_final-track .

      wa_final-bill_street     = ls_final-bill_street   .
      wa_final-bill_str1       = ls_final-bill_str1     .
      wa_final-bill_str2       = ls_final-bill_str2     .
      wa_final-bill_post       = ls_final-bill_post     .
      wa_final-bill_city       = ls_final-bill_city     .
      wa_final-bill_reg        = ls_final-bill_reg      .
      wa_final-bill_country    = ls_final-bill_country  .
      wa_final-ship_code       = ls_final-ship_code  .
      wa_final-ship_state      = ls_final-ship_state .
      wa_final-ort01           = ls_final-ort01 .
      wa_final-belnr1           = ls_final-belnr1.
      wa_final-gv_cogs          = LS_FINAL-GV_COGS."ls_final-int_pr3.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = wa_final-GV_COGS.




      wa_final-waerk         = ls_final-waerk.
*      wa_final-kursk         = ls_final-kursk.
      wa_final-GV_NET_V       = abs( LS_FINAL-GV_NET_V )."ls_final-val_inr ).

      IF ls_final-GV_NET_V <= 0.
        CONDENSE wa_final-GV_NET_V.
        CONCATENATE '-' wa_final-GV_NET_V INTO wa_final-GV_NET_V.
      ENDIF.

      wa_final-GV_HAND        = abs( LS_FINAL-GV_HAND )."ls_final-pf_val ).
      IF ls_final-GV_HAND <= 0.
        CONDENSE wa_final-GV_HAND.
        CONCATENATE '-' wa_final-GV_HAND INTO wa_final-GV_HAND.
      ENDIF.

      wa_final-dis           = abs( ls_final-dis ).
      IF ls_final-dis < 0.
        CONDENSE wa_final-dis.
        CONCATENATE '-' wa_final-dis INTO wa_final-dis.
      ENDIF.

      wa_final-GV_GROSS       = abs( LS_FINAL-GV_GROSS )."ls_final-ass_val ).
      IF ls_final-GV_GROSS <= 0.
        CONDENSE wa_final-GV_GROSS.
        CONCATENATE '-' wa_final-GV_GROSS INTO wa_final-GV_GROSS.
      ENDIF.


      wa_final-GV_MOUNT          = abs( LS_FINAL-GV_MOUNT )."ls_final-frt ).
      IF ls_final-GV_MOUNT <= 0.
        CONDENSE wa_final-gv_mount.
        CONCATENATE '-' wa_final-GV_MOUNT INTO wa_final-gv_mount.
      ENDIF.



      wa_final-GV_SER           = abs( LS_FINAL-GV_SER )."ls_final-tes ).
      IF ls_final-GV_SER <= 0.
        CONDENSE wa_final-GV_SER.
        CONCATENATE '-' wa_final-GV_SER INTO wa_final-GV_SER.
      ENDIF.



      wa_final-uloc_p        = ls_final-uloc_p.


      wa_final-gv_local          = abs( ls_final-gv_local ).
      IF ls_final-gv_local <= 0.
        CONDENSE wa_final-gv_local.
        CONCATENATE '-' wa_final-gv_local INTO wa_final-gv_local.
      ENDIF.

      wa_final-uoth_p        = ls_final-uoth_p.

      wa_final-gv_other        = abs( ls_final-GV_OTHER ).
      IF ls_final-GV_OTHER <= 0.
        CONDENSE wa_final-gv_other.
        CONCATENATE '-' wa_final-GV_OTHER INTO wa_final-GV_OTHER.
      ENDIF.


      wa_final-usta_p        = ls_final-usta_p.

      wa_final-gv_state        = abs( ls_final-GV_STATE ).
      IF ls_final-GV_STATE <= 0.
        CONDENSE wa_final-GV_STATE.
        CONCATENATE '-' wa_final-gv_state INTO wa_final-GV_STATE.
      ENDIF.

      wa_final-ucou_p        = ls_final-ucou_p.

      wa_final-gv_country         = abs( ls_final-gv_country ).
      IF ls_final-gv_country <= 0.
        CONDENSE wa_final-gv_country.
        CONCATENATE '-' wa_final-gv_country INTO wa_final-gv_country.
      ENDIF.

      wa_final-GV_TOT_MAT       = abs( LS_FINAL-GV_TOT_MAT )."ls_final-int_pr2 ).
      IF ls_final-GV_TOT_MAT <= 0.
        CONDENSE wa_final-GV_TOT_MAT.
        CONCATENATE '-' wa_final-GV_TOT_MAT INTO wa_final-GV_TOT_MAT.
      ENDIF.



      wa_final-vtext         = ls_final-vtext.

*      wa_final-stprs         = ls_final-stprs.
*      wa_final-stprs1        = ls_final-stprs1.
      wa_final-zseries       = ls_final-zseries.
      wa_final-zsize         = ls_final-zsize.
      wa_final-brand         = ls_final-brand.
      wa_final-moc           = ls_final-moc.
      wa_final-type          = ls_final-type.



      IF  ls_final-fkdat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-fkdat
          IMPORTING
            output = wa_final-fkdat.
        CONCATENATE wa_final-fkdat+0(2) wa_final-fkdat+2(3) wa_final-fkdat+5(4)
                       INTO wa_final-fkdat SEPARATED BY '-'.


      ENDIF.


      IF ls_sales_ord_hdr-audat IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_sales_ord_hdr-audat
          IMPORTING
            output = wa_final-audat.
        CONCATENATE wa_final-audat+0(2) wa_final-audat+2(3) wa_final-audat+5(4)
                       INTO wa_final-audat SEPARATED BY '-'.


      ENDIF.



      IF ls_sales_ord_hdr-vdatu IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_sales_ord_hdr-vdatu
          IMPORTING
            output = wa_final-vdatu.
        CONCATENATE wa_final-vdatu+0(2) wa_final-vdatu+2(3) wa_final-vdatu+5(4)
                       INTO wa_final-vdatu SEPARATED BY '-'.

      ENDIF.

      IF ls_final-orig_dt IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-orig_dt
          IMPORTING
            output = wa_final-orig_dt.
        CONCATENATE wa_final-orig_dt+0(2) wa_final-orig_dt+2(3) wa_final-orig_dt+5(4)
                       INTO wa_final-orig_dt SEPARATED BY '-'.

      ENDIF.


      IF ls_schedule_line-edatu IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_schedule_line-edatu
          IMPORTING
            output = wa_final-edatu.
        CONCATENATE wa_final-edatu+0(2) wa_final-edatu+2(3) wa_final-edatu+5(4)
                       INTO wa_final-edatu SEPARATED BY '-'.

      ENDIF.

*      IF ls_final-curr_date IS NOT INITIAL .
*
*
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input  = sy-datum
*          IMPORTING
*            output = wa_final-curr_date.
*        CONCATENATE wa_final-curr_date+0(2) wa_final-curr_date+2(3) wa_final-curr_date+5(4)
*                       INTO wa_final-curr_date SEPARATED BY '-'.
*
*      ENDIF.
*******************************************************************************************************************

      IF  ls_sales_inv_item-aubel  IS NOT INITIAL.


        DATA:
          name      TYPE thead-tdname,
          blank     TYPE tline-tdformat,
          des       TYPE tline-tdline,
          count     TYPE num VALUE '1',
          lt1_lines TYPE STANDARD TABLE OF tline,
          ls1_lines TYPE tline.



        CLEAR: lt1_lines[],ls1_lines.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = '0001'
            language                = 'E'
            name                    = name
            object                  = 'VBBP'
          TABLES
            lines                   = lt1_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.


*        CLEAR ls_final-sal_txt.
        IF lt1_lines IS NOT INITIAL.


          LOOP AT lt1_lines INTO ls1_lines .


          ENDLOOP.

        ENDIF.

      ENDIF.

*--------------------------------------------------------------------*
*------------Added By Abhishek Pisolkar (26.03.2018)--------------------------
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_final-ref_date.
      CONCATENATE wa_final-ref_date+0(2) wa_final-ref_date+2(3) wa_final-ref_date+5(4)
                     INTO wa_final-ref_date SEPARATED BY '-'.
*--------------------------------------------------------------------*
********************************************************************************************************************
*
*




      APPEND wa_final TO it_final.


      APPEND ls_final TO ct_final.

      CLEAR:
         ls_final,wa_final, ls_sales_inv_item,ls_sales_inv_hdr,ls_sales_ord_hdr,ls_tvktt,ls_cust_info,ls_mat_master,ls_marc,ls_schedule_line,
         ls_sales_buss,lt_lines,ls_lines,lt1_lines,ls1_lines,blank,des,ls_sal_txt, ls_sal_txt,name,count,ls_vbfa.
*    DELETE FROM ct_final WHERE werks = 'PL01'.
*    DELETE FROM it_final WHERE werks = 'PL01'.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM display  USING    ct_final TYPE tt_final.
  DATA:
    lt_fieldcat     TYPE slis_t_fieldcat_alv,
    ls_alv_layout   TYPE slis_layout_alv,
    l_callback_prog TYPE sy-repid.

  l_callback_prog = sy-repid.

  PERFORM prepare_display CHANGING lt_fieldcat.
  CLEAR ls_alv_layout.
  ls_alv_layout-zebra = 'X'.
  ls_alv_layout-colwidth_optimize = 'X'.

* if p_own = 'X'.
**   PERFORM FIELDNAMES.
**  PERFORM DOWNLOAD_LOG.
*  ENDIF.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = l_callback_prog
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      is_layout               = ls_alv_layout
      it_fieldcat             = lt_fieldcat
      i_save                  = 'X'
    TABLES
      t_outtab                = ct_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_display  CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.
  DATA:
    gv_pos      TYPE i,
    ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH ct_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WERKS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Plant'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VBELN'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Invoice No.'.
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-hotspot   = 'X'.
  ls_fieldcat-no_zero   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'XBLNR'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Invoice No.'(102).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ORIG_NO'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Cancel Invoice No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ORIG_DT'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Cancel Invoice Dt.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STATUS'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Status'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'POSNR'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Item Line'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FKART'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Billing Type'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FKDAT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Inv. Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUART'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Ord. Type'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VKBUR'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Off'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUBEL'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Order No.'.
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUDAT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'SO Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VDATU'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Req.Del.Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EDATU'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Del.Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BSTNK'.
*  ls_fieldcat-outputlen = '16'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer PO.No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KUNAG'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer Name'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ADDRESS'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Address'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KDGRP'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer Group'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KTEXT'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer Group Desc'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GST_REGION'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer State Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BEZEI'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer State Name'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.



  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PARTNER'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Rep. No'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PART_NAME'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Rep. Name'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.




  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SALE_OFF'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Office'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ORG_UNIT'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Office Desc'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BZIRK'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales District'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BZTXT'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales District Desc'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BRSCH'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Industry Sector'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BRTXT'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Industry Sector Desc'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'VTEXT_TAX'.
**  ls_fieldcat-outputlen = '14'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'REGD/URD/SEZ/DEEMED/GOV'(182).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'STCD3'.
**  ls_fieldcat-outputlen = '14'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Customer GSTIN'(161).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SHIP_CODE'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Ship To Party Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1_SH'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Ship To Name'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'GST_REGION_SH'.
**  ls_fieldcat-outputlen = '14'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Ship To Party State Code'(165).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SHIP_STATE'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Ship To Party State Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BEZEI_SH'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Ship To Party State'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PSTLZ'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Ship To Party Zip Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ORT01'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Ship To City'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MATNR'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Item Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WRKST'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'USA Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ARKTX'.
*  ls_fieldcat-outputlen = '30'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Text'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LONG_TXT'.
*  ls_fieldcat-outputlen = '50'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Long Text'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BKLAS'.
*  ls_fieldcat-outputlen = '50'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Valuation Class'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KDMAT'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Customer Item Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_INV_QTY'."'FKIMG'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Inv.Qty.'.
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-do_sum    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VRKME'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'UOM'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_RATE'."'NETPR'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Rate'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BLART'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'FI Doc.Type'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FI_DES'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'FI Doc.Type Desc'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.



  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BELNR'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'FI Doc.No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MWSKZ'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Tax Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TAX_TXT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Tax Code Description'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_BASIC'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Basic Amt(D.C.)'.
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-do_sum    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WAERK'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Currency'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DIS'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Discount'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'KURSK'.
**  ls_fieldcat-outputlen = '7'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Ex.Rate'(132).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_NET_V'."'VAL_INR'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Net Val'.
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-do_sum    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ULOC_P'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Local Tax %'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
*
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_LOCAL'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Local Amt'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
*
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'USTA_P'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'State Tax %'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
*
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_STATE'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'State Amt'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
*
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'UCOU_P'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'County Tax %'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
*
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_COUNTRY'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'County Amt'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'UOTH_P'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Other Tax %'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
*
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_OTHER'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Other Amt'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.



  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_HAND'."'PF_VAL'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Handling & Shipping Chrg'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.




*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'EXE_VAL'.
**  ls_fieldcat-outputlen = '14'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Exe Duty Amt.'(121).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'EDU_VAL'.
**  ls_fieldcat-outputlen = '13'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Edu. Cess Amt'(122).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'HSE_VAL'.
**  ls_fieldcat-outputlen = '13'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'H.E. Cess Amt'(123).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'VAT'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'VAT/CST'(124).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_MOUNT'."'FRT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Mounting Chrg'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'INS'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Insurance'(129).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_SER'."'TES'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Service Charge'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_GROSS'."'ASS_VAL'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Gross Amt'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'ASS_GST'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Assessable GST'(172).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'COM_CESS'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Com.Cess'(173).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'COM_CESS_V'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Com.Cess Amt.'(174).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'TCS_P'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'TCS%'(175).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'TCS'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'TCS Amt.'(176).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'TOT'.
**  ls_fieldcat-outputlen = '02'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Grand Total'(130).
*  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-do_sum    = 'X'.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'PRODH'.
**  ls_fieldcat-outputlen = '14'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Prod. Category'(133).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'STEUC'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'HSN Code'(134).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VTEXT'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Sales Type'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'TRANS'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Transporter Name'(136).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'LR_NO'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'LR No.'(137).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'LR_DT'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'LR Date'(138).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'TRATY'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Transport Type'(139).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'FRT_TYP'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Freight Type'(140).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'INT_PR'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Internal Price'(141).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'STPRS'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Est. Cost'(142).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'STPRS1'.
**  ls_fieldcat-outputlen = '9'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Std. Cost'(143).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSERIES'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Series'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSIZE'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Size'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BRAND'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Brand'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MOC'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'MOC'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TYPE'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Type'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TRACK'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Tracking No'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'LD_TG'.
**  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'LD Tag'(149).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'ZLDFROMDATE'.
**  ls_fieldcat-outputlen = '12'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'LD Date'(150).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'ZLDPERWEEK'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'LD% Min'(155).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'ZLDMAX'.
**  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'LD% Max'(151).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'HKONT'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Sales Ledger Code'(177).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'VTEXT1'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Sales Ledger Head'(152).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'PORT_CD'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Port Code'(178).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'SHP_BIL'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Shipping Bill Number'(179).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'SHP_BL_DT'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Shipping Bill Date'(180).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'DEL_PROOF'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Proof of Delivery'(181).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_TOT_MAT'."'INT_PR2'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Internal Price'(141).
  ls_fieldcat-seltext_l = 'Total Material Cost'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BILL_STREET'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Internal Price'(141).
  ls_fieldcat-seltext_l = 'Bill To Street/House No'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BILL_STR1'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Bill To Street 2'.
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BILL_STR2'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Bill To Street 3'.
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BILL_POST'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Bill To Postal Code'.
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BILL_CITY'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Bill To City'.
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BILL_REG'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Bill To Region'.
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BILL_COUNTRY'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Bill To Country'.
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'REF_DATE'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'File Create Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BELNR1'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'COGS Doc. No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GV_COGS'."'INT_PR3'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'COGS Amount'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.





*
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'SAL_TXT'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'PO DOCUMENT NO'(191).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
*
*  """""""""""""ADDED BY SARIKA TALEKAR """""""
*  gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'DELDATE'.
**  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'ADDL_Data_B_Date'(191).
*  ls_fieldcat-col_pos   = gv_pos.
**  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.
  """"""""""""""""""""""""""
*   gv_pos = gv_pos + 1.
*  ls_fieldcat-fieldname = 'REP_DATE'.
*  ls_fieldcat-outputlen = '25'.
*  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_l = 'Report Ececuted Date'(191).
*  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
*  APPEND ls_fieldcat TO ct_fieldcat.
*  CLEAR ls_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UCOMM
*&---------------------------------------------------------------------*
*       Handlung of Commands on ALV
*----------------------------------------------------------------------*
*      -->U_UCOMM        USER COMMAND
*      -->U_SELFIELD     SELECT FIELD
*----------------------------------------------------------------------*
FORM ucomm_on_alv
     USING u_ucomm    TYPE sy-ucomm "#EC CALLED       "Form ucomm is called indirectly.
           u_selfield TYPE slis_selfield .

  DATA:
    ls_final      TYPE t_final,
    l_inv_display TYPE tcode VALUE 'VF03',
    l_ord_display TYPE tcode VALUE 'VA03'.


  IF u_ucomm = '&IC1'.  "Klick on field

    READ TABLE gt_final
         INDEX u_selfield-tabindex
          INTO ls_final.
*   Code to Display Selected purchase order in report
    IF u_selfield-fieldname = 'VBELN' .
      IF u_selfield-value IS NOT INITIAL.
        SET PARAMETER ID 'VF'
            FIELD u_selfield-value.
        CALL TRANSACTION  l_inv_display AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.
    IF u_selfield-fieldname = 'AUBEL' .
      IF u_selfield-value IS NOT INITIAL.
        SET PARAMETER ID 'AUN'
            FIELD u_selfield-value.
        CALL TRANSACTION  l_ord_display AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.
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
FORM download .



  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).
"BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZUSSALES.TXT'.

  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUSSALES Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CLOSE DATASET lv_fullfile.            " Abhishek Pisolkar (26.03.2018)
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


******************************************************new file zsales **********************************

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  .


  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZUSSALES.TXT'.

  CONCATENATE p_folder '\' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUSSALES Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.


  ENDIF.

  """"""""""""""""""''''''temp code for file download
*  PERFORM fieldnames.
*  PERFORM download_log.
  """"""""""""""""""""""""""""""""""""


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Plant'
              'Invoice No'
              'Cancel Invoice No'
              'Cancel Invoice Dt'
              'Status'
              'Item Line'
              'Billing Type'
              'Inv. Date'
              'Ord. Type'
              'Sales Off'
              'Sales Order No.'
              'SO Date'
              'Req.Del.Date'
              'Del.Date'
              'Customer PO.No.'
              'Customer Code'
              'Customer Name'
              'Address'
              'Sales Rep. No'
              'Sales Rep. Name'
              'Customer Group'
              'Customer Group Desc'
              'Sales Office'
              'Sales Office Desc'
              'Sales District'
              'Sales District Desc'
              'Industry Sector'
              'Industry Sector Desc'
              'Customer State Code'
              'Customer State Name'
              'Ship To Name'
*              'Ship To Party State Code'
              'Ship To Party State'
              'Item Code'
              'USA Code'
              'Sales Text'
              'Long Text'
              'Valuation Class'
              'Customer Item Code'
              'Inv.Qty'
              'UOM'
              'Rate'
              'FI Doc.Type'
              'FI Doc.No'
              'Tax Code'
              'Tax Code Description'
              'Basic Amt(D.C.)'
              'Currency'
              'Discount'
              'Net Val'
              'Local Tax %'
              'Local Amt'
              'State Tax %'
              'State Amt'
              'County Tax %'
              'County Amt'
              'Handling & Shipping Chrg'
              'Mounting Chrg'
              'Service Charge'
              'Gross Amt'
              'Sales Type'
*              'Est. Cost'
*              'Std. Cost'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'Type'
              'Refeshable Date'
              'Ship To Party Zip Code'
              'Tracking No'
              'Total Material Cost'
              'FI Doc.Type Desc'
              'Bill To Street/House No'
              'Bill To Street 2'
              'Bill To Street 3'
              'Bill To Postal Code'
              'Bill To City'
              'Bill To Region'
              'Bill To Country'
              'Ship To Party Code'
              'Ship To Party State Code'
              'Other Tax %'
              'Other Amt'
              'Ship To City'
              'COGS Doc. No'
              'COGS Amount'
  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
**************************************************************************************************************************

*
*FORM fieldnames.
*
*  wa_fieldname-field_name = 'Plant'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Invoice No'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Cancel Invoice No'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Cancel Invoice Dt'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Status'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Item Line'.
*  APPEND wa_fieldname TO it_fieldname.
*
*
*  wa_fieldname-field_name = 'Billing Type'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Inv. Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Ord. Type'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Sales Off'.
*  APPEND wa_fieldname TO it_fieldname.
**  WA_FIELDNAME-FIELD_NAME = 'Sales Off'.
**  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*  wa_fieldname-field_name = 'Sales Order No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'SO Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Req.Del.Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Del.Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer PO.No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Address'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Rep. No'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Rep. Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer Group'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer Group Desc'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Office'.
*  APPEND wa_fieldname TO it_fieldname.
*
*
*
*  wa_fieldname-field_name = 'Sales Office Desc'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales District'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Sales District Desc'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Industry Sector'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Industry Sector Desc'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer State Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer State Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Ship To Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Ship To Party State Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Ship To Party State'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Item Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'USA Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Text'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Long Text'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Valuation Class'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer Item Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Inv.Qty'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'UOM'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Rate'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'FI Doc.Type'.
*  APPEND wa_fieldname TO it_fieldname.
**
**  WA_FIELDNAME-FIELD_NAME = 'Est. Cost'.
**  APPEND WA_FIELDNAME TO IT_FIELDNAME.
*
*  wa_fieldname-field_name = 'FI Doc.No'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Tax Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Tax Code Description'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Basic Amt(D.C.)'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Currency'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Discount'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Net Val'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Local Tax %'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Local Amt'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'State Tax %'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'State Amt'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'County Tax %'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'County Amt'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Handling & Shipping Chrg'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Mounting Chrg'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Service Charge'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Gross Amt'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Sales Type'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Est. Cost'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Std. Cost'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Series'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Size'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Brand'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'MOC'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Type'.
*  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'Refeshable Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*
*ENDFORM.
*
*FORM download_log.
*
*  DATA : v_fullpath      TYPE string.
*
*  CALL FUNCTION 'GUI_FILE_SAVE_DIALOG'
*    EXPORTING
*      window_title      = 'STATUS RECORD FILE'
*      default_extension = '.xls'
*    IMPORTING
**     filename          = v_efile
*      fullpath          = v_fullpath.
*
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      filename                = v_fullpath
*      filetype                = 'ASC'
*      write_field_separator   = 'X'
*    TABLES
*      data_tab                = it_final
*      fieldnames              = it_fieldname
*    EXCEPTIONS
*      file_write_error        = 1
*      no_batch                = 2
*      gui_refuse_filetransfer = 3
*      invalid_type            = 4
*      no_authority            = 5
*      unknown_error           = 6
*      header_not_allowed      = 7
*      separator_not_allowed   = 8
*      filesize_not_allowed    = 9
*      header_too_long         = 10
*      dp_error_create         = 11
*      dp_error_send           = 12
*      dp_error_write          = 13
*      unknown_dp_error        = 14
*      access_denied           = 15
*      dp_out_of_memory        = 16
*      disk_full               = 17
*      dp_timeout              = 18
*      file_not_found          = 19
*      dataprovider_exception  = 20
*      control_flush_error     = 21
*      OTHERS                  = 22.
*
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ELSE.
*    MESSAGE 'Please check Status File' TYPE 'S'.
*  ENDIF.



*ENDFORM.

**&---------------------------------------------------------------------*
**&      Form  CVS_HEADER
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_HD_CSV  text
**----------------------------------------------------------------------*
*FORM cvs_header  USING    pd_csv.
*  DATA: l_field_seperator.
*  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
*  CONCATENATE 'Plant'
*              'Billing No.'
*              'Invoice No.'
*              'Item Line'
*              'Billing Type'
*              'Inv. Date'
*              'Ord. Type'
*              'Sales Off'
*              'Sales Doc.No.'
*              'SO Date'
*              'Req.Del.Date'
*              'Del.Date'
*              'Customer Ref.No.'
*              'Customer Code'
*              'Customer Name'
*              'Item Code'
*              'Sales Text'
*              'Long Text'
*              'Inv.Qty.'
*              'Basic Amt(D.C.)'
*              'Curr'
*              'Ex.Rate'
*              'Basic Val(INR)'
*              'P&F Amt'
*              'Discount'
*              'Ass. Val.'
*              'Exe Duty Amt.'
*              'Edu. Cess Amt'
*              'H.E. Cess Amt'
*              'VAT/CST'
*              'Freight'
*              'Insurance'
*              'ULOC'
*              'USTA'
*              'UCOU'
*              'Grand Total'
*              'Prod. Category'
*              'HSN Code'
*              'Sales Type'
*              'Transporter Name'
*              'LR No.'
*              'LR Date'
*              'Transport Type'
*              'Freight Type'
*              'Internal Price'
*              'Est. Cost'
*              'Std. Cost'
*              'Series'
*              'Size'
*              'Brand'
*              'MOC'
*              'Type'
*              'LD Tag'
*              'LD Date'
*              'LD% Min'
*              'LD% Max'
*              'Sales Ledger Head'
*              'Status'
*              'Customer Item Code'
*              'GSTIN No'
*              'Region'
*              'State Code'
*              'Ship To Party'
*              'Ship To Party Name'
*              'Ship To Region'
*              'Ship To State Code'
*              'Unit'
*              'Rate'
*              'Taxcode'
*              'Tax Code Description'
*              'Testing Charge'
*              'Assessable GST'
*              'Comp Cess%'
*              'Comp Cess Amt'
*              'TCS%'
*              'TCS amt'
*              'Sales Ledger'
*              'Port Code'
*              'Shipping Bill Number'
*              'Shipping Bill Dt'
*              'Proof of Delivery'
*              'Tax Classification'
*              'Original Invoice Number'
*              'Invoice Date'
*              'FI Document No.'
*              'FI Document Type'
*              'ULOC%'
*              'USTA%'
*              'UCOU%'
*              'FILE CREATE DATE'
*              'Customer Address'
*              'Sales Item Text'
*  INTO pd_csv
*  SEPARATED BY l_field_seperator.
*
*ENDFORM.
