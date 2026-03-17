*&---------------------------------------------------------------------*
*& Report ZSU_FI_VAT_RETURN_N
*&---------------------------------------------------------------------*
*&
* 1.PROGRAM OWNER           : PRIMUS TECHSYSTEMS PVT LTD.
* 2.PROJECT                 : VAT RETURN REPORT DEVLOPMENT
* 3.PROGRAM NAME            : ZSU_FI_VAT_RETURN_N
* 4.TRANS CODE              : ZSU_VATRET
* 5.MODULE NAME             : FI
* 6.REQUEST NO              :
* 7.CREATION DATE           : 06.02.2024
* 8.CREATED BY              : Pooja Ubhe
* 9.FUNCTIONAL CONSULTANT   : AISHWARYA KADAM
* 10.BUSINESS OWNER         : DELVAL Saudi PLANT.
*&---------------------------------------------------------------------*
REPORT ZSU_FI_VAT_RETURN_N.

INCLUDE ZSU_FI_VAT_RETURN_SEL.
INCLUDE ZSU_FI_VAT_RETURN_SUB.

START-OF-SELECTION.

  DATA(obj_rep) = NEW lcl_cust_coll_cls( ).
  obj_rep->get_data( ).
