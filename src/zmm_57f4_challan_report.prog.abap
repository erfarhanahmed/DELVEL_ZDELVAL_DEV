*&---------------------------------------------------------------------*
*& Report ZMM_57F4_CHALLAN_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_57f4_challan_report.

INCLUDE zmm_57f4_challan_report_cls.

TYPES : BEGIN OF t_mseg,
          mblnr  TYPE mblnr,     " Number of Material Document
          mjahr  TYPE char4,     " Material Document Year
          zeile  TYPE num6,      "  Item in Material Document
          matnr  TYPE matnr,     " Material Number
          werks  TYPE werks_d,   " Plant
*          lgort TYPE lgort_d,  " Storage Location
*          insmk TYPE mb_insmk, " Stock Type
*          sobkz TYPE sobkz,    " Special Stock Indicator
          lifnr  TYPE elifn,     " Vendor Account Number
          menge  TYPE j_1imenge, "  Quantity  ???? already in excise challan
          meins  TYPE j_1imeins, "  Base Unit of Measure
*          smbln TYPE mblnr,    " Number of Material Document
*          smblp TYPE mblpo,    " Item in Material Document
          bukrs  TYPE bukrs,     " Company code

          budat  TYPE budat,     " Posting Date in the Mat Doc
          xblnr  TYPE xblnr1,    " Reference Document Number
          zebeln TYPE ebeln,   " Purchasing Document Number
        END OF t_mseg,

        BEGIN OF t_ekpo,
          ebeln TYPE ebeln,   " Purchasing Document Number
          ebelp TYPE ebelp,   " Item Number of Purchasing Document
          matnr	TYPE matnr,   "	Material Number
          bukrs TYPE bukrs,   " Company code
          werks	TYPE ewerk,   "	Plant
          knttp	TYPE knttp,   "	Account Assignment Category
        END OF t_ekpo,

        BEGIN OF t_j_1iexcdtl,
          "trntyp      TYPE j_1itrntyp, " Excise Transaction Type
*          docyr       TYPE j_1idocuyr, " Year
*          docno       TYPE j_1idocno , " Internal Excise Document Number
          zeile   TYPE j_1izeile , " Item Number
          werks   TYPE werks_d   , " Plant
          exnum   TYPE j_1iexcnum, " Official Excise Document Number
          exdat   TYPE j_1iexcdat, " Excise Document Date
          exyear  TYPE j_1iexyear, " Excise Year
*          exgrp       TYPE j_1iexcgrp, " Excise Group
          lifnr   TYPE j_1ilifnr , " Vendor
*          shipfrom    TYPE lifnr     , " Account Number of Vendor or Creditor
*          lgort       TYPE lgort_d   , " Storage Location
          matnr   TYPE matnr     , " Material Number
          maktx   TYPE maktx,       " Material Description (Short Text)
*          chapid      TYPE j_1ichid,    " Chapter ID
          menge   TYPE j_1imenge,   " Quantity mentioned in the excise invoice
*          menga       TYPE j_1imenga,   " Quantity of Goods Received
*          credit_qty  TYPE j_1imengc,   "  Quantity on Which CENVAT Credit Is Taken
*          mengr       TYPE j_1imengr,   " Quantity remaining in the depot
*          scpgn       TYPE j_1iscpgn,   " Quantity of Scrap generated
          meins   TYPE j_1imeins,   " Unit of Measure
*          mengr_uom   TYPE meins,       " Base Unit of Measure
*          excur       TYPE j_1iexccur,  " Currency
*          rdoc1       TYPE j_1irdoc1,   " Reference Document 1
*          ryear1      TYPE j_1iryear1,                      " year 1
*          ritem1      TYPE j_1iritem1,                      " Item 1
*          rind1       TYPE j_1irind1 ,  " Document Type 1
          rdoc2   TYPE j_1irdoc2 ,  " Document 2
          ryear2  TYPE j_1iryear2,                      " year 2
          ritem2  TYPE j_1iritem2,                      " Item 2
*          rind2       TYPE j_1irind2 ,  " Document Type 2
*          rdoc3       TYPE j_1irdoc3 ,  " Document 3
*          rind3       TYPE j_1irind3 ,  " Document type 3
*          ntgew       TYPE ntgew_15,    " Net weight
*          brgew       TYPE brgew_15,    " Gross weight
*          gewei       TYPE gewei   ,    " Weight Unit
          ryear_2 TYPE num4,                           " year 2
        END OF t_j_1iexcdtl,

        BEGIN OF t_lfa1,
          lifnr TYPE lifnr,           " Account Number of Vendor or Creditor
*          land1 TYPE land1,          " Country Key
          name1 TYPE name1,                                 " Name 1
*         name2 TYPE name2,           " Name 2
        END OF t_lfa1,

        BEGIN OF t_mara,
          matnr   TYPE matnr,         " Material Number
          zseries TYPE zser_code,      " Series Code
          zsize   TYPE zsize,          " Size
          brand   TYPE zbrand,        " Brand
          moc     TYPE zmoc,          " MOC
          type    TYPE ztyp,          " Type
          bwkey   TYPE bwkey  ,       " Valuation Area
*          lbkum   TYPE lbkum  ,      " Total Valuated Stock
          verpr	  TYPE verpr,         "	Moving Average Price/Periodic Unit Price
          salk3   TYPE salk3  ,       " Value of Total Valuated Stock
*          stprs   TYPE stprs  ,      " Standard price
          maktx	  TYPE maktx,         "	Material Description (Short Text)
        END OF t_mara,

        BEGIN OF t_rmseg,
          mblnr TYPE mblnr,      " Number of Material Document
          mjahr TYPE char4,      " Material Document Year
          zeile TYPE num6,       " Item in Material Document
          matnr TYPE matnr,      " Material Number
          menge TYPE j_1imenge,  " Quantity
          meins TYPE j_1imeins,  " Base Unit of Measure
          ebeln TYPE ebeln,      " Purchasing Document Number
          ebelp TYPE ebelp,      " Item Number of Purchasing Document
          budat TYPE budat,      " Posting Date in the Mat Doc
*          bktxt    TYPE bktxt,      " Document Header Text
          frbnr	TYPE frbnr1,     " Number of Bill of Lading at Time of Goods Receipt
          hdmat TYPE matnr,       " Header material
        END OF t_rmseg,

        BEGIN OF t_j_1igrxsub,
          mjahr     TYPE mjahr,        "  Material Document Year
          mblnr     TYPE mblnr,        "  Number of Material Document
          zeile     TYPE mblpo,        "  Item in Material Document
          exnum     TYPE j_1iexcnum,  " Official Excise Document Number
          exyear    TYPE j_1iexyear,  " Excise Year
          exc_zeile TYPE j_1izeile,    "  Item Number
          rec_qty   TYPE j_1irecqty,  " Reconciled Qty for item in a Challan
*          rec_ind    TYPE j_1irec_ind, " Recredit Indicator
          scpgn     TYPE j_1iscpgn,    "  Quantity of Scrap generated
          meins     TYPE meins,        "  Base Unit of Measure
          ebeln	    TYPE ebeln,       "	Purchasing Document Number
          ebelp	    TYPE ebelp,       "	Item Number of Purchasing Document
          bwart	    TYPE bwart,       "	Movement Type (Inventory Management)
          budat     TYPE budat,       " Posting Date in the Document
          matnr     TYPE matnr,       " Material Number
          outmat    TYPE matnr,       " Outgoing material no
        END OF t_j_1igrxsub,

        BEGIN OF t_ekkn,
          ebeln TYPE ebeln, " Purchasing Document Number
          ebelp TYPE ebelp, " Item Number of Purchasing Document
          anln1 TYPE anln1, " Main Asset Number
          anln2 TYPE anln2, " Asset Subnumber
        END OF t_ekkn,

        BEGIN OF t_anlc,
          bukrs TYPE bukrs,     " Company code
          anln1 TYPE anln1,     " Main Asset Number
          anln2 TYPE anln2,     " Asset Subnumber
          gjahr TYPE gjahr,     " Fiscal Year
*          urwrt TYPE urwrt,     " Original acquisition value
*          menge TYPE am_menge,  " Quantity
          kansw	TYPE kansw,     "	Cumulative acquisition and production costs
          answl	TYPE answl,     "	Transactions for the year affecting asset values
        END OF t_anlc,

        BEGIN OF t_cmseg,
          mblnr TYPE mblnr,     " Cancellation doc
          mjahr TYPE mjahr,     " Cancellation Document Year
          matnr TYPE matnr,     " Material Number
          werks TYPE werks,     " Plant
          lifnr TYPE elifn,     " Vendor
          menge TYPE menge_d,   " Quantity
          meins TYPE j_1imeins, " Unit of Measure
          ebeln TYPE ebeln,     " Purchasing Document Number
          ebelp TYPE ebelp,     " Item Number of Purchasing Document
          budat TYPE budat,     " Posting Date in the Document
        END OF t_cmseg,

        BEGIN OF t_result,
          lifnr     TYPE j_1ilifnr ,  " Vendor
          name1     TYPE name1,       " Vendor Name
          zebeln    TYPE ebeln    ,   " Purchasing Document Number
          xblnr     TYPE xblnr1,      " mkpf-xblnr / likp-vbeln Reference Document Number
          mblnr     TYPE mblnr,       " Number of Material Document
          zeile     TYPE num6,        " Item Number in Material document
          mjahr     TYPE mjahr,       " Material Document Year
          budat     TYPE budat,       " Posting Date in the Mat Doc
          exnum     TYPE j_1iexcnum,  " Official Excise Document Number
          exc_zeile TYPE j_1izeile,      "  Item Number
          exdat     TYPE j_1iexcdat,  " Excise Document Date
          exyear    TYPE j_1iexyear,  " Excise Year
          matnr     TYPE matnr     ,  " Material Number
          maktx     TYPE maktx,       " Material Description (Short Text)
          menge     TYPE j_1imenge,   " Quantity mentioned in the excise invoice +++ lbkum TYPE lbkum  ,         " Total Valuated Stock
*          menga       TYPE j_1imenga,  " Quantity of Goods Received
          meins     TYPE j_1imeins,   " Unit of Measure
*          rdoc2       TYPE j_1irdoc2 , " Document 2
*          ryear2      TYPE j_1iryear2,                      " year 2
*          stprs       TYPE stprs  ,    " Standard price
*          lbkum   TYPE lbkum  ,        " Total Valuated Stock
          verpr	    TYPE verpr,           "	Moving Average Price/Periodic Unit Price
          salk3     TYPE salk3  ,     " Value of Total Valuated Stock

          rc_budat  TYPE budat,       " Posting Date in the Document
          rc_mblnr  TYPE mblnr,       " Number of Material Document
          rc_zeile  TYPE mblpo,       " Item in Material Document
          rc_mjahr  TYPE mjahr,       " Material Document Year
          rc_matnr  TYPE matnr,       " Material Number
          rc_qty    TYPE j_1irecqty,  " Reconciled Qty for challan itm
          rc_meins  TYPE meins,       " Base Unit of Measure

          "............................................................
          cmblnr    TYPE mblnr,       " Cencelation Doc No.
          cndat     TYPE budat,       " Date of cancellation
          cnyear    TYPE mjahr,       " Year of cancellation
          cnmenge   TYPE j_1imenge,   " Quantity Cancelled
          cnmeins   TYPE j_1imeins ,  " UOM
          "............................................................

          balqty    TYPE j_1irecqty,  " Balance Quantity
          balval    TYPE dmbtr,       " Amount in Local Currency
          delay     TYPE i    ,       " Delay in days


          zseries   TYPE zser_code,    " Series Code
          zsize     TYPE zsize,        " Size
          brand     TYPE zbrand,      " Brand
          moc       TYPE zmoc,        " MOC
          type      TYPE ztyp,        " Type
          werks     TYPE werks_d,     " Plant
        END OF t_result.

DATA : it_mseg       TYPE TABLE OF t_mseg,
       it_mara       TYPE TABLE OF t_mara,
       it_j_1iexcdtl TYPE TABLE OF t_j_1iexcdtl,
       it_lfa1       TYPE TABLE OF t_lfa1,
       it_j_1igrxsub TYPE TABLE OF t_j_1igrxsub,
       it_result     TYPE TABLE OF t_result,
       it_result_sum TYPE TABLE OF t_result,
       it_ekpo       TYPE TABLE OF t_ekpo,
       it_ekkn       TYPE TABLE OF t_ekkn,
       it_anlc       TYPE TABLE OF t_anlc,
       it_rmseg      TYPE TABLE OF t_rmseg,
       it_cmseg      TYPE TABLE OF t_cmseg,

       wa_mseg       TYPE t_mseg,
       wa_mara       TYPE t_mara,
       wa_j_1iexcdtl TYPE t_j_1iexcdtl,
       wa_lfa1       TYPE t_lfa1,
       wa_j_1igrxsub TYPE t_j_1igrxsub,
       wa_result     TYPE t_result,
       wa_result_tmp TYPE t_result,
       wa_result_sum TYPE t_result,
       wa_ekpo       TYPE t_ekpo,
       wa_ekkn       TYPE t_ekkn,
       wa_anlc       TYPE t_anlc,
       wa_anlc_tmp   TYPE t_anlc,
       wa_rmseg      TYPE t_rmseg,
       wa_cmseg      TYPE t_cmseg,

       " ALV related data-objects
       alv_obj       TYPE REF TO cl_salv_table,
       "lv_handler   TYPE REF TO lcl_salv_event_handler,
       lv_col        TYPE REF TO cl_salv_column,
       lv_cols       TYPE REF TO cl_salv_columns,
       lv_functions  TYPE REF TO cl_salv_functions_list,
       lv_column     TYPE REF TO cl_salv_column_list,

       wf_alv_dt     TYPE REF TO lcl_salv,
       wf_alv_sm     TYPE REF TO lcl_salv,

       ucomm         TYPE sy-ucomm,
       asst_rate     TYPE verpr,
       asst_val      TYPE salk3.

CONSTANTS : c_in TYPE char2 VALUE 'IN',
            c_x  VALUE 'X'.

*DEFINE reset_column_title.
*  CLEAR lv_col.
*
*  lv_col = lv_cols->get_column( &1 ).
*  CHECK NOT lv_col IS INITIAL.
*  IF NOT &2 IS INITIAL.
*    lv_col->set_short_text( &2 ).
*  ENDIF.
*  IF NOT &3 IS INITIAL.
*    lv_col->set_medium_text( &3 ).
*  ENDIF.
*  IF NOT &4 IS INITIAL.
*    lv_col->set_long_text( &4 ).
*  ENDIF.
*END-OF-DEFINITION.

DEFINE reset_column_title.

  lv_lbl_s  = &3.
  lv_lbl_m  = &4.
  lv_lbl_l  = &5.
  lv_tltip  = &6.

CALL METHOD &1->reset_column_title
EXPORTING
i_column = &2
i_lbl_s  = lv_lbl_s   "&3
i_lbl_m  = lv_lbl_m   "&4
i_lbl_l  = lv_lbl_l   "&5
i_tltip  = lv_tltip.  "&6.
END-OF-DEFINITION.

SELECTION-SCREEN BEGIN OF BLOCK b1  WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS : so_werks FOR wa_mseg-werks,
                so_exnum  FOR wa_j_1iexcdtl-exnum,
                so_exdat  FOR wa_j_1iexcdtl-exdat,
                so_exyr   FOR wa_j_1iexcdtl-exyear,
                so_lifnr  FOR wa_j_1iexcdtl-lifnr MATCHCODE OBJECT kred_c,
                so_matnr  FOR wa_j_1iexcdtl-matnr .
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2  WITH FRAME TITLE TEXT-006.
PARAMETERS : c_mat AS CHECKBOX,
             c_ast AS CHECKBOX.
PARAMETERS : r_dtl TYPE c RADIOBUTTON GROUP g1,
             r_sum TYPE c RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON BLOCK b2 .
  IF c_mat <> 'X' AND c_ast <> 'X'.
    MESSAGE TEXT-007 TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN.
  IF NOT so_lifnr[] IS INITIAL.
    LOOP AT so_lifnr.
      IF so_lifnr-low IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = so_lifnr-low
          IMPORTING
            output = so_lifnr-low.
      ENDIF.
      IF so_lifnr-high IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = so_lifnr-high
          IMPORTING
            output = so_lifnr-high.
      ENDIF.
      MODIFY so_lifnr.
    ENDLOOP.
  ENDIF.

INITIALIZATION.
  CLEAR : wa_mseg, wa_mara, wa_j_1iexcdtl, wa_result, wa_lfa1,
          wa_j_1igrxsub, wa_ekpo, wa_ekkn, wa_anlc, wa_anlc_tmp,
          wa_cmseg, wa_rmseg.
  REFRESH : it_mseg, it_mara, it_lfa1, it_j_1iexcdtl, it_result,
            it_result_sum, it_j_1igrxsub, it_ekpo, it_ekkn, it_anlc,
            it_cmseg, it_rmseg.

START-OF-SELECTION.
  PERFORM get_material_docs_and_pos.
  PERFORM get_material_info.
  PERFORM apply_asset_mat_filter.
  PERFORM get_vendor_info.
  PERFORM get_excise_docs.
  PERFORM determine_asset_prices.
  PERFORM get_receipt_info.
  PERFORM get_reconciliation_info .
  PERFORM get_cancellations.
  PERFORM determne_data_set.

  IF NOT it_result IS INITIAL.
    CLEAR : wa_result, wa_result_tmp.

    LOOP AT it_result INTO wa_result WHERE balqty > 0.
      IF wa_result-exnum IS INITIAL.
        LOOP AT it_result INTO wa_result_tmp
          WHERE zebeln = wa_result-zebeln
            AND mblnr = wa_result-mblnr
            AND exnum NE space.
        ENDLOOP.
        IF wa_result_tmp IS NOT INITIAL.
          wa_result-exc_zeile = wa_result_tmp-zeile.
          wa_result-exnum   = wa_result_tmp-exnum.
          wa_result-exdat   = wa_result_tmp-exdat.
          wa_result-exyear  = wa_result_tmp-exyear.
          wa_result-maktx   = wa_result_tmp-maktx.
          CLEAR wa_result_tmp.
        ENDIF.
      ENDIF.

      APPEND wa_result TO it_result_sum.
      CLEAR wa_result.
    ENDLOOP.
  ENDIF.


END-OF-SELECTION.
  IF NOT it_result IS INITIAL.
    CALL SCREEN 0101.
    "PERFORM display_results.
  ENDIF.

*----------------------------------------------------------------------*
*  MODULE DISPLAY_RESULTS OUTPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE display_results OUTPUT.
  PERFORM display_results.
ENDMODULE.                 " DISPLAY_RESULTS  OUTPUT

*&---------------------------------------------------------------------*
*&      Form  display_results
*&---------------------------------------------------------------------*
FORM display_results.
  DATA : "container_obj TYPE REF TO cl_gui_docking_container,
    container_obj TYPE REF TO cl_gui_custom_container,
    splitter_obj  TYPE REF TO cl_gui_splitter_container,
    container_1   TYPE REF TO cl_gui_container,
    container_2   TYPE REF TO cl_gui_container,
    wf_alv_obj    TYPE REF TO cl_salv_table,
    wf_alv_obj1   TYPE REF TO cl_salv_table.

  IF r_dtl = 'X'.
    PERFORM create_alv USING container_1
                              it_result
                       CHANGING wf_alv_obj.

    CREATE OBJECT wf_alv_dt
      EXPORTING
        i_alv_obj       = wf_alv_obj
        i_set_all       = c_x
        i_set_optimized = c_x.

    PERFORM set_detail_salv_view.
    PERFORM display_contents CHANGING wf_alv_dt.
  ELSE.
    PERFORM create_alv USING container_2
                         it_result_sum
                   CHANGING wf_alv_obj1.
    CREATE OBJECT wf_alv_sm
      EXPORTING
        i_alv_obj       = wf_alv_obj1
        i_set_all       = c_x
        i_set_optimized = c_x.

    PERFORM set_summary_salv_view .
    PERFORM display_contents CHANGING wf_alv_sm.
  ENDIF.
ENDFORM.                    "display_results

*&---------------------------------------------------------------------*
*&      Form  display_contents
*&---------------------------------------------------------------------*
FORM display_contents CHANGING p_alv_dt TYPE REF TO lcl_salv
*                              p_alv_sm TYPE REF TO lcl_salv
                              .

  DATA : container_h TYPE REF TO cl_gui_docking_container,
         container_f TYPE REF TO cl_gui_docking_container,

         hdr_obj     TYPE REF TO cl_salv_form_dydos.
*         ftr_obj TYPE REF TO cl_salv_form_dydos.

  PERFORM create_doc_container
    USING cl_gui_docking_container=>dock_at_top
          50
    CHANGING container_h. " for header

*  perform create_doc_container
*    USING cl_gui_docking_container=>dock_at_bottom
*          75
*    CHANGING container_f. " For footer
  " Display Headers
  CREATE OBJECT hdr_obj
    EXPORTING
      r_container = container_h
      r_content   = p_alv_dt->alv_hdr.
  hdr_obj->display( ).

  " Display ALVs
  p_alv_dt->display( ).
*  p_alv_sm->display( ).

ENDFORM.                    "display_contents

*&---------------------------------------------------------------------*
*&      Form  create_alv
*&---------------------------------------------------------------------*
FORM create_alv USING p_container   TYPE REF TO cl_gui_container
                      p_tab         TYPE table
                CHANGING p_alv_obj TYPE REF TO cl_salv_table.
  TRY .
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          r_container  = p_container
        IMPORTING
          r_salv_table = p_alv_obj
        CHANGING
          t_table      = p_tab.
    CATCH cx_salv_msg.
      MESSAGE 'Error in displaying ALV' TYPE 'I'.
      EXIT.
  ENDTRY.

ENDFORM.                    "create_alv

*&---------------------------------------------------------------------*
*&      Form  create_doc_container
*&---------------------------------------------------------------------*
FORM create_doc_container USING p_side    TYPE i
                                p_height  TYPE i
                          CHANGING p_container TYPE REF TO
                                cl_gui_docking_container.
  CREATE OBJECT p_container
    EXPORTING
      side                        = p_side
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF NOT p_height IS INITIAL.
    CALL METHOD p_container->set_height
      EXPORTING
        height = p_height.
  ENDIF.
ENDFORM.                    "create_doc_container
*&---------------------------------------------------------------------*
*&      Form  SET_DETAIL_SALV_VIEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_detail_salv_view .

  DATA: lv_column TYPE lvc_fname,
        lv_lbl_s  TYPE scrtext_s,
        lv_lbl_m  TYPE scrtext_m,
        lv_lbl_l  TYPE scrtext_l,
        lv_tltip  TYPE lvc_tip.

  wf_alv_dt->display_company_header( i_title = TEXT-004 ).
*
  " Set Totals for the columns
  wf_alv_dt->set_total( 'SALK3' ).
  wf_alv_dt->set_total( 'BALVAL' ).


*  " Show Hotspot Links " link display disables the navigation...chk why?
*  "wf_alv_dt->show_hotspot_links( 'BELNR' ).
*
*  " Set event handlers
*  wf_alv_dt->get_events( ).
*  set handler lv_handler->handle_double_click for wf_alv_dt->events.
*
  " Reset column titles
  reset_column_title :
    wf_alv_dt 'NAME1'     TEXT-051 TEXT-052 TEXT-052 TEXT-052,
    wf_alv_dt 'XBLNR'     TEXT-053 TEXT-054 TEXT-055 TEXT-055,
    wf_alv_dt 'ZEILE'     TEXT-056 TEXT-057 TEXT-058 TEXT-058,

    "wf_alv_dt 'EXC_ZEILE' text-059 text-060 text-061 text-061,
    wf_alv_dt 'EXNUM'     TEXT-062 TEXT-063 ''       ''      ,
    wf_alv_dt 'EXDAT'     TEXT-064 ''       ''       ''      ,
    wf_alv_dt 'SALK3'     TEXT-065 TEXT-066 TEXT-066 TEXT-066,
    wf_alv_dt 'VERPR'     TEXT-067 TEXT-068 TEXT-068 TEXT-068,
    wf_alv_dt 'BUDAT'     TEXT-069 ''       TEXT-070 TEXT-070,

    wf_alv_dt 'RC_MJAHR'  TEXT-071 TEXT-072 TEXT-074 TEXT-074,
    wf_alv_dt 'RC_MBLNR'  TEXT-075 TEXT-076 TEXT-077 TEXT-077,
*    wf_alv_dt 'RC_ZEILE'  text-078 text-079 text-080 text-080,
    wf_alv_dt 'RC_QTY'    TEXT-081 TEXT-082 TEXT-083 TEXT-083,
    wf_alv_dt 'BALQTY'    TEXT-084 TEXT-085 TEXT-086 TEXT-086,
    wf_alv_dt 'RC_MEINS'  TEXT-087 TEXT-087 TEXT-088 TEXT-088,
    wf_alv_dt 'RC_BUDAT'  TEXT-089 TEXT-090 TEXT-091 TEXT-091,
    wf_alv_dt 'BALVAL'    TEXT-092 TEXT-093 TEXT-094 TEXT-094,
    wf_alv_dt 'RC_MATNR'  TEXT-095 TEXT-096 TEXT-097 TEXT-097,
    wf_alv_dt 'DELAY'     TEXT-098 TEXT-099 TEXT-099 TEXT-099

*    wf_alv_dt 'CMBLNR'    text-100 text-101 text-102 text-102,
*    wf_alv_dt 'CNDAT'     text-103 text-104 text-105 text-105,
*    wf_alv_dt 'CNYEAR'    text-106 text-107 text-108 text-108,
*    wf_alv_dt 'CNMENGE'   text-109 text-110 text-111 text-111,
*    wf_alv_dt 'CNMEINS'   text-112 text-113 text-114 text-114

    .
  " Hide Columns
  wf_alv_dt->hide_column( 'RC_ZEILE'  ).
  wf_alv_dt->hide_column( 'CMBLNR'  ).
  wf_alv_dt->hide_column( 'CNDAT'   ).
  wf_alv_dt->hide_column( 'CNYEAR'  ).
  wf_alv_dt->hide_column( 'CNMENGE' ).
  wf_alv_dt->hide_column( 'CNMEINS' ).
  wf_alv_dt->hide_column( 'EXC_ZEILE' ).
*
*  " Set Align
*  wf_alv_dt->align( i_column = 'QSATZ'
*                    i_align  = IF_SALV_C_ALIGNMENT=>RIGHT ).


ENDFORM.                    " SET_DETAIL_SALV_VIEW

*&---------------------------------------------------------------------*
*&      Form  SET_SUMMARY_SALV_VIEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_summary_salv_view .
  DATA: lv_column TYPE lvc_fname,
        lv_lbl_s  TYPE scrtext_s,
        lv_lbl_m  TYPE scrtext_m,
        lv_lbl_l  TYPE scrtext_l,
        lv_tltip  TYPE lvc_tip.

  wf_alv_sm->display_company_header( i_title = TEXT-005 ).
*
  " Set Totals for the columns
  wf_alv_sm->set_total( 'BALVAL' ).

*  " Subtotals
*  wf_alv_sm->set_sort( i_column = 'QSCOD'
*                       i_subtot = if_salv_c_bool_sap=>true ).
*
*
*
  " Reset column titles
  reset_column_title :
    wf_alv_sm 'NAME1'     TEXT-051 TEXT-052 TEXT-052 TEXT-052,
    wf_alv_sm 'XBLNR'     TEXT-053 TEXT-054 TEXT-055 TEXT-055,
    wf_alv_sm 'ZEILE'     TEXT-056 TEXT-057 TEXT-058 TEXT-058,

    wf_alv_sm 'EXC_ZEILE' TEXT-059 TEXT-060 TEXT-061 TEXT-061,
    wf_alv_sm 'EXNUM'     TEXT-062 TEXT-063 ''       ''      ,
    wf_alv_sm 'EXDAT'     TEXT-064 ''       ''       ''      ,

    wf_alv_sm 'BALQTY'    TEXT-084 TEXT-085 TEXT-086 TEXT-086,
    wf_alv_sm 'RC_MEINS'  TEXT-087 TEXT-087 TEXT-088 TEXT-088,
    wf_alv_sm 'BALVAL'    TEXT-092 TEXT-093 TEXT-094 TEXT-094,
    wf_alv_sm 'DELAY'     TEXT-098 TEXT-099 TEXT-099 TEXT-099

*    wf_alv_sm 'CMBLNR'    text-100 text-101 text-102 text-102,
*    wf_alv_sm 'CNDAT'     text-103 text-104 text-105 text-105,
*    wf_alv_sm 'CNYEAR'    text-106 text-107 text-108 text-108,
*    wf_alv_sm 'CNMENGE'   text-109 text-110 text-111 text-111,
*    wf_alv_sm 'CNMEINS'   text-112 text-113 text-114 text-114
    .
  " Hide Columns
  wf_alv_sm->hide_column( 'SALK3' ).
  wf_alv_sm->hide_column( 'VERPR' ).
  wf_alv_sm->hide_column( 'RC_MJAHR' ).
  wf_alv_sm->hide_column( 'RC_MBLNR' ).
  wf_alv_sm->hide_column( 'RC_ZEILE' ).
  wf_alv_sm->hide_column( 'RC_QTY'  ).
  wf_alv_sm->hide_column( 'RC_BUDAT' ).
*  wf_alv_sm->hide_column( 'RC_MATNR' ).

  wf_alv_sm->hide_column( 'CMBLNR'  ).
  wf_alv_sm->hide_column( 'CNDAT'   ).
  wf_alv_sm->hide_column( 'CNYEAR'  ).
  wf_alv_sm->hide_column( 'CNMENGE' ).
  wf_alv_sm->hide_column( 'CNMEINS' ).

*
*  " Set Align
*  wf_alv_sm->align( i_column = 'QSATZ'
*                    i_align  = IF_SALV_C_ALIGNMENT=>RIGHT ).
ENDFORM.                    "SET_SUMMARY_SALV_VIEW
*&---------------------------------------------------------------------*
*&      Form  GET_MATERIAL_DOCS
*&---------------------------------------------------------------------*
FORM get_material_docs_and_pos .
  DATA wa_j_1iexcdtl_tmp TYPE t_j_1iexcdtl.

  IF NOT so_exnum IS INITIAL
    OR NOT so_exdat IS INITIAL
    OR NOT so_exyr IS INITIAL.
    SELECT DISTINCT
      werks
      lifnr
      matnr
      rdoc2
      ryear2
      INTO CORRESPONDING FIELDS OF TABLE it_j_1iexcdtl
      FROM j_1iexcdtl
      WHERE trntyp = '57FC'
        AND werks IN so_werks
        AND exnum IN so_exnum
        AND exdat IN so_exdat
        AND exyear IN so_exyr
        AND lifnr IN so_lifnr
        AND matnr IN so_matnr.
    IF sy-subrc = 0.
      CLEAR : wa_j_1iexcdtl_tmp, wa_j_1iexcdtl.
      LOOP AT it_j_1iexcdtl INTO wa_j_1iexcdtl.
        wa_j_1iexcdtl_tmp-ryear_2 = wa_j_1iexcdtl-ryear2.
        MODIFY it_j_1iexcdtl FROM wa_j_1iexcdtl_tmp
          TRANSPORTING ryear_2
          WHERE rdoc2 = wa_j_1iexcdtl-rdoc2
            AND ryear2 = wa_j_1iexcdtl-ryear2.
        CLEAR : wa_j_1iexcdtl_tmp, wa_j_1iexcdtl.
      ENDLOOP.

      SELECT DISTINCT
        mseg~mblnr        AS mblnr
        mseg~mjahr        AS mjahr
*        mseg~zeile        AS zeile
        mseg~line_id      AS zeile
        mseg~matnr        AS matnr
        mseg~werks        AS werks
        mseg~lifnr        AS lifnr
        mseg~menge        AS menge
        mseg~meins        AS meins
        mseg~bukrs        AS bukrs
        mkpf~budat        AS budat
        mkpf~xblnr        AS xblnr
*        zebeln                "-Jayant19Feb17
*        INTO TABLE it_mseg    "-Jayant19Feb17
        INTO CORRESPONDING FIELDS OF TABLE it_mseg    "+Jayant19Feb17
        FROM mseg
        JOIN mkpf ON  mkpf~mblnr = mseg~mblnr
                  AND mkpf~mjahr = mseg~mjahr
        LEFT OUTER JOIN likp ON  vbeln = mkpf~xblnr
        FOR ALL ENTRIES IN it_j_1iexcdtl
        WHERE mseg~mblnr = it_j_1iexcdtl-rdoc2
          AND mseg~mjahr = it_j_1iexcdtl-ryear_2
          AND xauto = space "mseg~zeile = '1'
          AND mseg~bwart = '541'
          AND mseg~matnr = it_j_1iexcdtl-matnr
          AND mseg~werks = it_j_1iexcdtl-werks
          AND mseg~lifnr = it_j_1iexcdtl-lifnr
          .
      REFRESH it_j_1iexcdtl.
    ENDIF.

  ELSE.
    SELECT DISTINCT
    mseg~mblnr        AS mblnr
    mseg~mjahr        AS mjahr
*    mseg~zeile        AS zeile
    mseg~line_id      AS zeile
    mseg~matnr        AS matnr
    mseg~werks        AS werks
    mseg~lifnr        AS lifnr
    mseg~menge        AS menge
    mseg~meins        AS meins
    mseg~bukrs        AS bukrs
    mkpf~budat        AS budat
    mkpf~xblnr        AS xblnr
*    zebeln                "-Jayant19Feb17
*    INTO TABLE it_mseg    "-Jayant19Feb17
    INTO CORRESPONDING FIELDS OF TABLE it_mseg    "+Jayant19Feb17
    FROM mseg
    JOIN mkpf ON  mkpf~mblnr = mseg~mblnr
              AND mkpf~mjahr = mseg~mjahr
    LEFT OUTER JOIN likp ON  vbeln = mkpf~xblnr
    WHERE xauto = space "mseg~zeile = '1'
      AND mseg~bwart = '541'
      AND mseg~matnr IN so_matnr
      AND mseg~werks IN so_werks
      AND mseg~lifnr IN so_lifnr
      .
  ENDIF.

  IF it_mseg IS INITIAL.
    MESSAGE TEXT-001 TYPE 'I'.
    EXIT.
  ENDIF.
ENDFORM.                    "GET_MATERIAL_DOCS_and_POs

*&---------------------------------------------------------------------*
*&      Form  GET_MATERIAL_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_material_info .
  IF NOT it_mseg IS INITIAL.
    SELECT
      mara~matnr
      zseries
      zsize
      brand
      moc
      type
      bwkey
*      lbkum
      verpr
      salk3
*      stprs
      maktx
      INTO TABLE it_mara
      FROM mara
      LEFT OUTER JOIN mbew ON mbew~matnr = mara~matnr
      LEFT OUTER JOIN makt ON makt~matnr = mara~matnr
                            AND spras = sy-langu
      FOR ALL ENTRIES IN it_mseg
      WHERE mara~matnr = it_mseg-matnr
      "  AND mbew~bwkey = it_mseg-werks
      .
    IF sy-subrc = 0.
      SORT it_mara BY matnr bwkey.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_MATERIAL_INFO

*&---------------------------------------------------------------------*
*&      Form  get_vendor_info
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_vendor_info.
  IF NOT it_mseg IS INITIAL.
    SELECT lifnr
          name1
      FROM lfa1
      INTO TABLE it_lfa1
      FOR ALL ENTRIES IN it_mseg
      WHERE lifnr = it_mseg-lifnr.
  ENDIF.
ENDFORM.                    " GET_VENDOR_INFO.

*&---------------------------------------------------------------------*
*&      Form  get_excise_docs
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_excise_docs.
  IF NOT it_mseg IS INITIAL.
    SELECT
      zeile
      werks
      exnum
      exdat
      exyear
      lifnr
      matnr
      maktx
      menge
      meins
      rdoc2
      ryear2
      ritem2
      INTO TABLE it_j_1iexcdtl
      FROM j_1iexcdtl
      FOR ALL ENTRIES IN it_mseg
      WHERE trntyp = '57FC'
        AND werks IN so_werks
        AND exnum IN so_exnum
        AND exdat IN so_exdat
        AND exyear IN so_exyr
        AND rdoc2 = it_mseg-mblnr
        AND ryear2 = it_mseg-mjahr
        AND ritem2 = it_mseg-zeile.
    IF sy-subrc <> 0.
      MESSAGE TEXT-001 TYPE 'I'.
      EXIT.
    ENDIF.
  ENDIF.
ENDFORM.                    "get_excise_docs

*&---------------------------------------------------------------------*
*&      Form  determne_data_set
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM determne_data_set .
  DATA : lv_rcvdqty LIKE wa_result-rc_qty,
         rec_count  TYPE i.
  SORT it_j_1iexcdtl BY rdoc2 ryear2 ritem2.
  SORT it_j_1igrxsub BY exnum exyear exc_zeile.
  SORT it_mseg BY zebeln mblnr mjahr zeile.
  LOOP AT it_mseg INTO wa_mseg.
    wa_result-mblnr   = wa_mseg-mblnr.
    wa_result-mjahr   = wa_mseg-mjahr.
    wa_result-zeile   = wa_mseg-zeile.
    wa_result-matnr   = wa_mseg-matnr.
    wa_result-werks   = wa_mseg-werks.
    wa_result-lifnr   = wa_mseg-lifnr.
    wa_result-budat   = wa_mseg-budat.
    wa_result-xblnr   = wa_mseg-xblnr.
    wa_result-zebeln  = wa_mseg-zebeln.
    wa_result-menge   = wa_mseg-menge.
    wa_result-meins   = wa_mseg-meins.

    READ TABLE it_mara INTO wa_mara
      WITH KEY matnr     = wa_mseg-matnr
               "bwkey     = wa_mseg-werks
               .
    IF sy-subrc = 0.
      wa_result-zseries   = wa_mara-zseries.
      wa_result-zsize     = wa_mara-zsize  .
      wa_result-brand     = wa_mara-brand  .
      wa_result-moc       = wa_mara-moc    .
      wa_result-type      = wa_mara-type   .
      wa_result-maktx     = wa_mara-maktx.

      IF wa_mara-bwkey IS INITIAL OR wa_mara-bwkey = wa_mseg-werks.
        wa_result-verpr     = wa_mara-verpr.
      ELSE.
        READ TABLE it_mara INTO wa_mara
          WITH KEY matnr     = wa_mseg-matnr
                   bwkey     = wa_mseg-werks.
        IF sy-subrc = 0.
          wa_result-verpr     = wa_mara-verpr.
        ENDIF.
      ENDIF.

      wa_result-salk3     = wa_result-verpr * wa_result-menge.
    ENDIF.

    READ TABLE it_lfa1  INTO wa_lfa1
      WITH KEY lifnr = wa_mseg-lifnr.
    IF sy-subrc = 0.
      wa_result-name1 = wa_lfa1-name1.
    ENDIF.

    " Process Challn info
    LOOP AT it_j_1iexcdtl INTO wa_j_1iexcdtl
      WHERE "matnr   = wa_mseg-matnr "???????????????
      "  AND
      rdoc2   = wa_mseg-mblnr
        AND ryear2  = wa_mseg-mjahr
        AND ritem2  = wa_mseg-zeile
         .

      wa_result-exc_zeile = wa_j_1iexcdtl-zeile.
      wa_result-exnum   = wa_j_1iexcdtl-exnum.
      wa_result-exdat   = wa_j_1iexcdtl-exdat.
      wa_result-exyear  = wa_j_1iexcdtl-exyear.
      wa_result-maktx   = wa_j_1iexcdtl-maktx.
      wa_result-menge   = wa_j_1iexcdtl-menge.
      wa_result-meins   = wa_j_1iexcdtl-meins.
      wa_result-salk3   = wa_result-verpr * wa_result-menge.

      LOOP AT it_rmseg INTO wa_rmseg WHERE ebeln = wa_mseg-zebeln
                                        AND frbnr = wa_mseg-xblnr
*                                        AND bktxt = wa_mseg-xblnr "wa_result-exnum
                                        AND matnr = wa_mseg-matnr
                                        AND menge > 0
        .
        IF NOT wa_rmseg-menge IS INITIAL
          AND lv_rcvdqty < wa_result-menge.
          wa_result-rc_mblnr = wa_rmseg-mblnr.
          wa_result-rc_mjahr = wa_rmseg-mjahr.
          wa_result-rc_zeile = wa_rmseg-zeile.
          wa_result-rc_qty   = wa_rmseg-menge.
          wa_result-rc_meins = wa_rmseg-meins.
          lv_rcvdqty = lv_rcvdqty + wa_rmseg-menge.
          wa_result-rc_budat  = wa_rmseg-budat.
*          wa_result-rc_matnr  = wa_rmseg-matnr.
          wa_result-rc_matnr  = wa_rmseg-hdmat.
          wa_result-delay     = wa_result-rc_budat - wa_result-budat.
          "APPEND wa_result TO it_result.
          ".....................................................
          IF lv_rcvdqty <= wa_result-menge.
            APPEND wa_result TO it_result.
          ELSE.
*            wa_result-cnmenge = wa_cmseg-menge - ( lv_rcvdqty - wa_result-menge ).
            wa_result-rc_qty = wa_rmseg-menge - ( lv_rcvdqty - wa_result-menge ).

*            lv_rcvdqty = lv_rcvdqty - wa_cmseg-menge + wa_result-cnmenge.
            lv_rcvdqty = lv_rcvdqty - wa_rmseg-menge + wa_result-rc_qty.
            IF wa_result-rc_qty IS NOT INITIAL.
              APPEND wa_result TO it_result.
            ENDIF.
          ENDIF.

          wa_rmseg-menge = wa_rmseg-menge - wa_result-rc_qty.
          MODIFY it_rmseg FROM wa_rmseg
            TRANSPORTING menge
            WHERE mblnr = wa_rmseg-mblnr
            AND mjahr = wa_rmseg-mjahr
            AND zeile = wa_rmseg-zeile.

          ".....................................................
        ENDIF.
        CLEAR wa_rmseg.
        IF lv_rcvdqty = wa_result-menge.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF sy-subrc <> 0.
        APPEND wa_result TO it_result.
      ENDIF.
      IF lv_rcvdqty < wa_result-menge.
        " Process Cancellation info
        CLEAR : "wa_result-exc_zeile,
                "wa_result-exnum   ,
                "wa_result-exdat   ,
                "wa_result-exyear  ,
                wa_result-rc_mjahr,
                wa_result-rc_mblnr,
                wa_result-rc_zeile,
                wa_result-rc_qty  ,

                wa_result-balval   ,
                wa_result-rc_meins ,
                wa_result-rc_budat ,
                wa_result-rc_matnr ,
                wa_result-delay    .

        LOOP AT it_cmseg INTO wa_cmseg WHERE ebeln = wa_mseg-zebeln
                                        AND matnr = wa_j_1iexcdtl-matnr."wa_mseg-matnr.
          IF wa_cmseg-menge IS INITIAL.
            CONTINUE.
          ENDIF.
*          wa_result-cmblnr  = wa_cmseg-mblnr.
*          wa_result-cndat   = wa_cmseg-budat.
*          wa_result-cnyear  = wa_cmseg-mjahr.
*          wa_result-cnmenge = wa_cmseg-menge.
*          wa_result-cnmeins = wa_cmseg-meins.

          wa_result-rc_mblnr  = wa_cmseg-mblnr.
          wa_result-rc_budat  = wa_cmseg-budat.
          wa_result-rc_mjahr  = wa_cmseg-mjahr.
          wa_result-rc_matnr  = wa_cmseg-matnr.
          wa_result-rc_qty    = wa_cmseg-menge.
          wa_result-rc_meins  = wa_cmseg-meins.

          lv_rcvdqty = lv_rcvdqty + wa_cmseg-menge.
          IF lv_rcvdqty <= wa_result-menge.
            APPEND wa_result TO it_result.
          ELSE.
*            wa_result-cnmenge = wa_cmseg-menge - ( lv_rcvdqty - wa_result-menge ).
            wa_result-rc_qty = wa_cmseg-menge - ( lv_rcvdqty - wa_result-menge ).

*            lv_rcvdqty = lv_rcvdqty - wa_cmseg-menge + wa_result-cnmenge.
            lv_rcvdqty = lv_rcvdqty - wa_cmseg-menge + wa_result-rc_qty.
            IF wa_result-rc_qty IS NOT INITIAL.
              APPEND wa_result TO it_result.
            ENDIF.
          ENDIF.
*            wa_cmseg-menge = wa_cmseg-menge - wa_result-cnmenge.
          wa_cmseg-menge = wa_cmseg-menge - wa_result-rc_qty.
          MODIFY it_cmseg FROM wa_cmseg
            TRANSPORTING menge
            WHERE mblnr = wa_cmseg-mblnr
              AND mjahr = wa_cmseg-mjahr
              AND matnr = wa_cmseg-matnr.
          CLEAR wa_cmseg.
          IF lv_rcvdqty = wa_result-menge.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

*          READ TABLE it_j_1igrxsub INTO wa_j_1igrxsub
*            WITH KEY exnum    = wa_j_1iexcdtl-exnum
*                    exyear    = wa_j_1iexcdtl-exyear
*                    exc_zeile = wa_j_1iexcdtl-zeile
*                    outmat = wa_j_1iexcdtl-matnr.
*          IF sy-subrc = 0.
*            CLEAR : rec_count, lv_rcvdqty, wa_j_1igrxsub.
*            " Process Receipt Info
*            LOOP AT it_j_1igrxsub INTO wa_j_1igrxsub
*              WHERE exnum     = wa_j_1iexcdtl-exnum
*                AND exyear    = wa_j_1iexcdtl-exyear
*                AND exc_zeile = wa_j_1iexcdtl-zeile
*                AND outmat    = wa_j_1iexcdtl-matnr
*              .
*
*              wa_result-rc_mjahr = wa_j_1igrxsub-mjahr.
*              wa_result-rc_mblnr = wa_j_1igrxsub-mblnr.
*              wa_result-rc_zeile = wa_j_1igrxsub-zeile.
*              wa_result-rc_qty   = wa_j_1igrxsub-rec_qty.
*              lv_rcvdqty = lv_rcvdqty + wa_result-rc_qty.
*    *          IF sy-index = rcvdoc_count.
*    *            wa_result-balqty   = wa_result-menge - lv_rcvdqty.
*    *          else.
*              CLEAR wa_result-balqty.
*    *          ENDIF.
*              "wa_result-balval    = wa_result-balqty * wa_result-verpr."XXXXXX
*              wa_result-rc_meins  = wa_j_1igrxsub-meins.
*              wa_result-rc_budat  = wa_j_1igrxsub-budat.
*    *          wa_result-rc_dmbtr = wa_j_1igrxsub-dmbtr.
*              wa_result-rc_matnr  = wa_j_1igrxsub-matnr.
*              wa_result-delay     = wa_result-rc_budat - wa_result-budat.
*              APPEND wa_result TO it_result.
*
*              CLEAR wa_j_1igrxsub.
*            ENDLOOP.
*    *        IF not lv_rcvdqty is initial.
*    *          " Set balance quantity for last received doc of resp challan
*    *          describe table it_result lines rec_count.
*    *          wa_result-balqty   = wa_result-menge - lv_rcvdqty.
*    *          wa_result-balval   = wa_result-balqty * wa_result-verpr.
*    *          modify it_result index rec_count from wa_result
*    *            transporting balqty balval.
*    *        ENDIF.
*          ELSE.
*    *        wa_result-balqty  = wa_result-menge.
*    *        wa_result-balval  = wa_result-salk3.
*    *        wa_result-delay   = sy-datum - wa_result-budat.
*            APPEND wa_result TO it_result.
*          ENDIF.
      CLEAR wa_j_1iexcdtl.
    ENDLOOP.
*    IF sy-subrc <> 0.
*      Set_append_flag  = 1.
*      "APPEND wa_result TO it_result.
*    ENDIF.

    READ TABLE it_result INTO wa_result_tmp
      WITH KEY mblnr = wa_result-mblnr
               mjahr = wa_result-mjahr
               zeile = wa_result-zeile.
    IF sy-subrc <> 0.
      APPEND wa_result TO it_result.
    ENDIF.

**    IF NOT lv_rcvdqty IS INITIAL.
**      " Set balance quantity for last received doc of resp challan
**      DESCRIBE TABLE it_result LINES rec_count.
**      wa_result-balqty   = wa_result-menge - lv_rcvdqty.
**      wa_result-balval   = wa_result-balqty * wa_result-verpr.
**      MODIFY it_result INDEX rec_count FROM wa_result
**        TRANSPORTING balqty balval.
**    ENDIF.


    " Set balance quantity for last received doc of resp challan
    CLEAR wa_result.
    DESCRIBE TABLE it_result LINES rec_count.
    READ TABLE it_result INTO wa_result INDEX rec_count.
    IF wa_result-exnum IS NOT INITIAL AND wa_result-rc_mblnr IS INITIAL.
      wa_result-balqty = wa_result-menge.
      wa_result-balval = wa_result-salk3.
      MODIFY it_result INDEX rec_count FROM wa_result
        TRANSPORTING balqty balval.
    ELSE.
      IF NOT lv_rcvdqty IS INITIAL.
        wa_result-balqty = wa_result-menge - lv_rcvdqty.
        wa_result-balval = wa_result-balqty * wa_result-verpr.
        MODIFY it_result INDEX rec_count FROM wa_result
        TRANSPORTING balqty balval.
      ENDIF.
    ENDIF.

    CLEAR : wa_mseg, wa_mara, wa_result, wa_lfa1, wa_j_1igrxsub, lv_rcvdqty.
    CLEAR wa_result.
  ENDLOOP.

******************  " Determine balance qty for challans having no receipt/cancellation.
******************  sort it_result by zebeln xblnr mblnr.
******************
******************  LOOP AT it_result into wa_result where exnum ne space.
******************    IF wa_result-rc_mblnr is initial.
******************      read table it_result into wa_result_tmp
******************        with key zebeln = wa_result-zebeln
******************                 xblnr  = wa_result-xblnr
******************                 mblnr  = wa_result-mblnr
******************                 rc_mblnr <> wa_result-rc_mblnr.
******************      IF sy-subrc <> 0.
******************        wa_result-balqty = wa_result-menge.
******************        wa_result-balval = wa_result-salk3.
******************        modify it_result from wa_result
******************          transporting balqty balval
******************          where zebeln = wa_result-zebeln
******************            and xblnr  = wa_result-xblnr
******************            and mblnr  = wa_result-mblnr
******************            and exnum  = wa_result-exnum.
******************      ENDIF.
******************    ENDIF.
******************    clear : wa_result, wa_result_tmp.
******************  ENDLOOP.
ENDFORM.                    " DETERMNE_DATA_SET

*&---------------------------------------------------------------------*
*&      Form  GET_RECEIPT_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_receipt_info.
  TYPES : BEGIN OF t_rcpt,
            mblnr TYPE mblnr,
            mjahr TYPE mjahr,
            matnr TYPE matnr,
            ebeln TYPE ebeln,
            ebelp TYPE ebelp,
          END OF t_rcpt.
  DATA : it_rcpt TYPE TABLE OF t_rcpt,
         wa_rcpt TYPE t_rcpt.
  REFRESH it_rcpt.
  CLEAR : wa_rcpt.

  IF NOT it_ekpo IS INITIAL.
    SELECT
        mseg~mblnr AS mblnr
        mseg~mjahr AS mjahr
        mseg~zeile AS zeile
        mseg~matnr AS matnr
        mseg~menge AS menge
        mseg~meins AS meins
        ebeln
        ebelp
        budat      AS budat
*        bktxt
        frbnr
      INTO TABLE it_rmseg
      FROM mseg
      JOIN mkpf ON mkpf~mblnr = mseg~mblnr
                AND mkpf~mjahr = mseg~mjahr
      FOR ALL ENTRIES IN it_ekpo
      WHERE mseg~bwart = '543'
        AND mseg~ebeln = it_ekpo-ebeln
        AND mseg~ebelp = it_ekpo-ebelp.
    IF sy-subrc = 0.
*      SORT it_rmseg BY ebeln bktxt matnr.
      SORT it_rmseg BY ebeln frbnr matnr.

      SELECT mblnr
            mjahr
            matnr
            ebeln
            ebelp
        INTO TABLE it_rcpt
        FROM mseg
        FOR ALL ENTRIES IN it_ekpo
        WHERE mseg~bwart = '101'
        AND mseg~ebeln = it_ekpo-ebeln
        AND mseg~ebelp = it_ekpo-ebelp.
      IF sy-subrc = 0.
        LOOP AT it_rcpt INTO wa_rcpt.
          CLEAR wa_rmseg.
          wa_rmseg-hdmat = wa_rcpt-matnr.
          MODIFY it_rmseg FROM wa_rmseg TRANSPORTING hdmat
            WHERE ebeln = wa_rcpt-ebeln
              AND ebelp = wa_rcpt-ebelp.
          CLEAR wa_rcpt.
        ENDLOOP.
      ENDIF.

    ENDIF.
  ENDIF.
ENDFORM.                    "get_receipt_info
*&---------------------------------------------------------------------*
*&      Form  GET_RECEIPT_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_reconciliation_info .
  DATA : lv_num            TYPE num6,
         wa_j_1igrxsub_tmp TYPE t_j_1igrxsub.
  IF NOT it_j_1iexcdtl IS INITIAL.
    SORT it_j_1iexcdtl BY exnum exyear zeile.
    SELECT
      mjahr
      mblnr
      zeile
      exnum
      exyear
      exc_zeile
      rec_qty
      "rec_ind
      scpgn
      meins
      ebeln
      ebelp
      bwart
      budat
      matnr
      INTO TABLE it_j_1igrxsub
      FROM j_1igrxsub
      JOIN ekbe ON  ekbe~gjahr = j_1igrxsub~mjahr
                AND ekbe~belnr = j_1igrxsub~mblnr
                "AND bwart = '101'
      FOR ALL ENTRIES IN it_j_1iexcdtl
      WHERE exnum = it_j_1iexcdtl-exnum
        AND exyear  = it_j_1iexcdtl-exyear
        AND exc_zeile = it_j_1iexcdtl-zeile
*        AND (ekbe~buzei = j_1igrxsub~zeile OR
*       ekbe~buzei = j_1igrxsub~zeile - 1)
        .
    IF sy-subrc = 0.
      LOOP AT it_j_1igrxsub INTO wa_j_1igrxsub.
        READ TABLE it_ekpo INTO wa_ekpo
          WITH KEY ebeln = wa_j_1igrxsub-ebeln
                   ebelp = wa_j_1igrxsub-ebelp.
        IF sy-subrc <> 0.
          DELETE TABLE it_j_1igrxsub FROM wa_j_1igrxsub.
        ENDIF.
        CLEAR : wa_j_1igrxsub, wa_ekpo.
      ENDLOOP.

      LOOP AT it_j_1igrxsub INTO wa_j_1igrxsub WHERE bwart = '543'.
        wa_j_1igrxsub_tmp-outmat = wa_j_1igrxsub-matnr.
        MODIFY it_j_1igrxsub FROM wa_j_1igrxsub_tmp TRANSPORTING outmat
          WHERE ebeln = wa_j_1igrxsub-ebeln
            AND ebelp = wa_j_1igrxsub-ebelp
            AND mjahr = wa_j_1igrxsub-mjahr
            AND mblnr = wa_j_1igrxsub-mblnr
            AND bwart = '101'.
        DELETE TABLE it_j_1igrxsub FROM wa_j_1igrxsub.
        CLEAR : wa_j_1igrxsub, wa_j_1igrxsub_tmp.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_RECEIPT_INFO

*----------------------------------------------------------------------*
*  MODULE SET_PF_STATUS OUTPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE set_pf_status OUTPUT.
  SET PF-STATUS 'ZMM_CHALLAN_REP_STAT'.
ENDMODULE.                 " SET_PF_STATUS  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  HANDLE_USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE handle_user_command INPUT.
  CASE ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " HANDLE_USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*&      Form  APPLY_ASSET_MAT_FILTER
*----------------------------------------------------------------------*
FORM apply_asset_mat_filter .
  DATA : str TYPE string.
  CLEAR : str.

  str = 'ebeln = it_mseg-zebeln and bukrs = it_mseg-bukrs'.
  IF c_mat = 'X' AND c_ast <> 'X'.
    CONCATENATE str 'knttp IN (space, ''E'', ''M'')'
    INTO str SEPARATED BY ' and '.
  ELSEIF c_mat <> 'X' AND c_ast = 'X'.
    CONCATENATE str 'knttp IN (''A'', ''K'')'
    INTO str SEPARATED BY ' and '.
  ELSE.
    CONCATENATE str 'knttp IN (space, ''A'', ''E'', ''K'', ''M'')'
    INTO str SEPARATED BY ' and '.
  ENDIF.

  IF NOT it_mseg IS INITIAL.
    SELECT ebeln
            ebelp
            matnr
            bukrs
            werks
            knttp
      INTO TABLE it_ekpo
      FROM ekpo
      FOR ALL ENTRIES IN it_mseg
      WHERE (str).
  ENDIF.

  IF c_mat <> 'X' AND c_ast = 'X'.
    DELETE it_mseg WHERE zebeln IS INITIAL.
  ENDIF.

  LOOP AT it_mseg INTO wa_mseg WHERE zebeln IS NOT INITIAL.
    READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_mseg-zebeln.
    IF sy-subrc <> 0.
      DELETE TABLE it_mseg FROM wa_mseg.
    ENDIF.
    CLEAR wa_mseg.
  ENDLOOP.

  IF it_mseg IS INITIAL.
    MESSAGE TEXT-001 TYPE 'I'.
    EXIT.
  ENDIF.
ENDFORM.                    " APPLY_ASSET_MAT_FILTER

*&---------------------------------------------------------------------*
*&      Form  get_cancellations
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_cancellations.
  IF NOT it_mseg IS INITIAL.
    SELECT mseg~mblnr
           mseg~mjahr
           mseg~matnr
           mseg~werks
           mseg~lifnr
           mseg~menge
           mseg~meins
           mseg~ebeln
           mseg~ebelp
           mkpf~budat
      INTO TABLE it_cmseg
      FROM mseg
        JOIN mkpf ON mkpf~mblnr = mseg~mblnr
                  AND mkpf~mjahr = mseg~mjahr
      FOR ALL ENTRIES IN it_mseg
      WHERE xauto = space                                   "zeile = 1
        AND bwart = '542'
        AND ebeln = it_mseg-zebeln.
    IF sy-subrc = 0.
      DELETE it_cmseg WHERE ebeln EQ space.
      SORT it_cmseg BY ebeln matnr.
    ENDIF.
  ENDIF.

ENDFORM.                    "get_cancellations
*&---------------------------------------------------------------------*
*&      Form  DETERMINE_ASSET_PRICES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM determine_asset_prices .
  DATA : it_lines TYPE TABLE OF tline,
         wa_line  TYPE tline,
         obj_name TYPE tdobname,
         str      TYPE string.

  IF c_ast = 'X' AND NOT it_ekpo IS INITIAL.
    IF NOT it_ekpo IS INITIAL.
      SELECT ebeln
             ebelp
             anln1
             anln2
        INTO TABLE it_ekkn
        FROM ekkn
        FOR ALL ENTRIES IN it_ekpo
        WHERE ekkn~ebeln = it_ekpo-ebeln
          AND ekkn~ebelp = it_ekpo-ebelp
          AND ekkn~zekkn = '1'
        .
    ENDIF.
    IF NOT it_ekkn IS INITIAL.
      SORT it_ekkn BY anln2.
      CLEAR wa_ekkn.
      wa_ekkn-anln2 = '0000'.
      MODIFY it_ekkn FROM wa_ekkn TRANSPORTING anln2
        WHERE anln2 IS INITIAL.

      SORT it_ekkn BY anln1 anln2.
      SELECT bukrs
             anln1
             anln2
             gjahr
*             urwrt
*             menge
             kansw
             answl
        INTO TABLE it_anlc
        FROM anlc
        FOR ALL ENTRIES IN it_ekkn
        WHERE anln1 = it_ekkn-anln1
          AND anln2 = it_ekkn-anln2
          AND afabe = '1'.
      IF sy-subrc = 0.
        SORT it_anlc BY bukrs anln1 anln2.
      ENDIF.
    ENDIF.
    LOOP AT it_ekpo INTO wa_ekpo.
      CLEAR : wa_mseg, wa_j_1iexcdtl.
      READ TABLE it_mseg INTO wa_mseg
        WITH KEY zebeln = wa_ekpo-ebeln.

      IF wa_ekpo-knttp = 'A'.
        READ TABLE it_ekkn INTO wa_ekkn WITH KEY ebeln = wa_ekpo-ebeln
                                               ebelp = wa_ekpo-ebelp.
        IF sy-subrc = 0.
          CLEAR : wa_anlc, wa_anlc_tmp, asst_val, asst_rate.
*++++++++++++++++++++++++++++++++++++++++++++++
          IF wa_mseg IS NOT INITIAL.
            READ TABLE it_j_1iexcdtl INTO wa_j_1iexcdtl
              WITH KEY rdoc2   = wa_mseg-mblnr
                       ryear2  = wa_mseg-mjahr
                       ritem2  = wa_mseg-zeile.
            IF sy-subrc = 0.
              READ TABLE it_anlc INTO wa_anlc
                WITH KEY bukrs = wa_ekpo-bukrs
                         anln1 = wa_ekkn-anln1
                         anln2 = wa_ekkn-anln2
                         gjahr = wa_j_1iexcdtl-exyear.
            ELSE.
              READ TABLE it_anlc INTO wa_anlc
                WITH KEY bukrs = wa_ekpo-bukrs
                         anln1 = wa_ekkn-anln1
                         anln2 = wa_ekkn-anln2
                         gjahr = wa_mseg-mjahr.
            ENDIF.
          ENDIF.
          IF wa_anlc IS NOT INITIAL.
            asst_rate = wa_anlc-kansw + wa_anlc-answl.
          ENDIF.
          CLEAR : wa_ekkn, wa_anlc.
        ENDIF.
      ELSEIF wa_ekpo-knttp = 'K'.
        REFRESH it_lines.
        CLEAR : str, wa_line, obj_name.
*        obj_name = wa_ekpo-ebeln.
        obj_name = wa_mseg-xblnr.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
*           CLIENT                  = SY-MANDT
            id                      = '0002'
            language                = sy-langu
            name                    = obj_name
            object                  = 'VBBK'
*           ARCHIVE_HANDLE          = 0
*           LOCAL_CAT               = ' '
*         IMPORTING
*           HEADER                  =
          TABLES
            lines                   = it_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc = 0.
          LOOP AT it_lines INTO wa_line WHERE tdline IS NOT INITIAL.
            FIND REGEX '([0-9|,]+[/.][0-9]{2})' IN wa_line-tdline SUBMATCHES str.
            IF str IS NOT INITIAL.
              asst_rate = str.
              EXIT.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      IF NOT asst_rate IS INITIAL.
        READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_ekpo-matnr.
        IF sy-subrc = 0.
          wa_mara-verpr = asst_rate.
          MODIFY it_mara FROM wa_mara
            TRANSPORTING verpr
            WHERE matnr = wa_mara-matnr.
        ENDIF.
      ENDIF.
      CLEAR : wa_mara, wa_ekpo, asst_rate, asst_val.
    ENDLOOP.

  ENDIF.
ENDFORM.                    " DETERMINE_ASSET_PRICES
