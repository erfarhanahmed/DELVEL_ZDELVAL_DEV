*&---------------------------------------------------------------------*
*& Report ZPP_ROUTING_REPORT
*&---------------------------------------------------------------------*
*& (C) PRIMUS  TECHSYSTEMS PVT. LTD.
*&---------------------------------------------------------------------*
*& AUTHOR: PRIMUS - YUVRAJ JADHAV
*&---------------------------------------------------------------------*
*& FUNCTIONAL : Anuj Deshpande
*&---------------------------------------------------------------------*
*& DATE : 01/08/2019
*&---------------------------------------------------------------------*

REPORT ZPP_ROUTING_REPORT.

TYPE-POOLS: SLIS.

TABLES : MAPL, PLPO, PLKO, CRHD.

TYPES: BEGIN OF TY_MAPL,
        MATNR TYPE MAPL-MATNR,
        WERKS TYPE MAPL-WERKS,
        PLNTY TYPE MAPL-PLNTY,
        PLNNR TYPE MAPL-PLNNR,
        PLNAL TYPE MAPL-PLNAL,
        ZAEHL TYPE MAPL-ZAEHL,
        ANDAT TYPE MAPL-ANDAT,
       END OF TY_MAPL.

TYPES: BEGIN OF TY_PLKO,
        PLNTY TYPE PLKO-PLNTY,
        PLNNR TYPE PLKO-PLNNR,
        PLNAL TYPE PLKO-PLNAL,
        ZAEHL TYPE PLKO-ZAEHL,
        VERWE TYPE PLKO-VERWE,
        WERKS TYPE PLKO-WERKS,
        STATU TYPE PLKO-STATU,
      END OF TY_PLKO.

TYPES: BEGIN OF TY_PLPO,
        PLNTY TYPE PLPO-PLNTY,
        PLNNR TYPE PLPO-PLNNR,
        ZAEHL TYPE PLPO-ZAEHL,
        VORNR TYPE PLPO-VORNR,
        STEUS TYPE PLPO-STEUS,
        ARBID TYPE PLPO-ARBID,
        OBJTY TYPE PLPO-OBJTY,
        WERKS TYPE PLPO-WERKS,
        LTXA1 TYPE PLPO-LTXA1,
        LAR01 TYPE PLPO-LAR01,
        VGE01 TYPE PLPO-VGE01,
        VGW01 TYPE PLPO-VGW01,
        "ARBTY TYPE PLPO-ARBTY,
        "NETID TYPE PLPO-NETID,
      END OF TY_PLPO.

TYPES: BEGIN OF TY_CRHD,
        OBJTY TYPE CRHD-OBJTY,
        OBJID TYPE CRHD-OBJID,
        ARBPL TYPE CRHD-ARBPL,
        WERKS TYPE CRHD-WERKS,
      END OF TY_CRHD.

TYPES: BEGIN OF TY_FINAL,
        MATNR TYPE MAPL-MATNR,
        WERKS TYPE MAPL-WERKS,
        PLNTY TYPE MAPL-PLNTY,
        PLNNR TYPE MAPL-PLNNR,
        PLNAL TYPE MAPL-PLNAL,
        ZAEHL TYPE MAPL-ZAEHL,
        ANDAT TYPE MAPL-ANDAT,
        "ARBTY TYPE PLPO-ARBTY,
        "NETID TYPE PLPO-NETID,
        "PLNTY TYPE PLKO-PLNTY,
        "PLNNR TYPE PLKO-PLNNR,
        "PLNAL TYPE PLKO-PLNAL,
        "ZAEHL TYPE PLKO-ZAEHL,
        VERWE TYPE PLKO-VERWE,
        "WERKS TYPE PLKO-WERKS,
        STATU TYPE PLKO-STATU,
        "PLNTY TYPE PLPO-PLNTY,
        "PLNNR TYPE PLPO-PLNNR,
        "ZAEHL TYPE PLPO-ZAEHL,
        VORNR TYPE PLPO-VORNR,
        STEUS TYPE PLPO-STEUS,
        ARBID TYPE PLPO-ARBID,
        OBJTY TYPE PLPO-OBJTY,
        "WERKS TYPE PLPO-WERKS,
        LTXA1 TYPE PLPO-LTXA1,
        LAR01 TYPE PLPO-LAR01,
        VGE01 TYPE PLPO-VGE01,
        VGW01 TYPE PLPO-VGW01,
        "OBJTY TYPE CRHD-OBJTY,
        OBJID TYPE CRHD-OBJID,
        ARBPL TYPE CRHD-ARBPL,
        "WERKS TYPE CRHD-WERKS,
       END OF TY_FINAL,

       BEGIN OF ty_down,
       MATNR TYPE char20,
       WERKS TYPE char10,
       PLNTY TYPE char10,
       PLNNR TYPE char10,
       PLNAL TYPE char10,
       ZAEHL TYPE char10,
       ANDAT TYPE char11,
       VERWE TYPE char10,
       STATU TYPE char10,
       VORNR TYPE char10,
       OBJTY TYPE char10,
       OBJID TYPE char10,
       ARBPL TYPE char10,
       STEUS TYPE char10,
       LTXA1 TYPE char50,
       LAR01 TYPE char10,
       VGW01 TYPE char10,
       VGE01 TYPE char10,
       ref   TYPE char11,
       END OF ty_down.


DATA: LT_MAPL TYPE TABLE OF TY_MAPL,
      LS_MAPL TYPE TY_MAPL.
DATA: LT_PLKO TYPE TABLE OF TY_PLKO,
      LS_PLKO TYPE TY_PLKO.
DATA: LT_CRHD TYPE TABLE OF TY_CRHD,
      LS_CRHD TYPE TY_CRHD.
DATA: LT_PLPO TYPE TABLE OF TY_PLPO,
      LS_PLPO TYPE TY_PLPO.
DATA: LT_FINAL TYPE TABLE OF TY_FINAL,
      LS_FINAL TYPE TY_FINAL.
DATA: LT_down TYPE TABLE OF TY_down,
      LS_down TYPE TY_down.

DATA: LT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      LS_FIELDCAT LIKE LINE OF LT_FIELDCAT.
DATA: WA_LAYOUT TYPE SLIS_LAYOUT_ALV,
      G_SAVE TYPE C VALUE 'X'.
DATA: IT_TOP TYPE SLIS_T_LISTHEADER,
      WA_TOP LIKE LINE OF IT_TOP.

SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : P_MATNR FOR MAPL-MATNR.
  SELECT-OPTIONS : P_ANDAT FOR MAPL-ANDAT OBLIGATORY.
  PARAMETERS     : P_WERKS TYPE MAPL-WERKS OBLIGATORY DEFAULT 'PL01'.
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.


START-OF-SELECTION .
PERFORM FETCH_DATA.
PERFORM FIELDCAT.
*PERFORM LAYOUT.
PERFORM DISPLAY_DATA.

*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FETCH_DATA.

  SELECT MATNR
         WERKS
         PLNTY
         PLNNR
         PLNAL
         ZAEHL
         ANDAT FROM MAPL
               INTO TABLE LT_MAPL
               WHERE MATNR IN P_MATNR
                 AND ANDAT IN P_ANDAT
                 AND WERKS EQ P_WERKS
                 AND PLNTY = 'N'.

  SELECT PLNTY
         PLNNR
         PLNAL
         ZAEHL
         VERWE
         WERKS
         STATU FROM PLKO
               INTO TABLE LT_PLKO
               FOR ALL ENTRIES IN LT_MAPL
               WHERE PLNTY = LT_MAPL-PLNTY
                 AND PLNNR = LT_MAPL-PLNNR
                 AND WERKS = LT_MAPL-WERKS
                 and PLNAL = LT_MAPL-PLNAL
                 and ZAEHL = LT_MAPL-ZAEHL.
    .
IF LT_PLKO IS NOT INITIAL.

   SELECT PLNTY
          PLNNR
          ZAEHL
          VORNR
          STEUS
          ARBID
          OBJTY
          WERKS
          LTXA1
          LAR01
          VGE01
          VGW01 FROM PLPO
                INTO TABLE LT_PLPO
                FOR ALL ENTRIES IN LT_MAPL
                WHERE PLNTY = LT_MAPL-PLNTY
                  AND PLNNR = LT_MAPL-PLNNR
                  AND ZAEHL = LT_MAPL-ZAEHL.
ENDIF.

    SELECT OBJTY
           OBJID
           ARBPL
           WERKS
                 FROM CRHD INTO TABLE LT_CRHD
                 FOR ALL ENTRIES IN LT_PLPO
                 WHERE OBJID = LT_PLPO-ARBID.
                   "AND OBJID = LT_PLPO-NETID.

  LOOP AT LT_MAPL INTO LS_MAPL.
  LS_FINAL-MATNR = LS_MAPL-MATNR.
  LS_FINAL-WERKS = LS_MAPL-WERKS.
  LS_FINAL-PLNTY = LS_MAPL-PLNTY.
  LS_FINAL-PLNNR = LS_MAPL-PLNNR.
  LS_FINAL-PLNAL = LS_MAPL-PLNAL.
  LS_FINAL-ZAEHL = LS_MAPL-ZAEHL.
  LS_FINAL-ANDAT = LS_MAPL-ANDAT.


  READ TABLE LT_PLKO INTO LS_PLKO WITH KEY PLNTY = LS_MAPL-PLNTY PLNNR = LS_MAPL-PLNNR WERKS = LS_MAPL-WERKS ZAEHL = LS_MAPL-ZAEHL.
  IF SY-SUBRC = 0.
*  LS_FINAL-PLNTY = LS_PLKO-PLNTY.
*  LS_FINAL-PLNNR = LS_PLKO-PLNNR.
*  LS_FINAL-PLNAL = LS_PLKO-PLNAL.
*  LS_FINAL-ZAEHL = LS_PLKO-ZAEHL.
  LS_FINAL-VERWE = LS_PLKO-VERWE.
*  LS_FINAL-WERKS = LS_PLKO-WERKS.
  LS_FINAL-STATU = LS_PLKO-STATU.
  ENDIF.

  READ TABLE LT_PLPO INTO LS_PLPO WITH KEY PLNTY = LS_MAPL-PLNTY PLNNR = LS_MAPL-PLNNR ZAEHL = LS_MAPL-ZAEHL.
 IF SY-SUBRC = 0.
*  LS_FINAL-PLNTY = LS_PLPO-PLNTY.
*  LS_FINAL-PLNNR = LS_PLPO-PLNNR.
*  LS_FINAL-ZAEHL = LS_PLPO-ZAEHL.
  LS_FINAL-VORNR = LS_PLPO-VORNR.
  LS_FINAL-STEUS = LS_PLPO-STEUS.
*  LS_FINAL-ARBID = LS_PLPO-ARBID.
*  LS_FINAL-OBJTY = LS_PLPO-OBJTY.
*  LS_FINAL-WERKS = LS_PLPO-WERKS.
  LS_FINAL-LTXA1 = LS_PLPO-LTXA1.
  LS_FINAL-LAR01 = LS_PLPO-LAR01.
  LS_FINAL-VGE01 = LS_PLPO-VGE01.
  LS_FINAL-VGW01 = LS_PLPO-VGW01.
ENDIF.

READ TABLE LT_CRHD INTO LS_CRHD WITH KEY OBJID = LS_PLPO-ARBID.
 IF SY-SUBRC = 0.
  LS_FINAL-OBJID = LS_CRHD-OBJID.
  LS_FINAL-OBJTY = LS_CRHD-OBJTY.
  LS_FINAL-ARBPL = LS_CRHD-ARBPL.
*  LS_FINAL-WERKS = LS_CRHD-WERKS.
ENDIF.

APPEND LS_FINAL TO LT_FINAL.
CLEAR LS_FINAL.

ENDLOOP.

IF p_down = 'X'.
LOOP AT lt_final INTO ls_final.
  ls_down-MATNR = ls_final-MATNR.
  ls_down-WERKS = ls_final-WERKS.
  ls_down-PLNTY = ls_final-PLNTY.
  ls_down-PLNNR = ls_final-PLNNR.
  ls_down-PLNAL = ls_final-PLNAL.
  ls_down-ZAEHL = ls_final-ZAEHL.
*  ls_down-ANDAT = ls_final-ANDAT.

  IF ls_final-ANDAT IS NOT INITIAL.


  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-ANDAT
     IMPORTING
        output = ls_down-ANDAT.

    CONCATENATE ls_down-ANDAT+0(2) ls_down-ANDAT+2(3) ls_down-ANDAT+5(4)
                    INTO ls_down-ANDAT SEPARATED BY '-'.

  ENDIF.






  ls_down-VERWE = ls_final-VERWE.
  ls_down-STATU = ls_final-STATU.
  ls_down-VORNR = ls_final-VORNR.
  ls_down-OBJTY = ls_final-OBJTY.
  ls_down-OBJID = ls_final-OBJID.
  ls_down-ARBPL = ls_final-ARBPL.
  ls_down-STEUS = ls_final-STEUS.
  ls_down-LTXA1 = ls_final-LTXA1.
  ls_down-LAR01 = ls_final-LAR01.
  ls_down-VGW01 = ls_final-VGW01.
  ls_down-VGE01 = ls_final-VGE01.
*  ls_down-ref   = ls_final-ref  .

  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref.

    CONCATENATE ls_down-ref+0(2) ls_down-ref+2(3) ls_down-ref+5(4)
                    INTO ls_down-ref SEPARATED BY '-'.

APPEND ls_down TO lt_down.
CLEAR ls_down.
ENDLOOP.
ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELDCAT.

  LS_FIELDCAT-COL_POS   = '1'.
  LS_FIELDCAT-FIELDNAME = 'MATNR'.
  LS_FIELDCAT-SELTEXT_L = 'Material Number'.
  LS_FIELDCAT-KEY       = 'X'.
  LS_FIELDCAT-outputlen = '18'.
  LS_FIELDCAT-fix_column = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '2'.
  LS_FIELDCAT-FIELDNAME = 'WERKS'.
  LS_FIELDCAT-SELTEXT_L = 'Plant'.
  LS_FIELDCAT-KEY       = 'X'.
  LS_FIELDCAT-fix_column = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '3'.
  LS_FIELDCAT-FIELDNAME = 'PLNTY'.
  LS_FIELDCAT-SELTEXT_L = 'Task List Type'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '4'.
  LS_FIELDCAT-FIELDNAME = 'PLNNR'.
  LS_FIELDCAT-SELTEXT_L = 'Group'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '5'.
  LS_FIELDCAT-FIELDNAME = 'PLNAL'.
  LS_FIELDCAT-SELTEXT_L = 'Group Counter'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '6'.
  LS_FIELDCAT-FIELDNAME = 'ZAEHL'.
  LS_FIELDCAT-SELTEXT_L = 'Counter'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '7'.
  LS_FIELDCAT-FIELDNAME = 'ANDAT'.
  LS_FIELDCAT-SELTEXT_L = 'Created ON'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '8'.
  LS_FIELDCAT-FIELDNAME = 'VERWE'.
  LS_FIELDCAT-SELTEXT_L = 'Task list usage'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '9'.
  LS_FIELDCAT-FIELDNAME = 'STATU'.
  LS_FIELDCAT-SELTEXT_L = 'Status'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '10'.
  LS_FIELDCAT-FIELDNAME = 'VORNR'.
  LS_FIELDCAT-SELTEXT_L = 'Activity Number'.
**  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '11'.
  LS_FIELDCAT-FIELDNAME = 'OBJTY'.
  LS_FIELDCAT-SELTEXT_L = 'Object Type'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '12'.
  LS_FIELDCAT-FIELDNAME = 'OBJID'.
  LS_FIELDCAT-SELTEXT_L = 'Object ID'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '13'.
  LS_FIELDCAT-FIELDNAME = 'ARBPL'.
  LS_FIELDCAT-SELTEXT_L = 'Work center'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '14'.
  LS_FIELDCAT-FIELDNAME = 'STEUS'.
  LS_FIELDCAT-SELTEXT_L = 'Control key'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '15'.
  LS_FIELDCAT-FIELDNAME = 'LTXA1'.
  LS_FIELDCAT-SELTEXT_L = 'Operation short text'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '16'.
  LS_FIELDCAT-FIELDNAME = 'LAR01'.
  LS_FIELDCAT-SELTEXT_L = 'Description of standard value 1'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '17'.
  LS_FIELDCAT-FIELDNAME = 'VGW01'.
  LS_FIELDCAT-SELTEXT_L = 'Std.Value'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

  LS_FIELDCAT-COL_POS   = '18'.
  LS_FIELDCAT-FIELDNAME = 'VGE01'.
  LS_FIELDCAT-SELTEXT_L = 'Unit of Measurement of Standard Value'.
*  LS_FIELDCAT-KEY       = 'X'.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR : LS_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TOP-OF-PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM TOP-OF-PAGE.
*
*DATA: LV_DATE TYPE D.
*DATA: str_date TYPE STRING.
*
*WA_TOP-info = 'Routing Template (ZPP92)'.
*WA_TOP-typ = 'H'.
*APPEND WA_TOP to IT_TOP.
*clear wa_TOP.
*
*
*LV_DATE = SY-datum.
*lv_DATE  = sy-datum .
*CONCATENATE lv_DATE+6(2)  '.' lv_DATE+4(2) '.' lv_DATE+0(4) INTO str_date.
*
*WA_TOP-info = str_date.
*WA_TOP-typ = 'S'.
*APPEND WA_TOP to IT_TOP.
**clear wa_TOP.
*
*
*
*CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
*  EXPORTING
*    it_list_commentary       = IT_TOP
**   I_LOGO                   =
**   I_END_OF_LIST_GRID       =
**   I_ALV_FORM               =
*          .
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_DATA.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
    I_CALLBACK_PROGRAM                = SY-CPROG
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*    I_CALLBACK_TOP_OF_PAGE            = 'TOP-OF-PAGE'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
    IS_LAYOUT                         = WA_LAYOUT
    IT_FIELDCAT                       = LT_FIELDCAT
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                             = G_SAVE
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    T_OUTTAB                          = LT_FINAL
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

IF p_down = 'X'.

    PERFORM download.

ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM LAYOUT.
*  WA_LAYOUT-ZEBRA = 'X' .
*  WA_LAYOUT-COLWIDTH_OPTIMIZE = 'X' .
*  WA_LAYOUT-EDIT = 'X' .
*  WA_LAYOUT-NO_VLINE = 'X' .
*  WA_LAYOUT-NO_HLINE = 'X' .
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .

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

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
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


    lv_file = 'ZPP92_REPORT.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPP92_REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_654 TYPE string.
DATA lv_crlf_654 TYPE string.
lv_crlf_654 = cl_abap_char_utilities=>cr_lf.
lv_string_654 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_654 lv_crlf_654 wa_csv INTO lv_string_654.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_654 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
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


    lv_file = 'ZPP92_REPORT.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPP92_REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_691 TYPE string.
DATA lv_crlf_691 TYPE string.
lv_crlf_691 = cl_abap_char_utilities=>cr_lf.
lv_string_691 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_691 lv_crlf_691 wa_csv INTO lv_string_691.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_691 TO lv_fullfile.
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
CONCATENATE 'Material Number'
            'Plant'
            'Task List Type'
            'Group'
            'Group Counter'
            'Counter'
            'Created ON'
            'Task list usage'
            'Status'
            'Activity Number'
            'Object Type'
            'Object ID'
            'Work center'
            'Control key'
            'Operation short text'
            'Description of standard value 1'
            'Std.Value'
            'Unit of Measurement of Standard Value'
            'Refresh Date'
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
