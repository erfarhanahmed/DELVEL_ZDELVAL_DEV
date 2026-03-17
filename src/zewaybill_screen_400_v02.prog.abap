*&---------------------------------------------------------------------*
*&  Include           ZEWAYBILL_SCREEN_400
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  IF zeway_bill-trns_md IS INITIAL.
    zeway_bill-trns_md = 'ROAD'.
  ENDIF.
  IF zeway_bill-vehical_type IS INITIAL.
    zeway_bill-vehical_type = 'REGULAR'.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.
  CASE sy-ucomm.
    WHEN '&CANCEL'.
      CLEAR : zeway_bill-reason ,zeway_bill-reasoncode.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN '&UPDATE'.
      CLEAR ls_final.
*      BREAK primus.
      LOOP AT lt_final ASSIGNING <ls_final> WHERE selection = 'X'.
        PERFORM update_vehical_number.
      ENDLOOP.
      SET SCREEN '0'.
      LEAVE SCREEN.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  REQUIRE_FIELD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE require_field INPUT.

  IF zeway_bill-reasoncode = '3'.
    IF zeway_bill-reason IS INITIAL.
      MESSAGE e010(zeway).
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INPUT_HELP_STATE_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE input_help_state_code INPUT.

  DATA: ls_state_ret TYPE ddshretval,
        lt_state_ret TYPE TABLE OF ddshretval.



*  SELECT STD_STATE_CODE,LEGAL_STATE_CODE FROM zstate_code INTO TABLE @DATA(lt_state).
  SELECT STD_STATE_CODE,LEGAL_STATE_CODE FROM J_1ISTATECDM INTO TABLE @DATA(lt_state).
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'LEGAL_STATE_CODE' "internal table field
      dynpprog        = 'Z_EWAYBILL_GENERATION' "program name
      dynpnr          = '0400' "screen number
      dynprofield     = 'ZEWAY_BILL-FROMSTATECODE' "screen field name
      value_org       = 'S'
    TABLES
      value_tab       = lt_state "internal table
      return_tab      = lt_state_ret
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    READ TABLE lt_state_ret INTO ls_state_ret INDEX 1.
    IF sy-subrc = 0.
      zeway_bill-fromstatecode = ls_state_ret-fieldval.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_VEHICAL_NUMBER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update_vehical_number .

  REFRESH : it_json , lt_json_output ,lt_res.
  CLEAR : ls_json, ls_json_output,p_lines,count,lv_json.

  DATA : lv_trex_json TYPE string.

  SELECT SINGLE * FROM zeway_bill INTO @DATA(ls_eway_bill) WHERE vbeln = @<ls_final>-vbeln.
  "Pass <ls_final>-vbeln to zeway_bill get remaining fields except vehical no and other fields which is coming from input scree 400
  "and pass to ls_vehicle_upade.

  ls_vehicle_update-ewbno       = <ls_final>-eway_bil.
  ls_vehicle_update-vehicleno   = zeway_bill-vehical_no.
  ls_vehicle_update-fromplace   = zeway_bill-fromplace.
  ls_vehicle_update-fromstate   = zeway_bill-fromstatecode.
  ls_vehicle_update-reasoncode  = zeway_bill-reasoncode.
  ls_vehicle_update-vehicletype = 'R'.  "zeway_bill-vehical_type.
  ls_vehicle_update-transdocno =  zeway_bill-trans_doc.
  IF zeway_bill-doc_dt IS NOT INITIAL.
    CONCATENATE zeway_bill-doc_dt+6(2) '/' zeway_bill-doc_dt+4(2) '/' zeway_bill-doc_dt+0(4) INTO ls_vehicle_update-transdocdate.
  ENDIF.



  CASE zeway_bill-trns_md.
    WHEN 'ROAD'.
      ls_vehicle_update-transmode         = '1' .
    WHEN 'RAIL'.
      ls_vehicle_update-transmode         = '2' .
    WHEN 'AIR'.
      ls_vehicle_update-transmode         = '3' .
    WHEN 'SHIP'.
      ls_vehicle_update-transmode         = '4' .
    WHEN OTHERS.
      ls_vehicle_update-transmode         = 'null' .
  ENDCASE.


  CASE ls_vehicle_update-reasoncode.
    WHEN '1'.
      ls_vehicle_update-reasonrem = 'Due to Break Down'.
    WHEN '2'.
      ls_vehicle_update-reasonrem = 'Due to Transshipment'.
    WHEN '3'.
      ls_vehicle_update-reasonrem =  zeway_bill-reason.
  ENDCASE.

      IF ls_vehicle_update-reasonrem IS INITIAL.
         ls_vehicle_update-reasonrem = 'null'.
      ENDIF.

*****  ls_vehicle_update-transdocno  = ls_eway_bill-trans_doc.
*****  CONCATENATE <ls_final>-eway_dt+6(2) '/' <ls_final>-eway_dt+4(2) '/' <ls_final>-eway_dt+2(4) INTO ls_vehicle_update-transdocdate.
*****  ls_vehicle_update-transmode   = ls_eway_bill-trns_md.
*****  ls_vehicle_update-vehicletype = ls_eway_bill-vehical_type.

  IF ls_vehicle_update IS NOT INITIAL.

    CALL FUNCTION 'ZEWAY_BILL_JSON'
      EXPORTING
        data      = ls_vehicle_update
      IMPORTING
        trex_json = lv_trex_json.
  ENDIF.

  IF sy-subrc IS INITIAL.
*    SPLIT lv_trex_json AT ':' INTO TABLE lt_json_string .
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.

  READ TABLE it_json ASSIGNING FIELD-SYMBOL(<lfs_json>) INDEX 1.
  IF sy-subrc EQ 0 .
    REPLACE ALL OCCURRENCES OF '[' IN <lfs_json> WITH ''.
  ENDIF.


  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).
    CASE sy-tabix.
      WHEN 1.
        REPLACE 'ewbno' IN <lfs_json_main> WITH '"ewbNo"'.
      WHEN 2.
        REPLACE 'vehicleno' IN <lfs_json_main> WITH '"vehicleNo"'.
      WHEN 3.
        REPLACE 'fromplace' IN <lfs_json_main> WITH '"fromPlace"'.
      WHEN 4.
        REPLACE 'fromstate' IN <lfs_json_main> WITH '"fromState"'.
      WHEN 5.
        REPLACE 'reasoncode' IN <lfs_json_main> WITH '"reasonCode"'.
      WHEN 6.
        REPLACE 'reasonrem' IN <lfs_json_main> WITH '"reasonRem"'.
      WHEN 7.
        REPLACE 'transdocno' IN <lfs_json_main> WITH '"transDocNo"'.
      WHEN 8.
        REPLACE 'transdocdate' IN <lfs_json_main> WITH '"transDocDate"'.
      WHEN 9.
        REPLACE 'transmode' IN <lfs_json_main> WITH '"transMode"'.
      WHEN 10.
        REPLACE 'vehicletype' IN <lfs_json_main> WITH '"vehicleType"'.
      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.


PERFORM auth.
*BREAK primus.
  CLEAR: ls_str,lt_json_output.
  LOOP AT it_json INTO ls_json.
    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.
    CLEAR : ls_json_output, ls_json.
  ENDLOOP.

CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename = 'C:/desktop/update.json'
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
CONCATENATE '{"action": "VEHEWB", "data":' ls_str '}' INTO lS_STR.
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

xconn = 'l7xxba7aa16e968646b992298b377e955e7c:20180522093257:27GSPMH2101G1Z2'."Dev
*xconn = '487ac80a07f6039c129fe7c27b12cbcf:20180519134451:27AACCD2898L1Z4'.



*DATA lv_url TYPE string.

*lv_url = 'http://35.154.208.8:8080/ewb/enc/v1.03/ewayapi'."Dev
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
   value = 'VEHEWB' ) .


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

*IF gv_mesg IS INITIAL.
*
*
IF lv_resp_status = 1.


  DATA : ls_eway_bill_vehicle_update TYPE zeway_bill.
*
  SELECT * FROM zeway_bill INTO TABLE @DATA(lt_eway_bill_temp)
     WHERE vbeln = @<ls_final>-vbeln.  "            vbeln = ls_vbeln
  IF sy-subrc = 0 .
    SORT lt_eway_bill_temp BY version DESCENDING.
    READ TABLE lt_eway_bill_temp INTO data(ls_eway_bill_temp) INDEX 1.
    IF sy-subrc = 0.
      ls_eway_bill_temp-version = ls_eway_bill_temp-version + 1.
      CONDENSE ls_eway_bill_temp-version.
      IF ls_eway_bill_temp-version LE 9.
        CONCATENATE '0' ls_eway_bill_temp-version INTO ls_eway_bill_temp-version.
      ENDIF.
    ENDIF.
  ENDIF.

  ls_eway_bill_vehicle_update-bukrs          =  ls_eway_bill_temp-bukrs.
  ls_eway_bill_vehicle_update-vbeln          =  <ls_final>-vbeln.
  ls_eway_bill_vehicle_update-version        =  ls_eway_bill_temp-version.
  ls_eway_bill_vehicle_update-trns_md        =  zeway_bill-trns_md.
  ls_eway_bill_vehicle_update-trans_doc      =  ls_vehicle_update-transdocno.
  ls_eway_bill_vehicle_update-lifnr          =  zeway_bill-lifnr.
  ls_eway_bill_vehicle_update-doc_dt         =  zeway_bill-doc_dt.
  ls_eway_bill_vehicle_update-trans_id       =  ls_eway_bill_temp-trans_id.
  ls_eway_bill_vehicle_update-trans_name     =  ls_eway_bill_temp-trans_name.
  ls_eway_bill_vehicle_update-vehical_no     =  ls_vehicle_update-vehicleno.
  ls_eway_bill_vehicle_update-vehical_type   =  zeway_bill-vehical_type.
  ls_eway_bill_vehicle_update-distance       =  ls_eway_bill_temp-distance.
  ls_eway_bill_vehicle_update-updateby       = sy-uname.
  ls_eway_bill_vehicle_update-reasoncode     = ls_vehicle_update-reasoncode.
  ls_eway_bill_vehicle_update-reason         = ls_vehicle_update-reasonrem.
  ls_eway_bill_vehicle_update-fromplace      = ls_vehicle_update-fromplace.
  ls_eway_bill_vehicle_update-fromstatecode  =  ls_vehicle_update-fromstate.



      CLEAR ls_res.
      LOOP AT lt_res INTO ls_res.

        IF ls_res-header CS 'vehUpdDate'.
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
          ENDIF.


*        IF gv_valid_upto IS NOT INITIAL.
        IF ls_res-header CS 'validUpto'..
          IF ls_res-value NE 'null'..
          lv_ewaybill_exdt = ls_res-value+0(10).
          CONCATENATE lv_ewaybill_exdt+6(4) lv_ewaybill_exdt+3(2) lv_ewaybill_exdt+0(2) INTO lv_ewaybill_exdt.

          lv_ewaybill_extm = ls_res-value+11(11).
          CONCATENATE lv_ewaybill_extm+0(2) lv_ewaybill_extm+3(2) lv_ewaybill_extm+6(2) INTO lv_ewaybill_extime.

          MOVE lv_ewaybill_extime TO lv_vdtotime.
          IF lv_ewaybill_extm+9(2) = 'PM'.
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
          ENDIF.
          ENDIF.
          ENDLOOP.
*          MOVE lv_vdtotime TO ls_eway_bill_vehicle_update-updatetime.
*          MOVE lv_ewaybill_dt  TO ls_eway_bill_vehicle_update-updatedt.

          MOVE sy-uzeit TO ls_eway_bill_vehicle_update-updatetime.
          MOVE sy-datum	TO ls_eway_bill_vehicle_update-updatedt.
  ENDIF.

      IF ls_eway_bill_vehicle_update IS NOT INITIAL.
            MESSAGE 'Eway Bill Sucessfully Updated' TYPE 'I'.
            <ls_final>-vdtotime    = lv_vdtotime.
            <ls_final>-eway_dt_exp = lv_ewaybill_exdt.
            <ls_final>-veh_no      = ls_eway_bill_vehicle_update-vehical_no.
            <ls_final>-message     = 'Eway Bill Sucessfully Updated'.
          MODIFY zeway_bill FROM ls_eway_bill_vehicle_update.

DATA : gv_eway    TYPE zeway_number,
       gv_eway122 TYPE ZEWAY_RES_122.

CLEAR :gv_eway ,gv_eway122.


SELECT SINGLE * FROM zeway_number INTO gv_eway  WHERE vbeln = ls_eway_bill_vehicle_update-vbeln.
  IF sy-subrc = 0.
    UPDATE zeway_number set validuptodate = lv_ewaybill_exdt
                                  vdtotime      = lv_vdtotime
                              WHERE vbeln = ls_eway_bill_vehicle_update-vbeln.
  ENDIF.

SELECT SINGLE * FROM ZEWAY_RES_122 INTO gv_eway122 WHERE belnr = ls_eway_bill_vehicle_update-vbeln.
IF sy-subrc = 0.
    UPDATE ZEWAY_RES_122 set validuptodate = lv_ewaybill_exdt
                                  vdtotime      = lv_vdtotime
                              WHERE BELNR = ls_eway_bill_vehicle_update-vbeln.
  ENDIF.


          REFRESH : lt_eway_bill_temp.
          clear :  ls_vehicle_update,ls_eway_bill_temp,zeway_bill,ls_vehicle_update,ls_eway_bill_vehicle_update,lv_response.
*      ENDIF.



   ELSE.

     CLEAR ls_res.
      READ TABLE lt_res INTO ls_res WITH KEY header = 'errorMsg'.

        IF sy-subrc = 0.
           MESSAGE ls_res-value TYPE 'I'.
           <ls_final>-message     = ls_res-value ."'Eway Bill not Updated'.
         ELSE.
           MESSAGE 'Eway Bill not Updated' TYPE 'I'.
           <ls_final>-message     = 'Eway Bill not Updated'.
        ENDIF.


   ENDIF.
CLEAR :gv_eway ,gv_eway122.
ENDFORM.
