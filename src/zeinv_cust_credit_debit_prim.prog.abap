*&---------------------------------------------------------------------*
*& Report ZEINV_CUSTOMER_INV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zeinv_cust_credit_debit_prim MESSAGE-ID zinv_message.

"===============================================================================================
" Golbal Data Delacrations
"===============================================================================================


TABLES : vbrk,vbrp.


DATA : t_fieldcat  TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       wa_fieldcat TYPE slis_t_fieldcat_alv.
CLASS lcl_events DEFINITION DEFERRED.

DATA: row TYPE lvc_s_row,
      col TYPE lvc_s_col.

DATA: con TYPE i.

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

DATA: ok_code   TYPE ui_func.
DATA: gstring   TYPE c.
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
       END OF lty_zeinv_link.


DATA : lt_zeinv_link TYPE STANDARD TABLE OF lty_zeinv_link,
       ls_zeinv_link TYPE lty_zeinv_link.

DATA : lt_jsonfile TYPE STANDARD TABLE OF zstr_jsonfile,
       ls_jsonfile TYPE  zstr_jsonfile.

DATA : lt_jsonfile_multiple TYPE STANDARD TABLE OF zstr_jsonfile,
       ls_jsonfile_multiple TYPE  zstr_jsonfile.


*DATA : lt_docs TYPE STANDARD TABLE OF zstr_vbeln,
*       ls_docs TYPE  zstr_vbeln.



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
         sfakn TYPE vbrk-sfakn,
         xblnr TYPE vbrk-xblnr,
         zuonr TYPE vbrk-vbeln,
         bupla TYPE vbrk-bupla,
       END OF lty_s_vbrk.

DATA : lt_vbrk TYPE STANDARD TABLE OF lty_s_vbrk,
       ls_vbrk TYPE lty_s_vbrk.


TYPES  : BEGIN OF lty_j_1bbranch,
           bukrs  TYPE j_1bbranch-bukrs,
           branch TYPE j_1bbranch-branch,
           gstin  TYPE j_1bbranch-gstin,
         END OF lty_j_1bbranch.


DATA : lt_j_1bbranch TYPE TABLE OF lty_j_1bbranch,
       ls_j_1bbranch TYPE lty_j_1bbranch.

DATA : lt_docs TYPE TABLE OF zstr_vbeln,
       ls_docs TYPE zstr_vbeln.


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


DATA : lt_likp TYPE STANDARD TABLE OF lty_likp,
       ls_likp TYPE lty_likp.


TYPES : BEGIN OF lty_kna1 ,
          kunnr TYPE kna1-kunnr,
          land1 TYPE kna1-land1,
          name1 TYPE kna1-name1,
          pstlz TYPE kna1-pstlz,
          regio TYPE kna1-regio,
          adrnr TYPE kna1-adrnr,
          stcd3 TYPE kna1-stcd3,
        END OF lty_kna1.

DATA: lt_kna1 TYPE TABLE OF lty_kna1,
      ls_kna1 TYPE lty_kna1.


DATA : lt_zeinv_response TYPE STANDARD TABLE OF zeinv_res,
       ls_zeinv_response TYPE zeinv_res.


DATA : lt_tvfkt TYPE STANDARD TABLE OF tvfkt,
       ls_tvfkt TYPE tvfkt.


TYPES : BEGIN OF lty_j_1ig_invrefnum,
          bukrs         TYPE j_1ig_invrefnum-bukrs,
          docno         TYPE j_1ig_invrefnum-docno,
          odn           TYPE j_1ig_invrefnum-odn,
          irn           TYPE j_1ig_invrefnum-irn,
          VERSION       TYPE j_1ig_invrefnum-VERSION,
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


TYPES : BEGIN OF lty_final,
          selection              TYPE char1,
          process_status(70)     TYPE c,
          status_description(20) TYPE c,
          reason(50)             TYPE c,
          kunnr                  TYPE kna1-kunnr,
          name1                  TYPE kna1-name1,
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
          zzirn_no               TYPE zeinv_res-zzirn_no,
          zzack_no               TYPE zeinv_res-zzack_no,
          zzqr_code              TYPE zeinv_res-zzqr_code,
          zzstatus               TYPE zeinv_res-zzstatus,
          zzuser                 TYPE zeinv_res-zzqr_code,
          zzcdate                TYPE zeinv_res-zzcdate,
          zztime                 TYPE zeinv_res-zztime,
          can_doc                TYPE vbrk-vbeln,
          can_reason(100)        TYPE c,
          can_rsn                TYPE zeinv_res-zzcan_rsn,
        END OF lty_final.


DATA : lt_final TYPE STANDARD TABLE OF lty_final,
       ls_final TYPE lty_final.

DATA : lt_zeinv_response_save TYPE STANDARD TABLE OF zeinv_res,
       ls_zeinv_res           TYPE zeinv_res.


CONSTANTS : lc_rfbsk TYPE rfbsk VALUE 'C'.

TYPES  :BEGIN OF lty_range,
          sign TYPE tvarvc-sign,
          opti TYPE tvarvc-opti,
          low  TYPE tvarvc-low,
          high TYPE tvarvc-high,
        END OF lty_range.

DATA : lt_range TYPE TABLE OF lty_range,
       ls_range TYPE lty_range.



"------Declarations for Drop Down list-----------------------------
DATA: it_list     TYPE vrm_values.
DATA: wa_list    TYPE vrm_value.
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
            a2  NO-DISPLAY ,"RADIOBUTTON GROUP r,
            a3 RADIOBUTTON GROUP r,
            a4 NO-DISPLAY. "RADIOBUTTON GROUP r.
SELECTION-SCREEN : END OF BLOCK b2.


*SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
*PARAMETERS: a1  AS CHECKBOX DEFAULT 'X',"RADIOBUTTON GROUP r,
*            a2 NO-DISPLAY,"RADIOBUTTON GROUP r,
*            a3 NO-DISPLAY,"RADIOBUTTON GROUP r,
*            a4 NO-DISPLAY."RADIOBUTTON GROUP r.
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
  wa_list-key = '6'.
  wa_list-text = 'All Documents'.
  APPEND wa_list TO it_list.



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
    CALL SCREEN 100.        "Cockpit Screen
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

    FROM zeinv_link INTO TABLE lt_zeinv_link
    WHERE bukrs IN s_bukrs AND
           vkorg IN s_vkorg AND
           flag NE 'X' AND
            type IN ( 'CRN', 'DBN' ).

  IF lt_zeinv_link IS NOT INITIAL.

    SELECT vbeln fkart vkorg fkdat gjahr rfbsk bukrs ernam erzet erdat sfakn xblnr zuonr bupla
      FROM vbrk INTO TABLE lt_vbrk
      FOR ALL ENTRIES IN lt_zeinv_link
      WHERE fkart EQ lt_zeinv_link-fkart AND
            fkdat IN s_fkdat AND
            vkorg IN s_vkorg AND
*            gjahr EQ @p_gjahr AND
            bukrs = lt_zeinv_link-bukrs AND
            rfbsk = lc_rfbsk AND
           vbeln IN s_vbeln.


    IF lt_vbrk IS NOT INITIAL.

      SELECT
        bukrs
        docno
        odn
        irn
        VERSION
        ack_no
        irn_status
        ernam
        erdat
        erzet
        signed_inv
        signed_qrcode
         FROM j_1ig_invrefnum INTO TABLE lt_j_1ig_invrefnum FOR ALL ENTRIES IN
      lt_vbrk WHERE docno = lt_vbrk-vbeln.

      SELECT
      bukrs branch gstin
       FROM j_1bbranch
            INTO TABLE lt_j_1bbranch
            FOR ALL ENTRIES IN lt_vbrk
            WHERE bukrs = lt_vbrk-bukrs AND
                  branch = lt_vbrk-bupla.

      SELECT vbeln sfakn FROM vbrk INTO TABLE lt_vbrk_can
        FOR ALL ENTRIES IN lt_vbrk
        WHERE  sfakn = lt_vbrk-vbeln.

      SELECT vbeln posnr werks vgbel FROM vbrp INTO TABLE lt_vbrp
        FOR ALL ENTRIES IN lt_vbrk WHERE
         vbeln = lt_vbrk-vbeln.

      SELECT vbeln,posnr,werks,vgbel FROM vbrp INTO TABLE @DATA(lt_vbrp_c)
        FOR ALL ENTRIES IN @lt_vbrk WHERE
         vbeln = @lt_vbrk-zuonr.


      IF lt_vbrp_c[] IS NOT INITIAL.

        SELECT vbeln,posnr,parvw,kunnr,adrnr,land1
          FROM vbpa
          INTO TABLE @DATA(lt_vbpa)
          FOR ALL ENTRIES IN @lt_vbrp_c
          WHERE vbeln = @lt_vbrp_c-vgbel. "and
*

        SELECT vbeln vkorg vstel
          kunnr
          kunag
          FROM likp
          INTO TABLE lt_likp
          FOR ALL ENTRIES IN lt_vbrp_c
          WHERE vbeln = lt_vbrp_c-vgbel.

        IF lt_likp[] IS NOT INITIAL.
          SELECT kunnr land1 name1 pstlz regio adrnr stcd3 FROM kna1
              INTO TABLE lt_kna1
              FOR ALL ENTRIES IN lt_likp
              WHERE kunnr = lt_likp-kunnr.
        ENDIF.

        IF lt_vbpa[] is NOT INITIAL.
          SELECT kunnr,land1,name1,pstlz,regio,adrnr,stcd3 FROM kna1
              INTO TABLE @DATA(lt_kna1_vbpa)
              FOR ALL ENTRIES IN @lt_vbpa
              WHERE kunnr = @lt_vbpa-kunnr.

        ENDIF.

        APPEND LINES OF lt_kna1_vbpa to lt_kna1.
        sort lt_kna1 by kunnr.
        delete ADJACENT DUPLICATES FROM lt_kna1 COMPARING kunnr.



      ENDIF.


      SELECT * FROM zeinv_res INTO TABLE lt_zeinv_response
        FOR ALL ENTRIES IN lt_vbrk
        WHERE vbeln = lt_vbrk-vbeln.

      SELECT * FROM tvfkt INTO TABLE lt_tvfkt FOR ALL ENTRIES IN lt_vbrk
        WHERE spras = 'EN' AND
              fkart = lt_vbrk-fkart.

    ENDIF.

  ELSE.

    MESSAGE 'No data found (Refer ZEINV_LINK )' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
    LEAVE LIST-PROCESSING.

  ENDIF.

  SORT lt_vbrk BY vbeln.
  SORT lt_vbrp BY vbeln.
  SORT lt_vbrk_can BY vbeln.
  SORT lt_zeinv_response BY vbeln .
  SORT lt_j_1ig_invrefnum BY docno VERSION DESCENDING .

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

    READ TABLE lt_vbrp ASSIGNING <lfs_vbrp> WITH KEY
                                                  vbeln = <lfs_vbrk>-vbeln BINARY SEARCH.
    IF sy-subrc EQ 0.
      ls_final-werks = <lfs_vbrp>-werks.
    ENDIF.


    READ TABLE lt_zeinv_link INTO ls_zeinv_link WITH KEY fkart = <lfs_vbrk>-fkart bukrs = <lfs_vbrk>-bukrs.
    IF sy-subrc EQ 0.
     IF ls_zeinv_link-type = 'DBN'.
      READ TABLE lt_vbrp_c ASSIGNING FIELD-SYMBOL(<lfs_vbrp_c>) WITH KEY
                                                       vbeln = <lfs_vbrk>-vbeln.
      IF sy-subrc IS INITIAL.
          READ TABLE lt_vbpa INTO DATA(ls_vbpa) WITH KEY vbeln = <lfs_vbrp_c>-vgbel parvw = 'AG'.
          IF sy-subrc EQ 0.
*            READ TABLE lt_likp INTO ls_likp WITH KEY  kunag = ls_vbpa-kunnr.
*            IF sy-subrc IS INITIAL.
              READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_vbpa-kunnr.
              IF sy-subrc EQ 0.
                ls_final-kunnr = ls_kna1-kunnr.
                ls_final-name1 = ls_kna1-name1.
              ENDIF.
*            ENDIF.
          ENDIF.
        ENDIF.
        ELSEIF ls_zeinv_link-type = 'CRN'.
          READ TABLE lt_vbrp_c ASSIGNING FIELD-SYMBOL(<lfs_vbrp_cd>) WITH KEY
                                                        vbeln = <lfs_vbrk>-zuonr.
          IF sy-subrc EQ 0.
            READ TABLE lt_likp INTO ls_likp WITH KEY  vbeln = <lfs_vbrp_cd>-vgbel.
            IF sy-subrc IS INITIAL.
              READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_likp-kunag.
              IF sy-subrc EQ 0.
                ls_final-kunnr = ls_kna1-kunnr.
                ls_final-name1 = ls_kna1-name1.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.


    READ TABLE lt_tvfkt INTO ls_tvfkt WITH KEY fkart = <lfs_vbrk>-fkart.
    IF sy-subrc EQ 0.
      ls_final-vtext = ls_tvfkt-vtext.
    ENDIF.


    READ TABLE lt_zeinv_response INTO  ls_zeinv_response WITH KEY
                                               vbeln = <lfs_vbrk>-vbeln BINARY SEARCH.
    IF sy-subrc EQ 0.

      ls_final-zzerror_disc = ls_zeinv_response-zzerror_disc.
      ls_final-zzstatus     = ls_zeinv_response-zzstatus.
      ls_final-zzuser       = ls_zeinv_response-zzuser.
      ls_final-zzcdate      = ls_zeinv_response-zzcdate.
      ls_final-zztime       = ls_zeinv_response-zztime.


      IF ls_zeinv_response-zzstatus EQ 'C'.
        ls_final-process_status = '@08\Q Completly Processed@'.
        ls_final-status_description = 'Completly Processed'.
      ELSEIF ls_zeinv_response-zzstatus EQ 'E'.
        ls_final-process_status = '@0A\Q Error!@'.
        ls_final-status_description = 'Error'.
      ELSEIF ls_zeinv_response-zzstatus EQ 'U'.
        ls_final-process_status = '@3J\Q Under Process@'.
        ls_final-status_description = 'Under Process'.
      ELSEIF ls_zeinv_response-zzstatus EQ 'S'.
        ls_final-process_status = '@F9\Q IRN Cancelled@'.
        ls_final-status_description = 'IRN Cancelled'.
      ENDIF.

      IF ls_zeinv_response-zzirn_no IS NOT INITIAL.
        ls_final-zzirn_no = ls_zeinv_response-zzirn_no.
        ls_final-zzerror_disc = ls_zeinv_response-zzerror_disc.
        ls_final-zzack_no = ls_zeinv_response-zzack_no.
        ls_final-zzstatus = ls_zeinv_response-zzstatus.
        ls_final-zzqr_code = ls_zeinv_response-zzqr_code.
        ls_final-zzuser = ls_zeinv_response-zzuser.
        ls_final-zzcdate = ls_zeinv_response-zzcdate.
        ls_final-zztime = ls_zeinv_response-zztime.

      ELSEIF ls_zeinv_response-zzirn_no IS INITIAL.
        READ TABLE lt_j_1ig_invrefnum ASSIGNING FIELD-SYMBOL(<lfs_j_1ig_invrefnum>) WITH KEY docno = <lfs_vbrk>-vbeln BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_final-zzirn_no = <lfs_j_1ig_invrefnum>-irn.
          ls_final-zzack_no = <lfs_j_1ig_invrefnum>-ack_no.
*       ls_final-zzstatus = ls_zeinv_response-zzstatus.
          ls_final-zzqr_code = <lfs_j_1ig_invrefnum>-signed_qrcode.
          ls_final-zzuser = <lfs_j_1ig_invrefnum>-ernam.
          ls_final-zzcdate = <lfs_j_1ig_invrefnum>-erdat.
          ls_final-zztime = <lfs_j_1ig_invrefnum>-erzet.

          IF <lfs_j_1ig_invrefnum>-irn_status EQ 'ACT'.
            ls_final-process_status = '@08\Q Completly Processed@'.
            ls_final-status_description = 'Completly Processed'.
            ls_final-zzerror_disc = 'E-Invoice Successfully Generated'.
          ELSEIF <lfs_J_1IG_INVREFNUM>-irn_status EQ 'CNL'.
            ls_final-process_status     = '@F9\Q IRN Cancelled@'.
            ls_final-status_description = 'IRN Cancelled'.
            ls_final-zzerror_disc       = 'E-Invoice Cancelled Successfully!'.
          ELSEIF ls_zeinv_response-zzstatus EQ 'ERR'.
            ls_final-process_status = '@0A\Q Error!@'.
            ls_final-status_description = 'Error'.
          ENDIF.
        ENDIF.
      ENDIF.


    ELSE.
      ls_final-process_status = '@5D\Q Not Processed@'.
      ls_final-status_description = 'Not Processed'.
    ENDIF.

    APPEND ls_final TO lt_final.
    CLEAR: ls_final , ls_zeinv_response , ls_zeinv_response.

  ENDLOOP.

  CLEAR :  lt_zeinv_response.



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

  CLEAR : lv_line, lv_notpi,lv_undi,lv_irni,lv_cani,lv_notp,lv_und,lv_irn,lv_can,lv_erri,lv_err.


*  WAIT UP TO 1 SECONDS.

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
      <lfs_status>-zzerror_disc = ls_zeinv_response-zzerror_disc.
      <lfs_status>-zzstatus     = ls_zeinv_response-zzstatus.
      <lfs_status>-zzuser       = ls_zeinv_response-zzuser.
      <lfs_status>-zzcdate      = ls_zeinv_response-zzcdate.
      <lfs_status>-zztime       = ls_zeinv_response-zztime.



      IF ls_zeinv_response-zzstatus EQ 'C'." OR ls_zeinv_response-zzirn_no IS NOT INITIAL.
        <lfs_status>-process_status     = '@08\Q Completly Processed@'.
        <lfs_status>-status_description = 'Completly Processed'.
        lv_irni = lv_irni + 1.
      ELSEIF ls_zeinv_response-zzstatus EQ 'E'.
        <lfs_status>-process_status     = '@0A\Q Error!@'.
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
        <lfs_status>-zzirn_no     = ls_zeinv_response-zzirn_no.
        <lfs_status>-zzerror_disc = ls_zeinv_response-zzerror_disc.
        <lfs_status>-zzack_no     = ls_zeinv_response-zzack_no.
        <lfs_status>-zzstatus     = ls_zeinv_response-zzstatus.
        <lfs_status>-zzqr_code    = ls_zeinv_response-zzqr_code.
        <lfs_status>-zzuser       = ls_zeinv_response-zzuser.
        <lfs_status>-zzcdate      = ls_zeinv_response-zzcdate.
        <lfs_status>-zztime       = ls_zeinv_response-zztime.

      ELSEIF ls_zeinv_response-zzirn_no IS INITIAL.

        READ TABLE lt_j_1ig_invrefnum ASSIGNING FIELD-SYMBOL(<lfs_j_1ig_invrefnum>) WITH KEY docno = <lfs_status>-vbeln BINARY SEARCH.
        IF sy-subrc EQ 0.
          <lfs_status>-zzirn_no  = <lfs_j_1ig_invrefnum>-irn.
          <lfs_status>-zzack_no  = <lfs_j_1ig_invrefnum>-ack_no.
          <lfs_status>-zzqr_code = <lfs_j_1ig_invrefnum>-signed_qrcode.
          <lfs_status>-zzuser    = <lfs_j_1ig_invrefnum>-ernam.
          <lfs_status>-zzcdate   = <lfs_j_1ig_invrefnum>-erdat.
          <lfs_status>-zztime    = <lfs_j_1ig_invrefnum>-erzet.


          IF <lfs_j_1ig_invrefnum>-irn_status EQ 'ACT'.
            <lfs_status>-process_status     = '@08\Q Completly Processed@'.
            <lfs_status>-status_description = 'Completly Processed'.
            <lfs_status>-zzerror_disc       = 'E-Invoice Successfully Generated'.
          ELSEIF <lfs_J_1IG_INVREFNUM>-irn_status EQ 'CNL'.
            <lfs_status>-process_status     = '@F9\Q IRN Cancelled@'.
            <lfs_status>-status_description = 'IRN Cancelled'.
            <lfs_status>-zzerror_disc       = 'E-Invoice Cancelled Successfully!'.
          ELSEIF ls_zeinv_response-zzstatus EQ 'ERR'.
            <lfs_status>-process_status     = '@0A\Q Error!@'.
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
BREAK primus.
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

  DATA : lv_msg           TYPE string,
         lv_ucomm         TYPE sy-ucomm,
         lv_gjahr         TYPE gjahr,
         lv_msg_reason    TYPE string,
         lv_mode          TYPE flag,
         lvs_data         TYPE string,
         lv_gstin         TYPE stcd3,
         lv_selected_docs TYPE i,
         lv_counter       TYPE i.






  CASE sy-ucomm.

      "===============================================================================================
      "Start of IRN Genertation
      "===============================================================================================
BREAK PRIMUS.
    WHEN '&IRN'.

      DATA : lv_status TYPE string,
             lt_retmsg TYPE STANDARD TABLE OF bapiret2.

      lv_ucomm = '&IRN'.

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

            CALL FUNCTION 'ZJSON_FILE_SAVE_CUST_CR_DB'
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



        ELSE.


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


            IF a3 = 'X'.
              IF ls_zeinv_res IS NOT INITIAL.
                MODIFY zeinv_res FROM ls_zeinv_res.
                COMMIT WORK.
              ENDIF.
            ENDIF.
            CALL FUNCTION 'GET_CURRENT_YEAR'
              EXPORTING
                bukrs = ' '
                date  = ls_final-fkdat
              IMPORTING
                curry = lv_gjahr.
            IF a3 = 'X'.
              lv_mode  = 'X'.
            ENDIF.

            "===============================================================================================
            "FM to Generate Json file data
            "===============================================================================================
            CALL FUNCTION 'ZJSON_FILE_SAVE_CUST_CR_DB'
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

            CLEAR sy-ucomm.
            "===============================================================================================
            "End of FM to generate Json file data
            "===============================================================================================


            IF lt_jsonfile IS NOT INITIAL.
              IF a1 = abap_true.   " Manual Generation
                PERFORM manual_irn_generation." TABLES lt_jsonfile .

              ELSEIF a2 = abap_true.  " using FTP
                PERFORM irn_using_ftp USING ls_final-vbeln.

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
                PERFORM irn_using_api USING ls_final-vbeln.

              ELSEIF a4 = abap_true. "---PrimEBrdige Application

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
            CONCATENATE ' Please Enter remark for Cancelation ' ls_final-vbeln INTO lv_msg_reason SEPARATED BY space.
            MESSAGE lv_msg_reason TYPE 'E'.
            LEAVE LIST-PROCESSING.
          ENDIF.
          IF ls_final-can_rsn IS INITIAL.
            CONCATENATE ' Please Enter reason for Cancelation ' ls_final-vbeln INTO lv_msg_reason SEPARATED BY space.
            MESSAGE lv_msg_reason TYPE 'E'.
            LEAVE LIST-PROCESSING.
          ENDIF.
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
        IF sy-subrc EQ 0 AND ( ls_zeinv_check-zzstatus = 'C' OR ls_zeinv_check-zzstatus = 'E' ) .
          ls_zeinv_check-zzcan_reason = ls_final-can_reason.
          ls_zeinv_check-zzcan_reason = ls_final-can_rsn.
          MODIFY zeinv_res FROM ls_zeinv_check.
          COMMIT WORK.


          "========================="FM to Generate Data into Json Format================================

          CALL FUNCTION 'ZJSON_FILE_SAVE_CUST_CR_DB'
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

            ELSEIF a4 = abap_true.
              IF lt_jsonfile IS NOT INITIAL.
                LOOP AT lt_jsonfile INTO ls_jsonfile.
                  CONCATENATE  lvs_data ls_jsonfile-line  INTO lvs_data.
                ENDLOOP.
              ENDIF.

              PERFORM cancel_irn_using_rfc USING ls_final-vbeln lvs_data ls_final-gstin.  "--Call .NET RFC.

              CLEAR: lvs_data.
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

*      DATA lw_lvc_s_stbl TYPE lvc_s_stbl.

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
      ENDIF.

      SUBMIT sd70av3a WITH rg_vbeln IN lt_range AND RETURN.

      CLEAR lt_range.

      "===============================================================================================
      "End of Print
      "===============================================================================================



    WHEN 'EXIT' OR 'BACK'.
      SET SCREEN '0'.
      LEAVE SCREEN.

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
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Status'.
*  lv_fldcat-key = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'STATUS_DESCRIPTION'.
  lv_fldcat-tabname   = 'LT_FINAL'.
  lv_fldcat-outputlen = 20.
*  lv_fldcat-edit      = 'X'.
  lv_fldcat-scrtext_m = 'Status Description'.
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
  lv_fldcat-scrtext_m = 'Cancelation Reason'.
*  lv_fldcat-key = 'X'.
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
  lv_fldcat-scrtext_m = 'Document Type'.
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



  g_stxbmaps-tdobject = 'GRAPHICS'.
  g_stxbmaps-tdname = 'ZJAI_COL' .           "'ZPRIM'.            "'ZJAI1_COL'.
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


  "update z table---------------------

*   ls_zeinv_res-zzstatus = 'U'.         "Under Process
*
*  IF ls_zeinv_res IS NOT INITIAL.
*    MODIFY zeinv_res FROM ls_zeinv_res.
*    COMMIT WORK.
*  ENDIF.


**DOWNLOAD FILE
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = file_name
    CHANGING
      data_tab = lt_jsonfile
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE i003 WITH file_name.
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
  DATA : ls_vbrk1 TYPE VBRK.
  DATA : lv_ackdt_s(10)    TYPE c,
         lv_ack_tm_s(08) TYPE c,
         lv_ack_dt      TYPE zzack_date1.
  DATA : LS_INVREFNUM TYPE J_1IG_INVREFNUM.
   DATA :lc_mode1            TYPE enqmode VALUE 'E',
         lc_invrefnum TYPE tabname VALUE 'J_1IG_INVREFNUM',
         lc_EWAY_NUMBER TYPE tabname VALUE 'ZEWAY_NUMBER'.

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


CONCATENATE '{"action": "GENERATEIRN", "data":' ls_str '}' INTO lS_STR.
REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
CONCATENATE ls_str '}' INTO lS_STR.
REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
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

xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.


DATA lv_url TYPE string.
 lv_url = 'https://gsthero.com/einvoice/v1.03/invoice'.

  cl_http_client=>create_by_url(
   EXPORTING
   url = lv_url
   IMPORTING
   client = DATA(lo_http_client)
   EXCEPTIONS
   argument_not_found = 1
   plugin_not_active = 2
   internal_error = 3
   OTHERS = 4 ).


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
   name =  'Authorization'
   value = tokan ) .

  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'Action'
   value = 'GENERATEIRN' ) .


  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'gstin'
   value = '27AACCD2898L1Z4' ).

  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'X-Connector-Auth-Token'
   value = xconn ) .


  lo_http_client->request->set_method(
   EXPORTING
   method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
   EXPORTING
   content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
   EXPORTING
   data =  ls_str ) .


  lo_http_client->send(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2
   http_processing_failed = 3 ).


  CHECK sy-subrc = 0.
  DATA(lv_response) = lo_http_client->response->get_cdata( ).


  REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.

  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 1000 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.

  READ TABLE lt_res INTO ls_res WITH KEY HEADER = 'status'.                "INDEX 5.
  IF SY-SUBRC EQ 0.
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

IF SY-SUBRC EQ 0.

        IF lv_resp_status EQ '1'.
              LOOP AT lt_res INTO ls_res.

                  CASE LS_RES-header.
                      WHEN 'AckNo'.
                          ls_zeinv_res-zzack_no = ls_res-value.
                          ls_invrefnum-ack_no = LS_RES-VALUE.
                      WHEN 'AckDt'.
                          SPLIT ls_res-value AT space INTO lv_ackdt_s lv_ack_tm_s.
                          REPLACE ALL OCCURRENCES OF '-' IN lv_ackdt_s WITH space.
                          CONDENSE lv_ackdt_s NO-GAPS.
                          lv_ack_dt = lv_ackdt_s.
                          ls_zeinv_res-zzack_date = lv_ack_dt.
                          LS_INVREFNUM-ack_date = LV_ACK_DT.
                     WHEN 'Irn'.
                         IF ls_zeinv_res-zzirn_no IS INITIAL.
                             ls_zeinv_res-zzirn_no = ls_res-value.
                             LS_INVREFNUM-irn = ls_res-value.
                         ENDIF.
                     WHEN 'SignedInvoice'.
                          ls_zeinv_res-zzsign_inv = ls_res-value.
                          LS_INVREFNUM-signed_inv = ls_res-value.
                     WHEN 'SignedQRCode'.
                          ls_zeinv_res-zzqr_code = ls_res-value.
                          LS_INVREFNUM-signed_qrcode = ls_res-value.
                     WHEN 'status'.
                          ls_zeinv_res-zzerror_disc = 'E-INVOICE GENERATED SUCCESSFULLY!'.
                          LS_INVREFNUM-irn_status = LS_RES-VALUE.
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
           IF LS_INVREFNUM IS NOT INITIAL.

                  SELECT SINGLE *
                  FROM vbrk INTO ls_vbrk1
                  WHERE vbeln = lvs_vbeln.

                   LS_INVREFNUM-version       = '001'.
                   ls_invrefnum-docno         = lvs_vbeln.
                   LS_INVREFNUM-bukrs         = ls_vbrk1-bukrs.
                   LS_INVREFNUM-doc_year      = ls_vbrk1-gjahr.
                   LS_INVREFNUM-doc_type      = ls_vbrk1-fkart.
                   LS_INVREFNUM-odn           = ls_vbrk1-xblnr.
                   LS_INVREFNUM-bupla         = ls_vbrk1-bupla.
                   LS_INVREFNUM-odn_date      = ls_vbrk1-fkdat.
                   LS_INVREFNUM-ernam         = ls_vbrk1-ernam.
                   LS_INVREFNUM-erdat         = ls_vbrk1-erdat.
                   LS_INVREFNUM-erzet         = ls_vbrk1-erzet.
                   LS_INVREFNUM-irn_status    = 'ACT'.

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
                      MODIFY j_1ig_invrefnum FROM LS_INVREFNUM.
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
                  ls_zeinv_res-zzerror_disc = LS_RES-value.
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
    ls_vbrk           TYPE ty_str,
    ls_str            TYPE j_1ig_invrefnum,
    ls_ewaybill       TYPE j_1ig_ewaybill,
    ls_zeinv_res      TYPE zeinv_res,
    ls_zeinv_res_fb70 TYPE zeinv_res_fb70,
    lv_fy(4)          TYPE c,
    lv_date           TYPE datum,
    lv_response_msg   TYPE string,
    lv_ack_date_s(10) TYPE c,
    lv_ack_time_s(08) TYPE c,
    lv_ack_date       TYPE zzack_date1.



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

    CALL FUNCTION 'ZEINV_SEND_DATA'   "--Call Remote Enabled Function Module to Connect with .NET Application
      DESTINATION 'PSERVER'            "--SM59 TCP/IP Destination
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
      ls_zeinv_res-zzdoc_type = 'CDN'.
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


      IF sy-subrc EQ 0.
*        TEST-SEAM non_exe.
          MODIFY zeinv_res FROM ls_zeinv_res .
          MODIFY j_1ig_invrefnum FROM ls_str.

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

      ENDIF.

      CLEAR: ls_str,lv_date.
      CLEAR : lv_ack_date,
              lv_ack_date_s.


      "--Error during IRN Generation

    ELSEIF ack_no IS INITIAL AND irn_status IS INITIAL AND sy-subrc NE 0 AND sy-msgv1 IS NOT INITIAL.

      ls_zeinv_res-mandt      = sy-mandt.
      ls_zeinv_res-vbeln      = ls_final-vbeln.
      ls_zeinv_res-fkdat      = ls_final-fkdat.
      ls_zeinv_res-xblnr      = ls_final-xblnr.
      ls_zeinv_res-werks      = ls_final-werks.
      ls_zeinv_res-zzack_no   = ack_no.
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



    WAIT UP TO 1 SECONDS.

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

DATA : ls_vbrk1 TYPE VBRK.
  DATA : lv_ackdt_s(10)    TYPE c,
         lv_ack_tm_s(08) TYPE c,
         lv_ack_dt      TYPE zzack_date1.
  DATA : LS_INVREFNUM TYPE J_1IG_INVREFNUM.
   DATA :lc_mode1            TYPE enqmode VALUE 'E',
         lc_invrefnum TYPE tabname VALUE 'J_1IG_INVREFNUM',
         lc_zeinv_res TYPE tabname VALUE 'ZEINV_RES',
         lc_EWAY_NUMBER TYPE tabname VALUE 'ZEWAY_NUMBER'.


  LOOP AT lt_jsonfile INTO ls_jsonfile.
    CONCATENATE  ls_str ls_jsonfile-line  INTO ls_str.
  ENDLOOP.


CONCATENATE '{"action": "CANCELIRN", "data":' ls_str '}' INTO lS_STR.
REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
CONCATENATE ls_str '}' INTO lS_STR.
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

xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.

DATA lv_url TYPE string.

lv_url = 'https://gsthero.com/einvoice/v1.03/invoice/cancel'.

  cl_http_client=>create_by_url(
   EXPORTING
   url = lv_url   "'http://logibrickseway.azurewebsites.net/TransactionAPI/CancelEInvoice' "'lv_url
   IMPORTING
   client = DATA(lo_http_client)
   EXCEPTIONS
   argument_not_found = 1
   plugin_not_active = 2
   internal_error = 3
   OTHERS = 4 ).

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
   name =  'Authorization'
   value = tokan ) .

  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'Action'
   value = 'CANCELIRN' ) .


  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'gstin'
   value = '27AACCD2898L1Z4' ).

  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'X-Connector-Auth-Token'
   value = xconn ) .

lo_http_client->request->set_method(
   EXPORTING
   method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
   EXPORTING
   content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
   EXPORTING
   data =  ls_str ) .


  lo_http_client->send(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2
   http_processing_failed = 3 ).

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
READ TABLE lt_res INTO ls_res WITH KEY HEADER = 'status'.                "INDEX 5.
  IF SY-SUBRC EQ 0.
    lv_resp_status = ls_res-value.
    ls_vbeln = lvs_vbeln.

  ENDIF.


  "---update data in z table-------------------------------

  SELECT SINGLE * FROM zeinv_res INTO ls_zeinv_res
    WHERE vbeln = lvs_vbeln.  "            vbeln = ls_vbeln.

  IF sy-subrc EQ 0.


    IF lv_resp_status EQ '1'.                        "IRN CANCELLATION
          LOOP AT lt_res INTO ls_res.
            CASE LS_RES-header.
                WHEN 'Irn'.
                   IF ls_zeinv_res-zzirn_no IS INITIAL.
                      ls_zeinv_res-zzirn_no = ls_res-value.
                      LS_INVREFNUM-irn = ls_res-value.
                   ENDIF.
                 WHEN 'CancelDate'.
                       SPLIT ls_res-value AT space INTO lv_ackdt_s lv_ack_tm_s.
                       REPLACE ALL OCCURRENCES OF '-' IN lv_ackdt_s WITH space.
                       CONDENSE lv_ackdt_s NO-GAPS.
                       lv_ack_dt = lv_ackdt_s.
                      ls_zeinv_res-zzcan_date = lv_ack_dt.
                      LS_INVREFNUM-cancel_date = lv_ack_dt.
                WHEN OTHERS.
              ENDCASE.
         ENDLOOP.


              IF ls_zeinv_res IS NOT INITIAL.
                 LS_INVREFNUM-irn = ls_zeinv_res-zzirn_no.
                 ls_invrefnum-ack_no = ls_zeinv_res-zzack_no.
                 LS_INVREFNUM-ack_date = ls_zeinv_res-zzack_date.
                 LS_INVREFNUM-signed_inv = ls_zeinv_res-zzsign_inv.
                 LS_INVREFNUM-signed_qrcode = ls_zeinv_res-zzqr_code.
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
         IF LS_INVREFNUM IS NOT INITIAL.
                  SELECT SINGLE *
                  FROM vbrk INTO ls_vbrk1
                  WHERE vbeln = lvs_vbeln.

                   LS_INVREFNUM-version       = '001'.
                   ls_invrefnum-docno         = lvs_vbeln.
                   LS_INVREFNUM-bukrs         = ls_vbrk1-bukrs.
                   LS_INVREFNUM-doc_year      = ls_vbrk1-gjahr.
                   LS_INVREFNUM-doc_type      = ls_vbrk1-fkart.
                   LS_INVREFNUM-odn           = ls_vbrk1-xblnr.
                   LS_INVREFNUM-bupla         = ls_vbrk1-bupla.
                   LS_INVREFNUM-odn_date      = ls_vbrk1-fkdat.
                   LS_INVREFNUM-ernam         = ls_vbrk1-ernam.
                   LS_INVREFNUM-erdat         = ls_vbrk1-erdat.
                   LS_INVREFNUM-erzet         = ls_vbrk1-erzet.
                   LS_INVREFNUM-irn_status    = 'CAN'.

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
                      MODIFY j_1ig_invrefnum FROM LS_INVREFNUM.
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
                  ls_zeinv_res-zzerror_disc = LS_RES-value.
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
*      -->P_LS_FINAL_GSTIN  text
*----------------------------------------------------------------------*
FORM cancel_irn_using_rfc  USING    p_vbeln TYPE vbeln
                                    ls_data TYPE string
                                    p_gstin TYPE stcd3.

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
    lv_err_msg        TYPE string.

  CONSTANTS:
    lc_mode            TYPE enqmode VALUE 'E',
    lc_j_1ig_invrefnum TYPE tabname VALUE 'J_1IG_INVREFNUM',
    lc_zeinv_res       TYPE tabname VALUE 'ZEINV_RES',
    lc_zeinv_res_fb70  TYPE tabname VALUE 'ZEINV_RES_FB70',
    lc_periv           TYPE periv VALUE 'V3'.


  "==================RECIEVED DATA FROM .NET APPLICATION==========================================
  DATA : can_date TYPE j_1ig_invrefnum-cancel_date.
  DATA : irn TYPE j_1ig_invrefnum-irn.
  "===============================================================================================


  IF ls_data IS NOT INITIAL.   "--Check jsonfile data exists or not

    "===============================================================================================
    "FM TO CONNECT WITH .NET APPLICATION
    "===============================================================================================

    CALL FUNCTION 'ZCANCEL_INR' "--Call Remote Enabled Function Module to Connect with .NET Application
      DESTINATION 'PSERVER'        "--"--SM59 TCP/IP Destination
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

    "===============================================================================================
    "===============================================================================================


    "--update tables
    IF  sy-subrc EQ 0.       "--'ACT' Status = IRN Generated. "irn_status = 'ACT' AND

      SELECT SINGLE vbeln bukrs gjahr fkart xblnr bupla fkdat ernam erdat erzet
        FROM vbrk INTO ls_vbrk
        WHERE vbeln = p_vbeln.

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
          zzcan_date = can_date
          zzirn_no = irn
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
          zzstatus = 'E'        "IRN Cancelation Failed
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
DATA : LS_H1 TYPE STRING,
       LS_H2 TYPE STRING,
       LS_HEADER TYPE zeinv_api.
DATA: lv_header TYPE string.
TYPES : BEGIN OF ty_auth,
        auth TYPE string,
        accept TYPE string,
        gstin TYPE string,
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
             SPLIT ls_jsonfile-line AT ':' INTO ls_H1 ls_H2.
             SPLIT ls_H2 AT ':' INTO ls_H1 ls_H2.
             REPLACE ALL OCCURRENCES OF ',' IN ls_H2 WITH ' '.
             CONDENSE ls_H2.
      ENDIF.
  ENDLOOP.
SELECT SINGLE * FROM zeinv_api
  INTO LS_HEADER WHERE GSTIN EQ ls_H2.

BREAK primus.

**********************************************************GST Hero Tokan**********************************
ls_auth-auth = 'Basic NDg3YWM4MGEwN2Y2MDM5YzEyOWZlN2MyN2IxMmNiY2Y6ZWtKVU5USHpZSw=='.
ls_auth-accept = 'application/json'.
ls_auth-gstin = '27AACCD2898L1Z4'. "ls_H2
DATA lv_url1 TYPE string.
lv_url1 = 'https://gsthero.com/auth-server/oauth/token'.

  cl_http_client=>create_by_url(
   EXPORTING
   url = lv_url1 "LV_URL   "LV_URL  'https://einvoicing.internal.cleartax.co/v2/eInvoice/generate'
   IMPORTING
   client = DATA(lo_http_client)
   EXCEPTIONS
   argument_not_found = 1
   plugin_not_active = 2
   internal_error = 3
   OTHERS = 4 ).

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
   name =  'Content-Type'
   value = 'application/x-www-form-urlencoded' ) .

  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'Authorization'
   value = ls_auth-auth ) .                              "lv_owid  "0bb45513-b359-48ba-9f5c-315796852950
*   value = '0bb45513-b359-48ba-9f5c-315796852950' ) .                              "lv_owid  "0bb45513-b359-48ba-9f5c-315796852950

   lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'gstin'
   value = ls_auth-gstin ).

DATA:pay TYPE string.

*pay = 'grant_type={password}&username={erp1@perennialsys.com}&password={einv12345}&client_id={testerpclient}&scope={einvauth}'.
pay = 'grant_type=password&username=stathe@delvalflow.com&password=India@12345&client_id=487ac80a07f6039c129fe7c27b12cbcf&scope=einvauth'.


lo_http_client->request->set_cdata(
   EXPORTING
   data =  pay ) .

  lo_http_client->send(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2
   http_processing_failed = 3 ).


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
lv_url2 = 'https://gsthero.com/einvoice/v1.03/authentication'."'http://35.154.208.8:8080/einvoice/v1.00/authentication'.
cl_http_client=>create_by_url(
   EXPORTING
   url = lv_url2
   IMPORTING
   client = DATA(lo_http_client1)
   EXCEPTIONS
   argument_not_found = 1
   plugin_not_active = 2
   internal_error = 3
   OTHERS = 4 ).

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
   name =  'Content-Type'
   value = 'application/json' ) .


DATA :auth TYPE string.

DATA xconn TYPE string.
CLEAR :xconn,auth.

xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.


READ TABLE lt_res_tokan INTO ls_res_tokan INDEX 1 .
auth = ls_res_tokan-value.
READ TABLE lt_res_tokan INTO ls_res_tokan INDEX 2 .
CONCATENATE 'Bearer' auth INTO auth SEPARATED BY space.
*CONDENSE auth.

   lo_http_client1->request->set_header_field(            "
   EXPORTING
   name =  'Authorization'
   value = auth ) .


  lo_http_client1->request->set_header_field(            "
   EXPORTING
   name =  'X-Connector-Auth-Token'
   value = xconn ) .


   lo_http_client1->request->set_header_field(            "
   EXPORTING
   name =  'Action'
   value = 'ACCESSTOKEN' ) .

  lo_http_client1->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client1->request->set_header_field(            "
   EXPORTING
   name =  'gstin'
   value = ls_auth-gstin ).


DATA:aut_tokan TYPE string.
DATA ls_json TYPE string.

CLEAR: aut_tokan,ls_json.
*aut_tokan = '{"action":"ACCESSTOKEN","username":"perennialsystems","password":"p3r3nn!@1"}'.

wa_auth-action   = 'ACCESSTOKEN'.
wa_auth-username = 'DELVALFLOW_API_123'.
wa_auth-password = 'gsthero@12345'.
APPEND wa_auth TO it_auth.


ls_json = /ui2/cl_json=>serialize( data = it_auth compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
CLEAR it_auth.
/ui2/cl_json=>deserialize( EXPORTING json = ls_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = it_auth ).

REPLACE ALL OCCURRENCES OF '[' IN ls_json WITH space.
REPLACE ALL OCCURRENCES OF ']' IN ls_json WITH space.
CONDENSE ls_json.

lo_http_client1->request->set_cdata(
   EXPORTING
   data =  ls_json ) .

  lo_http_client1->send(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client1->receive(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2
   http_processing_failed = 3 ).


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
