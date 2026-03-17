*&---------------------------------------------------------------------*
*& Report ZVENDOR_CHANGE_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVENDOR_CHANGE_UPLOAD
 NO STANDARD PAGE HEADING LINE-SIZE 255.
TABLES:SSCRFIELDS.


TYPES: BEGIN  OF TY_FINAL,
            LIFNR(10),            " vendor
            BUKRS(04),            " Company Code


****            ANRED(15),            " Title
****            NAME1(30),            " Name
****            SORTL(10),            " Sort field
****            STRAS(30),            " House number and street
****            ORT01(25),            " City
****            PSTLZ(10),            " Postal Code
****            ORT02(25),            " District
****            LAND1(03),            " Country Key
****            REGIO(03),            " State
****            TELF1(16),            " First telephone number
****            TELF2(16),            " Mobile Number
****            J_1IEXRG(60),         " Excise Range
****            J_1IEXDI(60),         " Excise Division
****            J_1IEXCO(60),         " Excise Commissionerate
****            J_1IEXCIVE(1),        " Excise tax indicator f


            SECCODE(04),          " Section Code
            SECCODE2(04),         " Section Code
            WT_EXNR(25),          " Exemption certificate number
            WT_EXNR2(25),         " Exemption certificate number
            WT_EXRT(05),          " Exemption rate
            WT_EXRT2(05),         " Exemption rate2
            WT_EXDF(10),        " Date on which exemption begins
            WT_EXDF2(10),         " Date on which exemption begins
            WT_EXDT(10),          " Date on which exemption
            WT_EXDT2(10),         " Date on which exemption2
            WT_WTEXRS(02),        " Reason for exemption
            WT_WTEXRS2(02),       " Reason for exemption2
            WITHT(02),            " Indicator for withholding tax type
            WITHT2(02),           " Indicator for withholding tax type
            WT_WITHCD(02),        " Withholding tax code
            WT_WITHCD2(02),       " Withholding tax code
            FIWTIN_EXEM_THR(15),  " Threshold amount for Exemption (India)
            FIWTIN_EXEM_THR2(15), " Threshold amount for Exemption (India)
            WAERS(05),            " Currency Key
            WAERS2(05),           " Currency Key
            Edate(10) TYPE c,
       END OF TY_FINAL.

DATA : IT_BDCDATA    TYPE TABLE OF BDCDATA WITH HEADER LINE,
       IT_BDCMSGCOLL LIKE TABLE OF BDCMSGCOLL,
       WA_BDCMSGCOLL LIKE LINE OF IT_BDCMSGCOLL,
       v_message TYPE string,
       TXT(4096)     TYPE C OCCURS 0,
       IT_HEADER      TYPE TABLE OF TY_FINAL,
       WA_HEADER      TYPE TY_FINAL.


SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS : FILE TYPE RLGRAP-FILENAME.
PARAMETERS : MODE TYPE CTU_PARAMS-DISMODE DEFAULT 'E'.
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.


INITIALIZATION.
* Add displayed text string to buttons
  W_BUTTON = 'Download Excel Template'.

AT SELECTION-SCREEN.

  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    PERFORM DOWNLOAD_XL .
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR FILE.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
*     FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = FILE.

*include bdcrecx1.
START-OF-SELECTION.
*perform open_group.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = TXT
      I_FILENAME           = FILE
    TABLES
      I_TAB_CONVERTED_DATA = IT_HEADER
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



  IF IT_HEADER IS NOT INITIAL.

    LOOP AT IT_HEADER INTO WA_HEADER.
      REFRESH: IT_BDCDATA, IT_BDCMSGCOLL.


      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0101'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'RF02K-D0110'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM BDC_FIELD       USING 'RF02K-LIFNR'
                                   WA_HEADER-LIFNR         . " '100152'.
      PERFORM BDC_FIELD       USING 'RF02K-BUKRS'
                                   WA_HEADER-BUKRS         . "  '1001'.
      PERFORM BDC_FIELD       USING 'RF02K-D0110'
                                    'X'.


      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0110'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFA1-ANRED'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=OPFI'.


****      PERFORM BDC_FIELD       USING 'LFA1-ANRED'
****                                   WA_HEADER-ANRED         .   "  'Company'.
****      PERFORM BDC_FIELD       USING 'LFA1-NAME1'
****                                   WA_HEADER-NAME1         .   "  'SHRO SYSTEMS PVT LTD'.
****      PERFORM BDC_FIELD       USING 'LFA1-SORTL'
****                                   WA_HEADER-SORTL         .   "  'SHRO'.
****      PERFORM BDC_FIELD       USING 'LFA1-STRAS'
****                                   WA_HEADER-STRAS         .   "  '23464 DNYANESHWAR PADUKA, CHK'.
****      PERFORM BDC_FIELD       USING 'LFA1-ORT01'
****                                   WA_HEADER-ORT01         .   "  'F.C.ROAD SHIVAJI NAG'.
****      PERFORM BDC_FIELD       USING 'LFA1-PSTLZ'
****                                   WA_HEADER-PSTLZ         .   "  '411005'.
****      PERFORM BDC_FIELD       USING 'LFA1-ORT02'
****                                   WA_HEADER-ORT02         .   "  'F.C.ROAD SHIVAJI NAG'.
****      PERFORM BDC_FIELD       USING 'LFA1-LAND1'
****                                    'IN'.
****      PERFORM BDC_FIELD       USING 'LFA1-REGIO'
****                                   WA_HEADER-REGIO         .   "  '13'.
****      PERFORM BDC_FIELD       USING 'LFA1-SPRAS'
****                                    'EN'.
****      PERFORM BDC_FIELD       USING 'LFA1-TELF1'
****                                   WA_HEADER-TELF1         .   "   '020-25531863'.
****      PERFORM BDC_FIELD       USING 'LFA1-TELF2'
****                                   WA_HEADER-TELF2         .   "  '9820518905'.



      PERFORM BDC_DYNPRO      USING 'SAPLJ1I_MASTER' '0100'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=CIN_VENDOR_FC4'.


****      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
****                                    'J_1IMOVEND-J_1IEXCD'.
****      PERFORM BDC_FIELD       USING 'J_1IMOVEND-J_1IEXRG'
****                                   WA_HEADER-J_1IEXRG         .   "  'PUNE'.
****      PERFORM BDC_FIELD       USING 'J_1IMOVEND-J_1IEXDI'
****                                   WA_HEADER-J_1IEXDI         .   "  'PUNE'.
****      PERFORM BDC_FIELD       USING 'J_1IMOVEND-J_1IEXCO'
****                                   WA_HEADER-J_1IEXCO         .   "  'PUNE'.
****      PERFORM BDC_FIELD       USING 'J_1IMOVEND-J_1IEXCIVE'
****                                   WA_HEADER-J_1IEXCIVE         .   "  '1'.

**
**
      PERFORM BDC_DYNPRO      USING 'SAPLJ1I_MASTER' '0100'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '/00'.


      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'GS_TAN_EXEM-WAERS(02)'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-SECCODE(01)'
                                  WA_HEADER-SECCODE         . "   '1001'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-SECCODE(02)'
                                  WA_HEADER-SECCODE2         . "   '1001'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXNR(01)'
                                  WA_HEADER-WT_EXNR         .   "   'TDSU/S194Q'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXNR(02)'
                                  WA_HEADER-WT_EXNR2         .   "   'TDSU/S194Q'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXRT(01)'
                                  WA_HEADER-WT_EXRT         .   "   '100'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXRT(02)'
                                  WA_HEADER-WT_EXRT2         .   "   '100'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXDF(01)'
                                  WA_HEADER-WT_EXDF         .   "   '01.04.2021'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXDF(02)'
                                  WA_HEADER-WT_EXDF2         .   "   '01.04.2021'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXDT(01)'
                                  WA_HEADER-WT_EXDT         .   "   '31.03.2022'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_EXDT(02)'
                                  WA_HEADER-WT_EXDT2         .   "   '31.03.2022'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_WTEXRS(01)'
                                  WA_HEADER-WT_WTEXRS         .   "   '01'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_WTEXRS(02)'
                                  WA_HEADER-WT_WTEXRS2         .   "  '01'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WITHT(01)'
                                  WA_HEADER-WITHT         .   "   '4Q'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WITHT(02)'
                                  WA_HEADER-WITHT2         .   "   '5Q'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_WITHCD(01)'
                                  WA_HEADER-WT_WITHCD         .   "   '4Q'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WT_WITHCD(02)'
                                  WA_HEADER-WT_WITHCD2         .   "   '5Q'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-FIWTIN_EXEM_THR(01)'
                                  WA_HEADER-FIWTIN_EXEM_THR         .   "   '5000000'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-FIWTIN_EXEM_THR(02)'
                                  WA_HEADER-FIWTIN_EXEM_THR2         .   "   '5000000'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WAERS(01)'
                                  WA_HEADER-WAERS         .   "   'INR'.
      PERFORM BDC_FIELD       USING 'GS_TAN_EXEM-WAERS(02)'
                                  WA_HEADER-WAERS2         .   "   'INR'.

      PERFORM BDC_DYNPRO      USING 'SAPLJ1I_MASTER' '0100'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=BACK'.


      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'GS_TAN_EXEM-WAERS(02)'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0110'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFA1-ANRED'.


      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=UPDA'.

****
****      PERFORM BDC_FIELD       USING 'LFA1-ANRED'
****                                  WA_HEADER-ANRED         .   "   'Company'.
****      PERFORM BDC_FIELD       USING 'LFA1-NAME1'
****                                  WA_HEADER-NAME1         .   "   'SHRO SYSTEMS PVT LTD'.
****      PERFORM BDC_FIELD       USING 'LFA1-SORTL'
****                                  WA_HEADER-SORTL         .   "   'SHRO'.
****      PERFORM BDC_FIELD       USING 'LFA1-STRAS'
****                                  WA_HEADER-STRAS         .   "   '23464 DNYANESHWAR PADUKA, CHK'.
****      PERFORM BDC_FIELD       USING 'LFA1-ORT01'
****                                  WA_HEADER-ORT01         .   "   'F.C.ROAD SHIVAJI NAG'.
****      PERFORM BDC_FIELD       USING 'LFA1-PSTLZ'
****                                  WA_HEADER-PSTLZ         .   "   '411005'.
****      PERFORM BDC_FIELD       USING 'LFA1-ORT02'
****                                  WA_HEADER-ORT02         .   "   'F.C.ROAD SHIVAJI NAG'.
****      PERFORM BDC_FIELD       USING 'LFA1-LAND1'
****                                    'IN'.
****      PERFORM BDC_FIELD       USING 'LFA1-REGIO'
****                                  WA_HEADER-REGIO         .   "   '13'.
****      PERFORM BDC_FIELD       USING 'LFA1-SPRAS'
****                                    'EN'.
****      PERFORM BDC_FIELD       USING 'LFA1-TELF1'
****                                  WA_HEADER-TELF1         .   "   '020-25531863'.
****      PERFORM BDC_FIELD       USING 'LFA1-TELF2'
****                                  WA_HEADER-TELF2         .   "   '9820518905'.



      CALL TRANSACTION 'XK02' USING IT_BDCDATA
                UPDATE 'S'
                MODE MODE
                MESSAGES INTO IT_BDCMSGCOLL.


      CLEAR : WA_HEADER.

    ENDLOOP.
  ENDIF.

  LOOP AT it_BDCMSGCOLL INTO wa_BDCMSGCOLL.
          CALL FUNCTION 'FORMAT_MESSAGE'                  "Formatting a T100 message
          EXPORTING
            id        = wa_BDCMSGCOLL-msgid
            lang      = sy-langu
            no        = wa_BDCMSGCOLL-msgnr
            v1        = wa_BDCMSGCOLL-msgv1
            v2        = wa_BDCMSGCOLL-msgv2
            v3        = wa_BDCMSGCOLL-msgv3
            v4        = wa_BDCMSGCOLL-msgv4
          IMPORTING
            msg       = v_message
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.

*        IF wa_bdcmsgcoll-msgtyp = 'S'.
          WRITE:/ v_message.
*
          ENDLOOP.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR IT_BDCDATA.
  IT_BDCDATA-PROGRAM  = PROGRAM.
  IT_BDCDATA-DYNPRO   = DYNPRO.
  IT_BDCDATA-DYNBEGIN = 'X'.
  APPEND IT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
  CLEAR IT_BDCDATA.
  IT_BDCDATA-FNAM = FNAM.
  IT_BDCDATA-FVAL = FVAL.
  APPEND IT_BDCDATA.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_XL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_XL .

  TYPE-POOLS OLE2.

  DATA: APPLICATION TYPE OLE2_OBJECT,
        WORKBOOK    TYPE OLE2_OBJECT,
        SHEET       TYPE OLE2_OBJECT,
        CELLS       TYPE OLE2_OBJECT,
        CELL1       TYPE OLE2_OBJECT,
        CELL2       TYPE OLE2_OBJECT,
        RANGE       TYPE OLE2_OBJECT,
        FONT        TYPE OLE2_OBJECT,
        COLUMN      TYPE OLE2_OBJECT,
        SHADING     TYPE OLE2_OBJECT,
        BORDER      TYPE OLE2_OBJECT.

  CONSTANTS: ROW_MAX TYPE I VALUE 256.
  DATA: INDEX TYPE I.
  DATA: LD_COLINDX TYPE I,   "COLUMN INDEX
        LD_ROWINDX TYPE I.   "ROW INDEX

  TYPES:BEGIN OF T_DATA,
          FIELD1  TYPE STRING,
          FIELD2  TYPE STRING,
          FIELD3  TYPE STRING,
          FIELD4  TYPE STRING,
          FIELD5  TYPE STRING,
          FIELD6  TYPE STRING,
          FIELD7  TYPE STRING,
          FIELD8  TYPE STRING,
          FIELD9  TYPE STRING,
          FIELD10  TYPE STRING,
          FIELD11  TYPE STRING,
          FIELD12  TYPE STRING,
          FIELD13  TYPE STRING,
          FIELD14  TYPE STRING,
          FIELD15  TYPE STRING,
          FIELD16 TYPE STRING,
          FIELD17  TYPE STRING,
          FIELD18  TYPE STRING,
          FIELD19  TYPE STRING,
          FIELD20  TYPE STRING,
          FIELD21  TYPE STRING,
          FIELD22  TYPE STRING,
          FIELD23  TYPE STRING,
          FIELD24  TYPE STRING,
          FIELD25  TYPE STRING,
          FIELD26  TYPE STRING,
          FIELD27  TYPE STRING,
          FIELD28  TYPE STRING,
          FIELD29  TYPE STRING,
          FIELD30  TYPE STRING,
          FIELD31  TYPE STRING,
          FIELD32  TYPE STRING,
          FIELD33  TYPE STRING,
          FIELD34  TYPE STRING,
          FIELD35  TYPE STRING,
          FIELD36  TYPE STRING,
          FIELD37  TYPE STRING,
        END OF T_DATA.

  DATA: IT_DATA TYPE STANDARD TABLE OF T_DATA,
        LS_DATA LIKE LINE OF IT_DATA.

  FIELD-SYMBOLS: <FS>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*

  LS_DATA-FIELD1  = 'vendor'.
  LS_DATA-FIELD2  = 'Company Code'.


****  LS_DATA-FIELD3  = 'Title'.
****  LS_DATA-FIELD4  = 'Name'.
****  LS_DATA-FIELD5  = 'Sort field'.
****  LS_DATA-FIELD6  = 'House number and street'.
****  LS_DATA-FIELD7  = 'City'.
****  LS_DATA-FIELD8  = 'Postal Code'.
****  LS_DATA-FIELD9  = 'District'.
****  LS_DATA-FIELD10 = 'Country Key'.
****  LS_DATA-FIELD11 = 'State'.
****  LS_DATA-FIELD12 = 'First telephone number'.
****  LS_DATA-FIELD13 = 'Mobile Number'.
****  LS_DATA-FIELD14 = 'Excise Range'.
****  LS_DATA-FIELD15 = 'Excise Division'. .
****  LS_DATA-FIELD16 = 'Excise Commissionerate'.
****  LS_DATA-FIELD17 = 'Excise tax indicator f'.


  LS_DATA-FIELD3  = 'Section Code'.
  LS_DATA-FIELD4  = 'Section Code-2'.
  LS_DATA-FIELD5  = 'Exemption certificate number'.
  LS_DATA-FIELD6  = 'Exemption certificate number-2'.
  LS_DATA-FIELD7  = 'Exemption rate'.
  LS_DATA-FIELD8  = 'Exemption rate-2'.
  LS_DATA-FIELD9  = 'Date on which exemption begins'.
  LS_DATA-FIELD10 = 'Date on which exemption begins-2'.
  LS_DATA-FIELD11 = 'Date on which exemption'.
  LS_DATA-FIELD12 = 'Date on which exemption-2'.
  LS_DATA-FIELD13 = 'Reason for exemption'.
  LS_DATA-FIELD14 = 'Reason for exemption-2'.
  LS_DATA-FIELD15 = 'Indicator for withholding tax type'.
  LS_DATA-FIELD16 = 'Indicator for withholding tax type-2'.
  LS_DATA-FIELD17 = 'Withholding tax code'.
  LS_DATA-FIELD18 = 'Withholding tax code-2'.
  LS_DATA-FIELD19 = 'Threshold amount for Exemption (India)'.
  LS_DATA-FIELD20 = 'Threshold amount for Exemption (India)-2'.
  LS_DATA-FIELD21 = 'Currency Key'.
  LS_DATA-FIELD22 = 'Currency Key2'.


  APPEND LS_DATA TO IT_DATA.

  CREATE OBJECT APPLICATION 'EXCEL.APPLICATION'.
  SET PROPERTY OF APPLICATION 'VISIBLE' = 1.
  CALL METHOD OF
      APPLICATION
      'WORKBOOKS' = WORKBOOK.

* CREATE NEW WORKSHEET
  SET PROPERTY OF APPLICATION 'SHEETSINNEWWORKBOOK' = 1.
  CALL METHOD OF
      WORKBOOK
      'ADD'.

* CREATE FIRST EXCEL SHEET
  CALL METHOD OF
      APPLICATION
      'WORKSHEETS' = SHEET
    EXPORTING
      #1           = 1.
  CALL METHOD OF
      SHEET
      'ACTIVATE'.
  SET PROPERTY OF SHEET 'NAME' = 'Vendor change for TDS-194Q'.

  " FILL_DATA
*&---------------------------------------------------------------------*
*&   DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET
*&---------------------------------------------------------------------*

  LD_ROWINDX = 1. "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT IT_DATA INTO LS_DATA.
    LD_ROWINDX = SY-TABIX . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
    CLEAR LD_COLINDX.
    DO.
      ASSIGN COMPONENT SY-INDEX OF STRUCTURE LS_DATA TO <FS>.
      IF SY-SUBRC NE 0.
        EXIT.
      ENDIF.
      LD_COLINDX = SY-INDEX.
      CALL METHOD OF
          SHEET
          'CELLS' = CELLS
        EXPORTING
          #1      = LD_ROWINDX
          #2      = LD_COLINDX.
      SET PROPERTY OF CELLS 'VALUE' = <FS>.
    ENDDO.
  ENDLOOP.

  " DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*&  FORMATTING OF COLUMN NUMBER ROW
*&---------------------------------------------------------------------*

  CALL METHOD OF
      APPLICATION
      'CELLS'     = CELL1
    EXPORTING
      #1          = 1     "DOWN
      #2          = 1.    "ACROSS

*END OF RANGE CELL
  CALL METHOD OF
      APPLICATION
      'CELLS'     = CELL2
    EXPORTING
      #1          = 1     "DOWN
      #2          = 2.   "ACROSS """"

  CALL METHOD OF
      APPLICATION
      'RANGE'     = RANGE
    EXPORTING
      #1          = CELL1
      #2          = CELL2.

* SET FONT DETAILS OF RANGE

  GET PROPERTY OF RANGE 'FONT' = FONT.
  SET PROPERTY OF FONT 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
  CALL METHOD OF
      RANGE
      'INTERIOR' = SHADING.
  SET PROPERTY OF SHADING 'COLORINDEX' = 2. " COLOUR - CHANGE NUMBER FOR DIFF COLOURS
  SET PROPERTY OF SHADING 'PATTERN' = 1.    " PATTERN - SOLID, STRIPED ETC
  FREE OBJECT SHADING.

  "END OF FORMATTING OF COLUMN NUMBER ROW

*&*--------------------------------------------------------------------*
*&*  MODIFY PROPERTIES OF CELL RANGE
*&*--------------------------------------------------------------------*

  FREE RANGE.
  CALL METHOD OF APPLICATION 'CELLS' = CELL1  "START CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

  CALL METHOD OF APPLICATION 'CELLS' = CELL2 "END CELL
  EXPORTING
    #1 = 1    "DOWN
    #2 = 7.   "ACROSS "added by manisha sarade

  CALL METHOD OF
      APPLICATION
      'RANGE'     = RANGE
    EXPORTING
      #1          = CELL1
      #2          = CELL2.


* SET BORDER PROPERTIES OF RANGE
  CALL METHOD OF
      RANGE
      'BORDERS' = BORDER
    EXPORTING
      #1        = '1'.  "LEFT
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'. "LINE STYLE SOLID, DASHED...
  SET PROPERTY OF BORDER 'WEIGHT' = 1.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
      RANGE
      'BORDERS' = BORDER
    EXPORTING
      #1        = '2'.  "RIGHT
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
      RANGE
      'BORDERS' = BORDER
    EXPORTING
      #1        = '3'.   "TOP
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
      RANGE
      'BORDERS' = BORDER
    EXPORTING
      #1        = '4'.   "BOTTOM
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  " SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *

  CALL METHOD OF
      APPLICATION
      'COLUMNS'   = COLUMN.
  CALL METHOD OF
      COLUMN
      'AUTOFIT'.
  FREE OBJECT COLUMN.

  " SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME

  CALL METHOD OF
      SHEET
      'SAVEAS'

    EXPORTING
      #1       = 'C:\ 194Q TAX ACCOUNTING.xls'     "FILENAME
      #2       = 1.                           "FILEFORMAT

  FREE OBJECT SHEET.
  FREE OBJECT WORKBOOK.
  FREE OBJECT APPLICATION.









ENDFORM.
