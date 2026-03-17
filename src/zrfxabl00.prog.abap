*&---------------------------------------------------------------------*
*&  Include           ZRFXABL00
*&---------------------------------------------------------------------*


***INCLUDE RFXABL00 .

*---------------------------------------------------------------------*
* FORM AENDBELEGE_ERMITTELN                                           *
*---------------------------------------------------------------------*
* Funktionsbaustein zur Ermittlung der Änderungsbelegköpfe aufrufen   *
*---------------------------------------------------------------------*
form aendbelege_ermitteln tables lr_objectid structure selopt.

  TYPES: BEGIN OF ys_cdhdr_obj,
           objectclas LIKE cdhdr-objectclas,
           objectid   LIKE cdhdr-objectid,
         END OF ys_cdhdr_obj.
  DATA: lt_cdhdr_obj TYPE ys_cdhdr_obj OCCURS 100 WITH HEADER LINE.
  DATA: ld_objectid  TYPE cdobjectv.
  DATA: ld_subrc     TYPE sy-subrc.
  DATA: ld_lines     TYPE i.

  CLEAR: ld_subrc.
  LOOP AT lr_objectid.
    IF lr_objectid-sign NE 'I' OR
    lr_objectid-option NE 'EQ'.
      ld_subrc = 1.
      EXIT.
    ENDIF.
  ENDLOOP.
  DESCRIBE TABLE lr_objectid LINES ld_lines.
  IF ld_subrc = 1 OR ld_lines LT 1.
    SELECT objectclas objectid FROM cdhdr
                      INTO TABLE lt_cdhdr_obj
                      WHERE objectclas = objekt
                        AND objectid IN lr_objectid
                        AND udate IN datum
                        AND username IN uname.
  ELSE.
    LOOP AT lr_objectid.
      ld_objectid = lr_objectid-low.
      SELECT objectclas objectid FROM cdhdr
                        INTO lt_cdhdr_obj
                        WHERE objectclas = objekt
                          AND objectid  = ld_objectid
                          AND udate IN datum
                          AND username IN uname.
        APPEND lt_cdhdr_obj.
      ENDSELECT.
    ENDLOOP.
  ENDIF.
  SORT lt_cdhdr_obj BY objectclas objectid.
  DELETE ADJACENT DUPLICATES FROM lt_cdhdr_obj.
  LOOP AT lt_cdhdr_obj.
    REFRESH icdhdr.
* optimize reading for exact date
*    if not low_datum is initial and datum-high is initial
*      and datum-option = 'EQ' and datum-sign = 'I'.  "2084718
*      datum-high = low_datum.
*    endif.
    PERFORM min_max_datum_ermitteln.                 "2265786
    datum-high = high_datum.
    CALL FUNCTION 'CHANGEDOCUMENT_READ_HEADERS'
      EXPORTING
        objectclass       = lt_cdhdr_obj-objectclas
        objectid          = lt_cdhdr_obj-objectid
        username          = usrname
        time_of_change    = uhrzeit
        date_of_change    = low_datum
        date_until        = datum-high
      TABLES
        i_cdhdr           = icdhdr
      EXCEPTIONS
        no_position_found = 1
        OTHERS            = 2.
    IF sy-subrc = 0 AND NOT icdhdr[] IS INITIAL.
      PERFORM aendpositionen_lesen.
    ENDIF.
  ENDLOOP.

ENDFORM.                    "aendbelege_ermitteln

*---------------------------------------------------------------------*
* FORM AENDPOSITIONEN_ERMITTELN                                       *
*---------------------------------------------------------------------*
* Funktionsbaustein zur Ermittlung der Änderungsbelegpositionen       *
* aufrufen                                                            *
*---------------------------------------------------------------------*
FORM aendpositionen_ermitteln.
  DATA: ls_msgtab LIKE fimsg.

  CALL FUNCTION 'CHANGEDOCUMENT_READ_POSITIONS'
    EXPORTING
      changenumber      = icdhdr-changenr
    IMPORTING
      header            = cdhdr
    TABLES
      editpos           = helpcdpos
    EXCEPTIONS
      no_position_found = 1
      OTHERS            = 2.
  IF sy-subrc = 0.
    REFRESH icdpos.                    "kein CLEAR, Felder aus ICDPOS
    LOOP AT helpcdpos.                 "sind teilweise bereits gefüllt!!
      MOVE-CORRESPONDING helpcdpos TO icdpos.
      APPEND icdpos.
    ENDLOOP.
    SORT ICDPOS BY TABNAME TABKEY.                             "1473861
    PERFORM positionen_in_extract.
  ELSE.
    CASE sy-subrc.
      WHEN 1.
        REFRESH icdpos.
        CLEAR helpcdpos.
        MOVE-CORRESPONDING helpcdpos TO icdpos.
        icdpos-chngind = 'U'.
        APPEND icdpos.
        PERFORM positionen_in_extract.
        CLEAR ls_msgtab.
        ls_msgtab-msort = '1'.
        ls_msgtab-msgid = 'FR'.
        ls_msgtab-msgty = 'E'.
        ls_msgtab-msgno = '520'.
        ls_msgtab-msgv1 = icdhdr-objectclas.
        ls_msgtab-msgv2 = icdhdr-changenr.
        CALL FUNCTION 'FI_MESSAGE_COLLECT'
          EXPORTING
            i_fimsg = ls_msgtab.
      WHEN 2.
        MESSAGE a080(fc) WITH 'AENDPOSITIONEN_LESEN' 'RC = 2'.
    ENDCASE.
  ENDIF.
ENDFORM.                    "AENDPOSITIONEN_ERMITTELN

*---------------------------------------------------------------------*
* FORM BATCH_HEADING                                                  *
*---------------------------------------------------------------------*
* BATCH-HEADING Felder belegen                                        *
*---------------------------------------------------------------------*
FORM batch_heading.
  bhdgd-bukrs = space.
  bhdgd-inifl = '0'.
  IF sy-linsz < 999.           "n2029628 to avoid dump
    bhdgd-lines = sy-linsz.
  ELSE.
    bhdgd-lines = 999.
  ENDIF.
*  bhdgd-lines = sy-linsz.              "Zeilenbreite der Liste
  bhdgd-uname = sy-uname.              "Benutzername
  bhdgd-repid = sy-repid.              "Name des ABAP-Programmes
  bhdgd-line1 = sy-title.              "Titel des ABAP-Programms
  bhdgd-separ = space.                 "Keine Listseparation
ENDFORM.                    "BATCH_HEADING

*---------------------------------------------------------------------*
* FORM FARBE_WECHSELN                                                 *
*---------------------------------------------------------------------*
* Streifenmuster: Die Farbe wird gewechselt und damit auch der Wert   *
*                 von XCOLOR                                          *
*---------------------------------------------------------------------*
FORM farbe_wechseln.
  IF xcolor = 'X'.
    IF NOT ICDPOS-TABNAME IS INITIAL.
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    ENDIF.
    CLEAR xcolor.
  ELSE.
    xcolor = 'X'.
  ENDIF.
ENDFORM.                    "FARBE_WECHSELN

*---------------------------------------------------------------------*
* FORM  FEHLERPROTOKOLL_AUSGEBEN                                      *
*---------------------------------------------------------------------*
* Falls Fehler aufgetreten sind, werden diese nun im Fehlerprotokoll  *
* ausgegeben.                                                         *
*---------------------------------------------------------------------*
FORM fehlerprotokoll_ausgeben.

  DATA: ls_layout TYPE slis_layout_alv.
  CONSTANTS: lc_x value 'X'.

*------ Sind auszugebende Fehlernachrichten vorhanden ? ----------------
  CALL FUNCTION 'FI_MESSAGE_CHECK'
    EXCEPTIONS
      no_message = 01.
  IF sy-subrc = 0.

*------ TOP-OF-PAGE für Fehlerprotokoll ausgeben -----------------------
    xerrprot = 'X'.

*------ Wurden zuvor Belege ausgegeben, dann bitte eine neue Seite -----
    IF xsele = 'X'.
      NEW-PAGE.
    ENDIF.

*------ Fehlernachrichten sortieren ------------------------------------
    CALL FUNCTION 'FI_MESSAGE_SORT'.
    IF xfeld = space.
      ls_layout-list_append = lc_x.
      ls_layout-colwidth_optimize = lc_x.

      CALL FUNCTION 'FI_MESSAGES_ALV'
       EXPORTING
         i_headline = text-f00
         is_layout  = ls_layout.
    ENDIF.
  ENDIF.
ENDFORM.                    "FEHLERPROTOKOLL_AUSGEBEN

*---------------------------------------------------------------------*
* FORM  FELDATTRIBUTE_TABELLE                                         *
*---------------------------------------------------------------------*
* Schlüsselworte der Felder von TABELLE lesen                         *
*---------------------------------------------------------------------*
* -->  TABELLE    Tabellenname                                        *
*---------------------------------------------------------------------*
FORM feldattribute_tabelle USING tabelle TYPE c.

*------ Lokale Datendeklarationen --------------------------------------
  DATA: lv_tabname LIKE dd02v-tabname.

  DATA: BEGIN OF dd03p_tab OCCURS 50.            "Feldinfos aus DD03P
          INCLUDE STRUCTURE dfies.
  DATA: END   OF dd03p_tab.
*------ Tabellenfelder ermitteln ---------------------------------------
  lv_tabname = tabelle.
  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname   = lv_tabname
    TABLES
      dfies_tab = dd03p_tab.
*------ Tabellenfelder merken ------------------------------------------
  LOOP AT dd03p_tab.
    CLEAR: fldattrtab.
    fldattrtab-tbnam    = dd03p_tab-tabname.
    fldattrtab-fdnam    = dd03p_tab-fieldname.
    fldattrtab-datatype = dd03p_tab-datatype.
    fldattrtab-intlen   = dd03p_tab-intlen.
    fldattrtab-text     = dd03p_tab-scrtext_m.

    IF fldattrtab-text = space.
      fldattrtab-text = dd03p_tab-scrtext_s.
    ENDIF.
    IF fldattrtab-text = space.
      fldattrtab-text = dd03p_tab-scrtext_l.
    ENDIF.
    IF fldattrtab-text = space.
      fldattrtab-text = dd03p_tab-fieldtext.
    ENDIF.
    APPEND fldattrtab.
  ENDLOOP.
ENDFORM.                    "FELDATTRIBUTE_TABELLE

*---------------------------------------------------------------------*
* FORM  FELD_PRUEFEN                                                  *
*---------------------------------------------------------------------*
* Die Änderungsbelege zu bestimmten Felder (Änderung erfolgt implizit *
* durch das Programm) werden nicht ausgegeben. Die Ausgabe der        *
* Änderungsbelege zu diesen Feldern macht nur bei der interaktiven    *
* Anzeige von Änderungsbelegen Sinn.                                  *
*---------------------------------------------------------------------*
* -->  ERGEBNIS   4 ==> Änderungsbeleg zu diesem Feld nicht ausgeben  *
*---------------------------------------------------------------------*
FORM feld_pruefen USING ergebnis LIKE sy-subrc.
  ergebnis = 0.
  IF icdpos-tabname = 'BKPF'  AND icdpos-fname = 'AEDAT'
  OR icdpos-tabname = 'BSEGM' AND icdpos-fname = 'AEDAT'
  OR icdpos-tabname = 'EBKPF' AND icdpos-fname = 'AEDAT'
  OR icdpos-tabname = 'KNKK'  AND icdpos-fname = 'AEDAT'
  OR icdpos-tabname = 'KNKK'  AND icdpos-fname = 'AENAM'
  OR icdpos-tabname = 'KNKK'  AND icdpos-fname = 'AETXT'.
    ergebnis = 4.
  ENDIF.
ENDFORM.                    "FELD_PRUEFEN

*---------------------------------------------------------------------*
* FORM  FLDATTR_ERMITTELN                                             *
*---------------------------------------------------------------------*
* Der Feldtext zur Änderungsbelegposition wird ermittelt              *
*---------------------------------------------------------------------*
FORM fldattr_ermitteln.

*------ CHNGIND = 'U' ==> FLDTEXT mit Schlüsselwort zum Feld belegen ---
*------                   FLDTYPE mit Datentyp zum Feld belegen      ---
  IF icdpos-chngind = 'U'.
    LOOP AT fldattrtab WHERE tbnam = icdpos-tabname
                         AND fdnam = icdpos-fname.
    ENDLOOP.
    IF sy-subrc = 0.
      fldtype = fldattrtab-datatype.
      IF ICDPOS-tabname = 'ADRC' and
         ICDPOS-tabkey+21(1) ne SPACE.                        "1506402
        concatenate fldattrtab-text '(' ICDPOS-tabkey+21(1) ')'
          into fldtext.                                       "1506402
      ELSE.                                                   "1506402
        fldtext = fldattrtab-text.
      ENDIF.
    ELSE.
      fldtext = text-001.
      CLEAR fldtype.
    ENDIF.

*------ CHNGIND <> 'U' ==> FLDTEXT mit der Tabellenbezeichnung belegen -
  ELSE.
    CASE icdpos-tabname.
      WHEN 'BSEC'.
        fldtext = text-nbs.
      WHEN 'BSED'.
        fldtext = text-nbs.
      WHEN 'BSEG'.
        fldtext = text-nbs.
      WHEN 'BSEGM'.
        fldtext = text-nbs.
      WHEN 'BSEGR'.
        fldtext = text-nbs.
      WHEN 'BSET'.
        fldtext = text-nbs.
      WHEN 'EBSEG'.
        fldtext = text-nbs.
      WHEN 'KNA1'.
        fldtext = text-na1.
      WHEN 'KNAS'.
        fldtext = text-nas.
      WHEN 'KNAT'.
        fldtext = text-nat.
      WHEN 'KNB1'.
        fldtext = text-nb1.
      WHEN 'KNB5'.
        fldtext = text-nb5.
      WHEN 'KNBK'.
        fldtext = text-nbk.
      WHEN 'KNBW'.
        fldtext = text-nbw.
      WHEN 'KNEX'.
        fldtext = text-nex.
      WHEN 'KNKA'.
        fldtext = text-nka.
      WHEN 'KNKK'.
        fldtext = text-nkk.
      WHEN 'KNVA'.
        fldtext = text-nva.
      WHEN 'KNVD'.
        fldtext = text-nvd.
      WHEN 'KNVI'.
        fldtext = text-nvi.
      WHEN 'KNVK'.
        fldtext = text-nvk.
      WHEN 'KNVL'.
        fldtext = text-nvl.
      WHEN 'KNVP'.
        fldtext = text-nvp.
      WHEN 'KNVV'.
        fldtext = text-nvv.
      WHEN 'KNZA'.
        fldtext = text-nza.
      WHEN 'LFA1'.
        fldtext = text-na1.
      WHEN 'LFAS'.
        fldtext = text-nas.
      WHEN 'LFAT'.
        fldtext = text-nat.
      WHEN 'LFB1'.
        fldtext = text-nb1.
      WHEN 'LFB5'.
        fldtext = text-nb5.
      WHEN 'LFBK'.
        fldtext = text-nbk.
      WHEN 'LFBW'.
        fldtext = text-nbw.
      WHEN 'LFEI'.
        fldtext = text-nei.
      WHEN 'LFLR'.
        fldtext = text-nlr.
      WHEN 'LFM1'.
        fldtext = text-nm1.
      WHEN 'LFM2'.
        fldtext = text-nm1.
      WHEN 'LFZA'.
        fldtext = text-nza.
      WHEN 'SKA1'.
        fldtext = text-na1.
      WHEN 'SKB1'.
        fldtext = text-nb1.
      WHEN 'SKAT'.
        fldtext = text-nat.
      WHEN 'VBKPF'.
        fldtext = text-nbk.
      WHEN 'VBSEC'.
        fldtext = text-nbs.
      WHEN 'VBSEG'.
        fldtext = text-nbs.
      WHEN 'VBSET'.
        fldtext = text-nbs.
      WHEN 'WYT1'.
        fldtext = text-nt1.
      WHEN 'WYT1T'.
        fldtext = text-nt1.
      WHEN 'WYT3'.
        fldtext = text-nt3.
      WHEN OTHERS.
        IF icdpos-tabname CP 'AD*'.
          IF ICDPOS-tabkey+21(1) ne SPACE and
             ICDPOS-TABNAME = 'ADRC'.                         "1506402
            concatenate text-zav '(' ICDPOS-tabkey+21(1) ')'
            into fldtext.                                     "1506402
          ELSE.
            fldtext = text-zav.
          ENDIF.
        ELSE.
          SELECT SINGLE ddtext FROM dd02t INTO fldtext    "Note 1551976
                        WHERE tabname    = icdpos-tabname
                          AND ddlanguage = sy-langu.       "#EC *
        ENDIF.
    ENDCASE.
    IF fldtext IS INITIAL.                                "Note 1551976
      fldtext = text-001.
    ENDIF.
    CLEAR fldtype.
  ENDIF.
ENDFORM.                    "FLDATTR_ERMITTELN

*---------------------------------------------------------------------*
* FORM  FLDTAB_FUELLEN                                                *
*---------------------------------------------------------------------*
* FLDTAB füllen mit den Feldern der gewünschten Feldgruppen aus T055G *
*---------------------------------------------------------------------*
* --> KOART    Kontoart                                               *
*---------------------------------------------------------------------*
FORM fldtab_fuellen USING koart TYPE c.
  CLEAR fldtab.                   "kein REFRESH, da bei Belegen mit
  CLEAR xgrupp.                   "Vorerfassungen zwei Aufrufe erfolgen
  IF NOT grupp-low  IS INITIAL
  OR NOT grupp-high IS INITIAL.
    xgrupp = 'X'.
    SELECT * FROM t055g WHERE koart =  koart
                          AND grupp IN grupp.
      SELECT * FROM t055 WHERE koart = koart
                           AND grupp = t055g-grupp.
        CHECK NOT t055-feldn IS INITIAL.
        SEARCH t055-feldn FOR '-'.
        fldtab-tabname = t055-feldn(sy-fdpos).
        SHIFT t055-feldn LEFT BY sy-fdpos PLACES.
        SHIFT t055-feldn LEFT.
        fldtab-fname   = t055-feldn.
        COLLECT fldtab.
      ENDSELECT.
    ENDSELECT.
  ELSE.
    READ TABLE grupp INDEX 1.
    IF sy-subrc = 0.
      IF grupp-low IS INITIAL AND grupp-high IS INITIAL.
        SELECT * FROM t055g WHERE koart =  koart
                              AND grupp IN grupp.
          SELECT * FROM t055 WHERE koart = koart
                               AND grupp = t055g-grupp.
            CHECK NOT t055-feldn IS INITIAL.
            SEARCH t055-feldn FOR '-'.
            fldtab-tabname = t055-feldn(sy-fdpos).
            SHIFT t055-feldn LEFT BY sy-fdpos PLACES.
            SHIFT t055-feldn LEFT.
            fldtab-fname   = t055-feldn.
            COLLECT fldtab.
          ENDSELECT.
        ENDSELECT.
        IF sy-subrc = 0.
          xgrupp = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "FLDTAB_FUELLEN

*---------------------------------------------------------------------*
* FORM  FLDTAB_PRUEFEN                                                *
*---------------------------------------------------------------------*
* Prüfung, ob die Änderung die gewünschten Felder betrifft            *
*---------------------------------------------------------------------*
* <-- ERGEBNIS   Betrifft die Änderung die gewünschten Felder?        *
*---------------------------------------------------------------------*
FORM fldtab_pruefen USING ergebnis LIKE sy-subrc.
  ergebnis = 0.
  CHECK xgrupp = 'X'.
  IF icdpos-chngind = 'U'.
    LOOP AT fldtab WHERE tabname = icdpos-tabname
                     AND fname   = icdpos-fname.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      ergebnis = 4.
    ENDIF.
  ELSE.
    LOOP AT fldtab WHERE tabname = icdpos-tabname.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      ergebnis = 4.
    ENDIF.
  ENDIF.
ENDFORM.                    "FLDTAB_PRUEFEN

*---------------------------------------------------------------------*
* FORM KEYSTRING_ERMITTELN                                            *
*---------------------------------------------------------------------*
* Der String für die auszugebenden Keyfelder wird erzeugt             *
*---------------------------------------------------------------------*
FORM keystring_ermitteln.

*------ Keystring initialisieren ---------------------------------------
  CLEAR keystr.

*------ Keystring ermitteln --------------------------------------------
  CASE icdpos-tabname.
    WHEN 'KNAS'.
      keystr(8)  = text-kas.
      REPLACE '&' WITH icdpos-tabkey+13(3)  INTO keystr.   "KNAS-LAND1
    WHEN 'KNAT'.
      keystr(17) = text-kat.
      REPLACE '&' WITH icdpos-tabkey+13(3) INTO keystr.    "KNAT-TAXGR
    WHEN 'KNB5'.
      keystr(8)  = text-kb5.
      REPLACE '&' WITH icdpos-tabkey+17(2)  INTO keystr.   "KNB5-MABER
    WHEN 'KNBK'.
      keystr(14) = text-kbk.                                "2093089
      REPLACE '&' WITH icdpos-tabkey+13(3)  INTO keystr.   "KNBK-BANKS
      REPLACE '&' WITH icdpos-tabkey+16(15) INTO keystr.   "KNBK-BANKL
      REPLACE '&' WITH icdpos-tabkey+31(18) INTO keystr.   "KNBK-BANKN
    WHEN 'KNBW'.
      keystr(8)  = text-kbw.
      REPLACE '&' WITH icdpos-tabkey+17(2) INTO keystr.    "LFBW-WITHT
    WHEN 'KNEX'.
      keystr(8)  = text-kex.
      REPLACE '&' WITH icdpos-tabkey+13(3)  INTO keystr.   "KNEX-LNDEX
    WHEN 'KNVA'.
      keystr(15) = text-kva.
      REPLACE '&' WITH icdpos-tabkey+13(25) INTO keystr.   "KNVA-ABLAD
    WHEN 'KNVD'.
      keystr(14) = text-kvd.
      REPLACE '&' WITH icdpos-tabkey+21(4)  INTO keystr.   "KNVD-DOCTP
      REPLACE '&' WITH icdpos-tabkey+22(1)  INTO keystr.   "KNVD-SPRAS
    WHEN 'KNVI'.
      keystr(11) = text-kvi.
      REPLACE '&' WITH icdpos-tabkey+13(3)  INTO keystr.   "KNVI-ALAND
      REPLACE '&' WITH icdpos-tabkey+16(4)  INTO keystr.   "KNVI-TATYP
    WHEN 'KNVK'.
      keystr(18) = text-kvk.
      REPLACE '&' WITH icdpos-tabkey+3(10)  INTO keystr.   "KNVK-PARNR
    WHEN 'KNVL'.
      keystr(13) = text-kvl.
      REPLACE '&' WITH icdpos-tabkey+13(3)  INTO keystr.   "KNVL-ALAND
      REPLACE '&' WITH icdpos-tabkey+16(4)  INTO keystr.   "KNVL-TATYP
      REPLACE '&' WITH icdpos-tabkey+20(15) INTO keystr.   "KNVL-LICNR
    WHEN 'KNVP'.
      keystr(15) = text-kvp.
      REPLACE '&' WITH ' ' INTO keystr.
      CONCATENATE keystr(15) icdpos-tabkey+21(2) icdpos-tabkey+23(3)
                                                        INTO keystr.
    WHEN 'KNZA'.
      keystr(12) = text-lza.
      REPLACE '&' WITH icdpos-tabkey+17(10) INTO keystr.   "KNZA-EMPFD
    WHEN 'LFAS'.
      keystr(8)  = text-las.
      REPLACE '&' WITH icdpos-tabkey+13(3) INTO keystr.    "LFAS-LAND1
    WHEN 'LFAT'.
      keystr(17) = text-lat.
      REPLACE '&' WITH icdpos-tabkey+13(3) INTO keystr.    "LFAT-TAXGR
    WHEN 'LFB5'.
      keystr(8) = text-lb5.
      REPLACE '&' WITH icdpos-tabkey+17(2) INTO keystr.    "LFB5-MABER
    WHEN 'LFBK'.
      keystr(14) = text-lbk.                               "2093089
      REPLACE '&' WITH icdpos-tabkey+13(3)  INTO keystr.   "LFBK-BANKS
      REPLACE '&' WITH icdpos-tabkey+16(15) INTO keystr.   "LFBK-BANKL
      REPLACE '&' WITH icdpos-tabkey+31(18) INTO keystr.   "LFBK-BANKN
    WHEN 'LFBW'.
      keystr(8)  = text-lbw.
      REPLACE '&' WITH icdpos-tabkey+17(2) INTO keystr.    "LFBW-WITHT
    WHEN 'LFLR'.
      keystr(17) = text-llr.
      REPLACE '&' WITH icdpos-tabkey+13(3)  INTO keystr.   "LFBK-BANKS
      REPLACE '&' WITH icdpos-tabkey+16(10) INTO keystr.   "LFBK-BANKL
    WHEN 'LFM2'.
      keystr(13) = text-lm2.
      REPLACE '&' WITH icdpos-tabkey+17(6)  INTO keystr.   "LFM2-LTSNR
      REPLACE '&' WITH icdpos-tabkey+23(4)  INTO keystr.   "LFM2-WERKS
    WHEN 'LFZA'.
      keystr(10) = text-lza.
      REPLACE '&' WITH icdpos-tabkey+17(10) INTO keystr.   "LFZA-EMPFK
    WHEN 'SKAT'.
      keystr(10) = text-lat.
      REPLACE '&' WITH icdpos-tabkey+3(1)   INTO keystr.   "SKAT-SPRAS
    WHEN 'VBKPF'.
      keystr(25) = text-lbk.
      REPLACE '&' WITH bkpf-xblnr(10)       INTO keystr.   "Folgebelegnr
      REPLACE '&' WITH bkpf-xblnr+10(4)     INTO keystr.   "Folgebeleggj
    WHEN 'WYT1'.
      keystr(8) = text-lt1.
      REPLACE '&' WITH icdpos-tabkey+13(6)  INTO keystr.   "WYT1-LTSNR
    WHEN 'TIBAN'.                                        "Note 1551976
      IF text-lbk NE '*'.
        keystr(14) = text-lbk.                              "2093089
      ELSE.
        keystr(14) = text-kbk.                              "2093089
      ENDIF.
      REPLACE '& & &' WITH '& & & &' INTO keystr.
      REPLACE '&' WITH icdpos-tabkey+3(3)  INTO keystr.    "TIBAN-BANKS
      REPLACE '&' WITH icdpos-tabkey+6(15) INTO keystr.    "TIBAN-BANKL
      REPLACE '&' WITH icdpos-tabkey+21(35) INTO keystr.   "TIBAN-BANKN
      REPLACE '&' WITH icdpos-tabkey+56(2) INTO keystr.    "TIBAN-BKONT
    WHEN 'WYT1T'.
      keystr(10) = text-ltt.
      REPLACE '&' WITH icdpos-tabkey+3(1)   INTO keystr.   "WYT1T-SPRAS
      REPLACE '&' WITH icdpos-tabkey+14(6)  INTO keystr.   "WYT1T-LTSNR
    WHEN 'WYT3'.
      keystr(29) = text-lt3.
      REPLACE '&' WITH icdpos-tabkey+17(6)  INTO keystr.   "WYT3-LTSNR
      REPLACE '&' WITH icdpos-tabkey+23(4)  INTO keystr.   "WYT3-WERKS
      REPLACE '&' WITH icdpos-tabkey+27(2)  INTO keystr.   "WYT3-PARVW
  ENDCASE.
ENDFORM.                    "KEYSTRING_ERMITTELN

*---------------------------------------------------------------------*
*       FORM KUENSTLICHER_EXTRAKT                                     *
*---------------------------------------------------------------------*
*       Derzeitiger Stand:                                            *
*         Bei Erfassungen und Löschungen wird jeweils nur ein         *
*         Änderungsbeleg angezeigt (kein Änderungsbeleg pro Feld)     *
*       <-- ERGEBNIS: X - Satz in Extract schreiben                   *
*---------------------------------------------------------------------*
FORM kuenstlicher_extrakt USING ergebnis LIKE sy-subrc.
  ergebnis = '4'.
  CASE icdpos-chngind.

*------ Löschung ohne Einzelfelddoku -----------------------------------
    WHEN 'D'.
      icdpos-f_new = text-m02.
      ergebnis = '0'.

*------ Löschung mit Einzelfelddoku:                      --------------
*------   Nur ein Änderungsbeleg für die gesamte Löschung --------------
    WHEN 'E'.
      CHECK old-tabname <> icdpos-tabname
         OR old-tabkey  <> icdpos-tabkey.
      MOVE-CORRESPONDING icdpos TO old.
      CLEAR: icdpos-fname,
             icdpos-f_old.
      icdpos-f_new = text-m02.
      ergebnis = '0'.

*------ Erfassung (immer ohne Einzelfelddoku) --------------------------
    WHEN 'I'.
      icdpos-f_new = text-m01.
      ergebnis = '0'.
  ENDCASE.
ENDFORM.                    "KUENSTLICHER_EXTRAKT

*---------------------------------------------------------------------*
* FORM LOW_DATUM_ERMITTELN                                            *
*---------------------------------------------------------------------*
* Aus den für die Select-Option eingegebenen Werten wird das kleinste *
* gewählte Datum ermittelt                                            *
*---------------------------------------------------------------------*
FORM low_datum_ermitteln.
  IF ( datum-option = 'LT' AND datum-sign = 'E' )
  OR ( datum-option = 'LE' AND datum-sign = 'E' )
  OR ( datum-option = 'EQ' AND datum-sign = 'I' )
  OR ( datum-option = 'NE' AND datum-sign = 'E' )
  OR ( datum-option = 'GE' AND datum-sign = 'I' )
  OR ( datum-option = 'GT' AND datum-sign = 'I' )
  OR ( datum-option = 'BT' AND datum-sign = 'I' )
  OR ( datum-option = 'NB' AND datum-sign = 'E' ).
    low_datum = datum-low.
  ELSE.
    CLEAR low_datum.
  ENDIF.
ENDFORM.                    "LOW_DATUM_ERMITTELN

*---------------------------------------------------------------------*
* FORM  POSZEILE2_AUSGEBEN                                            *
*---------------------------------------------------------------------*
* 2. Zeile der Änderungsbelegposition: - Technische Feldnamen ausgeben*
*                                      - Weitere Schlüssel ausgeben   *
*---------------------------------------------------------------------*
* FORM POSZEILE2_AUSGEBEN. "removed Retroif
FORM poszeile2_ausgeben CHANGING x_descr  x_tabfeld x_keystr. "ins Retr    " comment by supriya on 25.07.2024
*  FORM poszeile2_ausgeben CHANGING x_descr. " x_tabfeld x_keystr. "ins Retr
*------ Lokale Datendeklarationen --------------------------------------
  DATA: lv_dscrp(40) TYPE c,
        lv_xfound(1) TYPE c.

*------ Kennzeichen 'Daten für zweite Zeile gefunden' initialisieren ---
  CLEAR lv_xfound.

*------ Name/Ort ausgeben ----------------------------------------------
  PERFORM bezeichnung_ermitteln USING lv_dscrp.
  IF NOT LV_DSCRP IS INITIAL.
    LV_XFOUND = 'X'.
    MOVE lv_dscrp TO x_descr.
  ENDIF.
  IF LV_XFOUND = SPACE.
    LV_XFOUND = 'X'.
  ENDIF.
  MOVE tabfeld TO x_tabfeld.          " commented by supriya

*------ Weitere Schlüssel ausgeben bei bestimmten Tabellen -------------
  IF icdpos-tabname = 'KNAS'
  OR icdpos-tabname = 'KNAT'
  OR icdpos-tabname = 'KNBK'
  OR (  icdpos-tabname  =  'KNB5'
       AND NOT icdpos-tabkey+17(2) IS INITIAL )
  OR icdpos-tabname = 'KNBW'
  OR icdpos-tabname = 'KNEX'
  OR icdpos-tabname = 'KNVA'
  OR icdpos-tabname = 'KNVD'
  OR icdpos-tabname = 'KNVI'
  OR icdpos-tabname = 'KNVK'
  OR icdpos-tabname = 'KNVL'
  OR icdpos-tabname = 'KNVP'
  OR icdpos-tabname = 'KNZA'
  OR icdpos-tabname = 'LFAS'
  OR icdpos-tabname = 'LFAT'
  OR icdpos-tabname = 'LFBK'
  OR (         icdpos-tabname      =  'LFB5'
       AND NOT icdpos-tabkey+17(2) IS INITIAL )
  OR icdpos-tabname = 'LFBW'
  OR icdpos-tabname = 'LFLR'
  OR icdpos-tabname = 'LFM2'
  OR icdpos-tabname = 'LFZA'
  OR (         icdpos-tabname      =  'VBKPF'
       AND     icdpos-f_new        =  text-m02
       AND NOT bkpf-xblnr          IS INITIAL
       AND     bkpf-bstat          =  'W'     )
  OR icdpos-tabname = 'TIBAN'                             "Note 1551976
  OR icdpos-tabname = 'WYT1'
  OR icdpos-tabname = 'WYT1T'
  OR icdpos-tabname = 'WYT3'.
    PERFORM keystring_ermitteln.
    REPLACE ALL OCCURRENCES OF ';' IN KEYSTR WITH ''.        "n_1286334
    IF lv_xfound = space.
      lv_xfound = 'X'.
    ENDIF.
    MOVE keystr TO x_keystr .         " COMMENTED BY SUPRIYA ON 25.07.2024
  ENDIF.

ENDFORM.                    "poszeile2_ausgeben

*---------------------------------------------------------------------*
* FORM SORT_PRUEFEN                                                   *
*---------------------------------------------------------------------*
* Überprüfen der Eingabe im Feld 'Sortierung'                         *
*---------------------------------------------------------------------*
FORM sort_pruefen.
  IF sort < '1'                                           "#EC PORTABLE
  OR sort > '4'.                                          "#EC PORTABLE

*    MESSAGE ZE280.
  MESSAGE e280(Z280).
  ENDIF.
ENDFORM.                    "SORT_PRUEFEN

*---------------------------------------------------------------------*
* FORM TABFELD_ERMITTELN                                              *
*---------------------------------------------------------------------*
* Technischen Namen des Tabellenfeldes ermitteln                      *
*---------------------------------------------------------------------*
FORM tabfeld_ermitteln.
  CLEAR tabfeld.
  tabfeld = icdpos-tabname.
  IF NOT icdpos-fname IS INITIAL.
    tabfeld+30(1)  = '-'.
    tabfeld+31(30) = icdpos-fname.
    CONDENSE tabfeld NO-GAPS.
  ENDIF.
ENDFORM.                    "TABFELD_ERMITTELN

*---------------------------------------------------------------------*
* FORM USRNAME_FUELLEN                                                *
*---------------------------------------------------------------------*
* Export-Parameter USRNAME (Änderer) für den Aufruf des FktBausteins  *
* CHANGEDOCUMENT_READ_HEADERS füllen                                  *
*---------------------------------------------------------------------*
FORM usrname_fuellen.
  CLEAR usrname.
  DESCRIBE TABLE uname LINES lin.
  IF  lin          = 1
  AND uname-option = 'EQ'
  AND uname-sign   = 'I'.
    usrname = uname-low.
  ENDIF.
ENDFORM.                    "USRNAME_FUELLEN

*---------------------------------------------------------------------*
* FORM UZEIT_FORMATIEREN                                              *
*---------------------------------------------------------------------*
* Uhrzeit fünfstellig (ohne Sekundenangabe ausgeben)                  *
*---------------------------------------------------------------------*
FORM uzeit_formatieren.
  uzeit(2) =   icdhdr-utime(2).
  uzeit+2(1) = ':'.
  uzeit+3(2) = icdhdr-utime+2(2).
ENDFORM.                    "UZEIT_FORMATIEREN

*---------------------------------------------------------------------*
* FORM WERTE_AUSGEBEN                                                 *
*---------------------------------------------------------------------*
* 'Neuer Wert' und 'Alter Wert' sowie anfallende SY-VLINE ausgeben    *
*---------------------------------------------------------------------*
FORM werte_ausgeben.
  DATA: posalt     TYPE i,                                 "#EC NEEDED
        laenge_new TYPE i,                                 "#EC NEEDED
        laenge_old TYPE i.
  posalt = pos2 + 36.
  laenge_new = STRLEN( icdpos-f_new ).
  laenge_old = STRLEN( icdpos-f_old ).
ENDFORM.                    "WERTE_AUSGEBEN

*---------------------------------------------------------------------*
* FORM ZAHLEN_LINKSBUENDIG                                            *
*---------------------------------------------------------------------*
* Zahlen bei 'Alter' und 'Neuer Wert' werden linksbündig ausgegeben   *
*---------------------------------------------------------------------*
FORM zahlen_linksbuendig.
  IF fldtype = 'CURR' OR fldtype = 'DEC' OR fldtype = 'FLTP'
  OR fldtype(3) = 'INT'.
    IF icdpos-f_new CN ' '.
      SHIFT icdpos-f_new BY sy-fdpos PLACES.
    ENDIF.
    IF icdpos-f_old CN ' '.
      SHIFT icdpos-f_old BY sy-fdpos PLACES.
    ENDIF.
  ENDIF.
ENDFORM.                    "ZAHLEN_LINKSBUENDIG

*---------------------------------------------------------------------*
* FORM ZAHLEN_INITIALISIEREN                                          *
*---------------------------------------------------------------------*
* Zahlen und Datumswerte mit Initialwert werden als SPACE ausgegeben  *
*---------------------------------------------------------------------*
FORM zahlen_initialisieren.
  IF fldtype = 'CURR' OR fldtype = 'DATS' OR fldtype = 'DEC'
  OR fldtype = 'FLTP' OR fldtype(3) = 'INT'.
    IF icdpos-f_new CO '0., '.
      CLEAR icdpos-f_new.
    ENDIF.
    IF icdpos-f_old CO '0., '.
      CLEAR icdpos-f_old.
    ENDIF.
  ENDIF.
ENDFORM.                    "ZAHLEN_INITIALISIEREN

*&---------------------------------------------------------------------*
*&      Form  check_program_auth
*&---------------------------------------------------------------------*
FORM check_program_auth CHANGING cd_tpc_check TYPE char1.

  CALL FUNCTION 'FI_CHECK_DATE'
    EXPORTING
      i_bukrs           = space
      i_user            = sy-uname
      i_program         = sy-repid
    IMPORTING
      e_return          = cd_tpc_check
    EXCEPTIONS
      no_authority_prog = 1
      no_authority_date = 2
      wrong_parameter   = 3
      OTHERS            = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF cd_tpc_check <> 1.
    CLEAR cd_tpc_check.
  ENDIF.

ENDFORM.                    " check_program_auth

*&--------------------------------------------------------------------*
*&      Form  check_date
*&--------------------------------------------------------------------*
FORM check_date USING it_ra_bukrs TYPE acc_t_ra_bukrs.

  DATA: BEGIN OF ls_bukrs,
          bukrs TYPE bukrs,
        END OF ls_bukrs.
  DATA: lt_bukrs    LIKE STANDARD TABLE OF ls_bukrs.
  DATA: ld_check_ok TYPE char1.

* Select relevant company codes
  SELECT  bukrs
    FROM  t001
    INTO  TABLE lt_bukrs
    WHERE bukrs IN it_ra_bukrs.

* Check each company for each relevant date(s)
  LOOP AT lt_bukrs INTO ls_bukrs.
    LOOP AT datum.
      IF  datum-sign = 'I'
      AND ( datum-option = 'BT' OR datum-option = 'EQ' ).
        CALL FUNCTION 'FI_CHECK_DATE'
          EXPORTING
            i_bukrs           = ls_bukrs-bukrs
            i_user            = sy-uname
            i_program         = sy-repid
            i_from_date       = datum-low
            i_to_date         = datum-high
          EXCEPTIONS
            no_authority_prog = 1
            no_authority_date = 2
            wrong_parameter   = 3
            OTHERS            = 4.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        ld_check_ok = 'X'.
      ELSE.
*       in case of complex select-option the check has to be done
*       on record level
        MESSAGE e004(ca_check_date).
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  IF ld_check_ok NE 'X'.
    MESSAGE e505(Ze505).
  ENDIF.

ENDFORM.                    "check_date
*&---------------------------------------------------------------------*
*&      Form  screen_modify_tpc
*&---------------------------------------------------------------------*
*       id_field: name of field which should be set to "required"
*       id_field2: name of field which should be inactive
*----------------------------------------------------------------------*
FORM screen_modify_tpc using id_field  TYPE dynfnam
                             id_field2 TYPE dynfnam.
  LOOP AT SCREEN.
    IF screen-name CS id_field.
      screen-required = 1.
      MODIFY SCREEN.
    ENDIF.
    IF screen-name CS id_field2.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " screen_modify_tpc

*&---------------------------------------------------------------------*
*&      Form  write_log_tpc
*&---------------------------------------------------------------------*
FORM write_log_tpc .
  CALL FUNCTION 'CA_WRITE_LOG'
    EXPORTING
      i_program = sy-repid
    EXCEPTIONS
      OTHERS    = 0.
ENDFORM.                    " write_log_tpc

*&---------------------------------------------------------------------*
*&      Form  replace_tech_account
*&---------------------------------------------------------------------*
FORM replace_tech_account USING i_tabkey                   "Note 1551976
                          CHANGING o_outtab.

  DATA:
    wa_tiban LIKE tiban,
    l_bankn18 LIKE lfbk-bankn,
    l_outtab LIKE foap_s_rfkabl00_list,
    l_xtech.

* Get the payment instruction data
  wa_tiban-banks = i_tabkey+13(3).
  wa_tiban-bankl = i_tabkey+16(15).
  wa_tiban-bankn = i_tabkey+31(18).
* Check for a technical account number
  l_bankn18 = wa_tiban-bankn.
  CALL FUNCTION 'FI_TECH_ACCNO_CHECK'
    EXPORTING
      i_bankn       = l_bankn18
    IMPORTING
      e_xtech       = l_xtech.
* Get the IBAN
  CHECK NOT l_xtech IS INITIAL.
  CALL FUNCTION 'READ_IBAN_INT'
    EXPORTING
      i_banks         = wa_tiban-banks
      i_bankl         = wa_tiban-bankl
      i_bankn         = wa_tiban-bankn
      i_bkont         = wa_tiban-bkont
    IMPORTING
      e_iban_wa       = wa_tiban.
  IF NOT wa_tiban-iban IS INITIAL.
*   Replace technical account number with the IBAN
    MOVE-CORRESPONDING o_outtab TO l_outtab.
    REPLACE l_bankn18 IN l_outtab-other_keys WITH wa_tiban-iban.
    MOVE-CORRESPONDING l_outtab TO o_outtab.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  add_iban_changes
*&---------------------------------------------------------------------*
FORM add_iban_changes USING i_object r_tabkey TYPE table.  "Note 1551976

  DATA:
    lr_tabkey TYPE RANGE OF lifnr,
    BEGIN OF wa_bankey,
      takey LIKE lfbk-lifnr,
      banks LIKE lfbk-banks,
      bankl LIKE lfbk-bankl,
      bankn LIKE lfbk-bankn,
      bkont LIKE lfbk-bkont,
      bkref LIKE lfbk-bkref,
    END OF wa_bankey,
    lt_bankey LIKE TABLE OF wa_bankey,
    l_bankn35 LIKE tiban-bankn,
    l_bkont LIKE tiban-bkont,
    l_objectid LIKE cdhdr-objectid,
    l_tabname LIKE cdpos-tabname,
    l_cursor TYPE cursor,
    l_mindatum LIKE sy-datum VALUE '19900101',
    wa_cdhdr LIKE cdhdr,                                   "#EC NEEDED
    lt_cdpos LIKE TABLE OF cdpos,
    wa_cdpos LIKE cdpos.
    RANGES: lr_objectid  FOR cdhdr-objectid.                   "1686182

  lr_tabkey = r_tabkey[].
* Get current payments instructions
  CASE i_object.
    WHEN 'KRED'.
      l_tabname = 'LFBK'.
      SELECT lifnr banks bankl bankn bkont bkref FROM lfbk
        INTO TABLE lt_bankey
        FOR ALL ENTRIES IN lr_tabkey                           "1686182
        WHERE lifnr = lr_tabkey-low.                           "1686182
    WHEN 'DEBI'.
      l_tabname = 'KNBK'.
      SELECT kunnr banks bankl bankn bkont bkref FROM knbk
        INTO TABLE lt_bankey
        FOR ALL ENTRIES IN lr_tabkey                           "1686182
        WHERE kunnr = lr_tabkey-low.                           "1686182
    WHEN OTHERS.
      EXIT.
  ENDCASE.
* Get changed payment instructions (deletions, BKONT and BKREF changes)
  IF NOT datum IS INITIAL.
    WHILE l_mindatum NOT IN datum AND l_mindatum < sy-datum.
      ADD 1 TO l_mindatum.
    ENDWHILE.
  ENDIF.

* lr_objectid needed, as otherw. FOR ALL ENTRIES not supported
  REFRESH lr_objectid.                                         "1686182
  lr_objectid[] = lr_tabkey[].                                 "1686182

  OPEN CURSOR l_cursor FOR
    SELECT * FROM cdhdr
    FOR ALL ENTRIES IN lr_objectid                             "1686182
    WHERE objectclas = i_object
      AND objectid = lr_objectid-low                           "1686182
      AND udate GE l_mindatum.
  DO.
    FETCH NEXT CURSOR l_cursor INTO wa_cdhdr.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
*   Neither SELECT JOIN nor SUBQUERY possible for cluster tables...
    SELECT * FROM cdpos INTO TABLE lt_cdpos
      WHERE objectclas = wa_cdhdr-objectclas                   "1841809
        AND objectid   = wa_cdhdr-objectid                     "1841809
        AND changenr   = wa_cdhdr-changenr                     "1841809
        AND tabname    = l_tabname.                            "1841809
    LOOP AT lt_cdpos INTO wa_cdpos.
      CLEAR wa_bankey.
      wa_bankey-takey = wa_cdpos-objectid.
      wa_bankey-banks = wa_cdpos-tabkey+13(3).
      wa_bankey-bankl = wa_cdpos-tabkey+16(15).
      wa_bankey-bankn = wa_cdpos-tabkey+31(18).
      CASE wa_cdpos-fname.
        WHEN 'BKONT'.
          CHECK wa_cdpos-value_new NE wa_cdpos-value_old.
          wa_bankey-bkont = wa_cdpos-value_new.
          APPEND wa_bankey TO lt_bankey.
          wa_bankey-bkont = wa_cdpos-value_old.
          APPEND wa_bankey TO lt_bankey.
        WHEN 'BKREF'.
          CHECK wa_cdpos-value_new NE wa_cdpos-value_old.
          wa_bankey-bkref = wa_cdpos-value_new.
          APPEND wa_bankey TO lt_bankey.
          wa_bankey-bkref = wa_cdpos-value_old.
          APPEND wa_bankey TO lt_bankey.
        WHEN 'KEY'.
          APPEND wa_bankey TO lt_bankey.
      ENDCASE.
    ENDLOOP.
  ENDDO.
  CLOSE CURSOR l_cursor.
  CLEAR: icdhdr, icdhdr[].
  SORT lt_bankey BY takey banks bankl bankn bkont bkref.
  DELETE ADJACENT DUPLICATES FROM lt_bankey.
  LOOP AT lt_bankey INTO wa_bankey.
*   Convert account number BANKN18 TO BANKN35
    CLEAR: l_bankn35, l_bkont.
    CALL FUNCTION 'CONVERT_BANK_ACCOUNT_NUMBER'
      EXPORTING
        i_banks      = wa_bankey-banks
        i_bankk      = wa_bankey-bankl
        i_bankn      = wa_bankey-bankn
        i_bkont      = wa_bankey-bkont
        i_bkref      = wa_bankey-bkref
      IMPORTING
        e_bankn_long = l_bankn35
        e_bkont      = l_bkont.
*   Exclude technical account numbers
    IF NOT l_bankn35 IS INITIAL.
*   Convert payment instruction to change document object key
    l_objectid(3)    = sy-mandt.
    l_objectid+3(3)  = wa_bankey-banks.
    l_objectid+6(15) = wa_bankey-bankl.
    l_objectid+21(35) = l_bankn35.
    l_objectid+56(2) = l_bkont.
*   Get change document headers
    SELECT * FROM cdhdr APPENDING TABLE icdhdr
      WHERE objectclas = 'IBAN'
        AND objectid   = l_objectid
        AND    udate IN datum
        AND username IN uname.
    ENDIF.                                                     "1686182

    AT END OF takey.
      CHECK NOT icdhdr[] IS INITIAL.
      SORT icdhdr BY objectclas objectid changenr.
      DELETE ADJACENT DUPLICATES FROM icdhdr
        COMPARING objectclas objectid changenr username       "2304213
                  udate utime tcode change_ind.
*     Extract change document positions
      LOOP AT icdhdr.
        CLEAR: lt_cdpos[], icdpos[], icdpos.
*       Neither SELECT JOIN nor SUBQUERY possible for cluster tables...
        SELECT * FROM cdpos INTO TABLE lt_cdpos
          WHERE objectclas = icdhdr-objectclas
            AND objectid = icdhdr-objectid
            AND changenr = icdhdr-changenr.
        LOOP AT lt_cdpos INTO wa_cdpos.
          MOVE-CORRESPONDING wa_cdpos TO icdpos.           "#EC ENHOK
          icdpos-f_new = wa_cdpos-value_new.
          icdpos-f_old = wa_cdpos-value_old.
          IF icdpos-tabkey IS INITIAL.
            icdpos-tabkey = wa_cdpos-objectid.
          ENDIF.
          IF icdpos-fname = 'KEY'.
            CLEAR icdpos-fname.
          ENDIF.
*         Show IBAN value in case of a deletion
          TRANSLATE icdpos-chngind USING 'ED'.
          APPEND icdpos.
        ENDLOOP.
        SORT icdpos BY tabname tabkey fname.
        DELETE ADJACENT DUPLICATES FROM icdpos
          COMPARING tabname tabkey fname.
      icdhdr-objectid = wa_bankey-takey.
      PERFORM positionen_in_extract.
    ENDLOOP.
      CLEAR: icdhdr[], icdhdr.
    ENDAT.
  ENDLOOP.

ENDFORM.


"The End
*---------------------------------------------------------------------*
* FORM MIN_MAX_DATUM_ERMITTELN                                        *
*---------------------------------------------------------------------*
* Aus den für die Select-Option eingegebenen Werten wird das kleinste *
* und groesste gewaehlte Datum ermittelt, auch wenn die Mehrfach-     *
* Selektion genutzt wird (nur relevant für RFDABL00/RFKABL00/RFSABL00)*
*---------------------------------------------------------------------*
FORM min_max_datum_ermitteln.

* init min/max date
  high_datum = '19000101'.
  low_datum =  '99991231'.

* find min/max date
  LOOP AT datum.
    IF ( datum-option = 'LT' AND datum-sign = 'E' )
    OR ( datum-option = 'LE' AND datum-sign = 'E' )
    OR ( datum-option = 'EQ' AND datum-sign = 'I' )
    OR ( datum-option = 'NE' AND datum-sign = 'E' )
    OR ( datum-option = 'GE' AND datum-sign = 'I' )
    OR ( datum-option = 'GT' AND datum-sign = 'I' )
    OR ( datum-option = 'BT' AND datum-sign = 'I' )
    OR ( datum-option = 'NB' AND datum-sign = 'E' ).
      IF datum-low < low_datum.
        low_datum = datum-low.
      ENDIF.
      IF datum-high > high_datum.
        high_datum = datum-high.
      ENDIF.
      IF datum-low > high_datum.
        IF datum-high IS INITIAL AND                           "2320467
            ( datum-option = 'GT' OR datum-option = 'GE' ).    "2320467
          high_datum = '99991231'.                             "2320467
        ELSE.                                                  "2320467
          high_datum = datum-low.                              "2320467
        ENDIF.                                                 "2320467
      ENDIF.
    ELSE.
      CLEAR: low_datum, high_datum.
    ENDIF.
  ENDLOOP.

  IF datum-low IS INITIAL AND datum-high IS INITIAL.
    CLEAR: low_datum, high_datum.
  ENDIF.

ENDFORM.                    "MIN_MAX_DATUM_ERMITTELN
