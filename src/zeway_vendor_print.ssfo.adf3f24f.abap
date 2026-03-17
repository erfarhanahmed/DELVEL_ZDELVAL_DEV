DATA: lv_date(10),
      lv_time(8),
      gstin TYPE stcd3.
DATA : date TYPE budat,
       time TYPE ZCREATIONTIME.

READ TABLE lt_final_eway INTO ls_final_eway INDEX 1.

SELECT SINGLE  CREATIONDT CREATIONTIME FROM zeway_res_122 INTO ( date , time )
    WHERE EWAY_BILL = P_EBILLNO.

CLEAR :lv_date,lv_time.

CONCATENATE date+4(2)
            date+6(2)
            date+0(4)
       INTO lv_date
   SEPARATED BY '/'.

CONCATENATE time+0(2)
            time+2(2)
            time+4(2)
       INTO lv_time
    SEPARATED BY ':'.

CONCATENATE lv_date
            lv_time
*            gd_time
       INTO gd_dt_tm
  SEPARATED BY ' '.

CONCATENATE P_EBILLNO
            ls_final_eway-fromgstin
            gd_dt_tm
       INTO gd_qrcode
  SEPARATED BY '/'.

CONDENSE gd_qrcode.




















