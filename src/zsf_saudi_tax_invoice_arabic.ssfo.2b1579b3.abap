SELECT * FROM ZVEHICLE_TB INTO TABLE it_vehicle
  WHERE BILLING_NO = ls_bil_invoice-hd_gen-bil_number.

IF it_vehicle IS NOT INITIAL.
  READ TABLE it_vehicle INTO wa_vehicle INDEX 1.
  IF sy-subrc = 0.
    ls_veh = wa_vehicle-VEHICAL_NO.
  ENDIF.
  READ TABLE it_vehicle INTO wa_vehicle INDEX 2.
  IF sy-subrc = 0.
    ls_veh1 = wa_vehicle-VEHICAL_NO.
  ENDIF.
  READ TABLE it_vehicle INTO wa_vehicle INDEX 3.
  IF sy-subrc = 0.
    ls_veh2 = wa_vehicle-VEHICAL_NO.
  ENDIF.
  READ TABLE it_vehicle INTO wa_vehicle INDEX 4.
  IF sy-subrc = 0.
    ls_veh3 = wa_vehicle-VEHICAL_NO.
  ENDIF.
  READ TABLE it_vehicle INTO wa_vehicle INDEX 5.
  IF sy-subrc = 0.
    ls_veh4 = wa_vehicle-VEHICAL_NO.
  ENDIF.
ENDIF.






















