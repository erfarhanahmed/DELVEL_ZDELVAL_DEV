*&---------------------------------------------------------------------*
*& Report ZMM_BDC_ME12_STD_EXCEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_BDC_ME12_STD_EXCEL.


INCLUDE zfim_c03_asset_bal_excel_top.

START-OF-SELECTION.
  PERFORM fill_data.
  PERFORM download_data.
  PERFORM modify_cells.
  PERFORM cell_border.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_data.

*** Key
  wa_header2-field1 = 'Purchase Org'.
*** General Data
  wa_header2-field2 = 'Plant'.
  wa_header2-field3 = 'Info Record No.'.
  wa_header2-field4 = 'Date'.
  wa_header2-field5 = 'Value'.
  wa_header2-field6 = 'Upper Limit'.

  APPEND wa_header2 TO it_header2.

  CREATE OBJECT application 'excel.application'.
  SET PROPERTY OF application 'visible' = 1.
  CALL METHOD OF
    application
      'Workbooks' = workbook.

* Create new worksheet
  SET PROPERTY OF application 'SheetsInNewWorkbook' = 1.
  CALL METHOD OF
    workbook
    'Add'.

* Create first Excel Sheet
  CALL METHOD OF
    application
    'Worksheets' = sheet
    EXPORTING
    #1 = 1.
  CALL METHOD OF
    sheet
    'Activate'.
  SET PROPERTY OF sheet 'Name' = 'Info record Change'.
ENDFORM.                    "FILL_DATA


*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM download_data.

***********************************************
* Download second header data to excel spreadsheet   *
***********************************************
*   ld_rowindx = 2.
  LOOP AT it_header2 INTO wa_header2.
*Use sy-tabix for row index
    ld_rowindx = sy-tabix."  + 1.
*    ld_rowindx = sy-tabix.

*   Fill columns for current row
    CLEAR ld_colindx.
    DO.
*     Assign <fs> to table columns
      ASSIGN COMPONENT sy-index OF STRUCTURE wa_header2 TO <fs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      ld_colindx = sy-index.
      CALL METHOD OF
        sheet
        'Cells' = cells
        EXPORTING
        #1 = ld_rowindx
        #2 = ld_colindx.
      SET PROPERTY OF cells 'Value' = <fs>.
    ENDDO.
  ENDLOOP.


***********************************************
* Download 3rd header to excel spreadsheet          *
***********************************************
  CALL METHOD OF
    application
    'Worksheets' = sheet
    EXPORTING
    #1 = 2.

  CLEAR: ld_rowindx, ld_colindx.

ENDFORM.                    "DOWNLOAD_DATA

*&---------------------------------------------------------------------*
*&      Form  MODIFY_CELLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM modify_cells.
***********************************************
* Capture range of cells to be modified       *
***********************************************

*****start merging of cells from row 1 of column 1 to column 1

*Start of range Cell
  CALL METHOD OF
      application
      'Cells'     = cell1
    EXPORTING
      #1          = 1     "down
      #2          = 1.    "across
*End of range Cell
  CALL METHOD OF
      application
      'Cells'     = cell2
    EXPORTING
      #1          = 1     "down
      #2          = 6.   "across

  CALL METHOD OF
    application
    'Range' = range
    EXPORTING
    #1 = cell1
    #2 = cell2.

*  SET PROPERTY OF range 'Mergecells' = 1 .
***********************************************
* Modify properties of cell range             *
***********************************************
* SET FONT DETAILS of range
  GET PROPERTY OF range 'Font' = font.
  SET PROPERTY OF font 'Bold' = 1.
  SET PROPERTY OF font 'Size' = 10.

* SET CELL SHADING PROPERTIES of range
  CALL METHOD OF
    range
      'INTERIOR' = shading.
  SET PROPERTY OF shading 'ColorIndex' = 35. "colour - change number for diff colours
  SET PROPERTY OF shading 'Pattern' = 1. "pattern - solid, striped etc
  FREE OBJECT shading.
*****End merging of cells from row 1 of column 1 to column 1

ENDFORM.                    "MODIFY_CELLS


*&---------------------------------------------------------------------*
*&      Form  CELL_BORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM cell_border.
*************************************************
*** Modify properties of cell range             *
*************************************************

* CHANGE RANGE VALUES - include all lines (1,2 and 3)
  FREE range.
  CALL METHOD OF application 'Cells' = cell1  "start cell
    EXPORTING
      #1 = 1     "down
      #2 = 1.    "across
*
  CALL METHOD OF application 'Cells' = cell2 "end cell
    EXPORTING
      #1 = 1    "down
      #2 = 6.   "across

  CALL METHOD OF
    application
    'Range' = range
    EXPORTING
    #1 = cell1
    #2 = cell2.

* SET BORDER PROPERTIES of range
  CALL METHOD OF
    range
    'BORDERS' = border
    EXPORTING
    #1 = '1'.  "left
  SET PROPERTY OF border 'LineStyle' = '1'. "line style solid, dashed...
  SET PROPERTY OF border 'WEIGHT' = 1.                      "max = 4
  FREE OBJECT border.

  CALL METHOD OF
    range
    'BORDERS' = border
    EXPORTING
    #1 = '2'.  "right
  SET PROPERTY OF border 'LineStyle' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "max = 4
  FREE OBJECT border.

  CALL METHOD OF
    range
    'BORDERS' = border
    EXPORTING
    #1 = '3'.   "top
  SET PROPERTY OF border 'LineStyle' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "max = 4
  FREE OBJECT border.

  CALL METHOD OF
    range
    'BORDERS' = border
    EXPORTING
    #1 = '4'.   "bottom
  SET PROPERTY OF border 'LineStyle' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "max = 4
  FREE OBJECT border.

* Overwites all cell values in range to equal 'test'
* SET PROPERTY OF range    'VALUE' = 'test'.


***********************************************
* Set Columns to auto fit to width of text    *
***********************************************
  CALL METHOD OF
    application
      'Columns' = column.
  CALL METHOD OF
    column
    'Autofit'.

  FREE OBJECT column.

***********************************************
* Save excel speadsheet to particular filename*
*************************************?*********
  CALL METHOD OF
    sheet
    'SaveAs'
    EXPORTING
      #1 = 'D:\Inforecord_change.xls'     "filename
      #2 = 1.                          "fileFormat

  FREE OBJECT sheet.
  FREE OBJECT workbook.
  FREE OBJECT application.

*  Closes excel window, data is lost if not saved
*  SET PROPERTY OF application 'visible' = 0.
*  call method of workbook 'CLOSE'.
*  call method of excel 'QUIT'.

ENDFORM.                    "CELL_BORDER
