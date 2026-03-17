*&---------------------------------------------------------------------*
*& Report ZSU_CHALLAN_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_CHALLAN_DISPLAY.

TYPE-POOLS:SLIS.
TABLES: ZSU_CHALLANNO.

TYPES : BEGIN OF TY_FINAL,
          PLANT        TYPE ZSU_CHALLANNO-PLANT,
          MATDOCNO     TYPE MKPF-MBLNR,
          CHALLANNO    TYPE ZSU_CHALLANNO-CHALLANNO,
          YEAR1        TYPE ZSU_CHALLANNO-YEAR1,
          CHALLAN_DATE TYPE ZSU_CHALLANNO-CHALLAN_DATE,

        END OF TY_FINAL.



DATA : IT_SU_CHALL TYPE TABLE OF ZSU_CHALLANNO,
       WA_SU_CHALL TYPE ZSU_CHALLANNO,

       IT_FINAL1   TYPE TABLE OF TY_FINAL,
       WA_FINAL1   TYPE TY_FINAL.

SELECTION-SCREEN BEGIN OF BLOCK ORG WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_WERKS FOR ZSU_CHALLANNO-PLANT OBLIGATORY DEFAULT 'SU01' MODIF ID BU,
                S_MBLNR FOR ZSU_CHALLANNO-MATDOCNO ,
                S_CHN FOR ZSU_CHALLANNO-CHALLANNO ,
                S_DATE FOR ZSU_CHALLANNO-CHALLAN_DATE .

SELECTION-SCREEN  END OF BLOCK ORG.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


START-OF-SELECTION.

PERFORM GET_DATA.
PERFORM PROCESS_DATA.
PERFORM DISPLAY_DATA.


*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT * FROM ZSU_CHALLANNO
           INTO TABLE IT_SU_CHALL
           WHERE MATDOCNO IN S_MBLNR
           AND PLANT IN S_WERKS
           AND CHALLANNO IN S_CHN
           AND CHALLAN_DATE IN S_DATE  .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PROCESS_DATA .
  LOOP AT IT_SU_CHALL INTO WA_SU_CHALL.
  WA_FINAL1-CHALLANNO = WA_SU_CHALL-CHALLANNO.
  WA_FINAL1-CHALLAN_DATE = WA_SU_CHALL-CHALLAN_DATE.
  WA_FINAL1-MATDOCNO = WA_SU_CHALL-MATDOCNO.
  WA_FINAL1-PLANT = WA_SU_CHALL-PLANT.
  WA_FINAL1-YEAR1 = WA_SU_CHALL-YEAR1.

    APPEND WA_FINAL1 TO IT_FINAL1.

  CLEAR : WA_FINAL1,WA_SU_CHALL.
ENDLOOP.
DELETE ADJACENT DUPLICATES FROM IT_FINAL1 COMPARING MATDOCNO .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_DATA .
  DATA:
    LT_FIELDCAT     TYPE SLIS_T_FIELDCAT_ALV,
    LS_ALV_LAYOUT   TYPE SLIS_LAYOUT_ALV,
    L_CALLBACK_PROG TYPE SY-REPID.

  L_CALLBACK_PROG = SY-REPID.

  PERFORM PREPARE_DISPLAY CHANGING LT_FIELDCAT.
  CLEAR LS_ALV_LAYOUT.
  LS_ALV_LAYOUT-ZEBRA = 'X'.
  LS_ALV_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.

*IF WA_FINAL1-CHALLANNO IS INITIAL.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM       = L_CALLBACK_PROG
      I_CALLBACK_PF_STATUS_SET = 'SET_PF_STATUS'
      I_CALLBACK_USER_COMMAND  = 'USER_COMMAND'
  "   I_CALLBACK_TOP_OF_PAGE   = 'TOP_OF_PAGE'
      IS_LAYOUT                = LS_ALV_LAYOUT
      IT_FIELDCAT              = LT_FIELDCAT
      I_SAVE                   = 'X'
    TABLES
      T_OUTTAB                 = IT_FINAL1
    EXCEPTIONS
      PROGRAM_ERROR            = 1
      OTHERS                   = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*ENDIF.

ENDFORM.

FORM PREPARE_DISPLAY  CHANGING CT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV .
  DATA:
    GV_POS      TYPE I,
    LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  REFRESH CT_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'PLANT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Plant'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

    GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'YEAR1'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Year'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MATDOCNO'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Doc.No.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  LS_FIELDCAT-HOTSPOT   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.
*IF  MOD_CRE = 'X'.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CHALLANNO'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Challan No.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.

    GV_POS = GV_POS + 1.
    LS_FIELDCAT-FIELDNAME = 'CHALLAN_DATE'.
    LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
    LS_FIELDCAT-SELTEXT_M = 'Challan Date'.
    LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
    APPEND LS_FIELDCAT TO CT_FIELDCAT.

*ENIF.
ENDFORM.

FORM SET_PF_STATUS USING RT_EXTAB   TYPE  SLIS_T_EXTAB.
  SET PF-STATUS 'STANDARD_FULLSCREEN'.
ENDFORM.                    "set_pf_status



FORM USER_COMMAND  USING R_UCOMM LIKE SY-UCOMM
                         RS_SELFIELD TYPE SLIS_SELFIELD.


  CASE R_UCOMM.
    WHEN '&F03'.
     LEAVE TO TRANSACTIOn 'ZSU_CHALLAN'.

ENDCASE.

ENDFORM.
