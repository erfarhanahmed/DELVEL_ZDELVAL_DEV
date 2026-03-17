*&---------------------------------------------------------------------*
*& Report ZMM_SCRAP_SUBCR_REP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_scrap_subcr_rep NO STANDARD PAGE HEADING MESSAGE-ID zdel.

*---------------------------------------------------------------------------*
*                          Program Details                                  *
*---------------------------------------------------------------------------*
* Program Name         : ZMM_SCRAP_SUBCR_REP                                *
* Title                : Subcontracting Scrap Report                        *
* Created By           : Kumar Ankit                                        *
* Started On           : 5 MAY 2011                                         *
* Transaction Code     : ZMMSCRAP                                           *
* Description          : ALV presentation for Subcontracting Scrap Report   *
*---------------------------------------------------------------------------*

*REPORT  ZMM_SUBCONTRACTOR_REP

TYPE-POOLS : slis.

TYPES : BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,    " Purchasing Document Number
          ebelp TYPE ekpo-ebelp,    " Item Number of Purchasing Document
          loekz TYPE ekpo-loekz,    " Deletion Indicator in Purchasing Document
          matnr TYPE ekpo-matnr,    " Material Number
          werks TYPE ekpo-werks,    " Plant
          menge TYPE ekpo-menge,    " Purchase Order Quantity
          pstyp TYPE ekpo-pstyp,    " Item Category in Purchasing Document
        END OF ty_ekpo,

        BEGIN OF ty_ekbe,
          ebeln TYPE ekbe-ebeln,    " Purchasing Document Number
          ebelp TYPE ekbe-ebelp,    " Item Number of Purchasing Document
          belnr TYPE ekbe-belnr,    " Number of Material Document
          bwart TYPE ekbe-bwart,    " Movement Type (Inventory Management)
          budat TYPE ekbe-budat,    " Posting Date in the Document
          menge TYPE ekbe-menge,    " Quantity
          matnr TYPE ekbe-matnr,    " Material Number
          meng1 TYPE ekbe-menge,    " Quantity
        END OF ty_ekbe,

        BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,    " Purchasing Document Number
          lifnr TYPE ekko-lifnr,    " Vendor Account Number
          name1 TYPE lfa1-name1,    " Name 1
        END OF ty_ekko,

        BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,    " Account Number of Vendor or Creditor
          name1 TYPE lfa1-name1,    " Name 1
        END OF ty_lfa1,

        BEGIN OF ty_mara,
          matnr TYPE mara-matnr,    " Material Number
          moc   TYPE mara-moc,      " MOC
        END OF ty_mara,

        BEGIN OF ty_marm,
          matnr TYPE marm-matnr,    " Material Number
          meinh TYPE marm-meinh,    " Alternative Unit of Measure for Stockkeeping Unit
          umren TYPE marm-umren,    " Denominator for conversion to base units of measure
        END OF ty_marm,

        BEGIN OF ty_marm1,
          matnr TYPE marm-matnr,    " Material Number
          meinh TYPE marm-meinh,    " Alternative Unit of Measure for Stockkeeping Unit
          umren TYPE marm-umren,    " Denominator for conversion to base units of measure
        END OF ty_marm1,

        BEGIN OF ty_final,
          ebeln       TYPE ekpo-ebeln,    " Purchasing Document Number
          lifnr       TYPE ekko-lifnr,    " Vendor Account Number
          belnr       TYPE ekbe-belnr,    " Number of Material Document
          budat       TYPE ekbe-budat,    " Posting Date in the Document
          name1       TYPE adrc-name1,    " Name 1
          matnr       TYPE ekpo-matnr,    " Material Number
          moc         TYPE mara-moc,      " MOC
          menge       TYPE ekbe-menge,    " Quantity
          lv_rec_buom TYPE ekbe-menge,    " Quantity
          idnrk       TYPE stpox-idnrk,   " BOM component
          mngko       TYPE stpox-mngko,   " Calculated Component Quantity in Component Unit of Measure
          lv_rec_uom  TYPE ekbe-menge,    " Quantity
          scrap       TYPE ekbe-menge,    " Variable to Calculate the Scrap Quantity
        END OF ty_final  .

*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES
*---------------------------------------------------------------------*
DATA : it_ekpo  TYPE STANDARD TABLE OF ty_ekpo,
       wa_ekpo  TYPE ty_ekpo,
       it_ekbe  TYPE STANDARD TABLE OF ty_ekbe,
       wa_ekbe  TYPE ty_ekbe,
       it_ekko  TYPE STANDARD TABLE OF ty_ekko,
       wa_ekko  TYPE ty_ekko,
       it_lfa1  TYPE STANDARD TABLE OF ty_lfa1,
       wa_lfa1  TYPE ty_lfa1,
       it_mara  TYPE STANDARD TABLE OF ty_mara,
       wa_mara  TYPE ty_mara,
       it_marm  TYPE STANDARD TABLE OF ty_marm,
       wa_marm  TYPE ty_marm,
       it_marm1 TYPE STANDARD TABLE OF ty_marm1,
       wa_marm1 TYPE ty_marm1,
       it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final.

DATA : it_stb TYPE STANDARD TABLE OF stpox,
       wa_stb TYPE stpox.

DATA : lv_rec_buom TYPE ekbe-menge,
       lv_rec_uom  TYPE ekbe-menge,
       scrap       TYPE ekbe-menge,
       compo       TYPE ekbe-matnr,
       qty         TYPE ekpo-menge,
       uom         TYPE ekpo-meins.


*---------------------------------------------------------------------*
* ALV RELATED DATA
*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES AND CONSTANTS FOR ALV
*---------------------------------------------------------------------*
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      fieldlayout  TYPE slis_layout_alv.

DATA:
  i_sort             TYPE slis_t_sortinfo_alv, " SORT
  i_events           TYPE slis_t_event,        " EVENTS
  i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
  i_layout           TYPE slis_layout_alv,     " LAYOUT
  wa_layout          TYPE slis_layout_alv.     " LAYOUT WORKAREA

************************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname VALUE 'TOP_OF_PAGE',   " TOP_OF_PAGE
  c_formname_pf_status_set TYPE slis_formname VALUE 'PF_STATUS_SET', " PF_STATUS_SET
  c_z_alv_demo             LIKE trdir-name    VALUE 'Z_ALV_DEMO',
  c_s                      TYPE c VALUE 'S',                         " Constant for Small Header
  c_h                      TYPE c VALUE 'H'.                         " Constant for Header

************************************************************************
*                               SELECTION-SCREEN                       *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS        :  pa_werks TYPE ekpo-werks OBLIGATORY.   "
SELECT-OPTIONS    :  so_budat FOR  sy-datum.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON pa_werks.
  SELECT SINGLE werks
    FROM t001w
    INTO wa_ekpo-werks
    WHERE werks = pa_werks.
  IF sy-subrc <> 0.
    MESSAGE e023.
  ENDIF.

START-OF-SELECTION.
  PERFORM data_retrieval        TABLES    it_final .
  PERFORM stp3_eventtab_build   CHANGING  i_events[].
  PERFORM comment_build         CHANGING  i_list_top_of_page[].
  PERFORM build_fieldcatalog    TABLES    it_final.

*&---------------------------------------------------------------------*
*&      FORM  DATA_RETRIEVAL
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IT_FINAL  TEXT
*----------------------------------------------------------------------*
FORM data_retrieval  TABLES   it_final .
  SELECT ebeln
     ebelp
     loekz
     matnr
     werks
     menge
     pstyp
     FROM ekpo
     INTO CORRESPONDING FIELDS OF TABLE it_ekpo
     WHERE werks = pa_werks
     AND   loekz <> text-018
     AND   pstyp = 3.

  IF sy-subrc = 0.

    SELECT ebeln
           ebelp
           bwart
           budat
           belnr
           menge
           matnr
           FROM ekbe
           INTO CORRESPONDING FIELDS OF TABLE it_ekbe
           FOR ALL ENTRIES IN it_ekpo
           WHERE  ebeln = it_ekpo-ebeln
           AND    bwart = 101
           AND    budat IN so_budat.

    IF sy-subrc = 0.

      SELECT matnr
             moc
        FROM mara
        INTO CORRESPONDING FIELDS OF TABLE it_mara
        FOR ALL ENTRIES IN it_ekbe
        WHERE matnr = it_ekbe-matnr.



      SELECT a~ebeln
             a~lifnr
             b~name1
             INTO CORRESPONDING FIELDS OF wa_ekko
             FROM ekko AS a JOIN lfa1 AS b ON
             ( a~lifnr = b~lifnr )
             FOR ALL ENTRIES IN it_ekbe
             WHERE a~ebeln = it_ekbe-ebeln.
        APPEND wa_ekko TO it_ekko.
      ENDSELECT.
    ENDIF.
  ENDIF.

  SELECT matnr
           meinh
           umren
           FROM marm
           INTO TABLE it_marm
           FOR ALL ENTRIES IN it_ekbe
           WHERE matnr = it_ekbe-matnr
           AND   meinh = text-016.

  IF sy-subrc = 0.
    LOOP AT it_ekbe INTO wa_ekbe.
      READ TABLE it_marm INTO wa_marm WITH KEY matnr = wa_ekbe-matnr.
      IF sy-subrc = 0.
        wa_ekbe-meng1 = ( wa_ekbe-menge * wa_marm-umren ).

        MODIFY it_ekbe FROM wa_ekbe.
      ENDIF.
    ENDLOOP.
  ENDIF.

  READ TABLE it_ekpo INTO wa_ekpo WITH KEY werks = pa_werks.

  LOOP AT it_ekbe INTO wa_ekbe.
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = TEXT-017
        datuv                 = sy-datum
        emeng                 = wa_ekbe-menge
        mehrs                 = 'X'
        mtnrv                 = wa_ekbe-matnr
        svwvo                 = 'X'
        werks                 = pa_werks
        vrsvo                 = 'X'
      TABLES
        stb                   = it_stb
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    SELECT matnr
           meinh
           umren
         FROM marm
         INTO TABLE it_marm1
         FOR ALL ENTRIES IN it_stb
         WHERE matnr = it_stb-idnrk
         AND   meinh = text-016.

    LOOP AT it_stb INTO wa_stb.
      READ TABLE it_marm1 INTO wa_marm1 WITH KEY matnr = wa_stb-idnrk.
      lv_rec_uom = ( wa_stb-mngko * wa_marm1-umren ).
      scrap = lv_rec_uom - wa_ekbe-meng1.
    ENDLOOP.
    CLEAR : wa_marm1 .
    REFRESH it_marm1.

***********************************************************************
*                       SCRAP CALCULATION
***********************************************************************
    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_ekbe-matnr.
    IF sy-subrc = 0.
      wa_final-moc = wa_mara-moc.
    ENDIF.

*************************************
*MOVING DATA TO FINAL TABLE
*****************************************
    wa_final-ebeln       = wa_ekbe-ebeln.
    wa_final-lifnr       = wa_ekko-lifnr.
    wa_final-belnr       = wa_ekbe-belnr.
    wa_final-budat       = wa_ekbe-budat.
    wa_final-name1       = wa_ekko-name1.
    wa_final-matnr       = wa_ekbe-matnr.
    wa_final-moc         = wa_mara-moc.
    wa_final-menge       = wa_ekbe-menge.
    wa_final-lv_rec_buom = wa_ekbe-meng1.
    wa_final-idnrk       = wa_stb-idnrk.
    wa_final-mngko       = wa_stb-mngko.
    wa_final-lv_rec_uom  = lv_rec_uom.
    wa_final-scrap       = scrap.
    APPEND wa_final TO it_final.

    CLEAR wa_final.
  ENDLOOP.
ENDFORM.                    " DATA_RETRIEVAL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      FORM  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IT_FINAL  TEXT
*----------------------------------------------------------------------*
FORM build_fieldcatalog TABLES it_final .
  DATA: i_fieldcat  TYPE   slis_t_fieldcat_alv,
        wa_fieldcat TYPE   slis_fieldcat_alv.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-002.
  wa_fieldcat-seltext_m   = 'PO Number'.
  wa_fieldcat-key         = 'X'.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 10.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-003.
  wa_fieldcat-seltext_m   = 'Vendor'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 10.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-004.
  wa_fieldcat-seltext_m   = 'Material Doc. No.'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 18.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-005.
  wa_fieldcat-seltext_m   = 'Posting Date'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 12.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-006.
  wa_fieldcat-seltext_m   = 'Name'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 18.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-007.
  wa_fieldcat-seltext_m   = 'Material'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 18.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-008.
  wa_fieldcat-seltext_m   = 'MOC'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 5.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-009.
  wa_fieldcat-seltext_m   = 'Qty in EA'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 13.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-010.
  wa_fieldcat-seltext_m   = 'Qty in KG'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 13.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-011.
  wa_fieldcat-seltext_m   = 'Component'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 18.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-012.
  wa_fieldcat-seltext_m   = 'Qty in EA'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 13.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-013.
  wa_fieldcat-seltext_m   = 'Comp. Qty in KG'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 13.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CLEAR  wa_fieldcat.
  wa_fieldcat-fieldname   = TEXT-014.
  wa_fieldcat-seltext_m   = 'Scrap Qty in KG'.
  wa_fieldcat-key         = ' '.
  wa_fieldcat-col_pos     = 0.
  wa_fieldcat-outputlen   = 13.
  wa_fieldcat-just        = 'C'.
  APPEND wa_fieldcat TO i_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'X'
      is_layout              = i_layout
      it_fieldcat            = i_fieldcat
      i_default              = 'X'
      i_save                 = 'X'
      it_events              = i_events[]
    TABLES
      t_outtab               = it_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  REFRESH it_final.
ENDFORM.                    " BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

*&      FORM  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_I_EVENTS[]  TEXT
*----------------------------------------------------------------------*
FORM stp3_eventtab_build  CHANGING p_i_events TYPE slis_t_event...
  DATA: lf_event TYPE slis_alv_event. "WORK AREA

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

  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_i_events  FROM  lf_event INDEX 3 TRANSPORTING form."TO P_I_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      FORM  COMMENT_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_I_LIST_TOP_OF_PAGE[]  TEXT
*----------------------------------------------------------------------*
FORM comment_build  CHANGING p_i_list_top_of_page TYPE slis_t_listheader..
  DATA: lf_line       TYPE slis_listheader. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info = 'Subcontracting Scrap Report'.
  APPEND lf_line TO i_list_top_of_page.
*--HEAD INFO: TYPE S
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = TEXT-015.
  lf_line-info = sy-datum.
  WRITE sy-datum  TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.

ENDFORM.                    " COMMENT_BUILD

*PERFORM TOP_OF_PAGE.
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
      it_list_commentary = i_list_top_of_page.
ENDFORM.                    " TOP_OF_PAGE
