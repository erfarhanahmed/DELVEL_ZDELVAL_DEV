*----------------------------------------------------------------------*
***INCLUDE ZPUR_REGISTER_DD.
*----------------------------------------------------------------------*


TYPE-POOLS : slis.

** TABLES DECLARATION
TABLES : bkpf, rseg.


DATA : BEGIN OF gt_bkpf OCCURS 0,
         bukrs     LIKE bkpf-bukrs,
         belnr     LIKE bkpf-belnr,
         gjahr     LIKE bkpf-gjahr,
         blart     LIKE bkpf-blart,
         bldat     LIKE bkpf-bldat,
         budat     LIKE bkpf-budat,
         xblnr     LIKE bkpf-xblnr,
         waers     LIKE bkpf-waers,
         kursf     LIKE bkpf-kursf,
         awkey     LIKE bkpf-awkey,
         tcode     LIKE bkpf-tcode,
         xblnr_alt LIKE bkpf-xblnr_alt,
         g_belnr   LIKE rseg-belnr, "GR Inv No
         g_gjahr   LIKE rseg-gjahr, "GR Inv Year

       END OF gt_bkpf.

TYPES:
  BEGIN OF t_bseg,
    bukrs TYPE bseg-bukrs,
    belnr TYPE bseg-belnr,
    gjahr TYPE bseg-gjahr,
    buzei TYPE bseg-buzei,
    shkzg TYPE bseg-shkzg,
    dmbtr TYPE bseg-dmbtr,
    TXGRP TYPE BSEG-TXGRP,           "CHANGED BY P.L .BHOI
    ktosl TYPE bseg-ktosl,
    anln1 TYPE bseg-anln1,
    anln2 TYPE bseg-anln2,
    hkont TYPE bseg-hkont,
    ebeln TYPE bseg-ebeln,
    ebelp TYPE bseg-ebelp,
  END OF t_bseg,
  tt_bseg TYPE STANDARD TABLE OF t_bseg.


DATA : BEGIN OF gt_ekbe OCCURS 0,
         ebeln TYPE ekbe-ebeln,
         ebelp TYPE ekbe-ebelp,
         gjahr TYPE ekbe-gjahr,
         belnr TYPE ekbe-belnr,
         xblnr TYPE ekbe-xblnr,
         lfgja TYPE ekbe-lfgja,
         lfbnr TYPE ekbe-lfbnr,
         lfpos TYPE ekbe-lfpos,
         lsmng TYPE ekbe-lsmng,
         awkey TYPE bkpf-awkey, "Benz
       END OF gt_ekbe.

DATA : gt_ekbe_imp LIKE gt_ekbe OCCURS 0 WITH HEADER LINE,
       gt_bkpf_we  LIKE gt_bkpf OCCURS 0 WITH HEADER LINE,
       gt_bkpf_ses LIKE gt_bkpf OCCURS 0 WITH HEADER LINE,
       gt_bkpf_imp LIKE gt_bkpf OCCURS 0 WITH HEADER LINE.

DATA : BEGIN OF gt_rseg OCCURS 0,
         belnr      LIKE rseg-belnr,
         gjahr      LIKE rseg-gjahr,
         buzei      LIKE rseg-buzei,
         ebeln      LIKE rseg-ebeln,
         ebelp      LIKE rseg-ebelp,
         matnr      LIKE rseg-matnr,
         bukrs      LIKE rseg-bukrs,
         wrbtr      LIKE rseg-wrbtr,      " Amount in document currency  " Nakul N
         menge      LIKE rseg-menge,
         meins      LIKE rseg-meins,
         shkzg      LIKE rseg-shkzg,
         mwskz      LIKE rseg-mwskz,
         bklas      LIKE rseg-bklas,
         bnkan      LIKE rseg-bnkan,
         kschl      LIKE rseg-kschl, "Condition type in RSEG
         lfbnr      LIKE rseg-lfbnr, "Reference Document
         lfgja      LIKE rseg-lfgja,  " Benz
         lfpos      LIKE rseg-lfpos, "Reference Documenet item
         werks      LIKE rseg-werks,
         stunr      LIKE rseg-stunr,
         exkbe      LIKE rseg-exkbe,
         pstyp      LIKE rseg-pstyp, " Item category to check for SES " Benz
         xekbz      LIKE rseg-xekbz, " Delivery Costs Indicator       " Benz
         belnr1     LIKE bkpf-belnr,
         lifnr      LIKE rbkp-lifnr,
         blart      LIKE rbkp-blart,
         name1      LIKE lfa1-name1,
         regio      LIKE lfa1-regio,
         ort01      LIKE lfa1-ort01,
         land1      LIKE lfa1-land1, "lifnr name1 regio ort01 land1
         bukrs1     LIKE bkpf-bukrs,
         budat      LIKE bkpf-budat,
         gjahr1     LIKE bkpf-gjahr,
         gsber      LIKE bseg-gsber,
         count1(4)  TYPE n,
         mtart      LIKE mara-mtart,
         matkl      LIKE mara-matkl,
         txgrp      LIKE bset-txgrp,
         awkey      LIKE bkpf-awkey,
         add        LIKE rseg-belnr,
         bseg_buzei TYPE bseg-buzei,

       END OF gt_rseg.

DATA : gt_rseg_v1  LIKE gt_rseg OCCURS 0 WITH HEADER LINE,
       gt_rseg_ses LIKE gt_rseg OCCURS 0 WITH HEADER LINE,
       gt_rseg_imp LIKE gt_rseg OCCURS 0 WITH HEADER LINE.

DATA : BEGIN OF gt_rbkp OCCURS 0,
         belnr   TYPE rbkp-belnr,
         gjahr   TYPE rbkp-gjahr,
         lifnr   TYPE rbkp-lifnr,
         blart   TYPE rbkp-blart,
         xrech   TYPE rbkp-xrech,
         stblg   TYPE rbkp-stblg,
         zuonr   TYPE rbkp-zuonr,
         bktxt   TYPE rbkp-bktxt,
         g_belnr TYPE rseg-belnr,
       END OF gt_rbkp.

DATA : BEGIN OF gt_lfa1 OCCURS 0,
         lifnr LIKE lfa1-lifnr,
         name1 LIKE lfa1-name1,
         regio LIKE lfa1-regio,
         ort01 LIKE lfa1-ort01,
         land1 LIKE lfa1-land1,
         adrnr LIKE lfa1-adrnr,
         stcd3 LIKE lfa1-stcd3,
       END OF gt_lfa1.

DATA : BEGIN OF gt_lfb1 OCCURS 0,
         lifnr LIKE lfb1-lifnr,
         akont LIKE lfb1-akont,
       END OF gt_lfb1.

DATA : BEGIN OF gt_bset OCCURS 0,
         bukrs     LIKE bset-bukrs,
         belnr     LIKE bset-belnr,
         gjahr     LIKE bset-gjahr,
         txgrp(4)  TYPE n, " like bset-txgrp, "GR Invoice item
         shkzg     LIKE bset-shkzg, "Debit/Credit Indicator
         mwskz     LIKE bset-mwskz, "Tax Code
         hwbas     LIKE bset-hwbas, "Tax Base amount in local currency
         hwste     LIKE bset-hwste, "Tax Amount in local currency
         ktosl     LIKE bset-ktosl, "Transaction key
         kschl     LIKE bset-kschl, "Condition Type
         kbetr     LIKE bset-kbetr, "Tax Rate
         buzei     TYPE bset-buzei,
         hkont     TYPE bset-hkont,

         knumh     TYPE bset-knumh,
         count     TYPE sy-tabix,
         ebeln     TYPE ebeln,
         ebelp     TYPE ebelp,
         awkey     TYPE bkpf-awkey,
         lfbnr     TYPE mseg-lfbnr,
         stunr     TYPE rseg-stunr,
         ser_tax   TYPE bset-hwste,
         e_ser_tax TYPE bset-hwste,
         s_ser_tax TYPE bset-hwste,
       END OF gt_bset.

DATA : BEGIN OF gt_makt OCCURS 0,
         matnr LIKE makt-matnr,
         maktx LIKE makt-maktx,
       END OF gt_makt.

DATA : BEGIN OF gt_j_1imovend OCCURS 0,
         lifnr     TYPE lifnr,                "Vendor
         j_1ilstno TYPE j_1ilstno,            "LST No (TIN No)
         j_1ipanno TYPE j_1ipanno,            "PAN No
         j_1isern  TYPE j_1isern,             "Service Tax Registration Number
         j_1icstno TYPE j_1icstno,            "CST No
         j_1iexcd  TYPE j_1iexcd,
         ven_class TYPE dd07t-domvalue_l,
       END OF gt_j_1imovend.


** Region Description
DATA  : BEGIN OF gt_t005u OCCURS 0,
          mandt TYPE t005u-mandt,
          spras TYPE t005u-spras,
          land1 TYPE t005u-land1,
          bland TYPE t005u-bland,
          bezei TYPE zgst_region-bezei.
DATA  : END OF gt_t005u.

DATA:BEGIN OF gt_ekko OCCURS 0,
       ebeln        TYPE ekko-ebeln,
       ekorg        TYPE ekko-ekorg,
       ekgrp        TYPE ekko-ekgrp,
       bsart        TYPE ekko-bsart,         " Purchasing Document Type
       aedat        TYPE ekko-aedat,
*       knumv        TYPE ekko-knumv,
       doc_typ_desc TYPE text30,
       revno        TYPE revno,
     END OF gt_ekko.

DATA: BEGIN OF gt_ekpo OCCURS 0,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        matnr TYPE ekpo-matnr,
        werks TYPE ekpo-werks,
        menge TYPE ekpo-menge,
        netpr TYPE ekpo-netpr,
        peinh TYPE ekpo-peinh,
        netwr TYPE ekpo-netwr,
        mwskz TYPE ekpo-mwskz,
        pstyp TYPE ekpo-pstyp,
        knttp TYPE ekpo-knttp,
      END OF gt_ekpo.

TYPES:
  BEGIN OF t_eket,
    ebeln TYPE eket-ebeln,
    ebelp TYPE eket-ebelp,
    etenr TYPE eket-etenr,
    eindt TYPE eket-eindt,
  END OF t_eket,
  tt_eket TYPE STANDARD TABLE OF t_eket.

TYPES:
  BEGIN OF t_qals,
    prueflos TYPE qals-prueflos,
    ebeln    TYPE qals-ebeln,
    ebelp    TYPE qals-ebelp,
    mjahr    TYPE qals-mjahr,
    mblnr    TYPE qals-mblnr,
    zeile    TYPE qals-zeile,
  END OF t_qals,
  tt_qals TYPE STANDARD TABLE OF t_qals.

TYPES:
  BEGIN OF t_qamb,
    prueflos TYPE qamb-prueflos,
    mblnr    TYPE qamb-mblnr,
    mjahr    TYPE qamb-mjahr,
    zeile    TYPE qamb-zeile,
  END OF t_qamb,
  tt_qamb TYPE STANDARD TABLE OF t_qamb.

TYPES:
  BEGIN OF t_mseg,
    mblnr TYPE mseg-mblnr,
    mjahr TYPE mseg-mjahr,
    zeile TYPE mseg-zeile,
    bwart TYPE mseg-bwart,
    lgort TYPE mseg-lgort,
    insmk TYPE mseg-insmk,
    ebeln TYPE mseg-ebeln,
    ebelp TYPE mseg-ebelp,
    menge TYPE mseg-menge,
    lsmng TYPE mseg-lsmng,
  END OF t_mseg,
  tt_mseg TYPE STANDARD TABLE OF t_mseg.

DATA: BEGIN OF gt_ekkn OCCURS 0,
        ebeln TYPE ekkn-ebeln,
        ebelp TYPE ekkn-ebelp,
        anln1 TYPE ekkn-anln1,
        anln2 TYPE ekkn-anln2,
        sakto TYPE ekkn-sakto,
      END OF gt_ekkn.

DATA: BEGIN OF gt_anla OCCURS 0,
        anln1 TYPE anla-anln1,
        anln2 TYPE anla-anln2,
        invnr TYPE anla-invnr,
        txt50 TYPE anla-txt50,
      END OF gt_anla.

DATA : BEGIN OF gt_bset1 OCCURS 0,
         count     TYPE sy-tabix,
         bukrs     LIKE bset-bukrs,
         belnr     LIKE bset-belnr,
         gjahr     LIKE bset-gjahr,
         txgrp(4)  TYPE n, " like bset-txgrp, "GR Invoice item
         shkzg     LIKE bset-shkzg, "Debit/Credit Indicator
         mwskz     LIKE bset-mwskz, "Tax Code
         hwbas     LIKE bset-hwbas, "Tax Base amount in local currency
         hwste     LIKE bset-hwste, "Tax Amount in local currency
         ktosl     LIKE bset-ktosl, "Transaction key
         kschl     LIKE bset-kschl, "Condition Type
         kbetr     LIKE bset-kbetr, "Tax Rate
         ebeln     TYPE ebeln,
         ebelp     TYPE ebelp,
         awkey     TYPE bkpf-awkey,
         buzei     TYPE bset-buzei,
         hkont     TYPE bset-hkont,
         knumh     TYPE bset-knumh,
         lfbnr     TYPE mseg-lfbnr,
         stunr     TYPE rseg-stunr,
         ser_tax   TYPE bset-hwste,
         e_ser_tax TYPE bset-hwste,
         s_ser_tax TYPE bset-hwste,
         values    TYPE string,
       END OF gt_bset1.

DATA : BEGIN OF gt_rseg1 OCCURS 0,
         ebeln  LIKE rseg-ebeln,
         ebelp  LIKE rseg-ebelp,
         belnr  LIKE rseg-belnr,
         gjahr  LIKE rseg-gjahr,
         buzei  LIKE rseg-buzei,
         matnr  LIKE rseg-matnr,
         bukrs  LIKE rseg-bukrs,
         wrbtr  LIKE rseg-wrbtr,
         shkzg  LIKE rseg-shkzg,
         mwskz  LIKE rseg-mwskz,
         kschl  LIKE rseg-kschl, "Condition type in RSEG
         lfpos  LIKE rseg-lfpos, "Reference Documenet item
         lifnr  LIKE rbkp-lifnr,
         name1  LIKE lfa1-name1,
         bukrs1 LIKE bkpf-bukrs,
         belnr1 LIKE bkpf-belnr,
         gjahr1 LIKE bkpf-gjahr,
       END OF gt_rseg1.

DATA : BEGIN OF gt_with_item OCCURS 0,
         bukrs      TYPE with_item-bukrs,
         belnr      TYPE with_item-belnr,
         gjahr      TYPE with_item-gjahr,
         wt_withcd  TYPE with_item-wt_withcd,
         wt_qbshb   TYPE with_item-wt_qbshb,     "Withholding tax amount in document currency
         wt_opowtpd TYPE with_item-wt_opowtpd,   "Indicator: Entry posted as a debit/credit
       END OF gt_with_item.

TYPES:
  BEGIN OF t_adrc,
    addrnumber TYPE adrc-addrnumber,
    name1      TYPE adrc-name1,
    city2      TYPE adrc-city2,
    post_code1 TYPE adrc-post_code1,
    street     TYPE adrc-street,
    str_suppl3 TYPE adrc-str_suppl3,
    location   TYPE adrc-location,
    country    TYPE adrc-country,
  END OF t_adrc,
  tt_adrc TYPE STANDARD TABLE OF t_adrc.

TYPES:
  BEGIN OF t_dd07t,
    valpos     TYPE dd07t-valpos,
    ddtext     TYPE dd07t-ddtext,
    domvalue_l TYPE dd07t-domvalue_l,
  END OF t_dd07t,
  tt_dd07t TYPE STANDARD TABLE OF t_dd07t.


TYPES:
  BEGIN OF t_skat,
    saknr TYPE skat-saknr,
    txt20 TYPE skat-txt20,
  END OF t_skat,
  tt_skat TYPE STANDARD TABLE OF t_skat.

TYPES:
  BEGIN OF t_zgst_region,
    gst_region TYPE zgst_region-gst_region,
    bezei      TYPE zgst_region-bezei,
  END OF t_zgst_region,
  tt_zgst_region TYPE STANDARD TABLE OF t_zgst_region.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    steuc TYPE marc-steuc,
  END OF t_marc,
  tt_marc TYPE STANDARD TABLE OF t_marc.

TYPES:
  BEGIN OF t_t007s,
    mwskz TYPE t007s-mwskz,
    text1 TYPE t007s-text1,
  END OF t_t007s,
  tt_t007s TYPE STANDARD TABLE OF t_t007s.

TYPES:
  BEGIN OF t_t163y,
    pstyp TYPE t163y-pstyp,
    epstp TYPE t163y-epstp,
  END OF t_t163y,
  tt_t163y TYPE STANDARD TABLE OF t_t163y.


DATA:
  BEGIN OF gt_final OCCURS 0,
    ekorg            TYPE ekko-ekorg,  "" ** PURCHASE_ORG
    lifnr            TYPE lfa1-lifnr,  "" ** Vendor
    name1            TYPE lfa1-name1,  "" ** Vendor Name
    address          TYPE string,      "" ** Address
    stcd3            TYPE lfa1-stcd3,  "" ** GSTIN
    gst_txt          TYPE char30,            "Vendor GST
    gst_region       TYPE zgst_region-gst_region,  "State Code
    bezei            TYPE t005u-bezei, "" ** State
    xblnr_alt        TYPE bkpf-xblnr_alt, "" **ODN
    inv_no           TYPE bkpf-xblnr,  "" ** Inv/BILL_NO
    inv_dt           TYPE string,"bkpf-bldat,  "" ** INV DATE TIME
    ebeln            TYPE ekbe-ebeln,  "" ** PO No.
    aedat            TYPE string,"ekko-aedat,
    ebelp            TYPE ekbe-ebelp,  "" ** PO Line item
    pstyp            TYPE t163y-epstp, "ekpo-pstyp,
    knttp            TYPE ekpo-knttp,
    lfbnr            TYPE ekbe-lfbnr,  "" ** Migo number  GRN NO
    budat            TYPE string,"bkpf-budat,  "" ** Migo date
    belnr            TYPE bkpf-belnr,  "" ** Fi document No. (Migo Posting)
    grn_amt          TYPE bseg-dmbtr,  "" ** FI Doc Amt.(GRN)
    zuonr            TYPE rbkp-zuonr,
    bktxt            TYPE rbkp-bktxt,
    awkey            TYPE bkpf-awkey,  "" ** BILL_BOOKING_NO
    miro_ac_doc      TYPE bkpf-belnr,  "" ** MIRO A/c Doc No
    blart            TYPE bkpf-blart,  "" ** FI Doc Type
    bill_dt          TYPE string,"bkpf-budat,  "" ** Bill Booking Date
    hkont            TYPE bseg-hkont,  "" ** GR Legder Code
    txt20            TYPE skat-txt20,  "" ** GR Ledger Description
    steuc            TYPE marc-steuc,  "" ** HSN/SAC Code
    matnr            TYPE rseg-matnr,  "" ** Material
    long_txt         TYPE char100,     "" **Long Text for Material
    mtart            TYPE mara-mtart,  "" ** Material Type
    eindt            TYPE string,"eket-eindt,  "" ** Delivery Date
    po_qty           TYPE ekpo-menge,  "" ** PO Qty
    lsmng            TYPE mseg-lsmng,
    menge            TYPE rseg-menge,  "" ** Quantity
    acc_qty          TYPE mseg-menge,  "" ** Accept Qty
    rej_qty          TYPE mseg-menge,  "" ** Rej Qty
    scp_qty          TYPE mseg-menge,  "" ** Scrap Qty
    rew_qty          TYPE mseg-menge,  "" ** Rewrk Qty
    waers            TYPE bkpf-waers,  "" ** Document Currency
    kursf            TYPE bkpf-kursf,  "" ** Exchange Rate
    rate             TYPE kwert,       "" ** Rate Per Qty
    wrbtr            TYPE rseg-wrbtr,  "" ** Amount in document currency   " Nakul N 27.03.2018
    basic            TYPE rseg-wrbtr,  "" ** BASIC(DC)
    basic_lc         TYPE rseg-wrbtr,  "" ** BASIC(LC)
    packing_lc       TYPE rseg-wrbtr,  "" ** PACKING(LC)
    insp             TYPE rseg-wrbtr,  "" ** Inspection Charges
    set_val          TYPE rseg-wrbtr,  "" ** Setting Charges
    freight_lc       TYPE bseg-wrbtr,  "" ** Freight (LC)
    ins              TYPE rseg-wrbtr,  "" ** Insurance Charges
    oth_ch           TYPE rseg-wrbtr,  "" ** Other Charges
    dev_ch           TYPE rseg-wrbtr,  "" ** Devlopment Charges

    AMORT_VAL        TYPE rseg-wrbtr,  "" ** AMORTISED VALUE             " ADDEDED BY PARESH BHOI

    net_total_lc     TYPE kwert,       "" ** Assessable Val GST
    mwskz            TYPE rseg-mwskz,  "" ** Tax Code
    text1            TYPE t007s-text1, "" ** Tax Code Description
    bed              TYPE kwert,       "" ** BED
    aed              TYPE kwert,       "" ** AED
    vat_tax          TYPE kwert,       "" ** VAT TAX
    cst_tax          TYPE kwert,       "" ** CST TAX
    ser_val_dr       TYPE kwert,       "" ** Service Tax Value Credit
    sbc_dr           TYPE kwert,       "" ** Swach Bharat Cess Credit
    kkc_dr           TYPE kwert,       "" ** Krishi Kalyan Cess Credit
    cgst             TYPE kbetr,       "" ** CGST
    cgst_tax         TYPE kwert VALUE 0,       "" ** CGST TAX
    sgst             TYPE kbetr,       "" ** SGST
    sgst_tax         TYPE kwert,       "" ** SGST TAX
    igst             TYPE kbetr,       "" ** IGST
    igst_tax         TYPE kwert,       "" ** IGST TAX
    com_p            TYPE kwert,       "" ** Comp Cess %
    com_v            TYPE kwert,       "" ** Comp Cess Val
    gst_amt          TYPE kwert,       "" ** Total GST Amt
    basic_cust       TYPE wrbtr,       "" ** Basic Customs
    cvd              TYPE wrbtr,       "" ** CVD
    cust_cess        TYPE wrbtr,       "" ** Customs Ecess
    cust_hcess       TYPE wrbtr,       "" ** Customs HEcess
    add_cvd          TYPE wrbtr,       "" ** ADD CVD
    tot_tax          TYPE wrbtr,       "" ** Total Tax Amt
    gross_tot_lc     TYPE wrbtr,       "" ** GROSS_TOTAL (LC)
    anln1            TYPE ekkn-anln1,  ""  ** Main Asset Number
    anln2            TYPE ekkn-anln2,  ""  ** Asset Subnumber
    invnr            TYPE anla-invnr,  ""  ** Asset Inventory No.
    txt50            TYPE anla-txt50,  ""  ** Asset description
    sakto            TYPE ekkn-sakto,  ""  ** Asset Reconcilation
    ass_amt          TYPE bseg-dmbtr,  ""  ** Asset Gross Amount
    zseries          TYPE mara-zseries,      "Series
    zsize            TYPE mara-zsize,        "Size
    brand            TYPE mara-brand,        "Brand
    moc              TYPE mara-moc,          "MOC
    type             TYPE mara-type,         "Type
    kwert            TYPE kwert,

    akont            TYPE lfb1-akont,  ""  ** Reconciliation Account in General Ledger
    maktx            TYPE makt-maktx,  "" ** Material Description

    werks            TYPE rseg-werks,  "" ** PLANT_CODE
    ecs              TYPE kwert,       "" ** Edu.Excise
    hcess            TYPE kwert,       "" ** Higher Edu.Excise
    ecs_dr           TYPE kwert,       "" ** Edu.Excise Credit
    hcess_dr         TYPE kwert,       "" ** Higher Edu.Excise Credit
    vat              TYPE kbetr,       "" ** VAT
    cst              TYPE kbetr,       "" ** CST
    ecs_cr           TYPE kwert,       "" ** Edu.Excise Debit
    hcess_cr         TYPE kwert,       "" ** Higher Edu.Excise Debit
    ser_val_cr       TYPE kwert,       "" ** Service Tax Value Debit
    sbc_cr           TYPE kwert,       "" ** Swach Bharat Cess Debit
    kkc_cr           TYPE kwert,       "" ** Krishi Kalyan Cess Debit
    packing          TYPE rseg-wrbtr,  "" ** PACKING(DC)
    discount         TYPE rseg-wrbtr,  "" ** DISCOUNT(DC)
    discount_lc      TYPE rseg-wrbtr,  "" ** DISCOUNT(LC)
    freight          TYPE bseg-wrbtr,  "" ** Freight (DC)
    lbt              TYPE wrbtr,       "" ** CESS/LBT
    forwarding       TYPE wrbtr,       "" ** FORWARDING (DC)
    forwarding_lc    TYPE wrbtr,       "" ** FORWARDING (LC)
    clearing         TYPE wrbtr,       "" ** CLEARING (DC)
    clearing_lc      TYPE wrbtr,       "" ** CLEARING (LC)
    tds_dc           TYPE wt_bs1,      "" ** TDS (DC)
    tds_lc           TYPE wt_bs1,      "" ** TDS (LC)
    tds_flag         TYPE c,           "" ** TDS FLAG
    gross_tot        TYPE wrbtr,       "" ** GROSS_TOTAL (DC)
    gross_tot_tds    TYPE wrbtr,       ""  ** GROSS TOTAL WITHOUT TDS (DC)
    gross_tot_lc_tds TYPE wrbtr,       ""  ** GROSS TOTAL WITHOUT TDS (LC)
    tin_no           TYPE j_1imovend-j_1icstno, "" **TIN_NO
    lst_no           TYPE j_1imovend-j_1ilstno, "" **LST_NO
    tcode            TYPE bkpf-tcode,  "" ** Transaction Code
    net_total        TYPE kwert,       "" ** NET TOTAL (DC)
    ref_date         TYPE string,      " Abhishek Pisolkar (27.03.2018)
****    sgst_ns_tax      TYPE kwert,       "" ** SGST TAX Non Setupable
****    sgst_ns          TYPE kbetr,       "" ** SGST Non Setupable
****    cgst_ns_tax      TYPE kwert,       "" ** CGST TAX Non Setupable
****    cgst_ns          TYPE kbetr,       "" ** CGST Non Setupable
****    igst_ns_tax      TYPE kwert,       "" ** IGST TAX Non Setupable
****    igst_ns          TYPE kbetr,       "" ** IGST Non Setupable
****    sgst_rc_tax      TYPE kwert,       "" ** SGST TAX RCM
****    sgst_rc          TYPE kbetr,       "" ** SGST Non RCM
****    cgst_rc_tax      TYPE kwert,       "" ** CGST TAX RCM
****    cgst_rc          TYPE kbetr,       "" ** CGST Non RCM
****    sgst_nrc_tax     TYPE kwert,       "" ** SGST TAX RCM Non Setupable
****    sgst_nrc         TYPE kbetr,       "" ** SGST Non RCM Non Setupable
****    cgst_nrc_tax     TYPE kwert,       "" ** CGST TAX RCM Non Setupable
****    cgst_nrc         TYPE kbetr,       "" ** CGST Non RCM Non Setupable
** GST Taxation Pralhad Desai 19.07.2017 EOC
* B.O.C Bency 06.12.2016
***    sertaxcess_cr    TYPE kwert,       "" ** Serv tax cess credit
***    hsertaxcess_cr   TYPE kwert,       "" ** Higher Serv tax cess credit
***    sertaxcess_dr    TYPE kwert,       "" ** Serv tax cess debit
***    hsertaxcess_dr   TYPE kwert,       "" ** Higher Serv tax cess debit
**** E.O.C Bency 06.12.2016
***    igst_tax_im      TYPE kwert,       "" ** IGST TAX IMP
***    igst_im          TYPE kbetr,       "" ** IGST IMP

  END OF gt_final.
*----------------------------------For File Download----------------------------------------

DATA:
  BEGIN OF it_final OCCURS 0,
    ekorg            TYPE ekko-ekorg,  "" ** PURCHASE_ORG
    lifnr            TYPE lfa1-lifnr,  "" ** Vendor
    name1            TYPE lfa1-name1,  "" ** Vendor Name
    address          TYPE string,      "" ** Address
    stcd3            TYPE lfa1-stcd3,  "" ** GSTIN
    gst_txt          TYPE char30,            "Vendor GST
    gst_region       TYPE zgst_region-gst_region,  "State Code
    bezei            TYPE t005u-bezei, "" ** State
    xblnr_alt        TYPE bkpf-xblnr_alt, "" **ODN
    inv_no           TYPE bkpf-xblnr,  "" ** Inv/BILL_NO
    inv_dt           TYPE string,"char10, "bkpf-bldat,  "" ** INV DATE TIME
    ebeln            TYPE ekbe-ebeln,  "" ** PO No.
    aedat            TYPE string,"char10, "ekko-aedat,
    ebelp            TYPE ekbe-ebelp,  "" ** PO Line item
    pstyp            TYPE t163y-epstp, "ekpo-pstyp,
    knttp            TYPE ekpo-knttp,
    lfbnr            TYPE ekbe-lfbnr,  "" ** Migo number
    budat            TYPE string,"char10, "bkpf-budat,  "" ** Migo date
    belnr            TYPE bkpf-belnr,  "" ** Fi document No. (Migo Posting)
    grn_amt          TYPE bseg-dmbtr,  "" ** FI Doc Amt.(GRN)
    zuonr            TYPE rbkp-zuonr,
    bktxt            TYPE rbkp-bktxt,
    awkey            TYPE bkpf-awkey,  "" ** BILL_BOOKING_NO
    miro_ac_doc      TYPE bkpf-belnr,  "" ** MIRO A/c Doc No
    blart            TYPE bkpf-blart,  "" ** FI Doc Type
    bill_dt          TYPE string,"char10, "bkpf-budat,  "" ** Bill Booking Date
    hkont            TYPE bseg-hkont,  "" ** GR Legder Code
    txt20            TYPE skat-txt20,  "" ** GR Ledger Description
    steuc            TYPE marc-steuc,  "" ** HSN/SAC Code
    matnr            TYPE rseg-matnr,  "" ** Material
    long_txt         TYPE char100,     "" **Long Text for Material
    mtart            TYPE mara-mtart,  "" ** Material Type
    eindt            TYPE string,"char10, "eket-eindt,  "" ** Delivery Date
    po_qty           TYPE ekpo-menge,  "" ** PO Qty
    lsmng            TYPE mseg-lsmng,
    menge            TYPE string,"rseg-menge,  "" ** Quantity
    acc_qty          TYPE string,"mseg-menge,  "" ** Accept Qty
    rej_qty          TYPE string,"mseg-menge,  "" ** Rej Qty
    scp_qty          TYPE string,"mseg-menge,  "" ** Scrap Qty
    rew_qty          TYPE string,"mseg-menge,  "" ** Rewrk Qty
    waers            TYPE bkpf-waers,  "" ** Document Currency
    kursf            TYPE bkpf-kursf,  "" ** Exchange Rate
    rate             TYPE kwert,       "" ** Rate Per Qty
    basic            TYPE string,"rseg-wrbtr,  "" ** BASIC(DC)
    basic_lc         TYPE string,"rseg-wrbtr,  "" ** BASIC(LC)
    packing_lc       TYPE string,"rseg-wrbtr,  "" ** PACKING(LC)
    insp             TYPE string,"rseg-wrbtr,  "" ** Inspection Charges
    set_val          TYPE string,"rseg-wrbtr,  "" ** Setting Charges
    freight_lc       TYPE string,"bseg-wrbtr,  "" ** Freight (LC)
    ins              TYPE string,"rseg-wrbtr,  "" ** Insurance Charges
    oth_ch           TYPE string,"rseg-wrbtr,  "" ** Other Charges
    dev_ch           TYPE string,"rseg-wrbtr,  "" ** Devlopment Charges
    net_total_lc     TYPE string,"kwert,       "" ** Assessable Val GST

    mwskz            TYPE rseg-mwskz,  "" ** Tax Code
    text1            TYPE t007s-text1, "" ** Tax Code Description
    bed              TYPE string,"kwert,       "" ** BED
    aed              TYPE string,"kwert,       "" ** AED
    vat              TYPE string,"kbetr,       "" ** VAT
    vat_tax          TYPE string,"kwert,       "" ** VAT TAX
    cst              TYPE string,"kbetr,       "" ** CST
    cst_tax          TYPE string,"kwert,       "" ** CST TAX
    ser_val_dr       TYPE string,"kwert,       "" ** Service Tax Value Credit
    sbc_dr           TYPE string,"kwert,       "" ** Swach Bharat Cess Credit
    kkc_dr           TYPE string,"kwert,       "" ** Krishi Kalyan Cess Credit
    basic_cust       TYPE string,"wrbtr,       "" ** Basic Customs
    cvd              TYPE string,"wrbtr,       "" ** CVD
    cust_cess        TYPE string,"wrbtr,       "" ** Customs Ecess
    cust_hcess       TYPE string,"wrbtr,       "" ** Customs HEcess
    wrbtr            TYPE string,"rseg-wrbtr,  "" ** Social Welfare   "" Nakul N
    add_cvd          TYPE string,"wrbtr,       "" ** ADD CVD
    cgst             TYPE string,"kbetr,       "" ** CGST
    cgst_tax         TYPE string,"kwert,       "" ** CGST TAX
    sgst             TYPE string,"kbetr,       "" ** SGST
    sgst_tax         TYPE string,"kwert,       "" ** SGST TAX
    igst             TYPE string,"kbetr,       "" ** IGST
    igst_tax         TYPE string,"kwert,       "" ** IGST TAX
    com_p            TYPE string,"kwert,       "" ** Comp Cess %
    com_v            TYPE string,"kwert,       "" ** Comp Cess Val
    gst_amt          TYPE string,"kwert,       "" ** Total GST Amt
    tot_tax          TYPE string,"wrbtr,       "" ** Total Tax Amt
    gross_tot        TYPE string,"wrbtr,       "" ** GROSS_TOTAL (DC)
    gross_tot_lc     TYPE string,"wrbtr,       "" ** GROSS_TOTAL (LC)
    anln1            TYPE ekkn-anln1,  ""  ** Main Asset Number
    anln2            TYPE ekkn-anln2,  ""  ** Asset Subnumber
    invnr            TYPE anla-invnr,  ""  ** Asset Inventory No.
    txt50            TYPE anla-txt50,  ""  ** Asset description
    sakto            TYPE ekkn-sakto,  ""  ** Asset Reconcilation
    ass_amt          TYPE string,"bseg-dmbtr,  ""  ** Asset Gross Amount
    moc              TYPE mara-moc,          "MOC
    brand            TYPE mara-brand,        "Brand
    zsize            TYPE mara-zsize,        "Size
    zseries          TYPE mara-zseries,      "Series
    type             TYPE mara-type,         "Type

    ref_date         TYPE string,      " Abhishek Pisolkar (27.03.2018)
    AMORT_VAL        TYPE  string,  "" ** AMORTISED VALUE             " ADDEDED BY PARESH BHOI
  END OF it_final.

******************* cgst & sgst tax ******************
  TYPES : BEGIN OF ty_tax,
    belnr TYPE bseg-belnr,
    cgst TYPE kwert,
    sgst TYPE kwert,
    igst_tax TYPE kwert,
    bed TYPE kwert,
    aed TYPE kwert,
    vat_tax TYPE kwert,
    ser_val_dr TYPE kwert,
    sbc_dr TYPE kwert,
    kkc_dr TYPE kwert,
    END OF ty_tax.
  data : lt_tax TYPE TABLE OF ty_tax,
         ls_tax TYPE ty_tax.
***************************************************
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF t_mat_mast,
    matnr   TYPE mara-matnr,
    mtart   TYPE mara-mtart,
    zseries TYPE mara-zseries,
    zsize   TYPE mara-zsize,
    brand   TYPE mara-brand,
    moc     TYPE mara-moc,
    type    TYPE mara-type,
  END OF t_mat_mast,
  tt_mat_mast TYPE STANDARD TABLE OF t_mat_mast.

DATA : gt_ekpo1 LIKE gt_ekpo OCCURS 0 WITH HEADER LINE.

DATA : gt_listheader   TYPE slis_t_listheader   WITH HEADER LINE,
       gt_fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gt_event        TYPE slis_t_event        WITH HEADER LINE,
       gt_layout       TYPE slis_layout_alv,
       gt_sort         TYPE slis_t_sortinfo_alv WITH HEADER LINE.



******************************************************************************

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : "s_bukrs FOR bkpf-bukrs OBLIGATORY NO INTERVALS NO-EXTENSION,
                 s_ebeln FOR rseg-ebeln,
                 s_budat FOR bkpf-budat OBLIGATORY,
                 s_gjahr FOR bkpf-gjahr , " OBLIGATORY DEFAULT '2017',
                 s_werks FOR rseg-werks OBLIGATORY DEFAULT 'PL01'.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  'E:/delval/temp184'.
SELECTION-SCREEN END OF BLOCK b5.
