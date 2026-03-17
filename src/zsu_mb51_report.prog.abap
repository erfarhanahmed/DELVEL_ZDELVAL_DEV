*&---------------------------------------------------------------------*
*& REPORT ZMB51_REPORT
*&---------------------------------------------------------------------*
*&Transaction: ZSU_MB51_DETAILS
*&Functional Cosultant: Neeraj tiwari / Devshree Kalamkar
*&Technical Consultant: Shreya Sankpal / Nilay Brahme
*&TR: DEVK913048
*&Date: 14.12.2023
*&Owner: DelVal Flow Controls

*&---------------------------------------------------------------------*
REPORT ZSU_MB51_REPORT.

TABLES: MSEG.

TYPE-POOLS: SLIS.

TYPES: BEGIN OF TY_MSEG,                  " STRUCTURE
         MATNR      TYPE MSEG-MATNR,
         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
         MBLNR      TYPE MSEG-MBLNR,
         ZEILE      TYPE MSEG-ZEILE,
         BWART      TYPE MSEG-BWART,
         MENGE      TYPE MSEG-MENGE,
         DMBTR      TYPE MSEG-DMBTR,
         LGORT      TYPE MSEG-LGORT,
         KDAUF      TYPE MSEG-KDAUF,
         KDPOS      TYPE MSEG-KDPOS,
         AUFNR      TYPE MSEG-AUFNR,
         MEINS      TYPE MSEG-MEINS,
         WERKS      TYPE MSEG-WERKS,
         SHKZG      TYPE MSEG-SHKZG,
       END OF TY_MSEG,

       BEGIN OF TY_FINAL,
         MATNR      TYPE MSEG-MATNR,
         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
         MBLNR      TYPE MSEG-MBLNR,
         ZEILE      TYPE MSEG-ZEILE,
         BWART      TYPE MSEG-BWART,
         MENGE      TYPE MSEG-MENGE,
         DMBTR      TYPE MSEG-DMBTR,
         LGORT      TYPE MSEG-LGORT,
         KDAUF      TYPE MSEG-KDAUF,
         KDPOS      TYPE MSEG-KDPOS,
         AUFNR      TYPE MSEG-AUFNR,
         MEINS      TYPE MSEG-MEINS,
         WERKS      TYPE MSEG-WERKS,
         SHKZG      TYPE MSEG-SHKZG,
         BTEXT      TYPE T156T-BTEXT,
       END OF TY_FINAL.

TYPES: BEGIN OF TY_DOWN,                    " STRUCTURE TO DOWNLOAD DATA
*         MATNR      TYPE CHAR18,                       "MSEG-MATNR,
         MATNR      TYPE CHAR40,                       "MSEG-MATNR,
         BUDAT_MKPF TYPE CHAR15,                       "MSEG-BUDAT_MKPF,
         MBLNR      TYPE CHAR10,                       "MSEG-MBLNR,
         ZEILE      TYPE CHAR4,                        "MSEG-ZEILE,
         BWART      TYPE CHAR3,                        "MSEG-BWART,
         MENGE      TYPE CHAR15,                       "MSEG-MENGE,
         DMBTR      TYPE CHAR15,                       "MSEG-DMBTR,
         LGORT      TYPE CHAR4,                        "MSEG-LGORT,
         KDAUF      TYPE CHAR10,                       "MSEG-KDAUF,
         KDPOS      TYPE CHAR10,                       "MSEG-KDPOS,
         AUFNR      TYPE CHAR15,                       "MSEG-AUFNR,
         MEINS      TYPE CHAR3,                        "MSEG-MEINS,
         WERKS      TYPE CHAR4,                        "MSEG-WERKS,
         SHKZG      TYPE CHAR1,                        "MSEG-SHKZG,
         BTEXT      TYPE CHAR20,
         REF        TYPE CHAR15,
         TIME   TYPE CHAR15,
       END OF TY_DOWN.

DATA : IT_MSEG TYPE TABLE OF TY_MSEG,
       WA_MSEG TYPE          TY_MSEG.

DATA : IT_FINAL TYPE TABLE OF TY_FINAL,    " INTERNAL TABLE FOR FINAL STRUCTURE
       WA_FINAL TYPE          TY_FINAL.    " WORK AREA FOR FINAL STRUCTURE

DATA : IT_DOWN TYPE TABLE OF TY_DOWN,    " INTERNAL TABLE FOR DOWN STRUCTURE
       WA_DOWN TYPE          TY_DOWN.    " WORK AREA FOR DOWN STRUCTURE

DATA : IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,   " INTERNAL TABLE FOR FIELD CATALOG
       WA_FCAT LIKE LINE OF IT_FCAT,       " WORK AREA FOR FIELD CATALOG
       V_POS   TYPE I,                     " TO DEFINE FIELD/COLUMN POSTION IN FIELD CATALOG
       N       TYPE I.                     " TO STORE TOTAL NUMBER OF RECORDS DISPLAYED

************************* MACRO FOR FIELD CATALOG **********************
DEFINE FCAT.
  WA_FCAT-COL_POS = V_POS + 1.
  WA_FCAT-FIELDNAME = &1.
  WA_FCAT-TABNAME = 'IT_FINAL'.
  WA_FCAT-SELTEXT_M = &2.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
END-OF-DEFINITION.

SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MSEG-MATNR,                    " MATERIAL NUMBER
                S_BUDAT FOR MSEG-BUDAT_MKPF,               " POSTING DATE IN THE DOCUMENT
                S_MBLNR FOR MSEG-MBLNR,                    " NUMBER OF MATERIAL DOCUMENT
                S_BWART FOR MSEG-BWART,                    " MOVEMENT TYPE
                S_LGORT FOR MSEG-LGORT,                    " STORAGE LOCATION
                S_KDAUF FOR MSEG-KDAUF,                    " SALES ORDER NUMBER
                S_KDPOS FOR MSEG-KDPOS,                    " ITEM NUMBER IN SALES ORDER
                S_AUFNR FOR MSEG-AUFNR,                    " ORDER NUMBER
                S_MEINS FOR MSEG-MEINS,                    " UNIT OF MEASURE
                S_WERKS FOR MSEG-WERKS DEFAULT 'SU01'  MODIF ID BU.     " PLANT
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'."Saudi'."'/Delval/Saudi'."Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  PERFORM GET_DATA.

END-OF-SELECTION.
  PERFORM CREATE_FCAT.
  PERFORM DISPLAY_ALVGRID.
*&---------------------------------------------------------------------*
*&      FORM  GET_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM GET_DATA .
  SELECT MATNR
         BUDAT_MKPF
         MBLNR
         ZEILE
         BWART
         MENGE
         DMBTR
         LGORT
         KDAUF
         KDPOS
         AUFNR
         MEINS
         WERKS
         SHKZG
    FROM MSEG
    INTO CORRESPONDING FIELDS OF TABLE IT_mseg
    WHERE MATNR      IN S_MATNR
    AND   BUDAT_MKPF IN S_BUDAT
    AND   MBLNR      IN S_MBLNR
    AND   BWART      IN S_BWART
    AND   LGORT      IN S_LGORT
    AND   KDAUF      IN S_KDAUF
    AND   KDPOS      IN S_KDPOS
    AND   AUFNR      IN S_AUFNR
    AND   MEINS      IN S_MEINS
    AND   WERKS      IN S_WERKS.

LOOP AT IT_MSEG INTO WA_MSEG.                      " TO SHOW NEGATIVE SIGN
    WA_FINAL-MATNR      = WA_MSEG-MATNR     .
    WA_FINAL-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
    WA_FINAL-MBLNR      = WA_MSEG-MBLNR     .
    WA_FINAL-ZEILE      = WA_MSEG-ZEILE     .
    WA_FINAL-BWART      = WA_MSEG-BWART     .
*  wa_final-MENGE      = wa_mseg-MENGE     .
*  wa_final-DMBTR      = wa_mseg-DMBTR     .
    WA_FINAL-LGORT      = WA_MSEG-LGORT     .
    WA_FINAL-KDAUF      = WA_MSEG-KDAUF     .
    WA_FINAL-KDPOS      = WA_MSEG-KDPOS     .
    WA_FINAL-AUFNR      = WA_MSEG-AUFNR     .
    WA_FINAL-MEINS      = WA_MSEG-MEINS     .
    WA_FINAL-WERKS      = WA_MSEG-WERKS     .
    WA_FINAL-SHKZG      = WA_MSEG-SHKZG     .

    IF WA_final-SHKZG = 'H'.
      WA_FINAL-MENGE = WA_MSEG-MENGE * -1.
      WA_FINAL-DMBTR = WA_MSEG-DMBTR * -1.
*      MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING MENGE DMBTR WHERE MBLNR = WA_FINAL-MBLNR AND ZEILE = WA_FINAL-ZEILE.
    ELSEIF WA_final-SHKZG = 'S'.
      WA_FINAL-MENGE = WA_MSEG-MENGE * 1.
      WA_FINAL-DMBTR = WA_MSEG-DMBTR * 1.
*      MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING MENGE DMBTR WHERE MBLNR = WA_FINAL-MBLNR AND ZEILE = WA_FINAL-ZEILE.
    ENDIF.

    SELECT SINGLE BTEXT INTO WA_FINAL-BTEXT FROM T156T WHERE SPRAS = 'EN' AND BWART = WA_FINAL-BWART.
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.

  DESCRIBE TABLE IT_FINAL LINES N.  " TO FETCH TOTAL NUMBER OF RECORDS

*************************** TO DOWNLOAD DATA ***********************************
IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MATNR      = WA_FINAL-MATNR.
*    WA_DOWN-BUDAT_MKPF = WA_FINAL-BUDAT_MKPF.
      WA_DOWN-MBLNR      = WA_FINAL-MBLNR.
      WA_DOWN-ZEILE      = WA_FINAL-ZEILE.
      WA_DOWN-BWART      = WA_FINAL-BWART.
      WA_DOWN-LGORT      = WA_FINAL-LGORT.
      WA_DOWN-KDAUF      = WA_FINAL-KDAUF.
      WA_DOWN-KDPOS      = WA_FINAL-KDPOS.
      WA_DOWN-AUFNR      = WA_FINAL-AUFNR.
      WA_DOWN-MEINS      = WA_FINAL-MEINS.
      WA_DOWN-WERKS      = WA_FINAL-WERKS.
      WA_DOWN-SHKZG      = WA_FINAL-SHKZG.
      WA_DOWN-BTEXT      = WA_FINAL-BTEXT.


      WA_DOWN-MENGE      = ABS( WA_FINAL-MENGE ).
      WA_DOWN-DMBTR      = ABS( WA_FINAL-DMBTR ).

      IF WA_final-MENGE < 0 .
        CONDENSE WA_DOWN-MENGE.
        CONCATENATE '-' WA_DOWN-MENGE INTO WA_DOWN-MENGE.
      ENDIF.

      IF WA_final-DMBTR < 0 .
        CONDENSE WA_DOWN-DMBTR.
        CONCATENATE '-' WA_DOWN-DMBTR INTO WA_DOWN-DMBTR.
      ENDIF.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO WA_DOWN-TIME SEPARATED BY ':'.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BUDAT_MKPF
        IMPORTING
          OUTPUT = WA_DOWN-BUDAT_MKPF.

      CONCATENATE WA_DOWN-BUDAT_MKPF+0(2) WA_DOWN-BUDAT_MKPF+2(3) WA_DOWN-BUDAT_MKPF+5(4)
                      INTO WA_DOWN-BUDAT_MKPF SEPARATED BY '-'.

      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
    ENDLOOP.
  ENDIF.
********************************************************************************
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_fcat .
    V_POS = 0.
    FCAT 'MATNR     '     'Material No.'.
    FCAT 'BUDAT_MKPF'     'Posting Date'.
    FCAT 'MBLNR     '     'Material Document No.'.
    FCAT 'ZEILE     '     'Item in Material Document'.
    FCAT 'BWART     '     'Movement Type'.
    FCAT 'BTEXT     '     'Mov.Type Desc'.
    FCAT 'MENGE     '     'Quantity'.
    FCAT 'DMBTR     '     'Amount'.
    FCAT 'LGORT     '     'Storage Location'.
    FCAT 'KDAUF     '     'Sales Order NO'.
    FCAT 'KDPOS     '     'Item No'.
    FCAT 'AUFNR     '     'Order No'.
    FCAT 'MEINS     '     'Unit Of Measure'.
    FCAT 'WERKS     '     'Plant'.
    FCAT 'SHKZG     '     'Debit/Credit Indicator'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALVGRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alvgrid .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID
      I_CALLBACK_TOP_OF_PAGE = 'TOP_OF_PAGE'
      IT_FIELDCAT            = IT_FCAT
    TABLES
      T_OUTTAB               = IT_FINAL.
  .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.
ENDFORM.

FORM TOP_OF_PAGE .

  DATA :
    IT_HEADER TYPE SLIS_T_LISTHEADER,
    WA_HEADER LIKE LINE OF IT_HEADER.

  CLEAR IT_HEADER.

  WA_HEADER-TYP = 'H'.
  WA_HEADER-INFO = 'MB51 REPORT For Saudi'.
  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.

  WA_HEADER-TYP = 'S'.
  WA_HEADER-KEY = 'DATE: '.
  CONCATENATE SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM(4) INTO WA_HEADER-INFO.
  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.

  WA_HEADER-TYP = 'S'.
  WA_HEADER-KEY = 'Total No Of Records:'.
  WA_HEADER-INFO = N.
  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = IT_HEADER.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE         TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = IT_DOWN
    CHANGING
      i_tab_converted_data = IT_CSV
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


    LV_FILE = 'ZSU_MB51_DETAILS.TXT'.


*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSU_MB51 REPORT Started On', sy-datum, 'At', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_398 TYPE string.
DATA lv_crlf_398 TYPE string.
lv_crlf_398 = cl_abap_char_utilities=>cr_lf.
lv_string_398 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_398 lv_crlf_398 wa_csv INTO lv_string_398.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_441 TO lv_fullfile.
TRANSFER lv_string_398 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'Downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    PD_CSV.         "p_hd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Material No.'
              'Posting Date'
              'Material Document No.'
              'Item in Material Document'
              'Movement Type'
              'Quantity'
              'Amount'
              'Storage Location'
              'Sales Order No'
              'Item No'
              'Order No'
              'Unit Of Measure'
              'Plant'
              'Debit/Credit Indicator'
              'Mov.Type Desc'
              'Refreshable Date'
              'Refreshable TIME'
              INTO pd_csv
               SEPARATED BY l_field_seperator.
ENDFORM.
