*&---------------------------------------------------------------------*
*&  Include           ZFIM_C03_ASSET_BAL_EXCEL_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZFIM_C03_ASSET_BAL_EXCEL_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZFIM_C03_ASSET_BAL_EXCEL_TOP
*&---------------------------------------------------------------------*
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


DATA: ld_colindx TYPE i,   "column index
      ld_rowindx TYPE i.   "row index

TYPES: BEGIN OF t_data,
         field1  TYPE string,
         field2  TYPE string,
         field3  TYPE string,
         field4  TYPE string,
         field5  TYPE string,
         field6  TYPE string,
         field7  TYPE string,
         field8  TYPE string,
         field9  TYPE string,
         field10 TYPE string,

         field11 TYPE string,
         field12 TYPE string,
         field13 TYPE string,
         field14 TYPE string,
         field15 TYPE string,
         field16 TYPE string,
         field17 TYPE string,
         field18 TYPE string,
         field19 TYPE string,
         field20 TYPE string,

         field21 TYPE string,
         field22 TYPE string,
         field23 TYPE string,
         field24 TYPE string,
         field25 TYPE string,
         field26 TYPE string,
         field27 TYPE string,
         field28 TYPE string,
         field29 TYPE string,
         field30 TYPE string,
         field31 TYPE string,
         field32 TYPE string,
         field33 TYPE string,
         field34 TYPE string,
         field35 TYPE string,
         field36 TYPE string,
         field37 TYPE string,
         field38 TYPE string,
         field39 TYPE string,
         field40 TYPE string,
         field41 TYPE string,
         field42 TYPE string,
         field43 TYPE string,
         field44 TYPE string,
         field45 TYPE string,
         field46 TYPE string,
       END OF t_data.

DATA: it_header1 TYPE STANDARD TABLE OF t_data,
      wa_header1 LIKE LINE OF it_header1,
      it_header2 TYPE STANDARD TABLE OF t_data,
      wa_header2 LIKE LINE OF it_header2.


FIELD-SYMBOLS: <fs> TYPE any.
