*&---------------------------------------------------------------------*
*& REPORT  ZSD_CONTRY_MARGIN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zsd_socont_margin NO STANDARD PAGE HEADING MESSAGE-ID zdel.

INCLUDE zsd_socont_margin_cls.  "zclsalv.

TYPES : BEGIN OF t_vbak,
          vbeln	TYPE vbeln_va,    "	BILLING DOCUMENT
          erdat TYPE erdat,       " DATE ON WHICH RECORD WAS CREATED
          audat TYPE audat,       "Document Date (Date Received/Sent)
          waerk TYPE waerk,       " SD Document Currency
          vkbur TYPE vkbur,       "Sales Office
          knumv	TYPE knumv,       "	NUMBER OF THE DOCUMENT CONDITION
          kunnr TYPE kunag,       " SOLD-TO PARTY
          bstkd	TYPE bstkd,       " Customer purchase order number
          kursk TYPE kursk,       " Exchange Rate for Price Determination
        END OF t_vbak,

        BEGIN OF t_vbap,
          vbeln  TYPE vbeln_va,
          posnr	 TYPE posnr_va,  " BILLING ITEM
          matnr	 TYPE matnr,     " MATERIAL NUMBER
          arktx  TYPE arktx,     " Short text for sales order item
          kwmeng TYPE kwmeng,    " Cumulative Order Quantity in Sales Units
          werks  TYPE werks_d,   " Plant (Own or External)
          stprs  TYPE stprs,     "  Standard price
        END OF t_vbap,

        BEGIN OF t_kna1,
          kunnr TYPE kunnr,    " CUSTOMER NUMBER
          name1 TYPE name1_gp, " NAME
        END OF t_kna1,

        BEGIN OF t_konv,
          knumv	TYPE knumv,   " NUMBER OF THE DOCUMENT CONDITION
          kposn	TYPE kposn,	   " CONDITION ITEM NUMBER
          kschl	TYPE kscha,	   " CONDITION TYPE
          kbetr	TYPE kbetr,	   " RATE (CONDITION AMOUNT OR PERCENTAGE)
          waers	TYPE waers,   "	Currency Key
          kwert	TYPE kwert,	   " CONDITION VALUE
        END OF t_konv,

        BEGIN OF t_mara,
          matnr   TYPE mara-matnr,
          zseries TYPE mara-zseries,
          zsize   TYPE  mara-zsize,
          brand   TYPE mara-brand,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
        END OF t_mara,

        BEGIN OF t_result,
          kunnr      TYPE kunnr,         " Customer
          bstkd	     TYPE bstkd,         " Customer Reference
          name1      TYPE name1_gp,      " Customer Name
          vkbur      TYPE vkbur,         " Sales Office
          vbeln	     TYPE vbeln_va,      " Sales Doc
          audat      TYPE audat,         " SO Date
          matnr      TYPE matnr,         " Material
          arktx      TYPE arktx,         " Material Description
          werks      TYPE werks_d,       " Plant (Own or External)
          zseries    TYPE mara-zseries,  " Series
          zsize      TYPE  mara-zsize,   " Size
          brand      TYPE mara-brand,    " Brand
          moc        TYPE mara-moc,      " MOC
          type       TYPE mara-type,     " Type
          kwmeng     TYPE kwmeng,        " SO Quantity

          so_rate    TYPE kbetr,         " SO Rate
          so_amt     TYPE kwert,         " SO Amount
          dscnt      TYPE kbetr,         " Discount
          tot_dscnt  TYPE kwert,         " Total Discount
          price      TYPE stprs,         " Standard price
          tot_price  TYPE stprs,         " Total Standard price
          estcost    TYPE kwert,         " Estimated Cost
          totestcost TYPE kwert,        " Total Estimated Cost
          intprice   TYPE kbetr,         " Internal Price
          totintprc  TYPE kwert,         " Total Internal Price
          pfcost     TYPE kbetr,         " P & F cost
          totpfcost  TYPE kwert,         " Total P & F cost
          prpcntry   TYPE zprpcontry,     " Proposed Contribution
          actcntry   TYPE zactcontry,     " Actual Contribution
        END OF t_result.

DATA : wa_vbak   TYPE t_vbak,
       wa_vbap   TYPE t_vbap,
       wa_kna1   TYPE t_kna1,
       wa_konv   TYPE t_konv,
       wa_result TYPE t_result,
       wa_mara   TYPE t_mara,

       it_vbak   TYPE TABLE OF t_vbak,
       it_vbap   TYPE TABLE OF t_vbap,
       it_kna1   TYPE TABLE OF t_kna1,
       it_konv   TYPE TABLE OF t_konv,
       it_result TYPE TABLE OF t_result,
       it_mara   TYPE TABLE OF t_mara,

       lc_msg    TYPE REF TO cx_salv_msg,
       alv_obj   TYPE REF TO cl_salv_table,

       wf_alv    TYPE REF TO lcl_salv,
       lv_col    TYPE REF TO cl_salv_column,
       lv_cols   TYPE REF TO cl_salv_columns,
*       lv_functions   TYPE REF TO cl_salv_functions_list,
       lv_column TYPE REF TO cl_salv_column_list,

       lv_val    TYPE p. "MAXBT.

*       lyot_txt   TYPE REF TO cl_salv_form_layout_grid,
*       lyot_lbl   TYPE REF TO cl_salv_form_label,
*       lyot_flow  TYPE REF TO cl_salv_form_layout_flow,
*       lyot_func  TYPE REF TO cl_salv_functions,
*       lyot_disp  TYPE REF TO cl_salv_display_settings,
*       lyot_lout  TYPE REF TO cl_salv_layout,
*       lyot_key   TYPE        salv_s_layout_key,
*       txt        TYPE string,
*       zpp_qty    TYPE string,
*       v_datelow  TYPE char10,
*       v_datehigh TYPE char10,
*       var_i      TYPE i VALUE '1'.

CONSTANTS : c_x     VALUE 'X',
            c_colon VALUE ':',
            c_hypen VALUE '-'.

DEFINE reset_column_title.
  CALL METHOD &1->reset_column_title
    EXPORTING
      i_column = &2
      i_lbl_s  = &3
      i_lbl_m  = &4
      i_lbl_l  = &5
      i_tltip  = &6.
END-OF-DEFINITION.

DEFINE set_footer_text.
  CALL METHOD &1->set_footer_text
    EXPORTING
      i_row = &2
      i_col = &3
      i_typ = &4
      i_txt = &5.
END-OF-DEFINITION.

INITIALIZATION.
  CLEAR   : wa_konv, wa_result.
  REFRESH : it_konv, it_result.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  SELECT-OPTIONS : so_date FOR wa_vbak-erdat.
  SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_sales_docs.
  PERFORM get_sales_oredr_items.
  PERFORM fetch_customer_info.
  PERFORM get_material_info.
  PERFORM fetch_pricing_info.
  PERFORM determne_data_set.

END-OF-SELECTION.
  IF NOT it_result IS INITIAL.
    PERFORM display_results.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  get_sales_docs
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_sales_docs.
  SELECT vbak~vbeln
         erdat
         audat
         waerk
         vkbur
         knumv
         kunnr
         bstkd
         kursk
    FROM vbak
    LEFT OUTER JOIN vbkd ON vbkd~vbeln = vbak~vbeln
                          "AND vbkd~posnr = vbap~posnr
    INTO TABLE it_vbak
    WHERE erdat IN so_date
      AND vbtyp IN ('C', 'I')
      AND auart IN ('ZDEX', 'ZED', 'ZFRE', 'ZOR', 'ZREP', 'ZROW').
  IF sy-subrc <> 0.
    MESSAGE TEXT-000 TYPE 'I'.
    EXIT.
  ENDIF.
ENDFORM.                    "get_sales_docs

*&---------------------------------------------------------------------*
*&      Form  get_sales_oredr_items
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_sales_oredr_items.
  IF NOT it_vbak IS INITIAL.
    SELECT vbap~vbeln
           vbap~posnr
           vbap~matnr
           arktx
           kwmeng
           werks
           stprs
      FROM vbap
      LEFT OUTER JOIN mbew ON mbew~matnr = vbap~matnr
                          AND mbew~bwkey = vbap~werks
      INTO TABLE it_vbap
      FOR ALL ENTRIES IN it_vbak
      WHERE vbap~vbeln = it_vbak-vbeln.
  ENDIF.
ENDFORM.                    "get_sales_oredr_items

*&---------------------------------------------------------------------*
*&      Form  fetch_customer_info
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fetch_customer_info.
  IF NOT it_vbak IS INITIAL.
    SELECT kunnr
           name1
      FROM kna1
      INTO TABLE it_kna1
      FOR ALL ENTRIES IN it_vbak
      WHERE kunnr = it_vbak-kunnr.
  ENDIF.
ENDFORM.                    "fetch_customer_info

*&---------------------------------------------------------------------*
*&      Form  get_material_info
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_material_info.
  IF NOT it_vbap IS INITIAL.
    SELECT matnr
           zseries
           zsize
           brand
           moc
           type
      FROM mara
      INTO TABLE it_mara
     FOR ALL ENTRIES IN it_vbap
     WHERE matnr = it_vbap-matnr.
  ENDIF.
ENDFORM.                    "get_material_info

*&---------------------------------------------------------------------*
*&      Form  fetch_pricing_info
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fetch_pricing_info.
  SELECT knumv
         kposn
         kschl
         kbetr
         waers
         kwert
   from   PRCD_ELEMENTS "FROM konv
    INTO TABLE it_konv
    FOR ALL ENTRIES IN it_vbak
    WHERE knumv = it_vbak-knumv
      AND kschl IN ('ZPR0', 'ZDIS', 'ZESC', 'VPRS',
                    'ZPFO', 'ZPRC', 'ZACC').
ENDFORM.                    "fetch_pricing_info

*&---------------------------------------------------------------------*
*&      Form  determne_data_set
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM determne_data_set.
  SORT it_vbap BY vbeln posnr.
  SORT it_konv BY knumv kposn kschl.
  LOOP AT it_vbak INTO wa_vbak.

    wa_result-vbeln = wa_vbak-vbeln.
    wa_result-audat = wa_vbak-audat.
    wa_result-vkbur = wa_vbak-vkbur.
*    wa_result- = wa_vbak-knumv.
    wa_result-kunnr = wa_vbak-kunnr.
    wa_result-bstkd = wa_vbak-bstkd.

    " set customer info
    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_result-kunnr.
    IF sy-subrc = 0.
      wa_result-name1 = wa_kna1-name1.
      CLEAR wa_kna1.
    ENDIF.

    " Process line item records
    LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_result-vbeln.
*           wa_vbap-posnr.
      wa_result-matnr  = wa_vbap-matnr.
      wa_result-arktx  = wa_vbap-arktx.
      wa_result-kwmeng = wa_vbap-kwmeng.
      wa_result-werks  = wa_vbap-werks.
      wa_result-price  = wa_vbap-stprs.
      wa_result-tot_price = wa_result-price * wa_result-kwmeng.

      " Set Material Info
      READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_result-matnr.
      wa_result-zseries = wa_mara-zseries.
      wa_result-zsize   = wa_mara-zsize  .
      wa_result-brand   = wa_mara-brand  .
      wa_result-moc     = wa_mara-moc    .
      wa_result-type    = wa_mara-type   .
      wa_result-prpcntry = 0.
      wa_result-actcntry = 0.
      " Set Pricing info
      READ TABLE it_konv  INTO wa_konv  WITH KEY knumv = wa_vbak-knumv
                                                 kposn = wa_vbap-posnr
                                                 kschl = 'ZPR0'.
      IF sy-subrc = 0.
        wa_result-so_rate = wa_konv-kbetr.  " SO Rate
        wa_result-so_amt  = wa_konv-kwert.
        IF wa_vbak-waerk <> 'INR'.

*          wa_result-so_amt  = wa_result-so_amt * wa_vbak-kursk.  " SO Amount
***          clear lv_val.
***          lv_val  = wa_result-so_amt * wa_vbak-kursk.  " SO Amount
***          wa_result-so_amt = lv_val.
          IF wa_konv-waers <> 'INR'.
            wa_result-so_rate = wa_result-so_rate * wa_vbak-kursk.
            wa_result-so_amt = wa_result-so_amt * wa_vbak-kursk.
          ELSE.
            wa_result-so_amt = wa_result-so_rate * wa_result-kwmeng.
          ENDIF.
        ENDIF.

        CLEAR wa_konv.
      ENDIF.


      READ TABLE it_konv  INTO wa_konv  WITH KEY knumv = wa_vbak-knumv
                                                 kposn = wa_vbap-posnr
                                                 kschl = 'ZDIS'.
      IF sy-subrc = 0.
        wa_result-dscnt     = wa_konv-kbetr / 10.  " Discount
        wa_result-tot_dscnt = wa_konv-kwert.  " Total Discount
        IF wa_vbak-waerk <> 'INR'.
          IF wa_konv-waers <> 'INR'.
            wa_result-tot_dscnt = wa_result-tot_dscnt * wa_vbak-kursk.
          ELSE.
            wa_result-tot_dscnt = wa_result-dscnt * wa_result-kwmeng.
          ENDIF.
        ENDIF.
        CLEAR wa_konv.
      ENDIF.


      READ TABLE it_konv  INTO wa_konv  WITH KEY knumv = wa_vbak-knumv
                                                 kposn = wa_vbap-posnr
                                                 kschl = 'ZESC'.
      IF sy-subrc = 0.
        wa_result-estcost    = wa_konv-kbetr." / 10. " Estimated Cost
        wa_result-totestcost = wa_konv-kwert. " Total Estimated Cost
        IF wa_vbak-waerk <> 'INR'.
          IF wa_konv-waers <> 'INR'.
            wa_result-estcost = wa_result-estcost * wa_vbak-kursk.
            wa_result-totestcost = wa_result-totestcost * wa_vbak-kursk.
          ELSE.
            wa_result-totestcost = wa_konv-kbetr * wa_result-kwmeng.
          ENDIF.
        ENDIF.
        CLEAR wa_konv.
      ENDIF.



      READ TABLE it_konv  INTO wa_konv  WITH KEY knumv = wa_vbak-knumv
                                                 kposn = wa_vbap-posnr
                                                 kschl = 'VPRS'.
      IF sy-subrc = 0.
        wa_result-intprice  = wa_konv-kbetr.  " Internal Price
        wa_result-totintprc = wa_konv-kwert.  " Total Internal Price
        IF wa_vbak-waerk <> 'INR'.
*          clear lv_val.
*          lv_val = wa_result-totintprc * wa_vbak-kursk.
*          wa_result-totintprc  = lv_val.
          IF wa_konv-waers <> 'INR'.
            wa_result-intprice  = wa_result-intprice  * wa_vbak-kursk.
            wa_result-totintprc = wa_result-totintprc * wa_vbak-kursk.
          ELSE.
            wa_result-totintprc = wa_result-intprice * wa_result-kwmeng.
          ENDIF.
        ENDIF.
        CLEAR wa_konv.
      ENDIF.


      READ TABLE it_konv  INTO wa_konv  WITH KEY knumv = wa_vbak-knumv
                                                 kposn = wa_vbap-posnr
                                                 kschl = 'ZPFO'.
      IF sy-subrc = 0.
        wa_result-pfcost    = wa_konv-kbetr / 10.  " P & F cost
        wa_result-totpfcost = wa_konv-kwert.  " Total P & F cost
        IF wa_vbak-waerk <> 'INR'.
*          clear lv_val.
*          lv_val = wa_result-totpfcost * wa_vbak-kursk.  " SO Amount
*          wa_result-totpfcost = lv_val.
          IF wa_konv-waers <> 'INR'.
            wa_result-totpfcost = wa_result-totpfcost * wa_vbak-kursk.
          ELSE.
            wa_result-totpfcost = wa_result-pfcost * wa_result-kwmeng.
          ENDIF.
        ENDIF.
        CLEAR wa_konv.
      ENDIF.


      READ TABLE it_konv  INTO wa_konv  WITH KEY knumv = wa_vbak-knumv
                                                 kposn = wa_vbap-posnr
                                                 kschl = 'ZPRC'.
      IF sy-subrc = 0.
        wa_result-prpcntry  = wa_konv-kbetr / 10.  " Proposed Contribution
        CLEAR wa_konv.
      ENDIF.


      READ TABLE it_konv  INTO wa_konv  WITH KEY knumv = wa_vbak-knumv
                                                 kposn = wa_vbap-posnr
                                                 kschl = 'ZACC'.
      IF sy-subrc = 0.
        wa_result-actcntry  = wa_konv-kbetr / 10.  " Actual Contribution
      ENDIF.

      APPEND wa_result TO it_result.
      CLEAR : wa_vbap, wa_konv.
    ENDLOOP.

    CLEAR : wa_vbak, wa_result.
  ENDLOOP.
ENDFORM.                    "determne_data_set

*&---------------------------------------------------------------------*
*&      Form  display_results
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM display_results.
  DATA : lv_i    TYPE i VALUE 1,
         lv_str  TYPE char100,
         lv_str1 TYPE char10,
         lv_str2 TYPE char10.

  CLEAR : lv_i, lv_str, lv_i, lv_str1, lv_str2.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = alv_obj
        CHANGING
          t_table      = it_result[].

    CATCH cx_salv_msg INTO lc_msg .
  ENDTRY.

  CREATE OBJECT wf_alv
    EXPORTING
      i_alv_obj       = alv_obj
      i_set_all       = c_x
      i_set_optimized = c_x.

  wf_alv->display_company_header( TEXT-020 ).
  reset_column_title :
    wf_alv 'BSTKD'      TEXT-021 TEXT-022 TEXT-023 TEXT-023,
    wf_alv 'NAME1'      TEXT-024 TEXT-025 TEXT-025 TEXT-025,
    wf_alv 'AUDAT'      TEXT-026 TEXT-027 TEXT-028 TEXT-028,
    wf_alv 'SO_RATE'    TEXT-029 TEXT-029 TEXT-029 TEXT-029,
    wf_alv 'SO_AMT'     TEXT-030 TEXT-030 TEXT-030 TEXT-030,
    wf_alv 'DSCNT'      TEXT-031 TEXT-031 TEXT-031 TEXT-031,
    wf_alv 'TOT_DSCNT'  TEXT-032 TEXT-033 TEXT-033 TEXT-033,
    wf_alv 'PRICE'      TEXT-034 TEXT-034 TEXT-034 TEXT-034,
    wf_alv 'TOT_PRICE'  TEXT-035 TEXT-036 TEXT-037 TEXT-037,
    wf_alv 'ESTCOST'    TEXT-038 TEXT-039 TEXT-039 TEXT-039,
    wf_alv 'TOTESTCOST' TEXT-040 TEXT-041 TEXT-042 TEXT-042,
    wf_alv 'INTPRICE'   TEXT-043 TEXT-044 TEXT-044 TEXT-044,
    wf_alv 'TOTINTPRC'  TEXT-045 TEXT-046 TEXT-047 TEXT-047,
    wf_alv 'PFCOST'     TEXT-048 TEXT-048 TEXT-048 TEXT-048,
    wf_alv 'TOTPFCOST'  TEXT-049 TEXT-050 TEXT-051 TEXT-051,
    wf_alv 'PRPCNTRY'   TEXT-052 TEXT-053 TEXT-054 TEXT-054,
    wf_alv 'ACTCNTRY'   TEXT-055 TEXT-056 TEXT-057 TEXT-057.

  " Set Totals
  wf_alv->set_total( 'SO_AMT' ).
  wf_alv->set_total( 'TOT_PRICE' ).
  wf_alv->set_total( 'TOTESTCOST' ).
  wf_alv->set_total( 'TOTINTPRC' ).
  wf_alv->set_total( 'TOTPFCOST' ).

  " Set Footer Text
  " Date of Order Creation
  set_footer_text wf_alv lv_i '1' 'L' TEXT-061 .
  lv_i = lv_i + 2.
  set_footer_text wf_alv lv_i '1' 'T' TEXT-062 .
  LOOP AT so_date.
    IF NOT so_date-low IS INITIAL.
      CONCATENATE so_date-low+4(2) so_date-low+6(2) so_date-low(4)
        INTO lv_str1 SEPARATED BY '/'.
    ENDIF.
    IF NOT so_date-high IS INITIAL.
      CONCATENATE so_date-high+4(2) so_date-high+6(2) so_date-high(4)
        INTO lv_str2 SEPARATED BY '/'.
    ENDIF.
    IF lv_str1 IS INITIAL OR lv_str2 IS INITIAL.
      CONCATENATE c_colon lv_str1 lv_str2
        INTO lv_str SEPARATED BY space.
    ELSE.
      CONCATENATE c_colon lv_str1 c_hypen lv_str2
        INTO lv_str SEPARATED BY space.
    ENDIF.
    set_footer_text wf_alv lv_i '2' 'T' lv_str.
    CLEAR : so_date, lv_str, lv_str1, lv_str2.
    lv_i = lv_i + 1.
  ENDLOOP.

  " Display ALV
  wf_alv->display( ).
*  lyot_func = alv_obj->get_functions( ).
*  lyot_func->set_all( abap_true ).
*
*  lyot_disp = alv_obj->get_display_settings( ).
*  lyot_disp->set_striped_pattern( cl_salv_display_settings=>true ).
*  lyot_disp->set_list_header( 'CONTRIBUTION MARGIN' ).
*
*  CREATE OBJECT lyot_txt.
*  WRITE so_date-low  TO v_datelow.
*  WRITE so_date-high  TO v_datehigh.
*  CONCATENATE 'DATE : '  v_datelow  ' TO'  v_datehigh  INTO txt SEPARATED BY '  '."RESPECTING BLANKS.
*  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
*  lyot_flow->create_text( text = 'CONTRIBUTION MARGIN' ).
*
*  var_i = var_i + 1.
*  lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).
*  alv_obj->set_top_of_list( lyot_txt ).
*
*  lyot_lout = alv_obj->get_layout( ).
*  lyot_key-report = sy-repid.
*  lyot_lout->set_key( lyot_key ).
*  lyot_lout->set_save_restriction( cl_salv_layout=>restrict_none ).
*
*  alv_obj->display( ).
ENDFORM.                    "display_results
