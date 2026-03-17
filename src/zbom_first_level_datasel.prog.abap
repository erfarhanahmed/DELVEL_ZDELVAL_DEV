*&---------------------------------------------------------------------*
*&  Include           ZBOM_FIRST_LEVEL_DATASEL
*&---------------------------------------------------------------------*
DATA:
    ls_exch_rate TYPE bapi1093_0.

START-OF-SELECTION.

  IF open_so = 'X'.
 SELECT vbeln
        ERDAT
        VKORG
        KNUMV
        kunnr FROM vbak INTO TABLE it_vbak  WHERE vbeln IN s_vbeln
                                              AND vkorg = p_vkorg
                                              AND kunnr IN s_kunnr.
 IF it_vbak IS NOT INITIAL.
   SELECT vbeln
          posnr
          lfsta
          lfgsa
          fksta
          gbsta
          UVFAK FROM vbup INTO TABLE it_vbup
          FOR ALL ENTRIES IN it_vbak
          WHERE vbeln = it_vbak-vbeln
          AND   lfsta  NE 'C'
          AND   lfgsa  NE 'C'
          AND   fksta  NE 'C'
          AND   gbsta  NE 'C'.
ENDIF.

IF it_vbup IS NOT INITIAL.
    SELECT vbeln
           posnr
           matnr
           werks
           FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbup
           WHERE vbeln = it_vbup-vbeln
           AND posnr = it_vbup-posnr.
ENDIF.


       IF sy-subrc = 0.


      PERFORM fill_tables.
      PERFORM process_for_output.
     ENDIF.

ELSEIF all_so = 'X'.
    SELECT vbeln
           ERDAT
           VKORG
           KNUMV
           kunnr
      FROM vbak INTO TABLE it_vbak WHERE erdat IN s_date AND
                                                vbeln IN s_vbeln AND

                                                vkorg = p_vkorg AND
                                                kunnr IN s_kunnr .

IF it_vbak IS NOT INITIAL.
   SELECT vbeln
          posnr
          lfsta
          lfgsa
          fksta
          gbsta
          UVFAK FROM vbup INTO TABLE it_vbup
          FOR ALL ENTRIES IN it_vbak
          WHERE vbeln = it_vbak-vbeln
          AND   UVFAK  = 'C'.

ENDIF.

IF it_vbup IS NOT INITIAL.
 SELECT vbeln
           posnr
           matnr
           werks
           FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbup
           WHERE vbeln = it_vbup-vbeln
           AND posnr = it_vbup-posnr.
ENDIF.

    IF sy-subrc = 0.
      PERFORM fill_tables.
      PERFORM process_for_output.
*      IF p_down IS   INITIAL.
*        PERFORM alv_for_output.
*      ELSE.
*        PERFORM down_set_all.
*      ENDIF.
    ENDIF.

  ELSE.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

FORM fill_tables .

*  IF open_so = 'X'.
*
*  ELSE.
*    SELECT vbeln
*           posnr
*           matnr
*           werks
*       FROM vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_vbak WHERE vbeln = it_vbak-vbeln.
*  ENDIF.
*  IF it_vbap[] IS NOT INITIAL.
*
*  ENDIF.
ENDFORM.                    " FILL_TABLES
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM process_for_output .
  DATA:
    lv_ratio TYPE resb-enmng,
    lv_qty   TYPE resb-enmng,
    lv_index TYPE sy-tabix.
  IF it_vbap[] IS NOT INITIAL.
    CLEAR: wa_vbap, wa_vbak, wa_vbep, wa_mska,
           wa_vbrp, wa_konv, wa_kna1.
    SORT it_vbap BY vbeln posnr matnr werks.
    SORT it_mska BY vbeln posnr matnr werks.
    SORT it_afpo BY kdauf kdpos matnr.
    SORT lt_resb BY aufnr kdauf kdpos.
    LOOP AT it_vbap INTO wa_vbap.

      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln.
      wa_output-vbeln       = wa_vbak-vbeln.           "Sales Order

      wa_output-matnr       = wa_vbap-matnr.           "Material
      wa_output-posnr       = wa_vbap-posnr.           "item

      APPEND wa_output TO it_output.
      CLEAR ls_vbep.
*      clear:wa_output-wip,wa_output-stock_qty .
*
    ENDLOOP.

*
  ENDIF.

*  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
SORT it_output by matnr.
DELETE ADJACENT DUPLICATES FROM IT_OUTPUT COMPARING MATNR.

ENDFORM.                    " PROCESS_FOR_OUTPUT


*Table Declarations.
************************************************************************
tables : mast, stko, stpo.

************************************************************************
*Data Declarations
************************************************************************
type-pools : slis.

*Internal Table for field catalog
data : t_fieldcat type slis_t_fieldcat_alv with header line.
data : fs_layout type slis_layout_alv.

*Internal Table for sorting
data : t_sort type slis_t_sortinfo_alv with header line.


***** Changes By Amit 23-12-11 ***********************************************************************************

data : begin of i_mast_makt occurs 0,
        matnr type mast-matnr,
        maktx type makt-maktx,
        werks type mast-werks,
        stlan type mast-stlan,
        stlnr type mast-stlnr,
        stlal type mast-stlal,
        compd type makt-maktx,
        stlst TYPE stko-stlst,
       end of i_mast_makt.

data : begin of i_stko occurs 0,
        stlnr type stko-stlnr,
        stlty type stko-stlty,
        bmein type stko-bmein,
        bmeng type stko-bmeng,
        stlst type stko-stlst,
        stlal type stko-stlal,
        andat type stko-andat,
        annam type stko-annam,
       end of i_stko.

data : begin of i_stas occurs 0,
        stlnr type stas-stlnr,
        stlal type stas-stlal,
        stlkn type stas-stlkn,
       end of i_stas.

data : begin of i_stpo occurs 0,
        stlnr type stpo-stlnr,
        stlkn type stpo-stlkn,
        idnrk type stpo-idnrk,
        meins type stpo-meins,
        menge type stpo-menge,
        datuv type stpo-datuv,
        postp type stpo-postp,
        posnr type stpo-posnr,
       end of i_stpo.
************************************************************************************************************

data : begin of itab occurs 0,
        matnr type mast-matnr,
        long_txt TYPE char100,
        werks type mast-werks,
        stlan type mast-stlan,
        stlal type mast-stlal,
        bmeng type char15,
        bmein type stko-bmein,
        idnrk type stpo-idnrk,
        long_txt1 TYPE char100,
        menge type char15,
        meins type stpo-meins,
        stlst type stko-stlst,
        andat type char11,
        annam type stko-annam,
        ref   TYPE char15,

        maktx type makt-maktx,
        stlnr type mast-stlnr,
        stlty type stko-stlty,
        stlkn type stpo-stlkn,
        compd type makt-maktx,



        datuv type char15,"<----------Added by Amit 23.12.11
        postp type stpo-postp,
        posnr type stpo-posnr,


end of itab.

data : begin of itab1 occurs 0,
        matnr type mast-matnr,
        long_txt TYPE char100,
        werks type mast-werks,
        stlan type mast-stlan,
        stlal type mast-stlal,
        bmeng type char15,
        bmein type stko-bmein,
        idnrk type stpo-idnrk,
        long_txt1 TYPE char100,
        menge type char15,
        meins type stpo-meins,
        stlst type stko-stlst,
        andat type char11,
        annam type stko-annam,
        ref   TYPE char15,

        maktx type makt-maktx,
        stlnr type mast-stlnr,
        stlty type stko-stlty,
        stlkn type stpo-stlkn,
        compd type makt-maktx,



        datuv type char15,"<----------Added by Amit 23.12.11
        postp type stpo-postp,
        posnr type stpo-posnr,


end of itab1.




data: BEGIN OF it_final occurs 0,
      matnr type mast-matnr,
      long_txt TYPE char100,
      werks type mast-werks,
      stlan type mast-stlan,
      stlal type mast-stlal,
      bmeng type char15,
      bmein type stko-bmein,
      posnr type stpo-posnr,
      idnrk type stpo-idnrk,
      long_txt1 TYPE char100,
      menge type char15,
      meins type stpo-meins,
      stlst type stko-stlst,
      andat type char11,
      annam type stko-annam,
      datuv TYPE char15,
      ref   TYPE char15,
 END OF it_final.




 DATA:
    lv_id        TYPE thead-tdname,
    lt_lines     TYPE STANDARD TABLE OF tline.
*    ls_lines     TYPE tline.

**********************SELECTION-SCREEN**************************
*  selection-screen: begin of block b1  with frame title text-001.
*  select-options  : s_werks for mast-werks OBLIGATORY,
*                    s_stlan for mast-stlan,
*                    s_stlst for stko-stlst,
*                    s_matnr for mast-matnr.
*  selection-screen: end of block b1.
**********************END-OF-SELECTION**************************
*SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
*PARAMETERS p_down AS CHECKBOX.
*PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
*SELECTION-SCREEN END OF BLOCK B2.



start-of-selection.

perform data_select.
perform data_collect.
perform sort_list.
perform form_heading.

form data_select.

* select mast~matnr
*        mast~werks
*        mast~stlan
*        mast~stlnr
*        mast~stlal
*        stko~stlty
*        stko~bmein
*        stko~bmeng
*        stko~stlst
*        stpo~stlkn
*        stpo~idnrk
*        stpo~meins
*        stpo~menge
*        stpo~datuv
*        stpo~postp
*        stpo~posnr
*  into CORRESPONDING FIELDS OF TABLE itab
*  from mast
*  INNER JOIN stko on mast~stlnr = stko~stlnr and mast~stlal = stko~stlal
*  INNER JOIN stpo on stko~stlty = stpo~stlty and stko~stlnr = stpo~stlnr
*  where werks in s_werks
*  and   stlan in s_stlan
*  and   stlst in s_stlst.


*BREAK fujiabap.
IF it_output IS NOT INITIAL.


SELECT mast~matnr
       makt~maktx
       mast~werks
       mast~stlan
       mast~stlnr
       mast~stlal
       stko~stlst
*       makt~compd
  INTO CORRESPONDING FIELDS OF TABLE i_mast_makt
  FROM mast
  INNER JOIN makt ON mast~matnr = makt~matnr
  INNER JOIN stko ON mast~stlnr = stko~stlnr
  FOR ALL ENTRIES IN it_output
  WHERE mast~matnr = it_output-matnr.
*  WHERE werks in s_werks
*  AND   stlan in s_stlan
*  AND   mast~matnr in s_matnr
*  AND   stlst in s_stlst.
ENDIF.

sort i_mast_makt by stlnr.
IF sy-subrc IS INITIAL.
  SELECT stlnr
         stlty
         bmein
         bmeng
         stlst
         stlal
         andat
         annam
    INTO CORRESPONDING FIELDS OF TABLE i_stko
    FROM stko
    FOR ALL ENTRIES IN i_mast_makt
    WHERE stlnr = i_mast_makt-stlnr AND stlal = i_mast_makt-stlal AND stlst = i_mast_makt-stlst." or stlst = s_stlst.

SORT i_stko by stlnr.

  SELECT stlnr
         stlal
         stlkn
    FROM stas
    INTO CORRESPONDING FIELDS OF TABLE i_stas
    FOR ALL ENTRIES IN i_stko
    WHERE stlnr = i_stko-stlnr.



  SELECT stlnr
         stlkn
         idnrk
         meins
         menge
         datuv
         postp
         posnr
    INTO CORRESPONDING FIELDS OF TABLE i_stpo
    FROM stpo
    FOR ALL ENTRIES IN i_stko
    WHERE stlnr = i_stko-stlnr AND stlty = i_stko-stlty.

    ELSE.
      MESSAGE 'Data Not Found' TYPE 'E'.
    ENDIF.

************************************************************************************************************

endform.


form data_collect.
*  if not itab[] is initial.
*    loop at itab.
*      select single maktx into itab-maktx
*        from makt
*        where matnr = itab-matnr.
*
*      select single maktx into itab-compd
*        from makt
*        where matnr = itab-idnrk.
*
*      modify itab.
*      clear  itab.
*    endloop.
*  endif.

***** Changes By Amit 23-12-11 *******************************************************************************************

SORT i_stpo by stlnr posnr datuv DESCENDING.
DELETE ADJACENT DUPLICATES FROM i_stpo COMPARING stlnr posnr.

LOOP AT i_stpo.
*BREAK primus.
    itab-idnrk = i_stpo-idnrk.
    itab-meins = i_stpo-meins.
    itab-menge = i_stpo-menge.
    itab-datuv = i_stpo-datuv.
    itab-postp = i_stpo-postp.
    itab-posnr = i_stpo-posnr.


 lv_id = i_stpo-idnrk.

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
          CONCATENATE itab-long_txt1 ls_lines-tdline INTO itab-long_txt1 SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE itab-long_txt1.
    ENDIF.
CLEAR lv_id.


    READ TABLE i_stko with key stlnr = i_stpo-stlnr.

    itab-bmein = i_stko-bmein.
    itab-bmeng = i_stko-bmeng.
    itab-stlst = i_stko-stlst.
*    itab-andat = i_stko-andat.
    itab-annam = i_stko-annam.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = i_stko-andat
   IMPORTING
     OUTPUT        = itab-andat
            .

CONCATENATE itab-andat+0(2) itab-andat+2(3) itab-andat+5(4)
                INTO itab-andat SEPARATED BY '-'.



itab-ref = sy-datum.
 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = itab-ref
   IMPORTING
     OUTPUT        = itab-ref
            .

CONCATENATE itab-ref+0(2) itab-ref+2(3) itab-ref+5(4)
                INTO itab-ref SEPARATED BY '-'.



CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = itab-datuv
   IMPORTING
     OUTPUT        = itab-datuv
            .

CONCATENATE itab-datuv+0(2) itab-datuv+2(3) itab-datuv+5(4)
                INTO itab-datuv SEPARATED BY '-'.







    READ TABLE i_stas with key stlkn = i_stpo-stlkn stlnr = i_stpo-stlnr.

    itab-stlal = i_stas-stlal.


    READ TABLE i_mast_makt with key stlnr = i_stpo-stlnr stlal = i_stko-stlal.

    itab-werks = i_mast_makt-werks.
    itab-matnr = i_mast_makt-matnr.




    lv_id = i_mast_makt-matnr.

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
          CONCATENATE itab-long_txt ls_lines-tdline INTO itab-long_txt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE itab-long_txt.
    ENDIF.



*    itab-maktx = i_mast_makt-maktx.

    SELECT SINGLE maktx INTO itab-compd
      FROM makt WHERE matnr = i_stpo-idnrk.
*    itab-compd = maktx1.
    itab-stlan = i_mast_makt-stlan.
    itab-stlnr = i_mast_makt-stlnr.


it_final-matnr = itab-matnr.
it_final-long_txt = itab-long_txt.
it_final-werks = itab-werks.
it_final-stlan = itab-stlan.
it_final-posnr = itab-posnr.
it_final-stlal = itab-stlal.
it_final-bmeng = itab-bmeng.
it_final-bmein = itab-bmein.
it_final-idnrk = itab-idnrk.
it_final-long_txt1 = itab-long_txt1.
it_final-menge = itab-menge.
it_final-meins = itab-meins.
it_final-stlst = itab-stlst.
it_final-andat = itab-andat.
it_final-annam = itab-annam.
it_final-datuv = itab-datuv.
it_final-ref   = sy-datum.



 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = it_final-ref
   IMPORTING
     OUTPUT        = it_final-ref
            .

CONCATENATE it_final-ref+0(2) it_final-ref+2(3) it_final-ref+5(4)
                INTO it_final-ref SEPARATED BY '-'.




APPEND itab.
APPEND it_final.




*APPEND it_final.
CLEAR: lv_id,itab-long_txt,itab-long_txt1.
ENDLOOP.

************************************************************************************************************

endform.

form form_heading .

  refresh t_fieldcat.

  perform t_fieldcatlog using  '1'  'MATNR'         'Material Code' '18'.
  perform t_fieldcatlog using  '2'  'LONG_TXT'         'Description' '50'.
  perform t_fieldcatlog using  '3'  'WERKS'         'Plant' '5'.
  perform t_fieldcatlog using  '4' 'STLAN'         'BOM Usage'   '10'.
  perform t_fieldcatlog using  '5' 'STLAL'         'Alt BOM' '10'. "<----------Added by nupur 10.12.11
  perform t_fieldcatlog using  '6'  'BMENG'         'Base Qty' '10'.
  perform t_fieldcatlog using  '7'  'BMEIN'         'UOM'  '5'.

  perform t_fieldcatlog using  '8'  'POSNR'         'Comp Serial No' '15'.

  perform t_fieldcatlog using  '9'  'IDNRK'         'Component' '18'.
  perform t_fieldcatlog using  '10'  'LONG_TXT1'         'Component Description' '50'.
  perform t_fieldcatlog using  '11'  'MENGE'         'Qty' '10'.
  perform t_fieldcatlog using  '12'  'MEINS'         'UOM' '5'.
  perform t_fieldcatlog using  '13' 'STLST'         'BOM Status' '10'.
  perform t_fieldcatlog using  '14' 'ANDAT'         'Created Date' '15'.
  perform t_fieldcatlog using  '15' 'ANNAM'         'Created By' '15'.
  perform t_fieldcatlog using  '16' 'DATUV'         'Valid From' '15'.
  perform t_fieldcatlog using  '17' 'REF'         'Refresh Date' '15'.


*   perform t_fieldcatlog using  '14' 'DATUV'         'Valid From'. "<----------Added by Amit 23.12.11
*   perform t_fieldcatlog using  '15' 'POSTP'         'Item Category'.
*   perform t_fieldcatlog using  '16' 'STLNR'         'Bill of Material'.

  perform g_display_grid.
endform.                    " FORM_HEADING

form sort_list .
  t_sort-spos      = '1'.
  t_sort-fieldname = 'WERKS'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  append t_sort.

  t_sort-spos      = '2'.
  t_sort-fieldname = 'MATNR'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  append t_sort.

  t_sort-spos      = '3'.
  t_sort-fieldname = 'LONG_TXT'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  append t_sort.

  t_sort-spos      = '12'.
  t_sort-fieldname = 'STLAL'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
*  t_sort-subtot    = 'X'.
  append t_sort.
endform.                    " SOR


**&---------------------------------------------------------------------*
**&      Form  G_DISPLAY_GRID
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*



form g_display_grid .

call function 'REUSE_ALV_GRID_DISPLAY'
       exporting
            i_callback_program       = sy-repid
            is_layout                = fs_layout
            i_callback_top_of_page   = 'TOP-OF-PAGE'
            it_fieldcat              = t_fieldcat[]
            it_sort                 = t_sort[]
            i_save                   = 'X'
       tables
            t_outtab                 = itab
       exceptions
            program_error            = 1
            others                   = 2.
  if sy-subrc <> 0.
 message id sy-msgid type sy-msgty number sy-msgno
         with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

IF p_down = 'X'.
    PERFORM download.
  ENDIF.


endform.                    " G_DISPLAY_GRID
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0800   text
*      -->P_0801   text
*      -->P_0802   text
*----------------------------------------------------------------------*
form t_fieldcatlog  using    value(x)
                             value(f1)
                             value(f2)
                             value(p5).
  t_fieldcat-col_pos = x.
  t_fieldcat-fieldname = f1.
  t_fieldcat-seltext_l = f2.
*  t_fieldcat-decimals_out = '2'.
 t_fieldcat-outputlen   = p5.

*if f1 = 'MENGE'    or f1 = 'EXBAS'    or f1 = 'DR_EXBED' or f1 = 'DR_ECS'       or f1 = 'DR_EXADDTAX1' or
*   f1 = 'DR_EXAED' or f1 = 'CR_EXBED' or f1 = 'CR_ECS '  or f1 = 'CR_EXADDTAX1' or f1 = 'CR_EXAED'.
**   f1 = 'CL_EXBED' or f1 = 'CL_ECS'   or f1 = 'CL_EXAED' or f1 = 'CL_EXADDTAX1'.
*   t_fieldcat-do_sum = 'X'.
*  endif.
*
  append t_fieldcat.
  clear t_fieldcat.


endform.                    " T_FIELDCATLOG

form top-of-page.

*ALV Header declarations
  data: t_header type slis_t_listheader,
        wa_header type slis_listheader,
        t_line like wa_header-info,
        ld_lines type i,
        ld_linesc(10) type c.

* Title
  wa_header-typ  = 'H'.
  wa_header-info = 'First Level BOM Details'.
  append wa_header to t_header.
  clear wa_header.

* Date
*  wa_header-typ  = 'S'.
*  wa_header-key = 'From: '.
*  concatenate wa_header-info cpudt1+6(2) '.' cpudt1+4(2) '.' cpudt1(4) into wa_header-info.
*  concatenate wa_header-info ' To' cpudt-high+6(2) into wa_header-info separated by space.
*  concatenate wa_header-info  '.' cpudt-high+4(2) '.' cpudt-high(4) into wa_header-info. " separated by space.
*  append wa_header to t_header.
*  clear: wa_header.

*  CONCATENATE  sy-datum+6(2) '.'
*               sy-datum+4(2) '.'
*   sy-datum(4) INTO wa_header-info."todays date
*  CONCATENATE  into wa_header-info separated by space.

* Total No. of Records Selected
  describe table itab lines ld_lines.
  ld_linesc = ld_lines.

  concatenate 'Total No. of Records Selected: ' ld_linesc
     into t_line separated by space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  append wa_header to t_header.
  clear: wa_header, t_line.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
       exporting
       it_list_commentary = t_header.
*       i_logo             = 'GANESH_LOGO'.
endform.                    " top-of-page
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZBOMLEVEL.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_COMPO_LEVEL_REPORT', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
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
FORM cvs_header  USING    pd_csv.
 DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Material Code'
              'Description'
              'Plant'
              'BOM Usage'
              'Base qty'
              'ALT BOM'
              'UOM'
              'Comp Serial No'
              'Component'
              'Component Description'
              'QTY'
              'UOM'
              'BOM Status'
              'Created Date'
              'Created By'
              'Valid From'
              'Refresh Date'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
