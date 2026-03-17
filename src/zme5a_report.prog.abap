*&---------------------------------------------------------------------*
*& Report ZME5A_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zme5a_report.
TYPE-POOLS: slis.
TABLES : eban.

TYPES :BEGIN OF ty_eban,
         banfn   TYPE eban-banfn,  "PURCHASING DOCUMENT
         bnfpo   TYPE eban-bnfpo,  "Item number of purchase requisition
         bsart   TYPE eban-bsart,  "Purchase Requisition Document Type
         bstyp   TYPE eban-bstyp,
         loekz   TYPE eban-loekz,  "Deletion indicator
         statu   TYPE eban-statu,  "Processing status
         estkz   TYPE eban-estkz,  "Creation indicator
         ekgrp   TYPE eban-ekgrp,  "Purchasing Group
         ernam   TYPE eban-ernam,  "Created By
         txz01   TYPE eban-txz01,  "Short Text
         matnr   TYPE eban-matnr,  "Material
         werks   TYPE eban-werks,  "Plant
         matkl   TYPE eban-matkl,  "Material Group
         menge   TYPE eban-menge,  "Quantity Requested
         meins   TYPE eban-meins,  "UOM
         badat   TYPE eban-badat,
         lfdat   TYPE eban-lfdat,  "Delievry Date
         frgdt   TYPE eban-frgdt,  "Release Date
         preis   TYPE eban-preis,  "Valuation Type
         pstyp   TYPE eban-pstyp,  "Item category
         knttp   TYPE eban-knttp,  "Account Assignment Category
         wepos   TYPE eban-wepos,  "Goods Receipt
         weunb   TYPE eban-weunb,  "GR Non-valuated
         repos   TYPE eban-repos,  "Invoice receipt
         flief   TYPE eban-flief,
         infnr   TYPE eban-infnr,
         dispo   TYPE eban-dispo,  "MRP Controller
         ebeln   TYPE eban-ebeln,  "Purchase order number
         ebelp   TYPE eban-ebelp,  "Purchase order item number
         bedat   TYPE eban-bedat,  "Purchase Order Date
         bsmng   TYPE eban-bsmng,
         ebakz   TYPE eban-ebakz,
         fixkz   TYPE eban-fixkz,  "Purchase requisition is fixed
         plifz   TYPE eban-plifz,
         waers   TYPE eban-waers,
         tot_val TYPE string,

       END OF ty_eban.

TYPES :BEGIN OF ty_down,
         estkz   TYPE eban-estkz,  "Creation indicator
         ekgrp   TYPE eban-ekgrp,  "Purchasing Group
         werks   TYPE eban-werks,  "Plant
         banfn   TYPE eban-banfn,  "PURCHASING DOCUMENT
         bnfpo   TYPE eban-bnfpo,  "Item number of purchase requisition
         badat   TYPE char18,
         pstyp   TYPE eban-pstyp,  "Item category
         matnr   TYPE eban-matnr,  "Material
         txz01   TYPE eban-txz01,  "Short Text
         bsart   TYPE eban-bsart,  "Purchase Requisition Document Type
         menge   TYPE string,      "Quantity Requested
         bsmng   TYPE string,
         meins   TYPE eban-meins,  "UOM
         lfdat   TYPE char18,  "Delievry Date
         loekz   TYPE eban-loekz,  "Deletion indicator
         dispo   TYPE eban-dispo,  "MRP Controller
         matkl   TYPE eban-matkl,  "Material Group
         preis   TYPE string,  "Valuation Type
         tot_val TYPE string,
         plifz   TYPE eban-plifz,
         fixkz   TYPE eban-fixkz,  "Purchase requisition is fixed
         knttp   TYPE eban-knttp,  "Account Assignment Category
         ernam   TYPE eban-ernam,  "Created By
         waers   TYPE string,
*         lfdat1  TYPE char18,  "Delievry Date
         flief   TYPE eban-flief,
         wepos   TYPE eban-wepos,  "Goods Receipt
         weunb   TYPE eban-weunb,  "GR Non-valuated
         repos   TYPE eban-repos,  "Invoice receipt
         ebeln   TYPE eban-ebeln,  "Purchase order number
         bedat   TYPE char18,  "Purchase Order Date
         ebelp   TYPE eban-ebelp,  "Purchase order item number
         statu   TYPE eban-statu,  "Processing status
         infnr   TYPE eban-infnr,
*         bstyp   TYPE eban-bstyp,
*         frgdt   TYPE char18,  "Release Date
*         ebakz   TYPE eban-ebakz,
         ref     TYPE char15,
         ref_time TYPE char8,
       END OF ty_down.

DATA : lt_eban   TYPE STANDARD TABLE OF ty_eban,
       ls_eban   TYPE          ty_eban,

       lt_final  TYPE STANDARD TABLE OF ty_eban,
       ls_final  TYPE                   ty_eban,

       lt_down   TYPE STANDARD TABLE OF ty_down,
       ls_down   TYPE                   ty_down,

       ls_layout TYPE slis_layout_alv,

       gv_quant  TYPE eban-menge.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_pdoc FOR eban-banfn.
PARAMETERS     : p_plant TYPE eban-werks OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT   '/Delval/India'."India'."India'."temp'.        "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM get_fcat.
*end-of-SELECTION.
*  PERFORM get_display.


*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT banfn
  bnfpo
  bsart
  bstyp
  loekz
  statu
  estkz
  ekgrp
  ernam
  txz01
  matnr
  werks
  matkl
  menge
  meins
  badat
  lfdat
  frgdt
  preis
  pstyp
  knttp
  wepos
  weunb
  repos
  flief
  infnr
  dispo
  ebeln
  ebelp
  bedat
  bsmng
  ebakz
  fixkz
  plifz
  waers
  FROM eban
  INTO TABLE lt_eban
  WHERE werks = p_plant AND
  banfn IN s_pdoc.

  LOOP AT lt_eban INTO ls_eban.

    gv_quant = ls_eban-menge - ls_eban-bsmng.

    IF ls_eban-loekz = ' ' AND ls_eban-ebakz = ' ' ."AND gv_quant <> '0'.
      IF gv_quant <> '0'.
        IF sy-subrc = 0.
          ls_final-banfn = ls_eban-banfn.
          ls_final-bnfpo = ls_eban-bnfpo.
          ls_final-bsart = ls_eban-bsart.
          ls_final-bstyp = ls_eban-bstyp.
          ls_final-loekz = ls_eban-loekz.
          ls_final-statu = ls_eban-statu.
          ls_final-estkz = ls_eban-estkz.
          ls_final-ekgrp = ls_eban-ekgrp.
          ls_final-ernam = ls_eban-ernam.
          ls_final-txz01 = ls_eban-txz01.
          ls_final-matnr = ls_eban-matnr.
          ls_final-werks = ls_eban-werks.
          ls_final-matkl = ls_eban-matkl.
          ls_final-menge = ls_eban-menge.
          ls_final-meins = ls_eban-meins.
          ls_final-badat = ls_eban-badat.
          ls_final-lfdat = ls_eban-lfdat.
          ls_final-frgdt = ls_eban-frgdt.
          ls_final-preis = ls_eban-preis.
*      ls_final-pstyp = ls_eban-pstyp.
          IF ls_eban-pstyp = '0'.
            ls_final-pstyp = ' '.
          ELSEIF ls_eban-pstyp = '3'.
            ls_final-pstyp = 'L'.
          ELSEIF ls_eban-pstyp = '7'.
            ls_final-pstyp = 'U'.
          ELSEIF ls_eban-pstyp = '9'.
            ls_final-pstyp = 'D'.
          ENDIF.
          ls_final-knttp = ls_eban-knttp.
          ls_final-wepos = ls_eban-wepos.
          ls_final-weunb = ls_eban-weunb.
          ls_final-repos = ls_eban-repos.
          ls_final-flief = ls_eban-flief.
          ls_final-infnr = ls_eban-infnr.
          ls_final-dispo = ls_eban-dispo.
          ls_final-ebeln = ls_eban-ebeln.
          ls_final-ebelp = ls_eban-ebelp.
          ls_final-bedat = ls_eban-bedat.
          ls_final-bsmng = ls_eban-bsmng.
*      ls_final-ebakz = ls_eban-ebakz.
          ls_final-fixkz = ls_eban-fixkz.
          ls_final-plifz = ls_eban-plifz.
          ls_final-waers = ls_eban-waers.

          ls_final-tot_val = ls_final-preis * ls_final-menge.


          ls_down-banfn = ls_final-banfn.
          ls_down-bnfpo = ls_final-bnfpo.
          ls_down-bsart = ls_final-bsart.
*      ls_down-bstyp = ls_final-bstyp.
          ls_down-loekz = ls_final-loekz.
          ls_down-statu = ls_final-statu.
          ls_down-estkz = ls_final-estkz.
          ls_down-ekgrp = ls_final-ekgrp.
          ls_down-ernam = ls_final-ernam.
          ls_down-txz01 = ls_final-txz01.
          ls_down-matnr = ls_final-matnr.
          ls_down-werks = ls_final-werks.
          ls_down-matkl = ls_final-matkl.
          ls_down-menge = ls_final-menge.
          ls_down-meins = ls_final-meins.

          IF ls_final-badat IS NOT INITIAL.

          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              input  = ls_final-badat
            IMPORTING
              output = ls_down-badat.

          CONCATENATE ls_down-badat+0(2) ls_down-badat+2(3) ls_down-badat+5(4)
          INTO ls_down-badat SEPARATED BY '-'.

          ENDIF.

          IF ls_final-lfdat IS NOT INITIAL.

          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              input  = ls_final-lfdat
            IMPORTING
              output = ls_down-lfdat.

          CONCATENATE ls_down-lfdat+0(2) ls_down-lfdat+2(3) ls_down-lfdat+5(4)
          INTO ls_down-lfdat SEPARATED BY '-'.

          ENDIF.

          ls_down-bsmng = ls_final-bsmng.

*      ls_down-ebakz = ls_final-ebakz.
          ls_down-fixkz = ls_final-fixkz.
          ls_down-plifz = ls_final-plifz.
          ls_down-waers = ls_final-waers.

          ls_down-pstyp = ls_final-pstyp.

          ls_down-tot_val = ls_final-tot_val.

          ls_down-dispo = ls_final-dispo.

          ls_down-preis = ls_final-preis.

          ls_down-knttp = ls_final-knttp.

          ls_down-flief = ls_final-flief.

          ls_down-wepos = ls_final-wepos.
          ls_down-weunb = ls_final-weunb.
          ls_down-repos = ls_final-repos.
          ls_down-infnr = ls_final-infnr.
          ls_down-ebelp = ls_final-ebelp.
*          ls_down-bedat = ls_final-bedat.
          ls_down-ebeln = ls_final-ebeln.
*      ls_final_final-REF = sy-datum.
          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              input  = sy-datum
            IMPORTING
              output = ls_down-ref.

          CONCATENATE ls_down-ref+0(2) ls_down-ref+2(3) ls_down-ref+5(4)
                    INTO ls_down-ref SEPARATED BY '-'.

          IF ls_final-bedat IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              input  = ls_final-bedat
            IMPORTING
              output = ls_down-bedat.

          CONCATENATE ls_down-bedat+0(2) ls_down-bedat+2(3) ls_down-bedat+5(4)
          INTO ls_down-bedat SEPARATED BY '-'.
          ENDIF.
*break primus.
          ls_down-ref_time = sy-uzeit.

          concatenate ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  into ls_down-ref_time.
          CONDENSE ls_down-ref_time NO-GAPS .

          APPEND ls_final TO lt_final.
          APPEND ls_down TO lt_down.
          CLEAR : ls_final, ls_down.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM get_display .
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM download .
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .


  PERFORM fcat USING : '1'   'ESTKZ'   'LT_FINAL'  'Creation Indicator'           '18' ,
                       '2'   'EKGRP'   'LT_FINAL'  'Purchasing Group'             '18' ,
                       '3'   'WERKS'   'LT_FINAL'  'Plant'                         '4' ,
                       '4'   'BANFN'   'LT_FINAL'  'Purchase Requisition'           '18' ,
                       '5'   'BNFPO'  'LT_FINAL'  'Item Of Requisition'           '18' ,
                       '6'   'BADAT'   'LT_FINAL'  'Requisition Date'               '18' ,
                       '7'   'PSTYP'   'LT_FINAL'  'Item Category'                    '18' ,
                       '8'   'MATNR'   'LT_FINAL'  'Material'                     '18' ,
                       '9'   'TXZ01'   'LT_FINAL'  'Short Text'                    '18' ,
                       '10'  'BSART'   'LT_FINAL'  'Document Type'                   '18' ,
                       '11'  'MENGE'   'LT_FINAL'  'Quantity Requested'                    '18' ,
                       '12'  'BSMNG'   'LT_FINAL'  'Quantity Ordered'                 '18' ,
                       '13'  'MEINS'   'LT_FINAL'  'Unit Of Measure'                   '18' ,
                       '14'  'LFDAT'   'LT_FINAL'  'Delivery Date'                     '18' ,
                       '15'  'LOEKZ'   'LT_FINAL'  'Deletion Indicator'                  '18' ,
                       '16'  'DISPO'   'LT_FINAL'  'MRP Controller'                   '18' ,
                       '17'  'MATKL'   'LT_FINAL'  'Material Group'                 '18' ,
                       '18'  'PREIS'   'LT_FINAL'  'Valuation Price'                   '18' ,
                       '19'  'TOT_VAL' 'LT_FINAL'  'Total Value'                   '18' ,
                       '20'  'PLIFZ'   'LT_FINAL'  'Planned Delivery Time'          '18' ,
                       '21'  'FIXKZ'   'LT_FINAL'  'Fixed Indicator'               '18' ,
                       '22'  'KNTTP'   'LT_FINAL'  'Account Assignment Cat.'          '18' ,
                       '23'  'ERNAM'   'LT_FINAL'  'Created By'                         '18' ,
                       '24'  'WAERS'   'LT_FINAL'  'Currency'                          '18' ,
*                       '25'  'LFDAT'   'LT_FINAL'  'Delivery Date'                       '18' ,
                       '26'  'FLIEF'   'LT_FINAL'  'Fixed Vendor'                       '18' ,
                       '27'  'WEPOS'   'LT_FINAL'  'Goods Receipt'                                 '18' ,
                       '28'  'WEUNB'   'LT_FINAL'  'GR non-valuated'                         '18' ,
                       '29'  'REPOS'   'LT_FINAL'  'Invoice Receipt'                       '18' ,
                       '30'  'EBELN'   'LT_FINAL'  'Purchase Order'                         '18' ,
                       '31'  'BEDAT'   'LT_FINAL'  'Purchase Order Date'                        '18' ,
                       '32'  'EBELP'   'LT_FINAL'  'Purchase Order Item'                               '18' ,
                       '33'  'STATU'   'LT_FINAL'  'Purchase Requisition Processing Sate'          '18' ,
*                       '34'  'STATU'   'LT_FINAL'  'Purchase Requisition Processing Sate'          '18' ,
                       '35'  'INFNR'   'LT_FINAL'  'Purchasing Info rec.'                        '18' .


  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .
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
      is_layout          = ls_layout
      it_fieldcat        = it_fcat[]
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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = lt_final[]
* EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
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
*      -->P_0444   text
*      -->P_0445   text
*      -->P_0446   text
*      -->P_0447   text
*      -->P_0448   text
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
  BREAK primus.
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
  lv_file = 'ZME5A.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZME5A Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_550 TYPE string.
DATA lv_crlf_550 TYPE string.
lv_crlf_550 = cl_abap_char_utilities=>cr_lf.
lv_string_550 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_550 lv_crlf_550 wa_csv INTO lv_string_550.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_550 TO lv_fullfile.
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
  CONCATENATE 'Creation Indicator'
              'Purchasing Group'
              'Plant'
              'Purchase Requisition'
              'Item Of Requisition'
              'Requisition Date'
              'Item Category'
              'Material'
              'Short Text'
              'Document Type'
              'Quantity Requested'
              'Quantity Ordered'
              'Unit Of Measure'
              'Delivery Date'
              'Deletion Indicator'
              'MRP Controller'
              'Material Group'
              'Valuation Price'
              'Total Value'
              'Planned Delivery Time'
              'Fixed Indicator'
              'Account Assignment Cat.'
              'Created By'
              'Currency'
*              'Delivery Date'
              'Fixed Vendor'
              'Goods Receipt'
              'GR non-valuated'
              'Invoice Receipt'
              'Purchase Order'
              'Purchase Order Date'
              'Purchase Order Item'
              'Purchase Requisition Processing Sate'
              'Purchasing Info rec.'
              'Refresh Date'
              'Refresh Time'
  INTO p_hd_csv
  SEPARATED BY l_field_seperator.



ENDFORM.
