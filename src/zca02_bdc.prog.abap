*&---------------------------------------------------------------------*
*& Report ZCA02_BDC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zca02_bdc.

TABLES: sscrfields.
TYPE-POOLS: truxs.

*Str. Declaration
TYPES : BEGIN OF ty_final,
          matnr TYPE string, "Material
          werks TYPE string, "Plant
          vgw01 TYPE string, "Minuts
          sttag TYPE string, "Key date
          plnnr TYPE plnnr,
        END OF ty_final.

TYPES: BEGIN OF t_data,
         field1 TYPE string,
         field2 TYPE string,
         field3 TYPE string,
         field4 TYPE string,
       END OF t_data.

*Data Declaration
DATA : gt_final    TYPE TABLE OF ty_final,
       gs_final    TYPE ty_final,
       lv_date(10),
       itraw(4096) TYPE c OCCURS 0,
       bdcdata     TYPE STANDARD TABLE OF bdcdata WITH HEADER LINE.
DATA: it_msg TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
      wa_msg TYPE bdcmsgcoll.

DATA: it_msg1 TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
      wa_msg1 TYPE bdcmsgcoll.

DATA : v_msg TYPE string.
DATA: w_textout  LIKE t100-text.

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
DATA : it_data TYPE STANDARD TABLE OF t_data,
       wa_data LIKE LINE OF it_data.
***--------End Excel Download Declaration-------------
FIELD-SYMBOLS: <fs>.

**Selection Screen

SELECTION-SCREEN : BEGIN OF BLOCK s1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_file TYPE  rlgrap-filename.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN : END OF BLOCK s1.

INITIALIZATION.
  w_button = 'Download Excel Template'.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'BUT1' .
    PERFORM fill_data.
    PERFORM download_data.
    PERFORM modify_cells.
    PERFORM cell_border.

  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
    IMPORTING
      file_name     = p_file.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = 'X'
      i_tab_raw_data       = itraw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_final[]
    EXCEPTIONS
      conversion_failed    = 1.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

START-OF-SELECTION.

  LOOP AT gt_final INTO gs_final.
    REFRESH BDCDATA[].
    PERFORM bdc_dynpro      USING 'SAPLCPDI' '1010'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RC271-PLNNR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'RC27M-MATNR'
                                  gs_final-matnr. "'VALVE101'.
    PERFORM bdc_field       USING 'RC27M-WERKS'
                                  gs_final-werks . "'PL01'.
    PERFORM bdc_field       USING 'RC271-PLNNR'
                                  gs_final-plnnr.

    PERFORM bdc_field       USING 'RC271-STTAG'
                                  gs_final-sttag. "'29.03.2019'.
    PERFORM bdc_field       USING 'RC271-PLNAL'
                                  ' '.



    PERFORM bdc_dynpro      USING 'SAPLCPDI' '1400'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'PLPOD-VGW01(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'RC27X-ENTRY_ACT'
                                  '1'.
    PERFORM bdc_field       USING 'PLPOD-VGW01(01)'
                                  gs_final-vgw01 . "'2'.
    PERFORM bdc_dynpro      USING 'SAPLCPDI' '1400'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'PLPOD-VGW01(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
    PERFORM bdc_field       USING 'RC27X-ENTRY_ACT'
                                  '1'.
    SET PARAMETER ID 'PLN' FIELD gs_final-plnnr.
    CALL TRANSACTION 'CA02'
       USING bdcdata MODE 'N'
             UPDATE 'S' MESSAGES INTO  it_msg.
    .

    IF  it_msg IS INITIAL.
      CONCATENATE 'Routing was saved for material'  gs_final-matnr INTO wa_msg-msgv1 SEPARATED BY space.
      APPEND wa_msg TO it_msg1.


    ELSE.

      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = sy-msgid
          lang      = '-D'
          no        = sy-msgno
          v1        = sy-msgv1
          v2        = sy-msgv2
          v3        = sy-msgv3
          v4        = sy-msgv4
        IMPORTING
          msg       = v_msg
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      wa_msg1-msgv1 = v_msg.
      APPEND wa_msg1 TO it_msg1.
      CLEAR : wa_msg1,v_msg.
      REFRESH it_msg.
    ENDIF.
  ENDLOOP.
*perform close_group.
  LOOP AT it_msg1 INTO wa_msg1.


    WRITE: / wa_msg1-msgv1 , wa_msg1-msgv2 , wa_msg1-msgv3 , wa_msg1-msgv4.

  ENDLOOP.

FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval <> space.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.                    "BDC_FIELD
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

  wa_data-field1  = 'Matreial'.                                   "EORD-MATNR
  wa_data-field2  = 'Plant'.                                      "EORD-WERKS
  wa_data-field3  = 'Minuts'.                                 "EORD-VDATU
  wa_data-field4  = 'Key Date'.                                   "EORD-BDATU                                   "EORD-LIFNR

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
  SET PROPERTY OF sheet 'NAME' = 'EXCEL Upload'.

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
      #1 = 'D:\SAP_DATA\CA02_Template.XLS'     "FILENAME
**       #1       = '/home/lalit/Upload_FERT_Finished_Material.XLS'     "FILENAME
      #2 = 1.                          "FILEFORMAT

  FREE OBJECT sheet.
  FREE OBJECT workbook.
  FREE OBJECT application.
ENDFORM.
