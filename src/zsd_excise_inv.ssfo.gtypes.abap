TYPES : BEGIN OF t_hdr,
          vbeln	          TYPE vbeln_vl,       " Delivery
          knumv           TYPE knumv,          " Number of the document condition
          inco2           TYPE inco2,          " Transporter/ Incoterms (Part 2)
          fkart           TYPE fkart,          " Billing Type

          trntyp          TYPE j_1itrntyp,     " Excise Transaction Type
          docyr           TYPE j_1idocuyr,     " Year
          docno           TYPE j_1idocno,      " Internal Excise Document Number
          exdat           TYPE j_1iexcdat,     " Excise Document Date
          "EXYEAR         TYPE J_1IEXYEAR,     " Excise Year
          remtime         TYPE j_1iremtim,     " Time of Removal
          expind          TYPE j_1iindexp,     " Export Type
          cpudt	          TYPE j_1icpudt,      " Excise Document Entry Date
          cputm           TYPE sy-uzeit,       " CPU Time
          bukrs           TYPE bukrs,          " Company Code
          werks           TYPE werks_d,        " Plant
          exnum           TYPE j_1iexcnum,     " Official Excise Document Number / J_1IEXCHDR
          lifnr           TYPE lifnr,          " Account Number of Vendor or Creditor
          rcwrk           TYPE umwrk,          " Receiving/Issuing Plant
          excur           TYPE j_1iexccur,     " Currency
          kunag           TYPE kunag,          " Sold-to party
          kunwe           TYPE kunwe,          " Ship-to party
          waerk	          TYPE waerk,          " SD Document Currency
          kurrf	          TYPE kurrf,          " Exchange rate for FI postings
          j_1iexrn        TYPE j_1iexrn,       " Excise Registration Number
          j_1iexrg        TYPE j_1iexrg,       " Excise Range
          j_1iexdi        TYPE j_1iexdi,       " Excise Division
          j_1iexco        TYPE j_1iexco,       " Excise Commissionerate
          j_1isern        TYPE j_1isern,       " tin nO./Service Tax Registration Number
          j_1icstno       TYPE j_1icstno,      " Central Sales Tax Number
          j_1ilstno       TYPE j_1ilstno,      " Local Sales Tax Number
          " ------ CHANGE ------- "
          exbed           TYPE j_1iexcbed,     " BASIC EXCISE DUTY
          ecs             TYPE j_1iexecs,      " ECS VALUE "
          exaddtax1       TYPE j_1iexaddtax1,  " ADDITIONAL TAX 1 VALUE

          butxt           TYPE butxt,           " Name of Company Code or Company
          name1           TYPE name1,           " Name of plant
          ort01           TYPE ort01,           " Plant - city
          adrnr           TYPE adrnr,           " Plant - Address
          email           TYPE ad_smtpadr,      " Plant - E-mail
          url             TYPE ad_uri,          " Universal Resource Identifier (URI)
          uri_length      TYPE adr12-uri_length,
          kunag_adrnr     TYPE adrnr,           " Sold-To-Party - Address Number
          kunwe_adrnr     TYPE adrnr,           " Ship-To-Party - Address Number
          kunwe_ort01     TYPE ort01_gp,        " Ship-To-Party - city
          kunag_j_1iexcd  TYPE j_1iexcd,        " ECC Number
          kunag_j_1icstno TYPE j_1icstno,       " Central Sales Tax Number
          kunag_j_1ilstno TYPE j_1ilstno,       " TIN Number/ Local Sales Tax Number

          gewei           TYPE gewei,           " Weight Unit
          edu_cess_rate   TYPE j_1iecsrat,      " Edu. Cess Rate
          h_e_cess_rate   TYPE j_1iexaddrat1,   " H.E.Cess Rate
          rgplaser        TYPE j_1iplaser,      " PLA serial no.

          bstnk           TYPE bstnk,           " Customer purchase order number
          bstdk           TYPE bstdk,           " Customer purchase order date
          supplier        TYPE vtext,           " Supplier
          trnsprt_mode    TYPE vtext,           " Mode of Transport
          trnsprtr_name   TYPE vtext,           " Transporter
          trnsprtr        TYPE vtext,           " Transporter
          l_r_no          TYPE vtext,           " L.R.No.
          vhicl           TYPE vtext,           " Vehicle No.
          freight         TYPE vtext,           " Freight
          trnsprt_dt      TYPE vtext,           " Transport Date
          chptr           TYPE vtext,           " Chapter
        END OF t_hdr,

        BEGIN OF t_item,
          zeile    TYPE  j_1izeile, " Item Number
*                    SHIPFROM  TYPE  LIFNR,     " Account Number of Vendor or Creditor
*                    RCWRK      TYPE  UMWRK,     " Receiving/Issuing Plant
          matnr    TYPE  matnr,     " Material Number
          matkl    TYPE  matkl,     " Material Group
          maktx    TYPE  maktx,     " Material Description (Short Text)
          menge    TYPE  j_1imenge, " Quantity mentioned in the excise invoice
          meins    TYPE  j_1imeins, " Unit of measure
          rgplaser TYPE  j_1iplaser, " PLA serial no.
          ntgew    TYPE  ntgew_15,  " Net Weight
          brgew    TYPE  brgew_15,  " Gross weight
          gewei    TYPE  gewei,     " Weight Unit
          kbetr    TYPE kbetr,      " Rate Per Unit / Rate (condition amount or percentage)
          kwert    TYPE kwert,      " Amount / Condition base value
          waers    TYPE  waers,
          "MRK_PKG    TYPE  J_1IMRK_PKG, " Marks on Package
          "NOS_ON_PKG TYPE J_1INOS_ON_PKG, " Numbers on Package
*          QTY_PER_PACK(200)  TYPE C, " Quantity Per Package
*          JASS_KBETR TYPE KBETR,     " Assessable value / Rate (condition amount or percentage)
*          JASS_KWERT TYPE KWERT,     " Total Assessable value / Condition base value
*                    JEXQ_KBETR TYPE KBETR,     " Basic Excise Rate (condition amount or percentage)
*                    JEXQ_KAWRT TYPE KAWRT,     " TotaL Duty Payable / Condition base value
*                    JECS_KBETR TYPE KBETR,     " Edu. Cess. Rate (condition amount or percentage)
*                    JECS_KAWRT TYPE KAWRT,     " TotaL Edu. Cess.  / Condition base value
*                    JAIX_KBETR TYPE KBETR,     " H. E. Cess. Rate (condition amount or percentage)
*                    JAIX_KAWRT TYPE KBETR,     " Total H. E. Cess. / Condition base value
*          ZR00_KBETR TYPE KBETR,      " Rate Per Unit / Rate (condition amount or percentage)
*          ZR00_KWERT TYPE KWERT,      " Amount / Condition base value
*          BEDRATE      TYPE J_1IBEDRAT,    " Rate of duty / BED percentage
*          EXBED        TYPE J_1IEXCBED,    " TotaL Duty Payable / Basic Excise Duty
*          ECS          TYPE J_1IEXECS,     " ECS Value
*          ECSRATE      TYPE J_1IECSRAT,    " ECS rate  in %
*          EXADDRATE1  TYPE J_1IEXADDRAT1, " H.E. Cess. rate / AT1 rate in %
*          EXADDTAX1    TYPE J_1IEXADDTAX1, " Additional Tax1 value
*           added by Marmik - 04.02.2011
          ritem2   TYPE j_1iritem2, " Ref Item 2
*           done
        END OF t_item,


        BEGIN OF t_item_konv,
          kposn TYPE  kposn,        " Condition item number
          kschl TYPE  kschl,        " Condition Type
          kbetr TYPE  kbetr,        " Rate (condition amount or percentage)
          waers TYPE  waers,
          kstat	TYPE  kstat,        " Condition is used for statistics
          kwert TYPE  kwert,        " Condition value
        END OF t_item_konv,

        BEGIN OF t_condtn,
          sqno      TYPE i,
          kschl     TYPE kscha,
          kwert     TYPE kwert,
          kbetr     TYPE kbetr_kond,
          waers     TYPE waers,
          descr(30) TYPE c,
        END OF t_condtn,

        BEGIN OF t_vbrp,
          matnr TYPE matnr,       " Material Number
          arktx	TYPE arktx,       " sales order item
          matkl TYPE matkl,       " Material Group
          ntgew TYPE ntgew_15,   " Net Weight
          brgew TYPE brgew,       " Gross Weight
          gewei TYPE gewei,       " Weight Unit
          vgbel	TYPE vgbel,       " number of the reference document
          aubel TYPE vbeln_va,   " Sales Document
        END OF t_vbrp,

        BEGIN OF t_mara,
          matnr TYPE matnr,
          ntgew TYPE ntgew,
          gewei TYPE gewei,
        END OF t_mara,

        BEGIN OF t_j_1iexchdr,
          docno TYPE j_1idocno,
        END OF t_j_1iexchdr,

        BEGIN OF t_j_1iexcdtl,
          docno TYPE j_1idocno,
          exbas TYPE j_1iexcbas,
        END OF t_j_1iexcdtl,

        BEGIN OF t_addr,
          title	     TYPE ad_title	  , " Form-of-Address Key
          name1	     TYPE ad_name1	  , " Name 1
          name2	     TYPE ad_name2	  , " Name 2
          city1	     TYPE ad_city1	  , " City
          post_code1 TYPE ad_pstcd1  , " City postal code
          po_box     TYPE ad_pobx    , " PO Box
          street     TYPE ad_street  , " Street
          house_num1 TYPE ad_hsnm1   , " House Number
          country    TYPE land1      , " Country Key
        END OF t_addr,

        tab_t_j_1iexchdr TYPE TABLE OF t_j_1iexchdr,
        tab_t_j_1iexcdtl TYPE TABLE OF t_j_1iexcdtl,
        tab_t_items      TYPE TABLE OF t_item,
        tab_t_items_konv TYPE TABLE OF t_item_konv,
        tab_t_condtn     TYPE TABLE OF t_condtn,
        tab_t_vbrp       TYPE TABLE OF t_vbrp,
        tab_t_mara       TYPE TABLE OF t_mara.
