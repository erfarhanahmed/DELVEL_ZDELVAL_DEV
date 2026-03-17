*----------------------------------------------------------------------*
***INCLUDE LZMGD1I03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  MODIFY_DATA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_DATA INPUT.



  DATA : LV_BOM          TYPE MARA-BOM,
         LV_ITEM         TYPE MARA-ITEM_TYPE,
         LV_NORM         TYPE MARA-NORMT,
         LV_SERIES       TYPE  MARA-ZSERIES,
         LV_SIZE         TYPE      MARA-ZSIZE,
         LV_BRAND        TYPE    MARA-BRAND,
         LV_MOC          TYPE       MARA-MOC,
         LV_TYPE         TYPE      MARA-TYPE,
         LV_ZEDS         TYPE       MARA-ZZEDS,
         LV_ZMSS         TYPE       MARA-ZZMSS,
         LV_CAP          TYPE       MARA-CAP_LEAD,
         LV_AIR_PRESSURE TYPE MARA-AIR_PRESSURE,
         LV_AIR_FAIL     TYPE MARA-AIR_FAIL,
         LV_ACTUATOR     TYPE MARA-ACTUATOR,
         LV_VERTICAL     TYPE MARA-VERTICAL,
         LV_ZPEN_ITEM    TYPE MARA-ZPEN_ITEM,
         LV_RE_PEN_ITEM  TYPE MARA-ZRE_PEN_ITEM,
         LV_DEV_STATUS   TYPE MARA-DEV_STATUS,
         LV_ZKANBAN      TYPE MARA-ZKANBAN,
         LV_QAP          TYPE MARA-QAP_NO,
         LV_REV          TYPE MARA-REV_NO,
         LV_boi          TYPE MARA-zboi,            ""ADDED BY MA ON 04.04.2024
         LV_ITEM_CLASS  TYPE MARA-ZITEM_CLASS.  "adda by supriya on 27.09.2024
*BREAK PRIMUS.
*  BREAK-POINT.
  IF MARA-NORMT IS  NOT INITIAL .

*    lv_bom = mara-normt.
    LV_BOM = MARA-BOM.
    LV_ITEM = MARA-ITEM_TYPE.
    LV_NORM = MARA-NORMT.
    LV_DEV_STATUS = MARA-DEV_STATUS.

  ELSE.
    LV_BOM = MARA-BOM.
    LV_ITEM = MARA-ITEM_TYPE.
    LV_NORM = MARA-BOM.
    LV_DEV_STATUS = MARA-DEV_STATUS.
  ENDIF.

  LV_SERIES = MARA-ZSERIES.
  LV_SIZE   =   MARA-ZSIZE.
  LV_BRAND  =  MARA-BRAND.
  LV_MOC    =   MARA-MOC.
  LV_TYPE   =   MARA-TYPE.
  LV_ZEDS  =     MARA-ZZEDS.
  LV_ZMSS  =     MARA-ZZMSS.
  LV_CAP  =     MARA-CAP_LEAD.
  LV_AIR_PRESSURE = MARA-AIR_PRESSURE.
  LV_AIR_FAIL    =  MARA-AIR_FAIL.
  LV_ACTUATOR    =  MARA-ACTUATOR.
  LV_VERTICAL    =  MARA-VERTICAL.
  LV_ZPEN_ITEM    =  MARA-ZPEN_ITEM.
  LV_RE_PEN_ITEM =  MARA-ZRE_PEN_ITEM.
  LV_DEV_STATUS = MARA-DEV_STATUS.
  LV_ZKANBAN    = MARA-ZKANBAN.
  LV_BOM = MARA-BOM.
  LV_QAP  =     MARA-QAP_NO.
  LV_REV  =     MARA-REV_NO.
  LV_boi  =     MARA-zboi.                   """ADDED BY MA ON 04.04.2024
 LV_ITEM_CLASS  = MARA-ZITEM_CLASS.  "adda by supriya on 27.09.2024
  CALL FUNCTION 'MARA_GET_SUB'
    IMPORTING
      WMARA = MARA
      XMARA = *MARA
      YMARA = LMARA.

  MARA-BOM = LV_BOM.
  MARA-DEV_STATUS = LV_DEV_STATUS.

  MARA-ITEM_TYPE = LV_ITEM.
  MARA-NORMT  = LV_BOM.

  MARA-ZSERIES       =  LV_SERIES.
  MARA-ZSIZE       =  LV_SIZE  .
  MARA-BRAND        =  LV_BRAND .
  MARA-MOC        =   LV_MOC   .
  MARA-TYPE       =   LV_TYPE  .
  MARA-ZZEDS     =   LV_ZEDS  .
  MARA-ZZMSS      =  LV_ZMSS  .
  MARA-CAP_LEAD    = LV_CAP  .
  MARA-AIR_PRESSURE    = LV_AIR_PRESSURE  .
  MARA-AIR_FAIL    = LV_AIR_FAIL  .
  MARA-ACTUATOR    = LV_ACTUATOR  .
  MARA-VERTICAL    = LV_VERTICAL  .
  MARA-ZPEN_ITEM =    LV_ZPEN_ITEM.
  MARA-ZRE_PEN_ITEM = LV_RE_PEN_ITEM.
  MARA-ZKANBAN      = LV_ZKANBAN.
  MARA-QAP_NO      = LV_QAP     .
  MARA-REV_NO       = LV_REV      .
  MARA-zboi       = LV_boi      .
  MARA-ZITEM_CLASS =  LV_ITEM_CLASS.  "adda by supriya on 27.09.2024

  CALL FUNCTION 'MARA_SET_SUB'
    EXPORTING
      WMARA = MARA.

*  BREAK PRIMUS.

  IF MARA-BOM IS INITIAL.
    MARA-ZPEN_ITEM = ' '.
    MARA-ZRE_PEN_ITEM = ' '.
  ENDIF.



ENDMODULE.
