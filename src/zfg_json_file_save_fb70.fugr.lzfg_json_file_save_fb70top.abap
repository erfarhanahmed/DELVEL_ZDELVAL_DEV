FUNCTION-POOL zfg_json_file_save_fb70.          "MESSAGE-ID ..

* INCLUDE LZFG_JSON_CONVERSIOND...           " Local class definition


*--Data declaration for cancel irn doc.


TYPES : BEGIN OF lty_cancel,
          irn(65)    TYPE c,
          cnlrsn(1)  TYPE c,
          cnlrem(50) TYPE c,
        END OF lty_cancel,


        BEGIN OF lty_marc,
          matnr TYPE marc-matnr,
          steuc TYPE marc-steuc,
        END OF lty_marc,

        BEGIN OF lty_t052u,
          zterm TYPE t052u-zterm,
          text1 TYPE t052u-text1,
        END OF lty_t052u.

"=============================================Table Declaration============================="
TYPES : BEGIN OF ty_bkpf ,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          blart TYPE bkpf-blart,
          budat TYPE bkpf-budat,
          xblnr TYPE bkpf-xblnr,
          waers TYPE bkpf-waers,
        END OF ty_bkpf,

        BEGIN OF ty_bkpf_temp ,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          blart TYPE bkpf-blart,
          budat TYPE bkpf-budat,
          xblnr TYPE bkpf-belnr,
          waers TYPE bkpf-waers,
        END OF ty_bkpf_temp,

        BEGIN OF ty_t001,
          bukrs TYPE bukrs,
          butxt TYPE butxt,
          land1 TYPE land1,
        END OF ty_t001.

TYPES : BEGIN OF ty_bseg,
          bukrs   TYPE bseg-bukrs,
          belnr   TYPE bseg-belnr,
          gjahr   TYPE bseg-gjahr,
          buzei   TYPE bseg-buzei,
          buzid   TYPE bseg-buzid,
          koart   TYPE bseg-koart,
          ktosl   TYPE bseg-ktosl,
          txgrp   TYPE bseg-txgrp,
          gsber   TYPE bseg-gsber,
          kunnr   TYPE bseg-kunnr,
          matnr   TYPE bseg-matnr,
          werks   TYPE bseg-werks,
          menge   TYPE bseg-menge,
          meins   TYPE bseg-meins,
          posn2   TYPE bseg-posn2,
          dmbtr   TYPE bseg-dmbtr,
          wrbtr   TYPE bseg-wrbtr,
          gvtyp   TYPE bseg-gvtyp,
          sgtxt   TYPE bseg-sgtxt,
          bupla   TYPE bseg-bupla,
          hsn_sac TYPE bseg-hsn_sac,
        END OF ty_bseg.


TYPES :  BEGIN OF ty_bseg_ref,
          bukrs   TYPE bseg-bukrs,
          belnr   TYPE bseg-belnr,
          gjahr   TYPE bseg-gjahr,
          buzei   TYPE bseg-buzei,
          zuonr   TYPE vbrk-vbeln,
          END OF ty_bseg_ref.

DATA : lt_bseg_ref TYPE TABLE OF ty_bseg_ref,
       ls_bseg_ref TYPE ty_bseg_ref.


TYPES :  BEGIN OF ty_vbrk_ref,
         vbeln TYPE vbrk-vbeln,
         fkdat TYPE vbrk-fkdat,
         END OF ty_vbrk_ref.

DATA : lt_vbrk_ref TYPE TABLE OF ty_vbrk_ref,
       ls_vbrk_ref TYPE ty_vbrk_ref.


TYPES : BEGIN OF ty_knvi,
        kunnr TYPE knvi-kunnr,
        aland TYPE knvi-aland,
        tatyp TYPE knvi-tatyp,
        taxkd TYPE knvi-taxkd,
        END OF ty_knvi.

DATA : lt_knvi TYPE STANDARD TABLE OF ty_knvi,
       ls_knvi TYPE ty_knvi.


TYPES : BEGIN OF ty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
        END OF ty_makt.

TYPES : BEGIN OF ty_marc ,
          matnr TYPE marc-matnr,
          steuc TYPE marc-steuc,
        END OF ty_marc.

TYPES : BEGIN OF ty_j_1bbranch,
          bukrs  TYPE j_1bbranch-bukrs,
          branch TYPE j_1bbranch-branch,
          gstin  TYPE j_1bbranch-gstin,
        END OF ty_j_1bbranch.

TYPES : BEGIN OF ty_t001w,
          j_1bbranch TYPE t001w-j_1bbranch,
          adrnr      TYPE t001w-adrnr,
        END OF ty_t001w.

TYPES : BEGIN OF ty_adrc,
          addrnumber TYPE adrc-addrnumber,
          name1      TYPE adrc-name1,
          str_suppl1 TYPE adrc-str_suppl1,
          str_suppl2 TYPE adrc-str_suppl2,
          mc_city1   TYPE adrc-mc_city1,
          post_code1 TYPE adrc-post_code1,
          region     TYPE adrc-region,
        END OF ty_adrc.

TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
          regio TYPE kna1-regio,
          adrnr TYPE kna1-adrnr,
          stcd3 TYPE kna1-stcd3,
          land1 TYPE kna1-land1,

        END OF ty_kna1.

TYPES : BEGIN OF ty_bset,
          txgrp TYPE txgrp,
          belnr TYPE belnr_d,
          gjahr TYPE gjahr,
          buzei TYPE buzei,
          hwste TYPE hwste,
          ktosl TYPE ktosl,
          kschl TYPE kschl,
          kbetr TYPE kbetr,
          hwbas TYPE hwbas,
          bukrs TYPE bukrs,
        END OF ty_bset.

TYPES: BEGIN OF ty_t005u,
         spras TYPE t005u-spras,
         land1 TYPE t005u-land1,
         bezei TYPE t005u-bezei,
         bland TYPE t005u-bland,
       END OF ty_t005u.



TYPES : BEGIN OF trandtls,
          taxsch(10)   TYPE c,     "Required      "GST- Goods and Services Tax Scheme
          suptyp(10)   TYPE c,     "Required      "Type of Supply: B2B-Business to Business, SEZWP - SEZ with payment, SEZWOP - SEZ without payment,
          regrev(1)    TYPE c,                    "Y- whether the tax liability is payable under reverse charge
          ecmgstin(15) TYPE c,                    "GSTIN of e-Commerce operator
        END OF trandtls,

        BEGIN OF docdtls,
          ztyp(11) TYPE c,         "Required   "Document Type: INVOICE, CREDIT NOTE, DEBIT NOTE
          zno(16)  TYPE c,         "Required   "Document Number
          zdt(10)  TYPE c,         "Required   "Document Date
        END OF docdtls,


        BEGIN OF sellerdtls,
          gstin(15)  TYPE c,      "Required   "GSTIN of supplier
          lglnm(100) TYPE c,      "Required   "Legal Name
          trdnm(100) TYPE c,                  "Tradename
          addr1(100) TYPE c,      "Required   "Building/Flat num, Road/Street
          addr2(100) TYPE c,                  "Address 2 of the supplier (Floor num., Name of the premises/building)"
          zloc(50)    TYPE c,      "Required   "Location
          zpin(06)    TYPE c,      "Required   "Pincode
          zstate(50) TYPE c,      "Required   "State Name
          zph(10)     TYPE c,                  "Phone or Mobile num
          zem(100)   TYPE c,                  "Email-Id
        END OF sellerdtls,

        BEGIN OF buyerdtls,
          gstin(15)  TYPE c,  "Required       "GSTIN of buyer , URP if exporting
          lglnm(100) TYPE c,  "Required       "Legal Name
          trdnm(100) TYPE c,                  "Trade Name
          zpos(02)    TYPE c,  "Required       "State code of Place of supply. If POS lies outside the country, a the code shall be 96."
          addr1(100) TYPE c,  "Required       "Address 1 of the buyer. (Building/Flat num., Road/Street etc.)
          addr2(100) TYPE c,                  "Address 2 of the buyer.(Floor num., Name of the premises/ building)
          zloc(100)   TYPE c,  "Required       "Location
          zpin(06)    TYPE c,                  "Pincode
          zstate(50) TYPE c,                  "State Name
          zph(12)     TYPE c,                  "Phone or Mobile num
          zem(100)   TYPE c,                  "Email-Id
        END OF buyerdtls,

        BEGIN OF dispdtls,
          znm(60)    TYPE c,  "Required       "Name of the company from which the goods are dispatched
          addr1(100) TYPE c,  "Required       "Address 1 of the entity from which goods are dispatched.(Building/Flat num.Road/Street etc.)
          addr2(100) TYPE c,                  "Address 2 of the entity from which goods are dispatched. (Floor num., Name of the premises/building)"
          loc(100)   TYPE c,  "Required       "Location
          pin(06)    TYPE c,  "Required       "Pincode
          stcd(02)   TYPE c,  "Required       "State Code
        END OF dispdtls,

        BEGIN OF shipdtls,
          gstin(15)  TYPE c,                  "GSTIN of entity to whom goods are shipped
          lglnm(60)  TYPE c,  "Required       "Legal Name
          trdnm(60)  TYPE c,                  "Trade Name
          addr1(100) TYPE c,  "Required       "Address1 of the entity to whom the supplies are shipped to. (Building/Flat num., Road/Street etc.)
          addr2(100) TYPE c,                  "Address 2 of the entity to whom the supplies are shipped to. (Floor num., Name of the premises/building)."
          loc(100)   TYPE c,  "Required       "Place (City,Town,Village) entity to whom the supplies are shipped to.
          pin(06)    TYPE c,  "Required       "Pincode
          stcd(02)   TYPE c,  "Required       "State Code to which supplies are shipped to."
        END OF shipdtls,

        BEGIN OF valdtls,
          assval(15)      TYPE p DECIMALS 2,          "Required     "Total Assessable value of all items
          cgstval(13)     TYPE p DECIMALS 2,                        "Total CGST value of all items
          sgstval(13)     TYPE p DECIMALS 2,                        "Total SGST value of all items
          igstval(13)     TYPE p DECIMALS 2,                        "Total IGST value of all items"
          zcesval(13)     TYPE p DECIMALS 2,                        "Total CESS value of all items
          stcesval(13)    TYPE p DECIMALS 2,                        "Total State CESS value of all items
          rndoffamt(6)    TYPE p DECIMALS 2,                        "Rounded off amount
          ztotinvval(15)  TYPE p DECIMALS 2,          "Required     "Final Invoice value
          totinvvalfc(15) TYPE p DECIMALS 2,                        "Final Invoice value in Additional Currency
        END OF valdtls,

        BEGIN OF paydtls,
          znm(100)      TYPE c,                 "Payee Name
          accdet(18)    TYPE c,                 "Bank account number of payee
          modes(18)     TYPE c,                 "Mode of Payment: Cash, Credit, Direct Transfer
          fininsbr(11)  TYPE c,                 "Branch or IFSC code
          payterm(100)  TYPE c,                 "Terms of Payment
          payinstr(100) TYPE c,                 "Payment Instruction
          crtrn(100)    TYPE c,                 "Credit Transfer
          dirdr(100)    TYPE c,                 "Direct Debit
          crday(4)      TYPE n,                 "Credit Days
          paidamt(12)   TYPE p DECIMALS 2,      "The sum of amount which have been paid in advance.
          paymtdue(12)  TYPE p DECIMALS 2,      "Outstanding amount that is required to be paid."
        END OF paydtls,

        BEGIN OF precdocdtls,
          invno(16)    TYPE c,      "Required   "Reference of original invoice, if any.
          invdt(10)    TYPE c,      "Required   "Date of preceding invoice
          othrefno(20) TYPE c,                  "Other Reference
        END OF precdocdtls,

        BEGIN OF contrdtls,
          recadvrefr(20) TYPE c,                "Receipt Advice num."
          recadvdt(10)   TYPE c,                "Date of receipt advice"
          tendrefr(20)   TYPE c,                "Lot/Batch Reference num."
          contrrefr(20)  TYPE c,                "Contract Reference Number
          extrefr(20)    TYPE c,                "Any other reference
          projrefr(20)   TYPE c,                "Project Reference Number
          porefr(16)     TYPE c,                "Vendor PO Reference Number
          porefdt(10)    TYPE c,                "Vendor PO Reference date
        END OF contrdtls.

DATA:
  lt_precdocdtls TYPE STANDARD TABLE OF precdocdtls,
  ls_precdocdtls TYPE precdocdtls,
  lt_contrdtls   TYPE STANDARD TABLE OF contrdtls,
  ls_contrdtls   TYPE contrdtls.


TYPES : BEGIN OF docperddtls,
        invstdt(10)  TYPE c,     "required    "Invoice Period Start Date
        invenddt(10) TYPE c,     "required    "Invoice Period End Date
        END OF docperddtls.


TYPES :
  BEGIN OF refdtls,
    invrm(100)   TYPE c,                  "Remarks/Note
    docperddtls  TYPE docperddtls,
    precdocdtls  LIKE lt_precdocdtls,
    contrdtls    LIKE lt_contrdtls,
  END OF refdtls,

  BEGIN OF expdtls,
    shipbno(20) TYPE c,                   "Shipping Bill num."
    shipbdt(10) TYPE c,                   "Shipping Bill Date
    port(10)    TYPE c,                   "Port Code
    refclm(1)   TYPE c,                   "Options for supplier for refund. Y/N
    forcur(16)  TYPE c,                   "Additional Currency Code
    cntcode(2)  TYPE c,                   "Country Code
  END OF expdtls,

  BEGIN OF addldocdtls,
    url(100)   TYPE c,                    "Supporting document URL
    docs(1000) TYPE c,                    "Supporting document in Base64 Format
    info(1000) TYPE c,                    "Any additional information
  END OF addldocdtls,

  BEGIN OF ewbdtls,
    transid(15)    TYPE c,
    transname(100) TYPE c,
    transmode(1)   TYPE c,
    distance(4)    TYPE c,
    transdocno(15) TYPE c,
    transdocdt(10) TYPE c,
    vehno(20)      TYPE c,
    vehtype(1)     TYPE c,
  END OF ewbdtls,

  BEGIN OF bchdtls,
    znm(20)    TYPE c,     "Required         "Batch name
    zexpdt(10) TYPE c,                       "Batch Expiry Date
    wrdt(10)   TYPE c,                       "Warranty Date
  END OF bchdtls,

  BEGIN OF attribdtls,
    znm(100)  TYPE c,                    "Attribute details of the item
    zvalu(100) TYPE c,                    "Attribute value of the item
  END OF attribdtls.

DATA : lt_attribdtls TYPE STANDARD TABLE OF attribdtls,
       ls_attribdtls TYPE attribdtls.
TYPES :
  BEGIN OF itemlist,
    zslno(06)              TYPE c,                  "Required       "Serial num. of Item
    prddesc(300)           TYPE c,                                  "Product Description
    isservc(1)             TYPE c,                  "Required       "Specify whether the supply is service or not. Specify Y-for Service"
    hsncd(08)              TYPE c,                  "Required       "HSN Code
    barcde(30)             TYPE c,                                  "Bar Code
    qnty               TYPE c LENGTH 20,                                  "Quantity Qty->qnty
    freeqty            TYPE c LENGTH 20,                                "Free Quantity
    units(08)              TYPE c,                                  "Unit
    unitprice(13)          TYPE p DECIMALS 2,      "Required        "Unit Price - Rate
    totamt(13)             TYPE p DECIMALS 2,      "Required        "Gross Amount Amount (Unit Price * Quantity)"
    discount(12)           TYPE p DECIMALS 2,                       "Discount
    pretaxval(15)          TYPE p DECIMALS 2,                       "Pre tax value
    assamt(15)             TYPE p DECIMALS 2,                       "Taxable Value (Total Amount -Discount)
    gstrt(6)               TYPE p DECIMALS 3,       "Required       "The GST rate, represented as percentage that applies to the invoiced item. It will IGST rate only
    igstamt(13)            TYPE p DECIMALS 2,                       "Amount of IGST payable
    cgstamt(13)            TYPE p DECIMALS 2,                       "Amount of CGST payable.
    sgstamt(13)            TYPE p DECIMALS 2,                       "Amount of SGST payable."
    zcesrt(13)             TYPE p DECIMALS 2,                       "Cess Rate
    zcesamt(13)            TYPE p DECIMALS 2,                       "Cess Amount(Advalorem) on basis of rate and quantity of item
    zcesnonadvlamt(13)     TYPE p DECIMALS 2,                       "Cess Non-Advol Amount
    statecesrt(13)         TYPE p DECIMALS 2,                       "State CESS Rate
    statecesamt(13)        TYPE p DECIMALS 2,                       "State CESS Amount
    statecesnonadvlamt(13) TYPE p DECIMALS 2,                       "State CESS Non Adval Amount
    othchrg(13)            TYPE p DECIMALS 2,                       "Other Charges
    totitemval(13)         TYPE p DECIMALS 2,       "Required       "Total Item Value = Assessable Amount + CGST Amt + SGST Amt + Cess Amt + CesNonAdvlAmt + StateCesAmt + StateCesNonAdvlAmt+Otherchrg"
    ordlineref(50)         TYPE c,                                  "Order line referencee
    orgcntry(4)           TYPE c,                                  "Orgin Country
    prdslno(15)            TYPE c,                                  "Serial number in case of each item having a unique number."
    bchdtls                TYPE bchdtls,                            "If add Required
    attribdtls             LIKE lt_attribdtls,
  END OF itemlist.





DATA : ls_retmsg   TYPE bapiret2,
       lv_error(1),
       lv_vbeln    TYPE vbeln.



CONSTANTS : lc_taxsch(10)    TYPE c VALUE 'GST',
            lc_version(10)   TYPE c VALUE '1.1',
            lc_typ(10)       TYPE c VALUE 'REG',
            lc_doctyp_cr(05) TYPE c VALUE 'CRN',
            lc_doctyp_dr(05) TYPE c VALUE 'DBN',
            lc_catg(10)      TYPE c VALUE 'B2B',
            lc_catg_wop(10)  TYPE c VALUE 'SEZWOP',
            lc_catg_wp(10)   TYPE c VALUE 'SEZWP',
            lc_regrev(10)    TYPE c VALUE 'RG',
            lc_trntyp(10)    TYPE c VALUE 'REG',
            lc_ecmtrn(05)    TYPE c VALUE 'N',
            lc_blart_dr      TYPE c LENGTH 2 VALUE 'DR',
            lc_null(06)    TYPE c VALUE 'null'.


DATA : lt_itemlist TYPE STANDARD TABLE OF itemlist,
       ls_itemlist TYPE itemlist.


DATA : lv_total_val(11) TYPE p DECIMALS 2,
       lv_tax_val(11)   TYPE p DECIMALS 2,
       lv_cgstval(11)   TYPE p DECIMALS 2,
       lv_sgstval(11)   TYPE p DECIMALS 2,
       lv_igstval(11)   TYPE p DECIMALS 2,
       lv_discount(11)  TYPE p DECIMALS 2,
       lv_invtotal(11)  TYPE p DECIMALS 2.



DATA : lt_addldocdtls TYPE TABLE OF addldocdtls,
       ls_addldocdtls TYPE addldocdtls.



TYPES : BEGIN OF ty_final,
          version(10) TYPE c,            "Required        "Version of the schema
          irn(64)     TYPE c,                             "Invoice Reference Number
          trandtls    TYPE trandtls,     "Required        "GST- Goods and Services Tax Scheme
          zdocdtls    TYPE docdtls,      "Required
          sellerdtls  TYPE sellerdtls,   "Required
          buyerdtls   TYPE buyerdtls,    "Required
          dispdtls    TYPE dispdtls,     "If add Required
          shipdtls    TYPE shipdtls,     "If add Required
          valdtls     TYPE valdtls,      "Required
          paydtls     TYPE paydtls,
          refdtls     TYPE refdtls,      "If add Required
          expdtls     TYPE expdtls,
          addldocdtls TYPE addldocdtls,
          ewbdtls     TYPE ewbdtls,      "If add Required
          itemlist    LIKE  lt_itemlist,  "Required
*          vtweg       TYPE vtweg,
        END OF ty_final.

DATA : str1 TYPE string.




DATA : lt_bkpf      TYPE TABLE OF ty_bkpf,
       ls_bkpf      TYPE ty_bkpf,
       lt_bkpf_temp TYPE TABLE OF ty_bkpf_temp,
       ls_bkpf_temp TYPE ty_bkpf_temp,
       lt_bkpf_ref  TYPE TABLE OF ty_bkpf,
       ls_bkpf_ref  TYPE ty_bkpf,
       lt_t001      TYPE TABLE OF ty_t001,
       ls_t001      TYPE ty_t001,

       lt_bseg      TYPE TABLE OF ty_bseg,
       ls_bseg      TYPE ty_bseg,
       lt_bseg_d    TYPE TABLE OF ty_bseg,
       ls_bseg_d    TYPE ty_bseg,
       lt_bseg_t    TYPE TABLE OF ty_bseg,
       ls_bseg_t    TYPE  ty_bseg,
       lt_bseg1     TYPE TABLE OF bseg,
       ls_bseg1     TYPE bseg,
*       lt_kna1       TYPE TABLE OF ty_kna1,
*       ls_kna1       TYPE ty_kna1,
*       lt_adrc       TYPE TABLE OF ty_adrc,
*       ls_adrc       TYPE ty_adrc,
*       lt_j_1bbranch TYPE TABLE OF ty_j_1bbranch,
*       ls_j_1bbranch TYPE ty_j_1bbranch,
*       lt_t001w      TYPE TABLE OF ty_t001w,
*       ls_t001w      TYPE ty_t001w,
*       lt_marc       TYPE TABLE OF ty_marc,
*       ls_marc       TYPE ty_marc,
       lt_makt      TYPE TABLE OF makt,
       ls_makt      TYPE makt,
       lt_bset      TYPE TABLE OF bset,
       ls_bset      TYPE bset,
       lt_bset1     TYPE TABLE OF ty_bset,
       ls_bset1     TYPE ty_bset.

DATA : GV_BUZID TYPE BSEG-BUZID.

TYPES  : BEGIN OF lty_j_1bbranch,
           bukrs  TYPE j_1bbranch-bukrs,
           branch TYPE j_1bbranch-branch,
           gstin  TYPE j_1bbranch-gstin,
         END OF lty_j_1bbranch.


TYPES : BEGIN OF lty_vbpa,
          vbeln TYPE vbpa-vbeln,
          posnr TYPE vbpa-posnr,
          parvw TYPE vbpa-parvw,
          kunnr TYPE vbpa-kunnr,
        END OF lty_vbpa.



TYPES : BEGIN OF lty_t001w,
          werks TYPE t001w-werks,
          name1 TYPE t001w-name1,
          kunnr TYPE t001w-kunnr,
          lifnr TYPE t001w-lifnr,
          adrnr TYPE t001w-adrnr,
        END OF lty_t001w.


TYPES : BEGIN OF lty_kna1 ,
          kunnr TYPE kna1-kunnr,
          land1 TYPE kna1-land1,
          name1 TYPE kna1-name1,
          pstlz TYPE kna1-pstlz,
          regio TYPE kna1-regio,
          adrnr TYPE kna1-adrnr,
          stcd3 TYPE kna1-stcd3,
        END OF lty_kna1.


TYPES : BEGIN OF lty_adrc,
          addrnumber TYPE adrc-addrnumber,
          name1      TYPE adrc-name1,
          city1      TYPE adrc-city1,
          post_code1 TYPE adrc-post_code1,
          street     TYPE adrc-street,
          str_suppl1 TYPE adrc-str_suppl1,
          location   TYPE adrc-location,
          country    TYPE adrc-country,
          region     TYPE adrc-region,
          sort1      TYPE adrc-sort1,
        END OF lty_adrc.


TYPES : BEGIN OF lty_knvv,
        KUNNR TYPE knvv-kunnr,
        VKORG TYPE knvv-vkorg,
        VTWEG TYPE knvv-vtweg,
        SPART TYPE knvv-spart,
        END OF lty_knvv.

DATA : lt_final        TYPE TABLE OF ty_final,
       ls_final        TYPE ty_final,

       it_final        TYPE TABLE OF ty_final,
       wa_final        TYPE ty_final,

       lt_t001w        TYPE TABLE OF t001w,
       ls_t001w        TYPE t001w,

*       lt_t001       TYPE TABLE OF t001,
*       ls_t001       TYPE t001,

       lt_konv_t       TYPE TABLE OF konv WITH HEADER LINE,

       lt_adrc         TYPE TABLE OF adrc,
       ls_adrc         TYPE adrc,

       lt_adrc_re      TYPE TABLE OF lty_adrc,
       ls_adrc_re      TYPE lty_adrc,

       lt_adrc_we      TYPE TABLE OF lty_adrc,
       ls_adrc_we      TYPE lty_adrc,

       lt_t005u        TYPE TABLE OF t005u,
       ls_t005u        TYPE t005u,
       lt_j_1istatecdm TYPE TABLE OF j_1istatecdm,
       ls_j_1istatecdm TYPE j_1istatecdm,
       lt_adr2         TYPE TABLE OF adr2,
       ls_adr2         TYPE adr2,
       lt_adr6         TYPE TABLE OF adr6,
       ls_adr6         TYPE adr6,

       lt_t005u_re     TYPE TABLE OF t005u,
       ls_t005u_re     TYPE t005u,


       lt_t005u_we     TYPE TABLE OF t005u,
       ls_t005u_we     TYPE t005u,


       lt_vbpa         TYPE TABLE OF lty_vbpa,
       ls_vbpa         TYPE lty_vbpa,

       lt_vbpa_re      TYPE TABLE OF lty_vbpa,
       ls_vbpa_re      TYPE lty_vbpa,

       lt_vbpa_we      TYPE TABLE OF lty_vbpa,
       ls_vbpa_we      TYPE lty_vbpa,

       lt_vbpa_rg      TYPE TABLE OF lty_vbpa,
       ls_vbpa_rg      TYPE lty_vbpa,

       lt_kna1         TYPE TABLE OF kna1,
       ls_kna1         TYPE kna1,

       lt_kna1_re      TYPE TABLE OF lty_kna1,
       ls_kna1_re      TYPE lty_kna1,

       lt_kna1_we      TYPE TABLE OF lty_kna1,
       ls_kna1_we      TYPE lty_kna1,

       lt_kna1_rg      TYPE TABLE OF lty_kna1,
       ls_kna1_rg      TYPE lty_kna1,

       lt_j_1bbranch   TYPE STANDARD TABLE OF j_1bbranch,
       ls_j_1bbranch   TYPE j_1bbranch,

       lt_marc         TYPE STANDARD TABLE OF marc,
       ls_marc         TYPE marc,

       lt_t052u        TYPE STANDARD TABLE OF lty_t052u,
       ls_t052u        TYPE lty_t052u,

       lt_knvv         TYPE STANDARD TABLE OF lty_knvv,
       ls_knvv         TYPE lty_knvv.

DATA : ls_final_cancel TYPE lty_cancel,

       lv_kbetr        TYPE kbetr,
       lv_kwert        TYPE kwert,
       lv_itemcount    TYPE i,

       gr_table        TYPE REF TO cl_salv_table,              "Declaration for ALV Grid

       it_messages     LIKE sls_msgs OCCURS 0 WITH HEADER LINE.

DATA : go_einvoice_utility TYPE REF TO zcl_einvoice_utility.

DATA :  lt_sel_addr       TYPE TABLE OF zeinv_adrc,
       ls_sel_addr       TYPE zeinv_adrc,

       lt_dis_addr       TYPE TABLE OF zeinv_adrc,
       ls_dis_addr       TYPE zeinv_adrc,

       lt_buy_addr       TYPE TABLE OF zeinv_adrc,
       ls_buy_addr       TYPE zeinv_adrc,

       lt_shp_addr       TYPE TABLE OF zeinv_adrc,
       ls_shp_addr       TYPE zeinv_adrc.
