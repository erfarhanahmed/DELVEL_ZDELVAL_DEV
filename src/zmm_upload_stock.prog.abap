*&---------------------------------------------------------------------*
*& Report ZMM_UPLOAD_STOCK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_upload_stock.


TYPES: BEGIN OF ty_input,
         doc_date(10),
         pstng_date(10),
         move_type(3),
         plant(4),
         material(18),
         entry_qnt(17),
         entry_uom(3),
         stge_loc(4),
*         batch(10),
         amount_lc(30),
*         prod_date(10),
*         vend_batch(15),
         item_text(50),
       END OF ty_input.

DATA gt_input TYPE TABLE OF ty_input.

*>>
SELECTION-SCREEN BEGIN OF BLOCK blk6 WITH FRAME TITLE TEXT-001 .
PARAMETERS : p_file LIKE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK blk6 .


*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
*--- Validating file
  PERFORM search_file USING p_file.

*>>
START-OF-SELECTION.
  PERFORM get_xls USING p_file.
  PERFORM upload_data.
*&---------------------------------------------------------------------*
*&      Form  SEARCH_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM search_file  USING pv_file TYPE rlgrap-filename.

  DATA lv_file TYPE ibipparms-path.

  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = lv_file.

  pv_file = lv_file .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_XLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_xls USING pv_file TYPE rlgrap-filename.
  TYPE-POOLS truxs.
  DATA: lv_file TYPE string,
        lv_bool TYPE c.

  DATA: lt_rawdata TYPE truxs_t_text_data.
*Check the upload file
  lv_file = pv_file .
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = lv_file
    RECEIVING
      result = lv_bool.

  IF lv_bool IS NOT INITIAL .
*Read XLS to internal table
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
        I_LINE_HEADER        = 'X'   """ added by nc
        i_tab_raw_data       = lt_rawdata
        i_filename           = pv_file
      TABLES
        i_tab_converted_data = gt_input
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload_data .

  DATA: ls_input TYPE ty_input.

*BAPI
**Import
  DATA: ls_header LIKE  bapi2017_gm_head_01,
        ls_tcode  LIKE  bapi2017_gm_code.
**Export
  DATA: ls_headret  LIKE  bapi2017_gm_head_ret,
        lv_mat_doc  TYPE  bapi2017_gm_head_ret-mat_doc,
        lv_doc_year TYPE  bapi2017_gm_head_ret-doc_year.
**Tables
  DATA: lt_item	  TYPE TABLE OF	bapi2017_gm_item_create,
        lt_return TYPE TABLE OF bapiret2.
*        returnc TYPE TABLE OF bapiret2.
  DATA: ls_item   TYPE bapi2017_gm_item_create,
        ls_return TYPE bapiret2.

  IF gt_input IS INITIAL.
    MESSAGE i208(00) WITH 'No data for processing'.
  ELSE.
    LOOP AT gt_input INTO ls_input.

      CLEAR: ls_header, ls_tcode, ls_headret, lv_mat_doc,
             lv_doc_year, ls_item, ls_return.
      REFRESH: lt_item, lt_return.

      ls_header-header_txt = 'Initial Stock Upload'.
      CONCATENATE ls_input-doc_date+6(4) ls_input-doc_date+3(2)
                  ls_input-doc_date+0(2)
        INTO ls_header-doc_date.
      CONCATENATE ls_input-pstng_date+6(4) ls_input-pstng_date+3(2)
                  ls_input-pstng_date+0(2)
        INTO ls_header-pstng_date.

      ls_tcode-gm_code = '05'.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = ls_input-material
        IMPORTING
          output       = ls_item-material
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.

*    ls_item-material = ls_input-material.
      ls_item-plant = ls_input-plant."'PL01'.
      ls_item-stge_loc = ls_input-stge_loc.
*      ls_item-batch = ls_input-batch.
      ls_item-move_type = ls_input-move_type.
      ls_item-entry_qnt = ls_input-entry_qnt.
      TRANSLATE ls_input-entry_uom TO UPPER CASE.
*    ls_item-entry_uom = ls_input-entry_uom.

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
        EXPORTING
          input          = ls_input-entry_uom
          language       = sy-langu
        IMPORTING
          output         = ls_item-entry_uom
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      ls_item-no_more_gr = 'X'.
*      ls_item-vendrbatch = ls_input-vend_batch.
      ls_item-item_text = ls_input-item_text.
      ls_item-amount_lc = ls_input-amount_lc.
*      CONCATENATE ls_input-prod_date+6(4) ls_input-prod_date+3(2)
*                  ls_input-prod_date+0(2)
*        INTO ls_item-prod_date.

      APPEND ls_item TO lt_item.
**
      CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
        EXPORTING
          goodsmvt_header  = ls_header
          goodsmvt_code    = ls_tcode
        IMPORTING
          goodsmvt_headret = ls_headret
          materialdocument = lv_mat_doc
          matdocumentyear  = lv_doc_year
        TABLES
          goodsmvt_item    = lt_item
          return           = lt_return.

      READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
      IF sy-subrc = 0.
        WRITE:/ 'Error:-', ls_return-message.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
* EXPORTING
*   WAIT          =
* IMPORTING
*   lt_return        =
          .
        WAIT UP TO 1 SECONDS.
        WRITE:/ 'Material Document:', lv_mat_doc, ' created'.
      ENDIF.

    ENDLOOP.
  ENDIF.
ENDFORM.
