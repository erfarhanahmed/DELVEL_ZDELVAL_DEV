*&---------------------------------------------------------------------*
*& Report ZASSET_LOCATION_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zasset_location_report.

TYPE-POOLS:slis.
TABLES: ekpo,mard,mara.

TYPES:

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         matnr TYPE ekpo-matnr,
         knttp TYPE ekpo-knttp,
*       PO_QTY TYPE EKPO-MENGE,
       END OF ty_ekpo,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
*       LGORT TYPE MARD-LGORT,
         labst TYPE mard-labst,
       END OF ty_mard,


       BEGIN OF ty_mseg,
         mblnr  TYPE mseg-mblnr,
         zeile  TYPE mseg-zeile,
         bwart  TYPE mseg-bwart,
         lgort  TYPE mseg-lgort,
         matnr  TYPE mseg-matnr,
         ebeln  TYPE mseg-ebeln,
         menge1 TYPE mseg-menge,
         sobkz  TYPE mseg-sobkz,
       END OF ty_mseg,

       BEGIN OF ty_rev,
        mblnr TYPE mseg-mblnr,
        bwart TYPE mseg-bwart,
        matnr TYPE mseg-matnr,
        xauto TYPE mseg-xauto,
        menge TYPE mseg-menge,
        sgtxt TYPE mseg-sgtxt,
       END OF ty_rev,

       BEGIN OF ty_ekkn,
         ebeln TYPE ekkn-ebeln,
         anln1 TYPE ekkn-anln1,
       END OF ty_ekkn,

       BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         brand TYPE mara-brand,
         meins TYPE mara-meins,

       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_marc,
         matnr TYPE marc-matnr,
         ekgrp TYPE marc-ekgrp,
       END OF ty_marc,

       BEGIN OF ty_j_1ig_subcon,
         mblnr    TYPE j_1ig_subcon-mblnr,
         chln_inv TYPE j_1ig_subcon-chln_inv,
         lifnr    TYPE j_1ig_subcon-lifnr,
         budat    TYPE j_1ig_subcon-budat,
         matnr    TYPE j_1ig_subcon-matnr,
         menge    TYPE j_1ig_subcon-menge,
         meins    TYPE j_1ig_subcon-meins,
         bwart    TYPE j_1ig_subcon-bwart,
         zeile    TYPE j_1ig_subcon-zeile,
         status   TYPE j_1ig_subcon-status,
         ch_qty   TYPE j_1ig_subcon-ch_qty,
       END OF ty_j_1ig_subcon,

       BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
       END OF ty_lfa1,

       BEGIN OF ty_final,
         mblnr    TYPE mseg-mblnr,
         zeile    TYPE mseg-zeile,
         bwart    TYPE mseg-bwart,
         lgort    TYPE mseg-lgort,
         ebeln    TYPE mseg-ebeln,
         menge1   TYPE mseg-menge,
         matnr    TYPE mseg-matnr,

         matnr1   TYPE mard-matnr,
         labst    TYPE mard-labst,
         lgort1   TYPE mard-lgort,
         tot_qty  TYPE mard-labst,

         anln1    TYPE ekkn-anln1,
         brand    TYPE mara-brand,
         maktx    TYPE makt-maktx,
         ekgrp    TYPE marc-ekgrp,
         chln_inv TYPE j_1ig_subcon-chln_inv,
         lifnr    TYPE j_1ig_subcon-lifnr,
         budat    TYPE j_1ig_subcon-budat,
         menge    TYPE j_1ig_subcon-menge,
         meins    TYPE j_1ig_subcon-meins,
         ch_qty   TYPE j_1ig_subcon-ch_qty,
         name1    TYPE lfa1-name1,
         sr_no1   TYPE i,
         rm_qty   TYPE mseg-menge,
         qty      TYPE j_1ig_subcon-ch_qty,
       END OF ty_final.


DATA: sr_no TYPE i.
DATA: it_mseg         TYPE TABLE OF ty_mseg,
      wa_mseg         TYPE          ty_mseg,

      it_ekpo         TYPE TABLE OF ty_ekpo,
      wa_ekpo         TYPE          ty_ekpo,

      it_mseg1        TYPE TABLE OF ty_mseg,
      wa_mseg1        TYPE          ty_mseg,

      it_mard         TYPE TABLE OF ty_mard,
      wa_mard         TYPE          ty_mard,

      it_mard1        TYPE TABLE OF ty_mard,
      wa_mard1        TYPE          ty_mard,

      it_ekkn         TYPE TABLE OF ty_ekkn,
      wa_ekkn         TYPE          ty_ekkn,

      it_mara         TYPE TABLE OF ty_mara,
      wa_mara         TYPE          ty_mara,

      it_marc         TYPE TABLE OF ty_marc,
      wa_marc         TYPE          ty_marc,

      it_makt         TYPE TABLE OF ty_makt,
      wa_makt         TYPE          ty_makt,

      it_j_1ig_subcon TYPE TABLE OF ty_j_1ig_subcon,
      wa_j_1ig_subcon TYPE          ty_j_1ig_subcon,

      it_sub          TYPE TABLE OF ty_j_1ig_subcon,
      wa_sub          TYPE          ty_j_1ig_subcon,

      it_lfa1         TYPE TABLE OF ty_lfa1,
      wa_lfa1         TYPE          ty_lfa1,

      it_rev          TYPE TABLE OF ty_rev,
      wa_rev          TYPE          ty_rev,

      it_final        TYPE TABLE OF ty_final,
      wa_final        TYPE          ty_final,

      it_final1       TYPE TABLE OF ty_final,
      wa_final1       TYPE          ty_final.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_matnr FOR mard-matnr.
SELECTION-SCREEN: END OF BLOCK b1.


START-OF-SELECTION.
  PERFORM get_data.
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
*BREAK PRIMUS.
  SELECT matnr
         mtart
         brand
         meins FROM mara INTO TABLE it_mara
         WHERE matnr IN s_matnr AND mtart = 'UNBW'.


  IF  it_mara IS NOT INITIAL.
*  BREAK primus.
  SELECT mblnr
         zeile
         bwart
         lgort
         matnr
         ebeln
         menge
         sobkz FROM mseg INTO TABLE it_mseg
         FOR ALL ENTRIES IN it_mara
         WHERE matnr = it_mara-matnr
         AND bwart = '541'.

  SELECT mblnr
         zeile
         bwart
         lgort
         matnr
         ebeln
         menge
         sobkz FROM mseg INTO TABLE it_mseg1
         FOR ALL ENTRIES IN it_mara
         WHERE matnr = it_mara-matnr
         AND bwart IN ('561','101').

  SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.

  SELECT matnr
           ekgrp FROM marc INTO TABLE it_marc
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.

  SELECT ebeln
         matnr
         knttp FROM ekpo INTO TABLE it_ekpo
         FOR ALL ENTRIES IN it_mara
         WHERE matnr = it_mara-matnr.



 ENDIF.

IF  it_ekpo IS NOT INITIAL .

    SELECT ebeln
           anln1 FROM ekkn INTO TABLE it_ekkn
           FOR ALL ENTRIES IN it_ekpo
           WHERE ebeln = it_ekpo-ebeln.


ENDIF.



 IF it_mseg1 IS NOT INITIAL.


    SELECT matnr
           labst FROM mard INTO TABLE it_mard
           FOR ALL ENTRIES IN it_mseg1
           WHERE matnr = it_mseg1-matnr
           AND ( lgort NE 'SCR1' AND lgort NE 'SRN1' AND lgort NE 'RJ01' ).

*IT_MARD1 = IT_MARD.
*BREAK primus.
    LOOP AT it_mard INTO wa_mard.
      COLLECT wa_mard INTO it_mard1.
      CLEAR wa_mard.
    ENDLOOP.

    REFRESH it_mard.
    it_mard = it_mard1.


 ENDIF.



  IF it_mseg IS NOT INITIAL.

***
***  SELECT MATNR
***         BRAND
***         MEINS FROM MARA INTO TABLE IT_MARA
***         FOR ALL ENTRIES IN IT_MSEG
***         WHERE MATNR = IT_MSEG-MATNR.
***
***  SELECT MATNR
***         MAKTX FROM MAKT INTO TABLE IT_MAKT
***         FOR ALL ENTRIES IN IT_MSEG
***         WHERE MATNR = IT_MSEG-MATNR.
***
***  SELECT MATNR
***         EKGRP FROM MARC INTO TABLE IT_MARC
***         FOR ALL ENTRIES IN IT_MSEG
***         WHERE MATNR = IT_MSEG-MATNR.

    SELECT mblnr
           chln_inv
           lifnr
           budat
           matnr
           menge
           meins
           bwart
           zeile
           status
           ch_qty FROM j_1ig_subcon INTO TABLE it_j_1ig_subcon
           FOR ALL ENTRIES IN it_mseg
           WHERE mblnr = it_mseg-mblnr
           AND bwart = '541'.
*         AND ZEILE = '2'.
*         AND ( STATUS = 'C' AND STATUS = 'I' ).
    IF it_j_1ig_subcon IS NOT INITIAL.
      SELECT mblnr
         chln_inv
         lifnr
         budat
         matnr
         menge
         meins
         bwart
         zeile
         status
         ch_qty FROM j_1ig_subcon INTO TABLE it_sub
         FOR ALL ENTRIES IN it_j_1ig_subcon
         WHERE  chln_inv = it_j_1ig_subcon-chln_inv
         AND bwart IN ( '542','543' ).

    ENDIF.
  ENDIF.

  IF it_j_1ig_subcon IS NOT INITIAL.
    SELECT lifnr
           name1 FROM lfa1 INTO TABLE it_lfa1
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE lifnr = it_j_1ig_subcon-lifnr.

     SELECT mblnr
           bwart
           matnr
           xauto
           menge
           sgtxt FROM mseg INTO TABLE it_rev
           FOR ALL ENTRIES IN it_j_1ig_subcon
           WHERE matnr = it_j_1ig_subcon-matnr
           AND bwart = '542'
           AND xauto NE 'X'.


  ENDIF.

  LOOP AT it_mard INTO wa_mard.
*  WA_FINAL1-LGORT1 = WA_MARD-LGORT.
    wa_final1-labst = wa_mard-labst.
    wa_final1-matnr = wa_mard-matnr.

*  WA_FINAL1-TOT_QTY = WA_FINAL1-TOT_QTY + WA_FINAL1-LABST.
    wa_final1-qty = wa_final1-menge + wa_final1-labst.

    READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_mard-matnr.
    READ TABLE it_ekpo INTO wa_ekpo WITH KEY matnr = wa_mard-matnr.
    READ TABLE it_ekkn INTO wa_ekkn WITH KEY ebeln = wa_ekpo-ebeln.
    IF sy-subrc = 0.
      wa_final1-anln1 = wa_ekkn-anln1.

    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_mard-matnr.
    IF sy-subrc = 0.
      wa_final1-brand = wa_mara-brand.
      wa_final1-meins = wa_mara-meins.

    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mard-matnr.
    IF sy-subrc = 0.
      wa_final1-maktx = wa_makt-maktx.

    ENDIF.

    READ TABLE it_marc INTO wa_marc WITH KEY matnr = wa_mard-matnr.
    IF sy-subrc = 0.
      wa_final1-ekgrp = wa_marc-ekgrp.

    ENDIF.

    wa_final1-name1 = 'Delval Flow Control'.
    IF wa_final1-qty NE 0.
      APPEND wa_final1 TO it_final1.
    ENDIF.

    CLEAR wa_final1.
  ENDLOOP.
  CLEAR: wa_ekpo,wa_mara,wa_marc,wa_makt,wa_mseg.
  SORT it_j_1ig_subcon BY chln_inv.
  SORT it_sub BY chln_inv.

  DATA: sum     TYPE menge_d,
        v_index TYPE sy-index.


  LOOP AT it_j_1ig_subcon INTO wa_j_1ig_subcon .
    wa_final-chln_inv = wa_j_1ig_subcon-chln_inv.
    wa_final-lifnr    = wa_j_1ig_subcon-lifnr   .
    wa_final-budat    = wa_j_1ig_subcon-budat   .
*    WA_FINAL-MENGE    = WA_J_1IG_SUBCON-MENGE   .
    wa_final-meins    = wa_j_1ig_subcon-meins   .
    wa_final-matnr    = wa_j_1ig_subcon-matnr   .
    wa_final-ch_qty    = wa_j_1ig_subcon-ch_qty   .

*BREAK primus.

    READ TABLE it_sub INTO wa_sub WITH KEY chln_inv = wa_final-chln_inv matnr = wa_final-matnr.
    IF sy-subrc = 0.
      v_index = sy-tabix.
      LOOP AT it_sub INTO wa_sub FROM v_index.
        IF wa_sub-chln_inv <> wa_j_1ig_subcon-chln_inv AND wa_sub-matnr <> wa_j_1ig_subcon-matnr.
          EXIT.
        ELSE.
          sum = sum + wa_sub-menge.
        ENDIF.
      ENDLOOP.
      wa_final-menge = wa_j_1ig_subcon-menge - sum.
      CLEAR : sum.
    ELSE.
      wa_final-menge = wa_j_1ig_subcon-menge.
    ENDIF.



    READ TABLE it_rev INTO wa_rev WITH KEY sgtxt = wa_j_1ig_subcon-chln_inv matnr = wa_j_1ig_subcon-matnr.
      IF  sy-subrc = 0.
        v_index = sy-tabix.
        LOOP AT it_rev INTO wa_rev FROM v_index.
          IF wa_rev-sgtxt <> wa_j_1ig_subcon-chln_inv OR wa_rev-matnr <> wa_j_1ig_subcon-matnr .
           EXIT.
        ELSE.
          sum = sum + wa_rev-menge.
      ENDIF.
     ENDLOOP.
     wa_final-qty = wa_final-menge - sum.
     CLEAR: sum.
    ELSE.
     wa_final-qty = wa_final-menge.
    ENDIF.
    READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_j_1ig_subcon-matnr.
    READ TABLE it_ekpo INTO wa_ekpo WITH KEY matnr = wa_j_1ig_subcon-matnr.
    READ TABLE it_ekkn INTO wa_ekkn WITH KEY ebeln = wa_ekpo-ebeln.
    IF sy-subrc = 0.
      wa_final-anln1 = wa_ekkn-anln1.

    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_j_1ig_subcon-matnr.
    IF sy-subrc = 0.
      wa_final-brand = wa_mara-brand.

    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_j_1ig_subcon-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktx.

    ENDIF.

    READ TABLE it_marc INTO wa_marc WITH KEY matnr = wa_j_1ig_subcon-matnr.
    IF sy-subrc = 0.
      wa_final-ekgrp = wa_marc-ekgrp.

    ENDIF.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_j_1ig_subcon-lifnr.
    IF  sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    ENDIF.
*SR_NO = SR_NO + 1.
*
*WA_FINAL-SR_NO1 = SR_NO.
    IF wa_final-qty NE 0.
      APPEND wa_final TO it_final.
    ENDIF.

    CLEAR wa_final.
    CLEAR: wa_ekpo,wa_mara,wa_marc,wa_makt,wa_mseg,wa_rev,wa_sub.
  ENDLOOP.
  APPEND LINES OF it_final TO it_final1.
  SORT it_final BY matnr ASCENDING .
*APPEND WA_FINAL TO IT_FINAL.
*CLEAR WA_FINAL.
*ENDLOOP.
*DATA: LV_QTY TYPE MSEG-MENGE.
*LOOP AT IT_FINAL INTO WA_FINAL.
*
*  READ TABLE IT_SUB INTO WA_SUB WITH KEY CHLN_INV = WA_FINAL-CHLN_INV.
*  LV_QTY = WA_SUB-MENGE.
*  IF SY-SUBRC = 0.
*    WA_FINAL-TOT_QTY =  WA_FINAL-MENGE - LV_QTY.
*
*  ENDIF.
*
*ENDLOOP.
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
      t_outtab           = it_final1
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
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
  PERFORM fcat USING : ""'1'  'sr_no1'   'IT_FINAL'  'Sr.NO'              '10' ,
                       '1'  'MATNR'   'IT_FINAL'  'Item_Code'          '18',
                       '2'  'ANLN1'   'IT_FINAL'  'Asset Code'         '12',
                       '3'  'MAKTX'   'IT_FINAL'  'Item Description'   '40',
                       '4'  'BRAND'   'IT_FINAL'  'Brand'              '6',
                       '5'  'EKGRP'   'IT_FINAL'  'Asset Owner'        '12',
                       '6'  'NAME1'   'IT_FINAL'  'Location'           '35',
                       '7'  'CHLN_INV'   'IT_FINAL'  'DC NO./RC NO.'   '20',
                       '8'  'BUDAT'   'IT_FINAL'  'Date'               '12',
                       '9' 'QTY'   'IT_FINAL'  'QTY'                '13',
*                       '11' 'TOT_QTY'   'IT_FINAL'  'TOT_QTY'             '13',
                       '10' 'MEINS'   'IT_FINAL'  'Unit'               '6'.
*                     '11' 'LGORT'   'IT_FINAL'  'Stor.loc'           '10'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0510   text
*      -->P_0511   text
*      -->P_0512   text
*      -->P_0513   text
*      -->P_0514   text
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
