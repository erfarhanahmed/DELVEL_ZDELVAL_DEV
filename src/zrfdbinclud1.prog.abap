*&---------------------------------------------------------------------*
*&  Include           ZRFDBINCLUD1
*&---------------------------------------------------------------------*

***INCLUDE RFDBINCLUD1 .
*die Form Routine hier sind hauptsächlich für die Feldselektion
DATA: X_FIELDS LIKE RSFS_STRUC OCCURS 10.
*---------------------------------------------------------------------*
*       FORM ADD_FIELD_TO_TABLE                                       *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  TAB_NAM                                                       *
*  -->  FIELD_NAM                                                     *
*---------------------------------------------------------------------*
FORM ADD_FIELD_TO_TABLE TABLES TAB_NAM USING FIELD_NAM.
  READ TABLE TAB_NAM INTO TEST_FIELDS WITH KEY FIELD_NAM.
  IF SY-SUBRC NE 0.
    APPEND FIELD_NAM TO TAB_NAM.
  ENDIF.
ENDFORM.

FORM ADD_AUTH_CHECK_FIELDS TABLES XSEG_FIELDS USING ZTABNAM.
  IF ZTABNAM EQ 'BSID' OR ZTABNAM EQ 'BSIK' OR ZTABNAM EQ 'BSIS'.
     PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'BLART'.
     PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'GSBER'.
  ENDIF.
   IF ZTABNAM EQ 'BKPF'.
      PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'BLART'.
      PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'WAERS'.
   ENDIF.
   IF ZTABNAM EQ 'BSEG'.
      PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'GSBER'.
   ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM ADD_BSEGA_FIELDS                                         *
*---------------------------------------------------------------------*
*  Felder für BSEGA in die Feldliste aufnehmen wegen Feldselektion    *
*---------------------------------------------------------------------*
*  -->  XSEG_FIELDS                                                   *
*  -->  ZTABNAM                                                       *
*---------------------------------------------------------------------*
FORM ADD_BSEGA_FIELDS TABLES XSEG_FIELDS USING ZTABNAM.
*-- die Felder für die Berechnung von BSEGA in Feldleiste aufnehmen.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'SHKZG'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'DMBTR'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'WRBTR'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'MWSTS'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'WMWST'.
  IF ZTABNAM EQ 'BSEG'.
*   PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'FDBTR'.
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'BLNBT'.
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'MENGE'.
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'KOART'.
  ENDIF.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'ZFBDT'.
  IF ZTABNAM NE 'BSEG'.
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'BLDAT'.
  ENDIF.
  IF ZTABNAM NE 'BSIS'.
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'REBZG'. "<-31G
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'ZBD3T'.
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'ZBD2T'.
    PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'ZBD1T'.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM ADD_KEY_FIELDS_TO_GSEG                                   *
*---------------------------------------------------------------------*
*  add key fields to the field list of the structure GSEG             *
*---------------------------------------------------------------------*
*  -->  XSEG_FIELDS                                                   *
*---------------------------------------------------------------------*
FORM ADD_KEY_FIELDS_TO_GSEG TABLES  XSEG_FIELDS.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'MANDT'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'BUKRS'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'BELNR'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'GJAHR'.
  PERFORM ADD_FIELD_TO_TABLE TABLES XSEG_FIELDS USING 'BUZEI'.
ENDFORM.


*---------------------------------------------------------------------*
*       FORM DEL_FIELDS_NOT_EXIST_IN_VIEW                             *
*---------------------------------------------------------------------*
* x_fields : Felder für die Feldselektion
* Viewnam: Name eines Views
* Ztabnam: unterschiedliche Behandlung bei LFA1_fields, LFB1_fields
* und VF_KRED_fields. Bei VF_kred_fields werden die Fedler gelöscht.
* Bei LFA1_fields und LFB1_fields aber nicht, nur message wird
* ausgegeben.
*---------------------------------------------------------------------*
FORM DEL_FIELDS_NOT_EXIST_IN_VIEW TABLES X_FIELDS
                                     USING VIEWNAM ZTABNAM.

  DATA: Y_FIELDS LIKE RSFS_STRUC OCCURS 10 WITH HEADER LINE.

  LOOP AT X_FIELDS INTO Y_FIELDS-LINE.
    IF ZTABNAM EQ 'KNB1' OR ZTABNAM EQ 'LFB1'.
      REPLACE 'SPERR' WITH 'SPERR_B' INTO Y_FIELDS-LINE.
      REPLACE 'LOEVM' WITH 'LOEVM_B' INTO Y_FIELDS-LINE.
      REPLACE 'BEGRU' WITH 'BEGRU_B' INTO Y_FIELDS-LINE.
      REPLACE 'ERDAT' WITH 'ERDAT_B' INTO Y_FIELDS-LINE.
      REPLACE 'ERNAM' WITH 'ERNAM_B' INTO Y_FIELDS-LINE.
      REPLACE 'NODEL' WITH 'NODEL_B' INTO Y_FIELDS-LINE.
      REPLACE 'CONFS' WITH 'CONFS_B' INTO Y_FIELDS-LINE.
      REPLACE 'UPDAT' WITH 'UPDAT_B' INTO Y_FIELDS-LINE.
      REPLACE 'UPTIM' WITH 'UPTIM_B' INTO Y_FIELDS-LINE.
    ENDIF.
    SELECT SINGLE * FROM DD03L
         WHERE   TABNAME = VIEWNAM
         AND   FIELDNAME = Y_FIELDS-LINE
         AND   AS4LOCAL  = 'A'
         AND   AS4VERS   = '0000'.
    IF SY-SUBRC NE 0.
      IF ZTABNAM = 'VF_DEBI' OR ZTABNAM = 'VF_KRED'.
        DELETE X_FIELDS.
      ENDIF.
      WRITE: / Y_FIELDS-LINE, TEXT-014, VIEWNAM, TEXT-015.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM COMBINE_FSEL_TAB1_TO_TAB2 TABLES TAB1 TAB2 USING TABNAM.
 DATA: Y_FIELDS LIKE RSFS_STRUC OCCURS 10 WITH HEADER LINE.
  LOOP AT TAB1 INTO Y_FIELDS-LINE.
    SELECT SINGLE * FROM DD03L
         WHERE   TABNAME = TABNAM
         AND   FIELDNAME = Y_FIELDS-LINE
         AND   AS4LOCAL  = 'A'
         AND   AS4VERS   = '0000'.
    IF SY-SUBRC EQ 0.
       APPEND Y_FIELDS-LINE TO TAB2.
    ENDIF.
  ENDLOOP.
  SORT TAB2[].
  DELETE ADJACENT DUPLICATES FROM TAB2[].
ENDFORM.


FORM PUTZEN_BSEGH TABLES XSEG_FIELDS.
  READ TABLE XSEG_FIELDS INTO TEST_FIELDS WITH KEY 'FDBTR'.
  IF SY-SUBRC NE 0.
    CLEAR BSEGH-FDBTR.
  ENDIF.
  READ TABLE XSEG_FIELDS INTO TEST_FIELDS WITH KEY 'BLNBT'.
  IF SY-SUBRC NE 0.
    CLEAR BSEGH-BLNBT.
  ENDIF.
  READ TABLE XSEG_FIELDS INTO TEST_FIELDS WITH KEY 'MENGE'.
  IF SY-SUBRC NE 0.
    CLEAR BSEGH-MENGE.
  ENDIF.
ENDFORM.

*-----------------------------------------------------------------------
* Feldselektion für View wird aus der Feldselektion für tabelle A und B
* aufgebaut
*-----------------------------------------------------------------------
FORM FSEL_FOR_VIEW TABLES  TAB_A    LIKE X_FIELDS
                           TAB_B    LIKE X_FIELDS
                           TAB_VIEW LIKE X_FIELDS
                   USING XASGL TABNAM_A TABNAM_B VIEWNAM.

  DATA: A_FIELDS_LINE LIKE SY-TFILL,
        B_FIELDS_LINE LIKE SY-TFILL.

  DESCRIBE TABLE TAB_A LINES A_FIELDS_LINE.
  DESCRIBE TABLE TAB_B LINES B_FIELDS_LINE.

 IF A_FIELDS_LINE > 0 AND B_FIELDS_LINE > 0.
*----A-Segment Felder in View kopieren --------------------------------
    LOOP AT TAB_A INTO TAB_VIEW-LINE.
      APPEND TAB_VIEW.
    ENDLOOP.
*----B-Segment Felder in View kopieren --------------------------------
*--- Feldname in B-Segmente mit Feldname in View austauschen----------
    LOOP AT TAB_B INTO TAB_VIEW.
      REPLACE 'SPERR' WITH 'SPERR_B' INTO TAB_VIEW-LINE.
      REPLACE 'LOEVM' WITH 'LOEVM_B' INTO TAB_VIEW-LINE.
      REPLACE 'BEGRU' WITH 'BEGRU_B' INTO TAB_VIEW-LINE.
      REPLACE 'ERDAT' WITH 'ERDAT_B' INTO TAB_VIEW-LINE.
      REPLACE 'ERNAM' WITH 'ERNAM_B' INTO TAB_VIEW-LINE.
      REPLACE 'NODEL' WITH 'NODEL_B' INTO TAB_VIEW-LINE.
      REPLACE 'CONFS' WITH 'CONFS_B' INTO TAB_VIEW-LINE.
      REPLACE 'UPDAT' WITH 'UPDAT_B' INTO TAB_VIEW-LINE.
      REPLACE 'UPTIM' WITH 'UPTIM_B' INTO TAB_VIEW-LINE.
      APPEND TAB_VIEW.
    ENDLOOP.

    SORT TAB_VIEW[].
    DELETE ADJACENT DUPLICATES FROM TAB_VIEW.
*--- für Felder, die nicht in View vorhanden sind, Warnung ausgeben----
    IF XASGL NE 'X'.
        PERFORM DEL_FIELDS_NOT_EXIST_IN_VIEW
              TABLES TAB_VIEW USING VIEWNAM VIEWNAM.
    ENDIF.

  ELSE.
    REFRESH TAB_VIEW.
    CLEAR TAB_VIEW.
    IF XASGL NE 'X'.
*--- für Felder, die nicht in View vorhanden sind, Warnung ausgeben----
        IF A_FIELDS_LINE > 0.
          PERFORM DEL_FIELDS_NOT_EXIST_IN_VIEW
                TABLES TAB_A USING VIEWNAM TABNAM_A.
        ENDIF.
        IF B_FIELDS_LINE > 0.
          PERFORM DEL_FIELDS_NOT_EXIST_IN_VIEW
                TABLES TAB_B USING VIEWNAM TABNAM_B.
        ENDIF.
    ENDIF.

  ENDIF.                               "<-- Feldsel. View
ENDFORM.
