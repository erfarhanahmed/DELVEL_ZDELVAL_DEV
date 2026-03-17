*&---------------------------------------------------------------------*
*& Report ZMM_MB1C_AMT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_MB1C_AMT.

*&---------------------------------------------------------------------*
*& Report  ZMM_MB1C_STOCK_UPLOAD
*&
*&---------------------------------------------------------------------*
*& Description: MM BDC for Stock Upload
*&
*&---------------------------------------------------------------------*



TYPE-POOLS: truxs.

DATA : header  LIKE bapi2017_gm_head_01,
       code    LIKE bapi2017_gm_code,
       items   LIKE bapi2017_gm_item_create OCCURS 0 WITH HEADER LINE,
       serial  LIKE bapi2017_gm_serialnumber OCCURS 0 WITH HEADER LINE,
       return  LIKE bapi2017_gm_head_ret,
       ret     LIKE bapiret2 OCCURS 0 WITH HEADER LINE,
       testrun LIKE bapi2017_gm_gen-testrun.

DATA: it_tab   TYPE filetable,
      gd_subrc TYPE i,
      l_file   TYPE rlgrap-filename.
DATA: it_raw   TYPE truxs_t_text_data.

PARAMETERS : p_file TYPE rlgrap-filename.
**             p_test AS CHECKBOX.
SKIP 1.

DATA : BEGIN OF it_data OCCURS 0,
       id(10),
*       id1(10),
       bldat(10),                "Document Date
       budat(10),                "Posting Date
       bwart TYPE rm07m-bwartwa,             "Movement Type
       sobkz(1),                             "Special Stock
       werks TYPE rm07m-werks,               "Plant
       lgort TYPE rm07m-lgort,               "Storage Location
****       lgort1 TYPE rm07m-lgort,
****       lifnr(10),
       matnr TYPE mseg-matnr,                "Material Number
       erfmg(13) TYPE c,                     "Quantity
****       charg TYPE mseg-charg,                "Batch
****       bwtar TYPE bwtar_d,
       exbwr(15),                            "Amount in Local Currency
       sgtxt(40),
*       erfme TYPE mseg-erfme,                "Unit
*       sernr TYPE ripw0-sernr,               "Serial Number
       END OF it_data.

DATA : BEGIN OF it_head OCCURS 0,
       id(10),
*       id1(10),
       bldat(10),                "Document Date
       budat(10),                "Posting Date
       bwart TYPE rm07m-bwartwa,             "Movement Type
       sobkz(1),                             "Special Stock
       END OF it_head.

DATA : BEGIN OF it_item OCCURS 0,
       id(10),
*       id1(10),
       werks TYPE rm07m-werks,               "Plant
       lgort TYPE rm07m-lgort,               "Storage Location
****       lgort1 TYPE rm07m-lgort,
****       lifnr(10),
       matnr TYPE mseg-matnr,                "Material Number
       erfmg(13) TYPE c,                     "Quantity
***       charg TYPE mseg-charg,                "Batch
****       bwtar TYPE bwtar_d,
       exbwr(15),                            "Amount in Local Currency
       sgtxt(40),
*       erfme TYPE mseg-erfme,                "Unit
*       sernr TYPE ripw0-sernr,               "Serial Number       END OF st_upload.
       END OF it_item.

DATA : count(2) TYPE n,
       text_c(30).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title = 'Select File'
    CHANGING
      file_table   = it_tab
      rc           = gd_subrc.
  READ TABLE it_tab INTO p_file INDEX 1.

START-OF-SELECTION.

  PERFORM get_excel_data.
  PERFORM get_header_item.
  PERFORM update_data.

*&---------------------------------------------------------------------*
*&      Form  GET_EXCEL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_excel_data .
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = p_file
    IMPORTING
      output = l_file.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_tab_raw_data       = it_raw
      i_filename           = l_file
    TABLES
      i_tab_converted_data = it_data
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " GET_EXCEL_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_HEADER_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_header_item .

  DATA : flag(1).
  LOOP AT it_data.
    CLEAR flag.
    AT NEW id.
      flag = 'X'.
    ENDAT.
    IF flag = 'X'.
      MOVE-CORRESPONDING it_data TO it_head.
      APPEND it_head.
    ENDIF.
    MOVE-CORRESPONDING it_data TO it_item.
    APPEND it_item.
  ENDLOOP.


ENDFORM.                    " GET_HEADER_ITEM
*&---------------------------------------------------------------------*
*&      Form  UPDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update_data .
  DATA : count1(10),
         l_qty TYPE i.

  LOOP AT it_head.

    ON CHANGE OF it_head-id.

      CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
        EXPORTING
          date_external       = it_head-budat
          accept_initial_date = 'X'
        IMPORTING
          date_internal       = header-pstng_date.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
        EXPORTING
          date_external       = it_head-bldat
          accept_initial_date = 'X'
        IMPORTING
          date_internal       = header-doc_date.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      MOVE : '2'           TO header-ver_gr_gi_slip,
             'X'           TO header-ver_gr_gi_slipx.

*      IF r1 EQ 'X'.
      MOVE '05' TO code-gm_code.
*      ELSEIF r2 EQ 'X'.
*        MOVE '04' TO code-gm_code.
*      ELSEIF r3 EQ 'X'.
*        MOVE '04' TO code-gm_code.
*      ENDIF.

****      IF p_test = 'X'.
****        MOVE 'X' TO testrun.
****      ENDIF.

    ENDON.

    LOOP AT it_item WHERE id = it_head-id.
*      ON CHANGE OF it_item-id1.
      count1 = count1 + 1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = it_item-matnr
        IMPORTING
          output = items-material.

      MOVE : it_item-werks TO items-plant,
             it_item-lgort TO items-stge_loc,
****             it_item-lgort1 TO items-move_stloc,
***             it_item-charg TO items-batch,
****             it_item-bwtar TO items-val_type,
             it_head-bwart TO items-move_type,
             it_head-sobkz TO items-spec_stock,
             it_item-erfmg TO items-entry_qnt,
*               it_item-erfme TO items-entry_uom,
             it_item-sgtxt TO items-item_text,
             it_item-exbwr TO items-amount_lc,
             it_item-sgtxt TO items-item_text,
             it_item-erfmg TO l_qty.

*****      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*****        EXPORTING
*****          input  = it_item-lifnr
*****        IMPORTING
*****          output = items-vendor.
      APPEND items.

*      ENDON.
*      CHECK it_item-sernr IS NOT INITIAL.
*      MOVE : it_item-id1 TO serial-matdoc_itm,
*      it_item-sernr TO serial-serialno.
*      APPEND serial.

    ENDLOOP.

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header         = header
        goodsmvt_code           = code
        testrun                 = testrun
*       GOODSMVT_REF_EWM        =
      IMPORTING
        goodsmvt_headret        = return
*       MATERIALDOCUMENT        =
*       MATDOCUMENTYEAR         =
      TABLES
        goodsmvt_item           = items
*       goodsmvt_serialnumber   = serial
        return                  = ret
*       GOODSMVT_SERV_PART_DATA =
*       EXTENSIONIN             =
      .

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
     EXPORTING
       wait          = 'X'
*   IMPORTING
*     RETURN        =
              .

    IF NOT return IS INITIAL.
      WRITE :/ return-mat_doc,return-doc_year.
    ELSE.
      LOOP AT ret.
        WRITE : ret-type,    ret-message.
      ENDLOOP.
    ENDIF.
    REFRESH : items,ret.
    CLEAR : header,return.
  ENDLOOP.

ENDFORM.                    " UPDATE_DATA
