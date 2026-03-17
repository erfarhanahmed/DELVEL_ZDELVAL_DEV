*&---------------------------------------------------------------------*
*& Report ZSA_MIGO_105_FB08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsa_migo_105_fb08.



TABLES : mseg.
TYPES:BEGIN OF ty_mseg,
        mblnr      TYPE mseg-xblnr_mkpf,
        mjahr      TYPE mseg-mjahr,
        bwart      TYPE mseg-bwart,
        bukrs      TYPE mseg-bukrs,
        werks      TYPE mseg-werks,
        budat_mkpf TYPE mseg-budat_mkpf,
        xblnr_mkpf TYPE mseg-xblnr_mkpf,
        smbln      TYPE mseg-smbln,
      END OF ty_mseg,


      BEGIN OF ty_bkpf,
        belnr TYPE bkpf-belnr,
        gjahr TYPE bkpf-gjahr,
        blart TYPE bkpf-blart,
        xblnr TYPE bkpf-xblnr,
        stblg TYPE bkpf-stblg,
      END OF ty_bkpf,

      BEGIN OF final,
        mblnr103  TYPE mseg-mblnr,
        mblnr105  TYPE mseg-mblnr,
        belnrf02  TYPE bkpf-belnr,
        belnrfb08 TYPE bkpf-belnr,
        date      TYPE mseg-budat_mkpf,
        flag(1),
        gjahr     TYPE bkpf-gjahr,
      END OF final.

DATA: it_mseg  TYPE TABLE OF ty_mseg,
      wa_mseg  TYPE          ty_mseg,

      it_mseg1 TYPE TABLE OF ty_mseg,
      wa_mseg1 TYPE          ty_mseg,

      it_rev   TYPE TABLE OF ty_mseg,
      wa_rev   TYPE          ty_mseg,


      it_bkpf  TYPE TABLE OF ty_bkpf,
      wa_bkpf  TYPE          ty_bkpf,

      it_bkpf1 TYPE TABLE OF ty_bkpf,
      wa_bkpf1 TYPE          ty_bkpf,


      lt_final TYPE TABLE OF final,
      ls_final TYPE          final.


DATA: dd(02) TYPE c,
      mm(02) TYPE c,
      yy(04) TYPE c.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

CONSTANTS : c_check(1) VALUE 'X'.

DATA : bdcdata       TYPE STANDARD TABLE OF bdcdata WITH HEADER LINE.
DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS:s_mblnr TYPE mseg-mblnr.
SELECTION-SCREEN:END OF BLOCK b1.


START-OF-SELECTION.
  PERFORM get_data.
  PERFORM get_alv.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT mblnr
         mjahr
         bwart
         bukrs
         werks
         budat_mkpf
         xblnr_mkpf
         smbln       FROM mseg INTO TABLE it_mseg1
         WHERE mblnr = s_mblnr
           AND bukrs = 'SU00'
           AND bwart = '105'.

  IF it_mseg1 IS NOT INITIAL.
    SELECT  mblnr
                  mjahr
                  bwart
                  bukrs
                  werks
                  budat_mkpf
                  xblnr_mkpf
                  smbln
        FROM mseg INTO TABLE it_mseg
        FOR ALL ENTRIES IN it_mseg1
        WHERE xblnr_mkpf = it_mseg1-xblnr_mkpf
          AND bukrs = 'SU00'
          AND bwart = '103'.

  ENDIF.

  IF it_mseg IS NOT INITIAL.
          SELECT  mblnr
                  mjahr
                  bwart
                  bukrs
                  werks
                  budat_mkpf
                  xblnr_mkpf
                  smbln
        FROM mseg INTO TABLE it_rev
        FOR ALL ENTRIES IN it_mseg
        WHERE smbln = it_mseg-mblnr+0(10)
          AND bukrs = 'SU00'
          AND bwart = '104'.
  ENDIF.




  IF it_mseg IS NOT INITIAL.
          SELECT  belnr
                  gjahr
                  blart
                  xblnr
                  stblg FROM bkpf INTO TABLE it_bkpf
                  FOR ALL ENTRIES IN it_mseg
                  WHERE xblnr = it_mseg-mblnr
                    AND blart = 'TR'.




  ENDIF.

  IF it_bkpf IS NOT INITIAL.

          SELECT  belnr
                  gjahr
                  blart
                  xblnr
                  stblg FROM bkpf INTO TABLE it_bkpf1
                  FOR ALL ENTRIES IN it_bkpf
                  WHERE stblg = it_bkpf-belnr.




  ENDIF.
SORT it_bkpf DESCENDING by belnr.
SORT it_bkpf1 DESCENDING by belnr.
  READ TABLE it_mseg1 INTO wa_mseg1 INDEX 1.
  IF sy-subrc = 0.
    ls_final-mblnr105 = wa_mseg1-mblnr.
    ls_final-date     = wa_mseg1-budat_mkpf.

*    READ TABLE it_mseg INTO wa_mseg WITH KEY xblnr_mkpf = wa_mseg1-xblnr_mkpf.
    LOOP AT it_mseg INTO wa_mseg WHERE xblnr_mkpf = wa_mseg1-xblnr_mkpf..


    IF sy-subrc = 0.
    READ TABLE it_rev INTO wa_rev WITH KEY smbln = wa_mseg-mblnr+0(10).
    IF sy-subrc = 4.
      ls_final-mblnr103 = wa_mseg-mblnr.
    ENDIF.
    ENDIF.

    ENDLOOP.

    READ TABLE it_bkpf INTO wa_bkpf WITH KEY xblnr = ls_final-mblnr103.
    IF sy-subrc = 0.
      ls_final-belnrf02 = wa_bkpf-belnr.
      ls_final-gjahr    = wa_bkpf-gjahr.

    ENDIF.

    READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
    IF sy-subrc = 0.
      ls_final-belnrfb08 = wa_bkpf1-belnr.

    ENDIF.

    APPEND ls_final TO lt_final.
    CLEAR: ls_final.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ALV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_alv .

  PERFORM fcat USING :    '1'  'MBLNR105 '     'LT_FINAL'  'Reversal Material Document'      ''        ''       '18' ,
                          '2'  'BUDAT_MKPF '     'LT_FINAL'  'Rev Mat Doc Date'      ''        ''       '18' ,
                          '3'  'MBLNR103 '        'LT_FINAL'  'Material Document'           ''        ''       '18' ,
                          '4'  'BELNRF02 '        'LT_FINAL'  'Acounting NO'           ''        ''       '18' ,
                          '5'  'BELNRFB08 '        'LT_FINAL'  'Reves Acounting NO'           ''        ''       '18' ,
                          '6'  'FLAG '         'LT_FINAL'  'FB08'                    'X'       'X'      '18' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_top_of_page  = 'TOP-OF-PAGE'
      i_callback_user_command = 'USER_COMMAND'
      is_layout               = wa_layout
      it_fieldcat             = it_fcat
    TABLES
      t_outtab                = lt_final
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0502   text
*      -->P_0503   text
*      -->P_0504   text
*      -->P_0505   text
*      -->P_0506   text
*----------------------------------------------------------------------*
FORM fcat   USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5)
                    VALUE(p6)
                    VALUE(p7).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
  wa_fcat-checkbox  = p5.
  wa_fcat-edit     = p6.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p7.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.


FORM top-of-page.
*ALV HEADER DECLARATIONS
  DATA: lt_header     TYPE slis_t_listheader,
        ls_header     TYPE slis_listheader,
        lt_line       LIKE ls_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

* TITLE
  ls_header-typ  = 'H'.
  ls_header-info = 'Transit Report'.
  APPEND ls_header TO lt_header.
  CLEAR ls_header.

* DATE
  ls_header-typ  = 'S'.
  ls_header-key  = 'RUN DATE :'.
  CONCATENATE ls_header-info sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum(4) INTO ls_header-info.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header.

*TIME
  ls_header-typ  = 'S'.
  ls_header-key  = 'RUN TIME :'.
  CONCATENATE ls_header-info sy-timlo(2) '.' sy-timlo+2(2) '.' sy-timlo+4(2) INTO ls_header-info.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE lt_final LINES ld_lines.
  ld_linesc = ld_lines.
  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' ld_linesc
     INTO lt_line SEPARATED BY space.


  ls_header-typ  = 'A'.
  ls_header-info = lt_line.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header, lt_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
ENDFORM.                    " TOP-OF-PAGE

FORM user_command USING r_ucomm LIKE sy-ucomm s_selfield TYPE slis_selfield.

  DATA : ref_grid TYPE REF TO cl_gui_alv_grid.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'   "This FM will get the reference of the changed data in ref_grid
    IMPORTING
      e_grid = ref_grid.

  IF ref_grid IS NOT INITIAL.
    CALL METHOD ref_grid->check_changed_data( ).
  ENDIF.

*IF wa_final-flag = 'X'.
READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
IF sy-subrc = 4.


  READ TABLE lt_final INTO ls_final INDEX 1.
  IF sy-subrc = 0.
    PERFORM bdc_fb08.
  ENDIF.
ELSE.
  MESSAGE 'Already Reverse' TYPE 'E'.
ENDIF.
ENDFORM.

FORM setpf USING tab TYPE slis_t_extab.

  SET PF-STATUS 'ZCHECK'.

ENDFORM.

*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_FB08
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdc_fb08 .
    DATA : budat(10).
    WRITE ls_final-date TO budat.
  PERFORM bdc_dynpro      USING 'SAPMF05A' '0105'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'UF05A-STGRD'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'RF05A-BELNS'
                                ls_final-belnrf02.
  PERFORM bdc_field       USING 'BKPF-BUKRS'
                                'SU00'.
  PERFORM bdc_field       USING 'RF05A-GJAHS'
                                ls_final-gjahr ."'2018'.
  PERFORM bdc_field       USING 'UF05A-STGRD'
                                '02'.
  PERFORM bdc_dynpro      USING 'SAPMF05A' '0105'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RF05A-BELNS'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=BU'.
  PERFORM bdc_field       USING 'RF05A-BELNS'
                                ls_final-belnrf02.      "'1004'.
  PERFORM bdc_field       USING 'BKPF-BUKRS'
                                'SU00'.
  PERFORM bdc_field       USING 'RF05A-GJAHS'
                                ls_final-gjahr."'2018'.
  PERFORM bdc_field       USING 'UF05A-STGRD'
                                '02'.
  PERFORM bdc_field       USING 'BSIS-BUDAT'
                                budat.


  CALL TRANSACTION 'FB08' USING bdcdata UPDATE 'S' MODE 'E'.
ENDFORM.


FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.
*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
*  ENDIF.
ENDFORM.
