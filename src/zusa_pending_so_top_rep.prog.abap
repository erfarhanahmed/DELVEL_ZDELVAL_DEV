*&---------------------------------------------------------------------*
*&  Include           ZUS_SD_PEND_SO_TOP
*&---------------------------------------------------------------------*


TABLES: vbrp,vbak,vbap.
TYPES: BEGIN OF ty_data,
         vbeln TYPE vbeln,
         posnr TYPE posnr,

       END OF ty_data.

TYPES:BEGIN OF ty_vbap,
      vbeln       TYPE vbap-vbeln,
      posnr       TYPE vbap-posnr,
      matnr       TYPE vbap-matnr,
      abgru       TYPE vbap-abgru,
      KDMAT       TYPE vbap-KDMAT,
      ARKTX       TYPE vbap-ARKTX,
      WAERK       TYPE vbap-WAERK,
      KWMENG      TYPE vbap-KWMENG,
      WERKS       TYPE vbap-WERKS,
      OBJNR       TYPE vbap-OBJNR,

      HOLDDATE    TYPE vbap-HOLDDATE,
      HOLDRELDATE TYPE vbap-HOLDRELDATE,
      CANCELDATE  TYPE vbap-CANCELDATE,
      DELDATE     TYPE vbap-DELDATE,
      CUSTDELDATE TYPE vbap-CUSTDELDATE,
      ernam       TYPE vbap-ernam,          """Added in Pranit 28.03.2024
      erdat       TYPE vbap-erdat,          """Added in Pranit 28.03.2024
      END OF ty_vbap,

      BEGIN OF ty_vbak,
      vbeln       TYPE vbak-vbeln,
      ERDAT       TYPE vbak-ERDAT,
      AUART       TYPE vbak-AUART,
      WAERK       TYPE vbak-WAERK,
      VKBUR       TYPE vbak-VKBUR,"23
      KNUMV       TYPE vbak-KNUMV,"28
      VDATU       TYPE vbak-VDATU,"29
      BSTDK       TYPE VBAK-BSTDK,
      BNAME       TYPE vbak-BNAME,"44
      KUNNR       TYPE vbak-KUNNR,"48
      ZLDFROMDATE TYPE vbak-ZLDFROMDATE,
      ZLDPERWEEK  TYPE vbak-ZLDPERWEEK,
      ZLDMAX      TYPE vbak-ZLDMAX,
      END OF ty_vbak.

TYPES:BEGIN OF ty_vbpa,
      vbeln TYPE vbpa-vbeln,
      kunnr TYPE vbpa-kunnr,
      parvw TYPE vbpa-parvw,
      END OF ty_vbpa,

      BEGIN OF ty_kna1,
      kunnr TYPE kna1-kunnr,
      name1 TYPE kna1-name1,
      adrnr TYPE kna1-adrnr,
      brsch TYPE kna1-brsch,
      END OF ty_kna1,

      BEGIN OF ty_ship,
      kunnr TYPE kna1-kunnr,
      name1 TYPE kna1-name1,
      STRAS TYPE kna1-STRAS,
      PSTLZ TYPE kna1-PSTLZ,
      ORT01 TYPE kna1-ORT01,
      REGIO TYPE kna1-REGIO,
      LAND1 TYPE kna1-LAND1,
      END OF ty_ship,

      BEGIN OF ty_t005u,
      spras TYPE t005u-spras,
      land1 TYPE t005u-land1,
      bland TYPE t005u-bland,
      bezei TYPE t005u-bezei,
      END OF ty_t005u,

      BEGIN OF ty_t005t,
      spras TYPE t005t-spras,
      land1 TYPE t005t-land1,
      landx TYPE t005t-landx,
      END OF ty_t005t,

      BEGIN OF ty_knvv,
      kunnr TYPE knvv-kunnr,
      kdgrp TYPE knvv-kdgrp,
      bzirk TYPE knvv-bzirk,
      vkbur TYPE knvv-vkbur,
      END OF ty_knvv,

      BEGIN OF ty_t151t,
      spras TYPE t151t-spras,
      kdgrp TYPE t151t-kdgrp,
      ktext TYPE t151t-ktext,
      END OF ty_t151t,

      BEGIN OF ty_t016t,
      spras TYPE t016t-spras,
      brsch TYPE t016t-brsch,
      brtxt TYPE t016t-brtxt,
      END OF ty_t016t,

        BEGIN OF ty_vbep,
        VBELN  TYPE vbep-VBELN,
        POSNR  TYPE vbep-POSNR,
        ETENR  TYPE vbep-ETENR,
        ETTYP  TYPE vbep-ETTYP,
        EDATU  TYPE vbep-EDATU,
        END OF ty_vbep,


        BEGIN OF ty_vbkd,
        VBELN  TYPE vbkd-VBELN,
        INCO1  TYPE vbkd-INCO1,
        INCO2  TYPE vbkd-INCO2,
        ZTERM  TYPE vbkd-ZTERM,
        KURSK  TYPE vbkd-KURSK,
        BSTKD  TYPE vbkd-BSTKD,
        END OF ty_vbkd,

        BEGIN OF ty_t052u,
        SPRAS  TYPE t052u-SPRAS,
        ZTERM  TYPE t052u-ZTERM,
        TEXT1  TYPE t052u-TEXT1,
        END OF ty_t052u,

        BEGIN OF ty_mska,
        MATNR TYPE mska-MATNR,
        WERKS TYPE mska-WERKS,
        LGORT TYPE mska-LGORT,
        VBELN TYPE mska-VBELN,
        POSNR TYPE mska-POSNR,
        KALAB TYPE mska-KALAB,
        KAINS TYPE mska-KAINS,
        END OF ty_mska,

        BEGIN OF ty_konv,
        KNUMV TYPE prcd_elements-KNUMV,
        KPOSN TYPE prcd_elements-KPOSN,
        KSCHL TYPE prcd_elements-KSCHL,
        KBETR TYPE prcd_elements-KBETR,
        WAERS TYPE prcd_elements-WAERS,
        KINAK TYPE prcd_elements-KINAK,
        kgrpe TYPE prcd_elements-kgrpe,
        END OF ty_konv,

        BEGIN OF ty_vbfa,
        VBELV    TYPE vbfa-VBELV  ,
        POSNV    TYPE vbfa-POSNV  ,
        VBELN    TYPE vbfa-VBELN  ,
        VBTYP_N  TYPE vbfa-VBTYP_N,
        END OF ty_vbfa,

        BEGIN OF ty_vbrk,
        VBELN TYPE vbrk-VBELN,
        FKART TYPE vbrk-FKART,
        FKTYP TYPE vbrk-FKTYP,
        VKORG TYPE vbrk-VKORG,
        VTWEG TYPE vbrk-VTWEG,
        FKDAT TYPE vbrk-FKDAT,
        FKSTO TYPE vbrk-FKSTO,
        END OF ty_vbrk,

        BEGIN OF ty_vbrp,
        VBELN  TYPE vbrp-VBELN,
        POSNR  TYPE vbrp-POSNR,
        FKIMG  TYPE vbrp-FKIMG,
        AUBEL  TYPE vbrp-AUBEL,
        AUPOS  TYPE vbrp-AUPOS,
        MATNR  TYPE vbrp-MATNR,
        WERKS  TYPE vbrp-WERKS,
        END OF ty_vbrp.





TYPES : BEGIN OF output,
          werks       TYPE werks_ext,
          auart       TYPE vbak-auart,
          bstkd       TYPE vbkd-bstkd,
          BSTDK       TYPE VBAK-BSTDK,
          kunnr       TYPE kna1-kunnr,
          name1       TYPE kna1-name1,
          partner     TYPE kna1-kunnr,
          part_name   TYPE kna1-name1,
          kdgrp       TYPE knvv-kdgrp,
          ktext       TYPE char25,
          brsch       TYPE kna1-brsch,
          brtxt       TYPE char25,
          vkbur       TYPE vbak-vkbur,
          vbeln       TYPE vbak-vbeln,
          erdat       TYPE vbak-erdat,
          vdatu       TYPE vbak-vdatu,
          status      TYPE text30,
          holddate    TYPE vbap-holddate,
          reldate     TYPE vbap-holdreldate,
          canceldate  TYPE vbap-canceldate,
          deldate     TYPE vbap-deldate,
          tpi         TYPE char100,
          tag_req     TYPE char100,
          ld_txt      TYPE char100,
          matnr       TYPE vbap-matnr,
          wrkst       TYPE mara-wrkst,
          bklas       TYPE mbew-bklas,
          posnr       TYPE vbap-posnr,
          arktx       TYPE vbap-arktx,
          mattxt      TYPE text100,
          kwmeng      TYPE vbap-kwmeng,
          lfimg       TYPE lips-lfimg,
          fkimg       TYPE vbrp-fkimg,
          pnd_qty     LIKE vbrp-fkimg,
          ettyp       TYPE vbep-ettyp,
          mrp_dt      TYPE udate,
          edatu       TYPE vbep-edatu,
          kbetr       TYPE prcd_elements-kbetr,
          waerk       TYPE vbap-waerk,
          amont       TYPE kbetr,
          ordr_amt    TYPE kbetr,
          st_cost     TYPE mbew-stprs,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          brand       TYPE mara-brand,
          moc         TYPE mara-moc,
          type        TYPE mara-type,
          dispo       TYPE marc-dispo,
          mtart       TYPE mara-mtart,
          etenr       TYPE vbep-etenr,
          schid(25),
          zterm       TYPE vbkd-zterm,
          text1       TYPE t052u-text1,
          inco1       TYPE vbkd-inco1,
          inco2       TYPE vbkd-inco2,
          CUSTDELDATE    TYPE vbap-CUSTDELDATE,
          bname       TYPE vbak-bname,
          eccn        TYPE char100,
          ABGRU       TYPE vbap-ABGRU,
          BEZEI       TYPE TVAGT-BEZEI,
          ref_dt      TYPE sy-datum,
          ship_name   TYPE kna1-name1,
          stras       TYPE kna1-stras,
          pstlz       TYPE kna1-pstlz,
          ort01       TYPE kna1-ort01,
          ship_rig    TYPE char20,
          ship_land   TYPE char20,
          rej_dt      TYPE udate,
          rej_nm      TYPE char20,
          ship_code   TYPE char20,
          UHF1        TYPE prcd_elements-KBETR,
          USC1        TYPE prcd_elements-KBETR,
          UMC1        TYPE prcd_elements-KBETR,
          HUHF1       TYPE prcd_elements-KBETR,
          HUSC1       TYPE prcd_elements-KBETR,
          HUMC1       TYPE prcd_elements-KBETR,
          spl_ins     TYPE char250,
          ernam       TYPE vbap-ernam,        """Added in Pranit 28.03.2024
          erdat1      TYPE vbap-erdat,        """Added in Pranit 28.03.2024
*
*          zldperweek  TYPE zldperweek1,
*          zldmax      TYPE vbak-zldmax,
*          zldfromdate TYPE vbak-zldfromdate,
*          stock_qty   TYPE mska-kalab,
*          curr_con    TYPE ukursp,
*          in_price    TYPE konv-kbetr,
*          in_pr_dt    TYPE konv-kdatu,
*          est_cost    TYPE konv-kbetr,
*          latst_cost  TYPE konv-kbetr,
*          wip         TYPE i,
*          kdmat       TYPE vbap-kdmat,
*          qmqty       TYPE mska-kains,
*          itmtxt      TYPE text100,
*          so_exc      TYPE ukursp,
*          ofm         TYPE char50,
*          ofm_date    TYPE char50,
*          spl         TYPE string,
*          desc        TYPE char250,
*          sale_off    TYPE knvv-vkbur,
*          bzirk       TYPE knvv-bzirk,


          """"""""""""""""""""""""""""""""""""""""""""
        END OF output.

TYPES : BEGIN OF TY_TVAGT,
  SPRAS  TYPE  TVAGT-SPRAS,
  ABGRU TYPE  TVAGT-ABGRU,
  BEZEI  TYPE  TVAGT-BEZEI,
  END OF TY_TVAGT.

  DATA : IT_TVAGT TYPE STANDARD TABLE OF TY_TVAGT,
          WA_TVAGT TYPE TY_TVAGT.






""""""""""    Added By KD 04.05.2017        """""""""""
TYPES : BEGIN OF ty_afpo,
          aufnr TYPE afpo-aufnr,
          posnr TYPE afpo-posnr,
          kdauf TYPE afpo-kdauf,
          kdpos TYPE afpo-kdpos,
          matnr TYPE afpo-matnr,
          pgmng TYPE afpo-pgmng,
          psmng TYPE afpo-psmng,
          wemng TYPE afpo-wemng,
        END OF ty_afpo.

TYPES : BEGIN OF ty_caufv,
          aufnr TYPE caufv-aufnr,
          objnr TYPE caufv-objnr,
          kdauf TYPE caufv-kdauf,
          kdpos TYPE caufv-kdpos,
          igmng TYPE caufv-igmng,
        END OF ty_caufv .

TYPES : BEGIN OF ty_jest,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
        END OF ty_jest.

TYPES : BEGIN OF ty_tj02t,
          istat TYPE tj02t-istat,
          txt04 TYPE tj02t-txt04,
        END OF ty_tj02t.

TYPES : BEGIN OF ty_mast,
          matnr TYPE mast-matnr,
          werks TYPE mast-werks,
          stlan TYPE mast-stlan,
          stlnr TYPE mast-stlnr,
          stlal TYPE mast-stlal,
        END OF ty_mast.

TYPES : BEGIN OF ty_stko,
          stlty TYPE stko-stlty,
          stlnr TYPE stko-stlnr,
          stlal TYPE stko-stlal,
          stkoz TYPE stko-stkoz,
        END OF ty_stko.

TYPES : BEGIN OF ty_stpo,
          stlty TYPE stpo-stlty,
          stlnr TYPE stpo-stlnr,
          stlkn TYPE stpo-stlkn,
          stpoz TYPE stpo-stpoz,
          idnrk TYPE stpo-idnrk,
        END OF ty_stpo.

TYPES:
  BEGIN OF t_resb,
    rsnum TYPE resb-rsnum,
    rspos TYPE resb-rspos,
    rsart TYPE resb-rsart,
    bdmng TYPE resb-bdmng,
    enmng TYPE resb-enmng,
    aufnr TYPE resb-aufnr,
    kdauf TYPE resb-kdauf,
    kdpos TYPE resb-kdpos,
  END OF t_resb,
  tt_resb TYPE STANDARD TABLE OF t_resb.


TYPES:
  BEGIN OF t_final,
    werks       TYPE werks_ext,
    auart       TYPE vbak-auart,
    bstkd       TYPE vbkd-bstkd,
    BSTDK       TYPE char11,
    kunnr       TYPE kna1-kunnr,
    name1       TYPE kna1-name1,
    partner     TYPE kna1-kunnr,
    part_name   TYPE kna1-name1,
    kdgrp       TYPE knvv-kdgrp,
    ktext       TYPE char25,
    brsch       TYPE kna1-brsch,
    brtxt       TYPE char25,
    vkbur       TYPE vbak-vkbur,
    vbeln       TYPE vbak-vbeln,
    erdat       TYPE char11, "vbak-erdat,
    vdatu       TYPE char11, "vbak-vdatu,
    status      TYPE text30,
    holddate    TYPE char11, "vbap-holddate,
    reldate     TYPE char11, "vbap-holdreldate,
    canceldate  TYPE char11, "vbap-canceldate,
    deldate     TYPE char11, "vbap-deldate,
    tpi         TYPE char20,
    tag_req     TYPE char20,
    ld_txt      TYPE char20,
    matnr       TYPE vbap-matnr,
    wrkst       TYPE mara-wrkst,
    bklas       TYPE mbew-bklas,
    posnr       TYPE vbap-posnr,
    arktx       TYPE vbap-arktx,
    mattxt      TYPE char100,
    kwmeng      TYPE char15, "vbap-kwmeng,
    lfimg       TYPE char15, "lips-lfimg,
    fkimg       TYPE char15, "vbrp-fkimg,
    pnd_qty     TYPE char15, "vbrp-fkimg,
    ettyp       TYPE vbep-ettyp,
    mrp_dt      TYPE char11, "udate,
    edatu       TYPE char11, "vbep-edatu,
    kbetr       TYPE char15, "konv-kbetr,
    waerk       TYPE vbap-waerk,
    amont       TYPE char15, "kbetr,
    ordr_amt    TYPE char15, "kbetr,
    st_cost     TYPE char15, "mbew-stprs,
    zseries     TYPE mara-zseries,
    zsize       TYPE mara-zsize,
    brand       TYPE mara-brand,
    moc         TYPE mara-moc,
    type        TYPE mara-type,
    dispo       TYPE marc-dispo,
    mtart       TYPE mara-mtart,
    etenr       TYPE vbep-etenr,
    schid(25),
    zterm       TYPE vbkd-zterm,
    text1       TYPE char50,
    inco1       TYPE vbkd-inco1,
    inco2       TYPE char30,
    custdeldate TYPE char11, "vbap-deldate,
    bname       TYPE vbak-bname,
    eccn        TYPE char100,
    ABGRU       TYPE vbap-ABGRU,
    BEZEI       TYPE TVAGT-BEZEI,
    ref_dt      TYPE char11,
    ship_name   TYPE kna1-name1,
    stras       TYPE kna1-stras,
    pstlz       TYPE kna1-pstlz,
    ort01       TYPE kna1-ort01,
    ship_rig    TYPE char20,
    ship_land   TYPE char20,
    rej_dt      TYPE char11,
    rej_nm      TYPE char20,
    ship_code   TYPE char20,
    UHF1        TYPE CHAR20,
    USC1        TYPE CHAR20,
    UMC1        TYPE CHAR20,
    HUHF1       TYPE CHAR20,
    HUSC1       TYPE CHAR20,
    HUMC1       TYPE CHAR20,
    spl_ins     TYPE char250,
    ernam       TYPE char20,
    erdat1      TYPE char20,


  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.


TYPES : BEGIN OF t_jest,
        OBJNR TYPE jest-OBJNR,
        STAT  TYPE jest-STAT,
        INACT TYPE jest-INACT,
        CHGNR TYPE jest-CHGNR,
        END OF t_jest,

        BEGIN OF t_TJ30T,
        STSMA TYPE TJ30T-STSMA,
        ESTAT TYPE TJ30T-STSMA,
        SPRAS TYPE TJ30T-STSMA,
        TXT04 TYPE TJ30T-STSMA,
        TXT30 TYPE TJ30T-STSMA,
        LTEXT TYPE TJ30T-STSMA,
        END OF t_tj30t,

        BEGIN OF t_TVZBT,
        SPRAS TYPE TVZBT-SPRAS,
        ZTERM TYPE TVZBT-ZTERM,
        VTEXT TYPE TVZBT-VTEXT,
        END OF t_tvzbt,

        BEGIN OF ty_mbew,
        MATNR TYPE mbew-matnr,
        BWKEY TYPE mbew-BWKEY,
        STPRS TYPE mbew-STPRS,
        BKLAS TYPE mbew-BKLAS,
        END OF ty_mbew,

        BEGIN OF ty_mara,
        MATNR   TYPE mara-MATNR  ,
        MTART   TYPE mara-MTART  ,
        MATKL   TYPE mara-MATKL  ,
        WRKST   TYPE mara-WRKST  ,
        ZSERIES TYPE mara-ZSERIES,
        ZSIZE   TYPE mara-ZSIZE  ,
        BRAND   TYPE mara-BRAND  ,
        MOC     TYPE mara-MOC    ,
        TYPE    TYPE mara-TYPE   ,
        END OF ty_mara,

        BEGIN OF ty_marc,
        MATNR TYPE marc-MATNR,
        WERKS TYPE marc-WERKS,
        DISPO TYPE marc-DISPO,
        END OF ty_marc,

        BEGIN OF ty_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
        SPRAS TYPE makt-SPRAS,
        END OF ty_makt,

        BEGIN OF ty_cdpos,
        OBJECTCLAS TYPE CDPOS-OBJECTCLAS,
        OBJECTID   TYPE CDPOS-OBJECTID,
        CHANGENR   TYPE CDPOS-CHANGENR,
        TABNAME    TYPE CDPOS-TABNAME,
        TABKEY     TYPE CDPOS-TABKEY,
        FNAME      TYPE CDPOS-FNAME,
        CHNGIND    TYPE CDPOS-CHNGIND,
        VALUE_NEW  TYPE CDPOS-VALUE_NEW,
        END OF ty_cdpos.

DATA : it_afpo  TYPE TABLE OF ty_afpo,
       wa_afpo  TYPE ty_afpo,
       it_caufv TYPE TABLE OF ty_caufv,
       wa_caufv TYPE ty_caufv,
       it_jest2 TYPE TABLE OF ty_jest,
       wa_jest2 TYPE ty_jest,
       it_tj02t TYPE TABLE OF ty_tj02t,
       wa_tj02t TYPE ty_tj02t,
       it_mast  TYPE TABLE OF mast,
       wa_mast  TYPE mast,
       it_stko  TYPE TABLE OF ty_stko,
       wa_stko  TYPE ty_stko,
       it_stpo  TYPE TABLE OF ty_stpo,
       wa_stpo  TYPE ty_stpo.

"""""""""""""""    end   04.05.2017  """""""""""""""""""""""""""""
DATA:

      it_vbep        TYPE TABLE OF ty_vbep,
      wa_vbep        TYPE ty_vbep,
      lt_vbep        TYPE TABLE OF ty_vbep,
      ls_vbep        TYPE ty_vbep,
      lt_vbpa        TYPE TABLE OF ty_vbpa,
      ls_vbpa        TYPE ty_vbpa,

      it_vbkd        TYPE TABLE OF ty_vbkd,
      wa_vbkd        TYPE  ty_vbkd,
      it_t052u       TYPE TABLE OF ty_t052u,
      wa_t052u       TYPE  ty_t052u,
      it_mska        TYPE TABLE OF ty_mska,
      wa_mska        TYPE  ty_mska,
      it_konv        TYPE TABLE OF ty_konv,
      wa_konv        TYPE  ty_konv,
      it_konv1       TYPE TABLE OF ty_konv,
      wa_konv1       TYPE  ty_konv,
      it_vbfa        TYPE TABLE OF ty_vbfa,
      wa_vbfa        TYPE  ty_vbfa,
      it_vbrk        TYPE TABLE OF ty_vbrk,
      wa_vbrk        TYPE  ty_vbrk,
      it_vbrp        TYPE TABLE OF ty_vbrp,
      wa_vbrp        TYPE  ty_vbrp,
      it_kna1        TYPE TABLE OF ty_kna1,
      wa_kna1        TYPE  ty_kna1.

DATA: it_vbak      TYPE TABLE OF ty_vbak,
      wa_vbak      TYPE ty_vbak,

      it_vbap      TYPE TABLE OF ty_vbap,
      wa_vbap      TYPE          ty_vbap,

      it_tvzbt     TYPE TABLE OF t_tvzbt,
      wa_tvzbt     TYPE t_tvzbt,



      it_lips      TYPE STANDARD TABLE OF lips,
      wa_lips      TYPE lips,
      wa_lfimg     TYPE lips-lfimg,
      wa_lfimg_sum TYPE lips-lfimg,


      wa_fkimg     TYPE lips-lfimg,
      wa_fkimg_sum TYPE lips-lfimg,


      it_konh      TYPE STANDARD TABLE OF konh,
      wa_konh      TYPE konh,
      it_konp      TYPE STANDARD TABLE OF konp,
      wa_konp      TYPE konp,
      it_jest      TYPE TABLE OF t_jest,
      wa_jest1     TYPE t_jest,
      it_tj30t     TYPE TABLE OF t_tj30t,
      wa_tj30t     TYPE t_tj30t,
***      it_a508    TYPE STANDARD TABLE OF a508,
***      wa_a508    TYPE a508,
      it_cdhdr     TYPE STANDARD TABLE OF cdhdr,
      wa_cdhdr     TYPE cdhdr,
      it_cdpos     TYPE TABLE OF ty_cdpos,
      wa_cdpos     TYPE ty_cdpos,
      it_output    TYPE STANDARD TABLE OF output,
      wa_output    TYPE output,
      it_mbew      TYPE TABLE OF ty_mbew,
      wa_mbew      TYPE ty_mbew,
      lt_mara      TYPE TABLE OF ty_mara,
      wa_mara      TYPE ty_mara,
      it_marc      TYPE TABLE OF ty_marc,
      wa_marc      TYPE ty_marc,
      it_oauto     TYPE STANDARD TABLE OF output,
      wa_oauto     TYPE output,
      it_mara      TYPE TABLE OF ty_mara,
      it_makt      TYPE TABLE OF ty_makt,
      wa_makt      TYPE ty_makt,
      it_vbpa      TYPE TABLE OF ty_vbpa,
      wa_vbpa      TYPE ty_vbpa,
      it_partner   TYPE TABLE OF ty_kna1,
      wa_partner   TYPE ty_kna1,
      it_ship      TYPE TABLE OF ty_ship,
      wa_ship      TYPE ty_ship,
      it_t005u     TYPE TABLE OF ty_t005u,
      wa_t005u     TYPE ty_t005u,
      it_t005t     TYPE TABLE OF ty_t005t,
      wa_t005t     TYPE ty_t005t,
      it_knvv      TYPE TABLE OF ty_knvv,
      wa_knvv      TYPE          ty_knvv,
      it_t151t     TYPE TABLE OF ty_t151t,
      wa_t151t     TYPE          ty_t151t,
      it_t016t     TYPE TABLE OF ty_t016t,
      wa_t016t     TYPE          ty_t016t.


DATA:
  lt_resb TYPE tt_resb,
  ls_resb TYPE t_resb.
DATA:
   gt_final TYPE tt_final.
DATA: it_data   TYPE STANDARD TABLE OF ty_data,
      wa_data   TYPE ty_data,

      it_delete   TYPE STANDARD TABLE OF ty_data,
      wa_delete   TYPE ty_data,

      wa_data2  TYPE ty_data,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_lines  LIKE tline,
      wa_ln_ld  LIKE tline,
      wa_tag_rq LIKE tline,
      lv_name   TYPE thead-tdname,
      wa_text   TYPE char20.
DATA ls_mattxt  TYPE tline.
DATA ls_itmtxt  TYPE tline.
*data for bapi to convert currency

DATA: BEGIN OF ls_fr_curr OCCURS 0.
    INCLUDE STRUCTURE bapi1093_3.
DATA: END OF ls_fr_curr.

DATA: BEGIN OF ls_to_curr OCCURS 0.
    INCLUDE STRUCTURE bapi1093_4.
DATA: END OF ls_to_curr.

DATA: BEGIN OF ls_ex_rate OCCURS 0.
    INCLUDE STRUCTURE bapi1093_0.
DATA: END OF ls_ex_rate.

DATA: lv_ex_rate TYPE bapi1093_0.

DATA: BEGIN OF ls_return OCCURS 0.
    INCLUDE STRUCTURE bapiret1.
DATA: END OF ls_return.

ls_fr_curr-sign   = 'I'.
ls_fr_curr-option = 'EQ'.
*LV_FR_CURR-LOW = 'EQ'.

ls_to_curr-sign   = 'I'.
ls_to_curr-option = 'EQ'.
ls_to_curr-low = 'INR'.
APPEND ls_to_curr .


* ALV RELATED DATA
*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES AND CONSTANTS FOR ALV
*---------------------------------------------------------------------*
TYPE-POOLS : slis.
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      fieldlayout  TYPE slis_layout_alv,

      it_fcat      TYPE slis_t_fieldcat_alv,
      wa_fcat      TYPE LINE OF slis_t_fieldcat_alv. " SLIS_T_FIELDCAT_ALV.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
************************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname
                                   VALUE 'TOP_OF_PAGE',
  c_formname_pf_status_set TYPE slis_formname
                                 VALUE 'PF_STATUS_SET',
  c_s                      TYPE c VALUE 'S',
  c_h                      TYPE c VALUE 'H'.

INITIALIZATION.

  REFRESH : it_vbak, it_vbap, it_vbkd, it_mska,
         it_vbrp, it_vbep, it_konv.

  CLEAR  : wa_vbak, wa_vbap, wa_vbkd, wa_mska,
           wa_vbrp, wa_vbep, wa_konv.
