*&---------------------------------------------------------------------*
*& Report ZITEM_MASTER_BIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZITEM_MASTER_BIN.


*&---------------------------------------------------------------------*
*&
*&  (c)   P R I M U S  Techsystems Pvt. Ltd.
*&
*&  Description    :
*&
*&  Developer             :
*&  Request No.           :
*&  Change Request No.    :
*&  Functional Consultant :
*&  Created On            :
*&
*&  T-Code                :
*&
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Tables
*&---------------------------------------------------------------------*
TABLES : MARA , MAKT , MARD .

*&---------------------------------------------------------------------*
*& Types / structure
*&---------------------------------------------------------------------*
TYPES : BEGIN OF STR_MARA,
          MATNR TYPE MARA-MATNR,
          BRAND TYPE MARA-BRAND,
          TYPE  TYPE MARA-TYPE,
        END OF STR_MARA.

TYPES : BEGIN OF STR_MAKT,
          MATNR TYPE MAKT-MATNR,
          MAKTX TYPE MAKT-MAKTX,
        END OF STR_MAKT.

TYPES : BEGIN OF STR_MARD,
          MATNR TYPE MARD-MATNR,
          WERKS TYPE MARD-WERKS,
          LGORT TYPE MARD-LGORT,
          LGPBE TYPE MARD-LGPBE,
        END OF STR_MARD.

TYPES : BEGIN OF STR_DATA,
          MATNR TYPE MARA-MATNR,
          MAKTX TYPE MAKT-MAKTX,
          BRAND TYPE MARA-BRAND,
          TYPE  TYPE MARA-TYPE,
          LGORT TYPE MARD-LGORT,
          LGPBE TYPE MARD-LGPBE,
          WERKS TYPE MARD-WERKS,
        END OF STR_DATA.

TYPES : BEGIN OF STR_DOWN,
          MATNR    TYPE MARA-MATNR,
          MAKTX    TYPE MAKT-MAKTX,
          BRAND    TYPE MARA-BRAND,
          TYPE     TYPE MARA-TYPE,
          LGORT    TYPE MARD-LGORT,
          LGPBE    TYPE MARD-LGPBE,
          REF_DATE TYPE CHAR11,
          REF_TIME TYPE CHAR15,
        END OF STR_DOWN.

*&---------------------------------------------------------------------*
*& Data declaration / variable /Internal Table and Work Area Declaration
*&---------------------------------------------------------------------*
DATA : IT_MARA TYPE TABLE OF STR_MARA,
       WA_MARA TYPE STR_MARA.

DATA : IT_MAKT TYPE TABLE OF STR_MAKT,
       WA_MAKT TYPE STR_MAKT.

DATA : IT_MARD TYPE TABLE OF STR_MARD,
       WA_MARD TYPE STR_MARD.

DATA : IT_DATA TYPE TABLE OF STR_DATA,
       WA_DATA TYPE STR_DATA.

DATA: IT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

DATA : IT_DOWN TYPE TABLE OF STR_DOWN,
       WA_DOWN TYPE STR_DOWN.


*----------------------------------------------------------------------*
* Selection screen
*----------------------------------------------------------------------*
SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : S_MATNR FOR MARA-MATNR.

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-004  .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER TYPE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
        "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-002.
SELECTION-SCREEN  COMMENT /1(60) TEXT-003.
*                     COMMENT 1(70) TEXT-004.
*SELECTION-SCREEN COMMENT /1(70) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.




*&---------------------------------------------------------------------*
*& Start of Selection
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM FILL_FIELDCAT.
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

  SELECT MATNR
            WERKS
            LGORT
            LGPBE FROM MARD
            INTO CORRESPONDING FIELDS OF TABLE IT_MARD
            WHERE MATNR IN S_MATNR
*           AND MATNR = IT_MARA-MATNR
            AND  LGPBE NE ' '
              AND WERKS = 'PL01'.


  IF SY-SUBRC = 0 AND IT_MARD IS NOT INITIAL .

    SELECT MATNR
             BRAND
             TYPE FROM MARA
             INTO CORRESPONDING FIELDS OF  TABLE IT_MARA
             FOR ALL ENTRIES IN IT_MARD
             WHERE MATNR = IT_MARD-MATNR.


    SELECT  MATNR
               MAKTX FROM MAKT
               INTO CORRESPONDING FIELDS OF TABLE IT_MAKT
               FOR ALL ENTRIES IN IT_MARD
               WHERE MATNR = IT_MARD-MATNR.

    LOOP AT IT_MARD INTO WA_MARD.
      WA_DATA-MATNR = WA_MARD-MATNR.
      WA_DATA-LGORT = WA_MARD-LGORT.
      WA_DATA-LGPBE = WA_MARD-LGPBE.

      READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARD-MATNR.
      IF SY-SUBRC = 0.
*       WA_DATA-MATNR  = WA_MARA-MATNR.
        WA_DATA-BRAND  = WA_MARA-BRAND.
        WA_DATA-TYPE = WA_MARA-TYPE.
      ENDIF.

      READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_MARD-MATNR.
      IF SY-SUBRC = 0.
        WA_DATA-MAKTX = WA_MAKT-MAKTX.
      ENDIF.

      APPEND WA_DATA TO IT_DATA.
      CLEAR WA_DATA.

    ENDLOOP.
  ENDIF.
*ENDFORM.


  IF P_DOWN = 'X'.
    LOOP AT IT_DATA INTO WA_DATA.

      WA_DOWN-MATNR    = WA_DATA-MATNR.
      WA_DOWN-MAKTX    = WA_DATA-MAKTX.
      WA_DOWN-BRAND    = WA_DATA-BRAND.
      WA_DOWN-TYPE     = WA_DATA-TYPE .
      WA_DOWN-LGORT     = WA_DATA-LGORT .
      WA_DOWN-LGPBE    = WA_DATA-LGPBE.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF_DATE.
      IF WA_DOWN-REF_DATE IS NOT INITIAL.
        CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
                        INTO WA_DOWN-REF_DATE SEPARATED BY '-'.
        WA_DOWN-REF_TIME = SY-UZEIT.
      ENDIF.


      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.
      APPEND WA_DOWN TO IT_DOWN.
* CLEAR WA_DOWN.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_FIELDCAT .

  WA_FIELDCAT-FIELDNAME = 'MATNR' .
  WA_FIELDCAT-SELTEXT_M = 'Material Number' .
  WA_FIELDCAT-COL_POS = '1'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT .
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MAKTX ' .
  WA_FIELDCAT-SELTEXT_M = 'Material Description' .
  WA_FIELDCAT-COL_POS = '2'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT .
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BRAND' .
  WA_FIELDCAT-SELTEXT_M = 'Brand' .
  WA_FIELDCAT-COL_POS = '3'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT .
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'TYPE' .
  WA_FIELDCAT-SELTEXT_M = 'Type' .
  WA_FIELDCAT-COL_POS = '4'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT .
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'LGORT' .
  WA_FIELDCAT-SELTEXT_M = 'Storage Location' .
  WA_FIELDCAT-COL_POS = '5'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT .
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'LGPBE' .
  WA_FIELDCAT-SELTEXT_M = 'Storage Bin' .
  WA_FIELDCAT-COL_POS = '6'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT .
  CLEAR WA_FIELDCAT.


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
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = 'SY-REPID'
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
      IT_FIELDCAT        = IT_FIELDCAT
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
      T_OUTTAB           = IT_DATA
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


  IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.
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
  LV_FILE = 'ZSTORAGE_BIN.TXT'.

 CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSTORAGE_BIN.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_392 TYPE string.
DATA lv_crlf_392 TYPE string.
lv_crlf_392 = cl_abap_char_utilities=>cr_lf.
lv_string_392 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_392 lv_crlf_392 wa_csv INTO lv_string_392.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1008 TO lv_fullfile.
TRANSFER lv_string_392 TO lv_fullfile.
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
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE   'Material Number'
                'Material Description'
                'Brand'
                'Type'
                'Storage Location'
                'Storage Bin'
                'Refreshable Date'
                'Refreshable Time'

               INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
