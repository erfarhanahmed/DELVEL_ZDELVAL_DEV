*&---------------------------------------------------------------------*
*& Report ZUSER_AUTHORIZATION_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUSER_AUTHORIZATION_REPORT.

TABLES :AGR_USERS.


TYPES: BEGIN OF ty_users,
       AGR_NAME TYPE agr_users-AGR_NAME,
       UNAME    TYPE agr_users-UNAME,
       FROM_DAT TYPE agr_users-FROM_DAT,
       TO_DAT   TYPE agr_users-TO_DAT  ,
       EXCLUDE  TYPE agr_users-EXCLUDE ,
       END OF ty_users,

       BEGIN OF ty_tcode,
       AGR_NAME  TYPE AGR_TCODES-AGR_NAME ,
       TYPE      TYPE AGR_TCODES-TYPE     ,
       TCODE     TYPE AGR_TCODES-TCODE    ,
       EXCLUDE   TYPE AGR_TCODES-EXCLUDE  ,
       DIRECT    TYPE AGR_TCODES-DIRECT   ,
       INHERITED TYPE AGR_TCODES-INHERITED,
       FOLDER    TYPE AGR_TCODES-FOLDER   ,
       END OF ty_tcode,


       BEGIN OF ty_ucode,
       AGR_NAME TYPE agr_users-AGR_NAME,
       UNAME    TYPE agr_users-UNAME,
       TYPE      TYPE AGR_TCODES-TYPE     ,
       TCODE     TYPE AGR_TCODES-TCODE    ,
       END OF ty_ucode,

       BEGIN OF ty_final,
       UNAME    TYPE agr_users-UNAME,
       role     TYPE agr_users-AGR_NAME,
       TCODE    TYPE AGR_TCODES-TCODE    ,

       END OF ty_final,

       BEGIN OF ty_down,
       uname TYPE char15,
       role  TYPE char50,
       tcode TYPE char50,
       ref   TYPE char15,
       END OF ty_down.


DATA : it_users  TYPE TABLE OF ty_users,
       wa_users  TYPE          ty_users,

       it_tcode  TYPE TABLE OF ty_tcode,
       wa_tcode  TYPE          ty_tcode,

       it_ucode  TYPE TABLE OF ty_ucode,
       wa_ucode  TYPE          ty_ucode,

       it_final  TYPE TABLE OF ty_final,
       wa_final  TYPE          ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.


DATA : IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
       WA_FCAT LIKE LINE OF IT_FCAT.
DATA : FS_LAYOUT TYPE SLIS_LAYOUT_ALV.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  select-OPTIONS : user FOR agr_users-UNAME.
SELECTION-SCREEN:END OF BLOCK b1 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'."'E:/delval/temp125'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
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
FORM GET_DATA .

*SELECT AGR_NAME
*       UNAME
*       FROM_DAT
*       TO_DAT
*       EXCLUDE  FROM agr_users INTO TABLE it_users
*       WHERE UNAME IN user.

SELECT a~AGR_NAME
       a~UNAME
       b~TYPE
       b~TCODE  FROM agr_users AS a
       INNER JOIN agr_tcodes AS b
       ON a~AGR_NAME = b~AGR_NAME
       INTO TABLE it_ucode
       WHERE uname IN user.


SORT it_ucode BY uname.
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
LOOP AT it_ucode INTO wa_ucode.
  wa_final-UNAME = wa_ucode-UNAME.
  wa_final-role  = wa_ucode-AGR_NAME.
  wa_final-TCODE = wa_ucode-TCODE  .


APPEND wa_final TO it_final.
CLEAR wa_final.
ENDLOOP.

IF P_DOWN = 'X'.
LOOP AT it_final INTO wa_final.
wa_down-UNAME  = wa_final-UNAME.
wa_down-role   = wa_final-role .
wa_down-TCODE  = wa_final-TCODE.

CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

APPEND wa_down TO it_down.
CLEAR wa_down.
ENDLOOP .
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
 PERFORM FCAT USING :
                       '1'  'UNAME'         'IT_FINAL'  'User'            '18'  'C110' ,
                       '2'  'ROLE'          'IT_FINAL'  'Role'                '18'  ' ' ,
                       '3'  'TCODE'         'IT_FINAL'  'Transaction'          '18'  ' ' .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0266   text
*      -->P_0267   text
*      -->P_0268   text
*      -->P_0269   text
*      -->P_0270   text
*      -->P_0271   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5)
                    VALUE(P6).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*  wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.
  WA_FCAT-EMPHASIZE   = P6.

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
        I_CALLBACK_PROGRAM     = SY-REPID
*       IS_LAYOUT              = LAYOUT
        I_HTML_HEIGHT_TOP      = 27
        I_CALLBACK_TOP_OF_PAGE = 'TOP_PAGE'
*       I_BACKGROUND_ID        = 'ALV_BACKGROUND'
        IT_FIELDCAT            = IT_FCAT
        I_SAVE                 = 'A'
      TABLES
        T_OUTTAB               = IT_FINAL
      EXCEPTIONS
        PROGRAM_ERROR          = 1
        OTHERS                 = 2.
    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


 IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.

 ENDIF.


ENDFORM.

FORM TOP_PAGE.

  DATA: T_HEADER      TYPE SLIS_T_LISTHEADER,
        WA_HEADER     TYPE SLIS_LISTHEADER,
        T_LINE        LIKE WA_HEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C,
        NAME          TYPE STRING.

  WA_HEADER-TYP  = 'H'.
  WA_HEADER-INFO = 'USER Authorization Report'.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR WA_HEADER.


  DATA : SDATE TYPE STRING .
  DATA : EDATE TYPE STRING.
  DATA : STD TYPE STRING.
  DATA : LV_DATE TYPE STRING.
  DATA : LV_TIME TYPE STRING.



  CONCATENATE  SY-UZEIT+0(2) SY-UZEIT+2(2) SY-UZEIT+4(2) INTO LV_TIME SEPARATED BY ':'.
  WA_HEADER-TYP   = 'S'.
  WA_HEADER-KEY   = 'CURRANT TIME :'.
  WA_HEADER-INFO  = LV_TIME.

  APPEND WA_HEADER TO T_HEADER.
  CLEAR WA_HEADER.


  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = SY-DATUM
    IMPORTING
      OUTPUT = STD.

  CONCATENATE  STD+0(2) STD+2(3) STD+5(4) INTO STD SEPARATED BY '-'.
  WA_HEADER-TYP   = 'S'.
  WA_HEADER-KEY   = 'CURRANT DATE :'.
  WA_HEADER-INFO  = STD.

  APPEND WA_HEADER TO T_HEADER.
  CLEAR WA_HEADER.

  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.

  WA_HEADER-TYP  = 'S'.
  WA_HEADER-KEY   = 'TOTAL RECORDS :'.
  WA_HEADER-INFO = LD_LINESC .
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER, T_LINE.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
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
      I_TAB_SAP_DATA       = it_final
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER1 USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZUSER_RIGHTS.TXT'.


  CONCATENATE P_FOLDER '/' sy-datum sy-uzeit lv_file
    INTO LV_FULLFILE.

  WRITE: / 'ZUSER_RIGHTS REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

*************************************SQL Upload File*****************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = it_down
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


  LV_FILE = 'ZUSER_RIGHTS.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUSER_RIGHTS REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
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
FORM CVS_HEADER   USING    PD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'User Name'
              'Role'
              'Transaction Code'
              'Refresh Date'
               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER1  USING    PD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'User Name'
              'Role'
              'Transaction Code'

               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
