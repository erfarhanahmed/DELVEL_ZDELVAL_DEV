TYPES:
  BEGIN OF t_vekp,
    exidv TYPE vekp-exidv,
  END OF t_vekp.


DATA:
  lt_venum  TYPE hum_venum_t,
  ls_venum  TYPE hum_venum,
  lt_vekp   TYPE hum_exidv_t,
  ls_vekp   TYPE t_vekp,
  lt_items  TYPE hum_hu_item_t,
  ls_items  TYPE vepovb,
  lt_header TYPE hum_hu_header_t,
  ls_header TYPE vekpvb.


SELECT exidv
  FROM vekp
  INTO TABLE lt_vekp
  WHERE vpobjkey = ls_bil_invoice-hd_ref-deliv_numb.

*BREAK-POINT.
***  LOOP AT lt_vekp INTO ls_vekp.
***     CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
***       EXPORTING
***         input         = ls_vekp-exidv
***       IMPORTING
***         OUTPUT        = ls_venum-VENUM
***               .
***     APPEND ls_venum to lT_VENUM.
***  ENDLOOP.
CALL FUNCTION 'HU_GET_HUS'
  EXPORTING
    it_hus      = lt_vekp
  IMPORTING
    et_header   = lt_header
    et_items    = lt_items
  EXCEPTIONS
    hus_locked  = 1
    no_hu_found = 2
    fatal_error = 3
    OTHERS      = 4.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

DELETE ADJACENT DUPLICATES FROM lt_items COMPARING venum.
**
IF lt_items IS NOT INITIAL.
  LOOP AT lt_items INTO ls_items.
    READ TABLE lt_header INTO ls_header
              WITH KEY venum = ls_items-venum.
*   IF ls_header-vhilm CP 'PBMMW*' or
*          ls_header-vhilm CP 'CPBBMW*'.
    IF ls_header-vhart = 'Z002'.
      wdnbx_count = wdnbx_count + ls_items-velin.
    ELSEIF ls_header-vhart = 'Z001'."ls_header-vhilm CP 'PBMMC*' or
*          ls_header-vhilm CP 'CPBBMC*'.
      crgbx_count = crgbx_count + ls_items-velin.
    ENDIF.
  ENDLOOP.
  ttlbx_count = wdnbx_count + crgbx_count .
ENDIF.
**
**
**
**
**












