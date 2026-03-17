*&---------------------------------------------------------------------*
*& Include          J_1IG_IRN_DATA_DECL
*&---------------------------------------------------------------------*
BREAK primus.
DATA: w_date TYPE sydatum,
      w_doc  TYPE j_1ig_docno,
      w_odn  TYPE xblnr_alt,
      w_bp   TYPE bupla,
      w_stat TYPE j_1ig_irn_status,
      go_ref TYPE REF TO ZJ_1IG_CL_IRN_CUSTOM."j_1ig_cl_irn ##NEEDED.

CONSTANTS: c_m2(2) TYPE c VALUE 'M2',
           c_m3(2) TYPE c VALUE 'M3',
           c_m4(2) TYPE c VALUE 'M4',
           c_m5(2) TYPE c VALUE 'M5',
           c_m6(2) TYPE c VALUE 'M6',
           c_m7(2) TYPE c VALUE 'M7',
           c_m1(2) TYPE c VALUE 'M1',
           c_x     TYPE flag VALUE 'X',
           c_m8(2) TYPE c VALUE 'M8'.
