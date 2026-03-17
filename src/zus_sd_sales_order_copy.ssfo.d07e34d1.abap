


*SELECT SINGLE * FROM konv INTO wa_konv
*  WHERE KNUMV = IS_VBDKA-KNUMV
*    AND posnr = wa_final-posnr
*    AND kschl = 'ZPR0'.
CLEAR:wa_konv.

*READ TABLE IT_FINAL INTO WA_FINAL WITH KEY kposn = wa_KONV-posnr.
*                                         kschl = 'ZPR0'
*                                         kinak = ' '.


*GV_SUBTOT = GV_SUBTOT + WA_FINAL-NETWR." WA_KONV-KWERT.
*
*GV_TOT = GV_SUBTOT + GV_SALE + GV_HANDLING
*         + GV_SERVICE + GV_MOUNTING .



