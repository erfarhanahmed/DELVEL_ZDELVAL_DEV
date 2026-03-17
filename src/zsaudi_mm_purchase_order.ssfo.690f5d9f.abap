*************ADDED BY SP************

*BREAK-POINT.
*SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE it_mara
* for ALL ENTRIES IN IT_ITEMS WHERE matnr = it_items-matnr.
*
*
**SORT IT_ITEMS BY EBELP.
*LOOP AT IT_ITEMS INTO WA_ITEM.
*
*READ TABLE IT_MARA INTO WA_MARA WITH  KEY matnr = wa_item-matnr.
*wa_item-matnr = wa_mara-matnr.
*if wa_mara-dev_status IS NOT INITIAL.
*CONCATENATE '*' WA_ITEM-MATNR  '*' INTO WA_ITEM-MATNR.

*ENDIF.
*ENDLOOP.
*CLEAR:WA_MARA.

SELECT SINGLE *
  FROM mara
  INTO wa_mara
  WHERE matnr = wa_item-matnr.
















