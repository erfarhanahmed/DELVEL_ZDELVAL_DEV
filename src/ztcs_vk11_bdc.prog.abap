*&---------------------------------------------------------------------*
*& Report ZTCS_VK11_BDC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTCS_VK11_BDC
           no standard page heading line-size 255.



*include bdcrecx1.

TABLES:sscrfields.

TYPES: BEGIN OF TY_FINAL,
       KSCHL TYPE RV13A-KSCHL,
       LLAND TYPE KOMG-LLAND,
       BUKRS TYPE KOMG-BUKRS,
       TAXK6 TYPE KOMG-TAXK6,
       IDCHECK TYPE KOMG-IDCHECK,
       STEUC TYPE KOMG-STEUC,
       KBETR TYPE KONP-KBETR,
       DATAB TYPE RV13A-DATAB,
       DATBI TYPE RV13A-DATBI,
       MWSK1 TYPE KONP-MWSK1,
       END OF TY_FINAL.

DATA: LT_FINAL TYPE TABLE OF TY_FINAL,
      LS_FINAL TYPE TY_FINAL,
      LS_AMT TYPE STRING.

DATA: LT_BDCDATA TYPE TABLE OF BDCDATA,
      LS_BDCDATA TYPE BDCDATA.

DATA : TEXT(4096) TYPE C OCCURS 0.

TYPES: BEGIN OF TY_FIELDNAMES,
        FIELD_NAME(30) TYPE C,
       END OF TY_FIELDNAMES.

DATA: LT_FIELDNAMES TYPE TABLE OF TY_FIELDNAMES,
      LS_FIELDNAMES TYPE TY_FIELDNAMES.


SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS     : file TYPE rlgrap-filename.
PARAMETERS     : ctu_mode TYPE ctu_params-dismode DEFAULT 'N'.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN :BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) L_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN :END OF LINE.

INITIALIZATION.
L_BUTTON = 'Download Excel Template'.

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1'.
     SUBMIT ZUPLOAD_FILE_DATA VIA SELECTION-SCREEN.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR FILE.

CALL FUNCTION 'F4_FILENAME'
* EXPORTING
*   PROGRAM_NAME        = SYST-CPROG
*   DYNPRO_NUMBER       = SYST-DYNNR
*   FIELD_NAME          = ' '
 IMPORTING
   FILE_NAME            = FILE
          .

start-of-selection.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
   I_LINE_HEADER               = 'X'
    i_tab_raw_data             = TEXT[]
    i_filename                 = FILE
  TABLES
    i_tab_converted_data       = LT_FINAL
 EXCEPTIONS
   CONVERSION_FAILED           = 1
   OTHERS                      = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*start-of-selection.

*perform open_group.
LOOP AT LT_FINAL INTO LS_FINAL.
REFRESH LT_BDCDATA.
LS_AMT = LS_FINAL-KBETR.
perform bdc_dynpro      using 'SAPMV13A' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV13A-KSCHL'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RV13A-KSCHL'
                               LS_FINAL-KSCHL.  "'JTC1'.
perform bdc_dynpro      using 'SAPMV13A' '3949'.
perform bdc_field       using 'BDC_CURSOR'
                              'KONP-MWSK1(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'KOMG-LLAND'
                              LS_FINAL-LLAND. "'in'.
perform bdc_field       using 'KOMG-BUKRS'
                              LS_FINAL-BUKRS. "'1000'.
perform bdc_field       using 'KOMG-TAXK6'
                              LS_FINAL-TAXK6 ."'0'.
perform bdc_field       using 'KOMG-IDCHECK'
                              LS_FINAL-IDCHECK. "'01'.
perform bdc_field       using 'KOMG-STEUC(01)'
                              LS_FINAL-STEUC. "'7320.10.11'.
perform bdc_field       using 'KONP-KBETR(01)'
                              LS_AMT. "LS_FINAL-KBETR."'           0.075'.
perform bdc_field       using 'RV13A-DATAB(01)'
                              LS_FINAL-DATAB.
perform bdc_field       using 'RV13A-DATBI(01)'
                              LS_FINAL-DATBI.
perform bdc_field       using 'KONP-MWSK1(01)'
                              LS_FINAL-MWSK1.  "'&&'.
perform bdc_dynpro      using 'SAPMV13A' '3949'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SICH'.
*perform bdc_transaction using 'VK11'.

CALL TRANSACTION 'VK11' USING LT_BDCDATA MODE CTU_MODE UPDATE 'N'.

ENDLOOP.

*perform close_group.
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR LS_BDCDATA.
  LS_BDCDATA-PROGRAM  = PROGRAM.
  LS_BDCDATA-DYNPRO   = DYNPRO.
  LS_BDCDATA-DYNBEGIN = 'X'.
  APPEND LS_BDCDATA TO LT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
    CLEAR LS_BDCDATA.
    LS_BDCDATA-FNAM = FNAM.
    LS_BDCDATA-FVAL = FVAL.
    APPEND LS_BDCDATA TO LT_BDCDATA.
*  ENDIF.
ENDFORM.
