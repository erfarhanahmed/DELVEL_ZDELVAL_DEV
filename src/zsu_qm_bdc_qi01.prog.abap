*&---------------------------------------------------------------------*
*& Report ZQM_BDC_QP01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_QM_BDC_QI01.

TYPES TRUXS_T_TEXT_DATA(4096) TYPE C OCCURS 0.

TYPES : BEGIN OF TY_FILE,
          MATNR(40),        """  Material
          LIFNR(10),        """  Vendor
          WERKS(04),        """  Plant
          FREI_DAT(10),     """  Date
          NOINSP(1),        """  Indicator
        END OF TY_FILE .

DATA : GT_FILE TYPE TABLE OF TY_FILE,
       GS_FILE TYPE TY_FILE.

DATA: GV_FILE    TYPE IBIPPARMS-PATH,
      GT_BDCDATA TYPE TABLE OF BDCDATA.

SELECTION-SCREEN BEGIN OF BLOCK BLK1 WITH FRAME TITLE TEXT-T06 .
PARAMETERS : P_FILE LIKE RLGRAP-FILENAME .
SELECTION-SCREEN END OF BLOCK BLK1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      FILE_NAME = GV_FILE.
  P_FILE = GV_FILE .

START-OF-SELECTION.
  PERFORM READ_DATA.
  IF GT_FILE[] IS NOT INITIAL.
    PERFORM RUN_BDC.
  ELSE.
    MESSAGE 'No Data found' TYPE 'E'.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
FORM READ_DATA .

  TYPES TRUXS_T_TEXT_DATA(4096) TYPE C OCCURS 0.

  DATA: LT_RAWDATA TYPE TRUXS_T_TEXT_DATA.
  DATA: LV_STR  TYPE STRING,
        LV_BOOL TYPE C.

*Read the upload file
  LV_STR = P_FILE .
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_EXIST
    EXPORTING
      FILE   = LV_STR
    RECEIVING
      RESULT = LV_BOOL.

  IF LV_BOOL IS NOT INITIAL .
*    v_file_up = p_file .
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
*       I_LINE_HEADER        =
        I_TAB_RAW_DATA       = LT_RAWDATA
        I_FILENAME           = P_FILE
      TABLES
        I_TAB_CONVERTED_DATA = GT_FILE
      EXCEPTIONS
        CONVERSION_FAILED    = 1
        OTHERS               = 2.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  RUN_BDC
*&---------------------------------------------------------------------*
FORM RUN_BDC .

  LOOP AT GT_FILE INTO GS_FILE.

    PERFORM BDC_DYNPRO      USING 'SAPMQBAA' '0100'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'QINF-MATNR'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM BDC_FIELD       USING 'QINF-MATNR'
                                  GS_FILE-MATNR .   """ '18G12000104EBSW1'.
    PERFORM BDC_FIELD       USING 'QINF-LIEFERANT'
                                  GS_FILE-LIFNR .   """  '100010'.
    PERFORM BDC_FIELD       USING 'QINF-WERK'
                                  GS_FILE-WERKS .   """  'PL01'.

    IF GS_FILE-WERKS NE 'SU01'.

      MESSAGE 'Please Enter correct plant' TYPE 'E' DISPLAY LIKE 'E'.

    ENDIF.

    PERFORM BDC_DYNPRO      USING 'SAPMQBAA' '0101'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'QINF-NOINSP'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=QMBU'.
    PERFORM BDC_FIELD       USING 'QINF-FREI_DAT'
                                  GS_FILE-FREI_DAT .  """"  '31.03.2018'.
    PERFORM BDC_FIELD       USING 'QINF-NOINSP'
                                  GS_FILE-NOINSP  . " """  'X'.

    PERFORM BDC_TRANSACTION USING 'QI01'.
    CLEAR GS_FILE .
  ENDLOOP.
ENDFORM.
*&--------------------------------------------------------------------*
*&      Form  bdc_dynpro
*&--------------------------------------------------------------------*
FORM BDC_DYNPRO  USING RPROGRAM TYPE BDC_PROG
                       RDYNPRO  TYPE BDC_DYNR.

*Work Area for the Internal table T_BDCDATA
  DATA : WA_BDCDATA TYPE BDCDATA.

  CLEAR WA_BDCDATA.
  WA_BDCDATA-PROGRAM  = RPROGRAM.
  WA_BDCDATA-DYNPRO   = RDYNPRO.
  WA_BDCDATA-DYNBEGIN = 'X'.
  APPEND WA_BDCDATA TO GT_BDCDATA.

ENDFORM.                    " bdc_dynpro
*&--------------------------------------------------------------------*
*&      Form  bdc_field
*&--------------------------------------------------------------------*
FORM BDC_FIELD  USING RFNAM TYPE FNAM_____4
                      RFVAL.
*Work Area for the Internal table T_BDCDATA
  DATA : WA_BDCDATA TYPE BDCDATA.

  CLEAR WA_BDCDATA.
  WA_BDCDATA-FNAM = RFNAM.
  WA_BDCDATA-FVAL = RFVAL.
  APPEND WA_BDCDATA TO GT_BDCDATA.

ENDFORM.                    " bdc_field
*----------------------------------------------------------------------*
*        Start new transaction according to parameters                 *
*----------------------------------------------------------------------*
FORM BDC_TRANSACTION USING TCODE.

  DATA: L_MSTRING(480).
  DATA: MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.
  DATA: L_SUBRC LIKE SY-SUBRC,
        CTUMODE LIKE CTU_PARAMS-DISMODE VALUE 'N',
        CUPDATE LIKE CTU_PARAMS-UPDMODE VALUE 'L'.

*  IF p1 = 'X'.
*    ctumode = 'A'.
*  ELSE.
  CTUMODE = 'N'.
*  ENDIF.

  REFRESH MESSTAB.
  CALL TRANSACTION TCODE USING GT_BDCDATA
                   MODE   CTUMODE
                   UPDATE CUPDATE
                   MESSAGES INTO MESSTAB.
  L_SUBRC = SY-SUBRC.
*    IF SMALLLOG <> 'X'.
  WRITE: / 'CALL_TRANSACTION', TCODE,
           'returncode:'(i05),
           L_SUBRC,  'RECORD:', SY-INDEX.
  LOOP AT MESSTAB.
    MESSAGE ID     MESSTAB-MSGID
            TYPE   MESSTAB-MSGTYP
            NUMBER MESSTAB-MSGNR
            INTO L_MSTRING
            WITH MESSTAB-MSGV1
                 MESSTAB-MSGV2
                 MESSTAB-MSGV3
                 MESSTAB-MSGV4.
    WRITE: / MESSTAB-MSGTYP, L_MSTRING(250).
  ENDLOOP.
  WRITE: / '!----------------*--------------->'.
  SKIP.
*    ENDIF.
  REFRESH GT_BDCDATA.
ENDFORM.
