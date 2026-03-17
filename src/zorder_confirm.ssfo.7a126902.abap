
CLEAR wa_vbap.
SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE vbeln = wa_final-vbeln AND posnr = wa_final-posnr.

CLEAR: CUST_DT.
IF WA_vbap-CUSTDELDATE IS NOT INITIAL.

CONCATENATE  WA_vbap-CUSTDELDATE+6(2) WA_vbap-CUSTDELDATE+4(2) WA_vbap-CUSTDELDATE+0(4)
                INTO CUST_DT SEPARATED BY '-'.
ENDIF.






















