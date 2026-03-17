*&---------------------------------------------------------------------*
*& Report ZQM_QA12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZQM_QA12.
TYPES:
  T_MKPF_TAB  LIKE MKPF  OCCURS 0,
  T_MSEG_TAB  LIKE MSEG  OCCURS 0.
PARAMETERS:
  PRUEFLOS LIKE QALS-PRUEFLOS OBLIGATORY MEMORY ID QLS.
DATA:
  G_MSGV1       LIKE SY-MSGV1,
  G_QALS        LIKE QALS,
  G_QALS_LEISTE LIKE QALS,
  G_QAMB_TAB    TYPE QAMBTAB,
  G_QAMB_VB_TAB TYPE QAMBTAB,
  G_MKPF_TAB    TYPE T_MKPF_TAB,
  G_MSEG_TAB    TYPE T_MSEG_TAB,
  G_SUBRC       LIKE SY-SUBRC.
START-OF-SELECTION.
  PERFORM ENQUEUE_QALS USING PRUEFLOS
                             G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM READ_QALS USING PRUEFLOS
                          G_QALS
                          G_QALS_LEISTE
                          G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID 'QA' TYPE 'S' NUMBER '102'
            WITH PRUEFLOS.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM CHECK_LOT USING G_QALS
                          G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    CASE G_SUBRC.
      WHEN 256.
        G_MSGV1 = 'Lot & does not refer to a material doc'.
      WHEN 128.
        G_MSGV1 = 'Material & is serialized'.
        REPLACE '&' WITH G_QALS-MATNR INTO G_MSGV1.
      WHEN  64.
        G_MSGV1 = 'Lot & is not stock relevant'.
      WHEN  32.
        G_MSGV1 = 'Lot &: No stock transferred'.
      WHEN  16.
        G_MSGV1 = 'Lot & is cancelled'.
      WHEN   8.
        G_MSGV1 = 'Lot & is archived'.
      WHEN   4.
        G_MSGV1 = 'Lot & is blocked'.
      WHEN   2.
        G_MSGV1 = 'Lot & is HU managed'.
    ENDCASE.
    REPLACE '&' WITH PRUEFLOS INTO G_MSGV1.
    MESSAGE ID '00' TYPE 'S' NUMBER '208'
            WITH G_MSGV1.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM READ_QAMB USING G_QALS
                          G_QAMB_TAB
                          G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID 'QA' TYPE 'S' NUMBER '068'
            WITH PRUEFLOS.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM READ_MKPF USING G_QAMB_TAB
                          G_MKPF_TAB
                          G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM CHECK_MKPF USING G_MKPF_TAB
                           G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID 'QA' TYPE 'S' NUMBER '068'
            WITH PRUEFLOS.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM READ_MSEG USING G_MKPF_TAB
                          G_MSEG_TAB
                          G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM CHECK_MSEG USING G_MSEG_TAB
                           G_QAMB_TAB
                           G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID 'QA' TYPE 'S' NUMBER '068'
            WITH PRUEFLOS.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM CREATE_GOODS_MOVEMENT USING G_QALS
                                      G_MSEG_TAB
                                      G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID 'QA' TYPE 'S' NUMBER '068'
            WITH PRUEFLOS.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
  PERFORM POST_GOODS_MOVEMENT.
  PERFORM POST_DATA USING G_QALS
                          G_QALS_LEISTE
                          G_QAMB_TAB
                          G_QAMB_VB_TAB
                          G_SUBRC.
  IF NOT G_SUBRC IS INITIAL.
    MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ELSE.
    COMMIT WORK AND WAIT.
    G_MSGV1 = 'inspection lot &'.
    REPLACE '&' WITH PRUEFLOS INTO G_MSGV1.
    MESSAGE ID '00' TYPE 'S' NUMBER '368'
            WITH 'Stock posting reversed for ' G_MSGV1.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
*----------------------------------------------------------------------*
*       Form  ENQUEUE_QALS                                             *
*----------------------------------------------------------------------*
*       Los sperren                                                    *
*----------------------------------------------------------------------*
FORM ENQUEUE_QALS USING P_PRUEFLOS LIKE QALS-PRUEFLOS
                        P_SUBRC    LIKE SY-SUBRC.
  CLEAR: P_SUBRC.
  CALL FUNCTION 'ENQUEUE_EQQALS1'
       EXPORTING
            PRUEFLOS       = P_PRUEFLOS
       EXCEPTIONS
            FOREIGN_LOCK   = 1
            SYSTEM_FAILURE = 2
            OTHERS         = 3.
  P_SUBRC = SY-SUBRC.
ENDFORM.                               " ENQUEUE_QALS
*----------------------------------------------------------------------*
*       Form  READ_QALS                                                *
*----------------------------------------------------------------------*
*       Prüflos lesen                                                  *
*----------------------------------------------------------------------*
FORM READ_QALS USING P_PRUEFLOS    LIKE QALS-PRUEFLOS
                     P_QALS        LIKE QALS
                     P_QALS_LEISTE LIKE QALS
                     P_SUBRC       LIKE SY-SUBRC.
  CLEAR: P_SUBRC.
  CALL FUNCTION 'QPSE_LOT_READ'
       EXPORTING
            I_PRUEFLOS  = P_PRUEFLOS
            I_RESET_LOT = 'X'
       IMPORTING
            E_QALS      = P_QALS
       EXCEPTIONS
            NO_LOT      = 1.
  P_SUBRC = SY-SUBRC.
  IF P_SUBRC IS INITIAL.
    P_QALS_LEISTE = P_QALS.
  ELSE.
    CLEAR: P_QALS,
           P_QALS_LEISTE.
  ENDIF.
ENDFORM.                               " READ_QALS
*----------------------------------------------------------------------*
*       Form  CHECK_LOT                                                *
*----------------------------------------------------------------------*
*       Prüflos prüfen                                                 *
*----------------------------------------------------------------------*
FORM CHECK_LOT USING P_QALS  LIKE QALS
                     P_SUBRC LIKE SY-SUBRC.
  DATA:
    L_STAT      LIKE JSTAT,
    L_STAT_TAB  LIKE JSTAT OCCURS 0 WITH HEADER LINE.
  P_SUBRC = 256.
*/No reference to material document
  IF P_QALS-ZEILE IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 128.
  ENDIF.
*/Serialized Material
  IF NOT P_QALS-SERNP IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 64.
  ENDIF.
*/BERF
  CALL FUNCTION 'STATUS_CHECK'
       EXPORTING
            OBJNR             = P_QALS-OBJNR
            STATUS            = 'I0203'
       EXCEPTIONS
            STATUS_NOT_ACTIVE = 2.
  IF NOT SY-SUBRC IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 32.
  ENDIF.
*/BTEI & BEND
  CLEAR L_STAT. CLEAR L_STAT_TAB. REFRESH L_STAT_TAB.
  L_STAT-STAT = 'I0219'. APPEND L_STAT TO L_STAT_TAB. "BTEI
  L_STAT-STAT = 'I0220'. APPEND L_STAT TO L_STAT_TAB. "BEND
  CALL FUNCTION 'STATUS_OBJECT_CHECK_MULTI'
       EXPORTING
            OBJNR        = P_QALS-OBJNR
       TABLES
            STATUS_CHECK = L_STAT_TAB.
  IF L_STAT_TAB[] IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 16.
  ENDIF.
*/LSTO & LSTV
  CLEAR L_STAT. CLEAR L_STAT_TAB. REFRESH L_STAT_TAB.
  L_STAT-STAT = 'I0224'. APPEND L_STAT TO L_STAT_TAB. "LSTO
  L_STAT-STAT = 'I0232'. APPEND L_STAT TO L_STAT_TAB. "LSTV
  CALL FUNCTION 'STATUS_OBJECT_CHECK_MULTI'
       EXPORTING
            OBJNR        = P_QALS-OBJNR
       TABLES
            STATUS_CHECK = L_STAT_TAB.
  IF NOT L_STAT_TAB[] IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 8.
  ENDIF.
*/ARSP & ARCH & REO1 & REO2 & REO3
  CLEAR L_STAT. CLEAR L_STAT_TAB. REFRESH L_STAT_TAB.
  L_STAT-STAT = 'I0225'. APPEND L_STAT TO L_STAT_TAB. "ARSP
  L_STAT-STAT = 'I0226'. APPEND L_STAT TO L_STAT_TAB. "ARCH
  L_STAT-STAT = 'I0227'. APPEND L_STAT TO L_STAT_TAB. "REO3
  L_STAT-STAT = 'I0228'. APPEND L_STAT TO L_STAT_TAB. "REO2
  L_STAT-STAT = 'I0229'. APPEND L_STAT TO L_STAT_TAB. "REO1
  CALL FUNCTION 'STATUS_OBJECT_CHECK_MULTI'
       EXPORTING
            OBJNR        = P_QALS-OBJNR
       TABLES
            STATUS_CHECK = L_STAT_TAB.
  IF NOT L_STAT_TAB[] IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 4.
  ENDIF.
*/SPER
  CALL FUNCTION 'STATUS_CHECK'
       EXPORTING
            OBJNR             = P_QALS-OBJNR
            STATUS            = 'I0043'
       EXCEPTIONS
            STATUS_NOT_ACTIVE = 2.
  IF SY-SUBRC IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 2.
  ENDIF.
*/HUM
  CALL FUNCTION 'STATUS_CHECK'
       EXPORTING
            OBJNR             = P_QALS-OBJNR
            STATUS            = 'I0443'
       EXCEPTIONS
            STATUS_NOT_ACTIVE = 2.
  IF SY-SUBRC IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 0.
  ENDIF.
ENDFORM.                               " CHECK_LOT
*----------------------------------------------------------------------*
*       Form  READ_QAMB                                                *
*----------------------------------------------------------------------*
*       QAMBs lesen                                                    *
*----------------------------------------------------------------------*
FORM READ_QAMB USING P_QALS     LIKE QALS
                     P_QAMB_TAB TYPE QAMBTAB
                     P_SUBRC    LIKE SY-SUBRC.
  CLEAR: P_SUBRC.
  SELECT * FROM QAMB INTO TABLE P_QAMB_TAB
    WHERE PRUEFLOS =  P_QALS-PRUEFLOS
      AND TYP   = '3'.
  P_SUBRC = SY-SUBRC.
ENDFORM.                               " READ_QAMB
*----------------------------------------------------------------------*
*       Form  READ_MKPF                                                *
*----------------------------------------------------------------------*
*       Read material document header                                  *
*----------------------------------------------------------------------*
FORM READ_MKPF USING P_QAMB_TAB TYPE QAMBTAB
                     P_MKPF_TAB TYPE T_MKPF_TAB
                     P_SUBRC    LIKE SY-SUBRC.
  DATA:
    BEGIN OF L_MKPF_KEY_TAB OCCURS 0,
      MBLNR LIKE MKPF-MBLNR,
      MJAHR LIKE MKPF-MJAHR,
    END   OF L_MKPF_KEY_TAB.
  DATA:
    L_QAMB   LIKE QAMB,
    L_MKPF   LIKE MKPF,
    L_TRTYP  LIKE T158-TRTYP VALUE 'A',
    L_VGART  LIKE T158-VGART VALUE 'WQ',
    L_XEXIT  LIKE QM00-QKZ.
  P_SUBRC = 4.
  LOOP AT P_QAMB_TAB INTO L_QAMB.
    L_MKPF_KEY_TAB-MBLNR = L_QAMB-MBLNR.
    L_MKPF_KEY_TAB-MJAHR = L_QAMB-MJAHR.
    COLLECT L_MKPF_KEY_TAB.
  ENDLOOP.
  LOOP AT L_MKPF_KEY_TAB.
    CALL FUNCTION 'ENQUEUE_EMMKPF'
         EXPORTING
              MBLNR          = L_MKPF_KEY_TAB-MBLNR
              MJAHR          = L_MKPF_KEY_TAB-MJAHR
         EXCEPTIONS
              FOREIGN_LOCK   = 1
              SYSTEM_FAILURE = 2
              OTHERS         = 3.
    IF NOT SY-SUBRC IS INITIAL.
      L_XEXIT = 'X'.
      EXIT.
    ENDIF.
    CLEAR: L_MKPF.
    CALL FUNCTION 'MB_READ_MATERIAL_HEADER'
         EXPORTING
              MBLNR         = L_MKPF_KEY_TAB-MBLNR
              MJAHR         = L_MKPF_KEY_TAB-MJAHR
              TRTYP         = L_TRTYP
              VGART         = L_VGART
         IMPORTING
              KOPF          = L_MKPF
         EXCEPTIONS
              ERROR_MESSAGE = 1.
    IF NOT SY-SUBRC IS INITIAL.
      L_XEXIT = 'X'.
      EXIT.
    ELSE.
      APPEND L_MKPF TO P_MKPF_TAB.
    ENDIF.
  ENDLOOP.
  IF NOT L_XEXIT IS INITIAL.
    EXIT.
  ELSE.
    P_SUBRC = 0.
  ENDIF.
ENDFORM.                               " READ_MKPF
*----------------------------------------------------------------------*
*       Form  READ_MSEG                                                *
*----------------------------------------------------------------------*
*       MSEGs lesen                                                    *
*----------------------------------------------------------------------*
FORM READ_MSEG USING P_MKPF_TAB TYPE T_MKPF_TAB
                     P_MSEG_TAB TYPE T_MSEG_TAB
                     P_SUBRC    LIKE SY-SUBRC.
  DATA:
    L_MKPF     LIKE MKPF,
    L_MSEG_TAB LIKE MSEG OCCURS 0 WITH HEADER LINE,
    L_TRTYP    LIKE T158-TRTYP VALUE 'A',
    L_XEXIT    LIKE QM00-QKZ.
  P_SUBRC = 4.
  LOOP AT P_MKPF_TAB INTO L_MKPF.
    CLEAR: L_MSEG_TAB. REFRESH: L_MSEG_TAB.
    CALL FUNCTION 'MB_READ_MATERIAL_POSITION'
         EXPORTING
              MBLNR  = L_MKPF-MBLNR
              MJAHR  = L_MKPF-MJAHR
              TRTYP  = L_TRTYP
*/            ZEILB  = P_ZEILE
*/            ZEILE  = P_ZEILE
         TABLES
            SEQTAB = L_MSEG_TAB
       EXCEPTIONS
            ERROR_MESSAGE = 1.
    IF NOT SY-SUBRC IS INITIAL.
      L_XEXIT = 'X'.
      EXIT.
    ELSE.
      APPEND LINES OF L_MSEG_TAB TO P_MSEG_TAB.
    ENDIF.
  ENDLOOP.
  IF NOT L_XEXIT IS INITIAL.
    EXIT.
  ELSE.
*/  XAuto-Zeilen und Chargenzustandsänderung werden gelöscht
    DELETE P_MSEG_TAB WHERE XAUTO NE SPACE
                         OR BWART EQ '341'
                         OR BWART EQ '342'.
    P_SUBRC = 0.
  ENDIF.
ENDFORM.                               " READ_MSEG
*----------------------------------------------------------------------*
*       Form  CREATE_GOODS_MOVEMENT                                    *
*----------------------------------------------------------------------*
*       Warenbewegung anlegen                                          *
*----------------------------------------------------------------------*
FORM CREATE_GOODS_MOVEMENT USING P_QALS     LIKE QALS
                                 P_MSEG_TAB TYPE T_MSEG_TAB
                                 P_SUBRC    LIKE SY-SUBRC.
  DATA:
    L_LMENGEZUB LIKE QALS-LMENGEZUB,
    L_LMENGEGEB LIKE QALS-LMENGEZUB,
    L_MBQSS     LIKE MBQSS,
    L_IMKPF     LIKE IMKPF,
    L_IMSEG     LIKE IMSEG,
    L_IMSEG_TAB LIKE IMSEG OCCURS 1,
    L_EMKPF     LIKE EMKPF,
    L_EMSEG     LIKE EMSEG,
    L_EMSEG_TAB LIKE EMSEG OCCURS 1,
    L_MSEG      LIKE MSEG,
    L_MSEG_TAB  LIKE MSEG  OCCURS 1,
    L_TCODE     LIKE SY-TCODE VALUE 'QA11',
    L_TABIX     LIKE SY-TABIX VALUE 1,
    L_XSTBW     LIKE T156-XSTBW,
   L_VMENGE03_BWART like mseg-bwart.
  CLEAR: P_SUBRC.
*/QAMB initialisieren
  CALL FUNCTION 'QAMB_REFRESH_DATA'.
*/Kopf füllen
  L_IMKPF-BLDAT = SY-DATLO.
  L_IMKPF-BUDAT = SY-DATLO.
  L_IMKPF-BKTXT = 'Cancellation of QM UD postings'.
*/Ursprüngliche zu buchende Menge merken + inkrementieren
  L_LMENGEZUB = P_QALS-LMENGEZUB.
  L_LMENGEGEB =   P_QALS-LMENGE01
                + P_QALS-LMENGE02
                + P_QALS-LMENGE03
                + P_QALS-LMENGE04
                + P_QALS-LMENGE05
                + P_QALS-LMENGE06
                + P_QALS-LMENGE07
                + P_QALS-LMENGE08
                + P_QALS-LMENGE09.
  IF P_QALS-STAT11 is not INITIAL and P_qals-lmenge03 is not INITIAL.
    DATA ls_tq07m like tq07m.
    DATA: s_tq07m_buf LIKE tq07m OCCURS 9.
    SELECT * FROM tq07m INTO TABLE s_tq07m_buf
           WHERE feldname LIKE 'VMENGE%' .
    SORT s_tq07m_buf BY feldname ASCENDING
                        herkunft ASCENDING.
    READ TABLE s_tq07m_buf INTO ls_tq07m
                           WITH KEY feldname = 'VMENGE03'
                                    herkunft = ' ' BINARY SEARCH.
*   Binäre Suche mit Feld und Herkunft
    IF sy-subrc IS INITIAL.
      MOVE ls_tq07m-bwartwesp TO l_vmenge03_bwart.
    ENDIF.
  ENDIF.
*/Zeilen aufbauen
  L_MSEG_TAB[] = P_MSEG_TAB[].
  LOOP AT L_MSEG_TAB INTO L_MSEG.
    MOVE-CORRESPONDING L_MSEG  TO L_MBQSS.
    MOVE-CORRESPONDING L_MBQSS TO L_IMSEG.
*/  Referenzbeleg übergeben, falls Bestellnummer gefüllt
    IF NOT L_MSEG-EBELN IS INITIAL.
      MOVE: L_MSEG-LFBNR TO L_IMSEG-LFBNR,
            L_MSEG-LFBJA TO L_IMSEG-LFBJA,
            L_MSEG-LFPOS TO L_IMSEG-LFPOS.
    ENDIF.
    MOVE L_MSEG-KDAUF          TO L_IMSEG-KDAUF.
    MOVE L_MSEG-KDPOS          TO L_IMSEG-KDPOS.
    MOVE L_MSEG-PS_PSP_PNR     TO L_IMSEG-PS_PSP_PNR.
*/  Umlagerungsfelder setzen
    MOVE:
        L_MSEG-UMMAT  TO L_IMSEG-UMMAT,
        L_MSEG-UMWRK  TO L_IMSEG-UMWRK,
        L_MSEG-UMLGO  TO L_IMSEG-UMLGO,
        L_MSEG-UMCHA  TO L_IMSEG-UMCHA.
*/  Storno-Beleg setzen
    MOVE: L_MSEG-MJAHR  TO L_IMSEG-SJAHR,
          L_MSEG-MBLNR  TO L_IMSEG-SMBLN,
          L_MSEG-ZEILE  TO L_IMSEG-SMBLP.
*/  Falsch gefüllte Felder initialisieren
    CLEAR: L_IMSEG-MBLNR,
           L_IMSEG-MENGE,
           L_IMSEG-MEINS.
*/  Bewegungsart lesen
    SELECT SINGLE XSTBW FROM T156 INTO L_XSTBW
      WHERE BWART = L_IMSEG-BWART.
    IF NOT SY-SUBRC IS INITIAL.
      P_SUBRC = 4.
      EXIT.
    ENDIF.
*/  Werk/Lagerort füllen
    IF P_QALS-STAT11 IS INITIAL.
      IF L_XSTBW IS INITIAL.
        MOVE P_QALS-LAGORTVORG TO L_IMSEG-LGORT.
      ELSE.
        MOVE P_QALS-LAGORTVORG TO L_IMSEG-UMLGO.
      ENDIF.
    ENDIF.
    IF L_XSTBW IS INITIAL.
      MOVE P_QALS-WERKVORG TO L_IMSEG-WERKS.
    ELSE.
      MOVE P_QALS-WERKVORG TO L_IMSEG-UMWRK.
    ENDIF.
*/  Zusätzliche Felder
    MOVE P_QALS-MENGENEINH TO L_IMSEG-ERFME.
    "MOVE P_GRUND           TO L_IMSEG-GRUND.
    "MOVE P_ELIKZ           TO L_IMSEG-ELIKZ.
*/  Kennzeichen Storno-Buchung setzen
    MOVE 'X'               TO L_IMSEG-XSTOB.
    MOVE P_QALS-PRUEFLOS   TO L_IMSEG-QPLOS.
    APPEND L_IMSEG TO L_IMSEG_TAB.
    IF P_QALS-STAT11 IS INITIAL.
      ADD      L_IMSEG-ERFMG TO   L_LMENGEZUB.
      SUBTRACT L_IMSEG-ERFMG FROM L_LMENGEGEB.
    ELSE.
      IF  (  L_IMSEG-KZBEW EQ SPACE
         AND L_IMSEG-WERKS NE SPACE
         AND L_IMSEG-LGORT NE SPACE
         AND L_IMSEG-UMWRK NE SPACE
         AND L_IMSEG-UMLGO NE SPACE
         AND L_IMSEG-WERKS EQ L_IMSEG-UMWRK
         AND L_IMSEG-UMLGO EQ L_IMSEG-UMLGO )
        OR
          (  L_IMSEG-KZBEW EQ SPACE
         AND l_IMSEG-BWART EQ L_VMENGE03_BWART
         AND L_IMSEG-WERKS NE SPACE
         AND L_IMSEG-LGORT NE SPACE
         AND L_IMSEG-UMLGO NE SPACE
         AND L_IMSEG-UMLGO EQ L_IMSEG-UMLGO ).
*/      Dummy Buchung bei WE-Sperrbestand & Stichprobe
      ELSE.
        ADD      L_IMSEG-ERFMG TO   L_LMENGEZUB.
        SUBTRACT L_IMSEG-ERFMG FROM L_LMENGEGEB.
      ENDIF.
    ENDIF.
  ENDLOOP.
  IF NOT P_QALS-STAT11 IS INITIAL.
*/  Bei WE-Sperrbestand und Stichprobenbuchung Zeilen tauschen
    DO.
      READ TABLE L_IMSEG_TAB INDEX SY-INDEX INTO L_IMSEG.
      IF ( SY-SUBRC      IS INITIAL and
         L_IMSEG-KZBEW EQ SPACE
         AND L_IMSEG-WERKS NE SPACE
         AND L_IMSEG-LGORT NE SPACE
         AND L_IMSEG-UMWRK NE SPACE
         AND L_IMSEG-UMLGO NE SPACE
         AND L_IMSEG-WERKS EQ L_IMSEG-UMWRK
         AND L_IMSEG-UMLGO EQ L_IMSEG-UMLGO )
        OR
          ( SY-SUBRC      IS INITIAL and
         L_IMSEG-KZBEW EQ SPACE
         AND l_IMSEG-BWART EQ L_VMENGE03_BWART
         AND L_IMSEG-WERKS NE SPACE
         AND L_IMSEG-LGORT NE SPACE
         AND L_IMSEG-UMLGO NE SPACE
         AND L_IMSEG-UMLGO EQ L_IMSEG-UMLGO ).
        IF SY-TABIX NE L_TABIX.
          DELETE L_IMSEG_TAB INDEX SY-TABIX.
          INSERT L_IMSEG     INTO  L_IMSEG_TAB INDEX L_TABIX.
          L_TABIX = L_TABIX + 1.
        ELSE.
          L_TABIX = L_TABIX + 1.
          CONTINUE.
        ENDIF.
      ELSEIF SY-SUBRC IS INITIAL.
        CONTINUE.
      ELSE.
        EXIT.                          "from do
      ENDIF.
    ENDDO.
  ENDIF.
*/QM deaktivieren
  CALL FUNCTION 'QAAT_QM_ACTIVE_INACTIVE'
       EXPORTING
            AKTIV = SPACE.
*/Buchen
  CALL FUNCTION 'MB_CREATE_GOODS_MOVEMENT'
       EXPORTING
            IMKPF = L_IMKPF
            XALLP = 'X'
            XALLR = 'X'
            CTCOD = L_TCODE
            XQMCL = ' '
       IMPORTING
            EMKPF = L_EMKPF
       TABLES
            IMSEG = L_IMSEG_TAB
            EMSEG = L_EMSEG_TAB.
*/QM wieder aktivieren
  CALL FUNCTION 'QAAT_QM_ACTIVE_INACTIVE'
       EXPORTING
            AKTIV = 'X'.
*/Buchung auswerten
  IF L_EMKPF-SUBRC GT 1.
    IF L_EMKPF-MSGID NE SPACE.
*/    Fehler auf Kopfebene
      MESSAGE ID L_EMKPF-MSGID TYPE 'S'
              NUMBER L_EMKPF-MSGNO
              WITH L_EMKPF-MSGV1 L_EMKPF-MSGV2
                   L_EMKPF-MSGV3 L_EMKPF-MSGV4.
      SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
    ELSE.
*/    Fehler auf Zeilenebene (Ausgabe des ersten Fehlers)
      LOOP AT L_EMSEG_TAB INTO L_EMSEG.
        IF L_EMSEG-MSGID NE SPACE.
          MESSAGE ID L_EMSEG-MSGID TYPE 'S'
                NUMBER L_EMSEG-MSGNO
                WITH L_EMSEG-MSGV1 L_EMSEG-MSGV2
                     L_EMSEG-MSGV3 L_EMSEG-MSGV4.
          SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
  LOOP AT L_EMSEG_TAB INTO L_EMSEG.
    CALL FUNCTION 'QAMB_COLLECT_RECORD'
         EXPORTING
              LOTNUMBER   = P_QALS-PRUEFLOS
              DOCYEAR     = L_EMKPF-MJAHR
              DOCNUMBER   = L_EMKPF-MBLNR
              DOCPOSITION = L_EMSEG-MBLPO
              TYPE        = '7'.
  ENDLOOP.
*/Sonderkorrektur für Frei-An-Frei & WE-Sperr-An-We-Sperr
  IF NOT P_QALS-STAT11 IS INITIAL.
    IF P_QALS-LMENGE04 EQ L_LMENGEGEB.
      ADD      P_QALS-LMENGE04 TO   L_LMENGEZUB.
      SUBTRACT P_QALS-LMENGE04 FROM L_LMENGEGEB.
    ENDIF.
  ELSEIF P_QALS-INSMK IS INITIAL.
    IF         P_QALS-LMENGE01 GE L_LMENGEGEB
       AND NOT P_QALS-LMENGE01 IS INITIAL.
      ADD      L_LMENGEGEB     TO   L_LMENGEZUB.
      SUBTRACT L_LMENGEGEB     FROM L_LMENGEGEB.
    ENDIF.
  ENDIF.
  CLEAR: P_QALS-STAT34,
         P_QALS-MATNRNEU,
         P_QALS-CHARGNEU,
         P_QALS-LMENGE01,
         P_QALS-LMENGE02,
         P_QALS-LMENGE03,
         P_QALS-LMENGE04,
         P_QALS-LMENGE05,
         P_QALS-LMENGE06,
         P_QALS-LMENGE07,
         P_QALS-LMENGE08,
         P_QALS-LMENGE09.
  P_QALS-LMENGEZUB = L_LMENGEZUB.
  IF NOT L_LMENGEGEB IS INITIAL.
    P_SUBRC = 4.
  ENDIF.
ENDFORM.                               " CREATE_GOODS_MOVEMENT
*----------------------------------------------------------------------*
*       Form  POST_GOODS_MOVEMENT                                      *
*----------------------------------------------------------------------*
*       Warenbewegung buchen                                           *
*----------------------------------------------------------------------*
FORM POST_GOODS_MOVEMENT.
  CALL FUNCTION 'MB_POST_GOODS_MOVEMENT'.
ENDFORM.                               " POST_GOODS_MOVEMENT
*----------------------------------------------------------------------*
*       Form  POST_DATA                                                *
*----------------------------------------------------------------------*
*       QM-Daten verbuchen                                             *
*----------------------------------------------------------------------*
FORM POST_DATA USING P_QALS        LIKE QALS
                     P_QALS_LEISTE LIKE QALS
                     P_QAMB_TAB    TYPE QAMBTAB
                     P_QAMB_VB_TAB TYPE QAMBTAB
                     P_SUBRC       LIKE SY-SUBRC.
  DATA:
    L_STAT        LIKE JSTAT,
    L_STAT_TAB    LIKE JSTAT OCCURS 0,
    L_QAMB        LIKE QAMB,
    L_UPDKZ       LIKE QALSVB-UPSL VALUE 'U'.
*/QAMBs umsetzen (7 = VE-Buchung storniert)
  LOOP AT P_QAMB_TAB INTO L_QAMB.
    L_QAMB-TYP = '7'.
    APPEND L_QAMB TO P_QAMB_VB_TAB.
  ENDLOOP.
*/BERF & BTEI zurücknehmen
  CLEAR L_STAT. CLEAR L_STAT_TAB.
  L_STAT-INACT = 'X'.
  L_STAT-STAT = 'I0219'. APPEND L_STAT TO L_STAT_TAB. "BTEI
  L_STAT-STAT = 'I0220'. APPEND L_STAT TO L_STAT_TAB. "BEND
  CALL FUNCTION 'STATUS_CHANGE_INTERN'
       EXPORTING
            OBJNR         = P_QALS-OBJNR
       TABLES
            STATUS        = L_STAT_TAB
       EXCEPTIONS
            ERROR_MESSAGE = 1.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    SUBMIT (SY-REPID) VIA SELECTION-SCREEN.
  ENDIF.
*/Prüflos aktualisieren
  CALL FUNCTION 'QPL1_UPDATE_MEMORY'
       EXPORTING
            I_QALS  = P_QALS
            I_UPDKZ = L_UPDKZ.
  CALL FUNCTION 'QPL1_INSPECTION_LOTS_POSTING'
       EXPORTING
              I_MODE    = '1'.
  CALL FUNCTION 'STATUS_UPDATE_ON_COMMIT'.
*/QAMB initialisieren
  CALL FUNCTION 'QAMB_REFRESH_DATA'.
  PERFORM UPDATE_QAMB ON COMMIT.
  P_SUBRC = 0.
ENDFORM.                               " POST_DATA
*----------------------------------------------------------------------*
*       Form  UPDATE_QAMB                                              *
*----------------------------------------------------------------------*
*       Update auf QAMB                                                *
*----------------------------------------------------------------------*
FORM UPDATE_QAMB.
  CALL FUNCTION 'QEVA_QAMB_CANCEL' IN UPDATE TASK
       EXPORTING
            T_QAMB_TAB = G_QAMB_VB_TAB.
ENDFORM.                               " UPDATE_QAMB
*----------------------------------------------------------------------*
*       Form  CHECK_MSEG                                               *
*----------------------------------------------------------------------*
*       MSEGs prüfen                                                   *
*----------------------------------------------------------------------*
FORM CHECK_MSEG USING P_MSEG_TAB TYPE T_MSEG_TAB
                      P_QAMB_TAB TYPE QAMBTAB
                      P_SUBRC    LIKE SY-SUBRC.
  DATA:
    L_MSEG_STOR_TAB LIKE MSEG OCCURS 0 WITH HEADER LINE.
  CLEAR: P_SUBRC.
*/Zeilen bereits storniert?
  SELECT MBLNR MJAHR ZEILE SMBLN SJAHR SMBLP
    FROM MSEG INTO CORRESPONDING FIELDS OF TABLE L_MSEG_STOR_TAB
    FOR ALL ENTRIES IN P_MSEG_TAB
    WHERE SMBLN EQ P_MSEG_TAB-MBLNR
      AND SJAHR EQ P_MSEG_TAB-MJAHR
      AND SMBLP EQ P_MSEG_TAB-ZEILE.
  IF SY-SUBRC IS INITIAL.
    LOOP AT L_MSEG_STOR_TAB.
      DELETE P_MSEG_TAB WHERE     MBLNR = L_MSEG_STOR_TAB-SMBLN
                              AND MJAHR = L_MSEG_STOR_TAB-SJAHR
                              AND ZEILE = L_MSEG_STOR_TAB-SMBLP.
      DELETE P_QAMB_TAB WHERE     MBLNR = L_MSEG_STOR_TAB-SMBLN
                              AND MJAHR = L_MSEG_STOR_TAB-SJAHR
                              AND ZEILE = L_MSEG_STOR_TAB-SMBLP.
    ENDLOOP.
    IF P_MSEG_TAB[] IS INITIAL.
      P_SUBRC = 4.
      EXIT.
    ENDIF.
  ENDIF.
ENDFORM.                               " CHECK_MSEG
*----------------------------------------------------------------------*
*       Form  CHECK_MKPF                                               *
*----------------------------------------------------------------------*
*       Materialbelege prüfen (Wurde durch VE-Buchung Prüfllos erzeugt?*
*----------------------------------------------------------------------*
FORM CHECK_MKPF USING P_MKPF_TAB TYPE T_MKPF_TAB
                      P_SUBRC    LIKE SY-SUBRC.
  DATA:
    L_MKPF_TAB TYPE T_MKPF_TAB.
  CLEAR: P_SUBRC.
  SELECT MBLNR FROM QAMB INTO CORRESPONDING FIELDS OF TABLE L_MKPF_TAB
    FOR ALL ENTRIES IN P_MKPF_TAB
    WHERE MBLNR EQ P_MKPF_TAB-MBLNR
      AND MJAHR EQ P_MKPF_TAB-MJAHR
      AND TYP   = '1'.
  IF SY-SUBRC IS INITIAL.
    P_SUBRC = 4.
  ENDIF.
ENDFORM.                               " CHECK_MKPF
