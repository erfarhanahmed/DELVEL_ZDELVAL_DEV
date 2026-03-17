*&---------------------------------------------------------------------*
*& Report ZVENDOR_PENALTY_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvendor_penalty_report.

TABLES:vbrk.
TYPE-POOLS: slis.

TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
          fkdat TYPE vbrk-fkdat,
          bukrs TYPE vbrk-bukrs,
          netwr TYPE vbrk-netwr,
          kunag TYPE vbrk-kunag,
          mwsbk TYPE vbrk-mwsbk,
          xblnr TYPE vbrk-xblnr,
        END OF ty_vbrk,

        BEGIN OF ty_final,
          vbeln TYPE vbrk-vbeln,
          fkdat TYPE vbrk-fkdat,
          kunag TYPE vbrk-kunag,
          name  TYPE lfa1-name1,
          xblnr TYPE vbrk-xblnr,
          value TYPE vbrk-netwr,
          netwr TYPE vbrk-netwr,
          mwsbk TYPE vbrk-mwsbk,
          lifnr TYPE lfa1-lifnr,
        END OF ty_final,

        BEGIN OF ty_down,
         VBELN TYPE char15,
         XBLNR TYPE char20,
         KUNAG TYPE char15,
         NAME  TYPE char40,
         FKDAT TYPE char15,
         NETWR TYPE char15,
         MWSBK TYPE char15,
         VALUE TYPE char15,
         LIFNR TYPE char15,
         ref   TYPE char15,
        END OF ty_down.

DATA :it_vbrk  TYPE TABLE OF ty_vbrk,
      wa_vbrk  TYPE          ty_vbrk,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final,

      it_down  TYPE TABLE OF ty_down,
      wa_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA   fs_layout TYPE slis_layout_alv.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: bukrs TYPE vbrk-bukrs OBLIGATORY DEFAULT '1000'.
SELECT-OPTIONS: vendor FOR vbrk-kunag,
                date   FOR vbrk-fkdat.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM sort_data.
  PERFORM get_fcat.
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

  SELECT vbeln
         fkart
         fkdat
         bukrs
         netwr
         kunag
         mwsbk
         xblnr FROM vbrk INTO TABLE it_vbrk
         WHERE bukrs = bukrs
           AND kunag IN vendor
           AND fkdat IN date
           AND fkart = 'ZSER'.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
  LOOP AT it_vbrk INTO wa_vbrk.
    wa_final-vbeln = wa_vbrk-vbeln.
    wa_final-vbeln = wa_vbrk-vbeln.
    wa_final-fkdat = wa_vbrk-fkdat.
    wa_final-kunag = wa_vbrk-kunag.
    wa_final-xblnr = wa_vbrk-xblnr.
    wa_final-netwr = wa_vbrk-netwr.
    wa_final-mwsbk = wa_vbrk-mwsbk.

    wa_final-value = wa_final-netwr + wa_final-mwsbk.

    SELECT SINGLE name1 lifnr INTO ( wa_final-name,wa_final-lifnr ) FROM kna1 WHERE kunnr = wa_final-kunag.



    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.

IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
     wa_down-VBELN = wa_final-VBELN.
     wa_down-XBLNR = wa_final-XBLNR.
     wa_down-KUNAG = wa_final-KUNAG.
     wa_down-NAME  = wa_final-NAME .
     wa_down-FKDAT = wa_final-FKDAT.
     wa_down-NETWR = wa_final-NETWR.
     wa_down-MWSBK = wa_final-MWSBK.
     wa_down-VALUE = wa_final-VALUE.
     wa_down-LIFNR = wa_final-LIFNR.

     IF wa_final-FKDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-FKDAT
          IMPORTING
            output = wa_down-FKDAT.

        CONCATENATE wa_down-FKDAT+0(2) wa_down-FKDAT+2(3) wa_down-FKDAT+5(4)
                        INTO wa_down-FKDAT SEPARATED BY '-'.
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
FORM get_fcat .
  PERFORM fcat USING :   '1'   'VBELN'           'IT_FINAL'      'Document No'                 '20' ,
                         '2'   'XBLNR'           'IT_FINAL'      'Vendor Invoice Number '                '20' ,
                         '3'   'KUNAG'           'IT_FINAL'      'Customer Code'                '20' ,
                         '4'   'NAME'            'IT_FINAL'      'Vendor Name'                '20' ,
                         '5'   'FKDAT'           'IT_FINAL'      'Invoice Date'                '20' ,
                         '6'   'NETWR'           'IT_FINAL'      'Net Value'                  '20' ,
                         '7'   'MWSBK'           'IT_FINAL'      'Tax Value'                  '20' ,
                         '8'   'VALUE'           'IT_FINAL'      'Invoice Value'                '20' ,
                         '9'   'LIFNR'           'IT_FINAL'      'Vendor Code'                '20' .




ENDFORM.
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
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      i_callback_top_of_page = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = fs_layout
      it_fieldcat            = it_fcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = ' '
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
IF p_down = 'X'.

    PERFORM download.

ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0287   text
*      -->P_0288   text
*      -->P_0289   text
*      -->P_0290   text
*      -->P_0291   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
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
*&      Form  top-of-page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top-of-page.

*  ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c,
*        year          TYPE char10,
        period        TYPE char100.



*  Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Vendor Penalty Report'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.



*  Date
  wa_header-typ  = 'S'.
  wa_header-key  = 'Run Date : '.
  CONCATENATE wa_header-info sy-datum+6(2) '.' sy-datum+4(2) '.'
                      sy-datum(4) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

*  Time
  wa_header-typ  = 'S'.
  wa_header-key  = 'Run Time: '.
  CONCATENATE wa_header-info sy-timlo(2) ':' sy-timlo+2(2) ':'
                      sy-timlo+4(2) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

*   Total No. of Records Selected
  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
ENDFORM.                    " top-of-p
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


  lv_file = 'ZVENDOR_PENALTY.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENDOR_PENALTY REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_408 TYPE string.
DATA lv_crlf_408 TYPE string.
lv_crlf_408 = cl_abap_char_utilities=>cr_lf.
lv_string_408 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_408 lv_crlf_408 wa_csv INTO lv_string_408.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_408 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*************************************Second File********************************
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


  lv_file = 'ZVENDOR_PENALTY.TXT'.


  CONCATENATE p_folder '/'  lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENDOR_PENALTY REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_445 TYPE string.
DATA lv_crlf_445 TYPE string.
lv_crlf_445 = cl_abap_char_utilities=>cr_lf.
lv_string_445 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_445 lv_crlf_445 wa_csv INTO lv_string_445.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_445 TO lv_fullfile.
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
  CONCATENATE 'Document No'
              'Vendor Invoice Number '
              'Customer Code'
              'Vendor Name'
              'Invoice Date'
              'Net Value'
              'Tax Value'
              'Invoice Value'
              'Vendor Code'
              'Refresh Date'
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
