*&---------------------------------------------------------------------*
*& Report ZREP_CURRENY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrep_curreny.

TYPE-POOLS: slis.
TABLES : zcurr_tab.

TYPES : BEGIN OF ty_data,
          zyear    TYPE zcurr_tab-zyear,
          zcurr    TYPE zcurr_tab-zcurr,
          zex_rate TYPE zcurr_tab-zex_rate,
        END OF ty_data.

TYPES : BEGIN OF ty_down,
          zyear    TYPE zcurr_tab-zyear,
          zcurr    TYPE zcurr_tab-zcurr,
          zex_rate TYPE zcurr_tab-zex_rate,
          sy_date  TYPE char15,
          sy_time  TYPE sy-uzeit,
        END OF ty_down.

DATA : lt_data  TYPE TABLE OF ty_data,
       ls_data  TYPE ty_data,
       lt_final TYPE TABLE OF ty_data,
       ls_final TYPE ty_data.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.

DATA : lt_fieldcat TYPE slis_t_fieldcat_alv,
       ls_fieldcat TYPE slis_fieldcat_alv,
       ls_layout   TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.  "Selection Scrren for TMG
SELECT-OPTIONS : s_year FOR zcurr_tab-zyear,
                 s_curr FOR zcurr_tab-zcurr.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM process_data.
  PERFORM field_cat.
  PERFORM display.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT zyear
         zcurr
         zex_rate
         FROM zcurr_tab
         INTO TABLE lt_data
         WHERE zyear IN s_year
         AND   zcurr IN s_curr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_data .

  LOOP AT lt_data INTO ls_data.

    IF sy-subrc = 0.
      ls_final-zyear = ls_data-zyear.
      ls_final-zcurr = ls_data-zcurr.
      ls_final-zex_rate = ls_data-zex_rate.
    ENDIF.

    APPEND ls_final TO lt_final.
    CLEAR ls_final.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELD_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM field_cat .

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.

  PERFORM build_fc USING   '1'    'ZYEAR'      'Year'            ' '      ' '  ' '  'X'.
  PERFORM build_fc USING   '1'    'ZCURR'      'Currency'        ' '      ' '  ' '  ' '.
  PERFORM build_fc USING   '1'    'ZEX_RATE'   'Condition Rate'  ' '      ' '  ' '  ' '.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM build_fc  USING        pr_count TYPE i
                            pr_fname TYPE string
                            pr_title TYPE string
                            VALUE(p4)
                            VALUE(p5)
                            VALUE(p6)
                            VALUE(p7).

  ls_fieldcat-col_pos   = pr_count.
  ls_fieldcat-fieldname = pr_fname.
  ls_fieldcat-seltext_l = pr_title.
  ls_fieldcat-emphasize = p4.
  ls_fieldcat-edit      = p5.
  ls_fieldcat-checkbox  = p6.
  ls_fieldcat-hotspot   = p7.


  APPEND ls_fieldcat TO lt_fieldcat.
  CLEAR ls_fieldcat.

ENDFORM.                    "build_fc
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = ls_layout
      it_fieldcat        = lt_fieldcat[]
    TABLES
      t_outtab           = lt_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
    PERFORM download_file.
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

  LOOP AT lt_final INTO ls_final.

    IF sy-subrc = 0.
      ls_down-zyear = ls_final-zyear.
      ls_down-zcurr = ls_final-zcurr.
      ls_down-zex_rate = ls_final-zex_rate.
      ls_down-sy_date = sy-datum.
      ls_down-sy_time = sy-uzeit.
    ENDIF.

 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = ls_down-sy_date
   IMPORTING
     OUTPUT        = ls_down-sy_date.

    CONCATENATE ls_down-sy_date+0(2) ls_down-sy_date+2(3) ls_down-sy_date+5(4)
                INTO ls_down-sy_date SEPARATED BY '-'.


    APPEND ls_down TO lt_down.
    CLEAR: ls_down.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_file .

  TYPE-POOLS truxs.
  DATA: lt_csv TYPE truxs_t_text_data,
        ls_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
    CHANGING
      i_tab_converted_data = lt_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZCURRENCY.TXT'.

  CONCATENATE p_folder '/' lv_file INTO lv_fullfile.

  WRITE: / 'ZCURRENCY Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile

  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

*  IF sy-subrc = 0.
*DATA lv_string_263 TYPE string.
*DATA lv_crlf_263 TYPE string.
*lv_crlf_263 = cl_abap_char_utilities=>cr_lf.
*lv_string_263 = hd_csv.
* TRANSFER hd_csv TO lv_fullfile.
*  LOOP AT lt_csv INTO ls_csv.
*      IF sy-subrc = 0.
*        TRANSFER ls_csv TO lv_fullfile.
*      ENDIF.
*    ENDLOOP.
*
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.


  IF sy-subrc = 0.
    DATA lv_string_263 TYPE string.
    DATA lv_crlf_263 TYPE string.

*    TRANSFER hd_csv TO lv_fullfile.

    lv_crlf_263 = cl_abap_char_utilities=>cr_lf.
    lv_string_263 = hd_csv.

    LOOP AT lt_csv INTO ls_csv.
      CONCATENATE lv_string_263  lv_crlf_263   ls_csv INTO lv_string_263 .
      CLEAR: ls_csv.
    ENDLOOP.

    TRANSFER lv_string_263 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE  'Year'
               'Currency'
               'Condition Rate'
               'Refresh Date'
               'Refresh Time'
               INTO p_hd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
