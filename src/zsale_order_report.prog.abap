*&---------------------------------------------------------------------*
*& Report ZSALE_ORDER_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSALE_ORDER_REPORT.

TABLES: vbak.


TYPES: BEGIN OF ty_vbak,
       vbeln TYPE vbak-vbeln,
       auart TYPE vbak-auart,
       vkorg TYPE vbak-vkorg,
       bstnk TYPE vbak-bstnk,
       kunnr TYPE vbak-kunnr,
       knumv TYPE vbak-knumv,
       OBJNR TYPE vbak-OBJNR,
       END OF ty_vbak,

       BEGIN OF ty_vbap,
       vbeln  TYPE vbap-vbeln,
       posnr  TYPE vbap-posnr,
       matnr  TYPE vbap-matnr,
       kwmeng TYPE vbap-kwmeng,
       kdmat  TYPE vbap-kdmat,
       ntgew  TYPE vbap-ntgew,
       END OF ty_vbap,

       BEGIN OF ty_vbkd,
       vbeln TYPE vbkd-vbeln,
       posnr TYPE vbkd-posnr,
       kdgrp TYPE vbkd-kdgrp,
       KURRF TYPE vbkd-KURRF,
       KTGRD TYPE vbkd-KTGRD,
       KURSK TYPE vbkd-KURSK,
       PRSDT TYPE vbkd-PRSDT,
       END OF ty_vbkd,

       BEGIN OF ty_vbep,
       vbeln TYPE vbep-vbeln,
       posnr TYPE vbep-posnr,
       etenr TYPE vbep-etenr,
       edatu TYPE vbep-edatu,
       END OF ty_vbep,

       BEGIN OF ty_vbpa,
       vbeln TYPE vbpa-vbeln,
       posnr TYPE vbpa-posnr,
       parvw TYPE vbpa-parvw,
       kunnr TYPE vbpa-kunnr,
       END OF ty_vbpa,

       BEGIN OF ty_konv,
       knumv TYPE prcd_elements-knumv,
       kposn TYPE prcd_elements-kposn,
       kawrt TYPE prcd_elements-kawrt,
       kschl TYPE prcd_elements-kschl,
       kbetr TYPE prcd_elements-kbetr,
       kwert TYPE prcd_elements-kwert,
       END OF ty_konv,


       BEGIN OF ty_final,
       vbeln TYPE vbak-vbeln,
       auart TYPE vbak-auart,
       vkorg TYPE vbak-vkorg,
       bstnk TYPE vbak-bstnk,
       kunnr TYPE vbak-kunnr,
       knumv TYPE vbak-knumv,
       posnr  TYPE vbap-posnr,
       matnr  TYPE vbap-matnr,
       kwmeng TYPE vbap-kwmeng,
       kdmat  TYPE vbap-kdmat,
       ntgew  TYPE vbap-ntgew,
       KURRF TYPE vbkd-KURRF,
       KTGRD TYPE vbkd-KTGRD,
       KURSK TYPE vbkd-KURSK,
       PRSDT TYPE vbkd-PRSDT,
       mattxt TYPE char255,
       saltxt TYPE char255,
       rate   TYPE prcd_elements-kwert,
       pf     TYPE prcd_elements-kwert,
       test   TYPE prcd_elements-kwert,
       freight TYPE prcd_elements-kwert,
       insp   TYPE prcd_elements-kwert,
       cgst   TYPE prcd_elements-kwert,
       sgst   TYPE prcd_elements-kwert,
       igst   TYPE prcd_elements-kwert,
       transp TYPE char100,
       frtxt  TYPE char100,
       insur  TYPE char100,
       edatu  TYPE vbep-edatu,
       boe    TYPE char50,
       stcd3  TYPE kna1-stcd3,
       name1  TYPE kna1-name1,
       billto TYPE string,
       s_kunnr TYPE kna1-kunnr,
       s_stcd3 TYPE kna1-stcd3,
       s_name  TYPE kna1-name1,
       s_ship  TYPE string,
       ac_tag  TYPE char20,
       relase  TYPE char10,
       END OF ty_final.


DATA : it_vbak TYPE TABLE OF ty_vbak,
       wa_vbak TYPE          ty_vbak,

       it_vbap TYPE TABLE OF ty_vbap,
       wa_vbap TYPE          ty_vbap,

       it_vbep TYPE TABLE OF ty_vbep,
       wa_vbep TYPE          ty_vbep,

       it_vbpa TYPE TABLE OF ty_vbpa,
       wa_vbpa TYPE          ty_vbpa,

       it_konv TYPE TABLE OF ty_konv,
       wa_konv TYPE          ty_konv,

       it_vbkd TYPE TABLE OF ty_vbkd,
       wa_vbkd TYPE          ty_vbkd,


       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       wa_kna1  TYPE kna1,
       wa_adrc  TYPE adrc,
       wa_t005t TYPE t005t,
       wa_t005u TYPE t005u,
       ls_kna1  TYPE kna1,
       ls_adrc  TYPE adrc,
       ls_t005t TYPE t005t,
       ls_t005u TYPE t005u,
       ls_tvktt TYPE tvktt,
       wa_jest  TYPE jest.




DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.



SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS : s_vbeln FOR vbak-vbeln OBLIGATORY,
                   s_kunnr FOR vbak-kunnr.
SELECTION-SCREEN : END OF BLOCK b1.


START-OF-SELECTION.
PERFORM get_data.
PERFORM sort_data.
PERFORM get_fcat.
PERFORM get_display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

 SELECT vbeln
        auart
        vkorg
        bstnk
        kunnr
        knumv
        OBJNR FROM vbak INTO TABLE it_vbak
        WHERE vbeln IN s_vbeln
        AND kunnr IN s_kunnr
        AND vkorg = '1000'.



IF it_vbak IS NOT INITIAL.
SELECT vbeln
       posnr
       matnr
       kwmeng
       kdmat
       ntgew FROM vbap INTO TABLE it_vbap
       FOR ALL ENTRIES IN it_vbak
       WHERE vbeln = it_vbak-vbeln.

  SELECT vbeln
         posnr
         parvw
         kunnr FROM vbpa INTO TABLE it_vbpa
         FOR ALL ENTRIES IN it_vbak
         WHERE vbeln = it_vbak-vbeln
           AND posnr EQ ' '
           AND parvw EQ 'WE'.





  SELECT knumv
         kposn
         kawrt
         kschl
         kbetr
         kwert FROM prcd_elements INTO TABLE it_konv
         FOR ALL ENTRIES IN it_vbak
         WHERE knumv = it_vbak-knumv.

ENDIF.

IF it_vbap IS NOT INITIAL.
  SELECT vbeln
         posnr
         kdgrp
         KURRF
         KTGRD
         KURSK
         PRSDT FROM vbkd INTO TABLE it_vbkd
         FOR ALL ENTRIES IN it_vbap
         WHERE vbeln = it_vbap-vbeln.
*           AND posnr = it_vbap-posnr.

 SELECT vbeln
        posnr
        etenr
        edatu FROM vbep INTO TABLE it_vbep
        FOR ALL ENTRIES IN it_vbap
        WHERE vbeln = it_vbap-vbeln
          AND posnr = it_vbap-posnr.
*          AND etenr = '1'.



ENDIF.



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
SORT it_vbep by etenr DESCENDING.

LOOP AT it_vbap INTO wa_vbap.
wa_final-vbeln = wa_vbap-vbeln.
wa_final-posnr = wa_vbap-posnr.
wa_final-matnr = wa_vbap-matnr.
wa_final-kdmat = wa_vbap-kdmat.
wa_final-ntgew = wa_vbap-ntgew.


READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln.
IF sy-subrc = 0.
wa_final-knumv = wa_vbak-knumv.
wa_final-kunnr = wa_vbak-kunnr.
ENDIF.

SELECT SINGLE * FROM jest INTO wa_jest WHERE objnr = wa_vbak-objnr AND stat = 'E0005' AND inact = ' '.

IF wa_jest IS NOT INITIAL.
  wa_final-relase = 'YES'.
ELSE.
  wa_final-relase = 'NO'.

ENDIF.


SELECT SINGLE * FROM kna1 INTO wa_kna1 WHERE kunnr = wa_final-kunnr.
IF sy-subrc = 0.
wa_final-stcd3 = wa_kna1-stcd3.
wa_final-name1 = wa_kna1-name1.
ENDIF.

SELECT SINGLE * FROM adrc INTO wa_adrc WHERE ADDRNUMBER = wa_kna1-adrnr.
IF sy-subrc = 0.
CONCATENATE wa_adrc-STR_SUPPL1 wa_adrc-STR_SUPPL2 wa_adrc-STREET wa_adrc-STR_SUPPL3 wa_adrc-city1 wa_adrc-POST_CODE1
           INTO wa_final-billto SEPARATED BY ','.
ENDIF.


SELECT SINGLE * FROM T005U INTO wa_T005U WHERE spras = 'EN' AND land1 = wa_adrc-country AND BLAND = wa_adrc-REGION.
 IF sy-subrc = 0.
   CONCATENATE wa_final-billto wa_t005u-bezei INTO wa_final-billto  SEPARATED BY ','.
 ENDIF.


SELECT SINGLE * FROM T005T INTO wa_T005T WHERE spras = 'EN' AND land1 = wa_adrc-country.
 IF sy-subrc = 0.
   CONCATENATE wa_final-billto wa_t005t-landx INTO wa_final-billto  SEPARATED BY ','.
 ENDIF.

READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_final-vbeln." posnr = wa_final-posnr.
IF sy-subrc = 0.
 wa_final-KURRF = wa_vbkd-KURRF.
 wa_final-KTGRD = wa_vbkd-KTGRD.
 wa_final-KURSK = wa_vbkd-KURSK.
 wa_final-PRSDT = wa_vbkd-PRSDT.

ENDIF.

SELECT SINGLE * FROM tvktt INTO ls_tvktt WHERE spras = 'EN' AND ktgrd = wa_final-KTGRD.
IF sy-subrc = 0.
  wa_final-ac_tag = ls_tvktt-vtext.
ENDIF.

READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_final-vbeln posnr = wa_final-posnr.
IF sy-subrc = 0.
  wa_final-edatu = wa_vbep-edatu.

ENDIF.

LOOP AT it_konv INTO wa_konv WHERE knumv = wa_final-knumv AND kposn = wa_final-posnr.
CASE wa_konv-kschl.
  WHEN 'ZPR0'.
    wa_final-rate = wa_konv-kwert.
  WHEN 'ZPFO'.
    wa_final-pf = wa_konv-kbetr / 10.
  WHEN 'ZTE1'.
    wa_final-test = wa_konv-kwert.
  WHEN 'ZFR1'.
    wa_final-freight = wa_konv-kbetr.
  WHEN 'ZIN1'.
    wa_final-insp = wa_konv-kwert.
  WHEN 'JOCG'.
    wa_final-cgst = wa_konv-kbetr / 10.
  WHEN 'JOSG'.
    wa_final-sgst = wa_konv-kbetr / 10.
  WHEN 'JOIG'.
    wa_final-igst = wa_konv-kbetr / 10.
ENDCASE.
ENDLOOP.

CLEAR: lv_lines,lv_name.
    REFRESH lv_lines.
    CONCATENATE wa_final-vbeln wa_final-posnr INTO lv_name.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = '0001'
        language                = sy-langu
        name                    = lv_name
        object                  = 'VBBP'
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-saltxt wa_lines-tdline INTO wa_final-saltxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-saltxt.
    ENDIF.


CLEAR: lv_lines,lv_name.
    REFRESH lv_lines.
    lv_name = wa_final-matnr.
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-mattxt wa_lines-tdline INTO wa_final-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-mattxt.
    ENDIF.

CLEAR: lv_lines,lv_name.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z002'
        language                = sy-langu
        name                    = lv_name
        object                  = 'VBBK'
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-transp wa_lines-tdline INTO wa_final-transp SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-saltxt.
    ENDIF.


    CLEAR: lv_lines,lv_name.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z005'
        language                = sy-langu
        name                    = lv_name
        object                  = 'VBBK'
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-frtxt wa_lines-tdline INTO wa_final-frtxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-saltxt.
    ENDIF.

 CLEAR: lv_lines,lv_name.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z017'
        language                = sy-langu
        name                    = lv_name
        object                  = 'VBBK'
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-insur wa_lines-tdline INTO wa_final-insur SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-saltxt.
    ENDIF.

READ TABLE it_vbpa INTO wa_vbpa WITH KEY vbeln = wa_final-vbeln.
IF sy-subrc = 0.

  wa_final-s_kunnr = wa_vbpa-kunnr.
ENDIF.

SELECT SINGLE * FROM kna1 INTO ls_kna1 WHERE kunnr = wa_final-s_kunnr.
IF sy-subrc = 0.
wa_final-s_stcd3 = ls_kna1-stcd3.
wa_final-s_name = ls_kna1-name1.
ENDIF.

SELECT SINGLE * FROM adrc INTO ls_adrc WHERE ADDRNUMBER = ls_kna1-adrnr.
IF sy-subrc = 0.
CONCATENATE ls_adrc-STR_SUPPL1 ls_adrc-STR_SUPPL2 ls_adrc-STREET ls_adrc-STR_SUPPL3 ls_adrc-city1 ls_adrc-POST_CODE1
           INTO wa_final-s_ship SEPARATED BY ','.
ENDIF.


SELECT SINGLE * FROM T005U INTO ls_T005U WHERE spras = 'EN' AND land1 = ls_adrc-country AND BLAND = ls_adrc-REGION.
 IF sy-subrc = 0.
   CONCATENATE wa_final-s_ship ls_t005u-bezei INTO wa_final-s_ship  SEPARATED BY ','.
 ENDIF.


SELECT SINGLE * FROM T005T INTO ls_T005T WHERE spras = 'EN' AND land1 = ls_adrc-country.
 IF sy-subrc = 0.
   CONCATENATE wa_final-s_ship ls_t005t-landx INTO wa_final-s_ship  SEPARATED BY ','.
 ENDIF.


APPEND wa_final TO it_final.
CLEAR :wa_final,wa_kna1,wa_adrc,wa_t005t,wa_t005u,ls_kna1,ls_adrc,ls_t005t,ls_t005u,ls_tvktt,wa_jest.

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
PERFORM fcat USING :     '1'   'VBELN'           'IT_FINAL'      'SO No '                            '15' ,
                         '2'   'POSNR'           'IT_FINAL'      'Item Number'                             '15' ,
                         '3'   'MATNR'           'IT_FINAL'      'Item Code'                                 '15',
                         '4'   'MATTXT'           'IT_FINAL'     'Description'                                 '20',
                         '5'   'KUNNR'            'IT_FINAL'     'Bill to Party '          '10',
                         '6'   'NAME1'            'IT_FINAL'     'Bill to Party Name '          '15',
                         '7'   'BILLTO'            'IT_FINAL'    'Address '          '30',
                         '8'   'STCD3'            'IT_FINAL'     'GSTIN No'          '20',
                         '9'   'S_KUNNR'            'IT_FINAL'     'Ship to Party '          '10',
                         '10'   'S_NAME'            'IT_FINAL'     'Ship to Party Name '          '15',
                         '11'   'S_SHIP'            'IT_FINAL'    'Address '          '30',
                         '12'   'S_STCD3'            'IT_FINAL'     'GSTIN No'          '20',
                         '13'   'RATE'             'IT_FINAL'     'Rate'                                 '15',
                         '14'   'KDMAT'             'IT_FINAL'     'Customer Item No'                                 '15',
                         '15'   'SALTXT'             'IT_FINAL'     'PO No At item level text'               '20',
                         '16'   'PRSDT'             'IT_FINAL'     'Pricing Date'               '15',
                         '17'   'KURSK'             'IT_FINAL'     'Dollar Rate Sales'               '20',
                         '18'   'KURRF'             'IT_FINAL'     'Dollar Rate Accounting'               '20',
                         '19'   'KTGRD'             'IT_FINAL'     'Accounting Tag'               '20',
                         '20'   'AC_TAG'             'IT_FINAL'     'AC Tag Desc'               '20',
                         '21'   'PF'               'IT_FINAL'     'P&F Charges'               '15',
                         '22'   'TEST'             'IT_FINAL'     'Testing Charges'               '15',
                         '23'   'TRANSP'             'IT_FINAL'     'Transporter Name'               '20',
                         '24'   'FRTXT'             'IT_FINAL'     'Freight'               '20',
                         '25'   'FREIGHT'             'IT_FINAL'     'Frt Paid & Claim'               '15',
                         '26'   'INSUR'             'IT_FINAL'     'Customer Ins Policy name and number'             '20',
                         '27'   'INSP'             'IT_FINAL'     'Ins.Paid & Claim'             '20',
                         '28'   'NTGEW'             'IT_FINAL'     'Total Unit net Wt'             '15',
                         '29'   'CGST'             'IT_FINAL'     'CGST'             '15',
                         '30'   'SGST'             'IT_FINAL'     'SGST'             '15',
                         '31'   'IGST'             'IT_FINAL'     'IGST'             '15',
                         '32'   'EDATU'            'IT_FINAL'     'Schedule Line Dt'            '15',
                         '33'   'BOE'              'IT_FINAL'     'BOE No for SEZ order'             '15',
                         '34'   'RELASE'           'IT_FINAL'     'Commercial Relase'             '15'.





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
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_2194   text
*      -->P_2195   text
*      -->P_2196   text
*      -->P_2197   text
*      -->P_2198   text
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
