REPORT ZXD01_SAUDI_PROGRAM_NEW
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPE-POOLS: TRUXS.
*----------------------------------------------------------------------*
*  Types Declaration
*----------------------------------------------------------------------*
TYPES : BEGIN OF T_RECORD,
          KTOKD(004),
          BUKRS(004),
          VKORG(004),
          VTWEG(004),
          SPART(010),
          TITLE_MEDI(010),
          NAME1(030),
          SORT1(010),
          STREET(020),
          POST_CODE1(010),
          CITY1(010),
          COUNTRY(010),
          LANGU(010),
          MOB_NUMBER(020),
          SMTP_ADDR(020),
          STCD3(020),
          AKONT(010),
          ZTERM(020),
          VKBUR(020),
          WAERS(005),
          KURST(004),
          VERSG(10),
          KALKS(040),
          LPRIO(020),
          VSBED(010),
          VWERK(010),
          PERFK(010),
          PERRL(010),
          INCO1(003),
          INCO2(028),
          ZTERM1(020),
          KTGRD(020),
          TAXKD(010),
        END OF T_RECORD.

TYPES : BEGIN OF T_RESULT.
    INCLUDE TYPE T_RECORD.
TYPES: MSG(220)  TYPE C,                         "Message
       STATUS(1) TYPE C,                 "Status E or Y
       END OF T_RESULT.


TYPES : BEGIN OF T_DATA,
          LINE(400),
        END OF T_DATA.

TYPES : T_BDCDATA TYPE BDCDATA,
        T_MESS    TYPE BDCMSGCOLL,
        T_T100    TYPE T100.

TYPES : TYPE_T_RECORDS TYPE STANDARD TABLE OF T_RECORD,
        TYPE_T_RESULT  TYPE STANDARD TABLE OF T_RESULT,
        TYPE_T_BDCDATA TYPE STANDARD TABLE OF T_BDCDATA,
        TYPE_T_MESS    TYPE STANDARD TABLE OF T_MESS,
        TYPE_T_T100    TYPE STANDARD TABLE OF T_T100,
        TYPE_T_DATA    TYPE STANDARD TABLE OF T_DATA.

DATA : IT_RECORDS TYPE TYPE_T_RECORDS,     "Int Table - Uploaded Records
       IT_DATA    TYPE TYPE_T_DATA,        "Int Table - Comma Sep Recds
       IT_RESULT  TYPE TYPE_T_RESULT,      "Int Table - Output Records
       IT_BDCDATA TYPE TYPE_T_BDCDATA.     "Batch input: New table

*---------------------------------------------------------------------*
* Variable Declaration                                                *
*---------------------------------------------------------------------*
DATA: V_TOTAL_REC   TYPE I,                  "Total no.of records
      V_SUCCESS_REC TYPE I,                  "No of Successful records
      V_ERROR_REC   TYPE I.                  "No of Error records

DATA: GV_FILENAME TYPE RLGRAP-FILENAME,
      FILENAME    TYPE STRING,
      GV_RAW      TYPE TRUXS_T_TEXT_DATA.

*----------------------------------------------------------------------*
* CONSTANTS
*----------------------------------------------------------------------*
CONSTANTS :
  C_TCODE(04) TYPE C VALUE 'XD01',      "Tran. Code - XD01
  C_A(01)     TYPE C VALUE 'A',
  C_E(01)     TYPE C VALUE 'E',       "Indicator - MSG type ERROR
  C_X(01)     TYPE C VALUE 'X',       "Assigning the Value X
  C_1(01)     TYPE C VALUE '1',       "Value 1
*                c_y(01)    TYPE c VALUE 'Y',
  C_S(01)     TYPE C VALUE 'S',       "Indicator for Success Recd
  C_N(01)     TYPE C VALUE 'N'.       "Indicator for Error Record

*----------------------------------------------------------------------*
* SELECTION-SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*SELECTION-SCREEN SKIP 1.
PARAMETERS: P_FILE  TYPE LOCALFILE OBLIGATORY,              "File to upload data.
            P_FILE2 TYPE LOCALFILE DEFAULT 'C:\'.  "File to download Error Data
*SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
*SELECTION-SCREEN SKIP 1.
PARAMETERS P1 AS CHECKBOX.
*PARAMETERS: p1 no-display RADIOBUTTON GROUP g1 DEFAULT 'X',                "Foreground
*            p2 RADIOBUTTON GROUP g1 .                            "Background
*SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK B2.

*---------------------------------------------------------------------*
*  At Selection-screen on value-request for p_file
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
**To provide F4 Help for the file path on the Selection Screen
  PERFORM GET_FILE CHANGING P_FILE.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE2.
  "To provide F4 Help for the file path on the Selection Screen
  PERFORM GET_FILE CHANGING P_FILE2.
*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*

START-OF-SELECTION.
* Upload the flat file
  PERFORM UPLOAD_FILE USING P_FILE
                   CHANGING IT_RECORDS.
  " IF it_records IS INITIAL.
  "MESSAGE e000 WITH 'No Data has been Uploaded'.
  " ENDIF.

* To validate records uploaded into the internal table
  PERFORM VALIDATE_DATA USING     IT_RECORDS
                        CHANGING  IT_RESULT
                                  V_TOTAL_REC
                                  V_SUCCESS_REC
                                  V_ERROR_REC.

* To transfer the internal table values to the Transaction XDO1
  PERFORM BDC_TRANSACTION CHANGING IT_RESULT
                                   V_ERROR_REC
                                   V_SUCCESS_REC.

  "PERFORM download.

*&---------------------------------------------------------------------*
*&      Form  get_file
*&---------------------------------------------------------------------*
*       This form is to create F4 help for the file path on the
*       Selection Screen
*----------------------------------------------------------------------*
*      <--RP_FILE  File Path Variable
*----------------------------------------------------------------------*
FORM GET_FILE  CHANGING RP_FILE TYPE RLGRAP-FILENAME.

*F4 for the File Path
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      FILE_NAME = RP_FILE.

ENDFORM.                    " get_file

*&---------------------------------------------------------------------*
*&      Form  upload_file
*&---------------------------------------------------------------------*
*       This subroutine uploads the flat file
*----------------------------------------------------------------------*
*      -->  RP_FILE     File Path Variable
*      <--  RT_DATA     Internal Table with records uploaded from
*                       Flat File
*----------------------------------------------------------------------*
FORM UPLOAD_FILE  USING P_FILE TYPE RLGRAP-FILENAME
                  CHANGING IT_RECORDS TYPE TYPE_T_RECORDS.
  "CHANGING it_data TYPE type_t_data.


  GV_FILENAME = P_FILE.

*Upload Excel File

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      I_TAB_RAW_DATA       = GV_RAW
      I_FILENAME           = GV_FILENAME
    TABLES
      I_TAB_CONVERTED_DATA = IT_RECORDS
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " upload_file
*&---------------------------------------------------------------------*
*&      Form  validate_data
*&---------------------------------------------------------------------*
*       This from is to validate the records in the internal table
*----------------------------------------------------------------------*
*      -->  RT_RECORDS     Internal table with Uploaed Records
*      <--  RT_RESULT      Internal table with Success & Error Records
*      <--  RV_TOTAL_REC   Total Number of Records
*      <--  RV_SUCCESS_REC Total Number of Success Records
*      <--  RV_ERROR_REC   Total Number of Error Records
*----------------------------------------------------------------------*
FORM VALIDATE_DATA  USING IT_RECORDS     TYPE TYPE_T_RECORDS
                 CHANGING IT_RESULT      TYPE TYPE_T_RESULT
                          RV_TOTAL_REC   TYPE  I
                          RV_SUCCESS_REC TYPE  I
                          RV_ERROR_REC   TYPE  I.

  DATA : WA_RESULT  TYPE T_RESULT.     "Work Area for t_result
  DATA : V_MSG(100) TYPE C.           "Variable to hold Error Message

  CLEAR : RV_TOTAL_REC,
          RV_SUCCESS_REC,
          RV_ERROR_REC.

  CLEAR WA_RESULT.
  LOOP AT IT_RECORDS INTO WA_RESULT.

    RV_TOTAL_REC = RV_TOTAL_REC + C_1.

*Check for Mandatory fields
    IF WA_RESULT-VKORG IS INITIAL OR WA_RESULT-VTWEG IS INITIAL OR
       WA_RESULT-SPART IS INITIAL.

      MOVE WA_RESULT TO WA_RESULT.
      CONCATENATE 'The Input File Has a missing'
                  'required field' INTO
                  V_MSG SEPARATED BY SPACE.

      WA_RESULT-STATUS = C_E.
      WA_RESULT-MSG    = V_MSG.
      APPEND WA_RESULT TO IT_RESULT.
      CLEAR WA_RESULT.
      RV_ERROR_REC = RV_ERROR_REC + C_1.
      CLEAR V_MSG.

      CONTINUE.
    ELSE.

*if all the above checks are successfull
      MOVE WA_RESULT TO WA_RESULT.
      WA_RESULT-STATUS = C_S.
      APPEND WA_RESULT TO IT_RESULT.
      CLEAR WA_RESULT.
      RV_SUCCESS_REC = RV_SUCCESS_REC + C_1.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " validate_data
*&--------------------------------------------------------------------*
*&      Form  bdc_transaction
*&--------------------------------------------------------------------*
*       This form is used to transfer the internal table values to the
*       Transaction AS02
*---------------------------------------------------------------------*
*      <--  RT_RESULT  Internal table with all valid records which are
*                    to Uploaed Using Transaction AS02
*---------------------------------------------------------------------*
FORM BDC_TRANSACTION CHANGING IT_RESULT  TYPE TYPE_T_RESULT
                              RV_ERROR_REC   TYPE I
                              RV_SUCCESS_REC TYPE I.

  DATA : WA_RESULT TYPE T_RESULT.

  LOOP AT IT_RESULT INTO WA_RESULT WHERE STATUS = C_S.

    REFRESH IT_BDCDATA.

    SET PARAMETER ID 'KUN' FIELD ' '.


    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7100'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'RF02D-SPART'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM BDC_FIELD       USING 'RF02D-KTOKD'
                                  WA_RESULT-KTOKD."'SC01'.
    PERFORM BDC_FIELD       USING 'RF02D-KUNNR'
                                  ''.
    PERFORM BDC_FIELD       USING 'RF02D-BUKRS'
                                   WA_RESULT-BUKRS."'SU00'.
    PERFORM BDC_FIELD       USING 'RF02D-VKORG'
                                 WA_RESULT-VKORG."'SU00'.
    PERFORM BDC_FIELD       USING 'RF02D-VTWEG'
                                   WA_RESULT-VTWEG."'10'.
    PERFORM BDC_FIELD       USING 'RF02D-SPART'
                                   WA_RESULT-SPART."'10'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB02'.
    PERFORM BDC_FIELD       USING 'SZA1_D0100-TITLE_MEDI'
                                   WA_RESULT-TITLE_MEDI."'Company'.
    PERFORM BDC_FIELD       USING 'ADDR1_DATA-NAME1'
                                  WA_RESULT-NAME1."'Shivansh pvt ltd'.
    PERFORM BDC_FIELD       USING 'ADDR1_DATA-SORT1'
                                  WA_RESULT-SORT1."'shivansh'.
    PERFORM BDC_FIELD       USING 'ADDR1_DATA-STREET'
                                  WA_RESULT-STREET."'101 jai tulja bhawani road'.
    PERFORM BDC_FIELD       USING 'ADDR1_DATA-POST_CODE1'
                                WA_RESULT-POST_CODE1.       "'34623'.
    PERFORM BDC_FIELD       USING 'ADDR1_DATA-CITY1'
                                  WA_RESULT-CITY1."'Pune'.
    PERFORM BDC_FIELD       USING 'ADDR1_DATA-COUNTRY'
                                   WA_RESULT-COUNTRY."'sa'.
    PERFORM BDC_FIELD       USING 'ADDR1_DATA-LANGU'
                                   WA_RESULT-LANGU."'EN'.
    PERFORM BDC_FIELD       USING 'SZA1_D0100-MOB_NUMBER'
                                   WA_RESULT-MOB_NUMBER."'7776863836'.
    PERFORM BDC_FIELD       USING 'SZA1_D0100-SMTP_ADDR'
                                  WA_RESULT-SMTP_ADDR."'yjoshi@delvalflow.com'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB03'.
    PERFORM BDC_FIELD       USING 'KNA1-STCD3'
                                   WA_RESULT-STCD3."'urp'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB04'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNBK-BANKL(01)'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB05'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNA1-NIELS'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB06'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNVA-ABLAD(01)'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB07'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNEX-LNDEX(01)'.
    PERFORM BDC_FIELD       USING 'KNA1-CIVVE'
                                  'X'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=FISEG'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNVK-NAME1(01)'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB02'.
    PERFORM BDC_FIELD       USING 'KNB1-AKONT'
                                   WA_RESULT-AKONT.         "'450030'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB03'.
    PERFORM BDC_FIELD       USING 'KNB1-ZTERM'
                                  WA_RESULT-ZTERM. "'sc01'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB04'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNB5-MAHNA'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=SDSEG'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNB1-VRSNR'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB02'.
    "perform bdc_field       using 'KNVV-AWAHR'
    "  gs_final-awahr. "'100'.
    PERFORM BDC_FIELD       USING 'KNVV-VKBUR'
                                   WA_RESULT-VKBUR. "'SU01'.
    PERFORM BDC_FIELD       USING 'KNVV-WAERS'
                                 WA_RESULT-WAERS. "'USD'.
    PERFORM BDC_FIELD       USING 'KNVV-KURST'
                                  WA_RESULT-KURST. "'B'.
    PERFORM BDC_FIELD       USING 'KNVV-KALKS'
                                WA_RESULT-KALKS. "'1'.
    PERFORM BDC_FIELD    USING 'KNVV-VERSG'   WA_RESULT-VERSG."'1'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'LINK_KNVH-VALID_TO'.
    PERFORM BDC_FIELD       USING 'LINK_KNVH-VALID_FROM'
                                  '31.10.2023'.
    PERFORM BDC_FIELD       USING 'LINK_KNVH-VALID_TO'
                                  '31.12.9999'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB03'.
    PERFORM BDC_FIELD       USING 'KNVV-LPRIO'
                                   WA_RESULT-LPRIO. "'01'.
    PERFORM BDC_FIELD       USING 'KNVV-KZAZU'
                                  'X'.
    PERFORM BDC_FIELD       USING 'KNVV-VSBED'
                                WA_RESULT-VSBED. "'01'.
    PERFORM BDC_FIELD       USING 'KNVV-VWERK'
                                   WA_RESULT-VWERK. "'su01'.
    "perform bdc_field       using 'KNVV-ANTLF'
    " '9'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=TAB05'.
    PERFORM BDC_FIELD       USING 'KNVV-PERFK'
                                   WA_RESULT-PERFK. "'in'.
    PERFORM BDC_FIELD       USING 'KNVV-PERRL'
                                   WA_RESULT-PERRL. "'in'.
    PERFORM BDC_FIELD       USING 'KNVV-INCO1'
                                   WA_RESULT-INCO1. "'fob'.
    PERFORM BDC_FIELD       USING 'KNVV-INCO2'
                                   WA_RESULT-INCO2. "'free on board'.
    PERFORM BDC_FIELD       USING 'KNVV-ZTERM'
                                   WA_RESULT-ZTERM1. "'sc01'.
    PERFORM BDC_FIELD       USING 'KNVV-KTGRD'
                                   WA_RESULT-KTGRD. "'s1'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNVI-TAXKD(01)'.
    PERFORM BDC_FIELD       USING 'KNVI-TAXKD(01)'
                                   WA_RESULT-TAXKD. "'0'.
    PERFORM BDC_DYNPRO      USING 'SAPMF02D' '7000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=UPDA'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KNVP-PARVW(01)'.

    PERFORM CALL_TRANSACTION USING C_TCODE  IT_BDCDATA
                          CHANGING WA_RESULT.

    MODIFY IT_RESULT FROM WA_RESULT TRANSPORTING STATUS MSG.

    IF WA_RESULT-STATUS = C_N.
      RV_ERROR_REC = RV_ERROR_REC + C_1.
      RV_SUCCESS_REC = RV_SUCCESS_REC - C_1.
    ENDIF.

  ENDLOOP.
ENDFORM.                    "BDC_TRANSACTION
*&--------------------------------------------------------------------*
*&      Form  call_transaction
*&--------------------------------------------------------------------*
*       This form is used to Call the Transaction and append the error
*       message to the internal table
*---------------------------------------------------------------------*
*      -->  RC_XD01     Value ( XD01 - Transaction Code )
*      <--  RT_BDCDATA  Internal table with all valid records which are
*                       to Uploaed Using Transaction CJ40
*      <--  RS_RESULT   STRUCTURE OF OUTPUT TABLE
*---------------------------------------------------------------------*
FORM CALL_TRANSACTION  USING RC_TCODE    TYPE C
                             IT_BDCDATA  TYPE TYPE_T_BDCDATA
                    CHANGING WA_RESULT   TYPE T_RESULT.

*To hold the message returned from the table BDCMSGGOLL
  DATA: V_MSTRING(480) TYPE C,
        WA_CTU_PARAMS  TYPE CTU_PARAMS.
*Internal Table of the type BDCMSGCOLL
  DATA: IT_MESS TYPE TYPE_T_MESS.
*Work Area for the internal table T_MESS and T_T100
  DATA: WA_MESS TYPE T_MESS,
        WA_T100 TYPE T_T100.

  CLEAR WA_CTU_PARAMS.
  IF P1 = 'X'.
    WA_CTU_PARAMS-DISMODE = 'A'.
  ELSE.
    WA_CTU_PARAMS-DISMODE = 'N'.
  ENDIF.
  WA_CTU_PARAMS-UPDMODE = 'S'.
  WA_CTU_PARAMS-NOBINPT = 'X'.

  REFRESH IT_MESS.

*Call Transaction VBO1 and pass the values
*  CALL TRANSACTION rc_xd01 USING  it_bdcdata
*                           MODE   c_a                   "ctumode
*                           UPDATE c_a                   "cupdate
*                           MESSAGES INTO it_mess.

  CALL TRANSACTION RC_TCODE USING IT_BDCDATA
    OPTIONS FROM WA_CTU_PARAMS
    MESSAGES INTO IT_MESS.

  LOOP AT IT_MESS INTO WA_MESS.

*Getting the Error Message from the table T100
    SELECT SINGLE * FROM T100 INTO WA_T100
                    WHERE SPRSL = WA_MESS-MSGSPRA
                     AND  ARBGB = WA_MESS-MSGID
                     AND  MSGNR = WA_MESS-MSGNR.
    IF SY-SUBRC = 0.
      V_MSTRING = WA_T100-TEXT.
      IF V_MSTRING CS '&1'.
        REPLACE '&1' WITH WA_MESS-MSGV1 INTO V_MSTRING.
        REPLACE '&2' WITH WA_MESS-MSGV2 INTO V_MSTRING.
        REPLACE '&3' WITH WA_MESS-MSGV3 INTO V_MSTRING.
        REPLACE '&4' WITH WA_MESS-MSGV4 INTO V_MSTRING.
      ELSE.
        REPLACE '&' WITH WA_MESS-MSGV1 INTO V_MSTRING.
        REPLACE '&' WITH WA_MESS-MSGV2 INTO V_MSTRING.
        REPLACE '&' WITH WA_MESS-MSGV3 INTO V_MSTRING.
        REPLACE '&' WITH WA_MESS-MSGV4 INTO V_MSTRING.
      ENDIF.
      CONDENSE V_MSTRING.

      WA_RESULT-STATUS = WA_MESS-MSGTYP.
      WA_RESULT-MSG    = V_MSTRING.

      IF WA_RESULT-MSG CP 'Customer*has been created for company code*'.
        WA_RESULT-STATUS = 'S'.
      ELSE.
        WA_RESULT-STATUS = 'E'.
      ENDIF.

    ENDIF.
  ENDLOOP.
  CLEAR : WA_T100,
          WA_MESS.

ENDFORM.                    " call_transaction
*&--------------------------------------------------------------------*
*&      Form  bdc_dynpro
*&--------------------------------------------------------------------*
*       This form is used to start a new screen
*---------------------------------------------------------------------*
*      -->  RPROGRAM Program Name
*      -->  RDYNPRO  Screen Number
*---------------------------------------------------------------------*
FORM BDC_DYNPRO  USING RPROGRAM TYPE BDC_PROG
                       RDYNPRO  TYPE BDC_DYNR.

*Work Area for the Internal table T_BDCDATA
  DATA : WA_BDCDATA TYPE T_BDCDATA.

  CLEAR WA_BDCDATA.
  WA_BDCDATA-PROGRAM  = RPROGRAM.
  WA_BDCDATA-DYNPRO   = RDYNPRO.
  WA_BDCDATA-DYNBEGIN = C_X.
  APPEND WA_BDCDATA TO IT_BDCDATA.

ENDFORM.                    " bdc_dynpro
*&--------------------------------------------------------------------*
*&      Form  bdc_field
*&--------------------------------------------------------------------*
*       This form is used to insert field values
*---------------------------------------------------------------------*
*      -->RFNAM   Field Name
*      -->RFVAL   Field Value
*---------------------------------------------------------------------*
FORM BDC_FIELD  USING RFNAM TYPE FNAM_____4
                      RFVAL.
*Work Area for the Internal table T_BDCDATA
  DATA : WA_BDCDATA TYPE T_BDCDATA.

  CLEAR WA_BDCDATA.
  WA_BDCDATA-FNAM = RFNAM.
  WA_BDCDATA-FVAL = RFVAL.
  APPEND WA_BDCDATA TO IT_BDCDATA.

ENDFORM.                    " bdc_field
