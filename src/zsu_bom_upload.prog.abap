*&---------------------------------------------------------------------*
*& Report ZSU_BOM_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_BOM_UPLOAD NO STANDARD PAGE HEADING LINE-SIZE 255.

TABLES :SSCRFIELDS.

DATA: BDCDATA LIKE BDCDATA    OCCURS 0 WITH HEADER LINE.
DATA : LT_MSGTAB TYPE STANDARD TABLE OF BDCMSGCOLL,
       WA_MSGTAB TYPE BDCMSGCOLL.
DATA:   LV_MESTEXT TYPE CHAR100.
DATA:IT_ROW TYPE TRUXS_T_TEXT_DATA.
DATA: BEGIN OF ITAB OCCURS 0,
        MATNR(018) TYPE C,           "EQUIPMENT NUMBER
        STLAN(001) TYPE C,           "BOM USAGE
        IDNRK(036) TYPE C,           "COMPONENT
        POSTP(001) TYPE C,
        MENGE(013) TYPE C,           "QUANTITY
        LGORT(004) TYPE C,
      END OF ITAB .

DATA: BEGIN OF ITAB1 OCCURS 0,
        MATNR(018) TYPE C,           "EQUIPMENT NUMBER
        STLAN(001) TYPE C,           "BOM USAGE
        IDNRK(036) TYPE C,           "COMPONENT
        POSTP(001) TYPE C,
        MENGE(013) TYPE C,           "QUANTITY
        LGORT(004) TYPE C,
      END OF ITAB1  .

DATA: BEGIN OF ITAB2 OCCURS 0,
        MATNR(018) TYPE C,           "EQUIPMENT NUMBER
        STLAN(001) TYPE C,           "BOM USAGE
        IDNRK(036) TYPE C,           "COMPONENT
        POSTP(001) TYPE C,
        MENGE(013) TYPE C,           "QUANTITY
        LGORT(004) TYPE C,
      END OF ITAB2.


DATA : BEGIN OF ITAB3 OCCURS 0,
         MATNR(018) TYPE C,           "EQUIPMENT NUMBER
         STLAN(001) TYPE C,           "BOM USAGE
         IDNRK(036) TYPE C,           "COMPONENT
         POSTP(001) TYPE C,
         MENGE(013) TYPE C,           "QUANTITY
         LGORT(004) TYPE C,
       END OF ITAB3.

DATA : V_COUNT2 TYPE I.
DATA : V_POSNR TYPE I.

DATA : V_PAGE TYPE I.
DATA : IT_EXCEL TYPE TABLE OF ALSMEX_TABLINE.
*DATA : it_excel TYPE rlgrap-FILENAME.
DATA : WA_EXCEL TYPE ALSMEX_TABLINE.

DATA:   LV_RAW      TYPE TRUXS_T_TEXT_DATA.


V_PAGE = 0.


TYPES : BEGIN OF GT_FINAL,

*          MATNR TYPE MARA-MATNR,
*          STLAN TYPE MAST-STLAN,
*          IDNRK TYPE STPO-IDNRK,
*          POSTP TYPE STPO-POSTP,
*          MENGE TYPE STPO-MENGE,
*          LGORT TYPE STPO-LGORT,
            MATNR(018) TYPE C,
            STLAN(001) TYPE C,
            IDNRK(036) TYPE C,
            POSTP(001) TYPE C,
            MENGE(013) TYPE C,
            LGORT(004) TYPE C,



        END OF GT_FINAL.

DATA :  I_FILE TYPE TABLE OF GT_FINAL.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT_001.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) TEXT_1_1.
PARAMETERS: P_FILE LIKE RLGRAP-FILENAME ."OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B1.
PARAMETERS CTUMODE TYPE CTU_PARAMS-DISMODE DEFAULT 'N'.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.

*----------------------------------------------------------------------*
* Initialization Event
*----------------------------------------------------------------------*
INITIALIZATION.
  TEXT_001 = 'File path selection'.
  TEXT_1_1 = 'File Path'.
  W_BUTTON = 'Download Excel Template'.

*----------------------------------------------------------------------*
* AT SELECTION-SCREEN
*----------------------------------------------------------------------*

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    SUBMIT  ZSU_BOM_UPLOAD_EXCEL VIA SELECTION-SCREEN .
  ENDIF.


*----------------------------------------------------------------------*
* At Selection Screen Event
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      FILE_NAME = P_FILE.

*&---------------------------------------------------------------------*
*& Start of Selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM DATA_UPLOAD.
  PERFORM MANIPULATE_DATA.
  IF I_FILE[] IS NOT INITIAL.
    PERFORM OPEN_GROUP.

    REFRESH BDCDATA.
    PERFORM BDCDATA.

    PERFORM CLOSE_GROUP.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  DATA_UPLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA_UPLOAD.

  DATA: LOC_FILENAME TYPE LOCALFILE..

  LOC_FILENAME = P_FILE.

* Make to usable content
  BREAK-POINT.
DATA: L_FILE   TYPE RLGRAP-FILENAME.
*CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
*    EXPORTING
*      filename                = loc_filename
*      i_begin_col             = '1'
*      i_begin_row             = '2'
*      i_end_col               = '34'
*      i_end_row               = '9999'
*    TABLES
*      intern                  = it_excel
*    EXCEPTIONS
*      inconsistent_parameters = 1
*      upload_ole              = 2
*      OTHERS                  = 3.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT  = LOC_FILENAME
    IMPORTING
      OUTPUT = L_FILE.

*  ENDIF.
CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          = it_raw
*   I_LINE_HEADER              =
    I_TAB_RAW_DATA             = it_row
    I_FILENAME                 = L_FILE
  TABLES
    I_TAB_CONVERTED_DATA       = I_FILE" it_excel
* EXCEPTIONS
*   CONVERSION_FAILED          = 1
*   OTHERS                     = 2
  .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT I_FILE INTO WA_EXCEL.

    CASE WA_EXCEL-COL.

      WHEN '0001'. ITAB-MATNR = WA_EXCEL-VALUE.
      WHEN '0002'. ITAB-STLAN = WA_EXCEL-VALUE.
      WHEN '0003'. ITAB-IDNRK = WA_EXCEL-VALUE.
      WHEN '0004'. ITAB-POSTP = WA_EXCEL-VALUE.
      WHEN '0005'. ITAB-MENGE = WA_EXCEL-VALUE.
      WHEN '0006'. ITAB-LGORT = WA_EXCEL-VALUE.

    ENDCASE.
*    AT END OF RO.
      APPEND ITAB.
*    ENDAT.
  ENDLOOP.
ENDFORM.                    " DATA_UPLOAD

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  CLEAR BDCDATA.
  BDCDATA-FNAM = FNAM.
  BDCDATA-FVAL = FVAL.
  APPEND BDCDATA.
ENDFORM.                    "BDC_FIELD

*&---------------------------------------------------------------------*
*&      Form  OPEN_GROUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM OPEN_GROUP .

  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      CLIENT = SY-MANDT
      GROUP  = 'GROUP_NAME'
      USER   = SY-UNAME
      KEEP   = 'X'.

ENDFORM.                    " OPEN_GROUP

*&---------------------------------------------------------------------*
*&      Form  CLOSE_GROUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLOSE_GROUP .
  CALL FUNCTION 'BDC_CLOSE_GROUP'.
*  CALL TRANSACTION 'SM35'.
ENDFORM.                    " CLOSE_GROUP

*&---------------------------------------------------------------------*
*&      Form  bdcdata
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BDCDATA .

  DATA : V_COUNT1 TYPE I VALUE 0.
  DATA: V_FIELD1 TYPE STRING,
        V_FIELD2 TYPE STRING,
        V_FIELD3 TYPE STRING,
        V_FIELD4 TYPE STRING,
        V_FIELD5 TYPE STRING.

  DATA : V_TEMP(2) TYPE C.
  DATA : V_TEMP1 TYPE C.
  DATA : FLAG TYPE I VALUE 0.

  DATA: LV_DATE(10) TYPE C.
  DATA : LV_DAY(2)    TYPE C,
         LV_DAY1(3)   TYPE C,
         LV_MONTH(2)  TYPE C,
         LV_MONTH1(3) TYPE C,
         LV_DATE1(6)  TYPE C,
         LV_YEAR(4)   TYPE C,
         LV_MATNR     TYPE MARA-MATNR.

*  lv_year = sy-datum+0(4).
*  lv_month = sy-datum+4(2).
*  lv_day = sy-datum+6(2).
*
*  CONCATENATE lv_day '.' INTO  lv_day1.
*  CONCATENATE lv_month '.' INTO lv_month1.
*  CONCATENATE lv_day1 lv_month1 INTO lv_date1.
*  CONCATENATE lv_date1 lv_year INTO lv_date.
  LV_DATE = '01.04.2023'.

  V_COUNT1 = 0.



  LOOP AT ITAB1.
    PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0100'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'   '/00'.
    PERFORM BDC_FIELD       USING 'RC29N-MATNR'  ITAB1-MATNR.
    PERFORM BDC_FIELD       USING 'RC29N-WERKS'  'SU01'.
    PERFORM BDC_FIELD       USING 'RC29N-STLAN'   ITAB1-STLAN.

    IF ITAB1-STLAN = '2'.
      PERFORM BDC_FIELD       USING 'RC29N-STLAL' '01'.
    ENDIF.

    IF ITAB1-STLAN = '1'.
      PERFORM BDC_FIELD       USING 'RC29N-STLAL'  '01'.
    ENDIF.

    PERFORM BDC_FIELD       USING 'RC29N-DATUV'   LV_DATE .
    PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0110'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'   'RC29K-ZTEXT'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'   '/00'.
    PERFORM BDC_FIELD       USING 'RC29K-STLST'  '1'.

    PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0111'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'   '/00'.

    CLEAR V_COUNT1.
    V_COUNT1 = 0.
    LOOP AT ITAB2 WHERE  MATNR = ITAB1-MATNR AND
                         "werks = itab1-werks AND
                         STLAN = ITAB1-STLAN." AND
      "Datuv = itab1-datuv .
*                     menge = itab1-menge and
*                      meins = itab1-meins .
      IF FLAG = 1.
        V_COUNT1 = V_COUNT1 + 2.
      ELSE.
        V_COUNT1 = V_COUNT1 + 1.
      ENDIF.

      FLAG = 0.

      MOVE V_COUNT1 TO V_TEMP.
*CONCATENATE 'RC29P-AUSKZ(' v_temp ')' INTO v_field1.
      CONCATENATE 'RC29P-idnrk(' V_TEMP ')' INTO V_FIELD2.
      CONCATENATE 'RC29P-menge(' V_TEMP ')' INTO V_FIELD3.
      CONCATENATE 'RC29P-POSTP(' V_TEMP ')' INTO V_FIELD4.
*CONCATENATE 'RC29P-meins(' v_temp ')' INTO v_field4.               "asim

      PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0140'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'  'RC29P-AUSKZ(01)'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'  '/00'.
*  perform bdc_field       using 'BDC_OKCODE'  '=WIZU'.
*  perform bdc_field       using v_field1   'X'.
      PERFORM BDC_FIELD       USING V_FIELD2   ITAB2-IDNRK.   "'2780603001'.
      PERFORM BDC_FIELD       USING V_FIELD3   ITAB2-MENGE.
      PERFORM BDC_FIELD       USING V_FIELD4   ITAB2-POSTP .

      PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0130'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'   '/00'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'   'RC29P-POSNR'.
      PERFORM BDC_FIELD       USING 'RC29P-IDNRK'   ITAB2-IDNRK .
      PERFORM BDC_FIELD       USING 'RC29P-MENGE'   ITAB2-MENGE .
*  perform bdc_field       using 'RC29P-MEINS'               "asim   "changed
**                                'NO'.
*                              itab2-meins .

      PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0131'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'   '/00'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'   'RC29P-POTX1'.
      PERFORM BDC_FIELD       USING 'RC29P-SANKA'  'X'.
      IF ITAB2-STLAN = '1'.
        PERFORM BDC_FIELD       USING 'RC29P-LGORT'   ITAB2-LGORT.
      ENDIF.

      IF V_COUNT1 > 13 .           "8
        V_PAGE = V_COUNT1 MOD 14.           "9
        IF V_PAGE = 0.
          PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0140'.          " asim 24.12.2008
          PERFORM BDC_FIELD       USING 'BDC_CURSOR'  'RC29P-POSNR(01)'.
          PERFORM BDC_FIELD       USING 'BDC_OKCODE'  '=FCNP'.
          FLAG = 1.
          V_COUNT1 = 0.
        ENDIF.

      ENDIF.
    ENDLOOP.

    PERFORM BDC_DYNPRO      USING 'SAPLCSDI' '0140'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'   'RC29P-POSNR(01)'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'   '=FCBU'.

    CALL TRANSACTION 'CS01' USING BDCDATA
              MODE CTUMODE
              UPDATE 'A'
              MESSAGES INTO LT_MSGTAB.
    WRITE : /5 'Type',  10 'Description'.
    WRITE : /.
    LOOP AT LT_MSGTAB INTO WA_MSGTAB.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          ID        = WA_MSGTAB-MSGID
          LANG      = SY-LANGU
          NO        = WA_MSGTAB-MSGNR
          V1        = WA_MSGTAB-MSGV1
          V2        = WA_MSGTAB-MSGV2
          V3        = WA_MSGTAB-MSGV3
          V4        = WA_MSGTAB-MSGV4
        IMPORTING
          MSG       = LV_MESTEXT
        EXCEPTIONS
          NOT_FOUND = 1
          OTHERS    = 2.
      IF SY-SUBRC EQ 0.
        WRITE : /5 WA_MSGTAB-MSGTYP, 10 LV_MESTEXT.
      ENDIF.
    ENDLOOP.

    CLEAR BDCDATA.
    REFRESH BDCDATA.
  ENDLOOP.

ENDFORM.                    " bdcdata

*&---------------------------------------------------------------------*
*&      Form  MANIPULATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MANIPULATE_DATA .
  LOOP AT ITAB.
    MOVE-CORRESPONDING ITAB TO ITAB1.
    APPEND ITAB1.
    MOVE-CORRESPONDING ITAB TO ITAB2.
    APPEND ITAB2.
    MOVE-CORRESPONDING ITAB TO ITAB3.
    APPEND ITAB3.
    CLEAR: ITAB1, ITAB , ITAB2 .

  ENDLOOP.
  DELETE ADJACENT DUPLICATES FROM ITAB1 COMPARING MATNR STLAN .
  DELETE ADJACENT DUPLICATES FROM ITAB2 COMPARING MATNR STLAN IDNRK MENGE.  "meins." asim


ENDFORM.                    " MANIPULATE_DATA
