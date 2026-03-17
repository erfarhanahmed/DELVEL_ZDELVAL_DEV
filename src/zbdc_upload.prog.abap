*&---------------------------------------------------------------------*
*& Report ZBDC_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBDC_UPLOAD.
TYPES: BEGIN OF t_data,
  field1  TYPE string,
  field2  TYPE string,
*  field3  TYPE string,
*  field4  TYPE string,
*  field5  TYPE string,
*  field6  TYPE string,
*  field7  TYPE string,
*  field8  TYPE string,

END OF t_data.

 DATA : it_data TYPE STANDARD TABLE OF t_data,
        wa_data LIKE LINE OF it_data.
 DATA: application TYPE ole2_object,
      workbook TYPE ole2_object,
      sheet TYPE ole2_object,
      cells TYPE ole2_object,
      cell1 TYPE ole2_object,
      cell2 TYPE ole2_object,
      range TYPE ole2_object,
      font TYPE ole2_object,
      column TYPE ole2_object,
      shading TYPE ole2_object,
      border TYPE ole2_object.

 DATA: ld_colindx TYPE I,   "COLUMN INDEX
      ld_rowindx TYPE I.   "ROW INDEX


 FIELD-symbols: <fs>.


**ENDFORM.

*PERFORM fill_data.
*PERFORM download_data .


*form fill_data.
**START OF COLUMN NUMBERS
  wa_data-field1    = 'Material No'.
  wa_data-field2    = 'BOM Status'.
*  wa_data-field3    = 'Amount'.
*  wa_data-field4    = 'Unit'.
*  wa_data-field5    = 'Per'.
*  wa_data-field6    = 'UOM'.
*  wa_data-field7    = 'Valid from'.
*  wa_data-field8    = 'Valid to'.


  APPEND wa_data TO it_data.

  CREATE object application 'EXCEL.APPLICATION'.
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
    #1           = 1.
  CALL METHOD OF
  sheet
  'ACTIVATE'.
  SET PROPERTY OF sheet 'NAME' = 'ZBDC_UPLOAD'.


*ENDFORM.

*FORM download_data .

  ld_rowindx = 1. "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT it_data INTO wa_data.
    ld_rowindx = sy-tabix . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN
     "NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING,

*   FILL COLUMNS FOR CURRENT ROW
    CLEAR ld_colindx.
    DO.
      ASSIGN COMPONENT sy-INDEX OF STRUCTURE wa_data TO <fs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      ld_colindx = sy-INDEX.
      CALL METHOD OF
      sheet
      'CELLS' = cells
      EXPORTING
        #1      = ld_rowindx
        #2      = ld_colindx.
      SET PROPERTY OF cells 'VALUE' = <fs>.
    ENDDO.
  ENDLOOP.

*  ENDFORM.
