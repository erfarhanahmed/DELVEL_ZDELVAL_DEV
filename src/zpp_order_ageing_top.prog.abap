*&---------------------------------------------------------------------*
*& Include          ZPP_ORDER_AGEING_TOP
*&---------------------------------------------------------------------*


DATA : lt_order TYPE TABLE OF zz1_wip_order,
       ls_order TYPE zz1_wip_order.

DATA : gv_cnt_cnf type i,
       gv_cnt_pcnf type i,
       gv_cnt_dlv type i,
       gv_cnt type i.
