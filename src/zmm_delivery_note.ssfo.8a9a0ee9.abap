DATA lv_lifnr TYPE lfa1-lifnr.
DATA ls_lfa1 TYPE lfa1.
DATA lv_adrnr TYPE adrc-addrnumber.

*IF gs_mseg1-bwart = '201'.
*  lv_lifnr = i_mkpf-xblnr.
*  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*    EXPORTING
*      input  = lv_lifnr
*    IMPORTING
*      output = lv_lifnr.
*ELSE.
lv_lifnr = gs_mseg1-lifnr.

IF gs_mseg1-ebeln IS NOT INITIAL.
  SELECT SINGLE aedat FROM ekko INTO gv_podt WHERE ebeln = gs_mseg1-ebeln.
ENDIF.
*ENDIF.

SELECT SINGLE * FROM lfa1 INTO ls_lfa1
  WHERE lifnr = lv_lifnr.

SELECT SINGLE * FROM j_1imovend
  INTO gs_moven
  WHERE lifnr = lv_lifnr.

lv_adrnr = ls_lfa1-adrnr.

SELECT SINGLE * FROM adrc INTO gs_adrc
  WHERE addrnumber = lv_adrnr.
SELECT SINGLE * FROM t005t
  INTO gs_t005t
  WHERE land1 = gs_adrc-country
    AND spras = sy-langu.
SELECT SINGLE * FROM t005u INTO gs_t005u
  WHERE spras = sy-langu
    AND land1 = gs_adrc-country
    AND bland = gs_adrc-region.
