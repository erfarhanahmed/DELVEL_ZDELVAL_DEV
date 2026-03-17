*&---------------------------------------------------------------------*
*&  Include           YRASORT_ALV_TOOLS
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       FORM SORT_TEXT_LESEN                                          *
*---------------------------------------------------------------------*
*       Bezeichner für die Sortierfelder ermitteln und                *
*       evtl. diese modifizieren.                                     *
*---------------------------------------------------------------------*
*  -->  VALUE(V_INDEX)   : Sortierstufe (1-5)                         *
*  -->  VALUE(FELDINHALT): Sortierfeldname                            *
*  -->  C_TEXT           : Sortierfeldbezeichner                      *
*---------------------------------------------------------------------*
FORM SORT_TEXT_LESEN USING    VALUE(V_INDEX) LIKE SY-INDEX
                     CHANGING FELDINHALT
                              C_TEXT.
* lokale Variable zum anpassen des FELDINHALT-Feldes gemäß Längenangabe
* aus der Sortiervariante
DATA: LD_FELDINHALT_TMP TYPE FELDINHALT,
      LD_C_TEXT_2       LIKE ITAB_DATA-S1_TEXT.

  READ TABLE FELD INDEX V_INDEX.
  IF SY-SUBRC EQ 0.
    IF SUMMB = 'X'.                                         "no 332180
      CLEAR ANLAV-ANLHTXT. "undefined content                no 332180
    ENDIF.                                                  "no 332180

* Für OFFSET und LÄNGE den Feldinhalt modifizieren, falls einer der
* beiden oder beide Parameter nicht initial sind. Dies wird benötigt
* damit der ALV bei OFFSET und LÄNGE in den Sortiervarianten die
* Sortierung richtig darstellen kann.
    IF FELD-FOFFSET IS INITIAL AND FELD-LAENGE IS INITIAL.
* Da keine OFFSET und LÄNGE in der Sortiervariante nun nur Text der
* Sortierstufe lesen und das wars.
      CALL FUNCTION 'AREP_FBEZ_ERMITTELN'
         EXPORTING  I_FELD     = FELD
                    I_CONTENT  = FELDINHALT
                    I_ANLAV    = ANLAV
                    I_BEREICH1 = BEREICH1
                    I_BERDAT   = BERDATUM
         IMPORTING  E_BEZ      = C_TEXT.
    ELSE.
* Da OFFSET und/oder LÄNGE einen Wert haben nun FELDINHALT modifizieren
       IF NOT FELD-FOFFSET IS INITIAL.
         SHIFT FELDINHALT BY FELD-FOFFSET PLACES.
       ENDIF.

       IF NOT FELD-LAENGE IS INITIAL.
         LD_FELDINHALT_TMP = FELDINHALT.
         MOVE LD_FELDINHALT_TMP(FELD-LAENGE) TO FELDINHALT.
       ENDIF.
* Sortierstufentext als Fragezeichen ausgeben
         C_TEXT = '?'.
    ENDIF.

  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM SORT_FELDER_VORBEREITEN                                  *
*---------------------------------------------------------------------*
*       Sortierfelder mit Texten versehen und evtl. modifizieren.     *
*---------------------------------------------------------------------*
FORM SORT_FELDER_VORBEREITEN.

* Felder zur Anzeige mit ihren Feldnamen ergänzen und modifizieren
  IF CON_SRTST >= 1.
    PERFORM SORT_TEXT_LESEN USING 1
                            CHANGING <S1> ITAB_DATA-S1_TEXT.
  ENDIF.
  IF CON_SRTST >= 2.
    PERFORM SORT_TEXT_LESEN USING 2
                            CHANGING <S2> ITAB_DATA-S2_TEXT.
  ENDIF.
  IF CON_SRTST >= 3.
    PERFORM SORT_TEXT_LESEN USING 3
                            CHANGING <S3> ITAB_DATA-S3_TEXT.
  ENDIF.
  IF CON_SRTST >= 4.
    PERFORM SORT_TEXT_LESEN USING 4
                            CHANGING <S4> ITAB_DATA-S4_TEXT.
  ENDIF.
  IF CON_SRTST >= 5.
    PERFORM SORT_TEXT_LESEN USING 5
                            CHANGING <S5> ITAB_DATA-S5_TEXT.
  ENDIF.

  IF CON_SRTST >= 1.
    ITAB_DATA-S1 = <S1>.
  ENDIF.
  IF CON_SRTST >= 2.
    ITAB_DATA-S2 = <S2>.
  ENDIF.
  IF CON_SRTST >= 3.
    ITAB_DATA-S3 = <S3>.
  ENDIF.
  IF CON_SRTST >= 4.
    ITAB_DATA-S4 = <S4>.
  ENDIF.
  IF CON_SRTST >= 5.
    ITAB_DATA-S5 = <S5>.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM SET_REF_TABLE                                            *
*---------------------------------------------------------------------*
*       Referenzfelder aus dem DDIC in die Sortierfelder des          *
*       Feldkataloges eintragen (inklusive Konvertierungsexit).
*---------------------------------------------------------------------*
*  -->  FELD          : Sortierfelder                                 *
*  -->  VALUE(V_INDEX): Sortierfeldindex                              *
*  -->  X_FIELD_CAT   : Feldkatalogzeile                              *
*---------------------------------------------------------------------*
FORM SET_REF_TABLE TABLES FELD           STRUCTURE FELD
                    USING VALUE(V_INDEX) LIKE SY-INDEX
                 CHANGING X_FIELD_CAT    TYPE SLIS_FIELDCAT_ALV.
  DATA: L_INDEX(1).
  DATA: DDICFELD_INFO  TYPE DFIES,
        DDIC_TABNAME   LIKE DFIES-TABNAME,
        DDIC_FIELDNAME LIKE DFIES-LFIELDNAME.
  L_INDEX = V_INDEX.

* Sortierfeld aus Tabelle FELD lesen und in Feldkatalog schreiben
  READ TABLE FELD INDEX V_INDEX.
  IF SY-SUBRC EQ 0.
* Referenz Feld-/Tabellenname aus dem DDIC eintragen
* (Die Felder im Katalog haben Dummy-Namen S1, S2, ... repräsentieren
*  aber reale Felder einer realen Tabelle im DDIC)
    X_FIELD_CAT-REF_FIELDNAME = FELD-FELDN.  " DDIC Feldname
    X_FIELD_CAT-REF_TABNAME   = FELD-TABLN.  " DDIC Tabellenname

*   Einen vorhandenen Konvertierungexit eintragen.
*   Zuerst prüfen, ob es einen gibt:
    CLEAR DDICFELD_INFO.
    DDIC_TABNAME   = FELD-TABLN.
    DDIC_FIELDNAME = FELD-FELDN.

    CALL FUNCTION 'DDIF_FIELDINFO_GET'
         EXPORTING
              TABNAME    = DDIC_TABNAME
              LFIELDNAME = DDIC_FIELDNAME
         IMPORTING
              DFIES_WA   = DDICFELD_INFO
         EXCEPTIONS
              OTHERS     = 0.

    IF DDICFELD_INFO-CONVEXIT NE SPACE.
*     Konvertierungsexit in Feldkatalog eintragen
      CONCATENATE '==' DDICFELD_INFO-CONVEXIT
             INTO X_FIELD_CAT-EDIT_MASK.
    ENDIF.

*   Das Feld festlegen in dem die Feldbeschreibung textuell abgelegt ist
*   (== Sx_TEXT)
    X_FIELD_CAT-TEXT_FIELDNAME(1) = 'S'.
    CONCATENATE X_FIELD_CAT-TEXT_FIELDNAME L_INDEX '_TEXT'
                INTO X_FIELD_CAT-TEXT_FIELDNAME.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM VARIANTEN_AUSWAHL                                        *
*---------------------------------------------------------------------*
*       Auswahl einer ALV Variante für die Liste (F4)                 *
*---------------------------------------------------------------------*
*  -->  pvari  : Variantenname                                        *
*---------------------------------------------------------------------*
FORM VARIANTEN_AUSWAHL CHANGING PVARI LIKE DISVARIANT-VARIANT.
  DATA: X_EXIT(1)  TYPE C,
        X_VARIANT  LIKE DISVARIANT,
        X_VARIANT2 LIKE DISVARIANT.

  DATA: FIELDVALUES TYPE DYNPREAD OCCURS 1 WITH HEADER LINE,
        CREPID      LIKE SY-REPID.
  CREPID = SY-REPID.
* Feld SUMMB vom Dynpro einlesen.
* (Da der PAI noch nicht durchlaufen ist!)
  CLEAR FIELDVALUES.
  REFRESH FIELDVALUES.
  MOVE: 'SUMMB' TO FIELDVALUES-FIELDNAME.
  APPEND FIELDVALUES.

  CALL FUNCTION 'DYNP_VALUES_READ'
       EXPORTING DYNAME     = CREPID
                 DYNUMB     = '1000'
       TABLES    DYNPFIELDS = FIELDVALUES
       EXCEPTIONS
                    INVALID_ABAPWORKAREA           = 1
                    INVALID_DYNPROFIELD            = 2
                    INVALID_DYNPRONAME             = 3
                    INVALID_DYNPRONUMMER           = 4
                    INVALID_REQUEST                = 5
                    NO_FIELDDESCRIPTION            = 6
                    INVALID_PARAMETER              = 7
                    UNDEFIND_ERROR                 = 8
                    DOUBLE_CONVERSION              = 9
                    STEPL_NOT_FOUND                = 10
                    OTHERS                         = 11.
  IF SY-SUBRC = 0.
    READ TABLE FIELDVALUES INDEX 1.
    SUMMB = FIELDVALUES-FIELDVALUE.
  ELSE.
    CLEAR SUMMB.
  ENDIF.
* Aktueller Reportname
  X_VARIANT-REPORT  = SY-REPID.
* ...       Variantenname
  X_VARIANT-VARIANT = PVARI.

* Anzeigevarianten für (Nicht)Summenbericht unterschiedlich!
  IF SUMMB = 'X'.
    X_VARIANT-HANDLE = 'SUMX'.
  ELSE.
    X_VARIANT-HANDLE = ''.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
       EXPORTING
            IS_VARIANT = X_VARIANT
            I_SAVE     = 'A'
       IMPORTING
            E_EXIT     = X_EXIT
            ES_VARIANT = X_VARIANT2
       EXCEPTIONS
            NOT_FOUND  = 2.
  IF SY-SUBRC = 2.
*   Keine Varianten für den Report vorhanden
    MESSAGE ID SY-MSGID TYPE 'S'      NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    IF X_EXIT = SPACE.
*     Augewählten Variantennamen übernehmen
      PVARI = X_VARIANT2-VARIANT.
    ENDIF.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM HASHSUM_COLLECTION                                       *
*---------------------------------------------------------------------*
*       Reportzeilen in einer Hashtabelle aufsummieren.               *
*---------------------------------------------------------------------*
*  -->  VALUE(LINE): Reportzeile aus der internen Tabelle             *
*---------------------------------------------------------------------*
FORM HASHSUM_COLLECTION USING VALUE(LINE) LIKE ITAB_DATA.
  MOVE-CORRESPONDING LINE TO SUMLINE.
  COLLECT SUMLINE INTO SUMTAB_DATA.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM SUMMENTABELLE_AUFBAUEN                                   *
*---------------------------------------------------------------------*
*       Hashtabelle in eine Standardtabelle übertragen.               *
*---------------------------------------------------------------------*
FORM SUMMENTABELLE_AUFBAUEN.

  LOOP AT SUMTAB_DATA INTO SUMLINE.
    MOVE-CORRESPONDING SUMLINE TO SUMTAB_DATA_S.
    SUMTAB_DATA_S-FLG_PICK_UP = 'X'.   " Summen darf man picken
    SUMTAB_DATA_S-HLP_LEVEL = CON_SRTST.      " Summenstufe merken
*   ANLAV füllen für Textbezeichner lesen
    CLEAR ANLAV.                                 "<<<0433908
    MOVE SUMTAB_DATA_S-S1 TO <S1>.
    MOVE SUMTAB_DATA_S-S2 TO <S2>.
    MOVE SUMTAB_DATA_S-S3 TO <S3>.
    MOVE SUMTAB_DATA_S-S4 TO <S4>.
    MOVE SUMTAB_DATA_S-S5 TO <S5>.

    CASE CON_SRTST.
      WHEN 1.
*        PERFORM sort_text_lesen USING 1                        "<781218
*                                CHANGING sumtab_data_s-s1      "<781218
*                                         sumtab_data_s-text.   "<781218
        SUMTAB_DATA_S-TEXT = SUMTAB_DATA_S-S1_TEXT.             "<781218
      WHEN 2.
*        PERFORM sort_text_lesen USING 2                        "<781218
*                                CHANGING sumtab_data_s-s2      "<781218
*                                         sumtab_data_s-text.   "<781218
         SUMTAB_DATA_S-TEXT = SUMTAB_DATA_S-S2_TEXT.            "<781218
      WHEN 3.
*        PERFORM sort_text_lesen USING 3                        "<781218
*                                CHANGING sumtab_data_s-s3      "<781218
*                                         sumtab_data_s-text.   "<781218
         SUMTAB_DATA_S-TEXT = SUMTAB_DATA_S-S3_TEXT.            "<781218
      WHEN 4.
*        PERFORM sort_text_lesen USING 4                        "<781218
*                                CHANGING sumtab_data_s-s4      "<781218
*                                         sumtab_data_s-text.   "<781218
         SUMTAB_DATA_S-TEXT = SUMTAB_DATA_S-S4_TEXT.            "<781218
      WHEN 5.
*        PERFORM sort_text_lesen USING 5                        "<781218
*                                CHANGING sumtab_data_s-s5      "<781218
*                                         sumtab_data_s-text.   "<781218
        SUMTAB_DATA_S-TEXT = SUMTAB_DATA_S-S5_TEXT.             "<781218
    ENDCASE.
    APPEND SUMTAB_DATA_S.
  ENDLOOP.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM felder_ausblenden                                        *
*---------------------------------------------------------------------*
*       Ausblenden eines Feldes vom Selektionsbild (mit Textfeld)     *
*---------------------------------------------------------------------*
FORM FELDER_AUSBLENDEN USING FNAME TXTNAME.
* Ausblenden Summenberichtsschalter der LDB ADA (stört!)
  LOOP AT SCREEN.
    CASE SCREEN-NAME.
      WHEN FNAME.                      " Feldame
        SCREEN-INVISIBLE = ' '.
        SCREEN-ACTIVE = '0'.
        MODIFY SCREEN.
      WHEN TXTNAME.                    " Bezeichner
        SCREEN-INVISIBLE = ' '.
        SCREEN-ACTIVE = '0'.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM tcollect_fuellen                                         *
*---------------------------------------------------------------------*
*       Füllen der Felder, die an den FB gegeben werden müssen.       *
*---------------------------------------------------------------------*
FORM TCOLLECT_FUELLEN.
  CLEAR TCOLLECT.

  MOVE-CORRESPONDING: T091C TO TCOLLECT,
                      T091S TO TCOLLECT,
                      T090U TO TCOLLECT.
* The information of the currency is needed within the function group
* FIAA_FALVREPORTS. TCOLLECT is the only information source for the
* currency passed to this function group.
  MOVE T093B-WAERS TO TCOLLECT-WAERS.                  "<< note 583578

  MOVE: SAV_GITTERTXT  TO TCOLLECT-GITTERTXT,
        SAV_SIMVARTXT  TO TCOLLECT-SIMVARTXT,
        TXT_UMVAR      TO TCOLLECT-TXT_UMVAR,
        SY-REPID       TO TCOLLECT-REPORTID,
        PA_AI_ID       TO TCOLLECT-PA_AI_ID,
        SAV_GJAHR      TO TCOLLECT-SAV_GJAHR,
        PA_TITEL       TO TCOLLECT-PA_TITEL,
        PA_MIKRO       TO TCOLLECT-PA_MIKRO,
*        pa_lssep       TO tcollect-pa_lssep,              "no 394136
        HEAD           TO TCOLLECT-LIST_TITLE,
        FLG_NOT_FIRST  TO TCOLLECT-FLG_NOT_FIRST,
        BERDATUM       TO TCOLLECT-BERDATUM,
        BEREICH1       TO TCOLLECT-BEWERTUNGSBEREICH,
        P_TABLE        TO TCOLLECT-X_TABLE_OUT.

ENDFORM.
