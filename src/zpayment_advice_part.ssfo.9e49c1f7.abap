data lv_doc_date(10) TYPE C.

SELECT SINGLE BUDAT FROM BKPF
                    INTO @DATA(LV_BUDAT)
                     WHERE BUKRS = '1000'
                     AND BELNR = @P_BELNR
                     AND GJAHR = @P_GJAHR.


*lv_doc_date = |{ WA_HEADER_DETAILS-AUGDT+6(2) }{ '.' }{ WA_HEADER_DETAILS-AUGDT+4(2) }{ '.' }{ WA_HEADER_DETAILS-AUGDT(4) }|.
lv_doc_date = |{ LV_BUDAT+6(2) }{ '.' }{ LV_BUDAT+4(2) }{ '.' }{ LV_BUDAT(4) }|.
DATA:LV_DMBTR01 TYPE STRING.
*BREAK-POINT.
LV_DMBTR01 = WA_HEADER_DETAILS-DMBTR.

CONCATENATE 'The following payment has been made against DelVal Payment Doc No' P_BELNR 'DT' lv_doc_date
 'Total Amount in Rupees'LV_DMBTR01 INTO LV_pay_str SEPARATED BY space.
