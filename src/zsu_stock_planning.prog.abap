*&---------------------------------------------------------------------*
*& Report ZUS_STOCK_PLANNING                                           *
* 1.PROGRAM OWNER       : PRIMUS TECHSYSTEMS PVT LTD.
* 2.PROJECT                 : STOCK PLANNING REPORT DEVLOPMENT
* 3.PROGRAM NAME            : Zsu_STOCK_PLANNING
* 4.TRANS CODE              : zsu_stock
* 5.MODULE NAME             : SD.
* 6.REQUEST NO              :
* 7.CREATION DATE           : 14 .12.2018.
* 8.CREATED BY              : Shreya Sankpal.
* 9.FUNCTIONAL CONSULTANT   :
* 10.BUSINESS OWNER         : DELVAL Saudi PLANT.
*&---------------------------------------------------------------------*
REPORT zsu_stock_planning.

TABLES : mara,mard,mseg,ekpo,eket,vbbe,msku.

TYPES : BEGIN OF ty_mara,
          matnr   TYPE mara-matnr,
          zseries TYPE mara-zseries,
          zsize   TYPE mara-zsize,
          brand   TYPE mara-brand,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
          wrkst   TYPE mara-wrkst,
*          bwart   TYPE mara-bwart,
        END OF ty_mara.

DATA : it_mara TYPE STANDARD TABLE OF ty_mara,
       wa_mara TYPE ty_mara.

TYPES : BEGIN OF ty_vbbe,
          matnr TYPE vbbe-matnr,
          werks TYPE vbbe-werks,
          omeng TYPE vbbe-omeng,
        END OF ty_vbbe.

DATA : it_vbbe TYPE STANDARD TABLE OF ty_vbbe,
       wa_vbbe TYPE ty_vbbe.

TYPES : BEGIN OF ty_mard,
          matnr TYPE mard-matnr,
          lgort TYPE mard-lgort,
          werks TYPE mard-werks,
          labst TYPE mard-labst,
        END OF ty_mard.

DATA : it_mard TYPE STANDARD TABLE OF ty_mard,
       wa_mard TYPE ty_mard.

TYPES : BEGIN OF ty_msku,
          matnr TYPE msku-matnr,
          werks TYPE msku-werks,
          charg TYPE msku-charg,
          sobkz TYPE msku-sobkz,
          kunnr TYPE msku-kunnr,
          kulab TYPE msku-kulab,
        END OF ty_msku.

DATA : it_msku TYPE STANDARD TABLE OF ty_msku,
       wa_msku TYPE ty_msku.

TYPES : BEGIN OF ty_mseg,
*          matnr      TYPE mseg-matnr,
*          mblnr(16),   "" TYPE mseg-mblnr,
*          bwart      TYPE mseg-bwart,
*          werks      TYPE mseg-werks,
*          smbln      TYPE mseg-smbln,
*          xblnr_mkpf TYPE mseg-xblnr_mkpf,
*          vbeln_im   TYPE mseg-vbeln_im,
*          vbelp_im   TYPE mseg-vbelp_im,
*          menge      TYPE mseg-menge,
          matnr      TYPE mseg-matnr,
          mblnr(16),   "" TYPE mseg-mblnr,
          bwart      TYPE mseg-bwart,
          werks      TYPE mseg-werks,
          smbln      TYPE mseg-smbln,
          xblnr_mkpf TYPE mseg-xblnr_mkpf,
          vbeln_im   TYPE mseg-vbeln_im,
          vbelp_im   TYPE mseg-vbelp_im,
          menge      TYPE mseg-menge,
        END OF ty_mseg.

DATA : it_mseg TYPE STANDARD TABLE OF ty_mseg,
       wa_mseg TYPE ty_mseg.

DATA: it_mseg1 TYPE TABLE OF ty_mseg,
      wa_mseg1 TYPE          ty_mseg.

TYPES : BEGIN OF ty_rev,
          mblnr   TYPE mseg-mblnr,
          zeile   TYPE mseg-zeile,
          line_id TYPE mseg-line_id,
          bwart   TYPE mseg-bwart,
          matnr   TYPE mseg-matnr,
          werks   TYPE mseg-werks,
          menge   TYPE mseg-menge,
          smbln   TYPE mseg-smbln,
        END OF ty_rev.

*DATA : it_rev TYPE STANDARD TABLE OF ty_rev,
*       wa_rev TYPE ty_rev.

DATA : it_rev TYPE STANDARD TABLE OF ty_mseg,
       wa_rev TYPE ty_mseg.

TYPES: BEGIN OF str_vbap,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         kwmeng TYPE vbap-kwmeng,
         posex  TYPE vbap-posex,
       END OF str_vbap.

DATA: lt_vbap TYPE TABLE OF str_vbap,
      ls_vbap TYPE          str_vbap.

DATA : it_rev1 TYPE STANDARD TABLE OF ty_rev,
       wa_rev1 TYPE ty_rev.

TYPES: BEGIN OF ty_ekpo02,
         ebeln TYPE vbak-bstnk, "ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         werks TYPE ekpo-werks,
         menge TYPE ekpo-menge,
         matnr TYPE ekpo-matnr,
       END OF ty_ekpo02.

TYPES: BEGIN OF ty_bkpf,
         belnr TYPE bkpf-belnr,
         blart TYPE bkpf-blart,
         xblnr TYPE bkpf-xblnr,
         stblg TYPE bkpf-stblg,
       END OF ty_bkpf.

DATA: it_ekpo02 TYPE TABLE OF ty_ekpo02,
      wa_ekpo02 TYPE          ty_ekpo02.

DATA: it_bkpf TYPE TABLE OF ty_bkpf,
      wa_bkpf TYPE          ty_bkpf.

DATA: it_bkpf1 TYPE TABLE OF ty_bkpf,
      wa_bkpf1 TYPE          ty_bkpf.

DATA : it_mseg_105 TYPE STANDARD TABLE OF ty_mseg,
       wa_mseg_105 TYPE ty_mseg.

DATA : it_mseg_101 TYPE STANDARD TABLE OF ty_mseg,
       wa_mseg_101 TYPE ty_mseg.

DATA : it_mseg_102 TYPE STANDARD TABLE OF ty_mseg,
       wa_mseg_102 TYPE ty_mseg.

TYPES: BEGIN OF ty_ekpo,
         matnr TYPE ekpo-matnr,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         menge TYPE ekpo-menge,
         loekz TYPE ekpo-loekz,
         elikz TYPE ekpo-elikz,
         werks TYPE ekpo-werks,
         retpo TYPE ekpo-retpo,
       END OF ty_ekpo.
*
*DATA : it_ekpo TYPE STANDARD TABLE OF ty_ekpo,
*       wa_ekpo TYPE ty_ekpo.
*
DATA : it_ekpo1 TYPE STANDARD TABLE OF ty_ekpo,
       wa_ekpo1 TYPE ty_ekpo.
TYPES : BEGIN OF ty_vbrp,
          vbeln     TYPE vbrp-vbeln,
          posnr     TYPE vbrp-posnr,
          matnr     TYPE vbrp-matnr,
          vgbel(16),
          vgpos     TYPE vbrp-vgpos,
          aubel     TYPE vbrp-aubel,
          aupos     TYPE vbrp-aupos,
          werks     TYPE vbrp-werks,
          fkimg     TYPE vbrp-fkimg,
        END OF ty_vbrp.

TYPES: BEGIN OF ty_konv,
         knumv TYPE prcd_elements-knumv,
         kposn TYPE prcd_elements-kposn,
         kschl TYPE prcd_elements-kschl,
         kbetr TYPE prcd_elements-kbetr,
         kwert TYPE prcd_elements-kwert,
       END OF ty_konv.

TYPES: BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         land1 TYPE kna1-land1,
         ort01 TYPE kna1-ort01,
         pstlz TYPE kna1-pstlz,
       END OF ty_kna1.

TYPES:BEGIN OF ty_eikp,
        exnum TYPE eikp-exnum,
        iever TYPE eikp-iever,
      END OF ty_eikp.

TYPES:BEGIN OF ty_t618t,
        spras TYPE t618t-spras,
        land1 TYPE t618t-land1,
        expvz TYPE t618t-expvz,
        bezei TYPE t618t-bezei,
      END OF ty_t618t.

TYPES: BEGIN OF ty_mode,
         expvz TYPE ztransit-expvz,
         bezei TYPE ztransit-bezei,
         zdays TYPE ztransit-zdays,
       END OF ty_mode.

TYPES : BEGIN OF ty_vapma,
          matnr TYPE vapma-matnr,
          vkorg TYPE vapma-vkorg,
          bstnk TYPE vapma-bstnk,
          vbeln TYPE vapma-vbeln,
          posnr TYPE vapma-posnr,
          werks TYPE vapma-werks,
        END OF ty_vapma.

DATA : it_vbrp TYPE STANDARD TABLE OF ty_vbrp,  "added by primus jyoti on 02.02.2024
       wa_vbrp TYPE ty_vbrp.

TYPES: BEGIN OF ty_likp,
         vbeln TYPE likp-vbeln,
         verur TYPE likp-verur,
       END OF ty_likp.

DATA: it_likp TYPE TABLE OF ty_likp,
      wa_likp TYPE          ty_likp.

TYPES: BEGIN OF str_final,
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
         kbetr    TYPE prcd_elements-kbetr,
         kwert    TYPE prcd_elements-kwert,
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
       END OF str_final.

TYPES: BEGIN OF ty_t005t,
         spras TYPE t005t-spras,
         land1 TYPE t005t-land1,
         landx TYPE t005t-landx,
       END OF ty_t005t,

       BEGIN OF ty_marc,
         matnr TYPE marc-matnr,
         werks TYPE marc-werks,
       END OF ty_marc,

       BEGIN OF ty_trans,
         matnr TYPE mara-matnr,
         fkimg TYPE vbrp-fkimg,
       END OF ty_trans..

DATA: it_transit TYPE TABLE OF str_final,
      wa_transit TYPE          str_final.

DATA: it_konv  TYPE TABLE OF ty_konv,
      wa_konv  TYPE          ty_konv,
      it_kna1  TYPE TABLE OF ty_kna1,
      wa_kna1  TYPE          ty_kna1,
      it_t005t TYPE TABLE OF ty_t005t,
      wa_t005t TYPE          ty_t005t,
      it_marc  TYPE TABLE OF ty_marc,
      wa_marc  TYPE          ty_marc,
      it_trans TYPE TABLE OF ty_trans,
      wa_trans TYPE          ty_trans,
      it_eikp  TYPE TABLE OF ty_eikp,
      wa_eikp  TYPE          ty_eikp,
      it_t618t TYPE TABLE OF ty_t618t,
      wa_t618t TYPE          ty_t618t,
      it_mode  TYPE TABLE OF ty_mode,
      wa_mode  TYPE          ty_mode,
      it_vapma TYPE TABLE OF ty_vapma,
      wa_vapma TYPE          ty_vapma.
*
*TYPES : BEGIN OF ty_eket,
*          ebeln TYPE ekpo-ebeln,
*          ebelp TYPE ekpo-ebelp,
*          wemng TYPE eket-wemng,
*        END OF ty_eket.
*
*DATA : it_eket TYPE STANDARD TABLE OF ty_eket,
*       wa_eket TYPE ty_eket.

TYPES : BEGIN OF ty_ekpo_eket,

          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          matnr TYPE ekpo-matnr,
          menge TYPE ekpo-menge,
          loekz TYPE ekpo-loekz,
          elikz TYPE ekpo-elikz,
          werks TYPE ekpo-werks,
          retpo TYPE ekpo-retpo,

*  ebeln TYPE ekpo-ebeln,
*  ebelp TYPE ekpo-ebelp,
          wemng TYPE eket-wemng,

        END OF ty_ekpo_eket.

DATA : it_ekpo_eket TYPE STANDARD TABLE OF ty_ekpo_eket,
       wa_ekpo_eket TYPE ty_ekpo_eket.

TYPES : BEGIN OF ty_vbap,
          vbeln  TYPE vbap-vbeln,
          posnr  TYPE vbap-posnr,
          matnr  TYPE vbap-matnr,
          werks  TYPE vbap-werks,
          kwmeng TYPE vbap-kwmeng,
        END OF ty_vbap.

DATA: it_vbap TYPE TABLE OF ty_vbap,
      wa_vbap TYPE          ty_vbap.

TYPES :BEGIN OF ty_vbup,
         vbeln TYPE vbup-vbeln,
         posnr TYPE vbup-posnr,
         lfgsa TYPE vbup-lfgsa,
       END OF ty_vbup.

DATA :it_vbup TYPE TABLE OF ty_vbup,
      wa_vbup TYPE          ty_vbup.

TYPES : BEGIN OF ty_lips,
          vbeln TYPE lips-vbeln,
          posnr TYPE lips-posnr,
          vgbel TYPE lips-vgbel,
          vgpos TYPE lips-vgpos,
          matnr TYPE lips-matnr,
          werks TYPE lips-werks,
          lfimg TYPE lips-lfimg,
        END OF ty_lips.

DATA: it_lips TYPE TABLE OF ty_lips,
      wa_lips TYPE          ty_lips.


TYPES : BEGIN OF ty_mara_mard,
          matnr   TYPE mara-matnr,
          zseries TYPE mara-zseries,
          zsize   TYPE mara-zsize,
          brand   TYPE mara-brand,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
          wrkst   TYPE mara-wrkst,

          werks   TYPE mard-werks,
*          labst   TYPE mard-labst,
        END OF ty_mara_mard.

DATA : it_mara_mard TYPE STANDARD TABLE OF ty_mara_mard,
       wa_mara_mard TYPE ty_mara_mard.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
*  posnr  type vbak-posnr,
          vbtyp TYPE vbak-vbtyp,
        END OF ty_vbak.

DATA : it_vbak TYPE TABLE OF ty_vbak,
       wa_vbak TYPE ty_vbak.

TYPES: BEGIN OF ty_data,
         vbeln  TYPE vbeln,
         posnr  TYPE posnr,
         matnr  TYPE matnr,
         werks  TYPE werks,
         kwmeng TYPE kwmeng,
         abgru  TYPE abgru,
         lfsta  TYPE lfsta,
       END OF ty_data.

DATA: it_data TYPE STANDARD TABLE OF ty_data,
      wa_data TYPE ty_data.

TYPES: BEGIN OF ty_open_inv,
         vbeln TYPE lips-vbeln,
         posnr TYPE lips-posnr,
         matnr TYPE lips-matnr,
         werks TYPE lips-werks,
         lfimg TYPE lips-lfimg,
         vkbur TYPE lips-vkbur,
         pstyv TYPE lips-pstyv,
         fksta TYPE vbup-fksta,
       END OF ty_open_inv.

DATA: it_open_inv TYPE TABLE OF ty_open_inv,
      wa_open_inv TYPE          ty_open_inv.
TYPES : BEGIN OF ty_final,
          matnr       TYPE mara-matnr,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          brand       TYPE mara-brand,
          moc         TYPE mara-moc,
          type        TYPE mara-type,
          wrkst       TYPE mara-wrkst,

          vbeln       TYPE vbap-vbeln,
          posnr       TYPE vbap-posnr,
          lfgsa       TYPE vbup-lfgsa,

          vgbel       TYPE lips-vgbel,
          vgpos       TYPE lips-vgpos,
          lfimg       TYPE lips-lfimg,

          werks       TYPE mard-werks,
          labst       TYPE p DECIMALS 0,

          omeng       TYPE vbbe-omeng,

          kulab       TYPE p DECIMALS 0,

          bwart       TYPE mseg-bwart,
          vbeln_im    TYPE mseg-vbeln_im,
          vbelp_im    TYPE mseg-vbelp_im,
          mseg_menge  TYPE mseg-menge,
          mseg_menge1 TYPE mseg-menge,
          mblnr       TYPE mseg-mblnr,
          smbln       TYPE mseg-smbln,

          ebeln       TYPE ekpo-ebeln,
          ebelp       TYPE ekpo-ebelp,
          menge       TYPE ekpo-menge,
          loekz       TYPE ekpo-loekz,
          elikz       TYPE ekpo-elikz,

          wemng       TYPE eket-wemng,
*          lv_desc     TYPE tdline,
          mattxt      TYPE text100,
          free_stock  TYPE p DECIMALS 0,
          tran_qty    TYPE p DECIMALS 0,
          so_fall_qty TYPE p DECIMALS 0,
          menge2      TYPE string,
          menge3      TYPE string,
          menge4      TYPE string,
*          pend_po_qty TYPE string,
          pend_po_qty TYPE p DECIMALS 0,
          indent_qty  TYPE p DECIMALS 0,
          open_qty    TYPE p DECIMALS 0,
          vbap_qty    TYPE vbrp-fkimg,
          lips_qty    TYPE vbrp-fkimg,
          retpo       TYPE ekpo-retpo,
          neg         TYPE string,
          open_inv    TYPE p DECIMALS 0,

        END OF ty_final.

TYPES : BEGIN OF ty_vbrk,
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
        END OF ty_vbrk.

DATA : it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final,
       it_vbrk  TYPE TABLE OF ty_vbrk,
       wa_vbrk  TYPE          ty_vbrk.

TYPES : BEGIN OF ty_final_download,
          matnr       TYPE mara-matnr,
          mattxt      TYPE text100,
          wrkst       TYPE mara-wrkst,
          brand       TYPE mara-brand,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          moc         TYPE mara-moc,
          type        TYPE mara-type,
          open_qty    TYPE char15,
          labst       TYPE char15,
          free_stock  TYPE char15,
          kulab       TYPE char15,
          tran_qty    TYPE char15,
          so_fall_qty TYPE char15,
          pend_po_qty TYPE char15,
          indent_qty  TYPE char15,
          open_inv    TYPE char15,
          werks       TYPE char10,
          ref         TYPE char15,
          time        TYPE char15,
        END OF ty_final_download.

DATA : lt_final TYPE TABLE OF ty_final_download,
       ls_final TYPE ty_final_download.

DATA  : gt_fieldcat TYPE slis_t_fieldcat_alv,
        gs_fieldcat TYPE slis_fieldcat_alv.

DATA : gt_lines TYPE TABLE OF tline,
       ls_lines TYPE tline.

DATA : lv_desc TYPE tline.

DATA : pr_count TYPE i.

DATA : neg TYPE string.
DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : mat FOR mara-matnr,
                 plant FOR mard-werks OBLIGATORY NO INTERVALS DEFAULT 'SU01' MODIF ID bu.
*PARAMETERS: plant LIKE mard-werks DEFAULT 'US01'
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/Saudi'."Saudi'."Saudi'."Saudi'. " '/Delval/Saudi'."Saudi'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  PERFORM get_transit.
  PERFORM get_data.
  PERFORM process_data.
  PERFORM fcat.
  PERFORM display_data.

FORM get_data .
*  BREAK primus.
  SELECT
    a~matnr
    a~zseries
    a~zsize
    a~brand
    a~moc
    a~type
    a~wrkst
    b~werks
    INTO TABLE it_mara_mard
    FROM mara AS a
                  INNER JOIN mard AS b ON b~matnr = a~matnr
    WHERE a~matnr IN mat AND b~werks IN plant.

  SORT it_mara_mard BY matnr werks.
  DELETE ADJACENT DUPLICATES FROM it_mara_mard COMPARING matnr werks.

*  DELETE it_mara_mard WHERE werks = 'SU01'.

  SELECT a~vbeln a~posnr a~matnr a~werks a~kwmeng a~abgru
         b~lfsta
      INTO TABLE it_data
      FROM  vbap AS a
      JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
      FOR ALL ENTRIES IN it_mara_mard
      WHERE a~matnr = it_mara_mard-matnr
      AND   a~abgru = ''
      AND   b~lfsta  NE 'C'.


  SELECT a~vbeln a~posnr a~matnr a~werks a~lfimg a~vkbur a~pstyv b~fksta
        INTO TABLE it_open_inv
        FROM  lips AS a
        JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
      FOR ALL ENTRIES IN it_mara_mard
        WHERE a~matnr = it_mara_mard-matnr
        AND   a~werks  IN plant
        AND   a~vkbur  = 'SU01'
        AND   a~pstyv  = 'ZTAN'
        AND   b~fksta  NE 'C'.


  SELECT
     vbeln
     vbtyp
     FROM vbak
     INTO TABLE it_vbak
     FOR ALL ENTRIES IN it_data
     WHERE vbeln = it_data-vbeln
     AND   vbtyp IN ( 'C' , 'I' , 'H' ).

  SELECT
    vbeln
    posnr
    vgbel
    vgpos
    matnr
    werks
    lfimg
    FROM lips
    INTO TABLE it_lips
           FOR ALL ENTRIES IN it_data
           WHERE vgbel = it_data-vbeln
            AND  vgpos = it_data-posnr
            AND  werks IN plant.


  IF it_mara_mard IS NOT INITIAL.
    SELECT matnr
           zseries
           zsize
           brand
           moc
           type
           wrkst   FROM mara INTO TABLE it_mara
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr.


    SELECT
          matnr
          lgort
          werks
          labst
          FROM mard
          INTO TABLE it_mard
          FOR ALL ENTRIES IN it_mara_mard
          WHERE matnr = it_mara_mard-matnr
            AND werks = it_mara_mard-werks.
  ENDIF.

  IF it_mara_mard IS NOT INITIAL.
    SELECT
      matnr
      werks
      omeng
      FROM vbbe
      INTO TABLE it_vbbe
      FOR ALL ENTRIES IN it_mara_mard
      WHERE matnr EQ it_mara_mard-matnr AND werks EQ it_mara_mard-werks.
  ENDIF.

  IF it_mara_mard IS NOT INITIAL .
    SELECT
      matnr
      werks
      charg
      sobkz
      kunnr
      kulab
      FROM msku
      INTO TABLE it_msku
      FOR ALL ENTRIES IN it_mara_mard
      WHERE matnr EQ it_mara_mard-matnr
       AND  werks EQ it_mara_mard-werks.
  ENDIF.

  IF it_mara_mard IS NOT INITIAL .
    SELECT
      matnr
      mblnr
      bwart
      werks
      vbeln_im
      vbelp_im
      menge
      FROM mseg
      INTO CORRESPONDING FIELDS OF TABLE it_mseg
      FOR ALL ENTRIES IN it_mara_mard
      WHERE matnr = it_mara_mard-matnr
      AND   werks IN plant
      AND bwart = '103'.
  ENDIF.

  IF it_mara_mard IS NOT INITIAL .
    SELECT
      matnr
      mblnr
      bwart
      werks
      vbeln_im
      vbelp_im
      menge
      FROM mseg
      INTO CORRESPONDING FIELDS OF TABLE it_mseg_105
      FOR ALL ENTRIES IN it_mara_mard
      WHERE matnr = it_mara_mard-matnr
      AND   werks = it_mara_mard-werks
      AND bwart = '105'.
  ENDIF.

  IF it_mara_mard IS NOT INITIAL .
    SELECT
      matnr
      mblnr
      bwart
      werks
      vbeln_im
      vbelp_im
      menge
      FROM mseg
      INTO CORRESPONDING FIELDS OF  TABLE it_mseg_101
      FOR ALL ENTRIES IN it_mara_mard
      WHERE matnr = it_mara_mard-matnr
      AND   werks = it_mara_mard-werks
      AND bwart = '101'.
  ENDIF.

  IF it_mara_mard IS NOT INITIAL .
    SELECT
      matnr
      mblnr
      bwart
      werks
      vbeln_im
      vbelp_im
      menge
      FROM mseg
      INTO CORRESPONDING FIELDS OF TABLE it_mseg_102
      FOR ALL ENTRIES IN it_mara_mard
      WHERE matnr = it_mara_mard-matnr
      AND   werks = it_mara_mard-werks
      AND bwart = '102'.
  ENDIF.



  IF it_mseg IS NOT INITIAL.
    SELECT mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln  FROM mseg INTO CORRESPONDING FIELDS OF TABLE it_rev
           FOR ALL ENTRIES IN it_mseg
           WHERE smbln = it_mseg-mblnr+0(10)
            AND  matnr = it_mseg-matnr.
  ENDIF.

  IF it_mseg_105 IS NOT INITIAL.
    SELECT mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln
           FROM mseg INTO CORRESPONDING FIELDS OF TABLE it_rev1
           FOR ALL ENTRIES IN it_mseg_105
           WHERE smbln = it_mseg_105-mblnr+0(10)
            AND  matnr = it_mseg_105-matnr
            AND  werks IN plant.
  ENDIF.


  SELECT a~ebeln
         a~ebelp
         a~matnr
         a~menge
         a~loekz
         a~elikz
         a~werks
         a~retpo
         b~wemng
    INTO TABLE it_ekpo_eket
FROM ekpo AS a
INNER JOIN eket AS b
ON a~ebeln = b~ebeln
AND a~ebelp = b~ebelp
  FOR ALL ENTRIES IN it_mara_mard
  WHERE a~matnr EQ it_mara_mard-matnr AND a~werks IN plant
  AND a~loekz NE 'L' AND a~retpo NE 'X'.


  IF it_mara_mard IS NOT INITIAL .
    SELECT
          matnr
          ebeln
          ebelp
          menge
          loekz
          elikz
          werks
          retpo

          FROM ekpo
          INTO CORRESPONDING FIELDS OF TABLE it_ekpo1
          FOR ALL ENTRIES IN it_mara_mard
          WHERE matnr EQ it_mara_mard-matnr
           AND werks IN plant
          AND retpo EQ 'X'.
  ENDIF.
*****************************ADDED BY PRIMUS JYOTI ON 02.02.2024
*  IF it_mara_mard IS NOT INITIAL.
*    SELECT matnr
*           werks
*           fkimg
*       FROM vbrp
*   INTO TABLE it_vbrp
*      FOR ALL ENTRIES IN it_mara_mard
*   WHERE matnr = it_mara_mard-matnr   AND werks = 'SU01'.
*    and werks = it_mara_mard-werks.
*
*    SELECT vbeln,
*       fkart,
*       fkdat,
*       knumv,
*       rfbsk,
*       kunag,
*       exnum,
*       xblnr,
*       logsys,
*       fksto FROM vbrk INTO TABLE @data(lt_vbrk)
*       WHERE  kunag = '0000300315'
*         AND fksto NE 'X'
*         AND fkart NE 'SS1'  AND fkart NE 'SS2'
*         AND logsys NE ' '.



*  ENDIF.
ENDFORM.

FORM process_data .

  SORT it_ekpo1 .

  LOOP AT it_mara_mard INTO wa_mara_mard.

*    READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_mara-matnr.
*    IF sy-subrc = 0.
    wa_final-matnr   = wa_mara_mard-matnr  .
    wa_final-zseries = wa_mara_mard-zseries.
    wa_final-zsize   = wa_mara_mard-zsize  .
    wa_final-brand   = wa_mara_mard-brand  .
    wa_final-moc     = wa_mara_mard-moc    .
    wa_final-type    = wa_mara_mard-type   .
    wa_final-wrkst   = wa_mara_mard-wrkst  .
    wa_final-werks   = wa_mara_mard-werks   .

*    ENDIF.
    CLEAR wa_final-labst.
    LOOP AT it_mard INTO wa_mard WHERE matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks .
      IF wa_mard-lgort = 'SURJ' OR wa_mard-lgort ='SUSC'.

      ELSE.
        wa_final-labst = wa_final-labst + wa_mard-labst.
      ENDIF.
    ENDLOOP.

    CLEAR wa_vbap.
    CLEAR wa_vbup.
    CLEAR wa_lips.
    CLEAR wa_final-vbap_qty.
    CLEAR wa_vbap-kwmeng.

    LOOP AT it_open_inv INTO wa_open_inv WHERE matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks..
      wa_final-open_inv = wa_final-open_inv + wa_open_inv-lfimg.
    ENDLOOP.

    CLEAR wa_vbak.
    CLEAR wa_final-lips_qty.
    CLEAR wa_lips-lfimg.
    LOOP AT it_data INTO wa_data WHERE matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks.
      wa_final-vbeln = wa_data-vbeln.
      wa_final-posnr = wa_data-posnr.
      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_data-vbeln.
      IF sy-subrc = 0.
        wa_final-vbap_qty = wa_final-vbap_qty + wa_data-kwmeng.
      ENDIF.

      LOOP AT it_lips INTO wa_lips WHERE vgbel = wa_final-vbeln AND  vgpos = wa_final-posnr.
        wa_final-lips_qty = wa_final-lips_qty + wa_lips-lfimg.
      ENDLOOP.
    ENDLOOP.



    CLEAR wa_final-open_qty.

    wa_final-open_qty = wa_final-vbap_qty - wa_final-lips_qty .


    LOOP AT it_msku INTO wa_msku WHERE matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks.
      wa_final-kulab = wa_final-kulab + wa_msku-kulab   .
    ENDLOOP.

    LOOP AT it_mseg INTO wa_mseg WHERE  matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks.
      READ TABLE it_rev INTO wa_rev WITH KEY smbln = wa_mseg-mblnr matnr = wa_mseg-matnr.
      IF sy-subrc = 4.
        wa_final-mseg_menge = wa_final-mseg_menge  + wa_mseg-menge.
      ENDIF.
    ENDLOOP.
*****
*****    LOOP AT IT_MSEG_105 INTO WA_MSEG_105 WHERE  MATNR = WA_MARA_MARD-MATNR AND WERKS = WA_MARA_MARD-WERKS.
*****
*****      READ TABLE IT_REV1 INTO WA_REV1 WITH KEY SMBLN = WA_MSEG_105-MBLNR MATNR = WA_MSEG_105-MATNR.
*****      IF SY-SUBRC = 4.
*****        WA_FINAL-MSEG_MENGE1 = WA_FINAL-MSEG_MENGE1  + WA_MSEG_105-MENGE.
*****      ENDIF.
*****    ENDLOOP.
*****
*****    CLEAR WA_FINAL-TRAN_QTY.
*****    WA_FINAL-TRAN_QTY = WA_FINAL-MSEG_MENGE - WA_FINAL-MSEG_MENGE1.

*************************************************************************************Added logic for Transit Qty  by Shubhangi Sarode on dt 01.02.2024
*    SELECT SINGLE fkimg FROM vbrp
*      INTO @DATA(lv_fkimg)
*      WHERE matnr = @wa_mara_mard-matnr  AND werks = 'SU01'.
*    DATA : lv_fkimg TYPE vbrp-fkimg.
*    LOOP AT it_vbrp INTO wa_vbrp WHERE matnr = wa_mara_mard-matnr AND werks = 'SU01'.
*      lv_fkimg = lv_fkimg + wa_vbrp-fkimg.
*      CLEAR wa_vbrp-fkimg.
*    ENDLOOP.
*
*    IF lv_fkimg IS NOT INITIAL.
*      wa_final-tran_qty = lv_fkimg.
*    ENDIF.
*
*    CLEAR lv_fkimg.
**
**    IF lv_fkimg IS NOT INITIAL.
**      wa_final-tran_qty = wa_final-mseg_menge + lv_fkimg.
**
**    ENDIF.
*
*    DATA: lv_m101 TYPE mseg-menge.
*
*    IF wa_final-tran_qty IS NOT INITIAL.                                  ""ADDED BY MA ON(09.02.2024)
*      LOOP AT it_mseg_101 INTO wa_mseg_101 WHERE matnr = wa_mara_mard-matnr  AND werks = 'SU01'.
*        lv_m101 = lv_m101 + wa_mseg_101-menge.
*      ENDLOOP.
*      wa_final-tran_qty = wa_final-tran_qty - lv_m101.
*    ENDIF.
*
*    LOOP AT it_mseg_102 INTO wa_mseg_102  WHERE  matnr = wa_mara_mard-matnr  AND werks = 'SU01' .                                 ""ADDED BY MA ON (09.02.2023)
*      wa_final-tran_qty = wa_final-tran_qty + wa_mseg_102-menge.
*    ENDLOOP.
*    BREAK-POINT.
    READ TABLE it_trans INTO wa_trans WITH KEY matnr = wa_mara_mard-matnr.
    IF sy-subrc = 0.
      wa_final-tran_qty = wa_trans-fkimg.
      CLEAR wa_trans-fkimg.
    ENDIF.

    LOOP AT it_mseg_102 INTO wa_mseg_102  WHERE  matnr = wa_mara_mard-matnr  AND werks = 'SU01' .                                 ""ADDED BY MA ON (09.02.2023)
      wa_final-tran_qty = wa_final-tran_qty + wa_mseg_102-menge.
      CLEAR wa_mseg_102-menge.
    ENDLOOP.

*************************************************************************************End.
*    CLEAR  lv_m101.
    CLEAR wa_final-menge2.
    CLEAR wa_final-menge3.
    CLEAR wa_final-menge4.
    CLEAR wa_ekpo1-menge.
    CLEAR wa_ekpo_eket.



    LOOP AT it_ekpo_eket INTO wa_ekpo_eket WHERE matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks.
      IF wa_ekpo_eket-elikz NE 'X' OR wa_ekpo_eket-wemng NE 0.
*    if wa_ekpo_eket-wemng ne 0.
        wa_final-menge2 = wa_final-menge2 + wa_ekpo_eket-menge.
*    endif.
      ENDIF.
      wa_final-menge3 = wa_final-menge3 + wa_ekpo_eket-wemng.
    ENDLOOP.

    LOOP AT it_ekpo1 INTO wa_ekpo1 WHERE matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks.
*      if sy-subrc = 0.
      wa_final-menge4 = wa_final-menge4 + wa_ekpo1-menge.
*        endif.
    ENDLOOP.

    CLEAR wa_final-pend_po_qty.
    wa_final-pend_po_qty = wa_final-menge2 - wa_final-menge3 - wa_final-menge4.

    IF wa_final-pend_po_qty LT 0.
      wa_final-pend_po_qty = 0.
    ENDIF.

    CLEAR wa_final-free_stock.
    wa_final-free_stock =  wa_final-labst -  wa_final-open_qty.
    IF wa_final-free_stock LT 0.
      wa_final-free_stock = 0.
    ENDIF.

    CLEAR wa_final-so_fall_qty.
    wa_final-so_fall_qty =  wa_final-open_qty - wa_final-labst - wa_final-tran_qty .
    IF wa_final-so_fall_qty LT 0.
      wa_final-so_fall_qty = 0.
    ENDIF.

    CLEAR wa_final-indent_qty.
    wa_final-indent_qty =  wa_final-open_qty - ( wa_final-labst + wa_final-pend_po_qty ).

    IF wa_final-indent_qty LT 0.
      wa_final-indent_qty = 0.
    ENDIF.


    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_mara_mard-matnr.
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-mattxt wa_lines-tdline INTO wa_final-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-mattxt.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '<(>' IN wa_final-mattxt WITH space.
    REPLACE ALL OCCURRENCES OF '<)>' IN wa_final-mattxt WITH space.

    APPEND wa_final TO it_final.
    CLEAR : wa_final,ls_final,wa_data.

  ENDLOOP.
  DELETE it_final WHERE open_qty = ' 'AND kulab = ' ' AND
                        tran_qty = ' ' AND pend_po_qty = ' '
                        AND free_stock = ' ' AND so_fall_qty = ' '
                        AND indent_qty = ' ' AND open_inv = ' '.
  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
*      LS_FINAL-MATNR       = WA_FINAL-MATNR  .
*      LS_FINAL-MATTXT      = WA_FINAL-MATTXT.
*      LS_FINAL-WRKST       = WA_FINAL-WRKST  .
*      LS_FINAL-ZSERIES     = WA_FINAL-ZSERIES.
*      LS_FINAL-BRAND       = WA_FINAL-BRAND  .
*      LS_FINAL-ZSERIES     = WA_FINAL-ZSERIES    .
*      LS_FINAL-ZSIZE       = WA_FINAL-ZSIZE  .
*      LS_FINAL-MOC         = WA_FINAL-MOC    .
*      LS_FINAL-TYPE        = WA_FINAL-TYPE   .
*      LS_FINAL-OPEN_QTY    = WA_FINAL-OPEN_QTY.
*      LS_FINAL-LABST       = WA_FINAL-LABST.
*      LS_FINAL-FREE_STOCK  = WA_FINAL-FREE_STOCK.
*      LS_FINAL-KULAB       = WA_FINAL-KULAB.
*      LS_FINAL-TRAN_QTY    = WA_FINAL-TRAN_QTY.
*      LS_FINAL-SO_FALL_QTY = WA_FINAL-SO_FALL_QTY.
*      LS_FINAL-PEND_PO_QTY = WA_FINAL-PEND_PO_QTY.
*      LS_FINAL-INDENT_QTY  = WA_FINAL-INDENT_QTY.
*      LS_FINAL-OPEN_INV    = WA_FINAL-OPEN_INV.
*      LS_FINAL-WERKS    =    WA_FINAL-WERKS.
********************************************************

      ls_final-matnr         = wa_final-matnr.
      ls_final-mattxt        = wa_final-mattxt.
      ls_final-wrkst         = wa_final-wrkst  .
      ls_final-brand         = wa_final-brand   .
      ls_final-zseries       = wa_final-zseries  .
      ls_final-zsize         = wa_final-zsize     .
      ls_final-moc           = wa_final-moc .
      ls_final-type          = wa_final-type .
      ls_final-open_qty      = wa_final-open_qty.
      ls_final-labst         = wa_final-labst    .
      ls_final-free_stock    = wa_final-free_stock.
      ls_final-kulab         = wa_final-kulab      .
      ls_final-tran_qty      = wa_final-tran_qty .
      ls_final-so_fall_qty    = wa_final-so_fall_qty.
      ls_final-pend_po_qty    = wa_final-pend_po_qty.
      ls_final-indent_qty    = wa_final-indent_qty.
      ls_final-open_inv      = wa_final-open_inv  .
      ls_final-werks         = wa_final-werks     .





      ls_final-ref = sy-datum.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-ref
        IMPORTING
          output = ls_final-ref.

      CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                      INTO ls_final-ref SEPARATED BY '-'.


      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO ls_final-time SEPARATED BY ':'.

      APPEND ls_final TO lt_final.
      CLEAR ls_final.
    ENDLOOP.
  ENDIF.
ENDFORM.

FORM fcat .

  PERFORM build_fc USING  '1' pr_count 'MATNR'                 'Material Code'             'IT_FINAL'  '20'.
  PERFORM build_fc USING  '1' pr_count 'MATTXT'                'Material Description'      'IT_FINAL'  '50' .
  PERFORM build_fc USING  '1' pr_count 'WRKST'                 'Old Material Code'         'IT_FINAL'  '20'.
  PERFORM build_fc USING  '1' pr_count 'BRAND'                 'Brand'                     'IT_FINAL'  '5'.
  PERFORM build_fc USING  '1' pr_count 'ZSERIES'               'Series'                    'IT_FINAL'  '5'.
  PERFORM build_fc USING  '1' pr_count 'ZSIZE'                 'Size'                      'IT_FINAL'  '5'.
  PERFORM build_fc USING  '1' pr_count 'MOC'                   'MOC'                       'IT_FINAL'  '5'.
  PERFORM build_fc USING  '1' pr_count 'TYPE'                  'Type'                      'IT_FINAL'  '5'.
  PERFORM build_fc USING  '1' pr_count 'OPEN_QTY'              'Pending SO in Saudi'       'IT_FINAL'  '13'.
  PERFORM build_fc USING  '1' pr_count 'LABST'                 'Stock In Hand'             'IT_FINAL'  '10'.
  PERFORM build_fc USING  '1' pr_count 'FREE_STOCK'            'Free Stock'                'IT_FINAL'  '8'.
  PERFORM build_fc USING  '1' pr_count 'KULAB'                 'Consignment Stock'         'IT_FINAL'  '14'.
  PERFORM build_fc USING  '1' pr_count 'TRAN_QTY'              'Transit Qty'               'IT_FINAL'  '9'.
  PERFORM build_fc USING  '1' pr_count 'SO_FALL_QTY'           'SO Short Fall Qty'         'IT_FINAL'  '13'.
  PERFORM build_fc USING  '1' pr_count 'PEND_PO_QTY'           'Pend PO Qty'               'IT_FINAL'  '9'.
  PERFORM build_fc USING  '1' pr_count 'INDENT_QTY'            'Indent Qty'                'IT_FINAL'  '8'.
  PERFORM build_fc USING  '1' pr_count 'OPEN_INV'              'Open Invoice Qty'          'IT_FINAL'  '15'.
  PERFORM build_fc USING  '1' pr_count 'WERKS'                 'Plant'                     'IT_FINAL'  '15'.

ENDFORM.

FORM display_data.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP-OF-PAGE'
      it_fieldcat            = gt_fieldcat
    TABLES
      t_outtab               = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  IF p_down = 'X'.

    PERFORM download.
*    PERFORM gui_download.
  ENDIF.
ENDFORM.

FORM build_fc  USING        pr_row TYPE i
                            pr_count TYPE i
                            pr_fname TYPE string
                            pr_title TYPE string
                            pr_table TYPE slis_tabname
                            pr_length TYPE string.

  pr_count = pr_count + 1.
  gs_fieldcat-row_pos   = pr_row.
  gs_fieldcat-col_pos   = pr_count.
  gs_fieldcat-fieldname = pr_fname.
  gs_fieldcat-seltext_l = pr_title.
  gs_fieldcat-tabname   = pr_table.
  gs_fieldcat-outputlen = pr_length.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.

ENDFORM.

FORM top-of-page.

*  ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

*  Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Stock Planning '.
  APPEND wa_header TO t_header.
  CLEAR wa_header.



*  Date
*  wa_header-typ  = 'S'.
*  wa_header-key  = 'Run Date : '.
*  CONCATENATE wa_header-info sy-datum+6(2) '.' sy-datum+4(2) '.'
*                      sy-datum(4) INTO wa_header-info.
*  APPEND wa_header TO t_header.
*  CLEAR: wa_header.
*
**  Time
*  wa_header-typ  = 'S'.
*  wa_header-key  = 'Run Time: '.
*  CONCATENATE wa_header-info sy-timlo(2) ':' sy-timlo+2(2) ':'
*                      sy-timlo+4(2) INTO wa_header-info.
*  APPEND wa_header TO t_header.
*  CLEAR: wa_header.

*   Total No. of Records Selected
  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
ENDFORM.                    " top-of-page



*****************************************Download logic***************************************************

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
      i_tab_sap_data       = lt_final
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

*  IF plant = 'US01'.
  lv_file = 'ZSU_STOCK_SU01.TXT'.
*  ENDIF.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
*  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'Material Stock Planning Report started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1320 TYPE string.
DATA lv_crlf_1320 TYPE string.
lv_crlf_1320 = cl_abap_char_utilities=>cr_lf.
lv_string_1320 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1320 lv_crlf_1320 wa_csv INTO lv_string_1320.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1043 TO lv_fullfile.
TRANSFER lv_string_1320 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


**********************************SQL UPLOAD FILE*************************************

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_final
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

*  IF plant = 'US01'.
  lv_file = 'ZSU_STOCK_SU01.TXT'.
*  ENDIF.

*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'Material Stock Planning Report started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1361 TYPE string.
DATA lv_crlf_1361 TYPE string.
lv_crlf_1361 = cl_abap_char_utilities=>cr_lf.
lv_string_1361 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1361 lv_crlf_1361 wa_csv INTO lv_string_1361.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1043 TO lv_fullfile.
TRANSFER lv_string_1361 TO lv_fullfile.
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
  CONCATENATE'Material Code'
             'Material Description'
             'Old Material Code'   "(002)
             'Brand'
             'Series'
             'Size'
             'MOC'
             'Type'
             'Pending SO in Saudi'
             'Stock In Hand'
             'Free Stock'
             'Consignment Stock'
             'Transit Qty'
             'SO Short Fall Qty'
             'Pend PO Qty'
             'Indent Qty'
             'Open Invoice Qty'
             'Plant'
             'Refresh File Date'
             'Refresh File Time'
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
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
            kunag = '0000300315'
           AND fksto NE 'X'
           AND fkart NE 'SS1'  AND fkart NE 'SS2'
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
           werks FROM vbrp INTO CORRESPONDING FIELDS OF TABLE it_vbrp
           FOR ALL ENTRIES IN it_vbrk
           WHERE vbeln = it_vbrk-vbeln.


    SELECT knumv
           kposn
           kschl
           kbetr
           kwert FROM prcd_elements INTO TABLE it_konv
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
           vbelp_im FROM mseg INTO CORRESPONDING FIELDS OF TABLE it_mseg
           FOR ALL ENTRIES IN it_vbrp
           WHERE xblnr_mkpf = it_vbrp-vgbel
*         AND VBELP_IM = it_vbrp-posnr
             AND bwart = '101'.


    SELECT mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im FROM mseg INTO CORRESPONDING FIELDS OF TABLE it_rev
           FOR ALL ENTRIES IN it_vbrp
           WHERE xblnr_mkpf = it_vbrp-vgbel
*       AND VBELP_IM = it_vbrp-posnr
           AND bwart = '101' .







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
           matnr FROM ekpo INTO TABLE it_ekpo02
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
           vbelp_im FROM mseg INTO CORRESPONDING FIELDS OF TABLE it_mseg1
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

    READ TABLE it_ekpo02 INTO wa_ekpo02 WITH KEY ebeln = wa_vapma-bstnk  matnr = wa_vapma-matnr ebelp = ls_vbap-posex.
    IF sy-subrc = 0.
      wa_transit-ebeln = wa_ekpo02-ebeln.
      wa_transit-ebelp = wa_ekpo02-ebelp.
      wa_transit-matnr = wa_ekpo02-matnr.
      wa_transit-menge = wa_ekpo02-menge.
      wa_transit-werks = wa_ekpo02-werks.

    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_ekpo02-matnr.
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


    CLEAR:wa_transit,wa_mseg,wa_rev,wa_bkpf,wa_mseg1,wa_vbrp,wa_eikp,wa_mode,wa_kna1,wa_t005t,wa_vbrk,wa_t618t,wa_mara,wa_ekpo02,
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

**********************************************************************************************************
