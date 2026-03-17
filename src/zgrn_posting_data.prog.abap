*&---------------------------------------------------------------------*
*&  Include           ZGRN_POSTING_01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  DATA:
    lt_bseg        TYPE tt_bseg,
    lt_bseg1       TYPE tt_bseg,
    ls_bseg        TYPE t_bseg,
    lt_mat_mast    TYPE tt_mat_mast,
    ls_mat_mast    TYPE t_mat_mast,
    lt_adrc        TYPE tt_adrc,
    ls_adrc        TYPE t_adrc,
    lt_dd07t       TYPE tt_dd07t,
    ls_dd07t       TYPE t_dd07t,
    lt_zgst_region TYPE tt_zgst_region,
    ls_zgst_region TYPE t_zgst_region,
    lt_skat        TYPE tt_skat,
    ls_skat        TYPE t_skat,
    lt_marc        TYPE tt_marc,
    ls_marc        TYPE t_marc,
    lt_eket        TYPE tt_eket,
    ls_eket        TYPE t_eket,
    lt_t007s       TYPE tt_t007s,
    ls_t007s       TYPE t_t007s,
    lt_qals        TYPE tt_qals,
    ls_qals        TYPE t_qals,
    lt_qamb        TYPE tt_qamb,
    ls_qamb        TYPE t_qamb,
    lt_mseg        TYPE tt_mseg,
    ls_mseg        TYPE t_mseg,
    lt_t163y       TYPE tt_t163y,
    ls_t163y       TYPE t_t163y,
    lt_rseg        LIKE gt_rseg OCCURS 0 WITH HEADER LINE.

  DATA:wa_eine TYPE eine.

  DATA:
    lv_index TYPE sy-tabix,
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline.

  DATA:
    lv_cgst TYPE bset-hwste,
    lv_sgst TYPE bset-hwste,
    lv_igst TYPE bset-hwste.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text       = 'Reading data...'(i01)
      percentage = 1.

*Get Data from BKPF Table 'RE' Docs
*break primus.
  SELECT bukrs
         belnr
         gjahr
         blart
         bldat
         budat
         xblnr
         waers
         kursf
         awkey
         tcode
         xblnr_alt
  FROM bkpf
  INTO TABLE gt_bkpf
  WHERE "gjahr IN s_gjahr  "pj "bukrs IN s_bukrs
*    AND gjahr IN s_gjahr AND
     budat IN s_budat
    AND blart IN ('RE','RL','KG','KR','RX' , 'ZA' )
    AND bukrs = '1000'.

  SORT gt_bkpf BY belnr blart.
  LOOP AT gt_bkpf.
    gt_bkpf-g_belnr = gt_bkpf-awkey+0(10).
    gt_bkpf-g_gjahr = gt_bkpf-awkey+10(4).
    IF sy-subrc EQ 0.
      MODIFY gt_bkpf TRANSPORTING g_belnr g_gjahr.
    ENDIF.
  ENDLOOP.


*** Getting MIGO no.
  IF gt_bkpf[] IS NOT INITIAL .


    SELECT belnr
           gjahr
           lifnr
           blart
           bldat
           xrech
           stblg
           zuonr
           bktxt
           prepay_awkey" pj 30-09-21
    FROM rbkp
    INTO TABLE gt_rbkp
    FOR ALL ENTRIES IN gt_bkpf
    WHERE belnr = gt_bkpf-g_belnr
      AND gjahr = gt_bkpf-g_gjahr
      AND tcode IN ('MIRO','MIR7')
      AND rbstat = '5'
      AND lifnr IN s_lifnr. "MODIFIED BY PJ " avinash bhagat

    IF NOT gt_rbkp[] IS INITIAL.
      SELECT lifnr
             name1
             regio
             ort01
             land1
             adrnr
             stcd3
        FROM lfa1
        INTO TABLE gt_lfa1
        FOR ALL ENTRIES IN gt_rbkp
        WHERE lifnr = gt_rbkp-lifnr.
*        and lifnr in s_lifnr. " avinash bhagat

      IF gt_lfa1[] IS NOT INITIAL.
        SELECT lifnr akont
          FROM lfb1
          INTO TABLE gt_lfb1
          FOR ALL ENTRIES IN gt_lfa1
          WHERE lifnr = gt_lfa1-lifnr.
*          and lifnr in s_lifnr. "avinash bhagat
*            AND bukrs IN s_bukrs.

      ENDIF.
*break primus.
      SELECT belnr
             gjahr
             buzei
             ebeln
             ebelp
             matnr
             bukrs
             wrbtr
             menge
             meins
             shkzg
             mwskz
             bklas
             bnkan
             kschl
             lfbnr
             lfgja
             lfpos
             werks
             stunr
             exkbe
             pstyp
             xekbz
      FROM rseg
      INTO TABLE gt_rseg
      FOR ALL ENTRIES IN gt_rbkp
      WHERE belnr = gt_rbkp-belnr
        AND gjahr = gt_rbkp-gjahr
        AND lfbnr IN s_lfbnr.
      " AND werks IN s_werks "pj
      " AND ebeln IN s_ebeln. "pj
*        and lifnr in s_lifnr.   " avinash bhagat
      "and bustw = 'RE01'.        " Added to Remove Auto Parked Invoices and not Posted
    ENDIF.
  ENDIF.
*********** Changing Document Item Numbering in RSEG based on BSET ***********

  gt_rseg_v1[] = gt_rseg[].
  lt_rseg[] = gt_rseg[].
  SORT gt_rseg_v1 BY belnr gjahr.
  DELETE ADJACENT DUPLICATES FROM gt_rseg_v1 COMPARING belnr gjahr.

  SORT gt_rseg BY belnr gjahr buzei ASCENDING.
  DELETE lt_rseg WHERE lfbnr IS INITIAL.
  IF NOT lt_rseg[] IS INITIAL .
    LOOP AT lt_rseg.
      CONCATENATE lt_rseg-lfbnr lt_rseg-lfgja
             INTO lt_rseg-awkey.
      IF sy-subrc EQ 0.
        MODIFY lt_rseg TRANSPORTING awkey.
      ENDIF.
    ENDLOOP.

  ENDIF.
  DATA  : lv_buzei TYPE buzei.

  LOOP AT gt_rseg_v1.
    CLEAR : lv_buzei.
    LOOP AT gt_rseg WHERE belnr = gt_rseg_v1-belnr
                      AND gjahr = gt_rseg_v1-gjahr .
      lv_buzei      = lv_buzei + 1.
      gt_rseg-buzei = lv_buzei.
      MODIFY gt_rseg TRANSPORTING buzei.
    ENDLOOP.
  ENDLOOP.

  CLEAR : lv_buzei, gt_rseg_v1[].
*******************************************

  gt_rseg_v1[] = gt_rseg[].
  SORT gt_rseg_v1 BY belnr gjahr ebeln ebelp.
  SORT gt_rseg BY belnr gjahr ebeln ebelp.
  DELETE ADJACENT DUPLICATES FROM gt_rseg_v1 COMPARING belnr gjahr ebeln ebelp.

  DATA:
    lv_ind   TYPE sy-tabix,
    lv_menge TYPE mseg-menge.

  IF gt_rseg_v1[] IS NOT INITIAL.
    LOOP AT gt_rseg_v1.
      READ TABLE gt_rseg WITH KEY belnr = gt_rseg_v1-belnr
                                  gjahr = gt_rseg_v1-gjahr
                                  ebeln = gt_rseg_v1-ebeln
                                  ebelp = gt_rseg_v1-ebelp.

      IF sy-subrc IS INITIAL AND gt_rseg-lfbnr IS NOT INITIAL.
        lv_ind = sy-tabix.
        LOOP AT gt_rseg FROM lv_ind.
          IF gt_rseg-belnr = gt_rseg_v1-belnr AND gt_rseg-gjahr = gt_rseg_v1-gjahr AND gt_rseg-lfbnr IS NOT INITIAL
          AND gt_rseg-ebeln = gt_rseg_v1-ebeln AND gt_rseg-ebelp = gt_rseg_v1-ebelp.
            lv_menge = lv_menge + gt_rseg-menge.
          ELSE.
            EXIT.
          ENDIF.

        ENDLOOP.
        gt_rseg_v1-menge = lv_menge.
        CLEAR lv_menge.
      ENDIF.
      CONCATENATE gt_rseg_v1-lfbnr gt_rseg_v1-lfgja
             INTO gt_rseg_v1-awkey.
      IF sy-subrc EQ 0.
        MODIFY gt_rseg_v1 TRANSPORTING awkey menge.
      ENDIF.
    ENDLOOP.

    SELECT bukrs
           belnr
           gjahr
           blart
           bldat
           budat
           xblnr
           waers
           kursf
           awkey
           tcode
    FROM bkpf
    INTO TABLE gt_bkpf_we
    FOR ALL ENTRIES IN gt_rseg_v1
    WHERE awkey = gt_rseg_v1-awkey.

    IF NOT lt_rseg IS INITIAL.
      SELECT bukrs
             belnr
             gjahr
             blart
             bldat
             budat
             xblnr
             waers
             kursf
             awkey
             tcode
             xblnr_alt
      FROM bkpf
      APPENDING TABLE gt_bkpf_we
      FOR ALL ENTRIES IN lt_rseg
      WHERE awkey = lt_rseg-awkey.
    ENDIF.
    IF NOT gt_bkpf_we[] IS INITIAL.
      SELECT bukrs
             belnr
             gjahr
             buzei
             shkzg
             dmbtr
             ktosl
             anln1
             anln2
             hkont
             ebeln
             ebelp
        FROM bseg
        INTO TABLE lt_bseg
        FOR ALL ENTRIES IN gt_bkpf_we
        WHERE bukrs = gt_bkpf_we-bukrs
        AND   belnr = gt_bkpf_we-belnr
        AND   gjahr = gt_bkpf_we-gjahr.
    ENDIF.
  ENDIF.


********** Processing SERVICE ENTRY SHEETS

  gt_rseg_ses[] = gt_rseg[].
  SORT gt_rseg_ses BY pstyp.
  DELETE gt_rseg_ses WHERE pstyp NE '9'.
  SORT gt_rseg_ses BY belnr gjahr lfbnr lfgja ebeln ebelp.
  DELETE ADJACENT DUPLICATES FROM gt_rseg_ses COMPARING belnr gjahr lfbnr lfgja ebeln ebelp.

  IF gt_rseg_ses[] IS NOT INITIAL.
    SELECT ebeln
           ebelp
           gjahr
           belnr
           xblnr
           lfgja
           lfbnr
           lfpos
           lsmng
    FROM ekbe
    INTO TABLE gt_ekbe
    FOR ALL ENTRIES IN gt_rseg_ses
    WHERE ebeln EQ gt_rseg_ses-ebeln
      AND ebelp EQ gt_rseg_ses-ebelp
      AND lfgja EQ gt_rseg_ses-lfgja
      AND lfbnr EQ gt_rseg_ses-lfbnr
      AND bewtp EQ 'E'
      AND bwart EQ '101'.

  ENDIF.

***DATA:
**   ls_ekbe LIKE gt_ekbe.
  IF gt_ekbe[] IS NOT INITIAL.
    SORT gt_ekbe.
    LOOP AT gt_ekbe.
****      READ TABLE gt_ekbe INTO ls_ekbe INDEX sy-tabix + 1.
****      IF gt_ekbe-belnr = ls_ekbe-belnr AND gt_ekbe-ebeln = ls_ekbe-belnr AND gt_ekbe-ebelp = ls_ekbe-ebelp.
****        gt_ekbe-lsmng = gt_ekbe-lsmng +
****      ENDIF.
      CONCATENATE gt_ekbe-belnr gt_ekbe-gjahr
             INTO gt_ekbe-awkey.
      IF sy-subrc EQ 0.
        MODIFY gt_ekbe TRANSPORTING awkey.
      ENDIF.
    ENDLOOP.

    SELECT bukrs
           belnr
           gjahr
           blart
           bldat
           budat
           xblnr
           waers
           kursf
           awkey
           tcode
           xblnr_alt
    FROM bkpf
    INTO TABLE gt_bkpf_ses
    FOR ALL ENTRIES IN gt_ekbe
    WHERE gjahr = gt_ekbe-gjahr
      AND awkey = gt_ekbe-awkey.


    IF NOT gt_bkpf_ses[] IS INITIAL.
      SELECT bukrs
             belnr
             gjahr
             buzei
             shkzg
             dmbtr
             ktosl
             anln1
             anln2
             hkont
             ebeln
             ebelp
        FROM bseg
        APPENDING TABLE lt_bseg
        FOR ALL ENTRIES IN gt_bkpf_ses
        WHERE bukrs = gt_bkpf_ses-bukrs
        AND   belnr = gt_bkpf_ses-belnr
        AND   gjahr = gt_bkpf_ses-gjahr.
    ENDIF.
  ENDIF.

********** Processing IMPORT PO's

  gt_rseg_imp[] = gt_rseg[].
  SORT gt_rseg_imp BY lfbnr.
  DELETE gt_rseg_imp WHERE lfbnr IS NOT INITIAL.
  SORT gt_rseg_imp BY ebeln ebelp.
  DELETE ADJACENT DUPLICATES FROM gt_rseg_imp COMPARING ebeln ebelp.

  IF gt_rseg_imp[] IS NOT INITIAL.
    SELECT ebeln
           ebelp
           gjahr
           belnr
           xblnr
           lfgja
           lfbnr
           lfpos
           lsmng
    FROM ekbe
    INTO TABLE gt_ekbe_imp
    FOR ALL ENTRIES IN gt_rseg_imp
    WHERE ebeln EQ gt_rseg_imp-ebeln
      AND ebelp EQ gt_rseg_imp-ebelp
      AND bewtp EQ 'E'
      AND bwart EQ '101'.
  ENDIF.
  SORT gt_ekbe_imp BY belnr DESCENDING ebeln ebelp.
  DELETE ADJACENT DUPLICATES FROM gt_ekbe_imp COMPARING belnr ebeln ebelp.


  IF gt_ekbe_imp[] IS NOT INITIAL.

    LOOP AT gt_ekbe_imp.
      CONCATENATE gt_ekbe_imp-belnr gt_ekbe_imp-gjahr
             INTO gt_ekbe_imp-awkey.
      IF sy-subrc EQ 0.
        MODIFY gt_ekbe_imp TRANSPORTING awkey.
      ENDIF.
    ENDLOOP.



  ENDIF.

  IF gt_ekbe_imp IS NOT INITIAL.
    SELECT bukrs
           belnr
           gjahr
           blart
           bldat
           budat
           xblnr
           waers
           kursf
           awkey
           tcode
           xblnr_alt
    FROM bkpf
    INTO TABLE gt_bkpf_imp
    FOR ALL ENTRIES IN gt_ekbe_imp
    WHERE awkey = gt_ekbe_imp-awkey.
  ENDIF.

  IF NOT gt_bkpf_imp[] IS INITIAL.
    SELECT bukrs
           belnr
           gjahr
           buzei
           shkzg
           dmbtr
           ktosl
           anln1
           anln2
           hkont
           ebeln
           ebelp
      FROM bseg
      APPENDING TABLE lt_bseg
      FOR ALL ENTRIES IN gt_bkpf_imp
      WHERE bukrs = gt_bkpf_imp-bukrs
      AND   belnr = gt_bkpf_imp-belnr
      AND   gjahr = gt_bkpf_imp-gjahr.
  ENDIF.

  IF gt_bkpf IS NOT INITIAL.
    SELECT bukrs
           belnr
           gjahr
           txgrp
           shkzg
           mwskz
           hwbas
           hwste
           ktosl
           kschl
           kbetr
           buzei
           hkont
           knumh
    FROM bset
    INTO TABLE gt_bset
    FOR ALL ENTRIES IN gt_bkpf
    WHERE bukrs = gt_bkpf-bukrs
      AND belnr = gt_bkpf-belnr
      AND gjahr = gt_bkpf-gjahr .
  ENDIF.


  IF gt_lfa1[] IS NOT INITIAL .
    SELECT * FROM t005u
    INTO TABLE gt_t005u
    FOR ALL ENTRIES IN gt_lfa1
    WHERE spras = sy-langu
      AND land1 = gt_lfa1-land1
      AND bland = gt_lfa1-regio.

    SELECT gst_region
           bezei
      FROM zgst_region
      INTO TABLE lt_zgst_region
      FOR ALL ENTRIES IN gt_t005u
      WHERE bezei = gt_t005u-bezei.

    SELECT addrnumber
           name1
           city2
           post_code1
           street
           str_suppl3
           location
           country
      FROM adrc
      INTO TABLE lt_adrc
      FOR ALL ENTRIES IN gt_lfa1
      WHERE addrnumber = gt_lfa1-adrnr.

    SELECT lifnr
           j_1ilstno
           j_1ipanno
           j_1isern
           j_1icstno
           j_1iexcd
           ven_class
           j_1issist
      FROM j_1imovend
      INTO TABLE gt_j_1imovend
      FOR ALL ENTRIES IN gt_lfa1
      WHERE lifnr EQ gt_lfa1-lifnr.
  ENDIF.
  IF NOT gt_j_1imovend[] IS INITIAL.
    SELECT valpos
           ddtext
           domvalue_l
      FROM dd07t
      INTO TABLE lt_dd07t
      FOR ALL ENTRIES IN gt_j_1imovend
      WHERE domname    = 'J_1IGTAXKD'
      AND   domvalue_l = gt_j_1imovend-ven_class
      AND   ddlanguage = sy-langu.


  ENDIF.
  IF gt_rseg[] IS NOT INITIAL .
    SELECT mblnr
           mjahr
           zeile
           bwart
           lgort
           insmk
           ebeln
           ebelp
           menge
           lsmng
           matnr
           mwskz
           werks

      FROM mseg
      INTO TABLE lt_mseg
      FOR ALL ENTRIES IN gt_rseg
      WHERE mjahr = gt_rseg-lfgja
      AND   mblnr = gt_rseg-lfbnr
      AND   zeile = gt_rseg-lfpos
      AND   bwart = '101'
      AND   lgort = 'RM01'.
*      AND   insmk = space.
  ENDIF.
*************************************start of changes by shreya 27-10-2021***********************************
  SELECT   mblnr
           mjahr
           zeile
           bwart
           lgort
           insmk
           ebeln
           ebelp
           menge
           lsmng
           matnr
           mwskz
           werks
           budat_mkpf
      FROM mseg
     APPENDING TABLE lt_mseg
      "FOR ALL ENTRIES IN lt_mseg
      WHERE budat_mkpf IN s_budat
      AND   mblnr IN s_lfbnr
      AND   bwart = '101'
      AND   lgort = 'RM01'
      AND  mblnr not in rng_mblnr.
*      AND   insmk = space.
  SORT lt_mseg BY mblnr mjahr zeile bwart lgort insmk ebeln ebelp.
  DELETE ADJACENT DUPLICATES FROM lt_mseg.
  IF lt_mseg IS NOT INITIAL.
    LOOP AT lt_mseg INTO ls_mseg.
      CONCATENATE ls_mseg-mblnr ls_mseg-mjahr INTO ls_mseg-awkey.
      MODIFY lt_mseg FROM ls_mseg.
      CLEAR ls_mseg.
    ENDLOOP.

    SELECT belnr,
           gjahr,
           awkey
      FROM bkpf
      INTO TABLE @DATA(lt_bkpf)
      FOR ALL ENTRIES IN @lt_mseg
      WHERE awkey = @lt_mseg-awkey.

    SELECT prueflos
             ebeln
             ebelp
             mjahr
             mblnr
             zeile
        FROM qals
        INTO TABLE lt_qals
        FOR ALL ENTRIES IN lt_mseg
        WHERE mjahr = lt_mseg-mjahr
        AND   mblnr = lt_mseg-mblnr
        AND   zeile = lt_mseg-zeile.

    IF NOT lt_qals IS INITIAL.
      SELECT prueflos
             mblnr
             mjahr
             zeile
        FROM qamb
        INTO TABLE lt_qamb
        FOR ALL ENTRIES IN lt_qals
        WHERE prueflos = lt_qals-prueflos
        AND   typ = '3'.

      IF NOT lt_qamb IS INITIAL.
        SELECT mblnr
               mjahr
               zeile
               bwart
               lgort
               insmk
               ebeln
               ebelp
               menge
               lsmng
               matnr
               mwskz
               werks
               budat_mkpf

          FROM mseg
          APPENDING TABLE lt_mseg
          FOR ALL ENTRIES IN lt_qamb
          WHERE mblnr = lt_qamb-mblnr
          AND   mjahr = lt_qamb-mjahr
*          AND   zeile = lt_qamb-zeile
          AND   bwart = '321'
          AND   xauto = 'X'
          and mblnr not in rng_mblnr.

      ENDIF.
    ENDIF.
    SELECT matnr
           maktx
      FROM makt
      INTO TABLE gt_makt
      FOR ALL ENTRIES IN lt_mseg
      WHERE matnr = lt_mseg-matnr
      AND spras = 'EN'.

    SELECT matnr
           mtart
           meins
           zseries
           zsize
           brand
           moc
           type
      FROM mara
      INTO TABLE lt_mat_mast
      FOR ALL ENTRIES IN lt_mseg
      WHERE matnr = lt_mseg-matnr.

    SELECT mwskz
           text1
      FROM t007s
      INTO TABLE lt_t007s
      FOR ALL ENTRIES IN lt_mseg
      WHERE mwskz = lt_mseg-mwskz
      AND   kalsm = 'ZTAXIN'.

    SELECT matnr
           werks
           steuc
      FROM marc
      INTO TABLE lt_marc
      FOR ALL ENTRIES IN lt_mseg
      WHERE matnr = lt_mseg-matnr
      AND   werks = lt_mseg-werks.

    SELECT ebeln
           ekorg
           ekgrp
           bsart
           aedat
           lifnr
           revno
    FROM ekko
    INTO TABLE gt_ekko
     FOR ALL ENTRIES IN lt_mseg
    WHERE ebeln = lt_mseg-ebeln.

    SELECT ebeln
           ebelp
           matnr
           werks
           menge
           netpr
           peinh
           netwr
           mwskz
           pstyp
           knttp
           infnr
    FROM ekpo
    INTO TABLE gt_ekpo
     FOR ALL ENTRIES IN lt_mseg
    WHERE ebeln = lt_mseg-ebeln
      AND ebelp = lt_mseg-ebelp.

    SELECT ebeln
           ebelp
           etenr
           eindt
      FROM eket
      INTO TABLE lt_eket
      FOR ALL ENTRIES IN gt_ekpo
      WHERE ebeln = gt_ekpo-ebeln
      AND   ebelp = gt_ekpo-ebelp.

    SELECT pstyp
           epstp
      FROM t163y
      INTO TABLE lt_t163y
      FOR ALL ENTRIES IN gt_ekpo
      WHERE spras = sy-langu
      AND pstyp = gt_ekpo-pstyp.

    SORT gt_ekpo BY knttp.
    LOOP AT gt_ekpo WHERE knttp = 'A'  .
      MOVE-CORRESPONDING gt_ekpo TO gt_ekpo1.
      APPEND gt_ekpo1.
      CLEAR  gt_ekpo1.
    ENDLOOP.
    SORT gt_ekpo BY ebeln ebelp knttp.
  ENDIF.
  "ENDIF.
********************************************** end: changes by shreya***************************************************************
*** Populating FINAL TABLE

  SORT gt_rseg_v1 BY belnr ebeln ebelp.
  SORT gt_rseg    BY belnr ebeln ebelp.

****** New Code for BSET
  LOOP AT gt_rseg.
    READ TABLE gt_bkpf WITH KEY g_belnr = gt_rseg-belnr
                                g_gjahr = gt_rseg-gjahr.
    IF sy-subrc = 0.
      LOOP AT gt_bset WHERE belnr = gt_bkpf-belnr
                        AND txgrp = gt_rseg-buzei.
        MOVE-CORRESPONDING gt_bset TO gt_bset1.
        gt_bset1-ebeln = gt_rseg-ebeln.
        gt_bset1-ebelp = gt_rseg-ebelp.
        APPEND gt_bset1.
        CLEAR  gt_bset1.
      ENDLOOP.
*    APPEND gt_rseg.
    ENDIF.
  ENDLOOP.
****** End of New Code for BSET


  CLEAR : gt_final[].

  SORT gt_bkpf    BY g_belnr g_gjahr.
  SORT gt_rseg_v1 BY belnr gjahr ebeln ebelp.
  SORT gt_bset1   BY belnr ebeln ebelp.
  SORT lt_bseg BY belnr gjahr buzei.
  DELETE ADJACENT DUPLICATES FROM lt_bseg.
  SORT lt_qals BY prueflos mblnr mjahr ebeln ebelp.
  SORT lt_qamb BY prueflos.

  IF NOT lt_bseg IS INITIAL.
    SELECT saknr
           txt20
      FROM skat
      INTO TABLE lt_skat
      FOR ALL ENTRIES IN lt_bseg
      WHERE saknr = lt_bseg-hkont
      AND   spras = sy-langu
      AND   ktopl = '1000'.
  ENDIF.



  lt_bseg1 = lt_bseg.
***  DELETE lt_bseg1 WHERE ktosl NE 'BSX'.
***  DELETE lt_bseg2 WHERE ktosl NE 'FRL'.
  SORT lt_bseg1 BY belnr gjahr ebeln ebelp.
  SORT lt_mseg BY mblnr mjahr ebeln ebelp.
*BREAK primus.
  LOOP AT gt_rseg_v1.


    READ TABLE gt_bkpf WITH KEY g_belnr = gt_rseg_v1-belnr
                                g_gjahr = gt_rseg_v1-gjahr.

    IF sy-subrc = 0.
      READ TABLE gt_rbkp WITH KEY belnr = gt_bkpf-g_belnr
                                  gjahr = gt_bkpf-g_gjahr.
      IF sy-subrc = 0.
        gt_final-miro_ac_doc = gt_bkpf-belnr.     " MIRO A/C Doc No
        gt_final-blart       = gt_bkpf-blart.     " FI Doc Type
        gt_final-prepay_awkey = gt_rbkp-prepay_awkey. "pj 30-09-21

        IF gt_rbkp-bldat IS NOT INITIAL.


          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              input  = gt_rbkp-bldat
            IMPORTING
              output = gt_final-bldat.

          CONCATENATE gt_final-bldat+0(2) gt_final-bldat+2(3) gt_final-bldat+5(4)
                     INTO gt_final-bldat SEPARATED BY '-'.

        ENDIF.
*        IF NOT gt_bkpf-budat IS INITIAL.  commented by swati on 21.02.2019
**          CONCATENATE gt_bkpf-budat+6(2) gt_bkpf-budat+4(2) gt_bkpf-budat+0(4) INTO  gt_final-bill_dt SEPARATED BY '-'.
*        ELSE.
*          gt_final-bill_dt = 'NULL' .
*        ENDIF.
        gt_final-bill_dt = gt_bkpf-budat.
        gt_final-awkey       = gt_bkpf-g_belnr.   " Bill Booking No.
        gt_final-inv_no      = gt_bkpf-xblnr.     " Inv/Bill No.
        gt_final-xblnr_alt   = gt_bkpf-xblnr_alt. " ODN.

*        IF NOT gt_bkpf-bldat IS INITIAL.  "changed by swati on 21.02.2019
*          CONCATENATE gt_bkpf-bldat+6(2) gt_bkpf-bldat+4(2) gt_bkpf-bldat+0(4) INTO  gt_final-inv_dt SEPARATED BY '-'.
        gt_final-inv_dt = gt_bkpf-bldat.
*        ELSE.
*          gt_final-inv_dt = 'NULL' .
*        ENDIF.
        gt_final-tcode       = gt_bkpf-tcode.     " T-Code
        gt_final-waers       = gt_bkpf-waers.     " Document Currency
        gt_final-kursf       = gt_bkpf-kursf.     " Exchange rate
        gt_final-lifnr = gt_rbkp-lifnr.      " Vendor
        gt_final-zuonr = gt_rbkp-zuonr.      " Original Inv No.
        gt_final-bktxt = gt_rbkp-bktxt.      " Original Inv Dt
        REPLACE ALL OCCURRENCES OF '.' IN gt_final-bktxt WITH '-'.
        READ TABLE gt_lfa1 WITH KEY lifnr = gt_rbkp-lifnr.
        IF sy-subrc = 0.
          gt_final-name1 = gt_lfa1-name1.    " Vendor Name
          gt_final-stcd3 = gt_lfa1-stcd3.
          READ TABLE gt_t005u WITH KEY bland = gt_lfa1-regio.
          IF sy-subrc = 0.
            gt_final-bezei = gt_t005u-bezei. " State
          ENDIF.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = gt_t005u-bezei.
          IF sy-subrc IS INITIAL.
            gt_final-gst_region = ls_zgst_region-gst_region.
          ENDIF.
          READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = gt_lfa1-adrnr.
          IF sy-subrc IS INITIAL.
            IF NOT ls_adrc-street IS INITIAL.
              CONCATENATE gt_final-address ls_adrc-street INTO gt_final-address.
            ENDIF.

            IF NOT ls_adrc-str_suppl3 IS INITIAL.
              CONCATENATE gt_final-address ls_adrc-str_suppl3 INTO gt_final-address SEPARATED BY ','.
            ENDIF.
            IF NOT ls_adrc-location IS INITIAL.
              CONCATENATE gt_final-address ls_adrc-location INTO gt_final-address SEPARATED BY ','.
            ENDIF.

            IF NOT ls_adrc-city2 IS INITIAL.
              CONCATENATE gt_final-address ls_adrc-city2 INTO gt_final-address SEPARATED BY ','.
            ENDIF.
            IF NOT ls_adrc-post_code1 IS INITIAL.
              CONCATENATE gt_final-address 'PIN:' ls_adrc-post_code1 INTO gt_final-address SEPARATED BY ','.
            ENDIF.
            CONDENSE gt_final-address.

          ENDIF.

          READ TABLE gt_j_1imovend WITH KEY lifnr = gt_lfa1-lifnr.
          IF sy-subrc = 0.
            gt_final-tin_no =   gt_j_1imovend-j_1icstno.
            gt_final-lst_no =   gt_j_1imovend-j_1ilstno.

            IF gt_j_1imovend-j_1issist = '1'.
              gt_final-j_1issist = 'Micro'.
            ELSEIF gt_j_1imovend-j_1issist = '2'.
              gt_final-j_1issist = 'Small'.
            ELSEIF gt_j_1imovend-j_1issist = '3'.
              gt_final-j_1issist = 'Medium'.
            ELSEIF gt_j_1imovend-j_1issist = '4'.
              gt_final-j_1issist = 'NA'.
            ENDIF.

          ENDIF.
          READ TABLE lt_dd07t INTO ls_dd07t WITH KEY domvalue_l = gt_j_1imovend-ven_class.
          IF sy-subrc IS INITIAL.
            gt_final-gst_txt = ls_dd07t-ddtext.
          ENDIF.
          READ TABLE gt_lfb1 WITH KEY lifnr = gt_lfa1-lifnr.
          IF sy-subrc = 0.
            gt_final-akont = gt_lfb1-akont.
          ENDIF.
        ENDIF.


        READ TABLE gt_bkpf_we WITH KEY awkey = gt_rseg_v1-awkey.
        IF sy-subrc = 0.

          IF NOT gt_bkpf_we-budat IS INITIAL.
            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                input  = gt_bkpf_we-budat
              IMPORTING
                output = gt_final-budat.

            CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
                       INTO gt_final-budat SEPARATED BY '-'.


*            CONCATENATE gt_bkpf_we-budat+6(2) gt_bkpf_we-budat+4(2) gt_bkpf_we-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
          ELSE.
            gt_final-budat = 'NULL' .
          ENDIF.

          gt_final-belnr = gt_bkpf_we-belnr.    " FI document No.
          READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_we-bukrs
                                                    belnr = gt_bkpf_we-belnr
                                                    gjahr = gt_bkpf_we-gjahr
                                                    ebelp = gt_rseg_v1-ebelp
                                                    ktosl = 'BSX'.
          IF sy-subrc IS INITIAL.
            lv_index = sy-tabix.
            gt_final-hkont   = ls_bseg-hkont.
            LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
              IF ls_bseg-bukrs = gt_bkpf_we-bukrs AND ls_bseg-belnr = gt_bkpf_we-belnr AND ls_bseg-ktosl = 'BSX'
                AND ls_bseg-gjahr = gt_bkpf_we-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
                IF ls_bseg-shkzg = 'S'.
                  gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
                ELSE.
                  gt_final-grn_amt = gt_final-grn_amt - ls_bseg-dmbtr.
                ENDIF.

              ENDIF.
            ENDLOOP.

          ELSE.
            READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_we-bukrs
                                                      belnr = gt_bkpf_we-belnr
                                                      gjahr = gt_bkpf_we-gjahr
                                                      ebelp = gt_rseg_v1-ebelp
                                                      ktosl = 'FRL'.
            IF sy-subrc IS INITIAL.
              lv_index = sy-tabix.
              gt_final-hkont   = ls_bseg-hkont.
              LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
                IF ls_bseg-bukrs = gt_bkpf_we-bukrs AND ls_bseg-belnr = gt_bkpf_we-belnr AND ls_bseg-ktosl = 'FRL'
                  AND ls_bseg-gjahr = gt_bkpf_we-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
                  gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ELSE.
          READ TABLE lt_rseg WITH KEY belnr = gt_rseg_v1-belnr
                                      gjahr = gt_rseg_v1-gjahr
                                      ebeln = gt_rseg_v1-ebeln
                                      ebelp = gt_rseg_v1-ebelp.
          IF sy-subrc IS INITIAL.
            CLEAR gt_bkpf_we.
            READ TABLE gt_bkpf_we WITH KEY awkey = lt_rseg-awkey.
            IF sy-subrc = 0.
*              gt_final-budat = gt_bkpf_we-budat .   " MIGO Date.
              IF NOT gt_bkpf_we-budat IS INITIAL.                 "ADDED BY SNEHAL RAJALE ON 2 APRIL 2021.
                CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                  EXPORTING
                    input  = gt_bkpf_we-budat
                  IMPORTING
                    output = gt_final-budat.

                CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
                INTO gt_final-budat SEPARATED BY '-'.

*                CONCATENATE gt_bkpf_imp-budat+6(2) gt_bkpf_imp-budat+4(2) gt_bkpf_imp-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
              ELSE.
                gt_final-budat = 'NULL' .   " MIGO Date.
              ENDIF.

              gt_final-belnr = gt_bkpf_we-belnr.    " FI document No.

            ENDIF.
          ENDIF.
          READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_we-bukrs
                                                    belnr = gt_bkpf_we-belnr
                                                    gjahr = gt_bkpf_we-gjahr
                                                    ebelp = gt_rseg_v1-ebelp
                                                    ktosl = 'BSX'.
          IF sy-subrc IS INITIAL.
            lv_index = sy-tabix.
            gt_final-hkont   = ls_bseg-hkont.
            LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
              IF ls_bseg-bukrs = gt_bkpf_we-bukrs AND ls_bseg-belnr = gt_bkpf_we-belnr AND ls_bseg-ktosl = 'BSX'
                AND ls_bseg-gjahr = gt_bkpf_we-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
                gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
              ENDIF.
            ENDLOOP.
          ELSE.
            READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_we-bukrs
                                                    belnr = gt_bkpf_we-belnr
                                                    gjahr = gt_bkpf_we-gjahr
                                                    ebelp = gt_rseg_v1-ebelp
                                                    ktosl = 'FRL'.
            IF sy-subrc IS INITIAL.
              lv_index = sy-tabix.
              gt_final-hkont   = ls_bseg-hkont.
              LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
                IF ls_bseg-bukrs = gt_bkpf_we-bukrs AND ls_bseg-belnr = gt_bkpf_we-belnr AND ls_bseg-ktosl = 'FRL'
                  AND ls_bseg-gjahr = gt_bkpf_we-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
                  gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
        gt_final-ebelp = gt_rseg_v1-ebelp.     " PO item
        gt_final-ebeln = gt_rseg_v1-ebeln.     " PO No.

        READ TABLE lt_eket INTO ls_eket WITH KEY ebeln = gt_final-ebeln
                                                 ebelp = gt_final-ebelp.
        IF sy-subrc IS INITIAL.
          IF NOT ls_eket-eindt IS INITIAL.
            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                input  = ls_eket-eindt
              IMPORTING
                output = gt_final-eindt.

            CONCATENATE gt_final-eindt+0(2) gt_final-eindt+2(3) gt_final-eindt+5(4)
                       INTO gt_final-eindt SEPARATED BY '-'.

*            CONCATENATE ls_eket-eindt+6(2) ls_eket-eindt+4(2) ls_eket-eindt+0(4) INTO gt_final-eindt SEPARATED BY '-'.
          ELSE.
            gt_final-eindt = 'NULL' .
          ENDIF.
        ELSE.
          gt_final-eindt = 'NULL' .
        ENDIF.
****** New Code for BSET
        CLEAR: lv_cgst,lv_sgst,lv_igst.
        LOOP AT gt_bset1 WHERE belnr = gt_bkpf-belnr
                           AND ebeln = gt_rseg_v1-ebeln
                           AND ebelp = gt_rseg_v1-ebelp.
          "and gjahr = gt_bkpf-gjahr .

**          IF gt_bset1-kschl = 'JEC1' OR gt_bset1-kschl = 'JEC2' .
***          gt_final-ecs = gt_final-ecs + gt_bset-hwste.
***            gt_final-ecs = gt_final-ecs + gt_bset1-hwste.
**          ENDIF.
**          IF gt_bset1-kschl = 'JSEP' OR gt_bset1-kschl = 'JSEI' .
***          gt_final-hcess = gt_final-hcess + gt_bset-hwste.
**            gt_final-hcess = gt_final-hcess + gt_bset1-hwste.
**          ENDIF.

          IF gt_bset1-kschl = 'JVCS'.
*          gt_final-cst_tax = gt_final-cst_tax + gt_bset-hwste.
            gt_final-cst_tax = gt_final-cst_tax + gt_bset1-hwste.
            gt_final-cst     = gt_bset1-kbetr / 10.
            IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.
          IF gt_bset1-kschl = 'JMOP' OR gt_bset1-kschl = 'JMOQ' .
*          gt_final-bed = gt_final-bed + gt_bset-hwste.
            gt_final-bed = gt_final-bed + gt_bset1-hwste.
            IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.
          IF gt_bset1-kschl = 'JAOP' OR gt_bset1-kschl = 'JAOQ' .
*          gt_final-aed = gt_final-aed + gt_bset-hwste.
            gt_final-aed =  gt_final-aed + gt_bset1-hwste.
            IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.
          IF gt_bset1-kschl = 'JVRD' OR gt_bset1-kschl = 'JVRN'.
*          gt_final-vat_tax = gt_final-vat_tax + gt_bset-hwste.
            gt_final-vat_tax = gt_final-vat_tax + gt_bset1-hwste.
            gt_final-vat     = gt_bset1-kbetr / 10.
            IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.

          IF gt_bset1-kschl = 'JICG' OR gt_bset1-kschl = 'JICN'
          OR gt_bset1-kschl = 'JICR' OR gt_bset1-kschl = 'ZCRN'.
            IF gt_bset1-shkzg = 'H'.
              lv_cgst = lv_cgst - gt_bset1-hwste.
            ELSE.
              lv_cgst = lv_cgst + gt_bset1-hwste.
            ENDIF.

          ENDIF.

          IF gt_bset1-kschl = 'JICG' OR gt_bset1-kschl = 'JICN'.
*            OR gt_bset1-kschl = 'JICR' OR gt_bset1-kschl = 'ZCRN'.                               "CGST
            gt_final-cgst_tax = gt_final-cgst_tax + gt_bset1-hwste.

            IF NOT gt_bset1-kbetr IS INITIAL AND gt_bset1-kschl = 'JICG'.
              gt_final-cgst     = gt_bset1-kbetr / 10.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.
          IF gt_bset1-kschl = 'JISG' OR gt_bset1-kschl = 'JISN'.
*            OR gt_bset1-kschl = 'JISR' OR gt_bset1-kschl = 'ZSRN'.                               "SGST
            gt_final-sgst_tax = gt_final-sgst_tax + gt_bset1-hwste.

            IF NOT gt_bset1-kbetr IS INITIAL AND gt_bset1-kschl = 'JISG'.
              gt_final-sgst  = gt_bset1-kbetr / 10.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.

          ENDIF.

          IF gt_bset1-kschl = 'JISG' OR gt_bset1-kschl = 'JISN'
          OR gt_bset1-kschl = 'JISR' OR gt_bset1-kschl = 'ZSRN'.
            IF gt_bset1-shkzg = 'H'.
              lv_sgst = lv_sgst - gt_bset1-hwste.
            ELSE.
              lv_sgst = lv_sgst + gt_bset1-hwste.
            ENDIF.
          ENDIF.

          IF gt_bset1-kschl = 'JIIG' OR gt_bset1-kschl = 'JIIN'
            OR gt_bset1-kschl = 'JIMD' .                               "IGST
            gt_final-igst_tax = gt_final-igst_tax + gt_bset1-hwste.

            IF NOT gt_bset1-kbetr IS INITIAL AND gt_bset1-kschl = 'JIIG'.
              gt_final-igst     = gt_bset1-kbetr / 10.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.
          IF gt_bset1-kschl = 'JIIG' OR gt_bset1-kschl = 'JIIN'
          OR gt_bset1-kschl = 'ZIRN' OR gt_bset1-kschl = 'JIMD'.
            IF gt_bset1-shkzg = 'H'.
              lv_igst = lv_igst - gt_bset1-hwste.
            ELSE.
              lv_igst = lv_igst + gt_bset1-hwste.
            ENDIF.
          ENDIF.

          IF gt_bset1-kschl = 'JSER' OR gt_bset1-kschl = 'JSVD' OR gt_bset1-kschl = 'JSV2'.

            IF gt_bset1-shkzg = 'S'.
*            gt_final-ser_val_dr = gt_final-ser_val_dr + gt_bset-hwste.
              gt_final-ser_val_dr = gt_final-ser_val_dr + gt_bset1-hwste.
            ELSEIF gt_bset1-shkzg = 'H'.
*            gt_final-ser_val_cr = gt_final-ser_val_cr + gt_bset-hwste.
              gt_final-ser_val_dr = gt_final-ser_val_dr - gt_bset1-hwste.
            ENDIF.
            IF gt_final-mwskz IS INITIAL.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.

          IF gt_bset1-kschl = 'JSSB'.

            IF gt_bset1-shkzg = 'S'.
*            gt_final-sbc_dr = gt_final-sbc_dr + gt_bset-hwste.
              gt_final-sbc_dr = gt_final-sbc_dr + gt_bset1-hwste.
            ELSEIF gt_bset1-shkzg = 'H'.
*            gt_final-sbc_cr = gt_final-sbc_cr + gt_bset-hwste.
              gt_final-sbc_dr = gt_final-sbc_dr - gt_bset1-hwste.
            ENDIF.
            IF gt_final-mwskz IS INITIAL.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.

          IF gt_bset1-kschl = 'JKKP' OR gt_bset1-kschl = 'ZKKR' OR gt_bset1-kschl = 'JKKN' OR gt_bset1-kschl = 'JSKK'
          OR gt_bset1-kschl = 'JKK1' OR gt_bset1-kschl = 'JKK2' OR gt_bset1-kschl = 'JKK3' OR gt_bset1-kschl = 'JKK4' .
            IF gt_bset1-shkzg = 'S'.
*            gt_final-kkc_dr = gt_final-kkc_dr + gt_bset-hwste.
              gt_final-kkc_dr = gt_final-kkc_dr + gt_bset1-hwste.
            ELSEIF gt_bset-shkzg = 'H'.
*            gt_final-kkc_cr = gt_final-kkc_cr + gt_bset-hwste.
              gt_final-kkc_dr = gt_final-kkc_dr - gt_bset1-hwste.
            ENDIF.
            IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
              gt_final-mwskz = gt_bset1-mwskz.
            ENDIF.
          ENDIF.

        ENDLOOP.


**********          Service entry Sheet's MIGO No.
        IF gt_rseg_v1-pstyp = '9'.
          READ TABLE gt_ekbe WITH KEY ebeln = gt_rseg_v1-ebeln
                                      ebelp = gt_rseg_v1-ebelp
                                      lfbnr = gt_rseg_v1-lfbnr .
          IF sy-subrc = 0.
            gt_final-lfbnr = gt_ekbe-belnr.   " MIGO No.
            CLEAR gt_bkpf_ses.
            READ TABLE gt_bkpf_ses WITH KEY gjahr = gt_ekbe-gjahr
                                            awkey = gt_ekbe-awkey.
            IF sy-subrc = 0.
*              gt_final-budat = gt_bkpf_ses-budat .   " MIGO Date.
              IF NOT gt_bkpf_ses-budat IS INITIAL.                 "ADDED BY SNEHAL RAJALE ON 2 APRIL 2021.
                CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                  EXPORTING
                    input  = gt_bkpf_ses-budat
                  IMPORTING
                    output = gt_final-budat.

                CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
                INTO gt_final-budat SEPARATED BY '-'.

*                CONCATENATE gt_bkpf_imp-budat+6(2) gt_bkpf_imp-budat+4(2) gt_bkpf_imp-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
              ELSE.
                gt_final-budat = 'NULL' .   " MIGO Date.
              ENDIF.

              gt_final-belnr = gt_bkpf_ses-belnr.    " FI document No.


              READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_ses-bukrs
                                                        belnr = gt_bkpf_ses-belnr
                                                        gjahr = gt_bkpf_ses-gjahr
                                                        ebelp = gt_rseg_v1-ebelp
                                                        ktosl = 'KBS'.
              IF sy-subrc IS INITIAL.
                lv_index = sy-tabix.
                gt_final-hkont   = ls_bseg-hkont.
                LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
                  IF ls_bseg-bukrs = gt_bkpf_ses-bukrs AND ls_bseg-belnr = gt_bkpf_ses-belnr AND ls_bseg-ktosl = 'KBS'
                    AND ls_bseg-gjahr = gt_bkpf_ses-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.

                    IF ls_bseg-shkzg = 'S'.
                      gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
                    ELSE.
                      gt_final-grn_amt = gt_final-grn_amt - ls_bseg-dmbtr.
                    ENDIF.

                  ENDIF.
                ENDLOOP.
**              ELSE.
**                READ TABLE lt_bseg2 INTO ls_bseg WITH KEY bukrs = gt_bkpf_ses-bukrs
**                                                        belnr = gt_bkpf_ses-belnr
**                                                        gjahr = gt_bkpf_ses-gjahr
**                                                        ebelp = gt_rseg_v1-ebelp.
**                IF sy-subrc IS INITIAL.
**                  lv_index = sy-tabix.
**                  gt_final-hkont   = ls_bseg-hkont.
**                  LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
**                    IF ls_bseg-bukrs = gt_bkpf_ses-bukrs AND ls_bseg-belnr = gt_bkpf_ses-belnr
**                      AND ls_bseg-gjahr = gt_bkpf_ses-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
**
**                      IF ls_bseg-shkzg = 'S'.
**                        gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
**                      ELSE.
**                        gt_final-grn_amt = gt_final-grn_amt - ls_bseg-dmbtr.
**                      ENDIF.
**
**                    ENDIF.
**                  ENDLOOP.
**              ENDIF.
              ENDIF.

            ENDIF.
          ENDIF.
        ELSE.
          READ TABLE lt_rseg WITH KEY belnr = gt_rseg_v1-belnr
                                      gjahr = gt_rseg_v1-gjahr
                                      ebeln = gt_rseg_v1-ebeln
                                      ebelp = gt_rseg_v1-ebelp.
          IF sy-subrc IS INITIAL.

*          gt_final-lfbnr = gt_rseg_v1-lfbnr.     " MIGO No.
            gt_final-lfbnr = lt_rseg-lfbnr.     " MIGO No.


            READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = lt_rseg-lfbnr
                                                       mjahr = lt_rseg-lfgja
                                                       ebeln = lt_rseg-ebeln
                                                       ebelp = lt_rseg-ebelp
                                                       lgort = 'RM01'
                                                       bwart = '101'.


            IF sy-subrc IS INITIAL.
              lv_index = sy-tabix.
              LOOP AT lt_mseg INTO ls_mseg FROM lv_index.
                IF ls_mseg-mblnr = lt_rseg-lfbnr AND ls_mseg-mjahr = lt_rseg-lfgja AND ls_mseg-ebeln = lt_rseg-ebeln
                  AND ls_mseg-ebelp = lt_rseg-ebelp AND ls_mseg-lgort = 'RM01' AND ls_mseg-bwart = '101'.
*                    gt_final-acc_qty = gt_final-acc_qty + ls_mseg-menge .
                  gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                ENDIF.
              ENDLOOP.

            ENDIF.

            READ TABLE lt_qals INTO ls_qals WITH KEY mblnr = lt_rseg-lfbnr
                                                     mjahr = lt_rseg-lfgja
                                                     ebeln = gt_rseg_v1-ebeln
                                                     ebelp = gt_rseg_v1-ebelp.
            IF sy-subrc IS INITIAL.
              lv_ind = sy-tabix.
              LOOP AT lt_qals INTO ls_qals FROM lv_ind.
                IF ls_qals-mblnr = lt_rseg-lfbnr AND ls_qals-mjahr = lt_rseg-lfgja
                AND ls_qals-ebeln = gt_rseg_v1-ebeln AND ls_qals-ebelp = gt_rseg_v1-ebelp.
                  READ TABLE lt_qamb INTO ls_qamb WITH KEY prueflos = ls_qals-prueflos.
                  IF sy-subrc IS INITIAL.
                    lv_index = sy-tabix.
                    LOOP AT lt_qamb INTO ls_qamb FROM lv_index.
                      IF ls_qamb-prueflos = ls_qals-prueflos.
                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = lt_rseg-ebeln
                                                                 ebelp = lt_rseg-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RM01'.
                        IF sy-subrc IS INITIAL.
                          gt_final-acc_qty = gt_final-acc_qty + ls_mseg-menge.

                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RJ01'.
                        IF sy-subrc IS INITIAL.
                          gt_final-rej_qty = gt_final-rej_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'SCR1'.
                        IF sy-subrc IS INITIAL.
                          gt_final-scp_qty = gt_final-scp_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RWK1'.
                        IF sy-subrc IS INITIAL.
                          gt_final-rew_qty = gt_final-rew_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.
                      ELSE.
                        EXIT.

                      ENDIF.
                    ENDLOOP.
                  ELSE.
                    EXIT.
                  ENDIF.
                ENDIF.
              ENDLOOP.
            ELSE.
              READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = lt_rseg-lfbnr
                                                       mjahr = lt_rseg-lfgja
                                                       ebeln = lt_rseg-ebeln
                                                       ebelp = lt_rseg-ebelp
                                                       lgort = 'RM01'
                                                       bwart = '101'.


              IF sy-subrc IS INITIAL.
                lv_index = sy-tabix.
                LOOP AT lt_mseg INTO ls_mseg FROM lv_index.
                  IF ls_mseg-mblnr = lt_rseg-lfbnr AND ls_mseg-mjahr = lt_rseg-lfgja AND ls_mseg-ebeln = lt_rseg-ebeln
                    AND ls_mseg-ebelp = lt_rseg-ebelp AND ls_mseg-lgort = 'RM01' AND ls_mseg-bwart = '101'.
                    gt_final-acc_qty = gt_final-acc_qty + ls_mseg-menge .
*                    gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                  ENDIF.
                ENDLOOP.

              ENDIF.

            ENDIF.


          ENDIF.
        ENDIF.
**********          Import PO's  MIGO No.
        IF gt_final-lfbnr IS INITIAL AND gt_rseg_v1-xekbz NE 'X'.
          READ TABLE gt_ekbe_imp WITH KEY ebeln = gt_rseg_v1-ebeln
                                          ebelp = gt_rseg_v1-ebelp.
          IF sy-subrc = 0.
            gt_final-lfbnr = gt_ekbe_imp-belnr.   " MIGO No.
            gt_final-lsmng = gt_ekbe_imp-lsmng.   " MIGO No.
            READ TABLE lt_qals INTO ls_qals WITH KEY mblnr = gt_ekbe_imp-lfbnr
                                                     mjahr = gt_ekbe_imp-lfgja
                                                     ebeln = gt_rseg_v1-ebeln
                                                     ebelp = gt_rseg_v1-ebelp.
            IF sy-subrc IS INITIAL.
              lv_ind = sy-tabix.
              LOOP AT lt_qals INTO ls_qals FROM lv_ind.
                IF ls_qals-mblnr = lt_rseg-lfbnr AND ls_qals-mjahr = lt_rseg-lfgja
                AND ls_qals-ebeln = gt_rseg_v1-ebeln AND ls_qals-ebelp = gt_rseg_v1-ebelp.
                  IF sy-subrc IS INITIAL.
                    lv_index = sy-tabix.
                    LOOP AT lt_qamb INTO ls_qamb FROM lv_index.
                      IF ls_qamb-prueflos = ls_qals-prueflos.
                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                             mjahr = ls_qamb-mjahr
                                                             ebeln = gt_rseg_v1-ebeln
                                                             ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                             lgort = 'RM01'.
                        IF sy-subrc IS INITIAL.
                          gt_final-acc_qty = gt_final-acc_qty + ls_mseg-menge.
                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RJ01'.
                        IF sy-subrc IS INITIAL.
                          gt_final-rej_qty = gt_final-rej_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'SCR1'.
                        IF sy-subrc IS INITIAL.
                          gt_final-scp_qty = gt_final-scp_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RWK1'.
                        IF sy-subrc IS INITIAL.
                          gt_final-rew_qty = gt_final-rew_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.
                      ELSE.
                        EXIT.

                      ENDIF.
                    ENDLOOP.
                  ELSE.
                    EXIT.

                  ENDIF.
                ENDIF.
              ENDLOOP.
*            ENDIF.
            ENDIF.
            CLEAR gt_bkpf_imp.
            READ TABLE gt_bkpf_imp WITH KEY ""gjahr = Gt_ekbe_imp-gjahr
                                            awkey = gt_ekbe_imp-awkey.
            IF sy-subrc = 0.
              IF NOT gt_bkpf_imp-budat IS INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                  EXPORTING
                    input  = gt_bkpf_imp-budat
                  IMPORTING
                    output = gt_final-budat.

                CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
                           INTO gt_final-budat SEPARATED BY '-'.

*                CONCATENATE gt_bkpf_imp-budat+6(2) gt_bkpf_imp-budat+4(2) gt_bkpf_imp-budat+0(4) INTO  gt_final-budat SEPARATED BY '-'.
              ELSE.
                gt_final-budat = 'NULL' .   " MIGO Date.
              ENDIF.


              gt_final-belnr = gt_bkpf_imp-belnr.    " FI document No.


              READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_imp-bukrs
                                                        belnr = gt_bkpf_imp-belnr
                                                        gjahr = gt_bkpf_imp-gjahr
                                                        ebelp = gt_rseg_v1-ebelp
                                                        ktosl = 'BSX'.
              IF sy-subrc IS INITIAL.
                lv_index = sy-tabix.
                gt_final-hkont   = ls_bseg-hkont.
                LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
                  IF ls_bseg-bukrs = gt_bkpf_imp-bukrs AND ls_bseg-belnr = gt_bkpf_imp-belnr AND ls_bseg-ktosl = 'BSX'
                    AND ls_bseg-gjahr = gt_bkpf_imp-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
                    IF ls_bseg-shkzg = 'S'.
                      gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
                    ELSE.
                      gt_final-grn_amt = gt_final-grn_amt - ls_bseg-dmbtr.
                    ENDIF.
                  ENDIF.
                ENDLOOP.
              ELSE.
                READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_imp-bukrs
                                                        belnr = gt_bkpf_imp-belnr
                                                        gjahr = gt_bkpf_imp-gjahr
                                                        ebelp = gt_rseg_v1-ebelp
                                                        ktosl = 'FRL'.
                IF sy-subrc IS INITIAL.
                  lv_index = sy-tabix.
                  gt_final-hkont   = ls_bseg-hkont.
                  LOOP AT lt_bseg1 INTO ls_bseg FROM lv_index.
                    IF ls_bseg-bukrs = gt_bkpf_imp-bukrs AND ls_bseg-belnr = gt_bkpf_imp-belnr AND ls_bseg-ktosl = 'FRL'
                      AND ls_bseg-gjahr = gt_bkpf_imp-gjahr AND ls_bseg-ebelp = gt_rseg_v1-ebelp.
                      IF ls_bseg-shkzg = 'S'.
                        gt_final-grn_amt = gt_final-grn_amt + ls_bseg-dmbtr.
                      ELSE.
                        gt_final-grn_amt = gt_final-grn_amt - ls_bseg-dmbtr.
                      ENDIF.
                    ENDIF.
                  ENDLOOP.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        READ TABLE lt_skat INTO ls_skat WITH KEY saknr = gt_final-hkont.
        IF sy-subrc IS INITIAL.
          gt_final-txt20 = ls_skat-txt20.
        ENDIF.

        SHIFT gt_final-hkont LEFT DELETING LEADING '0'.
        IF gt_final-mwskz IS INITIAL.
          gt_final-mwskz = gt_rseg_v1-mwskz.
        ENDIF.
        gt_final-matnr = gt_rseg_v1-matnr.
        gt_final-menge = gt_rseg_v1-menge.
        gt_final-werks = gt_rseg_v1-werks.

        READ TABLE lt_t007s INTO ls_t007s WITH KEY mwskz = gt_final-mwskz."gt_rseg_v1-mwskz.
        IF sy-subrc IS INITIAL.
          gt_final-text1 = ls_t007s-text1.
        ENDIF.
        READ TABLE gt_makt WITH KEY matnr = gt_rseg_v1-matnr.
        IF sy-subrc = 0.
          gt_final-maktx = gt_makt-maktx.
        ENDIF.
        "Material Long Text
        lv_id = gt_final-matnr.
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
              REPLACE ALL OCCURRENCES OF '<&>' IN ls_lines-tdline WITH '&'.
              CONCATENATE gt_final-long_txt ls_lines-tdline INTO gt_final-long_txt SEPARATED BY space.
            ENDIF.
          ENDLOOP.
          CONDENSE gt_final-long_txt.
        ENDIF.

        READ TABLE lt_marc INTO ls_marc WITH KEY matnr = gt_rseg_v1-matnr
                                                 werks = gt_rseg_v1-werks.
        IF sy-subrc IS INITIAL.
          gt_final-steuc = ls_marc-steuc.
        ENDIF.
        READ TABLE lt_mat_mast INTO ls_mat_mast WITH KEY matnr = gt_rseg_v1-matnr.
        IF sy-subrc IS INITIAL.
          gt_final-mtart = ls_mat_mast-mtart.
          gt_final-meins = ls_mat_mast-meins.

          gt_final-zseries = ls_mat_mast-zseries.
          gt_final-zsize   = ls_mat_mast-zsize.
          gt_final-brand   = ls_mat_mast-brand.
          gt_final-moc     = ls_mat_mast-moc.
          gt_final-type    = ls_mat_mast-type.
        ENDIF.

        READ TABLE gt_ekko WITH KEY ebeln = gt_rseg_v1-ebeln.
        IF sy-subrc = 0.
          gt_final-ekorg = gt_ekko-ekorg.
          gt_final-bsart = gt_ekko-bsart.
          IF NOT gt_ekko-aedat IS INITIAL.
            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                input  = gt_ekko-aedat
              IMPORTING
                output = gt_final-aedat.

            CONCATENATE gt_final-aedat+0(2) gt_final-aedat+2(3) gt_final-aedat+5(4)
                       INTO gt_final-aedat SEPARATED BY '-'.

*            CONCATENATE gt_ekko-aedat+6(2) gt_ekko-aedat+4(2) gt_ekko-aedat+0(4) INTO gt_final-aedat SEPARATED BY '-'.
          ELSE.
            gt_final-aedat = 'NULL'.
          ENDIF.

        ENDIF.
        READ TABLE gt_ekpo WITH KEY ebeln = gt_rseg_v1-ebeln
                                    ebelp = gt_rseg_v1-ebelp .
        IF sy-subrc = 0.
          gt_final-po_qty = gt_ekpo-menge.
          gt_final-infnr  = gt_ekpo-infnr.
          gt_final-knttp = gt_ekpo-knttp.
          IF gt_ekpo-peinh IS NOT INITIAL.
            gt_final-rate = gt_ekpo-netpr / gt_ekpo-peinh.
          ENDIF.

          READ TABLE lt_t163y INTO ls_t163y WITH KEY pstyp = gt_ekpo-pstyp.
          IF sy-subrc IS INITIAL.
            gt_final-pstyp = ls_t163y-epstp.
          ENDIF.

*********   Asset no. & Sub Asset No.
          READ TABLE gt_ekkn WITH KEY ebeln = gt_ekpo-ebeln
                                      ebelp = gt_ekpo-ebelp .
          IF sy-subrc = 0.
            gt_final-anln1 = gt_ekkn-anln1.
            gt_final-anln2 = gt_ekkn-anln2.
            gt_final-sakto = gt_ekkn-sakto.
            READ TABLE gt_anla WITH KEY anln1 = gt_ekkn-anln1
                                        anln2 = gt_ekkn-anln2.
            IF sy-subrc = 0.
              gt_final-invnr = gt_anla-invnr.
              gt_final-txt50 = gt_anla-txt50.
            ENDIF.
            READ TABLE lt_bseg INTO ls_bseg WITH KEY ebeln = gt_ekpo-ebeln
                                                     ebelp = gt_ekpo-ebelp
                                                     anln1 = gt_ekkn-anln1
                                                     anln2 = gt_ekkn-anln2.
            IF sy-subrc IS INITIAL.
              gt_final-ass_amt = ls_bseg-dmbtr.
            ENDIF.
          ENDIF.
        ENDIF.

        IF NOT gt_rbkp-stblg IS INITIAL.
          gt_final-acc_qty = 0.
          gt_final-rej_qty = 0.
          gt_final-scp_qty = 0.
          gt_final-rew_qty = 0.
          gt_final-menge   = 0.
        ENDIF.
*BREAK primus.
        LOOP AT gt_rseg WHERE belnr = gt_rbkp-belnr
                          AND gjahr = gt_rbkp-gjahr
                          AND ebeln = gt_rseg_v1-ebeln
                          AND ebelp = gt_rseg_v1-ebelp.


*****  BASIC
          IF gt_rseg-kschl = ''.
            gt_final-basic = gt_final-basic + gt_rseg-wrbtr.
          ENDIF.

*****  PACKING
          IF gt_rseg-kschl = 'ZPFL' OR gt_rseg-kschl = 'ZPC1' OR gt_rseg-kschl = 'ZPFV'.
            gt_final-packing = gt_final-packing + gt_rseg-wrbtr.
          ENDIF.

*****  DISCOUNT
          IF gt_rseg-kschl = 'R001' OR gt_rseg-kschl = 'R002' OR gt_rseg-kschl = 'R003'.
            gt_final-discount = gt_final-discount + gt_rseg-wrbtr.
          ENDIF.

***** Basic Customs
          IF gt_rseg-kschl = 'JCDB'.
            gt_final-basic_cust = gt_final-basic_cust + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

***** CVD
          IF gt_rseg-kschl = 'JCV1'.
            gt_final-cvd = gt_final-cvd + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

***** Customs ECess
          IF gt_rseg-kschl = 'JECV' OR gt_rseg-kschl = 'JCZ2'.
            gt_final-cust_cess = gt_final-cust_cess + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

***** Socila Welfare
          IF gt_rseg-kschl = 'ZSWS' .
            gt_final-wrbtr = gt_rseg-wrbtr.
*            gt_final-cust_cess = gt_final-cust_cess + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

***** Customs HECess
          IF gt_rseg-kschl = 'JCZ4'.
*          if gt_rseg-kschl = 'JSED'.""Gt_rseg-kschl = 'JSDB'.
            gt_final-cust_hcess = gt_final-cust_hcess + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

***** Add. CVD
          IF gt_rseg-kschl = 'JADC'.
            gt_final-add_cvd = gt_final-add_cvd + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

***** Freight
          IF gt_rseg-kschl = 'ZRB1' OR gt_rseg-kschl = 'ZRC1' OR gt_rseg-kschl = 'FRA1'.
*          OR gt_rseg-kschl = 'ZFR1' OR gt_rseg-kschl = 'JOFV' OR gt_rseg-kschl = 'JOFP'.
            gt_final-freight = gt_final-freight + gt_rseg-wrbtr .
          ENDIF.

***** LBT
          IF gt_rseg-kschl = 'JOCM'.
            gt_final-lbt = gt_final-lbt + gt_rseg-wrbtr .
          ENDIF.

*****Inspection Charge
          IF gt_rseg-kschl = 'ZINS'.
            gt_final-insp = gt_final-insp + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

*****Setting Charge
          IF gt_rseg-kschl = 'ZSCV' OR gt_rseg-kschl = 'ZSCQ'.
            gt_final-set_val = gt_final-set_val + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.


*****Insurance
          IF gt_rseg-kschl = 'ZINR'.
            gt_final-ins = gt_final-ins + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

*****Devlopment Charges
          IF gt_rseg-kschl = 'ZDV%' OR gt_rseg-kschl = 'ZDVQ' OR gt_rseg-kschl = 'ZDVV'.
            gt_final-dev_ch = gt_final-dev_ch + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

*****Other Charges
          IF gt_rseg-kschl = 'ZOCV' OR gt_rseg-kschl = 'ZOCQ' OR gt_rseg-kschl = 'ZOC%'.
            gt_final-oth_ch = gt_final-oth_ch + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

*****Comp Cess %
          IF gt_rseg-kschl = 'ZCES'.
            gt_final-com_p = gt_final-com_p + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.

*****Comp Cess Val
          IF gt_rseg-kschl = 'ZCEV'.
            gt_final-com_v = gt_final-com_v + ( gt_rseg-wrbtr * gt_final-kursf ).
          ENDIF.
***** FORWARDING
***        if gt_rseg-kschl = ''.
***          gt_final-forwarding = gt_final-forwarding + gt_rseg-wrbtr .
***        endif.

**** CLEARING
          IF gt_rseg-kschl = 'JCFA' OR gt_rseg-kschl = 'ZCFA' OR gt_rseg-kschl = 'JFR2'.
            gt_final-clearing = gt_final-clearing + gt_rseg-wrbtr .
          ENDIF.
        ENDLOOP.



****** Check if debit or Credit
**    read table gt_rseg with key  belnr = gt_bkpf-g_belnr
**                                 gjahr = gt_bkpf-g_gjahr.
**    if sy-subrc = 0.
        IF gt_rseg_v1-shkzg = 'H'.
          gt_final-basic = gt_final-basic * -1.
          gt_final-packing = gt_final-packing * -1.
          gt_final-insp = gt_final-insp * -1.
          gt_final-set_val = gt_final-set_val * -1.
          gt_final-ins = gt_final-ins * -1.
          gt_final-dev_ch = gt_final-dev_ch * -1.
          gt_final-oth_ch = gt_final-oth_ch * -1.
          gt_final-discount = gt_final-discount * -1.
          gt_final-bed      = gt_final-bed * -1.
          gt_final-aed = gt_final-aed * -1.
*          gt_final-ecs = gt_final-ecs * -1.
*          gt_final-hcess = gt_final-hcess * -1.
*          gt_final-ecs_cr = gt_final-ecs_cr * -1.       "Benz, 25.11.2016
*          gt_final-hcess_cr = gt_final-hcess_cr * -1.   "Benz, 25.11.2016
          gt_final-vat_tax = gt_final-vat_tax * -1.
          gt_final-cst_tax = gt_final-cst_tax * -1.
*          gt_final-ser_val_cr = gt_final-ser_val_cr * -1. "Benz, 25.11.2016
*          gt_final-sbc_cr = gt_final-sbc_cr * -1.
*          gt_final-kkc_cr = gt_final-kkc_cr * -1.
**** B.O.C Bency 06.12.2016
**          gt_final-sertaxcess_cr  = gt_final-sertaxcess_cr * -1.
*          gt_final-hsertaxcess_cr = gt_final-hsertaxcess_cr * -1.
**** E.O.C Bency 06.12.2016
          gt_final-basic_cust = gt_final-basic_cust * -1.
          gt_final-cvd = gt_final-cvd * -1.
          gt_final-cust_cess = gt_final-cust_cess * -1.
          gt_final-cust_hcess = gt_final-cust_hcess * -1.
          gt_final-add_cvd = gt_final-add_cvd * -1.
          gt_final-freight = gt_final-freight * -1.

          gt_final-cgst_tax     = gt_final-cgst_tax * -1.
          gt_final-sgst_tax     = gt_final-sgst_tax * -1.
          gt_final-igst_tax     = gt_final-igst_tax * -1.
          gt_final-com_p        = gt_final-com_p * -1.
          gt_final-com_v        = gt_final-com_v * -1.
        ENDIF.

*** NET TOTAL
        gt_final-net_total = gt_final-basic
                           + gt_final-packing
                           + gt_final-insp
                           + gt_final-set_val
                           + gt_final-ins
                           + gt_final-dev_ch
                           + gt_final-oth_ch
*                           - gt_final-discount
                           + gt_final-bed
                           + gt_final-aed
                           + gt_final-ecs
                           + gt_final-hcess.


*** GROSS TOTAL
        gt_final-gross_tot = gt_final-net_total
                           + gt_final-vat_tax
                           + gt_final-cst_tax
                           - gt_final-ecs_cr
                           - gt_final-hcess_cr
                           - gt_final-ser_val_cr
*                           - gt_final-sbc_cr
*                           - gt_final-kkc_cr
*                           - gt_final-sertaxcess_cr     "Added by Bency 06.12.2016
*                           - gt_final-hsertaxcess_cr    "Added by Bency 06.12.2016
                           + gt_final-ecs_dr
                           + gt_final-hcess_dr
                           + gt_final-ser_val_dr
                           + gt_final-sbc_dr
                           + gt_final-kkc_dr
*                           + gt_final-sertaxcess_dr     "Added by Bency 06.12.2016
*                           + gt_final-hsertaxcess_dr    "Added by Bency 06.12.2016

                           + gt_final-basic_cust
                           + gt_final-cvd
                           + gt_final-cust_cess
                           + gt_final-cust_hcess
                           + gt_final-add_cvd
                           + gt_final-freight
                           + gt_final-lbt
**                           + gt_final-forwarding
**                           + gt_final-clearing
**                           + gt_final-tds_dc
                           + lv_cgst "gt_final-cgst_tax
                           + lv_sgst "gt_final-sgst_tax
                           + lv_igst "gt_final-igst_tax
                           + gt_final-com_p
                           + gt_final-com_v.
**                           + gt_final-cgst_ns_tax
**                           + gt_final-sgst_ns_tax
**                           + gt_final-igst_ns_tax
**                           + gt_final-igst_tax_im.
**                           + gt_final-cgst_rc_tax
**                           + gt_final-sgst_rc_tax
**                           + gt_final-cgst_nrc_tax
**                           + gt_final-sgst_nrc_tax.

*** GROSS TOTAL WITHOUT TDS
        gt_final-gross_tot_tds = gt_final-gross_tot - gt_final-tds_dc.

        IF gt_final-basic IS NOT INITIAL.
          gt_final-basic_lc = gt_final-basic * gt_final-kursf.
        ENDIF.

        IF gt_final-packing IS NOT INITIAL.
          gt_final-packing_lc = gt_final-packing * gt_final-kursf.
        ENDIF.

***        IF gt_final-discount IS NOT INITIAL.
***          gt_final-discount_lc = gt_final-discount * gt_final-kursf.
***        ENDIF.

        IF gt_final-freight IS NOT INITIAL.
          gt_final-freight_lc = gt_final-freight * gt_final-kursf.
        ENDIF.

***        IF gt_final-forwarding IS NOT INITIAL.
***          gt_final-forwarding_lc = gt_final-forwarding * gt_final-kursf.
***        ENDIF.

**        IF gt_final-clearing IS NOT INITIAL.
**          gt_final-clearing_lc = gt_final-clearing * gt_final-kursf.
**        ENDIF.


        IF NOT gt_rbkp-stblg IS INITIAL.
          gt_final-basic_lc = 0.
          gt_final-packing_lc = 0.
          gt_final-insp = 0.
          gt_final-set_val = 0.
          gt_final-ins = 0.
          gt_final-freight_lc = 0.
          gt_final-dev_ch = 0.
          gt_final-oth_ch = 0.
          gt_final-bed = 0.
          gt_final-aed = 0.
          gt_final-ecs = 0.
          gt_final-hcess = 0.
          gt_final-cgst_tax = 0.
          gt_final-sgst_tax = 0.
          gt_final-igst_tax = 0.
          gt_final-com_p = 0.
          gt_final-com_v = 0.
          gt_final-vat_tax = 0.
          gt_final-cst_tax = 0.
          gt_final-gross_tot = 0.
          gt_final-ser_val_dr = 0.
          gt_final-sbc_dr = 0.
          gt_final-kkc_dr = 0.
        ENDIF.

*** Assessable GST (LC)
        gt_final-net_total_lc = gt_final-basic_lc
                           + gt_final-packing_lc
                           + gt_final-insp
                           + gt_final-set_val
                           + gt_final-ins
                           + gt_final-freight_lc
                           + gt_final-dev_ch
                           + gt_final-oth_ch
*                           - gt_final-discount_lc
                           + gt_final-bed
                           + gt_final-aed
                           + gt_final-ecs
                           + gt_final-hcess.

*****Tot GST Amt
        gt_final-gst_amt =
                gt_final-cgst_tax + gt_final-sgst_tax
                + gt_final-igst_tax + gt_final-com_p + gt_final-com_v.

********Total Tax Amount
        gt_final-tot_tax = "gt_final-gst_amt
                lv_cgst + lv_sgst + lv_igst + gt_final-basic_cust + gt_final-cust_cess + gt_final-cust_hcess + gt_final-add_cvd
                + gt_final-vat_tax + gt_final-cst_tax + gt_final-ser_val_dr + gt_final-sbc_dr + gt_final-kkc_dr.

*** GROSS TOTAL (LC)
        gt_final-gross_tot_lc = gt_final-tot_tax + gt_final-net_total_lc.



*** GROSS TOTAL WITHOUT TDS (LC)
        gt_final-gross_tot_lc_tds = gt_final-gross_tot_lc - gt_final-tds_lc.


        SHIFT gt_final-xblnr_alt LEFT DELETING LEADING '0'.
        SHIFT gt_final-belnr LEFT DELETING LEADING '0'.
        SHIFT gt_final-awkey LEFT DELETING LEADING '0'.
        SHIFT gt_final-miro_ac_doc LEFT DELETING LEADING '0'.
        SHIFT gt_final-akont LEFT DELETING LEADING '0'.
*BREAK primus.

*------------------Refreshable Date / Shift negative sign to left logic ------------------------------------------
        DATA : val1 TYPE string.
        val1 = gt_final-wrbtr.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = val1.
        gt_final-wrbtr = val1.
        CLEAR val1.
        val1 = gt_final-kwert.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = val1.
        gt_final-kwert = val1.
        CLEAR val1.
        val1  = gt_final-menge.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = val1.
        gt_final-menge = val1.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = sy-datum
          IMPORTING
            output = gt_final-ref_date.

        CONCATENATE gt_final-ref_date+0(2) gt_final-ref_date+2(3) gt_final-ref_date+5(4)
                   INTO gt_final-ref_date SEPARATED BY '-'.
*inv_dt


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = gt_final-inv_dt
          IMPORTING
            output = gt_final-inv_dt.

        CONCATENATE gt_final-inv_dt+0(2) gt_final-inv_dt+2(3) gt_final-inv_dt+5(4)
                    INTO gt_final-inv_dt SEPARATED BY '-'.
*        aedat
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input  = gt_final-aedat
*          IMPORTING
*            output = gt_final-AEDAT.
*
*        CONCATENATE gt_final-aedat+0(2) gt_final-aedat+2(3) gt_final-aedat+5(4)
*                    into gt_final-aedat SEPARATED BY '-'.

*        budat
*      BREAK PRIMUS.
*      IF GT_FINAL-BUDAT IS NOT INITIAL.
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'                       "UNCOMMENTED BY SNEHAL RAJALE ON 2 APRIL 2021.
*          EXPORTING
*            input  = gt_final-budat
*          IMPORTING
*            output = gt_final-budat.
*
*       CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
*                   into gt_final-budat SEPARATED BY '-'.
*     ENDIF.
*         bill_dt
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'    "comment out by swati on 21.02.2019
          EXPORTING
            input  = gt_final-bill_dt
          IMPORTING
            output = gt_final-bill_dt.

        CONCATENATE gt_final-bill_dt+0(2) gt_final-bill_dt+2(3) gt_final-bill_dt+5(4)
                    INTO gt_final-bill_dt SEPARATED BY '-'.

*       eindt
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input = gt_final-eindt
*          IMPORTING
*            output = gt_final-eindt.
*
*        CONCATENATE gt_final-eindt+0(2) gt_final-eindt+2(3) gt_final-eindt+5(4)
*                   into gt_final-eindt SEPARATED BY '-'.

*        SELECT SINGLE infnr INTO gt_final-infnr FROM eine WHERE ebeln = gt_final-ebeln AND ebelp = gt_final-ebelp.

        APPEND gt_final.  "Commented 09.11.2016
*        CLEAR: gt_final,gt_rseg,lv_igst,lv_cgst,lv_igst.  "Commented 09.11.2016


        CLEAR :
          gt_final, gt_with_item, gt_rbkp, gt_lfa1,lv_igst,lv_cgst,lv_igst,gt_t005u, gt_j_1imovend,ls_eket,ls_bseg,
          gt_rseg_v1, gt_bkpf_we,gt_rseg, gt_ekbe_imp, gt_bkpf_imp, gt_makt,gt_ekko, gt_ekpo, gt_bset,ls_t163y.



      ENDIF. "end gt_rbkp
    ENDIF. " end gt_bkpf   """  checking condn gt_rseg_v1
  ENDLOOP. "" *****      END RSEG



****************************** start of changes by shreya 27-10-2021********************************************
  LOOP AT lt_mseg INTO DATA(wa_mseg).

*    REPLACE ALL OCCURRENCES OF '.' IN gt_final-bktxt WITH '-'.
    READ TABLE gt_rseg_v1 INTO DATA(wa_rseg) WITH KEY lfbnr = wa_mseg-mblnr
                                                      lfgja = wa_mseg-mjahr
                                                      lfpos = wa_mseg-zeile.

    IF sy-subrc NE 0.

      READ TABLE lt_bkpf INTO DATA(ls_bkpf) WITH KEY awkey = wa_mseg-awkey.

      IF sy-subrc = 0.
        gt_final-belnr = ls_bkpf-belnr.
      ENDIF.

      gt_final-lfbnr = wa_mseg-mblnr.

      CALL FUNCTION 'CONVERSION_EXIT_SDATE_OUTPUT'
        EXPORTING
          input  = wa_mseg-budat_mkpf
        IMPORTING
          output = gt_final-budat.
      REPLACE ALL OCCURRENCES OF '.' IN gt_final-budat WITH '-'.

*      gt_final-BUDAT = wa_mseg-budat_mkpf.
      READ TABLE gt_ekpo INTO DATA(wa_ekpo) WITH KEY ebeln = wa_mseg-ebeln
                                                     ebelp = wa_mseg-ebelp.
      IF sy-subrc = 0.
        READ TABLE gt_ekko INTO DATA(wa_ekko) WITH KEY ebeln = wa_mseg-ebeln.
        IF sy-subrc = 0.

          gt_final-lifnr = wa_ekko-lifnr.


        ENDIF.
      ENDIF.
*      READ TABLE gt_lfa1 WITH KEY lifnr = gt_final-lifnr.
      SELECT SINGLE lifnr
                    name1
                    regio
                    ort01
                    land1
                    adrnr
                    stcd3
        FROM lfa1 INTO gt_lfa1 WHERE lifnr = wa_ekko-lifnr.
      IF sy-subrc = 0.
        gt_final-name1 = gt_lfa1-name1.    " Vendor Name
        gt_final-stcd3 = gt_lfa1-stcd3.

        READ TABLE gt_t005u WITH KEY bland = gt_lfa1-regio.
        IF sy-subrc = 0.
          gt_final-bezei = gt_t005u-bezei. " State
        ENDIF.
        READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = gt_t005u-bezei.
        IF sy-subrc IS INITIAL.
          gt_final-gst_region = ls_zgst_region-gst_region.
        ENDIF.
        SELECT SINGLE addrnumber,
                      name1,
                      city2,
                      post_code1,
                      street,
                      str_suppl3,
                      location,
                      country
          FROM adrc INTO @DATA(wa_adrc) WHERE addrnumber = @gt_lfa1-adrnr.
        IF sy-subrc IS INITIAL.
          IF NOT wa_adrc-street IS INITIAL.
            CONCATENATE gt_final-address wa_adrc-street INTO gt_final-address.
          ENDIF.

          IF NOT wa_adrc-str_suppl3 IS INITIAL.
            CONCATENATE gt_final-address wa_adrc-str_suppl3 INTO gt_final-address SEPARATED BY ','.
          ENDIF.
          IF NOT wa_adrc-location IS INITIAL.
            CONCATENATE gt_final-address wa_adrc-location INTO gt_final-address SEPARATED BY ','.
          ENDIF.

          IF NOT wa_adrc-city2 IS INITIAL.
            CONCATENATE gt_final-address wa_adrc-city2 INTO gt_final-address SEPARATED BY ','.
          ENDIF.
          IF NOT wa_adrc-post_code1 IS INITIAL.
            CONCATENATE gt_final-address 'PIN:' wa_adrc-post_code1 INTO gt_final-address SEPARATED BY ','.
          ENDIF.
          CONDENSE gt_final-address.

        ENDIF.

        READ TABLE gt_j_1imovend WITH KEY lifnr = gt_lfa1-lifnr.
        IF sy-subrc = 0.
          gt_final-tin_no =   gt_j_1imovend-j_1icstno.
          gt_final-lst_no =   gt_j_1imovend-j_1ilstno.

          IF gt_j_1imovend-j_1issist = '1'.
            gt_final-j_1issist = 'Micro'.
          ELSEIF gt_j_1imovend-j_1issist = '2'.
            gt_final-j_1issist = 'Small'.
          ELSEIF gt_j_1imovend-j_1issist = '3'.
            gt_final-j_1issist = 'Medium'.
          ELSEIF gt_j_1imovend-j_1issist = '4'.
            gt_final-j_1issist = 'NA'.
          ENDIF.

        ENDIF.
        READ TABLE lt_dd07t INTO ls_dd07t WITH KEY domvalue_l = gt_j_1imovend-ven_class.
        IF sy-subrc IS INITIAL.
          gt_final-gst_txt = ls_dd07t-ddtext.
        ENDIF.
        READ TABLE gt_lfb1 WITH KEY lifnr = gt_lfa1-lifnr.
        IF sy-subrc = 0.
          gt_final-akont = gt_lfb1-akont.
        ENDIF.
      ENDIF.
    ENDIF.

    APPEND gt_final.
    DELETE gt_final WHERE lifnr = ''.
    CLEAR :
          gt_final, gt_with_item, gt_rbkp, gt_lfa1,lv_igst,lv_cgst,lv_igst,gt_t005u, gt_j_1imovend,ls_eket,ls_bseg,
          gt_rseg_v1, gt_bkpf_we,gt_rseg, gt_ekbe_imp, gt_bkpf_imp, gt_makt,gt_ekko, gt_ekpo, gt_bset,ls_t163y.


  ENDLOOP.


******************************************* end of changes by shreya 27-10-2021 *******************************************
*BREAK primus.
  LOOP AT gt_final.
    it_final-ekorg            = gt_final-ekorg           .
    it_final-lifnr            = gt_final-lifnr           .
    it_final-name1            = gt_final-name1           .
    it_final-address          = gt_final-address         .
    it_final-stcd3            = gt_final-stcd3           .
    it_final-gst_txt          = gt_final-gst_txt         .
    it_final-gst_region       = gt_final-gst_region      .
    it_final-bezei            = gt_final-bezei           .
    it_final-xblnr_alt        = gt_final-xblnr_alt       .
    it_final-inv_no           = gt_final-inv_no          .
    it_final-inv_dt           = gt_final-inv_dt          .
    it_final-ebeln            = gt_final-ebeln           .
    it_final-aedat            = gt_final-aedat           .
    it_final-ebelp            = gt_final-ebelp           .
    it_final-pstyp            = gt_final-pstyp           .
    it_final-knttp            = gt_final-knttp           .
    it_final-lfbnr            = gt_final-lfbnr           .
    it_final-budat            = gt_final-budat           .
    it_final-belnr            = gt_final-belnr           .
    it_final-grn_amt          = gt_final-grn_amt         .

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-grn_amt .

    it_final-zuonr            = gt_final-zuonr           .
    it_final-bktxt            = gt_final-bktxt           .
    it_final-awkey            = gt_final-awkey           .
    it_final-miro_ac_doc      = gt_final-miro_ac_doc     .
    it_final-blart            = gt_final-blart           .
    it_final-bill_dt          = gt_final-bill_dt         .
    it_final-hkont            = gt_final-hkont           .
    it_final-txt20            = gt_final-txt20           .
    it_final-steuc            = gt_final-steuc           .
    it_final-matnr            = gt_final-matnr           .
    it_final-long_txt         = gt_final-long_txt        .
    it_final-mtart            = gt_final-mtart           .
    it_final-eindt            = gt_final-eindt           .
    it_final-po_qty           = gt_final-po_qty          .
    it_final-lsmng            = gt_final-lsmng           .
    it_final-menge            = gt_final-menge           .
    it_final-acc_qty          = gt_final-acc_qty         .
    it_final-rej_qty          = gt_final-rej_qty         .
    it_final-scp_qty          = gt_final-scp_qty         .
    it_final-rew_qty          = gt_final-rew_qty         .
    it_final-waers            = gt_final-waers           .
    it_final-kursf            = gt_final-kursf           .
    it_final-rate             = gt_final-rate            .
    it_final-basic            = gt_final-basic           .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-basic .
    it_final-basic_lc         = gt_final-basic_lc        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-basic_lc .
    it_final-packing_lc       = gt_final-packing_lc      .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-packing_lc .
    it_final-insp             = gt_final-insp            .
    it_final-set_val          = gt_final-set_val         .
    it_final-freight_lc       = gt_final-freight_lc      .
    it_final-ins              = gt_final-ins             .
    it_final-oth_ch           = gt_final-oth_ch          .
    it_final-dev_ch           = gt_final-dev_ch          .
    it_final-net_total_lc     = gt_final-net_total_lc    .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-net_total_lc .
    it_final-mwskz            = gt_final-mwskz           .
    it_final-text1            = gt_final-text1           .
    it_final-bed              = gt_final-bed             .
    it_final-aed              = gt_final-aed             .
    it_final-vat_tax          = gt_final-vat_tax         . ""**
    it_final-cst_tax          = gt_final-cst_tax         .
    it_final-ser_val_dr       = gt_final-ser_val_dr      .
    it_final-sbc_dr           = gt_final-sbc_dr          .
    it_final-kkc_dr           = gt_final-kkc_dr          . "" **
    it_final-cgst             = gt_final-cgst            .

    it_final-cgst_tax         = gt_final-cgst_tax        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-cgst_tax .
    it_final-sgst             = gt_final-sgst            .
    it_final-sgst_tax         = gt_final-sgst_tax        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-sgst_tax .
    it_final-igst             = gt_final-igst            .
    it_final-igst_tax         = gt_final-igst_tax        .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-igst_tax .
    it_final-com_p            = gt_final-com_p           .
    it_final-com_v            = gt_final-com_v           .
    it_final-gst_amt          = gt_final-gst_amt         .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-gst_amt .
    it_final-basic_cust       = gt_final-basic_cust      . "" **
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-basic_cust .
    it_final-cvd              = gt_final-cvd             .
    it_final-cust_cess        = gt_final-cust_cess       .
    it_final-cust_hcess       = gt_final-cust_hcess      .
    it_final-wrbtr            = gt_final-wrbtr           .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-wrbtr .
    it_final-add_cvd          = gt_final-add_cvd         .
    it_final-tot_tax          = gt_final-tot_tax         . ""**
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-tot_tax .
    it_final-gross_tot     = gt_final-gross_tot    .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-gross_tot .
    it_final-gross_tot_lc     = gt_final-gross_tot_lc    .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-gross_tot_lc .
    it_final-anln1            = gt_final-anln1           .
    it_final-anln2            = gt_final-anln2           .
    it_final-invnr            = gt_final-invnr           .
    it_final-txt50            = gt_final-txt50           .
    it_final-sakto            = gt_final-sakto           .
    it_final-ass_amt          = gt_final-ass_amt         .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = it_final-ass_amt .
    it_final-zseries          = gt_final-zseries         .
    it_final-zsize            = gt_final-zsize           .
    it_final-brand            = gt_final-brand           .
    it_final-moc              = gt_final-moc             .
    it_final-type             = gt_final-type            .
*    it_final-kwert            = gt_final-kwert           .
*    it_final-akont            = gt_final-akont           .
*    it_final-maktx            = gt_final-maktx           .
*    it_final-werks            = gt_final-werks           .
*    it_final-ecs              = gt_final-ecs             .
*    it_final-hcess            = gt_final-hcess           .
*    it_final-ecs_dr           = gt_final-ecs_dr          .
*    it_final-hcess_dr         = gt_final-hcess_dr        .
    it_final-vat              = gt_final-vat             .
    it_final-cst              = gt_final-cst             .

*    it_final-ecs_cr           = gt_final-ecs_cr          .
*    it_final-hcess_cr         = gt_final-hcess_cr        .
*    it_final-ser_val_cr       = gt_final-ser_val_cr      .
*    it_final-sbc_cr           = gt_final-sbc_cr          .
*    it_final-kkc_cr           = gt_final-kkc_cr          .
*    it_final-packing          = gt_final-packing         .
*    it_final-discount         = gt_final-discount        .
*    it_final-discount_lc      = gt_final-discount_lc     .
*    it_final-freight          = gt_final-freight         .
*    it_final-lbt              = gt_final-lbt             .
*    it_final-forwarding       = gt_final-forwarding      .
*    it_final-forwarding_lc    = gt_final-forwarding_lc   .
*    it_final-clearing         = gt_final-clearing        .
*    it_final-clearing_lc      = gt_final-clearing_lc     .
*    it_final-tds_dc           = gt_final-tds_dc          .
*    it_final-tds_lc           = gt_final-tds_lc          .
*    it_final-tds_flag         = gt_final-tds_flag        .
*    it_final-gross_tot        = gt_final-gross_tot       .
*    it_final-gross_tot_tds    = gt_final-gross_tot_tds   .
*    it_final-gross_tot_lc_tds = gt_final-gross_tot_lc_tds.
*    it_final-tin_no           = gt_final-tin_no          .
*    it_final-lst_no           = gt_final-lst_no          .
*    it_final-tcode            = gt_final-tcode           .
*    it_final-net_total        = gt_final-net_total       .
    it_final-ref_date         = gt_final-ref_date        .
    it_final-bldat         = gt_final-bldat        .
    it_final-meins         = gt_final-meins        .
    it_final-bsart         = gt_final-bsart        .
    it_final-infnr         = gt_final-infnr.
    it_final-j_1issist     = gt_final-j_1issist.
    it_final-prepay_awkey = gt_final-prepay_awkey.

******************************** pj
    it_final_down-lifnr  = gt_final-lifnr.
    it_final_down-name1                 = gt_final-name1 .
    it_final_down-miro_ac_doc           = gt_final-miro_ac_doc .
    it_final_down-bill_dt           = gt_final-bill_dt .
*    it_final_down-PREPAY_AWKEY              = gt_final-PREPAY_AWKEY.
    it_final_down-inv_no                 = it_final-inv_no  .
    it_final_down-inv_dt                = gt_final-inv_dt   .
    it_final_down-lfbnr                 = gt_final-lfbnr    .
    it_final_down-budat                 = gt_final-budat   .
    it_final_down-belnr                 = gt_final-belnr   .
    IF gt_final-net_total_lc IS NOT INITIAL.
      it_final_down-net_total_lc          = gt_final-net_total_lc.
    ENDIF.
    IF gt_final-tot_tax IS NOT INITIAL.
      it_final_down-tot_tax               = gt_final-tot_tax .
    ENDIF.
    IF gt_final-gross_tot_lc IS NOT INITIAL.
      it_final_down-gross_tot_lc          = gt_final-gross_tot_lc.
    ENDIF.

    APPEND it_final_down.
    APPEND it_final.
    CLEAR : gt_final, it_final_down.
  ENDLOOP.
*  BREAK primus.


  PERFORM f_listheader.
  PERFORM f_fieldcatalog.
  PERFORM f_layout.
  PERFORM f_displaygrid.

ENDFORM.                    " GET_DATA


*&---------------------------------------------------------------------*
*&      Form  f_listheader
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM f_listheader .

  DATA : frmdt(10) TYPE c,
         todt(10)  TYPE c,
         v_str     TYPE string.


  gt_listheader-typ = 'H'.
  gt_listheader-key = ' '.
  gt_listheader-info = 'GRN Posting'.
  APPEND gt_listheader.

  IF s_budat-low NE '00000000' AND  s_budat-high NE '00000000'      .
    WRITE s_budat-low  TO frmdt USING EDIT MASK '__.__.____'.
    WRITE s_budat-high TO todt  USING EDIT MASK '__.__.____'.
    CONCATENATE 'FROM'
                 frmdt
                 'TO'
                 todt
           INTO v_str SEPARATED BY space.
  ELSEIF s_budat-low NE '00000000' AND  s_budat-high EQ '00000000'      .
    WRITE s_budat-low  TO frmdt USING EDIT MASK '__.__.____'.
    CONCATENATE 'ON'
                 frmdt
           INTO v_str SEPARATED BY space.
  ELSEIF s_budat-low EQ '00000000' AND  s_budat-high NE '00000000'      .
    WRITE s_budat-high  TO todt USING EDIT MASK '__.__.____'.
    CONCATENATE 'ON'
                 todt
           INTO v_str SEPARATED BY space.
  ENDIF.
  gt_listheader-typ = 'S'.
  gt_listheader-key = ' '.
  gt_listheader-info = v_str.
  APPEND gt_listheader.


ENDFORM. " f_listheader

*&---------------------------------------------------------------------*
*&      Form  f_fieldcatalog
*&---------------------------------------------------------------------*

FORM f_fieldcatalog .

****>>> 12. Vendor No.
  gt_fieldcatalog-fieldname = 'LIFNR'.
  gt_fieldcatalog-seltext_l = 'Vendor'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
  gt_fieldcatalog-no_zero   = 'X'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 13. Vendor Name
  gt_fieldcatalog-fieldname = 'NAME1'.
  gt_fieldcatalog-seltext_l = 'Vendor Name'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


****>>> 5. MIRO A/c Doc No.
  gt_fieldcatalog-fieldname = 'MIRO_AC_DOC'.
  gt_fieldcatalog-seltext_l = 'Posting No.'.
  gt_fieldcatalog-hotspot       = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 6. Bill Booking Date
  gt_fieldcatalog-fieldname = 'BILL_DT'.
  gt_fieldcatalog-seltext_l = 'Posting Date'.
  gt_fieldcatalog-no_zero   = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 7. Inv/Bill No.
  gt_fieldcatalog-fieldname = 'INV_NO'."'XBLNR_ALT'.pj 30-09-21
  gt_fieldcatalog-seltext_l = 'Invoice No.'.
  gt_fieldcatalog-no_zero = 'x'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 8. INV DATE TIME
  gt_fieldcatalog-fieldname = 'INV_DT'.
  gt_fieldcatalog-seltext_l = 'Invoice Date'.
  gt_fieldcatalog-no_zero   = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 1. Migo number
  gt_fieldcatalog-fieldname = 'LFBNR'.
  gt_fieldcatalog-seltext_l = 'GRN No.'.
  gt_fieldcatalog-no_zero   = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 2. Migo Date
  gt_fieldcatalog-fieldname = 'BUDAT'.
  gt_fieldcatalog-seltext_l = 'GRN Date'.
  gt_fieldcatalog-no_zero   = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 3. FI document No.
  gt_fieldcatalog-fieldname = 'BELNR'.
  gt_fieldcatalog-seltext_l = 'GRN FI Document No.'.
  gt_fieldcatalog-no_zero   = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  gt_fieldcatalog-hotspot       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 33. Assessable GST
  gt_fieldcatalog-fieldname = 'NET_TOTAL_LC'.
  gt_fieldcatalog-seltext_l = 'Assessable Amt'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  gt_fieldcatalog-no_zero   = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> Total Tax Amt
  gt_fieldcatalog-fieldname = 'TOT_TAX'.
  gt_fieldcatalog-seltext_l = 'Tax Amt.'.
  gt_fieldcatalog-no_zero   = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 59. GROSS TOTAL (LC)
  gt_fieldcatalog-fieldname = 'GROSS_TOT_LC'.
  gt_fieldcatalog-seltext_l = 'Gross Amt'.
  gt_fieldcatalog-no_zero   = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

ENDFORM. " f_fieldcatalog



*&---------------------------------------------------------------------*
*&      Form  f_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM f_layout .

  gt_event-name = slis_ev_top_of_page.
  gt_event-form = 'TOP_OF_PAGE'.
  APPEND gt_event.
  gt_layout-colwidth_optimize = 'X'.
ENDFORM. " f_layout

*&---------------------------------------------------------------------*
*&      Form  f_displaygrid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM f_displaygrid .

*  BREAK primus.
  IF p_down = 'X'.
    PERFORM download.
**    PERFORM gui_download.

  ELSE.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program      = sy-repid
        i_callback_user_command = 'USER_CMD'
        i_callback_top_of_page  = 'TOP_OF_PAGE'
        is_layout               = gt_layout
        it_fieldcat             = gt_fieldcatalog[]
        it_sort                 = gt_sort[]
        it_events               = gt_event[]
        i_save                  = 'A'
      TABLES
        t_outtab                = gt_final
      EXCEPTIONS
        program_error           = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.

* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
ENDFORM. " f_displaygrid

*&---------------------------------------------------------------------*
*&      Form  top_of_page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM top_of_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = gt_listheader[].

ENDFORM. "top_of_page

*&---------------------------------------------------------------------*
*&      Form  USER_CMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM user_cmd USING r_ucomm LIKE sy-ucomm
                    rs_selfield TYPE slis_selfield.
  DATA:
     lv_bukrs TYPE bkpf-bukrs VALUE '1000'   .
  CASE r_ucomm.
    WHEN '&IC1'. "for double click
      IF rs_selfield-fieldname = 'MIRO_AC_DOC'.
        SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
        SET PARAMETER ID 'BUK' FIELD lv_bukrs.
*        SET PARAMETER ID 'GJR' FIELD s_gjahr-low."pj
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
      IF rs_selfield-fieldname = 'BELNR'.
        SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
        SET PARAMETER ID 'BUK' FIELD lv_bukrs.
*        SET PARAMETER ID 'GJR' FIELD s_gjahr-low."pj
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
      IF rs_selfield-fieldname = 'EBELN'.
        SET PARAMETER ID 'BES' FIELD rs_selfield-value.
        CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
      ENDIF.
  ENDCASE.
ENDFORM.                    "USER_CMD
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
*  BREAK primus.


  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final_down "gt_final
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
  lv_file = 'GRN_Posting.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'GRN Posting Download started on', sy-datum, 'at', sy-uzeit.
  WRITE: / 'Dest. File:', lv_fullfile.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_fullfile.
  CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
  MESSAGE lv_msg TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING     pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE "'Purchase Org.'
              'Vendor'
              'Vendor Name'
              'Posting No.'
              'Posting Date'
              'Invoice No.'
              'Invoice Date'
              'GRN No'
              'GRN Date'
              'GRN FI Document No.'
              'Assessable Amt.'
              'Tax Amt.'
              'Gross Amt.'
              INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM gui_download .
  DATA file TYPE string VALUE 'D:\GRN_POSTING.TXT'.
  TYPES : BEGIN OF ls_fieldname,
            field_name(25),
          END OF ls_fieldname.
  DATA : it_fieldname TYPE TABLE OF ls_fieldname.
  DATA : wa_fieldname TYPE ls_fieldname.
*------------Heading------------------------

  wa_fieldname-field_name = 'Vendor'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Vendor Name'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Posting No.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Posting Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Invoice No.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Invoice Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GRN No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GRN Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GRN FI Document No.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Assessable Amt.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Tax Amt.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Gross Amt.'.
  APPEND wa_fieldname TO it_fieldname.

*--------------------------------------------------------------------*
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE            =
      filename                = file
      filetype                = 'ASC'
*     APPEND                  = ' '
      write_field_separator   = 'X'
    TABLES
      data_tab                = it_final_down
      fieldnames              = it_fieldname
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
