
CLEAR gv_category.
SELECT SINGLE zmono INTO gv_category
  FROM vbap
  WHERE vbeln = header-vbeln
  AND POSNR = header-vbelp.


CASE gv_category.
  WHEN '1'.
    gv_cat_txt = '(MONOGRAMMED)' .
  WHEN '2'.
    gv_cat_txt = '(MONOGRAMMABLE)'.
  WHEN '3'.
    gv_cat_txt =  '(NON-MONOGRAMMABLE)'.
ENDCASE.















