*&---------------------------------------------------------------------*
*& Report ZUS_CONSIGNMENT_STOCK_DET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_CONSIGNMENT_STOCK_DET.

TABLES:msku.

TYPES: BEGIN OF ty_msku,
       MATNR TYPE msku-matnr,
       WERKS TYPE msku-WERKS,
       CHARG TYPE msku-CHARG,
       SOBKZ TYPE msku-SOBKZ,
       KUNNR TYPE msku-KUNNR,
       LFGJA TYPE msku-LFGJA,
       KULAB TYPE msku-KULAB,
       END OF ty_msku,

       BEGIN OF ty_mbew,
       MATNR TYPE MBEW-MATNR,
       BWKEY TYPE MBEW-BWKEY,
       BWTAR TYPE MBEW-BWTAR,
       LBKUM TYPE MBEW-LBKUM,
       SALK3 TYPE MBEW-SALK3,
       VPRSV TYPE MBEW-VPRSV,
       VERPR TYPE MBEW-VERPR,
       STPRS TYPE MBEW-STPRS,
       END OF ty_mbew,

       BEGIN OF ty_mara,
       MATNR    TYPE MARA-MATNR,
       ERSDA    TYPE MARA-ERSDA,
       MTART    TYPE MARA-MTART,
       MATKL    TYPE MARA-MATKL,
       WRKST    TYPE MARA-WRKST,
       ZSERIES  TYPE MARA-ZSERIES,
       ZSIZE    TYPE MARA-ZSIZE  ,
       BRAND    TYPE MARA-BRAND  ,
       MOC      TYPE MARA-MOC    ,
       TYPE     TYPE MARA-TYPE   ,
       END OF ty_mara,

       BEGIN OF ty_final,
       ZSERIES  TYPE MARA-ZSERIES,
       ZSIZE    TYPE MARA-ZSIZE  ,
       KUNNR    TYPE msku-KUNNR,
       NAME1    TYPE KNA1-NAME1,
       MATNR    TYPE MARA-MATNR,
       MAKTX    TYPE MAKT-MAKTX,
       WRKST    TYPE MARA-WRKST,
       RATE     TYPE MBEW-VERPR,
       KULAB    TYPE MSKU-KULAB,
       CONS_VAL TYPE MBEW-VERPR,
       BRAND    TYPE MARA-BRAND  ,
       MOC      TYPE MARA-MOC    ,
       TYPE     TYPE MARA-TYPE   ,
       WERKS    TYPE MSKU-WERKS   ,
       END OF ty_final,

       BEGIN OF ty_down,
       ZSERIES  TYPE MARA-ZSERIES,
       ZSIZE    TYPE MARA-ZSIZE  ,
       KUNNR    TYPE msku-KUNNR,
       NAME1    TYPE KNA1-NAME1,
       MATNR    TYPE MARA-MATNR,
       MAKTX    TYPE MAKT-MAKTX,
       WRKST    TYPE MARA-WRKST,
       RATE     TYPE char250,"MBEW-VERPR,
       KULAB    TYPE char250,"MSKU-KULAB,
       CONS_VAL TYPE char250,"MBEW-VERPR,
       BRAND    TYPE MARA-BRAND  ,
       MOC      TYPE MARA-MOC    ,
       TYPE     TYPE MARA-TYPE   ,
       WERKS    TYPE MSKU-WERKS   ,
       ref      TYPE char15,
       ref_time TYPE char15,          """Added by Pranit 05.11.2024
       END OF ty_down.

DATA : it_msku TYPE TABLE OF ty_msku,
       wa_msku TYPE          ty_msku,

       it_mbew TYPE TABLE OF ty_mbew,
       wa_mbew TYPE          ty_mbew,

       it_mara TYPE TABLE OF ty_mara,
       wa_mara TYPE          ty_mara,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.



DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
  SELECT-OPTIONS : S_MATNR FOR MSKU-MATNR,
                   S_KUNNR FOR MSKU-KUNNR,
                   S_WERKS FOR MSKU-WERKS OBLIGATORY DEFAULT 'US01'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/India'."USA'."USA'."USA'."usa'.      "'/Delval/USA'."usa'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

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
SELECT MATNR
       WERKS
       CHARG
       SOBKZ
       KUNNR
       LFGJA
       KULAB FROM msku INTO TABLE it_msku
       WHERE matnr IN s_matnr
         AND kunnr IN s_kunnr
         AND werks IN s_werks.

IF it_msku IS NOT INITIAL.
 SELECT MATNR
        BWKEY
        BWTAR
        LBKUM
        SALK3
        VPRSV
        VERPR
        STPRS FROM mbew INTO TABLE it_mbew
        FOR ALL ENTRIES IN it_msku
        WHERE matnr = it_msku-matnr
          AND bwkey = it_msku-werks.

SELECT MATNR
       ERSDA
       MTART
       MATKL
       WRKST
       ZSERIES
       ZSIZE
       BRAND
       MOC
       TYPE FROM mara INTO TABLE it_mara
       FOR ALL ENTRIES IN it_msku
       WHERE matnr = it_msku-matnr.


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

DATA : con_rate TYPE p DECIMALS 8.
LOOP AT it_msku INTO wa_msku.
  wa_final-kunnr = wa_msku-kunnr.
  wa_final-matnr = wa_msku-matnr.
  wa_final-kulab = wa_msku-kulab.
  wa_final-WERKS = wa_msku-WERKS.

SELECT SINGLE maktx INTO wa_final-maktx FROM makt WHERE matnr = wa_msku-matnr.
SELECT SINGLE name1 INTO wa_final-name1 FROM kna1 WHERE kunnr = wa_msku-kunnr.

 READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_msku-matnr.
  IF sy-subrc = 0.
    wa_final-wrkst   = wa_mara-wrkst.
    wa_final-ZSERIES = wa_mara-ZSERIES.
    wa_final-ZSIZE   = wa_mara-ZSIZE  .
    wa_final-BRAND   = wa_mara-BRAND  .
    wa_final-MOC     = wa_mara-MOC    .
    wa_final-TYPE    = wa_mara-TYPE   .
  ENDIF.

 READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_msku-matnr bwkey = wa_msku-werks.
  IF sy-subrc = 0.
    IF wa_mbew-vprsv = 'S'.
      wa_final-rate = wa_mbew-stprs.
    ELSE.
      wa_final-rate = wa_mbew-verpr.
    ENDIF.

    con_rate = wa_mbew-salk3 / wa_mbew-lbkum.
  ENDIF.


  wa_final-CONS_VAL = wa_final-kulab * con_rate.


  APPEND wa_final TO it_final.
  CLEAR : wa_final,con_rate.
ENDLOOP.

IF P_DOWN = 'X'.
 LOOP AT it_final INTO wa_final.
   wa_down-ZSERIES  = wa_final-ZSERIES .
   wa_down-ZSIZE    = wa_final-ZSIZE   .
   wa_down-KUNNR    = wa_final-KUNNR   .
   wa_down-NAME1    = wa_final-NAME1   .
   wa_down-MATNR    = wa_final-MATNR   .
   wa_down-MAKTX    = wa_final-MAKTX   .
   wa_down-WRKST    = wa_final-WRKST   .
   wa_down-RATE     = wa_final-RATE    .
   wa_down-KULAB    = wa_final-KULAB   .
   wa_down-CONS_VAL = wa_final-CONS_VAL.
   wa_down-BRAND    = wa_final-BRAND   .
   wa_down-MOC      = wa_final-MOC     .
   wa_down-TYPE     = wa_final-TYPE    .
   wa_down-WERKS    = wa_final-WERKS   .

   CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO wa_down-ref_time SEPARATED BY ':'.

   APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
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
PERFORM fcat USING :     '1'  'ZSERIES'       'IT_FINAL'  'Series'                                           '18' ,
                         '2'  'ZSIZE'         'IT_FINAL'  'Size'                                     '18' ,
                         '3'  'KUNNR'         'IT_FINAL'  'Customer '                                     '18' ,
                         '4'  'NAME1'         'IT_FINAL'  'Customer Name'                                     '18' ,
                         '5'  'MATNR'         'IT_FINAL'  'Material.No.'                                     '18' ,
                         '6'  'MAKTX'         'IT_FINAL'  'Material Desc'                                    '18',
                         '7'  'WRKST'         'IT_FINAL'  'USA Part NO'                                    '18',
                         '8'  'RATE'          'IT_FINAL'  'Rate'                                        '18',
                         '9'  'KULAB'         'IT_FINAL'  'Consignment Qty'                                        '18',
                        '10'  'CONS_VAL'      'IT_FINAL'  'Consignment Value'                                        '18',
                        '11'  'BRAND'         'IT_FINAL'  'Brand'                                        '18',
                        '12'  'MOC'           'IT_FINAL'  'MOC'                                        '18',
                        '13'  'TYPE'          'IT_FINAL'  'Type'                                        '18',
                        '14'  'WERKS'         'IT_FINAL'  'Plant'                                        '18'.
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
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*      i_callback_user_command = 'USER_CMD'
*      i_callback_top_of_page  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
*      is_layout               = wa_layout
      it_fieldcat             = it_fcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*      it_sort                 = t_sort[]
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'X'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0492   text
*      -->P_0493   text
*      -->P_0494   text
*      -->P_0495   text
*      -->P_0496   text
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
*  wa_fcat-key       = .
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
 TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE         TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZUS_MB58.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUS_MB58 REPORT Started On', SY-DATUM, 'At', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_424 TYPE string.
DATA lv_crlf_424 TYPE string.
lv_crlf_424 = cl_abap_char_utilities=>cr_lf.
lv_string_424 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_424 lv_crlf_424 wa_csv INTO lv_string_424.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1019 TO lv_fullfile.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_424 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'Downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


************************************************************************************
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


  lv_file = 'ZUS_MB58.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_CONSIGNMENT REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_463 TYPE string.
DATA lv_crlf_463 TYPE string.
lv_crlf_463 = cl_abap_char_utilities=>cr_lf.
lv_string_463 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_463 lv_crlf_463 wa_csv INTO lv_string_463.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1019 TO lv_fullfile.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_463 TO lv_fullfile.
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
FORM CVS_HEADER  USING    PD_CSV.         "p_hd_csv.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Series'
              'Size'
              'Customer '
              'Customer Name'
              'Material.No.'
              'Material Desc'
              'USA Part NO'
              'Rate'
              'Consignment Qty'
              'Consignment Value'
              'Brand'
              'MOC'
              'Type'
              'Plant'
              'Refresh Date'
              'Refresh Time'
              INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
