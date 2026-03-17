DATA:
  LS_CONDITIONS TYPE T_CONDITIONS.
*BREAK PRIMUS.
GV_QTY = GS_ITEM-FKIMG.

CLEAR GV_KDMAT.
SELECT SINGLE KDMAT
         FROM VBAP
         INTO GV_KDMAT
         WHERE VBELN = GS_ITEM-AUBEL
         AND   POSNR = GS_ITEM-AUPOS.
CLEAR GV_STEUC.
SELECT SINGLE STEUC
            FROM MARC
            INTO GV_STEUC
            WHERE MATNR = GS_ITEM-MATNR
            and werks = 'SU01'.
CLEAR GV_SERIES.
SELECT SINGLE ZSERIES
            FROM MARA
            INTO GV_SERIES
            WHERE MATNR = GS_ITEM-MATNR.

READ TABLE GT_MAT_DESC INTO GS_MAT_DESC
           WITH KEY MATNR = GS_ITEM-MATNR.

READ TABLE GT_CONDITIONS INTO LS_CONDITIONS
              WITH KEY KPOSN = GS_ITEM-POSNR
                       KSCHL = 'ZPR0'.
IF SY-SUBRC IS INITIAL.
  GV_RATE = LS_CONDITIONS-KWERT / GS_ITEM-FKIMG.
  GV_AMT  = LS_CONDITIONS-KWERT.
  GV_BASE_AMT  = GV_BASE_AMT + LS_CONDITIONS-KWERT.
ENDIF.

"Added Sanjay
READ TABLE GT_CONDITIONS INTO LS_CONDITIONS
              WITH KEY KPOSN = GS_ITEM-POSNR
                       KSCHL = 'MWAS'.
IF SY-SUBRC IS INITIAL.
  GV_TAXRATE = LS_CONDITIONS-KWERT / GS_ITEM-FKIMG.
  GV_TAXAMT  = LS_CONDITIONS-KWERT.
*  gv_mwas  = gv_mwas + ls_conditions-kwert.
*  gv_mwas_rate = ls_conditions-kbetr / 10.
  GV_ITEM_TAX_AMT = ( GV_RATE * GV_QTY )  + GV_TAXAMT.
ELSE.
  GV_TAXRATE = 0.
  GV_TAXAMT  = 0.
*  gv_mwas  = gv_mwas + ls_conditions-kwert.
*  gv_mwas_rate = ls_conditions-kbetr / 10.
  GV_ITEM_TAX_AMT = ( GV_RATE * GV_QTY )  + GV_TAXAMT.
ENDIF.
"Ended Sanjay

GV_TOT_AMT = GV_TOT_AMT + GV_AMT.
GV_TOT_QTY = GV_TOT_QTY + GS_ITEM-FKIMG.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LV_LINES1  TYPE STANDARD TABLE OF TLINE,
      WA_LINES1 LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.

*BREAK fujiabap.
*BREAK-POINT.
CLEAR: LV_LINES, LS_MATTXT, LV_NAME,GV_ENG,GV_ARAB.
REFRESH LV_LINES.

*BREAK-POINT.
*CONCATENATE gs_item-vbeln gs_item-posnr INTO lv_name.
*CONCATENATE GS_ITEM-AUBEL GS_ITEM-AUPOS INTO LV_NAME.
*      lv_name = gs_item-vbeln.

DATA:      OBJNAME  TYPE TDOBNAME.
OBJNAME = GS_ITEM-MATNR.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'GRUN'
      language                      = 'E'
      name                          = OBJNAME
      object                        = 'MATERIAL'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = LV_LINES
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
IF NOT LV_LINES IS INITIAL.
  LOOP AT LV_LINES INTO WA_LINES.
    IF NOT WA_LINES-TDLINE IS INITIAL.
      CONCATENATE GV_ENG WA_LINES-TDLINE INTO GV_ENG SEPARATED BY SPACE.
    ENDIF.
  ENDLOOP.
  CONDENSE GV_ENG.
ENDIF.
if GV_ENG is INITIAL.
 gv_maktx = gs_mat_desc-maktx.
ENDIF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'GRUN'
      language                      = 'A'
      name                          = OBJNAME
      object                        = 'MATERIAL'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = LV_LINES1
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
IF NOT LV_LINES1 IS INITIAL.
  LOOP AT LV_LINES1 INTO WA_LINES1.
    IF NOT WA_LINES1-TDLINE IS INITIAL.
      CONCATENATE GV_ARAB WA_LINES1-TDLINE INTO GV_ARAB SEPARATED BY SPACE.
    ENDIF.
  ENDLOOP.
  CONDENSE GV_ARAB.
ENDIF.

IF GV_ARAB IS NOT INITIAL.
CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = GV_ARAB
    LANG            = 'A'
 IMPORTING
   RSTRING         = GV_ARAB
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
ENDIF.

**
**  IF sy-subrc <> 0.
***   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  ELSE.
***    DESCRIBE TABLE TEXT_LINES1.
***    IF SY-TFILL <> 0.
***      LOOP AT TEXT_LINES1 INTO WA_TEXT_LINE1.
***        CONCATENATE TXT1 WA_TEXT_LINE1-TDLINE INTO TXT1 SEPARATED BY SPACE.
***      ENDLOOP.
***    ENDIF.
**  ENDIF.
***  BREAK KANKIT.
***ENDFORM.








*CALL FUNCTION 'READ_TEXT'
*  EXPORTING
*    CLIENT                  = SY-MANDT
*    ID                      = '0001' "'0009'
*    LANGUAGE                = 'E' "'S'
*    NAME                    = LV_NAME
*    OBJECT                  = 'VBBP'
*  TABLES
*    LINES                   = LV_LINES
*  EXCEPTIONS
*    ID                      = 1
*    LANGUAGE                = 2
*    NAME                    = 3
*    NOT_FOUND               = 4
*    OBJECT                  = 5
*    REFERENCE_CHECK         = 6
*    WRONG_ACCESS_TO_ARCHIVE = 7
*    OTHERS                  = 8.
*IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ENDIF.
*IF NOT LV_LINES IS INITIAL.
*  LOOP AT LV_LINES INTO WA_LINES.
*    IF NOT WA_LINES-TDLINE IS INITIAL.
*      CONCATENATE GV_SPAN WA_LINES-TDLINE INTO GV_SPAN SEPARATED BY SPACE.
*    ENDIF.
*  ENDLOOP.
*  CONDENSE GV_SPAN.
*ENDIF.
*
*if gv_span is INITIAL.
* gv_maktx = gs_mat_desc-maktx.
*ENDIF.

*IF GV_SPAN IS INITIAL. "comitted by Awais on 03.11.2023
*IF GV_SPAN IS NOT INITIAL.
**----Added by Awais on 03.11.2023 for Long Text---*
*  DATA: LV_NAME1   TYPE THEAD-TDNAME.
*  CLEAR: LV_LINES,WA_LINES,GV_MAKTX.
*  REFRESH LV_LINES.
*  LV_NAME1 = GS_ITEM-MATNR.
*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
*      CLIENT                  = SY-MANDT
*      ID                      = 'GRUN'
*      LANGUAGE                = 'E'
*      NAME                    = LV_NAME1
*      OBJECT                  = 'MATERIAL'
*    TABLES
*      LINES                   = LV_LINES
*    EXCEPTIONS
*      ID                      = 1
*      LANGUAGE                = 2
*      NAME                    = 3
*      NOT_FOUND               = 4
*      OBJECT                  = 5
*      REFERENCE_CHECK         = 6
*      WRONG_ACCESS_TO_ARCHIVE = 7
*      OTHERS                  = 8.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*  IF LV_LINES IS NOT INITIAL.
*    LOOP AT LV_LINES INTO WA_LINES.
*      IF NOT WA_LINES-TDLINE IS INITIAL.
*        CONCATENATE GV_MAKTX WA_LINES-TDLINE INTO GV_MAKTX SEPARATED BY SPACE.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
**----Ended by Awais on 03.11.2023 for Long Text---*
** gv_maktx = gs_mat_desc-maktx.  "Comitted the short text by Awais on 03.11.2023
*ENDIF.
