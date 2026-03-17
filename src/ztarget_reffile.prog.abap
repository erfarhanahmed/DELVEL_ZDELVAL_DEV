*&---------------------------------------------------------------------*
*& Report ZTARGET_REFFILE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztarget_reffile.

TABLES : ztarget.

TYPES : BEGIN OF ty_data,

          zsr_no   TYPE ztarget-zsr_no,
          branch_n TYPE ztarget-branch_n,
          branch   TYPE ztarget-branch,
          b_head   TYPE ztarget-b_head,
          zmonth   TYPE ztarget-zmonth,
          zyear    TYPE ztarget-zyear,
          ztarget  TYPE ztarget-ztarget,

        END OF ty_data.

DATA : it_data  TYPE TABLE OF ty_data,
       wa_data  TYPE ty_data,

       it_final TYPE TABLE OF ty_data,
       wa_final TYPE ty_data.


TYPES : BEGIN OF ty_down,

          zsr_no   TYPE char20,  "ztarget-zsr_no,  "char20,
          branch_n TYPE char20,  "ztarget-branch_n,
          branch   TYPE char20,   "ztarget-branch,
          b_head   TYPE char20,   "ztarget-b_head,
          zmonth   TYPE char20,  "ztarget-zmonth,
          zyear    TYPE char20,  "ztarget-zyear,
          ztarget  TYPE char20,  "ztarget-ztarget,
          ref_dat  TYPE char15,                         "Refresh Date
          ref_time TYPE char15,

        END OF ty_down.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.


DATA : wa_fcat   TYPE  slis_fieldcat_alv,                         "Field catalog work area
       i_fcat    TYPE  slis_t_fieldcat_alv,                        "field catalog internal table
       gd_layout TYPE slis_layout_alv.                            "ALV layout settings


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.  "Selection Scrren for TMG
SELECT-OPTIONS: s_month   FOR ztarget-zmonth,
                s_year    FOR ztarget-zyear,
                s_branch  FOR ztarget-branch_n.
SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

START-OF-SELECTION.

*BREAK primus.

  SELECT    zsr_no
            branch_n
            branch
            b_head
            zmonth
            zyear
            ztarget FROM ztarget INTO TABLE it_data WHERE zmonth IN s_month AND zyear IN  s_year AND  branch_n IN s_branch.


  LOOP AT it_data INTO wa_data.

    IF sy-subrc = 0.

      wa_final-zsr_no     = wa_data-zsr_no.
      wa_final-branch_n   = wa_data-branch_n.
      wa_final-branch     = wa_data-branch.
      wa_final-b_head     = wa_data-b_head.
      wa_final-zmonth     = wa_data-zmonth.
      wa_final-zyear      = wa_data-zyear.
      wa_final-ztarget    = wa_data-ztarget.

    ENDIF.

    APPEND wa_final TO it_final.
    CLEAR wa_final.

  ENDLOOP.


   wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ZSR_NO' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Serial No' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

   wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'BRANCH_N' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Branch' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'BRANCH' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'BRANCH Code' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'B_HEAD' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'BRANCH Head' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'ZMONTH' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Month' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'ZYEAR' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Year' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'ZTARGET' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Target' .
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

*BREAK primus.

  LOOP AT it_final INTO wa_final.

      ls_down-zsr_no     = wa_final-zsr_no.
      ls_down-branch_n   = wa_final-branch_n.
      ls_down-branch     = wa_final-branch.
      ls_down-b_head     = wa_final-b_head.
      ls_down-zmonth     = wa_final-zmonth.
      ls_down-zyear      = wa_final-zyear.
      ls_down-ztarget    = wa_final-ztarget.


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
  lv_file = 'ZOFM_TARGET.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZOFM_TARGET Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_266 TYPE string.
DATA lv_crlf_266 TYPE string.
lv_crlf_266 = cl_abap_char_utilities=>cr_lf.
lv_string_266 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_266 lv_crlf_266 wa_csv INTO lv_string_266.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_263 TO lv_fullfile.
TRANSFER lv_string_266 TO lv_fullfile.
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

  CONCATENATE  'Serial No'
               'BRANCH'
               'Branch Code'
               'BRANCH HEAD'
               'Month'
               'Year'
               'Target'
               'Refresh date'
               'Refresh time'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
