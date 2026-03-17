*
*DATA: lv_old_address TYPE STRING,
*      lv_new_address TYPE STRING,
*      lv_current_date TYPE D.
*
*lv_current_date = '20240812'.
*
*IF erdat < lv_current_date.
*
*    lv_old_address = '0'.
*ELSE.
*
*    SELECT SINGLE * INTO lv_new_address
*    FROM ADRC
*    WHERE KUNNR = lv_kunnr
*    AND KUNAG = lv_kunag.
























