*&---------------------------------------------------------------------*
*& Report ZSO_DELIVERY_ANALYSIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zso_delivery_analysis.

TABLES:vbak.

TYPES:BEGIN OF ty_vbak,
        vbeln TYPE vbak-vbeln,
        erdat TYPE vbak-erdat,
        auart TYPE vbak-auart,
        vkorg TYPE vbak-vkorg,
        knumv TYPE vbak-knumv,
        kunnr TYPE vbak-kunnr,
      END OF ty_vbak,

      BEGIN OF ty_vbap,
        vbeln   TYPE vbak-vbeln,
        posnr   TYPE vbap-posnr,
        matnr   TYPE vbap-matnr,
        kwmeng  TYPE vbap-kwmeng,
        deldate TYPE vbap-deldate,
      END OF ty_vbap,

      BEGIN OF ty_vbep,
        vbeln TYPE vbep-vbeln,
        posnr TYPE vbep-posnr,
        etenr TYPE vbep-etenr,
        edatu TYPE vbep-edatu,
      END OF ty_vbep,


      BEGIN OF ty_afpo,
        aufnr TYPE afpo-aufnr,
        posnr TYPE afpo-posnr,
        kdauf TYPE afpo-kdauf,
        kdpos TYPE afpo-kdpos,
        psmng TYPE afpo-psmng,
      END OF ty_afpo,

      BEGIN OF ty_aufm,
        mblnr TYPE aufm-mblnr,
        mjahr TYPE aufm-mjahr,
        zeile TYPE aufm-zeile,
        budat TYPE aufm-budat,
        bwart TYPE aufm-bwart,
        lgort TYPE aufm-lgort,
        kdauf TYPE aufm-kdauf,
        kdpos TYPE aufm-kdpos,
        menge TYPE aufm-menge,
      END OF ty_aufm,

      BEGIN OF ty_final,
        vbeln   TYPE vbak-vbeln,
        auart   TYPE vbak-auart,
        vkorg   TYPE vbak-vkorg,
        knumv   TYPE vbak-knumv,
        kunnr   TYPE vbak-kunnr,
        posnr   TYPE vbap-posnr,
        matnr   TYPE vbap-matnr,
        kwmeng  TYPE vbap-kwmeng,
        deldate TYPE vbap-deldate,
        aufnr   TYPE afpo-aufnr,
        psmng   TYPE afpo-psmng,
        budat   TYPE aufm-budat,
        bwart   TYPE aufm-bwart,
        lgort   TYPE aufm-lgort,
        menge   TYPE aufm-menge,
        mblnr   TYPE aufm-mblnr,
        maktx   TYPE makt-maktx,
        edatu   TYPE vbep-edatu,
        mrp_dt  TYPE aufm-budat,
      END OF ty_final.


"" added by pankaj on 08.11.2021"""""

TYPES : BEGIN OF ty_down,
          vbeln    TYPE vbak-vbeln,
          posnr    TYPE vbap-posnr,
          matnr    TYPE vbap-matnr,
          maktx    TYPE makt-maktx,
          kwmeng   TYPE vbap-kwmeng,
          aufnr    TYPE afpo-aufnr,
          edatu    TYPE char11,                 "vbep-edatu,
          psmng    TYPE afpo-psmng,
          deldate  TYPE char11,                 "vbap-deldate,
          budat    TYPE char11,                 "aufm-budat,
          mrp_dt   TYPE char11,                 "aufm-budat,
          mblnr    TYPE aufm-mblnr,
          lgort    TYPE aufm-lgort,
          menge    TYPE aufm-menge,
          ref_dat  TYPE char15,                         "Refresh Date
          ref_time TYPE char15,                         "Refresh Time
        END OF ty_down.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

DATA: it_vbak  TYPE TABLE OF ty_vbak,
      wa_vbak  TYPE          ty_vbak,

      it_vbap  TYPE TABLE OF ty_vbap,
      wa_vbap  TYPE          ty_vbap,

      it_vbep  TYPE TABLE OF ty_vbep,
      wa_vbep  TYPE          ty_vbep,

      it_cdpos TYPE TABLE OF cdpos,
      wa_cdpos TYPE          cdpos,

      wa_cdhdr TYPE cdhdr,

      it_afpo  TYPE TABLE OF ty_afpo,
      wa_afpo  TYPE          ty_afpo,

      it_aufm  TYPE TABLE OF ty_aufm,
      wa_aufm  TYPE          ty_aufm,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_vbeln FOR vbak-vbeln.
PARAMETERS     : p_vkorg TYPE vbak-vkorg OBLIGATORY DEFAULT '1000'.
SELECTION-SCREEN:END OF BLOCK b1.


""" added by pankaj 08.11.2021

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

"""""""""""""""""""""""""""""""""""""
****************************added by jyoti on 29.07.2024*******************
INITIALIZATION.
MESSAGE 'This Tcode is discontinued. Kindly use ZDEL_PERFORM_1 Tcode' TYPE 'E'.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM sort_data.
  PERFORM get_fcat.
  PERFORM get_display.
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
         erdat
         auart
         vkorg
         knumv
         kunnr FROM vbak INTO TABLE it_vbak
         WHERE vbeln IN s_vbeln
           AND vkorg = p_vkorg.

  IF it_vbak IS NOT INITIAL.
    SELECT vbeln
           posnr
           matnr
           kwmeng
           deldate FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbak
           WHERE vbeln = it_vbak-vbeln.



  ENDIF.

  IF it_vbap IS NOT INITIAL.

    SELECT vbeln
           posnr
           etenr
           edatu FROM vbep INTO TABLE it_vbep
           FOR ALL ENTRIES IN it_vbap
           WHERE vbeln = it_vbap-vbeln
             AND posnr = it_vbap-posnr
             AND etenr = '0001'.




    SELECT aufnr
           posnr
           kdauf
           kdpos
           psmng FROM afpo INTO TABLE it_afpo
           FOR ALL ENTRIES IN it_vbap
           WHERE kdauf = it_vbap-vbeln
             AND kdpos = it_vbap-posnr.


    SELECT mblnr
           mjahr
           zeile
           budat
           bwart
           lgort
           kdauf
           kdpos
           menge FROM aufm INTO TABLE it_aufm
           FOR ALL ENTRIES IN it_vbap
           WHERE kdauf = it_vbap-vbeln
             AND kdpos = it_vbap-posnr
             AND bwart = '101'
             AND lgort = 'TPI1'.

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
  LOOP AT it_aufm INTO wa_aufm.
    wa_final-budat  = wa_aufm-budat.
    wa_final-bwart  = wa_aufm-bwart.
    wa_final-lgort  = wa_aufm-lgort.
    wa_final-menge  = wa_aufm-menge.
    wa_final-mblnr  = wa_aufm-mblnr.


    READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_aufm-kdauf posnr = wa_aufm-kdpos.
    IF sy-subrc = 0.
      wa_final-vbeln = wa_vbap-vbeln.
      wa_final-posnr = wa_vbap-posnr.
      wa_final-matnr = wa_vbap-matnr.
      wa_final-kwmeng = wa_vbap-kwmeng.
      wa_final-deldate = wa_vbap-deldate.
    ENDIF.

    READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_final-vbeln posnr = wa_final-posnr.
    IF sy-subrc = 0.
      wa_final-edatu = wa_vbep-edatu.
    ENDIF.
    CLEAR wa_cdpos.
    DATA tabkey TYPE cdpos-tabkey.
    CONCATENATE sy-mandt wa_vbep-vbeln wa_vbep-posnr wa_vbep-etenr INTO tabkey.
    SELECT * FROM cdpos INTO TABLE it_cdpos WHERE tabkey = tabkey
                                             AND tabname = 'VBEP'
                                             AND fname = 'ETTYP'.

    SORT it_cdpos BY changenr DESCENDING.

    READ TABLE it_cdpos INTO wa_cdpos INDEX 1.
    IF wa_cdpos-value_new = 'CP' .
      SELECT SINGLE * FROM cdhdr INTO wa_cdhdr WHERE changenr = wa_cdpos-changenr.
      wa_final-mrp_dt      = wa_cdhdr-udate.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar
    ENDIF.
    CLEAR wa_cdhdr.



    READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_final-vbeln.
    IF sy-subrc = 0.

    ENDIF.

    IF wa_final-mrp_dt IS INITIAL.
      wa_final-mrp_dt = wa_vbak-erdat.
    ENDIF.
    SELECT SINGLE maktx INTO wa_final-maktx FROM makt WHERE matnr = wa_final-matnr.


    READ TABLE it_afpo INTO wa_afpo WITH KEY kdauf = wa_final-vbeln kdpos = wa_final-posnr.
    IF sy-subrc = 0.
      wa_final-aufnr  = wa_afpo-aufnr.
      wa_final-psmng  = wa_afpo-psmng.
    ENDIF.


    APPEND wa_final TO it_final.
    CLEAR wa_final.
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
  PERFORM fcat USING : '1'   'VBELN'           'IT_FINAL'      'Sale Order No'                 '20' ,
                       '2'   'POSNR'           'IT_FINAL'      'SO Line Item'        '20' ,
                       '3'   'MATNR'           'IT_FINAL'      'Material Number'        '20' ,
                       '4'   'MAKTX'           'IT_FINAL'      'Material Description'        '20' ,
                       '5'   'KWMENG'          'IT_FINAL'      'SO Quantity'              '15' ,
                       '6'   'AUFNR'           'IT_FINAL'      'Production Order'              '15' ,
                       '7'   'EDATU'           'IT_FINAL'      'Production Date'              '15' ,
                       '8'   'PSMNG'           'IT_FINAL'      'Production Quantity'              '15' ,
                       '9'   'DELDATE'         'IT_FINAL'      'OA Delivery date'              '15' ,
                      '10'   'BUDAT'           'IT_FINAL'      'FG Credit date @TPI Store'              '15' ,
                      '11'   'MRP_DT'          'IT_FINAL'      'MRP Date'                       '15' ,
                      '12'   'MBLNR'           'IT_FINAL'      'Material Document'              '15' ,
                      '13'   'LGORT'           'IT_FINAL'      'Storage Location'              '15' ,
                      '14'   'MENGE'           'IT_FINAL'      'Quantity'              '15' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .
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
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0499   text
*      -->P_0500   text
*      -->P_0501   text
*      -->P_0502   text
*      -->P_0503   text
*----------------------------------------------------------------------*
FORM fcat   USING    VALUE(p1)
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
FORM download .

  LOOP AT it_final INTO wa_final.

    ls_down-vbeln     = wa_final-vbeln.
    ls_down-posnr     = wa_final-posnr.
    ls_down-matnr     =  wa_final-matnr.
    ls_down-maktx     =  wa_final-maktx.
    ls_down-kwmeng     =  wa_final-kwmeng.
    ls_down-aufnr     =  wa_final-aufnr.

    IF wa_final-edatu IS NOT INITIAL .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-edatu
        IMPORTING
          output = ls_down-edatu.
      CONCATENATE ls_down-edatu+0(2) ls_down-edatu+2(3) ls_down-edatu+5(4)
     INTO ls_down-edatu SEPARATED BY '-'.

    ENDIF.


*    ls_down-edatu     =  wa_final-edatu.           "production Date
    ls_down-psmng     =  wa_final-psmng.

    IF wa_final-deldate IS  NOT INITIAL .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-edatu
        IMPORTING
          output = ls_down-deldate.
      CONCATENATE ls_down-deldate+0(2) ls_down-deldate+2(3) ls_down-deldate+5(4)
     INTO ls_down-deldate SEPARATED BY '-'.

    ENDIF.

*    ls_down-deldate     =  wa_final-deldate.       "OA Delivery date

IF wa_final-budat IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-budat
        IMPORTING
          output = ls_down-budat.
      CONCATENATE ls_down-budat+0(2) ls_down-budat+2(3) ls_down-budat+5(4)
     INTO ls_down-budat SEPARATED BY '-'.

ENDIF.
*    ls_down-budat     =  wa_final-budat.          "FG Credit date @TPI Store

IF wa_final-mrp_dt IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-mrp_dt
        IMPORTING
          output = ls_down-mrp_dt.
      CONCATENATE ls_down-mrp_dt+0(2) ls_down-mrp_dt+2(3) ls_down-mrp_dt+5(4)
     INTO ls_down-mrp_dt SEPARATED BY '-'.

ENDIF.


*    ls_down-mrp_dt     =  wa_final-mrp_dt.        "MRP Date
    ls_down-mblnr     =  wa_final-mblnr.
    ls_down-lgort     =  wa_final-lgort.
    ls_down-menge     =  wa_final-menge.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref_dat.
    CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
   INTO ls_down-ref_dat SEPARATED BY '-'.

    ls_down-ref_time = sy-uzeit.
    CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.


    APPEND ls_down TO lt_down.
    CLEAR: ls_down.     "wa_final.

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
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
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
  lv_file = 'ZDEL_PERFORM.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZDEL_PERFORM Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_565 TYPE string.
DATA lv_crlf_565 TYPE string.
lv_crlf_565 = cl_abap_char_utilities=>cr_lf.
lv_string_565 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_565 lv_crlf_565 wa_csv INTO lv_string_565.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
TRANSFER lv_string_565 TO lv_fullfile.
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

  CONCATENATE        'Sale Order No'
                     'SO Line Item'
                     'Material Number'
                     'Material Description'
                     'SO Quantity'
                     'Production Order'
                     'Production Date'
                     'Production Quantity'
                     'OA Delivery date'
                     'FG Credit date @TPI Store'
                     'MRP Date'
                     'Material Document'
                     'Storage Location'
                     'Quantity'
                     'Refresh date'
                    'Refresh time'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
