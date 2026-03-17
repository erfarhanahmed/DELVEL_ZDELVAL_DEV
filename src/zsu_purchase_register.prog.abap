*&---------------------------------------------------------------------*
*& Report  ZPURCHASE_REGISTER
*&
*&---------------------------------------------------------------------*

report ZPURCHASE_REGISTER no standard page heading
                        message-id zmm_msg.



INCLUDE ZSU_PUR_REGISTER_DD.
*include zpur_register_dd.
include zsu_pur_register_01.         "abap work


start-of-selection.
*&---------------------------------------------------------------------*
*& Subroutine to process report data.
*&---------------------------------------------------------------------*
*  PERFORM get_authorizations.

  perform get_data1.
