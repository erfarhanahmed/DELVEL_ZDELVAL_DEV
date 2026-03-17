*&---------------------------------------------------------------------*
*& Report ZVENDOR_OUTWARD_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvendor_outward_report.

TABLES:rbkp.
TYPE-POOLS: slis.

TYPES:BEGIN OF ty_rbkp,
        belnr  TYPE rbkp-belnr,
        gjahr  TYPE rbkp-gjahr,
        blart  TYPE rbkp-blart,
        bldat  TYPE rbkp-bldat,
        budat  TYPE rbkp-budat,
        xblnr  TYPE rbkp-xblnr,
        bukrs  TYPE rbkp-bukrs,
        lifnr  TYPE rbkp-lifnr,
        rmwwr  TYPE rbkp-rmwwr,
        wmwst1 TYPE  rbkp-wmwst1,
        mwskz1 TYPE rbkp-mwskz1,
        sgtxt  TYPE rbkp-sgtxt,
      END OF ty_rbkp,

      BEGIN OF ty_bkpf,
        bukrs TYPE bkpf-bukrs,
        belnr TYPE bkpf-belnr,
        gjahr TYPE bkpf-gjahr,
        blart TYPE bkpf-blart,
        awkey TYPE bkpf-awkey,
      END OF ty_bkpf,

      BEGIN OF ty_final,
        belnr  TYPE rbkp-belnr,
        inv    TYPE rbkp-belnr,
        lifnr  TYPE rbkp-lifnr,
        name   TYPE lfa1-name1,
        budat  TYPE rbkp-budat,
        rmwwr  TYPE rbkp-rmwwr,
        awkey  TYPE bkpf-awkey,
        wmwst1 TYPE  rbkp-wmwst1,
        mwskz1 TYPE rbkp-mwskz1,
        sgtxt  TYPE rbkp-sgtxt,
      END OF ty_final,

      BEGIN OF ty_down,
      BELNR  TYPE char15,
      INV    TYPE char15,
      LIFNR  TYPE char15,
      NAME   TYPE char40,
      BUDAT  TYPE char15,
      RMWWR  TYPE char15,
      WMWST1 TYPE char15,
      MWSKZ1 TYPE char5,
      SGTXT  TYPE char50,
      ref    TYPE char15,
      END OF ty_down.
DATA : it_rbkp  TYPE TABLE OF ty_rbkp,
       wa_rbkp  TYPE          ty_rbkp,

       it_bkpf  TYPE TABLE OF ty_bkpf,
       wa_bkpf  TYPE          ty_bkpf,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA   fs_layout TYPE slis_layout_alv.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: bukrs TYPE rbkp-bukrs OBLIGATORY DEFAULT '1000'.
SELECT-OPTIONS: vendor FOR rbkp-lifnr,
                date   FOR rbkp-budat.
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
  SELECT belnr
         gjahr
         blart
         bldat
         budat
         xblnr
         bukrs
         lifnr
         rmwwr
         wmwst1
         mwskz1
         sgtxt  FROM rbkp INTO TABLE it_rbkp
         WHERE bukrs = bukrs
           AND budat IN date
           AND lifnr IN vendor
           AND blart = 'KG'.
*
*IF it_rbkp IS NOT INITIAL.
*SELECT bukrs
*       belnr
*       gjahr
*       blart
*       awkey FROM bkpf INTO TABLE it_bkpf
*       FOR ALL ENTRIES IN it_rbkp
*       WHERE awkey = it_rbkp-belnr.
*
*
*
*ENDIF.


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
  LOOP AT it_rbkp INTO wa_rbkp.
    wa_final-belnr = wa_rbkp-belnr.
    wa_final-budat = wa_rbkp-budat.
    wa_final-rmwwr = wa_rbkp-rmwwr.
    wa_final-budat = wa_rbkp-budat.
    wa_final-lifnr = wa_rbkp-lifnr.
    wa_final-wmwst1  = wa_rbkp-wmwst1 .
    wa_final-mwskz1 = wa_rbkp-mwskz1.
    wa_final-sgtxt  = wa_rbkp-sgtxt .
    CONCATENATE wa_rbkp-belnr wa_rbkp-gjahr INTO wa_final-awkey.

    SELECT SINGLE belnr INTO wa_final-inv FROM bkpf WHERE awkey = wa_final-awkey.

    SELECT SINGLE name1 INTO wa_final-name FROM lfa1 WHERE lifnr = wa_rbkp-lifnr.

    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.

  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
     wa_down-BELNR  = wa_final-BELNR .
     wa_down-INV    = wa_final-INV   .
     wa_down-LIFNR  = wa_final-LIFNR .
     wa_down-NAME   = wa_final-NAME  .
*     wa_down-BUDAT  = wa_final-BUDAT .
     wa_down-RMWWR  = wa_final-RMWWR .
     wa_down-WMWST1 = wa_final-WMWST1.
     wa_down-MWSKZ1 = wa_final-MWSKZ1.
     wa_down-SGTXT  = wa_final-SGTXT .
*     wa_down-ref    = wa_final-ref   .

   IF wa_final-BUDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-BUDAT
          IMPORTING
            output = wa_down-BUDAT.

        CONCATENATE wa_down-BUDAT+0(2) wa_down-BUDAT+2(3) wa_down-BUDAT+5(4)
                        INTO wa_down-BUDAT SEPARATED BY '-'.
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
  PERFORM fcat USING :   '1'   'BELNR'           'IT_FINAL'       'Document No'                 '20' ,
                         '2'   'INV'             'IT_FINAL'       'Vendor Invoice Number '                '20' ,
                         '3'   'LIFNR'           'IT_FINAL'       'Vendor Code'                '20' ,
                         '4'   'NAME'            'IT_FINAL'       'Vendor Name'                '20' ,
                         '5'   'BUDAT'           'IT_FINAL'       'Invoice Date'                '20' ,
                         '6'   'RMWWR'           'IT_FINAL'       'Invoice Value'                '20' ,
                         '7'   'WMWST1'           'IT_FINAL'      'Tax Amount'                '20' ,
                         '8'   'MWSKZ1'           'IT_FINAL'      'Tax Code'                '20' ,
                         '9'   'SGTXT '           'IT_FINAL'      'Text'                    '20' .
*                       '7'   'BUDAT'           'IT_FINAL'      'GRN Date'                '20' .
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
  wa_header-info = 'Vendor Outward Report'.
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


  lv_file = 'ZVENDOR_OUTWARD.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENDOR_OUTWARD REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_435 TYPE string.
DATA lv_crlf_435 TYPE string.
lv_crlf_435 = cl_abap_char_utilities=>cr_lf.
lv_string_435 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_435 lv_crlf_435 wa_csv INTO lv_string_435.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_435 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

********************************Second File**********************************
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


  lv_file = 'ZVENDOR_OUTWARD.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENDOR_OUTWARD REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_473 TYPE string.
DATA lv_crlf_473 TYPE string.
lv_crlf_473 = cl_abap_char_utilities=>cr_lf.
lv_string_473 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_473 lv_crlf_473 wa_csv INTO lv_string_473.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_473 TO lv_fullfile.
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
              'Vendor Invoice Number'
              'Vendor Code'
              'Vendor Name'
              'Invoice Date'
              'Invoice Value'
              'Tax Amount'
              'Tax Code'
              'Text'
              'Refresh Date'
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
