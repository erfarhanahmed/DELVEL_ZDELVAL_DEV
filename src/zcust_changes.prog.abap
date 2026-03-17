**&---------------------------------------------------------------------*
**& REPORT ZCUST_CHANGES
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*
REPORT ZCUST_CHANGES MESSAGE-ID FR NO STANDARD PAGE HEADING
                                               LINE-SIZE 132..
*DATA P_FOLDER.


*----------------------------------------------------------------------*
* DISPLAY OF CHANGED DOCUMENTS
*----------------------------------------------------------------------*

*------ STANDARD-RAHMENTEXTE FÜR SELEKTIONSBILD ------------------------
INCLUDE ZRFDBRMAC.

TABLES: SSCRFIELDS.
TABLES: BHDGD,
        BKPF,
        CDHDR,                                             "#EC NEEDED
        KNA1,
        KNB1,
        KNVV,
        T001,
        T055,
        T055G,
        TVTA.

*------ VARIABLEN ------------------------------------------------------
DATA: ACTVT        LIKE TACT-ACTVT          "AKTIVITÄTSTYP
                   VALUE '08',
      CHAR1(1)     TYPE C,                  "HILFSFELD
      FLDLENG      LIKE DD03P-INTLEN,       "FELDLÄNGE
      FLDTEXT(20)  TYPE C,                  "FELDTEXT          "1056664
      FLDTYPE(15)  TYPE C,                  "FELDTYP
      KEYSTR(70)   TYPE C,                  "AUSGABE DER WEIT. KEYFELDER
      LIN          TYPE P,                  "ANZAHL TABELLENZEILEN
      LOW_DATUM    LIKE CDHDR-UDATE,        "KLEINSTES SELEKTERTES DATUM
      HIGH_DATUM   LIKE CDHDR-UDATE,        "HÖCHSTES SELEKTERTES DATUM
      OBJEKT       LIKE CDHDR-OBJECTCLAS,   "ÄNDBELOBJEKT ( = DEBI )
      POS2         TYPE I,                  "POSITION: 'NEUER WERT'
                                            "BZW. 'WEITERE SCHLÜSSEL'
      SUBRC        LIKE SY-SUBRC,           "HILFSFELD: RÜCKGABEWERT
      TABFELD      LIKE RFCU3-FNAME,        "TABELLENFELD (TABELLE-FELD)
      TEXT20(20)   TYPE C,                  "HILFSFELD
      UHRZEIT      LIKE CDHDR-UTIME,        "FÜR EXPORTPAR. FKTBAUSTEIN
      USRNAME      LIKE CDHDR-USERNAME,     "FÜR EXPORTPAR. FKTBAUSTEIN
      UZEIT(5)     TYPE C,                                 "#EC NEEDED
      XCOLOR(1)    TYPE C,                  "X = COLOR INTENSIFIED
      XERRPROT(1)  TYPE C,                                 "#EC NEEDED
      XFELD(1)     TYPE C,                  "HILFSFELD
      XGRUPP(1)    TYPE C,                  "X = FELDGRUPPEN SELEKTIERT
      XSELE(1)     TYPE C,                  "X = MIND. 1 SATZ SELEKTIERT
      CHD_DATE     TYPE CDDATUM,            "ÄNDERUNGSDATUM
      CHD_USER     TYPE CDUSERNAME.         "GEÄNDERT VON


*------ INTERNE TABELLEN -----------------------------------------------
DATA:   BEGIN OF DSCTAB OCCURS 100,         "BESCHREIBUNG ZU DEBITOR
          KUNNR     LIKE KNA1-KUNNR,
          DSCRP(40) TYPE C,
        END   OF DSCTAB.

DATA:   BEGIN OF EXCTAB_F_KNA1_BUK OCCURS 5,"BUKRS: KEINE BERECHTIGUNG
          BUKRS LIKE KNB1-BUKRS,
        END   OF EXCTAB_F_KNA1_BUK.

DATA:   BEGIN OF EXCTAB_V_KNA1_VKO OCCURS 5,"VTBER.: KEINE BERECHTIGUNG
          VKORG LIKE KNVV-VKORG,
          VTWEG LIKE KNVV-VTWEG,
          SPART LIKE KNVV-SPART,
        END   OF EXCTAB_V_KNA1_VKO.

DATA:   BEGIN OF FLDTAB OCCURS 20,          "AUSGEWÄHLTE FELDER (T055)
          TABNAME LIKE CDSHW-TABNAME,
          FNAME   LIKE CDSHW-FNAME,
        END   OF FLDTAB.

DATA:   BEGIN OF HELPCDPOS OCCURS 10.       "ÄNDERUNGSBELEGE: POSITIONS
          INCLUDE STRUCTURE CDSHW.          "(HILFSTAB. FÜR FKTAUFRUF)
DATA:   END   OF HELPCDPOS.

DATA:   BEGIN OF ICDHDR OCCURS 100.         "ÄNDERUNGSBELEGE: HEADER
          INCLUDE STRUCTURE CDHDR.
DATA:   END   OF ICDHDR.

DATA:   BEGIN OF ICDPOS OCCURS 10.          "ÄNDERUNGSBELEGE: POSITIONS
          INCLUDE STRUCTURE CDSHW.
DATA:     KUNNR LIKE KNA1-KUNNR,
          BUKRS LIKE KNB1-BUKRS,
          VKORG LIKE KNVV-VKORG,
          VTWEG LIKE KNVV-VTWEG,
          SPART LIKE KNVV-SPART,
        END   OF ICDPOS.

DATA:   BEGIN OF KUNNRTAB OCCURS 0,
          KUNNR LIKE KNA1-KUNNR,
          XRELE_ALG LIKE BOOLE-BOOLE,
          XRELE_BUKRS LIKE BOOLE-BOOLE,
          XRELE_VKORG LIKE BOOLE-BOOLE,
        END   OF KUNNRTAB.

DATA:   BEGIN OF MSGTAB.                    "MESSAGES F. FEHLERPROTOKOLL
          INCLUDE STRUCTURE FIMSG.
DATA:   END   OF MSGTAB.

DATA:   BEGIN OF OLD,
          TABNAME LIKE CDSHW-TABNAME,
          TABKEY  LIKE CDSHW-TABKEY,
          FNAME   LIKE CDSHW-FNAME,
          F_NEW   LIKE CDSHW-F_NEW,
          F_OLD   LIKE CDSHW-F_OLD,
        END   OF OLD.

DATA:   BEGIN OF FLDATTRTAB OCCURS 100,     "SCHLÜSSELWORTE
          TBNAM        LIKE DD03P-TABNAME,
          FDNAM        LIKE DD03P-FIELDNAME,
          TEXT         LIKE DD03P-SCRTEXT_L,
          DATATYPE     LIKE DD03P-DATATYPE,
          INTLEN       LIKE DD03P-INTLEN,
        END   OF FLDATTRTAB.

RANGES: GR_ADRNR  FOR KNA1-ADRNR.
DATA:   BEGIN OF GT_KUNADR OCCURS 1,
          KUNNR        LIKE KNA1-KUNNR,
          ADRNR        LIKE KNA1-ADRNR,
          BEGRU        LIKE KNA1-BEGRU,
          KTOKD        LIKE KNA1-KTOKD,
        END OF GT_KUNADR.

RANGES: GR_OBJECTID  FOR CDHDR-OBJECTID.
RANGES: GR_KUNNR     FOR KNA1-KUNNR.              "1661114

* ALV DEFINITIONS
TYPE-POOLS: SLIS.

CONSTANTS:
  GC_SET       TYPE C VALUE 'X',          "BACK/EXIT/CANCEL
  GC_VALUE_X   TYPE C VALUE 'X',
  GC_ENDOFLIST TYPE SLIS_ALV_EVENT-FORM VALUE 'END_OF_LIST',
  GC_TOPOFPAGE TYPE SLIS_ALV_EVENT-FORM VALUE 'TOP_OF_PAGE',
  GC_PF_STATUS_SET TYPE SLIS_ALV_EVENT-FORM VALUE 'PF_STATUS_SET'.
* GC_PF_STATUS TYPE SLIS_ALV_EVENT-FORM VALUE PF_STATUS.
* STRUCTURE FOR 'BACK', 'EXIT' AND 'CANCEL'.
DATA: GS_EXIT_CAUSED_BY_USER TYPE SLIS_EXIT_BY_USER.
DATA: G_REPID                LIKE SY-REPID.

* DECLARATION OF INTERNAL OUTPUT STRUCTURE
DATA: BEGIN OF GS_OUTTAB.
*        INCLUDE STRUCTURE ZFOAP_ACC_S_RFDABL00_LIST.
        INCLUDE STRUCTURE FOAP_ACC_S_RFDABL00_LIST.
DATA:   F_OLD_35(35),
        F_NEW_35(35),
       END OF GS_OUTTAB.
* DECLARATION OF INTERNAL OUTPUT TABLE
DATA: GT_OUTTAB LIKE GS_OUTTAB OCCURS 0.

****************************************************** ADD BY SUPRIYA ON 23.07.2024

* DECLARATION OF INTERNAL OUTPUT STRUCTURE
DATA: BEGIN OF LS_OUTTAB1.
*        INCLUDE STRUCTURE FOAP_ACC_S_RFDABL00_LIST.   "ZFOAP_ACC_S_RFDABL00_LIST
         INCLUDE STRUCTURE ZFOAP_ACC_S_RFDABL00_LIST1.
DATA:   F_OLD_35(35),
        F_NEW_35(35),
       END OF LS_OUTTAB1.
* DECLARATION OF INTERNAL OUTPUT TABLE
DATA: LT_OUTTAB1 LIKE LS_OUTTAB1 OCCURS 0.


*********************************************************
DATA: GS_VARIANT         TYPE DISVARIANT,
      G_MAXLEN_OLDNEWVAL TYPE I.

DATA: GD_TPC_CHECK TYPE CHAR1 VALUE SPACE.


*------ PARAMETERS UND SELECT-OPTIONS ----------------------------------
 SELECTION-SCREEN :BEGIN OF BLOCK I WITH FRAME TITLE TEXT-000 .
*   BEGIN_OF_BLOCK 0.                                         "#EC *
  SELECT-OPTIONS:  KUNNR FOR  KNA1-KUNNR MATCHCODE OBJECT DEBI,
                   DATUM FOR  CHD_DATE,
                   UNAME FOR  CHD_USER.
*  END_OF_BLOCK 0.
  SELECTION-SCREEN :END OF BLOCK I .

SELECTION-SCREEN :BEGIN OF BLOCK J WITH FRAME TITLE TEXT-002  .
*BEGIN_OF_BLOCK 1.                                          "#EC *
  PARAMETERS:      XALG  LIKE RFPDO1-KABLXALG DEFAULT 'X'.
  PARAMETERS:      XALL  LIKE RFPDO1-DABLXALL DEFAULT 'X'.
  SELECTION-SCREEN SKIP 1.
  PARAMETERS:      XBUK  LIKE RFPDO1-KABLXBUK DEFAULT 'X'.
  SELECT-OPTIONS:  BUKRS FOR  KNB1-BUKRS.
  SELECTION-SCREEN SKIP 1.
  PARAMETERS:      XVKO  LIKE RFPDO1-DABLXVKO DEFAULT 'X'.
  SELECT-OPTIONS:  VKORG FOR  KNVV-VKORG.
  SELECT-OPTIONS:  VTWEG FOR  KNVV-VTWEG.
  SELECT-OPTIONS:  SPART FOR  KNVV-SPART.
  SELECTION-SCREEN SKIP 1.
  SELECT-OPTIONS:  GRUPP FOR  T055-GRUPP.
*END_OF_BLOCK 1.
SELECTION-SCREEN :END OF BLOCK J.

SELECTION-SCREEN :BEGIN OF BLOCK K WITH FRAME TITLE TEXT-003 .
*BEGIN_OF_BLOCK 2.                                          "#EC *
  PARAMETERS: SORT    LIKE RFPDO1-KABLSORT DEFAULT '1' NO-DISPLAY,
              P_VARIA LIKE DISVARIANT-VARIANT.
*END_OF_BLOCK 2.
SELECTION-SCREEN :END OF BLOCK K.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-004 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/DELVAL/TEMP'. " '/DELVAL/TEMP'.                 "/DELVAL/USA'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-005.
SELECTION-SCREEN  COMMENT /1(60) TEXT-006.
SELECTION-SCREEN: END OF BLOCK B3.


*------ FELDGRUPPEN ----------------------------------------------------
FIELD-GROUPS: HEADER,
              DATEN.

INSERT
  ICDHDR-USERNAME
  ICDHDR-UDATE
  ICDHDR-UTIME
  ICDHDR-CHANGENR
  ICDPOS-KUNNR
  ICDPOS-BUKRS
  ICDPOS-VKORG
  ICDPOS-VTWEG
  ICDPOS-SPART
******************
** ADD BY SUPRIYA ON 24.07.2024
*  ICDHDR-ZUSERNAME
*  ICDHDR-ZUDATE
******************
  FLDTEXT
  TABFELD
INTO HEADER.

INSERT
  ICDPOS-TABNAME
  ICDPOS-TABKEY
  ICDPOS-FNAME
  ICDPOS-CHNGIND
  ICDPOS-F_OLD
  ICDPOS-F_NEW
  FLDTYPE
  FLDLENG
INTO DATEN.

*------ ALLGEMEIN GÜLTIGE FORM-ROUTINEN --------------------------------
 INCLUDE ZRFXABL00.


***********************************************************************
* INITIALIZATION                                                      *
***********************************************************************
INITIALIZATION.

*------ TITEL FÜR STANDARDFENSTER AUF SELEKTIONSBILD HOLEN -------------
*GET_FRAME_TITLE: 0,1,2.

* INITIALIZING THE ALV VARIANT PARAMETER WITH THE DEFAULT VARIANT.
  PERFORM VARIANT_INIT CHANGING GS_VARIANT.

* CHECK PROGRAM AUTHORIZATION (TPC)
  PERFORM CHECK_PROGRAM_AUTH
    CHANGING
      GD_TPC_CHECK.

***********************************************************************
* AT SELECTION-SCREEN                                                 *
***********************************************************************
*------ EINGABE IM FELD 'SORTIERUNG' PRÜFEN ----------------------------
AT SELECTION-SCREEN ON SORT.
  PERFORM SORT_PRUEFEN.

*------ MINDESTENS EIN ANZUZEIGENDER DATENBEREICH ANGEKREUZT ? ---------
AT SELECTION-SCREEN.
  IF  XALG IS INITIAL
  AND XBUK IS INITIAL
  AND XVKO IS INITIAL.
    SET CURSOR FIELD 'XALG'.
*    MESSAGE E270.
*      MESSAGE ZE270.
  ENDIF.

*------ BERECHTIGUNG F_KNA1_APP PRÜFEN ---------------------------------
  PERFORM AUTHORITY_F_KNA1_APP.
* CHECK TIME FRAME AUTHORIZATION (TPC)
  IF NOT GD_TPC_CHECK IS INITIAL.
    IF SSCRFIELDS-UCOMM = SPACE
    OR SSCRFIELDS-UCOMM = 'ONLI'.
      PERFORM CHECK_DATE
        USING
          BUKRS[].
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_VARIA.
  PERFORM F4_HELP_FOR_VARIANT USING GS_VARIANT.

AT SELECTION-SCREEN ON P_VARIA.
  PERFORM CHECK_VARIANT CHANGING GS_VARIANT.

AT SELECTION-SCREEN OUTPUT.
  CHECK NOT GD_TPC_CHECK IS INITIAL.
  PERFORM SCREEN_MODIFY_TPC
    USING 'DATUM-LOW' 'XALL'.

***********************************************************************
* START-OF-SELECTION                                                  *
***********************************************************************
START-OF-SELECTION.
  PERFORM ZBATCH_HEADING.
  PERFORM ZFELDATTRIBUTE_LESEN.
  PERFORM ZAENDBELEGE_LESEN.
  PERFORM ZAENDPOSITIONEN_SORTIEREN.
  PERFORM ZAENDPOSITIONEN_AUSGEBEN.

  G_REPID = SY-REPID.
  DESCRIBE TABLE GT_OUTTAB.
  PERFORM OUTPUT_LIST_ALV.

* WRITE LOG FOR TPC
  IF NOT GD_TPC_CHECK IS INITIAL.
    PERFORM WRITE_LOG_TPC.
  ENDIF.

***********************************************************************
* FORM - ROUTINEN                                                     *
***********************************************************************

*---------------------------------------------------------------------*
* FORM AENDBELEGE_LESEN                                               *
*---------------------------------------------------------------------*
* EINLESEN DER ÄNDERUNGSBELEGE ZUR SELEKTION                          *
*---------------------------------------------------------------------*
FORM AENDBELEGE_LESEN.

*------ TABELLEN FÜR BERECHTIGUNGSPRÜFUNGEN DER OBJEKTE F_LFA1_BUK -----
*------ UND F_LFA1_EKO FÜLLEN                                      -----
  PERFORM EXCTAB_FUELLEN.

*------ ERMITTLE DEN KLEINSTEN SELEKTIERTEN WERT FÜR ÄNDERUNGSDATUM ----
  PERFORM LOW_DATUM_ERMITTELN.

*------ FLDTAB FÜLLEN MIT DEN FELDERN DER GEWÜNSCHTEN FELDGRUPPEN AUS --
*------ T055G                                                         --
  PERFORM FLDTAB_FUELLEN USING 'D'.

*------ TABELLE FÜR DIE ÄNDERUNGSBELEGKÖPFE INITIALISIEREN -------------
  CLEAR   ICDHDR.
  REFRESH ICDHDR.

*------ EXPORT-PARAMETER FÜR FB-AUFRUF FÜLLEN --------------------------
  OBJEKT = 'DEBI'.
  CLEAR UHRZEIT.

*------ BUILD RANGE WITH OBJECT ID -------------------------------------
  REFRESH GR_OBJECTID.
  LOOP AT KUNNR.
    MOVE-CORRESPONDING KUNNR TO GR_OBJECTID.
    APPEND GR_OBJECTID.
  ENDLOOP.

*------ BUILD MASTER DATA TABLE: ADDRESS & AUTHORIZATION ---------------
  CLEAR: GR_ADRNR, GT_KUNADR, GR_KUNNR.    "1661114
  REFRESH: GR_ADRNR, GT_KUNADR, GR_KUNNR.  "1661114
  GR_ADRNR-OPTION = 'EQ'.
  GR_ADRNR-SIGN   = 'I'.
  GR_KUNNR-OPTION = 'EQ'.                  "1661114
  GR_KUNNR-SIGN   = 'I'.
  LOOP AT KUNNR TRANSPORTING NO FIELDS
       WHERE SIGN NE 'I' OR
             OPTION NE 'EQ'.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC = 0 OR KUNNR[] IS INITIAL.       "1991544
    SELECT KUNNR ADRNR BEGRU KTOKD FROM KNA1
                 INTO GT_KUNADR
                 WHERE KUNNR IN KUNNR.
      IF NOT ( GT_KUNADR-BEGRU IS INITIAL ).
        AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                   ID  'BRGRU' FIELD GT_KUNADR-BEGRU
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.
      IF NOT ( GT_KUNADR-KTOKD IS INITIAL ).                     "914560
         AUTHORITY-CHECK OBJECT 'F_KNA1_GRP'
                   ID  'KTOKD' FIELD GT_KUNADR-KTOKD
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.                                                     "914560
      APPEND GT_KUNADR.
      GR_ADRNR-LOW = GT_KUNADR-ADRNR.
      APPEND GR_ADRNR.
      GR_KUNNR-LOW = GT_KUNADR-KUNNR.                          "1661114
      APPEND GR_KUNNR.                                         "1661114
    ENDSELECT.
  ELSE.
    SELECT KUNNR ADRNR BEGRU KTOKD FROM KNA1
                INTO GT_KUNADR
                FOR ALL ENTRIES IN KUNNR
                WHERE KUNNR = KUNNR-LOW.
      IF NOT ( GT_KUNADR-BEGRU IS INITIAL ).
        AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                   ID  'BRGRU' FIELD GT_KUNADR-BEGRU
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.
      IF NOT ( GT_KUNADR-KTOKD IS INITIAL ).                     "914560
         AUTHORITY-CHECK OBJECT 'F_KNA1_GRP'
                   ID  'KTOKD' FIELD GT_KUNADR-KTOKD
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.                                                     "914560
      APPEND GT_KUNADR.
      GR_ADRNR-LOW = GT_KUNADR-ADRNR.
      APPEND GR_ADRNR.
      GR_KUNNR-LOW = GT_KUNADR-KUNNR.                          "1661114
      APPEND GR_KUNNR.                                         "1661114
    ENDSELECT.
  ENDIF.

*------ EXPORT-PARAMETER USRNAME (ÄNDERER) FÜLLEN ----------------------
  PERFORM USRNAME_FUELLEN.

*------ ÄNDERUNGSBELEGKÖPFE ERMITTELN (AUFRUF DES FUNKTIONSBAUSTEINS) --
  PERFORM AENDBELEGE_ERMITTELN  TABLES GR_OBJECTID.
  DESCRIBE TABLE GR_KUNNR LINES LIN.                           "1661114
  IF NOT XALG IS INITIAL AND LIN NE 0.                 "1661114,1657998
    PERFORM ADD_IBAN_CHANGES USING OBJEKT GR_KUNNR[].     "NOTE 1575845
  ENDIF.                                                       "1657998
*------ SECOND CALL: GET CENTRAL ADDRESS CHANGES -----------------------
  IF NOT XALG IS INITIAL.
    OBJEKT = 'ADRESSE'.
    REFRESH GR_OBJECTID.
    CLEAR GR_OBJECTID.
    DESCRIBE TABLE GR_ADRNR LINES LIN.
    IF LIN < 200.
      GR_OBJECTID-OPTION = 'EQ'.
      GR_OBJECTID-SIGN   = 'I'.
      LOOP AT GR_ADRNR.
        WRITE 'BP' TO GR_OBJECTID-LOW.
        WRITE GR_ADRNR-LOW TO GR_OBJECTID-LOW+4 USING NO EDIT MASK.
        APPEND GR_OBJECTID.
      ENDLOOP.
    ENDIF.
    IF LIN <> 0.
      PERFORM AENDBELEGE_ERMITTELN  TABLES GR_OBJECTID.
    ENDIF.
  ENDIF.
ENDFORM.                    "AENDBELEGE_LESEN

*---------------------------------------------------------------------*
* FORM AENDPOSITIONEN_AUSGEBEN                                        *
*---------------------------------------------------------------------*
* DIE ÄNDERUNGSBELEGPOSITIONEN WERDEN AUSGEGEBEN                      *
*---------------------------------------------------------------------*
FORM AENDPOSITIONEN_AUSGEBEN.

*------ FARBE DER ERSTEN POSITION IST COL_NORMAL INTENSIFIED -----------
  XCOLOR = ' '.

*------ LOOP ÜBER ALLE RELEVANTEN ÄNDERUNGSBELEGPOSITIONEN -------------
  LOOP.

*------ SORTIERUNG <> '4': NUMERISCHE FELDER LINKSBÜNDIG AUSGEBEN ------
    IF SORT <> '4'.
      PERFORM ZAHLEN_LINKSBUENDIG.
    ENDIF.

*------ ZAHLEN UND DATUMSWERTE MIT INITIALWERT ALS SPACE AUSGEBEN ------
    PERFORM ZAHLEN_INITIALISIEREN.

    CLEAR GS_OUTTAB.
    MOVE: ICDHDR-UDATE     TO GS_OUTTAB-UDATE,
          ICDHDR-UTIME     TO GS_OUTTAB-UTIME,
          ICDHDR-USERNAME  TO GS_OUTTAB-USERNAME,
          ICDPOS-KUNNR     TO GS_OUTTAB-KUNNR,
          FLDTEXT          TO GS_OUTTAB-FNAME,
          ICDPOS-BUKRS     TO GS_OUTTAB-BUKRS,
          ICDPOS-VKORG     TO GS_OUTTAB-VKORG,
          ICDPOS-VTWEG     TO GS_OUTTAB-VTWEG,
          ICDPOS-SPART     TO GS_OUTTAB-SPART.
******************************************************
*    ADD BY SUPRIYA ON 24.07.2024
*          ICDPOS-ZUDATE     TO  GS_OUTTAB-ZUDATE,
*          ICDPOS-ZUDATE     TO GS_OUTTAB-ZUDATE.
*********************************************************
*   CHANGED WITH NOTE 1691291
    IF ICDPOS-F_OLD+32(6) NE SPACE OR ICDPOS-F_NEW+32(6) NE SPACE.
      DATA: L_POS_TECH TYPE INT4.

      IF ICDPOS-F_OLD NE SPACE.
        CALL METHOD CL_SCP_LINEBREAK_UTIL=>STRING_SPLIT_AT_POSITION
          EXPORTING
           IM_STRING        = ICDPOS-F_OLD
           IM_LANGU         = SY-LANGU
           IM_POS_TECH      = '35'
           IM_POS_VIS       = '35'
           IM_BOUNDARY_KIND = CL_SCP_LINEBREAK_UTIL=>C_BOUNDARY_GRAPHEME
          IMPORTING
           EX_POS_TECH      = L_POS_TECH.
        MOVE: ICDPOS-F_OLD+0(L_POS_TECH) TO GS_OUTTAB-F_OLD,
              ICDPOS-F_OLD+L_POS_TECH TO GS_OUTTAB-F_OLD_35.
      ENDIF.

      IF ICDPOS-F_NEW NE SPACE.
        CALL METHOD CL_SCP_LINEBREAK_UTIL=>STRING_SPLIT_AT_POSITION
          EXPORTING
           IM_STRING        = ICDPOS-F_NEW
           IM_LANGU         = SY-LANGU
           IM_POS_TECH      = '35'
           IM_POS_VIS       = '35'
           IM_BOUNDARY_KIND = CL_SCP_LINEBREAK_UTIL=>C_BOUNDARY_GRAPHEME
          IMPORTING
           EX_POS_TECH      = L_POS_TECH.
        MOVE: ICDPOS-F_NEW+0(L_POS_TECH) TO GS_OUTTAB-F_NEW,
              ICDPOS-F_NEW+L_POS_TECH TO GS_OUTTAB-F_NEW_35.
      ENDIF.

    ELSE.
      MOVE: ICDPOS-F_OLD+0(35) TO GS_OUTTAB-F_OLD,
            ICDPOS-F_NEW+0(35) TO GS_OUTTAB-F_NEW,
            ICDPOS-F_OLD+35    TO GS_OUTTAB-F_OLD_35,
            ICDPOS-F_NEW+35    TO GS_OUTTAB-F_NEW_35.
    ENDIF.
*   CHANGED WITH NOTE 1691291

    PERFORM POSZEILE2_AUSGEBEN CHANGING GS_OUTTAB-DSCRP
                                        GS_OUTTAB-TABFELD       " BY SUPRIYA ON 24.07.2024
                                        GS_OUTTAB-OTHER_KEYS.

    IF STRLEN(  GS_OUTTAB-F_OLD ) > G_MAXLEN_OLDNEWVAL.
      G_MAXLEN_OLDNEWVAL = STRLEN(  GS_OUTTAB-F_OLD ).
    ENDIF.

    IF STRLEN(  GS_OUTTAB-F_NEW ) > G_MAXLEN_OLDNEWVAL.
      G_MAXLEN_OLDNEWVAL = STRLEN(  GS_OUTTAB-F_NEW ).
    ENDIF.

    IF ICDPOS-TABNAME = 'KNBK'.                         "NOTE 1551976
      PERFORM REPLACE_TECH_ACCOUNT USING ICDPOS-TABKEY
                                    CHANGING GS_OUTTAB.
    ENDIF.
    APPEND GS_OUTTAB TO GT_OUTTAB.

  ENDLOOP.

*** BADI FI_RFDABL00_CHGDOC                                    "1340919
  DATA: LD_REF_TO_CHDOC  TYPE REF TO IF_EX_FI_RFDABL00_CHGDOC,
        LD_ACT_IMP_CHDOC TYPE C.
  DATA: LD_SELOPT LIKE RSDSSELOPT,
        LT_SELOPT TYPE RSDS_SELOPT_T,
        LD_FRANGE TYPE RSDS_FRANGE,
        LT_FRANGE TYPE RSDS_FRANGE_T.

  DATA: LT_OUTTAB TYPE TABLE OF FOAP_ACC_S_RFDABL00_LIST.

  CALL METHOD CL_EXITHANDLER=>GET_INSTANCE
    EXPORTING
      EXIT_NAME              = 'FI_RFDABL00_CHGDOC'
      NULL_INSTANCE_ACCEPTED = 'X'
    IMPORTING
      ACT_IMP_EXISTING       = LD_ACT_IMP_CHDOC
    CHANGING
      INSTANCE               = LD_REF_TO_CHDOC.

  IF  NOT LD_ACT_IMP_CHDOC IS INITIAL
  AND NOT LD_REF_TO_CHDOC  IS INITIAL.


*   CREATE THE DYNAMIC SELECTIONS FOR THE
    IF NOT KUNNR[] IS INITIAL.
      REFRESH: LT_SELOPT.
      LD_FRANGE-FIELDNAME = 'KUNNR'.
      LOOP AT KUNNR.
        MOVE-CORRESPONDING KUNNR TO LD_SELOPT.
        APPEND LD_SELOPT TO LT_SELOPT.
      ENDLOOP.
      LD_FRANGE-SELOPT_T = LT_SELOPT[].
      APPEND LD_FRANGE TO LT_FRANGE.
    ENDIF.
    IF NOT DATUM[] IS INITIAL.
      REFRESH: LT_SELOPT.
      LD_FRANGE-FIELDNAME = 'DATUM'.
      LOOP AT DATUM.
        MOVE-CORRESPONDING DATUM TO LD_SELOPT.
        APPEND LD_SELOPT TO LT_SELOPT.
      ENDLOOP.
      LD_FRANGE-SELOPT_T = LT_SELOPT[].
      APPEND LD_FRANGE TO LT_FRANGE.
    ENDIF.
    IF NOT UNAME[] IS INITIAL.
      REFRESH: LT_SELOPT.
      LD_FRANGE-FIELDNAME = 'UNAME'.
      LOOP AT UNAME.
        MOVE-CORRESPONDING UNAME TO LD_SELOPT.
        APPEND LD_SELOPT TO LT_SELOPT.
      ENDLOOP.
      LD_FRANGE-SELOPT_T = LT_SELOPT[].
      APPEND LD_FRANGE TO LT_FRANGE.
    ENDIF.

    CALL METHOD LD_REF_TO_CHDOC->CHANGE_DOCUMENTS
       EXPORTING
         CT_SEL         = LT_FRANGE
       CHANGING
         CT_CHANGE_DOCS = LT_OUTTAB.

    LOOP AT LT_OUTTAB INTO GS_OUTTAB.
*     AUTHORITY AND VALIDITY CHECK FOR BUKRS
      IF NOT GS_OUTTAB-BUKRS IS INITIAL.
        LOOP AT EXCTAB_F_KNA1_BUK WHERE BUKRS = GS_OUTTAB-BUKRS.
         EXIT.
        ENDLOOP.
        CHECK SY-SUBRC NE 0.

        CHECK GS_OUTTAB-BUKRS IN BUKRS.
      ENDIF.

      APPEND GS_OUTTAB TO GT_OUTTAB.
    ENDLOOP.
  ENDIF.
*** BADI FI_RFDABL00_CHGDOC                                    "1340919

ENDFORM.                    "AENDPOSITIONEN_AUSGEBEN

*---------------------------------------------------------------------*
* FORM  AENDPOSITIONEN_LESEN                                          *
*---------------------------------------------------------------------*
* DIE POSITIONEN DER ÄNDERUNGSBELEGE WERDEN GELESEN.                  *
*---------------------------------------------------------------------*
FORM AENDPOSITIONEN_LESEN.

* ------ IN ICDHDR STEHEN ALLE KÖPFE -----------------------------------
  LOOP AT ICDHDR.

*------ UNNÖTIGE ÄNDERUNGSBELEGKÖPFE WEGWERFEN -------------------------
    CHECK ICDHDR-UDATE    IN DATUM
      AND ICDHDR-USERNAME IN UNAME.
    CASE OBJEKT.
      WHEN 'DEBI'.
        READ TABLE GT_KUNADR WITH KEY KUNNR = ICDHDR-OBJECTID.   "#EC *
        CHECK SY-SUBRC = 0.
      WHEN 'ADRESSE'.
        CHECK ICDHDR-OBJECTID+4(10) IN GR_ADRNR.
    ENDCASE.

*------ BELEGE ZU EINEM ÄNDERUNGSBELEGKOPF LESEN -----------------------
    PERFORM AENDPOSITIONEN_ERMITTELN.
  ENDLOOP.
ENDFORM.                    "AENDPOSITIONEN_LESEN

*---------------------------------------------------------------------*
* FORM AENDPOSITIONEN_SORTIEREN                                       *
*---------------------------------------------------------------------*
* DIE ÄNDERUNGSBELEGPOSITIONEN WERDEN SORTIERT                        *
*---------------------------------------------------------------------*
FORM AENDPOSITIONEN_SORTIEREN.
  CASE SORT.

*------ CHRONOLOGISCHE SORTIERUNG (DATUM, UHRZEIT) ---------------------
    WHEN '1'.
      SORT BY ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING
              FLDTEXT
              TABFELD.

*------ SORTIERUNG NACH DEBITOR ----------------------------------------
    WHEN '2'.
      SORT BY ICDPOS-KUNNR
              ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING
              FLDTEXT
              TABFELD.

*------ SORTIERUNG NACH ÄNDERER ----------------------------------------
    WHEN '3'.
      SORT BY ICDHDR-USERNAME
              ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING
              FLDTEXT
              TABFELD.

*------ SORTIERUNG NACH FELDNAME ---------------------------------------
    WHEN '4'.
      SORT BY FLDTEXT
              TABFELD
              ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING.
  ENDCASE.
ENDFORM.                    "AENDPOSITIONEN_SORTIEREN

*---------------------------------------------------------------------*
* FORM AUTHORITY_F_KNA1_APP                                           *
*---------------------------------------------------------------------*
* BERECHTIGUNGSPRÜFUNGEN FÜR DAS OBJEKT F_KNA1_APP DURCHFÜHREN        *
*---------------------------------------------------------------------*
FORM AUTHORITY_F_KNA1_APP.
  CLEAR CHAR1.
  CLEAR TEXT20.

*------ PRÜFUNG DURCHFÜHREN, WENN NUR XALG MARKIERT --------------------
  IF  XALG = 'X'
  AND XBUK = SPACE
  AND XVKO = SPACE.
    CHAR1  = 'F'.
    AUTHORITY-CHECK OBJECT 'F_KNA1_APP'
                  ID     'APPKZ' FIELD CHAR1
                  ID     'ACTVT' FIELD ACTVT.
    IF SY-SUBRC <> 0.
      CHAR1  = 'V'.
      AUTHORITY-CHECK OBJECT 'F_KNA1_APP'
                      ID     'APPKZ' FIELD CHAR1
                      ID     'ACTVT' FIELD ACTVT.
      IF SY-SUBRC <> 0.
        TEXT20 = TEXT-A09.
        SET CURSOR FIELD 'XALG'.
        MESSAGE E150(F4) WITH SPACE 'F_KNA1_APP' ACTVT TEXT20.
      ENDIF.
    ENDIF.

*------ PRÜFUNG DURCHFÜHREN, WENN XBUK MARKIERT WURDE ------------------
  ELSE.
    IF  XBUK = 'X'.
      CHAR1  = 'F'.
      AUTHORITY-CHECK OBJECT 'F_KNA1_APP'
                      ID     'APPKZ' FIELD CHAR1
                      ID     'ACTVT' FIELD ACTVT.
      IF SY-SUBRC <> 0.
        TEXT20 = TEXT-A01.
        SET CURSOR FIELD 'XBUK'.
        MESSAGE E150(F4) WITH TEXT20 'F_KNA1_APP' ACTVT CHAR1.
      ENDIF.
    ENDIF.

*------ PRÜFUNG DURCHFÜHREN, WENN XEKO MARKIERT WURDE ------------------
    IF  XVKO = 'X'.
      CHAR1  = 'V'.
      AUTHORITY-CHECK OBJECT 'F_KNA1_APP'
                      ID     'APPKZ' FIELD CHAR1
                      ID     'ACTVT' FIELD ACTVT.
      IF SY-SUBRC <> 0.
        TEXT20 = TEXT-A02.
        SET CURSOR FIELD 'XVKO'.
        MESSAGE E150(F4) WITH TEXT20 'F_KNA1_APP' ACTVT CHAR1.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "AUTHORITY_F_KNA1_APP

*---------------------------------------------------------------------*
* FORM AUTHORITY_F_KNA1_BUK                                           *
*---------------------------------------------------------------------*
* BERECHTIGUNGSPRÜFUNGEN FÜR DAS OBJEKT F_KNA1_BUK DURCHFÜHREN        *
*---------------------------------------------------------------------*
FORM AUTHORITY_F_KNA1_BUK USING ERGEBNIS LIKE SY-SUBRC.
  ERGEBNIS = 0.
  CHECK NOT ICDPOS-BUKRS IS INITIAL.

* ------ BERECHTIGUNG PRÜFEN -------------------------------------------
  LOOP AT EXCTAB_F_KNA1_BUK WHERE BUKRS = ICDPOS-BUKRS.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC = 0.

*------ NACHRICHT FÜR FEHLERPROTOKOLL VORMERKEN ------------------------
    ERGEBNIS = 4.
    CLEAR MSGTAB.
    MSGTAB-MSORT = '1'.
    MSGTAB-MSGID = 'F4'.
    MSGTAB-MSGTY = 'E'.
    MSGTAB-MSGNO = '159'.
    MSGTAB-MSGV1 = ICDPOS-BUKRS.
    CALL FUNCTION 'FI_MESSAGE_COLLECT'
      EXPORTING
        I_FIMSG = MSGTAB.
  ENDIF.
ENDFORM.                    "AUTHORITY_F_KNA1_BUK

*---------------------------------------------------------------------*
* FORM AUTHORITY_F_KNA1_VKO                                           *
*---------------------------------------------------------------------*
* BERECHTIGUNGSPRÜFUNGEN FÜR DAS OBJEKT F_KNA1_VKO DURCHFÜHREN        *
*---------------------------------------------------------------------*
FORM AUTHORITY_F_KNA1_VKO USING ERGEBNIS LIKE SY-SUBRC.
  ERGEBNIS = 0.
  CHECK NOT ICDPOS-VKORG IS INITIAL
    AND NOT ICDPOS-VTWEG IS INITIAL
    AND NOT ICDPOS-SPART IS INITIAL.

* ------ BERECHTIGUNG PRÜFEN -------------------------------------------
  LOOP AT EXCTAB_V_KNA1_VKO WHERE VKORG = ICDPOS-VKORG
                              AND VTWEG = ICDPOS-VTWEG
                              AND SPART = ICDPOS-SPART.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC = 0.

*------ NACHRICHT FÜR FEHLERPROTOKOLL VORMERKEN ------------------------
    ERGEBNIS = 4.
    CLEAR MSGTAB.
    MSGTAB-MSORT = '2'.
    MSGTAB-MSGID = 'F4'.
    MSGTAB-MSGTY = 'E'.
    MSGTAB-MSGNO = '163'.
    MSGTAB-MSGV1 = ICDPOS-VKORG.
    MSGTAB-MSGV2 = ICDPOS-VTWEG.
    MSGTAB-MSGV3 = ICDPOS-SPART.
    CALL FUNCTION 'FI__COLLECT'
      EXPORTING
        I_FIMSG = MSGTAB.
  ENDIF.
ENDFORM.                    "AUTHORITY_F_KNA1_VKO

*---------------------------------------------------------------------*
*      FORM  BEZEICHNUNG_ERMITTELN                                    *
*---------------------------------------------------------------------*
*      BEZEICHNUNG ZUM DEBITOR AUSGEBEN                               *
*---------------------------------------------------------------------*
FORM BEZEICHNUNG_ERMITTELN USING E_DSCRP TYPE C.

*------ RÜCKGABEPARAMETER INITIALISIEREN -------------------------------
  CLEAR E_DSCRP.

*------ BESCHREIBUNG NUR ZUSAMMEN MIT DEBITORENNUMMER AUSGEBEN ---------
  CHECK NOT ICDPOS-KUNNR IS INITIAL.

*------ BESCHREIBUNG IN INTERNER TABELLE DSCTAB NACHLESEN --------------
  IF DSCTAB-KUNNR <> ICDPOS-KUNNR.
    READ TABLE DSCTAB WITH KEY KUNNR = ICDPOS-KUNNR.

*------ BESCHREIBUNG IN DB-TABELLE KNA1 NACHLESEN UND IN DSCTAB MERKEN -
    IF SY-SUBRC <> 0.
      DSCTAB-KUNNR = ICDPOS-KUNNR.
      SELECT SINGLE * FROM KNA1 WHERE KUNNR = ICDPOS-KUNNR.
      IF SY-SUBRC = 0.
        IF  NOT KNA1-NAME1 IS INITIAL
        AND NOT KNA1-ORT01 IS INITIAL.
          CONCATENATE KNA1-NAME1 KNA1-ORT01 INTO DSCTAB-DSCRP
                                            SEPARATED BY '/'.
        ELSE.
          CONCATENATE KNA1-NAME1 KNA1-ORT01 INTO DSCTAB-DSCRP.
        ENDIF.
      ELSE.
        CLEAR DSCTAB-DSCRP.
      ENDIF.
      APPEND DSCTAB.
    ENDIF.
  ENDIF.

*------ BESCHREIBUNG ZURÜCKGEBEN ---------------------------------------
  E_DSCRP = DSCTAB-DSCRP.
ENDFORM.                    "BEZEICHNUNG_ERMITTELN

*---------------------------------------------------------------------*
* FORM  EXCTAB_FUELLEN                                                *
*---------------------------------------------------------------------*
* FÜLLEN DER TABELLEN MIT DEN BUCHUNGSKREISEN BZW. DEN EINKAUFSORGA-  *
* NISATIONEN, FÜR DIE DER BENUTZER KEINE BERECHTIGUNG HAT             *
*---------------------------------------------------------------------*
FORM EXCTAB_FUELLEN.

*------ EXCTAB FÜR BUCHUNGSKREISE AUFBAUEN -----------------------------
  IF XBUK = 'X'.
    CLEAR   EXCTAB_F_KNA1_BUK.
    REFRESH EXCTAB_F_KNA1_BUK.
    SELECT * FROM T001 WHERE BUKRS IN BUKRS.
      AUTHORITY-CHECK OBJECT 'F_KNA1_BUK'
                      ID     'ACTVT' FIELD ACTVT
                      ID     'BUKRS' FIELD T001-BUKRS.
      IF SY-SUBRC <> 0.
        EXCTAB_F_KNA1_BUK-BUKRS = T001-BUKRS.
        APPEND EXCTAB_F_KNA1_BUK.
      ENDIF.
    ENDSELECT.
  ENDIF.

*------ EXCTAB FÜR VERTRIEBSORGANISATIONEN AUFBAUEN --------------------
  IF XVKO = 'X'.
    CLEAR   EXCTAB_V_KNA1_VKO.
    REFRESH EXCTAB_V_KNA1_VKO.
    SELECT * FROM TVTA WHERE VKORG IN VKORG
                         AND VTWEG IN VTWEG
                         AND SPART IN SPART.
      AUTHORITY-CHECK OBJECT 'V_KNA1_VKO'
                      ID 'VKORG' FIELD TVTA-VKORG
                      ID 'VTWEG' FIELD TVTA-VTWEG
                      ID 'SPART' FIELD TVTA-SPART
                      ID 'ACTVT' FIELD ACTVT.
      IF SY-SUBRC <> 0.
        EXCTAB_V_KNA1_VKO-VKORG = TVTA-VKORG.
        EXCTAB_V_KNA1_VKO-VTWEG = TVTA-VTWEG.
        EXCTAB_V_KNA1_VKO-SPART = TVTA-SPART.
        APPEND EXCTAB_V_KNA1_VKO.
      ENDIF.
    ENDSELECT.
  ENDIF.
ENDFORM.                    "EXCTAB_FUELLEN

*---------------------------------------------------------------------*
* FORM  FELDATTRIBUTE_LESEN                                           *
*---------------------------------------------------------------------*
* SCHLÜSSELWORTE DER FELDER LESEN                                     *
*---------------------------------------------------------------------*
FORM FELDATTRIBUTE_LESEN.
  CLEAR   FLDATTRTAB.
  REFRESH FLDATTRTAB.
  IF XALG = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNA1'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADRC'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADRP'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADCP'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR2'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR3'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR4'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR5'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR6'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR7'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR8'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR10'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR11'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR12'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR13'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNAS'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNAT'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNBK'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVA'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVK'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVI'.                "1801151
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVL'.                "1801151
  ENDIF.
  IF XBUK = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNB1'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNB5'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNBW'.
  ENDIF.
  IF XALG = 'X'
  OR XBUK = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNZA'.
  ENDIF.
  IF XVKO = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVV'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVD'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVP'.
  ENDIF.
  PERFORM FELDATTRIBUTE_TABELLE USING 'TIBAN'.           "NOTE 1551976
ENDFORM.                    "FELDATTRIBUTE_LESEN

*---------------------------------------------------------------------*
* FORM POSITIONEN_IN_EXTRACT                                          *
*---------------------------------------------------------------------*
* DIE POSITIONEN ZU EINEM ÄNDERUNGSBELEGKOPF WERDEN IN DEN EXTRACT    *
* GESTELLT                                                            *
*---------------------------------------------------------------------*
FORM POSITIONEN_IN_EXTRACT.
  STATICS: WA_T100S LIKE T100S,
           L_PROCESS_ADRU TYPE C.

*------ LOKALE DATENDEKLARATIONEN --------------------------------------
  DATA: LV_XRELE LIKE BOOLE-BOOLE.
  DATA: LS_KNB1 TYPE KNB1,  "1973032
        LS_KNVV TYPE KNVV.  "1973032
  DATA: LS_KNA1 TYPE KNA1.  "DPP

  CLEAR OLD.

*------ SCHLEIFE ÜBER DIE ÄNDERUNGSBELEGPOSITIONEN ---------------------
  LOOP AT ICDPOS.

*------ INITIALISIEREN DER SCHLÜSSELFELDER -----------------------------
    CLEAR: ICDPOS-BUKRS,
           ICDPOS-SPART,
           ICDPOS-VKORG,
           ICDPOS-VTWEG.

*------ KUNDENNUMMER IN ICDPOS SCHREIBEN -------------------------------
    CASE OBJEKT.
      WHEN 'DEBI'.
        ICDPOS-KUNNR = ICDHDR-OBJECTID.
      WHEN 'ADRESSE'.
        READ TABLE GT_KUNADR WITH KEY ADRNR = ICDHDR-OBJECTID+4(10).
        IF SY-SUBRC = 0.
          ICDPOS-KUNNR = GT_KUNADR-KUNNR.
        ELSE.
          ICDPOS-KUNNR = '...'.
        ENDIF.
    ENDCASE.

*------ 1) UNNÖTIGE POSITIONEN WEGWERFEN: SELEKTIERTE DATENBEREICHE ----
*------    (ANKREUZFELDER FÜR ALLG., BUKRS. UNHD EINKAUFSDATEN)     ----
*------ 2) FELDER AUS ICDPOS FÜLLEN MIT INHALT VON ICDPOS-TABKEY    ----
    CASE ICDPOS-TABNAME.
      WHEN 'KNA1'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
        PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.                "914560
        CHECK LV_XRELE = 'X'.                                    "914560
      WHEN 'KNAS'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
        PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.                "914560
        CHECK LV_XRELE = 'X'.                                    "914560
      WHEN 'KNAT'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
        PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.                "914560
        CHECK LV_XRELE = 'X'.                                    "914560
      WHEN 'KNB1'.
        CHECK XBUK = 'X'.
        ICDPOS-BUKRS = ICDPOS-TABKEY+13(4).
      WHEN 'KNB5'.
        CHECK XBUK = 'X'.
        ICDPOS-BUKRS = ICDPOS-TABKEY+13(4).
      WHEN 'KNBK'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
        PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.                "914560
        CHECK LV_XRELE = 'X'.                                    "914560
      WHEN 'KNBW'.
        CHECK XBUK = 'X'.
        ICDPOS-BUKRS = ICDPOS-TABKEY+13(4).
      WHEN 'KNVA'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
        PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.                "914560
        CHECK LV_XRELE = 'X'.                                    "914560
      WHEN 'KNVD'.
        CHECK XVKO = 'X'.
        ICDPOS-VKORG = ICDPOS-TABKEY+13(4).
        ICDPOS-VTWEG = ICDPOS-TABKEY+17(2).
        ICDPOS-SPART = ICDPOS-TABKEY+19(2).
      WHEN 'KNVI'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
      WHEN 'KNEX'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
        PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.                "914560
        CHECK LV_XRELE = 'X'.                                    "914560
      WHEN 'KNVK'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
        PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.                "914560
        CHECK LV_XRELE = 'X'.                                    "914560
      WHEN 'KNVL'.
        CHECK XALG = 'X'.
        PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                            CHANGING LV_XRELE.
        CHECK LV_XRELE = 'X'.
      WHEN 'KNVP'.
        CHECK XVKO = 'X'.
        ICDPOS-VKORG = ICDPOS-TABKEY+13(4).
        ICDPOS-VTWEG = ICDPOS-TABKEY+17(2).
        ICDPOS-SPART = ICDPOS-TABKEY+19(2).
      WHEN 'KNVV'.
        CHECK XVKO = 'X'.
        ICDPOS-VKORG = ICDPOS-TABKEY+13(4).
        ICDPOS-VTWEG = ICDPOS-TABKEY+17(2).
        ICDPOS-SPART = ICDPOS-TABKEY+19(2).
      WHEN 'KNZA'.
        ICDPOS-BUKRS = ICDPOS-TABKEY+13(4).
        IF ICDPOS-BUKRS IS INITIAL.
          CHECK XALG = 'X'.
          PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                              CHANGING LV_XRELE.
          CHECK LV_XRELE = 'X'.
          PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.              "914560
          CHECK LV_XRELE = 'X'.                                  "914560
        ELSE.
          CHECK XBUK = 'X'.
        ENDIF.
      WHEN OTHERS.
        CHECK NOT ( ICDPOS-TABNAME = 'ADRT'
                 OR ICDPOS-TABNAME = 'ADRCT' ).
        IF ICDPOS-TABNAME CP 'AD*'.
          CHECK XALG = 'X'.
          PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                              CHANGING LV_XRELE.
          IF ICDPOS-TABNAME = 'ADRU'.
            IF L_PROCESS_ADRU IS INITIAL.
              CLEAR WA_T100S.
              SELECT SINGLE * FROM T100S INTO WA_T100S
                              WHERE ARBGB = 'F2' AND MSGNR = '780'.
              L_PROCESS_ADRU = 'X'.
              IF 1 = 2. MESSAGE E780(F2). ENDIF.           "#EC BOOL_OK
            ENDIF.
*           IF MESSAGE F2780 IS NOT EXISTING OR ACTIVATED, ADRU IS
*           FILTERED OTHERWISE, ADRU IF SHOWN IN THE CHANGE DOCUMENTS
*           TRANSACTION FOR CUSTOMER AND VENDORS
            CHECK NOT WA_T100S-XIGNO IS INITIAL.
          ENDIF.
          CHECK LV_XRELE = 'X'.
          PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.              "914560
          CHECK LV_XRELE = 'X'.                                  "914560
        ENDIF.
        IF ICDPOS-TABNAME = 'TIBAN'.                           "1689441
          CHECK XALG = 'X'.
          PERFORM KUNNR_CHECK USING    ICDPOS-KUNNR
                              CHANGING LV_XRELE.
          CHECK LV_XRELE = 'X'.
          PERFORM AUTH_GEN_CHECK CHANGING LV_XRELE.
          CHECK LV_XRELE = 'X'.
        ENDIF.                                                 "1689441
    ENDCASE.

*------ UNNÖTIGE POSITIONEN WEGWERFEN: SELEKT. INTERVALLE FÜR ----------
*------   BUKRS, VKORG, VTWEG UND SPART PRÜFEN                ----------
    IF NOT ICDPOS-BUKRS IS INITIAL.
      CHECK ICDPOS-BUKRS IN BUKRS.
*NOTE 1973032:  MAKE SURE THAT BEGRU IS CHECKED FOR KNB1
      CALL FUNCTION 'KNB1_READ_SINGLE'
        EXPORTING
          ID_KUNNR                  = ICDPOS-KUNNR
          ID_BUKRS                  = ICDPOS-BUKRS
          ID_CVP_BEHAVIOR            = '3'
        IMPORTING
          ES_KNB1                   = LS_KNB1
        EXCEPTIONS
          NOT_FOUND                 = 1
          INPUT_NOT_SPECIFIED       = 2
          KUNNR_BLOCKED             = 3
          OTHERS                    = 4
                .
      IF SY-SUBRC = 0 AND NOT ( LS_KNB1-BEGRU IS INITIAL ).
         AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                  ID 'BRGRU' FIELD LS_KNB1-BEGRU
                  ID 'ACTVT' FIELD '08'.
         CHECK SY-SUBRC = 0.
      ENDIF.
* END OF NOTE 1973032

    ENDIF.
    IF NOT ICDPOS-VKORG IS INITIAL.
      CHECK ICDPOS-VKORG IN VKORG.
    ENDIF.
    IF NOT ICDPOS-VTWEG IS INITIAL.
      CHECK ICDPOS-VTWEG IN VTWEG.
    ENDIF.
    IF NOT ICDPOS-SPART IS INITIAL.
      CHECK ICDPOS-SPART IN SPART.
    ENDIF.

* NOTE 1973032: CHECK BEGRU ON KNVV LEVEL
    IF NOT ICDPOS-VKORG IS INITIAL AND
       NOT ICDPOS-VTWEG IS INITIAL AND
       NOT ICDPOS-SPART IS INITIAL.
      CALL FUNCTION 'KNVV_SINGLE_READ'
        EXPORTING
          I_KUNNR                  = ICDPOS-KUNNR
          I_VKORG                  = ICDPOS-VKORG
          I_VTWEG                  = ICDPOS-VTWEG
          I_SPART                  = ICDPOS-SPART
          I_CVP_BEHAVIOR           = '3'
        IMPORTING
          O_KNVV                   = LS_KNVV
        EXCEPTIONS
          NOT_FOUND                = 1
          PARAMETER_ERROR          = 2
          KUNNR_BLOCKED            = 3
          OTHERS                   = 4
                .
      IF SY-SUBRC = 0 AND NOT LS_KNVV-BEGRU IS INITIAL.
        AUTHORITY-CHECK OBJECT 'V_KNA1_BRG'
                 ID 'BRGRU' FIELD LS_KNVV-BEGRU
                 ID 'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
        IF CL_VS_SWITCH_CHECK=>CMD_VMD_CVP_ILM_SFW_01( ) IS NOT INITIAL.
          CALL FUNCTION 'KNA1_READ_SINGLE'
            EXPORTING
              ID_KUNNR                  = ICDPOS-KUNNR
              ID_CVP_BEHAVIOR           = '3'
            IMPORTING
              ES_KNA1                   = LS_KNA1
            EXCEPTIONS
              NOT_FOUND                 = 1
              INPUT_NOT_SPECIFIED       = 2
              KUNNR_BLOCKED             = 3
              OTHERS                    = 4
                .
          IF LS_KNA1-CVP_XBLCK = 'X'.
            AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                     ID 'BRGRU' FIELD LS_KNA1-BEGRU
                     ID 'ACTVT' FIELD '08'.
            CHECK SY-SUBRC = 0.
          ENDIF.
        ENDIF.
      ENDIF.
* END OF NOTE 1973032
    ENDIF.
*------ UNNÖTIGE POSITIONEN WEGWERFEN: FELDGRUPPEN ---------------------
    PERFORM FLDTAB_PRUEFEN USING SUBRC.
    CHECK SUBRC = 0.

*------ UNNÖTIGE POSITIONEN WEGWERFEN: BERECHTIGUNG F_KNA1_BUK ---------
    PERFORM AUTHORITY_F_KNA1_BUK USING SUBRC.
    CHECK SUBRC = 0.

*------ UNNÖTIGE POSITIONEN WEGWERFEN: BERECHTIGUNG F_KNA1_VKO ---------
    PERFORM AUTHORITY_F_KNA1_VKO USING SUBRC.
    CHECK SUBRC = 0.

*------ BEHANDLUNG VON EINFÜGUNGEN UND LÖSCHUNGEN ----------------------
    IF ICDPOS-CHNGIND <> 'U'.
      PERFORM KUENSTLICHER_EXTRAKT USING SUBRC.
      CHECK SUBRC = 0.
    ENDIF.

*------ FELDTEXT UND FELDTYP ZUR POSITION ERMITTELN --------------------
    PERFORM FLDATTR_ERMITTELN.

*------ TECHNISCHEN FELDNAMEN ERMITTELN --------------------------------
    PERFORM TABFELD_ERMITTELN.

*------ XSELE SETZEN: ZUMINDEST EINE POSITION SELEKTIERT ---------------
    XSELE = 'X'.

*------ POSITION IN EXTRACT SCHREIBEN ----------------------------------
    EXTRACT DATEN.

  ENDLOOP.
ENDFORM.                    "POSITIONEN_IN_EXTRACT

*---------------------------------------------------------------------*
*      FORM  KUNNR_CHECK                                              *
*---------------------------------------------------------------------*
*      KENNZEICHEN 'ALLG. DATEN ALLER DEBITOREN' NICHT MARKIERT:      *
*        ÄNDERUNGSBELEGPOSITIONEN ZU ALLGEMEINEN DATEN PRÜFEN         *
*---------------------------------------------------------------------*
*      --> I_KUNNR    DEBITORENNUMMER                                 *
*      <-- E_XRELE    KENNZEICHEN: DEBITOR RELEVANT                   *
*---------------------------------------------------------------------*
FORM KUNNR_CHECK USING    I_KUNNR LIKE ICDPOS-KUNNR
                 CHANGING E_XRELE LIKE BOOLE-BOOLE.

*------ LOKALE DATENDEKLARATIONEN --------------------------------------
  DATA: LV_XRELE_BUKRS LIKE BOOLE-BOOLE,
        LV_XRELE_VKORG LIKE BOOLE-BOOLE,
        LV_XRELE_ALG   LIKE BOOLE-BOOLE.

* NOT USED. PERMIT TO CHANGE THE BEHAVIOUR OF THE FILTER. BY DEFAULT, AN OR
* ACCROSS COMPANY CODE AND SALAES AREA DATA IS RUNNING. SO THE GENERAL DATA ARE RETURNED
* IF COMPANY CODE DATA OR SALES AREA DATA DO EXISTS
* SETTING THIS VARIABLE TO 'X', CHANGE THE OR TO AN AND.
  DATA: SEL_BUKRS_AND_VKORG TYPE XFELD.
*------ RÜCKGABEPARAMETER INITIALISIEREN -------------------------------
  CLEAR E_XRELE.

*------ KENNZ. 'ALLG. DATEN ALLER DEBITOREN' MARKIERT: -----------------
*------   DEBITOR IST RELEVANT -----------------------------------------
  IF XALL = 'X' OR ( XBUK IS INITIAL AND XVKO IS INITIAL ).
    E_XRELE = 'X'.
    EXIT.
  ENDIF.

*------ KENNZ. 'ALLG. DATEN ALLER DEBITOREN' NICHT MARKIERT ------------
*------ ... DEBITOR IN INTERNER TABELLE SUCHEN -------------------------
  READ TABLE KUNNRTAB WITH KEY KUNNR = I_KUNNR.
  IF SY-SUBRC = 0.
    CASE SEL_BUKRS_AND_VKORG.
      WHEN 'X'. " BOTH THE COMPANY CODE AND THE SALES AREA MUST BE FULFILL
        IF KUNNRTAB-XRELE_ALG = 'X' AND
           ( KUNNRTAB-XRELE_BUKRS = 'X' AND
             KUNNRTAB-XRELE_VKORG = 'X' ).
           E_XRELE = 'X'.
        ENDIF.
      WHEN OTHERS. " DEFAULT THE OR FILTER. TRUE IF THE COMPANY CODE OR THE SALES
                 " AREA ARE FULFILL.
        IF KUNNRTAB-XRELE_ALG = 'X' AND
           ( KUNNRTAB-XRELE_BUKRS = 'X' OR
             KUNNRTAB-XRELE_VKORG = 'X' ).
           E_XRELE = 'X'.
        ENDIF.
    ENDCASE.
*------ ... DEBITOR AUFGRUND TABELLEN KNB1 UND KNVV PRÜFEN--------------
*------ ...... KENNZEICHEN 'RELEVANT' MARKIEREN ------------------------
  ELSE.
    SELECT SINGLE * FROM KNA1 WHERE KUNNR = I_KUNNR.
    IF SY-SUBRC = 0.
      LV_XRELE_ALG   = 'X'.
      LV_XRELE_BUKRS = 'X'.
      LV_XRELE_VKORG = 'X'.
    ENDIF.
*------ ...... DEBITOR IN KNB1 NICHT GEFUNDEN: NICHT RELEVANT ----------
    IF XBUK = 'X'.
      IF BUKRS[] IS INITIAL.
        SELECT * FROM KNB1 WHERE KUNNR = I_KUNNR.
          EXIT.
        ENDSELECT.
      ELSE.
        SELECT * FROM KNB1 WHERE KUNNR =  I_KUNNR
                             AND BUKRS IN BUKRS.
          EXIT.
        ENDSELECT.
      ENDIF.
      IF SY-SUBRC <> 0.
        CLEAR LV_XRELE_BUKRS.
      ENDIF.
    ELSE.
      CLEAR LV_XRELE_BUKRS.
    ENDIF.

*------ ...... DEBITOR IN KNVV NICHT GEFUNDEN: NICHT RELEVANT ----------
*------ ......... VERKAUFSORGANISATION PRÜFEN --------------------------
    IF XVKO     = 'X'.
      IF VKORG[] IS INITIAL.
          SELECT * FROM KNVV WHERE KUNNR = I_KUNNR.
            EXIT.
          ENDSELECT.
        ELSE.
          SELECT * FROM KNVV WHERE KUNNR =  I_KUNNR
                               AND VKORG IN VKORG.
            EXIT.
          ENDSELECT.
        ENDIF.
        IF SY-SUBRC <> 0.
        CLEAR LV_XRELE_VKORG.
      ENDIF.

*------ ......... VERTRIEBSWEG PRÜFEN ----------------------------------
      IF LV_XRELE_VKORG = 'X'.
        IF VTWEG[] IS INITIAL.
          SELECT * FROM KNVV WHERE KUNNR = I_KUNNR.
            EXIT.
          ENDSELECT.
        ELSE.
          SELECT * FROM KNVV WHERE KUNNR =  I_KUNNR
                               AND VTWEG IN VTWEG.
            EXIT.
          ENDSELECT.
        ENDIF.
        IF SY-SUBRC <> 0.
          CLEAR LV_XRELE_VKORG.
        ENDIF.
      ENDIF.

*------ ......... SPARTE PRÜFEN ----------------------------------------
      IF LV_XRELE_VKORG = 'X'.
        IF SPART[] IS INITIAL.
          SELECT * FROM KNVV WHERE KUNNR = I_KUNNR.
            EXIT.
          ENDSELECT.
        ELSE.
          SELECT * FROM KNVV WHERE KUNNR =  I_KUNNR
                               AND SPART IN SPART.
            EXIT.
          ENDSELECT.
        ENDIF.
        IF SY-SUBRC <> 0.
          CLEAR LV_XRELE_VKORG.
        ENDIF.
      ENDIF.
    ELSE.
      CLEAR LV_XRELE_VKORG.
    ENDIF.

*------ ...... DEBITOR MIT SUCHERGEBNIS IN INTERNE TABELLE EINTRAGEN ---
    CLEAR KUNNRTAB.
    KUNNRTAB-KUNNR = I_KUNNR.
    KUNNRTAB-XRELE_ALG = LV_XRELE_ALG.
    KUNNRTAB-XRELE_BUKRS = LV_XRELE_BUKRS.
    KUNNRTAB-XRELE_VKORG = LV_XRELE_VKORG.
    APPEND KUNNRTAB.

*------ ...... KENNZEICHEN 'RELEVANT' ZURÜCKGEBEN ----------------------
    CASE SEL_BUKRS_AND_VKORG.
      WHEN 'X'. " BOTH THE COMPANY CODE AND THE SALES AREA MUST BE FULFILL
        IF KUNNRTAB-XRELE_ALG = 'X' AND
           ( KUNNRTAB-XRELE_BUKRS = 'X' AND
             KUNNRTAB-XRELE_VKORG = 'X' ).
           E_XRELE = 'X'.
        ENDIF.
      WHEN OTHERS. " DEFAULT THE OR FILTER. TRUE IF THE COMPANY CODE OR THE SALES
                 " AREA ARE FULFILL.
        IF KUNNRTAB-XRELE_ALG = 'X' AND
           ( KUNNRTAB-XRELE_BUKRS = 'X' OR
             KUNNRTAB-XRELE_VKORG = 'X' ).
           E_XRELE = 'X'.
        ENDIF.
    ENDCASE.
  ENDIF.
ENDFORM.                    "KUNNR_CHECK

*&---------------------------------------------------------------------*
*&      FORM  VARIANT_INIT
*&---------------------------------------------------------------------*
*       INITIALISE THE VARIANT
*----------------------------------------------------------------------*
FORM VARIANT_INIT CHANGING XS_VARIANT TYPE DISVARIANT.     "#EC CALLED

  DATA: LV_SAVE(1) TYPE C VALUE 'X',
        LV_REPID   LIKE SY-REPID.

  MOVE SY-REPID TO LV_REPID.
  XS_VARIANT-REPORT = LV_REPID.

* TO GET THE DEFAULT VARIANT.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'            "#EC *
    EXPORTING
      I_SAVE        = LV_SAVE
    CHANGING
      CS_VARIANT    = XS_VARIANT
    EXCEPTIONS
      WRONG_INPUT   = 1
      NOT_FOUND     = 2
      PROGRAM_ERROR = 3
      OTHERS        = 4.

  P_VARIA = XS_VARIANT-VARIANT.

ENDFORM.                    " VARIANT_INIT

*&---------------------------------------------------------------------*
*&      FORM  CHECK_VARIANT
*&---------------------------------------------------------------------*
*       SUBROUTINE TO CHECK IF THE ENTERED VARIANT EXISTS
*----------------------------------------------------------------------*
FORM CHECK_VARIANT CHANGING XS_VARIANT TYPE DISVARIANT.

  DATA: LV_SAVE TYPE C VALUE 'X'.

  PERFORM CHECK_AUTHORITY_LAYOUT USING LV_SAVE.                  "987855

  IF NOT P_VARIA IS INITIAL.
    MOVE P_VARIA TO XS_VARIANT-VARIANT.

* TO CHECK FOR THE EXISTENCE OF VARIANT.
    CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
      EXPORTING
        I_SAVE        = LV_SAVE
      CHANGING
        CS_VARIANT    = XS_VARIANT
      EXCEPTIONS
        WRONG_INPUT   = 1
        NOT_FOUND     = 2
        PROGRAM_ERROR = 3
        OTHERS        = 4.

    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
ENDFORM.                    " CHECK_VARIANT

*&---------------------------------------------------------------------*
*&      FORM  F4_HELP_FOR_VARIANT
*&---------------------------------------------------------------------*
*       SUBROUTINE TO  PROVIDE THE F4 HELP FOR THE VARIANT PARAMETER
*----------------------------------------------------------------------
FORM F4_HELP_FOR_VARIANT USING VALUE(IS_VARIANT) TYPE DISVARIANT.

  DATA: LV_SAVE    TYPE C VALUE 'X',
        LS_VARIANT TYPE DISVARIANT,
        LV_EXIT    TYPE C.

  PERFORM CHECK_AUTHORITY_LAYOUT USING LV_SAVE.                  "987855

* TO GET THE F4 HELP.
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      IS_VARIANT    = IS_VARIANT
      I_SAVE        = LV_SAVE
    IMPORTING
      E_EXIT        = LV_EXIT
      ES_VARIANT    = LS_VARIANT
    EXCEPTIONS
      NOT_FOUND     = 1
      PROGRAM_ERROR = 2
      OTHERS        = 3.

  IF SY-SUBRC = 1.
    MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    IF LV_EXIT = SPACE.
      P_VARIA = LS_VARIANT-VARIANT.
    ENDIF.
  ENDIF.

ENDFORM.                    " F4_HELP_FOR_VARIANT

*&---------------------------------------------------------------------*
*&      FORM  OUTPUT_LIST_ALV
*&---------------------------------------------------------------------*
*       OUTPUT THE LIST
*----------------------------------------------------------------------*
FORM OUTPUT_LIST_ALV.

  DATA: LT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
        LS_LAYOUT   TYPE SLIS_LAYOUT_ALV,
        LT_EVENTTAB TYPE SLIS_T_EVENT,
        LT_SORTTAB  TYPE SLIS_T_SORTINFO_ALV,
        LV_SAVE     TYPE C VALUE 'A'.
  DATA: LS_PRINT    TYPE SLIS_PRINT_ALV.                       "1344831

  PERFORM LAYOUT_BUILD   CHANGING LS_LAYOUT.
  PERFORM FIELDCAT_BUILD CHANGING LT_FIELDCAT.
  PERFORM EVENTTAB_BUILD CHANGING LT_EVENTTAB.
  PERFORM SORTTAB_BUILD  CHANGING LT_SORTTAB.
  PERFORM CHECK_AUTHORITY_LAYOUT USING LV_SAVE.                  "987855
  LS_PRINT-NO_PRINT_SELINFOS = 'X'.                            "1344831
**************************************************************************************
*TO DISPLAY THE LIST
  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM       = G_REPID
      I_CALLBACK_PF_STATUS_SET = GC_PF_STATUS_SET
*      I_CALLBACK_PF_STATUS_SET = GC_PF_STATUS
      IT_FIELDCAT              = LT_FIELDCAT
      IT_EVENTS                = LT_EVENTTAB
      IS_LAYOUT                = LS_LAYOUT
      IT_SORT                  = LT_SORTTAB
      I_SAVE                   = LV_SAVE
      IS_VARIANT               = GS_VARIANT
      IS_PRINT                 = LS_PRINT                      "1344831
    IMPORTING
      ES_EXIT_CAUSED_BY_USER   = GS_EXIT_CAUSED_BY_USER
    TABLES
      T_OUTTAB                 = GT_OUTTAB
    EXCEPTIONS
      PROGRAM_ERROR            = 1
      OTHERS                   = 2.
***********************************************************************************

*CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'     " add by supriya on 26.07.2024
* EXPORTING
**   I_INTERFACE_CHECK                 = ' '
**   I_BYPASSING_BUFFER                = ' '
**   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = G_REPID
*   I_CALLBACK_PF_STATUS_SET          = GC_PF_STATUS_SET
**   I_CALLBACK_USER_COMMAND           = ' '
**   I_CALLBACK_TOP_OF_PAGE            = ' '
**   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**   I_CALLBACK_HTML_END_OF_LIST       = ' '
**   I_STRUCTURE_NAME                  =
**   I_BACKGROUND_ID                   = ' '
**   I_GRID_TITLE                      =
**   I_GRID_SETTINGS                   =
*   IS_LAYOUT                          = LS_LAYOUT
*   IT_FIELDCAT                        = LT_FIELDCAT
**   IT_EXCLUDING                      =
**   IT_SPECIAL_GROUPS                 =
*   IT_SORT                            = LT_SORTTAB
**   IT_FILTER                         =
**   IS_SEL_HIDE                       =
**   I_DEFAULT                         = 'X'
*   I_SAVE                             = LV_SAVE
*   IS_VARIANT                         = GS_VARIANT
*   IT_EVENTS                          = LT_EVENTTAB
**   IT_EVENT_EXIT                     =
*   IS_PRINT                           = LS_PRINT
**   IS_REPREP_ID                      =
**   I_SCREEN_START_COLUMN             = 0
**   I_SCREEN_START_LINE               = 0
**   I_SCREEN_END_COLUMN               = 0
**   I_SCREEN_END_LINE                 = 0
**   I_HTML_HEIGHT_TOP                 = 0
**   I_HTML_HEIGHT_END                 = 0
**   IT_ALV_GRAPHICS                   =
**   IT_HYPERLINK                      =
**   IT_ADD_FIELDCAT                   =
**   IT_EXCEPT_QINFO                   =
**   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
**   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER             = GS_EXIT_CAUSED_BY_USER
*  TABLES
*    T_OUTTAB                          = GT_OUTTAB
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
*          .
***IF SY-SUBRC <> 0.
**** Implement suitable error handling here
***ENDIF.

*************************************************************************************

  IF SY-SUBRC = 0.
* USER LEAVES THE OUTPUT LIST VIA F3, F12 OR F15
    IF GS_EXIT_CAUSED_BY_USER-BACK = GC_SET         "F3
       OR GS_EXIT_CAUSED_BY_USER-EXIT   = GC_SET    "F15
       OR GS_EXIT_CAUSED_BY_USER-CANCEL = GC_SET.   "F12
      SET SCREEN 0.
    ENDIF.
  ELSE.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

 IF P_DOWN = 'X'.
*
    PERFORM DOWNLOAD.
*
  ENDIF.

ENDFORM.                    " OUTPUT_LIST_ALV

*&---------------------------------------------------------------------*
*&      FORM  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       TO BUILD THE LAYOUT FOR MULTIPLE LIST
*----------------------------------------------------------------------*
FORM LAYOUT_BUILD  CHANGING XS_LAYOUT TYPE SLIS_LAYOUT_ALV.

  CLEAR XS_LAYOUT.
  XS_LAYOUT-ZEBRA        = 'X'.
  XS_LAYOUT-NO_VLINE     = 'X'.
  XS_LAYOUT-ALLOW_SWITCH_TO_LIST = GC_VALUE_X.
  XS_LAYOUT-GROUP_CHANGE_EDIT = 'X'.                             "953910
  XS_LAYOUT-GET_SELINFOS = 'X'.                                  "1133830

ENDFORM.                    " LAYOUT_BUILD

*&---------------------------------------------------------------------*
*&      FORM  FIELDCAT_BUILD
*&---------------------------------------------------------------------*
*       BUILDS FIELD CATALOGUE
*----------------------------------------------------------------------*
FORM FIELDCAT_BUILD  CHANGING XT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

  CONSTANTS: LC_STRNAME_LIST LIKE DD02D-STRNAME
                               VALUE 'FOAP_ACC_S_RFDABL00_LIST'.

  DATA: LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  PERFORM FIELDCAT_MERGE USING LC_STRNAME_LIST CHANGING XT_FIELDCAT.

  LOOP AT XT_FIELDCAT INTO LS_FIELDCAT.
    CLEAR LS_FIELDCAT-TECH.
    CLEAR LS_FIELDCAT-NO_OUT.

    CASE LS_FIELDCAT-FIELDNAME.
      WHEN 'UDATE'.
        LS_FIELDCAT-COL_POS = 1.
      WHEN 'UTIME'.
        LS_FIELDCAT-COL_POS = 2.
      WHEN 'KUNNR'.
        LS_FIELDCAT-COL_POS = 3.
      WHEN 'USERNAME'.
        LS_FIELDCAT-COL_POS = 4.
      WHEN 'FNAME'.
        LS_FIELDCAT-COL_POS = 5.
      WHEN 'BUKRS'.
        LS_FIELDCAT-COL_POS = 6.
      WHEN 'VKORG'.
        LS_FIELDCAT-COL_POS = 7.
      WHEN 'VTWEG'.
        LS_FIELDCAT-COL_POS = 8.
      WHEN 'SPART'.
        LS_FIELDCAT-COL_POS = 9.
      WHEN 'F_NEW'.
        LS_FIELDCAT-COL_POS = 10.
      WHEN 'F_OLD'.
        LS_FIELDCAT-COL_POS = 11.
      WHEN 'DSCRP'.
        LS_FIELDCAT-COL_POS = 12.
*        LS_FIELDCAT-NO_OUT  = GC_SET.     commented on 25.07.2025
      WHEN 'TABFELD'.
        LS_FIELDCAT-COL_POS = 13.
        LS_FIELDCAT-NO_OUT  = GC_SET.
      WHEN 'OTHER_KEYS'.
        LS_FIELDCAT-COL_POS = 14.
        LS_FIELDCAT-NO_OUT  = GC_SET.

*    CASE LS_FIELDCAT-FIELDNAME.
*      WHEN 'UDATE'.
*        LS_FIELDCAT-COL_POS = 1.
*      WHEN 'UTIME'.
*        LS_FIELDCAT-COL_POS = 2.
*      WHEN 'KUNNR'.
*        LS_FIELDCAT-COL_POS = 3.
*      WHEN 'USERNAME'.
*         LS_FIELDCAT-COL_POS = 4.
*      WHEN 'DSCRP'.
*        LS_FIELDCAT-COL_POS = 5.
*        LS_FIELDCAT-NO_OUT  = GC_SET.
*      WHEN 'FNAME'.
*        LS_FIELDCAT-COL_POS = 6.
*      WHEN 'BUKRS'.
*        LS_FIELDCAT-COL_POS = 7.
*      WHEN 'VKORG'.
*        LS_FIELDCAT-COL_POS = 8.
*      WHEN 'VTWEG'.
*        LS_FIELDCAT-COL_POS = 9.
*      WHEN 'SPART'.
*        LS_FIELDCAT-COL_POS = 10.
*      WHEN 'F_NEW'.
*        LS_FIELDCAT-COL_POS = 11.
*      WHEN 'F_OLD'.
*        LS_FIELDCAT-COL_POS = 12.
*      WHEN 'ZUDATE'.
*        LS_FIELDCAT-COL_POS = 13.
*      WHEN 'ZUTIME'.
*        LS_FIELDCAT-COL_POS = 14.

    ENDCASE.

    MODIFY XT_FIELDCAT FROM         LS_FIELDCAT
                       INDEX        SY-TABIX
                       TRANSPORTING COL_POS
                                    NO_OUT
                                    TECH.
  ENDLOOP.

* NEEDED FOR THE FILTER FUNCTION.                              "1157572
  LS_FIELDCAT-LOWERCASE = 'X'.                                 "1157572
  MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING LOWERCASE   "1157572
                                     WHERE FIELDNAME = 'FNAME'."1157572
  CLEAR LS_FIELDCAT-LOWERCASE.                                 "1157572

* TO ADD THE FIELDS FOR F_OLD_35
  READ TABLE XT_FIELDCAT INTO LS_FIELDCAT WITH KEY FIELDNAME = 'F_OLD'.
  LS_FIELDCAT-FIELDNAME = 'F_OLD_35'.
  LS_FIELDCAT-ROW_POS   = 2.
  APPEND LS_FIELDCAT TO XT_FIELDCAT.
* TO ADD THE FIELDS FOR F_NEW_35
  READ TABLE XT_FIELDCAT INTO LS_FIELDCAT WITH KEY FIELDNAME = 'F_NEW'.
  LS_FIELDCAT-FIELDNAME = 'F_NEW_35'.
  LS_FIELDCAT-ROW_POS   = 2.
  IF GS_VARIANT-VARIANT IS INITIAL.                              "987650
    LS_FIELDCAT-OFFSET    = 94.
  ENDIF.                                                         "987650
  APPEND LS_FIELDCAT TO XT_FIELDCAT.

* TO ASSIGN THE OUTPUT LENGTH OF THE VALUE FIELDS TO 35
  LS_FIELDCAT-OUTPUTLEN = 35.
  MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING OUTPUTLEN
  WHERE FIELDNAME CP 'F_OLD*' OR FIELDNAME CP 'F_NEW*'.

* TO ASSIGN THE OUTPUT LENGTH OF DATE TO 10
  LS_FIELDCAT-OUTPUTLEN = 10.
  MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING OUTPUTLEN
  WHERE FIELDNAME = 'UDATE'.

* TO ASSIGN THE OUTPUT LENGTH OF TIME TO 8
  LS_FIELDCAT-OUTPUTLEN = 8.
  MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING OUTPUTLEN
  WHERE FIELDNAME = 'UTIME'.

* TO CHANGE THE COLUMN HEADINGS FOR 'TECH FIELD'
  LS_FIELDCAT-SELTEXT_L = TEXT-T22.
  TRANSLATE LS_FIELDCAT-SELTEXT_L USING '; '.
  MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING SELTEXT_L
  WHERE FIELDNAME = 'TABFELD'.

* TO CHANGE THE COLUMN HEADINGS FOR 'CHANGED BY'
  LS_FIELDCAT-SELTEXT_M = TEXT-S03.
  TRANSLATE LS_FIELDCAT-SELTEXT_M USING '; '.
  LS_FIELDCAT-DDICTXT   = 'M'.
  MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING SELTEXT_M DDICTXT
  WHERE FIELDNAME = 'USERNAME'.

* TO SORT THE FIELD ON DATE, CUSTOMER, CHANGED BY AND FIELD NAME
  LS_FIELDCAT-COL_POS = 0.
  CASE  SORT.
    WHEN '1'.
      MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING COL_POS KEY
      WHERE FIELDNAME = 'UDATE'.
    WHEN '2'.
      MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING COL_POS KEY
      WHERE FIELDNAME =  'KUNNR'.
    WHEN '3'.
      MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING COL_POS KEY
      WHERE FIELDNAME = 'USERNAME'.
*    WHEN '4'.                      " BY SUPRIYA ON 24.07.2024
*      MODIFY XT_FIELDCAT FROM LS_FIELDCAT TRANSPORTING COL_POS KEY
*      WHERE FIELDNAME = 'FNAME'.
  ENDCASE.

ENDFORM.                    " FIELDCAT_BUILD

*&---------------------------------------------------------------------*
*&      FORM  FIELDCAT_MERGE
*&---------------------------------------------------------------------*
*       TO MERGED FIELDS INTO TABLE XT_FIELDCAT
*----------------------------------------------------------------------*
FORM FIELDCAT_MERGE USING I_STRNAME CHANGING XT_FIELDCAT.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      I_STRUCTURE_NAME       = I_STRNAME
    CHANGING
      CT_FIELDCAT            = XT_FIELDCAT
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " FIELDCAT_MERGE

*&---------------------------------------------------------------------*
*&      FORM  EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*       BUILDS EVNT TABLE : TOP_OF_PAGE AND END_OF_LIST
*----------------------------------------------------------------------*
FORM EVENTTAB_BUILD CHANGING XT_EVENTTAB TYPE SLIS_T_EVENT.

  DATA: LS_EVENTS TYPE SLIS_ALV_EVENT.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE     = 0
    IMPORTING
      ET_EVENTS       = XT_EVENTTAB
    EXCEPTIONS
      LIST_TYPE_WRONG = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

* TO PASS TOP_OF_PAGE EVENT TO BE TRIGGERED
  READ TABLE XT_EVENTTAB INTO LS_EVENTS WITH KEY NAME =
            SLIS_EV_TOP_OF_PAGE.
  IF SY-SUBRC = 0.
    LS_EVENTS-FORM = GC_TOPOFPAGE.
    MODIFY XT_EVENTTAB FROM LS_EVENTS TRANSPORTING FORM
           WHERE NAME = SLIS_EV_TOP_OF_PAGE.
  ENDIF.

* TO PASS END_OF_LIST EVENT TO  BE TRIGGERED
  READ TABLE XT_EVENTTAB INTO LS_EVENTS WITH KEY NAME =
            SLIS_EV_END_OF_LIST.
  IF SY-SUBRC = 0.
    LS_EVENTS-FORM = GC_ENDOFLIST.
    MODIFY XT_EVENTTAB FROM LS_EVENTS TRANSPORTING FORM
           WHERE NAME = SLIS_EV_END_OF_LIST.
  ENDIF.
* PF_STATUS_SET
  READ TABLE XT_EVENTTAB INTO LS_EVENTS WITH KEY NAME =
            SLIS_EV_PF_STATUS_SET.
  IF SY-SUBRC = 0.
    LS_EVENTS-FORM = GC_PF_STATUS_SET.
    MODIFY XT_EVENTTAB FROM LS_EVENTS TRANSPORTING FORM
           WHERE NAME = SLIS_EV_PF_STATUS_SET.
  ENDIF.

ENDFORM.                    " EVENTTAB_BUILD

*---------------------------------------------------------------------*
*       FORM TOP_OF_PAGE
*---------------------------------------------------------------------*
FORM TOP_OF_PAGE.                                          "#EC CALLED

  DATA: LV_WIDTH TYPE INT4.

  CALL FUNCTION 'REUSE_ALV_LIST_LAYOUT_INFO_GET'
    IMPORTING
      E_WIDTH       = LV_WIDTH
    EXCEPTIONS
      NO_INFOS      = 1
      PROGRAM_ERROR = 2
      OTHERS        = 3.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  MOVE LV_WIDTH TO BHDGD-LINES.
  IF BHDGD-LINES LT 62.
*   BECAUSE OTHERWISE 'BHDGI_INDEX2 = BHDGD-LINES - 61'
*   WOULD COULD BE LESS THAN ZERO IN LFAGL_BATCH_HEADINGF01
*   AND 'WRITE BHDGI_T1 TO BHDGD-LINE1+26(BHDGI_INDEX2)'
*   WOULD CREATE A SHORTDUMP
    BHDGD-LINES = 132.
  ENDIF.

  CALL FUNCTION 'FAGL_BATCH_HEADING_PERFORM'
    EXPORTING
      IS_BHDGD     = BHDGD.                                    "1400193

ENDFORM.                    "TOP_OF_PAGE

*&---------------------------------------------------------------------*
*&      FORM  END_OF_LIST
*&---------------------------------------------------------------------*
FORM END_OF_LIST .                                          "#EC CALLED
  PERFORM FEHLERPROTOKOLL_AUSGEBEN.
ENDFORM.                    " EVENT_END_OF_LIST

*&---------------------------------------------------------------------*
*&      FORM  PF_STATUS_SET
*&---------------------------------------------------------------------*
*       DISPLAYING THE STATUS
*----------------------------------------------------------------------*
FORM PF_STATUS_SET USING IT_EXTAB TYPE SLIS_T_EXTAB.        "#EC *
  DATA: WA_EXTAB TYPE SLIS_EXTAB.                              "1685606
  WA_EXTAB-FCODE = '&CRTEMPL'.                                 "1685606
  INSERT WA_EXTAB INTO TABLE IT_EXTAB.                         "1685606
  WA_EXTAB-FCODE = '&URL'.                                     "1685606
  INSERT WA_EXTAB INTO TABLE IT_EXTAB.                         "1685606
  WA_EXTAB-FCODE = '&XML'.                                     "1685606
  INSERT WA_EXTAB INTO TABLE IT_EXTAB.                         "1685606
  DELETE ADJACENT DUPLICATES FROM IT_EXTAB.                    "1685606

  SET PF-STATUS 'STANDARD_ALV' EXCLUDING IT_EXTAB.      "N1253248
ENDFORM.                    " PF_STATUS_SET

*&---------------------------------------------------------------------*
*&      FORM  SORTTAB_BUILD
*&---------------------------------------------------------------------*
*       BUILD SORT TABLE FOR ALV DISPLAY
*----------------------------------------------------------------------*
FORM SORTTAB_BUILD  CHANGING XT_SORTTAB TYPE SLIS_T_SORTINFO_ALV.

  DATA: LS_SORT TYPE SLIS_SORTINFO_ALV.

  LS_SORT-GROUP = 'UL'.
  LS_SORT-UP    = 'X'.

  CASE  SORT.
* TO SORT THE RECORDS BY DATE(IN DECENDING ORDER), CUSTOMER, CHANGED BY
* AND FIELD NAME
    WHEN '1'.
      LS_SORT-FIELDNAME = 'UDATE'.
      LS_SORT-DOWN      = 'X'.
      LS_SORT-UP        = ' '.
    WHEN '2'.
      LS_SORT-FIELDNAME = 'KUNNR'.
    WHEN '3'.
      LS_SORT-FIELDNAME = 'USERNAME'.
*    WHEN '4'.                           "COMMENT BY SUPRIYA 24.07.2024
*      LS_SORT-FIELDNAME = 'FNAME'.
  ENDCASE.

  APPEND LS_SORT TO XT_SORTTAB.

ENDFORM.                    " SORTTAB_BUILD

*&---------------------------------------------------------------------*
*&      FORM  AUTH_GEN_CHECK
*&---------------------------------------------------------------------*
*       NEW AUTHORITY-CHECK FOR XALG                             914560
*----------------------------------------------------------------------*
FORM AUTH_GEN_CHECK CHANGING E_XRELE LIKE BOOLE-BOOLE.

  AUTHORITY-CHECK OBJECT 'F_KNA1_GEN'
               ID     'ACTVT' FIELD ACTVT.
   IF SY-SUBRC = 0.
     E_XRELE = 'X'.
   ELSE.
     E_XRELE = ' '.
   ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  CHECK_AUTHORITY_LAYOUT
*&---------------------------------------------------------------------*
*       CHECK WHETHER THE USER HAS THE AUTHORITY TO CREATE/CHANGE ALL
*       LAYOUTS, OR JUST TO CREATE/CHANGE USER SPECIFIC
*----------------------------------------------------------------------*
FORM CHECK_AUTHORITY_LAYOUT USING I_SAVE.                        "987855

  AUTHORITY-CHECK OBJECT 'S_ALV_LAYO'
                  ID 'ACTVT' FIELD '23'.
  IF SY-SUBRC = 0.
    I_SAVE = 'A'.
  ELSE.
    I_SAVE = 'U'.
  ENDIF.

ENDFORM.                    "CHECK_AUTHORITY_LAYOUT
*&---------------------------------------------------------------------*
*&      FORM  ZBATCH_HEADING
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM ZBATCH_HEADING .

  BHDGD-BUKRS = SPACE.
  BHDGD-INIFL = '0'.
  IF SY-LINSZ < 999.           "N2029628 TO AVOID DUMP
    BHDGD-LINES = SY-LINSZ.
  ELSE.
    BHDGD-LINES = 999.
  ENDIF.
*  BHDGD-LINES = SY-LINSZ.              "ZEILENBREITE DER LISTE
  BHDGD-UNAME = SY-UNAME.              "BENUTZERNAME
  BHDGD-REPID = SY-REPID.              "NAME DES ABAP-PROGRAMMES
  BHDGD-LINE1 = SY-TITLE.              "TITEL DES ABAP-PROGRAMMS
  BHDGD-SEPAR = SPACE.                 "KEINE LISTSEPARATION

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  ZFELDATTRIBUTE_LESEN
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM ZFELDATTRIBUTE_LESEN .

CLEAR   FLDATTRTAB.
  REFRESH FLDATTRTAB.
  IF XALG = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNA1'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADRC'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADRP'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADCP'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR2'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR3'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR4'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR5'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR6'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR7'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR8'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR10'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR11'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR12'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'ADR13'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNAS'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNAT'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNBK'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVA'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVK'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVI'.                "1801151
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVL'.                "1801151
  ENDIF.
  IF XBUK = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNB1'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNB5'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNBW'.
  ENDIF.
  IF XALG = 'X'
  OR XBUK = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNZA'.
  ENDIF.
  IF XVKO = 'X'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVV'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVD'.
    PERFORM FELDATTRIBUTE_TABELLE USING 'KNVP'.
  ENDIF.
  PERFORM FELDATTRIBUTE_TABELLE USING 'TIBAN'.           "NOTE 1551976

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  ZAENDBELEGE_LESEN
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM ZAENDBELEGE_LESEN .

*------ TABELLEN FÜR BERECHTIGUNGSPRÜFUNGEN DER OBJEKTE F_LFA1_BUK -----
*------ UND F_LFA1_EKO FÜLLEN                                      -----
  PERFORM EXCTAB_FUELLEN.

*------ ERMITTLE DEN KLEINSTEN SELEKTIERTEN WERT FÜR ÄNDERUNGSDATUM ----
  PERFORM LOW_DATUM_ERMITTELN.

*------ FLDTAB FÜLLEN MIT DEN FELDERN DER GEWÜNSCHTEN FELDGRUPPEN AUS --
*------ T055G                                                         --
  PERFORM FLDTAB_FUELLEN USING 'D'.

*------ TABELLE FÜR DIE ÄNDERUNGSBELEGKÖPFE INITIALISIEREN -------------
  CLEAR   ICDHDR.
  REFRESH ICDHDR.

*------ EXPORT-PARAMETER FÜR FB-AUFRUF FÜLLEN --------------------------
  OBJEKT = 'DEBI'.
  CLEAR UHRZEIT.

*------ BUILD RANGE WITH OBJECT ID -------------------------------------
  REFRESH GR_OBJECTID.
  LOOP AT KUNNR.
    MOVE-CORRESPONDING KUNNR TO GR_OBJECTID.
    APPEND GR_OBJECTID.
  ENDLOOP.

*------ BUILD MASTER DATA TABLE: ADDRESS & AUTHORIZATION ---------------
  CLEAR: GR_ADRNR, GT_KUNADR, GR_KUNNR.    "1661114
  REFRESH: GR_ADRNR, GT_KUNADR, GR_KUNNR.  "1661114
  GR_ADRNR-OPTION = 'EQ'.
  GR_ADRNR-SIGN   = 'I'.
  GR_KUNNR-OPTION = 'EQ'.                  "1661114
  GR_KUNNR-SIGN   = 'I'.
  LOOP AT KUNNR TRANSPORTING NO FIELDS
       WHERE SIGN NE 'I' OR
             OPTION NE 'EQ'.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC = 0 OR KUNNR[] IS INITIAL.       "1991544
    SELECT KUNNR ADRNR BEGRU KTOKD FROM KNA1
                 INTO GT_KUNADR
                 WHERE KUNNR IN KUNNR.
      IF NOT ( GT_KUNADR-BEGRU IS INITIAL ).
        AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                   ID  'BRGRU' FIELD GT_KUNADR-BEGRU
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.
      IF NOT ( GT_KUNADR-KTOKD IS INITIAL ).                     "914560
         AUTHORITY-CHECK OBJECT 'F_KNA1_GRP'
                   ID  'KTOKD' FIELD GT_KUNADR-KTOKD
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.                                                     "914560
      APPEND GT_KUNADR.
      GR_ADRNR-LOW = GT_KUNADR-ADRNR.
      APPEND GR_ADRNR.
      GR_KUNNR-LOW = GT_KUNADR-KUNNR.                          "1661114
      APPEND GR_KUNNR.                                         "1661114
    ENDSELECT.
  ELSE.
    SELECT KUNNR ADRNR BEGRU KTOKD FROM KNA1
                INTO GT_KUNADR
                FOR ALL ENTRIES IN KUNNR
                WHERE KUNNR = KUNNR-LOW.
      IF NOT ( GT_KUNADR-BEGRU IS INITIAL ).
        AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                   ID  'BRGRU' FIELD GT_KUNADR-BEGRU
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.
      IF NOT ( GT_KUNADR-KTOKD IS INITIAL ).                     "914560
         AUTHORITY-CHECK OBJECT 'F_KNA1_GRP'
                   ID  'KTOKD' FIELD GT_KUNADR-KTOKD
                   ID  'ACTVT' FIELD '08'.
        CHECK SY-SUBRC = 0.
      ENDIF.                                                     "914560
      APPEND GT_KUNADR.
      GR_ADRNR-LOW = GT_KUNADR-ADRNR.
      APPEND GR_ADRNR.
      GR_KUNNR-LOW = GT_KUNADR-KUNNR.                          "1661114
      APPEND GR_KUNNR.                                         "1661114
    ENDSELECT.
  ENDIF.

*------ EXPORT-PARAMETER USRNAME (ÄNDERER) FÜLLEN ----------------------
  PERFORM USRNAME_FUELLEN.

*------ ÄNDERUNGSBELEGKÖPFE ERMITTELN (AUFRUF DES FUNKTIONSBAUSTEINS) --
  PERFORM AENDBELEGE_ERMITTELN  TABLES GR_OBJECTID.
  DESCRIBE TABLE GR_KUNNR LINES LIN.                           "1661114
  IF NOT XALG IS INITIAL AND LIN NE 0.                 "1661114,1657998
    PERFORM ADD_IBAN_CHANGES USING OBJEKT GR_KUNNR[].     "NOTE 1575845
  ENDIF.                                                       "1657998
*------ SECOND CALL: GET CENTRAL ADDRESS CHANGES -----------------------
  IF NOT XALG IS INITIAL.
    OBJEKT = 'ADRESSE'.
    REFRESH GR_OBJECTID.
    CLEAR GR_OBJECTID.
    DESCRIBE TABLE GR_ADRNR LINES LIN.
    IF LIN < 200.
      GR_OBJECTID-OPTION = 'EQ'.
      GR_OBJECTID-SIGN   = 'I'.
      LOOP AT GR_ADRNR.
        WRITE 'BP' TO GR_OBJECTID-LOW.
        WRITE GR_ADRNR-LOW TO GR_OBJECTID-LOW+4 USING NO EDIT MASK.
        APPEND GR_OBJECTID.
      ENDLOOP.
    ENDIF.
    IF LIN <> 0.
      PERFORM AENDBELEGE_ERMITTELN  TABLES GR_OBJECTID.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  ZAENDPOSITIONEN_SORTIEREN
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM ZAENDPOSITIONEN_SORTIEREN .

 CASE SORT.

*------ CHRONOLOGISCHE SORTIERUNG (DATUM, UHRZEIT) ---------------------
    WHEN '1'.
      SORT BY ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING
              FLDTEXT
              TABFELD.

*------ SORTIERUNG NACH DEBITOR ----------------------------------------
    WHEN '2'.
      SORT BY ICDPOS-KUNNR
              ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING
              FLDTEXT
              TABFELD.

*------ SORTIERUNG NACH ÄNDERER ----------------------------------------
    WHEN '3'.
      SORT BY ICDHDR-USERNAME
              ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING
              FLDTEXT
              TABFELD.

*------ SORTIERUNG NACH FELDNAME ---------------------------------------
    WHEN '4'.
      SORT BY FLDTEXT
              TABFELD
              ICDHDR-UDATE DESCENDING
              ICDHDR-UTIME DESCENDING
              ICDHDR-CHANGENR DESCENDING.
  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  ZAENDPOSITIONEN_AUSGEBEN
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM ZAENDPOSITIONEN_AUSGEBEN .

* *------ FARBE DER ERSTEN POSITION IST COL_NORMAL INTENSIFIED -----------
  XCOLOR = ' '.

*------ LOOP ÜBER ALLE RELEVANTEN ÄNDERUNGSBELEGPOSITIONEN -------------
  LOOP.

*------ SORTIERUNG <> '4': NUMERISCHE FELDER LINKSBÜNDIG AUSGEBEN ------
    IF SORT <> '4'.
      PERFORM ZAHLEN_LINKSBUENDIG.
    ENDIF.

*------ ZAHLEN UND DATUMSWERTE MIT INITIALWERT ALS SPACE AUSGEBEN ------
    PERFORM ZAHLEN_INITIALISIEREN.

    CLEAR GS_OUTTAB.
    MOVE: ICDHDR-UDATE     TO GS_OUTTAB-UDATE,
          ICDHDR-UTIME     TO GS_OUTTAB-UTIME,
          ICDHDR-USERNAME  TO GS_OUTTAB-USERNAME,
          ICDPOS-KUNNR     TO GS_OUTTAB-KUNNR,
          FLDTEXT          TO GS_OUTTAB-FNAME,
          ICDPOS-BUKRS     TO GS_OUTTAB-BUKRS,
          ICDPOS-VKORG     TO GS_OUTTAB-VKORG,
          ICDPOS-VTWEG     TO GS_OUTTAB-VTWEG,
          ICDPOS-SPART     TO GS_OUTTAB-SPART.
*********************************************************
** ADD BY SUPRIYA 0N 24.07.2024
*    ICDPOS-ZUDATE     TO GS_OUTTAB-ZUDATE.
*    ICDPOS-ZUTIME     TO GS_OUTTAB-ZUTIME.
*********************************************************
*   CHANGED WITH NOTE 1691291
    IF ICDPOS-F_OLD+32(6) NE SPACE OR ICDPOS-F_NEW+32(6) NE SPACE.
      DATA: L_POS_TECH TYPE INT4.

      IF ICDPOS-F_OLD NE SPACE.
        CALL METHOD CL_SCP_LINEBREAK_UTIL=>STRING_SPLIT_AT_POSITION
          EXPORTING
           IM_STRING        = ICDPOS-F_OLD
           IM_LANGU         = SY-LANGU
           IM_POS_TECH      = '35'
           IM_POS_VIS       = '35'
           IM_BOUNDARY_KIND = CL_SCP_LINEBREAK_UTIL=>C_BOUNDARY_GRAPHEME
          IMPORTING
           EX_POS_TECH      = L_POS_TECH.
        MOVE: ICDPOS-F_OLD+0(L_POS_TECH) TO GS_OUTTAB-F_OLD,
              ICDPOS-F_OLD+L_POS_TECH TO GS_OUTTAB-F_OLD_35.
      ENDIF.

      IF ICDPOS-F_NEW NE SPACE.
        CALL METHOD CL_SCP_LINEBREAK_UTIL=>STRING_SPLIT_AT_POSITION
          EXPORTING
           IM_STRING        = ICDPOS-F_NEW
           IM_LANGU         = SY-LANGU
           IM_POS_TECH      = '35'
           IM_POS_VIS       = '35'
           IM_BOUNDARY_KIND = CL_SCP_LINEBREAK_UTIL=>C_BOUNDARY_GRAPHEME
          IMPORTING
           EX_POS_TECH      = L_POS_TECH.
        MOVE: ICDPOS-F_NEW+0(L_POS_TECH) TO GS_OUTTAB-F_NEW,
              ICDPOS-F_NEW+L_POS_TECH TO GS_OUTTAB-F_NEW_35.
      ENDIF.

    ELSE.
      MOVE: ICDPOS-F_OLD+0(35) TO GS_OUTTAB-F_OLD,
            ICDPOS-F_NEW+0(35) TO GS_OUTTAB-F_NEW,
            ICDPOS-F_OLD+35    TO GS_OUTTAB-F_OLD_35,
            ICDPOS-F_NEW+35    TO GS_OUTTAB-F_NEW_35.
    ENDIF.
*   CHANGED WITH NOTE 1691291

    PERFORM POSZEILE2_AUSGEBEN CHANGING GS_OUTTAB-DSCRP
                                        GS_OUTTAB-TABFELD
                                        GS_OUTTAB-OTHER_KEYS.

    IF STRLEN(  GS_OUTTAB-F_OLD ) > G_MAXLEN_OLDNEWVAL.
      G_MAXLEN_OLDNEWVAL = STRLEN(  GS_OUTTAB-F_OLD ).
    ENDIF.

    IF STRLEN(  GS_OUTTAB-F_NEW ) > G_MAXLEN_OLDNEWVAL.
      G_MAXLEN_OLDNEWVAL = STRLEN(  GS_OUTTAB-F_NEW ).
    ENDIF.

    IF ICDPOS-TABNAME = 'KNBK'.                         "NOTE 1551976
      PERFORM REPLACE_TECH_ACCOUNT USING ICDPOS-TABKEY
                                    CHANGING GS_OUTTAB.
    ENDIF.
    APPEND GS_OUTTAB TO GT_OUTTAB.

  ENDLOOP.

*** BADI FI_RFDABL00_CHGDOC                                    "1340919
  DATA: LD_REF_TO_CHDOC  TYPE REF TO IF_EX_FI_RFDABL00_CHGDOC,
        LD_ACT_IMP_CHDOC TYPE C.
  DATA: LD_SELOPT LIKE RSDSSELOPT,
        LT_SELOPT TYPE RSDS_SELOPT_T,
        LD_FRANGE TYPE RSDS_FRANGE,
        LT_FRANGE TYPE RSDS_FRANGE_T.

*  DATA: LT_OUTTAB TYPE TABLE OF FOAP_ACC_S_RFDABL00_LIST.
 DATA: LT_OUTTAB TYPE TABLE OF ZFOAP_ACC_S_RFDABL00_LIST.
  CALL METHOD CL_EXITHANDLER=>GET_INSTANCE
    EXPORTING
      EXIT_NAME              = 'FI_RFDABL00_CHGDOC'
      NULL_INSTANCE_ACCEPTED = 'X'
    IMPORTING
      ACT_IMP_EXISTING       = LD_ACT_IMP_CHDOC
    CHANGING
      INSTANCE               = LD_REF_TO_CHDOC.

  IF  NOT LD_ACT_IMP_CHDOC IS INITIAL
  AND NOT LD_REF_TO_CHDOC  IS INITIAL.


*   CREATE THE DYNAMIC SELECTIONS FOR THE
    IF NOT KUNNR[] IS INITIAL.
      REFRESH: LT_SELOPT.
      LD_FRANGE-FIELDNAME = 'KUNNR'.
      LOOP AT KUNNR.
        MOVE-CORRESPONDING KUNNR TO LD_SELOPT.
        APPEND LD_SELOPT TO LT_SELOPT.
      ENDLOOP.
      LD_FRANGE-SELOPT_T = LT_SELOPT[].
      APPEND LD_FRANGE TO LT_FRANGE.
    ENDIF.
    IF NOT DATUM[] IS INITIAL.
      REFRESH: LT_SELOPT.
      LD_FRANGE-FIELDNAME = 'DATUM'.
      LOOP AT DATUM.
        MOVE-CORRESPONDING DATUM TO LD_SELOPT.
        APPEND LD_SELOPT TO LT_SELOPT.
      ENDLOOP.
      LD_FRANGE-SELOPT_T = LT_SELOPT[].
      APPEND LD_FRANGE TO LT_FRANGE.
    ENDIF.
    IF NOT UNAME[] IS INITIAL.
      REFRESH: LT_SELOPT.
      LD_FRANGE-FIELDNAME = 'UNAME'.
      LOOP AT UNAME.
        MOVE-CORRESPONDING UNAME TO LD_SELOPT.
        APPEND LD_SELOPT TO LT_SELOPT.
      ENDLOOP.
      LD_FRANGE-SELOPT_T = LT_SELOPT[].
      APPEND LD_FRANGE TO LT_FRANGE.
    ENDIF.

*    CALL METHOD LD_REF_TO_CHDOC->CHANGE_DOCUMENTS   "  COMMENTED BY SUPRIYA ON 25.07.2024
*       EXPORTING
*         CT_SEL         = LT_FRANGE
*       CHANGING
*         CT_CHANGE_DOCS = LT_OUTTAB.

    LOOP AT LT_OUTTAB INTO GS_OUTTAB.
*     AUTHORITY AND VALIDITY CHECK FOR BUKRS
      IF NOT GS_OUTTAB-BUKRS IS INITIAL.
        LOOP AT EXCTAB_F_KNA1_BUK WHERE BUKRS = GS_OUTTAB-BUKRS.
         EXIT.
        ENDLOOP.
        CHECK SY-SUBRC NE 0.

        CHECK GS_OUTTAB-BUKRS IN BUKRS.
      ENDIF.

      APPEND GS_OUTTAB TO GT_OUTTAB.
    ENDLOOP.
  ENDIF.




**********************************************************

*IF P_DOWN = 'X'.
* LOOP AT LT_OUTTAB INTO DATA(LS_OUTTAB).
*
*  IF LS_OUTTAB-UDATE IS NOT INITIAL.
*          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*            EXPORTING
*              INPUT  = LS_OUTTAB-UDATE
*            IMPORTING
*              OUTPUT =  LS_OUTTAB1-UDATE.
*
*          CONCATENATE LS_OUTTAB1-UDATE+0(2)  LS_OUTTAB1-UDATE+2(3)  LS_OUTTAB1-UDATE+5(4)
*                          INTO  LS_OUTTAB1-UDATE SEPARATED BY '-'.
**APPEND LS_OUTTAB1 to Lt_OUTTAB1.
*  ENDIF.
*
*
* LS_OUTTAB1-UTIME     = LS_OUTTAB-UTIME.
*
* LS_OUTTAB1-USERNAME  = LS_OUTTAB-USERNAME.
* LS_OUTTAB1-KUNNR     = LS_OUTTAB-KUNNR.
* LS_OUTTAB1-FNAME     = LS_OUTTAB-FNAME.
* LS_OUTTAB1-BUKRS     = LS_OUTTAB-BUKRS.
* LS_OUTTAB1-VKORG     = LS_OUTTAB-VKORG.
* LS_OUTTAB1-VTWEG     = LS_OUTTAB-VTWEG.
* LS_OUTTAB1-SPART     = LS_OUTTAB-SPART.
* LS_OUTTAB1-DSCRP     = LS_OUTTAB-DSCRP.
*
**data: REF_DATE  TYPE CHAR11,
**      REF_TIME  TYPE CHAR15.
** IF LS_OUTTAB1-REF_DATE IS NOT INITIAL.
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            INPUT  = SY-DATUM
*          IMPORTING
*            OUTPUT = LS_OUTTAB1-REF_DATE.
* IF LS_OUTTAB1-REF_DATE IS NOT INITIAL.
*        CONCATENATE LS_OUTTAB1-REF_DATE+0(2) LS_OUTTAB1-REF_DATE+2(3) LS_OUTTAB1-REF_DATE+5(4)
*                        INTO LS_OUTTAB1-REF_DATE SEPARATED BY '-'.
*        LS_OUTTAB1-REF_TIME = SY-UZEIT.
* ENDIF.
*      CONCATENATE LS_OUTTAB1-REF_TIME+0(2) ':' LS_OUTTAB1-REF_TIME+2(2)  INTO LS_OUTTAB1-REF_TIME.
**       APPEND LS_OUTTAB1 TO LT_OUTTAB1.
** ENDIF.
*   APPEND LS_OUTTAB1 TO LT_OUTTAB1.
* endloop.
*ENDIF.
*
**ENDIF.
*ENDFORM.
************************************************************************
IF P_DOWN = 'X'.
* LOOP AT LT_OUTTAB INTO DATA(LS_OUTTAB).
  LOOP AT GT_OUTTAB INTO GS_OUTTAB.
* LS_OUTTAB1-UDATE = LS_OUTTAB-UDATE.

  IF GS_OUTTAB-UDATE IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
            EXPORTING
              INPUT  = GS_OUTTAB-UDATE
            IMPORTING
              OUTPUT =  LS_OUTTAB1-UDATE.

          CONCATENATE LS_OUTTAB1-UDATE+0(2)  LS_OUTTAB1-UDATE+2(3)  LS_OUTTAB1-UDATE+5(4)
                          INTO  LS_OUTTAB1-UDATE SEPARATED BY '-'.
*APPEND LS_OUTTAB1 to Lt_OUTTAB1.
  ENDIF.


 LS_OUTTAB1-UTIME     = GS_OUTTAB-UTIME.

 LS_OUTTAB1-USERNAME  = GS_OUTTAB-USERNAME.
 LS_OUTTAB1-KUNNR     = GS_OUTTAB-KUNNR.
 LS_OUTTAB1-DSCRP     = GS_OUTTAB-DSCRP.
 LS_OUTTAB1-FNAME     = GS_OUTTAB-FNAME.
 LS_OUTTAB1-BUKRS     = GS_OUTTAB-BUKRS.
 LS_OUTTAB1-VKORG     = GS_OUTTAB-VKORG.
 LS_OUTTAB1-VTWEG     = GS_OUTTAB-VTWEG.
 LS_OUTTAB1-SPART     = GS_OUTTAB-SPART.
* LS_OUTTAB1-F_OLD_35  = GS_OUTTAB-F_OLD_35.
 LS_OUTTAB1-F_NEW  =  GS_OUTTAB-F_NEW.
 LS_OUTTAB1-F_OLD  = GS_OUTTAB-F_OLD.
* LS_OUTTAB1-DSCRP     = GS_OUTTAB-DSCRP.

*data: REF_DATE  TYPE CHAR11,
*      REF_TIME  TYPE CHAR15.
* IF LS_OUTTAB1-REF_DATE IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = SY-DATUM
          IMPORTING
            OUTPUT = LS_OUTTAB1-REF_DATE.
 IF LS_OUTTAB1-REF_DATE IS NOT INITIAL.
        CONCATENATE LS_OUTTAB1-REF_DATE+0(2) LS_OUTTAB1-REF_DATE+2(3) LS_OUTTAB1-REF_DATE+5(4)
                        INTO LS_OUTTAB1-REF_DATE SEPARATED BY '-'.
        LS_OUTTAB1-REF_TIME = SY-UZEIT.
 ENDIF.
      CONCATENATE LS_OUTTAB1-REF_TIME+0(2) ':' LS_OUTTAB1-REF_TIME+2(2)  INTO LS_OUTTAB1-REF_TIME.
*       APPEND LS_OUTTAB1 TO LT_OUTTAB1.
* ENDIF.
   APPEND LS_OUTTAB1 TO LT_OUTTAB1.
 endloop.
ENDIF.

*ENDIF.
ENDFORM.



********************************************************************
* LS_OUTTAB1-USERNAME  = LS_OUTTAB-USERNAME,
* LS_OUTTAB1-KUNNR     = LS_OUTTAB-KUNNR,
* LS_OUTTAB1-FNAME     = LS_OUTTAB-FNAME,
* LS_OUTTAB1-BUKRS     = LS_OUTTAB-BUKRS,
* LS_OUTTAB1-VKORG     = LS_OUTTAB-VKORG,
* LS_OUTTAB1-VTWEG     = LS_OUTTAB-VTWEG,
* LS_OUTTAB1-SPART     = LS_OUTTAB-SPART.
* LS_OUTTAB1-           = LS_OUTTAB-ZREF_DATE
* LS_OUTTAB1-           = LS_OUTTAB-ZREF_TIME




*CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            INPUT  = SY-DATUM
*          IMPORTING
*            OUTPUT = GS_OUTTAB-REF_DATE.
*  IF SY-DATUM IS NOT INITIAL.
*        CONCATENATE GS_OUTTAB1-REF_DATE+0(2) GS_OUTTAB1-REF_DATE+2(3) GS_OUTTAB1-REF_DATE+5(4)
*                        INTO GS_OUTTAB1-REF_DATE SEPARATED BY '-'.
*        GS_OUTTAB1-REF_TIME = SY-UZEIT. "ADDED BY JYOTI ON 29.04.2024
*      CONCATENATE GS_OUTTAB1-REF_TIME+0(2) ':' GS_OUTTAB-REF_TIME+2(2)  INTO GS_OUTTAB1-REF_TIME.
*  ENDIF.
* REF_DATE  TYPE CHAR11.
* REF_TIME  TYPE CHAR15.

* ENDIF.
*************************************************************








*** BADI FI_RFDABL00_CHGDOC                                    "1340919
****************************************ADD BY SUPRIYA ON 23.07.2024
* MOVE GT_OUTTAB TO LT_OUTTAB1.
****************************************END BY SUPRIYA
*ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  DOWNLOAD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM DOWNLOAD .
 TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: LV_FOLDER(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).
*BREAK PRIMUS.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       =  LT_OUTTAB1                     "LT_FINAL1
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  LV_FOLDER = 'D:\USR\SAP\DEV\D00\WORK'.
  LV_FILE = 'ZCUST_CHANGES.TXT'.
*BREAK PRIMUS.
*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZCUST_CHANGES DOWNLOAD STARTED ON', SY-DATUM, 'AT', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_2634 TYPE string.
DATA lv_crlf_2634 TYPE string.
lv_crlf_2634 = cl_abap_char_utilities=>cr_lf.
lv_string_2634 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_2634 lv_crlf_2634 wa_csv INTO lv_string_2634.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_2634 TO lv_fullfile.
*TRANSFER lv_string_2634 TO lv_fullfile.
    CONCATENATE 'FILE' LV_FULLFILE 'DOWNLOADED' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  CVS_HEADER
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_HD_CSV  TEXT
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING  P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'DATE'
              'TIME'
              'CHANGED BY'
              'CUSTOMER'
              'CUSTOMER NAME'
              'FIELD NAME'
              'COMPANY CODE'
              'SALES ORG'
              'DISTRIBUTION CHNNL'
              'DIVISION'
              'NEW VALUE'
              'OLD VALUE'
*              'CUSTOMER NAME'
              'REFRESHABLE DATE'
              'REFRESHABLE TIME'




*  CONCATENATE 'DATE'    " changesby 24.07.2024
*              'TIME'
*              'CHANGED BY'
*              'CUSTOMER'
**              'CUSTOMER NAME'
*              'FIELD NAME'
*              'COMPANY COAD'
*              'SO RG'
*              'DCHL'
*              'DIVISION'
*              'NEW VALUE'
*              'OLD VALUE'
**              'CUSTOMER NAME'
*              'REFRESHABLE DATE'
*              'REFRESHABLE TIME'
              INTO P_HD_CSV                       " PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
