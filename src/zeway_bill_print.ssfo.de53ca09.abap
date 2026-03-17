*BREAK primusabap.
READ TABLE lt_vbrp into wa_vbrp with key vbeln = p_vbeln.
if wa_vbrp-lgort+0(1) = 'K'.
  wa_data-FROMPLACE = 'Kapurhol'.
endif.

 IF ls_vbrk_j-FKART = 'ZDC'.
 SELECT SINGLE LGORT FROM MSEG INTO GV_LGORT WHERE MBLNR = Wa_vbrp-VGBEL
                                                       AND XAUTO NE 'X'.
  IF GV_LGORT = 'SAN1'.
     wa_data-FROMPLACE = 'Sangavi'.
  ELSEIF GV_LGORT+0(1) = 'K'.
   wa_data-FROMPLACE = 'Kapurhol,Pune'.
   ELSEIF GV_LGORT = 'RM01' or GV_LGORT = 'FG01' OR
     GV_LGORT = 'MCN1' OR GV_LGORT = 'PLG1' OR GV_LGORT = 'PN01'
      OR GV_LGORT = 'PRD1' OR GV_LGORT = 'RJ01'
     OR GV_LGORT = 'RWK1' OR GV_LGORT = 'TPI1' OR  GV_LGORT = 'VLD1'.
    wa_data-FROMPLACE = 'Kavathe,Satara'.
  endif.

    endif.

*IF wa_data-FROMPLACE IS INITIAL.
*  wa_data-FROMPLACE = 'Kavathe,Satara'.
*ENDIF.

















