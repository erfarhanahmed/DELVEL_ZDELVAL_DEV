*&---------------------------------------------------------------------*
*& Report ZVENDOR_INWARD_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvendor_inward_report.

TABLES:mseg.
TYPE-POOLS: slis.

TYPES:BEGIN OF ty_mseg,
        mblnr      TYPE mseg-mblnr,
        mjahr      TYPE mseg-mjahr,
        zeile      TYPE mseg-zeile,
        bwart      TYPE mseg-bwart,
        matnr      TYPE mseg-matnr,
        werks      TYPE mseg-werks,
        lifnr      TYPE mseg-lifnr,
        smbln      TYPE mseg-smbln,
        kzbew      TYPE mseg-kzbew,
        budat_mkpf TYPE mseg-budat_mkpf,
      END OF ty_mseg,

      BEGIN OF ty_mkpf,
        mblnr TYPE mkpf-mblnr,
        mjahr TYPE mkpf-mjahr,
        bldat TYPE mkpf-bldat,
        budat TYPE mkpf-budat,
        xblnr TYPE mkpf-xblnr,
        bktxt TYPE mkpf-bktxt,
      END OF ty_mkpf,

      BEGIN OF ty_lfa1,
        lifnr TYPE lfa1-lifnr,
        name1 TYPE lfa1-name1,
      END OF ty_lfa1,

      BEGIN OF ty_final,
        mblnr TYPE mkpf-mblnr,
        bldat TYPE mkpf-bldat,
        budat TYPE mkpf-budat,
        xblnr TYPE mkpf-xblnr,
        bktxt TYPE mkpf-bktxt,
        lifnr TYPE lfa1-lifnr,
        name1 TYPE lfa1-name1,
      END OF ty_final,

      BEGIN OF ty_down,
       MBLNR TYPE char15,
       XBLNR TYPE char20,
       LIFNR TYPE char15,
       NAME1 TYPE char40,
       BLDAT TYPE char15,
       BKTXT TYPE char30,
       BUDAT TYPE char15,
       ref   TYPE char15,
      END OF ty_down.

DATA : it_mseg  TYPE TABLE OF ty_mseg,
       wa_mseg  TYPE          ty_mseg,

       it_mkpf  TYPE TABLE OF ty_mkpf,
       wa_mkpf  TYPE          ty_mkpf,

       lt_mseg  TYPE TABLE OF ty_mseg,
       ls_mseg  TYPE          ty_mseg,

       it_lfa1  TYPE TABLE OF ty_lfa1,
       wa_lfa1  TYPE          ty_lfa1,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA   fs_layout TYPE slis_layout_alv.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : plant TYPE mseg-werks OBLIGATORY DEFAULT 'PL01'.
SELECT-OPTIONS : vendor FOR mseg-lifnr,
                 date   FOR mseg-budat_mkpf,
                 mblnr FOR mseg-mblnr.
SELECTION-SCREEN : END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-006.
SELECTION-SCREEN END OF LINE.

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

  SELECT mblnr
         mjahr
         zeile
         bwart
         matnr
         werks
         lifnr
         smbln
         kzbew
         budat_mkpf FROM mseg INTO TABLE it_mseg
         WHERE werks = plant
          AND  lifnr IN vendor
          AND  mblnr IN mblnr
          AND  budat_mkpf IN date
          AND  bwart = '101'
          AND  kzbew = 'B'.


  IF  it_mseg IS NOT INITIAL.
    SELECT mblnr
           mjahr
           zeile
           bwart
           matnr
           werks
           lifnr
           smbln
           kzbew
           budat_mkpf FROM mseg INTO TABLE lt_mseg
           FOR ALL ENTRIES IN it_mseg
           WHERE smbln = it_mseg-mblnr.

    SELECT lifnr
           name1 FROM lfa1 INTO TABLE it_lfa1
           FOR ALL ENTRIES IN it_mseg
           WHERE lifnr = it_mseg-lifnr.

    SELECT mblnr
           mjahr
           bldat
           budat
           xblnr
           bktxt FROM mkpf INTO TABLE it_mkpf
           FOR ALL ENTRIES IN it_mseg
           WHERE mblnr = it_mseg-mblnr.


  ENDIF.
  SORT it_mseg BY mblnr zeile.
  DELETE ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr.
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
  LOOP AT it_mseg INTO wa_mseg.
    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_mseg-lifnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    ENDIF.

    READ TABLE lt_mseg INTO ls_mseg WITH KEY smbln = wa_mseg-mblnr.
    IF sy-subrc = 4.
      wa_final-mblnr = wa_mseg-mblnr.
      wa_final-lifnr = wa_mseg-lifnr.

      READ TABLE it_mkpf INTO wa_mkpf WITH KEY mblnr = wa_mseg-mblnr.
      IF sy-subrc = 0.
        wa_final-bldat = wa_mkpf-bldat.
        wa_final-bktxt = wa_mkpf-bktxt.
        wa_final-budat = wa_mkpf-budat.
        wa_final-xblnr = wa_mkpf-xblnr.
      ENDIF.
      APPEND wa_final TO it_final.
      CLEAR: wa_final,wa_mseg,ls_mseg,wa_mkpf.
    ENDIF.


  ENDLOOP.

IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
    wa_down-MBLNR = wa_final-MBLNR.
    wa_down-XBLNR = wa_final-XBLNR.
    wa_down-LIFNR = wa_final-LIFNR.
    wa_down-NAME1 = wa_final-NAME1.
    wa_down-BKTXT = wa_final-BKTXT.


    IF wa_final-BLDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-BLDAT
          IMPORTING
            output = wa_down-BLDAT.

        CONCATENATE wa_down-BLDAT+0(2) wa_down-BLDAT+2(3) wa_down-BLDAT+5(4)
                        INTO wa_down-BLDAT SEPARATED BY '-'.
    ENDIF.

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
  PERFORM fcat USING :   '1'   'MBLNR'           'IT_FINAL'      'Document No'                 '20' ,
                         '2'   'XBLNR'           'IT_FINAL'      'Vendor Invoice Number '                '20' ,
                         '3'   'LIFNR'           'IT_FINAL'      'Vendor Code'                '20' ,
                         '4'   'NAME1'           'IT_FINAL'      'Vendor Name'                '20' ,
                         '5'   'BLDAT'           'IT_FINAL'      'Invoice Date'                '20' ,
                         '6'   'BKTXT'           'IT_FINAL'      'Invoice Value'                '20' ,
                         '7'   'BUDAT'           'IT_FINAL'      'GRN Date'                '20' .
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
*      -->P_0401   text
*      -->P_0402   text
*      -->P_0403   text
*      -->P_0404   text
*      -->P_0405   text
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
  wa_header-info = 'Vendor Inward Report'.
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


  lv_file = 'ZVENDOR_INWARD.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENDOR_INWARD REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_476 TYPE string.
DATA lv_crlf_476 TYPE string.
lv_crlf_476 = cl_abap_char_utilities=>cr_lf.
lv_string_476 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_476 lv_crlf_476 wa_csv INTO lv_string_476.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_476 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

****************************Second File************************************
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


  lv_file = 'ZVENDOR_INWARD.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENDOR_INWARD REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_514 TYPE string.
DATA lv_crlf_514 TYPE string.
lv_crlf_514 = cl_abap_char_utilities=>cr_lf.
lv_string_514 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_514 lv_crlf_514 wa_csv INTO lv_string_514.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_514 TO lv_fullfile.
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
              'GRN Date'
              'Refresh Date'
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
