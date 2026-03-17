*&---------------------------------------------------------------------*
*& Report ZJOURNAL_ENTRIES_REPORT
*&---------------------------------------------------------------------*
*&         0. PROGRAM OWNER          : PRIMUS TECHSYSTEMS PVT LTD.
*&         1. FS NO                  : 4000000036
*&         2. PROJECT                : DELVAL
*&         3. PROGRAM NAME           : ZJOURNAL_ENTRIES_REPORT
*&         4. TRANS CODE             :
*&         5. MODULE NAME            : FI
*&         7. CREATION DATE          : 14/04/2021
*&         8. DEVELOPER NAME         : SNEHAL RAJALE
*&         9. FUNCTIONAL CONSULTANT  : SWAPNIL KOPPAL
*&---------------------------------------------------------------------*
REPORT zjournal_entries_report.

TYPE-POOLS: slis.

TABLES : bkpf,bseg,t003t,skat,ska1.

TYPES : BEGIN OF ty_bkpf,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          blart TYPE bkpf-blart,
          bldat TYPE bkpf-bldat,
          budat TYPE bkpf-budat,
          usnam TYPE bkpf-usnam,
          waers TYPE bkpf-waers,
          ppnam TYPE bkpf-ppnam,
        END OF ty_bkpf,

        BEGIN OF ty_bseg,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          buzei TYPE bseg-buzei,
          umskz TYPE bseg-umskz,
          shkzg TYPE bseg-shkzg,
          mwskz TYPE bseg-mwskz,
          qsskz TYPE bseg-qsskz,
          dmbtr TYPE bseg-dmbtr,
          wrbtr TYPE bseg-wrbtr,
          pswsl TYPE bseg-pswsl,
          sgtxt TYPE bseg-sgtxt,
          kostl TYPE bseg-kostl,
          hkont TYPE bseg-hkont,
          kunnr TYPE bseg-kunnr,
          lifnr TYPE bseg-lifnr,
          prctr TYPE bseg-prctr,
          saknr TYPE bseg-saknr,
        END OF ty_bseg,

        BEGIN OF ty_t003t,
          spras TYPE t003t-spras,
          blart TYPE t003t-blart,
          ltext TYPE t003t-ltext,
        END OF ty_t003t,

        BEGIN OF ty_skat,
          spras TYPE skat-spras,
          ktopl TYPE skat-ktopl,
          saknr TYPE skat-saknr,
          txt50 TYPE skat-txt50,
        END OF ty_skat,

        BEGIN OF ty_ska1,
          ktopl TYPE ska1-ktopl,
          saknr TYPE ska1-saknr,
          xbilk TYPE ska1-xbilk,
        END OF ty_ska1,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1,

        BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          name1 TYPE lfa1-name1,
        END OF ty_lfa1.

TYPES : BEGIN OF ty_final,
          sel,
          belnr TYPE bkpf-belnr,   "Document Number
          bldat TYPE bkpf-bldat,   "Document Date
          budat TYPE bkpf-budat,   "Posting Date
          kunnr TYPE bseg-kunnr,   "Customer code
          name1 TYPE kna1-name1,   "Customer Name
          lifnr TYPE bseg-lifnr,   "vendor code
          vname TYPE lfa1-name1,   "vendor name
          sgtxt TYPE bseg-sgtxt,   "narration
          blart TYPE bkpf-blart,   "Document Type
          ltext TYPE t003t-ltext,  "Description of Document Type
          hkont TYPE bseg-hkont,   "GL Code
          txt50 TYPE skat-txt50,   "GL Description
          xbilk TYPE char50,       "GL Type
          wrbtr TYPE bseg-wrbtr,   "Amount(Document currency)
          shkzg TYPE bseg-shkzg,   "Indicator
          waers TYPE bkpf-waers,   "Currency
          dmbtr TYPE bseg-dmbtr,   "Amount(Local currency)
          pswsl TYPE bseg-pswsl,   "Currency
          mwskz TYPE bseg-mwskz,   "Tax Code
          qsskz TYPE bseg-qsskz,   "With Holding Tax Code
          kostl TYPE bseg-kostl,   "Cost Center
          prctr TYPE bseg-prctr,   "Profit Center
          ppnam TYPE bkpf-ppnam,   "Parked by(entered by)
          usnam TYPE bkpf-usnam,   "Posted by
        END OF ty_final,

        BEGIN OF ty_ref,
          belnr    TYPE bkpf-belnr,   "Document Number
          bldat    TYPE char18,       "Document Date
          budat    TYPE char18,       "Posting Date
          kunnr    TYPE bseg-kunnr,   "Customer code
          name1    TYPE kna1-name1,   "Customer Name
          lifnr    TYPE bseg-lifnr,   "vendor code
          vname    TYPE lfa1-name1,   "vendor name
          sgtxt    TYPE bseg-sgtxt,   "narration
          blart    TYPE bkpf-blart,   "Document Type
          ltext    TYPE t003t-ltext,  "Description of Document Type
          hkont    TYPE bseg-hkont,   "GL Code
          txt50    TYPE skat-txt50,   "GL Description
          xbilk    TYPE char50,       "GL Type
          wrbtr    TYPE string,       "Amount(Document currency)
          shkzg    TYPE bseg-shkzg,   "Indicator
          waers    TYPE string,       "Currency
          dmbtr    TYPE string,       "Amount(Local currency)
          pswsl    TYPE string,       "Currency
          mwskz    TYPE bseg-mwskz,   "Tax Code
          qsskz    TYPE bseg-qsskz,   "With Holding Tax Code
          kostl    TYPE bseg-kostl,   "Cost Center
          prctr    TYPE bseg-prctr,   "Profit Center
          ppnam    TYPE bkpf-ppnam,   "Parked by(entered by)
          usnam    TYPE bkpf-usnam,   "Posted by
          ref_dat  TYPE char15,       "Refresh Date
          ref_time TYPE char15,       "Refresh Time
        END OF ty_ref.

DATA : lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_ref   TYPE TABLE OF ty_ref,
       ls_ref   TYPE          ty_ref,

       lt_bkpf  TYPE TABLE OF ty_bkpf,
       ls_bkpf  TYPE          ty_bkpf,

       lt_bseg  TYPE TABLE OF ty_bseg,
       ls_bseg  TYPE          ty_bseg,

       lt_skat  TYPE TABLE OF ty_skat,
       ls_skat  TYPE          ty_skat,

       lt_ska1  TYPE TABLE OF ty_ska1,
       ls_ska1  TYPE          ty_ska1,

       lt_t003t TYPE TABLE OF ty_t003t,
       ls_t003t TYPE          ty_t003t,

       lt_kna1  TYPE TABLE OF ty_kna1,
       ls_kna1  TYPE          ty_kna1,

       lt_lfa1  TYPE TABLE OF ty_lfa1,
       ls_lfa1  TYPE          ty_lfa1.

DATA : lt_fcat TYPE slis_t_fieldcat_alv,
       ls_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS     : p_compco TYPE bkpf-bukrs OBLIGATORY.
SELECT-OPTIONS : s_doctyp   FOR bkpf-blart,
                 s_date     FOR bkpf-budat.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

START-OF-SELECTION.

  PERFORM get_data.


*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT bukrs
         belnr
         gjahr
         blart
         bldat
         budat
         usnam
         waers
         ppnam
    FROM bkpf
    INTO TABLE lt_bkpf
    WHERE blart IN s_doctyp AND
          budat IN s_date   AND
          bukrs = p_compco.

  IF lt_bkpf IS NOT INITIAL.

    SELECT bukrs
           belnr
           gjahr
           buzei
           umskz
           shkzg
           mwskz
           qsskz
           dmbtr
           wrbtr
           pswsl
           sgtxt
           kostl
           hkont
           kunnr
           lifnr
           prctr
      FROM bseg
      INTO TABLE lt_bseg
      FOR ALL ENTRIES IN lt_bkpf
      WHERE belnr = lt_bkpf-belnr AND
            bukrs = lt_bkpf-bukrs AND
            gjahr = lt_bkpf-gjahr.

    SORT lt_bseg BY belnr.

    SELECT spras
           blart
           ltext
      FROM t003t
      INTO TABLE lt_t003t
      FOR ALL ENTRIES IN lt_bkpf
      WHERE blart = lt_bkpf-blart AND
            spras = 'EN'.

  ENDIF.

  IF lt_bseg IS NOT INITIAL.

    SELECT spras
           ktopl
           saknr
           txt50
      FROM skat
      INTO TABLE lt_skat
      FOR ALL ENTRIES IN lt_bseg
      WHERE saknr = lt_bseg-hkont AND
            ktopl = lt_bseg-bukrs AND
            spras = 'EN'.

    SELECT kunnr
           name1
      FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN lt_bseg
      WHERE kunnr = lt_bseg-kunnr.

    SELECT lifnr
           name1
      FROM lfa1
      INTO TABLE lt_lfa1
      FOR ALL ENTRIES IN lt_bseg
      WHERE lifnr = lt_bseg-lifnr.

  ENDIF.

  IF lt_skat IS NOT INITIAL.

    SELECT ktopl
           saknr
           xbilk
      FROM ska1
      INTO TABLE lt_ska1
      FOR ALL ENTRIES IN lt_skat
      WHERE saknr = lt_skat-saknr AND
            ktopl = lt_skat-ktopl.

  ENDIF.

  IF lt_bkpf IS NOT INITIAL.
    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM sort_ref.
    PERFORM display.
  ELSE.
    MESSAGE 'No Data Found!' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
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
FORM sort_data .

  LOOP AT lt_bseg INTO ls_bseg.

    ls_final-belnr = ls_bseg-belnr.
    ls_final-hkont = ls_bseg-hkont.
    ls_final-dmbtr = ls_bseg-dmbtr.
    ls_final-wrbtr = ls_bseg-wrbtr.
    ls_final-shkzg = ls_bseg-shkzg.
    ls_final-pswsl = ls_bseg-pswsl.
    ls_final-mwskz = ls_bseg-mwskz.
    ls_final-qsskz = ls_bseg-qsskz.
    ls_final-kostl = ls_bseg-kostl.
    ls_final-prctr = ls_bseg-prctr.
    ls_final-kunnr = ls_bseg-kunnr.
    ls_final-lifnr = ls_bseg-lifnr.
    ls_final-sgtxt = ls_bseg-sgtxt.

    SORT lt_lfa1 BY lifnr.
    READ TABLE lt_lfa1 INTO ls_lfa1 WITH KEY lifnr = ls_final-lifnr BINARY SEARCH.
    IF  sy-subrc = 0.
      ls_final-vname = ls_lfa1-name1.
    ENDIF.

    SORT lt_kna1 BY kunnr.
    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_final-kunnr BINARY SEARCH.
    IF sy-subrc = 0.
      ls_final-name1 = ls_kna1-name1.
    ENDIF.

    SORT lt_bkpf BY belnr bukrs.
    READ TABLE lt_bkpf INTO ls_bkpf WITH KEY belnr = ls_final-belnr
                                             bukrs = ls_bseg-bukrs BINARY SEARCH.
    IF sy-subrc = 0.
      ls_final-bldat = ls_bkpf-bldat.
      ls_final-budat = ls_bkpf-budat.
      ls_final-blart = ls_bkpf-blart.
      ls_final-waers = ls_bkpf-waers.
      ls_final-ppnam = ls_bkpf-ppnam.
      ls_final-usnam = ls_bkpf-usnam.
    ENDIF.

    SORT lt_t003t BY blart.
    READ TABLE lt_t003t INTO ls_t003t WITH KEY blart = ls_final-blart BINARY SEARCH.
    IF sy-subrc = 0.
      ls_final-ltext = ls_t003t-ltext.
    ENDIF.

    SORT lt_skat BY saknr ktopl.
    READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_final-hkont
                                             ktopl = ls_bseg-bukrs BINARY SEARCH.
    IF  sy-subrc = 0.
      ls_final-txt50 = ls_skat-txt50.
    ENDIF.

    SORT lt_ska1 BY saknr ktopl.
    READ TABLE lt_ska1 INTO ls_ska1 WITH KEY saknr = ls_skat-saknr
                                             ktopl = ls_bseg-bukrs BINARY SEARCH.
    IF sy-subrc = 0.
      IF ls_ska1-xbilk = 'X'.
        ls_final-xbilk = 'Balance Sheet A/C'.
      ELSEIF ls_ska1-xbilk = ' '.
        ls_final-xbilk = 'P&L A/C'.
      ENDIF.
    ENDIF.

    APPEND ls_final TO lt_final.
    CLEAR : ls_final,ls_bseg,ls_bkpf,ls_skat,ls_ska1,ls_t003t,ls_kna1,ls_lfa1.

  ENDLOOP.

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

*  PERFORM fcat USING : '1'     'CHK'       'LT_FINAL'  'Document Number'                  '18' .
  PERFORM fcat USING : '1'     'BELNR'       'LT_FINAL'  'Document Number'                  '18' .
  PERFORM fcat USING : '2'     'BLDAT'       'LT_FINAL'  'Document Date'                    '18' .
  PERFORM fcat USING : '3'     'BUDAT'       'LT_FINAL'  'Posting Date'                     '18' .
  PERFORM fcat USING : '4'     'KUNNR'       'LT_FINAL'  'Customer Code'                    '18' .
  PERFORM fcat USING : '5'     'NAME1'       'LT_FINAL'  'Cutomer Name'                     '40' .
  PERFORM fcat USING : '6'     'LIFNR'       'LT_FINAL'  'Vendor Code'                      '18' .
  PERFORM fcat USING : '7'     'VNAME'       'LT_FINAL'  'Vendor Name'                      '40' .
  PERFORM fcat USING : '8'     'SGTXT'       'LT_FINAL'  'Narration'                        '50' .
  PERFORM fcat USING : '9'     'BLART'       'LT_FINAL'  'Document Type'                    '10' .
  PERFORM fcat USING : '10'    'LTEXT'       'LT_FINAL'  'Description of Document Type'     '25' .
  PERFORM fcat USING : '11'    'HKONT'       'LT_FINAL'  'GL Code'                          '18' .
  PERFORM fcat USING : '12'    'TXT50'       'LT_FINAL'  'GL Description'                   '18' .
  PERFORM fcat USING : '13'    'XBILK'       'LT_FINAL'  'GL Type'                          '18' .
  PERFORM fcat USING : '14'    'WRBTR'       'LT_FINAL'  'Amount(Document currency)'        '18' .
  PERFORM fcat USING : '15'    'SHKZG'       'LT_FINAL'  'Indicator'                        '10' .
  PERFORM fcat USING : '16'    'WAERS'       'LT_FINAL'  'Currency'                         '10' .
  PERFORM fcat USING : '17'    'DMBTR'       'LT_FINAL'  'Amount(Local currency)'           '18' .
  PERFORM fcat USING : '18'    'PSWSL'       'LT_FINAL'  'Currency'                         '10' .
  PERFORM fcat USING : '19'    'MWSKZ'       'LT_FINAL'  'Tax Code'                         '10' .
  PERFORM fcat USING : '20'    'QSSKZ'       'LT_FINAL'  'With Holding Tax Code'            '10' .
  PERFORM fcat USING : '21'    'KOSTL'       'LT_FINAL'  'Cost Center'                      '10' .
  PERFORM fcat USING : '22'    'PRCTR'       'LT_FINAL'  'Profit Center'                    '18' .
  PERFORM fcat USING : '23'    'PPNAM'       'LT_FINAL'  'Parked by(entered by)'            '18' .
  PERFORM fcat USING : '24'    'USNAM'       'LT_FINAL'  'Posted by'                        '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0374   text
*      -->P_0375   text
*      -->P_0376   text
*      -->P_0377   text
*      -->P_0378   text
*----------------------------------------------------------------------*
FORM fcat  USING VALUE(p1)
      VALUE(p2)
      VALUE(p3)
      VALUE(p4)
      VALUE(p5).

  ls_fcat-col_pos   = p1.
  ls_fcat-fieldname = p2.
  ls_fcat-tabname   = p3.
  ls_fcat-seltext_l = p4.
  ls_fcat-outputlen = p5.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.
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

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .
  ls_layout-box_fieldname     = 'SEL'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP'
      i_background_id        = 'ALV_BACKGROUND'
      is_layout              = ls_layout
      it_fieldcat            = lt_fcat[]
      i_save                 = 'X'
    TABLES
      t_outtab               = lt_final[]
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM sort_ref.
    PERFORM download_excel.
  ENDIF.

ENDFORM.

FORM top.

  DATA: lt_listheader TYPE TABLE OF slis_listheader,
        ls_listheader TYPE slis_listheader,
        ls_month_name TYPE t7ru9a-regno,
        gs_string     TYPE string,
        gs_month(2)   TYPE n,
        t_line        LIKE ls_listheader-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

  REFRESH lt_listheader.
  CLEAR ls_listheader.

  ls_listheader-typ = 'H'.
  ls_listheader-info = 'JOURNAL ENTRIES REPORT'."GS_STRING.
  APPEND ls_listheader TO lt_listheader.
  CLEAR ls_listheader.

  gs_string = ''.
  CONCATENATE 'REPORT RUN DATE :' sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum+0(4) INTO gs_string SEPARATED BY ''.
  ls_listheader-typ = 'S'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.
  CLEAR ls_listheader.

  gs_string = ''.
  CONCATENATE 'REPORT RUN TIME :' sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2) INTO gs_string SEPARATED BY ''.
  ls_listheader-typ = 'S'.
*  LS_LISTHEADER-KEY = 'REPORT RUN TIME'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.
  CLEAR ls_listheader.

  DESCRIBE TABLE lt_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' ld_linesc
  INTO t_line SEPARATED BY space.

  ls_listheader-typ  = 'A'.
  ls_listheader-info = t_line.
  APPEND ls_listheader TO lt_listheader.
  CLEAR: ls_listheader, t_line.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_listheader
      i_logo             = 'NEW_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SORT_REF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_ref .

  LOOP AT lt_final INTO ls_final.

    ls_ref-belnr = ls_final-belnr.
    ls_ref-hkont = ls_final-hkont.
    ls_ref-dmbtr = ls_final-dmbtr.
    ls_ref-wrbtr = ls_final-wrbtr.
*    ls_ref-umskz = ls_final-umskz.
    ls_ref-shkzg = ls_final-shkzg.
    ls_ref-pswsl = ls_final-pswsl.
    ls_ref-mwskz = ls_final-mwskz.
    ls_ref-qsskz = ls_final-qsskz.
    ls_ref-kostl = ls_final-kostl.
    ls_ref-prctr = ls_final-prctr.
    ls_ref-kunnr = ls_final-kunnr.
    ls_ref-lifnr = ls_final-lifnr.
    ls_ref-sgtxt = ls_final-sgtxt.
    ls_ref-vname = ls_final-vname.
    ls_ref-name1 = ls_final-name1.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-bldat
      IMPORTING
        output = ls_ref-bldat.

    CONCATENATE ls_ref-bldat+0(2) ls_ref-bldat+2(3) ls_ref-bldat+5(4)
    INTO ls_ref-bldat SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-budat
      IMPORTING
        output = ls_ref-budat.

    CONCATENATE ls_ref-budat+0(2) ls_ref-budat+2(3) ls_ref-budat+5(4)
    INTO ls_ref-budat SEPARATED BY '-'.

    ls_ref-blart = ls_final-blart.
    ls_ref-waers = ls_final-waers.
    ls_ref-ppnam = ls_final-ppnam.
    ls_ref-usnam = ls_final-usnam.
    ls_ref-ltext = ls_final-ltext.
    ls_ref-txt50 = ls_final-txt50.
    ls_ref-xbilk = ls_final-xbilk.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_ref-ref_dat.

    CONCATENATE ls_ref-ref_dat+0(2) ls_ref-ref_dat+2(3) ls_ref-ref_dat+5(4)
    INTO ls_ref-ref_dat SEPARATED BY '-'.

    ls_ref-ref_time = sy-uzeit.
    CONCATENATE ls_ref-ref_time+0(2) ':' ls_ref-ref_time+2(2)  INTO ls_ref-ref_time.


    APPEND ls_ref TO lt_ref.
    CLEAR : ls_ref,ls_final.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_excel .

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
  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_ref
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
  lv_file = 'ZJOURNAL_ENTRIES.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZJOURNAL_ENTRIES_REPORT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_669 TYPE string.
DATA lv_crlf_669 TYPE string.
lv_crlf_669 = cl_abap_char_utilities=>cr_lf.
lv_string_669 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_669 lv_crlf_669 wa_csv INTO lv_string_669.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_669 TO lv_fullfile.
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

  CONCATENATE 'Document Number'
              'Document Date'
              'Posting Date'
              'Customer Code'
              'Cutomer Name'
              'Vendor Code'
              'Vendor Name'
              'Narration'
              'Document Type'
              'Description of Document Type'
              'GL Code'
              'GL Description'
              'GL Type'
              'Amount(Document currency)'
              'Indicator'
              'Currency'
              'Amount(Local currency)'
              'Currency'
              'Tax Code'
              'With Holding Tax Code'
              'Cost Center'
              'Profit Center'
              'Parked by(entered by)'
              'Posted by'
              'Refresh Date'
              'Refresh Time'
              INTO p_hd_csv
  SEPARATED BY l_field_seperator.


ENDFORM.
