*&---------------------------------------------------------------------*
*& Report ZUS_SUB_CHALLAN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_sub_challan.


INCLUDE zus_sub_challan_ss.
INCLUDE zus_sub_challan_TOP.
INCLUDE zus_sub_challan_PBO.
INCLUDE zus_sub_challan_data.

START-OF-SELECTION.
  PERFORM get_entry.

CONTROLS: TAB1 TYPE TABLEVIEW USING SCREEN 0200.
