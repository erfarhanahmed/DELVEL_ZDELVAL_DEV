*&---------------------------------------------------------------------*
*& Report  ZSD_INSURANCE_REGISTER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zsd_insurance_register NO STANDARD PAGE HEADING MESSAGE-ID zdel.

TYPES : BEGIN OF t_vbak,
          vbeln	TYPE vbeln_va,  "	Billing Document
          erdat TYPE erdat,     " Date on Which Record Was Created
          knumv	TYPE knumv,     "	Number of the document condition
          kunnr TYPE kunag,     " Sold-to party
          waerk TYPE waerk,
        END OF t_vbak,

        BEGIN OF t_vbfa,
          vbelv   TYPE vbeln_von,
          vbeln   TYPE vbeln_nach,
          vbtyp_n TYPE char4,
        END OF t_vbfa,

        BEGIN OF t_vbrk,
          vbeln TYPE vbeln_vf,
          vbtyp TYPE vbtyp,
          fkdat TYPE fkdat,
          knumv TYPE knumv,
          netwr TYPE netwr,
          kurrf TYPE kurrf,
          mwsbk TYPE mwsbp,
        END OF t_vbrk,

        BEGIN OF t_kna1,
          kunnr TYPE kunnr,    " Customer Number
          name1 TYPE name1_gp, " Name
          name2 TYPE name2_gp,                      " Name 2
          ort01 TYPE ort01_gp, " City
          pstlz TYPE pstlz,    " Postal Code
          stras TYPE stras_gp, " House number and street
        END OF t_kna1,

        BEGIN OF t_konv,
          knumv	TYPE knumv,   " Number of the document condition
          kposn	TYPE kposn,	    " Condition item number
          kschl	TYPE kscha,	    " Condition type
          kbetr	TYPE kbetr,	    " Rate (condition amount or percentage)
          waers TYPE waers,   " Currency Key
          kwert	TYPE kwert,	    " Condition value
        END OF t_konv,

        BEGIN OF t_result,
*          KUNNR         TYPE KUNNR,     " Payer
          name1    TYPE name1,     " Name
          address  TYPE char120,   " Address
          vbeln    TYPE vbeln_va,  " Billing Document
          vbeln_vf TYPE vbeln_vf,  " Invoice
          exnum    TYPE j_1iexcnum, " TAX Invoice
          fkdat    TYPE fkdat,     " Billing date for billing index and printout
          netwr    TYPE netwr,     " Net Value in Document Currency
          kbetr    TYPE kbetr,       " Rate (condition amount or percentage)
*          KWERT          TYPE KWERT,     " Rate (condition amount or percentage)
        END OF t_result.

DATA : wa_vbak       TYPE          t_vbak,
       wa_vbfa       TYPE          t_vbfa,
       wa_vbrk       TYPE          t_vbrk,
       wa_kna1       TYPE          t_kna1,
       wa_konv       TYPE          t_konv,
       wa_result     TYPE          t_result,
       it_vbak       TYPE TABLE OF t_vbak,
       it_vbfa       TYPE TABLE OF t_vbfa,
       it_vbrk       TYPE TABLE OF t_vbrk,
       it_kna1       TYPE TABLE OF t_kna1,
       it_konv       TYPE TABLE OF t_konv,
       it_result     TYPE TABLE OF t_result,
       lc_msg        TYPE REF TO   cx_salv_msg,
       alv_obj       TYPE REF TO   cl_salv_table,
       lyot_txt      TYPE REF TO   cl_salv_form_layout_grid,
       lyot_lbl      TYPE REF TO   cl_salv_form_label,
       lyot_flow     TYPE REF TO   cl_salv_form_layout_flow,
       lyot_func     TYPE REF TO   cl_salv_functions,
       lyot_disp     TYPE REF TO   cl_salv_display_settings,
       lyot_columns  TYPE REF TO   cl_salv_columns_table,
       lyot_column   TYPE REF TO   cl_salv_column_table,
*       lR_COLUMN  TYPE REF TO CL_SALV_COLUMN.
       lyot_add      TYPE REF TO   cl_salv_aggregations,
       lyot_lout     TYPE REF TO   cl_salv_layout,
       lyot_key      TYPE          salv_s_layout_key,
       txt           TYPE          string,
       v_datelow     TYPE          char10,
       v_datehigh    TYPE          char10,
       var_i         TYPE          i VALUE '1',
       address       TYPE          char70,
       wa_j_1iexchdr TYPE          j_1iexchdr.


INITIALIZATION.
  CLEAR   : wa_konv, wa_result.
  REFRESH : it_konv, it_result.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  SELECT-OPTIONS : so_date FOR wa_vbak-erdat.
  SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  SELECT vbeln
         erdat
         waerk
         knumv
         kunnr
  FROM   vbak
  INTO CORRESPONDING FIELDS OF TABLE it_vbak
  WHERE erdat IN so_date.

  SORT it_vbak ASCENDING.

  IF sy-subrc = 0.

    SELECT vbelv
           vbeln
           vbtyp_n
      FROM vbfa
      INTO CORRESPONDING FIELDS OF TABLE it_vbfa
      FOR ALL ENTRIES IN it_vbak
      WHERE vbelv = it_vbak-vbeln
      AND   vbtyp_n = 'M'.

    IF sy-subrc = 0.

      SELECT vbeln
             vbtyp
             fkdat
             knumv
             netwr
             kurrf
             mwsbk
        FROM vbrk
        INTO CORRESPONDING FIELDS OF TABLE it_vbrk
        FOR ALL ENTRIES IN it_vbfa
        WHERE vbeln = it_vbfa-vbeln
        AND   vbtyp = it_vbfa-vbtyp_n
        AND   fksto <> 'X'.

    ENDIF.

    SELECT
          kunnr
          name1
          name2
          ort01
          pstlz
          stras
     FROM kna1
     INTO CORRESPONDING FIELDS OF TABLE it_kna1
     FOR ALL ENTRIES IN it_vbak
     WHERE kunnr = it_vbak-kunnr.

    SELECT knumv
           kposn
           kschl
           kbetr
           waers
           kwert
      FROM prcd_elements
      INTO CORRESPONDING FIELDS OF TABLE it_konv
*      FOR ALL ENTRIES IN IT_VBAK
      FOR ALL ENTRIES IN it_vbrk
      WHERE knumv = it_vbrk-knumv
      AND   kschl = text-001
      AND   kbetr <> 0.
    SORT it_konv ASCENDING.
  ENDIF.

  DATA : lv_in1 TYPE kbetr VALUE 0.


  LOOP AT it_konv INTO wa_konv.

    lv_in1 = wa_konv-kbetr + lv_in1.
    AT END OF knumv.

      CLEAR wa_vbrk.
      READ TABLE it_vbrk INTO wa_vbrk WITH KEY knumv = wa_konv-knumv.

      SELECT SINGLE * FROM j_1iexchdr INTO wa_j_1iexchdr WHERE rdoc = wa_vbrk-vbeln
                                                           AND ( status = 'C' OR status = 'P'
                                                                 OR status = space ).

      wa_result-exnum = wa_j_1iexchdr-exnum.

      CLEAR: wa_vbfa, wa_vbak, wa_kna1.

      READ TABLE it_vbfa INTO wa_vbfa WITH KEY vbeln = wa_vbrk-vbeln
                                                vbtyp_n = 'M' .

      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbfa-vbelv.

      wa_result-kbetr	= lv_in1.
      wa_result-vbeln	= wa_vbfa-vbelv.
      wa_result-vbeln_vf = wa_vbrk-vbeln.
      wa_result-fkdat    = wa_vbrk-fkdat.
      IF wa_vbak-waerk = 'INR'.
        wa_result-netwr    = wa_vbrk-netwr + wa_vbrk-mwsbk.
      ELSE.
        wa_result-netwr    = ( wa_vbrk-netwr * wa_vbrk-kurrf )
                           + ( wa_vbrk-mwsbk * wa_vbrk-kurrf )  .
      ENDIF.

      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.
      CONCATENATE wa_kna1-name2 wa_kna1-stras wa_kna1-ort01 wa_kna1-pstlz INTO address SEPARATED BY ', '.

      IF sy-subrc = 0.
        wa_result-name1   = wa_kna1-name1.
        wa_result-address = address.
      ENDIF.

      IF wa_result-netwr <> 0.
        APPEND wa_result TO it_result.
        CLEAR: lv_in1.
      ENDIF.


    ENDAT.


*  ENDAT.

*  CLEAR : wa_vbak, wa_konv ,wa_kna1,wa_result, wa_vbfa, wa_vbrk, lv_in1 .

  ENDLOOP.

  IF NOT it_result[] IS INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = alv_obj
          CHANGING
            t_table      = it_result[].
      CATCH cx_salv_msg INTO lc_msg .
    ENDTRY.

    lyot_func = alv_obj->get_functions( ).
    lyot_func->set_all( abap_true ).

    lyot_disp = alv_obj->get_display_settings( ).
    lyot_disp->set_striped_pattern( cl_salv_display_settings=>true ).
    lyot_disp->set_list_header( 'Insurance Register' ).

    lyot_columns = alv_obj->get_columns( ).
    lyot_column ?= lyot_columns->get_column( 'KBETR' ).
    lyot_column->set_long_text( 'Insurance Amount Paid' ).
    lyot_add = alv_obj->get_aggregations( ).
    lyot_add->add_aggregation( 'KBETR' ).

    lyot_column ?= lyot_columns->get_column( 'NAME1' ).
    lyot_column->set_short_text( 'Name' ).
    lyot_column->set_medium_text( 'Name' ).
    lyot_column->set_long_text( 'Name' ).

    lyot_column ?= lyot_columns->get_column( 'ADDRESS' ).
*    LYOT_COLUMN->SET_OPTIMIZED( ).
    lyot_column->set_output_length('55').
    lyot_column->set_long_text( 'Address' ).

****
    lyot_column ?= lyot_columns->get_column( 'VBELN_VF' ).
    lyot_column->set_visible( abap_false ).
*    lyot_column->( '' ).

***
    lyot_column ?= lyot_columns->get_column( 'EXNUM' ).
*    LYOT_COLUMN->SET_OPTIMIZED( ).
    lyot_column->set_output_length('15').
    lyot_column->set_long_text( 'Tax Invoice No.' ).


    CREATE OBJECT lyot_txt.
    WRITE so_date-low  TO v_datelow.
    WRITE so_date-high  TO v_datehigh.
    CONCATENATE 'Date : '  v_datelow  ' To'  v_datehigh  INTO txt SEPARATED BY '  '.
    lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
    lyot_flow->create_text( text = 'Insurance Register' ).

    var_i = var_i + 1.
    lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).
    alv_obj->set_top_of_list( lyot_txt ).

    lyot_lout = alv_obj->get_layout( ).
    lyot_key-report = sy-repid.
    lyot_lout->set_key( lyot_key ).
    lyot_lout->set_save_restriction( cl_salv_layout=>restrict_none ).

    alv_obj->display( ).
  ENDIF.
