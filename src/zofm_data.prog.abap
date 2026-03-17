*&---------------------------------------------------------------------*
*& Report ZOFM_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zofm_data.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_rad1 RADIOBUTTON GROUP rb1,
             p_rad2 RADIOBUTTON GROUP rb1,
             p_rad3 RADIOBUTTON GROUP rb1,
             p_rad4 RADIOBUTTON GROUP rb1,
             p_rad5 RADIOBUTTON GROUP rb1,
             p_rad6 RADIOBUTTON GROUP rb1,
             p_rad7 RADIOBUTTON GROUP rb1,
             p_rad8 RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  IF p_rad1 = 'X'.
    SUBMIT zofm_maintain VIA SELECTION-SCREEN AND RETURN.
*    CALL TRANSACTION 'ZOFM_BOOK'.           "Main table of OFM BOOKING
  ELSEIF p_rad2 = 'X'.
    CALL TRANSACTION 'ZSCOPE'.               "Table to maintain scope
  ELSEIF p_rad3 = 'X'.
    CALL TRANSACTION 'ZOFM_REV'.             "Table to maintaim ofm revision no

  ELSEIF p_rad4 = 'X'.
    SUBMIT zofm_booking_report VIA SELECTION-SCREEN AND RETURN.  "OFM TABLE REPORT

  ELSEIF p_rad5 = 'X'.
    CALL TRANSACTION 'ZTARGET'.             "TARGET

  ELSEIF p_rad6 = 'X'.
    SUBMIT ztarget_prog VIA SELECTION-SCREEN AND RETURN..             "OFM BOOKING REPORT

  ELSEIF p_rad7 = 'X'.
    SUBMIT zofm_data_upload VIA SELECTION-SCREEN AND RETURN.     "Upload data to table

  ELSEIF p_rad8 = 'X'.
    SUBMIT ZPENDING_SO_OFM VIA SELECTION-SCREEN AND RETURN.       "Pending sales order ofm


  ENDIF.
