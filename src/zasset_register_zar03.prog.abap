
*&-----------------------------------------------------------------------------------------------------------*
*& Program Owner          : Primus TechSystems Pvt.Ltd.
*& Description            : Custom Asset Report ( AR03 Standard Report with addition of new fields)
*& T-code                 : ZAR03
*& Creation Date          : 06.06.2018
*& Developer Name         : Sneha Meshram
*& Functional Consultant  : Sujatha Bankhele,Ashish Patil,Rakesh Jawale, Vijay Ubhe.
*& Request No             : DEVK905824

*&-----------------------------------------------------------------------------------------------------------*

REPORT ZASSET_DEPRC MESSAGE-ID AB
                    LINE-SIZE 130
                    NO STANDARD PAGE HEADING.

TYPE-POOLS : SLIS .

DATA : WA_LAYOUT TYPE SLIS_LAYOUT_ALV .

NODES: ANLA0,
       ANLAV,
       ANLB,
       ANEK,
       ANEPV,
       ANLCV.

TABLES: ANLH.

* FIELDS-Anweisungen.
INCLUDE YRASORT00.

* Allgemeine DATA-, TABLES-, ... Anweisungen.
INCLUDE YRASORT_ALV04.
INCLUDE YRASORT_ALV_DATA_FIELDCAT.

DATA:
*     Anzahl der im Anforderungsbild erlaubten AfA-Bereiche.
      SAV_ANZBE(1) TYPE C VALUE '1',
*     Flag: Postenausgabe Ja='1'/Nein='0'.
      FLG_POSTX(1) TYPE C VALUE '0',
*     Summenbericht: Maximale Anzahl Wertfelder/Zeile.
      CON_WRTZL(2) TYPE P VALUE 3.

* Ausgabe-Wertfelder.
DATA: BEGIN OF X,
*       Kumulierter Anschaffungswert.
        KANSW      LIKE ANLCV-KANSW,
        KANSW2     LIKE ANLCV-KANSW,
*       Kumulierter Anschaffungwert Gesch�ftsjahresende
        GJE_KANSW  LIKE ANLCV-KANSW,                        "> 541822
*       Kumulierte N-AfA.
        KNAFA      LIKE ANLCV-KNAFA,
        KNAFA2     LIKE ANLCV-KNAFA,
*       Kumulierte S-AfA.
        KSAFA      LIKE ANLCV-KSAFA,
*       Kumulierte A-AfA.
        KAAFA      LIKE ANLCV-KAAFA,
*       Kumulierte M-AfA.
        KMAFA      LIKE ANLCV-KMAFA,
*       Kumulierter Buchwert GJ-Beginn.
        GJA_BCHWRT LIKE ANLCV-GJA_BCHWRT,
*       Bewegungen auf Anschaffungswert.
        ANSWL      LIKE ANLCV-ANSWL,
        ANSWL2     LIKE ANLCV-ANSWL,                        ">383021
*       Geplante N-AfA.
        NAFAP      LIKE ANLCV-NAFAP,
        NAFAP2     LIKE ANLCV-NAFAP,
*       Geplante S-AfA.
        SAFAP      LIKE ANLCV-SAFAP,
*       Geplante A-AfA.
        AAFAP      LIKE ANLCV-AAFAP,
*       Geplante M-AfA.
        MAFAP      LIKE ANLCV-MAFAP,
*       Zuschreibungen N-AfA + S-AfA + A-AfA + M-AfA.
        ZUSNA      LIKE ANLCV-ZUSNA,
*       Bewegungen auf Wertberichtigungen N.
        NABWB      LIKE ANLCV-NAFAV,
        NABWB2     LIKE ANLCV-NAFAV,
*       Bewegungen auf Wertberichtigungen S.
        SABWB      LIKE ANLCV-SAFAV,
*       Bewegungen auf Wertberichtigungen A.
        AABWB      LIKE ANLCV-AAFAV,
*       Bewegungen auf Wertberichtigungen M.
        MABWB      LIKE ANLCV-MAFAV,
*       Buchwert GJ-Ende.
        GJE_BCHWRT LIKE ANLCV-GJE_BCHWRT,
      END OF X.

* Sortier-Wertfelder.
DATA: BEGIN OF SORT,
*       Anschaffungswert GJ-Ende.
        GJE_KANSW   LIKE ANLCV-GJE_KANSW,
*       Buchwert GJ-Ende.
        GJE_BCHWRT  LIKE ANLCV-GJE_BCHWRT,
*       Gesamte geplante AfA/geplante N-AfA.
        NAFAP       LIKE ANLCV-NAFAP,
*       Geplante S-AfA.
        SAFAP       LIKE ANLCV-SAFAP,
*       Geplante A-AfA.
        AAFAP       LIKE ANLCV-AAFAP,
*       Geplante M-AfA.
        MAFAP       LIKE ANLCV-MAFAP,
      END OF SORT.

* Definition der internen Tabelle f�r den ALV
*DATA: itab_data LIKE fiaa_salvtab_rahafa OCCURS 10 WITH HEADER LINE.

" SHREYAS
TYPES : BEGIN OF TY_ANLA,
          BUKRS TYPE ANLA-BUKRS,
          ANLN1 TYPE ANLA-ANLN1,
          ANLN2 TYPE ANLA-ANLN2,
          ANLKL TYPE ANLA-ANLKL,   " CHANGE
          KTOGR TYPE ANLA-KTOGR,
          HERST TYPE ANLA-HERST,
          INVNR TYPE ANLA-INVNR,
          TXT50 TYPE ANLA-TXT50,
          TXA50 TYPE ANLA-TXA50,               "Added by Komal M. on 06-09-2024.
          SERNR TYPE ANLA-SERNR,
          DEAKT TYPE ANLA-DEAKT,                "ADDED BY KOMAL M. on 04-09-2014
        END OF TY_ANLA.
DATA : WA_ANLA TYPE TY_ANLA .

TYPES : BEGIN OF TY_T095,
          KTOGR TYPE T095-KTOGR,
          KTANSW TYPE T095-KTANSW,
        END OF TY_T095.
DATA : WA_T095 TYPE TY_T095.

TYPES : BEGIN OF TY_T095B,
          KTOGR  TYPE T095B-KTOGR,
          KTNAFB TYPE T095B-KTNAFB,
          KTNAFG TYPE T095B-KTNAFG,
        END OF TY_T095B.
DATA : WA_T095B TYPE TY_T095B.

TYPES : BEGIN OF TY_SKAT,
          SAKNR TYPE SKAT-SAKNR,
          TXT50 TYPE SKAT-TXT50,
        END OF TY_SKAT.
DATA : WA_SAPNAMEDR TYPE TY_SKAT .
DATA : WA_SAPNAMECR TYPE TY_SKAT .

TYPES : BEGIN OF TY_ANLH,
          BUKRS TYPE ANLH-BUKRS,
          ANLN1 TYPE ANLH-ANLN1,
          ANLHTXT TYPE ANLH-ANLHTXT,
        END OF TY_ANLH.
DATA : WA_ANLH TYPE TY_ANLH.

TYPES : BEGIN OF TY_ANEP,
          BUKRS TYPE ANEP-BUKRS,
          ANLN1 TYPE ANEP-ANLN1,
          ANLN2 TYPE ANEP-ANLN2,
          GJAHR TYPE ANEP-GJAHR,
          AFABE TYPE ANEP-AFABE,
          BWASL TYPE ANEP-BWASL,
          ANBTR TYPE ANEP-ANBTR,
        END OF TY_ANEP.
DATA : IT_ANEP_ADD TYPE TABLE OF TY_ANEP WITH HEADER LINE.
DATA : IT_ANEP_SUB TYPE TABLE OF TY_ANEP WITH HEADER LINE.

TYPES : BEGIN OF TY_TABW,
          BWASL TYPE TABW-BWASL,
          GITTGR TYPE TABW-GITTGR,
        END OF TY_TABW.
DATA : IT_TABW_ADD TYPE TABLE OF TY_TABW WITH HEADER LINE.
DATA : IT_TABW_SUB TYPE TABLE OF TY_TABW WITH HEADER LINE.

TYPES : BEGIN OF TY_ANLZ,
          BUKRS TYPE ANLZ-BUKRS,
          ANLN1 TYPE ANLZ-ANLN1,
          ANLN2 TYPE ANLZ-ANLN1,
          GSBER TYPE ANLZ-GSBER,
          MSFAK TYPE ANLZ-MSFAK,
        END OF TY_ANLZ.
DATA : WA_ANLZ TYPE TY_ANLZ.

DATA : IT_MORTGAGE TYPE TABLE OF ZMORTGAGE WITH HEADER LINE .


***************************************added by Sp***********
TYPES: BEGIN OF ty_ankt,
       ANLKL TYPE ankt-anlkl,
       TXK20 TYPE ankt-txk20,
      END OF ty_ankt.

DATA : WA_ANkt TYPE TY_ANkt,
      it_ankt  TYPE TABLE OF ty_ankt.

**********************************************************


TYPES : BEGIN OF TY_ITAB.

        INCLUDE STRUCTURE FIAA_SALVTAB_RAHAFA.
TYPES :

        NAME1            TYPE LFA1-NAME1,
        HERST            TYPE ANLA-HERST,
        INVNR            TYPE ANLA-INVNR,
        SERNR            TYPE ANLA-SERNR,
        DEAKT            TYPE ANLA-DEAKT,                              "Added by KOMAL M. on 04-09-2024
        KTNAFB           TYPE T095B-KTNAFB,
        KTNAFG           TYPE T095B-KTNAFG,
        SAPNAMEDR        TYPE SKAT-TXT50,
        SAPNAMECR        TYPE SKAT-TXT50,

        TXA50_1  TYPE ANLA-TXA50,                                         "added by Komal M on 06-09-2024
        ANLHTXT          TYPE ANLH-ANLHTXT,
*       During Year Addition & Deletion
        YR_ADD_AMT       TYPE ANEP-ANBTR,
        YR_SUB_AMT       TYPE ANEP-ANBTR,

*       ZMORTGAGE table fields
        MORT_DETAILS     TYPE ZMORTGAGE-MORT_DETAILS,
        ZZIMPDOM         TYPE ZMORTGAGE-ZZIMPDOM    ,
        ZZMEGAREM        TYPE ZMORTGAGE-ZZMEGAREM   ,
        ZZVAL_REMARK     TYPE ZMORTGAGE-ZZVAL_REMARK,
        ZZEXCL_CHRG      TYPE ZMORTGAGE-ZZEXCL_CHRG ,

*       ZASSET_DETAILS table fields
        ASSET_NAME_OLD   TYPE ZASSET_DETAILS-ASSET_NAME_OLD    ,
        INVNO            TYPE ZASSET_DETAILS-INVNO             ,
        INVDATE          TYPE ZASSET_DETAILS-INVDATE           ,
        PUR_AMT          TYPE ZASSET_DETAILS-PUR_AMT           ,
        OTHERCOST        TYPE ZASSET_DETAILS-OTHERCOST         ,
        CAPCOST          TYPE ZASSET_DETAILS-CAPCOST           ,
        INST_CHRG_AMT    TYPE ZASSET_DETAILS-INST_CHRG_AMT     ,
        DUTY_AMT         TYPE ZASSET_DETAILS-DUTY_AMT          ,
        FREIGHT_AMT      TYPE ZASSET_DETAILS-FREIGHT_AMT       ,
        CLEARING_AMT     TYPE ZASSET_DETAILS-CLEARING_AMT      ,
        INTEREST_AMT     TYPE ZASSET_DETAILS-INTEREST_AMT      ,
        RTO_AMT          TYPE ZASSET_DETAILS-RTO_AMT           ,
        INSURANCE_AMT    TYPE ZASSET_DETAILS-INSURANCE_AMT     ,
        VAT_DISALLWD_AMT TYPE ZASSET_DETAILS-VAT_DISALLWD_AMT  ,
        SRVPRMINT_AMT    TYPE ZASSET_DETAILS-SRVPRMINT_AMT     ,
        SITEDEVDEP_AMT   TYPE ZASSET_DETAILS-SITEDEVDEP_AMT    ,
        FERDCAP_AMT      TYPE ZASSET_DETAILS-FERDCAP_AMT       ,
        FEE              TYPE ZASSET_DETAILS-FEE               ,
        TOTALCOST        TYPE P DECIMALS 2                     ,
        CHECK_ASSET_VAL  TYPE P DECIMALS 2                     ,
        DEPRIRATE        TYPE ZASSET_DETAILS-DEPRIRATE         ,
        WDV_VALUE        TYPE ZASSET_DETAILS-WDV_VALUE         ,
        DISPOS           TYPE ZASSET_DETAILS-DISPOS            ,
        GAT_NO           TYPE ZASSET_DETAILS-GAT_NO            ,
        AREA_HECT        TYPE ZASSET_DETAILS-AREA_HECT         ,
        AREA_ACRE        TYPE ZASSET_DETAILS-AREA_ACRE         ,
        SAPFIDOC         TYPE ZASSET_DETAILS-SAPFIDOC          ,
        MIRONO           TYPE ZASSET_DETAILS-MIRONO            ,
        FURN_OFFI        TYPE ZASSET_DETAILS-FURN_OFFI         ,
        FC               TYPE ZASSET_DETAILS-FC                ,
        FC_RATE          TYPE ZASSET_DETAILS-FC_RATE           ,
        FC_AMT           TYPE ZASSET_DETAILS-FC_AMT            ,
        VAT              TYPE ZASSET_DETAILS-VAT               ,
        CENVAT           TYPE ZASSET_DETAILS-CENVAT            ,
        CST              TYPE ZASSET_DETAILS-CST               ,
        SERV_TAX         TYPE ZASSET_DETAILS-SERV_TAX          ,
        AST_GRP          TYPE ZASSET_DETAILS-AST_GRP           ,
        BUCAT            TYPE ZASSET_DETAILS-BUCAT             ,
        SEGMENT1         TYPE ZASSET_DETAILS-SEGMENT1          ,
        BU_JPK           TYPE ZASSET_DETAILS-BU_JPK            ,
        LOCATION_JPK     TYPE ZASSET_DETAILS-LOCATION_JPK      ,
        MACHINFROM       TYPE ZASSET_DETAILS-MACHINFROM        ,
        MACHINTO         TYPE ZASSET_DETAILS-MACHINTO          ,
        FAYEAR           TYPE ZASSET_DETAILS-FAYEAR            ,
        BKGDATE          TYPE ZASSET_DETAILS-BKGDATE           ,
        BUCODE           TYPE ZASSET_DETAILS-BUCODE            ,
        BUNAME           TYPE ZASSET_DETAILS-BUNAME            ,
        SEGMENT2         TYPE ZASSET_DETAILS-SEGMENT2          ,
        SEGNAME          TYPE ZASSET_DETAILS-SEGNAME           ,
        REMARK_1         TYPE ZASSET_DETAILS-REMARK_1          ,
        REMARK_2         TYPE ZASSET_DETAILS-REMARK_2          ,
        REMARK_3         TYPE ZASSET_DETAILS-REMARK_3          ,
        REMARK_4         TYPE ZASSET_DETAILS-REMARK_4          ,
        REMARK_5         TYPE ZASSET_DETAILS-REMARK_5          ,
        REMARK_6         TYPE ZASSET_DETAILS-REMARK_6          ,
        MSFAK            TYPE ANLZ-MSFAK                       ,
        APROP            TYPE ANLB-APROP                       ,
        SCHRW_PROZ       TYPE ANLB-SCHRW_PROZ                  ,
        TXK20            type ankt-TXK20                       ,
        END OF TY_ITAB.
" SHREYAS
DATA : ITAB_DATA TYPE TABLE OF TY_ITAB WITH HEADER LINE,
       ITAB_DATA1 TYPE ZASSET_DETAILS.


SELECTION-SCREEN BEGIN OF BLOCK BL0 WITH FRAME TITLE TEXT-BL0.
PARAMETERS: P_VARI TYPE DISVARIANT-VARIANT,
            P_GRID TYPE XGRID DEFAULT 'X' .    " Shreyas
SELECTION-SCREEN END OF BLOCK BL0.

SELECTION-SCREEN BEGIN OF BLOCK BL1                        "AB
                 WITH FRAME                                "AB
                 TITLE TEXT-BL1.                           "AB

SELECT-OPTIONS:
*               Anlagenbestandkonto.
              SO_KTANW FOR ANLAV-KTANSW NO DATABASE SELECTION,
*               Aktivierungsdatum.
              SO_AKTIV FOR ANLAV-AKTIV,
*               AfA-Schluessel.
              SO_AFASL FOR ANLB-AFASL,
*               Anschaffungswert.
              SO_KANSW FOR SORT-GJE_KANSW,
*               Geplante gesamte AfA/geplante N-AfA.
              SO_NAFAP FOR SORT-NAFAP,
*               Buchwert.
              SO_BCHWR FOR SORT-GJE_BCHWRT.
SELECTION-SCREEN END   OF BLOCK BL1.                       "AB

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK BL2                        "AB
                 WITH FRAME                                "AB
                 TITLE TEXT-BL2.                           "AB
PARAMETERS:

*           Sonder-AfA-Arten getrennt ausweisen.
          PA_SOAFA LIKE RAREP-SOAFA,
*           Simulationsvariante.
          PA_SIMVR  LIKE RBADA-SIMVAR.
SELECTION-SCREEN END   OF BLOCK BL2.                       "AB

SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK BL4                       "AB
                 WITH FRAME                                "AB
                 TITLE TEXT-C03.                           "AB
PARAMETERS:

*           Zusatzueberschrift.
          PA_TITEL LIKE RAREP-TITEL DEFAULT SPACE,
*           Flag: Listseparation gemaess Tabelle TLSEP.
*            pa_lssep LIKE bhdgd-separ,              "no 394136
*           Flag: Mikrofichezeile ausgeben.
          PA_MIKRO LIKE BHDGD-MIFFL.
SELECTION-SCREEN END   OF BLOCK BL4.                       "AB


INITIALIZATION.
* Sortiervariante vorschlagen.
  MOVE: '0001' TO SRTVR.
* ALV Grid NICHT als Standard vorschlagen
*  MOVE: ' '    TO p_grid.

* Report wird nicht von au�en aufgerufen. Lesen der PickUp-Informationen
* aus dem Memory d.h. der urspr�nglich eingegebenen Programmabgrenzungen
  IMPORT FLG_NOT_FIRST FROM MEMORY ID 'flg'.

* Allgemeine Verarbeitung der PA/SO-Eingaben.
  INCLUDE YRASORT_ALV08.

* Process on value request
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_VARI.
  PERFORM VARIANTEN_AUSWAHL CHANGING P_VARI.

AT SELECTION-SCREEN OUTPUT.
* Ausblenden des Feldes XUNTNR und des dazugeh�rigen Textfeldes
*  PERFORM felder_ausblenden USING 'XUNTNR' '%F301122_1000'.  no 332180
*

*--------------------------- START OF SELECTION ------------------------------------------*

START-OF-SELECTION.

  SET PF-STATUS 'ZPF_DWD_YAR03'.
* Sichern der Selektionsoptionen bzw. Einlesen der Sortierwerte bei
* PickUp.
  PERFORM INFO_PICK_UP.

* PF-Status setzen.
* SET PF-STATUS 'LIST'.

* K e i n e  automatischen Unterstrichzeilen bei getrenntem Ausweis
* von S-AfA.
  IF PA_SOAFA NE SPACE.
    FLG_ENDULINE = OFF.
  ENDIF.


* Sonder-AfA-Arten getrennt ausweisen ==> 6 statt 3 Wertspalten.
  IF PA_SOAFA NE SPACE.
    CON_WRTZL = 6.
  ENDIF.

* Bestimmung des Sortierfeldes auf unterster Gruppenstufe.
  ASSIGN SAV_DUMMY TO <B>.

* Bestimmung des Sortierfeldes fuer Gitterposition oder Einzelposten.
  ASSIGN SAV_DUMMY TO <P>.
  ASSIGN SAV_DUMMY TO <Q>.

* Allgemeines Coding nach START-OF-SELECTION. Aufbau des HEADERs.
  INCLUDE YRASORT_ALV10.

*INSERT
**        Daten zur Anlage.
*         ANLAV-ANLN0
*         ANLAV-ANLN1        ANLAV-ANLN2        ANLAV-WERKS
*         ANLAV-TXT50        ANLAV-KOSTL        ANLAV-STORT
*         ANLAV-POSNR        ANLAV-AKTIV        ANLAV-LIFNR
*         ANLAV-MENGE        ANLAV-MEINS        ANLAV-TXA50
*         ANLAV-ANLHTXT      ANLAV-XANLGR
**        Daten zum AfA-Bereich.
*         ANLB-AFASL         ANLB-AFABG         ANLB-SAFBG
*         ANLB-NDJAR         ANLB-NDPER         SAV_WAER1
**        Wertfelder.
*         X-KANSW            X-KNAFA            X-KSAFA
*         X-KAAFA            X-KMAFA            X-GJA_BCHWRT
*         X-ANSWL            X-NAFAP            X-SAFAP
*         X-AAFAP            X-MAFAP            X-ZUSNA
*                            X-NABWB            X-SABWB
*         X-AABWB            X-MABWB            X-GJE_BCHWRT
*         INTO DATEN.


* Steuerungskennzeichen f�r LDB setzen
   *ANLA0-SIMVAR = PA_SIMVR.
  IF NOT SO_AFASL[] IS INITIAL.
     *ANLA0-XNODBS = 'X'.
  ENDIF.

* Setzen der UserStrukturen f�r die log. Datenbank
* (2 St�ck - f�r Header und Item Tabelle)
   *ANLA0-SELFIELD_STRUCTURE1 = 'CI_REPRAHAFA'.
   *ANLA0-SELFIELD_STRUCTURE2 = ''.

GET ANLA0.


GET ANLAV FIELDS TXT50 POSNR MENGE KOSTL AKTIV MEINS XANLGR
                 WERKS STORT LIFNR TXA50 ZUGDT DEAKT .

  CHECK SELECT-OPTIONS.
* Nur Anlagen seleketieren, die aktiviert wurden ...
  CHECK NOT ANLAV-ZUGDT IS INITIAL.
* ... und zwar vor dem Berichtsdatum.
  CHECK     ANLAV-ZUGDT LE BERDATUM.

* Verarbeitungen ON CHANGE OF ANLAV-XXXXX.
  INCLUDE YRASORT14.

* Im VJ deaktivierte Anlagen nicht selektieren.
  IF NOT ANLAV-DEAKT IS INITIAL.
    CHECK ANLAV-DEAKT GE SAV_GJBEG.
  ENDIF.

  ON CHANGE OF ANLAV-BUKRS.
*   Individueller Teil des Headers
    MOVE: '-'       TO HEAD-INFO1,
          BEREICH1  TO HEAD-INFO2,
          SAV_AFBE1 TO HEAD-INFO3.
*
    CONDENSE HEAD.
  ENDON.


GET ANLB FIELDS AFASL AFABG SAFBG NDJAR NDPER PERFY
                XNEGA XGWGK ZINBG WBIND ALIND APROP UMJAR
                SCHRW LGJAN ANLGR ANLGR2 schrw_proz.

  CHECK SELECT-OPTIONS.


GET ANLCV.


* Fehlerhafte Anlagen protokollieren.
*ALV  PERFORM fehler_ausgeben.

* Ausgabewerte/Sortierwerte berechnen.
  PERFORM WERTE_BERECHNEN.

  CHECK X-GJE_KANSW  IN SO_KANSW.                           "> 541822
  CHECK X-GJE_BCHWRT IN SO_BCHWR.
  CHECK X-NAFAP      IN SO_NAFAP.
*

* Daten gegen Sortierwerte beim PickUp checken.
  PERFORM SORT_CHECK.
* Keine Unterteilung der extrahierten Saetze ==> Jeder hat Rang '1'.
  RANGE = '1'.
* DATEN extrahieren.
*  EXTRACT daten.

  CLEAR ITAB_DATA.
  PERFORM SORT_FELDER_VORBEREITEN.

  MOVE-CORRESPONDING ANLAV TO ITAB_DATA.
  MOVE-CORRESPONDING ANLB TO ITAB_DATA.

************  added by sp ******************************
SELECT ANLKL
      TXK20
from ankt
  INTO table it_ankt
  where anlkl eq itab_data-s5.

loop at it_ankt into wa_ankt.

  itab_data-TXK20 = wa_ankt-TXK20.

  endloop.

*********************************************






*       Dauer aufbauen
  CONCATENATE ANLB-NDJAR '/' ANLB-NDPER
              INTO ITAB_DATA-DAUER.

* Die Wertfelder zur Ausgabe
  MOVE: X-KANSW      TO ITAB_DATA-BTR1,
        X-KNAFA      TO ITAB_DATA-BTR2,
        X-KSAFA      TO ITAB_DATA-BTR3,
        X-KAAFA      TO ITAB_DATA-BTR4,
        X-KMAFA      TO ITAB_DATA-BTR5,
        X-GJA_BCHWRT TO ITAB_DATA-BTR6,
        X-ANSWL      TO ITAB_DATA-BTR7,
        X-NAFAP2     TO ITAB_DATA-BTR8,                     "> 943381
        X-SAFAP      TO ITAB_DATA-BTR9,
        X-AAFAP      TO ITAB_DATA-BTR10,
        X-MAFAP      TO ITAB_DATA-BTR11,
        X-ZUSNA      TO ITAB_DATA-BTR12,
        X-NABWB      TO ITAB_DATA-BTR13,
        X-SABWB      TO ITAB_DATA-BTR14,
        X-AABWB      TO ITAB_DATA-BTR15,
        X-MABWB      TO ITAB_DATA-BTR16,
        X-GJE_BCHWRT TO ITAB_DATA-BTR17,
        X-KNAFA      TO ITAB_DATA-BTR18,
        X-NAFAP      TO ITAB_DATA-BTR19,
        X-NABWB2     TO ITAB_DATA-BTR20,
        X-KANSW2     TO ITAB_DATA-BTR21,
        X-KNAFA2     TO ITAB_DATA-BTR22,
        X-NAFAP2     TO ITAB_DATA-BTR23,
        X-NABWB2     TO ITAB_DATA-BTR24,                    ">383021
        X-ANSWL2     TO ITAB_DATA-BTR25.                    ">383021

* Die W�hrung zur Ausgabe
  ITAB_DATA-WAERS = SAV_WAER1.
* Alles in der Tabelle ist ausw�hlbar!
  ITAB_DATA-FLG_PICK_UP = 'X'.
* Alle Eintr�ge in der ersten Stufe
  ITAB_DATA-RANGE = RANGE.
* Die Datenzeilen sind immer in der vollen Sortierung
  ITAB_DATA-HLP_LEVEL = CON_SRTST.      " == Anzahl Summenstufen

*--------------------------------- Custom Code -----------------------------------------

  PERFORM ADD_CUSTOM_FIELDS.        " Added by Shreyas Lakhani

*---------------------------------------------------------------------------------------
* Bestand f�r Summenbericht aufbereiten
  IF SUMMB NE SPACE.
    PERFORM HASHSUM_COLLECTION USING ITAB_DATA.
  ELSE.
*   ITAB_DATA nur dann aufbauen, wenn KEIN Summenbericht

    APPEND ITAB_DATA.
  ENDIF.

  PERFORM STORE_ERRORS.                                     "< 1002552




END-OF-SELECTION.

*---------------------------------------------------------------------*

************************************************************************
* Ausgabe der internen Tabelle mit dem ALV *****************************
************************************************************************
  PERFORM TCOLLECT_FUELLEN.

  WA_LAYOUT-COLWIDTH_OPTIMIZE = 'X' .            " Shreyas
  IF SUMMB EQ SPACE.
*                                                    *******************
*                                                    ** EINZELBERICHT **
*                                                    *******************
    PERFORM INIT_FIELDCAT.                       " CREATE FIELDCAT

    CALL FUNCTION 'FIAA_ALV_DISPLAY'             " DISPLAY ALV REPORT
         EXPORTING
              USE_ALV_GRID       = P_GRID
              VARIANTE           = P_VARI
              TABNAME_HEADER     = 'ITAB_DATA'
              SUMMEN_BERICHT     = SUMMB
              X_T086             = T086
              TCOLLECT           = TCOLLECT
              ITAB_LAYOUT        = WA_LAYOUT
         TABLES
              ITAB_HEADER    = ITAB_DATA[]
              BUKRS          = BUKRS[]
              SORTFELD       = FELD[]
              ITAB_ERRORS    = GT_ANFM[].                   "> 1002552
  ELSE.
*                                                    *******************
*                                                    ** SUMMENBERICHT **
*                                                    *******************
    PERFORM SUMMENTABELLE_AUFBAUEN.
    PERFORM INIT_FIELDCAT_SUM.
    CALL FUNCTION 'FIAA_ALV_DISPLAY'
      EXPORTING
        USE_ALV_GRID   = P_GRID
        VARIANTE       = P_VARI
        TABNAME_HEADER = 'SUMTAB_DATA_S'
        SUMMEN_BERICHT = SUMMB
        X_T086         = T086
        TCOLLECT       = TCOLLECT
        ITAB_LAYOUT    = WA_LAYOUT
      TABLES
        ITAB_HEADER    = SUMTAB_DATA_S[]
        BUKRS          = BUKRS[]
        SORTFELD       = FELD[]
        ITAB_ERRORS    = GT_ANFM[].                         "> 1002552
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  werte_berechnen
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM WERTE_BERECHNEN.

* Kumulierter Anschaffungswert.
  X-KANSW       = ANLCV-ANSW_GJA.
* Kumulierte N-AfA + S-AfA + A-AfA
  X-KNAFA       = ANLCV-AFA_GJA.
* Kumulierter Buchwert GJ-Beginn.
  X-GJA_BCHWRT    = ANLCV-BCHWRT_GJA.
* Bewegungen auf Anschaffungswert.
  X-ANSWL         = ANLCV-ANSW_BEW.
* Geplante N-AfA + S-AfA + A-AfA.
  X-NAFAP       = ANLCV-NAFAP
                + ANLCV-AUFNP
                + ANLCV-SAFAP
                + ANLCV-AAFAP.
*               + anlcv-mafap.               "schon in Anschaffungwert
* Zuschreibungen N-AfA + S-AfA + A-AfA + M-AfA.
  X-ZUSNA         = ANLCV-AFA_ZUS
                  + ANLCV-RUECK_ZUS.
* Bewegungen auf Wertberichtigungen N + S + A + M.
  X-NABWB       = ANLCV-AFA_ANT.
* Buchwert GJ-Ende.
  X-GJE_BCHWRT    = ANLCV-BCHWRT_GJE.

* GETRENNTE Werte:
  X-KANSW2      = ANLCV-ANSW_GJA - ANLCV-KMAFA.
* Kumulierte N-AfA.
  X-KNAFA2      = ANLCV-KNAFA    + ANLCV-KAUFN.
* Kumulierte S-AfA.
  X-KSAFA       = ANLCV-KSAFA.
* Kumulierte A-AfA.
  X-KAAFA       = ANLCV-KAAFA.
* Kumulierte M-AfA.
  X-KMAFA       = ANLCV-KMAFA.
* Geplante N-AfA.
  X-NAFAP2      = ANLCV-NAFAP
                + ANLCV-AUFNP.
  X-ANSWL2      = ANLCV-ANSW_BEW - ANLCV-MAFAP - ANLCV-MAFAL -
ANLCV-MAFAV.                                                ">383021
* Geplante S-AfA.
  X-SAFAP       = ANLCV-SAFAP.
* Geplante A-AfA.
  X-AAFAP       = ANLCV-AAFAP.
* Geplante M-AfA.
  X-MAFAP       = ANLCV-MAFAP.
* Bewegungen auf Wertberichtigungen N.
  X-NABWB2      = ANLCV-NAFA_ANT
                + ANLCV-AUFNV    + ANLCV-AUFNL.
* Bewegungen auf Wertberichtigungen S.
  X-SABWB       = ANLCV-SAFAV    + ANLCV-SAFAL.
* Bewegungen auf Wertberichtigungen A.
  X-AABWB       = ANLCV-AAFAV    + ANLCV-AAFAL.
* Bewegungen auf Wertberichtigungen M.
  X-MABWB       = ANLCV-MAFAV    + ANLCV-MAFAL.
* Kumulierter Anschaffungswert Gesch�ftsjahresende
  X-GJE_KANSW   = ANLCV-ANSW_GJE.                           "> 541822
ENDFORM.                    "werte_berechnen

*---------------------------------------------------------------------*
*       FORM INIT_FIELDCAT                                            *
*---------------------------------------------------------------------*
*       Feldkatalog f�r den ABAP Listviewer aufbauen.                 *
*       Dies ist der Default-Feldkatalog, der in der Auslieferung     *
*       vorgegeben wird. Das Aussehen kann speziell mit den Anzeige-  *
*       varianten angepasst werden. Welche Felder �berhaupt zur       *
*       Verf�gung stehen, _muss_ hier definiert werden.               *
*---------------------------------------------------------------------*
FORM INIT_FIELDCAT.

  DATA: COLOR(4).
  DATA: TEXTNAME(10), NUM(2).
  FIELD-SYMBOLS: <TEXT>.

* Es wird nicht mehr der Standard Feldkatalog f�r die internen
* Tabellen benutzt, sondern dieser selbst aufgebaut!

**********
* S1 bis S5 entsprechen der Sortiervariante. _Immer_ mitnehmen!
*
  PERFORM FIELDCAT_S_FIELDS_DEFINE USING 'ITAB_DATA'.
*
*
**********
  COLOR = 'C400'.

  CLEAR X_FIELDCAT.
  X_FIELDCAT-FIELDNAME     = 'ANLN0'.
  X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
  X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
  X_FIELDCAT-EMPHASIZE     = COLOR.
  CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
    EXPORTING
      FIELDCAT_LINE = X_FIELDCAT.

  CLEAR X_FIELDCAT.
  X_FIELDCAT-FIELDNAME     = 'ANLN2'.
  X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
  X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
  X_FIELDCAT-OUTPUTLEN     = 5.
  X_FIELDCAT-EMPHASIZE     = COLOR.
  CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
    EXPORTING
      FIELDCAT_LINE = X_FIELDCAT.

*  CLEAR X_FIELDCAT.
*  X_FIELDCAT-FIELDNAME     = 'AKTIV'.
*  X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*  X_FIELDCAT-SELTEXT_M     = 'Cap.Date'.
*  X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
*  X_FIELDCAT-EMPHASIZE     = COLOR.
*  CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*    EXPORTING
*      FIELDCAT_LINE = X_FIELDCAT.

  CLEAR X_FIELDCAT.
  X_FIELDCAT-FIELDNAME     = 'TXT50'.
  X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
  X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
  X_FIELDCAT-EMPHASIZE     = COLOR.
  CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
    EXPORTING
      FIELDCAT_LINE = X_FIELDCAT.

  IF PA_SOAFA IS INITIAL.
*   Keine AFA Trennung
*   BTR Felder 1, 18, 6 anh�ngen
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 1
        TEXT    = TEXT-W01
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 18
        TEXT    = TEXT-W18
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 6
        TEXT    = TEXT-W06
        TABNAME = 'ITAB_DATA'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'WAERS'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'T093B'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

* \ 2
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 12
                   TABNAME = 'ITAB_DATA'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'AFASL'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'DepKY'.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR x_fieldcat.
*    x_fieldcat-fieldname     = 'NDJAR'.
*    x_fieldcat-tabname       = 'ITAB_DATA'.
*    x_fieldcat-seltext_m     = 'Life'.                    "shreyas
*    x_fieldcat-ref_tabname   = 'ANLB'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*         EXPORTING fieldcat_line = x_fieldcat.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'AFABG'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.              " shreyas
*    X_FIELDCAT-SELTEXT_M     = 'ODep.Start'.
*    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'KOSTL'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.              " shreyas
    X_FIELDCAT-SELTEXT_M     = 'COST CENTER'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'DAUER'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.         " SHREYAS
*    X_FIELDCAT-SELTEXT_L     =  TEXT-012.
    X_FIELDCAT-SELTEXT_M     = 'LIFE'.
    X_FIELDCAT-OUTPUTLEN    =  10.                          "> 412670
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'GSBER'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.         " SHREYAS
*    X_FIELDCAT-SELTEXT_M     = 'BusA'.
*    X_FIELDCAT-REF_TABNAME   = 'ANLZ'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'MSFAK'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.         " SHREYAS
    X_FIELDCAT-SELTEXT_M     = 'Shift Factor'.
    X_FIELDCAT-REF_TABNAME   = 'ANLZ'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

      CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'APROP'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = text-001.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
*    X_FIELDCAT-ddictxt       = 'l'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'SCHRW_PROZ'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_l     = text-002  . "'Scrap Value'.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
*    X_FIELDCAT-ddictxt       = 'l'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'SAFBG'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'MENGE'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    X_FIELDCAT-QFIELDNAME    = 'MEINS'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'MEINS'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'UOM'.              ""   shreyas
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 6
                   TABNAME = 'ITAB_DATA'.

*   BTR Felder 7, 19 anh�ngen
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 7
        TEXT    = TEXT-W07
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 19
        TEXT    = TEXT-W19
        TABNAME = 'ITAB_DATA'.

* \ 3
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 12
                   TABNAME = 'ITAB_DATA'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'WERKS'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'Plant'.              ""   shreyas
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    X_FIELDCAT-OUTPUTLEN     = 5.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'STORT'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.            """ shreyas
    X_FIELDCAT-SELTEXT_M     = 'Location'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'. " or ANLZ
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'LIFNR'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.              "" shreyas
    X_FIELDCAT-SELTEXT_M     = 'Vendor'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'POSNR'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'WBS X/F,MBKJSBFVKJBSFJVBJLSFBV'.              ""   shreyas
*    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.



    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 3
                   TABNAME = 'ITAB_DATA'.

*   BTR Felder 12, 20, 17 anh�ngen
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 12
        TEXT    = TEXT-W12
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 13
        TEXT    = TEXT-W13
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 17
        TEXT    = TEXT-W17
        TABNAME = 'ITAB_DATA'.


*   Die restlichen Betragsfelder in den Feldkatalog stellen,
*   aber ausschalten! (Puh...)
******** Vorrat Start
*   BTR Felder anh�ngen
*   2-5
    DO 4 TIMES.
      NUM = SY-INDEX + 1.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'ITAB_DATA'
          NO_OUT  = 'X'.
    ENDDO.
*   8-11
    DO 4 TIMES.
      NUM = SY-INDEX + 7.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'ITAB_DATA'
          NO_OUT  = 'X'.
    ENDDO.
*   14-16
    DO 3 TIMES.
      NUM = SY-INDEX + 13.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'ITAB_DATA'
          NO_OUT  = 'X'.
    ENDDO.
*   20-23
    DO 4 TIMES.
      NUM = SY-INDEX + 19.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'ITAB_DATA'
          NO_OUT  = 'X'.
    ENDDO.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter DUMMY
         EXPORTING LENGTH  = 1
                   TABNAME = 'ITAB_DATA'
                   NO_OUT  = 'X'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter DUMMY
         EXPORTING LENGTH  = 1
                   TABNAME = 'ITAB_DATA'
                   NO_OUT  = 'X'.

    " BEGIN OF CODE ADDED BY SHREYAS
    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'NAME1'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.                " shreyas
    X_FIELDCAT-SELTEXT_L     = 'Supplier Name/Vendor Desc'.
    X_FIELDCAT-REF_TABNAME   = 'LFA1'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'HERST'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.            " shreyas
*    X_FIELDCAT-SELTEXT_M     = 'HERST'.
*    X_FIELDCAT-REF_TABNAME   = 'ANLA'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

**    CLEAR X_FIELDCAT.
**    X_FIELDCAT-FIELDNAME     = 'YR_ADD_AMT'.
**    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.            " shreyas
**    X_FIELDCAT-SELTEXT_M     = 'During Year Addition'.
***    X_FIELDCAT-REF_TABNAME   = ''.
**    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
**      EXPORTING
**        FIELDCAT_LINE = X_FIELDCAT.
**
**    CLEAR X_FIELDCAT.
**    X_FIELDCAT-FIELDNAME     = 'YR_SUB_AMT'.
**    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.            " shreyas
**    X_FIELDCAT-SELTEXT_L     = 'During Year Deletion'.
***    X_FIELDCAT-REF_TABNAME   = ''.
**    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
**      EXPORTING
**        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'TXT50'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'TXT50'.
    X_FIELDCAT-REF_TABNAME   = 'ANLA'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.                                                            "Added by Komal M. on 06-09-2024.
    X_FIELDCAT-FIELDNAME     = 'TXA50'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'Additional asset description'.
    X_FIELDCAT-REF_TABNAME   = 'ANLA'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.



    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'SERNR'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'Legacy Asset No'.
    X_FIELDCAT-REF_TABNAME   = 'ANLA'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'INVNR'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    x_fieldcat-seltext_m     = 'INVNR'.
    X_FIELDCAT-SELTEXT_M     = 'Machine No'.
    X_FIELDCAT-REF_TABNAME   = 'ANLA'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'KTANSW'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'Asset Class GL'.      """""""""""""" shreyas
    X_FIELDCAT-REF_TABNAME   = 'T095'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'KTNAFG'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'Depreciation GL'.          """""""" shreyas
    X_FIELDCAT-REF_TABNAME   = 'T095B'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

*****************************sp***************************************
CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'TXK20'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'Asset Class descr'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.


***********************************************************************
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SAPNAMEDR'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SAPNAMEDR'.
*    X_FIELDCAT-REF_TABNAME   = 'SKAT'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'KTNAFB'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'Accu. Depriciation GL'.       """""""" shreyas
    X_FIELDCAT-REF_TABNAME   = 'T095B'.
*    x_fieldcat-no_out        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'AFABG'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_L     =  'Deprc. Start Date'.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
       FIELDCAT_LINE = X_FIELDCAT.

     CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'DEAKT'.                         "added by jyoti on04.09.2024
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_L     =  'Deactivated Date'.
    X_FIELDCAT-REF_TABNAME   = 'ANLA'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SAPNAMECR'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SAPNAMECR'.
*    X_FIELDCAT-REF_TABNAME   = 'SKAT'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR x_fieldcat.
*    x_fieldcat-fieldname     = 'TXT50'.
*    x_fieldcat-tabname       = 'ITAB_DATA'.
*    x_fieldcat-seltext_m     = 'APC Name'.
*    x_fieldcat-ref_tabname   = 'SKA1'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*         EXPORTING fieldcat_line = x_fieldcat.

********************* ZMORTGAGE table fields **************************
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'ZZMEGAREM'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'MEGAREM'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'ZZIMPDOM'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'IMPDOM'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'MORT_DETAILS'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'MORTGAGE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'ZZVAL_REMARK'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'VAL_REMARK'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'ZZEXCL_CHRG'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'EXCL_CHRG'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.


********************* ZASSET_DETAILS table fields **************************

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'ASSET_NAME_OLD'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'ASSET_NAME_OLD'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'INVNO'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'INVNO'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'INVDATE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'INVDATE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'PUR_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'PUR_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'OTHERCOST'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'OTHERCOST'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'CAPCOST'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'CAPCOST'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'INST_CHRG_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'INST_CHRG_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'DUTY_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'DUTY_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FREIGHT_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FREIGHT_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'CLEARING_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'CLEARING_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'INTEREST_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'INTEREST_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'RTO_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'RTO_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'INSURANCE_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'INSURANCE_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'VAT_DISALLWD_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'VAT_DISALLWD_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SRVPRMINT_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SRVPRMINT_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SITEDEVDEP_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SITEDEVDEP_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FERDCAP_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FERDCAP_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FEE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FEE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'TOTALCOST'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'TOTALCOST'.
**    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'CHECK_ASSET_VAL'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_L     = 'Check Asset Val'.
**    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'DEPRIRATE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'DEPRIRATE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'WDV_VALUE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'WDV_VALUE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'DISPOS'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'DISPOS'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'GAT_NO'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'GAT_NO'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'AREA_HECT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'AREA_HECT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'AREA_ACRE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'AREA_ACRE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SAPFIDOC'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SAPFIDOC'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'MIRONO'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'MIRO NO'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FURN_OFFI'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FURN_OFFI'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FC'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FC'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FC_RATE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FC_RATE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FC_AMT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FC_AMT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'VAT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'VAT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.

*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'CENVAT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'CENVAT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'CST'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'CST'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SERV_TAX'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SERV_TAX'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'AST_GRP'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'AST_GRP'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'BUCAT'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'BUCAT'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SEGMENT1'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'AGRI/NONAGRI'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'BU_JPK'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'BU_JPK'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'LOCATION_JPK'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'LOCATION_JPK'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'MACHINFROM'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'MACHINFROM'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'MACHINTO'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'MACHINTO'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'FAYEAR'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'FAYEAR'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'BKGDATE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'BKGDATE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'BUCODE'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'BUCODE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'BUNAME'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'BUNAME'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SEGMENT2'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SEGMENT CODE'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'SEGNAME'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SEGNAME'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'REMARK_1'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'REMARK_1'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'REMARK_2'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'REMARK_2'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'REMARK_3'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'IGST'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'REMARK_4'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'CGST'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'REMARK_5'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'SGST'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*
*
*    CLEAR X_FIELDCAT.
*    X_FIELDCAT-FIELDNAME     = 'REMARK_6'.
*    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
*    X_FIELDCAT-SELTEXT_M     = 'UGST'.
*    X_FIELDCAT-REF_TABNAME   = 'ZASSET_DETAILS'.
**    x_fieldcat-no_out        = 'X'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*      EXPORTING
*        FIELDCAT_LINE = X_FIELDCAT.
*


    " END OF CODE BY SHREYAS

******** Vorrat Ende

  ELSE. "getrennte Darstellung erw�nscht

*   mit AFA Trennung

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'TXA50'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.         """""""""""" shreyas
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
*    x_fieldcat-seltext_l     = '...'.
    X_FIELDCAT-SELTEXT_M     = 'Additional Asset Description'.
    X_FIELDCAT-EMPHASIZE     = COLOR.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'ANLHTXT'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.         """""""""""" shreyas
    X_FIELDCAT-REF_TABNAME   = 'ANLH'.
    X_FIELDCAT-SELTEXT_M     = 'Asset Main Text'.
    X_FIELDCAT-EMPHASIZE     = COLOR.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'WAERS'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'T093B'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

* /2
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 7
                   TABNAME = 'ITAB_DATA'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'KOSTL'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'AFASL'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'DepKY'.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.






*    CLEAR x_fieldcat.
*    x_fieldcat-fieldname     = 'NDJAR'.
*    x_fieldcat-tabname       = 'ITAB_DATA'.
*    x_fieldcat-seltext_m     = 'Life'.                        "shreyas
*    x_fieldcat-ref_tabname   = 'ANLB'.
*    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
*         EXPORTING fieldcat_line = x_fieldcat.



    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'DAUER'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.                " SHREYAS
*    X_FIELDCAT-SELTEXT_L     =  TEXT-012.
    X_FIELDCAT-SELTEXT_L     = 'LIFE'.
    X_FIELDCAT-OUTPUTLEN    =  10.                          "> 412670
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 21
        TEXT    = TEXT-W21
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 22
        TEXT    = TEXT-W22
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 3
        TEXT    = TEXT-W03
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 4
        TEXT    = TEXT-W04
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 5
        TEXT    = TEXT-W05
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 6
        TEXT    = TEXT-W06
        TABNAME = 'ITAB_DATA'.

* \ 3
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 7
                   TABNAME = 'ITAB_DATA'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'WERKS'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    X_FIELDCAT-OUTPUTLEN     = 5.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 4
                   TABNAME = 'ITAB_DATA'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'AFABG'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_L     =  'Deprc. Start Date'.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 5
                   TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 25                                        ">383021
        TEXT    = TEXT-W07
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 23
        TEXT    = TEXT-W23
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 9
        TEXT    = TEXT-W09
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 10
        TEXT    = TEXT-W10
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 11
        TEXT    = TEXT-W11
        TABNAME = 'ITAB_DATA'.

* \ 4
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 7
                   TABNAME = 'ITAB_DATA'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'STORT'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'SAFBG'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLB'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING LENGTH  = 5
                   TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 12
        TEXT    = TEXT-W12
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 20
        TEXT    = TEXT-W20
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 14
        TEXT    = TEXT-W14
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 15
        TEXT    = TEXT-W15
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 16
        TEXT    = TEXT-W16
        TABNAME = 'ITAB_DATA'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 17
        TEXT    = TEXT-W17
        TABNAME = 'ITAB_DATA'.

*   Die restlichen Betragsfelder in den Feldkatalog stellen,
*   aber ausschalten! (Puh...)
******** Vorrat Start
*   BTR Felder anh�ngen
*   1-1
    DO 2 TIMES.
      NUM = SY-INDEX + 0.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'ITAB_DATA'
          NO_OUT  = 'X'.
    ENDDO.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 8
        TEXT    = TEXT-W08
        TABNAME = 'ITAB_DATA'
        NO_OUT  = 'X'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 13
        TEXT    = TEXT-W13
        TABNAME = 'ITAB_DATA'
        NO_OUT  = 'X'.

*   18-19
    DO 2 TIMES.
      NUM = SY-INDEX + 17.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'ITAB_DATA'
          NO_OUT  = 'X'.
    ENDDO.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'MENGE'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    X_FIELDCAT-QFIELDNAME    = 'MEINS'.
    X_FIELDCAT-NO_OUT        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'MEINS'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    X_FIELDCAT-NO_OUT        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'LIFNR'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.            "shreyas
    X_FIELDCAT-SELTEXT_M     = 'Vendor'.
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    X_FIELDCAT-NO_OUT        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'POSNR'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
    X_FIELDCAT-SELTEXT_M     = 'WBS Element'.             "" shreyas
    X_FIELDCAT-REF_TABNAME   = 'ANLAV'.
    X_FIELDCAT-NO_OUT        = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.


******** Vorrat ENDE
  ENDIF.

* User Felder an den Feldkatalog anh�ngen.
* ACHTUNG: Auf korrekten Struktur- und Tabellen-Namen achten!
  PERFORM FIELDCAT_USER_FIELDS_APPEND USING *ANLA0-SELFIELD_STRUCTURE1
                                            'ITAB_DATA'.

ENDFORM.                    "init_fieldcat

*---------------------------------------------------------------------*
*       FORM INIT_FIELDCAT_SUM                                        *
*---------------------------------------------------------------------*
*       Feldkatalog f�r Gruppensummen definieren                      *
*---------------------------------------------------------------------*
FORM INIT_FIELDCAT_SUM.
  DATA: TEXTNAME(10), NUM(2).
  DATA: LD_BLANKS  TYPE DD03P-OUTPUTLEN.                    "> 558765
  FIELD-SYMBOLS: <TEXT>.

* Pflichtteil!
  PERFORM FIELDCAT_S_FIELDS_DEFINE USING 'SUMTAB_DATA_S'.

  PERFORM GET_BLANKS_FROM_SORT_VARIANT TABLES     FELD      "> 558765
                                       CHANGING   LD_BLANKS. "> 558765

  CLEAR X_FIELDCAT.
  X_FIELDCAT-FIELDNAME     = 'TEXT'.
  X_FIELDCAT-TABNAME       = 'SUMTAB_DATA_S'.
  X_FIELDCAT-OUTPUTLEN     = 30.
  CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
    EXPORTING
      FIELDCAT_LINE = X_FIELDCAT.

  ADD 30 TO LD_BLANKS.                                      "> 558765

* K�rteil!
* Jetzt folgen die individuellen Betragsfelder

  IF PA_SOAFA IS INITIAL.
*   Keine AFA Trennung
*   BTR Felder 1, 18, 6 anh�ngen
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 1
        TEXT    = TEXT-W01
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 18
        TEXT    = TEXT-W18
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 6
        TEXT    = TEXT-W06
        TABNAME = 'SUMTAB_DATA_S'.

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'WAERS'.
    X_FIELDCAT-TABNAME       = 'SUMTAB_DATA_S'.
    X_FIELDCAT-REF_TABNAME   = 'T093B'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

* \ 2
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING
*                  length  = 71                                "> 558765
                   LENGTH  = LD_BLANKS                      "> 558765
                   TABNAME = 'SUMTAB_DATA_S'.

*   BTR Felder 7, 19 anh�ngen
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 7
        TEXT    = TEXT-W07
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 19
        TEXT    = TEXT-W19
        TABNAME = 'SUMTAB_DATA_S'.

* \ 3
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter
         EXPORTING
*                  length  = 71                                "> 558765
                   LENGTH  = LD_BLANKS                      "> 558765
                   TABNAME = 'SUMTAB_DATA_S'.

*   BTR Felder 12, 20, 17 anh�ngen
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 12
        TEXT    = TEXT-W12
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 13
        TEXT    = TEXT-W13
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 17
        TEXT    = TEXT-W17
        TABNAME = 'SUMTAB_DATA_S'.


*   Die restlichen Betragsfelder in den Feldkatalog stellen,
*   aber ausschalten! (Puh...)
******** Vorrat Start
*   BTR Felder anh�ngen
*   2-5
    DO 4 TIMES.
      NUM = SY-INDEX + 1.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'SUMTAB_DATA_S'
          NO_OUT  = 'X'.
    ENDDO.
*   8-11
    DO 4 TIMES.
      NUM = SY-INDEX + 7.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'SUMTAB_DATA_S'
          NO_OUT  = 'X'.
    ENDDO.
*   14-16
    DO 3 TIMES.
      NUM = SY-INDEX + 13.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'SUMTAB_DATA_S'
          NO_OUT  = 'X'.
    ENDDO.
*   20-23
    DO 4 TIMES.
      NUM = SY-INDEX + 19.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'SUMTAB_DATA_S'
          NO_OUT  = 'X'.
    ENDDO.

******** Vorrat Ende

  ELSE. "getrennte Darstellung erw�nscht

*   mit AFA Trennung

    CLEAR X_FIELDCAT.
    X_FIELDCAT-FIELDNAME     = 'WAERS'.
    X_FIELDCAT-TABNAME       = 'SUMTAB_DATA_S'.
    X_FIELDCAT-REF_TABNAME   = 'T093B'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.

    CLEAR X_FIELDCAT.                                                        "Added by KOMAL M. on 04-09-2024
    X_FIELDCAT-FIELDNAME     = 'DEAKT'.
    X_FIELDCAT-TABNAME       = 'ITAB_DATA'.
     X_FIELDCAT-SELTEXT_M     = 'DEACT.DATE'.
    X_FIELDCAT-REF_TABNAME   = 'ANLA'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        FIELDCAT_LINE = X_FIELDCAT.



* /2
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 21
        TEXT    = TEXT-W21
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 22
        TEXT    = TEXT-W22
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 3
        TEXT    = TEXT-W03
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 4
        TEXT    = TEXT-W04
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 5
        TEXT    = TEXT-W05
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 6
        TEXT    = TEXT-W06
        TABNAME = 'SUMTAB_DATA_S'.

* \ 3
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 25                                        ">383021
        TEXT    = TEXT-W07
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 23
        TEXT    = TEXT-W23
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 9
        TEXT    = TEXT-W09
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 10
        TEXT    = TEXT-W10
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 11
        TEXT    = TEXT-W11
        TABNAME = 'SUMTAB_DATA_S'.

* \ 4
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
      EXPORTING
        COMMAND = 'NEWLINE'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 12
        TEXT    = TEXT-W12
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 20
        TEXT    = TEXT-W20
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 14
        TEXT    = TEXT-W14
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 15
        TEXT    = TEXT-W15
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 16
        TEXT    = TEXT-W16
        TABNAME = 'SUMTAB_DATA_S'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 17
        TEXT    = TEXT-W17
        TABNAME = 'SUMTAB_DATA_S'.

*   Die restlichen Betragsfelder in den Feldkatalog stellen,
*   aber ausschalten! (Puh...)
******** Vorrat Start
*   BTR Felder anh�ngen
*   1-1
    DO 2 TIMES.
      NUM = SY-INDEX + 0.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'SUMTAB_DATA_S'
          NO_OUT  = 'X'.
    ENDDO.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 8
        TEXT    = TEXT-W08
        TABNAME = 'SUMTAB_DATA_S'
        NO_OUT  = 'X'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
      EXPORTING
        NUM     = 13
        TEXT    = TEXT-W13
        TABNAME = 'SUMTAB_DATA_S'
        NO_OUT  = 'X'.

*   18-19
    DO 2 TIMES.
      NUM = SY-INDEX + 17.
      IF NUM >= 10.
        CONCATENATE 'TEXT-W' NUM INTO TEXTNAME.
      ELSE.
        CONCATENATE 'TEXT-W0' NUM INTO TEXTNAME.
      ENDIF.
      ASSIGN (TEXTNAME) TO <TEXT>.
      CALL FUNCTION 'FIAA_FIELDCAT_ADD_BTR'
        EXPORTING
          NUM     = NUM
          TEXT    = <TEXT>
          TABNAME = 'SUMTAB_DATA_S'
          NO_OUT  = 'X'.
    ENDDO.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter DUMMY
         EXPORTING LENGTH  = 1
                   TABNAME = 'SUMTAB_DATA_S'
                   NO_OUT  = 'X'.

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_SPACE'     " Platzhalter DUMMY
         EXPORTING LENGTH  = 1
                   TABNAME = 'SUMTAB_DATA_S'
                   NO_OUT  = 'X'.

******** Vorrat ENDE
  ENDIF.

ENDFORM.                    "init_fieldcat_sum

* Allgemeine FORM-Routinen.
INCLUDE YRASORT_ALV_MISC.

* Formroutinen f�r den ABAP List Viewer
INCLUDE YRASORT_ALV_PREPARE_TABLE.    " Feldcatalog/Layout/Sort vorber.
INCLUDE YRASORT_ALV_TOOLS.            " diverse Forms



*&---------------------------------------------------------------------*
*&      Form  ADD_CUSTOM_FIELDS         ---Added by Shreyas
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ADD_CUSTOM_FIELDS .
*BREAK-POINT.
  CLEAR WA_ANLA.
  SELECT SINGLE BUKRS
                ANLN1
                ANLN2
                ANLKL
                KTOGR
                HERST
                INVNR
                TXT50
                TXA50                                                       "Added by Komal M. on 06-09-2024
                SERNR
                DEAKT                                                      "Added by KOMAL M. on 04-09-2024
  FROM ANLA INTO WA_ANLA
  WHERE BUKRS EQ ITAB_DATA-BUKRS AND ANLN1 EQ ITAB_DATA-ANLN1
  AND ANLN2 EQ ITAB_DATA-ANLN2 AND ANLKL EQ ITAB_DATA-ANLKL.

*  Supplier Name/Vendor desc
  DATA : LV_VENDOR_DESC TYPE STRING.
  CLEAR LV_VENDOR_DESC.
  SELECT SINGLE NAME1 INTO LV_VENDOR_DESC FROM LFA1 WHERE LIFNR EQ ITAB_DATA-LIFNR.
  ITAB_DATA-NAME1            = LV_VENDOR_DESC.

* Asset Class GL
  CLEAR WA_T095.
  SELECT SINGLE KTOGR           "CHANGE
                KTANSW
  FROM T095 INTO WA_T095
  WHERE KTOGR EQ WA_ANLA-KTOGR.

* Depreciation GL & Accumulated Depreciation GL
  CLEAR WA_T095B.
  SELECT SINGLE KTOGR
                KTNAFB
                KTNAFG
  FROM T095B INTO WA_T095B
  WHERE KTOGR EQ WA_ANLA-KTOGR.

*   SAPNAMEDR & SAPNAMECR fields

  CLEAR WA_SAPNAMEDR.
  SELECT SINGLE SAKNR
                TXT50
  FROM SKAT INTO WA_SAPNAMEDR
  WHERE SAKNR EQ WA_T095B-KTNAFG .

  CLEAR WA_SAPNAMECR.
  SELECT SINGLE SAKNR
         TXT50
  FROM SKAT INTO WA_SAPNAMECR
  WHERE SAKNR EQ WA_T095B-KTNAFB.


* Asset Main Text
  CLEAR WA_ANLH.
  SELECT SINGLE BUKRS
         ANLN1
         ANLHTXT
  FROM ANLH INTO WA_ANLH
  WHERE BUKRS EQ WA_ANLA-BUKRS AND ANLN1 EQ WA_ANLA-ANLN1.

*  Bus Area
  CLEAR WA_ANLZ.
  SELECT SINGLE BUKRS
         ANLN1
         ANLN1
         GSBER
         MSFAK
  FROM ANLZ INTO WA_ANLZ
  WHERE BUKRS EQ WA_ANLA-BUKRS AND ANLN1 EQ WA_ANLA-ANLN1 AND ANLN2 EQ WA_ANLA-ANLN2.

* During Year Addition & During Year Subtraction Calculation
  DATA: GD_FISCALYR  TYPE BAPI0002_4-FISCAL_YEAR.

*   BAPI To get Fiscal year from Reporting date input.
  CALL FUNCTION 'BAPI_COMPANYCODE_GET_PERIOD'
    EXPORTING
      COMPANYCODEID = ITAB_DATA-BUKRS
      POSTING_DATE  = BERDATUM
    IMPORTING
      FISCAL_YEAR   = GD_FISCALYR.
*      FISCAL_PERIOD = GD_FISCALP.


*  For During Year Addition : -

  SELECT BWASL
         GITTGR
  FROM TABW INTO TABLE IT_TABW_ADD
  WHERE GITTGR IN (10,31,33,35,37).

  DATA : LV_ANBTR_ADD TYPE ANEP-ANBTR.
  SELECT BUKRS
         ANLN1
         ANLN2
         GJAHR
         AFABE
         BWASL
         ANBTR
*  FROM ANEP INTO TABLE IT_ANEP_ADD .
  FROM ANEP INTO TABLE IT_ANEP_ADD FOR ALL ENTRIES IN IT_TABW_ADD
  WHERE BUKRS EQ ITAB_DATA-BUKRS AND
        ANLN1 EQ ITAB_DATA-ANLN1 AND
        ANLN2 EQ ITAB_DATA-ANLN2 AND
        GJAHR EQ GD_FISCALYR AND
        AFABE EQ '01' AND
        BWASL EQ IT_TABW_ADD-BWASL .

  CLEAR LV_ANBTR_ADD.

  LOOP AT IT_ANEP_ADD.
    LV_ANBTR_ADD = LV_ANBTR_ADD + IT_ANEP_ADD-ANBTR.
    CLEAR IT_ANEP_ADD-ANBTR.
  ENDLOOP.



*  For During Year Subtraction : -
  SELECT BWASL
         GITTGR
  FROM TABW INTO TABLE IT_TABW_SUB
  WHERE GITTGR IN (12,20,25,30,32,34,36).

  DATA : LV_ANBTR_SUB TYPE ANEP-ANBTR.
  SELECT BUKRS
         ANLN1
         ANLN2
         GJAHR
         AFABE
         BWASL
         ANBTR
  FROM ANEP INTO TABLE IT_ANEP_SUB FOR ALL ENTRIES IN IT_TABW_SUB
  WHERE BUKRS EQ ITAB_DATA-BUKRS AND
        ANLN1 EQ ITAB_DATA-ANLN1 AND
        ANLN2 EQ ITAB_DATA-ANLN2 AND
        GJAHR EQ GD_FISCALYR AND
        AFABE EQ '01' AND
        BWASL EQ IT_TABW_SUB-BWASL .

  CLEAR LV_ANBTR_SUB.
  LOOP AT IT_ANEP_SUB.
    LV_ANBTR_SUB = LV_ANBTR_SUB + IT_ANEP_SUB-ANBTR.
    CLEAR IT_ANEP_SUB-ANBTR.
  ENDLOOP.


** ZMORTGAGE table fields
*  SELECT ASSET_NO
*         ASSET_SUBNO
*         BUKRS
*         from_Date
*         to_date
*         MORT_DETAILS
*         ZZIMPDOM
*         ZZMEGAREM
*         ZZVAL_REMARK
*         ZZEXCL_CHRG
*  FROM ZMORTGAGE INTO CORRESPONDING FIELDS OF TABLE IT_MORTGAGE
*  WHERE ASSET_NO EQ ITAB_DATA-ANLN1 AND
*        ASSET_SUBNO EQ ITAB_DATA-ANLN2 AND
*        BUKRS EQ ITAB_DATA-BUKRS.


* ZMORTGAGE table fields
  DATA : WA_MORTGAGE TYPE ZMORTGAGE.
  SELECT SINGLE *
  FROM ZMORTGAGE INTO WA_MORTGAGE
  WHERE ASSET_NO EQ ITAB_DATA-ANLN1 AND
        ASSET_SUBNO EQ ITAB_DATA-ANLN2 AND
        BUKRS EQ ITAB_DATA-BUKRS.

  SELECT SINGLE *
  FROM ZASSET_DETAILS INTO ITAB_DATA1
  WHERE BUKRS EQ ITAB_DATA-BUKRS AND
        ANLN1 EQ ITAB_DATA-ANLN1 AND
        ANLN2 EQ ITAB_DATA-ANLN2.



* ZASSET_DETAILS table fields
*  SELECT BUKRS
*         ANLN1
*         ANLN2
*         ASSET_NAME_OLD
*         INVNO
*         INVDATE
*         PUR_AMT
*         OTHERCOST
*         CAPCOST
*         INST_CHRG_AMT
*         DUTY_AMT
*         FREIGHT_AMT
*         CLEARING_AMT
*         INTEREST_AMT
*         RTO_AMT
*         INSURANCE_AMT
*         VAT_DISALLWD_AMT
*         SRVPRMINT_AMT
*         SITEDEVDEP_AMT
*         FERDCAP_AMT
*         FEE
*         DEPRIRATE
*         WDV_VALUE
*         DISPOS
*         GAT_NO
*         AREA_HECT
*         AREA_ACRE
*         SAPFIDOC
*         MIRONO
*         FURN_OFFI
*         FC
*         FC_RATE
*         FC_AMT
*         VAT
*         CENVAT
*         CST
*         SERV_TAX
*         AST_GRP
*         BUCAT
*         SEGMENT1
*         BU_JPK
*         LOCATION_JPK
*         MACHINFROM
*         MACHINTO
*         FAYEAR
*         BKGDATE
*         BUCODE
*         BUNAME
*         SEGMENT2
*         SEGNAME
*         REMARK_1
*         REMARK_2
*         REMARK_3
*         REMARK_4
*         REMARK_5
*
*   FROM ZASSET_DETAILS
*  INTO CORRESPONDING FIELDS OF TABLE ITAB_DATA1
*  WHERE BUKRS EQ ITAB_DATA-BUKRS AND ANLN1 EQ ITAB_DATA-ANLN1.

************************* Filling final table ITAB_DATA *************************************

  ITAB_DATA-HERST            = WA_ANLA-HERST.
  ITAB_DATA-INVNR            = WA_ANLA-INVNR.
  ITAB_DATA-TXT50            = WA_ANLA-TXT50.
  ITAB_DATA-TXA50            = WA_ANLA-TXA50.
  ITAB_DATA-SERNR            = WA_ANLA-SERNR.
  ITAB_DATA-DEAKT            = WA_ANLA-DEAKT.                            "Added by KOMAL M. on 04-09-2024


  ITAB_DATA-ASSET_NAME_OLD   =  ITAB_DATA1-ASSET_NAME_OLD   .
  ITAB_DATA-INVNO            =  ITAB_DATA1-INVNO            .
  ITAB_DATA-INVDATE          =  ITAB_DATA1-INVDATE          .
  ITAB_DATA-PUR_AMT          =  ITAB_DATA1-PUR_AMT          .
  ITAB_DATA-OTHERCOST        =  ITAB_DATA1-OTHERCOST        .
  ITAB_DATA-CAPCOST          =  ITAB_DATA1-CAPCOST          .
  ITAB_DATA-INST_CHRG_AMT    =  ITAB_DATA1-INST_CHRG_AMT    .
  ITAB_DATA-DUTY_AMT         =  ITAB_DATA1-DUTY_AMT         .
  ITAB_DATA-FREIGHT_AMT      =  ITAB_DATA1-FREIGHT_AMT      .
  ITAB_DATA-CLEARING_AMT     =  ITAB_DATA1-CLEARING_AMT     .
  ITAB_DATA-INTEREST_AMT     =  ITAB_DATA1-INTEREST_AMT     .
  ITAB_DATA-RTO_AMT          =  ITAB_DATA1-RTO_AMT          .
  ITAB_DATA-INSURANCE_AMT    =  ITAB_DATA1-INSURANCE_AMT    .
  ITAB_DATA-VAT_DISALLWD_AMT =  ITAB_DATA1-VAT_DISALLWD_AMT .
  ITAB_DATA-SRVPRMINT_AMT    =  ITAB_DATA1-SRVPRMINT_AMT    .
  ITAB_DATA-SITEDEVDEP_AMT   =  ITAB_DATA1-SITEDEVDEP_AMT   .
  ITAB_DATA-FERDCAP_AMT      =  ITAB_DATA1-FERDCAP_AMT      .
  ITAB_DATA-FEE              =  ITAB_DATA1-FEE              .

  ITAB_DATA-TOTALCOST        =  ITAB_DATA-PUR_AMT           +
                                ITAB_DATA-OTHERCOST         +
                                ITAB_DATA-CAPCOST           +
                                ITAB_DATA-INST_CHRG_AMT     +
                                ITAB_DATA-DUTY_AMT          +
                                ITAB_DATA-FREIGHT_AMT       +
                                ITAB_DATA-CLEARING_AMT      +
                                ITAB_DATA-INTEREST_AMT      +
                                ITAB_DATA-RTO_AMT           +
                                ITAB_DATA-INSURANCE_AMT     +
                                ITAB_DATA-VAT_DISALLWD_AMT  +
                                ITAB_DATA-SRVPRMINT_AMT     +
                                ITAB_DATA-SITEDEVDEP_AMT    +
                                ITAB_DATA-FERDCAP_AMT       +
                                ITAB_DATA-FEE.

  ITAB_DATA-CHECK_ASSET_VAL  =  ITAB_DATA-BTR1 - ITAB_DATA-TOTALCOST.   " Chk asst val = cum aqui val - totalcost.

  ITAB_DATA-DEPRIRATE        =  ITAB_DATA1-DEPRIRATE        .
  ITAB_DATA-WDV_VALUE        =  ITAB_DATA1-WDV_VALUE        .
  ITAB_DATA-DISPOS           =  ITAB_DATA1-DISPOS           .
  ITAB_DATA-GAT_NO           =  ITAB_DATA1-GAT_NO           .
  ITAB_DATA-AREA_HECT        =  ITAB_DATA1-AREA_HECT        .
  ITAB_DATA-AREA_ACRE        =  ITAB_DATA1-AREA_ACRE        .
  ITAB_DATA-SAPFIDOC         =  ITAB_DATA1-SAPFIDOC         .
  ITAB_DATA-MIRONO           =  ITAB_DATA1-MIRONO           .
  ITAB_DATA-FURN_OFFI        =  ITAB_DATA1-FURN_OFFI        .
  ITAB_DATA-FC               =  ITAB_DATA1-FC               .
  ITAB_DATA-FC_RATE          =  ITAB_DATA1-FC_RATE          .
  ITAB_DATA-FC_AMT           =  ITAB_DATA1-FC_AMT           .
  ITAB_DATA-VAT              =  ITAB_DATA1-VAT              .
  ITAB_DATA-CENVAT           =  ITAB_DATA1-CENVAT           .
  ITAB_DATA-CST              =  ITAB_DATA1-CST              .
  ITAB_DATA-SERV_TAX         =  ITAB_DATA1-SERV_TAX         .
  ITAB_DATA-AST_GRP          =  ITAB_DATA1-AST_GRP          .
  ITAB_DATA-BUCAT            =  ITAB_DATA1-BUCAT            .
  ITAB_DATA-SEGMENT1         =  ITAB_DATA1-SEGMENT1         .
  ITAB_DATA-BU_JPK           =  ITAB_DATA1-BU_JPK           .
  ITAB_DATA-LOCATION_JPK     =  ITAB_DATA1-LOCATION_JPK     .
  ITAB_DATA-MACHINFROM       =  ITAB_DATA1-MACHINFROM       .
  ITAB_DATA-MACHINTO         =  ITAB_DATA1-MACHINTO         .
  ITAB_DATA-FAYEAR           =  ITAB_DATA1-FAYEAR           .
  ITAB_DATA-BKGDATE          =  ITAB_DATA1-BKGDATE          .
  ITAB_DATA-BUCODE           =  ITAB_DATA1-BUCODE           .
  ITAB_DATA-BUNAME           =  ITAB_DATA1-BUNAME           .
  ITAB_DATA-SEGMENT2         =  ITAB_DATA1-SEGMENT2         .
  ITAB_DATA-SEGNAME          =  ITAB_DATA1-SEGNAME          .
  ITAB_DATA-REMARK_1         =  ITAB_DATA1-REMARK_1         .
  ITAB_DATA-REMARK_2         =  ITAB_DATA1-REMARK_2         .
  ITAB_DATA-REMARK_3         =  ITAB_DATA1-REMARK_3         .
  ITAB_DATA-REMARK_4         =  ITAB_DATA1-REMARK_4         .
  ITAB_DATA-REMARK_5         =  ITAB_DATA1-REMARK_5         .
  ITAB_DATA-REMARK_6         =  ITAB_DATA1-REMARK_6         .

*    READ TABLE IT_T095 WITH KEY KTOGR = IT_ANLA-KTOGR .

  ITAB_DATA-KTANSW           = WA_T095-KTANSW.

*    READ TABLE IT_T095B WITH KEY KTOGR = IT_ANLA-KTOGR .

  ITAB_DATA-KTNAFB           = WA_T095B-KTNAFB.
  ITAB_DATA-KTNAFG           = WA_T095B-KTNAFG.

*    READ TABLE IT_SAPNAMEDR WITH KEY SAKNR = ITAB_DATA-KTNAFG .
  ITAB_DATA-SAPNAMEDR        = WA_SAPNAMEDR-TXT50.

*    READ TABLE IT_SAPNAMECR WITH KEY SAKNR = ITAB_DATA-KTNAFB .
  ITAB_DATA-SAPNAMECR        = WA_SAPNAMECR-TXT50 .

*    READ TABLE IT_ANLH WITH KEY BUKRS = ITAB_DATA-BUKRS
*                                ANLN1 = ITAB_DATA-ANLN1 .
  ITAB_DATA-ANLHTXT          = WA_ANLH-ANLHTXT.

*    READ TABLE IT_ANLZ WITH KEY BUKRS = ITAB_DATA-BUKRS
*                                ANLN1 = ITAB_DATA-ANLN1
*                                ANLN2 = ITAB_DATA-ANLN2 .
  ITAB_DATA-GSBER          = WA_ANLZ-GSBER.
  ITAB_DATA-MSFAK          = WA_ANLZ-MSFAK.

  ITAB_DATA-YR_ADD_AMT     = LV_ANBTR_ADD.
  ITAB_DATA-YR_SUB_AMT     = LV_ANBTR_SUB.


*    READ TABLE IT_MORTGAGE WITH KEY ASSET_NO    = ITAB_DATA-ANLN1
*                                    ASSET_SUBNO = ITAB_DATA-ANLN2
*                                    BUKRS       = ITAB_DATA-BUKRS .
  ITAB_DATA-MORT_DETAILS   = WA_MORTGAGE-MORT_DETAILS.
  ITAB_DATA-ZZIMPDOM       = WA_MORTGAGE-ZZIMPDOM.
  ITAB_DATA-ZZMEGAREM      = WA_MORTGAGE-ZZMEGAREM.
  ITAB_DATA-ZZVAL_REMARK   = WA_MORTGAGE-ZZVAL_REMARK.
  ITAB_DATA-ZZEXCL_CHRG    = WA_MORTGAGE-ZZEXCL_CHRG.



   ENDFORM.                    " ADD_CUSTOM_FIELDS
