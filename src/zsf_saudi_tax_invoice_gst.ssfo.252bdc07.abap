DATA : VDT(2) TYPE C,VMN(2) TYPE C,VYR(4) TYPE C.

 VDT = ls_bil_invoice-HD_GEN-BIL_DATE+6(2).
 VMN = ls_bil_invoice-HD_GEN-BIL_DATE+4(2).
 VYR = ls_bil_invoice-HD_GEN-BIL_DATE+0(4).

 CONCATENATE VYR '-' VMN '-' VDT INTO GVINVDT.























