*&---------------------------------------------------------------------*
*& Report ZBOM_COMPO_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbom_compo_report.
*IF SY-TCODE = 'ZBOM'.
*IF sy-repid = 'ZBOM_COMPO_REPORT' .
*MESSAGE 'This Tcode is discontinued. Kindly use ZBOM1 Tcode' TYPE 'E'.
*ENDIF.
*ENDIF.
************************************************************************
*Table Declarations.
************************************************************************
TABLES : mast, stko, stpo.

************************************************************************
*Data Declarations
************************************************************************
TYPE-POOLS : slis.

*Internal Table for field catalog
DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
DATA : fs_layout TYPE slis_layout_alv.

*Internal Table for sorting
DATA : t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.


***** Changes By Amit 23-12-11 ***********************************************************************************

DATA : BEGIN OF i_mast_makt OCCURS 0,
         matnr TYPE mast-matnr,
         maktx TYPE makt-maktx,
         werks TYPE mast-werks,
         stlan TYPE mast-stlan,
         stlnr TYPE mast-stlnr,
         stlal TYPE mast-stlal,
         compd TYPE makt-maktx,
         stlst TYPE stko-stlst,
       END OF i_mast_makt.

DATA : BEGIN OF i_stko OCCURS 0,
         stlnr TYPE stko-stlnr,
         stlty TYPE stko-stlty,
         bmein TYPE stko-bmein,
         bmeng TYPE stko-bmeng,
         stlst TYPE stko-stlst,
         stlal TYPE stko-stlal,
         andat TYPE stko-andat,
         annam TYPE stko-annam,
       END OF i_stko.

DATA : BEGIN OF i_stas OCCURS 0,
         STLTY TYPE stas-STLTY,
         stlnr TYPE stas-stlnr,
         stlal TYPE stas-stlal,
         stlkn TYPE stas-stlkn,
*        LKENZ type stas-LKENZ,          "added by pankaj 20.01.2022  Deletion indicator
         STASZ TYPE stas-STASZ,
       END OF i_stas.

DATA : BEGIN OF i_stpo OCCURS 0,
         stlnr TYPE stpo-stlnr,
         stlkn TYPE stpo-stlkn,
*        LKENZ type stpo-LKENZ,          "added by pankaj 20.01.2022  Deletion indicator
         stpoz TYPE stpo-stpoz,
         aennr TYPE stpo-aennr,
         vgknt TYPE stpo-vgknt,
         vgpzl TYPE stpo-vgpzl,
         idnrk TYPE stpo-idnrk,
         meins TYPE stpo-meins,
         menge TYPE stpo-menge,
         datuv TYPE stpo-datuv,
         postp TYPE stpo-postp,
         posnr TYPE stpo-posnr,
       END OF i_stpo.
************************************************************************************************************

DATA : BEGIN OF itab OCCURS 0,
         matnr     TYPE mast-matnr,
         long_txt  TYPE char100,
         werks     TYPE mast-werks,
         stlan     TYPE mast-stlan,
         stlal     TYPE mast-stlal,
         bmeng     TYPE char15,
         bmein     TYPE stko-bmein,
         idnrk     TYPE stpo-idnrk,
         long_txt1 TYPE char100,
         menge     TYPE char15,
         meins     TYPE stpo-meins,
         stlst     TYPE stko-stlst,
         andat     TYPE char11,
         annam     TYPE stko-annam,
         ref       TYPE char15,

         maktx     TYPE makt-maktx,
         stlnr     TYPE mast-stlnr,
         stlty     TYPE stko-stlty,
         stlkn     TYPE stpo-stlkn,
         compd     TYPE makt-maktx,



         datuv     TYPE char15, "<----------Added by Amit 23.12.11
         postp     TYPE stpo-postp,
         posnr     TYPE stpo-posnr,
*        LKENZ TYPE stpo-LKENZ ,     "added by pankaj 20.01.2022


       END OF itab.

TYPES  : BEGIN OF ty_marc,
           matnr TYPE marc-matnr,
           lvorm TYPE marc-lvorm,
         END OF ty_marc.


DATA: BEGIN OF it_final OCCURS 0,
        matnr     TYPE mast-matnr,
        long_txt  TYPE char100,
        werks     TYPE mast-werks,
        stlan     TYPE mast-stlan,
        stlal     TYPE mast-stlal,
        bmeng     TYPE char15,
        bmein     TYPE stko-bmein,
        idnrk     TYPE stpo-idnrk,
        long_txt1 TYPE char100,
        menge     TYPE char15,
        meins     TYPE stpo-meins,
        stlst     TYPE stko-stlst,
        andat     TYPE char11,
        annam     TYPE stko-annam,
        datuv     TYPE char15,
        ref       TYPE char15,
        posnr     TYPE stpo-posnr,
        lvorm     TYPE marc-lvorm,
*      LKENZ TYPE stpo-LKENZ ,     "added by pankaj 20.01.2022
      END OF it_final.

DATA : gv_count TYPE char15.

DATA : it_marc TYPE TABLE OF ty_marc,
       wa_marc TYPE ty_marc.

DATA:
  lv_id    TYPE thead-tdname,
  lt_lines TYPE STANDARD TABLE OF tline,
  ls_lines TYPE tline.

DATA : wa_stpo TYPE stpo.
**********************SELECTION-SCREEN**************************
SELECTION-SCREEN: BEGIN OF BLOCK b1  WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS  : s_werks FOR mast-werks DEFAULT 'PL01' OBLIGATORY MODIF ID wer,
                  s_stlan FOR mast-stlan,
                  s_stlst FOR stko-stlst,
                  s_matnr FOR mast-matnr.
SELECTION-SCREEN: END OF BLOCK b1.
*********************END-OF-SELECTION**************************
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.


    "MESSAGE 'This Tcode is discontinued. Kindly use ZBOM1 Tcode' TYPE 'E'.



"ENDIF.

******************************************************COMMENTED BY DIKSHA HALVE 16.12.2022
*AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
*  LOOP AT SCREEN.
*    IF screen-group1 = 'WER'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.
*MESSAGE 'This Tcode is discontinued. Kindly use ZBOM1 Tcode' TYPE 'E'.
********************************************************************************************

START-OF-SELECTION.

  PERFORM data_select.
  PERFORM data_collect.
  PERFORM sort_list.
  PERFORM form_heading.

FORM data_select.

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


 " BREAK primus.

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
    WHERE werks IN s_werks
    AND   stlan IN s_stlan
    AND   mast~matnr IN s_matnr
    AND   stlst IN s_stlst.

  SORT i_mast_makt BY stlnr.
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
      WHERE stlnr = i_mast_makt-stlnr AND stlal = i_mast_makt-stlal AND stlst = i_mast_makt-stlst.  "  OR lkenz = 'X'." or stlst = s_stlst.

    SORT i_stko BY stlnr.

    SELECT STLTY
           stlnr
           stlal
           stlkn
           STASZ
    "  LKENZ                "added by pankaj
      FROM stas
      INTO CORRESPONDING FIELDS OF TABLE i_stas
      FOR ALL ENTRIES IN i_stko
      WHERE stlnr = i_stko-stlnr." AND lkenz = 'X'.      "added by pankaj 20.01.2022 LKENZ logic

*DELETE i_stas WHERE lkenz = 'X'.

    SELECT stlnr
           stlkn
           stpoz
           aennr
           vgknt
           vgpzl
           idnrk
           meins
           menge
           datuv
           postp
           posnr
      INTO CORRESPONDING FIELDS OF TABLE i_stpo
      FROM stpo
      FOR ALL ENTRIES IN i_stko
      WHERE stlnr = i_stko-stlnr AND stlty = i_stko-stlty
        AND vgknt = ' '
        AND vgpzl = ' '.
  ELSE.
    MESSAGE 'Data Not Found' TYPE 'E'.
  ENDIF.



  SELECT matnr
         lvorm
         FROM marc
         INTO TABLE it_marc
         FOR ALL ENTRIES IN i_stpo
         WHERE matnr = i_stpo-idnrk.




************************************************************************************************************

ENDFORM.


FORM data_collect.
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
  SORT i_stpo BY stlnr posnr datuv DESCENDING.
*DELETE ADJACENT DUPLICATES FROM i_stpo COMPARING stlnr posnr.


  "BREAK primus.

  LOOP AT i_stpo.



    SELECT SINGLE * FROM stpo INTO wa_stpo WHERE stlnr = i_stpo-stlnr AND vgknt = i_stpo-stlkn AND vgpzl = i_stpo-stpoz.
    IF sy-subrc = 0.
      itab-idnrk = wa_stpo-idnrk.
      itab-meins = wa_stpo-meins.
      itab-menge = wa_stpo-menge.
      itab-datuv = wa_stpo-datuv.
      itab-postp = wa_stpo-postp.
      itab-posnr = wa_stpo-posnr.
      itab-stlnr = wa_stpo-stlnr.
      itab-stlkn = wa_stpo-stlkn.
*   itab-lkenz = wa_stpo-lkenz.                          "added by pankaj 20.01.2022
    ELSE.
      itab-idnrk = i_stpo-idnrk.
      itab-meins = i_stpo-meins.
      itab-menge = i_stpo-menge.
      itab-datuv = i_stpo-datuv.
      itab-postp = i_stpo-postp.
      itab-posnr = i_stpo-posnr.
      itab-stlnr = i_stpo-stlnr.
      itab-stlkn = i_stpo-stlkn.
*   itab-lkenz = i_stpo-lkenz.                "added by pankaj 20.01.2022
    ENDIF.


    lv_id = itab-idnrk.

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


    READ TABLE i_stko WITH KEY stlnr = itab-stlnr.

    itab-bmein = i_stko-bmein.
    itab-bmeng = i_stko-bmeng.
    itab-stlst = i_stko-stlst.
*    itab-andat = i_stko-andat.
    itab-annam = i_stko-annam.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = i_stko-andat
      IMPORTING
        output = itab-andat.

    CONCATENATE itab-andat+0(2) itab-andat+2(3) itab-andat+5(4)
                    INTO itab-andat SEPARATED BY '-'.



    itab-ref = sy-datum.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = itab-ref
      IMPORTING
        output = itab-ref.

    CONCATENATE itab-ref+0(2) itab-ref+2(3) itab-ref+5(4)
                    INTO itab-ref SEPARATED BY '-'.



    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = itab-datuv
      IMPORTING
        output = itab-datuv.

    CONCATENATE itab-datuv+0(2) itab-datuv+2(3) itab-datuv+5(4)
                    INTO itab-datuv SEPARATED BY '-'.







    READ TABLE i_stas WITH KEY stlkn = itab-stlkn stlnr = itab-stlnr.

    itab-stlal = i_stas-stlal.
*    itab-lkenz = i_stas-lkenz.              "added by pankaj
    LOOP AT i_stas WHERE stlkn = itab-stlkn AND stlnr = itab-stlnr..
      gv_count = gv_count + 1.
    ENDLOOP.

    READ TABLE i_mast_makt WITH KEY stlnr = itab-stlnr stlal = i_stko-stlal.

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
      FROM makt WHERE matnr = itab-idnrk.

*    itab-compd = maktx1.
    itab-stlan = i_mast_makt-stlan.
    itab-stlnr = i_mast_makt-stlnr.


    it_final-matnr = itab-matnr.
    it_final-long_txt = itab-long_txt.
    it_final-werks = itab-werks.
    it_final-stlan = itab-stlan.
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
    it_final-posnr = itab-posnr.
    it_final-ref   = sy-datum.



    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = it_final-ref
      IMPORTING
        output = it_final-ref.

    CONCATENATE it_final-ref+0(2) it_final-ref+2(3) it_final-ref+5(4)
                    INTO it_final-ref SEPARATED BY '-'.


    READ TABLE it_marc INTO wa_marc WITH KEY matnr = it_final-idnrk lvorm = 'X'.
    IF sy-subrc = 0.
      CONTINUE.
    ENDIF.

    IF gv_count   < 2.

      APPEND itab.
      APPEND it_final.
    ENDIF.
*APPEND it_final.
    CLEAR: lv_id,itab-long_txt,itab-long_txt1,wa_stpo, gv_count.
  ENDLOOP.

************************************************************************************************************

ENDFORM.

FORM form_heading .

  REFRESH t_fieldcat.

  PERFORM t_fieldcatlog USING  '1'  'MATNR'         'Material Code' '18'.
  PERFORM t_fieldcatlog USING  '2'  'LONG_TXT'         'Description' '50'.
  PERFORM t_fieldcatlog USING  '3'  'WERKS'         'Plant' '5'.
  PERFORM t_fieldcatlog USING  '4' 'STLAN'         'BOM Usage'   '10'.
  PERFORM t_fieldcatlog USING  '5' 'STLAL'         'Alt BOM' '10'. "<----------Added by nupur 10.12.11
  PERFORM t_fieldcatlog USING  '6'  'BMENG'         'Base Qty' '10'.
  PERFORM t_fieldcatlog USING  '7'  'BMEIN'         'UOM'  '5'.

  PERFORM t_fieldcatlog USING  '8'  'POSNR'         'Line Item' '15'.

  PERFORM t_fieldcatlog USING  '9'  'IDNRK'         'Component' '18'.
  PERFORM t_fieldcatlog USING  '10'  'LONG_TXT1'         'Component Description' '50'.
  PERFORM t_fieldcatlog USING  '11'  'MENGE'         'Qty' '10'.
  PERFORM t_fieldcatlog USING  '12'  'MEINS'         'UOM' '5'.
  PERFORM t_fieldcatlog USING  '13' 'STLST'         'BOM Status' '10'.
  PERFORM t_fieldcatlog USING  '14' 'ANDAT'         'Created Date' '15'.
  PERFORM t_fieldcatlog USING  '15' 'ANNAM'         'Created By' '15'.
  PERFORM t_fieldcatlog USING  '16' 'DATUV'         'Valid From' '15'.
  PERFORM t_fieldcatlog USING  '17' 'REF'         'Refresh Date' '15'.


*   perform t_fieldcatlog using  '14' 'DATUV'         'Valid From'. "<----------Added by Amit 23.12.11
*   perform t_fieldcatlog using  '15' 'POSTP'         'Item Category'.
*   perform t_fieldcatlog using  '16' 'STLNR'         'Bill of Material'.

  PERFORM g_display_grid.
ENDFORM.                    " FORM_HEADING

FORM sort_list .
  t_sort-spos      = '1'.
  t_sort-fieldname = 'WERKS'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '2'.
  t_sort-fieldname = 'MATNR'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '3'.
  t_sort-fieldname = 'LONG_TXT'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '12'.
  t_sort-fieldname = 'STLAL'.
  t_sort-tabname   = 'ITAB[]'.
  t_sort-up        = 'X'.
*  t_sort-subtot    = 'X'.
  APPEND t_sort.
ENDFORM.                    " SOR


**&---------------------------------------------------------------------*
**&      Form  G_DISPLAY_GRID
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*



FORM g_display_grid .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      is_layout              = fs_layout
      i_callback_top_of_page = 'TOP-OF-PAGE'
      it_fieldcat            = t_fieldcat[]
      it_sort                = t_sort[]
      i_save                 = 'X'
    TABLES
      t_outtab               = itab
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
  ENDIF.


ENDFORM.                    " G_DISPLAY_GRID
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0800   text
*      -->P_0801   text
*      -->P_0802   text
*----------------------------------------------------------------------*
FORM t_fieldcatlog  USING    VALUE(x)
                             VALUE(f1)
                             VALUE(f2)
                             VALUE(p5).
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
  APPEND t_fieldcat.
  CLEAR t_fieldcat.


ENDFORM.                    " T_FIELDCATLOG

FORM top-of-page.

*ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

* Title
  wa_header-typ  = 'H'.
  wa_header-info = 'BOM Component Details'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.

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
  DESCRIBE TABLE itab LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
*       i_logo             = 'GANESH_LOGO'.
ENDFORM.                    " top-of-page
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
  lv_file = 'ZBOM.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_COMPO_REPORT', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_778 TYPE string.
DATA lv_crlf_778 TYPE string.
lv_crlf_778 = cl_abap_char_utilities=>cr_lf.
lv_string_778 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_778 lv_crlf_778 wa_csv INTO lv_string_778.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_778 TO lv_fullfile.
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
              'Component'
              'Component Description'
              'QTY'
              'UOM'
              'BOM Status'
              'Created Date'
              'Created By'
              'Valid From'
              'Refresh Date'
              'Line Item No'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
"ENDIF.
