*
*IF sfsy-copycount = 1.
*gv_copy = 'Duplicate'.
*ENDIF.

CASE sfsy-copycount.
  WHEN 001.
    gv_copy = 'Original'.
  WHEN 002.
    gv_copy = 'Duplicate'.
  WHEN 003.
    gv_copy = 'Triplicate'.
  WHEN 004.
    gv_copy = 'Gate Copy'.
ENDCASE.




















