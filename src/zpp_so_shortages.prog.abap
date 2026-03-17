*----------------------------------------------------------------------*
*                          Program Details                             *
*----------------------------------------------------------------------*
* Program Name         : ZPP_SO_SHORTAGES.                             *
* Title                : SALES ORDER SHORTAGES                         *
* Created By           : Sansari                                       *
* Started On           : 20 January 2011                               *
* Transaction Code     :  ZPPSOS                                       *
* Description          : ALV presentation for SALES ORDER WISE SHORTAGES*
*----------------------------------------------------------------------*

REPORT  zpp_so_shortages  MESSAGE-ID zdel.

INCLUDE zpp_so_shortages_top.
*include zpp_so_shortages_copy_top.
INCLUDE zpp_so_shortages_selscr.
*include zpp_so_shortages_copy_selscr.
*INCLUDE ZPP_SO_SHORTAGES_DATASEL.

INCLUDE zpp_so_shortages_dataselection.
