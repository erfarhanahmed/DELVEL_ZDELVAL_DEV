*&---------------------------------------------------------------------*
*&  Include           ZSD_SALESORDER_CHANGE_DATA
*&---------------------------------------------------------------------*

data : order_header_in like bapisdhd1 occurs 100 with header line. .
data : return like bapiret2 occurs 100 with header line.
data : order_headerx_in like BAPISDH1X  ."occurs 100 with header line..
data :IORDER_ITEM_IN TYPE STANDARD TABLE OF BAPISDITM ,"WITH HEADER LINE,
       wa_IORDER_ITEM_IN type  BAPISDITM.
data : IORDER_ITEM_INx TYPE STANDARD TABLE OF BAPISDITMx ,"WITH HEADER LINE,
       wa_IORDER_ITEM_INx type  BAPISDITMx.
data :  it_sch type STANDARD TABLE OF BAPISCHDL ,
        WA_SCH TYPE BAPISCHDL.
data :  it_schx type STANDARD TABLE OF BAPISCHDLx ,
        WA_SCHx TYPE BAPISCHDLX.
data: it_vbak type STANDARD TABLE OF vbak,
      it_vbep type STANDARD TABLE OF vbep,
      wa_vbak type vbak,
      wa_vbep type vbep.
data: CTUMODE LIKE CTU_PARAMS-DISMODE value 'N' .
data:  CUPDATE LIKE CTU_PARAMS-UPDMODE value 'L'.
DATA:   BDCDATA LIKE BDCDATA    OCCURS 0 WITH HEADER LINE.

PARAMETERS : p_vbeln type vbak-vbeln obligatory.
