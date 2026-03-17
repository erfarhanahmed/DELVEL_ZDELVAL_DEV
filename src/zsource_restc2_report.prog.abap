*&---------------------------------------------------------------------*
*& Report ZSOURCE_RESTC2_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSOURCE_RESTC2_REPORT.


TYPE-POOLS:slis.


TYPES : BEGIN OF ty_data,
 vbeln               type ZSOURCE_RESTC2-vbeln,
 COMPONENT_TYPE      type ZSOURCE_RESTC2-COMPONENT_TYPE,
 POSNR               type ZSOURCE_RESTC2-POSNR,
 COM_CODE_DESC       type ZSOURCE_RESTC2-COM_CODE_DESC,
 PRODUCT             type ZSOURCE_RESTC2-PRODUCT,
 SUB_CAT             type ZSOURCE_RESTC2-SUB_CAT,
 COUNTRY_RESTRICTION TYPE ZSOURCE_RESTC2-COUNTRY_RESTRICTION,
 SUPPLY_RESTRICTION  type ZSOURCE_RESTC2-SUPPLY_RESTRICTION,
 "CHECK_BOX           type ZSOURCE_RESTC2-CHECK_BOX,
 COMP_RESTRCITION    type ZSOURCE_RESTC2-COMP_RESTRCITION,
end of ty_data.


types : BEGIN OF ty_final,
 vbeln               type ZSOURCE_RESTC2-vbeln,
 COMPONENT_TYPE      type ZSOURCE_RESTC2-COMPONENT_TYPE,
 POSNR               type ZSOURCE_RESTC2-POSNR,
 COM_CODE_DESC       type ZSOURCE_RESTC2-COM_CODE_DESC,
 PRODUCT             type ZSOURCE_RESTC2-PRODUCT,
 SUB_CAT             type ZSOURCE_RESTC2-SUB_CAT,
 COUNTRY_RESTRICTION TYPE ZSOURCE_RESTC2-COUNTRY_RESTRICTION,
 SUPPLY_RESTRICTION  type ZSOURCE_RESTC2-SUPPLY_RESTRICTION,
 "CHECK_BOX           type ZSOURCE_RESTC2-CHECK_BOX,
 ref_dat             TYPE char11,                         "Refresh Date
 ref_time            TYPE char15,
 COMP_RESTRCITION    type ZSOURCE_RESTC2-COMP_RESTRCITION,
 end of ty_final.


types : BEGIN OF ty_down,
 vbeln               type ZSOURCE_RESTC2-vbeln,
 COMPONENT_TYPE      type ZSOURCE_RESTC2-COMPONENT_TYPE,
 POSNR               type ZSOURCE_RESTC2-POSNR,
 COM_CODE_DESC       type ZSOURCE_RESTC2-COM_CODE_DESC,
 PRODUCT             type ZSOURCE_RESTC2-PRODUCT,
 SUB_CAT             type ZSOURCE_RESTC2-SUB_CAT,
 COUNTRY_RESTRICTION TYPE ZSOURCE_RESTC2-COUNTRY_RESTRICTION,
 SUPPLY_RESTRICTION  type ZSOURCE_RESTC2-SUPPLY_RESTRICTION,
 "CHECK_BOX           type ZSOURCE_RESTC2-CHECK_BOX,
 ref_dat             TYPE char11,"15,                         "Refresh Date
 ref_time            TYPE char15,
 COMP_RESTRCITION    type ZSOURCE_RESTC2-COMP_RESTRCITION,
  end of ty_down.


 data : wa_data type ty_data,
        it_data type STANDARD TABLE OF ty_data,


        wa_final type ty_final,
        it_final type STANDARD TABLE OF ty_final,


        wa_down type ty_down,
        it_down type STANDARD TABLE OF ty_down,


        it_fieldcat TYPE slis_t_fieldcat_alv,
        wa_fieldcat TYPE slis_fieldcat_alv,

        ls_layout   TYPE slis_layout_alv.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS   :  s_vbeln FOR wa_data-vbeln.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN END OF BLOCK b3.



START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM create_feildcat.
  PERFORM display_data.
  PERFORM down_set.
  PERFORM new_file.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

SELECT  vbeln
        COMPONENT_TYPE
        POSNR
        COM_CODE_DESC
        PRODUCT
        SUB_CAT
        COUNTRY_RESTRICTION
        SUPPLY_RESTRICTION
        COMP_RESTRCITION
  from ZSOURCE_RESTC2
  into table it_data[]
  where vbeln in s_vbeln.

loop at it_data into wa_data.
  wa_final-vbeln = wa_data-vbeln .
  wa_final-COMPONENT_TYPE = wa_data-COMPONENT_TYPE.
  wa_final-POSNR = wa_data-posnr.
  wa_final-COM_CODE_DESC = wa_data-COM_CODE_DESC.
  wa_final-PRODUCT = wa_data-product.
  wa_final-SUB_CAT = wa_data-SUB_CAT.
  wa_final-COUNTRY_RESTRICTION = wa_data-COUNTRY_RESTRICTION.
  wa_final-SUPPLY_RESTRICTION = wa_data-supply_restriction.
 " wa_final-CHECK_BOX = wa_data-check_box.
      wa_final-ref_dat = sy-datum.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-ref_dat
        IMPORTING
          output = wa_final-ref_dat.

      CONCATENATE wa_final-ref_dat+0(2) wa_final-ref_dat+2(3) wa_final-ref_dat+5(4)
                      INTO wa_final-ref_dat SEPARATED BY '-'.

      wa_final-ref_time = sy-uzeit.
      CONCATENATE wa_final-ref_time+0(2) ':' wa_final-ref_time+2(2)  INTO wa_final-ref_time.

       wa_final-COMP_RESTRCITION = wa_data-COMP_RESTRCITION.

  APPEND wa_final TO it_final.
  CLEAR : wa_final.
ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .
*PERFORM create_feildcat.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = it_fieldcat[]
    TABLES
      t_outtab      = it_final[]
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
*Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FEILDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_feildcat .

  wa_fieldcat-col_pos = '1'.
  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'SO No'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.

  wa_fieldcat-col_pos = '2'.
  wa_fieldcat-fieldname = 'COMPONENT_TYPE'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Component Type'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.

  wa_fieldcat-col_pos = '3'.
  wa_fieldcat-fieldname = 'POSNR '.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Item'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


  wa_fieldcat-col_pos = '4'.
  wa_fieldcat-fieldname = 'COM_CODE_DESC'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Component Code Description'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.

  wa_fieldcat-col_pos = '5'.
  wa_fieldcat-fieldname = 'PRODUCT'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Product'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.

  wa_fieldcat-col_pos = '6'.
  wa_fieldcat-fieldname = 'SUB_CAT '.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Sub Catagory'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


  wa_fieldcat-col_pos = '7'.
  wa_fieldcat-fieldname = 'COUNTRY_RESTRICTION'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Country Restriction'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


  wa_fieldcat-col_pos = '8'.
  wa_fieldcat-fieldname = 'SUPPLY_RESTRICTION'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Supply Restriction'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.

   wa_fieldcat-col_pos = '9'.
  wa_fieldcat-fieldname = 'COMP_RESTRCITION'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Comp Restriction'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down_set .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).
   CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.       "added for check
  lv_file = 'ZSOURCING.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSOURCING Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_308 TYPE string.
DATA lv_crlf_308 TYPE string.
lv_crlf_308 = cl_abap_char_utilities=>cr_lf.
lv_string_308 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_308 lv_crlf_308 wa_csv INTO lv_string_308.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1507 TO lv_fullfile.
TRANSFER lv_string_308 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


 ENDFORM.
  FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE
          'Sales Document'
          'Component Type'
          'Item'
          'Company Code Desc'
          'Product'
          'Sub Catogary'
          'Country Restriction'
          'Supply Restriction'
          'Refresh date'
          'Refresh time'
          'Comp Restriction'
  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
FORM new_file .
  LOOP AT it_final INTO wa_final.
  wa_down-vbeln = wa_final-vbeln .
  wa_down-COMPONENT_TYPE = wa_final-COMPONENT_TYPE.
  wa_down-POSNR = wa_final-posnr.
  wa_down-COM_CODE_DESC = wa_final-COM_CODE_DESC.
  wa_down-PRODUCT = wa_final-product.
  wa_down-SUB_CAT = wa_final-SUB_CAT.
  wa_down-COUNTRY_RESTRICTION = wa_final-COUNTRY_RESTRICTION.
  wa_down-SUPPLY_RESTRICTION = wa_final-supply_restriction.
  "wa_down-CHECK_BOX = wa_final-check_box.

*  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = sy-datum
*        IMPORTING
*          output = wa_down-ref_dat.
*      CONCATENATE wa_down-ref_dat+0(2) wa_down-ref_dat+2(3) wa_down-ref_dat+5(4)
*     INTO wa_down-ref_dat SEPARATED BY '-'.
*
*      wa_down-ref_time = sy-uzeit.
*      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

  wa_down-ref_dat = wa_final-ref_dat.
  wa_down-ref_time = wa_final-ref_time.
  wa_down-COMP_RESTRCITION = wa_final-COMP_RESTRCITION.
  APPEND wa_down TO it_down.
  clear wa_down.
  ENDLOOP.
ENDFORM.
