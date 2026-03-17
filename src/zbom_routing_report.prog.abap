*&---------------------------------------------------------------------*
*& Report ZBOM_ROUTING_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbom_routing_report.

TABLES: marc.

TYPES: BEGIN OF ty_mapl,
         matnr TYPE mapl-matnr,
         werks TYPE mapl-werks,
         plnty TYPE mapl-plnty,
         plnnr TYPE mapl-plnnr,
         plnal TYPE mapl-plnal,
         zaehl TYPE mapl-zaehl,
         andat TYPE mapl-andat,
         datuv TYPE mapl-datuv,
         loekz TYPE mapl-loekz,
       END OF ty_mapl.

TYPES: BEGIN OF ty_plko,
         plnty TYPE plko-plnty,
         plnnr TYPE plko-plnnr,
         plnal TYPE plko-plnal,
         zaehl TYPE plko-zaehl,
         verwe TYPE plko-verwe,
         werks TYPE plko-werks,
         statu TYPE plko-statu,
       END OF ty_plko.

TYPES: BEGIN OF ty_plpo,
         plnty TYPE plpo-plnty,
         plnnr TYPE plpo-plnnr,
         zaehl TYPE plpo-zaehl,
         vornr TYPE plpo-vornr,
         steus TYPE plpo-steus,
         arbid TYPE plpo-arbid,
         objty TYPE plpo-objty,
         werks TYPE plpo-werks,
         ltxa1 TYPE plpo-ltxa1,
         lar01 TYPE plpo-lar01,
         vge01 TYPE plpo-vge01,
         vgw01 TYPE plpo-vgw01,
       END OF ty_plpo.

TYPES: BEGIN OF ty_crhd,
         objty TYPE crhd-objty,
         objid TYPE crhd-objid,
         arbpl TYPE crhd-arbpl,
         werks TYPE crhd-werks,
       END OF ty_crhd.
TYPES : BEGIN OF ty_crco,
          objid TYPE crhd-objid,
          kostl TYPE crco-kostl,
        END OF ty_crco.


TYPES : BEGIN OF ty_mara,
          matnr TYPE mara-matnr,
          mtart TYPE mara-mtart,
          werks TYPE marc-werks,
        END OF ty_mara.

TYPES: BEGIN OF ty_final,
         matnr    TYPE mapl-matnr,
         werks    TYPE mapl-werks,
         plnty    TYPE mapl-plnty,
         plnnr    TYPE mapl-plnnr,
         plnal    TYPE mapl-plnal,
         zaehl    TYPE mapl-zaehl,
         andat    TYPE mapl-andat,
         datuv    TYPE mapl-datuv,
         verwe    TYPE plko-verwe,
         statu    TYPE plko-statu,
         vornr    TYPE plpo-vornr,
         steus    TYPE plpo-steus,
         arbid    TYPE plpo-arbid,
         objty    TYPE plpo-objty,
         ltxa1    TYPE plpo-ltxa1,
         lar01    TYPE plpo-lar01,
         vge01    TYPE plpo-vge01,
         vgw01    TYPE plpo-vgw01,
         objid    TYPE crhd-objid,
         arbpl    TYPE crhd-arbpl,
         kostl    TYPE crco-kostl,
         act_type TYPE dmbtr,
         act_cost TYPE dmbtr,
         mtart    TYPE mara-mtart,
         long_txt TYPE char250,
         tog001   TYPE cost-tog001, "modified by PJ on 21-07-21
         tarkz    TYPE cokl-tarkz,

       END OF ty_final,

       BEGIN OF ty_down,
         matnr    TYPE char20,
         long_txt TYPE char250,
         werks    TYPE char15,
         mtart    TYPE char15,
         plnty    TYPE char15,
         plnnr    TYPE char15,
         plnal    TYPE char15,
         zaehl    TYPE char15,
         verwe    TYPE char15,
         statu    TYPE char15,
         vornr    TYPE char15,
         steus    TYPE char15,
         objty    TYPE char15,
         ltxa1    TYPE char50,
         lar01    TYPE char15,
         vge01    TYPE char15,
         vgw01    TYPE char15,
         arbpl    TYPE char15,
         kostl    TYPE char15,
         datuv    TYPE char15,
         tarkz    TYPE char15,
         ref      TYPE char15,
         time     TYPE char10,
         tog001   TYPE char10,
       END OF ty_down.



DATA: it_mapl TYPE TABLE OF ty_mapl,
      wa_mapl TYPE ty_mapl.
DATA: it_plko TYPE TABLE OF ty_plko,
      wa_plko TYPE ty_plko.
DATA: it_crhd TYPE TABLE OF ty_crhd,
      wa_crhd TYPE ty_crhd.
DATA: it_crco TYPE TABLE OF ty_crco,
      wa_crco TYPE ty_crco.
DATA: it_plpo TYPE TABLE OF ty_plpo,
      wa_plpo TYPE ty_plpo.

DATA : it_mara TYPE TABLE OF ty_mara,
       wa_mara TYPE          ty_mara.

DATA : it_cost  TYPE TABLE OF cost,
       wa_cost  TYPE cost,
       act_type TYPE string.

DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final,

      it_down  TYPE TABLE OF ty_down,
      wa_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA:
  lv_id    TYPE thead-tdname,
  it_lines TYPE STANDARD TABLE OF tline,
  wa_lines TYPE tline.

*MODIFIED on 19-07-21. by PJ
DATA: gjahr(4) TYPE n,
      monat    TYPE bkpf-monat,
      v_objnr  TYPE cssl-objnr,
      v_tog    TYPE c LENGTH 6.
TYPES : BEGIN OF ty_cost,
          tog001 TYPE cost-tog001,
          tog002 TYPE cost-tog002,
          tog003 TYPE cost-tog003,
          tog004 TYPE cost-tog004,
          tog005 TYPE cost-tog005,
          tog006 TYPE cost-tog006,
          tog007 TYPE cost-tog007,
          tog008 TYPE cost-tog008,
          tog009 TYPE cost-tog009,
          tog010 TYPE cost-tog010,
          tog011 TYPE cost-tog011,
          tog012 TYPE cost-tog012,
        END OF ty_cost.

DATA : it_cost1 TYPE TABLE OF ty_cost,
       wa_cost1 TYPE ty_cost.
*end of modification.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
*SELECT-OPTIONS : s_werks  FOR marc-werks  NO INTERVALS OBLIGATORY DEFAULT 'PL01'.
PARAMETERS : s_werks  TYPE marc-werks OBLIGATORY DEFAULT 'PL01'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp'."'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.

  IF s_werks EQ 'PL01'.

    PERFORM fetch_data.
    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM get_display.
  ELSE.
    MESSAGE 'This Report For Plant PL01' TYPE 'E'.

  ENDIF.




*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  SELECT a~matnr
         a~mtart
         b~werks
         FROM mara AS a INNER JOIN marc AS b
         ON a~matnr = b~matnr
         INTO TABLE it_mara
         WHERE mtart IN ('HALB','FERT')
          AND  werks = s_werks.


  IF it_mara IS NOT INITIAL .
    SELECT matnr
           werks
           plnty
           plnnr
           plnal
           zaehl
           andat
           datuv
           loekz FROM mapl
           INTO TABLE it_mapl
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
             AND werks = it_mara-werks
             AND plnty = 'N'
             AND loekz NE 'X'.
  ENDIF.

  IF it_mapl IS NOT INITIAL.


    SELECT plnty
           plnnr
           plnal
           zaehl
           verwe
           werks
           statu FROM plko
           INTO TABLE it_plko
           FOR ALL ENTRIES IN it_mapl
           WHERE plnty = it_mapl-plnty
             AND plnnr = it_mapl-plnnr
             AND werks = it_mapl-werks
             AND plnal = it_mapl-plnal
             AND zaehl = it_mapl-zaehl.
  ENDIF.    .
  IF it_plko IS NOT INITIAL.

    SELECT plnty
           plnnr
           zaehl
           vornr
           steus
           arbid
           objty
           werks
           ltxa1
           lar01
           vge01
           vgw01 FROM plpo
           INTO TABLE it_plpo
           FOR ALL ENTRIES IN it_mapl
           WHERE plnty = it_mapl-plnty
             AND plnnr = it_mapl-plnnr
             AND zaehl = it_mapl-zaehl.
  ENDIF.
  IF it_plpo IS NOT INITIAL.
    SELECT objty
           objid
           arbpl
           werks
           FROM crhd INTO TABLE it_crhd
           FOR ALL ENTRIES IN it_plpo
           WHERE objid = it_plpo-arbid.
    "AND OBJID = LT_PLPO-NETID.

    SELECT objid
           kostl FROM crco INTO TABLE it_crco
           FOR ALL ENTRIES IN it_plpo
           WHERE objid = it_plpo-arbid.
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
FORM sort_data .

  LOOP AT it_mapl INTO wa_mapl.
    wa_final-matnr = wa_mapl-matnr.
    wa_final-werks = wa_mapl-werks.
    wa_final-plnty = wa_mapl-plnty.
    wa_final-plnnr = wa_mapl-plnnr.
    wa_final-plnal = wa_mapl-plnal.
    wa_final-zaehl = wa_mapl-zaehl.
    wa_final-andat = wa_mapl-andat.
    wa_final-datuv = wa_mapl-datuv.



    CLEAR: it_lines,wa_lines,lv_id.
    lv_id = wa_final-matnr.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_id
        object                  = 'MATERIAL'
      TABLES
        lines                   = it_lines
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
* Implement suitable error handling here
    ENDIF.
    IF NOT it_lines IS INITIAL.
      LOOP AT it_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-long_txt wa_lines-tdline INTO wa_final-long_txt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-long_txt.
    ENDIF.



    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_final-matnr werks = wa_final-werks.
    IF sy-subrc = 0.
      wa_final-mtart = wa_mara-mtart.
    ENDIF.

    READ TABLE it_plko INTO wa_plko WITH KEY plnty = wa_mapl-plnty plnnr = wa_mapl-plnnr werks = wa_mapl-werks zaehl = wa_mapl-zaehl.
    IF sy-subrc = 0.
      wa_final-verwe = wa_plko-verwe.
      wa_final-statu = wa_plko-statu.
    ENDIF.

    READ TABLE it_plpo INTO wa_plpo WITH KEY plnty = wa_mapl-plnty plnnr = wa_mapl-plnnr zaehl = wa_mapl-zaehl.
    IF sy-subrc = 0.
      wa_final-vornr = wa_plpo-vornr.
      wa_final-steus = wa_plpo-steus.
      wa_final-ltxa1 = wa_plpo-ltxa1.
      wa_final-lar01 = wa_plpo-lar01.
      wa_final-vge01 = wa_plpo-vge01.
      wa_final-vgw01 = wa_plpo-vgw01.
    ENDIF.

    READ TABLE it_crhd INTO wa_crhd WITH KEY objid = wa_plpo-arbid.
    IF sy-subrc = 0.
      wa_final-objid = wa_crhd-objid.
      wa_final-objty = wa_crhd-objty.
      wa_final-arbpl = wa_crhd-arbpl.
    ENDIF.

    READ TABLE it_crco INTO wa_crco WITH KEY objid = wa_plpo-arbid.
    IF sy-subrc = 0.
      wa_final-kostl = wa_crco-kostl.
    ENDIF.

*break primus.changeon 19/07/21 by PJ

    CALL FUNCTION 'FI_PERIOD_DETERMINE'
      EXPORTING
        i_budat        = sy-datum
        i_bukrs        = '1000'
*       I_RLDNR        = ' '
*       I_PERIV        = ' '
*       I_GJAHR        = 0000
*       I_MONAT        = 00
*       X_XMO16        = ' '
      IMPORTING
        e_gjahr        = gjahr
        e_monat        = monat
*       E_POPER        =
      EXCEPTIONS
        fiscal_year    = 1
        period         = 2
        period_version = 3
        posting_period = 4
        special_period = 5
        version        = 6
        posting_date   = 7
        OTHERS         = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    SELECT SINGLE objnr INTO v_objnr FROM cssl WHERE kostl = wa_final-kostl AND lstar = wa_plpo-lar01 AND gjahr = gjahr.
    IF v_objnr IS NOT INITIAL.

      SELECT tog001 tog002 tog003 tog004 tog005 tog006 tog007 tog008 tog009 tog010 tog011 tog012
        FROM cost INTO TABLE it_cost1
        WHERE objnr = v_objnr
        AND gjahr = gjahr.
      LOOP AT it_cost1 INTO wa_cost1.
        CLEAR wa_final-tog001.
        IF monat = '01'.
          wa_final-tog001 = wa_cost1-tog001.
        ELSEIF monat = '02'.
          wa_final-tog001 = wa_cost1-tog002.
        ELSEIF monat = '03'.
          wa_final-tog001 = wa_cost1-tog003.
        ELSEIF monat = '04'.
          wa_final-tog001 = wa_cost1-tog004.
        ELSEIF monat = '05'.
          wa_final-tog001 = wa_cost1-tog005.
        ELSEIF monat = '06'.
          wa_final-tog001 = wa_cost1-tog006.
        ELSEIF monat = '07'.
          wa_final-tog001 = wa_cost1-tog007.
        ELSEIF monat = '08'.
          wa_final-tog001 = wa_cost1-tog008.
        ELSEIF monat = '09'.
          wa_final-tog001 = wa_cost1-tog009.
        ELSEIF monat = '10'.
          wa_final-tog001 = wa_cost1-tog010.
        ELSEIF monat = '11'.
          wa_final-tog001 = wa_cost1-tog011.
        ELSEIF monat = '12'.
          wa_final-tog001 = wa_cost1-tog012.
        ENDIF.


      ENDLOOP.

    ENDIF.



*    SELECT SINGLE LSTAR FROM  crco INTO @DATA(lv_LSTAR) WHERE kostl = @WA_FINAL-KOSTL.
*
*    SELECT SINGLE TARKZ FROM COKL INTO wa_final-TARKZ WHERE
*                                                   lLSTAR =  lv_LSTAR.



    CONCATENATE 'KLDL00' wa_final-kostl wa_final-lar01 INTO act_type.

    DATA : per  TYPE char2,
           tkg1 TYPE string.

    READ TABLE it_cost INTO wa_cost WITH KEY objnr = act_type.
    IF sy-subrc = 0.
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

    wa_final-act_cost = wa_final-vgw01 * wa_final-act_type.

************ ENDED **************************

    APPEND wa_final TO it_final.
    CLEAR wa_final.

  ENDLOOP.


  IF p_down = 'X'..
    LOOP AT it_final INTO wa_final.
      wa_down-matnr    = wa_final-matnr   .
      wa_down-long_txt = wa_final-long_txt.
      wa_down-werks    = wa_final-werks   .
      wa_down-mtart    = wa_final-mtart   .
      wa_down-plnty    = wa_final-plnty   .
      wa_down-plnnr    = wa_final-plnnr   .
      wa_down-plnal    = wa_final-plnal   .
      wa_down-zaehl    = wa_final-zaehl   .
      wa_down-verwe    = wa_final-verwe   .
      wa_down-statu    = wa_final-statu   .
      wa_down-vornr    = wa_final-vornr   .
      wa_down-steus    = wa_final-steus   .
      wa_down-objty    = wa_final-objty   .
      wa_down-ltxa1    = wa_final-ltxa1   .
      wa_down-lar01    = wa_final-lar01   .
      wa_down-vge01    = wa_final-vge01   .
      wa_down-vgw01    = wa_final-vgw01   .
      wa_down-arbpl    = wa_final-arbpl   .
      wa_down-kostl    = wa_final-kostl   .
      wa_down-tarkz    = wa_final-tarkz   .
      wa_down-datuv    = wa_final-datuv   .
*    wa_down-ref      = wa_final-ref     .
      wa_down-tog001    = wa_final-tog001."MODIFIED ON20-07-21 BYpj

      IF wa_final-datuv IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-datuv
          IMPORTING
            output = wa_down-datuv.

        CONCATENATE wa_down-datuv+0(2) wa_down-datuv+2(3) wa_down-datuv+5(4)
                        INTO wa_down-datuv SEPARATED BY '-'.
      ENDIF.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_down-time SEPARATED BY ':'.
      APPEND wa_down TO it_down.
      CLEAR wa_down.
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
FORM get_fcat .
  PERFORM fcat USING :
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

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

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
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
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
      it_fieldcat        = it_fcat
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
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
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

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
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


  lv_file = 'ZROUTING_DETAIL.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZROUTING DETAIL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_791 TYPE string.
DATA lv_crlf_791 TYPE string.
lv_crlf_791 = cl_abap_char_utilities=>cr_lf.
lv_string_791 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_791 lv_crlf_791 wa_csv INTO lv_string_791.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1004 TO lv_fullfile.
TRANSFER lv_string_791 TO lv_fullfile.
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
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
