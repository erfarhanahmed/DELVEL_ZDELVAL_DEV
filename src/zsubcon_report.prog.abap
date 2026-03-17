*-----------------------------------------------------------------------
* (c)   P R I M U S  Techsystems Pvt. Ltd.
*-----------------------------------------------------------------------
* Version created and adopted for Hirschvogel Automotive Group
*-----------------------------------------------------------------------
* Descr.:   Report for Subcontracting Challan.
*-----------------------------------------------------------------------
* Author: PRIMUS - Deepak Taak (DT)
* Reffrence: PRIMUS- Pranav Khadatkar               Date: 11.09.17
*-----------------------------------------------------------------------
* Functional description
* Report for Subcontracting Challan.
*
*-----------------------------------------------------------------------
* Additional hints:
*
*-----------------------------------------------------------------------
* Change log
*
* Date     Shrt Vers  Change description                       Change-ID
* -------- ---- ----  ---------------------------------------  ---------
* 11.09.17 DT   V0.0  Created as Z_MM_SUBCONTRACT_CHALLAN       ID15564
*-----------------------------------------------------------------------
REPORT z_mm_subcontract_challan
NO STANDARD PAGE HEADING MESSAGE-ID z_mm_sub_challan.

TABLES : mseg.

*------------------------------------------------------------------------
*       CLASS lcl_prim_sub_challan DEFINITION
*------------------------------------------------------------------------
* Local class for Definition for Subcontracting Challan report
*------------------------------------------------------------------------
CLASS lcl_prim_sub_challan DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      "default Constructor
      constructor,

      "select data
      read_alv_data.

  PRIVATE SECTION.

    DATA :
      "Object Instance for displaying ALV
      go_display_alv         TYPE REF TO cl_salv_table,
      "Layout Key for Setting ALV Layout
      gs_layout_key          TYPE salv_s_layout_key,
      "Layout information for Setting ALV Layout
      gs_layout_info         TYPE salv_s_layout_info.

    TYPES :
      "Type for Billing header data
      BEGIN OF t_billing_header,
          vbeln       TYPE vbrk-vbeln,      "Challan Number
          xblnr       TYPE vbrk-xblnr,      "Official Doc number
      END OF t_billing_header,
        tt_billing_header TYPE STANDARD TABLE OF t_billing_header,

      "Type for Billing line item data
      BEGIN OF t_billing_item,
        vbeln       TYPE vbrp-vbeln,        "Challan Number
        posnr       TYPE vbrp-posnr,        "Challan line item
        matnr       TYPE vbrp-matnr,        "Material Number
        netwr       TYPE vbrp-netwr,        "Price or Challan Value
      END OF t_billing_item,
        tt_billing_item  TYPE STANDARD TABLE OF t_billing_item,

      "Type for Billing line item data
      BEGIN OF t_material_descr,
        matnr       TYPE makt-matnr,        "Material Number
        maktx       TYPE makt-maktx,        "Material Number Description
      END OF t_material_descr,
        tt_material_descr  TYPE STANDARD TABLE OF t_material_descr,

      "Type for subcon data
      BEGIN OF t_sub_doc_ref,
        issue_doc     TYPE j_1ig_subcon-mblnr,      "Issue document
        mjahr         TYPE j_1ig_subcon-mjahr,      "Doc year
        zeile         TYPE j_1ig_subcon-zeile,      "Material Document line item
        seq_no        TYPE j_1ig_subcon-seq_no,     "sequence no
        chln_inv      TYPE j_1ig_subcon-chln_inv,   "Subcon Challan No
        item          TYPE j_1ig_subcon-item,       "challan item
        erdat         TYPE j_1ig_subcon-erdat,      "Challan Date
        lifnr         TYPE j_1ig_subcon-lifnr,      "Vendor
        matnr         TYPE j_1ig_subcon-matnr,      "Material
        challn_qty    TYPE j_1ig_subcon-menge,      "Challan Qty
        budat         TYPE j_1ig_subcon-budat,      "Receipt Date
        mblnr         TYPE j_1ig_subcon-mblnr,      "Material Doc No
        bwart         TYPE j_1ig_subcon-bwart,      "Moment type
        recivd_qty    TYPE j_1ig_subcon-menge,      "Qty Received
        ch_oqty       TYPE j_1ig_subcon-ch_oqty,    "Balance Qty
        status        TYPE j_1ig_subcon-status,     "Challan Status
      END OF t_sub_doc_ref,
        tt_sub_doc_ref  TYPE STANDARD TABLE OF t_sub_doc_ref,

      "type for Display ALV
      BEGIN OF t_alv_output,
        issue_doc     TYPE j_1ig_subcon-mblnr,      "Issue document
        chln_inv      TYPE j_1ig_subcon-chln_inv,   "Subcon Challan No
        erdat         TYPE j_1ig_subcon-erdat,      "Challan Date
        xblnr         TYPE vbrk-xblnr,              "Official document No
        lifnr         TYPE j_1ig_subcon-lifnr,      "Vendor
        matnr         TYPE j_1ig_subcon-matnr,      "Material
        maktx         TYPE makt-maktx,              "Material Description
        challn_qty    TYPE j_1ig_subcon-menge,      "Challan Qty
        netwr         TYPE vbrp-netwr,              "Challan Value
        budat         TYPE j_1ig_subcon-budat,      "Receipt Date
        mblnr         TYPE j_1ig_subcon-mblnr,      "Material Doc No
        bwart         TYPE j_1ig_subcon-bwart,      "Moment type
        recivd_qty    TYPE j_1ig_subcon-menge,      "Qty Received
        ch_oqty       TYPE j_1ig_subcon-ch_oqty,    "Balance Qty
        status        TYPE j_1ig_subcon-status,     "Challan Status
*        mblnr         TYPE mseg-mblnr,
        mjahr         TYPE mseg-mjahr,
        zeile         TYPE mseg-zeile,
        ebeln         TYPE mseg-ebeln,
        ebelp         TYPE mseg-ebelp,
*        ebeln         TYPE ekpo-ebeln,
*        ebelp         TYPE ekpo-ebelp,
        menge         TYPE ekpo-menge,

      END OF t_alv_output,
      tt_alv_output TYPE STANDARD TABLE OF t_alv_output.
    DATA :
      gt_alv_output TYPE tt_alv_output.

    TYPES : BEGIN OF ty_mseg,
            mblnr TYPE mseg-mblnr,
            mjahr TYPE mseg-mjahr,
            zeile TYPE mseg-zeile,
            ebeln TYPE mseg-ebeln,
            ebelp TYPE mseg-ebelp,
          END OF ty_mseg.

    TYPES : BEGIN OF ty_ekpo,
            ebeln TYPE ekpo-ebeln,
            ebelp TYPE ekpo-ebelp,
            menge TYPE ekpo-menge,
          END OF ty_ekpo.

    DATA : lt_mseg TYPE TABLE OF ty_mseg,
          ls_mseg TYPE           ty_mseg.

    DATA : lt_ekpo TYPE TABLE OF ty_ekpo,
          ls_ekpo TYPE           ty_ekpo.





    METHODS :
      "display ALV output
      display_alv_result.
ENDCLASS.             "lcl_prim_sub_challan

DATA:
  "Reference Object of Local Class
  go_prim_sub_challan TYPE REF TO lcl_prim_sub_challan .

DATA:
  "Temporary variable for Challan Numnber
  tmp_chl     TYPE j_1ig_subcon-chln_inv,
  "Temporary variable for date
  tmp_date    TYPE j_1ig_subcon-budat,
  "Temporary variable for challan status
  tmp_status  TYPE j_1ig_subcon-status,
  "Temporary variable for Plant
  tmp_werks  TYPE j_1ig_subcon-werks,
  "Temporary variable for venedor
  tmp_vendor TYPE j_1ig_subcon-lifnr,
  "Temporary variable for  Material
  tmp_material TYPE j_1ig_subcon-matnr,
  "Temporary variable for Official Document number
  tmp_off_doc TYPE vbrk-xblnr
.
************************************************************************
*     S E L E C T I O N - S C R E E N                                  *
************************************************************************
"selection-screen for report output
SELECTION-SCREEN: BEGIN OF BLOCK selection WITH FRAME TITLE title000.
* Mutiple Values Range for Challan Numnber
SELECT-OPTIONS: so_chln   FOR tmp_chl,
* Mutiple Values Range for Posting Date in the Document
                so_date   FOR tmp_date,
                          "OBLIGATORY,
* Mutiple Values Range for Subcontracting Status
                so_stat   FOR tmp_status,
* Mutiple Values Range for Vebdor
                so_vend   FOR tmp_vendor,
* Mutiple Values Range Material Number
                so_mat    FOR tmp_material,

*                s_ebeln   FOR mseg-ebeln,
* Mutiple Values Range Official Doc number
                so_offd   FOR tmp_off_doc,
* Mutiple Values Range for Plant
                so_werks  FOR tmp_werks
                        OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK selection.


************************************************************************
*   I N I T I A L I Z A T I O N
************************************************************************
INITIALIZATION.
  "Assign Texts to titles
  title000 = 'Selections'(011).

AT SELECTION-SCREEN.
* Validate Plant
  IF NOT ( so_werks[] IS INITIAL OR
           so_werks-low IS INITIAL ).
    SELECT werks
      FROM t001w
      UP TO 1 ROWS
      INTO tmp_werks
     WHERE werks IN so_werks.
      EXIT.
    ENDSELECT.
    IF NOT sy-subrc IS INITIAL.
*     Message: None of the selected Plants exists
      MESSAGE e008.
    ENDIF.

  ENDIF.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_prim_sub_challan
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_prim_sub_challan IMPLEMENTATION.
*----------------------------------------------------------------------*
* Method : constructor
*----------------------------------------------------------------------*
* Set Layout Key in Constructor
*----------------------------------------------------------------------*
  METHOD constructor.

    DATA:
*     Internal Table and Structure Variable for Plants
      lt_plants              TYPE t_bwkey,
*     Variable to Check Plants Authorization
      l_plant                    TYPE werks_d,
*     Flag to Check Plant Authrization failed
      l_check_plant_auth_failed  TYPE flag.

*   Get Plants as per Selection Criteria
    SELECT bwkey
      FROM t001k
      INTO TABLE lt_plants
      WHERE bwkey IN so_werks.

    CLEAR
     gs_layout_key.

    LOOP AT lt_plants INTO l_plant.
      AUTHORITY-CHECK OBJECT 'M_MATE_WRK'
                 ID 'ACTVT' FIELD '03'
                 ID 'WERKS' FIELD l_plant.
        IF NOT sy-subrc IS INITIAL.
           DELETE lt_plants WHERE table_line = l_plant.
           MOVE abap_true TO l_check_plant_auth_failed.
        ENDIF.
       IF l_check_plant_auth_failed EQ abap_true.
         "You do not have Authorization of plant
         MESSAGE S009 DISPLAY LIKE 'W'.
       ENDIF.
    ENDLOOP.
ENDMETHOD.                    "constructor

*----------------------------------------------------------------------*
* Method : read_alv_data
*----------------------------------------------------------------------*
* Read ALV data of Purchase Register
*----------------------------------------------------------------------*
METHOD read_alv_data.
    CONSTANTS :
      "Constant for language
      lc_541_movement         TYPE j_1ig_subcon-bwart  VALUE '541',
      lc_542_movement         TYPE j_1ig_subcon-bwart  VALUE '542',
      lc_543_movement         TYPE j_1ig_subcon-bwart  VALUE '543'.
    DATA :
      "Internal table for Subcontracting Document Reference
      lt_sub_doc_ref      TYPE   tt_sub_doc_ref,
      "Work Area for Subcontracting Document Reference
      ls_sub_doc_ref      TYPE   t_sub_doc_ref ##NEEDED ,
      "Internal table for Billing documnet item
      lt_billing_item     TYPE   tt_billing_item,
      "Work Area for Billing documnet item
      ls_billing_item     TYPE   t_billing_item,
      "Internal table for Billing documnet Header
      lt_billing_Header   TYPE   tt_billing_Header,
      "Internal table for Material Description table
      lt_material_descr   TYPE   tt_material_descr,
      "Work Area for Material Description table
      ls_material_descr   TYPE   t_material_descr,

      "Work Area for Billing documnet Header
      ls_billing_Header   TYPE   t_billing_Header,
      "Work Area for Subcontracting Document Reference mvt 541
      ls_sub_doc_ref_541  TYPE   t_sub_doc_ref,
      "Work Area for Subcontracting Document Reference mvt 542
      ls_sub_doc_ref_542  TYPE   t_sub_doc_ref,
      "Work Area for Subcontracting Document Reference mvt 543
      ls_sub_doc_ref_543  TYPE   t_sub_doc_ref,
      "Work Area for final alv table
      ls_alv_output       TYPE   t_alv_output,
      "variable to check movement 542
      lv_no_mvt_542       TYPE   c,
      "variable to check movement 543
      lv_no_mvt_543       TYPE   c.

*BREAK-POINT.
    SELECT mblnr
           mjahr
           zeile
           seq_no
           chln_inv
           item
           erdat
           lifnr
           matnr
           menge
           budat
           mblnr
           bwart
           menge
           ch_oqty
           status
      FROM j_1ig_subcon
      INTO TABLE lt_sub_doc_ref
      WHERE chln_inv  IN so_chln
      AND   budat     IN so_date
      AND   werks     IN so_werks
      AND   lifnr     IN so_vend
      AND   matnr     IN so_mat
      AND   status    IN so_stat.

      CLEAR
        ls_sub_doc_ref.
      READ TABLE lt_sub_doc_ref INTO ls_sub_doc_ref WITH KEY bwart = lc_541_movement.
      IF NOT sy-subrc IS INITIAL AND NOT so_stat[] IS INITIAL.
       SELECT mblnr
            mjahr
            zeile
            seq_no
            chln_inv
            item
            erdat
            lifnr
            matnr
            menge
            budat
            mblnr
            bwart
            menge
            ch_oqty
            status
       FROM j_1ig_subcon
       APPENDING TABLE lt_sub_doc_ref
       FOR ALL ENTRIES IN lt_sub_doc_ref
       WHERE chln_inv  = lt_sub_doc_ref-chln_inv
       AND   budat     = lt_sub_doc_ref-budat
       AND   bwart     = lc_541_movement .
      ENDIF.
    IF NOT lt_sub_doc_ref IS INITIAL.

      SELECT  vbeln
              xblnr
        FROM  vbrk
        INTO  TABLE lt_billing_Header
        FOR ALL ENTRIES IN lt_sub_doc_ref
        WHERE vbeln = lt_sub_doc_ref-chln_inv.
        IF sy-subrc = 0.
           SELECT vbeln
                  posnr
                  matnr
                  netwr
             FROM vbrp
             INTO TABLE lt_billing_item
             FOR ALL ENTRIES IN lt_billing_Header
             WHERE vbeln = lt_billing_Header-vbeln.
        ENDIF.
        SELECT matnr
               maktx
          FROM makt
          INTO TABLE lt_material_descr
          FOR ALL ENTRIES IN lt_sub_doc_ref
          WHERE matnr = lt_sub_doc_ref-matnr
          AND   spras = sy-langu.

    ENDIF.
*BREAK-POINT.
    IF lt_sub_doc_ref IS NOT INITIAL.
      SELECT mblnr
             mjahr
             zeile
             ebeln
             ebelp
             FROM mseg
             INTO TABLE lt_mseg
             FOR ALL ENTRIES IN lt_sub_doc_ref
             WHERE " ebeln IN s_ebeln ."AND
                    mblnr = lt_sub_doc_ref-mblnr AND
                   zeile = lt_sub_doc_ref-zeile.
    ENDIF.

    IF lt_mseg IS NOT INITIAL.
      SELECT ebeln
             ebelp
             menge
             FROM ekpo
             INTO TABLE lt_ekpo
             FOR ALL ENTRIES IN lt_mseg
             WHERE "ebeln IN s_ebeln AND
                   ebeln = lt_mseg-ebeln AND
                   ebelp = lt_mseg-ebelp.
    ENDIF.

*    sort lt_sub_doc_ref BY chln_inv matnr bwart.
    LOOP AT lt_sub_doc_ref INTO ls_sub_doc_ref_541 WHERE bwart = lc_541_movement.
*      MOVE-CORRESPONDING ls_sub_doc_ref_541 to ls_alv_output.
      ls_alv_output-issue_doc   = ls_sub_doc_ref_541-issue_doc.
      ls_alv_output-chln_inv    = ls_sub_doc_ref_541-chln_inv.
      ls_alv_output-erdat       = ls_sub_doc_ref_541-erdat.
      ls_alv_output-lifnr       = ls_sub_doc_ref_541-lifnr.
      ls_alv_output-matnr       = ls_sub_doc_ref_541-matnr.
      ls_alv_output-challn_qty  = ls_sub_doc_ref_541-challn_qty.
      ls_alv_output-status      = ls_sub_doc_ref_541-status.

*BREAK-POINT.
************************************************************************************************************************************************

       CLEAR : LS_MSEG.
       READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_sub_doc_ref_541-mblnr zeile = ls_sub_doc_ref_541-zeile.
       if sy-subrc = 0.
       ls_alv_output-ebeln = ls_mseg-ebeln.
       ls_alv_output-ebelp = ls_mseg-ebelp.
       ENDIF.

       CLEAR : LS_EKPO.

       READ TABLE lt_ekpo INTO ls_ekpo WITH KEY ebeln = ls_mseg-ebeln ebelp = ls_mseg-ebelp.
       if sy-subrc = 0.
       ls_alv_output-menge = ls_ekpo-menge.
       ENDIF .

    CLEAR:
      ls_material_descr.
      READ TABLE lt_material_descr INTO ls_material_descr
          WITH KEY matnr = ls_sub_doc_ref_541-matnr.
       IF sy-subrc = 0.
         ls_alv_output-maktx  = ls_material_descr-maktx.
       ENDIF.


    CLEAR
      ls_billing_Header.
    READ TABLE lt_billing_Header INTO ls_billing_Header
      WITH KEY vbeln = ls_sub_doc_ref_541-chln_inv.
      IF sy-subrc = 0.
        ls_alv_output-xblnr =    ls_billing_Header-xblnr.
      ENDIF.

    CLEAR
      ls_billing_item.
    READ TABLE lt_billing_item INTO ls_billing_item
      WITH KEY vbeln = ls_sub_doc_ref_541-chln_inv
               matnr = ls_sub_doc_ref_541-matnr
               posnr = ls_sub_doc_ref_541-item.
      IF sy-subrc = 0.
        ls_alv_output-netwr =    ls_billing_item-netwr.
      ENDIF.

    CLEAR
        ls_sub_doc_ref_542.
*    READ TABLE lt_sub_doc_ref INTO ls_sub_doc_ref_542
    LOOP AT lt_sub_doc_ref INTO ls_sub_doc_ref_542
       WHERE     chln_inv = ls_sub_doc_ref_541-chln_inv
       AND       item     = ls_sub_doc_ref_541-item
       AND       matnr    = ls_sub_doc_ref_541-matnr
       AND       bwart    = lc_542_movement.
      ls_alv_output-budat         = ls_sub_doc_ref_542-budat.
      ls_alv_output-mblnr         = ls_sub_doc_ref_542-mblnr.
      ls_alv_output-bwart         = ls_sub_doc_ref_542-bwart.
      ls_alv_output-recivd_qty    = ls_sub_doc_ref_542-recivd_qty.
      ls_alv_output-ch_oqty       = ls_sub_doc_ref_542-ch_oqty.
      ls_alv_output-status        = ls_sub_doc_ref_542-status.
      lv_no_mvt_542               = abap_true.
      APPEND ls_alv_output TO gt_alv_output.
      CLEAR:
        ls_alv_output-challn_qty,
        ls_alv_output-netwr.
    ENDLOOP.
    IF NOT sy-subrc IS  INITIAL.
      lv_no_mvt_542 = abap_false.
    ENDIF.

    CLEAR
      ls_sub_doc_ref_543.
*    READ TABLE lt_sub_doc_ref INTO ls_sub_doc_ref_543
    LOOP AT lt_sub_doc_ref INTO ls_sub_doc_ref_543
        WHERE    chln_inv = ls_sub_doc_ref_541-chln_inv
        AND      item     = ls_sub_doc_ref_541-item
        AND      matnr    = ls_sub_doc_ref_541-matnr
        AND      bwart    = lc_543_movement.

      ls_alv_output-budat         = ls_sub_doc_ref_543-budat.
      ls_alv_output-mblnr         = ls_sub_doc_ref_543-mblnr.
      ls_alv_output-bwart         = ls_sub_doc_ref_543-bwart.
      ls_alv_output-recivd_qty    = ls_sub_doc_ref_543-recivd_qty.
      ls_alv_output-ch_oqty       = ls_sub_doc_ref_543-ch_oqty.
      ls_alv_output-status        = ls_sub_doc_ref_543-status.
      lv_no_mvt_543               = abap_true.

      APPEND ls_alv_output TO gt_alv_output.
      CLEAR:
        ls_alv_output-challn_qty,
        ls_alv_output-netwr.
    ENDLOOP.
    IF NOT sy-subrc IS INITIAL.
      lv_no_mvt_543 = abap_false .
    ENDIF.
    "append if no mvt found
    IF lv_no_mvt_542 = abap_false and lv_no_mvt_543 = abap_false.
      APPEND ls_alv_output TO gt_alv_output.
    ENDIF.
    CLEAR:
      lv_no_mvt_542,
      lv_no_mvt_543,
      ls_alv_output.
   ENDLOOP.
   "Delete challan where status is different
   IF NOT so_stat[] IS INITIAL.
     DELETE gt_alv_output WHERE status NOT IN so_stat[].
   ENDIF.
   "Delete where official document no. is not in range
   IF NOT so_offd[] IS INITIAL.
     DELETE gt_alv_output WHERE xblnr NOT IN so_offd[].
   ENDIF.
  "Display ALV result
    CALL METHOD me->display_alv_result( ).
  ENDMETHOD.                      "read_alv_data

*----------------------------------------------------------------------*
* Method : display_alv_result
*----------------------------------------------------------------------*
* Display ALV output with required data
*----------------------------------------------------------------------*
  METHOD display_alv_result.

    DATA:
      "Sort data
      lo_oref_sorts TYPE REF TO cl_salv_sorts,
      "Set Layout from selection screen
      ls_layout     TYPE        slis_vari,
      "Sort Data Reference
      lo_sort       TYPE REF TO cl_salv_sorts                  ##needed,
      lr_column     TYPE REF TO cl_salv_column_table,
      "Global Column class for Column Description of Table
      lr_columns    TYPE REF TO cl_salv_columns_table,
      "Grid Element in Design Object
      lo_grid            TYPE REF TO cl_salv_form_layout_grid,
      "Element of Type Label
      lo_label           TYPE REF TO cl_salv_form_label        ##needed,
      "Variable for low run date
      l_date_low         TYPE char10,
      "Variable for high run date
      l_date_high        TYPE char10,
      "variable for selected records
      l_selected_records TYPE string,
      "variable for selected period
      l_selected_period  TYPE string,
      "variable for local date
      l_local_date       TYPE d,
      "variable for local time
      l_local_time       TYPE t,
      "variable for date display
      l_date_display     TYPE char10,
      ""variable for time display
      l_time_display     TYPE char10,
      "string for date
      l_date_string      TYPE string,
      "string for time
      l_time_string      TYPE string,
      "Variable for time stamp
      l_time_stamp       TYPE timestamp,
      "varibale to describe total records.
      l_lines(5)         TYPE c.

    CONSTANTS:
    " Constant fo0r India timeZone
      lc_timezone_india  TYPE ttzz-tzone VALUE 'INDIA'.

    IF gt_alv_output IS INITIAL.
      "No records Found
      MESSAGE s003 DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ELSE.
      TRY.
          "Get ALV instance for output results
          CALL METHOD cl_salv_table=>factory
            IMPORTING
              r_salv_table = go_display_alv
            CHANGING
              t_table      = gt_alv_output.

          go_display_alv->get_display_settings( )->set_list_header('Subcontracting Challan Report'(002) ).
          "Optimize ALV columns
          go_display_alv->get_columns( )->set_optimize( abap_true ).

          "get Sort object
          lo_sort = go_display_alv->get_sorts( ).

          "Column Description of Table
          lr_columns = go_display_alv->get_columns( ).

        CATCH cx_salv_msg .
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.
        CATCH cx_salv_not_found.
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.
        CATCH cx_salv_data_error.
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.
        CATCH cx_salv_existing.
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.

      ENDTRY.

      "Number of Lines Selected for report display
      DESCRIBE TABLE gt_alv_output LINES l_lines.

      TRY.
          "Sort Column Issue Documnet number
          lo_oref_sorts = go_display_alv->get_sorts( ).
          CALL METHOD lo_oref_sorts->add_sort
            EXPORTING
              columnname = 'ISSUE_DOC'
              position   = 1
              .
          "Sort Column Challan Invoice
          lo_oref_sorts = go_display_alv->get_sorts( ).
          CALL METHOD lo_oref_sorts->add_sort
            EXPORTING
              columnname = 'CHLN_INV'
              position   = 2.

          "Change Column Headings
          lr_column ?= lr_columns->get_column( 'ISSUE_DOC' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Issue document'(012) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'CHLN_INV' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Subcon Challan No'(010) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'ERDAT' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Challan Date'(013) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'XBLNR' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Official document No'(014) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'CHALLN_QTY' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Challan Qty'(015) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'NETWR' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Challan Value'(016) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'BUDAT' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Receipt Date'(017) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'RECIVD_QTY' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Qty Received'(018) ).
          lr_column->set_f1_rollname( space ).

          lr_column ?= lr_columns->get_column( 'CH_OQTY' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Balance Qty'(019) ).
          lr_column->set_f1_rollname( space ).
*******************************************************************************************************************************************************
           lr_column ?= lr_columns->get_column( 'EBELN' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'PO. No.'(020) ).
          lr_column->set_f1_rollname( space ).

           lr_column ?= lr_columns->get_column( 'EBELP' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'PO Line Item'(021) ).
          lr_column->set_f1_rollname( space ).

           lr_column ?= lr_columns->get_column( 'MENGE' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'PO Quantity'(022) ).
          lr_column->set_f1_rollname( space ).

          DATA ls_ddic_ref TYPE salv_s_ddic_reference.

          ls_ddic_ref-table = 'J_1IG_SUBCON'.
          ls_ddic_ref-field = 'STATUS'.


          lr_column ?= lr_columns->get_column( 'STATUS' ).
          lr_column->set_medium_text( space ).
          lr_column->set_short_text( space ).
          lr_column->set_long_text( 'Challan Status'(023) ).
          lr_column->set_f1_rollname( space ).
          lr_column->SET_F4( 'X' ).
          lr_column->SET_DDIC_REFERENCE( ls_ddic_ref ).


          "create object for grid
          CREATE OBJECT lo_grid.

          "Assign Number of records selected to header
          CONCATENATE 'Number of Records Selected :'(h01)
                      l_lines
             INTO     l_selected_records.
          lo_label = lo_grid->create_label( row    = 1
                                            column = 1
                                            text   = l_selected_records ).

          "Check created date for low value
          IF so_date-low IS NOT INITIAL.
            WRITE so_date-low TO l_date_low.
          ENDIF.
          "Check created date for high value
          IF so_date-high IS NOT INITIAL.
            WRITE so_date-high TO l_date_high.
          ENDIF.
          CLEAR l_selected_period.
          "write period from - to
          CONCATENATE 'Period :'(h02)
                    l_date_low
              INTO l_selected_period SEPARATED BY space.

          "assign high date value for executed period
          IF l_date_high IS NOT INITIAL.
            CONCATENATE l_selected_period
                    'To'(h03)
                    l_date_high
               INTO l_selected_period SEPARATED BY space.
          ENDIF.
          lo_label = lo_grid->create_label( row    = 2
                                            column = 1
                                            text   = l_selected_period ).

          "Assign Run Date to header
          GET TIME STAMP FIELD l_time_stamp.
          CONVERT TIME STAMP l_time_stamp TIME ZONE lc_timezone_india
                          INTO DATE l_local_date TIME l_local_time.
          WRITE l_local_date TO l_date_display.
          CONCATENATE 'Run Date :'(h04)
                      l_date_display
                    INTO l_date_string SEPARATED BY space.
          lo_label = lo_grid->create_label( row    = 3
                                            column = 1
                                            text   = l_date_string ).

          "Assign Run Time to header
          WRITE l_local_time TO l_time_display.
          CLEAR l_time_string.
          CONCATENATE 'Run Time :'(h05)
                      l_time_display
                      '(local time India)'(h06)
                      INTO l_time_string SEPARATED BY space.
          lo_label = lo_grid->create_label( row    = 4
                                            column = 1
                                            text   = l_time_string ).

          "Set the top of list using the header for Online
          go_display_alv->set_top_of_list( lo_grid ).
*  --------------------------End of ID14169-1------------------

        CATCH cx_salv_not_found.
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.
        CATCH cx_salv_existing.
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.
        CATCH cx_salv_data_error.
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.

        CATCH cx_sy_ref_is_initial.
          "Message: ALV can't be displayed due to internal errors
          MESSAGE e001.
          RETURN.
      ENDTRY.
      "optimize alv columns
      go_display_alv->get_columns( )->set_optimize( abap_true ).

      "Set All function enabled e.g. Sort function
      go_display_alv->get_functions( )->set_all( abap_true ).

      "Set Default Layout settings for ALV
      go_display_alv->get_layout( )->set_default( value = abap_true ).

      "Authority Check for saving alv layout
      AUTHORITY-CHECK OBJECT 'S_ALV_LAYO'
      ID 'ACTVT' FIELD '23'.
      IF sy-subrc IS INITIAL.
        "Set Layout Save restriction at globla level settings for ALV
        go_display_alv->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
      ELSE.
        "Set Layout Save restriction at user level settings for ALV
        go_display_alv->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_user_dependant ).
      ENDIF.

      "Set Initial Layout for ALV
      MOVE gs_layout_info-layout TO ls_layout.
      gs_layout_key-handle = 0001.
      go_display_alv->get_layout( )->set_initial_layout( value = ls_layout ).
      "Set Layout specification
      go_display_alv->get_layout( )->set_key( value = gs_layout_key ).
      go_display_alv->get_layout( )->set_default( value = abap_true ).

      "Display ALV Report
      go_display_alv->display( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.               "lcl_prim_sub_challan

START-OF-SELECTION.
 "Create object for class
  CREATE OBJECT go_prim_sub_challan.
  IF go_prim_sub_challan IS BOUND.
    "Read ALV data
    CALL METHOD go_prim_sub_challan->read_alv_data( ).
  ENDIF.
