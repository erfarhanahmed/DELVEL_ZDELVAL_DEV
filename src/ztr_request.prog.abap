*&---------------------------------------------------------------------*
*& Report ZTR_REQUEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTR_REQUEST.

TABLES : E070.

TYPES : BEGIN OF TY_E070,
          TRKORR     TYPE E070-TRKORR,
          TRFUNCTION TYPE E070-TRFUNCTION,
          TRSTATUS   TYPE E070-TRSTATUS,
          TARSYSTEM  TYPE E070-TARSYSTEM,
          KORRDEV    TYPE E070-KORRDEV,
          AS4USER    TYPE E070-AS4USER,
          AS4DATE    TYPE E070-AS4DATE,
          AS4TIME    TYPE E070-AS4TIME,
          STRKORR    TYPE E070-STRKORR,
        END OF TY_E070.

TYPES : BEGIN OF TY_E07T,
       TRKORR     TYPE E07T-TRKORR,
       LANGU      TYPE E07T-LANGU,
       AS4TEXT    TYPE E07T-AS4TEXT,
       END OF TY_E07T.

TYPES : BEGIN OF TY_FINAL,
          TRKORR     TYPE E070-TRKORR,
          TRFUNCTION TYPE E070-TRFUNCTION,
          TRSTATUS   TYPE E070-TRSTATUS,
          TARSYSTEM  TYPE E070-TARSYSTEM,
          KORRDEV    TYPE E070-KORRDEV,
          AS4USER    TYPE E070-AS4USER,
          AS4DATE    TYPE E070-AS4DATE,
          AS4TIME    TYPE E070-AS4TIME,
          STRKORR    TYPE E070-STRKORR,
          AS4TEXT    TYPE E07T-AS4TEXT,

        END OF TY_FINAL.


TYPES : BEGIN OF TY_DOWN,
          TRKORR     TYPE E070-TRKORR,
          TRFUNCTION TYPE E070-TRFUNCTION,
          TRSTATUS   TYPE E070-TRSTATUS,
          TARSYSTEM  TYPE E070-TARSYSTEM,
          KORRDEV    TYPE E070-KORRDEV,
          AS4USER    TYPE E070-AS4USER,
          AS4DATE    TYPE CHAR30,
          AS4TIME    TYPE E070-AS4TIME,
          STRKORR    TYPE E070-STRKORR,
          AS4TEXT    TYPE E07T-AS4TEXT,
          REF_DAT    TYPE CHAR15,                         "Refresh Date
          REF_TIME   TYPE CHAR15,

        END OF TY_DOWN.

DATA : IT_E070  TYPE TABLE OF TY_E070,
       WA_E070  TYPE TY_E070,

       IT_E07T  TYPE TABLE OF TY_E07T,
       WA_E07T  TYPE TY_E07T,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL,

       IT_DOWN  TYPE TABLE OF TY_DOWN,
       WA_DOWN  TYPE TY_DOWN.



DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_TR FOR E070-TRKORR,
                S_USER FOR E070-AS4USER.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'. "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


START-OF-SELECTION.
  PERFORM GET_DATA.
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


  SELECT TRKORR
        TRFUNCTION
        TRSTATUS
        TARSYSTEM
        KORRDEV
        AS4USER
        AS4DATE
        AS4TIME
        STRKORR
        FROM E070
        INTO TABLE IT_E070
        WHERE TRKORR IN S_TR
        AND AS4USER IN S_USER.

    SELECT TRKORR
           LANGU
           AS4TEXT
           FROM E07T INTO TABLE  IT_E07T
           FOR ALL ENTRIES IN IT_E070 WHERE TRKORR = IT_E070-TRKORR.

  LOOP AT IT_E070 INTO WA_E070.
    WA_FINAL-TRKORR = WA_E070-TRKORR.
    WA_FINAL-TRFUNCTION = WA_E070-TRFUNCTION.
    WA_FINAL-TRSTATUS = WA_E070-TRSTATUS.
    WA_FINAL-TARSYSTEM = WA_E070-TARSYSTEM.
    WA_FINAL-KORRDEV = WA_E070-KORRDEV.
    WA_FINAL-AS4USER = WA_E070-AS4USER.
    WA_FINAL-AS4DATE = WA_E070-AS4DATE.
    WA_FINAL-AS4TIME = WA_E070-AS4TIME.
    WA_FINAL-STRKORR = WA_E070-STRKORR.

    READ TABLE IT_E07T INTO WA_E07T WITH KEY TRKORR = WA_E070-TRKORR.
     WA_FINAL-AS4TEXT = WA_E07T-AS4TEXT.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR : WA_E070,WA_E07T.
  ENDLOOP.



LOOP AT IT_FINAL INTO WA_FINAL.
    WA_DOWN-TRKORR = WA_FINAL-TRKORR.
    WA_DOWN-TRFUNCTION = WA_FINAL-TRFUNCTION.
    WA_DOWN-TRSTATUS = WA_FINAL-TRSTATUS.
    WA_DOWN-TARSYSTEM = WA_FINAL-TARSYSTEM.
    WA_DOWN-KORRDEV = WA_FINAL-KORRDEV.
    WA_DOWN-AS4USER = WA_FINAL-AS4USER.
    WA_DOWN-AS4DATE = WA_FINAL-AS4DATE.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-AS4DATE
      IMPORTING
        OUTPUT = WA_DOWN-AS4DATE.

    CONCATENATE WA_DOWN-AS4DATE+0(2) WA_DOWN-AS4DATE+2(3) WA_DOWN-AS4DATE+5(4)
                    INTO WA_DOWN-AS4DATE SEPARATED BY '-'.

    WA_DOWN-AS4TIME = WA_FINAL-AS4TIME.
    WA_DOWN-STRKORR = WA_FINAL-STRKORR.
    WA_DOWN-AS4TEXT = WA_FINAL-AS4TEXT.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_DOWN-REF_DAT.
    CONCATENATE WA_DOWN-REF_DAT+0(2) WA_DOWN-REF_DAT+2(3) WA_DOWN-REF_DAT+5(4)
   INTO WA_DOWN-REF_DAT SEPARATED BY '-'.

    WA_DOWN-REF_TIME = SY-UZEIT.
    CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

APPEND WA_DOWN TO IT_DOWN.


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
FORM GET_FCAT .
  PERFORM FCAT USING :
                        '1'  'TRKORR'         'IT_FINAL'  'Request Task'              '18' ,
                        '2'  'TRFUNCTION'     'IT_FINAL'  'TR Function'                '18',
                        '3'  'TRSTATUS'       'IT_FINAL'  'Status of Request Task'     '18' ,
                        '4'  'TARSYSTEM'      'IT_FINAL'  'Transport Target'           '18' ,
                        '5'  'KORRDEV'        'IT_FINAL'  'Category'                   '18' ,
                        '6'  'AS4USER'        'IT_FINAL'  'Owner'                      '18' ,
                        '7'  'AS4DATE'         'IT_FINAL'  'Date'                      '18' ,
                        '8'  'AS4TIME'         'IT_FINAL'  'Time'                      '18' ,
                        '9'  'STRKORR'         'IT_FINAL'  'Higher Level Request'      '18' ,
                        '10' 'AS4TEXT'         'IT_FINAL'  'TR Description'            '100' .
ENDFORM.

*----------------------------------------------------------------------*
FORM GET_DISPLAY .

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
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1200   text
*      -->P_1201   text
*      -->P_1202   text
*      -->P_1203   text
*      -->P_1204   text
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
  WA_FCAT-OUTPUTLEN = P5.

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

**** new addition cahnges by sagar dev as per requirement yogesh joshi sir 25/01/2024
  CONCATENATE 'ZTR_REQUEST' SY-MANDT '.TXT' INTO LV_FILE.
*  LV_FILE =   'ZTR_REQUEST.TXT'. " code commencted by sagar dev .
*****************************************************

*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZTR_REQUEST Download started on', SY-DATUM, 'at', SY-UZEIT .
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_360 TYPE string.
DATA lv_crlf_360 TYPE string.
lv_crlf_360 = cl_abap_char_utilities=>cr_lf.
lv_string_360 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_360 lv_crlf_360 wa_csv INTO lv_string_360.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_1683 TO lv_fullfile.
*TRANSFER lv_string_502 TO lv_fullfile.
TRANSFER lv_string_360 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' LV_FILE INTO LV_MSG SEPARATED BY SPACE.
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
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Request Task'
              'TR Function'
              'Status of Request Task'
              'Transport Target'
              'Category'
              'Owner'
              'Date'
              'Time'
              'Higher Level Request'
              'TR Description'
              'Ref Date'
              'Ref Time'
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
