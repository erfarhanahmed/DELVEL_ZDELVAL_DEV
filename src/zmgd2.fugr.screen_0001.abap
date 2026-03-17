PROCESS BEFORE OUTPUT.
*                      Verarbeitung vor der Ausgabe

MODULE init_sub.
  MODULE get_daten_sub.

MODULE modify_screen.
 MODULE get_data.

    MODULE set_daten_sub.

PROCESS AFTER INPUT.
*                      Verarbeitung nach der Eingabe

MODULE get_daten_sub.

CHAIN.
    FIELD: mara-BOM.
    MODULE modify_data.
    ENDCHAIN.

MODULE modify_data.

 MODULE set_daten_sub.

  PROCESS ON VALUE-REQUEST.
  field mara-BOM MODULE f4_eq.
