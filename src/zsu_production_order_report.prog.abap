*&---------------------------------------------------------------------*
*&Report: ZSU_PRODUCTION_ORDER_REPORT
*&Transaction: ZSU_ORDER_DETAIL
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 04.11.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*& Report ZPRODUCTION_ORDER_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_PRODUCTION_ORDER_REPORT.

TABLES:AFPO.

TYPES: BEGIN OF TY_AFPO,
         AUFNR  TYPE AFPO-AUFNR,
         POSNR  TYPE AFPO-POSNR,
         KDAUF  TYPE AFPO-KDAUF,
         KDPOS  TYPE AFPO-KDPOS,
         PSMNG  TYPE AFPO-PSMNG,
         WEMNG  TYPE AFPO-WEMNG,
         MATNR  TYPE AFPO-MATNR,
         ELIKZ  TYPE AFPO-ELIKZ,
         DWERK  TYPE AFPO-DWERK,
         DAUAT  TYPE AFPO-DAUAT,
         KUNNR2 TYPE AFPO-KUNNR2,
         DNREL  TYPE AFPO-DNREL,
       END OF TY_AFPO,

       BEGIN OF TY_CAUFV,
         AUFNR TYPE AFKO-AUFNR,
         ERDAT TYPE CAUFV-ERDAT,
       END OF TY_CAUFV,

       BEGIN OF TY_VBAK,
         VBELN TYPE VBAK-VBELN,
         KUNNR TYPE VBAK-KUNNR,
       END OF TY_VBAK,

       BEGIN OF TY_FINAL,
         AUFNR    TYPE AFPO-AUFNR,
         POSNR    TYPE AFPO-POSNR,
         KDAUF    TYPE AFPO-KDAUF,
         KDPOS    TYPE AFPO-KDPOS,
         PSMNG    TYPE AFPO-PSMNG,
         WEMNG    TYPE AFPO-WEMNG,
         MATNR    TYPE AFPO-MATNR,
         ELIKZ    TYPE AFPO-ELIKZ,
         DWERK    TYPE AFPO-DWERK,
         DAUAT    TYPE AFPO-DAUAT,
         KUNNR    TYPE KNA1-KUNNR,
         PEN_QTY  TYPE AFPO-PSMNG,
         MATTXT   TYPE CHAR255,
         ERDAT    TYPE CAUFV-ERDAT,
         NAME     TYPE KNA1-NAME1,
         V_POSNR  TYPE VBAP-POSNR, "added by pj
         REF_TIME TYPE CHAR10,          " ADDED by PJ on 09-09-21
       END OF TY_FINAL,

       BEGIN OF TY_DOWN,
         KUNNR    TYPE CHAR20,
         NAME     TYPE CHAR20,
         DAUAT    TYPE CHAR15,
         AUFNR    TYPE CHAR20,
         ERDAT    TYPE CHAR15,
         KDAUF    TYPE CHAR20,
*         MATNR    TYPE CHAR20,
         MATNR    TYPE CHAR40,
         MATTXT   TYPE CHAR255,
         PSMNG    TYPE CHAR15,
         WEMNG    TYPE CHAR15,
         PEN_QTY  TYPE CHAR15,
         REF      TYPE CHAR15,
         V_POSNR  TYPE CHAR15,    " by PJ.09-09-21
         REF_TIME TYPE CHAR10,          " ADDED by PJ on 09-09-21
       END OF TY_DOWN.

DATA : IT_AFPO  TYPE TABLE OF TY_AFPO,
       WA_AFPO  TYPE          TY_AFPO,

       IT_CAUFV TYPE TABLE OF TY_CAUFV,
       WA_CAUFV TYPE          TY_CAUFV,

       IT_VBAK  TYPE TABLE OF TY_VBAK,
       WA_VBAK  TYPE          TY_VBAK,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,

       IT_DOWN  TYPE TABLE OF TY_DOWN,
       WA_DOWN  TYPE          TY_DOWN.


DATA: IT_FCAT   TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT   LIKE LINE OF IT_FCAT,

      FS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.

DATA : V_POSNR TYPE VBAP-POSNR. "added BY PJ

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_AUFNR FOR AFPO-AUFNR,
                S_KDAUF FOR AFPO-KDAUF,
                S_DAUAT FOR AFPO-DAUAT,
                P_DWERK FOR AFPO-DWERK OBLIGATORY  DEFAULT 'SU01' MODIF ID BU.
*                  p_elikz TYPE afpo-elikz.

SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'. "'E:/delval/Saudi'
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT.
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
  PERFORM FILL_LAYOUT.
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

  SELECT AUFNR
         POSNR
         KDAUF
         KDPOS
         PSMNG
         WEMNG
         MATNR
         ELIKZ
         DWERK
         DAUAT
         KUNNR2
         DNREL FROM AFPO INTO TABLE IT_AFPO
         WHERE AUFNR IN S_AUFNR
           AND KDAUF IN S_KDAUF
           AND DAUAT IN S_DAUAT
*         AND elikz = p_elikz
           AND DWERK IN P_DWERK
           AND ELIKZ = ' '
           AND DNREL NE 'X'.

  IF IT_AFPO IS NOT INITIAL .
    SELECT AUFNR
           ERDAT FROM CAUFV INTO TABLE IT_CAUFV
           FOR ALL ENTRIES IN IT_AFPO
           WHERE AUFNR = IT_AFPO-AUFNR.

    SELECT VBELN
           KUNNR FROM VBAK INTO TABLE IT_VBAK
           FOR ALL ENTRIES IN IT_AFPO
           WHERE VBELN = IT_AFPO-KDAUF.

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
  LOOP AT IT_AFPO INTO WA_AFPO.
    WA_FINAL-AUFNR = WA_AFPO-AUFNR.
    WA_FINAL-POSNR = WA_AFPO-POSNR.
    WA_FINAL-KDAUF = WA_AFPO-KDAUF.
    WA_FINAL-KDPOS = WA_AFPO-KDPOS.
    WA_FINAL-PSMNG = WA_AFPO-PSMNG.
    WA_FINAL-WEMNG = WA_AFPO-WEMNG.
    WA_FINAL-MATNR = WA_AFPO-MATNR.
    WA_FINAL-ELIKZ = WA_AFPO-ELIKZ.
    WA_FINAL-DWERK = WA_AFPO-DWERK.
    WA_FINAL-DAUAT = WA_AFPO-DAUAT.


    WA_FINAL-PEN_QTY = WA_FINAL-PSMNG - WA_FINAL-WEMNG.


    READ TABLE IT_CAUFV INTO WA_CAUFV WITH KEY AUFNR = WA_FINAL-AUFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-ERDAT = WA_CAUFV-ERDAT.
    ENDIF.

    READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_FINAL-KDAUF.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_VBAK-KUNNR.

      SELECT SINGLE POSNR FROM VBAP INTO V_POSNR WHERE MATNR = WA_AFPO-MATNR "added BY PJ
                                                    AND VBELN = WA_VBAK-VBELN.
      IF SY-SUBRC = 0.
        WA_FINAL-V_POSNR = V_POSNR.

      ENDIF.

    ENDIF.

    SELECT SINGLE NAME1 INTO WA_FINAL-NAME FROM KNA1 WHERE KUNNR = WA_FINAL-KUNNR.


    CLEAR: LV_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LV_LINES
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-MATTXT WA_LINES-TDLINE INTO WA_FINAL-MATTXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-MATTXT.
    ENDIF.
************        edited by PJ on 09-09-21

    WA_FINAL-REF_TIME = SY-UZEIT.

*BREAK PRIMUS.
    CONCATENATE WA_FINAL-REF_TIME+0(2) ':' WA_FINAL-REF_TIME+2(2)  INTO WA_FINAL-REF_TIME.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-KUNNR   = WA_FINAL-KUNNR  .
      WA_DOWN-NAME    = WA_FINAL-NAME   .
      WA_DOWN-DAUAT   = WA_FINAL-DAUAT  .
      WA_DOWN-AUFNR   = WA_FINAL-AUFNR  .
      WA_DOWN-ERDAT   = WA_FINAL-ERDAT  .
      WA_DOWN-KDAUF   = WA_FINAL-KDAUF  .
      WA_DOWN-MATNR   = WA_FINAL-MATNR  .
      WA_DOWN-MATTXT  = WA_FINAL-MATTXT .
      WA_DOWN-PSMNG   = WA_FINAL-PSMNG  .
      WA_DOWN-WEMNG   = WA_FINAL-WEMNG  .
      WA_DOWN-PEN_QTY = WA_FINAL-PEN_QTY.


      IF WA_FINAL-ERDAT IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-ERDAT
          IMPORTING
            OUTPUT = WA_DOWN-ERDAT.

        CONCATENATE WA_DOWN-ERDAT+0(2) WA_DOWN-ERDAT+2(3) WA_DOWN-ERDAT+5(4)
                        INTO WA_DOWN-ERDAT SEPARATED BY '-'.

      ENDIF.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.
********"added BY PJ*********

      IF WA_FINAL-V_POSNR IS NOT INITIAL .
        WA_DOWN-V_POSNR = WA_FINAL-V_POSNR. "added BY PJ
      ELSE.
        WA_DOWN-V_POSNR = ''.
      ENDIF.
      WA_DOWN-REF_TIME = WA_FINAL-REF_TIME.
********END***************
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

  PERFORM FCAT USING :
                       '1'  'KUNNR'            'IT_FINAL'  'Customer'                        '18' ,
                       '2'  'NAME'             'IT_FINAL'  'Customer Name'                   '18' ,
                       '3'  'DAUAT'            'IT_FINAL'  'Production Ord.Type'             '18',
                       '4'  'AUFNR'            'IT_FINAL'  'Production Order No'             '18' ,
                       '5'  'ERDAT'            'IT_FINAL'  'Prod.Ord Date'                   '18' ,
                       '6'  'KDAUF'            'IT_FINAL'  'Sales Order'                     '18' ,
                       '7'  'MATNR'            'IT_FINAL'  'Item Code'                       '18' ,
                       '8'  'MATTXT'           'IT_FINAL'  'Description'                     '20' ,
                       '9'  'PSMNG'            'IT_FINAL'  'Order Qty.'                      '18' ,
                      '10'  'WEMNG'            'IT_FINAL'  'Confirm Qty.'                    '18' ,
                      '11'  'PEN_QTY'          'IT_FINAL'  'Pending Qty.'                    '18' ,
                      '12'  'V_POSNR'          'IT_FINAL'  'Sales Doc. Position'                    '18',"added BY PJ
                      '12'  'REF_TIME'          'IT_FINAL'  'Ref. Time'                    '18'. "added BY PJ
*                    '12'  'ELIKZ'            'IT_FINAL'  'Delivery Indicator'              '18' .
*                     '4'  'POSNR'            'IT_FINAL'  'Prod.Ord.line Itm'               '18' ,
*                     '5'  'KDPOS'            'IT_FINAL'  'Sales Order'                     '18' ,
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_LAYOUT .
  FS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  FS_LAYOUT-ZEBRA             = 'X'.
  FS_LAYOUT-DETAIL_POPUP      = 'X'.
  FS_LAYOUT-SUBTOTALS_TEXT    = 'DR'.
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
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      I_CALLBACK_PROGRAM      = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'USER_CMD'
      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       =
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      IS_LAYOUT               = FS_LAYOUT
      IT_FIELDCAT             = IT_FCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      I_SAVE                  = 'X'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      T_OUTTAB                = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
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
*      -->P_0318   text
*      -->P_0319   text
*      -->P_0320   text
*      -->P_0321   text
*      -->P_0322   text
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
*&      Form  top-of-page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM TOP-OF-PAGE.

*  ALV Header declarations
  DATA: T_HEADER      TYPE SLIS_T_LISTHEADER,
        WA_HEADER     TYPE SLIS_LISTHEADER,
        T_LINE        LIKE WA_HEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

*  Title
  WA_HEADER-TYP  = 'H'.
  WA_HEADER-INFO = 'Production Order Detail Report(Saudi)'.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR WA_HEADER.



*  Date
  WA_HEADER-TYP  = 'S'.
  WA_HEADER-KEY  = 'Run Date : '.
  CONCATENATE WA_HEADER-INFO SY-DATUM+6(2) '.' SY-DATUM+4(2) '.'
                      SY-DATUM(4) INTO WA_HEADER-INFO.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

*  Time
  WA_HEADER-TYP  = 'S'.
  WA_HEADER-KEY  = 'Run Time: '.
  CONCATENATE WA_HEADER-INFO SY-TIMLO(2) ':' SY-TIMLO+2(2) ':'
                      SY-TIMLO+4(2) INTO WA_HEADER-INFO.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

*   Total No. of Records Selected
  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.

  CONCATENATE 'Total No. of Records Selected: ' LD_LINESC
     INTO T_LINE SEPARATED BY SPACE.

  WA_HEADER-TYP  = 'A'.
  WA_HEADER-INFO = T_LINE.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER, T_LINE.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER.
ENDFORM.                    " top-of-page
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


  LV_FILE = 'ZSU_ORDER_DETAIL.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PRODUCTION ORDER DETAIL REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_574 TYPE string.
DATA lv_crlf_574 TYPE string.
lv_crlf_574 = cl_abap_char_utilities=>cr_lf.
lv_string_574 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_574 lv_crlf_574 wa_csv INTO lv_string_574.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_574 TO lv_fullfile.
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
  CONCATENATE 'Customer'
              'Customer Name'
              'Production Ord.Type'
              'Production Order No'
              'Prod.Ord Date'
              'Sales Order'
              'Item Code'
              'Description'
              'Order Qty.'
              'Confirm Qty.'
              'Pending Qty.'
              'Refresh Date'
              'Sales Doc. Position' "added BY PJ
              'Ref. Time'"added BY PJ
               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
