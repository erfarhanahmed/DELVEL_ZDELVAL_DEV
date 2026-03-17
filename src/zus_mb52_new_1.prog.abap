*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_mb52_new_1.

TABLES:mard,mara,mska.

TYPES: BEGIN OF ty_mara,
         matnr   TYPE mara-matnr,
         zseries TYPE mara-zseries,
         zsize   TYPE mara-zsize,
         brand   TYPE mara-brand,
         moc     TYPE mara-moc,
         type    TYPE mara-type,
         wrkst   TYPE mara-wrkst,
         meins   TYPE mara-meins,
       END OF ty_mara,

       BEGIN OF ty_vbap,
         vbeln TYPE vbup-vbeln,
         posnr TYPE vbup-posnr,
         lfsta TYPE vbup-lfsta,
         lfgsa TYPE vbup-lfgsa,
       END OF ty_vbap,

       BEGIN OF ty_mseg,
         mblnr   TYPE  mseg-mblnr,
         zeile   TYPE  mseg-zeile,
         line_id TYPE  mseg-line_id,
         bwart   TYPE  mseg-bwart,
         matnr   TYPE  mseg-matnr,
         werks   TYPE  mseg-werks,
         menge   TYPE  mseg-menge,
         smbln   TYPE  mseg-smbln,
         bukrs   TYPE  mseg-bukrs,
       END OF ty_mseg,

       BEGIN OF ty_mara_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         lgpbe TYPE mard-lgpbe,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
       END OF ty_mara_mard,

       BEGIN OF ty_mara_new,
         matnr TYPE mard-matnr,
         lgort TYPE mard-lgort,
         werks TYPE mard-werks,
       END OF ty_mara_new,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         labst TYPE mard-labst,
         umlme TYPE mard-umlme,
         insme TYPE mard-insme,
         einme TYPE mard-einme,
         speme TYPE mard-speme,
         retme TYPE mard-retme,
         vmlab TYPE mard-vmlab,
         vmuml TYPE mard-vmuml,
         vmins TYPE mard-vmins,
         vmein TYPE mard-vmein,
         vmspe TYPE mard-vmspe,
         vmret TYPE mard-vmret,
         lvorm TYPE mard-lvorm,
       END OF ty_mard,

       BEGIN OF ty_t001,
         bukrs TYPE t001-bukrs,
         waers TYPE t001-waers,
       END OF ty_t001,

       BEGIN OF ty_t001w,
         werks TYPE werks,
         name1 TYPE name1,
       END OF ty_t001w,

       BEGIN OF ty_t001l,
         lgort TYPE t001l-lgort,
         lgobe TYPE t001l-lgobe,
       END OF ty_t001l,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_mbew,
         matnr TYPE mbew-matnr,
         bwkey TYPE mbew-bwkey,
         lbkum TYPE mbew-lbkum,
         salk3 TYPE mbew-salk3,
         vprsv TYPE mbew-vprsv,
         verpr TYPE mbew-verpr,
         stprs TYPE mbew-stprs,
         bklas TYPE mbew-bklas,
       END OF ty_mbew,

       BEGIN OF ty_ebew,
         matnr TYPE ebew-matnr,
         bwkey TYPE ebew-bwkey,
         vbeln TYPE ebew-vbeln,
         posnr TYPE ebew-posnr,
         lbkum TYPE ebew-lbkum,
         salk3 TYPE ebew-salk3,
         vprsv TYPE ebew-vprsv,
         verpr TYPE ebew-verpr,
         stprs TYPE ebew-stprs,
       END OF ty_ebew,

       BEGIN OF ty_vbup_1,
         matnr TYPE mska-matnr,
         werks TYPE mska-werks,
         lgort TYPE mska-lgort,
         sobkz TYPE mska-sobkz,
         kalab TYPE mska-kalab,
         kains TYPE mska-kains,
         kaspe TYPE mska-kaspe,
         kavla TYPE mska-kavla,
         kavin TYPE mska-kavin,
         kavsp TYPE mska-kavsp,
         kavei TYPE mska-kavei,
         vbeln TYPE vbup-vbeln,
         posnr TYPE vbup-posnr,
         lfsta TYPE vbup-lfsta,
         lfgsa TYPE vbup-lfgsa,
       END  OF ty_vbup_1,

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

       BEGIN OF ty_mslb,
         matnr TYPE mslb-matnr,
         werks TYPE mslb-werks,
         lblab TYPE mslb-lblab,
         lbins TYPE mslb-lbins,
         lbvla TYPE mslb-lbvla,
         lbvei TYPE mslb-lbvei,
         lbuml TYPE mslb-lbuml,
         sobkz TYPE mslb-sobkz,
         lifnr TYPE mslb-lifnr,
       END OF ty_mslb,

       BEGIN OF ty_msku,
         matnr TYPE msku-matnr,
         werks TYPE msku-werks,
         charg TYPE msku-charg,
         sobkz TYPE msku-sobkz,
         kunnr TYPE msku-kunnr,
         kulab TYPE msku-kulab,
       END OF ty_msku,

       BEGIN OF ty_mchb,
         matnr    TYPE mchb-matnr,
         werks    TYPE mchb-werks,
         sgt_scat TYPE mchb-sgt_scat,
       END OF ty_mchb,

       BEGIN OF ty_mseg_1,
         mblnr   TYPE mseg-mblnr,
         zeile   TYPE mseg-zeile,
         line_id TYPE mseg-line_id,
         bwart   TYPE mseg-bwart,
         matnr   TYPE mseg-matnr,
         werks   TYPE mseg-werks,
         menge   TYPE mseg-menge,
         smbln   TYPE mseg-smbln,
         bukrs   TYPE mseg-bukrs,
       END OF ty_mseg_1,

       BEGIN OF ty_t001k,
         bwkey TYPE t001k-bwkey,
         bukrs TYPE t001k-bukrs,
       END OF ty_t001k,

       BEGIN OF ty_mssa,
         matnr TYPE mssa-matnr,
         werks TYPE mssa-werks,
         kzbws TYPE mssa-kzbws,
       END OF ty_mssa,

       BEGIN OF ty_final,
         matnr    TYPE mard-matnr,
         mattxt   TYPE text255,
         wrkst    TYPE mara-wrkst,
         brand    TYPE mara-brand,
         zseries  TYPE mara-zseries,
         zsize    TYPE mara-zsize,
         moc      TYPE mara-moc,
         type     TYPE mara-type,
         mtart    TYPE mara-mtart,
         matkl    TYPE mara-matkl,
         werks    TYPE mard-werks,
         labst    TYPE mard-labst,
         umlme    TYPE mard-umlme,
         insme    TYPE mard-insme,
         kulab    TYPE msku-kulab,
         kalab    TYPE mska-kalab,
         kains    TYPE mska-kains,
         speme    TYPE mard-speme,
         retme    TYPE mard-retme,
         total    TYPE mseg-menge,
         menge    TYPE mseg-menge,
         ref      TYPE char15,
         salk3    TYPE mbew-salk3,
         lgort    TYPE mard-lgort,          "added by pankaj 21.03.2022
         lv_qas   TYPE mbew-salk3,
         lv_speme TYPE mard-speme,
         name1    TYPE t001w-name1,
         lgobe    TYPE t001l-lgobe,
         sobkz    TYPE msku-sobkz,
         lvorm    TYPE mard-lvorm,
         meins    TYPE mara-meins,
         waers    TYPE t001-waers,
         einme    TYPE mard-einme,
         bwesb    TYPE marc-bwesb,
         glgmg    TYPE marc-glgmg,
         trame    TYPE marc-trame,
         umlmc    TYPE marc-umlmc,
         kzbws    TYPE mssa-kzbws,
         sgt_scat TYPE mchb-sgt_scat,
         lv_rest  TYPE char15,
         lv_rets  TYPE string,
         lv_gr    TYPE string,
         lv_tie   TYPE string,
         lv_tra   TYPE string,
         lv_tfr   TYPE string,
         kunnr    TYPE msku-kunnr,
         vbeln    TYPE vbap-vbeln,
         posnr    TYPE vbap-posnr,
         lv_con   TYPE p DECIMALS 2,
         lv_all   TYPE p DECIMALS 2,
       END OF ty_final,

       BEGIN OF ty_str,
         matnr    TYPE mard-matnr,
         mattxt   TYPE text255,
         mtart    TYPE mara-mtart,
         wrkst    TYPE mara-wrkst,
         lgort    TYPE mard-lgort,
         labst    TYPE char15,
         salk3    TYPE char15,
         kunnr    TYPE msku-kunnr,
         kulab    TYPE char15,
         lv_con   TYPE char15,
         vbeln    TYPE vbap-vbeln,
         posnr    TYPE vbap-posnr,
         kalab    TYPE char15,
         lv_all   TYPE char15,
         insme    TYPE char15,
         lv_qas   TYPE char15,
         speme    TYPE char15,
         lv_speme TYPE char15,
         werks    TYPE mard-werks,
         name1    TYPE t001w-name1,
         matkl    TYPE mara-matkl,
         lgobe    TYPE t001l-lgobe,
         sobkz    TYPE msku-sobkz,
         lvorm    TYPE mard-lvorm,
         meins    TYPE mara-meins,
         waers    TYPE t001-waers,
         brand    TYPE mara-brand,
         zseries  TYPE mara-zseries,
         zsize    TYPE mara-zsize,
         moc      TYPE mara-moc,
         type     TYPE mara-type,
         total    TYPE char15,
         einme    TYPE char15,
         lv_rest  TYPE char15,
         retme    TYPE char15,
         lv_rets  TYPE string,
         bwesb    TYPE char15,
         lv_gr    TYPE string,
         glgmg    TYPE char15,
         lv_tie   TYPE string,
         kzbws    TYPE mssa-kzbws,
         sgt_scat TYPE char15,
*         TRAME    TYPE CHAR15,
*         LV_TRA   TYPE CHAR15,
         umlmc    TYPE char15,
         lv_tfr   TYPE char15,
*         UMLME    TYPE CHAR15,
         menge    TYPE char10,
         ref      TYPE char15,
         ref_time TYPE char15,
       END OF ty_str,


       BEGIN OF ty_marc,
         matnr TYPE matnr,
         werks TYPE werks,
         bwesb TYPE bwesb,
         glgmg TYPE glgmg,
         trame TYPE trame,
         umlmc TYPE marc-umlmc,
       END OF ty_marc.

TYPES : BEGIN OF ty_vbrk1,
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
        END OF ty_vbrk1.

DATA : it_vbrk1 TYPE STANDARD TABLE OF ty_vbrk1,
       wa_vbrk1 TYPE ty_vbrk1.

TYPES : BEGIN OF ty_vbrp_vapma,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          fkimg TYPE vbrp-fkimg,
          vgbel TYPE char35, "CHAR16,
          vgpos TYPE vbrp-vgpos,
          aubel TYPE vbrp-aubel,
          aupos TYPE vbrp-aupos,
          matnr TYPE vbrp-matnr,
          werks TYPE vbrp-werks,
          vkorg TYPE vapma-vkorg,
          bstnk TYPE vapma-bstnk,
          kunnr TYPE vapma-kunnr,
        END OF ty_vbrp_vapma.


DATA : it_vbrp_vapma TYPE STANDARD TABLE OF ty_vbrp_vapma,
       wa_vbrp_vapma TYPE ty_vbrp_vapma.

TYPES : BEGIN OF ty_konv,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          kbetr TYPE prcd_elements-kbetr,
          kwert TYPE prcd_elements-kwert,
        END OF ty_konv.

DATA : it_konv TYPE TABLE OF ty_konv,
       wa_konv TYPE          ty_konv.

TYPES : BEGIN OF ty_eikp,
          exnum TYPE eikp-exnum,
          iever TYPE eikp-iever,
        END OF ty_eikp.

DATA : it_eikp TYPE TABLE OF ty_eikp,
       wa_eikp TYPE          ty_eikp.

TYPES : BEGIN OF ty_t618t,
          spras TYPE t618t-spras,
          land1 TYPE t618t-land1,
          expvz TYPE t618t-expvz,
          bezei TYPE t618t-bezei,
        END OF ty_t618t.

DATA : it_t618t TYPE TABLE OF ty_t618t,
       wa_t618t TYPE          ty_t618t.

TYPES : BEGIN OF ty_mode,
          expvz TYPE ztransit-expvz,
          bezei TYPE ztransit-bezei,
          zdays TYPE ztransit-zdays,
        END OF ty_mode.

DATA : it_mode TYPE TABLE OF ty_mode,
       wa_mode TYPE          ty_mode.

TYPES : BEGIN OF ty_likp1,
          vbeln TYPE likp-vbeln,
          verur TYPE likp-verur,
          trspg TYPE likp-trspg,
        END OF ty_likp1.

DATA : it_likp1 TYPE TABLE OF ty_likp1,
       wa_likp1 TYPE          ty_likp1.

TYPES : BEGIN OF ty_mseg_new,
          mblnr(16)," TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          bwart      TYPE mseg-bwart,
          matnr      TYPE mseg-matnr,
          werks      TYPE mseg-werks,
          smbln      TYPE mseg-smbln,
          xblnr_mkpf TYPE mseg-xblnr_mkpf,
          vbeln_im   TYPE mseg-vbeln_im,
          vbelp_im   TYPE mseg-vbelp_im,
          menge      TYPE mseg-menge,
        END OF ty_mseg_new.

DATA : it_mseg_new11 TYPE TABLE OF ty_mseg_new,
       wa_mseg_new11 TYPE          ty_mseg_new.

TYPES : BEGIN OF ty_mseg3,
          mblnr(16)," TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          bwart      TYPE mseg-bwart,
          matnr      TYPE mseg-matnr,
          werks      TYPE mseg-werks,
          smbln      TYPE mseg-smbln,
          xblnr_mkpf TYPE mseg-xblnr_mkpf,
          vbeln_im   TYPE mseg-vbeln_im,
          vbelp_im   TYPE mseg-vbelp_im,
        END OF ty_mseg3.

DATA : it_mseg3 TYPE TABLE OF ty_mseg3,
       wa_mseg3 TYPE          ty_mseg3.

TYPES : BEGIN OF str_vbap,
          vbeln  TYPE vbap-vbeln,
          posnr  TYPE vbap-posnr,
          matnr  TYPE vbap-matnr,
          kwmeng TYPE vbap-kwmeng,
          posex  TYPE vbap-posex,
        END OF str_vbap.

DATA : lt_vbap TYPE TABLE OF str_vbap,
       ls_vbap TYPE          str_vbap.

TYPES : BEGIN OF ty_ekpo_1,
          ebeln TYPE vbak-bstnk, "ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          werks TYPE ekpo-werks,
          menge TYPE ekpo-menge,
          matnr TYPE ekpo-matnr,
        END OF ty_ekpo_1.

DATA : it_ekpo TYPE TABLE OF ty_ekpo_1,
       wa_ekpo TYPE          ty_ekpo_1.

TYPES : BEGIN OF ty_bkpf,
          belnr TYPE bkpf-belnr,
          blart TYPE bkpf-blart,
          xblnr TYPE bkpf-xblnr,
          stblg TYPE bkpf-stblg,
        END OF ty_bkpf.

DATA : it_bkpf TYPE TABLE OF ty_bkpf,
       wa_bkpf TYPE          ty_bkpf.

TYPES :BEGIN OF ty_mseg_new1,
         mblnr(16)," TYPE mseg-mblnr,
         mjahr      TYPE mseg-mjahr,
         bwart      TYPE mseg-bwart,
         matnr      TYPE mseg-matnr,
         werks      TYPE mseg-werks,
         smbln      TYPE mseg-smbln,
         xblnr_mkpf TYPE mseg-xblnr_mkpf,
         vbeln_im   TYPE mseg-vbeln_im,
         vbelp_im   TYPE mseg-vbelp_im,
       END OF ty_mseg_new1.

DATA: it_mseg_new TYPE TABLE OF ty_mseg_new1,
      wa_mseg_new TYPE          ty_mseg_new1.

TYPES : BEGIN OF ty_bkpf1,
          belnr TYPE bkpf-belnr,
          blart TYPE bkpf-blart,
          xblnr TYPE bkpf-xblnr,
          stblg TYPE bkpf-stblg,
        END OF ty_bkpf1.

DATA: it_bkpf1 TYPE TABLE OF ty_bkpf,
      wa_bkpf1 TYPE          ty_bkpf.

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

DATA : it_transit TYPE TABLE OF str_final,
       wa_transit TYPE          str_final.

TYPES :BEGIN OF ty_trans,
         matnr TYPE mara-matnr,
         fkimg TYPE vbrp-fkimg,
         werks TYPE vbrp-werks,
       END OF ty_trans.

DATA :it_trans TYPE TABLE OF ty_trans,
      wa_trans TYPE          ty_trans.

DATA: it_mara      TYPE TABLE OF ty_mara,
      wa_mara      TYPE          ty_mara,

      it_marc      TYPE TABLE OF ty_marc,
      wa_marc      TYPE          ty_marc,

      it_vbap      TYPE TABLE OF ty_vbap,
      wa_vbap      TYPE          ty_vbap,

      it_makt      TYPE TABLE OF ty_makt,
      wa_makt      TYPE          ty_makt,

      it_mard      TYPE TABLE OF ty_mard,
      wa_mard      TYPE          ty_mard,

      it_mara_mard TYPE TABLE OF ty_mara_mard,
      wa_mara_mard TYPE          ty_mara_mard,

      it_mard_new  TYPE TABLE OF ty_mara_new,
      wa_mard_new  TYPE          ty_mara_new,

      it_mbew      TYPE TABLE OF ty_mbew,
      wa_mbew      TYPE          ty_mbew,

      it_ebew      TYPE TABLE OF ty_ebew,
      wa_ebew      TYPE          ty_ebew,

      it_mska      TYPE TABLE OF ty_mska,
      wa_mska      TYPE          ty_mska,

      it_msku      TYPE TABLE OF ty_msku,
      wa_msku      TYPE          ty_msku,

      it_mchb      TYPE TABLE OF ty_mchb,
      wa_mchb      TYPE          ty_mchb,

      it_mslb      TYPE TABLE OF ty_mslb,
      wa_mslb      TYPE          ty_mslb,

      it_mseg      TYPE TABLE OF ty_mseg,
      wa_mseg      TYPE          ty_mseg,

      it_mseg1     TYPE TABLE OF ty_mseg,
      wa_mseg1     TYPE          ty_mseg,

      it_mssa      TYPE TABLE OF ty_mssa,
      wa_mssa      TYPE          ty_mssa,

      it_mseg2     TYPE TABLE OF ty_mseg,
      wa_mseg2     TYPE          ty_mseg,

      it_t001      TYPE TABLE OF ty_t001,
      wa_t001      TYPE          ty_t001,

      it_rev       TYPE TABLE OF ty_mseg,
      wa_rev       TYPE          ty_mseg,

      it_rev1      TYPE TABLE OF ty_mseg,
      wa_rev1      TYPE          ty_mseg,

      it_rev2      TYPE TABLE OF ty_mseg,
      wa_rev2      TYPE          ty_mseg,

      it_final     TYPE TABLE OF ty_final,
      wa_final     TYPE          ty_final,

      lt_final     TYPE TABLE OF ty_str,
      ls_final     TYPE          ty_str,

      lt_t001w     TYPE TABLE OF ty_t001w,
      ls_t001w     TYPE          ty_t001w,

      lt_t001k     TYPE TABLE OF ty_t001k,
      ls_t001k     TYPE          ty_t001k,

      it_vbup_1    TYPE TABLE OF ty_vbup_1,
      wa_vbup_1    TYPE          ty_vbup_1,

      lt_t001l     TYPE TABLE OF ty_t001l,
      ls_t001l     TYPE          ty_t001l.

DATA : lv_diff TYPE p DECIMALS 10.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.



DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.



SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_matnr FOR mard-matnr,
                s_lgort FOR mard-lgort,
                s_mtart FOR mara-mtart,
                s_werks FOR mard-werks. " NO INTERVALS MODIF ID BU.
*PARAMETERS :
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-006 .
PARAMETERS p_stock AS CHECKBOX.
*SELECT-OPTIONS: s_SOBKZ FOR mska-sobkz.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/USA'.      "'/Delval/USA'."USA'."USA'."USA'."USA' .
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK b3.

*AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
*LOOP AT SCREEN.
*  IF SCREEN-GROUP1 = 'BU'.
*    SCREEN-INPUT = '0'.
*    MODIFY SCREEN.
* ENDIF.
*ENDLOOP.

INITIALIZATION.
  s_werks-sign = 'I'.
  s_werks-option = 'EQ' .
  s_werks-low = 'US01'.
  APPEND s_werks .
  CLEAR:s_werks.
*  S_WERKS-LOW = 'US02'.
*  APPEND S_WERKS.
*CLEAR:s_werks.
*  S_WERKS-LOW = 'US03'.
*  APPEND S_WERKS.
*CLEAR:s_werks.

  "Added BY Nilay B. On Date:27.11.2023" " Tr NO. DEVK912688

AT SELECTION-SCREEN ON s_werks.
  IF s_werks-low = 'PL01' OR  s_werks-low = 'SU01'  .

    MESSAGE 'You are not authorise for plant' TYPE 'E' DISPLAY LIKE 'E'.

  ENDIF.
  "Ended By NilaY B .



START-OF-SELECTION.
  BREAK primusabap.
  PERFORM get_transit.
  PERFORM get_data.
  PERFORM sort_data.
  PERFORM det_fcat.
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

  """"""""""""""""""""""""""""""""""""""""""""""""""""
  IF s_lgort IS NOT INITIAL.
***************Commented by jyoti on 05.11.2024**************
*     SELECT matnr
*            lgort
*            werks
*     FROM mard INTO TABLE it_mard_new
*     WHERE matnr IN s_matnr
*     AND   werks IN s_werks
*     AND   lgort IN s_lgort.

*  SELECT a~matnr
*         a~werks
*         a~lgort
*         a~lgpbe
*         b~mtart
*         b~matkl
*     INTO TABLE it_mara_mard FROM mard AS a
*     INNER JOIN mara AS b ON b~matnr = a~matnr
*     FOR ALL ENTRIES IN it_mard_new
*     WHERE a~matnr = it_mard_new-matnr
*     AND   b~mtart IN s_mtart
*     AND   a~werks = it_mard_new-werks
*     AND   a~lgort = it_mard_new-lgort.
***************************************************************

    SELECT a~matnr
             a~werks
             a~lgort
             a~lgpbe
             b~mtart
             b~matkl
         INTO TABLE it_mara_mard FROM mard AS a
         INNER JOIN mara AS b ON b~matnr = a~matnr
*     FOR ALL ENTRIES IN it_mard_new
         WHERE a~matnr IN s_matnr
         AND   b~mtart IN s_mtart
         AND   a~werks IN s_werks
         AND   a~lgort IN s_lgort.


  ELSE.

    SELECT a~matnr
           a~werks
           a~lgort
           a~lgpbe
           b~mtart
           b~matkl
           INTO TABLE it_mara_mard FROM mard AS a
           INNER JOIN mara AS b ON b~matnr = a~matnr
           WHERE a~matnr IN s_matnr
           AND   b~mtart IN s_mtart
           AND   a~werks IN s_werks.
  ENDIF.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""
  SORT it_mara_mard BY matnr werks.
**  DELETE ADJACENT DUPLICATES FROM it_mara_mard COMPARING matnr werks.
**  DELETE it_mara_mard WHERE werks IN  ( 'PL01' , 'US01' ).

  IF  it_mara_mard IS NOT INITIAL .
    SELECT matnr
           werks
           lgort
           labst
           umlme
           insme
           einme
           speme
           retme
           vmlab
           vmuml
           vmins
           vmein
           vmspe
           vmret
           lvorm  FROM mard INTO TABLE it_mard
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND  werks IN s_werks
           AND  lgort = it_mara_mard-lgort.

    SELECT werks
           name1
      FROM t001w
      INTO TABLE lt_t001w
      FOR ALL ENTRIES IN it_mard
      WHERE werks = it_mard-werks.

    SELECT matnr
           werks
           kzbws
      FROM mssa
      INTO TABLE it_mssa
      FOR ALL ENTRIES IN it_mard
      WHERE matnr = it_mard-matnr
      AND   werks = it_mard-werks.

    SELECT matnr
           werks
           bwesb
           glgmg
           trame
           umlmc
      FROM marc
      INTO TABLE it_marc
      FOR ALL ENTRIES IN it_mard
      WHERE matnr = it_mard-matnr
      AND   werks = it_mard-werks.

    SELECT lgort
           lgobe
           FROM t001l
           INTO TABLE lt_t001l
           FOR ALL ENTRIES IN it_mard
           WHERE lgort = it_mard-lgort.

    SELECT matnr
           werks
           sgt_scat
      FROM mchb
      INTO TABLE it_mchb
      FOR ALL ENTRIES IN it_mard
      WHERE matnr = it_mard-matnr
      AND   werks = it_mard-werks.

    BREAK primusabap.
    IF p_stock IS NOT INITIAL.
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
        FOR ALL ENTRIES IN it_mara_mard
        WHERE matnr = it_mara_mard-matnr
        AND   werks IN s_werks
        AND   lgort IN s_lgort ."added by jyoti on 04.11.2024
*        AND   sobkz IN s_SOBKZ    .

      SORT it_mska BY matnr.
      DELETE it_mska WHERE kalab = ''.
    ENDIF.

    IF it_mska IS NOT INITIAL.
      SELECT vbeln
             posnr
             lfsta
             lfgsa
        FROM vbup
        INTO TABLE it_vbap
        FOR ALL ENTRIES IN it_mska
        WHERE vbeln = it_mska-vbeln
        AND   posnr = it_mska-posnr
        AND   lfsta NE 'C'
        AND   lfgsa NE 'C' .
    ENDIF.

    SELECT a~matnr
           a~werks
           a~lgort
           a~sobkz
           a~kalab
           a~kains
           a~kaspe
           a~kavla
           a~kavin
           a~kavsp
           a~kavei
           b~vbeln
           b~posnr
           b~lfsta
           b~lfgsa
          FROM mska AS a INNER JOIN vbup AS b
          ON  a~vbeln EQ b~vbeln
          AND a~posnr EQ b~posnr
          INTO TABLE it_vbup_1
          FOR ALL ENTRIES IN it_mara_mard
           WHERE a~matnr = it_mara_mard-matnr
           AND   a~werks IN s_werks
           AND   b~lfsta NE 'C'
           AND   b~lfgsa NE 'C' .

    IF p_stock IS NOT INITIAL.
      IF s_lgort IS INITIAL AND s_mtart IS INITIAL.
        SELECT matnr
        werks
        charg
        sobkz
        kunnr
        kulab FROM msku INTO TABLE it_msku
        FOR ALL ENTRIES IN it_mara_mard
        WHERE matnr = it_mara_mard-matnr
        AND   werks = it_mara_mard-werks.
*      AND   sobkz IN s_SOBKZ    .

        SORT it_msku BY matnr.
        DELETE it_msku WHERE kulab = ''.
      ENDIF.
    ENDIF.

    IF p_stock IS NOT INITIAL.
      SELECT matnr
           werks
           lblab
           lbins
           lbvla
           lbvei
           lbuml
           sobkz
           lifnr
           FROM mslb INTO TABLE it_mslb
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   werks = it_mara_mard-werks.
    ENDIF.


    SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mara_mard
    WHERE matnr = it_mara_mard-matnr.


    SELECT matnr
           zseries
           zsize
           brand
           moc
           type
           wrkst
           meins       FROM mara INTO TABLE it_mara
           FOR ALL ENTRIES IN it_mara_mard
    WHERE matnr = it_mara_mard-matnr.

    SELECT mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln
           bukrs  FROM mseg INTO TABLE it_mseg
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   werks = it_mara_mard-werks
*           AND   BWART = '103'.
           AND   bwart IN ('103','106').

    SELECT bwkey
           bukrs
           FROM t001k INTO TABLE lt_t001k
           FOR ALL ENTRIES IN it_mard
           WHERE bwkey = it_mard-werks.

    SELECT bukrs
           waers
      FROM t001 INTO TABLE it_t001
      FOR ALL ENTRIES IN lt_t001k
      WHERE bukrs = lt_t001k-bukrs."'US00'.

    SELECT mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln  FROM mseg INTO TABLE it_mseg1
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   werks = it_mara_mard-werks
*    AND   BWART = '105'.
    AND   bwart IN ('105','104').

    SELECT mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln  FROM mseg INTO TABLE it_mseg2
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   werks = it_mara_mard-werks
    AND   bwart = '104'.
  ENDIF.

  IF it_mseg IS NOT INITIAL.
    SELECT mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln  FROM mseg INTO TABLE it_rev
           FOR ALL ENTRIES IN it_mseg
           WHERE smbln = it_mseg-mblnr
    AND  matnr = it_mseg-matnr.
  ENDIF.

  IF it_mseg1 IS NOT INITIAL.
    SELECT mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln  FROM mseg INTO TABLE it_rev1
           FOR ALL ENTRIES IN it_mseg1
           WHERE smbln = it_mseg1-mblnr
    AND  matnr = it_mseg1-matnr.
  ENDIF.

  IF it_mara_mard[] IS NOT INITIAL.
    SELECT matnr
           bwkey
           lbkum
           salk3
           vprsv
           verpr
           stprs
           bklas
           FROM mbew
           INTO TABLE it_mbew
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   bwkey = it_mara_mard-werks.
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

  LOOP AT it_mard INTO wa_mard.

*    IF wa_mard-labst IS NOT INITIAL.     "" Commented by Pranit 30.07.2024 bcz value do not display.
    wa_final-lgort = wa_mard-lgort.            "added by pankaj 21.03.2022
    wa_final-labst = wa_mard-labst.
    wa_final-umlme = wa_mard-umlme.      ""Commented by Pranit 01.08.2024 bcz suggested by Joshi sir.
    wa_final-insme = wa_mard-insme.
    wa_final-speme = wa_mard-speme.
    wa_final-retme = wa_mard-retme.
    wa_final-lvorm = wa_mard-lvorm.
    wa_final-einme = wa_mard-einme.

    READ TABLE it_marc INTO wa_marc WITH KEY matnr = wa_mard-matnr werks = wa_mard-werks.
    IF  sy-subrc = 0.
      wa_final-bwesb = wa_marc-bwesb.
      wa_final-glgmg = wa_marc-glgmg.
      wa_final-trame = wa_marc-trame.
      wa_final-umlmc = wa_marc-umlmc.
    ENDIF.

    READ TABLE it_mchb INTO wa_mchb WITH KEY matnr = wa_mard-matnr werks = wa_mard-werks.
    IF  sy-subrc = 0.
      wa_final-sgt_scat = wa_mchb-sgt_scat.
    ENDIF.

    READ TABLE it_mssa INTO wa_mssa WITH  KEY matnr = wa_mard-matnr werks = wa_mard-werks.
    IF sy-subrc = 0.
      wa_final-kzbws = wa_mssa-kzbws.
    ENDIF.

    READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_mard-matnr
                                                       werks = wa_mard-werks.
    IF sy-subrc = 0.
      wa_final-mtart = wa_mara_mard-mtart.
      wa_final-matkl = wa_mara_mard-matkl.
      wa_final-werks = wa_mara_mard-werks.
    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_mara_mard-matnr .
    IF sy-subrc = 0.
      wa_final-matnr       = wa_mara-matnr.
      wa_final-zseries     = wa_mara-zseries .
      wa_final-zsize       = wa_mara-zsize   .
      wa_final-brand       = wa_mara-brand   .
      wa_final-moc         = wa_mara-moc     .
      wa_final-type        = wa_mara-type    .
      wa_final-wrkst       = wa_mara-wrkst   .
      wa_final-meins       = wa_mara-meins   .
    ENDIF.

    DATA(lv_labst) = wa_final-labst + wa_final-kulab.

    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mara_mard-matnr bwkey = wa_mara_mard-werks.
    IF sy-subrc = 0.
      lv_diff = wa_mbew-salk3 / wa_mbew-lbkum.
      wa_final-salk3 = lv_diff * lv_labst.
      IF wa_mbew-vprsv = 'V'.
        wa_final-lv_qas   = wa_mbew-verpr * wa_final-insme. ""Added by 01.08.2024 (Value in Quality inspection)
        wa_final-lv_speme = wa_mbew-verpr * wa_final-speme. ""Added by 01.08.2024(Value block stock)
        wa_final-lv_rest  = wa_mbew-verpr * wa_final-einme. ""Added by 01.08.2024"""vALUE rESTRICTED
*        wa_final-lv_rets  = wa_mbew-verpr * wa_final-speme. ""Added by 01.08.2024"""Value Rets Blocked
        wa_final-lv_rets  = wa_mbew-verpr * wa_final-retme. ""Added by  aakashk 30.09.2024"""Value Rets Blocked
        wa_final-lv_gr    = wa_mbew-verpr * wa_final-bwesb. ""Added by 01.08.2024""" ""Val. GR Blocked St.
        wa_final-lv_tie   = wa_mbew-verpr * wa_final-glgmg. ""Added by 01.08.2024"""""Val. Tied Empties
        wa_final-lv_tra   = wa_mbew-verpr * wa_final-trame. ""Added by 01.08.2024"""""""Value in Transit
        wa_final-lv_tfr   = wa_mbew-verpr * wa_final-umlmc. ""Added by 01.08.2024"""""""Value in Transit
      ELSEIF wa_mbew-vprsv = 'S'.
        wa_final-lv_qas    = wa_mbew-stprs * wa_final-insme. ""Added by 01.08.2024 (Value in Quality inspection)
        wa_final-lv_speme  = wa_mbew-stprs * wa_final-speme. ""Added by 01.08.2024(Value block stock)
        wa_final-lv_rest   = wa_mbew-stprs * wa_final-einme. ""Added by 01.08.2024"""vALUE rESTRICTED
        wa_final-lv_rets   = wa_mbew-stprs * wa_final-speme. ""Added by 01.08.2024"""Value Rets Blocked
        wa_final-lv_gr     = wa_mbew-stprs * wa_final-bwesb. ""Added by 01.08.2024"" ""Val. GR Blocked St.
        wa_final-lv_tie    = wa_mbew-stprs * wa_final-glgmg. ""Added by 01.08.2024"" ""Val. Tied Empties
        wa_final-lv_tra    = wa_mbew-stprs * wa_final-trame. ""Added by 01.08.2024""""Value in Transit
        wa_final-lv_tfr    = wa_mbew-stprs * wa_final-umlmc. ""Added by 01.08.2024""""Value in Transit
      ENDIF.
    ENDIF.

    CLEAR : lv_lines, ls_mattxt.
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

    REPLACE ALL OCCURRENCES OF '<(>' IN wa_final-mattxt WITH space.
    REPLACE ALL OCCURRENCES OF '<)>' IN wa_final-mattxt WITH space.
    CONDENSE  wa_final-mattxt.
    wa_final-ref = sy-datum.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-ref
      IMPORTING
        output = wa_final-ref.

    CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
                    INTO wa_final-ref SEPARATED BY '-'.


    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = wa_final-werks.
    IF  sy-subrc = 0.
      wa_final-name1 = ls_t001w-name1.
    ENDIF.

    READ TABLE lt_t001l INTO ls_t001l WITH KEY lgort = wa_final-lgort.
    IF  sy-subrc = 0.
      wa_final-lgobe = ls_t001l-lgobe.
    ENDIF.

*    READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MATNR = WA_MARA_MARD-MATNR WERKS = WA_MARA_MARD-WERKS.

    READ TABLE it_t001 INTO wa_t001 INDEX 1." WITH KEY WERKS = WA_FINAL-WERKS .
    IF sy-subrc = 0.
      wa_final-waers = wa_t001-waers.
    ENDIF.

*    WA_FINAL-TOTAL = WA_FINAL-LABST + WA_FINAL-UMLME + WA_FINAL-INSME + WA_FINAL-KULAB         """TOTAL STOCK
*                     + WA_FINAL-KALAB + WA_FINAL-SPEME + WA_FINAL-RETME.

    wa_final-total = wa_final-labst + wa_final-kulab  + wa_final-kalab .

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""In transit Block
*        LOOP AT IT_MSEG INTO WA_MSEG WHERE MATNR = WA_MARA-MATNR AND  WERKS = WA_MARA_MARD-WERKS..
*      READ TABLE IT_REV INTO WA_REV WITH KEY SMBLN = WA_MSEG-MBLNR MATNR = WA_MSEG-MATNR.
*      IF SY-SUBRC = 4.
*        WA_FINAL-MENGE = WA_FINAL-MENGE  + WA_MSEG-MENGE.
*      ENDIF.
*      WA_FINAL-WERKS = WA_MSEG-WERKS.
*
*    ENDLOOP.
*
*    LOOP AT IT_MSEG1 INTO WA_MSEG1 WHERE MATNR = WA_MARA-MATNR AND  WERKS = WA_MARA_MARD-WERKS.
** wa_final-werks = wa_mseg-werks.
*      READ TABLE IT_REV1 INTO WA_REV1 WITH KEY SMBLN = WA_MSEG1-MBLNR MATNR = WA_MSEG1-MATNR.
*      IF SY-SUBRC = 4.
*        WA_FINAL-MENGE = WA_FINAL-MENGE  - WA_MSEG1-MENGE.
*      ENDIF.
*    ENDLOOP.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*     READ TABLE it_trans INTO wa_trans WITH KEY  matnr = wa_final-matnr.
*    IF  sy-subrc = 0.
*      wa_final-menge = wa_trans-fkimg.
*    ENDIF.

    IF wa_final-lgort IS NOT INITIAL.
        APPEND wa_final TO it_final.
        CLEAR wa_final.
      ENDIF.

  ENDLOOP.

  LOOP AT it_msku INTO wa_msku .                         """""FOR CUSTOMER VALUE
    wa_final-matnr = wa_msku-matnr.
    wa_final-werks = wa_msku-werks.
    wa_final-kunnr = wa_msku-kunnr.
    wa_final-kulab = wa_msku-kulab.
    wa_final-sobkz = wa_msku-sobkz.

    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_final-matnr bwkey = wa_final-werks.
    IF sy-subrc = 0.
      lv_diff = wa_mbew-salk3 / wa_mbew-lbkum.
      IF wa_mbew-vprsv = 'V'.
        wa_final-lv_con = wa_mbew-verpr * wa_msku-kulab.
      ELSEIF wa_mbew-vprsv = 'S'.
        wa_final-lv_con = wa_mbew-stprs * wa_msku-kulab.
      ENDIF.
    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_msku-matnr.
    IF sy-subrc = 0.
      wa_final-wrkst       = wa_mara-wrkst   .
      wa_final-zseries     = wa_mara-zseries .
      wa_final-zsize       = wa_mara-zsize   .
      wa_final-brand       = wa_mara-brand   .
      wa_final-moc         = wa_mara-moc     .
      wa_final-type        = wa_mara-type    .
      wa_final-meins       = wa_mara-meins   .
    ENDIF.

    READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_msku-matnr werks = wa_msku-werks.
    IF sy-subrc = 0.
      wa_final-mtart = wa_mara_mard-mtart.
      wa_final-matkl = wa_mara_mard-matkl.
      wa_final-werks = wa_mara_mard-werks.
    ENDIF.

    CLEAR: lv_lines, ls_mattxt.
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
    CONDENSE  wa_final-mattxt.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = wa_mard-werks.
    IF  sy-subrc = 0.
      wa_final-name1 = ls_t001w-name1.
    ENDIF.

*    READ TABLE LT_T001 INTO LS_T001 WITH KEY BUKRS = WA_MSEG-BUKRS .
    READ TABLE it_t001 INTO wa_t001 INDEX 1.
    IF sy-subrc = 0.
      wa_final-waers = wa_t001-waers.
    ENDIF.

    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_msku-matnr werks = wa_msku-werks.
    IF  sy-subrc = 0.
      wa_final-lvorm = wa_mard-lvorm.
    ENDIF.

    READ TABLE it_mssa INTO wa_mssa WITH KEY matnr = wa_msku-matnr werks = wa_msku-werks.
    IF sy-subrc = 0.
      wa_final-kzbws = wa_mssa-kzbws.
    ENDIF.

    wa_final-total = wa_final-kulab .

    APPEND wa_final TO it_final.
    CLEAR: wa_final.
  ENDLOOP.

  IF p_stock IS NOT INITIAL.
    LOOP AT it_vbup_1 INTO wa_vbup_1.                  "" FOR SALES ORDER VALUE
      wa_final-vbeln = wa_vbup_1-vbeln.
      wa_final-posnr = wa_vbup_1-posnr.
      wa_final-matnr = wa_vbup_1-matnr.
      wa_final-werks = wa_vbup_1-werks.
      wa_final-total = wa_vbup_1-kalab.

      CLEAR: lv_lines, ls_mattxt.
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

      REPLACE ALL OCCURRENCES OF '<(>' IN wa_final-mattxt WITH space.
      REPLACE ALL OCCURRENCES OF '<)>' IN wa_final-mattxt WITH space.
      CONDENSE  wa_final-mattxt.
      READ TABLE it_mska INTO wa_mska WITH KEY vbeln = wa_vbup_1-vbeln posnr = wa_vbup_1-posnr.
      IF  sy-subrc = 0.
        wa_final-kalab  = wa_mska-kalab.
        wa_final-sobkz  = wa_mska-sobkz.
*      ENDIF.

        READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_vbup_1-matnr werks = wa_vbup_1-werks.
        IF sy-subrc = 0.
          wa_final-mtart = wa_mara_mard-mtart.
          wa_final-matkl = wa_mara_mard-matkl.
        ENDIF.

        READ TABLE it_mbew INTO wa_mbew WITH KEY  matnr = wa_vbup_1-matnr bwkey = wa_final-werks.
        IF  sy-subrc = 0.
          IF wa_mbew-vprsv = 'V'.
            wa_final-lv_all = wa_mbew-verpr * wa_final-kalab.
          ELSEIF wa_mbew-vprsv = 'S'.
            wa_final-lv_all = wa_mbew-stprs * wa_final-kalab.
          ENDIF.
        ENDIF.

        READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_vbup_1-matnr.
        IF sy-subrc = 0.
          wa_final-wrkst       = wa_mara-wrkst   .
          wa_final-zseries     = wa_mara-zseries .
          wa_final-zsize       = wa_mara-zsize   .
          wa_final-brand       = wa_mara-brand   .
          wa_final-moc         = wa_mara-moc     .
          wa_final-type        = wa_mara-type    .
          wa_final-meins       = wa_mara-meins   .
        ENDIF.

        READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_vbup_1-matnr.
        IF  sy-subrc = 0.
          wa_final-lgort = wa_mard-lgort.
        ENDIF.

        READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = wa_vbup_1-werks.
        IF  sy-subrc = 0.
          wa_final-name1 = ls_t001w-name1.
        ENDIF.

        READ TABLE lt_t001l INTO ls_t001l WITH KEY lgort = wa_final-lgort.
        IF  sy-subrc = 0.
          wa_final-lgobe = ls_t001l-lgobe.
        ENDIF.

*    READ TABLE LT_T001 INTO LS_T001 WITH KEY BUKRS = WA_MSEG-BUKRS .
        READ TABLE it_t001 INTO wa_t001 INDEX 1.
        IF sy-subrc = 0.
          wa_final-waers = wa_t001-waers.
        ENDIF.

        READ TABLE it_mssa INTO wa_mssa WITH KEY matnr = wa_vbup_1-matnr werks = wa_vbup_1-werks.
        IF sy-subrc = 0.
          wa_final-kzbws = wa_mssa-kzbws.
        ENDIF.

        IF wa_final-lgort IS NOT INITIAL.
          APPEND wa_final TO it_final.
          CLEAR:wa_final.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  LOOP AT it_mslb INTO wa_mslb.
    wa_final-matnr = wa_mslb-matnr.
    wa_final-werks = wa_mslb-werks.
    wa_final-kulab = wa_mslb-lblab.
    wa_final-total = wa_mslb-lblab.
    wa_final-sobkz = wa_mslb-sobkz.
    wa_final-kunnr = wa_mslb-lifnr.

    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_final-matnr bwkey = wa_final-werks.
    IF sy-subrc = 0.
      IF wa_mbew-vprsv = 'V'.
        wa_final-lv_con = wa_mbew-verpr * wa_final-kulab.
      ELSEIF wa_mbew-vprsv = 'S'.
        wa_final-lv_con = wa_mbew-stprs * wa_final-kulab.
      ENDIF.
    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_final-matnr.
    IF sy-subrc = 0.
      wa_final-wrkst       = wa_mara-wrkst   .
      wa_final-zseries     = wa_mara-zseries .
      wa_final-zsize       = wa_mara-zsize   .
      wa_final-brand       = wa_mara-brand   .
      wa_final-moc         = wa_mara-moc     .
      wa_final-type        = wa_mara-type    .
      wa_final-meins       = wa_mara-meins   .
    ENDIF.

    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_final-matnr.
    IF  sy-subrc = 0.
      wa_final-lgort = wa_mard-lgort.
    ENDIF.

    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = wa_final-werks.
    IF  sy-subrc = 0.
      wa_final-name1 = ls_t001w-name1.
    ENDIF.

    READ TABLE lt_t001l INTO ls_t001l WITH KEY lgort = wa_final-lgort.
    IF  sy-subrc = 0.
      wa_final-lgobe = ls_t001l-lgobe.
    ENDIF.

    READ TABLE it_t001 INTO wa_t001 INDEX 1.
    IF sy-subrc = 0.
      wa_final-waers = wa_t001-waers.
    ENDIF.

    READ TABLE it_mssa INTO wa_mssa WITH KEY matnr = wa_final-matnr werks = wa_final-werks.
    IF sy-subrc = 0.
      wa_final-kzbws = wa_mssa-kzbws.
    ENDIF.

    READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_final-matnr werks = wa_final-werks.
    IF sy-subrc = 0.
      wa_final-mtart = wa_mara_mard-mtart.
      wa_final-matkl = wa_mara_mard-matkl.
      wa_final-lgort = wa_mara_mard-lgort.
    ENDIF.

    CLEAR: lv_lines, ls_mattxt.
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

    REPLACE ALL OCCURRENCES OF '<(>' IN wa_final-mattxt WITH space.
    REPLACE ALL OCCURRENCES OF '<)>' IN wa_final-mattxt WITH space.
    CONDENSE  wa_final-mattxt.

*     READ TABLE it_trans INTO wa_trans WITH KEY  matnr = wa_final-matnr.
*    IF  sy-subrc = 0.
*      wa_final-menge = wa_trans-fkimg.
*    ENDIF.

    IF wa_final-lgort IS NOT INITIAL.
      APPEND wa_final TO it_final.
      CLEAR wa_final.
    ENDIF.
  ENDLOOP.

  SORT it_mard BY matnr.
  DELETE ADJACENT DUPLICATES FROM it_mard COMPARING matnr.
  IF s_lgort IS INITIAL.
  LOOP AT it_mard INTO wa_mard.

    wa_final-matnr = wa_mard-matnr.
    READ TABLE it_trans INTO wa_trans WITH KEY  matnr = wa_final-matnr.
    IF  sy-subrc = 0.
      wa_final-menge = wa_trans-fkimg.

      wa_final-werks = wa_mard-werks.

      READ TABLE it_trans INTO wa_trans WITH KEY  matnr = wa_final-matnr.
      IF  sy-subrc = 0.
        wa_final-menge = wa_trans-fkimg.
      ENDIF.

      READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_final-matnr.
      IF sy-subrc = 0.
        wa_final-wrkst       = wa_mara-wrkst   .
        wa_final-zseries     = wa_mara-zseries .
        wa_final-zsize       = wa_mara-zsize   .
        wa_final-brand       = wa_mara-brand   .
        wa_final-moc         = wa_mara-moc     .
        wa_final-type        = wa_mara-type    .
        wa_final-meins       = wa_mara-meins   .
      ENDIF.

      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = wa_final-werks.
      IF  sy-subrc = 0.
        wa_final-name1 = ls_t001w-name1.
      ENDIF.

      READ TABLE it_t001 INTO wa_t001 INDEX 1.
      IF sy-subrc = 0.
        wa_final-waers = wa_t001-waers.
      ENDIF.

      READ TABLE it_mssa INTO wa_mssa WITH KEY matnr = wa_final-matnr werks = wa_final-werks.
      IF sy-subrc = 0.
        wa_final-kzbws = wa_mssa-kzbws.
      ENDIF.

      READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_final-matnr werks = wa_final-werks.
      IF sy-subrc = 0.
        wa_final-mtart = wa_mara_mard-mtart.
        wa_final-matkl = wa_mara_mard-matkl.
      ENDIF.

      CLEAR: lv_lines, ls_mattxt.
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

      REPLACE ALL OCCURRENCES OF '<(>' IN wa_final-mattxt WITH space.
      REPLACE ALL OCCURRENCES OF '<)>' IN wa_final-mattxt WITH space.
      IF wa_final-matnr NE ''.
        APPEND wa_final TO it_final.
      ENDIF.
      CLEAR:wa_final.
    ENDIF.
  ENDLOOP.
  ENDIF.

  DELETE it_final WHERE matnr EQ space.
  DELETE it_final WHERE KULAB EQ space and LABST eq space and KALAB eq space and INSME eq space and SPEME eq space and SOBKZ eq space and menge is INITIAL.
  SORT it_final BY matnr .
  CLEAR :wa_mseg,wa_mseg1, wa_final-menge ,wa_mard,wa_mara,wa_mska,wa_mbew,wa_vbap,wa_final.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS.

  IF  p_down = 'X'.
    LOOP AT it_final INTO wa_final.
      ls_final-matnr    = wa_final-matnr   .
      ls_final-mattxt   = wa_final-mattxt  .
      ls_final-wrkst    = wa_final-wrkst   .
      ls_final-brand    = wa_final-brand   .
      ls_final-zseries  = wa_final-zseries .
      ls_final-zsize    = wa_final-zsize   .
      ls_final-moc      = wa_final-moc     .
      ls_final-type     = wa_final-type    .
      ls_final-mtart    = wa_final-mtart   .
      ls_final-matkl    = wa_final-matkl   .
      ls_final-werks    = wa_final-werks   .
      ls_final-labst    = wa_final-labst   .
*      LS_FINAL-UMLME    = WA_FINAL-UMLME   .
      ls_final-insme    = wa_final-insme   .
      ls_final-kulab    = wa_final-kulab   .
      ls_final-kalab    = wa_final-kalab   .
      ls_final-speme    = wa_final-speme   .
      ls_final-retme    = wa_final-retme   .
      ls_final-total    = wa_final-total   .
      ls_final-menge    = wa_final-menge   .
      ls_final-ref      = wa_final-ref     .
      ls_final-salk3    = wa_final-salk3     .
      ls_final-lgort    = wa_final-lgort     .
      ls_final-lv_qas   = wa_final-lv_qas       .
      ls_final-lv_speme = wa_final-lv_speme     .
      ls_final-name1    = wa_final-name1        .
      ls_final-lgobe    = wa_final-lgobe        .
      ls_final-sobkz    = wa_final-sobkz        .
      ls_final-lvorm    = wa_final-lvorm        .
      ls_final-meins    = wa_final-meins        .
      ls_final-waers    = wa_final-waers        .
      ls_final-einme    = wa_final-einme        .
      ls_final-bwesb    = wa_final-bwesb        .
      ls_final-glgmg    = wa_final-glgmg        .
*      LS_FINAL-TRAME    = WA_FINAL-TRAME        .
      ls_final-umlmc    = wa_final-umlmc        .
      ls_final-kzbws    = wa_final-kzbws        .
      ls_final-sgt_scat = wa_final-sgt_scat     .
      ls_final-lv_rest  = wa_final-lv_rest      .
      ls_final-lv_rets  = wa_final-lv_rets      .
      ls_final-lv_gr    = wa_final-lv_gr        .
      ls_final-lv_tie   = wa_final-lv_tie       .
*      LS_FINAL-LV_TRA   = WA_FINAL-LV_TRA       .
      ls_final-lv_tfr   = wa_final-lv_tfr       .
      ls_final-kunnr    = wa_final-kunnr        .
      ls_final-vbeln    = wa_final-vbeln        .
      ls_final-posnr    = wa_final-posnr        .
      ls_final-lv_con   = wa_final-lv_con        .
      ls_final-lv_all   = wa_final-lv_all        .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = ls_final-ref.
      CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
     INTO ls_final-ref SEPARATED BY '-'.

      ls_final-ref_time = sy-uzeit.
      CONCATENATE ls_final-ref_time+0(2) ':' ls_final-ref_time+2(2)  INTO ls_final-ref_time.

      APPEND ls_final TO lt_final.
      CLEAR ls_final.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM det_fcat .
  PERFORM fcat USING :
                         '1'   'MATNR'         'IT_FINAL'  'Material.No.'                      '18' ,
                         '2'   'MATTXT'        'IT_FINAL'  'Material Desc'                     '18',
                         '3'   'MTART'         'IT_FINAL'  'Material Type'                     '18',
                         '4'   'WRKST'         'IT_FINAL'  'USA Code'                          '18' ,
                         '5'   'LGORT'         'IT_FINAL'  'Storage Location'                  '5',
                         '6'   'LABST'         'IT_FINAL'  'Unrestricted-Use Stock'            '5',
                         '7'   'SALK3'         'IT_FINAL'  'Unrestricted-Use Stock Value'      '5',
                         '8'   'KUNNR'         'IT_FINAL'  'Special Stock No.'                 '5',
                         '9'   'KULAB'         'IT_FINAL'  'Consignment Stock'                 '5',
                         '10'  'LV_CON'        'IT_FINAL'  'Value Consignment Stock'           '5',
                         '11'  'VBELN'         'IT_FINAL'  'Sales Order'                       '10',
                         '12'  'POSNR'         'IT_FINAL'  'Sales Order Line Item.'            '5',
                         '13'  'KALAB'         'IT_FINAL'  'SO Allocated Stock'                '10',
                         '14'  'LV_ALL'        'IT_FINAL'  'Value So Allocated Stock.'         '5',
                         '15'  'INSME'         'IT_FINAL'  'Stock in Quality Inspection'       '5',
                         '16'  'LV_QAS'        'IT_FINAL'  'Value In Quality Inspection'       '5',
                         '17'  'SPEME'         'IT_FINAL'  'Blocked Stock'                     '10',
                         '18'  'LV_SPEME'      'IT_FINAL'  'Value Blocked Stock'               '10',
                         '19'  'WERKS'         'IT_FINAL'  'Plant'                             '5',
                         '20'  'NAME1'         'IT_FINAL'  'Plant Description'                 '10',
                         '21'  'MATKL'         'IT_FINAL'  'Material Group'                    '5',
                         '22'  'LGOBE'         'IT_FINAL'  'Storage Location Description'      '10',
                         '23'  'SOBKZ'         'IT_FINAL'  'Special Stock'                     '10',
                         '24'  'LVORM'         'IT_FINAL'  'DF stor.loc.lvl'                   '15',
                         '25'  'MEINS'         'IT_FINAL'  'Base Unit of Measure'              '15',
                         '26'  'WAERS'         'IT_FINAL'  'Currency'                          '5',
                         '27'  'BRAND'         'IT_FINAL'  'Brand'                             '10',
                         '28'  'ZSERIES'       'IT_FINAL'  'Series'                            '10',
                         '29'  'ZSIZE'         'IT_FINAL'  'Size'                              '10',
                         '30'  'MOC'           'IT_FINAL'  'MOC'                               '10',
                         '31'  'TYPE'          'IT_FINAL'  'Type'                              '10',
                         '32'  'TOTAL'         'IT_FINAL'  'Total Stock'                       '10',
                         '33'  'EINME'         'IT_FINAL'  'Restricted-Use stock'              '5',
                         '34'  'LV_REST'       'IT_FINAL'  'Value Restricted'                  '5',
                         '35'  'RETME'         'IT_FINAL'  'Returns'                           '5',
                         '36'  'LV_RETS'       'IT_FINAL'  'Value Restricted Blocked'          '5',
                         '37'  'BWESB'         'IT_FINAL'  'Valueted GR Blocked Stock'         '5',
                         '38'  'LV_GR'         'IT_FINAL'  'Value GR Blocked St.'              '5',
                         '39'  'GLGMG'         'IT_FINAL'  'Tied Empties'                      '5',
                         '40'  'LV_TIE'        'IT_FINAL'  'Val. Tied Empties'                 '5',
                         '41'  'KZBWS'         'IT_FINAL'  'Special Stock Valuation'           '5',
                         '42'  'SGT_SCAT'      'IT_FINAL'  'Stock Segment'                     '5',
*                        '43'  'TRAME'         'IT_FINAL'  'Stock In Transit'                  '5',
*                        '44'  'LV_TRA'        'IT_FINAL'  'Value in Transit Block'            '5',
                         '45'  'UMLMC'         'IT_FINAL'  'Stock In Tranfer(Plant to Plant)'  '5',
                         '46'  'LV_TFR'        'IT_FINAL'  'Value in Stock Tfr'                '5',
                         '47'  'MENGE'         'IT_FINAL'  'In Transit Block'                  '5' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1435   text
*      -->P_1436   text
*      -->P_1437   text
*      -->P_1438   text
*      -->P_1439   text
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
*  wa_fcat-key       = .
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
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND = 'USER_CMD'
      i_callback_top_of_page = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = wa_layout
      it_fieldcat            = it_fcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
      it_sort                = t_sort[]
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
      i_save                 = 'X'
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER =
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

  ENDIF.
ENDFORM.

FORM top-of-page.
*ALV HEADER DECLARATIONS
  DATA: lt_header     TYPE slis_t_listheader,
        ls_header     TYPE slis_listheader,
        lt_line       LIKE ls_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

* TITLE
  ls_header-typ  = 'H'.
  ls_header-info = 'USA MB52 Report New'.
  APPEND ls_header TO lt_header.
  CLEAR ls_header.

* DATE
  ls_header-typ  = 'S'.
  ls_header-key  = 'RUN DATE :'.
  CONCATENATE ls_header-info sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum(4) INTO ls_header-info.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header.

*TIME
  ls_header-typ  = 'S'.
  ls_header-key  = 'RUN TIME :'.
  CONCATENATE ls_header-info sy-timlo(2) '.' sy-timlo+2(2) '.' sy-timlo+4(2) INTO ls_header-info.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.
  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' ld_linesc
     INTO lt_line SEPARATED BY space.


  ls_header-typ  = 'A'.
  ls_header-info = lt_line.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header, lt_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
ENDFORM.                    " TOP-OF-PAGE
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
    EXPORTING
*     I_FIELD_SEPERATOR    =
*     I_LINE_HEADER        =
      i_filename           = 'DAT'
*     I_APPL_KEEP          = ' '
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


  lv_file = 'ZUS_MB52.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_MB52 REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1982 TYPE string.
DATA lv_crlf_1982 TYPE string.
lv_crlf_1982 = cl_abap_char_utilities=>cr_lf.
lv_string_1982 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1982 lv_crlf_1982 wa_csv INTO lv_string_1982.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_2199 TO lv_fullfile.
*TRANSFER lv_string_2199 TO lv_fullfile.
TRANSFER lv_string_1982 TO lv_fullfile.
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


  lv_file = 'ZUS_MB52.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_MB52 REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_2019 TYPE string.
DATA lv_crlf_2019 TYPE string.
lv_crlf_2019 = cl_abap_char_utilities=>cr_lf.
lv_string_2019 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_2019 lv_crlf_2019 wa_csv INTO lv_string_2019.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_2199 TO lv_fullfile.
*TRANSFER lv_string_2199 TO lv_fullfile.
TRANSFER lv_string_2019 TO lv_fullfile.
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
  CONCATENATE  'Material.No.'
               'Material Desc'
               'Material Type'
               'USA Code'
               'Storage Location'
               'Unrestricted-Use Stock'
               'Unrestricted-Use Stock Value'
               'Special Stock No.'
               'Consignment Stock'
               'Value Consignment Stock'
               'Sales Order'
               'Sales Order Line Item.'
               'SO Allocated Stock'
               'Value So Allocated Stock.'
               'Stock in Quality Inspection'
               'Value In Quality Inspection'
               'Blocked Stock'
               'Value Blocked Stock'
               'Plant'
               'Plant Description'
               'Material Group'
               'Storage Location Description'
               'Special Stock'
               'DF stor.loc.lvl'
               'Base Unit of Measure'
               'Currency'
               'Brand'
               'Series'
               'Size'
               'MOC'
               'Type'
               'Total Stock '
               'Restricted-Use stock'
               'Value Restricted'
               'Returns'
               'Value Restricted Blocked'
               'Valueted GR Blocked Stock'
               'Value GR Blocked St.'
               'Tied Empties'
               'Val. Tied Empties'
               'Special Stock Valuation'
               'Stock Segment'
*              'Stock In Transit'
*               'Value in Transit'
               'Stock In Tranfer(Plant to Plant)'
               'Value in Stock Tfr'
               'In Transit Block'
               'Ref Date'
               'Ref Time'

                INTO pd_csv
                SEPARATED BY l_field_seperator.


ENDFORM.

*INCLUDE zus_mb52_new_1_get_transitf01.
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
    fksto
    FROM vbrk INTO TABLE it_vbrk1
    WHERE kunag = '0000300000'
      AND fksto NE 'X'
      AND fkart NE 'ZS1'  AND fkart NE 'ZF5'
      AND logsys NE ' '.

  IF it_vbrk1 IS NOT INITIAL.
    SELECT a~vbeln
             a~posnr
             a~fkimg
             vgbel
             a~vgpos
             a~aubel
             a~aupos
             a~matnr
             a~werks
             b~vkorg
             b~bstnk
             b~kunnr
         INTO TABLE it_vbrp_vapma
            FROM vbrp AS a
            JOIN vapma AS b
            ON ( b~vbeln = a~aubel
            AND b~posnr = a~aupos
            AND a~matnr = b~matnr )
           FOR ALL ENTRIES IN it_vbrk1
           WHERE a~vbeln  = it_vbrk1-vbeln
           AND b~kunnr = '0000300000'.

    SELECT knumv
           kposn
           kschl
           kbetr
           kwert FROM prcd_elements INTO TABLE it_konv
           FOR ALL ENTRIES IN it_vbrk1
           WHERE knumv = it_vbrk1-knumv
           AND kschl = 'ZPR0'.


    SELECT exnum
           iever FROM eikp INTO TABLE it_eikp
           FOR ALL ENTRIES IN it_vbrk1
           WHERE exnum = it_vbrk1-exnum.

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
  ENDIF.

  SELECT expvz
        bezei
        zdays FROM ztransit INTO TABLE it_mode
        FOR ALL ENTRIES IN it_eikp
        WHERE expvz = it_eikp-iever.

  IF it_vbrp_vapma IS NOT INITIAL.
    SELECT vbeln
       verur
       trspg
       FROM likp
       INTO TABLE it_likp1
       FOR ALL ENTRIES IN it_vbrp_vapma
       WHERE verur = it_vbrp_vapma-vgbel.
    SORT it_likp1 DESCENDING BY vbeln.

    SELECT mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im
           menge
     FROM mseg
     INTO TABLE it_mseg_new11
     FOR ALL ENTRIES IN it_vbrp_vapma
     WHERE xblnr_mkpf = it_vbrp_vapma-vgbel+(16)
     AND bwart EQ '103'.

    SELECT mblnr
         mjahr
         bwart
         matnr
         werks
         smbln
         xblnr_mkpf
         vbeln_im
         vbelp_im
   FROM mseg
   INTO TABLE it_mseg3
   FOR ALL ENTRIES IN it_vbrp_vapma
   WHERE xblnr_mkpf = it_vbrp_vapma-vgbel+(16)
   AND bwart EQ '105'.

  ENDIF.

  IF it_vbrp_vapma IS NOT INITIAL.
    SELECT vbeln
           posnr
           matnr
           kwmeng
           posex FROM vbap INTO TABLE lt_vbap
            FOR ALL ENTRIES IN it_vbrp_vapma
           WHERE vbeln = it_vbrp_vapma-aubel
             AND posnr = it_vbrp_vapma-aupos.

    SELECT ebeln
           ebelp
           werks
           menge
           matnr FROM ekpo INTO TABLE it_ekpo
    FOR ALL ENTRIES IN it_vbrp_vapma
         WHERE ebeln = it_vbrp_vapma-bstnk+0(10).
  ENDIF.

  IF it_mseg_new11 IS NOT INITIAL.

    SELECT belnr
           blart
           xblnr
           stblg FROM bkpf INTO TABLE it_bkpf
           FOR ALL ENTRIES IN it_mseg_new11
           WHERE xblnr = it_mseg_new11-mblnr
             AND blart = 'TR'.

    SELECT mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im FROM mseg INTO TABLE it_mseg_new
           FOR ALL ENTRIES IN it_mseg_new11
           WHERE smbln = it_mseg_new11-mblnr+0(10).

  ENDIF.

  IF it_bkpf IS NOT INITIAL.

    SELECT belnr
           blart
           xblnr
           stblg FROM bkpf INTO TABLE it_bkpf1
           FOR ALL ENTRIES IN it_bkpf
           WHERE stblg = it_bkpf-belnr
            AND bukrs = 'US00'. "added by jyoti on 23.07.2024

  ENDIF.

  LOOP AT it_vbrp_vapma INTO wa_vbrp_vapma WHERE vgbel NE space.
    wa_transit-inv_no   = wa_vbrp_vapma-vbeln.
    wa_transit-inv_line = wa_vbrp_vapma-posnr.
    wa_transit-fkimg    = wa_vbrp_vapma-fkimg.

    READ TABLE it_likp1 INTO wa_likp1 WITH KEY verur = wa_vbrp_vapma-vgbel.
    IF sy-subrc = 0.
      wa_transit-vbeln_im = wa_likp1-vbeln.
    ENDIF.

    READ TABLE it_vbrk1 INTO wa_vbrk1 WITH KEY vbeln = wa_vbrp_vapma-vbeln."wa_vbrp-vbeln.
    IF sy-subrc = 0.
      wa_transit-fkdat = wa_vbrk1-fkdat.
      wa_transit-xblnr = wa_vbrk1-xblnr.
    ENDIF.

    READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk1-knumv kposn = wa_vbrp_vapma-posnr. "wa_vbrp-posnr.
    IF sy-subrc = 0.
      wa_transit-kbetr = wa_konv-kbetr.
      wa_transit-kwert = wa_konv-kwert.
    ENDIF.
    wa_transit-vbeln = wa_vbrp_vapma-aubel.
    wa_transit-posnr = wa_vbrp_vapma-aupos.

    READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = wa_vbrp_vapma-aubel posnr = wa_vbrp_vapma-aupos. "vbeln = wa_vapma-vbeln posnr = wa_vapma-posnr.
    IF sy-subrc = 0.
      wa_transit-kwmeng = ls_vbap-kwmeng.
    ENDIF.

    READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_vbrp_vapma-bstnk  matnr = wa_vbrp_vapma-matnr ebelp = ls_vbap-posex."ebeln = wa_vapma-bstnk  matnr = wa_vapma-matnr ebelp = ls_vbap-posex.
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

    READ TABLE it_eikp INTO wa_eikp WITH KEY exnum = wa_vbrk1-exnum.
    IF sy-subrc = 0.
    ENDIF.
    READ TABLE it_t618t INTO wa_t618t WITH KEY expvz = wa_eikp-iever.
    IF sy-subrc = 0.
      wa_transit-bezei = wa_t618t-bezei.
    ENDIF.

    READ TABLE it_mseg_new11 INTO wa_mseg_new11 WITH KEY xblnr_mkpf = wa_vbrp_vapma-vgbel."
    IF sy-subrc = 0.
      READ TABLE it_mseg_new INTO wa_mseg_new WITH KEY smbln = wa_mseg_new11-mblnr.
      IF sy-subrc = 4.
        wa_transit-mblnr = wa_mseg_new11-mblnr.
      ENDIF.
    ENDIF.

    LOOP AT it_bkpf INTO wa_bkpf WHERE xblnr = wa_mseg-mblnr.
      READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
      IF sy-subrc = 4.
        wa_transit-belnr = wa_bkpf-belnr.
      ENDIF.
    ENDLOOP.

    READ TABLE it_mseg3  INTO wa_mseg3 WITH KEY xblnr_mkpf = wa_vbrp_vapma-vgbel.
    IF sy-subrc = 4.
      IF wa_likp1-trspg NE '03'.
        APPEND wa_transit TO it_transit.
      ENDIF.
    ENDIF.

    CLEAR:wa_transit,wa_mseg,wa_rev,wa_bkpf,wa_mseg1,wa_eikp,wa_mode,wa_vbrk1,wa_t618t,wa_mara,wa_ekpo,wa_mseg2,wa_mseg_new11,
        ls_vbap,wa_konv,wa_mseg1,wa_rev.
  ENDLOOP.

  DELETE it_transit WHERE ebeln  = ' '.
  DELETE it_transit WHERE vbeln_im  = ' '."COMMENT FOR TESTING PURPOSE 19.02.2024

  SELECT matnr
        werks FROM marc INTO TABLE it_marc
        FOR ALL ENTRIES IN it_transit
        WHERE matnr = it_transit-matnr
          AND werks = it_transit-werks.

  LOOP AT it_marc INTO wa_marc.
    wa_trans-matnr = wa_marc-matnr.
    wa_trans-werks = wa_marc-werks.
    LOOP AT it_transit INTO wa_transit WHERE matnr = wa_marc-matnr.
      wa_trans-fkimg = wa_trans-fkimg + wa_transit-fkimg.
    ENDLOOP.
    APPEND wa_trans TO it_trans.
    CLEAR wa_trans.
  ENDLOOP.
ENDFORM.
