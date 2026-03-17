*&---------------------------------------------------------------------*
*& Report ZBOM_ROUTING_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_BOM_ROUTING_REPORT.

TABLES: MARC.

TYPES: BEGIN OF TY_MAPL,
         MATNR TYPE MAPL-MATNR,
         WERKS TYPE MAPL-WERKS,
         PLNTY TYPE MAPL-PLNTY,
         PLNNR TYPE MAPL-PLNNR,
         PLNAL TYPE MAPL-PLNAL,
         ZAEHL TYPE MAPL-ZAEHL,
         ANDAT TYPE MAPL-ANDAT,
         DATUV TYPE MAPL-DATUV,
         LOEKZ TYPE MAPL-LOEKZ,
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
       END OF TY_PLPO.

TYPES: BEGIN OF TY_CRHD,
         OBJTY TYPE CRHD-OBJTY,
         OBJID TYPE CRHD-OBJID,
         ARBPL TYPE CRHD-ARBPL,
         WERKS TYPE CRHD-WERKS,
       END OF TY_CRHD.
TYPES : BEGIN OF TY_CRCO,
          OBJID TYPE CRHD-OBJID,
          KOSTL TYPE CRCO-KOSTL,
        END OF TY_CRCO.


TYPES : BEGIN OF TY_MARA,
          MATNR TYPE MARA-MATNR,
          MTART TYPE MARA-MTART,
          WERKS TYPE MARC-WERKS,
        END OF TY_MARA.

TYPES: BEGIN OF TY_FINAL,
         MATNR    TYPE MAPL-MATNR,
         WERKS    TYPE MAPL-WERKS,
         PLNTY    TYPE MAPL-PLNTY,
         PLNNR    TYPE MAPL-PLNNR,
         PLNAL    TYPE MAPL-PLNAL,
         ZAEHL    TYPE MAPL-ZAEHL,
         ANDAT    TYPE MAPL-ANDAT,
         DATUV    TYPE MAPL-DATUV,
         VERWE    TYPE PLKO-VERWE,
         STATU    TYPE PLKO-STATU,
         VORNR    TYPE PLPO-VORNR,
         STEUS    TYPE PLPO-STEUS,
         ARBID    TYPE PLPO-ARBID,
         OBJTY    TYPE PLPO-OBJTY,
         LTXA1    TYPE PLPO-LTXA1,
         LAR01    TYPE PLPO-LAR01,
         VGE01    TYPE PLPO-VGE01,
         VGW01    TYPE PLPO-VGW01,
         OBJID    TYPE CRHD-OBJID,
         ARBPL    TYPE CRHD-ARBPL,
         KOSTL    TYPE CRCO-KOSTL,
         ACT_TYPE TYPE DMBTR,
         ACT_COST TYPE DMBTR,
         MTART    TYPE MARA-MTART,
         LONG_TXT TYPE CHAR250,
         TOG001   TYPE COST-TOG001, "modified by PJ on 21-07-21
         TARKZ    TYPE COKL-TARKZ,

       END OF TY_FINAL,

       BEGIN OF TY_DOWN,
         MATNR    TYPE CHAR20,
         LONG_TXT TYPE CHAR250,
         WERKS    TYPE CHAR15,
         MTART    TYPE CHAR15,
         PLNTY    TYPE CHAR15,
         PLNNR    TYPE CHAR15,
         PLNAL    TYPE CHAR15,
         ZAEHL    TYPE CHAR15,
         VERWE    TYPE CHAR15,
         STATU    TYPE CHAR15,
         VORNR    TYPE CHAR15,
         STEUS    TYPE CHAR15,
         OBJTY    TYPE CHAR15,
         LTXA1    TYPE CHAR50,
         LAR01    TYPE CHAR15,
         VGE01    TYPE CHAR15,
         VGW01    TYPE CHAR15,
         ARBPL    TYPE CHAR15,
         KOSTL    TYPE CHAR15,
         DATUV    TYPE CHAR15,
         TARKZ    TYPE CHAR15,
         REF      TYPE CHAR15,
         TIME     TYPE CHAR10,
         TOG001   TYPE CHAR10,
       END OF TY_DOWN.



DATA: IT_MAPL TYPE TABLE OF TY_MAPL,
      WA_MAPL TYPE TY_MAPL.
DATA: IT_PLKO TYPE TABLE OF TY_PLKO,
      WA_PLKO TYPE TY_PLKO.
DATA: IT_CRHD TYPE TABLE OF TY_CRHD,
      WA_CRHD TYPE TY_CRHD.
DATA: IT_CRCO TYPE TABLE OF TY_CRCO,
      WA_CRCO TYPE TY_CRCO.
DATA: IT_PLPO TYPE TABLE OF TY_PLPO,
      WA_PLPO TYPE TY_PLPO.

DATA : IT_MARA TYPE TABLE OF TY_MARA,
       WA_MARA TYPE          TY_MARA.

DATA : IT_COST  TYPE TABLE OF COST,
       WA_COST  TYPE COST,
       ACT_TYPE TYPE STRING.

DATA: IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE TY_FINAL,

      IT_DOWN  TYPE TABLE OF TY_DOWN,
      WA_DOWN  TYPE          TY_DOWN.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA:
  LV_ID    TYPE THEAD-TDNAME,
  IT_LINES TYPE STANDARD TABLE OF TLINE,
  WA_LINES TYPE TLINE.

*MODIFIED on 19-07-21. by PJ
DATA: GJAHR(4) TYPE N,
      MONAT    TYPE BKPF-MONAT,
      V_OBJNR  TYPE CSSL-OBJNR,
      V_TOG    TYPE C LENGTH 6.
TYPES : BEGIN OF TY_COST,
          TOG001 TYPE COST-TOG001,
          TOG002 TYPE COST-TOG002,
          TOG003 TYPE COST-TOG003,
          TOG004 TYPE COST-TOG004,
          TOG005 TYPE COST-TOG005,
          TOG006 TYPE COST-TOG006,
          TOG007 TYPE COST-TOG007,
          TOG008 TYPE COST-TOG008,
          TOG009 TYPE COST-TOG009,
          TOG010 TYPE COST-TOG010,
          TOG011 TYPE COST-TOG011,
          TOG012 TYPE COST-TOG012,
        END OF TY_COST.

DATA : IT_COST1 TYPE TABLE OF TY_COST,
       WA_COST1 TYPE TY_COST.
*end of modification.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS : S_WERKS  FOR MARC-WERKS  NO INTERVALS OBLIGATORY DEFAULT 'SU01' MODIF ID BU.
*PARAMETERS : s_werks  TYPE marc-werks OBLIGATORY DEFAULT 'SUOO'.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."SAUDI'. "'E:/delval/SAUDI'
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

*  IF S_WERKS EQ 'SU01'.
*
    PERFORM FETCH_DATA.
    PERFORM SORT_DATA.
    PERFORM GET_FCAT.
    PERFORM GET_DISPLAY.
*  ELSE.
*    MESSAGE 'This Report For Plant SU01' TYPE 'E'.

*  ENDIF.




*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FETCH_DATA .

  SELECT A~MATNR
         A~MTART
         B~WERKS
         FROM MARA AS A INNER JOIN MARC AS B
         ON A~MATNR = B~MATNR
         INTO TABLE IT_MARA
         WHERE MTART IN ('HALB','FERT')
          AND  WERKS IN S_WERKS.


  IF IT_MARA IS NOT INITIAL .
    SELECT MATNR
           WERKS
           PLNTY
           PLNNR
           PLNAL
           ZAEHL
           ANDAT
           DATUV
           LOEKZ FROM MAPL
           INTO TABLE IT_MAPL
           FOR ALL ENTRIES IN IT_MARA
           WHERE MATNR = IT_MARA-MATNR
             AND WERKS = IT_MARA-WERKS
             AND PLNTY = 'N'
             AND LOEKZ NE 'X'.
  ENDIF.

  IF IT_MAPL IS NOT INITIAL.


    SELECT PLNTY
           PLNNR
           PLNAL
           ZAEHL
           VERWE
           WERKS
           STATU FROM PLKO
           INTO TABLE IT_PLKO
           FOR ALL ENTRIES IN IT_MAPL
           WHERE PLNTY = IT_MAPL-PLNTY
             AND PLNNR = IT_MAPL-PLNNR
             AND WERKS = IT_MAPL-WERKS
             AND PLNAL = IT_MAPL-PLNAL
             AND ZAEHL = IT_MAPL-ZAEHL.
  ENDIF.    .
  IF IT_PLKO IS NOT INITIAL.

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
           INTO TABLE IT_PLPO
           FOR ALL ENTRIES IN IT_MAPL
           WHERE PLNTY = IT_MAPL-PLNTY
             AND PLNNR = IT_MAPL-PLNNR
             AND ZAEHL = IT_MAPL-ZAEHL.
  ENDIF.
  IF IT_PLPO IS NOT INITIAL.
    SELECT OBJTY
           OBJID
           ARBPL
           WERKS
           FROM CRHD INTO TABLE IT_CRHD
           FOR ALL ENTRIES IN IT_PLPO
           WHERE OBJID = IT_PLPO-ARBID.
    "AND OBJID = LT_PLPO-NETID.

    SELECT OBJID
           KOSTL FROM CRCO INTO TABLE IT_CRCO
           FOR ALL ENTRIES IN IT_PLPO
           WHERE OBJID = IT_PLPO-ARBID.
  ENDIF.


*SELECT OBJNR
*       GJAHR
*       TKG001
*       TKG002
*       TKG003
*       TKG004
*       TKG005
*       TKG006
*       TKG007
*       TKG008
*       TKG009
*       TKG010
*       TKG011
*       TKG012
*       TKG013
*       TKG014
*       TKG015
*       TKG016
*   FROM COST
*   INTO CORRESPONDING FIELDS OF TABLE IT_COST
*   WHERE GJAHR = S_GJAHR.
*ENDIF.





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_DATA .

  LOOP AT IT_MAPL INTO WA_MAPL.
    WA_FINAL-MATNR = WA_MAPL-MATNR.
    WA_FINAL-WERKS = WA_MAPL-WERKS.
    WA_FINAL-PLNTY = WA_MAPL-PLNTY.
    WA_FINAL-PLNNR = WA_MAPL-PLNNR.
    WA_FINAL-PLNAL = WA_MAPL-PLNAL.
    WA_FINAL-ZAEHL = WA_MAPL-ZAEHL.
    WA_FINAL-ANDAT = WA_MAPL-ANDAT.
    WA_FINAL-DATUV = WA_MAPL-DATUV.



    CLEAR: IT_LINES,WA_LINES,LV_ID.
    LV_ID = WA_FINAL-MATNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = IT_LINES
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.
    IF NOT IT_LINES IS INITIAL.
      LOOP AT IT_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-LONG_TXT WA_LINES-TDLINE INTO WA_FINAL-LONG_TXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-LONG_TXT.
    ENDIF.



    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_FINAL-MATNR WERKS = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA-MTART.
    ENDIF.

    READ TABLE IT_PLKO INTO WA_PLKO WITH KEY PLNTY = WA_MAPL-PLNTY PLNNR = WA_MAPL-PLNNR WERKS = WA_MAPL-WERKS ZAEHL = WA_MAPL-ZAEHL.
    IF SY-SUBRC = 0.
      WA_FINAL-VERWE = WA_PLKO-VERWE.
      WA_FINAL-STATU = WA_PLKO-STATU.
    ENDIF.

    READ TABLE IT_PLPO INTO WA_PLPO WITH KEY PLNTY = WA_MAPL-PLNTY PLNNR = WA_MAPL-PLNNR ZAEHL = WA_MAPL-ZAEHL.
    IF SY-SUBRC = 0.
      WA_FINAL-VORNR = WA_PLPO-VORNR.
      WA_FINAL-STEUS = WA_PLPO-STEUS.
      WA_FINAL-LTXA1 = WA_PLPO-LTXA1.
      WA_FINAL-LAR01 = WA_PLPO-LAR01.
      WA_FINAL-VGE01 = WA_PLPO-VGE01.
      WA_FINAL-VGW01 = WA_PLPO-VGW01.
    ENDIF.

    READ TABLE IT_CRHD INTO WA_CRHD WITH KEY OBJID = WA_PLPO-ARBID.
    IF SY-SUBRC = 0.
      WA_FINAL-OBJID = WA_CRHD-OBJID.
      WA_FINAL-OBJTY = WA_CRHD-OBJTY.
      WA_FINAL-ARBPL = WA_CRHD-ARBPL.
    ENDIF.

    READ TABLE IT_CRCO INTO WA_CRCO WITH KEY OBJID = WA_PLPO-ARBID.
    IF SY-SUBRC = 0.
      WA_FINAL-KOSTL = WA_CRCO-KOSTL.
    ENDIF.

*break primus.changeon 19/07/21 by PJ

    CALL FUNCTION 'FI_PERIOD_DETERMINE'
      EXPORTING
        I_BUDAT        = SY-DATUM
        I_BUKRS        = '1000'
*       I_RLDNR        = ' '
*       I_PERIV        = ' '
*       I_GJAHR        = 0000
*       I_MONAT        = 00
*       X_XMO16        = ' '
      IMPORTING
        E_GJAHR        = GJAHR
        E_MONAT        = MONAT
*       E_POPER        =
      EXCEPTIONS
        FISCAL_YEAR    = 1
        PERIOD         = 2
        PERIOD_VERSION = 3
        POSTING_PERIOD = 4
        SPECIAL_PERIOD = 5
        VERSION        = 6
        POSTING_DATE   = 7
        OTHERS         = 8.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    SELECT SINGLE OBJNR INTO V_OBJNR FROM CSSL WHERE KOSTL = WA_FINAL-KOSTL AND LSTAR = WA_PLPO-LAR01 AND GJAHR = GJAHR.
    IF V_OBJNR IS NOT INITIAL.

      SELECT TOG001 TOG002 TOG003 TOG004 TOG005 TOG006 TOG007 TOG008 TOG009 TOG010 TOG011 TOG012
        FROM COST INTO TABLE IT_COST1
        WHERE OBJNR = V_OBJNR
        AND GJAHR = GJAHR.
      LOOP AT IT_COST1 INTO WA_COST1.
        CLEAR WA_FINAL-TOG001.
        IF MONAT = '01'.
          WA_FINAL-TOG001 = WA_COST1-TOG001.
        ELSEIF MONAT = '02'.
          WA_FINAL-TOG001 = WA_COST1-TOG002.
        ELSEIF MONAT = '03'.
          WA_FINAL-TOG001 = WA_COST1-TOG003.
        ELSEIF MONAT = '04'.
          WA_FINAL-TOG001 = WA_COST1-TOG004.
        ELSEIF MONAT = '05'.
          WA_FINAL-TOG001 = WA_COST1-TOG005.
        ELSEIF MONAT = '06'.
          WA_FINAL-TOG001 = WA_COST1-TOG006.
        ELSEIF MONAT = '07'.
          WA_FINAL-TOG001 = WA_COST1-TOG007.
        ELSEIF MONAT = '08'.
          WA_FINAL-TOG001 = WA_COST1-TOG008.
        ELSEIF MONAT = '09'.
          WA_FINAL-TOG001 = WA_COST1-TOG009.
        ELSEIF MONAT = '10'.
          WA_FINAL-TOG001 = WA_COST1-TOG010.
        ELSEIF MONAT = '11'.
          WA_FINAL-TOG001 = WA_COST1-TOG011.
        ELSEIF MONAT = '12'.
          WA_FINAL-TOG001 = WA_COST1-TOG012.
        ENDIF.


      ENDLOOP.

    ENDIF.



*    SELECT SINGLE LSTAR FROM  crco INTO @DATA(lv_LSTAR) WHERE kostl = @WA_FINAL-KOSTL.
*
*    SELECT SINGLE TARKZ FROM COKL INTO wa_final-TARKZ WHERE
*                                                   lLSTAR =  lv_LSTAR.



    CONCATENATE 'KLDL00' WA_FINAL-KOSTL WA_FINAL-LAR01 INTO ACT_TYPE.

    DATA : PER  TYPE CHAR2,
           TKG1 TYPE STRING.

    READ TABLE IT_COST INTO WA_COST WITH KEY OBJNR = ACT_TYPE.
    IF SY-SUBRC = 0.
********<<<uncommented By Ajay >>>>>>>>>>>>>>>>
*CASE S_PERIOD.
*WHEN '1'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG001.
*WHEN '2'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG002.
*WHEN '3'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG003.
*WHEN '4'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG004.
*WHEN '5'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG005.
*WHEN '6'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG006.
*WHEN '7'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG007.
*WHEN '8'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG008.
*WHEN '9'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG009.
*WHEN '10'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG010.
*WHEN '11'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG011.
*WHEN '12'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG012.
*WHEN '13'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG013.
*WHEN '14'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG014.
*WHEN '15'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG015.
*WHEN '16'.
*wa_FINAL-ACT_TYPE = WA_COST-TKG016.
*ENDCASE.

*********      <<<<<<<<<<<<
    ENDIF.

    WA_FINAL-ACT_COST = WA_FINAL-VGW01 * WA_FINAL-ACT_TYPE.

************ ENDED **************************

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.

  ENDLOOP.


  IF P_DOWN = 'X'..
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MATNR    = WA_FINAL-MATNR   .
      WA_DOWN-LONG_TXT = WA_FINAL-LONG_TXT.
      WA_DOWN-WERKS    = WA_FINAL-WERKS   .
      WA_DOWN-MTART    = WA_FINAL-MTART   .
      WA_DOWN-PLNTY    = WA_FINAL-PLNTY   .
      WA_DOWN-PLNNR    = WA_FINAL-PLNNR   .
      WA_DOWN-PLNAL    = WA_FINAL-PLNAL   .
      WA_DOWN-ZAEHL    = WA_FINAL-ZAEHL   .
      WA_DOWN-VERWE    = WA_FINAL-VERWE   .
      WA_DOWN-STATU    = WA_FINAL-STATU   .
      WA_DOWN-VORNR    = WA_FINAL-VORNR   .
      WA_DOWN-STEUS    = WA_FINAL-STEUS   .
      WA_DOWN-OBJTY    = WA_FINAL-OBJTY   .
      WA_DOWN-LTXA1    = WA_FINAL-LTXA1   .
      WA_DOWN-LAR01    = WA_FINAL-LAR01   .
      WA_DOWN-VGE01    = WA_FINAL-VGE01   .
      WA_DOWN-VGW01    = WA_FINAL-VGW01   .
      WA_DOWN-ARBPL    = WA_FINAL-ARBPL   .
      WA_DOWN-KOSTL    = WA_FINAL-KOSTL   .
      WA_DOWN-TARKZ    = WA_FINAL-TARKZ   .
      WA_DOWN-DATUV    = WA_FINAL-DATUV   .
*    wa_down-ref      = wa_final-ref     .
      WA_DOWN-TOG001    = WA_FINAL-TOG001."MODIFIED ON20-07-21 BYpj

      IF WA_FINAL-DATUV IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-DATUV
          IMPORTING
            OUTPUT = WA_DOWN-DATUV.

        CONCATENATE WA_DOWN-DATUV+0(2) WA_DOWN-DATUV+2(3) WA_DOWN-DATUV+5(4)
                        INTO WA_DOWN-DATUV SEPARATED BY '-'.
      ENDIF.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO WA_DOWN-TIME SEPARATED BY ':'.
      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
    ENDLOOP.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
  PERFORM FCAT USING :
                       '1'   'MATNR'           'IT_FINAL'      'Material '                                   '20' ,
                       '2'   'LONG_TXT'        'IT_FINAL'      'Material Description '                       '20' ,
                       '3'   'WERKS'           'IT_FINAL'      'Plant '                                      '10' ,
                       '4'   'MTART'           'IT_FINAL'      'Material Type '                              '18' ,
                       '5'   'PLNTY'           'IT_FINAL'      'Task List Type'                              '20',
                       '6'   'PLNNR'           'IT_FINAL'      'Group'                                       '10',
                       '7'   'PLNAL'           'IT_FINAL'      'Group Counter'                               '15',
                       '8'   'ZAEHL'           'IT_FINAL'      'Counter'                                     '15',
                       '9'   'VERWE'           'IT_FINAL'      'Task list usage'                             '15',
                      '10'   'STATU'           'IT_FINAL'      'Status'                                      '10',
                      '11'   'VORNR'           'IT_FINAL'      'Activity Number'                             '15',
                      '12'   'STEUS'           'IT_FINAL'      'Control key'                                 '15',
                      '13'   'OBJTY'           'IT_FINAL'      'Object Type'                                 '10',
                      '14'   'LTXA1'           'IT_FINAL'      'Operation short text'                        '20',
                      '15'   'LAR01'           'IT_FINAL'      'Description of standard value 1'             '20',
                      '16'   'VGE01'           'IT_FINAL'      'Unit of Measurement of Standard Value'       '10',
                      '17'   'VGW01'           'IT_FINAL'      'Std.Value'                                   '10',
                      '18'   'ARBPL'           'IT_FINAL'      'Work center'                                 '10',
                      '19'   'KOSTL'           'IT_FINAL'      'Cost center'                                 '10',
                      '20'   'DATUV'           'IT_FINAL'      'Valid-from'                                  '10',
*                      '21'   'TARKZ'           'IT_FINAL'      'Activity Rate'                                  '10', "MODIFIED ON20-07-21 BYpj
                      '22'   'TOG001'           'IT_FINAL'      'Activity Rate'                                  '10'. "MODIFIED ON20-07-21 BYpj


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0835   text
*      -->P_0836   text
*      -->P_0837   text
*      -->P_0838   text
*      -->P_0839   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
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
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
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

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
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


  LV_FILE = 'ZSU_ROUTING_DETAIL.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_ROUTING DETAIL REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_800 TYPE string.
DATA lv_crlf_800 TYPE string.
lv_crlf_800 = cl_abap_char_utilities=>cr_lf.
lv_string_800 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_800 lv_crlf_800 wa_csv INTO lv_string_800.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_800 TO lv_fullfile.
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
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Material '
              'Material Description '
              'Plant '
              'Material Type '
              'Task List Type'
              'Group'
              'Group Counter'
              'Counter'
              'Task list usage'
              'Status'
              'Activity Number'
              'Control key'
              'Object Type'
              'Operation short text'
              'Description of standard value 1'
              'Unit of Measurement of Standard Value'
              'Std.Value'
              'Work center'
              'Cost center'
              'Valid-from'
              'Plan Price Indicator'
              'Refresh Date'
              'Refresh Time'
              'Activity Rate'
               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
