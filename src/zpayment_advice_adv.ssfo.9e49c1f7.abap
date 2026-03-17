data lv_doc_date(10) TYPE C.
DATA: LV_DMBTR01 TYPE STRING.

*BREAK-POINT.

 LV_DMBTR01 = LV_NETAMT.

 SELECT SINGLE BUDAT
              FROM BKPF
              INTO @DATA(LV_BUDAT)
              WHERE BELNR = @P_BELNR
              AND BUKRS = @P_BUKRS
              AND GJAHR = @P_GJAHR.

lv_doc_date = |{ LV_BUDAT+6(2) }{ '.' }{ LV_BUDAT+4(2) }{ '.' }{ LV_BUDAT(4) }|.

CONCATENATE 'The following payment has been made against DelVal Payment Doc No' P_BELNR 'DT' lv_doc_date
'Total Amount in Rupees'LV_DMBTR01 INTO LV_pay_str SEPARATED BY space.
*BREAK-POINT.
SELECT SINGLE sgtxt FROM bseg INTO lv_sgtxt WHERE BELNR = P_BELNR
              AND BUKRS = P_BUKRS
              AND GJAHR = P_GJAHR
              AND koart = 'K'.
