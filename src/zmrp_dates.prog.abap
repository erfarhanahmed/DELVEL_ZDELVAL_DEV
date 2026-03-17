*&---------------------------------------------------------------------*
*& Report ZMRP_DATES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmrp_dates.

TABLES : vbak, vbap.


TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          kunnr TYPE vbak-kunnr,
          vkorg TYPE vbak-vkorg,
        END OF ty_vbak.


DATA : it_vbak TYPE TABLE OF  ty_vbak,
       wa_vbak TYPE ty_vbak.

TYPES : BEGIN OF ty_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
          werks TYPE vbap-werks,
        END OF ty_vbap.

DATA : it_vbap TYPE TABLE OF  ty_vbap,
       wa_vbap TYPE ty_vbap.

TYPES : BEGIN OF ty_data,
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          matnr TYPE matnr,
          lfsta TYPE vbup-lfsta,
          lfgsa TYPE vbup-lfgsa,
          fksta TYPE vbup-fksta,
          absta TYPE vbup-absta,
          gbsta TYPE vbup-gbsta,
*         WERKS TYPE WERKS,
        END OF ty_data.

DATA: it_data TYPE STANDARD TABLE OF ty_data,
      ls_data TYPE ty_data.

TYPES : BEGIN OF ty_konv,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          kbetr TYPE prcd_elements-kbetr,
          waers TYPE prcd_elements-waers,
          kwert TYPE prcd_elements-kwert,
        END OF ty_konv.

DATA : it_konv TYPE TABLE OF ty_konv,
       wa_konv TYPE ty_konv.


TYPES : BEGIN OF ty_vbep,
          vbeln TYPE vbep-vbeln,
          posnr TYPE vbep-posnr,
          etenr TYPE vbep-etenr,
          ettyp TYPE vbep-ettyp,
          edatu TYPE vbep-edatu,
        END OF ty_vbep.

DATA : it_vbep TYPE TABLE OF ty_vbep,
       wa_vbep TYPE ty_vbep.

TYPES : BEGIN OF ty_jest,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
        END OF ty_jest.

DATA : it_jest TYPE TABLE OF ty_jest,
       wa_jest TYPE ty_jest.

TYPES : BEGIN OF ty_vbpa,
          vbeln TYPE vbpa-vbeln,
          posnr TYPE vbpa-posnr,
          parvw TYPE vbpa-parvw,
          kunnr TYPE vbpa-kunnr,
          adrnr TYPE vbpa-adrnr,
          land1 TYPE vbpa-land1,
        END OF ty_vbpa.

DATA : lt_vbpa TYPE TABLE OF ty_vbpa,
       ls_vbpa TYPE ty_vbpa.


TYPES : BEGIN OF ty_mara,
          matnr     TYPE mara-matnr,
          item_type TYPE mara-item_type,
        END OF ty_mara.

DATA : it1_mara TYPE TABLE OF ty_mara,
       wa1_mara TYPE ty_mara.
DATA : tz TYPE timezone.


*TYPES : BEGIN OF ty_cdpos,
*          changenr TYPE  cdchangenr,
*          tabkey    TYPE cdtabkey,
*        END OF ty_cdpos.

DATA : it_cdpos TYPE STANDARD TABLE OF cdpos,
       wa_cdpos TYPE cdpos.

*TYPES : BEGIN OF ty_cdhdr,
*          changenr TYPE  cdchangenr,
*          udate    TYPE cddatum,
*        END OF ty_cdhdr.

DATA: it_cdhdr TYPE STANDARD TABLE OF cdhdr,
      wa_cdhdr TYPE cdhdr.

TYPES : BEGIN OF output,
          werks    TYPE werks_ext,
          vbeln    TYPE vbak-vbeln,
          posnr    TYPE vbap-posnr,
          mrp_dt   TYPE udate,
          ref_on    TYPE char15,
          ref_time TYPE char10,
        END OF output.

DATA : it_output TYPE STANDARD TABLE OF output,
       wa_output TYPE output.


TYPES: BEGIN OF t_final,
         werks    TYPE werks_ext,
         vbeln    TYPE vbak-vbeln,
         posnr    TYPE vbap-posnr,
         mrp_dt   TYPE char11, "udate,
         ref_on    TYPE char15,
         ref_time TYPE char10,
       END OF t_final,

       tt_final TYPE STANDARD TABLE OF t_final.
DATA : gt_final TYPE tt_final.



TYPE-POOLS : slis.
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      fieldlayout  TYPE slis_layout_alv,

      it_fcat      TYPE slis_t_fieldcat_alv,
      wa_fcat      TYPE LINE OF slis_t_fieldcat_alv. " SLIS_T_FIELDCAT_ALV.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA

************************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname
                                   VALUE 'TOP_OF_PAGE',
  c_formname_pf_status_set TYPE slis_formname
                                 VALUE 'PF_STATUS_SET',
  c_s                      TYPE c VALUE 'S',
  c_h                      TYPE c VALUE 'H'.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
SELECT-OPTIONS   :  s_vkorg FOR wa_vbak-vkorg,
                    s_date FOR wa_vbak-erdat OBLIGATORY ,
                    s_vbeln FOR wa_vbap-vbeln.
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
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-075.
SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
SELECTION-SCREEN COMMENT /1(70) TEXT-077.
SELECTION-SCREEN COMMENT /1(70) TEXT-078.
SELECTION-SCREEN COMMENT /1(70) TEXT-079.
SELECTION-SCREEN: END OF BLOCK b4.



DATA: ls_exch_rate TYPE bapi1093_0.

START-OF-SELECTION.


  IF open_so = 'X'.

    SELECT a~vbeln
           a~posnr
           a~matnr
           b~lfsta
           b~lfgsa
           b~fksta
           b~absta
           b~gbsta
    INTO TABLE it_data
    FROM  vbap AS a
    JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )

    WHERE a~erdat  IN s_date
*    WHERE C~AUDAT  IN S_DATE
*    AND   a~matnr  IN s_matnr
    AND   a~vbeln  IN s_vbeln
    AND   b~lfsta  NE 'C'
    AND   b~lfgsa  NE 'C'
    AND   b~fksta  NE 'C'
    AND   b~gbsta  NE 'C'.



    LOOP AT it_data INTO ls_data.
      IF ls_data-absta = 'C'.
        IF ls_data-lfsta = ' ' AND ls_data-lfgsa = ' ' AND ls_data-fksta = ' ' AND ls_data-gbsta = ' '.
          IF sy-subrc = 0.
*
            DELETE it_data[]  WHERE vbeln = ls_data-vbeln AND posnr = ls_data-posnr.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF it_data[] IS NOT INITIAL.
      SELECT vbeln
             erdat
             kunnr
             FROM vbak INTO TABLE it_vbak
             FOR ALL ENTRIES IN it_data WHERE vbeln = it_data-vbeln.  " AND kunnr IN s_kunnr.
      PERFORM fill_tables.
      PERFORM process_for_output.
      IF p_down IS   INITIAL.
        PERFORM alv_for_output.

      ELSE.
        PERFORM down_set.
      ENDIF.

    ENDIF.
  ELSEIF all_so = 'X'.
    SELECT vbeln
           erdat
           kunnr
           FROM vbak INTO TABLE it_vbak WHERE erdat IN s_date AND
                                                vbeln IN s_vbeln. " AND kunnr IN s_kunnr .
    IF sy-subrc = 0.
      PERFORM fill_tables.
      PERFORM process_for_output.
      IF p_down IS   INITIAL.
        PERFORM alv_for_output.

      ELSE.
*        BREAK Primus.
        PERFORM down_set_all.
      ENDIF.
    ENDIF.

*  ELSE.

  ENDIF.

FORM fill_tables .

*BREAK primus.

  IF open_so = 'X'.
    SELECT vbeln
           posnr
           matnr
           werks
           FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_data WHERE vbeln = it_data-vbeln
                                       AND posnr = it_data-posnr
                                       AND werks = 'PL01'.
    LOOP AT it_vbak INTO wa_vbak .
      LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln.
*        DELETE it_vbap WHERE vbeln = wa_vbap-vbeln AND posnr = wa_vbap-posnr.
      ENDLOOP.
    ENDLOOP.


  ELSE.
    SELECT vbeln
           posnr
           matnr
           werks
           FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbak WHERE vbeln = it_vbak-vbeln
                                        AND werks = 'PL01'.
  ENDIF.
  IF it_vbap[] IS NOT INITIAL.


    SELECT vbeln
           posnr
           parvw
           kunnr
*           adrnr
*           land1
           FROM vbpa INTO TABLE lt_vbpa
           FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln.


  ENDIF.
ENDFORM.

FORM process_for_output .

  DATA: lv_ratio TYPE resb-enmng,
        lv_qty   TYPE resb-enmng,
        lv_index TYPE sy-tabix.

  IF it_vbap[] IS NOT INITIAL.
    CLEAR: wa_vbap, wa_vbak.

    SORT it_vbap BY vbeln posnr werks.

    LOOP AT it_vbap INTO wa_vbap.

      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln.

      IF sy-subrc = 0.

        wa_output-posnr       = wa_vbap-posnr.           "item
        wa_output-werks       = wa_vbap-werks.           "PLANT
        wa_output-vbeln       = wa_vbap-vbeln.

      ENDIF.


*MRP DATE
      CLEAR wa_cdpos.
      DATA tabkey TYPE cdpos-tabkey.
      CONCATENATE sy-mandt wa_vbap-vbeln wa_vbap-posnr INTO tabkey.

      SELECT *  FROM cdpos INTO TABLE it_cdpos WHERE tabkey = tabkey.
*                                           AND tabname = 'VBEP' AND fname = 'ETTYP'.

*      DATA : r_objectclas TYPE RANGE OF cdpos-objectclas.
*
*      SELECT * FROM cdpos INTO TABLE it_cdpos
*    WHERE objectclas IN r_objectclas
*    AND   tabkey  = tabkey.   " AND   tabname = 'VBEP'  AND   fname   = 'ETTYP'.

      SORT it_cdpos BY changenr DESCENDING.
      READ TABLE it_cdpos INTO wa_cdpos INDEX 1.
*      IF wa_cdpos-value_new = 'CP' .
      SELECT SINGLE * FROM cdhdr INTO wa_cdhdr WHERE changenr = wa_cdpos-changenr.

      wa_output-mrp_dt      = wa_cdhdr-udate.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar

*        wa_output-ref_on = sy-datum.

      wa_output-ref_time = sy-uzeit.
      CONCATENATE wa_output-ref_time+0(2) ':' wa_output-ref_time+2(2)  INTO wa_output-ref_time.


      APPEND wa_output TO it_output.
      CLEAR wa_vbep.
      CLEAR wa_output.

*      ENDIF.
      CLEAR wa_cdhdr.

    ENDLOOP.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_for_output .

  PERFORM stp3_eventtab_build   CHANGING gt_events[].
  PERFORM comment_build         CHANGING i_list_top_of_page[].
  PERFORM top_of_page.
  PERFORM layout_build          CHANGING wa_layout.


  PERFORM build_fieldcat USING 'WERKS'          'X' '1'   'Plant'(003)                    '15'.
  PERFORM build_fieldcat USING 'VBELN'          'X' '2'   'Sales Order No'(008)             '15'.
  PERFORM build_fieldcat USING 'POSNR'          'X' '3'   'Position Number'(017)               '15'.
  PERFORM build_fieldcat USING 'MRP_DT'         'X' '4'   'MRP Date'(045)                '15'.
  PERFORM build_fieldcat USING 'REF_TIME'       'X' '5'   'Ref. Time'             '15'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
      it_sort            = i_sort
      i_save             = 'A'
      it_events          = gt_events[]
    TABLES
      t_outtab           = it_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  REFRESH it_output.
ENDFORM.

FORM stp3_eventtab_build  CHANGING p_gt_events TYPE slis_t_event.

  DATA: lf_event TYPE slis_alv_event. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = p_gt_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_gt_events  FROM  lf_event INDEX 3 TRANSPORTING form.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM comment_build CHANGING i_list_top_of_page TYPE slis_t_listheader.
  DATA: lf_line       TYPE slis_listheader. "WORK AREA

  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info =  ''(042).
  APPEND lf_line TO i_list_top_of_page.

  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = TEXT-043.
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_list_top_of_page[].


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.


  wa_layout-zebra          = 'X'.
*
  p_wa_layout-zebra          = 'X'.
  p_wa_layout-no_colhead        = ' '.

ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM build_fieldcat  USING    v1  v2 v3 v4 v5.
  wa_fcat-fieldname   = v1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_OUTPUT'.  "'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
  wa_fcat-key         =  v2 ."  'X'.
  wa_fcat-seltext_l   =  v4.
  wa_fcat-outputlen   =  v5." 20.
*  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.
  wa_fcat-col_pos     =  v3.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT



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
      i_tab_sap_data       = it_output
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

  lv_file = 'ZMRP_DATES.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMRP_DATES Download started on', sy-datum, 'at', sy-uzeit.
  IF open_so IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
*  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_588 TYPE string.
DATA lv_crlf_588 TYPE string.
lv_crlf_588 = cl_abap_char_utilities=>cr_lf.
lv_string_588 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_588 lv_crlf_588 wa_csv INTO lv_string_588.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
*TRANSFER lv_string_830 TO lv_fullfile.
TRANSFER lv_string_588 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


******************************************************new file **********************************
  PERFORM new_file.
*  break primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

  lv_file = 'ZMRP_DATES.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMRP_DATES Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_625 TYPE string.
DATA lv_crlf_625 TYPE string.
lv_crlf_625 = cl_abap_char_utilities=>cr_lf.
lv_string_625 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_625 lv_crlf_625 wa_csv INTO lv_string_625.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
*TRANSFER lv_string_830 TO lv_fullfile.
TRANSFER lv_string_625 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.

FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE   'PLANT'
                'SALES ORDER NO'
                'POSITION NO'
                'MRP DATE'
                'Ref On'
                'Ref. Time'
  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.

FORM new_file .


  DATA:ls_final TYPE t_final.
  LOOP AT it_output INTO wa_output.

    ls_final-werks       = wa_output-werks.
    ls_final-vbeln       = wa_output-vbeln.
    ls_final-posnr       = wa_output-posnr.

    IF wa_output-mrp_dt IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-mrp_dt
        IMPORTING
          output = ls_final-mrp_dt.
      CONCATENATE ls_final-mrp_dt+0(2) ls_final-mrp_dt+2(3) ls_final-mrp_dt+5(4)
                     INTO ls_final-mrp_dt SEPARATED BY '-'.
    ENDIF.

 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = ls_final-ref_on.
      CONCATENATE ls_final-ref_on+0(2) ls_final-ref_on+2(3) ls_final-ref_on+5(4)
     INTO ls_final-ref_on SEPARATED BY '-'.



    ls_final-ref_time          = wa_output-ref_time.

    APPEND ls_final TO gt_final.
    CLEAR: ls_final,wa_output.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  DOWN_SET_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down_set_all .

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
      i_tab_sap_data       = it_output
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZMRP_DATES_ALL.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMRP_DATES Download started on', sy-datum, 'at', sy-uzeit.
  IF open_so IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
*  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_746 TYPE string.
DATA lv_crlf_746 TYPE string.
lv_crlf_746 = cl_abap_char_utilities=>cr_lf.
lv_string_746 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_746 lv_crlf_746 wa_csv INTO lv_string_746.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
*TRANSFER lv_string_830 TO lv_fullfile.
TRANSFER lv_string_746 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


******************************************************new file zpendso **********************************
  PERFORM new_file.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*

*lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZMRP_DATES_ALL.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMRP_DATES Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_785 TYPE string.
DATA lv_crlf_785 TYPE string.
lv_crlf_785 = cl_abap_char_utilities=>cr_lf.
lv_string_785 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_785 lv_crlf_785 wa_csv INTO lv_string_785.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
*TRANSFER lv_string_830 TO lv_fullfile.
TRANSFER lv_string_785 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
