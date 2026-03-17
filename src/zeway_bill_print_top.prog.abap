*&---------------------------------------------------------------------*
*&  Include           Z_EWAYBILL_GENERATION_TOP_V02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           Z_EWAYBILL_GENERATION_TOP
*&---------------------------------------------------------------------*

TABLES : zeway_bill,zeway_number,zeway_multi_veh,zewayextend.


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


DATA : lt_final      TYPE STANDARD TABLE OF lty_final,
       lt_final_temp TYPE STANDARD TABLE OF lty_final,
       ls_final      TYPE lty_final,
       ls_final_temp TYPE lty_final.

FIELD-SYMBOLS : <ls_final> TYPE lty_final.

TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
          fkdat TYPE vbrk-fkdat,
          bukrs TYPE vbrk-bukrs,
          vkorg TYPE vbrk-vkorg,
          bupla TYPE vbrk-bupla,
        END OF ty_vbrk.

DATA : lt_vbrk TYPE TABLE OF ty_vbrk,
       ls_vbrk TYPE ty_vbrk.

DATA : "g_app     TYPE REF TO lcl_events,
       it_fcat   TYPE lvc_t_fcat,                             "Field catalogue
       it_layout TYPE lvc_s_layo.

DATA : ls_exclude TYPE ui_func,
       pt_exclude TYPE ui_functions.

DATA :gt_ewaybill_details TYPE TABLE OF zeway_bill,
      gs_ewaybill_details TYPE zeway_bill,
      gs_ewaybill_screen  TYPE zeway_bill.

DATA :gt_eway_multi_veh    TYPE TABLE OF zeway_multi_veh,
      gs_eway_multi_veh    TYPE zeway_multi_veh,
      gs_eway_multi_screen TYPE zeway_multi_veh.


TYPES : BEGIN OF lty_itemlist,
          itemno        TYPE string,
          productname   TYPE string,               ":"ELECTRICAL & MECHANICAL",
          productdesc   TYPE string,                   ":"SPG.STEEL 50 CRV4 90X25,R T/2",
          hsncode       TYPE string,                        ":72282000,
          quantity      TYPE string,                               ":1,
          qtyunit       TYPE string,                             ":"TON",
          taxableamount TYPE string,                               ":100,
          sgstrate      TYPE string,                                       ":5,
          cgstrate      TYPE string,                                         ":5,
          igstrate      TYPE string,                                       ":0,
          cessrate      TYPE string,                                     ":0,
          cessnonadvol  TYPE string,                                           ":0
        END OF lty_itemlist.

DATA : lt_itemlist TYPE TABLE OF lty_itemlist,
       ls_itemlist TYPE lty_itemlist.




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
          totalvalue            TYPE string,                    ":341.1,
          transactiontype       TYPE string,
          cgstvalue             TYPE string,                            ":17.06,
          sgstvalue             TYPE string,                        ":17.06,
          igstvalue             TYPE string,                    ":0,
          cessvalue             TYPE string,                      ":0,
          totnonadvolval        TYPE string,                            ":0,
          othvalue              TYPE string,                            ":0,
          totinvvalue           TYPE string,                        ":375.21,
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

DATA : lt_final_eway TYPE TABLE OF lty_json,
       ls_final_eway TYPE lty_json.


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

DATA : lt_json_data TYPE TABLE OF ls_final,
       ls_json_data TYPE ls_final.


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
          netwr TYPE vbrk-netwr,
          mwsbk TYPE vbrk-mwsbk,
          kunag TYPE vbrk-kunag,      " Sold-to party
          sfakn TYPE vbrk-sfakn,      " Cancelled billing document number
          xblnr TYPE vbrk-xblnr,      " Reference Document Number
          bupla TYPE vbrk-bupla,
        END OF ty_vbrk1.

DATA  : lt_vbrk_j TYPE TABLE OF ty_vbrk1,
        ls_vbrk_j TYPE          ty_vbrk1.
*---------------Billing Document: Item Data---------------------------------------------*
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

DATA  : lt_vbrp TYPE TABLE OF ls_vbrp,
        wa_vbrp TYPE          ls_vbrp.
*-------------Plant Data for Mat-----------------------
TYPES : BEGIN OF ls_marc,
          matnr TYPE marc-matnr,      " Material
          werks TYPE marc-werks,
          steuc TYPE marc-steuc,      " Control Data
        END OF ls_marc.

DATA  : lt_marc TYPE TABLE OF ls_marc,
        wa_marc TYPE          ls_marc.

DATA : r1,
       r2,
       r3.
*-------------Conditions (Transaction Data)----------------------------
TYPES: BEGIN OF ty_prcd,
         knumv TYPE  prcd_elements-knumv,        " Number of the document condition
         kposn TYPE  prcd_elements-kposn,        " Condition item number
         kschl TYPE  prcd_elements-kschl,        " Condition type
         kwert TYPE  prcd_elements-kwert,        " Condition Value
         kbetr TYPE  prcd_elements-kbetr,        " Rate
         kawrt TYPE  prcd_elements-kawrt,        " Condition base value
*        kursk TYPE konv-kursk,
       END OF ty_prcd.

DATA: lt_prcd TYPE TABLE OF ty_prcd,
      ls_prcd TYPE          ty_prcd.
*---------------Sales Document Flow--------------------------------------------
TYPES: BEGIN OF ty_vbfa,
         vbelv   TYPE vbfa-vbelv,     " Preceding sales and distribution document
         posnv   TYPE vbfa-posnv,     " Preceding item of an SD document
         vbeln   TYPE vbfa-vbeln,     " Subsequent sales and distribution document
         posnn   TYPE vbfa-posnn,     " Subsequent item of an SD document
         vbtyp_v TYPE vbfa-vbtyp_v,   " Document category
         matnr   TYPE vbfa-matnr,     " Material Number
       END OF ty_vbfa.
DATA  : lt_vbfa TYPE TABLE OF ty_vbfa,
        ls_vbfa TYPE          ty_vbfa.

DATA  : lt_vbfa_2 TYPE TABLE OF ty_vbfa,       " Sales Order Type Declaration
        ls_vbfa_2 TYPE          ty_vbfa.
*--------------------------------------------------------------------*
*--------------------Sales Document: Header--------------------------
TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,         " Sales Document
         auart TYPE vbak-auart,         " Sales Document Type
       END OF ty_vbak.
DATA : lt_vbak TYPE TABLE OF ty_vbak,
       ls_vbak TYPE          ty_vbak.
*-----------------Sales Document : Item--------------------------------
TYPES: BEGIN OF ty_vbap,
         vbeln TYPE vbap-vbeln,         " Sales Document
         posnr TYPE vbap-posnr,         " Sales Document Item
         kdmat TYPE vbap-kdmat,         " Material Number Used by Customer
       END OF ty_vbap.
DATA : lt_vbap TYPE TABLE OF ty_vbap,
       ls_vbap TYPE          ty_vbap.
*-----------General Data in Customer Ma------------------------------------------------------------*
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
DATA : lt_kna1 TYPE TABLE OF ty_kna1,
       wa_kna1 TYPE          ty_kna1.
*----------------Address Texts ---------------------------------------------------
TYPES : BEGIN OF ty_adrct,
          addrnumber TYPE adrct-addrnumber,  " Address Number
          remark     TYPE adrct-remark,      " Remark
        END OF ty_adrct.
DATA  : it_adrct TYPE TABLE OF ty_adrct,
        wa_adrct TYPE          ty_adrct.
*-----------------Company Codes-------------------------------------------*
TYPES : BEGIN OF ty_t001,
          bukrs TYPE t001-bukrs,              " Company Code
          adrnr TYPE t001-adrnr,              " Address Number
        END OF ty_t001.
DATA : it_t001 TYPE TABLE OF ty_t001,
       wa_t001 TYPE          ty_t001.
*--------------Addresses -----------------------------------------------*
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
DATA : it_adrc      TYPE TABLE OF ty_adrc,
       wa_adrc      TYPE          ty_adrc,
       it_adrc_cust TYPE TABLE OF ty_adrc,
       wa_adrc_cust TYPE          ty_adrc.

*--------------Add str by sarika thange for postal code and Discription and distance-----------------------------------------------------*
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

TYPES : BEGIN OF ty_zdistance,
          werks         TYPE zdistnace-werks,
          kunnr         TYPE zdistnace-kunnr,
          time_distance TYPE zdistnace-time_distance,
        END OF ty_zdistance.

DATA : it_t001w TYPE TABLE OF ty_t001w,
       wa_t001w TYPE          ty_t001w,
       it_t005u TYPE TABLE OF ty_t005u,
       wa_t005u TYPE          ty_t005u,
       gv_date  TYPE string,
       gv_vkorg TYPE string.


DATA : lt_statecode TYPE TABLE OF j_1istatecdm,
       ls_statecode TYPE j_1istatecdm.

DATA : lt_billingtypes TYPE TABLE OF zbillingtypes,
       ls_billingtypes TYPE zbillingtypes.

DATA : it_zdistance TYPE TABLE OF ty_zdistance,
       wa_zdistance TYPE  ty_zdistance.



DATA:  lv_json   TYPE string.
DATA : o_writer_itab TYPE REF TO cl_sxml_string_writer.
DATA: lv_result TYPE string.
DATA : o_trex TYPE REF TO cl_trex_json_serializer.

TYPES : BEGIN OF ty_json_output,
          line(255) TYPE c,
        END OF ty_json_output.



DATA :
  it_json        TYPE TABLE OF zeinv_json,
  it_json_in     TYPE TABLE OF zeinv_json,
  ls_json        TYPE zeinv_json,
  lt_json_output TYPE STANDARD TABLE OF ty_json_output,
  ls_json_output TYPE ty_json_output,
  p_lines        TYPE i VALUE 0,
  count          TYPE i VALUE 0.

DATA : ls_str TYPE string.

TYPES : BEGIN OF lty_response,
          line(3000) TYPE c,
        END OF lty_response.


TYPES : BEGIN OF lty_res,
          header TYPE string,
          value  TYPE string,
        END OF lty_res.

DATA : lt_res TYPE STANDARD TABLE OF lty_res,
       ls_res TYPE lty_res.


DATA : lt_res_up TYPE STANDARD TABLE OF lty_res,
       ls_res_up TYPE lty_res.



DATA: lv_string  TYPE string,
      lv_flag(1) TYPE c.

DATA: lt_response TYPE STANDARD TABLE OF lty_response,
      ls_response TYPE lty_response.


DATA : ls_zeinv_res TYPE zeinv_res.

DATA : ls_vbeln TYPE xblnr."vbeln.

DATA : lv_resp_status TYPE string.

DATA : ls_output TYPE string.
DATA : file_name TYPE string.

DATA : lv_lines TYPE string,
       lv_notp  TYPE string,
       lv_und   TYPE string,
       lv_eway  TYPE string,
       lv_can   TYPE string,
       lv_error TYPE string.

DATA: lv_ewaybill(12)       TYPE c,
      lv_ewaybill_dt(10)    TYPE c,
      lv_ewaybill_exdt(10)  TYPE c,
      lv_temp(10)           TYPE c,
      lv_ewaybill_time(6)   TYPE c,
      lv_ewaybill_extime(6) TYPE c,
      lv_ewaybill_tm(11)    TYPE c,
      lv_ewaybill_extm(11)  TYPE c,
      lv_cewaybill(12)      TYPE c,
      lv_cewaybill_dt(10)   TYPE c,
      lv_cewaybill_tm(11)   TYPE c,
      lv_cewaybill_time(6)  TYPE c.

DATA : lv_vdtotime TYPE j_1ig_vdfmtime,
       lv_vdfmtime TYPE j_1ig_vdfmtime.

DATA : lt_eway_number TYPE TABLE OF zeway_number.
DATA : ls_eway_number TYPE zeway_number.


TYPES : BEGIN OF ty_jsonfile,
          line TYPE c LENGTH 255,
        END OF ty_jsonfile.


DATA : lt_jsonfile TYPE STANDARD TABLE OF ty_jsonfile,
       ls_jsonfile TYPE  ty_jsonfile.


*--Data Declaration for Cancel Eway Bill.

TYPES : BEGIN OF lty_cancel,
          ewbno            TYPE c LENGTH 12,
          cancelledreason  TYPE c LENGTH 1,
          cancelledremarks TYPE c LENGTH 60,
        END OF lty_cancel.


DATA : ls_final_cancel TYPE lty_cancel.


TYPES : BEGIN OF lty_vehicle_update,
          ewbno        TYPE c LENGTH 12,
          vehicleno    TYPE c LENGTH 10,
          fromplace    TYPE c LENGTH 50,
          fromstate    TYPE c LENGTH 2,
          reasoncode   TYPE c LENGTH 1,
          reasonrem    TYPE c LENGTH 50,
          transdocno   TYPE c LENGTH 15,
          transdocdate TYPE c LENGTH 10,
          transmode    TYPE c LENGTH 1,
          vehicletype  TYPE c LENGTH 1,
        END OF lty_vehicle_update.

DATA : ls_vehicle_update TYPE lty_vehicle_update.

"""""""""""Consolidiate Eway bill declaration""""""""""""""""

TYPES : BEGIN OF ty_ewaybill_list,
          ewbno TYPE c LENGTH 12,
        END OF ty_ewaybill_list.

DATA : lt_ewaybill_list TYPE TABLE OF ty_ewaybill_list,
       ls_ewaybill_list TYPE  ty_ewaybill_list.

TYPES : BEGIN OF ty_consd_json,
          fromplace         TYPE c LENGTH 50,
          fromstate         TYPE c LENGTH 2,
          vehicleno         TYPE c LENGTH 10,
          transmode         TYPE c LENGTH 1,
          transdocno        TYPE c LENGTH 15,
          transdocdate      TYPE c LENGTH 10,
          tripsheetewbbills LIKE lt_ewaybill_list,
        END OF ty_consd_json.

DATA : lt_consd_json TYPE TABLE OF ty_consd_json,
       ls_consd_json TYPE ty_consd_json.

DATA : lt_zceb TYPE TABLE OF zceb,
       ls_zceb TYPE zceb.

""""""""End of Consolidiate Eway bill declaration""""""""""""

""" Eway bill extend data declaration""""""""""""""

DATA : gt_zewayextend TYPE TABLE OF zewayextend,
       gs_zewayextend TYPE zewayextend.

TYPES : BEGIN OF ty_extendeway,
          ewbno             TYPE  zewayextend-eway_bill,
          vehicleno         TYPE  zewayextend-vehical_no,
          fromplace         TYPE  zewayextend-fromplace,
          fromstate         TYPE  zewayextend-fromstatecode,
          remainingdistance TYPE  zewayextend-remaindistance,
          transdocno        TYPE  zewayextend-transdoc,
          transdocdate      TYPE  c LENGTH 10 ,"zewayextend-transdocdate,
          transmode         TYPE  zewayextend-trns_md,
          extnrsncode       TYPE  zewayextend-extnrsncode,
          extnremarks       TYPE  zewayextend-extnremarks,
          frompincode       TYPE  zewayextend-frompincode,
          consignmentstatus TYPE  zewayextend-consignmentstatus,
          transittype       TYPE  zewayextend-transittype,
          addressline1      TYPE  zewayextend-addressline1,
          addressline2      TYPE  zewayextend-addressline2,
          addressline3      TYPE  zewayextend-addressline3,
        END OF ty_extendeway.

DATA : gt_extend_json TYPE TABLE OF ty_extendeway,
       gs_extend_json TYPE ty_extendeway.


DATA : gv_ewaybill_no   TYPE string,
       gv_ewaybill_date TYPE string,
       gv_status        TYPE string,
       gv_mesg          TYPE string,
       gv_updated_date  TYPE string,
       gv_valid_upto    TYPE string,
       gv_vehupddate    TYPE string.



""" End of Eway bill extend data declaration""""
