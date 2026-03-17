*&---------------------------------------------------------------------*
*&  Include           ZPP_SO_SHORTAGES_COPY_SELSCR
*&---------------------------------------------------------------------*


************************************************************************
*                               SELECTION-SCREEN                       *
************************************************************************

DATA : plantvalidation TYPE int1 VALUE 0.


SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
PARAMETERS rb_plant  RADIOBUTTON GROUP code DEFAULT 'X' USER-COMMAND codegen.
PARAMETERS rb_input RADIOBUTTON GROUP code.
SELECTION-SCREEN END OF BLOCK b3.
* Printing the report using selection screen

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS       :  p_werks TYPE marc-werks DEFAULT 'PL01' MODIF ID plt ."MEMORY ID mat.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
SELECT-OPTIONS: s_vbeln FOR wa_vbap-vbeln   MODIF ID plt,
                s_matnr FOR wa_mara-matnr  MODIF ID plt,
                s_cdd   FOR wa_vbak-vdatu   MODIF ID  plt. " DISPLAY CALENDER.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-004 .
SELECT-OPTIONS : p_month FOR wa_zsoplan-zmonth  MODIF ID int,
                 p_year FOR wa_zsoplan-zyear  MODIF ID int.
PARAMETERS:     p_werks1 TYPE marc-werks DEFAULT 'PL01' MODIF ID int.
SELECTION-SCREEN END OF BLOCK b4.
SELECT-OPTIONS:  s_lfgsa   FOR  wa2_vbup-lfgsa NO-DISPLAY .

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS p_down as CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK b5.
AT SELECTION-SCREEN OUTPUT.

LOOP AT SCREEN.
   IF screen-name = 'P_WERKS'.
      screen-input = '0'.
       MODIFY SCREEN.
       ENDIF.
        ENDLOOP.

LOOP AT SCREEN.
   IF screen-name = 'P_WERKS1'.
      screen-input = '0'.
       MODIFY SCREEN.
       ENDIF.
        ENDLOOP.



  IF rb_plant = 'X'.

**    if.
    IF sy-ucomm = '&F03'.

      REFRESH : s_vbeln, s_matnr, s_cdd.
      CLEAR : p_werks, s_vbeln.
    ENDIF.
    LOOP AT SCREEN.
      CLEAR : s_vbeln, s_matnr, s_cdd.
      IF screen-group1 = 'PLT'.

        screen-invisible = 0.
        screen-active = 1.
        MODIFY SCREEN.
      ELSEIF screen-group1 = 'INT'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.

    ENDLOOP.

    v_plnt_ind = 'X'.

  ELSE.
    CLEAR: p_month,
           p_year.
*           p_werks1.
*    CLEAR p_werks. " COMMENT BY MD

    LOOP AT SCREEN.
      IF screen-group1 = 'PLT'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ELSEIF screen-group1 = 'INT'.
        CLEAR p_werks.
        screen-invisible = 0.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    CLEAR: p_month,
           p_year.
    CLEAR v_plnt_ind.

  ENDIF.
* clear : s_vbeln,
*        s_matnr,
*        s_cdd.


  DATA: wa_lfgsa LIKE s_lfgsa.
  CLEAR wa_lfgsa.

  wa_lfgsa-sign = 'I'.
  wa_lfgsa-option = 'EQ'.
  wa_lfgsa-low = 'A'.
  APPEND wa_lfgsa TO s_lfgsa.

  wa_lfgsa-sign = 'I'.
  wa_lfgsa-option = 'EQ'.
  wa_lfgsa-low = 'B'.
  APPEND wa_lfgsa TO s_lfgsa.
