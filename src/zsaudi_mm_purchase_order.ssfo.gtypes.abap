TYPES : BEGIN OF ty_hdr,

          ebeln         TYPE ebeln,       " Purchasing Document Number
          bsart	        TYPE esart,       " Purchasing Document Type
          bukrs	        TYPE bukrs,       " Company Code
          werks	        TYPE ewerk,       " Plant
          lifnr	        TYPE elifn,       " Vendor Account Number
          zterm	        TYPE dzterm,      "	Terms of Payment Key
          waers	        TYPE waers,       " Currency Key
          inco1	        TYPE inco1,       "	Incoterms (Part 1)
          inco2	        TYPE inco2,       "	Incoterms (Part 2)
          knumv	        TYPE knumv,       "	Number of the document condition
          regio         TYPE regio, "region
          aedat	        TYPE CHAR30,       " Date on Which Record Was Created
          zbd1t	        TYPE dzbdet,      " Cash (Prompt Payment) Discount Days
          eindt         TYPE eindt,       " Delivery Date
          slfdt	        TYPE slfdt,        " Statistics-Relevant Delivery Date
          stcd3         TYPE stcd3, " TAX
          j_1iexrn      TYPE j_1iexrn,    " Excise Registration Number
          j_1iexrg      TYPE j_1iexrg,    " Excise Range
          j_1iexdi      TYPE j_1iexdi,    " Excise Division
          j_1iexco      TYPE j_1iexco,    " Excise Commissionerate
          j_1isern      TYPE j_1isern,    " TIN nO./Service Tax Registration Number
          j_1icstno	    TYPE j_1icstno,   " Central Sales Tax Number
          j_1ilstno     TYPE j_1ilstno,   " Local Sales Tax Number
          j_1icstdt(10) TYPE c,       " CST-Date
          j_1ilstdt(10) TYPE c,       " LST-Date
          ekorg         TYPE ekorg,
          butxt         TYPE butxt,       " Name Of Company Code Or Company
          v_name1       TYPE name1_gp,    " Vendor Name
          mp_adrnr      TYPE adrnr,       " Main Plant Address_number
          p_adrnr       TYPE adrnr,       " Plant Address
          v_adrnr       TYPE adrnr,       " Vendor Address Number
          po_note       TYPE string,
          banfn         TYPE banfn,       " Purchase Requisition Number
          udate         TYPE cddatum,     "  Creation date of the change document
          zterm_txt     TYPE t052u-text1,   " Payment-terms Text
*          zterm_txt     TYPE j_3rt53apaymtx,   " Payment-terms Text
          CONSNUMBER    type adr6-CONSNUMBER,
          LV_WORD      TYPE Char255,
          GV_DELIVERY  TYPE char255,
          GV_PAYMENT   TYPE Char255,
          BEDAT        TYPE CHAR10,
         END OF ty_hdr,

        BEGIN OF ty_item,
          ebelp   TYPE ebelp,        " Item Number of Purchasing Document
          matnr   TYPE matnr,        " Material Number
          txz01   TYPE txz01,        "  Short Text
          "MAKTX    TYPE MAKTX,       " Material Description (Short Text)
          werks   TYPE ewerk,        " Plant
          menge   TYPE bstmg,        " Purchase Order Quantity
          meins   TYPE bstme,        " Purchase Order Unit of Measure
          netpr   TYPE bprei,        " Net Price in Purchasing Document (in Document Currency)
          netwr   TYPE bwert,        " Net Order Value in PO Currency
          ntgew   TYPE entge,        " Net Weight
          gewei   TYPE egewe,        " Unit of Weight
          banfn   TYPE banfn,        " Purchase Requisition Number
          mwskz   TYPE mwskz,
          eindt   TYPE eindt,        "  Item Delivery Date
          slfdt    TYPE slfdt,        " Statistics-Relevant Delivery Date
          zeinr   TYPE dzeinr,       "  Document number (without document management system)

          vbeln   TYPE vbeln,        " Sales Order Number
          vbelp   TYPE vbelp,        " Sales Order Item NUmber
          itm_txt TYPE string,
          adtxt   TYPE string,
          zeivr   TYPE mara-zeivr,
        END OF ty_item,

*        BEGIN OF TY_MAKT,
*          MATNR  TYPE MATNR,
*          MAKTX  TYPE MAKTX,
*        END OF TY_MAKT,

        " structure declaration for address "
        BEGIN OF ty_adrc,
          addrnumber TYPE ad_addrnum, " ADDRESS NO"
*          name_co    TYPE ad_name_co, " COMPANY NAME  "
          name1      TYPE adrc-name1,
          city1      TYPE ad_city1, " CITY1 "
          post_code1 TYPE ad_pstcd1, " POSTCODE 1 "
          street     TYPE ad_street, " STREET "
*           time_zone  TYPE ad_tzone, " TIME ZONE(COUNTRY) "
*          bezei      TYPE bezei20,    " REGION DESRIPTION "
          country    TYPE adrc-country,
          tel_number TYPE adrc-tel_number,
          fax_number TYPE adrc-fax_number,
          extension2 TYPE adrc-extension2,
          smtp_addr  TYPE adr6-smtp_addr,
          landx      TYPE t005t-landx,  "Country name
          cin        TYPE adrct-remark,
        END OF ty_adrc,


        BEGIN OF ty_mara,
          matnr TYPE matnr,
          zeinr	TYPE dzeinr,    " Document number (without document management system)
          ntgew TYPE entge,     " Net Weight
          gewei TYPE egewe,     " Unit of Weight
          dev_status TYPE mara-DEV_STATUS,
        END OF ty_mara,

        BEGIN OF ty_konv,
          sq_no TYPE i,
          kschl TYPE kscha,
          kbetr TYPE string, "KBETR, "  Rate (condition amount or percentage)
          waers	TYPE waers, "	Currency Key
          descr TYPE text30,  "vtext,
          kwert TYPE kwert,
        END OF ty_konv,


        ty_tab_items     TYPE TABLE OF ty_item,
        ty_tab_mara      TYPE TABLE OF ty_mara,
*        TY_TAB_MAKT TYPE TABLE OF TY_MAKT
        ty_tab_konv      TYPE TABLE OF ty_konv,
        ty_tab_item_konv TYPE TABLE OF komv,

        ty_text_lines1   TYPE TABLE OF tline.
TYPES :
  BEGIN OF t_conditions,
    knumv TYPE konv-knumv,
    kposn TYPE konv-kposn,
    kschl TYPE konv-kschl,
    kwert TYPE konv-kwert,
    kbetr TYPE komv-kbetr,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

 "Added BY Snehal Rajale On 31.12.2020
  TYPES : BEGIN OF ty_ekpo,
            EBELN TYPE ekpo-ebeln,
            EBELP TYPE ekpo-ebelp,
            knttp TYPE ekpo-knttp,
         END OF ty_ekpo.

 TYPES : BEGIN OF ty_makt,
            MATNR TYPE makt-matnr,
            SPRAS TYPE makt-spras,
            MAKTX TYPE makt-maktx,
         END OF ty_makt.

TYPES : BEGIN OF ty_ekkn,
          EBELN TYPE ekkn-ebeln,
          EBELP TYPE ekkn-ebelp,
          ZEKKN TYPE ekkn-zekkn,
          VBELN TYPE ekkn-vbeln,
          VBELP TYPE ekkn-vbelp,
        END OF ty_ekkn.

TYPES :   BEGIN OF ty_vbap,
            vbeln TYPE vbap-vbeln,
            posnr TYPE vbap-posnr,
            zce TYPE vbap-zce,
            ZGAD TYPE vbap-zgad,
         END OF ty_vbap.

TYPES : BEGIN OF ty_marc,
         MATNR TYPE marc-matnr,
         WERKS TYPE marc-werks,
         dispo TYPE marc-dispo,
       END OF ty_marc.

TYPES : BEGIN OF TY_CDPOS,
  OBJECTID TYPE CDPOS-OBJECTID,
  CHANGENR TYPE CDPOS-CHANGENR,
  VALUE_OLD TYPE CDPOS-VALUE_OLD,
  END OF TY_CDPOS.

  TYPES : BEGIN OF TY_CDHDR,
  OBJECTID TYPE CDPOS-OBJECTID,
  CHANGENR TYPE CDPOS-CHANGENR,
  END OF TY_CDHDR.
