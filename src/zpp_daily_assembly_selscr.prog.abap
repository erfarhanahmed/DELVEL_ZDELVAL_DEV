*&---------------------------------------------------------------------*
*&  Include           ZPP_SO_SHORTAGES_COPY_SELSCR
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*                               SELECTION-SCREEN                       *
*&---------------------------------------------------------------------*

      SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
      SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
      PARAMETERS       :  p_werks TYPE marc-werks OBLIGATORY  .
      SELECT-OPTIONS:  s_cdd   FOR wa_vbak-vdatu  ,"OBLIGATORY ." MODIF ID  plt. " DISPLAY CALENDER.
                       s_vbeln FOR vbap-vbeln.
      SELECTION-SCREEN END OF BLOCK b2.
      SELECTION-SCREEN END OF BLOCK b1.

      SELECT-OPTIONS:  s_status   FOR wa_vbup-lfsta NO-DISPLAY .
      SELECT-OPTIONS:  s_lfgsa   FOR  wa2_vbup-lfgsa NO-DISPLAY .
*data: wa_status type vbup-lfsta.
      DATA: wa_status LIKE s_status.
      CLEAR wa_status.
      DATA: wa_lfgsa LIKE s_lfgsa.
      CLEAR wa_lfgsa.

      wa_status-sign = 'I'.
      wa_status-option = 'EQ'.
      wa_status-low = 'A'.
      APPEND wa_status TO s_status.

      wa_status-sign = 'I'.
      wa_status-option = 'EQ'.
      wa_status-low = 'B'.
      APPEND wa_status TO s_status.



      wa_lfgsa-sign = 'I'.
      wa_lfgsa-option = 'EQ'.
      wa_lfgsa-low = 'A'.
      APPEND wa_lfgsa TO s_lfgsa.

      wa_lfgsa-sign = 'I'.
      wa_lfgsa-option = 'EQ'.
      wa_lfgsa-low = 'B'.
      APPEND wa_lfgsa TO s_lfgsa.
