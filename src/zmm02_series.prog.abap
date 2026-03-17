*&---------------------------------------------------------------------*
*& Report ZMM02_SERIES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&        0. PROGRAM OWNER          : PRIMUS TECHSYSTEMS PVT LTD.
*         1. FS NO                  :
*         2. PROJECT                : DELVAL.
*         3. PROGRAM NAME           : ZMM02_SERIES
*         4. TRANS CODE             :
*         5. MODULE NAME            : MM
*         7. CREATION DATE          : 08.02.2024
*         8. DEVELOPER NAME         : Jyoti Mahajan
*         9. FUNCTIONAL CONSULTANT  : Subhashish Pande
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT ZMM02_SERIES.

TABLES: sscrfields.
********include for download template
INCLUDE zhr_upload_excel.

*&-- STRUCTURE for file upload
TYPES : BEGIN OF t_file ,
         matnr       TYPE matnr,
         zseries     TYPE char03,
         brand       TYPE zbrand,
         zmsize      TYPE char03,
        END OF T_FILE.

*&-- internal table for file upload
 Data:       IT_BDCMSG  TYPE TABLE OF BDCMSGCOLL WITH HEADER LINE ,
       WA_BDCMSG  TYPE BDCMSGCOLL ,
        bdcdata     TYPE TABLE OF bdcdata WITH HEADER LINE,
        it_mess  TYPE STANDARD TABLE OF bdcmsgcoll,
        itraw(4096) TYPE c OCCURS 0,
        i_file                TYPE TABLE OF t_file,
       wa_file               TYPE t_file,
       count type num,
       wa_mess  TYPE bdcmsgcoll.
***************selection screen
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
PARAMETERS : p_file   LIKE ibipparms-path. "OBLIGATORY .
PARAMETERS : ctu_mode LIKE ctu_params-dismode DEFAULT 'E' NO-DISPLAY.
PARAMETERS : p_updt AS CHECKBOX.
SELECTION-SCREEN : END OF BLOCK b1 .

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.

INITIALIZATION.
* Add displayed text string to buttons
  w_button = 'Download Excel Template'.
* ============================================================
AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'BUT1' .
    PERFORM excel.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_file.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = itraw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = i_file
*   EXCEPTIONS
*     CONVERSION_FAILED    = 1
*     OTHERS               = 2
    .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

START-OF-SELECTION.
loop at i_file into wa_file.
*perform bdc_dynpro      using 'SAPLMGMM' '0060'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'RMMG1-MATNR'.
*perform bdc_field       using 'BDC_OKCODE'
*                              '=AUSW'.
*perform bdc_field       using 'RMMG1-MATNR'
*                              wa_file-matnr . "'5010000B-CH0118-01'.
*perform bdc_dynpro      using 'SAPLMGMM' '0070'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'MSICHTAUSW-DYTXT(01)'.
*perform bdc_field       using 'BDC_OKCODE'
*                              '=ENTR'.
*perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
*                              'X'.
*perform bdc_dynpro      using 'SAPLMGMM' '4004'.
*perform bdc_field       using 'BDC_OKCODE'
*                              '=BU'.
**perform bdc_field       using 'MAKT-MAKTX'
**                              '50,10",150PSI,16.5H,CI,CF8,SS410,E,-,B'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'MARA-ZSIZE'.
*perform bdc_field       using 'MARA-ZSERIES'
*                              wa_file-zseries."'50'.
*perform bdc_field       using 'MARA-BRAND'
*                              wa_file-brand."'BFV'.
*perform bdc_field       using 'MARA-ZSIZE'
*                             wa_file-zmsize."'15'.
**perform bdc_field       using 'MARA-MEINS'
**                              'NOS'.
**perform bdc_field       using 'MARA-MATKL'
**                              '0021'.
**perform bdc_field       using 'MARA-GEWEI'
**                              'KG'.
**perform bdc_field       using 'DESC_LANGU_GDTXT'
**                              'E'.
*CALL TRANSACTION 'MM02'
*           USING bdcdata
*            MODE ctu_mode
*            UPDATE 'S' MESSAGES INTO IT_BDCMSG.
*count = count + 1.

   UPDATE mara SET zseries = wa_file-zseries
                    zsize   = wa_file-zmsize
                    brand   = wa_file-brand
   WHERE matnr = wa_file-matnr .
    WAIT UP TO  1 SECONDS.

    if sy-subrc is INITIAL.
        WRITE :/ 'Data uploaded successfully'.
    endif.


endloop.


*  LOOP AT IT_BDCmSG INTO WA_BDCMSG.
*    IF WA_BDCMSG-msgtyp = 'S'.
*      WRITE :/ 'Data uploaded successfully'.
*    ENDIF.
*  ENDLOOP.
*----------------------------------------------------------------------*
*        START NEW SCREEN                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        INSERT FIELD                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
*  ENDIF.
ENDFORM.
FORM excel .

  PERFORM fill_data.
  PERFORM download_data.
  PERFORM modify_cells.
  PERFORM cell_border.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_data .

  wa_data-field1  = 'MATERIAL NUMBER'.
  wa_data-field2  = 'SERIES'.
  wa_data-field3  = 'BRAND'.
  wa_data-field4  = 'SIZE'.

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
  SET PROPERTY OF sheet 'NAME' = 'Infotype 0002 Master Data'.


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

***********************************************
* DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET   *
***********************************************

  ld_rowindx = 1.                         "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT it_data INTO wa_data.
    ld_rowindx = sy-tabix .               "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

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
    #2          = 4.   "ACROSS

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
  CALL METHOD OF application 'CELLS' = cell1   "START CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

  CALL METHOD OF application 'CELLS' = cell2   "END CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 4.   "ACROSS

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
  SET PROPERTY OF border 'LINESTYLE' = '1'.                 "LINE STYLE SOLID, DASHED...
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
      #1 = 'D:\SAP_DATA\Upload_MM02_SERIES.XLS'     "FILENAME
**       #1       = '/home/lalit/Upload_FERT_Finished_Material.XLS'     "FILENAME
      #2 = 1.                          "FILEFORMAT

  FREE OBJECT sheet.
  FREE OBJECT workbook.
  FREE OBJECT application.
ENDFORM.
