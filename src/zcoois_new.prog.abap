*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
*  Copyright        : PRIMUS TECHSYSTEMS PVT LTD
*  Program Name     :
*  Program Type     :
*  Package          :
*  Functional       :
*  Developed By     :
*  Initiated on     :
*  Completed on     :
*  Final Release on :
*&---------------------------------------------------------------------*
REPORT ZCOOIS_NEW.
TABLES : afru,afpo,aufk,mara,afko.
DATA : lt_ioconf TYPE STANDARD TABLE OF ioconf.
DATA : ls_ioconf TYPE  ioconf.
DATA : lt_iogomo TYPE STANDARD TABLE OF iogomo.
DATA : ls_iogomo TYPE  iogomo.
DATA : lt_IOHEADER TYPE STANDARD TABLE OF IOHEADER.
DATA : ls_IOHEADER TYPE  IOHEADER.
DATA : lt_IOMAMO TYPE STANDARD TABLE OF IOMAMO.
DATA : ls_IOMAMO TYPE  IOMAMO.
DATA : ls_layout TYPE slis_layout_alv.
DATA : gt_fieldcat TYPE slis_t_fieldcat_alv,
       gs_fieldcat TYPE slis_fieldcat_alv.

  DATA : ls_line    TYPE slis_listheader,
         vn_top     TYPE slis_t_listheader,
         l_line(40),
         line         TYPE string.

DATA :  object_tab-sttxt TYPE bsvx-sttxt.

TYPES : BEGIN OF ty_coois,
  aufnr type aufk-aufnr,
  matnr type mara-matnr,
  matxt type TEXT40,
  MENGE type RESB-ENMNG,
  DENMNG type RESB-ENMNG,
  V_DIFF type RESB-BDMNG,
  DFMENG type RESB-FLMNG,
  MEINS type RESB-MEINS,
  STTXT type string,
  erdat type caufv-erdat,
  txt04 TYPE string,
  gltri TYPE afko-gltri,
  END OF ty_coois.

  data : gt_tbl type STANDARD TABLE OF ty_coois,
         gw_tbl type ty_coois.

data : lv_stat type jest-stat,
       lv_OBJNR type caufv-objnr.

TYPES : BEGIN OF ty_down,
  aufnr type aufk-aufnr,
  matnr type mara-matnr,
  matxt type TEXT40,
  MENGE type RESB-ENMNG,
  DENMNG type RESB-ENMNG,
  V_DIFF type RESB-BDMNG,
  DFMENG type RESB-FLMNG,
  MEINS type RESB-MEINS,
  STTXT type string,
  erdat type char15,
  gltri TYPE char15,
  txt04 TYPE string,
  ref_dat  TYPE char15,                         "Refresh Date
  ref_time TYPE char15,                         "Refresh Time
  END OF ty_down.

  DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE ty_down.

DATA: v_repid LIKE sy-repid.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS : p_aufnr    FOR aufk-aufnr,
                 p_matnr    FOR mara-matnr,
                 p_werks    FOR afru-werks OBLIGATORY,
                 p_AUART    FOR AUFK-AUART no INTERVALS OBLIGATORY,
                 p_gltri    FOR afko-gltri.
SELECTION-SCREEN : END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.




INITIALIZATION.
  v_repid = sy-repid.

START-OF-SELECTION.
  FIELD-SYMBOLS <lt_final> TYPE ANY TABLE.
  DATA lr_final TYPE REF TO data.
  DATA lt_final TYPE REF TO data.

  cl_salv_bs_runtime_info=>set( EXPORTING display  = abap_false
                                          metadata = abap_false
                                          data     = abap_true ).

    PERFORM confirmation.

FORM confirmation .
  SUBMIT ppio_entry
*  WITH ppio_entry_sc100-ppio_listtyp = 'COMPONENTS'
                  USING SELECTION-SET 'COOIS_COMP'
*                  WITH ppio_entry_sc1100-alv_variant = '/0000000001'
                  WITH s_werks   IN p_werks
                  WITH s_aufnr   IN p_aufnr
                  WITH s_matnr   IN p_matnr
                  WITH s_AUART   IN p_AUART
                  WITH s_gltri   IN p_gltri
                  AND RETURN.
  TRY.
      cl_salv_bs_runtime_info=>get_data_ref( IMPORTING r_data = lr_final ).

      ASSIGN lr_final->* TO <lt_final>.
    CATCH cx_salv_bs_sc_runtime_info.
      MESSAGE `Unable to retrieve ALV data` TYPE 'E'.
  ENDTRY.

  cl_salv_bs_runtime_info=>clear_all( ).

if <lt_final> is not ASSIGNED.
  message 'Data Not Availabe For Selection Criteria.' type 'E'.
endif.
  MOVE-CORRESPONDING <lt_final> TO lt_ioconf.
  MOVE-CORRESPONDING <lt_final> TO gt_tbl.

loop at gt_tbl into gw_tbl.
*  select single maktx from makt into gw_tbl-maktx where matnr = gw_tbl-matnr.
*    select single FLMNG from resb into gw_tbl-FLMNG where matnr = gw_tbl-matnr.
      select single OBJNR erdat from CAUFV into (lv_OBJNR ,gw_tbl-erdat)  where aufnr = gw_tbl-aufnr.
*        select single stat from jest into lv_stat where OBJNR = lv_OBJNR.
          SELECT SINGLE gltri FROM AFKO INTO gw_tbl-gltri WHERE AUFNR = gw_tbl-aufnr.
*          select single txt04 from TJ02 into gw_tbl-status where stat = lv_stat.
    gw_tbl-V_DIFF = gw_tbl-MENGE - gw_tbl-DENMNG.

CALL FUNCTION 'STATUS_TEXT_EDIT'
              EXPORTING
                client            = sy-mandt
*                flg_user_stat     = 'X'
                objnr             = lv_OBJNR
               ONLY_ACTIVE       = 'X'
                spras             = sy-langu
*               BYPASS_BUFFER     = ' '
              IMPORTING
*                anw_stat_existing = ld_anw_stat_existing
*                e_stsma           = ld_e_stsma
                line              = object_tab-sttxt
*                user_line         = ld_user_line
*                stonr             = ld_stonr
              EXCEPTIONS
                object_not_found  = 1
                OTHERS            = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.

             gw_tbl-txt04       = object_tab-sttxt.

    MODIFY gt_tbl from gw_tbl .
    clear gw_tbl.
  endloop.

  DELETE gt_tbl[] WHERE gltri NOT IN  p_gltri .
gs_fieldcat-col_pos = '1' .
  gs_fieldcat-fieldname = 'AUFNR' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Order' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .


  gs_fieldcat-col_pos = '2' .
  gs_fieldcat-fieldname = 'MATNR' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Material' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

  gs_fieldcat-col_pos = '3' .
  gs_fieldcat-fieldname = 'MATXT' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Material Description' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

  gs_fieldcat-col_pos = '4' .
  gs_fieldcat-fieldname = 'MENGE' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Requirement Quantity' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .


  gs_fieldcat-col_pos = '5' .
  gs_fieldcat-fieldname = 'DENMNG' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Quantity withdrawn' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

  gs_fieldcat-col_pos = '6' .
  gs_fieldcat-fieldname = 'V_DIFF' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Difference' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .


  gs_fieldcat-col_pos = '7' .
  gs_fieldcat-fieldname = 'DFMENG' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Shortage' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

  gs_fieldcat-col_pos = '8' .
  gs_fieldcat-fieldname = 'MEINS' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Base Unit of Measure' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

  gs_fieldcat-col_pos = '9' .
  gs_fieldcat-fieldname = 'STTXT' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Status' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

   gs_fieldcat-col_pos = '10' .
  gs_fieldcat-fieldname = 'ERDAT' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Created On' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

    gs_fieldcat-col_pos = '11' .
  gs_fieldcat-fieldname = 'TXT04' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'System Status' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .

    gs_fieldcat-col_pos = '12' .
  gs_fieldcat-fieldname = 'GLTRI' .
  gs_fieldcat-tabname = 'gt_tbl' .
  gs_fieldcat-seltext_l = 'Actual Finish' .
  APPEND gs_fieldcat TO gt_fieldcat .
  CLEAR gs_fieldcat .


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP'
      is_layout              = ls_layout
      it_fieldcat            = gt_fieldcat[]
      i_save                 = 'A'
    TABLES
      t_outtab               = gt_tbl
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
  ENDIF.

ENDFORM.


form top.
  DATA: lt_listheader TYPE TABLE OF slis_listheader,
        ls_listheader TYPE slis_listheader,
        ls_month_name TYPE t7ru9a-regno,
        gs_string     TYPE string,
        gs_month(2)   TYPE n,
        t_line        LIKE ls_listheader-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

  REFRESH lt_listheader.
  CLEAR ls_listheader.

  DESCRIBE TABLE gt_tbl LINES line.
  ls_line-typ = 'S'.
  ls_line-key  = 'TOTAL NO.OF RECORDS:'(108).
  ls_line-info = line.
  APPEND ls_line TO vn_top.
  CLEAR: ls_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = vn_top
*      i_logo             = ''
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
.
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

  LOOP AT gt_tbl INTO gw_tbl.

    IF sy-subrc = 0.

ls_down-aufnr  = gw_tbl-aufnr .
ls_down-matnr  = gw_tbl-matnr .
ls_down-matxt  = gw_tbl-matxt .
ls_down-MENGE   = gw_tbl-MENGE  .
ls_down-DENMNG  = gw_tbl-DENMNG .
ls_down-V_DIFF = gw_tbl-V_DIFF.
ls_down-DFMENG = gw_tbl-DFMENG.
ls_down-MEINS  = gw_tbl-MEINS .
ls_down-STTXT  = gw_tbl-STTXT .

ls_down-erdat  = gw_tbl-erdat .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_down-erdat
        IMPORTING
          output = ls_down-erdat.
      CONCATENATE ls_down-erdat+0(2) ls_down-erdat+2(3) ls_down-erdat+5(4)
     INTO ls_down-erdat SEPARATED BY '-'.

ls_down-gltri  = gw_tbl-gltri .
if ls_down-gltri NE '00000000'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_down-gltri
        IMPORTING
          output = ls_down-gltri.
      CONCATENATE ls_down-gltri+0(2) ls_down-gltri+2(3) ls_down-gltri+5(4)
     INTO ls_down-gltri SEPARATED BY '-'.
else.
  ls_down-gltri = space.
  endif.

ls_down-txt04  = gw_tbl-txt04 .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = ls_down-ref_dat.
      CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
     INTO ls_down-ref_dat SEPARATED BY '-'.

      ls_down-ref_time = sy-uzeit.
      CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.


      APPEND ls_down TO lt_down.
      CLEAR: ls_down.

* lt_down[] = it_final[].
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM download_file .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZCOOIS_NEW.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZCOOIS_NEW Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
DATA lv_string_430 TYPE string.
DATA lv_crlf_430 TYPE string.
lv_crlf_430 = cl_abap_char_utilities=>cr_lf.
lv_string_430 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_430 lv_crlf_430 wa_csv INTO lv_string_430.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_430 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.

FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE  'Order'
               'Material'
               'Material Description'
               'Requirement Quantity'
               'Quantity withdrawn'
               'Difference'
               'Shortage'
               'Base Unit of Measure'
               'Status'
               'Created On'
               'ACTUAL FINISH'
               'SYSTEM STATUS'
               'Refresh date'
               'Refresh time'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
