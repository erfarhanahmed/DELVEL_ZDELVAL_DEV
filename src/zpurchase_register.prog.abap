*&---------------------------------------------------------------------*
*& Report  ZPURCHASE_REGISTER
*&
*&---------------------------------------------------------------------*

report ZPURCHASE_REGISTER no standard page heading
                        message-id zmm_msg.



include zpur_register_dd.
include zpur_register_01.         "abap work


start-of-selection.
*&---------------------------------------------------------------------*
*& Subroutine to process report data.
*&---------------------------------------------------------------------*

  perform get_data.
