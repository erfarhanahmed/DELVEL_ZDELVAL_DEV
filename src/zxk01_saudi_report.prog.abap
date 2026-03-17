REPORT ZXK01_SAUDI_REPORT
       NO STANDARD PAGE HEADING LINE-SIZE 255.
*&---------------------------------------------------------------------*
*& Report  ZVENDOR_MASTER_BDC
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*


TABLES :SSCRFIELDS.

TYPE-POOLS: TRUXS.
TYPES: BEGIN OF TY_DATA,
         BUKRS(004),
         EKORG(004),
         KTOKK(004),
         ANRED(040),
         NAME1(040),
         SORTL(020),
         STRAS(040),
         PFACH(030),
         PSTLZ(030),
         LAND1(040),
         TELF1(020),
         KUNNR(010),
         STCD3(020),
         AKONT(010),
         ZTERM      TYPE LFB1-ZTERM,
         WAERS(005),
         ZTERM1(20),
         INCO1(003),
         INCO2(028),
         KALSK(010),
       END OF TY_DATA.



DATA : GT_FINAL TYPE STANDARD TABLE OF TY_DATA.


DATA : RAW_TABLE TYPE TRUXS_T_TEXT_DATA.


DATA  : BDCDATA         LIKE BDCDATA OCCURS 0 WITH HEADER LINE,
        LV_BUFFER(4096) TYPE C OCCURS 0,

        TT_BDCMSGCOLL   TYPE STANDARD TABLE OF BDCMSGCOLL,
        WA_BDCMSGCOLL   TYPE BDCMSGCOLL.
DATA : IT_BDCDATA TYPE STANDARD TABLE OF BDCDATA,
       WA_BDCDATA TYPE BDCDATA.

DATA : CNT(3)        TYPE N,
       V_MESSAGE(50).

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN SKIP.
PARAMETERS :  F_NAME TYPE RLGRAP-FILENAME. " OBLIGATORY.
PARAMETERS :  MODE TYPE CTU_PARAMS-DISMODE DEFAULT 'E'.
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE."

INITIALIZATION.
  W_BUTTON = TEXT-003.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR F_NAME.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = F_NAME.

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1'.

    SUBMIT ZSU_VENDOR_EXCEL AND RETURN.
  ENDIF.


START-OF-SELECTION.

  DATA LT_EXCEL LIKE ALSMEX_TABLINE OCCURS 0 WITH HEADER LINE.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = LV_BUFFER
      I_FILENAME           = F_NAME
    TABLES
      I_TAB_CONVERTED_DATA = GT_FINAL
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.



  LOOP AT GT_FINAL INTO DATA(GS_FINAL).
    "REAK-POINT.
    IF GS_FINAL-BUKRS NE 'SU00'.
      MESSAGE 'Vendor cannot be created for company code' TYPE 'E'.
    ELSE.
      REFRESH IT_BDCDATA.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0100'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'RF02K-KTOKK'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM BDC_FIELD       USING 'RF02K-BUKRS'
                                    GS_FINAL-BUKRS. "'SU00'.
      PERFORM BDC_FIELD       USING 'RF02K-EKORG'
                                     GS_FINAL-EKORG. "'SUDM'.
      PERFORM BDC_FIELD       USING 'RF02K-KTOKK'
                                     GS_FINAL-KTOKK. "'SV01'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0110'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=VW'.
      PERFORM BDC_FIELD       USING 'LFA1-ANRED'
                                     GS_FINAL-ANRED. "'COMPANY'.
      PERFORM BDC_FIELD       USING 'LFA1-NAME1'
                                     GS_FINAL-NAME1. "'SAUSDI MIDDLE EAST LTD'.
      PERFORM BDC_FIELD       USING 'LFA1-SORTL'
                                     GS_FINAL-SORTL. "'DELVAL'.
      PERFORM BDC_FIELD       USING 'LFA1-STRAS'
                                     GS_FINAL-STRAS. "'CUSTODIAN HOLY STREET'.
      PERFORM BDC_FIELD       USING 'LFA1-PFACH'
                                     GS_FINAL-PFACH.        "'34623'.
      PERFORM BDC_FIELD       USING 'LFA1-PSTLZ'
                                     GS_FINAL-PSTLZ.        "'34623'.
      PERFORM BDC_FIELD       USING 'LFA1-LAND1'
                                     GS_FINAL-LAND1. "'SA'.
      PERFORM BDC_FIELD       USING 'LFA1-TELF1'
                                     GS_FINAL-TELF1. "'9072293895'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0120'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFA1-STCD3'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=VW'.
      PERFORM BDC_FIELD       USING 'LFA1-KUNNR'
                                     GS_FINAL-KUNNR.        "'600001'.
      PERFORM BDC_FIELD       USING 'LFA1-STCD3'
                                     GS_FINAL-STCD3. "'311562365300003'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0130'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFBK-BANKS(01)'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=ENTR'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0380'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'KNVK-NAMEV(01)'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '=ENTR'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0210'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFB1-AKONT'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM BDC_FIELD       USING 'LFB1-AKONT'
                                     GS_FINAL-AKONT.        "'250011'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0215'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFB1-ZTERM'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM BDC_FIELD       USING 'LFB1-ZTERM'
                                    GS_FINAL-ZTERM. "'SU11'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0220'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFB5-MAHNA'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0310'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'LFM1-KALSK'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM BDC_FIELD       USING 'LFM1-WAERS'
                                    GS_FINAL-WAERS. "'SAR'.
      PERFORM BDC_FIELD       USING 'LFM1-ZTERM'
                                    GS_FINAL-ZTERM1."SU11'.
      PERFORM BDC_FIELD       USING 'LFM1-INCO1'
                                    GS_FINAL-INCO1. "'FOB'.
      PERFORM BDC_FIELD       USING 'LFM1-INCO2'
                                    GS_FINAL-INCO2. "'MUMBAI'.
      PERFORM BDC_FIELD       USING 'LFM1-KALSK'
                                    GS_FINAL-KALSK. "'S1'.
      PERFORM BDC_DYNPRO      USING 'SAPMF02K' '0320'.
      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                    'WYT3-PARVW(01)'.
      PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                    'UPDA'.


      CALL TRANSACTION 'XK01' USING IT_BDCDATA
                               MODE MODE
                                UPDATE 'S'
                                MESSAGES INTO TT_BDCMSGCOLL.

    ENDIF.



    LOOP AT TT_BDCMSGCOLL INTO WA_BDCMSGCOLL.

      CALL FUNCTION 'FORMAT_MESSAGE'                  "Formatting a T100 message
        EXPORTING
          ID        = WA_BDCMSGCOLL-MSGID
          LANG      = SY-LANGU
          NO        = WA_BDCMSGCOLL-MSGNR
          V1        = WA_BDCMSGCOLL-MSGV1
          V2        = WA_BDCMSGCOLL-MSGV2
          V3        = WA_BDCMSGCOLL-MSGV3
          V4        = WA_BDCMSGCOLL-MSGV4
        IMPORTING
          MSG       = V_MESSAGE
        EXCEPTIONS
          NOT_FOUND = 1
          OTHERS    = 2.

      IF WA_BDCMSGCOLL-MSGV1 IS NOT INITIAL AND WA_BDCMSGCOLL-MSGTYP = 'S'.
        WRITE:/ V_MESSAGE.
      ENDIF.

      IF  WA_BDCMSGCOLL-MSGTYP = 'E'.
        "WRITE:/ v_message ,' Error in Count',ls_final-count.
      ENDIF.

    ENDLOOP.
    CLEAR : GS_FINAL.
  ENDLOOP.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR WA_BDCDATA.
  WA_BDCDATA-PROGRAM  = PROGRAM.
  WA_BDCDATA-DYNPRO   = DYNPRO.
  WA_BDCDATA-DYNBEGIN = 'X'.
  APPEND WA_BDCDATA TO IT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> SPACE. "NODATA.
    CLEAR WA_BDCDATA.
    WA_BDCDATA-FNAM = FNAM.
    WA_BDCDATA-FVAL = FVAL.
    SHIFT WA_BDCDATA-FVAL LEFT DELETING LEADING SPACE.
    APPEND WA_BDCDATA TO IT_BDCDATA.
  ENDIF.
ENDFORM.
