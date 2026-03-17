class ZCL_ZMTR_DPC_EXT definition
  public
  inheriting from ZCL_ZMTR_DPC
  create public .

public section.
protected section.

  methods MTRSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMTR_DPC_EXT IMPLEMENTATION.


  method MTRSET_GET_ENTITYSET.
*-------------------------------------------------------------
*  Data declaration
*-------------------------------------------------------------
 data LV_AUFNR type ZIF_ZMTR2=>AFPO-AUFNR.
 data LT_FINAL  type ZIF_ZMTR2=>__ZSTR_FINAL.
 data RETURN  type ZIF_ZMTR2=>__BAPIRET2.
 data LS_LT_FINAL  type line of ZIF_ZMTR2=>__ZSTR_FINAL.
 data LS_RETURN  type line of ZIF_ZMTR2=>__BAPIRET2.
 data LV_RFC_NAME type TFDIR-FUNCNAME.
 data LV_DESTINATION type RFCDEST.
 data LV_SUBRC type SYST-SUBRC.
 data LV_EXC_MSG type /IWBEP/MGW_BOP_RFC_EXCEP_TEXT.
 data LX_ROOT type ref to CX_ROOT.
DATA lo_filter TYPE  REF TO /iwbep/if_mgw_req_filter.
DATA lt_filter_select_options TYPE /iwbep/t_mgw_select_option.
DATA lv_filter_str TYPE string.
DATA ls_paging TYPE /iwbep/s_mgw_paging.
DATA ls_converted_keys LIKE LINE OF ET_ENTITYSET.
DATA ls_filter TYPE /iwbep/s_mgw_select_option.
DATA ls_filter_range TYPE /iwbep/s_cod_select_option.
DATA lr_LV_AUFNR LIKE RANGE OF ls_converted_keys-LV_AUFNR.
DATA ls_LV_AUFNR LIKE LINE OF lr_LV_AUFNR.
DATA lo_dp_facade TYPE REF TO /iwbep/if_mgw_dp_facade.
DATA ls_gw_lt_final LIKE LINE OF et_entityset.
DATA lv_skip     TYPE int4.
DATA lv_top      TYPE int4.

*-------------------------------------------------------------
*  Map the runtime request to the RFC - Only mapped attributes
*-------------------------------------------------------------
* Get all input information from the technical request context object
* Since DPC works with internal property names and runtime API interface holds external property names
* the process needs to get the all needed input information from the technical request context object
* Get filter or select option information
  lo_filter = io_tech_request_context->get_filter( ).
  lt_filter_select_options = lo_filter->get_filter_select_options( ).
  lv_filter_str = lo_filter->get_filter_string( ).

* Check if the supplied filter is supported by standard gateway runtime process
  IF  lv_filter_str            IS NOT INITIAL
  AND lt_filter_select_options IS INITIAL.
    " If the string of the Filter System Query Option is not automatically converted into
    " filter option table (lt_filter_select_options), then the filtering combination is not supported
    " Log message in the application log
    me->/iwbep/if_sb_dpc_comm_services~log_message(
      EXPORTING
        iv_msg_type   = 'E'
        iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
        iv_msg_number = 025 ).
     " Raise Exception
     RAISE EXCEPTION TYPE /IWBEP/CX_MGW_TECH_EXCEPTION
       EXPORTING
         textid = /iwbep/cx_mgw_tech_exception=>internal_error.
  ENDIF.

* Get key table information
  io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values  = ls_converted_keys ).

  ls_paging-top = io_tech_request_context->get_top( ).
  ls_paging-skip = io_tech_request_context->get_skip( ).

* Maps filter table lines to function module parameters
  LOOP AT lt_filter_select_options INTO ls_filter.

    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-property.
      WHEN 'LV_AUFNR'.
        lo_filter->convert_select_option(
          EXPORTING
            is_select_option = ls_filter
          IMPORTING
            et_select_option = lr_LV_AUFNR ).

        READ TABLE lr_LV_AUFNR into ls_LV_AUFNR index 1.
        IF sy-subrc = 0.
          LV_AUFNR = ls_LV_AUFNR-low.
        ENDIF.
        WHEN OTHERS.
          " Log message in the application log
          me->/iwbep/if_sb_dpc_comm_services~log_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
              iv_msg_number = 020
              iv_msg_v1     = ls_filter-property ).
          " Raise Exception
          RAISE EXCEPTION TYPE /IWBEP/CX_MGW_TECH_EXCEPTION
            EXPORTING
              textid = /iwbep/cx_mgw_tech_exception=>internal_error.
        ENDCASE.
    ENDLOOP.

  ENDLOOP.

* Get RFC destination
lo_dp_facade = /iwbep/if_mgw_conv_srv_runtime~get_dp_facade( ).
lv_destination = /iwbep/cl_sb_gen_dpc_rt_util=>get_rfc_destination( io_dp_facade = lo_dp_facade ).

*-------------------------------------------------------------
*  Call RFC function module
*-------------------------------------------------------------
lv_rfc_name = 'ZMTR'.

if lv_destination is initial or lv_destination eq 'NONE'.

  try.
      call function lv_rfc_name
        exporting
          LV_AUFNR   =   LV_AUFNR
        tables
          RETURN     =   RETURN
          LT_FINAL   =   LT_FINAL
        exceptions
          system_failure = 1000 message lv_exc_msg
          others = 1002.

      lv_subrc = sy-subrc.
*in case of co-deployment the exception is raised and needs to be caught
    catch cx_root into lx_root.
      lv_subrc = 1001.
      lv_exc_msg = lx_root->if_message~get_text( ).
  endtry.

else.

  call function lv_rfc_name destination lv_destination
        exporting
          LV_AUFNR   =   LV_AUFNR
        tables
          RETURN     =   RETURN
          LT_FINAL   =   LT_FINAL
        exceptions
          system_failure         = 1000 message lv_exc_msg
          communication_failure  = 1001 message lv_exc_msg
          others = 1002.

  lv_subrc = sy-subrc.

endif.

*-------------------------------------------------------------
*  Map the RFC response to the caller interface - Only mapped attributes
*-------------------------------------------------------------
*-------------------------------------------------------------
* Error and exception handling
*-------------------------------------------------------------
IF lv_subrc <> 0.
* Execute the RFC exception handling process
  me->/iwbep/if_sb_dpc_comm_services~rfc_exception_handling(
    EXPORTING
      iv_subrc            = lv_subrc
      iv_exp_message_text = lv_exc_msg ).
ENDIF.

IF RETURN IS NOT INITIAL.
  me->/iwbep/if_sb_dpc_comm_services~rfc_save_log(
    EXPORTING
      iv_entity_type = iv_entity_name
      it_return      = RETURN
      it_key_tab     = it_key_tab ).
ENDIF.

*-------------------------------------------------------------------------*
*             - Post Backend Call -
*-------------------------------------------------------------------------*
IF ls_paging-skip IS NOT INITIAL.
*  If the Skip value was requested at runtime
*  the response table will provide backend entries from skip + 1, meaning start from skip +1
*  for example: skip=5 means to start get results from the 6th row
  lv_skip = ls_paging-skip + 1.
ENDIF.
*  The Top value was requested at runtime but was not handled as part of the function interface
IF  ls_paging-top <> 0
AND lv_skip IS NOT INITIAL.
*  if lv_skip > 0 retrieve the entries from lv_skip + Top - 1
*  for example: skip=5 and top=2 means to start get results from the 6th row and end in row number 7
lv_top = ls_paging-top + lv_skip - 1.
ELSEIF ls_paging-top <> 0
AND    lv_skip IS INITIAL.
  lv_top = ls_paging-top.
ELSE.
  lv_top = lines( lt_final ).
ENDIF.

*  - Map properties from the backend to the Gateway output response table -

loop at lt_final into ls_lt_final
*  Provide the response entries according to the Top and Skip parameters that were provided at runtime
     from lv_skip to lv_top.
*  Only fields that were mapped will be delivered to the response table
 ls_gw_lt_final-mandt = ls_lt_final-mandt.
 ls_gw_lt_final-aufnr = ls_lt_final-aufnr.

  CALL FUNCTION 'CONVERSION_EXIT_ATINN_OUTPUT'
   EXPORTING
     INPUT        =   ls_lt_final-atinn
  IMPORTING
    OUTPUT        =   ls_lt_final-atinn
           .

 ls_gw_lt_final-atinn = ls_lt_final-atinn.
 ls_gw_lt_final-kdauf = ls_lt_final-kdauf.
 ls_gw_lt_final-kunnr = ls_lt_final-kunnr.
 ls_gw_lt_final-bstnk = ls_lt_final-bstnk.
 ls_gw_lt_final-bstdk = ls_lt_final-bstdk.
 ls_gw_lt_final-matnr = ls_lt_final-matnr.
 ls_gw_lt_final-maktx = ls_lt_final-maktx.
 ls_gw_lt_final-zsize = ls_lt_final-zsize.
 ls_gw_lt_final-atwrt = ls_lt_final-atwrt.
 ls_gw_lt_final-class = ls_lt_final-class.
 ls_gw_lt_final-shell_test = ls_lt_final-shell_test.
 ls_gw_lt_final-seat_test = ls_lt_final-seat_test.
 ls_gw_lt_final-pneumatic = ls_lt_final-pneumatic.
 ls_gw_lt_final-name1 = ls_lt_final-name1.
 ls_gw_lt_final-psmng = ls_lt_final-psmng.
 ls_gw_lt_final-lv_aufnr = ls_lt_final-aufnr.
 ls_gw_lt_final-tdline = ls_lt_final-tdline.
append ls_gw_lt_final to et_entityset.
CLEAR ls_gw_lt_final.
ENDLOOP.

  endmethod.
ENDCLASS.
