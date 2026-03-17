*&---------------------------------------------------------------------*
*&  Include           ZCOOIS_COMP_ISSUE_SS
*&---------------------------------------------------------------------*
CONSTANTS : C_PL01 TYPE CHAR4 VALUE 'PL01',
            C_PATH TYPE CHAR40 VALUE '/delval/temp'. "'E:\delval\temp'.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS  : S_BUDAT FOR afru-budat ,
                  s_AUFNR FOR resb-aufnr ,
                  S_AUART FOR CAUFV-AUART ,
                  s_KDAUF FOR resb-kdauf ,
                  S_KDPOS FOR resb-kdpos .
PARAMETERS :     p_werks TYPE resb-werks OBLIGATORY DEFAULT C_PL01 MODIF ID BU.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-005.
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder TYPE rlgrap-filename DEFAULT C_PATH.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-006.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
