*&---------------------------------------------------------------------*
*& Report ZGRN_POSTING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGRN_POSTING.



INCLUDE ZGRN_POSTING_DATA_01.
*INCLUDE ZPOSTING_NEW_1.
*include zgrn_posting_dd.
INCLUDE ZGRN_POSTING_DATA.
*INCLUDE ZPOSTING_NEW.
*include zgrn_posting_01.

start-of-selection.
*&---------------------------------------------------------------------*
*& Subroutine to process report data.
*&---------------------------------------------------------------------*

  perform get_data.
