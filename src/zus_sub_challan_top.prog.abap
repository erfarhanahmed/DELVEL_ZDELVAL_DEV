*&---------------------------------------------------------------------*
*&  Include           ZUS_SUB_CHALLAN_TOP
*&---------------------------------------------------------------------*
TABLES : ZSUB_REMARK ,MSEG , ZSUB_CHALLAN.

DATA : BEGIN OF IT_DATA OCCURS 0,
        MBLNR  TYPE MSEG-MBLNR,
        MATNR  TYPE MSEG-MATNR,
        MENGE  TYPE string,"STRING,
        WERKS  TYPE MSEG-WERKS,
        lgort  TYPE MSEG-lgort,
        mjahr  TYPE MSEG-mjahr,
        ZEILE  TYPE STRING,
        BWART  TYPE MSEG-BWART,
        RATE   TYPE string,"P decimals 2,
        rate1  type string,
        ZSHIP_DATE   TYPE datum,
        END OF   IT_DATA.

 dATA : BEGIN OF IT_remark OCCURS 0,
       MBLNR  TYPE MSEG-MBLNR,
       zremarks TYPE zsub_remark-zremarks,
       END OF IT_remark.

data : gv_remark TYPE zsub_remark-zremarks,
       GV_SHIP_METHOD TYPE zsub_remark-zship_method,
       ZFREIGHT TYPE string,
       ZDISCOUNT TYPE zsub_remark-ZDISCOUNT,
       zterm_cond TYPE zsub_remark-zterm_cond.

DATA : it_CHALLAN TYPE STANDARD TABLE OF ZSUB_CHALLAN,
       wa_challan TYPE ZSUB_CHALLAN.
*
DATA :" it_sub_re TYPE STANDARD TABLE OF zsub_remark,
       wa_sub_re TYPE zsub_remark.
