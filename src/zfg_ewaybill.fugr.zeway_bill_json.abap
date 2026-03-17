FUNCTION ZEWAY_BILL_JSON.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(DATA) TYPE  DATA
*"  EXPORTING
*"     REFERENCE(TREX_JSON) TYPE  STRING
*"----------------------------------------------------------------------

* serialize table lt_fINAL into JSON, skipping initial fields and converting ABAP field names into camelCase
  data(lv_json) = /ui2/cl_json=>serialize( data = data compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

  " Display JSON in ABAP
  CALL TRANSFORMATION sjson2html SOURCE XML lv_json
                             RESULT XML DATA(lvc_html).
*  cl_abap_browser=>show_html( title = 'ABAP (iTab) -> JSON: /ui2/cl_json=>serialize' html_string = cl_abap_codepage=>convert_from( lvc_html ) ).

  CLEAR data.

* deserialize JSON string json into internal table lt_final doing camelCase to ABAP like field name mapping
  /ui2/cl_json=>deserialize( EXPORTING json = lv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = data ).



  DATA(o_writer_itab) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
  CALL TRANSFORMATION id SOURCE values = data RESULT XML o_writer_itab.
  DATA: lv_result TYPE string.
  cl_abap_conv_in_ce=>create( )->convert( EXPORTING
                                            input = o_writer_itab->get_output( )
                                          IMPORTING
                                            data = lv_result ).

* JSON -> ABAP (iTab)
  CLEAR data.

  CALL TRANSFORMATION id SOURCE XML lv_result RESULT values = data.

* ABAP (iTab) -> JSON (trex)
  DATA(o_trex) = NEW cl_trex_json_serializer( data ).
  o_trex->serialize( ).

  trex_json = o_trex->get_data( ).

ENDFUNCTION.
