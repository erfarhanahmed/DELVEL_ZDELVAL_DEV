*&---------------------------------------------------------------------*
*& Report ZBDC_ZCASHFLOW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBDC_CASHFLOW.
TABLES : ZCASHFLOW .

TYPES: BEGIN OF ts_zcashflow,
*        mandt    TYPE zcashflow-mandt,
        bukrs    TYPE zcashflow-bukrs,
        ktopl    TYPE zcashflow-ktopl,
        head     TYPE zcashflow-head,
        item     TYPE zcashflow-item,
        saknr    TYPE zcashflow-saknr,
        direct   TYPE zcashflow-direct,
        indirect TYPE zcashflow-indirect,
      END OF ts_zcashflow.

DATA : IT_TAB TYPE TABLE OF ts_zcashflow,
       LS_TAB TYPE ts_zcashflow .


DATA : LT TYPE TABLE OF zcashflow,
       LS TYPE zcashflow .


DATA: IT_BDCDATA TYPE TABLE OF BDCDATA,
      WA_BDCDATA TYPE BDCDATA.
DATA: RAW_DATA(4096) TYPE C OCCURS 0,
      IT_MSG   TYPE TABLE OF BDCMSGCOLL WITH HEADER LINE.


SELECTION-SCREEN : BEGIN OF block b1 with FRAME TITLE text-001 .

PARAMETERS: P_FILE TYPE RLGRAP-FILENAME.

SELECTION-SCREEN : END OF block b1 .



AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
*     FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FILE.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = RAW_DATA
      I_FILENAME           = P_FILE
    TABLES
      I_TAB_CONVERTED_DATA = IT_TAB
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
**********************************************************************TABLE DATA END

START-OF-SELECTION .


  loop at it_tab into ls_tab.
   LS-MANDT   =  SY-MANDT .
  ls-bukrs    =  ls_tab-bukrs   .
  ls-ktopl    =  ls_tab-ktopl   .
  ls-head     =  ls_tab-head    .
  ls-item     =  ls_tab-item    .
  ls-saknr    =  ls_tab-saknr   .
  ls-direct   =  ls_tab-direct  .
  ls-indirect =  ls_tab-indirect.

   INSERT  zcashflow FROM  LS .

  clear ls .
    endloop.



  if sy-subrc eq 4.


    MESSAGE 'Update is not possible' type 'E'.
    ELSE.
       MESSAGE 'Table Updated Successfully' type 'S'.

    ENDIF .
