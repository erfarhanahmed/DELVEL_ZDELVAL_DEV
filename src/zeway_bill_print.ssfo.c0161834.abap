
IF wa_data-UPDATEDT IS INITIAL.
  SELECT SINGLE CREATIONDT  CREATIONTIME FROM zeway_number INTO ( wa_data-UPDATEDT ,
  wa_data-UPDATETIME  )  WHERE vbeln = p_vbeln.
ENDIF.




















