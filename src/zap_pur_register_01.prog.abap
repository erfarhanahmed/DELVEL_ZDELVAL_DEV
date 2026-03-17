*&---------------------------------------------------------------------*
*&  Include           ZFI_PUR_REGISTER_01
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
    lt_bseg        TYPE tt_bseg,                   " local bseg table
    lt_bseg1       TYPE tt_bseg,                   " local bseg table 1
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
BREAK fujiabap.
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
  WHERE gjahr IN s_gjahr "bukrs IN s_bukrs
*    AND gjahr IN s_gjahr
    AND budat IN s_budat
    AND blart IN ('RE','RL','KG','KR','RX')
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
           xrech
           stblg
           zuonr
           bktxt
    FROM rbkp
    INTO TABLE gt_rbkp
    FOR ALL ENTRIES IN gt_bkpf
    WHERE belnr = gt_bkpf-g_belnr
      AND gjahr = gt_bkpf-g_gjahr
      AND tcode IN ('MIRO','MIR7')
      AND rbstat = '5'.

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

      IF gt_lfa1[] IS NOT INITIAL.
        SELECT lifnr akont
          FROM lfb1
          INTO TABLE gt_lfb1
          FOR ALL ENTRIES IN gt_lfa1
          WHERE lifnr = gt_lfa1-lifnr.
*            AND bukrs IN s_bukrs.

      ENDIF.

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
      INTO TABLE gt_rseg BYPASSING BUFFER                " BYPASSING BUFFER by paresh bhoi
      FOR ALL ENTRIES IN gt_rbkp[]
      WHERE belnr = gt_rbkp-belnr
        AND gjahr = gt_rbkp-gjahr
        AND werks IN s_werks
        AND ebeln IN s_ebeln.
*        and bustw = 'RE01'.        " Added to Remove Auto Parked Invoices and not Posted
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
      CONCATENATE lt_rseg-belnr lt_rseg-gjahr                              "lt_rseg-lfbnr lt_rseg-lfgja
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
                                  ebelp = gt_rseg_v1-ebelp ..

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

***********************************perform LT_BSEG.
    IF NOT gt_bkpf_we[] IS INITIAL.
      SELECT bukrs
             belnr
             gjahr
             buzei
             shkzg
             dmbtr
             txgrp            " changed by p l bhoi
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
             txgrp         "changed by p l bhoi
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

*BREAK fujiabap.
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
*  ENDIF.

  IF NOT gt_bkpf_imp[] IS INITIAL.
    SELECT bukrs
           belnr
           gjahr
           buzei
           shkzg
           dmbtr
           txgrp           "changed by p l bhoi
           ktosl
           anln1
           anln2
           hkont
           ebeln
           ebelp
      FROM bseg
      APPENDING TABLE lt_bseg            "UP TO 10 rows
      FOR ALL ENTRIES IN gt_bkpf_imp
      WHERE bukrs = gt_bkpf_imp-bukrs
      AND   belnr = gt_bkpf_imp-belnr
      AND   gjahr = gt_bkpf_imp-gjahr.
  ENDIF.
*  BREAK fujiabap.
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
  INTO TABLE gt_bset BYPASSING BUFFER   "up to 10 rows
  FOR ALL ENTRIES IN gt_bkpf
  WHERE bukrs = gt_bkpf-bukrs
    AND belnr = gt_bkpf-belnr
    AND gjahr = gt_bkpf-gjahr .



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
      FROM mseg
      INTO TABLE lt_mseg
      FOR ALL ENTRIES IN gt_rseg
      WHERE mjahr = gt_rseg-lfgja
      AND   mblnr = gt_rseg-lfbnr
      AND   zeile = gt_rseg-lfpos
      AND   bwart = '101'
      AND   lgort = 'RM01'.
*      AND   insmk = space.

    SELECT prueflos
             ebeln
             ebelp
             mjahr
             mblnr
             zeile
        FROM qals
        INTO TABLE lt_qals
        FOR ALL ENTRIES IN gt_rseg
        WHERE mjahr = gt_rseg-lfgja
        AND   mblnr = gt_rseg-lfbnr
        AND   zeile = gt_rseg-lfpos.
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
          FROM mseg
          APPENDING TABLE lt_mseg
          FOR ALL ENTRIES IN lt_qamb
          WHERE mblnr = lt_qamb-mblnr
          AND   mjahr = lt_qamb-mjahr
*          AND   zeile = lt_qamb-zeile
          AND   bwart = '321'
          AND   xauto = 'X'.

      ENDIF.
    ENDIF.
    SELECT matnr
           maktx
      FROM makt
      INTO TABLE gt_makt
      FOR ALL ENTRIES IN gt_rseg
      WHERE matnr = gt_rseg-matnr
      AND spras = 'EN'.

    SELECT matnr
           mtart
           zseries
           zsize
           brand
           moc
           type
      FROM mara
      INTO TABLE lt_mat_mast
      FOR ALL ENTRIES IN gt_rseg
      WHERE matnr = gt_rseg-matnr.

    SELECT mwskz
           text1
      FROM t007s
      INTO TABLE lt_t007s
      FOR ALL ENTRIES IN gt_rseg
      WHERE mwskz = gt_rseg-mwskz
      AND   kalsm = 'ZTAXIN'.

    SELECT matnr
           werks
           steuc
      FROM marc
      INTO TABLE lt_marc
      FOR ALL ENTRIES IN gt_rseg
      WHERE matnr = gt_rseg-matnr
      AND   werks = gt_rseg-werks.

    SELECT ebeln
           ekorg
           ekgrp
           bsart
           aedat
           revno
    FROM ekko
    INTO TABLE gt_ekko
     FOR ALL ENTRIES IN gt_rseg
    WHERE ebeln = gt_rseg-ebeln.

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
    FROM ekpo
    INTO TABLE gt_ekpo
     FOR ALL ENTRIES IN gt_rseg
    WHERE ebeln = gt_rseg-ebeln
      AND ebelp = gt_rseg-ebelp.

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

  IF gt_ekpo1[] IS NOT INITIAL.
    SELECT ebeln ebelp anln1 anln2 sakto
      FROM ekkn
      INTO TABLE gt_ekkn
      FOR ALL ENTRIES IN gt_ekpo1
      WHERE ebeln = gt_ekpo1-ebeln
        AND ebelp = gt_ekpo1-ebelp.

    IF gt_ekkn[] IS NOT INITIAL.
      SELECT anln1
             anln2
             invnr
             txt50
        FROM anla
        INTO TABLE gt_anla
        FOR ALL ENTRIES IN gt_ekkn
        WHERE anln1 = gt_ekkn-anln1"bukrs IN s_bukrs
*          AND anln1 = gt_ekkn-anln1
          AND anln2 = gt_ekkn-anln2.
    ENDIF.
  ENDIF.

*** Populating FINAL TABLE

  SORT gt_rseg_v1 BY belnr ebeln ebelp.
  SORT gt_rseg    BY belnr ebeln ebelp.

***************************added by paresh bhoi******************

*   CONCATENATE gt_rseg-belnr gt_rseg-gjahr INTO gt_bkpf-awkey.

*****************************************************************
****** New Code for BSET
*BREAK fujiabap.
  LOOP AT gt_rseg[] INTO gt_rseg.
*
*    READ TABLE gt_bkpf[] INTO gt_bkpf WITH KEY gt_bkpf-awkey ..                  "
*
    READ TABLE gt_bkpf WITH KEY g_belnr = gt_rseg-belnr
                                 g_gjahr = gt_rseg-gjahr. "..
    IF sy-subrc = 0.
      LOOP AT gt_bset WHERE  belnr = gt_bkpf-belnr
                         AND gjahr =  gt_bkpf-gjahr.   "gt_bkpf-belnr.
*                        AND txgrp = gt_rseg-buzei.
        MOVE-CORRESPONDING gt_bset TO gt_bset1.
        gt_bset1-ebeln = gt_rseg-ebeln.
        gt_bset1-ebelp = gt_rseg-ebelp.
        APPEND gt_bset1.
        CLEAR  gt_bset1.
      ENDLOOP.
*    APPEND gt_rseg.
    ENDIF.
  ENDLOOP.

*  CLEAR : gt_bkpf-awkey.
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
   " check date
  LOOP AT gt_rseg_v1.
    READ TABLE gt_bkpf WITH KEY g_belnr = gt_rseg_v1-belnr
                                g_gjahr = gt_rseg_v1-gjahr ..

    IF sy-subrc = 0.
      READ TABLE gt_rbkp WITH KEY belnr = gt_bkpf-g_belnr
                                  gjahr = gt_bkpf-g_gjahr ..
      IF sy-subrc = 0.
        gt_final-miro_ac_doc = gt_bkpf-belnr.     " MIRO A/C Doc No
        gt_final-blart       = gt_bkpf-blart.     " FI Doc Type

        IF NOT gt_bkpf-budat IS INITIAL.
        "changed by paresh bhoi"

                           CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                             EXPORTING
                               input         =  gt_bkpf-budat
                            IMPORTING
                              OUTPUT        =   gt_final-bill_dt.


*   CONCATENATE gt_bkpf-budat+6(2) gt_bkpf-budat+4(2) gt_bkpf-budat+0(4) INTO gt_final-bill_dt SEPARATED BY '-'.
CONCATENATE gt_final-bill_dt+0(2) gt_final-bill_dt+2(3) gt_final-bill_dt+5(4) INTO gt_final-bill_dt SEPARATED BY '-'.

*CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
        ELSE.
          gt_final-bill_dt = 'NULL' .
        ENDIF.

        gt_final-awkey       = gt_bkpf-g_belnr.   " Bill Booking No.
        gt_final-inv_no      = gt_bkpf-xblnr.     " Inv/Bill No.
        gt_final-xblnr_alt   = gt_bkpf-xblnr_alt. " ODN.

        IF NOT gt_bkpf-bldat IS INITIAL.
*          CONCATENATE gt_bkpf-bldat+6(2) gt_bkpf-bldat+4(2) gt_bkpf-bldat+0(4) INTO  gt_final-inv_dt SEPARATED BY '-'.
        ELSE.
          gt_final-inv_dt = 'NULL' .
        ENDIF.
        gt_final-tcode       = gt_bkpf-tcode.     " T-Code
        gt_final-waers       = gt_bkpf-waers.     " Document Currency
        gt_final-kursf       = gt_bkpf-kursf.     " Exchange rate
        gt_final-lifnr = gt_rbkp-lifnr.      " Vendor
        gt_final-zuonr = gt_rbkp-zuonr.      " Original Inv No.
        gt_final-bktxt = gt_rbkp-bktxt.      " Original Inv Dt
        REPLACE ALL OCCURRENCES OF '.' IN gt_final-bktxt WITH '-'.
        READ TABLE gt_lfa1 WITH KEY lifnr = gt_rbkp-lifnr ..
        IF sy-subrc = 0.
          gt_final-name1 = gt_lfa1-name1.    " Vendor Name
          gt_final-stcd3 = gt_lfa1-stcd3.
          READ TABLE gt_t005u WITH KEY bland = gt_lfa1-regio ..
          IF sy-subrc = 0.
            gt_final-bezei = gt_t005u-bezei. " State
          ENDIF.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = gt_t005u-bezei ..
          IF sy-subrc IS INITIAL.
            gt_final-gst_region = ls_zgst_region-gst_region.
          ENDIF.
          READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = gt_lfa1-adrnr ..
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
          READ TABLE gt_j_1imovend WITH KEY lifnr = gt_lfa1-lifnr ..
          IF sy-subrc = 0.
            gt_final-tin_no =   gt_j_1imovend-j_1icstno.
            gt_final-lst_no =   gt_j_1imovend-j_1ilstno.
          ENDIF.
          READ TABLE lt_dd07t INTO ls_dd07t WITH KEY domvalue_l = gt_j_1imovend-ven_class ..
          IF sy-subrc IS INITIAL.
            gt_final-gst_txt = ls_dd07t-ddtext.
          ENDIF.
          READ TABLE gt_lfb1 WITH KEY lifnr = gt_lfa1-lifnr ..
          IF sy-subrc = 0.
            gt_final-akont = gt_lfb1-akont.
          ENDIF.
        ENDIF.

*BREAK fujiabap.

        READ TABLE gt_bkpf_we WITH KEY awkey = gt_rseg_v1-awkey ..   " . added by paresh bhoi

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
                                                    ktosl = 'BSX'
                                                    . .              " added by paresh bhoi
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
                                                      ktosl = 'FRL' ..
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
                                      ebelp = gt_rseg_v1-ebelp ..
          IF sy-subrc IS INITIAL.
            CLEAR gt_bkpf_we.
            READ TABLE gt_bkpf_we WITH KEY awkey = lt_rseg-awkey." ..
            IF sy-subrc = 0.
              gt_final-budat = gt_bkpf_we-budat .   " MIGO Date.
              gt_final-belnr = gt_bkpf_we-belnr.    " FI document No.
        "ADDED BY PARESH BHOI
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                input  = gt_bkpf_we-budat
              IMPORTING
                output = gt_final-budat.

            CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
                       INTO gt_final-budat SEPARATED BY '-'.


            ENDIF.
     ENDIF.

          READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_we-bukrs
                                                    belnr = gt_bkpf_we-belnr
                                                    gjahr = gt_bkpf_we-gjahr
                                                    ebelp = gt_rseg_v1-ebelp
                                                    ktosl = 'BSX' ."..
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
                                                    ktosl = 'FRL' ."..
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
                                                 ebelp = gt_final-ebelp ."..
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

*BREAK fujiabap.
**
**ASSESSABLE LC********************************
**LOOP AT gt_rseg WHERE belnr = gt_rbkp-belnr
**                 AND  gjahr = gt_rbkp-gjahr
**                 AND  ebeln = gt_rseg_v1-ebeln
**                 AND  ebelp = gt_rseg_v1-ebelP.
**                AND wrbtr = gt_rseg-wrbtr.            " <gt_rseg_v1-wrbtr> added by paresh bhoi
**
**          PERFORM ASSESSABLE_CAL_GT_RSEG.             "
**
**ENDLOOP.
**
**  PERFORM ASSBLE_GST_CAL.  " ADDING ALL CHARGES , VALUES  *ADDED BY PARESH BHOI.
**************************************************************







****** New Code for BSET
        CLEAR: lv_cgst,lv_sgst,lv_igst.

*****************<<<"CGST & sGST CALCULATION PART>>>*********************************ADDED BY PARESH BHOI
* DATA: gt_bset2 LIKE  gt_bset1.

*SORT LT_BSEG BY BELNR GJAHR KTOSL TXGRP ASCENDING.
        SORT lt_bseg1 BY belnr txgrp ASCENDING.

        SORT gt_bset1[] BY belnr gjahr ebeln ebelp kschl txgrp ASCENDING.   "'hwste ASCENDING.   " use also gt_bset1  remember
        DELETE ADJACENT DUPLICATES FROM gt_bset1 COMPARING belnr gjahr txgrp kschl." hwste .
*DELETE ADJACENT DUPLICATES FROM gt_bset1 COMPARING txgrp kschl hwste.

*BREAK fujiabap.
      clear : lt_tax, ls_tax.
*******************************************************************************************
data : lv_indx type sy-tabix.


BREAK fujiabap.
"erro lt_bseg  without header line add ls_bseg    "lt_resg1[]
***LOOP 1*****>>>>>>LT_BSEG1[]
LOOP AT lt_bseg1[] INTO ls_bseg WHERE ebeln  = gt_rseg_v1-ebeln  "gt_rseg_v1-ebeln       "lt_bseg                    "belnr = gt_bkpf-belnr
                                 AND  ebelp  = gt_rseg_v1-ebelp "gt_rseg_v1-ebelp                            "CHANGED BY P L BHOI
                                 AND  txgrp IS NOT INITIAL.      " AND   belnr  = '5100000032'.

***PARESH BHOI*********************performance improvement*************************
*     READ TABLE gt_bset1[] INTO gt_bset1 WITH key belnr  = ls_bseg-belnr
*                                                 txgrp  = ls_bseg-txgrp
*                                                 ebeln  = ls_bseg-ebeln
*                                                 ebelp  = ls_bseg-ebelp ."..
*
*          CHECK sy-subrc = 0 AND gt_bset1[] IS NOT INITIAL..
*              LV_INDX = SY-tabix.   " CURRENT NO FROM LOOP DATA 1.
************************************************************************************
***LOOP 2****>>>>>>GT_BSET1[]

               LOOP AT gt_bset1[] INTO gt_bset1 WHERE ebelp  = ls_bseg-ebelp
                                                AND  ebeln  = ls_bseg-ebeln
                                                and  belnr  = ls_bseg-belnr
                                                AND    txgrp  = ls_bseg-txgrp.

                     IF ( gt_bset1-belnr = ls_bseg-belnr ).

                           PERFORM calculate_tax.          " CALCULATE RELATED TAXES.
                         ELSE.
                            EXIT.
                     ENDIF.
             ENDLOOP.           " LOOP FOR GT_BSET1           "CHANGED BY P L BHOI
*   CLEAR : LS_BSEG-BELNR , GT_BSET1-belnr.
ENDLOOP.                       " LOOP FOR LT_BSEG1
*****************************************************************************************************************
***************END OF **<<<"CGST & sGST CALCULATION PART>>>*********************************ADDED BY PARESH BHOI

*BREAK fujiabap.

**********Service entry Sheet's MIGO No.
        IF gt_rseg_v1-pstyp = '9'.
          READ TABLE gt_ekbe WITH KEY ebeln = gt_rseg_v1-ebeln
                                      ebelp = gt_rseg_v1-ebelp
                                      lfbnr = gt_rseg_v1-lfbnr ."..  "..
          IF sy-subrc = 0.
            gt_final-lfbnr = gt_ekbe-belnr.   " MIGO No.
            CLEAR gt_bkpf_ses.
            READ TABLE gt_bkpf_ses WITH KEY gjahr = gt_ekbe-gjahr
                                            awkey = gt_ekbe-awkey ."..
            IF sy-subrc = 0.
              gt_final-budat = gt_bkpf_ses-budat .   " MIGO Date.
              gt_final-belnr = gt_bkpf_ses-belnr.    " FI document No.

               CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
                  EXPORTING
                    input  = gt_bkpf_ses-budat
                  IMPORTING
                    output = gt_final-budat.

                CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
                           INTO gt_final-budat SEPARATED BY '-'.





              READ TABLE lt_bseg1 INTO ls_bseg WITH KEY bukrs = gt_bkpf_ses-bukrs
                                                        belnr = gt_bkpf_ses-belnr
                                                        gjahr = gt_bkpf_ses-gjahr
                                                        ebelp = gt_rseg_v1-ebelp
                                                        ktosl = 'KBS' ."..
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
                                      ebelp = gt_rseg_v1-ebelp ..
          IF sy-subrc IS INITIAL.

*          gt_final-lfbnr = gt_rseg_v1-lfbnr.     " MIGO No.
            gt_final-lfbnr = lt_rseg-lfbnr.     " MIGO No.


            READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = lt_rseg-lfbnr
                                                       mjahr = lt_rseg-lfgja
                                                       ebeln = lt_rseg-ebeln
                                                       ebelp = lt_rseg-ebelp
                                                       lgort = 'RM01'
                                                       bwart = '101' ..


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
                                                     ebelp = gt_rseg_v1-ebelp ..
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
                                                                 lgort = 'RM01' ..
                        IF sy-subrc IS INITIAL.
                          gt_final-acc_qty = gt_final-acc_qty + ls_mseg-menge.

                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RJ01' ..
                        IF sy-subrc IS INITIAL.
                          gt_final-rej_qty = gt_final-rej_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'SCR1' ..
                        IF sy-subrc IS INITIAL.
                          gt_final-scp_qty = gt_final-scp_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RWK1' ..
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
                                                       bwart = '101' ..


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

*BREAK fujiabap.
**********          Import PO's  MIGO No.
      IF gt_final-lfbnr IS INITIAL AND gt_rseg_v1-xekbz NE 'X'.
          READ TABLE gt_ekbe_imp WITH KEY ebeln = gt_rseg_v1-ebeln
                                          ebelp = gt_rseg_v1-ebelp ..
          IF sy-subrc = 0.
            gt_final-lfbnr = gt_ekbe_imp-belnr.   " MIGO No.
            gt_final-lsmng = gt_ekbe_imp-lsmng.   " MIGO No.
            READ TABLE lt_qals INTO ls_qals WITH KEY mblnr = gt_ekbe_imp-lfbnr
                                                     mjahr = gt_ekbe_imp-lfgja
                                                     ebeln = gt_rseg_v1-ebeln
                                                     ebelp = gt_rseg_v1-ebelp ..
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
                                                             lgort = 'RM01' ..
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
                                                                 lgort = 'SCR1' ..
                        IF sy-subrc IS INITIAL.
                          gt_final-scp_qty = gt_final-scp_qty + ls_mseg-menge.
*                          gt_final-lsmng   = gt_final-lsmng + ls_mseg-lsmng.
                        ENDIF.

                        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                                                 mjahr = ls_qamb-mjahr
                                                                 ebeln = gt_rseg_v1-ebeln
                                                                 ebelp = gt_rseg_v1-ebelp
*                                                       zeile = gt_rseg_v1-lfpos
                                                                 lgort = 'RWK1' . .
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
*   BREAK fujiabap.
            CLEAR gt_bkpf_imp.
        READ TABLE gt_bkpf_imp[] INTO gt_bkpf_imp  WITH KEY ""gjahr = Gt_ekbe_imp-gjahr
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
                                                        ktosl = 'BSX' ..
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
                                                        ktosl = 'FRL' ..
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
*BREAK primus.
        READ TABLE lt_skat INTO ls_skat WITH KEY saknr = gt_final-hkont." ..
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

        READ TABLE lt_t007s INTO ls_t007s WITH KEY mwskz = gt_final-mwskz .."gt_rseg_v1-mwskz.
        IF sy-subrc IS INITIAL.
          gt_final-text1 = ls_t007s-text1.
        ENDIF.
        READ TABLE gt_makt WITH KEY matnr = gt_rseg_v1-matnr ..
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
                                                 werks = gt_rseg_v1-werks ..
        IF sy-subrc IS INITIAL.
          gt_final-steuc = ls_marc-steuc.
        ENDIF.
        READ TABLE lt_mat_mast INTO ls_mat_mast WITH KEY matnr = gt_rseg_v1-matnr ..
        IF sy-subrc IS INITIAL.
          gt_final-mtart = ls_mat_mast-mtart.
          gt_final-zseries = ls_mat_mast-zseries.
          gt_final-zsize   = ls_mat_mast-zsize.
          gt_final-brand   = ls_mat_mast-brand.
          gt_final-moc     = ls_mat_mast-moc.
          gt_final-type    = ls_mat_mast-type.
        ENDIF.
*BREAK PRIMUS.
        READ TABLE gt_ekko WITH KEY ebeln = gt_rseg_v1-ebeln ..
        IF sy-subrc = 0.
          gt_final-ekorg = gt_ekko-ekorg.
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
                                    ebelp = gt_rseg_v1-ebelp ..
        IF sy-subrc = 0.
          gt_final-po_qty = gt_ekpo-menge.

          gt_final-knttp = gt_ekpo-knttp.
          IF gt_ekpo-peinh IS NOT INITIAL.
            gt_final-rate = gt_ekpo-netpr / gt_ekpo-peinh.
          ENDIF.

          READ TABLE lt_t163y INTO ls_t163y WITH KEY pstyp = gt_ekpo-pstyp ..
          IF sy-subrc IS INITIAL.
            gt_final-pstyp = ls_t163y-epstp.
          ENDIF.

*********   Asset no. & Sub Asset No.
          READ TABLE gt_ekkn WITH KEY ebeln = gt_ekpo-ebeln
                                      ebelp = gt_ekpo-ebelp . .
          IF sy-subrc = 0.
            gt_final-anln1 = gt_ekkn-anln1.
            gt_final-anln2 = gt_ekkn-anln2.
            gt_final-sakto = gt_ekkn-sakto.
            READ TABLE gt_anla WITH KEY anln1 = gt_ekkn-anln1
                                        anln2 = gt_ekkn-anln2 ..
            IF sy-subrc = 0.
              gt_final-invnr = gt_anla-invnr.
              gt_final-txt50 = gt_anla-txt50.
            ENDIF.
            READ TABLE lt_bseg INTO ls_bseg WITH KEY ebeln = gt_ekpo-ebeln
                                                     ebelp = gt_ekpo-ebelp
                                                     anln1 = gt_ekkn-anln1
                                                     anln2 = gt_ekkn-anln2 ..
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

*BREAK Fujiabap.
        LOOP AT gt_rseg WHERE belnr = gt_rbkp-belnr
                                  AND gjahr = gt_rbkp-gjahr
                                  AND ebeln = gt_rseg_v1-ebeln
                                  AND ebelp = gt_rseg_v1-ebelp.
*                          AND wrbtr = gt_rseg-wrbtr.            " <gt_rseg_v1-wrbtr> added by paresh bhoi


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

*BREAK Fujiabap.
******** AMORTISED VALUE                                  " ADDED BY PARESH BHOI
          CHECK gt_rseg-kschl = 'ZAMV'.
*            IF gt_rseg-kschl = 'ZAMV'.
          gt_final-amort_val = gt_final-amort_val + gt_rseg-wrbtr.
*          ENDIF.
*********************************************************************

        ENDLOOP.

        "ADDED BY PARESH BHOI.
*  PERFORM ASSBLE_GST_CAL.  " ADDING ALL CHARGES , VALUES



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

*BREAK Fujiabap.
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
*                           + amort_val


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
*BREAK fujiabap.
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
                           + gt_final-hcess
                           + gt_final-amort_val.                " AMORTISED VALUE ADDED BY PARESH BHOI
        .

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


*        aedat
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input  = gt_final-aedat
*          IMPORTING
*            output = gt_final-AEDAT.

*        CONCATENATE gt_final-aedat+0(2) gt_final-aedat+2(3) gt_final-aedat+5(4)
*                    into gt_final-aedat SEPARATED BY '-'.

*        budat
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input  = gt_final-budat
*          IMPORTING
*            output = gt_final-budat.

*       CONCATENATE gt_final-budat+0(2) gt_final-budat+2(3) gt_final-budat+5(4)
*                   into gt_final-budat SEPARATED BY '-'.

*         bill_dt
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input = gt_final-bill_dt
*          IMPORTING
*            output = gt_final-bill_dt.

*        CONCATENATE gt_final-bill_dt+0(2) gt_final-bill_dt+2(3) gt_final-bill_dt+5(4)
*                    into gt_final-bill_dt SEPARATED BY '-'.

*       eindt
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input = gt_final-eindt
*          IMPORTING
*            output = gt_final-eindt.
*
*        CONCATENATE gt_final-eindt+0(2) gt_final-eindt+2(3) gt_final-eindt+5(4)
*                   into gt_final-eindt SEPARATED BY '-'.

*BREAK primus.
READ TABLE lt_tax INTO ls_tax WITH key belnr = gt_final-MIRO_AC_DOC.
if sy-subrc = 0.
gt_final-cgst_tax = ls_tax-cgst.
gt_final-sgst_tax = ls_tax-sgst.
gt_final-igst_tax = ls_tax-igst_tax.
gt_final-bed = ls_tax-bed.
gt_final-aed = ls_tax-aed.
gt_final-vat_tax = ls_tax-vat_tax.
gt_final-ser_val_dr = ls_tax-ser_val_dr.
gt_final-sbc_dr = ls_tax-sbc_dr.
gt_final-kkc_dr = ls_tax-kkc_dr.
endif.
        APPEND gt_final.

*        CLEAR: gt_final,gt_rseg,lv_igst,lv_cgst,lv_igst.  "Commented 09.11.2016


        CLEAR :
          gt_final, gt_with_item, gt_rbkp, gt_lfa1,lv_igst,lv_cgst,lv_igst,gt_t005u, gt_j_1imovend,ls_eket,ls_bseg,
          gt_rseg_v1, gt_bkpf_we,gt_rseg, gt_ekbe_imp, gt_bkpf_imp, gt_makt,gt_ekko, gt_ekpo, gt_bset,ls_t163y.



      ENDIF. "end gt_rbkp
    ENDIF. " end gt_bkpf   """  checking condn gt_rseg_v1
  ENDLOOP. "" *****      END RSEG
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
    it_final-basic_lc         = gt_final-basic_lc        .
    it_final-packing_lc       = gt_final-packing_lc      .
    it_final-insp             = gt_final-insp            .
    it_final-set_val          = gt_final-set_val         .
    it_final-freight_lc       = gt_final-freight_lc      .
    it_final-ins              = gt_final-ins             .
    it_final-oth_ch           = gt_final-oth_ch          .
    it_final-dev_ch           = gt_final-dev_ch          .
***amortized value """addeded by paresh bhoi
*    it_final-amort_val         = gt_final-amort_val.
    it_final-net_total_lc     = gt_final-net_total_lc    .
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
    it_final-sgst             = gt_final-sgst            .
    it_final-sgst_tax         = gt_final-sgst_tax        .
    it_final-igst             = gt_final-igst            .
    it_final-igst_tax         = gt_final-igst_tax        .
    it_final-com_p            = gt_final-com_p           .
    it_final-com_v            = gt_final-com_v           .
    it_final-gst_amt          = gt_final-gst_amt         .
    it_final-basic_cust       = gt_final-basic_cust      . "" **
    it_final-cvd              = gt_final-cvd             .
    it_final-cust_cess        = gt_final-cust_cess       .
    it_final-cust_hcess       = gt_final-cust_hcess      .
    it_final-wrbtr            = gt_final-wrbtr           .
    it_final-add_cvd          = gt_final-add_cvd         .
    it_final-tot_tax          = gt_final-tot_tax         . ""**
    it_final-gross_tot     = gt_final-gross_tot    .
    it_final-gross_tot_lc     = gt_final-gross_tot_lc    .
    it_final-anln1            = gt_final-anln1           .
    it_final-anln2            = gt_final-anln2           .
    it_final-invnr            = gt_final-invnr           .
    it_final-txt50            = gt_final-txt50           .
    it_final-sakto            = gt_final-sakto           .
    it_final-ass_amt          = gt_final-ass_amt         .
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
      it_final-amort_val      = gt_final-amort_val.
    APPEND it_final.
    CLEAR gt_final.
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
  gt_listheader-info = 'Purchase Register'.
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

****Purchase Org
  gt_fieldcatalog-fieldname = 'EKORG'.
  gt_fieldcatalog-seltext_l = 'Purchase Org'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

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

****>>> 13. Vendor Address
  gt_fieldcatalog-fieldname = 'ADDRESS'.
  gt_fieldcatalog-seltext_l = 'Address'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 13. Vendor GSTIN
  gt_fieldcatalog-fieldname = 'STCD3'.
  gt_fieldcatalog-seltext_l = 'GSTIN No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 13. Vendor GSTIN Regd.
  gt_fieldcatalog-fieldname = 'GST_TXT'.
  gt_fieldcatalog-seltext_l = 'REGD/URD /Comp'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '35'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 11. Vendor State
  gt_fieldcatalog-fieldname = 'GST_REGION'.
  gt_fieldcatalog-seltext_l = 'State Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '25'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 11. Vendor State
  gt_fieldcatalog-fieldname = 'BEZEI'.
  gt_fieldcatalog-seltext_l = 'Vendor State'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '25'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 7. Inv/Bill No.
  gt_fieldcatalog-fieldname = 'XBLNR_ALT'.
  gt_fieldcatalog-seltext_l = 'Invoice No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 7. Inv/Bill No.
  gt_fieldcatalog-fieldname = 'INV_NO'.
  gt_fieldcatalog-seltext_l = 'Vendor Inv.No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 8. INV DATE TIME
  gt_fieldcatalog-fieldname = 'INV_DT'.
  gt_fieldcatalog-seltext_l = 'Invoice Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 10. PO No.
  gt_fieldcatalog-fieldname = 'EBELN'.
  gt_fieldcatalog-seltext_l = 'PO No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  gt_fieldcatalog-hotspot   = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 9. PO Date
  gt_fieldcatalog-fieldname = 'AEDAT'.
  gt_fieldcatalog-seltext_l = 'PO Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 9. PO Line Item
  gt_fieldcatalog-fieldname = 'EBELP'.
  gt_fieldcatalog-seltext_l = 'PO Line Item'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 9. Item Category
  gt_fieldcatalog-fieldname = 'PSTYP'.
  gt_fieldcatalog-seltext_l = 'Item Category'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 9. Account Assignment Category
  gt_fieldcatalog-fieldname = 'KNTTP'.
  gt_fieldcatalog-seltext_l = 'Acc.Assign.Category'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 1. Migo number
  gt_fieldcatalog-fieldname = 'LFBNR'.
  gt_fieldcatalog-seltext_l = 'GRN No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 2. Migo Date
  gt_fieldcatalog-fieldname = 'BUDAT'.
  gt_fieldcatalog-seltext_l = 'GRN Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 3. FI document No.
  gt_fieldcatalog-fieldname = 'BELNR'.
  gt_fieldcatalog-seltext_l = 'GRN FI Doc No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  gt_fieldcatalog-hotspot       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 3. FI document No.
  gt_fieldcatalog-fieldname = 'GRN_AMT'.
  gt_fieldcatalog-seltext_l = 'GRN FI Doc.No.Amt'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 3. FI document No.
  gt_fieldcatalog-fieldname = 'ZUONR'.
  gt_fieldcatalog-seltext_l = 'Original Inv.No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 3. FI document No.
  gt_fieldcatalog-fieldname = 'BKTXT'.
  gt_fieldcatalog-seltext_l = 'Original Inv.Dt.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 4. Bill Booking No.
  gt_fieldcatalog-fieldname = 'AWKEY'.
  gt_fieldcatalog-seltext_l = 'Miro No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 5. MIRO A/c Doc No.
  gt_fieldcatalog-fieldname = 'MIRO_AC_DOC'.
  gt_fieldcatalog-seltext_l = 'FI Doc No.'.
  gt_fieldcatalog-hotspot       = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 5. MIRO A/c Doc No.
  gt_fieldcatalog-fieldname = 'BLART'.
  gt_fieldcatalog-seltext_l = 'FI Doc.Type'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-key       = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 6. Bill Booking Date
  gt_fieldcatalog-fieldname = 'BILL_DT'.
  gt_fieldcatalog-seltext_l = 'FI Doc Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> GR Ledger Code
  gt_fieldcatalog-fieldname = 'HKONT'.
  gt_fieldcatalog-seltext_l = 'GR Ledger Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> GR Ledger Description
  gt_fieldcatalog-fieldname = 'TXT20'.
  gt_fieldcatalog-seltext_l = 'GR Ledger Description'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> GR Ledger Description
  gt_fieldcatalog-fieldname = 'STEUC'.
  gt_fieldcatalog-seltext_l = 'HSN/SAC Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 15. Material
  gt_fieldcatalog-fieldname = 'MATNR'.
  gt_fieldcatalog-seltext_l = 'Item Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '18'.
  gt_fieldcatalog-no_zero = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 16. Material Description
  gt_fieldcatalog-fieldname = 'LONG_TXT'.
  gt_fieldcatalog-seltext_l = 'Item Description (100 char)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> Material Type
  gt_fieldcatalog-fieldname = 'MTART'.
  gt_fieldcatalog-seltext_l = 'Material Type'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> Delivery Date
  gt_fieldcatalog-fieldname = 'EINDT'.
  gt_fieldcatalog-seltext_l = 'Delivery Date'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> PO Qty
  gt_fieldcatalog-fieldname = 'PO_QTY'.
  gt_fieldcatalog-seltext_l = 'PO Qty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '40'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 17. Quantity
  gt_fieldcatalog-fieldname = 'LSMNG'.
  gt_fieldcatalog-seltext_l = 'Challan Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 17. Quantity
  gt_fieldcatalog-fieldname = 'MENGE'.
  gt_fieldcatalog-seltext_l = 'Recpt.Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 17. ACC Quantity
  gt_fieldcatalog-fieldname = 'ACC_QTY'.
  gt_fieldcatalog-seltext_l = 'Acc.Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 17. Rej Quantity
  gt_fieldcatalog-fieldname = 'REJ_QTY'.
  gt_fieldcatalog-seltext_l = 'Rejected Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 17. Scrap Quantity
  gt_fieldcatalog-fieldname = 'SCP_QTY'.
  gt_fieldcatalog-seltext_l = 'Scrap Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 17. Rewrk Quantity
  gt_fieldcatalog-fieldname = 'Rew_QTY'.
  gt_fieldcatalog-seltext_l = 'Rework Qty.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 20. Document Currency
  gt_fieldcatalog-fieldname = 'WAERS'.
  gt_fieldcatalog-seltext_l = 'PO.Currency'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '5'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 21. Exchange Rate
  gt_fieldcatalog-fieldname = 'KURSF'.
  gt_fieldcatalog-seltext_l = 'Exchange Rate'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

***>>> 63. Rate Per Qty
  gt_fieldcatalog-fieldname = 'RATE'.
  gt_fieldcatalog-seltext_l = 'Rate'.
  APPEND  gt_fieldcatalog.
  CLEAR  gt_fieldcatalog.

****>>> 22. Basic (DC)
  gt_fieldcatalog-fieldname = 'BASIC'.
  gt_fieldcatalog-seltext_l = 'Basic(DC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 23. Basic (LC)
  gt_fieldcatalog-fieldname = 'BASIC_LC'.
  gt_fieldcatalog-seltext_l = 'Basic(LC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 25. Packing (LC)
  gt_fieldcatalog-fieldname = 'PACKING_LC'.
  gt_fieldcatalog-seltext_l = 'Packing'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 25. Packing (LC)
  gt_fieldcatalog-fieldname = 'INSP'.
  gt_fieldcatalog-seltext_l = 'Insp.Charge'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 25. Packing (LC)
  gt_fieldcatalog-fieldname = 'SET_VAL'.
  gt_fieldcatalog-seltext_l = 'Setting Charge'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 50. Freight(LC)
  gt_fieldcatalog-fieldname = 'FREIGHT_LC'.
  gt_fieldcatalog-seltext_l = 'Freight'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 25. Insurance (LC)
  gt_fieldcatalog-fieldname = 'INS'.
  gt_fieldcatalog-seltext_l = 'Insurance'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 25. Other Charges (LC)
  gt_fieldcatalog-fieldname = 'OTH_CH'.
  gt_fieldcatalog-seltext_l = 'Other Charges'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 25. Development Charges (LC)
  gt_fieldcatalog-fieldname = 'DEV_CH'.
  gt_fieldcatalog-seltext_l = 'Development Charges'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.



****>>> new add                 " ADDED BY PARESH BHOI
  gt_fieldcatalog-fieldname = 'AMORT_VAL'.
  gt_fieldcatalog-seltext_l = 'AMORTISED VALUE'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


****>>> 33. Assessable GST
  gt_fieldcatalog-fieldname = 'NET_TOTAL_LC'.
  gt_fieldcatalog-seltext_l = 'Assessable Value (GST)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 14. Tax code
  gt_fieldcatalog-fieldname = 'MWSKZ'.
  gt_fieldcatalog-seltext_l = 'Tax Code'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '7'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 14. Tax code Description
  gt_fieldcatalog-fieldname = 'TEXT1'.
  gt_fieldcatalog-seltext_l = 'Tax Code Description'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '7'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 28. Basic Excise Duty
  gt_fieldcatalog-fieldname = 'BED'.
  gt_fieldcatalog-seltext_l = 'Basic Excise Duty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 29. Addl.Excise Duty
  gt_fieldcatalog-fieldname = 'AED'.
  gt_fieldcatalog-seltext_l = 'Addl.Excise Duty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 35. VAT
  gt_fieldcatalog-fieldname = 'VAT'.
  gt_fieldcatalog-seltext_l = 'VAT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 34. VAT Tax
  gt_fieldcatalog-fieldname = 'VAT_TAX'.
  gt_fieldcatalog-seltext_l = 'VAT Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 37. CST
  gt_fieldcatalog-fieldname = 'CST'.
  gt_fieldcatalog-seltext_l = 'CST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 36. CST Tax
  gt_fieldcatalog-fieldname = 'CST_TAX'.
  gt_fieldcatalog-seltext_l = 'CST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 41. Service Tax (Dr)
  gt_fieldcatalog-fieldname = 'SER_VAL_DR'.
  gt_fieldcatalog-seltext_l = 'Service Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 42. Swach Bharat Cess (Dr)
  gt_fieldcatalog-fieldname = 'SBC_DR'.
  gt_fieldcatalog-seltext_l = 'Swach Bharat Cess(Dr)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


****>>> 43. Krishi Kalyan Cess (Dr)
  gt_fieldcatalog-fieldname = 'KKC_DR'.
  gt_fieldcatalog-seltext_l = 'Krishi Kalyan Cess(Dr)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.



****>>> 44. Basic Customs
  gt_fieldcatalog-fieldname = 'BASIC_CUST'.
  gt_fieldcatalog-seltext_l = 'Custom Duty Value'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 45. CVD
  gt_fieldcatalog-fieldname = 'CVD'.
  gt_fieldcatalog-seltext_l = 'CVD'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


****>>> 46. Customs ECess
  gt_fieldcatalog-fieldname = 'CUST_CESS'.
  gt_fieldcatalog-seltext_l = 'Customs ECess'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


****>>> 47. Customs HECess
  gt_fieldcatalog-fieldname = 'CUST_HCESS'.
  gt_fieldcatalog-seltext_l = 'Customs HECess'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

***>>>Social Welfare
  gt_fieldcatalog-fieldname = 'WRBTR'.
  gt_fieldcatalog-seltext_l = 'Social Welfare'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 45. CVD
  gt_fieldcatalog-fieldname = 'ADD_CVD'.
  gt_fieldcatalog-seltext_l = 'Add.Custom Duty'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 72. CGST
  gt_fieldcatalog-fieldname = 'CGST'.
  gt_fieldcatalog-seltext_l = 'CGST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 71. CGST Tax
  gt_fieldcatalog-fieldname = 'CGST_TAX'.
  gt_fieldcatalog-seltext_l = 'CGST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 74. SGST
  gt_fieldcatalog-fieldname = 'SGST'.
  gt_fieldcatalog-seltext_l = 'SGST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

***>>> 73. SGST Tax
  gt_fieldcatalog-fieldname = 'SGST_TAX'.
  gt_fieldcatalog-seltext_l = 'SGST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 76. IGST
  gt_fieldcatalog-fieldname = 'IGST'.
  gt_fieldcatalog-seltext_l = 'IGST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 75. IGST Tax
  gt_fieldcatalog-fieldname = 'IGST_TAX'.
  gt_fieldcatalog-seltext_l = 'IGST Tax'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum    = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> Comm Cess %
  gt_fieldcatalog-fieldname = 'COM_P'.
  gt_fieldcatalog-seltext_l = 'Comp. Cess %'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> Comm Cess Val
  gt_fieldcatalog-fieldname = 'COM_V'.
  gt_fieldcatalog-seltext_l = 'Comp. Cess Value'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> GST Total
  gt_fieldcatalog-fieldname = 'GST_AMT'.
  gt_fieldcatalog-seltext_l = 'Total GST'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> Total Tax Amt
  gt_fieldcatalog-fieldname = 'TOT_TAX'.
  gt_fieldcatalog-seltext_l = 'Total Tax Amt.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


****>>> 58. GROSS TOTAL (DC)
  gt_fieldcatalog-fieldname = 'GROSS_TOT'.
  gt_fieldcatalog-seltext_l = 'Gross Total(DC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 59. GROSS TOTAL (LC)
  gt_fieldcatalog-fieldname = 'GROSS_TOT_LC'.
  gt_fieldcatalog-seltext_l = 'Gross Total(LC)'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  gt_fieldcatalog-do_sum = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

****>>> 65. Main Asset Number
  gt_fieldcatalog-fieldname = 'ANLN1'.
  gt_fieldcatalog-seltext_l = 'Main Asset Number'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND  gt_fieldcatalog.
  CLEAR   gt_fieldcatalog.

****>>> 66. Asset Subnumber
  gt_fieldcatalog-fieldname = 'ANLN2'.
  gt_fieldcatalog-seltext_l = 'Asset Subnumber'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
  APPEND  gt_fieldcatalog.
  CLEAR   gt_fieldcatalog.

****>>> 66. Asset Inventory No
  gt_fieldcatalog-fieldname = 'INVNR'.
  gt_fieldcatalog-seltext_l = 'Asset Inventory No.'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
  APPEND  gt_fieldcatalog.
  CLEAR   gt_fieldcatalog.

****>>> 67. Asset description
  gt_fieldcatalog-fieldname = 'TXT50'.
  gt_fieldcatalog-seltext_l = 'Asset description'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '25'.
  APPEND  gt_fieldcatalog.
  CLEAR   gt_fieldcatalog.

****>>> 68. Reconciliation Account in General Ledger
  gt_fieldcatalog-fieldname = 'SAKTO'.
  gt_fieldcatalog-seltext_l = 'Reconciliation G/L Account'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND  gt_fieldcatalog.
  CLEAR   gt_fieldcatalog.

****>>> 68. Reconciliation Account in General Ledger
  gt_fieldcatalog-fieldname = 'ASS_AMT'.
  gt_fieldcatalog-seltext_l = 'Gross Asset Amount'.
  gt_fieldcatalog-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND  gt_fieldcatalog.
  CLEAR   gt_fieldcatalog.
  gt_fieldcatalog-fieldname = 'MOC'.
  gt_fieldcatalog-seltext_l = 'MOC'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'BRAND'.
  gt_fieldcatalog-seltext_l = 'Brand'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'ZSIZE'.
  gt_fieldcatalog-seltext_l = 'Size'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'ZSERIES'.
  gt_fieldcatalog-seltext_l = 'Series'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'TYPE'.
  gt_fieldcatalog-seltext_l = 'Type'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.
*
****>>>Social Welfare
*  gt_fieldcatalog-fieldname = 'WRBTR'.
*  gt_fieldcatalog-seltext_l = 'Social Welfare'.
*  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum    = 'X'.
*  APPEND gt_fieldcatalog.
*  CLEAR gt_fieldcatalog.

********* Changes by Bency, Req No. DEVK903608 ************
***
*******>>> 51. LBT
***  gt_fieldcatalog-fieldname = 'LBT'.
***  gt_fieldcatalog-seltext_l = 'LBT'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 18. Plant
***  gt_fieldcatalog-fieldname = 'WERKS'.
***  gt_fieldcatalog-seltext_l = 'Plant'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '7'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


******>>> 24. Packing (DC)
**  gt_fieldcatalog-fieldname = 'PACKING'.
**  gt_fieldcatalog-seltext_l = 'Packing(DC)'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.


******>>> 26. Discount (DC)
**  gt_fieldcatalog-fieldname = 'DISCOUNT'.
**  gt_fieldcatalog-seltext_l = 'Discount'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.

*******>>> 27. Discount (LC)
***  gt_fieldcatalog-fieldname = 'DISCOUNT_LC'.
***  gt_fieldcatalog-seltext_l = 'Discount'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

***
*******>>> 30. Edu.Excise
***  gt_fieldcatalog-fieldname = 'ECS_CR'.
***  gt_fieldcatalog-seltext_l = 'Edu.Excise(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 31. HCESS
***  gt_fieldcatalog-fieldname = 'HCESS_CR'.
***  gt_fieldcatalog-seltext_l = 'Higher Edu.Excise(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>>  Edu.Excise
***  gt_fieldcatalog-fieldname = 'ECS_DR'.
***  gt_fieldcatalog-seltext_l = 'Edu.Excise(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

****>>>  HCESS
***  gt_fieldcatalog-fieldname = 'HCESS_DR'.
***  gt_fieldcatalog-seltext_l = 'Higher Edu.Excise(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

****>>> 30. Edu.Excise
***  gt_fieldcatalog-fieldname = 'ECS'.
***  gt_fieldcatalog-seltext_l = 'Edu.Excise'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 31. HCESS
***  gt_fieldcatalog-fieldname = 'HCESS'.
***  gt_fieldcatalog-seltext_l = 'Higher Edu.Excise'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

********* End of Changes by Bency, Req No. DEVK903608 ************

******>>> 32. Net Total (DC)
**  gt_fieldcatalog-fieldname = 'NET_TOTAL'.
**  gt_fieldcatalog-seltext_l = 'Net Total(DC)'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum    = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.


*******>>> 77. CGST Tax NS
***  gt_fieldcatalog-fieldname = 'CGST_NS_TAX'.
***  gt_fieldcatalog-seltext_l = 'CGST Tax (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 78. CGST NS
***  gt_fieldcatalog-fieldname = 'CGST_NS'.
***  gt_fieldcatalog-seltext_l = 'CGST (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 79. SGST Tax NS
***  gt_fieldcatalog-fieldname = 'SGST_NS_TAX'.
***  gt_fieldcatalog-seltext_l = 'SGST Tax (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 80. SGST NS
***  gt_fieldcatalog-fieldname = 'SGST_NS'.
***  gt_fieldcatalog-seltext_l = 'SGST (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 81. IGST Tax NS
***  gt_fieldcatalog-fieldname = 'IGST_NS_TAX'.
***  gt_fieldcatalog-seltext_l = 'IGST Tax (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 82. IGST NS
***  gt_fieldcatalog-fieldname = 'IGST_NS'.
***  gt_fieldcatalog-seltext_l = 'IGST (NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 83. IGST Tax IMP
***  gt_fieldcatalog-fieldname = 'IGST_TAX_IM'.
***  gt_fieldcatalog-seltext_l = 'IGST Tax (IMP)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 84. IGST IMP
***  gt_fieldcatalog-fieldname = 'IGST_IM'.
***  gt_fieldcatalog-seltext_l = 'IGST (IMP)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
*******>>> 38. Service Tax (Cr)
***  gt_fieldcatalog-fieldname = 'SER_VAL_CR'.
***  gt_fieldcatalog-seltext_l = 'Service Tax(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


****>>> 39. Swach Bharat Cess (Cr)
***  gt_fieldcatalog-fieldname = 'SBC_CR'.
***  gt_fieldcatalog-seltext_l = 'Swach Bharat Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
***
*******>>> 40. Krishi Kalyan Cess (Cr)
***  gt_fieldcatalog-fieldname = 'KKC_CR'.
***  gt_fieldcatalog-seltext_l = 'Krishi Kalyan Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 48. Add.CVD
***  gt_fieldcatalog-fieldname = 'ADD_CVD'.
***  gt_fieldcatalog-seltext_l = 'Add.CVD'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 49. Freight (DC)
***  gt_fieldcatalog-fieldname = 'FREIGHT'.
***  gt_fieldcatalog-seltext_l = 'Freight(DC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


**** B.O.C Bency 06.12.2016
*******>>>  Serv tax cess credit
***  gt_fieldcatalog-fieldname = 'SERTAXCESS_CR'.
***  gt_fieldcatalog-seltext_l = 'Service tax Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>>  Higher Serv tax cess credit
***  gt_fieldcatalog-fieldname = 'HSERTAXCESS_CR'.
***  gt_fieldcatalog-seltext_l = 'Higher Service tax Cess(Cr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>>  Serv tax cess debit
***  gt_fieldcatalog-fieldname = 'SERTAXCESS_DR'.
***  gt_fieldcatalog-seltext_l = 'Service tax Cess(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>>  Higher Serv tax cess debit
***  gt_fieldcatalog-fieldname = 'HSERTAXCESS_DR'.
***  gt_fieldcatalog-seltext_l = 'Higher Service tax Cess(Dr)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
**** E.O.C Bency 06.12.2016

****>>> 52. FORWARDING (DC)
*  gt_fieldcatalog-fieldname = 'FORWARDING'.
*  gt_fieldcatalog-seltext_l = 'Forwarding(DC)'.
*  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-do_sum    = 'X'.
*  append gt_fieldcatalog.
*  clear gt_fieldcatalog.

****>>> 53. FORWARDING (LC)
*  gt_fieldcatalog-fieldname = 'FORWARDING_LC'.
*  gt_fieldcatalog-seltext_l = 'Forwarding(LC)'.
*  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  gt_fieldcatalog-do_sum    = 'X'.
*  append gt_fieldcatalog.
*  clear gt_fieldcatalog.

******>>> 54. CLEARING
**  gt_fieldcatalog-fieldname = 'CLEARING'.
**  gt_fieldcatalog-seltext_l = 'Clearing'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
**  gt_fieldcatalog-do_sum    = 'X'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.

*******>>> 55. CLEARING (LC)
***  gt_fieldcatalog-fieldname = 'CLEARING_LC'.
***  gt_fieldcatalog-seltext_l = 'Clearing'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

*******>>> 56. TDS (DC)
***  gt_fieldcatalog-fieldname = 'TDS_DC'.
***  gt_fieldcatalog-seltext_l = 'TDS(DC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

***
*******>>> 57. TDS (LC)
***  gt_fieldcatalog-fieldname = 'TDS_LC'.
***  gt_fieldcatalog-seltext_l = 'TDS(LC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

******>>> 61. TIN No.
**  gt_fieldcatalog-fieldname = 'TIN_NO'.
**  gt_fieldcatalog-seltext_l = 'TIN No.'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
**  APPEND gt_fieldcatalog.
**
******>>> 62. LST No.
**  gt_fieldcatalog-fieldname = 'LST_NO'.
**  gt_fieldcatalog-seltext_l = 'LST No.'.
**  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '10'.
**  APPEND gt_fieldcatalog.
**  CLEAR gt_fieldcatalog.
**
******>>> 64. T-Code
**  gt_fieldcatalog-fieldname = 'TCODE'.
**  gt_fieldcatalog-seltext_l = 'T-Code'.
**  APPEND  gt_fieldcatalog.
**  CLEAR   gt_fieldcatalog.

*******>>> 69. GROSS TOTAL WITHOUT TDS (DC)
***  gt_fieldcatalog-fieldname = 'GROSS_TOT_TDS'.
***  gt_fieldcatalog-seltext_l = 'Gross Total Without TDS(DC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
***
*******>>> 70. GROSS TOTAL WITHOUT TDS (LC)
***  gt_fieldcatalog-fieldname = 'GROSS_TOT_LC_TDS'.
***  gt_fieldcatalog-seltext_l = 'Gross Total Without TDS(LC)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.

***
*******>>> 85. CGST Tax RC
***  gt_fieldcatalog-fieldname = 'CGST_RC_TAX'.
***  gt_fieldcatalog-seltext_l = 'CGST Tax (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 86. CGST RCM
***  gt_fieldcatalog-fieldname = 'CGST_RC'.
***  gt_fieldcatalog-seltext_l = 'CGST (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 87. SGST Tax RC
***  gt_fieldcatalog-fieldname = 'SGST_RC_TAX'.
***  gt_fieldcatalog-seltext_l = 'SGST Tax (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 88. SGST RCM
***  gt_fieldcatalog-fieldname = 'SGST_RC'.
***  gt_fieldcatalog-seltext_l = 'SGST (RCM)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 89. CGST Tax RC NS
***  gt_fieldcatalog-fieldname = 'CGST_NRC_TAX'.
***  gt_fieldcatalog-seltext_l = 'CGST Tax (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 90. CGST RCM NS
***  gt_fieldcatalog-fieldname = 'CGST_NRC'.
***  gt_fieldcatalog-seltext_l = 'CGST (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 91. SGST Tax RC NS
***  gt_fieldcatalog-fieldname = 'SGST_NRC_TAX'.
***  gt_fieldcatalog-seltext_l = 'SGST Tax (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  gt_fieldcatalog-do_sum    = 'X'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.
***
*******>>> 92. SGST RCM NS
***  gt_fieldcatalog-fieldname = 'SGST_NRC'.
***  gt_fieldcatalog-seltext_l = 'SGST (RCM NS)'.
***  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
***  APPEND gt_fieldcatalog.
***  CLEAR gt_fieldcatalog.


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
*  BREAK primus.
  IF p_down = 'X'.
    PERFORM download.
    PERFORM gui_download.
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
        SET PARAMETER ID 'GJR' FIELD s_gjahr-low.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
      IF rs_selfield-fieldname = 'BELNR'.
        SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
        SET PARAMETER ID 'BUK' FIELD lv_bukrs.
        SET PARAMETER ID 'GJR' FIELD s_gjahr-low.
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
      i_tab_sap_data       = it_final "gt_final
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
  lv_file = 'ZPURCHASE_REG.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPurchase Download started on', sy-datum, 'at', sy-uzeit.
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
  CONCATENATE 'Purchase Org.'
              'Vendor'
              'Vendor Name'
              'Address'
              'GSTIN'
              'REGD/URD/Comp'
              'State Code'
              'State'
              'Invoice No.'
              'Vendor Inv.No.'
              'Inv.Dt.'
              'PO No.'
              'PO Dt.'
              'PO Line Item'
              'Item Category'
              'Acc.Assgn.Category'
              'GRN No.'
              'GRN Dt.'
              'GRN FI Doc.'
              'GRN FI Doc.Amt.'
              'Original Inv.No.'
              'Original Inv.Dt.'
              'MIRO No.'
              'FI Doc.No.'
              'FI Doc.Type'
              'FI Doc.Dt.'
              'GR Ledger Code'
              'GR Ledger Description'
              'HSN/SAC Code'
              'Item Code'
              'Long Description'
              'Material Type'
              'Delivery Date'
              'PO Qty.'
              'Challan Qty.'
              'Recpt.Qty.'
              'Accpt.Qty.'
              'Rejected Qty.'
              'Scrap Qty.'
              'Rework Qty.'
              'PO Currency'
              'Exchange Rate'
              'Rate'
              'Basic(DC)'
              'Basic(LC)'
              'Packing'
              'Insp.Charge'
              'Setting Charge'
              'Freight'
              'Insurance'
              'Other Charge'
              'Development Charge'
              'Assessable Value(GST)'
              'Tax Code'
              'Tax Code Description'
              'Basic Excise Duty'
              'Add.Exc.Duty'
              'VAT'
              'VAT Tax'            " 'VAT TAX' By Abhishek
              'CST'
              'CST Tax'            " By Abhishek
              'Service Tax'
              'SBC'
              'KKC'
              'BASIC CUSTOM'             " BY NAKUL  09.0402018 Basic Custom
              'CVD'
              'Customs Ecess'
              'Customs HEcess'
              'Social Welfare'
              'Add.Custom Duty'
              'CGST%'
              'CGST'
              'SGST%'
              'SGST'
              'IGST%'
              'IGST'
              'Comp Cess%'
              'Comp Cess Val'
              'Total GST Amt'
              'Total Tax Amt'
              'GROSS_TOTAL (LC)'
              'Main Asset Number'
              'Asset Subnumber'
              'Asset Inventory No.'
              'Asset description'
              'Reconciliation Account'
              'Asset Gross Amount'
              'MOC'
              'Brand'
              'Size'
              'Series'
              'Type'
              'Refreshable Date'
              'Amortized value'         " changed by paresh bhoi
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
  DATA file TYPE string VALUE 'D:\ZPURCHASE_REG.TXT'.
  TYPES : BEGIN OF ls_fieldname,
            field_name(25),
          END OF ls_fieldname.
  DATA : it_fieldname TYPE TABLE OF ls_fieldname.
  DATA : wa_fieldname TYPE ls_fieldname.
*------------Heading------------------------
  wa_fieldname-field_name = 'Purchase Order'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Vendor'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Vendor Name'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Address'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GSTIN No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'REGD/URD/Comp'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'State Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'State'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Invoice No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Vendor Inv.No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Inv. Dt.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'PO No.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'PO Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'PO Line Item'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Item Category'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Acc.Assgn.Category'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GRN No.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GRN Dt'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GRN FI Doc'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GRN FI Doc Amt'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Original Inv.No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Original Inv.No Dt'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'MIRO No.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'FI Doc No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'FI Doc Type'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'FI Doc.Dt.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GR Ledger Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GR Ledger Description'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'HSN/SAC Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Item Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Long Description'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Material Type'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Delivery Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'PO Qty.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Challan Qty'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Recpt.Qty'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Accpt.Qty.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Rejected Qty'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Scrap Qty.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Rework Qty'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'PO Currency'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Exchange Rate'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Rate'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Basic (DC).'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Basic (LC).'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Packing'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Inspection Charge'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Setting Charge'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Freight'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Insurance'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Other Charge'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Development Charge'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Assessable Value(GST)'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Tax Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Tax Code Description'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Basic Excise Duty'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Add.Exc.Duty'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'VAT'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'VAT TAX'.  " bY NAKUL 09.04.2018
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'CST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'CST Tax'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Service Tax'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'SBC'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'KKC'.        "" **
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'BASIC CUSTOME'.           " BY NAKUL 04.09.2018 (Changed by Abhishek Pisolkar (10.04.2018))
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'CVD'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Customs Ecess'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Customs HEcess'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Social Welfare'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Add.Custom Duty'.
  APPEND wa_fieldname TO it_fieldname.

*  APPEND WA_FIELDNAME TO IT_FIELDNAME.
  wa_fieldname-field_name = 'CGST%'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'CGST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'SGST%'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'SGST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'IGST%'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'IGST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Com.Cess'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Com.Cess Val.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Total GST Amt'.
  APPEND wa_fieldname TO it_fieldname.

*  WA_FIELDNAME-FIELD_NAME = 'Basic Custom.'.      "" **
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  wa_fieldname-field_name = 'Total Tax Amount'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GROSS TOTAL(DC)'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GROSS TOTAL(LC)'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Main Asset Number'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Asset Subnumber'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Asset Inventory No.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Asset description'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Reconciliation Account'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Asset Gross Amount'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'MOC'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Brand'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Size'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Series'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Type'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Refreshable Date'.
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
      data_tab                = it_final
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



*
**&---------------------------------------------------------------------*
**&      Form  ASSBLE_GST_CAL
**&---------------------------------------------------------------------*
**       text      FINAL CALCULATION OF *** Assessable GST (LC)
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM assble_gst_cal .
*
*
**** Assessable GST (LC)
*    gt_final-net_total_lc = ( gt_final-basic                                         "gt_final-basic_lc
*                              + gt_final-packing                                        "gt_final-packing_lc
*                              + gt_final-insp
*                           + gt_final-set_val
*                           + gt_final-ins
*                           + gt_final-freight_lc
*                           + gt_final-dev_ch
*                           + gt_final-oth_ch
**                           - gt_final-discount_lc
*                           + gt_final-bed
*                           + gt_final-aed
*                           + gt_final-ecs
*                           + gt_final-hcess
*                           + GT_FINAL-AMORT_VAL ).                " AMORTISED VALUE ADDED BY PARESH BHOI
*.
*
*
*
*
*
*
*
*
*
*ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  ASSESSABLE_CAL_GT_RSEG
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM assessable_cal_gt_rseg .
*
*
*
******  BASIC                                            " pass dc not lc
*          IF gt_rseg-kschl = ''.
*            gt_final-basic = gt_final-basic + gt_rseg-wrbtr.
*          ENDIF.
*
******  PACKING
*          IF gt_rseg-kschl = 'ZPFL' OR gt_rseg-kschl = 'ZPC1' OR gt_rseg-kschl = 'ZPFV'.
*            gt_final-packing = gt_final-packing + gt_rseg-wrbtr.
*          ENDIF.
*
******  DISCOUNT
*          IF gt_rseg-kschl = 'R001' OR gt_rseg-kschl = 'R002' OR gt_rseg-kschl = 'R003'.
*            gt_final-discount = gt_final-discount + gt_rseg-wrbtr.
*          ENDIF.
*
****** Basic Customs
*          IF gt_rseg-kschl = 'JCDB'.
*
*            gt_final-basic_cust = gt_final-basic_cust + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
****** CVD
*          IF gt_rseg-kschl = 'JCV1'.
*            gt_final-cvd = gt_final-cvd + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
****** Customs ECess
*          IF gt_rseg-kschl = 'JECV' OR gt_rseg-kschl = 'JCZ2'.
*            gt_final-cust_cess = gt_final-cust_cess + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
****** Socila Welfare
*          IF gt_rseg-kschl = 'ZSWS' .
*            gt_final-wrbtr = gt_rseg-wrbtr.
**            gt_final-cust_cess = gt_final-cust_cess + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
****** Customs HECess
*          IF gt_rseg-kschl = 'JCZ4'.
**          if gt_rseg-kschl = 'JSED'.""Gt_rseg-kschl = 'JSDB'.
*            gt_final-cust_hcess = gt_final-cust_hcess + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
****** Add. CVD
*          IF gt_rseg-kschl = 'JADC'.
*            gt_final-add_cvd = gt_final-add_cvd + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
****** Freight
*          IF gt_rseg-kschl = 'ZRB1' OR gt_rseg-kschl = 'ZRC1' OR gt_rseg-kschl = 'FRA1'.
**          OR gt_rseg-kschl = 'ZFR1' OR gt_rseg-kschl = 'JOFV' OR gt_rseg-kschl = 'JOFP'.
*            gt_final-freight = gt_final-freight + gt_rseg-wrbtr .
*          ENDIF.
*
****** LBT
*          IF gt_rseg-kschl = 'JOCM'.
*            gt_final-lbt = gt_final-lbt + gt_rseg-wrbtr .
*          ENDIF.
*
******Inspection Charge
*          IF gt_rseg-kschl = 'ZINS'.
*            gt_final-insp = gt_final-insp + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
******Setting Charge
*          IF gt_rseg-kschl = 'ZSCV' OR gt_rseg-kschl = 'ZSCQ'.
*            gt_final-set_val = gt_final-set_val + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
*
******Insurance
*          IF gt_rseg-kschl = 'ZINR'.
*            gt_final-ins = gt_final-ins + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
******Devlopment Charges
*          IF gt_rseg-kschl = 'ZDV%' OR gt_rseg-kschl = 'ZDVQ' OR gt_rseg-kschl = 'ZDVV'.
*            gt_final-dev_ch = gt_final-dev_ch + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
******Other Charges
*          IF gt_rseg-kschl = 'ZOCV' OR gt_rseg-kschl = 'ZOCQ' OR gt_rseg-kschl = 'ZOC%'.
*            gt_final-oth_ch = gt_final-oth_ch + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
******Comp Cess %
*          IF gt_rseg-kschl = 'ZCES'.
*            gt_final-com_p = gt_final-com_p + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
*
******Comp Cess Val
*          IF gt_rseg-kschl = 'ZCEV'.
*            gt_final-com_v = gt_final-com_v + ( gt_rseg-wrbtr * gt_final-kursf ).
*          ENDIF.
****** FORWARDING
****        if gt_rseg-kschl = ''.
****          gt_final-forwarding = gt_final-forwarding + gt_rseg-wrbtr .
****        endif.
*
***** CLEARING
*          IF gt_rseg-kschl = 'JCFA' OR gt_rseg-kschl = 'ZCFA' OR gt_rseg-kschl = 'JFR2'.
*            gt_final-clearing = gt_final-clearing + gt_rseg-wrbtr .
*          ENDIF.
*
**BREAK Fujiabap.
********* AMORTISED VALUE                                  " ADDED BY PARESH BHOI
*            CHECK gt_rseg-kschl = 'ZAMV'.
**            IF gt_rseg-kschl = 'ZAMV'.
*              GT_FINAL-AMORT_VAL = gt_final-AMORT_VAL + gt_rseg-wrbtr.
**          ENDIF.
**********************************************************************
*
**ENDLOOP.
*
*
*
*
*
*ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  XYZ_NEW_GST_SGST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM xyz_new_gst_sgst .
*
*
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALCULATE_TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM calculate_tax .

        ls_tax-belnr = gt_bset1-belnr.

              IF gt_bset1-kschl = 'JVCS'.
*          gt_final-cst_tax = gt_final-cst_tax + gt_bset-hwste.
*                gt_final-cst_tax = gt_final-cst_tax + gt_bset1-hwste.
                ls_tax-cgst = ls_tax-cgst + gt_bset1-hwste.
                gt_final-cst     = gt_bset1-kbetr / 10.
                IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.

              IF gt_bset1-kschl = 'JMOP' OR gt_bset1-kschl = 'JMOQ' .
*          gt_final-bed = gt_final-bed + gt_bset-hwste.
*                gt_final-bed = gt_final-bed + gt_bset1-hwste.
                ls_tax-bed = ls_tax-bed + gt_bset1-hwste.
                IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.

              IF gt_bset1-kschl = 'JAOP' OR gt_bset1-kschl = 'JAOQ' .
*          gt_final-aed = gt_final-aed + gt_bset-hwste.
*                gt_final-aed =  gt_final-aed + gt_bset1-hwste.
                ls_tax-aed =  ls_tax-aed + gt_bset1-hwste.
                IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.

              IF gt_bset1-kschl = 'JVRD' OR gt_bset1-kschl = 'JVRN'.
*          gt_final-vat_tax = gt_final-vat_tax + gt_bset-hwste.
*                gt_final-vat_tax = gt_final-vat_tax + gt_bset1-hwste.
                ls_tax-vat_tax = ls_tax-vat_tax + gt_bset1-hwste.
                gt_final-vat     = gt_bset1-kbetr / 10.
                IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.
*
              IF gt_bset1-kschl = 'JICG' OR gt_bset1-kschl = 'JICN'.
*            OR gt_bset1-kschl = 'JICR' OR gt_bset1-kschl = 'ZCRN'.                               "CGST
                ls_tax-cgst = ls_tax-cgst + gt_bset1-hwste.          " total cgst_tax
                IF NOT gt_bset1-kbetr IS INITIAL AND gt_bset1-kschl = 'JICG'.
                  gt_final-cgst     = gt_bset1-kbetr / 10.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.

              IF gt_bset1-kschl = 'JISG' OR gt_bset1-kschl = 'JISN'.
*            OR gt_bset1-kschl = 'JISR' OR gt_bset1-kschl = 'ZSRN'.                               "SGST
                ls_tax-sgst = ls_tax-sgst + gt_bset1-hwste.
                IF NOT gt_bset1-kbetr IS INITIAL AND gt_bset1-kschl = 'JISG'.
                  gt_final-sgst  = gt_bset1-kbetr / 10.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.


              IF gt_bset1-kschl = 'JIIG' OR gt_bset1-kschl = 'JIIN'
                OR gt_bset1-kschl = 'JIMD' .                               "IGST
*                gt_final-igst_tax = gt_final-igst_tax + gt_bset1-hwste.
                ls_tax-igst_tax = ls_tax-igst_tax + gt_bset1-hwste.
                IF NOT gt_bset1-kbetr IS INITIAL AND gt_bset1-kschl = 'JIIG'.
                  gt_final-igst     = gt_bset1-kbetr / 10.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.



              IF gt_bset1-kschl = 'JSER' OR gt_bset1-kschl = 'JSVD' OR gt_bset1-kschl = 'JSV2'.
                IF gt_bset1-shkzg = 'S'.
*            gt_final-ser_val_dr = gt_final-ser_val_dr + gt_bset-hwste.
*                  gt_final-ser_val_dr = gt_final-ser_val_dr + gt_bset1-hwste.
                  ls_tax-ser_val_dr = ls_tax-ser_val_dr + gt_bset1-hwste.
                ELSEIF gt_bset1-shkzg = 'H'.
*            gt_final-ser_val_cr = gt_final-ser_val_cr + gt_bset-hwste.
*                  gt_final-ser_val_dr = gt_final-ser_val_dr - gt_bset1-hwste.
                  ls_tax-ser_val_dr = ls_tax-ser_val_dr - gt_bset1-hwste.
                ENDIF.
                IF gt_final-mwskz IS INITIAL.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.

              IF gt_bset1-kschl = 'JSSB'.
                IF gt_bset1-shkzg = 'S'.
*                  gt_final-sbc_dr = gt_final-sbc_dr + gt_bset1-hwste.
                  ls_tax-sbc_dr = ls_tax-sbc_dr + gt_bset1-hwste.
                ELSEIF gt_bset1-shkzg = 'H'.
*            gt_final-sbc_cr = gt_final-sbc_cr + gt_bset-hwste.
                  ls_tax-sbc_dr = ls_tax-sbc_dr - gt_bset1-hwste.
                ENDIF.
                IF gt_final-mwskz IS INITIAL.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.

              IF gt_bset1-kschl = 'JKKP' OR gt_bset1-kschl = 'ZKKR' OR gt_bset1-kschl = 'JKKN' OR gt_bset1-kschl = 'JSKK'
              OR gt_bset1-kschl = 'JKK1' OR gt_bset1-kschl = 'JKK2' OR gt_bset1-kschl = 'JKK3' OR gt_bset1-kschl = 'JKK4' .
                IF gt_bset1-shkzg = 'S'.
*            gt_final-kkc_dr = gt_final-kkc_dr + gt_bset-hwste.
*                  gt_final-kkc_dr = gt_final-kkc_dr + gt_bset1-hwste.
                  ls_tax-kkc_dr = ls_tax-kkc_dr + gt_bset1-hwste.
                ELSEIF gt_bset-shkzg = 'H'.
*            gt_final-kkc_cr = gt_final-kkc_cr + gt_bset-hwste.
*                  gt_final-kkc_dr = gt_final-kkc_dr - gt_bset1-hwste.
                  ls_tax-kkc_dr = ls_tax-kkc_dr - gt_bset1-hwste.
                ENDIF.
                IF gt_final-mwskz IS INITIAL AND gt_bset1-hwste IS NOT INITIAL.
                  gt_final-mwskz = gt_bset1-mwskz.
                ENDIF.
              ENDIF.
collect ls_tax INTO lt_tax.         " Abhishek
clear ls_tax.

ENDFORM.
