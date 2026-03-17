*&---------------------------------------------------------------------*
*& Report ZUS_STOCK_PLANNING                                           *
* 1.PROGRAM OWNER       : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : STOCK PLANNING REPORT DEVLOPMENT
* 3.PROGRAM NAME            : ZUS_STOCK_PLANNING                           *
* 4.TRANS CODE              : zus_stock                                 *
* 5.MODULE NAME             : MM.                                 *
* 6.REQUEST NO              :PRIMUS:US:ABAP:AB:NEW STOCK PLANNING REPORT:23.01.2018   DEVK905500                              *
* 7.CREATION DATE           : 14 .12.2018.                              *
* 8.CREATED BY              : AVINASH BHAGAT.                          *
* 9.FUNCTIONAL CONSULTANT   : PRANAV KHADAKAR.                                   *
* 10.BUSINESS OWNER         : DELVAL US PLANT.                                *
*&---------------------------------------------------------------------*
report zus_stock_planning.

tables : mara,mard,mseg,ekpo,eket,vbbe,msku.

types : begin of ty_mara,
          matnr   type mara-matnr,
          zseries type mara-zseries,
          zsize   type mara-zsize,
          brand   type mara-brand,
          moc     type mara-moc,
          type    type mara-type,
          wrkst   type mara-wrkst,
*          bwart   TYPE mara-bwart,
        end of ty_mara.

data : it_mara type standard table of ty_mara,
       wa_mara type ty_mara.

types : begin of ty_vbbe,
          matnr type vbbe-matnr,
          werks type vbbe-werks,
          omeng type vbbe-omeng,
        end of ty_vbbe.

data : it_vbbe type standard table of ty_vbbe,
       wa_vbbe type ty_vbbe.

types : begin of ty_mard,
          matnr type mard-matnr,
          lgort type mard-lgort,
          werks type mard-werks,
          labst type mard-labst,
        end of ty_mard.

data : it_mard type standard table of ty_mard,
       wa_mard type ty_mard.

types : begin of ty_msku,
          matnr type msku-matnr,
          werks type msku-werks,
          charg type msku-charg,
          sobkz type msku-sobkz,
          kunnr type msku-kunnr,
          kulab type msku-kulab,
        end of ty_msku.

data : it_msku type standard table of ty_msku,
       wa_msku type ty_msku.

types : begin of ty_mseg,
          matnr    type mseg-matnr,
          mblnr    type mseg-mblnr,
          bwart    type mseg-bwart,
          werks    type mseg-werks,
          vbeln_im type mseg-vbeln_im,
          vbelp_im type mseg-vbelp_im,
          menge    type mseg-menge,
          shkzg    type mseg-shkzg,
        end of ty_mseg.

        types : begin of ty_mseg1,
          matnr    type mseg-matnr,
          shkzg    type mseg-shkzg,
          menge    type mseg-menge,
          menge1    type mseg-menge,
          werks     type mseg-werks,
        end of ty_mseg1.

data : it_mseg type standard table of ty_mseg,
       wa_mseg type ty_mseg.

data : it_is1 type standard table of ty_mseg1,
       wa_is1 type ty_mseg1.

data : it_is2 type standard table of ty_mseg1,
       wa_is2 type ty_mseg1.

types : begin of ty_rev,
          mblnr   type mseg-mblnr,
          zeile   type mseg-zeile,
          line_id type mseg-line_id,
          bwart   type mseg-bwart,
          matnr   type mseg-matnr,
          werks   type mseg-werks,
          menge   type mseg-menge,
          smbln   type mseg-smbln,
        end of ty_rev.

data : it_rev type standard table of ty_rev,
       wa_rev type ty_rev.

data : it_rev1 type standard table of ty_rev,
       wa_rev1 type ty_rev.

data : it_mseg_105 type standard table of ty_mseg,
       wa_mseg_105 type ty_mseg.

types: begin of ty_ekpo,
         matnr type ekpo-matnr,
         ebeln type ekpo-ebeln,
         ebelp type ekpo-ebelp,
         menge type ekpo-menge,
         loekz type ekpo-loekz,
         elikz type ekpo-elikz,
         werks type ekpo-werks,
         retpo type ekpo-retpo,
       end of ty_ekpo.
*
*DATA : it_ekpo TYPE STANDARD TABLE OF ty_ekpo,
*       wa_ekpo TYPE ty_ekpo.
*
data : it_ekpo1 type standard table of ty_ekpo,
       wa_ekpo1 type ty_ekpo.
*
*TYPES : BEGIN OF ty_eket,
*          ebeln TYPE ekpo-ebeln,
*          ebelp TYPE ekpo-ebelp,
*          wemng TYPE eket-wemng,
*        END OF ty_eket.
*
*DATA : it_eket TYPE STANDARD TABLE OF ty_eket,
*       wa_eket TYPE ty_eket.

types : begin of ty_ekpo_eket,

          ebeln type ekpo-ebeln,
          ebelp type ekpo-ebelp,
          matnr type ekpo-matnr,
          menge type ekpo-menge,
          loekz type ekpo-loekz,
          elikz type ekpo-elikz,
          werks type ekpo-werks,
          retpo type ekpo-retpo,

*  ebeln TYPE ekpo-ebeln,
*  ebelp TYPE ekpo-ebelp,
          wemng type eket-wemng,

        end of ty_ekpo_eket.

   types : begin of ty_vbrk,
         vbeln type vbrk-vbeln,
         fkart type vbrk-fkart,
         fktyp type vbrk-fktyp,
         vkorg type vbrk-vkorg,
         vtweg type vbrk-vtweg,
         fkdat type vbrk-fkdat,
         fksto type vbrk-fksto,
               end of ty_vbrk.

       data : it_vbrk type standard table of ty_vbrk,
       wa_vbrk type ty_vbrk.

   types :   begin of ty_vbrk1,
        vbeln  type vbrk-vbeln,
        fkart  type vbrk-fkart,
        fkdat  type vbrk-fkdat,
        knumv  type vbrk-knumv,
        rfbsk  type vbrk-rfbsk,
        kunag  type vbrk-kunag,
        exnum  type vbrk-exnum,
        xblnr  type vbrk-xblnr,
        logsys type vbrk-logsys,
        fksto  type vbrk-fksto,
      end of ty_vbrk1.

  data : it_vbrk1 type standard table of ty_vbrk1,
       wa_vbrk1 type ty_vbrk1.

    types :    begin of ty_vbrp_vapma,
         vbeln type vbrp-vbeln,
         posnr type vbrp-posnr,
         fkimg type vbrp-fkimg,
         vgbel type char35, "CHAR16,
         vgpos type vbrp-vgpos,
         aubel type vbrp-aubel,
         aupos type vbrp-aupos,
         matnr type vbrp-matnr,
         werks type vbrp-werks,
         vkorg type vapma-vkorg,
         bstnk type vapma-bstnk,
         kunnr type vapma-kunnr,
       end of ty_vbrp_vapma.


       data : it_vbrp_vapma type standard table of ty_vbrp_vapma,
       wa_vbrp_vapma type ty_vbrp_vapma.

      types :             begin of ty_konv,
        knumv type PRCD_ELEMENTS-knumv,
        kposn type PRCD_ELEMENTS-kposn,
        kschl type PRCD_ELEMENTS-kschl,
        kbetr type PRCD_ELEMENTS-kbetr,
        kwert type PRCD_ELEMENTS-kwert,
      end of ty_konv.


    data :      it_konv    type table of ty_konv,
      wa_konv    type          ty_konv.


        types :      begin of ty_eikp,
        exnum type eikp-exnum,
        iever type eikp-iever,
      end of ty_eikp.

     data :        it_eikp    type table of ty_eikp,
      wa_eikp    type          ty_eikp.

         types :        begin of ty_t618t,
        spras type t618t-spras,
        land1 type t618t-land1,
        expvz type t618t-expvz,
        bezei type t618t-bezei,
      end of ty_t618t.


     data :     it_t618t   type table of ty_t618t,
      wa_t618t   type          ty_t618t.

         types :     begin of ty_mode,
        expvz type ztransit-expvz,
        bezei type ztransit-bezei,
        zdays type ztransit-zdays,
      end of ty_mode.

       data :       it_mode    type table of ty_mode,
      wa_mode    type          ty_mode.

           types :        begin of ty_likp1,
        vbeln type likp-vbeln,
        verur type likp-verur,
        trspg type likp-trspg,
      end of ty_likp1.

         data :       it_likp1    type table of ty_likp1,
      wa_likp1    type          ty_likp1.

        types :         begin of ty_mseg2,
        mblnr(16)," TYPE mseg-mblnr,
        mjahr      type mseg-mjahr,
        bwart      type mseg-bwart,
        matnr      type mseg-matnr,
        werks      type mseg-werks,
        smbln      type mseg-smbln,
        xblnr_mkpf type mseg-xblnr_mkpf,
        vbeln_im   type mseg-vbeln_im,
        vbelp_im   type mseg-vbelp_im,
      end of ty_mseg2.

    data :      it_mseg2  type table of ty_mseg2,
      wa_mseg2  type          ty_mseg2.

     types :  begin of ty_mseg_new,
         mblnr(16)," TYPE mseg-mblnr,
         mjahr      type mseg-mjahr,
         bwart      type mseg-bwart,
         matnr      type mseg-matnr,
         werks      type mseg-werks,
         smbln      type mseg-smbln,
         xblnr_mkpf type mseg-xblnr_mkpf,
         vbeln_im   type mseg-vbeln_im,
         vbelp_im   type mseg-vbelp_im,
         menge      type mseg-menge,
       end of ty_mseg_new.

    data :  it_mseg_new11 type table of ty_mseg_new,
      wa_mseg_new11 type          ty_mseg_new.

         types :
       begin of ty_mseg_1,
        mblnr(16)," TYPE mseg-mblnr,
        mjahr      type mseg-mjahr,
        bwart      type mseg-bwart,
        matnr      type mseg-matnr,
        werks      type mseg-werks,
        smbln      type mseg-smbln,
        xblnr_mkpf type mseg-xblnr_mkpf,
        vbeln_im   type mseg-vbeln_im,
        vbelp_im   type mseg-vbelp_im,
      end of ty_mseg_1.

  data: it_mseg1       type table of ty_mseg_1,
      wa_mseg1      type          ty_mseg_1.

    types :  begin of ty_bkpf,
        belnr type bkpf-belnr,
        blart type bkpf-blart,
        xblnr type bkpf-xblnr,
        stblg type bkpf-stblg,
      end of ty_bkpf.


     data:   it_bkpf1   type table of ty_bkpf,
      wa_bkpf1   type          ty_bkpf.

    types :  begin of ty_likp,
         vbeln type likp-vbeln,
         verur type likp-verur,
         trspg type likp-trspg,
       end of ty_likp.

data :  it_likp type table of ty_likp,
      wa_likp   type          ty_likp.

 types : begin of str_vbap,
         vbeln  type vbap-vbeln,
         posnr  type vbap-posnr,
         matnr  type vbap-matnr,
         kwmeng type vbap-kwmeng,
         posex  type vbap-posex,
       end of str_vbap.

 data : lt_vbap type table of str_vbap,
        ls_vbap   type          str_vbap.


  types :   begin of ty_ekpo_1,
         ebeln type vbak-bstnk, "ekpo-ebeln,
         ebelp type ekpo-ebelp,
         werks type ekpo-werks,
         menge type ekpo-menge,
         matnr type ekpo-matnr,
       end of ty_ekpo_1.

  data : it_ekpo       type table of ty_ekpo_1,
         wa_ekpo       type          ty_ekpo_1.


        data :   it_bkpf    type table of ty_bkpf,
      wa_bkpf    type          ty_bkpf.

  types : begin of ty_trasnit,
         matnr    type mara-matnr,
         ebeln    type ekpo-ebeln,
         ebelp    type ekpo-ebelp,
         fkimg    type vbrp-fkimg,
         vbeln_im type mseg-vbeln_im,
         werks    type ekpo-werks,
       end of ty_trasnit.

 data : it_trasnit    type table of ty_trasnit,
        wa_trasnit    type          ty_trasnit.


   types :begin of ty_trans,
          matnr type mara-matnr,
          fkimg type vbrp-fkimg,
          werks type vbrp-werks,
          end of ty_trans.

  data :it_trans      type table of ty_trans,
        wa_trans      type          ty_trans.

 types : begin of ty_marc,
         matnr type matnr,
         werks type werks,
*         bwesb type bwesb,
*         glgmg type glgmg,
*         trame type trame,
*         umlmc type marc-umlmc,
       end of ty_marc.

  data : it_marc       type table of ty_marc,
         wa_marc       type          ty_marc.

data : it_ekpo_eket type standard table of ty_ekpo_eket,
       wa_ekpo_eket type ty_ekpo_eket.

types : begin of ty_vbap,
          vbeln  type vbap-vbeln,
          posnr  type vbap-posnr,
          matnr  type vbap-matnr,
          werks  type vbap-werks,
          kwmeng type vbap-kwmeng,
        end of ty_vbap.

data: it_vbap type table of ty_vbap,
      wa_vbap type          ty_vbap.

types :begin of ty_vbup,
         vbeln type vbup-vbeln,
         posnr type vbup-posnr,
         lfgsa type vbup-lfgsa,
       end of ty_vbup.

data :it_vbup type table of ty_vbup,
      wa_vbup type          ty_vbup.

types : begin of ty_lips,
          vbeln type lips-vbeln,
          posnr type lips-posnr,
          vgbel type lips-vgbel,
          vgpos type lips-vgpos,
          matnr type lips-matnr,
          werks type lips-werks,
          lfimg type lips-lfimg,
        end of ty_lips.

data: it_lips type table of ty_lips,
      wa_lips type          ty_lips.


types : begin of ty_mara_mard,
          matnr   type mara-matnr,
          zseries type mara-zseries,
          zsize   type mara-zsize,
          brand   type mara-brand,
          moc     type mara-moc,
          type    type mara-type,
          wrkst   type mara-wrkst,

          werks   type mard-werks,
*          labst   TYPE mard-labst,
        end of ty_mara_mard.

data : it_mara_mard type standard table of ty_mara_mard,
       wa_mara_mard type ty_mara_mard.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
types : begin of ty_vbakp,
          vbeln    type vbak-vbeln,
          posnr_i  type vbap-posnr,
          erdat    type vbak-erdat,
          ernam    type vbak-ernam,
          audat    type vbak-audat,
          vbtyp    type vbak-vbtyp,
          auart    type vbak-auart,
          netwr    type vbak-netwr,
          waerk    type vbak-waerk,
          vkorg    type vbak-vkorg,
          vtweg    type vbak-vtweg,
          vkbur    type vbak-vkbur,
          knumv    type vbak-knumv,
          vdatu    type vbak-vdatu,
          bstnk    type vbak-bstnk,
          bstdk    type vbak-bstdk,
          bname    type vbak-bname,
          kunnr    type vbak-kunnr,
          vgbel    type vbak-vgbel,
          objnr    type vbak-objnr,
          matnr_i  type vbap-matnr,
          matkl_i  type vbap-matkl,
          arktx_i  type vbap-arktx,
          abgru_i  type vbap-abgru,
          kwmeng_i type vbap-kwmeng,
          werks_i  type vbap-werks,
        end of ty_vbakp.

 types :  begin of ty_vbfa,
          vbelv   type vbfa-vbelv,
          posnv   type vbfa-posnv,
          vbeln   type vbfa-vbeln,
          vbtyp_n type vbfa-vbtyp_n,
          erdat   type vbfa-erdat,
        end of ty_vbfa.

data: it_vbakp   type table of ty_vbakp,
      wa_vbakp   type ty_vbakp.

data: it_vbakp1   type table of ty_vbakp,
      wa_vbakp1   type ty_vbakp.


 types :  begin of ty_jest,
          objnr type jest-objnr,
          stat  type jest-stat,
          chgnr type jest-chgnr,
          inact type jest-inact,
        end of ty_jest.

 data:   it_jest    type table of ty_jest,
      wa_jest    type ty_jest.

data: it_vbfa    type table of ty_vbfa,
      wa_vbfa    type  ty_vbfa.

data : wa_lfimg     type lips-lfimg,
       wa_lfimg_sum type lips-lfimg,
       wa_fkimg     type lips-lfimg,
       wa_fkimg_sum type lips-lfimg.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
types : begin of ty_vbak,
          vbeln type vbak-vbeln,
*  posnr  type vbak-posnr,
          vbtyp type vbak-vbtyp,
        end of ty_vbak.

data : it_vbak type table of ty_vbak,
       wa_vbak type ty_vbak.

types: begin of ty_data,
         vbeln  type vbeln,
         posnr  type posnr,
         matnr  type matnr,
         werks  type werks,
         kwmeng type kwmeng,
         abgru  type abgru,
         auart  type auart,
       end of ty_data.

data: it_data type standard table of ty_data,
      wa_data type ty_data.

types:      BEGIN OF ty_mska,
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
      END OF ty_mska.

 data:  it_mska    TYPE TABLE OF ty_mska,
      wa_mska    TYPE          ty_mska.

types: begin of ty_open_inv,
         vbeln type lips-vbeln,
         posnr type lips-posnr,
         matnr type lips-matnr,
         werks type lips-werks,
         lfimg type lips-lfimg,
         vkbur type lips-vkbur,
         pstyv type lips-pstyv,
         fksta type vbup-fksta,
       end of ty_open_inv.

data: it_open_inv type table of ty_open_inv,
      wa_open_inv type          ty_open_inv.
types : begin of ty_final,
          matnr       type mara-matnr,
          zseries     type mara-zseries,
          zsize       type mara-zsize,
          brand       type mara-brand,
          moc         type mara-moc,
          type        type mara-type,
          wrkst       type mara-wrkst,

          vbeln       type vbap-vbeln,
          posnr       type vbap-posnr,
          lfgsa       type vbup-lfgsa,
          auart       type  vbak-auart,
          kwmeng      type vbap-kwmeng,
          fkimg       type vbrp-fkimg,
          vgbel       type lips-vgbel,
          vgpos       type lips-vgpos,
          lfimg       type lips-lfimg,

          werks       type mard-werks,
          labst       type p decimals 0,

          omeng       type vbbe-omeng,

          kulab       type p decimals 0,

          bwart       type mseg-bwart,
          vbeln_im    type mseg-vbeln_im,
          vbelp_im    type mseg-vbelp_im,
          mseg_menge  type mseg-menge,
          mseg_menge1 type mseg-menge,
          mblnr       type mseg-mblnr,
          smbln       type mseg-smbln,

          ebeln       type ekpo-ebeln,
          ebelp       type ekpo-ebelp,
          menge       type ekpo-menge,
          loekz       type ekpo-loekz,
          elikz       type ekpo-elikz,

          wemng       type eket-wemng,
*          lv_desc     TYPE tdline,
          mattxt      type text100,
          free_stock  type p decimals 0,
          tran_qty    type p decimals 0,
          so_fall_qty type p decimals 0,
          menge2      type string,
          menge3      type string,
          menge4      type string,
*          pend_po_qty TYPE string,
          pend_po_qty type p decimals 0,
          indent_qty  type p decimals 0,
          open_qty    type p decimals 0,
          vbap_qty    type vbrp-fkimg,
          lips_qty    type vbrp-fkimg,
          retpo       type ekpo-retpo,
          neg         type string,
          open_inv    type p decimals 0,

        end of ty_final.

data : it_final type standard table of ty_final,
       wa_final type ty_final.

types: begin of str_final,
        matnr    type mara-matnr,
        wrkst    type mara-wrkst,
        zseries  type mara-zseries,
        zsize    type mara-zsize,
        brand    type mara-brand,
        moc      type mara-moc,
        type     type mara-type,
*      maktx       TYPE makt-maktx,
        desc     type char100,
        ebeln    type ekpo-ebeln,
        ebelp    type ekpo-ebelp,
        menge    type ekpo-menge,
        lifnr    type lfa1-lifnr,
        name1    type lfa1-name1,
        vbeln    type vbap-vbeln,
        posnr    type vbap-posnr,
        kwmeng   type char15,
        inv_no   type vbrp-vbeln,
        inv_line type vbrp-posnr,
        fkimg    type vbrp-fkimg,
        fkdat    type vbrk-fkdat,
        xblnr    type vbrk-xblnr,
        kbetr    type prcd_elements-kbetr,
        kwert    type PRCD_ELEMENTS-kwert,
        pono     type char15,
        bezei    type ztransit-bezei,
        arrival  type sy-datum,
        due      type sy-datum,
        port     type char100,
        place    type string,
        stock    type mard-labst,
        pend     type vbrp-fkimg,
        mblnr    type mseg-mblnr,
        vbeln_im type mseg-vbeln_im,
        belnr    type bkpf-belnr,
        werks    type ekpo-werks,
      end of str_final.

 data :    it_transit type table of str_final,
      wa_transit type          str_final.

  types :    begin of ty_trans1,
        matnr type mara-matnr,
        fkimg type vbrp-fkimg,
          vbeln    type vbap-vbeln,
        posnr    type vbap-posnr,
      end of ty_trans1.

      data : it_trans1 type table of ty_trans1,
       wa_trans1 type          ty_trans1.

types : begin of ty_final_download,
          matnr       type mara-matnr,
          mattxt      type text100,
          wrkst       type mara-wrkst,
          brand       type mara-brand,
          zseries     type mara-zseries,
          zsize       type mara-zsize,
          moc         type mara-moc,
          type        type mara-type,
          open_qty    type char15,
          labst       type char15,
          kulab       type char15,
          free_stock  type char15,
          tran_qty    type char15,
          so_fall_qty type char15,
          pend_po_qty type char15,
          indent_qty  type char15,
          open_inv    type char15,
          werks       type char10,
          ref         type char15,
          ref_time    type char15,
        end of ty_final_download.

data : lt_final type table of ty_final_download,
       ls_final type ty_final_download.

data  : gt_fieldcat type slis_t_fieldcat_alv,
        gs_fieldcat type slis_fieldcat_alv.

data : gt_lines type table of tline,
       ls_lines type tline.

data : lv_desc type tline.

data : pr_count type i.

data : neg type string.
data: lv_name   type thead-tdname,
      lv_lines  type standard table of tline,
      wa_lines  like tline,
      ls_itmtxt type tline,
      ls_mattxt type tline.

selection-screen : begin of block b1 with frame title text-001.
select-options : mat for mara-matnr,
                 plant for mard-werks obligatory default 'US01'.
*PARAMETERS: plant LIKE mard-werks DEFAULT 'US01'.
selection-screen : end of block b1.

selection-screen begin of block b2 with frame title text-002 .
parameters p_down as checkbox.
parameters p_folder like rlgrap-filename default '/Delval/USA'."USA'."USA'."usa'.
selection-screen end of block b2.

selection-screen :begin of block b3 with frame title text-003.
selection-screen  comment /1(60) text-004.
selection-screen comment /1(70) text-005.
selection-screen: end of block b3.


loop at plant.
  if plant-low = 'PL01'.
    plant-low = ' '.
  endif.
  if plant-high = 'PL01'.
    plant-high = ' '.
  endif.
  modify plant.
endloop.


start-of-selection.
  perform get_transit.
  perform get_data.
  perform process_data.
  perform fcat.
  perform display_data.

form get_data .
*  BREAK primus.
  select
    a~matnr
    a~zseries
    a~zsize
    a~brand
    a~moc
    a~type
    a~wrkst
    b~werks
    into table it_mara_mard
    from mara as a
                  inner join mard as b on b~matnr = a~matnr
    where a~matnr in mat and b~werks in plant.

  sort it_mara_mard by matnr werks.
  delete adjacent duplicates from it_mara_mard comparing matnr werks.

  delete it_mara_mard where werks = 'PL01'.

  select a~vbeln a~posnr a~matnr a~werks a~kwmeng a~abgru
      into table it_data
      from  vbap as a
      join  vbup as b on ( b~vbeln = a~vbeln  and b~posnr = a~posnr )
      for all entries in it_mara_mard
      where a~matnr = it_mara_mard-matnr
      and   a~werks = it_mara_mard-werks
      and   a~abgru = ' '
      and   b~lfsta  ne 'C'.

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
               FOR ALL ENTRIES IN it_data
               WHERE matnr = it_data-matnr
               AND   werks IN ('US01','US02','US03')
               AND   sobkz = 'E'.
      DELETE IT_MSKA WHERE  kalab EQ 0 AND kains EQ 0 AND  kaspe EQ 0 AND kavla EQ 0 AND kavin EQ 0 AND kavsp EQ 0 AND kavei EQ 0.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""logic for transit qty

  select a~vbeln a~posnr a~matnr a~werks
     appending table it_data
     from  vbap as a
     join  lipsup as c on ( c~vgbel = a~vbeln  and c~vgpos = a~posnr )
     where  a~matnr  in mat
     and    a~werks  in plant
     and c~gbsta ne 'C'.

    if  it_data is not initial .

      select vbeln
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
           werks_i from wb2_v_vbak_vbap2 into table it_vbakp1
           for all entries in it_data
           where vbeln = it_data-vbeln
             and posnr_i = it_data-posnr.

              if it_vbakp1 is not initial.
        select objnr
           stat
           chgnr
           inact from jest into table it_jest
           for all entries in it_vbakp1
           where objnr = it_vbakp1-objnr
             and stat in ( 'E0001', 'E0002','E0003' )
             and inact ne 'X'.
      endif.
         loop at it_jest into wa_jest.
           read table it_vbakp1 into wa_vbakp1 with key objnr = wa_jest-objnr.
           if sy-subrc is initial.
             delete it_data where vbeln  = wa_vbakp1-vbeln.
           endif.
         endloop.

  endif.

  IF it_data is NOT INITIAL.

    select vbeln
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
           werks_i from wb2_v_vbak_vbap2 into table it_vbakp
           for all entries in it_data
           where vbeln = it_data-vbeln
             and posnr_i = it_data-posnr
             and abgru_i = it_data-abgru.

        ENDIF.

      select vbelv
           posnv
           vbeln
           vbtyp_n
           erdat
           from vbfa into table it_vbfa
           for all entries in it_vbakp
           where vbelv = it_vbakp-vbeln
           and  vbtyp_n in ( 'J', 'M' ,'T' , 'O' ).

        if it_vbfa is not initial.
    select vbeln
           fkart
           fktyp
           vkorg
           vtweg
           fkdat
           fksto
           from vbrk into table it_vbrk
           for all entries in it_vbfa
           where vbeln = it_vbfa-vbeln
             and fksto ne 'X'.
  endif.

          select a~vbeln
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
         into table it_vbrp_vapma
          from vbrp as a
          join vapma as b
         on ( b~vbeln = a~aubel and b~posnr = a~aupos )
         for all entries in it_vbrk
         where a~vbeln = it_vbrk-vbeln
         and b~kunnr = '0000300000'
        .
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  select a~vbeln a~posnr a~matnr a~werks a~lfimg a~vkbur a~pstyv b~fksta
        into table it_open_inv
        from  lips as a
        join  vbup as b on ( b~vbeln = a~vbeln  and b~posnr = a~posnr )
      for all entries in it_mara_mard
        where a~matnr = it_mara_mard-matnr
        and   a~werks  = it_mara_mard-werks
        and   a~vkbur  = 'US01'
        and   a~pstyv  = 'ZTAN'
        and   b~fksta  ne 'C'.


  select
     vbeln
     vbtyp
     from vbak
     into table it_vbak
     for all entries in it_data
     where vbeln = it_data-vbeln
     and   vbtyp in ( 'C' , 'I' , 'H' ).

  select
    vbeln
    posnr
    vgbel
    vgpos
    matnr
    werks
    lfimg
    from lips
    into table it_lips
           for all entries in it_data
           where vgbel = it_data-vbeln
            and  vgpos = it_data-posnr.


  if it_mara_mard is not initial.
    select matnr
           zseries
           zsize
           brand
           moc
           type
           wrkst   from mara into table it_mara
           for all entries in it_mara_mard
           where matnr = it_mara_mard-matnr.


    select
          matnr
          lgort
          werks
          labst
          from mard
          into table it_mard
          for all entries in it_mara_mard
          where matnr = it_mara_mard-matnr
            and werks = it_mara_mard-werks.
  endif.

  if it_mara_mard is not initial.
    select
      matnr
      werks
      omeng
      from vbbe
      into table it_vbbe
      for all entries in it_mara_mard
      where matnr eq it_mara_mard-matnr and werks eq it_mara_mard-werks.
  endif.

  if it_mara_mard is not initial .
    select
      matnr
      werks
      charg
      sobkz
      kunnr
      kulab
      from msku
      into table it_msku
      for all entries in it_mara_mard
      where matnr eq it_mara_mard-matnr
       and  werks eq it_mara_mard-werks.
  endif.

  if it_mara_mard is not initial .
    select     """                       COMMENTED BY PRANIT 14.09.2024
      matnr
      mblnr
      bwart
      werks
      vbeln_im
      vbelp_im
      menge
      from mseg
      into table it_mseg
      for all entries in it_mara_mard
      where matnr = it_mara_mard-matnr
      and   werks = it_mara_mard-werks
      and bwart = '103'.

      select matnr
      mblnr
      bwart
      werks
      vbeln_im
      vbelp_im
      menge
      from mseg
      into table it_mseg_105
      for all entries in it_mara_mard
      where matnr = it_mara_mard-matnr
      and   werks = it_mara_mard-werks
      and bwart = '105'.
        endif.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""NEW LOGIC FOR TRANSIT LOGIC



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  if it_mseg is not initial.
    select mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln  from mseg into table it_rev
           for all entries in it_mseg
           where smbln = it_mseg-mblnr
            and  matnr = it_mseg-matnr.
  endif.

  if it_mseg_105 is not initial.
    select mblnr
           zeile
           line_id
           bwart
           matnr
           werks
           menge
           smbln
           from mseg into table it_rev1
           for all entries in it_mseg_105
           where smbln = it_mseg_105-mblnr
            and  matnr = it_mseg_105-matnr.
  endif.



  select a~ebeln
         a~ebelp
         a~matnr
         a~menge
         a~loekz
         a~elikz
         a~werks
         a~retpo
         b~wemng
    into table it_ekpo_eket
from ekpo as a
inner join eket as b
on a~ebeln = b~ebeln
and a~ebelp = b~ebelp
  for all entries in it_mara_mard
  where a~matnr eq it_mara_mard-matnr and a~werks eq it_mara_mard-werks
  and a~loekz ne 'L' and a~retpo ne 'X'.


  if it_mara_mard is not initial .
    select
          matnr
          ebeln
          ebelp
          menge
          loekz
          elikz
          werks
          retpo
          from ekpo
          into table it_ekpo1
          for all entries in it_mara_mard
          where matnr eq it_mara_mard-matnr
           and werks eq it_mara_mard-werks
          and retpo eq 'X'.
  endif.

  delete it_vbakp where auart = 'US03' .
  delete it_vbakp where auart = 'US04' .
  delete it_vbakp where auart = 'US05' .
  delete it_vbakp where auart = 'US06' .
  delete it_vbakp where auart = 'US09' .
  delete it_vbakp where auart = 'US10' .
  delete it_vbakp where auart = 'US11' .
  delete it_vbakp where auart = 'US12' .

endform.

form process_data .

  sort it_ekpo1 .

  loop at it_mara_mard into wa_mara_mard.

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
    clear wa_final-labst.
    loop at it_mard into wa_mard where matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks.
      wa_final-labst = wa_final-labst + wa_mard-labst.
    endloop.

    LOOP AT IT_MSKA INTO wa_mska where matnr = wa_mara_mard-matnr AND werks = wa_mara_mard-werks.
      wa_final-labst = wa_final-labst + wa_mska-kalab.
    ENDLOOP.

    clear wa_vbap.
    clear wa_vbup.
    clear wa_lips.
    clear wa_final-vbap_qty.
    clear wa_vbap-kwmeng.

    loop at it_open_inv into wa_open_inv where matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks..
      wa_final-open_inv = wa_final-open_inv + wa_open_inv-lfimg.
    endloop.

    clear wa_vbak.
    clear wa_final-lips_qty.
    clear wa_lips-lfimg.
*    loop at it_data into wa_data where matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks. commented 23.09.2024 new logic for transit qty
*      wa_final-vbeln = wa_data-vbeln.
*      wa_final-posnr = wa_data-posnr.
*      read table it_vbak into wa_vbak with key vbeln = wa_data-vbeln.
*      if sy-subrc = 0.
*        wa_final-vbap_qty = wa_final-vbap_qty + wa_data-kwmeng.
*      endif.
*
*      loop at it_lips into wa_lips where vgbel = wa_final-vbeln and  vgpos = wa_final-posnr.
*        wa_final-lips_qty = wa_final-lips_qty + wa_lips-lfimg.
*      endloop.
*    endloop.
*    *    clear wa_final-open_qty.
*
*    wa_final-open_qty = wa_final-vbap_qty - wa_final-lips_qty .
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  loop at it_vbakp into wa_vbakp where matnr_i = wa_mara_mard-matnr and werks_i = wa_mara_mard-werks.

          wa_final-vbeln = wa_vbakp-vbeln.
          wa_final-posnr = wa_vbakp-posnr_i.
          wa_final-auart = wa_vbakp-auart.
          wa_final-kwmeng = wa_final-kwmeng + wa_vbakp-kwmeng_i.

    loop at it_vbfa into wa_vbfa where vbelv = wa_final-vbeln
                                 and posnv = wa_final-posnr
                                 and vbtyp_n = 'J'.

    clear wa_lfimg.
      select single lfimg from lips into  wa_lfimg  where vbeln = wa_vbfa-vbeln
                                                    and   pstyv = 'ZTAN'
                                                    and   vgbel = wa_final-vbeln
                                                    and   vgpos = wa_final-posnr.
    wa_lfimg_sum = wa_lfimg_sum + wa_lfimg .
    endloop.


    clear: wa_vbfa, wa_fkimg, wa_fkimg_sum.
    loop at it_vbfa into wa_vbfa where vbelv = wa_final-vbeln
                                   and posnv = wa_final-posnr
                                   and vbtyp_n = 'M'.

      clear wa_vbrk.
      read table it_vbrk into wa_vbrk with key   vbeln = wa_vbfa-vbeln.
      if sy-subrc = 0.
        clear wa_fkimg.
        select single fkimg from vbrp into  wa_fkimg  where vbeln = wa_vbrk-vbeln
                                                      and   aubel = wa_final-vbeln
                                                      and   aupos = wa_final-posnr.
        wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
      endif.
    endloop.
    if wa_final-auart = 'US03'.
          clear: wa_vbfa, wa_lfimg, wa_lfimg_sum.

      loop at it_vbfa into wa_vbfa where vbelv = wa_final-vbeln
                                   and posnv = wa_final-posnr
                                   and vbtyp_n = 'T'.

        clear wa_lfimg.
        select single lfimg from lips into  wa_lfimg  where vbeln = wa_vbfa-vbeln
                                                      and   pstyv = 'UREN'   "'ZTAN'
                                                      and   vgbel = wa_final-vbeln
                                                      and   vgpos = wa_final-posnr.
        wa_lfimg_sum = wa_lfimg_sum + wa_lfimg .

      endloop.

      clear: wa_vbfa, wa_fkimg, wa_fkimg_sum.
      loop at it_vbfa into wa_vbfa where vbelv = wa_final-vbeln
                                     and posnv = wa_final-posnr
                                     and vbtyp_n = 'O'.

        clear wa_vbrk.
        read table it_vbrk into wa_vbrk with key   vbeln = wa_vbfa-vbeln.
        if sy-subrc = 0.


          clear wa_fkimg.
          select single fkimg from vbrp into  wa_fkimg  where vbeln = wa_vbrk-vbeln
                                                        and   aubel = wa_final-vbeln
                                                        and   aupos = wa_final-posnr.
          wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
        endif.
      endloop.
    endif.

       wa_final-fkimg     = wa_fkimg_sum.                      "inv qty
       wa_final-open_qty  = wa_final-kwmeng - wa_final-fkimg.  "Pending Qty wa_final-open_qty  = wa_final-kwmeng - wa_final-fkimg.  "Pending Qty
       wa_final-kwmeng = wa_final-open_qty .
  endloop.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    loop at it_msku into wa_msku where matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks.
      wa_final-kulab = wa_final-kulab + wa_msku-kulab   .
    endloop.

*    loop at it_mseg into wa_mseg where  matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks.   COMMENTED BY PRANIT 14.09.2024
*      read table it_rev into wa_rev with key smbln = wa_mseg-mblnr matnr = wa_mseg-matnr.
*      if sy-subrc = 4.
*        wa_final-mseg_menge = wa_final-mseg_menge  + wa_mseg-menge.
*      endif.
*    endloop.
*
*    loop at it_mseg_105 into wa_mseg_105 where  matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks.
*
*      read table it_rev1 into wa_rev1 with key smbln = wa_mseg_105-mblnr matnr = wa_mseg_105-matnr.
*      if sy-subrc = 4.
*        wa_final-mseg_menge1 = wa_final-mseg_menge1  + wa_mseg_105-menge.
*      endif.
*    endloop.
*    clear wa_final-tran_qty.
*    wa_final-tran_qty = wa_final-mseg_menge - wa_final-mseg_menge1.
    read table it_trans into wa_trans with key matnr =  wa_final-matnr werks = wa_final-werks.
    if sy-subrc = 0.
      wa_final-tran_qty = wa_trans-fkimg.
    endif.

    clear wa_final-menge2.
    clear wa_final-menge3.
    clear wa_final-menge4.
    clear wa_ekpo1-menge.
    clear wa_ekpo_eket.

    loop at it_ekpo_eket into wa_ekpo_eket where matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks.
      if wa_ekpo_eket-elikz ne 'X' or wa_ekpo_eket-wemng ne 0.
*    if wa_ekpo_eket-wemng ne 0.
        wa_final-menge2 = wa_final-menge2 + wa_ekpo_eket-menge.
*    endif.
      endif.
      wa_final-menge3 = wa_final-menge3 + wa_ekpo_eket-wemng.
    endloop.

    loop at it_ekpo1 into wa_ekpo1 where matnr = wa_mara_mard-matnr and werks = wa_mara_mard-werks.
*      if sy-subrc = 0.
      wa_final-menge4 = wa_final-menge4 + wa_ekpo1-menge.
*        endif.
    endloop.

    clear wa_final-pend_po_qty.
    wa_final-pend_po_qty = wa_final-menge2 - wa_final-menge3 - wa_final-menge4.

    if wa_final-pend_po_qty lt 0.
      wa_final-pend_po_qty = 0.
    endif.

    clear wa_final-free_stock.
    wa_final-free_stock =  wa_final-labst -  wa_final-open_qty.
    if wa_final-free_stock lt 0.
      wa_final-free_stock = 0.
    endif.

    clear wa_final-so_fall_qty.
    wa_final-so_fall_qty =  wa_final-open_qty - wa_final-labst - wa_final-tran_qty ."- wa_final-pend_po_qty .
    if wa_final-so_fall_qty lt 0.
      wa_final-so_fall_qty = 0.
    endif.

    clear wa_final-indent_qty.
    wa_final-indent_qty =  wa_final-open_qty - ( wa_final-labst + wa_final-pend_po_qty ).

    if wa_final-indent_qty lt 0.
      wa_final-indent_qty = 0.
    endif.


    clear: lv_lines, ls_mattxt.
    refresh lv_lines.
    lv_name = wa_mara_mard-matnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_name
        object                  = 'MATERIAL'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-mattxt wa_lines-tdline into wa_final-mattxt separated by space.
        endif.
      endloop.
      condense wa_final-mattxt.
    endif.

    replace all occurrences of '<(>' in wa_final-mattxt with space.
    replace all occurrences of '<)>' in wa_final-mattxt with space.

    append wa_final to it_final.
    clear : wa_final,ls_final,wa_data.

  endloop.

  if p_down = 'X'.
    loop at it_final into wa_final.
      ls_final-matnr       = wa_final-matnr  .
      ls_final-zseries     = wa_final-zseries.
      ls_final-zsize       = wa_final-zsize  .
      ls_final-brand       = wa_final-brand  .
      ls_final-moc         = wa_final-moc    .
      ls_final-type        = wa_final-type   .
      ls_final-wrkst       = wa_final-wrkst  .
      ls_final-mattxt      = wa_final-mattxt.
      ls_final-labst       = wa_final-labst.
      ls_final-open_qty    = wa_final-open_qty.
      ls_final-kulab       = wa_final-kulab.
      ls_final-tran_qty    = wa_final-tran_qty.
      ls_final-pend_po_qty = wa_final-pend_po_qty.
      ls_final-free_stock  = wa_final-free_stock.
      ls_final-so_fall_qty = wa_final-so_fall_qty.
      ls_final-indent_qty  = wa_final-indent_qty.
      ls_final-open_inv    = wa_final-open_inv.
      ls_final-werks       = wa_final-werks.

      ls_final-ref         = sy-datum.
      ls_final-ref_time    = sy-uzeit.
      concatenate ls_final-ref_time+0(2) ':' ls_final-ref_time+2(2)  into ls_final-ref_time.

      call function 'CONVERSION_EXIT_IDATE_OUTPUT'
        exporting
          input  = ls_final-ref
        importing
          output = ls_final-ref.

      concatenate ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                      into ls_final-ref separated by '-'.

      append ls_final to lt_final.
      clear :ls_final.
    endloop.
  endif.
endform.

form fcat .

  perform build_fc using  '1' pr_count 'MATNR'                 'Material Code'             'IT_FINAL'  '20'.
  perform build_fc using  '1' pr_count 'MATTXT'                'Material Description'      'IT_FINAL'  '50' .
  perform build_fc using  '1' pr_count 'WRKST'                 'USA Material Code'         'IT_FINAL'  '20'.
  perform build_fc using  '1' pr_count 'BRAND'                 'Brand'                     'IT_FINAL'  '5'.
  perform build_fc using  '1' pr_count 'ZSERIES'               'Series'                    'IT_FINAL'  '5'.
  perform build_fc using  '1' pr_count 'ZSIZE'                 'Size'                      'IT_FINAL'  '5'.
  perform build_fc using  '1' pr_count 'MOC'                   'MOC'                       'IT_FINAL'  '5'.
  perform build_fc using  '1' pr_count 'TYPE'                  'Type'                      'IT_FINAL'  '5'.
  perform build_fc using  '1' pr_count 'OPEN_QTY'              'Pending SO in USA'         'IT_FINAL'  '13'.
  perform build_fc using  '1' pr_count 'LABST'                 'Stock In Hand'             'IT_FINAL'  '10'.
  perform build_fc using  '1' pr_count 'KULAB'                 'Consignment Stock'         'IT_FINAL'  '14'.
  perform build_fc using  '1' pr_count 'FREE_STOCK'            'Free Stock'                'IT_FINAL'  '8'.
  perform build_fc using  '1' pr_count 'TRAN_QTY'              'Transit Qty'               'IT_FINAL'  '9'.
  perform build_fc using  '1' pr_count 'SO_FALL_QTY'           'SO Short Fall Qty'         'IT_FINAL'  '13'.
  perform build_fc using  '1' pr_count 'PEND_PO_QTY'           'Pend PO Qty'               'IT_FINAL'  '9'.
  perform build_fc using  '1' pr_count 'INDENT_QTY'            'Indent Qty'                'IT_FINAL'  '8'.
  perform build_fc using  '1' pr_count 'OPEN_INV'              'Open Invoice Qty'          'IT_FINAL'  '15'.
  perform build_fc using  '1' pr_count 'WERKS'                 'Plant'                     'IT_FINAL'  '15'.

endform.

form display_data.
  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP-OF-PAGE'
      it_fieldcat            = gt_fieldcat
    tables
      t_outtab               = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.
  if p_down = 'X'.

    perform download.
*    PERFORM gui_download.
  endif.
endform.

form build_fc  using        pr_row type i
                            pr_count type i
                            pr_fname type string
                            pr_title type string
                            pr_table type slis_tabname
                            pr_length type string.

  pr_count = pr_count + 1.
  gs_fieldcat-row_pos   = pr_row.
  gs_fieldcat-col_pos   = pr_count.
  gs_fieldcat-fieldname = pr_fname.
  gs_fieldcat-seltext_l = pr_title.
  gs_fieldcat-tabname   = pr_table.
  gs_fieldcat-outputlen = pr_length.

  append gs_fieldcat to gt_fieldcat.
  clear gs_fieldcat.

endform.

form top-of-page.

*  ALV Header declarations
  data: t_header      type slis_t_listheader,
        wa_header     type slis_listheader,
        t_line        like wa_header-info,
        ld_lines      type i,
        ld_linesc(10) type c.

*  Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Stock Planning '.
  append wa_header to t_header.
  clear wa_header.



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
  describe table it_final lines ld_lines.
  ld_linesc = ld_lines.

  concatenate 'Total No. of Records Selected: ' ld_linesc
     into t_line separated by space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  append wa_header to t_header.
  clear: wa_header, t_line.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = t_header.
endform.                    " top-of-page



*****************************************Download logic***************************************************

form download .
  type-pools truxs.
  data: it_csv type truxs_t_text_data,
        wa_csv type line of truxs_t_text_data,
        hd_csv type line of truxs_t_text_data.

*  DATA: lv_folder(150).
  data: lv_file(30).
  data: lv_fullfile type string,
        lv_dat(10),
        lv_tim(4).
  data: lv_msg(80).

  call function 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    tables
      i_tab_sap_data       = lt_final
    changing
      i_tab_converted_data = it_csv
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

  perform cvs_header using hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.

*  IF plant = 'US01'.
  lv_file = 'ZUS_STOCK_US01.TXT'.
*  ENDIF.

  concatenate p_folder '/' sy-datum sy-uzeit lv_file
    into lv_fullfile.

  write: / 'Material Stock Planning Report started on', sy-datum, 'at', sy-uzeit.
  open dataset lv_fullfile
    for output in text mode encoding default.  "NON-UNICODE.
  if sy-subrc = 0.
DATA lv_string_1588 TYPE string.
DATA lv_crlf_1588 TYPE string.
lv_crlf_1588 = cl_abap_char_utilities=>cr_lf.
lv_string_1588 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1588 lv_crlf_1588 wa_csv INTO lv_string_1588.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_297 TO lv_fullfile.
TRANSFER lv_string_1588 TO lv_fullfile.
    concatenate 'File' lv_fullfile 'downloaded' into lv_msg separated by space.
    message lv_msg type 'S'.
  endif.


**********************************SQL UPLOAD FILE*************************************

  call function 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    tables
      i_tab_sap_data       = lt_final
    changing
      i_tab_converted_data = it_csv
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

  perform cvs_header using hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.

*  IF plant = 'US01'.
  lv_file = 'ZUS_STOCK_US01.TXT'.
*  ENDIF.

  concatenate p_folder '/' lv_file
    into lv_fullfile.

  write: / 'Material Stock Planning Report started on', sy-datum, 'at', sy-uzeit.
  open dataset lv_fullfile
    for output in text mode encoding default.  "NON-UNICODE.
  if sy-subrc = 0.
DATA lv_string_1628 TYPE string.
DATA lv_crlf_1628 TYPE string.
lv_crlf_1628 = cl_abap_char_utilities=>cr_lf.
lv_string_1628 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1628 lv_crlf_1628 wa_csv INTO lv_string_1628.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_297 TO lv_fullfile.
TRANSFER lv_string_1628 TO lv_fullfile.
    concatenate 'File' lv_fullfile 'downloaded' into lv_msg separated by space.
    message lv_msg type 'S'.
  endif.



endform.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
form cvs_header  using    pd_csv.
  data: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  concatenate'Material Code'
             'Material Description'
             'USA MAterial Code'
             'Brand'
             'Series'
             'Size'
             'MOC'
             'Type'
             'Pending SO in USA'
             'Stock In Hand'
             'Consignment Stock'
             'Free Stock'
             'Transit Qty'
             'SO Short Fall Qty'
             'Pend PO Qty'
             'Indent Qty'
             'Open Invoice Qty'
             'WERKS'
             'Refresh File Date'
             'Refresh File Time'
               into pd_csv
               separated by l_field_seperator.

endform.


**********************************************************************************************************
*&---------------------------------------------------------------------*
*&      Form  GET_TRANSIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_transit .
          select vbeln
     fkart
     fkdat
     knumv
     rfbsk
     kunag
     exnum
     xblnr
     logsys
     fksto
     from vbrk into table it_vbrk1
     where kunag = '0000300000'
       and fksto ne 'X'
       and fkart ne 'ZS1'  and fkart ne 'ZF5'
       and logsys ne ' '.

              if it_vbrk1 is not initial.
    select a~vbeln
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
         into table it_vbrp_vapma
            from vbrp as a
            join vapma as b
            on ( b~vbeln = a~aubel
            and b~posnr = a~aupos
            and a~matnr = b~matnr )
           for all entries in it_vbrk1
           where a~vbeln  = it_vbrk1-vbeln
           and b~kunnr = '0000300000'.

           select knumv
           kposn
           kschl
           kbetr
           kwert from PRCD_ELEMENTS into table it_konv
           for all entries in it_vbrk1
           where knumv = it_vbrk1-knumv
             and kschl = 'ZPR0'.


    select exnum
           iever from eikp into table it_eikp
           for all entries in it_vbrk1
           where exnum = it_vbrk1-exnum.
  endif.


  if it_eikp is not initial.
     select spras
           land1
           expvz
           bezei from t618t into table it_t618t
           for all entries in it_eikp
           where expvz = it_eikp-iever
            and  spras = 'EN'
            and  land1 = 'IN'.
endif.

   select expvz
           bezei
           zdays from ztransit into table it_mode
           for all entries in it_eikp
           where expvz = it_eikp-iever.

if it_vbrp_vapma is not initial.

    select vbeln
           verur
           trspg
           from likp
           into table it_likp1
           for all entries in it_vbrp_vapma
           where verur = it_vbrp_vapma-vgbel.
         sort it_likp1 descending by vbeln.

            select mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im
           menge
     from mseg
     into table it_mseg_new11
     for all entries in it_vbrp_vapma
     where xblnr_mkpf = it_vbrp_vapma-vgbel+(16)
     and bwart eq '103'.
* sort it_mseg_new11 descending by mblnr.
      select mblnr
           mjahr
           bwart
           matnr
           werks
           smbln
           xblnr_mkpf
           vbeln_im
           vbelp_im
     from mseg
     into table it_mseg2
     for all entries in it_vbrp_vapma
     where xblnr_mkpf = it_vbrp_vapma-vgbel+(16)
     and bwart eq '105'.
endif.

    if it_vbrp_vapma is not initial.
    select vbeln
           posnr
           matnr
           kwmeng
           posex from vbap into table lt_vbap
            for all entries in it_vbrp_vapma
           where vbeln = it_vbrp_vapma-aubel
             and posnr = it_vbrp_vapma-aupos.

    select ebeln
           ebelp
           werks
           menge
           matnr from ekpo into table it_ekpo
    for all entries in it_vbrp_vapma
         where ebeln = it_vbrp_vapma-bstnk+0(10).
      endif.

        if it_mseg_new11 is not initial.
*  BREAK PRIMUSUSA.
    select belnr
           blart
           xblnr
           stblg from bkpf into table it_bkpf
           for all entries in it_mseg_new11
           where xblnr = it_mseg_new11-mblnr
             and blart = 'TR'.

         select mblnr
                mjahr
                bwart
                matnr
                werks
                smbln
                xblnr_mkpf
                vbeln_im
                vbelp_im from mseg into table it_mseg1
                for all entries in it_mseg_new11
                where smbln = it_mseg_new11-mblnr+0(10).

  endif.

    if it_bkpf is not initial.

    select belnr
           blart
           xblnr
           stblg from bkpf into table it_bkpf1
           for all entries in it_bkpf
           where stblg = it_bkpf-belnr
            and bukrs = 'US00'. "added by jyoti on 23.07.2024

  endif.

   loop at it_vbrp_vapma into wa_vbrp_vapma where vgbel ne space.
    wa_transit-inv_no   = wa_vbrp_vapma-vbeln.
    wa_transit-inv_line = wa_vbrp_vapma-posnr.
    wa_transit-fkimg    = wa_vbrp_vapma-fkimg.

    read table it_likp1 into wa_likp1 with key verur = wa_vbrp_vapma-vgbel.
    if sy-subrc = 0.
      wa_transit-vbeln_im = wa_likp1-vbeln.
    endif.

    read table it_vbrk1 into wa_vbrk1 with key vbeln = wa_vbrp_vapma-vbeln."wa_vbrp-vbeln.
    if sy-subrc = 0.
      wa_transit-fkdat = wa_vbrk1-fkdat.
      wa_transit-xblnr = wa_vbrk1-xblnr.
    endif.

    read table it_konv into wa_konv with key knumv = wa_vbrk1-knumv kposn = wa_vbrp_vapma-posnr. "wa_vbrp-posnr.
    if sy-subrc = 0.
      wa_transit-kbetr = wa_konv-kbetr.
      wa_transit-kwert = wa_konv-kwert.
    endif.
       wa_transit-vbeln = wa_vbrp_vapma-aubel.
       wa_transit-posnr = wa_vbrp_vapma-aupos.

    read table lt_vbap into ls_vbap with key vbeln = wa_vbrp_vapma-aubel posnr = wa_vbrp_vapma-aupos. "vbeln = wa_vapma-vbeln posnr = wa_vapma-posnr.
    if sy-subrc = 0.
      wa_transit-kwmeng = ls_vbap-kwmeng.
    endif.

    read table it_ekpo into wa_ekpo with key ebeln = wa_vbrp_vapma-bstnk  matnr = wa_vbrp_vapma-matnr ebelp = ls_vbap-posex."ebeln = wa_vapma-bstnk  matnr = wa_vapma-matnr ebelp = ls_vbap-posex.
    if sy-subrc = 0.
      wa_transit-ebeln = wa_ekpo-ebeln.
      wa_transit-ebelp = wa_ekpo-ebelp.
      wa_transit-matnr = wa_ekpo-matnr.
      wa_transit-menge = wa_ekpo-menge.
      wa_transit-werks = wa_ekpo-werks.
    endif.

    read table it_mara into wa_mara with key matnr = wa_ekpo-matnr.
    if sy-subrc = 0.
      wa_transit-wrkst     = wa_mara-wrkst.
      wa_transit-zseries   = wa_mara-zseries.
      wa_transit-zsize     = wa_mara-zsize.
      wa_transit-brand     = wa_mara-brand.
      wa_transit-moc       = wa_mara-moc.
      wa_transit-type      = wa_mara-type   .
    endif.

    read table it_eikp into wa_eikp with key exnum = wa_vbrk1-exnum.
    if sy-subrc = 0.
    endif.
    read table it_t618t into wa_t618t with key expvz = wa_eikp-iever.
    if sy-subrc = 0.
      wa_transit-bezei = wa_t618t-bezei.
    endif.

     read table it_mseg_new11 into wa_mseg_new11 with key xblnr_mkpf = wa_vbrp_vapma-vgbel."
    if sy-subrc = 0.
      read table it_mseg1 into wa_mseg1 with key smbln = wa_mseg_new11-mblnr.
      if sy-subrc = 4.
        wa_transit-mblnr = wa_mseg_new11-mblnr.
      endif.
    endif.

    loop at it_bkpf into wa_bkpf where xblnr = wa_mseg-mblnr.
      read table it_bkpf1 into wa_bkpf1 with key stblg = wa_bkpf-belnr.
      if sy-subrc = 4.
        wa_transit-belnr = wa_bkpf-belnr.
      endif.
    endloop.

    read table it_mseg2 into wa_mseg2 with key xblnr_mkpf = wa_vbrp_vapma-vgbel.
    if sy-subrc = 4.
       if wa_likp1-trspg ne '03'.
      append wa_transit to it_transit.
        endif.
    endif.

      clear:wa_transit,wa_mseg,wa_rev,wa_bkpf,wa_mseg1,wa_eikp,wa_mode,wa_vbrk1,wa_t618t,wa_mara,wa_ekpo,wa_mseg2,wa_mseg_new11,
          ls_vbap,wa_konv,wa_mseg1,wa_rev.
     endloop.

   delete it_transit where ebeln  = ' '.
   delete it_transit where vbeln_im  = ' '."COMMENT FOR TESTING PURPOSE 19.02.2024

    select matnr
          werks from marc into table it_marc
          for all entries in it_transit
          where matnr = it_transit-matnr
            and werks = it_transit-werks.

  loop at it_marc into wa_marc.
    wa_trans-matnr = wa_marc-matnr.
    wa_trans-werks = wa_marc-werks.
    loop at it_transit into wa_transit where matnr = wa_marc-matnr.
      wa_trans-fkimg = wa_trans-fkimg + wa_transit-fkimg.
    endloop.
    append wa_trans to it_trans.
    clear wa_trans.
  endloop.
endform.
