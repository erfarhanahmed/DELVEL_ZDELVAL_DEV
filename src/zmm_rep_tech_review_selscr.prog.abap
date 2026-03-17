*&---------------------------------------------------------------------*
*&  Include           ZMM_REP_TECH_REVIEW_SELSCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS : p_sono like vbak-vbeln OBLIGATORY.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE text-001.
PARAMETERS: rb_tr RADIOBUTTON GROUP g1,
            rb_cr RADIOBUTTON GROUP g1.
SELECTION-SCREEN : END OF BLOCK b2.

SELECTION-SCREEN : BEGIN OF BLOCK b3 WITH FRAME TITLE text-001.
PARAMETERS: cb_prnt as CHECKBOX  .
SELECTION-SCREEN : END OF BLOCK b3.
