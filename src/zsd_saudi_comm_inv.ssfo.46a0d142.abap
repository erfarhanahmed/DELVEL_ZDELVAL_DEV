*&IS_BIL_INVOICE-HD_GEN-BIL_DATE&

CLEAR gv_date.
*CONCATENATE is_bil_invoice-hd_gen-bil_date+6(2)
*  is_bil_invoice-hd_gen-bil_date+4(2)
*  is_bil_invoice-hd_gen-bil_date+0(4)
*  INTO gv_date
*  SEPARATED BY '-'.

CONCATENATE is_bil_invoice-hd_gen-bil_date+0(4)
            is_bil_invoice-hd_gen-bil_date+4(2)
            is_bil_invoice-hd_gen-bil_date+6(2)
INTO gv_date SEPARATED BY '.'.





















