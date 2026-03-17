*&---------------------------------------------------------------------*
*& Report Z_SUB_RETROFIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SUB_RETROFIT MESSAGE-ID J_1IG_MSGS.

*Data declaration
INCLUDE z_subretrofit_data_decl.

*Selection screen
INCLUDE z_subretrofit_sel_scr.

START-OF-SELECTION.
*Process
  INCLUDE z_subretrofit_process.

*Subroutines
  INCLUDE z_subretrofit_forms.
