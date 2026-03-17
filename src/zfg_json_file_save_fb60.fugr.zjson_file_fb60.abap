FUNCTION ZJSON_FILE_FB60.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(BELNR) TYPE  BELNR_D
*"     REFERENCE(GJAHR) TYPE  GJAHR OPTIONAL
*"     REFERENCE(FILE_LOC) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(LV_UCOMM) TYPE  SY-UCOMM
*"     REFERENCE(LV_MODE) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     REFERENCE(STATUS) TYPE  STRING
*"  TABLES
*"      LT_RETMSG STRUCTURE  BAPIRET2
*"      LT_JSONFILE STRUCTURE  ZSTR_JSONFILE
*"--------------------------------------------------------------------


IF belnr IS NOT INITIAL." and gjahr is NOT INITIAL.

*BREAK-POINT.
  IF lv_ucomm = '&IRN'.
     CREATE OBJECT go_einvoice_utility.

  PERFORM get_data_all tables  lt_retmsg
                       USING BELNR
                             gjahr
                             lv_mode  .
  PERFORM json_conversion_all TABLES lt_jsonfile USING file_loc belnr lv_mode CHANGING status.



  ELSEIF lv_ucomm = '&CAN'.

   PERFORM get_data_cancel TABLES lt_retmsg
                            USING belnr
                                  gjahr.


    PERFORM json_conversion_cancel TABLES lt_jsonfile USING file_loc belnr CHANGING status.


ENDIF.


  ENDIF.




ENDFUNCTION.
