SELECT BUKRS
       VBELN
       VERSION
       TRNS_MD
       TRANS_DOC
       LIFNR
       DOC_DT
       TRANS_ID
       TRANS_NAME
       VEHICAL_NO
       VEHICAL_TYPE
       DISTANCE
       UPDATEBY
       UPDATEDT
       UPDATETIME
       FROMPLACE
       FROMSTATECODE FROM ZEWAY_BILL INTO TABLE it_data
       WHERE bukrs = p_bukrs
        AND  vbeln = p_vbeln.
SORT it_data by version DESCENDING.
READ TABLE it_data INTO wa_data INDEX 1.


CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    input         = ls_final_eway-docno
 IMPORTING
   OUTPUT        = ls_final_eway-docno
          .
SELECT EWAY_BILL
       VERSION
       FROMPLACE
       REMAINDISTANCE
       VALIDUPTODATE
       VALIDUPTOTIME
       EXTNDATE
       EXTNTIME FROM ZEWAYEXTEND INTO TABLE it_extend
       WHERE EWAY_BILL = P_EBILLNO.

 SORT it_extend BY VERSION DESCENDING .

 READ TABLE it_extend INTO wa_extend INDEX 1.
 IF sy-subrc = 0.
   wa_data-DISTANCE = wa_extend-REMAINDISTANCE.
   ls_eway-VALIDUPTODATE = wa_extend-VALIDUPTODATE.
 ENDIF.
