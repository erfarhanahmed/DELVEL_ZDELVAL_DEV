*&---------------------------------------------------------------------*
*& Report ZUS_SBIN_REPORT_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_SBIN_REPORT_NEW.

TABLES :MARD, MARA,CDPOS,CDHDR.

TYPES : BEGIN OF TY_MARD,
          MATNR(90)," TYPE MARD-MATNR,
          WERKS     TYPE MARD-WERKS,
          LGORT     TYPE MARD-LGORT,
          LGPBE     TYPE MARD-LGPBE,
        END OF TY_MARD.

TYPES : BEGIN OF TY_MARA,
          MATNR   TYPE MARA-MATNR,
          WRKST   TYPE MARA-WRKST,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          BRAND   TYPE MARA-BRAND,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
        END OF TY_MARA.

TYPES : BEGIN OF ty_data,
*       MATNR(90)," TYPE MARD-MATNR,
       MATNR TYPE char90,
          WERKS     TYPE MARD-WERKS,
          LGORT     TYPE MARD-LGORT,
          LGPBE     TYPE MARD-LGPBE,
           WRKST   TYPE MARA-WRKST,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          BRAND   TYPE MARA-BRAND,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
        END OF ty_data.
TYPES : BEGIN OF TY_CDPOS,
          OBJECTCLAS TYPE CDPOS-OBJECTCLAS, "Object class
          CHANGENR   TYPE CDPOS-CHANGENR,
          FNAME      TYPE CDPOS-FNAME,          "Field Name
          OBJECTID   TYPE CDPOS-OBJECTID,    "Object Value
          VALUE_NEW  TYPE CDPOS-VALUE_NEW,
        END OF TY_CDPOS.

TYPES : BEGIN OF TY_CDHDR,
          OBJECTCLAS TYPE CDHDR-OBJECTCLAS, "Object class
          OBJECTID   TYPE CDHDR-OBJECTID,
          CHANGENR   TYPE CDHDR-CHANGENR,
          USERNAME   TYPE CDHDR-USERNAME,         "User name of the person responsible in change document
          UDATE      TYPE CDHDR-UDATE ,           "Creation date of the change document
          UTIME      TYPE CDHDR-UTIME ,           " Time changed
          TCODE      TYPE CDHDR-TCODE ,           " Time changed
        END OF TY_CDHDR.

TYPES : BEGIN OF TY_MBEW,
          MATNR TYPE MBEW-MATNR,
          LBKUM TYPE MBEW-LBKUM,          "Stock Qty
        END OF TY_MBEW.

TYPES : BEGIN OF TY_FINAL,
          MATNR       TYPE MARD-MATNR,
          WERKS       TYPE MARD-WERKS,
          LGORT       TYPE MARD-LGORT,
          LGPBE       TYPE MARD-LGPBE,
          WRKST       TYPE MARA-WRKST,
          ZSERIES     TYPE MARA-ZSERIES,
          ZSIZE       TYPE MARA-ZSIZE,
*           MATNR       TYPE MARA-MATNR,
          LBKUM       TYPE MBEW-LBKUM,
        OBJECTID   TYPE CDPOS-OBJECTID,
          STORAGE_BIN TYPE CDPOS-VALUE_NEW,
          USERNAME    TYPE CDHDR-USERNAME,
          UDATE       TYPE UDATE ,           "Creation date of the change document
          UTIME       TYPE CDHDR-UTIME ,           " Time changed
        END OF TY_FINAL.

TYPES : BEGIN OF TY_STR,
          ref_dt       TYPE sy-datum,
           ZSERIES     TYPE MARA-ZSERIES,        " series
          ZSIZE       TYPE MARA-ZSIZE,          " Size
           WRKST       TYPE MARA-WRKST,           " Delval USA code
          MATNR       TYPE MARD-MATNR,             " Material No
          WERKS       TYPE MARD-WERKS,         " plant
          LGORT       TYPE MARD-LGORT,         " storage location
          LGPBE       TYPE string,          " Storage Bin
          LBKUM       TYPE char15, "MBEW-LBKUM,           " Stock Qty
          USERNAME    TYPE char40,       " Location updated by
          UDATE       TYPE UDATE,        "Location updated date
          UTIME       TYPE UTIME ,         "Location updated time
        END OF TY_STR.


DATA :IT_MBEW TYPE TABLE OF TY_MBEW,
      WA_MBEW TYPE TY_MBEW.

DATA : IT_MARA TYPE TABLE OF TY_MARA,
       WA_MARA TYPE TY_MARA.

DATA : IT_CDHDR TYPE TABLE OF TY_CDHDR,
       WA_CDHDR TYPE TY_CDHDR.

DATA : IT_MARD TYPE STANDARD TABLE OF ty_data ,"TY_MARD,
       WA_MARD TYPE ty_data."TY_MARD.

DATA : IT_FINAL TYPE STANDARD TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL.

DATA :IT_CDPOS TYPE TABLE OF TY_CDPOS,
      WA_CDPOS TYPE TY_CDPOS.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA : IT_STR TYPE TABLE OF TY_STR,
       WA_STR TYPE  TY_STR.


DATA : WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV,                                " LAYOUT WORKAREA
       I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,                     " TOP-OF-PAGE
       GT_EVENTS          TYPE SLIS_T_EVENT.


*DATA:
*  LV_CLINT   LIKE SY-MANDT,   "Client
*  LV_ID      LIKE THEAD-TDID, "Text ID of text to be read
*  LV_LANG    LIKE THEAD-TDSPRAS, "Language
*  LV_NAME    LIKE THEAD-TDNAME, "Name of text to be read
*  LV_OBJECT  LIKE THEAD-TDOBJECT, "Object of text to be read
*  LV_A(132)  TYPE C,           "local variable to store text
*  LV_B(132)  TYPE C,           "local variable to store text
*  LV_D(132)  TYPE C,           "local variable to store text
*  LV_E(132)  TYPE C,           "local variable to store text
*  LV_L(132)  TYPE C,           "local variable to store text
*  LV_G(132)  TYPE C,           "local variable to store text
*  LV_H(132)  TYPE C,           "local variable to store text
*  LV_I(132)  TYPE C,           "local variable to store text
*  LV_J(132)  TYPE C,           "local variable to store text
*  LV_K(132)  TYPE C,           "local variable to store text
*  LV_F(1320) TYPE C.           "local variable to store concatenated text


*LV_CLINT = SY-MANDT. "Client
*LV_LANG = 'EN'.      "Language
*LV_ID = 'QAVE'.      "Text ID of text to be read
*LV_OBJECT = 'QPRUEFLOS'. "Object of text to be read



SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : S_MATNR FOR MARD-MATNR.
SELECT-OPTIONS : S_SERIES FOR MARA-ZSERIES.
SELECT-OPTIONS : S_WERKS FOR MARD-WERKS OBLIGATORY DEFAULT 'US01'.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .           " for refreshable file
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/USA'."USA'."usa'.   "'E:\delval\usa'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN BEGIN OF LINE.                                         " for refreshable file
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM PROCESS_DATA.
  PERFORM FCAT_DATA.
  PERFORM DISPLAY_DATA.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT   a~MATNR
           a~WERKS
           a~LGORT
           a~LGPBE
           b~WRKST
           b~ZSERIES
           b~ZSIZE
           b~BRAND
           b~MOC
           b~TYPE
    into   TABLE it_mard
    FROM mard as a
    JOIN mara as b
    on ( b~matnr = a~matnr )
   WHERE A~MATNR IN S_MATNR
    AND a~WERKS IN S_WERKS
     AND  b~ZSERIES IN S_SERIES.


*
*  SELECT MATNR
*         WERKS
*         LGORT
*         LGPBE
*    FROM MARD
*    INTO TABLE IT_MARD
*    WHERE MATNR IN S_MATNR
*    AND WERKS IN S_WERKS.

  IF IT_MARD IS NOT INITIAL.
*    SELECT MATNR
*           WRKST
*           ZSERIES
*           ZSIZE
*      FROM MARA
*      INTO TABLE IT_MARA
*      FOR ALL ENTRIES IN IT_MARD
*      WHERE MATNR = IT_MARD-MATNR+0(18).
*      AND  ZSERIES IN S_SERIES.

    SELECT MATNR
       LBKUM                              "MBEW-Material Valuation
       FROM MBEW
       INTO CORRESPONDING FIELDS OF TABLE IT_MBEW
       FOR ALL ENTRIES IN IT_MARD
      WHERE MATNR = IT_MARD-matnr+0(40)
*      WHERE MATNR = IT_MARD-MATNR+0(18)
      and bwkey = 'US01'.

    SELECT OBJECTCLAS
           OBJECTID
           CHANGENR
           USERNAME
           UDATE
           UTIME
           TCODE
     FROM CDHDR
     INTO TABLE IT_CDHDR
     FOR ALL ENTRIES IN IT_MARD
     WHERE OBJECTID = IT_MARD-MATNR
      AND OBJECTCLAS = 'MATERIAL'
     AND TCODE = 'MM02(BAPI) '.

  ENDIF.
  IF IT_CDHDR IS NOT INITIAL.
    SELECT OBJECTCLAS
           CHANGENR
           FNAME
           OBJECTID
           VALUE_NEW
        FROM CDPOS
        INTO TABLE IT_CDPOS
        FOR ALL ENTRIES IN IT_CDHDR
        WHERE OBJECTID = IT_CDHDR-OBJECTID
         AND CHANGENR  = IT_CDHDR-CHANGENR
          AND TABNAME = 'MARD'
          AND FNAME =  'LGPBE'.
  ENDIF.






ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PROCESS_DATA .
  LOOP AT IT_MARD INTO WA_MARD.

    WA_FINAL-MATNR  = WA_MARD-MATNR.
    WA_FINAL-WERKS  = WA_MARD-WERKS.
    WA_FINAL-LGORT  = WA_MARD-LGORT.
    WA_FINAL-LGPBE  = WA_MARD-LGPBE.
     WA_FINAL-MATNR  = WA_mard-MATNR .
    WA_FINAL-WRKST   = WA_mard-WRKST .
    WA_FINAL-ZSERIES = WA_mard-ZSERIES.
    WA_FINAL-ZSIZE   = WA_mard-ZSIZE.

*    READ TABLE IT_MARA INTO WA_MARA WITH KEY  MATNR = WA_MARD-MATNR+0(18).  " MATNR = WA_FINAL-objectid.
*    WA_FINAL-MATNR   = WA_MARA-MATNR .
*    WA_FINAL-WRKST   = WA_MARA-WRKST .
*    WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
*    WA_FINAL-ZSIZE   = WA_MARA-ZSIZE.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY  MATNR = WA_MARD-MATNR+0(18).
    WA_FINAL-LBKUM  = WA_MBEW-LBKUM .
*    if wa_final-storage_bin

    READ TABLE IT_CDHDR INTO WA_CDHDR WITH KEY OBJECTID = WA_MARD-MATNR.                "wa_final-objectid.
*                                             changenr = wa_cdpos-changenr .
    IF SY-SUBRC = 0.

*if  wa_final-storage_bin = WA_FINAL-LGPBE .
      WA_FINAL-USERNAME    = WA_CDHDR-USERNAME   .
      WA_FINAL-UDATE       = WA_CDHDR-UDATE      .
      WA_FINAL-UTIME       = WA_CDHDR-UTIME      .
*   wa_final-TCODE       = wa_cdhdr-TCODE      .
*endif.
    ENDIF.

    READ TABLE IT_CDPOS INTO WA_CDPOS WITH KEY  OBJECTID = WA_CDHDR-OBJECTID
                                                CHANGENR = WA_CDHDR-CHANGENR.
*    wa_final-objectid = wa_cdpos-objectid.
    WA_FINAL-STORAGE_BIN = WA_CDPOS-VALUE_NEW.
*if  wa_final-storage_bin = WA_FINAL-LGPBE .
    APPEND WA_FINAL TO IT_FINAL.
*  endif.
    CLEAR : WA_FINAL,WA_MARA,WA_MARD,WA_CDHDR,WA_CDPOS,WA_MBEW.

  ENDLOOP.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
       WA_STR-ref_dt         = SY-DATUM.
      WA_STR-MATNR            =     WA_FINAL-MATNR       .
      WA_STR-WERKS            =     WA_FINAL-WERKS       .
      WA_STR-LGORT            =     WA_FINAL-LGORT       .
      WA_STR-LGPBE            =     WA_FINAL-LGPBE       .
      WA_STR-ZSERIES          =     WA_FINAL-ZSERIES     .                                                                                                                                                  " 'ZSIZE '
      WA_STR-ZSIZE            =     WA_FINAL-ZSIZE       .
      WA_STR-WRKST            =     WA_FINAL-WRKST       .
*      WA_STR-MATNR1            =    WA_FINAL-MATNR       .
      WA_STR-LBKUM            =     WA_FINAL-LBKUM       .
      WA_STR-USERNAME         =     WA_FINAL-USERNAME    .
      WA_STR-UDATE            =     WA_FINAL-UDATE       .
*      CONCATENATE WA_FINAL-UDATE+6(2) WA_FINAL-UDATE+4(2) WA_FINAL-UDATE+0(4)INTO WA_STR-UDATE SEPARATED BY '.'  .


      WA_STR-UTIME            =     WA_FINAL-UTIME       .
*       CONCATENATE WA_FINAL-UTIME+0(2) WA_FINAL-UTIME+2(2) WA_FINAL-UTIME+4(2) INTO WA_STR-UTIME SEPARATED BY ':'.

      APPEND WA_STR TO IT_STR.
    ENDLOOP.
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FCAT_DATA .
  PERFORM FCAT USING :    '1'    'ZSERIES'         'IT_Final'  'series '                                                 '20' ,
                         '2'    'ZSIZE'          'IT_Final'    'Size'                                                    '20' ,
                         '3'    'WRKST'          'IT_Final'    'Delval USA code'                                         '20' ,
                          '4'    'MATNR'           'IT_FINAL'  'Material Number'                                         '15' ,
                         '5'    'WERKS'           'IT_FINAL'   'Plant'                                                   '20' ,
                         '6'    'LGORT'           'IT_FINAL'   'Storage Location'                                        '20' ,
                         '7'    'LGPBE'           'IT_Final'   'Storage Bin'                                             '20' ,
                         '8'    'LBKUM'           'IT_Final'    'Stock Qty'                                             '20',
                         '09'   'USERNAME'       'IT_Final'    'Location updated by'                                     '20' ,
                         '10'    'UDATE'          'IT_Final'   'Location updated date'                                   '15' ,
                         '11'   'UTIME'          'IT_Final'    'Location updated time '                                   '15'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0170   text
*      -->P_0171   text
*      -->P_0172   text
*      -->P_0173   text
*      -->P_0174   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P_0170)
                    VALUE(P_0171)
                    VALUE(P_0172)
                    VALUE(P_0173)
                    VALUE(P_0174).

  WA_FCAT-COL_POS   = P_0170.
  WA_FCAT-FIELDNAME = P_0171 .
  WA_FCAT-TABNAME   = P_0172.
  WA_FCAT-SELTEXT_L = P_0173.
*  wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P_0174.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_DATA .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      I_CALLBACK_PROGRAM     = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      I_CALLBACK_TOP_OF_PAGE = 'TOP-OF-PAGE '
*     I_CALLBACK_HTML_TOP _OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      IS_LAYOUT              = WA_LAYOUT
      IT_FIELDCAT            = IT_FCAT
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
      I_SAVE                 = 'X'
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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      T_OUTTAB               = IT_FINAL
* EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.

ENDFORM.
FORM TOP-OF-PAGE.
*ALV HEADER DECLARATIONS
  DATA: LT_HEADER     TYPE SLIS_T_LISTHEADER,
        LS_HEADER     TYPE SLIS_LISTHEADER,
        LT_LINE       LIKE LS_HEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

* TITLE
  LS_HEADER-TYP  = 'H'.
  LS_HEADER-INFO = 'USA STORAGE BIN REPORT'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

* DATE
  LS_HEADER-TYP  = 'S'.
  LS_HEADER-KEY  = 'RUN DATE :'.
  CONCATENATE LS_HEADER-INFO SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM(4) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER.

*TIME
  LS_HEADER-TYP  = 'S'.
  LS_HEADER-KEY  = 'RUN TIME :'.
  CONCATENATE LS_HEADER-INFO SY-TIMLO(2) '.' SY-TIMLO+2(2) '.' SY-TIMLO+4(2) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.
  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' LD_LINESC
     INTO LT_LINE SEPARATED BY SPACE.


  LS_HEADER-TYP  = 'A'.
  LS_HEADER-INFO = LT_LINE.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER, LT_LINE.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_HEADER.
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
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_STR
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
  LV_FILE = 'ZUS_SBIN_REPORT_NEW.TXT'.                    "TCODE-ZSALES_ORD_CHANGE

*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.
*BREAK primus.
  WRITE: / 'ZUS_SBIN_REPORT_NEW DOWNLOAD STARTED ON', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_555 TYPE string.
DATA lv_crlf_555 TYPE string.
lv_crlf_555 = cl_abap_char_utilities=>cr_lf.
lv_string_555 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_555 lv_crlf_555 wa_csv INTO lv_string_555.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_555 TO lv_fullfile.
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
FORM CVS_HEADER  USING    P_HD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE  'Refreshable Date on'
              'series '
              'Size'
              'Delval USA code'
              'Material Number'
              'Plant'
              'Storage Location'
              'Storage Bin'
               'Stock Qty'
              'Location updated by'
              'Location updated date'
              'Location updated time '

INTO P_HD_CSV
             SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
