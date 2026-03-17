*&---------------------------------------------------------------------*
*&  Include           ZPAYMENT_VOUCHER_SS
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS : p_bukrs TYPE bkpf-bukrs DEFAULT '1000' MODIF ID bu,
            p_lifnr TYPE bsak-lifnr OBLIGATORY .
SELECT-OPTIONS : s_belnr FOR  v_belnr  OBLIGATORY."TYPE BSAK-GJAHR OBLIGATORY.
PARAMETERS: p_gjahr TYPE bkpf-gjahr OBLIGATORY,
            p_budat TYPE bkpf-budat .

*PARAMETERS : s_gjahr TYPE BSAK-GJAHR.
SELECTION-SCREEN END OF BLOCK b1.

*SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
*PARAMETERS: pdf AS CHECKBOX .
*SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
