CLEAR : WA_LIPS, WA_MARA." WA_MARA, GV_TXT, GV_AMT, GV_KBETR.





******IF SY-SUBRC = 0.
******  SELECT SINGLE
******          MATNR
*******          GROES
******          ZSIZE
******    FROM MARA INTO CORRESPONDING FIELDS OF WA_MARA
******    WHERE MATNR = GS_IT_GEN-MATERIAL.
******ENDIF.


