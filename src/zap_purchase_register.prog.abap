*&---------------------------------------------------------------------*
*& Report  ZPURCHASE_REGISTER
*&
*&---------------------------------------------------------------------*

report ZPURCHASE_REGISTER no standard page heading
                        message-id zmm_msg.



INCLUDE ZAP_PUR_REGISTER_DD.
*include zpur_register_dd.
INCLUDE ZAP_PUR_REGISTER_01.
*include zpur_register_01.         "abap work


start-of-selection.
*&---------------------------------------------------------------------*
*& Subroutine to process report data.
*&---------------------------------------------------------------------*

  perform get_data.
