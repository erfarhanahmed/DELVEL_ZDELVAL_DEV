FUNCTION-POOL zfg_json_file_save_inv_n MESSAGE-ID zinv_message .          "MESSAGE-ID ..

* INCLUDE LZFG_JSON_CONVERSIOND...           " Local class definition


DATA : ls_retmsg   TYPE bapiret2,
       lv_error(1),
       lv_vbeln    TYPE vbeln,
       lv_docs     TYPE i,
       lv_typ(03)  TYPE c.



CONSTANTS : lc_null(06)    TYPE c VALUE 'null',
            lc_taxsch(10)  TYPE c VALUE 'GST',
            lc_version(10) TYPE c VALUE '1.1',
            lc_typ_reg(10) TYPE c VALUE 'REG',
            lc_typ_dis(10) TYPE c VALUE 'DIS',
            lc_typ_shp(10) TYPE c VALUE 'SHP',
            lc_typ_cmb(10) TYPE c VALUE 'CMB',
            lc_typ_SER(10) TYPE c VALUE 'SER',
            lc_trntyp(10)  TYPE c VALUE 'REG',
            lc_regrev(05)  TYPE c VALUE 'N'.


TYPES : BEGIN OF trandtls,
          taxsch(10)   TYPE c,     "Required      "GST- Goods and Services Tax Scheme
          suptyp(10)   TYPE c,     "Required      "Type of Supply: B2B-Business to Business, SEZWP - SEZ with payment, SEZWOP - SEZ without payment, EXPWP - Export with Payment, EXPWOP - Export without payment,DEXP - Deemed Export
          regrev(1)    TYPE c,                    "Y- whether the tax liability is payable under reverse charge
          ecmgstin(15) TYPE c,                    "GSTIN of e-Commerce operator
        END OF trandtls.

TYPES : BEGIN OF docdtls,
          ztyp(11) TYPE c,         "Required   "Document Type: INVOICE, CREDIT NOTE, DEBIT NOTE
          zno(16)  TYPE c,         "Required   "Document Number
          zdt(10)  TYPE c,         "Required   "Document Date
        END OF docdtls.


TYPES : BEGIN OF sellerdtls,
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
        END OF sellerdtls.


TYPES : BEGIN OF buyerdtls,
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
        END OF buyerdtls.

TYPES : BEGIN OF dispdtls,
          znm(60)    TYPE c,  "Required       "Name of the company from which the goods are dispatched
          addr1(100) TYPE c,  "Required       "Address 1 of the entity from which goods are dispatched.(Building/Flat num.Road/Street etc.)
          addr2(100) TYPE c,                  "Address 2 of the entity from which goods are dispatched. (Floor num., Name of the premises/building)"
          zloc(100)   TYPE c,  "Required       "Location
          zpin(06)    TYPE c,  "Required       "Pincode
          stcd(02)   TYPE c,  "Required       "State Code
        END OF dispdtls.


TYPES : BEGIN OF shipdtls,
          gstin(15)  TYPE c,                  "GSTIN of entity to whom goods are shipped
          lglnm(60)  TYPE c,  "Required       "Legal Name
          trdnm(60)  TYPE c,                  "Trade Name
          addr1(100) TYPE c,  "Required       "Address1 of the entity to whom the supplies are shipped to. (Building/Flat num., Road/Street etc.)
          addr2(100) TYPE c,                  "Address 2 of the entity to whom the supplies are shipped to. (Floor num., Name of the premises/building)."
          zloc(100)   TYPE c,  "Required       "Place (City,Town,Village) entity to whom the supplies are shipped to.
          zpin(06)    TYPE c,  "Required       "Pincode
          stcd(02)   TYPE c,  "Required       "State Code to which supplies are shipped to."
        END OF shipdtls.

TYPES : BEGIN OF attribdtls,
          znm(100)  TYPE c,                    "Attribute details of the item
          valu(100) TYPE c,                    "Attribute value of the item
        END OF attribdtls.

DATA : lt_attribdtls TYPE STANDARD TABLE OF attribdtls,
       ls_attribdtls TYPE attribdtls.

TYPES : BEGIN OF bchdtls,
          znm(20)    TYPE c,     "Required         "Batch name
          zexpdt(10) TYPE c,                       "Batch Expiry Date
          wrdt(10)   TYPE c,                       "Warranty Date
        END OF bchdtls.

TYPES : BEGIN OF valdtls,
          assval(15)      TYPE p DECIMALS 2,          "Required     "Total Assessable value of all items
          cgstval(13)     TYPE p DECIMALS 2,                        "Total CGST value of all items
          sgstval(13)     TYPE p DECIMALS 2,                        "Total SGST value of all items
          igstval(13)     TYPE p DECIMALS 2,                        "Total IGST value of all items"
          zcesval(13)     TYPE p DECIMALS 2,                        "Total CESS value of all items
          stcesval(13)    TYPE p DECIMALS 2,                        "Total State CESS value of all items
          rndoffamt(6)    TYPE p DECIMALS 2,                        "Rounded off amount
          ztotinvval(15)  TYPE p DECIMALS 2,          "Required     "Final Invoice value
          totinvvalfc(15) TYPE p DECIMALS 2,                        "Final Invoice value in Additional Currency   " commented by rushikesh
*          invforcur(10)       TYPE c,
        END OF valdtls.

TYPES : BEGIN OF paydtls,
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
        END OF paydtls.

TYPES : BEGIN OF precdocdtls,
          invno(16)    TYPE c,      "Required   "Reference of original invoice, if any.
          invdt(10)    TYPE c,      "Required   "Date of preceding invoice
          othrefno(20) TYPE c,                  "Other Reference
        END OF precdocdtls.


TYPES  :BEGIN OF contrdtls,
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

TYPES : BEGIN OF refdtls,
          invrm(100)   TYPE c,                  "Remarks/Note
          docperddtls  TYPE docperddtls,
          precdocdtls  LIKE LT_precdocdtls,
          contrdtls    LIKE LT_contrdtls,
        END OF refdtls.

TYPES : BEGIN OF addldocdtls,
          url(100)   TYPE c,                    "Supporting document URL
          docs(1000) TYPE c,                    "Supporting document in Base64 Format
*          info(1000) TYPE c,                    "Any additional information     "commenetd by Rushikesh
          infodtls(1000) TYPE c,                    "Any additional information           "added by rushkesh
        END OF addldocdtls.


TYPES : BEGIN OF expdtls,
          shipbno(20) TYPE c,                   "Shipping Bill num."
          shipbdt(10) TYPE c,                   "Shipping Bill Date
          port(10)    TYPE c,                   "Port Code
          refclm(1)   TYPE c,                   "Options for supplier for refund. Y/N
          forcur(16)  TYPE c,                   "Additional Currency Code
          cntcode(6)  TYPE c,                   "Country Code
          expduty     TYPE p DECIMALS 2,        "Export Duty
        END OF expdtls.

TYPES : BEGIN OF ewbdtls,
          transid(15)    TYPE c,                "Transin/GSTIN
          transname(100) TYPE c,                "Name of the transporter
          transmode(1)   TYPE c,   "Required    "Mode of transport
          distance(4)    TYPE c,   "Required    "Distance between source and destination PIN codes
          transdocno(15) TYPE c,                "Tranport Document Number
          transdocdt(10) TYPE c,                "Transport Document Date
          vehno(20)      TYPE c,                "Vehicle Number
          vehtype(1)     TYPE c,                "Whether O-ODC or R-Regular
        END OF ewbdtls.


TYPES : BEGIN OF itemlist,
          zslno(06)              TYPE c,                  "Required       "Serial num. of Item
          prddesc(300)           TYPE c,                                  "Product Description
          isservc(1)             TYPE c,                  "Required       "Specify whether the supply is service or not. Specify Y-for Service"
          hsncd(08)              TYPE c,                  "Required       "HSN Code
          barcde(30)             TYPE c,                                  "Bar Code
          qnty(20)               TYPE c,                                  "Quantity Qty->qnty
          freeqty(20)            TYPE c,                                  "Free Quantity
          units(08)              TYPE c,                                  "Unit
          unitprice(13)          TYPE p DECIMALS 2,      "Required        "Unit Price - Rate
          totamt(13)             TYPE p DECIMALS 2,      "Required        "Gross Amount Amount (Unit Price * Quantity)"
          discount(12)           TYPE p DECIMALS 2,                       "Discount
          pretaxval(15)          TYPE p DECIMALS 2,                       "Pre tax value
          assamt(15)             TYPE p DECIMALS 2,                       "Taxable Value (Total Amount -Discount)
          gstrt(6)               TYPE c,                            "p DECIMALS 2,"3,       "Required       "The GST rate, represented as percentage that applies to the invoiced item. It will IGST rate only
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
          orgcntry(02)           TYPE c,                                  "Orgin Country
          prdslno(15)            TYPE c,                                  "Serial number in case of each item having a unique number."
          bchdtls                TYPE bchdtls,                            "If add Required
          attribdtls             LIKE lt_attribdtls,
        END OF itemlist.



DATA : lt_itemlist TYPE STANDARD TABLE OF itemlist,
       ls_itemlist TYPE itemlist.

DATA : lv_total_val(11) TYPE p DECIMALS 2,
       lv_assval(11)    TYPE p DECIMALS 2,
       lv_cgstval(11)   TYPE p DECIMALS 2,
       lv_sgstval(11)   TYPE p DECIMALS 2,
       lv_igstval(11)   TYPE p DECIMALS 2,
       lv_discount(11)  TYPE p DECIMALS 2.


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
          addldocdtls like lt_addldocdtls,                          "TYPE addldocdtls,
          ewbdtls     TYPE ewbdtls,      "If add Required
          itemlist    LIKE  lt_itemlist,  "Required
        END OF ty_final.

DATA : str1 TYPE string.


TYPES : BEGIN OF lty_marc,
          matnr TYPE marc-matnr,
          werks TYPE marc-werks,
          steuc TYPE marc-steuc,
        END OF lty_marc.

TYPES : BEGIN OF lty_t052u,
          zterm TYPE t052u-zterm,
          text1 TYPE t052u-text1,
        END OF lty_t052u.



"---Table Declarations------------
TYPES : BEGIN OF lty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
          waerk TYPE vbrk-waerk,
          knumv TYPE vbrk-knumv,
          fkdat TYPE vbrk-fkdat,
          gjahr TYPE vbrk-gjahr,
          rfbsk TYPE vbrk-rfbsk,
          zterm TYPE vbrk-zterm,
          bukrs TYPE vbrk-bukrs,
          xblnr TYPE vbrk-xblnr,
          zuonr TYPE vbrk-vbeln,
          bupla TYPE vbrk-bupla,
          vkorg TYPE vbrk-vkorg,
          vtweg TYPE vbrk-vtweg,
          land1 TYPE vbrk-land1,
        END OF lty_vbrk.



TYPES : BEGIN OF lty_vbrp,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          fkimg TYPE vbrp-fkimg,
          vrkme TYPE vbrp-vrkme,
          ntgew TYPE vbrp-ntgew,
          netwr TYPE vbrp-netwr,
          matnr TYPE vbrp-matnr,
          arktx TYPE vbrp-arktx,
          pstyv TYPE vbrp-pstyv,
          werks TYPE vbrp-werks,
          vgbel TYPE vbrp-vgbel,
        END OF lty_vbrp.

TYPES : BEGIN OF lty_vbpa_eway,
        vbeln TYPE vbpa-vbeln,
        posnr TYPE vbpa-posnr,
        parvw TYPE vbpa-parvw,
        lifnr TYPE vbpa-lifnr,
        END OF lty_vbpa_eway.

TYPES : BEGIN OF lty_lfa1_eway,
        lifnr TYPE lfa1-lifnr,
        name1 TYPE lfa1-name1,
        stcd3 TYPE lfa1-stcd3,
        END OF lty_lfa1_eway.



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
          str_suppl2 TYPE adrc-str_suppl2,
          location   TYPE adrc-location,
          country    TYPE adrc-country,
          region     TYPE adrc-region,
          sort1      TYPE adrc-sort1,
          mc_city1   TYPE adrc-mc_city1,
          tel_number TYPE adrc-tel_number,
          bezei      TYPE bezei,
          gstin      TYPE j_1bbranch-gstin,
        END OF lty_adrc.

TYPES: BEGIN OF lty_likp,
         vbeln TYPE likp-vbeln,
         vkorg TYPE likp-vkorg,
         vstel TYPE likp-vstel,
         kunnr TYPE likp-kunnr,
         kunag TYPE likp-kunag,
       END OF lty_likp.

TYPES: BEGIN OF lty_zeinv_link,
         bukrs       TYPE zeinv_link-bukrs,
         vkorg       TYPE zeinv_link-vkorg,
         fkart       TYPE zeinv_link-fkart,
         base_kschl  TYPE zeinv_link-base_kschl,
         disc_kschl  TYPE zeinv_link-disc_kschl,
         other_kschl TYPE zeinv_link-other_kschl,
         type        TYPE zeinv_link-type,
         category    TYPE zeinv_link-category,
         expcat      TYPE zeinv_link-expcat,
         flag        TYPE zeinv_link-flag,
         foc_flag        TYPE zeinv_link-foc_flag,
       END OF lty_zeinv_link.

TYPES : BEGIN OF lty_zstate_code,
          zstcode  TYPE zstate_code-zstcode,
          zsapcode TYPE zstate_code-zsapcode,
          zstdecr  TYPE zstate_code-zstdecr,
        END OF lty_zstate_code.

TYPES : BEGIN OF lty_zeway,
        vbeln        TYPE zeway_bill-vbeln,
        trns_md      TYPE zeway_bill-trns_md,
        trans_doc    TYPE zeway_bill-trans_doc,
        doc_dt       TYPE zeway_bill-doc_dt,
        trans_id     TYPE zeway_bill-trans_id,
        trans_name   TYPE zeway_bill-trans_name,
        vehical_no   TYPE zeway_bill-vehical_no,
        vehical_type TYPE zeway_bill-vehical_type,
        distance     TYPE zeway_bill-distance,
        END OF lty_zeway.

 DATA : lt_zeway_tab TYPE TABLE OF lty_zeway,
        ls_zeway_tab TYPE lty_zeway.


TYPES : BEGIN OF lty_knvi,
        kunnr TYPE knvi-kunnr,
        aland TYPE knvi-aland,
        tatyp TYPE knvi-tatyp,
        taxkd TYPE knvi-taxkd,
        END OF lty_knvi.


DATA : lt_knvi_expwp TYPE TABLE OF lty_knvi,
       ls_knvi_expwp TYPE lty_knvi.

DATA : lt_knvi_dexp TYPE TABLE OF lty_knvi,
       ls_knvi_dexp TYPE lty_knvi.

DATA : lt_knvi_sezexp TYPE TABLE OF lty_knvi,
       ls_knvi_sezexp TYPE lty_knvi.


TYPES : BEGIN OF lty_konv_exp,
        knumv TYPE konv-knumv,
        kschl TYPE konv-kschl,
        kstat TYPE konv-kstat,
        END OF lty_konv_exp.

DATA : lt_konv_exp TYPE TABLE OF lty_konv_exp,
       ls_konv_exp TYPE lty_konv_exp.


TYPES : BEGIN OF lty_vbpa_exp,
        vbeln TYPE vbpa-vbeln,
        posnr TYPE vbpa-posnr,
        parvw TYPE vbpa-parvw,
        kunnr TYPE vbpa-kunnr,
        END OF lty_vbpa_exp.


 DATA : lt_vbpa TYPE TABLE OF lty_vbpa_exp,
        ls_vbpa TYPE lty_vbpa_exp.


 TYPES : BEGIN OF lty_kna1_exp,
         kunnr TYPE kna1-kunnr,
         locco TYPE kna1-locco,
         END OF lty_kna1_exp.

 DATA : lt_kna1_exp TYPE TABLE OF lty_kna1_exp,
        ls_kna1_exp TYPE lty_kna1_exp.



DATA : lt_final          TYPE TABLE OF ty_final,
       ls_final          TYPE ty_final,

       lt_update         TYPE  TABLE OF zeinv_update,
       ls_update         TYPE zeinv_update,

       it_final          TYPE TABLE OF ty_final,
       wa_final          TYPE ty_final,

       lt_vbrk           TYPE TABLE OF lty_vbrk,
       ls_vbrk           TYPE lty_vbrk,

       lt_vbrp           TYPE TABLE OF lty_vbrp,
       ls_vbrp           TYPE lty_vbrp,

       lt_vbpa_eway           TYPE TABLE OF lty_vbpa_eway,
       ls_vbpa_eway           TYPE lty_vbpa_eway,

       lt_lfa1_eway      TYPE TABLE OF lty_lfa1_eway,
       ls_lfa1_eway      TYPE lty_lfa1_eway,

       lt_vbrp_cd           TYPE TABLE OF lty_vbrp,
       ls_vbrp_cd           TYPE lty_vbrp,

       lt_adrc           TYPE TABLE OF lty_adrc,
       ls_adrc           TYPE lty_adrc,


       lt_sel_addr       TYPE TABLE OF zeinv_adrc,
       ls_sel_addr       TYPE zeinv_adrc,

       lt_dis_addr       TYPE TABLE OF zeinv_adrc,
       ls_dis_addr       TYPE zeinv_adrc,

       lt_buy_addr       TYPE TABLE OF zeinv_adrc,
       ls_buy_addr       TYPE zeinv_adrc,

       lt_shp_addr       TYPE TABLE OF zeinv_adrc,
       ls_shp_addr       TYPE zeinv_adrc,

       lt_t001w          TYPE TABLE OF lty_t001w,
       ls_t001w          TYPE lty_t001w,

       lt_t001           TYPE TABLE OF t001,
       ls_t001           TYPE t001,

       lt_konv_t         TYPE TABLE OF konv WITH HEADER LINE,
*       LS_KONV_T TYPE  KONV,




*       lt_t005u          TYPE TABLE OF t005u,
*       ls_t005u          TYPE t005u,
*
*       lt_t005u_re       TYPE TABLE OF t005u,
*       ls_t005u_re       TYPE t005u,

*       lt_zcensus TYPE TABLE OF zcensus_india,
*       ls_zcensus TYPE zcensus_india,
*
*       lt_zcensus_seller  TYPE TABLE OF zcensus_india,
*       ls_zcensus_seller  TYPE zcensus_india,

*       lt_t005u_we       TYPE TABLE OF t005u,
*       ls_t005u_we       TYPE t005u,


*       lt_vbpa           TYPE TABLE OF lty_vbpa,
*       ls_vbpa           TYPE lty_vbpa,
*
*       lt_vbpa_re        TYPE TABLE OF lty_vbpa,
*       ls_vbpa_re        TYPE lty_vbpa,
*
*       lt_vbpa_we        TYPE TABLE OF lty_vbpa,
*       ls_vbpa_we        TYPE lty_vbpa,
*
*       lt_vbpa_rg        TYPE TABLE OF lty_vbpa,
*       ls_vbpa_rg        TYPE lty_vbpa,

       lt_kna1           TYPE TABLE OF lty_kna1,
       ls_kna1           TYPE lty_kna1,

*       lt_kna1_re        TYPE TABLE OF lty_kna1,
*       ls_kna1_re        TYPE lty_kna1,

*       lt_kna1_we        TYPE TABLE OF lty_kna1,
*       ls_kna1_we        TYPE lty_kna1,
*
*       lt_kna1_rg        TYPE TABLE OF lty_kna1,
*       ls_kna1_rg        TYPE lty_kna1,

       lt_j_1bbranch     TYPE TABLE OF lty_j_1bbranch,
       ls_j_1bbranch     TYPE lty_j_1bbranch,

       lt_marc           TYPE STANDARD TABLE OF lty_marc,
       ls_marc           TYPE lty_marc,

       lt_t052u          TYPE STANDARD TABLE OF lty_t052u,
       ls_t052u          TYPE lty_t052u,

       lt_likp           TYPE STANDARD TABLE OF lty_likp,
       ls_likp           TYPE lty_likp,


       ls_zeinv_link     TYPE lty_zeinv_link,
       lt_zeinv_link     TYPE TABLE OF lty_zeinv_link,

       ls_zstate_code    TYPE lty_zstate_code,
       lt_zstate_code    TYPE TABLE OF   lty_zstate_code,

       ls_zstate_code_re TYPE lty_zstate_code,
       lt_zstate_code_re TYPE TABLE OF   lty_zstate_code,

       ls_zstate_code_we TYPE lty_zstate_code,
       lt_zstate_code_we TYPE TABLE OF   lty_zstate_code.






"--Data Declaration for Cancel IRN Doc.

TYPES : BEGIN OF lty_cancel,
          irn(65)    TYPE c,
          cnlrsn(1)  TYPE c,
          cnlrem     TYPE string,
        END OF lty_cancel.

DATA : ls_final_cancel TYPE lty_cancel.

TYPES : BEGIN OF lty_cancel_eway,
          ewbno(12)         TYPE c,
          cancelRsnCode(1)  TYPE c,
          cancelRmrk        TYPE string,
        END OF lty_cancel_eway.

DATA : ls_final_cancel_eway TYPE lty_cancel_eway.



"------------------------------------------




DATA : lv_kbetr TYPE kbetr,
       lv_kwert TYPE kwert.

DATA : lv_recors_d TYPE i,
       lv_recors_s TYPE i.


DATA : ls_kkurs TYPE kkurs.
DATA : lv_roundoff TYPE P DECIMALS 2.
DATA : lv_roundoff_amt TYPE P DECIMALS 2.


DATA: gr_table TYPE REF TO cl_salv_table.               "Declaration for ALV Grid
