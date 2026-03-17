*&---------------------------------------------------------------------*
*& Report Z_CLOSE_PR_WITHOUT_PO
*&---------------------------------------------------------------------*
*INCIDENT           :       D-1-I6 Facility to delete Manual PR not Converted to PO /ABAP
*CASE/OBJ ID        :       Report
*CORRECTION         :       INITIAL DEVELOPMENT
*DESCRIPTION        :       CLOSE PR WITHOUT PO REPORT
*CREATED BY         :       Sagar Darade
*CHECKED BY         :       Vivek Kulkarni
*GIVEN BY           :       Chetan Shendge
*ORGANIZATION       :       OCPL.
*PROJECT            :       Delval India
*DATE               :       10.03.2026
*REQUEST NO.        :       DEVK942931
*-----------------------------------------------------------------------------------------

REPORT z_close_pr_without_po.

*---------------------------------------------------------------------*
* Types
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_eban,
         banfn TYPE eban-banfn,
         bnfpo TYPE eban-bnfpo,
         loekz TYPE eban-loekz,
         estkz TYPE eban-estkz,
         ebakz TYPE eban-ebakz,
         menge TYPE eban-menge,
         bsmng TYPE eban-bsmng,
         matnr TYPE eban-matnr,
         werks TYPE eban-werks,
         ekgrp TYPE eban-ekgrp,
       END OF ty_eban.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
       END OF ty_mara.

TYPES: BEGIN OF ty_t024,
         ekgrp     TYPE t024-ekgrp,
         smtp_addr TYPE adr6-smtp_addr,
       END OF ty_t024.

TYPES: BEGIN OF ty_log,
         sr_no TYPE string,
         banfn TYPE eban-banfn,
         bnfpo TYPE eban-bnfpo,
         matnr TYPE eban-matnr,
         werks TYPE eban-werks,
         menge TYPE eban-menge,
         bsmng TYPE eban-menge,
         ekgrp TYPE eban-ekgrp,
       END OF ty_log.

TYPES: tt_log TYPE STANDARD TABLE OF ty_log WITH DEFAULT KEY.
TYPES: tt_bapi TYPE STANDARD TABLE OF bapiebAND.
TYPES: tt_BAPIMEREQITEMIMP TYPE STANDARD TABLE OF bapimereqitemimp.
TYPES: tt_BAPIMEREQITEMX TYPE STANDARD TABLE OF bapimereqitemx.

*---------------------------------------------------------------------*
* Class
*---------------------------------------------------------------------*
CLASS lcl_close_pr DEFINITION.

  PUBLIC SECTION.

    DATA:
      it_eban TYPE STANDARD TABLE OF ty_eban,
      it_mara TYPE STANDARD TABLE OF ty_mara,
      it_t024 TYPE STANDARD TABLE OF ty_t024.

    METHODS:

      fetch_data,

      process_data,

      close_pr
        IMPORTING lt_pritem     TYPE tt_bapimereqitemimp
                  lt_pritemx    TYPE tt_bapimereqitemx
                  iv_pr_number  TYPE bapimereqheader-preq_no
        RETURNING VALUE(rt_log) TYPE tt_log,

      send_email
        IMPORTING
          it_log      TYPE tt_log
          iv_email_id TYPE t024-smtp_addr,

      generate_txt_file
        IMPORTING
          it_log TYPE tt_log.

ENDCLASS.

*---------------------------------------------------------------------*
* Implementation
*---------------------------------------------------------------------*
CLASS lcl_close_pr IMPLEMENTATION.

*---------------------------------------------------------------------*
* FETCH DATA
*---------------------------------------------------------------------*
  METHOD fetch_data.

    CLEAR: it_eban, it_mara, it_t024.

    SELECT banfn bnfpo loekz estkz ebakz menge bsmng matnr werks ekgrp
    FROM eban
    INTO TABLE it_eban
    WHERE werks = 'PL01'
      AND loekz <> 'X'
      AND estkz = 'R'
      AND ebakz = ''.

    IF it_eban IS NOT INITIAL.

      SELECT matnr mtart
      FROM mara
      INTO TABLE it_mara
      FOR ALL ENTRIES IN it_eban
      WHERE matnr = it_eban-matnr
        AND mtart IN ('HALB','FERT','ROH').

      SELECT ekgrp smtp_addr
      FROM t024
      INTO TABLE it_t024
      FOR ALL ENTRIES IN it_eban
      WHERE ekgrp = it_eban-ekgrp.

    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* PROCESS DATA
*---------------------------------------------------------------------*
  METHOD process_data.

    DATA:
      lt_bapi_item    TYPE tt_bapi,
      lt_bapi_PRITEM  TYPE tt_bapimereqitemimp,
      lt_bapi_pritemx TYPE tt_bapimereqitemx,
      lt_log          TYPE tt_log,
      lv_pr           TYPE eban-banfn,
      lv_email_id     TYPE t024-smtp_addr,
      lt_all_log      TYPE tt_log.

    FIELD-SYMBOLS:
      <fs_eban>         TYPE ty_eban,
      <fs_mara>         TYPE ty_mara,
      <fs_t024>         TYPE ty_t024,
      <fs_bapi_pritem>  TYPE bapimereqitemimp,
      <fs_bapi_pritemx> TYPE bapimereqitemx.



    SORT it_eban BY banfn bnfpo.

    LOOP AT it_eban ASSIGNING <fs_eban>.

      AT NEW banfn.
        CLEAR: lt_bapi_pritem, lt_bapi_pritemx.
        lv_pr = <fs_eban>-banfn.
      ENDAT.

      "Check open quantity
      IF <fs_eban>-menge - <fs_eban>-bsmng <> 0.

        READ TABLE it_mara ASSIGNING <fs_mara>
        WITH KEY matnr = <fs_eban>-matnr.

        IF sy-subrc = 0.

          APPEND INITIAL LINE TO lt_bapi_pritem ASSIGNING <fs_bapi_pritem>.
          <fs_bapi_pritem>-preq_item = <fs_eban>-bnfpo.
          <fs_bapi_pritem>-closed    = 'X'.

          APPEND INITIAL LINE TO lt_bapi_pritemx ASSIGNING <fs_bapi_pritemx>.
          <fs_bapi_pritemx>-preq_item  = <fs_eban>-bnfpo.
          <fs_bapi_pritemx>-preq_itemx = 'X'.
          <fs_bapi_pritemx>-closed     = 'X'.

        ENDIF.
      ENDIF.

      AT END OF banfn.

        IF lt_bapi_pritem IS NOT INITIAL.

          lt_log = me->close_pr(
                      lt_pritem     = lt_bapi_pritem
                      lt_pritemx    = lt_bapi_pritemx
                      iv_pr_number  = lv_pr ).

          APPEND LINES OF lt_log TO lt_all_log.

        ENDIF.

      ENDAT.

    ENDLOOP.

    " --- Generate TXT file on server ---
    IF lt_all_log IS NOT INITIAL.
      me->generate_txt_file( it_log = lt_all_log ).
    ELSE.
      MESSAGE 'No PR records found for closing' TYPE 'S'.
    ENDIF.


    " SEND EMAIL PER RECIPIENT
    LOOP AT it_t024 ASSIGNING <fs_t024>.

      CLEAR lt_log.

      FIELD-SYMBOLS <fs_all_log> TYPE ty_log.
      LOOP AT lt_all_log ASSIGNING <fs_all_log>.

        READ TABLE it_eban ASSIGNING <fs_eban>
          WITH KEY banfn = <fs_all_log>-banfn BNFPO = <fs_all_log>-bnfpo.

        IF sy-subrc = 0 AND <fs_eban>-ekgrp = <fs_t024>-ekgrp.
          APPEND <fs_all_log> TO lt_log.
        ENDIF.

      ENDLOOP.

      IF lt_log IS NOT INITIAL.
        lv_email_id = <fs_t024>-smtp_addr.
        me->send_email(
          it_log      = lt_log
          iv_email_id = lv_email_id ).
      ENDIF.

    ENDLOOP.



  ENDMETHOD.

*---------------------------------------------------------------------*
* CLOSE PR
*---------------------------------------------------------------------*
  METHOD close_pr.

    DATA:
      lt_return           TYPE TABLE OF bapiret2,
      lt_items_to_delete  TYPE  tt_bapimereqitemimp,
      lt_items_to_delete1 TYPE  tt_bapimereqitemx,
*      lt_pritem           TYPE tt_bapimereqitemimp,
*      lt_pritemx          TYPE tt_bapimereqitemx,
      lv_srno             TYPE i VALUE 0.

    FIELD-SYMBOLS:
      <fs_log>    TYPE ty_log,
      <fs_item>   TYPE bapimereqitemimp,
      <fs_item1>  TYPE bapimereqitemx,
      <fs_return> TYPE bapiret2.

    LOOP AT lt_pritem INTO DATA(ls_item).
      APPEND ls_item TO lt_items_to_delete.
    ENDLOOP.

    LOOP AT lt_pritemx INTO DATA(ls_item1).
      APPEND ls_item1 TO lt_items_to_delete1.
    ENDLOOP.


    CALL FUNCTION 'BAPI_PR_CHANGE'
      EXPORTING
        number  = iv_pr_number
*     IMPORTING
*       PRHEADEREXP                  =
      TABLES
        return  = lt_return
        pritem  = lt_items_to_delete
        pritemx = lt_items_to_delete1.


    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    READ TABLE lt_return ASSIGNING <fs_return> INDEX 1.

    IF sy-subrc = 0.

      LOOP AT lt_items_to_delete ASSIGNING <fs_item>.

        READ TABLE it_eban INTO DATA(ls_eban) WITH KEY banfn = iv_pr_number bnfpo = <fs_item>-preq_item.
        IF sy-subrc = 0 .


          APPEND INITIAL LINE TO rt_log ASSIGNING <fs_log>.

          lv_srno = lv_srno + 1.

          <fs_log>-sr_no = lv_srno.
          <fs_log>-banfn = iv_pr_number.
          <fs_log>-bnfpo = <fs_item>-preq_item.
          <fs_log>-matnr = ls_eban-matnr.
          <fs_log>-werks = ls_eban-werks.
          <fs_log>-menge = ls_eban-menge.
          <fs_log>-bsmng = ls_eban-bsmng.
          <fs_log>-ekgrp = ls_eban-ekgrp.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* SEND EMAIL
*---------------------------------------------------------------------*
  METHOD send_email.
    DATA:
      lt_text_str     TYPE STANDARD TABLE OF string,
      lt_text_soli    TYPE STANDARD TABLE OF soli,
      ls_text_soli    TYPE soli,
      lv_string       TYPE string,
      lv_counter      TYPE i VALUE 1,
      lo_send_request TYPE REF TO cl_bcs,
      lo_document     TYPE REF TO cl_document_bcs,
      lo_recipient    TYPE REF TO if_recipient_bcs.


    FIELD-SYMBOLS <fs_log> TYPE ty_log.

    IF iv_email_id IS INITIAL.
      RETURN.
    ENDIF.



    CLEAR lt_text_str.
    APPEND '<html><body>' TO lt_text_str.
    APPEND '<p>Dear Sir,</p>' TO lt_text_str.
    APPEND '<p>Please find below the list of manually created Purchase Requisitions and line items that have been automatically closed.</p>' TO lt_text_str.

    " Table header
    APPEND '<table border="1" style="border-collapse:collapse;">' TO lt_text_str.
    APPEND '<tr><th style="background-color:#d9e1f2;">SR NO</th><th style="background-color:#d9e1f2;">Purchase Requisition</th><th style="background-color:#d9e1f2;">Line Items</th></tr>' TO lt_text_str.

    LOOP AT it_log ASSIGNING <fs_log>.
      APPEND |<tr><td>{ lv_counter }</td><td>{ <fs_log>-banfn }</td><td>{ <fs_log>-bnfpo }</td></tr>| TO lt_text_str.
      lv_counter = lv_counter + 1.
    ENDLOOP.

    APPEND '</table><p>Thanks & regards,<br>Purchase Department<br>Delval Flow Controls Pvt. Ltd.</p></body></html>' TO lt_text_str.

    CLEAR lt_text_soli.
    LOOP AT lt_text_str INTO lv_string.
      ls_text_soli-line = lv_string.
      APPEND ls_text_soli TO lt_text_soli.
    ENDLOOP.


    TRY.

        lo_send_request = cl_bcs=>create_persistent( ).

        lo_document = cl_document_bcs=>create_document(
                        i_type    = 'HTM'
                        i_text    = lt_text_soli
                        i_subject = 'Closed PR Log' ).

        lo_send_request->set_document( lo_document ).

        lo_recipient = cl_cam_address_bcs=>create_internet_address(
                         i_address_string = iv_email_id ).

        lo_send_request->add_recipient( lo_recipient ).

        lo_send_request->send( ).

        COMMIT WORK.

      CATCH cx_send_req_bcs INTO DATA(lx_send).
        MESSAGE lx_send->get_text( ) TYPE 'E'.

      CATCH cx_bcs INTO DATA(lx_bcs).
        MESSAGE lx_bcs->get_text( ) TYPE 'E'.

    ENDTRY.

  ENDMETHOD.

*---------------------------------------------------------------------*
* GENERATE TXT FILE
*---------------------------------------------------------------------*
  METHOD generate_txt_file.


    DATA: it_csv      TYPE truxs_t_text_data,
          wa_csv      TYPE LINE OF truxs_t_text_data,
          hd_csv      TYPE string,
          lv_file     TYPE string,
          lv_fullfile TYPE string,
          lv_msg      TYPE string,
          lv_string   TYPE string,
          lv_date     TYPE char11,
          lv_time     TYPE char5,
          lv_menge    TYPE char20,
          lv_bsmng    TYPE char20.

    FIELD-SYMBOLS: <fs_log> TYPE ty_log.


*-----------------------------------------------------------
* Get System Date & Time
*-----------------------------------------------------------
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = lv_date.

    CONCATENATE
      lv_date+0(2)
      lv_date+2(3)
      lv_date+5(4)
    INTO lv_date
    SEPARATED BY '-'.

    CONCATENATE
      sy-uzeit+0(2)
      sy-uzeit+2(2)
    INTO lv_time
    SEPARATED BY ':'.

*-----------------------------------------------------------
* Header
*-----------------------------------------------------------
    DATA l_field_separator TYPE c VALUE cl_abap_char_utilities=>horizontal_tab.

    CONCATENATE
               'SR NO'
               'PR No'
               'Item'
               'Material'
               'Plant'
               'PR Qty'
               'PO Qty'
               'Purch Group'
               'Refresh Date'
               'Refresh Time'
               INTO hd_csv
               SEPARATED BY l_field_separator.



*-----------------------------------------------------------
* Convert table data
*-----------------------------------------------------------
    CLEAR it_csv.

    LOOP AT it_log ASSIGNING <fs_log>.

      WRITE <fs_log>-menge TO lv_menge.
      WRITE <fs_log>-bsmng TO lv_bsmng.

      CONDENSE lv_menge.
      CONDENSE lv_bsmng.

      CONCATENATE
           <fs_log>-sr_no
           <fs_log>-banfn
           <fs_log>-bnfpo
           <fs_log>-matnr
           <fs_log>-werks
           lv_menge
           lv_bsmng
           <fs_log>-ekgrp
           lv_date
           lv_time
      INTO lv_string
      SEPARATED BY l_field_separator.

        APPEND lv_string TO it_csv.


    ENDLOOP.

*-----------------------------------------------------------
* File name
*-----------------------------------------------------------
    lv_file = |ZClosed_PR_{ sy-datum }_{ sy-uzeit }.txt|.

    CONCATENATE '/Delval/India/' lv_file
    INTO lv_fullfile.

*-----------------------------------------------------------
* Write file on Application Server
*-----------------------------------------------------------
    OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

    IF sy-subrc = 0.

      TRANSFER hd_csv TO lv_fullfile.

      LOOP AT it_csv INTO wa_csv.
        TRANSFER wa_csv TO lv_fullfile.
      ENDLOOP.

      CLOSE DATASET lv_fullfile.

      CONCATENATE 'File created on server:' lv_fullfile
      INTO lv_msg SEPARATED BY space.

      MESSAGE lv_msg TYPE 'S'.

    ELSE.

      MESSAGE 'Unable to create file on server' TYPE 'E'.

    ENDIF.


  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* Start Program
*---------------------------------------------------------------------*
START-OF-SELECTION.

  DATA lo_obj TYPE REF TO lcl_close_pr.

  " Create instance of class
  CREATE OBJECT lo_obj.

  " Fetch and process PR data
  lo_obj->fetch_data( ).
  lo_obj->process_data( ).
