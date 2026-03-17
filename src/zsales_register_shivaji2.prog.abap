*&---------------------------------------------------------------------*
*& Report ZSALES_REGISTER_SHIVAJI2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsales_register_shivaji2.
TYPE-POOLS:slis.

DATA:
  tmp_vbeln TYPE vbrk-vbeln,
  tmp_fkdat TYPE vbrk-fkdat,
  tmp_so    TYPE vbak-vbeln,
  tmp_kunnr TYPE kna1-kunnr,
  dmp_vbeln TYPE vbrk-vbeln,
  dmp_ord   TYPE vbak-vbeln.


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
  END OF t_sales_partner,
  tt_sales_partner TYPE STANDARD TABLE OF t_sales_partner.

TYPES:
  BEGIN OF t_sales_ord_item,
    vbeln TYPE vbap-vbeln,
    posnr TYPE vbap-posnr,
    matnr TYPE vbap-matnr,
    kdmat TYPE vbap-kdmat,
*    DELDATE type vbap-DELDATE,
  END OF t_sales_ord_item,
  tt_sales_ord_item TYPE STANDARD TABLE OF t_sales_ord_item.

TYPES:
  BEGIN OF t_bseg,
    VBEL2 TYPE BSEG-VBEL2,
    POSN2 TYPE BSEG-POSN2,
    MATNR TYPE BSEG-MATNR,
    MENGE TYPE BSEG-MENGE,
    KTOSL TYPE BSEG-KTOSL,
    dmbtr TYPE bseg-dmbtr,
    shkzg TYPE bseg-shkzg,
  END OF t_bseg,
  tt_bseg TYPE STANDARD TABLE OF t_bseg.

TYPES:
  BEGIN OF t_cust_info,
    kunnr TYPE kna1-kunnr,
    name1 TYPE kna1-name1,
    land1 TYPE kna1-land1,
    regio TYPE kna1-regio,
    adrnr TYPE kna1-adrnr,
    stcd3 TYPE kna1-stcd3,
  END OF t_cust_info,
  tt_cust_info TYPE STANDARD TABLE OF t_cust_info.

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
    knumv   TYPE prcd_elements-knumv,
    kposn   TYPE prcd_elements-kposn,
    kschl   TYPE prcd_elements-kschl,
    kbetr   TYPE prcd_elements-kbetr,
    mwsk1   TYPE prcd_elements-mwsk1,
    kwert   TYPE prcd_elements-kwert,
    kstat   TYPE prcd_elements-kstat,
    kwert_k TYPE prcd_elements-kwert_k,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

TYPES:
  BEGIN OF t_afpo,
    aufnr TYPE afpo-aufnr,
    kdauf TYPE afpo-kdauf,
    kdpos TYPE afpo-kdpos,
    matnr TYPE afpo-matnr,
    PSMNG TYPE afpo-psmng,
  END OF t_afpo,
  tt_afpo TYPE STANDARD TABLE OF t_afpo.

TYPES:
  BEGIN OF t_coep,
    belnr TYPE coep-belnr,
    objnr TYPE coep-objnr,
  END OF t_coep,
  tt_coep TYPE STANDARD TABLE OF t_coep.

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
    city2      TYPE adrc-city2,
    post_code1 TYPE adrc-post_code1,
    street     TYPE adrc-street,
    str_suppl1 TYPE adrc-str_suppl1,
    str_suppl2 TYPE adrc-str_suppl2,
    str_suppl3 TYPE adrc-str_suppl3,
    location   TYPE adrc-location,
    country    TYPE adrc-country,
  END OF t_adrc,
  tt_adrc TYPE STANDARD TABLE OF t_adrc.

TYPES :
  BEGIN OF t_sal_txt,

    sal_txt TYPE string,
*         INCLUDE STRUCTURE TLINE,

  END OF t_sal_txt,

  tt_sal_txt TYPE STANDARD TABLE OF t_sal_txt.

*********************************************

TYPES : BEGIN OF ls_fieldname,
          field_name(25),
        END OF ls_fieldname.

DATA : it_fieldname TYPE TABLE OF ls_fieldname.
DATA : wa_fieldname TYPE ls_fieldname.




*****************************************
TYPES:
  BEGIN OF t_final,
*****    werks         TYPE vbrp-werks,      "Plant
*****    vbeln         TYPE vbrk-vbeln,      "Inv No
*****    xblnr         TYPE vbrk-xblnr,      "ODN Number
*****    zuonr         TYPE vbrk-zuonr,      "Original Invoice Number
*****    kurrf_dat     TYPE char10, "vbrk-kurrf_dat,          "Invoice Date
*****    status        TYPE c,               "Invoice Status
*****    posnr         TYPE vbrp-posnr,      "Line Item
*****    fkart         TYPE vbrk-fkart,      "Billing Type
*****    fkdat         TYPE char10, "vbrk-fkdat,      "Billing Date
*****    auart         TYPE vbak-auart,      "Sales Order Type
*****    vkbur         TYPE vbak-vkbur,      "Sales Office
*****    aubel         TYPE vbrp-aubel,      "Sales Order No
*****    audat         TYPE char10, "vbak-audat,      "Sales Order Date
*****    vdatu         TYPE char10, "vbak-vdatu,      "Req Delivery Date
*****    edatu         TYPE char10, "vbep-edatu,        "Delivery Date
*****    bstnk         TYPE vbak-bstnk,      "Customer Ref No.
*****    kunag         TYPE vbrk-kunag,      "Customer Code
*****    name1         TYPE kna1-name1,        "Customer Name
*****    address       TYPE string,           "" ** Address
*****    vtext_tax     TYPE tskdt-vtext,      "Tax Classification
*****    stcd3         TYPE kna1-stcd3,              "GSTIN No
*****    gst_region    TYPE zgst_region-gst_region,  "State Code
*****    bezei         TYPE t005u-bezei,             "Region
*****    name1_sh      TYPE kna1-name1,
*****    gst_region_sh TYPE zgst_region-gst_region,  "Ship To State Code
*****    bezei_sh      TYPE t005u-bezei,             " Ship To Region
*****    matnr         TYPE vbrp-matnr,      "Material Code
*****    arktx         TYPE vbrp-arktx,      "Sales Text
*****    long_txt      TYPE char100,         "Long Text for Material
*****    kdmat         TYPE vbap-kdmat,       "Customer Item Code
*****    fkimg         TYPE char15, "vbrp-fkimg,      "Invoice Qty
*****    vrkme         TYPE vbrp-vrkme,              "Unit
*****    netpr         TYPE vbap-netpr,              "Rate
*****    blart         TYPE bkpf-blart,              "FI Document Type
*****    belnr         TYPE bkpf-belnr,              "FI Document No.
*****    mwskz         TYPE konv-mwsk1,              "Taxcode
*****    tax_txt       TYPE t007s-text1,             "Tax Code Description
*****    base_val      TYPE konv-kwert,        "Base Price
*****    waerk         TYPE vbrk-waerk,      "Currency
*****    kursk         TYPE vbrp-kursk,      "Exchange Rate
*****    val_inr       TYPE vbrp-netwr,      "Amount in Local Currency
*****    pf_val        TYPE konv-kwert,        "P&F
*****    dis           TYPE konv-kwert,        "Discount
*****    ass_val       TYPE konv-kwert,        "Assessable
*****    exe_val       TYPE konv-kwert,        "Excise Duty
*****    edu_val       TYPE konv-kwert,        "Education Cess Amount
*****    hse_val       TYPE konv-kwert,        "Higher Education Cess Amount
*****    vat           TYPE konv-kwert,        "VAT/CST
*****    frt           TYPE konv-kwert,        "Freight
*****    ins           TYPE konv-kwert,        "Insurance
*****    tes           TYPE konv-kwert,              "Testing Charge
*****    ass_gst       TYPE konv-kwert,              "Assessable GST
*****    cgst_p        TYPE konv-kbetr,              "CGST %
*****    cgst          TYPE konv-kwert,        "CGST
*****    sgst_p        TYPE konv-kbetr,              "SGST %
*****    sgst          TYPE konv-kwert,        "SGST
*****    igst_p        TYPE konv-kbetr,              "IGST %
*****    igst          TYPE konv-kwert,        "IGST
*****    com_cess      TYPE konv-kwert,              "Comp Cess%
*****    com_cess_v    TYPE konv-kwert,              "Comp Cess Amt
*****    tcs_p         TYPE konv-kbetr,              "TCS Per
*****    tcs           TYPE konv-kwert,              "TCS amt
*****    tot           TYPE konv-kwert,        "Grand Total
*****    prodh         TYPE vbrp-prodh,      "Product Heirarchy
*****    steuc         TYPE marc-steuc,        "HSN Code
*****    vtext         TYPE tvktt-vtext,       "Sales Type Text
*****    trans         TYPE char30,            "Transporter Name
*****    lr_no         TYPE char20,            "L/R No.
*****    lr_dt         TYPE char15,            "LR Date
*****    traty         TYPE char20,        "Transport Type
*****    frt_typ       TYPE char40,            "Freight Type
*****    int_pr        TYPE kwert,             "Internal Price
*****    stprs         TYPE mbew-stprs,        "Cost
*****    stprs1        TYPE mbew-stprs,        "Cost
*****    zseries       TYPE mara-zseries,      "Series
*****    zsize         TYPE mara-zsize,        "Size
*****    brand         TYPE mara-brand,              "Brand
*****    moc           TYPE mara-moc,                "MOC
*****    type          TYPE mara-type,               "Type
*****    ld_tg         TYPE char20,                  "LD Tag
*****    zldfromdate   TYPE char10, "vbak-zldfromdate,  "LD Date
*****    zldperweek    TYPE vbak-zldperweek,
*****    zldmax        TYPE vbak-zldmax,             "LD%
*****    hkont         TYPE bseg-hkont,              "Sales Ledger
*****    vtext1        TYPE skat-txt20,             "Sales Ledger Head
*****    port_cd       TYPE char50,                  "Port Code
*****    shp_bil       TYPE char20,                  "Shipping Bill Number
*****    shp_bl_dt     TYPE char15,                  "Shipping Bill Dt
*****    del_proof     TYPE char15,                  "Proof of Delivery
*****    curr_date     TYPE char11,
*****    sal_txt       type string,
******    Rep_Date      type char10,
*****
******   DELDATE type vbap-DELDATE ,
*****    kunnr         TYPE kna1-kunnr,              "Ship To Party


*    mwskz         TYPE konv-mwsk1,              "Taxcode
*    tax_txt       TYPE t007s-text1,             "Tax Code Description








*    **    vkorg       TYPE vbrk-vkorg,      "Sales Org.
**    vtweg       TYPE vbrk-vtweg,      "Distribution Chanel


**    netwr       TYPE vbrp-netwr,      "Amount in doc currrency
**    vgbel       TYPE vbrp-vgbel,      "Delivery No.
*    vgpos       TYPE vbrp-vgpos,      "Delivery Item
**    vgtyp       TYPE vbrp-vgtyp,
**    aupos       TYPE vbrp-aupos,      "Sales Item
    """""""""""""""""''new str
    werks         TYPE vbrp-werks,      "Plant
    vbeln         TYPE vbrk-vbeln,      "Inv No
    xblnr         TYPE vbrk-xblnr,      "ODN Number
    posnr         TYPE vbrp-posnr,      "Line Item
    fkart         TYPE vbrk-fkart,      "Billing Type
    fkdat         TYPE char11, "vbrk-fkdat,      "Billing Date
    auart         TYPE vbak-auart,      "Sales Order Type
    vkbur         TYPE vbak-vkbur,      "Sales Office
    aubel         TYPE vbrp-aubel,      "Sales Order No
    audat         TYPE char11, "vbak-audat,      "Sales Order Date
    vdatu         TYPE char11, "vbak-vdatu,      "Req Delivery Date
    edatu         TYPE char11, "vbep-edatu,        "Delivery Date
    bstnk         TYPE vbak-bstnk,      "Customer Ref No.
    kunag         TYPE vbrk-kunag,      "Customer Code
    name1         TYPE kna1-name1,        "Customer Name
    matnr         TYPE vbrp-matnr,      "Material Code
    arktx         TYPE vbrp-arktx,      "Sales Text
    long_txt      TYPE char100,         "Long Text for Material
    fkimg         TYPE char15, "vbrp-fkimg,      "Invoice Qty
    base_val      TYPE prcd_elements-kwert,        "Base Price
    waerk         TYPE vbrk-waerk,      "Currency
    kursk         TYPE vbrp-kursk,      "Exchange Rate
    val_inr       TYPE prcd_elements-kwert,      "Amount in Local Currency
    pf_val        TYPE prcd_elements-kwert,   "char100,        "P&F
    dis           TYPE prcd_elements-kwert,        "Discount
    ass_val       TYPE prcd_elements-kwert,        "Assessable
    exe_val       TYPE prcd_elements-kwert,        "Excise Duty
    edu_val       TYPE prcd_elements-kwert,        "Education Cess Amount
    hse_val       TYPE prcd_elements-kwert,        "Higher Education Cess Amount
    vat           TYPE prcd_elements-kwert,        "VAT/CST
    frt           TYPE prcd_elements-kwert,        "Freight
    ins           TYPE prcd_elements-kwert,        "Insurance
    cgst          TYPE prcd_elements-kwert,        "CGST
    sgst          TYPE prcd_elements-kwert,        "SGST
    igst          TYPE prcd_elements-kwert,        "JOIG
    tot           TYPE prcd_elements-kwert,        "Grand Total
    prodh         TYPE vbrp-prodh,      "Product Heirarchy
    steuc         TYPE marc-steuc,        "HSN Code
    vtext         TYPE tvktt-vtext,       "Sales Type Text
    trans         TYPE char30,            "Transporter Name
    lr_no         TYPE char20,            "L/R No.
    lr_dt         TYPE char10,            "LR Date
    traty         TYPE char20,        "Transport Type
    frt_typ       TYPE char40,            "Freight Type
*    int_pr        TYPE prcd_elements-kbetr,             "Internal Price
    int_pr        TYPE p DECIMALS 2,             "Internal Price
    stprs         TYPE prcd_elements-kwert,        "Cost
    stprs1        TYPE prcd_elements-kwert,        "Cost
    zseries       TYPE mara-zseries,      "Series
    zsize         TYPE mara-zsize,        "Size
    brand         TYPE mara-brand,              "Brand
    moc           TYPE mara-moc,                "MOC
    type          TYPE mara-type,               "Type
    ld_tg         TYPE char20,                  "LD Tag
    zldfromdate   TYPE char11, "vbak-zldfromdate,  "LD Date
    zldperweek    TYPE vbak-zldperweek,
    zldmax        TYPE vbak-zldmax,             "LD%
    vtext1        TYPE skat-txt20,             "Sales Ledger Head
    status        TYPE c,                       "Invoice Status
    kdmat         TYPE vbap-kdmat,              "Customer Item Code
    stcd3         TYPE kna1-stcd3,              "GSTIN No
    bezei         TYPE t005u-bezei,             "Region
    gst_region    TYPE zgst_region-gst_region,  "State Code
    kunnr         TYPE kna1-kunnr,              "Ship To Party
    name1_sh      TYPE kna1-name1,
    bezei_sh      TYPE t005u-bezei,             " Ship To Region
    gst_region_sh TYPE zgst_region-gst_region,  "Ship To State Code
    vrkme         TYPE vbrp-vrkme,              "Unit
    netpr         TYPE char100,              "Rate
    mwskz         TYPE prcd_elements-mwsk1,              "Taxcode
    tax_txt       TYPE t007s-text1,             "Tax Code Description
    tes           TYPE char100,              "Testing Charge
    ass_gst       TYPE prcd_elements-kwert,              "Assessable GST
    com_cess      TYPE char100,              "Comp Cess%
    com_cess_v    TYPE prcd_elements-kwert,              "Comp Cess Amt
*    tcs_p         TYPE prcd_elements-kbetr,              "TCS Per
    tcs_p         TYPE p DECIMALS 2,              "TCS Per
    tcs           TYPE char20,              "TCS amt
    hkont         TYPE bseg-hkont,              "Sales Ledger
    port_cd       TYPE char50,                  "Port Code
    shp_bil       TYPE char20,                  "Shipping Bill Number
    shp_bl_dt     TYPE char15,                  "Shipping Bill Dt
    del_proof     TYPE char15,                  "Proof of Delivery
    vtext_tax     TYPE tskdt-vtext,             "Tax Classification
    zuonr         TYPE vbrk-zuonr,              "Original Invoice Number
    kurrf_dat     TYPE char11, "vbrk-kurrf_dat,          "Invoice Date
    belnr         TYPE bkpf-belnr,              "FI Document No.
    blart         TYPE bkpf-blart,              "FI Document Type
*    cgst_p        TYPE prcd_elements-kbetr,              "CGST %
    cgst_p        TYPE p DECIMALS 2,              "CGST %
*    sgst_p        TYPE prcd_elements-kbetr,              "SGST %
    sgst_p        TYPE p DECIMALS 2,              "SGST %
*    igst_p        TYPE prcd_elements-kbetr,              "IGST %
    igst_p        TYPE p DECIMALS 2,              "IGST %
    curr_date     TYPE char11,
    address       TYPE string,      "" ** Address
    sal_txt       TYPE string,
    ref_date      TYPE string,            " Added By Abhishek Pisolkar (26.03.2018)
*    int_pr2       TYPE prcd_elements-kwert,             "Internal Price
    int_pr2       TYPE p DECIMALS 2,             "Internal Price
*    int_pr3       TYPE prcd_elements-kbetr,             "Internal Price
    int_pr3       TYPE p DECIMALS 2,             "Internal Price
*    int_pr4       TYPE prcd_elements-kwert,             "Internal Price
    int_pr4       TYPE p DECIMALS 2,             "Internal Price
*    int_pr5       TYPE prcd_elements-kwert,             "Internal Price
    int_pr5       TYPE p DECIMALS 2,             "Internal Price
*    int_pr6       TYPE prcd_elements-kwert,             "Internal Price
    int_pr6       TYPE p DECIMALS 2,             "Internal Price
  END OF t_final,

  tt_final TYPE STANDARD TABLE OF t_final.

DATA:
  gt_final TYPE tt_final.

TYPES:
  BEGIN OF ty_final,
    werks         TYPE vbrp-werks,      "Plant
    vbeln         TYPE vbrk-vbeln,      "Inv No
    xblnr         TYPE vbrk-xblnr,      "ODN Number
    posnr         TYPE vbrp-posnr,      "Line Item
    fkart         TYPE vbrk-fkart,      "Billing Type
    fkdat         TYPE char11, "vbrk-fkdat,      "Billing Date
    auart         TYPE vbak-auart,      "Sales Order Type
    vkbur         TYPE vbak-vkbur,      "Sales Office
    aubel         TYPE vbrp-aubel,      "Sales Order No
    audat         TYPE char11, "vbak-audat,      "Sales Order Date
    vdatu         TYPE char11, "vbak-vdatu,      "Req Delivery Date
    edatu         TYPE char11, "vbep-edatu,        "Delivery Date
    bstnk         TYPE vbak-bstnk,      "Customer Ref No.
    kunag         TYPE vbrk-kunag,      "Customer Code
    name1         TYPE kna1-name1,        "Customer Name
    matnr         TYPE vbrp-matnr,      "Material Code
    arktx         TYPE vbrp-arktx,      "Sales Text
    long_txt      TYPE char100,         "Long Text for Material
    fkimg         TYPE char15, "vbrp-fkimg,      "Invoice Qty
    base_val      TYPE char100,        "Base Price
    waerk         TYPE vbrk-waerk,      "Currency
    kursk         TYPE vbrp-kursk,      "Exchange Rate
    val_inr       TYPE char100,      "Amount in Local Currency
    pf_val        TYPE char100,        "P&F
    dis           TYPE char100,        "Discount
    ass_val       TYPE char100,        "Assessable
    exe_val       TYPE char100,        "Excise Duty
    edu_val       TYPE char100,        "Education Cess Amount
    hse_val       TYPE char100,        "Higher Education Cess Amount
    vat           TYPE char100,        "VAT/CST
    frt           TYPE char100,        "Freight
    ins           TYPE char100,        "Insurance
    cgst          TYPE char100,        "CGST
    sgst          TYPE char100,        "SGST
    igst          TYPE char100,        "JOIG
    tot           TYPE char100,        "Grand Total
    prodh         TYPE vbrp-prodh,      "Product Heirarchy
    steuc         TYPE marc-steuc,        "HSN Code
    vtext         TYPE tvktt-vtext,       "Sales Type Text
    trans         TYPE char30,            "Transporter Name
    lr_no         TYPE char20,            "L/R No.
    lr_dt         TYPE char10,            "LR Date
    traty         TYPE char20,        "Transport Type
    frt_typ       TYPE char40,            "Freight Type
    int_pr        TYPE char100,             "Internal Price
    stprs         TYPE char100,        "Cost
    stprs1        TYPE char100,        "Cost
    zseries       TYPE mara-zseries,      "Series
    zsize         TYPE mara-zsize,        "Size
    brand         TYPE mara-brand,              "Brand
    moc           TYPE mara-moc,                "MOC
    type          TYPE mara-type,               "Type
    ld_tg         TYPE char20,                  "LD Tag
    zldfromdate   TYPE char11, "vbak-zldfromdate,  "LD Date
    zldperweek    TYPE vbak-zldperweek,
    zldmax        TYPE vbak-zldmax,             "LD%
    vtext1        TYPE skat-txt20,             "Sales Ledger Head
    status        TYPE c,                       "Invoice Status
    kdmat         TYPE vbap-kdmat,              "Customer Item Code
    stcd3         TYPE kna1-stcd3,              "GSTIN No
    bezei         TYPE t005u-bezei,             "Region
    gst_region    TYPE zgst_region-gst_region,  "State Code
    kunnr         TYPE kna1-kunnr,              "Ship To Party
    name1_sh      TYPE kna1-name1,
    bezei_sh      TYPE t005u-bezei,             " Ship To Region
    gst_region_sh TYPE zgst_region-gst_region,  "Ship To State Code
    vrkme         TYPE vbrp-vrkme,              "Unit
    netpr         TYPE char100,              "Rate
    mwskz         TYPE prcd_elements-mwsk1,              "Taxcode
    tax_txt       TYPE t007s-text1,             "Tax Code Description
    tes           TYPE char100,              "Testing Charge
    ass_gst       TYPE char100,              "Assessable GST
    com_cess      TYPE char100,              "Comp Cess%
    com_cess_v    TYPE char100,              "Comp Cess Amt
*    tcs_p         TYPE prcd_elements-kbetr,              "TCS Per
    tcs_p         TYPE p DECIMALS 2,              "TCS Per
    tcs           TYPE char20,              "TCS amt
    hkont         TYPE bseg-hkont,              "Sales Ledger
    port_cd       TYPE char50,                  "Port Code
    shp_bil       TYPE char20,                  "Shipping Bill Number
    shp_bl_dt     TYPE char15,                  "Shipping Bill Dt
    del_proof     TYPE char15,                  "Proof of Delivery
    vtext_tax     TYPE tskdt-vtext,             "Tax Classification
    zuonr         TYPE vbrk-zuonr,              "Original Invoice Number
    kurrf_dat     TYPE char11, "vbrk-kurrf_dat,          "Invoice Date
    belnr         TYPE bkpf-belnr,              "FI Document No.
    blart         TYPE bkpf-blart,              "FI Document Type
*    cgst_p        TYPE prcd_elements-kbetr,              "CGST %
    cgst_p        TYPE p DECIMALS 2,              "CGST %
*    sgst_p        TYPE prcd_elements-kbetr,              "SGST %
    sgst_p        TYPE p DECIMALS 2,              "SGST %
*    igst_p        TYPE prcd_elements-kbetr,              "IGST %
    igst_p        TYPE p DECIMALS 2,              "IGST %
    curr_date     TYPE char11,
    address       TYPE string,      "" ** Address
    sal_txt       TYPE string,
    ref_date      TYPE string,            " Added By Abhishek Pisolkar (26.03.2018)
**    vkorg       TYPE vbrk-vkorg,      "Sales Org.
**    vtweg       TYPE vbrk-vtweg,      "Distribution Chanel


**    netwr       TYPE vbrp-netwr,      "Amount in doc currrency
**    vgbel       TYPE vbrp-vgbel,      "Delivery No.
*    vgpos       TYPE vbrp-vgpos,      "Delivery Item
**    vgtyp       TYPE vbrp-vgtyp,
**    aupos       TYPE vbrp-aupos,      "Sales Item
  END OF ty_final.

DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
SELECT-OPTIONS: so_vbeln FOR tmp_vbeln,
                so_fkdat FOR tmp_fkdat OBLIGATORY DEFAULT '20170401' TO sy-datum,
                so_ord   FOR tmp_so,
                so_kunnr FOR tmp_kunnr.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE abc .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

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
    lt_sales_inv_hdr       TYPE tt_sales_inv_hdr,
    ls_sales_inv_hdr       TYPE t_sales_inv_hdr,
    lt_sales_inv_item      TYPE tt_sales_inv_item,
    ls_sales_inv_item      TYPE t_sales_inv_item,
    lt_sales_ord_hdr       TYPE tt_sales_ord_hdr,
    ls_sales_ord_hdr       TYPE t_sales_ord_hdr,
    lt_BSEG                TYPE tt_BSEG,
    ls_BSEG                TYPE t_BSEG,
    lt_sales_ord_item      TYPE tt_sales_ord_item,
    ls_sales_ord_item      TYPE t_sales_ord_item,
    lt_sales_partner       TYPE tt_sales_partner,
    ls_sales_partner       TYPE t_sales_partner,
    lt_cust_info           TYPE tt_cust_info,
    ls_cust_info           TYPE t_cust_info,
    lt_schedule_line       TYPE tt_schedule_line,
    ls_schedule_line       TYPE t_schedule_line,
    lt_tvktt               TYPE tt_tvktt,
    ls_tvktt               TYPE t_tvktt,
    lt_conditions          TYPE tt_conditions,
    ls_conditions          TYPE t_conditions,
    lt_mat_master          TYPE tt_mat_master,
    ls_mat_master          TYPE t_mat_master,
    lt_material_val        TYPE tt_material_val,
    ls_material_val        TYPE t_material_val,
    lt_marc                TYPE tt_marc,
    ls_marc                TYPE t_marc,
    lt_sales_buss          TYPE tt_sales_buss,
    ls_sales_buss          TYPE t_sales_buss,
    lt_t005u               TYPE tt_t005u,
    ls_t005u               TYPE t_t005u,
    lt_zgst_region         TYPE tt_zgst_region,
    ls_zgst_region         TYPE t_zgst_region,
    lt_t007s               TYPE tt_t007s,
    ls_t007s               TYPE t_t007s,
    lt_knvi                TYPE tt_knvi,
    ls_knvi                TYPE t_knvi,
    lt_tskdt               TYPE tt_tskdt,
    ls_tskdt               TYPE t_tskdt,
    lt_afpo                TYPE tt_afpo,
    ls_afpo                TYPE t_afpo,
    lt_coep                TYPE tt_coep,
    ls_coep                TYPE t_coep,
    lt_accounting_doc_item TYPE tt_accounting_doc_item,
    lt_accounting_doc_itm1 TYPE tt_accounting_doc_item,   "For GL Account
    ls_accounting_doc_item TYPE t_accounting_doc_item,
    lt_accounting_doc_hdr  TYPE tt_accounting_doc_hdr,
    ls_accounting_doc_hdr  TYPE t_accounting_doc_hdr,
    lt_skat                TYPE tt_skat,
    ls_skat                TYPE t_skat,
    ls_final               TYPE t_final,
    lt_adrc                TYPE tt_adrc,
    ls_adrc                TYPE t_adrc,
    ls_sal_txt             TYPE t_sal_txt.

  DATA:
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text       = 'Reading data...'(i01)
      percentage = 1.

  "Fetch Data for Invoice Header
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
    AND   aubel IN so_ord.

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
      FROM vbrk
      INTO TABLE lt_sales_inv_hdr
      WHERE vbeln IN so_vbeln
      AND   fkdat IN so_fkdat
      AND   kunag IN so_kunnr
      AND   fkart NOT IN ('ZF5','ZF8','F5','F8','ZSN','ZSP','ZS1').

  ENDIF.

***  DELETE lt_sales_inv_hdr WHERE fkart ='ZSN'. " Challan Skip
***  DELETE lt_sales_inv_hdr WHERE fkart = 'ZSP'. " Challan Skip
***  DELETE lt_sales_inv_hdr WHERE fkart = 'ZS1'. " Cancel Invoice Skip

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
    WHERE vbeln = lt_sales_inv_hdr-vbeln.

    SELECT vbeln
           posnr
           matnr
           kdmat
*           DELDATE
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
      FROM prcd_elements  " konv
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
      AND   kalsm = 'ZTAXIN'.

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

      SELECT
         VBEL2
         POSN2
         MATNR
         MENGE
         KTOSL
         dmbtr
         shkzg
         FROM BSEG
         INTO TABLE LT_BSEG
         FOR ALL ENTRIES IN  lt_sales_inv_item
         WHERE BUKRS   = '1000'
         and  VBEL2   = lt_sales_inv_item-aubel
         AND    posn2   = lt_sales_inv_item-aupos
         and    MATNR   = lt_sales_inv_item-MATNR
         and    ktosl   = 'PRD' .


      SELECT kunnr
             name1
             land1
             regio
             adrnr
             stcd3
        FROM kna1
        INTO TABLE lt_cust_info
        FOR ALL ENTRIES IN lt_sales_inv_hdr
        WHERE kunnr = lt_sales_inv_hdr-kunag.


      SELECT vbeln
             kunnr
        FROM vbpa
        INTO TABLE lt_sales_partner
        FOR ALL ENTRIES IN lt_sales_ord_hdr
        WHERE vbeln = lt_sales_ord_hdr-vbeln
        AND   parvw IN ('SH','WE').

      SELECT kunnr
             name1
             land1
             regio
             adrnr
             stcd3
        FROM kna1
        APPENDING TABLE lt_cust_info
        FOR ALL ENTRIES IN lt_sales_partner
        WHERE kunnr = lt_sales_partner-kunnr.

      SORT lt_cust_info BY kunnr.
      DELETE ADJACENT DUPLICATES FROM lt_cust_info.
      IF NOT lt_cust_info IS INITIAL.
        SELECT addrnumber
               name1
               city2
               post_code1
               street
               str_suppl1
               str_suppl2
               str_suppl3
               location
               country
          FROM adrc
          INTO TABLE lt_adrc
          FOR ALL ENTRIES IN lt_cust_info
          WHERE addrnumber = lt_cust_info-adrnr.

        SELECT kunnr
               taxkd
          FROM knvi
          INTO TABLE lt_knvi
          FOR ALL ENTRIES IN lt_cust_info
          WHERE kunnr = lt_cust_info-kunnr
          AND   tatyp IN ('JOCG','JOIG').


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
      SELECT vbeln
             posnr
             edatu
        FROM vbep
        INTO TABLE lt_schedule_line
        FOR ALL ENTRIES IN lt_sales_ord_hdr
      WHERE vbeln = lt_sales_ord_hdr-vbeln.

      SELECT matnr
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
        FROM mbew
        INTO TABLE lt_material_val
        FOR ALL ENTRIES IN lt_sales_inv_item
      WHERE matnr = lt_sales_inv_item-matnr.

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

  IF lt_sales_inv_item IS INITIAL.
    MESSAGE 'Data Not Found' TYPE 'E'.

  ELSE.
    LOOP AT lt_sales_inv_item INTO ls_sales_inv_item.

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
      ls_final-prodh = ls_sales_inv_item-prodh.
      ls_final-werks = ls_sales_inv_item-werks.
*      ls_final-kursk = ls_sales_inv_item-kursk.
*      ls_final-val_inr = ls_sales_inv_item-kursk * ls_final-netwr.
************************************************************************************************************************

**********************************************************************************************************************

      READ TABLE lt_sales_ord_hdr INTO ls_sales_ord_hdr WITH KEY vbeln = ls_sales_inv_item-aubel.
      IF sy-subrc IS INITIAL.
        IF NOT ls_sales_ord_hdr-audat IS INITIAL.
          CONCATENATE ls_sales_ord_hdr-audat+6(2) ls_sales_ord_hdr-audat+4(2) ls_sales_ord_hdr-audat+0(4)
             INTO ls_final-audat SEPARATED BY '-'.
*        ELSE.
*          ls_final-audat = 'NULL'.
        ENDIF.
        ls_final-auart       = ls_sales_ord_hdr-auart.
        ls_final-vkbur       = ls_sales_ord_hdr-vkbur.

*        ls_final-vdatu       = ls_sales_ord_hdr-vdatu.
        IF NOT ls_sales_ord_hdr-vdatu IS INITIAL.
          CONCATENATE ls_sales_ord_hdr-vdatu+6(2) ls_sales_ord_hdr-vdatu+4(2) ls_sales_ord_hdr-vdatu+0(4)
             INTO ls_final-vdatu SEPARATED BY '-'.
*        ELSE.
*          ls_final-vdatu = 'NULL'.
        ENDIF.

        ls_final-bstnk       = ls_sales_ord_hdr-bstnk.

        IF NOT ls_sales_ord_hdr-zldfromdate IS INITIAL.
          CONCATENATE ls_sales_ord_hdr-zldfromdate+6(2) ls_sales_ord_hdr-zldfromdate+4(2) ls_sales_ord_hdr-zldfromdate+0(4)
             INTO ls_final-zldfromdate SEPARATED BY '-'.
*        ELSE.
*          ls_final-zldfromdate = 'NULL'.
        ENDIF.
        ls_final-zldperweek  = ls_sales_ord_hdr-zldperweek.
        ls_final-zldmax      = ls_sales_ord_hdr-zldmax.
      ENDIF.
      READ TABLE lt_sales_inv_hdr INTO ls_sales_inv_hdr WITH KEY vbeln = ls_sales_inv_item-vbeln.
      IF sy-subrc IS INITIAL.
        ls_final-waerk = ls_sales_inv_hdr-waerk.
        ls_final-kursk = ls_sales_inv_hdr-kurrf.
*        ls_final-vtweg = ls_sales_inv_hdr-vtweg.
        IF NOT ls_sales_inv_hdr-fkdat IS INITIAL.
          CONCATENATE ls_sales_inv_hdr-fkdat+6(2) ls_sales_inv_hdr-fkdat+4(2) ls_sales_inv_hdr-fkdat+0(4)
             INTO ls_final-fkdat SEPARATED BY '-'.

*        ELSE.
*          ls_final-fkdat = 'NULL'.
        ENDIF.
        ls_final-fkart = ls_sales_inv_hdr-fkart.
        ls_final-kunag = ls_sales_inv_hdr-kunag.
        ls_final-xblnr = ls_sales_inv_hdr-xblnr.
*        ls_final-ktgrd = ls_sales_inv_hdr-ktgrd.
        IF ls_final-fkart = 'ZDR' OR ls_final-fkart = 'ZCR'.
          ls_final-zuonr     = ls_sales_inv_hdr-zuonr.
          IF ls_final-zuonr IS INITIAL.
            ls_final-zuonr = ls_final-xblnr.
          ENDIF.

          IF NOT ls_sales_inv_hdr-kurrf_dat IS INITIAL.
            CONCATENATE ls_sales_inv_hdr-kurrf_dat+6(2) ls_sales_inv_hdr-kurrf_dat+4(2) ls_sales_inv_hdr-kurrf_dat+0(4)
               INTO ls_final-kurrf_dat SEPARATED BY '-'.

            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                input  = ls_sales_inv_hdr-kurrf_dat
              IMPORTING
                output = wa_final-kurrf_dat.


            CONCATENATE wa_final-kurrf_dat+0(2) wa_final-kurrf_dat+2(3) wa_final-kurrf_dat+5(4)
                      INTO wa_final-kurrf_dat SEPARATED BY '-'.

*          ELSE.
*            ls_final-kurrf_dat = 'NULL'.
          ENDIF.

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
        READ TABLE lt_accounting_doc_itm1 INTO ls_accounting_doc_item WITH KEY belnr = ls_accounting_doc_hdr-belnr
                                                                               gjahr = ls_accounting_doc_hdr-gjahr.
*                                                                               vbel2 = ls_sales_inv_item-aubel
*                                                                               posn2 = ls_sales_inv_item-aupos.
        IF sy-subrc IS INITIAL.
          ls_final-hkont   = ls_accounting_doc_item-hkont.

          READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_accounting_doc_item-hkont.
          IF sy-subrc IS INITIAL.
            ls_final-vtext1 = ls_skat-txt20.
          ENDIF.
        ENDIF.
      ENDIF.
      READ TABLE lt_sales_ord_item INTO ls_sales_ord_item WITH KEY vbeln = ls_sales_inv_item-aubel
                                                                   posnr = ls_sales_inv_item-aupos.
      IF sy-subrc IS INITIAL.
        ls_final-kdmat = ls_sales_ord_item-kdmat.
*        ls_final-DELDATE = ls_sales_ord_item-DELDATE .
      ENDIF.
      READ TABLE lt_cust_info INTO ls_cust_info WITH KEY kunnr = ls_sales_inv_hdr-kunag.
      IF sy-subrc IS INITIAL.
        ls_final-name1 = ls_cust_info-name1.
        ls_final-stcd3 = ls_cust_info-stcd3.
      ENDIF.
      READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_cust_info-adrnr.
      IF sy-subrc IS INITIAL.
        IF NOT ls_adrc-str_suppl1 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-str_suppl1 INTO ls_final-address.
        ENDIF.

        IF NOT ls_adrc-str_suppl2 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-str_suppl2 INTO ls_final-address.
        ENDIF.

        IF NOT ls_adrc-street IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-street INTO ls_final-address.
        ENDIF.

        IF NOT ls_adrc-str_suppl3 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-str_suppl3 INTO ls_final-address SEPARATED BY ','.
        ENDIF.
        IF NOT ls_adrc-location IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-location INTO ls_final-address SEPARATED BY ','.
        ENDIF.

        IF NOT ls_adrc-city2 IS INITIAL.
          CONCATENATE ls_final-address ls_adrc-city2 INTO ls_final-address SEPARATED BY ','.
        ENDIF.
        IF NOT ls_adrc-post_code1 IS INITIAL.
          CONCATENATE ls_final-address 'PIN:' ls_adrc-post_code1 INTO ls_final-address SEPARATED BY ','.
        ENDIF.
        CONDENSE ls_final-address.

      ENDIF.
      READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_cust_info-land1
                                                 bland = ls_cust_info-regio.
      IF sy-subrc IS INITIAL.
        ls_final-bezei = ls_t005u-bezei.
      ENDIF.

      IF ls_cust_info-land1 = 'IN'.
        READ TABLE lt_knvi INTO ls_knvi WITH KEY kunnr = ls_cust_info-kunnr.
        IF sy-subrc IS INITIAL.
          IF ls_cust_info-regio = '13'.
            READ TABLE lt_tskdt INTO ls_tskdt WITH KEY tatyp = 'JOCG'.
            IF sy-subrc IS INITIAL.
              ls_final-vtext_tax = ls_tskdt-vtext.
            ENDIF.
          ELSE.
            READ TABLE lt_tskdt INTO ls_tskdt WITH KEY tatyp = 'JOIG'.
            IF sy-subrc IS INITIAL.
              ls_final-vtext_tax = ls_tskdt-vtext.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = ls_t005u-bezei.
      IF sy-subrc IS INITIAL.
        ls_final-gst_region = ls_zgst_region-gst_region.
      ENDIF.


      READ TABLE lt_sales_partner INTO ls_sales_partner WITH KEY vbeln = ls_sales_ord_hdr-vbeln.
      IF sy-subrc IS INITIAL.
        ls_final-kunnr  = ls_sales_partner-kunnr.
      ENDIF.

      CLEAR:ls_cust_info,ls_t005u,ls_zgst_region.
      READ TABLE lt_cust_info INTO ls_cust_info WITH KEY kunnr = ls_sales_partner-kunnr.
      IF sy-subrc IS INITIAL.
        ls_final-name1_sh = ls_cust_info-name1.
*        ls_final-stcd3 = ls_cust_info-stcd3.
      ENDIF.

      READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_cust_info-land1
                                                 bland = ls_cust_info-regio.
      IF sy-subrc IS INITIAL.
        ls_final-bezei_sh = ls_t005u-bezei.
      ENDIF.
      READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = ls_t005u-bezei.
      IF sy-subrc IS INITIAL.
        ls_final-gst_region_sh = ls_zgst_region-gst_region.
      ENDIF.

      READ TABLE lt_schedule_line INTO ls_schedule_line WITH KEY vbeln = ls_sales_inv_item-aubel
                                                                 posnr = ls_sales_inv_item-aupos.
      IF sy-subrc IS INITIAL.
        IF NOT ls_schedule_line-edatu IS INITIAL.
          CONCATENATE ls_schedule_line-edatu+6(2) ls_schedule_line-edatu+4(2) ls_schedule_line-edatu+0(4)
             INTO ls_final-edatu SEPARATED BY '-'.
*        ELSE.
*          ls_final-edatu = 'NULL'.
        ENDIF.
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
        ls_final-zseries = ls_mat_master-zseries.
        ls_final-zsize   = ls_mat_master-zsize.
        ls_final-brand   = ls_mat_master-brand.
        ls_final-moc     = ls_mat_master-moc.
        ls_final-type    = ls_mat_master-type.
      ENDIF.

      READ TABLE lt_material_val INTO ls_material_val WITH KEY matnr = ls_sales_inv_item-matnr.
      IF sy-subrc IS INITIAL.
        ls_final-stprs  = ls_material_val-stprs.
        ls_final-stprs1 = ls_material_val-stprs.
      ENDIF.
      READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_sales_inv_item-matnr.
      IF sy-subrc IS INITIAL.
        ls_final-steuc = ls_marc-steuc.
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
        ls_final-val_inr  = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
        ls_final-netpr    = ls_final-base_val / ls_final-fkimg.
        IF ls_sales_inv_hdr-waerk = 'USD'.
          ls_final-int_pr3 = ls_conditions-kbetr * ls_sales_inv_hdr-kurrf.
*        ls_final-int_pr2 = ls_conditions-KWERT_K.
        ELSE.
          ls_final-int_pr3 = ls_conditions-kbetr.
*        ls_final-int_pr2 = ls_conditions-KWERT_K.
        ENDIF.

      ENDIF.
*      IF ls_sales_inv_item-aubel IS NOT INITIAL.
*          READ TABLE LT_BSEG INTO LS_BSEG WITH KEY vbel2  = ls_sales_inv_item-aubel
*                                                   posn2  = ls_sales_inv_item-aupos
*                                                   MATNR  = ls_sales_inv_item-MATNR
*                                                   menge  = ls_sales_inv_item-fkimg
*                                                   ktosl  = 'PRD' .
*
*          IF LS_BSEG-SHKZG = 'H'.
*           ls_final-int_pr6 = LS_BSEG-DMBTR.
*           ls_final-int_pr6 = ls_final-int_pr6 * -1.
*          ELSE.
*           ls_final-int_pr6 = LS_BSEG-DMBTR.
*          ENDIF.
*      ENDIF.



      "Discount Price
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZDIS'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-dis = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-dis = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Internal Price
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'VPRS'.
*                                                           kstat = space.  " SHIVAJI SIR REUIREMNT NECESSARY CHANGES
      IF sy-subrc IS  INITIAL.
        IF ls_sales_inv_hdr-waerk = 'USD'.
          ls_final-int_pr = ls_conditions-kbetr * ls_sales_inv_hdr-kurrf.
          ls_final-int_pr2 = ls_conditions-kwert_k.
        ELSE.
          ls_final-int_pr = ls_conditions-kbetr.
          ls_final-int_pr2 = ls_conditions-kwert_k.
        ENDIF.
*        ls_final-int_pr = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.
      IF ls_final-int_pr IS NOT INITIAL AND ls_final-int_pr3 IS NOT INITIAL.
        ls_final-int_pr4 = ls_final-int_pr3 - ls_final-int_pr.
        IF ls_final-int_pr4 < 0.
          ls_final-int_pr4 = ls_final-int_pr4 * -1.
        ENDIF.
        ls_final-int_pr5 = ls_final-int_pr4 / ls_final-int_pr3 * 100.
      ENDIF.
      "Packing Forwarding Charge
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZPFO'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-pf_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-pf_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Assessable Value
      ls_final-ass_val = ls_final-val_inr + ls_final-pf_val + ls_final-dis.

      "Excise Duty
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZEXP'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-exe_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-exe_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-mwskz = ls_conditions-mwsk1.
      ENDIF.

      "Education Cess Amount
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCEP'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-edu_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-edu_val = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Higher Education Cess Amount
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCEH'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-hse_val = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-hse_val = ls_conditions-kwert * ls_sales_inv_item-kursk.

      ENDIF.

      "VAT
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCST'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-vat = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Testing Charge
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZTE1'
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
        ls_final-vat = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-vat = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "CGST
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'JOCG'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-cgst_p = ls_conditions-kbetr / 10.
        ls_final-cgst_p = ls_conditions-kbetr.
        ls_final-cgst   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-cgst   = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-mwskz  = ls_conditions-mwsk1.
      ENDIF.

      "SGST
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'JOSG'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-sgst_p = ls_conditions-kbetr / 10.
        ls_final-sgst_p = ls_conditions-kbetr .
*        ls_final-sgst   = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-sgst   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
      ENDIF.

      "IGST
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'JOIG'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
*        ls_final-igst_p = ls_conditions-kbetr / 10.
        ls_final-igst_p = ls_conditions-kbetr .
        ls_final-igst   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-igst   = ls_conditions-kwert * ls_sales_inv_item-kursk.
        ls_final-mwskz  = ls_conditions-mwsk1.
      ENDIF.

      READ TABLE lt_t007s INTO ls_t007s WITH KEY mwskz = ls_final-mwskz.
      IF sy-subrc IS INITIAL.
        ls_final-tax_txt = ls_t007s-text1.
      ENDIF.
      "Freight
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZFR1'
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
        ls_final-ins = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Insurance
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZIN2'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-ins = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "Insurance
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZIPP'
                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-ins = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-ins = ls_conditions-kwert * ls_sales_inv_item-kursk.
      ENDIF.

      "TCS
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZTCS'.
*                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-tcs   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-tcs   = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
        ls_final-tcs_p = ls_conditions-kbetr .
      ENDIF.

      "Compensation Cess
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCES'.
*                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-com_cess   = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-com_cess   = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
      ENDIF.

      "Compensation Cess
      READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_sales_inv_hdr-knumv
                                                           kposn = ls_sales_inv_item-posnr
                                                           kschl = 'ZCEV'.
*                                                           kstat = space.
      IF sy-subrc IS  INITIAL.
        ls_final-com_cess_v  = ls_conditions-kwert * ls_sales_inv_hdr-kurrf.
*        ls_final-com_cess_v  = ls_conditions-kwert * ls_sales_inv_item-kursk.
*        ls_final-tcs_p = ls_conditions-kbetr / 10.
      ENDIF.

*      IF NOT ls_final-cgst IS INITIAL OR
*        NOT ls_final-igst IS INITIAL.
      ls_final-ass_gst = ls_final-ass_val + ls_final-frt + ls_final-ins + ls_final-tes.
*      ENDIF.


      IF ls_sales_inv_hdr-fksto = 'X'.
        ls_final-status     = 'C'.
        ls_final-base_val   = 0.
        ls_final-val_inr    = 0.
        ls_final-dis        = 0.
        ls_final-int_pr     = 0.
        ls_final-pf_val     = 0.
        ls_final-ass_val    = 0.
        ls_final-exe_val    = 0.
        ls_final-edu_val    = 0.
        ls_final-hse_val    = 0.
        ls_final-vat        = 0.
        ls_final-cgst       = 0.
        ls_final-sgst       = 0.
        ls_final-igst       = 0.
        ls_final-frt        = 0.
        ls_final-ins        = 0.
        ls_final-tes        = 0.
        ls_final-ass_gst    = 0.
        ls_final-com_cess   = 0.
        ls_final-com_cess_v = 0.
        ls_final-tcs_p      = 0.
        ls_final-tcs        = 0.

      ENDIF.
      ls_final-tot =
             ls_final-ass_val + ls_final-exe_val + ls_final-edu_val + ls_final-hse_val + ls_final-vat + ls_final-cgst + ls_final-sgst
             + ls_final-igst + ls_final-frt + ls_final-ins + ls_final-tes + ls_final-com_cess + ls_final-com_cess_v + ls_final-tcs.

      IF ls_final-fkart = 'ZRE' OR ls_final-fkart = 'ZCR'.
        ls_final-tot        = ls_final-tot * -1.
        ls_final-base_val   = ls_final-base_val * -1.
        ls_final-val_inr    = ls_final-val_inr * -1.
        ls_final-ass_val    = ls_final-ass_val * -1.
        ls_final-exe_val    = ls_final-exe_val * -1.
        ls_final-edu_val    = ls_final-edu_val * -1.
        ls_final-hse_val    = ls_final-hse_val * -1.
        ls_final-vat        = ls_final-vat * -1.
        ls_final-cgst       = ls_final-cgst * -1.
        ls_final-sgst       = ls_final-cgst * -1.
        ls_final-igst       = ls_final-igst * -1.
        ls_final-frt        = ls_final-frt * -1.
        ls_final-ins        = ls_final-ins * -1.
        ls_final-tes        = ls_final-tes * -1.
        ls_final-ass_gst    = ls_final-ass_gst * -1.
        ls_final-com_cess   = ls_final-com_cess * -1.
        ls_final-com_cess_v = ls_final-com_cess_v * -1.
        ls_final-tcs        = ls_final-tcs * -1.

      ENDIF.

      lv_id = ls_final-vbeln.

      "Transporter Name Text
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z002'
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-trans ls_lines-tdline INTO ls_final-trans SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-trans.
      ENDIF.

      "LR No.
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z026'
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-lr_no ls_lines-tdline INTO ls_final-lr_no SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-lr_no.
      ENDIF.

      "LR Date.
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z012'
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-lr_dt ls_lines-tdline INTO ls_final-lr_dt SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-lr_dt.
      ENDIF.

      "Transport Type
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z013'
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-traty ls_lines-tdline INTO ls_final-traty SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-traty.
      ENDIF.

      "Freight Type.
      CLEAR: lt_lines[],ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z005'
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-frt_typ ls_lines-tdline INTO ls_final-frt_typ SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-frt_typ.
      ENDIF.

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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-ld_tg ls_lines-tdline INTO ls_final-ld_tg SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-ld_tg.
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
          LOOP AT lt_lines INTO ls_lines.
            IF NOT ls_lines-tdline IS INITIAL.
              CONCATENATE ls_final-ld_tg ls_lines-tdline INTO ls_final-ld_tg SEPARATED BY space.
            ENDIF.
          ENDLOOP.
          CONDENSE ls_final-ld_tg.
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-port_cd ls_lines-tdline INTO ls_final-port_cd SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-port_cd.
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-shp_bil ls_lines-tdline INTO ls_final-shp_bil SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-shp_bil.
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-shp_bl_dt ls_lines-tdline INTO ls_final-shp_bl_dt SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-shp_bl_dt.
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
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-shp_bl_dt ls_lines-tdline INTO ls_final-shp_bl_dt SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-shp_bl_dt.
      ENDIF.

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

      SHIFT ls_final-vbeln LEFT DELETING LEADING '0'.
      SHIFT ls_final-aubel LEFT DELETING LEADING '0'.
      SHIFT ls_final-xblnr LEFT DELETING LEADING '0'.
      SHIFT ls_final-kunag LEFT DELETING LEADING '0'.

      ls_final-curr_date  = sy-datum.
      wa_final-curr_date     = ls_final-curr_date.
      wa_final-werks         = ls_final-werks.
      wa_final-vbeln         = ls_final-vbeln.
      wa_final-xblnr         = ls_final-xblnr.
      wa_final-zuonr         = ls_final-zuonr.
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
      wa_final-vtext_tax     = ls_final-vtext_tax.
      wa_final-stcd3         = ls_final-stcd3.
      wa_final-gst_region    = ls_final-gst_region.
      wa_final-bezei         = ls_final-bezei.
      wa_final-kunnr         = ls_final-kunnr.
      wa_final-name1_sh      = ls_final-name1_sh.
      wa_final-gst_region_sh = ls_final-gst_region_sh.
      wa_final-bezei_sh      = ls_final-bezei_sh.
      wa_final-matnr         = ls_final-matnr.
      wa_final-arktx         = ls_final-arktx.
      wa_final-long_txt      = ls_final-long_txt.
      wa_final-kdmat         = ls_final-kdmat.
      wa_final-fkimg         = ls_final-fkimg.
      wa_final-vrkme         = ls_final-vrkme.
      wa_final-netpr         = ls_final-netpr.
      wa_final-blart         = ls_final-blart.
      wa_final-belnr         = ls_final-belnr.
      wa_final-mwskz         = ls_final-mwskz.
      wa_final-tax_txt       = ls_final-tax_txt.
      wa_final-base_val      = abs( ls_final-base_val ).
      IF ls_final-base_val < 0.
        CONDENSE wa_final-base_val.
        CONCATENATE '-' wa_final-base_val INTO wa_final-base_val.
      ENDIF.
      wa_final-waerk         = ls_final-waerk.
      wa_final-kursk         = ls_final-kursk.
      wa_final-val_inr       = abs( ls_final-val_inr ).

      IF ls_final-val_inr < 0.
        CONDENSE wa_final-val_inr.
        CONCATENATE '-' wa_final-val_inr INTO wa_final-val_inr.
      ENDIF.

      wa_final-pf_val        = abs( ls_final-pf_val ).
      IF ls_final-pf_val < 0.
        CONDENSE wa_final-pf_val.
        CONCATENATE '-' wa_final-pf_val INTO wa_final-pf_val.
      ENDIF.

      wa_final-dis           = abs( ls_final-dis ).
      IF ls_final-dis < 0.
        CONDENSE wa_final-dis.
        CONCATENATE '-' wa_final-dis INTO wa_final-dis.
      ENDIF.

      wa_final-ass_val       = abs( ls_final-ass_val ).
      IF ls_final-ass_val < 0.
        CONDENSE wa_final-ass_val.
        CONCATENATE '-' wa_final-ass_val INTO wa_final-ass_val.
      ENDIF.

      wa_final-exe_val       = abs( ls_final-exe_val ).
      IF ls_final-exe_val < 0.
        CONDENSE wa_final-exe_val.
        CONCATENATE '-' wa_final-exe_val INTO wa_final-exe_val.
      ENDIF.

      wa_final-edu_val       = ls_final-edu_val.
      IF ls_final-edu_val < 0.
        CONDENSE wa_final-edu_val.
        CONCATENATE '-' wa_final-edu_val INTO wa_final-edu_val.
      ENDIF.

      wa_final-hse_val       = abs( ls_final-hse_val ).
      IF ls_final-hse_val < 0.
        CONDENSE wa_final-hse_val.
        CONCATENATE '-' wa_final-hse_val INTO wa_final-hse_val.
      ENDIF.

      wa_final-vat           = abs( ls_final-vat ).
      IF ls_final-vat < 0.
        CONDENSE wa_final-vat.
        CONCATENATE '-' wa_final-vat INTO wa_final-vat.
      ENDIF.

      wa_final-frt           = abs( ls_final-frt ).
      IF ls_final-frt < 0.
        CONDENSE wa_final-frt.
        CONCATENATE '-' wa_final-frt INTO wa_final-frt.
      ENDIF.

      wa_final-ins           = abs( ls_final-ins ).
      IF ls_final-ins < 0.
        CONDENSE wa_final-ins.
        CONCATENATE '-' wa_final-ins INTO wa_final-ins.
      ENDIF.

      wa_final-tes           = abs( ls_final-tes ).
      IF ls_final-tes < 0.
        CONDENSE wa_final-tes.
        CONCATENATE '-' wa_final-tes INTO wa_final-tes.
      ENDIF.

      wa_final-ass_gst       = abs( ls_final-ass_gst ).
      IF ls_final-ass_gst < 0.
        CONDENSE wa_final-ass_gst.
        CONCATENATE '-' wa_final-ass_gst INTO wa_final-ass_gst.
      ENDIF.

      wa_final-cgst_p        = ls_final-cgst_p.

      wa_final-cgst          = abs( ls_final-cgst ).
      IF ls_final-cgst < 0.
        CONDENSE wa_final-cgst.
        CONCATENATE '-' wa_final-cgst INTO wa_final-cgst.
      ENDIF.

      wa_final-sgst_p        = ls_final-sgst_p.

      wa_final-sgst          = abs( ls_final-sgst ).
      IF ls_final-sgst < 0.
        CONDENSE wa_final-sgst.
        CONCATENATE '-' wa_final-sgst INTO wa_final-sgst.
      ENDIF.

      wa_final-igst_p        = ls_final-igst_p.

      wa_final-igst          = abs( ls_final-igst ).
      IF ls_final-igst < 0.
        CONDENSE wa_final-igst.
        CONCATENATE '-' wa_final-igst INTO wa_final-igst.
      ENDIF.

      wa_final-com_cess      = abs( ls_final-com_cess ).
      IF ls_final-com_cess < 0.
        CONDENSE wa_final-com_cess.
        CONCATENATE '-' wa_final-com_cess INTO wa_final-com_cess.
      ENDIF.

      wa_final-com_cess_v    = abs( ls_final-com_cess_v ).
      IF ls_final-com_cess_v < 0.
        CONDENSE wa_final-com_cess_v.
        CONCATENATE '-' wa_final-com_cess_v INTO wa_final-com_cess_v.
      ENDIF.

      wa_final-tcs_p         = ls_final-tcs_p.

      wa_final-tcs           = abs( ls_final-tcs ).
      IF ls_final-tcs < 0.
        CONDENSE wa_final-tcs.
        CONCATENATE '-' wa_final-tcs INTO wa_final-tcs.
      ENDIF.

      wa_final-tot           = abs( ls_final-tot ).
      IF ls_final-tot < 0.
        CONDENSE wa_final-tot.
        CONCATENATE '-' wa_final-tot INTO wa_final-tot.
      ENDIF.

      wa_final-prodh         = ls_final-prodh.
      wa_final-steuc         = ls_final-steuc.
      wa_final-vtext         = ls_final-vtext.
      wa_final-trans         = ls_final-trans.
      wa_final-lr_no         = ls_final-lr_no.
      wa_final-traty         = ls_final-traty.
      wa_final-frt_typ       = ls_final-frt_typ.
      wa_final-int_pr        = ls_final-int_pr.
      wa_final-stprs         = ls_final-stprs.
      wa_final-stprs1        = ls_final-stprs1.
      wa_final-zseries       = ls_final-zseries.
      wa_final-zsize         = ls_final-zsize.
      wa_final-brand         = ls_final-brand.
      wa_final-moc           = ls_final-moc.
      wa_final-type          = ls_final-type.
      wa_final-ld_tg         = ls_final-ld_tg.
      wa_final-zldperweek    = ls_final-zldperweek.
      wa_final-zldmax        = ls_final-zldmax.
      wa_final-hkont         = ls_final-hkont.
      wa_final-vtext1        = ls_final-vtext1.
      wa_final-port_cd       = ls_final-port_cd.
      wa_final-shp_bil       = ls_final-shp_bil.
      wa_final-del_proof     = ls_final-del_proof.
      wa_final-lr_dt         = ls_final-lr_dt.

*    wa_final-SHP_BL_DT     .


*    wa_final-KURRF_DAT     = ls_final-KURRF_DAT.

*      IF ls_sales_ord_hdr-kurrf_dat IS NOT INITIAL.

*      ENDIF.

* wa_final-ZLDFROMDATE   = ls_final-ZLDFROMDATE.
      IF ls_sales_ord_hdr-zldfromdate IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_sales_ord_hdr-zldfromdate
          IMPORTING
            output = wa_final-zldfromdate.


        CONCATENATE wa_final-zldfromdate+0(2) wa_final-zldfromdate+2(3) wa_final-zldfromdate+5(4)
                  INTO wa_final-zldfromdate SEPARATED BY '-'.

      ENDIF.

*    wa_final-AUDAT         = ls_final-AUDAT.

      IF ls_sales_ord_hdr-audat IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_sales_ord_hdr-audat
          IMPORTING
            output = wa_final-audat.
        CONCATENATE wa_final-audat+0(2) wa_final-audat+2(3) wa_final-audat+5(4)
                       INTO wa_final-audat SEPARATED BY '-'.


      ENDIF.


*    wa_final-FKDAT         = ls_final-FKDAT.

      IF ls_sales_inv_hdr-fkdat IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_sales_inv_hdr-fkdat
          IMPORTING
            output = wa_final-fkdat.
        CONCATENATE wa_final-fkdat+0(2) wa_final-fkdat+2(3) wa_final-fkdat+5(4)
                       INTO wa_final-fkdat SEPARATED BY '-'.

      ENDIF.


* wa_final-VDATU         = ls_final-VDATU.

      IF ls_sales_ord_hdr-vdatu IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_sales_ord_hdr-vdatu
          IMPORTING
            output = wa_final-vdatu.
        CONCATENATE wa_final-vdatu+0(2) wa_final-vdatu+2(3) wa_final-vdatu+5(4)
                       INTO wa_final-vdatu SEPARATED BY '-'.

      ENDIF.



*    wa_final-EDATU         = ls_final-EDATU.

      IF ls_schedule_line-edatu IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_schedule_line-edatu
          IMPORTING
            output = wa_final-edatu.
        CONCATENATE wa_final-edatu+0(2) wa_final-edatu+2(3) wa_final-edatu+5(4)
                       INTO wa_final-edatu SEPARATED BY '-'.

      ENDIF.

      IF ls_final-curr_date IS NOT INITIAL .


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-curr_date
          IMPORTING
            output = wa_final-curr_date.
        CONCATENATE wa_final-curr_date+0(2) wa_final-curr_date+2(3) wa_final-curr_date+5(4)
                       INTO wa_final-curr_date SEPARATED BY '-'.

      ENDIF.
*******************************************************************************************************************

      IF  ls_sales_inv_item-aubel  IS NOT INITIAL.


        DATA:
          name      TYPE thead-tdname,
          blank     TYPE tline-tdformat,
          des       TYPE tline-tdline,
          count     TYPE num VALUE '1',
          lt1_lines TYPE STANDARD TABLE OF tline,
          ls1_lines TYPE tline.



*      CONCATENATE LS_SALES_INV_ITEM-aubel  LS_SALES_INV_ITEM-vgpos INTO LS_FINAL-sal_txt.
        CONCATENATE ls_sales_inv_item-aubel  '000010' INTO ls_final-sal_txt.

        name = ls_final-sal_txt.


        CLEAR: lt1_lines[],ls1_lines.
*BREAK primus.
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


        CLEAR ls_final-sal_txt.
        IF lt1_lines IS NOT INITIAL.


          LOOP AT lt1_lines INTO ls1_lines .
*  COUNT = COUNT + 1.
*   BLANK  = LS1_LINES-TDFORMAT.
*   DES  = LS1_lines-tdline.
*
*   IF COUNT = '2'.
*   EXIT.
*
*  ENDIF.
            CONCATENATE ls_final-sal_txt ls1_lines-tdline INTO ls_final-sal_txt SEPARATED BY space.

          ENDLOOP.

        ENDIF.

      ENDIF.
*clear ls_final-sal_txt.
* LS_FINAL-SAL_TXT = DES.

*gt_final-sal_txt = ls_final-sal_txt.
      wa_final-sal_txt = ls_final-sal_txt.
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
*BREAK primus.



      APPEND wa_final TO it_final.

*CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+0(4)
*             INTO ls_final-rep_date SEPARATED BY '-'.

      APPEND ls_final TO ct_final.

      CLEAR:
         ls_final, ls_sales_inv_item,ls_sales_inv_hdr,ls_sales_ord_hdr,ls_tvktt,ls_cust_info,ls_mat_master,ls_marc,ls_schedule_line,
         ls_sales_buss,lt_lines,ls_lines,lt1_lines,ls1_lines,blank,des,ls_sal_txt, ls_sal_txt,name,count.


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
  ls_fieldcat-seltext_m = 'Plant'(100).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VBELN'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Billing No.'(101).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-hotspot   = 'X'.
  ls_fieldcat-no_zero   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'XBLNR'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Invoice No.'(102).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZUONR'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Original Invoice No.'(183).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KURRF_DAT'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Original Invoice Dt.'(184).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STATUS'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Status'(159).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'POSNR'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Item Line'(114).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FKART'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Billing Type'(156).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FKDAT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Inv. Date'(103).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUART'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Ord. Type'(104).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VKBUR'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Off'(105).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUBEL'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Doc.No.'(106).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUDAT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SO Date'(107).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VDATU'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Req.Del.Date'(108).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EDATU'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Del.Date'(109).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BSTNK'.
*  ls_fieldcat-outputlen = '16'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer Ref.No.'(110).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KUNAG'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer Code'(111).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer Name'(112).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ADDRESS'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Address'(190).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VTEXT_TAX'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'REGD/URD/SEZ/DEEMED/GOV'(182).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STCD3'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer GSTIN'(161).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GST_REGION'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer State Code'(162).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BEZEI'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer State Name'(163).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1_SH'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Ship To Name'(164).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GST_REGION_SH'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Ship To Party State Code'(165).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BEZEI_SH'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Ship To Party State'(166).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MATNR'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Item Code'(113).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ARKTX'.
*  ls_fieldcat-outputlen = '30'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Text'(115).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LONG_TXT'.
*  ls_fieldcat-outputlen = '50'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Long Text'(158).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KDMAT'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer Item Code'(160).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FKIMG'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Inv.Qty.'(117).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VRKME'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'UOM'(167).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NETPR'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Rate'(168).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BLART'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'FI Doc.Type'(185).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BELNR'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'FI Doc.No.'(186).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MWSKZ'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Tax Code'(169).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TAX_TXT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Tax Code Description'(170).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BASE_VAL'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Basic Amt(D.C.)'(118).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-do_sum    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WAERK'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Curr'(131).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KURSK'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Ex.Rate'(132).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VAL_INR'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Basic Val(INR)'(154).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-do_sum    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PF_VAL'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'P&F Amt'(119).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DIS'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Discount'(157).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ASS_VAL'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Ass. Val.'(120).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EXE_VAL'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Exe Duty Amt.'(121).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EDU_VAL'.
*  ls_fieldcat-outputlen = '13'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Edu. Cess Amt'(122).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'HSE_VAL'.
*  ls_fieldcat-outputlen = '13'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'H.E. Cess Amt'(123).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VAT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'VAT/CST'(124).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FRT'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Freight'(128).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'INS'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Insurance'(129).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TES'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Testing Charge'(171).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ASS_GST'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Assessable GST'(172).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CGST_P'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'CGST%'(187).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CGST'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'CGST'(125).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SGST_P'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SGST%'(188).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SGST'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SGST'(126).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'IGST_P'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'IGST%'(189).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'IGST'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'IGST'(127).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'COM_CESS'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Com.Cess'(173).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'COM_CESS_V'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Com.Cess Amt.'(174).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TCS_P'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'TCS%'(175).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TCS'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'TCS Amt.'(176).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TOT'.
*  ls_fieldcat-outputlen = '02'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Grand Total'(130).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-do_sum    = 'X'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PRODH'.
*  ls_fieldcat-outputlen = '14'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Prod. Category'(133).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STEUC'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'HSN Code'(134).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VTEXT'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Type'(135).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TRANS'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Transporter Name'(136).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LR_NO'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'LR No.'(137).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LR_DT'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'LR Date'(138).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TRATY'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Transport Type'(139).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FRT_TYP'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Freight Type'(140).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'INT_PR'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_m = 'Internal Price'(141).
  ls_fieldcat-seltext_m = 'Per Unit Cost'(141).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STPRS'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Est. Cost'(142).
*  ls_fieldcat-seltext_m = 'Actual Rate'(142).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STPRS1'.
*  ls_fieldcat-outputlen = '9'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Std. Cost'(143).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSERIES'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Series'(144).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSIZE'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Size'(145).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BRAND'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Brand'(146).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MOC'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MOC'(147).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TYPE'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Type'(148).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LD_TG'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'LD Tag'(149).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZLDFROMDATE'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'LD Date'(150).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZLDPERWEEK'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'LD% Min'(155).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZLDMAX'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'LD% Max'(151).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'HKONT'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Ledger Code'(177).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VTEXT1'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Ledger Head'(152).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PORT_CD'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Port Code'(178).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SHP_BIL'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Shipping Bill Number'(179).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SHP_BL_DT'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Shipping Bill Date'(180).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DEL_PROOF'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Proof of Delivery'(181).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CURR_DATE'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'File Create Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SAL_TXT'.
*  ls_fieldcat-outputlen = '25'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'PO DOCUMENT NO'(191).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'INT_PR2'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_m = 'Internal Price'(141).
  ls_fieldcat-seltext_m = 'Total Material Cost'(192).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'INT_PR3'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_m = 'Internal Price'(141).
  ls_fieldcat-seltext_m = 'Sale Price Per Unit'(193).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'INT_PR5'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_m = 'Internal Price'(141).
  ls_fieldcat-seltext_m = 'Sale Proft %'(194).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'INT_PR6'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
*  ls_fieldcat-seltext_m = 'Internal Price'(141).
  ls_fieldcat-seltext_m = 'Material Price Diff.'(196).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

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

*  TYPE-POOLS truxs.
*  DATA: it_csv TYPE truxs_t_text_data,
*        wa_csv TYPE LINE OF truxs_t_text_data,
*        hd_csv TYPE LINE OF truxs_t_text_data.
*
**  DATA: lv_folder(150).
*  DATA: lv_file(30).
*  DATA: lv_fullfile TYPE string,
*        lv_dat(10),
*        lv_tim(4).
*  DATA: lv_msg(80).
****************************************************************************************
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = gt_final
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZSALES.TXT'.
*
*  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*
*******************************************************new file zsales **********************************
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_final
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZSALES.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ELSE.
*     lv_file = 'ZSALE.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*
*  ENDIF.


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
  lv_file = 'ZSALES.TXT'.

  CONCATENATE p_folder '/' lv_file "sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
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
*BREAK primus.
  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZSALES.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
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
*  ELSE.
*     lv_file = 'ZSALE.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZSALES Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.

  ENDIF.

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
              'Billing No.'
              'Invoice No.'
              'Item Line'
              'Billing Type'
              'Inv. Date'
              'Ord. Type'
              'Sales Off'
              'Sales Doc.No.'
              'SO Date'
              'Req.Del.Date'
              'Del.Date'
              'Customer Ref.No.'
              'Customer Code'
              'Customer Name'
              'Item Code'
              'Sales Text'
              'Long Text'
              'Inv.Qty.'
              'Basic Amt(D.C.)'
              'Curr'
              'Ex.Rate'
              'Basic Val(INR)'
              'P&F Amt'
              'Discount'
              'Ass. Val.'
              'Exe Duty Amt.'
              'Edu. Cess Amt'
              'H.E. Cess Amt'
              'VAT/CST'
              'Freight'
              'Insurance'
              'CGST'
              'SGST'
              'IGST'
              'Grand Total'
              'Prod. Category'
              'HSN Code'
              'Sales Type'
              'Transporter Name'
              'LR No.'
              'LR Date'
              'Transport Type'
              'Freight Type'
              'Internal Price'
              'Est. Cost'
              'Std. Cost'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'Type'
              'LD Tag'
              'LD Date'
              'LD% Min'
              'LD% Max'
              'Sales Ledger Head'
              'Status'
              'Customer Item Code'
              'GSTIN No'
              'Region'
              'State Code'
              'Ship To Party'
              'Ship To Party Name'
              'Ship To Region'
              'Ship To State Code'
              'Unit'
              'Rate'
              'Taxcode'
              'Tax Code Description'
              'Testing Charge'
              'Assessable GST'
              'Comp Cess%'
              'Comp Cess Amt'
              'TCS%'
              'TCS amt'
              'Sales Ledger'
              'Port Code'
              'Shipping Bill Number'
              'Shipping Bill Dt'
              'Proof of Delivery'
              'Tax Classification'
              'Original Invoice Number'
              'Invoice Date'
              'FI Document No.'
              'FI Document Type'
              'CGST%'
              'SGST%'
              'IGST%'
              'FILE CREATE DATE'
              'Customer Address'
              'Sales Item Text'
*              'ADDL_Data_B_Date'  "sarika talekar
              'Refeshable Date'    " By Abhishek Pisolkar (26.03.2018)

  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
