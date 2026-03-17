*&---------------------------------------------------------------------*
*& Report ZGSTR_SUBCON_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgstr_subcon_report.


TABLES:j_1ig_subcon.
TYPES: BEGIN OF ty_mseg,
         mblnr TYPE mseg-mblnr,
         bwart TYPE mseg-bwart,
         lifnr TYPE mseg-lifnr,
         matnr TYPE mseg-matnr,
         ebeln TYPE mseg-ebeln,
       END OF ty_mseg,

       BEGIN OF ty_j_1ig_subcon,
         mblnr    TYPE j_1ig_subcon-mblnr,
         chln_inv TYPE j_1ig_subcon-chln_inv,
         item     TYPE j_1ig_subcon-item,
         matnr    TYPE j_1ig_subcon-matnr,
         bwart    TYPE j_1ig_subcon-bwart,
         lifnr    TYPE j_1ig_subcon-lifnr,
         ch_qty   TYPE j_1ig_subcon-ch_qty,
         budat    TYPE j_1ig_subcon-budat,
         menge    TYPE j_1ig_subcon-menge,
         erdat    TYPE j_1ig_subcon-erdat,
       END OF ty_j_1ig_subcon,

       BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         meins TYPE mara-meins,
       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_lfa1,
         lifnr_s TYPE lfa1-lifnr,
         name1_s TYPE lfa1-name1,             " add subodh 19 feb 2018
         stcd3 TYPE lfa1-stcd3,
         adrnr TYPE lfa1-adrnr,
         regio TYPE lfa1-regio,
       END OF ty_lfa1,

       BEGIN OF ty_vbrp,
         vbeln TYPE vbrp-vbeln,
         posnr TYPE vbrp-posnr,
         mwsbp TYPE vbrp-mwsbp,
         netwr TYPE vbrp-netwr,
         fkimg TYPE vbrp-fkimg,
       END OF ty_vbrp,

       BEGIN OF ty_vbrk,
         vbeln TYPE vbrk-vbeln,
         knumv TYPE vbrk-knumv,
       END OF ty_vbrk,

       BEGIN OF ty_konv,
         knumv TYPE  prcd_elements-knumv,
         kposn TYPE  prcd_elements-kposn,
         kschl TYPE  prcd_elements-kschl,
         kbetr TYPE  prcd_elements-kbetr,
         kawrt TYPE  prcd_elements-kawrt,
         kwert TYPE  prcd_elements-kwert,
       END OF ty_konv,

       BEGIN OF ty_zgst_region,
         region     TYPE zgst_region-region,
         gst_region TYPE zgst_region-gst_region,
       END OF ty_zgst_region,

        BEGIN OF ty_mkpf,                              "add subodh 19 feb 2018
           mblnr TYPE mkpf-mblnr,
           mjahr TYPE mkpf-mjahr,
           bldat TYPE mkpf-bldat,
           xblnr TYPE mkpf-xblnr,
         END OF ty_mkpf,


       BEGIN OF ty_final,
         mblnr      TYPE mseg-mblnr,
         bwart      TYPE mseg-bwart,
         lifnr      TYPE mseg-lifnr,
         matnr      TYPE mseg-matnr,
         ebeln      TYPE mseg-ebeln,                    " Pass
         chln_inv   TYPE j_1ig_subcon-chln_inv,
*         bwart    TYPE j_1ig_subcon-bwart,
         ch_qty     TYPE j_1ig_subcon-ch_qty,
         budat      TYPE j_1ig_subcon-budat,
         menge      TYPE j_1ig_subcon-menge,
         erdat      TYPE j_1ig_subcon-erdat,
         mtart      TYPE mara-mtart,
         meins      TYPE mara-meins,
         maktx      TYPE makt-maktx,
         lifnr_s      TYPE lfa1-lifnr,                  " add subodh 19 feb 2018
         name1_s      TYPE lfa1-name1,                  "add subodh 19 feb 2018
         stcd3      TYPE lfa1-stcd3,
         adrnr      TYPE lfa1-adrnr,
         regio      TYPE lfa1-regio,
         mwsbp      TYPE vbrp-mwsbp,
         netwr      TYPE vbrp-netwr,
         knumv      TYPE  prcd_elements-knumv,
         kposn      TYPE  prcd_elements-kposn,
         kschl      TYPE  prcd_elements-kschl,
         kbetr      TYPE  prcd_elements-kbetr,
         kawrt      TYPE  prcd_elements-kawrt,
         kwert      TYPE  prcd_elements-kwert,
         cgst       TYPE  prcd_elements-kwert,        "CGST
         sgst       TYPE  prcd_elements-kwert,        "SGST
         igst       TYPE  prcd_elements-kwert,        "JOIG
         cess       TYPE  prcd_elements-kwert,        "JOIG
         gst_region TYPE zgst_region-gst_region,
         blank      TYPE char100,
         net_price  TYPE vbrp-netwr,    " 541 543 quantity price
         price      TYPE vbrp-netwr,    "single quantity price
*        mblnr      TYPE mkpf-mblnr,
         mjahr      TYPE mkpf-mjahr,
         bldat      TYPE mkpf-bldat,
         xblnr      TYPE mkpf-xblnr,

       END OF ty_final.

TYPEs : BEGIN OF ITAB,
          mblnr       TYPE    CHAR15,
          bwart       TYPE    CHAR10,
          lifnr       TYPE    CHAR10,
          matnr       TYPE    CHAR10,
          ebeln       TYPE    CHAR15,               " pass
          chln_inv    TYPE    CHAR50,
          ch_qty      TYPE    CHAR50,
          budat       TYPE    CHAR15,
          menge       TYPE    CHAR50,
          erdat       TYPE    CHAR50,
          mtart       TYPE    CHAR50,
          meins       TYPE    CHAR70,
          maktx       TYPE    CHAR15,
          lifnr_s     TYPE    CHAR10,                     " add Subodh 19 Feb 2018
          name1_s     TYPE    CHAR35,                     " add subodh 19 feb 2018
          stcd3       TYPE    CHAR50,
          adrnr       TYPE    CHAR15,
          regio       TYPE    CHAR50,
          mwsbp       TYPE    CHAR10,
          netwr       TYPE    CHAR10,
          knumv       TYPE    CHAR20,
          kposn       TYPE    CHAR15,
          kschl       TYPE    CHAR5,
          kbetr       TYPE    CHAR50,
          kawrt       TYPE    CHAR50,
          kwert       TYPE    CHAR250,
          cgst        TYPE    CHAR10,
          sgst        TYPE    CHAR15,
          igst        TYPE    CHAR15,
          cess        TYPE    CHAR5,
          gst_region  TYPE    CHAR50,
          blank       TYPE    CHAR50,
          net_price   TYPE    CHAR250,
          price       TYPE    CHAR10,
          bldat       TYPE    CHAR8,              " add subodh 19 feb 2018
         xblnr        TYPE    CHAR16,              " add subodh 19 feb 2018
           REF        TYPE    CHAR15,
      END OF ITAB.

DATA : LT_ITAB TYPE TABLE OF ITAB,
       LS_ITAB TYPE ITAB.

DATA: it_mara         TYPE TABLE OF ty_mara,
      wa_mara         TYPE          ty_mara,

      it_makt         TYPE TABLE OF ty_makt,
      wa_makt         TYPE          ty_makt,

      it_mseg         TYPE TABLE OF ty_mseg,
      wa_mseg         TYPE          ty_mseg,

      it_lfa1         TYPE TABLE OF ty_lfa1,
      wa_lfa1         TYPE          ty_lfa1,

      it_vbrp         TYPE TABLE OF ty_vbrp,
      wa_vbrp         TYPE          ty_vbrp,

      it_vbrk         TYPE TABLE OF ty_vbrk,
      wa_vbrk         TYPE          ty_vbrk,

      it_konv         TYPE TABLE OF ty_konv,
      wa_konv         TYPE          ty_konv,

      it_j_1ig_subcon TYPE TABLE OF ty_j_1ig_subcon,
      wa_j_1ig_subcon TYPE          ty_j_1ig_subcon,

      it_challan      TYPE TABLE OF ty_j_1ig_subcon,   "mov. typ 541
      wa_challan      TYPE          ty_j_1ig_subcon,

      it_zgst_region  TYPE TABLE OF ty_zgst_region,
      wa_zgst_region  TYPE          ty_zgst_region,

      it_mkpf TYPE TABLE OF ty_mkpf,                     " add subodh 19 feb 2018
      wa_mkpf TYPE          ty_mkpf,

      it_final        TYPE TABLE OF ty_final,
      wa_final        TYPE          ty_final.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : ls_layout TYPE slis_layout_alv.


SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_lifnr FOR j_1ig_subcon-lifnr,
                s_chln  FOR j_1ig_subcon-chln_inv,
                s_erdat FOR j_1ig_subcon-erdat.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS part1  RADIOBUTTON GROUP rg1 DEFAULT 'X' USER-COMMAND codegen.
PARAMETERS part2  RADIOBUTTON GROUP rg1.
SELECTION-SCREEN END OF BLOCK b2.
*--------------------------Added By AG DT:16.02.2018-------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B3.
*----------------------------------------------------------------------------------------

START-OF-SELECTION.
  PERFORM get_dat.
  IF part1 = 'X'.
    PERFORM get_fcat.
  ENDIF.

  IF part2 = 'X'.

    PERFORM get_fcat1.

  ENDIF.

  PERFORM get_display.

*&---------------------------------------------------------------------*
*&      Form  GET_DAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*BREAK primus.
FORM get_dat .
  IF part1 = 'X'.
    SELECT mblnr
           chln_inv
           item
           matnr
           bwart
           lifnr
           ch_qty
           budat
           menge
           erdat  FROM j_1ig_subcon INTO TABLE it_j_1ig_subcon
           WHERE chln_inv IN s_chln
           AND   lifnr    IN s_lifnr
           AND   erdat    IN s_erdat
           AND   bwart = '541'.
  ENDIF.

  IF part2 = 'X'.
    SELECT mblnr
           chln_inv
           item
           matnr
           bwart
           lifnr
           ch_qty
           budat
           menge
           erdat FROM j_1ig_subcon INTO TABLE it_j_1ig_subcon
           WHERE chln_inv IN s_chln
           AND   lifnr    IN s_lifnr
           AND   erdat    IN s_erdat
           AND   bwart IN ('542','543').

delete ADJACENT DUPLICATES FROM it_j_1ig_subcon COMPARING mblnr.

    SELECT mblnr
           chln_inv
           item
           matnr
           bwart
           lifnr
           ch_qty
           budat
           menge
           erdat FROM j_1ig_subcon INTO TABLE it_challan
           WHERE chln_inv IN s_chln
           AND   lifnr    IN s_lifnr
           AND   erdat    IN s_erdat
           AND   bwart = '541'.

  ENDIF.

  IF it_j_1ig_subcon IS NOT INITIAL.

    SELECT mblnr
           bwart
           lifnr
           matnr
           ebeln FROM mseg INTO TABLE it_mseg           " wa_mseg-ebeln
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE mblnr = it_j_1ig_subcon-mblnr.

    SELECT lifnr
           name1
           stcd3
           adrnr
           regio FROM lfa1 INTO TABLE it_lfa1            " wa_lfa1-lifnr wa_lfa1-name1
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE lifnr = it_j_1ig_subcon-lifnr.

    SELECT matnr
           mtart
           meins FROM mara INTO TABLE it_mara
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE matnr = it_j_1ig_subcon-matnr.

    SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE matnr = it_j_1ig_subcon-matnr.

    SELECT vbeln
           posnr
           mwsbp
           netwr
           fkimg FROM vbrp INTO TABLE it_vbrp
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE vbeln = it_j_1ig_subcon-chln_inv
           AND   posnr = it_j_1ig_subcon-item.

    SELECT vbeln
           knumv FROM vbrk INTO TABLE it_vbrk
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE vbeln = it_j_1ig_subcon-chln_inv.

    SELECT mblnr                                           " add subodh 19 feb 2018
           mjahr
           bldat
           xblnr
           FROM mkpf INTO TABLE it_mkpf
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE mblnr = it_j_1ig_subcon-mblnr.
  ENDIF.

  IF it_vbrk IS NOT INITIAL.
    SELECT knumv
           kposn
           kschl
           kbetr
           kawrt
           kwert FROM prcd_elements INTO TABLE it_konv
           FOR ALL ENTRIES IN it_vbrk
           WHERE knumv = it_vbrk-knumv.

  ENDIF.



  IF it_lfa1 IS NOT INITIAL.
    SELECT region
            gst_region FROM zgst_region INTO TABLE it_zgst_region
            FOR ALL ENTRIES IN it_lfa1
            WHERE region = it_lfa1-regio.

  ENDIF.

  LOOP AT it_j_1ig_subcon INTO wa_j_1ig_subcon.
    wa_final-chln_inv = wa_j_1ig_subcon-chln_inv.
    wa_final-budat    = wa_j_1ig_subcon-budat.
    wa_final-erdat    = wa_j_1ig_subcon-erdat.
    wa_final-ch_qty   = wa_j_1ig_subcon-ch_qty.
    wa_final-menge   = wa_j_1ig_subcon-menge.
    wa_final-matnr   = wa_j_1ig_subcon-matnr.


    READ TABLE it_mseg INTO wa_mseg WITH KEY mblnr = wa_j_1ig_subcon-mblnr.
    IF sy-subrc = 0.

      wa_final-ebeln = wa_mseg-ebeln.                                      " add subodh 20 feb 2018


    ENDIF.
    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr_s = wa_j_1ig_subcon-lifnr.
    IF  sy-subrc = 0.
      wa_final-lifnr_s = wa_lfa1-lifnr_s.
      wa_final-name1_s = wa_lfa1-name1_s.                       " Add Subodh 19 feb 2018
      wa_final-stcd3 = wa_lfa1-stcd3.

    ENDIF.
    READ TABLE it_zgst_region INTO wa_zgst_region WITH KEY region = wa_lfa1-regio.
    IF sy-subrc = 0.
      wa_final-gst_region = wa_zgst_region-gst_region.

    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_j_1ig_subcon-matnr.
    IF sy-subrc = 0 .
      wa_final-matnr = wa_mara-matnr.
      wa_final-mtart = wa_mara-mtart.
      wa_final-meins = wa_mara-meins.

    ENDIF.
    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_j_1ig_subcon-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktx.

    ENDIF.

    READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_j_1ig_subcon-chln_inv
                                             posnr = wa_j_1ig_subcon-item.
    IF sy-subrc = 0 .
      wa_final-mwsbp = wa_vbrp-mwsbp.
      wa_final-netwr = wa_vbrp-netwr.

    ENDIF.
    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_j_1ig_subcon-chln_inv.
    IF sy-subrc = 0.
      wa_final-knumv = wa_vbrk-knumv.
    ENDIF.

*BREAK-POINT.
    READ TABLE it_mkpf INTO wa_mkpf WITH KEY mblnr = wa_j_1ig_subcon-mblnr.                 " add subodh 18 feb 2018
    IF  sy-subrc = 0.
      wa_final-bldat = wa_mkpf-bldat.
      wa_final-xblnr = wa_mkpf-xblnr.

    ENDIF.


    LOOP AT it_konv INTO wa_konv WHERE knumv = wa_vbrk-knumv
                                 AND   kposn = wa_vbrp-posnr.
      CASE wa_konv-kschl.
        WHEN 'JOCG'.
          wa_final-cgst = wa_konv-kwert .
        WHEN 'JOSG'.
          wa_final-sgst = wa_konv-kwert .
        WHEN 'JOIG'.
          wa_final-igst = wa_konv-kwert .
      ENDCASE.
    ENDLOOP.

    READ TABLE it_challan INTO wa_challan WITH KEY chln_inv = wa_j_1ig_subcon-chln_inv. " mov. type 542 543
    IF sy-subrc = 0.
        wa_final-price = wa_final-netwr / wa_challan-menge.  " single quantity price calculation
    ENDIF.

     wa_final-net_price = wa_final-menge * wa_final-price.  "542 543 taxable value calculation
*--------------------------Added By AG DT:16.02.2018------------------------------------------------------
***********************************************Dowanload Data*********************************************
LS_ITAB-mblnr                 =   WA_FINAL-mblnr        .
LS_ITAB-bwart                 =   WA_FINAL-bwart        .
LS_ITAB-lifnr                 =   WA_FINAL-lifnr        .
LS_ITAB-matnr                 =   WA_FINAL-matnr        .
LS_ITAB-ebeln                 =   WA_FINAL-ebeln        .
LS_ITAB-chln_inv              =   WA_FINAL-chln_inv     .
LS_ITAB-ch_qty                =   WA_FINAL-ch_qty       .
LS_ITAB-budat                 =   WA_FINAL-budat        .
LS_ITAB-menge                 =   WA_FINAL-menge        .
LS_ITAB-erdat                 =   WA_FINAL-erdat        .
LS_ITAB-mtart                 =   WA_FINAL-mtart        .
LS_ITAB-meins                 =   WA_FINAL-meins        .
LS_ITAB-maktx                 =   WA_FINAL-maktx        .
LS_ITAB-lifnr_s               =   WA_FINAL-lifnr_s        .            " add subodh 19 FEB 2018
LS_ITAB-name1_s               =   WA_FINAL-name1_s        .            " Add subodh 19 feb 2018

LS_ITAB-stcd3                 =   WA_FINAL-stcd3        .
LS_ITAB-adrnr                 =   WA_FINAL-adrnr        .
LS_ITAB-regio                 =   WA_FINAL-regio        .
LS_ITAB-mwsbp                 =   WA_FINAL-mwsbp        .
LS_ITAB-netwr                 =   WA_FINAL-netwr        .
LS_ITAB-knumv                 =   WA_FINAL-knumv        .
LS_ITAB-kposn                 =   WA_FINAL-kposn        .
LS_ITAB-kschl                 =   WA_FINAL-kschl        .
LS_ITAB-kbetr                 =   WA_FINAL-kbetr        .
LS_ITAB-kawrt                 =   WA_FINAL-kawrt        .
LS_ITAB-kwert                 =   WA_FINAL-kwert        .
LS_ITAB-cgst                  =   WA_FINAL-cgst         .
LS_ITAB-sgst                  =   WA_FINAL-sgst         .
LS_ITAB-igst                  =   WA_FINAL-igst         .
LS_ITAB-cess                  =   WA_FINAL-cess         .
LS_ITAB-gst_region            =   WA_FINAL-gst_region   .
LS_ITAB-blank                 =   WA_FINAL-blank        .
LS_ITAB-net_price             =   WA_FINAL-net_price    .
LS_ITAB-price                 =   WA_FINAL-price        .
LS_ITAB-bldat                 =   WA_FINAL-bldat        .
LS_ITAB-xblnr                 =   WA_FINAL-xblnr        .


LS_ITAB-REF = SY-DATUM.
CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
  EXPORTING
    input         = LS_ITAB-REF
 IMPORTING
   OUTPUT        = LS_ITAB-REF
          .
CONCATENATE LS_ITAB-ref+0(2) LS_ITAB-ref+2(3) LS_ITAB-ref+5(4)
                INTO LS_ITAB-ref SEPARATED BY '-'.
*-----------------------------------------------------------------------------------------------------------------------


    APPEND wa_final TO it_final.
    CLEAR:wa_final,wa_final-cgst,wa_final-sgst,wa_final-igst,wa_final-price,wa_final-net_price, LS_ITAB, WA_MSEG, WA_j_1ig_subcon, WA_mara, WA_makt, WA_lfa1, WA_vbrp, WA_konv, WA_zgst_region.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .
  PERFORM fcat USING : '1'   'STCD3'           'IT_FINAL'      'GSTIN of Job Worker (JW)'                 '18' ,
                       '2'   'GST_REGION'      'IT_FINAL'      'State'                       '10',
                       '3'   'CHLN_INV'        'IT_FINAL'      'Challan No.'                  '18' ,
                       '4'   'ERDAT'           'IT_FINAL'      'Challan Date'                  '18' ,
                       '5'   'MATNR'           'IT_FINAL'      'Item Code'                     '18',
                       '6'   'MAKTX'           'IT_FINAL'      'Description'                      '25' ,
                       '7'   'MEINS'           'IT_FINAL'      'Unique Quantity Code (UQC)'                    '18' ,
                       '8'   'CH_QTY'          'IT_FINAL'      'Quantity'                       '15' ,
                       '9'   'MTART'           'IT_FINAL'      'Typ of Goods'                   '15' ,
                       '10'   'NETWR'           'IT_FINAL'      'Taxable Value'                 '15' ,
                       '11'   'SGST'            'IT_FINAL'      'SGST'                          '15',
                       '12'   'CGST'            'IT_FINAL'      'CGST'                          '15',
                       '13'   'IGST'            'IT_FINAL'      'IGST'                          '15',
                       '14'   'CESS'            'IT_FINAL'      'Cess'                          '10',
                       '15'   'EBELN'           'IT_FINAL'     'Purchase Doc. No'                                '10' ,
                       '16'   'LIFNR_S'            'IT_FINAL'   'Vendor NO.'                  '10',
                       '17'   'NAME1_S'            'IT_FINAL'   'Vendor Name'                  '35'.

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
*--------------------------Added By AG DT:16.02.2018-------------------------------------
 IF p_down = 'X'.
    PERFORM download.
  ENDIF.
*----------------------------------------------------------------------------------------

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1083   text
*      -->P_1084   text
*      -->P_1085   text
*      -->P_1086   text
*      -->P_1087   text
*----------------------------------------------------------------------*
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
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat1 .

  PERFORM fcat USING : '1'   'STCD3'           'IT_FINAL'      'GSTIN of Job Worker (JW)'                 '18' ,
                        '2'   'GST_REGION'      'IT_FINAL'     'State'                                     '10',
                       '3'   'BLANK'           'IT_FINAL'      'Nature of Transaction '                    '10',
                       '4'   'CHLN_INV'        'IT_FINAL'      'Original Challan No.'                      '18' ,
                       '5'   'ERDAT'           'IT_FINAL'      'Challan Date'                              '18' ,
                       '6'   'BLANK'           'IT_FINAL'      'JB Challan No'                             '18' ,
                       '7'   'BLANK'           'IT_FINAL'      'JB Challan Date'                           '18' ,
                       '8'   'BLANK'           'IT_FINAL'      'JB GSTIN'                                  '18' ,
                       '9'   'BLANK'           'IT_FINAL'      'JB State'                                  '18' ,
                       '10'   'BLANK'           'IT_FINAL'     'JB Inv.No.'                              '18' ,
                       '11'   'BLANK'           'IT_FINAL'     'JB Inv.Date'                             '18' ,
                       '12'   'MATNR'           'IT_FINAL'     'Item Code'                             '18' ,
                       '13'   'MAKTX'           'IT_FINAL'     'Description'                              '25' ,
                       '14'   'MEINS'           'IT_FINAL'     'Unique Quantity Code (UQC)'              '18' ,
                       '15'   'MENGE'          'IT_FINAL'      'Quantity'                                '15' ,
                       '16'   'NET_PRICE'      'IT_FINAL'      'Taxable Value'                         '15' ,
                       '17'   'BLANK'           'IT_FINAL'     'Errors'                                '15' ,
                       '18'   'BLDAT'           'IT_FINAL'     'Doc. Date'                                '08' ,
                       '19'   'XBLNR'           'IT_FINAL'     'Vendor Invoice'                                '16',
                       '20'   'EBELN'           'IT_FINAL'     'Purchase Doc. No'                                '10' ,
                       '21'   'LIFNR_S'            'IT_FINAL'  'Vendor NO.'                  '10',
                       '22'   'NAME1_S'            'IT_FINAL'  'Vendor Name'                  '35'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*--------------------------Added By AG DT:16.02.2018-------------------------------------
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
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = LT_ITAB
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
  lv_file = 'ZGSTR_SUBCON_REPORT.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
*BREAK primus.
  WRITE: / 'ZGSTR_SUBCON_REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_726 TYPE string.
DATA lv_crlf_726 TYPE string.
lv_crlf_726 = cl_abap_char_utilities=>cr_lf.
lv_string_726 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_726 lv_crlf_726 wa_csv INTO lv_string_726.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_726 TO lv_fullfile.
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
FORM cvs_header  USING    p_hd_csv.
DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
CONCATENATE 'GSTIN of Job Worker (JW)'
            'State'
            'Challan No.'
            'Challan Date'
            'Item Code'
            'Description'
            'Unique Quantity Code (UQC)'
            'Quantity'
            'Typ of Goods'
            'Taxable Value'
            'SGST'
            'CGST'
            'IGST'
            'Cess'
            'Purchase Doc. No'
            'Vendor NO.'
            'Vendor Name'
            'GSTIN of Job Worker (JW)'
            'State'
            'Nature of Transaction '
            'Original Challan No.'
            'Challan Date'
            'JB Challan No'
            'JB Challan Date'
            'JB GSTIN'
            'JB State'
            'JB Inv.No.'
            'JB Inv.Date'
            'Item Code'
            'Description'
            'Unique Quantity Code (UQC)'
            'Quantity'
            'Taxable Value'
            'Errors'
            'Doc. Date'
            'Vendor Invoice'
            'Purchase Doc. No'
            'Vendor NO.'
            'Vendor Name'                      INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
*----------------------------------------------------------------------------------------------------------------------
