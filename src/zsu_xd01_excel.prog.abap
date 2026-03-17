*&---------------------------------------------------------------------*
*& Report ZVENDOR_EXCEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_XD01_EXCEL.




DATA: FIELD1  TYPE C LENGTH 40 VALUE    'Company Code',
      FIELD2  TYPE C LENGTH 40 VALUE    'Sales Org',
      FIELD3  TYPE C LENGTH 40 VALUE    'Distribution Channel',
      FIELD4  TYPE C LENGTH 40 VALUE    'Division',
      FIELD5  TYPE C LENGTH 40 VALUE    'Account group',
      FIELD6  TYPE C LENGTH 40 VALUE    'Title',
      FIELD7  TYPE  C LENGTH 40 VALUE    'Name',
      FIELD8  TYPE C LENGTH 40 VALUE     'Street House Number',
      FIELD9  TYPE C LENGTH 40 VALUE     'City',
      FIELD10 TYPE C LENGTH 40 VALUE    'Postal Code',
      FIELD11 TYPE C LENGTH 40 VALUE   'Country',
      FIELD12 TYPE  C LENGTH 40 VALUE   'Launguage',
      FIELD13 TYPE  C LENGTH 40 VALUE   'Telephone',            "---------------
      FIELD14 TYPE C LENGTH 40 VALUE    'Vat no',
      FIELD15 TYPE C LENGTH 40 VALUE 'Recco Account',
      FIELD16 TYPE C LENGTH 40 VALUE 'Payment Term',
      FIELD17 TYPE C LENGTH 40 VALUE 'Order Probab.',
      FIELD18 TYPE C LENGTH 40 VALUE 'Sales Office',
      FIELD19 TYPE C LENGTH 40 VALUE 'Currency',
      FIELD20 TYPE C LENGTH 40 VALUE 'Cust Pri Procedure',
      FIELD21 TYPE C LENGTH 40 VALUE 'Delivery Priority',
      FIELD22 TYPE C LENGTH 40 VALUE 'Shipping Condition',
      FIELD23 TYPE C LENGTH 40 VALUE 'Delivering Plant',
      FIELD24 TYPE C LENGTH 40 VALUE 'Max.Part.Deliveries',
      FIELD25 TYPE C LENGTH 40 VALUE 'Invoicing Dates',
      FIELD26 TYPE C LENGTH 40 VALUE 'Incoterms',
      FIELD27 TYPE C LENGTH 40 VALUE 'Incoterms Description',
      FIELD28 TYPE C LENGTH 40 VALUE 'Acc Assignmt Group',
      FIELD29 TYPE C LENGTH 40 VALUE 'Output Tax'.
      INCLUDE ZSUADI_XD01_FORMAT.
*INCLUDE ZVEN_EXCEL_FORMAT.

START-OF-SELECTION.
  PERFORM FILL_DATA.
  PERFORM DOWNLOAD_DATA.
  PERFORM MODIFY_CELLS.
  PERFORM CELL_BORDER.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_DATA .
***START OF COLUMN NUMBERS


  WA_DATA-FIELD1  = FIELD1.
  WA_DATA-FIELD2  = FIELD2.
  WA_DATA-FIELD3  = FIELD3.
  WA_DATA-FIELD4  = FIELD4.
  WA_DATA-FIELD5  = FIELD5.
  WA_DATA-FIELD6  = FIELD6.
  WA_DATA-FIELD7  = FIELD7.
  WA_DATA-FIELD8  = FIELD8.
  WA_DATA-FIELD9  = FIELD9.
  WA_DATA-FIELD10 = FIELD10.
  WA_DATA-FIELD11 = FIELD11.
  WA_DATA-FIELD12 = FIELD12.
  WA_DATA-FIELD13 = FIELD13.
  WA_DATA-FIELD14 = FIELD14.
  WA_DATA-FIELD15 = FIELD15.
  WA_DATA-FIELD16 = FIELD16.
  WA_DATA-FIELD17 = FIELD17.
  WA_DATA-FIELD18 = FIELD18.
  WA_DATA-FIELD19 = FIELD19.
  WA_DATA-FIELD20 = FIELD20.
  WA_DATA-FIELD21 = FIELD21.
  WA_DATA-FIELD22 = FIELD22.
  WA_DATA-FIELD23 = FIELD23.
  WA_DATA-FIELD24 = FIELD24.
  WA_DATA-FIELD25 = FIELD25.
  WA_DATA-FIELD26 = FIELD26.
  WA_DATA-FIELD27 = FIELD27.
  WA_DATA-FIELD28 = FIELD27.
  WA_DATA-FIELD29 = FIELD27.
  APPEND WA_DATA TO IT_DATA.

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
  SET PROPERTY OF SHEET 'NAME' = 'VENDOR_MASTER'.


ENDFORM.                    " FILL_DATA
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_DATA .

***********************************************
* DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET   *
***********************************************

  LD_ROWINDX = 1. "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT IT_DATA INTO WA_DATA.
    LD_ROWINDX = SY-TABIX . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
    CLEAR LD_COLINDX.
    DO.
      ASSIGN COMPONENT SY-INDEX OF STRUCTURE WA_DATA TO <FS>.
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

ENDFORM.                    " DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*&      Form  MODIFY_CELLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MODIFY_CELLS .

***********************************************
****FORMATTING OF COLUMN NUMBER ROW ***********
***********************************************
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
    #2          = 51.   "ACROSS

  CALL METHOD OF
  APPLICATION
  'RANGE'     = RANGE
  EXPORTING
    #1          = CELL1
    #2          = CELL2.
***********************************************
* MODIFY PROPERTIES OF CELL RANGE             *
***********************************************
* SET FONT DETAILS OF RANGE

  GET PROPERTY OF RANGE 'FONT' = FONT.
  SET PROPERTY OF FONT 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
  CALL METHOD OF
    RANGE
      'INTERIOR' = SHADING.
  SET PROPERTY OF SHADING 'COLORINDEX' = 0. "COLOUR - CHANGE NUMBER FOR DIFF COLOURS
  SET PROPERTY OF SHADING 'PATTERN' = 1. "PATTERN - SOLID, STRIPED ETC
  FREE OBJECT SHADING.

***********************************************
*****END OF FORMATTING OF COLUMN NUMBER ROW****
***********************************************



ENDFORM.                    " MODIFY_CELLS
*&---------------------------------------------------------------------*
*&      Form  CELL_BORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CELL_BORDER .

*************************************************
*** MODIFY PROPERTIES OF CELL RANGE             *
*************************************************

  FREE RANGE.
  CALL METHOD OF APPLICATION 'CELLS' = CELL1  "START CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

  CALL METHOD OF APPLICATION 'CELLS' = CELL2 "END CELL
  EXPORTING
    #1 = 1    "DOWN
    #2 = 51.   "ACROSS

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

* OVERWITES ALL CELL VALUES IN RANGE TO EQUAL 'TEST'
* SET PROPERTY OF RANGE    'VALUE' = 'TEST'.


***********************************************
* SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *
***********************************************
  CALL METHOD OF
    APPLICATION
      'COLUMNS' = COLUMN.
  CALL METHOD OF
    COLUMN
    'AUTOFIT'.

  FREE OBJECT COLUMN.

***********************************************
* SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME*
*************************************#*********
  CALL METHOD OF
    SHEET
    'SAVEAS'
    EXPORTING
      #1 = 'D:\SAP_DATA\VENDOR_MASTER.XLS'     "FILENAME
      #2 = 1.                          "FILEFORMAT

  FREE OBJECT SHEET.
  FREE OBJECT WORKBOOK.
  FREE OBJECT APPLICATION.

ENDFORM.                    " CELL_BORDER
