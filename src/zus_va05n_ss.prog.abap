*&---------------------------------------------------------------------*
*&  Include           ZUS_VA05N_SS
*&---------------------------------------------------------------------*

TABLES : VBAK,VBKD,VBAP.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : S_VBELN FOR VBAK-VBELN ,
                 S_AUART FOR VBAK-auart ,
                 S_KUNNR FOR VBAK-kunnr ,
                 S_AUDAT FOR VBAK-audat ,
                 S_WERKS FOR VBAP-werks ,
                 s_bstnk FOR VBAK-bstnk .
PARAMETERS     : p_VKORG TYPE VBAK-vkorg OBLIGATORY DEFAULT C_VKORG MODIF ID bu.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-005.
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder TYPE rlgrap-filename DEFAULT C_PATH. "'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN COMMENT /1(70) TEXT-004.
SELECTION-SCREEN END OF BLOCK b3.
