*&---------------------------------------------------------------------*
*& Report ZAP_CHANGE_SALES_ORDER_VA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zap_change_sales_order_va02.
TYPE-POOLS : slis.
TYPES : BEGIN OF ty_final,
          salesdocno TYPE  bapivbeln-vbeln,             " Sales Document no
          sales_org  TYPE  bapisdh1-sales_org,         " Sales Organisation
          distr_chan TYPE  bapisdh1-distr_chan,        " Distribution channel
          division   TYPE  bapisdh1-division,          " Division
          item_no    TYPE  bapischdl-itm_number,        " Item No
          sch_no     TYPE  bapischdl-sched_line,        " Schedule line no
          first_date TYPE  bapischdl-req_date,          " First date
        END OF ty_final.
DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.

TYPES : BEGIN OF header,
          sales_org  TYPE  bapisdh1-sales_org,         " Sales Organisation
          distr_chan TYPE  bapisdh1-distr_chan,         " Distribution channel
          division   TYPE  bapisdh1-division,         " Division
        END OF header.
TYPES : BEGIN OF sch_item,
          item_no    TYPE bapischdl-itm_number,       " Item No
          sch_no     TYPE bapischdl-sched_line,         " Schedule line no
          first_date TYPE bapischdl-req_date,         " First date
        END OF sch_item.
DATA : wa_header   TYPE header,
       it_sch_item TYPE TABLE OF sch_item,
       wa_sch_item TYPE sch_item.
TYPES : BEGIN OF ty_item,
          salesdocno TYPE vbeln,
          itm_number TYPE bapischdl-itm_number,
          sched_line TYPE bapischdl-sched_line,
          req_date   TYPE bapischdl-req_date,
        END OF ty_item.
DATA : it_item TYPE TABLE OF ty_item,
       wa_item TYPE ty_item.

DATA : raw_data(4096) TYPE c OCCURS 0.
DATA : salesdocument   TYPE bapivbeln-vbeln,       " Sales Document no
       wa_header_data  TYPE bapisdh1,              " Work area for header data
       wa_header_datax TYPE bapisdh1x,             " Work area for update structure
       it_sch_line     TYPE TABLE OF bapischdl,    " Internal table for schedule line data
       wa_sch_line     TYPE bapischdl,             " Work area for schedule line data
       it_sch_linex    TYPE TABLE OF bapischdlx,   " Internal table for schedule line data update structure
       wa_sch_linex    TYPE  bapischdlx,           " Work area for schedule line data update structure
       return          LIKE bapiret2  OCCURS 0 WITH HEADER LINE.
*--------------Output table-------------------
TYPES : BEGIN OF ty_output,
        so_no TYPE ebeln,
        msg(150) TYPE c,
  END OF ty_output.

data : it_output TYPE TABLE OF ty_output,
       wa_output TYPE ty_output,
       it_fcat TYPE  slis_t_fieldcat_alv,
       wa_fcat TYPE  slis_fieldcat_alv.
*--------------------------------------------------------------------*
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS : file TYPE rlgrap-filename.
SELECTION-SCREEN : END OF BLOCK b1.
SELECTION-SCREEN : PUSHBUTTON 2(20) but1 USER-COMMAND CMD.
at SELECTION-SCREEN.

  if sy-ucomm = 'CMD'.
    PERFORM download_excel.
    ENDIF.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name = syst-cprog
    IMPORTING
      file_name    = file.
  IF sy-subrc <> 0.
    MESSAGE 'File format does not support...' TYPE 'E'.
  ENDIF.
INITIALIZATION.
but1 = 'Download Excel'.
START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = 'X'
      i_tab_raw_data       = raw_data
      i_filename           = file
    TABLES
      i_tab_converted_data = it_final[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Problem occurs during convertion data' TYPE 'E'.
  ENDIF.
*  BREAK primus.
*----------------Differentiate item data from header----------------
  LOOP AT it_final INTO wa_final.
    MOVE wa_final-salesdocno TO wa_item-salesdocno.
    MOVE wa_final-item_no    TO wa_item-itm_number.
    MOVE wa_final-sch_no     TO wa_item-sched_line.
    MOVE wa_final-first_date TO wa_item-req_date.
    APPEND wa_item TO it_item.
    CLEAR wa_item.
  ENDLOOP.
*--------------------------------------------------------------------*
  LOOP AT it_final INTO wa_final.
*--------------Header data--------------------------------------------

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_final-salesdocno
      IMPORTING
        output = salesdocument.
********************added by jyoti on 26.08.2024**********************
    select SINGLE * FROM vbak INTO @data(wa_vbak)
      where vbeln = @salesdocument.
**********************************************************************
      IF WA_VBAK-VKORG = wa_final-sales_org.
    MOVE wa_final-sales_org  TO  wa_header_data-sales_org.
      ELSE.
      return-type = 'E'.
      wa_output-msg = 'SALES ORGANIZATION DOES NOT MATCH'.
      APPEND wa_output to it_output.
      clear wa_output.
    ENDIF.
    IF WA_VBAK-VTWEG = wa_final-distr_chan.
    MOVE wa_final-distr_chan TO  wa_header_data-distr_chan.
    ELSE.
      return-type = 'E'.
      wa_output-msg = 'DISTRIBUTION CHANNEL DOES NOT MATCH'.
      APPEND wa_output to it_output.
      clear wa_output.
    ENDIF.
      IF WA_VBAK-SPART = wa_final-division.
    MOVE wa_final-division   TO  wa_header_data-division.
    ELSE.
      return-type = 'E'.
      wa_output-msg = 'DIVISION DOES NOT MATCH'.
      APPEND wa_output to it_output.
      clear wa_output.
    ENDIF.
 IF return-type NE 'E'."ADDED BY JYOTI ON 26.08.2024
    MOVE 'U'                 TO  wa_header_datax-updateflag.
    MOVE wa_final-sales_org  TO  wa_header_datax-sales_org.
    MOVE wa_final-distr_chan TO  wa_header_datax-distr_chan.
    MOVE wa_final-division   TO  wa_header_datax-division.
*--------------------------------------------------------------------*
*--------------Schedule line data--------------------------------------

    LOOP AT it_item INTO wa_item WHERE salesdocno = wa_final-salesdocno
                                      AND itm_number = wa_final-ITEM_NO.
      MOVE wa_item-itm_number    TO   wa_sch_line-itm_number.
      MOVE wa_item-sched_line    TO   wa_sch_line-sched_line.
      MOVE wa_item-req_date      TO   wa_sch_line-req_date.
      APPEND wa_sch_line TO it_sch_line.
      CLEAR wa_sch_line.

      MOVE  wa_item-itm_number TO wa_sch_linex-itm_number.
      MOVE  wa_item-sched_line TO wa_sch_linex-sched_line.
      MOVE 'U' TO wa_sch_linex-updateflag.
      MOVE 'X' TO wa_sch_linex-req_date.
      APPEND wa_sch_linex TO it_sch_linex.
      CLEAR wa_sch_linex.
    ENDLOOP.
*--------------------------------------------------------------------*
*IF  return-type ne 'E'.
    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = salesdocument
        order_header_in  = wa_header_data
        order_header_inx = wa_header_datax
      TABLES
        return           = return[]
        schedule_lines   = it_sch_line
        schedule_linesx  = it_sch_linex.

*BREAK primus.
  DELETE return[] WHERE NUMBER <> '311'.
  READ TABLE return INDEX 1.
  if return-type = 'S'.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    wa_output-msg = return-message.
    APPEND wa_output to it_output.
    clear wa_output.
    ENDIF.
    IF sy-subrc = 0.
      CLEAR : salesdocument, wa_header_data, wa_header_datax, it_sch_line, it_sch_linex, wa_final.
    ENDIF.
ENDIF.
CLEAR :  return-type .
  ENDLOOP.
  wa_fcat-col_pos = '1'.
  wa_fcat-seltext_m = 'Message'.
  wa_fcat-tabname = 'IT_OUTPUT'.
  wa_fcat-fieldname = 'MSG'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*  BREAK primus.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
     I_CALLBACK_PROGRAM                = sy-repid
*     I_STRUCTURE_NAME                  = 'BAPIRET2'
*     I_DEFAULT                         = 'X'
     I_SAVE                            = 'X'
     IT_FIELDCAT                       = it_fcat[]
    TABLES
      t_outtab                          = it_output[]
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2.
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
          field6  TYPE string,
          field7  TYPE string,
        END OF t_data.

  DATA: it_data TYPE STANDARD TABLE OF t_data,
        ls_data LIKE LINE OF it_data.

  FIELD-SYMBOLS: <fs>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*

  ls_data-field1 =  'Sales Order No'.
  ls_data-field2 =  'Sales Org'.
  ls_data-field3 =  'Dist Channel'.
  ls_data-field4 =  'Division'.
  ls_data-field5 =  'Item No'.
  ls_data-field6 =  'Schedule Line No'.
  ls_data-field7 = 'First Date'.
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
  SET PROPERTY OF sheet 'NAME' = 'Sales Order Change'.

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
        #2 = 7.   "COLUMNS ACROSS

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
        #1 = 'C:\VA02.xls'     "FILENAME
        #2 = 1.                "FILEFORMAT

      FREE OBJECT sheet.
      FREE OBJECT workbook.
      FREE OBJECT application.

      " CELL_BORDER

ENDFORM.
