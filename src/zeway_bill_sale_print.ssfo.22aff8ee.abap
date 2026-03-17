
DATA: lv_date(10),
      lv_time(8),
      gstin TYPE stcd3.
DATA : date TYPE budat,
       time TYPE ZCREATIONTIME.
SELECT SINGLE gstin FROM j_1bbranch INTO gstin
  WHERE bukrs = ls_vbrk_j-bukrs
  AND branch = ls_vbrk_j-bupla.


SELECT SINGLE  CREATIONDT CREATIONTIME FROM ZEWAY_NUMBER INTO ( date , time )
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
            gstin
            gd_dt_tm
       INTO gd_qrcode
  SEPARATED BY '/'.

CONDENSE gd_qrcode.















