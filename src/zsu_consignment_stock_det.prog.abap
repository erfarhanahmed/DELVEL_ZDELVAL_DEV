*&---------------------------------------------------------------------*
*&Report: ZSU_CONSIGNMENT_STOCK_DET
*&Transaction: ZSU_MB58
*&Functional Cosultant: Tejaswani Thakre/Vijay Gaike
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZUS_CONSIGNMENT_STOCK_DET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_CONSIGNMENT_STOCK_DET.

TABLES:MSKU.

TYPES: BEGIN OF TY_MSKU,
         MATNR TYPE MSKU-MATNR,
         WERKS TYPE MSKU-WERKS,
         CHARG TYPE MSKU-CHARG,
         SOBKZ TYPE MSKU-SOBKZ,
         KUNNR TYPE MSKU-KUNNR,
         LFGJA TYPE MSKU-LFGJA,
         KULAB TYPE MSKU-KULAB,
       END OF TY_MSKU,

       BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         BWTAR TYPE MBEW-BWTAR,
         LBKUM TYPE MBEW-LBKUM,
         SALK3 TYPE MBEW-SALK3,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
       END OF TY_MBEW,

       BEGIN OF TY_MARA,
         MATNR   TYPE MARA-MATNR,
         ERSDA   TYPE MARA-ERSDA,
         MTART   TYPE MARA-MTART,
         MATKL   TYPE MARA-MATKL,
         WRKST   TYPE MARA-WRKST,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         BRAND   TYPE MARA-BRAND,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
       END OF TY_MARA,

       BEGIN OF TY_FINAL,
         ZSERIES  TYPE MARA-ZSERIES,
         ZSIZE    TYPE MARA-ZSIZE,
         KUNNR    TYPE MSKU-KUNNR,
         NAME1    TYPE KNA1-NAME1,
         MATNR    TYPE MARA-MATNR,
         MAKTX    TYPE MAKT-MAKTX,
         WRKST    TYPE MARA-WRKST,
         RATE     TYPE MBEW-VERPR,
         KULAB    TYPE MSKU-KULAB,
         CONS_VAL TYPE MBEW-VERPR,
         BRAND    TYPE MARA-BRAND,
         MOC      TYPE MARA-MOC,
         TYPE     TYPE MARA-TYPE,
         WERKS    TYPE MSKU-WERKS,
         LONG_TXT TYPE CHAR100,        "Long Text for Material
       END OF TY_FINAL,

       BEGIN OF TY_DOWN,
         ZSERIES  TYPE MARA-ZSERIES,
         ZSIZE    TYPE MARA-ZSIZE,
         KUNNR    TYPE MSKU-KUNNR,
         NAME1    TYPE KNA1-NAME1,
         MATNR    TYPE MARA-MATNR,
         LONG_TXT TYPE CHAR100,         "Long Text for Material
*         MAKTX    TYPE MAKT-MAKTX,
         WRKST    TYPE MARA-WRKST,
         RATE     TYPE CHAR15, "MBEW-VERPR,
         KULAB    TYPE CHAR15, "MSKU-KULAB,
         CONS_VAL TYPE CHAR15, "MBEW-VERPR,
         BRAND    TYPE MARA-BRAND,
         MOC      TYPE MARA-MOC,
         TYPE     TYPE MARA-TYPE,
         WERKS    TYPE MSKU-WERKS,
         REF      TYPE CHAR15,
         REF_TIME TYPE CHAR20,

       END OF TY_DOWN.

DATA : IT_MSKU  TYPE TABLE OF TY_MSKU,
       WA_MSKU  TYPE          TY_MSKU,

       IT_MBEW  TYPE TABLE OF TY_MBEW,
       WA_MBEW  TYPE          TY_MBEW,

       IT_MARA  TYPE TABLE OF TY_MARA,
       WA_MARA  TYPE          TY_MARA,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,

       IT_DOWN  TYPE TABLE OF TY_DOWN,
       WA_DOWN  TYPE          TY_DOWN.



DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.
DATA:
  LV_ID    TYPE THEAD-TDNAME,
  LT_LINES TYPE STANDARD TABLE OF TLINE,
  LS_LINES TYPE TLINE.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS : S_MATNR FOR MSKU-MATNR,
                 S_KUNNR FOR MSKU-KUNNR,
                 S_WERKS FOR MSKU-WERKS OBLIGATORY DEFAULT 'SU01' NO INTERVALS MODIF ID BU.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi' . "'E:\delval\Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.


AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM SORT_DATA.
  PERFORM GET_FCAT.
  PERFORM GET_DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
  SELECT MATNR
         WERKS
         CHARG
         SOBKZ
         KUNNR
         LFGJA
         KULAB FROM MSKU INTO TABLE IT_MSKU
         WHERE MATNR IN S_MATNR
           AND KUNNR IN S_KUNNR
           AND WERKS IN S_WERKS.

  IF IT_MSKU IS NOT INITIAL.
    SELECT MATNR
           BWKEY
           BWTAR
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS FROM MBEW INTO TABLE IT_MBEW
           FOR ALL ENTRIES IN IT_MSKU
           WHERE MATNR = IT_MSKU-MATNR
             AND BWKEY = IT_MSKU-WERKS.

    SELECT MATNR
           ERSDA
           MTART
           MATKL
           WRKST
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_MSKU
           WHERE MATNR = IT_MSKU-MATNR.


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

  DATA : CON_RATE TYPE P DECIMALS 8.
  LOOP AT IT_MSKU INTO WA_MSKU.
    WA_FINAL-KUNNR = WA_MSKU-KUNNR.
    WA_FINAL-MATNR = WA_MSKU-MATNR.
    WA_FINAL-KULAB = WA_MSKU-KULAB.
    WA_FINAL-WERKS = WA_MSKU-WERKS.

    SELECT SINGLE MAKTX INTO WA_FINAL-MAKTX FROM MAKT WHERE MATNR = WA_MSKU-MATNR.
    SELECT SINGLE NAME1 INTO WA_FINAL-NAME1 FROM KNA1 WHERE KUNNR = WA_MSKU-KUNNR.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MSKU-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-WRKST   = WA_MARA-WRKST.
      WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
      WA_FINAL-ZSIZE   = WA_MARA-ZSIZE  .
      WA_FINAL-BRAND   = WA_MARA-BRAND  .
      WA_FINAL-MOC     = WA_MARA-MOC    .
      WA_FINAL-TYPE    = WA_MARA-TYPE   .
    ENDIF.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MSKU-MATNR BWKEY = WA_MSKU-WERKS.
    IF SY-SUBRC = 0.
      IF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-RATE = WA_MBEW-STPRS.
      ELSE.
        WA_FINAL-RATE = WA_MBEW-VERPR.
      ENDIF.

      CON_RATE = WA_MBEW-SALK3 / WA_MBEW-LBKUM.
    ENDIF.


    WA_FINAL-CONS_VAL = WA_FINAL-KULAB * CON_RATE.


    "Material Long Text
    LV_ID = WA_FINAL-MATNR.
    IF LV_ID IS NOT INITIAL.

      CLEAR: LT_LINES,LS_LINES.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_ID
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = LT_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.
      IF NOT LT_LINES IS INITIAL.
        LOOP AT LT_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_FINAL-LONG_TXT LS_LINES-TDLINE INTO WA_FINAL-LONG_TXT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
        CONDENSE WA_FINAL-LONG_TXT.
      ENDIF.

      CLEAR: LT_LINES,LS_LINES,LV_ID.

    ENDIF.
    IF WA_FINAL-KULAB IS NOT INITIAL.
      APPEND WA_FINAL TO IT_FINAL.
    ENDIF.
    CLEAR : WA_FINAL,CON_RATE.
  ENDLOOP.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-ZSERIES  = WA_FINAL-ZSERIES .
      WA_DOWN-ZSIZE    = WA_FINAL-ZSIZE   .
      WA_DOWN-KUNNR    = WA_FINAL-KUNNR   .
      WA_DOWN-NAME1    = WA_FINAL-NAME1   .
      WA_DOWN-MATNR    = WA_FINAL-MATNR   .
*      WA_DOWN-MAKTX    = WA_FINAL-MAKTX   .
      WA_DOWN-LONG_TXT    = WA_FINAL-LONG_TXT   .
      WA_DOWN-WRKST    = WA_FINAL-WRKST   .
      WA_DOWN-RATE     = WA_FINAL-RATE    .
      WA_DOWN-KULAB    = WA_FINAL-KULAB   .
      WA_DOWN-CONS_VAL = WA_FINAL-CONS_VAL.
      WA_DOWN-BRAND    = WA_FINAL-BRAND   .
      WA_DOWN-MOC      = WA_FINAL-MOC     .
      WA_DOWN-TYPE     = WA_FINAL-TYPE    .
      WA_DOWN-WERKS    = WA_FINAL-WERKS   .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      IF WA_DOWN-KULAB IS NOT INITIAL.
        APPEND WA_DOWN TO IT_DOWN.
      ENDIF.
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
FORM GET_FCAT .
  PERFORM FCAT USING :     '1'  'ZSERIES'       'IT_FINAL'  'Series'                                           '18' ,
                           '2'  'ZSIZE'         'IT_FINAL'  'Size'                                     '18' ,
                           '3'  'KUNNR'         'IT_FINAL'  'Customer '                                     '18' ,
                           '4'  'NAME1'         'IT_FINAL'  'Customer Name'                                     '18' ,
                           '5'  'MATNR'         'IT_FINAL'  'Material.No.'                                     '18' ,
                           '6'  'LONG_TXT'         'IT_FINAL'  'Material Desc'                                    '18',
                           '7'  'WRKST'         'IT_FINAL'  'Old Part No'                                    '18',
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
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     i_callback_user_command = 'USER_CMD'
*     i_callback_top_of_page  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     is_layout          = wa_layout
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     it_sort            = t_sort[]
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
      I_SAVE             = 'X'
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      T_OUTTAB           = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
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
FORM FCAT  USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*  wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

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


  LV_FILE = 'ZSU_MB58.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_MB51 REPORT Started On', SY-DATUM, 'At', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_494 TYPE string.
DATA lv_crlf_494 TYPE string.
lv_crlf_494 = cl_abap_char_utilities=>cr_lf.
lv_string_494 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_494 lv_crlf_494 wa_csv INTO lv_string_494.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_494 TO lv_fullfile.
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


  LV_FILE = 'ZSU_MB58.TXT'.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_CONSIGNMENT REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_534 TYPE string.
DATA lv_crlf_534 TYPE string.
lv_crlf_534 = cl_abap_char_utilities=>cr_lf.
lv_string_534 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_534 lv_crlf_534 wa_csv INTO lv_string_534.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_534 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
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
              'Old Part No'
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
