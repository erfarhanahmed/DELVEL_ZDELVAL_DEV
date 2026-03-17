*&---------------------------------------------------------------------*
*& Report ZMB1A_BDC
*&---------------------------------------------------------------------*
*& Report ZBAPI_MB1A                                             *
* 1.PROGRAM OWNER           : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : BDC FOR MB1A- MOVEMENT TYPE 202
* 3.PROGRAM NAME            : ZMB1A_BDC                        *
* 4.TRANS CODE              :                                    *
* 5.MODULE NAME             : MM.                                 *
* 6.REQUEST NO              : DEVK905872  PRIMUS:ABAP:GP:REQUEST FOR BAPI MB1A :                               *
* 7.CREATION DATE           : 14.03.2019.                              *
* 8.CREATED BY              : SAGAR DEV                          *
* 9.FUNCTIONAL CONSULTANT   : SHIVAJI                               *
* 10.BUSINESS OWNER         : DELVAL.
* 11.DESCRIPTION            : BDC FOR MB1A- MOVEMENT TYPE 201              *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

REPORT ZMB1A_202
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TABLES: sscrfields.
TYPE-POOLS truxs.
TYPES : BEGIN OF ty_file,
          bldat(010), "TYPE mkpf-bldat,                    " Document Date in Document
          budat(010), " TYPE mkpf-budat,                    " Posting Date in the Document
*          gm_code TYPE dd03p_d-fieldname,             " Component name
          matnr(018), " TYPE mseg-matnr,                    " Material NO
          werks(004), " TYPE mseg-werks,                    " Plant
          lgort(004), " TYPE mseg-lgort,                    " Storage Location
          erfmg(013), " TYPE mseg-erfmg,                    "Quantity
          bwart(004), "TYPE mseg-bwart,                    "Movement type
          kostl(010), "TYPE mseg-kostl,                    "Cost Center
          saknr(010), "TYPE mseg-sakto,                    "GL

        END OF ty_file.

***************************************************************
*& Data Declaration
***************************************************************

DATA: it_message TYPE STANDARD TABLE OF bdcmsgcoll,               "Internal table and work area to give msg
      wa_message TYPE bdcmsgcoll.
DATA: it_message1 TYPE STANDARD TABLE OF bdcmsgcoll,               "Internal table and work area to give msg
      wa_message1 TYPE bdcmsgcoll.

DATA :it_bdcdata TYPE TABLE OF bdcdata,             ""internal table and work area to store data from internal table
      wa_bdcdata TYPE bdcdata.

DATA : gt_file TYPE STANDARD TABLE OF ty_file,    "internal table and work area to store data from excel
       gs_file TYPE ty_file,
       lv_msg TYPE string.

DATA :it_raw_data TYPE TRUXS_T_TEXT_DATA,
      opt         LIKE ctu_params.
DATA : lv_bldat(10),                                    "to give date in dd.mm.yyyy format
       lv_budat(10).                                    "to give date in dd.mm.yyyy format
DATA: l_message(255) TYPE c .
*************************** Excel Download Declaration********************************
TYPES: BEGIN OF t_data,
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

DATA : it_data TYPE STANDARD TABLE OF t_data,
       wa_data LIKE LINE OF it_data.
FIELD-SYMBOLS: <fs>.
***--------------------------- Excel Download Declaration -------------------------
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
DATA index TYPE i.
DATA: ld_colindx TYPE i,   "COLUMN INDEX
      ld_rowindx TYPE i.


********************Selection screen**********************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename ,
             mode   TYPE ctu_params-dismode DEFAULT 'N' AS LISTBOX VISIBLE LENGTH 21.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.

***Initializaion
INITIALIZATION.
  w_button = 'Download Excel Template'.                            "to download exel file

AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'BUT1' .
    PERFORM fill_data.
    PERFORM download_data.
    PERFORM modify_cells.
    PERFORM cell_border.

  ENDIF.


*AT SELECTION-SCREEN.
  PERFORM file_validation.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_file.


START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = it_raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_file
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  opt-dismode = mode.
  opt-defsize = 'X'.
  opt-updmode = 'S'.

  LOOP AT gt_file INTO gs_file.
    REFRESH it_bdcdata.


*    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
*      EXPORTING
*        input  = gs_file-bldat
*      IMPORTING
*        output = lv_bldat.
    LV_BLDAT = gs_file-bldat.
*    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
*      EXPORTING
*        input  = gs_file-budat
*      IMPORTING
*        output = lv_budat.
lv_budat = gs_file-budat.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = gs_file-kostl
      IMPORTING
        output = gs_file-kostl.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = gs_file-saknr
      IMPORTING
        output = gs_file-saknr.


    PERFORM bdc_dynpro      USING 'SAPMM07M' '0400'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RM07M-LGORT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'MKPF-BLDAT'
*                              '14.03.2019'.
                                   lv_bldat.                  "gs_file-bldat.
    PERFORM bdc_field       USING 'MKPF-BUDAT'
*                              '14.03.2019'.
                                   lv_budat.                    "gs_file-budat.
    PERFORM bdc_field       USING 'RM07M-BWARTWA'
                                  '202'.
    PERFORM bdc_field       USING 'RM07M-WERKS'
*                              'pl01'.
                                   gs_file-werks.
    PERFORM bdc_field       USING 'RM07M-LGORT'
*                              'rm01'.
                                   gs_file-lgort.
    PERFORM bdc_field       USING 'XFULL'
                                  'X'.
    PERFORM bdc_field       USING 'RM07M-WVERS2'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPMM07M' '0421'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MSEG-ERFMG(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'MSEGK-KONTO'
*                              '620030'.
                                   gs_file-saknr.
    PERFORM bdc_field       USING 'MSEG-MATNR(01)'
*                              'CASTING-A-101'.
                                   gs_file-matnr.
    PERFORM bdc_field       USING 'MSEG-ERFMG(01)'
*                              '1'.
                                   gs_file-erfmg..
    PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COBL-KOSTL'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTE'.
    PERFORM bdc_field       USING 'COBL-KOSTL'
*                              '4000130'.
                                   gs_file-kostl.
    PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COBL-KOSTL'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTE'.
*perform bdc_field       using 'COBL-KOSTL'
*                              '4000130'.
    PERFORM bdc_dynpro      USING 'SAPMM07M' '0421'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MSEG-ERFMG(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
    PERFORM bdc_field       USING 'DKACB-FMORE'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COBL-KOSTL'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTE'.
*BREAK primus.
    CALL TRANSACTION 'MB1A' USING it_bdcdata
                            MODE opt
                            UPDATE 'S'
                            MESSAGES INTO it_message.
*break primus.

    CLEAR : lv_budat,lv_bldat.
  ENDLOOP.


loop at it_message INTO wa_message.
  append wa_message to it_message1.
  endloop.

loop at it_message1 INTO wa_message1.

 CALL FUNCTION 'FORMAT_MESSAGE'
EXPORTING
ID =  wa_message1-MSGID
LANG = sy-langu
NO =  wa_message1-MSGNR
V1 =  wa_message1-MSGV1
V2 =  wa_message1-MSGV2
V3 =  wa_message1-MSGV3
V4 =  wa_message1-MSGV4
IMPORTING
MSG = L_MESSAGE
EXCEPTIONS
NOT_FOUND = 1
OTHERS = 2.

IF SY-SUBRC <> 0.
MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4. "'-D'
ENDIF.

WRITE : l_message.
 endloop.
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR wa_bdcdata.
  wa_bdcdata-program  = program.
  wa_bdcdata-dynpro   = dynpro.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF fval <> nodata.
  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = fnam.
  wa_bdcdata-fval = fval.
  CONDENSE wa_bdcdata-fval.
  APPEND wa_bdcdata TO it_bdcdata.
*  ENDIF.
ENDFORM.                    "BDC_FIELD
*&---------------------------------------------------------------------*
*&      Form  FILE_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM file_validation .
  IF p_file IS INITIAL.
    MESSAGE 'Please enter filename' TYPE sy-abcde+4(1) DISPLAY LIKE sy-abcde+18(1).
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.                    " FILE_VALIDATION

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_data .
***START OF COLUMN NUMBERS
  REFRESH it_data.

  wa_data-field1  = 'Document Date'.
  wa_data-field2  = 'Posting Date'.
  wa_data-field3  = 'Material NO'.
  wa_data-field4  = 'Plant'.
  wa_data-field5  = 'Storage Location'.
  wa_data-field6  = 'Quantity'.
  wa_data-field7  = 'Movement type'.
  wa_data-field8  = 'Cost Center'.
  wa_data-field9  = 'GL Account'.

  APPEND wa_data TO it_data.

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
    #1           = 1.
  CALL METHOD OF
    sheet
    'ACTIVATE'.
  SET PROPERTY OF sheet 'NAME' = 'Data Upload For Ztable'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_data .
  CLEAR ld_rowindx.
  ld_rowindx = 1. "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT it_data INTO wa_data.
    ld_rowindx = sy-tabix . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
    CLEAR ld_colindx.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE wa_data TO <fs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      ld_colindx = sy-index.
      CALL METHOD OF
      sheet
      'CELLS' = cells
      EXPORTING
        #1      = ld_rowindx
        #2      = ld_colindx.
      SET PROPERTY OF cells 'VALUE' = <fs>.
    ENDDO.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_CELLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify_cells .

***********************************************
****FORMATTING OF COLUMN NUMBER ROW ***********
***********************************************
  CALL METHOD OF
  application
  'CELLS'     = cell1
  EXPORTING
    #1          = 1     "DOWN
    #2          = 1.    "ACROSS
*END OF RANGE CELL
  CALL METHOD OF
  application
  'CELLS'     = cell2
  EXPORTING
    #1          = 1     "DOWN
    #2          = 51.   "ACROSS

  CALL METHOD OF
  application
  'RANGE'     = range
  EXPORTING
    #1          = cell1
    #2          = cell2.
***********************************************
* MODIFY PROPERTIES OF CELL RANGE             *
***********************************************
* SET FONT DETAILS OF RANGE

  GET PROPERTY OF range 'FONT' = font.
  SET PROPERTY OF font 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
  CALL METHOD OF
    range
      'INTERIOR' = shading.
  SET PROPERTY OF shading 'COLORINDEX' = 0. "COLOUR - CHANGE NUMBER FOR DIFF COLOURS
  SET PROPERTY OF shading 'PATTERN' = 1. "PATTERN - SOLID, STRIPED ETC
  FREE OBJECT shading.

***********************************************
*****END OF FORMATTING OF COLUMN NUMBER ROW****
***********************************************

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CELL_BORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cell_border .
*************************************************
*** MODIFY PROPERTIES OF CELL RANGE             *
*************************************************

  FREE range.
  CALL METHOD OF application 'CELLS' = cell1  "START CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

  CALL METHOD OF application 'CELLS' = cell2 "END CELL
  EXPORTING
    #1 = 1    "DOWN
    #2 = 51.   "ACROSS

  CALL METHOD OF
  application
  'RANGE'     = range
  EXPORTING
    #1          = cell1
    #2          = cell2.


* SET BORDER PROPERTIES OF RANGE
  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1        = '1'.  "LEFT
  SET PROPERTY OF border 'LINESTYLE' = '1'. "LINE STYLE SOLID, DASHED...
  SET PROPERTY OF border 'WEIGHT' = 1.                      "MAX = 4
  FREE OBJECT border.

  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1        = '2'.  "RIGHT
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT border.

  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1        = '3'.   "TOP
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT border.

  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1        = '4'.   "BOTTOM
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT border.

* OVERWITES ALL CELL VALUES IN RANGE TO EQUAL 'TEST'
* SET PROPERTY OF RANGE    'VALUE' = 'TEST'.


***********************************************
* SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *
***********************************************
  CALL METHOD OF
    application
      'COLUMNS' = column.
  CALL METHOD OF
    column
    'AUTOFIT'.

  FREE OBJECT column.

***********************************************
* SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME*
*************************************#*********
  CALL METHOD OF
    sheet
    'SAVEAS'
    EXPORTING
      #1 = 'D:\SAP_DATA\Upload_ztable_Template.XLS'     "FILENAME
**       #1       = '/home/lalit/Upload_FERT_Finished_Material.XLS'     "FILENAME
      #2 = 1.                          "FILEFORMAT

  FREE OBJECT sheet.
  FREE OBJECT workbook.
  FREE OBJECT application.
ENDFORM.
