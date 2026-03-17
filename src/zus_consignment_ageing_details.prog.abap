*&---------------------------------------------------------------------*
*& Report ZUS_INVENTORY_AGEING_DETAILS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_consignment_ageing_details.

TABLES:mara,mard.
TYPE-POOLS: slis.

TYPES:BEGIN OF ty_mara ,
        matnr TYPE mara-matnr,
*        mtart TYPE mara-mtart,
*        werks TYPE mard-werks,
*        lgort TYPE mard-lgort,
*        labst TYPE mard-labst,
        wrkst TYPE mara-wrkst, "Added by sarika Thange 09.05.2019
      END OF ty_mara,

*      BEGIN OF ty_mard,
*        matnr TYPE mard-matnr,
*        werks TYPE mard-werks,
*        lgort TYPE mard-lgort,
*        labst TYPE mard-labst,
*      END OF ty_mard,

      BEGIN OF ty_msku,
        matnr TYPE msku-matnr,
        werks TYPE msku-werks,
        kulab TYPE msku-kulab,
        kunnr TYPE msku-kunnr,
      END OF ty_msku,

      BEGIN OF ty_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF ty_makt,

      BEGIN OF ty_mseg,
        mblnr      TYPE mseg-mblnr,
        zeile      TYPE mseg-zeile,
        bwart      TYPE mseg-bwart,
        matnr      TYPE mseg-matnr,
        werks      TYPE mseg-werks,
        lgort      TYPE mseg-lgort,
        sobkz      TYPE mseg-sobkz,
        lifnr      TYPE mseg-lifnr,
        shkzg      TYPE mseg-shkzg,
        dmbtr      TYPE mseg-dmbtr,
        menge      TYPE mseg-menge,
        bukrs      TYPE mseg-bukrs,
        budat_mkpf TYPE mseg-budat_mkpf,
        kunnr      TYPE mseg-kunnr,
        vbeln_im   TYPE mseg-vbeln_im, "Modified on 21-07-21 by PJ
      END OF ty_mseg,

      BEGIN OF ty_t156t,
        spras TYPE t156t-spras,
        bwart TYPE t156t-bwart,
        sobkz TYPE t156t-sobkz,
        kzbew TYPE t156t-kzbew,
        kzzug TYPE t156t-kzzug,
        kzvbr TYPE t156t-kzvbr,
        btext TYPE t156t-btext,
      END OF ty_t156t,

      BEGIN OF ty_mbew,
        matnr	TYPE matnr,     " MATERIAL NUMBER
        bwkey TYPE mbew-bwkey,
        lbkum TYPE mbew-lbkum,
        salk3 TYPE mbew-salk3,
        vprsv TYPE vprsv,     " PRICE CONTROL INDICATOR
        verpr TYPE verpr,      "  MOVING AVERAGE PRICE/PERIODIC UNIT PRICE
        stprs	TYPE stprs,	          " STANDARD PRICE
      END OF ty_mbew,


      BEGIN OF ty_final,
        mblnr TYPE mseg-mblnr,
        zeile TYPE mseg-zeile,
        bwart TYPE mseg-bwart,
        matnr TYPE mseg-matnr,
        werks TYPE mseg-werks,
        lgort TYPE mseg-lgort,
        lifnr TYPE mseg-lifnr,
        dmbtr TYPE mseg-dmbtr,
        menge TYPE mseg-menge,
        bukrs TYPE mseg-bukrs,
        date  TYPE mkpf-budat,
        day   TYPE int4,
        qty   TYPE mseg-menge,
        text  TYPE string,
        wrkst TYPE mara-wrkst,
        btext TYPE t156t-btext,
        kunnr TYPE mseg-kunnr,
        name1 TYPE kna1-name1,
        land1 TYPE kna1-land1, "Modified on 21-07-21 by PJ
        ort01 TYPE kna1-ort01, "Modified on 21-07-21 by PJ
        regio TYPE kna1-regio, "Modified on 23-07-21 by PJ
      END OF ty_final,

      BEGIN OF ty_down,
        mblnr TYPE mseg-mblnr,
        matnr TYPE mseg-matnr,
        bwart TYPE mseg-bwart,
        werks TYPE mseg-werks,
        lgort TYPE mseg-lgort,
        qty   TYPE char15,
        menge TYPE char15,
        dmbtr TYPE char15,
        date  TYPE char15,
        day   TYPE char15,
        text  TYPE string,
        wrkst TYPE mara-wrkst,
        ref   TYPE char15,
        btext TYPE char25,
        kunnr TYPE mseg-kunnr,
        name1 TYPE kna1-name1,
        land1 TYPE kna1-land1, "Modified on 21-07-21 by PJ
        ort01 TYPE kna1-ort01, "Modified on 21-07-21 by PJ
        regio TYPE kna1-regio, "Modified on 23-07-21 by PJ
      END OF ty_down.

TYPES:BEGIN OF ty_temp,
        matnr TYPE mseg-matnr,
        kunnr TYPE mseg-kunnr,
        menge TYPE mseg-menge,
      END OF ty_temp.

DATA: lt_temp TYPE TABLE OF ty_temp,
      ls_temp TYPE ty_temp.


DATA: it_mara  TYPE TABLE OF ty_mara,
      wa_mara  TYPE          ty_mara,

      it_mseg  TYPE TABLE OF ty_mseg,
      wa_mseg  TYPE          ty_mseg,

*      it_mard  TYPE TABLE OF ty_mard,
*      wa_mard  TYPE          ty_mard,

      it_t156t TYPE TABLE OF ty_t156t,
      wa_t156t TYPE          ty_t156t,

      it_mbew  TYPE TABLE OF ty_mbew,
      wa_mbew  TYPE          ty_mbew,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final,

      it_down  TYPE TABLE OF ty_down,
      wa_down  TYPE          ty_down,

      it_makt  TYPE TABLE OF ty_makt,
      wa_makt  TYPE          ty_makt,

      it_msku  TYPE TABLE OF ty_msku,
      wa_msku  TYPE          ty_msku,

      it_msku1 TYPE TABLE OF ty_msku,
      wa_msku1 TYPE          ty_msku.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : lv_text TYPE tdobname.
DATA : lt_lines TYPE TABLE OF tline,
       ls_lines TYPE tline.
**********Modified on 21-07-21 by PJ
TYPES: BEGIN OF ty_likp,
         vbeln TYPE likp-vbeln,
         kunnr TYPE likp-kunnr,
       END OF ty_likp.

TYPES: BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         land1 TYPE kna1-land1,
         ort01 TYPE kna1-ort01,
         regio TYPE kna1-regio,
       END OF ty_kna1.

DATA: it_likp TYPE TABLE OF  ty_likp,
      wa_likp TYPE          ty_likp,
      it_kna1 TYPE TABLE OF  ty_kna1,
      wa_kna1 TYPE          ty_kna1.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_matnr FOR mara-matnr.

PARAMETERS    : p_lgort TYPE mard-lgort,
                s_werks TYPE mard-werks OBLIGATORY DEFAULT 'US01'.

SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT      '/Delval/USA'."USA'."USA'."usa'.          "'/Delval/USA'."usa'.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM sort_data.
  PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*  IF p_lgort IS NOT INITIAL.
*    SELECT matnr
*           werks
*           lgort
*           labst FROM mard INTO TABLE it_mard
*           WHERE matnr IN s_matnr
*             AND lgort = p_lgort
*             AND werks = s_werks.
*  ELSE.
*    SELECT matnr
*           werks
*           lgort
*           labst FROM mard INTO TABLE it_mard
*           WHERE matnr IN s_matnr
*             AND werks = s_werks.
*  ENDIF.
*  IF p_lgort IS NOT INITIAL.
  SELECT matnr
  werks
  kulab
  kunnr FROM msku INTO TABLE it_msku
  WHERE matnr IN s_matnr
*    AND lgort = p_lgort
  AND werks = s_werks.
*  ELSE.
*    SELECT matnr
*    werks
**    lgort
*    kulab FROM msku INTO TABLE it_msku
*    WHERE matnr IN s_matnr
*    AND werks = s_werks.
*  ENDIF.


*  DELETE it_mard WHERE werks = 'PL01'.
  DELETE it_msku WHERE werks = 'PL01'.
*  IF it_mard IS NOT INITIAL.
*    SELECT matnr
*           wrkst
*           FROM mara
*           INTO TABLE it_mara
*           FOR ALL ENTRIES IN it_mard
*           WHERE matnr = it_mard-matnr.
*
*    SELECT matnr
*           bwkey
*           lbkum
*           salk3
*           vprsv
*           verpr
*           stprs
*      FROM mbew
*      INTO TABLE it_mbew
*      FOR ALL ENTRIES IN it_mard
*      WHERE matnr = it_mard-matnr
*        AND bwkey = it_mard-werks.
*
*
*
*  ENDIF.
  IF it_msku IS NOT INITIAL.
    SELECT matnr
    wrkst
    FROM mara
    INTO TABLE it_mara
    FOR ALL ENTRIES IN it_msku
    WHERE matnr = it_msku-matnr.

    SELECT matnr
    bwkey
    lbkum
    salk3
    vprsv
    verpr
    stprs
    FROM mbew
    INTO TABLE it_mbew
    FOR ALL ENTRIES IN it_msku
    WHERE matnr = it_msku-matnr
    AND bwkey = it_msku-werks.



  ENDIF.

  IF  it_mara IS NOT INITIAL.
    SELECT matnr
           maktx
           FROM makt
           INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.
  ENDIF.


*  IF it_mard IS NOT INITIAL.
*    SELECT mblnr
*           zeile
*           bwart
*           matnr
*           werks
*           lgort
*           sobkz
*           lifnr
*           shkzg
*           dmbtr
*           menge
*           bukrs
*           budat_mkpf FROM mseg INTO TABLE it_mseg
*           FOR ALL ENTRIES IN it_mard
*           WHERE matnr = it_mard-matnr
*             AND lgort = it_mard-lgort
*             AND bukrs = 'US00'
*             AND werks = it_mard-werks
*             AND bwart IN ('101','105','561','309','311','411','412','501','531','653','701','Z11','542','262',
*                           '602','301','413','344','Z42','202','343','312','544','166')
*             AND sobkz <> 'E'
*             AND shkzg = 'S'.
*
*  ENDIF.
  IF it_msku IS NOT INITIAL.
    SELECT mblnr
    zeile
    bwart
    matnr
    werks
    lgort
    sobkz
    lifnr
    shkzg
    dmbtr
    menge
    bukrs
    budat_mkpf
    kunnr
    vbeln_im  FROM mseg INTO TABLE it_mseg" modified by PJ on 21-07-21
    FOR ALL ENTRIES IN it_msku
    WHERE matnr = it_msku-matnr
*    AND lgort = it_msku-lgort
    AND bukrs = 'US00'
    AND werks = it_msku-werks
    AND bwart IN ('631','634','633')            "added by satyajeet on 19.03.2021  on request of supriya
    AND sobkz <> 'E'
    AND shkzg = 'S'.

****Modifies by PJ on 21-07-21
    IF it_mseg IS NOT INITIAL.

      SELECT vbeln
             kunnr FROM likp
        INTO TABLE it_likp
        FOR ALL ENTRIES IN it_mseg
        WHERE vbeln = it_mseg-vbeln_im.
*
      IF it_likp IS NOT INITIAL.

        SELECT kunnr land1 ort01 regio FROM kna1
          INTO TABLE it_kna1
        FOR ALL ENTRIES IN it_likp
      WHERE kunnr = it_likp-kunnr.
      ENDIF.

    ENDIF.

  ENDIF.
  SORT it_mseg BY matnr.
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
  DATA :tmp_qty TYPE mard-labst.
  DATA :tmp_qty2 TYPE mard-labst.
  DATA : zrate   TYPE zrate.
  DATA : rate TYPE p DECIMALS 5.
  DATA: lv_menge TYPE mseg-menge.
  DATA: lv_menge2 TYPE mseg-menge.

  LOOP AT it_mseg INTO wa_mseg.
    CLEAR:rate.

    ON CHANGE OF wa_mseg-matnr.
      CLEAR: tmp_qty,zrate .

      LOOP AT it_msku INTO wa_msku WHERE matnr = wa_mseg-matnr.
        tmp_qty = tmp_qty + wa_msku-kulab.
      ENDLOOP.

      READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_msku-matnr.
      IF sy-subrc = 0.
        IF wa_mbew-vprsv = 'V'.
          zrate = wa_mbew-verpr.
        ELSEIF wa_mbew-vprsv = 'S'.
          zrate = wa_mbew-stprs.
        ENDIF.
      ENDIF.
***      wa_final-dmbtr = tmp_qty * zrate .  " Hide By Milind 04.01.2021
    ENDON.
    wa_final-mblnr = wa_mseg-mblnr.
    wa_final-zeile = wa_mseg-zeile.
    wa_final-bwart = wa_mseg-bwart.
    wa_final-matnr = wa_mseg-matnr.
    wa_final-werks = wa_mseg-werks.
    wa_final-lgort = wa_mseg-lgort.
    wa_final-lifnr = wa_mseg-lifnr.
    wa_final-kunnr = wa_mseg-kunnr.
*    wa_final-dmbtr = wa_mseg-dmbtr.

    SELECT SINGLE name1 INTO wa_final-name1 FROM kna1 WHERE kunnr = wa_mseg-kunnr.
    rate = wa_mbew-salk3 / wa_mbew-lbkum.
    IF wa_mseg-menge > tmp_qty.

*      wa_final-menge = tmp_qty.
      wa_final-dmbtr = tmp_qty * rate." * wa_mbew-verpr.  " Added By Milind 04.01.2021
      CLEAR tmp_qty.
    ELSE.
*      wa_final-menge = wa_mseg-menge.
      tmp_qty = tmp_qty - wa_mseg-menge.
      wa_final-dmbtr = wa_mseg-menge * rate ."wa_mbew-verpr.  " Added By Milind 04.01.2021
    ENDIF .
******    modified by PJ on 21-07-21

    READ TABLE it_likp INTO wa_likp WITH KEY vbeln = wa_mseg-vbeln_im.

    IF sy-subrc = 0.

      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_likp-kunnr.
      IF sy-subrc = 0.
        wa_final-land1 = wa_kna1-land1.
        wa_final-ort01 = wa_kna1-ort01.
        wa_final-regio = wa_kna1-regio. "on 23-07-21 by PJ
      ENDIF.

    ENDIF.

********    end

**************************START ******************************************** ADDED BY SATYAJEET ON 25.03.2021

    SELECT SINGLE SUM( menge ) FROM mseg INTO lv_menge WHERE matnr = wa_mseg-matnr AND  kunnr = wa_mseg-kunnr AND werks = wa_mseg-werks
        AND bwart IN ('631','634','633')
        AND sobkz <> 'E'
        AND shkzg = 'S'.


    SELECT SINGLE SUM( kulab ) FROM msku INTO tmp_qty2 WHERE matnr = wa_mseg-matnr AND  kunnr = wa_mseg-kunnr AND werks = wa_mseg-werks.

    IF lv_menge > tmp_qty2.
      wa_final-menge = tmp_qty2.

    ELSE.
      wa_final-menge =  lv_menge.

    ENDIF.
***************************END*******************************************
    wa_final-qty   = wa_mseg-menge.
    wa_final-bukrs = wa_mseg-bukrs.
    wa_final-date  = wa_mseg-budat_mkpf .
    wa_final-day   = sy-datum - wa_mseg-budat_mkpf .
*****modified by PJ on 22-07-21
    IF wa_final-land1 IS INITIAL.
      SELECT SINGLE land1 INTO wa_final-land1 FROM kna1 WHERE kunnr = wa_mseg-kunnr.
    ENDIF.

    IF wa_final-ort01 IS INITIAL.
      SELECT SINGLE ort01 INTO wa_final-ort01 FROM kna1 WHERE kunnr = wa_mseg-kunnr.
    ENDIF.

    IF wa_final-regio IS INITIAL." modified by PJ on 23-07-21
      SELECT SINGLE regio INTO wa_final-regio FROM kna1 WHERE kunnr = wa_mseg-kunnr.
    ENDIF.
********end

    CASE wa_final-bwart.
      WHEN '101'.
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND kzbew = 'B' AND kzzug = ' '.
      WHEN '262'.
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND kzbew = 'L'." AND kzzug = ' '.
      WHEN OTHERS .
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND sobkz = ' ' AND kzvbr = ' '.
    ENDCASE.




    READ TABLE it_mara INTO wa_mara WITH  KEY matnr = wa_mseg-matnr.
    wa_final-wrkst = wa_mara-wrkst.

    lv_text = wa_final-matnr .

    IF lv_text IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = 'E'
          name                    = lv_text
          object                  = 'MATERIAL'
        TABLES
          lines                   = lt_lines
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

      IF lt_lines IS NOT INITIAL.
        LOOP AT  lt_lines INTO ls_lines.
          CONCATENATE wa_final-text  ls_lines-tdline INTO wa_final-text SEPARATED BY space.
        ENDLOOP.
      ELSE.
        READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr.
        wa_final-text = wa_makt-maktx.
      ENDIF.

    ENDIF.

    APPEND wa_final TO it_final.
    CLEAR :wa_final,wa_mara,wa_mara,lv_text,rate,wa_msku,ls_temp,tmp_qty2,lv_menge.

  ENDLOOP.
  DELETE it_final WHERE menge = 0.
  SORT it_final[] BY matnr kunnr menge.
  DELETE ADJACENT DUPLICATES FROM it_final[] COMPARING matnr kunnr menge.
  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
      wa_down-mblnr = wa_final-mblnr.
      wa_down-matnr = wa_final-matnr.
      wa_down-bwart = wa_final-bwart.
      wa_down-werks = wa_final-werks.
      wa_down-lgort = wa_final-lgort.
      wa_down-qty = wa_final-qty.
      wa_down-menge = wa_final-menge.
      wa_down-dmbtr = wa_final-dmbtr.
      wa_down-day   = wa_final-day.
      wa_down-text   = wa_final-text.
      wa_down-wrkst   = wa_final-wrkst.
      wa_down-btext   = wa_final-btext.
      wa_down-kunnr   = wa_final-kunnr.
      wa_down-name1   = wa_final-name1.
      wa_down-land1   = wa_final-land1."Modifies by PJ on 21-07-21
      wa_down-ort01   = wa_final-ort01."Modifies by PJ on 21-07-21
      wa_down-regio   = wa_final-regio."Modifies by PJ on 23-07-21

      IF wa_final-date IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-date
          IMPORTING
            output = wa_down-date.

        CONCATENATE wa_down-date+0(2) wa_down-date+2(3) wa_down-date+5(4)
                        INTO wa_down-date SEPARATED BY '-'.

      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

      APPEND wa_down TO it_down.
      CLEAR :wa_down,rate.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
  PERFORM fcat USING :   '1'   'MBLNR'           'IT_FINAL'      'Document No'                 '20' ,
                         '2'   'MATNR'           'IT_FINAL'      'Material No '                '20' ,
                         '3'   'BWART'           'IT_FINAL'      'Movement Type '              '15' ,
                         '4'   'BTEXT'           'IT_FINAL'      'Mov Type Desc'              '15' ,
                         '5'   'WERKS'           'IT_FINAL'      'Plant '                      '05' ,
                         '6'   'LGORT'           'IT_FINAL'      'Storage Loc '                '15' ,
                         '7'   'QTY'             'IT_FINAL'      'Quantity '                   '15' ,
                         '8'   'MENGE'           'IT_FINAL'      'Allocated Quantity '         '15' ,
                         '9'   'DMBTR'           'IT_FINAL'      'Amount '                     '15' ,
                        '10'   'DATE'            'IT_FINAL'      'Posting Date '               '15' ,
                        '11'   'DAY'             'IT_FINAL'      'Aging Day '                  '15' ,
                        '12'   'TEXT'           'IT_FINAL'      'Material Description'        '100' ,
                        '13'   'WRKST'           'IT_FINAL'      'USA Code'                    '15' ,
                        '14'   'KUNNR'           'IT_FINAL'      'Customer Code'               '15' ,
                        '15'   'NAME1'           'IT_FINAL'      'Customer Name'               '15' ,
                        '15'   'LAND1'           'IT_FINAL'      'Country'                     '15' , "Modifies by PJ on 21-07-21
                        '15'   'ORT01'           'IT_FINAL'      'City'                        '15' , "Modifies by PJ on 21-07-21
                        '15'   'REGIO'           'IT_FINAL'      'Region'                      '15'.  "Modifies by PJ on 23-07-21


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
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0383   text
*      -->P_0384   text
*      -->P_0385   text
*      -->P_0386   text
*      -->P_0387   text
*----------------------------------------------------------------------*
FORM fcat USING    VALUE(p1)
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


  """""""""""""""""""uncomment by snehal R. on 12/2/21""""""""""""""""""""""""""""""""""""""""

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


*  lv_file = 'ZUS_INVAG_DET.TXT'.
  BREAK primusabap.
*  CONCATENATE S_WERKS 'ZUS_INVAG_DET.TXT' INTO LV_FILE.
  CONCATENATE  'ZUS_CON_AGE' s_werks '.TXT' INTO lv_file.
  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_CON_AGE REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_777 TYPE string.
DATA lv_crlf_777 TYPE string.
lv_crlf_777 = cl_abap_char_utilities=>cr_lf.
lv_string_777 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_777 lv_crlf_777 wa_csv INTO lv_string_777.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_777 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
  """""""""""""""""""uncomment end by snehal R. on 12/2/21""""""""""""""""""""""""""""""""""""""""




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


*  lv_file = 'ZUS_INVAG_DET.TXT'.

*CONCATENATE S_WERKS 'ZUS_INVAG_DET.TXT' INTO LV_FILE.
  CONCATENATE  'ZUS_CON_AGE' s_werks '.TXT' INTO lv_file.
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_CON_AGE REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_820 TYPE string.
DATA lv_crlf_820 TYPE string.
lv_crlf_820 = cl_abap_char_utilities=>cr_lf.
lv_string_820 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_820 lv_crlf_820 wa_csv INTO lv_string_820.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_820 TO lv_fullfile.
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
  CONCATENATE 'Document No'
              'Material No '
              'Movement Type '
              'Plant '
              'Storage Loc '
              'Quantity '
              'Allocated Quantity '
              'Amount '
              'Posting Date '
              'Aging Day '
              'Material Description '
              'USA Code'
              'Refresh Date'
              'Movement Type Description'
              'Customer Code'
              'Customer Name'
              'Country'         "Modifies by PJ on 21-07-21
              'City'            "Modifies by PJ on 21-07-21
              'Region'          "Modifies by PJ on 23-07-21
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
