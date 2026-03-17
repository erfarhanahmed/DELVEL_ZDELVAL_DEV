*&---------------------------------------------------------------------*
*& Report ZBOM_COST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbom_cost.


TABLES : cki64a,  keko ,tckh1 ,plm_alv_230, mara, zohperc.
TABLES : stpox, cscmat.

DATA: i_stpo TYPE STANDARD TABLE OF stpo.

DATA: i_stpox TYPE STANDARD TABLE OF stpox,
      w_stpox TYPE stpox.

DATA: i_csxequi TYPE STANDARD TABLE OF csxequi,
      w_csxequi TYPE csxequi,

      i_csxtpl  TYPE STANDARD TABLE OF csxtpl,
      w_csxtpl  TYPE  csxtpl,

      i_csxmat  TYPE STANDARD TABLE OF csxmat,
      w_csxmat  TYPE  csxmat,

      i_csxdoc  TYPE STANDARD TABLE OF csxdoc,
      w_csxdoc  TYPE  csxdoc,

      i_csxgen  TYPE STANDARD TABLE OF csxgen,
      w_csxgen  TYPE  csxgen,

      i_csxkla  TYPE STANDARD TABLE OF csxkla,
      w_csxkla  TYPE csxkla,

      it_matcat TYPE STANDARD TABLE OF cscmat WITH HEADER LINE.



TYPES : BEGIN OF ty_keko,
          kalnr   TYPE keko-kalnr,
          kalka   TYPE keko-kalka,
          kadky   TYPE keko-kadky,
          tvers   TYPE keko-tvers,
          matnr   TYPE keko-matnr,
          werks   TYPE keko-werks,
          kadat   TYPE keko-kadat,
          bidat   TYPE keko-bidat,
          aldat   TYPE keko-aldat,
          feh_sta TYPE keko-feh_sta,
*          sobsl   TYPE keko-sobsl,
          klvar   TYPE keko-klvar,
          poper   TYPE keko-poper,
          bdatj   TYPE keko-bdatj,
*          beskz   TYPE keko-beskz,
        END OF ty_keko.

TYPES : BEGIN OF ty_keph,
          kalnr  TYPE  keph-kalnr,
          kalka  TYPE  keph-kalka,
          kadky  TYPE  keph-kadky,
          tvers  TYPE  keph-tvers,
          kst001 TYPE keph-kst001,
          kst003 TYPE keph-kst003,
          kst005 TYPE keph-kst005,
          kst017 TYPE keph-kst017,
        END OF ty_keph.


TYPES: BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt.


TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
       END OF ty_mara.


TYPES: BEGIN OF ty_mbew,
         matnr TYPE mbew-matnr,
         bwkey TYPE mbew-bwkey,
         vprsv TYPE mbew-vprsv,
       END OF ty_mbew.


TYPES : BEGIN OF ty_zoh,
          poper  TYPE zohperc-poper,
          bdatj  TYPE zohperc-bdatj,
          zohper TYPE zohperc-zohper,
        END OF ty_zoh.

TYPES : BEGIN OF ty_marc,
          matnr TYPE marc-matnr,
          beskz TYPE marc-beskz,
          sobsl TYPE marc-sobsl,
        END OF ty_marc.


DATA : it_marc TYPE TABLE OF ty_marc,
       wa_marc TYPE ty_marc.


DATA : it_zoh TYPE TABLE OF ty_zoh,
       wa_zoh TYPE ty_zoh.


DATA : it_keko TYPE TABLE OF ty_keko,
       wa_keko TYPE ty_keko,

       it_keph TYPE TABLE OF ty_keph,
       wa_keph TYPE ty_keph,

       it_makt TYPE TABLE OF ty_makt,
       wa_makt TYPE ty_makt,

       it_mara TYPE TABLE OF ty_mara,
       wa_mara TYPE ty_mara,

       it_mbew TYPE  TABLE OF ty_mbew,
       wa_mbew TYPE ty_mbew.

DATA:  roll_up_cost TYPE kbetr.
DATA: tot_cost2 TYPE kbetr,
      tot_cost3 TYPE kbetr.

DATA : oh_cost  TYPE char20,
       tot_cost TYPE kbetr.


TYPES : BEGIN OF ty_final,
          werks        TYPE keko-werks,            "plant
          matnr        TYPE keko-matnr,            "material
          feh_sta      TYPE keko-feh_sta,          "Costing Status
          tvers        TYPE keko-tvers,            "Costing Version
          kalka        TYPE keko-kalka,            "Costing Type
          klvar        TYPE keko-klvar,            "Costing Variant
          kadat        TYPE keko-kadat,            "Costing Date From
          bidat        TYPE keko-bidat,            "Costing Date To
          aldat        TYPE keko-aldat,           "Qty. Structure Date
          poper        TYPE keko-poper,            "Posting Period
          bdatj        TYPE keko-bdatj,             "Year
          beskz        TYPE marc-beskz,            "Procurement Type
          sobsl        TYPE marc-sobsl,               "Special procurement
          kadky        TYPE keko-kadky,                "Costing Key Date
          kalnr        TYPE keko-kalnr,             "Cost Estimate Number - Product Costing
          kst001       TYPE keph-kst001,         "Material Cost
          kst003       TYPE keph-kst003,         "Machine Hours'
          kst005       TYPE keph-kst005,           "Labour Hours
          kst017       TYPE keph-kst017,          "Subcontracting Cost
          maktx        TYPE makt-maktx,            "Material description
          mtart        TYPE mara-mtart,            "Material Type
          bwkey        TYPE mbew-bwkey,
          vprsv        TYPE mbew-vprsv,            "Price control
          roll_up_cost TYPE kbetr,            "roll up cost
          zohper       TYPE zohperc-zohper,     "OH Perc
          oh_cost      TYPE char20,               "Oh Cost
          tot_cost     TYPE kbetr,                "total cost
        END OF ty_final.

DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.



TYPES : BEGIN OF ty_down,
          werks        TYPE keko-werks,            "plant
          kalnr        TYPE keko-kalnr,             "Cost Estimate Number - Product Costing
          kadky        TYPE char20,            "keko-kadky,                "Costing Key Date
          matnr        TYPE keko-matnr,            "material
          mtart        TYPE mara-mtart,            "Material Type
          vprsv        TYPE mbew-vprsv,            "Price control
          beskz        TYPE marc-beskz,            "Procurement Type
          sobsl        TYPE marc-sobsl,               "Special procurement
          feh_sta      TYPE keko-feh_sta,          "Costing Status
          tvers        TYPE keko-tvers,            "Costing Version
          klvar        TYPE keko-klvar,            "Costing Variant
          kadat        TYPE char20,          "keko-kadat,            "Costing Date From
          bidat        TYPE char20,           "keko-bidat,            "Costing Date To
          aldat        TYPE char20,          "keko-aldat,           "Qty. Structure Date
          poper        TYPE keko-poper,            "Posting Period
          bdatj        TYPE keko-bdatj,             "Year
          kst001       TYPE char20,            "keph-kst001,         "Material Cost
          kst003       TYPE char20,            "keph-kst003,         "Machine Hours'
          kst005       TYPE char20,            "keph-kst005,           "Labour Hours
          kst017       TYPE char20,            "keph-kst017,          "Subcontracting Cost
          roll_up_cost TYPE kbetr,            "roll up cost
          zohper       TYPE zohperc-zohper,     "OH Perc
          oh_cost      TYPE char20,               "Oh Cost
          tot_cost     TYPE kbetr,                "total cost
          ref_dat      TYPE char15,                         "Refresh Date
          ref_time     TYPE char15,                        "Refresh Time
        END OF ty_down.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.




DATA : ls_layout TYPE slis_layout_alv.
DATA : gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gs_fieldcat TYPE slis_fieldcat_alv.

DATA : ls_line    TYPE slis_listheader,
       vn_top     TYPE slis_t_listheader,
       l_line(40),
       line       TYPE string.


DATA : it_event TYPE slis_t_event,
       wa_event LIKE LINE OF it_event.

DATA : fs_layout TYPE slis_layout_alv.

DATA : it_header TYPE slis_t_listheader,
       wa_header LIKE LINE OF it_header.



DATA: v_repid LIKE sy-repid.


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : p_werks    FOR keko-werks   OBLIGATORY,
                 p_matnr    FOR keko-matnr  ,
                 p_klvar    FOR keko-klvar   OBLIGATORY,
                 p_kadat    FOR keko-kadat   ,
                 p_bidat    FOR keko-bidat   ,
                 p_feh      FOR keko-feh_sta   OBLIGATORY,
                 p_tvers    FOR keko-tvers   OBLIGATORY.
PARAMETERS:      p_mtart    TYPE mara-mtart.
SELECT-OPTIONS : p_bdatj    FOR keko-bdatj.

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

  PERFORM fetch_data.
  PERFORM fieldcatlog.
  PERFORM display.
  PERFORM get_event.



FORM fetch_data .

*  BREAK primus.


  SELECT   kalnr
           kalka
           kadky
           tvers
           matnr
           werks
           kadat
           bidat
           aldat
           feh_sta
           klvar
           poper
           bdatj FROM keko INTO TABLE it_keko WHERE werks   IN p_werks  AND
                                                    matnr   IN p_matnr  AND
                                                    klvar   IN p_klvar  AND
                                                    kadat   IN p_kadat   AND
                                                    bidat   IN p_bidat   AND
                                                    feh_sta IN p_feh  AND
                                                    tvers   IN p_tvers AND bdatj IN p_bdatj.

  IF  it_keko IS NOT INITIAL.

    SELECT kalnr
           kalka
           kadky
           tvers
           kst001
           kst003
           kst005
           kst017 FROM keph INTO TABLE it_keph FOR ALL ENTRIES IN it_keko WHERE kalnr = it_keko-kalnr
                                                                          AND kalka = it_keko-kalka
                                                                          AND kadky = it_keko-kadky
                                                                          AND tvers = it_keko-tvers AND  kkzst = ' '.

  ENDIF.


  IF it_keko IS NOT INITIAL.

    SELECT matnr
           maktx  FROM makt INTO TABLE it_makt FOR ALL ENTRIES IN it_keko WHERE matnr = it_keko-matnr.



  ENDIF.

  IF it_keko IS NOT INITIAL.


    SELECT matnr
           mtart FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_keko WHERE matnr = it_keko-matnr  AND mtart = p_mtart.

*      DELETE it_mara WHERE mtart = space.

IF it_mara IS INITIAL.

 SELECT matnr
           mtart FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_keko WHERE matnr = it_keko-matnr  .

ENDIF.

ENDIF.


  IF it_keko IS NOT INITIAL.

    SELECT matnr
           bwkey
           vprsv  FROM mbew INTO TABLE it_mbew FOR ALL ENTRIES IN it_keko WHERE matnr = it_keko-matnr AND bwkey = it_keko-werks AND bwtar = ' '.

  ENDIF.



  IF it_keko IS NOT INITIAL .

    SELECT  poper
            bdatj
            zohper FROM zohperc INTO TABLE it_zoh FOR ALL ENTRIES IN it_keko WHERE  poper = it_keko-poper AND bdatj = it_keko-bdatj.

  ENDIF.

  IF it_keko IS NOT INITIAL .

    SELECT matnr
           beskz
           sobsl FROM marc INTO TABLE it_marc FOR ALL ENTRIES IN it_keko WHERE  matnr = it_keko-matnr .

  ENDIF.

*  BREAK primus.

  LOOP AT it_keko INTO wa_keko .

    IF sy-subrc = 0.

      wa_final-kalnr = wa_keko-kalnr.
      wa_final-kalka = wa_keko-kalka.
      wa_final-kadky = wa_keko-kadky.
      wa_final-tvers = wa_keko-tvers.
      wa_final-matnr = wa_keko-matnr.
      wa_final-werks = wa_keko-werks.
      wa_final-kadat = wa_keko-kadat.
      wa_final-bidat = wa_keko-bidat.
      wa_final-aldat = wa_keko-aldat.
      wa_final-feh_sta = wa_keko-feh_sta.
*      wa_final-sobsl = wa_keko-sobsl.
      wa_final-klvar = wa_keko-klvar.
      wa_final-poper = wa_keko-poper.
      wa_final-bdatj  = wa_keko-bdatj.
*      wa_final-beskz = wa_keko-beskz.

    ENDIF.

    READ TABLE it_keph INTO wa_keph WITH  KEY  kalnr = wa_final-kalnr kalka = wa_final-kalka kadky = wa_final-kadky tvers = wa_final-tvers.

    IF sy-subrc = 0.

      wa_final-kst001 = wa_keph-kst001.
      wa_final-kst003 = wa_keph-kst003.
      wa_final-kst005 = wa_keph-kst005.
      wa_final-kst017 = wa_keph-kst017.

    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH  KEY matnr = wa_final-matnr.

    IF sy-subrc = 0.

      wa_final-maktx = wa_makt-maktx.

    ENDIF.

*    BREAK primus.

    READ TABLE it_mara INTO wa_mara WITH  KEY matnr = wa_final-matnr.

    IF sy-subrc = 0.

      wa_final-mtart = wa_mara-mtart.
*      wa_final-mtart = p_mtart.


    ENDIF.

*    IF it_mara IS  INITIAL.
*
*      SELECT SINGLE mtart FROM mara INTO  wa_final-mtart WHERE  matnr = wa_final-matnr.
*    ENDIF.

*    BREAK primus.

    READ TABLE it_mbew INTO wa_mbew WITH  KEY matnr = wa_final-matnr.  " bwkey = wa_final-bwkey.

    IF  sy-subrc = 0.

      wa_final-vprsv = wa_mbew-vprsv.
      wa_final-bwkey = wa_mbew-bwkey.

    ENDIF.


    IF  sy-subrc = 0.


      tot_cost2 = wa_final-kst001 + wa_final-kst003 + wa_final-kst005 + wa_final-kst017 .

      wa_final-roll_up_cost = tot_cost2.

    ENDIF.

    READ TABLE it_zoh INTO wa_zoh WITH KEY   poper = wa_final-poper bdatj = wa_final-bdatj.

    IF sy-subrc = 0.

      wa_final-zohper = wa_zoh-zohper.
      wa_final-poper = wa_zoh-poper.
      wa_final-bdatj = wa_zoh-bdatj.

      IF  sy-subrc = 0.
        tot_cost3 = wa_final-kst001 * wa_final-zohper.
        wa_final-oh_cost = tot_cost3.
      ENDIF.

      wa_final-tot_cost = wa_final-oh_cost + wa_final-roll_up_cost .

    ENDIF.


    READ TABLE it_marc INTO wa_marc WITH  KEY matnr = wa_final-matnr.

    IF  sy-subrc = 0.

      wa_final-beskz = wa_marc-beskz.
      wa_final-sobsl = wa_marc-sobsl.

    ENDIF.

*    LOOP AT it_mara INTO wa_mara .
*
*      IF sy-subrc = 0.
*
*        wa_final-matnr = wa_mara-matnr.
**        wa_final-mtart = wa_mara-mtart.
**        wa_final-mtart = p_mtart.
*
*      ENDIF.
*ENDLOOP.

*    IF wa_final-kst017 NE wa_final-kst001.
*
*      tot_cost2 = wa_final-kst001 + wa_final-kst002 + wa_final-kst005 +  wa_final-kst017 .
*
*      wa_final-kst001 = tot_cost2 .
*
*    ENDIF.
*

*
*    wa_final-roll_up_cost = tot_cost2.

*    wa_final-roll_up_cost = wa_FINAL-KST001 + wa_FINAL-KST002 + wa_FINAL-KST005 + wa_FINAL-KST017.

*    DELETE it_final WHERE mtart = space.



    APPEND wa_final TO it_final.
    CLEAR: wa_final.
    CLEAR : wa_mbew,wa_keko,wa_keph,wa_mara.

*    DELETE ADJACENT DUPLICATES FROM it_final .
  ENDLOOP.
  IF p_mtart IS NOT INITIAL.
    DELETE  it_final WHERE mtart NE p_mtart .
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcatlog .

  REFRESH gt_fieldcat.

  DATA(cnt) = 0.
  cnt = cnt + 1.


  PERFORM gt_fieldcat USING  cnt   'WERKS'       'Plant'.                     cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KALNR'       'Cost Estimate Number'. cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KADKY'       'Costing Key Date'. cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'MATNR'       'Material'.                  cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'MTART'       'Material Type'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'VPRSV'       'Price Control'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'BESKZ'       'Procurement Type'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'SOBSL'       'Special Procurement Type'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'FEH_STA'       'Costing Status'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'TVERS'       'Costing Version'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KLVAR'       'Costing Variant'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KADAT'       'Costing Date From'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'BIDAT'       'Costing Date To'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'ALDAT'       'Qty. Structure Date'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'POPER'       'Posting Period'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'BDATJ'       'Year'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KST001'       'Material Cost'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KST003'       'Machine Hour Cost'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KST005'       'Labour Hour Cost'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'KST017'       'Subcontracting Cost'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'ROLL_UP_COST'  'Roll Up Cost'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'ZOHPER'       'OH %'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'OH_COST'       'OH Cost'.             cnt = cnt + 1.
  PERFORM gt_fieldcat USING  cnt   'TOT_COST'       'Total Cost'.             cnt = cnt + 1.




  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CNT  text
*      -->P_0973   text
*      -->P_0974   text
*----------------------------------------------------------------------*
FORM gt_fieldcat  USING    p_cnt
                             VALUE(p_0973)
                             VALUE(p_0974).

  gt_fieldcat-col_pos = p_cnt.
  gt_fieldcat-fieldname = p_0973.
  gt_fieldcat-seltext_l = p_0974.
  APPEND gt_fieldcat.
  CLEAR gs_fieldcat.

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
      i_callback_program     = sy-repid
      is_layout              = fs_layout
      i_callback_top_of_page = 'TOP_OF_PAGE'
      it_fieldcat            = gt_fieldcat[]
*     IT_SORT                = T_SORT[]
      i_save                 = 'X'
      it_events              = it_event
    TABLES
      t_outtab               = it_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.


  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_event .


  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = it_event
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE it_event INTO wa_event WITH KEY name = 'TOP_OF_PAGE'.

  wa_event-form = 'TOP_OF_PAGE'.
  MODIFY it_event FROM wa_event INDEX sy-tabix.

ENDFORM.




FORM top_of_page.
  DATA : date1 TYPE string.

  wa_header-typ = 'H'.  "header
  wa_header-info = 'Standard Costing Report'.
  APPEND wa_header TO it_header.
  CLEAR wa_header.

  CONCATENATE sy-datum+6(2) ' : ' sy-datum+4(2)' : ' sy-datum(4) INTO date1 SEPARATED BY space.

  wa_header-typ = 'S'. "selection
  wa_header-key = 'USER : '.
  wa_header-info = sy-uname.
  APPEND wa_header TO it_header.
  CLEAR wa_header.

  wa_header-typ = 'S'. "Action
  wa_header-key = 'Current Date : '.
  wa_header-info = date1.
  APPEND wa_header TO it_header.
  CLEAR: wa_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_header
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
  CLEAR it_header.


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

    IF  sy-subrc = 0.

      ls_down-werks    = wa_final-werks.
      ls_down-kalnr    = wa_final-kalnr.
*      ls_down-kadky    = wa_final-kadky.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-kadky
        IMPORTING
          output = ls_down-kadky.

      CONCATENATE ls_down-kadky+0(2) ls_down-kadky+2(3) ls_down-kadky+5(4)
     INTO ls_down-kadky SEPARATED BY '-'.


      ls_down-matnr    = wa_final-matnr.
      ls_down-mtart    = wa_final-mtart.
      ls_down-vprsv    = wa_final-vprsv.
      ls_down-beskz    = wa_final-beskz.
      ls_down-sobsl    = wa_final-sobsl.
      ls_down-feh_sta  = wa_final-feh_sta.
      ls_down-tvers    = wa_final-tvers.
      ls_down-klvar    = wa_final-klvar.

*      ls_down-kadat    = wa_final-kadat.
*      ls_down-bidat    = wa_final-bidat.
*      ls_down-aldat    = wa_final-aldat.



      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-kadat
        IMPORTING
          output = ls_down-kadat.

      CONCATENATE ls_down-kadat+0(2) ls_down-kadat+2(3) ls_down-kadat+5(4)
     INTO ls_down-kadat SEPARATED BY '-'.



      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-bidat
        IMPORTING
          output = ls_down-bidat.

      CONCATENATE ls_down-bidat+0(2) ls_down-bidat+2(3) ls_down-bidat+5(4)
     INTO ls_down-bidat SEPARATED BY '-'.



      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-aldat
        IMPORTING
          output = ls_down-aldat.

      CONCATENATE ls_down-aldat+0(2) ls_down-aldat+2(3) ls_down-aldat+5(4)
     INTO ls_down-aldat SEPARATED BY '-'.



      ls_down-poper    = wa_final-poper.
      ls_down-bdatj    = wa_final-bdatj.
      ls_down-kst001   = wa_final-kst001.
      ls_down-kst003   = wa_final-kst003.
      ls_down-kst005   = wa_final-kst005.
      ls_down-kst017   = wa_final-kst017.
      ls_down-roll_up_cost = wa_final-roll_up_cost.
      ls_down-zohper      = wa_final-zohper.
      ls_down-oh_cost     = wa_final-oh_cost.
      ls_down-tot_cost    = wa_final-tot_cost.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = ls_down-ref_dat.
      CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
     INTO ls_down-ref_dat SEPARATED BY '-'.

      ls_down-ref_time = sy-uzeit.
      CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.



      IF  wa_final-kst003 = 0.
        ls_down-kst003 = space.
      ELSE.
        ls_down-kst003      = wa_final-kst003.
      ENDIF.

      IF  wa_final-kst005 = 0.
        ls_down-kst005 = space.
      ELSE.
        ls_down-kst005      = wa_final-kst005.
      ENDIF.


      IF  wa_final-kst017 = 0.
        ls_down-kst017 = space.
      ELSE.
        ls_down-kst017      = wa_final-kst017.
      ENDIF.



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
  lv_file = 'ZBOM_COST.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZBOM_COST Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_853 TYPE string.
DATA lv_crlf_853 TYPE string.
lv_crlf_853 = cl_abap_char_utilities=>cr_lf.
lv_string_853 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_853 lv_crlf_853 wa_csv INTO lv_string_853.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_853 TO lv_fullfile.
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

  CONCATENATE    'Plant'
                 'Cost Estimate Number'
                 'Costing Key Date'
                 'Material'
                 'Material Type'
                 'Price Control'
                 'Procurement Type'
                 'Special Procurement Type'
                 'Costing Status'
                 'Costing Version'
                 'Costing Variant'
                 'Costing Date From'
                 'Costing Date To'
                 'Qty. Structure Date'
                 'Posting Period'
                 'Year'
                 'Material Cost'
                 'Machine Hour Cost'
                 'Labour Hour Cost'
                 'Subcontracting Cost'
                 'Roll Up Cost'
                 'OH %'
                 'OH Cost'
                 'Total Cost'
                 'Ref Date'
                 'Ref Time'
                 INTO p_hd_csv
                 SEPARATED BY l_field_seperator..

ENDFORM.
