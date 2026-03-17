*&---------------------------------------------------------------------*
*& Report ZBAPI_PHY_INV
*&---------------------------------------------------------------------*
*&
*         0. PROGRAM OWNER          : PRIMUS TECHSYSTEMS PVT LTD.
*         1. FS NO                  :
*         2. PROJECT                : WINDSOR MACHINES
*         3. PROGRAM NAME           : ZBAPI_PHY_INV
*         4. TRANS CODE             : ZMI10
*         5. MODULE NAME            : MM
*         7. CREATION DATE          : 25/03/2017
*         8. DEVELOPER NAME         : SUBODH DONGARE
*         9. FUNCTIONAL CONSULTANT  : Nikhil Ugale
*&---------------------------------------------------------------------*
*REPORT zbapi_phy_inv.
REPORT ZBAPI_PHY_INV_COUNT.
TABLES: sscrfields.

DATA: physinventory LIKE  ikpf-iblnr,
      fiscalyear LIKE  ikpf-gjahr,
      percentage_variance LIKE  iikpf-abwei,
      count_date LIKE  iikpf-zldat.

DATA: lt_head TYPE TABLE OF bapi_physinv_create_head,
      ls_head TYPE bapi_physinv_create_head,
      lt_items TYPE TABLE OF bapi_physinv_create_items,
      ls_items TYPE bapi_physinv_create_items,

      lt_items1 TYPE TABLE OF bapi_physinv_count_items,
      ls_items1 TYPE bapi_physinv_count_items,
      ls_head1             LIKE ikpf,

      lt_final TYPE STANDARD TABLE OF bapi_physinv_post_items,
      ls_final TYPE bapi_physinv_post_items,
      lt_return like bapiret2 occurs 0 WITH HEADER LINE,
      lt_return1 like bapiret2 occurs 0 WITH HEADER LINE,
      ls_return TYPE bapiret2,
      lt_serialnumbers TYPE STANDARD TABLE OF bapi_physinv_serialnumbers,
      ls_serialnumbers TYPE bapi_physinv_serialnumbers,
      lt_extensionin   TYPE STANDARD TABLE OF  bapiparex,
      ls_extensionin   TYPE bapiparex.

 TYPES: BEGIN OF ty_output,
          text TYPE String,
          END OF ty_output.
 DATA : lt_output TYPE STANDARD TABLE OF ty_output,
        ls_output TYPE                   ty_output.
 DATA : raw_data(4096) TYPE c occurs 0.
 DATA : count TYPE i.


      DATA : BEGIN OF iTEM OCCURS 0,
              sales_ord  TYPE bapi_physinv_create_items-sales_ord,
              s_ord_item TYPE bapi_physinv_create_items-s_ord_item,
              stge_loc   TYPE MARD-LGORT,
              material   TYPE bapi_physinv_create_items-material,
              END OF iTEM.

      DATA : BEGIN OF htab OCCURS 0,
        stge_loc    TYPE MARD-LGORT,
        doc_date    TYPE bapi_physinv_create_head-doc_date,
        plan_date   TYPE bapi_physinv_create_head-plan_date,
        plant       TYPE bapi_physinv_create_head-plant,
        END OF htab.

        DATA : BEGIN OF itab OCCURS 0,
          stge_loc   TYPE MARD-LGORT,
          material   TYPE bapi_physinv_create_items-material,
          END OF itab.


          DATA : BEGIN OF ftab OCCURS 0,
             doc_date    TYPE bapi_physinv_create_head-doc_date,
             plan_date   TYPE bapi_physinv_create_head-plan_date,
             plant       TYPE bapi_physinv_create_head-plant,
             stge_loc    TYPE bapi_physinv_create_head-stge_loc,
             material    TYPE bapi_physinv_create_items-material,
             END OF ftab.

*---------------------------------------------------------------------------------------------------------------------------------
 SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
   PARAMETERS : p_file TYPE rlgrap-filename.
   SELECTION-SCREEN : END OF BLOCK b1.


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
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

*BREAK primus.
CALL FUNCTION 'F4_FILENAME'
 EXPORTING
   program_name        = syst-cprog
*   dynpro_number       = syst-dynnr
   field_name          = ' '
 IMPORTING
   file_name           = p_file
          .
CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
   i_line_header              = 'X'
    i_tab_raw_data             = raw_data
    i_filename                 = p_file
  TABLES
    i_tab_converted_data       = ftab[]
 EXCEPTIONS
   conversion_failed          = 1
   OTHERS                     = 2
          .
IF sy-subrc <> 0.
*MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.


*-----------------------------------------------------------------------------------
START-OF-SELECTION.

*SORT ftab ASCENDING by spec_stock sales_ord s_ord_item stge_loc.        "COMMENTED BY GANGA 20.03.2019

LOOP AT ftab .
TRANSLATE ftab-stge_loc to UPPER CASE.
TRANSLATE ftab-plant to UPPER CASE.
    MOVE-CORRESPONDING ftab TO HTAB.
    APPEND HTAB.

    MOVE-CORRESPONDING ftab TO ITAB.
    APPEND ITAB.
    CLEAR: htab,itab,ftab.
ENDLOOP.

DELETE ADJACENT DUPLICATES FROM HTAB COMPARING ALL FIELDS.


LOOP AT htab.
*LOOP AT ftab.

  REFRESH lt_items.
  ls_head-doc_date  = htab-doc_date.
  ls_head-plan_date = htab-plan_date.
  ls_head-plant     = htab-plant.
  ls_head-stge_loc = htab-stge_loc.
  ls_head-post_block = 'X'.


*  LOOP AT itab WHERE sales_ord = HTAB-sales_ord AND s_ord_item = HTAB-s_ord_item AND stge_loc = HTAB-stge_loc.       "COMMENTED BY GANGA 20.03.2019
  LOOP AT itab WHERE  stge_loc = HTAB-stge_loc.
     COUNT = COUNT + 1.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = itab-material
    IMPORTING
      output = ls_items-material.

  LS_ITEMS-alt_unit   = 'X'.
  LS_ITEMS-stock_type = '1'.
  APPEND ls_items TO lt_items.
  Clear ls_items.

  IF COUNT = 333.

    CALL FUNCTION 'BAPI_MATPHYSINV_CREATE_MULT'
        EXPORTING
          head           = lS_head
*         MAXITEMS       =
        TABLES
          items          = lt_items
          return         = lt_return1
                .

     CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait          = 'X'.
*      IMPORTING
*        RETURN        =
*               .
   CLEAR COUNT.

   sort lt_return1[] ASCENDING by type id number message_v1.
   delete ADJACENT DUPLICATES FROM lt_return1[] COMPARING type id number message_v1.

LOOP AT lt_return1 INTO ls_return.                                                     "CHANGED BY GANGA 20.03.2019

 CALL FUNCTION 'FORMAT_MESSAGE'
EXPORTING
ID =  ls_return-ID
LANG = sy-langu
NO =  LS_return-NUMBER
V1 =  LS_return-MESSAGE_V1
V2 =  LS_return-MESSAGE_V2
V3 =  LS_return-MESSAGE_V3
V4 =  LS_return-MESSAGE_V4
IMPORTING
MSG = LS_OUTPUT-TEXT
EXCEPTIONS
NOT_FOUND = 1
OTHERS = 2.

IF SY-SUBRC <> 0.
MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4. "'-D'
ENDIF.

     APPEND ls_output TO lt_output.
     CLEAR ls_output.
   ENDLOOP.
   REFRESH : lt_items,LT_RETURN1.
   ENDIF.

  ENDLOOP.

   CALL FUNCTION 'BAPI_MATPHYSINV_CREATE_MULT'
      EXPORTING
        head           = lS_head
*       MAXITEMS       =
      TABLES
        items          = lt_items
        return         = lt_return1
              .
   CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait          = 'X'.
*    IMPORTING
*      RETURN        =
*             .

   sort lt_return1[] ASCENDING by type id number message_v1.
   delete ADJACENT DUPLICATES FROM lt_return1[] COMPARING type id number message_v1.

   LOOP AT lt_return1 INTO ls_return.                                                          "CHANGED BY GANGA 20.03.2019

 CALL FUNCTION 'FORMAT_MESSAGE'
EXPORTING
ID =  ls_return-ID
LANG = sy-langu
NO =  LS_return-NUMBER
V1 =  LS_return-MESSAGE_V1
V2 =  LS_return-MESSAGE_V2
V3 =  LS_return-MESSAGE_V3
V4 =  LS_return-MESSAGE_V4
IMPORTING
MSG = LS_OUTPUT-TEXT
EXCEPTIONS
NOT_FOUND = 1
OTHERS = 2.

IF SY-SUBRC <> 0.
MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4. "'-D'
ENDIF.

APPEND ls_output TO lt_output.
CLEAR ls_output.
ENDLOOP.

  CLEAR: LS_HEAD,LT_RETURN,lt_return1.
  REFRESH: lt_return,lt_return1.

ENDLOOP.

LOOP AT lt_output INTO ls_output.
  WRITE:/ ls_output-TEXT.
ENDLOOP.

*&---------------------------------------------------------------------*
*&      Form  EXCEL_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM excel_download .
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
*          field6 TYPE string,
*          field7 TYPE string,
*          field8 TYPE string,
*          field9 TYPE string,
        END OF t_data.

  DATA: it_data TYPE STANDARD TABLE OF t_data,
        ls_data LIKE LINE OF it_data.

  FIELD-SYMBOLS: <fs>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
  ls_data-field1 =  'Document Date'.
  ls_data-field2 =  'Planned Count Date'.
  ls_data-field3 =  'Plant'.
  ls_data-field4 =  'Storage Location'.
  ls_data-field5 =  'Material'.

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
