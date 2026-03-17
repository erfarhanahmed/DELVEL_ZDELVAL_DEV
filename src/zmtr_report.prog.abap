*&---------------------------------------------------------------------*
*& Report ZMTR_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMTR_REPORT.

TYPE-POOLS: slis.
TABLES: VBAK,KNA1,AFPO,VBAP,AFKO,AFRU.

TYPES : BEGIN OF TY_AUFK,
          AUFNR TYPE AUFK-AUFNR,
          AUART TYPE AUFK-AUART,
          ERDAT TYPE AUFK-ERDAT,
        END OF TY_AUFK,

        BEGIN OF TY_AFKO,
          AUFNR TYPE AFKO-AUFNR,
          GAMNG TYPE AFKO-GAMNG,
          RMANR TYPE AFKO-RMANR,
          GLTRI TYPE AFKO-GLTRI,
        END OF TY_AFKO,

        BEGIN OF TY_AFPO,
          AUFNR TYPE AFPO-AUFNR,
          WEMNG TYPE AFPO-WEMNG,
          KDAUF TYPE AFPO-KDAUF,
          KDPOS TYPE AFPO-KDPOS,
        END OF TY_AFPO,

        BEGIN OF TY_AFRU,
          AUFNR TYPE AFRU-AUFNR,
          BUDAT TYPE AFRU-BUDAT,
          RMZHL TYPE AFRU-RMZHL,
        END OF TY_AFRU,

        BEGIN OF TY_VBAK,
          VBELN TYPE VBAK-VBELN,
          AUFNR TYPE VBAK-AUFNR,
          AUART TYPE VBAK-AUART,
          KUNNR TYPE VBAK-KUNNR,
          AUDAT TYPE VBAK-AUDAT,
          VKBUR TYPE VBAK-VKBUR,
        END OF TY_VBAK,

        BEGIN OF TY_VBAP,
          VBELN TYPE VBAP-VBELN,
          POSNR TYPE VBAP-POSNR,
          MATNR TYPE VBAP-MATNR,
        END OF TY_VBAP,

        BEGIN OF TY_VBKD,
          VBELN TYPE VBKD-VBELN,
          BSTKD TYPE VBKD-BSTKD,
          BSTDK TYPE VBKD-BSTDK,
        END OF TY_VBKD,

        BEGIN OF TY_MARA,
          MATNR TYPE MARA-MATNR,
          BRAND TYPE MARA-BRAND,
          ZSIZE TYPE MARA-ZSIZE,
          MOC   TYPE MARA-MOC,
          TYPE  TYPE MARA-TYPE,
          ZSERIES TYPE MARA-ZSERIES,
        END OF TY_MARA,

        BEGIN OF TY_KNA1,
          KUNNR TYPE KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
        END OF TY_KNA1,

        BEGIN OF TY_KNMT,
          MATNR TYPE KNMT-MATNR,
          KUNNR TYPE KNMT-KUNNR,
          KDMAT TYPE KNMT-KDMAT,
        END OF TY_KNMT,

        BEGIN OF TY_FINAL,
          AUFNR TYPE AUFK-AUFNR,
          AUART TYPE AUFK-AUART,
          ERDAT TYPE char15,
          GAMNG TYPE AFKO-GAMNG,
          RMANR TYPE AFKO-RMANR,
          GLTRI TYPE AFKO-GLTRI,
          WEMNG TYPE AFPO-WEMNG,
          KDAUF TYPE AFPO-KDAUF,
          KDPOS TYPE AFPO-KDPOS,
          BUDAT TYPE char15,
          VBELN TYPE VBAK-VBELN,
*          AUFNR TYPE VBAK-AUFNR,
          AUART1 TYPE VBAK-AUART,
          KUNNR TYPE VBAK-KUNNR,
          AUDAT TYPE char15,
          VKBUR TYPE VBAK-VKBUR,
          POSNR TYPE VBAP-POSNR,
          MATNR TYPE VBAP-MATNR,
          BSTKD TYPE VBKD-BSTKD,
          BSTDK TYPE VBKD-BSTDK,
          BRAND TYPE MARA-BRAND,
          ZSIZE TYPE MARA-ZSIZE,
          MOC   TYPE MARA-MOC,
          NAME1 TYPE KNA1-NAME1,
          TYPE  TYPE MARA-TYPE,
          ZSERIES TYPE MARA-ZSERIES,
          KDMAT TYPE KNMT-KDMAT,
          mattxt      TYPE text100,
          SO_DATE(11) TYPE C,
          DOC_DATE(11) TYPE C,
          REF  TYPE char15,
        END OF TY_FINAL.

TYPES: BEGIN OF STR_FINAL,
       AUART    TYPE AUFK-AUART,
       AUFNR    TYPE AUFK-AUFNR,
       ERDAT    TYPE char15,
       GAMNG    TYPE char17, "AFKO-GAMNG,
       WEMNG    TYPE char17, "AFPO-WEMNG,
       KUNNR    TYPE VBAK-KUNNR,
       NAME1    TYPE KNA1-NAME1,
       VKBUR    TYPE VBAK-VKBUR,
       VBELN    TYPE VBAK-VBELN,
       AUDAT    TYPE char15,
       BSTKD    TYPE VBKD-BSTKD,
       KDPOS    TYPE AFPO-KDPOS,
       KDMAT    TYPE KNMT-KDMAT,
       MATNR    TYPE VBAP-MATNR,
       mattxt   TYPE text100,
       BRAND    TYPE MARA-BRAND,
       ZSIZE    TYPE MARA-ZSIZE,
       MOC      TYPE MARA-MOC,
       TYPE     TYPE MARA-TYPE,
       ZSERIES  TYPE MARA-ZSERIES,
       BUDAT    TYPE char15,
       REF      TYPE char15,
       END OF STR_FINAL.

DATA: IT_AUFK TYPE TABLE OF TY_AUFK,
      WA_AUFK TYPE          TY_AUFK,

      IT_AFKO TYPE TABLE OF TY_AFKO,
      WA_AFKO TYPE          TY_AFKO,

      IT_AFPO TYPE TABLE OF TY_AFPO,
      WA_AFPO TYPE          TY_AFPO,

      IT_AFRU TYPE TABLE OF TY_AFRU,
      WA_AFRU TYPE          TY_AFRU,

      IT_VBAK TYPE TABLE OF TY_VBAK,
      WA_VBAK TYPE          TY_VBAK,

      IT_VBAP TYPE TABLE OF TY_VBAP,
      WA_VBAP TYPE          TY_VBAP,

      IT_VBKD TYPE TABLE OF TY_VBKD,
      WA_VBKD TYPE          TY_VBKD,

      IT_KNA1 TYPE TABLE OF TY_KNA1,
      WA_KNA1 TYPE          TY_KNA1,

      IT_MARA TYPE TABLE OF TY_MARA,
      WA_MARA TYPE          TY_MARA,

      IT_KNMT TYPE TABLE OF TY_KNMT,
      WA_KNMT TYPE          TY_KNMT,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL,

      LT_FINAL TYPE TABLE OF STR_FINAL,
      LS_FINAL TYPE          STR_FINAL.


DATA: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.


SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: "S_KUNNR FOR KNA1-KUNNR,
                  "S_NAME1 FOR KNA1-NAME1,
                 s_gltri FOR afru-budat.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.
PERFORM GET_DATA.
PERFORM GET_FCAT.
PERFORM GET_DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  BREAK PRIMUS.

SELECT AUFNR
       BUDAT
       RMZHL FROM AFRU INTO TABLE IT_AFRU
       WHERE BUDAT IN S_GLTRI.
IF IT_AFRU IS NOT INITIAL.
  SELECT AUFNR
       GAMNG
       RMANR
       GLTRI FROM AFKO INTO TABLE IT_AFKO
       FOR ALL ENTRIES IN IT_AFRU
       WHERE AUFNR = IT_AFRU-AUFNR.
ENDIF.


IF IT_AFKO IS NOT INITIAL .

  SELECT AUFNR
         WEMNG
         KDAUF
         KDPOS FROM AFPO INTO TABLE IT_AFPO
         FOR ALL ENTRIES IN IT_AFKO
         WHERE AUFNR = IT_AFKO-AUFNR.
*         FOR ALL ENTRIES IN IT_VBAP
*         WHERE KDAUF = IT_VBAP-VBELN
*         AND   KDPOS = IT_VBAP-POSNR.


ENDIF.

IF IT_AFPO IS NOT INITIAL.
  SELECT AUFNR
         AUART
         ERDAT FROM AUFK INTO TABLE IT_AUFK
         FOR ALL ENTRIES IN IT_AFPO
         WHERE AUFNR = IT_AFPO-AUFNR.

  SELECT VBELN
         POSNR
         MATNR FROM VBAP INTO TABLE IT_VBAP
         FOR ALL ENTRIES IN IT_AFPO
         WHERE VBELN = IT_AFPO-KDAUF
         AND   POSNR = IT_AFPO-KDPOS.



ENDIF.

IF IT_VBAP IS NOT INITIAL .

  SELECT VBELN
         AUFNR
         AUART
         KUNNR
         AUDAT
         VKBUR FROM VBAK INTO TABLE IT_VBAK
         FOR ALL ENTRIES IN IT_VBAP
         WHERE VBELN = IT_VBAP-VBELN.

      SELECT VBELN
         BSTKD
         BSTDK FROM VBKD INTO TABLE IT_VBKD
         FOR ALL ENTRIES IN IT_VBAP
         WHERE VBELN = IT_VBAP-VBELN.




  SELECT MATNR
         BRAND
         ZSIZE
         MOC
         TYPE
         ZSERIES FROM MARA INTO TABLE IT_MARA
         FOR ALL ENTRIES IN IT_VBAP
         WHERE MATNR = IT_VBAP-MATNR.


ENDIF.

IF IT_VBAK IS NOT INITIAL .

SELECT KUNNR
       NAME1 FROM KNA1 INTO TABLE IT_KNA1
       FOR ALL ENTRIES IN IT_VBAK
       WHERE KUNNR = IT_VBAK-KUNNR.


ENDIF.


IF IT_KNA1 IS NOT INITIAL.

  SELECT MATNR
         KUNNR
         KDMAT FROM KNMT INTO TABLE IT_KNMT
         FOR ALL ENTRIES IN IT_KNA1
         WHERE KUNNR = IT_KNA1-KUNNR.

ENDIF.


LOOP AT IT_AFPO INTO WA_AFPO.
  WA_FINAL-AUFNR = WA_AFPO-AUFNR.
  WA_FINAL-WEMNG = WA_AFPO-WEMNG.
  WA_FINAL-KDAUF = WA_AFPO-KDAUF.
  WA_FINAL-KDPOS = WA_AFPO-KDPOS.

READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_AFPO-KDAUF
                                         POSNR = WA_AFPO-KDPOS.
IF SY-SUBRC = 0.
  WA_FINAL-VBELN =  WA_VBAP-VBELN.
  WA_FINAL-POSNR =  WA_VBAP-POSNR.
  WA_FINAL-MATNR =  WA_VBAP-MATNR.

ENDIF.


READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_VBAP-VBELN.
IF SY-SUBRC = 0.
  WA_FINAL-AUART1  = WA_VBAK-AUART .
  WA_FINAL-KUNNR  = WA_VBAK-KUNNR .
*  WA_FINAL-AUDAT = WA_VBAK-AUDAT.
  WA_FINAL-VKBUR = WA_VBAK-VKBUR.

CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_VBAK-AUDAT
   IMPORTING
     OUTPUT        = WA_FINAL-AUDAT
            .

CONCATENATE WA_FINAL-AUDAT+0(2) WA_FINAL-AUDAT+2(3) WA_FINAL-AUDAT+5(4)
                INTO WA_FINAL-AUDAT SEPARATED BY '-'.

ENDIF.

READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_VBAP-VBELN.
IF SY-SUBRC = 0.
  WA_FINAL-BSTKD = WA_VBKD-BSTKD.
  WA_FINAL-BSTDK = WA_VBKD-BSTDK.

ENDIF.

READ TABLE IT_AFKO INTO WA_AFKO WITH KEY AUFNR = WA_AFPO-AUFNR.
  IF SY-SUBRC = 0.
    WA_FINAL-GAMNG = WA_AFKO-GAMNG.
    WA_FINAL-GLTRI = WA_AFKO-GLTRI.
  ENDIF.

READ TABLE IT_AUFK INTO WA_AUFK WITH KEY AUFNR = WA_AFPO-AUFNR.
 IF SY-SUBRC = 0.
   WA_FINAL-AUART = WA_AUFK-AUART.
*   WA_FINAL-ERDAT = WA_AUFK-ERDAT.
   CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_AUFK-ERDAT
   IMPORTING
     OUTPUT        = WA_FINAL-ERDAT
            .

CONCATENATE WA_FINAL-ERDAT+0(2) WA_FINAL-ERDAT+2(3) WA_FINAL-ERDAT+5(4)
                INTO WA_FINAL-ERDAT SEPARATED BY '-'.


 ENDIF.
*BREAK PRIMUS.
SORT IT_AFRU BY RMZHL DESCENDING.
DELETE ADJACENT DUPLICATES FROM IT_AFRU COMPARING AUFNR.
READ TABLE IT_AFRU INTO WA_AFRU WITH KEY AUFNR = WA_AFPO-AUFNR.
IF  SY-SUBRC = 0.

*  WA_FINAL-BUDAT = WA_AFRU-BUDAT.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_AFRU-BUDAT
   IMPORTING
     OUTPUT        = WA_FINAL-BUDAT
            .

CONCATENATE WA_FINAL-BUDAT+0(2) WA_FINAL-BUDAT+2(3) WA_FINAL-BUDAT+5(4)
                INTO WA_FINAL-BUDAT SEPARATED BY '-'.


ENDIF.

READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBAK-KUNNR.
IF SY-SUBRC = 0.
  WA_FINAL-NAME1 = WA_KNA1-NAME1.

ENDIF.

READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_VBAP-MATNR.
IF SY-SUBRC = 0.
  WA_FINAL-MATNR   = WA_MARA-MATNR .
  WA_FINAL-BRAND   = WA_MARA-BRAND .
  WA_FINAL-ZSIZE   = WA_MARA-ZSIZE .
  WA_FINAL-MOC     = WA_MARA-MOC   .
  WA_FINAL-TYPE    = WA_MARA-TYPE  .
  WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
ENDIF.

READ TABLE IT_KNMT INTO WA_KNMT WITH KEY KUNNR = WA_KNA1-KUNNR MATNR = WA_VBAP-MATNR.
IF SY-SUBRC = 0.
  WA_FINAL-KDMAT = WA_KNMT-KDMAT.

ENDIF.

CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_vbap-matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name
          object                  = 'MATERIAL'
        TABLES
          lines                   = lv_lines
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
      READ TABLE lv_lines INTO ls_mattxt INDEX 1.

WA_FINAL-mattxt = ls_mattxt-tdline.
*BREAK PRIMUS.


wa_final-ref = sy-datum.
 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = wa_final-ref
   IMPORTING
     OUTPUT        = wa_final-ref
            .

CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
                INTO wa_final-ref SEPARATED BY '-'.


LS_FINAL-AUART    = WA_FINAL-AUART   .
LS_FINAL-AUFNR    = WA_FINAL-AUFNR   .
LS_FINAL-ERDAT    = WA_FINAL-ERDAT   .
LS_FINAL-GAMNG    = WA_FINAL-GAMNG   .
LS_FINAL-WEMNG    = WA_FINAL-WEMNG   .
LS_FINAL-KUNNR    = WA_FINAL-KUNNR   .
LS_FINAL-NAME1    = WA_FINAL-NAME1   .
LS_FINAL-VKBUR    = WA_FINAL-VKBUR   .
LS_FINAL-VBELN    = WA_FINAL-VBELN   .
LS_FINAL-AUDAT    = WA_FINAL-AUDAT   .
LS_FINAL-BSTKD    = WA_FINAL-BSTKD   .
LS_FINAL-KDPOS    = WA_FINAL-KDPOS   .
LS_FINAL-KDMAT    = WA_FINAL-KDMAT   .
LS_FINAL-MATNR    = WA_FINAL-MATNR   .
LS_FINAL-mattxt   = WA_FINAL-mattxt  .
LS_FINAL-BRAND    = WA_FINAL-BRAND   .
LS_FINAL-ZSIZE    = WA_FINAL-ZSIZE   .
LS_FINAL-MOC      = WA_FINAL-MOC     .
LS_FINAL-TYPE     = WA_FINAL-TYPE    .
LS_FINAL-ZSERIES  = WA_FINAL-ZSERIES .
LS_FINAL-BUDAT    = WA_FINAL-BUDAT   .
LS_FINAL-REF      = WA_FINAL-REF     .






IF WA_FINAL-WEMNG IS NOT INITIAL.
APPEND WA_FINAL TO IT_FINAL.
APPEND LS_FINAL TO LT_FINAL.
ELSE.
  CLEAR WA_FINAL.
ENDIF.
*APPEND WA_FINAL TO IT_FINAL.

CLEAR WA_FINAL.
ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .



PERFORM FCAT USING : '1'  'AUART'   'IT_FINAL'  'DOC CODE'           '18' ,
                     '2'  'AUFNR'   'IT_FINAL'  'VW_APM_DOC_NO'      '18',
                     '3'  'ERDAT'   'IT_FINAL'  'VW_APM_DOC_DATE'    '18' ,
                     '4'  'GAMNG'   'IT_FINAL'  'VW_APM_QTY'         '18' ,
                     '5'  'WEMNG'   'IT_FINAL'  'VW_APM_DEL_QTY'     '18',
                     '6'  'KUNNR'   'IT_FINAL'  'VW_PARTY_CODE'      '18',
                     '7'  'NAME1'   'IT_FINAL'  'VW_PARTY_NAME'      '25',
                     '8'  'VKBUR'  'IT_FINAL'   'VW_SO_DOC_CODE'     '15',
                     '9'  'VBELN'   'IT_FINAL'  'VW_SO_DOC_NO'       '18',
                    '10'  'AUDAT'   'IT_FINAL'  'VW_SO_DOC_DATE'     '18',
                    '11'  'BSTKD'   'IT_FINAL'  'VW_REF_PO_NO'       '18',
                    '12'  'KDPOS'   'IT_FINAL'  'VW_SO_SR_NO'        '18',
                    '13'  'KDMAT'   'IT_FINAL'  'VW_USER_ITEM_DESC'  '25',
                    '14'  'MATNR'   'IT_FINAL'  'VW_ITEM_CODE'       '18',
                    '15'  'MATTXT'  'IT_FINAL'  'VW_ITEM_DESC'       '50',
                    '16'  'BRAND'   'IT_FINAL'  'VW_BRAND'           '18',
                    '17'  'ZSIZE'   'IT_FINAL'  'VW_SIZE'            '18',
                    '18'  'MOC'     'IT_FINAL'  'VW_MOC'             '15',
                    '19'  'TYPE'    'IT_FINAL'  'VW_TYPE'            '15',
                    '20'  'ZSERIES' 'IT_FINAL'  'VW_SERIES'          '15',
                    '21'  'BUDAT'   'IT_FINAL'  'CONFIRMATION DATE'  '15',
                    '22'  'REF'     'IT_FINAL'  'Refresh DATE'       '15'.





ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
     IT_FIELDCAT                       = it_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
IF p_down = 'X'.
    PERFORM download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0731   text
*      -->P_0732   text
*      -->P_0733   text
*      -->P_0734   text
*      -->P_0735   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
wa_fcat-col_pos   = p1.
wa_fcat-fieldname = p2.
wa_fcat-tabname   = p3.
wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
wa_fcat-outputlen   = p5.

append wa_fcat to it_fcat.
CLEAR wa_fcat.
ENDFORM.

FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).
BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = LT_FINAL
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZMTR.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
BREAK primus.
  WRITE: / 'ZMTR Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_681 TYPE string.
DATA lv_crlf_681 TYPE string.
lv_crlf_681 = cl_abap_char_utilities=>cr_lf.
lv_string_681 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_681 lv_crlf_681 wa_csv INTO lv_string_681.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_778 TO lv_fullfile.
TRANSFER lv_string_681 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'DOC CODE'
              'VW_APM_DOC_NO'
              'VW_APM_DOC_DATE'
              'VW_APM_QTY'
              'VW_APM_DEL_QTY'
              'VW_PARTY_CODE'
              'VW_PARTY_NAME'
              'VW_SO_DOC_CODE'
              'VW_SO_DOC_NO'
              'VW_SO_DOC_DATE'
              'VW_REF_PO_NO'
              'VW_SO_SR_NO'
              'VW_USER_ITEM_DESC'
              'VW_ITEM_CODE'
              'VW_ITEM_DESC'
              'VW_BRAND'
              'VW_SIZE'
              'VW_MOC'
              'VW_TYPE'
              'VW_SERIES'
              'CONFIRMATION DATE'
              'Refresh DATE'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
