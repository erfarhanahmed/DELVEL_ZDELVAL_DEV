*&---------------------------------------------------------------------*
*&Report: ZSU_CUSTOMER_INFO_RECORD
*&Transaction:  ZSU_CUST_INFO
*&Functional Cosultant: Tejswini Kapadnis
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZCUSTOMER_INFO_RECORD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_CUSTOMER_INFO_RECORD.


TABLES:KNMT.

TYPES : BEGIN OF TY_KNMT,
          VKORG TYPE KNMT-VKORG,
          VTWEG TYPE KNMT-VTWEG,
          KUNNR TYPE KNMT-KUNNR,
          MATNR TYPE KNMT-MATNR,
          ERNAM TYPE KNMT-ERNAM,
          ERDAT TYPE KNMT-ERDAT,
          KDMAT TYPE KNMT-KDMAT,
        END OF TY_KNMT,

        BEGIN OF TY_FINAL,
          VKORG TYPE CHAR10,
          VTWEG TYPE CHAR10,
          KUNNR TYPE CHAR10,
          MATNR TYPE CHAR20,
          ERNAM TYPE CHAR15,
          ERDAT TYPE CHAR15,
          KDMAT TYPE CHAR50,
          REF   TYPE CHAR15,
         ref_time type char20,


        END OF TY_FINAL.

DATA : IT_KNMT  TYPE TABLE OF TY_KNMT,
       WA_KNMT  TYPE          TY_KNMT,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.


SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : S_KUNNR FOR KNMT-KUNNR,
                 S_MATNR FOR KNMT-MATNR.
PARAMETERS : P_VKORG LIKE KNMT-VKORG OBLIGATORY DEFAULT 'SU00'. ".NO INTERVALS MODIF ID BU.
SELECTION-SCREEN : END OF BLOCK B1.


SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'. "'/delval/Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
   " IF SCREEN-GROUP1 = 'BU'.
    "  SCREEN-INPUT = '0'.
      IF SCREEN-name = 'P_VKORG'.
       screen-input = '0'.
      MODIFY SCREEN.
    "ENDIF.
    endif.
  ENDLOOP.

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
  SELECT VKORG
         VTWEG
         KUNNR
         MATNR
         ERNAM
         ERDAT
         KDMAT FROM KNMT INTO TABLE IT_KNMT
         WHERE KUNNR IN S_KUNNR
           AND MATNR IN S_MATNR
  AND VKORG = 'SU00'.


  LOOP AT IT_KNMT INTO WA_KNMT.
    WA_FINAL-VKORG = WA_KNMT-VKORG.
    WA_FINAL-VTWEG = WA_KNMT-VTWEG.
    WA_FINAL-KUNNR = WA_KNMT-KUNNR.
    WA_FINAL-MATNR = WA_KNMT-MATNR.
    WA_FINAL-ERNAM = WA_KNMT-ERNAM.
    WA_FINAL-ERDAT = WA_KNMT-ERDAT.
    WA_FINAL-KDMAT = WA_KNMT-KDMAT.


    IF WA_KNMT-ERDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_KNMT-ERDAT
        IMPORTING
          OUTPUT = WA_FINAL-ERDAT.

      CONCATENATE WA_FINAL-ERDAT+0(2) WA_FINAL-ERDAT+2(3) WA_FINAL-ERDAT+5(4)
                      INTO WA_FINAL-ERDAT SEPARATED BY '-'.
    ENDIF.




    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_FINAL-REF.

    CONCATENATE WA_FINAL-REF+0(2) WA_FINAL-REF+2(3) WA_FINAL-REF+5(4)
                    INTO WA_FINAL-REF SEPARATED BY '-'.



     wa_final-ref_time = sy-uzeit.
    CONCATENATE wa_final-ref_time+0(2) ':' wa_final-ref_time+2(2)  INTO wa_final-ref_time.



    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.


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
  PERFORM FCAT USING : '1'   'VKORG'           'IT_FINAL'      'Sales Organization'          '20' ,
                       '2'   'VTWEG'           'IT_FINAL'      'Distribution Channel'        '20' ,
                       '3'   'KUNNR'           'IT_FINAL'      'Customer number'             '20' ,
                       '4'   'MATNR'           'IT_FINAL'      'Material Number'             '20' ,
                       '5'   'ERNAM'           'IT_FINAL'      'Created By'                  '20' ,
                       '6'   'ERDAT'           'IT_FINAL'      'Created Date'                '20' ,
                       '7'   'KDMAT'           'IT_FINAL'      'Customer Material'           '20' .
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
*      -->P_1083   text
*      -->P_1084   text
*      -->P_1085   text
*      -->P_1086   text
*      -->P_1087   text
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
      I_TAB_SAP_DATA       = IT_FINAL
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


  LV_FILE = 'ZSU_CUSTOMER_INFO_RECORD.TXT'.


*  CONCATENATE P_FOLDER '\'  LV_FILE
  CONCATENATE P_FOLDER '/'  LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_CUSTOMER_INFO_RECORD REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_321 TYPE string.
DATA lv_crlf_321 TYPE string.
lv_crlf_321 = cl_abap_char_utilities=>cr_lf.
lv_string_321 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_321 lv_crlf_321 wa_csv INTO lv_string_321.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_321 TO lv_fullfile.
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
  CONCATENATE 'Sales Organization'
              'Distribution Channel'
              'Customer number'
              'Material Number'
              'Created By'
              'Created Date'
              'Customer Material'
              'Refresh Date'
              'Refresh Time'

                INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
