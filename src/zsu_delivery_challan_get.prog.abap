*&---------------------------------------------------------------------*
*&  Include           ZSU_DELIVERY_CHALLAN_GET
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .


  SELECT * FROM MSEG
*     FIELDS MBLNR,
*             MATNR,
*             MJAHR,
*             BWART,
*             WERKS,
*             DMBTR,
*             BUDAT_MKPF,
*             SHKZG,
*             zeile,
*             ebeln,
*             ebelp
    WHERE MBLNR IN @S_MBLNR
    AND   BUDAT_MKPF IN @S_DATE
    AND   WERKS EQ 'SU01'
    AND   BWART EQ '541'
    AND   LIFNR IN @S_LIFNR
    AND   EBELN NE ' '
    AND   PARENT_ID NE ''
    INTO TABLE @DATA(GT_MSEG).


  SELECT EBELN,
     EBELP,
     TXZ01,
     MATNR,
     MENGE,
     MEINS,
     MWSKZ,
     WERKS,
     NETWR
FROM EKPO
FOR ALL ENTRIES IN @GT_MSEG
WHERE EBELN = @GT_MSEG-EBELN
AND   EBELP = @GT_MSEG-EBELP
INTO TABLE @DATA(IT_EKKO).

*  ENDIF.

  IF GT_MSEG IS NOT INITIAL.
    SELECT * FROM MSEG
         INTO TABLE IT_MSEG1
         FOR ALL ENTRIES IN GT_MSEG
         WHERE SMBLN = GT_MSEG-MBLNR
         AND   SMBLP = GT_MSEG-ZEILE
         AND   BWART = '542'.
  ENDIF.

  IT_MSEG = GT_MSEG.

  IF GT_MSEG IS NOT INITIAL.
    SELECT * FROM ZSU_CHALLANNO
             INTO TABLE IT_SU_CHALL
             FOR ALL ENTRIES IN GT_MSEG
             WHERE MATDOCNO = GT_MSEG-MBLNR.
  ENDIF.

  SELECT * FROM A994 INTO TABLE IT_A994
       FOR ALL ENTRIES IN IT_MSEG
       WHERE MATNR = IT_MSEG-MATNR AND WERKS = IT_MSEG-WERKS
       AND   KSCHL = 'ZSUB'
    and datbi = '99991231'
     AND KFRST = ' '
.

  SELECT KNUMH KOPOS
         KSCHL KBETR FROM KONP  INTO TABLE IT_CONDITION
         FOR ALL ENTRIES IN IT_A994
         WHERE KNUMH = IT_A994-KNUMH .

  SELECT * FROM LFA1 INTO TABLE IT_LFA1
    WHERE LIFNR IN S_LIFNR.



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
*  SORT IT_MSEG DESCENDING BY DATAB.

  LOOP AT IT_MSEG INTO WA_MSEG.
    WA_FINAL1-MBLNR = WA_MSEG-MBLNR.
    WA_FINAL1-BWART = WA_MSEG-BWART.
    WA_FINAL1-MENGE = WA_MSEG-MENGE.
    WA_FINAL1-BWART = WA_MSEG-BWART.
    WA_FINAL1-MEINS = WA_MSEG-MEINS.
    WA_FINAL1-WERKS = WA_MSEG-WERKS.
    WA_FINAL1-XAUTO = WA_MSEG-XAUTO.
    WA_FINAL1-LIFNR = WA_MSEG-LIFNR.
    WA_FINAL1-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
    WA_FINAL1-EBELN = WA_MSEG-EBELN.
    WA_FINAL1-EBELP = WA_MSEG-EBELP.
    WA_FINAL1-MATNR = WA_mseg-MATNR.

     sort IT_A994 DESCENDING by datab.
    READ TABLE IT_A994 INTO WA_A994 WITH KEY MATNR = WA_MSEG-MATNR WERKS = WA_MSEG-WERKS KSCHL = 'ZSUB'  KFRST = ' '.
    IF WA_A994-KFRST IS NOT INITIAL .
      WA_FINAL1-KNUMH = WA_A994-KNUMH.
      WA_FINAL1-KFRST = WA_A994-KFRST.
      WA_FINAL1-KSCHL = WA_A994-KSCHL.
*      WA_FINAL1-MATNR = WA_A994-MATNR.
    ENDIF.

    READ TABLE IT_CONDITION INTO WA_CONDITION WITH KEY KNUMH = WA_A994-KNUMH.
    IF SY-SUBRC = 0.
      WA_FINAL1-KBETR = WA_CONDITION-KBETR.
    ENDIF.

    READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_MSEG-LIFNR.
    WA_FINAL1-NAME1 = WA_LFA1-NAME1.

    READ TABLE IT_SU_CHALL INTO WA_SU_CHALL WITH KEY MATDOCNO = WA_MSEG-MBLNR.
    IF SY-SUBRC = 0.
      WA_FINAL1-CHALLANNO = WA_SU_CHALL-CHALLANNO.
    ENDIF.

    READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY SMBLN = WA_MSEG-MBLNR.

    IF WA_MSEG-MBLNR NE WA_MSEG1-SMBLN.

      APPEND WA_FINAL1 TO IT_FINAL1.

    ENDIF.
    CLEAR : WA_FINAL1,WA_MSEG,WA_MSEG1,WA_A994,WA_CONDITION.

  ENDLOOP.

*  DELETE ADJACENT DUPLICATES FROM IT_FINAL1 COMPARING MBLNR.

  SORT IT_FINAL1.

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
  LS_ALV_LAYOUT-BOX_TABNAME = 'IT_FINAL1'.
  LS_ALV_LAYOUT-BOX_FIELDNAME = 'SELECT'.


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

ENDFORM.

FORM PREPARE_DISPLAY  CHANGING CT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV .
  DATA:
    GV_POS      TYPE I,
    LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  REFRESH CT_FIELDCAT.
**
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SELCET'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Check Box.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  LS_FIELDCAT-CHECKBOX = 'X'.
  LS_FIELDCAT-INPUT = 'X'.
  LS_FIELDCAT-NO_OUT = 'X'.
  LS_FIELDCAT-EDIT = 'X'.
*  LS_FIELDCAT- = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MBLNR'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Doc.No.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MATNR'.              "changes 24.01.2024
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Material No.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BUDAT_MKPF'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_M = 'Posting.Date'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME    = 'LIFNR'.
  LS_FIELDCAT-TABNAME      = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_L    = 'Vendor'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME    = 'NAME1'.
  LS_FIELDCAT-TABNAME      = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_L    = 'Vendor Name'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME    = 'MENGE'.
  LS_FIELDCAT-TABNAME      = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_L    = 'Qty.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME    = 'MEINS'.
  LS_FIELDCAT-TABNAME      = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_L    = 'UOM'.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  LS_FIELDCAT-OFFSET       = 1.
*  LS_FIELDCAT-HOTSPOT      = 'X' .
  APPEND LS_FIELDCAT TO CT_FIELDCAT.


  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME    = 'BWART'.
  LS_FIELDCAT-TABNAME      = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_L    = 'Mvt.Type.'.
*  LS_FIELDCAT-OFFSET       = 1.
  LS_FIELDCAT-COL_POS   = GV_POS.
*  LS_FIELDCAT-HOTSPOT      = 'X' .
  APPEND LS_FIELDCAT TO CT_FIELDCAT.

  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME    = 'CHALLANNO'.
  LS_FIELDCAT-TABNAME      = 'IT_FINAL1'.
  LS_FIELDCAT-SELTEXT_L    = 'Challan No.'.
  LS_FIELDCAT-COL_POS   = GV_POS.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.

  CLEAR LS_FIELDCAT.

ENDFORM.

FORM SET_PF_STATUS USING RT_EXTAB   TYPE  SLIS_T_EXTAB.
  SET PF-STATUS 'STANDARD'.
ENDFORM.                    "set_pf_status
FORM USER_COMMAND  USING R_UCOMM LIKE SY-UCOMM
                         RS_SELFIELD TYPE SLIS_SELFIELD.

  CASE R_UCOMM.

    WHEN '&GST'.

*      REFRESH : g_t_msg.
*      clear : g_r_msg.

      READ TABLE IT_FINAL1 INTO WA_FINAL1 WITH  KEY SELECT = 'X' .

*      DELETE IT_MSEG WHERE MBLNR NE WA_FINAL1-MBLNR .

      IF SY-SUBRC = 0.
*************************************ADDED BY PRIMUS JYOTI ON 02.01.2024
        LOOP AT IT_MSEG INTO WA_MSEG WHERE MBLNR = WA_FINAL1-MBLNR ."AND matnr = WA_FINAL1-matnr.

*          SORT IT_A994 ASCENDING BY KNUMH.
          SORT IT_A994 DESCENDING BY datab knumh.
*          IF SY-SUBRC IS INITIAL.
   READ TABLE IT_A994 INTO WA_A994 WITH KEY MATNR = WA_MSEG-MATNR WERKS = WA_MSEG-WERKS KSCHL = 'ZSUB'  KFRST = ' '.
*            LOOP AT IT_A994 INTO WA_A994 WHERE MATNR = WA_MSEG-MATNR AND WERKS = WA_MSEG-WERKS
*                                         AND KSCHL = 'ZSUB' ."AND KFRST = ' '.
*            IF SY-SUBRC = 0.
*              IF WA_A994-KFRST EQ 'A'  and wa_a994-kbstat = '01'.
*              IF WA_A994-KFRST EQ  ' ' .
        if SY-SUBRC IS NOT INITIAL.
*                MESSAGE 'Please Maintain Price' TYPE 'E' DISPLAY LIKE 'E'.
           g_r_msg-type = 'E'.
           CONCATENATE 'Please Maintain Price for material'WA_MSEG-MATNR INTO g_r_msg-msg SEPARATED BY space.

               APPEND g_r_msg TO g_t_msg.
               CLEAR g_r_msg.
      .
*      WA_FINAL1-KNUMH = WA_A994-KNUMH.
*      WA_FINAL1-KFRST = WA_A994-KFRST.
*      WA_FINAL1-KSCHL = WA_A994-KSCHL.

            ELSE.
            SORT IT_CONDITION DESCENDING BY KNUMH.
            READ TABLE IT_CONDITION INTO WA_CONDITION WITH KEY KNUMH = WA_A994-KNUMH .
            IF SY-SUBRC = 0.
              WA_FINAL1-KBETR = WA_CONDITION-KBETR.
            ENDIF.

             IF WA_CONDITION-KBETR = '0.00'  OR  SY-SUBRC <> 0 .
*              MESSAGE 'Please Maintain Price' TYPE 'E' DISPLAY LIKE 'E'.
           g_r_msg-type = 'E'.
            CONCATENATE 'Please Maintain Price for material' WA_MSEG-MATNR INTO g_r_msg-msg SEPARATED BY space.

               APPEND g_r_msg TO g_t_msg.
               CLEAR g_r_msg.
            ENDIF  .

            ENDIF.



*      endloop.
*          ELSE.
*            MESSAGE 'Kindly maintain price for material' TYPE 'E' DISPLAY LIKE 'E'.
*          ENDIF.
*          ENDIF.
*        ENDLOOP.
        ENDLOOP.
        ENDIF.
         CLEAR:WA_CONDITION.
if WA_FINAL1-SELECT = 'X' .
if g_t_msg is NOT INITIAL.
  PERFORM display_log.

*      CALL FUNCTION 'COPO_POPUP_TO_DISPLAY_TEXTLIST'
*        EXPORTING
*         TASK             = 'DISPLAY'
*          TITEL            = 'Error Log'
*       IMPORTING
*         FUNCTION         = FUNCTION
*        TABLES
*          TEXT_TABLE       =  g_t_msg
          .
      else.
**************************************************************************
        DATA FORMNAME    TYPE TDSFNAME VALUE 'ZSD_DELIVERY_CHALLAN_NEW'.
        DATA FM_NAME     TYPE RS38L_FNAM.

*        DELETE IT_MSEG WHERE MBLNR NE WA_FINAL1-MBLNR .

        CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
          EXPORTING
            FORMNAME           = FORMNAME
            VARIANT            = ' '
            DIRECT_CALL        = ' '
          IMPORTING
            FM_NAME            = FM_NAME
          EXCEPTIONS
            NO_FORM            = 1
            NO_FUNCTION_MODULE = 2
            OTHERS             = 3.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.

        DATA CONTROL_PARAMETERS   TYPE SSFCTRLOP.
        DATA OUTPUT_OPTIONS       TYPE SSFCOMPOP.
        DATA JOB_OUTPUT_INFO      TYPE SSFCRESCL.

        DATA : LS_BIL_INVOICE TYPE LBBIL_INVOICE.

        CALL FUNCTION FM_NAME
          EXPORTING
            CONTROL_PARAMETERS = CONTROL_PARAMETERS
            OUTPUT_OPTIONS     = OUTPUT_OPTIONS
            USER_SETTINGS      = 'X'
            LS_BIL_INVOICE     = LS_BIL_INVOICE
          IMPORTING
            JOB_OUTPUT_INFO    = JOB_OUTPUT_INFO
*           P_mblnr            = wa_final1-mblnr
          TABLES
            GT_MSEG            = IT_MSEG                        "GT_MSEG
          EXCEPTIONS
            FORMATTING_ERROR   = 1
            INTERNAL_ERROR     = 2
            SEND_ERROR         = 3
            USER_CANCELED      = 4
            OTHERS             = 5.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
      ENDIF.
      ENDIF.

*DATA TASK       TYPE CLIKE.
*DATA TITEL      TYPE CLIKE.
*DATA FUNCTION   TYPE SY-UCOMM.
*DATA TEXT_TABLE TYPE STANDARD TABLE OF TLINE.

                .
*ENDIF.
  ENDCASE.


ENDFORM.
FORM display_log .

CONSTANTS: l_c_type(4) TYPE c VALUE 'TYPE',

l_c_msg(3) TYPE c VALUE 'MSG'.

DATA : l_t_fieldcat TYPE TABLE OF slis_fieldcat_alv,

l_r_fieldcat TYPE slis_fieldcat_alv.

DATA : l_f_line TYPE i.

CLEAR l_r_fieldcat.

l_f_line = l_f_line + 1.

l_r_fieldcat-col_pos = l_f_line.

l_r_fieldcat-fieldname = l_c_type.

l_r_fieldcat-seltext_m = 'Type'.

APPEND l_r_fieldcat TO l_t_fieldcat.

CLEAR l_r_fieldcat.

l_f_line = l_f_line + 1.

l_r_fieldcat-col_pos = l_f_line.

l_r_fieldcat-fieldname = l_c_msg.

l_r_fieldcat-seltext_m = 'Message'.

l_r_fieldcat-outputlen = 120.

APPEND l_r_fieldcat TO l_t_fieldcat.

*To display the message log as a Popup in the form of ALV List

CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'

EXPORTING

i_title = 'Message Log'

i_tabname = 'G_T_MSG'

it_fieldcat = l_t_fieldcat[]

TABLES

t_outtab = g_t_msg

EXCEPTIONS

program_error = 1

OTHERS = 2.

IF sy-subrc <> 0.

MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno

WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

ENDIF.

ENDFORM.
