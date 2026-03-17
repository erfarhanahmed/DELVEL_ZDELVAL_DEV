*&---------------------------------------------------------------------*
*&  Include           ZPP_SO_SHORTAGES_COPY_SELSCR
*&---------------------------------------------------------------------*


************************************************************************
*                               SELECTION-SCREEN                       *
************************************************************************

DATA : plantvalidation TYPE int1 VALUE 0.


*selection-screen begin of block b3 with frame title text-002.
*  parameters rb_plant  radiobutton group code DEFAULT 'X' USER-COMMAND codegen.
*  parameters rb_input radiobutton group code.
*selection-screen end of block b3.
* Printing the report using selection screen

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
PARAMETERS : p_werks TYPE marc-werks OBLIGATORY MODIF ID plt, "MEMO       RY ID mat.
             p_matnr TYPE mara-matnr OBLIGATORY MODIF ID plt,
             p_qty   TYPE bmeng OBLIGATORY MODIF ID plt,
             P_lgort type lgort_D OBLIGATORY MODIF ID plt."ADDED BY JYOTI ON 12.06.2024

*      SELECT-OPTIONS: s_vbeln FOR wa_vbap-vbeln   MODIF ID plt,
*      SELECT-OPTIONS: s_matnr FOR wa_mara-matnr  MODIF ID plt,
*                      s_cdd   FOR wa_vbak-vdatu   MODIF ID  plt. " DISPLAY CALENDER.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN END OF BLOCK b1.
*
*      SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME title text-004 .
*       SELECT-OPTIONs : p_month for wa_zsoplan-zmonth  MODIF ID int,
*                        p_year for wa_zsoplan-zyear  MODIF ID int.
*        PARAMETERS:     p_werks1 TYPE marc-werks  MODIF ID int.
*      SELECTION-SCREEN END OF BLOCK b4.

*AT SELECTION-SCREEN.
*IF  P_qty <= 0.
*        SET CURSOR FIELD 'P_QTY'.
*        MESSAGE 'Quantity should be greter than zero'
*           TYPE 'S'
*        DISPLAY LIKE 'E'.
*ENDIF.

AT SELECTION-SCREEN OUTPUT.

*  IF rb_plant = 'X'.

*    if.
  IF sy-ucomm = '&F03'.

*  refresh :  p_matnr. s_vbeln."", s_cdd.
    CLEAR : p_werks, p_matnr, p_qty, p_LGORT." s_vbeln.
  ENDIF.
  LOOP AT SCREEN.
*      clear : s_vbeln, p_matnr.", s_cdd.
*      clear : p_matnr.", s_cdd.
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

*  ELSE.
*clear: p_month,
*       p_year,
*       P_WERKS1.
*clear p_werks.
*
*    LOOP AT SCREEN.
*      IF screen-group1 = 'PLT'.
*        screen-invisible = 1.
*        screen-active = 0.
*        MODIFY SCREEN.
*      ELSEIF screen-group1 = 'INT'.
*        clear p_werks.
*        screen-invisible = 0.
*        screen-active = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*clear: p_month,
*       p_year.
*CLEAR V_PLNT_IND.
*
**ENDIF.
* clear : s_vbeln,
*        s_matnr,
*        s_cdd.
