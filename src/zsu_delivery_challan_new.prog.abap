*&---------------------------------------------------------------------*
*& Report ZSU_DELIVERY_CHALLAN_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_DELIVERY_CHALLAN_NEW.

DATA IT_GRXSUB_N.
INCLUDE Zj_1ig_sub_data_decl.

*** Selc screen
INCLUDE Zj_1ig_sub_sel_scr.

START-OF-SELECTION.
*** Process data
  INCLUDE Zj_1ig_sub_get_data.

*** Build ALV
  INCLUDE Zj_1ig_sub_alv_N.

*** Subroutines
  INCLUDE Zj_1ig_sub_forms.
