"Name: \FU:FI_WT_READ_LFBW\SE:END\EI
ENHANCEMENT 0 ZMRRL_WITHTAXCODE.
************Addedby jyoti on 25.06.2024
  data : LV_TAX(5) type c.
    clear LV_TAX.
*    if SY-TCODE eq 'ZMRRL' OR SY-TCODE eq 'MRRL'.
**
**      IMPORT gv_ebeln TO gv_ebeln FROM MEMORY ID 'EBELN'.
*      BREAK PRIMUSABAP.
*      import SEGTAB-ZZWITHT to LV_TAX from memory id 'ZMRRL_TAX'.
**
*
**      import ptx_segtab-zzwitht-ZZWITHT to LV_TAX from memory id 'ZMRRL_TAX'.
*      delete H_LFBW where WITHT ne LV_TAX.
*      delete X_LFBW where WITHT ne LV_TAX.
*      delete T_LFBW where WITHT ne LV_TAX.
*    endif.

    TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
         knumv TYPE ekko-knumv,
         bsart TYPE ekko-bsart,
       END OF ty_ekko.
 data :  gt_ekko    TYPE TABLE OF ty_ekko,
      gs_ekko    TYPE ty_ekko,
       gv_ebeln type ekko-ebeln.

     if SY-TCODE eq 'ZMRRL' OR SY-TCODE eq 'MRRL'.
*        BREAK PRIMUSABAP.
      IMPORT GT_EKKO TO GT_EKKO FROM MEMORY ID 'ZMRRL_EKKO'.
      IMPORT gv_ebeln TO gv_ebeln FROM MEMORY ID 'EBELN'.

      import SEGTAB-ZZWITHT to LV_TAX from memory id 'ZMRRL_TAX'.
      READ TABLE gt_ekko INTO gs_ekko WITH  KEY ebeln = gv_ebeln.
      LOOP AT T_LFBW into Data(w_lfbw) where lifnr = i_lifnr.
       IF w_lfbw-witht IS NOT INITIAL AND w_lfbw-wt_withcd IS NOT INITIAL AND
              w_lfbw-wt_subjct IS NOT INITIAL.
          DATA : gv_witht TYPE lfbw-witht.
          DATA : gv_witht2 TYPE lfbw-witht.
           gv_witht = '4Q'.
            IF gs_ekko-bsart = 'NB'.
               IF gv_witht = w_lfbw-witht.
              LV_TAX =  w_lfbw-witht.
            ENDIF.
      ELSEIF gs_ekko-bsart = 'ZSUB'.
            DATA(gv_witht1) = 'T1'.
             IF gv_witht1 = w_lfbw-witht.
              LV_TAX =  w_lfbw-witht.
            ENDIF.
      endif.
     endif.
     ENDLOOP.
*      import ptx_segtab-zzwitht-ZZWITHT to LV_TAX from memory id 'ZMRRL_TAX'.
      delete H_LFBW where WITHT ne LV_TAX.
      delete X_LFBW where WITHT ne LV_TAX.
      delete T_LFBW where WITHT ne LV_TAX.
    endif.

ENDENHANCEMENT.
