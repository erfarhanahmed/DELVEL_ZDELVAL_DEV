class ZCL_IM_BOM_UPDATE definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BOM_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BOM_UPDATE IMPLEMENTATION.


  METHOD IF_EX_BOM_UPDATE~CHANGE_AT_SAVE.

** code added by shreya 08-08-23 ***
    DATA : WA_STKOB     TYPE CS01_STKOB,
           WA_STKOB_NEW TYPE CS01_STKOB,
           WA_MASTB     TYPE CS01_MASTB.


    DATA : WA_STPOB TYPE CS01_STPOB,
           WA_STPO  TYPE STPO,
           IT_STPO  TYPE TABLE OF CS01_STPOB," STPO,
           IT_STPO1  TYPE TABLE OF STPO,
           IT_STPO2  TYPE TABLE OF CS01_STPOB,
            WA_STPO1  TYPE STPO,
            WA_STPO2  TYPE CS01_STPOB.
   data :    IT_STPO_rep TYPE TABLE OF STPO,
            WA_STPO_rep  TYPE STPO.

**********************added by primus jyoti on 23.01.2024
TYPES : BEGIN OF g_ty_msg,

type LIKE sy-msgty,

msg(120),

END OF g_ty_msg.

DATA: g_t_msg TYPE TABLE OF g_ty_msg,

g_r_msg TYPE g_ty_msg.

   DATA :gv_msg type string.

   CONSTANTS: l_c_type(4) TYPE c VALUE 'TYPE',

l_c_msg(3) TYPE c VALUE 'MSG'.

DATA : l_t_fieldcat TYPE TABLE OF slis_fieldcat_alv,

l_r_fieldcat TYPE slis_fieldcat_alv.

DATA : l_f_line TYPE i.

DATA: SELEC   TYPE SLIS_SELFIELD,
      L_EXIT  TYPE C.
******************************************************************
    IF SY-TCODE = 'CS01'.
*      BREAK-POINT.

      LOOP AT DELTA_MASTB INTO WA_MASTB.

        READ TABLE DELTA_STPOB INTO WA_STPOB WITH KEY STLNR = WA_MASTB-STLNR.
        IF WA_STPOB-IDNRK IS INITIAL.
          MESSAGE E099(29).
        ENDIF.


        READ TABLE DELTA_STKOB INTO WA_STKOB WITH KEY STLST = '2'.
        IF WA_STKOB-STLST = '2'.
          MESSAGE E517(29).
        ENDIF.


        READ TABLE DELTA_STKOB INTO WA_STKOB_NEW WITH KEY STLST = '3'.
        IF WA_STKOB_NEW-STLST = '3'.
          MESSAGE E517(29).
        ENDIF.

      ENDLOOP.
      IF DELTA_STPOB  IS INITIAL.
        MESSAGE E099(29).
      ENDIF.

****************************added by primus jyoti on 05.02.2024
**************logic for quantity  is greater than 1 then display warning message

       loop at DELTA_STPOB INTO WA_STPOB.

          IF WA_STPOb-MENGE > 1 . ">= 0.
              g_r_msg-type = 'W'.
           CONCATENATE 'Quantity is greater than 1 for' WA_STPOB-IDNRK wa_stpoB-posnr
           into g_r_msg-msg SEPARATED BY space.
            APPEND g_r_msg TO g_t_msg.
               CLEAR g_r_msg.
         ENDIF.

       ENDLOOP.
*       BREAK-POINT.
*****logic for material code is already exit then display wrning message
     LOOP AT DELTA_STPOB INTO WA_STPOB ."WHERE VBKZ in ( 'I' ,' ' ).
      if WA_STPOB-vbkz = 'I' or WA_STPOB-vbkz = ''.
*        if wa_stpob-aenkz = 'X'.
      WA_STPO = WA_STPOB.
      APPEND WA_STPO TO IT_STPO.

      CLEAR : WA_STPO, WA_STPOB.
      endif.
    ENDLOOP.

   SORT IT_STPO BY IDNRK.
       IT_STPO2 = IT_STPO.
       DELETE ADJACENT DUPLICATES FROM it_stpo COMPARING idnrk.

       LOOP AT IT_STPO2 INTO WA_STPO2.
    READ TABLE  IT_STPO INTO WA_STPO WITH KEY IDNRK = WA_STPO2-IDNRK
                                                  STLKN = WA_sTPO2-STLKN.
    IF SY-SUBRC IS INITIAL.
      DELETE IT_STPO2.
    ENDIF.
   ENDLOOP.

         clear : WA_STPOB, wa_stpo2.
        loop at DELTA_STPOB INTO WA_STPOB.
          READ TABLE IT_STPO2 into wa_stpo2 with key idnrk = WA_STPOb-IDNRK.
          if WA_STPOB-IDNRK = wa_stpo2-IDNRK.
            g_r_msg-type = 'W'.
*            data : gv_msg type string.
             CONCATENATE 'Item already exist for material' WA_STPOb-IDNRK WA_STPOb-posnr into g_r_msg-msg SEPARATED BY space.
             APPEND g_r_msg TO g_t_msg.
               CLEAR g_r_msg.
          ENDIF.
        ENDLOOP.
*        endif.
IF  g_t_msg IS NOT INITIAL.
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
sort G_T_MSG.

delete ADJACENT DUPLICATES FROM G_T_MSG COMPARING ALL FIELDS.


CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'

EXPORTING

i_title = 'Message Log'

i_tabname = 'G_T_MSG'

it_fieldcat = l_t_fieldcat[]

 IMPORTING
    ES_SELFIELD      = SELEC
    E_EXIT           = L_EXIT

TABLES

t_outtab = g_t_msg

EXCEPTIONS

program_error = 1

OTHERS = 2.

IF L_EXIT IS NOT INITIAL.
    LEAVE TO SCREEN SY-DYNNR.
ENDIF.



IF sy-subrc <> 0.

MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno

WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

ENDIF.


ENDIF.
    ENDIF.


    IF SY-TCODE = 'CS02'.
***    break-point.
***********************added by jyoti on 05.04.2024***********************************
********************COMPONANT  is blank then display error msg***************************
**
    IF DELTA_STPOB  IS INITIAL.
        MESSAGE E099(29).
    ENDIF.
      data(DELTA_STPOB_new) = DELTA_STPOB.
    DELETE DELTA_STPOB_new WHERE vbkz = 'D' .
    if DELTA_STPOB_new is INITIAL.
      MESSAGE E099(29).
     ENDIF.
**
**
**
*******************************************************************************************8
***************logic for material allready exist for bom change
*CLEAR : WA_STPOB.
*    LOOP AT DELTA_STPOB INTO WA_STPOB ."WHERE VBKZ in ( 'I' ,' ' ).
*      if WA_STPOB-vbkz = 'I' or WA_STPOB-vbkz = ''.
*      WA_STPO = WA_STPOB.
*      APPEND WA_STPO TO IT_STPO.
*
*      CLEAR : WA_STPO, WA_STPOB.
**B.
*      endif.
*    ENDLOOP.
*   SORT IT_STPO BY IDNRK.
*   IT_STPO2 = IT_STPO.
*   DELETE ADJACENT DUPLICATES FROM it_stpo COMPARING idnrk.
*     clear : WA_STPO, wa_stpo2.
*   LOOP AT IT_STPO2 INTO WA_STPO2.
*    READ TABLE  IT_STPO INTO WA_STPO WITH KEY IDNRK = WA_STPO2-IDNRK
*                                                  STLKN = WA_sTPO2-STLKN.
*    IF SY-SUBRC IS INITIAL.
*      DELETE IT_STPO2.
*    ENDIF.
*   ENDLOOP.
*     clear : WA_STPOB, wa_stpo2.
*      LOOP AT DELTA_STPOB INTO WA_STPOB WHERE vbkz eq ' '.
*        READ TABLE IT_STPO2 INTO WA_STPO2 WITH KEY stlnr = WA_STPOb-stlnr.
*
*         IF WA_STPOb-IDNRK = WA_STPO2-IDNRK .
*           data : gv_msg1 TYPE string.
**           MESSAGE W279(29).
*           g_r_msg-type = 'E'.
*           CONCATENATE 'Item already exist for material' WA_STPOb-IDNRK WA_STPOb-posnr into g_r_msg-msg SEPARATED BY space.
*            APPEND g_r_msg TO g_t_msg.
*               CLEAR g_r_msg.
*         ENDIF.
**         ENDIF.
*         ENDLOOP.


***********************************************************************************
*****logic for quantity is greater than 1 display warning message
    LOOP AT DELTA_STPOB INTO WA_STPOB." WHERE VBKZ = 'U' .
       if WA_STPOB-vbkz = 'I' or WA_STPOB-vbkz = ''.
      WA_STPO1 = WA_STPOB.
      APPEND WA_STPO1 TO IT_STPO1.

      CLEAR : WA_STPO1, WA_STPOB.
      endif.
    ENDLOOP.

          LOOP AT DELTA_STPOB INTO WA_STPOB WHERE vbkz eq ' '.
          READ TABLE IT_STPO1 INTO WA_STPO1 WITH KEY stlnr = WA_STPOb-stlnr
                                                 posnr = WA_STPOb-posnr.
*
      ENDLOOP.
************added logic for replac the value from anywhere
*      BREAK primus.
*      LOOP AT DELTA_STPOB INTO WA_STPOB." WHERE VBKZ = 'U' .
*       if WA_STPOB-vbkz = 'U' .
*      WA_STPO_rep = WA_STPOB.
*      APPEND WA_STPO_rep TO IT_STPO_rep.
*      CLEAR : WA_STPO_rep, WA_STPOB.
*      endif.
*    ENDLOOP.
**
*    LOOP AT IT_STPO_rep INTO wa_STPO_rep ."WHERE vbkz eq ''.
**
*           g_r_msg-type = 'W'.
**             g_r_msg-msg = 'Item is replace with material'.
*           CONCATENATE 'Item is replace with line item' wa_STPO_rep-posnr
*                                                      into g_r_msg-msg SEPARATED BY space.
*            APPEND g_r_msg TO g_t_msg.
*               CLEAR g_r_msg.
*
**         ENDIF.
*    ENDLOOP.
IF g_t_msg IS NOT INITIAL.
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
sort G_T_MSG.
delete ADJACENT DUPLICATES FROM G_T_MSG COMPARING ALL FIELDS.
*DATA ES_SELFIELD TYPE SLIS_SELFIELD.

CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
  EXPORTING
   I_TITLE                       = 'Message Log'
*   I_SELECTION                   = 'X'
*   I_ALLOW_NO_SELECTION          = 'X' "I_ALLOW_NO_SELECTION
*   I_ZEBRA                       = ' '
*   I_SCREEN_START_COLUMN         = 0
*   I_SCREEN_START_LINE           = 0
*   I_SCREEN_END_COLUMN           = 0
*   I_SCREEN_END_LINE             = 0
*   I_CHECKBOX_FIELDNAME          = I_CHECKBOX_FIELDNAME
*   I_LINEMARK_FIELDNAME          = I_LINEMARK_FIELDNAME
*   I_SCROLL_TO_SEL_LINE          = 'X'
    i_tabname                     = 'G_T_MSG'
*   I_STRUCTURE_NAME              = I_STRUCTURE_NAME
   IT_FIELDCAT                   = l_t_fieldcat[]
*   IT_EXCLUDING                  = IT_EXCLUDING
*   I_CALLBACK_PROGRAM            = I_CALLBACK_PROGRAM
*   I_CALLBACK_USER_COMMAND       = I_CALLBACK_USER_COMMAND
*   IS_PRIVATE                    = IS_PRIVATE
 IMPORTING
   ES_SELFIELD                   = SELEC
   E_EXIT                        = L_EXIT
  TABLES
    t_outtab                      = g_t_msg
 EXCEPTIONS
   PROGRAM_ERROR                 = 1
   OTHERS                        = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*
IF L_EXIT IS NOT INITIAL.
    LEAVE TO SCREEN SY-DYNNR.
ENDIF.

IF sy-subrc <> 0.

MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno

WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

ENDIF.

    ENDIF.
    ENDIF.



  ENDMETHOD.


  method IF_EX_BOM_UPDATE~CHANGE_BEFORE_UPDATE.



 DATA :    T_STPO TYPE TABLE OF ZSTPO,
           W_STPO TYPE ZSTPO,
           T_STKO TYPE TABLE OF ZSTKO,
           W_STKO TYPE ZSTKO,
           T_MAST TYPE TABLE OF ZMAST,
           W_MAST TYPE ZMAST,

           T_MASTB TYPE TABLE OF MASTB,
           W_MASTB TYPE MASTB,
           T_STPOB TYPE STANDARD TABLE OF STPOB,
           W_STPOB TYPE STPOB,
           T_STKOB TYPE STANDARD TABLE OF STKOB,
           W_STKOB TYPE STKOB,
           W_DELTA_MASTB TYPE MASTB,
           W_DELTA_STKOB TYPE STKOB,
           W_DELTA_STPOB TYPE STPOB.

   DATA : CNT TYPE I,
         STLNR TYPE MAST-STLNR.
*   BREAK-POINT.
*......................................................................................................
   IF SY-TCODE = 'CS01'.
*     INSERT INTO TABLE MAST
      LOOP AT DELTA_MASTB INTO W_DELTA_MASTB WHERE VBKZ = 'I'.
          W_MAST-MATNR   =  W_DELTA_MASTB-MATNR .
          W_MAST-WERKS   =  W_DELTA_MASTB-WERKS .
          W_MAST-STLAN   =  W_DELTA_MASTB-STLAN .
          W_MAST-STLNR   =  W_DELTA_MASTB-STLNR .
          W_MAST-STLAL   =  W_DELTA_MASTB-STLAL .
          W_MAST-LOSVN   =  W_DELTA_MASTB-LOSVN .
          W_MAST-ANDAT   =  W_DELTA_MASTB-ANDAT .
          W_MAST-ANNAM   =  W_DELTA_MASTB-ANNAM .
          W_MAST-CTIME   =  SY-UZEIT .
          W_MAST-MANDT    = W_DELTA_MASTB-MANDT.

      SELECT SINGLE STLNR INTO STLNR FROM MAST WHERE STLNR = W_DELTA_MASTB-STLNR .
        IF STLNR IS INITIAL.
          W_MAST-IND     =  'O' .   "When New BOM is to be created
          w_MAST-ZYEAR   =  W_DELTA_MASTB-ANDAT+0(4).
        ELSE.
          W_MAST-IND     =  'AB' .  "When BOM is already exist and adding alternative bom to existing BOM
          W_MAST-AEDAT   =  SY-DATUM.
          W_MAST-AENAM   =  SY-UNAME .
          W_MAST-ZYEAR   =  SY-DATUM+0(4).
       ENDIF.

      SELECT MAX( COUNTER ) INTO CNT FROM ZMAST WHERE STLNR = W_DELTA_MASTB-STLNR.
          CNT = CNT + 1.
          W_MAST-COUNTER = CNT.
         INSERT ZMAST FROM W_MAST.
         APPEND W_MAST TO T_MAST.
         CLEAR :W_MAST,CNT,STLNR.
      ENDLOOP.

*....................................................................................................
*     INSERT INTO TABLE STPO
      IF DELTA_STPOB[] IS NOT INITIAL.
       LOOP AT  DELTA_STPOB INTO  W_DELTA_STPOB WHERE VBKZ = 'I' AND MVBKZ = 'I'.
          W_STPO-STLTY  =  W_DELTA_STPOB-STLTY .
          W_STPO-STLNR  =  W_DELTA_STPOB-STLNR .
          W_STPO-STLKN  =  W_DELTA_STPOB-STLKN .
          W_STPO-STPOZ  =  W_DELTA_STPOB-STPOZ .
          W_STPO-DATUV  =  W_DELTA_STPOB-DATUV .
          W_STPO-ANDAT  =  W_DELTA_STPOB-ANDAT .
          W_STPO-IDNRK  =  W_DELTA_STPOB-IDNRK .
          W_STPO-POSTP  =  W_DELTA_STPOB-POSTP .
          W_STPO-POSNR  =  W_DELTA_STPOB-POSNR .
          W_STPO-MEINS  =  W_DELTA_STPOB-MEINS .
          W_STPO-MENGE  =  W_DELTA_STPOB-MENGE .
          W_STPO-FMENG  =  W_DELTA_STPOB-FMENG .
          W_STPO-SANFE  =  W_DELTA_STPOB-SANFE .
          W_STPO-SANKA  =  W_DELTA_STPOB-SANKA .
          W_STPO-OBJTY  =  W_DELTA_STPOB-OBJTY .
          W_STPO-STVKN  =  W_DELTA_STPOB-STVKN .
          W_STPO-ANNAM  =  W_DELTA_STPOB-ANNAM .
          W_STPO-CTIME  =  SY-UZEIT .
          W_STPO-MANDT    = W_DELTA_STPOB-MANDT.
      READ TABLE DELTA_STKOB INTO W_DELTA_STKOB WITH KEY AENKZ = 'X' SELKZ = 'X'.
        IF SY-SUBRC = 0.
          W_STPO-STLAL = W_DELTA_STKOB-STLAL.
        ENDIF.
      CLEAR CNT.
       SELECT SINGLE STLNR INTO STLNR FROM MAST WHERE STLNR = W_DELTA_STPOB-STLNR .
          IF STLNR IS INITIAL.
            W_STPO-IND     =  'O' .   "When New BOM is to be created
            W_STPO-ZYEAR   =  W_DELTA_STPOB-ANDAT+0(4).
          ELSE.
            W_STPO-IND     =  'AL' .  "When BOM is already exist and adding alternative bom to existing BOM
            W_STPO-AEDAT   =  SY-DATUM.
            W_STPO-AENAM   =  SY-UNAME .
            W_STPO-ZYEAR   =  SY-DATUM+0(4).

          ENDIF.
       CLEAR CNT.
      SELECT MAX( COUNTER ) INTO CNT FROM ZSTPO WHERE STLNR = W_DELTA_STPOB-STLNR.
            CNT = CNT + 1.
          W_STPO-COUNTER = CNT.
          INSERT ZSTPO FROM W_STPO.
          APPEND W_STPO TO T_STPO.
          CLEAR :W_STPO,STLNR,CNT,W_DELTA_STPOB,W_DELTA_STPOB.
       ENDLOOP.

    ENDIF.
*...........................................................................................................
*     INSERT INTO TABLE STKO
      IF DELTA_STKOB[] IS NOT INITIAL.
       LOOP AT DELTA_STKOB INTO W_DELTA_STKOB WHERE VBKZ = 'I'.
          W_STKO-STLTY   =   W_DELTA_STKOB-STLTY .
          W_STKO-STLNR   =   W_DELTA_STKOB-STLNR .
          W_STKO-STLAL   =   W_DELTA_STKOB-STLAL .
          W_STKO-STKOZ   =   W_DELTA_STKOB-STKOZ .
          W_STKO-DATUV   =   W_DELTA_STKOB-DATUV .
          W_STKO-ANDAT   =   W_DELTA_STKOB-ANDAT .
          W_STKO-AEDAT   =   W_DELTA_STKOB-AEDAT .
          W_STKO-BMEIN   =   W_DELTA_STKOB-BMEIN .
          W_STKO-BMENG   =   W_DELTA_STKOB-BMENG .
          W_STKO-STLST   =   W_DELTA_STKOB-STLST .
          W_STKO-WRKAN   =   W_DELTA_STKOB-WRKAN .
          W_STKO-ANNAM   =   W_DELTA_STKOB-ANNAM .
          W_STKO-CTIME   =   SY-UZEIT .
          W_STKO-MANDT    = W_DELTA_STKOB-MANDT.
      SELECT SINGLE STLNR INTO STLNR FROM STKO WHERE STLNR = W_DELTA_STKOB-STLNR .
          IF STLNR IS INITIAL.
            W_STKO-IND     =  'O' .   "When New BOM is to be created
             W_STKO-ZYEAR   =  W_DELTA_STKOB-ANDAT+0(4).
          ELSE.
            W_STKO-IND     =  'AH' .  "When BOM is already exist and adding alternative bom to existing BOM
            W_STKO-AEDAT   =  SY-DATUM.
            W_STKO-AENAM   =  SY-UNAME .
            W_STKO-ZYEAR   =  SY-DATUM+0(4).
          ENDIF.
      CLEAR CNT.
      SELECT MAX( COUNTER ) INTO CNT FROM ZSTKO WHERE STLNR = W_DELTA_STKOB-STLNR.
            CNT = CNT + 1.
            W_STKO-COUNTER = CNT.
          INSERT ZSTKO FROM W_STKO.
          APPEND W_STKO TO T_STKO.
          CLEAR :W_STKO,STLNR,CNT,W_DELTA_STKOB.

       ENDLOOP.
   ENDIF.
   ENDIF.

*   ................................................................................................



 IF SY-TCODE = 'CS02'.
*   For STKO TABLE
    IF DELTA_STKOB[] IS NOT INITIAL.
*      *   If Any changes in HEADER DATA table STKO
      LOOP AT DELTA_STKOB INTO W_DELTA_STKOB WHERE VBKZ = 'U' AND MVBKZ = 'U'.
          W_STKO-STLTY   =   W_DELTA_STKOB-STLTY .
          W_STKO-STLNR   =   W_DELTA_STKOB-STLNR .
          W_STKO-STLAL   =   W_DELTA_STKOB-STLAL .
          W_STKO-STKOZ   =   W_DELTA_STKOB-STKOZ .
          W_STKO-DATUV   =   W_DELTA_STKOB-DATUV .
          W_STKO-ANDAT   =   W_DELTA_STKOB-ANDAT .
          W_STKO-AEDAT   =   W_DELTA_STKOB-AEDAT .
          W_STKO-BMEIN   =   W_DELTA_STKOB-BMEIN .
          W_STKO-BMENG   =   W_DELTA_STKOB-BMENG .
          W_STKO-STLST   =   W_DELTA_STKOB-STLST .
          W_STKO-WRKAN   =   W_DELTA_STKOB-WRKAN .
          W_STKO-ANNAM   =   W_DELTA_STKOB-ANNAM .
          W_STKO-CTIME   =   SY-UZEIT .
          W_STKO-IND     =  'UH' .
          W_STKO-AEDAT   =  SY-DATUM.
          W_STKO-AENAM   =  SY-UNAME .
          W_STKO-ZYEAR   =  SY-DATUM+0(4).
          W_STKO-MANDT    = W_DELTA_STKOB-MANDT.
        CLEAR CNT.
        SELECT MAX( COUNTER ) INTO CNT FROM ZSTKO WHERE STLNR = W_DELTA_STKOB-STLNR.
              CNT = CNT + 1.
              W_STKO-COUNTER = CNT.
             INSERT ZSTKO FROM W_STKO.
            APPEND W_STKO TO T_STKO.
            CLEAR :W_STKO,STLNR,CNT,W_DELTA_STKOB.
         ENDLOOP.

* *      .....................................................................................................
*      Delete Alternative BOM FROM STKO

      LOOP AT DELTA_STKOB INTO W_DELTA_STKOB WHERE VBKZ = 'D' AND AENKZ = 'X' AND SELKZ = 'X'.
          W_STKO-STLTY   =   W_DELTA_STKOB-STLTY .
          W_STKO-STLNR   =   W_DELTA_STKOB-STLNR .
          W_STKO-STLAL   =   W_DELTA_STKOB-STLAL .
          W_STKO-STKOZ   =   W_DELTA_STKOB-STKOZ .
          W_STKO-DATUV   =   W_DELTA_STKOB-DATUV .
          W_STKO-ANDAT   =   W_DELTA_STKOB-ANDAT .
          W_STKO-AEDAT   =   W_DELTA_STKOB-AEDAT .
          W_STKO-BMEIN   =   W_DELTA_STKOB-BMEIN .
          W_STKO-BMENG   =   W_DELTA_STKOB-BMENG .
          W_STKO-STLST   =   W_DELTA_STKOB-STLST .
          W_STKO-WRKAN   =   W_DELTA_STKOB-WRKAN .
          W_STKO-ANNAM   =   W_DELTA_STKOB-ANNAM .
          W_STKO-CTIME   =   SY-UZEIT .
          W_STKO-IND     =  'DH' .
          W_STKO-AEDAT   =  SY-DATUM.
          W_STKO-AENAM   =  SY-UNAME .
          W_STKO-ZYEAR   =  SY-DATUM+0(4).
          W_STKO-MANDT    = W_DELTA_STKOB-MANDT.
      CLEAR CNT.
      SELECT MAX( COUNTER ) INTO CNT FROM ZSTKO WHERE STLNR = W_DELTA_STKOB-STLNR.
            CNT = CNT + 1.
            W_STKO-COUNTER = CNT.
          INSERT ZSTKO FROM W_STKO.
          APPEND W_STKO TO T_STKO.
          CLEAR :W_STKO,STLNR,CNT,W_DELTA_STKOB,W_DELTA_STPOB.
       ENDLOOP.

    ENDIF.
*    ................................................................................................
    IF DELTA_STPOB[] IS NOT INITIAL.
*   CHANGES IN Line item from BOM
    LOOP AT  DELTA_STPOB INTO  W_DELTA_STPOB WHERE VBKZ = 'U' AND MVBKZ = 'U' .
          W_STPO-STLTY  =  W_DELTA_STPOB-STLTY .
          W_STPO-STLNR  =  W_DELTA_STPOB-STLNR .
          W_STPO-STLKN  =  W_DELTA_STPOB-STLKN .
          W_STPO-STPOZ  =  W_DELTA_STPOB-STPOZ .
          W_STPO-DATUV  =  W_DELTA_STPOB-DATUV .
          W_STPO-ANDAT  =  W_DELTA_STPOB-ANDAT .
          W_STPO-IDNRK  =  W_DELTA_STPOB-IDNRK .
          W_STPO-POSTP  =  W_DELTA_STPOB-POSTP .
          W_STPO-POSNR  =  W_DELTA_STPOB-POSNR .
          W_STPO-MEINS  =  W_DELTA_STPOB-MEINS .
          W_STPO-MENGE  =  W_DELTA_STPOB-MENGE .
          W_STPO-FMENG  =  W_DELTA_STPOB-FMENG .
          W_STPO-SANFE  =  W_DELTA_STPOB-SANFE .
          W_STPO-SANKA  =  W_DELTA_STPOB-SANKA .
          W_STPO-OBJTY  =  W_DELTA_STPOB-OBJTY .
          W_STPO-STVKN  =  W_DELTA_STPOB-STVKN .
          W_STPO-ANNAM  =  W_DELTA_STPOB-ANNAM .
          W_STPO-CTIME  =  SY-UZEIT .
          W_STPO-IND     =  'UL' .   "LINE ITEM CHANGES
          W_STPO-AEDAT   =  SY-DATUM.
          W_STPO-AENAM   =  SY-UNAME .
          W_STPO-ZYEAR   =  SY-DATUM+0(4).
          W_STPO-MANDT    = W_DELTA_STPOB-MANDT.
      READ TABLE DELTA_STKOB INTO W_DELTA_STKOB WITH KEY AENKZ = 'X' SELKZ = 'X'.
        IF SY-SUBRC = 0.
          W_STPO-STLAL = W_DELTA_STKOB-STLAL.
        ENDIF.
      CLEAR CNT.
      SELECT MAX( COUNTER ) INTO CNT FROM ZSTPO WHERE STLNR = W_DELTA_STPOB-STLNR.
            CNT = CNT + 1.
          W_STPO-COUNTER = CNT.
          INSERT ZSTPO FROM W_STPO.
          APPEND W_STPO TO T_STPO.
          CLEAR :W_STPO,STLNR,CNT,W_DELTA_STPOB,W_DELTA_STPOB.
       ENDLOOP.


*    INSERT LINE ITEM IN BOM
    LOOP AT  DELTA_STPOB INTO  W_DELTA_STPOB WHERE VBKZ = 'I' AND MVBKZ = 'I'.
          W_STPO-STLTY  =  W_DELTA_STPOB-STLTY .
          W_STPO-STLNR  =  W_DELTA_STPOB-STLNR .
          W_STPO-STLKN  =  W_DELTA_STPOB-STLKN .
          W_STPO-STPOZ  =  W_DELTA_STPOB-STPOZ .
          W_STPO-DATUV  =  W_DELTA_STPOB-DATUV .
          W_STPO-ANDAT  =  W_DELTA_STPOB-ANDAT .
          W_STPO-IDNRK  =  W_DELTA_STPOB-IDNRK .
          W_STPO-POSTP  =  W_DELTA_STPOB-POSTP .
          W_STPO-POSNR  =  W_DELTA_STPOB-POSNR .
          W_STPO-MEINS  =  W_DELTA_STPOB-MEINS .
          W_STPO-MENGE  =  W_DELTA_STPOB-MENGE .
          W_STPO-FMENG  =  W_DELTA_STPOB-FMENG .
          W_STPO-SANFE  =  W_DELTA_STPOB-SANFE .
          W_STPO-SANKA  =  W_DELTA_STPOB-SANKA .
          W_STPO-OBJTY  =  W_DELTA_STPOB-OBJTY .
          W_STPO-STVKN  =  W_DELTA_STPOB-STVKN .
          W_STPO-ANNAM  =  W_DELTA_STPOB-ANNAM .
          W_STPO-CTIME  =  SY-UZEIT .
          W_STPO-IND     =  'NL' .
          W_STPO-AEDAT   =  SY-DATUM.
          W_STPO-AENAM   =  SY-UNAME .
          W_STPO-ZYEAR   =  SY-DATUM+0(4).
          W_STPO-MANDT    = W_DELTA_STPOB-MANDT.
      READ TABLE DELTA_STKOB INTO W_DELTA_STKOB WITH KEY AENKZ = 'X' SELKZ = 'X'.
        IF SY-SUBRC = 0.
          W_STPO-STLAL = W_DELTA_STKOB-STLAL.
        ENDIF.
      CLEAR CNT.
      SELECT MAX( COUNTER ) INTO CNT FROM ZSTPO WHERE STLNR = W_DELTA_STPOB-STLNR.
            CNT = CNT + 1.
          W_STPO-COUNTER = CNT.
          INSERT ZSTPO FROM W_STPO.
          APPEND W_STPO TO T_STPO.
          CLEAR :W_STPO,STLNR,CNT,W_DELTA_STPOB,W_DELTA_STPOB.
       ENDLOOP.

* ....................................................................................................
*    DELETE FOR LINE ITEM
      LOOP AT  DELTA_STPOB INTO  W_DELTA_STPOB WHERE VBKZ = 'D' AND MVBKZ = 'D'.
          W_STPO-STLTY  =  W_DELTA_STPOB-STLTY .
          W_STPO-STLNR  =  W_DELTA_STPOB-STLNR .
          W_STPO-STLKN  =  W_DELTA_STPOB-STLKN .
          W_STPO-STPOZ  =  W_DELTA_STPOB-STPOZ .
          W_STPO-DATUV  =  W_DELTA_STPOB-DATUV .
          W_STPO-ANDAT  =  W_DELTA_STPOB-ANDAT .
          W_STPO-IDNRK  =  W_DELTA_STPOB-IDNRK .
          W_STPO-POSTP  =  W_DELTA_STPOB-POSTP .
          W_STPO-POSNR  =  W_DELTA_STPOB-POSNR .
          W_STPO-MEINS  =  W_DELTA_STPOB-MEINS .
          W_STPO-MENGE  =  W_DELTA_STPOB-MENGE .
          W_STPO-FMENG  =  W_DELTA_STPOB-FMENG .
          W_STPO-SANFE  =  W_DELTA_STPOB-SANFE .
          W_STPO-SANKA  =  W_DELTA_STPOB-SANKA .
          W_STPO-OBJTY  =  W_DELTA_STPOB-OBJTY .
          W_STPO-STVKN  =  W_DELTA_STPOB-STVKN .
          W_STPO-ANNAM  =  W_DELTA_STPOB-ANNAM .
          W_STPO-CTIME  =  SY-UZEIT .
          W_STPO-IND     =  'DL' .
          W_STPO-AEDAT   =  SY-DATUM.
          W_STPO-AENAM   =  SY-UNAME .
          W_STPO-ZYEAR   =  SY-DATUM+0(4).
          W_STPO-MANDT    = W_DELTA_STPOB-MANDT.
      READ TABLE DELTA_STKOB INTO W_DELTA_STKOB WITH KEY AENKZ = 'X' SELKZ = 'X'.
        IF SY-SUBRC = 0.
          W_STPO-STLAL = W_DELTA_STKOB-STLAL.
        ENDIF.
      CLEAR CNT.
      SELECT MAX( COUNTER ) INTO CNT FROM ZSTPO WHERE STLNR = W_DELTA_STPOB-STLNR.
            CNT = CNT + 1.
          W_STPO-COUNTER = CNT.
          INSERT ZSTPO FROM W_STPO.
          APPEND W_STPO TO T_STPO.
          CLEAR :W_STPO,STLNR,CNT,W_DELTA_STPOB,W_DELTA_STPOB.
       ENDLOOP.


*     DELETE BOM
  LOOP AT  DELTA_STPOB INTO  W_DELTA_STPOB WHERE VBKZ = 'D' AND AENKZ = 'X' AND SELKZ = 'X'.
          W_STPO-STLTY  =  W_DELTA_STPOB-STLTY .
          W_STPO-STLNR  =  W_DELTA_STPOB-STLNR .
          W_STPO-STLKN  =  W_DELTA_STPOB-STLKN .
          W_STPO-STPOZ  =  W_DELTA_STPOB-STPOZ .
          W_STPO-DATUV  =  W_DELTA_STPOB-DATUV .
          W_STPO-ANDAT  =  W_DELTA_STPOB-ANDAT .
          W_STPO-IDNRK  =  W_DELTA_STPOB-IDNRK .
          W_STPO-POSTP  =  W_DELTA_STPOB-POSTP .
          W_STPO-POSNR  =  W_DELTA_STPOB-POSNR .
          W_STPO-MEINS  =  W_DELTA_STPOB-MEINS .
          W_STPO-MENGE  =  W_DELTA_STPOB-MENGE .
          W_STPO-FMENG  =  W_DELTA_STPOB-FMENG .
          W_STPO-SANFE  =  W_DELTA_STPOB-SANFE .
          W_STPO-SANKA  =  W_DELTA_STPOB-SANKA .
          W_STPO-OBJTY  =  W_DELTA_STPOB-OBJTY .
          W_STPO-STVKN  =  W_DELTA_STPOB-STVKN .
          W_STPO-ANNAM  =  W_DELTA_STPOB-ANNAM .
          W_STPO-CTIME  =  SY-UZEIT .
          W_STPO-IND     =  'DL' .
          W_STPO-AEDAT   =  SY-DATUM.
          W_STPO-AENAM   =  SY-UNAME .
          w_stpo-ZYEAR   =  SY-DATUM+0(4).
          W_STPO-MANDT    = W_DELTA_STPOB-MANDT.
      READ TABLE DELTA_STKOB INTO W_DELTA_STKOB WITH KEY AENKZ = 'X' SELKZ = 'X'.
        IF SY-SUBRC = 0.
          W_STPO-STLAL = W_DELTA_STKOB-STLAL.
        ENDIF.
      CLEAR CNT.
      SELECT MAX( COUNTER ) INTO CNT FROM ZSTPO WHERE STLNR = W_DELTA_STPOB-STLNR.
            CNT = CNT + 1.
          W_STPO-COUNTER = CNT.
          INSERT ZSTPO FROM W_STPO.
          APPEND W_STPO TO T_STPO.
          CLEAR :W_STPO,STLNR,CNT,W_DELTA_STPOB,W_DELTA_STPOB.
       ENDLOOP.
   ENDIF.
 ENDIF.


  endmethod.


  method IF_EX_BOM_UPDATE~CHANGE_IN_UPDATE.

*BREAK-POINT.
  endmethod.


  method IF_EX_BOM_UPDATE~CREATE_TREX_CPOINTER.

 " break-point.
  endmethod.
ENDCLASS.
