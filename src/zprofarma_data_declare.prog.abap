*&---------------------------------------------------------------------*
*&  Include           ZPROFARMA_DATA_DECLARE
*&---------------------------------------------------------------------*
INCLUDE RVADTABL.

DATA:   RETCODE   LIKE SY-SUBRC.         "Returncode
DATA:   XSCREEN(1) TYPE C.               "Output on printer or screen
DATA:   REPEAT(1) TYPE C.
DATA: NAST_ANZAL LIKE NAST-ANZAL.      "Number of outputs (Orig. + Cop.)
DATA: NAST_TDARMOD LIKE NAST-TDARMOD.  "Archiving only one time

* current language for read buffered.
DATA: GF_LANGUAGE LIKE SY-LANGU.
*&---------------------------------------------------------------------*
*&      Form  PROCESSING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_US_SCREEN  text
*      <--P_LF_RETCODE  text
*----------------------------------------------------------------------*
FORM PROCESSING  USING    P_US_SCREEN
                 CHANGING P_LF_RETCODE.

ENDFORM.
