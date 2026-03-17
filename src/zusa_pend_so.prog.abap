*&---------------------------------------------------------------------*
*& Report ZUSA_PEND_SO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zusa_pend_so.


TABLES: vbrp,vbak,vbap.

TYPES: BEGIN OF ty_data,
         vbeln TYPE vbeln,
         posnr TYPE posnr,

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
          vbeln       TYPE vbap-vbeln,
          posnr       TYPE vbap-posnr,
          matnr       TYPE vbap-matnr,
          holddate    TYPE vbap-holddate,
          holdreldate TYPE vbap-holdreldate,
          canceldate  TYPE vbap-canceldate,
          deldate     TYPE vbap-deldate,
          custdeldate TYPE vbap-custdeldate,
*          ZMRP_DELAY TYPE vbap-ZMRP_DELAY,
          ZWHSE_BACK      TYPE VBAP-ZWHSE_BACK    ,
          ZASSM_BACK      TYPE VBAP-ZASSM_BACK    ,
        ZTRAN_DELAY     TYPE VBAP-ZTRAN_DELAY   ,
        ZLCL_DELAYS     TYPE VBAP-ZLCL_DELAYS   ,
        ZOTHER_COMMENT  TYPE VBAP-ZOTHER_COMMENT,
        ZOTHER_REMARK   TYPE VBAP-ZOTHER_REMARK ,
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


        BEGIN OF ty_final,
          werks       TYPE vbap-werks,
          auart       TYPE vbak-auart,
          bstnk       TYPE vbak-bstnk,
          bstdk       TYPE vbak-bstdk,
          kunnr       TYPE vbak-kunnr,
          name1       TYPE kna1-name1,
          partner     TYPE kna1-kunnr,
          part_name   TYPE kna1-name1,
          kdgrp       TYPE knvv-kdgrp,
          ktext       TYPE t151t-ktext,
          brsch       TYPE t016t-brsch,
          brtxt       TYPE t016t-brtxt,
          vkbur       TYPE vbak-vkbur,
          vbeln       TYPE vbak-vbeln,
          erdat       TYPE vbak-erdat,
          vdatu       TYPE vbak-vdatu,
          status      TYPE tj30t-txt30,
          holddate    TYPE vbap-holddate,
          holdreldate TYPE vbap-holdreldate,
          canceldate  TYPE vbap-canceldate,
          deldate     TYPE vbap-deldate,
          tpi         TYPE char100,
          TAG_REQ     TYPE char100,
          ld_txt      TYPE char100,
          matnr       TYPE mara-matnr,
          wrkst       TYPE mara-wrkst,
          bklas       TYPE mbew-bklas,
          posnr       TYPE vbap-posnr,
          arktx       TYPE vbap-arktx,
          mattxt      TYPE text100,
          kwmeng      TYPE vbap-kwmeng,
          lfimg       TYPE lips-lfimg,
          fkimg       TYPE vbrp-fkimg,
          pnd_qty     TYPE vbrp-fkimg,
          ettyp       TYPE vbep-ettyp,
          edatu       TYPE vbep-edatu,
          etenr       TYPE vbep-etenr,
          kbetr       TYPE prcd_elements-kbetr,
          waerk       TYPE vbak-waerk,
          amont       TYPE kbetr,
          ordr_amt    TYPE kbetr,
          stprs       TYPE mbew-stprs,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          brand       TYPE mara-brand,
          moc         TYPE mara-moc,
          type        TYPE mara-type,
          mtart       TYPE mara-mtart,
          dispo       TYPE marc-dispo,
          zterm       TYPE vbkd-zterm,
          text1       TYPE t052u-text1,
          inco1       TYPE vbkd-inco1,
          inco2       TYPE vbkd-inco2,
          custdeldate TYPE vbap-custdeldate,
          bname       TYPE vbak-bname,
          eccn        TYPE char100,
          abgru       TYPE vbap-abgru,
          bezei       TYPE  tvagt-bezei,
          ship_code   TYPE kna1-kunnr,
          ship_name   TYPE kna1-name1,
          STRAS       TYPE kna1-STRAS,
          PSTLZ       TYPE kna1-PSTLZ,
          ORT01       TYPE kna1-ORT01,
          SHIP_RIG    TYPE T005U-BEZEI,
          SHIP_LAND   TYPE T005T-LANDX,
          UHF1        TYPE prcd_elements-KBETR,
          USC1        TYPE prcd_elements-KBETR,
          UMC1        TYPE prcd_elements-KBETR,
          HUHF1       TYPE prcd_elements-KBETR,
          HUSC1       TYPE prcd_elements-KBETR,
          HUMC1       TYPE prcd_elements-KBETR,
          spl_ins     TYPE char250,
          ZMRP_DELAY  TYPE CHAR250,
        END OF ty_final,

                BEGIN OF ty_down,
          werks       TYPE vbap-werks,
          auart       TYPE vbak-auart,
          bstnk       TYPE vbak-bstnk,
          bstdk       TYPE char15,
          kunnr       TYPE vbak-kunnr,
          name1       TYPE kna1-name1,
          partner     TYPE kna1-kunnr,
          part_name   TYPE kna1-name1,
          kdgrp       TYPE knvv-kdgrp,
          ktext       TYPE t151t-ktext,
          brsch       TYPE t016t-brsch,
          brtxt       TYPE t016t-brtxt,
          vkbur       TYPE vbak-vkbur,
          vbeln       TYPE vbak-vbeln,
          erdat       TYPE char15,
          vdatu       TYPE char15,
          status      TYPE tj30t-txt30,
          holddate    TYPE char15,
          holdreldate TYPE char15,
          canceldate  TYPE char15,
          deldate     TYPE char15,
          tpi         TYPE char100,
          TAG_REQ     TYPE char100,
          ld_txt      TYPE char100,
          matnr       TYPE mara-matnr,
          wrkst       TYPE mara-wrkst,
          bklas       TYPE mbew-bklas,
          posnr       TYPE vbap-posnr,
          arktx       TYPE vbap-arktx,
          mattxt      TYPE text100,
          kwmeng      TYPE char15,
          lfimg       TYPE char15,
          fkimg       TYPE char15,
          pnd_qty     TYPE char15,
          ettyp       TYPE vbep-ettyp,
          kbetr       TYPE char15,
          waerk       TYPE vbak-waerk,
          amont       TYPE char15,
          ordr_amt    TYPE char15,
          stprs       TYPE char15,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          brand       TYPE mara-brand,
          moc         TYPE mara-moc,
          type        TYPE mara-type,
          dispo       TYPE marc-dispo,
          mtart       TYPE mara-mtart,
          zterm       TYPE vbkd-zterm,
          text1       TYPE t052u-text1,
          inco1       TYPE vbkd-inco1,
          inco2       TYPE vbkd-inco2,
          custdeldate TYPE char15,
          bname       TYPE vbak-bname,
          eccn        TYPE char100,
          abgru       TYPE vbap-abgru,
          bezei       TYPE  tvagt-bezei,
          ship_code   TYPE kna1-kunnr,
          ship_name   TYPE kna1-name1,
          STRAS       TYPE kna1-STRAS,
          PSTLZ       TYPE kna1-PSTLZ,
          ORT01       TYPE kna1-ORT01,
          SHIP_RIG    TYPE T005U-BEZEI,
          SHIP_LAND   TYPE T005T-LANDX,
          UHF1        TYPE char15,
          USC1        TYPE char15,
          UMC1        TYPE char15,
          HUHF1       TYPE char15,
          HUSC1       TYPE char15,
          HUMC1       TYPE char15,
          spl_ins     TYPE char250,
          ZMRP_DELAY  TYPE CHAR250,
          REF         TYPE CHAR15,
          REF_TIME    TYPE CHAR18,
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

      IT_TVAGT   TYPE TABLE OF TY_TVAGT,
      WA_TVAGT   TYPE TY_TVAGT,

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
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\usa'.
SELECTION-SCREEN END OF BLOCK b5.


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
  BREAK primus.
  SELECT a~vbeln a~posnr
  INTO TABLE it_data
  FROM  vbap AS a
  JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
  WHERE a~erdat  IN s_date
  AND   a~matnr  IN s_matnr
  AND   a~werks  IN s_werks
  AND   a~vbeln  IN s_vbeln
  AND   a~custdeldate IN s_ddate
  AND   b~lfsta  NE 'C'.

  SELECT a~vbeln a~posnr
          INTO TABLE it_delete
          FROM  vbap AS a
          JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
          JOIN vbak AS c ON ( c~vbeln = a~vbeln )
          WHERE a~erdat  IN s_date
          AND   a~matnr  IN s_matnr
          AND   a~werks  IN s_werks
          AND   a~vbeln  IN s_vbeln
          AND   a~custdeldate IN s_ddate
          AND   b~gbsta  = 'C'
          AND   c~auart IN ( 'US04', 'US05', 'US06' ).


  LOOP AT it_delete INTO wa_delete .
    DELETE it_data WHERE vbeln = wa_delete-vbeln AND posnr = wa_delete-posnr.
  ENDLOOP.

  SELECT a~vbeln a~posnr
     APPENDING TABLE it_data
     FROM  vbap AS a
     JOIN  lipsup AS c ON ( c~vgbel = a~vbeln  AND c~vgpos = a~posnr )
     WHERE a~erdat  IN s_date
     AND   a~matnr  IN s_matnr
     AND   a~werks  IN s_werks
     AND   a~vbeln  IN s_vbeln
     AND   a~custdeldate IN s_ddate
     AND c~gbsta NE 'C'.

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
*           ZMRP_DELAY
           ZWHSE_BACK
           ZASSM_BACK
           ZTRAN_DELAY
           ZLCL_DELAYS
           ZOTHER_COMMENT
           ZOTHER_REMARK
           FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbakp
           WHERE vbeln = it_vbakp-vbeln
             AND posnr = it_vbakp-posnr_i.


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

    SELECT SPRAS
           ABGRU
           BEZEI
           FROM TVAGT INTO TABLE IT_TVAGT
           FOR ALL ENTRIES IN IT_VBAKP
           WHERE  ABGRU = IT_VBAKP-ABGRU_I
             AND SPRAS = 'E'.


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

*      IF wa_vbap-ZMRP_DELAY EQ 'WHSE_BACK'.
*        WA_FINAL-zmrp_delay = 'Whse Backlog'.
*        ELSEIF wa_vbap-ZMRP_DELAY EQ 'ASSEM_BACK'.
*        WA_FINAL-zmrp_delay = 'Assembly Backlog'.
*        ELSEIF wa_vbap-ZMRP_DELAY EQ 'TRAN_DELAY'.
*        WA_FINAL-zmrp_delay = 'Transit Delays'.
*        ELSEIF wa_vbap-ZMRP_DELAY EQ 'LCL_DELAY'.
*        WA_FINAL-zmrp_delay = 'LCL Delays'.
*        ELSEIF wa_vbap-ZMRP_DELAY EQ 'OTHER'.
*        WA_FINAL-zmrp_delay = 'Other w/c Comments'.
*      ENDIF.

     IF wa_vbap-ZWHSE_BACK EQ 'X'.       """Added by Pranit 18.11.2024
       DATA(GV_WHSE) = 'Whse Backlog'.
       CONCATENATE  GV_WHSE wa_final-zmrp_delay INTO wa_final-zmrp_delay SEPARATED BY ' '.
     endif.
     IF wa_vbap-ZASSM_BACK EQ 'X'.
        DATA(GV_ASSM) = 'Assembly Backlog'.
        CONCATENATE wa_final-zmrp_delay GV_ASSM iNTO wa_final-zmrp_delay SEPARATED BY ','.
     endif.
      IF wa_vbap-ZTRAN_DELAY EQ 'X'.
        DATA(GV_TRANS) = 'Transit Delays'.
        CONCATENATE wa_final-zmrp_delay GV_TRANS INTO wa_final-zmrp_delay SEPARATED BY ','.
     endif.
      IF wa_vbap-ZLCL_DELAYS EQ 'X'.
        DATA(GV_LCL) = 'LCL Delays'.
        CONCATENATE wa_final-zmrp_delay GV_lcl INTO wa_final-zmrp_delay SEPARATED BY ','.
     endif.
      IF wa_vbap-ZOTHER_COMMENT EQ 'X'.
       DATA(GV_OTHER) = WA_VBAP-ZOTHER_REMARK.
       CONCATENATE wa_final-zmrp_delay GV_OTHER INTO wa_final-zmrp_delay SEPARATED BY ','.
      ENDIF.

*      CONCATENATE GV_WHSE GV_ASSM GV_TRANS GV_LCL GV_OTHER INTO wa_final-zmrp_delay SEPARATED BY ','.


      if wa_final-zmrp_delay is NOT INITIAL.
   DATA(lv_str) = strlen( wa_final-zmrp_delay ).
   data(lv_count) = lv_Str - 1.
    if wa_final-zmrp_delay+0(1) = ','.
     wa_final-zmrp_delay+0(1) = ' '.
   endif.

*   if wa_final-zmrp_delay+LV_count(1) = ','.
*     wa_final-zmrp_delay+LV_count(1) = ' '.
*   endif.
   endif.
















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

     READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_VBAKP-VBELN PARVW = 'WE'.
      IF SY-SUBRC = 0.
        READ TABLE IT_SHIP INTO WA_SHIP WITH KEY KUNNR = WA_VBPA-KUNNR.
        IF SY-SUBRC = 0.
          WA_FINAL-SHIP_NAME = WA_SHIP-NAME1.
          wa_FINAL-ship_code = wa_ship-kunnr.
          WA_FINAL-STRAS     = WA_SHIP-STRAS.
          WA_FINAL-PSTLZ     = WA_SHIP-PSTLZ.
          WA_FINAL-ORT01     = WA_SHIP-ORT01.

        ENDIF.

      ENDIF.

    READ TABLE IT_T005U INTO WA_T005U WITH KEY SPRAS = 'EN' LAND1 = WA_SHIP-LAND1 BLAND = WA_SHIP-REGIO.
      IF SY-SUBRC = 0.
        WA_FINAL-SHIP_RIG = WA_T005U-BEZEI.
      ENDIF.

      READ TABLE IT_T005T INTO WA_T005T WITH KEY SPRAS = 'EN' LAND1 = WA_SHIP-LAND1 .
      IF SY-SUBRC = 0.
        WA_FINAL-SHIP_LAND = WA_T005T-LANDX.
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
*        WA_FINAL-BSTKD       = WA_VBKD-BSTKD.           "Cust Ref No.
      wa_final-zterm       = wa_vbkd-zterm.           "payment terms
      wa_final-inco1       = wa_vbkd-inco1.           "inco terms
      wa_final-inco2       = wa_vbkd-inco2.           "inco terms description
    ENDIF.

    READ TABLE it_tvzbt INTO wa_tvzbt WITH KEY zterm = wa_final-zterm.
    IF sy-subrc = 0.
      wa_final-text1  = wa_tvzbt-vtext.
    ENDIF.

    READ TABLE IT_TVAGT INTO WA_TVAGT WITH KEY  ABGRU = WA_VBAKP-ABGRU_I  SPRAS = 'E'.
     IF sy-subrc = 0.
       WA_final-BEZEI   =  WA_TVAGT-BEZEI.
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

    READ TABLE lv_lines INTO wa_lines INDEX 1.
    IF wa_lines IS NOT INITIAL.
      wa_final-ld_txt = wa_lines-tdline.
    ENDIF.

*Tag Required
      CLEAR: LV_LINES, wa_lines.
      REFRESH LV_LINES.
      LV_NAME = WA_final-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'U006'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      READ TABLE LV_LINES INTO wa_lines INDEX 1.
      IF wa_lines IS NOT INITIAL.
        WA_Final-TAG_REQ = wa_lines-tdline.
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


    CLEAR: LV_LINES, wa_lines,LV_NAME.
      REFRESH LV_LINES.
      CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z888'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBP'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-TDLINE IS INITIAL..


          CONCATENATE WA_FINAL-spl_ins wa_lines-TDLINE  INTO WA_FINAL-spl_ins SEPARATED BY SPACE.

        ENDIF.
        ENDLOOP.
      ENDIF.


    CLEAR: wa_vbfa, wa_lfimg, wa_lfimg_sum.

    LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_final-vbeln
                                 AND posnv = wa_final-posnr
                                 AND vbtyp_n = 'J'.

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


      CLEAR: WA_KONV .
      READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAKP-KNUMV
                                                    KPOSN = WA_VBAKP-POSNR_i
                                                    KSCHL = 'UHF1' .
      IF SY-SUBRC EQ 0.

        IF wa_konv-kgrpe = 'X'.
          ON CHANGE OF WA_VBAKP-KNUMV.
          WA_FINAL-HUHF1       = WA_KONV-KBETR.           "Rate
          ENDON.
        ELSE.
          WA_FINAL-UHF1       = WA_KONV-KBETR.           "Rate
        ENDIF.

      ENDIF.

     CLEAR: WA_KONV .
     READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAKP-KNUMV
                                                    KPOSN = WA_VBAKP-POSNR_I
                                                    KSCHL = 'USC1' .
      IF SY-SUBRC EQ 0.
        IF wa_konv-kgrpe = 'X'.
          ON CHANGE OF WA_VBAKP-KNUMV.
          WA_FINAL-HUSC1       = WA_KONV-KBETR.           "Rate
          ENDON.
        ELSE.
          WA_FINAL-USC1       = WA_KONV-KBETR.           "Rate
        ENDIF.

      ENDIF.

      CLEAR: WA_KONV .
      READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAKP-KNUMV
                                                    KPOSN = WA_VBAKP-POSNR_I
                                                    KSCHL = 'UMC1' .

      IF SY-SUBRC EQ 0.
        IF wa_konv-kgrpe = 'X'.
          ON CHANGE OF WA_VBAKP-KNUMV.
          WA_FINAL-HUMC1       = WA_KONV-KBETR.           "Rate
          ENDON.
        ELSE.
          WA_FINAL-UMC1       = WA_KONV-KBETR.           "Rate
        ENDIF.

      ENDIF.

      IF WA_final-AUART = 'US03'.
        WA_final-PND_QTY = WA_final-PND_QTY * -1.
      ENDIF.

      WA_final-AMONT       = WA_final-PND_QTY * WA_final-KBETR .
      WA_final-ORDR_AMT    = WA_final-KWMENG * WA_final-KBETR .




IF WA_FINAL-AUART = 'US03'.
  WA_FINAL-KWMENG    = WA_FINAL-KWMENG * -1.
  WA_FINAL-LFIMG     = WA_FINAL-LFIMG * -1.
  WA_FINAL-FKIMG     = WA_FINAL-FKIMG * -1.
  WA_FINAL-ORDR_AMT  = WA_FINAL-ORDR_AMT * -1.
ENDIF.

IF WA_FINAL-AUART = 'US12' .
  WA_FINAL-KWMENG    = WA_FINAL-KWMENG * -1.
  WA_FINAL-PND_QTY   = WA_FINAL-PND_QTY * -1.
  WA_FINAL-AMONT     = WA_FINAL-AMONT * -1.
  WA_FINAL-ORDR_AMT  = WA_FINAL-ORDR_AMT * -1.
ENDIF.

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

  PERFORM fcat USING : '1'    'WERKS'       'IT_FINAL'  'Plant'                    '15' ,
                        '2'    'AUART'       'IT_FINAL'  'Order Type'                    '15' ,
                        '3'    'BSTNK'       'IT_FINAL'  'Customer PO No'                    '15' ,
                        '4'    'BSTDK'       'IT_FINAL'  'Customer PO Date'                    '15' ,
                        '5'    'KUNNR'       'IT_FINAL'  'Customer Code'                    '15' ,
                        '6'    'NAME1'       'IT_FINAL'  'Customer Name'                    '15' ,
                        '7'    'PARTNER'     'IT_FINAL'  'Sales Rep. No'                    '15' ,
                        '8'    'PART_NAME'   'IT_FINAL'  'Sales Rep. Name'                    '15' ,
                        '9'    'KDGRP'       'IT_FINAL'  'Customer Group'                    '15' ,
                        '10'    'KTEXT'       'IT_FINAL'  'Customer Group Desc'                    '15' ,
                        '11'    'BRSCH'       'IT_FINAL'  'Industry Sector'                    '15' ,
                        '12'    'BRTXT'       'IT_FINAL'  'Industry Sector Desc'                    '15' ,
                        '13'    'VKBUR'       'IT_FINAL'  'Sales Office'                    '15' ,
                        '14'    'VBELN'       'IT_FINAL'  'Sales Doc No'                    '15' ,
                        '15'    'ERDAT'       'IT_FINAL'  'So Date'                    '15' ,
                        '16'    'VDATU'       'IT_FINAL'  'Required Delivery Dt'                    '15' ,
                        '17'    'STATUS'       'IT_FINAL'  'Hold/Unhold'                    '15' ,

                        '18'    'HOLDDATE'         'IT_FINAL'  'Hold Date'                          '15' ,
                        '19'    'HOLDRELDATE'          'IT_FINAL'  'Release Date'                       '15' ,
                        '20'    'CANCELDATE'       'IT_FINAL'  'Cancelled Date'                     '15' ,
                        '21'    'DELDATE'          'IT_FINAL'  'Delivery Date'                      '15' ,
                        '22'    'TPI'              'IT_FINAL'  'Shipping Method'                    '15' ,
                        '23'    'TAG_REQ'          'IT_FINAL'  'Service Charge'                     '15' ,
                        '24'    'LD_TXT'           'IT_FINAL'  'Remark'                             '15' ,
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

                        '38'    'AMONT'            'IT_FINAL'   'Pending SO Amount'                      '15' ,
                        '39'    'ORDR_AMT'         'IT_FINAL'   'Order Amount'                      '15' ,
                        '40'    'STPRS'            'IT_FINAL'   'Standard Cost'                      '15' ,
                        '41'    'ZSERIES'          'IT_FINAL'   'Series'                    '15' ,
                        '42'    'ZSIZE'            'IT_FINAL'   'Size'                    '15' ,
                        '43'    'BRAND'            'IT_FINAL'   'Brand'                    '15' ,
                        '44'    'MOC'              'IT_FINAL'   'MOC'                    '15' ,
                        '45'    'TYPE'             'IT_FINAL'   'Type'                    '15' ,
                        '46'    'DISPO'            'IT_FINAL'    'MRP Controller'                    '15' ,
                        '47'    'MTART'            'IT_FINAL'    'MAT TYPE'                    '15' ,
                        '48'    'ZTERM'            'IT_FINAL'    'Payment Terms'                    '15' ,
                        '49'    'TEXT1'            'IT_FINAL'    'Payment Terms Text'                    '15' ,
                        '50'    'INCO1'            'IT_FINAL'    'Inco Terms'                    '15' ,
                        '51'    'INCO2'            'IT_FINAL'    'Inco Terms Descr'                    '15' ,
                        '52'    'CUSTDELDATE'      'IT_FINAL'    'Customer Delivery Date'                   '15' ,
                        '53'    'BNAME'            'IT_FINAL'    'Contact Person'                   '15' ,
                        '54'    'ECCN'             'IT_FINAL'    'ECCN'                   '15' ,
                        '55'    'ABGRU'            'IT_FINAL'    'Rejection Reason Code'                     '15' ,
                        '56'    'BEZEI'            'IT_FINAL'    'Rejection Reason Description'                     '15' ,
                        '57'    'SHIP_CODE'        'IT_FINAL'    'Ship To Party Code'                     '15' ,
                        '58'    'SHIP_NAME'        'IT_FINAL'    'Ship To Party Name'                     '15' ,
                        '59'    'STRAS'            'IT_FINAL'    'Ship To Party House No'                     '15' ,
                        '60'    'PSTLZ'            'IT_FINAL'    'Ship To Party Postal Code'                     '15' ,
                        '61'    'ORT01'            'IT_FINAL'    'Ship To Party City'                     '15' ,
                        '62'    'SHIP_RIG'         'IT_FINAL'    'Ship To Party Region'                     '15' ,
                        '63'    'SHIP_LAND'        'IT_FINAL'    'Ship To Party Country'                     '15' ,
                        '64'    'UHF1'             'IT_FINAL'    'Handling Charges '                    '15' ,
                        '65'    'USC1'             'IT_FINAL'    'Service Charges'                    '15' ,
                        '66'    'UMC1'             'IT_FINAL'    'Mounting Charges'                    '15' ,
                        '67'    'HUHF1'            'IT_FINAL'    'Hed.Handling Charges '                    '15' ,
                        '68'    'HUSC1'            'IT_FINAL'    'Hed.Service Charges'                    '15' ,
                        '69'    'HUMC1'            'IT_FINAL'    'Hed.Mounting Charges'                    '15' ,
                        '70'    'SPL_INS'          'IT_FINAL'    'Special Instruction'                    '15' ,
                        '71'    'ZMRP_DELAY'       'IT_FINAL'    'Target Date Delay(Reason)'                      '100' .
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
  ls_header-info = 'Pending So Report'.
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
    WA_DOWN-WERKS       = WA_FINAL-WERKS.
    WA_DOWN-AUART       = WA_FINAL-AUART.
    WA_DOWN-BSTNK       = WA_FINAL-BSTNK.
    WA_DOWN-KUNNR       = WA_FINAL-KUNNR.
    WA_DOWN-NAME1       = WA_FINAL-NAME1.
    WA_DOWN-PARTNER     = WA_FINAL-PARTNER.
    WA_DOWN-PART_NAME   = WA_FINAL-PART_NAME.
    WA_DOWN-KDGRP       = WA_FINAL-KDGRP.
    WA_DOWN-KTEXT       = WA_FINAL-KTEXT.
    WA_DOWN-BRSCH       = WA_FINAL-BRSCH.
    WA_DOWN-BRTXT       = WA_FINAL-BRTXT.
    WA_DOWN-VKBUR       = WA_FINAL-VKBUR.
    WA_DOWN-VBELN       = WA_FINAL-VBELN.
    WA_DOWN-STATUS      = WA_FINAL-STATUS.

    WA_DOWN-TPI         = WA_FINAL-TPI.
    WA_DOWN-TAG_REQ     = WA_FINAL-TAG_REQ.
    WA_DOWN-LD_TXT      = WA_FINAL-LD_TXT.
    WA_DOWN-MATNR       = WA_FINAL-MATNR.
    WA_DOWN-WRKST       = WA_FINAL-WRKST.
    WA_DOWN-BKLAS       = WA_FINAL-BKLAS.
    WA_DOWN-POSNR       = WA_FINAL-POSNR.
    WA_DOWN-ARKTX       = WA_FINAL-ARKTX.

    WA_DOWN-MATTXT      = WA_FINAL-MATTXT.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN WA_DOWN-MATTXT WITH ' & '.

    WA_DOWN-KWMENG      = ABS( WA_FINAL-KWMENG ).
    WA_DOWN-LFIMG       = ABS( WA_FINAL-LFIMG ).
    WA_DOWN-FKIMG       = ABS( WA_FINAL-FKIMG ).
    WA_DOWN-PND_QTY     = ABS( WA_FINAL-PND_QTY ).
    WA_DOWN-AMONT       = ABS( WA_FINAL-AMONT ).
    WA_DOWN-ORDR_AMT    = ABS( WA_FINAL-ORDR_AMT ).
    WA_DOWN-STPRS       = ABS( WA_FINAL-STPRS ).
    WA_DOWN-UHF1        = ABS( WA_FINAL-UHF1 ).
    WA_DOWN-USC1        = ABS( WA_FINAL-USC1 ).
    WA_DOWN-UMC1        = ABS( WA_FINAL-UMC1 ).
    WA_DOWN-HUHF1       = ABS( WA_FINAL-HUHF1 ).
    WA_DOWN-HUSC1       = ABS( WA_FINAL-HUSC1 ).
    WA_DOWN-HUMC1       = ABS( WA_FINAL-HUMC1 ).
    WA_DOWN-KBETR       = ABS( WA_FINAL-KBETR ).

    CONDENSE WA_DOWN-UHF1.
    IF WA_FINAL-UHF1 < 0.
      CONCATENATE '-' WA_DOWN-UHF1 INTO WA_DOWN-UHF1.
    ENDIF.

    CONDENSE WA_DOWN-USC1.
    IF WA_FINAL-USC1 < 0.
      CONCATENATE '-' WA_DOWN-USC1 INTO WA_DOWN-USC1.
    ENDIF.

    CONDENSE WA_DOWN-UMC1.
    IF WA_FINAL-UMC1 < 0.
      CONCATENATE '-' WA_DOWN-UMC1 INTO WA_DOWN-UMC1.
    ENDIF.


    CONDENSE WA_DOWN-HUHF1.
    IF WA_FINAL-HUHF1 < 0.
      CONCATENATE '-' WA_DOWN-HUHF1 INTO WA_DOWN-HUHF1.
    ENDIF.

    CONDENSE WA_DOWN-HUSC1.
    IF WA_FINAL-HUSC1 < 0.
      CONCATENATE '-' WA_DOWN-HUSC1 INTO WA_DOWN-HUSC1.
    ENDIF.

    CONDENSE WA_DOWN-HUMC1.
    IF WA_FINAL-HUMC1 < 0.
      CONCATENATE '-' WA_DOWN-HUMC1 INTO WA_DOWN-HUMC1.
    ENDIF.

    CONDENSE WA_DOWN-KWMENG.
    IF WA_FINAL-KWMENG < 0.
      CONCATENATE '-' WA_DOWN-KWMENG INTO WA_DOWN-KWMENG.
    ENDIF.


    CONDENSE WA_DOWN-LFIMG.
    IF WA_FINAL-LFIMG < 0.
      CONCATENATE '-' WA_DOWN-LFIMG INTO WA_DOWN-LFIMG.
    ENDIF.

    CONDENSE WA_DOWN-FKIMG.
    IF WA_FINAL-FKIMG < 0.
      CONCATENATE '-' WA_DOWN-FKIMG INTO WA_DOWN-FKIMG.
    ENDIF.

    CONDENSE WA_DOWN-PND_QTY.
    IF WA_FINAL-PND_QTY < 0.
      CONCATENATE '-' WA_DOWN-PND_QTY INTO WA_DOWN-PND_QTY.
    ENDIF.

    CONDENSE WA_DOWN-KBETR.
    IF WA_FINAL-KBETR < 0.
      CONCATENATE '-' WA_DOWN-KBETR INTO WA_DOWN-KBETR.
    ENDIF.

    CONDENSE WA_DOWN-AMONT.
    IF WA_FINAL-AMONT < 0.
      CONCATENATE '-' WA_DOWN-AMONT INTO WA_DOWN-AMONT.
    ENDIF.

    CONDENSE WA_DOWN-ORDR_AMT.
    IF WA_FINAL-ORDR_AMT < 0.
      CONCATENATE '-' WA_DOWN-ORDR_AMT INTO WA_DOWN-ORDR_AMT.
    ENDIF.

    CONDENSE WA_DOWN-STPRS.
    IF WA_FINAL-STPRS < 0.
      CONCATENATE '-' WA_DOWN-STPRS INTO WA_DOWN-STPRS.
    ENDIF.

    WA_DOWN-ETTYP       = WA_FINAL-ETTYP.
    WA_DOWN-WAERK       = WA_FINAL-WAERK.
    WA_DOWN-ZSERIES     = WA_FINAL-ZSERIES.
    WA_DOWN-ZSIZE       = WA_FINAL-ZSIZE.
    WA_DOWN-BRAND       = WA_FINAL-BRAND.
    WA_DOWN-MOC         = WA_FINAL-MOC.
    WA_DOWN-TYPE        = WA_FINAL-TYPE.
    WA_DOWN-DISPO       = WA_FINAL-DISPO.
    WA_DOWN-MTART       = WA_FINAL-MTART.
    WA_DOWN-ZTERM       = WA_FINAL-ZTERM.
    WA_DOWN-INCO1       = WA_FINAL-INCO1.
    WA_DOWN-INCO2       = WA_FINAL-INCO2.
    WA_DOWN-TEXT1       = WA_FINAL-TEXT1.
    WA_DOWN-BNAME       = WA_FINAL-BNAME.
    WA_DOWN-ECCN        = WA_FINAL-ECCN.
    WA_DOWN-ABGRU       = WA_FINAL-ABGRU.
    WA_DOWN-BEZEI       = WA_FINAL-BEZEI.
    WA_DOWN-ship_code   = WA_FINAL-ship_code.
    WA_DOWN-SHIP_NAME   = WA_FINAL-SHIP_NAME.
    WA_DOWN-STRAS       = WA_FINAL-STRAS    .
    WA_DOWN-PSTLZ       = WA_FINAL-PSTLZ    .
    WA_DOWN-ORT01       = WA_FINAL-ORT01    .
    WA_DOWN-SHIP_RIG    = WA_FINAL-SHIP_RIG.
    WA_DOWN-SHIP_LAND   = WA_FINAL-SHIP_LAND.
    WA_DOWN-zmrp_delay  = WA_FINAL-zmrp_delay.

    IF WA_FINAL-BSTDK IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BSTDK
        IMPORTING
          OUTPUT = WA_DOWN-BSTDK.
      CONCATENATE WA_DOWN-BSTDK+0(2) WA_DOWN-BSTDK+2(3) WA_DOWN-BSTDK+5(4)
                     INTO WA_DOWN-BSTDK SEPARATED BY '-'.
    ENDIF.

    IF WA_FINAL-ERDAT IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-ERDAT
        IMPORTING
          OUTPUT = WA_DOWN-ERDAT.
      CONCATENATE WA_DOWN-ERDAT+0(2) WA_DOWN-ERDAT+2(3) WA_DOWN-ERDAT+5(4)
                     INTO WA_DOWN-ERDAT SEPARATED BY '-'.
    ENDIF.

    IF WA_FINAL-VDATU IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-VDATU
        IMPORTING
          OUTPUT = WA_DOWN-VDATU.
      CONCATENATE WA_DOWN-VDATU+0(2) WA_DOWN-VDATU+2(3) WA_DOWN-VDATU+5(4)
                     INTO WA_DOWN-VDATU SEPARATED BY '-'.
    ENDIF.

    IF WA_FINAL-HOLDDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-HOLDDATE
        IMPORTING
          OUTPUT = WA_DOWN-HOLDDATE.
      CONCATENATE WA_DOWN-HOLDDATE+0(2) WA_DOWN-HOLDDATE+2(3) WA_DOWN-HOLDDATE+5(4)
                     INTO WA_DOWN-HOLDDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_FINAL-HOLDRELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-HOLDRELDATE
        IMPORTING
          OUTPUT = WA_DOWN-HOLDRELDATE.
      CONCATENATE WA_DOWN-HOLDRELDATE+0(2) WA_DOWN-HOLDRELDATE+2(3) WA_DOWN-HOLDRELDATE+5(4)
                     INTO WA_DOWN-HOLDRELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_FINAL-CANCELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-CANCELDATE
        IMPORTING
          OUTPUT = WA_DOWN-CANCELDATE.
      CONCATENATE WA_DOWN-CANCELDATE+0(2) WA_DOWN-CANCELDATE+2(3) WA_DOWN-CANCELDATE+5(4)
                     INTO WA_DOWN-CANCELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_FINAL-DELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-DELDATE
        IMPORTING
          OUTPUT = WA_DOWN-DELDATE.
      CONCATENATE WA_DOWN-DELDATE+0(2) WA_DOWN-DELDATE+2(3) WA_DOWN-DELDATE+5(4)
                     INTO WA_DOWN-DELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_FINAL-CUSTDELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-CUSTDELDATE
        IMPORTING
          OUTPUT = WA_DOWN-CUSTDELDATE.
      CONCATENATE WA_DOWN-CUSTDELDATE+0(2) WA_DOWN-CUSTDELDATE+2(3) WA_DOWN-CUSTDELDATE+5(4)
                     INTO WA_DOWN-CUSTDELDATE SEPARATED BY '-'.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = WA_DOWN-ref.

    CONCATENATE WA_DOWN-ref+0(2) WA_DOWN-ref+2(3) WA_DOWN-ref+5(4)
    INTO WA_DOWN-ref SEPARATED BY '-'.


    WA_DOWN-ref_time = sy-uzeit.

    CONCATENATE WA_DOWN-ref_time+0(2) ':' WA_DOWN-ref_time+2(2)  INTO WA_DOWN-ref_time.


    APPEND WA_DOWN TO IT_DOWN.
    CLEAR WA_DOWN.

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
      i_tab_sap_data       = IT_DOWN
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
  lv_file = 'ZUSANEWPENDSO.TXT'.

  CONCATENATE p_folder '\' SY-DATUM SY-UZEIT LV_FILE
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZUSANEWPENDSO Download started on', sy-datum, 'at', sy-uzeit.
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


*************************************
CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = IT_DOWN
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
  lv_file = 'ZUSANEWPENDSO.TXT'.

  CONCATENATE p_folder '\'  LV_FILE
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZUSANEWPENDSO Download started on', sy-datum, 'at', sy-uzeit.
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
FORM cvs_header   USING    PD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

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
              'Target Date Delay(Reason)'
              'Refresh Date'
              'Refresh Time'

  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
