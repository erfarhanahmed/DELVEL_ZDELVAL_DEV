REPORT ZSU_BDC_INFO_RECORD
       NO STANDARD PAGE HEADING LINE-SIZE 255.


*include bdcrecx1.

TABLES: SSCRFIELDS.
TYPES:BEGIN OF TY_STR,
        LIFNR(10),
        MATNR(18),
        EKORG(04),
        WERKS(04),
        NORBM(13),
        MWSKZ(02),
        NETPR(11),
        GKWRT(11),
        DATBI(10),
        IDNLF(35),
        URZZT(16),           "Number or Casting weight       "added by pankaj 27.10.2021
      END OF TY_STR.

TYPES: TRUX_T_TEXT_DATA(4096) TYPE C OCCURS 0.
DATA : TEXT TYPE STRING .
DATA:IT_ITAB    TYPE TABLE OF TY_STR,
     WA_ITAB    TYPE          TY_STR,
     IT_MSG     LIKE TABLE OF BDCMSGCOLL,
     WA         TYPE  BDCMSGCOLL , "WITH HEADER LINE,
     IT_BDCDATA TYPE TABLE OF BDCDATA,
     WA_BDCDATA TYPE BDCDATA.
DATA : RAWDATA(4096) TYPE C OCCURS 0.
SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS : P_FILE TYPE RLGRAP-FILENAME.
PARAMETERS : CTU_MODE  LIKE CTU_PARAMS-DISMODE DEFAULT 'N'.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
*PARAMETERS : R1 RADIOBUTTON GROUP R,  " Standard
*             R2 RADIOBUTTON GROUP R.  " Subcontracting
*SELECTION-SCREEN END OF BLOCK B2.

INITIALIZATION.
*Assign Text string To Button
  W_BUTTON = 'Download Excel Template'.

AT SELECTION-SCREEN.

  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    SUBMIT  ZSU_INFO_RECORD_EXCEL VIA SELECTION-SCREEN .
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME = SYST-CPROG
*     DYNPRO_NUMBER       = SYST-DYNNR
*     FIELD_NAME   = ' '
    IMPORTING
      FILE_NAME    = P_FILE.
  .

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      I_LINE_HEADER        = 'x'
      I_TAB_RAW_DATA       = RAWDATA
      I_FILENAME           = P_FILE
    TABLES
      I_TAB_CONVERTED_DATA = IT_ITAB
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*include bdcrecx1.
START-OF-SELECTION.

*perform open_group.
  LOOP AT  IT_ITAB INTO WA_ITAB.

    PERFORM BDC_DYNPRO      USING 'SAPMM06I' '0100'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  '*LFA1-NAME1'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM BDC_FIELD       USING 'EINA-LIFNR'
                                   WA_ITAB-LIFNR .          "'500002'.
    PERFORM BDC_FIELD       USING 'EINA-MATNR'
                                  WA_ITAB-MATNR  .                                             "'7E02BK0066000008'.
    PERFORM BDC_FIELD       USING 'EINE-EKORG'
                                  WA_ITAB-EKORG   .                                                    "'SUDM'.
    PERFORM BDC_FIELD       USING 'EINE-WERKS'
                                  WA_ITAB-WERKS    .                                         "'SU01'.
    PERFORM BDC_FIELD       USING 'RM06I-NORMB'
                                  'X'.
    PERFORM BDC_DYNPRO      USING 'SAPMM06I' '0101'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'EINA-URZZT'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM BDC_FIELD       USING 'EINA-IDNLF'
                                  WA_ITAB-IDNLF.                                       "'7E02BK0066000008'.
    PERFORM BDC_FIELD       USING 'EINA-URZLA'
                                  'SA'.
    PERFORM BDC_FIELD       USING 'EINA-URZZT'
                                  WA_ITAB-URZZT.                                    "'55555555'.
*perform bdc_field       using 'EINA-MEINS'
*                              'NOS'.
*perform bdc_field       using 'EINA-UMREZ'
*                              '1'.
*perform bdc_field       using 'EINA-UMREN'
*                              '1'.
    PERFORM BDC_DYNPRO      USING 'SAPMM06I' '0102'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'EINE-WAERS'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=KO'.
    PERFORM BDC_FIELD       USING 'EINE-EKGRP'
                                  'S02'.
    PERFORM BDC_FIELD       USING 'EINE-NORBM'
                                  WA_ITAB-NORBM.               "                '50'.
    PERFORM BDC_FIELD       USING 'EINE-MWSKZ'
                                  WA_ITAB-MWSKZ.                                  "'I1'.
    PERFORM BDC_FIELD       USING 'EINE-IPRKZ'
                                  'D'.
    PERFORM BDC_FIELD       USING 'EINE-NETPR'
                                  WA_ITAB-NETPR.                          "'            50'.
*perform bdc_field       using 'EINE-WAERS'
*                              'SAR'.
*perform bdc_field       using 'EINE-PEINH'
*                              '1'.
*perform bdc_field       using 'EINE-BPRME'
*                              'NOS'.
*perform bdc_field       using 'EINE-BPUMZ'
*                              '1'.
*perform bdc_field       using 'EINE-BPUMN'
*                              '1'.
    PERFORM BDC_DYNPRO      USING 'SAPMV13A' '0201'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'RV13A-DATBI'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=KDAT'.
*perform bdc_field       using 'RV13A-DATAB'
*                              '25.11.2023'.
    PERFORM BDC_FIELD       USING 'RV13A-DATBI'
                                  WA_ITAB-DATBI.                           "'25.11.2027'.
    PERFORM BDC_DYNPRO      USING 'SAPMV13A' '0200'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'RV13A-DATAB'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=PDAT'.
*    PERFORM BDC_FIELD       USING 'RV13A-DATAB'
*                                  '25.11.2023'.
    PERFORM BDC_FIELD       USING 'RV13A-DATBI'
                                  WA_ITAB-DATBI.                             "'25.11.2027'.
    PERFORM BDC_DYNPRO      USING 'SAPMV13A' '0300'.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'KONP-GKWRT'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=SICH'.
*perform bdc_field       using 'RV13A-DATAB'
*                              '25.11.2023'.
perform bdc_field       using 'RV13A-DATBI'
                               WA_ITAB-DATBI.            " '25.11.2027'.
*perform bdc_field       using 'KONP-KBETR'
*                              '          50.00'.
*perform bdc_field       using 'KONP-KONWA'
*                              'SAR'.
*perform bdc_field       using 'KONP-KPEIN'
*                              '    1'.
*perform bdc_field       using 'KONP-KMEIN'
*                              'NOS'.
    PERFORM BDC_FIELD       USING 'KONP-GKWRT'
                                  WA_ITAB-GKWRT.                "'              60'.
*perform bdc_field       using 'KONP-STFKZ'
*                              'A'.
*perform bdc_field       using 'KONP-KZNEP'
*                              'X'.
*perform bdc_transaction using 'ME11'.

*perform close_group.

    CALL TRANSACTION 'ME11' USING IT_BDCDATA
                                    MODE CTU_MODE UPDATE 'S' MESSAGES INTO IT_MSG.


    CLEAR  IT_BDCDATA.

  ENDLOOP.

  """"""""""""""""""""""""ADDED BY SARIKA TALEKAR """""""""""""""""""""""""""""""'''''''''''
  DATA : INFNR TYPE EINA-INFNR .
  DATA : IT_MSG1 TYPE CHAR100.
*    SELECT SINGLE infnr FROM eina INTO infnr WHERE matnr = wa_itab-matnr AND lifnr =  wa_itab-lifnr .
  LOOP AT IT_MSG INTO WA.


    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        ID        = WA-MSGID
        LANG      = SY-LANGU
        NO        = WA-MSGNR
        V1        = WA-MSGV1
        V2        = WA-MSGV2
        V3        = WA-MSGV3
        V4        = WA-MSGV4
      IMPORTING
        MSG       = IT_MSG1
      EXCEPTIONS
        NOT_FOUND = 1
        OTHERS    = 2.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.
    IF  WA-MSGTYP = 'S' .
      INFNR =  WA-MSGV1 .

      READ TABLE IT_MSG INTO WA WITH KEY MSGTYP = 'W' .
      IF SY-SUBRC = '0'.
        CONCATENATE 'Info record ' INFNR 'generate with warning.' INTO TEXT SEPARATED BY SPACE.
*          MESSAGE text TYPE 'I' DISPLAY LIKE 'E'.
        WRITE : / TEXT .
      ENDIF.
    ENDIF .
    IF  WA-MSGTYP = 'E' .
      WRITE : / IT_MSG1 .
    ENDIF.
  ENDLOOP .

  """"""""""""""""""""""""END  BY SARIKA TALEKAR """""""""""""""""""""""""""""""'''''''''''

*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR WA_BDCDATA.
  WA_BDCDATA-PROGRAM  = PROGRAM.
  WA_BDCDATA-DYNPRO   = DYNPRO.
  WA_BDCDATA-DYNBEGIN = 'X'.
  APPEND WA_BDCDATA TO IT_BDCDATA.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> SPACE.
    CLEAR WA_BDCDATA.
    WA_BDCDATA-FNAM = FNAM.
    WA_BDCDATA-FVAL = FVAL.
    APPEND WA_BDCDATA TO IT_BDCDATA.
  ENDIF.
ENDFORM.                    "bdc_field
