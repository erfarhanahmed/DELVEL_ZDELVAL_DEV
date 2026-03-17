*&---------------------------------------------------------------------*
*&  Include           Z_SUBRETROFIT_DATA_DECL
*&---------------------------------------------------------------------*

TABLES: mseg,
        mkpf,
        vbrk,
        lfa1,
        j_1ig_subcon.

TYPES:
 BEGIN OF chtab,
   chln_inv TYPE j_1ig_subcon-chln_inv,
   item     TYPE j_1ig_subcon-item,
 END   OF chtab.

DATA: ls_mseg      TYPE MSEG,
      lt_mseg      TYPE TABLE OF MSEG,
      ls_sub       TYPE          J_1IG_SUBCON,
      lt_subsrc    TYPE TABLE OF J_1IG_SUBCON.

DATA: gs_sub       TYPE          J_1IG_SUBCON,
      gt_subact    TYPE TABLE OF J_1IG_SUBCON,
      gt_chtab     TYPE TABLE OF chtab,
      gs_chtab     TYPE          chtab,
      gr_table     TYPE REF TO   cl_salv_table,
      gr_functions TYPE REF TO   cl_salv_functions_list,
      gv_log_handle TYPE         balloghndl.
