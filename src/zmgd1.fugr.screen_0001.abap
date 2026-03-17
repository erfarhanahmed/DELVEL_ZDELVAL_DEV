
PROCESS BEFORE OUTPUT.
*                      Verarbeitung vor der Ausgabe
  MODULE INIT_SUB.
  MODULE GET_DATEN_SUB.
  MODULE DISPLAY_DATA.
  MODULE GET_DATA.
  MODULE SET_DATEN_SUB.
  MODULE ZBOI_DATA.
*  MODULE ZITEM_CLASS_DATA."added by supriya
*    CHAIN.
*      FIELD MARA-ZITEM_CLASS MODULE ZITEM_CLASS.
*    ENDCHAIN.
PROCESS AFTER INPUT.
  MODULE GET_DATEN_SUB.


  CHAIN.
    FIELD: MARA-ZSERIES,
           MARA-ZSIZE,
           MARA-BRAND,
           MARA-MOC,
           MARA-TYPE,
           MARA-ZZEDS,
           MARA-ZZMSS,
           MARA-CAP_LEAD,
           MARA-ZBOI,               ""ADDDED MA ON 04.04.2024
           MARA-QAP_NO,
           MARA-REV_NO,
           MARA-BOM,
           MARA-DEV_STATUS,
           MARA-ITEM_TYPE,
           MARA-AIR_PRESSURE,
           MARA-AIR_FAIL,
           MARA-ACTUATOR,
           MARA-VERTICAL,
           MARA-ZPEN_ITEM,
           MARA-ZRE_PEN_ITEM,
           MARA-ZKANBAN,
           MARA-ZITEM_CLASS.      " ADD BY SUPRIYA ON 27.09.2024
    MODULE GET_DATA.
    module zboi_new.
  ENDCHAIN.


  MODULE MODIFY_DATA.

  MODULE SET_DATEN_SUB.

CHAIN.
      FIELD MARA-ZITEM_CLASS MODULE ZITEM_CLASS.
   "ADD BY SUPRIYA ON 04.11.2024
    ENDCHAIN.


PROCESS ON VALUE-REQUEST .
  FIELD MARA-BOM MODULE F4_EQ.
*  field mara-zboi MODULE f4_eq_new.

*FIELD MARA-ZITEM_CLASS MODULE F4_EQ.
*    process ON VALUE-REQUEST.
  FIELD MARA-DEV_STATUS MODULE F4_EQ1.

*                      Verarbeitung nach der Eingabe

***************
