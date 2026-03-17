*&---------------------------------------------------------------------*
*& Report ZGRN_POST_CALCULATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgrn_post_calculation.


TYPE-POOLS:slis.
TABLES:mseg,mkpf.

TYPES : BEGIN OF ty_mseg,
          mblnr      TYPE mseg-mblnr,
          ebeln      TYPE mseg-ebeln,
          bwart      TYPE mseg-bwart,
*        BLDAT TYPE MSEG-BLDAT,
          werks      TYPE mseg-werks,
          dmbtr      TYPE mseg-dmbtr,
          budat_mkpf TYPE mseg-budat_mkpf,
          smbln      TYPE mseg-smbln,
        END OF ty_mseg,


        BEGIN OF ty_mkpf,
          mblnr TYPE mkpf-mblnr,
          xblnr TYPE mkpf-xblnr,
          bldat TYPE mkpf-bldat,
          budat TYPE mkpf-budat,
          bktxt TYPE mkpf-bktxt,
          mjahr TYPE mkpf-mjahr,
        END OF ty_mkpf,

        BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,
          knumv TYPE ekko-knumv,
          aedat TYPE ekko-aedat,
          bedat TYPE ekko-bedat,
          waers TYPE ekko-waers,
          lifnr TYPE ekko-lifnr,
          ekorg TYPE ekko-ekorg,
          lands TYPE ekko-lands,
        END OF ty_ekko,

        BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          bukrs TYPE ekpo-bukrs,
          mwskz TYPE ekpo-mwskz,
          mtart TYPE ekpo-mtart,

        END OF ty_ekpo,

        BEGIN OF ty_konv,
          knumv TYPE  prcd_elements-knumv,
          kschl TYPE  prcd_elements-kschl,
          kbetr TYPE  prcd_elements-kbetr,
        END OF ty_konv,

        BEGIN OF ty_bseg,
          belnr TYPE bseg-belnr,
          buzei TYPE bseg-buzei,
          gjahr TYPE bseg-gjahr,
          dmbtr TYPE bseg-dmbtr,
          xopvw TYPE bseg-xopvw,
          ebeln TYPE bseg-ebeln,
          ebelp TYPE bseg-ebelp,
        END OF ty_bseg,

        BEGIN OF ty_bkpf,
          belnr TYPE bkpf-belnr,
          awkey TYPE bkpf-awkey,
        END OF ty_bkpf,

        BEGIN OF ty_final,
          mblnr     TYPE mseg-mblnr,
          ebeln     TYPE mseg-ebeln,
          bwart     TYPE mseg-bwart,
          xblnr     TYPE mkpf-xblnr,
          bldat     TYPE mkpf-bldat,
          budat     TYPE mkpf-budat,
          bktxt     TYPE mkpf-bktxt,
          mjahr     TYPE mkpf-mjahr,
          knumv     TYPE ekko-knumv,
          kschl     TYPE  prcd_elements-kschl,
          kbetr     TYPE  p length 16 decimals 3, " prcd_elements-kbetr,
          tot_value TYPE  p length 16 decimals 3, "prcd_elements-kbetr,
          gross     TYPE  p length 16 decimals 3, "prcd_elements-kbetr,
          cal_val   TYPE  prcd_elements-kwert,
          inv       TYPE  prcd_elements-kwert,
          mblnr1    TYPE bkpf-awkey,
          ind       TYPE char10,
        END OF ty_final.
DATA: gv_mblnr TYPE bkpf-awkey.
DATA: it_mseg  TYPE TABLE OF ty_mseg,
      wa_mseg  TYPE          ty_mseg,

      it_mseg1 TYPE TABLE OF ty_mseg,
      wa_mseg1 TYPE          ty_mseg,

      it_mkpf  TYPE TABLE OF ty_mkpf,
      wa_mkpf  TYPE          ty_mkpf,

      it_ekko  TYPE TABLE OF ty_ekko,
      wa_ekko  TYPE          ty_ekko,

      it_ekpo  TYPE TABLE OF ty_ekpo,
      wa_ekpo  TYPE          ty_ekpo,

      it_konv  TYPE TABLE OF ty_konv,
      wa_konv  TYPE          ty_konv,

      it_bkpf  TYPE TABLE OF ty_bkpf,
      wa_bkpf  TYPE          ty_bkpf,

      it_bseg  TYPE TABLE OF ty_bseg,
      wa_bseg  TYPE          ty_bseg,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.

DATA: it_taxcom TYPE TABLE OF taxcom,
      wa_taxcom TYPE          taxcom,

      it_taxcon TYPE TABLE OF taxcom,
      wa_taxcon TYPE          taxcom.

DATA :lv_netwr   TYPE ekpo-netwr,
      kb_cgst    TYPE ekpo-netwr,
      kb_igst    TYPE komv-kwert,
      cgst       TYPE komv-kwert,
      sgst       TYPE komv-kwert,
      igst       TYPE komv-kwert,
      tot_tax    TYPE komv-kwert,
      text       TYPE string,
      gv_del_tax TYPE komv-kwert,
      kb_sgst    TYPE komv-kbetr.


DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.
DATA : it_xkomv TYPE komv OCCURS 0 WITH HEADER LINE.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: mblnr FOR mseg-mblnr,
                s_date FOR mseg-budat_mkpf DEFAULT '20170926' TO sy-datum.
*  PARAMETERS:  S_INV TYPE MSEG-DMBTR.
*                  BLDAT FOR MKPF-BLDAT.
SELECTION-SCREEN:END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM get_fcat.
  PERFORM get_display.
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
         ebeln
         bwart
         werks
         dmbtr
         budat_mkpf
         smbln
         FROM mseg INTO TABLE it_mseg
         WHERE mblnr IN mblnr
         AND budat_mkpf IN s_date
         AND bwart = '101'
         AND werks = 'PL01'.

  IF it_mseg IS NOT INITIAL.
    SELECT mblnr
           xblnr
           bldat
           budat
           bktxt
           mjahr FROM mkpf INTO TABLE it_mkpf
           FOR ALL ENTRIES IN it_mseg
           WHERE mblnr = it_mseg-mblnr.


    SELECT ebeln
           knumv
           aedat
           bedat
           waers
           lifnr
           ekorg
           lands
            FROM ekko INTO TABLE it_ekko
           FOR ALL ENTRIES IN it_mseg
           WHERE ebeln = it_mseg-ebeln.

  ENDIF.

  IF it_mkpf IS NOT INITIAL .

  SELECT mblnr
         ebeln
         bwart
         werks
         dmbtr
         budat_mkpf
         smbln
         FROM mseg INTO TABLE it_mseg1
         FOR ALL ENTRIES IN it_mkpf
         WHERE smbln = it_mkpf-mblnr
         AND bwart = '102'.


  ENDIF.

  IF it_ekko IS NOT INITIAL.
    SELECT knumv
           kschl
           kbetr FROM PRCD_ELEMENTS INTO TABLE it_konv
           FOR ALL ENTRIES IN it_ekko
           WHERE knumv = it_ekko-knumv.

    SELECT ebeln
           ebelp
           bukrs
           mwskz
           mtart FROM ekpo INTO TABLE it_ekpo
           FOR ALL ENTRIES IN it_ekko
           WHERE ebeln = it_ekko-ebeln.

  ENDIF.

  LOOP AT it_mkpf INTO wa_mkpf.

    wa_final-mblnr = wa_mkpf-mblnr.
    wa_final-xblnr = wa_mkpf-xblnr.
    wa_final-bktxt = wa_mkpf-bktxt.
    wa_final-bldat = wa_mkpf-bldat.
    wa_final-mjahr = wa_mkpf-mjahr.
    CONCATENATE wa_final-mblnr wa_final-mjahr INTO gv_mblnr.

    wa_final-mblnr1 = gv_mblnr.
    SELECT belnr
           awkey FROM bkpf INTO TABLE it_bkpf
           WHERE awkey = gv_mblnr.

    IF it_bkpf IS NOT INITIAL.
      SELECT belnr
             buzei
             gjahr
             dmbtr
             xopvw
             ebeln
             ebelp FROM bseg INTO TABLE it_bseg
             FOR ALL ENTRIES IN it_bkpf
             WHERE belnr = it_bkpf-belnr
             AND xopvw = 'X'.

    ENDIF.

    READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY smbln = wa_final-mblnr.
     IF sy-subrc = 0.
       wa_final-ind = 'X'.

     ENDIF.

*    READ TABLE it_bkpf INTO wa_bkpf WITH KEY awkey = wa_final-mblnr1.
* IF sy-subrc = 0.
loop at it_bkpf INTO wa_bkpf where awkey = wa_final-mblnr1.


*LOOP AT IT_MSEG INTO WA_MSEG WHERE MBLNR = WA_MKPF-MBLNR.
    LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bkpf-belnr.



      READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_bseg-ebeln.
      READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_bseg-ebeln
                                               ebelp = wa_bseg-ebelp.
IF sy-subrc = 0.



      wa_taxcon-bukrs = wa_ekpo-bukrs.
      wa_taxcon-budat = wa_ekko-aedat.
      wa_taxcon-bldat = wa_ekko-bedat.
      wa_taxcon-waers = wa_ekko-waers.
      wa_taxcon-hwaer = wa_ekko-waers.
      wa_taxcon-kposn = wa_ekpo-ebelp.
      wa_taxcon-mwskz = wa_ekpo-mwskz.
      lv_netwr        = wa_bseg-dmbtr.

      wa_taxcon-wrbtr = lv_netwr.

      wa_taxcon-xmwst = 'X'.
      wa_taxcom-shkzg =  'H'.
*  it_taxcon-txjcd = it_ekpo-txjcd.
      wa_taxcon-lifnr = wa_ekko-lifnr.
      wa_taxcon-ekorg = wa_ekko-ekorg.
      wa_taxcon-ebeln = wa_ekpo-ebeln.
      wa_taxcon-ebelp = wa_ekpo-ebelp.
*  wa_taxcon-matnr = wa_item-matnr.
*  wa_taxcon-werks = it_ekpo-werks.
*  wa_taxcon-matkl = it_ekpo-matkl.
*  wa_taxcon-meins = wa_item-meins.
*  wa_taxcon-mglme = wa_item-menge.
      wa_taxcon-mtart = wa_ekpo-mtart.
      wa_taxcon-land1 = wa_ekko-lands.
      "**************************START OF FUNCTION CALCULATE TAX
      "ITEM****************************
ENDIF.
      IF wa_taxcon-mwskz IS NOT INITIAL .
        CALL FUNCTION 'CALCULATE_TAX_ITEM'   "This is tHe Function Module
          EXPORTING
            dialog              = 'DIAKZ'
            display_only        = 'X'
            i_taxcom            = wa_taxcon
          TABLES
            t_xkomv             = it_xkomv
          EXCEPTIONS
            mwskz_not_defined   = 1
            mwskz_not_found     = 2
            mwskz_not_valid     = 3
            steuerbetrag_falsch = 4
            country_not_found   = 5
            OTHERS              = 6.


      ENDIF.


      READ TABLE it_xkomv WITH KEY kschl = 'JICG'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
        cgst = cgst + it_xkomv-kwert.
        kb_cgst = it_xkomv-kbetr / 10.
*    cgst = cgst + ( wa_taxcon-wrbtr * kb_cgst / 100 ).
        cgst = wa_taxcon-wrbtr * kb_cgst / 100 .

      ENDIF.

      READ TABLE it_xkomv WITH KEY kschl = 'JICN'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
        cgst = cgst + it_xkomv-kwert.
        kb_cgst = it_xkomv-kbetr / 10.
*    cgst = cgst + ( wa_taxcon-wrbtr * kb_cgst / 100 ).
        cgst = wa_taxcon-wrbtr * kb_cgst / 100 .
      ENDIF.
      READ TABLE it_xkomv WITH KEY kschl = 'JICR'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
        gv_del_tax = gv_del_tax + it_xkomv-kwert.

        text = 'YES'.
      ENDIF.
      READ TABLE it_xkomv WITH KEY kschl = 'ZCRN'. " AND
      IF sy-subrc IS INITIAL.
        text = 'YES'.
        it_xkomv-kposn = wa_ekpo-ebelp.
        gv_del_tax = gv_del_tax + it_xkomv-kwert.


      ENDIF.

      READ TABLE it_xkomv WITH KEY kschl = 'JISG'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
*    sgst = sgst + it_xkomv-kwert.
        kb_sgst = it_xkomv-kbetr / 10.
*    sgst = sgst + ( wa_taxcon-wrbtr * kb_sgst / 100 ).
        sgst = wa_taxcon-wrbtr * kb_sgst / 100 .
      ENDIF.

      READ TABLE it_xkomv WITH KEY kschl = 'JISN'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
*    sgst = sgst + it_xkomv-kwert.
        kb_sgst = it_xkomv-kbetr / 10.
*    sgst = sgst + ( wa_taxcon-wrbtr * kb_sgst / 100 ).
        sgst = wa_taxcon-wrbtr * kb_sgst / 100 .
      ENDIF.
      READ TABLE it_xkomv WITH KEY kschl = 'JISR'. " AND
      IF sy-subrc IS INITIAL.
        text = 'YES'.
        it_xkomv-kposn = wa_ekpo-ebelp.
        gv_del_tax = gv_del_tax + it_xkomv-kwert.

      ENDIF.
      READ TABLE it_xkomv WITH KEY kschl = 'ZSRN'. " AND
      IF sy-subrc IS INITIAL.
        text = 'YES'.
        it_xkomv-kposn = wa_ekpo-ebelp.
        gv_del_tax = gv_del_tax + it_xkomv-kwert.

      ENDIF.
      READ TABLE it_xkomv WITH KEY kschl = 'JIIG'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
*    igst = igst + it_xkomv-kwert.
        kb_igst = it_xkomv-kbetr / 10.
*    igst = igst + ( wa_taxcon-wrbtr * kb_igst / 100 ).
        igst = wa_taxcon-wrbtr * kb_igst / 100 .
      ENDIF.
      READ TABLE it_xkomv WITH KEY kschl = 'JIIN'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
*    igst = igst + it_xkomv-kwert.
        kb_igst = it_xkomv-kbetr / 10.
*    igst = igst + ( wa_taxcon-wrbtr * kb_igst / 100 ).
        igst = wa_taxcon-wrbtr * kb_igst / 100.
      ENDIF.
      READ TABLE it_xkomv WITH KEY kschl = 'ZIRN'. " AND
      IF sy-subrc IS INITIAL.
        text = 'YES'.
        it_xkomv-kposn = wa_ekpo-ebelp.
        gv_del_tax = gv_del_tax + it_xkomv-kwert.

      ENDIF.
*ENDLOOP.

      tot_tax = igst + cgst + sgst + gv_del_tax.


      wa_final-tot_value = wa_taxcon-wrbtr + tot_tax .
      wa_final-gross = wa_final-gross + wa_final-tot_value.
      CLEAR: cgst,sgst,igst,tot_tax,kb_igst,kb_cgst,kb_sgst,wa_taxcon-wrbtr,wa_final-tot_value,gv_del_tax.
    ENDLOOP.
    endloop.
*  ENDIF.
****
    DATA: num     TYPE  prcd_elements-kwert,
          lv_char TYPE string.

    lv_char = wa_final-bktxt.
    REPLACE ALL OCCURRENCES OF ',' IN lv_char WITH ''.
    CONDENSE lv_char.
    MOVE lv_char TO num.

    wa_final-inv = num.
    wa_final-cal_val = wa_final-gross - wa_final-inv.
    APPEND wa_final TO it_final.
    CLEAR num.
    CLEAR :wa_final-gross,wa_final-ind.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



ENDFORM.

FORM get_fcat .
  PERFORM fcat USING :
                       '1'  'MBLNR'   'IT_FINAL'  'GRN No'          '18',
                       '2'  'XBLNR'   'IT_FINAL'  'Invoice No'         '12',
                       '3'  'BLDAT'   'IT_FINAL'  'Document Date'   '12',
                       '4'  'GROSS'   'IT_FINAL'  'PO Value'              '12',
                       '5'  'INV'   'IT_FINAL'  'Invoice Value'        '22',
                       '6'  'CAL_VAL'   'IT_FINAL'  'Price Variance'           '20',
                       '7'  'IND'   'IT_FINAL'  'Cancel Doc.'           '20'.
*                     '8'  'BUDAT'   'IT_FINAL'  'Date'               '12',
*                     '9' 'MENGE'   'IT_FINAL'  'QTY'                '13',
*                     '11' 'TOT_QTY'   'IT_FINAL'  'TOT_QTY'             '13',
*                     '10' 'MEINS'   'IT_FINAL'  'Unit'               '6'.
*                     '11' 'LGORT'   'IT_FINAL'  'Stor.loc'           '10'.
ENDFORM.

FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
ENDFORM.
