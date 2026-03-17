*&---------------------------------------------------------------------*
*& Report ZUS_SHORTFALLL_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&Report: ZUS_SHORTFALLL_NEW
*&Transaction
*&Functional Cosultant: Tejaswini Kapadnis
*&Technical Consultant: Pranit Chavan
*&TR:
*&Date:
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_SHORTFALLL_NEW.

TABLES:vbak.


TYPES: BEGIN OF ty_vbak,
         vbeln  TYPE vbak-vbeln,
         erdat  TYPE vbak-erdat,
         audat  TYPE vbak-audat,
         vbtyp  TYPE vbak-vbtyp,
         auart  TYPE vbak-auart,
         vkorg  TYPE vbak-vkorg,
         kunnr  TYPE vbak-kunnr,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         kwmeng TYPE vbap-kwmeng,
         werks  TYPE vbap-werks,
       END OF ty_vbak,

       BEGIN OF ty_vbap,
         vbeln       TYPE vbap-vbeln,
         posnr       TYPE vbap-posnr,
         matnr       TYPE vbap-matnr,
         kwmeng      TYPE vbap-kwmeng,
         custdeldate TYPE vbap-custdeldate,
       END OF ty_vbap,

       BEGIN OF ty_vbap2,
         vbeln       TYPE vbap-vbeln,
         posnr       TYPE vbap-posnr,
         matnr       TYPE vbap-matnr,
         kwmeng      TYPE vbap-kwmeng,
         custdeldate TYPE vbap-custdeldate,
         ind         TYPE c,
       END OF ty_vbap2,

       BEGIN OF ty_vbkd,
         vbeln TYPE vbkd-vbeln,
         posnr TYPE vbkd-posnr,
         bstkd TYPE vbkd-bstkd,
         bstdk TYPE vbkd-bstdk,
       END OF ty_vbkd,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         labst TYPE mard-labst,
         insme TYPE mard-insme,
         diskz TYPE mard-diskz,
       END OF ty_mard,

       BEGIN OF ty_t001l,
         werks TYPE t001l-werks,
         lgort TYPE t001l-lgort,
         diskz TYPE t001l-diskz,
       END OF ty_t001l,

       BEGIN OF ty_lips,
         vbeln TYPE lips-vbeln,
         posnr TYPE lips-posnr,
         werks TYPE lips-werks,
         lfimg TYPE lips-lfimg,
         vgbel TYPE lips-vgbel,
         vgpos TYPE lips-vgpos,
       END OF ty_lips,

       BEGIN OF ty_final,
         kunnr       TYPE vbak-kunnr,
         name1       TYPE kna1-name1,
         bstkd       TYPE vbkd-bstkd,
         bstdk       TYPE vbkd-bstdk,
         vbeln       TYPE vbap-vbeln,
         posnr       TYPE vbap-posnr,
         audat       TYPE vbak-audat,
         matnr       TYPE vbap-matnr,
         wrkst       TYPE mara-wrkst,
*         maktx       TYPE makt-maktx,
         lv_longtxt  TYPE char255,
         custdeldate TYPE vbap-custdeldate,
         kalab       TYPE p DECIMALS 2,
         kwmeng      TYPE p DECIMALS 2,
         pnd_so      TYPE vbap-kwmeng,
         so_srt      TYPE vbap-kwmeng,
         trnst       TYPE vbap-kwmeng,
         alloc       TYPE vbap-kwmeng,
         lfimg       TYPE lips-lfimg,
         ind         TYPE char50,
         zseries     TYPE mara-zseries,
         zsize       TYPE mara-zsize,
         brand       TYPE mara-brand,
         moc         TYPE mara-moc,
         type        TYPE mara-type,

       END OF ty_final,

       BEGIN OF ty_down,
         kunnr       TYPE vbak-kunnr, "customer
         name1       TYPE kna1-name1,  "CUSTOMER NAME
         bstkd       TYPE vbkd-bstkd, " customer po
         bstdk       TYPE char15,      "customer po date
         vbeln       TYPE vbap-vbeln,  " sales order
         posnr       TYPE vbap-posnr,  " SO line item
         audat       TYPE char15,      "so Date
         matnr       TYPE vbap-matnr, " material
         wrkst       TYPE mara-wrkst,  "saudi Code
*         maktx       TYPE makt-maktx,  "material Description
         lv_longtxt  TYPE char255, "material Description
         custdeldate TYPE char15,      "CDD
         kwmeng      TYPE char15,      "SO qty
         pnd_so      TYPE char15,      "Pend so qty
         alloc       TYPE char15,     "allocation
         so_srt      TYPE char15,     " shortfall qty
         ind         TYPE char50,     "allocation details
         zseries     TYPE mara-zseries, "series
         zsize       TYPE mara-zsize,  "size
         brand       TYPE mara-brand,  "brand
         moc         TYPE mara-moc,    "moc
         type        TYPE mara-type,   "type
         ref         TYPE char15,      "referesh
         time        TYPE char15,         "added by Nilay on 03.01.2023
       END OF ty_down.

*****************************************TRANSIT REPORT
TYPES:BEGIN OF ty_mara,
        matnr   TYPE mara-matnr,
        wrkst   TYPE mara-wrkst,
        zseries TYPE mara-zseries,
        zsize   TYPE mara-zsize,
        brand   TYPE mara-brand,
        moc     TYPE mara-moc,
        type    TYPE mara-type,
      END OF ty_mara,

      BEGIN OF ty_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF ty_makt,

      BEGIN OF ty_ekpo,
        ebeln TYPE vbak-bstnk, "ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        werks TYPE ekpo-werks,
        menge TYPE ekpo-menge,
        matnr TYPE ekpo-matnr,
      END OF ty_ekpo,

      BEGIN OF ty_ekko,
        ebeln TYPE vbak-bstnk, "ekko-ebeln,
        bukrs TYPE ekko-bukrs,
        aedat TYPE ekko-aedat,
        bedat TYPE ekko-bedat,
        lifnr TYPE ekko-lifnr,
      END OF ty_ekko,


*      BEGIN OF ty_vbak,
*        vbeln TYPE vbak-vbeln,
*        bstnk TYPE vbak-bstnk,
*      END OF ty_vbak,

      BEGIN OF str_vbap,
        vbeln  TYPE vbap-vbeln,
        posnr  TYPE vbap-posnr,
        matnr  TYPE vbap-matnr,
        kwmeng TYPE vbap-kwmeng,
        posex  TYPE vbap-posex,
      END OF str_vbap,

      BEGIN OF ty_vbrp,
        vbeln     TYPE vbrp-vbeln,
        posnr     TYPE vbrp-posnr,
        fkimg     TYPE vbrp-fkimg,
        vgbel(16),
        vgpos     TYPE vbrp-vgpos,
        aubel     TYPE vbrp-aubel,
        aupos     TYPE vbrp-aupos,
        matnr     TYPE vbrp-matnr,
        werks     TYPE vbrp-werks,
      END OF ty_vbrp,

      BEGIN OF ty_vbrk,
        vbeln  TYPE vbrk-vbeln,
        fkart  TYPE vbrk-fkart,
        fkdat  TYPE vbrk-fkdat,
        knumv  TYPE vbrk-knumv,
        rfbsk  TYPE vbrk-rfbsk,
        kunag  TYPE vbrk-kunag,
        exnum  TYPE vbrk-exnum,
        xblnr  TYPE vbrk-xblnr,
        logsys TYPE vbrk-logsys,
        fksto  TYPE vbrk-fksto,
      END OF ty_vbrk,

      BEGIN OF ty_vapma,
        matnr TYPE vapma-matnr,
        vkorg TYPE vapma-vkorg,
        bstnk TYPE vapma-bstnk,
        vbeln TYPE vapma-vbeln,
        posnr TYPE vapma-posnr,
        werks TYPE vapma-werks,
      END OF ty_vapma,




      BEGIN OF ty_eikp,
        exnum TYPE eikp-exnum,
        iever TYPE eikp-iever,
      END OF ty_eikp,

      BEGIN OF ty_mode,
        expvz TYPE ztransit-expvz,
        bezei TYPE ztransit-bezei,
        zdays TYPE ztransit-zdays,
      END OF ty_mode,

      BEGIN OF ty_konv,
        knumv TYPE PRCD_ELEMENTS-knumv,
        kposn TYPE PRCD_ELEMENTS-kposn,
        kschl TYPE PRCD_ELEMENTS-kschl,
        kbetr TYPE PRCD_ELEMENTS-kbetr,
        kwert TYPE PRCD_ELEMENTS-kwert,
      END OF ty_konv,

      BEGIN OF ty_kna1,
        kunnr TYPE kna1-kunnr,
        land1 TYPE kna1-land1,
        ort01 TYPE kna1-ort01,
        pstlz TYPE kna1-pstlz,
      END OF ty_kna1,

      BEGIN OF ty_t005t,
        spras TYPE t005t-spras,
        land1 TYPE t005t-land1,
        landx TYPE t005t-landx,
      END OF ty_t005t,

      BEGIN OF ty_likp,
        vbeln TYPE likp-vbeln,
        verur TYPE likp-verur,
      END OF ty_likp,


      BEGIN OF ty_t618t,
        spras TYPE t618t-spras,
        land1 TYPE t618t-land1,
        expvz TYPE t618t-expvz,
        bezei TYPE t618t-bezei,
      END OF ty_t618t,

      BEGIN OF ty_mseg,
        mblnr(16)," TYPE mseg-mblnr,
        mjahr      TYPE mseg-mjahr,
        bwart      TYPE mseg-bwart,
        matnr      TYPE mseg-matnr,
        werks      TYPE mseg-werks,
        smbln      TYPE mseg-smbln,
        xblnr_mkpf TYPE mseg-xblnr_mkpf,
        vbeln_im   TYPE mseg-vbeln_im,
        vbelp_im   TYPE mseg-vbelp_im,
      END OF ty_mseg,

      BEGIN OF ty_bkpf,
        belnr TYPE bkpf-belnr,
        blart TYPE bkpf-blart,
        xblnr TYPE bkpf-xblnr,
        stblg TYPE bkpf-stblg,
      END OF ty_bkpf,

      BEGIN OF ty_marc,
        matnr TYPE marc-matnr,
        werks TYPE marc-werks,
      END OF ty_marc,


      BEGIN OF ty_mska,
        matnr TYPE mska-matnr,
        werks TYPE mska-werks,
        lgort TYPE mska-lgort,
        sobkz TYPE mska-sobkz,
        vbeln TYPE mska-vbeln,
        posnr TYPE mska-posnr,
        kalab TYPE mska-kalab,
        kains TYPE mska-kains,
        kaspe TYPE mska-kaspe,
        kavla TYPE mska-kavla,
        kavin TYPE mska-kavin,
        kavsp TYPE mska-kavsp,
        kavei TYPE mska-kavei,
      END OF ty_mska,

      BEGIN OF str_final,
        matnr    TYPE mara-matnr,
        wrkst    TYPE mara-wrkst,
        zseries  TYPE mara-zseries,
        zsize    TYPE mara-zsize,
        brand    TYPE mara-brand,
        moc      TYPE mara-moc,
        type     TYPE mara-type,
*      maktx       TYPE makt-maktx,
        desc     TYPE char100,
        ebeln    TYPE ekpo-ebeln,
        ebelp    TYPE ekpo-ebelp,
        menge    TYPE ekpo-menge,
        lifnr    TYPE lfa1-lifnr,
        name1    TYPE lfa1-name1,
        vbeln    TYPE vbap-vbeln,
        posnr    TYPE vbap-posnr,
        kwmeng   TYPE char15,
        inv_no   TYPE vbrp-vbeln,
        inv_line TYPE vbrp-posnr,
        fkimg    TYPE vbrp-fkimg,
        fkdat    TYPE vbrk-fkdat,
        xblnr    TYPE vbrk-xblnr,
        kbetr    TYPE PRCD_ELEMENTS-kbetr,
        kwert    TYPE PRCD_ELEMENTS-kwert,
        pono     TYPE char15,
        bezei    TYPE ztransit-bezei,
        arrival  TYPE sy-datum,
        due      TYPE sy-datum,
        port     TYPE char100,
        place    TYPE string,
        stock    TYPE mard-labst,
        pend     TYPE vbrp-fkimg,
        mblnr    TYPE mseg-mblnr,
        vbeln_im TYPE mseg-vbeln_im,
        belnr    TYPE bkpf-belnr,
        werks    TYPE ekpo-werks,
      END OF str_final,

      BEGIN OF ty_trans,
        matnr TYPE mara-matnr,
        fkimg TYPE vbrp-fkimg,
      END OF ty_trans.

DATA : it_trans TYPE TABLE OF ty_trans,
       wa_trans TYPE          ty_trans.

DATA :day TYPE i.
DATA: s   TYPE char50,
      t   TYPE char50,
      qty TYPE char10.

DATA: it_mara    TYPE TABLE OF ty_mara,
      wa_mara    TYPE          ty_mara,

      lt_mara    TYPE TABLE OF ty_mara,
      ls_mara    TYPE          ty_mara,

      it_makt    TYPE TABLE OF ty_makt,
      wa_makt    TYPE          ty_makt,

      it_ekko    TYPE TABLE OF ty_ekko,
      wa_ekko    TYPE          ty_ekko,

      it_ekpo    TYPE TABLE OF ty_ekpo,
      wa_ekpo    TYPE          ty_ekpo,

      it_mska    TYPE TABLE OF ty_mska,
      wa_mska    TYPE          ty_mska,


      it_likp    TYPE TABLE OF ty_likp,
      wa_likp    TYPE          ty_likp,


      lt_vbap    TYPE TABLE OF str_vbap,
      ls_vbap    TYPE          str_vbap,


      it_vbrp    TYPE TABLE OF ty_vbrp,
      wa_vbrp    TYPE          ty_vbrp,

      it_vbrk    TYPE TABLE OF ty_vbrk,
      wa_vbrk    TYPE          ty_vbrk,

      it_vapma   TYPE TABLE OF ty_vapma,
      wa_vapma   TYPE          ty_vapma,

      it_eikp    TYPE TABLE OF ty_eikp,
      wa_eikp    TYPE          ty_eikp,

      it_t618t   TYPE TABLE OF ty_t618t,
      wa_t618t   TYPE          ty_t618t,

      it_mode    TYPE TABLE OF ty_mode,
      wa_mode    TYPE          ty_mode,

      it_mseg    TYPE TABLE OF ty_mseg,
      wa_mseg    TYPE          ty_mseg,

      it_mseg1   TYPE TABLE OF ty_mseg,
      wa_mseg1   TYPE          ty_mseg,

      it_bkpf    TYPE TABLE OF ty_bkpf,
      wa_bkpf    TYPE          ty_bkpf,

      it_bkpf1   TYPE TABLE OF ty_bkpf,
      wa_bkpf1   TYPE          ty_bkpf,

      it_rev     TYPE TABLE OF ty_mseg,
      wa_rev     TYPE          ty_mseg,

      it_konv    TYPE TABLE OF ty_konv,
      wa_konv    TYPE          ty_konv,

      it_kna1    TYPE TABLE OF ty_kna1,
      wa_kna1    TYPE          ty_kna1,

      it_t005t   TYPE TABLE OF ty_t005t,
      wa_t005t   TYPE          ty_t005t,

      it_marc    TYPE TABLE OF ty_marc,
      wa_marc    TYPE          ty_marc,

      it_transit TYPE TABLE OF str_final,
      wa_transit TYPE          str_final.


************************************************



DATA : it_vbak  TYPE TABLE OF ty_vbak,
       wa_vbak  TYPE          ty_vbak,

       it_vbap  TYPE TABLE OF ty_vbap,
       wa_vbap  TYPE          ty_vbap,

       it_vbap3 TYPE TABLE OF ty_vbap,
       wa_vbap3 TYPE          ty_vbap,

       it_vbkd  TYPE TABLE OF ty_vbkd,
       wa_vbkd  TYPE          ty_vbkd,

       it_mard  TYPE TABLE OF ty_mard,
       it_mard1 TYPE TABLE OF ty_mard,

       wa_mard  TYPE          ty_mard,
       wa_mard1 TYPE          ty_mard,

       it_t001l TYPE TABLE OF ty_t001l,
       wa_t001l TYPE          ty_t001l,

       it_lips  TYPE TABLE OF ty_lips,
       wa_lips  TYPE          ty_lips,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.

DATA : lt_fcat  TYPE slis_t_fieldcat_alv,
       ls_fcat  TYPE slis_fieldcat_alv,
       lv_matnr TYPE matnr.

DATA: tot_alloc_stk(20) TYPE c.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_vbeln FOR vbak-vbeln,
                 s_date  FOR vbak-audat,
                 p_vkorg FOR vbak-vkorg OBLIGATORY NO INTERVALS DEFAULT 'US00' MODIF ID bu .
*                   p_matnr TYPE vbap-matnr.
SELECTION-SCREEN: END OF BLOCK b1 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\USA'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


START-OF-SELECTION .
*  BREAK primus.
  PERFORM get_transit.
  PERFORM get_data.
  PERFORM sort_data.
  PERFORM get_fcat.
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
  SELECT a~vbeln
         a~erdat
         a~audat
         a~vbtyp
         a~auart
         a~vkorg
         a~kunnr
         b~posnr
         b~matnr
         b~kwmeng
         b~werks FROM vbak AS a
         JOIN vbap AS b ON a~vbeln = b~vbeln
         JOIN vbup AS c ON ( a~vbeln = c~vbeln AND b~posnr = c~posnr ) INTO TABLE it_vbak
         WHERE a~vbeln IN s_vbeln
           AND a~audat IN s_date
           AND a~vkorg IN p_vkorg
*         AND b~matnr = p_matnr
           AND c~lfsta  NE 'C'
           AND c~lfgsa  NE 'C'
           AND c~fksta  NE 'C'
           AND c~gbsta  NE 'C'.




  IF it_vbak IS NOT INITIAL.

    SELECT matnr
           wrkst
           zseries
           zsize
           brand
           moc
           type    FROM mara INTO TABLE lt_mara
           FOR ALL ENTRIES IN it_vbak
           WHERE matnr = it_vbak-matnr.

    SELECT vbeln
           posnr
           matnr
           kwmeng
           custdeldate
              FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbak
           WHERE vbeln = it_vbak-vbeln.


    SELECT vbeln
           posnr
           bstkd
           bstdk FROM vbkd INTO TABLE it_vbkd
           FOR ALL ENTRIES IN it_vbak
           WHERE vbeln = it_vbak-vbeln.

    SELECT matnr
           werks
           lgort
           labst
           insme
           diskz FROM mard INTO TABLE it_mard
           FOR ALL ENTRIES IN it_vbak
           WHERE matnr = it_vbak-matnr
            AND  werks = it_vbak-werks.


    SELECT matnr
         werks
         lgort
         sobkz
         vbeln
         posnr
         kalab
         kains
         kaspe
         kavla
         kavin
         kavsp
         kavei FROM mska INTO TABLE it_mska
         FOR ALL ENTRIES IN it_vbap
         WHERE matnr = it_vbap-matnr AND vbeln = it_vbap-vbeln
        " AND   POSNR = IT_VBAP-POSNR
         AND   werks IN ('US01','US02','US03')
         AND   sobkz = 'E'.

    SELECT werks
           lgort
           diskz FROM t001l INTO TABLE it_t001l
           FOR ALL ENTRIES IN it_mard
           WHERE lgort = it_mard-lgort
           AND   diskz NE '1'.

    SELECT matnr
            werks
            lgort
            labst
            insme
            diskz FROM mard INTO TABLE it_mard1
            FOR ALL ENTRIES IN it_t001l
            WHERE lgort = it_t001l-lgort
            AND diskz = ''.



    SELECT vbeln
           posnr
           werks
           lfimg
           vgbel
           vgpos FROM lips INTO TABLE it_lips
           FOR ALL ENTRIES IN it_vbak
           WHERE vgbel = it_vbak-vbeln
             AND vgpos = it_vbak-posnr.

  ENDIF.


  DELETE it_vbak WHERE auart = 'US04' . "'' , '' , '' ,'', '', '' ).
  DELETE it_vbak WHERE auart = 'US05' .
  DELETE it_vbak WHERE auart = 'US06' .
  DELETE it_vbak WHERE auart = 'US09' .
  DELETE it_vbak WHERE auart = 'US10' .
  DELETE it_vbak WHERE auart = 'US11' .
  DELETE it_vbak WHERE auart = 'US12' .
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
  DATA:stock         TYPE mard-labst,
       lv_stock      TYPE mard-labst,
       lv_mska_stock TYPE mard-labst,
       alloc         TYPE mard-labst,
       qty_al        TYPE mard-labst,
       tran_st       TYPE vbrp-fkimg,
       mb52          TYPE mard-labst,
       short         TYPE mard-labst.
  SORT it_vbak BY matnr audat.
  SORT it_vbap BY custdeldate.
  SORT it_vbap3.
*********************************************New code added by Shubhangi Sarode 22.01.2024
************************** Collect special indicator vbeln in another table.
  LOOP AT it_mska INTO wa_mska WHERE kalab <> 0.

    READ TABLE it_vbap INTO DATA(wa_vbap_3) WITH KEY vbeln = wa_mska-vbeln matnr = wa_mska-matnr.
    IF sy-subrc = 0.
      APPEND wa_vbap_3 TO it_vbap3.
    ENDIF.
    DELETE it_vbap  WHERE vbeln = wa_mska-vbeln AND matnr = wa_mska-matnr .
    CLEAR :wa_mska,wa_vbap_3.
  ENDLOOP.

  SORT it_vbap3 ASCENDING BY matnr custdeldate.
  SORT it_vbap ASCENDING BY matnr custdeldate.
*********************************************************************

  SORT lt_mara BY matnr.
  LOOP AT lt_mara INTO DATA(wa_mara).   """""""""""""""""""""""""""""""""""""Loop according to multiple materials.
    ON CHANGE OF wa_mara-matnr.

      CLEAR : wa_vbap3,wa_final.
      LOOP AT it_vbap3 INTO wa_vbap3 WHERE matnr = wa_mara-matnr.       """""" 1st proirity to Special indicator stock
        wa_final-custdeldate  = wa_vbap3-custdeldate.
        "READ TABLE IT_MSKA INTO WA_MSKA WITH KEY VBELN = WA_VBAP3-VBELN MATNR = WA_VBAP3-MATNR. " POSNR = WA_VBAP3-POSNR
        LOOP AT it_mska INTO wa_mska WHERE vbeln = wa_vbap3-vbeln AND matnr = wa_vbap3-matnr. " POSNR = WA_VBAP3-POSNR
          IF wa_mska-sobkz = 'E'.
            wa_final-kalab = wa_final-kalab + wa_mska-kalab.
          ENDIF.
          CLEAR : wa_mska.
        ENDLOOP.
        wa_final-alloc  =  wa_final-kalab.
        wa_final-vbeln  = wa_vbap3-vbeln .

        READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap3-vbeln posnr = wa_vbap3-posnr.
        IF sy-subrc = 0.
          wa_final-posnr    =  wa_vbak-posnr  .
          wa_final-matnr    =  wa_vbak-matnr  .
          wa_final-kwmeng   =  wa_vbak-kwmeng .
          wa_final-kunnr    =  wa_vbak-kunnr .
          wa_final-audat    =  wa_vbak-audat .

          ON CHANGE OF wa_vbak-matnr.
            CLEAR :stock,short,tran_st,mb52,t.

            LOOP AT it_mard1 INTO wa_mard1 WHERE matnr = wa_vbak-matnr.
              IF wa_mard1-labst IS NOT INITIAL.
                stock = stock + wa_mard1-labst.
              ENDIF.
              IF wa_mard1-insme IS NOT INITIAL.
                stock = stock + wa_mard1-insme.
              ENDIF.
            ENDLOOP.
            CLEAR:lv_mska_stock .
            LOOP AT it_mska INTO wa_mska WHERE kalab <> 0  AND matnr = wa_vbak-matnr.
              lv_mska_stock =  lv_mska_stock + wa_mska-kalab.
            ENDLOOP.

            IF lv_mska_stock IS NOT INITIAL.
              stock = stock + lv_mska_stock.
              mb52 = stock.
              lv_stock = stock.
            ENDIF.

            READ TABLE it_trans INTO wa_trans WITH KEY matnr = wa_vbak-matnr.
            IF sy-subrc = 0.
              tran_st = wa_trans-fkimg.
            ENDIF.

          ENDON.
        ENDIF.
        LOOP AT it_lips INTO wa_lips WHERE vgbel = wa_vbak-vbeln AND vgpos = wa_vbak-posnr.
          wa_final-lfimg = wa_final-lfimg + wa_lips-lfimg .
        ENDLOOP.
        wa_final-pnd_so = wa_vbak-kwmeng - wa_final-lfimg.
        wa_vbak-kwmeng = wa_final-pnd_so.

***        IF STOCK GE WA_VBAP3-KWMENG .
        wa_final-alloc = wa_final-alloc. " WA_VBAP3-KWMENG.
        stock = stock -   wa_final-alloc.
        wa_final-so_srt  = wa_final-pnd_so - wa_final-alloc.
        qty = wa_final-alloc.

*************************************Added on 21.02.2024 by Shubhangi Sarode

        CONCATENATE 'S' qty INTO s SEPARATED BY '-'.
        CONDENSE s.

********* If stock is zero then allocate transit stock.
        IF stock = 0 AND tran_st NE 0.

          stock = tran_st.
          wa_final-alloc = wa_final-alloc + wa_final-so_srt .
          wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.
          tran_st = tran_st - wa_final-so_srt.
          qty = wa_final-alloc.
          CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
          CONDENSE t.
        ENDIF.

***************************************End on dt 21.02.2024


        CLEAR :alloc,qty_al.


        "        CLEAR:S,T.
        alloc = wa_final-alloc.
        IF wa_final-alloc IS NOT INITIAL.
          IF mb52 GE alloc.
            CLEAR:qty.
            qty = alloc.
            qty_al = alloc.
***            CONCATENATE 'S' QTY INTO S SEPARATED BY '-'.
***            CONDENSE S.
            alloc = mb52 - alloc.
*    IF alloc > 0.
            mb52 = mb52 - qty_al.
*    ENDIF.

          ELSEIF mb52 > 0.
            CLEAR:qty.
            qty_al = alloc.
            alloc = alloc - mb52.
            qty = mb52.
***            CONCATENATE 'S' QTY INTO S SEPARATED BY '-'.
***            CONDENSE S.
            mb52 = mb52 - qty_al.
          ENDIF.
          IF alloc > 0.
            IF tran_st GE alloc.
              CLEAR:qty.
              qty = alloc.
              qty_al = alloc.
***              CONCATENATE  'T' QTY INTO T SEPARATED BY '-'.
***              CONDENSE T.
              alloc = alloc - tran_st .
***              TRAN_ST = TRAN_ST - QTY_AL.
            ELSEIF tran_st > 0 .
              CLEAR:qty.

              qty = tran_st.
              qty_al = alloc.
              alloc = alloc - tran_st .
***              CONCATENATE  'T' QTY INTO T SEPARATED BY '-'.
***              CONDENSE T.

***              TRAN_ST = TRAN_ST - QTY_AL .

            ENDIF.
          ENDIF.
        ENDIF.
        CONCATENATE s t INTO wa_final-ind SEPARATED BY ','.

        IF s IS INITIAL.
          REPLACE ',' WITH ' ' INTO wa_final-ind.
        ENDIF.


        IF t IS INITIAL.
          REPLACE ',' WITH ' ' INTO wa_final-ind.
        ENDIF.

        REPLACE '.000' WITH ' ' INTO wa_final-ind.
        REPLACE '.000' WITH ' ' INTO wa_final-ind.

        READ TABLE lt_mara INTO ls_mara WITH KEY matnr = wa_vbak-matnr.
        IF sy-subrc = 0.
          wa_final-zseries    =  ls_mara-zseries.
          wa_final-zsize      =  ls_mara-zsize  .
          wa_final-brand      =  ls_mara-brand  .
          wa_final-moc        =  ls_mara-moc    .
          wa_final-type       =  ls_mara-type   .
        ENDIF.
        READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_vbak-vbeln.
        IF sy-subrc = 0.
          wa_final-bstkd  =  wa_vbkd-bstkd .
          wa_final-bstdk  =  wa_vbkd-bstdk .
        ENDIF.
*==============================================================        ADDED BY MA ON 08.03.2024.

        SELECT SINGLE name1 FROM kna1 INTO @DATA(lv_name1) WHERE kunnr = @wa_final-kunnr.

        wa_final-name1 = lv_name1.
        CLEAR lv_name1.

        DATA: lv_id    TYPE thead-tdname,
              lt_lines TYPE STANDARD TABLE OF tline,
              ls_lines TYPE  tline.

        IF wa_final-matnr IS NOT INITIAL.
          lv_id = wa_final-matnr .
          CLEAR: lt_lines,ls_lines.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = 'GRUN'
              language                = 'E'
              name                    = lv_id
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
          IF NOT lt_lines IS INITIAL.
            LOOP AT lt_lines INTO ls_lines.
              IF NOT ls_lines-tdline IS INITIAL.
                REPLACE ALL OCCURRENCES OF '<&>' IN ls_lines-tdline WITH '&'.
                CONCATENATE wa_final-lv_longtxt ls_lines-tdline INTO wa_final-lv_longtxt SEPARATED BY space.
              ENDIF.
            ENDLOOP.
*        CONDENSE lv_longtxt.
          ENDIF.
        ENDIF.
*==============================================================


*        SELECT SINGLE maktx INTO wa_final-maktx FROM makt WHERE matnr = wa_vbak-matnr.
        SELECT SINGLE wrkst INTO wa_final-wrkst FROM mara WHERE matnr = wa_vbak-matnr.




        APPEND wa_final TO it_final.
        CLEAR: wa_final, wa_vbap3,wa_mska,t.
      ENDLOOP.
****************************************  end 22.01.2024
      SORT it_vbap BY matnr custdeldate vbeln.
      LOOP AT it_vbap INTO wa_vbap WHERE matnr = wa_mara-matnr.
        wa_final-custdeldate  =  wa_vbap-custdeldate.
        wa_final-vbeln    =  wa_vbap-vbeln  .
        wa_final-kwmeng   =  wa_vbap-kwmeng .
        wa_final-posnr    =  wa_vbap-posnr .
        lv_matnr =  wa_vbap-matnr.
        "sort it_mska DESCENDING by vbeln.
        READ TABLE it_mska INTO wa_mska WITH KEY vbeln = wa_vbap-vbeln posnr = wa_vbap-posnr matnr = wa_vbap-matnr.
        IF wa_mska-sobkz = 'E'.
          wa_final-kalab = wa_mska-kalab.
        ENDIF.

        "sort it_vbak DESCENDING by vbeln.
        READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln ."posnr = wa_vbap-posnr.
        IF sy-subrc = 0.
          "WA_FINAL-VBELN    =  WA_VBAK-VBELN  .
        "  wa_final-posnr    =  wa_vbak-posnr  .
          wa_final-matnr    =  wa_vbak-matnr  .
        "  wa_final-kwmeng   =  wa_vbak-kwmeng .
          wa_final-kunnr    =  wa_vbak-kunnr .
          wa_final-audat    =  wa_vbak-audat .
*==============================================================        ADDED BY MA ON 08.03.2024.

          SELECT SINGLE name1 FROM kna1 INTO @DATA(lv_name2) WHERE kunnr = @wa_final-kunnr.

          wa_final-name1 = lv_name2.
          CLEAR lv_name2.

*          DATA: lv_id    TYPE thead-tdname,
*                lt_lines TYPE STANDARD TABLE OF tline,
*                ls_lines  type  tline.

          IF wa_final-matnr IS NOT INITIAL.
            lv_id = wa_final-matnr .
            CLEAR: lt_lines,ls_lines.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'GRUN'
                language                = 'E'
                name                    = lv_id
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
            IF NOT lt_lines IS INITIAL.
              LOOP AT lt_lines INTO ls_lines.
                IF NOT ls_lines-tdline IS INITIAL.
                  REPLACE ALL OCCURRENCES OF '<&>' IN ls_lines-tdline WITH '&'.
                  CONCATENATE wa_final-lv_longtxt ls_lines-tdline INTO wa_final-lv_longtxt SEPARATED BY space.
                ENDIF.
              ENDLOOP.
*        CONDENSE lv_longtxt.
            ENDIF.
          ENDIF.

          CLEAR : lv_id , lt_lines  , ls_lines.
*==============================================================



          ON CHANGE OF wa_vbak-matnr.
            IF lv_stock  = 0. """"""""""""""""""""""""""""""""""""""""""""""  ADDED IF STOCK IS NOT AVAILABLE IN ABOVE LOOP by Shubhangi Sarode
              CLEAR :stock,short,tran_st,mb52.
              " sort it_mard1.
              LOOP AT it_mard1 INTO wa_mard1 WHERE matnr = wa_vbak-matnr.
                IF wa_mard1-labst IS NOT INITIAL.
                  stock = stock + wa_mard1-labst.
                ENDIF.
                IF wa_mard1-insme IS NOT INITIAL.
                  stock = stock + wa_mard1-insme.
                ENDIF.
              ENDLOOP.

              IF stock IS NOT INITIAL.
                mb52 = stock.
              ENDIF.
            ENDIF.      """"""""""""""""""""""""""""""""""""""""""""""""""""
            READ TABLE it_trans INTO wa_trans WITH KEY matnr = wa_vbak-matnr.
            IF sy-subrc = 0.
              tran_st = wa_trans-fkimg.
            ENDIF.
          ENDON.
        ENDIF.
        LOOP AT it_lips INTO wa_lips WHERE vgbel = wa_vbak-vbeln AND vgpos = wa_vbak-posnr.
          wa_final-lfimg = wa_final-lfimg + wa_lips-lfimg .
        ENDLOOP.
        wa_final-pnd_so = wa_vbak-kwmeng - wa_final-lfimg.
        wa_vbak-kwmeng = wa_final-pnd_so.

        "**********   Start on 06.02.2024
        """"" vbap-vbeln = 489.

        IF stock <> 0.
**          BREAK primus.
          LOOP AT  it_final INTO DATA(wa_final_temp1) WHERE  custdeldate LE wa_final-custdeldate AND matnr = wa_mara-matnr.. " SO_SRT LE STOCK AND"AND ALLOC LT STOCK.
            """   479 , 490  stock allocated
            IF wa_final_temp1-so_srt <> 0.

              DATA(allocation) = wa_final_temp1-alloc.
              DATA(stk)        = stock.
              IF stock > wa_final_temp1-so_srt.
                wa_final_temp1-alloc = wa_final_temp1-alloc + wa_final_temp1-so_srt.
                stock = stock - wa_final_temp1-so_srt.
              ELSE.
                wa_final_temp1-alloc = wa_final_temp1-alloc + stock.
                stock = mb52 - stock.
              ENDIF.
              wa_final_temp1-so_srt = wa_final_temp1-pnd_so - wa_final_temp1-alloc.
              mb52 = stock.

              IF NOT stk IS INITIAL.
                CLEAR  wa_final_temp1-ind.
                tot_alloc_stk = allocation + stk - mb52.
                CONDENSE tot_alloc_stk.
                CONCATENATE 'S' tot_alloc_stk INTO wa_final_temp1-ind SEPARATED BY '-'.
**                CONCATENATE 'S' tot_alloc_stk2 INTO wa_final_temp1-ind SEPARATED BY '-'.
              ENDIF.

              IF stock = 0 AND wa_final_temp1-pnd_so NE wa_final_temp1-alloc.
                IF stock = 0 AND tran_st NE 0.
                  IF wa_final_temp1-so_srt LE tran_st.
                    DATA(tran_st3) = tran_st.
                    wa_final_temp1-alloc = wa_final_temp1-alloc + wa_final_temp1-so_srt .
                    tran_st = tran_st - wa_final_temp1-so_srt.
                    wa_final_temp1-so_srt = wa_final_temp1-pnd_so - wa_final_temp1-alloc.
**                  TRAN_ST = TRAN_ST - WA_FINAL_TEMP1-SO_SRT.

                    qty = tran_st3 - tran_st.
                    CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                    CONDENSE t.

                    IF t IS INITIAL.
                      REPLACE ',' WITH ' ' INTO wa_final_temp1-ind.
                    ENDIF.
                    REPLACE '.000' WITH ' ' INTO wa_final_temp1-ind.

                    CONCATENATE wa_final_temp1-ind t INTO wa_final_temp1-ind SEPARATED BY ','.
                  ELSE.
                    DATA(tran_st3n) = tran_st.
                    DATA(allc) = wa_final_temp1-alloc.
                    wa_final_temp1-alloc = wa_final_temp1-alloc + wa_final_temp1-so_srt .
**                    TRAN_ST = TRAN_ST - WA_FINAL_TEMP1-SO_SRT.
                    wa_final_temp1-so_srt = wa_final_temp1-pnd_so - allc - tran_st.
                    CLEAR tran_st.

                    qty = tran_st3n - tran_st.
                    CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                    CONDENSE t.
                    IF t IS INITIAL.
                      REPLACE ',' WITH ' ' INTO wa_final_temp1-ind.
                    ENDIF.
                    REPLACE '.000' WITH ' ' INTO wa_final_temp1-ind.
                    CONCATENATE wa_final_temp1-ind t INTO wa_final_temp1-ind SEPARATED BY ','.
                  ENDIF.
                ENDIF.
              ENDIF.


              MODIFY it_final FROM wa_final_temp1 TRANSPORTING alloc so_srt ind WHERE vbeln = wa_final_temp1-vbeln AND matnr = wa_mara-matnr.
              CLEAR : wa_final_temp1.

            ENDIF.
**            BREAK PRIMUS.
*************************************Added on 21.02.2024 by Shubhangi Sarode
**** If stock is zero then allocate transit stock.
*            IF STOCK = 0 AND TRAN_ST NE 0.
*              DATA(TRAN_ST3) = TRAN_ST.
****
****"""""""""""""""""""" commented by pavan need to add below logic on 23.02.2023. """"""""""""""""""""""""""""""
*              STOCK = TRAN_ST.
*              MB52 = STOCK.
****              WA_FINAL-ALLOC = WA_FINAL-ALLOC + WA_FINAL-SO_SRT .
****              WA_FINAL-SO_SRT = WA_FINAL-PND_SO - WA_FINAL-ALLOC.
****              TRAN_ST = TRAN_ST - WA_FINAL-SO_SRT.
****"""""""""""""""""""" commented by pavan need to add below logic on 23.02.2023. """"""""""""""""""""""""""""""


*            ENDIF.
***************************************End on dt 21.02.2024

            IF stock <= 0 AND tran_st EQ 0.
              EXIT.
            ENDIF.
            CLEAR: qty, stk, allocation.
          ENDLOOP.

        ENDIF.

        IF stock IS INITIAL AND NOT tran_st IS INITIAL .
          LOOP AT  it_final INTO DATA(wa_final_temp2) WHERE  custdeldate LE wa_final-custdeldate AND matnr = wa_mara-matnr.. " SO_SRT LE STOCK AND"AND ALLOC LT STOCK.

            IF wa_final_temp2-so_srt <> 0.
              IF stock > wa_final_temp2-so_srt.
                wa_final_temp2-alloc = wa_final_temp2-alloc + wa_final_temp2-so_srt.
**                STOCK = STOCK - WA_FINAL_TEMP2-SO_SRT.
              ELSE.
                wa_final_temp2-alloc = wa_final_temp2-alloc + stock.
**                STOCK = MB52 - STOCK.
              ENDIF.
              wa_final_temp2-so_srt = wa_final_temp2-pnd_so - wa_final_temp2-alloc.
**              MB52 = STOCK.

              IF stock = 0 AND wa_final_temp2-pnd_so NE wa_final_temp2-alloc.
                IF stock = 0 AND tran_st NE 0.
                  IF wa_final_temp2-so_srt LE tran_st.

                    DATA(tran_st3nn) = tran_st.
                    DATA(lv_srt) = wa_final_temp2-so_srt.
                    wa_final_temp2-alloc = wa_final_temp2-alloc + wa_final_temp2-so_srt .
                    tran_st = tran_st - wa_final_temp2-so_srt.
                    wa_final_temp2-so_srt = wa_final_temp2-pnd_so - wa_final_temp2-alloc.
**                  TRAN_ST = TRAN_ST - WA_FINAL_TEMP2-SO_SRT.

                    qty = tran_st3nn - tran_st.

                    CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                    CONDENSE t.
                    CONCATENATE wa_final_temp2-ind t INTO wa_final_temp2-ind SEPARATED BY ','.

                  ELSE.
                    CLEAR: tran_st3nn,lv_srt,allc.
                    tran_st3nn = tran_st.
                    allc = wa_final_temp2-alloc.
                    lv_srt = wa_final_temp2-so_srt.
                    wa_final_temp2-alloc = wa_final_temp2-alloc + wa_final_temp2-so_srt .
***                    TRAN_ST = TRAN_ST - WA_FINAL_TEMP2-SO_SRT.
**                    WA_FINAL_TEMP2-SO_SRT = WA_FINAL_TEMP2-PND_SO - WA_FINAL_TEMP2-ALLOC.
                    wa_final_temp2-so_srt = wa_final_temp2-pnd_so - allc - tran_st.
**                  TRAN_ST = TRAN_ST - WA_FINAL_TEMP2-SO_SRT.

                    CLEAR tran_st.
                    qty = tran_st3nn - tran_st.
                    IF tran_st IS INITIAL.
                      CLEAR qty.
                      qty = tran_st3nn.
                    ENDIF.
                    CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                    CONDENSE t.
                    CONCATENATE wa_final_temp2-ind t INTO wa_final_temp2-ind SEPARATED BY ','.

                  ENDIF.
                  IF t IS INITIAL.
                    REPLACE ',' WITH ' ' INTO wa_final_temp2-ind.
                  ENDIF.
                  REPLACE '.000' WITH ' ' INTO wa_final_temp2-ind.
                ENDIF.
              ENDIF.
              MODIFY it_final FROM wa_final_temp2 TRANSPORTING alloc so_srt ind  WHERE vbeln = wa_final_temp2-vbeln AND matnr = wa_mara-matnr.
              CLEAR : wa_final_temp2,tran_st3n,tran_st3nn,lv_srt..

            ENDIF.

            IF stock <= 0 AND tran_st EQ 0.
              EXIT.
            ENDIF.
            CLEAR: qty.
          ENDLOOP.

        ENDIF.

***        BREAK primus.
        stk = stock.
        IF mb52 <= 0 .
          wa_final-alloc = 0.
          wa_final-so_srt = wa_final-pnd_so.
        ELSEIF stock LE wa_vbap-kwmeng .
          wa_final-alloc = stock .
          wa_final-so_srt = wa_final-pnd_so - wa_final-alloc."WA_VBAP-KWMENG - WA_FINAL-ALLOC.
          stock = stock -  wa_final-alloc.
        ELSEIF stock GE wa_vbap-kwmeng .
          wa_final-alloc = wa_final-pnd_so.
          wa_final-so_srt = wa_final-pnd_so - wa_final-alloc."WA_VBAP-KWMENG - WA_FINAL-ALLOC.
          stock = stock -  wa_final-alloc.
        ENDIF.

        IF NOT stk IS INITIAL.
          CLEAR: wa_final_temp1-ind,s,tot_alloc_stk.
**          tot_alloc_stk = allocation + stk - mb52.
          tot_alloc_stk = stk - stock.
          CONDENSE tot_alloc_stk.
          CONCATENATE 'S' tot_alloc_stk INTO wa_final-ind SEPARATED BY '-'.
**          CONCATENATE 'S' tot_alloc_stk INTO s SEPARATED BY '-'.
        ENDIF.

        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""close on 06.02.2024
***        QTY = WA_FINAL-ALLOC.
***        CONCATENATE 'S' QTY INTO S SEPARATED BY '-'.
***        CONDENSE S.

*************************************Added on 21.02.2024 by Shubhangi Sarode
********* If stock is zero then allocate transit stock.
        IF stock = 0 AND wa_final-pnd_so NE wa_final-alloc.
          IF stock = 0 AND tran_st NE 0.
            IF wa_final-so_srt LE tran_st.
              DATA(tran_st5) = tran_st.
**          STOCK = TRAN_ST.    ""commented by pavan bcoz stock already clear when came here
              wa_final-alloc = wa_final-alloc + wa_final-so_srt .
              tran_st = tran_st - wa_final-so_srt.
              wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.
***          TRAN_ST = TRAN_ST - WA_FINAL-SO_SRT.

**          QTY = WA_FINAL-ALLOC.
              qty = tran_st5 - tran_st.
              CONCATENATE 'T' qty INTO t SEPARATED BY '-'.
              CONDENSE t.
              DATA(t2) = t.
            ELSE.
              CLEAR t2.
              DATA(tran_st5n) = tran_st.
**          STOCK = TRAN_ST.    ""commented by pavan bcoz stock already clear when came here
**              wa_final-alloc = wa_final-alloc + wa_final-so_srt .
              wa_final-alloc = wa_final-alloc + tran_st5n.

              wa_final-so_srt = wa_final-so_srt - tran_st5n.

              CLEAR tran_st.

**          QTY = WA_FINAL-ALLOC.
              qty = tran_st5n - tran_st.
              CONCATENATE 'T' qty INTO t SEPARATED BY '-'.
              CONDENSE t.
              t2 = t.

            ENDIF.
          ENDIF.

        ENDIF.


***************************************End on dt 21.02.2024

        CLEAR :alloc,qty_al.
        CLEAR:s,t.              "" commented by pavan for testing purpose
        alloc = wa_final-alloc.
        IF wa_final-alloc IS NOT INITIAL.
          IF mb52 GE alloc.
            CLEAR:qty.
            qty = alloc.
            qty_al = alloc.
***            CONCATENATE 'S' QTY INTO S SEPARATED BY '-'.
***            CONDENSE S.
            alloc =  mb52 - alloc.
*    IF alloc > 0.
            mb52 = mb52 - qty_al.
*    ENDIF.

          ELSEIF mb52 > 0.
            CLEAR:qty.
            qty_al = alloc.
            alloc = alloc - mb52.
            qty = mb52.
***            CONCATENATE 'S' QTY INTO S SEPARATED BY '-'.
***            CONDENSE S.
            mb52 = mb52 - qty_al.
          ENDIF.


          IF alloc > 0.

            IF tran_st GE alloc.
              CLEAR:qty.
              qty = alloc.
              qty_al = alloc.
**              CONCATENATE  'T' QTY INTO T SEPARATED BY '-'.
**              CONDENSE T.
              alloc = alloc - tran_st .
**              TRAN_ST = TRAN_ST - QTY_AL.
            ELSEIF tran_st > 0 .
              CLEAR:qty.

              qty = tran_st.
              qty_al = alloc.
              alloc = alloc - tran_st .
**              CONCATENATE  'T' QTY INTO T SEPARATED BY '-'.
**              CONDENSE T.
**
**              TRAN_ST = TRAN_ST - QTY_AL.

            ENDIF.
          ENDIF.
        ENDIF.

**        CONCATENATE s t INTO wa_final-ind SEPARATED BY ','.

        IF NOT t2 IS INITIAL.
          CONCATENATE wa_final-ind t2 INTO wa_final-ind SEPARATED BY ','.
          REPLACE ',' WITH ' ' INTO wa_final-ind.
          REPLACE '.000' WITH ' ' INTO wa_final-ind.
        ENDIF.

        IF s IS INITIAL.
          REPLACE ',' WITH ' ' INTO wa_final-ind.
        ENDIF.


        IF t IS INITIAL.
          REPLACE ',' WITH ' ' INTO wa_final-ind.
        ENDIF.

        REPLACE '.000' WITH ' ' INTO wa_final-ind.
        REPLACE '.000' WITH ' ' INTO wa_final-ind.

        READ TABLE lt_mara INTO ls_mara WITH KEY matnr = wa_vbak-matnr.
        IF sy-subrc = 0.
          wa_final-zseries    =  ls_mara-zseries.
          wa_final-zsize      =  ls_mara-zsize  .
          wa_final-brand      =  ls_mara-brand  .
          wa_final-moc        =  ls_mara-moc    .
          wa_final-type       =  ls_mara-type   .
        ENDIF.

        READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_vbak-vbeln.
        IF sy-subrc = 0.
          wa_final-bstkd  =  wa_vbkd-bstkd .
          wa_final-bstdk  =  wa_vbkd-bstdk .
        ENDIF.
*        SELECT SINGLE maktx INTO wa_final-maktx FROM makt WHERE matnr = wa_vbak-matnr.
        SELECT SINGLE wrkst INTO wa_final-wrkst FROM mara WHERE matnr = wa_vbak-matnr.

        IF NOT tran_st IS INITIAL.
          wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.  """""""""""""""""""""added by shubhangi sarode on dt 06.02.2024 for shorfall calculation after delivery.
        ENDIF.
        APPEND wa_final TO it_final.
        CLEAR: wa_final,wa_mska,t2,tran_st3,tran_st5.
      ENDLOOP.
****************************************************************** on dt 01.02.2024 if stock is availble , then assign stock to thatremaining material till stock zero

***      BREAK primus.
      IF stock IS NOT INITIAL AND stock GE 0.
        DATA:  lv_alloc_temp TYPE mard-labst.

        IF it_final IS NOT INITIAL.
          LOOP AT it_final INTO wa_final WHERE matnr = wa_mara-matnr AND so_srt IS NOT INITIAL ."and KWMENG le stock.
            allocation = wa_final-alloc.
            stk        = stock.
            IF stock < wa_final-kwmeng.

              IF wa_final-so_srt > stock.
                wa_final-alloc =  wa_final-alloc + stock ."LV_ALLOC_TEMP .     "old code
                wa_final-so_srt =   wa_final-so_srt - stock ."WA_FINAL-ALLOC .
                " WA_FINAL-SO_SRT = STOCK - WA_FINAL-KWMENG.
                stock = mb52 - stock.
                mb52 =  stock.
              ELSE.
                wa_final-alloc =  wa_final-alloc + wa_final-so_srt .          "new code on dt 08.02.2024
                stock = stock - wa_final-so_srt.
                wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.
                mb52 = stock.
              ENDIF.
            ELSE.

              lv_alloc_temp = wa_final-alloc + wa_final-so_srt .
              wa_final-alloc = lv_alloc_temp.
              " WA_FINAL_TEMP-ALLOC = WA_FINAL_TEMP-ALLOC + STOCK .
              stock = stock - wa_final-so_srt.
              wa_final-so_srt = wa_final-pnd_so - wa_final-alloc."WA_FINAL-KWMENG - WA_FINAL-ALLOC.
              mb52 = stock.
            ENDIF.




            """""""""""""""""""""""""""""""""""" ss """""""""""""""""""
            IF NOT stk IS INITIAL.
              CLEAR  wa_final-ind.
***              tot_alloc_stk = allocation + stk - mb52.
              tot_alloc_stk = allocation + stk - stock.
              CONDENSE tot_alloc_stk.
              CONCATENATE 'S' tot_alloc_stk INTO wa_final-ind SEPARATED BY '-'.
**                CONCATENATE 'S' tot_alloc_stk2 INTO wa_final_temp1-ind SEPARATED BY '-'.
            ENDIF.

            """""""""""""""""""""""""""""""""""" ss """""""""""""""""""


***            BREAK PRIMUS.
            """""""""""""""" added by pavan bcoz transit T value should be populate """"""""""""""
            IF stock = 0 AND wa_final-pnd_so NE wa_final-alloc.
              IF stock = 0 AND tran_st NE 0.                  "" added by pavan on 22.02.2024
                CLEAR lv_alloc_temp.
**              STOCK = TRAN_ST.
**              QTY = TRAN_ST.
**              CONCATENATE  'T' QTY INTO T SEPARATED BY '-'.
**              CONDENSE T.
                IF wa_final-so_srt < tran_st.
                  DATA(tran_st2) = tran_st.

                  wa_final-alloc = wa_final-alloc + wa_final-so_srt.
                  tran_st = tran_st - wa_final-so_srt.
                  wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.

                  qty = tran_st2 - tran_st.
                  CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                  CONDENSE t.
                  CONCATENATE wa_final-ind t INTO wa_final-ind SEPARATED BY ','.

**                  DATA(MB53) = QTY.
                  DATA(mb53) = tran_st.
                ELSE.
*                  BREAK primusabap.
                  tran_st2 = tran_st.
                  DATA(lv_so_srt) = wa_final-so_srt.
                  wa_final-alloc = wa_final-alloc + tran_st.
                  wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.
**              TRAN_ST = TRAN_ST - WA_FINAL-SO_SRT.
***                  TRAN_ST = STOCK - TRAN_ST.

                  qty = tran_st2 - tran_st.
**                  QTY = TRAN_ST.
                  IF NOT mb53 IS INITIAL.
                    tran_st = mb53 - tran_st.
                  ENDIF.
                  IF lv_so_srt GE tran_st.
                    CLEAR tran_st.
                  ENDIF.
                  IF tran_st IS INITIAL.
                    qty = tran_st2.
                  ENDIF.


                  CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                  CONDENSE t.
                  CONCATENATE wa_final-ind t INTO wa_final-ind SEPARATED BY ','.
                ENDIF.
                """""""""""""""" added by pavan bcoz transit T value should be populate """"""""""""""

*              STOCK = TRAN_ST.

**              LV_ALLOC_TEMP = WA_FINAL-ALLOC + WA_FINAL-SO_SRT .
**              WA_FINAL-ALLOC = LV_ALLOC_TEMP.

**              S = WA_FINAL-IND.
****              CONCATENATE WA_FINAL-IND T INTO WA_FINAL-IND SEPARATED BY ','.

**              IF T IS INITIAL.
                REPLACE ',' WITH ' ' INTO wa_final-ind.
**              ENDIF.

                REPLACE '.000' WITH ' ' INTO wa_final-ind.
                REPLACE '.000' WITH ' ' INTO wa_final-ind.

              ENDIF.
            ENDIF.

            MODIFY it_final FROM wa_final TRANSPORTING alloc so_srt ind WHERE vbeln = wa_final-vbeln AND matnr = wa_mara-matnr.
            IF stock = 0 AND tran_st = 0.
              EXIT.
            ENDIF.

            CLEAR : wa_final,tran_st2,allocation,stk.
          ENDLOOP.

        ENDIF.

**      ENDIF.
      ELSEIF stock = 0 AND tran_st <> 0.
        IF it_final IS NOT INITIAL.
          LOOP AT it_final INTO wa_final WHERE matnr = wa_mara-matnr AND so_srt IS NOT INITIAL ."and KWMENG le stock.

            IF stock < wa_final-kwmeng.

              IF wa_final-so_srt > stock.
                wa_final-alloc =  wa_final-alloc + stock ."LV_ALLOC_TEMP .     "old code
                wa_final-so_srt =   wa_final-so_srt - stock ."WA_FINAL-ALLOC .
                " WA_FINAL-SO_SRT = STOCK - WA_FINAL-KWMENG.
**                STOCK = MB52 - STOCK.
**                MB52 =  STOCK.
              ELSE.
                wa_final-alloc =  wa_final-alloc + wa_final-so_srt .          "new code on dt 08.02.2024
                stock = stock - wa_final-so_srt.
                wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.
**                MB52 = STOCK.
              ENDIF.
            ELSE.

              lv_alloc_temp = wa_final-alloc + wa_final-so_srt .
              wa_final-alloc = lv_alloc_temp.
              " WA_FINAL_TEMP-ALLOC = WA_FINAL_TEMP-ALLOC + STOCK .
              stock = stock - wa_final-so_srt.
              wa_final-so_srt = wa_final-pnd_so - wa_final-alloc."WA_FINAL-KWMENG - WA_FINAL-ALLOC.
**              MB52 = STOCK.
            ENDIF.



***            BREAK PRIMUS.
            """""""""""""""" added by pavan bcoz transit T value should be populate """"""""""""""
            IF stock = 0 AND wa_final-pnd_so NE wa_final-alloc.
              IF stock = 0 AND tran_st NE 0.                  "" added by pavan on 22.02.2024
                CLEAR lv_alloc_temp.
**              STOCK = TRAN_ST.
**              QTY = TRAN_ST.
**              CONCATENATE  'T' QTY INTO T SEPARATED BY '-'.
**              CONDENSE T.
                IF wa_final-so_srt < tran_st.
                  DATA(tran_st4) = tran_st.

                  wa_final-alloc = wa_final-alloc + wa_final-so_srt.
                  tran_st = tran_st - wa_final-so_srt.
                  wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.

                  qty = tran_st4 - tran_st.
                  CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                  CONDENSE t.
                  CONCATENATE wa_final-ind t INTO wa_final-ind SEPARATED BY ','.

**                  DATA(MB53) = QTY.
                  DATA(mb54) = tran_st.
                ELSE.
                  DATA(lv_so_srt1) = wa_final-so_srt.
                  DATA(tran_st6) = tran_st.
                  wa_final-alloc = wa_final-alloc + tran_st.
                  wa_final-so_srt = wa_final-pnd_so - wa_final-alloc.
**              TRAN_ST = TRAN_ST - WA_FINAL-SO_SRT.
***                  TRAN_ST = STOCK - TRAN_ST.

                  qty = tran_st.
                  IF NOT mb53 IS INITIAL.
                    tran_st = mb53 - tran_st.
                  ENDIF.
                  IF lv_so_srt1 GE tran_st.
                    CLEAR tran_st.
                  ENDIF.
                  IF tran_st IS INITIAL.
                    qty = tran_st6.
                  ENDIF.

                  CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
                  CONDENSE t.
                  CONCATENATE wa_final-ind t INTO wa_final-ind SEPARATED BY ','.
                ENDIF.
                """""""""""""""" added by pavan bcoz transit T value should be populate """"""""""""""

*              STOCK = TRAN_ST.

**              LV_ALLOC_TEMP = WA_FINAL-ALLOC + WA_FINAL-SO_SRT .
**              WA_FINAL-ALLOC = LV_ALLOC_TEMP.

**              S = WA_FINAL-IND.
****              CONCATENATE WA_FINAL-IND T INTO WA_FINAL-IND SEPARATED BY ','.

**              IF T IS INITIAL.
                REPLACE ',' WITH ' ' INTO wa_final-ind.
**              ENDIF.

                REPLACE '.000' WITH ' ' INTO wa_final-ind.
                REPLACE '.000' WITH ' ' INTO wa_final-ind.

              ENDIF.
            ENDIF.

            MODIFY it_final FROM wa_final TRANSPORTING alloc so_srt ind WHERE vbeln = wa_final-vbeln AND matnr = wa_mara-matnr.
            IF stock = 0 AND tran_st = 0.
              EXIT.
            ENDIF.

            CLEAR : wa_final,tran_st4,tran_st6.
          ENDLOOP.

        ENDIF.
      ENDIF.


******************************************************************** end on dt 01.02.2024
    ENDON.

    CLEAR : wa_mara,lv_stock.
  ENDLOOP.
*  SORT it_final BY vbeln posnr.
  """""""""""""""""""""""""""""""""""""""""""""""""Added by Pranit 05.04.2024
  DELETE IT_FINAL WHERE MATNR EQ SPACE.
  DELETE IT_FINAL WHERE POSNR EQ SPACE.
""""""""""""""""""""""""""""""""""""""""""""""""""""


  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
      wa_down-kunnr   = wa_final-kunnr  .
      wa_down-bstkd   = wa_final-bstkd  .

      IF wa_final-bstdk IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-bstdk
          IMPORTING
            output = wa_down-bstdk.

        CONCATENATE wa_down-bstdk+0(2) wa_down-bstdk+2(3) wa_down-bstdk+5(4)
                        INTO wa_down-bstdk SEPARATED BY '-'.

      ENDIF.

      wa_down-vbeln   = wa_final-vbeln  .
      wa_down-posnr   = wa_final-posnr  .
*    WA_DOWN-AUDAT   = WA_FINAL-AUDAT  .

      IF wa_final-audat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-audat
          IMPORTING
            output = wa_down-audat.

        CONCATENATE wa_down-audat+0(2) wa_down-audat+2(3) wa_down-audat+5(4)
                        INTO wa_down-audat SEPARATED BY '-'.

      ENDIF.


      wa_down-matnr   = wa_final-matnr  .

      wa_down-name1   = wa_final-name1  .                 "ADDED BY MA ON 08.03.2024

      wa_down-wrkst   = wa_final-wrkst  .
*      wa_down-maktx   = wa_final-maktx  .
*========================================================================================      ADDDED BY MA ON 08.03.2024
      wa_down-lv_longtxt =   wa_final-lv_longtxt.
*========================================================================================

      wa_down-ind     = wa_final-ind  .
      wa_down-zseries   = wa_final-zseries  .
      wa_down-zsize     = wa_final-zsize    .
      wa_down-brand     = wa_final-brand    .
      wa_down-moc       = wa_final-moc      .
      wa_down-type      = wa_final-type     .
*    WA_DOWN-DELDATE = WA_FINAL-DELDATE.

      IF wa_final-custdeldate IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-custdeldate
          IMPORTING
            output = wa_down-custdeldate.

        CONCATENATE wa_down-custdeldate+0(2) wa_down-custdeldate+2(3) wa_down-custdeldate+5(4)
                        INTO wa_down-custdeldate SEPARATED BY '-'.

      ENDIF.

      wa_down-kwmeng  = abs( wa_final-kwmeng ) .
      wa_down-so_srt  = abs( wa_final-so_srt ).
      wa_down-pnd_so  = abs( wa_final-pnd_so ).
      wa_down-alloc   = abs( wa_final-alloc ).

      IF wa_final-kwmeng < 0.
        CONDENSE wa_down-kwmeng.
        CONCATENATE '-' wa_down-kwmeng INTO wa_down-kwmeng.
      ENDIF.

      IF wa_final-alloc < 0.
        CONDENSE wa_down-alloc.
        CONCATENATE '-' wa_down-alloc INTO wa_down-alloc.
      ENDIF.


      IF wa_final-so_srt < 0.
        CONDENSE wa_down-so_srt.
        CONCATENATE '-' wa_down-so_srt INTO wa_down-so_srt.
      ENDIF.

      IF wa_final-pnd_so < 0.
        CONDENSE wa_down-pnd_so.
        CONCATENATE '-' wa_down-pnd_so INTO wa_down-pnd_so.
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
  PERFORM fcat USING : '1'   'KUNNR'           'IT_FINAL'      'Customer'                 '15',
                       '2'   'NAME1'           'IT_FINAL'      'Customer Name'                 '15',             ""ADDED BY MA ON 08.03.2024.
                       '3'   'BSTKD'           'IT_FINAL'      'Customer Po'                      '15' ,
                       '4'   'BSTDK'           'IT_FINAL'      'Cust.Po.Dt'                      '15' ,
                       '5'   'VBELN'           'IT_FINAL'      'Sales Order'                      '15' ,
                       '6'   'POSNR'           'IT_FINAL'      'SO Line Item'                      '15' ,
                       '7'   'AUDAT'           'IT_FINAL'      'SO Date'                      '15' ,
                       '8'   'MATNR'           'IT_FINAL'      'Material'                      '20' ,
                       '9'   'WRKST'           'IT_FINAL'      'Old Material Code'                      '15' ,
                       '10'   'lv_longtxt'           'IT_FINAL'      'Material Desc'                      '15' ,
                      '11'   'CUSTDELDATE'     'IT_FINAL'      'CDD'                      '15' ,
                      '12'   'KWMENG'          'IT_FINAL'      'SO Quantity'                      '15' ,
                      '13'   'PND_SO'          'IT_FINAL'      'Pend So Qty'                      '15' ,
                      '14'   'ALLOC'           'IT_FINAL'      'Allocation'                      '15' ,
                      '15'   'SO_SRT'          'IT_FINAL'      'Shortfall Quantity'                      '15' ,
                      '16'   'IND'             'IT_FINAL'      'Allocation Detail'                      '15' ,
                      '17'   'ZSERIES'         'IT_FINAL'      'Series '                      '15' ,
                      '18'   'ZSIZE'           'IT_FINAL'      'Size'                      '15' ,
                      '19'   'BRAND'           'IT_FINAL'      'BRAND'                      '15' ,
                      '20'   'MOC'             'IT_FINAL'      'MOC'                      '15' ,
                      '21'   'TYPE'            'IT_FINAL'      'TYPE'                      '15' .


*                    '14'   'TRAN_QTY'        'IT_FINAL'      'Transir Qty'                      '15' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0380   text
*      -->P_0381   text
*      -->P_0382   text
*      -->P_0383   text
*      -->P_0384   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                 VALUE(p2)
                 VALUE(p3)
                 VALUE(p4)
                 VALUE(p5).
*                 VALUE(p6).

  ls_fcat-col_pos       = p1.
  ls_fcat-fieldname     = p2.
  ls_fcat-tabname       = p3.
  ls_fcat-seltext_l     = p4.
  ls_fcat-outputlen     = p5.
*  ls_fcat-ref_fieldname = p6.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.
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
      it_fieldcat        = lt_fcat
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
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
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


  lv_file = 'ZUS_SHORTFALL_TRANSIT_NEW.TXT'.


  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_SHORTFALL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
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


  lv_file = 'ZUS_SHORTFALL_TRANSIT_NEW.TXT'.


  CONCATENATE p_folder '\' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_SHORTFALL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
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
FORM cvs_header  USING    pd_csv.         "p_hd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Customer'
              'Customer Name'
              'Customer Po'
              'Cust.Po.Dt'
              'Sales Order'
              'SO Line Item'
              'SO Date'
              'Material'
              'USA Code'
              'Material Desc'
              'CDD'
              'SO Quantity'
              'Pend So Qty'
              'Allocation'
              'Shortfall Quantity'
              'Allocation Detail'
              'Series '
              'Size'
              'BRAND'
              'MOC'
              'TYPE'
              'Refreshable Date'
              'Refreshable Time'
              INTO pd_csv
               SEPARATED BY l_field_seperator.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TRANSIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_transit .

  SELECT vbeln
         fkart
         fkdat
         knumv
         rfbsk
         kunag
         exnum
         xblnr
         logsys
         fksto FROM vbrk INTO TABLE it_vbrk
         WHERE "vbeln IN inv
           "AND fkdat IN date
**            KUNAG = '0000300159'    "'0000300315'
            kunag = '0000300000'
*            kunag = '300000'
           AND fksto NE 'X'
           AND fkart NE 'US1'  AND fkart NE 'US2'
           AND logsys NE ' '.


  IF it_vbrk IS NOT INITIAL.
    SELECT vbeln
           posnr
           fkimg
           vgbel
           vgpos
           aubel
           aupos
           matnr
           werks FROM vbrp INTO TABLE it_vbrp
           FOR ALL ENTRIES IN it_vbrk
           WHERE vbeln = it_vbrk-vbeln.


    SELECT knumv
           kposn
           kschl
           kbetr
           kwert FROM PRCD_ELEMENTS INTO TABLE it_konv
           FOR ALL ENTRIES IN it_vbrk
           WHERE knumv = it_vbrk-knumv
             AND kschl = 'ZPR0'.


    SELECT exnum
           iever FROM eikp INTO TABLE it_eikp
           FOR ALL ENTRIES IN it_vbrk
           WHERE exnum = it_vbrk-exnum.


*SELECT kunnr
*       land1
*       ort01
*       pstlz FROM kna1 INTO TABLE it_kna1
*       FOR ALL ENTRIES IN it_vbrk
*       WHERE kunnr = it_vbrk-kunag.

  ENDIF.


  IF it_eikp IS NOT INITIAL.

    SELECT spras
           land1
           expvz
           bezei FROM t618t INTO TABLE it_t618t
           FOR ALL ENTRIES IN it_eikp
           WHERE expvz = it_eikp-iever
            AND  spras = 'EN'
            AND  land1 = 'IN'.


    SELECT expvz
           bezei
           zdays FROM ztransit INTO TABLE it_mode
           FOR ALL ENTRIES IN it_eikp
           WHERE expvz = it_eikp-iever.

  ENDIF.

  IF it_vbrp IS NOT INITIAL.

    SELECT matnr
           vkorg
           bstnk
           vbeln
           posnr
           werks FROM vapma INTO TABLE it_vapma
           FOR ALL ENTRIES IN it_vbrp
           WHERE vbeln = it_vbrp-aubel
             AND posnr = it_vbrp-aupos.

*  SELECT vbeln
*         verur FROM likp INTO TABLE it_likp
*         FOR ALL ENTRIES IN it_vbrp
*         WHERE VERUR = it_vbrp-VGBEL.




    SELECT mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im FROM mseg INTO TABLE it_mseg
           FOR ALL ENTRIES IN it_vbrp
           WHERE xblnr_mkpf = it_vbrp-vgbel
*         AND VBELP_IM = it_vbrp-posnr
             AND bwart = '103'.
*             AND bwart = '101'.


    SELECT mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im FROM mseg INTO TABLE it_rev
           FOR ALL ENTRIES IN it_vbrp
           WHERE xblnr_mkpf = it_vbrp-vgbel
*       AND VBELP_IM = it_vbrp-posnr
           AND bwart = '105' .
*           AND bwart = '101' .







  ENDIF.
  IF it_vapma IS NOT INITIAL.
    SELECT vbeln
           posnr
           matnr
           kwmeng
           posex FROM vbap INTO TABLE lt_vbap
           FOR ALL ENTRIES IN it_vapma
           WHERE vbeln = it_vapma-vbeln
             AND posnr = it_vapma-posnr.


    SELECT ebeln
           ebelp
           werks
           menge
           matnr FROM ekpo INTO TABLE it_ekpo
           FOR ALL ENTRIES IN it_vapma
           WHERE ebeln = it_vapma-bstnk+0(10).



  ENDIF.

*IF it_kna1 IS NOT INITIAL.
*  SELECT spras
*         land1
*         landx FROM t005t INTO TABLE it_t005t
*         FOR ALL ENTRIES IN it_kna1
*         WHERE spras = 'EN'
*          AND  land1 = it_kna1-land1.
*
*
*ENDIF.

*IF it_ekpo IS NOT INITIAL.
*  SELECT matnr
*         wrkst
*         zseries
*         zsize
*         brand
*         moc
*         type   FROM mara INTO TABLE it_mara
*         FOR ALL ENTRIES IN it_ekpo
*         WHERE matnr = it_ekpo-matnr.
*
*ENDIF.

  IF it_mseg IS NOT INITIAL.
*  BREAK PRIMUSUSA.
    SELECT belnr
           blart
           xblnr
           stblg FROM bkpf INTO TABLE it_bkpf
           FOR ALL ENTRIES IN it_mseg
           WHERE xblnr = it_mseg-mblnr
             AND blart = 'TR'.



    SELECT mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im FROM mseg INTO TABLE it_mseg1
           FOR ALL ENTRIES IN it_mseg
           WHERE smbln = it_mseg-mblnr+0(10).


  ENDIF.

  IF it_bkpf IS NOT INITIAL.

    SELECT belnr
           blart
           xblnr
           stblg FROM bkpf INTO TABLE it_bkpf1
           FOR ALL ENTRIES IN it_bkpf
           WHERE stblg = it_bkpf-belnr.
*         AND blart = 'TR'.





  ENDIF.

  LOOP AT it_vbrp INTO wa_vbrp WHERE vgbel NE space.

    wa_transit-inv_no = wa_vbrp-vbeln.
    wa_transit-inv_line = wa_vbrp-posnr.
    wa_transit-fkimg = wa_vbrp-fkimg.

*SELECT SINGLE vbeln INTO wa_final-VBELN_IM FROM likp WHERE verur = wa_vbrp-vgbel.

    SELECT vbeln
           verur FROM likp INTO TABLE it_likp
           WHERE verur = wa_vbrp-vgbel.


    SORT it_likp DESCENDING BY vbeln.

    READ TABLE it_likp INTO wa_likp INDEX 1.
    IF sy-subrc = 0.

      wa_transit-vbeln_im = wa_likp-vbeln.

    ENDIF.

    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
    IF sy-subrc = 0.
      wa_transit-fkdat = wa_vbrk-fkdat.
      wa_transit-xblnr = wa_vbrk-xblnr.

    ENDIF.

    READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr.
    IF sy-subrc = 0.

      wa_transit-kbetr = wa_konv-kbetr.
      wa_transit-kwert = wa_konv-kwert.

    ENDIF.


    READ TABLE it_vapma INTO wa_vapma WITH KEY vbeln = wa_vbrp-aubel posnr = wa_vbrp-aupos.
    IF sy-subrc = 0.
      wa_transit-vbeln = wa_vapma-vbeln.
      wa_transit-posnr = wa_vapma-posnr.

    ENDIF.


    READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = wa_vapma-vbeln posnr = wa_vapma-posnr.
    IF sy-subrc = 0.
      wa_transit-kwmeng = ls_vbap-kwmeng.
    ENDIF.

    READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_vapma-bstnk  matnr = wa_vapma-matnr ebelp = ls_vbap-posex.
    IF sy-subrc = 0.
      wa_transit-ebeln = wa_ekpo-ebeln.
      wa_transit-ebelp = wa_ekpo-ebelp.
      wa_transit-matnr = wa_ekpo-matnr.
      wa_transit-menge = wa_ekpo-menge.
      wa_transit-werks = wa_ekpo-werks.

    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_ekpo-matnr.
    IF sy-subrc = 0.
      wa_transit-wrkst     = wa_mara-wrkst.
      wa_transit-zseries   = wa_mara-zseries.
      wa_transit-zsize     = wa_mara-zsize.
      wa_transit-brand     = wa_mara-brand.
      wa_transit-moc       = wa_mara-moc.
      wa_transit-type      = wa_mara-type   .

    ENDIF.





    READ TABLE it_eikp INTO wa_eikp WITH KEY exnum = wa_vbrk-exnum.
    IF sy-subrc = 0.

    ENDIF.
    READ TABLE it_t618t INTO wa_t618t WITH KEY expvz = wa_eikp-iever.
    IF sy-subrc = 0.
      wa_transit-bezei = wa_t618t-bezei.

    ENDIF.

*READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbrk-kunag.
*IF sy-subrc = 0.
*  READ TABLE it_t005t INTO wa_t005t WITH KEY spras = 'EN' land1 = wa_kna1-land1.
*  IF sy-subrc = 0.
*    CONCATENATE wa_kna1-ort01 wa_kna1-pstlz wa_t005t-landx INTO wa_transit-place SEPARATED BY ','.
*
*  ENDIF.
*
*ENDIF.

*    READ TABLE it_mode INTO wa_mode WITH KEY expvz = wa_eikp-iever.
*    IF sy-subrc = 0.
*      day = wa_mode-zdays.
*      CALL FUNCTION 'BKK_ADD_WORKINGDAY'
*        EXPORTING
*          i_date = wa_transit-fkdat
*          i_days = day
**         I_CALENDAR1       =
**         I_CALENDAR2       =
*        IMPORTING
*          e_date = wa_transit-arrival
**         E_RETURN          =
*        .
*
*    ENDIF.
*

*
*READ TABLE it_likp INTO wa_likp WITH KEY VERUR = wa_vbrp-VGBEL.
*IF sy-subrc = 0.
*wa_final-VBELN_IM = wa_likp-VBELN.
*ENDIF.

    READ TABLE it_mseg INTO wa_mseg WITH KEY xblnr_mkpf = wa_vbrp-vgbel." VBELP_IM = wa_vbrp-posnr.
    IF sy-subrc = 0.

      READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY smbln = wa_mseg-mblnr.
      IF sy-subrc = 4.
        wa_transit-mblnr = wa_mseg-mblnr.
      ENDIF.


    ENDIF.
*BREAK PRIMUSUSA.
    LOOP AT it_bkpf INTO wa_bkpf WHERE xblnr = wa_mseg-mblnr.
*IF sy-subrc = 0.
      READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
      IF sy-subrc = 4.
        wa_transit-belnr = wa_bkpf-belnr.
      ENDIF.

*ENDIF.
    ENDLOOP.

    READ TABLE it_rev INTO wa_rev WITH KEY xblnr_mkpf = wa_vbrp-vgbel." VBELP_IM = wa_vbrp-posnr.
    IF sy-subrc = 4.
      APPEND wa_transit TO it_transit.
    ENDIF.


    CLEAR:wa_transit,wa_mseg,wa_rev,wa_bkpf,wa_mseg1,wa_vbrp,wa_eikp,wa_mode,wa_kna1,wa_t005t,wa_vbrk,wa_t618t,wa_mara,wa_ekpo,
          ls_vbap,wa_vapma,wa_konv,wa_mseg1,wa_rev.
    DELETE it_transit WHERE ebeln  = ' '.
    " DELETE IT_TRANSIT WHERE VBELN_IM  = ' '.  "FOR TESTING PURPOSE ON DT 19.02.2024
  ENDLOOP.

  SELECT matnr
         werks FROM marc INTO TABLE it_marc
         FOR ALL ENTRIES IN it_transit
         WHERE matnr = it_transit-matnr
           AND werks = it_transit-werks.

  LOOP AT it_marc INTO wa_marc.
    wa_trans-matnr = wa_marc-matnr.

    LOOP AT it_transit INTO wa_transit WHERE matnr = wa_marc-matnr.

      wa_trans-fkimg = wa_trans-fkimg + wa_transit-fkimg.

    ENDLOOP.

    APPEND wa_trans TO it_trans.
    CLEAR wa_trans.
  ENDLOOP.


ENDFORM.
