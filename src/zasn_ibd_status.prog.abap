*&---------------------------------------------------------------------*
*& Report ZASN_IBD_STATUS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZASN_IBD_STATUS.

TABLES : ZBUVI_IBD_FTP.
TYPE-POOLS : SLIS.

TYPES : BEGIN OF TY_ZBUVI_IBD_FTP,
        MANDT   TYPE ZBUVI_IBD_FTP-MANDT,
        FILE_NM TYPE ZBUVI_IBD_FTP-FILE_NM,
        LOG_ID  TYPE ZBUVI_IBD_FTP-LOG_ID,
        FDATE   TYPE ZBUVI_IBD_FTP-FDATE,
        FTIME   TYPE ZBUVI_IBD_FTP-FTIME,
        STAT    TYPE ZBUVI_IBD_FTP-STAT,
        ERNAM   TYPE ZBUVI_IBD_FTP-ERNAM,
        MESS    TYPE ZBUVI_IBD_FTP-MESS,
        END OF TY_ZBUVI_IBD_FTP.

DATA : WA_ZBUVI_IBD_FTP TYPE TY_ZBUVI_IBD_FTP,
       IT_ZBUVI_IBD_FTP TYPE TABLE OF TY_ZBUVI_IBD_FTP,
       V_FDATE TYPE ZBUVI_IBD_FTP-FDATE.

TYPES : BEGIN OF TY_FINAL,
        MANDT   TYPE ZBUVI_IBD_FTP-MANDT,
        FILE_NM TYPE ZBUVI_IBD_FTP-FILE_NM,
        LOG_ID  TYPE ZBUVI_IBD_FTP-LOG_ID,
        FDATE   TYPE CHAR15,"ZBUVI_IBD_FTP-FDATE,
        FTIME   TYPE ZBUVI_IBD_FTP-FTIME,
        STAT    TYPE ZBUVI_IBD_FTP-STAT,
        ERNAM   TYPE ZBUVI_IBD_FTP-ERNAM,
        MESS    TYPE ZBUVI_IBD_FTP-MESS,
        END OF TY_FINAL.

DATA : WA_FINAL TYPE TY_FINAL,
       IT_FINAL TYPE TABLE OF TY_FINAL.

DATA : WA_FCAT TYPE SLIS_FIELDCAT_ALV,
       IT_FCAT TYPE SLIS_T_FIELDCAT_ALV.

TYPES : BEGIN OF TY_DOWN,
        MANDT   TYPE ZBUVI_IBD_FTP-MANDT,
        FILE_NM TYPE ZBUVI_IBD_FTP-FILE_NM,
        LOG_ID  TYPE ZBUVI_IBD_FTP-LOG_ID,
        FDATE   TYPE CHAR15,"ZBUVI_IBD_FTP-FDATE,
        FTIME   TYPE ZBUVI_IBD_FTP-FTIME,
        STAT    TYPE ZBUVI_IBD_FTP-STAT,
        ERNAM   TYPE ZBUVI_IBD_FTP-ERNAM,
        MESS    TYPE ZBUVI_IBD_FTP-MESS,
        REF_DATE TYPE CHAR15,
        REF_TIME TYPE CHAR15,

        END OF TY_DOWN.

DATA : IT_DOWN TYPE STANDARD TABLE OF TY_DOWN,
       WA_DOWN TYPE TY_DOWN.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS S_FDATE FOR V_FDATE.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME.   "TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.

  PERFORM FETCH_DATA.
  PERFORM GET_DATA.
  PERFORM DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FETCH_DATA .

  SELECT *
    FROM ZBUVI_IBD_FTP
    INTO TABLE IT_ZBUVI_IBD_FTP
    WHERE FDATE IN S_FDATE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  LOOP AT IT_ZBUVI_IBD_FTP INTO WA_ZBUVI_IBD_FTP.

    WA_FINAL-MANDT   = WA_ZBUVI_IBD_FTP-MANDT  .
    WA_FINAL-FILE_NM = WA_ZBUVI_IBD_FTP-FILE_NM.
    WA_FINAL-LOG_ID  = WA_ZBUVI_IBD_FTP-LOG_ID .
    WA_FINAL-FDATE   = WA_ZBUVI_IBD_FTP-FDATE  .

     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-FDATE    "10.07.2017
      IMPORTING
        OUTPUT = WA_FINAL-FDATE.
    CONCATENATE WA_FINAL-FDATE+0(2) WA_FINAL-FDATE+2(3) WA_FINAL-FDATE+5(4)
    INTO WA_FINAL-FDATE SEPARATED BY '-'.



    WA_FINAL-FTIME   = WA_ZBUVI_IBD_FTP-FTIME  .
    WA_FINAL-STAT    = WA_ZBUVI_IBD_FTP-STAT   .
    WA_FINAL-ERNAM   = WA_ZBUVI_IBD_FTP-ERNAM  .
    WA_FINAL-MESS    = WA_ZBUVI_IBD_FTP-MESS   .

    APPEND WA_FINAL TO IT_FINAL.

  ENDLOOP.

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

  WA_FCAT-FIELDNAME     = 'MANDT'.
  WA_FCAT-SELTEXT_M     = 'Client'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  WA_FCAT-FIELDNAME     = 'FILE_NM'.
  WA_FCAT-SELTEXT_M     = 'file name'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  WA_FCAT-FIELDNAME     = 'LOG_ID'.
  WA_FCAT-SELTEXT_M     = 'log'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  WA_FCAT-FIELDNAME     = 'FDATE'.
  WA_FCAT-SELTEXT_M     = 'System Date'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  WA_FCAT-FIELDNAME     = 'FTIME'.
  WA_FCAT-SELTEXT_M     = 'System Time'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  WA_FCAT-FIELDNAME     = 'STAT'.
  WA_FCAT-SELTEXT_M     = 'File status'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  WA_FCAT-FIELDNAME     = 'ERNAM'.
  WA_FCAT-SELTEXT_M     = 'User Name'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  WA_FCAT-FIELDNAME     = 'MESS'.
  WA_FCAT-SELTEXT_M     = 'Message Text'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = 'SY-REPID'
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
     IT_FIELDCAT                       = IT_FCAT
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB                          = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2
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
    WA_DOWN-MANDT   = WA_FINAL-MANDT  .
    WA_DOWN-FILE_NM = WA_FINAL-FILE_NM.
    WA_DOWN-LOG_ID  = WA_FINAL-LOG_ID .
    WA_DOWN-FDATE   = WA_FINAL-FDATE  .
    WA_DOWN-FTIME   = WA_FINAL-FTIME  .
    WA_DOWN-STAT    = WA_FINAL-STAT   .
    WA_DOWN-ERNAM   = WA_FINAL-ERNAM  .
    WA_DOWN-MESS    = WA_FINAL-MESS   .

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_DOWN-REF_DATE.
    CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
    INTO WA_DOWN-REF_DATE SEPARATED BY '-'.

    WA_DOWN-REF_TIME = SY-UZEIT.
    CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.


    APPEND WA_DOWN TO IT_DOWN.
    CLEAR WA_DOWN.

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
  LV_FILE = 'ZASN_IBD_STATUS.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
  INTO LV_FULLFILE.
* BREAK primus.
  WRITE: / 'ZASN IBD STATUS Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_330 TYPE string.
DATA lv_crlf_330 TYPE string.
lv_crlf_330 = cl_abap_char_utilities=>cr_lf.
lv_string_330 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_330 lv_crlf_330 wa_csv INTO lv_string_330.
  CLEAR: wa_csv.
ENDLOOP.

TRANSFER lv_string_330 TO lv_fullfile.
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
  CONCATENATE   'Client'
                'file name'
                'log'
                'System Date'
                'System Time'
                'File status'
                'User Name'
                'Message Text'
                'Refresh Date'
                'Refresh Time'

                INTO P_HD_CSV
 SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
