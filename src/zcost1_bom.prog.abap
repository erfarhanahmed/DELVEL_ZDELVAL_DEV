*&---------------------------------------------------------------------*
*& Report ZCOST1_BOM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
***************************************************
*Requirement: ZCOST1_BOM (Bom Cost explode report)
*Transaction: ZCOST1
*Functional Consultant: Subhashish Pande
*Technical Consultant: Diksha Halve
*Date: 13.10.2022
***************************************************

REPORT zcost1_bom.

TABLES : keko.

TYPES : BEGIN OF ty_keko,
          kalnr TYPE keko-kalnr,   "costing no
          kadky TYPE keko-kadky,   "costing date
          tvers TYPE keko-tvers,   "costing version
          matnr TYPE keko-matnr,   "material
          werks TYPE werks_d,      "plant
          losgr TYPE keko-losgr,   "lot size
          klvar TYPE keko-klvar,   "costing variant

        END OF ty_keko.

TYPES : BEGIN OF ty_final,
          werks  TYPE werks_d,
          matnr  TYPE keko-matnr,
          matnr1 TYPE char18,    "ck_strukturtab-matnr,
          ltext  TYPE char40,     "STRUKTURTABELLE-ltext,
          klvar  TYPE keko-klvar,
          kalnr  TYPE keko-kalnr,
          kadky  TYPE char15,  "keko-kadky,
          tvers  TYPE keko-tvers,
          gpreis TYPE p DECIMALS 2,   "STRUKTURTABELLE-GPREIS,
          menge  TYPE p DECIMALS 3,    "STRUKTURTABELLE-menge,
          meeht  TYPE char3,           "STRUKTURTABELLE-MEEHT,
          tcost  TYPE p DECIMALS 2,
*          REF TYPE CHAR15,

        END OF ty_final.

TYPES : BEGIN OF ty_down,
          werks    TYPE werks_d,
          matnr    TYPE keko-matnr,
          matnr1   TYPE char18,    "ck_strukturtab-matnr,
          ltext    TYPE char40,     "STRUKTURTABELLE-ltext,
          klvar    TYPE keko-klvar,
          kalnr    TYPE keko-kalnr,
          kadky    TYPE char15,
          tvers    TYPE keko-tvers,
          gpreis   TYPE p DECIMALS 2,   "STRUKTURTABELLE-GPREIS,
          menge    TYPE p DECIMALS 3,    "STRUKTURTABELLE-menge,
          meeht    TYPE char3,
          tcost    TYPE p DECIMALS 2,
          ref_dat  TYPE char15,
          ref_time TYPE char15,

        END OF ty_down.

DATA : it_keko TYPE STANDARD TABLE OF ty_keko,
       wa_keko TYPE ty_keko.

DATA : it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final.

DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE          ty_down.

DATA : s_aufl_unvollstaendig TYPE  c,
       f_keko                LIKE  keko,
       f_header_mat          TYPE  ck_strukturtab_header,

       it_strukturtabelle    TYPE ck_strukturtab,  "WITH HEADER LINE,
       wa_strukturtabelle    LIKE LINE OF it_strukturtabelle,
       t_keko_imp            LIKE  keko.

DATA : gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gs_fieldcat TYPE slis_fieldcat_alv.

DATA : fs_layout TYPE slis_layout_alv.

DATA : BEGIN OF it_stpox OCCURS 1.
    INCLUDE STRUCTURE stpox.
DATA : END OF it_stpox.

DATA : lv_idx TYPE sy-tabix.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_matnr FOR keko-matnr,
                 s_werks FOR keko-werks,
                 s_kadky FOR keko-kadky.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT 5(63) TEXT-005.
*SELECTION-SCREEN END OF LINE.

PERFORM get_data.
PERFORM fcat.
PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT kalnr
         MAX( kadky )
         tvers
         matnr
         werks
         losgr
         klvar
    FROM keko
    INTO TABLE it_keko
    WHERE matnr IN s_matnr
    AND werks = s_werks-low
    GROUP BY kalnr
             tvers
             matnr
             werks
             losgr
             klvar.


* LOOP AT IT_KEKO INTO WA_KEKO.
* LV_IDX = SY-TABIX.
* IF LV_IDX > 1.
* DELETE IT_KEKO INDEX  LV_IDX .
* ENDIF.
* ENDLOOP.

  LOOP AT it_keko INTO wa_keko.

    wa_final-werks = wa_keko-werks.
    wa_final-matnr = wa_keko-matnr.

    IF sy-subrc IS INITIAL.

      CALL FUNCTION 'CK_F_CSTG_STRUCTURE_EXPLOSION'
        EXPORTING
          klvar                 = wa_keko-klvar
          kalnr                 = wa_keko-kalnr
          kadky                 = wa_keko-kadky
          tvers                 = wa_keko-tvers
          werk                  = wa_keko-werks
          sicht                 = '01'
          s_losgr               = 'X'
          s_bezugsmenge         = wa_keko-losgr
*         S_BEZUGSMENGENEINHEIT =
*         S_ACCEPT_NULLMENGE    = ' '
          s_aufloesungstiefe    = '0'
          s_read_only_db        = 'X'
          s_only_mat_pos        = 'X'
*         S_EXPLODE_KF_TOO      = ' '
*         S_EXPLODE_RAW         = ' '
          s_skip_totals         = 'X'
*         S_USE_KKE3_CACHE      = ' '
*         S_EXPLODE_BPO         = ' '
*         s_vuc_read_only_db    = 'X'
        IMPORTING
          f_keko                = f_keko
          f_header_mat          = f_header_mat  "ck_strukturtab_header
          s_aufl_unvollstaendig = s_aufl_unvollstaendig    "c
        TABLES
          strukturtabelle       = it_strukturtabelle    "it_stpox
*         T_KEKO_IMP            =
        EXCEPTIONS
          invalid_bzobj         = 1
          keko_not_found        = 2
          meta_model_error      = 3
          ckhs_not_found        = 4
          OTHERS                = 5.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

    ENDIF.

*    READ TABLE it_keko INTO wa_keko WITH KEY matnr = s_matnr werks = s_werks-low BINARY SEARCH.
*    IF sy-subrc = 0.
*      wa_final-werks = wa_keko-werks.
*      wa_final-matnr = wa_keko-matnr.
*    ENDIF.

    LOOP AT it_strukturtabelle INTO wa_strukturtabelle.
      IF sy-subrc = 0.
        wa_final-matnr1 = wa_strukturtabelle-matnr.
        wa_final-ltext = wa_strukturtabelle-ltext.
        wa_final-klvar = wa_strukturtabelle-klvar.
        wa_final-kalnr = wa_strukturtabelle-kalnr.
*      wa_final-kadky = wa_strukturtabelle-kadky.

        IF wa_strukturtabelle-kadky IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              input  = wa_strukturtabelle-kadky
            IMPORTING
              output = wa_final-kadky.

          CONCATENATE wa_final-kadky+0(2) wa_final-kadky+2(3) wa_final-kadky+5(4)
                        INTO wa_final-kadky SEPARATED BY '-'.
        ENDIF.

        wa_final-tvers = wa_strukturtabelle-tvers.
        wa_final-gpreis = wa_strukturtabelle-gpreis.
        wa_final-menge = wa_strukturtabelle-menge.
        wa_final-meeht = wa_strukturtabelle-meeht.

        wa_final-tcost = wa_final-gpreis * wa_final-menge.
*        wa_final-ref = sy-datum.
*
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*            EXPORTING
*              input  = wa_final-ref
*            IMPORTING
*              output = wa_final-ref.
*
*          CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
*                        INTO wa_final-ref SEPARATED BY '-'.

      ENDIF.

      APPEND wa_final TO it_final.
      CLEAR : wa_final.
    ENDLOOP.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fcat .

  REFRESH gt_fieldcat.
  DATA(cnt) = 0.
  cnt = cnt + 1.

  PERFORM gt_fieldcatlog USING :
       'WERKS'     'IT_FINAL'     'Plant'                             '1',
       'MATNR'     'IT_FINAL'     'Parent Material'                   '2',
       'MATNR1'     'IT_FINAL'     'Child Material'                   '3',
       'LTEXT'     'IT_FINAL'     'Material Description'                   '4',
       'KLVAR'     'IT_FINAL'     'Costing Variant'                   '5',
       'KALNR'     'IT_FINAL'     'Prodcostest No.'                   '6',
       'KADKY'     'IT_FINAL'     'Costing Date'                   '7',
       'TVERS'     'IT_FINAL'     'Costing Version'                   '8',
       'GPREIS'     'IT_FINAL'     'Rate'                   '9',
       'MENGE'     'IT_FINAL'     'Quantity'                   '10',
       'MEEHT'     'IT_FINAL'     'Unit'                   '11',
       'TCOST'     'IT_FINAL'     'Total Cost'                   '12'.
*       'REF'       'IT_FINAL'     'Refresh Date'           '7'.

  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra = 'X'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GT_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ENDFORM  text
*----------------------------------------------------------------------*
FORM gt_fieldcatlog  USING  v1 v2 v3 v4 .  "p_endform.

  gs_fieldcat-fieldname   = v1.
  gs_fieldcat-tabname     = v2.
  gs_fieldcat-seltext_l   = v3.
  gs_fieldcat-col_pos     = v4.
*  gt_fieldcat-do_sum     =  v5.
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR  gs_fieldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = fs_layout
      it_fieldcat        = gt_fieldcat[]
    TABLES
      t_outtab           = it_final.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.

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
FORM download .

  LOOP AT it_final INTO wa_final.

    wa_down-werks = wa_final-werks.
    wa_down-matnr = wa_final-matnr.
    wa_down-matnr1 = wa_final-matnr1.
    wa_down-ltext = wa_final-ltext.
    wa_down-klvar = wa_final-klvar.
    wa_down-kalnr = wa_final-kalnr.
    wa_down-kadky = wa_final-kadky.
    wa_down-tvers = wa_final-tvers.
    wa_down-gpreis = wa_final-gpreis.
    wa_down-menge = wa_final-menge.
    wa_down-meeht = wa_final-meeht.
    wa_down-tcost = wa_final-tcost.
*    WA_DOWN-REF =   WA_FINAL-REF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_down-ref_dat.

    CONCATENATE wa_down-ref_dat+0(2) wa_down-ref_dat+2(3) wa_down-ref_dat+5(4)
    INTO wa_down-ref_dat SEPARATED BY '-'.

    wa_down-ref_time = sy-uzeit.
    CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

    APPEND wa_down TO it_down.
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
        lv_dat(18),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZCOST_NEW_1.TXT'.

*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.

  WRITE: / 'ZCOST1_BOM Download started on', sy-datum, 'at', sy-uzeit.
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
TRANSFER lv_string_412 TO lv_fullfile.
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

  CONCATENATE 'Plant'
              'Parent Material'
              'Child Material'
              'Material Description'
              'Costing Variant'
              'Prodcostest No.'
              'Costing Date'
              'Costing Version'
              'Rate'
              'Quantity'
              'Unit'
              'Total Cost'
              'Refresh Date'
              'Refresh Time'
     INTO p_hd_csv
      SEPARATED BY l_field_seperator.

ENDFORM.
