*&---------------------------------------------------------------------*
*& Report ZQA_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&*&Transaction: ZSU_QA_INFO
*&Functional Cosultant: Shumbham More
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK913058
*&Date: 15.12.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
REPORT ZSU_QA_INFO.

TYPE-POOLS: SLIS.

TABLES: QINF.

TYPES: BEGIN OF TY_QINF,
         MATNR     TYPE QINF-MATNR,
         WERK      TYPE QINF-WERK,
         LIEFERANT TYPE QINF-LIEFERANT,
         FREI_DAT  TYPE QINF-FREI_DAT,
         NOINSP    TYPE QINF-NOINSP,
       END OF TY_QINF.


TYPES: BEGIN OF TY_MAKT,
         MATNR TYPE MAKT-MATNR,
         MAKTX TYPE MAKT-MAKTX,
       END OF TY_MAKT.


TYPES: BEGIN OF TY_LFA1,
         LIFNR TYPE LFA1-LIFNR,
         NAME1 TYPE LFA1-NAME1,
       END OF TY_LFA1.



TYPES : BEGIN OF TY_FINAL,
          MATNR     TYPE QINF-MATNR,
          MAKTX     TYPE MAKT-MAKTX,
          LIEFERANT TYPE QINF-LIEFERANT,
          NAME1     TYPE LFA1-NAME1,
          WERK      TYPE QINF-WERK,
          FREI_DAT  TYPE QINF-FREI_DAT,
          NOINSP    TYPE QINF-NOINSP,
        END OF TY_FINAL.

TYPES : BEGIN OF TY_DOWN,
          MATNR     TYPE QINF-MATNR,
          MAKTX     TYPE MAKT-MAKTX,
          LIEFERANT TYPE QINF-LIEFERANT,
          NAME1     TYPE LFA1-NAME1,
          WERK      TYPE QINF-WERK,
          FREI_DAT  TYPE CHAR20,
          NOINSP    TYPE QINF-NOINSP,
          REF       TYPE CHAR15,
          TIME      TYPE CHAR10,
        END OF TY_DOWN.

DATA: IT_QINF  TYPE TABLE OF TY_QINF,
      WA_QINF  TYPE TY_QINF,


      IT_LFA1  TYPE TABLE OF TY_LFA1,
      WA_LFA1  TYPE TY_LFA1,

      IT_MAKT  TYPE TABLE OF TY_MAKT,
      WA_MAKT  TYPE TY_MAKT,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE TY_FINAL,

      IT_DOWN  TYPE TABLE OF TY_DOWN,
      WA_DOWN  TYPE  TY_DOWN.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR QINF-MATNR,
                S_WERKS FOR QINF-WERK OBLIGATORY NO INTERVALS DEFAULT 'SU01' MODIF ID BU.
*PARAMETERS :    p_werks TYPE vbap-werks DEFAULT 'US01'.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'. "'/delval/Saudi'.
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
        WERK
        LIEFERANT
        FREI_DAT
        NOINSP
        FROM QINF
        INTO TABLE IT_QINF
        WHERE WERK IN S_WERKS
        AND MATNR IN S_MATNR.



  IF IT_QINF[] IS NOT INITIAL.

    SELECT MATNR
           MAKTX
           FROM MAKT INTO TABLE IT_MAKT
           FOR ALL ENTRIES IN IT_QINF
           WHERE MATNR = IT_QINF-MATNR.

    SELECT LIFNR
           NAME1
           FROM LFA1 INTO TABLE IT_LFA1
           FOR ALL ENTRIES IN IT_QINF
           WHERE LIFNR = IT_QINF-LIEFERANT .

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


  LOOP AT IT_QINF INTO WA_QINF.
    WA_FINAL-MATNR        =  WA_QINF-MATNR.
    WA_FINAL-WERK         =  WA_QINF-WERK.
    WA_FINAL-LIEFERANT    =  WA_QINF-LIEFERANT.
    WA_FINAL-FREI_DAT     =  WA_QINF-FREI_DAT.
    WA_FINAL-NOINSP       =  WA_QINF-NOINSP.



    READ TABLE  IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_QINF-MATNR.
    WA_FINAL-MAKTX =  WA_MAKT-MAKTX.



    READ TABLE  IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_QINF-LIEFERANT.
    WA_FINAL-NAME1 = WA_LFA1-NAME1.


    APPEND WA_FINAL TO IT_FINAL.
    CLEAR: WA_FINAL.
  ENDLOOP.

    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MATNR        =  WA_FINAL-MATNR.
      WA_DOWN-WERK         =  WA_FINAL-WERK.
      WA_DOWN-LIEFERANT    =  WA_FINAL-LIEFERANT.

      WA_FINAL-FREI_DAT     =  WA_QINF-FREI_DAT.
      IF WA_FINAL-FREI_DAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-FREI_DAT
          IMPORTING
            OUTPUT = WA_DOWN-FREI_DAT.

        CONCATENATE WA_DOWN-FREI_DAT+0(2) WA_DOWN-FREI_DAT+2(3) WA_DOWN-FREI_DAT+5(4)
                        INTO WA_DOWN-FREI_DAT SEPARATED BY '-'.
      ENDIF.

      WA_DOWN-NOINSP =  WA_FINAL-NOINSP.
      WA_DOWN-MAKTX  =  WA_FINAL-MAKTX.
      WA_DOWN-NAME1  = WA_FINAL-NAME1.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.


      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO WA_DOWN-TIME SEPARATED BY ':'.


      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
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

  PERFORM FCAT USING :   '1'   'MATNR'             'IT_FINAL'      'Material'                      '20' ,
                         '2'   'MAKTX'             'IT_FINAL'      'Material Description'          '20' ,
                         '3'   'LIEFERANT'         'IT_FINAL'      'Vendor '                       '20' ,
                         '4'   'NAME1'             'IT_FINAL'      'Vendor Name'                   '20',
                         '5'   'WERK'              'IT_FINAL'      'Plant'                         '20',
                         '6'   'FREI_DAT'          'IT_FINAL'      'Release UntilL'                '20',
                         '7'   'NOINSP'            'IT_FINAL'      'INSP. CONTROL'                 '20'.


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
*      -->P_0426   text
*      -->P_0427   text
*      -->P_0428   text
*      -->P_0429   text
*      -->P_0430   text
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
*wa_fcat-key       = .
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


  LV_FILE = 'ZSU_QA_INFO.TXT'.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_QA_INFO REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_401 TYPE string.
DATA lv_crlf_401 TYPE string.
lv_crlf_401 = cl_abap_char_utilities=>cr_lf.
lv_string_401 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_401 lv_crlf_401 wa_csv INTO lv_string_401.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_401 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


*********************************************SQL UPLOAD FILE *****************************************
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


  LV_FILE = 'ZSU_QA_INFO.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_QA_INFO REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_441 TYPE string.
DATA lv_crlf_441 TYPE string.
lv_crlf_441 = cl_abap_char_utilities=>cr_lf.
lv_string_441 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_441 lv_crlf_441 wa_csv INTO lv_string_441.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_441 TO lv_fullfile.
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
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE  'Material'
               'Material Description'
               'Vendor '
               'Vendor Name'
               'Plant'
               'Release UntilL'
               'INSP. CONTROL'
               'Refresh Date'
               'Refresh Time'

               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
