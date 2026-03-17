*&---------------------------------------------------------------------*
*& Include          ZPP_ORDER_AGEING_SELSCR
*&---------------------------------------------------------------------*
TABLES : vbak,mara,aufk.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS  :   s_werks FOR aufk-werks ,
                      s_kunnr FOR vbak-kunnr ,
                      s_auart FOR aufk-auart ,
                      s_div FOR vbak-spart ,
                      s_brand FOR mara-brand .
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2  WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_bkt1 TYPE c RADIOBUTTON GROUP g1 DEFAULT 'X',
              p_bkt2 TYPE c RADIOBUTTON GROUP g1,
              p_bkt3 TYPE c RADIOBUTTON GROUP g1,
              p_bkt4 TYPE c RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3  WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_cnf  TYPE c AS CHECKBOX,
              p_pcnf TYPE c AS CHECKBOX,
              p_dlv  TYPE c AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b3.
