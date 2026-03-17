*BREAK-POINT.
* DELETE ADJACENT DUPLICATES FROM GT_MSEG





IF GT_MSEG IS not INITIAL .

  SELECT matnr
         werks
         steuc
         dispo
    FROM marc
    INTO TABLE gt_marc
    FOR ALL ENTRIES IN gt_MSEG
    WHERE matnr = gt_MSEG-matnr.
*      AND werks = gt_MSEG-werks.

 SELECT  KSCHL
         MATNR
         KFRST
         DATBI
         DATAB
         KNUMH
    FROM A994
    INTO TABLE tt_A994
    FOR ALL ENTRIES IN gt_mSEG
    WHERE matnr = gt_MSEG-matnr
    AND KSCHL = 'ZSUB'
   and datbi = '99991231'
    AND KFRST = ' '.
ENDIF.



LOOP AT gt_MSEG INTO GS_MSEG WHERE parent_id NE ' '.
wa_final-matnr   = gs_MSEG-matnr.
wa_final-fkimg   = GS_MSEG-MENGE.

*wa_final-netwr   = gs_item-netwr.
*wa_final-werks   = gs_item-werks.
READ TABLE GT_MARC INTO GS_MARC WITH KEY MATNR = wa_final-matnr.
wa_final-steuc = gS_marc-STEUC.


*LOOP AT it_konv INTO wa_konv WHERE knumv = wa_vbrk-knumv AND kposn = wa_final-posnr.
*CASE wa_konv-kschl.
*  WHEN 'JOCG'.
*    wa_final-cgst = wa_konv-kbetr / 10.
*    wa_final-cgst_amt = wa_konv-kwert.
*  WHEN 'JOSG'.
*    wa_final-sgst = wa_konv-kbetr / 10.
*    wa_final-sgst_amt = wa_konv-kwert.
*  WHEN 'JOIG'.
*    wa_final-igst = wa_konv-kbetr / 10.
*    wa_final-igst_amt = wa_konv-kwert.
*ENDCASE.
*ENDLOOP.

*rEAD TABLE TT_A994 INTO WA_A994 WITH KEY MATNR = wa_final-matnr.
*    IF WA_A994-DATAB = ' '.
*      WA_FINAL-KNUMH = WA_A994-KNUMH.
*    ENDIF.
*READ TABLE TT_KONP INTO WA_KONP WITH  KEY knumH =  WA_A994-KNUMH.
**                             AND kposn = wa_final-posnr.
*
  IF  wa_konp-kschl = 'ZSUB'.
    wa_final-KBETR = WA_KONP-KBETR.
    wa_final-VALUE   =  wa_final-KBETR  *  WA_FINAL-fkimg.
  ENDIF.
APPEND wa_final TO it_final.
CLEAR wa_final.
ENDLOOP.
