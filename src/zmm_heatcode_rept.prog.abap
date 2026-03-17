*&---------------------------------------------------------------------*
*& Report ZMM_HEATCODE_REPT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_heatcode_rept.

TABLES : mseg.

TYPE-POOLS : slis.

*Structure for alv layout
DATA : i_layout      TYPE slis_layout_alv.

DATA : it_fieldcat TYPE slis_t_fieldcat_alv,  "Internal table for fieldcatlog
       wa_fieldcat TYPE slis_fieldcat_alv. "Workarea for fieldcatlog

DATA : it_header TYPE slis_t_listheader,
       wa_header TYPE slis_listheader.
DATA : it_events TYPE slis_t_event,       "Internal table for alv events
       wa_event  TYPE slis_alv_event.   "Workarea for alv events
TYPES: BEGIN OF ty_final,
         werks       TYPE mseg-werks,
         lifnr       TYPE mseg-lifnr,
         mblnr       TYPE mblnr,
         budat       TYPE mseg-budat_mkpf,
         ebeln       TYPE mseg-ebeln,
         zeile       TYPE mseg-zeile,
         matnr       TYPE mseg-matnr,
         wempf       TYPE mseg-wempf,
         menge       TYPE mseg-menge,
         meins       TYPE mseg-meins,
         ablad       TYPE mseg-ablad,
         waers       TYPE mseg-waers,
         lgort       TYPE mseg-lgort, "added by jyoti on 24.06.2024
         tdline(132) TYPE c,
         maktx       TYPE makt-maktx,
         sgtxt       TYPE mseg-sgtxt,    """""      Added By KD on 22.04.2017

         ref_dat    TYPE char50,
         ref_time    TYPE char50,
       END OF ty_final.

TYPES : BEGIN OF ty_down,
        werks       TYPE mseg-werks,
         lifnr       TYPE mseg-lifnr,
         mblnr       TYPE mblnr,
         budat       TYPE char50, "mseg-budat_mkpf,
         ebeln       TYPE mseg-ebeln,
         zeile       TYPE char50,"mseg-zeile,
         matnr       TYPE mseg-matnr,
         tdline(132) TYPE c,
         wempf       TYPE char50,"mseg-wempf,
         menge       TYPE char50,"mseg-menge,
         meins       TYPE char50,"mseg-meins,
         ablad       TYPE char50,"mseg-ablad,
         waers       TYPE char50,"mseg-waers,
         sgtxt       TYPE char50,"mseg-sgtxt,
         lgort       TYPE mseg-lgort, "added by jyoti on 24.06.2024
         ref_dat    TYPE char50,
         ref_time    TYPE char50,

       END OF ty_down.

TYPES : BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,
          pstyp TYPE ekpo-pstyp,
        END OF ty_ekpo.

TYPES : BEGIN OF ty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
        END OF ty_makt.

DATA : gt_makt TYPE TABLE OF ty_makt,
       wa_makt TYPE ty_makt.

DATA : gt_ekpo TYPE TABLE OF ty_ekpo,
       wa_ekpo TYPE ty_ekpo.


DATA : gt_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.

DATA : gt_mseg TYPE TABLE OF ty_final,
       wa_mseg TYPE ty_final.

DATA : i_header   TYPE  thead,
       i_language TYPE  thead-tdspras,
       i_name     TYPE  thead-tdname,
       i_id       TYPE  thead-tdid,
       i_object   TYPE  thead-tdobject.

DATA : i_lines  TYPE TABLE OF tline,
       wa_lines TYPE  tline.

""""""      Added By KD on 22.-4.2017   """""""""""
TYPES : BEGIN OF tt_qals,
          prueflos TYPE qals-prueflos,
          werk     TYPE qals-werk,
          mblnr    TYPE qals-mblnr,
          zeile    TYPE qals-zeile,
        END OF tt_qals.

DATA : it_qals TYPE TABLE OF tt_qals,
       wa_qals TYPE tt_qals.

TYPES : BEGIN OF tt_qamb,
          prueflos TYPE qamb-prueflos,
          typ      TYPE qamb-typ,
          mblnr    TYPE qamb-mblnr,
          mjahr    TYPE qamb-mjahr,
          zeile    TYPE qamb-zeile,
        END OF tt_qamb.

DATA : it_qamb TYPE TABLE OF tt_qamb,
       wa_qamb TYPE tt_qamb.

TYPES : BEGIN OF tt_mseg1,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          zeile TYPE mseg-zeile,
          sgtxt TYPE mseg-sgtxt,
        END OF tt_mseg1.

DATA : it_mseg1 TYPE TABLE OF tt_mseg1,
       wa_mseg1 TYPE tt_mseg1.

DATA:
  gt_events     TYPE slis_t_event,
  gd_prntparams TYPE slis_print_alv.

DATA :  lt_down     TYPE TABLE OF ty_down,
       ls_down     TYPE ty_down.

DATA : ls_layout   TYPE slis_layout_alv.


"""""""""""""""""""""""""""""""""""""""""""""""""""
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS : s_werks FOR mseg-werks OBLIGATORY NO INTERVALS NO-EXTENSION, " Date for Selecting Records
                 s_vendor FOR mseg-lifnr,               " Vendor Account Number
                 s_ebeln FOR mseg-ebeln,
                 s_mblnr FOR mseg-mblnr,
                 s_wempf FOR mseg-wempf NO INTERVALS,
                 s_budat FOR mseg-budat_mkpf,"OBLIGATORY.
                 S_lgort for mseg-lgort." added by jyoti on 24.06.2024


SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.

  SELECT werks lifnr mblnr budat_mkpf
        ebeln zeile matnr wempf menge meins ablad waers lgort "lgort added by jyoti on 24.06.2024
    FROM mseg INTO TABLE gt_mseg WHERE werks IN s_werks
     AND   lifnr IN s_vendor
     AND   ebeln IN s_ebeln
     AND   mblnr IN s_mblnr
     AND   wempf IN s_wempf
     AND   budat_mkpf IN s_budat
    and  lgort in s_lgort   "added by jyoti on 24.06.2024
     AND kzbew = 'B'.

  IF gt_mseg[] IS NOT INITIAL.

    SELECT matnr maktx FROM makt INTO TABLE gt_makt
      FOR ALL ENTRIES IN gt_mseg
      WHERE matnr = gt_mseg-matnr.

    """""""""""  Added by KD on 22.04.2017     """""""""""
    SELECT prueflos werk mblnr zeile FROM qals INTO TABLE it_qals
                                        FOR ALL ENTRIES IN gt_mseg
                                             WHERE mblnr = gt_mseg-mblnr
                                               AND zeile = gt_mseg-zeile .

    SELECT prueflos typ mblnr mjahr zeile FROM qamb INTO TABLE it_qamb
                                      FOR ALL ENTRIES IN it_qals
                                           WHERE prueflos = it_qals-prueflos
                                             AND typ      = '3'.

    DELETE ADJACENT DUPLICATES FROM it_qamb COMPARING prueflos typ .

    SELECT mblnr mjahr zeile sgtxt FROM mseg INTO TABLE it_mseg1
                                      FOR ALL ENTRIES IN it_qamb
                                           WHERE mblnr = it_qamb-mblnr
                                             AND mjahr = it_qamb-mjahr
                                             AND zeile = it_qamb-zeile.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDIF.

  SELECT ebeln pstyp FROM ekpo INTO TABLE gt_ekpo FOR ALL ENTRIES IN gt_final
                                                  WHERE ebeln = gt_final-ebeln
                                                  AND   pstyp = '0'.


  LOOP AT gt_mseg INTO wa_mseg.

    i_id = 'GRUN'.
    i_language = sy-langu.
    i_name = wa_mseg-matnr.
    i_object = 'MATERIAL'.


    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = i_id
        language                = i_language
        name                    = i_name
        object                  = i_object
      IMPORTING
        header                  = i_header
      TABLES
        lines                   = i_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    READ TABLE i_lines INTO wa_lines INDEX 1.

    IF sy-subrc  = 0.

      wa_final-tdline = wa_lines-tdline.

    ELSE.

      READ TABLE gt_makt INTO wa_makt WITH KEY matnr = wa_mseg-matnr.

      IF sy-subrc = 0.

        wa_final-tdline = wa_makt-maktx.

      ENDIF.

    ENDIF.

    READ TABLE gt_ekpo INTO wa_ekpo WITH KEY ebeln = wa_mseg-ebeln pstyp = '0'.

    IF sy-subrc = 0.

      wa_final-werks = wa_mseg-werks.
      wa_final-matnr = wa_mseg-matnr.
      wa_final-zeile = wa_mseg-zeile.
      wa_final-meins = wa_mseg-meins.
      wa_final-menge = wa_mseg-menge.
      wa_final-lifnr = wa_mseg-lifnr.
      wa_final-ebeln = wa_mseg-ebeln.
      wa_final-mblnr = wa_mseg-mblnr.
      wa_final-wempf = wa_mseg-wempf.
      wa_final-budat = wa_mseg-budat.
      wa_final-ablad = wa_mseg-ablad.
      wa_final-waers = wa_mseg-waers.
      wa_final-lgort = wa_mseg-lgort."added by jyoti on 24.06.2024

      READ TABLE it_qals INTO wa_qals WITH KEY mblnr = wa_mseg-mblnr zeile = wa_mseg-zeile.
      IF sy-subrc = 0.
        READ TABLE it_qamb INTO wa_qamb WITH KEY prueflos = wa_qals-prueflos typ = '3'.
        IF sy-subrc = 0.
          READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY mblnr = wa_qamb-mblnr mjahr = wa_qamb-mjahr .
          IF sy-subrc = 0.
            wa_final-sgtxt = wa_mseg1-sgtxt .
          ENDIF.
        ENDIF.
      ENDIF.

      APPEND wa_final TO gt_final.

    ENDIF.
  ENDLOOP.

  PERFORM build_field_catalog.
  PERFORM alv_events.
  PERFORM build_print_params.
  PERFORM alv_display.
  PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_field_catalog .

  REFRESH : it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Plant'.
  wa_fieldcat-col_pos   = '1'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'LIFNR'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Vendor'.
  wa_fieldcat-col_pos   = '2'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MBLNR'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Material Doc'.
  wa_fieldcat-col_pos   = '3'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'BUDAT'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'GR Date'.
  wa_fieldcat-col_pos   = '4'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'EBELN'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'PO No.'.
  wa_fieldcat-col_pos   = '5'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ZEILE'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Line item'.
  wa_fieldcat-col_pos   = '6'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Material Code'.
  wa_fieldcat-col_pos   = '7'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'TDLINE'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Material Description'.
  wa_fieldcat-col_pos   = '8'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WEMPF'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Heat Code'.
  wa_fieldcat-col_pos   = '9'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MENGE'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Qty'.
  wa_fieldcat-col_pos   = '10'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MEINS'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'UOM'.
  wa_fieldcat-col_pos   = '11'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ABLAD'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Price/Unit'.
  wa_fieldcat-col_pos   = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WAERS'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Currency'.
  wa_fieldcat-col_pos   = '13'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SGTXT'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'TC Numbar'.
  wa_fieldcat-col_pos   = '13'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.
****************added by jyoti on 24.06.2024********
   wa_fieldcat-fieldname = 'LGORT'.     " Field name should be capital"
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_l = 'Storage Location'.
  wa_fieldcat-col_pos   = '14'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .

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
*     I_CALLBACK_HTML_END_OF_LIST       = 'END_OF_LIST'
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = i_layout
      it_fieldcat            = it_fieldcat[]
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
      i_save                 = 'X'
*     IS_VARIANT             =
      it_events              = it_events
*     IT_EVENT_EXIT          =
      is_print               = gd_prntparams
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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = gt_final[]
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.

FORM display .

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .

  IF p_down = 'X'.
    PERFORM download.
    PERFORM download_excel.
  ENDIF.

ENDFORM.

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

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
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
  lv_file = 'ZHCR.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.

  WRITE: / 'zmm_heatcode_rept Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_532 TYPE string.
DATA lv_crlf_532 TYPE string.
lv_crlf_532 = cl_abap_char_utilities=>cr_lf.
lv_string_532 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_532 lv_crlf_532 wa_csv INTO lv_string_532.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_988 TO lv_fullfile.
TRANSFER lv_string_532 TO lv_fullfile.
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

  CONCATENATE  'Plant'
               'Vendor'
               'Material Doc'
               'GR Date'
               'PO NO'
               'Line Item'
               'Material Code'
               'Material Description'
               'Heat Code'
               'Qty'
               'UOM'
               'Price/Unit'
               'Currency'
               'TC Number'
               'Storage Location'"added by jyoti on 24.06.2024
               'Refreshable Date'
               'Refreshable Time'

    INTO p_hd_csv
    SEPARATED BY l_field_seperator.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .

  REFRESH: it_header.
  CLEAR  : wa_header.

  wa_header-typ = 'H'.
  wa_header-info = 'Heat Code Traceability Report'.
  APPEND wa_header TO it_header.
  CLEAR wa_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_header
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.                    " TOP_OF_PAGE

FORM alv_events .
  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = it_events[]
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  READ TABLE it_events WITH KEY name = slis_ev_top_of_page INTO wa_event.

  IF sy-subrc = 0.

    MOVE 'TOP_OF_PAGE' TO wa_event-form.
    APPEND wa_event TO it_events.

  ENDIF.
  read table it_events with key name =  slis_ev_end_of_page
                           into wa_event.
  if sy-subrc = 0.
    move 'END_OF_PAGE' to wa_event-form.
    append wa_event to it_events.
  endif.

    read table it_events with key name =  slis_ev_end_of_list
                           into wa_event.
  if sy-subrc = 0.
    move 'END_OF_LIST' to wa_event-form.
    append wa_event to it_events.
  endif.

ENDFORM.                    " ALV_EVENTS

*&---------------------------------------------------------------------*
*&      Form  BUILD_PRINT_PARAMS
*&---------------------------------------------------------------------*
*       Setup print parameters
*----------------------------------------------------------------------*
form build_print_params.
  gd_prntparams-reserve_lines = '3'.   "Lines reserved for footer
  gd_prntparams-no_coverpage = 'X'.
endform.                    " BUILD_PRINT_PARAMS
*&---------------------------------------------------------------------*
*&      Form  END_OF_PAGE
*&---------------------------------------------------------------------*
form END_OF_PAGE.
  data: listwidth type i,
        ld_pagepos(10) type c,
        ld_page(10)    type c.

  write: sy-uline(50).
  skip.
  write: /2'F/DFCPL/QA/15/01/15.04.2017'.
endform.


*&---------------------------------------------------------------------*
*&      Form  END_OF_LIST
*&---------------------------------------------------------------------*
form END_OF_LIST.
  data: listwidth type i,
        ld_pagepos(10) type c,
        ld_page(10)    type c.

  skip.
  write: /2 'F/DFCPL/QA/15/01/15.04.2017'.
endform.
FORM download.

  LOOP AT gt_final into wa_final.

  ls_down-werks = wa_final-werks.
  ls_down-lifnr = wa_final-lifnr.
  ls_down-mblnr = wa_final-mblnr.

  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input  = wa_final-budat
    IMPORTING
      output = ls_down-budat.

  CONCATENATE ls_down-budat+0(2) ls_down-budat+2(3) ls_down-budat+5(4)
  INTO ls_down-budat SEPARATED BY '-'.

  ls_down-ebeln = wa_final-ebeln.
  ls_down-zeile = wa_final-zeile.
  ls_down-matnr = wa_final-matnr.
  ls_down-tdline = wa_final-tdline.
  ls_down-wempf = wa_final-wempf.
  ls_down-menge = wa_final-menge.
  ls_down-meins = wa_final-meins.
  ls_down-ablad = wa_final-ablad.
  ls_down-waers = wa_final-waers.
  ls_down-lgort = wa_final-lgort."added by jyoti on 24.06.2024
  ls_down-sgtxt = wa_final-sgtxt.

  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input  = sy-datum
    IMPORTING
      output = ls_down-ref_dat.

  CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
  INTO ls_down-ref_dat SEPARATED BY '-'.

  ls_down-ref_time = sy-uzeit.
  CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.

 REPLACE ALL OCCURRENCES OF '-' IN ls_down-wempf WITH ' '.
 REPLACE ALL OCCURRENCES OF '-' IN ls_down-ablad WITH ' '.

  IF ls_down-ablad IS INITIAL .
     ls_down-ablad = '0'.
  ENDIF.

  APPEND ls_down TO lt_down.
  CLEAR : ls_down,wa_final.

  ENDLOOP.
ENDFORM.
