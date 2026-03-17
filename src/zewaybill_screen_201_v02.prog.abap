*&---------------------------------------------------------------------*
*&  Include           ZEWAYBILL_SCREEN_201_V02
*&---------------------------------------------------------------------*
MODULE user_command_0201 INPUT.

  CASE sy-ucomm.
    WHEN '&EXTNCAN'.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN '&EXTEND'.
      CLEAR ls_final.
      LOOP AT lt_final ASSIGNING <ls_final> WHERE selection = 'X'.
*        BREAK primus.
        PERFORM extend_ewaybill_validity.
      ENDLOOP.
      SET SCREEN '0'.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.

FORM extend_ewaybill_validity.
CLEAR: gs_extend_json,it_json,lt_json_output,ls_json_output.
  gs_extend_json-ewbno             =  zewayextend-eway_bill.
  gs_extend_json-vehicleno         =  zewayextend-vehical_no.
  gs_extend_json-fromplace         =  zewayextend-fromplace.
  gs_extend_json-fromstate         =  zewayextend-fromstatecode.
  gs_extend_json-remainingdistance =  zewayextend-remaindistance.
  gs_extend_json-transdocno        =  zewayextend-transdoc.
*  gs_extend_json-transdocdate      =  zewayextend-transdocdate.
*  gs_extend_json-transmode         =  zewayextend-trns_md.

  IF zewayextend-transdocdate IS NOT INITIAL.
    CONCATENATE zewayextend-transdocdate+6(2) '/'
     zewayextend-transdocdate+4(2) '/' zewayextend-transdocdate+0(4)
     INTO gs_extend_json-transdocdate.
  ENDIF.
  CASE zewayextend-trns_md.
      WHEN 'ROAD'.
        gs_extend_json-transmode         = '1' .
      WHEN 'RAIL'.
        gs_extend_json-transmode        = '2' .
      WHEN 'AIR'.
        gs_extend_json-transmode        = '3' .
      WHEN 'SHIP'.
        gs_extend_json-transmode        = '4' .
      WHEN OTHERS.
*        ls_final_eway-transmode         = 'null' .
        gs_extend_json-transmode        = '1' .
    ENDCASE.
  gs_extend_json-extnrsncode       =  zewayextend-extnrsncode.
  gs_extend_json-extnremarks       =  zewayextend-extnremarks.
  gs_extend_json-frompincode       =  zewayextend-frompincode.
  gs_extend_json-consignmentstatus =  zewayextend-consignmentstatus.
  gs_extend_json-transittype       =  zewayextend-transittype.
  gs_extend_json-addressline1      =  zewayextend-addressline1.
  gs_extend_json-addressline2      =  zewayextend-addressline2.
  gs_extend_json-addressline3      =  zewayextend-addressline3.


  """Write code for json conversion and rfc calling """"""""""""""
*  CLEAR :lv_trex_json.
  DATA : lv_trex_json TYPE string.

  CALL FUNCTION 'ZEWAY_BILL_JSON'
    EXPORTING
      data      = gs_extend_json
    IMPORTING
      trex_json = lv_trex_json.

  REFRESH it_json.

  IF sy-subrc IS INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.



  DATA : cnt TYPE i VALUE 0.

  CLEAR :  cnt.


  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<ls_json>).
    cnt = cnt + 1.
    <ls_json>-tabix = cnt.
  ENDLOOP.



  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).

    CASE <lfs_json_main>-tabix.
      WHEN '1'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'ewbno'  IN <lfs_json_main> WITH '"ewbNo"'.
      WHEN '2'.
        REPLACE 'vehicleno'  IN <lfs_json_main> WITH '"vehicleNo"'.
      WHEN '3'.
        REPLACE 'fromplace'  IN <lfs_json_main> WITH '"fromPlace"'.
      WHEN '4'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'fromstate'  IN <lfs_json_main> WITH '"fromState"'.
      WHEN '5'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'remainingdistance'  IN <lfs_json_main> WITH '"remainingDistance"'.
      WHEN '6'.
        REPLACE 'transdocno'  IN <lfs_json_main> WITH '"transDocNo"'.
      WHEN '7'.
        REPLACE 'transdocdate'  IN <lfs_json_main> WITH '"transDocDate"'.
      WHEN '8'.
        REPLACE 'transmode'  IN <lfs_json_main> WITH '"transMode"'.
      WHEN '9'.
        REPLACE ALL OCCURRENCES OF '"' IN <lfs_json_main> WITH space.
        REPLACE 'extnrsncode'  IN <lfs_json_main> WITH '"extnRsnCode"'.
      WHEN '10'.
        REPLACE 'extnremarks'  IN <lfs_json_main> WITH '"extnRemarks"'.
      WHEN '11'.
        REPLACE 'frompincode'  IN <lfs_json_main> WITH '"fromPincode"'.
      WHEN '12'.
        REPLACE 'consignmentstatus'  IN <lfs_json_main> WITH '"consignmentStatus"'.
      WHEN '13'.
        REPLACE 'transittype'  IN <lfs_json_main> WITH '"transitType"'.
      WHEN '14'.
        REPLACE 'addressline1'  IN <lfs_json_main> WITH '"addressLine1"'.
      WHEN '15'.
        REPLACE 'addressline2'  IN <lfs_json_main> WITH '"addressLine2"'.
      WHEN '16'.
        REPLACE 'addressline3'  IN <lfs_json_main> WITH '"addressLine3"'.

    ENDCASE.


  ENDLOOP.
PERFORM auth.
  CLEAR : ls_str.

  LOOP AT it_json INTO ls_json.

    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.
    CLEAR :  ls_json , ls_json_output.

  ENDLOOP.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = 'C:/desktop/EXtend.json'
    CHANGING
      data_tab = lt_json_output "lv_json "
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc EQ 0.

    MESSAGE 'Eway Bill Downloaded in Json Format on C:/desktop/'
               TYPE 'I'.
  ENDIF.

  CONDENSE ls_str NO-GAPS.

clear : gv_ewaybill_no,gv_updated_date,gv_valid_upto,gv_status,gv_mesg.

CONCATENATE '{"action": "EXTENDVALIDITY", "data":' ls_str '}' INTO lS_STR.
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

*xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180607093257:27GSPMH2101G1Z2'."DEV
xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'. """" PRD
*xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:05AAACG5222D1ZA'.



DATA lv_url TYPE string.

*lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."DEV
* lv_url = 'https://gsthero.com/ewb/enc/v1.03/ewayapi'.  """"PRD
lv_url = 'https://qa.gsthero.com/ewb/enc/v1.03/ewayapi'.

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
   value = 'EXTENDVALIDITY' ) .


  lo_http_client->request->set_header_field(            "
   EXPORTING
   name =  'gstin'
*   value = '27AACCD2898L1Z4' ).
   value = '05AAACG5222D1ZA' )."DEV


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
CLEAR:ls_response,lt_response,ls_res,lt_res,lv_resp_status.
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

IF lv_resp_status = '1'.

  SELECT SINGLE MAX( version ) FROM zewayextend
    INTO @DATA(lv_version)
    WHERE eway_bill = @gs_extend_json-ewbno.
  IF sy-subrc = 0.
    lv_version = lv_version + 1.
  ELSE.
    lv_version = '1'.
  ENDIF.

  zewayextend-version     = lv_version.
  zewayextend-extndate    = sy-datum.
  zewayextend-extntime    = sy-uzeit.
  zewayextend-extnuser    = sy-uname.
  CLEAR ls_res.
    LOOP AT lt_res INTO ls_res..
      IF ls_res-header CS 'validUpto'.
          IF ls_res-value NE 'null'.


          lv_ewaybill_dt = ls_res-value+0(10).
          CONCATENATE lv_ewaybill_dt+6(4) lv_ewaybill_dt+3(2) lv_ewaybill_dt+0(2) INTO lv_ewaybill_dt.

          lv_ewaybill_tm = ls_res-value+11(11).
          CONCATENATE lv_ewaybill_tm+0(2) lv_ewaybill_tm+3(2) lv_ewaybill_tm+6(2) INTO lv_ewaybill_time.

          MOVE lv_ewaybill_time TO lv_vdtotime.
          IF lv_ewaybill_tm+9(2) = 'PM'.
            CALL FUNCTION 'HRVE_CONVERT_TIME'
              EXPORTING
                type_time       = 'B'
                input_time      = lv_vdtotime
                input_am_pm     = 'PM'
              IMPORTING
                output_time     = lv_vdtotime
              EXCEPTIONS
                parameter_error = 1
                OTHERS          = 2.
            IF sy-subrc <> 0.
*              * Implement suitable error handling here
            ENDIF.

          ENDIF.

          MOVE lv_vdtotime TO zewayextend-VALIDUPTOTIME.
          MOVE lv_ewaybill_dt	TO zewayextend-VALIDUPTODATE.
        ENDIF.
       ENDIF.

  ENDLOOP.


 IF zewayextend IS NOT INITIAL.
    MESSAGE 'Eway Bill Sucessfully Extended' TYPE 'I'.
    <ls_final>-message     = 'Eway Bill Sucessfully Extended'.
    modify zewayextend FROM zewayextend.
 ENDIF.


  ELSE.
    CLEAR ls_res.
      READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.

        IF sy-subrc = 0.
           MESSAGE ls_res-value TYPE 'I'.
           <ls_final>-message     = ls_res-value ."'Eway Bill not Updated'.
         ELSE.
           MESSAGE 'Eway Bill Not Extended' TYPE 'I'.
           <ls_final>-message     = 'Eway Bill Not Extended'.
        ENDIF.


   ENDIF.



ENDFORM.

MODULE status_0201 OUTPUT.
  CLEAR :zewayextend .
  clear : gv_ewaybill_no,gv_updated_date,gv_valid_upto,gv_status,gv_mesg.
  zewayextend-eway_bill = ls_final-eway_bil.


  SELECT SINGLE trns_md trans_doc doc_dt vehical_no FROM zeway_bill
    INTO  ( zewayextend-trns_md, zewayextend-transdoc, zewayextend-transdocdate, zewayextend-vehical_no )
    WHERE  bukrs = ls_final-bukrs
      AND  vbeln = ls_final-vbeln.



ENDMODULE.
