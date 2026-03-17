*&---------------------------------------------------------------------*
*&  Include           ZEWAYBILL_SCREEN_300
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
*BREAK primus.
  CASE sy-ucomm.
    WHEN '&CAN' OR 'CANCEL'.
      CLEAR zeway_bill.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN '&SUBMIT'.
      CLEAR ls_final.
      LOOP AT lt_final ASSIGNING <ls_final> WHERE selection = 'X'.
        IF <ls_final>-eway_bil IS INITIAL.
          MESSAGE 'Eway bill number is not generated' TYPE 'E'.
*****        ELSEIF <ls_final>-cancel_doc IS INITIAL.
*****          MESSAGE 'Invoice number is not cancel in system' TYPE 'E'.
        ELSE.
          PERFORM get_data_for_cancel.
          PERFORM eway_can_using_api.
        ENDIF.
      ENDLOOP.
      SET SCREEN '0'.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.


FORM eway_can_using_api.

  CLEAR : ls_res, ls_response,ls_eway_number.
  REFRESH : lt_res , lt_response.

  DATA : lt_res_up TYPE STANDARD TABLE OF lty_res,
         ls_res_up TYPE lty_res.

  DATA: lv_string  TYPE string,
        lv_flag(1) TYPE c.


  DATA : ls_vbeln TYPE xblnr.

  DATA : lv_resp_status TYPE string.

  DATA : ls_output TYPE string.


PERFORM auth.



  TYPES : BEGIN OF lty_response,
            line(3000) TYPE c,
          END OF lty_response.


  TYPES : BEGIN OF lty_res,
            header TYPE string,
            value  TYPE string,
          END OF lty_res.

  DATA : lt_res TYPE STANDARD TABLE OF lty_res,
         ls_res TYPE lty_res.





  DATA: lt_response TYPE STANDARD TABLE OF lty_response,
        ls_response TYPE lty_response.


  DATA : ls_zeinv_res TYPE zeinv_res.

*  DATA : ls_vbeln TYPE xblnr."vbeln.

*  DATA : lv_resp_status TYPE string.

*  DATA : ls_output TYPE string.


*DATA : ls_vbeln TYPE vbeln.

*  DATA : lv_resp_status TYPE string.


CONCATENATE '{"action": "CANEWB", "data":' ls_str '}' INTO lS_STR.
REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
CONCATENATE ls_str '}' INTO lS_STR.
CONDENSE ls_str.
  """"""""""""""""""""""""""""""""""""""""""""""' API  CODE """"""""""""""""""""""""""""""
*BREAK primus.
DATA :tokan TYPE string.

CLEAR :tokan.

READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
tokan = ls_ein_tokan-value.
CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

DATA xconn TYPE string.
CLEAR: xconn.

xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180522093257:27GSPMH2101G1Z2'." Dev
*xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'. """""""""" PRD
**xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AAACG5222D1ZA'.

DATA lv_url TYPE string.

*lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'. ""''PRD
lv_url = 'https://qa.gsthero.com/ewb/enc/v1.03/ewayapi'.

  cl_http_client=>create_by_url(
   EXPORTING
   url = lv_url   "'http://logibrickseway.azurewebsites.net/TransactionAPI/CancelEInvoice' "'lv_url
   IMPORTING
   client = DATA(lo_http_client)
   EXCEPTIONS
   argument_not_found = 1
   plugin_not_active = 2
   internal_error = 3
   OTHERS = 4 ).

lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

  lo_http_client->request->set_method(
   EXPORTING
   method = 'POST' ).     "if_http_entity=>co_request_method_post


  lo_http_client->request->set_content_type(
   EXPORTING
   content_type = if_rest_media_type=>gc_appl_json ).



  CALL METHOD lo_http_client->request->set_header_field
    EXPORTING
      name  = 'Content-Type'
      value = 'application/json'.


   lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'Authorization'
   value = tokan ) .

  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'Action'
   value = 'CANEWB' ) .


  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'gstin'
   value = '05AAACG5222D1ZA' ).
*   value = '27AACCD2898L1Z4' ). """""""" PRD

  lo_http_client->request->set_header_field(
    EXPORTING
      name  = 'Accept'
      value = 'application/json' ).

  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'X-Connector-Auth-Token'
   value = xconn ) .

lo_http_client->request->set_method(
   EXPORTING
   method = if_http_entity=>co_request_method_post ).


  lo_http_client->request->set_content_type(
   EXPORTING
   content_type = if_rest_media_type=>gc_appl_json ).


  lo_http_client->request->set_cdata(
   EXPORTING
   data =  ls_str ) .


  lo_http_client->send(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2 ).


  CHECK sy-subrc = 0.
  lo_http_client->receive(
   EXCEPTIONS
   http_communication_failure = 1
   http_invalid_state = 2
   http_processing_failed = 3 ).

*BREAK primus.
  CHECK sy-subrc = 0.
  DATA(lv_response) = lo_http_client->response->get_cdata( ).

*    BREAK abap01.

 REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '"data":' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.


  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 20 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.


*BREAK primus.
READ TABLE lt_res INTO ls_res WITH KEY HEADER = 'status'.                "INDEX 5.
  IF SY-SUBRC EQ 0.
    lv_resp_status = ls_res-value.
    ls_vbeln = <ls_final>-vbeln.

  ENDIF.



*  CONCATENATE '{"CLIENTCODE": "LOGIBRICKS", "USERCODE": "RUPALI", "PASSWORD": "Auto@1996", "cancelledewblist":['   ls_str   ']' '}' INTO ls_str.


  """"""""""""""""""""""""""""""""""""""""""""""' API  CODE """"""""""""""""""""""""""""""

*  DATA : "lv_response TYPE string,
*         lv_url      TYPE string.

SELECT SINGLE * FROM zeway_number INTO ls_eway_num
    WHERE vbeln = <ls_final>-vbeln.  "
  "---update data in z table-------------------------------
IF ls_eway_num IS NOT INITIAL.
  SELECT SINGLE * FROM zeway_number INTO ls_eway_number
    WHERE vbeln = <ls_final>-vbeln.  "            vbeln = ls_vbeln.

  IF sy-subrc EQ 0.
*     LOOP AT lt_res ASSIGNING FIELD-SYMBOL(<f2>).
       IF lv_resp_status = '1'.
            ls_eway_number-zzstatus = 'S'.
            IF <ls_final> IS ASSIGNED.
              <ls_final>-process_status = text-005. "'@F9\Q Eway Bill Cancelled@'.
              <ls_final>-status_description = text-006. "'Eway Bill Cancelled'.
            ENDIF.

        ELSEIF lv_resp_status = '0'.
          ls_eway_number-zzstatus = 'E'.
          IF <ls_final> IS ASSIGNED.
            <ls_final>-process_status = text-009. "'@0A\Q Error!@'.
            <ls_final>-status_description = text-010. "'Error'.
          ENDIF.
       ENDIF.

      IF ls_eway_number-zzstatus = 'S'.
        ls_eway_number-cancelremark = zeway_number-cancelremark.
        ls_eway_number-canreason  = zeway_number-canreason.
        ls_eway_number-canceldt = sy-datum.
        ls_eway_number-message = 'Eway Bill cancelled successfully'.

      IF <ls_final> IS ASSIGNED.
        <ls_final>-cancelremark = zeway_number-cancelremark.
        <ls_final>-canreason  = zeway_number-canreason.
        <ls_final>-canceldt = sy-datum.
        <ls_final>-message = 'Eway Bill cancelled successfully'.
      ENDIF.
    ELSEIF ls_eway_number-zzstatus = 'E'.

**    <ls_final>-message = lv_response.
      ls_eway_number-cancelremark = zeway_number-cancelremark.
      ls_eway_number-canreason  = zeway_number-canreason.
      ls_eway_number-canceldt = sy-datum.
      IF <ls_final> IS ASSIGNED.
     READ TABLE lt_res INTO ls_res WITH KEY HEADER = 'errorMsg'.
      IF sy-subrc = 0.

      ENDIF.
        <ls_final>-cancelremark = zeway_number-cancelremark.
        <ls_final>-canreason  = zeway_number-canreason.
        <ls_final>-canceldt = sy-datum.
        <ls_final>-message = ls_res-value.
*        <ls_final>-message = 'Validity period lapsed, you cannot cancel this eway bill!'.
      ENDIF.
    ENDIF.




    IF ls_eway_number IS NOT INITIAL.
      MODIFY zeway_number FROM ls_eway_number.
      COMMIT WORK.
    ENDIF.
*        ENDLOOP .
  ENDIF .

ELSE.
  SELECT SINGLE * FROM zeway_res_122  INTO ls_zeway_res_122
    WHERE belnr = <ls_final>-vbeln AND gjahr = <ls_final>-gjahr.  "            vbeln = ls_vbeln.

  IF sy-subrc EQ 0.
*     LOOP AT lt_res ASSIGNING FIELD-SYMBOL(<f2>).
       IF lv_resp_status = '1'.
            ls_zeway_res_122-zzstatus = 'S'.
            IF <ls_final> IS ASSIGNED.
              <ls_final>-process_status = text-005. "'@F9\Q Eway Bill Cancelled@'.
              <ls_final>-status_description = text-006. "'Eway Bill Cancelled'.
            ENDIF.

        ELSEIF lv_resp_status = '0'.
          ls_zeway_res_122-zzstatus = 'E'.
          IF <ls_final> IS ASSIGNED.
            <ls_final>-process_status = text-009. "'@0A\Q Error!@'.
            <ls_final>-status_description = text-010. "'Error'.
          ENDIF.
       ENDIF.

      IF ls_zeway_res_122-zzstatus = 'S'.
        ls_zeway_res_122-cancelremark = zeway_number-cancelremark.
        ls_zeway_res_122-canreason  = zeway_number-canreason.
        ls_zeway_res_122-canceldt = sy-datum.
        ls_zeway_res_122-message = 'Eway Bill cancelled successfully'.

      IF <ls_final> IS ASSIGNED.
        <ls_final>-cancelremark = ls_zeway_res_122-cancelremark.
        <ls_final>-canreason  = ls_zeway_res_122-canreason.
        <ls_final>-canceldt = sy-datum.
        <ls_final>-message = 'Eway Bill cancelled successfully'.
      ENDIF.
    ELSEIF ls_eway_number-zzstatus = 'E'.

**    <ls_final>-message = lv_response.
      ls_zeway_res_122-cancelremark = zeway_number-cancelremark.
      ls_zeway_res_122-canreason  = zeway_number-canreason.
      ls_zeway_res_122-canceldt = sy-datum.
      IF <ls_final> IS ASSIGNED.
     READ TABLE lt_res INTO ls_res WITH KEY HEADER = 'errorMsg'.
      IF sy-subrc = 0.

      ENDIF.
        <ls_final>-cancelremark = zeway_number-cancelremark.
        <ls_final>-canreason  = zeway_number-canreason.
        <ls_final>-canceldt = sy-datum.
        <ls_final>-message = ls_res-value.
*        <ls_final>-message = 'Validity period lapsed, you cannot cancel this eway bill!'.
      ENDIF.
    ENDIF.




    IF ls_zeway_res_122 IS NOT INITIAL.
      MODIFY zeway_res_122 FROM ls_zeway_res_122." WHERE belnr = <ls_final>-vbeln ."AND gjahr = <ls_final>-gjahr.
      COMMIT WORK.
    ENDIF.
*        ENDLOOP .
  ENDIF .

ENDIF.
*    IF gv_ewaybill_no IS NOT INITIAL.
*      IF <ls_final> IS ASSIGNED.
*       <ls_final>-process_status = text-005. "'@F9\Q Eway Bill Cancelled@'.
*       <ls_final>-status_description = text-006. "'Eway Bill Cancelled'.
*       ls_eway_number-cancelremark = zeway_number-cancelremark.
*       ls_eway_number-canreason  = zeway_number-canreason.
*       ls_eway_number-canceldt = sy-datum.
*       ls_eway_number-zzstatus = 'S'.
*       ls_eway_number-message = 'Eway Bill cancelled successfully'.
*      endif.
*
*   else.
*     IF <ls_final> IS ASSIGNED.
*      <ls_final>-process_status = text-009. "'@0A\Q Error!@'.
*        <ls_final>-status_description = text-010. "'Error'.
*     endif.
*        ls_eway_number-message = gv_mesg.
*    ENDIF.






*  ELSE.
*
**    MESSAGE 'Error Generating Cancel Eway through API' TYPE 'E'.
*    MESSAGE gv_mesg TYPE 'E'.
*    EXIT.
*  ENDIF.
*  ENDIF.

  CLEAR: lt_res,ls_res,ls_eway_number,lt_response,ls_response,lv_response,ls_zeway_res_122,ls_eway_num.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_FOR_CANCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_FINAL_VBELN  text
*----------------------------------------------------------------------*
FORM get_data_for_cancel.

  REFRESH : it_json , lt_json_output .
  CLEAR : ls_json, ls_json_output,p_lines,count,lv_json.

  DATA : lv_trex_json TYPE string.

  ls_final_cancel-ewbno = <ls_final>-eway_bil.
  ls_final_cancel-cancelledreason = zeway_number-canreason.
  ls_final_cancel-cancelledremarks = zeway_number-cancelremark.


  CALL FUNCTION 'ZEWAY_BILL_JSON'
    EXPORTING
      data      = ls_final_cancel
    IMPORTING
      trex_json = lv_trex_json.

  IF sy-subrc IS INITIAL.
*    SPLIT lv_trex_json AT ':' INTO TABLE lt_json_string .
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.





  READ TABLE it_json ASSIGNING FIELD-SYMBOL(<lfs_json>) INDEX 1.
  IF sy-subrc EQ 0 .
    REPLACE ALL OCCURRENCES OF '[' IN <lfs_json> WITH ''.
  ENDIF.

  DATA : lv_srno TYPE string VALUE 'slno'.
  DATA : cnt TYPE i VALUE 200.
  DATA : lv_flag(01) TYPE c.


  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).
    CASE sy-tabix.
      WHEN 1.
        REPLACE 'ewbno' IN <lfs_json_main> WITH '"EwbNo"'.
      WHEN 2.
        REPLACE 'cancelledreason' IN <lfs_json_main> WITH '"cancelRsnCode"'.
      WHEN 3.
        REPLACE 'cancelledremarks' IN <lfs_json_main> WITH '"cancelRmrk"'.

      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.


  CLEAR ls_str.


  LOOP AT it_json INTO ls_json.
    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.
    count = count + 1.
    CLEAR :  ls_json , ls_json_output.
  ENDLOOP.
  CLEAR : ls_final_cancel.

ENDFORM.
