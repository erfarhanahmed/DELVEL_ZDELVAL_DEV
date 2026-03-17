*&---------------------------------------------------------------------*
*&Report: ZSU_PO_AUTHORIZATION
*&Transaction: ZSU_PO_AUTHORIZATION
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZPO_AUTHORIZATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_PO_AUTHORIZATION.

TABLES : EKKO,EKPO,CDHDR.

TYPES : BEGIN OF TY_CDHDR,
          OBJECTCLAS TYPE CDHDR-OBJECTCLAS,
          OBJECTID   TYPE CDHDR-OBJECTID,
          CHANGENR   TYPE CDHDR-CHANGENR,
          USERNAME   TYPE CDHDR-USERNAME,
          UDATE      TYPE CDHDR-UDATE,
          UTIME      TYPE CDHDR-UTIME,
          TCODE      TYPE CDHDR-TCODE,
        END OF TY_CDHDR,

        BEGIN OF TY_EKKO,
          EBELN TYPE CDHDR-OBJECTID,
          AEDAT TYPE EKKO-AEDAT,
          LIFNR TYPE EKKO-LIFNR,
          EKORG TYPE EKKO-EKORG,
          WAERS TYPE EKKO-WAERS,
          BEDAT TYPE EKKO-BEDAT,
          RLWRT TYPE ekko-RLWRT,
        END OF TY_EKKO,
        BEGIN OF TY_LFA1,
          LIFNR2 TYPE LFA1-LIFNR,
          ADRNR  TYPE LFA1-ADRNR,

        END OF TY_LFA1,

        BEGIN OF TY_ADRC,
          ADDRNUMBER TYPE ADRC-ADDRNUMBER,
          NAME1      TYPE ADRC-NAME1,

        END OF TY_ADRC,

        BEGIN OF TY_EKPO,
          EBELN TYPE EKPO-EBELN,
          EBELP TYPE EKPO-EBELP,
          LOEKZ TYPE EKPO-LOEKZ,
        END OF TY_EKPO,

        BEGIN OF TY_FINAL,
          OBJECTID TYPE CDHDR-OBJECTID,
          USERNAME TYPE CDHDR-USERNAME,
          UDATE    TYPE CHAR20,
          UTIME    TYPE CDHDR-UTIME,
          TCODE    TYPE CDHDR-TCODE,
          DLT      TYPE CHAR1,
          EBELN    TYPE EKPO-EBELN,
          EBELP    TYPE EKPO-EBELP,
          BEDAT    TYPE CHAR18,
          LIFNR    TYPE EKKO-LIFNR,
          NAME1    TYPE ADRC-NAME1,
          EKORG    TYPE EKKO-EKORG,
          WAERS    TYPE EKKO-WAERS,
          PONETAMT TYPE STRING,
        END OF TY_FINAL,

        BEGIN OF TY_DOWN,
          OBJECTID TYPE CDHDR-OBJECTID,
          USERNAME TYPE CDHDR-USERNAME,
          UDATE    TYPE CHAR20,
          UTIME    TYPE CHAR18,
          TCODE    TYPE CDHDR-TCODE,
          DLT      TYPE CHAR1,
          BEDAT    TYPE CHAR15,
          LIFNR    TYPE EKKO-LIFNR,
          NAME1    TYPE ADRC-NAME1,
          REF_DAT  TYPE CHAR15,  "Refresh Date
          REF_TIME TYPE CHAR15,  "Refresh Time
          EKORG    TYPE EKKO-EKORG,
          PONETAMT TYPE STRING,
          WAERS    TYPE EKKO-WAERS,
        END OF TY_DOWN.


DATA : BEGIN OF LT_TEMP OCCURS 0,
         EBELN1 TYPE CDHDR-OBJECTID,
       END OF LT_TEMP.

DATA : LT_CDHDR TYPE TABLE OF TY_CDHDR,
       LS_CDHDR TYPE          TY_CDHDR,

       LT_EKKO  TYPE TABLE OF TY_EKKO,
       LS_EKKO  TYPE          TY_EKKO,

       LT_EKPO  TYPE TABLE OF TY_EKPO,
       LS_EKPO  TYPE          TY_EKPO,

       LT_LFA1  TYPE TABLE OF TY_LFA1,
       LS_LFA1  TYPE          TY_LFA1,

       LT_ADRC  TYPE TABLE OF TY_ADRC,
       LS_ADRC  TYPE  TY_ADRC,

       LS_TEMP  LIKE LINE OF LT_TEMP,

       LT_FINAL TYPE TABLE OF TY_FINAL,
       LS_FINAL TYPE          TY_FINAL,

       LT_DOWN  TYPE TABLE OF TY_DOWN,
       LS_DOWN  TYPE          TY_DOWN.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.

DATA : LS_LAYOUT TYPE SLIS_LAYOUT_ALV.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : S_DAT  FOR EKKO-AEDAT,
                 S_VEN  FOR EKKO-LIFNR,
                 S_ORG  FOR EKKO-EKORG OBLIGATORY MODIF ID BU  NO INTERVALS .
*PARAMETERS     : p_org TYPE ekko-ekorg OBLIGATORY  MODIF ID BU.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'."Saudi'. "'/Delval/Saudi'."Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

AT SELECTION-SCREEN OUTPUT.
LOOP AT SCREEN.
  IF SCREEN-GROUP1 = 'BU'.
    SCREEN-INPUT = '0'.
    MODIFY SCREEN.
  ENDIF.
ENDLOOP.


INITIALIZATION.
s_ORG-sign = 'I'.
s_ORG-option = 'EQ' .
s_ORG-low = 'SUIM'.
APPEND s_ORG .

s_ORG-low = 'SUDM'.
APPEND s_ORG.
At SELECTION-SCREEN ON S_ORG.
IF S_ORG-LOW NE 'SUIM'.

  MESSAGE 'ENTER CORRECT Purchase ORGANISATION' TYPE 'E' DISPLAY LIKE 'E'.

ENDIF.

START-OF-SELECTION.

  PERFORM GET_DATA.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT EBELN
         AEDAT
         LIFNR
         EKORG
         WAERS
         BEDAT
         RLWRT
    FROM EKKO
    INTO TABLE LT_EKKO
    WHERE AEDAT IN S_DAT AND
          EKORG IN S_ORG
    AND   LIFNR IN S_VEN.



  SELECT LIFNR ADRNR FROM LFA1
    INTO TABLE LT_LFA1
    FOR ALL ENTRIES IN LT_EKKO
    WHERE LIFNR = LT_EKKO-LIFNR.

  SELECT ADDRNUMBER
         NAME1
    FROM ADRC
    INTO TABLE LT_ADRC
    FOR ALL ENTRIES IN LT_LFA1
    WHERE ADDRNUMBER = LT_LFA1-ADRNR.

  IF LT_EKKO IS NOT INITIAL.

    SELECT OBJECTCLAS
           OBJECTID
           CHANGENR
           USERNAME
           UDATE
           UTIME
           TCODE
      FROM CDHDR
      INTO TABLE LT_CDHDR
      FOR ALL ENTRIES IN LT_EKKO
      WHERE OBJECTID = LT_EKKO-EBELN AND
            TCODE IN ( 'ME28' , 'ME29N' ).

    SELECT EBELN
           EBELP
           LOEKZ
      FROM EKPO
      INTO TABLE LT_EKPO
      FOR ALL ENTRIES IN LT_EKKO
      WHERE EBELN = LT_EKKO-EBELN+0(10) AND
            LOEKZ NE ' '.
    DELETE ADJACENT DUPLICATES FROM LT_EKPO COMPARING EBELN  LOEKZ.
    PERFORM SORT_DATA.
    PERFORM GET_FCAT.
    PERFORM DISPLAY.
  ELSE.

    MESSAGE 'No Data Found!' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.

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
*  BREAK primus.

  DATA : PONAMT TYPE STRING.
  LOOP AT LT_CDHDR INTO LS_CDHDR.

    LS_FINAL-OBJECTID = LS_CDHDR-OBJECTID.
    LS_FINAL-USERNAME = LS_CDHDR-USERNAME.
    LS_FINAL-UDATE    = LS_CDHDR-UDATE.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-UDATE
      IMPORTING
        OUTPUT = LS_FINAL-UDATE.

    CONCATENATE LS_FINAL-UDATE+0(2) LS_FINAL-UDATE+2(3) LS_FINAL-UDATE+5(4)
    INTO LS_FINAL-UDATE SEPARATED BY '-'.

    LS_FINAL-UTIME    = LS_CDHDR-UTIME.
    LS_FINAL-TCODE    = LS_CDHDR-TCODE.
    LS_FINAL-DLT = 'N'.

    READ TABLE  LT_EKKO INTO LS_EKKO WITH  KEY EBELN = LS_FINAL-OBJECTID .

    LS_FINAL-BEDAT = LS_EKKO-BEDAT.
    LS_FINAL-WAERS = LS_EKKO-WAERS.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-BEDAT
      IMPORTING
        OUTPUT = LS_FINAL-BEDAT.

    CONCATENATE LS_FINAL-BEDAT+0(2) LS_FINAL-BEDAT+2(3) LS_FINAL-BEDAT+5(4)
    INTO LS_FINAL-BEDAT SEPARATED BY '-'.
    LS_FINAL-LIFNR = LS_EKKO-LIFNR.
    LS_FINAL-EKORG = LS_EKKO-EKORG.
    PONAMT = LS_EKKO-RLWRT.
          REPLACE ALL OCCURRENCES OF ',' IN PONAMT WITH ''.
          LS_FINAL-PONETAMT = PONAMT.
    READ TABLE LT_LFA1 INTO LS_LFA1 WITH KEY LIFNR2 = LS_FINAL-LIFNR.
    DATA(ADDRESS) = LS_LFA1-ADRNR.

    READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = ADDRESS.
    LS_FINAL-NAME1 = LS_ADRC-NAME1.


    APPEND LS_FINAL TO LT_FINAL.
    CLEAR : LS_FINAL,LS_CDHDR,LS_EKPO,SY-SUBRC,ADDRESS.

  ENDLOOP.

*  BREAK primus.

  LOOP AT LT_EKPO INTO LS_EKPO.
    LS_FINAL-OBJECTID = LS_EKPO-EBELN.
    LS_FINAL-UTIME    = ' '.


    READ TABLE  LT_EKKO INTO LS_EKKO WITH  KEY EBELN = LS_FINAL-OBJECTID .

    LS_FINAL-BEDAT = LS_EKKO-BEDAT.
    LS_FINAL-WAERS = LS_EKKO-WAERS.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-BEDAT
      IMPORTING
        OUTPUT = LS_FINAL-BEDAT.

    CONCATENATE LS_FINAL-BEDAT+0(2) LS_FINAL-BEDAT+2(3) LS_FINAL-BEDAT+5(4)
    INTO LS_FINAL-BEDAT SEPARATED BY '-'.





    LS_FINAL-LIFNR = LS_EKKO-LIFNR.
    LS_FINAL-EKORG = LS_EKKO-EKORG.

    READ TABLE LT_LFA1 INTO LS_LFA1 WITH KEY LIFNR2 = LS_FINAL-LIFNR.
    ADDRESS = LS_LFA1-ADRNR.

    READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = ADDRESS.
    LS_FINAL-NAME1 = LS_ADRC-NAME1.



    READ TABLE LT_CDHDR INTO LS_CDHDR WITH KEY  OBJECTID = LS_EKPO-EBELN.
    IF SY-SUBRC NE 0.
      LS_FINAL-DLT = 'Y'.
    ENDIF.

    IF LS_FINAL-DLT IS NOT INITIAL.
      APPEND LS_FINAL TO LT_FINAL.

    ENDIF.
*    DELETE ADJACENT DUPLICATES FROM LT_FINAL

    CLEAR: LS_FINAL,ADDRESS.
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

  PERFORM FCAT USING : '1'    'OBJECTID'       'LT_FINAL'  'Purchasing Document'     '18' .
  PERFORM FCAT USING : '2'    'USERNAME'       'LT_FINAL'  'Released By'             '18' .
  PERFORM FCAT USING : '3'    'UDATE'          'LT_FINAL'  'Released on '            '18' .
  PERFORM FCAT USING : '4'    'UTIME'          'LT_FINAL'  'Time'                    '18' .
  PERFORM FCAT USING : '5'    'TCODE'          'LT_FINAL'  'TCode'                   '18' .
  PERFORM FCAT USING : '6'    'DLT'            'LT_FINAL'  'Deleted'                 '18' .
  PERFORM FCAT USING : '7'    'BEDAT'            'LT_FINAL'    'Purchase Order Date'  '18' .
  PERFORM FCAT USING : '8'    'LIFNR'            'LT_FINAL'  'Vendor'               '18' .
  PERFORM FCAT USING : '9'    'NAME1'            'LT_FINAL'  'Vendor Name'          '18' .
  PERFORM FCAT USING : '10'   'EKORG'            'LT_FINAL'  'Purchase Org.'          '18' .
  PERFORM fcat USING : '11'   'PONETAMT'            'LT_FINAL'  'PO Relased Net Val.'          '18' .
  PERFORM fcat USING : '11'   'WAERS'            'LT_FINAL'  'Currency'          '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0416   text
*      -->P_0417   text
*      -->P_0418   text
*      -->P_0419   text
*      -->P_0420   text
*----------------------------------------------------------------------*
FORM FCAT  USING VALUE(P1)
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
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .

  LS_LAYOUT-ZEBRA = 'X'.
  LS_LAYOUT-COLWIDTH_OPTIMIZE = 'X' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID
      I_CALLBACK_TOP_OF_PAGE = 'TOP'
      I_BACKGROUND_ID        = 'ALV_BACKGROUND'
      IS_LAYOUT              = LS_LAYOUT
      IT_FIELDCAT            = IT_FCAT[]
    TABLES
      T_OUTTAB               = LT_FINAL[]
    EXCEPTIONS
      PROGRAM_ERROR          = 1
      OTHERS                 = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
    PERFORM DOWNLOAD_EXCEL.
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

  LOOP AT LT_FINAL INTO LS_FINAL.

    LS_DOWN-OBJECTID = LS_FINAL-OBJECTID.
    LS_DOWN-USERNAME = LS_FINAL-USERNAME.
    LS_DOWN-TCODE    = LS_FINAL-TCODE.
    LS_DOWN-DLT      = LS_FINAL-DLT.
    LS_DOWN-BEDAT      = LS_FINAL-BEDAT.
    LS_DOWN-LIFNR      =  LS_FINAL-LIFNR.
    LS_DOWN-NAME1      =  LS_FINAL-NAME1.
    LS_DOWN-EKORG      =  LS_FINAL-EKORG.
    LS_DOWN-BEDAT      = LS_FINAL-BEDAT.
    LS_DOWN-UDATE      = LS_FINAL-UDATE.
    ls_down-PONETAMT      =  LS_FINAL-PONETAMT.
    ls_down-WAERS      =  LS_FINAL-WAERS.

*    IF LS_FINAL-BEDAT IS NOT INITIAL.
*
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = LS_FINAL-BEDAT
*        IMPORTING
*          output = ls_down-BEDAT.
*
*      CONCATENATE ls_down-BEDAT+0(2) ls_down-BEDAT+2(3) ls_down-BEDAT+5(4)
*      INTO ls_down-BEDAT SEPARATED BY '-'.

*<    ENDIF.

*    IF ls_final-udate IS NOT INITIAL.
*
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = ls_final-udate
*        IMPORTING
*          output = ls_down-udate.
*
*      CONCATENATE ls_down-udate+0(2) ls_down-udate+2(3) ls_down-udate+5(4)
*      INTO ls_down-udate SEPARATED BY '-'.
*
*    ENDIF.

    IF LS_FINAL-UTIME IS NOT INITIAL.

      CONCATENATE LS_FINAL-UTIME+0(2) ':' LS_FINAL-UTIME+2(2)  INTO LS_DOWN-UTIME.

    ENDIF.

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
    CLEAR LS_DOWN.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_EXCEL .

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
*  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZSU_PO_AUTHORIZATION.TXT'.

*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
  INTO LV_FULLFILE.
*  BREAK primus.
  WRITE: / 'ZSU_PO_AUTHORIZATION Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_568 TYPE string.
DATA lv_crlf_568 TYPE string.
lv_crlf_568 = cl_abap_char_utilities=>cr_lf.
lv_string_568 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_568 lv_crlf_568 wa_csv INTO lv_string_568.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_576 TO lv_fullfile.
TRANSFER lv_string_568 TO lv_fullfile.
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

  CONCATENATE 'Purchasing Document'
              'Released By'
              'Released on '
              'Time'
              'TCode'
              'Deleted'
              'Purchase Order Date'
              'Vendor'
              'Vendor Name'
              'Refresh Date'
              'Refresh Time'
              'Purchase Org.'
              'PO Released Net Val.'
              'Currency Key'
  INTO P_HD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.

FORM TOP.

  DATA: LT_LISTHEADER TYPE TABLE OF SLIS_LISTHEADER,
        LS_LISTHEADER TYPE SLIS_LISTHEADER,
        LS_MONTH_NAME TYPE T7RU9A-REGNO,
        GS_STRING     TYPE STRING,
        GS_MONTH(2)   TYPE N,
        T_LINE        LIKE LS_LISTHEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

  REFRESH LT_LISTHEADER.
  CLEAR LS_LISTHEADER.

  LS_LISTHEADER-TYP = 'H'.
  LS_LISTHEADER-INFO = 'ZSU_PO_AUTHORIZATION REPORT'."GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.
  CLEAR LS_LISTHEADER.

  GS_STRING = ''.
  CONCATENATE 'REPORT RUN DATE :' SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ''.
  LS_LISTHEADER-TYP = 'S'.
  LS_LISTHEADER-INFO =  GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.
  CLEAR LS_LISTHEADER.

  GS_STRING = ''.
  CONCATENATE 'REPORT RUN TIME :' SY-UZEIT+0(2) ':' SY-UZEIT+2(2) ':' SY-UZEIT+4(2) INTO GS_STRING SEPARATED BY ''.
  LS_LISTHEADER-TYP = 'S'.
*  LS_LISTHEADER-KEY = 'REPORT RUN TIME'.
  LS_LISTHEADER-INFO =  GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.
  CLEAR LS_LISTHEADER.

  DESCRIBE TABLE LT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.

  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' LD_LINESC
  INTO T_LINE SEPARATED BY SPACE.

  LS_LISTHEADER-TYP  = 'A'.
  LS_LISTHEADER-INFO = T_LINE.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.
  CLEAR: LS_LISTHEADER, T_LINE.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_LISTHEADER
      I_LOGO             = 'NEW_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.
