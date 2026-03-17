*----------------------------------------------------------------------*
*                           TYPE-POOLS                                 *
*----------------------------------------------------------------------*
TYPE-POOLS slis.
*----------------------------------------------------------------------*
*                         TYPE DEFINITION                              *
*----------------------------------------------------------------------*

TABLES :VBAP.
TYPES: BEGIN OF ty_data,
         vbeln TYPE vbap-vbeln,        "Sales Document
         posnr TYPE vbap-posnr,        "Sales Document Item
         matnr TYPE vbap-matnr,        "Material Number
         arktx TYPE vbap-arktx,        "Short text for sales order item
         werks TYPE vbap-werks,        "Plant
         meins TYPE vbap-meins,        "Unit of Measurement
         edatu TYPE vbep-edatu,        "Requested delivery date
         wmeng TYPE vbep-wmeng,      "Cumulative Order Quantity in Sales Units
         etenr TYPE vbep-etenr,      "Schedule line number
         lfsta TYPE vbup-lfsta,        "Delivery status
       END OF ty_data.

TYPES:  tt_mdps TYPE mdps.

TYPES: BEGIN OF tt_vbfa,
         vbeln   TYPE vbfa-vbeln,
         posnv   TYPE vbfa-posnv,
         vbtyp_n TYPE vbfa-vbtyp_n,
         bwart   TYPE  vbfa-bwart,
       END OF tt_vbfa.

TYPES: BEGIN OF tt_comp_tot_qty,
*    HEADER_MATERIAL TYPE MATNR,
         component      TYPE stpox-idnrk,
         comp_total_stk TYPE stpox-mnglg,
         temp_stock     TYPE mng01,
       END OF tt_comp_tot_qty.


TYPES: BEGIN OF tt_so_stock,
         so         TYPE vbak-vbeln,
         item       TYPE vbap-posnr,
         component  TYPE matnr,
         temp_stock TYPE mng01,
         so_qty     TYPE mng01,
       END OF tt_so_stock.

TYPES: BEGIN OF tt_lips,
*          VBELN TYPE lips-VBELN,
*          posnr TYPE lips-POSNR,
         lfimg TYPE lips-lfimg,
       END OF tt_lips.

TYPES : BEGIN OF tt_vbup,
          vbeln TYPE vbup-vbeln,
          posnr TYPE vbup-posnr,
          lfsta TYPE vbup-lfsta,
        END OF tt_vbup.

TYPES : BEGIN OF tt_vbup2,
          vbeln TYPE vbup-vbeln,
          posnr TYPE vbup-posnr,
          lfgsa TYPE vbup-lfgsa,
        END OF tt_vbup2.

TYPES: BEGIN OF type_final,
         vbeln       TYPE vbak-vbeln,
         posnr       TYPE vbap-posnr,
         customer    TYPE kna1-name1,
         edatu       TYPE vbep-edatu,
         matnr       TYPE vbap-matnr,        "Material Number
         arktx       TYPE vbap-arktx,        "Short text for sales order item
         pending_qty TYPE mengv13,
         canbe_qty   TYPE mng01,
         so_rate     TYPE prcd_elements-kbetr,
         canbe_value TYPE netwr,
         """""""""       Added By KD on 05.05.2017       """""""""
         dispo       TYPE marc-dispo,       """"   MRP Controller
         sfcpf       TYPE marc-sfcpf,       """"   MRP Controller
         plnum       TYPE plaf-plnum,       """"   Planned Order Number
         psttr       TYPE plaf-psttr,       """"   Planned Start date
         """""""""""""""""""""""""""""""""""""""""""""""""""""""""
       END OF type_final.

"""""""""       Added By KD on 05.05.2017       """""""""
TYPES : BEGIN OF ty_marc,
          matnr TYPE marc-matnr,
          werks TYPE marc-werks,
          dispo TYPE marc-dispo,
          sfcpf TYPE marc-sfcpf,
        END OF ty_marc.

DATA : it_marc TYPE TABLE OF ty_marc,
       wa_marc TYPE ty_marc.

TYPES : BEGIN OF ty_plaf,
          plnum TYPE plaf-plnum,
          matnr TYPE plaf-matnr,
          plwrk TYPE plaf-plwrk,
          psttr TYPE plaf-psttr,
          kdauf TYPE plaf-kdauf,
          kdpos TYPE plaf-kdpos,
        END OF ty_plaf.

DATA : it_plaf TYPE TABLE OF ty_plaf,
       wa_plaf TYPE ty_plaf.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

TYPES: BEGIN OF type_canbe,
         comp_canbe TYPE mng01,
       END OF type_canbe.

TYPES: BEGIN OF type_max_canbe,
         component  TYPE idnrk,
         comp_canbe TYPE mng01,
       END OF type_max_canbe.
*----------------------------------------------------------------------*
*                          INTERNAL TABLE/WORK AREA                              *
*----------------------------------------------------------------------*

DATA: itab_final    TYPE STANDARD TABLE OF type_final,
      wa_itab_final TYPE type_final.

DATA:   it_delivary TYPE STANDARD TABLE OF tt_vbfa.
*sales order stock
DATA:   it_so_stk   TYPE STANDARD TABLE OF tt_so_stock.
DATA:   wa_so_stk   TYPE tt_so_stock.


DATA: it_vbfa TYPE STANDARD TABLE OF tt_vbfa,
      wa_vbfa TYPE tt_vbfa.

DATA: it_lips TYPE STANDARD TABLE OF tt_lips,
      wa_lips TYPE tt_lips.

DATA: it_comp_canbe TYPE STANDARD TABLE OF type_canbe,
      wa_comp_canbe TYPE type_canbe.

DATA: it_max_comp_canbe TYPE STANDARD TABLE OF type_max_canbe,
      wa_max_comp_canbe TYPE type_max_canbe.


DATA: it_mdps TYPE STANDARD TABLE OF tt_mdps,
      wa_mdps TYPE tt_mdps.


DATA: it_data TYPE STANDARD TABLE OF ty_data,
      wa_data TYPE ty_data.

DATA: t_stb   TYPE STANDARD TABLE OF stpox,
      lt_stb  TYPE STANDARD TABLE OF stpox,
      lwa_stb TYPE stpox,
      wa_stb  TYPE stpox.

DATA:   it_tot_stk TYPE STANDARD TABLE OF tt_comp_tot_qty.
DATA:   wa_comp_qty TYPE tt_comp_tot_qty.
DATA:   wa_tot_stk TYPE tt_comp_tot_qty.

DATA:   wa_vbup TYPE tt_vbup.
DATA:   wa2_vbup TYPE tt_vbup2.

DATA:   i_sort  TYPE slis_t_sortinfo_alv. " Sort

*----------------------------------------------------------------------*
*                          VARIABLES                              *
*----------------------------------------------------------------------*
DATA: unrestrict_stock TYPE labst,
      stock_quality    TYPE insme,
      blocked_stk      TYPE speme,
      total_stock      TYPE mng01,
      lv_qty           TYPE mng01,
      temp_stock       TYPE mng01,
      comp_canbe       TYPE mng01,
      stock_reserve    TYPE mng01,
      mdps_so_stk      TYPE mng01,
      so_stk           TYPE mng01,
      ref_pp_stk       TYPE mng01,
      pending_qty      TYPE mengv13,
      lv_actul_canbe   TYPE mng01,
      lv_canbe         TYPE i,
      lv_knumv         TYPE knumv,
      lv_kunnr         TYPE kunnr,
      lv_name1         TYPE name1,
      wa_lfimg         TYPE lfimg,
      lv_kbetr         TYPE kbetr.

DATA: wa_vbak TYPE vbak.

DATA: gt_events          TYPE slis_t_event,        " Events
      i_list_top_of_page TYPE slis_t_listheader.   " Top-of-page

DATA: it_fcat   TYPE slis_t_fieldcat_alv,
      wa_fcat   TYPE LINE OF slis_t_fieldcat_alv, " SLIS_t_fieldcat_ALV.
      wa_layout TYPE  slis_layout_alv.     " Layout workarea
*----------------------------------------------------------------------*
*                            CONSTANTS                                 *
*----------------------------------------------------------------------*
CONSTANTS: c_formname_top_of_page TYPE slis_formname
                                  VALUE 'TOP_OF_PAGE',
           c_s                    TYPE c VALUE 'S',
           c_h                    TYPE c VALUE 'H'.
