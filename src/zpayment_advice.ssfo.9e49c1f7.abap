data lv_doc_date(10) TYPE C.
data lv_total01 TYPE STRING.
data lv_total02 TYPE dmbtr.

data(lv_augbl) = augbl.

CLEAR lv_total02.
 LOOP AT IT_FINAL INTO WA_FINAL .
   IF WA_FINAL-augbl = lv_augbl .
      lv_total02 =  lv_total02 + WA_FINAL-NET_DMBTR  .
   ENDIF.
   ENDLOOP.

 lv_total01 = lv_total02.

lv_doc_date = |{ WA_HEADER_DETAILS-AUGDT+6(2) }{ '.' }{ WA_HEADER_DETAILS-AUGDT+4(2) }{ '.' }{ WA_HEADER_DETAILS-AUGDT(4) }|.

CONCATENATE 'The following payment has been made against DelVal Payment Doc No' augbl 'DT' lv_doc_date
 'Total Amount in Rupees' LV_TOTAL01 INTO LV_pay_str SEPARATED BY space.

 CLEAR: lv_augbl.
