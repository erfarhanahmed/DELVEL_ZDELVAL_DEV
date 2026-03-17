*&---------------------------------------------------------------------*
*& Report ZBDC_WHT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVENDOR_MASTER_BDC
NO STANDARD PAGE HEADING LINE-SIZE 255.
*INCLUDE BDCRECX1.
TYPES : BEGIN OF TY_FINAL,

          LIFNR     TYPE LIFNR, " RF02K-LIFNR,
          BUKRS     TYPE BUKRS,       "RF02K-BUKRS,
*          d0610     TYPE char1,            "RF02K-D0610,
          QLAND     TYPE QLAND,       "RF02K-BUKRS,
          WITHT     TYPE STRING,
          WT_WITHCD TYPE STRING,
          LIABLE    TYPE CHAR1,
          QSREC     TYPE STRING,


        END OF TY_FINAL.

TYPES : BEGIN OF STR_LFBW,
          LIFNR TYPE LIFNR,
          WITHT TYPE LFBW-WITHT,
        END OF STR_LFBW.



DATA : IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,
       LV_COUNT TYPE N,
       LT_LFBW  TYPE STANDARD TABLE OF STR_LFBW,
       LT_LFBW1 TYPE STANDARD TABLE OF STR_LFBW,
       COUNT    TYPE N LENGTH 2,
       VALUE    TYPE CHAR20..





DATA : BDCMSGCOLL    TYPE STANDARD TABLE OF BDCMSGCOLL WITH HEADER LINE,
       WA_BDCMSGCOLL TYPE BDCMSGCOLL,
       BDCDATA       TYPE STANDARD TABLE OF BDCDATA WITH HEADER LINE.


TYPES: TRUX_T_TEXT_DATA(4096) TYPE C OCCURS 0.
DATA : IT_RAW TYPE TRUX_T_TEXT_DATA.
DATA : LS_VENDOR TYPE LFA1-LIFNR.
*-------------------------------------------------------------------------
**************************************************************************
*SELECTION SCREEN DECLARATION
**************************************************************************
SELECTION-SCREEN: BEGIN OF BLOCK B1.
PARAMETERS: BDC_FILE TYPE RLGRAP-FILENAME,
            LV_MODE  LIKE CTU_PARAMS-DISMODE DEFAULT 'A'.
SELECTION-SCREEN: END OF BLOCK B1.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR BDC_FILE.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = BDC_FILE.

*START-OF-SELECTION.



START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = IT_RAW
      I_FILENAME           = BDC_FILE
    TABLES
      I_TAB_CONVERTED_DATA = IT_FINAL[]
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.

    MESSAGE 'ERROR WHILE GENERATING FILE' TYPE 'E'.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*  ***************************************************

  IF SY-SUBRC IS INITIAL.
    SORT LT_LFBW BY LIFNR.
  ENDIF.

  LOOP AT IT_FINAL[] INTO WA_FINAL.
    REFRESH LT_LFBW[].

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = WA_FINAL-LIFNR
      IMPORTING
        OUTPUT = LS_VENDOR.




    SELECT LIFNR
           WITHT
      FROM LFBW
      INTO TABLE LT_LFBW
      WHERE LIFNR = LS_VENDOR
      AND BUKRS = WA_FINAL-BUKRS.

    REFRESH BDCDATA[].
    CLEAR : COUNT.

    DESCRIBE TABLE LT_LFBW LINES COUNT.

    COUNT = COUNT + 1.


    PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0106'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'RF02K-D0610'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM BDC_FIELD       USING 'RF02K-LIFNR'
                                   WA_FINAL-LIFNR.                        "               '100140'.
    PERFORM BDC_FIELD       USING 'RF02K-BUKRS'
                                   WA_FINAL-BUKRS.                                                  "'1000'.
    PERFORM BDC_FIELD       USING 'RF02K-D0610'
                                  'X'.

    " added by s.
    PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0610'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=UPDA'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'LFBW-WT_EXDF(01)'.
    PERFORM BDC_FIELD       USING 'LFB1-QLAND'
                                  WA_FINAL-QLAND.

    IF COUNT GT 6.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0610'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                  '=ENTR'.
                                    '=P+'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFBW-QSREC(01)'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0610'.
      IF  COUNT = 6.
        COUNT = 1.
      ELSE.
        COUNT = COUNT MOD 6.
        COUNT = COUNT + 1.
      ENDIF.

*    ELSE.
*      PERFORM bdc_dynpro      USING 'SAPMF02K' '0610'.
*      PERFORM bdc_field       USING 'BDC_OKCODE'
*                                    '=ENTR'.
*      PERFORM bdc_field       USING 'BDC_CURSOR'
*                                    'LFBW-QSREC(01)'.
*          PERFORM bdc_field       USING 'LFB1-QLAND'
*                                  wa_final-qland.
    ENDIF.

    CLEAR VALUE.
    CONCATENATE 'LFBW-WITHT(' COUNT ')' INTO VALUE.

    PERFORM BDC_FIELD       USING   VALUE
                                   WA_FINAL-WITHT.

    CLEAR VALUE.
    CONCATENATE 'LFBW-WT_WITHCD(' COUNT ')' INTO VALUE.
    "'VA'.
    PERFORM BDC_FIELD       USING VALUE
                                   WA_FINAL-WT_WITHCD." 'VA'.

    CLEAR VALUE.
    CONCATENATE 'LFBW-WT_SUBJCT(' COUNT ')' INTO VALUE.

    PERFORM BDC_FIELD       USING VALUE
                                    WA_FINAL-LIABLE  .                   "   'X'.

    CLEAR VALUE.
    CONCATENATE 'LFBW-QSREC(' COUNT ')' INTO VALUE.

    PERFORM BDC_FIELD       USING   VALUE
                                   WA_FINAL-QSREC    .         "'VT'.

    PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0610'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=UPDA'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'LFBW-WT_SUBJCT(06)'.
    CALL TRANSACTION 'FK02'
    USING BDCDATA[]
    MODE LV_MODE
    UPDATE 'S'
    MESSAGES INTO BDCMSGCOLL[].
*PERFORM BDC_TRANSACTION USING 'FK02'.
    CLEAR : LS_VENDOR.
  ENDLOOP.

  LOOP AT  BDCMSGCOLL[] INTO WA_BDCMSGCOLL.

    WRITE : WA_BDCMSGCOLL-MSGV1.
  ENDLOOP.
*PERFORM BDC_TRANSACTION USING
*----------------------------------------------------------------------*
*        START NEW SCREEN                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        INSERT FIELD                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
  CLEAR BDCDATA.
  BDCDATA-FNAM = FNAM.
  BDCDATA-FVAL = FVAL.
  APPEND BDCDATA.
*  ENDIF.
ENDFORM.                    "BDC_FIELD
