*&---------------------------------------------------------------------*
*& Report ZMM02_BAPI_COSTING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM02_BAPI_COSTING.

TABLES sscrfields.
TYPES : BEGIN OF ty_final,
        matnr(18),   " Material No
        PLANT(4),
         PRICE3(23),
         PDATE TYPE DZPLD2,
         END OF TY_FINAL.

DATA : GT_FINAL TYPE STANDARD TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL.


DATA : IT_RAW TYPE truxs_t_text_data.

DATA :
       IT_RETURN TYPE BAPIRET2,
       mat_head   TYPE bapimathead,
       wa_SBIN   TYPE BAPI_MARD,
       wa_SBIN1  TYPE BAPI_MARDX,
       wa_value TYPE BAPI_MBEW,
       wa_valuex TYPE BAPI_MBEWX.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS : p_file TYPE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN: PUSHBUTTON 2(30)  but1 USER-COMMAND CLI1.
INITIALIZATION.
but1 = 'Download Excel Template'.
at SELECTION-SCREEN.
   if sscrfields  = 'CLI1'.
  PERFORM download_excel.
  ENDIF.




AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .

CALL FUNCTION 'F4_FILENAME'
 EXPORTING
   PROGRAM_NAME        = SYST-CPROG
   DYNPRO_NUMBER       = SYST-DYNNR
*   FIELD_NAME          = ' '
 IMPORTING
   FILE_NAME           = P_FILE
          .

START-OF-SELECTION .

PERFORM GET_FILE .

LOOP AT GT_FINAL INTO WA_FINAL.

CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
  EXPORTING
    input              = WA_FINAL-MATNR
 IMPORTING
   OUTPUT             = mat_head-MATERIAL
 EXCEPTIONS
   LENGTH_ERROR       = 1
   OTHERS             = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

mat_head-COST_VIEW   = 'X'.
WA_SBIN-PLANT       = WA_FINAL-PLANT.

SELECT SINGLE LGORT FROM MARD INTO @DATA(LV_LGORT) WHERE WERKS = @WA_FINAL-PLANT AND MATNR = @WA_FINAL-MATNR.
WA_SBIN-STGE_LOC       = LV_LGORT.
WA_SBIN1-STGE_LOC       = LV_LGORT.

WA_SBIN1-PLANT       = WA_FINAL-PLANT.
WA_SBIN1-STGE_BIN    = 'X'.


WA_VALUE-VAL_AREA      = WA_FINAL-PLANT.
WA_VALUEX-VAL_AREA      = WA_FINAL-PLANT.  "'X'.

wa_value-PLNDPRICE3 = wa_final-price3.
wa_valuex-PLNDPRICE3 = 'X'.

wa_value-PLNDPRDATE3 = wa_final-pdate.
wa_valuex-PLNDPRDATE3 = 'X'.


CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
  EXPORTING
    headdata                   = mat_head
        STORAGELOCATIONDATA            = WA_SBIN
     STORAGELOCATIONDATAX           = WA_SBIN1

   VALUATIONDATA              = wa_value
   VALUATIONDATAX             = wa_valuex
 IMPORTING
   RETURN                     = IT_RETURN
.

IF SY-SUBRC EQ 0.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*   EXPORTING
*     WAIT          =
*   IMPORTING
*     RETURN        =
            .
WRITE : IT_RETURN-MESSAGE.
ENDIF.

          .
 clear : wa_value, wa_valuex, mat_head, it_return , wa_sbin, wa_sbin1.

*endif.


* clear : wa_sbin, wa_sbin1, mat_head, it_return.
ENDLOOP.
*&---------------------------------------------------------------------*
*&      Form  GET_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form GET_FILE .

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
   I_LINE_HEADER              = 'X'
    i_tab_raw_data             = IT_RAW
    i_filename                 = P_FILE
  TABLES
    i_tab_converted_data       = GT_FINAL
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

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

  ls_data-field1 =  'Material'.
  ls_data-field2 =  'Plant'.
  ls_data-field3 =  'Planned price 3'.
  ls_data-field4 =  'Planned date'.
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
      SET PROPERTY OF shading 'COLORINDEX' = 6. " COLOUR - CHANGE NUMBER FOR DIFF COLOURS
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
