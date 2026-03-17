report ZINVENTORY_BDC
       no standard page heading line-size 255.

TYPES: BEGIN OF TY_FINAL,                               "RECORDING STRUCTURE
       ANLN1 TYPE ANLA-ANLN1,
       ANLN2 TYPE ANLA-ANLN2,
       BUKRS TYPE ANLA-BUKRS,
       INVNR TYPE ANLA-INVNR,
       END OF TY_FINAL.
DATA: IT_FINAL TYPE TABLE OF TY_FINAL,                  "INTERNAL TABLE FOR STRUCTURE
      WA_FINAL TYPE          TY_FINAL.                  "WORK AREA FOR STRUCTURE

DATA: IT_BDCDATA TYPE TABLE OF BDCDATA,                 "INTERNAL TABLE FOR BDCDATA
      WA_BDCDATA TYPE          BDCDATA.                 "WORK AREA FOR BDCDATA

DATA: IT_BDCMSGCOLL TYPE TABLE OF BDCMSGCOLL,           "INTERNAL TABLE FOR BDC MESSAGE
      WA_BDCMSGCOLL TYPE          BDCMSGCOLL.           "WORK AREA FOR BDC MESSAGE

DATA: IT_RAWDATA TYPE TRUXS_T_TEXT_DATA.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS: P_FILE   TYPE RLGRAP-FILENAME.                  "INPUT PARAMETER FOR FILE UPLOAD
PARAMETERS: CTU_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'A'.   "INPUT PARAMETER FOR SELECTION MODE
SELECTION-SCREEN: END OF BLOCK B1.
*include bdcrecx1.

*start-of-selection.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.        "FUNCTION MODULE FOR F4 HELP
CALL FUNCTION 'F4_FILENAME'
 EXPORTING
   PROGRAM_NAME        = SYST-CPROG
   DYNPRO_NUMBER       = SYST-DYNNR
   FIELD_NAME          = ' '
 IMPORTING
   FILE_NAME           = P_FILE
          .

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'                 "FUNCTION MODULE TO CONVERT EXCEL SHEET TO SAP
  EXPORTING
*   I_FIELD_SEPERATOR          =
   I_LINE_HEADER              = 'X'
    i_tab_raw_data             = IT_RAWDATA
    i_filename                 = P_FILE
  TABLES
    i_tab_converted_data       = IT_FINAL
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

START-OF-SELECTION.
LOOP AT IT_FINAL INTO WA_FINAL.                         "RECORDING VALUES
*perform open_group.

perform bdc_dynpro      using 'SAPLAIST' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLA-ANLN1'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'ANLA-ANLN1'
                              WA_FINAL-ANLN1. "'24000000'.
perform bdc_field       using 'ANLA-ANLN2'
                              WA_FINAL-ANLN2. "'0'.
perform bdc_field       using 'ANLA-BUKRS'
                              WA_FINAL-BUKRS. "'1000'.
perform bdc_dynpro      using 'SAPLAIST' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BUCH'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLA-INVNR'.
*perform bdc_field       using 'ANLA-TXT50'
*                              'Internal Order receiver'.
*perform bdc_field       using 'ANLH-ANLHTXT'
*                              'Internal Order receiver'.
perform bdc_field       using 'ANLA-INVNR'
                              WA_FINAL-INVNR. "'abcd1234'.
*perform bdc_transaction using 'AS02'.

*perform close_group.
CALL TRANSACTION 'AS02' USING IT_BDCDATA
                        MODE CTU_MODE
                        UPDATE 'S'
                        MESSAGES INTO IT_BDCMSGCOLL.
REFRESH IT_BDCDATA.
CLEAR WA_BDCDATA.
ENDLOOP.


*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  WA_BDCDATA-PROGRAM  = PROGRAM.
  WA_BDCDATA-DYNPRO   = DYNPRO.
  WA_BDCDATA-DYNBEGIN = 'X'.
  APPEND  WA_BDCDATA TO IT_BDCDATA.
  CLEAR WA_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
    WA_BDCDATA-FNAM = FNAM.
    WA_BDCDATA-FVAL = FVAL.
    APPEND WA_BDCDATA TO IT_BDCDATA.
    CLEAR WA_BDCDATA.
ENDFORM.
