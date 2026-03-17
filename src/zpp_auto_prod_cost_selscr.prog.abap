*&---------------------------------------------------------------------*
*&  SELECTION SCREEN
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1.  " WITH FRAME TITLE text-001.
PARAMETERS       :  p_werks TYPE marc-werks OBLIGATORY,
                    p_matnr TYPE mara-matnr OBLIGATORY,
                    p_erdat TYPE vbak-erdat OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECT-OPTIONS:  s_AEDAT   FOR  wa_ekko-AEDAT NO-DISPLAY .


*DATA wa_AEDAT LIKE s_AEDAT.
*CLEAR: wa_AEDAT.
*
*old_date = sy-datum - 90.
*wa_AEDAT-sign = 'I'.
*wa_AEDAT-option = 'BT'.
*wa_AEDAT-low = old_date .
*wa_AEDAT-high = sy-datum.
*APPEND wa_AEDAT TO s_AEDAT.

AT SELECTION-SCREEN .

  CLEAR WA_MARA.
  SELECT SINGLE * FROM MARA INTO WA_MARA WHERE MATNR EQ P_MATNR.
    IF WA_MARA-MTART <> 'FERT'.
           MESSAGE 'Please Enter Material of type FERT'
           TYPE 'E'.
*           TYPE 'S' DISPLAY LIKE 'E'.
*       SET SCREEN 0.
*      LEAVE SCREEN.
*      LEAVE to SCREEN 0.
*         LEAVE LIST-PROCESSING.
    ENDIF.


DATA wa_AEDAT LIKE s_AEDAT.
CLEAR: wa_AEDAT.
REFRESH S_AEDAT.
old_date = sy-datum - 90.
wa_AEDAT-sign = 'I'.
wa_AEDAT-option = 'BT'.
wa_AEDAT-low = old_date .
wa_AEDAT-high = sy-datum.
APPEND wa_AEDAT TO s_AEDAT.
