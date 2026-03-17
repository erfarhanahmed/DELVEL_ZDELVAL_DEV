*&---------------------------------------------------------------------*
*&  Include           ZSO_STORAGE_LOCATION_LOGIC
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data.

  IF p_lgort IS NOT INITIAL.
    SELECT vbeln,
      posnr,
      matnr,
      lgort
      FROM vbap
      INTO TABLE @lt_vbap
      WHERE vbeln IN @s_vbeln
      AND werks EQ 'PL01'
      AND lgort EQ @p_lgort .
    IF sy-subrc EQ 0.
      SORT lt_vbap BY vbeln posnr.
    ENDIF.
  ELSE.
    SELECT vbeln,
  posnr,
  matnr,
  lgort
  FROM vbap
  INTO TABLE @lt_vbap
  WHERE vbeln IN @s_vbeln
      AND werks EQ 'PL01'.
    IF sy-subrc EQ 0.
      SORT lt_vbap BY vbeln posnr.
    ENDIF.
  ENDIF.
  DELETE lt_vbap WHERE lgort IS INITIAL.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_data.

  LOOP AT lt_vbap INTO DATA(lw_vbap).
*    if LW_FINAL-LGORT is NOT INITIAL.

    lv_date = sy-datum.
    lv_time = sy-uzeit.

    lw_final-vbeln = lw_vbap-vbeln.     " Sales Document
    lw_final-posnr = lw_vbap-posnr.     " Sales Document Item
    lw_final-matnr = lw_vbap-matnr.     " Material Number
    lw_final-lgort = lw_vbap-lgort.     " Storage Location
    IF lv_date IS NOT   INITIAL AND lv_date NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = lv_date
        IMPORTING
          output = lw_final-zrf_date.
    ENDIF.
    IF lw_final-zrf_date IS NOT INITIAL   .
      CONCATENATE lw_final-zrf_date+0(2) lw_final-zrf_date+2(3) lw_final-zrf_date+5(4)
                      INTO lw_final-zrf_date SEPARATED BY '-'.                         " Refreshed Date
    ENDIF.

    IF lv_time IS NOT INITIAL .
      CONCATENATE lv_time+0(2) ':' lv_time+2(2) INTO lw_final-zrf_time.                " Refreshed Time
    ENDIF.

    APPEND lw_final TO lt_final.
    CLEAR lw_final.
*    endif.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat.

  PERFORM fcat USING : '1'  'VBELN'      'LT_FINAL'    TEXT-006  '10',
                       '2'  'POSNR'      'LT_FINAL'    TEXT-007  '10',
                       '3'  'MATNR'      'LT_FINAL'    TEXT-008  '15',
                       '4'  'LGORT'      'LT_FINAL'    TEXT-009  '15',
                       '5'  'ZRF_DATE'   'LT_FINAL'    TEXT-010  '10',
                       '6'  'ZRF_TIME'   'LT_FINAL'    TEXT-011  '10'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form fCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0813   text
*      -->P_0814   text
*      -->P_0815   text
*      -->P_0816   text
*      -->P_0817   text
*----------------------------------------------------------------------*
FORM fcat USING    VALUE(p_0813)
                    VALUE(p_0814)
                    VALUE(p_0815)
                    VALUE(p_0816)
                    VALUE(p_0817).

  lw_fcat-col_pos   = p_0813.
  lw_fcat-fieldname = p_0814.
  lw_fcat-tabname   = p_0815.
  lw_fcat-seltext_l = p_0816.
  lw_fcat-outputlen   = p_0817.
  APPEND lw_fcat TO lt_fcat.
  CLEAR lw_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data.

  ls_layout-zebra = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = ls_layout
      it_fieldcat        = lt_fcat
    TABLES
      t_outtab           = lt_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE TEXT-005 TYPE 'I'.
  ENDIF.

  IF p_down = 'X'.    " download file
    PERFORM download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download.

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
    TABLES
      i_tab_sap_data       = lt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE TEXT-012 TYPE 'I'.
  ENDIF.

  PERFORM csv_header USING hd_csv.     " file heading

  lv_file = 'ZSO_STORAGE_LOCATION.TXT'.

*  CONCATENATE P_FILE '\' LV_FILE INTO LV_FULLFILE.
  CONCATENATE p_file '/' lv_file INTO lv_fullfile.

  WRITE: / 'ZSO_STORAGE_LOCATION DOWNLOAD STARTED ON', sy-datum, 'at', sy-uzeit.

  OPEN DATASET lv_fullfile FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF SY-SUBRC = 0.
*    TRANSFER HD_CSV TO LV_FULLFILE.
*
*    LOOP AT IT_CSV INTO WA_CSV.
*      IF SY-SUBRC = 0.
*        TRANSFER WA_CSV TO LV_FULLFILE.
*      ENDIF.
*    ENDLOOP.
*
*    CONCATENATE TEXT-013 LV_FULLFILE TEXT-014 INTO LV_MSG SEPARATED BY SPACE.
*    MESSAGE LV_MSG TYPE 'S'.
*  ENDIF.

  IF sy-subrc = 0.
    DATA lv_string_263 TYPE string.
    DATA lv_crlf_263 TYPE string.

*    TRANSFER hd_csv TO lv_fullfile.

    lv_crlf_263 = cl_abap_char_utilities=>cr_lf.
    lv_string_263 = hd_csv.

    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_263  lv_crlf_263   wa_csv INTO lv_string_263 .
      CLEAR: wa_csv.
    ENDLOOP.

    TRANSFER lv_string_263 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CSV_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM csv_header  USING p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE TEXT-006
              TEXT-007
              TEXT-008
              TEXT-009
              TEXT-010
              TEXT-011
    INTO p_hd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
