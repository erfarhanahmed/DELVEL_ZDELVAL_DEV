*&---------------------------------------------------------------------*
*&  Include           ZBOM_FIRST_LEVEL_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_data,
         vbeln TYPE vbeln,
         posnr TYPE posnr,
       END OF ty_data.

TYPES : BEGIN OF output,
          werks       TYPE werks_ext,
          auart       TYPE vbak-auart,
          bstkd       TYPE vbkd-bstkd,
          name1       TYPE kna1-name1,
          vkbur       TYPE vbak-vkbur,
          vbeln       TYPE vbak-vbeln,
          erdat       TYPE vbak-erdat,
          vdatu       TYPE vbak-vdatu,
          status      TYPE text30,
          holddate    TYPE vbap-holddate,
          reldate     TYPE vbap-holdreldate,
          canceldate  TYPE vbap-canceldate,
          deldate     TYPE vbap-deldate,
          tag_req     TYPE char20,
*         ld 5 fields
          tpi         TYPE char20,
          ld_txt      TYPE char20,
          zldperweek  TYPE zldperweek1,
          zldmax      TYPE vbak-zldmax,
          zldfromdate TYPE vbak-zldfromdate,

********
          matnr       TYPE vbap-matnr,
          posnr       TYPE vbap-posnr,
          arktx       TYPE vbap-arktx,
          kwmeng      TYPE vbap-kwmeng,
          stock_qty   TYPE mska-kalab,
*          kalab       TYPE mska-kalab,
          lfimg       TYPE lips-lfimg,
          fkimg       TYPE vbrp-fkimg,
          pnd_qty     LIKE vbrp-fkimg,
          ettyp       TYPE vbep-ettyp,
          mrp_dt      TYPE udate,
          edatu       TYPE vbep-edatu,
          kbetr       TYPE prcd_elements-kbetr,
          waerk       TYPE vbap-waerk,
          curr_con    TYPE ukursp,
          amont       TYPE kbetr,
          ordr_amt    TYPE kbetr,
*          KURSK         TYPE VBKD-KURSK,
          in_price    TYPE  prcd_elements-kbetr,
          in_pr_dt    TYPE  prcd_elements-kdatu,
          est_cost    TYPE  prcd_elements-kbetr,
          latst_cost  TYPE prcd_elements-kbetr,
          st_cost     TYPE mbew-stprs,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          brand       TYPE mara-brand,
          moc         TYPE mara-moc,
          type        TYPE mara-type,

          """"""""   Added By KD 04.05.2017    """""""
          dispo       TYPE marc-dispo,
          wip         TYPE i,
          mtart       TYPE mara-mtart,
          kdmat       TYPE vbap-kdmat,
          kunnr       TYPE kna1-kunnr,
          qmqty       TYPE mska-kains,
          mattxt      TYPE text100,
          itmtxt      TYPE text100,
          etenr       TYPE vbep-etenr,
          schid(25),
          so_exc      TYPE ukursp,
          zterm       TYPE vbkd-zterm,
          inco1       TYPE vbkd-inco1,
          inco2       TYPE vbkd-inco2,
          text1       TYPE t052u-text1,
          ofm         TYPE char50,
          ofm_date    TYPE char50,
          spl         TYPE string,
          ref_dt      TYPE sy-datum,
          """"""""""""""""""""""""""""""""""""""""""""
        END OF output.

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
    name1       TYPE kna1-name1,
    vkbur       TYPE vbak-vkbur,
    vbeln       TYPE vbak-vbeln,
    erdat       TYPE char11, "vbak-erdat,
    vdatu       TYPE char11, "vbak-vdatu,
    status      TYPE text30,
    holddate    TYPE char11, "vbap-holddate,
    reldate     TYPE char11, "vbap-holdreldate,
    canceldate  TYPE char11, "vbap-canceldate,
    deldate     TYPE char11, "vbap-deldate,
    tag_req     TYPE char20,
*         ld 5 fields
    tpi         TYPE char20,
    ld_txt      TYPE char20,
    zldperweek  TYPE zldperweek1,
    zldmax      TYPE vbak-zldmax,
    zldfromdate TYPE char11, "vbak-zldfromdate,

********
    matnr       TYPE vbap-matnr,
    posnr       TYPE vbap-posnr,
    arktx       TYPE vbap-arktx,
    kwmeng      TYPE char15, "vbap-kwmeng,
    kalab       TYPE mska-kalab,
*    stock_qty   TYPE mska-kalab,
    lfimg       TYPE char15, "lips-lfimg,
    fkimg       TYPE char15, "vbrp-fkimg,
    pnd_qty     TYPE char15, "vbrp-fkimg,
    ettyp       TYPE vbep-ettyp,
    mrp_dt      TYPE char11, "udate,
    edatu       TYPE char11, "vbep-edatu,
    kbetr       TYPE char15, "konv-kbetr,
    waerk       TYPE vbap-waerk,
    curr_con    TYPE ukursp,
    amont       TYPE char15, "kbetr,
    ordr_amt    TYPE char15, "kbetr,
*          KURSK         TYPE VBKD-KURSK,
    in_price    TYPE char15, "konv-kbetr,
    in_pr_dt    TYPE char11, "konv-kdatu,
    est_cost    TYPE char15, "konv-kbetr,
    latst_cost  TYPE char15, "konv-kbetr,
    st_cost     TYPE char15, "mbew-stprs,
    zseries     TYPE mara-zseries,
    zsize       TYPE mara-zsize,
    brand       TYPE mara-brand,
    moc         TYPE mara-moc,
    type        TYPE mara-type,

    """"""""   Added By KD 04.05.2017    """""""
    dispo       TYPE marc-dispo,
    wip         TYPE i,
    mtart       TYPE mara-mtart,
    kdmat       TYPE vbap-kdmat,
    kunnr       TYPE kna1-kunnr,
    qmqty       TYPE char15, "mska-kains,
    mattxt      TYPE char100,
    itmtxt      TYPE char100,
    etenr       TYPE vbep-etenr,
    schid(25),
    so_exc      TYPE ukursp,
    zterm       TYPE vbkd-zterm,
    inco1       TYPE vbkd-inco1,
    inco2       TYPE char30,
    text1       TYPE char50,
    ofm         TYPE char50,
    ofm_date    TYPE char50,
    spl         TYPE string,
    ref_dt      TYPE char11,
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.

TYPES : BEGIN OF ty_vbak,
        vbeln TYPE vbak-vbeln,
        ERDAT TYPE vbak-ERDAT,
        VKORG TYPE vbak-VKORG,
        KNUMV TYPE vbak-KNUMV,
        kunnr TYPE vbak-kunnr,
        END OF ty_vbak,

        BEGIN OF ty_vbap,
        vbeln TYPE vbap-vbeln,
        posnr TYPE vbap-posnr,
        matnr TYPE vbap-matnr,
        werks TYPE vbap-werks,
        END OF ty_vbap,

        BEGIN OF ty_vbup,
        vbeln TYPE vbup-vbeln,
        posnr TYPE vbup-posnr,
        lfsta TYPE vbup-lfsta,
        lfgsa TYPE vbup-lfgsa,
        fksta TYPE vbup-fksta,
        gbsta TYPE vbup-gbsta,
        UVFAK TYPE vbup-UVFAK,
        END OF ty_vbup.


DATA :it_vbak      TYPE TABLE OF ty_vbak,
      wa_vbak      TYPE ty_vbak,
      it_vbap      TYPE TABLE OF ty_vbap,
      wa_vbap      TYPE ty_vbap,
      it_vbup      TYPE TABLE OF ty_vbup,
      wa_vbup      TYPE ty_vbup.





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

*DATA: it_vbak      TYPE TABLE OF ty_vbak,
*      wa_vbak      TYPE ty_vbak,
*      it_vbap      TYPE TABLE OF ty_vbap,
*      wa_vbap      TYPE ty_vbap,
DATA: it_vbkd      TYPE STANDARD TABLE OF vbkd,
      wa_vbkd      TYPE vbkd,
      it_t052u     TYPE STANDARD TABLE OF t052u,
      wa_t052u     TYPE t052u,
      it_kna1      TYPE STANDARD TABLE OF  kna1,
      wa_kna1      TYPE kna1,
      it_mska      TYPE STANDARD TABLE OF mska,
      wa_mska      TYPE mska,
      it_vbfa      TYPE STANDARD TABLE OF vbfa,
      wa_vbfa      TYPE vbfa,
      it_lips      TYPE STANDARD TABLE OF lips,
      wa_lips      TYPE lips,
      wa_lfimg     TYPE lips-lfimg,
      wa_lfimg_sum TYPE lips-lfimg,
      it_vbrk      TYPE STANDARD TABLE OF vbrk,
      wa_vbrk      TYPE vbrk,
      it_vbrp      TYPE STANDARD TABLE OF vbrp,
      wa_vbrp      TYPE vbrp,
      wa_fkimg     TYPE lips-lfimg,
      wa_fkimg_sum TYPE lips-lfimg,
      it_vbep      TYPE STANDARD TABLE OF vbep,
      wa_vbep      TYPE vbep,
      lt_vbep      TYPE STANDARD TABLE OF vbep,
      ls_vbep      TYPE vbep,
      it_konv      TYPE STANDARD TABLE OF prcd_elements,
      wa_konv      TYPE prcd_elements,
      it_konh      TYPE STANDARD TABLE OF konh,
      wa_konh      TYPE konh,
      it_konp      TYPE STANDARD TABLE OF konp,
      wa_konp      TYPE konp,
      it_jest      TYPE STANDARD TABLE OF jest,
      wa_jest1     TYPE jest,
      it_tj30t     TYPE STANDARD TABLE OF tj30t,
      wa_tj30t     TYPE tj30t,
***      it_a508    TYPE STANDARD TABLE OF a508,
***      wa_a508    TYPE a508,
      it_cdhdr     TYPE STANDARD TABLE OF cdhdr,
      wa_cdhdr     TYPE cdhdr,
      it_cdpos     TYPE STANDARD TABLE OF cdpos,
      wa_cdpos     TYPE cdpos,
      it_output    TYPE STANDARD TABLE OF output,
      wa_output    TYPE output,
      wa_mbew      TYPE mbew,
      wa_mara      TYPE mara,
      it_oauto     TYPE STANDARD TABLE OF output,
      wa_oauto     TYPE output,
      it_mara      TYPE TABLE OF mara,
      it_makt      TYPE TABLE OF makt,
      wa_makt      TYPE makt.

DATA:
  lt_resb TYPE tt_resb,
  ls_resb TYPE t_resb.
DATA:
   gt_final TYPE tt_final.
DATA: it_data   TYPE STANDARD TABLE OF ty_data,
      wa_data   TYPE ty_data,
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
