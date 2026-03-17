*&---------------------------------------------------------------------*
*& REPORT  ZSD_PACK_MAT_COST
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*                          PROGRAM DETAILS                             *
*----------------------------------------------------------------------*
* PROGRAM NAME         : ZSD_PACK_MAT_COST.                     *
* TITLE                :                                               *
* CREATED BY           : SANSARI                                       *
* STARTED ON           : 15 MAY 2012                                 *
* TRANSACTION CODE     : ZSD                                       *
* DESCRIPTION          :                                               *
*----------------------------------------------------------------------*

REPORT  zsd_pack_mat_cost.

************************************************************************
*                                  TABLES                              *
************************************************************************
TABLES:
  mara, vbrk, vbfa, lips, mbew.
************************************************************************
*                             TYPE -POOLS                              *
************************************************************************
TYPE-POOLS : slis.
************************************************************************
*                             TYPE DECLARATIONS                        *
************************************************************************
TYPES:
  BEGIN OF t_vbrk,
    vbeln TYPE vbrk-vbeln,
    vbtyp TYPE vbrk-vbtyp,
    fkdat TYPE vbrk-fkdat,
  END OF t_vbrk,

  BEGIN OF t_vbfa,
    vbelv   TYPE vbfa-vbelv,
    posnv   TYPE vbfa-posnv,
    vbeln   TYPE vbfa-vbeln,
    posnn   TYPE vbfa-posnn,
    vbtyp_v TYPE vbfa-vbtyp_v,
  END OF t_vbfa,

  BEGIN OF t_lips,
    vbeln TYPE lips-vbeln,
    posnr TYPE lips-posnr,
    pstyv TYPE lips-pstyv,
    arktx TYPE lips-arktx,
    matnr TYPE lips-matnr,
    lfimg TYPE lips-lfimg,
  END OF t_lips,

  BEGIN OF t_mbew,
    matnr TYPE mara-matnr,
    vprsv TYPE mbew-vprsv,
    verpr TYPE mbew-verpr,
    stprs TYPE mbew-stprs,
  END OF t_mbew,

  BEGIN OF t_final,
    sr_no TYPE i,
    vbeln TYPE vbrk-vbeln,
    vbelv TYPE vbfa-vbelv,
    matnr TYPE mara-matnr,
    fkdat TYPE vbrk-fkdat,
    arktx TYPE lips-arktx,
    lfimg TYPE lips-lfimg,
    verpr TYPE mbew-verpr,
    cost  TYPE mbew-verpr,
  END OF t_final.
.
************************************************************************
*                             DATA DECLARATIONS                        *
************************************************************************
DATA: it_vbrk  TYPE STANDARD TABLE OF t_vbrk,
      wa_vbrk  TYPE t_vbrk,

      it_vbfa  TYPE STANDARD TABLE OF t_vbfa,
      wa_vbfa  TYPE t_vbfa,

      it_lips  TYPE STANDARD TABLE OF t_lips,
      wa_lips  TYPE t_lips,

      it_mbew  TYPE STANDARD TABLE OF t_mbew,
      wa_mbew  TYPE t_mbew,

      it_final TYPE STANDARD TABLE OF t_final,
      wa_final TYPE t_final,

      idx      TYPE sy-tabix.


* ALV RELATED DATA
*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES AND CONSTANTS FOR ALV
*---------------------------------------------------------------------*
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      fieldlayout  TYPE slis_layout_alv,
      t_listheader TYPE slis_t_listheader WITH HEADER LINE,
      it_fcat      TYPE slis_t_fieldcat_alv,
      wa_fcat      TYPE LINE OF slis_t_fieldcat_alv. . "SLIS_T_FIELDCAT_ALV.

DATA:
  i_sort             TYPE slis_t_sortinfo_alv, " SORT
  gt_events          TYPE slis_t_event,        " EVENTS
  i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
  wa_layout          TYPE slis_layout_alv..            " LAYOUT
*WORKAREA
************************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname
                                   VALUE 'TOP_OF_PAGE',
  c_formname_pf_status_set TYPE slis_formname
                                 VALUE 'PF_STATUS_SET',
  c_z_alv_demo             LIKE trdir-name   VALUE 'Z_ALV_DEMO',
  c_vbak                   TYPE slis_tabname VALUE 'I_VBAK',
  c_s                      TYPE c VALUE 'S',
  c_h                      TYPE c VALUE 'H',
  c_101                    TYPE i VALUE '101',
  c_105                    TYPE i VALUE '105',
  c_4                      TYPE i VALUE '4',
  c_10                     TYPE i VALUE '10',
  c_15                     TYPE i VALUE '15',
  c_20                     TYPE i VALUE '20',
  c_35                     TYPE i VALUE '35',
  c_1                      TYPE i VALUE '1',
  c_x                      TYPE char1 VALUE 'X',
  c_0                      TYPE i VALUE '00000000',
  c_prcntg                 TYPE c VALUE '%'.
************************************************************************

************************************************************************
*                               SELECTION-SCREEN                       *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE title .
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

SELECT-OPTIONS   :  s_budat FOR vbrk-fkdat OBLIGATORY  .

SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON s_budat.
  IF s_budat-low EQ ' '.
    MESSAGE TEXT-001 TYPE TEXT-070.
  ENDIF.

************************************************************************
*                               START-OF-SELECTION.                    *
************************************************************************

INITIALIZATION.

  title =  'Cost of Packing Material For the Period of '.


START-OF-SELECTION.
*&---------------------------------------------------------------------*
*& SUBROUTINE TO FETCH REPORT DATA.
*&---------------------------------------------------------------------*
  PERFORM process_data.
  PERFORM final_data.
* ALV DISPLAY PERFORM
  PERFORM stp2_sort_table_build CHANGING i_sort[].
  PERFORM stp3_eventtab_build   CHANGING gt_events[].
  PERFORM comment_build         CHANGING i_list_top_of_page[].
  PERFORM top_of_page.
  PERFORM layout_build          CHANGING wa_layout.
  PERFORM listheader .          " CHANGING WA_LAYOUT.


  PERFORM build_fieldcat USING 'SR_NO'          'X' '1'   ''(012).
  PERFORM build_fieldcat USING 'VBELN'          'X' '1'   ''(003).
  PERFORM build_fieldcat USING 'FKDAT'          ' ' '2'   ''(004).
*  PERFORM BUILD_FIELDCAT USING 'MATNR'          ' ' '3'   ''(009).
  PERFORM build_fieldcat USING 'ARKTX'          ' ' '4'   ''(005).
  PERFORM build_fieldcat USING 'LFIMG'          ' ' '5'   ''(006).
*  PERFORM BUILD_FIELDCAT USING 'VERPR'          ' ' '6'   ''(010).
  PERFORM build_fieldcat USING 'COST'           ' ' '7'   ''(007).

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'T_FINAL'
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
      it_sort            = i_sort
*     IT_FILTER          =
*     IS_SEL_HIDE        =
      i_default          = 'A'
      i_save             = 'A'
*     IS_VARIANT         =
      it_events          = gt_events[]
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  REFRESH it_final.


*&---------------------------------------------------------------------*
*&      FORM  PROCESS_DATA
*&---------------------------------------------------------------------*

FORM process_data .
  SELECT vbeln
         vbtyp
         fkdat
    FROM vbrk
    INTO TABLE it_vbrk
    WHERE vbtyp = 'M'
    AND fkdat IN s_budat.

  IF sy-subrc = 0.

    IF NOT it_vbrk[] IS INITIAL.
      SELECT vbelv
             posnv
             vbeln
             posnn
             vbtyp_v
        FROM vbfa
        INTO TABLE it_vbfa
        FOR ALL ENTRIES IN it_vbrk
        WHERE vbeln = it_vbrk-vbeln
        AND vbtyp_v = 'J'.

    ENDIF.

    IF NOT it_vbfa[] IS INITIAL.

      SELECT vbeln
             posnr
             pstyv
             arktx
             matnr
             lfimg
        FROM lips
        INTO TABLE it_lips
        FOR ALL ENTRIES IN it_vbfa
        WHERE vbeln = it_vbfa-vbelv
*        AND   POSNR = IT_VBFA-POSNV
        AND pstyv = 'HUPM.'.
    ENDIF.

    IF sy-subrc = 0.
      SORT it_lips BY matnr.
    ENDIF.

    IF NOT it_lips[] IS INITIAL.
      SELECT matnr
       vprsv
       verpr
       stprs
      FROM mbew
      INTO TABLE it_mbew
      FOR ALL ENTRIES IN it_lips
      WHERE matnr = it_lips-matnr.

      IF sy-subrc = 0.
        SORT it_mbew BY matnr.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.                    " PROCESS_DATA


*&---------------------------------------------------------------------*
*&      FORM  FINAL_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM final_data .

  SORT it_vbrk BY vbeln.
  SORT it_vbfa BY vbelv vbtyp_v.
  SORT it_lips BY vbeln pstyv.
  LOOP AT it_vbrk INTO wa_vbrk.

    wa_final-vbeln = wa_vbrk-vbeln.
    wa_final-fkdat = wa_vbrk-fkdat.

    LOOP AT it_vbfa INTO wa_vbfa
          WHERE vbeln = wa_vbrk-vbeln
          AND vbtyp_v = 'J'.
      AT END OF vbelv.
        wa_final-vbelv = wa_vbfa-vbelv.

        LOOP AT it_lips INTO wa_lips
          WHERE vbeln = wa_vbfa-vbelv
          AND   pstyv = 'HUPM'.
          wa_final-sr_no = sy-tabix.
          wa_final-matnr = wa_lips-matnr.
          wa_final-arktx = wa_lips-arktx.
          wa_final-lfimg = wa_lips-lfimg.

          IF sy-subrc = 0.
            READ TABLE it_mbew INTO wa_mbew
             WITH KEY matnr = wa_lips-matnr.
            IF wa_mbew-vprsv = 'V'.
              wa_final-verpr =  wa_mbew-verpr .
              wa_final-cost = ( wa_mbew-verpr * wa_lips-lfimg ).
            ELSEIF
            wa_mbew-vprsv = 'S'.
              wa_final-verpr = wa_mbew-stprs .
              wa_final-cost = ( wa_mbew-stprs * wa_lips-lfimg ).
            ENDIF.
          ENDIF.

          APPEND wa_final TO it_final.
          SORT it_final BY sr_no vbeln fkdat.

        ENDLOOP.
      ENDAT.
    ENDLOOP.
    CLEAR : wa_vbrk, wa_lips, wa_mbew, wa_final.
  ENDLOOP.

ENDFORM.                    " FINAL_DATA
*&---------------------------------------------------------------------*
*&      FORM  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_GT_EVENTS[]  TEXT
*----------------------------------------------------------------------*
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
  MODIFY p_gt_events  FROM  lf_event INDEX 3 TRANSPORTING form."TO
  "P_GT_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      FORM  COMMENT_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_I_LIST_TOP_OF_PAGE[]  TEXT
*----------------------------------------------------------------------*
FORM comment_build  CHANGING i_list_top_of_page TYPE slis_t_listheader.

  DATA: lf_line       TYPE slis_listheader. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info =  ''(008).

  APPEND lf_line TO i_list_top_of_page.
*--HEAD INFO: TYPE S
  CLEAR lf_line.
  lf_line-typ  = c_s.
*  LF_LINE-KEY  = TEXT-011.
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      FORM  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM top_of_page .
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_listheader[]. "I_LIST_TOP_OF_PAGE[]."INTERNAL TABLE
*  WITH DETAILS WHICH ARE REQUIRED AS HEADER FOR THE ALV.
*    I_LOGO                   =
*    I_END_OF_LIST_GRID       =
*    I_ALV_FORM               =
  .

ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      FORM  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  TEXT
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.
*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  wa_layout-zebra          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  p_wa_layout-zebra        = 'X'.
  p_wa_layout-no_colhead        = ' '.
ENDFORM.                    " LAYOUT_BUILD


*&---------------------------------------------------------------------*
*&      FORM  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_0313   TEXT
*      -->P_0314   TEXT
*      -->P_0315   TEXT
*      -->P_0316   TEXT
*----------------------------------------------------------------------*
FORM build_fieldcat  USING    v1 v2 v3 v4.
  wa_fcat-fieldname   = v1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_FINAL'.
* WA_FCAT-_ZEBRA      = 'X'.
  wa_fcat-key         =  v2 ."  'X'.
  wa_fcat-seltext_m   =  v4.
  wa_fcat-outputlen   =  20.
  wa_fcat-ddictxt     =  'M'.
  wa_fcat-col_pos     =  v3.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  LISTHEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM listheader .
  DATA : frmdt(10) TYPE c,
         todt(10)  TYPE c,
         v_str     TYPE string.


  t_listheader-typ = TEXT-014."H
  t_listheader-key = ' '.
  t_listheader-info = TEXT-059.
  APPEND t_listheader.

  IF s_budat-low NE c_0 AND  s_budat-high NE c_0      .
    WRITE s_budat-low  TO frmdt USING EDIT MASK TEXT-061."'__.__.____'.
    WRITE s_budat-high TO todt  USING EDIT MASK TEXT-061.
    CONCATENATE TEXT-062
                 frmdt
                 TEXT-063
                 todt
           INTO v_str SEPARATED BY space.
  ELSEIF s_budat-low NE c_0 AND  s_budat-high EQ c_0      .
    WRITE s_budat-low  TO frmdt USING EDIT MASK TEXT-061.
    CONCATENATE TEXT-069
                 frmdt
           INTO v_str SEPARATED BY space.
  ELSEIF s_budat-low EQ c_0 AND  s_budat-high NE c_0      .
    WRITE s_budat-high  TO todt USING EDIT MASK TEXT-061.
    CONCATENATE TEXT-069
                 todt
           INTO v_str SEPARATED BY space.
  ENDIF.
  t_listheader-typ = TEXT-021."S
  t_listheader-key = ' '.
  t_listheader-info = v_str.
  APPEND t_listheader.

ENDFORM.                    " LISTHEADER
*&---------------------------------------------------------------------*
*&      Form  STP2_SORT_TABLE_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_SORT[]  text
*----------------------------------------------------------------------*
FORM stp2_sort_table_build  CHANGING p_i_sort TYPE slis_t_sortinfo_alv.
  DATA : lf_sort  LIKE LINE OF i_sort. "Work Area
  CLEAR : lf_sort.
  lf_sort-spos      = 2.
  lf_sort-tabname   = 'IT_FINAL'.
  lf_sort-fieldname = 'VBELN'.

*  LF_SORT-GROUP     = '*'.
  lf_sort-up        = 'X'.
  APPEND lf_sort TO p_i_sort.

ENDFORM.                    " STP2_SORT_TABLE_BUILD
