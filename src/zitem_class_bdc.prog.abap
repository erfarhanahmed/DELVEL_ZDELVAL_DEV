report ZITEM_CLASS_BDC  no standard page heading line-size 255.

TABLES sscrfields.
TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.
*******************************

*DATA: BEGIN OF MESSTAB OCCURS 10.
*       INCLUDE STRUCTURE BDCMSGCOLL.
*DATA: END OF MESSTAB.

*************************


TYPES : BEGIN OF ty_file,
          matnr(18),        """  Material
*          maktx(40),
*          zseries,
*          brand,
*          type,
*          zsize,
*          moc,
          ZITEM_CLASS, "maktx(40),
*          meins,
*          matkl,
*          bismt,
*          gewei,
        END OF ty_file .

DATA : gt_file TYPE TABLE OF ty_file,
       gs_file TYPE ty_file.

DATA: gv_file    TYPE ibipparms-path,
*      gt_bdcdata TYPE TABLE OF bdcdata,
      GT_BDCDATA TYPE TABLE OF BDCDATA WITH HEADER LINE,
      TEXT(4096) TYPE C OCCURS 0.
DATA: It_msg TYPE TABLE OF bdcmsgcoll,
      wa_msg TYPE  bdcmsgcoll,
      v_message TYPE string.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : S_file LIKE rlgrap-filename .
*PARAMETERS :  CTU_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'S'.
SELECTION-SCREEN END OF BLOCK blk1.
********************************************************
SELECTION-SCREEN: PUSHBUTTON 2(30)  but1 USER-COMMAND CLI1.
INITIALIZATION.
but1 = 'Download Excel Template'.
AT SELECTION-SCREEN.
   IF SSCRFIELDS  = 'CLI1'.
  PERFORM DOWNLOAD_EXCEL.
  ENDIF.

*******************************************
 AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_FILE.
    CALL FUNCTION 'F4_FILENAME'

     IMPORTING
       FILE_NAME           = S_FILE.
******************************************
 start-of-selection.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
   I_LINE_HEADER              = 'X'
    I_TAB_RAW_DATA             = TEXT
    I_FILENAME                 = S_FILE
  TABLES
    I_TAB_CONVERTED_DATA       = gt_file[]
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

*FORM run_bdc .

  LOOP AT gt_file INTO gs_file.
REFRESH GT_BDCDATA.
perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                               gs_file-matnr .              "'RND6504BD03B010-C'.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BU'.
*perform bdc_field       using 'MAKT-MAKTX'.
**                              gs_file-maktx.               "' 5,1",BODY,FLG RF,WCB,MR0175,2,CPHO,-,'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'MARA-ZITEM_CLASS'.
*perform bdc_field       using 'MARA-ZSERIES'
**                              gs_file-zseries.           "'65'.
*perform bdc_field       using 'MARA-BRAND'
**                               gs_file-brand.                    "'BLV'.
*perform bdc_field       using 'MARA-TYPE'
**                               gs_file-type.   "'BDY'.
*perform bdc_field       using 'MARA-ZSIZE'
**                              gs_file-zsize."'001'.
*perform bdc_field       using 'MARA-MOC'
**                              gs_file-moc."'03'.
perform bdc_field       using 'MARA-ZITEM_CLASS'
                               gs_file-ZITEM_CLASS.                    "'A'.
*perform bdc_field       using 'MARA-MEINS'
**                              gs_file-meins.    "'NOS'.
*perform bdc_field       using 'MARA-MATKL'
**                              gs_file-matkl.    "'0002'.
*perform bdc_field       using 'MARA-BISMT'
**                              gs_file-bismt.  "'6504BD03B010-30'.
*perform bdc_field       using 'MARA-GEWEI'
**                              gs_file-gewei.  "'KG'.
*perform bdc_field       using 'DESC_LANGU_GDTXT'
*                              'E'.
*perform bdc_transaction using 'MM02'.
*    CLEAR gs_file.

CALL  TRANSACTION 'MM02' USING GT_BDCDATA
*      MODE CTU_MODE
      MODE 'S'
      UPDATE 'S'
      MESSAGES INTO it_mSG.

*CALL TRANSACTION 'MMO2' USING GT_BDCDATA MODE 'N'
*                  MESSAGES INTO MESSTAB.

  ENDLOOP.

LOOP AT it_msg INTO wa_msg.
          CALL FUNCTION 'FORMAT_MESSAGE'                  "Formatting a T100 message
          EXPORTING
            id        = wa_msg-msgid
            lang      = sy-langu
            no        = wa_msg-msgnr
            v1        = wa_msg-msgv1
            v2        = wa_msg-msgv2
            v3        = wa_msg-msgv3
            v4        = wa_msg-msgv4
          IMPORTING
            msg       = v_message
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.
*********************************************************************************
*          IF wa_msg-msgv1 IS INITIAL.                               "added by aakashk 07.10.2024
*    REPLACE '&1' WITH '' INTO v_message.
*  ENDIF.
*  IF wa_msg-msgv2 IS INITIAL.
*    REPLACE '&2' WITH '' INTO v_message.
*  ENDIF.
*  IF wa_msg-msgv3 IS INITIAL.
*    REPLACE '&3' WITH '' INTO v_message.
*  ENDIF.
*  IF wa_msg-msgv4 IS INITIAL.
*    REPLACE '&4' WITH '' INTO v_message.
*  ENDIF.

          REPLACE ALL OCCURRENCES OF '&5' IN v_message WITH ''.
    REPLACE ALL OCCURRENCES OF '&6' IN v_message WITH ''.
    REPLACE ALL OCCURRENCES OF '&7' IN v_message WITH ''.
    REPLACE ALL OCCURRENCES OF '&8' IN v_message WITH ''.



**********************************************************************************


*        IF wa_bdcmsgcoll-msgtyp = 'S'.
          WRITE:/ v_message.
*
          ENDLOOP.
*  ENDFORM .
************************************
* LOOP AT MESSTAB.
*   WRITE: / MESSTAB-TCODE,
*          MESSTAB-DYNAME,
*          MESSTAB-DYNUMB,
*          MESSTAB-MSGTYP,
*          MESSTAB-MSGSPRA,
*          MESSTAB-MSGID,
*          MESSTAB-MSGNR.
*ENDLOOP.

**********************************
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR GT_BDCDATA.
  GT_BDCDATA-PROGRAM  = PROGRAM.
  GT_BDCDATA-DYNPRO   = DYNPRO.
  GT_BDCDATA-DYNBEGIN = 'X'.
  APPEND GT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
    CLEAR GT_BDCDATA.
    GT_BDCDATA-FNAM = FNAM.
    GT_BDCDATA-FVAL = FVAL.
    APPEND GT_BDCDATA.
*  ENDIF.
ENDFORM.
*ENDFORM.





*perform close_group.
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

        END OF t_data.

  DATA: it_data TYPE STANDARD TABLE OF t_data,
        ls_data LIKE LINE OF it_data.

  FIELD-SYMBOLS: <fs>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*

 ls_data-field1 =  'Material'.
 ls_data-field2 = 'Item Class'.

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
        #2 = 2.   "COLUMN ACROSS

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
      SET PROPERTY OF shading 'COLORINDEX' = 2. " COLOUR - CHANGE NUMBER FOR DIFF COLOURS
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
        #2 = 2.   "COLUMNS ACROSS

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
*      sheet'SAVEAS'
       workbook 'SAVEAS'
      EXPORTING
        #1 = 'C:\\MM02.xls'     "FILENAME
        #2 = 1.                "FILEFORMAT

      FREE OBJECT sheet.
      FREE OBJECT workbook.
      FREE OBJECT application.

      " CELL_BORDER

ENDFORM.
