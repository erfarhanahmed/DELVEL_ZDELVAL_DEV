FUNCTION ZJSON_FILE_SAVE_CUST_CR_DB.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(VBELN) TYPE  VBELN OPTIONAL
*"     REFERENCE(GJAHR) TYPE  GJAHR OPTIONAL
*"     REFERENCE(FILE_LOC) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(LV_UCOMM) TYPE  SY-UCOMM
*"     REFERENCE(LV_MODE) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     REFERENCE(STATUS) TYPE  STRING
*"  TABLES
*"      LT_DOCS STRUCTURE  ZSTR_VBELN OPTIONAL
*"      LT_RETMSG STRUCTURE  BAPIRET2
*"      LT_JSONFILE STRUCTURE  ZSTR_JSONFILE
*"----------------------------------------------------------------------


IF vbeln IS NOT INITIAL." and gjahr is NOT INITIAL.

  IF lv_ucomm = '&IRN'.
BREAK primus.
  PERFORM get_data_all tables  lt_retmsg
                       USING vbeln
                             gjahr
                             lv_mode  .
  PERFORM json_conversion_all TABLES lt_jsonfile USING file_loc vbeln lv_mode CHANGING status.


  ELSEIF lv_ucomm = '&CAN'.

   PERFORM get_data_cancel TABLES lt_retmsg
                            USING vbeln
                                  gjahr.


    PERFORM json_conversion_cancel TABLES lt_jsonfile USING file_loc vbeln CHANGING status.



  ENDIF.

  ENDIF.




ENDFUNCTION.
