TYPES : BEGIN OF t_hdr,
  VBELN	          TYPE VBELN_VL,       " Delivery
  KNUMV           TYPE KNUMV,          " Number of the document condition
  INCO2           TYPE INCO2,          " Transporter/ Incoterms (Part 2)
  FKART           TYPE FKART,          " Billing Type

  TRNTYP          TYPE J_1ITRNTYP,     " Excise Transaction Type
  DOCYR           TYPE J_1IDOCUYR,     " Year
  DOCNO           TYPE J_1IDOCNO,      " Internal Excise Document Number
  EXDAT           TYPE J_1IEXCDAT,     " Excise Document Date
  "EXYEAR         TYPE J_1IEXYEAR,     " Excise Year
  REMTIME         TYPE J_1IREMTIM,     " Time of Removal
  CPUTM           TYPE sy-uzeit,       " CPU Time
  BUKRS           TYPE BUKRS,          " Company Code
  WERKS           TYPE WERKS_D,        " Plant
  EXNUM           TYPE J_1IEXCNUM,     " Official Excise Document Number / J_1IEXCHDR
  LIFNR           TYPE LIFNR,          " Account Number of Vendor or Creditor
  RCWRK           TYPE UMWRK,          " Receiving/Issuing Plant
  EXCUR           TYPE J_1IEXCCUR,     " Currency
*  KUNAG           TYPE KUNAG,         " Sold-to party
*  KUNWE           TYPE KUNWE,         " Ship-to party
  EXBED           TYPE J_1IEXCBED,     " Basic Excise Duty
  ECS             TYPE J_1IEXECS,      " ECS Duty
  EXADDTAX1       TYPE J_1IEXADDTAX1,	 " Additional Tax1 value


  J_1IEXRN        TYPE J_1IEXRN,       " Excise Registration Number
  J_1IEXRG        TYPE J_1IEXRG,       " Excise Range
  J_1IEXDI        TYPE J_1IEXDI,       " Excise Division
  J_1IEXCO        TYPE J_1IEXCO,       " Excise Commissionerate
  J_1ISERN        TYPE J_1ISERN,       " tin nO./Service Tax Registration Number
  J_1ICSTNO       TYPE J_1ICSTNO,      " Central Sales Tax Number
  J_1ILSTNO       TYPE J_1ILSTNO,      " Local Sales Tax Number

  BUTXT           TYPE BUTXT,           " Name of Company Code or Company
  NAME1           TYPE NAME1,           " Name of plant
  ORT01           TYPE ORT01,           " Plant - city
  ADRNR           TYPE ADRNR,           " Plant - Address
  EMAIL           TYPE AD_SMTPADR,      " Plant - E-mail
  URL             TYPE AD_URI,          " Universal Resource Identifier (URI)
  LIFNR_ADRNR     TYPE ADRNR,           " Vendor - Address Number
*  KUNAG_ADRNR     TYPE ADRNR,           " Sold-To-Party - Address Number
*  KUNWE_ADRNR     TYPE ADRNR,           " Ship-To-Party - Address Number
*  KUNWE_ORT01     TYPE ORT01_GP,        " Ship-To-Party - city
*  KUNAG_J_1IEXCD  TYPE J_1IEXCD,        " ECC Number
*  KUNAG_J_1ICSTNO TYPE J_1ICSTNO,       " Central Sales Tax Number
*  KUNAG_J_1ILSTNO TYPE J_1ILSTNO,       " TIN Number/ Local Sales Tax Number

  LIFNR_J_1IEXCD  TYPE J_1IEXCD,        " Vendor - ECC Number
  LIFNR_J_1ICSTNO TYPE J_1ICSTNO,       " Vendor - Central Sales Tax Number
  LIFNR_J_1ILSTNO TYPE J_1ILSTNO,       " Vendor - TIN Number/ Local Sales Tax Number


  GEWEI           TYPE GEWEI,           " Weight Unit
  EDU_CESS_RATE   TYPE J_1IECSRAT,      " Edu. Cess Rate
  H_E_CESS_RATE   TYPE J_1IEXADDRAT1,   " H.E.Cess Rate
  RGPLASER        TYPE J_1IPLASER,      " PLA serial no.

  EBELN	          TYPE EBELN,           "	Purchasing Document Number
  BEDAT           TYPE EBDAT,           " Purchasing Document Date
*  SUPPLIER        TYPE VTEXT,           " Supplier
*  TRNSPRT_MODE    TYPE VTEXT,           " Mode of Transport
  TRNSPRTR        TYPE VTEXT,           " Transporter
  L_R_NO          TYPE VTEXT,           " L.R.No.
  VHICL           TYPE VTEXT,           " Vehicle No.
  FREIGHT         TYPE VTEXT,           " Freight
  TRNSPRT_DT      TYPE VTEXT,           " Transport Date
  CHALLAN         TYPE VTEXT,           " Invoice/challan Info.
END OF t_hdr,

BEGIN OF T_ITEM,
  ZEILE           TYPE  J_1IZEILE, " Item Number
  MATNR           TYPE  MATNR,     " Material Number
  MENGE           TYPE  J_1IMENGE, " Quantity mentioned in the excise invoice
  MEINS           TYPE  J_1IMEINS, " Unit of measure
  "EBELN           TYPE  BSTNR,     " Purchase Order Number
  EBELP           TYPE  EBELP,     " Item Number of Purchasing Document

  MAKTX           TYPE  MAKTX,     " Material Description (Short Text)
  NETPR	          TYPE  BPREI,     " Net Price in Purchasing Document (in Document Currency)
  NETWR           TYPE  NUM20,     " Unit-Rate x Quantity








*ZEILE
**          SHIPFROM  TYPE  LIFNR,     " Account Number of Vendor or Creditor
**          RCWRK      TYPE  UMWRK,     " Receiving/Issuing Plant
*MATNR
*MATKL      TYPE  MATKL,     " Material Group
*MAKTX      TYPE  MAKTX,     " Material Description (Short Text)
*MENGE
*MEINS
*RGPLASER  TYPE  J_1IPLASER," PLA serial no.
*NTGEW      TYPE  NTGEW_15,  " Net Weight
*BRGEW      TYPE  BRGEW_15,  " Gross weight
*GEWEI      TYPE  GEWEI,     " Weight Unit
*KBETR       TYPE KBETR,      " Rate Per Unit / Rate (condition amount or percentage)
*KWERT       TYPE KWERT,      " Amount / Condition base value
"MRK_PKG    TYPE  J_1IMRK_PKG, " Marks on Package
"NOS_ON_PKG TYPE J_1INOS_ON_PKG, " Numbers on Package
*QTY_PER_PACK(200)  TYPE C, " Quantity Per Package
*JASS_KBETR TYPE KBETR,     " Assessable value / Rate (condition amount or percentage)
*JASS_KWERT TYPE KWERT,     " Total Assessable value / Condition base value
*          JEXQ_KBETR TYPE KBETR,     " Basic Excise Rate (condition amount or percentage)
*          JEXQ_KAWRT TYPE KAWRT,     " TotaL Duty Payable / Condition base value
*          JECS_KBETR TYPE KBETR,     " Edu. Cess. Rate (condition amount or percentage)
*          JECS_KAWRT TYPE KAWRT,     " TotaL Edu. Cess.  / Condition base value
*          JAIX_KBETR TYPE KBETR,     " H. E. Cess. Rate (condition amount or percentage)
*          JAIX_KAWRT TYPE KBETR,     " Total H. E. Cess. / Condition base value
*ZR00_KBETR TYPE KBETR,      " Rate Per Unit / Rate (condition amount or percentage)
*ZR00_KWERT TYPE KWERT,      " Amount / Condition base value
*BEDRATE      TYPE J_1IBEDRAT,    " Rate of duty / BED percentage
*EXBED        TYPE J_1IEXCBED,    " TotaL Duty Payable / Basic Excise Duty
*ECS          TYPE J_1IEXECS,     " ECS Value
*ECSRATE      TYPE J_1IECSRAT,    " ECS rate  in %
*EXADDRATE1  TYPE J_1IEXADDRAT1, " H.E. Cess. rate / AT1 rate in %
*EXADDTAX1    TYPE J_1IEXADDTAX1, " Additional Tax1 value
* added by Marmik - 04.02.2011
ritem2      type J_1IRITEM2, " Ref Item 2
* done
END OF T_ITEM,


BEGIN OF T_ITEM_KONV,
KPOSN      TYPE  KPOSN,        " Condition item number
KSCHL      TYPE  KSCHL,        " Condition Type
KBETR      TYPE  KBETR,        " Rate (condition amount or percentage)
WAERS       TYPE WAERS,
KWERT      TYPE  KWERT,        " Condition value
END OF T_ITEM_KONV,

BEGIN OF T_CONDTN,
SQNO        TYPE I,
KSCHL       TYPE KSCHA,
KWERT       TYPE KWERT,
KBETR       TYPE KBETR_KOND,
WAERS       TYPE WAERS,
DESCR(30)   TYPE C,
END OF T_CONDTN,

BEGIN OF T_VBRP,
MATNR TYPE MATNR,       " Material Number
ARKTX	TYPE ARKTX,       " sales order item
MATKL TYPE MATKL,       " Material Group
NTGEW  TYPE NTGEW_15,   " Net Weight
BRGEW TYPE BRGEW,       " Gross Weight
GEWEI TYPE GEWEI,       " Weight Unit
"WGBEZ60
AUBEL  TYPE VBELN_VA,   " Sales Document
END OF T_VBRP,

begin of t_mara,
matnr type matnr,
ntgew type NTGEW,
GEWEI TYPE GEWEI,
end of t_mara,

begin of t_J_1IEXCHDR,
DOCNO type J_1IDOCNO,
end of t_J_1IEXCHDR,

begin of t_J_1IEXCDTL,
DOCNO type J_1IDOCNO,
EXBAS type J_1IEXCBAS,
end of t_J_1IEXCDTL,

tab_t_J_1IEXCHDR type table of t_J_1IEXCHDR,
tab_t_J_1IEXCDTL type table of t_J_1IEXCDTL,
TAB_T_ITEMS      TYPE TABLE OF T_ITEM,
TAB_T_ITEMS_KONV TYPE TABLE OF T_ITEM_KONV,
TAB_T_CONDTN     TYPE TABLE OF T_CONDTN,
TAB_T_VBRP       TYPE TABLE OF T_VBRP,
TAB_T_mara       TYPE TABLE OF T_mara,

TY_TAB_ITEM_KONV TYPE TABLE OF KOMV.
