
LOOP AT it_konv INTO bf_konv WHERE sq_no < 100.
  grand_total = bf_konv-kwert + grand_total.
ENDLOOP.
" Insert gross_amount details at 5th position
CLEAR bf_konv.
bf_konv-sq_no = 100.  "11
bf_konv-descr = 'Gross Amount'.
bf_konv-kwert = grand_total.
APPEND bf_konv TO it_konv.

SORT it_konv BY sq_no.

