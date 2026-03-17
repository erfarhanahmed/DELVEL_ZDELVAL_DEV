

*&---------------------------------------------------------------------*
*& Report ZASSET_RP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZASSET_RP.

TABLES : ZASSET_TABLE, ANLA, ANLC.

TYPE-POOLS : SLIS.

TYPES : BEGIN OF TY_ZASSET_TABLE,
          HEADING TYPE ZASSET_TABLE-HEADING,
          ANLKL   TYPE ZASSET_TABLE-ANLKL,
        END OF TY_ZASSET_TABLE.

TYPES : BEGIN OF TY_ANLA,
          BUKRS TYPE ANLA-BUKRS,
          ANLN1 TYPE ANLA-ANLN1,
          ANLN2 TYPE ANLA-ANLN2,
          ANLKL TYPE ANLA-ANLKL,
        END OF TY_ANLA.

TYPES : BEGIN OF TY_ANLC,
          BUKRS  TYPE ANLC-BUKRS,
          ANLN1  TYPE ANLC-ANLN1,
          ANLN2  TYPE ANLC-ANLN2,
          GJAHR  TYPE ANLC-GJAHR,
          AFABE  TYPE ANLC-AFABE,
          KANSW  TYPE ANLC-KANSW,
          KNAFA  TYPE ANLC-KNAFA,
          NAFAP  TYPE ANLC-NAFAP,
          ANSWL  TYPE ANLC-ANSWL,
          ANSWL1 LIKE ANLC-ANSWL,
          NAFAL  TYPE ANLC-NAFAL,
        END OF TY_ANLC.

TYPES : BEGIN OF TY_FINAL,
          HEADING  TYPE ZASSET_TABLE-HEADING,
          ANLKL    TYPE ZASSET_TABLE-ANLKL,
*
*          BUKRS    TYPE ANLA-BUKRS,
          ANLN1    TYPE ANLA-ANLN1,
          ANLN2    TYPE ANLA-ANLN2,
*
*          GJAHR    TYPE ANLC-GJAHR,
*          AFABE    TYPE ANLC-AFABE,
          KANSW    TYPE ANLC-KANSW,
          KNAFA    TYPE ANLC-KNAFA,
          NAFAP    TYPE ANLC-NAFAP,
          ANSWL    TYPE ANLC-ANSWL,
          ANSWL1   LIKE ANLC-ANSWL,
          NAFAL    TYPE ANLC-NAFAL,

          LV_TEMP  TYPE ANLC-KANSW,

          LV_TEMP1 TYPE ANLC-KNAFA,

          LV_TEMP2 TYPE ANLC-KANSW,

          LV_TEMP3 TYPE ANLC-KNAFA,

        END OF TY_FINAL.

DATA : LT_ZASSET_TABLE TYPE TABLE OF TY_ZASSET_TABLE,
       LS_ZASSET_TABLE TYPE TY_ZASSET_TABLE,

       LT_ANLA         TYPE TABLE OF TY_ANLA,
       LS_ANLA         TYPE TY_ANLA,

       LT_ANLC         TYPE TABLE OF TY_ANLC,
       LS_ANLC         TYPE TY_ANLC,

       LT_FINAL        TYPE TABLE OF TY_FINAL,
       LT_FINAL1       TYPE TABLE OF TY_FINAL,
       LS_FINAL        TYPE TY_FINAL,
       LS_FINAL1       TYPE TY_FINAL.

DATA : LT_FCAT   TYPE SLIS_T_FIELDCAT_ALV,
       LS_FCAT   TYPE SLIS_FIELDCAT_ALV,

       LT_LAYOUT TYPE SLIS_LAYOUT_ALV,
       LS_LAYOUT TYPE SLIS_LAYOUT_ALV,

       LT_EVENT  TYPE SLIS_T_EVENT WITH HEADER LINE.

DATA : V_POS         TYPE I.

DATA : LV_TEMP TYPE ANLC-KANSW.

DATA : LV_TEMP1 TYPE ANLC-KNAFA.

DATA : LV_TEMP2 TYPE ANLC-KANSW.

DATA : LV_TEMP3 TYPE ANLC-KNAFA.

DATA : N TYPE I.

data : ws_year(4) type c.

data : ws_year1(4) type c.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

PARAMETERS : P_BUKRS TYPE ANLA-BUKRS,
             P_GJAHR TYPE ANLC-GJAHR.

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN: BEGIN OF BLOCK b2 .
PARAMETERS:
            rb1 RADIOBUTTON GROUP rgrp,
            rb2 RADIOBUTTON GROUP rgrp. "  USER-COMMAND call_tcode.
SELECTION-SCREEN: END OF BLOCK b2.

START-OF-SELECTION .
 PERFORM SELECT_DATA.
** IF rb1 = 'X'.
**       PERFORM DISPDATA.
**  ELSEIF rb2 = 'X'.
***     PERFORM get_data_a.
**     PERFORM DISPDATA1.
**
**  ENDIF.


DEFINE FCAT.

  ls_fcat-col_pos = v_pos + 1.
  ls_fcat-fieldname = &1.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = &2.
  ls_fcat-OUTPUTLEN = &3.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

END-OF-DEFINITION.
**
**START-OF-SELECTION.
**  PERFORM SELECT_DATA.

END-OF-SELECTION.
  IF RB1 EQ 'X'.
  PERFORM DISPDATA.
**  ELSE.
  ENDIF.
  IF RB2 EQ 'X'.
  PERFORM DISPDATA1.
  ENDIF.

 TOP-OF-PAGE.
  PERFORM TOP_OF_PAGE.

  PERFORM TOP_OF_PAGE1.
  .
*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SELECT_DATA .
*
  SELECT *
    FROM ZASSET_TABLE
    INTO CORRESPONDING FIELDS OF TABLE LT_ZASSET_TABLE.

  SELECT BUKRS
         ANLN1
         ANLN2
         ANLKL
    FROM ANLA
    INTO TABLE LT_ANLA
    FOR ALL ENTRIES IN LT_ZASSET_TABLE
    WHERE BUKRS = P_BUKRS
    AND ANLKL = LT_ZASSET_TABLE-ANLKL.

  SELECT BUKRS
         ANLN1
         ANLN2
         GJAHR
         AFABE
         KANSW
         KNAFA
         NAFAP
         ANSWL
         NAFAL
    FROM ANLC
    INTO CORRESPONDING FIELDS OF TABLE LT_ANLC
    FOR ALL ENTRIES IN LT_ANLA
    WHERE GJAHR = P_GJAHR
    AND BUKRS = LT_ANLA-BUKRS
    AND ANLN1 = LT_ANLA-ANLN1
    AND ANLN2 = LT_ANLA-ANLN2
    AND AFABE = 01.

***DELETE LT_ANLC WHERE  ANLN1 NE '000013000153'.

LOOP AT LT_ZASSET_TABLE INTO LS_ZASSET_TABLE.

    LS_FINAL-HEADING = LS_ZASSET_TABLE-HEADING.
    LS_FINAL-ANLKL = LS_ZASSET_TABLE-ANLKL.

 LOOP AT LT_ANLA INTO LS_ANLA WHERE BUKRS = P_BUKRS
                               AND     ANLKL = LS_ZASSET_TABLE-ANLKL.

*    IF SY-SUBRC EQ 0.
*      LS_FINAL-BUKRS = LS_ANLA-BUKRS.
      LS_FINAL-ANLN1 = LS_ANLA-ANLN1.
      LS_FINAL-ANLN2 = LS_ANLA-ANLN2.
*    ENDIF.
     ls_final-anlkl = ls_anla-anlkl.


    LOOP AT LT_ANLC INTO LS_ANLC WHERE BUKRS = LS_ANLA-BUKRS
                                 AND   ANLN1 = LS_ANLA-ANLN1
                                 AND   ANLN2 = LS_ANLA-ANLN2
                                 AND   AFABE = 01
                                 AND   GJAHR = P_GJAHR.

**     IF SY-SUBRC EQ 0.  """"commented by jyoti mahajan 30.09.2019.
     IF   LS_ANLC-BUKRS     EQ LS_ANLA-BUKRS
         AND LS_ANLC-ANLN1  EQ LS_ANLA-ANLN1
         AND LS_ANLC-ANLN2  EQ LS_ANLA-ANLN2
         AND LS_ANLC-AFABE  EQ 1
         AND LS_ANLC-GJAHR  EQ  P_GJAHR.


*      LS_FINAL-GJAHR = LS_ANLC-GJAHR.
*      LS_FINAL-AFABE = LS_ANLC-AFABE.
      LS_FINAL-KANSW = LS_ANLC-KANSW.
      LS_FINAL-KNAFA = LS_ANLC-KNAFA.
         if ls_final-knafa ne 0.
         LS_FINAL-KNAFA =  LS_FINAL-KNAFA * -1.
         ENDIF.
      IF LS_ANLC-ANSWL GT 0.
        LS_FINAL-ANSWL = LS_ANLC-ANSWL.
      ELSE.
        LS_FINAL-ANSWL1 = LS_ANLC-ANSWL.
         if  LS_FINAL-ANSWL1 ne 0.
       LS_FINAL-ANSWL1 = LS_FINAL-ANSWL1 * -1.
       endif.
      ENDIF.
      LS_FINAL-NAFAL = LS_ANLC-NAFAL.
       if LS_ANLC-NAFAL GT 0.
        LS_FINAL-NAFAP = 0.
         ELSE.
        LS_FINAL-NAFAP = LS_ANLC-NAFAP.
         if  LS_FINAL-NAFAP ne 0.
       LS_FINAL-NAFAP = LS_FINAL-NAFAP * -1.
       endif.
          ENDIF.
      ENDIF.
*    ENDIF.
    LS_FINAL-LV_TEMP = LS_FINAL-KANSW + LS_FINAL-ANSWL - LS_FINAL-ANSWL1.
    LS_FINAL-LV_TEMP1 = LS_FINAL-KNAFA + LS_FINAL-NAFAP - LS_FINAL-NAFAL.
    LS_FINAL-LV_TEMP2 = LS_FINAL-LV_TEMP - LS_FINAL-LV_TEMP1.
    LS_FINAL-LV_TEMP3 = LS_FINAL-KANSW - LS_FINAL-KNAFA.

    LS_FINAL-HEADING = LS_ZASSET_TABLE-HEADING.
     APPEND LS_FINAL TO LT_FINAL.

    CLEAR :  LS_FINAL,LS_ANLC,LS_ANLA.

     ENDLOOP.
  ENDLOOP.

*    ENDLOOP.
  CLEAR LS_ZASSET_TABLE.
  ENDLOOP.
*BREAK-POINT.
  IF  rb2 = 'X' .
SORT LT_FINAL BY HEADING.
**DELETE LT_FINAL WHERE HEADING EQ '' AND ANLKL EQ ''.
 LOOP AT LT_FINAL INTO LS_FINAL.
   IF LS_FINAL-HEADING IS INITIAL.
   ENDIF.
   MOVE-CORRESPONDING LS_FINAL TO LS_FINAL1.
   AT END OF HEADING.
     SUM.
     LS_FINAL1-KANSW =   LS_FINAL-KANSW .
     LS_FINAL1-KNAFA =   LS_FINAL-KNAFA .
     LS_FINAL1-NAFAP =   LS_FINAL-NAFAP.
     LS_FINAL1-ANSWL =   LS_FINAL-ANSWL.
     LS_FINAL1-ANSWL1 =  LS_FINAL-ANSWL1.
     LS_FINAL1-NAFAL =  LS_FINAL-NAFAL.
     LS_FINAL1-LV_TEMP = LS_FINAL-LV_TEMP.
     LS_FINAL1-LV_TEMP1 = LS_FINAL-LV_TEMP1.

      LS_FINAL1-LV_TEMP = LS_FINAL1-KANSW + LS_FINAL1-ANSWL - LS_FINAL1-ANSWL1.
    LS_FINAL1-LV_TEMP1 = LS_FINAL1-KNAFA + LS_FINAL1-NAFAP - LS_FINAL1-NAFAL.
    LS_FINAL1-LV_TEMP2 = LS_FINAL1-LV_TEMP - LS_FINAL1-LV_TEMP1.
    LS_FINAL1-LV_TEMP3 = LS_FINAL1-KANSW - LS_FINAL1-KNAFA.

   APPEND LS_FINAL1 TO LT_FINAL1.
    CLEAR LS_FINAL.
    ENDAT.
      ENDLOOP.

REFRESH LT_FINAL.
LT_FINAL[] = LT_FINAL1[].
ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPDATA .

  DATA : lv1 TYPE string.
  DATA : lv2 TYPE string.
  DATA : lv3 TYPE string.
  DATA : lv4 TYPE string.
  DATA : lv5 TYPE string.
  DATA : lv6 TYPE string.


  DATA : value1 TYPE string.
  DATA : value2 TYPE string.
  DATA : value3 TYPE string.
  DATA : value4 TYPE string.
  DATA : value5 TYPE string.
  DATA : value6 TYPE string.

  V_POS = 0.

  ws_year = p_gjahr.

  ws_year1 = ws_year + 1.

  value1 = 'AS At 31st March'.

  value2 = 'UPTO 31st March'.

  CONCATENATE Value1 ws_year into lv1 SEPARATED BY space.

  CONCATENATE Value1 ws_year1 into lv3 SEPARATED BY space.

  CONCATENATE Value2 ws_year into lv2 SEPARATED BY space.

  CONCATENATE Value2 ws_year1 into lv4 SEPARATED BY space.

  CONCATENATE Value1 ws_year1 into lv5 SEPARATED BY space.

  CONCATENATE Value1 ws_year into lv6 SEPARATED BY space.


  LS_FCAT-HOTSPOT = 'X'.

  FCAT 'HEADING'  'HEADING'                         '40'.
  FCAT 'ANLN1'    'ASSET NUMBER'                    '12'.
  FCAT 'ANLN2'    'ASSET SUB NUMBER'                '8'.
  FCAT 'KANSW'    lv1                               '13'.
  FCAT 'ANSWL'    'Addition During the year Rs.'    '13'.
  FCAT 'ANSWL1'   'Deduction During the year Rs.'   '13'.
  FCAT 'LV_TEMP'  lv3                               '13'.
  FCAT 'KNAFA'    lv2                               '13' .
  FCAT 'NAFAP'    'For the year RS.'                '13'.
  FCAT 'NAFAL'    'On Deduction Rs.'                '13'.
  FCAT 'LV_TEMP1' lv4                               '13'.
  FCAT 'LV_TEMP2' lv5                               '13'.
  FCAT 'LV_TEMP3' lv6                               '13'.

   LS_LAYOUT-ZEBRA = 'X'.
  LS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
*    ls_layout-no_colhead         = 'X'. "space.

* ls_layout-EDIT = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      I_CALLBACK_PROGRAM     = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      I_CALLBACK_TOP_OF_PAGE = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      IS_LAYOUT              = LS_LAYOUT
      IT_FIELDCAT            = LT_FCAT
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = ' '
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      T_OUTTAB               = LT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR          = 1
      OTHERS                 = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

*
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE .

*  uline (295) .
*  format color 1 .
*   write: / sy-vline, (20) 'HEADING' centered,
*           sy-vline, (60) 'COST' centered,
*           sy-vline, (57) 'Depreciation / Amortization / Diminution' centered,
*           sy-vline, (27) 'Net Block' centered,
*           sy-vline.
*  write: / sy-vline, (20) ' ' centered,
*         sy-vline, (12)  'AS ATt 31st March,2018 RS. ' centered,
*         sy-vline, (12)  'Addition During the year Rs. ' centered,
*         sy-vline, (12)  'Deductions During the year Rs. ' centered,
*         sy-vline, (15) 'AS At 31st March,2019 RS. ' centered,
*         sy-vline, (12) 'UPTO 31st March,2018 RS. ' centered,
*         sy-vline, (12) 'For the year RS. ' centered,
*         sy-vline, (12) 'On Deduction RS.' centered,
*         sy-vline, (12) 'UPTO 31st March,2019 RS.' centered,
*         sy-vline, (12) 'AS At 31st March,2019 RS.' centered,
*         sy-vline, (12) 'AS At 31st March,2018 RS.' centered,
*         sy-vline.

*         format COLOR off.
  DATA :
    LT_HEADER TYPE SLIS_T_LISTHEADER,
    LS_HEADER LIKE LINE OF LT_HEADER.
*    n         TYPE i.


  CLEAR LT_HEADER.

  LS_HEADER-TYP = 'H'.
  LS_HEADER-KEY = 'COMPANY'.
  LS_HEADER-INFO = 'Delval Flow Controls Private Limited'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  DATA : lv7 TYPE string.
  DATA :  value3 TYPE string.

  value3 = 'FINANCIAL STATEMENTS FOR THE YEAR ENDED 31st MARCH'.

  CONCATENATE Value3 ws_year into lv7 SEPARATED BY ','.

  LS_HEADER-TYP = 'H'.
*  LS_HEADER-KEY = 'SUBJECT'.
  LS_HEADER-INFO = lv7.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  LS_HEADER-TYP = 'S'.
  LS_HEADER-KEY = 'Note 13 :'.
  LS_HEADER-INFO = ' Tangible & Intangible Assets'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  LS_HEADER-TYP = 'S'.
  LS_HEADER-KEY = 'DATE: '.
  CONCATENATE SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM(4) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  LS_HEADER-TYP = 'S'.
  LS_HEADER-KEY = 'Total no of record'.
  LS_HEADER-INFO = N.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_HEADER
*     i_logo             = 'SAP'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPDATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPDATA1 .
 DATA : lv1 TYPE string.
  DATA : lv2 TYPE string.
  DATA : lv3 TYPE string.
  DATA : lv4 TYPE string.
  DATA : lv5 TYPE string.
  DATA : lv6 TYPE string.

  DATA : value1 TYPE string.
  DATA : value2 TYPE string.
  DATA : value3 TYPE string.
  DATA : value4 TYPE string.
  DATA : value5 TYPE string.
  DATA : value6 TYPE string.

  V_POS = 0.

  ws_year = p_gjahr.

  ws_year1 = ws_year + 1.

  value1 = 'AS At 31st March'.

  value2 = 'UPTO 31st March'.

  CONCATENATE Value1 ws_year into lv1 SEPARATED BY space.

  CONCATENATE Value1 ws_year1 into lv3 SEPARATED BY space.

  CONCATENATE Value2 ws_year into lv2 SEPARATED BY space.

  CONCATENATE Value2 ws_year1 into lv4 SEPARATED BY space.

  CONCATENATE Value1 ws_year1 into lv5 SEPARATED BY space.

  CONCATENATE Value1 ws_year into lv6 SEPARATED BY space.


  LS_FCAT-HOTSPOT = 'X'.

  FCAT 'HEADING'  'HEADING'                          '40'.
  FCAT 'KANSW'    lv1                                '13'.
  FCAT 'ANSWL'    'Addition During the year Rs.'      '13'.
  FCAT 'ANSWL1'   'Deduction During the year Rs.'    '13'.
  FCAT 'LV_TEMP'  lv3                                 '13'.
  FCAT 'KNAFA'    lv2                                 '13'.
  FCAT 'NAFAP'    'For the year RS.'                  '13'.
  FCAT 'NAFAL'    'On Deduction Rs.'                  '13'.
  FCAT 'LV_TEMP1' lv4                                 '13'.
  FCAT 'LV_TEMP2' lv5                                 '13'.
  FCAT 'LV_TEMP3' lv6                                 '13'.

  LS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
*    ls_layout-no_colhead         = 'X'. "space.

* ls_layout-EDIT = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      I_CALLBACK_PROGRAM     = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      I_CALLBACK_TOP_OF_PAGE = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
**     I_GRID_TITLE            = LV
*     I_GRID_SETTINGS        =
      IS_LAYOUT              = LS_LAYOUT
      IT_FIELDCAT            = LT_FCAT
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = ' '
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      T_OUTTAB               = LT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR          = 1
      OTHERS                 = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE1 .

   DATA :
    LT_HEADER TYPE SLIS_T_LISTHEADER,
    LS_HEADER LIKE LINE OF LT_HEADER.
*    n         TYPE i.


  CLEAR LT_HEADER.

  LS_HEADER-TYP = 'H'.
  LS_HEADER-KEY = 'COMPANY'.
  LS_HEADER-INFO = 'Delval Flow Controls Private Limited'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  DATA : lv7 TYPE string.
  DATA :  value3 TYPE string.

  value3 = 'Financial Statements For The Year Ended 31st MAR'.

  CONCATENATE Value3 ws_year into lv7 SEPARATED BY ','.

  LS_HEADER-TYP = 'H'.
*  LS_HEADER-KEY = 'SUBJECT'.
  LS_HEADER-INFO = lv7.   "'NOTES TO FINANCIAL STATEMENTS FOR THE YEAR ENDED 31st MARCH, 2019'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  LS_HEADER-TYP = 'S'.
  LS_HEADER-KEY = 'Note 13 :'.
  LS_HEADER-INFO = ' Tangible & Intangible Assets'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  LS_HEADER-TYP = 'S'.
  LS_HEADER-KEY = 'DATE: '.
  CONCATENATE SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM(4) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

  LS_HEADER-TYP = 'S'.
  LS_HEADER-KEY = 'Total no of record'.
  LS_HEADER-INFO = N.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_HEADER
*     i_logo             = 'SAP'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .




ENDFORM.
