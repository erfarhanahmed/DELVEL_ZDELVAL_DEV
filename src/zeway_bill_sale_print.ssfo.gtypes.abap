
TYPES : BEGIN OF lty_final,
          bukrs                  TYPE vbrk-bukrs,
          selection              TYPE char1,
          process_status(70)     TYPE c,
          status_description(20) TYPE c,
          vbeln                  TYPE vbrk-vbeln,
          fkart                  TYPE vbrk-fkart,
          fkdat                  TYPE vbrk-fkdat,
          bupla                  TYPE vbrk-bupla,
*****          transmode             TYPE ZTRANS_MODE,
          eway_bil               TYPE zeway_number-eway_bill,
          conway_bil             TYPE zeway_number-conewayno,
          eway_dt                TYPE zeway_number-ewaybilldate,
          vdfmtime               TYPE zeway_number-vdfmtime,
          eway_dt_exp            TYPE zeway_number-validuptodate,
          vdtotime               TYPE zeway_number-vdtotime,
          message                TYPE zeway_number-message,
          veh_no                 TYPE zeway_bill-vehical_no,
          werks                  TYPE vbrp-werks,
          vkorg                  TYPE vbrk-vkorg,
          created_by             TYPE sy-uname,
          created_dt             TYPE sy-datum,
          created_time           TYPE sy-uzeit,
          canreason              TYPE string,"zcanreason,
          canceldt               TYPE zcanceldt,
          cancelremark           TYPE zeway_number-cancelremark,
          cancel_doc             TYPE sfakn,
          irn_no                 TYPE j_1ig_irn,
          stcd3                  TYPE stcd3,
          to_gstin               TYPE stcd3,
        END OF lty_final.

TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
          fkdat TYPE vbrk-fkdat,
          bukrs TYPE vbrk-bukrs,
          vkorg TYPE vbrk-vkorg,
          bupla TYPE vbrk-bupla,
        END OF ty_vbrk.

TYPES : BEGIN OF lty_itemlist,
          itemno        TYPE string,
          productname   TYPE string,               ":"ELECTRICAL & MECHANICAL",
          productdesc   TYPE string,                   ":"SPG.STEEL 50 CRV4 90X25,R T/2",
          hsncode       TYPE string,                        ":72282000,
          quantity      TYPE vbrp-FKIMG,                               ":1,
          qtyunit       TYPE string,                             ":"TON",
          taxableamount TYPE vbrp-NETWR,                               ":100,
          sgstrate      TYPE konv-kbetr,                                       ":5,
          cgstrate      TYPE konv-kbetr,                                         ":5,
          igstrate      TYPE konv-kbetr,                                       ":0,
          cessrate      TYPE konv-kbetr,                                     ":0,
          cessnonadvol  TYPE vbrp-NETWR,                                           ":0
        END OF lty_itemlist.


TYPES : BEGIN OF lty_json,
*****          usergstin             TYPE string,  Excelon
          zstyp                 TYPE string,         ":"O",
          subsupplytype         TYPE string , "string,  ":1,
          subSupplyDesc         TYPE string,
          doctype               TYPE string,    ":"INV",
          docno                 TYPE string,      ":"90171519",
          docdate               TYPE string,      ":"11/09/2019",
          fromgstin             TYPE string,        ":"23AAACJ3929N1ZE",
          fromtrdname           TYPE string,        ":"JAMNA AUTO INDUSTRIES",
          fromaddr1             TYPE string,            ":"",
          fromaddr2             TYPE string,          ":"",
          fromplace             TYPE string,          ":"",
          frompincode           TYPE string,                ":477117,
          fromstatecode         TYPE string,              ":23,
          actfromstatecode      TYPE string,                ":23,
          togstin               TYPE string,                ":"33AAACA4651L1ZT",
          totrdname             TYPE string,                ":"",
          toaddr1               TYPE string,                ":"",
          toaddr2               TYPE string,                  ":"",
          toplace               TYPE string,                  ":"",
          topincode             TYPE string,                ":477177,
          tostatecode           TYPE string,                          ":33,
          acttostatecode        TYPE string,                        ":33,
          totalvalue            TYPE konv-kwert,                    ":341.1,
          transactiontype       TYPE string,
          cgstvalue             TYPE konv-kwert,                            ":17.06,
          sgstvalue             TYPE konv-kwert,                        ":17.06,
          igstvalue             TYPE konv-kwert,
          cessvalue             TYPE string,                      ":0,
          totnonadvolval        TYPE string,                            ":0,
          othvalue              TYPE konv-kwert,                            ":0,
          totinvvalue           TYPE konv-kwert,                        ":375.21,
          transmode             TYPE string,                            ":1,
          transdistance         TYPE string,                          ":250,
          transportername       TYPE string,                              ":"",
          transporterid         TYPE string,                                ":"",
          transdocno            TYPE string,                                  ":"",
          transdocdate          TYPE string,                              ":"12/09/2019",
          vehicleno             TYPE string,                            ":"MH12CR3213",
          vehicletype           TYPE string,                                ":"R",
          mainhsncode           TYPE string,
          shiptogstin           TYPE string,
          shiptotradename       TYPE string,
          dispatchfromgstin     TYPE string,
          dispatchfromtradename TYPE string,
          eway                  TYPE string,
          gen_date              TYPE string,
          gen_time              TYPE string,
          gen_by                TYPE string,
          valid_to              TYPE string,
        END OF lty_json.

TYPES : BEGIN OF ls_final,
          supply_type(40)  TYPE c,
          sub_type(40)     TYPE c,
          subSupplyDesc    TYPE string,
          doc_type(40)     TYPE c,
          doc_no           TYPE vbrk-vbeln,
          posnr            TYPE vbrp-posnr,
          xblnr            TYPE  vbrk-xblnr,
          doc_date(40)     TYPE c,
          name1            TYPE string, "adrc-name1,
          gstin(40)        TYPE c,
          from_state       TYPE regio,
          street           TYPE adrc-street,
          str_suppl3       TYPE adrc-str_suppl3,
          location         TYPE string,
          country          TYPE adrc-country,
          city             TYPE adrc-city1,
          post_code1       TYPE adrc-post_code1,
          region           TYPE adrc-region,
          ship_to_party    TYPE kna1-name1,
          to_gstin         TYPE kna1-stcd3,
          to_add1          TYPE string,
          to_add2          TYPE string,
          to_place         TYPE kna1-ort01,
          to_pincode       TYPE kna1-pstlz,
          to_state         TYPE regio, "t005u-bezei,
          line_item        TYPE string, "VBRP-MATNR,
          item_code        TYPE vbrp-arktx,
          hsn_sac          TYPE marc-steuc,
          uqc              TYPE vbrp-vrkme, "VBRP-MEINS,
          quantity         TYPE string, " vbrp-fkimg,
          taxable_value    TYPE string, "vbrp-netwr,
          total_gst_rate   TYPE string,
          cgst_amt         TYPE string,        "KONV-KWERT,
          cgst_rate        TYPE string,        "KONV-KBETR,
          sgst_amt         TYPE string,        "KONV-KWERT,
          sgst_rate        TYPE string, "KONV-KBETR,
          igst_amt         TYPE string, "KONV-KWERT,
          igst_rate        TYPE string, "KONV-KBETR,
          cess_amt         TYPE string, "KONV-KWERT,
          cess_rate        TYPE string, "KONV-KBETR,
          trans_mode(40)   TYPE c,
          distance_level   TYPE kna1-locco,
          trans_name(40)   TYPE c,
          trans_id(40)     TYPE c,
          trans_doc_no(40) TYPE c,
          trans_date(40)   TYPE c,
          vehicle_no       TYPE string,
          error_list(40)   TYPE c,
          total_val        TYPE string, "vbrp-netwr,
          discount         TYPE string, "vbrp-netwr,
          transport_id     TYPE kna1-bahne,
          transport_name   TYPE adrct-remark,
          order_type       TYPE vbrk-fkart,
          sales_order_type TYPE vbak-auart,
          material         TYPE vbrp-matnr,
          arktx            TYPE vbrp-arktx,
          remark           TYPE adrct-remark,
          eway_no          TYPE char20,
          cust_mat         TYPE vbap-kdmat,
          ewd_date         TYPE budat,
          assess_value     TYPE dmbtr,
          othvalue         TYPE string,                            ":0,
        END OF ls_final.

TYPES : BEGIN OF ty_vbrk1,
          vbeln TYPE vbrk-vbeln,      " Billing Document
          fkart TYPE vbrk-fkart,      " Billing Type
          waerk TYPE vbrk-waerk,      " SD Document Currency
          vkorg TYPE vbrk-vkorg,      " Sales Organisation
          kalsm TYPE vbrk-kalsm,      " Pricing Procedure in Pricing
          knumv TYPE vbrk-knumv,      " Document condition
          fkdat TYPE vbrk-fkdat,      " Billing Date
          kurrf TYPE vbrk-kurrf,      " Exchange rate for FI postings
          bukrs TYPE vbrk-bukrs,      " Company Code
          taxk6 TYPE vbrk-taxk6,
          netwr TYPE vbrk-netwr,
          mwsbk TYPE vbrk-mwsbk,
          kunag TYPE vbrk-kunag,      " Sold-to party
          sfakn TYPE vbrk-sfakn,      " Cancelled billing document number
          xblnr TYPE vbrk-xblnr,      " Reference Document Number
          bupla TYPE vbrk-bupla,
        END OF ty_vbrk1.

TYPES : BEGIN OF ls_vbrp,
          vbeln TYPE vbrp-vbeln,      " Billing Document
          posnr TYPE vbrp-posnr,      " Billing item
          matnr TYPE vbrp-matnr,      " Material
          arktx TYPE vbrp-arktx,      " Short text for sales order item
          fkimg TYPE vbrp-fkimg,      " Actual Invoiced Quantity
          netwr TYPE vbrp-netwr,      " Net value of the billing item
          meins TYPE vbrp-meins,      " Base Unit of Measure
          aubel TYPE vbrp-aubel,      " Sales Document
          kursk TYPE vbrp-kursk,      " Exchange Rate
          werks TYPE vbrp-werks,
          vrkme TYPE vbrp-vrkme, "added by st
          vgbel TYPE vbrp-vgbel, "added by st
        END OF ls_vbrp.

TYPES : BEGIN OF ls_marc,
          matnr TYPE marc-matnr,      " Material
          werks TYPE marc-werks,
          steuc TYPE marc-steuc,      " Control Data
        END OF ls_marc.

TYPES: BEGIN OF ty_prcd,
         knumv TYPE Konv-knumv,        " Number of the document condition
         kposn TYPE Konv-kposn,        " Condition item number
         kschl TYPE Konv-kschl,        " Condition type
         kwert TYPE Konv-kwert,        " Condition Value
         kbetr TYPE Konv-kbetr,        " Rate
         kawrt TYPE Konv-kawrt,        " Condition base value
*        kursk TYPE konv-kursk,
       END OF ty_prcd.

TYPES: BEGIN OF ty_vbfa,
         vbelv   TYPE vbfa-vbelv,     " Preceding sales and distribution document
         posnv   TYPE vbfa-posnv,     " Preceding item of an SD document
         vbeln   TYPE vbfa-vbeln,     " Subsequent sales and distribution document
         posnn   TYPE vbfa-posnn,     " Subsequent item of an SD document
         vbtyp_v TYPE vbfa-vbtyp_v,   " Document category
         matnr   TYPE vbfa-matnr,     " Material Number
       END OF ty_vbfa.
TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,               " Customer Number
          name1 TYPE kna1-name1,               " Name
          locco TYPE kna1-locco,               " City
          stcd3 TYPE kna1-stcd3,               " Tax Number 3
          ort01 TYPE kna1-ort01,               " City
          pstlz TYPE kna1-pstlz,               " Postal Code
          land1 TYPE kna1-land1,               " Land
          regio TYPE kna1-regio,               " Region
          bahne TYPE kna1-bahne,               " Express train station
          adrnr TYPE kna1-adrnr,               " Address Number
          werks TYPE kna1-werks,               " Plant
          ktokd TYPE kna1-ktokd,               " Account group
        END OF ty_kna1.
TYPES : BEGIN OF ty_t001,
          bukrs TYPE t001-bukrs,              " Company Code
          adrnr TYPE t001-adrnr,              " Address Number
          END OF ty_t001.

TYPES : BEGIN OF ty_adrc,
          addrnumber TYPE adrc-addrnumber,       " Address Number
          name1      TYPE adrc-name1,            " Name
          street     TYPE adrc-street,           " Street
          str_suppl1 TYPE adrc-str_suppl1,       " Street 1
          str_suppl2 TYPE adrc-str_suppl1,       " Street 2
          str_suppl3 TYPE adrc-location,         " Street 3
          location   TYPE adrc-location,         " Location
          country    TYPE adrc-country,          " Country
          city1      TYPE adrc-city1,            " City
          post_code1 TYPE adrc-post_code1,       " Postal Code
          region     TYPE adrc-region,           " Region
          city2      TYPE adrc-city2,            " City
        END OF ty_adrc.

TYPES : BEGIN OF ty_t001w,
          werks TYPE t001w-werks,
          pstlz TYPE t001w-pstlz,
          spras TYPE t001w-spras,
          land1 TYPE t001w-land1,
          regio TYPE t001w-regio,
          adrnr TYPE t001w-adrnr,
        END OF ty_t001w.

TYPES : BEGIN OF ty_t005u,
          spras TYPE t005u-spras,
          land1 TYPE t005u-land1,
          bland TYPE t005u-bland,
          bezei TYPE t005u-bezei,
        END OF ty_t005u.
TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,         " Sales Document
         auart TYPE vbak-auart,         " Sales Document Type
       END OF ty_vbak.

TYPES: BEGIN OF ty_vbap,
         vbeln TYPE vbap-vbeln,         " Sales Document
         posnr TYPE vbap-posnr,         " Sales Document Item
         kdmat TYPE vbap-kdmat,         " Material Number Used by Customer
       END OF ty_vbap.

TYPES : BEGIN OF ty_adrct,
          addrnumber TYPE adrct-addrnumber,  " Address Number
          remark     TYPE adrct-remark,      " Remark
        END OF ty_adrct.

TYPES:BEGIN OF ty_data,
      BUKRS        TYPE ZEWAY_BILL-BUKRS,
      VBELN        TYPE ZEWAY_BILL-VBELN ,
      VERSION      TYPE ZEWAY_BILL-VERSION,
      TRNS_MD      TYPE ZEWAY_BILL-TRNS_MD ,
      TRANS_DOC    TYPE ZEWAY_BILL-TRANS_DOC,
      LIFNR        TYPE ZEWAY_BILL-LIFNR,
      DOC_DT       TYPE ZEWAY_BILL-DOC_DT,
      TRANS_ID     TYPE ZEWAY_BILL-TRANS_ID,
      TRANS_NAME   TYPE ZEWAY_BILL-TRANS_NAME,
      VEHICAL_NO   TYPE ZEWAY_BILL-VEHICAL_NO,
      VEHICAL_TYPE TYPE ZEWAY_BILL-VEHICAL_TYPE,
      DISTANCE     TYPE ZEWAY_BILL-DISTANCE,
      UPDATEBY     TYPE ZEWAY_BILL-UPDATEBY,
      UPDATEDT     TYPE ZEWAY_BILL-UPDATEDT ,
      UPDATETIME   TYPE ZEWAY_BILL-UPDATETIME ,
      FROMPLACE    TYPE ZEWAY_BILL-FROMPLACE,
      FROMSTATECODE TYPE ZEWAY_BILL-FROMSTATECODE,
      END OF ty_data.

TYPES : BEGIN OF ty_extend,
        EWAY_BILL     TYPE ZEWAYEXTEND-EWAY_BILL    ,
        VERSION       TYPE ZEWAYEXTEND-VERSION      ,
        FROMPLACE     TYPE ZEWAYEXTEND-FROMPLACE    ,
        REMAINDISTANCE TYPE ZEWAYEXTEND-REMAINDISTANCE,
        VALIDUPTODATE TYPE ZEWAYEXTEND-VALIDUPTODATE,
        VALIDUPTOTIME TYPE ZEWAYEXTEND-VALIDUPTOTIME,
        EXTNDATE      TYPE ZEWAYEXTEND-EXTNDATE     ,
        EXTNTIME      TYPE ZEWAYEXTEND-EXTNTIME     ,
        END OF ty_extend.

TYPES: BEGIN OF ty_multi,
       VERSION      TYPE ZEWAY_MULTI_ADD-VERSION     ,
       EWAY_BILL    TYPE ZEWAY_MULTI_ADD-EWAY_BILL   ,
       GROUP1       TYPE ZEWAY_MULTI_ADD-GROUP1      ,
       VEHICAL_NO   TYPE ZEWAY_MULTI_ADD-VEHICAL_NO  ,
       TRANS_DOC    TYPE ZEWAY_MULTI_ADD-TRANS_DOC   ,
       QTY          TYPE ZEWAY_MULTI_ADD-QTY         ,
       CR_DATE      TYPE ZEWAY_MULTI_ADD-CR_DATE     ,
       VEHADDEDDATE TYPE ZEWAY_MULTI_ADD-VEHADDEDDATE,
       VEHADDEDTIME TYPE ZEWAY_MULTI_ADD-VEHADDEDTIME,
       DOC_DT       TYPE ZEWAY_MULTI_ADD-DOC_DT,
       END OF ty_multi.
