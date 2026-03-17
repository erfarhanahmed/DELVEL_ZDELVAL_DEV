*&---------------------------------------------------------------------*
*& Report ZITEM_MASTER_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zitem_master_report.

TABLES: mara.

TYPES: BEGIN OF ty_mara,
         matnr        TYPE mara-matnr,
         mtart        TYPE mara-mtart,
         ersda        TYPE mara-ersda,
         ernam        TYPE mara-ernam,
         bismt        TYPE mara-bismt,
         extwg        TYPE mara-extwg,
         matkl        TYPE mara-matkl,
         spart        TYPE mara-spart,
         brgew        TYPE mara-brgew,
         meins        TYPE mara-meins,
         ntgew        TYPE mara-ntgew,
         mtpos_mara   TYPE mara-mtpos_mara,
         tragr        TYPE mara-tragr,
         magrv        TYPE mara-magrv,
         bstme        TYPE mara-bstme,
         zseries      TYPE mara-zseries,
         zsize        TYPE mara-zsize,
         brand        TYPE mara-brand,
         moc          TYPE mara-moc,
         type         TYPE mara-type,
         qmpur        TYPE mara-qmpur,
         pstat        TYPE mara-pstat,
         raube        TYPE mara-raube,
         zeinr        TYPE mara-zeinr,
         zeivr        TYPE mara-zeivr,
*       OBJ        TYPE OBJNUM,
         lvorm        TYPE mara-lvorm,        " Added By Abhishek Pisolkar (01.03.2018)
         normt        TYPE mara-normt,           "ADDED BY GANGA 15.03.2019
         bom          TYPE mara-bom,           "ADDED BY Nilay 23.03.2023
         zzeds        TYPE mara-zzeds,
         zzmss        TYPE mara-zzmss,
         cap_lead     TYPE mara-cap_lead,
         item_type    TYPE mara-item_type, " edited by PJ on16-08-21
         air_pressure TYPE mara-air_pressure, "Added By Avinash Bhagat
         air_fail     TYPE mara-air_fail, "Added By Avinash Bhagat
         actuator     TYPE mara-actuator, "Added By Avinash Bhagat
         vertical     TYPE mara-vertical, "Added By Avinash Bhagat
         kzkfg        TYPE mara-kzkfg, "Added by shreya 15-02-2022
*-----------------------ADDED BY DIKSHA-----------
         dev_status   TYPE mara-dev_status,
         zkanban      TYPE mara-zkanban,
         zpen_item    TYPE mara-zpen_item,
         zre_pen_item TYPE mara-zre_pen_item,
*------------------------------------------------
* *******added by Jyoti *************************
         zqap         TYPE mara-qap_no,
         rev_no       TYPE mara-rev_no,
         zboi         TYPE mara-zboi,                                """mara-zboi,
         wrkst        TYPE mara-wrkst,        "ADDED BY JYOTI ON 21.06.2024
         zitem_class  TYPE mara-zitem_class,  " ADD BY SUPRIYA  ON 02.10.2024
**************************************************
       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,


       BEGIN OF ty_marc,
         matnr TYPE marc-matnr,
         werks TYPE marc-werks,
         mtvfp TYPE marc-mtvfp,
         ladgr TYPE marc-ladgr,
         prctr TYPE marc-prctr,
         sernp TYPE marc-sernp,
         ekgrp TYPE marc-ekgrp,
         dismm TYPE marc-dismm,
         dispo TYPE marc-dispo,
         bstmi TYPE marc-bstmi,
         disls TYPE marc-disls,
         beskz TYPE marc-beskz,
         sobsl TYPE marc-sobsl,
         wzeit TYPE marc-wzeit,
         plifz TYPE marc-plifz,
         fhori TYPE marc-fhori,
         strgr TYPE marc-strgr,
         vrmod TYPE marc-vrmod,
         vint1 TYPE marc-vint1,
         vint2 TYPE marc-vint2,
         sbdkz TYPE marc-sbdkz,
         fevor TYPE marc-fevor,
         sfcpf TYPE marc-sfcpf,
         dzeit TYPE marc-dzeit,
         ausme TYPE marc-ausme,
         losgr TYPE marc-losgr,
         steuc TYPE marc-steuc,
         ssqss TYPE marc-ssqss,
         miskz TYPE marc-miskz,
         lvorm TYPE marc-lvorm,
         ncost TYPE marc-ncost,
         sobsk TYPE marc-sobsk,
       END OF ty_marc,



       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         lgort TYPE mard-lgort,
         lgpbe TYPE mard-lgpbe,
         werks TYPE mard-werks,

       END OF ty_mard,

       BEGIN OF ty_mvke,
         matnr TYPE mvke-matnr,
         vkorg TYPE mvke-vkorg,
         vtweg TYPE mvke-vtweg,
         dwerk TYPE mvke-dwerk,
         versg TYPE mvke-versg,
         ktgrm TYPE mvke-ktgrm,
         mtpos TYPE mvke-mtpos,
         vmsta TYPE mvke-vmsta,
       END OF ty_mvke,

       BEGIN OF ty_marm,
         matnr TYPE marm-matnr,
         meinh TYPE marm-meinh,
         umrez TYPE marm-umrez,
         umren TYPE marm-umren,
       END OF ty_marm,

       BEGIN OF ty_mbew,
         matnr TYPE mbew-matnr,
         bklas TYPE mbew-bklas,
         vprsv TYPE mbew-vprsv,
         verpr TYPE mbew-verpr,
         stprs TYPE mbew-stprs,
         ekalr TYPE mbew-ekalr,
         zplp3 TYPE mbew-zplp3,
         zpld3 TYPE mbew-zpld3,
         pprdl TYPE mbew-pprdl,     "Added by pankaj 17.01.2022 "Current Period
         pprdv TYPE mbew-pprdv,     "Added by pankaj 17.01.2022   "Perivoius Period
         pdatl TYPE mbew-pdatl,     "Added by pankaj 17.01.2022 "Fiscal Year
         pdatv TYPE mbew-pdatv,     "Added by pankaj 17.01.2022 "Fiscal Year for Previous Period
         vplpr TYPE mbew-vplpr,     "Added by pankaj 17.01.2022 "Previous Planned Price
         lplpr TYPE mbew-lplpr,     "Added by pankaj 17.01.2022 "Planned Price


       END OF ty_mbew,

       BEGIN OF ty_mlan,
         matnr TYPE mlan-matnr,
         taxm1 TYPE mlan-taxm1,
         taxm2 TYPE mlan-taxm2,
         taxm3 TYPE mlan-taxm3,
         taxm4 TYPE mlan-taxm4,
         taxm8 TYPE mlan-taxm8,
       END OF ty_mlan,

       BEGIN OF ty_j_1imtchid,
         matnr      TYPE j_1imtchid-matnr,
         j_1icapind TYPE j_1imtchid-j_1icapind,
         j_1isubind TYPE j_1imtchid-j_1isubind,
         j_1igrxref TYPE j_1imtchid-j_1igrxref,
       END OF ty_j_1imtchid,

       BEGIN OF ty_qmat,
         matnr TYPE qmat-matnr,
         art   TYPE qmat-art,
         aktiv TYPE qmat-aktiv,
       END OF ty_qmat,

       BEGIN OF ty_j_1iassval,
         j_1imatnr  TYPE j_1iassval-j_1imatnr,
         j_1ivalass TYPE j_1iassval-j_1ivalass,
       END OF ty_j_1iassval,

       BEGIN OF ty_j_1imoddet,
         j_1imoim TYPE j_1imoddet-j_1imoim,
         j_1imoom TYPE j_1imoddet-j_1imoom,
       END OF ty_j_1imoddet,

       BEGIN OF ty_ausp,
         objek TYPE ausp-objek,
         atinn TYPE ausp-atinn,
         atwrt TYPE ausp-atwrt,
       END OF ty_ausp,

       BEGIN OF ty_kssk,
         objek TYPE  kssk-objek,
         clint TYPE  kssk-clint,
       END OF ty_kssk,

       BEGIN OF ty_klah,
         clint TYPE  klah-clint,
         class TYPE  klah-class,
       END OF ty_klah,

       BEGIN OF ty_material,
*         matnr TYPE objnum,
         matnr TYPE char90,
       END OF ty_material,

       BEGIN OF ty_tvmst,
         spras TYPE tvmst-spras,
         vmsta TYPE tvmst-vmsta,
         vmstb TYPE tvmst-vmstb,
       END OF ty_tvmst,

       BEGIN OF ty_cdhdr,
         objectclas TYPE cdhdr-objectclas,
         objectid   TYPE cdhdr-objectid,
         changenr   TYPE cdhdr-changenr,
         username   TYPE cdhdr-username,
         udate      TYPE cdhdr-udate,
         tcode      TYPE cdhdr-tcode,
       END OF ty_cdhdr,

       BEGIN OF ty_cdpos,
         objectclas TYPE cdhdr-objectclas,
         objectid   TYPE cdhdr-objectid,
         changenr   TYPE cdhdr-changenr,
         tabname    TYPE cdpos-tabname,
         tabkey     TYPE cdpos-tabkey,
         fname      TYPE cdpos-fname,
         value_new  TYPE cdpos-value_new,
       END OF ty_cdpos,

       BEGIN OF ty_final,
         matnr        TYPE mara-matnr,
         mtart        TYPE mara-mtart,
         ersda        TYPE char15,
         ernam        TYPE mara-ernam,
         bismt        TYPE mara-bismt,
         extwg        TYPE mara-extwg,
         matkl        TYPE mara-matkl,
         spart        TYPE mara-spart,
         brgew        TYPE mara-brgew,
         meins        TYPE mara-meins,
         ntgew        TYPE mara-ntgew,
         mtpos_mara   TYPE mara-mtpos_mara,
         tragr        TYPE mara-tragr,
         magrv        TYPE mara-magrv,
         bstme        TYPE mara-bstme,
         zseries      TYPE mara-zseries,
         zsize        TYPE mara-zsize,
         brand        TYPE mara-brand,
         moc          TYPE mara-moc,
         type         TYPE mara-type,
         qmpur        TYPE mara-qmpur,
         pstat        TYPE mara-pstat,
         raube        TYPE mara-raube,
         zeinr        TYPE mara-zeinr,
         zeivr        TYPE mara-zeivr,
         maktx        TYPE makt-maktx,
*         zitem_class  TYPE mara-zitem_class,  " ADD BY SUPRIYA  ON 02.10.2024
         werks        TYPE marc-werks,
         mtvfp        TYPE marc-mtvfp,
         ladgr        TYPE marc-ladgr,
         prctr        TYPE marc-prctr,
         sernp        TYPE marc-sernp,
         ekgrp        TYPE marc-ekgrp,
         dismm        TYPE marc-dismm,
         dispo        TYPE marc-dispo,
         bstmi        TYPE marc-bstmi,
         disls        TYPE marc-disls,
         beskz        TYPE marc-beskz,
         sobsl        TYPE marc-sobsl,
         wzeit        TYPE marc-wzeit,
         plifz        TYPE marc-plifz,
         fhori        TYPE marc-fhori,
         strgr        TYPE marc-strgr,
         vrmod        TYPE marc-vrmod,
         vint1        TYPE marc-vint1,
         vint2        TYPE marc-vint2,
         sbdkz        TYPE marc-sbdkz,
         fevor        TYPE marc-fevor,
         sfcpf        TYPE marc-sfcpf,
         dzeit        TYPE marc-dzeit,
         ausme        TYPE marc-ausme,
         losgr        TYPE char15,
         steuc        TYPE marc-steuc,
         ssqss        TYPE marc-ssqss,
         miskz        TYPE marc-miskz,
         lgort        TYPE mard-lgort,
         lgpbe        TYPE mard-lgpbe,
         vkorg        TYPE mvke-vkorg,
         vtweg        TYPE mvke-vtweg,
         dwerk        TYPE mvke-dwerk,
         versg        TYPE mvke-versg,
         ktgrm        TYPE mvke-ktgrm,
         mtpos        TYPE mvke-mtpos,
         meinh        TYPE marm-meinh,
         umrez        TYPE marm-umrez,
         umren        TYPE marm-umren,
         bklas        TYPE mbew-bklas,
         vprsv        TYPE mbew-vprsv,
         verpr        TYPE char15,
         stprs        TYPE char15,
         ekalr        TYPE mbew-ekalr,

         taxm1        TYPE mlan-taxm1,
         taxm2        TYPE mlan-taxm2,
         taxm3        TYPE mlan-taxm3,
         taxm4        TYPE mlan-taxm4,
         j_1icapind   TYPE j_1imtchid-j_1icapind,
         j_1isubind   TYPE j_1imtchid-j_1isubind,
         j_1igrxref   TYPE j_1imtchid-j_1igrxref,
         art          TYPE qmat-art,
         aktiv        TYPE qmat-aktiv,
         j_1ivalass   TYPE char15,
         j_1imoom     TYPE j_1imoddet-j_1imoom,
         mattxt       TYPE text300,
*         ZITEM_CLASS TYPE MARA-ZITEM_CLASS,  " ADD BY SUPRIYA  ON 02.10.2024
*         span         TYPE text300,
         class        TYPE klah-class,
         stem         TYPE ausp-atwrt,
         seat         TYPE ausp-atwrt,
         body         TYPE ausp-atwrt,
         disc         TYPE ausp-atwrt,
         ball         TYPE ausp-atwrt,
         rating       TYPE ausp-atwrt,
         clas         TYPE ausp-atwrt,
         air_f        TYPE ausp-atwrt,
         main_air     TYPE ausp-atwrt,
         lvorm        TYPE mara-lvorm,              " Added By Abhishek Pisolkar(01.03.2018)
         ref          TYPE char15,
*         normt        TYPE mara-normt,           "ADDED BY GANGA 15.03.2019
         bom          TYPE mara-bom,           "ADDED BY Nilay 23.03.2023
         ncost        TYPE marc-ncost,
         sobsk        TYPE marc-sobsk,
         rm01         TYPE char10,
         fg01         TYPE char10,
         prd1         TYPE char10,
         rj01         TYPE char10,
         rwk1         TYPE char10,
         scr1         TYPE char10,
         sfg1         TYPE char10,
         srn1         TYPE char10,
         vld1         TYPE char10,
         plg1         TYPE char10,
         tpi1         TYPE char10,
         sc01         TYPE char10,
         spc1         TYPE char10,
         slr1         TYPE char10,
         dis10        TYPE char10,
         dis20        TYPE char10,
         dis30        TYPE char10,
         zzeds        TYPE char20,
         zzmss        TYPE char20,
         vmsta        TYPE char10,
         vmstb        TYPE char20,
         username     TYPE char15,
         udate        TYPE char15,
         tcode        TYPE char20,
         taxm8        TYPE mlan-taxm8,
         cap          TYPE mara-cap_lead,
         zplp3        TYPE char15   ,                "mbew-ZPLP3,
         zpld3        TYPE char15,
         item_type    TYPE mara-item_type, " edited by PJ 16-08-21
         air_pressure TYPE mara-air_pressure,
         air_fail     TYPE mara-air_fail,
         actuator     TYPE mara-actuator,
         vertical     TYPE mara-vertical,
         pprdl        TYPE char15,     "mbew-pprdl,     "Added by pankaj 17.01.2022 "Current Period
         pdatl        TYPE char15,     "mbew-pdatl,     "Added by pankaj 17.01.2022 "Fiscal Year
         lplpr        TYPE char15,     "mbew-lplpr,     "Added by pankaj 17.01.2022 "Planned Price
         pprdv        TYPE char15,     "mbew-pprdv,     "Added by pankaj 17.01.2022   "Perivoius Period
         pdatv        TYPE char15,     "mbew-pdatv,     "Added by pankaj 17.01.2022 "Fiscal Year for Previous Period
         vplpr        TYPE char15,     "mbew-vplpr,     "Added by pankaj 17.01.2022 "Previous Planned Price
         kzkfg        TYPE mara-kzkfg,   "Added by shreya 15-02-2022
         modify_date  TYPE char15,
*-----------------------------ADDED BY DIKSHA----------
         dev_status   TYPE mara-dev_status,
         zkanban      TYPE mara-zkanban,
         zpen_item    TYPE mara-zpen_item,
         zre_pen_item TYPE mara-zre_pen_item,
         mcn1         TYPE char10,  "Added By Nilay On 31.03.2023
         pn01         TYPE char10,  "Added By Nilay On 31.03.2023
         zqap         TYPE mara-qap_no, "ADDED BY PRIMUS JYOTI ON 02.04.2024
         rev_no       TYPE mara-rev_no, "ADDED BY PRIMUS JYOTI ON 02.04.2024
         zboi         TYPE   char3,           ""MARA-zboi,"ADDED BY PRIMUS JYOTI ON 05.04.2024
         time         TYPE string,
         wrkst        TYPE mara-wrkst, "ADDED BY JYOTI ON 21.06.2024
*********ADDED BY SAURABH ON 5.09.2024*******************
         kmcn         TYPE char10,
         kndt         TYPE char10,
         kplg         TYPE char10,
         kpr1         TYPE char10,
         kprd         TYPE char10,
         krj0         TYPE char10,
         krm0         TYPE char10,
         krwk         TYPE char10,
         ksc0         TYPE char10,
         kscr         TYPE char10,
         ksfg         TYPE char10,
         kslr         TYPE char10,
         kspc         TYPE char10,
         ksrn         TYPE char10,
         ktpi         TYPE char10,
         kvld         TYPE char10,
         kfg0         TYPE char10,
**************************************************************
         zitem_class  TYPE mara-zitem_class,  " ADD BY SUPRIYA 0N 02.10.2024
         span         TYPE string,"text300, "added by jyoti on 25.06.2024
*-----------------------------------------------------
       END OF ty_final.

DATA: it_mara       TYPE TABLE OF ty_mara,
      wa_mara       TYPE          ty_mara,

      it_makt       TYPE TABLE OF ty_makt,
      wa_makt       TYPE          ty_makt,

      it_mard       TYPE TABLE OF ty_mard,
      wa_mard       TYPE          ty_mard,

      it_marc       TYPE TABLE OF ty_marc,
      wa_marc       TYPE          ty_marc,

      it_mbew       TYPE TABLE OF ty_mbew,
      wa_mbew       TYPE          ty_mbew,

      it_mlan       TYPE TABLE OF ty_mlan,
      wa_mlan       TYPE          ty_mlan,

      it_marm       TYPE TABLE OF ty_marm,
      wa_marm       TYPE          ty_marm,

      it_mvke       TYPE TABLE OF ty_mvke,
      wa_mvke       TYPE          ty_mvke,

      it_j_1imtchid TYPE TABLE OF ty_j_1imtchid,
      wa_j_1imtchid TYPE          ty_j_1imtchid,

      it_qmat       TYPE TABLE OF ty_qmat,
      wa_qmat       TYPE          ty_qmat,

      it_j_1iassval TYPE TABLE OF ty_j_1iassval,
      wa_j_1iassval TYPE          ty_j_1iassval,

      it_j_1imoddet TYPE TABLE OF ty_j_1imoddet,
      wa_j_1imoddet TYPE          ty_j_1imoddet,

      it_ausp       TYPE TABLE OF ty_ausp,
      wa_ausp       TYPE          ty_ausp,

      it_material   TYPE TABLE OF ty_material,
      wa_material   TYPE          ty_material,

      it_kssk       TYPE TABLE OF ty_kssk,
      wa_kssk       TYPE          ty_kssk,

      it_klah       TYPE TABLE OF ty_klah,
      wa_klah       TYPE          ty_klah,

      it_tvmst      TYPE TABLE OF ty_tvmst,
      wa_tvmst      TYPE          ty_tvmst,

      it_cdhdr      TYPE TABLE OF ty_cdhdr,
      wa_cdhdr      TYPE          ty_cdhdr,

      it_cdhdr_new  TYPE TABLE OF ty_cdhdr,
      wa_cdhdr_new  TYPE          ty_cdhdr,

      it_cdpos      TYPE TABLE OF ty_cdpos,
      wa_cdpos      TYPE          ty_cdpos,

      it_final      TYPE TABLE OF ty_final,
      wa_final      TYPE          ty_final.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_mat FOR mara-matnr,
                  s_date FOR mara-ersda.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

PARAMETERS  p_hidden TYPE char8 NO-DISPLAY.

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

  SELECT matnr
         mtart
         ersda
         ernam
         bismt
         extwg
         matkl
         spart
         brgew
         meins
         ntgew
         mtpos_mara
         tragr
         magrv
         bstme
         zseries
         zsize
         brand
         moc
         type
         qmpur
         pstat
         raube
         zeinr
         zeivr
         lvorm
         normt
         bom
         zzeds
         zzmss
         cap_lead
         item_type  " edited by PJ on16-08-21
         air_pressure
         air_fail
         actuator
         vertical
         kzkfg "added by shreya 15-02-2022
         dev_status
         zkanban
         zpen_item
         zre_pen_item
         qap_no "ADDED BY JYOTI ON 02.04.2024
         rev_no "ADDED BY JYOTI ON 02.04.2024
         zboi  "added by jyoti on 05.04.2024
         wrkst "ADDEDE BY JYOTI ON 21.06.2024
         zitem_class  " ADD BY SUPRIYA  ON 02.10.2024
         FROM mara INTO TABLE it_mara                " LVORM addded by abhishek (01.03.2018)
*         UP TO 30 ROWS.
         WHERE  matnr IN s_mat
         AND ersda IN s_date.

  IF  it_mara IS NOT INITIAL.

    SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.

    SELECT matnr
            FROM mara INTO TABLE it_material
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.


    SELECT matnr
           werks
           mtvfp
           ladgr
           prctr
           sernp
           ekgrp
           dismm
           dispo
           bstmi
           disls
           beskz
           sobsl
           wzeit
           plifz
           fhori
           strgr
           vrmod
           vint1
           vint2
           sbdkz
           fevor
           sfcpf
           dzeit
           ausme
           losgr
           steuc
           ssqss
           miskz
           lvorm
           ncost
           sobsk FROM marc INTO TABLE it_marc
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
           AND werks = 'PL01'.

    SELECT matnr
           lgort
           lgpbe werks  FROM mard INTO TABLE it_mard
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
            AND werks = 'PL01'.

    SELECT matnr
           vkorg
           vtweg
           dwerk
           versg
           ktgrm
           mtpos
           vmsta FROM mvke INTO TABLE it_mvke
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
           AND vkorg = '1000'.

    SELECT matnr
           meinh
           umrez
           umren FROM marm INTO TABLE it_marm
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.

    SELECT matnr
           bklas
           vprsv
           verpr
           stprs
           ekalr
           zplp3
           zpld3
           pprdl "added by pankaj 17.01.2022
           pprdv "added by pankaj 17.01.2022
           pdatl "added by pankaj 17.01.2022
           pdatv "added by pankaj 17.01.2022
           vplpr "added by pankaj 17.01.2022
           lplpr "added by pankaj 17.01.2022
       FROM mbew INTO TABLE it_mbew
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
            AND bwkey = 'PL01'.

    SELECT matnr
           taxm1
           taxm2
           taxm3
           taxm4
           taxm8 FROM mlan INTO TABLE it_mlan
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
            AND aland = 'IN'.

    SELECT matnr
           j_1icapind
           j_1isubind
           j_1igrxref FROM j_1imtchid INTO TABLE it_j_1imtchid
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
            AND werks = 'PL01'.

    SELECT matnr
           art
           aktiv FROM qmat INTO TABLE it_qmat
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr
            AND werks = 'PL01'.

    SELECT j_1imatnr
           j_1ivalass FROM j_1iassval INTO TABLE it_j_1iassval
           FOR ALL ENTRIES IN it_mara
           WHERE j_1iwerks = 'PL01'
           AND   j_1imatnr = it_mara-matnr.

    SELECT j_1imoim
           j_1imoom FROM j_1imoddet INTO TABLE it_j_1imoddet
           FOR ALL ENTRIES IN it_mara
           WHERE werks = 'PL01'
            AND  j_1imoim = it_mara-matnr.


  ENDIF.

  IF it_cdpos IS NOT INITIAL.

  ENDIF.
  IF it_material IS NOT INITIAL .
    SELECT objek
           atinn
           atwrt FROM ausp INTO TABLE it_ausp
           FOR ALL ENTRIES IN it_material
           WHERE objek = it_material-matnr.

    SELECT objek
             clint FROM kssk INTO TABLE it_kssk
             FOR ALL ENTRIES IN it_material
             WHERE objek = it_material-matnr.

  ENDIF.

  IF it_kssk IS NOT INITIAL.
    SELECT clint
           class FROM klah INTO TABLE it_klah
           FOR ALL ENTRIES IN it_kssk
           WHERE clint = it_kssk-clint.
  ENDIF.

  IF it_mvke IS NOT INITIAL.
    SELECT spras
           vmsta
           vmstb FROM tvmst INTO TABLE it_tvmst
           FOR ALL ENTRIES IN it_mvke
           WHERE spras = 'EN'
             AND vmsta = it_mvke-vmsta.
  ENDIF.

  LOOP AT it_mara INTO wa_mara.
    wa_final-matnr      = wa_mara-matnr.
    wa_final-mtart      = wa_mara-mtart.
*  WA_FINAL-ERSDA      = WA_MARA-ERSDA.
    wa_final-ernam      = wa_mara-ernam.
    wa_final-bismt      = wa_mara-bismt.
    wa_final-extwg      = wa_mara-extwg.
    wa_final-matkl      = wa_mara-matkl.
    wa_final-spart      = wa_mara-spart.
    wa_final-brgew      = wa_mara-brgew.
    wa_final-meins      = wa_mara-meins.
    wa_final-ntgew      = wa_mara-ntgew.
    wa_final-mtpos_mara = wa_mara-mtpos_mara.
    wa_final-tragr      = wa_mara-tragr  .
    wa_final-magrv      = wa_mara-magrv  .
    wa_final-bstme      = wa_mara-bstme  .
    wa_final-zseries    = wa_mara-zseries.
    wa_final-zsize      = wa_mara-zsize  .
    wa_final-brand      = wa_mara-brand  .
    wa_final-moc        = wa_mara-moc    .
    wa_final-type       = wa_mara-type   .
    wa_final-qmpur      = wa_mara-qmpur   .
    wa_final-pstat      = wa_mara-pstat   .
    wa_final-raube      = wa_mara-raube   .
    wa_final-zeinr      = wa_mara-zeinr   .
    wa_final-zeivr      = wa_mara-zeivr   .
    wa_final-lvorm      = wa_mara-lvorm   .            " Added By Abhishek Pisolkar (01.03.2018)
*    wa_final-normt      = wa_mara-normt   .            " Added By GANGA (15.03.2019)
    wa_final-bom        = wa_mara-bom     .            " Added By Nilay B (23.03.2023)
    wa_final-zzeds      = wa_mara-zzeds   .
    wa_final-zzmss      = wa_mara-zzmss   .
    wa_final-cap        = wa_mara-cap_lead   .
    wa_final-air_pressure = wa_mara-air_pressure.   "Added By Avinash Bhagat
    wa_final-air_fail     = wa_mara-air_fail    . "Added By Avinash Bhagat
    wa_final-actuator     = wa_mara-actuator    . "Added By Avinash Bhagat
    wa_final-vertical     = wa_mara-vertical    . "Added By Avinash Bhagat
    wa_final-kzkfg        = wa_mara-kzkfg   . " added by shreya 15-02-2022.
    wa_final-dev_status   = wa_mara-dev_status.
    wa_final-zkanban      = wa_mara-zkanban.
    wa_final-zpen_item      = wa_mara-zpen_item.
    wa_final-zre_pen_item      = wa_mara-zre_pen_item.
    wa_final-zqap = wa_mara-zqap."ADDED  BY JYOTI ON 02.04.2024
    wa_final-rev_no = wa_mara-rev_no. "ADDED BY JYOTI ON 02.04.2024

    IF wa_mara-zboi = 'Y'.
      wa_final-zboi = 'Yes'.               "ADDED BY JYOTI ON 05.04.2024
    ELSE.
      wa_final-zboi = ''.                  "ADDED BY JYOTI ON 05.04.2024
    ENDIF.

    CLEAR wa_mara-zboi.
    wa_final-wrkst = wa_mara-wrkst. "ADDED BY JYOTI ON21.06.2024

    READ TABLE it_material INTO wa_material WITH KEY matnr = wa_final-matnr.


    LOOP AT it_ausp INTO wa_ausp WHERE objek = wa_material-matnr.
      CASE wa_ausp-atinn.
*        WHEN '0000000811'.
        WHEN '0000000822'.
          wa_final-stem = wa_ausp-atwrt.
        WHEN '0000000812' .
          wa_final-rating = wa_ausp-atwrt.
        WHEN '0000000813'.
          wa_final-disc = wa_ausp-atwrt.
*        WHEN '0000000815'.
        WHEN '0000000818'.
          wa_final-body = wa_ausp-atwrt.
*        WHEN '0000000816'.
        WHEN '0000000811'.
          wa_final-seat = wa_ausp-atwrt.
        WHEN '0000000828'.
          wa_final-ball = wa_ausp-atwrt.
*        WHEN '0000000829'.
        WHEN '0000000815'.
          wa_final-clas = wa_ausp-atwrt.
*        WHEN '0000000831'.
        WHEN '0000000817'.
          wa_final-main_air = wa_ausp-atwrt.
*        WHEN '0000000832'.
        WHEN '0000000816'.
          wa_final-air_f = wa_ausp-atwrt.
      ENDCASE.

    ENDLOOP.

    READ TABLE it_kssk INTO wa_kssk WITH KEY objek = wa_material-matnr.

    READ TABLE it_klah INTO wa_klah WITH KEY clint = wa_kssk-clint.
    IF sy-subrc = 0.
      wa_final-class = wa_klah-class.

    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_mara-ersda
      IMPORTING
        output = wa_final-ersda.

    CONCATENATE wa_final-ersda+0(2) wa_final-ersda+2(3) wa_final-ersda+5(4)
                    INTO wa_final-ersda SEPARATED BY '-'.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktx.

*      wa_final-zitem_class = wa_mara-zitem_class.

    ENDIF.


    READ TABLE it_marc INTO wa_marc WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-werks = wa_marc-werks.
      wa_final-mtvfp = wa_marc-mtvfp.
      wa_final-ladgr = wa_marc-ladgr.
      wa_final-prctr = wa_marc-prctr.
      wa_final-sernp = wa_marc-sernp.
      wa_final-ekgrp = wa_marc-ekgrp.
      wa_final-dismm = wa_marc-dismm.
      wa_final-dispo = wa_marc-dispo.
      wa_final-bstmi = wa_marc-bstmi.
      wa_final-disls = wa_marc-disls.
      wa_final-beskz = wa_marc-beskz.
      wa_final-sobsl = wa_marc-sobsl.
      wa_final-wzeit = wa_marc-wzeit.
      wa_final-plifz = wa_marc-plifz.
      wa_final-fhori = wa_marc-fhori.
      wa_final-strgr = wa_marc-strgr.
      wa_final-vrmod = wa_marc-vrmod.
      wa_final-vint1 = wa_marc-vint1.
      wa_final-vint2 = wa_marc-vint2.
      wa_final-sbdkz = wa_marc-sbdkz.
      wa_final-fevor = wa_marc-fevor.
      wa_final-sfcpf = wa_marc-sfcpf.
      wa_final-dzeit = wa_marc-dzeit.
      wa_final-ausme = wa_marc-ausme.
      wa_final-losgr = wa_marc-losgr.
      wa_final-steuc = wa_marc-steuc.
      wa_final-ssqss = wa_marc-ssqss.
      wa_final-miskz = wa_marc-miskz.
      wa_final-ncost = wa_marc-ncost.
      wa_final-sobsk = wa_marc-sobsk.
      IF wa_final-lvorm IS INITIAL.
        wa_final-lvorm = wa_marc-lvorm.
      ENDIF.
    ENDIF.

    DATA:tabkey TYPE cdpos-tabkey.
    CLEAR:tabkey,it_cdpos,it_cdhdr,wa_cdpos,wa_cdhdr.

    CONCATENATE sy-mandt wa_final-matnr wa_final-matnr INTO tabkey.

    IF wa_final-lvorm IS NOT INITIAL.


      SELECT objectclas
             objectid
             changenr
             tabname
             tabkey
             fname
             value_new  FROM cdpos INTO TABLE it_cdpos
             WHERE objectid = wa_final-matnr
               AND tabname IN ('MARA','MARC')
*            AND TABKEY = TABKEY
               AND fname    = 'LVORM'
               AND value_new = 'X'.

      SELECT objectclas
             objectid
             changenr
             username
             udate
             tcode
             FROM cdhdr
             INTO TABLE it_cdhdr
             FOR ALL ENTRIES IN it_cdpos
             WHERE changenr = it_cdpos-changenr.

      SORT it_cdpos BY changenr DESCENDING .

      READ TABLE it_cdpos INTO wa_cdpos WITH KEY objectid = wa_final-matnr.
      IF sy-subrc = 0.
        READ TABLE it_cdhdr INTO wa_cdhdr WITH KEY changenr = wa_cdpos-changenr.
        IF sy-subrc = 0.
          wa_final-username  = wa_cdhdr-username.
          wa_final-tcode     = wa_cdhdr-tcode.
*    wa_final-UDATE     = wa_cdhdr-UDATE   .

          IF wa_cdhdr-udate IS NOT INITIAL.

            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                input  = wa_cdhdr-udate
              IMPORTING
                output = wa_final-udate.

            CONCATENATE wa_final-udate+0(2) wa_final-udate+2(3) wa_final-udate+5(4)
                          INTO wa_final-udate SEPARATED BY '-'.

          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-lgort = wa_mard-lgort.
      wa_final-lgpbe = wa_mard-lgpbe.
    ENDIF.

    LOOP AT it_mard INTO wa_mard WHERE matnr = wa_mara-matnr. .
      CASE wa_mard-lgort.
        WHEN 'RM01'.
          wa_final-rm01 = 'YES'.
        WHEN 'FG01'.
          wa_final-fg01 = 'YES'.
        WHEN 'PRD1'.
          wa_final-prd1 = 'YES'.
        WHEN 'RJ01'.
          wa_final-rj01 = 'YES'.
        WHEN 'RWK1'.
          wa_final-rwk1 = 'YES'.
        WHEN 'SCR1'.
          wa_final-scr1 = 'YES'.
        WHEN 'SFG1'.
          wa_final-sfg1 = 'YES'.
        WHEN 'SRN1'.
          wa_final-srn1 = 'YES'.
        WHEN 'VLD1'.
          wa_final-vld1 = 'YES'.
        WHEN 'PLG1'.
          wa_final-plg1 = 'YES'.
        WHEN 'TPI1'.
          wa_final-tpi1 = 'YES'.
        WHEN 'SC01'.
          wa_final-sc01 = 'YES'.
        WHEN 'SPC1'.
          wa_final-spc1 = 'YES'.
        WHEN 'SLR1'.
          wa_final-slr1 = 'YES'.
        WHEN 'MCN1'.
          wa_final-mcn1 = 'YES'.
        WHEN 'PN01'.
          wa_final-pn01 = 'YES'.
**********************ADDED BY SAURABH ON 5.9.2024***************************
        WHEN 'KMCN'.
          wa_final-kmcn = 'YES'.
        WHEN 'KNDT'.
          wa_final-kndt = 'YES'.
        WHEN 'KPLG'.
          wa_final-kplg = 'YES'.
        WHEN 'KPR1'.
          wa_final-kpr1 = 'YES'.
        WHEN 'KPRD'.
          wa_final-kprd = 'YES'.
        WHEN 'KRJ0'.
          wa_final-krj0 = 'YES'.
        WHEN 'KRM0'.
          wa_final-krm0 = 'YES'.
        WHEN 'KRWK'.
          wa_final-krwk = 'YES'.
        WHEN 'KSC0'.
          wa_final-ksc0 = 'YES'.
        WHEN 'KSCR'.
          wa_final-kscr = 'YES'.
        WHEN 'KSFG'.
          wa_final-ksfg = 'YES'.
        WHEN 'KSLR'.
          wa_final-kslr = 'YES'.
        WHEN 'KSPC'.
          wa_final-kspc = 'YES'.
        WHEN 'KSRN'.
          wa_final-ksrn = 'YES'.
        WHEN 'KTPI'.
          wa_final-ktpi = 'YES'.
        WHEN 'KVLD'.
          wa_final-kvld = 'YES'.
        WHEN 'KFG0'.
          wa_final-kfg0 = 'YES'.

************************************************************
      ENDCASE.
    ENDLOOP.

    LOOP AT it_mvke INTO wa_mvke WHERE matnr = wa_mara-matnr.
      CASE wa_mvke-vtweg.
        WHEN '10'.
          wa_final-dis10 = 'YES'.
        WHEN '20'.
          wa_final-dis20 = 'YES'.
        WHEN '30'.
          wa_final-dis30 = 'YES'.
      ENDCASE.

    ENDLOOP.

    READ TABLE it_mvke INTO wa_mvke WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-vkorg = wa_mvke-vkorg.
      wa_final-vtweg = wa_mvke-vtweg.
      wa_final-dwerk = wa_mvke-dwerk.
      wa_final-versg = wa_mvke-versg.
      wa_final-ktgrm = wa_mvke-ktgrm.
      wa_final-mtpos = wa_mvke-mtpos.
      wa_final-vmsta = wa_mvke-vmsta.

    ENDIF.

    READ TABLE it_tvmst INTO wa_tvmst WITH KEY vmsta = wa_final-vmsta.
    IF sy-subrc = 0.
      wa_final-vmstb = wa_tvmst-vmstb.
    ENDIF.

    READ TABLE it_marm INTO wa_marm WITH KEY matnr = wa_mara-matnr." MEINH = WA_MARA-MEINS .
    IF sy-subrc = 0.
      IF wa_marm-meinh NE wa_mara-meins.
        wa_final-meinh = wa_marm-meinh.
        wa_final-umrez = wa_marm-umrez.
        wa_final-umren = wa_marm-umren.
      ENDIF.
    ENDIF.

    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-bklas = wa_mbew-bklas.
      wa_final-vprsv = wa_mbew-vprsv.
      wa_final-verpr = wa_mbew-verpr.
      wa_final-stprs = wa_mbew-stprs.
      wa_final-ekalr = wa_mbew-ekalr.
      wa_final-zplp3 = wa_mbew-zplp3.
      wa_final-zpld3 = wa_mbew-zpld3.

      IF  wa_final-zplp3 = 0.
        CLEAR wa_final-zplp3.
      ENDIF.


      IF wa_final-zpld3 <> 0.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-zpld3
          IMPORTING
            output = wa_final-zpld3.

        CONCATENATE wa_final-zpld3+0(2) wa_final-zpld3+2(3) wa_final-zpld3+5(4)
                        INTO wa_final-zpld3 SEPARATED BY '-'.

      ELSE.
        CLEAR wa_final-zpld3.

        """"""""""" code added by pankaj  17.01.2022""""""""""""""

      ENDIF.
      wa_final-pprdl = wa_mbew-pprdl.
      wa_final-pdatl = wa_mbew-pdatl.
      wa_final-lplpr = wa_mbew-lplpr.
      wa_final-pprdv = wa_mbew-pprdv.
      wa_final-pdatv = wa_mbew-pdatv.
      wa_final-vplpr = wa_mbew-vplpr.

    ENDIF.

    READ TABLE it_mlan INTO wa_mlan WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-taxm1 = wa_mlan-taxm1.
      wa_final-taxm2 = wa_mlan-taxm2.
      wa_final-taxm3 = wa_mlan-taxm3.
      wa_final-taxm4 = wa_mlan-taxm4.
      wa_final-taxm8 = wa_mlan-taxm8.

    ENDIF.

    READ TABLE it_j_1imtchid INTO wa_j_1imtchid WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-j_1icapind = wa_j_1imtchid-j_1icapind.
      wa_final-j_1isubind = wa_j_1imtchid-j_1isubind.
      wa_final-j_1igrxref = wa_j_1imtchid-j_1igrxref.
    ENDIF.

    READ TABLE it_qmat INTO wa_qmat WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-art = wa_qmat-art.
      wa_final-aktiv = wa_qmat-aktiv.

    ENDIF.

    READ TABLE it_j_1iassval INTO wa_j_1iassval WITH KEY j_1imatnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-j_1ivalass = wa_j_1iassval-j_1ivalass.

    ENDIF.

    READ TABLE it_j_1imoddet INTO wa_j_1imoddet WITH KEY j_1imoim = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-j_1imoom = wa_j_1imoddet-j_1imoom.

    ENDIF.

    wa_final-ref = sy-datum.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-ref
      IMPORTING
        output = wa_final-ref.

    CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
                    INTO wa_final-ref SEPARATED BY '-'.

    CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_final-time SEPARATED BY ':'.

    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_mara-matnr.
    IF lv_name IS NOT INITIAL.
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
    ENDIF.

    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          REPLACE ALL OCCURRENCES OF '<(>' IN wa_lines-tdline WITH space.
          REPLACE ALL OCCURRENCES OF '<)>' IN wa_lines-tdline WITH space.
          CONCATENATE wa_final-mattxt wa_lines-tdline INTO wa_final-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-mattxt.
    ENDIF.
******************************************************ADD BY SUPRIYA ON 02.10.2024
    wa_final-zitem_class = wa_mara-zitem_class.
*********************************************************************************
    CLEAR: lv_lines, ls_mattxt, lv_name.
    REFRESH lv_lines.
    lv_name = wa_mara-matnr.
    DATA: lang TYPE sy-langu.
    lang = 'ES'.
    IF lv_name IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = 'S'
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
    ENDIF.

    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-span wa_lines-tdline INTO wa_final-span SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-span.
    ENDIF.

    wa_final-item_type  = wa_mara-item_type .         " edited by PJ on16-08-21

    SELECT objectclas
           objectid
           changenr
           username
           udate
           tcode
           FROM cdhdr
           INTO TABLE it_cdhdr_new
           WHERE objectid = wa_mara-matnr
           AND   tcode = 'MM02'.

    SORT it_cdhdr_new BY udate DESCENDING.
    READ TABLE it_cdhdr_new INTO wa_cdhdr_new WITH KEY objectid = wa_mara-matnr
                                                       tcode    = 'MM02'.
    IF sy-subrc = 0.
      wa_final-modify_date = wa_cdhdr_new-udate.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_cdhdr_new-udate
      IMPORTING
        output = wa_final-modify_date.

    CONCATENATE wa_final-modify_date+0(2) wa_final-modify_date+2(3) wa_final-modify_date+5(4)
                    INTO wa_final-modify_date SEPARATED BY '-'.

    IF wa_final-modify_date = '--'.
      wa_final-modify_date = ' '.
    ENDIF.
**********SOC by farhan on dated 11-06-2025
IF WA_FINAL-MATNR+0(1) =  CL_ABAP_CHAR_UTILITIES=>NEWLINE.
SHIFT WA_FINAL-MATNR LEFT BY 1 PLACES.
ENDIF.
IF wA_FINAL-J_1IMOOM+0(1) = CL_ABAP_CHAR_UTILITIES=>NEWLINE.
SHIFT wA_FINAL-J_1IMOOM LEFT BY 1 PLACES..
ENDIF.

    APPEND wa_final TO it_final.
    CLEAR : wa_final.
    CLEAR : wa_mara, wa_material, wa_kssk, wa_klah, wa_makt, wa_marc, wa_cdpos, wa_cdhdr, wa_mard, wa_mvke,
            wa_tvmst, wa_marm, wa_mbew, wa_mlan, wa_j_1imtchid, wa_qmat, wa_j_1iassval, wa_j_1imoddet,wa_cdhdr_new.
  ENDLOOP.

  DELETE it_final WHERE matnr = ''.

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
  PERFORM fcat USING :
                       '1'  'MATNR'         'IT_FINAL'  'Ext.Mat.No.'              '18' ,
                       '2'  'MTART'         'IT_FINAL'  'Material Type'            '18',
                       '3'  'ERSDA'         'IT_FINAL'  'Created On'               '18' ,
                       '4'  'ERNAM'         'IT_FINAL'  'Created By'               '18' ,
                       '5'  'BISMT'         'IT_FINAL'  'Old material number'      '18' ,
                       '6'  'EXTWG'         'IT_FINAL'  'Ext.Material Group'       '18' ,
                       '7'  'MATKL'         'IT_FINAL'  'Material Group'           '18' ,
                       '8'  'SPART'         'IT_FINAL'  'Divis'                    '5' ,
                       '9'  'BRGEW'         'IT_FINAL'  'Gross Weight'             '18' ,
                      '10'  'MEINS'         'IT_FINAL'  'Base Unit of Measure'     '18' ,
                      '11'  'NTGEW'         'IT_FINAL'  'Net Weight'               '18' ,
                      '12'  'MTPOS_MARA'    'IT_FINAL'  'Gen.item cat.group'       '18' ,
                      '13'  'TRAGR  '       'IT_FINAL'  'Transportation Group'     '18' ,
                      '14'  'MAGRV  '       'IT_FINAL'  'Matl.Grp.Pack.Matls'      '18',
                      '15'  'BSTME  '       'IT_FINAL'  'Purc.Ord.Unit'            '18' ,
                      '16'  'ZSERIES'       'IT_FINAL'  'series code'              '18' ,
                      '17'  'ZSIZE  '       'IT_FINAL'  'Size'                     '18' ,
                      '18'  'BRAND  '       'IT_FINAL'  'Brand'                    '18' ,
                      '19'  'MOC    '       'IT_FINAL'  'MOC'                      '18' ,
                      '20'  'TYPE   '       'IT_FINAL'  'TYPE'                     '18' ,
                      '21'  'QMPUR   '       'IT_FINAL'  'QM proc active'          '18' ,
                      '22'  'PSTAT   '       'IT_FINAL'  'Mainten status'          '18' ,
                      '23'  'RAUBE   '       'IT_FINAL'  'Stor.cond'               '10' ,
                      '24'  'ZEINR   '       'IT_FINAL'  'Drawing No'              '18' ,
                      '25'  'ZEIVR   '       'IT_FINAL'  'Rev.No'                  '8' ,

                        "MAKT TABLE"
                      '26'  'MAKTX   '       'IT_FINAL'  'Mat.Descr'              '20' ,

*                      '27'  'ZITEM_CLASS'    'IT_FINAL'   'ITEM CLASS'            '3',
*                      '28'  'WERKS'         'IT_FINAL'  'Plant'                    '5' ,
*                      '29'  'MTVFP'         'IT_FINAL'  'Avail.Chk'                '10',
*                      '30'  'LADGR'         'IT_FINAL'  'Load.Group'               '10' ,
*                      '31'  'PRCTR'         'IT_FINAL'  'Profit Center'            '10' ,
*                      '32'  'SERNP'         'IT_FINAL'  'Ser.No.Prof'              '10' ,
*                      '33'  'EKGRP'         'IT_FINAL'  'Pur.Group'                '10' ,
*                      '34'  'DISMM'         'IT_FINAL'  'MRP Type'                 '7' ,
*                      '35'  'DISPO'         'IT_FINAL'  'MRP Cont'                 '8' ,
*                      '36'  'BSTMI'         'IT_FINAL'  'Min.Ord.Quntity'         '18' ,
*                      '37'  'DISLS'         'IT_FINAL'  'Lot size'                 '8' ,
*                      '38'  'BESKZ'         'IT_FINAL'  'Procur.Type'              '11' ,
*                      '39'  'SOBSL'         'IT_FINAL'  'Spec.proc.type'           '15' ,
*                      '40'  'WZEIT  '       'IT_FINAL'  'Repl.Lead Time'           '10' ,
*                      '41'  'PLIFZ  '       'IT_FINAL'  'Plan.Del.Time'            '18',
*                      '42'  'FHORI  '       'IT_FINAL'  'Sched.Margin'             '10' ,
*                      '43'  'STRGR  '       'IT_FINAL'  'strat.group'              '10' ,
*                      '44'  'VRMOD  '       'IT_FINAL'  'Consum.mode'              '10' ,
*                      '45'  'VINT1  '       'IT_FINAL'  'Consum.peri backward'     '18' ,
*                      '46'  'VINT2  '       'IT_FINAL'  'Consum.peri forward'      '18' ,
*                      '47'  'SBDKZ  '       'IT_FINAL'  'Indi/Coll'                '10' ,
*                      '48'  'FEVOR'         'IT_FINAL'  'Prod.Sched'               '10' ,
*                      '49'  'SFCPF'         'IT_FINAL'  'Prod.Sched.Prof'          '10',
*                      '50'  'DZEIT'         'IT_FINAL'  'Prod.Time'                '10' ,
*                      '51'  'AUSME'         'IT_FINAL'  'Unit of issue'            '15' ,
*                      '52'  'LOSGR'         'IT_FINAL'  'Costing Lot Size'         '18' ,
*                      '53'  'STEUC'         'IT_FINAL'  'HSN Code'                 '18' ,
*                      '54'  'SSQSS'         'IT_FINAL'  'QM Cont.Key'              '18' ,
*                      '55'  'MISKZ'         'IT_FINAL'  'Mix.MRP.Ind'              '10' ,
*                      '56'  'LGORT'         'IT_FINAL'  'Stor.Loc'                 '10' ,
*                      '57'  'LGPBE'         'IT_FINAL'  'Stor.Bin'                 '10' ,
*                      '58'   'VKORG'         'IT_FINAL'  'Sale.Org.'                '10' ,
*                      '59'   'VTWEG'         'IT_FINAL'  'Dist.Chan'                '10',
*                      '60'   'DWERK'         'IT_FINAL'  'Deli.Plant'               '10' ,
*                      '61'   'VERSG'         'IT_FINAL'  'Mate.stat.group'          '10' ,
*                      '62'   'KTGRM'         'IT_FINAL'  'Ac.Ass'                   '6' ,
*
*                      '63'    'MTPOS'         'IT_FINAL'  'Itm.Cat.grp'              '10' ,
*                      '64'  'MEINH'         'IT_FINAL'  'Alt.UOM'                '8' ,
*                      '65'  'UMREZ'         'IT_FINAL'  'Conv Factor'            '8' ,
*
*                      '66'  'UMREN'         'IT_FINAL'  'Den.conv'               '8' ,
*                      '67'  'BKLAS'         'IT_FINAL'  'Val.Class'                '10' ,
*                      '68'  'VPRSV'         'IT_FINAL'  'Pri.cont.ind'             '10',
*                      '69'  'VERPR'         'IT_FINAL'  'Mov.price'                '15' ,
*                      '70'  'STPRS'         'IT_FINAL'  'Stand.price'              '15' ,
*
*                      '71'  'EKALR'         'IT_FINAL'  'With Qty Struc'           '8' ,
*                      '72'  'TAXM1'         'IT_FINAL'  'Tax clas.mat'             '10',
*                      '73'  'TAXM2'         'IT_FINAL'  'Tax clas.mat'             '10' ,
*                      '74'  'TAXM3'         'IT_FINAL'  'Tax clas.mat'             '10' ,
*
*                      '75'  'TAXM4'         'IT_FINAL'  'Tax clas.mat'             '10' ,
*                      '76'  'J_1ICAPIND'    'IT_FINAL'  'Mat.Type'                 '10' ,
*                      '77'  'J_1ISUBIND'    'IT_FINAL'  'Subcontractors'           '10' ,
*                      '78'   'J_1IGRXREF'    'IT_FINAL'  'No.of GR per.EI'          '10' ,
*                      '79'  'ART'           'IT_FINAL'  'Ins.Type'                 '10',
*
*                      '80'  'AKTIV'         'IT_FINAL'  'Ins.Active'               '10',
*
*                      '81'  'J_1IVALASS'    'IT_FINAL'  'Assessable Value'         '15',
*                      '82'  'J_1IMOOM'        'IT_FINAL'  'Output Mat.'  '18 ',
*                      '83'  'MATTXT'        'IT_FINAL'  'Long Text'                ' ' ,
*                      '84'  'SPAN'          'IT_FINAL'  'Item.Span.txt'            ' ',
*                      '85'  'CLASS'             'IT_FINAL'  'Class'               '8',
*                      '86'  'STEM    '          'IT_FINAL'  'Stem'                '18',
*                      '87'  'SEAT    '          'IT_FINAL'  'Seat'                '18',
*                      '88'  'BODY    '          'IT_FINAL'  'Body'                '18',
*                      '89'  'DISC    '          'IT_FINAL'  'Disc'                '18',
*                      '90'  'BALL    '          'IT_FINAL'  'Ball'                '18',
*                      '91'  'RATING  '          'IT_FINAL'  'Rating'              '18',
*                      '92'  'CLAS   '           'IT_FINAL'  'Class'               '18',
*                      '93'  'AIR_F   '          'IT_FINAL'  'Air_Fail_Position'   '18',
*                      '94'  'MAIN_AIR'          'IT_FINAL'  'Min_Air_Pressure'    '18',
*                      '95'  'LVORM'           'IT_FINAL'  'Deletion Ind'        '12' ,
*                      '96'  'REF'           'IT_FINAL'  'Refresh File Date'        '12' ,
*                      '96'   'NORMT'           'IT_FINAL'  'BOM Status'        '18' ,     "ADDED BY GANGA 15.03.2019
*                      '97'  'BOM'           'IT_FINAL'  'BOM Status'        '18' ,     "ADDED BY Nilay 23.03.2023
*                      '98'  'NCOST'           'IT_FINAL'    'Do Not Cost'     '15',
*                      '99'  'SOBSK'           'IT_FINAL'    'SpecProcurem Costing'     '15',
*                      '100' 'RM01'           'IT_FINAL'    'RM01'     '10',
*                      '101' 'FG01'           'IT_FINAL'    'FG01'     '10',
*                      '102' 'PRD1'           'IT_FINAL'    'PRD1'     '10',
*                      '103' 'RJ01'           'IT_FINAL'    'RJ01'     '10',
*                      '104' 'RWK1'           'IT_FINAL'    'RWK1'     '10',
*                      '105' 'SCR1'           'IT_FINAL'    'SCR1'     '10',
*                      '106' 'SFG1'           'IT_FINAL'    'SFG1'     '10',
*                      '107' 'SRN1'           'IT_FINAL'    'SRN1'     '10',
*                      '108' 'VLD1'           'IT_FINAL'    'VLD1'     '10',
*                      '109' 'PLG1'           'IT_FINAL'    'PLG1'     '10',
*                      '110' 'TPI1'           'IT_FINAL'    'TPI1'     '10',
*                      '111' 'SC01'           'IT_FINAL'    'SC01'     '10',
*                      '112' 'SPC1'           'IT_FINAL'    'SPC1'     '10',
*                      '113' 'SLR1'           'IT_FINAL'    'SLR1'     '10',
*                      '114' 'DIS10'           'IT_FINAL'    'Dis.Ch.10'     '10',
*                      '115' 'DIS20'           'IT_FINAL'    'Dis.Ch.20'     '10',
*                      '116' 'DIS30'           'IT_FINAL'    'Dis.Ch.30'     '10',
*                      '117' 'ZZEDS'           'IT_FINAL'    'EDS'           '10',
*                      '118' 'ZZMSS'           'IT_FINAL'    'MSS'           '10',
*                      '119' 'VMSTA'           'IT_FINAL'    'Dst.chl.loc'   '10',
*                      '120' 'VMSTB'           'IT_FINAL'    'Dst.chl.loc Desc'   '20',
*                      '121' 'USERNAME'        'IT_FINAL'    'Deleted By'      '20',
*                      '122' 'UDATE   '        'IT_FINAL'    'Deleted On'      '20',
*                      '123' 'TCODE   '        'IT_FINAL'    'T-code'      '20',
*                      '124' 'TAXM8   '        'IT_FINAL'    'Tax clas.mat'      '20',
*                      '125' 'CAP   '          'IT_FINAL'    'CAP Lead Time'      '20',
*                      '126' 'ZPLP3   '          'IT_FINAL'    'Planned Price 3'      '20',
*                      '127' 'ZPLD3  '          'IT_FINAL'    'Planned Price Date'      '20',
*                      '128' 'ITEM_TYPE'       'IT_FINAL'    'Item Type'      '5',
*                      '129' 'AIR_PRESSURE'       'IT_FINAL'    'Min Air Supply Pressure'      '4',
*                      '130' 'AIR_FAIL'       'IT_FINAL'    'Air fail position'      '15',
*                      '131' 'ACTUATOR'       'IT_FINAL'    'Actuator sizing done on diff. Pressure'      '25',
*                       '132' 'VERTICAL'       'IT_FINAL'    'Vertical'      '15',
*                       '133' 'PPRDL'       'IT_FINAL'    'Current Period'      '15',
*                       '134' 'PDATL'       'IT_FINAL'    'Current Fiscal Year'      '15',
*                       '135' 'LPLPR'       'IT_FINAL'    'Current Planned Price'      '15',
*                       '136' 'PPRDV'       'IT_FINAL'    'Perivoius Period'      '15',
*                       '137' 'PDATV'       'IT_FINAL'    'Previous Fiscal Year'      '15',
*                       '138' 'VPLPR'       'IT_FINAL'    'Previous Planned Price'      '15',
*                       '139'  'KZKFG'       'IT_FINAL'    'Material is Configurable'    '15',  "added by shreya 15-02-2022
*                       '140'  'MODIFY_DATE' 'IT_FINAL'    'Modify Date'    '15',
*                       '141'  'Dev_Status' 'IT_FINAL'     'Development Status' '23',
*                       '142'  'ZKANBAN'    'IT_FINAL'     'KANBAN Item'        '1',
*                       '143'  'ZPEN_ITEM'  'IT_FINAL'     'Pending Item'       '20',
*                       '144'  'ZRE_PEN_ITEM'  'IT_FINAL'     'Reason for Pending Item'       '20',
*                      '145'    'MCN1'           'IT_FINAL'    'MCN1'     '10',
*                      '146'   'PN01'           'IT_FINAL'    'PN01'     '10',
*                      '147'   'ZQAP'           'IT_FINAL'    'QAP Number'     '08',"ADDED BY JYOTI ON 02.04.2024
*                      '148'   'REV_NO'           'IT_FINAL'    'Revision No.'     '02',"ADDED BY JYOTI ON 02.04.2024
*                      '149'   'ZBOI'           'IT_FINAL'    'Bought Out Item'     '02',"ADDED BY JYOTI ON 05.04.2024
*                      '150'   'WRKST'           'IT_FINAL'    'Basic MAterial'     '48',"ADDED BY JYOTI ON21.06.2024'
*                      '151'      'KMCN'           'IT_FINAL'    'KMCN'     '10',
*                      '152'     'KNDT'           'IT_FINAL'    'KNDT'     '10',
*                      '153'     'KPLG'           'IT_FINAL'    'KPLG'     '10',
*                      '154'     'KPR1'           'IT_FINAL'    'KPR1'     '10',
*                      '155'     'KPRD'           'IT_FINAL'    'KPRD'     '10',
*                      '156'     'KRJ0'           'IT_FINAL'    'KRJ0'     '10',
*                      '157'     'KRM0'           'IT_FINAL'    'KRM0'     '10',
*                      '158'     'KRWK'           'IT_FINAL'    'KRWK'     '10',
*                      '159'     'KSC0'           'IT_FINAL'    'KSC0'     '10',
*                      '160'     'KSCR'           'IT_FINAL'    'KSCR'     '10',
*                      '161'     'KSFG'           'IT_FINAL'    'KSFG'     '10',
*                      '162'     'KSLR'           'IT_FINAL'    'KSLR'     '10',
*                      '163'     'KSPC'           'IT_FINAL'    'KSPC'     '10',
*                      '164'     'KSRN'           'IT_FINAL'    'KSRN'     '10',
*                      '165'     'KTPI'           'IT_FINAL'    'KTPI'     '10',
*                      '166'     'KVLD'           'IT_FINAL'    'KVLD'     '10',
*                      '167'     'KFG0'           'IT_FINAL'    'KFG0'     '10'.

**************************************************************************************************
                      "marc Table
                      '27'  'WERKS'         'IT_FINAL'  'Plant'                    '5' ,
                      '28'  'MTVFP'         'IT_FINAL'  'Avail.Chk'                '10',
                      '29'  'LADGR'         'IT_FINAL'  'Load.Group'               '10' ,
                      '30'  'PRCTR'         'IT_FINAL'  'Profit Center'            '10' ,
                      '31'  'SERNP'         'IT_FINAL'  'Ser.No.Prof'              '10' ,
                      '32'  'EKGRP'         'IT_FINAL'  'Pur.Group'                '10' ,
                      '33'  'DISMM'         'IT_FINAL'  'MRP Type'                 '7' ,
                      '34'  'DISPO'         'IT_FINAL'  'MRP Cont'                 '8' ,
                      '35'  'BSTMI'         'IT_FINAL'  'Min.Ord.Quntity'         '18' ,
                      '36'  'DISLS'         'IT_FINAL'  'Lot size'                 '8' ,
                      '37'  'BESKZ'         'IT_FINAL'  'Procur.Type'              '11' ,
                      '38'  'SOBSL'         'IT_FINAL'  'Spec.proc.type'           '15' ,
                      '39'  'WZEIT  '       'IT_FINAL'  'Repl.Lead Time'           '10' ,
                      '40'  'PLIFZ  '       'IT_FINAL'  'Plan.Del.Time'            '18',
                      '41'  'FHORI  '       'IT_FINAL'  'Sched.Margin'             '10' ,
                      '42'  'STRGR  '       'IT_FINAL'  'strat.group'              '10' ,
                      '43'  'VRMOD  '       'IT_FINAL'  'Consum.mode'              '10' ,
                      '44'  'VINT1  '       'IT_FINAL'  'Consum.peri backward'     '18' ,
                      '45'  'VINT2  '       'IT_FINAL'  'Consum.peri forward'      '18' ,
                      '46'  'SBDKZ  '       'IT_FINAL'  'Indi/Coll'                '10' ,
                      '47'  'FEVOR'         'IT_FINAL'  'Prod.Sched'               '10' ,
                      '48'  'SFCPF'         'IT_FINAL'  'Prod.Sched.Prof'          '10',
                      '49'  'DZEIT'         'IT_FINAL'  'Prod.Time'                '10' ,
                      '50'  'AUSME'         'IT_FINAL'  'Unit of issue'            '15' ,
                      '51'  'LOSGR'         'IT_FINAL'  'Costing Lot Size'         '18' ,
                      '52'  'STEUC'         'IT_FINAL'  'HSN Code'                 '18' ,
                      '53'  'SSQSS'         'IT_FINAL'  'QM Cont.Key'              '18' ,
                      '54'  'MISKZ'         'IT_FINAL'  'Mix.MRP.Ind'              '10' ,


                        "mard table.
                      '55'  'LGORT'         'IT_FINAL'  'Stor.Loc'                 '10' ,
                      '56'  'LGPBE'         'IT_FINAL'  'Stor.Bin'                 '10' ,

                        "mvke table.
                      '57'  'VKORG'         'IT_FINAL'  'Sale.Org.'                '10' ,
                      '58'  'VTWEG'         'IT_FINAL'  'Dist.Chan'                '10',
                      '59'  'DWERK'         'IT_FINAL'  'Deli.Plant'               '10' ,
                      '60'  'VERSG'         'IT_FINAL'  'Mate.stat.group'          '10' ,
                      '61'  'KTGRM'         'IT_FINAL'  'Ac.Ass'                   '6' ,
                      '62'  'MTPOS'         'IT_FINAL'  'Itm.Cat.grp'              '10' ,


                          "marm table
                      '63'  'MEINH'         'IT_FINAL'  'Alt.UOM'                '8' ,
                      '64'  'UMREZ'         'IT_FINAL'  'Conv Factor'            '8' ,
                      '65'  'UMREN'         'IT_FINAL'  'Den.conv'               '8' ,

                      "mbew table.
                      '66'  'BKLAS'         'IT_FINAL'  'Val.Class'                '10' ,
                      '67'  'VPRSV'         'IT_FINAL'  'Pri.cont.ind'             '10',
                      '68'  'VERPR'         'IT_FINAL'  'Mov.price'                '15' ,
                      '69'  'STPRS'         'IT_FINAL'  'Stand.price'              '15' ,
                      '70'  'EKALR'         'IT_FINAL'  'With Qty Struc'           '8' ,

                      "mlan table
                      '71'  'TAXM1'         'IT_FINAL'  'Tax clas.mat'             '10',
                      '72'  'TAXM2'         'IT_FINAL'  'Tax clas.mat'             '10' ,
                      '73'  'TAXM3'         'IT_FINAL'  'Tax clas.mat'             '10' ,
                      '74'  'TAXM4'         'IT_FINAL'  'Tax clas.mat'             '10' ,

                      "J_1IMTCHID table
                      '75'  'J_1ICAPIND'    'IT_FINAL'  'Mat.Type'                 '10' ,
                      '76'  'J_1ISUBIND'    'IT_FINAL'  'Subcontractors'           '10' ,
                      '77'  'J_1IGRXREF'    'IT_FINAL'  'No.of GR per.EI'          '10' ,


                      "QMAT TABLE

                      '78'  'ART'           'IT_FINAL'  'Ins.Type'                 '10',
                      '79'  'AKTIV'         'IT_FINAL'  'Ins.Active'               '10',

                      "J_1IASSVAL table
                      '80'  'J_1IVALASS'    'IT_FINAL'  'Assessable Value'         '15',

                      "J_1IMODDET TABLE
                      '81'  'J_1IMOOM'        'IT_FINAL'  'Output Mat.'                '18' ,

                      " long txt
                      '82'  'MATTXT'        'IT_FINAL'  'Long Text'                ' ' ,
                      '83'  'SPAN'          'IT_FINAL'  'Item.Span.txt'            ' ',

                      "classification ausp table
                      '84'  'CLASS'             'IT_FINAL'  'Class'               '8',
                      '85'  'STEM    '          'IT_FINAL'  'Stem'                '18',
                      '86'  'SEAT    '          'IT_FINAL'  'Seat'                '18',
                      '87'  'BODY    '          'IT_FINAL'  'Body'                '18',
                      '88'  'DISC    '          'IT_FINAL'  'Disc'                '18',
                      '89'  'BALL    '          'IT_FINAL'  'Ball'                '18',
                      '90'  'RATING  '          'IT_FINAL'  'Rating'              '18',
                      '91'  'CLAS   '           'IT_FINAL'  'Class'               '18',
                      '92'  'AIR_F   '          'IT_FINAL'  'Air_Fail_Position'   '18',
                      '93'  'MAIN_AIR'          'IT_FINAL'  'Min_Air_Pressure'    '18',

                      "REFRESH DATE"

                      '94'  'LVORM'           'IT_FINAL'  'Deletion Ind'        '12' ,
                      '95'  'REF'           'IT_FINAL'  'Refresh File Date'        '12' ,
*                      '96'  'NORMT'           'IT_FINAL'  'BOM Status'        '18' ,     "ADDED BY GANGA 15.03.2019
                      '96'  'BOM'           'IT_FINAL'  'BOM Status'        '18' ,     "ADDED BY Nilay 23.03.2023
                      '97'  'NCOST'           'IT_FINAL'    'Do Not Cost'     '15',
                      '98'  'SOBSK'           'IT_FINAL'    'SpecProcurem Costing'     '15',

                      "Storage Location
                      '99'   'RM01'           'IT_FINAL'    'RM01'     '10',
                      '100'  'FG01'           'IT_FINAL'    'FG01'     '10',
                      '101'  'PRD1'           'IT_FINAL'    'PRD1'     '10',
                      '102'  'RJ01'           'IT_FINAL'    'RJ01'     '10',
                      '103'  'RWK1'           'IT_FINAL'    'RWK1'     '10',
                      '104'  'SCR1'           'IT_FINAL'    'SCR1'     '10',
                      '105'  'SFG1'           'IT_FINAL'    'SFG1'     '10',
                      '106'  'SRN1'           'IT_FINAL'    'SRN1'     '10',
                      '107'  'VLD1'           'IT_FINAL'    'VLD1'     '10',
                      '108'  'PLG1'           'IT_FINAL'    'PLG1'     '10',
                      '109'  'TPI1'           'IT_FINAL'    'TPI1'     '10',
                      '110'  'SC01'           'IT_FINAL'    'SC01'     '10',
                      '111'  'SPC1'           'IT_FINAL'    'SPC1'     '10',
                      '112'  'SLR1'           'IT_FINAL'    'SLR1'     '10',

                      "Distribution Channel
                      '113'  'DIS10'           'IT_FINAL'    'Dis.Ch.10'     '10',
                      '114'  'DIS20'           'IT_FINAL'    'Dis.Ch.20'     '10',
                      '115'  'DIS30'           'IT_FINAL'    'Dis.Ch.30'     '10',
                      '116'  'ZZEDS'           'IT_FINAL'    'EDS'           '10',
                      '117'  'ZZMSS'           'IT_FINAL'    'MSS'           '10',
                      '118'  'VMSTA'           'IT_FINAL'    'Dst.chl.loc'   '10',
                      '119'  'VMSTB'           'IT_FINAL'    'Dst.chl.loc Desc'   '20',
                      '120'  'USERNAME'        'IT_FINAL'    'Deleted By'      '20',
                      '121'  'UDATE   '        'IT_FINAL'    'Deleted On'      '20',
                      '122'  'TCODE   '        'IT_FINAL'    'T-code'      '20',
                      '123'  'TAXM8   '        'IT_FINAL'    'Tax clas.mat'      '20',
                      '124'  'CAP   '          'IT_FINAL'    'CAP Lead Time'      '20',
                      '125'  'ZPLP3   '          'IT_FINAL'    'Planned Price 3'      '20',
                      '126'  'ZPLD3  '          'IT_FINAL'    'Planned Price Date'      '20',
                      '127'  'ITEM_TYPE'       'IT_FINAL'    'Item Type'      '5',
                      '128'  'AIR_PRESSURE'       'IT_FINAL'    'Min Air Supply Pressure'      '4',
                      '129'  'AIR_FAIL'       'IT_FINAL'    'Air fail position'      '15',
                      '130'  'ACTUATOR'       'IT_FINAL'    'Actuator sizing done on diff. Pressure'      '25',
                      '131'  'VERTICAL'       'IT_FINAL'    'Vertical'      '15',

                      """"Code added by pankaj 17.01.2022
                       '132'  'PPRDL'       'IT_FINAL'    'Current Period'      '15',
                       '133'  'PDATL'       'IT_FINAL'    'Current Fiscal Year'      '15',
                       '134'  'LPLPR'       'IT_FINAL'    'Current Planned Price'      '15',
                       '135'  'PPRDV'       'IT_FINAL'    'Perivoius Period'      '15',
                       '136'  'PDATV'       'IT_FINAL'    'Previous Fiscal Year'      '15',
                       '137'  'VPLPR'       'IT_FINAL'    'Previous Planned Price'      '15',

                       '138'  'KZKFG'       'IT_FINAL'    'Material is Configurable'    '15',  "added by shreya 15-02-2022

                       '139'  'MODIFY_DATE' 'IT_FINAL'    'Modify Date'    '15',
                       '140'  'Dev_Status' 'IT_FINAL'     'Development Status' '23',
                       '141'  'ZKANBAN'    'IT_FINAL'     'KANBAN Item'        '1',
                       '142'  'ZPEN_ITEM'  'IT_FINAL'     'Pending Item'       '20',
                       '143'  'ZRE_PEN_ITEM'  'IT_FINAL'     'Reason for Pending Item'       '20',
                       '144'   'MCN1'           'IT_FINAL'    'MCN1'     '10',
                      '145'   'PN01'           'IT_FINAL'    'PN01'     '10',
                      '146'   'ZQAP'           'IT_FINAL'    'QAP Number'     '08',"ADDED BY JYOTI ON 02.04.2024
                      '147'   'REV_NO'           'IT_FINAL'    'Revision No.'     '02',"ADDED BY JYOTI ON 02.04.2024
                      '148'   'ZBOI'           'IT_FINAL'    'Bought Out Item'     '02',"ADDED BY JYOTI ON 05.04.2024
                      '149'   'WRKST'           'IT_FINAL'    'Basic MAterial'     '48',"ADDED BY JYOTI ON21.06.2024'

                      "Added by Saurabh ON 5.9.2024********************
                      '150'   'KMCN'           'IT_FINAL'    'KMCN'     '10',
                      '151'  'KNDT'           'IT_FINAL'    'KNDT'     '10',
                      '152'  'KPLG'           'IT_FINAL'    'KPLG'     '10',
                      '153'  'KPR1'           'IT_FINAL'    'KPR1'     '10',
                      '154'  'KPRD'           'IT_FINAL'    'KPRD'     '10',
                      '155'  'KRJ0'           'IT_FINAL'    'KRJ0'     '10',
                      '156'  'KRM0'           'IT_FINAL'    'KRM0'     '10',
                      '157'  'KRWK'           'IT_FINAL'    'KRWK'     '10',
                      '158'  'KSC0'           'IT_FINAL'    'KSC0'     '10',
                      '159'  'KSCR'           'IT_FINAL'    'KSCR'     '10',
                      '160'  'KSFG'           'IT_FINAL'    'KSFG'     '10',
                      '161'  'KSLR'           'IT_FINAL'    'KSLR'     '10',
                      '162'  'KSPC'           'IT_FINAL'    'KSPC'     '10',
                      '163'  'KSRN'           'IT_FINAL'    'KSRN'     '10',
                      '164'  'KTPI'           'IT_FINAL'    'KTPI'     '10',
                      '165'  'KVLD'           'IT_FINAL'    'KVLD'     '10',
                      '166'  'KFG0'           'IT_FINAL'    'KFG0'     '10',
                      '167'  'ZITEM_CLASS'    'IT_FINAL'   'ITEM CLASS'  '3'.
  .
****************************************************************************************
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
  DELETE it_final WHERE werks NE 'PL01'.
*  EXPORT it_final TO MEMORY ID 'ZITMMASS'.

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
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  ENDIF.
  IF p_down = 'X'.
    PERFORM download TABLES it_final USING p_folder.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1200   text
*      -->P_1201   text
*      -->P_1202   text
*      -->P_1203   text
*      -->P_1204   text
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
  wa_fcat-outputlen = p5.

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
FORM download TABLES it_final USING p_folder.
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
      i_tab_sap_data       = it_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*  IF p_hidden IS INITIAL OR p_hidden = 'Task 1'.
  IF p_hidden IS INITIAL.
    PERFORM cvs_header USING hd_csv.
  ENDIF.



*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file =   'ZITEM.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZITEM MASTER Download started on', sy-datum, 'at', sy-uzeit.
*  IF p_hidden IS INITIAL OR p_hidden = 'Task 1'.
    OPEN DATASET lv_fullfile
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT MESSAGE lv_msg.  "NON-UNICODE.
    IF sy-subrc = 0.
      DATA lv_string_1787 TYPE string.
      DATA lv_crlf_1787 TYPE string.
      lv_crlf_1787 = cl_abap_char_utilities=>cr_lf.
      lv_string_1787 = hd_csv.
      LOOP AT it_csv INTO wa_csv.
        CONCATENATE lv_string_1787 lv_crlf_1787 wa_csv INTO lv_string_1787.
        CLEAR: wa_csv.
      ENDLOOP.

    ENDIF.
*  ELSE.
*    OPEN DATASET lv_fullfile
*   FOR APPENDING IN TEXT MODE ENCODING DEFAULT MESSAGE lv_msg.
*    IF sy-subrc = 0.
*      lv_crlf_1787 = cl_abap_char_utilities=>cr_lf.
*      DESCRIBE TABLE it_csv LINES DATA(lv_linetem).
*      LOOP AT it_csv INTO wa_csv.
*        IF lv_linetem > 1.
*          IF sy-tabix = 1.
**            lv_string_1787 = wa_csv.
*            CONCATENATE lv_crlf_1787  wa_csv  lv_crlf_1787 INTO lv_string_1787.
*          else.
*           CONCATENATE lv_string_1787 lv_crlf_1787 wa_csv INTO lv_string_1787.
*          ENDIF.
*
*        else.
*           CONCATENATE  wa_csv lv_crlf_1787 INTO lv_string_1787.
*         lv_string_1787 =  wa_csv.
*        ENDIF.
**        lv_string_1787 = wa_csv.
**         TRANSFER lv_string_1787 TO lv_fullfile.
*        CLEAR: wa_csv.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.

 TRANSFER lv_string_1787 TO lv_fullfile.
*CLOSE DATASET lv_fullfile.
*  TRANSFER lv_string_1787 TO lv_fullfile.
 CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
  MESSAGE lv_msg TYPE 'S'.

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
  CONCATENATE 'Ext.Mat.No.'
              'Material Type'
              'Created On'
              'Created By'
              'Old material number'
              'Ext.Material Group'
              'Material Group'
              'Divis'
              'Gross Weight'
              'Base Unit of Measure'
              'Net Weight'
              'Gen.item cat.group'
              'Transportation Group'
              'Matl.Grp.Pack.Matls'
              'Purc.Ord.Unit'
              'series code'
              'Size'
              'Brand'
              'MOC'
              'TYPE'
              'QM proc active'
              'Mainten status'
              'Stor.cond'
              'Drawing No'
              'Rev.No'
              'Mat.Descr'
              'Plant'
              'Avail.Chk'
              'Load.Group'
              'Profit Center'
              'Ser.No.Prof'
              'Pur.Group'
              'MRP Type'
              'MRP Cont'
              'Min.Ord.Quntity'
              'Lot size'
              'Procur.Type'
              'Spec.proc.type'
              'Repl.Lead Time'
              'Plan.Del.Time'
              'Sched.Margin'
              'strat.group'
              'Consum.mode'
              'Consum.peri backward'
              'Consum.peri forward'
              'Indi/Coll'
              'Prod.Sched'
              'Prod.Sched.Prof'
              'Prod.Time'
              'Unit of issue'
              'Costing Lot Size'
              'HSN Code'
              'QM Cont.Key'
              'Mix.MRP.Ind'
              'Stor.Loc'
              'Stor.Bin'
              'Sale.Org.'
              'Dist.Chan'
              'Deli.Plant'
              'Mate.stat.group'
              'Ac.Ass'
              'Itm.Cat.grp'
              'Alt.UOM'
              'Conv Factor'
              'Den.conv'
              'Val.Class'
              'Pri.cont.ind'
              'Mov.price'
              'Stand.price'
              'With Qty Struc'
              'Tax clas.mat'
              'Tax clas.mat'
              'Tax clas.mat'
              'Tax clas.mat'
              'Mat.Type'
              'Subcontractors'
              'No.of GR per.EI'
              'Ins.Type'
              'Ins.Active'
              'Assessable Value'
              'Output Mat.'
              'Long Text'
*              'Item.Span.txt'
              'Class'
              'Stem'
              'Seat'
              'Body'
              'Disc'
              'Ball'
              'Rating'
              'Class'
              'Air_Fail_Position'
              'Min_Air_Pressure'
              'Deletion Indicator'
              'Refresh File Date'
              'BOM Status'
              'Do Not Cost'
              'SpecProcurem Costing'
              'RM01'
              'FG01'
              'PRD1'
              'RJ01'
              'RWK1'
              'SCR1'
              'SFG1'
              'SRN1'
              'VLD1'
              'PLG1'
              'TPI1'
              'SC01'
              'SPC1'
              'SLR1'
              'Dis.Ch.10'
              'Dis.Ch.20'
              'Dis.Ch.30'
              'EDS'
              'MSS'
              'Dst.chl.loc'
              'Dst.chl.loc Desc'
              'Deleted By'
              'Deleted On'
              'T-code'
              'Tax clas.mat'
              'CAP Lead Time'
              'Planned Price 3'
              'Planned Price Date'
              'Item Type'
              'Min Air Pressure'
              'Air fail position'
              'Actuator Pressure'
              'Vertical'
              "" added by pankaj 17.01.2022
              'Current Period'
              'Current Fiscal Year'
              'Current Planned Price'
              'Perivoius Period'
              'Previous Fiscal Year'
              'Previous Planned Price'
              'Material is Configurable'
              'Modify Date'
              'Development Status'
              'KANBAN Item'
              'Pending Item'
              'Reason for Pending Item'
              'MCN1'
              'PN01'
              'QAP Number'
              'Revision No.'
              'Bought Out Item' "added by jyoti
              'Refreshable Time'
              'Basic Material' "added by jyoti
"ADDED BY SAURABH ON 5.9.2024
              'KMCN'
              'KNDT'
              'KPLG'
              'KPR1'
              'KPRD'
              'KRJ0'
              'KRM0'
              'KRWK'
              'KSC0'
              'KSCR'
              'KSFG'
              'KSLR'
              'KSPC'
              'KSRN'
              'KTPI'
              'KVLD'
              'KFG0'
              'ITEM CLASS'
***********************************
              'Item.Span.txt'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
