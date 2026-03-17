*&---------------------------------------------------------------------*
*&  Include           YRASORT_ALV_DATA_FIELDCAT
*&---------------------------------------------------------------------*
* type-pool enthält Feldkatalogstruktur
TYPE-POOLS:  SLIS.

* Feldkatalog
DATA: X_FIELDCAT        TYPE SLIS_FIELDCAT_ALV,    " Zeile Feldkatalog
* Sub-Sortierung für hierarchische Listen
      T_SUBSORT         TYPE SLIS_T_SORTINFO_ALV,  " itab Sortierung
* Default Variante
      X_VARIANT         LIKE DISVARIANT.           " Anzeigevariante

CONSTANTS: NOEXPAND   VALUE 0,
           EXPAND     VALUE 1,
           OUTPUT_OFF VALUE 'X',
           OUTPUT_ON  VALUE ' '.

DATA: SUMTAB_DATA LIKE HASHED TABLE OF FIAA_SALVTAB_SUM
                  WITH UNIQUE KEY S1 S2 S3 S4 S5
                                  S1_TEXT S2_TEXT S3_TEXT S4_TEXT
                                  S5_TEXT ADD1 WAERS.

DATA: BEGIN OF SUMTAB_DATA_S OCCURS 10.
        INCLUDE STRUCTURE FIAA_SALVTAB_SUM.
*       Infotext
DATA:   TEXT(30),
        FLG_PICK_UP(1),
        HLP_LEVEL(1),
*       Sortiertexte
*       s1_text(10), s2_text(10), s3_text(10), s4_text(10), s5_text(10),
                                                                " 781218
*       Platzhalter (Sonst dumpt ALV Grid!)
        DSPACE01(1),DSPACE02(1),DSPACE03(1),DSPACE04(1),DSPACE05(1),
        DSPACE06(1),DSPACE07(1),DSPACE08(1),DSPACE09(1),DSPACE10(1),
      END OF SUMTAB_DATA_S,
      SUMLINE TYPE FIAA_SALVTAB_SUM.

DATA: TCOLLECT TYPE FIAA_SALVCOLLECT.
