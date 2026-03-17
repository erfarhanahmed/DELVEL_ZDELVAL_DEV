CLEAR gs_konv.
SELECT SINGLE * FROM konv INTO gs_konv
  WHERE knumv = gv_knumv
    AND kposn = gs_it_gen-itm_number
    AND kschl = 'ZPR0'.





















