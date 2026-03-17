
TYPES:
  BEGIN OF t_item,
    vbeln TYPE vbrp-vbeln,
    posnr TYPE vbrp-posnr,
    fkimg TYPE vbrp-fkimg,
    vrkme TYPE vbrp-vrkme,
    netwr TYPE vbrp-netwr,
    matnr TYPE vbrp-matnr,
    arktx TYPE vbrp-arktx,
    werks TYPE vbrp-werks,
    aubel TYPE vbrp-aubel,
    aupos TYPE vbrp-aupos,
  END OF t_item,
  tt_item TYPE STANDARD TABLE OF t_item.

TYPES:
  BEGIN OF t_conditions,
    knumv TYPE konv-knumv,
    kposn TYPE konv-kposn,
    kschl TYPE konv-kschl,
    kbetr TYPE konv-kbetr,
    waers TYPE konv-waers,
    kwert TYPE konv-kwert,
    kstat TYPE konv-kstat,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.


  TYPES: BEGIN OF idata ,
         name1      LIKE kna1-name1,          "custmor Name
         ktokd      LIKE kna1-ktokd,          " customer account group
         kunnr      LIKE bsid-kunnr,          "Customer Code
         shkzg      LIKE bsid-shkzg,          "debit/credit s/h
         bukrs      LIKE bsid-bukrs,          "Company Code
         augbl      LIKE bsid-augbl,          "Clearing Doc No
         auggj      LIKE bsid-auggj,
         augdt      LIKE bsid-augdt,          "Clearing Date
         gjahr      LIKE bsid-gjahr,          "Fiscal year
         belnr      LIKE bsid-belnr,          "Document no.
         umskz      LIKE bsid-umskz,          "Special G/L indicator
         buzei      LIKE bsid-buzei,          "Line item no.
         budat      LIKE bsid-budat,          "Posting date in the document
         bldat      LIKE bsid-bldat,          "Document date in document
         waers      LIKE bsid-waers,          "Currency
         blart      LIKE bsid-blart,          "Doc. Type
         xblnr      TYPE bsid-xblnr,          "ODN
         dmbtr      LIKE bsid-dmbtr,          "Amount in local curr.
         wrbtr      LIKE bsid-wrbtr,          "Amount in local curr.
         rebzg      LIKE bsid-rebzg,          "refr inv no
         rebzj      LIKE bsid-rebzj,          "Fiscal year
         rebzz      LIKE bsid-rebzz,          "Line Item no
         vbeln      TYPE bsad-vbeln,          "Invoice Number
         duedate    LIKE bsid-augdt,        "Due Date
         zterm      LIKE bsid-zterm,         "Payment Term
*         zbd1t     LIKE bsid-zbd1t,         "Cash Discount Days 1
         day        TYPE i,
         debit      LIKE bsid-dmbtr,         "Amount in local curr.
         credit     LIKE bsid-dmbtr,         "Amount in local curr.
         netbal     LIKE bsid-dmbtr,         "Amount in local curr.
         not_due_cr TYPE bsid-dmbtr,        "Amount in local curr.
         not_due_db TYPE bsid-dmbtr,        "Amount in local curr.
         not_due    TYPE bsid-dmbtr,        "Amount in local curr.
         debit30    LIKE bsid-dmbtr,        "Amount in local curr.
         credit30   LIKE bsid-dmbtr,       "Amount in local curr.
         netb30     LIKE bsid-dmbtr,         "Amount in local curr.
         debit60    LIKE bsid-dmbtr,        "Amount in local curr.
         credit60   LIKE bsid-dmbtr,       "Amount in local curr.
         netb60     LIKE bsid-dmbtr,         "Amount in local curr.
         debit90    LIKE bsid-dmbtr,        "Amount in local curr.
         credit90   LIKE bsid-dmbtr,       "Amount in local curr.
         netb90     LIKE bsid-dmbtr,         "Amount in local curr.
         debit120   LIKE bsid-dmbtr,       "Amount in local curr.
         credit120  LIKE bsid-dmbtr,      "Amount in local curr.
         netb120    LIKE bsid-dmbtr,         "Amount in local curr.
         debit180   LIKE bsid-dmbtr,       "Amount in local curr.
         credit180  LIKE bsid-dmbtr,      "Amount in local curr.
         netb180    LIKE bsid-dmbtr,         "Amount in local curr.
         debit360   LIKE bsid-dmbtr,       "Amount in local curr.
         credit360  LIKE bsid-dmbtr,      "Amount in local curr.
         netb360    LIKE bsid-dmbtr,         "Amount in local curr.
         debit720   LIKE bsid-dmbtr,       "Amount in local curr.
         credit720  LIKE bsid-dmbtr,      "Amount in local curr.
         netb720    LIKE bsid-dmbtr,         "Amount in local curr.
         debit730   LIKE bsid-dmbtr,       "Amount in local curr.
         credit730  LIKE bsid-dmbtr,      "Amount in local curr.
         netb730    LIKE bsid-dmbtr,         "Amount in local curr.
         debit_ab   LIKE bsid-dmbtr,       "Amount in local curr.
         credit_ab  LIKE bsid-dmbtr,      "Amount in local curr.
         netb_ab    LIKE bsid-dmbtr,         "Amount in local curr.
         tdisp      TYPE string,
         group      TYPE string,
         akont      TYPE knb1-akont,
         zfbdt      TYPE bsid-zfbdt,
         zbd1t      TYPE bsid-zbd1t,
         zbd2t      TYPE bsid-zbd2t,
         zbd3t      TYPE bsid-zbd3t,
         curr       TYPE bsid-dmbtr,
         bezei      TYPE tvkbt-bezei,
         fkdat      TYPE vbrk-fkdat,
         aubel      TYPE vbrp-aubel,
         audat      TYPE vbak-audat,
         bstnk      TYPE vbak-bstnk,
         bstdk      TYPE vbak-bstdk,
         vtext      TYPE char200,
         txt50      TYPE string,
         rec_txt    TYPE char70,     "Reconcilation Account text
         debit1000  LIKE bsid-dmbtr,
         credit1000 LIKE bsid-dmbtr,
         netb1000   LIKE bsid-dmbtr,
         sale       TYPE char10,
         sale_off   TYPE char50,
         bstkd      TYPE vbkd-bstkd,
       END OF idata.









