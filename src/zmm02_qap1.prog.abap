REPORT ZMM02_QAP1
       NO STANDARD PAGE HEADING LINE-SIZE 255.


TABLES : SSCRFIELDS.

DATA : LT_BDCDATA TYPE TABLE OF BDCDATA WITH HEADER LINE, "BDCDATA
       LS_BDCDATA LIKE LT_BDCDATA . "work area BDCDATA

DATA :V_STR  TYPE STRING,
      V_BOOL TYPE C.

TYPES : BEGIN OF TY_MARA,
          MATNR  TYPE MARA-MATNR,
*          MAKTX TYPE MAKT-MAKTX,
*          zseries type mara-zseries,
*          brand type mara-brand,
*          zsize type mara-zsize,
*          moc type mara-moc,
*          type type mara-type,
          QAP_NO TYPE MARA-QAP_NO,
          REV_NO TYPE MARA-REV_NO,

        END OF TY_MARA.

DATA : LT_MARA TYPE TABLE OF TY_MARA,
       LS_MARA TYPE TY_MARA.

TYPES TRUXS_T_TEXT_DATA(4096) TYPE C OCCURS 0.
DATA : RAWDATA TYPE TRUXS_T_TEXT_DATA.

INITIALIZATION.

  SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : P_FILE TYPE RLGRAP-FILENAME.
  PARAMETERS : CTU_MODE LIKE CTU_PARAMS-DISMODE OBLIGATORY DEFAULT 'N'.
  SELECTION-SCREEN END OF BLOCK B1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FILE.

START-OF-SELECTION.

  V_STR = P_FILE .

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_EXIST
    EXPORTING
      FILE   = V_STR
    RECEIVING
      RESULT = V_BOOL.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = RAWDATA
      I_FILENAME           = P_FILE
    TABLES
      I_TAB_CONVERTED_DATA = LT_MARA
* EXCEPTIONS
*     CONVERSION_FAILED    = 1
*     OTHERS               = 2
    .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  REFRESH LT_BDCDATA.
  PERFORM BDC.
*include bdcrecx1.

*start-of-selection.
*&---------------------------------------------------------------------*
*&      Form  BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*perform open_group.
FORM BDC .

  LOOP AT LT_MARA INTO LS_MARA.
    REFRESH : LT_BDCDATA, LT_BDCDATA.
    PERFORM BDC_DYNPRO      USING 'SAPLMGMM' '0060'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'RMMG1-MATNR'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM BDC_FIELD       USING 'RMMG1-MATNR'
                                  LS_MARA-MATNR.           "'8R06BTRF08100001'.
    PERFORM BDC_DYNPRO      USING 'SAPLMGMM' '0070'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'MSICHTAUSW-DYTXT(01)'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM BDC_FIELD       USING 'MSICHTAUSW-KZSEL(01)'
                                  'X'.
    PERFORM BDC_DYNPRO      USING 'SAPLMGMM' '4004'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=BU'.
*    PERFORM BDC_FIELD       USING 'MAKT-MAKTX'
*                                  '8R,6",BODY SI,FLG RF,CF8M,MR0175,1,-,-'
*                                & ',-'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'MARA-REV_NO'.
*    PERFORM BDC_FIELD       USING 'MARA-ZSERIES'
*                                  '21'.
*    PERFORM BDC_FIELD       USING 'MARA-BRAND'
*                                  'ACT'.
*    PERFORM BDC_FIELD       USING 'MARA-TYPE'
*                                  '10'.
*    PERFORM BDC_FIELD       USING 'MARA-ZSIZE'
*                                  '100'.
*    PERFORM BDC_FIELD       USING 'MARA-MOC'
*                                  '10'.
    PERFORM BDC_FIELD       USING 'MARA-QAP_NO'
                                  LS_MARA-QAP_NO.   "'12345678'.
    PERFORM BDC_FIELD       USING 'MARA-REV_NO'
                                  LS_MARA-REV_NO.        "'01'.
*    PERFORM BDC_FIELD       USING 'MARA-MEINS'
*                                  'NOS'.
*    PERFORM BDC_FIELD       USING 'MARA-MATKL'
*                                  '0001'.
*    PERFORM BDC_FIELD       USING 'MARA-GEWEI'
*                                  'KG'.
*    PERFORM BDC_FIELD       USING 'DESC_LANGU_GDTXT'
*                                  'E'.

    CALL TRANSACTION 'MM02' USING LT_BDCDATA "call transaction
          MODE CTU_MODE"'E'
          UPDATE 'S'.

*    PERFORM BDC_TRANSACTION USING 'MM02'.

*perform close_group.
  ENDLOOP.
ENDFORM.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR LT_BDCDATA.
  LT_BDCDATA-PROGRAM  = PROGRAM.
  LT_BDCDATA-DYNPRO   = DYNPRO.
  LT_BDCDATA-DYNBEGIN = 'X'.
  APPEND LT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF fval <> space.
  CLEAR LT_BDCDATA.
  LT_BDCDATA-FNAM = FNAM.
  LT_BDCDATA-FVAL = FVAL.
*    SHIFT lt_bdcdata-fval LEFT DELETING LEADING space.
  APPEND LT_BDCDATA.
*  ENDIF.
ENDFORM.
