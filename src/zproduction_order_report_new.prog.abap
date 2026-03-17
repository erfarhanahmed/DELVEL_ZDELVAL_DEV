*&---------------------------------------------------------------------*
*& Report ZPRODUCTION_ORDER_REPORT_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPRODUCTION_ORDER_REPORT_NEW.

TABLES:AUFK.

TYPES:BEGIN OF ty_aufk,
      AUFNR TYPE aufk-AUFNR,
      AUART TYPE aufk-AUART,
      ERNAM TYPE aufk-ERNAM,
      ERDAT TYPE aufk-ERDAT,
      BUKRS TYPE aufk-BUKRS,
      WERKS TYPE aufk-WERKS,
      LOEKZ TYPE aufk-LOEKZ,
      KDAUF TYPE aufk-KDAUF,
      KDPOS TYPE aufk-KDPOS,
      END OF ty_aufk,

      BEGIN OF ty_afko,
      aufnr TYPE afko-aufnr,
      GAMNG TYPE afko-GAMNG,
      END OF ty_afko,

      BEGIN OF ty_final,
      AUFNR TYPE aufk-AUFNR,
      AUART TYPE aufk-AUART,
      ERDAT TYPE aufk-ERDAT,
      KDAUF TYPE aufk-KDAUF,
      KDPOS TYPE aufk-KDPOS,
      kunnr TYPE kna1-kunnr,
      name1 TYPE kna1-name1,
      GAMNG TYPE afko-GAMNG,
      LOEKZ TYPE aufk-LOEKZ,
      matnr TYPE afpo-matnr,
      text  TYPE string,
      END OF ty_final,

      BEGIN OF ty_down,
      AUART  TYPE aufk-AUART,
      AUFNR  TYPE aufk-aufnr,
      ERDAT  TYPE char15,
      KDAUF  TYPE aufk-kdauf,
      KDPOS  TYPE aufk-kdpos,
      KUNNR  TYPE kna1-kunnr,
      NAME1  TYPE kna1-name1,
      GAMNG  TYPE char10,
      LOEKZ  TYPE aufk-loekz,
      ref    TYPE char15,
      matnr  TYPE afpo-matnr,
      text   TYPE string,
      END OF ty_down.


DATA: it_aufk TYPE TABLE OF ty_aufk,
      wa_aufk TYPE          ty_aufk,

      it_afko TYPE TABLE OF ty_afko,
      wa_afko TYPE          ty_afko,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final,

      it_down  TYPE TABLE OF ty_down,
      wa_down  TYPE          ty_down,

      wa_vbak TYPE vbak,
      wa_kna1 TYPE kna1.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : lv_text TYPE tdobname.
DATA : lt_lines TYPE TABLE OF tline,
       ls_lines TYPE tline.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_AUFNR FOR AUFK-AUFNR,
                S_ERDAT FOR AUFK-ERDAT,
                S_KDAUF FOR AUFK-KDAUF,
                S_AUART FOR AUFK-AUART.
PARAMETERS    : P_BUKRS TYPE AUFK-BUKRS OBLIGATORY DEFAULT '1000'.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp'.         "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.


START-OF-SELECTION.

PERFORM GET_DATA.
PERFORM SORT_DATA.
PERFORM GET_FCAT.
PERFORM DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
SELECT AUFNR
       AUART
       ERNAM
       ERDAT
       BUKRS
       WERKS
       LOEKZ
       KDAUF
       KDPOS FROM AUFK INTO TABLE IT_AUFK
       WHERE AUFNR IN S_AUFNR
         AND AUART IN S_AUART
         AND ERDAT IN S_ERDAT
         AND KDAUF IN S_KDAUF
         AND BUKRS = P_BUKRS
         AND loekz = 'X'.

IF IT_AUFK IS NOT INITIAL.
  SELECT aufnr
         GAMNG FROM AFKO INTO TABLE IT_AFKO
         FOR ALL ENTRIES IN IT_AUFK
         WHERE AUFNR = IT_AUFK-AUFNR.
ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_DATA .
LOOP AT IT_AUFK INTO WA_AUFK.
  WA_FINAL-AUFNR = WA_AUFK-AUFNR.
  WA_FINAL-AUART = WA_AUFK-AUART.
  WA_FINAL-ERDAT = WA_AUFK-ERDAT.
  WA_FINAL-KDAUF = WA_AUFK-KDAUF.
  WA_FINAL-KDPOS = WA_AUFK-KDPOS.
  WA_FINAL-LOEKZ = WA_AUFK-LOEKZ.
*  WA_FINAL-AUFNR = WA_AUFK-AUFNR.

READ TABLE IT_AFKO INTO WA_AFKO WITH KEY AUFNR = WA_FINAL-AUFNR.
  IF SY-SUBRC = 0.
    WA_FINAL-GAMNG = WA_AFKO-GAMNG.
  ENDIF.

SELECT SINGLE KUNNR INTO WA_FINAL-KUNNR FROM VBAK WHERE VBELN = WA_FINAL-KDAUF.
SELECT SINGLE NAME1 INTO WA_FINAL-NAME1 FROM KNA1 WHERE KUNNR = WA_FINAL-KUNNR.
SELECT SINGLE MATNR INTO WA_FINAL-MATNR FROM AFPO WHERE AUFNR = WA_FINAL-AUFNR.

  lv_text = wa_final-matnr .


      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = 'E'
          name                    = lv_text
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

      IF lt_lines IS NOT INITIAL.
        LOOP AT  lt_lines INTO ls_lines.
          CONCATENATE wa_final-text  ls_lines-tdline INTO wa_final-text SEPARATED BY space.
        ENDLOOP.
      ENDIF .

  APPEND wa_final TO it_final.
    CLEAR :wa_final.
ENDLOOP.

IF p_down = 'X'.
  LOOP AT it_final INTO wa_final.
    wa_down-AUART = wa_final-AUART.
    wa_down-AUFNR = wa_final-AUFNR.
*    wa_down-ERDAT = wa_final-ERDAT.
    wa_down-KDAUF = wa_final-KDAUF.
    wa_down-KDPOS = wa_final-KDPOS.
    wa_down-KUNNR = wa_final-KUNNR.
    wa_down-NAME1 = wa_final-NAME1.
    wa_down-GAMNG = wa_final-GAMNG.
    wa_down-LOEKZ = wa_final-LOEKZ.
    wa_down-MATNR = wa_final-MATNR.
    wa_down-TEXT = wa_final-TEXT.
*    wa_down-ref   = wa_final-ref  .

    IF wa_final-ERDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-ERDAT
          IMPORTING
            output = wa_down-ERDAT.

        CONCATENATE wa_down-ERDAT+0(2) wa_down-ERDAT+2(3) wa_down-ERDAT+5(4)
                        INTO wa_down-ERDAT SEPARATED BY '-'.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

      APPEND wa_down TO it_down.
      CLEAR wa_down.

  ENDLOOP.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
PERFORM fcat USING :   '1'   'AUART'           'IT_FINAL'      'Order Type'                       '15' ,
                       '2'   'AUFNR'           'IT_FINAL'      'Production Order'                 '15' ,
                       '3'   'ERDAT'           'IT_FINAL'      'Order Date'                       '15' ,
                       '4'   'KDAUF'           'IT_FINAL'      'Sales Order'                      '15' ,
                       '5'   'KDPOS'           'IT_FINAL'      'Sales Order Item'                 '15' ,
                       '6'   'KUNNR'           'IT_FINAL'      'Customer Code'                    '15' ,
                       '7'   'NAME1'           'IT_FINAL'      'Customer Name'                    '15' ,
                       '8'   'GAMNG'           'IT_FINAL'      'Order Qty'                        '15' ,
                       '9'   'LOEKZ'           'IT_FINAL'      'Deletion Ind'                     '15' ,
                      '10'   'MATNR'           'IT_FINAL'      'Material Code'                    '15' ,
                      '11'   'TEXT'            'IT_FINAL'      'Long Text'                        '15' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .

IF p_down = 'X'.

    PERFORM download.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0342   text
*      -->P_0343   text
*      -->P_0344   text
*      -->P_0345   text
*      -->P_0346   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .
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
      i_tab_sap_data       = it_down
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


  lv_file = 'ZPROD_DEL.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPROD_DEL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_402 TYPE string.
DATA lv_crlf_402 TYPE string.
lv_crlf_402 = cl_abap_char_utilities=>cr_lf.
lv_string_402 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_402 lv_crlf_402 wa_csv INTO lv_string_402.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_982 TO lv_fullfile.
TRANSFER lv_string_402 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
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


  lv_file = 'ZPROD_DEL.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPROD_DEL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_439 TYPE string.
DATA lv_crlf_439 TYPE string.
lv_crlf_439 = cl_abap_char_utilities=>cr_lf.
lv_string_439 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_439 lv_crlf_439 wa_csv INTO lv_string_439.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_982 TO lv_fullfile.
TRANSFER lv_string_439 TO lv_fullfile.
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
FORM CVS_HEADER  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Order Type'
              'Production Order'
              'Order Date'
              'Sales Order'
              'Sales Order Item'
              'Customer Code'
              'Customer Name'
              'Order Qty'
              'Deletion Ind'
              'Refresh Date'
              'Material Code'
              'Long Text'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
