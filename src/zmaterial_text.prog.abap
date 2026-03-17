*&---------------------------------------------------------------------*
*& Report ZMATERIAL_TEXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmaterial_text.

TABLES : marc,
         mara.
TYPES : BEGIN OF st_marc,
          matnr         TYPE matnr,
          werks         TYPE werks_d,
          ekgrp         TYPE ekgrp,
          steuc         TYPE steuc,
          text_en(600)  TYPE c, " char255,
          text_es(1000) TYPE c,
        END OF st_marc.

TYPES : BEGIN OF st_final,
          matnr         TYPE matnr,
          werks         TYPE werks_d,
          ekgrp         TYPE ekgrp,
          steuc         TYPE steuc,
          text_en       TYPE string,
          text_es(1000),
          text_es1      TYPE text1000,
          ref_on   TYPE char15,
          ref_time TYPE char15,        "ADD BY SUPRIYA ON 23.08.2024
        END OF st_final.

TYPES : BEGIN OF st_final2,
          matnr TYPE mara-matnr,
          text_es(1000) TYPE c,
        END OF st_final2.


DATA : it_final TYPE TABLE OF st_final,
       wa_final TYPE st_final.
DATA : it_final2 TYPE TABLE OF st_final2,
       wa_final2 TYPE st_final2.

DATA: BEGIN OF lt_download OCCURS 0,
        matnr TYPE matnr,
        data  TYPE string,
        ref_on   TYPE char15,
        ref_time TYPE char15,
      END OF lt_download.
*****************************************  add aby supriya
DATA: BEGIN OF lt_download4 OCCURS 0,
        data TYPE string,
      END OF lt_download4.
********************************************
DATA: lv_name          TYPE thead-tdname,
      lv_lines         TYPE STANDARD TABLE OF tline,
      wa_final_text_es TYPE tline,
      wa_lines         LIKE tline.


DATA : it_marc TYPE TABLE OF st_marc,
       wa_marc TYPE st_marc.

DATA : it_fcat TYPE slis_t_fieldcat_alv,
       wa_fcat TYPE slis_fieldcat_alv.


DATA : lv_matnr(20) TYPE c,
       lv_text_es(3000) TYPE c.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : matnr FOR marc-matnr.
*                 ekgrp FOR marc-ekgrp NO-DISPLAY .

SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-004 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."temp'.           "   'E:/delval/temp'.
SELECTION-SCREEN END OF BLOCK b2.

selection-screen :begin of block b3 with frame title text-002.
selection-screen  comment /1(60) text-003.
*                     COMMENT 1(70) TEXT-004.
*SELECTION-SCREEN COMMENT /1(70) TEXT-004.
selection-screen: end of block b3.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM fill_fieldcat.
  PERFORM display_data.


FORM get_data.
  SELECT matnr
         werks
         ekgrp
         steuc FROM marc INTO TABLE it_marc
         WHERE matnr IN matnr
*         AND ekgrp IN ekgrp
         AND werks = 'PL01'.

  LOOP AT it_marc INTO wa_marc.

    wa_final-matnr = wa_marc-matnr.

    DATA: lv_multiple_lines TYPE string.
    CLEAR: lv_lines, lv_name,wa_lines.

    lv_name = wa_final-matnr.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = 'S'
        name                    = lv_name
        object                  = 'MATERIAL'
      TABLES
        lines                   = lv_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    "start


    DATA: lv_string TYPE string.

    lv_string = REDUCE #( INIT lv_str TYPE string FOR ls_tline IN lv_lines NEXT lv_str =  lv_str && ls_tline-tdline && | | ).
*    lv_string = REDUCE #( INIT lv_str TYPE string FOR ls_tline IN lv_lines NEXT lv_str = lv_str && ls_tline-tdline && cl_abap_char_utilities=>cr_lf ).
    wa_final-text_es = lv_string.
    APPEND wa_final TO it_final.


    CLEAR: lv_string,wa_final.




  ENDLOOP.
  DELETE it_final WHERE text_es IS INITIAL.
  if p_down = 'X'.
    loop AT it_final INTO wa_final.
      lt_download-matnr = wa_final-matnr.
      lt_download-data  =  wa_final-text_es.
       lt_download-ref_on = sy-datum.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = lt_download-ref_on.
      CONCATENATE lt_download-ref_on+0(2) lt_download-ref_on+2(3) lt_download-ref_on+5(4)
                      INTO lt_download-ref_on SEPARATED BY '-'.

       lt_download-ref_time = sy-uzeit.
      CONCATENATE lt_download-ref_time+0(2) ':' lt_download-ref_time+2(2)  INTO lt_download-ref_time.


       APPEND lt_download.
       clear : wa_Final.
     endloop.
  endif.
ENDFORM.
***********************************************************

*********************************************************************************

FORM fill_fieldcat.
  wa_fcat-col_pos = '1'.
  wa_fcat-tabname = 'IT_FINAL'.
  wa_fcat-no_zero = 'X'.
  wa_fcat-outputlen = 15.
  wa_fcat-fieldname = 'MATNR'.
  wa_fcat-seltext_l = 'MATERIAL NUMBER'.
  APPEND wa_fcat TO it_fcat.

*  wa_fcat-col_pos = '2'.
*  wa_fcat-tabname = 'IT_FINAL'.
*  wa_fcat-no_zero = 'X'.
*  wa_fcat-outputlen = 10.
*  wa_fcat-fieldname = 'WERKS'.
*  wa_fcat-seltext_l = 'Plant'.
*  APPEND wa_fcat TO it_fcat.
*  CLEAR wa_fcat.

*  wa_fcat-col_pos = '3'.
*  wa_fcat-tabname = 'IT_FINAL'.
*  wa_fcat-no_zero = 'X'.
*  wa_fcat-outputlen = 10.
*  wa_fcat-fieldname = 'EKGRP'.
*  wa_fcat-seltext_l = 'Purchase Group'.
*  APPEND wa_fcat TO it_fcat.
*  CLEAR wa_fcat.

*  wa_fcat-col_pos = '4'.
*  wa_fcat-tabname = 'IT_FINAL'.
*  wa_fcat-no_zero = 'X'.
*  wa_fcat-outputlen = 10.
*  wa_fcat-fieldname = 'STEUC'.
*  wa_fcat-seltext_l = 'HSN Code'.
*  APPEND wa_fcat TO it_fcat.
*  CLEAR wa_fcat.

*  wa_fcat-col_pos = '5'.
*  wa_fcat-tabname = 'IT_FINAL'.
*  wa_fcat-outputlen = 600.
*  wa_fcat-fieldname = 'TEXT_EN'.
*  wa_fcat-seltext_l = 'English Text'.
*  APPEND wa_fcat TO it_fcat.
*  CLEAR wa_fcat.

  CLEAR wa_fcat.
  wa_fcat-col_pos = '2'.
  wa_fcat-tabname = 'IT_FINAL'.
  wa_fcat-outputlen = 3000.
  wa_fcat-fieldname = 'TEXT_ES'.
  wa_fcat-seltext_l = 'Spanish Text'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.


FORM display_data.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = it_fcat
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  IF p_down = 'X'.

    PERFORM download.
  ENDIF.

ENDFORM.


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
*  break primus.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_download
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
  lv_file =   'ZMATERIAL_TEXT.TXT'.
*BREAK primus.
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMATERIAL_TEXT.TXT  Download started on', sy-datum, 'at', sy-uzeit.
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
*TRANSFER lv_string_939 TO lv_fullfile.
TRANSFER lv_string_297 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.




FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE  'Material'
               'Spanish Text'
               'Refreshable Date'
               'Refreshable Time'

              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
