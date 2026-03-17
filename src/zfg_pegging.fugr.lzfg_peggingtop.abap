FUNCTION-POOL ZFG_PEGGING.                  "MESSAGE-ID ..

* INCLUDE LZFG_PEGGINGD...                   " Local class definition

CONSTANTS: gc_true  TYPE bool VALUE 'X',
           gc_false TYPE bool VALUE space.

*----------------------------------------------------------------------*
*  Datanbanktebellen                                                   *
*----------------------------------------------------------------------*
TABLES: plaf,         "Planaufträge
        mdfa,         "View auf Fertigungsaufträge
        afih,         "Instandhaltungsauftraege
        eban,         "Bestellanforderungen
        mdbs,         "View auf Bestellungen
        mdrs,         "View zum Lesen Sekundärbedarf
        vbep,         "KundenAuftragseinteilungen
        mdua,         "Bedarfe fuer TB-Banfen
        mdub,         "Bedarfe fuer TB-Bestellungen
        mdsm,         "Simulationsbedarfe
        mdup,         "Transportabrufe aus Simulationsauftraegen
        mdri,         "Summensekundaerbedarfe
        rqhd,         "Summenbedarfs-Kopfsaetze
        plsc.         "Planungsszenarien


*----------------------------------------------------------------------*
*  ATAB-Tabellen                                                       *
*----------------------------------------------------------------------*
TABLES: t001w,        "Werkstabelle (Fabrikkalender)
        t000md,       "Wird mit Dispobereichen gearbeitet
        t100,         "Fehlermeldungen
        t399d,        "Dispoparameter
        t457t,        "Texte zu Dispo-Elementen
        t460a.        "Sonderbeschaffungsschlüssel


*----------------------------------------------------------------------*
*   MDPSX                                                              *
*                                                                      *
*   Daten für das Lesen von Dispo-Elementen über die Funktionsbausteine*
*        'AUFBAUEN_MDPSX_ANZEIGE'                                      *
*----------------------------------------------------------------------*
TABLES:  mt61d,       "View Materialstamm
         cm61x,       "Steuerkennzeichen Bedarfsplanung
         cm61w.       "Steuerkennzeichen Werk
*----------------------------------------------------------------------*
*  ENTRY_ELEMENT                                                       *
*                                                                      *
*  Ist das Dispoelement, mit dem der Einstieg erfolgt ist, ein Zugang  *
*  oder Abgang ?  Dies wird in GL_ENTRY_ELEMENT gemerkt.               *
*----------------------------------------------------------------------*
TYPES: entry_element(1) TYPE c.
DATA:  el_receipt      TYPE entry_element VALUE 'I',
       el_requirement  TYPE entry_element VALUE 'O',
       el_directprocur TYPE entry_element VALUE 'D'.

*----------------------------------------------------------------------*
*  Globale Variable                                                    *
*----------------------------------------------------------------------*
DATA: gl_dsp_no_matnr_but_maktx       TYPE bool,
      gl_dsp_screenwidth              TYPE i,
      gl_dsp_matwidth                 TYPE i,
      gl_dsp_same_mat                 TYPE bool,
      gl_entry_element                TYPE entry_element,
      gl_entry_meins                  LIKE mt61d-meins,
      gl_graph_with_dep_rqmts         TYPE bool,
      gl_display_only                 TYPE bool,
      gl_read_database                TYPE bool,
      gv_mrparea                      TYPE bool,
      gl_alloc                        TYPE bool VALUE 'X'.

CONSTANTS:
      barez(2) TYPE c VALUE 'BR',      "Prozeßauftrag
      neauf(2) TYPE c VALUE 'NE',      "Netzauftrag
      ihauf(2) TYPE c VALUE 'IH',      "Instandhaltungsauftrag   SA 46a
      bsanf(2) TYPE c VALUE 'BA',      "Bestellanforderung
      bsein(2) TYPE c VALUE 'BE',      "Bestelleinteilung
* neu 46 af
      lplab(2) TYPE c VALUE 'LL',      "Abrufeinteilung LAB
      lpfab(2) TYPE c VALUE 'LF',      "Abrufeinteilung FAB
      lpein(2) TYPE c VALUE 'LE',      "Lieferplaneintelung
      lavis(2) TYPE c VALUE 'LA',      "LieferAVIS
      umres(2) TYPE c VALUE 'UR',      "Uml.reservierung LO gl. Werk
      ulres(2) TYPE c VALUE 'UL',      "Uml.reservierung zw. Werken
                                       "-- BEDARFE --
      trbed(2) TYPE c VALUE 'TB',      "Transportbedarf LVS
      skbed(2) TYPE c VALUE 'SB',      "Sekundaerbedarf
      smbed(2) TYPE c VALUE 'SM',      "Simulationsbedarf
      subed(2) TYPE c VALUE 'SU',      "Summenbedarf
      brbed(2) TYPE c VALUE 'BB',      "Bereitstellungsbedarf
      unbed(2) TYPE c VALUE 'UB',      "Ungepl. Bedarf
      prbed(2) TYPE c VALUE 'PR',      "Prognosebedarf
      uxabr(2) TYPE c VALUE 'U0',      "Abruf UL-Best. aus Lief ATPcheck
      ubabr(2) TYPE c VALUE 'U1',      "Abruf UL-Bestellung
      uaabr(2) TYPE c VALUE 'U2',      "Abruf UL-Anforderung
      upabr(2) TYPE c VALUE 'U3',      "Abruf UL-SimAuftrag
      ulabr(2) TYPE c VALUE 'U4',      "Abruf UL-Lieferplan
      ppbed(2) TYPE c VALUE 'PP',      "Planprimaerbedarf
      kdbed(2) TYPE c VALUE 'KD',      "Kundenprimaerbedarf (nicht verw)
      mrbed(2) TYPE c VALUE 'MR',      "Reservierung
      arbed(2) TYPE c VALUE 'AR',      "Abhaengige Reservierung
      vbeda(2) TYPE c VALUE 'VA',      "Anfrage
      vbedb(2) TYPE c VALUE 'VB',      "Angebot
      vbedc(2) TYPE c VALUE 'VC',      "Auftrag
      vbede(2) TYPE c VALUE 'VE',      "SD-Lieferplan
      vbedf(2) TYPE c VALUE 'VF',      "SD-Lieferpl. ext. Dienstleister
      vbedh(2) TYPE c VALUE 'VH',      "SD-Retoure
      vbedg(2) TYPE c VALUE 'VG',      "Kontrakt
      vbedi(2) TYPE c VALUE 'VI',      "Kostenlose Lieferung
      vbedj(2) TYPE c VALUE 'VJ',      "Lieferung
      vbedz(2) TYPE c VALUE 'VZ',      "ungeprüfte Lieferung   -AIP-
      vbedw(2) TYPE c VALUE 'VW',      "externer Kundenauftrag
      vbedt(2) TYPE c VALUE 'VT',      "Retourenlieferung nur Verf.Pr.
      sibed(2) TYPE c VALUE 'SI',      "Simulationsbedarf
      si2bd(2) TYPE c VALUE 'S2',      "Simulationsbedarf aus Verfpr.
      matbw(2) TYPE c VALUE 'MB',      "Lagerabgang

      vorpl(2) TYPE c VALUE 'VP',      "Vorplanung
      brtpl(2) TYPE c VALUE 'BP',      "Bruttoplanung
      mstfr(2) TYPE c VALUE 'MS',      "Mehrstufige Fertigung
      fxhor(2) TYPE c VALUE 'FH',      "Ende Fixierungshorizont
      wzhor(2) TYPE c VALUE 'WH',      "Ende Wiederbesch.Horizont
      ausdt(2) TYPE c VALUE 'DD',      "Auslaufdatum
      lbein(2) TYPE c VALUE 'E1',      "Lohnbearbeitung Einkauf
      tblvs(2) TYPE c VALUE 'TB',      "Transportbedarf LVS
      prabr(2) TYPE c VALUE 'JI',      "Produktionsabruf
*@003-Begin
      retpo(2) TYPE c VALUE 'RP',      "Retourenposition
*@003-End
      kmbed(2) TYPE c VALUE 'KM',      "Kummulierte Bedarfe (Memory)
      sfbed(2) TYPE c VALUE 'SF',      "Sicherheitsbedarf      pb300697
      rnivd(2) TYPE c VALUE 'RD',      "RsNum invalid in DB
      rnivs(2) TYPE c VALUE 'RS',      "RsNum invalid in Sperrserver
      eorlt(2) TYPE c VALUE 'ER',      "Ende Wiederbeschaffungszeit
      grreq(2) TYPE c VALUE 'GR'.      "Temporärer Bedarf (ATP intern)

*--> Kennzeichen Dispositionselemente
CONSTANTS:
                                       "-- BESTAENDE --
      wkbst(2) TYPE c VALUE 'WB',      "Werksbestand
      shbst(2) TYPE c VALUE 'SH',      "Sicherheitsbestand   new SA_46a
      lgbst(2) TYPE c VALUE 'LB',      "Lagerortbestand
      kdbst(2) TYPE c VALUE 'KB',      "Kundeneinzelbestand
      prbst(2) TYPE c VALUE 'PB',      "Projekteinzelbestand
      lbbst(2) TYPE c VALUE 'LK',      "Beistellbestand Lohnbearb.
                                       "-
      chbst(2) TYPE c VALUE 'CH',      "Chargenbestand
      lcbst(2) TYPE c VALUE 'LC',      "Lager/Chargenbestand
      kkbst(2) TYPE c VALUE 'KK',      "Kundenkonsi (ATP)

      hsbst(2) TYPE c VALUE 'HS',      "SegmentBatchStock
      lsbst(2) TYPE c VALUE 'LS',      "SegmentSLocStock
      csbsts(2) TYPE c VALUE 'CS',      "SegmentBatchSLoc
      wsbst(2) TYPE c VALUE 'WS',      "SegmentStock

                                       "-- ZUGAENGE --
      qmlos(2) TYPE c VALUE 'QM',      "QM-Prüflos
      plauf(2) TYPE c VALUE 'PA',      "Planauftrag
      saauf(2) TYPE c VALUE 'SA',      "Simulationsauftrag
      feauf(2) TYPE c VALUE 'FE'.      "Fertigungsauftrag

CONSTANTS:
      stern(1) TYPE c VALUE '*',
      punkt(1) TYPE c VALUE '.',
      xflag(1) TYPE c VALUE 'X',
      char0(1) TYPE c VALUE '0',
      char1(1) TYPE c VALUE '1',
      char2(1) TYPE c VALUE '2',
      char3(1) TYPE c VALUE '3',
      char4(1) TYPE c VALUE '4',
      char5(1) TYPE c VALUE '5',
      char6(1) TYPE c VALUE '6',
      char7(1) TYPE c VALUE '7',
      char8(1) TYPE c VALUE '8',
      char9(1) TYPE c VALUE '9',
      chara(1) TYPE c VALUE 'A',
      charb(1) TYPE c VALUE 'B',
      charc(1) TYPE c VALUE 'C',
      chard(1) TYPE c VALUE 'D',
      chare(1) TYPE c VALUE 'E',
      charf(1) TYPE c VALUE 'F',
      charg(1) TYPE c VALUE 'G',
      charh(1) TYPE c VALUE 'H',
      chari(1) TYPE c VALUE 'I',
      charj(1) TYPE c VALUE 'J',
      chark(1) TYPE c VALUE 'K',
      charl(1) TYPE c VALUE 'L',
      charm(1) TYPE c VALUE 'M',
      charn(1) TYPE c VALUE 'N',
      charo(1) TYPE c VALUE 'O',
      charp(1) TYPE c VALUE 'P',
      charq(1) TYPE c VALUE 'Q',
      charr(1) TYPE c VALUE 'R',
      chars(1) TYPE c VALUE 'S',
      chart(1) TYPE c VALUE 'T',
      charu(1) TYPE c VALUE 'U',
      charv(1) TYPE c VALUE 'V',
      charw(1) TYPE c VALUE 'W',
      charx(1) TYPE c VALUE 'X',
      chary(1) TYPE c VALUE 'Y',
      charz(1) TYPE c VALUE 'Z'.

*---> Soll-/Haben-Kennzeichen
CONSTANTS:
      shkzgh(1) TYPE c VALUE 'H',      "Haben
      shkzgs(1) TYPE c VALUE 'S'.      "Soll

*--> Kennzeichen Planungsabschnitt
CONSTANTS:
      netpla(2)  TYPE n VALUE '02',    "Nettoplanung
      brtpla(2)  TYPE n VALUE '04',    "Bruttoplanung
      lgods1(2)  TYPE n VALUE '06',    "Lagerdisposition-1
      lgods2(2)  TYPE n VALUE '07',    "Lager von Dispo ausgeschlossen
      kndpla(2)  TYPE n VALUE '20',    "Kundeneinzel
      propla(2)  TYPE n VALUE '22',    "Projekteinzel
      mstpla(2)  TYPE n VALUE '24',    "Direktfertigung
      lobpla(2)  TYPE n VALUE '26',    "Beistellung fuer Lohnbearb.
      vorpla(2)  TYPE n VALUE '30',    "Vorplanung o. Montage
      vmspla(2)  TYPE n VALUE '32',    "Vorplanung Direktfert.
      lagerpr(2) TYPE n VALUE '50',    "Lagerabschnitt    Verf.pr.
      chargpr(2) TYPE n VALUE '52',    "Chargenabschnitt  Verf.pr.
      chalgpr(2) TYPE n VALUE '54',    "ChargenLGOrtAbsch.Verf.pr.
      kundkon(2) TYPE n VALUE '56',    "Kundenkonsi       Verf.pr.
      kkcharg(2) TYPE n VALUE '58'.    "Kundenkonsi & Charge

DATA: savety_stock(2) TYPE c VALUE '1S',
      transp_rqmt(2)  TYPE c VALUE '1T',
*     PM_ORDER(2)     TYPE C VALUE '1P'.             "note 158866
      pm_order(2)     TYPE c VALUE 'IH'.             "note 158866

* Kennzeichen gleichen Verursacher für Ursprungsaufträge
DATA: hit_u TYPE bool VALUE space.

*---> Art der Planungsaktivitaeten  (Festwerte fuer T450N-MDATY)
CONSTANTS:
      mrppl(2) TYPE c VALUE 'B1',      "MRP-Planung
      mrpmp(2) TYPE c VALUE 'B2',      "MRP-Planung -mehrstufig-
      mrpep(2) TYPE c VALUE 'B3',      "MRP-Planung -einstufig-
      anzbs(2) TYPE c VALUE 'B4',      "Bestands-/Bedarfssituation
      anzdl(2) TYPE c VALUE 'B5',      "Disp.liste -Einzelliste-
      anzds(2) TYPE c VALUE 'B6',      "Disp.liste -Sammelanzeige-
      anzml(2) TYPE c VALUE 'B7',      "akt. BBL   -Sammelanzeige
      anzpt(2) TYPE c VALUE 'SP',      "Planungstableau- nach Ausnahmen
      anzrm(2) TYPE c VALUE 'RM',      "Planungstableau- Sammelanzeige
      mpspl(2) TYPE c VALUE 'M1',      "MPS-Planung
      mpsmp(2) TYPE c VALUE 'M2',      "MPS-Planung -mehrstufig-
      mpsep(2) TYPE c VALUE 'M3',      "MPS-Planung -einstufig-
      mpskd(2) TYPE c VALUE 'M4',      "MPS-Planung -Kundenauftrag-
      mpspr(2) TYPE c VALUE 'M5',      "MPS-Planung -Projekt-
      mpsip(2) TYPE c VALUE 'I1',      "MPS-Planung -interaktiv-
      mpsaw(2) TYPE c VALUE 'AW',      "MPS- werksübergr. Auswertung
      mpsla(2) TYPE C VALUE 'LA',      "MPS-Long-Term-Pl.  (note 750373)
      ordaz(2) TYPE c VALUE 'OR',      "Order Report -total-
      ordkd(2) TYPE c VALUE 'OK',      "Order Report -Kundenauftrag-
      ordpr(2) TYPE c VALUE 'OP',      "Order Report -Projekt-
      loraz(2) TYPE c VALUE 'LO',      "Order Report LTP -total-
      lorkd(2) TYPE c VALUE 'LC',      "Order Report LTP -Kundenauftrag-
      lorpr(2) TYPE c VALUE 'LP',      "Order Report LTP -Projekt-
      lfrpl(2) TYPE c VALUE 'L1',      "LFR-Planung
      lfrmp(2) TYPE c VALUE 'L2',      "LFR-Planung -mehrstufig-
      lfrep(2) TYPE c VALUE 'L3',      "LFR-Planung -einstufig-
      lfraz(2) TYPE c VALUE 'L4',      "Anzeigen LFR-Planung - BBL
      lfrdl(2) TYPE c VALUE 'L5',      "LFR-Planung - Disp.liste einzel
      lfrds(2) TYPE c VALUE 'L6',      "LFR-Planung - Disp.liste Sammel
      lfrml(2) TYPE c VALUE 'L7',      "LFR-Planung - Materialübersicht
      lfrkd(2) TYPE c VALUE 'LJ',      "LFR-Planung - Kundenauftrag
      lfrpr(2) TYPE c VALUE 'LK',      "LFR-Planung - Projekt
      lfrkp(2) TYPE c VALUE 'LF',      "LFR-Planung - fix. Plafs kop.
      mtpv0(2) TYPE c VALUE 'V0',      "MatPlanungsvormerkung anlegen
      mtpv1(2) TYPE c VALUE 'V1',      "MatPlanungsvormerkung anzeigen
      mtpw0(2) TYPE c VALUE 'W0',      "MDVL anlegen
      mtpw1(2) TYPE c VALUE 'W1',      "MDVL anzeigen
      verpr(2) TYPE c VALUE 'X1',      "Verfuegbarkeitsprüfung
      peggo(2) TYPE c VALUE 'P1',      "Pegging operativ
*--> Verrechnung nutzt alten Stand
      reduc(2) TYPE c VALUE '01',      "Reduction Primaerbedarf PBATP01
      reduc_sd(2) TYPE c VALUE '02',   "Reduction Primaerbed SD PBATP01
      alloca(2) TYPE c VALUE '03',     "Reduction Primaerbed SD PBATP01
      alloca_sd(2) TYPE c VALUE '04',  "Reduction Primaerbed SD PBATP01
      abbau(2) TYPE c VALUE 'R',       "Reduction Primaerbedarf
      alloc(2) TYPE c VALUE 'D',       "Zuordnen Primaerbedarf
      simul(2) TYPE c VALUE 'S',       "Simulation Allocation     ??
      fehlt(2) TYPE c VALUE 'X4',      "Fehlteilepruefung
      raufl(2) TYPE c VALUE 'X5',      "Rueckstandsauflösung
      shplo(2) TYPE c VALUE 'X6',      "Sammelanzeige Planaufträge
      rauma(2) TYPE c VALUE 'X7',      "Rueckstandsauflösung Montage
* see CL_MRP_COCKPIT_DATA_PROVIDER  IF_MRP_COCKPIT_DATA_PROVIDER~GET_BASIC_LIST
      mrpapps(2) TYPE c VALUE 'MA'.    "MRP Apps

*---> MDAKT Objekte laut T450N (Kennzeichnen z.B. Art des Sperrobjekts)
CONSTANTS:
      mdobjb(1) TYPE c VALUE 'B',      "MRP-Planung
      mdobjm(1) TYPE c VALUE 'M',      "MPS-Planung
      mdobjl(1) TYPE c VALUE 'L',      "LFR-Planung ( auch MDVL )
      mdobjr(1) TYPE c VALUE 'R',      "Kanbanregelkreis
      mdobjv(1) TYPE c VALUE 'V',      "Planungsvormerkungen MDVM
      mdobjx(1) TYPE c VALUE 'X',      "Sonstige
      mdobjp(1) TYPE c VALUE 'P',      "Prognose (fuer Sperrobjekt)
* see CL_MRP_COCKPIT_DATA_PROVIDER  IF_MRP_COCKPIT_DATA_PROVIDER~GET_BASIC_LIST
      mdobja(1) TYPE c VALUE 'A'.      "MRP Apps

*---> Zugangs/Abgangskennzeichen
CONSTANTS:
      plusx(1)  TYPE c VALUE '+',      "Plus
      minus(1)  TYPE c VALUE '-',      "Minus
      bestx(1)  TYPE c VALUE 'B'.      "Bestand

*---> Beschaffungs-/Sonderbeschaffungsarten/Eigen
CONSTANTS:
      beskze    TYPE c VALUE 'E'.      "Eigenfertigung
CONSTANTS:
      sobese    TYPE c VALUE 'E',      "Eigenfertigung
      sobesp    TYPE c VALUE 'P',      "Produktions  im 2. Werk
      sobesr    TYPE c VALUE 'R',      "Reservierung im 2. Werk
      sobesv    TYPE c VALUE 'V',      "Vorplanung
      sobesd    TYPE c VALUE 'D',      "Dummy-Baugruppe
      sobes9    TYPE c VALUE '9', "IS-OIL KH Werksumlager.-Reserv.
      sobesm    TYPE c VALUE 'M'.      "Mehrstufig


*--> Kennzeichen Dispositionselemente
CONSTANTS:
  "{ Begin ENHO /SAPMP/ORDCOMB_PP_MM61XVAL IS-MP-PP /SAPMP/ORDER_COMBINATION }
  omauf(2)  TYPE c VALUE 'OM',      " AZF zusammengefaßter Auftrag
  mpauf(2)  TYPE c VALUE 'MP'.      " AZF zusammengef. Prozeßauftr

*---> Auftragstypen
CONSTANTS:
      aftypf(2) TYPE c VALUE '10',     "Fertigungsauftrag
      aftypn(2) TYPE c VALUE '20',     "Netzauftrag
      aftypb(2) TYPE c VALUE '40',     "Prozeßauftrag
      aftypi(2) TYPE c VALUE '30',     "Instandhaltungsauftrag  SA 46a
      aftypr(2) TYPE c VALUE '32',     "RMA-Auftrag (Serviceauftr)SA 46A
      aftypc(2) TYPE c VALUE '04',     "CO-Kostensammler
      aftypp(2) TYPE c VALUE '05',     "Periodenauftrag
      aftypq(2) TYPE c VALUE '06'.     "QM-Auftrag

CONSTANTS:
      BEGIN OF sstck,
        zero      VALUE ' ',
        safety    VALUE '1',
        actual    VALUE '2',
        simulated VALUE '3',
      END OF sstck.

DATA: GV_MAXLEV  TYPE I VALUE '1999'.

* Tabelle um doppelten Eintrag in Mdrqx zu löschen
DATA: BEGIN OF ct_mdrqx_u OCCURS 50.
    INCLUDE STRUCTURE mdrq.
DATA: rsnum LIKE mdzu-delnr,
      rspos LIKE mdzu-delps,
      rsein LIKE mdzu-delet,
      aufnr LIKE mdzu-delnr,
      END OF ct_mdrqx_u.

DATA: BEGIN OF mdpsx OCCURS 500.
        INCLUDE STRUCTURE mdps.
DATA: END OF mdpsx.

*----------------------------------------------------------------------*
*   MDZUX                                                              *
*                                                                      *
*   Tabelle der Zugänge                                                *
*----------------------------------------------------------------------*
DATA: BEGIN OF mdzux OCCURS 500.
        INCLUDE STRUCTURE mdzu.
DATA: END OF mdzux.

*----------------------------------------------------------------------*
*   MDBOM                                                              *
*                                                                      *
*   Interne Tabelle mit übergordneten Materialien                      *
*----------------------------------------------------------------------*
DATA: BEGIN OF mdbom OCCURS 50,
        this_matnr   LIKE mt61d-matnr,
        this_werks   LIKE mt61d-werks,
        this_berid   LIKE mt61d-berid,
        next_matnr   LIKE mt61d-matnr,
        next_werks   LIKE mt61d-werks,
        next_berid   LIKE mt61d-berid,
        level        TYPE i,
        index        TYPE i,
        lines        TYPE i,
        used         TYPE bool.
DATA: END OF mdbom.


*----------------------------------------------------------------------*
*  MDSBX                                                               *
*                                                                      *
*  Tabelle mit den Sekundärbedarfen/Reservierungen und den dazu        *
*  gehörigen verursachenden Planaufträgen und Fertigungsaufträgen      *
*----------------------------------------------------------------------*
DATA: BEGIN OF mdsbx OCCURS 600,
        rsnum  LIKE mdps-del12,     "Nummer Reservierung/Sekundärbedarf
        rspos  LIKE mdps-delps,
        rsein  LIKE mdps-delet,
        matnr  LIKE mt61d-matnr,    "DIESES Material
        werks  LIKE mt61d-werks,    "DIESES Werk
        berid  LIKE mt61d-berid,    "DIESER Dispobereich
        baugr  LIKE mt61d-matnr,    "UEBERGEORDNETES Material
        werk2  LIKE mt61d-werks,    "UEBERGEORDNETES Werk
        berid2 LIKE mt61d-berid,    "UEBERGEORDNETER Dispobereich
        delnr  LIKE mdps-del12,     "Nummer Pauf/Fauf
        delps  LIKE mdps-delps,
        delet  LIKE mdps-delet,
        delkz  LIKE mdps-delkz,     "Pauf/Fauf
        rekur  TYPE bool.           "Kennzeichen Rekursivitaet
DATA: END OF mdsbx.

"{ Begin ENHO /SAPMP/ORDCOMB_PP_SAPLM61B IS-MP-PP /SAPMP/ORDER_COMBINATION }
* Tabelle um Ursprungsaufträge für Auftragzusammenfassung zu merken
* mill 0001 jw 000724

DATA: BEGIN OF ct_mdzux_u OCCURS   500,
        delnr LIKE mdzu-delnr,
        delps LIKE mdzu-delps,
        delet LIKE mdzu-delet,
        delkz LIKE mdzu-delkz,
        matnr LIKE mdzu-matnr,
        werks LIKE mdzu-werks,
        berid LIKE mdzu-berid,
        plaab LIKE mdzu-plaab,
        planr LIKE mdzu-planr,
        dat00 LIKE mdzu-dat00,
        baart LIKE mdzu-baart,
        versb LIKE mdzu-versb,
        mng01 LIKE mdzu-mng01,
        mng02 LIKE mdzu-mng02,
        index LIKE mdzu-index,
        alloc LIKE mdzu-alloc,
        extra LIKE mdzu-extra,
        level TYPE i,
        aufnr LIKE afpo-aufnr,
        posnr LIKE afpo-posnr,
        rsnum LIKE mdzu-delnr,
        rspos LIKE mdzu-delps,
        rsein LIKE mdzu-delet,
      END OF ct_mdzux_u.

"{ Begin ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
*--> PIC global data for MPN/SUS handling                           "4.6
DATA: gv_pic_lmatn  LIKE mara-matnr,  "LPart of Set/Chain
*      gv_pic_picid  LIKE cm61m-picid, "picid of initial part
      gv_pic_picid(2) VALUE '', "picid of initial part
      gv_pic_savmat TYPE matnr,       "initial part
      gt_pic_parts  TYPE pictb201.    "table with Set/chain  parts

*----------------------------------------------------------------------*
*  MDABX                                                               *
*                                                                      *
*  Tabelle der Bedarfe/Abgänge                                         *
*  MDZUX-INDEX verweist auf einen Eintrag dieser Tabelle.              *
*                                                                      *
*  MDABX-DELKZ   Kennzeichen DispoElement des zugehörigen Bedarfs      *
*  MDABX-DAT00   Datum des zugehörigen Bedarfselements                 *
*  MDABX-DELNR   Nummer des zugehörigen Bedarfselements                *
*  MDABX-MNG01   Originalmenge des Bedarfes                            *
*  MDABX-INDEX   weiteres Bedarfselement bei Bedarfszusammenfassung    *
*  MDABX-MNG02   Einem bestimmten Auftrag zugeordnete Menge            *
*----------------------------------------------------------------------*
DATA: BEGIN OF mdabx OCCURS 1000.
        INCLUDE STRUCTURE mdzu.
DATA: END OF mdabx.

*----------------------------------------------------------------------*
*   MDRQX                                                              *
*                                                                      *
*   Tabelle der originären Bedarfe und der Excessiven Aufträge, d.h.   *
*   der Aufträge, zu denen keine korrespondierenden Bedafe ermittelt   *
*   werden konnten.                                                    *
*----------------------------------------------------------------------*
DATA: BEGIN OF mdrqx OCCURS 50.
        INCLUDE STRUCTURE mdrq.
DATA: END OF mdrqx.

DATA: BEGIN OF it_mdrq OCCURS 0.
        INCLUDE STRUCTURE mdrqx.
DATA: END OF it_mdrq.


*DATA : it_mdrq  TYPE STANDARD TABLE OF  mdrqx,
*        wa_mdrq TYPE st_mdrqx.
