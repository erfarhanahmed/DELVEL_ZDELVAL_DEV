*&---------------------------------------------------------------------*
*& Include          ZPP_ORDER_AGEING_DATASEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  DATA : lv_today TYPE dats,
         lv_f20   TYPE dats,
         lv_f30   TYPE dats,
         lv_f45   TYPE dats.
  lv_today = sy-datum.
  lv_f20 = lv_today - 20.
  lv_f30 = lv_today - 30.
  lv_f45 = lv_today - 45.

  IF p_bkt1 = 'X'.
    SELECT * FROM zz1_wip_order
       WHERE soldtoparty IN @s_kunnr
         AND productionplant IN @s_werks
         AND division IN @s_div
         AND zbrand IN @s_brand
         AND manufacturingordertype IN @s_auart
         AND (
                   ( @p_cnf = @abap_true AND orderisconfirmed = 'X' )
               OR  ( @p_pcnf = @abap_true AND orderispartiallyconfirmed = 'X' )
               OR  ( @p_dlv = @abap_true AND orderisdelivered = 'X' )
              )
         AND creationdate BETWEEN @lv_f20 AND @lv_today
      INTO CORRESPONDING FIELDS OF TABLE @lt_order.
  ELSEIF p_bkt2 = 'X'.
    lv_f20 = lv_f20 - 1.
    SELECT * FROM zz1_wip_order
       INTO CORRESPONDING FIELDS OF TABLE @lt_order
      WHERE soldtoparty IN @s_kunnr
        AND productionplant IN @s_werks
        AND division IN @s_div
        AND zbrand IN @s_brand
        AND manufacturingordertype IN @s_auart
        AND orderisconfirmed = @p_cnf
        AND orderispartiallyconfirmed = @p_pcnf
        AND orderisdelivered = @p_dlv
        AND creationdate BETWEEN @lv_f30 AND @lv_f20.
    .
  ELSEIF p_bkt3 = 'X'.
    lv_f30 = lv_f30 - 1.
    SELECT * FROM zz1_wip_order
       INTO CORRESPONDING FIELDS OF TABLE @lt_order
      WHERE soldtoparty IN @s_kunnr
        AND productionplant IN @s_werks
        AND division IN @s_div
        AND zbrand IN @s_brand
        AND manufacturingordertype IN @s_auart
        AND orderisconfirmed = @p_cnf
        AND orderispartiallyconfirmed = @p_pcnf
        AND orderisdelivered = @p_dlv
        AND creationdate BETWEEN @lv_f45 AND @lv_f30.
  ELSEIF p_bkt4 = 'X'.
    SELECT * FROM zz1_wip_order
      WHERE soldtoparty IN @s_kunnr
        AND productionplant IN @s_werks
        AND division IN @s_div
        AND zbrand IN @s_brand
        AND manufacturingordertype IN @s_auart
        AND (
                   ( @p_cnf = @abap_true AND orderisconfirmed = 'X' )
               OR  ( @p_pcnf = @abap_true AND orderispartiallyconfirmed = 'X' )
               OR  ( @p_dlv = @abap_true AND orderisdelivered = 'X' )
              )
        AND creationdate LT @lv_f45
      INTO CORRESPONDING FIELDS OF TABLE @lt_order.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .
 DATA : lo_alv TYPE REF TO cl_salv_table,
        lo_header TYPE REF TO cl_salv_form_layout_grid,
        lo_label TYPE REF TO cl_salv_form_label,
        lo_text TYPE REF TO cl_salv_form_text,
        lo_columns     TYPE REF TO cl_salv_columns,
        lo_column TYPE REF TO cl_salv_column.

* gv_cnt_cnf = lines( FILTER ANY( lt_order where orderisconfirmed = 'X' ) ).
 gv_cnt = lines( lt_order ).
 gv_cnt_cnf = REDUCE i( INIT x = 0 FOR wa in lt_order
                        NEXT x = x + COND i( WHEN wa-orderisconfirmed = 'X' then 1 ELSE 0 ) ).

  gv_cnt_pcnf = REDUCE i( INIT x = 0 FOR wa in lt_order
                        NEXT x = x + COND i( WHEN wa-orderispartiallyconfirmed = 'X' then 1 ELSE 0 ) ).

  gv_cnt_dlv = REDUCE i( INIT x = 0 FOR wa in lt_order
                        NEXT x = x + COND i( WHEN wa-orderisdelivered = 'X' then 1 ELSE 0 ) ).

***********create ALV********
  cl_salv_table=>factory(
   IMPORTING
     r_salv_table = lo_alv
   CHANGING
     t_table      = lt_order ).

*********Enable standard functions******
  lo_alv->get_functions( )->set_all( abap_true ).

*********Create a header layout
create OBJECT lo_header.
*lo_label =  lo_alv->get_display_settings( ).
lo_label = lo_header->create_label( row = 1 column = 1 ).
lo_label->set_text( 'Order Ageing Report' ).

lo_label = lo_header->create_label( row = 2 column = 1 ).
lo_label->set_text( 'Date:' ).
lo_text = lo_header->create_text( row = 2 column = 2 ).
lo_text->set_text( sy-datum ).

lo_label = lo_header->create_label( row = 3 column = 1 ).
lo_label->set_text( 'Total Count:' ).
lo_text = lo_header->create_text( row = 3 column = 2 ).
lo_text->set_text( gv_cnt ).

lo_label = lo_header->create_label( row = 4 column = 1 ).
lo_label->set_text( 'Confirmed Orders:' ).
lo_text = lo_header->create_text( row = 4 column = 2 ).
lo_text->set_text( gv_cnt_cnf ).

lo_label = lo_header->create_label( row = 5 column = 1 ).
lo_label->set_text( 'Partially confirmed orders:' ).
lo_text = lo_header->create_text( row = 5 column = 2 ).
lo_text->set_text( gv_cnt_pcnf ).

lo_label = lo_header->create_label( row = 6 column = 1 ).
lo_label->set_text( 'Delivered orders:' ).
lo_text = lo_header->create_text( row = 6 column = 2 ).
lo_text->set_text( gv_cnt_dlv ).

lo_alv->set_top_of_list( lo_header ).
* If you also want the header to appear in print preview:
*    gr_table->set_top_of_list_print( lo_header ).

*********** Column header
lo_columns = lo_alv->get_columns( ).
lo_column ?= lo_columns->get_column( columnname = 'ORDERISRELEASED' ).
lo_column->set_long_text( value = 'Order Released' ).

lo_column ?= lo_columns->get_column( 'ORDERISCREATED' ).
lo_column->set_long_text( 'Order Created' ).

lo_column ?= lo_columns->get_column( 'ORDERISCONFIRMED' ).
lo_column->set_long_text( 'Order Confirmed' ).

lo_column ?= lo_columns->get_column( 'ORDERISPARTIALLYCONFIRMED' ).
lo_column->set_long_text( 'Order Partially Confirmed' ).

lo_column ?= lo_columns->get_column( 'ORDERISDELIVERED' ).
lo_column->set_long_text( 'Order Delivered' ).

lo_column ?= lo_columns->get_column( 'ORDERISTECHNICALLYCOMPLETED' ).
lo_column->set_long_text( 'Order Technically complete' ).

lo_column ?= lo_columns->get_column( 'ORDERISPARTIALLYDELIVERED' ).
lo_column->set_long_text( 'Order Partially Delivered' ).
*******Display ALV
  lo_alv->display( ).
ENDFORM.
