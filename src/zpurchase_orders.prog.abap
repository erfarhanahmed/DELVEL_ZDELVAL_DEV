*&---------------------------------------------------------------------*
*& Report ZPURCHASE_ORDERS
*&---------------------------------------------------------------------*
*& Report: Zpurchase_Orders
*&Functional Consultant : Devshree Kalamkar
*&Technical Consultant: Diksha Halve & Nilay Brahme
*&Tr: DEVK910252
*&---------------------------------------------------------------------*
REPORT zpurchase_orders.

TYPE-POOLS:slis.

TABLES : ekko, ekpo, eket, t163x, eine.

TYPES : BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,
*          ebelp TYPE ekko-ebelp,
          bedat TYPE ekko-bedat,
          bsart TYPE ekko-bsart,
          bstyp TYPE ekko-bstyp,
          ekgrp TYPE ekko-ekgrp,
          lifnr TYPE ekko-lifnr,
          reswk TYPE ekko-reswk,
          waers TYPE ekko-waers,
*         esokz TYPE ekko-esokz,
*         mwskz TYPE ekko-mwskz,
          frgsx TYPE ekko-frgsx,
          frgzu TYPE ekko-frgzu,
        END OF ty_ekko,

        BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          werks TYPE ekpo-werks,
          matkl TYPE ekpo-matkl,
          infnr TYPE ekpo-infnr,
          loekz TYPE ekpo-loekz,
          pstyp TYPE ekpo-pstyp,
          knttp TYPE ekpo-knttp,
          lgort TYPE ekpo-lgort,
          menge TYPE ekpo-menge,
          meins TYPE ekpo-meins,
          netpr TYPE ekpo-netpr,
          netwr TYPE ekpo-netwr,
          mwskz TYPE ekpo-mwskz,
          bprme TYPE ekpo-bprme,
          repos TYPE ekpo-repos,
          matnr TYPE ekpo-matnr,
          txz01 TYPE ekpo-txz01,
        END OF ty_ekpo,

        BEGIN OF ty_eket,
          ebeln TYPE eket-ebeln,
          etenr TYPE eket-etenr,
          menge TYPE eket-menge,
          eindt TYPE eket-eindt,
          uzeit TYPE eket-uzeit,
          slfdt TYPE eket-slfdt,
          ameng TYPE eket-ameng,
          wamng TYPE eket-wamng,
          wemng TYPE eket-wemng,
          banfn TYPE eket-banfn,
          bnfpo TYPE eket-bnfpo,
          estkz TYPE eket-estkz,

        END OF ty_eket,

        BEGIN OF ty_ekbe,
          ebeln TYPE ekbe-ebeln,
          ebelp TYPE ekbe-ebelp,
          vgabe TYPE ekbe-vgabe,
          menge TYPE ekbe-menge,
          bpmng TYPE ekbe-bpmng,
        END OF ty_ekbe,

        BEGIN OF ty_t163x,
          spras TYPE t163x-spras,
          pstyp TYPE t163x-pstyp,
          epstp TYPE t163x-epstp,
        END OF ty_t163x,

        BEGIN OF ty_eine,
          ebeln TYPE eine-ebeln,
          infnr TYPE eine-infnr,
          peinh TYPE eine-peinh,
        END OF ty_eine.



TYPES : BEGIN OF ty_final,
          ebeln    TYPE ekko-ebeln,
          bedat    TYPE char15,       "ekko-bedat,
          bsart    TYPE ekko-bsart,
          bstyp    TYPE ekko-bstyp,
          ekgrp    TYPE ekko-ekgrp,
          lifnr    TYPE ekko-lifnr,
          reswk    TYPE ekko-reswk,
          waers    TYPE ekko-waers,
*        esokz TYPE ekko-esokz,
          mwskz    TYPE ekpo-mwskz,
          frgsx    TYPE ekko-frgsx,
          frgzu    TYPE ekko-frgzu,
*        ebeln TYPE ekpo-ebeln,
          ebelp    TYPE ekpo-ebelp,
          werks    TYPE ekpo-werks,
          matkl    TYPE ekpo-matkl,
          loekz    TYPE ekpo-loekz,
          pstyp    TYPE ekpo-pstyp,
          knttp    TYPE ekpo-knttp,
          lgort    TYPE ekpo-lgort,
          menge    TYPE ekpo-menge,
          meins    TYPE ekpo-meins,
          netpr    TYPE ekpo-netpr,
          netwr    TYPE ekpo-netwr,
          bprme    TYPE ekpo-bprme,
          repos    TYPE ekpo-repos,
          matnr    TYPE ekpo-matnr,
          txz01    TYPE ekpo-txz01,
          epstp    TYPE t163x-epstp,
          peinh    TYPE eine-peinh,
          etenr    TYPE eket-etenr,
          eindt    TYPE char15,        "eket-eindt,
          uzeit    TYPE eket-uzeit,
          slfdt    TYPE char15,        "eket-slfdt,
          ameng    TYPE eket-ameng,
          wamng    TYPE eket-wamng,
          wemng    TYPE eket-wemng,
          banfn    TYPE eket-banfn,
          bnfpo    TYPE eket-bnfpo,
          estkz    TYPE eket-estkz,
          lv_qty   TYPE char10,
          lv_val   TYPE char10,
          lv_inv   TYPE char30,
          ref_dat  TYPE char15,
          ref_time TYPE char15,

          bpmng    TYPE ekbe-bpmng,
*          menge    TYPE ekbe-menge,

        END OF ty_final.

TYPES: BEGIN OF ty_down,
        ebeln TYPE ekko-ebeln,
        ebelp TYPE ekpo-ebelp,
        etenr TYPE eket-etenr,
        bsart TYPE ekko-bsart,
        bstyp TYPE ekko-bstyp,
        ekgrp TYPE ekko-ekgrp,
        bedat TYPE char15,     "ekko-bedat,
        lifnr TYPE ekko-lifnr,
        matkl    TYPE ekpo-matkl,
          loekz    TYPE ekpo-loekz,
          epstp    TYPE t163x-epstp,
          knttp    TYPE ekpo-knttp,
          werks    TYPE ekpo-werks,
          lgort    TYPE ekpo-lgort,
          menge    TYPE string,      "ekpo-menge,
          meins    TYPE ekpo-meins,
          netpr    TYPE string,    "ekpo-netpr,
          waers    TYPE ekko-waers,
          peinh    TYPE eine-peinh,
          menge1    TYPE string,    "ekpo-menge,
          repos    TYPE ekpo-repos,
          eindt    TYPE char15,
          uzeit    TYPE eket-uzeit,
          slfdt    TYPE char15,
          ameng    TYPE eket-ameng,
          wamng    TYPE eket-wamng,
          wemng    TYPE eket-wemng,
          banfn    TYPE eket-banfn,
          bnfpo    TYPE eket-bnfpo,
          estkz    TYPE eket-estkz,
          matnr    TYPE ekpo-matnr,
          txz01    TYPE ekpo-txz01,
          mwskz    TYPE ekpo-mwskz,
          lv_qty   TYPE char10,
          lv_val   TYPE char10,
          lv_inv   TYPE char30,
          frgsx    TYPE ekko-frgsx,
          frgzu    TYPE ekko-frgzu,
          ref_dat  TYPE char15,
          ref_time TYPE char15,
       END OF ty_down.

DATA : lv_menge  TYPE ekpo-menge,
       lv_bpmng  TYPE ekbe-bpmng,
       lv1_bpmng TYPE ekbe-bpmng.


DATA : it_ekko TYPE STANDARD TABLE OF ty_ekko,
       wa_ekko TYPE ty_ekko,
       it_ekpo TYPE STANDARD TABLE OF ty_ekpo,
       wa_ekpo TYPE ty_ekpo,
       it_eket TYPE STANDARD TABLE OF ty_eket,
       wa_eket TYPE ty_eket,
       it_ekbe TYPE STANDARD TABLE OF ty_ekbe,
       wa_ekbe TYPE ty_ekbe,
       it_t163x TYPE STANDARD TABLE OF ty_t163x,
       wa_t163x TYPE ty_t163x,
       it_eine TYPE STANDARD TABLE OF ty_eine,
       wa_eine TYPE ty_eine.

DATA : lv_data TYPE char30.
DATA : lv_data_n TYPE char30.

DATA : it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final,
       it_down TYPE STANDARD TABLE OF ty_down,
       wa_down TYPE ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS : s_bedat FOR ekko-bedat,
                 s_bsart FOR ekko-bsart,
                 p_werks FOR ekpo-werks DEFAULT 'PL01'.
*PARAMETERS : p_werks LIKE ekpo-werks DEFAULT 'PL01'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.   "TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

*AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-name EQ 'P_WERKS'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.


START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_data.
  PERFORM create_fieldcat.
  PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT ebeln
         bedat
         bsart
         bstyp
         ekgrp
         lifnr
         reswk
         waers
*         esokz
         frgsx
         frgzu
    FROM ekko
    INTO TABLE it_ekko
    WHERE bsart IN s_bsart
    AND bedat IN s_bedat.
  "    AND reswk = p_werks.

  IF it_ekko[] IS NOT INITIAL.
    SELECT ebeln
           ebelp
           werks
           matkl
           infnr
           loekz
           pstyp
           knttp
           lgort
           menge
           meins
           netpr
           netwr
           mwskz
           bprme
           repos
           matnr
           txz01
      FROM ekpo
      INTO TABLE it_ekpo
        FOR ALL ENTRIES IN it_ekko
      WHERE werks IN p_werks AND ebeln = it_ekko-ebeln.
  ENDIF.

IF it_ekpo IS NOT INITIAL.
  SELECT spras
         pstyp
         epstp
    FROM t163x INTO TABLE it_t163x
    FOR ALL ENTRIES IN it_ekpo
    WHERE pstyp = it_ekpo-pstyp
    AND spras = 'EN'.

    SELECT ebeln
           infnr
           peinh
      FROM eine INTO TABLE it_eine
      FOR ALL ENTRIES IN it_ekpo
      WHERE infnr = it_ekpo-infnr.


  SELECT ebeln
        etenr
        menge
        eindt
        uzeit
        slfdt
        ameng
        wamng
        wemng
        banfn
        bnfpo
        estkz
        FROM eket
        INTO TABLE it_eket
        FOR ALL ENTRIES IN it_ekpo
        WHERE ebeln = it_ekpo-ebeln.

*    IF it_ekko IS NOT INITIAL.
  SELECT ebeln
         ebelp
         vgabe
         menge
         bpmng
    FROM ekbe INTO TABLE it_ekbe
    FOR ALL ENTRIES IN it_ekpo
    WHERE ebeln = it_ekpo-ebeln
    AND ebelp = it_ekpo-ebelp
    AND ( vgabe =  '1' OR vgabe = '2' ).
*    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_data .
SORT it_ekpo BY ebeln ebelp.
  LOOP AT it_ekpo INTO wa_ekpo.
    wa_final-ebeln = wa_ekpo-ebeln.
    wa_final-ebelp = wa_ekpo-ebelp.
    wa_final-werks = wa_ekpo-werks.
    wa_final-matkl = wa_ekpo-matkl.
    wa_final-loekz = wa_ekpo-loekz.
    wa_final-pstyp = wa_ekpo-pstyp.
    wa_final-knttp = wa_ekpo-knttp.
    wa_final-lgort = wa_ekpo-lgort.
    wa_final-menge = wa_ekpo-menge.

    wa_final-meins = wa_ekpo-meins.
    wa_final-netpr = wa_ekpo-netpr.
    wa_final-netwr = wa_ekpo-netwr.
    wa_final-mwskz = wa_ekpo-mwskz.
    wa_final-bprme = wa_ekpo-bprme.

    IF wa_ekpo-repos = 'X'.
      wa_final-repos = 'YES'.
    ELSEIF wa_ekpo-repos = ' '.
      wa_final-repos = 'NO'.
    ENDIF.

    wa_final-matnr = wa_ekpo-matnr.
    wa_final-txz01 = wa_ekpo-txz01.

    READ TABLE it_t163x INTO wa_t163x WITH KEY pstyp = wa_ekpo-pstyp spras = 'EN'.
    IF sy-subrc = 0.
      wa_final-epstp = wa_t163x-epstp.
     ENDIF.

    READ TABLE it_eine INTO wa_eine WITH KEY infnr = wa_ekpo-infnr.
     IF sy-subrc = 0.
       wa_final-peinh = wa_eine-peinh.
     ENDIF.
*
    READ TABLE  it_ekko INTO wa_ekko WITH  KEY ebeln = wa_ekpo-ebeln.

*    READ TABLE it_ekko INTO wa_ekko WITH KEY bedat = s_bedat-low. "bsart = s_bsart-low.  " ebeln = wa_ekpo-ebeln.
    IF sy-subrc = 0.
      wa_final-ebeln = wa_ekko-ebeln.
      wa_final-bedat = wa_ekko-bedat.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-bedat
        IMPORTING
          output = wa_final-bedat.

      CONCATENATE wa_final-bedat+0(2) wa_final-bedat+2(3) wa_final-bedat+5(4)
   INTO wa_final-bedat SEPARATED BY '-'.

      wa_final-bsart = wa_ekko-bsart.
      wa_final-bstyp = wa_ekko-bstyp.
      wa_final-ekgrp = wa_ekko-ekgrp.
      wa_final-lifnr = wa_ekko-lifnr.
      wa_final-reswk = wa_ekko-reswk.
      wa_final-waers = wa_ekko-waers.
      wa_final-frgsx = wa_ekko-frgsx.
      wa_final-frgzu = wa_ekko-frgzu.

    ENDIF.
*    CLEAR:WA_EKKO.

    IF wa_final-bsart = 'ZAST' OR wa_final-bsart = 'FO' OR wa_final-bsart = 'NB' OR wa_final-bsart = 'ZSUB' OR wa_final-bsart = 'ZIMP' OR wa_final-bsart = 'ZRP'.
      IF wa_final-meins = 'LE'.
        wa_final-meins = 'AU'.
      ENDIF.
    ENDIF.

    LOOP AT it_ekbe INTO wa_ekbe WHERE vgabe = '1' AND vgabe = '2'.

      wa_final-bpmng = wa_ekbe-bpmng.

      APPEND wa_final TO it_final.
    ENDLOOP.
*    CLEAR:WA_EKBE.


**    READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_ekko-ebeln .

*      ENDIF.

**      SELECT SUM( menge ) FROM ekpo INTO lv_menge WHERE ebeln = wa_ekko-ebeln.
**
**      SELECT SUM( bpmng )  FROM ekbe INTO lv_bpmng WHERE ebeln = wa_ekko-ebeln
**                                                   AND vgabe = '1'.
**      SELECT SUM( bpmng ) FROM ekbe INTO lv1_bpmng WHERE ebeln = wa_ekko-ebeln
**                                                   AND vgabe = '2'.    "Commented By Nilay
**
**      wa_final-lv_qty = lv_menge - lv_bpmng.
**
**      wa_final-lv_val = wa_final-lv_qty * wa_final-netwr.
**
**      wa_final-lv_inv = lv_menge - lv1_bpmng.

*      APPEND wa_final TO it_final.
*      DELETE ADJACENT DUPLICATES FROM it_final COMPARING ebelp.
*      CLEAR wa_final.
*    ENDLOOP.


    READ TABLE it_eket INTO wa_eket WITH KEY ebeln = wa_ekpo-ebeln.
*    LOOP AT it_eket INTO wa_eket WHERE ebeln = wa_ekpo-ebeln.
    IF sy-subrc = 0.
      wa_final-etenr = wa_eket-etenr.
*        wa_final-menge = wa_eket-menge.
      wa_final-eindt = wa_eket-eindt.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-eindt
        IMPORTING
          output = wa_final-eindt.

      CONCATENATE wa_final-eindt+0(2) wa_final-eindt+2(3) wa_final-eindt+5(4)
   INTO wa_final-eindt SEPARATED BY '-'.

      wa_final-uzeit = wa_eket-uzeit.
      wa_final-slfdt = wa_eket-slfdt.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-slfdt
        IMPORTING
          output = wa_final-slfdt.

      CONCATENATE wa_final-slfdt+0(2) wa_final-slfdt+2(3) wa_final-slfdt+5(4)
   INTO wa_final-slfdt SEPARATED BY '-'.

      wa_final-ameng = wa_eket-ameng.
      wa_final-wamng = wa_eket-wamng.
      wa_final-wemng = wa_eket-wemng.
      wa_final-banfn = wa_eket-banfn.
      wa_final-bnfpo = wa_eket-bnfpo.
      wa_final-estkz = wa_eket-estkz.

    ENDIF.

    APPEND wa_final TO it_final.

    CLEAR: wa_final.
*    ENDLOOP.
  ENDLOOP.
*    CLEAR:WA_EKPO.

*  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*    EXPORTING
*      input  = sy-datum
*    IMPORTING
*      output = wa_final-ref_dat.
*  CONCATENATE wa_final-ref_dat+0(2) wa_final-ref_dat+2(3) wa_final-ref_dat+5(4)
*  INTO wa_final-ref_dat SEPARATED BY '-'.
*
*  wa_final-ref_time = sy-uzeit.
*  CONCATENATE wa_final-ref_time+0(2) ':' wa_final-ref_time+2(2)  INTO wa_final-ref_time.


*  APPEND wa_final TO it_final.
*  CLEAR : wa_final.   " wa_ekko, wa_ekpo, wa_eket.

*  ENDLOOP.
*  CLEAR:WA_EKKO,WA_EKPO.
  DELETE it_final WHERE ebeln IS INITIAL.

  SORT it_final BY ebeln ebelp.
  LOOP AT  it_final INTO wa_final .
    wa_final-lv_qty = wa_final-menge - wa_final-bpmng.

    wa_final-lv_val = wa_final-lv_qty * wa_final-netpr.

    wa_final-lv_inv = wa_final-menge - wa_final-bpmng.


    MODIFY it_final FROM wa_final TRANSPORTING lv_qty lv_val lv_inv WHERE ebeln = wa_final-ebeln AND ebelp = wa_final-ebelp .

    CLEAR:wa_final.
  ENDLOOP.
  CLEAR:wa_final.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_fieldcat .
  SORT it_final BY ebeln ebelp.
  PERFORM fcat USING : '1'    'EBELN'          'IT_FINAL'      'Document No.'                                         '10' ,
                       '2'    'EBELP'          'IT_FINAL'      'Document Item'                                        '10' ,
                       '3'    'ETENR'          'IT_FINAL'      'Schedule Line'                                        '10' ,
                       '4'    'BSART'          'IT_FINAL'      'Purchasing Document Type'                             '10' ,
                       '5'    'BSTYP'          'IT_FINAL'      'Purchasing Document Category'                         '10' ,
                       '6'    'EKGRP'          'IT_FINAL'      'Purchasing Group'                                     '10' ,
                       '7'    'BEDAT'          'IT_FINAL'      'Document Date'                                        '10' ,
                       '8'    'LIFNR'          'IT_FINAL'      'Vendor/Supplying Plant'                               '10' ,
                       '9'    'MATKL'          'IT_FINAL'      'Material Group'                                       '10' ,
                       '10'   'LOEKZ'          'IT_FINAL'      'Deletion Indicator'                                   '10' ,
*                      '11'   'LOEKZ'          'IT_FINAL'      'Deletion Indicator'                                   '10' ,
                       '11'   'EPSTP'          'IT_FINAL'      'Item Category'                                        '10' ,
                       '12'   'KNTTP'          'IT_FINAL'      'Acct Assignment Cat.'                                 '10' ,
                       '13'   'WERKS'          'IT_FINAL'      'Plant'                                                '10' ,
                       '14'   'LGORT'          'IT_FINAL'      'Storage Location'                                     '10' ,
                       '15'   'MENGE'          'IT_FINAL'      'Order Quantity'                                       '10' ,
                       '16'   'MEINS'          'IT_FINAL'      'Order Unit'                                           '10' ,
                       '17'   'NETPR'          'IT_FINAL'      'Net Price'                                            '10' ,
                       '18'   'WAERS'          'IT_FINAL'      'Currency'                                             '10' ,
                       '19'   'PEINH'          'IT_FINAL'      'Price Unit'                                           '10' ,
                       '20'   'MENGE'          'IT_FINAL'      'Scheduled Quantity'                                   '10' ,
                       '21'   'REPOS'          'IT_FINAL'      'Still to be invoiced (val.)'                          '10' ,
                       '22'   'EINDT'          'IT_FINAL'      'Delivery date'                                        '10' ,
                       '23'   'UZEIT'          'IT_FINAL'      'Time'                                                 '10' ,
                       '24'   'SLFDT'          'IT_FINAL'      'Stat. Rel. Del. Date'                                 '10' ,
                       '25'   'AMENG'          'IT_FINAL'      'Previous Quantity'                                    '10' ,
                       '26'   'WAMNG'          'IT_FINAL'      'Issued Quantity'                                      '10' ,
                       '27'   'WEMNG'          'IT_FINAL'      'Quantity Delivered'                                   '10' ,
                       '28'   'BANFN'          'IT_FINAL'      'Purchase Requisition'                                 '10' ,
                       '29'   'BNFPO'          'IT_FINAL'      'Item of requisition'                                  '10' ,
                       '30'   'ESTKZ'          'IT_FINAL'      'Creation indicator'                                   '10' ,
                       '31'   'MATNR'          'IT_FINAL'      'Material'                                             '10' ,
                       '32'   'TXZ01'          'IT_FINAL'      'Short Text'                                           '10' ,
                   "    '33'   'ESOKZ'          'IT_FINAL'      'Item category PURCHASE REQISITION'                    '10' ,
                       '33'   'MWSKZ'          'IT_FINAL'      'Tax Code'                                             '10' ,
                       '34'   'LV_QTY'         'IT_FINAL'      'Still to be delivered (qty)'                          '10' ,
                       '35'   'LV_VAL'         'IT_FINAL'      'Still to be delivered (value)'                        '10' ,
                       '36'   'LV_INV'         'IT_FINAL'      'Still to be invoiced (qty)'                           '10' ,
                       '37'   'FRGSX'          'IT_FINAL'      'Release Strategy'                                     '10' ,
                       '38'   'FRGZU'          'IT_FINAL'      'Release State'                                        '10' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0718   text
*      -->P_0719   text
*      -->P_0720   text
*      -->P_0721   text
*      -->P_0722   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p_0718)
                    VALUE(p_0719)
                    VALUE(p_0720)
                    VALUE(p_0721)
                    VALUE(p_0722).

  wa_fcat-col_pos   = p_0718.
  wa_fcat-fieldname = p_0719.
  wa_fcat-tabname   = p_0720.
  wa_fcat-seltext_l = p_0721.
  wa_fcat-outputlen   = p_0722.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final[]
* EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_file .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
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
  lv_file = 'ZPURCHASE_ORDERS.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZPURCHASE ORDER PROGRAM Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_733 TYPE string.
DATA lv_crlf_733 TYPE string.
lv_crlf_733 = cl_abap_char_utilities=>cr_lf.
lv_string_733 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_733 lv_crlf_733 wa_csv INTO lv_string_733.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_733 TO lv_fullfile.
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
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE 'Document NO'
                        'Document Item'
                        'Schedule Line'
                        'Purchasing Document Type'
                        'Purchasing Document Category'
                        'Purchasing Group'
                        'Document Date'
                        'Vendor/Supplying Plant'
                        'Material Group'
                        'Deletion Indicator'
                        'Item Category'
                        'Acct Assignment Cat.'
                        'Plant'
                        'Storage Location'
                        'Order Quantity'
                        'Order Unit'
                        'Net Price'
                        'Currency'
                        'Price Unit'
                        'Scheduled Quantity'
                        'Still to be invoiced (val.)'
                        'Delivery date'
                        'Time'
                        'Stat. Rel. Del. Date'
                        'Previous Quantity'
                        'Issued Quantity'
                        'Quantity Deliverd'
                        'Purchase Requisition'
                        'Item of requisition'
                        'Creation indicator'
                        'Material'
                        'Short Text'
                        'Tax Code'
                        'Still to be delivered (qty)'
                        'Still to be delivered (value)'
                        'Still to be invoiced (qty)'
                        'Release Strategy'
                        'Release State'
                        'Refresh Date'
                        'Refresh Time'

          INTO p_hd_csv
  SEPARATED BY l_field_seperator.

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

LOOP AT it_final INTO wa_final.
  wa_down-ebeln = wa_final-ebeln.
  wa_down-ebelp = wa_final-ebelp.
  wa_down-etenr = wa_final-etenr.
  wa_down-bsart = wa_final-bsart.
  wa_down-bstyp = wa_final-bstyp.
  wa_down-ekgrp = wa_final-ekgrp.
  wa_down-bedat = wa_final-bedat.      "ekko-bedat,
  wa_down-lifnr = wa_final-lifnr.
  wa_down-matkl = wa_final-matkl.
  wa_down-loekz = wa_final-loekz.
  wa_down-epstp = wa_final-epstp.
  wa_down-knttp = wa_final-knttp."      knttp    TYPE ekpo-knttp,
  wa_down-werks = wa_final-werks."        werks    TYPE ekpo-werks,
  wa_down-lgort = wa_final-lgort."        lgort    TYPE ekpo-lgort,
  wa_down-menge = wa_final-menge."'        menge    TYPE ekpo-menge,
  IF wa_down-menge IS NOT INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN wa_down-menge WITH ''.
  ENDIF.
  wa_down-meins = wa_final-meins.
  wa_down-netpr = wa_final-netpr.

  IF wa_down-netpr IS NOT INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN wa_down-netpr WITH ''.
  ENDIF.

  wa_down-waers = wa_final-waers."        waers    TYPE ekko-waers,
  wa_down-peinh = wa_final-peinh."        peinh    TYPE eine-peinh,
  wa_down-menge1 = wa_final-menge."        menge1    TYPE ekpo-menge,
   IF wa_down-menge1 IS NOT INITIAL.
    REPLACE ALL OCCURRENCES OF ',' IN wa_down-menge1 WITH ''.
  ENDIF.
  wa_down-repos = wa_final-repos."        repos    TYPE ekpo-repos,
  wa_down-eindt = wa_final-eindt."        eindt    TYPE char15,
  wa_down-uzeit = wa_final-uzeit."        uzeit    TYPE eket-uzeit,
  wa_down-slfdt = wa_final-slfdt."         slfdt    TYPE char15,
  wa_down-ameng = wa_final-ameng.
  wa_down-wamng = wa_final-wamng.
  wa_down-wemng = wa_final-wemng.
  wa_down-banfn = wa_final-banfn.
  wa_down-bnfpo = wa_final-bnfpo.
  wa_down-estkz = wa_final-estkz.
  wa_down-matnr = wa_final-matnr.
  wa_down-txz01 = wa_final-txz01.
  wa_down-mwskz = wa_final-mwskz.
  wa_down-lv_qty = wa_final-lv_qty.
  wa_down-lv_val = wa_final-lv_val.
  wa_down-lv_inv = wa_final-lv_inv.
  wa_down-frgsx = wa_final-frgsx.
  wa_down-frgzu = wa_final-frgzu.

*   wa_down-ref_dat = wa_final-ref_dat.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input  = sy-datum
    IMPORTING
      output = wa_down-ref_dat.
  CONCATENATE wa_down-ref_dat+0(2) wa_down-ref_dat+2(3) wa_down-ref_dat+5(4)
  INTO wa_down-ref_dat SEPARATED BY '-'.

  wa_final-ref_time = sy-uzeit.
  CONCATENATE wa_final-ref_time+0(2) ':' wa_final-ref_time+2(2)  INTO wa_final-ref_time.


  wa_down-ref_time = wa_final-ref_time.

  APPEND wa_down TO it_down.
  CLEAR wa_down.

ENDLOOP.

ENDFORM.
