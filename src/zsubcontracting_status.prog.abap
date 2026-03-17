*&---------------------------------------------------------------------*
*& Report ZSUBCONTRACTING_STATUS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsubcontracting_status.

TYPE-POOLS:slis.

DATA: tmp_lifnr TYPE ekko-lifnr,
      tmp_aedat TYPE ekko-aedat,
      tmp_ekgrp TYPE ekko-ekgrp,
      tmp_ebeln TYPE ekko-ebeln.

TYPES: BEGIN OF t_purchasing_doc,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         aedat TYPE ekko-aedat,
         lifnr TYPE ekko-lifnr,
         ekgrp TYPE ekko-ekgrp,
         frgrl TYPE ekko-frgrl,
       END OF t_purchasing_doc,
       tt_purchasing_doc TYPE STANDARD TABLE OF t_purchasing_doc.

TYPES: BEGIN OF t_purchasing_doc_item,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         ELIKZ TYPE EKPO-ELIKZ,
         LOEKZ TYPE EKPO-LOEKZ,
       END OF t_purchasing_doc_item,
       tt_purchasing_doc_item TYPE STANDARD TABLE OF t_purchasing_doc_item.

TYPES: BEGIN OF t_mat_mast,
         matnr   TYPE mara-matnr,
         zseries TYPE mara-zseries,
         zsize   TYPE mara-zsize,
         brand   TYPE mara-brand,
         moc     TYPE mara-moc,
         type    TYPE mara-type,
       END OF t_mat_mast,
       tt_mat_mast TYPE STANDARD TABLE OF t_mat_mast.

TYPES: BEGIN OF t_vend_mast,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
       END OF t_vend_mast,
       tt_vend_mast TYPE STANDARD TABLE OF t_vend_mast.

TYPES: BEGIN OF t_j_1ig_subcon,
         mblnr    TYPE j_1ig_subcon-mblnr,
         mjahr    TYPE j_1ig_subcon-mjahr,
         zeile    TYPE j_1ig_subcon-zeile,
         chln_inv TYPE j_1ig_subcon-chln_inv,
         item     TYPE j_1ig_subcon-item,
         matnr    TYPE j_1ig_subcon-matnr,
         menge    TYPE j_1ig_subcon-menge,
         bwart    TYPE j_1ig_subcon-bwart,
       END OF t_j_1ig_subcon,
       tt_j_1ig_subcon TYPE STANDARD TABLE OF t_j_1ig_subcon.

TYPES: BEGIN OF t_mat_doc,
         mblnr TYPE mseg-mblnr,
         mjahr TYPE mseg-mjahr,
         zeile TYPE mseg-zeile,
         ebeln TYPE mseg-ebeln,
         ebelp TYPE mseg-ebelp,
         bwart TYPE mseg-bwart,
         menge TYPE mseg-menge,
       END OF t_mat_doc,
       tt_mat_doc TYPE STANDARD TABLE OF t_mat_doc.


TYPES: BEGIN OF t_final,
         name1         TYPE lfa1-name1,
         lifnr         TYPE lfa1-lifnr,
         aedat         TYPE char10,
         ebeln         TYPE ekko-ebeln,
         ekgrp         TYPE ekko-ekgrp,
         ebelp         TYPE ekpo-ebelp,
         matnr         TYPE ekpo-matnr,
         long_txt      TYPE char100,
         menge         TYPE ekpo-menge,
         meins         TYPE ekpo-meins,
         ELIKZ         TYPE EKPO-ELIKZ,
         LOEKZ         TYPE EKPO-LOEKZ,
         status        TYPE char3,
         dev_crd       TYPE mseg-menge,       "added by AG 11.01.2018
         pen_qty       TYPE mseg-menge,       "added by AG 11.01.2018
         ch_qty        TYPE mseg-menge,       "added by AG 11.01.2018
         men_541_final TYPE mseg-menge,       "added by AG 17.01.2018
         ch_qty_1      TYPE mseg-menge,       "added by AG 11.01.2018
         zseries       TYPE mara-zseries,
         zsize         TYPE mara-zsize,
         brand         TYPE mara-brand,
         moc           TYPE mara-moc,
         type          TYPE mara-type,
         bwart         TYPE mseg-bwart,
         men_541       TYPE mseg-menge,       "added by AG 11.01.2018
         men_541_1     TYPE mseg-menge,       "added by AG 11.01.2018
         men_542       TYPE mseg-menge,       "added by AG 11.01.2018
         rec_101       TYPE mseg-menge,       "added by AG 11.01.2018
         sen_102       TYPE mseg-menge,       "added by AG 11.01.2018
         sum_rs        TYPE mseg-menge,       "added by AG 11.01.2018
         mblnr         TYPE mseg-mblnr,       "added by AG 12.01.2018
       END OF t_final,
       tt_final TYPE STANDARD TABLE OF t_final.

DATA: gt_final TYPE tt_final.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
SELECT-OPTIONS: so_lifnr FOR tmp_lifnr,
                so_aedat FOR tmp_aedat,
                so_ekgrp FOR tmp_ekgrp,
                so_ebeln FOR tmp_ebeln.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE abc .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

INITIALIZATION.
  xyz = 'Select Options'(tt1).
  abc = 'Download File'(tt2).

START-OF-SELECTION.
  PERFORM fetch_data CHANGING gt_final.
  PERFORM display    USING gt_final.

*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM fetch_data  CHANGING ct_final TYPE tt_final.
  DATA: lt_purchasing_doc      TYPE tt_purchasing_doc,
        ls_purchasing_doc      TYPE t_purchasing_doc,
        lt_purchasing_doc_item TYPE tt_purchasing_doc_item,
        ls_purchasing_doc_item TYPE t_purchasing_doc_item,
        lt_mat_mast            TYPE tt_mat_mast,
        ls_mat_mast            TYPE t_mat_mast,
        lt_vend_mast           TYPE tt_vend_mast,
        ls_vend_mast           TYPE t_vend_mast,
        lt_j_1ig_subcon        TYPE tt_j_1ig_subcon,
        ls_j_1ig_subcon        TYPE t_j_1ig_subcon,
        lt_mat_doc             TYPE tt_mat_doc,
        ls_mat_doc             TYPE t_mat_doc,
        ls_final               TYPE t_final.

  DATA: lt_stb   TYPE STANDARD TABLE OF stpox,
        ls_stb   TYPE stpox,
        lv_id    TYPE thead-tdname,
        lt_lines TYPE STANDARD TABLE OF tline,
        ls_lines TYPE tline,
        lv_index TYPE sy-tabix.


  SELECT ebeln
         bukrs
         aedat
         lifnr
         ekgrp
         frgrl
    FROM ekko
    INTO TABLE lt_purchasing_doc
    WHERE ebeln IN so_ebeln
    AND   aedat IN so_aedat
    AND   lifnr IN so_lifnr
    AND   ekgrp IN so_ekgrp
    AND   bsart = 'ZSUB'.

  IF NOT sy-subrc IS INITIAL.
    MESSAGE 'Data Not Found' TYPE 'E'.
  ENDIF.

  IF NOT lt_purchasing_doc IS INITIAL.
    SELECT ebeln
           ebelp
           matnr
           werks
           menge
           meins
           ELIKZ
           LOEKZ
      FROM ekpo
      INTO TABLE lt_purchasing_doc_item
      FOR ALL ENTRIES IN lt_purchasing_doc
      WHERE ebeln = lt_purchasing_doc-ebeln
      AND   elikz = ''. " OR LOEKZ = ''.

    SELECT matnr
           zseries
           zsize
           brand
           moc
           type
      FROM mara
      INTO TABLE lt_mat_mast
      FOR ALL ENTRIES IN lt_purchasing_doc_item
      WHERE matnr = lt_purchasing_doc_item-matnr.

    SELECT lifnr
           name1
      FROM lfa1
      INTO TABLE lt_vend_mast
      FOR ALL ENTRIES IN lt_purchasing_doc
      WHERE lifnr = lt_purchasing_doc-lifnr.

    SELECT
      mblnr
      mjahr
      zeile
      ebeln
      ebelp
      bwart
      menge
     FROM mseg
     INTO TABLE lt_mat_doc
     FOR ALL ENTRIES IN lt_purchasing_doc
     WHERE ebeln = lt_purchasing_doc-ebeln.

    SELECT mblnr
           mjahr
           zeile
           chln_inv
           item
           matnr
           menge
           bwart
      FROM j_1ig_subcon
      INTO TABLE lt_j_1ig_subcon
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE mblnr = lt_mat_doc-mblnr
      AND   mjahr = lt_mat_doc-mjahr.

    SORT lt_j_1ig_subcon BY mblnr mjahr.
    DELETE ADJACENT DUPLICATES FROM lt_j_1ig_subcon COMPARING mblnr mjahr.
  ENDIF.

  SORT lt_mat_doc BY mblnr mjahr.
  DELETE ADJACENT DUPLICATES FROM lt_mat_doc COMPARING mblnr mjahr.
  SORT lt_mat_doc BY ebeln ebelp.

  LOOP AT lt_purchasing_doc_item INTO ls_purchasing_doc_item.
    ls_final-ebeln = ls_purchasing_doc_item-ebeln.
    ls_final-ebelp = ls_purchasing_doc_item-ebelp.
    ls_final-matnr = ls_purchasing_doc_item-matnr.
    ls_final-menge = ls_purchasing_doc_item-menge.
    ls_final-meins = ls_purchasing_doc_item-meins.

    READ TABLE lt_purchasing_doc INTO ls_purchasing_doc WITH KEY ebeln = ls_purchasing_doc_item-ebeln.
    IF sy-subrc IS INITIAL.
      CONCATENATE ls_purchasing_doc-aedat+6(2) ls_purchasing_doc-aedat+4(2) ls_purchasing_doc-aedat+0(4)
                          INTO ls_final-aedat SEPARATED BY '-'.

      ls_final-lifnr  = ls_purchasing_doc-lifnr.
      ls_final-ekgrp  = ls_purchasing_doc-ekgrp.
      IF ls_purchasing_doc-frgrl NE 'X'.
        ls_final-status = 'Yes'.
      ELSE.
        ls_final-status = 'No'.
      ENDIF.
    ENDIF.

    READ TABLE lt_vend_mast INTO ls_vend_mast WITH KEY lifnr = ls_final-lifnr.
    IF sy-subrc IS INITIAL.
      ls_final-name1 = ls_vend_mast-name1.
    ENDIF.
    READ TABLE lt_mat_doc INTO ls_mat_doc WITH KEY ebeln = ls_purchasing_doc_item-ebeln
                                                   ebelp = ls_purchasing_doc_item-ebelp.
    IF sy-subrc IS INITIAL.
      lv_index = sy-tabix.
      CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
        EXPORTING
          capid                 = 'PP01'
          datuv                 = sy-datum
          mktls                 = 'X'
          mtnrv                 = ls_purchasing_doc_item-matnr
          stlal                 = '01'
          stlan                 = '1'
          stpst                 = '0'
          svwvo                 = 'X'
          werks                 = ls_purchasing_doc_item-werks
          vrsvo                 = 'X'
        TABLES
          stb                   = lt_stb
        EXCEPTIONS
          alt_not_found         = 1
          call_invalid          = 2
          material_not_found    = 3
          missing_authorization = 4
          no_bom_found          = 5
          no_plant_data         = 6
          no_suitable_bom_found = 7
          conversion_error      = 8
          OTHERS                = 9.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
*---------------------------------------Added By AG DT:12.01.2018---------------------------------------------------------------------------
      READ TABLE lt_stb INTO ls_stb INDEX 1.

LOOP AT lt_mat_doc INTO ls_mat_doc WHERE ebeln = ls_purchasing_doc_item-ebeln and  ebelp = ls_purchasing_doc_item-ebelp.

        READ TABLE lt_j_1ig_subcon INTO ls_j_1ig_subcon WITH KEY mblnr = ls_mat_doc-mblnr.
        IF sy-subrc = 0.

          IF ls_j_1ig_subcon-bwart = '541'.
             ls_final-men_541 =  ls_j_1ig_subcon-menge.
             ls_final-men_541 = ls_final-men_541 / ls_stb-menge.
             ls_final-ch_qty = ls_final-ch_qty + ls_final-men_541 .
          ENDIF.
             ls_final-men_541_final = ls_final-ch_qty.
*      CLEAR LS_FINAL-men_541_FINAL.

          IF ls_j_1ig_subcon-bwart = '542'.
             ls_final-men_542 =  ls_j_1ig_subcon-menge.
             ls_final-men_542 = ls_final-men_542 / ls_stb-menge.

          IF sy-tabix NE '1' .
             ls_final-ch_qty = ls_final-ch_qty - ls_final-men_542.
          ENDIF.
          ENDIF.
        ENDIF.

*   CLEAR LS_FINAL-men_541_FINAL.
ENDLOOP.

*-------------------------------------------------------------------------------------------------------------------------
      READ TABLE lt_stb INTO ls_stb INDEX 1.
      LOOP AT lt_mat_doc INTO ls_mat_doc FROM lv_index.
        IF ls_mat_doc-ebeln = ls_purchasing_doc_item-ebeln AND ls_mat_doc-ebelp = ls_purchasing_doc_item-ebelp.
          LOOP AT lt_j_1ig_subcon INTO ls_j_1ig_subcon
                                    WHERE mblnr = ls_mat_doc-mblnr
                                    AND   mjahr = ls_mat_doc-mjahr
                                    AND   bwart = ls_mat_doc-bwart
                                    AND   matnr = ls_stb-idnrk.
            IF sy-subrc IS INITIAL.
* ls_final-ch_qty =  ls_j_1ig_subcon-menge / ls_stb-menge .
* ls_final-ch_qty = ls_final-ch_qty + ( ls_j_1ig_subcon-menge / ls_stb-menge ).
* ls_final-ch_qty = ls_final-men_541 - ls_final-men_542.
            ENDIF.
          ENDLOOP.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    ls_final-pen_qty = ls_final-menge - ls_final-ch_qty.
*-------------------------------------------Added by AG DT:08.01.2018---------------------------------------------
    loop at lt_MAT_DOC INTO LS_MAT_DOC WHERE ebeln = ls_purchasing_doc_item-ebeln and ebelp = ls_purchasing_doc_item-ebelp and bwart = '541'.

     IF ls_stb-menge NE 0.
        ls_final-DEV_CRD =  ls_final-DEV_CRD + ( ls_mat_doc-menge / ls_stb-menge ) .
    ENDIF.

    ENDLOOP.
*-------------------------------------------Added by AG DT:08.01.2018--------------------------------------------------

    LOOP AT lt_mat_doc INTO ls_mat_doc WHERE ebeln = ls_purchasing_doc_item-ebeln AND ebelp = ls_purchasing_doc_item-ebelp and ( bwart = '101' or bwart = '102' ).

      IF ls_mat_doc-bwart = '101'.
        ls_final-rec_101 = ls_mat_doc-menge.
        IF  sy-tabix = '1'.
          ls_final-sum_rs = ls_final-rec_101.
        ENDIF.

        IF sy-tabix NE '1'.
          ls_final-sum_rs = ls_final-sum_rs + ls_final-rec_101.
          ls_final-rec_101 = ls_final-sum_rs.
        ENDIF.
      ENDIF.

      IF ls_mat_doc-bwart = '102'.
        ls_final-sen_102 = ls_mat_doc-menge.

        IF sy-tabix EQ '2'.
          ls_final-sum_rs = ls_final-rec_101 - ls_final-sen_102.
        ENDIF.

        IF sy-tabix NE '1'.
          IF sy-tabix NE '2'.
            ls_final-sum_rs = ls_final-sum_rs + ls_final-sen_102.
          ENDIF.
        ENDIF.

        ls_final-sum_rs = ls_final-rec_101 - ls_final-sen_102.
      ENDIF.
*clear : LS_FINAL-SEN_102,LS_FINAL-REC_101.

    ENDLOOP.
*---------------------------------------------------------------------------------------------------------
    READ TABLE lt_mat_mast INTO ls_mat_mast WITH KEY matnr = ls_final-matnr.
    IF sy-subrc IS INITIAL.
      ls_final-zseries = ls_mat_mast-zseries.
      ls_final-zsize   = ls_mat_mast-zsize.
      ls_final-brand   = ls_mat_mast-brand.
      ls_final-moc     = ls_mat_mast-moc.
      ls_final-type    = ls_mat_mast-type.

    ENDIF.

    lv_id = ls_final-matnr.
    CLEAR: lt_lines,ls_lines.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_id
        object                  = 'MATERIAL'
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF NOT lt_lines IS INITIAL.
      LOOP AT lt_lines INTO ls_lines.
        IF NOT ls_lines-tdline IS INITIAL.
          REPLACE ALL OCCURRENCES OF '<&>' IN ls_lines-tdline WITH '&'.
          CONCATENATE ls_final-long_txt ls_lines-tdline INTO ls_final-long_txt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE ls_final-long_txt.
    ENDIF.
*    ENDIF.


    APPEND ls_final TO ct_final.
    CLEAR:
      ls_final,ls_purchasing_doc,ls_purchasing_doc_item,ls_mat_mast,ls_vend_mast,ls_j_1ig_subcon,ls_mat_doc.
  ENDLOOP.
*ENDIF.
  DELETE ct_final WHERE pen_qty = 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM display  USING ct_final TYPE tt_final.
  DATA:
    lt_fieldcat     TYPE slis_t_fieldcat_alv,
    ls_alv_layout   TYPE slis_layout_alv,
    l_callback_prog TYPE sy-repid.

  l_callback_prog = sy-repid.

  PERFORM prepare_display CHANGING lt_fieldcat.
  CLEAR ls_alv_layout.
  ls_alv_layout-zebra = 'X'.
  ls_alv_layout-colwidth_optimize = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = l_callback_prog
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      is_layout               = ls_alv_layout
      it_fieldcat             = lt_fieldcat
    TABLES
      t_outtab                = ct_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZCHALLAN_STATUS.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZCHALLAN STATUS Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_550 TYPE string.
DATA lv_crlf_550 TYPE string.
lv_crlf_550 = cl_abap_char_utilities=>cr_lf.
lv_string_550 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_550 lv_crlf_550 wa_csv INTO lv_string_550.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_550 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_display  CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.
  DATA:
    gv_pos      TYPE i,
    ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH ct_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Vendor Name'(101).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LIFNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Vendor Code'(102).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AEDAT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'PO Date'(103).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EBELN'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'PO Num'(104).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EKGRP'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Purchasing Group'(105).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EBELP'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'PO Line No'(106).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MATNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Item Code'(107).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LONG_TXT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Item Description'(108).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STATUS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'PO Release Status'(109).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MENGE'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'PO Qty.'(110).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CH_QTY'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'CH. Release Qty.'(111).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PEN_QTY'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Pending CH. Qty.'(112).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DEV_CRD'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Delivery Created'(113).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SUM_RS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Qty Received'(114).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BRAND'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Brand'(115).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSERIES'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Series'(116).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSIZE'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Size'(117).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MOC'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MOC'(118).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TYPE'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Type'(119).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Vendor Name'
              'Vendor Code'
              'PO Date'
              'PO Num'
              'Purchasing Group'
              'PO Line No'
              'Item Code'
              'Item Description'
              'PO Qty.'
              'PO Release Status'
              'Sum Of Released CH. Qty.'
              'Pending CH. Qty.'
              'Delivery Created'
              'Qty Received'
              'Brand'
              'Series'
              'Size'
              'MOC'
              'Type'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  UCOMM
*&---------------------------------------------------------------------*
*       Handlung of Commands on ALV
*----------------------------------------------------------------------*
*      -->U_UCOMM        USER COMMAND
*      -->U_SELFIELD     SELECT FIELD
*----------------------------------------------------------------------*
FORM ucomm_on_alv
     USING u_ucomm    TYPE sy-ucomm "#EC CALLED       "Form ucomm is called indirectly.
           u_selfield TYPE slis_selfield .

  DATA:
    ls_final     TYPE t_final,
    l_po_display TYPE tcode VALUE 'ME23N'.


  IF u_ucomm = '&IC1'.  "Klick on field

    READ TABLE gt_final
         INDEX u_selfield-tabindex
          INTO ls_final.
*   Code to Display Selected purchase order in report
    IF u_selfield-fieldname = 'EBELN' .
      IF u_selfield-value IS NOT INITIAL.
        SET PARAMETER ID 'BES'
            FIELD u_selfield-value.
        CALL TRANSACTION  l_po_display . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
