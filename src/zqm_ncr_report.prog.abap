*&---------------------------------------------------------------------*
*& Report ZQM_NCR_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zqm_ncr_report.


TYPES : BEGIN OF ty_f4_mblnr,
          mblnr TYPE mkpf-mblnr,
          mjahr TYPE mkpf-mjahr,
        END OF ty_f4_mblnr.

TYPES : BEGIN OF ty_out,
          col1 TYPE text40,
          col2 TYPE text200,
          col3 TYPE text40,
          col4 TYPE text10,
          col5 TYPE text10,
          col6 TYPE text40,
          col7 TYPE text10,
          col8 TYPE text40,
          col9 TYPE text20,
        END OF ty_out.


DATA: gt_f4_mblnr TYPE TABLE OF ty_f4_mblnr.
DATA: gt_out TYPE TABLE OF ty_out,
      gs_out TYPE ty_out.
DATA: gs_mkpf TYPE mkpf,
      gs_mseg TYPE mseg,
      gs_lfa1 TYPE lfa1,
*      gs_afpo TYPE afpo,
      gs_makt TYPE makt.
DATA: ok_code TYPE sy-ucomm.
DATA: gs_ncr TYPE zqm_ncr_report,
      gs_ncx TYPE zqm_ncr_report.
DATA: gv_max TYPE zqm_ncr_report-ncrno.

*>>
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_mjahr TYPE mkpf-mjahr OBLIGATORY.
PARAMETERS: p_mblnr TYPE mkpf-mblnr OBLIGATORY.
PARAMETERS: p_zeile TYPE mseg-zeile OBLIGATORY.
SELECTION-SCREEN : END OF BLOCK b1.

*>>
INITIALIZATION.
  CALL FUNCTION 'GET_CURRENT_YEAR'
    EXPORTING
      bukrs = '1000'
      date  = sy-datum
    IMPORTING
*     CURRM =
      curry = p_mjahr
*     PREVM =
*     PREVY =
    .

*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_mblnr.
  SELECT DISTINCT mblnr mjahr FROM mseg INTO TABLE gt_f4_mblnr
    WHERE ( bwart = '101' OR bwart = '501' OR bwart = '262' )
      AND mjahr = p_mjahr.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'MBLNR'
      value_org       = 'S'
      dynpprog        = 'ZQM_NCR_REPORT'
      dynpnr          = '1000'
      dynprofield     = 'P_MBLNR'
    TABLES
      value_tab       = gt_f4_mblnr
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*>>
AT SELECTION-SCREEN ON BLOCK b1.
  SELECT SINGLE * FROM mseg INTO gs_mseg
    WHERE mblnr = p_mblnr
      AND mjahr = p_mjahr
      AND zeile = p_zeile.
  IF sy-subrc NE 0.
    MESSAGE 'Invalid Material document' TYPE 'E'.
  ENDIF.

*>>
START-OF-SELECTION.
  SELECT SINGLE * FROM mkpf INTO gs_mkpf
    WHERE mblnr = p_mblnr
      AND mjahr = p_mjahr.

  SELECT SINGLE * FROM lfa1 INTO gs_lfa1 WHERE lifnr = gs_mseg-lifnr.

  SELECT SINGLE * FROM makt INTO gs_makt WHERE matnr = gs_mseg-matnr
    AND spras = sy-langu.

*  SELECT SINGLE * FROM afpo INTO gs_afpo
*    WHERE aufnr = gs_mseg-aufnr.

  SELECT SINGLE * FROM zqm_ncr_report INTO gs_ncr
    WHERE mblnr = gs_mseg-mblnr AND zeile = gs_mseg-zeile AND mjahr = gs_mseg-mjahr.
  IF sy-subrc = 0.
*    gs_ncr = gs_ncx.
  ELSE.
    CLEAR gs_ncr.
    SELECT MAX( ncrno ) FROM zqm_ncr_report INTO gv_max.

    gs_ncr-ncrno = gv_max + 1.
    gs_ncr-ncrdt = sy-datum.
    gs_ncr-mblnr = gs_mseg-mblnr.
    gs_ncr-mjahr = gs_mseg-mjahr.
    gs_ncr-zeile = gs_mseg-zeile.
    gs_ncr-lifnr = gs_mseg-lifnr.
*zqm_ncr_report-NCRUS = sy-uname.
*zqm_ncr_report-NCRQT
    gs_ncr-meins = gs_mseg-meins.
    MODIFY zqm_ncr_report FROM gs_ncr.
*zqm_ncr_report-VBELN
  ENDIF.

  CALL SCREEN 200.

**>>
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'MENU_0200'.
  SET TITLEBAR 'TITL_0200'.
ENDMODULE.
**>>
MODULE user_command_0200 INPUT.

  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM save_data.
    WHEN 'EXCL'.
      PERFORM bld_out.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
FORM save_data.
  IF gs_ncr-lifnr IS INITIAL.
    gs_ncr-lifnr = gs_mseg-lifnr.
  ENDIF.

  MODIFY zqm_ncr_report FROM gs_ncr.
  MESSAGE 'Data saved' TYPE 'S'.

ENDFORM.
FORM bld_out.

  PERFORM save_data.

  REFRESH gt_out.

*  CLEAR gs_out.
*  APPEND INITIAL LINE TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'Delval Flow Controls Pvt. Ltd. '.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'NON CONFORMANCE REPORT'.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'Supplier Name :'.
  gs_out-col3 = gs_lfa1-name1.
  gs_out-col6 = 'NCR No.'.
  gs_out-col8 = gs_ncr-ncrno.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'Challan No.   :'.
  gs_out-col3 = gs_mkpf-frbnr.
  gs_out-col6 = 'NCR Date'.
  WRITE gs_ncr-ncrdt TO gs_out-col8.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'Date          :'.
  WRITE gs_mkpf-bldat TO gs_out-col3.
  gs_out-col6 = 'Received Quantity'.
*   =  gs_mseg-erfmg.
  WRITE gs_mseg-erfmg TO gs_out-col8.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'Part No.      :'.
  gs_out-col3 = gs_mseg-matnr.
  gs_out-col6 = 'NCR Quantity'.
  WRITE gs_ncr-ncrqt TO gs_out-col8.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'Part Description :'.
  gs_out-col3 = gs_makt-maktx.
  gs_out-col6 = 'Sales Order No'.
  gs_out-col8 = gs_ncr-vbeln.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'GRN / GRS No. :'.
  gs_out-col3 = gs_mseg-mblnr.
  gs_out-col6 = 'Raised By'.
  gs_out-col8 = gs_ncr-ncrus.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = 'Sr No'.
  gs_out-col2 = 'NC Details'.
  gs_out-col9 = 'QTY'.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = '1'.
  gs_out-col2 = gs_ncr-cat01.
  gs_out-col9 = gs_ncr-qty01.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = '2'.
  gs_out-col2 = gs_ncr-cat02.
  gs_out-col9 = gs_ncr-qty02.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = '3'.
  gs_out-col2 = gs_ncr-cat03.
  gs_out-col9 = gs_ncr-qty03.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = '4'.
  gs_out-col2 = gs_ncr-cat04.
  gs_out-col9 = gs_ncr-qty04.
  APPEND gs_out TO gt_out.

  CLEAR gs_out.
  gs_out-col1 = '5'.
  gs_out-col2 = gs_ncr-cat05.
  gs_out-col9 = gs_ncr-qty05.
  APPEND gs_out TO gt_out.

  DATA: lv_filename	   TYPE string,
        lv_path	       TYPE string,
        lv_fullpath	   TYPE string,
        lv_user_action TYPE i,
        lv_file_name   TYPE  rlgrap-filename.
*FILE_ENCODING  TYPE ABAP_ENCODING OPTIONAL

* Display save dialog window
  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title      = 'Save File As...'
      default_extension = ''
      default_file_name = 'NCR_Report'
      initial_directory = 'C:\'
    CHANGING
      filename          = lv_filename
      path              = lv_path
      fullpath          = lv_fullpath
      user_action       = lv_user_action.

  lv_file_name = lv_fullpath.

  CALL FUNCTION 'EXCEL_OLE_STANDARD_DAT'
    EXPORTING
      file_name                 = lv_file_name
*     CREATE_PIVOT              = 0
*     DATA_SHEET_NAME           = ' '
*     PIVOT_SHEET_NAME          = ' '
*     PASSWORD                  = ' '
*     PASSWORD_OPTION           = 0
    TABLES
*     PIVOT_FIELD_TAB           =
      data_tab                  = gt_out
*     FIELDNAMES                =
    EXCEPTIONS
      file_not_exist            = 1
      filename_expected         = 2
      communication_error       = 3
      ole_object_method_error   = 4
      ole_object_property_error = 5
      invalid_pivot_fields      = 6
      download_problem          = 7
      OTHERS                    = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  MESSAGE 'File save and download complete' TYPE 'S'.

ENDFORM.
