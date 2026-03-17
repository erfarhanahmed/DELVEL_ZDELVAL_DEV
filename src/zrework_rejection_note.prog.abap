*&---------------------------------------------------------------------*
*& Report ZREWORK_REJECTION_NOTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREWORK_REJECTION_NOTE.

TABLES: qals,lfa1,kna1.

TYPES: BEGIN OF TY_QALS,
       PRUEFLOS     TYPE QALS-PRUEFLOS,
       LAGORTVORG   TYPE QALS-LAGORTVORG,                                       " ADD BY SUPRIYA ON 28.06.2024
       MATNR        TYPE QALS-SELMATNR,
       MBLNR        TYPE QALS-MBLNR,
       LIFNR        TYPE QALS-SELLIFNR,
       HERKUNFT     TYPE QALS-HERKUNFT,
       ART          TYPE QALS-ART,
       PASTRTERM    TYPE QALS-PASTRTERM,
       PAENDTERM    TYPE QALS-PAENDTERM,
       PLNNR        TYPE QALS-PLNNR,
       KTEXTMAT     TYPE QALS-KTEXTMAT,
       ENSTEHDAT    TYPE QALS-ENSTEHDAT,
       LOSMENGE     TYPE QALS-LOSMENGE,
       MENGENEINH   TYPE QALS-MENGENEINH,
       GESSTICHPR   TYPE QALS-GESSTICHPR,
       EINHPROBE    TYPE QALS-EINHPROBE,
       END OF TY_QALS,

       BEGIN OF TY_QAMB,
       PRUEFLOS TYPE QAMB-PRUEFLOS,
       TYP      TYPE QAMB-TYP,
       MBLNR    TYPE QAMB-MBLNR,
       END OF TY_QAMB,

       BEGIN OF TY_MSEG,
       MBLNR TYPE MSEG-MBLNR,
       ZEILE TYPE MSEG-ZEILE,
       LGORT TYPE MSEG-LGORT,
       MENGE TYPE MSEG-MENGE,
       MEINS TYPE MSEG-MEINS,
       END OF TY_MSEG,

       BEGIN OF TY_LFA1,
       LIFNR TYPE LFA1-LIFNR,
       NAME1 TYPE LFA1-NAME1,
       END OF TY_LFA1,

       BEGIN OF TY_PLKO,
       PLNNR TYPE PLKO-PLNNR,
       KTEXT TYPE PLKO-KTEXT,
       END OF TY_PLKO,

       BEGIN OF TY_TQ31T,
       SPRACHE  TYPE TQ31T-SPRACHE,
       HERKUNFT TYPE TQ31T-HERKUNFT,
       HERKTXT TYPE TQ31T-HERKTXT,
       END OF TY_TQ31T,

       BEGIN OF TY_TQ30T,
*       MANDT   TYPE TQ30T-MANDT,
       SPRACHE  TYPE TQ30T-SPRACHE,
       ART TYPE TQ30T-ART,
       KURZTEXT TYPE TQ30T-KURZTEXT,
       END OF TY_TQ30T,

       BEGIN OF TY_QAVE,
       PRUEFLOS   TYPE QAVE-PRUEFLOS,
       VBEWERTUNG TYPE QAVE-VBEWERTUNG,
       VCODE      TYPE QAVE-VCODE,
       QKENNZAHL  TYPE QAVE-QKENNZAHL,
       VCODEGRP   TYPE QAVE-VCODEGRP,
       END OF TY_QAVE,

       BEGIN OF TY_QPCT,
       CODE     TYPE QPCT-CODE,
       SPRACHE  TYPE QPCT-SPRACHE,
       KURZTEXT TYPE QPCT-KURZTEXT,
       CODEGRUPPE TYPE QPCT-CODEGRUPPE,
       END OF TY_QPCT.

       TYPES : BEGIN OF t_line,
          tdformat(2) TYPE c , "Tag column
          tdline(132) TYPE c , "Text Line
        END OF t_line.

DATA:it_line     TYPE STANDARD TABLE OF t_line, "Table to store read_text data
      wa_line     TYPE t_line.

DATA: IT_QALS TYPE TABLE OF TY_QALS,
      WA_QALS TYPE         TY_QALS,

      IT_QAMB TYPE TABLE OF TY_QAMB,
      WA_QAMB TYPE          TY_QAMB,

      IT_MSEG TYPE TABLE OF TY_MSEG,
      WA_MSEG TYPE          TY_MSEG,

      IT_LFA1 TYPE TABLE OF TY_LFA1,
      WA_LFA1 TYPE          TY_LFA1,

      IT_PLKO TYPE TABLE OF TY_PLKO,
      WA_PLKO TYPE          TY_PLKO,

      IT_QGRES  TYPE TABLE OF QGRES,
      WA_QGRES  TYPE          QGRES,

      IT_TQ30T  TYPE TABLE OF TY_TQ30T,
      WA_TQ30T  TYPE          TY_TQ30T,

      IT_TQ31T  TYPE TABLE OF TY_TQ31T,
      WA_TQ31T  TYPE          TY_TQ31T,

      IT_QAVE  TYPE TABLE OF TY_QAVE,
      WA_QAVE  TYPE          TY_QAVE,

      IT_QPCT TYPE TABLE OF TY_QPCT,
      WA_QPCT TYPE          TY_QPCT,

      IT_FINAL TYPE TABLE OF ZINSP_LOT,
      WA_FINAL TYPE          ZINSP_LOT.

DATA : GV_FROMPLACE TYPE STRING.          " ADDED BY SUPRIYA ON 28.06.2024
DATA : fmname        type rs38l_fnam,
       FORMNAME TYPE TDSFNAME VALUE 'ZREWORK_REJECTION_NOTE'.
***DATA: lv_name   TYPE thead-tdname,
***      lv_lines  TYPE STANDARD TABLE OF tline,
***      wa_lines  LIKE tline,
***      ls_itmtxt  TYPE tline,
***      ls_mattxt  TYPE tline.
DATA:
       lv_clint    LIKE sy-mandt,   "Client
       lv_id       LIKE thead-tdid, "Text ID of text to be read
       lv_lang     LIKE thead-tdspras, "Language
       lv_name     LIKE thead-tdname, "Name of text to be read
       lv_object   LIKE thead-tdobject, "Object of text to be read
       lv_a(132)   TYPE c,           "local variable to store text
       lv_b(132)   TYPE c,           "local variable to store text
       lv_d(132)   TYPE c,           "local variable to store text
       lv_e(132)   TYPE c,           "local variable to store text
       lv_l(132)   TYPE c,           "local variable to store text
       lv_g(132)   TYPE c,           "local variable to store text
       lv_h(132)   TYPE c,           "local variable to store text
       lv_i(132)   TYPE c,           "local variable to store text
       lv_j(132)   TYPE c,           "local variable to store text
       lv_k(132)   TYPE c,           "local variable to store text
       lv_f(1320)  TYPE c.           "local variable to store concatenated text


lv_clint = sy-mandt. "Client
lv_lang = 'EN'.      "Language
lv_id = 'QAVE'.      "Text ID of text to be read
lv_object = 'QPRUEFLOS'. "Object of text to be read

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: P_LOT TYPE QALS-PRUEFLOS.
SELECTION-SCREEN:END OF BLOCK B1.

START-OF-SELECTION.
PERFORM GET_DATA.
CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname                 = FORMNAME
*   VARIANT                  = ' '
*   DIRECT_CALL              = ' '
 IMPORTING
   FM_NAME                  = fmname
* EXCEPTIONS
*   NO_FORM                  = 1
*   NO_FUNCTION_MODULE       = 2
*   OTHERS                   = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION fmname
  EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         =
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
*   OUTPUT_OPTIONS             =
*   USER_SETTINGS              = 'X'
    wa_final                   = wa_final
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
  tables
    it_final                   = it_final
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*BREAK PRIMUS.
SELECT PRUEFLOS
       LAGORTVORG   " ADDED BY SUPRIYA ON 28.06.2024
       MATNR
       MBLNR
       LIFNR
       HERKUNFT
       ART
       PASTRTERM
       PAENDTERM
       PLNNR
       KTEXTMAT
       ENSTEHDAT
       LOSMENGE
       MENGENEINH
       GESSTICHPR
       EINHPROBE  FROM QALS INTO TABLE IT_QALS
       WHERE PRUEFLOS = P_LOT.

IF IT_QALS IS NOT INITIAL.
  SELECT LIFNR
         NAME1 FROM LFA1 INTO TABLE IT_LFA1
         FOR ALL ENTRIES IN IT_QALS
         WHERE LIFNR = IT_QALS-LIFNR.

  SELECT PLNNR
         KTEXT FROM PLKO INTO TABLE IT_PLKO
         FOR ALL ENTRIES IN IT_QALS
         WHERE PLNNR = IT_QALS-PLNNR.

  SELECT SPRACHE
         HERKUNFT
         HERKTXT FROM TQ31T INTO TABLE IT_TQ31T
         FOR ALL ENTRIES IN IT_QALS
         WHERE HERKUNFT = IT_QALS-HERKUNFT AND SPRACHE = 'EN'.

  SELECT SPRACHE
         ART
         KURZTEXT FROM TQ30T INTO TABLE IT_TQ30T
         FOR ALL ENTRIES IN IT_QALS
         WHERE ART = IT_QALS-ART AND SPRACHE = 'EN'.

  SELECT PRUEFLOS
         VBEWERTUNG
         VCODE
         QKENNZAHL
         VCODEGRP     FROM QAVE INTO TABLE IT_QAVE
         FOR ALL ENTRIES IN IT_QALS
         WHERE PRUEFLOS = IT_QALS-PRUEFLOS.

  SELECT PRUEFLOS
         TYP
         MBLNR  FROM QAMB INTO TABLE IT_QAMB
         FOR ALL ENTRIES IN IT_QALS
         WHERE PRUEFLOS = IT_QALS-PRUEFLOS AND TYP = '3'.

ENDIF.

IF IT_QAVE IS NOT INITIAL .
  SELECT CODE
         SPRACHE
         KURZTEXT
         CODEGRUPPE FROM QPCT INTO TABLE IT_QPCT
         FOR ALL ENTRIES IN IT_QAVE
         WHERE CODE = IT_QAVE-VCODE AND CODEGRUPPE = IT_QAVE-VCODEGRP AND SPRACHE = 'EN'.

ENDIF.

IF IT_QAMB IS NOT INITIAL .

  SELECT MBLNR
         ZEILE
         LGORT
         MENGE
         MEINS  FROM MSEG INTO TABLE IT_MSEG
         FOR ALL ENTRIES IN IT_QAMB
         WHERE MBLNR = IT_QAMB-MBLNR AND ZEILE = '2'.

ENDIF.

LOOP AT IT_QALS INTO WA_QALS.
  WA_FINAL-PRUEFLOS   = WA_QALS-PRUEFLOS.
  WA_FINAL-LAGORTVORG = WA_QALS-LAGORTVORG.
  WA_FINAL-MATNR      = WA_QALS-MATNR.
  WA_FINAL-MBLNR      = WA_QALS-MBLNR.
  WA_FINAL-LIFNR      = WA_QALS-LIFNR.
  WA_FINAL-HERKUNFT   = WA_QALS-HERKUNFT.
  WA_FINAL-ART        = WA_QALS-ART.
  WA_FINAL-PASTRTERM  = WA_QALS-PASTRTERM.
  WA_FINAL-PAENDTERM  = WA_QALS-PAENDTERM.
  WA_FINAL-PLNNR      = WA_QALS-PLNNR    .
  WA_FINAL-KTEXTMAT   = WA_QALS-KTEXTMAT .
  WA_FINAL-ENSTEHDAT   = WA_QALS-ENSTEHDAT .
  WA_FINAL-LOSMENGE    = WA_QALS-LOSMENGE   .
  WA_FINAL-MENGENEINH  = WA_QALS-MENGENEINH .
  WA_FINAL-GESSTICHPR   = WA_QALS-GESSTICHPR  .
  WA_FINAL-EINHPROBE    = WA_QALS-EINHPROBE   .

READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_QALS-LIFNR.
  IF SY-SUBRC = 0.
    WA_FINAL-NAME1 = WA_LFA1-NAME1.
  ENDIF.

READ TABLE IT_PLKO INTO WA_PLKO WITH KEY PLNNR = WA_QALS-PLNNR.
  IF SY-SUBRC = 0.
    WA_FINAL-KTEXT = WA_PLKO-KTEXT.
  ENDIF.

READ TABLE IT_TQ30T INTO WA_TQ30T WITH KEY ART = WA_QALS-ART.
  IF SY-SUBRC = 0.
    WA_FINAL-KURZTEXT = WA_TQ30T-KURZTEXT.

  ENDIF.

READ TABLE IT_TQ31T INTO WA_TQ31T WITH KEY HERKUNFT = WA_QALS-HERKUNFT.
  IF SY-SUBRC = 0.
    WA_FINAL-HERKTXT = WA_TQ31T-HERKTXT.

  ENDIF.

READ TABLE IT_QAVE INTO WA_QAVE WITH KEY PRUEFLOS = WA_QALS-PRUEFLOS.
  IF SY-SUBRC = 0.
    WA_FINAL-VBEWERTUNG = WA_QAVE-VBEWERTUNG.
    WA_FINAL-VCODE      = WA_QAVE-VCODE.
    WA_FINAL-QKENNZAHL  = WA_QAVE-QKENNZAHL.
    CASE WA_FINAL-VBEWERTUNG .
      WHEN ' '.
        WA_FINAL-VALUATION = 'Not valuated'.
      WHEN 'A'.
        WA_FINAL-VALUATION = 'Accepted (OK)'.
      WHEN 'R'.
        WA_FINAL-VALUATION = 'Rejected (not OK)'.
    ENDCASE.

  ENDIF.
* BREAK PRIMUS.
READ TABLE IT_QPCT INTO WA_QPCT WITH KEY CODE = WA_QAVE-VCODE.
  IF SY-SUBRC = 0.
    WA_FINAL-CODE = WA_QPCT-CODE.
    WA_FINAL-KURZTEXT1 = WA_QPCT-KURZTEXT.

  ENDIF.

READ TABLE IT_QAMB INTO WA_QAMB WITH KEY PRUEFLOS = WA_QALS-PRUEFLOS.
*  IF .
*    WA_FINAL-MBLNR = WA_QAMB-MBLNR.
*  ENDIF.
*READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MBLNR = WA_QAMB-MBLNR LGORT = 'RM01'.
*IF  SY-SUBRC = 0.
*
*    WA_FINAL-MENGE = WA_MSEG-MENGE.
*    WA_FINAL-RM01 = WA_FINAL-RM01 + WA_MSEG-MENGE.
*
*ENDIF.

LOOP AT IT_MSEG INTO WA_MSEG.


**  CREATED BY SUPRIYA ON 28.06.2024

  IF wa_mseg-LGORT = 'SAN1'.
     WA_FINAL-GV_FROMPLACE = 'Sangavi'.
  ELSEIF wa_mseg-LGORT+0(1) = 'K'.
    WA_FINAL-GV_FROMPLACE = 'Kapurhol'.

*    IF wa_mseg-lgort = 'KRM0'.
**    wa_final-rm01_menge = wa_mseg-menge.
*     wa_final-menge = wa_mseg-menge.
     ENDIF.

   "----------SOC BY PM ON 25.06.2024 FOR KAPURHOL STOARGE LOCATON ---------"
*  IF  wa_mseg-lgort = 'RM01'OR wa_mseg-lgort = 'RJ01'OR wa_mseg-lgort = 'RWK1'OR wa_mseg-lgort = 'SCR1'
*    OR wa_mseg-lgort = 'TPI1' OR wa_mseg-lgort = 'SRN1'.
IF wa_mseg-LGORT = 'RM01' OR wa_mseg-LGORT = 'FG01' OR
     wa_mseg-LGORT = 'MCN1' OR wa_mseg-LGORT = 'PLG1' OR wa_mseg-LGORT = 'PN01'
     OR wa_mseg-LGORT = 'PRD1' OR wa_mseg-LGORT = 'RJ01'
     OR wa_mseg-LGORT = 'RWK1' OR wa_mseg-LGORT = 'TPI1' OR  wa_mseg-LGORT = 'VLD1' or wa_mseg-LGORT = 'SCR1' or wa_mseg-LGORT = 'SCN1' OR wa_mseg-LGORT = 'SRN1' .
 WA_FINAL-GV_FROMPLACE = 'Kavathe,Satara'.
    "----------EOC BY PM ON 25.06.2024 FOR KAPURHOL STOARGE LOCATON ---------"
  IF wa_mseg-lgort = 'RM01'.
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-RM01 = WA_FINAL-RM01 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'RJ01'.
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-RJ01 = WA_FINAL-RJ01 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'RWK1'.
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-RWK1 = WA_FINAL-RWK1 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'SCR1'.
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-SCR1 = WA_FINAL-SCR1 + WA_FINAL-MENGE.
   ENDIF.

*   IF wa_mseg-lgort = 'TPI1'.
   IF wa_mseg-lgort = 'SRN1'.
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
     WA_FINAL-SRN1 = WA_FINAL-SRN1 + WA_FINAL-MENGE.
*    WA_FINAL-TPI1 = WA_FINAL-TPI1 + WA_FINAL-MENGE.
   ENDIF.

*   IF wa_mseg-lgort = 'SRN1'.
   IF wa_mseg-lgort = 'TPI1'.
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-TPI1 = WA_FINAL-TPI1 + WA_FINAL-MENGE.
*    WA_FINAL-SRN1 = WA_FINAL-SRN1 + WA_FINAL-MENGE.
   ENDIF.



    "----------SOC BY PM ON 25.06.2024 FOR KAPURHOL STOARGE LOCATON ---------"
   ELSEIF  wa_mseg-LGORT+0(1) = 'K'.
   IF wa_mseg-lgort = 'KRM0'.     " ACCEPT QTY
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-RM01 = WA_FINAL-RM01 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'KRJ0'.     " REJECT QTY
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-RJ01 = WA_FINAL-RJ01 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'KRWK'.     " REWORK QTY
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-RWK1 = WA_FINAL-RWK1 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'KSCR'.     " SCRAP QTY
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-SCR1 = WA_FINAL-SCR1 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'KSRN'.     " SRN QTY
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-SRN1 = WA_FINAL-SRN1 + WA_FINAL-MENGE.
   ENDIF.

   IF wa_mseg-lgort = 'KTPI'.     " TPI Qty
    WA_FINAL-MEINS = WA_MSEG-MEINS.
    WA_FINAL-MENGE = WA_MSEG-MENGE.
    WA_FINAL-TPI1 = WA_FINAL-TPI1 + WA_FINAL-MENGE.
   ENDIF.
 ENDIF.
   "----------EOC BY PM ON 25.06.2024 FOR KAPURHOL STOARGE LOCATON ---------"

ENDLOOP.

BREAK PRIMUS.

      CONCATENATE lv_clint wa_final-prueflos 'L' INTO lv_name.

*FM to fetch reason according to inspection lot
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = lv_clint
          id                      = lv_id
          language                = lv_lang
          name                    = lv_name
          object                  = lv_object
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*   IMPORTING
*         HEADER                  =
        TABLES
          lines                   = it_line[]
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      CLEAR sy-tabix.
      LOOP AT it_line INTO wa_line.

        IF sy-tabix = '1'.
          lv_a = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '2'.
          lv_b = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '3'.
          lv_d = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '4'.
          lv_e = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '5'.
          lv_l = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '6'.
          lv_g = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '7'.
          lv_h = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '8'.
          lv_i = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '9'.
          lv_j = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '10'.
          lv_k = wa_line-tdline.
        ENDIF.

      ENDLOOP.

      CONCATENATE lv_a lv_b lv_d lv_e lv_l lv_g lv_h lv_i lv_j lv_k INTO lv_f SEPARATED BY space.
WA_FINAL-mattxt = lv_f.

******CLEAR: lv_lines, ls_mattxt.
******      REFRESH lv_lines.
******      lv_name = wa_final-PRUEFLOS.
******      CALL FUNCTION 'READ_TEXT'
******        EXPORTING
******          client                  = sy-mandt
******          id                      = 'QAVE'
******          language                = sy-langu
******          name                    = lv_name
******          object                  = 'QPRUEFLOS'
******        TABLES
******          lines                   = lv_lines
******        EXCEPTIONS
******          id                      = 1
******          language                = 2
******          name                    = 3
******          not_found               = 4
******          object                  = 5
******          reference_check         = 6
******          wrong_access_to_archive = 7
******          OTHERS                  = 8.
******      IF sy-subrc <> 0.
******* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*******         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
******      ENDIF.
******      READ TABLE lv_lines INTO ls_mattxt INDEX 1.
******
******WA_FINAL-mattxt = ls_mattxt-tdline.
APPEND WA_FINAL TO IT_FINAL.
*CLEAR:WA_FINAL.
ENDLOOP.



ENDFORM.
