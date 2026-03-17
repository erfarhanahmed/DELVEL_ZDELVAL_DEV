*&---------------------------------------------------------------------*
*& Report  ZSD_PEND_SO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zsd_pend_so.

INCLUDE zsd_pend_so_top.

*IF sy-repid = 'ZSD_PEND_SO' .
MESSAGE 'This Tcode is discontinued. Kindly use ZDELPENDSO Tcode' TYPE 'E'.


INCLUDE zsd_pend_so_selscr.

INCLUDE zsd_pend_so_datasel.
*ENDIF.
