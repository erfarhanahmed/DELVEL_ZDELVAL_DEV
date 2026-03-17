TYPES:
  BEGIN OF t_vekp,
    exidv TYPE vekp-exidv,
  END OF t_vekp.


DATA:
   lT_VENUM TYPE HUM_VENUM_T,
   ls_venum TYPE HUM_VENUM,
   lt_vekp  TYPE HUM_EXIDV_T,
   ls_vekp  TYPE t_vekp,
   lt_items TYPE HUM_HU_ITEM_T,
   ls_items TYPE VEPOVB,
   lt_header TYPE HUM_HU_HEADER_T,
   ls_header TYPe VEKPVB.

*BREAK PRIMUS.

WDNBX_COUNT = 0.
crgbx_count = 0.

SELECT exidv
  FROM vekp
  INTO TABLE lt_vekp
  WHERE vpobjkey = LS_BIL_INVOICE-hd_ref-DELIV_NUMB.

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
   IT_HUS                   = lt_vekp
 IMPORTING
   ET_HEADER                = lt_header
   ET_ITEMS                 = lt_items
 EXCEPTIONS
   HUS_LOCKED               = 1
   NO_HU_FOUND              = 2
   FATAL_ERROR              = 3
   OTHERS                   = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

delete ADJACENT DUPLICATES FROM lt_items COMPARING venum.
**
IF lt_items IS NOT INITIAL.
  LOOP AT lt_items INTO ls_items.
    READ TABLE lt_header INTO ls_header
              with KEY VENUM = ls_items-VENUM.
*    IF ls_header-vhilm CP 'PBMMW*' or
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







