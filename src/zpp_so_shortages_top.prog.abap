*&---------------------------------------------------------------------*
*&  Include           ZPP_SO_SHORTAGES_COPY_TOP
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*                             TABLES                                   *
*----------------------------------------------------------------------*

TABLES: vbap, mara, vbak.
*----------------------------------------------------------------------*
*                           TYPE-POOLS                                 *
*----------------------------------------------------------------------*
TYPE-POOLS slis.

*----------------------------------------------------------------------*
*                         TYPE DEFINITION                              *
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_data,
         vbeln       TYPE vbap-vbeln,        "Sales Document
         posnr       TYPE vbap-posnr,        "Sales Document Item
         etenr       TYPE vbep-etenr,        " Delivery Schedule Line Number
         matnr       TYPE vbap-matnr,        "Material Number
         arktx       TYPE vbap-arktx,        "Short text for sales order item
         werks       TYPE vbap-werks,        "Plant
         meins       TYPE vbap-meins,        "Unit of Measurement
         edatu       TYPE vbep-edatu,        "Requested delivery date
         wmeng       TYPE vbep-wmeng,        "Cumulative Order Quantity in Sales Units
*        ETENR type vbep-ETENR,        "Schedule line number
         lfsta       TYPE vbup-lfsta,        "Delivery status
         deldate     TYPE vbap-deldate,   "Delivery Date
*=======Changes on 12/05/2011
         vendor_stk  TYPE mng01,
         quality_stk TYPE mng01,
         brand       TYPE mara-brand,        " brand
         zseries     TYPE mara-zseries,
         zsize       TYPE mara-zsize,
         moc         TYPE mara-moc,
         type        TYPE mara-type,
         dispo       TYPE marc-dispo,
         beskz       TYPE marc-beskz,      " Procurement Type
         verpr       TYPE mbew-verpr,      " Moving Average Price
         act_dt      TYPE mdps-dat00,
         po_number   TYPE ekko-ebeln,
         po_item     TYPE ekpo-ebelp,


*=================
       END OF ty_data.

TYPES: BEGIN OF ty_final,
         header       TYPE vbap-matnr,
         vbeln        TYPE vbap-vbeln,
         posnr        TYPE vbap-posnr,
         etenr        TYPE vbep-etenr,        " Delivery Schedule Line Number
         so_plant     TYPE vbap-werks,        "SALES ORDER LINE ITEM PLANT
         matnr        TYPE vbap-matnr,
         arktx        TYPE vbap-arktx,
         uom          TYPE mara-meins,
         edatu        TYPE vbep-edatu,
         wmeng        TYPE vbep-wmeng,
         open_so      TYPE vbap-kwmeng,
*        SO_STOCK_QM TYPE vbap-kwmeng,
         unres_stk    TYPE vbap-kwmeng,     " unrestricted stock
         qm_stk       TYPE vbap-kwmeng,        " Quality stock.
         vendor_stk   TYPE vbap-kwmeng,    " vendor Stk
         block_stk    TYPE vbap-kwmeng,     " Block stock.
         wip_stk      TYPE vbap-kwmeng,       " WIP stock.
         deldate      TYPE vbap-deldate,   "Delivery Date
         so_block_stk TYPE vbap-kwmeng,
         short_qty    TYPE vbap-kwmeng,
         po_usd       TYPE vbap-kwmeng,
         po_qty       TYPE vbap-kwmeng,
         po_no        TYPE mdps-delnr,
         pr_qty       TYPE vbap-kwmeng,
         pr_no        TYPE mdps-delnr,
         action_dt    TYPE mdps-dat00,
*=======Changes on 12/05/2011
         act_dt       TYPE mdps-dat00,       "reqd dt.
         brand        TYPE mara-brand,        " brand
         zseries      TYPE mara-zseries,
         zsize        TYPE mara-zsize,
         moc          TYPE mara-moc,
         type         TYPE mara-type,
         mtart        TYPE mara-mtart,
         bismt        TYPE mara-bismt,
         dispo        TYPE marc-dispo,
         beskz        TYPE marc-beskz,      " Procurement Type
         verpr        TYPE mbew-verpr,
         customer     TYPE kna1-name1,
         pr_qty_verpr TYPE mbew-verpr,
         po_qty_verpr TYPE mbew-verpr,
         plant        TYPE marc-werks,
         plant2       TYPE marc-werks,
         header_desc  TYPE makt-maktx,
         action_days  TYPE marc-plifz,
         act_matnr    TYPE mara-matnr,
*        deldate  type vbap-deldate,   "Delivery Date
         stufe        TYPE stpox-stufe,
         net_indent   TYPE vbap-kwmeng,
         sobsl        TYPE marc-sobsl,
         schid(20),
*=================
         rowcolor(4)  TYPE c,
       END OF ty_final.

TYPES: BEGIN OF st_idnrk,
         hdmat     TYPE mara-matnr,
         vbeln     TYPE vbap-vbeln,
         posnr     TYPE vbap-posnr,
         etenr     TYPE vbep-etenr,        " Delivery Schedule Line Number
         idnrk     TYPE stpox-idnrk,       "Component Material Number
         maktx     TYPE makt-maktx,        "material Description
         uom       TYPE mara-meins,        "Unit of measure
         edatu     TYPE vbep-edatu,        "Delivery status
         wmeng     TYPE vbep-wmeng,
         "ETENR TYPE vbep-ETENR,
         sbdkz     TYPE marc-sbdkz,        "Dependent requirements ind. for individual and coll. reqmts
         level     TYPE vbap-kwmeng,       " REQD_QTY
         action_dt TYPE vbep-edatu,     " Planned delivery Time in days
         plant     TYPE marc-werks,
         plant2    TYPE marc-werks,
         deldate   TYPE vbap-deldate,     "dELIVERY DATE
         stufe     TYPE stpox-stufe,       "Level (in multi-level BOM explosions)
         actdys    TYPE i,               " Action Days
         act_dt    TYPE  vbep-edatu,      " Required date
       END OF st_idnrk.

TYPES:  tt_mdps TYPE mdps.


TYPES: BEGIN OF tt_stock,
         matnr        TYPE mara-matnr,
         rt_stock     TYPE vbap-kwmeng,      " RUNTIME STOCK.
         qm_net_stock TYPE vbap-kwmeng ,      " Quality netting stock.
         block_stk    TYPE vbap-kwmeng,        " Block_stock
         ven_net_stk  TYPE vbap-kwmeng,   " Vendor neting stock.
         wip_stk      TYPE vbap-kwmeng,    " WIP STOCK
       END OF tt_stock.

TYPES: BEGIN OF ty_mast,
         matnr TYPE mara-matnr,
         werks TYPE vbap-werks,
       END OF ty_mast.

TYPES: BEGIN OF ty_delnr,
         delnr TYPE delnr,
         matnr TYPE mara-matnr,
         werks TYPE vbap-werks,
       END OF ty_delnr,

       BEGIN OF ty_pr,
         matnr   TYPE mara-matnr,
         reqd_dt TYPE mdps-dat00,
         prno    TYPE mdps-delnr,
         prqty   TYPE vbap-kwmeng,
*         Poqty type mdps-delnr,
       END OF ty_pr,

       BEGIN OF ty_po,
         matnr   TYPE mara-matnr,
         reqd_dt TYPE mdps-dat00,
         pono    TYPE mdps-delnr,
         poqty   TYPE vbap-kwmeng,
*         Poqty type mdps-delnr,
       END OF ty_po.

TYPES : BEGIN OF tt_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
          arktx TYPE vbap-arktx,
          werks TYPE vbap-werks,
          meins TYPE vbap-meins,
*           deldate  type vbap-deldate,   "Delivery Date
        END OF tt_vbap.
*
*types : begin of tt_vbak,
*        vbeln   type vbak-vbeln,
*        vdatu   type vbak-vdatu,
*           end of tt_vbak.

TYPES : BEGIN OF tt_vbup,
          vbeln TYPE vbup-vbeln,
          posnr TYPE vbup-posnr,
          lfsta TYPE vbup-lfsta,
        END OF tt_vbup.

*========Changes on 13/05/2011

TYPES: BEGIN OF tt_mara,
         matnr   TYPE mara-matnr,
         brand   TYPE mara-brand,        " brand
         zseries TYPE mara-zseries,
         zsize   TYPE mara-zsize,
         moc     TYPE mara-moc,
         type    TYPE mara-type,
         mtart   TYPE mara-mtart,
         bismt   TYPE mara-bismt,
       END OF tt_mara,

       BEGIN OF tt_marc,
         matnr TYPE marc-matnr,
         werks TYPE marc-werks,
         dispo TYPE marc-dispo,      "MRP controller
         beskz TYPE marc-beskz,      " Procurement Type
       END OF tt_marc,

       BEGIN OF tt_mbew,
         matnr TYPE mbew-matnr,
*         werks  TYPE marc-werks,
         bwkey TYPE mbew-bwkey,
         verpr TYPE mbew-verpr,      " Moving Average Price
       END OF tt_mbew,

       BEGIN OF tt_vbak,
         vbeln TYPE vbak-vbeln,
         kunnr TYPE vbak-kunnr,
       END OF tt_vbak,

*       Begin of tt_kna1,
*         kunnr TYPE kna1-kunnr,
*         name1 TYPE kna1-name1,
*       end of tt_kna1,

       BEGIN OF tt_kna1,
*         vbeln  TYPE vbak-vbeln,
         kunnr TYPE vbak-kunnr,
         name1 TYPE kna1-name1,
       END OF tt_kna1,

       BEGIN OF tt_material,
         so_no       TYPE vbap-vbeln,
         posnr       TYPE vbap-posnr,
         etenr       TYPE vbep-etenr,        " Delivery Schedule Line Number
         head_mat    TYPE mara-matnr,
*         HEAD_DESC TYPE MAKT-MAKTX,
         comp_mat    TYPE mara-matnr,
         plant       TYPE marc-werks,
         mat_qty     TYPE vbap-kwmeng,
         act_matnr   TYPE mara-matnr, " header material for action date calculations.
         action_days TYPE i,
         required_dt TYPE vbep-edatu,
       END OF tt_material,


       BEGIN OF tt_resb,
         matnr  TYPE mara-matnr,
         bdmng  TYPE resb-bdmng,
         enmng  TYPE resb-enmng,
         aufnr  TYPE resb-aufnr,
         wipqty TYPE resb-bdmng,
         xloek  TYPE resb-xloek,
         shkzg  TYPE resb-shkzg,
       END OF tt_resb,

       BEGIN OF ty_order,
         order TYPE mdps-del12,
       END OF ty_order,

       BEGIN OF tt_afpo,
         aufnr TYPE afpo-aufnr,
         psmng TYPE afpo-psmng,
         wemng TYPE afpo-wemng,
       END OF tt_afpo,

       BEGIN OF tt_makt,
         matnr TYPE matnr,
         maktx TYPE makt-maktx,
         spras TYPE makt-spras,
       END OF tt_makt,


*========*========*========*========
       BEGIN OF t_comp,
         matnr       TYPE matnr,
         action_days TYPE i,
       END OF t_comp.
*===========Changes on 25/05/2011


*===========*===========*===========*===========

*----------------------------------------------------------------------*
*                          INTERNAL TABLE/WORK AREA                              *
*----------------------------------------------------------------------*
DATA: it_delnr TYPE STANDARD TABLE OF ty_delnr,
      wa_delnr TYPE ty_delnr.

DATA: it_mast TYPE STANDARD TABLE OF ty_mast,
      wa_mast TYPE ty_mast.

DATA: it_stock TYPE STANDARD TABLE OF tt_stock,
      wa_stock TYPE tt_stock.

DATA: it_final TYPE STANDARD TABLE OF ty_final,
      wa_final TYPE ty_final.

DATA: it_final_new TYPE STANDARD TABLE OF ty_final,
      wa_final_new TYPE ty_final.

DATA: it_mdps  TYPE STANDARD TABLE OF tt_mdps,
      it_mdps2 TYPE STANDARD TABLE OF tt_mdps,
      wa_mdps  TYPE tt_mdps,
      wa_mdps1 TYPE tt_mdps,
      wa_mdps2 TYPE tt_mdps.


DATA : it_mdez TYPE STANDARD TABLE OF mdez,
       wa_mdez TYPE mdez.

DATA: it_order TYPE STANDARD TABLE OF ty_order,
      wa_order TYPE ty_order.

DATA: it_data  TYPE STANDARD TABLE OF ty_data,
      wa_data  TYPE ty_data,
      wa_data2 TYPE ty_data.

DATA: t_stb      TYPE STANDARD TABLE OF stpox,
      wa_stb     TYPE stpox,
      wa_stb2    TYPE stpox,
      wa_stb_tmp TYPE stpox,

      t_stb1     TYPE STANDARD TABLE OF stpox,
      wa_stb1    TYPE stpox.

DATA: it_idnrk  TYPE STANDARD TABLE OF st_idnrk,
      wa_idnrk  TYPE st_idnrk,
      wa_idnrk1 TYPE st_idnrk.

DATA: it_zsoplan TYPE STANDARD TABLE OF zsoplan,
      wa_zsoplan TYPE zsoplan.

DATA: it_mdpsx TYPE STANDARD TABLE OF mdps,
      wa_mdpsx TYPE mdps.

DATA: it_mdrqx TYPE STANDARD TABLE OF mdrq,
      wa_mdrqx TYPE mdrq.

*DATA:   it_vbap TYPE STANDARD TABLE OF tt_vbap,
*        wa_vbap TYPE tt_vbap.
*

DATA: it_vbup TYPE STANDARD TABLE OF tt_vbup,
      wa_vbup TYPE tt_vbup.

DATA:   v_werks TYPE marc-werks..
DATA:   i_sort  TYPE slis_t_sortinfo_alv. " Sort

*========Changes on 13/05/2011
DATA: it_mara  TYPE STANDARD TABLE OF tt_mara,
      w_mara   TYPE tt_mara,

      it_marc  TYPE STANDARD TABLE OF tt_marc,
      wa_marc  TYPE tt_marc,
      wa_marc1 TYPE marc,

      it_mbew  TYPE STANDARD TABLE OF tt_mbew,
      wa_mbew  TYPE  tt_mbew,
      wa_mbew1 TYPE mbew.
*========*========*========
*===========Changes on 25/05/2011
DATA: it_vbak  TYPE STANDARD TABLE OF tt_vbak,
      w_vbak   TYPE tt_vbak,

      it_kna1  TYPE STANDARD TABLE OF tt_kna1,
      wa_kna1  TYPE tt_kna1,

      it_pr    TYPE STANDARD TABLE OF ty_pr,
      wa_pr    TYPE ty_pr,

      it_po    TYPE STANDARD TABLE OF ty_po,
      wa_po    TYPE ty_po,

      it_resb  TYPE STANDARD TABLE OF tt_resb,
      wa_resb  TYPE tt_resb,

      it_afpo  TYPE STANDARD TABLE OF tt_afpo,
      wa_afpo  TYPE tt_afpo,
      wa_afpo2 TYPE tt_afpo,
      wa_ekko  TYPE ekko,
      wa_ekpo  TYPE ekpo,

      it_comp  TYPE STANDARD TABLE OF t_comp,
      wa_comp  TYPE t_comp.

*===========*===========*===========*===========

*----------------------------------------------------------------------*
*                          VARIABLES                              *
*----------------------------------------------------------------------*
DATA: so_stock      TYPE vbap-kwmeng,     "Sales Order Stock
      so_wip        TYPE vbap-kwmeng,     "Sales Order Stock
      so_stock_qm   TYPE vbap-kwmeng,
      so_block_stk  TYPE vbap-kwmeng,
      so_qty        TYPE vbap-kwmeng,
      short_qty     TYPE vbap-kwmeng,
      po_qty        TYPE vbap-kwmeng,
      avail_stock   TYPE vbap-kwmeng,     " Free stock-temp var-for coll
      avail_qm      TYPE vbap-kwmeng,        " Quality stock-temp var-for coll
      avail_block   TYPE vbap-kwmeng,     "Blocked Stock
      avail_vs      TYPE vbap-kwmeng,        " Vendor stock-temp var-for coll
      level_0       TYPE vbap-kwmeng,
      level_1       TYPE vbap-kwmeng,
      level_2       TYPE vbap-kwmeng,
      level_3       TYPE vbap-kwmeng,
      level_4       TYPE vbap-kwmeng,
      lv_mat_qty    TYPE  stko-bmeng,
      lv_matnr_0    TYPE mara-matnr,
      lv_matnr_1    TYPE mara-matnr,
      lv_matnr_2    TYPE mara-matnr,
      lv_matnr_3    TYPE mara-matnr,
      lv_matnr_4    TYPE mara-matnr,
      lv_matnr_5    TYPE mara-matnr,
      lv_matnr      TYPE mara-matnr,
      lv_stlnr      TYPE stpo-stlnr,
      flag          TYPE i,
      flag1         TYPE i,
      v_plnt_ind    TYPE c VALUE 'X',
      v_inp_ind     TYPE c VALUE 'X',
      action_days   TYPE i,
*========Changes on 13/05/2011
      vendor_stk    TYPE mng01,
      quality_stk   TYPE mng01,
      blk_stk       TYPE mng01,       " Block Stock
      v_kunnr       TYPE vbak-kunnr,
      v_bwkey       TYPE mbew-bwkey,
      header        TYPE mara-matnr,
      rem_qty       TYPE vbap-kwmeng,    " Temp var for remaining Stock Qty.
      v_name1       TYPE kna1-name1,
      prod_ord      TYPE afpo-aufnr,      " Production order
      pr_qty_verpr  TYPE i,
      po_qty_verpr  TYPE i,
      tot_pr        TYPE  vbap-kwmeng,
      tot_po        TYPE vbap-kwmeng,
      pl_werks      TYPE marc-werks,
      pl_werks2     TYPE marc-werks,
      lv_werks      TYPE marc-werks,
      header_desc   TYPE makt-maktx,
      planseg       TYPE mdps-planr,
      planseg1      TYPE mdps-planr,
      lv_delnr      TYPE mdps-del12,
      po_number     TYPE ekko-ebeln,
      lv_tot_po_qty TYPE mng01,
      po_quantity   TYPE bstmg,
      lv_action_dt  TYPE edatu,
      lv_action_dt1 TYPE edatu,
      lv_action_dt2 TYPE edatu,
      v_level       TYPE stpox-stufe,
      lv_so_plant   TYPE vbap-werks,
      po_item       TYPE ekpo-ebelp.
*========*========*========
*===========Changes on 25/05/2011
TYPES : BEGIN OF tt_vbup2,
          vbeln TYPE vbup-vbeln,
          posnr TYPE vbup-posnr,
          lfgsa TYPE vbup-lfgsa,
        END OF tt_vbup2.
DATA:   wa2_vbup TYPE tt_vbup2.

*===========*===========*===========*===========

DATA: i_vbap       TYPE STANDARD TABLE OF vbap,
      wa_vbap      TYPE vbap,

      i_mara       TYPE STANDARD TABLE OF mara,
      wa_mara      TYPE mara,

      i_vbak       TYPE STANDARD TABLE OF vbak,
      wa_vbak      TYPE vbak,

      it_material  TYPE STANDARD TABLE OF tt_material,
      wa_material  TYPE tt_material,
      wa_material2 TYPE tt_material,
      wa_material3 TYPE tt_material.

DATA: i_fieldcat         TYPE slis_t_fieldcat_alv, " Fieldcatalog
      wa_fieldcat        TYPE slis_fieldcat_alv,   " Fieldcat workarea
*      i_sort             TYPE slis_t_sortinfo_alv, " Sort
      gt_events          TYPE slis_t_event,        " Events
      i_list_top_of_page TYPE slis_t_listheader.   " Top-of-page
*      wa_layout          TYPE slis_layout_alv.     " Layout workarea

DATA : i_repid  TYPE sy-repid,
       zebra(1) TYPE c.

DATA: it_fcat   TYPE slis_t_fieldcat_alv,
      wa_fcat   TYPE LINE OF slis_t_fieldcat_alv, " SLIS_t_fieldcat_ALV.
      wa_layout TYPE  slis_layout_alv.     " Layout workarea
*----------------------------------------------------------------------*
*                            CONSTANTS                                 *
*----------------------------------------------------------------------*
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname
                                   VALUE 'TOP_OF_PAGE',
  c_formname_pf_status_set TYPE slis_formname
                                 VALUE 'PF_STATUS_SET',
  c_z_alv_demo             LIKE trdir-name VALUE 'Z_ALV_DEMO',
  c_vbak                   TYPE slis_tabname    VALUE 'I_VBAK',

  c_s                      TYPE c VALUE 'S',
  c_h                      TYPE c VALUE 'H'.
