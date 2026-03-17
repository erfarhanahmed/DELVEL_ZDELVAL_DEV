*&---------------------------------------------------------------------*
*& Report ZGRN_POST_CALCULATION_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgrn_post_calculation_new.

TYPE-POOLS:slis.
TABLES:mseg,mkpf.

TYPES : BEGIN OF ty_mseg,
          mblnr      TYPE mseg-mblnr,
          ebeln      TYPE mseg-ebeln,
          bwart      TYPE mseg-bwart,
          werks      TYPE mseg-werks,
          dmbtr      TYPE mseg-dmbtr,
          budat_mkpf TYPE mseg-budat_mkpf,
          lfbnr      TYPE mseg-lfbnr,
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
          bukrs TYPE ekko-bukrs,
          bsart TYPE ekko-bsart,
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
          netwr TYPE ekpo-netwr,
          mwskz TYPE ekpo-mwskz,
          mtart TYPE ekpo-mtart,
          weunb TYPE ekpo-weunb,
        END OF ty_ekpo,

        BEGIN OF ty_bseg,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          buzei TYPE bseg-buzei,
          shkzg TYPE bseg-shkzg,
          dmbtr TYPE bseg-dmbtr,
          wrbtr TYPE bseg-wrbtr,
          xopvw TYPE bseg-xopvw,
          ebeln TYPE bseg-ebeln,
          ebelp TYPE bseg-ebelp,
        END OF ty_bseg,

        BEGIN OF ty_bkpf,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          awkey TYPE bkpf-awkey,
        END OF ty_bkpf,

        BEGIN OF ty_konv,
          knumv TYPE  prcd_elements-knumv,
          kposn TYPE  prcd_elements-kposn,
          stunr TYPE  prcd_elements-stunr,
          zaehk TYPE  prcd_elements-zaehk,
          kschl TYPE  prcd_elements-kschl,
          kbetr TYPE  prcd_elements-kbetr,
          kntyp TYPE  prcd_elements-kntyp,
        END OF ty_konv,

        BEGIN OF ty_t161t,
          spras TYPE t161t-spras,
          bsart TYPE t161t-bsart,
          bstyp TYPE t161t-bstyp,
          batxt TYPE t161t-batxt,
        END OF ty_t161t,

        BEGIN OF ty_rseg,
          belnr TYPE rseg-belnr,
          gjahr TYPE rseg-gjahr,
          buzei TYPE rseg-buzei,
          ebeln TYPE rseg-ebeln,
          menge TYPE rseg-menge,
          lfbnr TYPE rseg-lfbnr,
        END OF ty_rseg,

        BEGIN OF ty_with_item,
          bukrs     TYPE with_item-bukrs,
          belnr     TYPE with_item-belnr,
          gjahr     TYPE with_item-gjahr,
          buzei     TYPE with_item-buzei,
          witht     TYPE with_item-witht,
          wt_withcd TYPE with_item-wt_withcd,
          wt_qbshh  TYPE with_item-wt_qbshh,
        END OF ty_with_item,

        BEGIN OF ty_final,
          mblnr         TYPE mseg-mblnr,
          ebeln         TYPE mseg-ebeln,
          bwart         TYPE mseg-bwart,
          xblnr         TYPE mkpf-xblnr,
          bldat         TYPE mkpf-bldat,
          budat         TYPE mkpf-budat,
          bktxt         TYPE mkpf-bktxt,
          mjahr         TYPE mkpf-mjahr,
          knumv         TYPE ekko-knumv,
          kschl         TYPE  prcd_elements-kschl,
          kbetr         TYPE  prcd_elements-kbetr,
          tot_value     TYPE  prcd_elements-kbetr,
          gross         TYPE  prcd_elements-kbetr,
          cal_val       TYPE  prcd_elements-kwert,
          inv           TYPE  prcd_elements-kwert,
          mblnr1        TYPE bkpf-awkey,
          ind           TYPE char10,
          bsart         TYPE ekko-bsart,
          waers         TYPE ekko-waers,
          weunb         TYPE ekpo-weunb,
          migo_fi_docno TYPE bkpf-belnr,
          miro_lc       TYPE bseg-wrbtr,
          batxt         TYPE t161t-batxt,
          ebelp         TYPE ekpo-ebelp,
          miro_docno    TYPE rseg-belnr,
          miro_fi_docno TYPE bkpf-belnr,
          tds_val       TYPE char20,
          tot_miro_val  TYPE bseg-dmbtr,
          diff_val      TYPE  prcd_elements-kbetr,
        END OF ty_final.

DATA: gv_mblnr TYPE bkpf-awkey,
      lv_awkey TYPE bkpf-awkey.

DATA: it_mseg      TYPE TABLE OF ty_mseg,
      wa_mseg      TYPE          ty_mseg,

      it_mseg1     TYPE TABLE OF ty_mseg,
      wa_mseg1     TYPE          ty_mseg,

      it_mkpf      TYPE TABLE OF ty_mkpf,
      wa_mkpf      TYPE          ty_mkpf,

      it_ekko      TYPE TABLE OF ty_ekko,
      wa_ekko      TYPE          ty_ekko,

      it_ekpo      TYPE TABLE OF ty_ekpo,
      wa_ekpo      TYPE          ty_ekpo,

      it_konv      TYPE TABLE OF ty_konv,
      wa_konv      TYPE          ty_konv,

      it_bkpf      TYPE TABLE OF ty_bkpf,
      wa_bkpf      TYPE          ty_bkpf,

      it_bkpf_new  TYPE TABLE OF ty_bkpf,
      wa_bkpf_new  TYPE          ty_bkpf,

      it_bkpf_new1 TYPE TABLE OF ty_bkpf,
      wa_bkpf_new1 TYPE          ty_bkpf,

      it_bseg      TYPE TABLE OF ty_bseg,
      wa_bseg      TYPE          ty_bseg,

      it_bseg_new  TYPE TABLE OF ty_bseg,
      wa_bseg_new  TYPE          ty_bseg,

      it_t161t     TYPE TABLE OF ty_t161t,
      wa_t161t     TYPE          ty_t161t,

      it_rseg      TYPE TABLE OF ty_rseg,
      wa_rseg      TYPE          ty_rseg,

      it_with_item TYPE TABLE OF ty_with_item,
      wa_with_item TYPE          ty_with_item,

      it_final     TYPE TABLE OF ty_final,
      wa_final     TYPE          ty_final.

DATA: it_taxcom TYPE TABLE OF taxcom,
      wa_taxcom TYPE          taxcom,

      it_taxcon TYPE TABLE OF taxcom,
      wa_taxcon TYPE          taxcom.

DATA: num     TYPE  prcd_elements-kwert,
      lv_char TYPE string.

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
         lfbnr
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
           bukrs
           bsart
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
           lfbnr
           smbln
           FROM mseg INTO TABLE it_mseg1
           FOR ALL ENTRIES IN it_mkpf
           WHERE smbln = it_mkpf-mblnr
           AND bwart = '102'.
  ENDIF.

  IF it_ekko IS NOT INITIAL.
    SELECT ebeln
           ebelp
           bukrs
           netwr
           mwskz
           mtart
           weunb
           FROM ekpo
           INTO TABLE it_ekpo
           FOR ALL ENTRIES IN it_ekko
           WHERE ebeln = it_ekko-ebeln.
  ENDIF.

  IF it_ekko IS NOT INITIAL.
    SELECT knumv
           kposn
           stunr
           zaehk
           kschl
           kbetr
           kntyp
           FROM  prcd_elements
           INTO TABLE it_konv
           FOR ALL ENTRIES IN it_ekko
           WHERE knumv = it_ekko-knumv
           AND   kschl = 'JEXS'.

    SELECT spras
           bsart
           bstyp
           batxt
           FROM t161t
           INTO TABLE it_t161t
           FOR ALL ENTRIES IN it_ekko
           WHERE bsart = it_ekko-bsart
           AND   bstyp = 'F'
           AND   spras = 'E'.
  ENDIF.

  IF it_mseg[] IS NOT INITIAL.
    SELECT belnr
           gjahr
           buzei
           ebeln
           menge
           lfbnr
           FROM rseg
           INTO TABLE it_rseg
           FOR ALL ENTRIES IN it_mseg
           WHERE lfbnr = it_mseg-lfbnr.
  ENDIF.

  LOOP AT it_mkpf INTO wa_mkpf.

    wa_final-mblnr = wa_mkpf-mblnr.
    wa_final-xblnr = wa_mkpf-xblnr.
    wa_final-bktxt = wa_mkpf-bktxt.
    wa_final-bldat = wa_mkpf-bldat.
    wa_final-mjahr = wa_mkpf-mjahr.

    READ TABLE it_mseg INTO wa_mseg WITH KEY mblnr = wa_mkpf-mblnr.
    IF sy-subrc = 0.
    wa_final-ebeln = wa_mseg-ebeln.
    ENDIF.

    READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_mseg-ebeln.
    IF sy-subrc = 0.
    wa_final-bsart = wa_ekko-bsart.
    ENDIF.

    READ TABLE it_t161t INTO wa_t161t WITH KEY bsart = wa_ekko-bsart
                                               bstyp = 'F'
                                               spras = 'E'.
    IF sy-subrc = 0.
      wa_final-batxt = wa_t161t-batxt.
    ENDIF.

    READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_ekko-ebeln.
    IF sy-subrc = 0.
    wa_final-ebelp = wa_ekpo-ebelp.
    wa_final-weunb = wa_ekpo-weunb.
    ENDIF.

    READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_ekko-knumv
                                             kschl = 'JEXS'.
    IF sy-subrc = 0.
      wa_final-kbetr = wa_konv-kbetr.
    ENDIF.

    READ TABLE it_rseg INTO wa_rseg WITH KEY lfbnr = wa_mseg-lfbnr.
    IF sy-subrc = 0.
      wa_final-miro_docno = wa_rseg-belnr.
    ENDIF.

    CONCATENATE wa_final-miro_docno wa_rseg-gjahr INTO lv_awkey.
    SELECT belnr
           gjahr
           awkey
           FROM bkpf
           INTO TABLE it_bkpf_new1
           WHERE awkey = lv_awkey.

    READ TABLE it_bkpf_new1 INTO wa_bkpf_new1 WITH KEY awkey = lv_awkey.
    IF sy-subrc = 0.
      wa_final-miro_fi_docno = wa_bkpf_new1-belnr.
    ENDIF.

    CONCATENATE wa_final-mblnr wa_final-mjahr INTO gv_mblnr.
    wa_final-mblnr1 = gv_mblnr.

    SELECT belnr
           gjahr
           awkey
           FROM bkpf
           INTO TABLE it_bkpf
           WHERE awkey = gv_mblnr.

    IF it_bkpf IS NOT INITIAL.
      SELECT bukrs
             belnr
             gjahr
             buzei
             shkzg
             dmbtr
             wrbtr
             xopvw
             ebeln
             ebelp
             FROM bseg INTO TABLE it_bseg
             FOR ALL ENTRIES IN it_bkpf
             WHERE belnr = it_bkpf-belnr
             AND xopvw = 'X'.
    ENDIF.

*-------------------------------------------------------------------*

    SELECT belnr
           gjahr
           awkey
           FROM bkpf
           INTO TABLE it_bkpf_new
           WHERE awkey = gv_mblnr.

    READ TABLE it_bkpf_new INTO wa_bkpf_new WITH KEY awkey = gv_mblnr.
    IF sy-subrc = 0.
      wa_final-migo_fi_docno = wa_bkpf_new-belnr.
    ENDIF.

    SELECT bukrs
           belnr
           gjahr
           buzei
           shkzg
           dmbtr
           wrbtr
           xopvw
           ebeln
           ebelp
           FROM bseg
           INTO TABLE it_bseg_new
           WHERE belnr = wa_bkpf_new1-belnr
           AND   gjahr = wa_bkpf_new1-gjahr
           AND   shkzg = 'H'.

    READ TABLE it_bseg_new INTO wa_bseg_new WITH KEY belnr = wa_bkpf_new1-belnr
                                                     gjahr = wa_bkpf_new1-gjahr
                                                     shkzg = 'H'.
    IF sy-subrc = 0.
      wa_final-miro_lc = wa_bseg_new-wrbtr.
    ENDIF.

    SELECT bukrs
           belnr
           gjahr
           buzei
           witht
           wt_withcd
           wt_qbshh
           FROM with_item
           INTO TABLE it_with_item
           WHERE belnr = wa_bkpf_new1-belnr
           AND   gjahr = wa_bkpf_new1-gjahr.

    READ TABLE it_with_item INTO wa_with_item WITH KEY belnr = wa_bkpf_new1-belnr.
    IF sy-subrc = 0.
      wa_final-tds_val = wa_with_item-wt_qbshh.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '-' IN wa_final-tds_val WITH space.

    READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY smbln = wa_final-mblnr.
    IF sy-subrc = 0.
      wa_final-ind = 'X'.
    ENDIF.

    IF wa_ekpo-weunb = 'X'.

      wa_taxcon-bukrs = wa_ekpo-bukrs.
      wa_taxcon-budat = wa_ekko-aedat.
      wa_taxcon-bldat = wa_ekko-bedat.
      wa_taxcon-waers = wa_ekko-waers.
      wa_taxcon-hwaer = wa_ekko-waers.
      wa_taxcon-kposn = wa_ekpo-ebelp.
      wa_taxcon-mwskz = 'A2'."wa_ekpo-mwskz.
      lv_netwr        = wa_ekpo-netwr.

      wa_taxcon-wrbtr = lv_netwr.

      wa_taxcon-xmwst = 'X'.
      wa_taxcom-shkzg = 'H'.

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
        cgst = wa_taxcon-wrbtr * kb_cgst / 100 .
      ENDIF.

      READ TABLE it_xkomv WITH KEY kschl = 'JICN'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
        cgst = cgst + it_xkomv-kwert.
        kb_cgst = it_xkomv-kbetr / 10.
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
        kb_sgst = it_xkomv-kbetr / 10.
        sgst = wa_taxcon-wrbtr * kb_sgst / 100 .
      ENDIF.

      READ TABLE it_xkomv WITH KEY kschl = 'JISN'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
        kb_sgst = it_xkomv-kbetr / 10.
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
        kb_igst = it_xkomv-kbetr / 10.
        igst = wa_taxcon-wrbtr * kb_igst / 100 .
      ENDIF.

      READ TABLE it_xkomv WITH KEY kschl = 'JIIN'. " AND
      IF sy-subrc IS INITIAL.
        it_xkomv-kposn = wa_ekpo-ebelp.
        kb_igst = it_xkomv-kbetr / 10.
        igst = wa_taxcon-wrbtr * kb_igst / 100.
      ENDIF.

      READ TABLE it_xkomv WITH KEY kschl = 'ZIRN'. " AND
      IF sy-subrc IS INITIAL.
        text = 'YES'.
        it_xkomv-kposn = wa_ekpo-ebelp.
        gv_del_tax = gv_del_tax + it_xkomv-kwert.
      ENDIF.

      tot_tax = igst + cgst + sgst + gv_del_tax.

      wa_final-tot_value = wa_taxcon-wrbtr + tot_tax .
      wa_final-gross = wa_final-gross + wa_final-tot_value + wa_final-kbetr.

      CLEAR: cgst,sgst,igst,tot_tax,kb_igst,kb_cgst,kb_sgst,wa_taxcon-wrbtr,wa_final-tot_value,gv_del_tax.

*    ENDIF.
ELSE.
    LOOP AT it_bkpf INTO wa_bkpf WHERE awkey = wa_final-mblnr1.

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
          wa_taxcom-shkzg = 'H'.

          wa_taxcon-lifnr = wa_ekko-lifnr.
          wa_taxcon-ekorg = wa_ekko-ekorg.
          wa_taxcon-ebeln = wa_ekpo-ebeln.
          wa_taxcon-ebelp = wa_ekpo-ebelp.
          wa_taxcon-mtart = wa_ekpo-mtart.
          wa_taxcon-land1 = wa_ekko-lands.
        ENDIF.

        IF wa_taxcon-mwskz IS NOT INITIAL .
          CALL FUNCTION 'CALCULATE_TAX_ITEM'
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
          cgst = wa_taxcon-wrbtr * kb_cgst / 100 .
        ENDIF.

        READ TABLE it_xkomv WITH KEY kschl = 'JICN'. " AND
        IF sy-subrc IS INITIAL.
          it_xkomv-kposn = wa_ekpo-ebelp.
          cgst = cgst + it_xkomv-kwert.
          kb_cgst = it_xkomv-kbetr / 10.
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
          kb_sgst = it_xkomv-kbetr / 10.
          sgst = wa_taxcon-wrbtr * kb_sgst / 100 .
        ENDIF.

        READ TABLE it_xkomv WITH KEY kschl = 'JISN'. " AND
        IF sy-subrc IS INITIAL.
          it_xkomv-kposn = wa_ekpo-ebelp.
          kb_sgst = it_xkomv-kbetr / 10.
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
          kb_igst = it_xkomv-kbetr / 10.
          igst = wa_taxcon-wrbtr * kb_igst / 100 .
        ENDIF.

        READ TABLE it_xkomv WITH KEY kschl = 'JIIN'. " AND
        IF sy-subrc IS INITIAL.
          it_xkomv-kposn = wa_ekpo-ebelp.
          kb_igst = it_xkomv-kbetr / 10.
          igst = wa_taxcon-wrbtr * kb_igst / 100.
        ENDIF.

        READ TABLE it_xkomv WITH KEY kschl = 'ZIRN'. " AND
        IF sy-subrc IS INITIAL.
          text = 'YES'.
          it_xkomv-kposn = wa_ekpo-ebelp.
          gv_del_tax = gv_del_tax + it_xkomv-kwert.
        ENDIF.

        tot_tax = igst + cgst + sgst + gv_del_tax.

        wa_final-tot_value = wa_taxcon-wrbtr + tot_tax .
        wa_final-gross = wa_final-gross + wa_final-tot_value.

        CLEAR: cgst,sgst,igst,tot_tax,kb_igst,kb_cgst,kb_sgst,wa_taxcon-wrbtr,wa_final-tot_value,gv_del_tax.

      ENDLOOP.
    ENDLOOP.

ENDIF.

    lv_char = wa_final-bktxt.
    REPLACE ALL OCCURRENCES OF ',' IN lv_char WITH ''.
    CONDENSE lv_char.
    MOVE lv_char TO num.

    wa_final-inv = num.
    wa_final-cal_val = wa_final-gross - wa_final-inv.

    wa_final-tot_miro_val = wa_final-tds_val + wa_final-miro_lc.
    wa_final-diff_val     = wa_final-gross - wa_final-tot_miro_val.

    APPEND wa_final TO it_final.

    CLEAR : wa_mkpf, wa_mseg, wa_ekko, wa_t161t, wa_ekpo, wa_konv, wa_rseg, wa_bkpf_new, wa_bkpf_new1,
            wa_bseg_new, wa_with_item, wa_mseg1, wa_bkpf, wa_bseg, wa_final.

*    CLEAR : num,wa_final, wa_mseg, wa_rseg, wa_mkpf, wa_bkpf_new.
    CLEAR : lv_awkey,gv_mblnr.

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
                       '1'  'MBLNR'            'IT_FINAL'  'GRN No'                        '20',
                       '2'  'XBLNR'            'IT_FINAL'  'Invoice No'                    '20',
                       '3'  'BLDAT'            'IT_FINAL'  'Document Date'                 '20',
                       '4'  'GROSS'            'IT_FINAL'  'PO Value'                      '20',
                       '5'  'INV'              'IT_FINAL'  'Invoice Value'                 '20',
                       '6'  'CAL_VAL'          'IT_FINAL'  'Price Variance'                '20',
                       '7'  'IND'              'IT_FINAL'  'Cancel Doc.'                   '20',
                       '8'  'MIRO_LC'          'IT_FINAL'  'Invoice(Miro) Value LC'        '20',
                       '9'  'WAERS'            'IT_FINAL'  'Documnet Currency'             '20',
                       '10' 'BSART'            'IT_FINAL'  'PO Document Type'              '20',
                       '11' 'MIGO_FI_DOCNO'    'IT_FINAL'  'MIGO FI Document No'           '20',
                       '12' 'BATXT'            'IT_FINAL'  'PO Type Description'           '20',
                       '13' 'MIRO_DOCNO'       'IT_FINAL'  'MIRO Document No'              '20',
                       '14' 'MIRO_FI_DOCNO'    'IT_FINAL'  'MIRO FI Document No'           '20',
                       '15' 'TDS_VAL'          'IT_FINAL'  'TDS Value in MIRO'             '20',
                       '16' 'TOT_MIRO_VAL'     'IT_FINAL'  'Total MIRO value LC'           '20',
                       '17' 'DIFF_VAL'         'IT_FINAL'  'Diff PO and total MIRO Value'  '20'.
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
