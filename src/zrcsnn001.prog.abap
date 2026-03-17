*eject
* 4.7
* HGA087938 090102 überflüssiger SUBMIT-Parameter (div.)
* 4.6C
* HGA246532 081199 ALV
* 4.6B
* HGA054648 010999 Print Optionen im Batch (II)
* HGA046836 270799 Aufl. ProjektStl
* 4.6A
* HGC201257 240399 DVS enjoy aenderungen
* HGB201257 230399 CL.. enjoy aenderungen
* HGB195880 180399 Abbr. auf ECM_PROCESSOR_INIT Dynpro
* HGB177870 230299 Print Optionen im Batch
* HGB142493 061098 Erw. ECM_PROCESSOR_INIT
* 4.5B
* HGB069822 231298 Parm.Eff: Gültigkeitsvorgaben bei Dat.Eff
* HGD059252 161198 Conversion-Error entschaerft
* HGC059252 121198 Nachtrag A033687 (KndStl - kein Ausweichen auf Mat)
* HGB059252 121198 ParmEff-Bewertung in SelkritAnzeige
* HGA059252 121198 ParmEff-Popup abh. vom Stl.-TopMat (auch bei KndStl)
* 4.0C/4.5A
* HGA033347 140798 Anz. Mengenfelder ohne Mengeneinheit
* HGA024434 090798 div. /Pos.Anz fuer KndStl/Ansprung Verw.
* HGA084505 200298 neue Gueltigkeit
* 4.0A
* HGA027225 290797 Neudesign SondBesch. / Werkswechsel
* HGA025100 230797 Profilvorbelegung / VList Performance
* 3.1H
* HGC154389 180697 Codingbereinigung (LOOP AT/CHECK)
* 3.1G
* HGA127128 270197 Langtextkennz. / Druck SelKriterien
* 3.0F
* HGB099459 010896 alter Materialobjekttyp
* 3.0E
* HGA080825 030796 Vervollst. HGD051356; x-stell. MatNum
* HGD072824 170596 Ruecksprung bei call transaction
* HGC072824 150596 CATT; Druck im Batch ausschalten
* HGB072824 150596 Abbruch bei Langtext-Includes
* HGA072824 150596 Werksberechtigungspruefung
* 3.0D
* HGB057558 210396 Langtext Includes auflösen
* HGD051356 150396 MatNr-Laenge
* 3.0C
* YHG032486 271195 Performance/Konvertierungen, Coding
* 3.0A
* YHG141209 110795 Performance/Typisierung
* YHG126159 230595 Submit-Defaults
* YHG124829 180595 Anpassung Grafikaufruf
* YHG123656 160595 Verhalten bei CALLs korrigiert
* QIK110780 110495 Aufruf aus Graphik repariert
* 3.0
* YHG139715 030495 Selectoptions-Anzeige
* YHG137469 230395 Oberfläche / PosAnz repariert / F1-Hilfe
* YHG130360 280295 Aend. ParmName in FB / Berech. Vereinfachung
* YHG093161 290694 Korr. Grafikanbindung
* 2.2
* YHG083093 180594 Ausflug Verwendung korrigiert
* YHG079407 250494 Zuordnungen anzeigen
* YHG078090 130494 Druckmessage / Batch / Rahmenausgabe (SY-VLINE)
* YHG077295 050494 MatVerwendung ueber Klassen und Folgeaktionen
* YHG000109 280294 Klassenpositionen
* 2.1D
* YHG072697 180294 GUI-Listanzeige (Nachtrag zu K066003)
* YHG069035 310194 fehlende Fehlerhinweise
* YHG068719 280194 Sortiermoeglichkeiten korrigiert
* 2.1C
* YHG063567 140194 Seitenende
* 2.1
* YHG063011 101293 Nachtrag zu K061577
* YHG061577 071293 Positionsanzeige
* YHG058186 291193 Grafikanbindung korrigiert
* YHG053243 151093 Steuerung der Druckoption geaendert
* YHG044860 100993 Verwendung durch CAD-Schnittstelle ermoeglicht
* YHG042334 270893 Restore Set/Get-Parameter nach Transaktionsansprung
* YHG041147 250893 Dokumentpositionen
* YHG037132 120793 Seitenkopfueberschriften korrigiert
***********************************************************************
*        R C S N N 0 0 1           Programme   R C S 1 1 0 0 1        *
*                                              R C S 1 2 0 0 1        *
*                                              R C S 1 3 0 0 1        *
***********************************************************************
TABLES:                                                       "HGA025100
   MTCOM,                                                     "HGA084505
   MC29M,                                                     "HGA084505
   MTCOR,                                                     "HGA084505
   TCC08,                                                     "HGA084505
   TCSVL,                                                     "HGA025100
   USR02.                                                     "HGA025100

TYPE-POOLS:                                                   "HGA084505
   CC01.                                                      "HGA084505

DATA: BEGIN OF CSIN.
         INCLUDE STRUCTURE CSIN.
DATA: END OF CSIN.

DATA: BEGIN OF DUMMYTAB OCCURS 0,                             "HGA084505
         DUMMY1,                                              "HGA084505
      END OF DUMMYTAB.                                        "HGA084505

DATA:
   TYP_DOC   LIKE STZU-STLTY VALUE 'D',                       "YHG137469
   TYP_EQUI  LIKE STZU-STLTY VALUE 'E',
   TYP_KND   LIKE STZU-STLTY VALUE 'K',                       "YHG137469
   TYP_MAT   LIKE STZU-STLTY VALUE 'M',
   TYP_PRJ   LIKE STZU-STLTY VALUE 'P',                       "HGA046836
   TYP_STD   LIKE STZU-STLTY VALUE 'S',                       "YHG137469
   TYP_TPL   LIKE STZU-STLTY VALUE 'T'.                       "YHG137469

DATA:                                                         "YHG032486
   SHORTLN(30) TYPE C VALUE '______________________________', "YHG032486
   I28         TYPE I VALUE 28.                               "YHG032486

DATA:                                                         "YHG032486
   TMP_CNT     TYPE I.                                        "YHG032486

*d DATA:                                            "HGD051356"HGA080825
*d    MNR_LNG     TYPE I.                           "HGD051356"HGA080825

DATA:
   SCR_PAGNO LIKE SY-PAGNO,                                   "YHG079407
   SCR_LINNO LIKE SY-LINNO.                                   "YHG079407

DATA:                                                         "HGC072824
   CATTAKTIV(1) TYPE C.                                       "HGC072824

DATA:                                                         "HGA072824
   DSP_ACTVT(2) TYPE C VALUE '03'.                            "HGA072824

DATA: BEGIN OF INP_SEL OCCURS 20.  "Selektionsparameter       "YHG139715
         INCLUDE STRUCTURE RSPARAMS.                          "YHG139715
DATA: END OF INP_SEL.                                         "YHG139715

*d DATA: BEGIN OF TXT_SEL OCCURS 20,  "Selektionstexte     "YHG139715"uc
*d         ID(9),                                          "YHG139715"uc
*d         TEXT(40),                                       "YHG139715"uc
*d      END OF TXT_SEL.                                    "YHG139715"uc

DATA: BEGIN OF TXT_SEL OCCURS 20.  "Selektionstexte                  "uc
         include structure textpool.                                 "uc
data: END OF TXT_SEL.                                                "uc

ENHANCEMENT-SECTION     RCSNN001_40 SPOTS ES_RCSNN001 STATIC INCLUDE BOUND .
DATA: BEGIN OF DSP_SEL OCCURS 20,                             "YHG139715
         TEXT(30),                                            "YHG139715
         FILLER(2) VALUE '_ ',                                "YHG139715
         WERT(32),                                            "YHG139715
      END OF DSP_SEL.                                         "YHG139715
END-ENHANCEMENT-SECTION.

DATA: BEGIN OF DSP_SEL2 OCCURS 20,                            "HGB059252
         TEXT(30),                                            "HGB059252
         FILLER(2) VALUE '_ ',                                "HGB059252
         WERT(32),                                            "HGB059252
      END OF DSP_SEL2.                                        "HGB059252

DATA: USR_CLASS LIKE USR02-CLASS.                             "HGA025100

DATA: SV_UCOMM LIKE SY-UCOMM.                               "note 351902

DATA: CCVAL  TYPE CC01_VALID_INVALID,                         "HGA084505
      PARAM  TYPE CC01_PARAMETER,                             "HGA084505
      SCCVAL TYPE CC01_VALID_OR_INVALID_TYPE,                 "HGA084505
      SPARAM TYPE CC01_PARAMETER_TYPE.                        "HGA084505

DATA: ECM_SL    TYPE CC01_PARAMETER.                          "HGB059252
DATA: WA_ECM_SL TYPE CC01_PARAMETER_TYPE.                     "HGB059252

FIELD-SYMBOLS: <PM_NAME>.                                     "YHG139715

DATA: BEGIN OF XDPROF OCCURS 0.                               "HGB020150
         INCLUDE STRUCTURE DPROF.                             "HGB020150
DATA: END OF XDPROF.                                          "HGB020150

DATA: BEGIN OF prrsv_tb OCCURS 0,                             "HGB020150
         blnam like dprof-class,                              "HGB020150
         maxln like dprof-bllin,                              "HGB020150
      END OF prrsv_tb.                                        "HGB020150

field-symbols:                                                       "uc
  <x_watab-table>  type x,                                           "uc
  <x_stpol_add_wa> type x,                                           "uc
  <x_stpox_wa>     type x,                                           "uc
  <x_cscmat_wa>    type x,                                           "uc
  <x_cstmat_wa>    type x,                                           "uc
  <x_stpub_wa>     type x.                                           "uc

* ---------------------------------
AT USER-COMMAND.
   SV_UCOMM = SY-UCOMM.                                     "note 351902

   CASE SY-UCOMM.
      WHEN 'ABBR'.
         LEAVE.
      WHEN 'ANMS'.
         LEAVE TO TRANSACTION SY-TCODE.
      WHEN 'CSCA'.                                            "YHG079407
         PERFORM SINGLE_CLXPL_ON_OFF.                         "YHG079407
      WHEN 'CSCN'.                                            "YHG079407
         PERFORM GLOBAL_CLXPL_ON_OFF.                         "YHG079407
      WHEN 'CSCF'.                                            "YHG079407
         PERFORM GLOBAL_CLXPL_ON_OFF.                         "YHG079407
      WHEN 'CSAO'.                                            "YHG000109
         PERFORM OBJEKT_ANZEIGEN.                             "YHG000109
      WHEN 'CSAD'.                                            "YHG041147
         PERFORM DOKUMENT_ANZEIGEN.                           "YHG041147
      WHEN 'CSAK'.                                            "YHG000109
         PERFORM KLASSE_ANZEIGEN.                             "YHG000109
      WHEN 'CSAP'.
         PERFORM POSITION_ANZEIGEN.
      WHEN 'CSAM'.
         PERFORM MATERIAL_ANZEIGEN.
      WHEN 'CSEN'.
         IF CAL_ACLAS = 'CC  '.                               "HGD072824
            LEAVE.                                            "HGD072824
         ELSE.                                                "HGD072824
            LEAVE TO TRANSACTION '    '.
         ENDIF.                                               "HGD072824
      WHEN 'CSMV'.
         PERFORM VERWENDUNG_ANZEIGEN.
      WHEN 'CSWU'.                                            "YHG083093
         PERFORM VERWENDUNG_ANZEIGEN.                         "YHG083093
      WHEN 'CSPR'.
*del     PERFORM PREP_DRUCK.                                  "YHG139715
         PERFORM DRUCKEN.                                     "YHG139715
      WHEN 'CSGR'.                                            "YHG058186
         PERFORM CALL_GRAFIK.                                 "YHG058186
*     gehe zu Objekt Material
      WHEN 'CSSM'.                                            "YHG068719
         SCROLL LIST TO PAGE PAGE_MAT.                        "YHG068719
*     gehe zu Objekt Dokument
      WHEN 'CSDK'.                                            "YHG068719
         SCROLL LIST TO PAGE PAGE_DOK.                        "YHG068719
*     gehe zu Objekt Klasse
      WHEN 'CSKL'.                                            "YHG000109
         SCROLL LIST TO PAGE PAGE_KLA.                        "YHG000109
*     gehe zu Objekt -kein Objekt-
      WHEN 'CSNO'.                                            "YHG068719
         SCROLL LIST TO PAGE PAGE_NOO.                        "YHG068719
*     gehe zu Ausnahmehinweisen
      WHEN 'CSSX'.                                            "YHG068719
         SCROLL LIST TO PAGE PAGE_EXC.                        "YHG068719
*     Hilfe
      WHEN 'CSHP'.                                            "YHG137469
         PERFORM HELP_ME.                                     "YHG137469
*     Selektionsparameter
      WHEN 'CSSL'.                                            "YHG139715
         PERFORM PARAMETER_ANZEIGEN.                          "YHG139715
*     fms modifications
      WHEN 'SGT+' OR 'SGT-'.
         CLEAR: CSBOMEX.
         CSBOMEX-MVAR1 = SY-UCOMM.
         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.
         LEAVE.
   ENDCASE.
   PERFORM CLR_HIDE_AREA.                                     "YHG123656

*eject
* ---------------------------------
INCLUDE RCSROU00.


*eject
***********************************************************************
*        F O R M  -  Routinen                                         *
***********************************************************************
*eject
*---------------------------------------------------------------------*
*        CALL_GRAFIK                               USER-COMMAND: CSGR *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM CALL_GRAFIK.                                             "YHG058186
   CALL FUNCTION 'BOM_HIERARCHY'                              "YHG058186
      EXPORTING WERKS = PM_WERKS                              "YHG058186
                DATUV = PM_DATUV                              "YHG058186
*del            GBRAZ = PM_GBRAZ                    "YHG058186"YHG139715
                LTEXT = PM_LTEXT                              "YHG058186
                POSTP = PM_POSTP                              "YHG058186
                TMAT  = SELPOOL                               "YHG058186
      TABLES                                                  "YHG058186
                STL = STB                                     "YHG058186
                MAT = MATCAT.                                 "YHG124829
ENDFORM.                                                      "YHG058186


*eject
*---------------------------------------------------------------------*
*        CHK_CL_CLSTAB_ENTRY                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM CHK_CL_CLSTAB_ENTRY.                                     "YHG079407
* ---------------------------------
DATA: LCL_TABIX LIKE SY-TABIX.
* ---------------------------------
*  Nr. der aktuellen CL_CLSTAB-Zeile merken
   LCL_TABIX = SY-TABIX.

*  akt. CL_CLSTAB-Eintrag als bearbeitet kennzeichnen
   CL_CLSTAB-CHKED = 'x'.

*  Zuordnungen zur Klasse im akt. POSTAB-Eintrag holen
   PERFORM GET_CLA_ALLOCS
      USING CL_CLSTAB-CLASS
            CL_CLSTAB-KLART.

*  ?Zuordnungen vorhanden
*  ja
   IF SY-SUBRC = 0.
*     Zuordnungen in Memotabelle uebernehmen
      PERFORM CL_OBJMEMO_MAINT.
*     Merktabelle sortieren
      SORT CL_OBJMEMO.

*     Kz ZuordnungenAnzeigen setzen
      CL_CLSTAB-DSPLY = 'x'.
*  nein, keine Zuordnungen gefunden
   ELSE.
*     Kz KlasseOhneZuordnungen setzen
      CL_CLSTAB-NOOBJ = 'x'.
*     Kz ZuordnungenAnzeigen zuruecknehmen
      CLEAR: CL_CLSTAB-DSPLY.
   ENDIF.

*  CL_CLSTAB-Eintrag geaendert zurueckschreiben
   MODIFY CL_CLSTAB INDEX LCL_TABIX.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        CHK_PLANT_AUTH                                               *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM CHK_PLANT_AUTH.                                          "HGA072824
   IF PM_WERKS IS INITIAL.
      AUTHORITY-CHECK OBJECT 'C_STUE_WRK'                  "#EC CI_SUBRC
*                                                             "ci 042902
         ID 'ACTVT' FIELD DSP_ACTVT
         ID 'CSWRK' DUMMY.
   ELSE.
      AUTHORITY-CHECK OBJECT 'C_STUE_WRK'                  "#EC CI_SUBRC
*                                                             "ci 042902
         ID 'ACTVT' FIELD DSP_ACTVT
         ID 'CSWRK' FIELD PM_WERKS.
   ENDIF.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        CLR_HIDE_AREA                                                *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM CLR_HIDE_AREA.
   CLEAR:
      STB-MNGLG,
      STB-IDNRK,
      STB-WERKS,                                              "HGA027225
      CLO_MATNR,                                              "YHG079407
      STB-DOKAR,                                              "YHG041147
      STB-DOKNR,                                              "YHG041147
      STB-DOKVR,                                              "YHG041147
      STB-DOKTL,                                              "YHG041147
      STB-CLASS,                                              "YHG000109
      STB-KLART,                                              "YHG000109
      STB-OBJTY,                                              "YHG079407
      STB-SUMKZ,
      STB-STPOZ,                                              "YHG063011
*del  STB-MATNR,                                              "YHG137469
      MATCAT-MATNR,                                           "YHG137469
      MATCAT-PRWRK,                                           "HGA027225
      STB-VPSTA,
      STB-STLAL,
      STB-STLAN,
      STB-STLKN,
      STB-STLTY,                                              "HGA024434
      STB-STLNR.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        CL_CLSTAB_MAINT                                              *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM CL_CLSTAB_MAINT.                                         "YHG079407
*  nur fuer Klassenpositionen
   CHECK STB-OBJTY EQ OTYP_KLA.

*  Teilkey der Klassenpositionentabelle
   CL_CLSTAB-CLASS = STB-CLASS.
   CL_CLSTAB-KLART = STB-KLART.

*  Klassenpositionentabelle lesen
   READ TABLE CL_CLSTAB
      WITH KEY CL_CLSTAB(21)
      BINARY SEARCH.

*  aktuelle Klassenposition bereits in Klassenpositionentabelle
*  nein
   IF SY-SUBRC <> 0.
*     Klassenposition in Klassenpositionentabelle hinzufuegen
      INSERT CL_CLSTAB INDEX SY-TABIX.
   ENDIF.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        CL_OBJMEMO_MAINT                                             *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM CL_OBJMEMO_MAINT.                                        "YHG079407
*  fuer jede Zuordnung der aktuellen Klasse
   LOOP AT CL_OBJTAB.
*     Klassendaten in MemoEintrag uebernehmen
      MOVE-CORRESPONDING CL_CLSTAB TO CL_OBJMEMO.
*     Materialdaten in MemoEintrag uebernehmen
      MOVE-CORRESPONDING CL_OBJTAB TO CL_OBJMEMO.

*     Materialkurztext in MemoEintrag besorgen
      PERFORM READ_MAKT
*d       USING CL_OBJMEMO-OBJECT(18)                          "HGA080825
         USING CL_OBJMEMO-OBJECT(MNR_LNG)                     "HGA080825
               CL_OBJMEMO-TEXT(40).

*     Eintrag sichern
      APPEND CL_OBJMEMO.
   ENDLOOP.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        CREATE_TXINCL_CMD                                            *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM CREATE_TXINCL_CMD.                                       "HGB057558
DATA: CHK_NXT  LIKE CSDATA-XFELD,
      TXT_RIDX LIKE SY-TABIX,
      TXT_OFFS TYPE I,
      HLP_FLIN LIKE TLINE-TDLINE.
*----------------------------------

   CLEAR: CHK_NXT.
   LOOP AT TXT.
*     ?war die Vorgaengerzeile eine INCLUDE-Anweisung
*     ja
      IF NOT CHK_NXT IS INITIAL.
*        ?ist akt. Zeile mögliche Fortsetzung der Vorgaengerzeile
*        ja, es ist eine Kommentarzeile
         IF TXT-TDFORMAT EQ '/*'.
*           bestimme Endpos. des beschriebenen Abschnitts von HLP_FLIN
            IF HLP_FLIN CP '*# '. ENDIF.
*           ?liegt Endeposition am Feldende
*           ja
            IF SY-FDPOS >= 132.                               "HGB072824
*              dann passt da nichts mehr hin; Zus.stellung abbr.
               CLEAR: CHK_NXT.                                "HGB072824
*           nein, in der Hilfslinie ist noch Platz
            ELSE.                                             "HGB072824
*              bestimme Offset (= Endpos. + 1)
               TXT_OFFS = SY-FDPOS + 1 .
*              fuege Fortsetzungszeile ab Offset an
               HLP_FLIN+TXT_OFFS = TXT-TDLINE.
*              alles zusammenschieben; Luecken lassen
               CONDENSE HLP_FLIN.
*              LeseIndex des INCLUDE-Satzes ermitteln
               TXT_RIDX = SY-TABIX - 1 .
*              INCLUDE-Satz wieder einlesen
               READ TABLE TXT INDEX TXT_RIDX.
*              Satzverlaengerung uebernehmen ...
               TXT-TDLINE = HLP_FLIN.
*              ... und sichern
               MODIFY TXT INDEX TXT_RIDX.
*              Index des Fortsetzungssatzes ermitteln
               TXT_RIDX = TXT_RIDX + 1 .
*              Fortsetzungssatz löschen
               DELETE TXT INDEX TXT_RIDX.
*              Format des INCLUDE-Satzes init.
               CLEAR: TXT-TDFORMAT.
            ENDIF.                                            "HGB072824
         ELSE.
*           NachfolgerCheck init.
            CLEAR: CHK_NXT.
         ENDIF.
      ENDIF.

*     ?Ist akt. Zeile eine Steueranweisung
*     ja
      IF TXT-TDFORMAT EQ '/:'.
*        ?Ist akt. Zeile (sehr wahrscheinlich) eine INCL-Anweisung
         SEARCH TXT-TDLINE FOR 'INCLUDE'.
*        ja
         IF SY-SUBRC = 0.
*           dann sollte die Nachfolgezeile geprüft werden ...
            CHK_NXT = 'x'.
*           und der erste Teil der INCL-Anweisung gesichert werden
            HLP_FLIN = TXT-TDLINE.
         ENDIF.
      ENDIF.
   ENDLOOP.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        DOKUMENT_ANZEIGEN                         USER-COMMAND: CSAD *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM DOKUMENT_ANZEIGEN.                                       "YHG041147
* ---------------------------------
DATA: LKL_DOKAR LIKE DRAW-DOKAR,                              "YHG041147
      LKL_DOKNR LIKE DRAW-DOKNR,                              "YHG041147
      LKL_DOKVR LIKE DRAW-DOKVR,                              "YHG041147
      LKL_DOKTL LIKE DRAW-DOKTL.                              "YHG041147
* ---------------------------------

   IF     STB-DOKAR IS INITIAL                                "YHG069035
      OR  STB-DOKNR IS INITIAL                                "YHG069035
      OR  STB-DOKVR IS INITIAL                                "YHG069035
      OR  STB-DOKTL IS INITIAL.                               "YHG069035

      MESSAGE S150.                                           "YHG069035

      CHECK     NOT STB-DOKAR IS INITIAL                      "YHG041147
            AND NOT STB-DOKNR IS INITIAL                      "YHG041147
            AND NOT STB-DOKVR IS INITIAL                      "YHG041147
            AND NOT STB-DOKTL IS INITIAL.                     "YHG041147
   ENDIF.                                                     "YHG069035


   GET PARAMETER: ID 'CV2' FIELD LKL_DOKAR,                   "YHG041147
                  ID 'CV1' FIELD LKL_DOKNR,                   "YHG041147
                  ID 'CV3' FIELD LKL_DOKVR,                   "YHG041147
                  ID 'CV4' FIELD LKL_DOKTL.                   "YHG041147

   SET PARAMETER: ID 'CV2' FIELD STB-DOKAR,                   "YHG041147
                  ID 'CV1' FIELD STB-DOKNR,                   "YHG041147
                  ID 'CV3' FIELD STB-DOKVR,                   "YHG041147
                  ID 'CV4' FIELD STB-DOKTL.                   "YHG041147

*d CALL TRANSACTION 'CV03' AND SKIP FIRST SCREEN.   "YHG041147"HGC201257
   CALL TRANSACTION 'CV03N' AND SKIP FIRST SCREEN.            "HGC201257

   SET PARAMETER: ID 'CV2' FIELD LKL_DOKAR,                   "YHG041147
                  ID 'CV1' FIELD LKL_DOKNR,                   "YHG041147
                  ID 'CV3' FIELD LKL_DOKVR,                   "YHG041147
                  ID 'CV4' FIELD LKL_DOKTL.                   "YHG041147
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        DRUCKEN                                                      *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM DRUCKEN.                                                 "YHG139715
   PERFORM LISTE_DRUCKEN.

   MESSAGE S518.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        END_PAGE                                                     *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
*FORM END_PAGE.                                               "YHG036694
* inactivated and moved to RCS13001                           "HGB246532
* ---------------------------------
*DATA: LCL_RLLIN LIKE SY-LINNO.
*DATA: CS11_LIN LIKE SY-LINNO VALUE 8.                        "YHG037132
*DATA: CS12_LIN LIKE SY-LINNO VALUE 8.                        "YHG037132
*del DATA: CS13_LIN LIKE SY-LINNO VALUE 7.         "YHG037132 "YHG041147
*DATA: CS13_LIN LIKE SY-LINNO VALUE 8.                        "YHG041147

* ---------------------------------
*  FORMAT RESET.                                              "YHG072697
*  CASE SY-REPID.                                             "YHG037132
*     WHEN 'RCS11001'.                                        "YHG037132
*        LINS_PER_PAG = SY-SROWS - CS11_LIN.                  "YHG037132
*        LINS_OUT = LINS_OUT_SAV + SY-LINNO - CS11_LIN + 1 .  "YHG037132
*     WHEN 'RCS12001'.                                        "YHG037132
*        LINS_PER_PAG = SY-SROWS - CS12_LIN.                  "YHG037132
*        LINS_OUT = LINS_OUT_SAV + SY-LINNO - CS12_LIN + 1 .  "YHG037132
*     WHEN 'RCS13001'.                                        "YHG037132
*        LINS_PER_PAG = SY-SROWS - CS13_LIN.                  "YHG037132
*        LINS_OUT = LINS_OUT_SAV + SY-LINNO - CS13_LIN + 1 .  "YHG037132
*  ENDCASE.                                                   "YHG037132

*del LINS_PER_PAG = SY-SROWS - 8 .                            "YHG037132
*del LINS_OUT     = LINS_OUT_SAV + SY-LINNO - 7 .             "YHG037132
*  LINS_OUT_SAV = LINS_OUT.

*  DO.
*     IF LINS_OUT <= LINS_PER_PAG.
*        EXIT.
*     ENDIF.
*     LINS_OUT = LINS_OUT - LINS_PER_PAG.
*  ENDDO.
*  LINS_TO_SKIP = LINS_PER_PAG - LINS_OUT.
*  LINS_OUT_SAV = LINS_OUT_SAV + LINS_TO_SKIP.

*  LCL_RLLIN = LINS_PER_PAG - LINS_TO_SKIP.
*  CHECK LCL_RLLIN > 1.

*  IF SY-UCOMM NE 'CSPR'.                                     "YHG063567
*     DO.
*        IF LINS_TO_SKIP < 1.
*           EXIT.
*        ENDIF.
*        SKIP.
*        LINS_TO_SKIP = LINS_TO_SKIP - 1 .
*     ENDDO.

*del  FORMAT INTENSIFIED OFF.                                 "YHG063567
*del  WRITE: /37 '***'.                                       "YHG063567
*     WRITE: / ' '.                                           "YHG063567
*  ENDIF.                                                     "YHG063567
*ENDFORM.


*eject
*---------------------------------------------------------------------*
*        GET_CLA_ALLOCS                                               *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM GET_CLA_ALLOCS USING                                     "YHG079407
   LCL_CLASS LIKE KLAH-CLASS
   LCL_KLART LIKE KLAH-KLART.
*----------------------------------
DATA: SAV_CL_OBJTAB LIKE CKSSK.
*----------------------------------
*  Tab. mit allen Zuord.n zu einer Klasse initialisieren
   CLEAR: CL_OBJTAB.
   REFRESH CL_OBJTAB.

*  alle Zuord.n zur Klasse LCL_CLASS besorgen
   CALL FUNCTION 'CLFC_OBJECTS_FROM_CLASS'
        EXPORTING
             CLASS             = LCL_CLASS
             date              = pm_datuv                   "note 159716
*del         TYPE              = LCL_KLART                    "YHG130360
             CLASSTYPE         = LCL_KLART                    "YHG130360
             TOP_DOWN          = 'X'
        TABLES
             OBJECTS           = CL_OBJTAB
        EXCEPTIONS
             NOT_FOUND         = 01.

*  nur weiter, wenn Zuordnungen gefunden wurden
   CHECK SY-SUBRC = 0.

*  ZuordnungenTab sortieren
   SORT CL_OBJTAB.

*  fuer jede Zuordnung zu LCL_CLASS ...
*d LOOP AT CL_OBJTAB.                                         "HGC154389
*     ?kommt der Eintrag mehrfach vor
*     ja
*d    IF CL_OBJTAB EQ SAV_CL_OBJTAB.                          "HGC154389
*        Eintrag loeschen
*d       DELETE CL_OBJTAB.                                    "HGC154389
*        naechsten Eintrag bearbeiten
*d       CHECK 1 = 2 .                                        "HGC154389
*d    ENDIF.                                                  "HGC154389

*     ?handelt es sich bei der Zuord. um ein Material
*     nein
*d    IF CL_OBJTAB-TABLE(4) NE 'MARA'.                        "HGC154389
*        Eintrag loeschen
*d       DELETE CL_OBJTAB.                                    "HGC154389
*        naechsten Eintrag bearbeiten
*d       CHECK 1 = 2 .                                        "HGC154389
*d    ENDIF.                                                  "HGC154389

*     Eintrag akzeptiert; als Vergleich fuer naechsten Eintrag merken
*d    SAV_CL_OBJTAB = CL_OBJTAB.                              "HGC154389
*d ENDLOOP.                                                   "HGC154389

*  loesche Zuord., die kein Material sind
   DELETE CL_OBJTAB                                           "HGC154389
      WHERE TABLE(4) NE 'MARA'.                               "HGC154389

*  loesche doppelte
   DELETE ADJACENT DUPLICATES                                 "HGC154389
      FROM CL_OBJTAB.                                         "HGC154389

*  setze SY-SUBRC wg. DELETE zurueck
   CLEAR: SY-SUBRC.                                           "HGC154389
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        GET_CLA_ALLOCS_ALL                                           *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM GET_CLA_ALLOCS_ALL.                                      "YHG079407
* ---------------------------------
DATA: MEMO_SORTFG(1) TYPE C.
* ---------------------------------
*  Kz MerktabelleMussSortiertWerden initialisieren
   CLEAR: MEMO_SORTFG.

*  fuer jeden Eintrag in der Klassenpositionentabelle ...
   LOOP AT CL_CLSTAB.
*     ... seine Zuordnungen holen
      PERFORM GET_CLA_ALLOCS
         USING CL_CLSTAB-CLASS
               CL_CLSTAB-KLART.

*     im POSTAB-Eintrag BearbeitetKz setzen
      CL_CLSTAB-CHKED = 'x'.

*     ?Zuordnungen vorhanden
*     ja
      IF SY-SUBRC = 0.
*        Zuordnungenmerktabelle pflegen
         PERFORM CL_OBJMEMO_MAINT.

*        Kz MerktabelleMussSortiertWerden setzen
         MEMO_SORTFG = 'x'.

*        ?Anzeigen Zuordnungen schon beim Programmeinstieg gesetzt
*        ja
         IF NOT PM_DSPCO IS INITIAL.
*           im POSTAB-Eintrag DisplayKz setzen
            CL_CLSTAB-DSPLY = 'x'.
         ENDIF.

*        POSTAB-Eintrag mit Aenderungen zurueckschreiben
         MODIFY CL_CLSTAB.
*     nein, keine Zuordnungen vorhanden
      ELSE.
*        im POSTAB-Eintrag KeineZuordnungenKz setzen
         CL_CLSTAB-NOOBJ = 'x'.
*        POSTAB-Eintrag mit Aenderungen zurueckschreiben
         MODIFY CL_CLSTAB.
      ENDIF.
   ENDLOOP.

*  ?Muss Merktabelle neu sortiert werden
*  ja
   IF NOT MEMO_SORTFG IS INITIAL.
*     Merktabelle sortieren
      SORT CL_OBJMEMO.
      CLEAR: MEMO_SORTFG.
   ENDIF.
ENDFORM.


FORM GET_PROFS.                                               "HGA025100
   if pm_dsprf is initial.                                    "HGA246532
      SELECT SINGLE PROFL FROM TCSVL
         INTO PM_DSPRF
         WHERE     UNAME EQ SY-UNAME
               AND PROGR EQ SY-REPID
               AND PVERW EQ 'DSPL'.

      IF SY-SUBRC <> 0.
         SELECT SINGLE CLASS FROM USR02
            INTO USR_CLASS
            WHERE BNAME EQ SY-UNAME.

         IF USR_CLASS IS INITIAL.
            PERFORM GET_PROFS_DUMMY_D.
         ELSE.
            SELECT SINGLE PROFL FROM TCSVL
               INTO PM_DSPRF
               WHERE     UNAME EQ USR_CLASS
                     AND PROGR EQ SY-REPID
                     AND PVERW EQ 'DSPL'.

            IF SY-SUBRC <> 0.
               PERFORM GET_PROFS_DUMMY_D.
            ENDIF.
         ENDIF.
      ENDIF.
   endif.                                                     "HGA246532

   if pm_prprf is initial.                                    "HGA246532
      SELECT SINGLE PROFL FROM TCSVL
         INTO PM_PRPRF
         WHERE     UNAME EQ SY-UNAME
               AND PROGR EQ SY-REPID
               AND PVERW EQ 'PRNT'.

      IF SY-SUBRC <> 0.
         SELECT SINGLE CLASS FROM USR02
            INTO USR_CLASS
            WHERE BNAME EQ SY-UNAME.

         IF USR_CLASS IS INITIAL.
            PERFORM GET_PROFS_DUMMY_P.
         ELSE.
            SELECT SINGLE PROFL FROM TCSVL
               INTO PM_PRPRF
               WHERE     UNAME EQ USR_CLASS
                     AND PROGR EQ SY-REPID
                     AND PVERW EQ 'PRNT'.

            IF SY-SUBRC <> 0.
               PERFORM GET_PROFS_DUMMY_P.
            ENDIF.
         ENDIF.
      ENDIF.
   endif.                                                     "HGA246532
ENDFORM.


FORM GET_PROFS_DUMMY_D.                                       "HGA025100
   SELECT SINGLE PROFL FROM TCSVL
      INTO PM_DSPRF
      WHERE     UNAME EQ 'DUMMY       '
            AND PROGR EQ SY-REPID
            AND PVERW EQ 'DSPL'.

   IF SY-SUBRC <> 0.
      PM_DSPRF = DFLT_DSPRF.
   ENDIF.
ENDFORM.


FORM GET_PROFS_DUMMY_P.                                       "HGA025100
   SELECT SINGLE PROFL FROM TCSVL
      INTO PM_PRPRF
      WHERE     UNAME EQ 'DUMMY       '
            AND PROGR EQ SY-REPID
            AND PVERW EQ 'PRNT'.

   IF SY-SUBRC <> 0.
      PM_PRPRF = DFLT_PRPRF.
   ENDIF.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        GLOBAL_CLXPL_ON_OFF.                                         *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM GLOBAL_CLXPL_ON_OFF.                                     "YHG079407
* --------------------------------
DATA: SCROLL_DIFF LIKE SY-LINNO,
      LCL_LINES LIKE SY-LINNO.
* --------------------------------
*  Submodus verhindern
   SY-LSIND = SY-LSIND - 1 .

   DESCRIBE TABLE CL_CLSTAB LINES LCL_LINES.
   CHECK LCL_LINES > 0.

   LOOP AT CL_CLSTAB.
*d    IF     sy-ucomm EQ 'CSCN'.                            "note 351902
      IF     SV_UCOMM EQ 'CSCN'.                            "note 351902
         CL_CLSTAB-DSPLY = 'x'.
      ELSE.
         CLEAR: CL_CLSTAB-DSPLY.
      ENDIF.
      MODIFY CL_CLSTAB.
   ENDLOOP.
   SY-UCOMM = 'CSCA'.
   SV_UCOMM = 'CSCA'.                                       "note 351902

*  Scroll-Seite ermitteln
   SCR_PAGNO = SY-CPAGE.
   IF SCR_PAGNO IS INITIAL.
      SCR_PAGNO = 1.
   ENDIF.

   SCR_LINNO = 1 .

*  Liste erneut anzeigen (Zuordnungen ein- bzw. ausgeblendet)
   PERFORM NEU_ANZEIGE.

*  Anzeige positionieren
   SCROLL LIST INDEX 1 TO PAGE SCR_PAGNO LINE SCR_LINNO .
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        GRAPH_CSXX                                                   *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM GRAPH_CSXX                                               "YHG058186
   USING LKL_STB                                              "YHG058186
         LKL_WERKS                                            "YHG058186
         LKL_DATUV                                            "YHG058186
*del     LKL_GBRAZ                                  "YHG058186"YHG139715
         LKL_LTEXT                                            "YHG058186
         LKL_POSTP                                            "YHG058186
         LKL_UCOMM.                                           "YHG058186

   STB = LKL_STB.                                             "YHG058186
   PM_WERKS = LKL_WERKS.                                      "YHG058186
   PM_DATUV = LKL_DATUV.                                      "YHG058186
*del PM_GBRAZ = LKL_GBRAZ.                          "YHG058186"YHG139715
   PM_LTEXT = LKL_LTEXT.                                      "YHG058186
   PM_POSTP = LKL_POSTP.                                      "YHG058186

   CASE LKL_UCOMM.                                            "YHG058186
      WHEN 'CSAD'.                                            "YHG058186
         PERFORM DOKUMENT_ANZEIGEN.                           "YHG058186
      WHEN 'CSAP'.                                            "YHG058186
         CASE STB-STLTY.                                     "QIKK110780
         WHEN TYP_MAT.                                       "QIKK110780
            READ TABLE MATCAT INDEX STB-TTIDX.               "QIKK110780
         WHEN OTHERS.                                        "QIKK110780
*----------- Zu programmieren                                "QIKK110780
         ENDCASE.                                            "QIKK110780
         PERFORM POSITION_ANZEIGEN.                           "YHG058186
      WHEN 'CSAM'.                                            "YHG058186
         PERFORM MATERIAL_ANZEIGEN.                           "YHG058186
      WHEN 'CSMV'.                                            "YHG058186
         PERFORM VERWENDUNG_ANZEIGEN.                         "YHG058186
      WHEN 'CSWU'.                                            "YHG093161
         PERFORM VERWENDUNG_ANZEIGEN.                         "YHG093161
      WHEN 'CSAO'.                                            "YHG093161
         PERFORM OBJEKT_ANZEIGEN.                             "YHG093161
   ENDCASE.                                                   "YHG058186
ENDFORM.                                                      "YHG058186


*eject
*---------------------------------------------------------------------*
*        HELP_ME                                                      *
*---------------------------------------------------------------------*
*        -->                                                          *
*                                                                     *
*        <--                                                          *
*                                                                     *
*---------------------------------------------------------------------*
FORM HELP_ME.                                                 "YHG137469
  CALL FUNCTION 'CS_VLIST_BLOCK_FIELD_DOCU'
                     EXPORTING LSTID = LIST_ID
                               PROFL = ACT_PROFIL.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        HIDE_ROUTINE_01                                              *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM HIDE_ROUTINE_01.
   HIDE:
      STB-MNGLG,
      STB-IDNRK,
      STB-WERKS,                                              "HGA027225
      STB-DOKAR,                                              "YHG041147
      STB-DOKNR,                                              "YHG041147
      STB-DOKVR,                                              "YHG041147
      STB-DOKTL,                                              "YHG041147
      STB-CLASS,                                              "YHG000109
      STB-KLART,                                              "YHG000109
      STB-OBJTY,                                              "YHG079407
      STB-SUMKZ,
      STB-STPOZ,                                              "YHG063011
*del  STB-MATNR,                                              "YHG137469
      MATCAT-MATNR,                                           "YHG137469
      MATCAT-PRWRK,                                           "HGA027225
      STB-VPSTA,
      STB-STLAL,
      STB-STLAN,
      STB-STLKN,
*del  STB-STLNR.                                              "YHG079407
*del  STB-STLNR,                                    "YHG079407"YHG137469
      STB-STLTY,                                              "HGA024434
      STB-STLNR.                                              "YHG137469
*del  REAL_LINE.                                    "YHG079407"YHG137469
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        HIDE_ROUTINE_02                                              *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM HIDE_ROUTINE_02.                                         "YHG079407
   STB-OBJTY = OTYP_MAT.

   HIDE:
      CLO_MATNR,
      ALL_PSTAT,
      STB-OBJTY.
ENDFORM.


FORM IMPORT_CATT_FLAG.                                        "HGC072824
   IMPORT CATTAKTIV FROM MEMORY ID 'CATT'.                    "HGC072824
ENDFORM.                                                      "HGC072824


*eject
*---------------------------------------------------------------------*
*        KLASSE_ANZEIGEN                           USER-COMMAND: CSAK *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM KLASSE_ANZEIGEN.                                         "YHG000109
* ---------------------------------
DATA: LKL_CLASS LIKE KLAH-CLASS,
      LKL_KLART LIKE KLAH-KLART.
* ---------------------------------

   IF     STB-CLASS IS INITIAL
      OR  STB-KLART IS INITIAL.

      MESSAGE S150.

      CHECK     NOT STB-CLASS IS INITIAL
            AND NOT STB-KLART IS INITIAL.
   ENDIF.


   GET PARAMETER: ID 'KLA' FIELD LKL_CLASS,
                  ID 'KAR' FIELD LKL_KLART.

   SET PARAMETER: ID 'KLA' FIELD STB-CLASS,
                  ID 'KAR' FIELD STB-KLART.

*d CALL TRANSACTION 'CL03' AND SKIP FIRST SCREEN.             "HGB201256
   CALL FUNCTION 'CLMO_CLASS_OBJECT_MAINTAIN'                 "HGB201256
        EXPORTING                                             "HGB201256
             activity           = '2'                         "HGB201256
             CLASSTYPE          = stb-klart                   "HGB201256
             CLASSNAME          = stb-class                   "HGB201256
             SKIP               = 'X'                         "HGB201256
             .                                                "HGB201256

   SET PARAMETER: ID 'KLA' FIELD LKL_CLASS,
                  ID 'KAR' FIELD LKL_KLART.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        MATERIAL_ANZEIGEN                         USER-COMMAND: CSAM *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM MATERIAL_ANZEIGEN.
* ---------------------------------
DATA: LKL_MATNR LIKE MARA-MATNR,                              "YHG042334
      LKL_WERKS LIKE MARC-WERKS.                              "YHG042334
* ---------------------------------
*del IF STB-IDNRK IS INITIAL.                       "YHG069035"YHG079407
   IF     STB-IDNRK IS INITIAL                                "YHG079407
      AND CLO_MATNR IS INITIAL.                               "YHG079407

      MESSAGE S150.                                           "YHG069035
      CHECK NOT STB-IDNRK IS INITIAL.
   ENDIF.                                                     "YHG069035

   GET PARAMETER ID: 'MAT' FIELD LKL_MATNR,                   "YHG042334
                     'WRK' FIELD LKL_WERKS.                   "YHG042334
                                                              "YHG079407
   IF NOT STB-IDNRK IS INITIAL.                               "YHG079407
      SET PARAMETER ID: 'MAT' FIELD STB-IDNRK,
*del                    'WRK' FIELD PM_WERKS,                 "YHG079407
                        'MXX' FIELD STB-VPSTA.
   ELSE.                                                      "YHG079407
      SET PARAMETER ID: 'MAT' FIELD CLO_MATNR,                "YHG079407
                        'MXX' FIELD ALL_PSTAT.                "YHG079407
   ENDIF.                                                     "YHG079407

*d set parameter id: 'WRK' field pm_werks.                    "HGA027225
   SET PARAMETER ID: 'WRK' FIELD STB-WERKS.                   "HGA027225

   CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

   SET PARAMETER ID: 'MAT' FIELD LKL_MATNR,                   "YHG042334
                     'WRK' FIELD LKL_WERKS.                   "YHG042334

   PERFORM CLR_HIDE_AREA.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        OBJEKT_ANZEIGEN                           USER-COMMAND: CSAO *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM OBJEKT_ANZEIGEN.                                         "YHG000109
*del IF NOT STB-IDNRK IS INITIAL.                             "YHG079407
*d IF     STB-OBJTY EQ OTYP_MAT.                    "YHG079407"HGB099459
   IF     STB-OBJTY EQ OTYP_MAT                               "HGB099459
      OR  STB-OBJTY EQ OOTYP_MAT.                             "HGB099459
      PERFORM MATERIAL_ANZEIGEN.
      EXIT.
   ENDIF.

*del IF     NOT STB-DOKAR IS INITIAL                          "YHG079407
*del    AND NOT STB-DOKNR IS INITIAL                          "YHG079407
*del    AND NOT STB-DOKVR IS INITIAL                          "YHG079407
*del    AND NOT STB-DOKTL IS INITIAL.                         "YHG079407
   IF STB-OBJTY EQ OTYP_DOC.                                  "YHG079407
      PERFORM DOKUMENT_ANZEIGEN.
      EXIT.
   ENDIF.

*del IF     NOT STB-CLASS IS INITIAL                          "YHG079407
*del    AND NOT STB-KLART IS INITIAL.                         "YHG079407
   IF STB-OBJTY EQ OTYP_KLA.                                  "YHG079407
      PERFORM KLASSE_ANZEIGEN.
      EXIT.
   ENDIF.

*  falls Routine bis jetzt noch nicht verlassen, Fehler
   MESSAGE S150.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        POSITION_ANZEIGEN                         USER-COMMAND: CSAP *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM POSITION_ANZEIGEN.
*del IF STB-MATNR IS INITIAL.                       "YHG069035"YHG137469
   IF MATCAT-MATNR IS INITIAL.                                "YHG137469
      MESSAGE S150.                                           "YHG069035
*del  CHECK NOT STB-MATNR IS INITIAL.                         "YHG137469
      CHECK NOT MATCAT-MATNR IS INITIAL.                      "YHG137469
   ENDIF.                                                     "YHG069035

   IF STB-SUMKZ EQ '*'.
      CHECK STB-SUMKZ NE '*'.
   ENDIF.

   CSIN-DATUV = PM_DATUV.
   CSIN-DATUB = PM_DATUV.
   CSIN-EMENG = 0 .
*d csin-idnrk = stb-idnrk.                                 "note 149116
*del CSIN-MATNR = STB-MATNR.                                  "YHG137469
   CSIN-MATNR = MATCAT-MATNR.                                 "YHG137469
   CSIN-STLAL = STB-STLAL.
   CSIN-STLAN = STB-STLAN.
   CSIN-STLKN = STB-STLKN.
*d csin-stlty = typ_mat.                                      "HGA024434
   CSIN-STLTY = STB-STLTY.                                    "HGA024434

   IF CSIN-STLTY EQ TYP_KND.                                  "HGA024434
      CSIN-VBELN = PM_VBELN.                                  "HGA024434
      CSIN-VBPOS = PM_VBPOS.                                  "HGA024434
   ENDIF.                                                     "HGA024434

   IF CSIN-STLTY EQ TYP_PRJ.                                  "HGA046836
      CSIN-pspnr = PM_pspnr.                                  "HGA046836
   ENDIF.                                                     "HGA046836

   CSIN-TRTYP = 'A'.
*d csin-werks = pm_werks.
   CSIN-WERKS = MATCAT-PRWRK.                                 "HGA027225
   CSIN-CMODE = '01'.
   CSIN-STUEZ = STB-STPOZ.                                    "YHG061577

   CALL DIALOG 'CS_BOM_DISPLAY'
      EXPORTING CSIN.

   PERFORM CLR_HIDE_AREA.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        PREP_DRUCK                                                   *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM PREP_DRUCK.                                              "YHG139715
   SIZ_LINPF = SIZ_LINPF - 2.

   IF SIZ_LINPF <= 79.
*     IF TCSPR-PROPT IS INITIAL.                              "HGA054648
      if not syst-batch is initial.                           "HGA054648
         NEW-PAGE PRINT ON
             DESTINATION               sy-pdest               "HGB177870
             COPIES                    sy-prcop               "HGB177870
             LIST NAME                 sy-plist               "HGB177870
             LIST DATASET              sy-prdsn               "HGB177870
             COVER TEXT                sy-prtxt               "HGB177870
             IMMEDIATELY               sy-primm               "HGB177870
             KEEP IN SPOOL             sy-prrel               "HGB177870
             NEW LIST IDENTIFICATION   sy-prnew               "HGB177870
             DATASET EXPIRATION        sy-pexpi               "HGB177870
             LINE-COUNT                62
             LINE-SIZE                 SIZ_LINPF
             LAYOUT                    'X_65_80'
             SAP COVER PAGE            sy-prbig               "HGB177870
             RECEIVER                  sy-prrec               "HGB177870
             DEPARTMENT                sy-prabt               "HGB177870
             WITH-TITLE
             NO DIALOG.
      ELSE.
         IF TCSPR-PROPT IS INITIAL.                           "HGA054648
            NEW-PAGE PRINT ON                                 "HGA054648
                LINE-COUNT 62                                 "HGA054648
                LINE-SIZE SIZ_LINPF                           "HGA054648
                LAYOUT 'X_65_80'                              "HGA054648
                WITH-TITLE                                    "HGA054648
                NO DIALOG.                                    "HGA054648
         else.                                                "HGA054648
            NEW-PAGE PRINT ON
                     LINE-COUNT 62
                     LINE-SIZE SIZ_LINPF
                     LAYOUT 'X_65_80'
                     WITH-TITLE.
         endif.                                               "HGA054648
      ENDIF.
   ELSE.                                                      "YHG139715
*     IF TCSPR-PROPT IS INITIAL.                              "HGA054648
      if not syst-batch is initial.                           "HGA054648
         NEW-PAGE PRINT ON                                    "YHG139715
             DESTINATION               sy-pdest               "HGB177870
             COPIES                    sy-prcop               "HGB177870
             LIST NAME                 sy-plist               "HGB177870
             LIST DATASET              sy-prdsn               "HGB177870
             COVER TEXT                sy-prtxt               "HGB177870
             IMMEDIATELY               sy-primm               "HGB177870
             KEEP IN SPOOL             sy-prrel               "HGB177870
             NEW LIST IDENTIFICATION   sy-prnew               "HGB177870
             DATASET EXPIRATION        sy-pexpi               "HGB177870
             LINE-COUNT                44                     "YHG139715
             LINE-SIZE                 SIZ_LINPF              "YHG139715
             LAYOUT                    'X_44_120'             "YHG139715
             SAP COVER PAGE            sy-prbig               "HGB177870
             RECEIVER                  sy-prrec               "HGB177870
             DEPARTMENT                sy-prabt               "HGB177870
             WITH-TITLE                                       "YHG139715
             NO DIALOG.                                       "YHG139715
      ELSE.                                                   "YHG139715
         IF TCSPR-PROPT IS INITIAL.                           "HGA054648
            NEW-PAGE PRINT ON                                 "HGA054648
                LINE-COUNT 44                                 "HGA054648
                LINE-SIZE SIZ_LINPF                           "HGA054648
                LAYOUT 'X_44_120'                             "HGA054648
                WITH-TITLE                                    "HGA054648
                NO DIALOG.                                    "HGA054648
         else.                                                "HGA054648
            NEW-PAGE PRINT ON                                 "YHG139715
                     LINE-COUNT 44                            "YHG139715
                     LINE-SIZE SIZ_LINPF                      "YHG139715
                     LAYOUT 'X_44_120'                        "YHG139715
                     WITH-TITLE.                              "YHG139715
         endif.                                               "HGA054648
      ENDIF.                                                  "YHG139715
   ENDIF.                                                     "YHG139715
   SIZ_LINPF = SIZ_LINPF + 2.
*del CASE SY-TCODE.                                           "YHG053243
*del    WHEN 'CS11'.                                          "YHG053243
*del       PERFORM CS11(RCS11001).                            "YHG053243
*del    WHEN 'CS12'.                                          "YHG053243
*del       PERFORM CS12(RCS12001).                            "YHG053243
*del    WHEN 'CS13'.                                          "YHG053243
*del       PERFORM CS13(RCS13001).                            "YHG053243
*del ENDCASE.                                                 "YHG053243

*del PERFORM LISTE_DRUCKEN.                         "YHG053243"YHG139715

*del MESSAGE S899 WITH 'I: ' 'Druckauftrag erteilt'.          "YHG078090
*del MESSAGE S518.                                  "YHG078090"YHG139715
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        PRINT_MODE_BATCH                                             *
*---------------------------------------------------------------------*
*        -->                                                          *
*                                                                     *
*        <--                                                          *
*                                                                     *
*---------------------------------------------------------------------*
FORM PRINT_MODE_BATCH.                                        "YHG078090
*----------------------------------

DATA:                                                       "note 486930
  EX2MM TYPE C.                                             "note 486930
*----------------------------------

  call function 'IS_SUBMIT_TO_MEMORY'                       "note 486930
    importing                                               "note 486930
      flag = ex2mm                                          "note 486930
    exceptions                                              "note 486930
      others = 4.                                           "note 486930

  clear: sy-subrc.                                          "note 486930

  IF EX2MM IS INITIAL.                                      "note 486930
   SY-UCOMM = 'CSPR'.
   SV_UCOMM = 'CSPR'.                                       "note 351902
  ENDIF.                                                    "note 486930

*d NEW-PAGE PRINT ON                                          "HGA054648
*d     DESTINATION               sy-pdest           "HGB177870"HGA054648
*d     COPIES                    sy-prcop           "HGB177870"HGA054648
*d     LIST NAME                 sy-plist           "HGB177870"HGA054648
*d     LIST DATASET              sy-prdsn           "HGB177870"HGA054648
*d     COVER TEXT                sy-prtxt           "HGB177870"HGA054648
*d     IMMEDIATELY               sy-primm           "HGB177870"HGA054648
*d     KEEP IN SPOOL             sy-prrel           "HGB177870"HGA054648
*d     NEW LIST IDENTIFICATION   sy-prnew           "HGB177870"HGA054648
*d     DATASET EXPIRATION        sy-pexpi           "HGB177870"HGA054648
*d     LINE-COUNT                62                           "HGA054648
*d     LINE-SIZE                 79                           "HGA054648
*d     LAYOUT                    'X_65_80'                    "HGA054648
*d     SAP COVER PAGE            sy-prbig           "HGB177870"HGA054648
*d     RECEIVER                  sy-prrec           "HGB177870"HGA054648
*d     DEPARTMENT                sy-prabt           "HGB177870"HGA054648
*d     WITH-TITLE                                             "HGA054648
*d     NO DIALOG.                                             "HGA054648
ENDFORM.


form prof_get_cmpl                                            "HGB020150
   changing
      c_prfsz LIKE klah-lbrei.

   CALL FUNCTION 'CLFC_GET_PROFILE'
        EXPORTING
             LISTID                = list_id
             PROFILE               = act_profil
        IMPORTING
             SIZE                  = c_prfsz
        TABLES
             T_PROFILE             = XDPROF
        EXCEPTIONS
             EMPTY_PROFILE         = 01
             LISTID_NOT_FOUND      = 02
             NO_VALID_LISTID       = 03
             NO_VALID_PROFILE      = 04
             PROFILE_NOT_FOUND     = 05
             PROFILE_NOT_IN_LISTID = 06.
endform.



form prrsv_tb_cre.                                            "HGB020150
   SORT XDPROF
     BY CLASS
        BLLIN.

   read table xdprof index 1.
   prrsv_tb-blnam = xdprof-class.
   prrsv_tb-maxln = xdprof-bllin.
   loop at xdprof.
     if prrsv_tb-blnam = xdprof-class.
       prrsv_tb-maxln = xdprof-bllin.
       continue.
     else.
       append prrsv_tb.
       prrsv_tb-blnam = xdprof-class.
       prrsv_tb-maxln = xdprof-bllin.
     endif.
   endloop.
   if sy-subrc = 0.
     append prrsv_tb.
   endif.

   sort prrsv_tb.
endform.


*eject
*---------------------------------------------------------------------*
*        READ_MAKT                                                    *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM READ_MAKT USING                                          "YHG079407
   LKL_MATNR LIKE MARA-MATNR                                  "YHG141209
   LKL_MAKTX LIKE MAKT-MAKTX.                                 "YHG141209
*  Kurztext zur Anmeldesprache besorgen
   SELECT SINGLE * FROM MAKT
      WHERE MATNR = LKL_MATNR
      AND   SPRAS = SY-LANGU.

*  Kurztext an Schnittstelle uebergeben
   LKL_MAKTX = MAKT-MAKTX.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        SEL_GRENZEN_03                                               *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM SEL_GRENZEN_03.
   IF PM_DATUV IS INITIAL.
      PM_DATUV = MIN_GRG.
   ENDIF.
*d DESCRIBE FIELD MAKT-MATNR LENGTH MNR_LNG.        "HGD051356"HGA080825
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        SET_MARGIN                                                   *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM SET_MARGIN.                                              "YHG066003
*d IF sy-ucomm NE 'CSPR'.
   IF SV_UCOMM NE 'CSPR'.                                   "note 351902
*del  WRITE: /1      TEXT-099.                                "YHG078090
      WRITE: /1      SY-VLINE, 81 SY-VLINE.                   "YHG078090
   ELSE.
      WRITE: /1      ' '.
   ENDIF.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        SINGLE_CLXPL_ON_OFF.                                         *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM SINGLE_CLXPL_ON_OFF.                                     "YHG079407
* --------------------------------
DATA: SCROLL_DIFF LIKE SY-LINNO.
* --------------------------------

*  Windows hat Probleme mit unterdrueckten Submodi (s. LSIND)
*  im Zusammenhang mit der HIDE-Option. Kurioserweise wird nach
*  entsprechender LINE-SELECTION (hier: CSCA) AT SY-UCOMM zweimal
*  prozessiert - einmal mit leerem HIDE-Bereich (falsch) und dann
*  richtig. Unter UNIX passiert das nicht.
*  Der folgende CHECK umgeht diesen Fehler.
   CHECK NOT SY-LISEL IS INITIAL.

*  Submodus verhindern
   SY-LSIND = SY-LSIND - 1 .

*  ?Klassendaten sitzen
*  nein
   IF     STB-CLASS IS INITIAL
      OR  STB-KLART IS INITIAL.
*     Cursor steht auf falsche Zeile
      MESSAGE S150.
      EXIT.
   ENDIF.

*  Teilkey der Klassenpositionentabelle
   CL_CLSTAB-CLASS = STB-CLASS.
   CL_CLSTAB-KLART = STB-KLART.

*  Klassenpositionentabelle lesen
   READ TABLE CL_CLSTAB
      WITH KEY CL_CLSTAB(21)
      BINARY SEARCH.

*  ?aktuelle Klassenposition in Klassenpositionentabelle
*  muss eigentlich
   IF SY-SUBRC = 0.
*     ?Zuordnungen sollen angezeigt werden
*     ja
      IF CL_CLSTAB-DSPLY IS INITIAL.
*        DisplayKz setzen
         CL_CLSTAB-DSPLY = 'x'.
*     nein, Zuordnungen sollen ausgeblendet werden
      ELSE.
*        DisplayKz zuruecknehmen
         CLEAR: CL_CLSTAB-DSPLY.
      ENDIF.

*     Eintrag in KlassenpositionenTab geaendert zurueckschreiben
      MODIFY CL_CLSTAB INDEX SY-TABIX.
   ENDIF.

*  Scroll-Seite ermitteln
   SCR_PAGNO = SY-CPAGE.

*  Scrolldiff. zum Seitenanfang ermitteln
*del SCROLL_DIFF = REAL_LINE MOD LINS_PER_PAG.                "YHG130360
*del SCROLL_DIFF = ( SCROLL_DIFF + 8 ) - SY-CUROW .           "YHG130360

*  Scrollzeile ermitteln
*del SCR_LINNO = REAL_LINE DIV LINS_PER_PAG .                 "YHG130360
*del SCR_LINNO = SCR_LINNO * LINS_PER_PAG + 1 + SCROLL_DIFF.  "YHG130360
   SCR_LINNO = SY-STARO.                                      "YHG130360

*  Liste erneut anzeigen (Zuordnungen ein- bzw. ausgeblendet)
   PERFORM NEU_ANZEIGE.

*  Anzeige positionieren
   SCROLL LIST INDEX 1 TO PAGE SCR_PAGNO LINE SCR_LINNO .
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        SUBRC_EXPLOR                                                 *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM SUBRC_EXPLR.
   CASE SY-SUBRC.
*     alles klar
      WHEN 0 .
         CLEAR: CSBOMEX.
         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.
*     Material nicht vorhanden
      WHEN 4 .
         CLEAR: CSBOMEX.
         CSBOMEX-RETCD = SY-SUBRC.
         CSBOMEX-MSGNO = '500'.
         CSBOMEX-MVAR1 = 'E:'.                                "YHG044860
         WRITE PM_MTNRV TO CSBOMEX-MVAR2.                     "YHG044860
         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.

         IF CAL_ACLAS NE 'CA  '.                              "YHG044860
            MESSAGE S500 WITH 'E: ' PM_MTNRV.
         ENDIF.                                               "YHG044860

         LEAVE.
*     Material im Werk nicht gepflegt
      WHEN 8 .
         CLEAR: CSBOMEX.
         CSBOMEX-RETCD = SY-SUBRC.
         CSBOMEX-MSGNO = '501'.
         CSBOMEX-MVAR1 = 'E:'.                                "YHG044860
         WRITE PM_MTNRV TO CSBOMEX-MVAR2.                     "YHG044860
         CSBOMEX-MVAR2 = PM_WERKS.                            "YHG044860
         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.

         IF CAL_ACLAS NE 'CA  '.                              "YHG044860
            MESSAGE S501 WITH 'E: ' PM_MTNRV PM_WERKS.
         ENDIF.                                               "YHG044860
         LEAVE.
*     Stl zu Mat/Werk/Verw. nicht vorhanden
      WHEN 12.
         CLEAR: CSBOMEX.
         CSBOMEX-RETCD = SY-SUBRC.
         CSBOMEX-MSGNO = '514'.
         CSBOMEX-MVAR1 = 'E:'.                                "YHG044860
         WRITE PM_MTNRV TO CSBOMEX-MVAR2.                     "YHG044860
         CSBOMEX-MVAR3 = PM_WERKS.                            "YHG044860
*del     EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.            "YHG044860

         IF NOT PM_STLAN IS INITIAL.
            CSBOMEX-MVAR4 = PM_STLAN.                         "YHG044860
            EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.         "YHG044860
            IF CAL_ACLAS NE 'CA  '.                           "YHG044860
               MESSAGE S514 WITH 'E: ' PM_MTNRV PM_WERKS PM_STLAN.
            ENDIF.                                            "YHG044860
         ELSE.
            CSBOMEX-MVAR4 = PM_CAPID.                         "YHG044860
            EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.         "YHG044860
            IF CAL_ACLAS NE 'CA  '.                           "YHG044860
               MESSAGE S514 WITH 'E: ' PM_MTNRV PM_WERKS PM_CAPID.
            ENDIF.                                            "YHG044860
         ENDIF.
         LEAVE.
*     Stl nicht gueltig
      WHEN 16.
*        ungueltig wg. Datum, LOEKZ od. Status

         CLEAR: CSBOMEX.
         CSBOMEX-RETCD = SY-SUBRC.
*del     CSBOMEX-MSGNO = '503'.                               "YHG044860
*del     EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.            "YHG044860

         IF NOT PM_DATUV EQ MIN_GRG.
            CSBOMEX-MSGNO = '503'.                            "YHG044860
            CSBOMEX-MVAR1 = 'E:'.                             "YHG044860
            WRITE PM_DATUV TO CSBOMEX-MVAR2 DD/MM/YYYY.       "YHG044860
            EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.         "YHG044860
*del        MESSAGE S503 WITH 'E: ' 'am' PM_DATUV.            "YHG036694
            IF CAL_ACLAS NE 'CA  '.                           "YHG044860
               MESSAGE S503 WITH 'E: ' PM_DATUV.              "YHG036694
            ENDIF.                                            "YHG044860
         ELSE.
            CSBOMEX-MSGNO = '505'.                            "YHG044860
            CSBOMEX-MVAR1 = 'E:'.                             "YHG044860
            EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.         "YHG044860
            IF CAL_ACLAS NE 'CA  '.                           "YHG044860
               MESSAGE S505 WITH 'E: '.
            ENDIF.                                            "YHG044860
         ENDIF.

         IF NOT STB-LOEKZ IS INITIAL.
            IF STB-LOEKZ = 'Y'.
               CLEAR: CSBOMEX.
               CSBOMEX-RETCD = 24.
               CSBOMEX-MSGNO = '517'.
               CSBOMEX-MVAR1 = 'E:'.                          "YHG044860
               EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.

               IF CAL_ACLAS NE 'CA  '.                        "YHG044860
                  MESSAGE S517 WITH 'E: ' .
               ENDIF.                                         "YHG044860
            ELSE.
               CLEAR: CSBOMEX.
               CSBOMEX-RETCD = 28.
               CSBOMEX-MSGNO = '516'.
               CSBOMEX-MVAR1 = 'E:'.                          "YHG044860
               EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.

               IF CAL_ACLAS NE 'CA  '.                        "YHG044860
                  MESSAGE S516 WITH 'E: ' .
               ENDIF.                                         "YHG044860
            ENDIF.
         ENDIF.
         LEAVE.
*     Alternative nicht vorhanden
      WHEN 24.
         HLP_STLAL = PM_STLAL.
         IF NOT STB-STLAL IS INITIAL.
            HLP_STLAL = STB-STLAL.
         ENDIF.

         CLEAR: CSBOMEX.
         CSBOMEX-RETCD = 32.
         CSBOMEX-MSGNO = '504'.
         CSBOMEX-MVAR1 = 'E:'.                                "YHG044860
         CSBOMEX-MVAR2 = HLP_STLAL.                           "YHG044860
         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.

         IF CAL_ACLAS NE 'CA  '.                              "YHG044860
            MESSAGE S504 WITH 'E: ' HLP_STLAL.
         ENDIF.                                               "YHG044860
         LEAVE.
*     keine Berechtigung zur Anzeige
      WHEN 28.
         CLEAR: CSBOMEX.
         CSBOMEX-RETCD = 36.
         CSBOMEX-MSGNO = '509'.
         CSBOMEX-MVAR1 = 'E:'.                                "YHG044860
         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.

         IF CAL_ACLAS NE 'CA  '.                              "YHG044860
            MESSAGE S509 WITH 'E: '.
         ENDIF.                                               "YHG044860
         LEAVE.
*     Stl zu AuftrNr/AuftrPos/Mat nicht vorhanden
      WHEN 32.                                                "HGA033687
         CLEAR: CSBOMEX.                                      "HGA033687
         CSBOMEX-RETCD = SY-SUBRC.                            "HGA033687
         CSBOMEX-MSGNO = '514'.                               "HGA033687
         CSBOMEX-MVAR1 = 'E:'.                                "HGA033687
         CSBOMEX-MVAR2 = PM_VBELN.                            "HGA033687
         WHILE PM_VBPOS(1) EQ '0'.                            "HGA033687
           SHIFT PM_VBPOS.                                    "HGA033687
         ENDWHILE.                                            "HGA033687
         CSBOMEX-MVAR3 = PM_VBPOS.                            "HGA033687
*d       write pm_mtnrv to csbomex-mvar4.           "HGA033687"HGC059252

         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.            "HGA033687
         IF CAL_ACLAS NE 'CA  '.                              "HGA033687
*d          message s514 with 'E: ' ... s pm_mtnrv. "HGA033687"HGC059252
            MESSAGE S514 WITH 'E: ' PM_VBELN PM_VBPOS.        "HGC059252
         ENDIF.                                               "HGA033687
         LEAVE.                                               "HGA033687

*     Konvertierungsfehler
      WHEN 36.                                                "HGD059252
         CLEAR: CSBOMEX.                                      "HGD059252
         CSBOMEX-RETCD = SY-SUBRC.                            "HGD059252
         CSBOMEX-MSGNO = '524'.                               "HGD059252
         CSBOMEX-MVAR1 = 'E:'.                                "HGD059252
         WRITE PM_MTNRV TO CSBOMEX-MVAR2.                     "HGD059252
         EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.            "HGD059252

         IF CAL_ACLAS NE 'CA  '.                              "HGD059252
            MESSAGE S524 WITH 'E: ' PM_MTNRV.                 "HGD059252
         ENDIF.                                               "HGD059252

         LEAVE.                                               "HGD059252

*     Stl zu PspNr/Mat/Werk/Verw. nicht vorhanden
      WHEN 40.                                                "HGA046836
         CLEAR: CSBOMEX.                                      "HGA046836
         CSBOMEX-RETCD = SY-SUBRC.                            "HGA046836
         CSBOMEX-MSGNO = '526'.                               "HGA046836
         CSBOMEX-MVAR1 = 'E:'.                                "HGA046836
         CSBOMEX-MVAR2 = pm_pspnr.                            "HGA046836
         WRITE PM_MTNRV TO CSBOMEX-MVAR3.                     "HGA046836
         CSBOMEX-MVAR4 = PM_WERKS.                            "HGA046836

         IF NOT PM_STLAN IS INITIAL.                          "HGA046836
            CSBOMEX-MVAR4+5 = PM_STLAN.                       "HGA046836
            EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.         "HGA046836
            IF CAL_ACLAS NE 'CA  '.                           "HGA046836
               MESSAGE S526                                   "HGA046836
                 WITH 'E: ' PM_PSPNR PM_MTNRV                 "HGA046836
                      PM_WERKS.                               "HGA046836
            ENDIF.                                            "HGA046836
         ELSE.                                                "HGA046836
            CSBOMEX-MVAR4+5 = PM_CAPID.                       "HGA046836
            EXPORT CSBOMEX TO MEMORY ID 'CSNN_BOMEX'.         "HGA046836
            IF CAL_ACLAS NE 'CA  '.                           "HGA046836
               MESSAGE S526                                   "HGA046836
                 WITH 'E: ' pm_pspnr PM_MTNRV                 "HGA046836
                      PM_WERKS.                               "HGA046836
            ENDIF.                                            "HGA046836
         ENDIF.                                               "HGA046836
         LEAVE.                                               "HGA046836
   ENDCASE.
ENDFORM.


FORM TXT_CONV_CHK                                           "note 306308
  tables
    txt structure tline
  using
    potx1 like stpo-potx1
    potx2 like stpo-potx2 .

data:
  shft like sy-index.

  describe table txt lines sy-tabix.
  if sy-tabix <> 0.
    loop at txt
* ^_NOTE_825334
*       where tdline cs '</>'.
        where tdline cs '</>'
          OR  tdformat cs '/(' .
* v_NOTE_825334

       exit.
    endloop.

    if sy-subrc = 0.
      CALL FUNCTION 'CONVERT_TEXT'
        EXPORTING
          FORMAT_TYPE = 'ASCII'
        TABLES
          foreign     = txt
          itf_lines   = txt.

*d    describe field txt-tdformat length shft.                       "uc
      describe field txt-tdformat                                    "uc
        length shft                                                  "uc
        in character mode.                                           "uc

      loop at txt.
        shift txt by shft places right.
        txt-tdformat = '*'.
        modify txt.
      endloop.
    endif.
  else.
     if   (     potx1 cs '<'
            and potx1 cs '>' )
       or (     potx2 cs '<'
            and potx2 cs '>' ) .

      txt-tdformat = '*'.
      txt-tdline = potx1.
      append txt.
      txt-tdline = potx2.
      append txt.

      CALL FUNCTION 'CONVERT_TEXT'
        EXPORTING
          FORMAT_TYPE = 'ASCII'
        TABLES
          foreign     = txt
          itf_lines   = txt.

*d    describe field txt-tdformat length shft.                       "uc
      describe field txt-tdformat                                    "uc
        length shft                                                  "uc
        in character mode.                                           "uc

      read table txt index 1.
        shift txt by shft places right.
        potx1 = txt-tdline.

      read table txt index 2.
        shift txt by shft places right.
        potx2 = txt-tdline.

      refresh:
        txt.
    endif.
  endif.
endform.


*eject
*---------------------------------------------------------------------*
*        VERWENDUNG_ANZEIGEN                                          *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM VERWENDUNG_ANZEIGEN.                                     "YHG080683
* ehem. Coding verlegt nach VERWENDUNG_ANZ_MAT

data:                                                       "note 539856
   cur_custcont type ref TO  CL_GUI_ALV_GRID.               "note 539856

* ---------------------------------
   CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'            "note 539856
     IMPORTING                                              "note 539856
       E_GRID                = cur_custcont                 "note 539856
     exceptions                                             "note 539856
       others                = 1 .                          "note 539856

   if not cur_custcont is initial.                          "note 539856
     call method                                            "note 539856
       cur_custcont->SET_VISIBLE( VISIBLE = ' ' ).          "note 539856
   endif.                                                   "note 539856

   IF     NOT STB-IDNRK IS INITIAL
      OR  NOT CLO_MATNR IS INITIAL.
      PERFORM VERWENDUNG_ANZ_MAT.

      if not cur_custcont is initial.                       "note 539856
        call method                                         "note 539856
          cur_custcont->SET_VISIBLE( VISIBLE = 'X' ).       "note 539856
      endif.                                                "note 539856

      EXIT.                                                   "YHG083093
   ENDIF.

   IF     NOT STB-DOKNR IS INITIAL.                           "YHG083093
      PERFORM VERWENDUNG_ANZ_DOC.                             "YHG083093

      if not cur_custcont is initial.                       "note 539856
        call method                                         "note 539856
          cur_custcont->SET_VISIBLE( VISIBLE = 'X' ).       "note 539856
      endif.                                                "note 539856

      EXIT.                                                   "YHG083093
   ENDIF.                                                     "YHG083093

   IF     NOT STB-CLASS IS INITIAL.                           "YHG083093
      PERFORM VERWENDUNG_ANZ_CLA.                             "YHG083093

      if not cur_custcont is initial.                       "note 539856
        call method                                         "note 539856
          cur_custcont->SET_VISIBLE( VISIBLE = 'X' ).       "note 539856
      endif.                                                "note 539856

      EXIT.                                                   "YHG083093
   ENDIF.                                                     "YHG083093

   MESSAGE S150.                                              "YHG083093
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        VERWENDUNG_ANZ_CLA                                           *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM VERWENDUNG_ANZ_CLA.                                      "YHG083093

   SUBMIT RCS15021
      WITH PM_CLASS INCL STB-CLASS
      WITH PM_KLART INCL STB-KLART
      WITH PM_WERKS INCL PM_WERKS
      WITH PM_STLAN INCL STB-STLAN
      WITH PM_DATUV INCL PM_DATUV
      WITH PM_DATUB INCL PM_DATUV
      WITH PM_GBRAZ INCL PM_GBRAZ
      WITH pm_alvsa INCL pm_alvsa                           "note 430354
      WITH pm_dsprf INCL pm_dsprf                           "note 430354
      WITH pm_prprf INCL pm_prprf                           "note 430354
      WITH PM_LTEXT INCL PM_LTEXT
      WITH PM_POSTP INCL PM_POSTP
      AND RETURN.

   PERFORM CLR_HIDE_AREA.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        VERWENDUNG_ANZ_DOC                                           *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM VERWENDUNG_ANZ_DOC.                                      "YHG083093

   SUBMIT RCS15011
      WITH PM_DOKNR INCL STB-DOKNR
      WITH PM_DOKAR INCL STB-DOKAR
      WITH PM_DOKTL INCL STB-DOKTL
      WITH PM_DOKVR INCL STB-DOKVR
      WITH PM_WERKS INCL PM_WERKS
      WITH PM_STLAN INCL STB-STLAN
      WITH PM_DATUV INCL PM_DATUV
      WITH PM_DATUB INCL PM_DATUV
*d    WITH PM_GBRAZ INCL PM_GBRAZ                             "HGA087938
      WITH pm_alvsa INCL pm_alvsa                           "note 430354
      WITH pm_dsprf INCL pm_dsprf                           "note 430354
      WITH pm_prprf INCL pm_prprf                           "note 430354
      WITH PM_LTEXT INCL PM_LTEXT
      WITH PM_POSTP INCL PM_POSTP
      WITH PM_DOCTP INCL 'x'                                  "YHG126159
      WITH PM_EQUTP INCL 'x'                                  "YHG126159
      WITH PM_MATTP INCL 'x'                                  "YHG126159
      WITH PM_STDTP INCL 'x'                                  "YHG126159
      WITH PM_TPLTP INCL 'x'                                  "YHG126159
      AND RETURN.

   PERFORM CLR_HIDE_AREA.
ENDFORM.


*eject
*---------------------------------------------------------------------*
*        VERWENDUNG_ANZ_MAT                                           *
*        ehem. VERWENDUNG_ANZEIGEN                                    *
*---------------------------------------------------------------------*
*        Input :                                                      *
*                                                                     *
*        Output:                                                      *
*                                                                     *
*---------------------------------------------------------------------*
FORM VERWENDUNG_ANZ_MAT.                                      "YHG080683
* ---------------------------------
DATA: LCL_MATNR LIKE MARA-MATNR.                              "YHG080683
* ---------------------------------
*del IF STB-IDNRK IS INITIAL.                       "YHG069035"YHG080683
*del    MESSAGE S150.                               "YHG069035"YHG080683
*del    CHECK NOT STB-IDNRK IS INITIAL.                       "YHG080683
*del ENDIF.                                         "YHG069035"YHG080683

   IF     NOT STB-IDNRK IS INITIAL.                           "YHG080683
      LCL_MATNR = STB-IDNRK.                                  "YHG080683
   ELSE.                                                      "YHG080683
      LCL_MATNR = CLO_MATNR.                                  "YHG080683
   ENDIF.                                                     "YHG080683

   SUBMIT RCS15001
*del  WITH PM_IDNRK INCL STB-IDNRK                            "YHG080683
      WITH PM_IDNRK INCL LCL_MATNR                            "YHG080683
*d    WITH pm_werks INCL pm_werks                             "HGA024434
      WITH PM_WERKS INCL STB-WERKS                            "HGA024434
      WITH PM_STLAN INCL STB-STLAN
      WITH PM_DATUV INCL PM_DATUV
      WITH PM_DATUB INCL PM_DATUV
      WITH PM_GBRAZ INCL PM_GBRAZ
      WITH pm_alvsa INCL pm_alvsa                           "note 430354
      WITH pm_dsprf INCL pm_dsprf                           "note 430354
      WITH pm_prprf INCL pm_prprf                           "note 430354
*     WITH PM_EMENG INCL STB-MNGLG
*     WITH PM_RMENG INCL RC29L-RMENG
      WITH PM_LTEXT INCL PM_LTEXT
      WITH PM_POSTP INCL PM_POSTP
      WITH PM_EQUTP INCL 'x'                                  "YHG126159
      WITH PM_MATTP INCL 'x'                                  "YHG126159
      WITH PM_STDTP INCL 'x'                                  "YHG126159
      WITH PM_TPLTP INCL 'x'                                  "YHG126159
      WITH PM_KNDTP INCL 'x'                                  "HGA024434
      AND RETURN.

   PERFORM CLR_HIDE_AREA.
ENDFORM.


FORM PARAMETER_ANZEIGEN.                                      "YHG139715
DATA: LCL_LNGTH LIKE SY-INDEX.
* ---------------------------------

   WINDOW STARTING AT 15 1
          ENDING   AT 79 8.

   SET PF-STATUS 'SNN1'.
   SET TITLEBAR 'A02'.
*d DESCRIBE FIELD DSP_SEL LENGTH LCL_LNGTH.                          "uc
   DESCRIBE FIELD DSP_SEL                                            "uc
     LENGTH LCL_LNGTH                                                "uc
     in character mode.                                              "uc

   NEW-PAGE LINE-SIZE LCL_LNGTH.
   FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.

   LOOP AT DSP_SEL.
      WRITE: / DSP_SEL.
   ENDLOOP.
ENDFORM.


FORM CREATE_DSP_SEL.                                          "YHG139715
DATA: LCL_COUNT LIKE SY-INDEX,
      ACT_REPID LIKE SY-REPID.

   REFRESH:  DSP_SEL,
             TXT_SEL.
   READ TEXTPOOL SY-REPID INTO TXT_SEL.

   ACT_REPID = SY-REPID.
   CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
        EXPORTING
             CURR_REPORT     = ACT_REPID
        TABLES
             SELECTION_TABLE = INP_SEL
        EXCEPTIONS
             NOT_FOUND       = 01
             NO_REPORT       = 02.

*d LOOP AT INP_SEL.                                           "HGC154389
*d    CHECK INP_SEL-SELNAME NE 'PM_HEMNG'.          "YHG032486"HGC154389

   LOOP AT INP_SEL                                            "HGC154389
      WHERE SELNAME NE 'PM_HEMNG'.                            "HGC154389

*d    LOOP AT TXT_SEL.                                        "HGC154389
*del    IF     INP_SEL-SELNAME EQ TXT_SEL-ID+1                "YHG032486
*del       AND INP_SEL-SELNAME NE 'PM_HEMNG'.                 "YHG032486
*d      CHECK INP_SEL-SELNAME EQ TXT_SEL-ID+1.      "YHG032486"HGC154389

      LOOP AT TXT_SEL                                         "HGC154389
*d       WHERE ID+1 EQ INP_SEL-SELNAME.                    "HGC154389"uc
         WHERE key EQ INP_SEL-SELNAME.                               "uc

*d         ASSIGN (TXT_SEL-ID+1) TO <PM_NAME>.                       "uc
           ASSIGN (TXT_SEL-key) TO <PM_NAME>.                        "uc
           IF NOT <PM_NAME> IS INITIAL.                              "uc
*D            DSP_SEL-TEXT = TXT_SEL-TEXT+8.                         "uc
              DSP_SEL-TEXT = TXT_SEL-entry.                          "uc

*del          CLEAR: LCL_COUNT.                               "YHG032486
              CLEAR: LCL_COUNT,                               "YHG032486
                     TMP_CNT.                                 "YHG032486

*del          WHILE DSP_SEL-TEXT+28(2) IS INITIAL.            "YHG032486
*del             DSP_SEL-TEXT+29(1) = '_'.                    "YHG032486
*del             SHIFT DSP_SEL-TEXT CIRCULAR RIGHT.           "YHG032486
*del             LCL_COUNT = LCL_COUNT + 1.                   "YHG032486
*del          ENDWHILE.                                       "YHG032486
*del          SHIFT DSP_SEL-TEXT                              "YHG032486
*del             BY LCL_COUNT PLACES CIRCULAR LEFT.           "YHG032486

              TMP_CNT = STRLEN( DSP_SEL-TEXT ).               "YHG032486
              IF TMP_CNT <= I28.                              "YHG032486
                 TMP_CNT = TMP_CNT + 1.                       "YHG032486
                 LCL_COUNT = 30 - TMP_CNT.                    "YHG032486
                 DSP_SEL-TEXT+TMP_CNT = SHORTLN(LCL_COUNT).   "YHG032486
              ENDIF.                                          "YHG032486

              DSP_SEL-WERT = INP_SEL-LOW.

ENHANCEMENT-POINT CREATE_DSP_SEL_01 SPOTS ES_RCSNN001 INCLUDE BOUND.
              IF INP_SEL-SELNAME EQ 'PM_DATUV'.
                 CLEAR: DSP_SEL-WERT.
                 WRITE PM_DATUV TO DSP_SEL-WERT.
              ENDIF.

              IF     INP_SEL-SELNAME EQ 'PM_EMENG'
                 AND NOT PM_EMENG IS INITIAL.

                 CLEAR: DSP_SEL-WERT.
*d               WRITE pm_emeng TO dsp_sel-wert.              "HGA033347
                 WRITE PM_EMENG TO DSP_SEL-WERT DECIMALS 3.   "HGA033347
                 WHILE DSP_SEL-WERT(1) EQ SPACE.
                    SHIFT DSP_SEL-WERT LEFT.
                 ENDWHILE.
              ENDIF.

              APPEND DSP_SEL.
           ENDIF.
*del    ENDIF.                                                "YHG032486
      ENDLOOP.
   ENDLOOP.

   SORT DSP_SEL BY TEXT.

   CHECK NOT ECM_SL[] IS INITIAL.                             "HGB059252

   REFRESH:                                                   "HGB059252
     DSP_SEL2.                                                "HGB059252

   CLEAR: DSP_SEL.                                            "HGB059252
   DSP_SEL-TEXT = '_'.                                        "HGB059252
   APPEND DSP_SEL.                                            "HGB059252

   DSP_SEL-TEXT = TEXT-020.                                   "HGB059252
   APPEND DSP_SEL.                                            "HGB059252

   LOOP AT ECM_SL INTO WA_ECM_SL.                             "HGB059252
      CHECK NOT WA_ECM_SL-VALUE IS INITIAL.                   "HGB059252
      CHECK NOT WA_ECM_SL-FIELDNAME EQ 'DATE_LO'.             "HGB059252

      DSP_SEL2-TEXT = WA_ECM_SL-TEXT.                         "HGB059252

      CLEAR: LCL_COUNT,                                       "HGB059252
             TMP_CNT.                                         "HGB059252

      TMP_CNT = STRLEN( DSP_SEL2-TEXT ).                      "HGB059252
      IF TMP_CNT <= I28.                                      "HGB059252
         TMP_CNT = TMP_CNT + 1.                               "HGB059252
         LCL_COUNT = 30 - TMP_CNT.                            "HGB059252
         DSP_SEL2-TEXT+TMP_CNT = SHORTLN(LCL_COUNT).          "HGB059252
      ENDIF.                                                  "HGB059252

      DSP_SEL2-WERT = WA_ECM_SL-VALUE.                        "HGB059252
      APPEND DSP_SEL2.                                        "HGB059252
   ENDLOOP.                                                   "HGB059252

   APPEND LINES OF DSP_SEL2 TO DSP_SEL.                       "HGB059252
ENDFORM.


FORM SELKRIT_DRUCK.
   CHECK NOT TCSPR-PRSEL IS INITIAL.                          "HGA127128

   CLEAR: STB_ADD.
   WRITE TEXT-050 TO STB_ADD-TLINE(76).

   FORMAT COLOR COL_BACKGROUND INTENSIFIED ON.

   CLEAR: WATAB. REFRESH WATAB.

*d WATAB-TNAME = 'STPOL_ADD'. WATAB-TABLE = STB_ADD .                "uc
   WATAB-TNAME = 'STPOL_ADD'.                                        "uc
   assign watab-table to <x_watab-table>  casting.                   "uc
   assign stb_add     to <x_stpol_add_wa> casting.                   "uc
   <x_watab-table> = <x_stpol_add_wa> .                              "uc

   APPEND WATAB.
   CLEAR: WATAB.

   PERFORM WRITE_BLOCK
      USING 'SEL_GNRL_HDNG     '
*            ausgegebene Zeilen nicht zaehlen
             ' '
*            Hide ausfuehren
             ' '.                                             "YHG123656

   FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
   LOOP AT DSP_SEL.
      STB_ADD-SELNM = DSP_SEL(32).
      TRANSLATE STB_ADD-SELNM USING '_ '.
      STB_ADD-SELVL = DSP_SEL-WERT.

      CLEAR: WATAB. REFRESH WATAB.

*d    WATAB-TNAME = 'STPOL_ADD'. WATAB-TABLE = STB_ADD .             "uc
      WATAB-TNAME = 'STPOL_ADD'.                                     "uc
      assign watab-table to <x_watab-table>  casting.                "uc
      assign stb_add     to <x_stpol_add_wa> casting.                "uc
      <x_watab-table> = <x_stpol_add_wa> .                           "uc

      APPEND WATAB.
      CLEAR: WATAB.

      PERFORM WRITE_BLOCK
         USING 'SEL_PARAM         '
*              ausgegebene Zeilen nicht zaehlen
               ' '
*              Hide ausfuehren
               ' '.                                           "YHG123656
   ENDLOOP.
   NEW-PAGE.
ENDFORM.


FORM ECM_PROC_INIT                                            "HGA084505
   USING
      LKL_MATNR LIKE MARA-MATNR                               "HGA059252
      LKL_TECHS TYPE C.

   IF TCC08-AGBCC IS INITIAL.
      TCC08-AGBCC = 'CC'.
      READ TABLE TCC08.
   ENDIF.

*d if     not tcc08-vtnew is initial                          "HGB069822
*d    or  not tcc08-rlact is initial.                         "HGB069822

      CLEAR: MTCOM.
*d    mtcom-matnr = pm_mtnrv.                                 "HGA059252
      MTCOM-MATNR = LKL_MATNR.                                "HGA059252

      MTCOM-KENNG = 'MC29M'.

      MTCOM-SPRAS = SY-LANGU.
      MTCOM-NOVOR = 'X'.

      CALL FUNCTION 'MATERIAL_READ'
         EXPORTING  SCHLUESSEL = MTCOM
         IMPORTING  RETURN     = MTCOR
                    MATDATEN   = MC29M
         TABLES     SEQMAT01   = DUMMYTAB
         EXCEPTIONS MATERIAL_NOT_FOUND = 4
                    PLANT_NOT_FOUND    = 8 .


      IF NOT MC29M-KZEFF IS INITIAL.
         IF LKL_TECHS IS INITIAL.
            SPARAM-FIELDNAME = 'DATE_LO'.
            SPARAM-VALUE = PM_DATUV.
            APPEND SPARAM TO PARAM.
         ENDIF.

         CALL FUNCTION 'ECM_PROCESSOR_INIT'
              EXPORTING
                   TOPMATNR            = LKL_MATNR            "HGB142493
                   E_TECHS             = LKL_TECHS
                   DEFAULT_TECHS       = 'X'
                   FREIG_KALKULATION   = 'X'
                   FREIG_PLANUNG       = 'X'
                   FREIG_FERTIGUNG     = 'X'
                   FREIG_EINGABEBEREIT = 'X'
                   BATCHLAUF           = SYST-BATCH
              TABLES
                   VALID_OR_INVALID = CCVAL
                   PARAMETER        = PARAM
                   OUTPUT_PARAMETER = ECM_SL                  "HGB059252
              EXCEPTIONS
                   exit_in_dynpro   = 4                       "HGB195880
                   OTHERS           = 0.

        if sy-subrc = 4.                                      "HGB195880
           leave.                                             "HGB195880
        endif.                                                "HGB195880
      ENDIF.
*d endif.                                                     "HGB069822
ENDFORM.


form werks_best                                             "note 353640
  using                                                     "note 353640
    i_matnr like mara-matnr                                 "note 353640
  changing                                                  "note 353640
    c_werks like marc-werks.                                "note 353640
*..................................

DATA: BEGIN OF DUMMYTAB OCCURS 0,                           "note 353640
        DUMMY1,                                             "note 353640
      END OF DUMMYTAB.                                      "note 353640

TABLES:                                                     "note 353640
  MC29S,                                                    "note 353640
  t460A.                                                    "note 353640
*..................................

  CLEAR: MTCOM.                                             "note 353640
  MTCOM-MATNR = i_matnr.                                    "note 353640
  MTCOM-WERKS = c_werks.                                    "note 353640
  MTCOM-KENNG = 'MC29S'.                                    "note 353640
  MTCOM-NOPLTRS = 'X'.                                      "note 353640

  CALL FUNCTION 'MATERIAL_READ'                             "note 353640
    EXPORTING  SCHLUESSEL = MTCOM                           "note 353640
    IMPORTING  RETURN     = MTCOR                           "note 353640
               MATDATEN   = MC29S                           "note 353640
    TABLES     SEQMAT01   = DUMMYTAB                        "note 353640
    EXCEPTIONS MATERIAL_NOT_FOUND = 4                       "note 353640
               PLANT_NOT_FOUND    = 8 .                     "note 353640

  if    sy-subrc = 0                                        "note 353640
    and not mc29s-sobsl is initial.                         "note 353640

    CLEAR:                                                  "note 353640
      T460A.                                                "note 353640

    SELECT SINGLE * FROM T460A                              "note 353640
      WHERE WERKS EQ MC29S-WERKS                            "note 353640
      AND   SOBSL EQ MC29S-SOBSL.                           "note 353640

    check sy-subrc = 0.                                     "note 353640

    if not t460a-rewfg is initial.                          "note 353640
      c_werks = t460a-rewfg.                                "note 353640
    elseif t460a-sobes eq 'P'.                              "note 353640
      c_werks = t460a-wrk02.                                "note 353640
    endif.                                                  "note 353640
  endif.                                                    "note 353640
endform.                                                    "note 353640
