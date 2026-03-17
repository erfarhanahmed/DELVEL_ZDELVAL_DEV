*&---------------------------------------------------------------------*
*& Report ZSALE_ORD_VALI_REF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsale_ord_vali_ref.


TABLES :vbak,zsales_ord_valid.


TYPES : BEGIN OF ty_zsales,
          vbeln  TYPE zsales_ord_valid-vbeln,
          posnr  TYPE zsales_ord_valid-posnr,
          status TYPE zsales_ord_valid-status,
          lvbeln TYPE zsales_ord_valid-lvbeln,
          ernam  TYPE zsales_ord_valid-ernam,
          zabdat TYPE zsales_ord_valid-zabdat,
        END OF ty_zsales.


DATA : it_sale TYPE TABLE OF ty_zsales,
       wa_sale TYPE ty_zsales.

DATA : it_final TYPE TABLE OF ty_zsales,
       wa_final TYPE ty_zsales.


TYPES : BEGIN OF ty_down,
          vbeln    TYPE char25,
          posnr    TYPE char25,
          status   TYPE char25,
          lvbeln   TYPE char25,
          ernam    TYPE char25,
          zabdat   TYPE char25,
          ref_dat  TYPE char15,                         "Refresh Date
          ref_time TYPE char15,                        "Refresh Time
        END OF ty_down.


DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.


DATA : wa_fcat   TYPE  slis_fieldcat_alv,                         "Field catalog work area
       i_fcat    TYPE  slis_t_fieldcat_alv,                        "field catalog internal table
       gd_layout TYPE  slis_layout_alv.                            "ALV layout settings


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : p_vbeln FOR vbak-vbeln.

SELECTION-SCREEN : END OF BLOCK b1.



SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-075.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN : END OF BLOCK b4.


START-OF-SELECTION.

  SELECT vbeln
         posnr
         status
         lvbeln
         ernam
         zabdat FROM zsales_ord_valid INTO TABLE it_sale WHERE vbeln IN p_vbeln.


  LOOP AT it_sale INTO wa_sale.


    wa_final-vbeln = wa_sale-vbeln.
    wa_final-posnr = wa_sale-posnr.
    wa_final-status = wa_sale-status.
    wa_final-lvbeln = wa_sale-lvbeln.
    wa_final-ernam = wa_sale-ernam.
    wa_final-zabdat = wa_sale-zabdat.


    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.



  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'VBELN' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Sales Ord Number' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'POSNR' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Position Number' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'STATUS' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Status' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'LVBELN' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Linked Sale Order' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'ERNAM' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Name of Person Who Created the Object' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'ZABDAT' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Date of Modification' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  gd_layout-zebra = 'X'.
  gd_layout-colwidth_optimize = 'X' .


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gd_layout
      it_fieldcat        = i_fcat[]
    TABLES
      t_outtab           = it_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .

  LOOP AT it_final INTO wa_final.


    IF sy-subrc = 0.

      ls_down-vbeln     = wa_final-vbeln.
      ls_down-posnr    = wa_final-posnr.
      ls_down-status   = wa_final-status.
      ls_down-lvbeln   = wa_final-lvbeln.
      ls_down-ernam    = wa_final-ernam.

*    ls_down-zabdat   = wa_final-zabdat.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-zabdat
        IMPORTING
          output = ls_down-zabdat.
      CONCATENATE ls_down-zabdat+0(2) ls_down-zabdat+2(3) ls_down-zabdat+5(4)
     INTO ls_down-zabdat SEPARATED BY '-'.


*      IF  wa_final-zabdat = 0.
*        ls_down-zabdat = space.
*      ELSE.
*        ls_down-zabdat = wa_final-zabdat.
*      ENDIF.


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

    ENDIF.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
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
  lv_file = 'ZSALE_ORD_VALI.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZSALE_ORD_VALI started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_278 TYPE string.
DATA lv_crlf_278 TYPE string.
lv_crlf_278 = cl_abap_char_utilities=>cr_lf.
lv_string_278 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_278 lv_crlf_278 wa_csv INTO lv_string_278.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_278 TO lv_fullfile.
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

  CONCATENATE  'Sales Ord Number'
               'Position Number'
               'Status'
               'Linked sale order'
               'User Name'
               'Date of Modification'
               'Refresh date'
               'Refresh time'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
