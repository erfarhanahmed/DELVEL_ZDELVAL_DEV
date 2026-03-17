*&---------------------------------------------------------------------*
*& Report ZPO_TYPE_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPO_TYPE_REPORT.


TABLES:MARA,EKPO.

TYPES: BEGIN OF TY_MARA,
         MATNR TYPE MARA-MATNR,
         MTART TYPE MARA-MTART,
         WERKS TYPE MARC-WERKS,
       END OF TY_MARA,



       BEGIN OF TY_DATA,
         EBELN TYPE EKKO-EBELN,
         LIFNR TYPE EKKO-LIFNR,
         AEDAT TYPE EKKO-AEDAT,
         BUKRS TYPE EKKO-BUKRS,
         FRGKE TYPE EKKO-FRGKE,
         EBELP TYPE EKPO-EBELP,
         MATNR TYPE EKPO-MATNR,
         WERKS TYPE EKPO-WERKS,
         ELIKZ TYPE EKPO-ELIKZ,
         LOEKZ TYPE EKPO-LOEKZ,
         PSTYP TYPE EKPO-PSTYP,
         RETPO TYPE EKPO-RETPO,
       END OF TY_DATA,


       BEGIN OF TY_FINAL,
         MATNR  TYPE MARA-MATNR,
         MTART  TYPE MARA-MTART,
         SUBCON TYPE CHAR5,
         OTHER  TYPE CHAR5,
       END OF TY_FINAL,

       BEGIN OF TY_DOWN,
         MATNR  TYPE MARA-MATNR,
         MTART  TYPE MARA-MTART,
         SUBCON TYPE CHAR5,
         OTHER  TYPE CHAR5,
         REF    TYPE CHAR11,
       END OF TY_DOWN.

DATA : IT_MARA  TYPE TABLE OF TY_MARA,
       WA_MARA  TYPE          TY_MARA,

       IT_DATA  TYPE TABLE OF TY_DATA,
       WA_DATA  TYPE          TY_DATA,

       IT_SUBCON  TYPE TABLE OF TY_DATA,
       WA_SUBCON  TYPE          TY_DATA,

       IT_OTHER  TYPE TABLE OF TY_DATA,
       WA_OTHER  TYPE          TY_DATA,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,

       IT_DOWN  TYPE TABLE OF TY_DOWN,
       WA_DOWN  TYPE          TY_DOWN.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MARA-MATNR,
                S_WERKS FOR EKPO-WERKS OBLIGATORY DEFAULT 'PL01',
                S_MTART FOR MARA-MTART.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'. "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.


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
  SELECT A~MATNR
         A~MTART
         B~WERKS INTO TABLE IT_MARA FROM MARA AS A
         INNER JOIN MARC AS B ON B~MATNR = A~MATNR
         WHERE A~MATNR IN S_MATNR
           AND A~MTART IN S_MTART
           AND B~WERKS IN S_WERKS.

  IF IT_MARA IS NOT INITIAL .
    SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'.

        SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'.



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
  LOOP AT IT_MARA INTO WA_MARA.
    WA_FINAL-MATNR = WA_MARA-MATNR.
    WA_FINAL-MTART = WA_MARA-MTART.

    READ TABLE IT_SUBCON INTO WA_SUBCON WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON = 'YES'.
    ELSE.
      WA_FINAL-SUBCON = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER INTO WA_OTHER WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER = 'YES'.
    ELSE.
      WA_FINAL-OTHER = 'NO'.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR:WA_FINAL,WA_MARA,WA_DATA.
  ENDLOOP.


  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MATNR = WA_FINAL-MATNR.
      WA_DOWN-MTART = WA_FINAL-MTART.
      WA_DOWN-SUBCON = WA_FINAL-SUBCON.
      WA_DOWN-OTHER = WA_FINAL-OTHER.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.


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
FORM GET_FCAT .
  PERFORM FCAT USING : '1'   'MATNR'           'IT_FINAL'      'Material'                     '20' ,
                       '2'   'MTART'           'IT_FINAL'      'Material Type'                '10' ,
                       '3'   'SUBCON'          'IT_FINAL'      'Subcontracting Purchase'      '20' ,
                       '3'   'OTHER'           'IT_FINAL'      'Other Purchase'               '20' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0432   text
*      -->P_0433   text
*      -->P_0434   text
*      -->P_0435   text
*      -->P_0436   text
*----------------------------------------------------------------------*
FORM FCAT USING    VALUE(P1)
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


  LV_FILE = 'ZPO_TYPE.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPO_TYPE REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_386 TYPE string.
DATA lv_crlf_386 TYPE string.
lv_crlf_386 = cl_abap_char_utilities=>cr_lf.
lv_string_386 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_386 lv_crlf_386 wa_csv INTO lv_string_386.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1323 TO lv_fullfile.
TRANSFER lv_string_386 TO lv_fullfile.
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


  LV_FILE = 'ZPO_TYPE.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPO_TYPE REPORT started on', SY-DATUM, 'at', SY-UZEIT.
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
*TRANSFER lv_string_1323 TO lv_fullfile.
TRANSFER lv_string_424 TO lv_fullfile.
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
  CONCATENATE 'Material'
              'Material Type'
              'Subcontracting Purchase'
              'Other Purchase'
              'Refresh Date'

              INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
