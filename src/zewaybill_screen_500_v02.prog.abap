*&---------------------------------------------------------------------*
*&  Include           ZEWAYBILL_SCREEN_500
*&---------------------------------------------------------------------*
MODULE status_0500 OUTPUT.

  IF zeway_bill-trns_md IS INITIAL.
    zeway_bill-trns_md = 'ROAD'.
  ENDIF.

ENDMODULE.

MODULE user_command_0500 INPUT.
  DATA flag(1) TYPE c.
  CASE sy-ucomm.
    WHEN '@SUBMIT'.

      IF zeway_bill-vehical_no IS NOT INITIAL.
        ls_consd_json-vehicleno  = zeway_bill-vehical_no.
      ELSE.
        ls_consd_json-vehicleno  = 'null'.
      ENDIF.

      IF zeway_bill-trans_doc IS NOT INITIAL.
      ls_consd_json-transdocno  = zeway_bill-trans_doc.
      ELSE.
      ls_consd_json-transdocno  = 'null'.
      ENDIF.

      IF zeway_bill-doc_dt IS NOT INITIAL.
         ls_consd_json-transdocdate  = zeway_bill-doc_dt.
      CONCATENATE ls_consd_json-transdocdate+6(2) '/' ls_consd_json-transdocdate+4(2)
       '/' ls_consd_json-transdocdate+0(4) INTO ls_consd_json-transdocdate.
      ELSE.
        ls_consd_json-transdocdate  = 'null'.
      ENDIF.

      CASE zeway_bill-trns_md.
        WHEN 'ROAD'.
          ls_consd_json-transmode         = '1' .
        WHEN 'RAIL'.
          ls_consd_json-transmode         = '2' .
        WHEN 'AIR'.
          ls_consd_json-transmode         = '3' .
        WHEN 'SHIP'.
          ls_consd_json-transmode         = '4' .
        WHEN OTHERS.
          ls_consd_json-transmode         = '""' .
***          ls_consd_json-transmode         = 'null' .
      ENDCASE.
      CLEAR : flag,ls_ewaybill_list.
      Refresh lt_ewaybill_list.
      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        ls_ewaybill_list-ewbno = ls_final-eway_bil.
        APPEND ls_ewaybill_list TO lt_ewaybill_list.
        IF flag IS INITIAL.
          SELECT SINGLE werks FROM vbrp INTO @DATA(lv_werks) WHERE vbeln = @ls_final-vbeln.
          SELECT SINGLE adrnr FROM t001w INTO @DATA(lv_adrnr) WHERE werks = @lv_werks.
          SELECT SINGLE city1,region FROM adrc INTO @DATA(ls_from_city) WHERE addrnumber = @lv_adrnr.
          SELECT SINGLE zstcode FROM zstate_code INTO @DATA(lv_state_code) WHERE zsapcode = @ls_from_city-region.
          IF sy-subrc = 0.
            flag = 'X'.
          ENDIF.
        ENDIF.
      ENDLOOP.
*      ls_consd_json-fromplace = ls_from_city-city1.
*      ls_consd_json-fromstate = lv_state_code.

      ls_consd_json-tripsheetewbbills = lt_ewaybill_list.
      PERFORM get_json.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN '&CANCEL'.
      CLEAR zeway_bill.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

FORM get_json.
  DATA : lv_trex_json TYPE string.
  CALL FUNCTION 'ZEWAY_BILL_JSON'
    EXPORTING
      data      = ls_consd_json
    IMPORTING
      trex_json = lv_trex_json.

  IF sy-subrc IS INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.

  DATA : lv_srno TYPE string VALUE 'ewbno'.
  DATA : lv_tax TYPE string VALUE 'fromplace'.
  DATA : cnt TYPE i VALUE 45.
  DATA : cnt_tax TYPE i VALUE 0.
  DATA : lv_flag(01) TYPE c.

  LOOP AT it_json INTO ls_json.
    IF ls_json-line CS lv_tax.
      cnt_tax = 0.
      ls_json-tabix = cnt_tax.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_srno.
      cnt_tax = cnt_tax + 1.
      ls_json-tabix = cnt_tax.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.
    CLEAR ls_json.
  ENDLOOP.

  CLEAR :  sy-tabix , lv_flag .


  LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
    IF ls_json-line CS lv_srno.
      cnt = 6.
      ls_json-tabix = cnt.
      lv_flag = 'X'.
    ENDIF.
    IF lv_flag  = 'X' AND ls_json-line NS lv_tax.
      cnt = cnt + 1.
      ls_json-tabix = cnt.
    ELSE.
      CLEAR lv_flag.
    ENDIF.

    MODIFY it_json FROM ls_json TRANSPORTING tabix.

  ENDLOOP.


  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).

    CASE <lfs_json_main>-tabix.
      WHEN '1'.
        REPLACE 'fromplace'  IN <lfs_json_main> WITH '"fromPlace"'.
      WHEN '2'.
        REPLACE 'fromstate'  IN <lfs_json_main> WITH '"fromState"'.
      WHEN '3'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ' '.
        ENDIF.
        REPLACE 'vehicleno'  IN <lfs_json_main> WITH '"vehicleNo"'.
      WHEN '4'.
        REPLACE 'transmode'  IN <lfs_json_main> WITH '"transMode"'.
      WHEN '5'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ' '.
        ENDIF.
        REPLACE 'transdocno'  IN <lfs_json_main> WITH '"transDocNo"'.
      WHEN '6'.
        IF <lfs_json_main> CS 'null'.
          REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH ' '.
        ENDIF.
        REPLACE 'transdocdate'  IN <lfs_json_main> WITH '"transDocDate"'.
      WHEN '7'.
        REPLACE 'tripsheetewbbills'  IN <lfs_json_main> WITH '"tripSheetEwbBills"'.
        REPLACE 'ewbno'  IN <lfs_json_main> WITH '"ewbNo"'.
      WHEN '8'.
        REPLACE 'ewbno'  IN <lfs_json_main> WITH '"ewbNo"'.
    ENDCASE.

  ENDLOOP.


PERFORM auth.
CLEAR: ls_str,lt_json_output.
  LOOP AT it_json INTO ls_json.
    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.
    CLEAR : ls_json_output, ls_json.
  ENDLOOP.

CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = 'C:/desktop/cons.json'
    CHANGING
      data_tab = lt_json_output "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
               TYPE 'I'.
  ENDIF.

  CLEAR : ls_res, ls_response,ls_eway_number.
  REFRESH : lt_res , lt_response.

  DATA : lt_res_up TYPE STANDARD TABLE OF lty_res,
         ls_res_up TYPE lty_res.



*  CONCATENATE '{"CLIENTCODE": "LOGIBRICKS", "USERCODE": "RUPALI", "PASSWORD": "Auto@1996", "vehicleupdatelist":['   ls_str   ']' '}' INTO ls_str.



  DATA : "lv_response TYPE string,
         lv_url      TYPE string.
CONCATENATE '{"action": "GENCEWB", "data":' ls_str '}' INTO lS_STR.
REPLACE ALL OCCURRENCES OF '"data":}' IN ls_str WITH '"data":'.
CONCATENATE ls_str '}' INTO lS_STR.
*REPLACE ALL OCCURRENCES OF  '"Irn": "",' IN lS_STR WITH ' '.
CONDENSE ls_str.


""""""""""""""""""""""""""""""""""""""""""""""' API Einvoce CODE """"""""""""""""""""""""""""""

DATA :tokan TYPE string.

CLEAR :tokan.

READ TABLE lt_ein_tokan INTO ls_ein_tokan INDEX 1 .
tokan = ls_ein_tokan-value.
CONCATENATE 'Bearer' tokan INTO tokan SEPARATED BY space.

DATA xconn TYPE string.
CLEAR: xconn.

*xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180522093257:27GSPMH2101G1Z2'. "DEV
xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.





*lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."DEV
lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'.

  cl_http_client=>create_by_url(
   EXPORTING
   url = lv_url
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
   value = 'GENCEWB' ) .


  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'gstin'
   value = '27AACCD2898L1Z4' ).
*   value = '05AAACG5222D1ZA' )."DEV


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


  REPLACE ALL OCCURRENCES OF '{"data":{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{"error":[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '[{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}]' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '{' IN lv_response WITH ' '.
  REPLACE ALL OCCURRENCES OF '}' IN lv_response WITH ' '.
  SPLIT lv_response AT ',' INTO TABLE lt_response.

  LOOP AT  lt_response INTO ls_response.
    REPLACE ALL OCCURRENCES OF '"' IN ls_response WITH ' '.
    SPLIT ls_response AT ':' INTO ls_res-header ls_res-value.

    IF sy-tabix LE 1000 .
      APPEND ls_res TO lt_res.
      CLEAR ls_res.
    ENDIF.

  ENDLOOP.

  READ TABLE lt_res INTO ls_res WITH KEY HEADER = 'status'.                "INDEX 5.
  IF SY-SUBRC EQ 0.
    lv_resp_status = ls_res-value.
  ENDIF.

IF lv_resp_status = 1.
  LOOP AT lt_res INTO ls_res.


      IF ls_res-header = 'cEwbNo'.
        lv_cewaybill = ls_res-value.
      ENDIF.

      IF ls_res-header = 'cEwbDate'.
        lv_cewaybill_dt = ls_res-value+0(10).
        CONCATENATE lv_cewaybill_dt+6(4) lv_cewaybill_dt+3(2) lv_cewaybill_dt+0(2) INTO lv_cewaybill_dt.

        lv_cewaybill_tm = ls_res-value+11(11).
        CONCATENATE lv_cewaybill_tm+0(2) lv_cewaybill_tm+3(2) lv_cewaybill_tm+6(2) INTO lv_cewaybill_time.
        CLEAR lv_vdfmtime.
        MOVE lv_cewaybill_time TO lv_vdfmtime.
        IF lv_cewaybill_tm+9(2) = 'PM'.
          CALL FUNCTION 'HRVE_CONVERT_TIME'
            EXPORTING
              type_time       = 'B'
              input_time      = lv_vdfmtime
              input_am_pm     = 'PM'
            IMPORTING
              output_time     = lv_vdfmtime
            EXCEPTIONS
              parameter_error = 1
              OTHERS          = 2.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
        ENDIF.
      ENDIF.

      IF gv_mesg IS NOT INITIAL.
        DATA(lv_message) = gv_mesg.
      ENDIF.
 ENDLOOP.
ENDIF.
  IF lv_cewaybill IS NOT INITIAL .
    LOOP AT lt_final ASSIGNING <ls_final> WHERE selection = 'X'.
      ls_zceb-vbeln         = <ls_final>-vbeln.
      ls_zceb-eway_bill     = <ls_final>-eway_bil.
      ls_zceb-conewayno     = lv_cewaybill.
      ls_zceb-cewaybilldate = lv_cewaybill_dt.
      ls_zceb-cewaybilltime = lv_vdfmtime.
      ls_zceb-vehical_no    = ls_consd_json-vehicleno.
      ls_zceb-trans_doc     = ls_consd_json-transdocno.
      CONCATENATE ls_consd_json-transdocdate+6(4)
                  ls_consd_json-transdocdate+3(2)
                  ls_consd_json-transdocdate+0(2)
             INTO ls_zceb-doc_dt.
      ls_zceb-fromplace     = ls_consd_json-fromplace.
      ls_zceb-fromstate     = ls_consd_json-fromstate.
      ls_zceb-trns_md       = zeway_bill-trns_md.


      APPEND ls_zceb TO lt_zceb.
      <ls_final>-message = 'CEWB Generated successfully'.
      <ls_final>-conway_bil = lv_cewaybill.
      <ls_final>-veh_no = ls_zceb-vehical_no.
    ENDLOOP.

DATA : gv_eway    TYPE zeway_number,
       gv_eway122 TYPE ZEWAY_RES_122.

CLEAR :gv_eway ,gv_eway122.

    IF lt_zceb IS NOT INITIAL.
      MODIFY zceb FROM TABLE lt_zceb.
      LOOP AT lt_final ASSIGNING <ls_final> WHERE selection = 'X'.
      SELECT SINGLE * FROM zeway_number INTO gv_eway  WHERE vbeln = <ls_final>-vbeln.
        IF sy-subrc = 0.
             UPDATE zeway_number SET conewayno = lv_cewaybill
                                  message = <ls_final>-message
                            WHERE vbeln = <ls_final>-vbeln.
      ENDIF.
      SELECT SINGLE * FROM ZEWAY_RES_122 INTO gv_eway122 WHERE belnr = <ls_final>-vbeln.
       IF sy-subrc = 0.
          UPDATE ZEWAY_RES_122 SET conewayno = lv_cewaybill
                                  message = <ls_final>-message
                            WHERE belnr = <ls_final>-vbeln.
       ENDIF.
        UPDATE zeway_bill SET vehical_no = <ls_final>-veh_no
                          WHERE vbeln    = <ls_final>-vbeln.
        COMMIT WORK.
      Endloop.
    ENDIF.

    ELSE.
      LOOP AT lt_final ASSIGNING <ls_final> WHERE selection = 'X'.
        <ls_final>-message = 'CEWB not Generated successfully'.
        <ls_final>-process_status = TEXT-009. "'@0A\Q Error!@'.
        <ls_final>-status_description = TEXT-010. "'Error'.
        UPDATE zeway_number SET message = <ls_final>-message
                               zzstatus = 'E'
                          WHERE vbeln   = <ls_final>-vbeln.
        COMMIT WORK.
      Endloop.

  ENDIF.

ENDFORM.
