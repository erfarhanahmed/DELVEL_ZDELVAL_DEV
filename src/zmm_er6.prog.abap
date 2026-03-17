*&---------------------------------------------------------------------*
*& Report ZMM_ER6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_er6.

TYPES : BEGIN OF t_mara,
          matnr TYPE matnr,     " Material Number
          mtart TYPE mtart,     " Material Type
          type  TYPE ztyp,      " TYPE
        END OF t_mara,

        BEGIN OF t_j_1imtchid,
          matnr	TYPE matnr,     "	Material Number
          "WERKS  TYPE WERKS_D, " Plant
          "
        END OF t_j_1imtchid,

        BEGIN OF t_mard,
          matnr	TYPE matnr,     "	Material Number
          labst	TYPE labst,     "	Valuated Unrestricted-Use Stock
        END OF t_mard,

*        BEGIN OF t_j_1ipart1,
*          matnr  TYPE matnr,       " Material Number
*          bwart  TYPE bwart,       " Movement Type (Inventory Management)
*          menge  TYPE j_1iexmenge, " Excise Invoice Quantity
*        END OF t_j_1ipart1,

        BEGIN OF t_mseg,
          mblnr	TYPE mblnr,       " Number of Material Document
          matnr	TYPE matnr,       "	Material Number
          bwart TYPE bwart,       "	Movement Type (Inventory Management)
          menge	TYPE menge_d,     "	Quantity
        END OF t_mseg,

        BEGIN OF t_mkpf,
          mblnr	TYPE mblnr,       "	Number of Material Document
        END OF t_mkpf,

        BEGIN OF t_j_1irg1,
          matnr	TYPE matnr,     "	Material Number
          menge	TYPE menge_d,   "	Quantity
          cpudt TYPE j_1icpudt,
        END OF t_j_1irg1,

        BEGIN OF t_mat,
          matnr	TYPE matnr,     "	Material Number
          type  TYPE ztyp,      " TYPE
          opbal	TYPE labst,     "	Quantity - Opening Balance
          recpt TYPE menge_d,   " Quantity - Receipt
          inuse TYPE menge_d,   " Quantity - Taken for use
          remvd TYPE menge_d,   " Quantity - Removed for Export / Home_use
          clblq TYPE menge_d,   " Quantity - Closing Balance

        END OF t_mat,

        BEGIN OF t_result,
          type  TYPE ztyp,      " type
          idscr TYPE char50,    " Description of principle inputs
          iqtym TYPE meins,     " Base Unit of Measure for Input materials' quantity
          opbal	TYPE labst,     "	Quantity - Opening Balance
          recpt TYPE menge_d,   " Quantity - Receipt
          inuse TYPE menge_d,   " Quantity - Taken for use
          remvd TYPE menge_d,   " Quantity - Removed for Export / Home_use
          clblq TYPE menge_d,   " Quantity - Closing Balance

          odscr TYPE char50,    " Description of output(finished goods) out of inputs
          fqtym TYPE meins,     " Base Unit of Measure for Finished Goods' Quantity
          fgqty TYPE menge_d,   " Finished Goods' Quantity
        END OF t_result,

        tt_mara       TYPE TABLE OF t_mara,
        tt_j_1imtchid TYPE TABLE OF t_j_1imtchid,
        tt_mard       TYPE TABLE OF t_mard,
        " tt_j_1ipart1  TYPE TABLE OF t_mseg       , "t_j_1ipart1  ,
        tt_mseg       TYPE TABLE OF t_mseg,
        tt_mkpf       TYPE TABLE OF t_mkpf,
        tt_j_1irg1    TYPE TABLE OF t_j_1irg1,
        tt_mats       TYPE TABLE OF t_mat,
        tt_result     TYPE TABLE OF t_result.

DATA : wa_mara          TYPE t_mara,
       "wa_j_1imtchid    TYPE t_j_1imtchid ,
       wa_mard          TYPE t_mard,
       wa_j_1ipart1     TYPE t_mseg       , "t_j_1ipart1  ,
       "TMP_WA_J_1IPART1 TYPE t_J_1IPART1  ,
       wa_mseg          TYPE t_mseg,
       wa_mkpf          TYPE t_mkpf,
       wa_j_1irg1       TYPE t_j_1irg1,
       wa_mat           TYPE t_mat,
       wa_result        TYPE t_result,

       it_mara          TYPE tt_mara,
       it_j_1imtchid    TYPE tt_j_1imtchid,
       it_mard          TYPE tt_mard,
       it_mardh         TYPE tt_mard,
       tmp_it_j_1ipart1 TYPE tt_mseg       , " tt_j_1ipart1  ,
       it_j_1ipart1     TYPE tt_mseg       , " tt_j_1ipart1  ,
       tmp_it_mseg      TYPE tt_mseg,
       it_mseg          TYPE tt_mseg,
       it_mkpf          TYPE tt_mkpf,
       it_j_1irg1       TYPE tt_j_1irg1,
       it_mats          TYPE tt_mats,
       it_result        TYPE tt_result.

DATA : v_str            TYPE string,
       v_str1           TYPE string,
       f_mnth           TYPE am_monat,
       f_mnth_year      TYPE anjhr,
       prev_f_mnth      TYPE am_monat,
       prev_f_mnth_year TYPE anjhr,

       lc_msg           TYPE REF TO cx_salv_msg,
       alv_obj          TYPE REF TO cl_salv_table.

CONSTANTS : true  TYPE c VALUE 'X',
            false TYPE c VALUE ' '.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-000.
PARAMETERS : p_mnth TYPE am_monat AS LISTBOX VISIBLE LENGTH 15 .
PARAMETERS : p_year TYPE vjahr.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN.
  CLEAR v_str.
  CONCATENATE p_year p_mnth INTO v_str.
  IF v_str > sy-datum+0(6).
    "MESSAGE e011.
    MESSAGE TEXT-012 TYPE 'I'.
    EXIT.
  ELSE.
    SELECT SINGLE lfgja
      FROM mardh
      INTO p_year
      WHERE lfgja = p_year.
    IF sy-subrc <> 0.
      SELECT SINGLE lfgja
      FROM mard
      INTO p_year
      WHERE lfgja = p_year.
      IF sy-subrc <> 0.
        " MESSAGE e011.
        MESSAGE TEXT-012 TYPE 'I'.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

START-OF-SELECTION.
  SELECT DISTINCT matnr
    FROM j_1imtchid
    INTO TABLE it_j_1imtchid
    WHERE j_1icapind <> 'F'.

  IF sy-subrc = 0.

    SELECT matnr
           mtart
           type
      FROM mara
      INTO TABLE it_mara
      FOR ALL ENTRIES IN it_j_1imtchid
      WHERE matnr = it_j_1imtchid-matnr AND type IN ('BAA', 'BOA', 'BOV').

    IF sy-subrc = 0.
      CLEAR : f_mnth, f_mnth_year, prev_f_mnth, prev_f_mnth_year, v_str1.
*      CONCATENATE p_year p_mnth INTO v_str.
      CONCATENATE v_str '%' INTO v_str1.
      " Column : Opening Balance
      IF p_mnth BETWEEN '01' AND '03'. "If Selected Month Is January
        f_mnth = p_mnth + 9.
        f_mnth_year = p_year - 1.

        prev_f_mnth = p_mnth + 8.
        prev_f_mnth_year = f_mnth_year.
      ELSE.
        f_mnth = p_mnth - 3.
        f_mnth_year = p_year.

        prev_f_mnth = p_mnth - 4.
        IF p_mnth = '04'.
          prev_f_mnth_year = p_year - 1.
        ELSE.
          prev_f_mnth_year = p_year.
        ENDIF.

      ENDIF.

      SELECT DISTINCT matnr
                      labst
        FROM mardh
        INTO TABLE it_mardh
        FOR ALL ENTRIES IN it_mara
        WHERE matnr = it_mara-matnr
          AND lfgja = prev_f_mnth_year
          AND lfmon = prev_f_mnth.

      " Column : Receipt
      SELECT mblnr  " added this column just to satisfy the structural requirements
             matnr
             bwart
             menge
        FROM j_1ipart1
        INTO TABLE tmp_it_j_1ipart1
        FOR ALL ENTRIES IN it_mara
        WHERE matnr = it_mara-matnr
          AND bwart IN ('101', '102' , '122', '123')
          AND cpudt LIKE v_str1.
      IF sy-subrc = 0.
        SORT tmp_it_j_1ipart1 BY matnr bwart.
        PERFORM sum_qty_for_mvtyp TABLES tmp_it_j_1ipart1 it_j_1ipart1.
        SORT it_j_1ipart1 BY matnr bwart.
        " read matnr and respective 101 &102 values to canculate the remaining balance.
      ENDIF.
      BREAK mbhosale.
      " Column : Taken for use
      SELECT  mblnr
              matnr
              bwart
              menge
        FROM mseg
        INTO TABLE tmp_it_mseg
        FOR ALL ENTRIES IN it_mara
        WHERE matnr = it_mara-matnr
          AND bwart IN ('261', '201', '262', '202').
      IF sy-subrc = 0.
        SELECT mblnr
          FROM mkpf
          INTO TABLE it_mkpf
          FOR ALL ENTRIES IN tmp_it_mseg
          WHERE mblnr = tmp_it_mseg-mblnr
            AND budat LIKE v_str1.
        IF sy-subrc = 0.
          SORT : tmp_it_mseg, it_mkpf BY mblnr.
          LOOP AT tmp_it_mseg INTO wa_mseg.
            READ TABLE it_mkpf INTO wa_mkpf WITH KEY mblnr = wa_mseg-mblnr.
            IF sy-subrc <> 0.
              DELETE tmp_it_mseg WHERE mblnr = wa_mseg-mblnr.
            ENDIF.
          ENDLOOP.
        ELSE.
          REFRESH tmp_it_mseg.
        ENDIF.
      ENDIF.
      IF NOT tmp_it_mseg[] IS INITIAL.
        SORT tmp_it_mseg BY matnr bwart.
        PERFORM sum_qty_for_mvtyp TABLES tmp_it_mseg it_mseg.
        SORT it_mseg BY matnr bwart.
      ENDIF.
      " read matnr and respective 261,201 minus 262,202 values to canculate Taken_for_use Qty.

      " Closing Balance
      IF v_str = sy-datum+0(6). " if input month is current month
        SELECT DISTINCT matnr
                        labst
          FROM mard
          INTO TABLE it_mard
          FOR ALL ENTRIES IN it_mara
          WHERE matnr = it_mara-matnr
            AND lfgja = f_mnth_year " p_year  " Year/ Month values for QRY should refer to the financial calender
            AND lfmon = f_mnth.     " p_mnth. "
      ELSE.
        SELECT DISTINCT matnr
                        labst
          FROM mardh
          INTO TABLE it_mard
          FOR ALL ENTRIES IN it_mara
          WHERE matnr = it_mara-matnr
            AND lfgja = f_mnth_year
            AND lfmon = f_mnth.
      ENDIF.

      CLEAR : wa_mat, wa_mara, wa_mard, wa_j_1ipart1, wa_mseg, wa_mard.
      LOOP AT it_mara INTO wa_mara.

        " Material Number
        wa_mat-matnr = wa_mara-matnr.

        " Material Type
        wa_mat-type = wa_mara-type.

        " Opening Balance
        READ TABLE it_mardh INTO wa_mard WITH KEY matnr = wa_mara-matnr.
        IF sy-subrc = 0.
          wa_mat-opbal = wa_mat-opbal + wa_mard-labst.
        ENDIF.

        " Receipt
        LOOP AT it_j_1ipart1 INTO wa_j_1ipart1 WHERE matnr =  wa_mara-matnr AND bwart = '101'.
          wa_mat-recpt = wa_mat-recpt + wa_j_1ipart1-menge.
          CLEAR wa_j_1ipart1.
        ENDLOOP.
        LOOP AT it_j_1ipart1 INTO wa_j_1ipart1 WHERE matnr =  wa_mara-matnr AND bwart = '102'.
          wa_mat-recpt = wa_mat-recpt - wa_j_1ipart1-menge.
          CLEAR wa_j_1ipart1.
        ENDLOOP.

        " Taken For Use
        LOOP AT it_mseg INTO wa_mseg WHERE matnr =  wa_mara-matnr
                                       AND ( bwart = '201' OR bwart = '261' ).
          wa_mat-inuse = wa_mat-inuse + wa_mseg-menge.
          CLEAR wa_mseg.
        ENDLOOP.
        LOOP AT it_mseg INTO wa_mseg WHERE matnr =  wa_mara-matnr
                                       AND ( bwart = '202' OR bwart = '262' ).
          wa_mat-inuse = wa_mat-inuse - wa_mseg-menge.
          CLEAR wa_mseg.
        ENDLOOP.

        " Removed for Export / Home_use
        CLEAR wa_j_1ipart1.
        LOOP AT it_j_1ipart1 INTO wa_j_1ipart1 WHERE matnr =  wa_mara-matnr AND bwart = '122'.
          wa_mat-remvd = wa_mat-remvd + wa_j_1ipart1-menge.
          CLEAR wa_j_1ipart1.
        ENDLOOP.
        LOOP AT it_j_1ipart1 INTO wa_j_1ipart1 WHERE matnr =  wa_mara-matnr AND bwart = '123'.
          wa_mat-remvd = wa_mat-remvd - wa_j_1ipart1-menge.
          CLEAR wa_j_1ipart1.
        ENDLOOP.

        " Closing Balance
        LOOP AT it_mard INTO wa_mard WHERE matnr =  wa_mara-matnr.
          wa_mat-clblq = wa_mat-clblq + wa_mard-labst.
          CLEAR wa_mard.
        ENDLOOP.


        IF NOT wa_mat IS INITIAL.
          APPEND wa_mat TO it_mats.
        ENDIF.

        CLEAR : wa_mat, wa_mara, wa_mard, wa_j_1ipart1, wa_mseg, wa_mard.
      ENDLOOP.

      IF NOT it_mats[] IS INITIAL.
*        PERFORM generate_alv USING lc_msg it_mats[] CHANGING alv_obj.
*        PERFORM set_header USING p_mnth p_year alv_obj.
*        alv_obj->display( ).
        SORT it_mats BY type.
        CLEAR : wa_mat, wa_result.
        LOOP AT it_mats INTO wa_mat.
          IF NOT wa_result IS INITIAL AND wa_result-type <> wa_mat-type.
            PERFORM set_descriptions USING wa_result-type CHANGING wa_result-idscr wa_result-odscr.
            APPEND wa_result TO it_result.
            CLEAR wa_result.
          ENDIF.
          IF wa_result IS INITIAL.
            wa_result-type  = wa_mat-type.
            wa_result-fqtym = 'EA'.
            wa_result-iqtym = 'EA'.
          ENDIF.
          wa_result-opbal = wa_result-opbal + wa_mat-opbal.
          wa_result-recpt = wa_result-recpt + wa_mat-recpt.
          wa_result-inuse = wa_result-inuse + wa_mat-inuse.
          wa_result-remvd = wa_result-remvd + wa_mat-remvd.
          wa_result-clblq = wa_result-clblq + wa_mat-clblq.
          CLEAR : wa_mat.
        ENDLOOP.
        IF NOT wa_result IS INITIAL.
          PERFORM set_descriptions USING wa_result-type CHANGING wa_result-idscr wa_result-odscr.
          APPEND wa_result TO it_result.
          CLEAR wa_result.
        ENDIF.

        "Fetch Finished Goods info
        PERFORM get_output_maufactured TABLES it_result[].

        PERFORM generate_alv USING it_result[] CHANGING alv_obj lc_msg.
        PERFORM set_header USING p_mnth p_year alv_obj.
        alv_obj->display( ).
      ENDIF.
    ELSE.
*    MESSAGE i030.
      MESSAGE TEXT-011 TYPE 'I'.
      EXIT.
    ENDIF.
  ELSE.
*    MESSAGE i030.
    MESSAGE TEXT-011 TYPE 'I'.
    EXIT.
  ENDIF.



  " FOR info about : Finished Goods
*&---------------------------------------------------------------------*
*&      Form  get_output_maufactured
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IT_RESULT  text
*----------------------------------------------------------------------*
FORM get_output_maufactured TABLES it_result TYPE tt_result.
  DATA : wa_j_1irg1 TYPE t_j_1irg1,
         it_mara    TYPE tt_mara,
         it_j_1irg1 TYPE tt_j_1irg1.

  REFRESH : it_j_1imtchid, it_mara, it_j_1irg1.
  SELECT DISTINCT matnr
    FROM j_1imtchid
    INTO TABLE it_j_1imtchid
    WHERE j_1icapind = 'F'.
  IF sy-subrc = 0.
    SELECT matnr
           mtart
           type
      FROM mara
      INTO TABLE it_mara
      FOR ALL ENTRIES IN it_j_1imtchid
      WHERE matnr = it_j_1imtchid-matnr AND type IN ('BAA', 'BOA', 'BOV').
    IF sy-subrc = 0.
      SELECT matnr
             menge
            cpudt
        FROM j_1irg1
        INTO TABLE it_j_1irg1
        FOR ALL ENTRIES IN it_mara
        WHERE syear = p_year
          AND matnr = it_mara-matnr
          AND rcptissrsn IN ('RMA', 'ROP')
          AND cpudt LIKE v_str1.
      IF sy-subrc = 0.
        SORT it_mara BY type.
        CLEAR : wa_mara, wa_j_1irg1.
        LOOP AT it_mara INTO wa_mara.
*            READ TABLE it_j_1irg1 INTO wa_j_1irg1 WITH KEY matnr = wa_mara-matnr.
*            IF sy-subrc = 0.
*              IF NOT wa_result IS INITIAL AND wa_result-type <> wa_mara-type.
*                modify it_result FROM wa_result TRANSPORTING fgqty WHERE type = wa_result-type.
*                CLEAR wa_result.
*              ENDIF.
*              IF wa_result is INITIAL.
*                wa_result-type = wa_mara-type.
*              ENDIF.
*              wa_result-fgqty = wa_result-fgqty + wa_j_1irg1-menge.
*            ENDIF.

          IF NOT wa_result IS INITIAL AND wa_result-type <> wa_mara-type.
            MODIFY it_result FROM wa_result TRANSPORTING fgqty WHERE type = wa_result-type.
            CLEAR wa_result.
          ENDIF.
          IF wa_result IS INITIAL.
            wa_result-type = wa_mara-type.
          ENDIF.
          LOOP AT it_j_1irg1 INTO wa_j_1irg1 WHERE matnr = wa_mara-matnr.
            wa_result-fgqty = wa_result-fgqty + wa_j_1irg1-menge.
          ENDLOOP.
          CLEAR : wa_mara, wa_j_1irg1.
        ENDLOOP.
        IF NOT wa_result IS INITIAL.
          MODIFY it_result FROM wa_result TRANSPORTING fgqty WHERE type = wa_result-type.
          CLEAR wa_result.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "get_output_maufactured

*&---------------------------------------------------------------------*
*&      Form  sum_qty_for_mvtyp
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->TMP_IT     text
*      -->IT         text
*----------------------------------------------------------------------*
FORM sum_qty_for_mvtyp TABLES tmp_it TYPE tt_mseg
                              it     TYPE tt_mseg.
  DATA : tmp_wa TYPE t_mseg,
         wa     TYPE t_mseg.

  REFRESH it.

  CLEAR : tmp_wa, wa.
  LOOP AT tmp_it INTO tmp_wa.
    IF NOT wa IS INITIAL AND ( wa-matnr <> tmp_wa-matnr OR wa-bwart <> tmp_wa-bwart ).
      APPEND wa TO it.
      CLEAR wa.
    ENDIF.
    IF wa IS INITIAL.
      wa-matnr = tmp_wa-matnr.
      wa-bwart = tmp_wa-bwart.
    ENDIF.
    wa-menge = wa-menge + tmp_wa-menge.
    CLEAR tmp_wa.
  ENDLOOP.
  IF NOT wa IS INITIAL.
    APPEND wa TO it.
    CLEAR wa.
  ENDIF.
ENDFORM.                    "SUM_QTY_FOR_MVTYP

*&---------------------------------------------------------------------*
*&      Form  GENERATE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LC_MSG     text
*      -->P_RSLT     text
*      -->ALV_OBJ    text
*----------------------------------------------------------------------*
FORM generate_alv USING   p_rslt TYPE tt_result
                  CHANGING alv_obj TYPE REF TO cl_salv_table
                           lc_msg TYPE REF TO cx_salv_msg .

  DATA : o_layout  TYPE REF TO cl_salv_layout,
         key       TYPE salv_s_layout_key,
         alv_fncts TYPE REF TO cl_salv_functions_list.

  IF NOT p_rslt[] IS INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = alv_obj
          CHANGING
            t_table      = p_rslt[].
      CATCH cx_salv_msg INTO lc_msg .
    ENDTRY.

    " Enable Save Layout Option
    o_layout = alv_obj->get_layout( ).
    key-report = sy-repid.
    o_layout->set_key( key ).
    CALL METHOD o_layout->set_save_restriction
      EXPORTING
        value = if_salv_c_layout=>restrict_none.

    " Default functions
    alv_fncts = alv_obj->get_functions( ).
    alv_fncts->set_all( abap_true ).
  ENDIF.
ENDFORM.                    "GENERATE_ALV

*&---------------------------------------------------------------------*
*&      Form  SET_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_WERKS    text
*      -->ALV_OBJ    text
*----------------------------------------------------------------------*
FORM set_header USING p_mnth TYPE am_monat
                      p_year TYPE vjahr
                      alv_obj TYPE REF TO cl_salv_table.

  DATA : col       TYPE REF TO cl_salv_column_table,
         cols      TYPE REF TO cl_salv_columns_table,
         lyot_txt  TYPE REF TO cl_salv_form_layout_grid,
         lyot_lbl  TYPE REF TO cl_salv_form_label,
         lyot_flow TYPE REF TO cl_salv_form_layout_flow,
         line      TYPE string,
         var_i     TYPE i.

  CREATE OBJECT lyot_txt.

  " HEADER TEXT
  lyot_lbl = lyot_txt->create_label( row = 1 column = 1 text = 'Selection Criteria : ').
  var_i = 1.

  " Name of the manufacturer
  CLEAR : lyot_flow, line.
  var_i = var_i + 1.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = 'Name of the manufacturer : ' ).
  SELECT SINGLE name1
    FROM t001w
    INTO line
    WHERE werks = 'PL01'.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 2 ).
  lyot_flow->create_text( text = line ).

  " Pan based registration number
  CLEAR : lyot_flow, line.
  var_i = var_i + 1.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = 'Pan based registration number : ' ).
  SELECT SINGLE j_1iexrn
    FROM j_1imocomp
    INTO line
    WHERE werks = 'PL01'.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 2 ).
  lyot_flow->create_text( text = line ).

  " Input Month
  var_i = var_i + 1.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = 'Month : ' ).

  CLEAR line.
  SELECT SINGLE ltx
     FROM t247
     INTO line
     WHERE mnr = p_mnth
         AND spras = sy-langu.
  CONCATENATE line p_year INTO line SEPARATED BY space.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 2 ).
  lyot_flow->create_text( text = line ).

  var_i = var_i + 1.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = 'Date of Report Generation : ' ).

  lyot_flow = lyot_txt->create_flow( row = var_i column = 2 ).
  lyot_flow->create_text( text = sy-datum ).
  var_i = var_i + 1.

  alv_obj->set_top_of_list( lyot_txt ).

  cols = alv_obj->get_columns( ).
  cols->set_optimize( true ).

  CLEAR : col.
  col ?= cols->get_column( 'IDSCR' ).
  col->set_short_text( 'I/P Descr' ). "( text-001 ).
  col->set_medium_text( 'Input Descr' ). "( text-001 ).
  col->set_long_text( 'Description Of Principle Inputs' ). "( text-001 ).

  CLEAR : col.
  col ?= cols->get_column( 'ODSCR' ).
  col->set_short_text( 'Fin. Gds' ). "( text-001 ).
  col->set_medium_text( 'Finished Goods' ). "( text-001 ).
  col->set_long_text( 'Finished Goods Manufactured' ). "( text-001 ).

  CLEAR : col.
  col ?= cols->get_column( 'IQTYM' ).
  col->set_short_text( 'Qty Code' ). "( text-001 ).
  col->set_medium_text( 'Quantity Code' ). "( text-001 ).
  col->set_long_text( 'Quantity Code' ). "( text-001 ).

  CLEAR : col.
  col ?= cols->get_column( 'FQTYM' ).
  col->set_short_text( 'Qty Code' ). "( text-001 ).
  col->set_medium_text( 'FG Quantity Code' ). "( text-001 ).
  col->set_long_text( 'Finished Goods Quantity Codes' ). "( text-001 ).

  CLEAR : col.
  col ?= cols->get_column( 'OPBAL' ).
  col->set_short_text( 'Opn Bal.' ). "( text-001 ).
  col->set_medium_text( 'Opn Balance' ). "( text-001 ).
  col->set_long_text( 'Opening Balance' ). "( text-001 ).

  CLEAR : col.
  col ?= cols->get_column( 'RECPT' ).
  col->set_short_text( 'Receipt' ). "( text-001 ).
  col->set_medium_text( 'Receipt' ). "( text-001 ).
  col->set_long_text( 'Receipt' ). "( text-001 ).

  CLEAR : col.
  col ?= cols->get_column( 'INUSE' ).
  col->set_short_text( 'In Use' ). "( text-002 ).
  col->set_medium_text( 'In Use Stck' ). "( text-002 ).
  col->set_long_text( 'In Use Stock' ). "( text-002 ).

  CLEAR : col.
  col ?= cols->get_column( 'REMVD' ).
  col->set_short_text( 'Rmvd' ). "( text-003 ).
  col->set_medium_text( 'Removed' ). "( text-003 ).
  col->set_long_text( 'Removed' ). "( text-003 ).

  CLEAR : col.
  col ?= cols->get_column( 'CLBLQ' ).
  col->set_short_text( 'Cls Bal.' ).  "( text-004 ).
  col->set_medium_text( 'Clsng Balance' ).  "( text-004 ).
  col->set_long_text( 'Closing Balance' ).  "( text-004 ).

ENDFORM.                    "seT_HEADER

*&---------------------------------------------------------------------*
*&      Form  set_descriptions
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->V_TYPE     text
*      -->V_IDSCR    text
*      -->V_ODSCR    text
*----------------------------------------------------------------------*
FORM set_descriptions USING    v_type  TYPE ztyp
                      CHANGING v_idscr TYPE char50
                               v_odscr TYPE char50.
  CASE v_type.
    WHEN 'BOA'.
      v_idscr = 'Body of Actuators'(005).
      v_odscr = 'Actuators'(006).
    WHEN 'BOV'.
      v_idscr = 'Body of Valve'(007).
      v_odscr = 'Industrial Valves'(008).
    WHEN 'BAA'.
      v_idscr = 'Body of Automation'(009).
      v_odscr = 'Automation'(010).
  ENDCASE.

ENDFORM.                    "set_descriptions
