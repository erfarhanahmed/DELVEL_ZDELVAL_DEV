*&---------------------------------------------------------------------*
*& Report ZEINV_CUSTOMER_INV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT zeinv_customer_inv_prim MESSAGE-ID zinv_message.


"===============================================================================================
" Golbal Data Delacrations
"===============================================================================================

TABLES : vbrk,vbrp,zeway_bill.


DATA : t_fieldcat  TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       wa_fieldcat TYPE slis_t_fieldcat_alv.

CLASS lcl_events DEFINITION DEFERRED.

DATA: row TYPE lvc_s_row,
      col TYPE lvc_s_col.

DATA: con TYPE i.

DATA : lv_status TYPE string,
       lt_retmsg TYPE STANDARD TABLE OF bapiret2.


DATA : file_name TYPE string.
*Internal Table for sorting
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

DATA : w_tabname TYPE slis_tabname,
       idx       TYPE sytabix.

DATA : fs_layout TYPE slis_layout_alv.

DATA: c_ccont     TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_ccont_del TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd     TYPE REF TO cl_gui_alv_grid,                 "ALV grid object
      it_fcat     TYPE lvc_t_fcat,                             "Field catalogue
      it_layout   TYPE lvc_s_layo,
      lin         TYPE i,
      g_cc        TYPE REF TO cl_gui_custom_container,
      g_rep       TYPE REF TO cl_gui_alv_grid,
      g_app       TYPE REF TO lcl_events.

DATA: ok_code    TYPE ui_func.
DATA: gstring    TYPE c.
DATA: vtest(100) TYPE c.



TYPES: BEGIN OF lty_zeinv_link,
         bukrs       TYPE zeinv_link-bukrs,
         vkorg       TYPE zeinv_link-vkorg,
         fkart       TYPE zeinv_link-fkart,
         base_kschl  TYPE zeinv_link-base_kschl,
         disc_kschl  TYPE zeinv_link-disc_kschl,
         other_kschl TYPE zeinv_link-other_kschl,
         type        TYPE zeinv_link-type,
         category    TYPE zeinv_link-category,
         expcat      TYPE zeinv_link-expcat,
         flag        TYPE zeinv_link-flag,
         foc_flag    TYPE zeinv_link-foc_flag,
       END OF lty_zeinv_link.


DATA : lt_zeinv_link TYPE STANDARD TABLE OF lty_zeinv_link,
       ls_zeinv_link TYPE lty_zeinv_link.

DATA : lt_jsonfile TYPE STANDARD TABLE OF zstr_jsonfile,
       ls_jsonfile TYPE  zstr_jsonfile.

DATA : lt_jsonfile_multiple TYPE STANDARD TABLE OF zstr_jsonfile,
       ls_jsonfile_multiple TYPE  zstr_jsonfile.


*DATA : lt_docs       TYPE STANDARD TABLE OF zstr_vbeln,  "Optional
*       ls_docs       TYPE  zstr_vbeln.



TYPES: BEGIN OF lty_s_vbrk,
         vbeln TYPE vbrk-vbeln,
         fkart TYPE vbrk-fkart,
         vkorg TYPE vbrk-vkorg,
         fkdat TYPE vbrk-fkdat,
         gjahr TYPE vbrk-gjahr,
         rfbsk TYPE vbrk-rfbsk,
         bukrs TYPE vbrk-bukrs,
         ernam TYPE vbrk-ernam,
         erzet TYPE vbrk-erzet,
         erdat TYPE vbrk-erdat,
         kunag TYPE vbrk-kunag,
         sfakn TYPE vbrk-sfakn,
         xblnr TYPE vbrk-xblnr,
         bupla TYPE vbrk-bupla,
       END OF lty_s_vbrk.


TYPES  : BEGIN OF lty_j_1bbranch,
           bukrs  TYPE j_1bbranch-bukrs,
           branch TYPE j_1bbranch-branch,
           gstin  TYPE j_1bbranch-gstin,
         END OF lty_j_1bbranch.


DATA : lt_j_1bbranch TYPE TABLE OF lty_j_1bbranch,
       ls_j_1bbranch TYPE lty_j_1bbranch.


DATA : lt_vbrk TYPE STANDARD TABLE OF lty_s_vbrk,
       ls_vbrk TYPE lty_s_vbrk.


TYPES : BEGIN OF lty_vbrk_cancel,
          vbeln TYPE vbrk-vbeln,
          sfakn TYPE vbrk-sfakn,
        END OF lty_vbrk_cancel.

DATA : lt_vbrk_can TYPE TABLE OF lty_vbrk_cancel,
       ls_vbrk_can TYPE lty_vbrk_cancel.


TYPES: BEGIN OF lty_s_vbrp,
         vbeln TYPE vbrp-vbeln,
         posnr TYPE vbrp-posnr,
         werks TYPE vbrp-werks,
         vgbel TYPE vbrp-vgbel,
       END OF lty_s_vbrp.

DATA : lt_vbrp TYPE STANDARD TABLE OF lty_s_vbrp,
       ls_vbrp TYPE lty_s_vbrp.

TYPES: BEGIN OF lty_likp,
         vbeln TYPE likp-vbeln,
         vkorg TYPE likp-vkorg,
         vstel TYPE likp-vstel,
         kunnr TYPE likp-kunnr,
         kunag TYPE likp-kunag,
       END OF lty_likp.

DATA: lt_likp      TYPE STANDARD TABLE OF lty_likp,
      ls_likp_cust TYPE lty_likp.


TYPES : BEGIN OF lty_kna1 ,
          kunnr TYPE kna1-kunnr,
          land1 TYPE kna1-land1,
          name1 TYPE kna1-name1,
          pstlz TYPE kna1-pstlz,
          regio TYPE kna1-regio,
          adrnr TYPE kna1-adrnr,
          stcd3 TYPE kna1-stcd3,
        END OF lty_kna1.

DATA : lt_kna1 TYPE TABLE OF lty_kna1,
       ls_kna1 TYPE lty_kna1.



DATA : lt_zeinv_response TYPE STANDARD TABLE OF zeinv_res,
       ls_zeinv_response TYPE zeinv_res.


DATA : lt_tvfkt TYPE STANDARD TABLE OF tvfkt,
       ls_tvfkt TYPE tvfkt.


TYPES : BEGIN OF lty_final,
          selection              TYPE char1,
          process_status(70)     TYPE c,
          eway_status(70)        TYPE c,
          status_description(20) TYPE c,
          eway_description(20)   TYPE c,
          reason(50)             TYPE c,
          kunnr                  TYPE kna1-kunnr,
          name1                  TYPE kna1-name1,
          stcd3_cust             TYPE kna1-stcd3,
          bukrs                  TYPE vbrk-bukrs,
          werks                  TYPE vbrp-werks,
          vkorg                  TYPE vbrk-vkorg,
          vbeln                  TYPE zeinv_res-vbeln,
          fkart                  TYPE vbrk-fkart,
          gstin                  TYPE stcd3,
          vtext                  TYPE tvfkt-vtext,
          xblnr                  TYPE zeinv_res-xblnr,
          erdat                  TYPE vbrk-erdat,
          erzet                  TYPE vbrk-erzet,
          ernam                  TYPE vbrk-ernam,
          fkdat                  TYPE zeinv_res-fkdat,
          zzerror_disc           TYPE zeinv_res-zzerror_disc,
          zzirn_no               TYPE zzirn_no,
          zzack_no               TYPE zeinv_res-zzack_no,
          zzqr_code              TYPE zeinv_res-zzqr_code,
          zzstatus               TYPE zeinv_res-zzstatus,
          zzuser                 TYPE zeinv_res-zzqr_code,
          zzcdate                TYPE zeinv_res-zzcdate,
          zztime                 TYPE zeinv_res-zztime,
          can_doc                TYPE vbrk-vbeln,
          can_reason(100)        TYPE c,
          zzewaybill_no          TYPE zeinv_res-zzewaybill_no,
          zzewaybill_date        TYPE zeinv_res-zzewaybill_date,
          zzvalid_upto           TYPE zeinv_res-zzvalid_upto,
          zzewaycan_date         TYPE zeinv_res-zzewaycan_date,
          can_rsn                TYPE zeinv_res-zzcan_rsn,
          gstin_flag(1)          TYPE c,
          gstin_dtls(70)         TYPE c,
          eway_dtls(70)          TYPE c,
        END OF lty_final.


DATA : lt_final TYPE STANDARD TABLE OF lty_final,
       ls_final TYPE lty_final.

DATA : lt_zeinv_response_save TYPE STANDARD TABLE OF zeinv_res,
       ls_zeinv_res           TYPE zeinv_res.


TYPES : BEGIN OF lty_j_1ig_invrefnum,
          bukrs         TYPE j_1ig_invrefnum-bukrs,
          docno         TYPE j_1ig_invrefnum-docno,
          odn           TYPE j_1ig_invrefnum-odn,
          irn           TYPE j_1ig_invrefnum-irn,
          version       TYPE j_1ig_invrefnum-version,
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

CONSTANTS : lc_rfbsk TYPE rfbsk VALUE 'C'.

TYPES  :BEGIN OF lty_range,
          sign TYPE tvarvc-sign,
          opti TYPE tvarvc-opti,
          low  TYPE tvarvc-low,
          high TYPE tvarvc-high,
        END OF lty_range.

DATA : lt_range TYPE TABLE OF lty_range,
       ls_range TYPE lty_range.



DATA :gt_ewaybill_details TYPE TABLE OF zeway_bill,
      gs_ewaybill_details TYPE zeway_bill,
      gs_ewaybill_screen  TYPE zeway_bill,
      lv_ucomm_sub        TYPE sy-ucomm,
      lv_eway             TYPE string.



"------Declarations for Drop Down list-----------------------------
DATA: it_list     TYPE vrm_values.
DATA: wa_list     TYPE vrm_value.
DATA: it_values TYPE TABLE OF dynpread,
      wa_values TYPE dynpread.

DATA: lv_selected_value(20) TYPE c.
"--------------------------------------------------------------------

"===============================================================================================
"  End of Golbal Data Declarations
"===============================================================================================






"===============================================================================================
"Selection Screen
"===============================================================================================


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : s_bukrs FOR vbrk-bukrs OBLIGATORY,
                   s_vkorg FOR vbrk-vkorg  OBLIGATORY,
                   s_fkdat FOR vbrk-fkdat OBLIGATORY,
                   s_vbeln FOR vbrk-vbeln .

  PARAMETERS: status TYPE c AS LISTBOX VISIBLE LENGTH 20. "Parameter

SELECTION-SCREEN : END OF BLOCK b1.


SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: a1 RADIOBUTTON GROUP r,
              a2 NO-DISPLAY , "RADIOBUTTON GROUP r ,
              a3 RADIOBUTTON GROUP r,
              a4 NO-DISPLAY. "RADIOBUTTON GROUP r .
SELECTION-SCREEN : END OF BLOCK b2.


*SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
*PARAMETERS: a1  AS CHECKBOX DEFAULT 'X',"RADIOBUTTON GROUP r,
*            a2 NO-DISPLAY ,"RADIOBUTTON GROUP r ,
*            a3 NO-DISPLAY,"RADIOBUTTON GROUP r,
*            a4 NO-DISPLAY."RADIOBUTTON GROUP r .
*SELECTION-SCREEN : END OF BLOCK b2.

"===============================================================================================
"End of Selection Screen
"===============================================================================================




"===============================================================================================
"Start of Class Delcation and Implementation
"===============================================================================================

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

ENDCLASS.                    "lcl_events DEFINITION

DATA gv_event_receiver TYPE REF TO lcl_events.

*----------------------------------------------------------------------*
*       CLASS lcl_events IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_events IMPLEMENTATION.
  METHOD handle_double_click.
    row = e_row.
    col = e_column.
*    DATA : wa LIKE LINE OF it_final.
  ENDMETHOD.
  "handle_double_click
  METHOD handle_f4.

  ENDMETHOD.

  METHOD handle_hot_spot.

    CASE e_column_id .
      WHEN 'VBELN'.
        READ TABLE lt_final ASSIGNING FIELD-SYMBOL(<lfs_read>) INDEX e_row_id.
        IF sy-subrc EQ 0.
          SET PARAMETER ID 'VF' FIELD <lfs_read>-vbeln.
          CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
        ENDIF.

      WHEN 'GSTIN_DTLS'.
        READ TABLE lt_final ASSIGNING FIELD-SYMBOL(<lfs_read_gstin>) INDEX e_row_id.
        IF sy-subrc EQ 0.
          PERFORM get_gstin_details USING e_row_id <lfs_read_gstin>-stcd3_cust.
        ENDIF.


      WHEN 'EWAY_DTLS'.
        READ TABLE lt_final ASSIGNING FIELD-SYMBOL(<lfs_read_eway>) INDEX e_row_id.
        IF sy-subrc EQ 0.
          PERFORM get_eway_details USING e_row_id <lfs_read_eway>-stcd3_cust
                                          <lfs_read_eway>-gstin <lfs_read_eway>-zzirn_no.
        ENDIF.



      WHEN OTHERS.


    ENDCASE.


    DATA lw_lvc_s_stbl TYPE lvc_s_stbl.

    lw_lvc_s_stbl-row  =  'X'   .
    lw_lvc_s_stbl-col  =  'X'.

    CALL METHOD c_alvgd->refresh_table_display
      EXPORTING
        is_stable      = lw_lvc_s_stbl
        i_soft_refresh = 'X'
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    CLEAR :e_row_id,          "Type	LVC_S_ROW
           e_column_id,      "Type LVC_S_COL
           es_row_no .       "Type  LVC_S_ROID



  ENDMETHOD.

  METHOD handle_toolbar.

  ENDMETHOD.


ENDCLASS.                    "lcl_events IMPLEMENTATION

CLASS my_cl_salv_pop_up DEFINITION .

  PUBLIC SECTION .

    CLASS-DATA: BEGIN OF st_double_click .
    CLASS-DATA: row    TYPE salv_de_row,
                column TYPE salv_de_column.
    CLASS-DATA: END OF st_double_click .

    CLASS-METHODS: popup
      IMPORTING
        mode           TYPE c
        start_line     TYPE i DEFAULT 2
        end_line       TYPE i DEFAULT 5
        start_column   TYPE i DEFAULT 15
        end_column     TYPE i DEFAULT 150
        popup          TYPE boolean DEFAULT ' '
        VALUE(t_table) TYPE table .

    CLASS-METHODS: double_click FOR EVENT double_click OF cl_salv_events_table
      IMPORTING row column.

ENDCLASS.                    "my_cl_salv_pop_up DEFINITION
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
CLASS my_cl_salv_pop_up IMPLEMENTATION .

  METHOD popup .

    DATA: ob_salv_table TYPE REF TO cl_salv_table.

    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = ob_salv_table
          CHANGING
            t_table      = t_table ).

      CATCH cx_salv_msg.
    ENDTRY.

    CHECK ob_salv_table IS BOUND.

    "-- Get ALV Funcitons Object reference
    DATA(lr_function) = ob_salv_table->get_functions( ).
    "-- Set Default ALV funtions
    lr_function->set_all( abap_true ).
    lr_function->set_layout_save( abap_true ).
    "-- Get ALV Display Setting Reference
    DATA(lr_display) = ob_salv_table->get_display_settings( ).
    "-- Set Report Title.
    lr_display->set_list_header( | Result Log | ).

    DATA: lr_columns TYPE REF TO cl_salv_columns_table,
          lr_column  TYPE REF TO cl_salv_column_table.

    lr_columns = ob_salv_table->get_columns( ).

    IF mode = 'G'.

      TRY.
          lr_column ?= lr_columns->get_column( 'GSTIN' ).
          lr_column->set_medium_text( 'GSTIN ' ).
          lr_column->set_long_text( 'GSTIN' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'TRADENAME' ).
*      lr_column->set_short_text( 'Trade Name' ).
          lr_column->set_medium_text( 'Trande Name' ).
          lr_column->set_long_text( 'Trade Name' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'LEGALNAME' ).
          lr_column->set_medium_text( 'Legal Name' ).
          lr_column->set_long_text( 'Legal Name' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'ADDRBNM' ).
          lr_column->set_medium_text( 'Address 1' ).
          lr_column->set_long_text( 'Address 1' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.


      TRY.
          lr_column ?= lr_columns->get_column( 'ADDRBNO' ).
          lr_column->set_medium_text( 'Address 2' ).
          lr_column->set_long_text( 'Address 2' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.


      TRY.
          lr_column ?= lr_columns->get_column( 'ADDRFLNO' ).
          lr_column->set_medium_text( 'Address 3' ).
          lr_column->set_long_text( 'Address 3' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.


      TRY.
          lr_column ?= lr_columns->get_column( 'ADDRST' ).
          lr_column->set_medium_text( 'Address 4' ).
          lr_column->set_long_text( 'Address 4' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'ADDRLOC' ).
          lr_column->set_medium_text( 'Location' ).
          lr_column->set_long_text( 'Location' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.


      TRY.
          lr_column ?= lr_columns->get_column( 'STATECODE' ).
          lr_column->set_medium_text( 'State Code' ).
          lr_column->set_long_text( 'State Code' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'ADDRPNCD' ).
          lr_column->set_medium_text( 'Pin Code' ).
          lr_column->set_long_text( 'Pin Code' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'TXPTYPE' ).
          lr_column->set_medium_text( 'Tax Type' ).
          lr_column->set_long_text( 'Tax Type' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'STATUS' ).
          lr_column->set_medium_text( 'Status' ).
          lr_column->set_long_text( 'Status' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.
      TRY.
          lr_column ?= lr_columns->get_column( 'BLKSTATUS' ).
          lr_column->set_medium_text( 'BLK Status' ).
          lr_column->set_long_text( 'BLK Status' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

    ELSEIF mode = 'E'.        " eway bill mode

      TRY.
          lr_column ?= lr_columns->get_column( 'EWAYBILL_NO' ).
          lr_column->set_medium_text( 'Eway Bill No' ).
          lr_column->set_long_text( 'Eway Bill No' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

      TRY.
          lr_column ?= lr_columns->get_column( 'STATUS' ).
          lr_column->set_medium_text( 'Status' ).
          lr_column->set_long_text( 'Status' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.


      TRY.
          lr_column ?= lr_columns->get_column( 'GENGSTIN' ).
          lr_column->set_medium_text( 'GSTIN' ).
          lr_column->set_long_text( 'GSTIN' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.


      TRY.
          lr_column ?= lr_columns->get_column( 'EWAYBILL_DATE' ).
          lr_column->set_medium_text( 'Eway Bill Date' ).
          lr_column->set_long_text( 'Eway Bill Date' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.


      TRY.
          lr_column ?= lr_columns->get_column( 'VALID_UPTO' ).
          lr_column->set_medium_text( 'Valid Upto' ).
          lr_column->set_long_text( 'Valid Upto' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.



      TRY.
          lr_column ?= lr_columns->get_column( 'BLKSTATUS' ).
          lr_column->set_medium_text( 'BLK Status' ).
          lr_column->set_long_text( 'BLK Status' ).
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.

    ENDIF.


    ob_salv_table->set_screen_popup(
      start_column = start_column
      end_column   = end_column
      start_line   = start_line
      end_line     = end_line ).

    DATA: ob_salv_events    TYPE REF TO cl_salv_events_table.

    ob_salv_events = ob_salv_table->get_event( ).

    SET HANDLER double_click FOR ob_salv_events .

    ob_salv_table->display( ) .

  ENDMETHOD .                    "popup
*----------------------------------------------------------------------*
  METHOD double_click .

    st_double_click-row    = row .
    st_double_click-column = column .

  ENDMETHOD .                    "raise_double_click
*----------------------------------------------------------------------*

ENDCLASS.                    "my_cl_salv_pop_up IMPLEMENTATION

*----------------------------------------------------------------------*


"===============================================================================================
"End of Class Declaration and Implementation
"===============================================================================================



"===============================================================================================
"Start of Initialization
"===============================================================================================

INITIALIZATION.

  wa_list-key = '1'.
  wa_list-text = 'Not Processed'.
  APPEND wa_list TO it_list.
  wa_list-key = '2'.
  wa_list-text = 'Under Proccess'.
  APPEND wa_list TO it_list.
  wa_list-key = '3'.
  wa_list-text = 'Completly Processed'.
  APPEND wa_list TO it_list.
  wa_list-key = '4'.
  wa_list-text = 'Error'.
  APPEND wa_list TO it_list.
  wa_list-key = '5'.
  wa_list-text = 'IRN Cancelled'.
  APPEND wa_list TO it_list.
*  wa_list-key = '6'.
*  wa_list-text = 'All Documents'.
*  APPEND wa_list TO it_list.



  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'STATUS'
      values          = it_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.


AT SELECTION-SCREEN ON status.

  CLEAR: wa_values, it_values.
  REFRESH it_values.
  wa_values-fieldname = 'STATUS'.

  APPEND wa_values TO it_values.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = sy-cprog
      dynumb             = sy-dynnr
      translate_to_upper = 'X'
    TABLES
      dynpfields         = it_values.

  READ TABLE it_values INDEX 1 INTO wa_values.
  IF sy-subrc = 0 AND wa_values-fieldvalue IS NOT INITIAL.
    READ TABLE it_list INTO wa_list
                      WITH KEY key = wa_values-fieldvalue.
    IF sy-subrc = 0.
      lv_selected_value = wa_list-text.
    ENDIF.
  ENDIF.


  "===============================================================================================
  "End of Initialization
  "===============================================================================================


  "===============================================================================================
  "Main Event
  "===============================================================================================

START-OF-SELECTION.
  PERFORM get_data.
  IF lt_final IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE 'No Entries found for selected criteria' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
    LEAVE LIST-PROCESSING.
  ENDIF.


  "===============================================================================================
  "End of Main Event
  "===============================================================================================









*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  BREAK primus.
  SELECT
          bukrs
          vkorg
          fkart
          base_kschl
          disc_kschl
          other_kschl
          type
          category
          expcat
          flag
          foc_flag

    FROM zeinv_link INTO TABLE lt_zeinv_link
    WHERE bukrs IN s_bukrs AND
           vkorg IN s_vkorg AND
           type = 'INV' AND
           flag NE 'X'.




  IF lt_zeinv_link IS NOT INITIAL.

    SELECT vbeln fkart vkorg fkdat gjahr rfbsk bukrs ernam erzet erdat kunag sfakn xblnr bupla
      FROM vbrk INTO TABLE lt_vbrk
      FOR ALL ENTRIES IN lt_zeinv_link
      WHERE fkart = lt_zeinv_link-fkart AND
            fkdat IN s_fkdat AND
            vkorg IN s_vkorg AND
*            gjahr EQ @p_gjahr AND
            bukrs = lt_zeinv_link-bukrs AND
            rfbsk = lc_rfbsk AND
           vbeln IN s_vbeln.


    IF lt_vbrk IS NOT INITIAL.

      SELECT
      bukrs branch gstin
       FROM j_1bbranch
            INTO TABLE lt_j_1bbranch
            FOR ALL ENTRIES IN lt_vbrk
            WHERE bukrs = lt_vbrk-bukrs AND
                  branch = lt_vbrk-bupla.

      SELECT
        bukrs
        docno
        odn
        irn
        version
        ack_no
        irn_status
        ernam
        erdat
        erzet
        signed_inv
        signed_qrcode
         FROM j_1ig_invrefnum INTO TABLE lt_j_1ig_invrefnum FOR ALL ENTRIES IN
      lt_vbrk WHERE docno = lt_vbrk-vbeln.


      SELECT vbeln sfakn FROM vbrk INTO TABLE lt_vbrk_can
        FOR ALL ENTRIES IN lt_vbrk
        WHERE  sfakn = lt_vbrk-vbeln.

      SELECT vbeln posnr werks vgbel FROM vbrp INTO TABLE lt_vbrp
        FOR ALL ENTRIES IN lt_vbrk WHERE
         vbeln = lt_vbrk-vbeln.

      IF lt_vbrp[] IS NOT INITIAL.

        SELECT vbeln vkorg vstel kunnr kunag
          FROM likp INTO TABLE lt_likp
          FOR ALL ENTRIES IN lt_vbrp WHERE vbeln = lt_vbrp-vgbel.

*       IF lt_likp[] is NOT INITIAL.
        SELECT kunnr land1 name1 pstlz regio adrnr stcd3
         FROM kna1 INTO TABLE lt_kna1
         FOR ALL ENTRIES IN lt_vbrk WHERE kunnr = lt_vbrk-kunag.

*       ENDIF.

      ENDIF.


      SELECT * FROM zeinv_res INTO TABLE lt_zeinv_response
        FOR ALL ENTRIES IN lt_vbrk
        WHERE vbeln = lt_vbrk-vbeln.

      SELECT * FROM tvfkt INTO TABLE lt_tvfkt FOR ALL ENTRIES IN lt_vbrk
        WHERE spras = 'EN' AND
              fkart = lt_vbrk-fkart.


    ENDIF.
  ELSE.
    MESSAGE 'No data found (Refer ZEINV_LINK)' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
    LEAVE LIST-PROCESSING.

  ENDIF.

  SORT lt_vbrk BY vbeln.
  SORT lt_vbrp BY vbeln.
  SORT lt_vbrk_can BY vbeln.
  SORT lt_zeinv_response BY vbeln.
  SORT lt_j_1ig_invrefnum BY docno version DESCENDING .





  FIELD-SYMBOLS : <lfs_vbrk>           TYPE lty_s_vbrk, <lfs_final> TYPE lty_final, <lfs_vbrp> TYPE lty_s_vbrp, <lfs_zeinv_response> TYPE zeinv_res.

  LOOP AT lt_vbrk ASSIGNING <lfs_vbrk>.

    ls_final-vbeln = <lfs_vbrk>-vbeln.
    ls_final-fkart = <lfs_vbrk>-fkart.
    ls_final-bukrs = <lfs_vbrk>-bukrs.
    ls_final-fkdat = <lfs_vbrk>-fkdat.
    ls_final-xblnr = <lfs_vbrk>-xblnr.
    ls_final-vkorg = <lfs_vbrk>-vkorg.
    ls_final-ernam = <lfs_vbrk>-ernam.
    ls_final-erzet = <lfs_vbrk>-erzet.
    ls_final-erdat = <lfs_vbrk>-erdat.


    READ TABLE lt_vbrk_can INTO ls_vbrk_can WITH KEY sfakn = <lfs_vbrk>-vbeln.
    IF sy-subrc EQ 0  .
      ls_final-can_doc = ls_vbrk_can-vbeln.
    ENDIF.

    READ TABLE lt_j_1bbranch INTO ls_j_1bbranch WITH KEY bukrs = <lfs_vbrk>-bukrs branch = <lfs_vbrk>-bupla.
    IF sy-subrc IS INITIAL.
      ls_final-gstin  = ls_j_1bbranch-gstin.
    ENDIF.

    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = <lfs_vbrk>-kunag."kunag.
    IF sy-subrc EQ 0.
      ls_final-kunnr      = ls_kna1-kunnr.
      ls_final-name1      = ls_kna1-name1.
      ls_final-stcd3_cust = ls_kna1-stcd3.
    ENDIF.

    READ TABLE lt_vbrp ASSIGNING <lfs_vbrp> WITH KEY
                                                  vbeln = <lfs_vbrk>-vbeln BINARY SEARCH.
    IF sy-subrc EQ 0.
      ls_final-werks = <lfs_vbrp>-werks.

      READ TABLE lt_likp INTO ls_likp_cust WITH KEY  vbeln = <lfs_vbrp>-vgbel.
      IF sy-subrc IS INITIAL.

*         READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_likp_cust-kunnr."kunag.
*         IF sy-subrc eq 0.
*           ls_final-kunnr      = ls_kna1-kunnr.
*           ls_final-name1      = ls_kna1-name1.
*           ls_final-stcd3_cust = ls_kna1-stcd3.
*         ENDIF.
      ENDIF.
    ENDIF.


    READ TABLE lt_tvfkt INTO ls_tvfkt WITH KEY fkart = <lfs_vbrk>-fkart.
    IF sy-subrc EQ 0.
      ls_final-vtext = ls_tvfkt-vtext.
    ENDIF.

    READ TABLE lt_zeinv_response INTO  ls_zeinv_response WITH KEY
                                           vbeln = <lfs_vbrk>-vbeln BINARY SEARCH.
    IF sy-subrc EQ 0 .

      ls_final-zzerror_disc = ls_zeinv_response-zzerror_disc.
      ls_final-zzstatus     = ls_zeinv_response-zzstatus.
      ls_final-zzuser       = ls_zeinv_response-zzuser.
      ls_final-zzcdate      = ls_zeinv_response-zzcdate.
      ls_final-zztime       = ls_zeinv_response-zztime.


      IF ls_zeinv_response-zzewaybill_no IS NOT INITIAL AND ls_zeinv_response-zzewaycan_date IS INITIAL .
        ls_final-eway_status       = '@0V\Q Eway Generated@'.
        ls_final-eway_description  = 'Eway Generated'.

      ELSEIF  ls_zeinv_response-zzewaybill_no IS NOT INITIAL AND ls_zeinv_response-zzewaycan_date IS NOT INITIAL .
        ls_final-eway_status       = '@F9\Q E-way Bill Cancelled@'.
        ls_final-eway_description  = 'E-way Bill Cancelled'.

      ELSE.
        ls_final-eway_status       = '@0W\Q Eway Not Generated@'.
        ls_final-eway_description  = 'Eway Not Generated'.
      ENDIF.

      IF ls_zeinv_response-zzstatus EQ 'C'.
        ls_final-process_status     = '@5B\Q Completly Processed@'.
        ls_final-status_description = 'Completly Processed'.
      ELSEIF ls_zeinv_response-zzstatus EQ 'E'.
        ls_final-process_status     = '@5C\Q Error!@'.
        ls_final-status_description = 'Error'.
      ELSEIF ls_zeinv_response-zzstatus EQ 'U'.
        ls_final-process_status     = '@3J\Q Under Process@'.
        ls_final-status_description = 'Under Process'.
      ELSEIF ls_zeinv_response-zzstatus EQ 'S'.
        ls_final-process_status     = '@F9\Q IRN Cancelled@'.
        ls_final-status_description = 'IRN Cancelled'.
      ENDIF.

      IF ls_zeinv_response-zzirn_no IS NOT INITIAL.
        ls_final-zzirn_no         = ls_zeinv_response-zzirn_no.
        ls_final-zzerror_disc     = ls_zeinv_response-zzerror_disc.
        ls_final-zzack_no         = ls_zeinv_response-zzack_no.
        ls_final-zzstatus         = ls_zeinv_response-zzstatus.
        ls_final-zzqr_code        = ls_zeinv_response-zzqr_code.
        ls_final-zzuser           = ls_zeinv_response-zzuser.
        ls_final-zzcdate          = ls_zeinv_response-zzcdate.
        ls_final-zztime           = ls_zeinv_response-zztime.
        ls_final-zzewaybill_no    = ls_zeinv_response-zzewaybill_no.
        ls_final-zzewaybill_date  = ls_zeinv_response-zzewaybill_date.
        ls_final-zzvalid_upto     = ls_zeinv_response-zzvalid_upto.
        ls_final-zzewaycan_date   = ls_zeinv_response-zzewaycan_date.

      ELSEIF ls_zeinv_response-zzirn_no IS INITIAL.
        READ TABLE lt_j_1ig_invrefnum ASSIGNING FIELD-SYMBOL(<lfs_j_1ig_invrefnum>) WITH KEY docno = <lfs_vbrk>-vbeln BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_final-zzirn_no         = <lfs_j_1ig_invrefnum>-irn.
          ls_final-zzack_no         = <lfs_j_1ig_invrefnum>-ack_no.
          ls_final-zzqr_code        = <lfs_j_1ig_invrefnum>-signed_qrcode.
          ls_final-zzuser           = <lfs_j_1ig_invrefnum>-ernam.
          ls_final-zzcdate          = <lfs_j_1ig_invrefnum>-erdat.
          ls_final-zztime           = <lfs_j_1ig_invrefnum>-erzet.

          IF <lfs_j_1ig_invrefnum>-irn_status EQ 'ACT'.
            ls_final-process_status     = '@5B\Q Completly Processed@'.
            ls_final-status_description = 'Completly Processed'.
            ls_final-zzerror_disc       = 'E-Invoice Generated Successfully!'.
          ELSEIF <lfs_j_1ig_invrefnum>-irn_status EQ 'CNL'.
            ls_final-process_status     = '@F9\Q IRN Cancelled@'.
            ls_final-status_description = 'IRN Cancelled'.
            ls_final-zzerror_disc       = 'E-Invoice Cancelled Successfully!'.
          ELSEIF ls_zeinv_response-zzstatus EQ 'ERR'.
            ls_final-process_status     = '@5C\Q Error!@'.
            ls_final-status_description = 'Error'.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
      ls_final-process_status = '@5D\Q Not Processed@'.
      ls_final-status_description = 'Not Processed'.
    ENDIF.


    ls_final-gstin_dtls = '@8P\Q Get GSTIN Details@'.
    ls_final-eway_dtls = '@8P\Q Get GSTIN Details@'.


    APPEND ls_final TO lt_final.
    CLEAR: ls_final , ls_zeinv_response , ls_zeinv_response.

  ENDLOOP.
  CLEAR :  lt_zeinv_response.


  "--Code added to Remove Same GSTIN (Buyer and Seller Same GSTIN ) 05.10.2020
  LOOP AT lt_final INTO ls_final.
    IF ls_final-gstin EQ ls_final-stcd3_cust.
      ls_final-gstin_flag = 'X'.
      MODIFY lt_final FROM ls_final TRANSPORTING gstin_flag.
    ENDIF.
  ENDLOOP.

  DELETE lt_final WHERE gstin_flag = 'X'.
  CLEAR : ls_final.
  "----------code end--------------------------------------------------

  IF lv_selected_value IS NOT INITIAL.
    DELETE lt_final WHERE status_description  NE lv_selected_value.
  ENDIF.
  CLEAR : lv_selected_value.


  CREATE OBJECT g_app.
  IF c_ccont IS INITIAL.
    CREATE OBJECT c_ccont
      EXPORTING
        container_name = 'CCONT'.   "--Custom Container Object for Materials Display.

    CREATE OBJECT c_alvgd
      EXPORTING
        i_parent = c_ccont.
  ENDIF.

  SET HANDLER g_app->handle_double_click FOR c_alvgd.
  SET HANDLER g_app->handle_hot_spot FOR c_alvgd.
  SET HANDLER g_app->handle_toolbar FOR c_alvgd.
*  SET HANDLER g_app->

  PERFORM alv_build_fieldcat.
  PERFORM alv_report_layout.

  CHECK NOT c_alvgd IS INITIAL.

  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
      is_layout                     = it_layout
      i_save                        = 'A'
    CHANGING
      it_outtab                     = lt_final[]
      it_fieldcatalog               = it_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo OUTPUT.

  DATA : lv_date_low  TYPE string,
         lv_date_high TYPE string,
         lv_date      TYPE string,
         lv_vkorg     TYPE string,
         lv_cname     TYPE string,
         lv_lines     TYPE string,
         lv_notp      TYPE string,
         lv_und       TYPE string,
         lv_irn       TYPE string,
         lv_can       TYPE string,
         lv_err       TYPE string.



  DATA : lv_line  TYPE i VALUE IS INITIAL,
         lv_notpi TYPE i VALUE IS INITIAL,
         lv_undi  TYPE i VALUE IS INITIAL,
         lv_irni  TYPE i VALUE IS INITIAL,
         lv_cani  TYPE i VALUE IS INITIAL,
         lv_erri  TYPE i VALUE IS INITIAL.


  FIELD-SYMBOLS : <lfs_status> TYPE lty_final.

  CLEAR : lv_line, lv_notpi,lv_undi,lv_irni,lv_cani,lv_notp,lv_und,lv_irn,lv_can,lv_err,lv_erri.


  IF lt_final IS NOT INITIAL.
    SELECT * FROM zeinv_res INTO TABLE lt_zeinv_response
     FOR ALL ENTRIES IN lt_final
     WHERE vbeln = lt_final-vbeln.

    SELECT vbeln sfakn FROM vbrk INTO TABLE lt_vbrk_can
       FOR ALL ENTRIES IN lt_final
       WHERE  sfakn = lt_final-vbeln.
  ENDIF.


  SORT lt_final BY vbeln.
  SORT lt_zeinv_response BY vbeln.


  LOOP AT lt_final ASSIGNING <lfs_status>.

    READ TABLE lt_zeinv_response INTO ls_zeinv_response WITH KEY
                                               vbeln = <lfs_status>-vbeln BINARY SEARCH.
    IF sy-subrc EQ 0.

      <lfs_status>-zzerror_disc   = ls_zeinv_response-zzerror_disc.
      <lfs_status>-zzstatus       = ls_zeinv_response-zzstatus.
      <lfs_status>-zzuser         = ls_zeinv_response-zzuser.
      <lfs_status>-zzcdate        = ls_zeinv_response-zzcdate.
      <lfs_status>-zztime         = ls_zeinv_response-zztime.

      IF ls_zeinv_response-zzewaybill_no IS NOT INITIAL AND ls_zeinv_response-zzewaycan_date IS INITIAL .
        <lfs_status>-eway_status        = '@0V\Q Eway Generated@'.
        <lfs_status>-eway_description   = 'Eway Generated'.

      ELSEIF ls_zeinv_response-zzewaybill_no IS NOT INITIAL AND ls_zeinv_response-zzewaycan_date IS NOT INITIAL.
        <lfs_status>-eway_status        = '@F9\Q E-way Bill Cancelled@'.
        <lfs_status>-eway_description   = 'E-way Bill Cancelled'.

      ELSE.
        <lfs_status>-eway_status        = '@0W\Q Eway Not Generated@'.
        <lfs_status>-eway_description   = 'Eway Not Generated'.
      ENDIF.

      IF ls_zeinv_response-zzstatus EQ 'C'.
        <lfs_status>-process_status     = '@5B\Q Completly Processed@'.
        <lfs_status>-status_description = 'Completly Processed'.
        lv_irni = lv_irni + 1.
      ELSEIF ls_zeinv_response-zzstatus EQ 'E'.
        <lfs_status>-process_status     = '@5C\Q Error!@'.
        <lfs_status>-status_description = 'Error'.
        lv_erri = lv_erri + 1.
      ELSEIF ls_zeinv_response-zzstatus EQ 'U'.
        <lfs_status>-process_status     = '@3J\Q Under Process@'.
        <lfs_status>-status_description = 'Under Proccess'.
        lv_undi = lv_undi + 1.
      ELSEIF ls_zeinv_response-zzstatus EQ 'S'.
        <lfs_status>-process_status     = '@F9\Q IRN Cancelled@'.
        <lfs_status>-status_description = 'IRN Cancelled'.
        lv_cani = lv_cani + 1.
      ENDIF.

      IF ls_zeinv_response-zzirn_no IS NOT INITIAL.
        <lfs_status>-zzirn_no        = ls_zeinv_response-zzirn_no.
        <lfs_status>-zzerror_disc    = ls_zeinv_response-zzerror_disc.
        <lfs_status>-zzack_no        = ls_zeinv_response-zzack_no.
        <lfs_status>-zzstatus        = ls_zeinv_response-zzstatus.
        <lfs_status>-zzqr_code       = ls_zeinv_response-zzqr_code.
        <lfs_status>-zzuser          = ls_zeinv_response-zzuser.
        <lfs_status>-zzcdate         = ls_zeinv_response-zzcdate.
        <lfs_status>-zztime          = ls_zeinv_response-zztime.
        <lfs_status>-can_reason      = ls_zeinv_response-zzcan_reason.
        <lfs_status>-zzewaybill_no   = ls_zeinv_response-zzewaybill_no.
        <lfs_status>-zzewaybill_date = ls_zeinv_response-zzewaybill_date.
        <lfs_status>-zzvalid_upto    = ls_zeinv_response-zzvalid_upto.
        <lfs_status>-zzewaycan_date  = ls_zeinv_response-zzewaycan_date.

      ELSEIF sy-subrc EQ 0 AND ls_zeinv_response-zzirn_no IS INITIAL.
        READ TABLE lt_j_1ig_invrefnum ASSIGNING FIELD-SYMBOL(<lfs_j_1ig_invrefnum>) WITH KEY docno = <lfs_status>-vbeln BINARY SEARCH.
        IF sy-subrc EQ 0.
          <lfs_status>-zzirn_no    = <lfs_j_1ig_invrefnum>-irn.
          <lfs_status>-zzack_no    = <lfs_j_1ig_invrefnum>-ack_no.
          <lfs_status>-zzqr_code   = <lfs_j_1ig_invrefnum>-signed_qrcode.
          <lfs_status>-zzuser      = <lfs_j_1ig_invrefnum>-ernam.
          <lfs_status>-zzcdate     = <lfs_j_1ig_invrefnum>-erdat.
          <lfs_status>-zztime      = <lfs_j_1ig_invrefnum>-erzet.

          IF <lfs_j_1ig_invrefnum>-irn_status EQ 'ACT'.
            <lfs_status>-process_status     = '@5B\Q Completly Processed@'.
            <lfs_status>-status_description = 'Completly Processed'.
            <lfs_status>-zzerror_disc       = 'E-Invoice Generated Successfully!'.
          ELSEIF <lfs_j_1ig_invrefnum>-irn_status EQ 'CNL'.
            <lfs_status>-process_status     = '@F9\Q IRN Cancelled@'.
            <lfs_status>-status_description = 'IRN Cancelled'.
            <lfs_status>-zzerror_disc       = 'E-Invoice Cancelled Successfully!'.
          ELSEIF ls_zeinv_response-zzstatus EQ 'ERR'.
            <lfs_status>-process_status     = '@5C\Q Error!@'.
            <lfs_status>-status_description = 'Error'.
          ENDIF.
        ENDIF.
      ENDIF.

    ELSE.
      <lfs_status>-process_status     = '@5D\Q Not Processed@'.
      <lfs_status>-status_description = 'Not Processed'.
      lv_notpi = lv_notpi + 1.
    ENDIF.

    READ TABLE lt_vbrk_can ASSIGNING FIELD-SYMBOL(<lfs_vbrk_can>) WITH KEY  sfakn = <lfs_status>-vbeln.
    IF sy-subrc EQ 0 .
      <lfs_status>-can_doc = <lfs_vbrk_can>-vbeln.
    ENDIF.
    CLEAR : ls_zeinv_response.
  ENDLOOP.

  CLEAR : lv_line, lv_notpi,lv_undi,lv_irni,lv_cani,lv_notp,lv_und,lv_irn,lv_can,lv_err,lv_erri.

  DESCRIBE TABLE lt_final LINES lv_line.

  LOOP AT lt_final INTO ls_final.
    IF ls_final-status_description  = 'Under Proccess'.
      lv_undi = lv_undi + 1.
    ELSEIF   ls_final-status_description  = 'Completly Processed' .
      lv_irni = lv_irni + 1.
    ELSEIF   ls_final-status_description  = 'Not Processed' .
      lv_notpi = lv_notpi + 1.
    ELSEIF   ls_final-status_description  = 'Error' .
      lv_erri = lv_erri + 1.
    ELSEIF   ls_final-status_description  = 'IRN Cancelled' .
      lv_cani = lv_cani + 1.
    ENDIF.
  ENDLOOP.


  lv_lines = lv_line.
  lv_notp  = lv_notpi.
  lv_irn   = lv_irni.
  lv_und   = lv_undi.
  lv_can   = lv_cani.
  lv_err   = lv_erri.

  CONCATENATE s_vkorg-low ' ' INTO  lv_vkorg.

  CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
    EXPORTING
      date_internal            = s_fkdat-low
    IMPORTING
      date_external            = lv_date_low
    EXCEPTIONS
      date_internal_is_invalid = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.

  ENDIF.

  IF s_fkdat-high IS NOT INITIAL.
    CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
      EXPORTING
        date_internal            = s_fkdat-high
      IMPORTING
        date_external            = lv_date_high
      EXCEPTIONS
        date_internal_is_invalid = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.

    ENDIF.

  ENDIF.



  IF s_fkdat-high IS NOT INITIAL.
    CONCATENATE lv_date_low '-' lv_date_high  INTO lv_date.
  ELSE.
    CONCATENATE lv_date_low '-' lv_date_high  INTO lv_date.
  ENDIF.



  DATA lw_lvc_s_stbl TYPE lvc_s_stbl.

  lw_lvc_s_stbl-row  =  'X'   .
  lw_lvc_s_stbl-col  =  'X'.

  CALL METHOD c_alvgd->refresh_table_display
    EXPORTING
      is_stable      = lw_lvc_s_stbl
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  PAI  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai INPUT.
  c_alvgd->check_changed_data( ).

  TYPES : BEGIN OF lty_check,
            vbeln    TYPE zeinv_res-vbeln,
            zzstatus TYPE zeinv_res-zzstatus,
          END OF lty_check.

  DATA : lt_zeinv_check TYPE STANDARD TABLE OF zeinv_res, "lty_check,
         ls_zeinv_check TYPE zeinv_res.

  DATA : lt_zeinv_c TYPE TABLE OF lty_check,
         ls_zeinv_c TYPE lty_check.

  DATA : lt_docs TYPE TABLE OF zstr_vbeln,
         ls_docs TYPE zstr_vbeln.

  DATA : lv_msg           TYPE string,
         lv_ucomm         TYPE sy-ucomm,
         lv_gjahr         TYPE gjahr,
         lv_msg_reason    TYPE string,
         lv_mode          TYPE flag,
         lvs_data         TYPE string,
         lv_gstin         TYPE stcd3,
         lv_selected_docs TYPE i,
         lv_counter       TYPE i.


  CLEAR :  lv_mode , lv_ucomm.


  CASE sy-ucomm.

      "===============================================================================================
      "Start of IRN Genertation
      "===============================================================================================

    WHEN '&IRN'.
      BREAK primus.
      lv_ucomm = '&IRN'.
      IF lt_final IS NOT INITIAL.
        SELECT vbeln zzstatus FROM zeinv_res INTO TABLE lt_zeinv_c
          FOR ALL ENTRIES IN lt_final
          WHERE vbeln = lt_final-vbeln.
      ENDIF.

      SORT lt_final BY vbeln.
      SORT lt_zeinv_c BY vbeln.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        lv_selected_docs = lv_selected_docs + 1.
        READ TABLE lt_zeinv_c INTO ls_zeinv_c
                                   WITH KEY vbeln = ls_final-vbeln BINARY SEARCH.
        IF sy-subrc EQ 0 AND ( ls_zeinv_c-zzstatus = 'C').
          CONCATENATE 'Document' ls_zeinv_c-vbeln 'Already Processed'
          INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

        IF ls_final-can_doc IS NOT INITIAL.
          CONCATENATE 'Document' ls_final-vbeln 'is Cancelled'
          INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

      ENDLOOP.
      IF sy-subrc EQ 4.
        MESSAGE 'Select Atleast 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.


      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar       = 'Generate IRN'
          text_question  = 'Submit Selected Documents?'
          icon_button_1  = 'icon_booking_ok'
        IMPORTING
          answer         = gstring
        EXCEPTIONS
          text_not_found = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      IF ( gstring = '1' ).
        MESSAGE 'Saved' TYPE 'S'.


        IF a1 = 'X'.

          LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
            CONCATENATE 'C:/EInvoice Files/IRN/' ls_final-vbeln '.json' INTO file_name.
            ls_zeinv_res-mandt  = sy-mandt.
            ls_zeinv_res-vbeln = ls_final-vbeln.
            ls_zeinv_res-fkdat = ls_final-fkdat.
            ls_zeinv_res-xblnr = ls_final-xblnr.
            ls_zeinv_res-zzuser = sy-uname.
            ls_zeinv_res-zzcdate = sy-datum.
            ls_zeinv_res-zztime = sy-uzeit.
            ls_zeinv_res-werks = ls_final-werks.
            ls_zeinv_res-zzstatus = 'U'.         "Under Process

********************          ADDED BY AJAY *****************************************************************
*          ls_zeinv_res-ZZIRN_NO = LS_FINAL-ZZIRN_NO.
*          ls_zeinv_res-ZZQR_CODE = LS_FINAL-ZZQR_CODE.
*          ls_zeinv_res-ZZEWAYBILL_NO = LS_FINAL-ZZEWAYBILL_NO.
*          ls_zeinv_res-ZZEWAYBILL_DATE = LS_FINAL-ZZEWAYBILL_DATE.
***************************************************************




            CALL FUNCTION 'GET_CURRENT_YEAR'
              EXPORTING
                bukrs = ' '
                date  = ls_final-fkdat "SY-DATUM
              IMPORTING
                curry = lv_gjahr.

            IF lv_selected_docs GT 1.
              lv_mode = 'R'. "--- Manual Mode with multiple doc selected.
            ELSE.
              lv_mode = 'M'. "------Manual mode with single doc selected
            ENDIF.


            "===============================================================================================
            "FM to Generate Json file data
            "===============================================================================================

            CALL FUNCTION 'ZJSON_FILE_SAVE_INV_N'
              EXPORTING
                vbeln       = ls_final-vbeln
                gjahr       = lv_gjahr
*               FILE_LOC    =
                lv_ucomm    = lv_ucomm
                lv_mode     = lv_mode
              IMPORTING
                status      = lv_status
              TABLES
                lt_docs     = lt_docs
                lt_retmsg   = lt_retmsg
                lt_jsonfile = lt_jsonfile.

            CLEAR :  sy-ucomm , lv_mode.
            REFRESH lt_docs.




            lv_counter = lv_counter + 1.

            IF lt_jsonfile[] IS NOT INITIAL.
              IF lv_selected_docs GT 1.
                IF lv_counter EQ 1.
                  ls_jsonfile-line  = '['.
                  APPEND ls_jsonfile-line TO lt_jsonfile_multiple.
                  CLEAR ls_jsonfile.
                ENDIF.

                APPEND LINES OF lt_jsonfile TO lt_jsonfile_multiple.

                IF lv_counter LT lv_selected_docs.
                  ls_jsonfile-line  = ','.
                  APPEND ls_jsonfile-line TO lt_jsonfile_multiple.
                  CLEAR ls_jsonfile.
                ELSEIF lv_counter EQ lv_selected_docs.
                  ls_jsonfile-line  = ']'.
                  APPEND ls_jsonfile-line TO lt_jsonfile_multiple.
                  CLEAR ls_jsonfile.
                ENDIF.
                CLEAR : lt_jsonfile.
              ENDIF.

*        *  "update z table---------------------



              IF ls_zeinv_res IS NOT INITIAL.
                MODIFY zeinv_res FROM ls_zeinv_res.
                COMMIT WORK.
              ENDIF.

            ENDIF.

          ENDLOOP.

          "===============================================================================================
          "End of FM to generate Json file data
          "===============================================================================================

          IF lv_selected_docs GT 1.
            lt_jsonfile[] = lt_jsonfile_multiple[].
          ENDIF.

          IF lt_jsonfile[] IS NOT INITIAL.
            IF a1 = abap_true.   " Manual Generation
              PERFORM manual_irn_generation." TABLES lt_jsonfile .
            ENDIF.
          ENDIF.

          CLEAR : lt_jsonfile, lt_jsonfile_multiple ,lv_counter,lv_selected_docs.


        ELSE.     "--------------------------------------  if selected option is not manual mode.
          BREAK primus.
          LOOP AT lt_final INTO ls_final WHERE selection = 'X'.

            CONCATENATE 'C:/EInvoice Files/IRN/' ls_final-vbeln '.json' INTO file_name.
            ls_zeinv_res-mandt  = sy-mandt.
            ls_zeinv_res-vbeln = ls_final-vbeln.
            ls_zeinv_res-fkdat = ls_final-fkdat.
            ls_zeinv_res-xblnr = ls_final-xblnr.
            ls_zeinv_res-zzuser = sy-uname.
            ls_zeinv_res-zzcdate = sy-datum.
            ls_zeinv_res-zztime = sy-uzeit.
            ls_zeinv_res-werks = ls_final-werks.

****************************          ADDED BY AJAY ****************************************
*          ls_zeinv_res-ZZIRN_NO = LS_FINAL-ZZIRN_NO.
*          ls_zeinv_res-ZZQR_CODE = LS_FINAL-ZZQR_CODE.
*          ls_zeinv_res-ZZEWAYBILL_NO = LS_FINAL-ZZEWAYBILL_NO.
*          ls_zeinv_res-ZZEWAYBILL_DATE = LS_FINAL-ZZEWAYBILL_DATE.


***************************       END ****************************************

            IF a3 = 'X'.
              IF ls_zeinv_res IS NOT INITIAL.
                MODIFY zeinv_res FROM ls_zeinv_res.
                COMMIT WORK.
              ENDIF.
            ENDIF.

            CALL FUNCTION 'GET_CURRENT_YEAR'
              EXPORTING
                bukrs = ' '
                date  = ls_final-fkdat "SY-DATUM
              IMPORTING
                curry = lv_gjahr.

            IF a3 = 'X'.
              lv_mode  = 'X'.
            ELSEIF a1 = 'X'.
              lv_mode = 'M'.
            ENDIF.

            "===============================================================================================
            "FM to Generate Json file data
            "===============================================================================================

            CALL FUNCTION 'ZJSON_FILE_SAVE_INV_N'
              EXPORTING
                vbeln       = ls_final-vbeln
                gjahr       = lv_gjahr
*               FILE_LOC    =
                lv_ucomm    = lv_ucomm
                lv_mode     = lv_mode
              IMPORTING
                status      = lv_status
              TABLES
*               lt_docs     = lt_docs
                lt_retmsg   = lt_retmsg
                lt_jsonfile = lt_jsonfile.

            CLEAR :  sy-ucomm , lv_mode.
*          REFRESH lt_docs.


            "===============================================================================================
            "End of FM to generate Json file data
            "===============================================================================================


            IF lt_jsonfile IS NOT INITIAL.
              IF a1 = abap_true.   " Manual Generation
                PERFORM manual_irn_generation." TABLES lt_jsonfile .

              ELSEIF a2 = abap_true.  " using FTP
                PERFORM irn_using_ftp USING ls_final-vbeln..

              ELSEIF a3 = abap_true. " using api


                TYPES : BEGIN OF ty_res_tokan,
                          header TYPE string,
                          value  TYPE string,
                        END OF ty_res_tokan.

                DATA :lt_res_tokan TYPE STANDARD TABLE OF ty_res_tokan,
                      ls_res_tokan TYPE ty_res_tokan.

                DATA:lt_ein_tokan TYPE STANDARD TABLE OF ty_res_tokan,
                     ls_ein_tokan TYPE ty_res_tokan.

                PERFORM api_auth .
                PERFORM irn_using_api USING ls_final-vbeln .

              ELSEIF a4 = abap_true.   "---PrimEBrdige Application

                LOOP AT lt_jsonfile INTO ls_jsonfile.
                  CONCATENATE  lvs_data ls_jsonfile-line  INTO lvs_data.
                ENDLOOP.

                PERFORM irn_using_rfc USING ls_final-vbeln lvs_data ls_final-gstin.  "--Call .NET RFC
                CLEAR: lvs_data.
              ENDIF.
            ENDIF.

            CLEAR : lt_jsonfile.
          ENDLOOP.
        ENDIF.


        lw_lvc_s_stbl-row  =  'X'   .
        lw_lvc_s_stbl-col  =  'X'.

        CALL METHOD c_alvgd->refresh_table_display
          EXPORTING
            is_stable      = lw_lvc_s_stbl
            i_soft_refresh = 'X'
          EXCEPTIONS
            finished       = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.


        REFRESH:it_fcat.

      ELSE.
        MESSAGE 'Not Saved'  TYPE 'S'.
      ENDIF.

      "===============================================================================================
      "End of IRN Generation
      "===============================================================================================



      "===============================================================================================
      " Start of Cancel IRN
      "===============================================================================================


    WHEN '&CAN'.  " ----Cancel IRN

      BREAK primus.
      IF a1 = 'X'.
        MESSAGE ' Cancel The IRN From Gov. Portal Directly' TYPE 'E'.
        EXIT.
        LEAVE LIST-PROCESSING.
      ENDIF.

      lv_ucomm = '&CAN'.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.


        IF ls_final-can_doc IS INITIAL.
          CONCATENATE 'Cancelation is not done for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ELSE.
          IF ls_final-can_reason IS INITIAL.
            CONCATENATE ' Please Enter Remark for Cancelation ' ls_final-vbeln INTO lv_msg_reason SEPARATED BY space.
            MESSAGE lv_msg_reason TYPE 'E'.
            LEAVE LIST-PROCESSING.
          ENDIF.
          IF ls_final-can_rsn IS INITIAL.
            CONCATENATE ' Please Enter reason for Cancelation ' ls_final-vbeln INTO lv_msg_reason SEPARATED BY space.
            MESSAGE lv_msg_reason TYPE 'E'.
            LEAVE LIST-PROCESSING.
          ENDIF.
        ENDIF.

        IF ls_final-zzewaycan_date IS NOT INITIAL.
          CONCATENATE 'Eway bill is cancelled for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

        IF ls_final-zzirn_no IS INITIAL.
          CONCATENATE 'IRN is not generated for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.
      ENDLOOP.
      IF sy-subrc EQ 4.
        MESSAGE 'Select Atleast 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.




      SELECT * FROM zeinv_res INTO TABLE lt_zeinv_check
        FOR ALL ENTRIES IN lt_final
        WHERE vbeln = lt_final-vbeln.

      SORT lt_final BY vbeln.
      SORT lt_zeinv_check BY vbeln.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        CONCATENATE 'C:/EInvoice Files/Cancel IRN/' ls_final-vbeln '.json' INTO file_name.
        READ TABLE lt_zeinv_check INTO ls_zeinv_check
                                    WITH KEY vbeln = ls_final-vbeln BINARY SEARCH.

        IF sy-subrc EQ 0.
          ls_zeinv_check-zzcan_reason = ls_final-can_reason.
          ls_zeinv_check-zzcan_rsn    = ls_final-can_rsn.
          MODIFY zeinv_res FROM ls_zeinv_check.
          COMMIT WORK.


          "========================="FM to Generate Data into Json Format================================
          CALL FUNCTION 'ZJSON_FILE_SAVE_INV_N'
            EXPORTING
              vbeln       = ls_final-vbeln
*             GJAHR       =
*             file_loc    = file_name
              lv_ucomm    = lv_ucomm
*             lv_mode     = lv_mode
            IMPORTING
              status      = lv_status
            TABLES
              lt_retmsg   = lt_retmsg
              lt_jsonfile = lt_jsonfile.

          CLEAR sy-ucomm.
          "===============================================================================================



          IF lt_jsonfile IS NOT INITIAL.
            IF a1 = abap_true.   " Manual Generation
              PERFORM manual_irn_generation." TABLES lt_jsonfile .

            ELSEIF a2 = abap_true.  " using FTP
              PERFORM irn_using_ftp USING ls_final-vbeln..

            ELSEIF a3 = abap_true. " using api
              PERFORM api_auth .
              PERFORM irn_can_using_api USING ls_final-vbeln.

            ELSEIF a4 = abap_true. "--PrimEBridge Application

              IF lt_jsonfile IS NOT INITIAL.
                LOOP AT lt_jsonfile INTO ls_jsonfile.
                  CONCATENATE  lvs_data ls_jsonfile-line  INTO lvs_data.
                ENDLOOP.
              ENDIF.

              PERFORM cancel_irn_using_rfc USING ls_final-vbeln lvs_data ls_final-gstin lv_ucomm.  "--Call .NET RFC.

              CLEAR: lvs_data,lv_ucomm.
            ENDIF.
          ENDIF.
          CLEAR : lt_jsonfile,ls_zeinv_check.

        ELSE.
          CONCATENATE 'Document' ls_zeinv_check-vbeln 'is not Processed Completely'
          INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.
      ENDLOOP.
      "===============================================================================================
      "End of Cancel IRN
      "===============================================================================================



      "===============================================================================================
      "Start of Refresh
      "===============================================================================================
    WHEN '&REF'.
      lw_lvc_s_stbl-row  =  'X'   .
      lw_lvc_s_stbl-col  =  'X'.

      CALL METHOD c_alvgd->refresh_table_display
        EXPORTING
          is_stable      = lw_lvc_s_stbl
          i_soft_refresh = 'X'
        EXCEPTIONS
          finished       = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      "===============================================================================================
      "End of Refresh
      "===============================================================================================




      "===============================================================================================
      "Start of Print
      "===============================================================================================
    WHEN '&PRINT'.
      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        IF ls_final-zzirn_no IS INITIAL.
          CONCATENATE 'IRN is not generated for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.
        ls_range-sign = 'I'.
        ls_range-opti = 'EQ'.
        ls_range-low = ls_final-vbeln.
        APPEND ls_range TO lt_range.
        CLEAR ls_range.
      ENDLOOP.
      IF sy-subrc EQ 4.
        MESSAGE 'Select Atleast 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ELSE.
        SUBMIT sd70av3a WITH rg_vbeln IN lt_range AND RETURN.
        CLEAR lt_range.
      ENDIF.
      "===============================================================================================
      "End of Print
      "===============================================================================================



      "===============================================================================================
      "Start of Eway Bill Number Generation
      "===============================================================================================

      "--Eway Bill Generate
    WHEN '&EWAY'.
      CLEAR lv_selected_docs.
      CLEAR zeway_bill.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        lv_selected_docs = lv_selected_docs + 1.
        IF ls_final-zzstatus = 'S'.
          CONCATENATE 'IRN is cancelled for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

        IF ls_final-zzirn_no IS INITIAL.
          CONCATENATE 'IRN is not generated for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

        IF ls_final-zzewaybill_no IS NOT INITIAL.
          CONCATENATE 'Eway bill is already generated for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

      ENDLOOP.
      IF sy-subrc EQ 4.
        MESSAGE 'Select Atleast 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.
      IF lv_selected_docs GT 1 AND a1 NE 'X'.
        MESSAGE 'Select Maximum 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.

      "======================Call Sub-screen =========================================================

      CALL SCREEN 200  STARTING AT 05 05 .
      "===============================================================================================


      IF sy-ucomm = '&SAVE'.
        LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
          CONCATENATE 'C:/EInvoice Files/Eway/' ls_final-vbeln '.json' INTO file_name.

          PERFORM create_eway_by_irn USING ls_final-zzirn_no ls_final-vbeln ls_final-bukrs ls_final-fkart ls_final-gstin.
        ENDLOOP.
        MESSAGE 'Saved' TYPE 'S'.
      ENDIF.

      CLEAR : sy-ucomm ,zeway_bill..

      "===============================================================================================
      "End of Eway Bill Number Generation
      "===============================================================================================




      "===============================================================================================
      "Start of IRN + Eway Generation
      "===============================================================================================

    WHEN '&IRNEW'.

      CLEAR lv_selected_docs.
      CLEAR zeway_bill.
      lv_ucomm = '&IRNEW'.

      SELECT vbeln zzstatus FROM zeinv_res INTO TABLE lt_zeinv_c
        FOR ALL ENTRIES IN lt_final
        WHERE vbeln = lt_final-vbeln.

      SORT lt_final BY vbeln.
      SORT lt_zeinv_c BY vbeln.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        lv_selected_docs = lv_selected_docs + 1.
        READ TABLE lt_zeinv_c INTO ls_zeinv_c
                                   WITH KEY vbeln = ls_final-vbeln BINARY SEARCH.
        IF sy-subrc EQ 0 AND ( ls_zeinv_c-zzstatus = 'C')." OR ls_zeinv_check-zzstatus = 'U' ) .
          CONCATENATE 'Document' ls_zeinv_c-vbeln 'Already Processed'
          INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.
      ENDLOOP.
      IF sy-subrc EQ 4.
        MESSAGE 'Select Atleast 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.
      IF lv_selected_docs GT 1.
        MESSAGE 'Select Maximum 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.

      "Call Sub-screen
      "===============================================================================================

      CALL SCREEN 0200 STARTING AT 05 05.
      "===============================================================================================

      IF sy-ucomm = '&SAVE'.

        LOOP AT lt_final INTO ls_final WHERE selection = 'X'.

          CONCATENATE 'C:/EInvoice Files/IRN and Eway/' ls_final-vbeln '.json' INTO file_name.
          ls_zeinv_res-mandt  = sy-mandt.
          ls_zeinv_res-vbeln = ls_final-vbeln.
          ls_zeinv_res-fkdat = ls_final-fkdat.
          ls_zeinv_res-xblnr = ls_final-xblnr.
          ls_zeinv_res-zzuser = sy-uname.
          ls_zeinv_res-zzcdate = sy-datum.
          ls_zeinv_res-zztime = sy-uzeit.
          ls_zeinv_res-werks = ls_final-werks.


          CALL FUNCTION 'GET_CURRENT_YEAR'
            EXPORTING
              bukrs = ' '
              date  = ls_final-fkdat "SY-DATUM
            IMPORTING
*             CURRM =
              curry = lv_gjahr
*             PREVM =
*             PREVY =
            .


          IF a3 = 'X'.
            lv_mode  = 'X'.
          ELSEIF a1 = 'X'.
            lv_mode = 'M'.
          ENDIF.

          "FM to  Generate Data json format
          "===============================================================================================

          CALL FUNCTION 'ZJSON_FILE_SAVE_INV_N'
            EXPORTING
              vbeln       = ls_final-vbeln
              gjahr       = lv_gjahr
*             FILE_LOC    =
              lv_ucomm    = lv_ucomm
              lv_mode     = lv_mode
            IMPORTING
              status      = lv_status
            TABLES
*             lt_docs     = lt_docs
              lt_retmsg   = lt_retmsg
              lt_jsonfile = lt_jsonfile.

          CLEAR :sy-ucomm , lv_mode , lv_ucomm.
*          REFRESH lt_docs.

          "===============================================================================================



          IF lt_jsonfile IS NOT INITIAL.
            IF a1 = abap_true.   " Manual Generation
              PERFORM manual_irn_generation." TABLES lt_jsonfile .

            ELSEIF a2 = abap_true.  " using FTP
              PERFORM irn_using_ftp USING ls_final-vbeln..

            ELSEIF a3 = abap_true. " using api
              PERFORM irn_using_api USING ls_final-vbeln.

            ELSEIF a4 = abap_true.   "---PrimEBrdige Application


              LOOP AT lt_jsonfile INTO ls_jsonfile.
                CONCATENATE  lvs_data ls_jsonfile-line  INTO lvs_data.
              ENDLOOP.

              PERFORM irn_using_rfc USING ls_final-vbeln lvs_data ls_final-gstin.  "--Call .NET RFC
              CLEAR: lvs_data.
            ENDIF.
          ENDIF.

          CLEAR : lt_jsonfile ,zeway_bill.

        ENDLOOP.



        lw_lvc_s_stbl-row  =  'X'   .
        lw_lvc_s_stbl-col  =  'X'.

        CALL METHOD c_alvgd->refresh_table_display
          EXPORTING
            is_stable      = lw_lvc_s_stbl
            i_soft_refresh = 'X'
          EXCEPTIONS
            finished       = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.


        REFRESH:it_fcat.
      ENDIF.
      CLEAR: sy-ucomm.

      "===============================================================================================
      "End of IRN + Eway Generation
      "===============================================================================================


    WHEN '&CANEWAY'.

      CLEAR : lv_selected_docs.

      lv_ucomm = '&CANEWAY'.

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        lv_selected_docs = lv_selected_docs + 1.
        IF ls_final-zzirn_no IS INITIAL.
          CONCATENATE 'IRN is not generated for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

        IF ls_final-zzewaybill_no IS INITIAL.
          CONCATENATE 'Eway Bill is not generated for Document' ls_final-vbeln INTO lv_msg SEPARATED BY space.
          MESSAGE lv_msg TYPE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

      ENDLOOP.
      IF sy-subrc EQ 4.
        MESSAGE 'Select Atleast 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.

      IF lv_selected_docs GT 1.
        MESSAGE 'Select Maximum 1 Document' TYPE 'E'.
        LEAVE LIST-PROCESSING.
        EXIT.
      ENDIF.

      "======================Call Sub-screen =========================================================

      CALL SCREEN 300  STARTING AT 05 05 .
      "===============================================================================================

      IF sy-ucomm = '&CAN'.

        LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
          CONCATENATE 'C:/EInvoice Files/Cancel Eway/' ls_final-vbeln '.json' INTO file_name.

          "========================="FM to Generate Data into Json Format================================
          CALL FUNCTION 'ZJSON_FILE_SAVE_INV_N'
            EXPORTING
              vbeln       = ls_final-vbeln
*             GJAHR       =
*             file_loc    = file_name
              lv_ucomm    = lv_ucomm
*             lv_mode     = lv_mode
            IMPORTING
              status      = lv_status
            TABLES
              lt_retmsg   = lt_retmsg
              lt_jsonfile = lt_jsonfile.

          CLEAR: sy-ucomm.
          "===============================================================================================



          IF lt_jsonfile IS NOT INITIAL.

            IF a1 = abap_true.   " Manual Generation
              PERFORM manual_irn_generation." TABLES lt_jsonfile .

            ELSEIF a2 = abap_true.  " using FTP
              PERFORM irn_using_ftp USING ls_final-vbeln..

            ELSEIF a3 = abap_true. " using api
              PERFORM irn_can_using_api USING ls_final-vbeln.

            ELSEIF a4 = abap_true. "--PrimEBridge Application
              LOOP AT lt_jsonfile INTO ls_jsonfile.
                CONCATENATE  lvs_data ls_jsonfile-line  INTO lvs_data.
              ENDLOOP.
              PERFORM cancel_irn_using_rfc USING ls_final-vbeln lvs_data ls_final-gstin lv_ucomm.  "--Call .NET RFC.
              CLEAR: lvs_data,lv_ucomm.
            ENDIF.
          ENDIF.
          CLEAR : lt_jsonfile,ls_zeinv_check.

        ENDLOOP.
      ENDIF.








    WHEN 'EXIT' OR 'BACK'.
      SET SCREEN '0'.
      LEAVE SCREEN.

      CLEAR: lv_selected_docs,lv_mode.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZSTATUS'.
  SET TITLEBAR 'ZTITLE'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat .


  DATA lv_fldcat TYPE lvc_s_fcat.
  CLEAR :lv_fldcat,it_fcat.


  lv_fldcat-fieldname = 'SELECTION'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 5.
  lv_fldcat-scrtext_m = 'Selection'.
  lv_fldcat-checkbox = abap_true.
  lv_fldcat-edit = 'X'.


  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PROCESS_STATUS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 5.
  lv_fldcat-just      = 'C'.
  lv_fldcat-scrtext_m = 'IRN Status'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'STATUS_DESCRIPTION'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 25.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'IRN Description'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'EWAY_STATUS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 5.
  lv_fldcat-just      = 'C'.
  lv_fldcat-scrtext_m = 'Eway Status'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'EWAY_Description'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 20.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Eway Description'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CAN_DOC'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 16.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Cancelled Document'.

  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'CAN_RSN'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
  lv_fldcat-edit      = 'X'.
  lv_fldcat-f4availabl = 'X'.
  lv_fldcat-ref_table = 'ZEINV_RES'.
  lv_fldcat-ref_field = 'ZZCAN_RSN'.
  lv_fldcat-scrtext_m = 'Can Reason'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CAN_REASON'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 50.
  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Cancelation Remark'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GSTIN_DTLS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-inttype   = 'C'.
  lv_fldcat-outputlen = 5.
  lv_fldcat-just      = 'C'.
  lv_fldcat-scrtext_m = 'GSTIN'.
  lv_fldcat-tooltip   = 'Get GSTIN Details'.
  lv_fldcat-hotspot = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'EWAY_DTLS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-inttype   = 'C'.
  lv_fldcat-outputlen = 5.
  lv_fldcat-scrtext_m = 'EWAY'.
  lv_fldcat-just      = 'C'.
  lv_fldcat-tooltip   = 'Get EWAY Details'.
  lv_fldcat-hotspot = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'KUNNR'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Customer'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'NAME1'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 30.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Customer Name'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'BUKRS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Company Code'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Plant'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'VKORG'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 04.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Sales Organization'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 16.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Billing Document'.
  lv_fldcat-hotspot = 'X'.
  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'FKART'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 06.
  lv_fldcat-scrtext_m = 'Billing Type'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'VTEXT'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 20.
  lv_fldcat-scrtext_m = 'Document Type Desc.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'XBLNR'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 16.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Invoice Number'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ERDAT'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'IRN Creation Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ERZET'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 16.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'IRN Creation Time'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ERNAM'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 12.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Created By'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FKDAT'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Billing Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ZZIRN_NO'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 65.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'IRN Number'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'ZZERROR_DISC'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 50.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Message'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ZZACK_NO'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 15.
  lv_fldcat-scrtext_m = 'Acknowledgement Number'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'ZZEWAYBILL_NO'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 12.
  lv_fldcat-scrtext_m = 'E-Way Number'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ZZEWAYBILL_DATE'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'E-Way Bill Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ZZVALID_UPTO'.
  lv_fldcat-tabname   = 'LT_FINAL'.
*  lv_fldcat-key       = 'X'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'E-Way Valid Upto'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'ZZQR_CODE'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 40.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'QR Code'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ZZUSER'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 12.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'IRN Generation User'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'ZZCDATE'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'IRN Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'ZZTIME'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'IRN Created On'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ZZEWAYCAN_DATE'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'E-way Cancel Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_report_layout .

  it_layout-zebra      = 'X'.
  it_layout-cwidth_opt = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  LOAD_LOGO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE load_logo OUTPUT.
  CONSTANTS: cntl_true  TYPE i VALUE 1,
             cntl_false TYPE i VALUE 0.
  DATA:h_picture       TYPE REF TO cl_gui_picture,
       h_pic_container TYPE REF TO cl_gui_custom_container.
  DATA: graphic_url(255),
  graphic_refresh(1),
  g_result LIKE cntl_true.
  DATA: BEGIN OF graphic_table OCCURS 0,
          line(255) TYPE x,
        END OF graphic_table.
  DATA: graphic_size TYPE i.
  DATA: g_stxbmaps TYPE stxbitmaps,
        l_bytecnt  TYPE i,
        l_content  TYPE STANDARD TABLE OF bapiconten INITIAL SIZE 0.


*BREAK primus.
  g_stxbmaps-tdobject = 'GRAPHICS'.
  g_stxbmaps-tdname = 'LOGO_INDIA'.       "'ZJAI1_BW'.         "'ZPRIM'.            "'ZJAI1_COL'.
  g_stxbmaps-tdid = 'BMAP'.
  g_stxbmaps-tdbtype = 'BCOL'.


  CALL FUNCTION 'SAPSCRIPT_GET_GRAPHIC_BDS'
    EXPORTING
      i_object       = g_stxbmaps-tdobject
      i_name         = g_stxbmaps-tdname
      i_id           = g_stxbmaps-tdid
      i_btype        = g_stxbmaps-tdbtype
    IMPORTING
      e_bytecount    = l_bytecnt
    TABLES
      content        = l_content
    EXCEPTIONS
      not_found      = 1
      bds_get_failed = 2
      bds_no_content = 3
      OTHERS         = 4.

  CALL FUNCTION 'SAPSCRIPT_CONVERT_BITMAP'
    EXPORTING
      old_format               = 'BDS'
      new_format               = 'BMP'
      bitmap_file_bytecount_in = l_bytecnt
    IMPORTING
      bitmap_file_bytecount    = graphic_size
    TABLES
      bds_bitmap_file          = l_content
      bitmap_file              = graphic_table
    EXCEPTIONS
      OTHERS                   = 1.

  CALL FUNCTION 'DP_CREATE_URL'
    EXPORTING
      type     = 'image'
      subtype  = cndp_sap_tab_unknown
      size     = graphic_size
      lifetime = cndp_lifetime_transaction
    TABLES
      data     = graphic_table
    CHANGING
      url      = graphic_url
    EXCEPTIONS
      OTHERS   = 4.

  CREATE OBJECT h_pic_container
    EXPORTING
      container_name = 'CLOGO'.

  CREATE OBJECT h_picture EXPORTING parent = h_pic_container.

  CALL METHOD h_picture->set_display_mode
    EXPORTING
      display_mode = cl_gui_picture=>display_mode_normal.

  CALL METHOD h_picture->load_picture_from_url
    EXPORTING
      url    = graphic_url
    IMPORTING
      result = g_result.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  MANUAL_IRN_GENERATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM manual_irn_generation.


*  "update z table---------------------


  IF  a1 NE 'X'.

    ls_zeinv_res-zzstatus = 'U'.         "Under Process

    IF ls_zeinv_res IS NOT INITIAL.
      MODIFY zeinv_res FROM ls_zeinv_res.
      COMMIT WORK.
    ENDIF.

  ENDIF.


**DOWNLOAD FILE
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = file_name "'C:/desktop/E-INVOICE.json'
    CHANGING
      data_tab = lt_jsonfile "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE i003 WITH file_name. " 'E-INVOICE Downloaded in Json Format on C:/desktop/'
    "TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  IRN_USING_FTP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM irn_using_ftp USING vbeln TYPE vbeln.

  """""""""""""""""""""""ftp send file""""""""""""""""""""""""""""""""""""""""""''

  TYPES : BEGIN OF lts_result,
            line(10000) TYPE c,
          END OF lts_result.

  TYPES : BEGIN OF lts_result1,
            line TYPE x,
          END OF lts_result1.


  DATA : lt_hex TYPE lts_result1.

  DATA : lv_date        TYPE char10,
         lv_date1       TYPE char10,

         lv_date_chnage TYPE char8,
         lv_date2       TYPE char10.

  DATA : pa_user  TYPE c LENGTH 30 VALUE 'user1', "FTP Server User
         pa_pswrd TYPE c LENGTH 30 VALUE 'password', "FTP Server User's Password
         pa_host  TYPE c LENGTH 64 VALUE '49.248.152.131', "IP Address of the FTP Server
         pa_rfcds LIKE rfcdes-rfcdest VALUE 'SAPFTPA' . "RFC Destination,SAPFTP for Frontend communications(Local Connections)

  DATA : mi_key     TYPE i VALUE '26101957', "Hardcoded Handler Key,This is always '26101957'
         mi_pwd_len TYPE i , "For finding the length of the Password,This is used when scrambling the password
         mi_handle  TYPE i. "Handle for Pointing to an already connected FTP connection,used for subsequent actions on the connected FTP session

  DATA : lv_path TYPE c LENGTH 80 VALUE 'LOGIBRICKS\E-INVOICING\RECEIVE'. "'E:\Power BI Credenca\SOURCE DATA'.
  DATA : lv_path_file TYPE c LENGTH 80 VALUE 'LOGIBRICKS\E-INVOICING\RESPONSE'."10022020113833.txt'. "'E:\Power BI Credenca\SOURCE DATA'.
  DATA : lv_fname TYPE c LENGTH 40 .

  CONCATENATE 'PRIMUS~E-INVOICING~' vbeln '.json' INTO lv_fname.


  DATA: lt_data TYPE STANDARD TABLE OF lts_result, "Final Internal table to be uploaded as a Text file on an FTP Server
        ls_data TYPE lts_result.


  TYPES : BEGIN OF lty_data,
            clientname    TYPE string,
            filename      TYPE string,
            status        TYPE string,
            message       TYPE string,
            docno         TYPE string,
            docdate       TYPE string,
            ackno         TYPE string,
            ackdt         TYPE string,
            irn           TYPE string,
            signedinvoice TYPE string,
          END OF lty_data.


  DATA : lt_result1 TYPE STANDARD TABLE OF lty_data,
         ls_result1 TYPE lty_data.


*  DATA : lt_passive TYPE STANDARD TABLE OF ty_ftp.


  SET EXTENDED CHECK OFF.
  mi_pwd_len = strlen( pa_pswrd ).



  CALL FUNCTION 'HTTP_SCRAMBLE'
    EXPORTING
      source      = pa_pswrd
      sourcelen   = mi_pwd_len
      key         = mi_key
    IMPORTING
      destination = pa_pswrd.

  CALL FUNCTION 'FTP_CONNECT'
    EXPORTING
      user            = pa_user
      password        = pa_pswrd
      host            = pa_host
      rfc_destination = pa_rfcds
    IMPORTING
      handle          = mi_handle
    EXCEPTIONS
      not_connected   = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FTP_COMMAND'
    EXPORTING
      handle        = mi_handle
      command       = 'set passive on'
    TABLES
      data          = lt_data "lt_passive
    EXCEPTIONS
      tcpip_error   = 1
      command_error = 2
      data_error    = 3
      OTHERS        = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  DELETE lt_data INDEX 1.
  DELETE lt_data INDEX 1.

  DATA: w_cmd(40) TYPE c.



  CONCATENATE 'cd' lv_path INTO w_cmd SEPARATED BY space.

  CALL FUNCTION 'FTP_COMMAND'
    EXPORTING
      handle        = mi_handle
      command       = w_cmd
      compress      = 'N'
    TABLES
      data          = lt_data
    EXCEPTIONS
      tcpip_error   = 1
      command_error = 2
      data_error    = 3
      OTHERS        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  REFRESH lt_data.
  CLEAR w_cmd.


  LOOP AT lt_jsonfile INTO ls_jsonfile .
    ls_data-line = ls_jsonfile-line.
    APPEND ls_data TO lt_data.
    CLEAR: ls_data.
  ENDLOOP.



  IF lt_data IS NOT INITIAL.
    CALL FUNCTION 'FTP_R3_TO_SERVER'
      EXPORTING
        handle         = mi_handle
        fname          = lv_fname
        character_mode = 'X'
      TABLES
*       BLOB           =
        text           = lt_data
      EXCEPTIONS
        tcpip_error    = 1
        command_error  = 2
        data_error     = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    CLEAR lv_fname.
    REFRESH lt_data.


  ELSE.

    MESSAGE 'JSON File Generation Failed Please Try Again' TYPE 'E'.

  ENDIF.



  CALL FUNCTION 'FTP_DISCONNECT'
    EXPORTING
      handle = mi_handle.



  CALL FUNCTION 'RFC_CONNECTION_CLOSE'
    EXPORTING
      destination          = 'SAPFTPA'
*     TASKNAME             =
    EXCEPTIONS
      destination_not_open = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  """"""""""""""""""end of code ftp send""""""""""""""""""""""""""""""""""""""""""""""'




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  IRN_USING_API
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM irn_using_api USING lvs_vbeln TYPE vbeln.
*****************************************E-Invoice API*************************************
  DATA : ls_str TYPE string.

  TYPES : BEGIN OF lty_response,
            line(2550) TYPE c,
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

  DATA : ls_vbeln TYPE vbeln.

  DATA : lv_resp_status TYPE string.
  DATA : ls_vbrk1 TYPE vbrk.
  DATA : lv_ackdt_s(10)  TYPE c,
         lv_ack_tm_s(08) TYPE c,
         lv_ack_dt       TYPE zzack_date1.
  DATA : ls_invrefnum TYPE j_1ig_invrefnum.
  DATA :lc_mode1       TYPE enqmode VALUE 'E',
        lc_invrefnum   TYPE tabname VALUE 'J_1IG_INVREFNUM',
        lc_eway_number TYPE tabname VALUE 'ZEWAY_NUMBER'.

*  **DOWNLOAD FILE
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = file_name "'C:/desktop/E-INVOICE.json'
    CHANGING
      data_tab = lt_jsonfile "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE 'E-INVOICE Downloaded in Json Format on C:/desktop/'
               TYPE 'I'.
  ENDIF.

  CLEAR :ls_str.
  LOOP AT lt_jsonfile INTO ls_jsonfile.
    CONCATENATE  ls_str ls_jsonfile-line  INTO ls_str.
  ENDLOOP.

  DATA : ls_xstring TYPE xstring.
  DATA : ls_output TYPE string.

  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      text   = ls_str
*     MIMETYPE       = ' '
*     ENCODING       =
    IMPORTING
      buffer = ls_xstring
    EXCEPTIONS
      failed = 1
      OTHERS = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
    EXPORTING
      input  = ls_xstring
    IMPORTING
      output = ls_output.

  CLEAR : ls_xstring.


  CONCATENATE '{"action": "GENERATEIRN", "data":' ls_str '}' INTO ls_str.
  REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
  CONCATENATE ls_str '}' INTO ls_str.
  REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN ls_str WITH ' '.
  CONDENSE ls_str.

  """"""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""
  BREAK primus.
  DATA :tokan TYPE string.

  CLEAR :tokan.

  READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
  tokan = ls_ein_tokan-value.
  CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

  DATA xconn TYPE string.
  CLEAR: xconn.
*  IF sy-mandt = 060 .
*    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AALFP1139Q003'.
*  ELSE.
    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.
*  ENDIF.

  DATA lv_url TYPE string.

*  IF sy-mandt = '060'.
*    lv_url = 'http://35.154.208.8:8080/einvoice/v1.00/invoice'.
*  ELSE.
    lv_url = 'https://gsthero.com/einvoice/v1.03/invoice'.
*  ENDIF.
  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url
    IMPORTING
      client             = DATA(lo_http_client)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).


  lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json'.


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = tokan ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Action'
      value = 'GENERATEIRN' ).
*  IF sy-mandt =  060.
*    lo_http_client->request->set_header_field(            "
*      EXPORTING
*        name  = 'gstin'
*        value = '05AALFP1139Q003' ).
*  ELSE.
    lo_http_client->request->set_header_field(            "
      EXPORTING
        name  = 'gstin'
        value = '27AACCD2898L1Z4' ).
*  ENDIF.
  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'X-Connector-Auth-Token'
      value = xconn ).


  lo_http_client->request->set_method(
    EXPORTING
      method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
    EXPORTING
      data = ls_str ).


  lo_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).


  CHECK sy-subrc = 0.
  DATA(lv_response) = lo_http_client->response->get_cdata( ).


  REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.
  BREAK primus.
  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 1000 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.

  READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
  IF sy-subrc EQ 0.
    lv_resp_status = ls_res-value.
    ls_vbeln = lvs_vbeln.

  ENDIF.

  IF lv_resp_status = '1'.      "'TRUE'.
    ls_zeinv_res-zzstatus = 'C'.
  ELSEIF lv_resp_status = '0'.       "'FALSE'.
    ls_zeinv_res-zzstatus = 'E'.
  ENDIF.

  SELECT SINGLE * FROM zeinv_res INTO ls_zeinv_res
    WHERE vbeln = ls_vbeln.

  IF sy-subrc EQ 0.

    IF lv_resp_status EQ '1'.
      LOOP AT lt_res INTO ls_res.

        CASE ls_res-header.
          WHEN 'AckNo'.
            ls_zeinv_res-zzack_no = ls_res-value.
            ls_invrefnum-ack_no = ls_res-value.
          WHEN 'AckDt'.
            SPLIT ls_res-value AT space INTO lv_ackdt_s lv_ack_tm_s.
            REPLACE ALL OCCURRENCES OF '-' IN lv_ackdt_s WITH space.
            CONDENSE lv_ackdt_s NO-GAPS.
            lv_ack_dt = lv_ackdt_s.
            ls_zeinv_res-zzack_date = lv_ack_dt.
            ls_invrefnum-ack_date = lv_ack_dt.
          WHEN 'Irn'.
            IF ls_zeinv_res-zzirn_no IS INITIAL.
              ls_zeinv_res-zzirn_no = ls_res-value.
              ls_invrefnum-irn = ls_res-value.
            ENDIF.
          WHEN 'SignedInvoice'.
            ls_zeinv_res-zzsign_inv = ls_res-value.
            ls_invrefnum-signed_inv = ls_res-value.
          WHEN 'SignedQRCode'.
            ls_zeinv_res-zzqr_code = ls_res-value.
            ls_invrefnum-signed_qrcode = ls_res-value.
          WHEN 'status'.
            ls_zeinv_res-zzerror_disc = 'E-INVOICE GENERATED SUCCESSFULLY!'.
            ls_invrefnum-irn_status = ls_res-value.
*                     WHEN 'EwbNo'.
*                          ls_zeinv_res-zzewaybill_no = ls_res-value.
*                          ls_zeway_number-eway_bill = ls_res-value.
*                          ls_zeway_number-mandt = SY-MANDT.
*                          ls_zeway_number-vbeln = lvs_vbeln.
*                          ls_zeway_number-zzstatus       = 'C'.
*                          ls_zeway_number-message        = 'Eway Bill Sucessfully Generated'.
*                     WHEN 'EwbDt'.
*                          SPLIT ls_res-value AT space INTO DATA(lv_Ewb_dt) DATA(lv_Ewb_tm).
*                          REPLACE ALL OCCURRENCES OF '-' IN lv_Ewb_dt WITH space.
*                          REPLACE ALL OCCURRENCES OF ':' IN lv_Ewb_tm WITH space.
*                          CONDENSE lv_Ewb_tm NO-GAPS.
*                          CONDENSE lv_Ewb_dt NO-GAPS.
*                          ls_zeinv_res-zzewaybill_date = lv_Ewb_dt.
*                          ls_zeinv_res-zzewaybill_time = lv_Ewb_tm.
*                          ls_zeway_number-ewaybilldate = lv_Ewb_dt.
*                          ls_zeway_number-vdfmtime = lv_Ewb_tm.
*                          CLEAR: lv_Ewb_dt,lv_Ewb_tm.
*                     WHEN 'EwbValidTill'.
*                          SPLIT ls_res-value AT space INTO lv_Ewb_dt lv_Ewb_tm.
*                          REPLACE ALL OCCURRENCES OF '-' IN lv_Ewb_dt WITH space.
*                           REPLACE ALL OCCURRENCES OF ':' IN lv_Ewb_tm WITH space.
*                          CONDENSE lv_Ewb_dt NO-GAPS.
*                          CONDENSE lv_Ewb_dt NO-GAPS.
*                          ls_zeinv_res-zzvalid_upto = lv_Ewb_dt.
*                          ls_zeinv_res-ZZVAILD_UPTO_TIME = lv_Ewb_dt.
*                          ls_zeway_number-validuptodate = lv_Ewb_dt.
*                          ls_zeway_number-vdtotime = lv_Ewb_tm.
*                          ls_zeway_number-createdby = sy-uname.
*                          ls_zeway_number-creationdt = sy-datum.
*                          ls_zeway_number-creationtime = sy-uzeit.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
      IF ls_zeinv_res IS NOT INITIAL.
        ls_zeinv_res-zzstatus = 'C'.
        MODIFY zeinv_res FROM ls_zeinv_res.
        IF lv_resp_status = '1'.
          PERFORM update_text_fields USING ls_zeinv_res.
        ENDIF.
      ENDIF.
      IF ls_invrefnum IS NOT INITIAL.

        SELECT SINGLE *
        FROM vbrk INTO ls_vbrk1
        WHERE vbeln = lvs_vbeln.

        ls_invrefnum-version       = '001'.
        ls_invrefnum-docno         = lvs_vbeln.
        ls_invrefnum-bukrs         = ls_vbrk1-bukrs.
        ls_invrefnum-doc_year      = ls_vbrk1-gjahr.
        ls_invrefnum-doc_type      = ls_vbrk1-fkart.
        ls_invrefnum-odn           = ls_vbrk1-xblnr.
        ls_invrefnum-bupla         = ls_vbrk1-bupla.
        ls_invrefnum-odn_date      = ls_vbrk1-fkdat.
        ls_invrefnum-ernam         = ls_vbrk1-ernam.
        ls_invrefnum-erdat         = ls_vbrk1-erdat.
        ls_invrefnum-erzet         = ls_vbrk1-erzet.
        ls_invrefnum-irn_status    = 'ACT'.

        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = lc_mode1
            tabname        = lc_invrefnum
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.

        IF sy-subrc EQ 0.
          TEST-SEAM non_exe.
            MODIFY j_1ig_invrefnum FROM ls_invrefnum.
            IF sy-subrc EQ 0.
              COMMIT WORK.
            ENDIF.
          END-TEST-SEAM.

          CALL FUNCTION 'DEQUEUE_E_TABLE'
            EXPORTING
              mode_rstable = lc_mode1
              tabname      = lc_invrefnum.
        ENDIF.
      ENDIF.
*               IF LS_ZEWAY_NUMBER IS NOT INITIAL.
*
*                    CALL FUNCTION 'ENQUEUE_E_TABLE'
*                    EXPORTING
*                      mode_rstable   = lc_mode1
*                      tabname        = lc_EWAY_NUMBER
*                    EXCEPTIONS
*                      foreign_lock   = 1
*                      system_failure = 2
*                   OTHERS         = 3.
*                    IF sy-subrc EQ 0.
*                            TEST-SEAM non_exe_1.
*                            MODIFY ZEWAY_NUMBER FROM ls_zeway_number.
*                            IF sy-subrc EQ 0.
*                               COMMIT WORK.
*                            ENDIF.
*                            END-TEST-SEAM.
*
*                             CALL FUNCTION 'DEQUEUE_E_TABLE'
*                             EXPORTING
*                               mode_rstable = lc_mode1
*                               tabname      = lc_EWAY_NUMBER.
*                  ENDIF.
*               ENDIF.

    ELSEIF lv_resp_status EQ '0'.
      LOOP AT lt_res INTO ls_res.


        IF ls_res-header = 'errorMsg'.
          ls_zeinv_res-zzerror_disc = ls_res-value.
        ENDIF.
*                  CASE ls_res-header.
*                     WHEN 'errorMsg'.
*                          CONCATENATE LS_RES-value ',' INTO dATA(LV_TXT).
*                          ls_zeinv_res-zzerror_disc = LV_TXT.
*
*                     WHEN OTHERS.
*                 ENDCASE.
      ENDLOOP.
      ls_zeinv_res-zzstatus = 'E'.
      ls_zeinv_res-vbeln = lvs_vbeln.
      IF ls_zeinv_res IS NOT INITIAL.
        MODIFY zeinv_res FROM ls_zeinv_res.
        COMMIT WORK.
      ENDIF.
    ENDIF.
  ELSE.
    SELECT SINGLE * FROM zeinv_res INTO ls_zeinv_res
    WHERE vbeln = lvs_vbeln.
    IF sy-subrc EQ 0.
      ls_zeinv_res-vbeln = lvs_vbeln.
      ls_zeinv_res-zzstatus = 'E'.
      ls_zeinv_res-zzerror_disc = lv_response.
      IF ls_zeinv_res IS NOT INITIAL.
        MODIFY zeinv_res FROM ls_zeinv_res.
        COMMIT WORK.
      ENDIF.
      EXIT.
    ENDIF.
  ENDIF.
  CLEAR: lt_res,ls_res,ls_zeinv_res,lvs_vbeln,lv_resp_status,ls_vbeln,ls_invrefnum,ls_vbrk1.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_TEXT_FIELDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ZEINV_RES  text
*----------------------------------------------------------------------*
FORM update_text_fields  USING    p_ls_zeinv_res TYPE zeinv_res.


  DATA : qr_id   TYPE thead-tdid VALUE 'ZSQR',
         irn_id  TYPE thead-tdid VALUE 'ZIRN',
         ack_id  TYPE thead-tdid VALUE 'ZACK',
         env_id  TYPE thead-tdid VALUE 'ZSIC',
         flang   TYPE thead-tdspras VALUE 'E',
         fname   TYPE thead-tdname,
         fobject TYPE thead-tdobject VALUE 'VBBK',
         fline   TYPE tline,
         flines  TYPE TABLE OF tline.



  fname = p_ls_zeinv_res-vbeln. "<lfs_final>-vbeln.


  fline-tdline = p_ls_zeinv_res-zzqr_code.
  APPEND fline TO flines.
  CLEAR : fline.

  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      fid         = qr_id   "QR Code
      flanguage   = flang
      fname       = fname
      fobject     = fobject
      save_direct = 'X'
      fformat     = '*'
    TABLES
      flines      = flines
    EXCEPTIONS
      no_init     = 1
      no_save     = 2
      OTHERS      = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here

  ENDIF.

  CLEAR : flines.


  "--Updating IRN Number in VF02

  fline-tdline = p_ls_zeinv_res-zzirn_no.
  APPEND fline TO flines.
  CLEAR : fline.

  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      fid         = irn_id   "IRN Number
      flanguage   = flang
      fname       = fname
      fobject     = fobject
      save_direct = 'X'
      fformat     = '*'
    TABLES
      flines      = flines
    EXCEPTIONS
      no_init     = 1
      no_save     = 2
      OTHERS      = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR : flines.



  "--Updating Ack Number in VF02--------

*        CONCATENATE <lfs_final>-zzack_date+6(2) '/' <lfs_final>-zzack_date+4(2) '/' <lfs_final>-zzack_date(4) INTO DATA(lv_date).
*        CONCATENATE <lfs_final>-zzack_no lv_date INTO DATA(ls_ack) SEPARATED BY space.

  fline-tdline = p_ls_zeinv_res-zzack_no.
  APPEND fline TO flines.
  CLEAR : fline."ls_ack.

  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      fid         = ack_id   "Ack Number
      flanguage   = flang
      fname       = fname
      fobject     = fobject
      save_direct = 'X'
      fformat     = '*'
    TABLES
      flines      = flines
    EXCEPTIONS
      no_init     = 1
      no_save     = 2
      OTHERS      = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR : flines.


  "--Updating Signed Invoice Number in VF02--------



  fline-tdline =  p_ls_zeinv_res-zzsign_inv.
  APPEND fline TO flines.
  CLEAR : fline.

  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      fid         = env_id   "Signed Invoice
      flanguage   = flang
      fname       = fname
      fobject     = fobject
      save_direct = 'X'
      fformat     = '*'
    TABLES
      flines      = flines
    EXCEPTIONS
      no_init     = 1
      no_save     = 2
      OTHERS      = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR : flines.

  "----End of Text field update---------




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  IRN_USING_RFC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM irn_using_rfc USING p_vbeln TYPE vbeln ls_data TYPE string gstin TYPE stcd3 .

  TYPES :
    BEGIN OF ty_str,
      doc_no   TYPE vbrk-vbeln,
      bukrs    TYPE vbrk-bukrs,
      doc_year TYPE vbrk-gjahr,
      doc_type TYPE vbrk-fkart,
      odn      TYPE vbrk-xblnr,
      bupla    TYPE vbrk-bupla,
      odn_date TYPE vbrk-fkdat,
      ernam    TYPE vbrk-ernam,
      erdat    TYPE vbrk-erdat,
      erzet    TYPE vbrk-erzet,
    END OF ty_str.

  DATA :
    ls_vbrk             TYPE ty_str,
    ls_str              TYPE j_1ig_invrefnum,
    ls_ewaybill         TYPE j_1ig_ewaybill,
    ls_zeinv_res        TYPE zeinv_res,
    ls_zeinv_res_fb70   TYPE zeinv_res_fb70,
    lv_fy(4)            TYPE c,
    lv_date             TYPE datum,
    lv_response_msg     TYPE string,
    lv_ack_date_s(10)   TYPE c,
    lv_ack_time_s(08)   TYPE c,
    lv_eway_date_s(10)  TYPE c,
    lv_eway_time_s(08)  TYPE c,
    lv_valid_date_s(10) TYPE c,
    lv_valid_time_s(08) TYPE c,
    lv_eway_date        TYPE j_1ig_egendat,
    lv_eway_time        TYPE j_1ig_vdfmtime,
    lv_valid_date       TYPE j_1ig_vdtodate,
    lv_valid_time       TYPE j_1ig_vdtotime,
    lv_ack_date         TYPE zzack_date1.



  CONSTANTS:
    lc_mode            TYPE enqmode VALUE 'E',
    lc_j_1ig_invrefnum TYPE tabname VALUE 'J_1IG_INVREFNUM',
    lc_j_1ig_ewaybill  TYPE tabname VALUE 'J_1IG_EWAYBILL',
    lc_zeinv_res       TYPE tabname VALUE 'ZEINV_RES',
    lc_zeinv_res_fb70  TYPE tabname VALUE 'ZEINV_RES_FB70',
    lc_periv           TYPE periv VALUE 'V3'.


  "==================RECIEVED DATA FROM .NET APPLICATION==========================================
  DATA : ack_no TYPE j_1ig_invrefnum-ack_no.
  DATA : ack_date TYPE j_1ig_ack_date.
  DATA : irn TYPE j_1ig_invrefnum-irn.
  DATA : signed_inv TYPE j_1ig_invrefnum-signed_inv.
  DATA : signed_qrcode TYPE j_1ig_invrefnum-signed_qrcode.
  DATA : irn_status TYPE j_1ig_invrefnum-irn_status.
  DATA : ewaybill_no TYPE string.
  DATA : ewaybill_date TYPE string.
  DATA : valid_upto TYPE string.
  "===============================================================================================


  IF ls_data IS NOT INITIAL.   "--Check jsonfile data exists or not

    "===============================================================================================
    "FM TO CONNECT WITH .NET APPLICATION
    "===============================================================================================

    CALL FUNCTION 'ZEINV_SEND_DATA'   "--Call Remote Enabled Function Module to Connect with .NET Application
      DESTINATION 'PSERVER' "--SM59 TCP/IP Destination
      EXPORTING
        ls_data         = ls_data
        gstin           = gstin
      IMPORTING
        ack_no          = ack_no
        ack_date        = ack_date
        irn             = irn
        signed_inv      = signed_inv
        signed_qrcode   = signed_qrcode
        irn_status      = irn_status
        ewaybill_no     = ewaybill_no
        ewaybill_date   = ewaybill_date
        valid_upto      = valid_upto
      EXCEPTIONS
        raise_exception = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    CLEAR : ls_data ,gstin .

    "===============================================================================================
    "===============================================================================================

    "--update tables
    IF irn_status = 'ACT' AND sy-subrc EQ 0.       "--'ACT' Status = IRN Generated.

      "=============ZEINV_RES Table data Populate=============================
      ls_zeinv_res-mandt  = sy-mandt.
      ls_zeinv_res-vbeln = ls_final-vbeln.
      ls_zeinv_res-fkdat = ls_final-fkdat.
      ls_zeinv_res-xblnr = ls_final-xblnr.
      ls_zeinv_res-zzuser = sy-uname.
      ls_zeinv_res-zzcdate = sy-datum.
      ls_zeinv_res-zztime = sy-uzeit.
      ls_zeinv_res-werks = ls_final-werks.
      ls_zeinv_res-zzack_no = ack_no.
      ls_zeinv_res-zzdoc_type = 'INV'.
      ls_zeinv_res-zzirn_no = irn.
      ls_zeinv_res-zzsign_inv = signed_inv.
      ls_zeinv_res-zzqr_code = signed_qrcode.
      ls_zeinv_res-zzewaybill_no     = ewaybill_no.
      ls_zeinv_res-zzstatus = 'C'.        "Completely Processed
      ls_zeinv_res-zzerror_disc = 'E-Invoice Generated Successfully!'.

      IF ack_no IS NOT INITIAL.
        SPLIT ack_date AT space INTO lv_ack_date_s lv_ack_time_s.
        REPLACE ALL OCCURRENCES OF '-' IN lv_ack_date_s WITH space.
        CONDENSE lv_ack_date_s NO-GAPS.
        lv_ack_date = lv_ack_date_s.
        ls_zeinv_res-zzack_date = lv_ack_date.
      ENDIF.


      IF ewaybill_no IS NOT INITIAL.
        SPLIT ewaybill_date AT space INTO lv_eway_date_s lv_eway_time_s.
        REPLACE ALL OCCURRENCES OF '-' IN lv_eway_date_s WITH space.
        REPLACE ALL OCCURRENCES OF ':' IN lv_eway_time_s WITH space.
        CONDENSE lv_eway_date_s NO-GAPS.
        CONDENSE lv_eway_time_s NO-GAPS.
        lv_eway_date = lv_eway_date_s.
        lv_eway_time = lv_eway_time_s.
        SPLIT valid_upto AT space INTO lv_valid_date_s lv_valid_time_s.
        REPLACE ALL OCCURRENCES OF '-' IN lv_valid_date_s WITH space.
        REPLACE ALL OCCURRENCES OF ':' IN lv_valid_time_s WITH space.
        CONDENSE lv_valid_date_s NO-GAPS.
        CONDENSE lv_valid_time_s NO-GAPS.
        lv_valid_date = lv_valid_date_s.
        lv_valid_time = lv_valid_time_s.
      ENDIF.

      ls_zeinv_res-zzewaybill_date   = lv_eway_date.
      ls_zeinv_res-zzewaybill_time   = lv_eway_time.
      ls_zeinv_res-zzvalid_upto      = lv_valid_date.
      ls_zeinv_res-zzvaild_upto_time = lv_valid_time.



      "=========================================================================

      "=========J_1IG_INVREFNUM Table data Populate=============================

      ls_str-docno         =  p_vbeln.

      SELECT SINGLE vbeln bukrs gjahr fkart xblnr bupla fkdat ernam erdat erzet
        FROM vbrk INTO ls_vbrk
        WHERE vbeln = ls_str-docno.

      ls_str-bukrs         = ls_vbrk-bukrs.
      ls_str-doc_year      = ls_vbrk-doc_year.
      ls_str-doc_type      = ls_vbrk-doc_type.
      ls_str-odn           = ls_vbrk-odn.
      ls_str-bupla         = ls_vbrk-bupla.
      ls_str-odn_date      = ls_vbrk-odn_date.
      ls_str-ernam         = ls_vbrk-ernam.
      ls_str-erdat         = ls_vbrk-erdat.
      ls_str-erzet         = ls_vbrk-erzet.
      ls_str-ack_no        =  ack_no.
      ls_str-ack_date      =  ack_date.
      ls_str-irn           =  irn.
      ls_str-signed_inv    =  signed_inv.
      ls_str-signed_qrcode =  signed_qrcode.
      ls_str-irn_status    =  irn_status.


      IF ls_str-doc_year IS INITIAL.
        CALL FUNCTION 'GM_GET_FISCAL_YEAR' "--FM to get Current Fiscal Year
          EXPORTING
            i_date                     = ls_vbrk-odn_date
            i_fyv                      = lc_periv
          IMPORTING
            e_fy                       = lv_fy
          EXCEPTIONS
            fiscal_year_does_not_exist = 1
            not_defined_for_date       = 2
            OTHERS                     = 3.
        IF sy-subrc IS INITIAL.
          ls_str-doc_year = lv_fy.
        ENDIF.
      ENDIF.

      IF ewaybill_no IS NOT INITIAL.        "--update J_1IG_EWAYBILL table if ewaybill number is not initial
        ls_ewaybill-bukrs = ls_vbrk-bukrs.
        ls_ewaybill-doctyp = ls_vbrk-doc_type.
        ls_ewaybill-docno = p_vbeln.
        ls_ewaybill-gjahr = lv_fy.
        ls_ewaybill-ebillno = ewaybill_no.
        ls_ewaybill-egen_dat = lv_eway_date.
        ls_ewaybill-egen_time = lv_eway_time.
        ls_ewaybill-vdfmdate = lv_eway_date.
        ls_ewaybill-vdfmtime = lv_eway_time.
        ls_ewaybill-vdtodate = lv_valid_date.
        ls_ewaybill-vdtotime = lv_valid_time.
        ls_ewaybill-status = 'A'.
        ls_ewaybill-ernam = sy-uname.
        ls_ewaybill-erdat = sy-datum.
*     ls_ewaybill-aenam = sy-uname.
*     ls_ewaybill-aedat = sy-datum.
      ENDIF.




      "====================Update J_1IG_INVREFNUM  J_1IG_EWAYBILL and ZEINV_RES tables=========================

*    *---Lock the table
      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          mode_rstable   = lc_mode
          tabname        = lc_zeinv_res
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.

      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          mode_rstable   = lc_mode
          tabname        = lc_j_1ig_invrefnum
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.

      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          mode_rstable   = lc_mode
          tabname        = lc_j_1ig_ewaybill
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.


      IF sy-subrc EQ 0.
*        TEST-SEAM non_exe.
        MODIFY zeinv_res FROM ls_zeinv_res .
        MODIFY j_1ig_invrefnum FROM ls_str.
        MODIFY j_1ig_ewaybill FROM ls_ewaybill.

        IF sy-subrc EQ 0.
          COMMIT WORK.
        ENDIF.
*        END-TEST-SEAM.


*---Unlock the table
        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_mode
            tabname      = lc_zeinv_res.

        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_mode
            tabname      = lc_j_1ig_invrefnum.

        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_mode
            tabname      = lc_j_1ig_ewaybill.

      ENDIF.

      CLEAR: ls_str,lv_date ,ls_ewaybill.
      CLEAR : lv_eway_date,lv_eway_time,lv_valid_date,lv_valid_time,lv_ack_date,
              lv_eway_date_s,lv_eway_time_s,lv_valid_date_s,lv_valid_time_s,lv_ack_date_s.


      "--Error during IRN Generation

    ELSEIF ack_no IS INITIAL AND irn_status IS INITIAL AND sy-subrc NE 0 AND sy-msgv1 IS NOT INITIAL.

      ls_zeinv_res-mandt      = sy-mandt.
      ls_zeinv_res-vbeln      = ls_final-vbeln.
      ls_zeinv_res-fkdat      = ls_final-fkdat.
      ls_zeinv_res-xblnr      = ls_final-xblnr.
      ls_zeinv_res-werks      = ls_final-werks.
      ls_zeinv_res-zzack_no   = ack_no.
      ls_zeinv_res-zzdoc_type = 'INV'.
      ls_zeinv_res-zzack_date = ack_date.
      ls_zeinv_res-zzirn_no   = irn.
      ls_zeinv_res-zzsign_inv = signed_inv.
      ls_zeinv_res-zzqr_code  = signed_qrcode.
      ls_zeinv_res-zzstatus   = 'E'.        "Error
      CONCATENATE sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_response_msg.
      ls_zeinv_res-zzerror_disc = lv_response_msg.

      "--Lock the Table
      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          mode_rstable   = lc_mode
          tabname        = lc_zeinv_res
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.


      IF sy-subrc EQ 0.
        TEST-SEAM non_exe1.
          MODIFY zeinv_res FROM ls_zeinv_res .
*         MODIFY j_1ig_invrefnum FROM ls_str.
          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.
        END-TEST-SEAM.

*---Unlock the table
        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_mode
            tabname      = lc_zeinv_res.
      ENDIF.

    ELSE.  "--Unknown error display
      MESSAGE 'PrimEBridge Application is not running' TYPE 'E'.
    ENDIF.

    CLEAR : lv_response_msg.


    DATA : qr_id   TYPE thead-tdid VALUE 'ZSQR',
           irn_id  TYPE thead-tdid VALUE 'ZIRN',
           ack_id  TYPE thead-tdid VALUE 'ZACK',
           env_id  TYPE thead-tdid VALUE 'ZSIC',
           flang   TYPE thead-tdspras VALUE 'E',
           fname   TYPE thead-tdname,
           fobject TYPE thead-tdobject VALUE 'VBBK',
           fline   TYPE tline,
           flines  TYPE TABLE OF tline.


    SELECT SINGLE  * FROM  j_1ig_invrefnum INTO @DATA(ls_j_1ig_invrefnum)
      WHERE docno = @ls_zeinv_res-vbeln.


    IF ls_j_1ig_invrefnum IS NOT INITIAL.

      fname = ls_j_1ig_invrefnum-docno. "<lfs_final>-vbeln.


      fline-tdline = ls_j_1ig_invrefnum-signed_qrcode.
      APPEND fline TO flines.
      CLEAR : fline.

      CALL FUNCTION 'CREATE_TEXT'
        EXPORTING
          fid         = qr_id   "QR Code
          flanguage   = flang
          fname       = fname
          fobject     = fobject
          save_direct = 'X'
          fformat     = '*'
        TABLES
          flines      = flines
        EXCEPTIONS
          no_init     = 1
          no_save     = 2
          OTHERS      = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here

      ENDIF.

      CLEAR : flines.


      "--Updating IRN Number in VF02

      fline-tdline = ls_j_1ig_invrefnum-irn.
      APPEND fline TO flines.
      CLEAR : fline.

      CALL FUNCTION 'CREATE_TEXT'
        EXPORTING
          fid         = irn_id   "IRN Number
          flanguage   = flang
          fname       = fname
          fobject     = fobject
          save_direct = 'X'
          fformat     = '*'
        TABLES
          flines      = flines
        EXCEPTIONS
          no_init     = 1
          no_save     = 2
          OTHERS      = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR : flines.



      "--Updating Ack Number in VF02--------

*        CONCATENATE <lfs_final>-zzack_date+6(2) '/' <lfs_final>-zzack_date+4(2) '/' <lfs_final>-zzack_date(4) INTO DATA(lv_date).
*        CONCATENATE <lfs_final>-zzack_no lv_date INTO DATA(ls_ack) SEPARATED BY space.

      fline-tdline = ls_j_1ig_invrefnum-ack_date.
      APPEND fline TO flines.
      CLEAR : fline."ls_ack.

      CALL FUNCTION 'CREATE_TEXT'
        EXPORTING
          fid         = ack_id   "Ack Number
          flanguage   = flang
          fname       = fname
          fobject     = fobject
          save_direct = 'X'
          fformat     = '*'
        TABLES
          flines      = flines
        EXCEPTIONS
          no_init     = 1
          no_save     = 2
          OTHERS      = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR : flines.


      "--Updating Signed Invoice Number in VF02--------



      fline-tdline =  ls_j_1ig_invrefnum-signed_inv.
      APPEND fline TO flines.
      CLEAR : fline.

      CALL FUNCTION 'CREATE_TEXT'
        EXPORTING
          fid         = env_id   "Signed Invoice
          flanguage   = flang
          fname       = fname
          fobject     = fobject
          save_direct = 'X'
          fformat     = '*'
        TABLES
          flines      = flines
        EXCEPTIONS
          no_init     = 1
          no_save     = 2
          OTHERS      = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR : flines.

      "----End of Text field update---------
    ENDIF.
    CLEAR : ls_zeinv_res.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  IRN_CAN_USING_API
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM irn_can_using_api USING lvs_vbeln TYPE vbeln.


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


*DATA : ls_vbeln TYPE vbeln.

*  DATA : lv_resp_status TYPE string.
  DATA : ls_vbrk1 TYPE vbrk.
  DATA : lv_ackdt_s(10)  TYPE c,
         lv_ack_tm_s(08) TYPE c,
         lv_ack_dt       TYPE zzack_date1.
  DATA : ls_invrefnum TYPE j_1ig_invrefnum.
  DATA :lc_mode1       TYPE enqmode VALUE 'E',
        lc_invrefnum   TYPE tabname VALUE 'J_1IG_INVREFNUM',
        lc_zeinv_res   TYPE tabname VALUE 'ZEINV_RES',
        lc_eway_number TYPE tabname VALUE 'ZEWAY_NUMBER'.

*  **DOWNLOAD FILE
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = file_name "'C:/desktop/E-INVOICE.json'
    CHANGING
      data_tab = lt_jsonfile "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE 'E-INVOICE Downloaded in Json Format on C:/desktop/'
               TYPE 'I'.
  ENDIF.

  CLEAR :ls_str.
  LOOP AT lt_jsonfile INTO ls_jsonfile.
    CONCATENATE  ls_str ls_jsonfile-line  INTO ls_str.
  ENDLOOP.

  CONCATENATE '{"action": "CANCELIRN", "data":' ls_str '}' INTO ls_str.
  REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
  CONCATENATE ls_str '}' INTO ls_str.
  CONDENSE ls_str.
  """"""""""""""""""""""""""""""""""""""""""""""' API  CODE """"""""""""""""""""""""""""""
  BREAK primus.
  DATA :tokan TYPE string.

  CLEAR :tokan.

  READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
  tokan = ls_ein_tokan-value.
  CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

  DATA xconn TYPE string.
  CLEAR: xconn.

*  IF sy-mandt = 060.
*    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AALFP1139Q003'.
*  ELSE.
    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.
*  ENDIF.
  DATA lv_url TYPE string.
*  IF sy-mandt = '060'.
*    lv_url = 'https://35.154.208.8/einvoice/v1.03/invoice/cancel'.
*  ELSE.
    lv_url = 'http://gsthero.com/einvoice/v1.03/invoice/cancel'.
*  ENDIF.
  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url   "'http://logibrickseway.azurewebsites.net/TransactionAPI/CancelEInvoice' "'lv_url
    IMPORTING
      client             = DATA(lo_http_client)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).

  lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).



  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json'.


  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = tokan ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Action'
      value = 'CANCELIRN' ).

*  IF sy-mandt = 060.
*    lo_http_client->request->set_header_field(            "
*      EXPORTING
*        name  = 'gstin'
*        value = '05AALFP1139Q003' ).
*  ELSE.
    lo_http_client->request->set_header_field(            "
      EXPORTING
        name  = 'gstin'
        value = '27AACCD2898L1Z4' ).
*  ENDIF.

  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'X-Connector-Auth-Token'
      value = xconn ).

  lo_http_client->request->set_method(
    EXPORTING
      method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
    EXPORTING
      data = ls_str ).


  lo_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).

  BREAK primus.
  CHECK sy-subrc = 0.
  DATA(lv_response) = lo_http_client->response->get_cdata( ).

*    BREAK abap01.

  REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '"data":' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.


  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 20 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.


  BREAK primus.
  READ TABLE lt_res INTO ls_res WITH KEY header = 'status'.                "INDEX 5.
  IF sy-subrc EQ 0.
    lv_resp_status = ls_res-value.
    ls_vbeln = lvs_vbeln.

  ENDIF.


  "---update data in z table-------------------------------

  SELECT SINGLE * FROM zeinv_res INTO ls_zeinv_res
    WHERE vbeln = lvs_vbeln.  "            vbeln = ls_vbeln.

  IF sy-subrc EQ 0.


    IF lv_resp_status EQ '1'.                        "IRN CANCELLATION
      LOOP AT lt_res INTO ls_res.
        CASE ls_res-header.
          WHEN 'Irn'.
            IF ls_zeinv_res-zzirn_no IS INITIAL.
              ls_zeinv_res-zzirn_no = ls_res-value.
              ls_invrefnum-irn = ls_res-value.
            ENDIF.
          WHEN 'CancelDate'.
            SPLIT ls_res-value AT space INTO lv_ackdt_s lv_ack_tm_s.
            REPLACE ALL OCCURRENCES OF '-' IN lv_ackdt_s WITH space.
            CONDENSE lv_ackdt_s NO-GAPS.
            lv_ack_dt = lv_ackdt_s.
            ls_zeinv_res-zzcan_date = lv_ack_dt.
            ls_invrefnum-cancel_date = lv_ack_dt.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.


      IF ls_zeinv_res IS NOT INITIAL.
        ls_invrefnum-irn = ls_zeinv_res-zzirn_no.
        ls_invrefnum-ack_no = ls_zeinv_res-zzack_no.
        ls_invrefnum-ack_date = ls_zeinv_res-zzack_date.
        ls_invrefnum-signed_inv = ls_zeinv_res-zzsign_inv.
        ls_invrefnum-signed_qrcode = ls_zeinv_res-zzqr_code.
        ls_zeinv_res-zzerror_disc = 'E-Invoice Cancelled Successfully!'.
        ls_zeinv_res-zzstatus = 'S'.

        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = lc_mode1
            tabname        = lc_zeinv_res
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.

        IF sy-subrc EQ 0.
          TEST-SEAM non_exe3.
            MODIFY zeinv_res FROM ls_zeinv_res.
            IF sy-subrc EQ 0.
              COMMIT WORK.
            ENDIF.
          END-TEST-SEAM.

          CALL FUNCTION 'DEQUEUE_E_TABLE'
            EXPORTING
              mode_rstable = lc_mode1
              tabname      = lc_zeinv_res.
        ENDIF.
        IF lv_resp_status = '1'.
          PERFORM update_text_fields USING ls_zeinv_res.
        ENDIF.
      ENDIF.
      IF ls_invrefnum IS NOT INITIAL.
        SELECT SINGLE *
        FROM vbrk INTO ls_vbrk1
        WHERE vbeln = lvs_vbeln.

        ls_invrefnum-version       = '002'.
        ls_invrefnum-docno         = lvs_vbeln.
        ls_invrefnum-bukrs         = ls_vbrk1-bukrs.
        ls_invrefnum-doc_year      = ls_vbrk1-gjahr.
        ls_invrefnum-doc_type      = ls_vbrk1-fkart.
        ls_invrefnum-odn           = ls_vbrk1-xblnr.
        ls_invrefnum-bupla         = ls_vbrk1-bupla.
        ls_invrefnum-odn_date      = ls_vbrk1-fkdat.
        ls_invrefnum-ernam         = ls_vbrk1-ernam.
        ls_invrefnum-erdat         = ls_vbrk1-erdat.
        ls_invrefnum-erzet         = ls_vbrk1-erzet.
        ls_invrefnum-irn_status    = 'CNL'.

        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = lc_mode1
            tabname        = lc_invrefnum
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.

        IF sy-subrc EQ 0.
*                      TEST-SEAM non_exe1.
          MODIFY j_1ig_invrefnum FROM ls_invrefnum.
          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.
*                      END-TEST-SEAM.

          CALL FUNCTION 'DEQUEUE_E_TABLE'
            EXPORTING
              mode_rstable = lc_mode1
              tabname      = lc_invrefnum.
        ENDIF.

      ENDIF.

    ELSEIF lv_resp_status EQ '0'.
      LOOP AT lt_res INTO ls_res.
        IF ls_res-header = 'errorMsg'.
          ls_zeinv_res-zzerror_disc = ls_res-value.
        ENDIF.
      ENDLOOP.
      ls_zeinv_res-zzstatus = 'E'.
      ls_zeinv_res-vbeln = lvs_vbeln.
      IF ls_zeinv_res IS NOT INITIAL.
        MODIFY zeinv_res FROM ls_zeinv_res.
        COMMIT WORK.
      ENDIF.
    ENDIF.
  ELSE.

    MESSAGE 'ERROR GENERATING IRN THROUGH API' TYPE 'E'.
    EXIT.
  ENDIF.
  CLEAR: lt_res,ls_res,ls_zeinv_res,lvs_vbeln.





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CANCEL_IRN_USING_RFC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_FINAL_VBELN  text
*      -->P_LVS_DATA  text
*      -->P_GSTIN  text
*----------------------------------------------------------------------*
FORM cancel_irn_using_rfc  USING    p_vbeln TYPE vbeln
                                    ls_data TYPE string
                                    p_gstin TYPE stcd3
                                    lv_ucomm TYPE sy-ucomm.
  TYPES : BEGIN OF lty_vbrk,
            vbeln TYPE vbrk-vbeln,
            bukrs TYPE vbrk-bukrs,
            gjahr TYPE vbrk-gjahr,
            fkart TYPE vbrk-fkart,
            xblnr TYPE vbrk-xblnr,
            bupla TYPE vbrk-bupla,
            fkdat TYPE vbrk-fkdat,
            ernam TYPE vbrk-ernam,
            erdat TYPE vbrk-erdat,
            erzet TYPE vbrk-erzet,
          END OF lty_vbrk.



  DATA :
    ls_vbrk           TYPE lty_vbrk,
    ls_str            TYPE j_1ig_invrefnum,
    ls_zeinv_res      TYPE zeinv_res,
    ls_zeinv_res_fb70 TYPE zeinv_res_fb70,
    lv_fy(4)          TYPE c,
    lv_date           TYPE datum,
    lv_err_msg        TYPE string,
    lv_can_date       TYPE j_1ig_canc_date,
    lv_can_time       TYPE j_1ig_vdfmtime,
    lv_can_date_s(10) TYPE c,
    lv_can_time_s(08) TYPE c.

  CONSTANTS:
    lc_mode            TYPE enqmode VALUE 'E',
    lc_j_1ig_invrefnum TYPE tabname VALUE 'J_1IG_INVREFNUM',
    lc_zeinv_res       TYPE tabname VALUE 'ZEINV_RES',
    lc_zeinv_res_fb70  TYPE tabname VALUE 'ZEINV_RES_FB70',
    lc_periv           TYPE periv VALUE 'V3'.


  "==================RECIEVED DATA FROM .NET APPLICATION==========================================
  DATA : can_date    TYPE j_1ig_invrefnum-cancel_date.
  DATA : ewaybill_no TYPE j_1ig_ewaybill-ebillno.
  DATA : irn         TYPE j_1ig_invrefnum-irn.
  "===============================================================================================


  IF ls_data IS NOT INITIAL.   "--Check jsonfile data exists or not

    "===============================================================================================
    "FM TO CONNECT WITH .NET APPLICATION
    "===============================================================================================

    IF lv_ucomm = '&CAN'.
      CALL FUNCTION 'ZCANCEL_INR' "--Call Remote Enabled Function Module to Connect with .NET Application
        DESTINATION 'PSERVER' "--"--SM59 TCP/IP Destination
        EXPORTING
          ls_data         = ls_data
          gstin           = p_gstin
        IMPORTING
          ack_date        = can_date
          irn             = irn
        EXCEPTIONS
          raise_exception = 1
          OTHERS          = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

    ELSEIF lv_ucomm = '&CANEWAY'.

      CALL FUNCTION 'ZCANCEL_EWAY_BILL' "--Call Remote Enabled Function Module to Connect with .NET Application
        DESTINATION 'PSERVER' "--"--SM59 TCP/IP Destination
        EXPORTING
          ls_data         = ls_data
          gstin           = p_gstin
        IMPORTING
          cancel_date     = can_date
          eway_bill_no    = ewaybill_no
        EXCEPTIONS
          raise_exception = 1
          OTHERS          = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.

    CLEAR :  ls_data , p_gstin.

    "===============================================================================================
    "===============================================================================================


    "--update tables
    IF  sy-subrc EQ 0.       "--'ACT' Status = IRN Generated. "irn_status = 'ACT' AND

      IF lv_ucomm = '&CAN'.

        SELECT SINGLE vbeln bukrs gjahr fkart xblnr bupla fkdat ernam erdat erzet
          FROM vbrk INTO ls_vbrk
          WHERE vbeln = p_vbeln.

        IF can_date IS NOT INITIAL.
          SPLIT can_date AT space INTO lv_can_date_s lv_can_time_s.
          REPLACE ALL OCCURRENCES OF '-' IN lv_can_date_s WITH space.
          REPLACE ALL OCCURRENCES OF ':' IN lv_can_time_s WITH space.
          CONDENSE lv_can_date_s NO-GAPS.
          CONDENSE lv_can_time_s NO-GAPS.
          lv_can_date = lv_can_date_s.
          lv_can_time = lv_can_time_s.
        ENDIF.

        "====================Update J_1IG_INVREFNUM and ZEINV_RES tables=========================

*    *---Lock the table
        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = lc_mode
            tabname        = lc_zeinv_res
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.

        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = lc_mode
            tabname        = lc_j_1ig_invrefnum
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.

        IF sy-subrc EQ 0.
          TEST-SEAM non_exe2.
            "----update table ZEINV_RES------------------------

            UPDATE zeinv_res
            SET
            zzcan_date = lv_can_date
*          zzirn_no = irn
            zzstatus = 'S'        "IRN Cancelled
            zzerror_disc = 'E-Invoice Successfully Cancelled'
            WHERE vbeln = ls_final-vbeln AND  xblnr = ls_final-xblnr.
            "----------------------------------------------------

            "----update table j_1ig_invrefnum------------------------
            UPDATE j_1ig_invrefnum
            SET
            cancel_date   = can_date
            irn           =  irn
            irn_status    =  'CAN'
            WHERE bukrs = ls_vbrk-bukrs  AND docno = p_vbeln AND doc_year = ls_vbrk-gjahr AND doc_type = ls_vbrk-fkdat AND
                  odn   = ls_vbrk-xblnr.
            "----------------------------------------------------


            IF sy-subrc EQ 0.
              COMMIT WORK.
            ENDIF.
          END-TEST-SEAM.


*---Unlock the table
          CALL FUNCTION 'DEQUEUE_E_TABLE'
            EXPORTING
              mode_rstable = lc_mode
              tabname      = lc_zeinv_res.

          CALL FUNCTION 'DEQUEUE_E_TABLE'
            EXPORTING
              mode_rstable = lc_mode
              tabname      = lc_j_1ig_invrefnum.
        ENDIF.

        CLEAR: ls_str,lv_date .

        "--Error during IRN Generation

      ELSEIF lv_ucomm = '&CANEWAY'.

        "====================Update ZEINV_RES table only=========================

*    *---Lock the table
        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = lc_mode
            tabname        = lc_zeinv_res
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.


        IF sy-subrc EQ 0.
*        TEST-SEAM non_exe3.
          "----update table ZEINV_RES------------------------
          UPDATE zeinv_res
          SET
          zzewaycan_date = can_date
          zzerror_disc = 'E-Way Bill Successfully Cancelled'
          WHERE vbeln = ls_final-vbeln AND  xblnr = ls_final-xblnr.
          "----------------------------------------------------

          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.
*        END-TEST-SEAM.


*---Unlock the table
          CALL FUNCTION 'DEQUEUE_E_TABLE'
            EXPORTING
              mode_rstable = lc_mode
              tabname      = lc_zeinv_res.
        ENDIF.

        CLEAR: ls_str,lv_date .
      ENDIF.



    ELSEIF sy-subrc NE 0 AND sy-msgv1 IS NOT INITIAL AND can_date IS INITIAL.

      "--Lock the Table
      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          mode_rstable   = lc_mode
          tabname        = lc_zeinv_res
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.


      IF sy-subrc EQ 0.
        TEST-SEAM non_exe12.
          CONCATENATE 'IRN Cancelation failed due to :' sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_err_msg SEPARATED BY space.
          "----update table ZEINV_RES------------------------
          UPDATE zeinv_res
          SET
*          zzstatus = 'E'        "IRN Cancelation Failed
          zzerror_disc = lv_err_msg
          WHERE vbeln = ls_final-vbeln AND  xblnr = ls_final-xblnr.
          "----------------------------------------------------
          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.
        END-TEST-SEAM.


*---Unlock the table
        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_mode
            tabname      = lc_zeinv_res.
      ENDIF.
      MESSAGE lv_err_msg TYPE 'E' DISPLAY LIKE 'I'.


    ELSE.  "--Unknown error display

      MESSAGE 'PrimEBridge Application is not running' TYPE 'E' DISPLAY LIKE 'I'.
    ENDIF.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CREATE_EWAY_BY_IRN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_FINAL_IRN  text
*      -->P_LS_FINAL_VBELN  text
*----------------------------------------------------------------------*
FORM create_eway_by_irn  USING    p_irn TYPE zzirn_no
                                  p_vbeln TYPE vbeln
                                  p_bukrs TYPE bukrs
                                  p_fkart TYPE fkart
                                  p_gstin TYPE stcd3.


  TYPES : BEGIN OF expshpdtls,
            addr1(100) TYPE c,
            addr2(100) TYPE c,
            loc(100)   TYPE c,
            pin(06)    TYPE c,
            stcd(02)   TYPE c,
          END OF expshpdtls.

  TYPES : BEGIN OF ty_ewbdtls,
            irn            TYPE zzirn_no,    " IRN Number
            transid(15)    TYPE c,                "Transin/GSTIN
            transmode(1)   TYPE c,   "Required    "Mode of transport
            transdocno(15) TYPE c,                "Tranport Document Number
            transdocdt(10) TYPE c,                "Transport Document Date
            vehno(20)      TYPE c,                "Vehicle Number
            distance(4)    TYPE c,   "Required    "Distance between source and destination PIN codes
            vehtype(1)     TYPE c,                "Whether O-ODC or R-Regular
            transname(100) TYPE c,                "Name of the transporter
            expshpdtls     TYPE expshpdtls,         " Export Shipping Details
          END OF ty_ewbdtls.



  DATA : lt_eway TYPE TABLE OF ty_ewbdtls,
         ls_eway TYPE ty_ewbdtls.


  DATA :
    ls_ewaybill         TYPE j_1ig_ewaybill,
    ls_zeinv_res        TYPE zeinv_res,
    lv_fy(4)            TYPE c,
    lv_date             TYPE datum,
    lv_response_msg     TYPE string,
    lv_ack_date_s(10)   TYPE c,
    lv_ack_time_s(08)   TYPE c,
    lv_eway_date_s(10)  TYPE c,
    lv_eway_time_s(08)  TYPE c,
    lv_valid_date_s(10) TYPE c,
    lv_valid_time_s(08) TYPE c,
    lv_eway_date        TYPE j_1ig_egendat,
    lv_eway_time        TYPE j_1ig_vdfmtime,
    lv_valid_date       TYPE j_1ig_vdtodate,
    lv_valid_time       TYPE j_1ig_vdtotime,
    lv_ack_date         TYPE zzack_date1,
    lv_err              TYPE string.



  CONSTANTS:
    lc_mode            TYPE enqmode VALUE 'E',
    lc_j_1ig_invrefnum TYPE tabname VALUE 'J_1IG_INVREFNUM',
    lc_j_1ig_ewaybill  TYPE tabname VALUE 'J_1IG_EWAYBILL',
    lc_zeinv_res       TYPE tabname VALUE 'ZEINV_RES',
    lc_zeinv_res_fb70  TYPE tabname VALUE 'ZEINV_RES_FB70',
    lc_periv           TYPE periv VALUE 'V3'.



  DATA : ewaybill_no      TYPE string,
         ewaybill_date    TYPE string,
         valid_upto       TYPE string,
         remark           TYPE string,
         lv_doc_date      TYPE string,
         lv_trans_mode(1) TYPE c.





  "----Populate Eway Details
*  ls_eway-irn = p_irn.
*  ls_eway-transid = '29AAACW6874H1ZS'.
*  ls_eway-transmode = '1'.
*  ls_eway-transdocno = '1000'.
*  ls_eway-transdocdt = '17/06/2020'.
*  ls_eway-vehno = 'MH12MG0619'.
*  ls_eway-distance = '100'.
*  ls_eway-vehtype = 'R'.
*  ls_eway-transname = 'Om Exports'.

  "------------------------------

  CASE zeway_bill-trns_md.
    WHEN 'Road'.
      lv_trans_mode = 1.
    WHEN 'Rail'.
      lv_trans_mode = 2.
    WHEN 'Air'.
      lv_trans_mode = 3.
    WHEN 'Ship'.
      lv_trans_mode = 4.
    WHEN OTHERS.
  ENDCASE.

  ls_eway-irn = p_irn.
  ls_eway-transid = zeway_bill-trans_id.
  ls_eway-transmode = lv_trans_mode.
  ls_eway-transdocno = zeway_bill-trans_doc.
  CONCATENATE zeway_bill-doc_dt+6(2) zeway_bill-doc_dt+4(2) zeway_bill-doc_dt+0(4) INTO lv_doc_date SEPARATED BY '/'.
  ls_eway-transdocdt = lv_doc_date.
  ls_eway-vehno = zeway_bill-vehical_no.
  ls_eway-distance = zeway_bill-distance.
  ls_eway-vehtype = zeway_bill-vehical_type+0(1).
  ls_eway-transname = zeway_bill-trans_name.


  LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
*
*     READ TABLE lt_likp INTO ls_likp WITH KEY  vbeln = ls_vbrp-vgbel.
*        IF sy-subrc eq 0.
*          READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln  = ls_likp-vbeln.
*            IF sy-subrc eq 0.
*             READ TABLE lt_kna1_exp INTO ls_kna1_exp WITH KEY kunnr = ls_vbpa-kunnr.
*             IF sy-subrc eq 0.
*               ls_final-expdtls-port     = ls_kna1_exp-locco.
*             ENDIF.
*            ENDIF.
*        ENDIF.



  ENDLOOP.







  DATA:  lv_json   TYPE string.

* serialize table lt_fINAL into JSON, skipping initial fields and converting ABAP field names into camelCase
  lv_json = /ui2/cl_json=>serialize( data = ls_eway compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

  " Display JSON in ABAP
  CALL TRANSFORMATION sjson2html SOURCE XML lv_json
                             RESULT XML DATA(lvc_html).
*  cl_abap_browser=>show_html( title = 'ABAP (iTab) -> JSON: /ui2/cl_json=>serialize' html_string = cl_abap_codepage=>convert_from( lvc_html ) ).

*  CLEAR lt_final.

* deserialize JSON string json into internal table lt_final doing camelCase to ABAP like field name mapping
  /ui2/cl_json=>deserialize( EXPORTING json = lv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_final ).



  DATA(o_writer_itab) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
  CALL TRANSFORMATION id SOURCE values = ls_eway RESULT XML o_writer_itab.
  DATA: lv_result TYPE string.
  cl_abap_conv_in_ce=>create( )->convert( EXPORTING
                                            input = o_writer_itab->get_output( )
                                          IMPORTING
                                            data = lv_result ).

* JSON -> ABAP (iTab)
*  CLEAR lt_final.

  CALL TRANSFORMATION id SOURCE XML lv_result RESULT values = ls_eway.

* ABAP (iTab) -> JSON (trex)
  DATA(o_trex) = NEW cl_trex_json_serializer( ls_eway ).
  o_trex->serialize( ).

  DATA(lv_trex_json) = o_trex->get_data( ).
*--------------------------------------------------------------------------------------
*************************************************************************************************
  TYPES : BEGIN OF ty_json,
            line(255) TYPE c,
            tabix(03) TYPE n,
*           lv_text(65535) TYPE c,
          END OF ty_json.

  TYPES : BEGIN OF ty_json_output,
            line(255) TYPE c,
          END OF ty_json_output.


  TYPES : BEGIN OF ty_json_cnt,
            line(255) TYPE c,
            tabix     TYPE i,
*           lv_text(65535) TYPE c,
          END OF ty_json_cnt.

  DATA : it_json        TYPE TABLE OF ty_json,
         ls_json        TYPE ty_json,
         lt_json_output TYPE STANDARD TABLE OF ty_json_output,
         ls_json_output TYPE ty_json_output,
         p_lines        TYPE i VALUE 0,
         count          TYPE i VALUE 0.

  DATA : json_out TYPE  zeinv_json_tt.


  DATA : lt_json_cnt TYPE TABLE OF ty_json_cnt,
         ls_json_cnt TYPE ty_json_cnt.

  DATA : gstin TYPE string.

  IF sy-subrc IS INITIAL.
*    SPLIT lv_trex_json AT ':' INTO TABLE lt_json_string .
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.





  READ TABLE it_json ASSIGNING FIELD-SYMBOL(<lfs_json>) INDEX 1.
  IF sy-subrc EQ 0 .
    REPLACE ALL OCCURRENCES OF '[' IN <lfs_json> WITH ''.
  ENDIF.

  DATA : lv_srno TYPE string VALUE 'slno'.
  DATA : cnt TYPE i VALUE 200.
  DATA : lv_flag(01) TYPE c.
  DATA : ls_data TYPE string.


  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).
    CASE sy-tabix.
      WHEN 1.
        REPLACE 'irn' IN <lfs_json_main> WITH '"Irn"'.
      WHEN 2.
        REPLACE 'transid' IN <lfs_json_main> WITH '"TransId"'.
      WHEN 3.
        REPLACE 'transmode' IN <lfs_json_main> WITH '"TransMode"'.
      WHEN 4.
        REPLACE 'transdocno' IN <lfs_json_main> WITH '"TransDocNo"'.
      WHEN 5.
        REPLACE 'transdocdt' IN <lfs_json_main> WITH '"TransDocDt"'.
      WHEN 6.
        REPLACE 'vehno' IN <lfs_json_main> WITH '"VehNo"'.
      WHEN 7.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main>-line WITH ''.
        REPLACE 'distance' IN <lfs_json_main> WITH '"Distance"'.
      WHEN 8.
        REPLACE 'vehtype' IN <lfs_json_main> WITH '"VehType"'.
      WHEN 9.
        REPLACE 'transname' IN <lfs_json_main> WITH '"TransName"'.
        IF p_fkart NE 'ZEXP'.
          REPLACE ALL   OCCURRENCES OF ',' IN  <lfs_json_main> WITH space.
          CONCATENATE <lfs_json_main> '}' INTO <lfs_json_main> SEPARATED BY space.
        ENDIF.
      WHEN 10.
        IF p_fkart EQ 'ZEXP'.
          REPLACE 'expshpdtls' IN <lfs_json_main> WITH '"ExpShipDtls"'.
          REPLACE 'addr1' IN <lfs_json_main> WITH '"Addr1"'.
        ELSE.
          CLEAR <lfs_json_main>-line.
          CONTINUE.
        ENDIF.
      WHEN 11.
        IF p_fkart EQ 'ZEXP'.
          REPLACE 'addr2' IN <lfs_json_main> WITH '"Addr2"'.
        ELSE.
          CLEAR <lfs_json_main>-line.
          CONTINUE.
        ENDIF.

      WHEN 12.
        IF p_fkart EQ 'ZEXP'.
          REPLACE 'loc' IN <lfs_json_main> WITH '"Loc"'.
        ELSE.
          CLEAR <lfs_json_main>-line.
          CONTINUE.
        ENDIF.

      WHEN 13.
        IF p_fkart EQ 'ZEXP'.
          REPLACE 'pin' IN <lfs_json_main> WITH '"Pin"'.
        ELSE.
          CLEAR <lfs_json_main>-line.
          CONTINUE.
        ENDIF.

      WHEN 14.
        IF p_fkart EQ 'ZEXP'.
          REPLACE 'stcd' IN <lfs_json_main> WITH '"Stcd"'.
        ELSE.
          CLEAR <lfs_json_main>-line.
          CONTINUE.
        ENDIF.

      WHEN OTHERS.
    ENDCASE.
    IF <lfs_json_main>-line IS NOT INITIAL.
      REPLACE '"null"'            IN <lfs_json_main>-line WITH   'null'.
      REPLACE '"NULL"'            IN <lfs_json_main>-line WITH   'null'.
      APPEND <lfs_json_main>-line TO  json_out.
    ENDIF.
  ENDLOOP.




*  LOOP AT it_json INTO ls_json.
  LOOP AT json_out INTO DATA(ls_json_new).
    ls_json_output-line = ls_json_new-line.
    APPEND ls_json_output TO lt_json_output.
    CLEAR :  ls_json_new , ls_json_output.
  ENDLOOP.

  CLEAR json_out.

  LOOP AT lt_json_output INTO ls_json_output.
    CONCATENATE ls_data ls_json_output-line INTO ls_data.
  ENDLOOP.

  gstin = p_gstin.


  IF a1  = abap_true.                  "----Manual Download file.


*  **DOWNLOAD FILE
    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename = file_name "'C:/desktop/E-INVOICE.json'
      CHANGING
        data_tab = lt_json_output "lv_json "
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc EQ 0.

      MESSAGE i003 WITH file_name. " 'E-INVOICE Downloaded in Json Format on C:/desktop/'
      "TYPE 'I'.
    ENDIF.





  ELSEIF a4  = abap_true.              "----PrimEbridge Application

    "===============================================================================================
    "FM TO CONNECT WITH .NET APPLICATION
    "===============================================================================================

    CALL FUNCTION 'ZGENERATE_WAYBILL_BY_IRN'
      DESTINATION 'PSERVER' "--------TCP/IP Destination in SM59
      EXPORTING
        ls_data         = ls_data
        gstin           = gstin
      IMPORTING
        ewaybill_no     = ewaybill_no
        ewaybill_date   = ewaybill_date
        valid_upto      = valid_upto
        remark          = remark
      EXCEPTIONS
        raise_exception = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    CLEAR : ls_data , gstin.
    "===============================================================================================
    "===============================================================================================


    IF ewaybill_no IS NOT INITIAL  AND sy-subrc EQ 0.
      "=============ZEINV_RES Table data Populate=============================

      SPLIT ewaybill_date AT space INTO lv_eway_date_s lv_eway_time_s.
      REPLACE ALL OCCURRENCES OF '-' IN lv_eway_date_s WITH space.
      REPLACE ALL OCCURRENCES OF ':' IN lv_eway_time_s WITH space.
      CONDENSE lv_eway_date_s NO-GAPS.
      CONDENSE lv_eway_time_s NO-GAPS.
      lv_eway_date = lv_eway_date_s.
      lv_eway_time = lv_eway_time_s.
      SPLIT valid_upto AT space INTO lv_valid_date_s lv_valid_time_s.
      REPLACE ALL OCCURRENCES OF '-' IN lv_valid_date_s WITH space.
      REPLACE ALL OCCURRENCES OF ':' IN lv_valid_time_s WITH space.
      CONDENSE lv_valid_date_s NO-GAPS.
      CONDENSE lv_valid_time_s NO-GAPS.
      lv_valid_date = lv_valid_date_s.
      lv_valid_time = lv_valid_time_s.

      "==================================================================================




      "=========J_1IG_EWAYBILL Table data Populate=======================================
      ls_ewaybill-bukrs = p_bukrs.
      ls_ewaybill-doctyp = p_fkart.
      ls_ewaybill-docno = p_vbeln.
      ls_ewaybill-gjahr = lv_fy.
      ls_ewaybill-ebillno = ewaybill_no.
      ls_ewaybill-egen_dat = lv_eway_date.
      ls_ewaybill-egen_time = lv_eway_time.
      ls_ewaybill-vdfmdate = lv_eway_date.
      ls_ewaybill-vdfmtime = lv_eway_time.
      ls_ewaybill-vdtodate = lv_valid_date.
      ls_ewaybill-vdtotime = lv_valid_time.
      ls_ewaybill-status = 'A'.
      ls_ewaybill-ernam = sy-uname.
      ls_ewaybill-erdat = sy-datum.
      ls_ewaybill-aenam = sy-uname.
      ls_ewaybill-aedat = sy-datum.

      "===================================================================================

      "====================Update J_1IG_INVREFNUM  J_1IG_EWAYBILL and ZEINV_RES tables====

*    *---Lock the table
      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          mode_rstable   = lc_mode
          tabname        = lc_zeinv_res
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.


      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          mode_rstable   = lc_mode
          tabname        = lc_j_1ig_ewaybill
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.


      IF sy-subrc EQ 0.
        TEST-SEAM non_exee.
          "----update table ZEINV_RES-----------------------
          UPDATE zeinv_res
          SET
          zzewaybill_no     = ewaybill_no
          zzewaybill_date   = lv_eway_date
          zzewaybill_time   = lv_eway_time
          zzvalid_upto      = lv_valid_date
          zzvaild_upto_time = lv_valid_time
          WHERE vbeln = ls_final-vbeln AND  xblnr = ls_final-xblnr.
          "----------------------------------------------------

          "--Modify Table J1ig_ewaybill------------------------
          MODIFY j_1ig_ewaybill FROM ls_ewaybill.
          "----------------------------------------------------

          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.
        END-TEST-SEAM.


*---Unlock the table
        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_mode
            tabname      = lc_zeinv_res.


        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_mode
            tabname      = lc_j_1ig_ewaybill.

      ENDIF.

      CONCATENATE 'Remark' remark INTO DATA(lv_remark).
      MESSAGE lv_remark TYPE 'I'.

      CLEAR: lv_date ,ls_zeinv_res, ls_ewaybill , lv_doc_date , lv_trans_mode , ls_eway , zeway_bill .
      CLEAR : lv_eway_date,lv_eway_time,lv_valid_date,lv_valid_time,lv_ack_date,
              lv_eway_date_s,lv_eway_time_s,lv_valid_date_s,lv_valid_time_s,lv_ack_date_s,remark.
      CLEAR : ewaybill_no , ewaybill_date , valid_upto.


    ELSEIF sy-subrc NE 0 AND sy-msgv1 IS NOT INITIAL.

      CONCATENATE 'Eway bill Generation Failed ' sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_err.
      MESSAGE lv_err TYPE 'E' DISPLAY LIKE 'I'.

    ELSE.
      MESSAGE 'PrimEBridge Application is not running' TYPE 'E'.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

  lv_ucomm_sub = sy-ucomm.

  IF zeway_bill IS INITIAL.

    READ TABLE lt_final INTO ls_final WITH KEY selection = 'X'.
    IF sy-subrc = 0.

      SELECT
      vbeln,posnr,vgbel
       FROM vbrp
            INTO TABLE @DATA(lt_vbrp_eway)
            FOR ALL ENTRIES IN @lt_final
            WHERE vbeln = @lt_final-vbeln.


      IF lt_vbrp_eway IS NOT INITIAL.

        SELECT vbeln,posnr,parvw,lifnr
          FROM vbpa INTO TABLE @DATA(lt_vbpa_eway)
          FOR ALL ENTRIES IN @lt_vbrp_eway
          WHERE vbeln = @lt_vbrp_eway-vgbel AND
                parvw = 'LF'.

        IF lt_vbpa_eway IS NOT INITIAL.
          SELECT lifnr,name1,stcd3 FROM
          lfa1 INTO TABLE @DATA(lt_lfa1_eway)
           FOR ALL ENTRIES IN @lt_vbpa_eway
            WHERE lifnr = @lt_vbpa_eway-lifnr.
        ENDIF.

        SELECT vbeln,bolnr FROM likp
          INTO TABLE @DATA(lt_likp_eway)
          FOR ALL ENTRIES IN @lt_vbrp_eway
          WHERE vbeln = @lt_vbrp_eway-vgbel.

      ENDIF.

      READ TABLE lt_vbrp_eway INTO DATA(ls_vbrp_eway) WITH KEY vbeln  = ls_final-vbeln.
      IF sy-subrc EQ 0.

        READ TABLE lt_likp_eway INTO DATA(ls_likp) WITH KEY  vbeln = ls_vbrp_eway-vgbel.
        IF sy-subrc EQ 0.
          zeway_bill-vehical_no        =  ls_likp-bolnr.
        ENDIF.

        READ TABLE lt_vbpa_eway INTO DATA(ls_vbpa_eway) WITH KEY vbeln = ls_vbrp_eway-vgbel.
        IF sy-subrc EQ 0.
          READ TABLE lt_lfa1_eway INTO DATA(ls_lfa1_eway) WITH KEY lifnr = ls_vbpa_eway-lifnr.
          IF sy-subrc EQ 0.
            zeway_bill-trans_id      = ls_lfa1_eway-stcd3.
            zeway_bill-lifnr         = ls_lfa1_eway-lifnr.
          ENDIF.
        ENDIF.
      ENDIF.



      SELECT SINGLE * FROM zeway_bill INTO @DATA(ls_zeway_bill)
                                      WHERE bukrs = @ls_final-bukrs
                                        AND vbeln = @ls_final-vbeln.
      IF sy-subrc = 0.
        zeway_bill-trns_md       = ls_zeway_bill-trns_md.
        zeway_bill-trans_doc     = ls_zeway_bill-trans_doc.
        zeway_bill-lifnr         = ls_zeway_bill-lifnr.
        zeway_bill-doc_dt        = ls_zeway_bill-doc_dt.
        zeway_bill-vehical_type  = ls_zeway_bill-vehical_type.
        zeway_bill-distance      = ls_zeway_bill-distance.

        IF zeway_bill-trans_id  IS INITIAL.
          zeway_bill-trans_id      = ls_zeway_bill-trans_id.
        ENDIF.

        IF zeway_bill-trans_name IS INITIAL.
          zeway_bill-trans_name    = ls_zeway_bill-trans_name.
        ENDIF.

        IF zeway_bill-vehical_no IS INITIAL.
          zeway_bill-vehical_no    = ls_zeway_bill-vehical_no.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE sy-ucomm.
    WHEN '&CAN' OR 'CANCEL'.
      CLEAR zeway_bill.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN '&SAVE'.

*        **      #validation

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        gs_ewaybill_details-bukrs        =    ls_final-bukrs.
        gs_ewaybill_details-vbeln        =    ls_final-vbeln.
        gs_ewaybill_details-trns_md      =    zeway_bill-trns_md.
        gs_ewaybill_details-trans_doc    =    zeway_bill-trans_doc.
        gs_ewaybill_details-lifnr        =    zeway_bill-lifnr.
        gs_ewaybill_details-doc_dt       =    zeway_bill-doc_dt.
        gs_ewaybill_details-trans_id     =    zeway_bill-trans_id.
        gs_ewaybill_details-trans_name   =    zeway_bill-trans_name.
        gs_ewaybill_details-vehical_no   =    zeway_bill-vehical_no.
        gs_ewaybill_details-vehical_type =    zeway_bill-vehical_type.
        gs_ewaybill_details-distance     =    zeway_bill-distance.
        APPEND gs_ewaybill_details TO gt_ewaybill_details.
      ENDLOOP.

      IF gt_ewaybill_details IS NOT INITIAL.
        MODIFY zeway_bill FROM TABLE gt_ewaybill_details.
        COMMIT WORK.
        CLEAR : gs_ewaybill_details.
        REFRESH : gt_ewaybill_details.
      ENDIF.

      SET SCREEN '0'.
      LEAVE SCREEN.

    WHEN OTHERS.
  ENDCASE.


ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  VALIDATE_SUBSCREEN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validate_subscreen_vehicalno INPUT.

  IF zeway_bill-trns_md = 'Road' AND ( zeway_bill-trans_id IS INITIAL AND zeway_bill-vehical_no IS INITIAL ).
*    MESSAGE 'IF transport mode is road and transporter ID is not entered then vehical number is mandatory' TYPE 'E'.
    MESSAGE 'IF transport mode is road then either transporter ID or  vehical number is mandatory' TYPE 'E'.
  ENDIF.

ENDMODULE.


MODULE validate_subscreen_vehicaltype INPUT.

  IF zeway_bill-trns_md = 'Road' AND zeway_bill-vehical_type IS INITIAL.
    MESSAGE e005(zeway).
  ENDIF.

ENDMODULE.

MODULE validate_subscreen_transdoc INPUT.
*          *Transport doc no is MANDATORY if transMode is RAIL/AIR/SHIP.
  IF ( zeway_bill-trns_md = 'Rail' OR zeway_bill-trns_md = 'Air' OR zeway_bill-trns_md = 'Ship' ) AND zeway_bill-trans_doc IS INITIAL .
    MESSAGE e001(zeway).
  ENDIF.

ENDMODULE.

MODULE validate_subscreen_docdt INPUT.
**      *Transport doc date is MANDATORY if transMode is RAIL/AIR/SHIP.
  IF ( zeway_bill-trns_md = 'Rail' OR zeway_bill-trns_md = 'Air' OR zeway_bill-trns_md = 'Ship' ) AND zeway_bill-doc_dt IS INITIAL.
    MESSAGE e002(zeway).
  ENDIF.

  IF zeway_bill-doc_dt IS NOT INITIAL AND zeway_bill-doc_dt LT ls_final-fkdat .
    MESSAGE e009(zeway).
  ENDIF.

ENDMODULE.

MODULE validate_subscreen_distance INPUT.
**      *Transport doc date is MANDATORY if transMode is RAIL/AIR/SHIP.
  IF  zeway_bill-distance > '4000'.
    MESSAGE e008(zeway).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

  READ TABLE lt_final INTO ls_final WITH KEY selection = 'X'.
  IF sy-subrc = 0.
    lv_eway               = ls_final-zzewaybill_no.
    SELECT SINGLE * FROM zeway_bill INTO @DATA(ls_zeway_bill_can)
                                    WHERE bukrs = @ls_final-bukrs
                                      AND vbeln = @ls_final-vbeln.
    IF sy-subrc = 0.
      zeway_bill-reasoncode = ls_zeway_bill_can-reasoncode.
      zeway_bill-reason     = ls_zeway_bill_can-reason.
    ENDIF.
  ENDIF.




ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  CASE sy-ucomm.

    WHEN '&EXIT'.
      CLEAR zeway_bill.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN '&CAN'.

*        **      #validation

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        UPDATE zeway_bill
        SET
        reasoncode = zeway_bill-reasoncode
        reason     = zeway_bill-reason
        WHERE bukrs = ls_final-bukrs AND vbeln = ls_final-vbeln.
      ENDLOOP.
      COMMIT WORK.
      CLEAR : gs_ewaybill_details.
      REFRESH : gt_ewaybill_details.


      SET SCREEN '0'.
      LEAVE SCREEN.

    WHEN OTHERS.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  GET_GSTIN_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_ROW_ID  text
*      -->P_GSTIN  text
*----------------------------------------------------------------------*
FORM get_gstin_details  USING    p_e_row_id TYPE any
                                 p_gstin TYPE stcd3.

  DATA :

    gstin     TYPE string,
    tradename TYPE string,
    legalname TYPE string,
    addrbnm   TYPE string,
    addrbno   TYPE string,
    addrflno  TYPE string,
    addrst    TYPE string,
    addrloc   TYPE string,
    statecode TYPE string,
    addrpncd  TYPE string,
    txptype   TYPE string,
    status    TYPE string,
    blkstatus TYPE string.

  TYPES: BEGIN OF ty_msg,
           name(20),
           log(5000),
         END OF ty_msg.

  DATA : it_log TYPE TABLE OF ty_msg,
         wa_log TYPE ty_msg.

  TYPES : BEGIN OF lty_data,
            gstin     TYPE string,
            tradename TYPE string,
            legalname TYPE string,
            addrbnm   TYPE string,
            addrbno   TYPE string,
            addrflno  TYPE string,
            addrst    TYPE string,
            addrloc   TYPE string,
            statecode TYPE string,
            addrpncd  TYPE string,
            txptype   TYPE string,
            status    TYPE string,
            blkstatus TYPE string,
          END OF lty_data.

  DATA : lt_gstin_details TYPE TABLE OF lty_data,
         ls_gstin_details TYPE lty_data.




  "===============================================================================================
  "FM TO CONNECT WITH .NET APPLICATION
  "===============================================================================================

  CALL FUNCTION 'ZSYSC_GSTIN_DETAILS'
    DESTINATION 'PSERVER' "--------TCP/IP Destination in SM59
    EXPORTING
      gstin_in        = p_gstin
    IMPORTING
      gstin_out       = ls_gstin_details-gstin
      tradename       = ls_gstin_details-tradename
      legalname       = ls_gstin_details-legalname
      addrbnm         = ls_gstin_details-addrbnm
      addrbno         = ls_gstin_details-addrbno
      addrflno        = ls_gstin_details-addrflno
      addrst          = ls_gstin_details-addrst
      addrloc         = ls_gstin_details-addrloc
      statecode       = ls_gstin_details-statecode
      addrpncd        = ls_gstin_details-addrpncd
      txptype         = ls_gstin_details-txptype
      status          = ls_gstin_details-status
      blkstatus       = ls_gstin_details-blkstatus
    EXCEPTIONS
      raise_exception = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CLEAR : p_gstin.

  APPEND ls_gstin_details TO lt_gstin_details.
  CLEAR  ls_gstin_details.

  "===============================================================================================
  "===============================================================================================

  my_cl_salv_pop_up=>popup( EXPORTING mode    = 'G'
                                      t_table = lt_gstin_details ).
  CLEAR : lt_gstin_details.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_EWAY_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_ROW_ID  text
*      -->P_<LFS_READ_GSTIN>_STCD3_CUST  text
*----------------------------------------------------------------------*
FORM get_eway_details  USING    p_e_row_id TYPE any
                                p_gstin TYPE stcd3
                                supplier_gstin TYPE stcd3
                                irn TYPE zzirn_no.

  TYPES : BEGIN OF lty_data,
            ewaybill_no   TYPE string,
            status        TYPE string,
            gengstin      TYPE string,
            ewaybill_date TYPE string,
            valid_upto    TYPE string,
          END OF lty_data.


  DATA : lt_eway_details TYPE TABLE OF lty_data,
         ls_eway_details TYPE lty_data.



  "===============================================================================================
  "FM TO CONNECT WITH .NET APPLICATION
  "===============================================================================================


  CALL FUNCTION 'ZGET_EWAYBILL_BY_IRN'
    DESTINATION 'PSERVER' "--------TCP/IP Destination in SM59
    EXPORTING
      gstin           = p_gstin
      irn             = irn
      supplier_gstin  = supplier_gstin
    IMPORTING
      ewaybill_no     = ls_eway_details-ewaybill_no
      status          = ls_eway_details-status
      gengstin        = ls_eway_details-gengstin
      ewaybill_date   = ls_eway_details-ewaybill_date
      valid_upto      = ls_eway_details-valid_upto
    EXCEPTIONS
      raise_exception = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR : p_gstin,irn,supplier_gstin.

  APPEND ls_eway_details TO lt_eway_details.
  CLEAR ls_eway_details.

  "===============================================================================================
  "===============================================================================================

  my_cl_salv_pop_up=>popup( EXPORTING mode    = 'E'
                                      t_table = lt_eway_details ).
  CLEAR : lt_eway_details.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  API_AUTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM api_auth .
  BREAK primus.


  DATA : ls_zeinv_res TYPE zeinv_res.
  DATA : ls_h1     TYPE string,
         ls_h2     TYPE string,
         ls_header TYPE zeinv_api.
  DATA: lv_header TYPE string.
  TYPES : BEGIN OF ty_auth,
            auth   TYPE string,
            accept TYPE string,
            gstin  TYPE string,
          END OF ty_auth.
  DATA : ls_auth TYPE ty_auth.

  TYPES : BEGIN OF ty_auth1,
            action   TYPE string,
            username TYPE string,
            password TYPE string,
          END OF ty_auth1.
  DATA : it_auth TYPE TABLE OF ty_auth1,
         wa_auth TYPE          ty_auth1.

  TYPES : BEGIN OF ty_response_tokan,
            line(255) TYPE c,
          END OF ty_response_tokan.

  DATA: lt_response_tokan TYPE STANDARD TABLE OF ty_response_tokan,
        ls_response_tokan TYPE ty_response_tokan.

  DATA: lt_einres_tokan TYPE STANDARD TABLE OF ty_response_tokan,
        ls_einres_tokan TYPE ty_response_tokan.


  CLEAR :lt_res_tokan ,ls_res_tokan, wa_auth , it_auth, ls_ein_tokan , lt_ein_tokan ,lt_response_tokan ,ls_response_tokan,lt_einres_tokan,ls_einres_tokan.
  REFRESH : lt_res_tokan,it_auth,lt_ein_tokan,lt_response_tokan,lt_einres_tokan.


  LOOP AT lt_jsonfile INTO ls_jsonfile.
    IF ls_jsonfile-line CS 'SellerDtls'.
      REPLACE ALL OCCURRENCES OF '"' IN ls_jsonfile-line WITH ' '.
      SPLIT ls_jsonfile-line AT ':' INTO ls_h1 ls_h2.
      SPLIT ls_h2 AT ':' INTO ls_h1 ls_h2.
      REPLACE ALL OCCURRENCES OF ',' IN ls_h2 WITH ' '.
      CONDENSE ls_h2.
    ENDIF.
  ENDLOOP.
  SELECT SINGLE * FROM zeinv_api
    INTO ls_header WHERE gstin EQ ls_h2.

  BREAK primus.

**********************************************************GST Hero Tokan**********************************
   ls_auth-auth = 'Basic NDg3YWM4MGEwN2Y2MDM5YzEyOWZlN2MyN2IxMmNiY2Y6ZWtKVU5USHpZSw=='.
*  ls_auth-auth = 'Basic dGVzdGVycGNsaWVudDpBZG1pbkAxMjM='.
  ls_auth-accept = 'application/json'.

*  IF sy-mandt = 060.
*    ls_auth-gstin = '05AALFP1139Q003' .
*  ELSE.
    ls_auth-gstin = '27AACCD2898L1Z4'. "ls_H2
*  ENDIF.

  DATA lv_url1 TYPE string.

*  IF sy-mandt = '060'.
**    lv_url1 = 'http://35.154.208.8:8080/auth-server/oauth/token'.
*    lv_url1 = 'http://35.154.208.8:8080/auth-server/oauth/token'.
*  ELSE.
    lv_url1 = 'https://gsthero.com/auth-server/oauth/token'.
*  ENDIF.
  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url1 "LV_URL   "LV_URL  'https://einvoicing.internal.cleartax.co/v2/eInvoice/generate'
    IMPORTING
      client             = DATA(lo_http_client)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).

  DATA gv_auth_val TYPE string.
  CHECK lo_http_client IS BOUND.

  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Accept'
      value = 'application/json'.

  lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post

  lo_http_client->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Content-Type'
      value = 'application/x-www-form-urlencoded' ).

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = ls_auth-auth ).                              "lv_owid  "0bb45513-b359-48ba-9f5c-315796852950
*   value = '0bb45513-b359-48ba-9f5c-315796852950' ) .  """ chg by NC                            "lv_owid  "0bb45513-b359-48ba-9f5c-315796852950

  lo_http_client->request->set_header_field(            "
    EXPORTING
      name  = 'gstin'
      value = ls_auth-gstin ).

  DATA:pay TYPE string.

*  pay = 'grant_type={password}&username={erp1@perennialsys.com}&password={einv12345}&client_id={testerpclient}&scope={einvauth}'.
   pay = 'grant_type=password&username=stathe@delvalflow.com&password=India@12345&client_id=487ac80a07f6039c129fe7c27b12cbcf&scope=einvauth'.
*   pay = 'grant_type=password&username=erp1@perennialsys.com&password=einv12345&client_id=testerpclient&scope=einvauth'.

  lo_http_client->request->set_cdata(
    EXPORTING
      data = pay ).

  lo_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).


  CHECK sy-subrc = 0.
  DATA(lv_response_tokan) = lo_http_client->response->get_cdata( ).

  REPLACE ALL OCCURRENCES OF '[{' IN lv_response_tokan WITH ' '.
  SPLIT lv_response_tokan AT ',' INTO TABLE lt_response_tokan.


  LOOP AT  lt_response_tokan INTO ls_response_tokan.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response_tokan WITH ' '.
    SPLIT ls_response_tokan AT ':' INTO ls_res_tokan-header ls_res_tokan-value.

    IF sy-tabix LE 10 .
      APPEND ls_res_tokan TO lt_res_tokan.
      CLEAR ls_res_tokan.
    ENDIF.

  ENDLOOP.
****************************************************************************************************

******************************************************Einvoice Tokan***********************************

  DATA lv_url2 TYPE string.

*  IF sy-mandt = '060'.
*    lv_url2 = 'http://35.154.208.8:8080/einvoice/v1.00/authentication'.
*  ELSE.
    lv_url2 = 'https://gsthero.com/einvoice/v1.03/authentication'."'http://35.154.208.8:8080/einvoice/v1.00/authentication'.
*  ENDIF.
  cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url2
    IMPORTING
      client             = DATA(lo_http_client1)
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).

  DATA gv_auth_val1 TYPE string.
  CHECK lo_http_client1 IS BOUND.


  lo_http_client1->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client1->request->set_method(
    EXPORTING
      method = 'POST' ).     "if_http_entity=>co_request_method_post

  lo_http_client1->request->set_content_type(
    EXPORTING
      content_type = if_rest_media_type=>gc_appl_json ).

  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json' ).


  DATA :auth TYPE string.

  DATA xconn TYPE string.
  CLEAR :xconn,auth.

*  IF sy-mandt = 060.
*    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AALFP1139Q003'.
*  ELSE.
    xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.
*  ENDIF.

  READ TABLE lt_res_tokan INTO ls_res_tokan INDEX 1 .
  auth = ls_res_tokan-value.
  READ TABLE lt_res_tokan INTO ls_res_tokan INDEX 2 .
  CONCATENATE 'Bearer' auth INTO auth SEPARATED BY space.
*CONDENSE auth.

  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'Authorization'
      value = auth ).


  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'X-Connector-Auth-Token'
      value = xconn ).


  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'Action'
      value = 'ACCESSTOKEN' ).

  lo_http_client1->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client1->request->set_header_field(            "
    EXPORTING
      name  = 'gstin'
      value = ls_auth-gstin ).


  DATA:aut_tokan TYPE string.
  DATA ls_json TYPE string.

  CLEAR: aut_tokan,ls_json.
*aut_tokan = '{"action":"ACCESSTOKEN","username":"perennialsystems","password":"p3r3nn!@1"}'.



*if sy-mandt = 060.
*  wa_auth-action   = 'ACCESSTOKEN'.
*  wa_auth-username = 'perennialsys_UK'.
*  wa_auth-password = 'Pere@123'.
*  APPEND wa_auth TO it_auth.



  wa_auth-action   = 'ACCESSTOKEN'.
  wa_auth-username = 'DELVALFLOW_API_123'.
  wa_auth-password = 'gsthero@12345'.
  APPEND wa_auth TO it_auth.
*endif.

  ls_json = /ui2/cl_json=>serialize( data = it_auth compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
  CLEAR it_auth.
  /ui2/cl_json=>deserialize( EXPORTING json = ls_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = it_auth ).

  REPLACE ALL OCCURRENCES OF '[' IN ls_json WITH space.
  REPLACE ALL OCCURRENCES OF ']' IN ls_json WITH space.
  CONDENSE ls_json.

  lo_http_client1->request->set_cdata(
    EXPORTING
      data = ls_json ).

  lo_http_client1->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client1->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3 ).


  CHECK sy-subrc = 0.
  DATA(lv_einres_tokan) = lo_http_client1->response->get_cdata( ).

  REPLACE ALL OCCURRENCES OF '[{' IN lv_einres_tokan WITH ' '.
  SPLIT lv_einres_tokan AT ',' INTO TABLE lt_einres_tokan.


  LOOP AT  lt_einres_tokan INTO ls_einres_tokan.
    REPLACE ALL OCCURRENCES OF '"' IN ls_einres_tokan WITH ' '.
    SPLIT ls_einres_tokan AT ':' INTO ls_ein_tokan-header ls_ein_tokan-value.

    IF sy-tabix LE 10 .
      APPEND ls_ein_tokan TO lt_ein_tokan.
      CLEAR ls_ein_tokan.
    ENDIF.

  ENDLOOP.

ENDFORM.
