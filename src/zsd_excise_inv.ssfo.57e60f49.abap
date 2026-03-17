IF flg_next_page is INITIAL.
  flg_next_page = 1.
  V_INT = 1.
ELSE.
  V_INT = flg_next_page MOD 9.
  flg_next_page = flg_next_page + 1.
ENDIF.

*if v_int = 0.
*  clear flg_next_page.
*endif.

counter = counter - 1.









