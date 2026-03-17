*&---------------------------------------------------------------------*
*& Report ZVK11_ZSTO_UPLOAD1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVK11_ZSTO_UPLOAD1.

TABLES sscrfields.
*** CREATED BY SUPRIYA :102423: ON 18.07.2024
TYPES : BEGIN OF TY_FINAL,
       VKORG  TYPE STRING,
       VTWEG  TYPE STRING,
       kunnr  TYPE STRING,
       matnr  TYPE STRING,
       amount  TYPE STRING,
       END OF TY_FINAL.

DATA : LT_FINAL TYPE TABLE OF TY_FINAL WITH HEADER LINE,
      LS_FINAL TYPE TY_FINAL,
       LT_BDCDATA TYPE TABLE OF BDCDATA WITH HEADER LINE,
       TEXT(4096) TYPE C OCCURS 0.
DATA: It_msg TYPE TABLE OF bdcmsgcoll,
      wa_msg TYPE  bdcmsgcoll,
      v_message TYPE string.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS : S_FILE TYPE RLGRAP-FILENAME.
  PARAMETERS : CTU_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'E'.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN: PUSHBUTTON 2(30)  but1 USER-COMMAND CLI1.
INITIALIZATION.
but1 = 'Download Excel Template'.
at SELECTION-SCREEN.
   if sscrfields  = 'CLI1'.
  PERFORM download_excel.
  ENDIF.

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_FILE.
    CALL FUNCTION 'F4_FILENAME'
*     EXPORTING
*       PROGRAM_NAME        = SYST-CPROG
*       DYNPRO_NUMBER       = SYST-DYNNR
*       FIELD_NAME          = ' '
     IMPORTING
       FILE_NAME           = S_FILE
.
start-of-selection.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
   I_LINE_HEADER              = 'X'
    I_TAB_RAW_DATA             = TEXT
    I_FILENAME                 = S_FILE
  TABLES
    I_TAB_CONVERTED_DATA       = LT_FINAL[]
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


*include bdcrecx1.

*start-of-selection.
LOOP AT LT_FINAL. "INTO LS_FINAL.
*perform open_group.
REFRESH LT_BDCDATA.
perform bdc_dynpro      using 'SAPMV13A' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV13A-KSCHL'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RV13A-KSCHL'
                              'ZSTO'.
perform bdc_dynpro      using 'SAPLV14A' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV130-SELKZ(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=WEIT'.
perform bdc_dynpro      using 'SAPMV13A' '1005'.
perform bdc_field       using 'BDC_CURSOR'
                              'KONP-KBETR(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'KOMG-VKORG'
                              lt_final-vkorg.             "'1000'.
perform bdc_field       using 'KOMG-VTWEG'
                              lt_final-vtweg.            "'10'.
perform bdc_field       using 'KOMG-KUNNR'
                              lt_final-kunnr .             "'1'.
perform bdc_field       using 'KOMG-MATNR(01)'
                               lt_final-matnr.           " 'TESTROH2'.
perform bdc_field       using 'KONP-KBETR(01)'
                              lt_final-amount.          "'150'.
perform bdc_dynpro      using 'SAPMV13A' '1005'.
perform bdc_field       using 'BDC_CURSOR'
                              'KOMG-MATNR(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SICH'.
*perform bdc_transaction using 'VK11'.


CALL  TRANSACTION 'VK11' USING LT_BDCDATA
      MODE CTU_MODE
      UPDATE 'S'
      MESSAGES INTO it_mSG.
ENDLOOP.

*perform close_group.

LOOP AT it_msg INTO wa_msg.
          CALL FUNCTION 'FORMAT_MESSAGE'                  "Formatting a T100 message
          EXPORTING
            id        = wa_msg-msgid
            lang      = sy-langu
            no        = wa_msg-msgnr
            v1        = wa_msg-msgv1
            v2        = wa_msg-msgv2
            v3        = wa_msg-msgv3
            v4        = wa_msg-msgv4
          IMPORTING
            msg       = v_message
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.

*        IF wa_bdcmsgcoll-msgtyp = 'S'.
          WRITE:/ v_message.
*
          ENDLOOP.


FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR LT_BDCDATA.
  LT_BDCDATA-PROGRAM  = PROGRAM.
  LT_BDCDATA-DYNPRO   = DYNPRO.
  LT_BDCDATA-DYNBEGIN = 'X'.
  APPEND LT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
    CLEAR LT_BDCDATA.
    LT_BDCDATA-FNAM = FNAM.
    LT_BDCDATA-FVAL = FVAL.
    APPEND LT_BDCDATA.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_excel .



TYPE-POOLS ole2 .

  DATA: application TYPE ole2_object,
        workbook    TYPE ole2_object,
        sheet       TYPE ole2_object,
        cells       TYPE ole2_object,
        cell1       TYPE ole2_object,
        cell2       TYPE ole2_object,
        range       TYPE ole2_object,
        font        TYPE ole2_object,
        column      TYPE ole2_object,
        shading     TYPE ole2_object,
        border      TYPE ole2_object.

  CONSTANTS: row_max TYPE I VALUE 256.
  DATA: INDEX TYPE I.
  DATA: ld_colindx TYPE I,   "COLUMN INDEX
        ld_rowindx TYPE I.   "ROW INDEX

  TYPES:BEGIN OF t_data,
          field1  TYPE string,
          field2  TYPE string,
          field3  TYPE string,
          field4  TYPE string,
          field5  TYPE string,
*          field5  TYPE string,
*          field6  TYPE string,
*          field7  TYPE string,
        END OF t_data.

  DATA: it_data TYPE STANDARD TABLE OF t_data,
        ls_data LIKE LINE OF it_data.

  FIELD-SYMBOLS: <fs>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*

  ls_data-field1 =  'Sales Organiztion'.
  ls_data-field2 =  'Dist. channel'.
   ls_data-field3 =  'Customer'.
  ls_data-field4 =  'Material'.
  ls_data-field5 =  'Amount'.


*  ls_data-field5 =  'Account Holder'.
*  ls_data-field6 =  'Ref Details'.
*  ls_data-field7 = 'First Date'.
  APPEND ls_data TO it_data.

  CREATE OBJECT application 'EXCEL.APPLICATION'.
  SET PROPERTY OF application 'VISIBLE' = 1.
  CALL METHOD OF
  application
  'WORKBOOKS' = workbook.

* CREATE NEW WORKSHEET
  SET PROPERTY OF application 'SHEETSINNEWWORKBOOK' = 1.
  CALL METHOD OF
  workbook
  'ADD'.

* CREATE FIRST EXCEL SHEET
  CALL METHOD OF
  application
  'WORKSHEETS' = sheet
  EXPORTING
    #1 = 1.
  CALL METHOD OF
  sheet
  'ACTIVATE'.
  SET PROPERTY OF sheet 'NAME' = 'Material Details'.

  " FILL_DATA
*&---------------------------------------------------------------------*
*&   DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET
*&---------------------------------------------------------------------*

  ld_rowindx = 1. "START AT ROW 1 FOR COLUMN NUMBERS
    LOOP AT it_data INTO ls_data.
      ld_rowindx = sy-tabix . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
      CLEAR ld_colindx.
      DO.
        ASSIGN COMPONENT sy-INDEX OF STRUCTURE ls_data TO <fs>.
        IF sy-subrc NE 0.
          EXIT.
        ENDIF.
        ld_colindx = sy-INDEX.
        CALL METHOD OF
        sheet
        'CELLS' = cells
        EXPORTING
          #1 = ld_rowindx
          #2 = ld_colindx.
        SET PROPERTY OF cells 'VALUE' = <fs>.
      ENDDO.
    ENDLOOP.

    " DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*&  FORMATTING OF COLUMN NUMBER ROW
*&---------------------------------------------------------------------*

    CALL METHOD OF
    application
    'CELLS' = cell1
    EXPORTING
      #1 = 1     "DOWN
      #2 = 1.    "ACROSS

*END OF RANGE CELL
      CALL METHOD OF
      application
      'CELLS' = cell2
      EXPORTING
        #1 = 1     "DOWN
        #2 = 4.   "COLUMN ACROSS

      CALL METHOD OF
      application
      'RANGE' = range
      EXPORTING
        #1 = cell1
        #2 = cell2.

* SET FONT DETAILS OF RANGE

      GET PROPERTY OF range 'FONT' = font.
      SET PROPERTY OF font 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
      CALL METHOD OF
      range
      'INTERIOR' = shading.
      SET PROPERTY OF shading 'COLORINDEX' = 2. " COLOUR - CHANGE NUMBER FOR DIFF COLOURS
      SET PROPERTY OF shading 'PATTERN' = 1.    " PATTERN - SOLID, STRIPED ETC
      FREE OBJECT shading.

      "END OF FORMATTING OF COLUMN NUMBER ROW

*&*--------------------------------------------------------------------*
*&*  MODIFY PROPERTIES OF CELL RANGE
*&*--------------------------------------------------------------------*

      FREE range.
      CALL METHOD OF application 'CELLS' = cell1  "START CELL
      EXPORTING
        #1 = 1     "DOWN
        #2 = 1.    "ACROSS

      CALL METHOD OF application 'CELLS' = cell2 "END CELL
      EXPORTING
        #1 = 1    "DOWN
        #2 = 4.   "COLUMNS ACROSS

      CALL METHOD OF
      application
      'RANGE' = range
      EXPORTING
        #1 = cell1
        #2 = cell2.


* SET BORDER PROPERTIES OF RANGE
      CALL METHOD OF
      range
      'BORDERS' = border
      EXPORTING
        #1 = '1'.  "LEFT
      SET PROPERTY OF border 'LINESTYLE' = '1'. "LINE STYLE SOLID, DASHED...
      SET PROPERTY OF border 'WEIGHT' = 1.                      "MAX = 4
      FREE OBJECT border.

      CALL METHOD OF
      range
      'BORDERS' = border
      EXPORTING
        #1 = '2'.  "RIGHT
      SET PROPERTY OF border 'LINESTYLE' = '1'.
      SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
      FREE OBJECT border.

      CALL METHOD OF
      range
      'BORDERS' = border
      EXPORTING
        #1 = '3'.   "TOP
      SET PROPERTY OF border 'LINESTYLE' = '1'.
      SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
      FREE OBJECT border.

      CALL METHOD OF
      range
      'BORDERS' = border
      EXPORTING
        #1 = '4'.   "BOTTOM
      SET PROPERTY OF border 'LINESTYLE' = '1'.
      SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
      FREE OBJECT border.

      " SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *

      CALL METHOD OF application
      'COLUMNS' = column.
      CALL METHOD OF column
      'AUTOFIT'.
      FREE OBJECT column.

      " SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME

      CALL METHOD OF
      sheet'SAVEAS'
      EXPORTING
        #1 = 'C:\MM02.xls'     "FILENAME
        #2 = 1.                "FILEFORMAT

      FREE OBJECT sheet.
      FREE OBJECT workbook.
      FREE OBJECT application.

      " CELL_BORDER







ENDFORM.
