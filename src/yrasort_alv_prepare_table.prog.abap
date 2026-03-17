*&---------------------------------------------------------------------*
*&  Include           YRASORT_ALV_PREPARE_TABLE
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       FORM FIELDCAT_S_FIELDS_DEFINE                                 *
*---------------------------------------------------------------------*
*       Sx und Sx_TEXT Felder für den Feldkatalog definieren.
*---------------------------------------------------------------------*
*  -->  VALUE(TABNAME): Tabellenname des Feldkatalogs                 *
*  -->  COLPOS        : Zähler für die Spalten                        *
*---------------------------------------------------------------------*
FORM FIELDCAT_S_FIELDS_DEFINE USING VALUE(TABNAME).
  DATA: A(1), B(1), COUNT(1).

  IF SUMMB EQ SPACE.
    A = 'X'.   B = ' '.
  ELSE.
    A = ' '.   B = ' '.
  ENDIF.

  DO CON_SRTST TIMES.                  " con_srtst == Summenstufen
    CLEAR X_FIELDCAT.
    MOVE SY-INDEX TO COUNT.
    CONCATENATE 'S' COUNT INTO X_FIELDCAT-FIELDNAME.
    X_FIELDCAT-TABNAME   = TABNAME.
    X_FIELDCAT-NO_OUT    = A.
    X_FIELDCAT-TECH      = B.
    PERFORM SET_REF_TABLE TABLES FELD USING SY-INDEX
                                      CHANGING X_FIELDCAT.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
         EXPORTING FIELDCAT_LINE = X_FIELDCAT.

*   Bezeichner dazu
    CLEAR X_FIELDCAT.
    CONCATENATE 'S' COUNT '_TEXT' INTO X_FIELDCAT-FIELDNAME.
    X_FIELDCAT-TABNAME       = TABNAME.
    X_FIELDCAT-NO_OUT        = 'X'.
    X_FIELDCAT-TECH          = 'X'.
    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
         EXPORTING FIELDCAT_LINE = X_FIELDCAT.
  ENDDO.

ENDFORM.                               " FIELDCAT_S_FIELDS_DEFINE

*---------------------------------------------------------------------*
*       FORM FIELDCAT_USER_FIELDS_APPEND                              *
*---------------------------------------------------------------------*
*       Die definierbare Userstruktur an den Feldkatalog anhängen.    *
*---------------------------------------------------------------------*
*  -->  FCAT              : Feldkatalog                               *
*  -->  VALUE(STRUCT_NAME): Userstrukturname                          *
*  -->  VALUE(TAB_NAME)   : Tabellenname des Feldkatalogs             *
*---------------------------------------------------------------------*
FORM FIELDCAT_USER_FIELDS_APPEND USING VALUE(STRUCT_NAME)
                                       VALUE(TAB_NAME).

  DATA: TMP_FCAT TYPE SLIS_T_FIELDCAT_ALV,
        LFCAT    LIKE LINE OF TMP_FCAT.

  CHECK NOT STRUCT_NAME IS INITIAL
    AND NOT TAB_NAME    IS INITIAL.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
       EXPORTING   I_PROGRAM_NAME         = SY-CPROG
                   I_STRUCTURE_NAME       = STRUCT_NAME
       CHANGING    CT_FIELDCAT            = TMP_FCAT
       EXCEPTIONS  INCONSISTENT_INTERFACE = 1
                   PROGRAM_ERROR          = 2
                   OTHERS                 = 3
                   .

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

* Die neuen Felder nicht anzeigen aber an den aktuellen
* Feldkatalog anhängen und im Vorrat zur Verfügung stellen
  LOOP AT TMP_FCAT INTO LFCAT.
     LFCAT-TABNAME = TAB_NAME.
    LFCAT-NO_OUT = 'X'.

* da hier ein Customer Include ankommt, in dem WAERS nicht definiert
* werden kann (ist im übergeordneten Include schon definiert), wird
* beim FIELDCATALOG_MERGE der CFIELDNAME wieder gelöscht. Ohne den kann
* die Währung aber nicht korrekt ausgegeben werden.
      IF LFCAT-DATATYPE = 'CURR' AND                           "> 526282
         LFCAT-CFIELDNAME IS INITIAL.                          "> 526282
        LFCAT-CFIELDNAME = 'WAERS'.                            "> 526282
      ENDIF.                                                   "> 526282

    CALL FUNCTION 'FIAA_FIELDCAT_ADD_FIELD'
         EXPORTING FIELDCAT_LINE = LFCAT.
  ENDLOOP.
ENDFORM.                               " FIELDCAT_USER_FIELDS_APPEND

*&---------------------------------------------------------------------*
*&      Form  get_blanks_from_sort_variant
*&---------------------------------------------------------------------*
* This form routine is necessary for ALV Information System Reports
* who have more than 1 output line per asset. In group total reports
* it is usual to have some value columns, and in the first of the output
* lines some additional text before the value columns. This text depends
* on the sort variant, in detail on which sort field and the count of
* sort fields. This routine now calculates how much digits there are
* used caused by the information given out in the first line per asset
* out of the sort variant.
* This routine was implemented with note 558765
*----------------------------------------------------------------------*
*      -->IT_FELD  Table with definition of the sort variant
*      <--ED_BLANKS  count of digits used by the sort variant
*----------------------------------------------------------------------*
FORM GET_BLANKS_FROM_SORT_VARIANT TABLES   IT_FELD
                                  CHANGING ED_BLANKS.

DATA: LT_DFIES     TYPE TABLE OF DFIES.
DATA: LS_DFIES     TYPE DFIES.
DATA: LD_TABNAME   TYPE DDOBJNAME.
DATA: LD_FIELDNAME TYPE DFIES-FIELDNAME.
DATA: LD_LINES     TYPE SY-TABIX.

* Die Spalten der ersten Ausgabezeile verschieben sich individuell, je
* nach Art und Ausgabelänge der Sortierfelder. Deshalb wird hier
* ausgelesen, bei welcher Spalte die Betragsfelder anfangen.
  LOOP AT FELD.
    LD_TABNAME = FELD-TABLN.
    LD_FIELDNAME = FELD-FELDN.
    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING
        TABNAME              = LD_TABNAME
        FIELDNAME            = LD_FIELDNAME
        ALL_TYPES            = 'X'
      TABLES
        DFIES_TAB            = LT_DFIES
      EXCEPTIONS
        NOT_FOUND            = 1
        INTERNAL_ERROR       = 2
        OTHERS               = 3.

*   Hier aufsummieren wie sich die Ausgabelänge der Sortierfelder
*   zusammensetzt
    READ TABLE LT_DFIES INDEX 1 INTO LS_DFIES.
    ADD LS_DFIES-OUTPUTLEN TO ED_BLANKS.
  ENDLOOP.

* Je nach Anzahl der Summenstufen wird auf der Ausgabeliste eine Anzahl
* von '*'-Zeichen vor der entsprechenden Summenstufe vorangestellt.
* Deshalb muß zusätzlich zu den Sortierfeldern noch die Anzahl der
* Sterne berücksichtigt werden. Standardmässig werden auch noch 30
* Leerzeichen in der ersten Zeile ausgegeben, diese auch noch
* berücksichtigen.
  DESCRIBE TABLE IT_FELD LINES LD_LINES.
  ED_BLANKS = ED_BLANKS + LD_LINES.

ENDFORM.                    " get_blanks_from_sort_variant
