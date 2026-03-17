"Name: \FU:MRM_INVOICE_CHECK\SE:END\EI
ENHANCEMENT 0 ZCHANGE_QTY_MRRL.
*
*  BREAK primusabap.
  IF ( sy-tcode = 'MRRL' or sy-tcode = 'ZMRRL' ).

  DATA: lv_first_qty TYPE menge_d,
        lv_rate(13) TYPE p DECIMALS 2.
  dATA : IT_RSEG  TYPE MMCR_TDRSEG."TABLE OF MMCR_TDRSEG.
  dATA : WA_RSEG LIKE t_drseg.
*  dATA : WA_RSEG_NEW TYPE MMCR_TDRSEG.
*break primusabap.
***************************************************************************
*  LOOP AT t_drseg." INTO WA_RSEG.
*    IF t_drseg-LFBNR IS NOT INITIAL.
*      WA_RSEG = t_drseg.
*      APPEND WA_RSEG TO IT_RSEG.
*    ENDIF.
*  ENDLOOP.
*LOOP AT IT_RSEG INTO DATA(WA_RSEG_NEW) .
**************************Addded by parkishit on 30.04.2024************************

  DELETE ADJACENT DUPLICATES FROM t_drseg[] COMPARING ALL FIELDS.
*  SORT T_DRSEG[] BY LFBNR EBELN EBELP.
  SORT T_DRSEG[] DESCENDING BY EBELN EBELP LFBNR lfpos .  " added by sonu
  LOOP AT t_drseg ASSIGNING FIELD-SYMBOL(<lfs_drseg>)." WHERE EBELN = WA_RSEG_NEW-EBELN
*                                                        AND EBELP = WA_RSEG_NEW-EBELP.
*                                                        AND lfbnr NE ' '.
*    IF sy-tabix = 1.
    data :gv_index type i .
     IF <lfs_drseg>-LFBNR IS NOT INITIAL.
*      lv_first_qty = <lfs_drseg>-menge.
         clear lv_first_qty.
     loop at t_drseg ASSIGNING FIELD-SYMBOL(<lfs_drseg1>) WHERE LFBNR = <LFS_DRSEG>-LFBNR
                                                           AND EBELN = <LFS_DRSEG>-EBELN
                                                            AND EBELP = <LFS_DRSEG>-EBELP."FROM gv_index.
    lv_first_qty = lv_first_qty + <lfs_drseg1>-menge.
    endloop.
    ELSE.
      IF lv_first_qty ne <lfs_drseg>-menge.
        lv_rate = <lfs_drseg>-netwr / <lfs_drseg>-bsmng.
        <lfs_drseg>-menge = lv_first_qty.
        <lfs_drseg>-wrbtr = lv_rate * lv_first_qty.
        CLEAR: lv_rate.
      ENDIF.
    ENDIF.
  ENDLOOP.
CLEAR: lv_rate, lv_first_qty.
*ENDLOOP.
**************************************************************************************

ENDIF.
ENDENHANCEMENT.
