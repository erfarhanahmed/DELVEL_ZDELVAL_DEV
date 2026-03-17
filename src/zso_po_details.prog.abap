*&---------------------------------------------------------------------*
*& Report ZSO_PO_DETAILS
*&---------------------------------------------------------------------*
*&         0. PROGRAM OWNER          : PRIMUS TECHSYSTEMS PVT LTD.
*&         1. FS NO                  :
*&         2. PROJECT                : DELVAL
*&         3. PROGRAM NAME           : ZSO_PO_DETAILS
*&         4. TRANS CODE             :
*&         5. MODULE NAME            :
*&         7. CREATION DATE          : 17/02/2021
*&         8. DEVELOPER NAME         : SNEHAL RAJALE
*&         9. FUNCTIONAL CONSULTANT  : VAIBHAV VHANMANE
*&---------------------------------------------------------------------*
REPORT zso_po_details.

TYPE-POOLS: slis.

TABLES : ekko,ekpo,lfa1,adrc,ekbe,ekkn,vbak,mara.

TYPES :BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         loekz TYPE ekpo-loekz,
         txz01 TYPE ekpo-txz01,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         menge TYPE ekpo-menge,
         elikz TYPE ekpo-elikz,
         knttp TYPE ekpo-knttp,
       END OF ty_ekpo,

       BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         aedat TYPE ekko-aedat,
         lifnr TYPE ekko-lifnr,
         ekgrp TYPE ekko-ekgrp,
       END OF ty_ekko,

       BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         adrnr TYPE lfa1-adrnr,
       END OF ty_lfa1,

       BEGIN OF ty_adrc,
         addrnumber TYPE adrc-addrnumber,
         name1      TYPE adrc-name1,
       END OF ty_adrc,

       BEGIN OF ty_ekbe,
         ebeln TYPE ekbe-ebeln,
         ebelp TYPE ekbe-ebelp,
         bwart TYPE ekbe-bwart,
         menge TYPE ekbe-menge,
         lfbnr TYPE ekbe-lfbnr,
       END OF ty_ekbe,

       BEGIN OF ty_ekkn,
         ebeln TYPE ekkn-ebeln,
         ebelp TYPE ekkn-ebelp,
         vbeln TYPE ekkn-vbeln,
         vbelp TYPE ekkn-vbelp,
       END OF ty_ekkn,

       BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,
         vkbur TYPE vbak-vkbur,
         kunnr TYPE vbak-kunnr,
       END OF ty_vbak,

       BEGIN OF ty_mara,
         matnr   TYPE mara-matnr,
         zseries TYPE mara-zseries,
         zsize   TYPE mara-zsize,
       END OF ty_mara,

       BEGIN OF ty_vbap,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         kwmeng TYPE vbap-kwmeng,
       END OF ty_vbap,

       BEGIN OF ty_mska,
         matnr TYPE mska-matnr,
         werks TYPE mska-werks,
         lgort TYPE mska-lgort,
         charg TYPE mska-charg,
         sobkz TYPE mska-sobkz,
         vbeln TYPE mska-vbeln,
         posnr TYPE mska-posnr,
         kalab TYPE mska-kalab,
       END OF ty_mska,

       BEGIN OF ty_vbep,
         vbeln TYPE vbep-vbeln,
         posnr TYPE vbep-posnr,
         etenr TYPE vbep-etenr,
       END OF ty_vbep,

       BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         name1 TYPE kna1-name1,
       END OF ty_kna1,

       BEGIN OF ty_final,
         ebeln     TYPE ekpo-ebeln, "PO NO
         ebelp     TYPE ekpo-ebelp, "PO Line item
         lifnr     TYPE ekko-lifnr, "Vendor Code
         name1     TYPE adrc-name1, "Vendor Name
         aedat     TYPE ekko-aedat, "PO Date
         ekgrp     TYPE ekko-ekgrp, "Purchasing Group
         matnr     TYPE ekpo-matnr, "Material
         txz01     TYPE ekpo-txz01, "Long Text
         menge     TYPE ekpo-menge, "PO QTY
         del_menge TYPE ekbe-menge, "Delivered Qty
         vbeln     TYPE ekkn-vbeln, "Sales Order No
         vbelp     TYPE ekkn-vbelp, "Line Item
         kunnr     TYPE vbak-kunnr, "Customer
         name12    TYPE kna1-name1, "Customer Name
         vkbur     TYPE vbak-vkbur, "Branch
         kwmeng    TYPE vbap-kwmeng, "SO QTY
         kalab     TYPE mska-kalab,  "TPI Stock
         zseries   TYPE mara-zseries, "Series
         zsize     TYPE mara-zsize,   "Size
         sh_id     TYPE string,
         tpi       TYPE char20,
         still_del TYPE ekpo-menge,  "Still To Be Delivered QTY
       END OF ty_final,

       BEGIN OF ty_down,
         ebeln     TYPE ekpo-ebeln, "PO NO
         ebelp     TYPE ekpo-ebelp, "PO Line item
         lifnr     TYPE ekko-lifnr, "Vendor Code
         name1     TYPE adrc-name1, "Vendor Name
         aedat     TYPE char18, "PO Date
         ekgrp     TYPE ekko-ekgrp, "Purchasing Group
         matnr     TYPE ekpo-matnr, "Material
         txz01     TYPE ekpo-txz01, "Long Text
         menge     TYPE string, "PO QTY
         del_menge TYPE string, "Delivered Qty
         still_del TYPE string,  "Still To Be Delivered QTY
         vbeln     TYPE ekkn-vbeln, "Sales Order No
         vbelp     TYPE ekkn-vbelp, "Line Item
         sh_id     TYPE string,     "Schedule ID
         kunnr     TYPE vbak-kunnr, "Customer Name
         name12    TYPE kna1-name1, "Customer Name
         vkbur     TYPE vbak-vkbur, "Branch
         kwmeng    TYPE string, "SO QTY
         kalab     TYPE mska-kalab,  "TPI Stock
         zseries   TYPE mara-zseries, "Series
         zsize     TYPE mara-zsize,   "Size
         tpi       TYPE char20,     "TPI Remark
         ref_dat   TYPE char15,  "Refresh Date
         ref_time  TYPE char8,"char15,  "Refresh Time
       END OF ty_down.

DATA : lv_lines TYPE STANDARD TABLE OF tline,
       wa_lines LIKE tline,
       ls_lines LIKE tline,
       lv_name  TYPE thead-tdname,
       wa_text  TYPE char20,
       gv_lfbnr TYPE ekbe-lfbnr.



DATA : lt_ekpo  TYPE TABLE OF ty_ekpo,
       ls_ekpo  TYPE          ty_ekpo,

       lt_ekko  TYPE TABLE OF ty_ekko,
       ls_ekko  TYPE          ty_ekko,

       lt_ekko1 TYPE TABLE OF ty_ekko WITH HEADER LINE,
       ls_ekko1 TYPE          ty_ekko,

       lt_ekbe  TYPE TABLE OF ty_ekbe,
       ls_ekbe  TYPE          ty_ekbe,

       lt_ekkn  TYPE TABLE OF ty_ekkn,
       ls_ekkn  TYPE          ty_ekkn,

       lt_ekkn1 TYPE TABLE OF ty_ekkn,
       ls_ekkn1 TYPE          ty_ekkn,

       lt_vbak  TYPE TABLE OF ty_vbak,
       ls_vbak  TYPE          ty_vbak,

       lt_mara  TYPE TABLE OF ty_mara,
       ls_mara  TYPE          ty_mara,

       lt_lfa1  TYPE TABLE OF ty_lfa1,
       ls_lfa1  TYPE          ty_lfa1,

       lt_adrc  TYPE TABLE OF ty_adrc,
       ls_adrc  TYPE          ty_adrc,

       lt_vbap  TYPE TABLE OF ty_vbap,
       ls_vbap  TYPE          ty_vbap,

       lt_mska  TYPE TABLE OF ty_mska,
       ls_mska  TYPE          ty_mska,

       lt_vbep  TYPE TABLE OF ty_vbep,
       ls_vbep  TYPE          ty_vbep,

       lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_kna1  TYPE TABLE OF ty_kna1,
       ls_kna1  TYPE          ty_kna1,

       lt_down  TYPE TABLE OF ty_down,
       ls_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_pono  FOR ekpo-ebeln,
                 s_poit  FOR ekpo-ebelp,
                 s_podat FOR ekko-aedat,
                 s_sono  FOR ekkn-vbeln.
PARAMETERS     : p_plant TYPE ekpo-werks OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT   '/Delval/India'."India'."India'."temp' .    " '/Delval/India'."temp_'
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

START-OF-SELECTION.

  PERFORM get_data.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .


  IF s_podat IS NOT INITIAL.

    SELECT ebeln
           aedat
           lifnr
           ekgrp
      FROM ekko
      INTO TABLE lt_ekko1[]
      WHERE aedat IN s_podat.

    IF s_sono IS NOT INITIAL.

      IF lt_ekko1[] IS NOT INITIAL.

        SELECT ebeln
              ebelp
              vbeln
              vbelp
              FROM ekkn
              INTO TABLE lt_ekkn1[]
              FOR ALL ENTRIES IN lt_ekko1[]
              WHERE vbeln IN s_sono AND
                    ebeln = lt_ekko1-ebeln.

        IF lt_ekkn1[] IS NOT INITIAL.

          SELECT ebeln
          ebelp
          loekz
          txz01
          matnr
          werks
          menge
          elikz
          knttp
          FROM ekpo
          INTO TABLE lt_ekpo
          FOR ALL ENTRIES IN lt_ekkn1[]
          WHERE ebeln = lt_ekkn1-ebeln AND
          ebelp = lt_ekkn1-ebelp AND
          loekz = ' '            AND
          werks = p_plant        AND
          knttp = 'E' AND
          elikz = ' '.

        ENDIF.

      ENDIF.

    ELSE.

      IF lt_ekko1[] IS NOT INITIAL.

        SELECT ebeln
               ebelp
               loekz
               txz01
               matnr
               werks
               menge
               knttp
          FROM ekpo
          INTO TABLE lt_ekpo
          FOR ALL ENTRIES IN lt_ekko1
          WHERE ebeln = lt_ekko1-ebeln AND
                ebelp IN s_poit        AND
                loekz = ' '            AND
                werks = p_plant        AND
                knttp = 'E'  AND
                elikz = ' '.

      ENDIF.

    ENDIF.

  ELSEIF s_sono IS NOT INITIAL.

    IF s_pono IS INITIAL.
      SELECT ebeln
            ebelp
            vbeln
            vbelp
      FROM ekkn
      INTO TABLE lt_ekkn1
      WHERE vbeln IN s_sono.

*    IF s_podat IS INITIAL.
    ELSEIF s_pono IS NOT INITIAL.

      SELECT ebeln
      ebelp
      vbeln
      vbelp
      FROM ekkn
      INTO TABLE lt_ekkn1
      WHERE vbeln IN s_sono AND
            ebeln IN s_pono.
    ENDIF.

    IF lt_ekkn1[] IS NOT INITIAL.

      SELECT ebeln
      ebelp
      loekz
      txz01
      matnr
      werks
      menge
      knttp
      FROM ekpo
      INTO TABLE lt_ekpo
      FOR ALL ENTRIES IN lt_ekkn1
      WHERE ebeln = lt_ekkn1-ebeln AND
            ebelp = lt_ekkn1-ebelp AND
            loekz = ' '            AND
            werks = p_plant        AND
            knttp = 'E' AND
            elikz = ' '.
    ENDIF.

  ELSE.

    SELECT ebeln
    ebelp
    loekz
    txz01
    matnr
    werks
    menge
    knttp
    FROM ekpo
    INTO TABLE lt_ekpo
    WHERE ebeln IN s_pono AND
    ebelp       IN s_poit AND
    loekz       = ' '     AND
    werks       = p_plant AND
    knttp       = 'E' AND
    elikz       = ' '.

  ENDIF.

  IF lt_ekpo IS NOT INITIAL.

    SELECT ebeln
           aedat
           lifnr
           ekgrp
      FROM ekko
      INTO TABLE lt_ekko
      FOR ALL ENTRIES IN lt_ekpo
      WHERE ebeln = lt_ekpo-ebeln.

    SELECT ebeln
           ebelp
           bwart
           menge
           lfbnr
      FROM ekbe
      INTO TABLE lt_ekbe
      FOR ALL ENTRIES IN lt_ekpo
      WHERE ebeln = lt_ekpo-ebeln AND
            ebelp = lt_ekpo-ebelp.

    SELECT ebeln
           ebelp
           vbeln
           vbelp
      FROM ekkn
      INTO TABLE lt_ekkn
      FOR ALL ENTRIES IN lt_ekpo
      WHERE ebeln = lt_ekpo-ebeln AND
            ebelp = lt_ekpo-ebelp.


    SELECT matnr
           zseries
           zsize
      FROM mara
      INTO TABLE lt_mara
      FOR ALL ENTRIES IN lt_ekpo
      WHERE matnr = lt_ekpo-matnr.

    IF lt_ekko IS NOT INITIAL.

      SELECT lifnr
             adrnr
        FROM lfa1
        INTO TABLE lt_lfa1
        FOR ALL ENTRIES IN lt_ekko
        WHERE lifnr = lt_ekko-lifnr.

    ENDIF.

    IF lt_lfa1 IS NOT INITIAL.

      SELECT addrnumber
             name1
        FROM adrc
        INTO TABLE lt_adrc
        FOR ALL ENTRIES IN lt_lfa1
        WHERE addrnumber = lt_lfa1-adrnr.


    ENDIF.

    IF lt_ekkn IS NOT INITIAL.

      SELECT vbeln
             vkbur
             kunnr
        FROM vbak
        INTO TABLE lt_vbak
        FOR ALL ENTRIES IN lt_ekkn
        WHERE vbeln = lt_ekkn-vbeln.

      SELECT vbeln
             posnr
             kwmeng
        FROM vbap
        INTO TABLE lt_vbap
        FOR ALL ENTRIES IN lt_ekkn
        WHERE vbeln = lt_ekkn-vbeln AND
              posnr = lt_ekkn-vbelp.


      SELECT matnr
             werks
             lgort
             charg
             sobkz
             vbeln
             posnr
             kalab
         FROM mska
         INTO TABLE lt_mska
         FOR ALL ENTRIES IN lt_ekkn
         WHERE vbeln = lt_ekkn-vbeln AND
               posnr = lt_ekkn-vbelp AND
               lgort = 'TPI1'.

      SELECT vbeln
             posnr
             etenr
        FROM vbep
        INTO TABLE lt_vbep
        FOR ALL ENTRIES IN lt_ekkn
        WHERE vbeln = lt_ekkn-vbeln AND
              posnr = lt_ekkn-vbelp .



    ENDIF.

    IF lt_vbak IS NOT INITIAL.

      SELECT kunnr
             name1
        FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbak
        WHERE kunnr = lt_vbak-kunnr.

    ENDIF.


    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM download.
    PERFORM display.
  ELSE.
    MESSAGE 'No Data Found!' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
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

  LOOP AT lt_ekpo INTO ls_ekpo.

    ls_final-ebeln = ls_ekpo-ebeln.
    ls_final-ebelp = ls_ekpo-ebelp.
    ls_final-matnr = ls_ekpo-matnr.
    ls_final-txz01 = ls_ekpo-txz01.
    ls_final-menge = ls_ekpo-menge.

    READ TABLE lt_ekko INTO ls_ekko WITH KEY ebeln = ls_final-ebeln .
    IF sy-subrc = 0.
      ls_final-lifnr  = ls_ekko-lifnr.
      ls_final-aedat  = ls_ekko-aedat.
      ls_final-ekgrp  = ls_ekko-ekgrp.

    ENDIF.

    READ TABLE lt_lfa1 INTO ls_lfa1 WITH KEY lifnr = ls_final-lifnr.

    IF sy-subrc = 0.

      READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_lfa1-adrnr.
      IF sy-subrc = 0.
        ls_final-name1 = ls_adrc-name1.

      ENDIF.

    ENDIF.

    READ TABLE lt_ekkn INTO ls_ekkn WITH KEY ebeln = ls_final-ebeln
                                             ebelp = ls_ekpo-ebelp.
    IF sy-subrc = 0.
      ls_final-vbeln = ls_ekkn-vbeln.
      ls_final-vbelp = ls_ekkn-vbelp.

    ENDIF.

    READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_final-vbeln.
    IF sy-subrc = 0 .
      ls_final-kunnr = ls_vbak-kunnr.
      ls_final-vkbur = ls_vbak-vkbur.
    ENDIF.

    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_final-kunnr.
    IF sy-subrc = 0.
      ls_final-name12 = ls_kna1-name1.

    ENDIF.

    READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_final-vbeln
                                             posnr = ls_final-vbelp.
    IF sy-subrc = 0.
      ls_final-kwmeng = ls_vbap-kwmeng.

    ENDIF.

    READ TABLE lt_vbep INTO ls_vbep WITH KEY vbeln = ls_final-vbeln
                                             posnr = ls_final-vbelp.


    READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_final-matnr.
    IF sy-subrc = 0.
      ls_final-zseries = ls_mara-zseries.
      ls_final-zsize   = ls_mara-zsize.

    ENDIF.

    READ TABLE lt_mska INTO ls_mska WITH KEY matnr = ls_final-matnr
                                             vbeln = ls_final-vbeln
                                             posnr = ls_final-vbelp
                                             lgort = 'TPI1'.
    IF sy-subrc = 0.
      ls_final-kalab = ls_mska-kalab.

    ENDIF.

    LOOP AT lt_ekbe INTO ls_ekbe WHERE ebeln = ls_final-ebeln AND
                                       ebelp = ls_ekpo-ebelp.

      IF ls_ekbe-bwart = '101'.
        ls_final-del_menge = ls_final-del_menge + ls_ekbe-menge.

      ELSEIF ls_ekbe-bwart = '102'.
        gv_lfbnr = ls_ekbe-lfbnr .
*
        LOOP AT lt_ekbe INTO ls_ekbe WHERE ebeln = ls_final-ebeln AND
                                           ebelp = ls_ekpo-ebelp  AND
                                           lfbnr =  gv_lfbnr      AND
                                           bwart = '101'.
          ls_final-del_menge = ls_final-del_menge - ls_ekbe-menge.

        ENDLOOP.


      ENDIF.

    ENDLOOP.

    ls_final-still_del = ls_final-menge - ls_final-del_menge .



*ls_vbep-etenr

**TPI TEXT

    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
    lv_name = ls_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z999'
        language                = 'E'
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

    READ TABLE lv_lines INTO wa_lines INDEX 1.

    CLEAR wa_text.
    wa_text = wa_lines-tdline(20).
    TRANSLATE wa_text TO UPPER CASE .
    ls_final-tpi         = wa_text.     "TPI Required


    SHIFT ls_final-vbeln LEFT DELETING LEADING '0'.
    SHIFT ls_final-vbelp LEFT DELETING LEADING '0'.

    CONCATENATE ls_final-vbeln ls_final-vbelp
     INTO ls_final-sh_id SEPARATED BY '-'.

    APPEND ls_final TO lt_final.
    CLEAR ls_final.
    CLEAR : ls_mara,ls_ekkn,ls_vbak,ls_adrc,ls_lfa1,ls_ekko,ls_ekpo,ls_kna1.

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

  PERFORM fcat USING : '1'    'EBELN'       'LT_FINAL'  'PO NO'             '18' .
  PERFORM fcat USING : '2'    'EBELP'       'LT_FINAL'  'PO Line Item'      '18' .
  PERFORM fcat USING : '3'    'LIFNR'       'LT_FINAL'  'Vendor Code'       '18' .
  PERFORM fcat USING : '4'    'NAME1'       'LT_FINAL'  'Vendor Name'       '40' .
  PERFORM fcat USING : '5'    'AEDAT'       'LT_FINAL'  'PO Date'           '18' .
  PERFORM fcat USING : '6'    'EKGRP'       'LT_FINAL'  'Purchasing Group'  '18' .
  PERFORM fcat USING : '7'    'MATNR'       'LT_FINAL'  'Material'          '18' .
  PERFORM fcat USING : '8'    'TXZ01'       'LT_FINAL'  'Long Text'         '40' .
  PERFORM fcat USING : '9'    'MENGE'       'LT_FINAL'  'PO Qty'            '18' .
  PERFORM fcat USING : '10'   'DEL_MENGE'   'LT_FINAL'  'Delivered Qty'     '18' .
  PERFORM fcat USING : '11'   'STILL_DEL'   'LT_FINAL'  'Still To Be Delivered Qty'     '18' .
  PERFORM fcat USING : '12'   'VBELN'       'LT_FINAL'  'Sale Order No'     '18' .
  PERFORM fcat USING : '13'   'VBELP'       'LT_FINAL'  'Line Item'         '18' .
  PERFORM fcat USING : '14'   'SH_ID'       'LT_FINAL'  'Schedule ID'       '30' .
  PERFORM fcat USING : '15'   'KUNNR'       'LT_FINAL'  'Customer'          '40' .
  PERFORM fcat USING : '16'   'NAME12'       'LT_FINAL'  'Customer Name'     '40' .
  PERFORM fcat USING : '17'   'VKBUR'       'LT_FINAL'  'Branch'            '18' .
  PERFORM fcat USING : '18'   'KWMENG'      'LT_FINAL'  'SO Qty'            '18' .
  PERFORM fcat USING : '19'   'KALAB'       'LT_FINAL'  'TPI Stock'         '18' .
  PERFORM fcat USING : '20'   'ZSERIES'     'LT_FINAL'  'Series'            '18' .
  PERFORM fcat USING : '21'   'ZSIZE'       'LT_FINAL'  'Size'              '18' .
  PERFORM fcat USING : '22'   'TPI'         'LT_FINAL'  'TPI Remark'        '25' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1097   text
*      -->P_1098   text
*      -->P_1099   text
*      -->P_1100   text
*      -->P_1101   text
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
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .

  LOOP AT lt_final INTO ls_final.

    ls_down-ebeln = ls_final-ebeln.
    ls_down-ebelp = ls_final-ebelp.
    ls_down-matnr = ls_final-matnr.
    ls_down-txz01 = ls_final-txz01.
    ls_down-menge = ls_final-menge.

    IF ls_down-menge LT 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = ls_down-menge.
    ENDIF.

    ls_down-lifnr = ls_final-lifnr.
*    ls_down-aedat = ls_final-aedat.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-aedat
      IMPORTING
        output = ls_down-aedat.

    CONCATENATE ls_down-aedat+0(2) ls_down-aedat+2(3) ls_down-aedat+5(4)
    INTO ls_down-aedat SEPARATED BY '-'.

    ls_down-ekgrp = ls_final-ekgrp.
    ls_down-name1 = ls_final-name1.
    ls_down-vbeln = ls_final-vbeln.
    ls_down-vbelp = ls_final-vbelp.
    ls_down-kunnr = ls_final-kunnr.
    ls_down-vkbur = ls_final-vkbur.
    ls_down-kwmeng = ls_final-kwmeng.

    IF ls_down-kwmeng LT 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = ls_down-kwmeng.
    ENDIF.

    ls_down-zseries = ls_final-zseries.
    ls_down-zsize   = ls_final-zsize.
    ls_down-kalab   =  ls_final-kalab.
    ls_down-del_menge = ls_final-del_menge.

    IF ls_down-del_menge LT 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = ls_down-del_menge.
    ENDIF.

    ls_down-still_del = ls_final-still_del.

    IF ls_down-still_del LT 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = ls_down-still_del.
    ENDIF.


    ls_down-sh_id = ls_final-sh_id.
    ls_down-tpi = ls_final-tpi .

    ls_down-name12 = ls_final-name12.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref_dat.

    CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
    INTO ls_down-ref_dat SEPARATED BY '-'.

    ls_down-ref_time = sy-uzeit.
    CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2) ':'  ls_down-ref_time+4(2) INTO ls_down-ref_time.

    CONDENSE ls_down-ref_time NO-GAPS .
    APPEND ls_down TO lt_down.
    CLEAR : ls_down,ls_final.



  ENDLOOP.

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


  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = ls_layout
      it_fieldcat        = it_fcat[]
    TABLES
      t_outtab           = lt_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download_excel.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_excel .

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
  lv_file = 'ZPO_SO_DETAILS.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZPO_SO_DETAILS Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_928 TYPE string.
DATA lv_crlf_928 TYPE string.
lv_crlf_928 = cl_abap_char_utilities=>cr_lf.
lv_string_928 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_928 lv_crlf_928 wa_csv INTO lv_string_928.
  CLEAR: wa_csv.
ENDLOOP.

*SHIFT lv_string_928 RIGHT DELETING TRAILING SPACE.  """" added by nc

*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_928 TO lv_fullfile.
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

  CONCATENATE 'PO NO'
              'PO Line Item'
              'Vendor Code'
              'Vendor Name'
              'PO Date'
              'Purchasing Group'
              'Material'
              'Long Text'
              'PO Qty'
              'Delivered Qty'
              'Still To Be Delivered Qty'
              'Sale Order No'
              'Line Item'
              'Schedule ID'
              'Customer'
              'Customer Name'
              'Branch'
              'SO Qty'
              'TPI Stock'
              'Series'
              'Size'
              'TPI Remark'
              'Refresh Date'
              'Refresh Time'

          INTO p_hd_csv
  SEPARATED BY l_field_seperator.
ENDFORM.
