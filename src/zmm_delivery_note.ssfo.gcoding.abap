
DATA ls_mseg TYPE mseg.

CLEAR gv_flag .

SELECT * FROM mseg INTO TABLE gt_mseg
  WHERE mblnr = i_mkpf-mblnr
    AND mjahr = i_mkpf-mjahr.

DELETE gt_mseg WHERE ( bwart = 'Z41' OR bwart = '541' ) AND xauto = ''.

READ TABLE gt_mseg INTO gs_mseg1 INDEX 1.

IF gs_mseg1-bwart = '541' OR gs_mseg1-bwart = 'Z41'.
  gv_flag = 'X'.
ELSE.
  CLEAR gv_flag.
ENDIF.

LOOP AT gt_mseg INTO ls_mseg.
  gv_totqty = gv_totqty + gs_mseg-menge.

ENDLOOP.












