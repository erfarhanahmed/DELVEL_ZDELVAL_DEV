*&---------------------------------------------------------------------*
*& Report ZIN_BOM_COMPONANT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zin_bom_componant.


TABLES : ekpo.

"Data Declaration


** Declaration for ALV Grid **
DATA : gr_table TYPE REF TO cl_salv_table.


** declaration for Layout Settings
DATA : gr_layout      TYPE REF TO cl_salv_layout,
       gr_layout_key  TYPE salv_s_layout_key,
       ls_layout      TYPE salv_s_layout,
       lt_layout_info TYPE salv_t_layout_info.

** Declaration for Global Display Settings
DATA : gr_display TYPE REF TO cl_salv_display_settings,
       lv_title   TYPE lvc_title.

** Declarations for ALV Functions
DATA : gr_functions TYPE REF TO cl_salv_functions_list.


TYPES : BEGIN OF t_mast,
          matnr TYPE matnr,
          stlnr TYPE stnum,
        END OF t_mast.

DATA : gt_mast TYPE TABLE OF t_mast.
DATA : gs_mast TYPE t_mast.


TYPES : BEGIN OF t_stpo,
          idnrk TYPE idnrk,
        END OF t_stpo.

DATA : gt_stpo TYPE TABLE OF t_stpo.
DATA : gs_stpo TYPE t_stpo.

TYPES : BEGIN OF t_final,
          matnr TYPE matnr,
        END OF t_final.
DATA : gt_final TYPE TABLE OF t_final.
DATA : gs_final TYPE t_final.

TYPES : BEGIN OF t_ftp,
          matnr  TYPE matnr,
          r_date TYPE string, "sy-datum,
        END OF t_ftp.

DATA : gt_ftp TYPE TABLE OF t_ftp,
       gs_ftp TYPE t_ftp.

"" Selection Screen


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_werks FOR  ekpo-werks NO-EXTENSION NO INTERVALS DEFAULT 'PL01'.
**                 s_ebeln FOR  ekpo-ebeln,
**                 s_matnr FOR ekpo-matnr.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'S_WERKS-LOW'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM manipulate_data.
  IF p_down IS INITIAL.
    PERFORM display.
  ELSE.
    PERFORM download.
  ENDIF.
  .
*&---------------------------------------------------------------------*
*& Form FETCH_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fetch_data .

  SELECT  matnr
          stlnr
    FROM mast
    INTO TABLE gt_mast
    WHERE werks IN s_werks.

  IF gt_mast IS NOT INITIAL.
    SELECT idnrk
      FROM stpo
      INTO TABLE gt_stpo
      FOR ALL ENTRIES IN gt_mast
      WHERE stlnr = gt_mast-stlnr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .
  CLEAR : gr_table.
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = gt_final.
    CATCH cx_salv_msg .
  ENDTRY.
  IF gr_table IS INITIAL.
    MESSAGE 'Error Creating ALV Grid ' TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

  "Get functions details
  gr_functions = gr_table->get_functions( ).

** Activate All Buttons in Tool Bar
  gr_functions->set_all( if_salv_c_bool_sap=>true ).


  CLEAR : gr_layout, gr_layout_key.
  MOVE sy-repid TO gr_layout_key-report.                        "Set Report ID as Layout Key"

  gr_layout = gr_table->get_layout( ).                          "Get Layout of Table"
  gr_layout->set_key( gr_layout_key ).                          "Set Report Id to Layout"
  gr_layout->set_save_restriction( if_salv_c_layout=>restrict_none ). "No Restriction to Save Layout"

  gr_layout->set_default( if_salv_c_bool_sap=>true ).         "Set Default Variant"


******* Global Display Settings  *******
  CLEAR : gr_display.
  MOVE 'BOM Material list' TO lv_title.
  gr_display = gr_table->get_display_settings( ).               " Global Display settings"
  gr_display->set_striped_pattern( if_salv_c_bool_sap=>true ).  "Activate Strip Pattern"
  gr_display->set_list_header( lv_title ).                      "Report Header"





  CALL METHOD gr_table->display.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MANIPULATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM manipulate_data .
  LOOP AT gt_mast INTO gs_mast.

    gs_final-matnr = gs_mast-matnr.
    APPEND gs_final TO gt_final.

    gs_ftp-matnr = gs_mast-matnr.
    gs_ftp-r_date = sy-datum.

     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
     EXPORTING
       input         = gs_ftp-r_date
    IMPORTING
      OUTPUT        = gs_ftp-r_date
             .


      CONCATENATE gs_ftp-r_date+0(2) gs_ftp-r_date+2(3) gs_ftp-r_date+5(4)
     INTO gs_ftp-r_date SEPARATED BY '-'.


    APPEND gs_ftp TO gt_ftp.
  ENDLOOP.

  LOOP AT gt_stpo INTO gs_stpo.

    gs_final-matnr = gs_stpo-idnrk.
    APPEND gs_final TO gt_final.

    gs_ftp-matnr = gs_stpo-idnrk.
    gs_ftp-r_date = sy-datum.

   CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
     EXPORTING
       input         = gs_ftp-r_date
    IMPORTING
      OUTPUT        = gs_ftp-r_date
             .


      CONCATENATE gs_ftp-r_date+0(2) gs_ftp-r_date+2(3) gs_ftp-r_date+5(4)
     INTO gs_ftp-r_date SEPARATED BY '-'.



    APPEND gs_ftp TO gt_ftp.
  ENDLOOP.

SORT gt_final by matnr.
DELETE ADJACENT DUPLICATES FROM gt_final COMPARING matnr.

SORT gt_ftp by matnr.
DELETE ADJACENT DUPLICATES FROM gt_ftp COMPARING matnr.

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
  DATA: it_csv     TYPE truxs_t_text_data,
        wa_csv     TYPE LINE OF truxs_t_text_data,
        hd_csv     TYPE LINE OF truxs_t_text_data,
        hd_csv_new TYPE LINE OF truxs_t_text_data.        " Added By Abhishek Pisolkar (14.03.2018)

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile     TYPE string,
        lv_fullfile_new TYPE string,
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
      i_tab_sap_data       = gt_ftp
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
  lv_file = 'ZBOM_Components.TXT'.

  CONCATENATE p_folder '/'  lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_COMPONENTS Download started on', sy-datum, 'at', sy-uzeit.
  WRITE: / 'Plant', s_werks-low.
  WRITE: / 'Dest. File:', lv_fullfile.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_297 TYPE string.
DATA lv_crlf_297 TYPE string.
lv_crlf_297 = cl_abap_char_utilities=>cr_lf.
lv_string_297 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_297 lv_crlf_297 wa_csv INTO lv_string_297.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_297 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
  CLOSE DATASET lv_fullfile.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING  pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE
        'MATERIAL'
        'REFRESH DATE'
  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
