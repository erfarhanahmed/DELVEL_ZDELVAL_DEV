*&---------------------------------------------------------------------*
*& Report ZCS02_BAPI
*&---------------------------------------------------------------------*
*	**** 1.PROGRAM OWNER           : PRIMUS TECHSYSTEMS PVT LTD.
*	**** 2.PROGRAM NAME            : ZCS02_BAPI
*	**** 4.MODULE NAME             : PP
*	**** 5.REQUEST NO              :
*	**** 6.CREATION DATE           : 21/01/2020
*	**** 7.CREATED BY              : SAURABH PATIL
*	**** 8.FUNCTIONAL CONSULTANT   : ROHIT REDDY/PRASHANT UBHE
*	**** 9.BUSINESS OWNER          :
*&---------------------------------------------------------------------*
REPORT ZCS02_BAPI.
TYPE-POOLS : SLIS ,OLE2,ICON.
TABLES: SSCRFIELDS,ICONS.
DATA: APPLICATION TYPE OLE2_OBJECT,
      WORKBOOK    TYPE OLE2_OBJECT,
      SHEET       TYPE OLE2_OBJECT,
      CELLS       TYPE OLE2_OBJECT,
      CELL1       TYPE OLE2_OBJECT,
      CELL2       TYPE OLE2_OBJECT,
      RANGE       TYPE OLE2_OBJECT,
      FONT        TYPE OLE2_OBJECT,
      COLUMN      TYPE OLE2_OBJECT,
      SHADING     TYPE OLE2_OBJECT,
      BORDER      TYPE OLE2_OBJECT.

CONSTANTS: ROW_MAX TYPE I VALUE 256.
DATA: INDEX TYPE I.
DATA: LD_COLINDX TYPE I,   "COLUMN INDEX
      LD_ROWINDX TYPE I.   "ROW INDEX

TYPES:BEGIN OF T_DATA,
        FIELD1  TYPE STRING,
        FIELD2  TYPE STRING,
        FIELD3  TYPE STRING,
        FIELD4  TYPE STRING,
        FIELD5  TYPE STRING,
        FIELD6  TYPE STRING,
        FIELD7  TYPE STRING,
        FIELD8  TYPE STRING,
        FIELD9  TYPE STRING,
        FIELD10 TYPE STRING,
      END OF T_DATA.

DATA: IT_XSL TYPE STANDARD TABLE OF T_DATA,
      LS_XSL TYPE T_DATA.

FIELD-SYMBOLS: <FS>.
DATA : EXTEND TYPE C LENGTH 5.

TYPES: TRUX_T_TEXT_DATA(4096) TYPE C OCCURS 0.
DATA : IT_RAW TYPE TRUX_T_TEXT_DATA.

TYPES : BEGIN OF TY_FIELDNAMES,
          FIELD_NAME(30) TYPE C, "FIELD NAMES
        END OF TY_FIELDNAMES.
DATA: IT_FIELDNAMES TYPE TABLE OF TY_FIELDNAMES.
DATA : WA_FIELDNAMES TYPE TY_FIELDNAMES.
DATA : FILENAME TYPE STRING.

TYPES : BEGIN OF TY_FINAL,
          CNT         TYPE C LENGTH 5,
          CNT1        TYPE C LENGTH 5,
          MATERIAL    TYPE CSAP_MBOM-MATNR,
          PLANT	      TYPE CSAP_MBOM-WERKS,
          BOM_USAGE	  TYPE CSAP_MBOM-STLAN,
          ALTERNATIVE TYPE CSAP_MBOM-STLAL,
          VALID_FROM  TYPE CSAP_MBOM-DATUV,
          ITEM_CATEG  TYPE POSTP,
          COMPONENT   TYPE IDNRK,
          COMP_QTY    TYPE MENGE_D,
        END OF TY_FINAL.
TYPES : BEGIN OF LOG,
          REFERENCE  TYPE C,
          STATUS(10),
          MATNR      TYPE MATNR,
        END OF LOG.
DATA : IT_LOG TYPE TABLE OF LOG,
       WA_LOG TYPE LOG.
DATA : ITAB  TYPE TABLE OF TY_FINAL,
       WA    TYPE TY_FINAL,
       ITAB1 TYPE TABLE OF TY_FINAL,
       WA1   TYPE TY_FINAL,
       ITAB2 TYPE TABLE OF TY_FINAL,
       WA2   TYPE TY_FINAL.
DATA LT_STPO TYPE TABLE OF STPO_API03.
DATA LS_STPO TYPE STPO_API03.
DATA : FL_WARNING	TYPE 	CAPIFLAG-FLWARNING.
DATA : O_STKO	    TYPE 	STKO_API02.
DATA : O_STKO1      TYPE  STKO_API02.
DATA : I_STKO	    TYPE 	STKO_API01.
DATA : T_STPO     TYPE TABLE OF   STPO_API02.

SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS : ZVM TYPE RLGRAP-FILENAME.
SELECTION-SCREEN: END OF BLOCK B1.
SELECTION-SCREEN: BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-010.
SELECTION-SCREEN: PUSHBUTTON 2(15)  BUT1 USER-COMMAND CLI1.
SELECTION-SCREEN: END OF BLOCK B2.

INITIALIZATION.
  CONCATENATE ICON_EXPORT 'TEMPLATE' INTO BUT1.


AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM  = 'CLI1'.
    MESSAGE 'DEAR USER,FIRST CHECK THE SCENARIO & MAINTAIN DATA IN EXCEL FORMAT' TYPE 'I'. "DISPLAY LIKE 'I'.
    PERFORM DOWNLOAD_EXCEL.
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR ZVM.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = ZVM.


AT SELECTION-SCREEN ON ZVM.
  IF ZVM IS NOT INITIAL.
    CALL FUNCTION 'TRINT_FILE_GET_EXTENSION'
      EXPORTING
        FILENAME  = ZVM
        UPPERCASE = 'X'
      IMPORTING
        EXTENSION = EXTEND.
    IF EXTEND EQ 'XLSX' OR EXTEND EQ 'XLS'.
    ELSE.
      MESSAGE 'CHOOSE CORRECT FILE FORMAT' TYPE 'E'.
    ENDIF.
  ENDIF.

START-OF-SELECTION.
  PERFORM SELECT_FILE.
  PERFORM FIELDNAMES.
  PERFORM PROCESS.
  IF IT_LOG IS NOT INITIAL.
    PERFORM DOWNLOAD_LOG.
  ENDIF.




*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_EXCEL .
  LS_XSL-FIELD1   = 'HEADER COUNTER'.
  LS_XSL-FIELD2   = 'ITEM COUNTER'.
  LS_XSL-FIELD3   = 'HEADER MATERIAL'.
  LS_XSL-FIELD4   = 'PLANT'.
  LS_XSL-FIELD5   = 'BOM USAGE'.
  LS_XSL-FIELD6   = 'ALTERNATIVE'.
  LS_XSL-FIELD7   = 'VALID FROM DATE'.
  LS_XSL-FIELD8   = 'ITEM CATEGORY'.
  LS_XSL-FIELD9   = 'COMPONENT  '.
  LS_XSL-FIELD10  = 'COMPONENT QUANTITY'.
  APPEND LS_XSL TO IT_XSL.
  CLEAR LS_XSL.


  CREATE OBJECT APPLICATION 'EXCEL.APPLICATION'.
  SET PROPERTY OF APPLICATION 'VISIBLE' = 1.
  CALL METHOD OF
    APPLICATION
      'WORKBOOKS' = WORKBOOK.

* CREATE NEW WORKSHEET
  SET PROPERTY OF APPLICATION 'SHEETSINNEWWORKBOOK' = 1.
  CALL METHOD OF
    WORKBOOK
    'ADD'.

* CREATE FIRST EXCEL SHEET
  CALL METHOD OF
  APPLICATION
  'WORKSHEETS' = SHEET
  EXPORTING
    #1 = 1.
  CALL METHOD OF
    SHEET
    'ACTIVATE'.
  SET PROPERTY OF SHEET 'NAME' = 'ZCS02 DATA'.

  " FILL_DATA
*&---------------------------------------------------------------------*
*&   DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET
*&---------------------------------------------------------------------*

  LD_ROWINDX = 1. "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT IT_XSL INTO LS_XSL.
    LD_ROWINDX = SY-TABIX . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
    CLEAR LD_COLINDX.
    DO.
      ASSIGN COMPONENT SY-INDEX OF STRUCTURE LS_XSL TO <FS>.
      IF SY-SUBRC NE 0.
        EXIT.
      ENDIF.
      LD_COLINDX = SY-INDEX.
      CALL METHOD OF
      SHEET
      'CELLS' = CELLS
      EXPORTING
        #1 = LD_ROWINDX
        #2 = LD_COLINDX.
      SET PROPERTY OF CELLS 'VALUE' = <FS>.
    ENDDO.
  ENDLOOP.

  " DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*&  FORMATTING OF COLUMN NUMBER ROW
*&---------------------------------------------------------------------*

  CALL METHOD OF
  APPLICATION
  'CELLS' = CELL1
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

*END OF RANGE CELL
  CALL METHOD OF
  APPLICATION
  'CELLS' = CELL2
  EXPORTING
    #1 = 1     "DOWN
    #2 = 28.   "COLUMN ACROSS

  CALL METHOD OF
  APPLICATION
  'RANGE' = RANGE
  EXPORTING
    #1 = CELL1
    #2 = CELL2.

* SET FONT DETAILS OF RANGE

  GET PROPERTY OF RANGE 'FONT' = FONT.
  SET PROPERTY OF FONT 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
  CALL METHOD OF
    RANGE
      'INTERIOR' = SHADING.
  SET PROPERTY OF SHADING 'COLORINDEX' =  6 . " COLOUR - CHANGE NUMBER FOR DIFF COLOURS
  SET PROPERTY OF SHADING 'PATTERN' = 1.    " PATTERN - SOLID, STRIPED ETC
  FREE OBJECT SHADING.

  "END OF FORMATTING OF COLUMN NUMBER ROW

*&*--------------------------------------------------------------------*
*&*  MODIFY PROPERTIES OF CELL RANGE
*&*--------------------------------------------------------------------*

  FREE RANGE.
  CALL METHOD OF APPLICATION 'CELLS' = CELL1  "START CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

  CALL METHOD OF APPLICATION 'CELLS' = CELL2 "END CELL
  EXPORTING
    #1 = 1    "DOWN
    #2 = 28.   "COLUMNS ACROSS

  CALL METHOD OF
  APPLICATION
  'RANGE' = RANGE
  EXPORTING
    #1 = CELL1
    #2 = CELL2.

* SET BORDER PROPERTIES OF RANGE
  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1 = '1'.  "LEFT
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'. "LINE STYLE SOLID, DASHED...
  SET PROPERTY OF BORDER 'WEIGHT' = 1.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1 = '2'.  "RIGHT
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1 = '3'.   "TOP
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1 = '4'.   "BOTTOM
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  " SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *

  CALL METHOD OF APPLICATION
      'COLUMNS' = COLUMN.
  CALL METHOD OF COLUMN
    'AUTOFIT'.
  FREE OBJECT COLUMN.

  " SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME

  CALL METHOD OF
    SHEET 'SAVEAS'
    EXPORTING
      #1 = 'C:\ZCS02_DATA.XLS'     "FILENAME
      #2 = 1.                "FILEFORMAT

  FREE OBJECT SHEET.
  FREE OBJECT WORKBOOK.
  FREE OBJECT APPLICATION.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SELECT_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SELECT_FILE .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = IT_RAW
      I_FILENAME           = ZVM
    TABLES
      I_TAB_CONVERTED_DATA = ITAB[]
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF .
  ITAB1[] = ITAB[].
  SORT ITAB1 BY CNT.
  DELETE ADJACENT DUPLICATES FROM ITAB1 COMPARING CNT.
  DELETE ITAB1 WHERE CNT IS INITIAL.
  ITAB2[] = ITAB[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDNAMES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELDNAMES .
  WA_FIELDNAMES-FIELD_NAME = 'REFERENCE'.
  APPEND WA_FIELDNAMES TO IT_FIELDNAMES.
  WA_FIELDNAMES-FIELD_NAME = 'STATUS'.
  APPEND WA_FIELDNAMES TO IT_FIELDNAMES.
  WA_FIELDNAMES-FIELD_NAME = 'HEADER MATERIAL'.
  APPEND WA_FIELDNAMES TO IT_FIELDNAMES.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PROCESS .
  IF ITAB1 IS NOT INITIAL.
    LOOP AT ITAB1 INTO WA1.
      REFRESH LT_STPO[].
      CLEAR : O_STKO,I_STKO,FL_WARNING.
      REFRESH : T_STPO[].
      LOOP AT ITAB INTO WA WHERE CNT1 EQ WA1-CNT.
        LS_STPO-ITEM_CATEG = WA-ITEM_CATEG.
        LS_STPO-COMPONENT  = WA-COMPONENT .
        LS_STPO-COMP_QTY   = WA-COMP_QTY  .
        APPEND LS_STPO TO LT_STPO.
        CLEAR : WA,LS_STPO.
      ENDLOOP.
      CALL FUNCTION 'CSAP_MAT_BOM_OPEN'
        EXPORTING
          MATERIAL    = WA1-MATERIAL
          PLANT       = WA1-PLANT
          BOM_USAGE   = WA1-BOM_USAGE
          ALTERNATIVE = WA1-ALTERNATIVE
          VALID_FROM  = WA1-VALID_FROM
*         CHANGE_NO   =
*         REVISION_LEVEL         =
*         FL_NO_CHANGE_DOC       = ' '
        IMPORTING
          O_STKO      = O_STKO
*         FL_WARNING  =
        TABLES
          T_STPO      = T_STPO[]
*         T_DEP_DATA  =
*         T_DEP_DESCR =
*         T_DEP_ORDER =
*         T_DEP_SOURCE           =
*         T_DEP_DOC   =
        EXCEPTIONS
          ERROR       = 1
          OTHERS      = 2.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.

      CALL FUNCTION 'CSAP_MAT_BOM_MAINTAIN'
        EXPORTING
          MATERIAL           = WA1-MATERIAL
          PLANT              = WA1-PLANT
          BOM_USAGE          = WA1-BOM_USAGE
          ALTERNATIVE        = WA1-ALTERNATIVE
          VALID_FROM         = WA1-VALID_FROM
*         CHANGE_NO          =
*         REVISION_LEVEL     =
          I_STKO             = I_STKO
*         FL_NO_CHANGE_DOC   = ' '
          FL_COMMIT_AND_WAIT = 'X'
*         FL_CAD             = ' '
*         FL_BOM_CREATE      = ' '
*         FL_NEW_ITEM        = ' '
*         FL_COMPLETE        = ' '
          FL_DEFAULT_VALUES  = 'X'
*         FL_IDENTIFY_BY_GUID       = ' '
*         FL_RECURSIVE       = ' '
        IMPORTING
          FL_WARNING         = FL_WARNING
          O_STKO             = O_STKO
        TABLES
          T_STPO             = LT_STPO[]
*         T_DEP_DATA         =
*         T_DEP_DESCR        =
*         T_DEP_ORDER        =
*         T_DEP_SOURCE       =
*         T_DEP_DOC          =
*         T_DOC_LINK         =
*         T_DMU_TMX          =
*         T_LTX_LINE         =
*         T_STPU             =
*         T_FSH_BOMD         =
*         T_SGT_BOMC         =
        EXCEPTIONS
          ERROR              = 1
          OTHERS             = 2.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.
      IF SY-SUBRC IS INITIAL.
        WA_LOG-STATUS = 'SUCESS'.
        WA_LOG-MATNR = WA1-MATERIAL.
      ELSE.
        WA_LOG-STATUS = 'ERROR'.
      ENDIF.
      WA_LOG-REFERENCE = WA1-CNT.
      APPEND WA_LOG TO IT_LOG.
      CLEAR WA_LOG.
      CALL FUNCTION 'CSAP_MAT_BOM_CLOSE'
        EXPORTING
          FL_COMMIT_AND_WAIT = 'X'
*       IMPORTING
*         FL_WARNING         =
        EXCEPTIONS
          ERROR              = 1
          OTHERS             = 2.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR WA1.
    ENDLOOP.
  ELSE.
    MESSAGE 'ERROR WHILE READING EXCEL FILE' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_LOG .
  DATA : V_FULLPATH TYPE STRING.
  CALL FUNCTION 'GUI_FILE_SAVE_DIALOG'
    EXPORTING
      WINDOW_TITLE      = 'STATUS RECORD FILE'
      DEFAULT_EXTENSION = '.XLS'
    IMPORTING
*     FILENAME          = V_EFILE
      FULLPATH          = V_FULLPATH.
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      FILENAME                = V_FULLPATH
      FILETYPE                = 'ASC'
      WRITE_FIELD_SEPARATOR   = 'X'
    TABLES
      DATA_TAB                = IT_LOG
      FIELDNAMES              = IT_FIELDNAMES
    EXCEPTIONS
      FILE_WRITE_ERROR        = 1
      NO_BATCH                = 2
      GUI_REFUSE_FILETRANSFER = 3
      INVALID_TYPE            = 4
      NO_AUTHORITY            = 5
      UNKNOWN_ERROR           = 6
      HEADER_NOT_ALLOWED      = 7
      SEPARATOR_NOT_ALLOWED   = 8
      FILESIZE_NOT_ALLOWED    = 9
      HEADER_TOO_LONG         = 10
      DP_ERROR_CREATE         = 11
      DP_ERROR_SEND           = 12
      DP_ERROR_WRITE          = 13
      UNKNOWN_DP_ERROR        = 14
      ACCESS_DENIED           = 15
      DP_OUT_OF_MEMORY        = 16
      DISK_FULL               = 17
      DP_TIMEOUT              = 18
      FILE_NOT_FOUND          = 19
      DATAPROVIDER_EXCEPTION  = 20
      CONTROL_FLUSH_ERROR     = 21
      OTHERS                  = 22.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
* WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    MESSAGE 'PLEASE CHECK STATUS FILE' TYPE 'S'.
  ENDIF.
ENDFORM.
