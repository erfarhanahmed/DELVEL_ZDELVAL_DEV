
REPORT  zpp_excess_inventory_rep MESSAGE-ID zdel.
*----------------------------------------------------------------------*
*                          Program Details                             *
*----------------------------------------------------------------------*
* Program Name         : ZPP_EXCESS_INVENTORY_REP.                     *
* Title                : Excess Inventory report                       *
* Created By           : Sansari                                       *
* Started On           : 20 January 2011                               *
* Transaction Code     : ZPPEIR                                       *
* Description          : ALV presentation for Excess Inventory Report  *
*----------------------------------------------------------------------*


INITIALIZATION.
************************************************************************
*                             TYPE DECLARATIONS                        *
************************************************************************

  TYPE-POOLS : slis.

*  TYPES:   BEGIN OF ST_FINAL,                         "FINAL TABLE STRUCTURE
*                    MATNR        TYPE MATNR,          "MATERIAL NUMBER
*                    WERKS        TYPE WERKS_D,        "PLANT
*                    VBELN        TYPE VBELN,          "SALES ORDER NUMBER
*                    POSNR        TYPE POSNR,          "SALES DOCUMENT ITEM
*                    MAKTX        TYPE MAKTX,          "MATERIAL DESCRIPTION
*                    UOM          TYPE MEINS,          "UNIT OF MEASURE
*                    ZSERIES       TYPE ZSER_code,
*                    ZSIZE        TYPE ZSIZE,
*                    BRAND        TYPE ZBRAND,
*                    MOC         TYPE ZMOC,
*                    TYPE         TYPE ZTYP,
*                    REQD_QTY     TYPE MNG01,          "QUANTITY REQUIRED
*                    SO_STOCK     TYPE MNG01,          "SALES ORDER STOCK
*                    EX_SO_STOCK  TYPE MNG01,          "EXCESS SALES ORDER STOCK
*                    EX_FREE_STK  TYPE MNG01,          "EXCESS FREE STOCK
*                    SBDKZ        TYPE SBDKZ,
*            END OF ST_FINAL.


  TYPES: BEGIN OF st_marc ,
           matnr TYPE matnr,
           werks TYPE werks,
           sbdkz TYPE sbdkz,
         END OF st_marc.

  TYPES : BEGIN OF st_makt ,
            matnr TYPE mara-matnr,
            maktx TYPE makt-maktx,
            spras TYPE makt-spras,
          END OF st_makt.

  TYPES: BEGIN OF st_mara,
           matnr   TYPE matnr,
           uom     TYPE meins,
           zseries TYPE zser_code,
           zsize   TYPE zsize,
           brand   TYPE zbrand,
           moc     TYPE zmoc,
           ztype   TYPE ztyp,
         END OF st_mara.
************************************************************************
*                             DATA DECLARATIONS                        *
************************************************************************

*  DATA : ST_FINAL TYPE STANDARD TABLE OF ZT_FINAL.

  DATA : it_mara TYPE STANDARD TABLE OF st_mara,
         wa_mara TYPE st_mara.

  DATA: it_makt TYPE  STANDARD TABLE OF st_makt,
        wa_makt TYPE st_makt.

  DATA: it_marc TYPE STANDARD TABLE OF st_marc,
        wa_marc TYPE st_marc.

  DATA: it_final_alv TYPE  zt_final,     "STANDARD TABLE OF ZT_FINAL,
        wa_final_alv TYPE  zst_final,      "TYPE STANDARD TABLE OF ZT_FINAL,

        it_final     TYPE  zt_final,
        wa_final     TYPE zst_final,     "ZT_FINAL,
        wa_final_new TYPE zst_final.     "ZT_FINAL.

  DATA : i_mdps  TYPE STANDARD TABLE OF mdps,
         wa_mdps TYPE mdps.

  DATA : r_matnr TYPE ddtrange,
         r       LIKE LINE OF r_matnr.

* LIKE DISPLAY IN THE ZEBRA PATTERN ,THE HOTSPOT OPTIONS ETC.
  DATA: fieldcatalog   TYPE slis_t_fieldcat_alv WITH HEADER LINE,
        fieldlayout    TYPE slis_layout_alv,
        info_fieldname TYPE slis_fieldname.

* ALV RELATED DATA
*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES AND CONSTANTS FOR ALV
*---------------------------------------------------------------------*
  DATA:
    i_sort             TYPE slis_t_sortinfo_alv, " SORT
    i_events           TYPE slis_t_event,        " EVENTS
    i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
    i_layout           TYPE slis_layout_alv,
    wa_layout          TYPE slis_layout_alv.    " Layout workarea
*      WA_LAYOUT          TYPE ZT_FINAL.            " LAYOUT WORKAREA

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
    c_h                      TYPE c VALUE 'H'.
************************************************************************
*                               SELECTION-SCREEN                       *
************************************************************************
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECTION-SCREEN BEGIN OF BLOCK b2 .

  SELECT-OPTIONS : ss_matnr FOR wa_mara-matnr NO INTERVALS.

  PARAMETERS       :  pa_werks TYPE marc-werks OBLIGATORY  . "MEMORY ID WRK.
  SELECTION-SCREEN END OF BLOCK b2.
  SELECTION-SCREEN END OF BLOCK b1.
************************************************************************
*                           AT SELECTION-SCREEN                        *
************************************************************************
********Validate selection Criteria.

AT SELECTION-SCREEN ON pa_werks.
  IF pa_werks IS NOT INITIAL.
    SELECT SINGLE werks
      INTO pa_werks
      FROM marc
      WHERE werks = pa_werks.
    IF sy-subrc <> 0.
      MESSAGE w029.
*      call transaction 'ZPPEIR' .
    ENDIF.
  ENDIF.

********Validate selection Criteria.

AT SELECTION-SCREEN ON ss_matnr.

  SELECT matnr
         werks
         sbdkz
    FROM marc
    INTO TABLE it_marc
    WHERE ( matnr IN ss_matnr AND werks = pa_werks AND sbdkz = 1 ).

************************************************************************
*                           START-OF-SELECTION                         *
************************************************************************
START-OF-SELECTION.
*======================plant changes===================================*


  IF NOT pa_werks IS INITIAL    "p_WERKS
     AND ss_matnr IS INITIAL.   "P_MATNR
    PERFORM plant_report TABLES it_final_alv.
    PERFORM stp2_sort_table_build CHANGING i_sort[].
    PERFORM stp3_eventtab_build   CHANGING i_events[].
    PERFORM comment_build         CHANGING i_list_top_of_page[].
    PERFORM build_fieldcatalog    TABLES it_final_alv.
    PERFORM layout_build     CHANGING wa_layout.
*ENDIF.

*IF NOT PA_WERKS IS INITIAL    "p_WERKS
*    AND  ss_MATNR IS not INITIAL.   "P_MATNR
  ELSE.
    PERFORM data_retrieval TABLES it_final_alv .
    PERFORM stp2_sort_table_build CHANGING i_sort[].
    PERFORM stp3_eventtab_build   CHANGING i_events[].
    PERFORM comment_build CHANGING i_list_top_of_page[].
    PERFORM build_fieldcatalog TABLES it_final_alv.
    PERFORM layout_build     CHANGING wa_layout.
  ENDIF.
*----------------------------------------------------------------------*

  PERFORM clear_refresh.
*&---------------------------------------------------------------------*
*&      Form  CLEAR_REFRESH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM clear_refresh .
  REFRESH: ss_matnr, i_mdps.
  CLEAR:  pa_werks.

ENDFORM.                    " CLEAR_REFRESH


*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IT_FINAL_ALV  text
*----------------------------------------------------------------------*
FORM build_fieldcatalog    TABLES it_final_alv ."TYPE ZT_FINAL.
  DATA: i_fieldcat  TYPE slis_t_fieldcat_alv,  "SLIS_T_FIELDCAT_ALV WITH HEADER LINE, " FIELDCATALOG
        wa_fieldcat TYPE slis_fieldcat_alv.   " FIELDCAT WORKAREA

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'MATNR'.
  wa_fieldcat-seltext_m   = 'MATERIAL NUMBER'.
  wa_fieldcat-key         = 'X'.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 18.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'VBELN'.
  wa_fieldcat-seltext_m   = 'SALES ORDER NUMBER'.
  wa_fieldcat-col_pos     = 1.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'POSNR'.
  wa_fieldcat-seltext_m   = 'SALES DOCUMENT ITEM'.
  wa_fieldcat-col_pos     = 2.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'MAKTX'.
  wa_fieldcat-seltext_m   = 'MATERIAL DESCRIPTION'.
  wa_fieldcat-col_pos     = 3.
  wa_fieldcat-outputlen   = 20.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'REQD_QTY'.
  wa_fieldcat-seltext_m   = 'SO OPEN QUANTITY'.
  wa_fieldcat-col_pos     = 4.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'SO_STOCK'.
  wa_fieldcat-seltext_m   = 'SALES ORDER STOCK'.
  wa_fieldcat-col_pos     = 5.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'EX_SO_STOCK'.
  wa_fieldcat-seltext_m   = 'EXCESS SALES ORDER STOCK'.
  wa_fieldcat-col_pos     = 6.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'EX_FREE_STK'.
  wa_fieldcat-seltext_m   = 'EXCESS FREE STOCK'.
  wa_fieldcat-col_pos     = 7.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'ZSERIES'.
  wa_fieldcat-seltext_m   = 'SERIES'.
  wa_fieldcat-col_pos     = 8.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'ZSIZE'.
  wa_fieldcat-seltext_m   = 'SIZE'.
  wa_fieldcat-col_pos     = 9.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'BRAND'.
  wa_fieldcat-seltext_m   = 'BRAND'.
  wa_fieldcat-col_pos     = 10.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'MOC'.
  wa_fieldcat-seltext_m   = 'MOC'.
  wa_fieldcat-col_pos     = 11.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = 'TYPE'.
  wa_fieldcat-seltext_m   = 'TYPE'.
  wa_fieldcat-col_pos     = 12.
  wa_fieldcat-outputlen   = 10.
  APPEND wa_fieldcat TO i_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = i_layout
      it_fieldcat        = i_fieldcat
      i_default          = 'X'
      it_events          = i_events[]
      i_save             = 'X'
    TABLES
      t_outtab           = it_final_alv
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  REFRESH it_final_alv.

ENDFORM.                    " BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*&      FORM  DATA_RETRIEVAL
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM data_retrieval TABLES it_final_alv TYPE zt_final.
*-----Selection screen input data passed to FM
  LOOP AT ss_matnr INTO r.
    APPEND r TO r_matnr.
  ENDLOOP.

  CALL FUNCTION 'ZPP_EXCESS_INVENTORY'
    EXPORTING
      p_werks                  = pa_werks
    TABLES
      it_mdps                  = i_mdps
      it_final_alv             = it_final_alv
      s_matnr                  = r_matnr[]
    EXCEPTIONS
      material_plant_not_found = 1
      plant_not_found          = 2
      OTHERS                   = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
***********************************************************
*..........Delete records which have zero values for excess stock columns.
  SORT it_final_alv BY matnr.
  DELETE it_final_alv
  WHERE ( ex_so_stock = 0  AND ex_free_stk = 0 )
  OR      sbdkz <> 1.

  ".................................................................

  LOOP AT it_final_alv .
    SHIFT it_final_alv-vbeln LEFT DELETING LEADING '0'.
    SHIFT it_final_alv-matnr LEFT DELETING LEADING '0'.
    MODIFY it_final_alv INDEX sy-tabix..
  ENDLOOP.
*ENDLOOP.
*endif.
ENDFORM.                    " DATA_RETRIEVAL

*======================plant changes===================================*
*&---------------------------------------------------------------------*
*&      Form  PLANT_REPORT
*&---------------------------------------------------------------------*

FORM plant_report  TABLES   it_final_alv TYPE  zt_final."P_IT_FINAL_ALV STRUCTURE < IT_FINAL_ALV #local# >
  "Insert correct name for <...>.
  TYPES: BEGIN OF st_idnrk,
           matnr TYPE stpox-idnrk,
           maktx TYPE makt-maktx,
           uom   TYPE mara-meins,
           sbdkz TYPE sbdkz,
           werks TYPE marc-werks,
         END OF st_idnrk.

  DATA: it_idnrk TYPE STANDARD TABLE OF st_idnrk,
        wa_idnrk TYPE st_idnrk.

  DATA: reqd_qty_new    TYPE mng01,        "QUANTITY REQUIRED
        so_stock_new    TYPE mng01,         "SALES ORDER STOCK
        ex_so_stock_new TYPE mng01,         "EXCESS SALES ORDER STOCK
        ex_free_stk_new TYPE mng01.         "EXCESS FREE STOCK


  SELECT matnr
         werks
         sbdkz
    FROM marc
    INTO TABLE it_marc
    WHERE werks = pa_werks AND sbdkz = 1.


*&---FILLING FINAL INT TABLE

  LOOP AT it_marc INTO wa_marc.

    wa_idnrk-matnr = wa_marc-matnr.  "MATNR
    wa_idnrk-sbdkz = wa_marc-sbdkz.
    wa_idnrk-werks = wa_marc-werks.


    SELECT SINGLE maktx FROM makt
      INTO wa_idnrk-maktx
      WHERE matnr = wa_idnrk-matnr.
    IF sy-subrc = 0.
      APPEND wa_idnrk TO it_idnrk.
    ENDIF.
  ENDLOOP.     "LOOP AT IT_MARC INTO WA_MARC.

*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
  LOOP AT it_idnrk INTO wa_idnrk .

    CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
      EXPORTING
        matnr                    = wa_idnrk-matnr
        werks                    = pa_werks
      TABLES
        mdpsx                    = i_mdps "IT_MDPS
      EXCEPTIONS
        material_plant_not_found = 1
        plant_not_found          = 2
        OTHERS                   = 3.
    IF sy-subrc <> 0.
*        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

************************************************************************************

    LOOP AT i_mdps INTO wa_mdps.
      wa_final-matnr    = wa_idnrk-matnr.
      wa_final-maktx    = wa_idnrk-maktx.
      wa_final-uom      = wa_idnrk-uom.
      wa_final-werks    = pa_werks.
      wa_final-vbeln    = wa_mdps-kdauf.
      wa_final-posnr    = wa_mdps-kdpos.
*********************************************************************************

      IF ( wa_mdps-delkz = 'VC' OR wa_mdps-delkz = 'SB').
        reqd_qty_new          =  wa_mdps-mng01.
      ENDIF.

      IF ( ( wa_mdps-delkz = 'KB' OR wa_mdps-delkz = 'QM') AND wa_mdps-planr <> '').
        so_stock_new  = so_stock_new + wa_mdps-mng01.
      ENDIF.

      IF ( ( wa_mdps-delkz = 'WB' OR wa_mdps-delkz = 'QM') AND wa_mdps-planr = '').
        ex_free_stk_new      = ex_free_stk_new + wa_mdps-mng01.
      ENDIF.

      AT END OF planr.
        SELECT SINGLE

           zseries
           zsize
           brand
           moc
           type
*
        FROM mara
        INTO CORRESPONDING FIELDS OF wa_final  "WA_IDNRK-UOM
       WHERE matnr = wa_idnrk-matnr.
        IF ( so_stock_new  > reqd_qty_new ) .
          ex_so_stock_new = so_stock_new - reqd_qty_new.
          so_stock_new    = reqd_qty_new.
        ENDIF.
        wa_final-reqd_qty    = reqd_qty_new.
        wa_final-so_stock    = so_stock_new.
        wa_final-ex_so_stock = ex_so_stock_new.
        wa_final-ex_free_stk = ex_free_stk_new.
*          WA_FINAL_ALV-SBDKZ       = WA_IDNRK-SBDKZ.
        APPEND wa_final TO it_final.  ""
        CLEAR : reqd_qty_new,
                so_stock_new ,
                ex_so_stock_new ,
                ex_free_stk_new.
      ENDAT.
    ENDLOOP.
  ENDLOOP. "LOOP AT IT_FINAL_ALV INTO IT_FINAL_ALV.
  LOOP AT it_final INTO wa_final.
    wa_final_alv-matnr       = wa_final-matnr.
    wa_final_alv-werks       = wa_final-werks.
    wa_final_alv-vbeln       = wa_final-vbeln.
    wa_final_alv-posnr       = wa_final-posnr.
    wa_final_alv-maktx       = wa_final-maktx.
    wa_final_alv-uom         = wa_final-uom.
    "--------------------
    wa_final_alv-zseries     = wa_final-zseries.
    wa_final_alv-zsize       = wa_final-zsize  .
    wa_final_alv-brand       = wa_final-brand  .
    wa_final_alv-moc         = wa_final-moc   .
    wa_final_alv-type        = wa_final-type  .
*

    wa_final_alv-reqd_qty    = wa_final-reqd_qty.
    wa_final_alv-so_stock    = wa_final-so_stock.
    wa_final_alv-ex_so_stock = wa_final-ex_so_stock.
    wa_final_alv-ex_free_stk = wa_final-ex_free_stk.
    wa_final_alv-sbdkz       = wa_idnrk-sbdkz.

    APPEND wa_final_alv TO it_final_alv.

*      CLEAR :       REQD_QTY_NEW,
*                    SO_STOCK_NEW ,
*                    EX_SO_STOCK_NEW ,
*                    EX_FREE_STK_NEW.

    SORT it_final_alv BY matnr.
    DELETE it_final_alv
    WHERE ( ex_so_stock = 0  AND ex_free_stk = 0 ).

  ENDLOOP.  "LOOP AT IT_MDPS INTO WA_MDPS.

********************************************************************************
*  BREAK SANSARI.

*ENDIF.


ENDFORM.                    " PLANT_REPORT
*======================plant changes===================================*

*
****TOP_OF_PAGE
**perform comment_build changing slis_ev_top_of_page.
***&---------------------------------------------------------------------*
***&      Form  COMMENT_BUILD
***&---------------------------------------------------------------------*
***       text
***----------------------------------------------------------------------*
***      <--P_SLIS_EV_TOP_OF_PAGE  text
***----------------------------------------------------------------------*
**FORM COMMENT_BUILD  CHANGING P_SLIS_EV_TOP_OF_PAGE.
**
**ENDFORM.                    " COMMENT_BUILD
**&---------------------------------------------------------------------*
**&      Form  STP3_EVENTTAB_BUILD
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      <--P_I_EVENTS[]  text
**----------------------------------------------------------------------*
FORM stp3_eventtab_build  CHANGING p_i_events TYPE slis_t_event..

  DATA: lf_event TYPE slis_alv_event. "Work area

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = p_i_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*  sort p_i_events by vbeln.
*----TOP_OF_PAGE
*  clear lf_event.
*  read table p_i_events with key name =  slis_ev_top_of_page
*                           binary search
*                           into lf_event.
*  if sy-subrc = 0.
  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_i_events  FROM  lf_event INDEX 3 TRANSPORTING form."to p_i_events .
*  endif.

ENDFORM.                    " STP3_EVENTTAB_BUILD
*
FORM top_of_page.
*** This FM is used to create ALV header
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_list_top_of_page[] "Internal table with
*  details which are required as header for the ALV.
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.                    " TOP_OF_PAGE

*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SLIS_EV_TOP_OF_PAGE  text
*----------------------------------------------------------------------*
FORM comment_build  CHANGING    i_list_top_of_page TYPE slis_t_listheader.
  DATA: lf_line       TYPE slis_listheader. "Work Area
*--List heading -  Type H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info = 'EXCESS INVENTORY REPORT'(010).
  APPEND lf_line TO i_list_top_of_page.
*--Head info: Type S
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = 'DATE'(011).
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.


ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  STP2_SORT_TABLE_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_SORT[]  text
*----------------------------------------------------------------------*
FORM stp2_sort_table_build  CHANGING p_i_sort TYPE slis_t_sortinfo_alv..
  DATA : lf_sort    LIKE LINE OF i_sort. "Work Area
  CLEAR : lf_sort.
  lf_sort-spos      = 1.
  lf_sort-tabname   = 'IT_FINAL_ALV'.
  lf_sort-fieldname = 'MATNR'.

*  LF_SORT-GROUP     = '*'.
  lf_sort-up        = 'X'.
  APPEND lf_sort TO p_i_sort.

ENDFORM.                    " STP2_SORT_TABLE_BUILD
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.
*        it_layout-colwidth_optimize = 'X'.
  i_layout-zebra          = 'X'.
*        p_wa_layout-Info_fieldname = 'C51'.
  p_wa_layout-zebra          = 'X'.
  p_wa_layout-no_colhead        = ' '.
  p_wa_layout-box_fieldname     = 'BOX'.
  p_wa_layout-box_tabname       = 'IT_FINAL_ALV'.

ENDFORM.                    " LAYOUT_BUILD
