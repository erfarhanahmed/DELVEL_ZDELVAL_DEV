
*CLEAR grand_total.
BREAK fujiabap.
LOOP AT it_konv INTO bf_konv WHERE sq_no > 100.
  grand_total = bf_konv-kwert + grand_total.
ENDLOOP.
*v_text =  grand_total.

