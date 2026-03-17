Data: v_text1 TYPE vtext.

*break sansari.
v_qty = GS_IT_GEN-DLV_QTY.

v_text1 = GS_IT_GEN-sales_unit.

condense  v_qty.
condense v_text1.
concatenate v_qty  v_text1 into v_qty SEPARATED BY space.
clear v_text1.
****************************************************
*Code for Qty and UOM of Processed Material
"----------------------------------------------------
*Data: v_text2 TYPE vtext.
**break sansari.
*v_qty1 = wa_ekpo-menge.
*
*v_text2 = wa_ekpo-meins.
*condense  v_qty1.
*condense v_text2.
*concatenate v_qty1  v_text2 into v_qty1 SEPARATED BY space.

"--------------------------------------------------------

