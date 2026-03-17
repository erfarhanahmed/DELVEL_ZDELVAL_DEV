*&---------------------------------------------------------------------*
*& Report ZSALES_ORD_CHANGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSALES_ORD_CHANGE.

*** TCODE - ZSO_CHANGES

TABLES : VBAK,
         CDPOS,
         VBAP,
         CDHDR.

TYPES : BEGIN OF TY_VBAK,
          VBELN TYPE VBAK-VBELN,           " Sales Document
          AUDAT TYPE VBAK-AUDAT,           "Document Date
        END OF TY_VBAK.

TYPES : BEGIN OF TY_CDPOS,
          OBJECTID  TYPE CDPOS-OBJECTID,    "Object Value
          TABKEY    TYPE CDPOS-TABKEY,       "Changed table record key
          CHANGENR  TYPE CDPOS-CHANGENR,    "Change Number of Document
          FNAME     TYPE CDPOS-FNAME,          "Field Name
          VALUE_NEW TYPE CDPOS-VALUE_NEW,   "New contents of changed field
          VALUE_OLD TYPE CDPOS-VALUE_OLD,   "Old contents of changed field
          CHNGIND   TYPE CDPOS-CHNGIND,     "Change Ind.
          TABNAME   TYPE CDPOS-TABNAME,
        END OF TY_CDPOS.


TYPES : BEGIN OF TY_VBAP,
          VBELN   TYPE VBAP-VBELN,           " Sales Document
          POSNR   TYPE VBAP-POSNR,           " Sales Document Item
          MATNR   TYPE VBAP-MATNR,           " Material Number
          KWMENG  TYPE VBAP-KWMENG,          " Cumulative Order Quantity in Sales Units
          NETWR   TYPE VBAP-NETWR,           " Net Weight of the Item
          DELDATE TYPE VBAP-DELDATE,         " Delivery Date\
          WERKS   TYPE VBAP-WERKS,
        END OF TY_VBAP.

TYPES : BEGIN OF TY_CDHDR,
          UDATE    TYPE CDHDR-UDATE,          " Creation date of the change document
          USERNAME TYPE CDHDR-USERNAME,       " User name of the person responsible in change document
          OBJECTID TYPE CDHDR-OBJECTID,       " User name of the person responsible in change document
          CHANGENR TYPE CDHDR-CHANGENR,
        END OF TY_CDHDR.


TYPES : BEGIN OF TY_FINAL,
*         vbeln    TYPE vbak-vbeln,           " Sales Document
*         audat    TYPE vbak-audat,           "Document Date
          OBJECTID    TYPE CDPOS-OBJECTID,     "Object Value
          TABKEY      TYPE CDPOS-TABKEY,       "Changed table record key
          CHANGENR    TYPE CDPOS-CHANGENR,     "Change Number of Document
          FNAME       TYPE CDPOS-FNAME,       "Field Name
          MATNR_NEW   TYPE CDPOS-VALUE_NEW,           " Material Number
          MATNR_OLD   TYPE CDPOS-VALUE_OLD,           " Material Number
          KWMENG_NEW  TYPE CHAR10,
          KWMENG_OLD  TYPE CHAR10,
          NETWR_NEW   TYPE CDPOS-VALUE_NEW,
          NETWR_OLD   TYPE CDPOS-VALUE_OLD,
          LGORT_NEW   TYPE CDPOS-VALUE_NEW,
          LGORT_OLD   TYPE CDPOS-VALUE_OLD,
          DELDATE_NEW TYPE VBAP-DELDATE,
          DELDATE_OLD TYPE VBAP-DELDATE,
          UDATE       TYPE CDHDR-UDATE,          " Creation date of the change document
          USERNAME    TYPE CDHDR-USERNAME,       " User name of the person responsible in change document
          ZTERM_NEW   TYPE  DZTERM,
          ZTERM_OLD   TYPE DZTERM,
          INCO1_NEW   TYPE INCO1,
          INCO1_OLD   TYPE INCO1,
          KUNNR_NEW   TYPE KUNNR,
          KUNNR_OLD   TYPE KUNNR,
          KEY_NEW     TYPE CDPOS-TABKEY,

        END OF TY_FINAL.

TYPES : BEGIN OF TY_STR,

          OBJECTID    TYPE CDPOS-OBJECTID,    "Object Value
          TABKEY      TYPE CDPOS-TABKEY,       "Changed table record key
          MATNR_NEW   TYPE CDPOS-VALUE_NEW,           " Material Number
          MATNR_OLD   TYPE CDPOS-VALUE_OLD,
          KWMENG_NEW  TYPE CDPOS-VALUE_NEW,
          KWMENG_OLD  TYPE CDPOS-VALUE_OLD,
          NETWR_NEW   TYPE CDPOS-VALUE_NEW,
          NETWR_OLD   TYPE CDPOS-VALUE_OLD,
          DELDATE_NEW TYPE CHAR11,
          DELDATE_OLD TYPE CHAR11,
          LGORT_NEW   TYPE CDPOS-VALUE_NEW,
          LGORT_OLD   TYPE CDPOS-VALUE_OLD,
          UDATE       TYPE CHAR11,          " Creation date of the change document
          USERNAME    TYPE CDHDR-USERNAME,       "  User name of the person responsible in change document
          REF_DATE    TYPE CHAR11,
          REF_TIME    TYPE CHAR15,
        END OF TY_STR.


DATA : IT_VBAK     TYPE TABLE OF TY_VBAK,
       WA_VBAK     TYPE TY_VBAK,

       IT_VBAP     TYPE TABLE OF TY_VBAP,
       WA_VBAP     TYPE TY_VBAP,

       IT_VBAP_NEW TYPE TABLE OF TY_VBAP,
       WA_VBAP_NEW TYPE TY_VBAP,

       IT_CDPOS    TYPE TABLE OF TY_CDPOS,
       WA_CDPOS    TYPE TY_CDPOS,

       IT_CDHDR    TYPE TABLE OF TY_CDHDR,
       WA_CDHDR    TYPE TY_CDHDR,

       IT_FINAL    TYPE TABLE OF TY_FINAL,
       WA_FINAL    TYPE TY_FINAL,

       LT_STR      TYPE TABLE OF TY_STR,
       WA_STR      TYPE          TY_STR.

DATA : IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
       WA_FCAT TYPE SLIS_FIELDCAT_ALV.

DATA : LS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA:
  LV_CLINT   LIKE SY-MANDT,   "Client
  LV_ID      LIKE THEAD-TDID, "Text ID of text to be read
  LV_LANG    LIKE THEAD-TDSPRAS, "Language
  LV_NAME    LIKE THEAD-TDNAME, "Name of text to be read
  LV_OBJECT  LIKE THEAD-TDOBJECT, "Object of text to be read
  LV_A(132)  TYPE C,           "local variable to store text
  LV_B(132)  TYPE C,           "local variable to store text
  LV_D(132)  TYPE C,           "local variable to store text
  LV_E(132)  TYPE C,           "local variable to store text
  LV_L(132)  TYPE C,           "local variable to store text
  LV_G(132)  TYPE C,           "local variable to store text
  LV_H(132)  TYPE C,           "local variable to store text
  LV_I(132)  TYPE C,           "local variable to store text
  LV_J(132)  TYPE C,           "local variable to store text
  LV_K(132)  TYPE C,           "local variable to store text
  LV_F(1320) TYPE C.           "local variable to store concatenated text


LV_CLINT = SY-MANDT. "Client
LV_LANG = 'EN'.      "Language
LV_ID = 'QAVE'.      "Text ID of text to be read
LV_OBJECT = 'QPRUEFLOS'. "Object of text to be read

TYPES : BEGIN OF T_LINE,
          TDFORMAT(2) TYPE C , "Tag column
          TDLINE(132) TYPE C , "Text Line
        END OF T_LINE.

DATA:IT_LINE TYPE STANDARD TABLE OF T_LINE, "Table to store read_text data
     WA_LINE TYPE T_LINE.


SELECTION-SCREEN : BEGIN OF BLOCK A1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_VBELN FOR VBAK-VBELN,
                   S_AUDAT FOR VBAK-AUDAT,
                   S_POSNR FOR VBAP-POSNR .
SELECTION-SCREEN : END OF BLOCK A1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."temp'. " 'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK B2.
SELECTION-SCREEN :BEGIN OF BLOCK B4 WITH FRAME TITLE TEXT-075.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
SELECTION-SCREEN: END OF BLOCK B4.

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM READDATA.
  PERFORM GET_FCAT .
  PERFORM DISPLAYDATA.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
*BREAK PRIMUSABAP.
  SELECT OBJECTID
         TABKEY
         CHANGENR
         FNAME
         VALUE_NEW
         VALUE_OLD
         CHNGIND
         TABNAME
                   FROM CDPOS
                   INTO TABLE IT_CDPOS
                   WHERE OBJECTID IN S_VBELN
                   AND FNAME  IN ( 'WMENG' , 'NETPR' ,'LDDAT', 'MATNR' , 'LGORT' , 'ZTERM' , 'INCO1' , 'KUNNR' , 'KEY' ) .
  "THREE FNAME ADDED BY MADHAVI  "ZTERM = PAYMENT TERM CHANGE
  "INCO1 = Incoterm
  "KUNNR = SOLD TO PARTY

*IF  IT_VBAK IS INITIAL.
  SELECT VBELN
          POSNR
          MATNR
          KWMENG
          NETWR
          DELDATE
          WERKS   FROM VBAP
                  INTO TABLE IT_VBAP_NEW
                  WHERE VBELN IN S_VBELN
                  AND POSNR IN S_POSNR
                  AND WERKS EQ 'PL01'.
*ENDIF.
  IF S_AUDAT IS NOT INITIAL.
    SELECT * FROM VBAK
      INTO TABLE
      @DATA(IT_VBAK)
      FOR ALL ENTRIES IN @IT_VBAP_NEW
      WHERE AUDAT IN @S_AUDAT
      AND VBELN = @IT_VBAP_NEW-VBELN.

  ENDIF.

  IF IT_VBAK IS NOT INITIAL.
    SELECT VBELN
          POSNR
          MATNR
          KWMENG
          NETWR
          DELDATE
          WERKS   FROM VBAP
                  INTO TABLE IT_VBAP
                  FOR ALL ENTRIES IN IT_VBAK
                  WHERE VBELN EQ IT_VBAK-VBELN
*                 AND posnr IN s_posnr
                  AND WERKS EQ 'PL01'.
  ENDIF.

  IF IT_VBAP IS INITIAL.

    IT_VBAP  =  IT_VBAP_NEW.
  ENDIF.



  IF IT_CDPOS IS NOT INITIAL.


    SELECT UDATE
           USERNAME
           OBJECTID
           CHANGENR  FROM CDHDR
                     INTO TABLE IT_CDHDR
                     FOR ALL ENTRIES IN IT_CDPOS
                     WHERE  OBJECTID = IT_CDPOS-OBJECTID
                     AND    CHANGENR = IT_CDPOS-CHANGENR  .
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READDATA .
*  BREAK-POINT.
*  loop AT it_vbap INTO wa_vbap .
*     wa_final-matnr     = wa_vbap-matnr.
*      wa_final-objectid =  WA_VBAP-VBELN.
*      wa_final-tabkey =  WA_VBAP-POSNR.

DELETE  IT_CDPOS WHERE FNAME = 'KEY' AND TABNAME NE 'VBAP'.

  LOOP AT IT_CDPOS INTO WA_CDPOS ."'"WHERE objectid = wa_final-objectid
    " AND tabkey+15(4) = WA_VBAP-POSNR.
    WA_FINAL-FNAME    = WA_CDPOS-FNAME.
*      CASE wa_final-fname.
*      WHEN 'WMENG'.
    IF WA_FINAL-FNAME =  'WMENG'.
      WA_FINAL-KWMENG_NEW     = WA_CDPOS-VALUE_NEW.
      WA_FINAL-KWMENG_OLD     = WA_CDPOS-VALUE_OLD.
*       WHEN 'NETPR'.
    ELSEIF WA_FINAL-FNAME =  'NETPR'.
      WA_FINAL-NETWR_NEW     = WA_CDPOS-VALUE_NEW.
      WA_FINAL-NETWR_OLD     = WA_CDPOS-VALUE_OLD.
*      WHEN 'LDDAT'.
    ELSEIF WA_FINAL-FNAME =  'LDDAT'.
      WA_FINAL-DELDATE_NEW     = WA_CDPOS-VALUE_NEW.
      WA_FINAL-DELDATE_OLD     = WA_CDPOS-VALUE_OLD.
*      WHEN 'LGORT'.
    ELSEIF WA_FINAL-FNAME =  'LGORT'.
      WA_FINAL-LGORT_NEW     = WA_CDPOS-VALUE_NEW.
      WA_FINAL-LGORT_OLD     = WA_CDPOS-VALUE_OLD.
*      WHEN 'MATNR'.
    ELSEIF WA_FINAL-FNAME =  'MATNR'.
      WA_FINAL-MATNR_NEW     = WA_CDPOS-VALUE_NEW.
      WA_FINAL-MATNR_OLD     = WA_CDPOS-VALUE_OLD.

    ELSEIF WA_FINAL-FNAME = 'ZTERM'.
      WA_FINAL-ZTERM_NEW  = WA_CDPOS-VALUE_NEW.
      WA_FINAL-ZTERM_OLD = WA_CDPOS-VALUE_OLD.

    ELSEIF WA_FINAL-FNAME = 'INCO1'.
      WA_FINAL-INCO1_NEW   = WA_CDPOS-VALUE_NEW.
      WA_FINAL-INCO1_OLD   = WA_CDPOS-VALUE_OLD.

    ELSEIF WA_FINAL-FNAME = 'KUNNR'.
      WA_FINAL-KUNNR_NEW   = WA_CDPOS-VALUE_NEW.
      WA_FINAL-KUNNR_OLD  = WA_CDPOS-VALUE_OLD.

    ELSEIF WA_FINAL-FNAME = 'KEY'.
      WA_FINAL-KEY_NEW   = WA_CDPOS-TABKEY+15(4).


*      ENDCASE.
    ENDIF.
*      ENDLOOP.
    WA_FINAL-OBJECTID = WA_CDPOS-OBJECTID.
    WA_FINAL-TABKEY =  WA_CDPOS-TABKEY+15(4).
    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_FINAL-OBJECTID
                                             POSNR = WA_FINAL-TABKEY+15(4).

    READ TABLE IT_CDHDR INTO WA_CDHDR WITH KEY OBJECTID = WA_FINAL-OBJECTID
                                           CHANGENR = WA_CDPOS-CHANGENR .
    IF SY-SUBRC = 0.
      WA_FINAL-UDATE        = WA_CDHDR-UDATE.
      WA_FINAL-USERNAME     = WA_CDHDR-USERNAME.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR : WA_FINAL , WA_VBAP,WA_CDPOS,WA_CDHDR.
  ENDLOOP.
*  ENDLOOP.
*  DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING kwmeng_new kwmeng_old
*   netwr_NEW netwr_OLD deldate_new deldate_old
*   udate username .
*  DELETE IT_fINAL WHERE kwmeng_new IS INITIAL
*                  AND kwmeng_OLD IS INITIAL
*                  AND netwr_NEW IS INITIAL
*                  AND netwr_OLD IS INITIAL
*                  AND deldate_new IS INITIAL
*                  AND deldate_old IS INITIAL
*                  AND matnr_new IS INITIAL
*                  AND matnr_old IS INITIAL
*                  AND lgort_new IS INITIAL
*                  AND lgort_old IS INITIAL
*                   AND udate IS INITIAL
*                  AND username IS INITIAL.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_STR-OBJECTID =  WA_FINAL-OBJECTID.
      WA_STR-TABKEY =  WA_FINAL-TABKEY.
*      wa_str-MATNR =  wa_final-MATNR.
      WA_STR-KWMENG_NEW =  WA_FINAL-KWMENG_NEW.
      WA_STR-KWMENG_OLD =  WA_FINAL-KWMENG_OLD.
      WA_STR-NETWR_NEW =  WA_FINAL-NETWR_NEW.
      WA_STR-NETWR_OLD =  WA_FINAL-NETWR_OLD.
      WA_STR-MATNR_NEW =  WA_FINAL-MATNR_NEW.
      WA_STR-MATNR_OLD =  WA_FINAL-MATNR_OLD.
      WA_STR-LGORT_NEW =  WA_FINAL-LGORT_NEW.
      WA_STR-LGORT_OLD =  WA_FINAL-LGORT_OLD.

*      wa_str-DELDATE_NEW =  wa_final-DELDATE_NEW.
      IF WA_FINAL-DELDATE_NEW IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-DELDATE_NEW
          IMPORTING
            OUTPUT = WA_STR-DELDATE_NEW.

        CONCATENATE WA_STR-DELDATE_NEW+0(2) WA_STR-DELDATE_NEW+2(3) WA_STR-DELDATE_NEW+5(4)
                        INTO WA_STR-DELDATE_NEW SEPARATED BY '-'.

      ENDIF.
*      wa_str-DELDATE_OLD =  wa_final-DELDATE_OLD.
      IF WA_FINAL-DELDATE_OLD IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-DELDATE_OLD
          IMPORTING
            OUTPUT = WA_STR-DELDATE_OLD.

        CONCATENATE WA_STR-DELDATE_OLD+0(2) WA_STR-DELDATE_OLD+2(3) WA_STR-DELDATE_OLD+5(4)
                        INTO WA_STR-DELDATE_OLD SEPARATED BY '-'.

      ENDIF.


*      wa_str-UDATE =  wa_final-UDATE.

      WA_STR-USERNAME =  WA_FINAL-USERNAME.
      IF WA_FINAL-UDATE IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-UDATE
          IMPORTING
            OUTPUT = WA_STR-UDATE.

        CONCATENATE  WA_STR-UDATE+0(2)  WA_STR-UDATE+2(3)  WA_STR-UDATE+5(4)
                        INTO  WA_STR-UDATE SEPARATED BY '-'.

      ENDIF.
*       IF wa_final-ref_date IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_STR-REF_DATE.

      CONCATENATE WA_STR-REF_DATE+0(2) WA_STR-REF_DATE+2(3) WA_STR-REF_DATE+5(4)
                      INTO WA_STR-REF_DATE SEPARATED BY '-'.
      WA_STR-REF_TIME = SY-UZEIT. "added by jyoti on 29.04.2024
      CONCATENATE WA_STR-REF_TIME+0(2) ':' WA_STR-REF_TIME+2(2)  INTO WA_STR-REF_TIME.
      APPEND WA_STR TO LT_STR.
    ENDLOOP.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  get
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT.
  PERFORM FCAT USING :         '1'     'OBJECTID'       'IT_FINAL'  'sales order no'                    '10' ,
                               '2'     'TABKEY'         'IT_FINAL'  'Sales Order Item No'                             '20' ,
                               '5'     'MATNR_NEW'       'IT_FINAL' 'Material New Value'                                        '25' ,
                               '5'     'MATNR_OLD'      'IT_FINAL'  'Material Old Value'                                        '25' ,
                               '7'     'KWMENG_NEW '    'IT_FINAL'  'QTY New Value'                                    '13' ,
                               '8'     'KWMENG_OLD '    'IT_FINAL'  'QTY Old Value'                                    '13' ,
                               '9'     'NETWR_NEW '     'IT_FINAL'  'Rate New Value'                                   '13' ,
                              '10'     'NETWR_OLD'      'IT_FINAL'  'Rate Old Value'                                   '25' ,
                               '11'    'DELDATE_NEW'    'IT_FINAL'  'Delivery Date New Value'                          '15' ,
                               '12'    'DELDATE_OLD'    'IT_FINAL'  'Delivery Date Old Value'                          '15' ,
                               '15'    'LGORT_NEW'    'IT_FINAL'    'Storage Location New Value'                          '15' ,
                               '16'    'LGORT_OLD'    'IT_FINAL'    'Storage Location Old Value'                          '15' ,
                               '17'    'UDATE'          'IT_FINAL'  'Changed Date'                                     '27',
                               '18'    'USERNAME'       'IT_FINAL'  'Change By'                                       '25' ,
                              "ADDED BY MADHAVI
                               '19'    'ZTERM_NEW'       'IT_FINAL'  'Payment Term New Value'                                       '25' ,
                               '20'    'ZTERM_OLD'       'IT_FINAL'  'Payment Term Old Value'                                       '25' ,
                               '21'    'INCO1_NEW'       'IT_FINAL'  'Incoterm New Value'                                       '25' ,
                               '22'    'INCO1_OLD'       'IT_FINAL'  'Incoterm Old Value'                                       '25' ,
                               '23'    'KUNNR_NEW'       'IT_FINAL'  'Sold To Party New Code'                                       '25' ,
                               '24'    'KUNNR_OLD'       'IT_FINAL'  'Sold To Party Old Code'                                       '25' ,
                               '24'    'KEY_NEW'         'IT_FINAL'  'New Line Added'                                       '25' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form fCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0813   text
*      -->P_0814   text
*      -->P_0815   text
*      -->P_0816   text
*      -->P_0817   text
*----------------------------------------------------------------------*
FORM FCAT USING    VALUE(P_0813)
                    VALUE(P_0814)
                    VALUE(P_0815)
                    VALUE(P_0816)
                    VALUE(P_0817).

  WA_FCAT-COL_POS   = P_0813.
  WA_FCAT-FIELDNAME = P_0814.
  WA_FCAT-TABNAME   = P_0815.
  WA_FCAT-SELTEXT_L = P_0816.
* *WA_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P_0817.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAYDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAYDATA .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET    = ' '
*     I_CALLBACK_USER_COMMAND     = ' '
*     I_CALLBACK_TOP_OF_PAGE      = ' '
*     i_callback_html_top_of_page = 'TOP'
*     I_CALLBACK_HTML_END_OF_LIST = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      IS_LAYOUT          = LS_LAYOUT
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN       = 0
*     I_SCREEN_START_LINE         = 0
*     I_SCREEN_END_COLUMN         = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER  =
*  IMPORTING
*     E_EXIT_CAUSED_BY_CALLER     =
*     ES_EXIT_CAUSED_BY_USER      =
    TABLES
      T_OUTTAB           = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.


    PERFORM DOWNLOAD.
  ENDIF.

ENDFORM.

FORM TOP.
*  BREAK-POINT.
  DATA: LT_LISTHEADER TYPE TABLE OF SLIS_LISTHEADER,
        LS_LISTHEADER TYPE SLIS_LISTHEADER,
        LS_MONTH_NAME TYPE T7RU9A-REGNO,
        GS_STRING     TYPE STRING,
        GS_MONTH(2)   TYPE N,
        T_LINE        LIKE LS_LISTHEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

  REFRESH LT_LISTHEADER.
  CLEAR LS_LISTHEADER.

  LS_LISTHEADER-TYP = 'S'.
  LS_LISTHEADER-INFO =  '. '.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.

  GS_STRING = ''.
  GS_MONTH = SY-DATUM+4(2).
  CALL FUNCTION 'HR_RU_MONTH_NAME_IN_GENITIVE'
    EXPORTING
      MONTH = GS_MONTH
    IMPORTING
      NAME  = LS_MONTH_NAME.
*
  TRANSLATE LS_MONTH_NAME TO UPPER CASE.
*  CONCATENATE 'DAILY DISPATCH REPORT'." LS_MONTH_NAME SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ' '.
  LS_LISTHEADER-TYP = 'H'.
  LS_LISTHEADER-INFO = 'SALES ORDER CHANGE REPORT'."GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.

  GS_STRING = ''.
  CONCATENATE 'REPORT DATE :' SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ''.
  LS_LISTHEADER-TYP = 'S'.
  LS_LISTHEADER-INFO =  GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.

  GS_STRING = ''.
  LS_LISTHEADER-TYP = 'S'.
  LS_LISTHEADER-INFO =  GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.


  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.

  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' LD_LINESC
   INTO T_LINE SEPARATED BY SPACE.

  LS_LISTHEADER-TYP  = 'A'.
  LS_LISTHEADER-INFO = T_LINE.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.
  CLEAR: LS_LISTHEADER, T_LINE.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_LISTHEADER
      I_LOGO             = 'NEW_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  DOWNLOAD
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
FORM DOWNLOAD .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = LT_STR
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZSALES_ORD_CHANGE.TXT'.                    "TCODE-ZSALES_ORD_CHANGE

*  CONCATENATE p_folder '\' lv_file
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.
*BREAK primus.
  WRITE: / 'ZSALES_ORD_CHANGE DOWNLOAD STARTED ON', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_631 TYPE STRING.
    DATA LV_CRLF_631 TYPE STRING.
    LV_CRLF_631 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_631 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_631 LV_CRLF_631 WA_CSV INTO LV_STRING_631.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_631 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'sales order no'
              'Sales Order Item No'
              'Material New Value'
              'Material Old Value'
              'QTY New Value'
              'QTY Old Value'
              'Rate New Value'
              'Rate Old Value'
              'Delivery Date New Value'
              'Delivery Date Old Value'
              'Storage Location New Value'
              'Storage Location Old Value'
              'Changed Date'
              'Change By'
              'Refreshable Date'
              'Refreshable Time'
    INTO P_HD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
