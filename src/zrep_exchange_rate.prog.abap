*&---------------------------------------------------------------------*
*& Report ZREP_EXCHANGE_RATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrep_exchange_rate.

TABLES : tcurr.

TYPE-POOLS : slis.

TYPES : BEGIN OF ty_tcurr,
          kurst TYPE tcurr-kurst,
          fcurr TYPE tcurr-fcurr,
          tcurr TYPE tcurr-tcurr,
          gdatu TYPE tcurr-gdatu,
          ukurs TYPE tcurr-ukurs,
        END OF ty_tcurr.

TYPES : BEGIN OF ty_final,
          kurst TYPE tcurr-kurst,
          fcurr TYPE tcurr-fcurr,
          tcurr TYPE tcurr-tcurr,
          gdatu TYPE char20,
          ukurs TYPE char20,
          ref   TYPE char20,
          time  TYPE char20,
        END OF ty_final.

TYPES : BEGIN OF ty_down,
          kurst TYPE char20,
          fcurr TYPE char20,
          tcurr TYPE char20,
          gdatu TYPE char20,
          ukurs TYPE char20,
          ref   TYPE char20,
          time  TYPE char20,
        END OF ty_down.

DATA : lt_tcurr TYPE STANDARD TABLE OF ty_tcurr,
       ls_tcurr TYPE ty_tcurr,
       lt_final TYPE TABLE OF ty_final,
       ls_final TYPE ty_final.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE ty_down.

DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
DATA : fs_layout TYPE slis_layout_alv.

DATA : t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_kurst FOR tcurr-kurst,
                 s_fcurr FOR tcurr-fcurr,
                 s_tcurr FOR tcurr-tcurr,
                 s_gdatu FOR tcurr-gdatu.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM fetch_data.
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

  SELECT kurst
         fcurr
         tcurr
         gdatu
         ukurs
         FROM tcurr
         INTO TABLE lt_tcurr
         WHERE kurst IN s_kurst
         AND   fcurr IN s_fcurr
         AND   tcurr IN s_tcurr
         AND   gdatu IN s_gdatu.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  LOOP AT lt_tcurr INTO ls_tcurr.

    ls_final-kurst = ls_tcurr-kurst.
    ls_final-fcurr = ls_tcurr-fcurr.
    ls_final-tcurr = ls_tcurr-tcurr.
    ls_final-gdatu = ls_tcurr-gdatu.
    ls_final-ukurs = ls_tcurr-ukurs.

*     IF ls_final-ukurs < 0.
*        CONCATENATE '-' ls_final-ukurs INTO ls_final-ukurs.
*     ENDIF.
*     CONDENSE ls_final-ukurs NO-GAPS.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = ls_final-ukurs.

    CALL FUNCTION 'CONVERSION_EXIT_INVDT_OUTPUT'
      EXPORTING
        input  = ls_tcurr-gdatu
      IMPORTING
        output = ls_final-gdatu.

    REPLACE ALL OCCURRENCES OF '.' IN ls_final-gdatu WITH space.

    CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
      EXPORTING
        date_external            = ls_final-gdatu
*       ACCEPT_INITIAL_DATE      =
      IMPORTING
        date_internal            = ls_final-gdatu
      EXCEPTIONS
        date_external_is_invalid = 1
        OTHERS                   = 2.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-gdatu
      IMPORTING
        output = ls_final-gdatu.

    CONCATENATE ls_final-gdatu+0(2) ls_final-gdatu+2(3) ls_final-gdatu+5(4)
                    INTO ls_final-gdatu SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_final-ref.

    CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                    INTO ls_final-ref SEPARATED BY '-'.

    CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO ls_final-time SEPARATED BY ':'.

    APPEND ls_final TO lt_final.
    CLEAR : ls_final.

  ENDLOOP.

  IF p_down = 'X'.
    LOOP AT lt_final INTO ls_final.

      ls_down-kurst     = ls_final-kurst.
      ls_down-fcurr     = ls_final-fcurr.
      ls_down-tcurr     = ls_final-tcurr.
      ls_down-gdatu     = ls_final-gdatu.
      ls_down-ukurs     = ls_final-ukurs.
      ls_down-ref       = ls_final-ref.
      ls_down-time      = ls_final-time.

      APPEND ls_down TO lt_down.
      CLEAR ls_down.

    ENDLOOP.
  ENDIF.

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

  PERFORM fcat USING :  '1'  'KURST'           'LT_FINAL'  'Exchange rate type'  '20',
                        '1'  'FCURR'           'LT_FINAL'  'From currency'       '20',
                        '1'  'TCURR'           'LT_FINAL'  'To-currency'         '20',
                        '1'  'GDATU'           'LT_FINAL'  'Date'                '20',
                        '1'  'UKURS'           'LT_FINAL'  'Exchange Rate'       '20'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0905   text
*      -->P_0906   text
*      -->P_0907   text
*      -->P_0908   text
*      -->P_0909   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  t_fieldcat-col_pos   = p1.
  t_fieldcat-fieldname = p2.
  t_fieldcat-tabname   = p3.
  t_fieldcat-seltext_l = p4.
  t_fieldcat-outputlen = p5.

  APPEND t_fieldcat.
  CLEAR t_fieldcat.

ENDFORM.
FORM top-of-page.

*ALV Header declarations
  DATA: lt_header     TYPE slis_t_listheader,
        ls_header     TYPE slis_listheader,
        t_line        LIKE ls_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

* Title
  ls_header-typ  = 'H'.
  ls_header-info = 'Exchange Rate Details'.
  APPEND ls_header TO lt_header.
  CLEAR ls_header.

* Total No. of Records Selected
  DESCRIBE TABLE lt_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  ls_header-typ  = 'A'.
  ls_header-info = t_line.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
*       i_logo             =

ENDFORM.                    " top-of-page
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
      i_callback_program     = sy-repid
      is_layout              = fs_layout
      i_callback_top_of_page = 'TOP-OF-PAGE'
      it_fieldcat            = t_fieldcat[]
      it_sort                = t_sort[]
      i_save                 = 'X'
    TABLES
      t_outtab               = lt_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
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
      i_tab_sap_data       = lt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

  lv_file = 'ZFIN_CURR.TXT'.

*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZREP_EXCHANGE_RATE', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_347 TYPE string.
DATA lv_crlf_347 TYPE string.
lv_crlf_347 = cl_abap_char_utilities=>cr_lf.
lv_string_347 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_347 lv_crlf_347 wa_csv INTO lv_string_347.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1024 TO lv_fullfile.
TRANSFER lv_string_347 TO lv_fullfile.
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
FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE 'Exchange rate type'
              'From currency'
              'To-currency'
              'Date'
              'Exchange Rate'
              'Refresh Date'
              'Refresh Time'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
