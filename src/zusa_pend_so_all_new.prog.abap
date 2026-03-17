*&---------------------------------------------------------------------*
*& Report ZUSA_PEND_SO_new
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zusa_pend_so_all_new.



TABLES: vbrp,vbak,vbap.

TYPES: BEGIN OF ty_data,
         vbeln  TYPE vbeln,
         posnr  TYPE posnr,
         zbstkd TYPE zbstkd,
         zposex TYPE zposex,

       END OF ty_data.

TYPES : BEGIN OF ty_vbakp,
          vbeln    TYPE vbak-vbeln,
          posnr_i  TYPE vbap-posnr,
          erdat    TYPE vbak-erdat,
          ernam    TYPE vbak-ernam,
          audat    TYPE vbak-audat,
          vbtyp    TYPE vbak-vbtyp,
          auart    TYPE vbak-auart,
          netwr    TYPE vbak-netwr,
          waerk    TYPE vbak-waerk,
          vkorg    TYPE vbak-vkorg,
          vtweg    TYPE vbak-vtweg,
          vkbur    TYPE vbak-vkbur,
          knumv    TYPE vbak-knumv,
          vdatu    TYPE vbak-vdatu,
          bstnk    TYPE vbak-bstnk,
          bstdk    TYPE vbak-bstdk,
          bname    TYPE vbak-bname,
          kunnr    TYPE vbak-kunnr,
          vgbel    TYPE vbak-vgbel,
          objnr    TYPE vbak-objnr,
          matnr_i  TYPE vbap-matnr,
          matkl_i  TYPE vbap-matkl,
          arktx_i  TYPE vbap-arktx,
          abgru_i  TYPE vbap-abgru,
          kwmeng_i TYPE vbap-kwmeng,
          werks_i  TYPE vbap-werks,
        END OF ty_vbakp,

        BEGIN OF ty_vbap,
          vbeln          TYPE vbap-vbeln,
          posnr          TYPE vbap-posnr,
          matnr          TYPE vbap-matnr,
          holddate       TYPE vbap-holddate,
          holdreldate    TYPE vbap-holdreldate,
          canceldate     TYPE vbap-canceldate,
          deldate        TYPE vbap-deldate,
          custdeldate    TYPE vbap-custdeldate,
          posex          TYPE vbap-posex,
          ernam          TYPE vbap-ernam, """Added by Pranit 27.03.2024
          erdat          TYPE vbap-erdat, """Added by Pranit 27.03.2024
*          zmrp_delay  TYPE vbap-zmrp_delay, """Added by Pranit 19.11.2024
          zwhse_back     TYPE vbap-zwhse_back,
          zassm_back     TYPE vbap-zassm_back,
          ztran_delay    TYPE vbap-ztran_delay,
          zlcl_delays    TYPE vbap-zlcl_delays,
          zother_comment TYPE vbap-zother_comment,
          zother_remark  TYPE vbap-zother_remark,
        END OF ty_vbap,

        BEGIN OF ty_konv,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          kbetr TYPE prcd_elements-kbetr,
          waers TYPE prcd_elements-waers,
          kinak TYPE prcd_elements-kinak,
          kgrpe TYPE prcd_elements-kgrpe,
        END OF ty_konv,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
          adrnr TYPE kna1-adrnr,
          brsch TYPE kna1-brsch,
        END OF ty_kna1,

        BEGIN OF ty_ship,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
          stras TYPE kna1-stras,
          pstlz TYPE kna1-pstlz,
          ort01 TYPE kna1-ort01,
          regio TYPE kna1-regio,
          land1 TYPE kna1-land1,
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

        BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
          fktyp TYPE vbrk-fktyp,
          vkorg TYPE vbrk-vkorg,
          vtweg TYPE vbrk-vtweg,
          fkdat TYPE vbrk-fkdat,
          fksto TYPE vbrk-fksto,
        END OF ty_vbrk,

        BEGIN OF ty_vbpa,
          vbeln TYPE vbpa-vbeln,
          posnr TYPE vbpa-posnr,
          kunnr TYPE vbpa-kunnr,
          parvw TYPE vbpa-parvw,
        END OF ty_vbpa,

        BEGIN OF ty_vbfa,
          vbelv   TYPE vbfa-vbelv,
          posnv   TYPE vbfa-posnv,
          vbeln   TYPE vbfa-vbeln,
          vbtyp_n TYPE vbfa-vbtyp_n,
          erdat   TYPE vbfa-erdat,
        END OF ty_vbfa,

        BEGIN OF ty_vbkd,
          vbeln TYPE vbkd-vbeln,
          posnr TYPE vbkd-posnr,
          inco1 TYPE vbkd-inco1,
          inco2 TYPE vbkd-inco2,
          zterm TYPE vbkd-zterm,
          kursk TYPE vbkd-kursk,
          bstkd TYPE vbkd-bstkd,
        END OF ty_vbkd,


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

        BEGIN OF ty_jest,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
          chgnr TYPE jest-chgnr,
          inact TYPE jest-inact,
        END OF ty_jest,

        BEGIN OF ty_tj30t,
          stsma TYPE tj30t-stsma,
          estat TYPE tj30t-estat,
          spras TYPE tj30t-spras,
          txt30 TYPE tj30t-txt30,
        END OF ty_tj30t,

        BEGIN OF ty_mara,
          matnr   TYPE mara-matnr,
          mtart   TYPE mara-mtart,
          matkl   TYPE mara-matkl,
          wrkst   TYPE mara-wrkst,
          zseries TYPE mara-zseries,
          zsize   TYPE mara-zsize,
          brand   TYPE mara-brand,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
        END OF ty_mara,

        BEGIN OF ty_mbew ,
          matnr TYPE mbew-matnr,
          bwkey TYPE mbew-bwkey,
          lbkum TYPE mbew-lbkum,
          salk3 TYPE mbew-salk3,
          vprsv TYPE mbew-vprsv,
          verpr TYPE mbew-verpr,
          stprs TYPE mbew-stprs,
          bklas TYPE mbew-bklas,
        END OF ty_mbew,

        BEGIN OF ty_marc,
          matnr TYPE marc-matnr,
          werks TYPE marc-werks,
          dispo TYPE marc-dispo,
        END OF ty_marc,

        BEGIN OF ty_vbep,
          vbeln TYPE vbep-vbeln,
          posnr TYPE vbep-posnr,
          etenr TYPE vbep-etenr,
          ettyp TYPE vbep-ettyp,
          edatu TYPE vbep-edatu,
        END OF ty_vbep,

        BEGIN OF ty_tvzbt,
          spras TYPE tvzbt-spras,
          zterm TYPE tvzbt-zterm,
          vtext TYPE tvzbt-vtext,
        END OF ty_tvzbt,

        BEGIN OF ty_tvagt,
          spras TYPE  tvagt-spras,
          abgru TYPE  tvagt-abgru,
          bezei TYPE  tvagt-bezei,
        END OF ty_tvagt,


        BEGIN OF ty_lips,
          vbeln TYPE lips-vbeln,
          posnr TYPE lips-posnr,
          vgbel TYPE lips-vgbel,
          mbdat TYPE lips-mbdat,
        END OF ty_lips,



        BEGIN OF ty_final,
          werks             TYPE vbap-werks,
          auart             TYPE vbak-auart,
          bstnk             TYPE vbak-bstnk,
          bstdk             TYPE vbak-bstdk,
          kunnr             TYPE vbak-kunnr,
          name1             TYPE kna1-name1,
          partner           TYPE kna1-kunnr,
          part_name         TYPE kna1-name1,
          kdgrp             TYPE knvv-kdgrp,
          ktext             TYPE t151t-ktext,
          brsch             TYPE t016t-brsch,
          brtxt             TYPE t016t-brtxt,
          vkbur             TYPE vbak-vkbur,
          vbeln             TYPE vbak-vbeln,
          erdat             TYPE vbak-erdat,
          vdatu             TYPE vbak-vdatu,
          status            TYPE tj30t-txt30,
          holddate          TYPE vbap-holddate,
          holdreldate       TYPE vbap-holdreldate,
          canceldate        TYPE vbap-canceldate,
          deldate           TYPE vbfa-erdat,
          tpi               TYPE char100,
          tag_req           TYPE char100,
          ld_txt            TYPE char250,
          matnr             TYPE mara-matnr,
          wrkst             TYPE mara-wrkst,
          bklas             TYPE mbew-bklas,
          posnr             TYPE vbap-posnr,
          arktx             TYPE vbap-arktx,
          mattxt            TYPE text100,
          kwmeng            TYPE vbap-kwmeng,
          lfimg             TYPE lips-lfimg,
          fkimg             TYPE vbrp-fkimg,
          pnd_qty           TYPE vbrp-fkimg,
          ettyp             TYPE vbep-ettyp,
          edatu             TYPE vbep-edatu,
          etenr             TYPE vbep-etenr,
          kbetr             TYPE prcd_elements-kbetr,
          waerk             TYPE vbak-waerk,
          amont             TYPE kbetr,
          ordr_amt          TYPE kbetr,
          stprs             TYPE mbew-stprs,
          zseries           TYPE mara-zseries,
          zsize             TYPE mara-zsize,
          brand             TYPE mara-brand,
          moc               TYPE mara-moc,
          type              TYPE mara-type,
          mtart             TYPE mara-mtart,
          dispo             TYPE marc-dispo,
          zterm             TYPE vbkd-zterm,
          text1             TYPE t052u-text1,
          inco1             TYPE vbkd-inco1,
          inco2             TYPE vbkd-inco2,
          custdeldate       TYPE vbap-custdeldate,
          bname             TYPE vbak-bname,
          eccn              TYPE char100,
          abgru             TYPE vbap-abgru,
          bezei             TYPE  tvagt-bezei,
          ship_code         TYPE kna1-kunnr,
          ship_name         TYPE kna1-name1,
          stras             TYPE kna1-stras,
          pstlz             TYPE kna1-pstlz,
          ort01             TYPE kna1-ort01,
          ship_rig          TYPE t005u-bezei,
          ship_land         TYPE t005t-landx,
          uhf1              TYPE prcd_elements-kbetr,
          usc1              TYPE prcd_elements-kbetr,
          umc1              TYPE prcd_elements-kbetr,
          huhf1             TYPE prcd_elements-kbetr,
          husc1             TYPE prcd_elements-kbetr,
          humc1             TYPE prcd_elements-kbetr,
          spl_ins           TYPE char250,
          tag_no            TYPE char50,             "added by pankaj 14.01.2022
          ship_from         TYPE char50,   " added by shreya sankpal 15-02-2022
          ofm_date_new      TYPE char20,    "added by shreya 17-03-2022
          mbdat             TYPE lips-mbdat,
          deloyed_remark    TYPE string, "Added by Pranit 23.01.2024
          bstkd             TYPE vbkd-bstkd,   "Added by Pranit 23.01.2024
          posex             TYPE vbap-posex,   "Added by Pranit 23.01.2024
          zbstkd            TYPE vbap-zbstkd, """Added by Pranit 21.02.2024
          zposex            TYPE vbap-zposex,  """Added by Pranit 21.02.2024
*          remark         TYPE char35,  """Added by Pranit 21.02.2024
          ernam             TYPE vbap-ernam,  """Added by Pranit 27.03.2024
          erdat1            TYPE vbap-erdat,  """Added by Pranit 27.03.2024
          reason_hc         TYPE  char20,                """added by supriya 17:06:2024
          delay_item_remark TYPE string,      "added by aakashk 05.08.2024
          zmrp_delay        TYPE char250,      "added by PRANIT 19.11.2024
        END OF ty_final,

        BEGIN OF ty_down,
          werks             TYPE vbap-werks,
          auart             TYPE vbak-auart,
          bstnk             TYPE vbak-bstnk,
          bstdk             TYPE char15,
          kunnr             TYPE vbak-kunnr,
          name1             TYPE kna1-name1,
          partner           TYPE kna1-kunnr,
          part_name         TYPE kna1-name1,
          kdgrp             TYPE knvv-kdgrp,
          ktext             TYPE t151t-ktext,
          brsch             TYPE t016t-brsch,
          brtxt             TYPE t016t-brtxt,
          vkbur             TYPE vbak-vkbur,
          vbeln             TYPE vbak-vbeln,
          erdat             TYPE char15,
          vdatu             TYPE char15,
          status            TYPE tj30t-txt30,
          holddate          TYPE char15,
          holdreldate       TYPE char15,
          canceldate        TYPE char15,
          deldate           TYPE char15,
          tpi               TYPE char100,
          tag_req           TYPE char100,
          ld_txt            TYPE char256,
          matnr             TYPE mara-matnr,
          wrkst             TYPE mara-wrkst,
          bklas             TYPE mbew-bklas,
          posnr             TYPE vbap-posnr,
          arktx             TYPE vbap-arktx,
          mattxt            TYPE text100,
          kwmeng            TYPE char15,
          lfimg             TYPE char15,
          fkimg             TYPE char15,
          pnd_qty           TYPE char15,
          ettyp             TYPE vbep-ettyp,
          kbetr             TYPE char15,
          waerk             TYPE vbak-waerk,
          amont             TYPE char15,
          ordr_amt          TYPE char15,
          stprs             TYPE char15,
          zseries           TYPE mara-zseries,
          zsize             TYPE mara-zsize,
          brand             TYPE mara-brand,
          moc               TYPE mara-moc,
          type              TYPE mara-type,
          dispo             TYPE marc-dispo,
          mtart             TYPE mara-mtart,
          zterm             TYPE vbkd-zterm,
          text1             TYPE t052u-text1,
          inco1             TYPE vbkd-inco1,
          inco2             TYPE vbkd-inco2,
          custdeldate       TYPE char15,
          bname             TYPE vbak-bname,
          eccn              TYPE char100,
          abgru             TYPE vbap-abgru,
          bezei             TYPE  tvagt-bezei,
          ship_code         TYPE kna1-kunnr,
          ship_name         TYPE kna1-name1,
          stras             TYPE kna1-stras,
          pstlz             TYPE kna1-pstlz,
          ort01             TYPE kna1-ort01,
          ship_rig          TYPE t005u-bezei,
          ship_land         TYPE t005t-landx,
          uhf1              TYPE char15,
          usc1              TYPE char15,
          umc1              TYPE char15,
          huhf1             TYPE char15,
          husc1             TYPE char15,
          humc1             TYPE char15,
          spl_ins           TYPE char250,
          ref               TYPE char15,
          ref_time          TYPE char18,
          tag_no            TYPE char100,             "added by pankaj 14.01.2022
          ship_from         TYPE char100,   " added by shreya sankpal 15-02-2022
          ofm_date_new      TYPE char20,    "added by shreya 17-03-2022
          mbdat             TYPE char30,
          deloyed_remark    TYPE string, """Added by Pranit 23.01.2024
          bstkd             TYPE vbkd-bstkd, """Added by Pranit 04.02.2024
          posex             TYPE vbap-posex, """Added by Pranit 04.02.2024
          zbstkd            TYPE vbap-zbstkd,  """Added by Pranit 21.02.2024
          zposex            TYPE vbap-zposex,  """Added by Pranit 21.02.2024
*          remark         TYPE char35,  """Added by Pranit 01.03.2024
          ernam             TYPE char15,  """Added by Pranit 27.03.2024
          erdat1            TYPE char15,  """Added by Pranit 27.03.2024
          reason_hc         TYPE  char20,                """added by supriya 17:06:2024
          delay_item_remark TYPE string,    "added by aakashk 05.08.2024
          zmrp_delay        TYPE string,     "ADDED BY PRANIT 19.11.2024
        END OF ty_down.

DATA: it_vbakp   TYPE TABLE OF ty_vbakp,
      wa_vbakp   TYPE ty_vbakp,

      it_vbap    TYPE TABLE OF ty_vbap,
      wa_vbap    TYPE          ty_vbap,

      it_konv    TYPE TABLE OF ty_konv,
      wa_konv    TYPE  ty_konv,

      it_vbpa    TYPE TABLE OF ty_vbpa,
      wa_vbpa    TYPE ty_vbpa,

      it_vbfa    TYPE TABLE OF ty_vbfa,
      wa_vbfa    TYPE  ty_vbfa,

      it_vbrk    TYPE TABLE OF ty_vbrk,
      wa_vbrk    TYPE  ty_vbrk,

      it_vbep    TYPE TABLE OF ty_vbep,
      wa_vbep    TYPE ty_vbep,

      it_kna1    TYPE TABLE OF ty_kna1,
      wa_kna1    TYPE          ty_kna1,

      it_tvagt   TYPE TABLE OF ty_tvagt,
      wa_tvagt   TYPE ty_tvagt,


      it_lips    TYPE TABLE OF ty_lips,
      wa_lips    TYPE ty_lips,


      it_partner TYPE TABLE OF ty_kna1,
      wa_partner TYPE ty_kna1,

      it_mara    TYPE TABLE OF ty_mara,
      wa_mara    TYPE          ty_mara,

      it_mbew    TYPE TABLE OF ty_mbew,
      wa_mbew    TYPE          ty_mbew,

      it_marc    TYPE TABLE OF ty_marc,
      wa_marc    TYPE          ty_marc,

      it_ship    TYPE TABLE OF ty_ship,
      wa_ship    TYPE ty_ship,

      it_vbkd    TYPE TABLE OF ty_vbkd,
      wa_vbkd    TYPE  ty_vbkd,

      it_t005u   TYPE TABLE OF ty_t005u,
      wa_t005u   TYPE ty_t005u,

      it_t005t   TYPE TABLE OF ty_t005t,
      wa_t005t   TYPE ty_t005t,

      it_knvv    TYPE TABLE OF ty_knvv,
      wa_knvv    TYPE          ty_knvv,

      it_t151t   TYPE TABLE OF ty_t151t,
      wa_t151t   TYPE          ty_t151t,

      it_t016t   TYPE TABLE OF ty_t016t,
      wa_t016t   TYPE          ty_t016t,

      it_jest    TYPE TABLE OF ty_jest,
      wa_jest    TYPE ty_jest,

      it_tj30t   TYPE TABLE OF ty_tj30t,
      wa_tj30t   TYPE ty_tj30t,

      it_tvzbt   TYPE TABLE OF ty_tvzbt,
      wa_tvzbt   TYPE          ty_tvzbt,

      it_data    TYPE STANDARD TABLE OF ty_data,
      wa_data    TYPE ty_data,

      it_delete  TYPE STANDARD TABLE OF ty_data,
      wa_delete  TYPE ty_data,

      it_down    TYPE TABLE OF ty_down,
      wa_down    TYPE          ty_down,

      it_final   TYPE TABLE OF ty_final,
      wa_final   TYPE          ty_final.


DATA :lv_lines TYPE STANDARD TABLE OF tline,
      wa_lines LIKE tline,
      lv_name  TYPE thead-tdname.

DATA : wa_lfimg     TYPE lips-lfimg,
       wa_lfimg_sum TYPE lips-lfimg,
       wa_fkimg     TYPE lips-lfimg,
       wa_fkimg_sum TYPE lips-lfimg.


DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
    SELECT-OPTIONS   :  s_date FOR vbak-erdat OBLIGATORY ,
                        s_matnr FOR vbap-matnr,
                        s_kunnr FOR vbak-kunnr,
                        s_vbeln FOR vbap-vbeln,
                        s_ddate FOR vbap-custdeldate,
                        s_werks FOR vbap-werks OBLIGATORY DEFAULT 'US01'.
*PARAMETERS : s_werks TYPE vbap-werks OBLIGATORY DEFAULT 'US01'.
  SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/USA'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


START-OF-SELECTION .
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

  SELECT vbeln posnr zbstkd zposex
      FROM  vbap
      INTO TABLE it_data
      WHERE erdat  IN s_date
      AND   matnr  IN s_matnr
      AND   werks  IN s_werks
      AND   vbeln  IN s_vbeln
      AND   custdeldate IN s_ddate.


  IF  it_data IS NOT INITIAL .
    SELECT vbeln
           posnr_i
           erdat
           ernam
           audat
           vbtyp
           auart
           netwr
           waerk
           vkorg
           vtweg
           vkbur
           knumv
           vdatu
           bstnk
           bstdk
           bname
           kunnr
           vgbel
           objnr
           matnr_i
           matkl_i
           arktx_i
           abgru_i
           kwmeng_i
           werks_i FROM wb2_v_vbak_vbap2 INTO TABLE it_vbakp
           FOR ALL ENTRIES IN it_data
           WHERE vbeln = it_data-vbeln
             AND posnr_i = it_data-posnr.

  ENDIF.

  IF it_vbakp IS NOT INITIAL.

    SELECT vbeln
           posnr
           matnr
           holddate
           holdreldate
           canceldate
           deldate
           custdeldate
           posex                              ""Added by Pranit 04.02.2024
           ernam                              """Added by Pranit 27.03.2024
           erdat                              """Added by Pranit 27.03.2024
*            zmrp_delay
*                 zmrp_delay
                 zwhse_back
                zassm_back
              ztran_delay
              zlcl_delays
              zother_comment
              zother_remark
          FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbakp
           WHERE vbeln = it_vbakp-vbeln
             AND posnr = it_vbakp-posnr_i.

    SELECT vbeln
           posnr
           vgbel
           mbdat
           FROM lips INTO TABLE it_lips FOR ALL ENTRIES IN it_vbap WHERE vgbel = it_vbap-vbeln
                                                                      AND posnr = it_vbap-posnr.



    SELECT knumv
           kposn
           kschl
           kbetr
           waers
           kinak
           kgrpe
           FROM prcd_elements INTO TABLE it_konv
           FOR ALL ENTRIES IN it_vbakp
           WHERE  knumv = it_vbakp-knumv
           AND kschl IN ( 'ZPR0' , 'VPRS' , 'ZESC', 'UHF1', 'USC1', 'UMC1' ).


    SELECT vbeln
           posnr
           kunnr
           parvw
      FROM vbpa
      INTO TABLE it_vbpa
      FOR ALL ENTRIES IN it_vbakp
      WHERE vbeln = it_vbakp-vbeln.

    SELECT vbeln
           posnr
           inco1
           inco2
           zterm
           kursk
           bstkd
           FROM vbkd INTO TABLE it_vbkd
           FOR ALL ENTRIES IN it_vbakp
           WHERE vbeln = it_vbakp-vbeln.





    SELECT vbelv
           posnv
           vbeln
           vbtyp_n
           erdat
           FROM vbfa INTO TABLE it_vbfa
           FOR ALL ENTRIES IN it_vbakp
           WHERE vbelv = it_vbakp-vbeln
*             AND ( VBTYP_N = 'J' OR  VBTYP_N = 'M' ).
             AND  vbtyp_n IN ( 'J', 'M' ,'T' , 'O' ).

    SELECT kunnr
           name1
           adrnr
           brsch
           FROM kna1 INTO TABLE it_kna1
           FOR ALL ENTRIES IN it_vbakp
           WHERE kunnr = it_vbakp-kunnr.

    SELECT objnr
           stat
           chgnr
           inact FROM jest INTO TABLE it_jest
           FOR ALL ENTRIES IN it_vbakp
           WHERE objnr = it_vbakp-objnr
             AND stat IN ( 'E0001', 'E0002','E0003' )
             AND inact NE 'X'.

    SELECT matnr
           mtart
           matkl
           wrkst
           zseries
           zsize
           brand
           moc
           type   FROM mara INTO TABLE it_mara
           FOR ALL ENTRIES IN it_vbakp
           WHERE matnr = it_vbakp-matnr_i.

    SELECT matnr
           bwkey
           lbkum
           salk3
           vprsv
           verpr
           stprs
           bklas FROM mbew INTO TABLE it_mbew
           FOR ALL ENTRIES IN it_vbakp
           WHERE matnr = it_vbakp-matnr_i
            AND  bwkey = it_vbakp-werks_i.

    SELECT matnr
           werks
           dispo FROM marc INTO TABLE it_marc
           FOR ALL ENTRIES IN it_vbakp
           WHERE matnr = it_vbakp-matnr_i
             AND werks = it_vbakp-werks_i.




    SELECT vbeln
           posnr
           etenr
           ettyp
           edatu
           FROM vbep INTO TABLE it_vbep
           FOR ALL ENTRIES IN it_vbakp WHERE vbeln = it_vbakp-vbeln
                                       AND  posnr = it_vbakp-posnr_i.
    SORT it_vbep BY vbeln posnr etenr.

    SELECT spras
           abgru
           bezei
           FROM tvagt INTO TABLE it_tvagt
           FOR ALL ENTRIES IN it_vbakp
           WHERE  abgru = it_vbakp-abgru_i
             AND spras = 'E'.


  ENDIF.

  IF it_vbpa IS NOT INITIAL.

    SELECT kunnr
           name1
           adrnr
           brsch
           FROM kna1 INTO TABLE it_partner
           FOR ALL ENTRIES IN it_vbpa
           WHERE kunnr = it_vbpa-kunnr.

    SELECT  kunnr
            name1
            stras
            pstlz
            ort01
            regio
            land1 FROM kna1 INTO TABLE it_ship
            FOR ALL ENTRIES IN it_vbpa
            WHERE kunnr = it_vbpa-kunnr.

  ENDIF.

  IF it_ship IS NOT INITIAL.
    SELECT spras
           land1
           bland
           bezei FROM t005u INTO TABLE it_t005u
           FOR ALL ENTRIES IN it_ship
           WHERE spras = 'EN'
            AND  land1 = it_ship-land1
            AND  bland = it_ship-regio.

    SELECT spras
           land1
           landx FROM t005t INTO TABLE it_t005t
           FOR ALL ENTRIES IN it_ship
           WHERE spras = 'EN'
            AND  land1 = it_ship-land1.


  ENDIF.
  IF it_kna1 IS NOT INITIAL.
    SELECT kunnr
           kdgrp
           bzirk
           vkbur FROM knvv INTO TABLE it_knvv
           FOR ALL ENTRIES IN it_kna1
           WHERE kunnr = it_kna1-kunnr.

    SELECT spras
           brsch
           brtxt FROM t016t INTO TABLE it_t016t
           FOR ALL ENTRIES IN it_kna1
           WHERE brsch = it_kna1-brsch.
  ENDIF.

  IF it_knvv IS NOT INITIAL.
    SELECT spras
           kdgrp
           ktext FROM t151t INTO TABLE it_t151t
           FOR ALL ENTRIES IN it_knvv
           WHERE spras = 'E'
            AND  kdgrp = it_knvv-kdgrp.
  ENDIF.
  IF it_jest IS NOT INITIAL.
    SELECT stsma
           estat
           spras
           txt30 FROM tj30t INTO TABLE it_tj30t
           FOR ALL ENTRIES IN it_jest
           WHERE estat = it_jest-stat
           AND stsma  = 'OR_ITEM' .


  ENDIF.

  IF it_vbfa IS NOT INITIAL.
    SELECT vbeln
           fkart
           fktyp
           vkorg
           vtweg
           fkdat
           fksto
           FROM vbrk INTO TABLE it_vbrk
           FOR ALL ENTRIES IN it_vbfa
           WHERE vbeln = it_vbfa-vbeln
             AND fksto NE 'X'.
  ENDIF.

  IF it_vbkd IS NOT INITIAL.
    SELECT spras
           zterm
           vtext FROM tvzbt INTO TABLE it_tvzbt
           FOR ALL ENTRIES IN it_vbkd
           WHERE zterm = it_vbkd-zterm
            AND spras = 'EN'.

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
  SORT it_vbakp BY vbeln posnr_i.
  LOOP AT it_vbakp INTO wa_vbakp.
    wa_final-werks       = wa_vbakp-werks_i.
    wa_final-auart       = wa_vbakp-auart.
    wa_final-bstnk       = wa_vbakp-bstnk.
    wa_final-bstdk       = wa_vbakp-bstdk.
    wa_final-kunnr       = wa_vbakp-kunnr.
    wa_final-vkbur       = wa_vbakp-vkbur.
    wa_final-erdat       = wa_vbakp-erdat.
    wa_final-vdatu       = wa_vbakp-vdatu.
    wa_final-matnr       = wa_vbakp-matnr_i.
    wa_final-posnr       = wa_vbakp-posnr_i.
    wa_final-arktx       = wa_vbakp-arktx_i.
    wa_final-kwmeng      = wa_vbakp-kwmeng_i.
    wa_final-waerk       = wa_vbakp-waerk.
    wa_final-bname       = wa_vbakp-bname.
    wa_final-abgru       = wa_vbakp-abgru_i.
    wa_final-vbeln       = wa_vbakp-vbeln.

    READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_vbakp-vbeln posnr = wa_vbakp-posnr_i.
    IF sy-subrc = 0.
      wa_final-holddate     =  wa_vbap-holddate   .
      wa_final-holdreldate  =  wa_vbap-holdreldate.
      wa_final-canceldate   =  wa_vbap-canceldate .
      wa_final-deldate      =  wa_vbap-deldate    .
      wa_final-custdeldate  =  wa_vbap-custdeldate .
      wa_final-posex        =  wa_vbap-posex .
      wa_final-ernam        =  wa_vbap-ernam .
      wa_final-erdat1       =  wa_vbap-erdat .

*      IF wa_vbap-zmrp_delay EQ 'WHSE_BACK'.
*        wa_final-zmrp_delay = 'Whse Backlog'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'ASSEM_BACK'.
*        wa_final-zmrp_delay = 'Assembly Backlog'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'TRAN_DELAY'.
*        wa_final-zmrp_delay = 'Transit Delays'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'LCL_DELAY'.
*        wa_final-zmrp_delay = 'LCL Delays'.
*      ELSEIF wa_vbap-zmrp_delay EQ 'OTHER'.
*        wa_final-zmrp_delay = 'Other w/c Comments'.
*      ENDIF.

      IF wa_vbap-zwhse_back EQ 'X'.       """Added by Pranit 18.11.2024
        DATA(gv_whse) = 'Whse Backlog'.
        CONCATENATE  gv_whse wa_final-zmrp_delay INTO wa_final-zmrp_delay SEPARATED BY ' '.
      ENDIF.
      IF wa_vbap-zassm_back EQ 'X'.
        DATA(gv_assm) = 'Assembly Backlog'.
        CONCATENATE wa_final-zmrp_delay gv_assm INTO wa_final-zmrp_delay SEPARATED BY ','.
      ENDIF.
      IF wa_vbap-ztran_delay EQ 'X'.
        DATA(gv_trans) = 'Transit Delays'.
        CONCATENATE wa_final-zmrp_delay gv_trans INTO wa_final-zmrp_delay SEPARATED BY ','.
      ENDIF.
      IF wa_vbap-zlcl_delays EQ 'X'.
        DATA(gv_lcl) = 'LCL Delays'.
        CONCATENATE wa_final-zmrp_delay gv_lcl INTO wa_final-zmrp_delay SEPARATED BY ','.
      ENDIF.
      IF wa_vbap-zother_comment EQ 'X'.
        DATA(gv_other) = wa_vbap-zother_remark.
        CONCATENATE wa_final-zmrp_delay gv_other INTO wa_final-zmrp_delay SEPARATED BY ','.
      ENDIF.

*      CONCATENATE GV_WHSE GV_ASSM GV_TRANS GV_LCL GV_OTHER INTO wa_final-zmrp_delay SEPARATED BY ','.


      IF wa_final-zmrp_delay IS NOT INITIAL.
        DATA(lv_str) = strlen( wa_final-zmrp_delay ).
        DATA(lv_count) = lv_str - 1.
        IF wa_final-zmrp_delay+0(1) = ','.
          wa_final-zmrp_delay+0(1) = ' '.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE it_lips INTO wa_lips WITH KEY vgbel = wa_vbap-vbeln posnr = wa_vbap-posnr.
    IF sy-subrc = 0.
      wa_final-mbdat = wa_lips-mbdat.
    ENDIF.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbakp-kunnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_kna1-name1.
    ENDIF.

    READ TABLE it_knvv INTO wa_knvv WITH KEY kunnr = wa_kna1-kunnr.
    IF sy-subrc = 0.
      wa_final-kdgrp      = wa_knvv-kdgrp.

    ENDIF.

    READ TABLE it_t151t INTO wa_t151t WITH KEY kdgrp = wa_knvv-kdgrp.
    IF sy-subrc = 0.
      wa_final-ktext = wa_t151t-ktext.
    ENDIF.

    READ TABLE it_vbpa INTO wa_vbpa WITH KEY vbeln = wa_vbakp-vbeln parvw = 'UR'.
    IF sy-subrc = 0.
      wa_final-partner = wa_vbpa-kunnr.
    ENDIF.

    READ TABLE it_partner INTO wa_partner WITH KEY kunnr = wa_final-partner.
    IF sy-subrc = 0.
      wa_final-part_name = wa_partner-name1.
    ENDIF.

    READ TABLE it_vbpa INTO wa_vbpa WITH KEY vbeln = wa_vbakp-vbeln parvw = 'WE'.
    IF sy-subrc = 0.
      READ TABLE it_ship INTO wa_ship WITH KEY kunnr = wa_vbpa-kunnr.
      IF sy-subrc = 0.
        wa_final-ship_name = wa_ship-name1.
        wa_final-ship_code = wa_ship-kunnr.
        wa_final-stras     = wa_ship-stras.
        wa_final-pstlz     = wa_ship-pstlz.
        wa_final-ort01     = wa_ship-ort01.

      ENDIF.

    ENDIF.

    READ TABLE it_t005u INTO wa_t005u WITH KEY spras = 'EN' land1 = wa_ship-land1 bland = wa_ship-regio.
    IF sy-subrc = 0.
      wa_final-ship_rig = wa_t005u-bezei.
    ENDIF.

    READ TABLE it_t005t INTO wa_t005t WITH KEY spras = 'EN' land1 = wa_ship-land1 .
    IF sy-subrc = 0.
      wa_final-ship_land = wa_t005t-landx.
    ENDIF.


    READ TABLE it_t016t INTO wa_t016t WITH KEY brsch = wa_kna1-brsch.
    IF sy-subrc = 0.
      wa_final-brsch = wa_t016t-brsch.
      wa_final-brtxt = wa_t016t-brtxt.

    ENDIF.

    READ TABLE it_jest INTO wa_jest WITH KEY objnr = wa_vbakp-objnr.
    IF sy-subrc = 0.
      READ TABLE it_tj30t INTO wa_tj30t WITH  KEY estat = wa_jest-stat
                                               stsma  = 'OR_ITEM'
                                               spras  = 'EN'.
      IF sy-subrc = 0.
        wa_final-status      = wa_tj30t-txt30.          "Hold/Unhold
      ENDIF.
    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_vbakp-matnr_i.
    IF sy-subrc = 0.
      wa_final-mtart   = wa_mara-mtart.
      wa_final-wrkst   = wa_mara-wrkst.
      wa_final-zseries = wa_mara-zseries.
      wa_final-zsize   = wa_mara-zsize.
      wa_final-brand   = wa_mara-brand.
      wa_final-moc     = wa_mara-moc.
      wa_final-type    = wa_mara-type   .
    ENDIF.


    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_vbakp-matnr_i bwkey = wa_vbakp-werks_i.
    IF sy-subrc = 0.
      wa_final-bklas = wa_mbew-bklas.
      wa_final-stprs = wa_mbew-stprs.
    ENDIF.

    READ TABLE it_marc INTO wa_marc WITH KEY matnr = wa_final-matnr werks = wa_final-werks.
    IF sy-subrc = 0.
      wa_final-dispo = wa_marc-dispo.
    ENDIF.

    READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_final-vbeln
                                               posnr = wa_final-posnr
                                               etenr = '0001'.
    IF sy-subrc = 0.
      wa_final-ettyp       = wa_vbep-ettyp.           "So Status
      wa_final-edatu       = wa_vbep-edatu.           "delivary Date
      wa_final-etenr       = wa_vbep-etenr.           "Schedule line no.
    ENDIF.

    READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_final-vbeln.
    IF sy-subrc = 0.
      wa_final-bstkd       = wa_vbkd-bstkd.           "Cust Ref No.
      wa_final-zterm       = wa_vbkd-zterm.           "payment terms
      wa_final-inco1       = wa_vbkd-inco1.           "inco terms
      wa_final-inco2       = wa_vbkd-inco2.           "inco terms description
    ENDIF.

    READ TABLE it_tvzbt INTO wa_tvzbt WITH KEY zterm = wa_final-zterm.
    IF sy-subrc = 0.
      wa_final-text1  = wa_tvzbt-vtext.
    ENDIF.

    READ TABLE it_tvagt INTO wa_tvagt WITH KEY  abgru = wa_vbakp-abgru_i  spras = 'E'.
    IF sy-subrc = 0.
      wa_final-bezei   =  wa_tvagt-bezei.
    ENDIF.

    READ TABLE it_data INTO DATA(wa_data) WITH KEY vbeln = wa_vbep-vbeln  posnr = wa_vbep-posnr.                 """Added by Pranit 21.02.2024
    IF sy-subrc = 0.
      wa_final-zbstkd = wa_data-zbstkd.
      wa_final-zposex = wa_data-zposex.
    ENDIF.

    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'U001'
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
    IF wa_lines IS NOT INITIAL.
      wa_final-tpi = wa_lines-tdline.
    ENDIF.

*LD Req Text
    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'U005'
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

*    READ TABLE lv_lines INTO wa_lines INDEX 1.
*    IF wa_lines IS NOT INITIAL.
*      wa_final-ld_txt = wa_lines-tdline.
*    ENDIF.
    LOOP AT lv_lines INTO wa_lines.
      IF NOT wa_lines-tdline IS INITIAL.
        CONCATENATE wa_final-ld_txt wa_lines-tdline  INTO wa_final-ld_txt ." SEPARATED BY space.
        CLEAR wa_lines-tdline.
      ENDIF.
    ENDLOOP.

*Tag Required
    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'U006'
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
    IF wa_lines IS NOT INITIAL.
      wa_final-tag_req = wa_lines-tdline.
    ENDIF.
*Material Long Text
    CLEAR: lv_lines, wa_lines.
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

    READ TABLE lv_lines INTO wa_lines INDEX 1.
    IF wa_lines IS NOT INITIAL.
      wa_final-mattxt = wa_lines-tdline.
    ENDIF.


**ECCN
    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'U002'
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

*      READ TABLE lv_lines INTO wa_lines INDEX 1.

    LOOP AT lv_lines INTO wa_lines.
      IF NOT wa_lines-tdline IS INITIAL..


        CONCATENATE wa_final-eccn wa_lines-tdline  INTO wa_final-eccn SEPARATED BY space.

      ENDIF.
    ENDLOOP.
*    BREAK-POINT.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Pranit 23.01.2024
    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'U008'
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

    LOOP AT lv_lines INTO wa_lines.     "added by aakashk 05.08.2024
      IF NOT wa_lines-tdline IS INITIAL.
        CONCATENATE wa_final-deloyed_remark wa_lines-tdline  INTO wa_final-deloyed_remark SEPARATED BY space.

*    READ TABLE lv_lines INTO wa_lines INDEX 1.    "commented by aakashk 05.08.2024
*    IF wa_lines IS NOT INITIAL.
*      wa_final-deloyed_remark = wa_lines-tdline.
      ENDIF.
    ENDLOOP.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""ADDED BY PRANIT 01.03.2024

*    CLEAR: lv_lines, wa_lines.
*    REFRESH lv_lines.
*    lv_name = wa_final-vbeln.
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'U005'
*        language                = 'E'
*        name                    = lv_name
*        object                  = 'VBBK'
*      TABLES
*        lines                   = lv_lines
*      EXCEPTIONS
*        id                      = 1
*        language                = 2
*        name                    = 3
*        not_found               = 4
*        object                  = 5
*        reference_check         = 6
*        wrong_access_to_archive = 7
*        OTHERS                  = 8.
*    IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    READ TABLE lv_lines INTO wa_lines INDEX 1.
*    IF wa_lines IS NOT INITIAL.
*      wa_final-remark = wa_lines-tdline.
*    ENDIF.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""ENDED BY 01.03.2024

    """"""""""""""""""""""""""""""""""""""""""""ADD BY SUPRIYA JAGTAP 17:06:2024

    CONCATENATE wa_final-vbeln wa_final-posnr INTO lv_name.
    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
*    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z109'
        language                = 'E'
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

    READ TABLE lv_lines  INTO wa_lines INDEX 1.
    IF wa_lines-tdline IS NOT INITIAL .
      wa_final-reason_hc = wa_lines-tdline.
    ENDIF.


    """"""""""""""""""""""""""""""""""""""""""""

    "ADDED BY AAKASHK 05.08.2024''''''''''''''''''''''''''''''''''''''''''''''''''''

    CONCATENATE wa_final-vbeln wa_final-posnr INTO lv_name.
    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
*   lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'U008'
        language                = 'E'
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
    LOOP AT lv_lines INTO wa_lines.
      IF NOT wa_lines-tdline IS INITIAL.
        CONCATENATE wa_final-delay_item_remark wa_lines-tdline  INTO wa_final-delay_item_remark SEPARATED BY space.
*           wa_final-delay_item_remark = wa_lines-tdline.
*      wa_final-tpi = wa_lines-tdline.
      ENDIF.
    ENDLOOP.
    "END ADD BY AAKASHK.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

    CLEAR: lv_lines, wa_lines,lv_name.
    REFRESH lv_lines.
    CONCATENATE wa_final-vbeln wa_final-posnr INTO lv_name.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z888'
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
    IF lv_lines IS NOT INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL..


          CONCATENATE wa_final-spl_ins wa_lines-tdline  INTO wa_final-spl_ins SEPARATED BY space.

        ENDIF.
      ENDLOOP.
    ENDIF.


    CLEAR: wa_vbfa, wa_lfimg, wa_lfimg_sum.

    LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_final-vbeln
                                 AND posnv = wa_final-posnr
                                 AND vbtyp_n = 'J'.

      wa_final-deldate = wa_vbfa-erdat.

      CLEAR wa_lfimg.
      SELECT SINGLE lfimg FROM lips INTO  wa_lfimg  WHERE vbeln = wa_vbfa-vbeln
                                                    AND   pstyv = 'ZTAN'
                                                    AND   vgbel = wa_final-vbeln
                                                    AND   vgpos = wa_final-posnr.
      wa_lfimg_sum = wa_lfimg_sum + wa_lfimg .

    ENDLOOP.


*INVOICE QTY
    CLEAR: wa_vbfa, wa_fkimg, wa_fkimg_sum.
    LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_final-vbeln
                                   AND posnv = wa_final-posnr
                                   AND vbtyp_n = 'M'.

      CLEAR wa_vbrk.
      READ TABLE it_vbrk INTO wa_vbrk WITH KEY   vbeln = wa_vbfa-vbeln.
      IF sy-subrc = 0.


        CLEAR wa_fkimg.
        SELECT SINGLE fkimg FROM vbrp INTO  wa_fkimg  WHERE vbeln = wa_vbrk-vbeln
                                                      AND   aubel = wa_final-vbeln
                                                      AND   aupos = wa_final-posnr.
        wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
      ENDIF.
    ENDLOOP.

****

******************Logic For US03 Order Type****************************************
    IF wa_final-auart = 'US03'.
      CLEAR: wa_vbfa, wa_lfimg, wa_lfimg_sum.

      LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_final-vbeln
                                   AND posnv = wa_final-posnr
                                   AND vbtyp_n = 'T'.

        CLEAR wa_lfimg.
        SELECT SINGLE lfimg FROM lips INTO  wa_lfimg  WHERE vbeln = wa_vbfa-vbeln
                                                      AND   pstyv = 'UREN'   "'ZTAN'
                                                      AND   vgbel = wa_final-vbeln
                                                      AND   vgpos = wa_final-posnr.
        wa_lfimg_sum = wa_lfimg_sum + wa_lfimg .

      ENDLOOP.

      CLEAR: wa_vbfa, wa_fkimg, wa_fkimg_sum.
      LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_final-vbeln
                                     AND posnv = wa_final-posnr
                                     AND vbtyp_n = 'O'.

        CLEAR wa_vbrk.
        READ TABLE it_vbrk INTO wa_vbrk WITH KEY   vbeln = wa_vbfa-vbeln.
        IF sy-subrc = 0.


          CLEAR wa_fkimg.
          SELECT SINGLE fkimg FROM vbrp INTO  wa_fkimg  WHERE vbeln = wa_vbrk-vbeln
                                                        AND   aubel = wa_final-vbeln
                                                        AND   aupos = wa_final-posnr.
          wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
        ENDIF.
      ENDLOOP.
    ENDIF.

    wa_final-lfimg       = wa_lfimg_sum.                "del qty
    wa_final-fkimg       = wa_fkimg_sum.                "inv qty
    wa_final-pnd_qty     = wa_final-kwmeng - wa_final-fkimg.  "Pending Qty


    CLEAR: wa_konv.
    READ TABLE it_konv INTO wa_konv WITH  KEY knumv = wa_vbakp-knumv
                                                      kposn = wa_vbakp-posnr_i
                                                      kschl = 'ZPR0'  kinak = ' '.

    IF sy-subrc EQ 0.
      wa_final-kbetr       = wa_konv-kbetr.           "Rate
    ENDIF.


    CLEAR: wa_konv .
    READ TABLE it_konv INTO wa_konv WITH  KEY knumv = wa_vbakp-knumv
                                                  kposn = wa_vbakp-posnr_i
                                                  kschl = 'UHF1' .
    IF sy-subrc EQ 0.

      IF wa_konv-kgrpe = 'X'.
        ON CHANGE OF wa_vbakp-knumv.
          wa_final-huhf1       = wa_konv-kbetr.           "Rate
        ENDON.
      ELSE.
        wa_final-uhf1       = wa_konv-kbetr.           "Rate
      ENDIF.

    ENDIF.

    CLEAR: wa_konv .
    READ TABLE it_konv INTO wa_konv WITH  KEY knumv = wa_vbakp-knumv
                                                   kposn = wa_vbakp-posnr_i
                                                   kschl = 'USC1' .
    IF sy-subrc EQ 0.
      IF wa_konv-kgrpe = 'X'.
        ON CHANGE OF wa_vbakp-knumv.
          wa_final-husc1       = wa_konv-kbetr.           "Rate
        ENDON.
      ELSE.
        wa_final-usc1       = wa_konv-kbetr.           "Rate
      ENDIF.

    ENDIF.

    CLEAR: wa_konv .
    READ TABLE it_konv INTO wa_konv WITH  KEY knumv = wa_vbakp-knumv
                                                  kposn = wa_vbakp-posnr_i
                                                  kschl = 'UMC1' .

    IF sy-subrc EQ 0.
      IF wa_konv-kgrpe = 'X'.
        ON CHANGE OF wa_vbakp-knumv.
          wa_final-humc1       = wa_konv-kbetr.           "Rate
        ENDON.
      ELSE.
        wa_final-umc1       = wa_konv-kbetr.           "Rate
      ENDIF.

    ENDIF.




    IF wa_final-auart = 'US03'.
      wa_final-pnd_qty = wa_final-pnd_qty * -1.
    ENDIF.

    wa_final-amont       = wa_final-pnd_qty * wa_final-kbetr .
    wa_final-ordr_amt    = wa_final-kwmeng * wa_final-kbetr .
    IF wa_final-auart = 'US03'.
      wa_final-kwmeng    = wa_final-kwmeng * -1.
      wa_final-lfimg     = wa_final-lfimg * -1.
      wa_final-fkimg     = wa_final-fkimg * -1.
      wa_final-ordr_amt  = wa_final-ordr_amt * -1.
    ENDIF.

    IF wa_final-auart = 'US12' .
      wa_final-kwmeng    = wa_final-kwmeng * -1.
      wa_final-pnd_qty   = wa_final-pnd_qty * -1.
      wa_final-amont     = wa_final-amont * -1.
      wa_final-ordr_amt  = wa_final-ordr_amt * -1.
    ENDIF.

    """"""""""code added by pankaj 14.01.2022
    CLEAR: lv_lines, wa_lines,lv_name.
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
    IF lv_lines IS NOT INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL..


          CONCATENATE wa_final-tag_no wa_lines-tdline  INTO wa_final-tag_no SEPARATED BY space.

        ENDIF.
      ENDLOOP.
    ENDIF.
    CLEAR: lv_lines, wa_lines,lv_name.
    REFRESH lv_lines.
    CONCATENATE wa_final-vbeln wa_final-posnr INTO lv_name.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z108'
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
    IF lv_lines IS NOT INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL..


          CONCATENATE wa_final-ship_from wa_lines-tdline  INTO wa_final-ship_from SEPARATED BY space.

        ENDIF.
      ENDLOOP.
    ENDIF.

**********    start of code by shreya 17-03-2022****************************

    CLEAR: lv_lines, wa_lines.
    REFRESH lv_lines.
    lv_name = wa_final-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'U007'
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

*      READ TABLE lv_lines INTO wa_lines INDEX 1.

    LOOP AT lv_lines INTO wa_lines.
      IF NOT wa_lines-tdline IS INITIAL..


        CONCATENATE wa_final-ofm_date_new wa_lines-tdline  INTO wa_final-ofm_date_new SEPARATED BY space.

      ENDIF.
    ENDLOOP.
********************************end of code by shreya************************



    """"""""ednded """"""""""""""""""""""""""""""""""""""""""

    APPEND wa_final TO it_final.
    CLEAR wa_final.
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

  PERFORM fcat USING :  '1'     'WERKS'       'IT_FINAL'  'Plant'                    '15' ,
                        '2'     'AUART'       'IT_FINAL'  'Order Type'                    '15' ,
                        '3'     'BSTNK'       'IT_FINAL'  'Customer PO No'                    '15' ,
                        '4'     'BSTDK'       'IT_FINAL'  'Customer PO Date'                    '15' ,
                        '5'     'KUNNR'       'IT_FINAL'  'Customer Code'                    '15' ,
                        '6'     'NAME1'       'IT_FINAL'  'Customer Name'                    '15' ,
                        '7'     'PARTNER'     'IT_FINAL'  'Sales Rep. No'                    '15' ,
                        '8'     'PART_NAME'   'IT_FINAL'  'Sales Rep. Name'                    '15' ,
                        '9'     'KDGRP'       'IT_FINAL'  'Customer Group'                    '15' ,
                        '10'    'KTEXT'       'IT_FINAL'  'Customer Group Desc'                    '15' ,
                        '11'    'BRSCH'       'IT_FINAL'  'Industry Sector'                    '15' ,
                        '12'    'BRTXT'       'IT_FINAL'  'Industry Sector Desc'                    '15' ,
                        '13'    'VKBUR'       'IT_FINAL'  'Sales Office'                    '15' ,
                        '14'    'VBELN'       'IT_FINAL'  'Sales Doc No'                    '15' ,
                        '15'    'ERDAT'       'IT_FINAL'  'So Date'                    '15' ,
                        '16'    'VDATU'       'IT_FINAL'  'Required Delivery Dt'                    '15' ,
                        '17'    'STATUS'      'IT_FINAL'  'Hold/Unhold'                    '15' ,

                        '18'    'HOLDDATE'         'IT_FINAL'   'Hold Date'                          '15' ,
                        '19'    'HOLDRELDATE'      'IT_FINAL'   'Release Date'                       '15' ,
                        '20'    'CANCELDATE'       'IT_FINAL'   'Cancelled Date'                     '15' ,
                        '21'    'DELDATE'          'IT_FINAL'   'Delivery Date'                      '15' ,
                        '22'    'TPI'              'IT_FINAL'   'Shipping Method'                    '15' ,
                        '23'    'TAG_REQ'          'IT_FINAL'   'Service Charge'                     '15' ,
                        '24'    'LD_TXT'           'IT_FINAL'   'Remark'                             '15' ,
                        '25'    'MATNR'            'IT_FINAL'   'Item Code'                         '15' ,
                        '26'    'WRKST'            'IT_FINAL'   'USA Code'                          '15' ,
                        '27'    'BKLAS'            'IT_FINAL'   'Valuation Class'                   '15' ,
                        '28'    'POSNR'            'IT_FINAL'   'Line Item'                         '15' ,
                        '29'    'ARKTX'            'IT_FINAL'   'Item Description'                  '15' ,
                        '30'    'MATTXT'           'IT_FINAL'   'Material long Text'                '15' ,
                        '31'    'KWMENG'           'IT_FINAL'   'SO QTY'                            '15' ,
                        '32'    'LFIMG'            'IT_FINAL'   'Delivary Qty'                      '15' ,
                        '33'    'FKIMG'            'IT_FINAL'   'Invoice Quantity'                  '15' ,
                        '34'    'PND_QTY'          'IT_FINAL'   'Pending Qty'                       '15' ,
                        '35'    'ETTYP'            'IT_FINAL'   'SO Status'                         '15' ,
                        '36'    'KBETR'            'IT_FINAL'   'Rate'                              '15' ,
                        '37'    'WAERK'            'IT_FINAL'   'Currency Type'                      '15' ,

                        '38'    'AMONT'            'IT_FINAL'    'Pending SO Amount'                  '15' ,
                        '39'    'ORDR_AMT'         'IT_FINAL'    'Order Amount'                       '15' ,
                        '40'    'STPRS'            'IT_FINAL'    'Standard Cost'                      '15' ,
                        '41'    'ZSERIES'          'IT_FINAL'    'Series'                             '15' ,
                        '42'    'ZSIZE'            'IT_FINAL'    'Size'                               '15' ,
                        '43'    'BRAND'            'IT_FINAL'    'Brand'                              '15' ,
                        '44'    'MOC'              'IT_FINAL'    'MOC'                                '15' ,
                        '45'    'TYPE'             'IT_FINAL'    'Type'                               '15' ,
                        '46'    'DISPO'            'IT_FINAL'    'MRP Controller'                     '15' ,
                        '47'    'MTART'            'IT_FINAL'    'MAT TYPE'                           '15' ,
                        '48'    'ZTERM'            'IT_FINAL'    'Payment Terms'                      '15' ,
                        '49'    'TEXT1'            'IT_FINAL'    'Payment Terms Text'                 '15' ,
                        '50'    'INCO1'            'IT_FINAL'    'Inco Terms'                         '15' ,
                        '51'    'INCO2'            'IT_FINAL'    'Inco Terms Descr'                   '15' ,
                        '52'    'CUSTDELDATE'      'IT_FINAL'    'Customer Delivery Date'             '15' ,
                        '53'    'BNAME'            'IT_FINAL'    'Contact Person'                     '15' ,
                        '54'    'ECCN'             'IT_FINAL'    'ECCN'                               '15' ,
                        '55'    'ABGRU'            'IT_FINAL'    'Rejection Reason Code'              '15' ,
                        '56'    'BEZEI'            'IT_FINAL'    'Rejection Reason Description'       '15' ,
                        '57'    'SHIP_CODE'        'IT_FINAL'    'Ship To Party Code'                 '15' ,
                        '58'    'SHIP_NAME'        'IT_FINAL'    'Ship To Party Name'                 '15' ,
                        '59'    'STRAS'            'IT_FINAL'    'Ship To Party House No'             '15' ,
                        '60'    'PSTLZ'            'IT_FINAL'    'Ship To Party Postal Code'          '15' ,
                        '61'    'ORT01'            'IT_FINAL'    'Ship To Party City'                 '15' ,
                        '62'    'SHIP_RIG'         'IT_FINAL'    'Ship To Party Region'               '15' ,
                        '63'    'SHIP_LAND'        'IT_FINAL'    'Ship To Party Country'              '15' ,
                        '64'    'UHF1'             'IT_FINAL'    'Handling Charges '                  '15' ,
                        '65'    'USC1'             'IT_FINAL'    'Service Charges'                    '15' ,
                        '66'    'UMC1'             'IT_FINAL'    'Mounting Charges'                   '15' ,
                        '67'    'HUHF1'            'IT_FINAL'    'Hed.Handling Charges '              '15' ,
                        '68'    'HUSC1'            'IT_FINAL'    'Hed.Service Charges'                '15' ,
                        '69'    'HUMC1'            'IT_FINAL'    'Hed.Mounting Charges'               '15' ,
                        '70'    'SPL_INS'          'IT_FINAL'    'Special Instruction'                '15' ,
                        '71'    'TAG_NO'           'IT_FINAL'    'Tag No Details'                     '15' ,         "added by pankaj 14.01.2022
                        '72'    'SHIP_FROM'        'IT_FINAL'    'Shipping From'                      '15' ,       "added by shreya 15-02-2022
                        '73'    'OFM_DATE_NEW'     'IT_FINAL'    'OFM Date'                           '15' ,       "added by shreya 15-02-2022
                        '74'    'MBDAT'            'IT_FINAL'    'Material Avail Date'                '15' ,
                        '75'    'DELOYED_REMARK'   'IT_FINAL'    'Delayed SO remark'                '15' ,   ""Added by Pranit 23.01.2024   changed by aakashk 05.08.2024
                        '76'    'BSTKD'            'IT_FINAL'    'PO Number'                          '15' ,   ""Added by Pranit 04.02.2024
                        '77'    'POSEX'            'IT_FINAL'    'PO Line Item Number'                '15' ,   ""Added by Pranit 04.02.2024
                        '78'    'ZBSTKD'           'IT_FINAL'    'DV IND PO Number'                   '15' ,   ""Added by Pranit 21.02.2024
                        '79'    'ZPOSEX'           'IT_FINAL'    'DV IND PO Line Item Number'         '15' ,   ""Added by Pranit 21.02.2024
*                        '80'    'REMARK'           'IT_FINAL'    'SO Remark'                          '15' ,   ""Added by Pranit 01.03.2024
                        '80'    'ERNAM'            'IT_FINAL'    'Created By'                         '15' ,   ""Added by Pranit 27.03.2024
                        '81'    'ERDAT'            'IT_FINAL'    'Created On'                         '15' ,   ""Added by Pranit 27.03.2024
                        '82'    'REASON_HC '        'IT_FINAL'   'Reason for Hold/Cancelled'                           '15',  """Added by supriya Jagtap    17.06.2024
                        '83'    'DELAY_ITEM_REMARK'  'IT_FINAL'    'Delay Item Remark'                   '20',     "added by aakashk 05.08.2024
                        '84'    'zmrp_delay'         'IT_FINAL'    'Target Date Delay(Reason)'        '20'.     "added by PRANIT 19.11.2024
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_3532   text
*      -->P_3533   text
*      -->P_3534   text
*      -->P_3535   text
*      -->P_3536   text
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
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_CMD'
      i_callback_top_of_page  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = wa_layout
      it_fieldcat             = it_fcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
      it_sort                 = t_sort[]
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'X'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
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
  ls_header-info = 'Pending So All Report'.
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
ENDFORM.                    " TOP-OF-
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
    wa_down-werks       = wa_final-werks.
    wa_down-auart       = wa_final-auart.
    wa_down-bstnk       = wa_final-bstnk.
    wa_down-kunnr       = wa_final-kunnr.
    wa_down-name1       = wa_final-name1.
    wa_down-partner     = wa_final-partner.
    wa_down-part_name   = wa_final-part_name.
    wa_down-kdgrp       = wa_final-kdgrp.
    wa_down-ktext       = wa_final-ktext.
    wa_down-brsch       = wa_final-brsch.
    wa_down-brtxt       = wa_final-brtxt.
    wa_down-vkbur       = wa_final-vkbur.
    wa_down-vbeln       = wa_final-vbeln.
    wa_down-status      = wa_final-status.

    wa_down-tpi         = wa_final-tpi.
    wa_down-tag_req     = wa_final-tag_req.
    wa_down-ld_txt      = wa_final-ld_txt.
    wa_down-matnr       = wa_final-matnr.
    wa_down-wrkst       = wa_final-wrkst.
    wa_down-bklas       = wa_final-bklas.
    wa_down-posnr       = wa_final-posnr.
    wa_down-arktx       = wa_final-arktx.

    wa_down-mattxt      = wa_final-mattxt.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN wa_down-mattxt WITH ' & '.

    wa_down-kwmeng      = abs( wa_final-kwmeng ).
    wa_down-lfimg       = abs( wa_final-lfimg ).
    wa_down-fkimg       = abs( wa_final-fkimg ).
    wa_down-pnd_qty     = abs( wa_final-pnd_qty ).
    wa_down-amont       = abs( wa_final-amont ).
    wa_down-ordr_amt    = abs( wa_final-ordr_amt ).
    wa_down-stprs       = abs( wa_final-stprs ).
    wa_down-uhf1        = abs( wa_final-uhf1 ).
    wa_down-usc1        = abs( wa_final-usc1 ).
    wa_down-umc1        = abs( wa_final-umc1 ).
    wa_down-huhf1       = abs( wa_final-huhf1 ).
    wa_down-husc1       = abs( wa_final-husc1 ).
    wa_down-humc1       = abs( wa_final-humc1 ).
    wa_down-kbetr       = abs( wa_final-kbetr ).

    CONDENSE wa_down-uhf1.
    IF wa_final-uhf1 < 0.
      CONCATENATE '-' wa_down-uhf1 INTO wa_down-uhf1.
    ENDIF.

    CONDENSE wa_down-usc1.
    IF wa_final-usc1 < 0.
      CONCATENATE '-' wa_down-usc1 INTO wa_down-usc1.
    ENDIF.

    CONDENSE wa_down-umc1.
    IF wa_final-umc1 < 0.
      CONCATENATE '-' wa_down-umc1 INTO wa_down-umc1.
    ENDIF.


    CONDENSE wa_down-huhf1.
    IF wa_final-huhf1 < 0.
      CONCATENATE '-' wa_down-huhf1 INTO wa_down-huhf1.
    ENDIF.

    CONDENSE wa_down-husc1.
    IF wa_final-husc1 < 0.
      CONCATENATE '-' wa_down-husc1 INTO wa_down-husc1.
    ENDIF.

    CONDENSE wa_down-humc1.
    IF wa_final-humc1 < 0.
      CONCATENATE '-' wa_down-humc1 INTO wa_down-humc1.
    ENDIF.

    CONDENSE wa_down-kwmeng.
    IF wa_final-kwmeng < 0.
      CONCATENATE '-' wa_down-kwmeng INTO wa_down-kwmeng.
    ENDIF.


    CONDENSE wa_down-lfimg.
    IF wa_final-lfimg < 0.
      CONCATENATE '-' wa_down-lfimg INTO wa_down-lfimg.
    ENDIF.

    CONDENSE wa_down-fkimg.
    IF wa_final-fkimg < 0.
      CONCATENATE '-' wa_down-fkimg INTO wa_down-fkimg.
    ENDIF.

    CONDENSE wa_down-pnd_qty.
    IF wa_final-pnd_qty < 0.
      CONCATENATE '-' wa_down-pnd_qty INTO wa_down-pnd_qty.
    ENDIF.

    CONDENSE wa_down-kbetr.
    IF wa_final-kbetr < 0.
      CONCATENATE '-' wa_down-kbetr INTO wa_down-kbetr.
    ENDIF.

    CONDENSE wa_down-amont.
    IF wa_final-amont < 0.
      CONCATENATE '-' wa_down-amont INTO wa_down-amont.
    ENDIF.

    CONDENSE wa_down-ordr_amt.
    IF wa_final-ordr_amt < 0.
      CONCATENATE '-' wa_down-ordr_amt INTO wa_down-ordr_amt.
    ENDIF.

    CONDENSE wa_down-stprs.
    IF wa_final-stprs < 0.
      CONCATENATE '-' wa_down-stprs INTO wa_down-stprs.
    ENDIF.

    wa_down-ettyp       = wa_final-ettyp.
    wa_down-waerk       = wa_final-waerk.
    wa_down-zseries     = wa_final-zseries.
    wa_down-zsize       = wa_final-zsize.
    wa_down-brand       = wa_final-brand.
    wa_down-moc         = wa_final-moc.
    wa_down-type        = wa_final-type.
    wa_down-dispo       = wa_final-dispo.
    wa_down-mtart       = wa_final-mtart.
    wa_down-zterm       = wa_final-zterm.
    wa_down-inco1       = wa_final-inco1.
    wa_down-inco2       = wa_final-inco2.
    wa_down-text1       = wa_final-text1.
    wa_down-bname       = wa_final-bname.
    wa_down-eccn        = wa_final-eccn.
    wa_down-abgru       = wa_final-abgru.
    wa_down-bezei       = wa_final-bezei.
    wa_down-ship_code   = wa_final-ship_code.
    wa_down-ship_name   = wa_final-ship_name.
    wa_down-stras       = wa_final-stras    .
    wa_down-pstlz       = wa_final-pstlz    .
    wa_down-ort01       = wa_final-ort01    .
    wa_down-ship_rig    = wa_final-ship_rig.
    wa_down-ship_land   = wa_final-ship_land.


    IF wa_final-bstdk IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-bstdk
        IMPORTING
          output = wa_down-bstdk.
      CONCATENATE wa_down-bstdk+0(2) wa_down-bstdk+2(3) wa_down-bstdk+5(4)
                     INTO wa_down-bstdk SEPARATED BY '-'.
    ENDIF.

    IF wa_final-erdat IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-erdat
        IMPORTING
          output = wa_down-erdat.
      CONCATENATE wa_down-erdat+0(2) wa_down-erdat+2(3) wa_down-erdat+5(4)
                     INTO wa_down-erdat SEPARATED BY '-'.
    ENDIF.

    IF wa_final-vdatu IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-vdatu
        IMPORTING
          output = wa_down-vdatu.
      CONCATENATE wa_down-vdatu+0(2) wa_down-vdatu+2(3) wa_down-vdatu+5(4)
                     INTO wa_down-vdatu SEPARATED BY '-'.
    ENDIF.

    IF wa_final-holddate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-holddate
        IMPORTING
          output = wa_down-holddate.
      CONCATENATE wa_down-holddate+0(2) wa_down-holddate+2(3) wa_down-holddate+5(4)
                     INTO wa_down-holddate SEPARATED BY '-'.
    ENDIF.

    IF wa_final-holdreldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-holdreldate
        IMPORTING
          output = wa_down-holdreldate.
      CONCATENATE wa_down-holdreldate+0(2) wa_down-holdreldate+2(3) wa_down-holdreldate+5(4)
                     INTO wa_down-holdreldate SEPARATED BY '-'.
    ENDIF.

    IF wa_final-canceldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-canceldate
        IMPORTING
          output = wa_down-canceldate.
      CONCATENATE wa_down-canceldate+0(2) wa_down-canceldate+2(3) wa_down-canceldate+5(4)
                     INTO wa_down-canceldate SEPARATED BY '-'.
    ENDIF.

    IF wa_final-deldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-deldate
        IMPORTING
          output = wa_down-deldate.
      CONCATENATE wa_down-deldate+0(2) wa_down-deldate+2(3) wa_down-deldate+5(4)
                     INTO wa_down-deldate SEPARATED BY '-'.
    ENDIF.

    IF wa_final-custdeldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-custdeldate
        IMPORTING
          output = wa_down-custdeldate.
      CONCATENATE wa_down-custdeldate+0(2) wa_down-custdeldate+2(3) wa_down-custdeldate+5(4)
                     INTO wa_down-custdeldate SEPARATED BY '-'.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_down-ref.

    CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
    INTO wa_down-ref SEPARATED BY '-'.


    wa_down-ref_time = sy-uzeit.

    CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

    wa_down-tag_no   = wa_final-tag_no.       "code added by pankaj 14.01.2022
    wa_down-ship_from = wa_final-ship_from.    "code added by shreya 15-02-2022
    wa_down-ofm_date_new = wa_final-ofm_date_new. " code added by shreya 17-03-2022
    wa_down-deloyed_remark = wa_final-deloyed_remark. " Added by Pranit 24.01.2024
    wa_down-bstkd          = wa_final-bstkd. " Added by Pranit 24.01.2024
    wa_down-posex          = wa_final-posex. " Added by Pranit 24.01.2024
    wa_down-zbstkd         = wa_final-zbstkd. ""Added by Pranit 21.02.2024
    wa_down-zposex         = wa_final-zposex. ""Added by Pranit 21.02.2024
*    wa_down-remark         = wa_final-remark. ""Added by Pranit 01.03.2024
    wa_down-ernam          = wa_final-ernam. ""Added by Pranit 27.03.2024
    wa_down-erdat1         = wa_final-erdat. ""Added by Pranit 27.03.2024
    wa_down-reason_hc = wa_final-reason_hc.                  """added by supriya 17:06:2024
    wa_down-delay_item_remark = wa_final-delay_item_remark.   "added by aakashk 05.08.2024
    wa_down-zmrp_delay = wa_final-zmrp_delay.   "added by PRANIT 19.11.2024


    IF wa_final-erdat IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-erdat
        IMPORTING
          output = wa_down-erdat.
      CONCATENATE wa_down-erdat+0(2) wa_down-erdat+2(3) wa_down-erdat+5(4)
                     INTO wa_down-erdat SEPARATED BY '-'.
    ENDIF.

    wa_down-erdat1         = wa_down-erdat. ""Added by Pranit 27.03.2024

    IF wa_final-mbdat IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-mbdat
        IMPORTING
          output = wa_down-mbdat.
      CONCATENATE wa_down-mbdat+0(2) wa_down-mbdat+2(3) wa_down-mbdat+5(4)
                     INTO wa_down-mbdat SEPARATED BY '-'.
    ENDIF.

    APPEND wa_down TO it_down.
    CLEAR wa_down.

  ENDLOOP.


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
*  BREAK primus.
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
  lv_file = 'ZUSANEWPENDSOALL.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZUSANEWPENDSOALL Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_2272 TYPE string.
    DATA lv_crlf_2272 TYPE string.
    lv_crlf_2272 = cl_abap_char_utilities=>cr_lf.
    lv_string_2272 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_2272 lv_crlf_2272 wa_csv INTO lv_string_2272.
      CLEAR: wa_csv.
    ENDLOOP.
    TRANSFER lv_string_2272 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


*************************************
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
  lv_file = 'ZUSANEWPENDSOALL.TXT'.

  CONCATENATE p_folder '/'  lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZUSANEWPENDSOALL Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_2308 TYPE string.
    DATA lv_crlf_2308 TYPE string.
    lv_crlf_2308 = cl_abap_char_utilities=>cr_lf.
    lv_string_2308 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_2308 lv_crlf_2308 wa_csv INTO lv_string_2308.
      CLEAR: wa_csv.
    ENDLOOP.
    TRANSFER lv_string_2308 TO lv_fullfile.
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
FORM cvs_header   USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE 'Plant'
              'Order Type'
              'Customer PO No'
              'Customer PO Date'
              'Customer Code'
              'Customer Name'
              'Sales Rep. No'
              'Sales Rep. Name'
              'Customer Group'
              'Customer Group Desc'
              'Industry Sector'
              'Industry Sector Desc'
              'Sales Office'
              'Sales Doc No'
              'So Date'
              'Required Delivery Dt'
              'Hold/Unhold'
              'Hold Date'
              'Release Date'
              'Cancelled Date'
              'Delivery Date'
              'Shipping Method'
              'Service Charge'
              'Remark'
              'Item Code'
              'USA Code'
              'Valuation Class'
              'Line Item'
              'Item Description'
              'Material long Text'
              'SO QTY'
              'Delivary Qty'
              'Invoice Quantity'
              'Pending Qty'
              'SO Status'
              'Rate'
              'Currency Type'
              'Pending SO Amount'
              'Order Amount'
              'Standard Cost'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'Type'
              'MRP Controller'
              'MAT TYPE'
              'Payment Terms'
              'Payment Terms Text'
              'Inco Terms'
              'Inco Terms Descr'
              'Customer Delivery Date'
              'Contact Person'
              'ECCN'
              'Rejection Reason Code'
              'Rejection Reason Description'
              'Ship To Party Code'
              'Ship To Party Name'
              'Ship To Party House No'
              'Ship To Party Postal Code'
              'Ship To Party City'
              'Ship To Party Region'
              'Ship To Party Country'
              'Handling Charges '
              'Service Charges'
              'Mounting Charges'
              'Hed.Handling Charges '
              'Hed.Service Charges'
              'Hed.Mounting Charges'
              'Special Instruction'
              'Refresh Date'
              'Refresh Time'
              'Tag No Details'          "added by pankaj 14.01.2022
              'Shipping From'           "added by shreya 15-02-2022
              'OFM Date'                "added by shreya 17.03.2022
              'Material Avail Date'
              'Delayed SO Remark'          ""Added by Pranit 23.01.2024   "ADDED BY AAKASHK 05.08.2024
              'PO Number'               ""Added by Pranit 04.02.2024
              'PO Line Item Number'     ""Added by Pranit 04.02.2024
              'DV IND PO Number'           ""Added by Pranit 21.02.2024
              'DV IND PO Line Item Number' ""Added by Pranit 21.02.2024
*              'Remark'                     ""Added by Pranit 01.03.2024
              'Cretaed By'                     ""Added by Pranit 27.03.2024
              'Created On'                     ""Added by Pranit 27.03.2024
              'Reason for Hold/Cancelled'       ""added by supriya 17:06:2024
               'Delay Item Remarks'         "added by aakashk 05.08.2024
               'Target Date Delay(Reason)'

  INTO pd_csv
  SEPARATED BY l_field_seperator.
ENDFORM.
