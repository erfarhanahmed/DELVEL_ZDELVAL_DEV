*&---------------------------------------------------------------------*
*& Report ZSU_MIGO_103_F02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsu_migo_103_f02.


TABLES:mseg.

TYPES:BEGIN OF ty_mseg,
        mblnr      TYPE mseg-xblnr_mkpf,
        mjahr      TYPE mseg-mjahr,
        bwart      TYPE mseg-bwart,
        bukrs      TYPE mseg-bukrs,
        werks      TYPE mseg-werks,
        budat_mkpf TYPE mseg-budat_mkpf,
        xblnr_mkpf TYPE mseg-xblnr_mkpf,
        vbelp_im   TYPE mseg-vbelp_im,
      END OF ty_mseg,

      BEGIN OF ty_vbrk,
        vbeln TYPE vbrk-vbeln,
        knumv TYPE vbrk-knumv,
        netwr TYPE vbrk-netwr,
      END OF ty_vbrk,
      BEGIN OF ty_vbrp,
        vbeln TYPE vbrp-vbeln,
        posnr TYPE vbrp-posnr,
        vgbel TYPE vbrp-vgbel,
        vgpos TYPE vbrp-vgpos,
      END OF ty_vbrp,

      BEGIN OF ty_bkpf,
        belnr TYPE bkpf-belnr,
        blart TYPE bkpf-blart,
        xblnr TYPE bkpf-xblnr,
        stblg TYPE bkpf-stblg,
      END OF ty_bkpf,

      BEGIN OF ty_konv,
        knumv TYPE prcd_elements-knumv,
        kposn TYPE prcd_elements-kposn,
        kschl TYPE prcd_elements-kschl,
        kwert TYPE prcd_elements-kwert,
      END OF ty_konv,
****************************ADD BY AVINASH BHAGAT**************************************
      BEGIN OF ty_mkpf,
        mblnr TYPE mkpf-mblnr,
        xblnr TYPE mkpf-xblnr,
        bldat TYPE mkpf-bldat,
      END OF ty_mkpf,

******************************************************************
      BEGIN OF ty_final,
        mblnr   TYPE mseg-mblnr,
        vbeln   TYPE vbrk-vbeln,
        budat   TYPE mseg-budat_mkpf,
        amount  TYPE prcd_elements-kwert,
        belnr   TYPE bkpf-belnr,
        bldat   TYPE mkpf-bldat, " ADD BY AVINASH BHAGAT
        flag(1),
      END OF ty_final,

      BEGIN OF final,
        mblnr103 TYPE mseg-mblnr,
        mblnr105 TYPE mseg-mblnr,
        belnr    TYPE bkpf-belnr,
        flag(1),
      END OF final.

DATA: it_mseg  TYPE TABLE OF ty_mseg,
      wa_mseg  TYPE          ty_mseg,

      it_mseg1 TYPE TABLE OF ty_mseg,
      wa_mseg1 TYPE          ty_mseg,

      it_vbrk  TYPE TABLE OF ty_vbrk,
      wa_vbrk  TYPE          ty_vbrk,

      it_vbrp  TYPE TABLE OF ty_vbrp,
      wa_vbrp  TYPE          ty_vbrp,

      it_bkpf  TYPE TABLE OF ty_bkpf,
      wa_bkpf  TYPE          ty_bkpf,

      it_bkpf1 TYPE TABLE OF ty_bkpf,
      wa_bkpf1 TYPE          ty_bkpf,

      it_konv  TYPE TABLE OF ty_konv,
      wa_konv  TYPE          ty_konv,

****************ADD BY AVINASH BHAGAT************************************
      it_mkpf  TYPE TABLE OF ty_mkpf,
      wa_mkpf  TYPE ty_mkpf,
*************************************************************************

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final,

      lt_final TYPE TABLE OF final,
      ls_final TYPE          final.


DATA: dd(02) TYPE c,
      mm(02) TYPE c,
      yy(04) TYPE c.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

*CONSTANTS : c_check(1)." VALUE 'X'.

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
         vbelp_im FROM mseg INTO TABLE it_mseg
         WHERE mblnr = s_mblnr
           AND bukrs = 'SU00'
           AND bwart = '103'.
***********************ADD BY AVINASH BHAGAT*******************************************************
*  BREAK primus.
  SELECT
    mblnr
    xblnr
    bldat
    FROM mkpf INTO TABLE it_mkpf
*    FOR ALL ENTRIES IN it_mseg
     WHERE mblnr = s_mblnr.

******************************************************************************

  IF it_mseg IS NOT INITIAL.
    SELECT vbeln
           posnr
           vgbel
           vgpos FROM vbrp INTO TABLE it_vbrp
           FOR ALL ENTRIES IN it_mseg
           WHERE vgbel = it_mseg-xblnr_mkpf+0(10).
*             AND posnr = it_mseg-vbelp_im.

  ENDIF.

  IF it_vbrp IS NOT INITIAL.
    SELECT vbeln
           knumv
           netwr FROM vbrk INTO TABLE it_vbrk
           FOR ALL ENTRIES IN it_vbrp
           WHERE vbeln = it_vbrp-vbeln.
  ENDIF.
  IF it_vbrk IS NOT INITIAL.
    SELECT knumv
           kposn
           kschl
           kwert FROM prcd_elements INTO TABLE it_konv
           FOR ALL ENTRIES IN it_vbrk
           WHERE knumv = it_vbrk-knumv
             AND kschl = 'ZPR0'.

  ENDIF.

  IF it_mseg IS NOT INITIAL.
    SELECT belnr
           blart
           xblnr
           stblg FROM bkpf INTO TABLE it_bkpf
           FOR ALL ENTRIES IN it_mseg
           WHERE xblnr = it_mseg-mblnr
             AND blart = 'TR'.



  ENDIF.

  IF it_bkpf IS NOT INITIAL.
    SELECT belnr
           blart
           xblnr
           stblg FROM bkpf INTO TABLE it_bkpf1
           FOR ALL ENTRIES IN it_bkpf
           WHERE stblg = it_bkpf-belnr.
*           AND blart = 'TR'.

  ENDIF.


  SORT it_mseg .
  SORT it_vbrp.
  SORT it_konv.
*LOOP AT it_mseg INTO wa_mseg.
  READ TABLE it_mseg INTO wa_mseg INDEX 1.

  IF sy-subrc = 0.


    wa_final-mblnr = wa_mseg-mblnr.
    wa_final-budat = wa_mseg-budat_mkpf.

**************************ADD BY AVINASH BHAGAT**************************
    READ TABLE it_mkpf INTO wa_mkpf INDEX 1.
*    wa_final-mblnr = wa_mkpf-mblnr.
    wa_final-bldat = wa_mkpf-bldat.
****************************************************

*LOOP AT it_vbrp INTO wa_vbrp WHERE vgbel = wa_mseg-xblnr_mkpf+0(10)." AND vgpos = wa_mseg-VBELP_IM..
    READ TABLE it_vbrp INTO wa_vbrp WITH KEY vgbel = wa_mseg-xblnr_mkpf+0(10)." posnr = wa_mseg-vbelp_im.
    IF sy-subrc = 0.
*
    ENDIF.
    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
    IF sy-subrc = 0.
      wa_final-vbeln = wa_vbrk-vbeln.
      wa_final-amount =  wa_vbrk-netwr.
*      wa_final-amount =  wa_final-amount / 10 .
    ENDIF.
*READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr.
*IF sy-subrc = 0.
*  wa_final-amount =  wa_konv-kwert.

*ENDIF.



*READ TABLE it_bkpf INTO wa_bkpf WITH KEY xblnr = wa_mseg-mblnr.
*IF sy-subrc = 0.
*READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
*IF sy-subrc = 4.
*wa_final-belnr = wa_bkpf-belnr.
*ENDIF.
*ENDIF.

    LOOP AT it_bkpf INTO wa_bkpf WHERE xblnr = wa_mseg-mblnr..
      IF sy-subrc = 0.
        READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
        IF sy-subrc = 4.
          wa_final-belnr = wa_bkpf-belnr.
        ENDIF.

      ENDIF.
    ENDLOOP.
    APPEND wa_final TO it_final.
*COLLECT wa_final INTO  it_final.
  ENDIF.
*APPEND wa_final TO it_final.
*CLEAR wa_final.
*ENDLOOP.
*
*LOOP AT it_final INTO wa_final.
*COLLECT wa_final INTO  it_final .
*ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_alv .
  PERFORM fcat USING :  '1'  'MBLNR '        'IT_FINAL'  'Material Document'      ''        ''       '18' ,
                        '2'  'BUDAT '        'IT_FINAL'  'Posting Date'           ''        ''       '18' ,
*                        '2'  'BLDAT '        'IT_FINAL'  'Posting Date'           ''        ''       '18' ,
                        '3'  'VBELN '        'IT_FINAL'  'Invoice Number'          ''        ''       '18' ,
                        '4'  'AMOUNT '       'IT_FINAL'  'Invoice Amount'         ''        ''       '18' ,
                        '5'  'BELNR '        'IT_FINAL'  'Acounting NO'           ''        ''       '18' ,
                        '6'  'FLAG '         'IT_FINAL'  'F-02'                    'X'       'X'      '18' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_top_of_page  = 'TOP-OF-PAGE'
      i_callback_user_command = 'USER_COMMAND'
      is_layout               = wa_layout
      it_fieldcat             = it_fcat
    TABLES
      t_outtab                = it_final
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
  DESCRIBE TABLE it_final LINES ld_lines.
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


*READ TABLE it_bkpf INTO wa_bkpf WITH KEY xblnr = wa_final-mblnr.
*IF sy-subrc = 4.
  PERFORM bdc.
*ELSE.
*  MESSAGE 'Already posted' TYPE 'E'.
*ENDIF.
*ELSE.
*  MESSAGE 'Please Select Check Box' TYPE 'E'.
*ENDIF.
ENDFORM.

FORM setpf USING tab TYPE slis_t_extab.

  SET PF-STATUS 'ZCHECK'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdc .
  DATA : budat(10),
         bldat(10),
         amount(13).
  READ TABLE it_final INTO wa_final INDEX 1.
  amount = wa_final-amount.
  WRITE wa_final-budat TO budat.
  WRITE wa_final-bldat TO bldat. "  ADD BY AVINASH BHAGAT
  PERFORM bdc_dynpro      USING 'SAPMF05A' '0100'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RF05A-NEWKO'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'BKPF-BLDAT'
                                bldat.              "wa_final-budat.           "'28.12.2018'.
  PERFORM bdc_field       USING 'BKPF-BLART'
                                'TR'.
  PERFORM bdc_field       USING 'BKPF-BUKRS'
                                'SU00'.
  PERFORM bdc_field       USING 'BKPF-BUDAT'
                                budat.              "wa_final-budat.        "'28.12.2018'.
*perform bdc_field       using 'BKPF-MONAT'
*                              '9'.
  PERFORM bdc_field       USING 'BKPF-WAERS'
                                'SAR'.
  PERFORM bdc_field       USING 'BKPF-XBLNR'
                                wa_final-mblnr.             "'test 2'.

  PERFORM bdc_field       USING 'BKPF-BKTXT'
                                wa_final-vbeln.             "'test 2'.

  PERFORM bdc_field       USING 'FS006-DOCID'
                                '*'.
  PERFORM bdc_field       USING 'RF05A-NEWBS'
                                 '31'.
  PERFORM bdc_field       USING 'RF05A-NEWKO'
                                '600001'.                  "'1000019'.
  PERFORM bdc_dynpro      USING 'SAPMF05A' '0302'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RF05A-NEWKO'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'BSEG-WRBTR'
                                amount.    "wa_final-amount.            "'1000'.
  PERFORM bdc_field       USING 'BSEG-MWSKZ'
                                '**'.
*perform bdc_field       using 'BSEG-ZTERM'
*                              'U101'.
*perform bdc_field       using 'BSEG-ZBD1T'
*                              '15'.
  PERFORM bdc_field       USING 'BSEG-ZFBDT'
                                bldat.                  " wa_final-budat.         "'28.12.2018'.
  PERFORM bdc_field       USING 'RF05A-NEWBS'
                                '40'.
  PERFORM bdc_field       USING 'RF05A-NEWKO'
                                '410083'.                    "'12051'.
  PERFORM bdc_dynpro      USING 'SAPMF05A' '0300'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'BSEG-ZUONR'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=ZK'.
  PERFORM bdc_field       USING 'BSEG-WRBTR'
                                amount.                 "wa_final-amount.      "'1000'.
  PERFORM bdc_field       USING 'BSEG-MWSKZ'
                                'I0'.
  PERFORM bdc_field       USING 'DKACB-FMORE'
                                'X'.
  PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'COBL-PRCTR'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=ENTE'.
  PERFORM bdc_field       USING 'COBL-PRCTR'
                                'SU5000'.
  PERFORM bdc_dynpro      USING 'SAPMF05A' '0330'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'BSEG-DMBE2'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=BS'.
*perform bdc_field       using 'BSEG-DMBE2'
*                              '70,000.00'.
  PERFORM bdc_dynpro      USING 'SAPMF05A' '0700'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RF05A-NEWBS'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=BU'.
  PERFORM bdc_field       USING 'BKPF-XBLNR'
                                wa_final-mblnr.               "'TEST 2'.
  CALL TRANSACTION 'F-02' USING bdcdata UPDATE 'S' MODE 'E'.


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
*ENDFORM.
