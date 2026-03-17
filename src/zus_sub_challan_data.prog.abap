*&---------------------------------------------------------------------*
*&  Include           ZUS_SUB_CHALLAN_DATA
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_entry .

  CALL SCREEN 0200.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK_0100'.
      LEAVE TO SCREEN 0.
    WHEN 'CLOSE_0100'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  READOBS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE readobs INPUT.
*  MODIFY IT_DATA FROM WA_DATA INDEX TABAREA-CURRENT_LINE.
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK_0100'.
      LEAVE TO SCREEN 0.
    WHEN 'CLOSE_0100'.
      LEAVE TO SCREEN 0.
    WHEN 'GET_DATA'.
      PERFORM get_data.
    WHEN 'SAVE_0100'.
      PERFORM save_data.
    WHEN 'PRINT'.
      PERFORM print.
    WHEN 'REFRESH'.
      PERFORM clear.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  DATA :  lv_mblnr TYPE mseg-mblnr.

  lv_mblnr =   zsub_challan-zmblnr.

  IF it_data[] IS INITIAL .

    SELECT mblnr,
           matnr,
           menge,
           werks,
           lgort,
           mjahr,
           zeile,
           bwart
      FROM mseg
      INTO TABLE @DATA(it_data_1)
      WHERE mblnr = @lv_mblnr
      AND   bukrs = 'US00'
      AND   bwart = '541'
      AND   xauto = 'X'.

    SELECT mblnr,
           matnr,
           menge,
           werks,
           lgort,
           mjahr,
           zeile,
           bwart
     FROM mseg
     INTO TABLE @DATA(it_lgort)
     WHERE mblnr = @lv_mblnr
     AND   bukrs = 'US00'
     AND   bwart = '541'.

    DELETE it_lgort WHERE lgort EQ space.

    SELECT zmblnr,
           zrate,
           zmatnr,
           zzeile,
           zremarks,
           zship_date
    FROM zsub_challan
    INTO TABLE @DATA(it_challan)
    FOR ALL ENTRIES IN @it_data_1
     WHERE zmblnr = @it_data_1-mblnr.

    SELECT mblnr,
          zremarks,
          zfreight,
          zdiscount,
          zterm_cond
    FROM zsub_remark
    INTO TABLE @DATA(it_sub_re)
    FOR ALL ENTRIES IN @it_data_1
    WHERE mblnr = @it_data_1-mblnr.

    IF it_data_1 IS INITIAL.
      MESSAGE |Data Not Found| TYPE 'E'.
    ENDIF.
    BREAK primusabap.
    LOOP AT it_data_1 INTO DATA(wa_data_1).
      it_data-mblnr = wa_data_1-mblnr.
      it_data-matnr = wa_data_1-matnr.
      it_data-mjahr = wa_data_1-mjahr.
      it_data-werks = wa_data_1-werks.
      it_data-zeile = wa_data_1-zeile.
      it_data-bwart = wa_data_1-bwart.
      DATA :gv_menge TYPE p DECIMALS 2.
      gv_menge = wa_data_1-menge.
*      it_data-menge = wa_data_1-menge.
      it_data-menge = gv_menge.

      READ TABLE it_lgort INTO DATA(wa_lgort) WITH  KEY mblnr = wa_data_1-mblnr
                                                             matnr = wa_data_1-matnr
                                                             zeile = wa_data_1-zeile.
      IF sy-subrc = 0.
        it_data-lgort = wa_lgort-lgort.
      ENDIF.

      READ TABLE it_challan INTO DATA(wa_challan) WITH KEY zmblnr = it_data-mblnr
                                                           zmatnr = it_data-matnr
                                                           zzeile = it_data-zeile.
      IF sy-subrc IS INITIAL.
        it_data-rate = wa_challan-zrate.
        it_data-rate1 = it_data-rate.
        it_data-rate1 = replace( val = it_data-rate1 sub = ',' with = '').
        it_data-zship_date = wa_challan-zship_date.
      ENDIF.

      APPEND it_data TO it_data .
      CLEAR :it_data, it_remark.
    ENDLOOP.
    SELECT SINGLE zremarks zship_method INTO ( gv_remark, gv_ship_method ) FROM zsub_remark WHERE mblnr = zsub_challan-zmblnr.
    zsub_remark-zremarks     = gv_remark .
    zsub_remark-zship_method = gv_ship_method .
    DATA : gv_freight TYPE zsub_remark-zfreight.
    SELECT SINGLE zfreight zdiscount zterm_cond INTO ( gv_freight , zdiscount ,zterm_cond ) FROM zsub_remark
      WHERE mblnr = zsub_challan-zmblnr.
    zfreight  = gv_freight.
    zsub_remark-zdiscount  = zdiscount.
    zsub_remark-zterm_cond  = zterm_cond.

    DELETE ADJACENT DUPLICATES FROM it_data COMPARING ALL FIELDS.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear .

  REFRESH : it_data[] .
  CLEAR : mseg , zsub_remark ,zsub_challan.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_data .

  LOOP AT it_data INTO it_data.
    wa_challan-zmblnr = it_data-mblnr.
    wa_challan-zzeile = it_data-zeile.
    wa_challan-zmatnr = it_data-matnr.
    wa_challan-zrate  = it_data-rate.
    wa_challan-zship_date  = it_data-zship_date.

    MODIFY zsub_challan FROM wa_challan .
    CLEAR it_data.

    IF sy-subrc = 0.
      MESSAGE |Data save successfully| TYPE 'S'.
    ENDIF.
  ENDLOOP.

  zsub_remark-mblnr = zsub_challan-zmblnr.
  zsub_remark-zfreight = zfreight.
  MODIFY zsub_remark." from gv_remark where mblnr = mseg-mblnr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print .

  DATA formname    TYPE tdsfname VALUE 'ZUS_SUB_CHALLAN'.
  DATA fm_name     TYPE rs38l_fnam.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = formname
      variant            = ' '
      direct_call        = ' '
    IMPORTING
      fm_name            = fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  DATA: cparam TYPE ssfctrlop.
  DATA:  ls_composer_param TYPE ssfcompop.

*                CALL FUNCTION '/1BCDWB/SF00000118'
  CALL FUNCTION fm_name
    EXPORTING
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = cparam
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = ls_composer_param
      user_settings      = 'X'
      mblnr              = zsub_challan-zmblnr
*                 IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO    =
*     JOB_OUTPUT_OPTIONS =
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  ZDISCOUNT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zdiscount INPUT.
  IF zsub_remark-zdiscount GT '100'.
    MESSAGE |Discount not more than 100%| TYPE 'E'.
  ENDIF.
ENDMODULE.
