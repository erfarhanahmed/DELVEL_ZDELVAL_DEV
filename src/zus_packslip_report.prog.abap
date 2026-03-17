
*&---------------------------------------------------------------------*
*& Report ZUS_PACKSLIP_REPORT
*&---------------------------------------------------------------------*
*&Transaction:ZUS_PACKSLIP
*&Program Name:ZUS_PACKSLIP_REPORT
*&Functional Cosultant: Vijay Gaike
*&Technical Consultant: Shreya Sankpal / Nilay Brahnme
*&TR: DEVK911642
*&Date: 26.06.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT ZUS_PACKSLIP_REPORT.


TABLES : VBAK, VBAP.

TYPES : BEGIN OF TY_VBAK,
          VBELN TYPE VBAK-VBELN,
          ERDAT TYPE VBAK-ERDAT,
          KUNNR TYPE VBAK-KUNNR,
          AUDAT TYPE VBAK-AUDAT,
        END OF TY_VBAK,

        BEGIN OF TY_KNA1,
          KUNNR TYPE KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
        END OF TY_KNA1,


        BEGIN OF TY_VBAP,
          VBELN TYPE VBAP-VBELN,
          POSNR TYPE VBAP-POSNR,
          MATNR TYPE VBAP-MATNR,
          ARKTX TYPE VBAP-ARKTX,
          WERKS TYPE VBAP-WERKS,
        END OF TY_VBAP,


        BEGIN OF TY_VBFA,
          VBELV   TYPE VBFA-VBELV,
          POSNV   TYPE VBFA-POSNV,
          VBELN   TYPE VBFA-VBELN,
          POSNN   TYPE VBFA-POSNN,
          VBTYP_N TYPE VBFA-VBTYP_N,
          ERDAT   TYPE VBFA-ERDAT,
          RFMNG   TYPE VBFA-RFMNG,
          VBTYP_V TYPE VBFA-VBTYP_V,
        END OF TY_VBFA,


        BEGIN OF TY_LIPS,
          VBELN TYPE LIPS-VBELN,
          POSNR TYPE LIPS-POSNR,
          MATNR TYPE LIPS-MATNR,
        END OF TY_LIPS,


        BEGIN OF TY_FINAL,
          VBELN  TYPE VBAK-VBELN,
          ERDAT  TYPE VBAK-ERDAT,
          WERKS  TYPE VBAP-WERKS,
          KUNNR  TYPE VBAK-KUNNR,
          NAME1  TYPE KNA1-NAME1,
          MATNR  TYPE VBAP-MATNR,
          ARKTX  TYPE VBAP-ARKTX,
          POSNR  TYPE VBAP-POSNR,
          POSNR1 TYPE LIPS-POSNR,
          VBELN1 TYPE VBFA-VBELN,
          ERDAT1 TYPE VBFA-ERDAT,
          RFMNG  TYPE VBFA-RFMNG,
        END OF TY_FINAL,

        BEGIN OF TY_DOWN,
          VBELN    TYPE VBAK-VBELN,
          ERDAT    TYPE CHAR30,
          WERKS    TYPE VBAP-WERKS,
          KUNNR    TYPE VBAK-KUNNR,
          NAME1    TYPE KNA1-NAME1,
          MATNR    TYPE VBAP-MATNR,
          ARKTX    TYPE VBAP-ARKTX,
          POSNR    TYPE VBAP-POSNR,
          POSNR1   TYPE LIPS-POSNR,
          VBELN1   TYPE VBFA-VBELN,
          ERDAT1   TYPE CHAR30,
          RFMNG    TYPE VBFA-RFMNG,
          REF_DAT  TYPE CHAR30,
          REF_TIME TYPE CHAR30,
        END OF TY_DOWN.

DATA : IT_VBAP  TYPE TABLE OF TY_VBAP,
       WA_VBAP  TYPE TY_VBAP,

       IT_VBAK  TYPE TABLE OF TY_VBAK,
       WA_VBAK  TYPE TY_VBAK,

       IT_KNA1  TYPE TABLE OF TY_KNA1,
       WA_KNA1  TYPE TY_KNA1,

       IT_VBFA  TYPE TABLE OF TY_VBFA,
       WA_VBFA  TYPE TY_VBFA,

       IT_LIPS  TYPE TABLE OF TY_LIPS,
       WA_LIPS  TYPE TY_LIPS,

       WA_FINAL TYPE TY_FINAL,
       IT_FINAL TYPE STANDARD TABLE OF TY_FINAL,

       LT_DOWN  TYPE TABLE OF TY_DOWN,
       LS_DOWN  TYPE          TY_DOWN,

       WA_FCAT  TYPE SLIS_FIELDCAT_ALV,
       IT_FCAT  TYPE SLIS_T_FIELDCAT_ALV.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS      : S_AUDAT FOR VBAK-AUDAT.
SELECT-OPTIONS    : S_VBELN  FOR VBAK-VBELN,
                    S_WERKS FOR VBAP-WERKS OBLIGATORY  DEFAULT 'US01'."OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/USA'."USA'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM DISPLAY_DATA.
  PERFORM CREATE_FEILDCAT.
  PERFORM DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .



  SELECT  VBELN
          ERDAT
          KUNNR
          AUDAT
        FROM VBAK
        INTO TABLE IT_VBAK
        WHERE AUDAT IN S_AUDAT
        AND VBELN IN S_VBELN.

  SELECT  VBELN
            POSNR
            MATNR
            ARKTX
            WERKS
        FROM VBAP
        INTO TABLE IT_VBAP
        FOR ALL ENTRIES IN IT_VBAK
        WHERE WERKS IN S_WERKS
        AND VBELN = IT_VBAK-VBELN
        AND WERKS IN ( 'US01','US02','US03' ).

  SELECT   VBELV
             POSNV
             VBELN
             POSNN
             VBTYP_N
             ERDAT
             RFMNG
             VBTYP_V
             FROM VBFA
             INTO TABLE IT_VBFA
             FOR ALL ENTRIES IN IT_VBAP
             WHERE VBELV = IT_VBAP-VBELN
             AND VBTYP_N = 'J'.


  SELECT KUNNR
         NAME1
        FROM KNA1
        INTO TABLE IT_KNA1
        FOR ALL ENTRIES IN IT_VBAK
        WHERE KUNNR = IT_VBAK-KUNNR.


  SELECT VBELN
         POSNR
         MATNR
         FROM LIPS
         INTO TABLE IT_LIPS
         FOR ALL ENTRIES IN IT_VBFA
         WHERE VBELN = IT_VBFA-VBELN
        AND   POSNR  = IT_VBFA-POSNV.


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

  LOOP AT IT_LIPS INTO WA_LIPS .

    WA_FINAL-VBELN = WA_LIPS-VBELN.
    WA_FINAL-POSNR1 = WA_LIPS-POSNR.
    WA_FINAL-MATNR = WA_LIPS-MATNR.

    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY MATNR = WA_LIPS-MATNR.

    IF SY-SUBRC = '0'.
      WA_FINAL-WERKS = WA_VBAP-WERKS.
      WA_FINAL-POSNR = WA_VBAP-POSNR.
      WA_FINAL-MATNR = WA_VBAP-MATNR.
      WA_FINAL-ARKTX = WA_VBAP-ARKTX.
    ENDIF.

    READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_VBAP-VBELN.
    WA_FINAL-VBELN = WA_VBAK-VBELN.
    WA_FINAL-ERDAT = WA_VBAK-ERDAT.
    WA_FINAL-KUNNR = WA_VBAK-KUNNR.


    READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBAK-KUNNR.
    IF SY-SUBRC = '0'.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
    ENDIF.

    READ TABLE IT_VBFA INTO WA_VBFA WITH KEY VBELN = WA_LIPS-VBELN POSNV = WA_LIPS-POSNR.
    IF SY-SUBRC = '0'.
      WA_FINAL-VBELN1 = WA_VBFA-VBELN.
      WA_FINAL-ERDAT1 = WA_VBFA-ERDAT.
      WA_FINAL-RFMNG = WA_VBFA-RFMNG.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.

    CLEAR : WA_FINAL,WA_KNA1,WA_VBAK,WA_VBFA.

  ENDLOOP.
  CLEAR: WA_LIPS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FEILDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_FEILDCAT .
  SORT IT_FINAL BY VBELN1.
  PERFORM FCAT USING : '1'   'VBELN'           'IT_FINAL'      'Sales Order NO'                             '10' ,
                       '2'   'ERDAT'           'IT_FINAL'      'Sales Order Date'                           '10' ,
                       '3'   'WERKS'           'IT_FINAL'      'Plant'                                      '06' ,
                       '4'   'KUNNR'           'IT_FINAL'      'Customer Code'                              '10' ,
                       '5'   'NAME1'           'IT_FINAL'      'Customer Description'                       '20' ,
                       '6'   'MATNR'           'IT_FINAL'      'Material Code'                              '15' ,
                       '7'   'ARKTX'           'IT_FINAL'      'Material Description'                       '20' ,
                       '8'   'POSNR'           'IT_FINAL'      'Item Number'                                '20' ,
                       '9'   'POSNR1'          'IT_FINAL'      'Delivery Item Number'                       '20' ,
                       '10'  'VBELN1'          'IT_FINAL'      'Delivery No'                                '10' ,
                       '11'  'ERDAT1'          'IT_FINAL'      'Delivery Date'                              '10' ,
                       '12'  'RFMNG'           'IT_FINAL'      'Total Number of Items Packed'               '10' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0447   text
*      -->P_0448   text
*      -->P_0449   text
*      -->P_0450   text
*      -->P_0451   text
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
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
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
      IT_FIELDCAT        = IT_FCAT
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
    PERFORM DOWNLOAD_FILE.
  ENDIF.

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
  LOOP AT IT_FINAL INTO WA_FINAL.
    LS_DOWN-VBELN = WA_FINAL-VBELN.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-ERDAT
      IMPORTING
        OUTPUT = LS_DOWN-ERDAT.
    CONCATENATE LS_DOWN-ERDAT+0(2) LS_DOWN-ERDAT+2(3) LS_DOWN-ERDAT+5(4)
   INTO LS_DOWN-ERDAT SEPARATED BY '-'.

    LS_DOWN-MATNR = WA_FINAL-MATNR.
    LS_DOWN-ARKTX = WA_FINAL-ARKTX.
    LS_DOWN-WERKS = WA_FINAL-WERKS.
    LS_DOWN-KUNNR = WA_FINAL-KUNNR.
    LS_DOWN-NAME1 = WA_FINAL-NAME1.
    LS_DOWN-VBELN1 = WA_FINAL-VBELN1.
    LS_DOWN-POSNR = WA_FINAL-POSNR.        "Added By Nilay B. on 27.06.2023
    LS_DOWN-POSNR1 = WA_FINAL-POSNR1.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-ERDAT1
      IMPORTING
        OUTPUT = LS_DOWN-ERDAT1.
    CONCATENATE LS_DOWN-ERDAT1+0(2) LS_DOWN-ERDAT1+2(3) LS_DOWN-ERDAT1+5(4)
   INTO LS_DOWN-ERDAT1 SEPARATED BY '-'.

    LS_DOWN-RFMNG = WA_FINAL-RFMNG.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = LS_DOWN-REF_DAT.
    CONCATENATE LS_DOWN-REF_DAT+0(2) LS_DOWN-REF_DAT+2(3) LS_DOWN-REF_DAT+5(4)
   INTO LS_DOWN-REF_DAT SEPARATED BY '-'.

    LS_DOWN-REF_TIME = SY-UZEIT.
    CONCATENATE LS_DOWN-REF_TIME+0(2) ':' LS_DOWN-REF_TIME+2(2)  INTO LS_DOWN-REF_TIME.


    APPEND LS_DOWN TO LT_DOWN.
    CLEAR: LS_DOWN.     "wa_final.

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
FORM DOWNLOAD_FILE .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.


  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = LT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.
  LV_FILE = 'ZUS_PACKSLIP.TXT'.

*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
  INTO LV_FULLFILE.
* BREAK primus.
  WRITE: / 'ZUS_PACKSLIP_REPORT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_487 TYPE string.
DATA lv_crlf_487 TYPE string.
lv_crlf_487 = cl_abap_char_utilities=>cr_lf.
lv_string_487 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_487 lv_crlf_487 wa_csv INTO lv_string_487.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_487 TO lv_fullfile.
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

  CONCATENATE           'Sales Order NO'
                        'Sales Order Date'
                        'Plant'
                        'Customer Code'
                        'Customer Name'
                        'Material No'
                        'Material Description'
                        'Item Number'
                        'Delivery Line Item'
                        'Delivery No'
                        'Delivery Date'
                        'Total Number of Items Packed'
                        'Refresh date'
                        'Refresh time'
          INTO P_HD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
