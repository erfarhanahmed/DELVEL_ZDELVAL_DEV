*&---------------------------------------------------------------------*
*& Report ZMATERIAL_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmaterial_list.
TYPE-POOLS: slis.

data:
  tmp_ersda TYPE mara-ersda.
TYPES:
  BEGIN OF t_mat_mast,
    matnr   TYPE mara-matnr,
    ersda   TYPE mara-ersda,
    ernam   TYPE mara-ernam,
    mtart   TYPE mara-mtart,
    mbrsh   TYPE mara-mbrsh,
    bismt   TYPE mara-bismt,
    meins   TYPE mara-meins,
    zeinr   TYPE mara-zeinr,
    zeivr   TYPE mara-zeivr,
    zseries TYPE mara-zseries,
    zsize   TYPE mara-zsize,
    brand   TYPE mara-brand,
    moc     TYPE mara-moc,
    type    TYPE mara-type,
    zzmss   TYPE mara-zzmss,
    zzeds   TYPE mara-zzeds,
  END OF t_mat_mast,
  tt_mat_mast TYPE STANDARD TABLE OF t_mat_mast.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    prctr TYPE marc-prctr,
  END OF t_marc,
  tt_marc TYPE STANDARD TABLE OF t_marc.

TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    spras TYPE makt-spras,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.

TYPES:
  BEGIN OF t_final,
    matnr    TYPE mara-matnr,
    ersda    TYPE mara-ersda,
    ernam    TYPE mara-ernam,
    mtart    TYPE mara-mtart,
    mbrsh    TYPE mara-mbrsh,
    bismt    TYPE mara-bismt,
    meins    TYPE mara-meins,
    zeinr    TYPE mara-zeinr,
    zeivr    TYPE mara-zeivr,
    zseries  TYPE mara-zseries,
    zsize    TYPE mara-zsize,
    brand    TYPE mara-brand,
    moc      TYPE mara-moc,
    type     TYPE mara-type,
    werks    TYPE marc-werks,
    prctr    TYPE marc-prctr,
    maktx_e  TYPE makt-maktx, " English
    maktx_s  TYPE string, "Spanish
    long_txt TYPE TEXT300,
    mss      TYPE mara-zzmss,
    eds      TYPE mara-zzeds,
    VERPR   TYPE MBEW-VERPR,
    STPRS   TYPE MBEW-STPRS,


  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.

data:
  gt_final TYPE tt_final.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
  select-OPTIONS so_ersda FOR tmp_ersda.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
xyz = 'Select Options'(tt1).

START-OF-SELECTION.
PERFORM fetch_data CHANGING gt_final.
PERFORM display USING gt_final.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM fetch_data  CHANGING ct_final TYPE tt_final.
  data:
    lt_mat_mast TYPE tt_mat_mast,
    ls_mat_mast TYPE t_mat_mast,
    lt_marc     TYPE tt_marc,
    ls_marc     TYPE t_marc,
    lt_mat_desc TYPE tt_mat_desc,
    ls_mat_desc TYPE t_mat_desc,
    ls_mat_des  TYPE t_mat_desc,
    ls_final    TYPE t_final.

   DATA:
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline.


  SELECT matnr
         ersda
         ernam
         mtart
         mbrsh
         bismt
         meins
         zeinr
         zeivr
         zseries
         zsize
         brand
         moc
         type
         zzmss
         zzeds
    FROM mara
    INTO TABLE lt_mat_mast
    WHERE ersda in so_ersda.

    IF not sy-subrc IS INITIAL.
      MESSAGE 'Data Not Found' TYPE 'E'.
    ENDIF.

    IF NOT lt_mat_mast IS INITIAL.
      SELECT matnr
             werks
             prctr
        FROM marc
        INTO TABLE lt_marc
        FOR ALL ENTRIES IN lt_mat_mast
        WHERE matnr = lt_mat_mast-matnr.

      SELECT matnr
             spras
             maktx
        FROM makt
        INTO TABLE lt_mat_desc
        FOR ALL ENTRIES IN lt_mat_mast
        WHERE matnr = lt_mat_mast-matnr
        AND   spras in ('EN','ES').


    ENDIF.


  LOOP AT lt_mat_mast INTO ls_mat_mast.
    ls_final-matnr   = ls_mat_mast-matnr.
    ls_final-ersda   = ls_mat_mast-ersda.
    ls_final-ernam   = ls_mat_mast-ernam.
    ls_final-mtart   = ls_mat_mast-mtart.
    ls_final-mbrsh   = ls_mat_mast-mbrsh.
    ls_final-bismt   = ls_mat_mast-bismt.
    ls_final-meins   = ls_mat_mast-meins.
    ls_final-zeinr   = ls_mat_mast-zeinr.
    ls_final-zeivr   = ls_mat_mast-zeivr.
    ls_final-zseries = ls_mat_mast-zseries.
    ls_final-zsize   = ls_mat_mast-zsize.
    ls_final-brand   = ls_mat_mast-brand.
    ls_final-moc     = ls_mat_mast-moc.
    ls_final-type    = ls_mat_mast-type.
    ls_final-mss     = ls_mat_mast-zzmss.
    ls_final-eds     = ls_mat_mast-zzeds.

    READ TABLE lt_marc INTO ls_marc with KEY matnr = ls_final-matnr.
    IF sy-subrc is INITIAL.
    ls_final-werks   = ls_marc-werks.
    ls_final-prctr   = ls_marc-prctr.
    ENDIF.

    READ TABLE lt_mat_desc INTO ls_mat_desc with KEY matnr = ls_final-matnr
                                                     spras = 'E'.
    IF sy-subrc is INITIAL.
      ls_final-maktx_e = ls_mat_desc-maktx.
    ENDIF.

    READ TABLE lt_mat_desc INTO ls_mat_des with KEY matnr = ls_final-matnr
                                                     spras = 'S'.
    IF sy-subrc is INITIAL.
      ls_final-maktx_s = ls_mat_des-maktx.
    ENDIF.

          "Material Long Text
      lv_id = ls_final-matnr.
      CLEAR: lt_lines,ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_id
          object                  = 'MATERIAL'
        TABLES
          lines                   = lt_lines
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
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-long_txt ls_lines-tdline INTO ls_final-long_txt SEPARATED BY space.


*            APPEND ls_final to ct_final.
*            CLEAR ls_final-long_txt.
*
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-long_txt.
      ENDIF.

          "Material Long Text
      lv_id = ls_final-matnr.
      CLEAR lt_lines.
      CLEAR: lt_lines,ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = 'S'
          name                    = lv_id
          object                  = 'MATERIAL'
        TABLES
          lines                   = lt_lines
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
* Implement suitable error handling here
      ENDIF.
      IF NOT lt_lines IS INITIAL.
        LOOP AT lt_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE ls_final-maktx_s ls_lines-tdline INTO ls_final-maktx_s SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE ls_final-maktx_s.
      ENDIF.

      SELECT SINGLE VERPR STPRS  FROM MBEW INTO ( LS_FINAL-VERPR , LS_FINAL-STPRS ) WHERE MATNR = LS_FINAL-MATNR.

      APPEND ls_final TO ct_final.
*      *

      CLEAR: ls_final,ls_mat_mast,ls_mat_desc,ls_marc.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM display  USING    ct_final TYPE tt_final.
  DATA:
    lt_fieldcat     TYPE slis_t_fieldcat_alv,
    ls_alv_layout   TYPE slis_layout_alv,
    l_callback_prog TYPE sy-repid.

  l_callback_prog = sy-repid.

  PERFORM prepare_display CHANGING lt_fieldcat.
  CLEAR ls_alv_layout.
  ls_alv_layout-zebra = 'X'.
  ls_alv_layout-colwidth_optimize = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = l_callback_prog
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      is_layout               = ls_alv_layout
      it_fieldcat             = lt_fieldcat
    TABLES
      t_outtab                = ct_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_display  CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.
  DATA:
    gv_pos      TYPE i,
    ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH ct_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MBRSH'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Industry Sector'."(100).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MATNR'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Material'."(101).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MTART'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Material Type'."(102).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WERKS'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Plant'."(103).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MAKTX_E'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Material Description'."(104).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MEINS'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Unit'."(105).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BISMT'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Old Material Number'."(106).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BRAND'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Brand'."(107).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSERIES'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Series'."(108).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSIZE'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Size'."(109).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MOC'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MOC'."(110).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TYPE'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Type'."(111).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LONG_TXT'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_l = 'Long Description(English)'."(112).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-outputlen = '200'.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZEINR'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Drawing No.'."(113).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZEIVR'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Doc. Ver.'."(114).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PRCTR'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Profit Center'."(115).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MSS'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MSS'."(116).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EDS'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'EDS'."(117).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ERSDA'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Created On'."(118).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ERNAM'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Created By'."(119).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MAKTX_S'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Item Text(Spanish)'."(120).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VERPR'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Moving Price'."(120).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STPRS'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Standard Price'."(120).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.



ENDFORM.
