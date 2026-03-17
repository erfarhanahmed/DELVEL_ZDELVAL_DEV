*&---------------------------------------------------------------------*
*& Report ZASSET_ITC4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zasset_itc4.

TABLES : mkpf,mseg,lfa1.

"Data Declaration


** Declaration for ALV Grid **
DATA : gr_table TYPE REF TO cl_salv_table.
** declaration for ALV Columns
DATA : gr_columns TYPE REF TO cl_salv_columns_table,
       gr_column  TYPE REF TO cl_salv_column_table.


** declaration for Layout Settings
DATA : gr_layout      TYPE REF TO cl_salv_layout,
       gr_layout_key  TYPE salv_s_layout_key,
       ls_layout      TYPE salv_s_layout,
       lt_layout_info TYPE salv_t_layout_info.

** Declaration for Global Display Settings
DATA : gr_display TYPE REF TO cl_salv_display_settings,
       lv_title   TYPE lvc_title.

** Declaration for Top of List settings
DATA : gr_content TYPE REF TO cl_salv_form_element.

DATA : l_rec(10)  TYPE n.
** Declarations for ALV Functions
DATA : gr_functions TYPE REF TO cl_salv_functions_list.

DATA : lt_mseg         TYPE TABLE OF mseg,
       ls_mseg         TYPE mseg,
       ls_mseg1        TYPE mseg,
       lt_mseg1        TYPE TABLE OF mseg,
       lt_mkpf         TYPE TABLE OF mkpf,
       lt_lfa1         TYPE TABLE OF lfa1,
       lt_makt         TYPE TABLE OF makt,
       lt_mara         TYPE TABLE OF mara,
       lt_j_1ig_subcon TYPE TABLE OF j_1ig_subcon.


TYPES : BEGIN OF ty_final,
          mblnr      TYPE mseg-mblnr,       "Material Document
          mjahr      TYPE mseg-mjahr,       "Mat doc year
          zeile      TYPE mseg-zeile,       "Mat Doc line item
          budat_makf TYPE mseg-budat_mkpf,  "Posting Date
          xblnr      TYPE mkpf-xblnr,       "Reference
          matnr      TYPE mseg-matnr,       "Material
          maktx      TYPE makt-maktx,       "Material Description
          meins      TYPE mara-meins,       "UOM
          menge      TYPE mseg-menge,       "Quantity
          bwart      TYPE mseg-bwart,       "Movement type
          in_out(7)  TYPE c,                "Tag 542 = Inward  541 = Outward text
          lifnr      TYPE mseg-lifnr,       "Vendor
          name1      TYPE lfa1-name1,       "Vendor Name
          stcd3      TYPE lfa1-stcd3,       "GSTIN No
          chln_inv   TYPE j_1ig_ci,         "Challan No
          chln_date  TYPE budat,            "Challan Date
          regio      TYPE lfa1-regio,       "State Code
          text(19)   TYPE c,                "Type of Goods - Default Other Than Job Work
          bldat      TYPE bldat,            "Document Date
*          smbln      TYPE mblnr,            "Number of Material Document
        END OF ty_final.

DATA : lt_final TYPE TABLE OF ty_final.
DATA : lt_final1 TYPE TABLE OF ty_final.

DATA : lv_date TYPE mseg-budat_mkpf.
DATA : lv_zeile TYPE mseg-zeile.

DATA: budat_mkpf1 TYPE mseg-budat_mkpf,
      mblnr1      TYPE mseg-mblnr.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text1.
PARAMETERS : p_werks TYPE werks_d DEFAULT 'PL01'.
*PARAMETERS : p_mjahr TYPE mjahr.
SELECT-OPTIONS : s_lifnr FOR lfa1-lifnr,
                 s_budat FOR mkpf-budat.
SELECTION-SCREEN : END OF BLOCK b1.


AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF screen-name = 'P_WERKS'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM data_manipulation.
  PERFORM display_data.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  SELECT * FROM mara INTO TABLE lt_mara
        WHERE ( mtart = 'UNBW'
           OR mtart = 'ZCON'
           OR mtart = 'ERSA'
           OR mtart = 'VERP'
           OR mtart = 'DIEN' ).

  IF lt_mara IS NOT INITIAL.
    SELECT * FROM mseg INTO TABLE lt_mseg
        FOR ALL ENTRIES IN lt_mara
        WHERE bwart IN ('541' , '542')        " mjahr = p_mjahr
        AND   xauto NE 'X'
        AND   werks = 'PL01'
        AND   matnr = lt_mara-matnr
        AND   lifnr IN s_lifnr
        AND   ebeln EQ ''.      "22.04.2019

    SELECT * FROM makt INTO TABLE lt_makt
       FOR ALL ENTRIES IN lt_mara
       WHERE spras = 'EN'
        AND matnr = lt_mara-matnr.
  ENDIF.

  IF lt_mseg IS NOT INITIAL.
    SELECT * FROM lfa1 INTO TABLE lt_lfa1
        FOR ALL ENTRIES IN lt_mseg
        WHERE lifnr = lt_mseg-lifnr.

    SELECT * FROM mkpf INTO TABLE lt_mkpf
      FOR ALL ENTRIES IN lt_mseg
      WHERE mblnr = lt_mseg-mblnr
        AND mjahr = lt_mseg-mjahr.

    SELECT * FROM j_1ig_subcon INTO TABLE lt_j_1ig_subcon
        FOR ALL ENTRIES IN lt_mseg
        WHERE bukrs IN ( '1000' , '2000' )
          AND mblnr = lt_mseg-mblnr
          AND mjahr = lt_mseg-mjahr
          AND matnr = lt_mseg-matnr
**          AND zeile = lt_mseg-zeile
           AND bwart IN ('541' , '542')
          AND status = 'I'.     "Added on 29.04.2019

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATA_MANIPULATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_manipulation .

*------Code Added By Abhijeet Nikam On 22.04.2019----------------------*
  MOVE lt_mseg TO lt_mseg1.
  DELETE lt_mseg1 WHERE smbln EQ ' '.
  LOOP AT lt_mseg1 INTO ls_mseg1.
    LOOP AT lt_mseg INTO ls_mseg.
      IF ls_mseg-mblnr = ls_mseg1-smbln.
        DELETE lt_mseg WHERE mblnr = ls_mseg-mblnr.
      ELSE.
        CONTINUE.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  DELETE lt_mseg WHERE smbln IS NOT INITIAL .
*--------------------------------------------------------------------*

  LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<f_mseg>).
    DATA : ls_final TYPE ty_final.
    DATA : ls_final1 TYPE ty_final.

    ls_final-mblnr = <f_mseg>-mblnr.
    ls_final-zeile = <f_mseg>-zeile.
    ls_final-mjahr  = <f_mseg>-mjahr.
    ls_final-budat_makf = <f_mseg>-budat_mkpf.
    ls_final-matnr = <f_mseg>-matnr.
    ls_final-bwart = <f_mseg>-bwart.
    ls_final-lifnr = <f_mseg>-lifnr.

    "If Movement type is 541 then quantity should be positive otherwise negative

    IF <f_mseg>-bwart = '541'.
      ls_final-menge = <f_mseg>-menge.
      ls_final-in_out = 'OUTWARD'.
    ELSEIF <f_mseg>-bwart = '542'.
      ls_final-menge = <f_mseg>-menge * -1.
      ls_final-in_out = 'INWARD'.
    ENDIF.

    READ TABLE lt_mkpf ASSIGNING FIELD-SYMBOL(<f_mkpf>) WITH KEY mblnr = <f_mseg>-mblnr mjahr = <f_mseg>-mjahr.
    IF <f_mkpf> IS ASSIGNED.
      ls_final-xblnr = <f_mkpf>-xblnr.
      ls_final-bldat = <f_mkpf>-bldat.
    ENDIF.

    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<f_lfa1>) WITH KEY lifnr = <f_mseg>-lifnr.
    IF <f_lfa1> IS ASSIGNED.
      ls_final-name1 = <f_lfa1>-name1.
      ls_final-regio = <f_lfa1>-regio.
      ls_final-stcd3 = <f_lfa1>-stcd3.
    ENDIF.

    READ TABLE lt_makt ASSIGNING FIELD-SYMBOL(<f_makt>) WITH KEY matnr = <f_mseg>-matnr.
    IF <f_makt> IS ASSIGNED.
      ls_final-maktx = <f_makt>-maktx.
    ENDIF.

    READ TABLE lt_mara ASSIGNING FIELD-SYMBOL(<f_mara>) WITH KEY matnr = <f_mseg>-matnr.
    IF <f_mara> IS ASSIGNED.
      ls_final-meins = <f_mara>-meins.
    ENDIF.

    CLEAR lv_zeile.
    lv_zeile = <f_mseg>-zeile.
    ADD 1 TO lv_zeile.

    READ TABLE lt_j_1ig_subcon ASSIGNING FIELD-SYMBOL(<f_subcon>) WITH KEY mblnr = <f_mseg>-mblnr
                                                                           mjahr = <f_mseg>-mjahr
                                                                           zeile = lv_zeile
*                                                                           bwart = '541'.
                                                                           bwart = <f_mseg>-bwart.
*---------Code Added By Abhijeet Nikam On 20.04.2019--------------------------*
    IF <f_subcon> IS ASSIGNED.
      IF ls_final-bwart = '541'.
        ls_final-chln_inv = <f_subcon>-chln_inv.
**        ls_final-chln_date = <f_subcon>-budat.
        IF ls_final-chln_inv IS NOT INITIAL.
          ls_final-chln_date = <f_mseg>-budat_mkpf.
        ENDIF.
      ELSEIF ls_final-bwart = '542'.
        ls_final-chln_inv = <f_mseg>-sgtxt.
        IF ls_final-chln_inv IS NOT INITIAL.
          SELECT SINGLE mblnr FROM j_1ig_subcon
            INTO  mblnr1 WHERE chln_inv = ls_final-chln_inv.
          SELECT SINGLE budat_mkpf FROM mseg
            INTO budat_mkpf1 WHERE mblnr = mblnr1.
          ls_final-chln_date = budat_mkpf1.
**           ls_final-chln_date = <f_mseg>-budat_mkpf.
        ENDIF.
      ENDIF.
    ENDIF.
*-----------------------------------------------------------------------------*
*Commented on 20.04.2019
**    IF ls_final-bwart = '541'.
**      ls_final-chln_date = <f_mseg>-budat_mkpf.
**      lv_date = ls_final-chln_date.
**    ELSEIF ls_final-bwart = '542'.
**      ls_final-chln_inv = <f_mseg>-sgtxt.
**    ENDIF.

    ls_final-text = 'Other Than Job Work'.

    APPEND ls_final TO lt_final.
    CLEAR: ls_final.
*    CLEAR: <f_mseg>,<f_mseg>,<f_mara>,<f_makt>,<f_lfa1>,<f_mkpf>, <f_subcon>.
    CLEAR: <f_mseg>.
    IF <f_subcon> IS ASSIGNED.
      CLEAR: <f_subcon>.
    ENDIF.
  ENDLOOP.


*
*  LOOP AT lt_final ASSIGNING FIELD-SYMBOL(<f_final>).
*    if <f_final>-chln_inv IS NOT INITIAL.
*    IF <f_final>-bwart = '542'.
*      READ TABLE lt_final INTO ls_final WITH KEY chln_inv = <f_final>-chln_inv bwart = '541'.
*      IF sy-subrc = 0.
*        IF <f_final>-chln_inv EQ  ls_final-chln_inv ."AND <f_final>-zeile = ls_final-zeile AND <f_final>-bwart = ls_final-bwart.
*          <f_final>-chln_date = ls_final-budat_makf.
*        ENDIF.
**          CLEAR : ls_final.
*      ENDIF.
*      ENDIF.
*      ELSE.
**        data : lv_date TYPE sy-datum.
*        <f_final>-chln_date = '' .
*    ENDIF.
*
*
*  ENDLOOP.


ENDFORM.


FORM display_data .
  CLEAR : gr_table.
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = lt_final.
    CATCH cx_salv_msg .
  ENDTRY.
  IF gr_table IS INITIAL.
    MESSAGE 'Error Creating ALV Grid ' TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

  "Get functions details
  gr_functions = gr_table->get_functions( ).

** Activate All Buttons in Tool Bar
  gr_functions->set_all( if_salv_c_bool_sap=>true ).


  CLEAR : gr_layout, gr_layout_key.
  MOVE sy-repid TO gr_layout_key-report.                        "Set Report ID as Layout Key"

  gr_layout = gr_table->get_layout( ).                          "Get Layout of Table"
  gr_layout->set_key( gr_layout_key ).                          "Set Report Id to Layout"
  gr_layout->set_save_restriction( if_salv_c_layout=>restrict_none ). "No Restriction to Save Layout"

  gr_layout->set_default( if_salv_c_bool_sap=>true ).         "Set Default Variant"

******* Top of List settings *******
  PERFORM top_of_page CHANGING gr_content.
  gr_table->set_top_of_list( gr_content ).

******** Set Column Heading ************
  TRY .
      gr_columns = gr_table->get_columns( ).
      gr_column ?= gr_columns->get_column( columnname = 'IN_OUT').
      gr_column->set_long_text( value = 'Tag').
      gr_column->set_output_length( 08 ).

      gr_column ?= gr_columns->get_column( columnname = 'TEXT').
      gr_column->set_long_text( value = 'Type of Goods').
      gr_column->set_output_length( 20 ).

      gr_column ?= gr_columns->get_column( columnname = 'NAME1').
      gr_column->set_long_text( value = 'Vendor Name').
      gr_column->set_output_length( 40 ).

      gr_column ?= gr_columns->get_column( columnname = 'CHLN_INV').
      gr_column->set_long_text( value = 'Challan No').
      gr_column->set_short_text( value = 'Challan No').
      gr_column->set_medium_text( value = 'Challan No').
      gr_column->set_output_length( 10 ).


      gr_column ?= gr_columns->get_column( columnname = 'STCD3').
      gr_column->set_long_text( value = 'GSTIN No').
      gr_column->set_short_text( value = 'GSTIN No').
      gr_column->set_medium_text( value = 'GSTIN No').
      gr_column->set_output_length( 10 ).

      gr_column ?= gr_columns->get_column( columnname = 'CHLN_DATE').
      gr_column->set_long_text( value = 'Challan Date').
      gr_column->set_short_text( value = 'Chln Date').
      gr_column->set_medium_text( value = 'Challan Date').
      gr_column->set_output_length( 10 ).



      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""'''
    CATCH cx_salv_not_found.
  ENDTRY.




******* Global Display Settings  *******
  CLEAR : gr_display.
  MOVE 'Gate Entries Details' TO lv_title.
  gr_display = gr_table->get_display_settings( ).               " Global Display settings"
  gr_display->set_striped_pattern( if_salv_c_bool_sap=>true ).  "Activate Strip Pattern"
  gr_display->set_list_header( lv_title ).                      "Report Header"


  CALL METHOD gr_table->display.

ENDFORM.

FORM top_of_page CHANGING lr_content TYPE REF TO cl_salv_form_element.
  DATA : lr_grid  TYPE REF TO cl_salv_form_layout_grid,
         lr_text  TYPE REF TO cl_salv_form_text,
         lr_label TYPE REF TO cl_salv_form_label,
         lr_head  TYPE string.

  MOVE 'Asset ITC4' TO lr_head.
  CREATE OBJECT lr_grid.
** Header of Top of Page **
  lr_grid->create_header_information( row     = 1
                                      column  = 1
                                      text    = lr_head
                                      tooltip = lr_head ).
** Add Row **
  lr_grid->add_row( ).

** Add Label in Grid **
  lr_label = lr_grid->create_label( row = 4
                                    column = 1
                                    text = 'No of Records'
                                    tooltip = 'No of Records' ).

  DESCRIBE TABLE lt_final LINES l_rec.

** Add Text in The Grid **
  lr_text = lr_grid->create_text( row = 4
                                  column = 2
                                  text = l_rec
                                  tooltip = l_rec ).
** Set Label and Text Link **
  lr_label->set_label_for( lr_text ).

** Move lr_grid to lr_content **
  lr_content = lr_grid.
ENDFORM.                    "top_of_page
