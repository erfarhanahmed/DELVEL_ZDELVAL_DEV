*&---------------------------------------------------------------------*
*&  Include           YRASORT_ALV_MISC
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*   INCLUDE RASORT_ALV40                                               *
*----------------------------------------------------------------------*

*---------------------------------------------------------------------*
* Merken der benoetigten Feldattribute der Sortierfelder (aus DDIC)   *
* in der internen Tabelle FELD.                                       *
*---------------------------------------------------------------------*
* <-- FELD       Tabelle mit Feldattributen der Sortierfelder         *
* <-- FLG_XANLN1 Kennzeichen "Summe je Hauptnummer ausgeben"          *
*---------------------------------------------------------------------*
FORM FELDATTRIBUTE_MERKEN.

*   T086 einlesen.
  SELECT SINGLE * FROM T086
    WHERE SRTVAR EQ SRTVR.
*
  IF SY-SUBRC EQ 0.
*     Summe je Anlage ausgeben.
    MOVE T086-XANLN1 TO FLG_XANLN1.
*     Für Add-Fields eine Initialisierung durchführen
    IF T086-ANZUNTNR IS INITIAL.
      T086-ANZUNTNR = 2.
    ENDIF.
  ELSE.
*     Keine Sortiervariante angegeben.
    CLEAR FLG_XANLN1.
  ENDIF.

*   Tabelle Feld fuellen.
  REFRESH FELD.
  PERFORM FELD_FUELLEN USING T086-TABLN1  T086-FELDN1
                             T086-OFFSET1 T086-LAENGE1
                             T086-XSUMM1  T086-XAFLG1
                             T086-XNEWPG1.
  PERFORM FELD_FUELLEN USING T086-TABLN2  T086-FELDN2
                             T086-OFFSET2 T086-LAENGE2
                             T086-XSUMM2  T086-XAFLG2
                             T086-XNEWPG2.
  PERFORM FELD_FUELLEN USING T086-TABLN3  T086-FELDN3
                             T086-OFFSET3 T086-LAENGE3
                             T086-XSUMM3  T086-XAFLG3
                             T086-XNEWPG3.
  PERFORM FELD_FUELLEN USING T086-TABLN4  T086-FELDN4
                             T086-OFFSET4 T086-LAENGE4
                             T086-XSUMM4  T086-XAFLG4
                             T086-XNEWPG4.
  PERFORM FELD_FUELLEN USING T086-TABLN5  T086-FELDN5
                             T086-OFFSET5 T086-LAENGE5
                             T086-XSUMM5  T086-XAFLG5
                             T086-XNEWPG5.

* Muss Kostenstellenstamm/Bilanzversion gelesen werden?
  LOOP AT FELD
    WHERE TABLN EQ 'ANLAV'
    AND ( FELDN EQ 'KHINR' OR
          FELDN EQ 'TXJCD' OR
          FELDN EQ 'PRCTR' OR
          FELDN EQ 'ERGSO' OR
          FELDN EQ 'ERGHB' ).
    CASE FELD-FELDN.
      WHEN 'KHINR'.
         *ANLA0-XKOST = 'X'.
      WHEN 'TXJCD'.
         *ANLA0-XKOST = 'X'.
      WHEN 'PRCTR'.
         *ANLA0-XKOST = 'X'.
      WHEN 'ERGSO'.
         *ANLA0-XBILV = 'X'.
      WHEN 'ERGHB'.
         *ANLA0-XBILV = 'X'.
    ENDCASE.
  ENDLOOP.

* Summenbericht + keine Stufe zum Summieren vorgesehen ...
  IF SUMMB NE SPACE.
    DESCRIBE TABLE FELD LINES CNT_COUNT.
    IF CNT_COUNT GT 0.
      LOOP AT FELD
        WHERE XSUMM NE SPACE.
      ENDLOOP.
    ENDIF.
    IF CNT_COUNT = 0  OR
     ( CNT_COUNT > 0  AND
       SY-SUBRC NE 0 ).
*          ... Fehler!
      MESSAGE E036 WITH SRTVR.
    ENDIF.
  ENDIF.

* Anzahl Sortierfelder in Sortierstufe merken.
  DESCRIBE TABLE FELD LINES CNT_COUNT.
  MOVE CNT_COUNT TO CON_SRTST.

ENDFORM.                    "FELDATTRIBUTE_MERKEN


*---------------------------------------------------------------------*
*       FORM FELD_FUELLEN                                             *
*---------------------------------------------------------------------*
*       FELD ist die Tabelle für die Sortierfelder.                   *
*---------------------------------------------------------------------*
*  -->  F_TABLN                                                       *
*  -->  F_FELDN                                                       *
*  -->  F_OFFSET                                                      *
*  -->  F_LAENGE                                                      *
*  -->  F_XSUMM                                                       *
*  -->  F_XAFLG                                                       *
*---------------------------------------------------------------------*
FORM FELD_FUELLEN USING F_TABLN  F_FELDN
                        F_OFFSET F_LAENGE
                        F_XSUMM  F_XAFLG
                        F_XNEWPG.

  DATA: L_PACK(6)      TYPE P,
        L_CHAR(10)     TYPE C,
        L_FTEXT        LIKE DFIES-REPTEXT,
        L_POSITION     LIKE SY-FDPOS.
  DATA: WA_DFIES TYPE DFIES.
  DATA: DDIC_TABNAME   LIKE DFIES-TABNAME,
        DDIC_FIELDNAME LIKE DFIES-LFIELDNAME.

  IF F_TABLN NE SPACE.

    CLEAR FELD.
*
    MOVE: F_TABLN TO FELD-TABLN,
          F_FELDN TO FELD-FELDN,
          F_OFFSET TO FELD-FOFFSET,
          F_LAENGE TO FELD-LAENGE,
          F_XSUMM TO FELD-XSUMM,
          F_XAFLG TO FELD-XAFLG,
          F_XNEWPG TO FELD-XNEWPG.

    DDIC_TABNAME   = FELD-TABLN.
    DDIC_FIELDNAME = FELD-FELDN.
    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING
        TABNAME    = DDIC_TABNAME
        LFIELDNAME = DDIC_FIELDNAME
      IMPORTING
        DFIES_WA   = WA_DFIES
      EXCEPTIONS
        OTHERS     = 0.
*    if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    endif.

**
*    PERFORM GET_FIELD(RDDFIE00)
*      USING F_TABLN F_FELDN SY-LANGU
*      CHANGING DFIES SY-SUBRC.
*
    MOVE: WA_DFIES-SCRTEXT_M TO FELD-FTEXT,
          WA_DFIES-HEADLEN   TO FELD-LAENG,
          WA_DFIES-REPTEXT   TO FELD-SPALT.
*   Bei Offset und Laenge: FTEXT korrigieren.
*   Mit ALV leider nicht möglich!
*    IF not f_offset is initial.
*      MOVE: '+'        TO l_char(1),
*            f_offset   TO l_pack.
*      WRITE l_pack     TO l_char+1(2).
*    ENDIF.
*    IF not f_laenge is initial.
*      MOVE: '(  )'     TO l_char+3(4),
*            f_laenge   TO l_pack.
*      WRITE l_pack     TO l_char+4(2).
*    ENDIF.
    CONDENSE L_CHAR NO-GAPS.
    IF L_CHAR CA ' '.
    ENDIF.
    L_POSITION = 20 - SY-FDPOS.
    L_FTEXT = FELD-FTEXT.
    MOVE L_FTEXT+L_POSITION TO  L_CHAR.
*   PERFORM FIELD_ASSIGN USING L_FTEXT+L_POSITION L_CHAR.
    CONDENSE L_FTEXT NO-GAPS.
    FELD-FTEXT = L_FTEXT.
*   Bei Offset und Laenge: LAENG korrigieren.
    IF NOT F_LAENGE IS INITIAL.
      FELD-LAENG = F_LAENGE.
    ENDIF.
*    IF not f_offset is initial and
*           f_laenge is initial .
*      feld-laeng = feld-laeng - f_offset.
*    ENDIF.
*
    APPEND FELD.

  ENDIF.

ENDFORM.                    "FELD_FUELLEN


*---------------------------------------------------------------------*
*       FORM FIELD_ASSIGN                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  F_SOURCE                                                      *
*  -->  F_TARGET                                                      *
*---------------------------------------------------------------------*
FORM FIELD_ASSIGN USING F_SOURCE F_TARGET.

  F_SOURCE = F_TARGET.

ENDFORM.                    "FIELD_ASSIGN


*---------------------------------------------------------------------*
* Zuweisung der Sortierfelder aus T086 zu den Feldsymbolen.           *
*---------------------------------------------------------------------*
FORM FELDSYMBOLE_ZUWEISEN.

* 1. Feldsymbol.
  READ TABLE FELD INDEX 1.
  IF SY-SUBRC EQ 0.
    PERFORM FLST_AUFBAUEN.
    ASSIGN (FLST) TO <S1>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMLINE TO <SUM1>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMTAB_DATA_S TO <SUM_S1>.
  ELSE.
    ASSIGN SAV_DUMMY TO <S1>.
  ENDIF.

* 2. Feldsymbol.
  READ TABLE FELD INDEX 2.
  IF SY-SUBRC EQ 0.
    PERFORM FLST_AUFBAUEN.
    ASSIGN (FLST) TO <S2>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMLINE TO <SUM2>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMTAB_DATA_S TO <SUM_S2>.
  ELSE.
    ASSIGN SAV_DUMMY TO <S2>.
  ENDIF.

* 3. Feldsymbol.
  READ TABLE FELD INDEX 3.
  IF SY-SUBRC EQ 0.
    PERFORM FLST_AUFBAUEN.
    ASSIGN (FLST) TO <S3>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMLINE TO <SUM3>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMTAB_DATA_S TO <SUM_S3>.
  ELSE.
    ASSIGN SAV_DUMMY TO <S3>.
  ENDIF.

* 4. Feldsymbol.
  READ TABLE FELD INDEX 4.
  IF SY-SUBRC EQ 0.
    PERFORM FLST_AUFBAUEN.
    ASSIGN (FLST) TO <S4>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMLINE TO <SUM4>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMTAB_DATA_S TO <SUM_S4>.
  ELSE.
    ASSIGN SAV_DUMMY TO <S4>.
  ENDIF.

* 5. Feldsymbol.
  READ TABLE FELD INDEX 5.
  IF SY-SUBRC EQ 0.
    PERFORM FLST_AUFBAUEN.
    ASSIGN (FLST) TO <S5>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMLINE TO <SUM5>.
    ASSIGN COMPONENT FELD-FELDN OF STRUCTURE SUMTAB_DATA_S TO <SUM_S5>.
  ELSE.
    ASSIGN SAV_DUMMY TO <S5>.
  ENDIF.

ENDFORM.                    "FELDSYMBOLE_ZUWEISEN

*---------------------------------------------------------------------*
*       FORM FLST_AUFBAUEN                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM FLST_AUFBAUEN.

  CLEAR FLST.

  MOVE: FELD-TABLN TO FLST-TABLN,
        '-'        TO FLST-STRIC,
        FELD-FELDN TO FLST-FELDN.
* Offset?
* Mit ALV leider nicht möglich!
*  IF not feld-foffset is initial.
*    WRITE: '+'         TO flst-offset(1),
*           feld-foffset TO flst-offset+1(2).
*  ELSE.
  CLEAR FLST-OFFSET.
*  ENDIF.
* Laenge?
*  IF not feld-laenge is initial.
*    WRITE: '(  )'      TO flst-laenge,
*           feld-laenge TO flst-laenge+1(2).
*  ELSE.
  CLEAR FLST-LAENGE.
*  ENDIF.
*
  CONDENSE FLST NO-GAPS.

ENDFORM.                    "FLST_AUFBAUEN

*---------------------------------------------------------------------*
* Einlesen des Kurztextes zu AfA-Bereich AKL_AFABE.                   *
*---------------------------------------------------------------------*
* --> AKL_AFABE  AfA-Bereich                                          *
* <-- AKL_AFKTX  Kurztext zu AfA-Bereich                              *
*---------------------------------------------------------------------*
FORM AFABEKTX_LESEN USING AKL_AFABE AKL_AFKTX.

* Default: Text = SPACE.
  CLEAR AKL_AFKTX.
* Zuerst Bewertungsplan zu Buchungskreis lesen.
  SELECT SINGLE * FROM T093C
    WHERE BUKRS EQ ANLAV-BUKRS.
* Kurztext zu AfA-Bereich lesen.
  IF SY-SUBRC EQ 0.
    SELECT SINGLE * FROM T093T
      WHERE SPRAS  EQ SY-LANGU
      AND   AFAPL  EQ T093C-AFAPL
      AND   AFABER EQ AKL_AFABE.
    IF SY-SUBRC EQ 0.
      AKL_AFKTX = T093T-AFBKTX.
    ENDIF.
  ENDIF.

ENDFORM.                    "AFABEKTX_LESEN


*---------------------------------------------------------------------*
* Ermittlung des Waehrungsschluessels zu AfA-Bereich WER_AFABE.       *
*---------------------------------------------------------------------*
* --> WER_AFABE  AfA-Bereich                                          *
* <-- WER_WAERS  Waehrungsschluessel                                  *
*---------------------------------------------------------------------*
FORM WAEHRUNG_ERMITTELN USING VALUE(WER_AFABE) WER_WAERS.

  CLEAR WER_WAERS.
  IF NOT UMVAR IS INITIAL.
    SELECT SINGLE * FROM T091C WHERE UMVAR = UMVAR.
    IF SY-SUBRC = 0 AND NOT T091C-WAERS IS INITIAL.
      WER_WAERS = T091C-WAERS.
      EXIT.
    ENDIF.
  ENDIF.

* Waehrungsschluessel aus T093B.
* select single * from t093b
*   where bukrs eq anlav-bukrs
*   and   afabe eq wer_afabe.

  T093B-BUKRS = ANLAV-BUKRS.
  IF WER_AFABE = '*'.
    T093B-AFABE = CON_LEITBE.
  ELSE.
    T093B-AFABE = WER_AFABE.
  ENDIF.

*  call function 'T093B_READ'
*       exporting
*            f_t093b   = t093b
*       importing
*            f_t093b   = t093b
*       exceptions
*            not_found = 1
*            others    = 2.

  CALL FUNCTION 'T093B_READ_VIRTUAL'
*    IMPORTING
*         E_VIRTUAL =
     CHANGING
          F_T093B   = T093B
     EXCEPTIONS
          NOT_FOUND = 1
          OTHERS    = 2.
  IF SY-SUBRC EQ 0.
    WER_WAERS = T093B-WAERS.
* Nix gefunden?
  ELSE.
*   Dann nimm die Hauswaehrung.
    SELECT SINGLE * FROM T001
      WHERE BUKRS EQ ANLAV-BUKRS.
    WER_WAERS = T001-WAERS.
  ENDIF.

ENDFORM.                    "WAEHRUNG_ERMITTELN

*---------------------------------------------------------------------*
*       FORM FLG_EINZEL_SETZEN                                        *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM FLG_EINZEL_SETZEN.

  DATA: L_CNT  LIKE SY-TFILL,
        L_CNT1 LIKE SY-TFILL,
        L_CNT2 LIKE SY-TFILL.

* Default-Annahme: Keine Einzelsatzverarbeitung.
  FLG_EINZEL = OFF.

* Mehrere Buchungskreise ==> Keine Einzelsatzverarbeitung.
  DESCRIBE TABLE BUKRS LINES L_CNT.
  CHECK L_CNT EQ 1.
  READ TABLE BUKRS INDEX 1.
  CHECK BUKRS-SIGN  EQ 'I'                       AND
        ( BUKRS-OPTION  EQ 'EQ'              OR
          ( BUKRS-OPTION  EQ 'BT'        AND
            BUKRS-LOW     EQ BUKRS-HIGH  )   )   .

* Verarbeitung von InvProgrammen oder Projekten ==>
* Keine Einzelsatzverarbeitung.
  CHECK PA_XINVP IS INITIAL AND
        PA_XPROJ IS INITIAL .

* Verarbeitung von Anlagen  u n d  Aufträgen ==>
* Keine Einzelsatzverarbeitung.
  CHECK   PA_XANLG IS INITIAL OR
          PA_XAUFT IS INITIAL .

* Verarbeitung von Anlagen.
  IF NOT PA_XANLG IS INITIAL.
    DESCRIBE TABLE ANLAGE   LINES L_CNT.
    CHECK L_CNT EQ 1.
    DESCRIBE TABLE UNTNR    LINES L_CNT.
    CHECK L_CNT EQ 1.
    READ TABLE ANLAGE INDEX 1.
    READ TABLE UNTNR  INDEX 1.
    CHECK ANLAGE-SIGN EQ 'I'                       AND
          ( ANLAGE-OPTION EQ 'EQ'              OR
            ( ANLAGE-OPTION EQ 'BT'        AND
              ANLAGE-LOW    EQ ANLAGE-HIGH )   )   .
    CHECK UNTNR-SIGN EQ 'I'                      AND
          ( UNTNR-OPTION EQ 'EQ'             OR
            ( UNTNR-OPTION EQ 'BT'       AND
              UNTNR-LOW    EQ UNTNR-HIGH )   )   .
    FLG_EINZEL = ON.
  ENDIF.

* Verarbeitung von Aufträgen.
  IF NOT PA_XAUFT IS INITIAL.
*   Genau eine Abgrenzung Auftraege, sonst sicher keine
*   Einzelsatzverarbeitung.
    DESCRIBE TABLE SO_EAUFN LINES L_CNT1.
    CHECK L_CNT1 EQ 1.
    IF L_CNT1 EQ 1.
      READ TABLE SO_EAUFN INDEX 1.
      CHECK SO_EAUFN-SIGN EQ 'I'                         AND
            ( SO_EAUFN-OPTION EQ 'EQ'                OR
              ( SO_EAUFN-OPTION EQ 'BT'          AND
                SO_EAUFN-LOW    EQ SO_EAUFN-HIGH )   )   .
      FLG_EINZEL = ON.
    ENDIF.
  ENDIF.

ENDFORM.                    "FLG_EINZEL_SETZEN

* Beim ersten Aufruf Selektionsoptionen sichern.
* Beim Aufruf aus einem PickUp werden die im Memory gespeicherten
* Selektionsoptionen wieder eingelesen.
FORM INFO_PICK_UP.
  IF FLG_NOT_FIRST <> 0.
    PERFORM SORTIERWERTE_EINLESEN.
  ENDIF.
ENDFORM.                    "INFO_PICK_UP


*---------------------------------------------------------------------*
*       FORM SORTIERWERTE_EINLESEN                                    *
*---------------------------------------------------------------------*
*       Einlesen der Sortierwerte aus dem Memory                      *
*---------------------------------------------------------------------*
FORM SORTIERWERTE_EINLESEN.
  IMPORT Z_FELD_IND FROM MEMORY ID 'ind'.
  IF Z_FELD_IND >= 1.
    IMPORT SO_SEL1 FROM MEMORY ID 'so_sel1'.
  ENDIF.
  IF Z_FELD_IND >= 2.
    IMPORT SO_SEL2 FROM MEMORY ID 'so_sel2'.
  ENDIF.
  IF Z_FELD_IND >= 3.
    IMPORT SO_SEL3 FROM MEMORY ID 'so_sel3'.
  ENDIF.
  IF Z_FELD_IND >= 4.
    IMPORT SO_SEL4 FROM MEMORY ID 'so_sel4'.
  ENDIF.
  IF Z_FELD_IND >= 5.
    IMPORT SO_SEL5 FROM MEMORY ID 'so_sel5'.
  ENDIF.
ENDFORM.                    "SORTIERWERTE_EINLESEN

* Bei Aufruf aus einem PickUp einer Zeile werden die Sortierwerte der
* aufgepickten Zeile gegen die aktuellen Daten gecheckt.
* Entsprechen die aktuellen Daten diesen nicht werden sie auch nicht
* in den Datenbestand extrahiert.
* Weiterhin werden alle Anlagen nicht angelistet, die einem Komplex
* zugeordnet sind.
FORM SORT_CHECK.
  IF FLG_NOT_FIRST = 1.
    PERFORM SORTIERWERTE_CHECKEN USING FLG_CHK_SUCCESS.
    IF FLG_CHK_SUCCESS NE 1.
* Daten erfüllen nicht die Sortierkriterien.
      REJECT.
    ENDIF.
  ENDIF.
ENDFORM.                    "SORT_CHECK

*---------------------------------------------------------------------*
*       FORM SORTIERWERTE_CHECKEN                                     *
*---------------------------------------------------------------------*
*       Die Sortierwerte der aufgepickten  Zeile werden gegen         *
*       die aktuellen Werte gecheckt                                  *
*---------------------------------------------------------------------*
*  -->  FLG_CHK_SUCCESS                                               *
*       gibt an, ob aktueller Wert den Check bestanden hat            *
*---------------------------------------------------------------------*
FORM SORTIERWERTE_CHECKEN USING FLG_CHK_SUCCESS.
* BREAK-POINT.
  FLG_CHK_SUCCESS = 0.
  IF Z_FELD_IND >= 1.                  "Sortierstufe 1
    MOVE <S1> TO HLP_FELD.
    CHECK HLP_FELD IN SO_SEL1.
  ENDIF.
  IF Z_FELD_IND >= 2.                  "Sortierstufe 2
    MOVE <S2> TO HLP_FELD.
    CHECK HLP_FELD IN SO_SEL2.
  ENDIF.
  IF Z_FELD_IND >= 3.                  "Sortierstufe 3
    MOVE <S3> TO HLP_FELD.
    CHECK HLP_FELD IN SO_SEL3.
  ENDIF.
  IF Z_FELD_IND >= 4.                  "Sortierstufe 4
    MOVE <S4> TO HLP_FELD.
    CHECK HLP_FELD IN SO_SEL4.
  ENDIF.
  IF Z_FELD_IND >= 5.                  "Sortierstufe 5
    MOVE <S5> TO HLP_FELD.
    CHECK HLP_FELD IN SO_SEL5.
  ENDIF.
  FLG_CHK_SUCCESS = 1.                 "Daten entsprechen Sortierwerten
ENDFORM.                    "SORTIERWERTE_CHECKEN

* Select-Option-Tabelle für Pick-Up aufbauen bzw. zurücksetzen.
FORM SO_TAB_ERNEUERN TABLES SO_NAME SAV_SO_NAME.
* SO-Tabelle erfrischen
  CLEAR   SO_NAME.
  REFRESH SO_NAME.
* SO-Tabelle in Anfangszustand zurücksetzen
  LOOP AT SAV_SO_NAME.
    MOVE SAV_SO_NAME TO SO_NAME.
    APPEND SO_NAME.
  ENDLOOP.
ENDFORM.                    "SO_TAB_ERNEUERN

*---------------------------------------------------------------------*
*       FORM KOMPL_TESTEN                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM KOMPL_TESTEN.
  DATA: FLG_KOMPL.
  DATA: X093C LIKE T093C OCCURS 0 WITH HEADER LINE.
  DATA: X093B LIKE T093B OCCURS 0 WITH HEADER LINE.

  IF SUMMB IS INITIAL.
    IF *ANLA0-XAKPL IS INITIAL.
*     select * from  t093b
*       where  bukrs  in bukrs
*       and  (  afabe = bereich1 or afabe = bereich2 or
*                 afabe = bereich3 )
*       order by primary key.
*
*       if not t093b-xakpl is initial.
*         flg_kompl = 'X'.
*         exit.
*       endif.
*     endselect.


      CALL FUNCTION 'T093C_READ_MULTIPLE'
        TABLES
          T_T093C          = X093C
        EXCEPTIONS
          NO_BUKRS_DEFINED = 1
          OTHERS           = 2.

      LOOP AT X093C WHERE BUKRS IN BUKRS.

        CALL FUNCTION 'T093B_READ_MULTIPLE'
             EXPORTING
                  I_BUKRS         =  X093C-BUKRS
             TABLES
                  T_T093B         =  X093B
*                  T_T093T         =
             EXCEPTIONS
                  T093B_NOT_FOUND = 1
                  OTHERS          = 2.

        LOOP AT X093B.
          IF BEREICH1 <> '*'.
            CHECK ( X093B-AFABE = BEREICH1 OR
                    X093B-AFABE = BEREICH2 OR
                    X093B-AFABE = BEREICH3 ).
          ENDIF.
          IF NOT X093B-XAKPL IS INITIAL.
            FLG_KOMPL = 'X'.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF FLG_KOMPL = 'X'.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
  IF FLG_KOMPL IS INITIAL.
    CALL FUNCTION 'FIAA_FUNCTION_EXCLUDE'
      EXPORTING
        FCODE = 'KOMP'.
  ENDIF.
ENDFORM.                    "KOMPL_TESTEN

*---------------------------------------------------------------------*
*       FORM KOMPLEX_AUFLOESEN                                        *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM KOMPLEX_AUFLOESEN.

  IF ANLAV-XANLGR IS INITIAL.
    MESSAGE E421.
*    Die selektierte Anlage ist kein Komplex.
  ENDIF.
  SUBMIT RAKOMP_ALV01 AND RETURN                            "> 961989
                  WITH BUKRS EQ ANLAV-BUKRS SIGN 'I'
                  WITH ANLAGE EQ ANLAV-ANLN1 SIGN 'I'
                  WITH BEREICH1 EQ BEREICH1
                  WITH BERDATUM EQ BERDATUM
                  WITH SRTVR EQ SRTVR.
ENDFORM.                    "KOMPLEX_AUFLOESEN



* Anlagennummer aus Hide-Bereich in die Sel-Optiontabelle füllen.
FORM ANLAGE_FUELLEN TABLES IT_SEL    STRUCTURE RSTISEL
                           IT_FIELDS STRUCTURE RSTIFIELDS.

*   Anlagenhauptnummer füllen.
  PERFORM SELOPTIONS_EINTRAG TABLES IT_SEL
                                    IT_FIELDS
                             USING  'ANLAGE' 'ANLAV'
                                    'ANLN1' ANLAV-ANLN1.
*   Anlagenunternummer.
  PERFORM SELOPTIONS_EINTRAG TABLES IT_SEL
                                    IT_FIELDS
                             USING  'UNTNR' 'ANLAV'
                                    'ANLN2' ANLAV-ANLN2.
*   Buchungskreis.
  PERFORM SELOPTIONS_EINTRAG TABLES IT_SEL
                                    IT_FIELDS
                             USING  'BUKRS' 'ANLAV'
                                    'BUKRS' ANLAV-BUKRS.

************************************************************************
* Listvariante für Bestelllisten, sollte später eliminiert werden
  DATA: L_LISTVAR LIKE T160O-LISTU.
  TABLES: T160B.


  SELECT * FROM  T160B
         WHERE  TCODE       = 'AW01'.
    L_LISTVAR = T160B-LISTU.
    EXIT.
  ENDSELECT.

  PERFORM SELOPTIONS_EINTRAG TABLES IT_SEL
                                    IT_FIELDS
                             USING  'LISTU' 'T160O'
                                    'LISTU' L_LISTVAR.
************************************************************************
ENDFORM.                    "ANLAGE_FUELLEN



*---------------------------------------------------------------------*
*       FORM SELOPTIONS_EINTRAG                                       *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  SEL_OPTS                                                      *
*  -->  VALUE(SEL_NAM)                                                *
*  -->  VALUE(SEL_VAL)                                                *
*---------------------------------------------------------------------*
FORM SELOPTIONS_EINTRAG TABLES IT_SEL     STRUCTURE RSTISEL
                               IT_FIELDS  STRUCTURE RSTIFIELDS
                        USING  VALUE(SEL_OPTNAM)
                               VALUE(SEL_TABNAM)
                               VALUE(SEL_FNAM)
                               VALUE(SEL_VAL).

* Lokaler Tabellenindex.
  DATA: L_TABIX LIKE SY-TABIX.
  DATA: WA_DFIES       TYPE DFIES,
        DDIC_TABNAME   LIKE DFIES-TABNAME,
        DDIC_FIELDNAME LIKE DFIES-LFIELDNAME.

* Eintrag aus Tabelle it_sel genau spezifizieren.
  READ TABLE IT_SEL WITH KEY FIELD = SEL_OPTNAM.
  IF SY-SUBRC = 0.
    CLEAR: IT_SEL-HIGH.
    IT_SEL-LOW    = SEL_VAL.
    IT_SEL-SIGN   = 'I'.
    IT_SEL-OPTION = 'EQ'.
    MODIFY IT_SEL INDEX SY-TABIX.
    L_TABIX = SY-TABIX + 1.
    LOOP AT IT_SEL FROM L_TABIX
        WHERE FIELD = SEL_OPTNAM.
      DELETE IT_SEL.
    ENDLOOP.
* Eintrag noch nicht vorhanden.
  ELSE.
    CLEAR: IT_SEL.
    IT_SEL-FIELD  = SEL_OPTNAM.
    IT_SEL-LOW    = SEL_VAL.
    IT_SEL-SIGN   = 'I'.
    IT_SEL-OPTION = 'EQ'.
    APPEND IT_SEL.
*   Namen einfügen
    READ TABLE IT_FIELDS WITH KEY FIELD = SEL_OPTNAM.
    IF SY-SUBRC <> 0.
      DDIC_TABNAME   = SEL_TABNAM.
      DDIC_FIELDNAME = SEL_FNAM.
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          TABNAME    = DDIC_TABNAME
          LFIELDNAME = DDIC_FIELDNAME
        IMPORTING
          DFIES_WA   = WA_DFIES
        EXCEPTIONS
          OTHERS     = 0.

      IT_FIELDS-DOMNAME  = WA_DFIES-DOMNAME.             " Domäne
      IT_FIELDS-ROLLNAME = WA_DFIES-ROLLNAME.            " Datenelement
      IT_FIELDS-FIELD = SEL_OPTNAM.    " Feldname
      IT_FIELDS-KIND  = 'S'.           " Selectoption
      APPEND IT_FIELDS.
    ENDIF.
  ENDIF.

ENDFORM.                    "SELOPTIONS_EINTRAG

*---------------------------------------------------------------------*
*       FORM BBS_VERARBEITEN                                          *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM BBS_VERARBEITEN.
  DATA: HLP_LINES LIKE SY-INDEX.
  DATA: HLP_IONRA LIKE IONRA.
  DATA: L_OBART           LIKE IONRA-OBART,
        L_MEASURE         LIKE IMCEM-MEASURE,
        L_AUFNR_LOW       LIKE AUFK-AUFNR,
        L_AUFNR_HIGH      LIKE AUFK-AUFNR,
        L_PS_POSID_LOW    LIKE PRPS-POSID,
        L_PS_POSID_HIGH   LIKE PRPS-POSID.


* Verarbeitung der übergebenen Projekte. Konvertierung von externen
* zur internen Projektnummer.
  REFRESH POSNR.

* Verarbeitung allgemeine Maßnahmennummer.
  LOOP AT MEASURE.

    L_MEASURE = MEASURE-LOW.
    CALL FUNCTION 'AIC0_MEASURE_SPLIT'
      EXPORTING
        I_MEASURE  = L_MEASURE
      IMPORTING
        E_OBART    = L_OBART
        E_AUFNR    = L_AUFNR_LOW
        E_PS_POSID = L_PS_POSID_LOW.
    .
    L_MEASURE = MEASURE-HIGH.
    CALL FUNCTION 'AIC0_MEASURE_SPLIT'
      EXPORTING
        I_MEASURE  = L_MEASURE
      IMPORTING
        E_OBART    = L_OBART
        E_AUFNR    = L_AUFNR_HIGH
        E_PS_POSID = L_PS_POSID_HIGH.
    .
    CASE L_OBART.
*   Auftrag.
      WHEN 'OR'.
        EAUFN-SIGN   = MEASURE-SIGN.
        EAUFN-OPTION = MEASURE-OPTION.
        EAUFN-LOW    = L_AUFNR_LOW.
        EAUFN-HIGH   = L_AUFNR_HIGH.
        APPEND EAUFN.
*   Projekt.
      WHEN 'PR'.
        POSNR-SIGN   = MEASURE-SIGN.
        POSNR-OPTION = MEASURE-OPTION.
*       ACHTUNG: Domänenänderung von ANLAV-POSNR
*       POSNR hat ab 4.5B die Domäne PS_POSID !!!
        POSNR-LOW    = L_PS_POSID_LOW.
        POSNR-HIGH   = L_PS_POSID_HIGH.
        APPEND POSNR.

    ENDCASE.

  ENDLOOP.

  LOOP AT POSID.
    POSNR-SIGN = POSID-SIGN.
    POSNR-OPTION = POSID-OPTION.
    POSNR-LOW    = POSID-LOW   .
    POSNR-HIGH   = POSID-HIGH  .

    APPEND POSNR.
  ENDLOOP.

* Verarbeitung von allgemeiner Objektnummer
  LOOP AT OBJNR.

    CALL FUNCTION 'OBJECT_IDENTIFICATION_GET'
      EXPORTING
        OBJNR   = OBJNR-LOW
      IMPORTING
        E_IONRA = HLP_IONRA.

    CASE HLP_IONRA-OBART.
      WHEN 'OR'.
        EAUFN-SIGN = 'I'.
        EAUFN-OPTION = 'EQ'.
        EAUFN-LOW = HLP_IONRA-AUFNR.
        APPEND EAUFN.

      WHEN 'PR'.
        POSNR-SIGN = 'I'.
        POSNR-OPTION = 'EQ'.
        POSNR-LOW = HLP_IONRA-PSPNR.
        APPEND POSNR.
    ENDCASE.
  ENDLOOP.

* Parameter und Selektionsoptionen für Simulation clearen - sonst doppel
  IF SY-SUBRC EQ 0.
    REFRESH SO_PSPNR.
    CLEAR PA_POSID.
  ENDIF.

  DESCRIBE TABLE EAUFN LINES HLP_LINES.
  IF HLP_LINES GT 0.
    REFRESH SO_EAUFN.
  ENDIF.

* Buchungskreis = SPACE eliminieren.
  LOOP AT BUKRS.
    IF BUKRS-SIGN = 'I' AND BUKRS-OPTION = 'EQ'
                        AND BUKRS-LOW IS INITIAL.
      DELETE BUKRS.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "BBS_VERARBEITEN

*---------------------------------------------------------------------*
*       FORM AV_BUKRS_CHECK                                           *
*---------------------------------------------------------------------*
*   Reports über mehr als einen Buchungskreis -> keine AV's erzeugen.
*   und auch bei Summenlisten                 -> keine AV's erzeugen.
*---------------------------------------------------------------------*
FORM AV_BUKRS_CHECK.
* Summenbericht ?
  IF NOT SUMMB IS INITIAL.
*   AV's erzeugen.
    CALL FUNCTION 'FIAA_FUNCTION_EXCLUDE'
      EXPORTING
        FCODE = 'AICR'.
*   AV's ergänzen.
    CALL FUNCTION 'FIAA_FUNCTION_EXCLUDE'
      EXPORTING
        FCODE = 'AIME'.
    EXIT.
  ENDIF.


* mehrere Buchungskreise
  DESCRIBE TABLE BUKRS LINES SY-TABIX.
  IF SY-TABIX > 1.
*   AV's erzeugen.
    CALL FUNCTION 'FIAA_FUNCTION_EXCLUDE'
      EXPORTING
        FCODE = 'AICR'.
*   AV's ergänzen.
    CALL FUNCTION 'FIAA_FUNCTION_EXCLUDE'
      EXPORTING
        FCODE = 'AIME'.
  ELSE.
*   Buchungskreis mit Between angegeben.
    READ TABLE BUKRS INDEX 1.
    IF BUKRS-HIGH > BUKRS-LOW AND                         "#EC PORTABLE
       BUKRS-SIGN <> 'EQ'.
*     AV's erzeugen.
      CALL FUNCTION 'FIAA_FUNCTION_EXCLUDE'
        EXPORTING
          FCODE = 'AICR'.
*     AV's ergänzen.
      CALL FUNCTION 'FIAA_FUNCTION_EXCLUDE'
        EXPORTING
          FCODE = 'AIME'.
    ENDIF.
  ENDIF.

ENDFORM.                    "AV_BUKRS_CHECK


*---------------------------------------------------------------------*
*       FORM RSTI_SELECTION_EXIT                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  IT_FIELDRM                                                    *
*  -->  FLG_OWN_LOGIC                                                 *
*---------------------------------------------------------------------*
FORM RSTI_SELECTION_EXIT TABLES IT_FIELDRM STRUCTURE RSTIFIELDS
                        USING FLG_OWN_LOGIC.

* Bereich für BBS
  IT_FIELDRM-RFIELD = 'BEREICH1'.
  IT_FIELDRM-TRFLG = 'I'.

  IT_FIELDRM-DOMNAME = 'AFABE'.
  APPEND IT_FIELDRM.
* SUMMB
  IT_FIELDRM-RFIELD = 'SUMMB'.
  IT_FIELDRM-TRFLG = 'I'.

  IT_FIELDRM-DOMNAME = 'SUMMB'.
  APPEND IT_FIELDRM.

* XEINZL
  IT_FIELDRM-RFIELD = 'XEINZEL'.
  IT_FIELDRM-TRFLG = 'I'.

  IT_FIELDRM-DOMNAME = 'XEINZL'.
  APPEND IT_FIELDRM.

* Geschäftsjahr                                                "> 380767
  IT_FIELDRM-RFIELD  = 'SO_GNJHR'.                          "> 380767
  IT_FIELDRM-TRFLG   = 'E'.                                 "> 380767

  IT_FIELDRM-DOMNAME = 'GJAHR'.                             "> 380767
  APPEND IT_FIELDRM.                                        "> 380767

* Bei bestimmten Berichten ...
  CASE SY-REPID.
    WHEN 'RASOPO_ALV01'.        " RASOPO
*     Bereich2 und 3 für BBS AUSschalten.
*     (RASOPO kann nur einen Bereich verarbeiten)
      IT_FIELDRM-RFIELD = 'BEREICH2'.
      IT_FIELDRM-TRFLG = 'E'.

      IT_FIELDRM-DOMNAME = 'AFABE'.
      APPEND IT_FIELDRM.

      IT_FIELDRM-RFIELD = 'BEREICH3'.
      IT_FIELDRM-TRFLG = 'E'.

      IT_FIELDRM-DOMNAME = 'AFABE'.
      APPEND IT_FIELDRM.
  ENDCASE.

ENDFORM.                    "RSTI_SELECTION_EXIT

* Hier wird geprüft, ob dem ersten Schritt des Workflows zur
* Massenbearbeitung Bearbeiter zugeordnet worden sind.
* Wenn das nicht der Fall ist, kann der AV nur über
* das Programm RAWORK01 bearbeitet werden.
FORM WF_STATUS_PRUEFEN.

* WF aktiv
  CALL FUNCTION 'AM_WF_STATUS_PRUEFEN'
    IMPORTING
      E_WFACTIVE = FLG_WFAKTIV
    EXCEPTIONS
      OTHERS     = 0.
ENDFORM.                    "WF_STATUS_PRUEFEN
*&---------------------------------------------------------------------*
*&      Form  fehler_ausgeben
*&---------------------------------------------------------------------*
*       Store erroneous assets before the list output
*----------------------------------------------------------------------*
* Form routine implemented new with note 1002552
FORM STORE_ERRORS.

  FIELD-SYMBOLS: <LFS_ANFM> TYPE ANFM.

  CHECK NOT YANFM[] IS INITIAL.

* start of note 1421225
* Check message class is intial
  LOOP AT YANFM ASSIGNING <LFS_ANFM>
                WHERE ID IS INITIAL.
    <LFS_ANFM>-ID = 'AA'.
  ENDLOOP.
* end of note 1421225

  APPEND INITIAL LINE TO GT_ANFM[] ASSIGNING <LFS_ANFM>.
  <LFS_ANFM>-ID = 'AB'.
  <LFS_ANFM>-KZ = 'W'.
  <LFS_ANFM>-NR = '076'.
  <LFS_ANFM>-V1 = ANLAV-BUKRS.
  <LFS_ANFM>-V2 = ANLAV-ANLN1.
  <LFS_ANFM>-V3 = ANLAV-ANLN2.

  APPEND LINES OF YANFM[] TO GT_ANFM[].
ENDFORM.                    " store_errors
*&---------------------------------------------------------------------*
*&      Form  CHECK_SORT_SELECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->ld_select_index  text
*      -->ld_select_field  text
*      <--ld_select_not_found  text
*----------------------------------------------------------------------*
FORM CHECK_SORT_SELECT  USING    LD_SELECT_INDEX
                                 LD_SELECT_FIELD
                        CHANGING LD_SELECT_FOUND.

  CLEAR LD_SELECT_FOUND.

* select sort level from ALV list
* check sort level in selection tables in logical expressions
  IF FLG_NOT_FIRST = 1.

    CASE LD_SELECT_INDEX.
      WHEN 1.
        CHECK LD_SELECT_FIELD IN SO_SEL1.
      WHEN 2.
        CHECK LD_SELECT_FIELD IN SO_SEL2.
      WHEN 3.
        CHECK LD_SELECT_FIELD IN SO_SEL3.
      WHEN 4.
        CHECK LD_SELECT_FIELD IN SO_SEL4.
      WHEN 5.
        CHECK LD_SELECT_FIELD IN SO_SEL5.
    ENDCASE.

    LD_SELECT_FOUND = CON_X.

  ELSE.

* No check, if select sort level from ALV list
    LD_SELECT_FOUND = CON_X.

  ENDIF.

ENDFORM.                    " CHECK_SORT_SELECT
