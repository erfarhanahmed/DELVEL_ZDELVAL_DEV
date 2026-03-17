"Name: \PR:SAPMV45A\FO:USEREXIT_MOVE_FIELD_TO_VBKD\SE:BEGIN\EI
ENHANCEMENT 0 ZSO_MATERIAL_TYPE.

*IF sy-tcode = 'VA01'.
*
*DATA : l_mat_type TYPE mtart.
***BREAK fujiabap.
*IF xvbap[] is NOT INITIAL.
*LOOP AT xvbap.
*  SELECT SINGLE mtart FROM mara INTO l_mat_type WHERE matnr = xvbap-matnr.
*    IF l_mat_type NE 'FERT' AND l_mat_type NE 'UNBW' AND l_mat_type NE 'DIEN'.
*        MESSAGE  'This Material type is not allowed for sales order' TYPE 'E' DISPLAY LIKE 'E'.
*    ENDIF.
*ENDLOOP.
**BREAK fujiabap.
*ENDIF.
*ENDIF.
ENDENHANCEMENT.
