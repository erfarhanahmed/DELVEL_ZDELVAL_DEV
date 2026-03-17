
SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE VBELN = IS_VBDKA-VBELN
    AND posnr = wa_final-posnr
    AND matnr = wa_final-matnr.

if wa_vbap-custdeldate is not INITIAL. "added by jyoti on 14.11.2024
gv_req_date = wa_vbap-custdeldate.

CONCATENATE  GV_REQ_DATE+4(2) GV_REQ_DATE+6(2)
GV_REQ_DATE+0(4)
                INTO GV_REQ_DATE SEPARATED BY '.'.
ENDIF. "added by jyoti on 14.11.2024















