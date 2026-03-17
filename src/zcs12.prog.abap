*eject
* 4.7
* HGA095729 230102 keine Grafik unter webgui
* 4.6C
* HGB020150 260100 Reserve beim Druck (Var.List)
* HGA020150 240100 UComm  anderes Material (ALV)
* HGD246532 171199 Stoppstufe f. Aufl.
* HGA246532 081199 ALV_S
* 4.6B
* HGA046836 270799 Aufl. ProjektStl
* 4.6A
* HGA154419 231298 ECN - FB Anpassung
* 4.5B
* HGC072185 180199 Anzeige KndSelDaten
* HGD059252 161198 Conversion-Error entschaerft
* HGC059252 121198 Nachtrag A033687
* HGA059252 121198 ParmEff-Popup abh. vom Stl.-TopMat (auch bei KndStl)
* 4.0C/4.5A
* HGA033687 140798 KndStl-Aufloesen - Kein Ausweichen auf MatStl mehr
* HGA029649 090798 Langtextausgabe (KndStl)
* HGA084505 060398 neue Gueltigkeit
* HGB084505 030398 KND-Stueckliste
* 4.0A
* HGA025100 230797 Profilvorbelegung / VList Performance
* 3.1G
* HGA127128 270197 Langtextkennz. / Druck SelKriterien
* 3.0F
* HGA108310 251096 EinsatzwahrscheinlichkeitsHandling
* HGA105944 161096 MatNr-Aufbereitung bei ZwBauGrp-Info
* HGG099459 180996 TCSPR-Default
* HGB099459 010896 alter Materialobjekttyp
* 3.0E
* HGA080825 030796 Vervollst. HG0D51356; x-stell. MatNum
* HGC072824 150596 CATT; Druck im Batch ausschalten
* HGA072824 150596 Werksberechtigungspruefung
* 3.0D
* HGB070841 260496 keine Memoryverwaltung fuer CA
* HGB057558 210396 Langtext Includes auflösen
* 3.0C
* YHG046403 260196 Anpassung an Basisaenderung bzgl. SUBMIT
* YHG032486 041295 Performance/Konvertierungen, Coding
* 3.0B
* YHG020009 231095 Performance
*                  CSIO Memory / Puffer Aktivierung / APPEND
* 3.0A
* YHG137563 270695 Druck; falsche Positionierung im Listenkopf
* YHG132854 130695 Keine Grafik bei nicht zus.haengender StlStruktur
* YHG127645 120695 Erweiterung und Korr. zu var. Listen
* YHG123656 160595 Verhalten bei CALLs korrigiert
* YHG121750 100595 Nichtlager ohne Materialstamm
* 3.0
* YHG140031 040495 SKIP bei var. Liste im Druck korrigiert
* YHG139715 030495 Selectoptions-Anzeige
* YHG139336 300395 Ende der Liste
* YHG139320 300395 Kennz Wissen zugeordnet
* YHG138467 270395 Oberfläche / Anpassung Statusname
* YHG137424 230395 Defaultprofil Absicherung
* YHG134257 020395 Korr. CAD-Versorgung
* YHG133914 020395 Umstellung auf var. Liste und neue FB-Generation
* YHG101965 041094 Schalter Mengenrunden
* YHG100916 150994 Korr. Vgl. mit expliziter Laenge
* 2.2                                                            < 1995
* Coding bereinigt: 000109 / 000301 / 077295 / 078090 / 079407
*                   079319 / 087863 / 88020
* 2.1D                                                           < 1995
* Coding bereinigt: 66003 / 68719 / 72697
* 2.1C                                                           < 1994
* Coding bereinigt: 44318
* 2.1B                                                           < 1994
* Coding bereinigt: 35283 / 35785 / 35807 / 36365 / 36694 / 41147
*                   42334 / 44860 / 49857 / 52824 / 53243 / 62728
***********************************************************************
*del REPORT RCS12001 MESSAGE-ID 29 LINE-SIZE 81               "YHG139715
REPORT ZCS12 MESSAGE-ID 29 LINE-SIZE 132                 "YHG139715
                NO STANDARD PAGE HEADING.

***********************************************************************
*        D A T E N  -  Definitionen                                   *
***********************************************************************
*---------------------------------------------------------------------*
*        ATAB-Tabellen                                                *
*---------------------------------------------------------------------*
TABLES:
   makt,
   t418,                                                    "YHG121750
   tcs03,
   tcspr,
   sgt_s_bomexpl.


*---------------------------------------------------------------------*
*        interne Tabellen                                             *
*---------------------------------------------------------------------*
DATA: BEGIN OF selpool.
        INCLUDE STRUCTURE cstmat.
DATA: END OF selpool.

DATA: BEGIN OF stb OCCURS 1000.
        INCLUDE STRUCTURE stpox.
DATA: END OF stb.

*     Materialkatalog
DATA: BEGIN OF matcat OCCURS 50.                            "YHG133914
        INCLUDE STRUCTURE cscmat.                           "YHG133914
DATA: END OF matcat.                                        "YHG133914

DATA: BEGIN OF sav_stb.
        INCLUDE STRUCTURE stpox.
DATA: END OF sav_stb.

DATA: BEGIN OF txt OCCURS 25.
        INCLUDE STRUCTURE tline.
DATA: END OF txt.

DATA: BEGIN OF cl_clstab OCCURS 0,
         class LIKE klah-class,
         klart LIKE klah-klart,
         chked LIKE csdata-xfeld,
         noobj LIKE csdata-xfeld,
         dsply LIKE csdata-xfeld,
      END OF cl_clstab.

DATA: BEGIN OF cl_objtab OCCURS 0.
        INCLUDE STRUCTURE ckssk.
DATA: END OF cl_objtab.

DATA: BEGIN OF cl_objmemo OCCURS 0,
         class LIKE klah-class,
         klart LIKE klah-klart.
        INCLUDE STRUCTURE ckssk.
DATA: END OF cl_objmemo.

*     WAs fuer AnzBlockAusgabe (var. Liste)
DATA: BEGIN OF watab OCCURS 0.                              "YHG133914
        INCLUDE STRUCTURE cltable.                          "YHG133914
DATA: END OF watab.                                         "YHG133914

*     Sicherungstabelle der AnzBlockWAs
DATA: BEGIN OF sav_watab OCCURS 0.                          "YHG133914
        INCLUDE STRUCTURE cltable.                          "YHG133914
DATA: END OF sav_watab.                                     "YHG133914

*     Uebergabestruktur Typ STPOX (fuer STB)
DATA: BEGIN OF stb_orig.                                    "YHG133914
        INCLUDE STRUCTURE stpox.                            "YHG133914
DATA: END OF stb_orig.                                      "YHG133914

*     Uebergabestruktur Typ STPOL_ADD
DATA: BEGIN OF stb_add.                                     "YHG133914
        INCLUDE STRUCTURE stpol_add.                        "YHG133914
DATA: END OF stb_add.                                       "YHG133914

DATA : BEGIN OF vbap_wa OCCURS 0.                           "HGB084505
        INCLUDE STRUCTURE vbap.                             "HGB084505
DATA : END OF vbap_wa.                                      "HGB084505

DATA: matpos_flg LIKE csdata-xfeld,                         "HGB084505
      mpos_page  LIKE sy-pagno,                             "HGB084505
      mpos_line  LIKE sy-linno.                             "HGB084505

DATA: BEGIN OF wa_kdstb OCCURS 0.                           "HGA033687
        INCLUDE STRUCTURE kdstb.                            "HGA033687
DATA: END OF wa_kdstb.                                      "HGA033687

DATA lv_config_status TYPE abap_bool.
*---------------------------------------------------------------------*
*        interne Feldleisten                                          *
*---------------------------------------------------------------------*
*del DATA:                                                    "YHG133914
*del    BEGIN OF INFO_LINIE,                                  "YHG133914
*del       MATNR LIKE MARA-MATNR,                             "YHG133914
*del       ABSTD(1)   TYPE C,                                 "YHG133914
*del       STRICH(18) TYPE C,                                 "YHG133914
*del    END OF INFO_LINIE.                                    "YHG133914

*---------------------------------------------------------------------*
*        interne Felder                                               *
*---------------------------------------------------------------------*
DATA:
   cal_aclas LIKE tappl-applclass,
   hlf_stlnr LIKE stko-stlnr,
   hlp_stlal LIKE stko-stlal,
   clo_matnr LIKE mara-matnr,
   anz_stptx(3)   TYPE c,
   anz_stufe(11)  TYPE c,
   anz_datuv LIKE stko-datuv,
   anz_datub LIKE stko-datuv,
   anz_stlal LIKE stko-stlal,
   abw_stlal LIKE stko-stlal,
   anz_upmng LIKE stpu-upmng,
   txt_key   LIKE thead-tdname,
   txt_kyln(3)    TYPE n,
   col_switch(1)  TYPE c,          "intensified on/off
   tmp_hrechf     TYPE f,          "temp. HilfsRechenfeld
   ups_faktor     TYPE f,
   ret_code       LIKE sy-subrc.

DATA: anr_datuv LIKE aenr-datuv,                            "HGA084505
      anr_techs LIKE tecs-techs.                            "HGA084505

* ---------------------------------
DATA: lins_out     LIKE sy-linno,
      lins_out_sav LIKE sy-linno,
      lst_lin_on_p LIKE sy-linno,
      lins_to_skip LIKE sy-linno,
      lins_per_pag LIKE sy-pagno.
* ---------------------------------
*     Ueberlaufschalter (f. Zahlen)
DATA: ueberl_flg(1) TYPE c,
*del  EDTLIN(79) TYPE C,                                      "YHG133914
*del  SAV_EDTLIN(79) TYPE C,                                  "YHG133914
      first_flg(1) TYPE c.

* ---------------------------------
DATA: page_mat LIKE sy-pagno,
      page_dok LIKE sy-pagno,
      page_kla LIKE sy-pagno,
      page_noo LIKE sy-pagno,
      page_exc LIKE sy-pagno.
* ---------------------------------
*     --> kann nach Bereinigung der anderen Reports geloescht werden
*d DATA: REAL_LINE LIKE SY-LINNO.                             "HGA046836
*d DATA: STB-MATNR LIKE MARA-MATNR.                 "YHG133681"HGA046836


* ---------------------------------
*     EndOfBlock-Kennzeichen
DATA: eoblc      LIKE csdata-xfeld,                         "YHG133914
*     Zeilenbreite aus dem aktuellen Profil
      itf_prfsz  LIKE klah-lbrei,                   "YHG133914"YHG32486
*del  SAV_PRFSZ  LIKE KLAH-LBREI,                   "YHG133914"YHG32486
      sav_prfsz  TYPE i,                                    "YHG32486
*     Zeilenbreite des akt. Profils plus Rand ( + 2 )
*del  SIZ_LINPF  LIKE KLAH-LBREI,  "Lnsz plus frame "YHG133914"YHG32486
      siz_linpf  TYPE i,                                    "YHG32486
*     Kennzeichen 'akt. Zeile ist leer'
      lnmpt_flg  LIKE csdata-xfeld,                         "YHG133914
*     das aktuell gueltige Profil
      act_profil LIKE klah-class,                           "YHG133914
*     BlockzeilenZaehler
      blclns_cnt LIKE sy-linno,                             "YHG133914
*     Anzahl Zeilen Listenkopf
      nbr_hdrlns LIKE sy-linno.                             "YHG133914

DATA: dstst_flg LIKE csdata-xfeld.                          "YHG132854

DATA: mem_mngmt(1) TYPE c.                                  "HGB070841

DATA: mnr_lng     TYPE i.                                   "HGA080825


*---------------------------------------------------------------------*
*        Konstanten                                                   *
*---------------------------------------------------------------------*
DATA:
   bom_txobj  LIKE thead-tdobject VALUE 'BOM',
*d bom_txid   like thead-tdid value 'MPO',                    "HGA029649
   bom_txid   LIKE thead-tdid,                              "HGA029649
   mbm_txid   LIKE thead-tdid VALUE 'MPO',                  "HGA029649
   kbm_txid   LIKE thead-tdid VALUE 'KPO',                  "HGA029649
*  maximal anzeigbare Menge
   max_num(7)  TYPE p DECIMALS 3 VALUE '9999999999.999',
   min_num(7)  TYPE p DECIMALS 3 VALUE '9999999999.999-',
   cnull(18)  TYPE c          VALUE '000000000000000000',
   strich(50) TYPE c          VALUE
      '--------------------------------------------------',
   min_grg    LIKE sy-datum   VALUE '19000101',
   max_grg    LIKE sy-datum   VALUE '99991231'.

DATA: ueberl_kz(1) TYPE c VALUE '*'.
DATA: b_flag(1) TYPE c VALUE 'X'.

DATA:
   otyp_mat(1) TYPE c VALUE '1',
   ootyp_mat(1) TYPE c VALUE 'M',                           "HGB099459
*  Objekttyp 'kein Objekt'
   otyp_noo(1) TYPE c VALUE '2',                            "YHG133914
   otyp_doc(1) TYPE c VALUE '3',
   otyp_kla(1) TYPE c VALUE '4',
*  Objekttyp 'Intramaterial'
   otyp_ntm(1) TYPE c VALUE '5'.                            "YHG133914

DATA: all_pstat(9) TYPE c VALUE 'KVEDLAPSB'.


* ---------------------------------
*     langes leeres Feld
DATA: ecfld(250) TYPE c.                                    "YHG133914


*---------------------------------------------------------------------*
*        spezielle Export- Importbereiche                             *
*---------------------------------------------------------------------*
DATA: BEGIN OF stpub OCCURS 0.
        INCLUDE STRUCTURE stpub.
DATA: END OF stpub.

DATA: BEGIN OF csbomex.
        INCLUDE STRUCTURE csbomex.
DATA: END OF csbomex.


*---------------------------------------------------------------------*
*        Selektionsparameter                                          *
*---------------------------------------------------------------------*
PARAMETERS:
*d pm_mtnrv like mara-matnr memory id mat obligator           "HGC059252
   pm_mtnrv LIKE mara-matnr MEMORY ID mat,                  "HGC059252
   pm_werks LIKE marc-werks MEMORY ID wrk,
   pm_stlal LIKE stko-stlal,
   pm_stlan LIKE stzu-stlan,
   pm_capid LIKE tc04-capid,
   pm_datuv LIKE stko-datuv DEFAULT sy-datum OBLIGATORY,
*  Parameterbelegung P-Effektivity
   pm_techs LIKE tecs-techs,                                "HGA084505
*  Aenderungsnummer
   pm_aennr LIKE aenr-aennr,                                "HGA084505
*  Einsatzmenge
   pm_emeng LIKE stko-bmeng,
*  zugehoeriges SUBMIT-Hilfsfeld:
   pm_hemng(13)  TYPE n NO-DISPLAY,
   pm_alvsa      LIKE rc29l-valst,                          "HGA246532
*  Profil zur Bildschirmanzeige
*d pm_dsprf      like klah-class default 'SAPCSMLVM "YHG133681"HGA025100
   pm_dsprf      LIKE klah-class,                           "HGA025100
*  Profil beim Druck
*d pm_prprf      like klah-class default 'SAPCSMLVM "YHG133681"HGA025100
   pm_prprf      LIKE klah-class,                           "HGA025100
   pm_ausch(1)   TYPE c,
   pm_ltext(1)   TYPE c,
*  (Dok.)Revisionsstand ermitteln
   pm_drldt(1)   TYPE c,                                    "note 438371
   pm_dspco(1)   TYPE c,
*  Stoppstufe
   pm_stpst      LIKE rc29l-maxst,                          "HGD246532
   pm_altvo(1)   TYPE c,
   pm_upsaz(1)   TYPE c,
*d PM_GBRAZ(1)   TYPE C,                                      "HGA046836
   pm_brems(1)   TYPE c,
   pm_erskz(1)   TYPE c,
   pm_erssl(1)   TYPE c,
   pm_beikz(1)   TYPE c,
   pm_bessl(1)   TYPE c,
   pm_bagrp LIKE mara-matnr,
   pm_postp(1)   TYPE c,
   pm_ehndl(1)       TYPE c DEFAULT '1',                    "HGA108310
   pm_sanko LIKE stpo-sanko,
   pm_sanfe LIKE stpo-sanfe,
   pm_sanka LIKE stpo-sanka,
   pm_sanin LIKE stpo-sanin,
   pm_sanvs LIKE stpo-sanvs,
   pm_rvrel LIKE stpo-rvrel,
   pm_schgt LIKE stpo-schgt,
   pm_stkkz LIKE stpo-stkkz.

PARAMETERS:
*  ProjektNr.
   pm_pspnr LIKE prst-pspnr,                                "HGA046836

   pm_vbeln LIKE kdst-vbeln,                                "HGB084505
   pm_vbpos LIKE kdst-vbpos.                                "HGB084505

PARAMETERS:
   pm_scat     type sgt_scat,
   pm_ignor    type sgt_ignore.

DATA :
   gs_pushb_convtype TYPE smp_dyntxt,
   gt_matnr          TYPE pre03_tab,
   gt_alv_stb        TYPE TABLE OF stpox_alv.

*  reporteigene Konstanten
DATA:
   list_id    LIKE klah-class VALUE 'SAPCSMLVM         ',   "YHG137424
*  Profil zur Bildschirmanzeige
   dflt_dsprf LIKE klah-class VALUE 'SAPCSMLVMP01      ',   "YHG137424
*  Profil beim Druck
   dflt_prprf LIKE klah-class VALUE 'SAPCSMLVMP01      '.   "YHG137424

DATA:                                                       "HGA046836
*  obsolete
   pm_gbraz TYPE c.                                         "HGA046836

TYPES:                                                      "HGA095729
  BEGIN OF y_menu_fc_type,                                  "HGA095729
    fcode LIKE rsmpe-func,                                  "HGA095729
  END OF y_menu_fc_type.                                    "HGA095729

TYPES:                                                      "HGA095729
  y_menu_fc_tb_type                                         "HGA095729
    TYPE STANDARD TABLE OF y_menu_fc_type                   "HGA095729
         WITH NON-UNIQUE DEFAULT KEY INITIAL SIZE 10.       "HGA095729

DATA:                                                       "HGA095729
  menu_fc_tb TYPE y_menu_fc_tb_type,                        "HGA095729

  wa_menu_fc_tb TYPE y_menu_fc_type.                        "HGA095729

* .. Declaration for Menu Enhancement........................
DATA: lp_badi     TYPE REF TO badi_rcs12001_fcode_enh,
      lv_error    TYPE abap_bool,
      ls_message  TYPE symsg,
      lt_sel_tab  TYPE TABLE OF rsparams.

*---------------------------------------------------------------------*
*.. ALV_S  beg .............................................. "HGA246532

TYPE-POOLS: slis.
*..................................
DATA:
   report_name      LIKE sy-repid,
   alvlo_stb        TYPE slis_layout_alv,
   alvvr            LIKE disvariant,
   alvvr_sav        TYPE c,
   exit_by_caller   TYPE c,
   exit_by_user     TYPE slis_exit_by_user.

DATA:
   wa_stb_fields_tb TYPE slis_fieldcat_alv.

DATA:
*  ALV Events complete
   alv_evnt_tb_cmpl TYPE slis_t_event,
*  ALV Events pf exit only
   alv_evnt_tb_pfxt TYPE slis_t_event,
*  ALV Top of page table
   alv_top_tb    TYPE slis_t_listheader,
*  field display properties  stb tab
   stb_fields_tb TYPE slis_t_fieldcat_alv.

DATA:
   alvvr_sav_all    TYPE c VALUE 'A',
   alvvr_sav_no_usr TYPE c VALUE 'X'.

DATA: BEGIN OF alv_stb OCCURS 0.
        INCLUDE STRUCTURE stpox_alv.
DATA:   info(3)   TYPE c,
      END OF alv_stb.

DATA: BEGIN OF ftab OCCURS 200.
        INCLUDE STRUCTURE dfies.
DATA: END   OF ftab.

DATA:
*  ALV-Variante
   pm_alvvr LIKE ltdx-variant,
*  alv variant user specific
   pm_alvvu TYPE c.

*.. ALV_S  end .......................................................*
*---------------------------------------------------------------------*

*eject
***********************************************************************
*        M A I N  -  Routinen                                         *
***********************************************************************
*eject
INITIALIZATION.
  SET TITLEBAR 'E01' WITH text-001 text-002.
  IMPORT csbomex FROM MEMORY ID 'CSNN_BOMEX'.

  cal_aclas = csbomex-aclas.

*  CATT-Info besorgen
  PERFORM import_catt_flag.                                 "HGC072824

  PERFORM tcs03_lesen.
  PERFORM tcspr_lesen.
  PERFORM set_schalter.

  IF NOT csbomex-submf = 'x'.
    PERFORM sel_grenzen_01.

*del  IF SY-SUBRC = 0.                                        "YHG133914
    PERFORM sel_grenzen_02.
*del  ENDIF.                                                  "YHG133914

    IF NOT pm_alvsa IS INITIAL.                             "HGA246532
      PERFORM get_profs.                                    "HGA025100
    ENDIF.                                                  "HGA246532
  ENDIF.


*eject
* ---------------------------------
AT SELECTION-SCREEN.
*  ?Report per SUBMIT gestartet
*  nein, ... per SE38 oder sonstwie
  IF csbomex-submf IS INITIAL.
    PERFORM chk_plant_auth.                                 "HGA072824

    IF sy-subrc <> 0.                                       "HGA072824
      IF sy-batch IS INITIAL.                               "HGA072824
        MESSAGE e523 WITH 'E:' pm_werks.                    "HGA072824
      ELSE.                                                 "HGA072824
        LEAVE.                                              "HGA072824
      ENDIF.                                                "HGA072824
    ENDIF.                                                  "HGA072824

*     ?weder Stuecklistenverwendung noch StlAnwendung angegeben
*     ja, weder - noch
    IF     pm_stlan IS INITIAL
       AND pm_capid IS INITIAL.

*        ?Batchverarbeitung aktiv
*        nein
      IF     sy-batch IS INITIAL.
*           Msg.: wenigstens eine Verwendg od. eine Anwendg angeben
        MESSAGE e560 WITH ''.
*        ja, Report laeuft im Moment im Batch
      ELSE.
*           Report abbrechen - Selektion macht keinen Sinn
        LEAVE.
      ENDIF.
    ENDIF.

*     ?weder Einsatzmenge noch Alternative angegeben
*     ja, weder - noch
    IF     pm_emeng IS INITIAL
       AND pm_stlal IS INITIAL.

*        ?Batchverarbeitung aktiv
*        nein
      IF     sy-batch IS INITIAL.
*           Msg.: wenigstens eine Verwendg od. eine Anwendg angeben
        MESSAGE w561 WITH ''.
      ENDIF.
    ENDIF.

*     ?weder Material noch KndDaten
*     ja, weder - noch
    IF     pm_mtnrv IS INITIAL                              "HGC059252
       AND (    pm_pspnr IS INITIAL )                       "HGA046836
       AND (    pm_vbeln IS INITIAL                         "HGC059252
             OR pm_vbpos IS INITIAL ).                      "HGC059252
*        ?Batchverarbeitung aktiv
*        nein
      IF     sy-batch IS INITIAL.                           "HGC059252
*           Msg.: wenigstens ein Mat od. KNDDaten angeben
        MESSAGE e562 WITH ''.                               "HGC059252
*        ja, Report laeuft im Moment im Batch
      ELSE.                                                 "HGC059252
*           Report abbrechen - Selektion macht keinen Sinn
        LEAVE.                                              "HGC059252
      ENDIF.                                                "HGC059252
    ENDIF.                                                  "HGC059252

    CLEAR:                                                  "HGA084505
       anr_techs,                                           "HGA084505
       anr_datuv.                                           "HGA084505

    IF NOT pm_aennr IS INITIAL.                             "HGA084505
      CALL FUNCTION 'CC_CHANGE_NUMBER_READ'                 "HGA084505
           EXPORTING                                        "HGA084505
                eaennr = pm_aennr                           "HGA084505
           IMPORTING                                        "HGA084505
*d                 atechs = anr_techs               "HGA084505"HGA154419
                adatuv = anr_datuv.                         "HGA084505

      IF sy-subrc = 0.                                      "HGA084505
        IF NOT anr_datuv IS INITIAL.                        "HGA084505
          IF pm_datuv NE anr_datuv.                         "HGA084505
            pm_datuv = anr_datuv.                           "HGA084505
            MESSAGE w042 WITH pm_datuv.                     "HGA084505
          ENDIF.                                            "HGA084505
        ENDIF.                                              "HGA084505
        IF NOT anr_techs IS INITIAL.                        "HGA084505
          IF pm_techs NE anr_techs.                         "HGA084505
            pm_techs = anr_techs.                           "HGA084505
          ENDIF.                                            "HGA084505
        ENDIF.                                              "HGA084505
      ELSE.                                                 "HGA084505
        MESSAGE w521 WITH 'E:' pm_aennr.                    "HGA084505
      ENDIF.                                                "HGA084505
    ENDIF.                                                  "HGA084505
  ENDIF.


*eject
* ---------------------------------
START-OF-SELECTION.
  IF csbomex-submf IS INITIAL.
    SET PARAMETER ID 'CSV' FIELD pm_stlan.
    SET PARAMETER ID 'CSA' FIELD pm_capid.
  ENDIF.

  IF pm_alvsa IS INITIAL.                                   "HGA246532
    report_name = sy-repid.                                 "HGA246532

    alvlo_stb-detail_popup = 'X'.                           "HGA246532
    alvlo_stb-zebra        = 'X'.                           "HGA246532

    PERFORM alv_evnt_tb_prep                                "HGA246532
      USING                                                 "HGA246532
        'A'                                                 "HGA246532
        alv_evnt_tb_cmpl.                                   "HGA246532

    alvvr-report = report_name.                             "HGA246532
    IF NOT pm_alvvr IS INITIAL.                             "HGA246532
      alvvr-variant = pm_alvvr.                             "HGA246532

      IF NOT pm_alvvu IS INITIAL.                           "HGA246532
        alvvr-username = sy-uname.                          "HGA246532
      ENDIF.                                                "HGA246532
    ENDIF.                                                  "HGA246532

    alvvr_sav = alvvr_sav_all.                              "HGA246532
  ELSE.                                                     "HGA246532
    IF    pm_dsprf IS INITIAL                               "HGA246532
       OR pm_prprf IS INITIAL.                              "HGA246532

      PERFORM get_profs.                                    "HGA246532
    ENDIF.                                                  "HGA246532

    CLASS: cl_gui_frontend_services DEFINITION LOAD.        "HGA095729

    IF NOT cl_gui_frontend_services=>www_active IS INITIAL. "HGA095729
      wa_menu_fc_tb-fcode = 'CSGR'.                         "HGA095729
      APPEND wa_menu_fc_tb TO menu_fc_tb.                   "HGA095729

      SET PF-STATUS 'S121' EXCLUDING menu_fc_tb.            "HGA095729
    ELSE.                                                   "HGA095729
*del    SET PF-STATUS 'SA12'.                                 "YHG139715
      SET PF-STATUS 'S121'.                                 "YHG139715
    ENDIF.                                                  "HGA095729

    SET TITLEBAR 'A01'.
  ENDIF.                                                    "HGA246532

*d IF NOT CSBOMEX-SUBMF = 'x'.                                "YHG046403
*del  PM_EMENG = PM_EMENG * 1000 .                            "YHG046403
*d ELSE.                                                      "YHG046403
*d    TMP_HRECHF = PM_HEMNG.                                  "YHG046403
*d    TMP_HRECHF = TMP_HRECHF / 1000.                         "YHG046403
*d    PM_EMENG   = TMP_HRECHF.                                "YHG046403
*d ENDIF.                                                     "YHG046403

  PERFORM field_convert USING pm_stlal.
  PERFORM sel_grenzen_03.

  IF cal_aclas EQ 'CA  '.                                   "HGB070841
    mem_mngmt = '0'.                                        "HGB070841
  ELSE.                                                     "HGB070841
    mem_mngmt = '1'.                                        "HGB070841
  ENDIF.                                                    "HGB070841

*d DESCRIBE FIELD makt-matnr LENGTH mnr_lng.               "HGA080825"uc
  DESCRIBE FIELD makt-matnr                                         "uc
    LENGTH mnr_lng                                                  "uc
    IN CHARACTER MODE.                                              "uc

*ENHANCEMENT-POINT RCS12001_02 SPOTS ES_RCS12001 .

*  die eigentliche Aufloesung
*d IF     PM_VBELN IS INITIAL                       "HGB084505"HGA046836
*d    OR  PM_VBPOS IS INITIAL.                      "HGB084505"HGA046836
  IF     ( pm_vbeln IS INITIAL                              "HGA046836
           OR  pm_vbpos IS INITIAL )                        "HGA046836
     AND ( pm_pspnr IS INITIAL ).                           "HGA046836

    PERFORM ecm_proc_init                                   "HGA084505
*d    using pm_techs.                               "HGA084505"HGA059252
       USING pm_mtnrv                                       "HGA059252
             pm_techs.                                      "HGA059252


*  CS_BOM_EXPLOSION_MAT ersetzt                               "YHG133914
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        altvo                 = pm_altvo
        aufsw                 = ' '
        auskz                 = pm_ausch
        bagrp                 = pm_bagrp
        beikz                 = pm_beikz
        bessl                 = pm_bessl
        brems                 = pm_brems
        capid                 = pm_capid
        datuv                 = pm_datuv
        drldt                 = pm_drldt                                   "note 438371
        ehndl                 = pm_ehndl                    "HGA108310
        emeng                 = pm_emeng
        erskz                 = pm_erskz
        erssl                 = pm_erssl
        mbwls                 = ' '
        mtnrv                 = pm_mtnrv
        mehrs                 = 'X'
*                                "YHG020009"HGB070841
        mmory                 = mem_mngmt                   "HGB070841
        postp                 = pm_postp
        sanko                 = pm_sanko
        sanfr                 = pm_sanfe
        sanka                 = pm_sanka
        sanin                 = pm_sanin
        sanvs                 = pm_sanvs
        rndkz                 = tcspr-amekz                 "YHG100738
        rvrel                 = pm_rvrel
        schgt                 = pm_schgt
        stkkz                 = pm_stkkz
        stlal                 = pm_stlal
        stlan                 = pm_stlan
        stpst                 = pm_stpst                    "HGD246532
        werks                 = pm_werks
        aumgb                 = 'X'                                        "NOTE_887365
        sgt_scat              =  pm_scat                  "segmentation
        sgt_rel               = pm_ignor                   "segmentation
      IMPORTING
        topmat                = selpool
        dstst                 = dstst_flg                   "YHG132854
      TABLES
        stb                   = stb
        matcat                = matcat
      EXCEPTIONS
        material_not_found    = 4
        no_plant_data         = 8
        no_bom_found          = 12
        no_suitable_bom_found = 16
        alt_not_found         = 24
*                                                           "HGD059252
        missing_authorization = 28                          "HGD059252
        conversion_error      = 36.                         "HGD059252
*d ELSE.                                            "HGB084505"HGA046836
  ELSEIF pm_pspnr IS INITIAL.                               "HGA046836
    CALL FUNCTION 'SD_VBAP_SELECT'                          "HGB084505
       EXPORTING                                            "HGB084505
          i_document_number = pm_vbeln                      "HGB084505
          i_item_number     = pm_vbpos                      "HGB084505
       IMPORTING                                            "HGB084505
          e_vbap            = vbap_wa                       "HGB084505
       EXCEPTIONS                                           "HGB084505
          item_not_found    = 1                             "HGB084505
          OTHERS            = 2.                            "HGB084505

*d    wa_kdstb-matnr = vbap_wa-matnr.               "HGA033687"HGC059252
*d    wa_kdstb-werks = vbap_wa-werks.               "HGA033687"HGC059252
*d    wa_kdstb-vbeln = pm_vbeln.                    "HGA033687"HGC059252
*d    wa_kdstb-vbpos = pm_vbpos.                    "HGA033687"HGC059252

*d    call function 'GET_KDST'                      "HGA033687"HGC059252
*d         exporting                                "HGA033687"HGC059252
*d              all             = 'X'               "HGA033687"HGC059252
*d              no_buffer       = ' '               "HGA033687"HGC059252
*d              set             = 'X'               "HGA033687"HGC059252
*d         tables                                   "HGA033687"HGC059252
*d              wa              = wa_kdstb          "HGA033687"HGC059252
*d         exceptions                               "HGA033687"HGC059252
*d*             CALL_INVALID    = 1                           "HGC059252
*d*             END_OF_TABLE    = 2                           "HGC059252
*d*             GET_WITHOUT_SET = 3                           "HGC059252
*d*             KEY_INCOMPLETE  = 4                           "HGC059252
*d*             KEY_INVALID     = 5                           "HGC059252
*d              no_record_found = 32                "HGA033687"HGC059252
*d*             OTHERS          = 7                           "HGC059252
*d              .                                   "HGA033687"HGC059252

    IF sy-subrc = 0.                                        "HGA033687
*     -->
      IF vbap_wa-matnr NE pm_mtnrv.                         "HGB084505
        matpos_flg = 'x'.                                   "HGB084505
      ENDIF.                                                "HGB084505

      IF NOT vbap_wa-techs IS INITIAL.                      "HGA084505
        PERFORM ecm_proc_init                               "HGA084505
*d          using vbap_wa-techs.                    "HGA084505"HGA059252
           USING vbap_wa-matnr                              "HGA059252
                 vbap_wa-techs.                             "HGA059252
      ELSE.                                                 "HGA084505
*....... I: pm_techs kann auch init sein
        PERFORM ecm_proc_init                               "HGA084505
*d          using pm_techs.                         "HGA084505"HGA059252
           USING vbap_wa-matnr                              "HGA059252
                 pm_techs.                                  "HGA059252
      ENDIF.                                                "HGA084505

*     perform werks_best                             "note 353640 384597
*       using                                        "note 353640 384597
*         vbap_wa-matnr                              "note 353640 384597
*       changing                                     "note 353640 384597
*         vbap_wa-werks.                             "note 353640 384597

      IF matpos_flg IS INITIAL  OR                          "note 847517
         pm_mtnrv IS INITIAL.                               "note 847517

        PERFORM compute_plant(saplcuko)                       "note 384597
                USING    vbap_wa-matnr                        "note 384597
                         vbap_wa-werks                        "note 384597
                CHANGING vbap_wa-werks.                       "note 384597

*ENHANCEMENT-POINT RCS12001_06 SPOTS ES_RCS12001 .

        CALL FUNCTION 'CS_BOM_EXPL_KND_V1'                  "HGB084505
           EXPORTING                                        "HGB084505
              altvo = pm_altvo                              "HGB084505
              aufsw = ' '                                   "HGB084505
              auskz = pm_ausch                              "HGB084505
              bagrp = pm_bagrp                              "HGB084505
              beikz = pm_beikz                              "HGB084505
              bessl = pm_bessl                              "HGB084505
              brems = pm_brems                              "HGB084505
              capid = pm_capid                              "HGB084505
              cuobj = vbap_wa-cuobj                         "HGB084505
              datuv = pm_datuv                              "HGB084505
              drldt = pm_drldt                                "note 438371
              ehndl = pm_ehndl                              "HGB084505
              emeng = pm_emeng                              "HGB084505
              erskz = pm_erskz                              "HGB084505
              erssl = pm_erssl                              "HGB084505
              mbwls = ' '                                   "HGB084505
              mtnrv = vbap_wa-matnr                         "HGB084505
              mehrs = 'X'                                   "HGB084505
              mmory = mem_mngmt                             "HGB084505
              postp = pm_postp                              "HGB084505
              sanko = pm_sanko                              "HGB084505
              sanfr = pm_sanfe                              "HGB084505
              sanka = pm_sanka                              "HGB084505
              sanin = pm_sanin                              "HGB084505
              sanvs = pm_sanvs                              "HGB084505
              rndkz = tcspr-amekz                           "HGB084505
              rvrel = pm_rvrel                              "HGB084505
              schgt = pm_schgt                              "HGB084505
              stkkz = pm_stkkz                              "HGB084505
              stlal = pm_stlal                              "HGB084505
              stlan = pm_stlan                              "HGB084505
              stpst = pm_stpst                              "HGD246532
              werks = vbap_wa-werks                         "HGB084505
              vbeln = pm_vbeln                              "HGB084505
              vbpos = pm_vbpos                              "HGB084505
              sgt_scat = pm_scat                         "segmentation
              sgt_rel  = pm_ignor                        "segmentation
           IMPORTING                                        "HGB084505
              topmat = selpool                              "HGB084505
              dstst  = dstst_flg                            "HGB084505
           TABLES                                           "HGB084505
              stb = stb                                     "HGB084505
              matcat = matcat                               "HGB084505
           EXCEPTIONS                                       "HGB084505
              material_not_found    = 4                     "HGB084505
              no_plant_data         = 8                     "HGB084505
*d          no_bom_found          = 12              "HGB084505"HGC059252
              no_bom_found          = 32                    "HGB084505
              no_suitable_bom_found = 16                    "HGB084505
              alt_not_found         = 24                    "HGB084505
*d          missing_authorization = 28.             "HGB084505"HGD059252
              missing_authorization = 28                    "HGD059252
              conversion_error      = 36.                   "HGD059252
*     <--
* START OF NOTE 847517
      ELSE.

        PERFORM compute_plant(saplcuko)                 "note 1226225
          USING    pm_mtnrv                             "note 1226225
                   vbap_wa-werks                        "note 1226225
          CHANGING vbap_wa-werks.                       "note 1226225

        CALL FUNCTION 'CS_BOM_EXPL_KND_V1'
          EXPORTING
            altvo                 = pm_altvo
            aufsw                 = ' '
            auskz                 = pm_ausch
            bagrp                 = pm_bagrp
            beikz                 = pm_beikz
            bessl                 = pm_bessl
            brems                 = pm_brems
            capid                 = pm_capid
            cuobj                 = vbap_wa-cuobj
            datuv                 = pm_datuv
            drldt                 = pm_drldt
            ehndl                 = pm_ehndl
            emeng                 = pm_emeng
            erskz                 = pm_erskz
            erssl                 = pm_erssl
            mbwls                 = ' '
            mtnrv                 = pm_mtnrv
            mehrs                 = 'X'
            mmory                 = mem_mngmt
            postp                 = pm_postp
            sanko                 = pm_sanko
            sanfr                 = pm_sanfe
            sanka                 = pm_sanka
            sanin                 = pm_sanin
            sanvs                 = pm_sanvs
            rndkz                 = tcspr-amekz
            rvrel                 = pm_rvrel
            schgt                 = pm_schgt
            stkkz                 = pm_stkkz
            stlal                 = pm_stlal
            stlan                 = pm_stlan
            stpst                 = pm_stpst
            werks                 = vbap_wa-werks
            vbeln                 = pm_vbeln
            vbpos                 = pm_vbpos
          IMPORTING
            topmat                = selpool
            dstst                 = dstst_flg
          TABLES
            stb                   = stb
            matcat                = matcat
          EXCEPTIONS
            material_not_found    = 4
            no_plant_data         = 8
            no_bom_found          = 32
            no_suitable_bom_found = 16
            alt_not_found         = 24
            missing_authorization = 28
            conversion_error      = 36.

      ENDIF.

*END OF NOTE 847517
    ELSE.                                                   "HGC059252
      sy-subrc = 32.                                        "HGC059252
    ENDIF.                                                  "HGA033687
  ELSEIF (     pm_vbeln IS INITIAL                          "HGA046836
           AND pm_vbpos IS INITIAL ) .                      "HGA046836

    PERFORM ecm_proc_init                                 "note 485260
       USING pm_mtnrv                                     "note 485260
             pm_techs.                                    "note 485260

    CALL FUNCTION 'CS_BOM_EXPL_PSP_V1'                      "HGA046836
       EXPORTING                                            "HGA046836
          altvo = pm_altvo                                  "HGA046836
          aufsw = ' '                                       "HGA046836
          auskz = pm_ausch                                  "HGA046836
          bagrp = pm_bagrp                                  "HGA046836
          beikz = pm_beikz                                  "HGA046836
          bessl = pm_bessl                                  "HGA046836
          brems = pm_brems                                  "HGA046836
          capid = pm_capid                                  "HGA046836
          datuv = pm_datuv                                  "HGA046836
          drldt = pm_drldt                                "note 438371
          ehndl = pm_ehndl                                  "HGA046836
          emeng = pm_emeng                                  "HGA046836
          erskz = pm_erskz                                  "HGA046836
          erssl = pm_erssl                                  "HGA046836
          mbwls = ' '                                       "HGA046836
          mehrs = 'X'                                       "HGA046836
          mmory = mem_mngmt                                 "HGA046836
          mtnrv = pm_mtnrv                                  "HGA046836
          postp = pm_postp                                  "HGA046836
          pspnr = pm_pspnr                                  "HGA046836
          rndkz = tcspr-amekz                               "HGA046836
          rvrel = pm_rvrel                                  "HGA046836
          sanko = pm_sanko                                  "HGA046836
          sanfr = pm_sanfe                                  "HGA046836
          sanin = pm_sanin                                  "HGA046836
          sanka = pm_sanka                                  "HGA046836
          sanvs = pm_sanvs                                  "HGA046836
          schgt = pm_schgt                                  "HGA046836
          stkkz = pm_stkkz                                  "HGA046836
          stlal = pm_stlal                                  "HGA046836
          stlan = pm_stlan                                  "HGA046836
          stpst = pm_stpst                                  "HGD246532
          werks = pm_werks                                  "HGA046836
       IMPORTING                                            "HGA046836
          topmat                = selpool                   "HGA046836
          dstst                 = dstst_flg                 "HGA046836
       TABLES                                               "HGA046836
          stb                   = stb                       "HGA046836
          matcat                = matcat                    "HGA046836
       EXCEPTIONS                                           "HGA046836
          material_not_found    = 4                         "HGA046836
          no_plant_data         = 8                         "HGA046836
          no_suitable_bom_found = 16                        "HGA046836
          alt_not_found         = 24                        "HGA046836
          missing_authorization = 28                        "HGA046836
          conversion_error      = 36                        "HGA046836
          no_bom_found          = 40                        "HGA046836
          .                                                 "HGA046836

    IF sy-subrc <> 0.                                       "HGA046836
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.                                                  "HGA046836
  ENDIF.                                                    "HGB084505


*  ggf Grafikbutton ausschalten
  IF NOT dstst_flg IS INITIAL.                              "YHG132854
    SET PF-STATUS sy-pfkey EXCLUDING 'CSGR'.                "YHG132854
  ENDIF.                                                    "YHG132854

*  SubRc auswerten
  PERFORM subrc_explr.


*eject
* ---------------------------------
TOP-OF-PAGE.
  PERFORM top_01_79.


*eject
* ---------------------------------
TOP-OF-PAGE DURING LINE-SELECTION.
  PERFORM top_01_79.

  IF NOT mpos_line IS INITIAL.                              "HGB084505
    SCROLL LIST TO PAGE mpos_page LINE mpos_line.           "HGB084505
  ENDIF.                                                    "HGB084505


*eject
* ---------------------------------
END-OF-SELECTION.
*del   PERFORM ANZEIGEFELDER_SETZEN.                          "YHG133914
  PERFORM cs12_vorbereiten.

  IF cal_aclas EQ 'CA  '.
    EXPORT selpool TO MEMORY ID 'CSNN_CSTMAT'.
    EXPORT stb     TO MEMORY ID 'CSNN_STB'.
    EXPORT matcat  TO MEMORY ID 'CSNN_MATCAT'.              "YHG134257

    CLEAR: cal_aclas.
    LEAVE.
  ENDIF.

  IF NOT pm_alvsa IS INITIAL.                               "HGA246532
    PERFORM cs12.
    PERFORM clr_hide_area.
    CLEAR: hlf_stlnr.

    IF NOT mpos_line IS INITIAL.                            "HGB084505
      SCROLL LIST TO PAGE mpos_page LINE mpos_line.         "HGB084505
    ENDIF.                                                  "HGB084505
  ELSE.                                                     "HGA246532
    PERFORM alv_top_tb_prep USING alv_top_tb.               "HGA246532
    PERFORM cs12_alv.                                       "HGA246532
  ENDIF.                                                    "HGA246532


*eject
* ---------------------------------
INCLUDE ZRCSNN001.
*  INCLUDE rcsnn001.


*eject
***********************************************************************
*        F O R M  -  Routinen                                         *
***********************************************************************
*eject
*---------------------------------------------------------------------*
*        ANZEIGEFELDER_SETZEN                                         *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM anzeigefelder_setzen.
  CLEAR:
     anz_stptx.

  IF NOT selpool-altst IS INITIAL.
    anz_stptx = '101'.
    anz_stlal = selpool-stlal.
  ENDIF.
  IF NOT selpool-varst IS INITIAL.
    anz_stptx = '102'.
  ENDIF.
  IF NOT selpool-kbaus IS INITIAL.
    anz_stptx = '103'.
  ENDIF.

  anz_datuv = selpool-datuv.
  anz_datub = selpool-datub.
ENDFORM.                    "anzeigefelder_setzen


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_01_79                                                *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM anzeige_01_79.
* ---------------------------------
* Routine im wesentlichen nach ANZEIGE_01_79_DRUCK uebernommen
* ---------------------------------
  IF stb-mngko >= max_num.
    ueberl_flg = ueberl_kz.
  ELSE.
    IF stb-mngko <= min_num.
      ueberl_flg = ueberl_kz.
    ELSE.
      CLEAR: ueberl_flg.
    ENDIF.
  ENDIF.

  PERFORM stufe_aufbereiten.
  PERFORM anzeige_02_79.

*del IF SY-UCOMM NE 'CSPR'.                                   "YHG133914
  PERFORM anzeige_01_79_liste.
*del ELSE.                                                    "YHG133914
*del    PERFORM ANZEIGE_01_79_DRUCK.                          "YHG133914
*del ENDIF.                                                   "YHG133914

*  ?Klassenposition
*   und Zuordnungen komplett od. teilweise anzeigen bzw. drucken
*  ja
  IF     stb-objty EQ otyp_kla
     AND (     NOT pm_dspco IS INITIAL
*d          OR  sy-ucomm EQ 'CSCA'                          "note 351902
*d          OR  sy-ucomm EQ 'CSPR' ).                       "note 351902
           OR  sv_ucomm EQ 'CSCA'                          "note 351902
           OR  sv_ucomm EQ 'CSPR' ).                       "note 351902

*     Teilkey der Klassenpositionentabelle fuellen
    cl_clstab-class = stb-class.
    cl_clstab-klart = stb-klart.

*     Bearbeitungsstand zur aktuellen Klassenposition versorg
    READ TABLE cl_clstab
       WITH KEY cl_clstab(21)
       BINARY SEARCH.

*     ?Zuordnungen anzeigen
*     ja
    IF NOT cl_clstab-dsply IS INITIAL.
*        ?Klassenposition bereits bearbeitet
*        nein
      IF cl_clstab-chked IS INITIAL.
*           Klassenposition bearbeiten
        PERFORM chk_cl_clstab_entry.
      ENDIF.

*        ?gibt es ueberhaupt Zuordnungen zum Anzeigen
*        ja
      IF cl_clstab-noobj IS INITIAL.
*           na also, dann los
        PERFORM anzeige_04_79.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "anzeige_01_79


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_01_79_DRUCK                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  entfaellt mit var. Liste
*del FORM ANZEIGE_01_79_DRUCK.
*del ENDFORM.


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_01_79_LISTE                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  komplett ueberarbeitet                                     "YHG133914
FORM anzeige_01_79_liste.
  DATA: lkl_blockname LIKE klah-class.
* ---------------------------------

*  Stufe - ohne Vorzeichen - in Uebergabestruktur uebernehmen
  WRITE anz_stufe TO stb_add-dglvl NO-SIGN.

*  Feld fuer ObjAnzeige in Uebergabestruktur initialisieren
  CLEAR: stb_add-dobjt.
  CLEAR: lkl_blockname.

*  ?die Komponente ist ...
  CASE stb_orig-objty.
*     ... ein Material
    WHEN otyp_mat.
*        Blockname festlegen
      lkl_blockname = 'ITEM_M            '.

*     ... ein Material (ein altes)
    WHEN 'M'.
*        Blockname festlegen
      lkl_blockname = 'ITEM_M            '.

*     ... objektlos; z.B. eine Textposition
    WHEN otyp_noo.
*        Blockname festlegen
      lkl_blockname = 'ITEM_NOO          '.

*     ... ein Dokument
    WHEN otyp_doc.
*        Blockname festlegen
      lkl_blockname = 'ITEM_D            '.

*     ... eine Klasse
    WHEN otyp_kla.
*        Blockname festlegen
      lkl_blockname = 'ITEM_C            '.

*     ... ein Intramaterial
    WHEN otyp_ntm.
*        Blockname festlegen
      lkl_blockname = 'ITEM_NTM          '.

*     ... ein UFO
    WHEN OTHERS.
*        Blockname festlegen
      CLEAR: lkl_blockname.
  ENDCASE.

*  Ueberlaufschalter in Uebergabestruktur uebernehmen
  stb_add-ovfls = ueberl_flg.

*  ?Komponente ist selber Stueckliste
*  ja
  IF NOT stb_orig-xtlnr IS INITIAL.
*     Kennzeichen in Uebergabestruktur setzen
    stb_add-bomfl = b_flag.
  ENDIF.

*  ?Komponente ist Wissensbaustein zugeordnet
*  ja
*d IF NOT STB_ORIG-KNOBJ IS INITIAL.                "YHG139320"YHG127645
  IF     NOT stb_orig-knobj IS INITIAL                      "YHG127645
     OR  NOT stb_orig-class IS INITIAL                      "YHG127645
     OR  NOT stb_orig-kzclb IS INITIAL.                     "YHG127645

*     Kennzeichen in Uebergabestruktur setzen
    stb_add-knofl = 'X'.                                    "YHG139320
  ENDIF.                                                    "YHG139320

*  ?es gibt einen Positionstext
*  ja
  IF NOT stb_orig-potx1 IS INITIAL.
*     ?der Positionstext stimmt mit dem Kurztext ueberein
*     ja
    IF     stb_orig-potx1 EQ stb_orig-ojtxp.
*        dann kann man den Positionstext loeschen
      CLEAR: stb_orig-potx1.
    ENDIF.
  ENDIF.

*d IF NOT pm_ltext IS INITIAL.                    "HGA132240"note 306308
*d    IF NOT stb-ltxsp IS INITIAL.                "HGA132240"note 306308
  IF     NOT pm_ltext IS INITIAL                           "note 306308
     AND NOT stb-ltxsp IS INITIAL.                         "note 306308

    PERFORM ltext_holen.                                    "HGA132240

    IF sy-subrc = 0.                                        "HGA132240
      READ TABLE txt INDEX 1.                               "HGA132240
      IF stb-potx1 = txt-tdline.                            "HGA132240
        IF stb_orig-potx1 IS INITIAL.                "note 375902
          IF stb_orig-ojtxp = txt-tdline.           "note 375902
            CLEAR: stb_orig-ojtxp.                 "note 375902
          ENDIF.                                    "note 375902
        ENDIF.                                       "note 375902

        CLEAR: stb_orig-potx1.                              "HGA132240

        READ TABLE txt INDEX 2.                             "HGA132240
        IF stb-potx2 = txt-tdline.                          "HGA132240
          CLEAR: stb_orig-potx2.                            "HGA132240
        ENDIF.                                              "HGA132240
      ENDIF.                                                "HGA132240

      PERFORM txt_conv_chk                            "note 306308
        TABLES                                        "note 306308
          txt                                         "note 306308
        USING                                         "note 306308
          ' '                                         "note 306308
          ' '.                                        "note 306308

      CALL FUNCTION 'FORMAT_TEXTLINES'                      "HGA132240
         EXPORTING                                          "HGA132240
*d                   FORMATWIDTH = 41                         "HGA132240
               formatwidth = 40                       "note 667950
               linewidth   = 40                       "note 875961
         TABLES                                             "HGA132240
               lines       = txt.                           "HGA132240

      IF     stb_orig-potx1 IS INITIAL                      "HGA132240
         AND stb_orig-potx2 IS INITIAL.                     "HGA132240

        READ TABLE txt INDEX 1.                             "HGA132240
        stb_orig-potx1 = txt-tdline.                        "HGA132240
        stb-potx1      = txt-tdline.                        "HGA132240

        READ TABLE txt INDEX 2.                             "HGA132240
        stb_orig-potx2 = txt-tdline.                        "HGA132240
        stb-potx2      = txt-tdline.                        "HGA132240
      ENDIF.                                                "HGA132240
    ELSE.                                                   "HGA029649
      txt-tdline = text-097.                                "HGA029649
      APPEND txt.                                           "HGA029649
    ENDIF.                                                  "HGA132240
*d    ENDIF.                                      "HGA132240"note 306308
  ELSE.                                                    "note 306308
    PERFORM txt_conv_chk                                  "note 306308
      TABLES                                              "note 306308
        txt                                               "note 306308
      USING                                               "note 306308
        stb_orig-potx1                                    "note 306308
        stb_orig-potx2.                                   "note 306308
  ENDIF.                                                    "HGA132240

*  Positionszeile
*  je nach Farbschalter
  IF col_switch IS INITIAL.
*     hellen Hintergrund an-
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    col_switch = 'x'.
  ELSE.
*     ... oder ausschalten
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    CLEAR: col_switch.
  ENDIF.

*  WATAB initialisieren und komplett leeren
  CLEAR: watab. REFRESH: watab.
*  Uebergabestruktur (Typ STPOX) ...
*d watab-tname = 'STPOX'. watab-table = stb_orig .                   "uc
  watab-tname = 'STPOX'.                                            "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN stb_orig    TO <x_stpox_wa>     CASTING.                   "uc
  <x_watab-table> = <x_stpox_wa> .                                  "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR: watab.
*  Uebergabestruktur (Typ CSCMAT) ...
*d watab-tname = 'CSCMAT'. watab-table = matcat.                     "uc
  watab-tname = 'CSCMAT'.                                           "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN matcat      TO <x_cscmat_wa>    CASTING.                   "uc
  <x_watab-table> = <x_cscmat_wa> .                                 "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR watab.
*  Uebergabestruktur (Typ STPOL_ADD) ...
*d watab-tname = 'STPOL_ADD'. watab-table = stb_add .                "uc
  watab-tname = 'STPOL_ADD'.                                        "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN stb_add     TO <x_stpol_add_wa> CASTING.                   "uc
  <x_watab-table> = <x_stpol_add_wa> .                              "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR watab.

*  Daten zur Position ausgeben
  PERFORM write_block
     USING  lkl_blockname
*            ausgegebene Zeilen nicht zaehlen
            ' '
*            Hide ausfuehren
            'x'.                                            "YHG123656

*  ?soll Langtext ausgegeben werdem
*  ja
  IF NOT pm_ltext IS INITIAL.
*     ?gibt es Langtext
*     ja
    IF NOT stb-ltxsp IS INITIAL.
*        Langtext einlesen
*d       perform ltext_holen.                                 "HGA132240
      READ TABLE txt INDEX 1.                               "HGA132240

*        ?Langtext konnte eingelesen werden
*        ja
      IF sy-subrc = 0.
*           pro Textzeile ...
        LOOP AT txt.
*              ?wenn Zeile 1 ...
          IF sy-tabix = 1.
*                 gleich der ersten PosTextzeile ist, - nicht ausgeben
            CHECK stb-potx1 <> txt-tdline.
          ENDIF.

*              ?wenn Zeile 1 ...
          IF sy-tabix = 2.
*                 gleich der zweiten PosTextzeile ist, - nicht ausgeben
            CHECK stb-potx2 <> txt-tdline.
          ENDIF.

*              Uebergabestruktur initialisieren
          CLEAR: stb_add.
*              Textzeile in Uebergabestruktur uebernehmen
          stb_add-tline = txt-tdline.

*              WATAB initialisieren und komplett leeren
          CLEAR watab. REFRESH watab.
*              Uebergabestruktur (Typ STPOL_ADD) ...
*d             watab-tname = 'STPOL_ADD'. watab-table = stb_add .    "uc
          watab-tname = 'STPOL_ADD'.                            "uc
          ASSIGN watab-table TO <x_watab-table>  CASTING.       "uc
          ASSIGN stb_add     TO <x_stpol_add_wa> CASTING.       "uc
          <x_watab-table> = <x_stpol_add_wa> .                  "uc
*              ... sichern
          APPEND watab.

*              WATAB initialisieren und komplett leeren
          CLEAR watab.
*              Langtextzeile ausgeben
          PERFORM write_block
             USING 'LTEXT_LIN         '
*                       ausgegebene Zeilen nicht zaehlen
                   ' '
*                       Hide ausfuehren
                   'x'.                                     "YHG123656
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "anzeige_01_79_liste


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_02_79                                                *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM anzeige_02_79.
* ---------------------------------
* Routine im wesentlichen nach ANZEIGE_02_79_DRUCK uebernommen
* ---------------------------------
*del IF SY-UCOMM NE 'CSPR'.                                   "YHG133914
  PERFORM anzeige_02_79_liste.
*del ELSE.                                                    "YHG133914
*del    PERFORM ANZEIGE_02_79_DRUCK.                          "YHG133914
*del ENDIF.                                                   "YHG133914
ENDFORM.                    "anzeige_02_79


*---------------------------------------------------------------------*
*        ANZEIGE_02_79_DRUCK                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  entfaellt mit var. Liste
*del FORM ANZEIGE_02_79_DRUCK.
*del ENDFORM.


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_02_79_LISTE                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  komplett ueberarbeitet                                     "YHG133914
FORM anzeige_02_79_liste.
  IF stb-stlnr NE hlf_stlnr.
    IF     pm_beikz NE space
       OR  pm_bessl NE space
       OR  pm_erskz NE space
       OR  pm_erssl NE space
       OR  pm_bagrp NE space
       OR  pm_postp NE space.

      IF first_flg IS INITIAL.
        first_flg = 'n'.
      ELSE.
        ULINE AT /1(siz_linpf).
      ENDIF.

      WRITE cnull TO stb_add-dposn.
*d       WRITE MATCAT-MATNR TO STB_ADD-MATNR.                 "HGA105944
      stb_add-matnr = matcat-matnr.                         "HGA105944

      CLEAR: col_switch.
      FORMAT COLOR COL_GROUP INTENSIFIED OFF.

*        WATAB initialisieren und komplett leeren
      CLEAR: watab. REFRESH: watab.
*        Uebergabestruktur (Typ STPOL_ADD) ...
*d       watab-tname = 'STPOL_ADD'. watab-table = stb_add ."HGA025100"uc
      watab-tname = 'STPOL_ADD'.                                  "uc
      ASSIGN watab-table TO <x_watab-table>  CASTING.             "uc
      ASSIGN stb_add     TO <x_stpol_add_wa> CASTING.             "uc
      <x_watab-table> = <x_stpol_add_wa> .                        "uc
*        ... sichern
      APPEND watab.

*        WATAB initialisieren und komplett leeren
      CLEAR: watab.                                         "HGA025100
*        Uebergabestruktur (Typ CSCMAT) ...
*d       watab-tname = 'CSCMAT'. watab-table = matcat.     "HGA025100"uc
      watab-tname = 'CSCMAT'.                                     "uc
      ASSIGN watab-table TO <x_watab-table>  CASTING.             "uc
      ASSIGN matcat     TO <x_cscmat_wa>     CASTING.             "uc
      <x_watab-table> = <x_cscmat_wa> .                           "uc
*        ... sichern
      APPEND watab.                                         "HGA025100

*        WATAB initialisieren
      CLEAR watab.
*        Kopfdaten zum SemiFinishedProduct ausgeben
      PERFORM  write_block
         USING 'SFP_INFO          '
*                 ausgegebene Zeilen nicht zaehlen
               ' '
*                 Hide nicht ausfuehren
               ' '.                                         "YHG123656

      hlf_stlnr = stb-stlnr.
    ENDIF.
  ENDIF.
ENDFORM.                    "anzeige_02_79_liste


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_03_79                                                *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM anzeige_03_79.
* ---------------------------------
* Routine im wesentlichen nach ANZEIGE_03_79_DRUCK uebernommen
* ---------------------------------
*del IF SY-UCOMM NE 'CSPR'.                                   "YHG133914
  PERFORM anzeige_03_79_liste.
*del ELSE.                                                    "YHG133914
*del    PERFORM ANZEIGE_03_79_DRUCK.                          "YHG133914
*del ENDIF.                                                   "YHG133914
ENDFORM.                    "anzeige_03_79


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_03_79_DRUCK                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  entfaellt mit var. Liste
*del FORM ANZEIGE_03_79_DRUCK.
*del ENDFORM.


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_03_79_LISTE                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  komplett ueberarbeitet                                     "YHG133914
FORM anzeige_03_79_liste.
*  Uebergabestruktur (Typ STPOL_ADD) initialisieren
  CLEAR: stb_add.
*  Kennzeichen 'Unterpositionen existieren od. auch nicht' uebernehmen
  stb_add-dupmg = anz_upmng.

*  WATAB initialisieren und komplett leeren
  CLEAR: watab. REFRESH: watab.
*  Uebergabestruktur (Typ STPUB) ...
*d watab-tname = 'STPUB'. watab-table = stpub .                      "uc
  watab-tname = 'STPUB'.                                            "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN stpub       TO <x_stpub_wa>     CASTING.                   "uc
  <x_watab-table> = <x_stpub_wa> .                                  "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR watab.
*  Uebergabestruktur (Typ STPOX) ...
*d watab-tname = 'STPOX'. watab-table = stb_orig .                   "uc
  watab-tname = 'STPOX'.                                            "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN stb_orig    TO <x_stpox_wa>     CASTING.                   "uc
  <x_watab-table> = <x_stpox_wa> .                                  "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR: watab.
*  Uebergabestruktur (Typ CSCMAT) ...
*d watab-tname = 'CSCMAT'. watab-table = matcat.                     "uc
  watab-tname = 'CSCMAT'.                                           "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN matcat     TO <x_cscmat_wa>     CASTING.                   "uc
  <x_watab-table> = <x_cscmat_wa> .                                 "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR watab.
*  Uebergabestruktur (Typ STPOL_ADD) ...
*d watab-tname = 'STPOL_ADD'. watab-table = stb_add .                "uc
  watab-tname = 'STPOL_ADD'.                                        "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN stb_add     TO <x_stpol_add_wa> CASTING.                   "uc
  <x_watab-table> = <x_stpol_add_wa> .                              "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR watab.
*  Daten zur Unterposition ausgeben
  PERFORM write_block
     USING 'SUB_ITEM          '
*           ausgegebene Zeilen nicht zaehlen
           ' '
*           Hide ausfuehren
           'x'.                                             "YHG123656
ENDFORM.                    "anzeige_03_79_liste


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_04_79                                                *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM anzeige_04_79.
*del IF SY-UCOMM NE 'CSPR'.                                   "YHG133914
  PERFORM anzeige_04_79_liste.
*del ELSE.                                                    "YHG133914
*del    PERFORM ANZEIGE_04_79_DRUCK.                          "YHG133914
*del ENDIF.                                                   "YHG133914
ENDFORM.                    "anzeige_04_79


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_04_79_DRUCK                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  entfaellt mit var. Liste
*del FORM ANZEIGE_04_79_DRUCK.
*del ENDFORM.


*eject
*---------------------------------------------------------------------*
*        ANZEIGE_04_79_LISTE                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM anzeige_04_79_liste.
* ---------------------------------
  DATA: sav_cl_objmemo LIKE cl_objmemo.
* ---------------------------------
*  Teilkey der KlassenObjekteMemotabelle fuellen
  sav_cl_objmemo(18)   = stb-class.
  sav_cl_objmemo+18(3) = stb-klart.

*  Merktabelle lesen
  READ TABLE cl_objmemo
     WITH KEY sav_cl_objmemo(21)
     BINARY SEARCH.

*  ?passende Eintraege (Zuordnungen) gefunden
*  ja
  IF sy-subrc = 0.
    CLEAR: stb_add.                                         "YHG133914
*     Alle passenden Zuordnungen ...
    LOOP AT cl_objmemo FROM sy-tabix.
*        ?Eintrag passt noch
*        nein
*del     IF CL_OBJMEMO(21) NE SAV_CL_OBJMEMO.                 "YHG100916
      IF cl_objmemo(21) NE sav_cl_objmemo(21).              "YHG100916
*           Ausgabe beenden
        EXIT.
      ENDIF.

*        MatNr fuer HIDE festlegen
*d       CLO_MATNR = CL_OBJMEMO-OBJECT(18).                   "HGA080825
      clo_matnr = cl_objmemo-object(mnr_lng).               "HGA080825

*        gib Zuordnungen aus
*-- ab hier neu -------------------------------------------------------*
*        Klassenobjekt (Mat) in Uebergabestruktur uebernehmen
*d     WRITE CL_OBJMEMO-OBJECT(18) TO STB_ADD-CLOBJ."YHG133914"HGA080825
      WRITE cl_objmemo-object TO stb_add-clobj(mnr_lng).    "HGA080825
*        Kurztext zum Objekt in Uebergabestruktur uebernehmen
      WRITE cl_objmemo-text(40) TO stb_add-clotx.           "YHG133914

*        WATAB initialisieren und komplett leeren
      CLEAR: watab. REFRESH: watab.                         "YHG133914
*        Uebergabestruktur (Typ STPOL_ADD) ...
*d       watab-tname = 'STPOL_ADD'. watab-table = stb_add ."YHG133914"uc
      watab-tname = 'STPOL_ADD'.                                  "uc
      ASSIGN watab-table TO <x_watab-table>  CASTING.             "uc
      ASSIGN stb_add     TO <x_stpol_add_wa> CASTING.             "uc
      <x_watab-table> = <x_stpol_add_wa> .                        "uc
*        ... sichern
      APPEND watab.                                         "YHG133914

*        WATAB initialisieren
      CLEAR watab.                                          "YHG133914
*        Daten zum Objekt der Klasse ausgeben
      PERFORM write_block                                   "YHG133914
         USING 'CLASS_OBJ         '                         "YHG133914
*                 ausgegebene Zeilen nicht zaehlen
               ' '                                          "YHG133914
*                 Hide nicht ausfuehren
               ' '.                                         "YHG123656
    ENDLOOP.
  ENDIF.
ENDFORM.                    "anzeige_04_79_liste




*eject
*---------------------------------------------------------------------*
*        CS12                                                         *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM cs12.
*d IF NOT SY-BATCH IS INITIAL.                                "HGC072824
  IF     NOT sy-batch IS INITIAL                            "HGC072824
     AND cattaktiv IS INITIAL.                              "HGC072824

    PERFORM print_mode_batch.
  ENDIF.

*  ?Druck eingeschaltet
*  ja
*d IF sy-ucomm EQ 'CSPR'.                         "YHG133914"note 351902
  IF sv_ucomm EQ 'CSPR'.                                   "note 351902
*     Druckprofil aktivieren
    act_profil = pm_prprf.                                  "YHG133914

    PERFORM prof_get_cmpl                                   "HGB020150
       USING itf_prfsz.                                     "HGB020150

    PERFORM prrsv_tb_cre.                                   "HGB020150
*  nein, Bildschirmausgabe
  ELSE.                                                     "YHG133914
*     Bildschirmausgabeprofil aktivieren
    act_profil = pm_dsprf.                                  "YHG133914
  ENDIF.                                                    "YHG133914

*  im Profil definierte Zeilenbreite besorgen
  CALL FUNCTION 'CLFC_PROFILE_SIZE'                         "YHG133914
       EXPORTING                                            "YHG133914
*del         LISTID           = 'SAPCSMLVM         '"YHG133914"YHG137424
            listid                = list_id                 "YHG137424
            profile               = act_profil              "YHG133914
       IMPORTING                                            "YHG133914
*del         SIZE                  = SAV_PRFSZ      "YHG133914"YHG32486
            size                  = itf_prfsz               "YHG32486
       EXCEPTIONS                                           "YHG133914
            listid_not_found      = 01                      "YHG133914
            no_valid_listid       = 02                      "YHG133914
            no_valid_profile      = 03                      "YHG133914
            profile_not_found     = 04                      "YHG133914
            profile_not_in_listid = 05.                     "YHG133914

  sav_prfsz = itf_prfsz.                                    "YHG32486

  IF sy-subrc <> 0.                                         "YHG137424
*     ?Druck eingeschaltet
*     ja
*d    IF sy-ucomm EQ 'CSPR'.                      "YHG137424"note 351902
    IF sv_ucomm EQ 'CSPR'.                                "note 351902
*        Druckprofil aktivieren
      act_profil = dflt_prprf.                              "YHG137424
*     nein, Bildschirmausgabe
    ELSE.                                                   "YHG137424
*        Bildschirmausgabeprofil aktivieren
      act_profil = dflt_dsprf.                              "YHG137424
    ENDIF.                                                  "YHG137424

    CALL FUNCTION 'CLFC_PROFILE_SIZE'                       "YHG137424
         EXPORTING                                          "YHG137424
              listid  = list_id                             "YHG137424
              profile = act_profil                          "YHG137424
         IMPORTING                                          "YHG137424
*del            SIZE    = SAV_PRFSZ.                "YHG137424"YHG032486
              size    = itf_prfsz.                          "YHG032486

    sav_prfsz = itf_prfsz.                                  "YHG032486
  ENDIF.                                                    "YHG137424

*  Zeilenbreiten wg. Rahmen um 2 erhoehen
  siz_linpf = sav_prfsz + 2.                                "YHG133914

*d IF sy-ucomm EQ 'CSPR'.                         "YHG139715"note 351902
  IF sv_ucomm EQ 'CSPR'.                                   "note 351902
    PERFORM prep_druck.                                     "YHG139715
  ENDIF.                                                    "YHG139715

  PERFORM create_dsp_sel.                                   "YHG139715

*d IF sy-ucomm EQ 'CSPR'.                         "YHG139715"note 351902
  IF sv_ucomm EQ 'CSPR'.                                   "note 351902
    PERFORM selkrit_druck.                                  "YHG139715
  ENDIF.                                                    "YHG139715

  LOOP AT stb.
*     Uebergabestrukturen initialisieren
    CLEAR: stb_orig,                                        "YHG133914
           stb_add.                                         "YHG133914

    IF stb-ttidx <> matcat-index.
      READ TABLE matcat INDEX stb-ttidx.
    ENDIF.

*     STB-Eintrag in Uebergabestruktur uebernehmen
    stb_orig = stb.                                         "YHG133914

    PERFORM anzeige_01_79.

    IF NOT pm_upsaz IS INITIAL.
      PERFORM upos_bearbeitung.
    ENDIF.
  ENDLOOP.

*  ?gab es ueberhaupt einen STB-Eintrag
*  nein
  IF sy-subrc <> 0.
*     traurige Nachricht ausgeben
    MESSAGE s513 WITH 'E: '.
*  ja, Positionen gefunden und ausgegeben
  ELSE.
*     ?wird gerade gedruckt
*     nein
*d    IF sy-ucomm NE 'CSPR'.                                "note 351902
    IF sv_ucomm NE 'CSPR'.                                "note 351902
*        Liste mit Strichlinie abschliessen
*del     ULINE (81).                                "YHG036694"YHG133914
      ULINE AT /1(siz_linpf).                               "YHG133914
*del     PERFORM END_PAGE.                          "YHG036694"YHG133914
    ELSE.                                                   "YHG139336
      SKIP.                                                 "YHG139336
*        Ende der Liste
      FORMAT COLOR COL_BACKGROUND.                          "YHG139336
      WRITE: /       text-098 INTENSIFIED.                  "YHG139336
    ENDIF.
  ENDIF.
ENDFORM.                                                    "cs12


*eject
*---------------------------------------------------------------------*
*        CS12_VORBEREITEN                                             *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM cs12_vorbereiten.
  CLEAR: cl_clstab,
         cl_objmemo.

  REFRESH: cl_clstab,
           cl_objmemo.

  LOOP AT stb.
    PERFORM obj_ident.                                      "YHG121750

    PERFORM cl_clstab_maint.
  ENDLOOP.

  SORT stb BY index ASCENDING.

*  ?Fuer Klassenpositionen alle Zuordnungen ausgeben
*  ja
  IF NOT pm_dspco IS INITIAL.
*     alle Zuordnungen aller Klassenpositionen besorgen
    PERFORM get_cla_allocs_all.
  ENDIF.
ENDFORM.                    "cs12_vorbereiten


*eject
*---------------------------------------------------------------------*
*        LISTE_DRUCKEN                                                *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM liste_drucken.
  PERFORM cs12.
ENDFORM.                    "liste_drucken


*eject
*---------------------------------------------------------------------*
*        LTEXT_HOLEN                                                  *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM ltext_holen.
  DATA: BEGIN OF txhdr.                                     "HGB057558
          INCLUDE STRUCTURE thead.                          "HGB057558
  DATA: END OF txhdr.                                       "HGB057558
*----------------------------------

  CLEAR: txt_key.
  WRITE sy-mandt  TO txt_key USING NO EDIT MASK.
  txt_kyln = strlen( txt_key ).
  WRITE stb-stlty TO txt_key+txt_kyln.
  txt_kyln = strlen( txt_key ).
  WRITE stb-stlnr TO txt_key+txt_kyln USING NO EDIT MASK.
  txt_kyln = strlen( txt_key ).
  WRITE stb-stlkn TO txt_key+txt_kyln.
  txt_kyln = strlen( txt_key ).
  WRITE stb-stpoz TO txt_key+txt_kyln.

*d bom_txid = mbm_txid.                           "HGA029649"note 411978
*d IF stb-stlty EQ typ_knd.                       "HGA029649"note 411978
*d   bom_txid = kbm_txid.                         "HGA029649"note 411978
*d ENDIF.                                         "HGA029649"note 411978

  bom_txid(1) = stb-stlty.                                 "note 411978
  bom_txid+1  = 'PO'.                                      "note 411978

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id        = bom_txid
      language  = stb-ltxsp
      name      = txt_key
      object    = bom_txobj
    IMPORTING                                               "HGB057558
      header    = txhdr                                     "HGB057558
    TABLES
*                                                           "HGA029649
      lines     = txt                                       "HGA029649
    EXCEPTIONS                                              "HGA029649
      not_found = 1.                                        "HGA029649

  IF sy-subrc = 0.                                          "HGA029649
    PERFORM create_txincl_cmd.                              "HGB057558

    CALL FUNCTION 'TEXT_INCLUDE_REPLACE'                    "HGB057558
       EXPORTING                                            "HGB057558
             header = txhdr                                 "HGB057558
       TABLES                                               "HGB057558
             lines =  txt.                                  "HGB057558
  ENDIF.                                                    "HGA029649
ENDFORM.                    "ltext_holen


*eject
*---------------------------------------------------------------------*
*        MENGN_01                                                     *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM mengn_01.
  IF stb-menge <> stb-mngko.
    ups_faktor = stb-mngko / stb-menge .
  ELSE.
    ups_faktor = 1 .
  ENDIF.

  IF stb-roanz <> 0.
    ups_faktor = ups_faktor * ( stb-menge / stb-roanz ) .
  ENDIF.
ENDFORM.                                                    "mengn_01


*eject
*---------------------------------------------------------------------*
*        MENGN_02                                                     *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM mengn_02.
  IF ups_faktor <> 1 .
    anz_upmng = stpub-upmng * ups_faktor.
  ELSE.
    anz_upmng = stpub-upmng.
  ENDIF.
ENDFORM.                                                    "mengn_02


*eject
*---------------------------------------------------------------------*
*        NEU_ANZEIGE                                                  *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM neu_anzeige.
*  Liste anzeigen
  PERFORM cs12.
*  Hidebereich loeschen
  PERFORM clr_hide_area.
ENDFORM.                    "neu_anzeige


*eject
*---------------------------------------------------------------------*
*        OBJ_IDENT                                                    *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM obj_ident.                                             "YHG121750
*  weder Mat noch Doc
  CHECK: stb-objty NE otyp_mat,
         stb-objty NE ootyp_mat,                            "HGB099459
         stb-objty NE otyp_doc,
         stb-objty NE otyp_ntm.

*  ?T418-WA schon ok
*  nein
  IF stb-postp NE t418-postp.
*     T418 einlesen
    PERFORM t418_lesen USING stb-postp.
  ENDIF.

*  ?MatNr-Eingabe bei diesem PosTyp moeglich
*   und keine Textposition
*  trifft zu
  IF     t418-matin NE '-'
     AND t418-txpos IS INITIAL.

*     aktuelles Objekt ist Material NLAG
    stb-objty = '1'.
*     PosKurztext in ObjKurztext uebernehmen.
    stb-ojtxp = stb-potx1.
    MODIFY stb.
  ELSE.
    IF stb-objty IS INITIAL.
      stb-objty = '2'.
      MODIFY stb.
    ENDIF.
  ENDIF.
ENDFORM.                    "obj_ident


*eject
*---------------------------------------------------------------------*
*        SEL_GRENZEN_01                                               *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM sel_grenzen_01.
  IF tcs03-lowdt IS INITIAL.
    pm_datuv = syst-datum.
  ELSE.
    pm_datuv = min_grg.
  ENDIF.
ENDFORM.                    "sel_grenzen_01


*eject
*---------------------------------------------------------------------*
*        SEL_GRENZEN_02                                               *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM sel_grenzen_02.
*  ?Report wurde von woanders per Submit gestartet
*  nein
*del IF CSBOMEX-SUBMF IS INITIAL.                             "YHG133914
*  Stuecklistenverwendung aus der ParameterArea vorschlagen
  GET PARAMETER ID 'CSV' FIELD pm_stlan.
*  Stuecklistenanwendung aus der ParameterArea vorschlagen
  GET PARAMETER ID 'CSA' FIELD pm_capid.
*del ENDIF.                                                   "YHG133914
ENDFORM.                    "sel_grenzen_02


*eject
*---------------------------------------------------------------------*
*        SET_MARGIN                                                   *
*---------------------------------------------------------------------*
*        in Include RCSNN001 verlagert
*---------------------------------------------------------------------*


*eject
*---------------------------------------------------------------------*
*        SET_SCHALTER                                                 *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM set_schalter.
  IF NOT tcspr-upsaz IS INITIAL.
    pm_upsaz = 'X'.
  ENDIF.

  IF NOT tcspr-ltext IS INITIAL.                            "HGA127128
    pm_ltext = 'X'.                                         "HGA127128
  ENDIF.                                                    "HGA127128

  IF NOT tcspr-dspco IS INITIAL.                            "HGA246532
    pm_dspco = 'X'.                                         "HGA246532
  ENDIF.                                                    "HGA246532

  IF NOT tcspr-valst IS INITIAL.                            "HGA246532
    pm_alvsa = 'X'.                                         "HGA246532
  ENDIF.                                                    "HGA246532
ENDFORM.                    "set_schalter


*eject
*---------------------------------------------------------------------*
*        STPU_LESEN                                                   *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM stpu_lesen.
  CALL FUNCTION 'GET_STPU'
    EXPORTING
      set             = 'X'
      all             = 'X'
    TABLES
      wa              = stpub
    EXCEPTIONS
      no_record_found = 4
      key_incomplete  = 16
      call_invalid    = 24.
ENDFORM.                    "stpu_lesen


*eject
*---------------------------------------------------------------------*
*        STUFE_AUFBEREITEN                                            *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM stufe_aufbereiten.
  anz_stufe = stb-stufe.
  TRANSLATE anz_stufe USING ' .'.
  anz_stufe+10(1) = ' '.

  IF stb-stufe < 9.
    stb-stufe = 9 - stb-stufe.
    SHIFT anz_stufe BY stb-stufe PLACES.
    stb-stufe = 9 - stb-stufe.
  ENDIF.
ENDFORM.                    "stufe_aufbereiten


*eject
*---------------------------------------------------------------------*
*        T418_LESEN                                                   *
*---------------------------------------------------------------------*
*        -->                                                          *
*                                                                     *
*        <-- T418-WA                                                  *
*                                                                     *
*---------------------------------------------------------------------*
FORM t418_lesen USING lkl_postp.                            "YHG121750
*  T418-WA initialisieren
  CLEAR:
     t418.

*  Key angeben
  t418-postp = lkl_postp.
*  PosTypDefinition lesen
  READ TABLE t418.
ENDFORM.                                                    "t418_lesen


*eject
*---------------------------------------------------------------------*
*        TCS03_LESEN                                                  *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM tcs03_lesen.
  tcs03-agb29 = '29'.
  READ TABLE tcs03.
ENDFORM.                    "tcs03_lesen


*eject
*---------------------------------------------------------------------*
*        TCSPR_LESEN                                                  *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM tcspr_lesen.
  tcspr-csusr = sy-uname.
  READ TABLE tcspr.

  IF sy-subrc <> 0.                                         "HGG099459
    tcspr-csusr = 'DUMMY'.                                  "HGG099459
    READ TABLE tcspr.                                       "HGG099459
  ENDIF.                                                    "HGG099459
ENDFORM.                    "tcspr_lesen


*eject
*---------------------------------------------------------------------*
*        TOP_01_79                                                    *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM top_01_79.
*d CHECK sy-ucomm NE 'CSSL'.                      "YHG139715"note 351902
  CHECK sv_ucomm NE 'CSSL'.                                "note 351902

*del CLEAR: REAL_LINE.                                        "YHG133914

*del IF SY-UCOMM NE 'CSPR'.                                   "YHG133914
  PERFORM top_01_79_liste.
*del ELSE.                                                    "YHG133914
*del    PERFORM TOP_01_79_DRUCK.                              "YHG133914
*del ENDIF.                                                   "YHG133914
ENDFORM.                                                    "top_01_79


*eject
*---------------------------------------------------------------------*
*        TOP_01_79_DRUCK                                              *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  entfaellt mit var. Liste
*del FORM TOP_01_79_DRUCK.
*del ENDFORM.


*eject
*---------------------------------------------------------------------*
*        TOP_01_79_LISTE                                              *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*  komplett ueberarbeitet
FORM top_01_79_liste.
*  Zeilenzaehler initialisieren
  CLEAR: blclns_cnt.
*  SAV-WATAB-Entry initialisieren
  CLEAR: sav_watab.
*  SAV-WATAB leeren
  REFRESH: sav_watab.

*  die aktuellen WATab-Eintraege (var. Liste)
*del LOOP AT WATAB.                                           "YHG020009
*     ... nach SAV_WATAB ...                                  "YHG020009
*del  SAV_WATAB = WATAB.                                      "YHG020009
*     ... sichern                                             "YHG020009
*del  APPEND SAV_WATAB.                                       "YHG020009
*del ENDLOOP.                                                 "YHG020009
  sav_watab[] = watab[].                                    "YHG020009

*  ?EinstiegsStl ist MehrfachStl
*  ja
  IF NOT selpool-altst IS INITIAL.
*     fuehrende Nullen der AlternativenNr entfernen
    IF selpool-stlal(1) = '0'.
      selpool-stlal(1) = ' '.
    ENDIF.
*  nein, keine MehrfachStl
  ELSE.
*     AlternativenNr loeschen
    CLEAR: selpool-stlal.
  ENDIF.

*  Ausgabeformat festlegen
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.

*  ?Druck
*  ja
*d IF sy-ucomm EQ 'CSPR'.                                   "note 351902
  IF sv_ucomm EQ 'CSPR'.                                   "note 351902
*     Strich auf Zeile 2 mit Strichlinie aus AnzBlock ueberschreiben
*del  SKIP TO LINE 2.                                         "YHG139336
*del  SKIP TO LINE 1.                               "YHG139336"YHG137563
    SKIP TO LINE 2.                                         "YHG137563
  ENDIF.

*  WATAB initialisieren und komplett leeren
  CLEAR: watab. REFRESH: watab.
*  Uebergabestruktur (Typ CSTMAT) ...
*d watab-tname = 'CSTMAT'. watab-table = selpool .                   "uc
  watab-tname = 'CSTMAT'.                                           "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN selpool    TO <x_cstmat_wa>     CASTING.                   "uc
  <x_watab-table> = <x_cstmat_wa> .                                 "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR: watab,                                             "YHG127645
         stb_add.                                           "YHG127645

  stb_add-sldtv = pm_datuv.                                 "YHG127645
  stb_add-pspnr = pm_pspnr.                                 "HGA046836
  stb_add-vbeln = pm_vbeln.                                 "HGC072185
  stb_add-vbpos = pm_vbpos.                                 "HGC072185
*  Uebergabestruktur (Typ STPOL_ADD). - wg TOKNZ
*d watab-tname = 'STPOL_ADD'. watab-table = stb_add .      "YHG127645"uc
  watab-tname = 'STPOL_ADD'.                                        "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN stb_add     TO <x_stpol_add_wa> CASTING.                   "uc
  <x_watab-table> = <x_stpol_add_wa> .                              "uc
*  ... sichern
  APPEND watab.                                             "YHG127645

*  WATAB initialisieren
  CLEAR watab.
*  Listenkopf ausgeben
  PERFORM write_block
     USING 'LISTHDR           '
*           ausgegebene Zeilen zaehlen
           'x'
*           Hide nicht ausfuehren
           ' '.                                             "YHG123656

*  WATAB initialisieren und komplett leeren
  CLEAR: watab. REFRESH: watab.
*  Uebergabestruktur (Typ STPOX) ...
  watab-tname = 'STPOX'.
*  ... sichern
  APPEND watab.

*  WATAB initialisieren und komplett leeren
  CLEAR: watab.
*  Uebergabestruktur (Typ CSCMAT) ...
*d watab-tname = 'CSCMAT'. watab-table = matcat.                     "uc
  watab-tname = 'CSCMAT'.                                           "uc
  ASSIGN watab-table TO <x_watab-table>  CASTING.                   "uc
  ASSIGN matcat     TO <x_cscmat_wa>     CASTING.                   "uc
  <x_watab-table> = <x_cscmat_wa> .                                 "uc
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR watab.
*  Uebergabestruktur (Typ STPOL_ADD) ...
  watab-tname = 'STPOL_ADD'.
*  ... sichern
  APPEND watab.

*  WATAB initialisieren
  CLEAR watab.

*  Ausgabe festlegen
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
*  Listenueberschrift ausgeben
  PERFORM write_block
     USING 'LISTHDNG          '
*           ausgegebene Zeilen zaehlen
           'x'
*           Hide nicht ausfuehren
           ' '.                                             "YHG123656

*  WATab-Entry (var. Liste) initialisieren
  CLEAR: watab.
*  WATab (var. Liste) leeren
  REFRESH: watab.

*  gesicherte Saetze aus SAV_WATAB
*del LOOP AT SAV_WATAB.                                       "YHG020009
*     wieder nach WATAB ...                                   "YHG020009
*del  WATAB = SAV_WATAB.                                      "YHG020009
*     ... uebernehmen                                         "YHG020009
*del  APPEND WATAB.                                           "YHG020009
*del ENDLOOP.                                                 "YHG020009
  watab[] = sav_watab[].                                    "YHG020009

*  Anzahl Zeilen Listenkopf sichern
  nbr_hdrlns = blclns_cnt.
*  Reset Zeilenzaehler
  CLEAR: blclns_cnt.
ENDFORM.                    "top_01_79_liste


*eject
*---------------------------------------------------------------------*
*        UPOS_BEARBEITUNG                                             *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM upos_bearbeitung.
  CHECK NOT stb-upskz IS INITIAL.

  CLEAR: stpub.
  stpub-stlty = stb-stlty.
  stpub-stlnr = stb-stlnr.
  stpub-stlkn = stb-stlkn.
  stpub-stpoz = stb-stpoz.
  PERFORM stpu_lesen.

  IF sy-subrc = 0 .
    PERFORM mengn_01.

    LOOP AT stpub.
      PERFORM mengn_02.
      PERFORM anzeige_03_79.
    ENDLOOP.
  ENDIF.
ENDFORM.                    "upos_bearbeitung


*eject
*---------------------------------------------------------------------*
*        WRITE_BLOCK                                                  *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM write_block                                            "YHG133914
     USING lcl_blcnm
           lcl_lncnt
           lcl_hidef.                                       "YHG123656

  DATA: first_swt(1) TYPE c.
* ---------------------------------

*d IF sy-ucomm EQ 'CSPR'.                         "HGB020150"note 351902
  IF sv_ucomm EQ 'CSPR'.                                   "note 351902
    READ TABLE prrsv_tb                                     "HGB020150
      WITH KEY lcl_blcnm.                                   "HGB020150

    RESERVE prrsv_tb-maxln LINES.                           "HGB020150
  ENDIF.                                                    "HGB020150

*  Kennzeichen 'erste Zeile ausgeben' setzen
  first_swt = 'x'.

*  bis zum St. Nimmerleinstag
  DO.
*     Zeile ausgeben
    PERFORM write_line
*del     USING 'SAPCSMLVM         '                           "YHG137424
       USING list_id                                        "YHG137424
             act_profil
             lcl_blcnm
             first_swt
             ' '.

*     ?Ist die auszugebende Zeile leer (und sitzt BLANK-LINES OFF!!)
*     nein
    IF lnmpt_flg IS INITIAL.
*        ?sollen die ausgegebenen Zeilen (weiter-) gezaehlt werden
*        ja
      IF NOT lcl_lncnt IS INITIAL.
*           Zeilenzaehler um eins erhoehen
        blclns_cnt = blclns_cnt + 1 .
      ENDIF.

*        ?wird gerade gedruckt
*        nein
*d       IF sy-ucomm NE 'CSPR'.                             "note 351902
      IF sv_ucomm NE 'CSPR'.                             "note 351902
*           gib die Rahmenstriche aus
        WRITE 1 sy-vline.
        WRITE AT siz_linpf sy-vline.

*           ... und - wenn gewuenscht -
        IF NOT lcl_hidef IS INITIAL.                        "YHG123656
*              ... versorge den HIDE-Bereich
          PERFORM hide_routine_01.
        ENDIF.                                              "YHG123656

        IF  lcl_blcnm EQ 'ITEM_M            '            "HGB084505
           AND     mpos_line  IS INITIAL                    "HGB084505
           AND NOT first_swt  IS INITIAL                    "HGB084505
           AND NOT matpos_flg IS INITIAL                    "HGB084505
           AND matcat-matnr   EQ pm_mtnrv.                  "HGB084505

          mpos_page = syst-pagno.                           "HGB084505
          mpos_line = syst-linno - nbr_hdrlns - 2.          "HGB084505

          IF mpos_line < 1.                                 "HGB084505
            mpos_line = 1.                                  "HGB084505
          ENDIF.                                            "HGB084505
        ENDIF.                                              "HGB084505
      ELSE.                                                 "YHG140031
        IF sy-colno = 1.                                    "YHG140031
          SKIP.                                             "YHG140031
        ENDIF.                                              "YHG140031
      ENDIF.
    ENDIF.

*     ?sitzt EndOfBlock-Kennzeichen
*     ja
    IF NOT eoblc IS INITIAL.
*        ... dann Schleife beenden
      EXIT.
    ENDIF.

*     Kennzeichen 'erste Zeile ausgeben' zuruecknehmen
    CLEAR: first_swt.
  ENDDO.
ENDFORM.                    "write_block


*eject
*---------------------------------------------------------------------*
*        WRITE_LINE                                                   *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM write_line                                             "YHG133914
   USING lcl_lstid
         lcl_profl
         lcl_blcnm
         lcl_first
         lcl_nline.

  DATA: val_shift LIKE sy-cucol.


* ---------------------------------
*  ?wenn nicht gedruckt wird, ...
*d IF sy-ucomm NE 'CSPR'.                                   "note 351902
  IF sv_ucomm NE 'CSPR'.                                   "note 351902
*     ... Blockausgabe um eine Stelle nach rechts verschieben
    val_shift = 1 .
*  sonst ...
  ELSE.
*     ... nicht
    CLEAR: val_shift.
  ENDIF.

*  neue Zeile
  NEW-LINE.

*  ?wird gerade gedruckt
*  nein
*d IF sy-ucomm NE 'CSPR'.                                   "note 351902
  IF sv_ucomm NE 'CSPR'.                                   "note 351902
*     Leerzeile in Profillaenge + 2 ausgeben
    WRITE AT 2(sav_prfsz) ecfld.
**  ja, es wird gedruckt
*   ELSE.
**     Hintergrundfarben etc. ausschalten
*      FORMAT RESET.
  ENDIF.

*  Zeile endgueltig ausgeben
  CALL FUNCTION 'CS_VLIST_BLOCK_PROCESSING'
    EXPORTING
      blcnm        = lcl_blcnm
      lstid        = lcl_lstid
      profl        = lcl_profl
      first        = lcl_first
      rshift       = val_shift
      newline      = lcl_nline
    IMPORTING
      eoblc        = eoblc
      lnmpt        = lnmpt_flg
    TABLES
      watab        = watab
    EXCEPTIONS
      call_invalid = 4.
ENDFORM.                    "write_line


*. Here begins ALV section ............................       "HGA246532
FORM alv_dsp_sel_dsp.
*...................................

  DATA:
    sel_fields_tb    TYPE slis_t_fieldcat_alv,
    wa_sel_fields_tb TYPE slis_fieldcat_alv.

  DATA:
    alvlo_sel TYPE slis_layout_alv.
*....................................

  PERFORM alv_dsp_sel_prep.

  PERFORM alv_evnt_tb_prep
    USING
      'B'
      alv_evnt_tb_pfxt.

  wa_sel_fields_tb-fieldname = 'TEXT'.
  wa_sel_fields_tb-outputlen = 30.
  wa_sel_fields_tb-col_pos   = 1.
  APPEND wa_sel_fields_tb TO sel_fields_tb.

  wa_sel_fields_tb-fieldname = 'WERT'.
  wa_sel_fields_tb-outputlen = 32.
  wa_sel_fields_tb-col_pos   = 2.
  APPEND wa_sel_fields_tb TO sel_fields_tb.

  WRITE text-050 TO alvlo_sel-window_titlebar.

  alvvr-handle = '2'.                                         "note 877609



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = report_name
      is_layout               = alvlo_sel
      i_save                  = ' '
      is_variant              = alvvr                              "note 877609
      it_fieldcat             = sel_fields_tb
      it_events               = alv_evnt_tb_pfxt
      i_screen_start_column   = 7
      i_screen_start_line     = 8
      i_screen_end_column     = 71
      i_screen_end_line       = 16
    IMPORTING
      e_exit_caused_by_caller = exit_by_caller
      es_exit_caused_by_user  = exit_by_user
    TABLES
      t_outtab                = dsp_sel
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc = 0.
    IF exit_by_caller = 'X'.
*     Forced Exit by calling program
*     <do_something>.
    ELSE.
*     User left list via F3, F12 or F15
      IF exit_by_user-back = 'X'.       "F3
*       <do_something>.
      ELSE.
        IF exit_by_user-exit = 'X'.     "F15
*         <do_something>.
        ELSE.
          IF exit_by_user-cancel = 'X'. "F12
*           <do_something>.
          ELSE.
*           should not occur!
*           <do_Abnormal_End>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
*   Fatal error callin ALV
*   MESSAGE AXXX(XY) WITH ...
  ENDIF.
ENDFORM. "alv_dsp_sel_dsp


*&---------------------------------------------------------------------*
*&      Form  alv_dsp_sel_prep
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_dsp_sel_prep.
*...................................

  CHECK dsp_sel[] IS INITIAL.

  READ TEXTPOOL sy-repid INTO txt_sel.

  CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
    EXPORTING
      curr_report     = report_name
    TABLES
      selection_table = inp_sel
    EXCEPTIONS
      not_found       = 01
      no_report       = 02.

  LOOP AT inp_sel
    WHERE selname NE 'PM_HEMNG'
      AND selname NE 'PM_DSPCO'
      AND selname NE 'PM_DSPRF'
      AND selname NE 'PM_LTEXT'
      AND selname NE 'PM_PRPRF'
      AND selname NE 'PM_UPSAZ'.

    LOOP AT txt_sel
*d    WHERE id+1 EQ inp_sel-selname.                                 "uc
      WHERE key EQ inp_sel-selname.                                  "uc

*d    ASSIGN (txt_sel-id+1) TO <pm_name>.                            "uc
      ASSIGN (txt_sel-key) TO <pm_name>.                             "uc
      IF NOT <pm_name> IS INITIAL.
*d      dsp_sel-text = txt_sel-text+8.                               "uc
        dsp_sel-text = txt_sel-entry.                                "uc

        dsp_sel-wert = inp_sel-low.

        IF inp_sel-selname EQ 'PM_DATUV'.
          CLEAR:
            dsp_sel-wert.
          WRITE pm_datuv TO dsp_sel-wert.
        ENDIF.

        IF    inp_sel-selname EQ 'PM_EMENG'
          AND NOT pm_emeng IS INITIAL.

          CLEAR:
            dsp_sel-wert.
          WRITE pm_emeng TO dsp_sel-wert DECIMALS 3.

          WHILE dsp_sel-wert(1) EQ space.
            SHIFT dsp_sel-wert LEFT.
          ENDWHILE.
        ENDIF.

        APPEND dsp_sel.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  SORT dsp_sel BY text.

  CHECK NOT ecm_sl[] IS INITIAL.

  REFRESH:
    dsp_sel2.

  CLEAR:
    dsp_sel.
  dsp_sel-text = '_'.
  APPEND dsp_sel.

  dsp_sel-text = text-020.
  APPEND dsp_sel.

  LOOP AT ecm_sl INTO wa_ecm_sl.
    CHECK NOT wa_ecm_sl-value IS INITIAL.
    CHECK NOT wa_ecm_sl-fieldname EQ 'DATE_LO'.

    dsp_sel2-text = wa_ecm_sl-text.

    dsp_sel2-wert = wa_ecm_sl-value.
    APPEND dsp_sel2.
  ENDLOOP.

  APPEND LINES OF dsp_sel2 TO dsp_sel.
ENDFORM. "alv_dsp_sel_prep


*&---------------------------------------------------------------------*
*&      Form  alv_evnt_tb_prep
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->EVENT_SPEC text
*      -->EVENT_TB   text
*----------------------------------------------------------------------*
FORM alv_evnt_tb_prep
  USING
    event_spec TYPE c
    event_tb TYPE slis_t_event.
*..................................

  DATA:
    wa_event_tb TYPE slis_alv_event.
*..................................

  CHECK event_tb[] IS INITIAL.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type = 0
    IMPORTING
      et_events   = event_tb.

  CASE event_spec.
*   complete
    WHEN 'A'.
      READ TABLE event_tb
        WITH KEY name = slis_ev_top_of_page
        INTO wa_event_tb.

      IF sy-subrc = 0.
        wa_event_tb-form = 'ALV_TOP_OF_PAGE'.
        APPEND wa_event_tb TO event_tb.
      ENDIF.


      READ TABLE event_tb
        WITH KEY name = slis_ev_user_command
        INTO wa_event_tb.

      IF sy-subrc = 0.
        wa_event_tb-form = 'ALV_USER_COMMAND'.
        APPEND wa_event_tb TO event_tb.
      ENDIF.


      READ TABLE event_tb
        WITH KEY name = slis_ev_pf_status_set
        INTO wa_event_tb.

      IF sy-subrc = 0.
        wa_event_tb-form = 'ALV_PF_STATUS_SET_MAIN'.
        APPEND wa_event_tb TO event_tb.
      ENDIF.

*   PF EXIT only
    WHEN 'B'.
      READ TABLE event_tb
        WITH KEY name = slis_ev_pf_status_set
        INTO wa_event_tb.

      IF sy-subrc = 0.
        wa_event_tb-form = 'ALV_PF_STATUS_SET_EXIT'.
        APPEND wa_event_tb TO event_tb.
      ENDIF.
  ENDCASE.
ENDFORM. "alv_evnt_tb_prep


*&---------------------------------------------------------------------*
*&      Form  alv_pf_status_set_exit
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM alv_pf_status_set_exit
  USING
    rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'SNN1'
    EXCLUDING rt_extab.
ENDFORM. "alv_pf_status_set_exit


*&---------------------------------------------------------------------*
*&      Form  alv_pf_status_set_main
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM alv_pf_status_set_main
  USING
    rt_extab TYPE slis_t_extab.
*.........................................

  DATA:
    wa_rt_extab LIKE rsmpe-func.
*.........................................
* ex sort
  wa_rt_extab = '&OUP'.
  APPEND wa_rt_extab TO rt_extab.
  wa_rt_extab = '&ODN'.
  APPEND wa_rt_extab TO rt_extab.

*** Enhancement for controlling the enhanced pushbutton
  TRY.
      GET BADI lp_badi.
    CATCH cx_badi_not_implemented .
  ENDTRY.
  TRY.
      CALL BADI lp_badi->control_menu_enhancement
        CHANGING
          ct_extab = rt_extab.
    CATCH cx_badi_initial_reference.
  ENDTRY.
****

  SET PF-STATUS 'S121_ALV'
    EXCLUDING rt_extab.
ENDFORM. "alv_pf_status_set_main


*&---------------------------------------------------------------------*
*&      Form  alv_stb_prep
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_stb_prep.
*..................................
  CLEAR:
    alv_stb,
    stb_orig,
    stb_add.

  stb_orig = stb.

  IF stb-mngko >= max_num.
    stb_add-ovfls = ueberl_kz.
  ELSE.
    IF stb-mngko <= min_num.
      stb_add-ovfls = ueberl_kz.
    ELSE.
      CLEAR: stb_add-ovfls.
    ENDIF.
  ENDIF.

  IF NOT stb-xtlnr IS INITIAL.
    stb_add-bomfl = b_flag.
  ENDIF.

  IF    NOT stb-knobj IS INITIAL
     OR NOT stb-class IS INITIAL
     OR NOT stb-kzclb IS INITIAL.

    stb_add-knofl = 'X'.
  ENDIF.

  CLEAR:
    stb_add-dobjt,
    stb_add-objic.

  CASE stb-objty.
    WHEN otyp_mat.
      WRITE: stb_orig-idnrk TO ecfld.
*     Begin of Note_1553704
*     stb_add-objic = '@A6@'.
      if not stb_orig-hdnfo is initial.
        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
            name                  = ICON_BOM
            info                  = text-074
          IMPORTING
            RESULT                = stb_add-objic
          EXCEPTIONS
            icon_not_found        = 1
            outputfield_too_short = 2
            OTHERS                = 3.
      else.

        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
            name                  = ICON_MATERIAL
            info                  = text-070
          IMPORTING
            RESULT                = stb_add-objic
          EXCEPTIONS
            icon_not_found        = 1
            outputfield_too_short = 2
            OTHERS                = 3.
      endif.
*     End of Note_1553704

    WHEN 'M'.
      WRITE: stb_orig-idnrk TO ecfld.
*     Begin of Note_1553704
*     stb_add-objic = '@A6@'.
      if not stb_orig-hdnfo is initial.
        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
            name                  = ICON_BOM
            info                  = text-074
          IMPORTING
            RESULT                = stb_add-objic
          EXCEPTIONS
            icon_not_found        = 1
            outputfield_too_short = 2
            OTHERS                = 3.
      else.

        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
            name                  = ICON_MATERIAL
            info                  = text-070
          IMPORTING
            RESULT                = stb_add-objic
          EXCEPTIONS
            icon_not_found        = 1
            outputfield_too_short = 2
            OTHERS                = 3.
      endif.
*     End of Note_1553704

    WHEN otyp_noo.
      WRITE: stb_orig-potx1 TO ecfld.
*     Begin of Note_1553704
*     stb_add-objic = '@0Q@'.
      CALL FUNCTION 'ICON_CREATE'
         EXPORTING
            name                  = ICON_CHANGE_TEXT
            info                  = text-073
         IMPORTING
            RESULT                = stb_add-objic
         EXCEPTIONS
            icon_not_found        = 1
            outputfield_too_short = 2
            OTHERS                = 3.
*     End of Note_1553704

    WHEN otyp_doc.
      WRITE stb_orig-doknr TO ecfld.                        "note 489354

      IF ecfld CP '*# '. ENDIF.                             "note 489354
      sy-fdpos = sy-fdpos + 1.                              "note 489354

      CONCATENATE
*d      stb_orig-doknr                                      "note 489354
        stb_orig-dokar
        stb_orig-doktl
        stb_orig-dokvr
*d      INTO ecfld                                          "note 489354
        INTO ecfld+sy-fdpos                                 "note 489354
        SEPARATED BY space.

*     Begin of Note_1553704
*     stb_add-objic = '@AR@'.
      CALL FUNCTION 'ICON_CREATE'
         EXPORTING
            name                  = ICON_DOCUMENT
            info                  = text-071
         IMPORTING
            RESULT                = stb_add-objic
         EXCEPTIONS
            icon_not_found        = 1
            outputfield_too_short = 2
            OTHERS                = 3.
*     End of Note_1553704

    WHEN otyp_kla.
      CONCATENATE
        stb_orig-class
        stb_orig-klart
        INTO ecfld
        SEPARATED BY space.

*     Begin of Note_1553704
*     stb_add-objic = '@7C@'.
      CALL FUNCTION 'ICON_CREATE'
         EXPORTING
            name                  = ICON_OO_CLASS
            info                  = text-072
         IMPORTING
            RESULT                = stb_add-objic
         EXCEPTIONS
            icon_not_found        = 1
            outputfield_too_short = 2
            OTHERS                = 3.
*     End of Note_1553704

    WHEN otyp_ntm.
      WRITE: stb_orig-intrm TO ecfld.

    WHEN OTHERS.
  ENDCASE.

*d CONDENSE ecfld.                                          "note 515408
  stb_add-dobjt = ecfld(40).
  CLEAR: ecfld.

  WRITE stb_orig-stufe TO stb_add-dstuf NO-SIGN.
  PERFORM stufe_aufbereiten.
  WRITE anz_stufe TO stb_add-dglvl NO-SIGN.

*d  MOVE-CORRESPONDING stb_orig TO alv_stb.                 "note 331962
  MOVE-CORRESPONDING stb_add TO alv_stb.
  MOVE-CORRESPONDING stb_orig TO alv_stb.                   "note 331962

* Phantom item adjusted for ALV filtering                   "Note 1327742
  IF NOT alv_stb-dumps IS INITIAL.                          "Note 1327742
    TRANSLATE alv_stb-dumps TO UPPER CASE.  "#EC TRANSLANG  "Note 1327742
  ENDIF.                                                    "Note 1327742

  APPEND alv_stb.
ENDFORM. "alv_stb_prep


*&---------------------------------------------------------------------*
*&      Form  alv_top_of_page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_top_of_page.
*.....................................

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = alv_top_tb.
ENDFORM. "alv_top_of_page


*&---------------------------------------------------------------------*
*&      Form  alv_top_tb_prep
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->TOP_TB     text
*----------------------------------------------------------------------*
FORM alv_top_tb_prep
  USING
    top_tb TYPE slis_t_listheader.
*......................................

  DATA:
    wa_top_tb TYPE slis_listheader.

  DATA:
    lkl_matnr LIKE mara-matnr.                                "note 363714
*ENHANCEMENT-POINT RCS12001_L2 SPOTS ES_RCS12001 STATIC .

*......................................

* CLEAR wa_top_tb.
* wa_top_tb-typ  = 'H'.
* CONCATENATE
*   text-001
*   text-002
*   INTO wa_top_tb-info
*   SEPARATED BY space(1).
* APPEND wa_top_tb TO top_tb.

  CLEAR wa_top_tb.

  IF    NOT pm_vbeln IS INITIAL
    AND pm_pspnr IS INITIAL.

    wa_top_tb-typ  = 'S'.
    ecfld    = text-025.
    ecfld+13 = '/'.
    ecfld+14 = text-026.
    wa_top_tb-key  = ecfld(19).
    CONDENSE wa_top_tb-key.
    CLEAR: ecfld.

    CONCATENATE
      pm_vbeln
      pm_vbpos
      INTO wa_top_tb-info
      SEPARATED BY ' / '.

    APPEND wa_top_tb TO top_tb.
  ENDIF.

  IF    NOT pm_pspnr IS INITIAL
    AND pm_vbeln IS INITIAL.

    wa_top_tb-typ  = 'S'.
    ecfld = text-028.
    ecfld+13 = '/'.
    ecfld+14 = text-029.
    wa_top_tb-key  = ecfld(19).
    CONDENSE wa_top_tb-key NO-GAPS.
    CLEAR: ecfld.

    WRITE pm_pspnr TO wa_top_tb-info.
    wa_top_tb-info+25 = '/'.
*ENHANCEMENT-SECTION RCS12001_L3 SPOTS ES_RCS12001 .
    wa_top_tb-info+27 = pm_mtnrv.
*END-ENHANCEMENT-SECTION.
    CONDENSE wa_top_tb-info.
    APPEND wa_top_tb TO top_tb.
  ENDIF.

  IF wa_top_tb IS INITIAL.
    wa_top_tb-typ  = 'S'.
    ecfld = text-010.
    wa_top_tb-key  = ecfld(11).
    CLEAR: ecfld.
*ENHANCEMENT-SECTION     RCS12001_L1 SPOTS ES_RCS12001.
    WRITE pm_mtnrv TO lkl_matnr.                            "note 363714
*d  wa_top_tb-info = pm_mtnrv.                              "note 363714
    wa_top_tb-info = lkl_matnr.                             "note 363714
*END-ENHANCEMENT-SECTION.
    APPEND wa_top_tb TO top_tb.
  ENDIF.

  CLEAR wa_top_tb.
  wa_top_tb-typ  = 'S'.
  ecfld    = text-005.
  ecfld+5  = '/'.
  ecfld+6  = text-006.
  ecfld+11 = '/'.
  ecfld+12 = text-014.
  wa_top_tb-key  = ecfld(17).
  CONDENSE wa_top_tb-key NO-GAPS.
  CLEAR: ecfld.

  CONCATENATE
    selpool-werks
    selpool-stlan
    selpool-stlal
    INTO wa_top_tb-info
    SEPARATED BY ' / '.
  APPEND wa_top_tb TO top_tb.

  CLEAR wa_top_tb.
  wa_top_tb-typ  = 'S'.
  wa_top_tb-key = text-017.
  CONDENSE wa_top_tb-key.
  wa_top_tb-info = selpool-maktx.
  APPEND wa_top_tb TO top_tb.

*ENHANCEMENT-POINT RCS12001_03 SPOTS ES_RCS12001 .

  CLEAR wa_top_tb.
  wa_top_tb-typ  = 'S'.
  ecfld = text-013.
  ecfld+13 = ' ('.
* ecfld+15 = selpool-bmein.                                 "NOTE_975832
  WRITE selpool-bmein TO ecfld+15(3).                       "NOTE_975832
  ecfld+18 = ')'.
  wa_top_tb-key  = ecfld(19).
  CLEAR: ecfld.

*d wa_top_tb-info = selpool-bmeng.                          "note 317957
  WRITE selpool-bmeng TO wa_top_tb-info .                   "note 317957
  CONDENSE wa_top_tb-info.
  APPEND wa_top_tb TO top_tb.

* ^_NOTE_811372

  CLEAR wa_top_tb.
  wa_top_tb-typ = 'S'.
  ecfld = text-009.
  ecfld+11 = ' ('.
* ecfld+13 = selpool-emgme.                                 "NOTE_975832
  WRITE selpool-emgme TO ecfld+13(3).                       "NOTE_975832
  ecfld+16 = ')'.
  wa_top_tb-key  = ecfld(17).
  CLEAR: ecfld.
  WRITE selpool-emeng TO wa_top_tb-info UNIT selpool-bmein.
  CONDENSE wa_top_tb-info.
  APPEND wa_top_tb TO top_tb.

*v_NOTE_811372

  CLEAR wa_top_tb.
  wa_top_tb-typ  = 'S'.
* so it looks better
  APPEND wa_top_tb TO top_tb.
ENDFORM. "alv_top_tb_prep


*&---------------------------------------------------------------------*
*&      Form  alv_user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_UCOMM    text
*      -->I_SELFIELD text
*----------------------------------------------------------------------*
FORM alv_user_command
  USING i_ucomm LIKE sy-ucomm
    i_selfield TYPE slis_selfield.
*.......................................

  CASE i_ucomm.
    WHEN 'ANMS'.                                            "HGA020150
      LEAVE TO TRANSACTION sy-tcode.                        "HGA020150

    WHEN 'CSAP' OR '&IC1'.
      SORT stb BY index.

      READ TABLE alv_stb INDEX i_selfield-tabindex.
      IF NOT alv_stb-index IS INITIAL.
        READ TABLE stb INDEX alv_stb-index.
        READ TABLE matcat INDEX stb-ttidx.
      ELSE.
        CLEAR:
           stb,
           matcat.
      ENDIF.

      PERFORM position_anzeigen.

    WHEN 'CSAO'.
      SORT stb BY index.

      READ TABLE alv_stb INDEX i_selfield-tabindex.
      IF NOT alv_stb-index IS INITIAL.
        READ TABLE stb INDEX alv_stb-index.
      ELSE.
        CLEAR:
           stb.
      ENDIF.

      PERFORM objekt_anzeigen.

    WHEN 'CSWU'.
      SORT stb BY index.

      READ TABLE alv_stb INDEX i_selfield-tabindex.
      IF NOT alv_stb-index IS INITIAL.
        READ TABLE stb INDEX alv_stb-index.
      ELSE.
        CLEAR:
           stb.
      ENDIF.

      PERFORM verwendung_anzeigen.

    WHEN 'CSSL'.
      PERFORM alv_dsp_sel_dsp.

    WHEN '+ENH1'.

*** getting the input entered on screen
      CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
        EXPORTING
          curr_report     = report_name
        TABLES
          selection_table = lt_sel_tab
        EXCEPTIONS
          not_found       = 1
          no_report       = 2.

*** Enhancement for exporting the screen input
      TRY.
          GET BADI lp_badi.
        CATCH cx_badi_not_implemented .
      ENDTRY.

      TRY.
          CALL BADI lp_badi->get_dynamic_bom_data
            EXPORTING
              it_sel_tab = lt_sel_tab
            IMPORTING
              es_message = ls_message.
          IF ls_message IS NOT INITIAL.
            MESSAGE ID ls_message-msgid TYPE ls_message-msgty NUMBER ls_message-msgno
             WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
          ENDIF.
        CATCH cx_badi_initial_reference.
      ENDTRY.

  ENDCASE.

*ENHANCEMENT-POINT RCS12001_04 SPOTS ES_RCS12001 .

ENDFORM. "alv_user_command


*&---------------------------------------------------------------------*
*&      Form  cs12_alv
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM cs12_alv.
*...................................

DATA: ls_exclude TYPE slis_extab,
      lt_exclude  TYPE SLIS_T_EXTAB.

  LOOP AT stb.
    stb-index = sy-tabix.
    MODIFY stb.

    PERFORM alv_stb_prep.
  ENDLOOP.

  PERFORM stb_fields_tb_prep.

*ENHANCEMENT-POINT RCS12001_05 SPOTS ES_RCS12001 .
  alvlo_stb-info_fieldname = 'INFO'.

  alvvr-handle = '1'.                                         "note 877609

 EXPORT alv_stb[] TO MEMORY ID 'ALV_STB'.              """""""""exported to zbom_cs12 report
WAIT UP TO 2 SECONDS.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = report_name
      i_structure_name        = 'STPOX_ALV'
      is_layout               = alvlo_stb
      i_save                  = alvvr_sav_all
      is_variant              = alvvr
      it_events               = alv_evnt_tb_cmpl
      it_fieldcat             = stb_fields_tb
      it_excluding            = lt_exclude
    IMPORTING
      e_exit_caused_by_caller = exit_by_caller
      es_exit_caused_by_user  = exit_by_user
    TABLES
      t_outtab                = alv_stb
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc = 0.
    IF exit_by_caller = 'X'.
*     Forced Exit by calling program
*     <do_something>.
    ELSE.
*     User left list via F3, F12 or F15
      IF exit_by_user-back = 'X'.       "F3
*       <do_something>.
      ELSE.
        IF exit_by_user-exit = 'X'.     "F15
*         <do_something>.
        ELSE.
          IF exit_by_user-cancel = 'X'. "F12
*           <do_something>.
          ELSE.
*           should not occur!
*           <do_Abnormal_End>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
*   Fatal error callin ALV
*   MESSAGE AXXX(XY) WITH ...
  ENDIF.

  IF sy-subrc <> 0.
    MESSAGE s513 WITH 'E: '.
    EXIT.
  ENDIF.
ENDFORM.                                                    "cs13_alv


*&---------------------------------------------------------------------*
*&      Form  stb_fields_tb_prep
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM stb_fields_tb_prep.
*.....................................

*dCALL FUNCTION 'GET_FIELDTAB'                                "uc 070302
*d  EXPORTING                                                 "uc 070302
*d    langu    = sy-langu                                     "uc 070302
*d    tabname  = 'STPOX_ALV'                                  "uc 070302
*d    withtext = ' '                                          "uc 070302
*d    only     = 'T'                                          "uc 070302
*d  TABLES                                                    "uc 070302
*d    fieldtab = ftab                                         "uc 070302
*d  EXCEPTIONS                                                "uc 070302
*d    OTHERS   = 1.                                           "uc 070302

  CALL FUNCTION 'DDIF_FIELDINFO_GET'                        "uc 070302
    EXPORTING                                               "uc 070302
      langu                = sy-langu                       "uc 070302
      tabname              = 'STPOX_ALV'                    "uc 070302
*     UCLEN                = '01'                             "uc 070302
    TABLES                                                  "uc 070302
      dfies_tab            = ftab                           "uc 070302
    EXCEPTIONS                                              "uc 070302
      OTHERS               = 1.                             "uc 070302

  LOOP AT ftab.
    CLEAR: wa_stb_fields_tb.

    CASE ftab-fieldname.
      WHEN 'DGLVL'.
        wa_stb_fields_tb-fieldname = 'DGLVL'.
        wa_stb_fields_tb-col_pos   =  1.
        wa_stb_fields_tb-fix_column = 'X' .
        wa_stb_fields_tb-outputlen = 11.
        wa_stb_fields_tb-just      = 'L' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'POSNR'.
        wa_stb_fields_tb-fieldname = 'POSNR'.
        wa_stb_fields_tb-col_pos   =  2.
        wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 4 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'OBJIC'.
        wa_stb_fields_tb-fieldname = 'OBJIC'.
        wa_stb_fields_tb-col_pos   =  3.
        wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 3 .
        wa_stb_fields_tb-icon       =  'X' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'DOBJT'.
        wa_stb_fields_tb-fieldname = 'DOBJT'.
        wa_stb_fields_tb-col_pos   =  4.
        wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 23 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'OJTXP'.
        wa_stb_fields_tb-fieldname = 'OJTXP'.
        wa_stb_fields_tb-col_pos   =  5.
        wa_stb_fields_tb-outputlen = 19.
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'OVFLS'.
        wa_stb_fields_tb-fieldname = 'OVFLS'.
        wa_stb_fields_tb-col_pos   = 6.
        wa_stb_fields_tb-outputlen = 3 .
        wa_stb_fields_tb-just      = 'R' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'MNGKO'.
        wa_stb_fields_tb-fieldname = 'MNGKO'.
        wa_stb_fields_tb-col_pos   = 7.
        wa_stb_fields_tb-outputlen = 18.
        wa_stb_fields_tb-no_sum    = 'X'.
        wa_stb_fields_tb-no_zero   = 'X'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'MEINS'.
        wa_stb_fields_tb-fieldname = 'MEINS'.
        wa_stb_fields_tb-col_pos   = 8.
        wa_stb_fields_tb-outputlen = 3 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'POSTP'.
        wa_stb_fields_tb-fieldname = 'POSTP'.
        wa_stb_fields_tb-col_pos   = 9.
        wa_stb_fields_tb-outputlen = 3 .
        wa_stb_fields_tb-just      = 'C' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'AUSNM'.
        wa_stb_fields_tb-fieldname = 'AUSNM'.
        wa_stb_fields_tb-col_pos   = 10.
        wa_stb_fields_tb-outputlen = 5 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'SGT_RCAT'.
        wa_stb_fields_tb-fieldname = 'SGT_RCAT'.  "requirement segment
        wa_stb_fields_tb-col_pos   = 11.
        wa_stb_fields_tb-outputlen = 16 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'SGT_SCAT'.
        wa_stb_fields_tb-fieldname = 'SGT_SCAT'.       "stock segment
        wa_stb_fields_tb-col_pos   = 12.
        wa_stb_fields_tb-outputlen = 16 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

       WHEN 'VERPR'.
        wa_stb_fields_tb-fieldname = 'VERPR'.       "stock segment
        wa_stb_fields_tb-col_pos   = 12.
        wa_stb_fields_tb-outputlen = 40 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN OTHERS.
        wa_stb_fields_tb-fieldname = ftab-fieldname.
        wa_stb_fields_tb-no_out    = 'X'.
        wa_stb_fields_tb-no_sum    = 'X'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.

    ENDCASE.
  ENDLOOP.
*ENHANCEMENT-POINT RCS12001_08 SPOTS ES_RCS12001 .

ENDFORM. "stb_fields_tb_prep
*. Here ends ALV section ..............................       "HGA246532
*eject
*---------------------------------------------------------------------*
*                                                                     *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
