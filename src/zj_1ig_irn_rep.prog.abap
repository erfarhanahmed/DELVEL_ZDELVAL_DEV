*&---------------------------------------------------------------------*
*& Report J_1IG_IRN_REP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zj_1ig_irn_rep MESSAGE-ID j_1ig_msgs.

*----------------------------------------------------------------------*
* Includes for Program
*----------------------------------------------------------------------*
BREAK primus.
INCLUDE ZJ_1IG_IRN_DATA_DECL.
*INCLUDE: j_1ig_irn_data_decl,        "Data declaration
INCLUDE ZJ_1IG_IRN_SEL_SCR.
*         j_1ig_irn_sel_scr.          "Selection Screen

*----------------------------------------------------------------------*
* Initialization
*----------------------------------------------------------------------*
INITIALIZATION.
  j_1ig_cl_irn=>init_sel_screen( ).

*----------------------------------------------------------------------*
* Start-Of-Selection
*----------------------------------------------------------------------*
START-OF-SELECTION.
INCLUDE ZJ_1IG_IRN_PROCESS.
*  INCLUDE j_1ig_irn_process.          "Processing Logic.

*----------------------------------------------------------------------*
* End-Of-Selection
*----------------------------------------------------------------------*
END-OF-SELECTION.
  IF go_ref->gt_output IS NOT INITIAL.
    go_ref->disp_out_data( ).
  ENDIF.
