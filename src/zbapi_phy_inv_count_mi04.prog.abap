*&---------------------------------------------------------------------*
*& Report  ZBAPI_PHY_INV_COUNT_MI04
*&---------------------------------------------------------------------*

REPORT ZBAPI_PHY_INV_COUNT_MI04.

TABLES: sscrfields.

DATA : it_item            LIKE bapi_physinv_count_items OCCURS 0 WITH HEADER LINE,
       lt_serial          TYPE bapi_physinv_serialnumbers OCCURS 0 WITH HEADER LINE,
      wa_head             LIKE iikpf OCCURS 0 WITH HEADER LINE,
      fiscalyear          LIKE ikpf-gjahr OCCURS 0 WITH HEADER LINE,
      percentage_variance LIKE iikpf-abwei OCCURS 0 WITH HEADER LINE,
      count_date          LIKE iikpf-zldat OCCURS 0 WITH HEADER LINE,
      return              LIKE bapiret2 OCCURS 0 WITH HEADER LINE.

TYPES: trux_t_text_data(4096) TYPE c OCCURS 0.
DATA : it_raw TYPE trux_t_text_data.
DATA : int TYPE char01 .


DATA: BEGIN OF log OCCURS 0,
  index TYPE i,
  message LIKE return-message,
END OF log.

DATA : count TYPE i.

DATA : BEGIN OF head OCCURS 0,
  iblnr TYPE ikpf-iblnr,     "Physical Inventory Document
  gjahr TYPE ikpf-gjahr,     "Fiscal Year
  zldat TYPE ikpf-zldat,     "Date of last count
  abwei TYPE iikpf-abwei,
END OF head.

DATA : BEGIN OF item OCCURS 0,
  iblnr         TYPE ikpf-iblnr,     "Physical Inventory Document
  item          TYPE bapi_physinv_count_items-item,
  material      TYPE bapi_physinv_count_items-material,
  entry_qnt     TYPE bapi_physinv_count_items-entry_qnt,
  ENTRY_UOM     TYPE bapi_physinv_count_items-entry_uom,
END OF item.

DATA : BEGIN OF serial OCCURS 0,
  iblnr TYPE ikpf-iblnr,     "Physical Inventory Document
  item          TYPE bapi_physinv_count_items-item,
  material      TYPE bapi_physinv_count_items-material,
  serialnumbers TYPE bapi_physinv_serialnumbers-serialno,
END OF serial.
DATA: lv_lines TYPE i.
DATA : BEGIN OF ty_serial OCCURS 0,
   count TYPE i,
   serialnumbers TYPE bapi_physinv_serialnumbers-serialno,
END OF ty_serial.
 TYPES: BEGIN OF ty_output,
          text TYPE String,
          END OF ty_output.
 DATA : lt_output TYPE STANDARD TABLE OF ty_output,
        ls_output TYPE                   ty_output.


DATA : BEGIN OF itab3 OCCURS 0,
  iblnr         TYPE ikpf-iblnr,
  gjahr         TYPE ikpf-gjahr,
  zldat         TYPE ikpf-zldat,
  item          TYPE bapi_physinv_count_items-item,
  material      TYPE bapi_physinv_count_items-material,
  entry_qnt     TYPE bapi_physinv_count_items-entry_qnt,
  ENTRY_UOM     TYPE bapi_physinv_count_items-entry_uom,
  serialnumbers TYPE bapi_physinv_serialnumbers-serialno,
  abwei         TYPE iikpf-abwei,
END OF itab3.

SELECTION-SCREEN : BEGIN OF BLOCK frame01 WITH FRAME TITLE TEXT-001.
*  PARAMETERS     : plant TYPE ikpf-werks OBLIGATORY.
  PARAMETERS     : txtfile  LIKE rlgrap-filename .
SELECTION-SCREEN: END OF BLOCK frame01.

SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.


INITIALIZATION.
*Assign Text string To Button
w_button = 'Download Excel Template'.


AT SELECTION-SCREEN.
  if sscrfields = 'BUT1'.
PERFORM EXCEL_DOWNLOAD.
ENDIF.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR txtfile.

CALL FUNCTION 'F4_FILENAME'
EXPORTING
  program_name  = syst-cprog
  dynpro_number = syst-dynnr
  field_name    = ' '
IMPORTING
  file_name     = txtfile.

START-OF-SELECTION.
PERFORM frm_get_data.
PERFORM frm_create_requ.
END-OF-SELECTION.

*-----------upload data----------

FORM frm_get_data.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   i_field_seperator    = 'X'
    i_tab_raw_data       = it_raw
    i_line_header        = 'X'
    i_filename           = txtfile
  TABLES
    i_tab_converted_data = itab3[]
  EXCEPTIONS
    conversion_failed    = 1
    OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF .

ENDFORM.                    "FRM_GET_DATA


*&---------------------------------------------------------------------*
*&      Form  frm_create_requ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM frm_create_requ.

  SORT itab3 ASCENDING BY iblnr gjahr zldat item material.

  LOOP AT itab3.

    MOVE-CORRESPONDING itab3 TO head.
    APPEND head.

    MOVE-CORRESPONDING itab3 TO item.
    APPEND item.

    MOVE-CORRESPONDING itab3 TO serial.
    APPEND serial.

  ENDLOOP.
  SORT head ASCENDING BY iblnr gjahr.
  SORT item ASCENDING BY iblnr item.

  DELETE ADJACENT DUPLICATES FROM head COMPARING iblnr gjahr.
  DELETE ADJACENT DUPLICATES FROM item COMPARING iblnr item.
  DELETE serial WHERE serialnumbers IS INITIAL.

  LOOP AT head.
   REFRESH: it_item[],lt_serial[].
* Header Data
   CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = head-iblnr
    IMPORTING
      output = wa_head-iblnr.
   wa_head-gjahr = head-gjahr.
   wa_head-zldat = head-zldat.
   wa_head-abwei = head-abwei.
* Item Data
   LOOP AT item WHERE iblnr = head-iblnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = item-item
    IMPORTING
      output = it_item-item.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = item-material
    IMPORTING
      output = it_item-material.
     IF item-entry_qnt IS INITIAL.
       it_item-zero_count = 'X'.
     ELSE.
       it_item-entry_qnt = item-entry_qnt.
     ENDIF.
     it_item-entry_uom = ITEM-entry_uom.
* Serial Data
     LOOP AT serial WHERE iblnr = head-iblnr AND item = item-item.
       lt_serial-item        = serial-item.
       lt_serial-serialno    = serial-serialnumbers.
       APPEND lt_serial.
       CLEAR lt_serial.
     ENDLOOP.

     IF lt_serial[] IS NOT INITIAL.
       DESCRIBE TABLE lt_serial LINES lv_lines.
       it_item-entry_qnt = lv_lines.
       CLEAR lv_lines.
     ENDIF.
     APPEND it_item.
     CLEAR: serial,item,IT_ITEM.
     ENDLOOP.

     CALL FUNCTION 'BAPI_MATPHYSINV_COUNT'
     EXPORTING
       physinventory             = wa_head-iblnr
       fiscalyear                = wa_head-gjahr
       percentage_variance       = wa_head-abwei
       count_date                = wa_head-zldat
     TABLES
       items                     = it_item[]
       return                    = return
       serialnumbers             = lt_serial[]
*    EXTENSIONIN                 =
       .
     COMMIT WORK AND WAIT.

     SORT return[] ASCENDING BY type id number message_v1.
     DELETE ADJACENT DUPLICATES FROM return[] COMPARING type id number message_v1.
     LOOP AT return.
       CONCATENATE wa_head-iblnr wa_head-gjahr return-message INTO ls_output-text SEPARATED BY ':'.
       APPEND ls_output TO lt_output.
       CLEAR: ls_output,return.
     ENDLOOP.

  refresh return.
  CLEAR head.
  ENDLOOP.

LOOP AT lt_output INTO ls_output.
  WRITE:/ ls_output-TEXT.
ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXCEL_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM excel_download .
*IF sscrfields-ucomm EQ 'BUT1'.
*DATA: LT_EXCEL TYPE ZZEXCEL_TT.
*data: WA_DATA  like LINE OF LT_EXCEL.
*
*  WA_DATA-FIELD1  = 'Document No'.
*  WA_DATA-FIELD2  = 'Year'.
*  WA_DATA-FIELD3  = 'Date'.
*  WA_DATA-FIELD4  = 'Item'.
*  WA_DATA-FIELD5  = 'Material'.
*  WA_DATA-FIELD6  = 'Quantity'.
*  WA_DATA-FIELD7  = 'UoM'.
*  WA_DATA-FIELD8  = 'Serial No'.
*  WA_DATA-FIELD9  = 'Variance in %'.
*  APPEND wa_data to lt_excel.
**  SUBMIT zbp_uplaod_excel_c VIA SELECTION-SCREEN.
*
*  CALL FUNCTION 'ZZ_GET_EXCEL_TMPLT'
*    TABLES
*      lt_excel       = lt_excel
*            .
*
*ENDIF.

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

  CONSTANTS: row_max TYPE i VALUE 256.
  DATA: index TYPE i.
  DATA: ld_colindx TYPE i,   "COLUMN INDEX
        ld_rowindx TYPE i.   "ROW INDEX

  TYPES:BEGIN OF t_data,
          field1 TYPE string,
          field2 TYPE string,
          field3 TYPE string,
          field4 TYPE string,
          field5 TYPE string,
          field6 TYPE string,
          field7 TYPE string,
          field8 TYPE string,
          field9 TYPE string,
        END OF t_data.

  DATA: it_data TYPE STANDARD TABLE OF t_data,
        ls_data LIKE LINE OF it_data.

  FIELD-SYMBOLS: <fs>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
  ls_data-field1 =  'Document No'.
  ls_data-field2 =  'Year'.
  ls_data-field3 =  'Date'.
  ls_data-field4 =  'Item'.
  ls_data-field5 =  'Material'.
  ls_data-field6 =  'Quantity'.
  ls_data-field7 =  'UOM'.
*  ls_data-field8 =  'Serial No'.                         "COMMENTED BY GANGA 20.03.2019
*  ls_data-field9 =  'Variance %'.                        "COMMENTED BY GANGA 20.03.2019

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
      ASSIGN COMPONENT sy-index OF STRUCTURE ls_data TO <fs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      ld_colindx = sy-index.
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
    #2 = 7.   "COLUMN ACROSS

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
    #2 = 6.   "COLUMNS ACROSS

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
    sheet 'SAVEAS'
    EXPORTING
      #1 = 'C:\XK02.xls'     "FILENAME
      #2 = 1.                "FILEFORMAT

  FREE OBJECT sheet.
  FREE OBJECT workbook.
  FREE OBJECT application.

ENDFORM.
