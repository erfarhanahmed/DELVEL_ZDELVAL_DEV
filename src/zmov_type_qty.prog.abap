*&---------------------------------------------------------------------*
*& Report ZMOV_TYPE_QTY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmov_type_qty.

TABLES :mseg, marc, makt , mara.


"for dynamic table
FIELD-SYMBOLS : <dyn_table> TYPE STANDARD TABLE,  "for dynamic table
                <dyn_wa>,
                <fs1>.

* Create the dynamic internal table
DATA : new_table TYPE REF TO data,
       new_line  TYPE REF TO data.

DATA: fieldname      TYPE string,
      fieldvalue(60) TYPE c.

DATA: it_fldcat  TYPE lvc_t_fcat,
      wa_fldcat  TYPE lvc_s_fcat,
      gs_layout1 TYPE lvc_s_layo,
      gs_sort    TYPE lvc_s_sort,               "slis_layout_alv,
      gt_sort    TYPE TABLE OF lvc_s_sort.                "slis_layout_alv,

TYPES : BEGIN OF ty_final,
          matnr   TYPE mseg-matnr,
          werks   TYPE mseg-werks,
          meins   TYPE mara-meins,
          moc     TYPE mara-moc,
          brand   TYPE mara-brand,
          zsize   TYPE mara-zsize,
          zseries TYPE mara-zseries,
          type    TYPE mara-type,
          vmvpr   TYPE mbew-vmvpr,
          maktx   TYPE makt-maktx,
        END OF ty_final.

TYPES  : BEGIN OF ty_bwart_po,
           bwart     TYPE mseg-bwart,
           matnr     TYPE mseg-matnr,
*           ebeln     TYPE mseg-ebeln,
           tot_menge TYPE mseg-menge,
         END OF ty_bwart_po.

TYPES  : BEGIN OF ty_bwart_prod,
           bwart          TYPE mseg-bwart,
           matnr          TYPE mseg-matnr,
*           aufnr          TYPE mseg-aufnr,
           tot_menge_prod TYPE mseg-menge,
         END OF ty_bwart_prod.

TYPES  : BEGIN OF ty_bwart_new,
           bwart         TYPE mseg-bwart,
           matnr         TYPE mseg-matnr,
*           aufnr          TYPE mseg-aufnr,
           tot_menge_new TYPE mseg-menge,
         END OF ty_bwart_new.

TYPES  : BEGIN OF ty_bwart,
           bwart TYPE mseg-bwart,
           matnr TYPE mseg-matnr,
         END OF ty_bwart.

DATA : it_bwart TYPE TABLE OF ty_bwart,
       wa_bwart TYPE ty_bwart.
DATA : it_bwart1 TYPE TABLE OF ty_bwart,
       wa_bwart1 TYPE ty_bwart.

DATA : it_bwart2 TYPE TABLE OF ty_bwart,
       wa_bwart2 TYPE ty_bwart.

DATA : it_bwart3 TYPE TABLE OF ty_bwart,
       wa_bwart3 TYPE ty_bwart.



TYPES  : BEGIN OF ty_bwart_final,
           bwart     TYPE string,
           matnr     TYPE mseg-matnr,
           ebeln     TYPE mseg-ebeln,
           aufnr     TYPE mseg-aufnr,
           tot_menge TYPE mseg-menge,

         END OF ty_bwart_final.

DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.

DATA : it_final1 TYPE TABLE OF ty_final,
       wa_final1 TYPE ty_final.

DATA : it_final_bwart TYPE TABLE OF ty_bwart_final,
       wa_final_bwart TYPE ty_bwart_final.

DATA : it_final_po TYPE TABLE OF ty_bwart_po,
       wa_final_po TYPE ty_bwart_po.

DATA : it_final_prod TYPE TABLE OF ty_bwart_prod,
       wa_final_prod TYPE ty_bwart_prod.

DATA : it_final_new TYPE TABLE OF ty_bwart_new,
       wa_final_new TYPE ty_bwart_new.

*----------------------------------------------------------------------*
* Selection screen
*----------------------------------------------------------------------*
SELECTION-SCREEN : BEGIN OF BLOCK b1.
PARAMETERS  : p_bukrs TYPE mseg-bukrs." OBLIGATORY.
SELECT-OPTIONS : s_werks FOR marc-werks OBLIGATORY.
SELECT-OPTIONS : s_matnr FOR mseg-matnr,
               s_mtart FOR mara-mtart,
               s_bwart FOR mseg-bwart,
               s_budat FOR mseg-budat_mkpf OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001  .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder TYPE rlgrap-filename DEFAULT 'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
SELECTION-SCREEN  COMMENT /1(60) TEXT-003.
SELECTION-SCREEN: END OF BLOCK b3.

CONSTANTS : c_1000  TYPE char4 VALUE '1000',
            c_us00  TYPE char4 VALUE 'US00',
            c_su00  TYPE char4 VALUE 'SU00',
            c_pl01  TYPE char4 VALUE 'PL01',
            c_us01  TYPE char4 VALUE 'US01',
            c_us02  TYPE char4 VALUE 'US02',
            c_us03  TYPE char4 VALUE 'US03',
            c_su01  TYPE char4 VALUE 'SU01',
            c_lang  TYPE char1 VALUE 'E',
            c_xauto TYPE char1 VALUE 'X'.
*&---------------------------------------------------------------------*
*& Start of Selection
*&---------------------------------------------------------------------*

START-OF-SELECTION.
  IF  s_werks-low = c_su01 OR  s_werks-low = c_pl01 .
    IF s_werks-high NE ' '.
      IF s_werks-low NE s_werks-high .
*    s_werks-high = .
        MESSAGE e005(zdelval_mesage).
      ENDIF.
    ENDIF.
  ENDIF.

  IF s_werks-low = c_su01.
    s_werks-high = c_su01.
  ENDIF.
  IF p_bukrs = c_1000 AND ( s_werks-low NE c_pl01 AND  s_werks-high NE c_pl01 ).
    MESSAGE e005(zdelval_mesage).
  ELSEIF p_bukrs = c_us00 AND ( s_werks-low NE c_us01 AND s_werks-low NE c_us02 AND s_werks-low NE c_us03 ) AND
                                                     ( s_werks-high NE c_us01 AND s_werks-high NE c_us02 AND s_werks-high NE c_us03 ).
    MESSAGE e005(zdelval_mesage).
  ELSEIF p_bukrs  = c_su00 AND ( s_werks-low NE c_su01 AND s_werks-high NE c_su01 ) .
    MESSAGE e005(zdelval_mesage).
  ENDIF.

  PERFORM get_data.
  PERFORM build_dynamic_table.
  PERFORM build_data.
  PERFORM sort_list.
  PERFORM alv_display.

FORM get_data.
*BREAK PRIMUSABAP.
*if s_matnr is NOT INITIAL.
  IF p_bukrs IS INITIAL.
    IF s_werks-low = c_pl01.
      p_bukrs = c_1000.
    ELSEIF s_werks-low = c_su01.
      p_bukrs = c_su00.
    ELSEIF s_werks-low NE c_us01 OR s_werks-low NE c_us02 OR s_werks-low NE c_us03.
      p_bukrs = c_us00 .
    ENDIF.
  ENDIF.
break primusabap.
  SELECT a~matnr,
         a~werks,
         b~meins,
         b~moc,
         b~brand,
         b~zsize,
         b~zseries,
         b~type,
*         c~vmvpr,
         d~maktx
         INTO TABLE @DATA(it_data)
         FROM marc AS a
         JOIN mara AS b ON ( b~matnr = a~matnr )
*         right JOIN mbew AS c ON ( c~matnr = a~matnr )
         INNER JOIN makt AS d ON ( d~matnr = a~matnr )
         WHERE  a~werks IN @s_werks
         AND a~matnr IN @s_matnr
       AND b~mtart IN @s_mtart
         AND d~spras = @c_lang."'E'.

  DELETE ADJACENT DUPLICATES FROM it_data COMPARING ALL FIELDS .
  it_final = it_data.

     SELECT bwart,
            matnr,
*           ebeln,
            SUM( menge ) AS tot_menge
            FROM mseg
            INTO TABLE @DATA(it_sum_po)
*           into CORRESPONDING FIELDS OF TABLE @data(it_sum_po)
            WHERE budat_mkpf IN @s_budat
            AND matnr IN @s_matnr
            AND werks IN @s_werks
            AND bwart IN @s_bwart
            AND bukrs = @p_bukrs
            AND ebeln NE ' '
            AND xauto NE @c_xauto "'X'
            GROUP BY matnr,bwart.",ebeln.

  it_final_po = it_sum_po.

  SELECT bwart,
         matnr,
*           aufnr,
         SUM( menge ) AS tot_menge_prod
         FROM mseg
         INTO TABLE @DATA(it_sum_prod)
         WHERE budat_mkpf IN @s_budat
         AND matnr IN @s_matnr
          AND werks IN @s_werks
          AND bwart IN @s_bwart
          AND bukrs = @p_bukrs
         AND aufnr NE ' '
         AND xauto NE @c_xauto"'X'
         GROUP BY matnr,bwart.",aufnr .
  it_final_prod = it_sum_prod.

  SELECT bwart,
     matnr,
*           aufnr,
     SUM( menge ) AS tot_menge_new
     FROM mseg
     INTO TABLE @DATA(it_sum_new)
     WHERE budat_mkpf IN @s_budat
     AND matnr IN @s_matnr
      AND werks IN @s_werks
      AND bwart IN @s_bwart
      AND bukrs = @p_bukrs
     AND aufnr = ' '
     AND ebeln = ' '
     AND xauto NE @c_xauto"'X'
     GROUP BY matnr,bwart.",aufnr .
  it_final_new = it_sum_new.


*
*  SELECT ebeln,
*         bsart
*         FROM ekko
*         INTO TABLE @DATA(it_ekko)
*         FOR ALL ENTRIES IN @it_sum_po
*         WHERE ebeln = @it_sum_po-ebeln.


  IF it_sum_po IS NOT INITIAL.
    SELECT bwart
           matnr
    FROM mseg
    INTO TABLE it_bwart
     FOR ALL ENTRIES IN it_sum_po
     WHERE  matnr = it_sum_po-matnr
       AND bwart =  it_sum_po-bwart.

  ENDIF.

  IF it_sum_prod IS NOT INITIAL.
    SELECT bwart
          matnr
   FROM mseg
  INTO TABLE it_bwart1
     FOR ALL ENTRIES IN it_sum_prod
    WHERE  matnr = it_sum_prod-matnr
       AND bwart =  it_sum_prod-bwart.
  ENDIF.

  IF it_sum_new IS NOT INITIAL.
    SELECT bwart
          matnr
   FROM mseg
  INTO TABLE it_bwart3
     FOR ALL ENTRIES IN it_sum_new
    WHERE  matnr = it_sum_new-matnr
       AND bwart =  it_sum_new-bwart.
  ENDIF.
  SORT it_bwart BY bwart.
  DELETE ADJACENT DUPLICATES FROM it_bwart COMPARING bwart.
  SORT it_bwart1 BY bwart.
  DELETE ADJACENT DUPLICATES FROM it_bwart1 COMPARING bwart.
  SORT it_bwart3 BY bwart.
  DELETE ADJACENT DUPLICATES FROM it_bwart3 COMPARING bwart.


  LOOP AT it_final INTO wa_final.
    READ TABLE it_final_po INTO wa_final_po WITH KEY matnr = wa_final-matnr.
    IF sy-subrc IS INITIAL.
      wa_bwart2-matnr = wa_final_po-matnr.
      APPEND wa_bwart2 TO it_bwart2.
    ENDIF.
    READ TABLE it_final_prod INTO wa_final_prod WITH KEY matnr = wa_final-matnr.
    IF sy-subrc IS INITIAL.
      wa_bwart2-matnr = wa_final_prod-matnr.
      APPEND wa_bwart2 TO it_bwart2.
    ENDIF.
    READ TABLE it_final_new INTO wa_final_new WITH KEY matnr = wa_final-matnr.
    IF sy-subrc IS INITIAL.
      wa_bwart2-matnr = wa_final_new-matnr.
      APPEND wa_bwart2 TO it_bwart2.
    ENDIF.
  ENDLOOP.
*
*  loop at it_final_po INTO wa_final_po.
*    wa_bwart2-matnr = wa_final_po-matnr.
*    APPEND wa_bwart2 TO it_bwart2.
*  endloop.

*  BREAK PRIMUSABAP.
  DELETE ADJACENT DUPLICATES FROM it_bwart2 COMPARING ALL FIELDS.
  LOOP AT it_bwart2 INTO wa_bwart2.
    READ TABLE it_final INTO wa_final WITH KEY matnr = wa_bwart2-matnr.
    IF sy-subrc IS INITIAL.
      wa_final1 = wa_final.
      APPEND wa_final1 TO it_final1.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_dynamic_table .
  CLEAR wa_fldcat.
  wa_fldcat-fieldname = 'MATNR'.
  wa_fldcat-coltext   = 'Material No.'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '18'.
  wa_fldcat-emphasize  = 'C5'.

  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'MAKTX'.
  wa_fldcat-coltext   = 'Material Description.'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '30'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'MEINS'.
  wa_fldcat-coltext   = 'Unit'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '10'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'VMVPR'.
  wa_fldcat-coltext   = 'Price Control'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '10'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'MOC'.
  wa_fldcat-coltext   = 'Moc'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '10'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'BRAND'.
  wa_fldcat-coltext   = 'Brand'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '10'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'ZSIZE'.
  wa_fldcat-coltext   = 'Size'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '10'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'ZSERIES'.
  wa_fldcat-coltext   = 'Series'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '10'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.

  wa_fldcat-fieldname = 'TYPE'.
  wa_fldcat-coltext   = 'Type'.
  wa_fldcat-datatype  = 'CHAR'.
  wa_fldcat-outputlen  = '10'.
*  WA_FLDCAT-EMPHASIZE  = 'C5'.
  APPEND wa_fldcat TO it_fldcat.
  DATA :  ld_lines      TYPE i.
  DESCRIBE TABLE it_bwart LINES ld_lines.
*break
*   primusabap.
*data(it_final_po1) = it_final_po.
* delete ADJACENT DUPLICATES FROM it_final_po1 COMPARING bwart.
  LOOP AT it_bwart INTO wa_bwart.
    CLEAR wa_fldcat.
    CONCATENATE wa_bwart-bwart '_MOVTYPE_PURCH' INTO wa_fldcat-fieldname.
    CONCATENATE 'Purchase_' wa_bwart-bwart INTO wa_fldcat-coltext.
    wa_fldcat-datatype  = 'CHAR'.
    wa_fldcat-outputlen  = '18'.
    wa_fldcat-no_zero  = 'X'.
*    wa_fldcat-do_sum = 'X'.
*    wa_fldcat-ref_field = 'MENGE'.
*    wa_fldcat-ref_table = 'MSEG'.
    APPEND wa_fldcat TO it_fldcat.

  ENDLOOP.
*data(it_final_prod1) = it_final_prod.
  LOOP AT it_bwart1 INTO wa_bwart1.
    CLEAR wa_fldcat.
    CONCATENATE wa_bwart1-bwart '_MOVTYPE_PROD' INTO wa_fldcat-fieldname.
    CONCATENATE 'Production_' wa_bwart1-bwart INTO wa_fldcat-coltext.
    wa_fldcat-datatype  = 'CHAR'.
    wa_fldcat-outputlen  = '18'.
    wa_fldcat-no_zero  = 'X'.
*    wa_fldcat-do_sum = 'X'.
*    wa_fldcat-ref_field = 'MENGE'.
*    wa_fldcat-ref_table = 'MSEG'.
    APPEND wa_fldcat TO it_fldcat.

  ENDLOOP.

  LOOP AT it_bwart3 INTO wa_bwart3.
    CLEAR wa_fldcat.
    CONCATENATE wa_bwart3-bwart '_MOVTYPE' INTO wa_fldcat-fieldname.
    CONCATENATE 'MovType_' wa_bwart3-bwart INTO wa_fldcat-coltext.
    wa_fldcat-datatype  = 'CHAR'.
    wa_fldcat-outputlen  = '18'.
    wa_fldcat-no_zero  = 'X'.
*    wa_fldcat-do_sum = 'X'.
*    wa_fldcat-ref_field = 'MENGE'.
*    wa_fldcat-ref_table = 'MSEG'.
    APPEND wa_fldcat TO it_fldcat.

  ENDLOOP.

*sort it_fldcat." by fieldname.
*delete ADJACENT DUPLICATES FROM it_fldcat COMPARING fieldname.

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
*     I_STYLE_TABLE             =
      it_fieldcatalog           = it_fldcat
*     I_LENGTH_IN_BYTE          =
    IMPORTING
      ep_table                  = new_table
*     E_STYLE_FNAME             =
    EXCEPTIONS
      generate_subpool_dir_full = 1
      OTHERS                    = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  ASSIGN new_table->* TO <dyn_table>.

* Create dynamic work area and assign to FS
  CREATE DATA new_line LIKE LINE OF <dyn_table>.
  ASSIGN new_line->* TO <dyn_wa>.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_data .
*  break primusabap.

  LOOP AT it_final1 INTO DATA(wa_data).


    CLEAR : <dyn_wa>.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'MATNR'.
    fieldvalue = wa_data-matnr.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'MAKTX'.
    fieldvalue = wa_data-maktx.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'MEINS'.
    fieldvalue = wa_data-meins.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'VMVPR'.
    fieldvalue = wa_data-vmvpr.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'MOC'.
    fieldvalue = wa_data-moc.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'BRAND'.
    fieldvalue = wa_data-brand.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'ZSIZE'.
    fieldvalue = wa_data-zsize.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'ZSERIES'.
    fieldvalue = wa_data-zseries.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    CLEAR : fieldname, fieldvalue.
    fieldname  = 'TYPE'.
    fieldvalue = wa_data-type.
    CONDENSE fieldvalue.
    ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
    <fs1> = fieldvalue.

    LOOP AT it_final_po INTO wa_final_po WHERE matnr = wa_data-matnr.

      CLEAR : fieldname, fieldvalue.
      CONCATENATE wa_final_po-bwart '_MOVTYPE_PURCH' INTO fieldname.
      fieldvalue = wa_final_po-tot_menge.
      CONDENSE fieldvalue.
      ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
      <fs1> = fieldvalue.

*     append <DYN_WA> to <DYN_TABLE>.
    ENDLOOP.
*
    LOOP AT it_final_prod INTO wa_final_prod WHERE matnr = wa_data-matnr.

      CLEAR : fieldname, fieldvalue.
      CONCATENATE wa_final_prod-bwart '_MOVTYPE_PROD' INTO fieldname.
      fieldvalue = wa_final_prod-tot_menge_prod.
      CONDENSE fieldvalue.
      ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
      <fs1> = fieldvalue.

    ENDLOOP.
*break primusabap.
    LOOP AT it_final_new INTO wa_final_new WHERE matnr = wa_data-matnr.

      CLEAR : fieldname, fieldvalue.
      CONCATENATE wa_final_new-bwart '_MOVTYPE' INTO fieldname.
      fieldvalue = wa_final_new-tot_menge_new.
      CONDENSE fieldvalue.
      ASSIGN COMPONENT fieldname OF STRUCTURE <dyn_wa> TO <fs1>.
      <fs1> = fieldvalue.

    ENDLOOP.
    APPEND <dyn_wa> TO <dyn_table>.
    CLEAR : wa_data ,wa_final_po,wa_final_prod,wa_final_new.
  ENDLOOP.


ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .

*   gs_layout1-colwidth_optimize = 'X'.
*   gs_layout1-zebra             = 'X'.
*   gs_layout1-detail_popup      = 'X'.
*   gs_layout1-subtotals_text    = 'DR'.


*  gs_layout1-col_opt   = 'X'.
*  gs_layout1-totals_bef   = 'X'.
  gs_layout1-numc_total  = abap_false.



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = SY-REPID
*     I_CALLBACK_PF_STATUS_SET  = 'PF_STATUS_SET'
      is_layout_lvc      = gs_layout1
      it_fieldcat_lvc    = it_fldcat[]
      it_sort_lvc        = gt_sort[]
*     I_GRID_SETTINGS    = gs_grid
*     IT_EVENTS          = lt_evts[]
*     IT_EVENTS          = I_EVENTS
*      i_default          = 'X'
      i_save             = 'S'
*     IS_VARIANT         = GS_VARIANT1
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab           = <dyn_table>
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*if p_down = 'X'.
*endloop.



ENDFORM.
*FORM pf_status_set USING extab TYPE slis_t_extab.
*  SET PF-STATUS 'STANDARD'.
*ENDFORM.
FORM sort_list.
  gs_sort-fieldname = 'MATNR'.
  gs_sort-spos = 1.
  gs_sort-up = 'X'.
  gs_sort-subtot = 'X'. "important statement
  APPEND gs_sort TO gt_sort.
ENDFORM.
