report ZBDC_ME12_SUB_PR
       no standard page heading line-size 255.

TYPES : BEGIN OF ty_record,
*        LIFNR_001(010),
*        MATNR_002(018),
          EKORG(004),
*        WERKS(004),
          infnr(010),
*        NORMB_006(001),
*        MAHN1_007(004),
*        URZLA_008(003),
*        REGIO_009(003),
*        TELF1_010(016),
*        MEINS_011(003),
*        UMREZ_012(006),
*        UMREN_013(006),
*        DATAB_014(010),
          datbi(010),
        END OF ty_record.

TYPES : BEGIN OF ty_eina,
        infnr TYPE eina-infnr,
        matnr TYPE eina-matnr,
        lifnr TYPE eina-lifnr,
  END OF ty_eina.

DATA : it_record TYPE TABLE OF ty_record,
       wa_record TYPE ty_record,
       it_a017 TYPE TABLE OF a017,
       wa_a017 TYPE a017,
       it_eina TYPE TABLE OF ty_eina,
       wa_eina TYPE ty_eina.

DATA : it_msg  TYPE STANDARD TABLE OF bdcmsgcoll,
       wa_msg  TYPE bdcmsgcoll,
       bdcdata TYPE STANDARD TABLE OF bdcdata WITH HEADER LINE.

DATA : raw_data(4096) TYPE c OCCURS 0.

data : max_datbi TYPE a017-datbi,
       max_datab TYPE a017-datab,
       count(2) TYPE c,
       fname TYPE string,
       v_message TYPE string.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
      PARAMETERS : p_file TYPE rlgrap-filename.

*      PARAMETERS : P_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'A'.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN : PUSHBUTTON 2(16) but1 USER-COMMAND CMD." VISIBLE LENGTH 15.

INITIALIZATION.
but1 = 'Download Excel'.

at SELECTION-SCREEN.
*  BREAK primus.
  if sy-ucomm = 'CMD'.
    PERFORM download_file.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_file.


START-OF-SELECTION .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
     i_tab_raw_data       = raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = it_record
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc <> 0.
     MESSAGE 'Unable to convert data' TYPE 'E'.
 else.
*  BREAK primus.

  SELECT infnr matnr lifnr
         from eina
         INTO TABLE it_eina
         FOR ALL ENTRIES IN it_record
    WHERE infnr = it_record-infnr.

    IF sy-subrc = 0.
    SELECT * from a017 INTO TABLE it_a017
      FOR ALL ENTRIES IN it_eina
      WHERE lifnr = it_eina-lifnr
      and matnr = it_eina-matnr.
    ENDIF.
  ENDIF.

*BREAK fujiabap.
*-----------Start processing----------------------------------
  LOOP AT it_record INTO wa_record.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0100'.

    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINA-MATNR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
"PASS AS BLANK IN VENDOR NO & MATERIAL NO.
    perform bdc_field       using 'EINA-LIFNR'
                              ''.
    perform bdc_field       using 'EINA-MATNR'
                              ''.

    perform bdc_field       using 'EINE-EKORG'
                              wa_record-ekorg."'1000'.

    perform bdc_field       using 'EINE-WERKS'
                              'PL01'.

    PERFORM bdc_field       USING 'EINA-INFNR'
                                  wa_record-infnr.      "'5300000229'.
    PERFORM bdc_field       USING 'RM06I-LOHNB'
                                  'X'.                  " Normal
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0101'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINA-MAHN1'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=KO'.
*perform bdc_field       using 'EINA-MAHN1'
*                              '1'.
*perform bdc_field       using 'EINA-URZLA'
*                              'IN'.
*perform bdc_field       using 'EINA-REGIO'
*                              '13'.
*perform bdc_field       using 'EINA-TELF1'
*                              '+390119852911'.
*perform bdc_field       using 'EINA-MEINS'
*                              'KG'.
*perform bdc_field       using 'EINA-UMREZ'
*                              '1'.
*perform bdc_field       using 'EINA-UMREN'
*                              '1'.
    PERFORM bdc_dynpro      USING 'SAPLV14A' '0102'.
*--------------Selection for Open period--------------------
    READ TABLE it_eina INTO wa_eina with KEY infnr = wa_record-infnr.
    IF sy-subrc = 0.
      SELECT SINGLE max( datbi )
                    max( datab ) from a017
                    INTO ( max_datbi, max_datab )
                    WHERE matnr = wa_eina-matnr and lifnr = wa_eina-lifnr.
    sort it_a017 by datab DESCENDING.
    LOOP AT it_a017 INTO wa_a017 WHERE matnr = wa_eina-matnr and lifnr = wa_eina-lifnr.
    count = count + 1.
*    IF wa_a017-datbi = max_datbi and wa_a017-datab = max_datab.
*    exit.
*    ENDIF.
    ENDLOOP.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input         = count
     IMPORTING
       OUTPUT        = count.
    ENDIF.
*--------------------------------------------------------------------*
    CONCATENATE 'VAKE-DATAB' '(' count ')' INTO fname.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  fname."'VAKE-DATAB(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=PICK'.
    PERFORM bdc_dynpro      USING 'SAPMV13A' '0201'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'RV13A-DATBI'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=SICH'.
*perform bdc_field       using 'RV13A-DATAB'
*                              '13.02.2018'.
    PERFORM bdc_field       USING 'RV13A-DATBI'
                                  wa_record-datbi.      "'31.12.9909'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '=BU'.
    CALL TRANSACTION 'ME12' USING bdcdata MESSAGES INTO it_msg  MODE 'E' UPDATE 'S'.
clear : wa_record, count, bdcdata[].
  ENDLOOP.

*  BREAK primus.
  delete it_msg WHERE msgtyp = 'W'.
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

*        IF wa_bdcmsgcoll-msgtyp = 'S'.
          WRITE:/ v_message.
*        ENDIF.

*        if  wa_bdcmsgcoll-msgtyp = 'E'.
*          WRITE:/ v_message ."' Error in Count',ls_final-count.
*        endif.


  ENDLOOP.
*  PERFORM display_result.
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_RESULT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_result .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
      i_structure_name   = 'BDCMSGCOLL'
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
*     IT_FIELDCAT        =
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
      i_default          = 'X'
      i_save             = 'X'
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_msg[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_file .
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
          field1  TYPE string,          " Sales Org
          field2  TYPE string,          " Info record number
          field3  TYPE string,          " Date
*          field4  TYPE string,
*          field5  TYPE string,
*          field6  TYPE string,
*          field7  TYPE string,
        END OF t_data.

  DATA: it_data TYPE STANDARD TABLE OF t_data,
        ls_data LIKE LINE OF it_data.

  FIELD-SYMBOLS: <fs>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*

  ls_data-field1 =  'Purchase Org'.
  ls_data-field2 =  'Info Record No.'.
  ls_data-field3 =  'Date'.
*  ls_data-field4 =  'Division'.
*  ls_data-field5 =  'Item No'.
*  ls_data-field6 =  'Schedule Line No'.
*  ls_data-field7 = 'First Date'.
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
  SET PROPERTY OF sheet 'NAME' = 'Info record Change'.

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
        #2 = 3.   "COLUMN ACROSS

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
        #2 = 3.   "COLUMNS ACROSS

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
        #1 = 'C:\ME12_excel.xls'     "FILENAME
        #2 = 1.                "FILEFORMAT

      FREE OBJECT sheet.
      FREE OBJECT workbook.
      FREE OBJECT application.

      " CELL_BORDER

ENDFORM.
*PARAMETERS infnr TYPE eine-infnr.
*data : wa_eine  TYPE eine.
*START-OF-SELECTION.
* SELECT SINGLE * from
