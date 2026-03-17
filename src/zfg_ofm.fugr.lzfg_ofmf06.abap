*----------------------------------------------------------------------*
***INCLUDE LZFG_OFMF06.
*----------------------------------------------------------------------*

FORM CHECK_AND_RESIZE_TABLECONTROL.
CALL FUNCTION 'ZSD_RESIZE_TABLE_CTRL'
  EXPORTING
    iv_table           = 'ZOFM_BOOKING'
    iv_maint_fg        = 'ZFG_OFM'
    iv_dynpro_no       = '0001'
    iv_width           =  180
          .
ENDFORM.
