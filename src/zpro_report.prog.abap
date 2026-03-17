*&---------------------------------------------------------------------*
*& Report ZPRO_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpro_report.



TYPE-POOLS:slis.

TYPES : BEGIN OF ty_konv,
          knumv TYPE PRCD_ELEMENTS-knumv,
          kposn TYPE PRCD_ELEMENTS-kposn,
          stunr TYPE PRCD_ELEMENTS-stunr,
          zaehk TYPE PRCD_ELEMENTS-zaehk,
          kschl TYPE PRCD_ELEMENTS-kschl,
          kinak TYPE PRCD_ELEMENTS-kinak,
          kbetr TYPE PRCD_ELEMENTS-kbetr,
        END OF ty_konv.


TYPES: BEGIN OF ty_vbak,
         knumv TYPE vbak-knumv,
         vbeln TYPE vbak-vbeln,
         kunnr TYPE vbak-kunnr,
         vkorg TYPE vbak-vkorg,
         erdat TYPE vbak-erdat,
       END OF ty_vbak.

TYPES: BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         name1 TYPE kna1-name1,
       END OF ty_kna1.


TYPES: BEGIN OF ty_vbap,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         arktx  TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
       END OF ty_vbap.

TYPES: BEGIN OF ty_final,
         vbeln  TYPE vbak-vbeln,
         kunnr  TYPE vbak-kunnr,
         name1  TYPE kna1-name1,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         arktx  TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
         kbetr  TYPE PRCD_ELEMENTS-kbetr,
         knumv  TYPE PRCD_ELEMENTS-knumv,
         kposn  TYPE PRCD_ELEMENTS-kposn,
         stunr  TYPE PRCD_ELEMENTS-stunr,
         zaehk  TYPE PRCD_ELEMENTS-zaehk,
         kschl  TYPE PRCD_ELEMENTS-kschl,
         kinak  TYPE PRCD_ELEMENTS-kinak,
         vkorg  TYPE vbak-vkorg,
         erdat  TYPE vbak-erdat,
         REF_DAT TYPE char20,
         REF_TIME TYPE char20,
       END OF ty_final.


TYPES: BEGIN OF ty_down,
         "KNUMV TYPE CHAR20,
         "KPOSN TYPE CHAR20,
         "STUNR TYPE CHAR20,
         "ZAEHK TYPE CHAR20,
         "KSCHL TYPE CHAR20,
         "KINAK TYPE CHAR20,
         vbeln  TYPE char20,
         kunnr  TYPE char20,
         name1  TYPE char20,
         posnr  TYPE char20,
         matnr  TYPE char20,
         arktx  TYPE char20,
         kwmeng TYPE char20,
         kbetr  TYPE char20,
         REF_DAT TYPE char20,
         REF_TIME TYPE char20,
       END OF ty_down.

DATA : it_konv     TYPE TABLE OF ty_konv,
       wa_konv     TYPE ty_konv,

       it_konv1    TYPE TABLE OF ty_konv,
       wa_konv1    TYPE ty_konv,

       it_vbak     TYPE TABLE OF ty_vbak,
       wa_vbak     TYPE ty_vbak,

       it_vbak1    TYPE TABLE OF ty_vbak,
       wa_vbak1    TYPE ty_vbak,

       it_kna1     TYPE TABLE OF ty_kna1,
       wa_kna1     TYPE ty_kna1,

       it_vbap     TYPE TABLE OF ty_vbap,
       wa_vbap     TYPE ty_vbap,


       it_final    TYPE TABLE OF ty_final,
       wa_final    TYPE ty_final,

       it_down     TYPE TABLE OF ty_down,
       wa_down     TYPE ty_down,

       it_fieldcat TYPE slis_t_fieldcat_alv,
       wa_fieldcat TYPE slis_fieldcat_alv,

       ls_layout   TYPE slis_layout_alv.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
SELECT-OPTIONS   :  s_date FOR wa_vbak-erdat, "OBLIGATORY ,
                    s_kunnr FOR wa_vbak-kunnr,
                    s_vbeln FOR wa_vbap-vbeln,
                    s_vkorg FOR wa_vbak-vkorg OBLIGATORY DEFAULT 1000.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
PARAMETERS open_so  RADIOBUTTON GROUP code DEFAULT 'X' USER-COMMAND codegen.
PARAMETERS all_so  RADIOBUTTON GROUP code.
SELECTION-SCREEN END OF BLOCK b3.

*SELECT-OPTIONS:  s_kschl   FOR  wa_konv-kschl NO-DISPLAY .
*SELECT-OPTIONS:  s_stat   FOR  wa_jest1-stat NO-DISPLAY .

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-075.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN COMMENT /1(70) TEXT-077.
  SELECTION-SCREEN COMMENT /1(70) TEXT-078.
  SELECTION-SCREEN COMMENT /1(70) TEXT-079.
SELECTION-SCREEN: END OF BLOCK B4.


START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM display_data.
  PERFORM down_set.
  PERFORM new_file.
  " PERFORM DOWNLOAD_DATA.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  SELECT knumv
         vbeln
         kunnr
         vkorg
         erdat
         FROM vbak INTO TABLE it_vbak WHERE vkorg IN s_vkorg AND vbeln IN s_vbeln AND erdat IN s_date.


  IF it_vbak[] IS NOT INITIAL.

    SELECT knumv
           kposn
           stunr
           zaehk
           kschl
           kinak
           kbetr
           FROM PRCD_ELEMENTS INTO TABLE it_konv FOR ALL ENTRIES IN it_vbak WHERE knumv = it_vbak-knumv AND kschl = 'ZPR0' AND kinak NE ' '.

      SELECT knumv
             vbeln
             kunnr
             vkorg
             erdat FROM vbak INTO TABLE it_vbak1 FOR ALL ENTRIES IN it_konv WHERE knumv = it_konv-knumv.


    SELECT kunnr
           name1
           FROM kna1
           INTO TABLE it_kna1
           FOR ALL ENTRIES IN it_vbak1
           WHERE kunnr = it_vbak1-kunnr.


    SELECT vbeln
           posnr
           matnr
           arktx
           kwmeng
      FROM vbap
      INTO TABLE it_vbap
      FOR ALL ENTRIES IN it_vbak1
      WHERE vbeln = it_vbak1-vbeln.


  ENDIF.


    LOOP AT it_konv INTO wa_konv.
*    IF sy-subrc = 0.
      wa_final-kbetr = wa_konv-kbetr.
      wa_final-posnr = wa_konv-kposn.
      wa_final-stunr = wa_konv-stunr.
      wa_final-zaehk = wa_konv-zaehk.
      wa_final-kinak = wa_konv-kinak.
*    ENDIF.


  READ TABLE it_vbak1 INTO wa_vbak1 WITH KEY knumv = wa_konv-knumv.

    IF sy-subrc = 0.
      wa_final-vbeln = wa_vbak1-vbeln.
      wa_final-kunnr = wa_vbak1-kunnr.
      wa_final-knumv = wa_vbak1-knumv.
      wa_final-vkorg = wa_vbak-vkorg.
      wa_final-erdat = wa_vbak-erdat.
    ENDIF.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak1-kunnr.

    IF sy-subrc = 0.
      wa_final-name1 = wa_kna1-name1.
    ENDIF.


    READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_vbak1-vbeln
                                             posnr = wa_konv-kposn.
    IF sy-subrc = 0.
*      wa_final-posnr = wa_vbap-posnr.
      wa_final-matnr = wa_vbap-matnr.
      wa_final-arktx = wa_vbap-arktx.
      wa_final-kwmeng = wa_vbap-kwmeng.
    ENDIF.

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
  PERFORM create_feildcat.

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
  wa_fieldcat-fieldname = 'KUNNR'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Customer Code'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


  wa_fieldcat-col_pos = '3'.
  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Custumor Name'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


  wa_fieldcat-col_pos = '4'.
  wa_fieldcat-fieldname = 'POSNR'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Line Item No'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


  wa_fieldcat-col_pos = '5'.
  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Item Code'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.

  wa_fieldcat-col_pos = '6'.
  wa_fieldcat-fieldname = 'ARKTX'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Item Description'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.

  wa_fieldcat-col_pos = '7'.
  wa_fieldcat-fieldname = 'KWMENG'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'Quantity'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


  wa_fieldcat-col_pos = '8'.
  wa_fieldcat-fieldname = 'KBETR'.
  wa_fieldcat-tabname   = 'IT_FINAL'.
  wa_fieldcat-seltext_m  = 'ZPR0'.
  wa_fieldcat-outputlen = '12'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: wa_fieldcat.


ENDFORM.

FORM down_set .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).


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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.                "added for check
  lv_file = 'ZPR0_ALL.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPR0 Download started on', sy-datum, 'at', sy-uzeit.

  IF open_so IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
  "WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_412 TYPE string.
DATA lv_crlf_412 TYPE string.
lv_crlf_412 = cl_abap_char_utilities=>cr_lf.
lv_string_412 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_412 lv_crlf_412 wa_csv INTO lv_string_412.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1507 TO lv_fullfile.
TRANSFER lv_string_412 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


******************************************************new file zpr0 **********************************
  PERFORM new_file.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.       "added for check
  lv_file = 'ZPR0_OPEN.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPR0 Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_450 TYPE string.
DATA lv_crlf_450 TYPE string.
lv_crlf_450 = cl_abap_char_utilities=>cr_lf.
lv_string_450 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_450 lv_crlf_450 wa_csv INTO lv_string_450.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1507 TO lv_fullfile.
TRANSFER lv_string_450 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

ENDFORM.

FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE
          'SO No'
          'Customer Code'
          'Customer Name'
          'Line Item No'
          'Item Code'
          'Item Decription'
          'Quantity'
          'ZPR0'
          'Ref Date'
          'Ref time'
  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
FORM new_file .

  LOOP AT it_final INTO wa_final.
    wa_down-vbeln = wa_final-vbeln.
    wa_down-kunnr = wa_final-kunnr.
    wa_down-name1 = wa_final-name1.
    wa_down-posnr = wa_final-posnr.
    wa_down-matnr = wa_final-matnr.
    wa_down-arktx = wa_final-arktx.
    wa_down-kwmeng = wa_final-kwmeng.
    wa_down-kbetr = wa_final-kbetr.
    wa_DOWN-ref_dat = sy-datum.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_DOWN-ref_dat
        IMPORTING
          output = wa_DOWN-ref_dat.

      CONCATENATE wa_DOWN-ref_dat+0(2) wa_DOWN-ref_dat+2(3) wa_DOWN-ref_dat+5(4)
                      INTO wa_DOWN-ref_dat SEPARATED BY '-'.

      wa_DOWN-ref_time = sy-uzeit.
      CONCATENATE wa_DOWN-ref_time+0(2) ':' wa_DOWN-ref_time+2(2)  INTO wa_DOWN-ref_time.


    APPEND wa_down TO it_down.
  ENDLOOP.
ENDFORM.
