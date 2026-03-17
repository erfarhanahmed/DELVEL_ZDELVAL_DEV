*&---------------------------------------------------------------------*
*&  Include           Z_EWAYBILL_GENERATION_TOP_V02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           Z_EWAYBILL_GENERATION_TOP
*&---------------------------------------------------------------------*

TABLES : zeway_bill,zeway_number,zeway_multi_veh,zewayextend.

CLASS lcl_events DEFINITION.
  PUBLIC SECTION.

    METHODS: handle_toolbar
                  FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object e_interactive.

    METHODS: handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
          e_row
          e_column.

    METHODS : handle_f4 FOR EVENT onf4 OF cl_gui_alv_grid
      IMPORTING
          e_fieldname
          es_row_no
          er_event_data
          et_bad_cells
          e_display.

    METHODS :
      handle_hot_spot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
            e_row_id     "Type  LVC_S_ROW
            e_column_id  "Type LVC_S_COL
            es_row_no.

ENDCLASS.

DATA gv_event_receiver TYPE REF TO lcl_events.


DATA: row         TYPE lvc_s_row,
      col         TYPE lvc_s_col,
      c_ccont     TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_ccont_del TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd     TYPE REF TO cl_gui_alv_grid                 "ALV grid object
      .


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
          kunnr                  TYPE kna1-kunnr,
          cust_name              TYPE kna1-name1,
          gjahr                  TYPE gjahr,
          belnr1                 TYPE bkpf-belnr,
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

DATA : g_app     TYPE REF TO lcl_events,
       it_fcat   TYPE lvc_t_fcat,                             "Field catalogue
       it_layout TYPE lvc_s_layo.

DATA : ls_exclude TYPE ui_func,
       pt_exclude TYPE ui_functions.

DATA :gt_ewaybill_details TYPE TABLE OF zeway_bill,
      gs_ewaybill_details TYPE zeway_bill,
      gs_ewaybill_screen  TYPE zeway_bill.

DATA :gt_eway_multi_veh    TYPE TABLE OF zeway_multi_veh,
      gs_eway_multi_veh    TYPE zeway_multi_veh,
      gs_eway_multi_screen TYPE zeway_multi_veh,
      gs_eway_multi_veh_add    TYPE ZEWAY_MULTI_ADD,
      gt_eway_multi_veh_add    TYPE TABLE OF ZEWAY_MULTI_ADD,
      gs_eway_multi_veh_chng    TYPE ZEWAY_MULTI_CHNG,
      gt_eway_multi_veh_chng    TYPE TABLE OF ZEWAY_MULTI_CHNG.

TYPES: BEGIN OF ty_eway_multi_init,
        ewbno         TYPE zeway_multi_veh-eway_bill     ,
        reasoncode    TYPE zeway_multi_veh-reasoncode    ,
        reason        TYPE zeway_multi_veh-reason        ,
        fromplace     TYPE zeway_multi_veh-fromplace     ,
        fromstate     TYPE zeway_multi_veh-fromstatecode ,
        toplace       TYPE zeway_multi_veh-to_place      ,
        tostate       TYPE zeway_multi_veh-to_state      ,
        trnsmd        TYPE zeway_multi_veh-trns_md       ,
        totqty        TYPE zeway_multi_veh-tot_qty       ,
        unit          TYPE zeway_multi_veh-unit          ,
       END OF ty_eway_multi_init.

DATA : gs_eway_multi_init    TYPE ty_eway_multi_init." ZEWAY_MULT_INIT.

TYPES : BEGIN OF ty_eway_multi_add,
        ewbno         TYPE zeway_multi_veh-eway_bill     ,
        group         TYPE zeway_multi_veh-group1 ,
        qty           TYPE zeway_multi_veh-qty ,
        transDate     TYPE string,
        transdocno    TYPE zeway_multi_veh-TRANS_DOC ,
        vehicle       TYPE zeway_multi_veh-VEHICAL_NO,
        END OF ty_eway_multi_add.

DATA : gs_eway_multi_add TYPE ty_eway_multi_add.

TYPES : BEGIN OF ty_eway_multi_chng,
        ewbno         TYPE zeway_multi_veh-eway_bill     ,
        fromplace     TYPE zeway_multi_veh-fromplace     ,
        fromstate     TYPE zeway_multi_veh-fromstatecode ,
        group         TYPE zeway_multi_veh-group1 ,
        newtrans      TYPE ZEWAY_MULTI_CHNG-NEW_TRANS_NO,
        newvehicle    TYPE ZEWAY_MULTI_CHNG-NEW_VEHICAL,
        oldtrans      TYPE ZEWAY_MULTI_CHNG-OLD_TRANS_NO,
        oldvehicle    TYPE ZEWAY_MULTI_CHNG-OLD_VEHICAL,
        reasoncode    TYPE zeway_multi_veh-reasoncode    ,
        reason        TYPE zeway_multi_veh-reason        ,
        END OF ty_eway_multi_chng.

DATA : gs_eway_multi_chng TYPE ty_eway_multi_chng.



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
          portpin               TYPE string,
          portname              TYPE string,
          itemlist              LIKE lt_itemlist,
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
          ship_to_party    TYPE string,"kna1-name1,
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
          othvalue         TYPE string,
          vehicletype      TYPE string,
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
          TAXK6 TYPE vbrk-TAXK6,
          netwr TYPE vbrk-netwr,
          mwsbk TYPE vbrk-mwsbk,
          kunag TYPE vbrk-kunag,      " Sold-to party
          sfakn TYPE vbrk-sfakn,      " Cancelled billing document number
          xblnr TYPE vbrk-xblnr,      " Reference Document Number
          bupla TYPE vbrk-bupla,
  land1 TYPE vbrk-land1,    "country                        "added by Diksha
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
          LGORT TYPE VBRP-LGORT, "ADDED BY JYOTI ON 16.06.2024
        END OF ls_vbrp.
*******aDDED BY PRIMUS JYOTI ON 01.12.2023*********
TYPES :
  BEGIN OF t_konp1,
    knumh TYPE konp-knumh,
    kopos TYPE konp-kopos,
    kschl TYPE konp-kschl,
    kbetr TYPE konp-kbetr,
  END OF t_konp1,
  tt_konp TYPE STANDARD TABLE OF t_konp1.



  TYPES :
  BEGIN OF t_A005,
    KSCHL TYPE A005-kschl,
    KUNNR TYPE A005-KUNNR,
    MATNR TYPE A005-MATNR,
    DATBI TYPE A005-DATBI,
    DATAB TYPE A005-DATAB,
    KNUMH TYPE A005-KNUMH,
  END OF t_A005,
  tt_A005 TYPE STANDARD TABLE OF t_A005.


  dATA : WA_KONP  TYPE  T_KONP1,
WA_A005 TYPE  T_A005,
TT_A005	TYPE TABLE OF	T_A005,
TT_KONP	TYPE TABLE OF	T_KONP1.
**************************************************

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
         knumv TYPE PRCD_ELEMENTS-knumv,        " Number of the document condition
         kposn TYPE PRCD_ELEMENTS-kposn,        " Condition item number
         kschl TYPE PRCD_ELEMENTS-kschl,        " Condition type
         kwert TYPE PRCD_ELEMENTS-kwert,        " Condition Value
         kbetr TYPE PRCD_ELEMENTS-kbetr,        " Rate
         kawrt TYPE PRCD_ELEMENTS-kawrt,        " Condition base value
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
          name1 TYPE string,                   " Name
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
DATA : ls_eway_num TYPE zeway_number.


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



TYPES : BEGIN OF lty_s_bkpf,
          bukrs     TYPE bukrs,
          belnr     TYPE belnr_d,
          gjahr     TYPE gjahr,
          bldat     TYPE bldat,
          budat     TYPE budat,
          xblnr     TYPE xblnr,
          xblnr_alt TYPE xblnr_alt,
          blart     TYPE blart,
          stblg     TYPE stblg,
          tcode     TYPE tcode,
          cpudt     TYPE cpudt,
          cputm     TYPE cputm,
          usnam     TYPE usnam,
          awkey     TYPE bkpf-awkey,
        END OF lty_s_bkpf.

DATA : lt_bkpf TYPE STANDARD TABLE OF lty_s_bkpf,
       ls_bkpf TYPE lty_s_bkpf.

TYPES : BEGIN OF ty_mseg,
          mblnr      TYPE mblnr,
          mjahr      TYPE mjahr,
          lfbnr      TYPE lfbnr,
          ebeln      TYPE ebeln,
          ebelP      TYPE ebelP,
          bwart      TYPE bwart,
          "added
          budat_mkpf TYPE mseg-budat_mkpf,
          menge      TYPE mseg-menge,
        END OF ty_mseg.

DATA : lt_mseg1 TYPE TABLE OF ty_mseg,
       ls_mseg1 TYPE ty_mseg.

TYPES: BEGIN OF ty_rseg,
         belnr   TYPE  rseg-belnr,
         gjahr   TYPE  rseg-gjahr,
         buzei   TYPE  rseg-buzei,
         ebeln   TYPE  rseg-ebeln,
         ebelp   TYPE  rseg-ebelp,
         werks   TYPE  rseg-werks,
         matnr   TYPE  rseg-matnr,
         hsn_sac TYPE  rseg-hsn_sac,
         menge   TYPE  rseg-menge,
         meins   TYPE  rseg-meins,
         wrbtr   TYPE  rseg-wrbtr,
         kschl   TYPE  rseg-kschl,
         xekbz   TYPE  rseg-xekbz,
         lfbnr   TYPE  rseg-lfbnr,
         bukrs   TYPE  rseg-bukrs,
         xblnr   TYPE  rseg-xblnr,
         mwskz   TYPE  rseg-mwskz,
       END OF ty_rseg.

DATA : lt_rseg TYPE TABLE OF ty_rseg,
       ls_rseg TYPE ty_rseg.

TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-kunnr,
         name1 TYPE lfa1-name1,
         stcd3 TYPE lfa1-stcd3,
       END OF ty_lfa1.

DATA: lt_lfa1 TYPE TABLE OF ty_lfa1,
      ls_lfa1 TYPE ty_lfa1.


TYPES :BEGIN OF ty_awkey,
         lv_awkey TYPE bkpf-awkey,
       END OF ty_awkey.

DATA : lt_awkey TYPE TABLE OF ty_awkey,
       ls_awkey TYPE ty_awkey.


TYPES : BEGIN OF lty_s_bseg,
          bukrs TYPE bukrs,
          belnr TYPE belnr_d,
          gjahr TYPE gjahr,
          lifnr TYPE lifnr,
          txgrp TYPE txgrp,
          sgtxt TYPE sgtxt,
          gvtyp TYPE gvtyp,
          dmbtr TYPE dmbtr,
          mwskz TYPE mwskz,
          hkont TYPE hkont,
          kostl TYPE kostl,
          bupla TYPE bupla,
          prctr TYPE prctr,
          kunnr TYPE kunnr,
          koart TYPE koart,
        END OF lty_s_bseg.

DATA : lt_bseg TYPE STANDARD TABLE OF lty_s_bseg,
       ls_bseg TYPE lty_s_bseg.

DATA : lt_zeinv_response TYPE STANDARD TABLE OF  zeinv_res_fb70,       "zeinv_res_fb70,
       ls_zeinv_response TYPE zeinv_res_fb70.                              "zeinv_res_fb70.



TYPES  : BEGIN OF lty_j_1bbranch,
           bukrs  TYPE j_1bbranch-bukrs,
           branch TYPE j_1bbranch-branch,
           gstin  TYPE j_1bbranch-gstin,
         END OF lty_j_1bbranch.


DATA : lt_j_1bbranch TYPE TABLE OF lty_j_1bbranch,
       ls_j_1bbranch TYPE lty_j_1bbranch.

TYPES : BEGIN OF lty_j_1ig_invrefnum,
          bukrs         TYPE j_1ig_invrefnum-bukrs,
          docno         TYPE j_1ig_invrefnum-docno,
          odn           TYPE j_1ig_invrefnum-odn,
          irn           TYPE j_1ig_invrefnum-irn,
          ack_no        TYPE j_1ig_invrefnum-ack_no,
          irn_status    TYPE j_1ig_invrefnum-irn_status,
          ernam         TYPE j_1ig_invrefnum-ernam,
          erdat         TYPE j_1ig_invrefnum-erdat,
          erzet         TYPE j_1ig_invrefnum-erzet,
          signed_inv    TYPE j_1ig_invrefnum-signed_inv,
          signed_qrcode TYPE j_1ig_invrefnum-signed_qrcode,

        END OF lty_j_1ig_invrefnum.

DATA : lt_j_1ig_invrefnum TYPE TABLE OF lty_j_1ig_invrefnum,
       ls_j_1ig_invrefnum TYPE lty_j_1ig_invrefnum.


TYPES : BEGIN OF lty_final2,
          bukrs                  TYPE bkpf-bukrs,
          selection              TYPE char1,
          process_status(70)     TYPE c,
          status_description(20) TYPE c,
****          reason(50)             TYPE c,
          bupla                  TYPE bseg-bupla,
          prctr                  TYPE bseg-prctr,
          blart                  TYPE bkpf-blart,
          kunnr                  TYPE kna1-kunnr,
          name1                  TYPE kna1-name1,
          belnr                  TYPE bkpf-belnr,
          gjahr                  TYPE bkpf-gjahr,
          xblnr                  TYPE bkpf-xblnr,
          bldat                  TYPE bkpf-bldat,
          cpudt                  TYPE bkpf-cpudt,
          cputm                  TYPE bkpf-cputm,
          usnam                  TYPE bkpf-usnam,
          budat                  TYPE bkpf-budat,
          gstin                  TYPE stcd3,
****          zzirn_no               TYPE zeinv_res_fb70-zzirn_no,
          eway_bil               TYPE zeway_res_122-eway_bill,
****          zzack_no               TYPE zeinv_res_fb70-zzack_no,
****          zzqr_code              TYPE zeinv_res_fb70-zzqr_code,
****          zzstatus               TYPE zeinv_res_fb70-zzstatus,
****          zzerror_disc           TYPE zeinv_res_fb70-zzerror_disc,
          message                TYPE zeway_res_122-message,
****          zzuser                 TYPE zeinv_res_fb70-zzqr_code,
          created_by             TYPE sy-uname,
****          zzcdate                TYPE zeinv_res_fb70-zzcdate,
          created_dt             TYPE sy-datum,
****          zztime                 TYPE zeinv_res_fb70-zztime,
          created_time           TYPE sy-uzeit,
****          can_doc                TYPE vbrk-vbeln,
          cancel_doc             TYPE sfakn,
****          can_reason             TYPE zeinv_res_fb70-zzcan_reason,
          cancelremark           TYPE zeway_res_122-cancelremark,
          conewayno              TYPE zeway_res_122-conewayno    ,
          ewaybilldate           TYPE zeway_res_122-ewaybilldate ,
          vdfmtime               TYPE zeway_res_122-vdfmtime     ,
          validuptodate          TYPE zeway_res_122-validuptodate,
          vdtotime               TYPE zeway_res_122-vdtotime     ,
          canreason              TYPE zeway_res_122-canreason,
          canceldt               TYPE zeway_res_122-canceldt,
          belnr1                 TYPE bkpf-belnr,
        END OF lty_final2.


DATA : lt_final2 TYPE STANDARD TABLE OF lty_final2,
       ls_final2 TYPE lty_final2.


****DATA : lt_zeinv_response_save TYPE STANDARD TABLE OF zeinv_res_fb70,
****       ls_zeinv_response_save TYPE zeinv_res_fb70 .               "_fb70.


DATA : lt_zeway_res_122 TYPE TABLE OF zeway_res_122,
       ls_zeway_res_122 TYPE zeway_res_122.


****DATA: lt_data_122 TYPE TABLE OF zodn_122,
****      ls_data_122 TYPE zodn_122.

CONSTANTS : lc_null TYPE string VALUE 'null'.

"------Declarations for Drop Down list-----------------------------
****DATA: it_list     TYPE vrm_values.
****DATA: wa_list    TYPE vrm_value.
****DATA: it_values TYPE TABLE OF dynpread,
****      wa_values TYPE dynpread.
****
****DATA: lv_selected_value(20) TYPE c.
"--------------------------------------------------------------------

""""""""""""End of Data Declaration for Inward""""""""""""""
