*&---------------------------------------------------------------------*
*& Report  ZSD_FORMC
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsd_formc MESSAGE-ID zdel.

TABLES : VBRK.

TYPES : BEGIN OF t_vbrk,
          vbeln TYPE vbeln_vf,
          knumv TYPE knumv,
          fkdat TYPE fkdat,
*          RFBSK  TYPE RFBSK,   " Status for transfer to accounting
          taxk1	TYPE taxk1,   "	Tax classification 1 for customer
          netwr TYPE netwr,   " Net Value in Document Currency
          kunag TYPE kunag,
          mwsbk	TYPE mwsbp,   "	Tax amount in document currency
          fksto	TYPE fksto,   "	Billing document is cancelled
          gjahr TYPE gjahr,
        END OF t_vbrk,

        BEGIN OF t_kna1,
          kunnr TYPE kunnr,
          name1 TYPE name1_gp, " Customer Name
        END OF t_kna1,

        BEGIN OF t_konv,
          knumv TYPE knumv,
          kposn TYPE kposn,
          kwert TYPE kwert,   " Condition value
          waers TYPE waers,   "	Currency Key
        END OF t_konv,

        BEGIN OF t_zfrmc,
          vbeln TYPE vbeln_vf,
          frcvd TYPE zrcvd,    "  Received : Yes/No
          frdat	TYPE zfrdt,
          frval TYPE zfrval,
          crunt TYPE waers,
          frmnr	TYPE zfrmnr,    " Form Number
        END OF t_zfrmc,

        BEGIN OF t_qurtr,
          id(3) TYPE c,
          b     TYPE int2,
          e     TYPE int2,
        END OF t_qurtr,

        " CHANGES DONE BY SAUIMTRA MANI TIWARI "
        BEGIN OF t_j_1iexchdr,
          rdoc  TYPE j_1irdoc1, " REF DOC 1
          exnum TYPE j_1iexcnum, " EXCISE DOC NO
          exdat TYPE j_1iexcdat, " EXCISE DOC DATE
        END OF t_j_1iexchdr,

        BEGIN OF t_docyr,
          vbeln TYPE vbeln_vf,
          docyr TYPE j_1idocuyr,
        END OF t_docyr,

        tt_qurtr TYPE TABLE OF t_qurtr,

        BEGIN OF t_result,
          exnum      TYPE j_1iexcnum,
          exdat      TYPE j_1iexcdat,
          kunag      TYPE kunag,
          kunag_name TYPE name1_gp, " Customer Name
          kwert      TYPE kwert,
          taxk1	     TYPE taxk1,
          frcvd      TYPE zrcvd,    "  Received : Yes/No
          frdat	     TYPE zfrdt,
          frval      TYPE zfrval,
          crunt      TYPE waers,
          frmnr	     TYPE zfrmnr,    " Form Number
          qrtr       TYPE int1,
          qurtr      TYPE char9,
          balns      TYPE jbbsaldo,
          cellstyles TYPE lvc_t_styl,
          fkdat      TYPE fkdat,
          vbeln      TYPE vbeln_vf,
        END OF t_result,

        t_kunag   TYPE RANGE OF kna1-kunnr,
        t_vkorg   TYPE RANGE OF vbrk-vkorg,
        t_vtweg   TYPE RANGE OF vbrk-vtweg,
        t_fkdat   TYPE RANGE OF sy-datum,
        tb_result TYPE TABLE OF t_result.

DATA : wa       TYPE t_result,
       it       TYPE tb_result,
       sublist  TYPE tb_result,
       it_qurtr TYPE tt_qurtr,
       ok_comm  TYPE sy-ucomm.

DATA : cntnr        TYPE REF TO cl_gui_custom_container,
       cntrl        TYPE scrfname VALUE 'CUST_CTRL',
       it_fcat      TYPE lvc_t_fcat,
       wa_lout      TYPE lvc_s_layo,
       it_sort      TYPE lvc_t_sort,
       cntnr1       TYPE REF TO cl_gui_container,
       it_chngs     TYPE lvc_t_modi,
       chk          TYPE i VALUE 0,

       " INTERNAL TABLE AND WA FOR T_J_IEXCHDR "
       i_j_1iexchdr TYPE STANDARD TABLE OF t_j_1iexchdr,
       w_j_1iexchdr TYPE t_j_1iexchdr,
       " for t_docyr "
       i_docyr      TYPE STANDARD TABLE OF t_docyr,
       w_docyr      TYPE t_docyr.


INCLUDE zsd_formc_cls.   "Z_LCLASSES.

DATA : grid    TYPE REF TO lcl_gui_alv_grid,
       evhndlr TYPE REF TO lcl_event_handler.

TABLES: kna1.

*>>
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: p_kunag FOR kna1-kunnr OBLIGATORY.
SELECT-OPTIONS: p_vkorg for vbrk-vkorg no INTERVALS no-EXTENSION,
                p_vtweg for vbrk-vtweg no INTERVALS no-EXTENSION.
SELECT-OPTIONS: p_fkdat FOR sy-datum OBLIGATORY.
PARAMETERS: p_taxk1 TYPE vbrk-taxk1 OBLIGATORY,
            p_recvd TYPE zrcvd AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b1.

*>>
START-OF-SELECTION.
  PERFORM set_qrtrs TABLES it_qurtr.
  PERFORM fetch_list TABLES it
                            it_qurtr
                            p_kunag
                            p_fkdat
                     USING  p_vkorg[]
                            p_vtweg[]
                            p_taxk1
                            p_recvd.
  PERFORM set_readonly_display TABLES it it_fcat it_sort USING p_taxk1 CHANGING wa_lout.
  SET SCREEN 1111.
*&---------------------------------------------------------------------*
*&      Module  INIT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init OUTPUT.
  PERFORM reset_status USING p_recvd ok_comm.
  IF grid IS INITIAL.
    PERFORM set_alv USING cntrl CHANGING cntnr grid.

    " To handle validationnon change of cell-data
    CALL METHOD grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  IF evhndlr IS INITIAL.
    CREATE OBJECT evhndlr.
    SET HANDLER evhndlr->handle_hotspot_click FOR grid.
    SET HANDLER evhndlr->handle_data_change_validity FOR grid.
  ENDIF.
  IF NOT it IS INITIAL.
    PERFORM disp_alv TABLES it
                            it_fcat
                            it_sort
                     USING wa_lout
                     CHANGING grid.
  ENDIF.
ENDMODULE.                 " INIT  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  ACT_USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE act_user_command INPUT.
  CASE ok_comm.

    WHEN 'EXEC'.
      PERFORM fetch_list TABLES it
                                it_qurtr
                                p_kunag
                                p_fkdat
                          USING p_vkorg[]
                                p_vtweg[]
                                p_taxk1
                                p_recvd.
      PERFORM set_readonly_display TABLES it it_fcat it_sort USING p_taxk1 CHANGING wa_lout.

    WHEN 'RFRS'.
      PERFORM fetch_list TABLES it
                                it_qurtr
                                p_kunag
                                p_fkdat
                          USING p_vkorg[]
                                p_vtweg[]
                                p_taxk1
                                p_recvd.
      PERFORM set_readonly_display TABLES it it_fcat it_sort USING p_taxk1 CHANGING wa_lout.

    WHEN 'EDIT'.
      PERFORM set_editable TABLES it_fcat it USING grid.

    WHEN 'UPDT'.
      PERFORM update_list TABLES it USING grid.
      PERFORM fetch_list TABLES it
                                it_qurtr
                                p_kunag
                                p_fkdat
                          USING p_vkorg[]
                                p_vtweg[]
                                p_taxk1
                                p_recvd.
      PERFORM set_editable TABLES it_fcat it USING grid.

    WHEN 'BACK'.
*      LEAVE TO LIST-PROCESSING AND RETURN TO SCREEN 0.
*      LEAVE SCREEN.
      PERFORM init_flow.
    WHEN 'RW'.
      LEAVE TO LIST-PROCESSING AND RETURN TO SCREEN 0.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " ACT_USER_COMMAND  INPUT

MODULE check_data_validity INPUT.
  IF sy-ucomm = 'UPDT'.
    PERFORM check_data_validity TABLES it it_chngs CHANGING chk.
    IF chk NE 0.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.
ENDMODULE.

FORM reset_status USING v_rcvd TYPE zrcvd
                        v_comm TYPE sy-ucomm.
  DATA  fnctns TYPE TABLE OF sy-ucomm.
  APPEND 'EXEC' TO fnctns.

  IF v_rcvd EQ 'X' OR v_comm EQ 'EDIT' OR v_comm EQ 'UPDT'.
    APPEND 'EDIT' TO fnctns.
  ENDIF.
  IF v_comm NE 'EDIT' AND v_comm NE 'UPDT'.
    APPEND 'UPDT' TO fnctns.
  ENDIF.
  SET PF-STATUS 'ZST_FRMC' EXCLUDING fnctns.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISP_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->V_IT       text
*      -->V_FCAT     text
*      -->V_SORT     text
*      -->V_LOUT     text
*      -->V_GRID     text
*----------------------------------------------------------------------*
FORM disp_alv TABLES v_it   TYPE tb_result
                     v_fcat TYPE lvc_t_fcat
                     v_sort TYPE lvc_t_sort
              USING  v_lout TYPE lvc_s_layo
              CHANGING v_grid TYPE REF TO lcl_gui_alv_grid.

  DATA : factv TYPE i VALUE 0.

  CLEAR factv.

  CALL METHOD v_grid->is_alive
    RECEIVING
      state = factv.

  IF factv EQ 0.  " Not Yet Displayed
    CALL METHOD v_grid->set_table_for_first_display
      EXPORTING
*       I_BUFFER_ACTIVE               =
*       I_BYPASSING_BUFFER            =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME              =
*       IS_VARIANT                    =
*       I_SAVE                        =
*       I_DEFAULT                     = 'X'
        is_layout                     = v_lout
*       IS_PRINT                      =
*       IT_SPECIAL_GROUPS             =
*       IT_TOOLBAR_EXCLUDING          =
*       IT_HYPERLINK                  =
*       IT_ALV_GRAPHICS               =
*       IT_EXCEPT_QINFO               =
*       IR_SALV_ADAPTER               =
      CHANGING
        it_outtab                     = v_it[]
        it_fieldcatalog               = v_fcat[]
        it_sort                       = v_sort[]
*       IT_FILTER                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.                 " Refresh Display
    CALL METHOD v_grid->refresh_table_display.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.                    " DISP_ALV

*&---------------------------------------------------------------------*
*&      Form  SET_READONLY_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->V_IT       text
*      -->V_FCAT     text
*      -->V_SORT     text
*      -->V_LOUT     text
*----------------------------------------------------------------------*
FORM set_readonly_display TABLES v_it   TYPE tb_result
                                 v_fcat TYPE lvc_t_fcat
                                 v_sort TYPE lvc_t_sort
                          USING  v_taxk1 TYPE c
                          CHANGING v_lout TYPE lvc_s_layo.
  DATA : setcustlink TYPE c VALUE ''.

  " IF P_TAXK1 = 'C'.
  setcustlink = ''." To enable the link to smartform set this to 'X'.
  " ENDIF.

  " Prepare fieldCatalog
  REFRESH : v_fcat.
  PERFORM build_field_catalog TABLES v_fcat
    USING : '1' '1' 'FKDAT'       'IT' 'FKDAT'     '' '' '' '' '' '' 9,
            '1' '2' 'VBELN'       'IT' 'VBELN_VF'  '' '' '' '' '' '' 0,
            '1' '3' 'EXDAT'       'IT' 'J_1IEXCDAT' '' '' 'Excise Doc Date' '' '' '' 9,
            '1' '4' 'EXNUM'        'IT' 'J_1IEXCNUM' '' '' 'Excise Doc No' '' '' '' 0,
            '1' '5' 'KUNAG'       'IT' 'KUNAG'    '' '' '' '' '' '' 0,
            '1' '6' 'KUNAG_NAME'  'IT' 'NAME1_GP' 'Cust.' 'Customer' 'Customer Name' setcustlink '' '' 22,
            '1' '7' 'KWERT'       'IT' 'KWERT'    '' '' '' '' '' 'X' 0,
            '1' '8' 'FRCVD'       'IT' 'ZRCVD'    '' '' '' '' 'C' '' 0,
            '1' '9' 'FRDAT'       'IT' 'ZFRDT'    '' '' '' '' '' '' 10,
            '1' '10' 'FRVAL'       'IT' 'ZFRVAL'   '' '' '' '' '' 'X' 0,
            '1' '11' 'CRUNT'       'IT' 'WAERS'    '' '' '' '' '' '' 0,
            '1' '12' 'FRMNR'       'IT' 'ZFRMNR'   '' '' '' '' '' '' 0,
*            '1' '11' 'QURTR'      'IT' ''   'Qrtr.' 'Qurtr' 'Quarter' 'X' '' '' 0,
            '1' '13' 'QURTR'      'IT' ''   'Qrtr.' 'Qurtr' 'Quarter' '' '' '' 0,
            '1' '14' 'BALNS'      'IT' 'JBBSALDO' '' '' '' '' '' 'X' 0.
  .

  PERFORM set_layout CHANGING v_lout.

  PERFORM set_sortabilty TABLES v_sort.
ENDFORM.                    "SET_READONLY_DISPLAY

FORM build_field_catalog  TABLES v_fcat   TYPE lvc_t_fcat
                          USING p_rowpos  TYPE sycurow
                                p_colpos  TYPE sycucol
                                p_fldnam  TYPE fieldname
                                p_tabnam  TYPE tabname
                                p_dtelmn  TYPE rollname
                                p_txt_s	  TYPE scrtext_s
                                p_txt_m   TYPE scrtext_m
                                p_txt_l   TYPE scrtext_l
                                p_htspot  TYPE lvc_hotspt
                                p_just    TYPE lvc_just
                                p_totl    TYPE lvc_dosum
                                p_otptln  TYPE lvc_outlen.

  DATA : wa_fcat TYPE lvc_s_fcat.

  CLEAR wa_fcat.
  wa_fcat-row_pos   = p_rowpos.
  wa_fcat-col_pos   = p_colpos.
  wa_fcat-fieldname = p_fldnam.
  wa_fcat-tabname   = p_tabnam.

  IF wa_fcat-fieldname = 'FKDAT' OR wa_fcat-fieldname = 'VBELN'.
    wa_fcat-tech = 'X'.
  ENDIF.

  IF p_txt_m IS INITIAL.
    wa_fcat-rollname   = p_dtelmn.
  ELSE.
    wa_fcat-scrtext_l = p_txt_l.
    wa_fcat-scrtext_m = p_txt_m.
    wa_fcat-scrtext_s = p_txt_s.
  ENDIF.

  wa_fcat-hotspot = p_htspot.
  IF wa_fcat-fieldname <> 'EXDAT'
    OR wa_fcat-fieldname <> 'RDOC'.
    wa_fcat-do_sum = p_totl.
  ENDIF.


  IF NOT p_otptln IS INITIAL.
    wa_fcat-outputlen = p_otptln.
  ENDIF.

  APPEND wa_fcat TO v_fcat.

ENDFORM.                    "BUILD_FIELD_CATALOG

*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->V_LOUT     text
*----------------------------------------------------------------------*
FORM set_layout CHANGING v_lout TYPE lvc_s_layo.
  CLEAR v_lout.
  v_lout-cwidth_opt = 'X'." OPTIMIZATION OF COL WIDTH
  v_lout-totals_bef = 'X'." dISPLAY SUB-TOTALS ON TOP
*  V_LOUT-NO_TOTARR = 'X'.
ENDFORM.                    "SET_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  SET_SORTABILTY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->V_SORT     text
*----------------------------------------------------------------------*
FORM set_sortabilty TABLES v_sort TYPE lvc_t_sort.
  DATA wa_sort TYPE lvc_s_sort.

*  CLEAR WA_SORT.
*    WA_SORT-SPOS = '1'.
*    WA_SORT-FIELDNAME = 'FKDAT'.
*    WA_SORT-UP = 'X'.
*    WA_SORT-DOWN = SPACE.
*    WA_SORT-SUBTOT = 'X'.
*  APPEND WA_SORT TO V_SORT.
*
*  CLEAR WA_SORT.
*    WA_SORT-SPOS = '2'.
*    WA_SORT-FIELDNAME = 'KUNAG_NAME'.
*    WA_SORT-UP = 'X'.
*    WA_SORT-DOWN = SPACE.
*    WA_SORT-SUBTOT = 'X'.
*  APPEND WA_SORT TO V_SORT.

ENDFORM.                    "SET_SORTABILTY

*&---------------------------------------------------------------------*
*&      Form  SET_EDITABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->V_FCAT     text
*      -->V_GRID     text
*----------------------------------------------------------------------*
FORM set_editable TABLES v_fcat TYPE lvc_t_fcat
                         v_it TYPE tb_result
                  USING v_grid TYPE REF TO lcl_gui_alv_grid.
  REFRESH v_fcat.
  FIELD-SYMBOLS <wa_fcat> STRUCTURE lvc_s_fcat DEFAULT %DUMMY%.

  CALL METHOD v_grid->get_frontend_fieldcatalog
    IMPORTING
      et_fieldcatalog = v_fcat[].

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    UNASSIGN <wa_fcat>.
    READ TABLE v_fcat ASSIGNING <wa_fcat> WITH KEY fieldname = 'FRCVD'.
    IF <wa_fcat> IS ASSIGNED.
      <wa_fcat>-checkbox = 'X'.
      <wa_fcat>-edit = 'X'.
    ENDIF.

    UNASSIGN <wa_fcat>.
    READ TABLE v_fcat ASSIGNING <wa_fcat> WITH KEY fieldname = 'FRDAT'.
    IF <wa_fcat> IS ASSIGNED.
      <wa_fcat>-edit = 'X'.
      <wa_fcat>-ref_field = 'FRDAT'.
      <wa_fcat>-ref_table = 'ZFRMC'.
    ENDIF.

    UNASSIGN <wa_fcat>.
    READ TABLE v_fcat ASSIGNING <wa_fcat> WITH KEY fieldname = 'FRVAL'.
    IF <wa_fcat> IS ASSIGNED.
      <wa_fcat>-edit = 'X'.
      "<WA_FCAT>-EDIT_MASK = '-----.--'.
      "<WA_FCAT>-CONVEXIT = 2.
      "<WA_FCAT>-INTTYPE = 'N'.
      <wa_fcat>-decimals = 2.
      <wa_fcat>-dd_outlen = 20.
      "<WA_FCAT>-NO_CONVEXT = 'X'.

    ENDIF.



    UNASSIGN <wa_fcat>.
    READ TABLE v_fcat ASSIGNING <wa_fcat> WITH KEY fieldname = 'FRMNR'.
    IF <wa_fcat> IS ASSIGNED.
      <wa_fcat>-edit = 'X'.
    ENDIF.
  ENDIF.

  " following block to set the ckboxes checked when the resp. field value = 'X'
  DATA : ls_stylerow TYPE lvc_s_styl,
         lt_styletab TYPE lvc_t_styl.

  LOOP AT v_it INTO wa.
    CLEAR ls_stylerow.
    REFRESH : lt_styletab, wa-cellstyles.

    IF NOT wa-frcvd IS INITIAL.
      ls_stylerow-fieldname = 'FRCVD'.
      ls_stylerow-style = cl_gui_alv_grid=>mc_style_disabled .
      APPEND ls_stylerow TO lt_styletab .
    ENDIF.
    IF NOT lt_styletab IS INITIAL.
      "INSERT LINES OF LT_STYLETAB INTO WA-CELLSTYLES .
      wa-cellstyles = lt_styletab[].
      MODIFY v_it FROM wa.
    ENDIF.

    CLEAR wa.
  ENDLOOP.
  "...........................................................................

ENDFORM.                    "SET_EDITABLE
*&---------------------------------------------------------------------*
*&      Form  UPDATE_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT  text
*----------------------------------------------------------------------*
FORM update_list TABLES v_it TYPE tb_result
                  USING v_grid TYPE REF TO lcl_gui_alv_grid.
  DATA : wa_frmc TYPE zfrmc,
         it_frmc TYPE TABLE OF zfrmc,

         fval    TYPE char1.

  CLEAR : wa_frmc, wa, fval.

  CALL METHOD v_grid->check_changed_data
    IMPORTING
      e_valid = fval.

  IF fval IS INITIAL.
    MESSAGE i025.
  ELSE.
    REFRESH it_frmc.
    LOOP AT v_it INTO wa.
      wa_frmc-vbeln = wa-vbeln.
      wa_frmc-frcvd = wa-frcvd.
      wa_frmc-frval = wa-frval.
      wa_frmc-frdat = wa-frdat.
      wa_frmc-crunt = wa-crunt.
      wa_frmc-frmnr = wa-frmnr.

      APPEND wa_frmc TO it_frmc.
      CLEAR : wa_frmc, wa.
    ENDLOOP.
    MODIFY zfrmc FROM TABLE it_frmc.
  ENDIF.

ENDFORM.                    " UPDATE_LIST

*&---------------------------------------------------------------------*
*&      Form  fetch_list
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->V_KUNAG    text
*      -->V_FKDAT    text
*      -->V_IT       text
*      -->OF         text
*      -->T_RESULT   text
*      -->V_VKORG    text
*      -->V_VTWEG    text
*      -->V_TAXK1    text
*----------------------------------------------------------------------*
FORM fetch_list TABLES v_it   TYPE tb_result
                      v_qurtr TYPE tt_qurtr
                      v_kunag TYPE t_kunag
                      v_fkdat TYPE t_fkdat
               USING  v_vkorg TYPE t_vkorg
                      v_vtweg TYPE t_vtweg
                      v_taxk1 TYPE taxk1
                      v_rcvd TYPE zrcvd.

  TYPES : BEGIN OF t_cndtn,
            str(50) TYPE c,
          END OF t_cndtn.

  DATA : cndtn_str TYPE string,
         cndtn     TYPE t_cndtn,
         cndtns    TYPE TABLE OF t_cndtn,

         wa_vbrk   TYPE t_vbrk,
         it_vbrk   TYPE TABLE OF t_vbrk,

         wa_kna1   TYPE t_kna1,
         it_kna1   TYPE TABLE OF t_kna1,

         wa_konv   TYPE t_konv,
         it_konv   TYPE TABLE OF t_konv,

         wa_frmc   TYPE t_zfrmc,
         it_frmc   TYPE TABLE OF t_zfrmc.

  REFRESH : it_vbrk, it_kna1, it_konv, v_it.
  CLEAR : wa_vbrk, wa_kna1, wa_konv, wa_frmc, wa.

* Derive the condition statment for fetching the billing documents' details from table VBRK
  CLEAR : cndtn_str, cndtn.
  REFRESH cndtns.

  IF NOT v_kunag IS INITIAL.
    CLEAR cndtn.
    cndtn-str = 'KUNAG IN V_KUNAG'.
    APPEND cndtn TO cndtns.
  ENDIF.

  "BREAK-POINT.

  IF NOT v_vkorg IS INITIAL.
    CLEAR cndtn.
    cndtn-str = 'VKORG = V_VKORG'.
    APPEND cndtn TO cndtns.
  ENDIF.

  IF NOT v_vtweg IS INITIAL.
    CLEAR cndtn.
    cndtn-str = 'VTWEG = V_VTWEG'.
    APPEND cndtn TO cndtns.
  ENDIF.

  IF NOT v_fkdat IS INITIAL.
    CLEAR cndtn.
    cndtn-str = 'FKDAT IN V_FKDAT'.
    APPEND cndtn TO cndtns.
  ENDIF.

  IF NOT v_taxk1 IS INITIAL.
    CLEAR cndtn.
    cndtn-str = 'TAXK1 = V_TAXK1'.
    APPEND cndtn TO cndtns.
  ENDIF.

  IF v_rcvd EQ 'X'.
    SELECT vbeln
           frcvd
           frdat
           frval
           crunt
           frmnr
      INTO TABLE it_frmc
      FROM zfrmc
      WHERE frcvd = v_rcvd.

    CLEAR cndtn.
    cndtn-str = 'VBELN = IT_FRMC-VBELN'.
    APPEND cndtn TO cndtns.
  ENDIF.

  IF NOT cndtns IS INITIAL.
    CONCATENATE LINES OF cndtns INTO cndtn_str SEPARATED BY ' AND '.
  ELSE.
    cndtn_str = ' 1 = 1 '. " to avoide errors
  ENDIF.
  CONDENSE cndtn_str.

  " Fetch billing documents for given critera
  IF v_rcvd EQ 'X'.
    IF NOT it_frmc IS INITIAL.
      SELECT
        vbeln
        knumv
        fkdat
*        RFBSK
        taxk1
        netwr
        kunag
        mwsbk
        fksto
        gjahr
      FROM vbrk
      INTO TABLE it_vbrk
      FOR ALL ENTRIES IN it_frmc
      WHERE (cndtn_str).

      LOOP AT it_vbrk INTO wa_vbrk.
        w_docyr-vbeln = wa_vbrk-vbeln.
        w_docyr-docyr =  wa_vbrk-fkdat+0(4).
        APPEND w_docyr TO i_docyr.
      ENDLOOP.

      IF it_vbrk[] IS NOT INITIAL.

        SELECT rdoc
               exnum
               exdat
               INTO TABLE i_j_1iexchdr
          FROM j_1iexchdr
          FOR ALL ENTRIES IN i_docyr

          WHERE rdoc = i_docyr-vbeln
          AND ( status = 'P'
                OR status = 'C'
                OR status = space )
                AND docyr = i_docyr-docyr.

      ENDIF.

    ELSE.
      MESSAGE i030 WITH 'For the given criteria no forms recieved yet.'.
      LEAVE TO CURRENT TRANSACTION.
    ENDIF.
  ELSE.
    SELECT
      vbeln
      knumv
      fkdat
*      RFBSK
      taxk1
      netwr
      kunag
      mwsbk
      fksto
      gjahr
      FROM vbrk
      INTO TABLE it_vbrk
      WHERE (cndtn_str).

    LOOP AT it_vbrk INTO wa_vbrk.
      w_docyr-vbeln = wa_vbrk-vbeln.
      w_docyr-docyr =  wa_vbrk-fkdat+0(4).
      APPEND w_docyr TO i_docyr.
    ENDLOOP.

    IF it_vbrk[] IS NOT INITIAL.
      SELECT rdoc exnum exdat
        INTO TABLE i_j_1iexchdr
        FROM j_1iexchdr
        FOR ALL ENTRIES IN i_docyr
        WHERE rdoc = i_docyr-vbeln
          AND ( status = 'P'
             OR status = 'C'
             OR status = space )
          AND docyr = i_docyr-docyr.
    ENDIF.

  ENDIF.
  IF sy-subrc EQ 0.
    " remove cancelled docs from the list
    DELETE it_vbrk WHERE fksto = 'X'.
    " Fetch Customer Details
    SELECT kunnr name1
      INTO TABLE it_kna1
      FROM kna1
      FOR ALL ENTRIES IN it_vbrk
      WHERE kunnr = it_vbrk-kunag.

    " Fetch Value Of Condition Type ZCST
    SELECT knumv kposn kwert waers
      INTO TABLE it_konv
    FROM PRCD_ELEMENTS  "FROM konv
      FOR ALL ENTRIES IN it_vbrk
      WHERE knumv = it_vbrk-knumv
        AND kschl = 'ZCST'.

    " Fetch the forms records
    IF v_rcvd NE 'X'.
      SELECT vbeln
           frcvd
           frdat
           frval
           crunt
           frmnr
      INTO TABLE it_frmc
      FROM zfrmc
      FOR ALL ENTRIES IN it_vbrk
      WHERE vbeln = it_vbrk-vbeln.
    ENDIF.

    LOOP AT it_vbrk INTO wa_vbrk.

      READ TABLE it_frmc INTO wa_frmc WITH KEY vbeln = wa_vbrk-vbeln.
      IF sy-subrc EQ 0.
        IF wa_frmc-frcvd NE v_rcvd.
          CLEAR : wa_vbrk, wa_kna1, wa_konv, wa_frmc, wa.
          CONTINUE.
        ENDIF.

        wa-frcvd = wa_frmc-frcvd.
        wa-frdat = wa_frmc-frdat.
*        IF NOT WA_FRMC-FRCVD IS INITIAL.
*          WA-FRCVD = 'Yes'.
*        ENDIF.
        wa-frmnr = wa_frmc-frmnr.
        wa-frval = wa_frmc-frval.
      ENDIF.

      wa-fkdat = wa_vbrk-fkdat.
      wa-vbeln = wa_vbrk-vbeln.
      wa-kunag = wa_vbrk-kunag.
      wa-taxk1 = wa_vbrk-taxk1.

      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbrk-kunag.
      IF sy-subrc = 0.
        wa-kunag_name = wa_kna1-name1.
      ENDIF.

      LOOP AT it_konv INTO wa_konv WHERE knumv = wa_vbrk-knumv.
        IF wa-crunt IS INITIAL.
          wa-crunt = wa_konv-waers.
        ENDIF.
*        WA-KWERT = WA-KWERT + WA_KONV-KWERT.
        CLEAR wa_konv.
      ENDLOOP.

      wa-kwert = wa_vbrk-netwr + wa_vbrk-mwsbk.

      " Determine Quarter
      PERFORM dtrmn_qurtr TABLES v_qurtr USING wa_vbrk-fkdat CHANGING wa-qrtr wa-qurtr.

      wa-balns = wa-kwert - wa-frval.

      READ TABLE i_docyr INTO w_docyr
      WITH KEY vbeln = wa_vbrk-vbeln BINARY SEARCH TRANSPORTING docyr.
*
*      select single rdoc exnum exdat into w_j_1iexchdr
*        from j_1iexchdr where rdoc = WA_VBRK-vbeln
*        and ( status = 'C' or status = 'P' or status = space )
*        and docyr = W_DOCYR-DOCYR.


      " CHANGE BY SAUMITRA MANI TIWARI"
      READ TABLE i_j_1iexchdr INTO w_j_1iexchdr WITH KEY
      rdoc = wa_vbrk-vbeln BINARY SEARCH TRANSPORTING
      exnum exdat.
      IF sy-subrc = 0.
        wa-exnum = w_j_1iexchdr-exnum.
        wa-exdat = w_j_1iexchdr-exdat.

        " POPULATE ONLY WHEN EXNUM <> ''.
        IF w_j_1iexchdr-exnum <> ''.
          APPEND wa TO v_it. "...USE V_IT
        ENDIF.

      ENDIF.

*
*      APPEND WA TO V_IT. "...USE V_IT

      CLEAR : wa_vbrk, wa_kna1, wa_konv, wa_frmc, wa, w_j_1iexchdr,
              w_docyr.

    ENDLOOP.
    REFRESH : it_vbrk, it_kna1, it_konv, it_frmc.

    "perform display_result tables v_it.
    IF v_it[] IS INITIAL.
      MESSAGE i030.
      LEAVE TO CURRENT TRANSACTION.
    ELSE.
      SORT v_it BY fkdat vbeln kunag_name.
    ENDIF.

  ELSE.
    MESSAGE i029.
    LEAVE TO CURRENT TRANSACTION.
  ENDIF.
ENDFORM.                    "FETCH_LIST


FORM set_alv USING cntrl TYPE scrfname
             CHANGING cntnr TYPE REF TO cl_gui_custom_container
                      grid TYPE REF TO lcl_gui_alv_grid.
  CREATE OBJECT cntnr
    EXPORTING
      container_name = cntrl
      lifetime       = cl_gui_custom_container=>lifetime_dynpro.

  CREATE OBJECT grid
    EXPORTING
      i_parent          = cntnr
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    "SET_ALV

FORM handle_hotspot_click TABLES v_it     TYPE tb_result
                                 v_sublist TYPE tb_result
                          USING v_row_id
                                v_column_id TYPE lvc_s_col
                                v_row_no TYPE lvc_s_roid.
  DATA : wa TYPE t_result.
  CLEAR wa.
  READ TABLE v_it INTO wa INDEX v_row_no-row_id.
  IF sy-subrc EQ 0.
    IF v_column_id-fieldname = 'KUNAG_NAME'.
      SUBMIT zsd_pendingforms WITH p_kunnr EQ wa-kunag
                              WITH p_frmtyp EQ wa-taxk1 AND RETURN.
    ELSE.
      PERFORM extract_sublist TABLES v_it v_sublist USING wa-qrtr.
    ENDIF.
  ENDIF.
ENDFORM.

FORM extract_sublist TABLES v_it TYPE tb_result
                            v_sublist TYPE tb_result
                      USING vq TYPE int1.
  DATA : wa TYPE t_result.
  CLEAR wa.
  REFRESH v_sublist.
  LOOP AT v_it INTO wa WHERE qrtr = vq.
    APPEND wa TO sublist.
  ENDLOOP.
  CALL SCREEN 1112 STARTING AT 30 50 ENDING AT 140 70.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_FLOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_flow .
  LEAVE TO LIST-PROCESSING AND RETURN TO SCREEN 0.
  LEAVE SCREEN.
ENDFORM.                    " INIT_FLOW


FORM set_qrtrs TABLES v_qurtr TYPE tt_qurtr.
  DATA w_qurtr TYPE t_qurtr.
  REFRESH v_qurtr.

  CLEAR w_qurtr.
  w_qurtr-id = 'I'.
  w_qurtr-b = '04'.
  w_qurtr-e = '06'.
  APPEND w_qurtr TO v_qurtr.

  CLEAR w_qurtr.
  w_qurtr-id = 'II'.
  w_qurtr-b = '07'.
  w_qurtr-e = '09'.
  APPEND w_qurtr TO v_qurtr.

  CLEAR w_qurtr.
  w_qurtr-id = 'III'.
  w_qurtr-b = '10'.
  w_qurtr-e = '12'.
  APPEND w_qurtr TO v_qurtr.

  CLEAR w_qurtr.
  w_qurtr-id = 'IV'.
  w_qurtr-b = '01'.
  w_qurtr-e = '03'.
  APPEND w_qurtr TO v_qurtr.
ENDFORM.

FORM dtrmn_qurtr TABLES v_qurtr TYPE tt_qurtr
                 USING v_dat TYPE sy-datum
                 CHANGING vq TYPE int1
                          str TYPE char9.

  DATA : wa_qurtr TYPE t_qurtr,
         m        TYPE int2,
         m1       TYPE char3,
         m2       TYPE char3.

  m = v_dat+4(2).

  LOOP AT v_qurtr INTO wa_qurtr.
    IF m BETWEEN wa_qurtr-b AND wa_qurtr-e.
      CLEAR str.
      PERFORM get_month USING wa_qurtr-b CHANGING m1.
      PERFORM get_month USING wa_qurtr-e CHANGING m2.
      CONCATENATE m1 m2 INTO str SEPARATED BY ' - '.
      vq = sy-tabix.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM get_month USING m TYPE int2
               CHANGING str TYPE char3.
  SELECT SINGLE ktx
    FROM t247
    INTO str
    WHERE mnr = m
        AND spras = sy-langu.
  IF sy-subrc NE 0.
    str = 'INV'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  INIT_1112  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_1112 OUTPUT.
  SET PF-STATUS ''.
  IF NOT sublist[] IS INITIAL.
    DATA op_tab TYPE REF TO cl_salv_table.
*    data V_STABLE type lvc_s_stbl.

    IF cntnr1 IS INITIAL.
      DATA: l_cust_container TYPE REF TO cl_gui_custom_container.

      CREATE OBJECT l_cust_container
        EXPORTING
          container_name = 'CUST_CTRL1'
          lifetime       = cl_gui_custom_container=>lifetime_dynpro.
*
      cntnr1 = l_cust_container.
      TRY.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container  = cntnr1
            IMPORTING
              r_salv_table = op_tab
            CHANGING
              t_table      = sublist[].
        CATCH cx_salv_msg .
      ENDTRY.
      op_tab->display( ).

    ELSE.
*
**      CLEAR V_STABLE.
**      V_STABLE-ROW = 'X'.
**      CALL METHOD OP_TAB->REFRESH
**        EXPORTING
**          S_STABLE     = V_STABLE
**          REFRESH_MODE = IF_SALV_C_REFRESH=>SOFT.
*
*
*try.
*      OP_TAB->set_data(
*        changing
*          t_table = SUBLIST[] ).
*    catch cx_salv_no_new_data_allowed.                  "#EC NO_HANDLER
*  endtry.
*
    ENDIF.
  ENDIF.
ENDMODULE.                 " INIT_1112  OUTPUT

FORM check_data_validity TABLES v_it TYPE tb_result
                                v_chngs TYPE lvc_t_modi
                         "USING  V_GOOD_CELLS TYPE LVC_T_MODI
                         CHANGING v_chk TYPE i.
  DATA : line TYPE lvc_s_modi,
         wa   TYPE t_result.

  v_chk = 0.

*  IF NOT V_GOOD_CELLS IS INITIAL.
*    REFRESH V_CHNGS.
*    V_CHNGS[] = V_GOOD_CELLS[].
*    REFRESH V_GOOD_CELLS.
*  ENDIF.

  LOOP AT v_chngs INTO line.
    READ TABLE v_it INTO wa INDEX line-row_id.
    IF sy-subrc EQ 0.
      IF line-fieldname EQ 'FRVAL' AND ( line-value < 0 OR line-value > wa-kwert ).
        v_chk = 1.
        MESSAGE e011 WITH 'Form value should lie between 0 & condition value'.
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " CHECK_DATA_VALIDITY
