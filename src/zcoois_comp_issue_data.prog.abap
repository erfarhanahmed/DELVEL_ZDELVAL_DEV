*&---------------------------------------------------------------------*
*&  Include           ZCOOIS_COMP_ISSUE_DATA
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

*  BREAK primusabap.

  SELECT a~aufnr,
         a~budat,
         a~stokz,
         a~stzhl,
         b~auart,
         b~objnr,
         b~werks,
         b~kdauf,
         b~kdpos,
         d~matnr,
         d~bdmng,
         d~enmng,
         d~meins,
         d~xloek
    FROM afru AS a INNER JOIN caufv AS b
    ON a~aufnr EQ b~aufnr
    INNER JOIN jest AS c
    ON b~objnr EQ c~objnr
    INNER JOIN resb AS d
    ON d~aufnr = a~aufnr
    WHERE a~aufnr IN @s_aufnr
    AND   a~budat IN @s_budat
    AND   a~werks EQ @p_werks
    AND   b~kdauf IN @s_kdauf
    AND   b~kdpos IN @s_kdpos
    AND   b~auart IN @s_auart
    AND   c~stat  IN ( 'I0009' ,'I0010','I0045','I0046','I0012' )
    AND   c~inact NE 'X'
*   AND   d~xloek NE 'X'
    AND   a~stokz NE 'X'
    AND   a~stzhl NE '1'
    INTO TABLE @DATA(it_data).

*    IF it_data is NOT INITIAL.
*      MESSAGE e001  TYPE 'E'.
*    ENDIF.

  SORT it_data BY aufnr matnr.
  DELETE ADJACENT DUPLICATES FROM it_data COMPARING aufnr matnr.
  BREAK primusabap.
  SELECT aufnr,
         stokz,
         stzhl,
         budat
    FROM afru
    INTO TABLE @DATA(it_afru_new)
    FOR ALL ENTRIES IN @it_data
    WHERE aufnr = @it_data-aufnr.

    SORT it_afru_new by aufnr stokz stzhl.
    DELETE it_afru_new WHERE stokz is NOT INITIAL .
    DELETE it_afru_new WHERE stzhl is NOT INITIAL.

select matnr,
       maktx
     FROM makt
     FOR ALL ENTRIES IN @it_data
     WHERE matnr = @it_data-matnr
     INTO TABLE @DATA(it_makt).

  SELECT aufnr,
         gamng
    FROM afko
    FOR ALL ENTRIES IN @it_data
    WHERE aufnr = @it_data-aufnr
    INTO TABLE @DATA(it_afko).

  SELECT a~aufnr,
         a~matnr,
         b~maktx,
         a~wemng
    FROM afpo AS a INNER JOIN makt AS b
    ON a~matnr EQ b~matnr
    FOR ALL ENTRIES IN @it_data
    WHERE aufnr = @it_data-aufnr
    INTO TABLE @DATA(it_afpo).

  SELECT a~vbeln,
         a~posnr,
         a~matnr,
         b~kunnr,
         c~name1
    FROM vbap AS a INNER JOIN vbak AS b
    ON a~vbeln EQ b~vbeln
    INNER JOIN kna1 AS c
    ON b~kunnr EQ c~kunnr
    INTO TABLE @DATA(it_vbap)
    FOR ALL ENTRIES IN @it_data
    WHERE a~vbeln = @it_data-kdauf.

  SELECT matnr,
         bwkey,
         vprsv,
         verpr,
         stprs
    FROM mbew
    INTO TABLE @DATA(it_mbew)
    FOR ALL ENTRIES IN @it_data
    WHERE  matnr = @it_data-matnr
    AND    bwkey = @it_data-werks.

  SELECT aufnr,
         idat2
    FROM aufk
    FOR ALL ENTRIES IN @it_data
    WHERE aufnr = @it_data-aufnr
    INTO TABLE @DATA(it_aufk).

  SELECT a~aufnr,
         a~objnr,
         a~matnr,
         b~stat
    FROM resb AS a INNER JOIN jest AS b
    ON a~objnr EQ b~objnr
    FOR ALL ENTRIES IN @it_data
    WHERE aufnr = @it_data-aufnr
    INTO TABLE @DATA(it_jest).

  LOOP AT it_data ASSIGNING FIELD-SYMBOL(<fs_data>).
    wa_final-aufnr   = <fs_data>-aufnr.

    READ TABLE it_aufk INTO DATA(wa_aufk) WITH KEY aufnr = wa_final-auart .
    IF wa_aufk-idat2 EQ '00000000'.
      wa_final-matnr   = <fs_data>-matnr.
      wa_final-budat   = <fs_data>-budat.
      wa_final-auart   = <fs_data>-auart.
      wa_final-bdmng   = <fs_data>-bdmng.
      wa_final-bdmng1  = wa_final-bdmng.
      wa_final-enmng   = <fs_data>-enmng.
      wa_final-enmng1  = wa_final-enmng.
      wa_final-to_be   = wa_final-bdmng - wa_final-enmng.
      wa_final-kdauf   = <fs_data>-kdauf.
      wa_final-kdpos   = <fs_data>-kdpos.
      wa_final-meins   = <fs_data>-meins.

      objnr = <fs_data>-objnr.
      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
          client           = sy-mandt
          objnr            = objnr
          spras            = 'E'
        IMPORTING
          line             = line
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      wa_final-status = line.

      READ TABLE it_mbew INTO DATA(wa_mbew) WITH KEY matnr = wa_final-matnr .
      IF sy-subrc = 0.
        IF wa_mbew-vprsv EQ 'V'.
          wa_final-rate = wa_mbew-verpr.
        ELSEIF wa_mbew-vprsv EQ 'S' .
          wa_final-rate = wa_mbew-stprs.
        ENDIF.
      ENDIF.

      name = wa_final-matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'GRUN'
          language                = 'E'
          name                    = name
          object                  = 'MATERIAL'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
      ENDIF.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF wa_lines-tdline IS NOT INITIAL.
            CONCATENATE wa_final-maktx wa_lines-tdline INTO wa_final-maktx SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      READ TABLE it_afko INTO DATA(wa_afko) WITH KEY aufnr = wa_final-aufnr .
      IF sy-subrc = 0.
        wa_final-gamng = wa_afko-gamng.
      ENDIF.

      READ TABLE it_afpo INTO DATA(wa_afpo) WITH KEY aufnr = wa_final-aufnr .
      IF sy-subrc = 0.
        wa_final-h_matnr = wa_afpo-matnr.
        wa_final-wemng = wa_afpo-wemng.
        name = wa_final-h_matnr.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = 'GRUN'
            language                = 'E'
            name                    = name
            object                  = 'MATERIAL'
          TABLES
            lines                   = lv_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc <> 0.
        ENDIF.

        IF lv_lines IS NOT INITIAL.
          LOOP AT lv_lines INTO wa_lines.
            IF wa_lines-tdline IS NOT INITIAL.
              CONCATENATE wa_final-h_maktx wa_lines-tdline INTO wa_final-h_maktx SEPARATED BY space.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

      READ TABLE it_vbap INTO DATA(wa_vbap) WITH KEY vbeln = wa_final-kdauf posnr = wa_final-kdpos .
      IF sy-subrc = 0.
        wa_final-so_matnr = wa_vbap-matnr.
        wa_final-kunnr    = wa_vbap-kunnr.
        wa_final-name1    = wa_vbap-name1.
      ENDIF.

      wa_final-value = wa_final-rate * wa_final-to_be.

      READ TABLE it_jest INTO DATA(wa_jest) WITH KEY matnr =  wa_final-matnr stat = 'I0013' .
      IF sy-subrc = 0.
        DATA(flag) = 'X'.
      ENDIF.

      IF wa_final-enmng1 = wa_final-bdmng1.   """ LOGIC FOR WHAN REQ QTY AND ISSUE QTY SAME THEN LINE DELETED
        wa_main-aufnr = <fs_data>-aufnr.
        wa_main-matnr = wa_afpo-matnr.
        APPEND wa_main TO it_main.            """LOGIC FOR WHEN ALL COMPONENT DELETED THEN ONE LINE APPEND PROD
        CLEAR wa_main.
      ELSE.
        IF  <fs_data>-xloek NE 'X'.
          APPEND wa_final TO it_final.
          CLEAR wa_final.
        ELSEIF wa_aufk-idat2 EQ '00000000'.   """LOGIC FOR TECO PROD
          IF flag NE 'X'.
            APPEND wa_final TO it_final.
            CLEAR : wa_final, wa_afpo, wa_vbap.
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR :wa_final,name,flag.

    ENDIF.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM it_main COMPARING aufnr.
*  BREAK primusabap.
  SORT it_afru_new BY budat DESCENDING.
  LOOP AT it_main INTO wa_main.
*    clear:wa_final.              """LOGIC FOR WHEN ALL COMPONENT DELETED THEN ONE LINE APPEND PROD
    READ TABLE it_final INTO wa_final WITH KEY aufnr = wa_main-aufnr.
    IF sy-subrc IS NOT INITIAL.
      wa_final-aufnr = wa_main-aufnr.
      wa_final-h_matnr = wa_main-matnr.
      wa_final-kdauf   = <fs_data>-kdauf.
      wa_final-kdpos   = <fs_data>-kdpos.
      wa_final-auart   = <fs_data>-auart.

      READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_final-kdauf posnr = wa_final-kdpos .
      IF sy-subrc = 0.
        wa_final-so_matnr = wa_vbap-matnr.
        wa_final-kunnr    = wa_vbap-kunnr.
        wa_final-name1    = wa_vbap-name1.
      ENDIF.

      READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_final-aufnr .
      IF sy-subrc = 0.
        wa_final-gamng = wa_afko-gamng.
      ENDIF.

      READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_final-auart .
      IF wa_aufk-idat2 EQ '00000000'.
        READ TABLE  it_afru_new INTO DATA(wa_afru_new) WITH KEY aufnr = wa_final-aufnr .
        IF sy-subrc = 0.
          wa_final-budat   = wa_afru_new-budat.
        ENDIF.
      ENDIF.

      READ TABLE it_data INTO DATA(wa_data) WITH KEY aufnr = wa_final-aufnr .
      IF sy-subrc = 0.
        objnr = wa_data-objnr.
      ENDIF.

      READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = wa_final-aufnr .
      IF sy-subrc = 0.
        wa_final-wemng = wa_afpo-wemng.
      ENDIF.

      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
          client           = sy-mandt
          objnr            = objnr
          spras            = 'E'
        IMPORTING
          line             = line
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      wa_final-status = line.


      name = wa_final-h_matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'GRUN'
          language                = 'E'
          name                    = name
          object                  = 'MATERIAL'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
      ENDIF.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF wa_lines-tdline IS NOT INITIAL.
            CONCATENATE wa_final-h_maktx wa_lines-tdline INTO wa_final-h_maktx SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
      APPEND wa_final TO it_final.
      CLEAR :wa_final,wa_afpo,wa_afko,wa_main.
    ENDIF.
    CLEAR :wa_final,wa_afpo,wa_afko,wa_main.
  ENDLOOP.

  IF p_down EQ 'X'.
    LOOP AT it_final INTO wa_final.
      wa_down-aufnr    = wa_final-aufnr.
      wa_down-matnr    = wa_final-matnr.

      IF wa_final-budat  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-budat
          IMPORTING
            output = wa_down-budat.

        CONCATENATE wa_down-budat+0(2) wa_down-budat+2(3) wa_down-budat+5(4)
                        INTO wa_down-budat SEPARATED BY '-'.
      ENDIF.

      wa_down-bdmng    = wa_final-bdmng.
      wa_down-enmng    = wa_final-enmng.
      wa_down-kdauf    = wa_final-kdauf.
      wa_down-kdpos    = wa_final-kdpos.
      wa_down-meins    = wa_final-meins.
      wa_down-maktx    = wa_final-maktx.
      wa_down-gamng    = wa_final-gamng.
      wa_down-h_matnr  = wa_final-h_matnr.
      wa_down-h_maktx  = wa_final-h_maktx.
      wa_down-so_matnr = wa_final-so_matnr.
      wa_down-kunnr    = wa_final-kunnr.
      wa_down-name1    = wa_final-name1 .
      wa_down-to_be    = wa_final-to_be .
      wa_down-rate     = wa_final-rate .
      wa_down-value    = wa_final-value .
      wa_down-status   = wa_final-status .
      wa_down-auart    = wa_final-auart .
      wa_down-wemng    = wa_final-wemng .
      wa_down-ref_time = sy-uzeit .
*BREAK primusabap.
      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)':' wa_down-ref_time+4(2) INTO wa_down-ref_time.
      wa_down-ref_date = sy-datum .

      IF wa_down-ref_date  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_down-ref_date
          IMPORTING
            output = wa_down-ref_date.

        CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                        INTO wa_down-ref_date SEPARATED BY '-'.
      ENDIF.

      IF wa_down-to_be = 0.
        wa_down-to_be = ' '.
      ENDIF.

      IF wa_down-rate = 0 .
        wa_down-rate = ' '.
      ENDIF.

      IF wa_down-value = 0.
        wa_down-value = ' '.
      ENDIF.

      IF wa_down-wemng = 0.
        wa_down-value = ' '.
      ENDIF.

      APPEND wa_down TO it_down.
      CLEAR :wa_down, wa_final..
    ENDLOOP.
  ENDIF.

  PERFORM fct.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = 'sy-repid'
      is_layout          = fs_layout
      it_fieldcat        = gt_fieldcat[]
      i_default          = 'X'
      i_save             = 'A'
    TABLES
      t_outtab           = it_final.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fct .
  REFRESH gt_fieldcat.
  PERFORM gt_fieldcatlog USING :

         'AUFNR'        'IT_FINAL'     'Production Order'               '1',
         'H_MATNR'      'IT_FINAL'     'Header Material'                '2',
         'h_maktx'      'IT_FINAL'     'Header Material Desc.'          '3',
         'MATNR'        'IT_FINAL'     'Component.'                     '4',
         'MAKTX'        'IT_FINAL'     'Component Description'          '5',
         'BUDAT'        'IT_FINAL'     'Confirmation Date'              '6',
         'BDMNG'        'IT_FINAL'     'Required Quantity'              '7',
         'ENMNG'        'IT_FINAL'     'Quantity Issued'                '8',
         'GAMNG'        'IT_FINAL'     'Prd Order Quantity'             '9',
         'MEINS'        'IT_FINAL'     'Unit'                           '10',
         'KDAUF'        'IT_FINAL'     'Sales Order'                    '11',
         'KDPOS'        'IT_FINAL'     'Sales ord. item'                '12',
         'SO_MATNR'     'IT_FINAL'     'So Material'                    '13',
         'KUNNR'        'IT_FINAL'     'Customer Code'                  '14',
         'NAME1'        'IT_FINAL'     'Customer Name'                  '15',
         'TO_BE'        'IT_FINAL'     'Difference'                     '16',
         'RATE'         'IT_FINAL'     'Rate'                           '17',
         'VALUE'        'IT_FINAL'     'Value'                          '18',
         'STATUS'       'IT_FINAL'     'Status'                         '19',
         'AUART'       'IT_FINAL'      'Order Type'                     '20',
         'WEMNG'       'IT_FINAL'      'Confirm Qty.'                   '21'.


  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GT_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0259   text
*      -->P_0260   text
*      -->P_0261   text
*      -->P_0262   text
*----------------------------------------------------------------------*
FORM gt_fieldcatlog   USING    v1 v2 v3 v4.

  gs_fieldcat-fieldname   = v1.
  gs_fieldcat-tabname     = v2.
  gs_fieldcat-seltext_l   = v3.
  gs_fieldcat-col_pos     = v4.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR  gs_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .

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
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

  lv_file = 'ZCOOIS_COMP_ISSUE.TXT'.

  CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

  WRITE: / 'ZCOOIS_COMP_ISSUE.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CLOSE DATASET lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE  'Production Order'
               'Header Material'
               'Header Material Desc.'
               'Component.'
               'Component Description'
               'Confirmation Date'
               'Required Quantity'
               'Quantity Issued'
               'Prd Order Quantity'
               'Unit'
               'Sales Order'
               'Sales ord. item'
               'So Material'
               'Customer Code'
               'Customer Name'
               'Difference'
               'Rate'
               'Value'
               'Status'
               'Order Type'
               'Confirm Qty'
               'Refreshable Date'
               'Refreshable Time'
               INTO p_hd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
