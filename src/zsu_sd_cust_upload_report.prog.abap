*&---------------------------------------------------------------------*
*&Report: ZSU_SD_CUST_UPLOAD_REPORT
*&Transaction:  ZSU_CUST_MASTER
*&Functional Cosultant: Tejswini Kapadnis
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZSD_CUST_UPLOAD_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsu_sd_cust_upload_report.



TABLES: knb1.

TYPES: BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         ktokd TYPE kna1-ktokd,
         anred TYPE kna1-anred,
         name1 TYPE kna1-name1,
         name2 TYPE kna1-name2,
         land1 TYPE kna1-land1,
         regio TYPE kna1-regio,
         telf2 TYPE kna1-telf2,
         adrnr TYPE kna1-adrnr,
         stcd3 TYPE kna1-stcd3,
         erdat TYPE kna1-erdat,
       END OF ty_kna1,

       BEGIN OF ty_kna12,
         kunnr TYPE cdhdr-objectid,   "kna1-kunnr,
         ktokd TYPE kna1-ktokd,
         anred TYPE kna1-anred,
         name1 TYPE kna1-name1,
         name2 TYPE kna1-name2,
         land1 TYPE kna1-land1,
         regio TYPE kna1-regio,
         telf2 TYPE kna1-telf2,
         adrnr TYPE kna1-adrnr,
         stcd3 TYPE kna1-stcd3,
         erdat TYPE kna1-erdat,
       END OF ty_kna12,

       BEGIN OF ty_knb1,
         kunnr TYPE knb1-kunnr,
         bukrs TYPE knb1-bukrs,
         akont TYPE knb1-akont,
         zuawa TYPE knb1-zuawa,
         zterm TYPE knb1-zterm,
         xverr TYPE knb1-xverr,
         zwels TYPE knb1-zwels,
         knrzb TYPE knb1-knrzb,
         hbkid TYPE knb1-hbkid,
         altkn TYPE knb1-altkn,
       END OF ty_knb1,

       BEGIN OF ty_knvv,
         kunnr TYPE knvv-kunnr,
         vkorg TYPE knvv-vkorg,
         vtweg TYPE knvv-vtweg,
         spart TYPE knvv-spart,
         vkbur TYPE knvv-vkbur,
         kdgrp TYPE knvv-kdgrp,
         waers TYPE knvv-waers,
         kalks TYPE knvv-kalks,
         versg TYPE knvv-versg,
         kvgr1 TYPE knvv-kvgr1,
         lprio TYPE knvv-lprio,
         vsbed TYPE knvv-vsbed,
         vwerk TYPE knvv-vwerk,
         inco1 TYPE knvv-inco1,
         inco2 TYPE knvv-inco2,
         zterm TYPE knvv-zterm,
         ktgrd TYPE knvv-ktgrd,
       END OF ty_knvv,


       BEGIN OF ty_knvt,
         kunnr TYPE knvv-kunnr,
         vkorg TYPE knvv-vkorg,
         vtweg TYPE knvv-vtweg,
         spart TYPE knvv-spart,
       END OF ty_knvt,

       BEGIN OF ty_tinct,
         spras TYPE tinct-spras,
         inco1 TYPE tinct-inco1,
         bezei TYPE tinct-bezei,
       END OF ty_tinct,


       BEGIN OF ty_adrc,
         addrnumber TYPE adrc-addrnumber,
         name1      TYPE adrc-name1,
         name2      TYPE adrc-name2,
         name3      TYPE adrc-name3,
         sort1      TYPE adrc-sort1,
         street     TYPE adrc-street,
         house_num1 TYPE adrc-house_num1,
         post_code1 TYPE adrc-post_code1,
         city1      TYPE adrc-city1,
         city2      TYPE adrc-city2,
         country    TYPE adrc-country,
         region     TYPE adrc-region,
         langu      TYPE adrc-langu,
         tel_number TYPE adrc-tel_number,
         fax_number TYPE adrc-fax_number,
         str_suppl1 TYPE adrc-str_suppl1,
         str_suppl2 TYPE adrc-str_suppl2,
         str_suppl3 TYPE adrc-str_suppl3,
         location   TYPE adrc-location,
       END OF ty_adrc,

       BEGIN OF ty_adr6,
         addrnumber TYPE adr6-addrnumber,
         smtp_addr  TYPE adr6-smtp_addr,
       END OF ty_adr6,

       BEGIN OF ty_knvi,
         kunnr TYPE knvi-kunnr,
         tatyp TYPE knvi-tatyp,
         taxkd TYPE knvi-taxkd,
       END OF ty_knvi,

*       BEGIN OF TY_KNVP,
*       KUNNR TYPE KNVP-KUNNR,
*       PARVW TYPE KNVP-PARVW,
*       END OF TY_KNVP,

       BEGIN OF ty_knvp,               " Add subodh 19 feb 2018
         kunnr TYPE knvp-kunnr,
         vkorg TYPE knvp-vkorg,
         vtweg TYPE knvp-vtweg,
         spart TYPE knvp-spart,
         parvw TYPE knvp-parvw,
         parza TYPE knvp-parza,
         kunn2 TYPE knvp-kunn2,
       END OF ty_knvp,



       BEGIN OF ty_t005u,
         spras TYPE t005u-spras,
         land1 TYPE t005u-land1,
         bland TYPE t005u-bland,
         bezei TYPE t005u-bezei,
       END OF ty_t005u,

       BEGIN OF ty_tzunt,
         zuawa TYPE tzunt-zuawa,
         ttext TYPE tzunt-ttext,
       END OF ty_tzunt,

       BEGIN OF ty_tvzbt,
         spras TYPE tvzbt-spras,
         zterm TYPE tvzbt-zterm,
         vtext TYPE tvzbt-vtext,
       END OF ty_tvzbt,


       BEGIN OF ty_t005t,
         spras TYPE t005t-spras,
         land1 TYPE t005t-land1,
         landx TYPE t005t-landx,
       END OF ty_t005t,


       BEGIN OF ty_j_1imocust,
         kunnr      TYPE j_1imocust-kunnr,
         j_1iexcd   TYPE j_1imocust-j_1iexcd,
         j_1iexrn   TYPE j_1imocust-j_1iexrn,
         j_1iexrg   TYPE j_1imocust-j_1iexrg,
         j_1iexdi   TYPE j_1imocust-j_1iexdi,
         j_1iexco   TYPE j_1imocust-j_1iexco,
         j_1iexcicu TYPE j_1imocust-j_1iexcicu,
         j_1icstno  TYPE j_1imocust-j_1icstno,
         j_1isern   TYPE j_1imocust-j_1isern,
         j_1ilstno  TYPE j_1imocust-j_1ilstno,
         j_1ipanno  TYPE j_1imocust-j_1ipanno,
         j_1ipanref TYPE j_1imocust-j_1ipanref,

       END OF ty_j_1imocust,

       BEGIN OF ty_cdhdr,
         objectid TYPE cdhdr-objectid,
         udate    TYPE cdhdr-udate,
         tcode    TYPE cdtcode,
       END OF ty_cdhdr,


       BEGIN OF ty_final,
         ktokd      TYPE kna1-ktokd,
         kunnr      TYPE kna1-kunnr,
         bukrs      TYPE knb1-bukrs,
         vkorg      TYPE knvv-vkorg,
         vtweg      TYPE knvv-vtweg,
         spart      TYPE knvv-spart,
         anred      TYPE kna1-anred,
         name1      TYPE adrc-name1,
         name2      TYPE adrc-name2,
         name3      TYPE adrc-name3,
         sort1      TYPE adrc-sort1,
         street     TYPE adrc-street,
         house_num1 TYPE adrc-house_num1,
         str_suppl1 TYPE adrc-str_suppl1,
         str_suppl2 TYPE adrc-str_suppl2,
         str_suppl3 TYPE adrc-str_suppl3,
         post_code1 TYPE adrc-post_code1,
         city1      TYPE adrc-city1,
         city2      TYPE adrc-city2,
         country    TYPE adrc-country,
         landx      TYPE t005t-landx,
         regio      TYPE kna1-regio,
         region     TYPE adrc-region,
         bezei      TYPE t005u-bezei,
         langu      TYPE adrc-langu,
         tel_number TYPE adrc-tel_number,
         telf2      TYPE kna1-telf1,
         fax_number TYPE adrc-fax_number,
         smtp_addr  TYPE adr6-smtp_addr,
         akont      TYPE knb1-akont,
         zuawa      TYPE knb1-zuawa,
         ttext      TYPE tzunt-ttext,
         fi_zterm   TYPE knb1-zterm,
         fi_vtext   TYPE tvzbt-vtext,
         xverr      TYPE knb1-xverr,
         zwels      TYPE knb1-zwels,
         knrzb      TYPE knb1-knrzb,
         hbkid      TYPE knb1-hbkid,
         vkbur      TYPE knvv-vkbur,
         kdgrp      TYPE knvv-kdgrp,
         waers      TYPE knvv-waers,
         kalks      TYPE knvv-kalks,
         versg      TYPE knvv-versg,
         kvgr1      TYPE knvv-kvgr1,
         lprio      TYPE knvv-lprio,
         vsbed      TYPE knvv-vsbed,
         vwerk      TYPE knvv-vwerk,
         inco1      TYPE knvv-inco1,
         inco_text  TYPE tinct-bezei,
         inco2      TYPE knvv-inco2,
         zterm      TYPE knvv-zterm,
         vtext      TYPE tvzbt-vtext,
         ktgrd      TYPE knvv-ktgrd,
         taxkd      TYPE knvi-taxkd,
********************************************************** Add subodh 19 feb 2018 ****************************
*       kunnr        TYPE knvp-kunnr,
*       vkorg        TYPE knvp-vkorg,
*       vtweg        TYPE knvp-vtweg,
*       spart        TYPE knvp-spart,
         parvw      TYPE knvp-parvw,
         parza      TYPE knvp-parza,
         kunn2      TYPE knvp-kunn2,
****************************************************************************************************************
*       PARVW        TYPE KNVP-PARVW,
*         j_1iexcd   TYPE j_1imocust-j_1iexcd,
*         j_1iexrn   TYPE j_1imocust-j_1iexrn,
*         j_1iexrg   TYPE j_1imocust-j_1iexrg,
*         j_1iexdi   TYPE j_1imocust-j_1iexdi,
*         j_1iexco   TYPE j_1imocust-j_1iexco,
*         j_1iexcicu TYPE j_1imocust-j_1iexcicu,
*         j_1icstno  TYPE j_1imocust-j_1icstno,
*         j_1isern   TYPE j_1imocust-j_1isern,
         j_1ilstno  TYPE j_1imocust-j_1ilstno,
*         j_1ipanno  TYPE j_1imocust-j_1ipanno,
*         j_1ipanref TYPE j_1imocust-j_1ipanref,
         stcd3      TYPE kna1-stcd3,
         kunn2_ag   TYPE knvp-kunn2,
         kunn2_re   TYPE knvp-kunn2,
         kunn2_rg   TYPE knvp-kunn2,
         kunn2_we   TYPE knvp-kunn2,
         erdat      TYPE kna1-erdat,
         altkn      TYPE knb1-altkn,
         tcs        TYPE knvi-taxkd,
         adrnr      TYPE kna1-adrnr,
         location   TYPE adrc-location,
         objectid   TYPE cdhdr-objectid,
         udate      TYPE char15,                          "cdhdr-udate,
         tcode      TYPE cdtcode,

       END OF ty_final.

************************************************Dowanlod Str***************
TYPES : BEGIN OF itab,
          ktokd      TYPE char10,
          kunnr      TYPE char15,
          bukrs      TYPE char10,
          vkorg      TYPE char10,
          vtweg      TYPE char10,
          spart      TYPE char10,
          anred      TYPE char20,
          name1      TYPE char50,
          name2      TYPE char50,
          name3      TYPE char50,
          sort1      TYPE char30,
          street     TYPE char50,
          str_suppl1 TYPE char50,
          str_suppl2 TYPE char50,
          str_suppl3 TYPE char50,
          house_num1 TYPE char15,
          post_code1 TYPE char15,
          city2      TYPE char50,
          city1      TYPE char50,
          country    TYPE char20,
          landx      TYPE char30,
          region     TYPE char20,
          bezei      TYPE char30,
          langu      TYPE char30,
          tel_number TYPE char30,
          telf2      TYPE char20,
          fax_number TYPE char30,
          smtp_addr  TYPE char128,
          akont      TYPE char30,
          zuawa      TYPE char20,
          ttext      TYPE char50,
          fi_zterm   TYPE char50,
          fi_vtext   TYPE char50,
          xverr      TYPE char30,
          zwels      TYPE char30,
          knrzb      TYPE char30,
          hbkid      TYPE char30,
          vkbur      TYPE char30,
          kdgrp      TYPE char30,
          waers      TYPE char20,
          kalks      TYPE char20,
          versg      TYPE char20,
          kvgr1      TYPE char20,
          lprio      TYPE char20,
          vsbed      TYPE char20,
          vwerk      TYPE char20,
          inco1      TYPE char20,
          inco_text  TYPE char50,
          inco2      TYPE char20,
          zterm      TYPE char50,
          vtext      TYPE char50,
          ktgrd      TYPE char20,
          taxkd      type char20,
*          PARVW             TYPE CHAR20,               commetn subodh 19 feb 2018
*          j_1iexcd   TYPE char30,
*          j_1iexrn   TYPE char30,
*          j_1iexrg   TYPE char30,
*          j_1iexdi   TYPE char30,
*          j_1iexco   TYPE char30,
*          j_1iexcicu TYPE char30,
*          j_1icstno  TYPE char30,
*          j_1ilstno  TYPE char30,
*          j_1isern   TYPE char30,
*          j_1ipanno  TYPE char30,
*          j_1ipanref TYPE char30,
          stcd3      TYPE char20,
************************************************************* add subodh 19 feb 2018 *******************************
*         kunnr type char10,
*         vkorg type char4,
*         vtweg type char2,
*         spart type char2,
*         parvw type char2,
*         parza type char3,
          kunn2_ag   TYPE char10,
          kunn2_re   TYPE char10,
          kunn2_rg   TYPE char10,
          kunn2_we   TYPE char10,
          ref        TYPE char15,
          TIME     TYPE CHAR10,
          erdat      TYPE char15,
          altkn      TYPE char10,
          location   TYPE char30,
          udate      TYPE char15,     "cdhdr-udate,              "DH

        END OF itab.

DATA : lt_final TYPE TABLE OF itab,
       ls_final TYPE          itab.
************************************************end itab*******************************************
DATA : it_kna1       TYPE TABLE OF ty_kna1,
       wa_kna1       TYPE          ty_kna1,

       it_kna12      TYPE TABLE OF ty_kna12,
       wa_kna12      TYPE          ty_kna12,

       it_knb1       TYPE TABLE OF ty_knb1,
       wa_knb1       TYPE          ty_knb1,

       it_knvv       TYPE TABLE OF ty_knvv,
       wa_knvv       TYPE          ty_knvv,

       it_knvt       TYPE TABLE OF ty_knvt,
       wa_knvt       TYPE          ty_knvt,

       it_adrc       TYPE TABLE OF ty_adrc,
       wa_adrc       TYPE          ty_adrc,

       it_adr6       TYPE TABLE OF ty_adr6,
       wa_adr6       TYPE          ty_adr6,

       it_tinct      TYPE TABLE OF ty_tinct,
       wa_tinct      TYPE          ty_tinct,

       it_knvp       TYPE TABLE OF ty_knvp,
       wa_knvp       TYPE          ty_knvp,

       it_knvi       TYPE TABLE OF ty_knvi,
       wa_knvi       TYPE          ty_knvi,

       it_t005u      TYPE TABLE OF ty_t005u,
       wa_t005u      TYPE          ty_t005u,

       it_t005t      TYPE TABLE OF ty_t005t,
       wa_t005t      TYPE          ty_t005t,

       it_fi_tvzbt   TYPE TABLE OF ty_tvzbt,
       wa_fi_tvzbt   TYPE          ty_tvzbt,

       it_tvzbt      TYPE TABLE OF ty_tvzbt,
       wa_tvzbt      TYPE          ty_tvzbt,

       it_tzunt      TYPE TABLE OF ty_tzunt,
       wa_tzunt      TYPE          ty_tzunt,

       it_j_1imocust TYPE TABLE OF ty_j_1imocust,
       wa_j_1imocust TYPE          ty_j_1imocust,

       it_cdhdr      TYPE TABLE OF ty_cdhdr,
       wa_cdhdr      TYPE ty_cdhdr,

       it_final      TYPE TABLE OF ty_final,
       wa_final      TYPE          ty_final,

       lv_kunnr      TYPE cdhdr-objectid,
       lv_kunnr1     TYPE kna1-kunnr.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_kunnr FOR knb1-kunnr,
                s_bukrs FOR knb1-bukrs DEFAULT 'SU00' NO INTERVALS  MODIF ID BU.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/Saudi'."Saudi'."Saudi'. "'/delval/Saudi'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK b3.


AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
START-OF-SELECTION.
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
  SELECT kunnr
         bukrs
         akont
         zuawa
         zterm
         xverr
         zwels
         knrzb
         hbkid
         altkn FROM knb1 INTO TABLE it_knb1
         WHERE kunnr IN s_kunnr
         AND   bukrs IN s_bukrs.

  IF it_knb1 IS NOT INITIAL.
    SELECT kunnr
           ktokd
           anred
           name1
           name2
           land1
           regio
           telf2
           adrnr
           stcd3
           erdat FROM kna1 INTO TABLE it_kna1
           FOR ALL ENTRIES IN it_knb1
           WHERE kunnr = it_knb1-kunnr.


    SELECT zuawa
           ttext FROM tzunt INTO TABLE it_tzunt
           FOR ALL ENTRIES IN it_knb1
           WHERE zuawa = it_knb1-zuawa.

    SELECT spras
           zterm
           vtext FROM tvzbt INTO TABLE it_fi_tvzbt
           FOR ALL ENTRIES IN it_knb1
           WHERE zterm = it_knb1-zterm
           AND   spras = 'E'.
  ENDIF.

  IF it_kna1 IS NOT INITIAL.
    LOOP AT it_kna1 INTO wa_kna1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_kna1-kunnr
        IMPORTING
          output = lv_kunnr.

      MOVE-CORRESPONDING wa_kna1 TO wa_kna12.
      wa_kna12-kunnr = lv_kunnr.
      APPEND wa_kna12 TO it_kna12.

    ENDLOOP.


*    MOVE-CORRESPONDING wa_kna1 TO wa_kna12.
*    wa_kna12-kunnr = lv_kunnr.
*    APPEND wa_kna12 TO it_kna12.
*    CLEAR: lv_kunnr, wa_kna1, wa_kna12.

  ENDIF.

  LOOP AT it_kna12 INTO wa_kna12.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_kna12-kunnr
      IMPORTING
        output = lv_kunnr1.

    wa_kna12-kunnr = lv_kunnr1.
    MODIFY it_kna12 FROM wa_kna12.
  ENDLOOP.

  IF it_kna12 IS NOT INITIAL.
*    SELECT *
*      FROM cdhdr
*      INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
*      FOR ALL ENTRIES IN it_kna12
*      WHERE objectid = it_kna12-kunnr
*      AND tcode = 'XD02'.

    SELECT objectid udate tcode
      FROM cdhdr
      INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
      FOR ALL ENTRIES IN it_kna12
      WHERE objectid = it_kna12-kunnr
      AND tcode = 'XD02'.

  ENDIF.

  SORT it_cdhdr BY udate DESCENDING.

  IF it_kna1 IS NOT INITIAL.
    SELECT kunnr
           vkorg
           vtweg
           spart
           vkbur
           kdgrp
           waers
           kalks
           versg
           kvgr1
           lprio
           vsbed
           vwerk
           inco1
           inco2
           zterm
           ktgrd FROM knvv INTO TABLE it_knvv
           FOR ALL ENTRIES IN it_kna1
           WHERE kunnr = it_kna1-kunnr.

    SELECT kunnr
           vkorg
           vtweg
           spart FROM knvv INTO TABLE it_knvt
           FOR ALL ENTRIES IN it_kna1
           WHERE kunnr = it_kna1-kunnr.

    SELECT addrnumber
           name1
           name2
           name3
           sort1
           street
           house_num1
           post_code1
           city1
           city2
           country
           region
           langu
           tel_number
           fax_number
           str_suppl1
           str_suppl2
           str_suppl3
           location
       FROM adrc INTO TABLE it_adrc
           FOR ALL ENTRIES IN it_kna1
           WHERE addrnumber = it_kna1-adrnr.


    SELECT kunnr
           tatyp
           taxkd FROM knvi INTO TABLE it_knvi
           FOR ALL ENTRIES IN it_kna1
           WHERE kunnr = it_kna1-kunnr.

    SELECT kunnr
           vkorg
           vtweg
           spart
           parvw
           parza
           kunn2
           FROM knvp INTO TABLE it_knvp
           FOR ALL ENTRIES IN it_kna1
           WHERE kunnr = it_kna1-kunnr.

    SELECT kunnr
           j_1iexcd
           j_1iexrn
           j_1iexrg
           j_1iexdi
           j_1iexco
           j_1iexcicu
           j_1icstno
           j_1isern
           j_1ilstno
           j_1ipanno
           j_1ipanref  FROM j_1imocust INTO TABLE it_j_1imocust
           FOR ALL ENTRIES IN it_kna1
           WHERE kunnr = it_kna1-kunnr.



  ENDIF.

  IF it_knvv IS NOT INITIAL.
    SELECT spras
             inco1
             bezei FROM tinct INTO TABLE it_tinct
             FOR ALL ENTRIES IN it_knvv
             WHERE inco1 = it_knvv-inco1
             AND   spras = 'E'.

    SELECT spras
            zterm
            vtext FROM tvzbt INTO TABLE it_tvzbt
            FOR ALL ENTRIES IN it_knvv
            WHERE zterm = it_knvv-zterm
            AND   spras = 'E'.



  ENDIF.

  IF it_adrc IS NOT INITIAL.

    SELECT addrnumber
           smtp_addr  FROM adr6 INTO TABLE it_adr6
           FOR ALL ENTRIES IN it_adrc
           WHERE addrnumber = it_adrc-addrnumber.


    SELECT spras
             land1
             bland
             bezei FROM t005u INTO TABLE it_t005u
             FOR ALL ENTRIES IN it_adrc
             WHERE spras = it_adrc-langu
             AND   land1 = it_adrc-country
             AND   bland = it_adrc-region.

    SELECT spras
           land1
           landx FROM t005t INTO TABLE it_t005t
           FOR ALL ENTRIES IN it_adrc
           WHERE spras = it_adrc-langu
           AND   land1 = it_adrc-country.


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
*  BREAK PRIMUS.
  LOOP AT it_kna1 INTO wa_kna1.
    wa_final-kunnr   =   wa_kna1-kunnr.
    wa_final-ktokd   =   wa_kna1-ktokd.
    wa_final-anred   =   wa_kna1-anred.
*  WA_FINAL-LAND1   =   WA_KNA1-LAND1.
    wa_final-regio   =   wa_kna1-regio.
    wa_final-telf2   =   wa_kna1-telf2.
    wa_final-stcd3   =   wa_kna1-stcd3.
    wa_final-erdat   =   wa_kna1-erdat.
    wa_final-adrnr   =   wa_final-adrnr.

*    LOOP AT it_kna12 INTO wa_kna12.
    READ TABLE it_kna12 INTO wa_kna12 WITH KEY kunnr = wa_kna1-kunnr.

      READ TABLE it_cdhdr INTO wa_cdhdr WITH KEY objectid = wa_kna12-kunnr tcode = 'XD02'.
      IF sy-subrc = 0.
        wa_final-objectid = wa_cdhdr-objectid.
        wa_final-udate = wa_cdhdr-udate.
        wa_final-tcode = wa_cdhdr-tcode.
      ENDIF.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-udate
        IMPORTING
          output = wa_final-udate.

      CONCATENATE wa_final-udate+0(2) wa_final-udate+2(3) wa_final-udate+5(4)
                      INTO wa_final-udate SEPARATED BY '-'.

      IF wa_final-udate = '--'.
        REPLACE ALL OCCURRENCES OF '--' IN wa_final-udate WITH ' '.
      ENDIF.

*    ENDLOOP.

    READ TABLE it_knb1 INTO wa_knb1 WITH KEY kunnr = wa_kna1-kunnr.
    IF sy-subrc = 0.
      wa_final-bukrs   = wa_knb1-bukrs.
      wa_final-akont   = wa_knb1-akont.
      wa_final-zuawa   = wa_knb1-zuawa.
      wa_final-fi_zterm   = wa_knb1-zterm.
      wa_final-xverr   = wa_knb1-xverr.
      wa_final-zwels   = wa_knb1-zwels.
      wa_final-knrzb   = wa_knb1-knrzb.
      wa_final-hbkid   = wa_knb1-hbkid.
      wa_final-altkn   = wa_knb1-altkn.

    ENDIF.

    READ TABLE it_tzunt INTO wa_tzunt WITH KEY zuawa = wa_knb1-zuawa.
    IF sy-subrc = 0.
      wa_final-ttext = wa_tzunt-ttext.

    ENDIF.

    READ TABLE it_knvv INTO wa_knvv WITH KEY kunnr = wa_kna1-kunnr.
    IF sy-subrc = 0.
      wa_final-vkbur   = wa_knvv-vkbur.
      wa_final-vkorg   = wa_knvv-vkorg.
      wa_final-vtweg   = wa_knvv-vtweg.
      wa_final-spart   = wa_knvv-spart.
      wa_final-kdgrp   = wa_knvv-kdgrp.
      wa_final-waers   = wa_knvv-waers.
      wa_final-kalks   = wa_knvv-kalks.
      wa_final-versg   = wa_knvv-versg.
      wa_final-kvgr1   = wa_knvv-kvgr1.
      wa_final-lprio   = wa_knvv-lprio.
      wa_final-vsbed   = wa_knvv-vsbed.
      wa_final-vwerk   = wa_knvv-vwerk.
      wa_final-inco1   = wa_knvv-inco1.
      wa_final-inco2   = wa_knvv-inco2.
      wa_final-zterm   = wa_knvv-zterm.
      wa_final-ktgrd   = wa_knvv-ktgrd.

    ENDIF.

    READ TABLE it_tinct INTO wa_tinct WITH KEY inco1 = wa_knvv-inco1
                                               spras = 'E'.
    IF sy-subrc = 0.
      wa_final-inco_text  =   wa_tinct-bezei.

    ENDIF.


    READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_kna1-adrnr.
    IF sy-subrc = 0.
      wa_final-name1       = wa_adrc-name1     .
      wa_final-name2       = wa_adrc-name2     .
      wa_final-name3       = wa_adrc-name3     .
      wa_final-sort1       = wa_adrc-sort1     .
      wa_final-street      = wa_adrc-street    .
      wa_final-house_num1  = wa_adrc-house_num1.
      wa_final-post_code1  = wa_adrc-post_code1.
      wa_final-city1       = wa_adrc-city1     .
      wa_final-city2       = wa_adrc-city2     .
      wa_final-country     = wa_adrc-country   .
      wa_final-region      = wa_adrc-region    .
      wa_final-langu       = wa_adrc-langu     .
      wa_final-tel_number  = wa_adrc-tel_number.
      wa_final-fax_number  = wa_adrc-fax_number.
      wa_final-str_suppl1  = wa_adrc-str_suppl1.
      wa_final-str_suppl2  = wa_adrc-str_suppl2.
      wa_final-str_suppl3  = wa_adrc-str_suppl3.
      wa_final-location    = wa_adrc-location.
    ENDIF.

    read table  it_knvi INTO wa_knvi With key kunnr = wa_kna1-kunnr.

          wa_final-taxkd = wa_knvi-taxkd.




*READ TABLE it_knvp INTO wa_knvp WITH KEY KUNNR = wa_KNA1-KUNNR.              " add subodh 19 feb 2018
*if wa_knvp-parvw = 'AG'.
*wa_final-kunn2_ag = wa_knvp-kunn2.
*ELSEIF wa_knvp-parvw = 'RE'.
*wa_final-kunn2_re = wa_knvp-kunn2.
*ELSEIF wa_knvp-parvw = 'RG'.
*wa_final-kunn2_rg = wa_knvp-kunn2.
*ELSEIF wa_knvp-parvw = 'WE'.
*wa_final-kunn2_we = wa_knvp-kunn2.
*ENDIF.

    LOOP AT it_knvp INTO wa_knvp WHERE kunnr = wa_kna1-kunnr.

      CASE wa_knvp-parvw.
        WHEN 'AG'.
          wa_final-kunn2_ag = wa_knvp-kunn2.
        WHEN 'RE'.
          wa_final-kunn2_re = wa_knvp-kunn2.
        WHEN 'RG'.
          wa_final-kunn2_rg = wa_knvp-kunn2.
        WHEN 'WE'.
          wa_final-kunn2_we = wa_knvp-kunn2.
      ENDCASE.
    ENDLOOP.



    READ TABLE it_t005u INTO wa_t005u WITH KEY spras = wa_adrc-langu
                                               land1 = wa_adrc-country
                                               bland = wa_adrc-region.
    IF sy-subrc = 0.
      wa_final-bezei   =  wa_t005u-bezei.

    ENDIF.

    READ TABLE it_t005t INTO wa_t005t WITH KEY spras = wa_adrc-langu
                                               land1 = wa_adrc-country.
    IF sy-subrc = 0.
      wa_final-landx  =    wa_t005t-landx.

    ENDIF.

    READ TABLE it_fi_tvzbt INTO wa_fi_tvzbt WITH KEY zterm = wa_knb1-zterm
                                                     spras = 'E'.
    IF sy-subrc = 0.
      wa_final-fi_vtext   = wa_fi_tvzbt-vtext.

    ENDIF.


    READ TABLE it_tvzbt INTO wa_tvzbt WITH KEY zterm = wa_knvv-zterm
                                                     spras = 'E'.
    IF sy-subrc = 0.
      wa_final-vtext   = wa_tvzbt-vtext.

    ENDIF.




    READ TABLE it_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_adrc-addrnumber.
    IF sy-subrc = 0.
      wa_final-smtp_addr  =  wa_adr6-smtp_addr.

    ENDIF.

    READ TABLE it_j_1imocust INTO wa_j_1imocust WITH KEY kunnr = wa_kna1-kunnr.
    IF sy-subrc = 0.
**      wa_final-j_1iexcd    =  wa_j_1imocust-j_1iexcd   .
*      wa_final-j_1iexrn    =  wa_j_1imocust-j_1iexrn   .
*      wa_final-j_1iexrg    =  wa_j_1imocust-j_1iexrg   .
*      wa_final-j_1iexdi    =  wa_j_1imocust-j_1iexdi   .
*      wa_final-j_1iexco    =  wa_j_1imocust-j_1iexco   .
*      wa_final-j_1iexcicu  =  wa_j_1imocust-j_1iexcicu .
*      wa_final-j_1icstno   =  wa_j_1imocust-j_1icstno  .
*      wa_final-j_1isern    =  wa_j_1imocust-j_1isern   .
      wa_final-j_1ilstno   =  wa_j_1imocust-j_1ilstno  .
*      wa_final-j_1ipanno   =  wa_j_1imocust-j_1ipanno  .
*      wa_final-j_1ipanref  =  wa_j_1imocust-j_1ipanref .

    ENDIF.
***********************************************8SORT DATA FOR DOWANLOAD FILE***********************************
    ls_final-ktokd                 =          wa_final-ktokd     .
    ls_final-kunnr                 =          wa_final-kunnr     .
    ls_final-bukrs                 =          wa_final-bukrs     .
    ls_final-vkorg                 =          wa_final-vkorg     .
    ls_final-vtweg                 =          wa_final-vtweg     .
    ls_final-spart                 =          wa_final-spart     .
    ls_final-anred                 =          wa_final-anred     .
    ls_final-name1                 =          wa_final-name1     .
    ls_final-name2                 =          wa_final-name2     .
    ls_final-name3                 =          wa_final-name3     .
    ls_final-sort1                 =          wa_final-sort1     .
    ls_final-street                =          wa_final-street    .
    ls_final-str_suppl1            =          wa_final-str_suppl1.
    ls_final-str_suppl2            =          wa_final-str_suppl2.
    ls_final-str_suppl3            =          wa_final-str_suppl3.
    ls_final-house_num1            =          wa_final-house_num1.
    ls_final-post_code1            =          wa_final-post_code1.
    ls_final-city2                 =          wa_final-city2     .
    ls_final-city1                 =          wa_final-city1     .
    ls_final-country               =          wa_final-country   .
    ls_final-landx                 =          wa_final-landx     .
    ls_final-region                =          wa_final-region    .
    ls_final-bezei                 =          wa_final-bezei     .
    ls_final-langu                 =          wa_final-langu     .
    ls_final-tel_number            =          wa_final-tel_number.
    ls_final-telf2                 =          wa_final-telf2     .
    ls_final-fax_number            =          wa_final-fax_number.
    ls_final-smtp_addr             =          wa_final-smtp_addr .
    ls_final-akont                 =          wa_final-akont     .
    ls_final-zuawa                 =          wa_final-zuawa     .
    ls_final-ttext                 =          wa_final-ttext     .
    ls_final-fi_zterm              =          wa_final-fi_zterm  .
    ls_final-fi_vtext              =          wa_final-fi_vtext  .
    ls_final-xverr                 =          wa_final-xverr     .
    ls_final-zwels                 =          wa_final-zwels     .
    ls_final-knrzb                 =          wa_final-knrzb     .
    ls_final-hbkid                 =          wa_final-hbkid     .
    ls_final-vkbur                 =          wa_final-vkbur     .
    ls_final-kdgrp                 =          wa_final-kdgrp     .
    ls_final-waers                 =          wa_final-waers     .
    ls_final-kalks                 =          wa_final-kalks     .
    ls_final-versg                 =          wa_final-versg     .
    ls_final-kvgr1                 =          wa_final-kvgr1     .
    ls_final-lprio                 =          wa_final-lprio     .
    ls_final-vsbed                 =          wa_final-vsbed     .
    ls_final-vwerk                 =          wa_final-vwerk     .
    ls_final-inco1                 =          wa_final-inco1     .
    ls_final-inco_text             =          wa_final-inco_text .
    ls_final-inco2                 =          wa_final-inco2     .
    ls_final-zterm                 =          wa_final-zterm     .
    ls_final-vtext                 =          wa_final-vtext     .
    ls_final-ktgrd                 =          wa_final-ktgrd     .
     ls_final-taxkd                 =          wa_final-taxkd     .
*    ls_final-j_1iexcd               =          wa_final-j_1iexcd        .
*    ls_final-j_1iexrn               =          wa_final-j_1iexrn        .
*    ls_final-j_1iexrg               =          wa_final-j_1iexrg        .
*    ls_final-j_1iexdi               =          wa_final-j_1iexdi        .
*    ls_final-j_1iexco               =          wa_final-j_1iexco        .
*    ls_final-j_1iexcicu             =          wa_final-j_1iexcicu      .
*    ls_final-j_1icstno              =          wa_final-j_1icstno       .
*    ls_final-j_1ilstno              =          wa_final-j_1ilstno       .
*    ls_final-j_1isern               =          wa_final-j_1isern        .
*    ls_final-j_1ipanno              =          wa_final-j_1ipanno       .
*    ls_final-j_1ipanref             =          wa_final-j_1ipanref      .
    ls_final-kunn2_ag               =          wa_final-kunn2_ag      .                  " Add subodh 19 feb 2018
    ls_final-kunn2_re               =          wa_final-kunn2_re      .                  "" Add subodh 19 feb 2018
    ls_final-kunn2_rg               =            wa_final-kunn2_rg      .                   " Add subodh 19 feb 2018
    ls_final-kunn2_we               =            wa_final-kunn2_we      .                   " Add subodh 19 feb 2018
    ls_final-erdat                  =           wa_final-erdat.
    ls_final-stcd3                  =           wa_final-stcd3.
    ls_final-altkn                  =            wa_final-altkn.
    ls_final-location               =            wa_final-location.
    ls_final-udate                  =            wa_final-udate.
*************************************************************************************************************








***************************************************************************************************************
    ls_final-ref = sy-datum.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-ref
      IMPORTING
        output = ls_final-ref.

    CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                    INTO ls_final-ref SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-erdat
      IMPORTING
        output = ls_final-erdat.

    CONCATENATE ls_final-erdat+0(2) ls_final-erdat+2(3) ls_final-erdat+5(4)
                    INTO ls_final-erdat SEPARATED BY '-'.

     CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO ls_final-TIME SEPARATED BY ':'.

********************************************************END ********************************

    APPEND ls_final TO lt_final.
    APPEND wa_final TO it_final.
    CLEAR wa_final.
    CLEAR : wa_final-fi_zterm,wa_final-fi_vtext,wa_final-inco_text,wa_final-taxkd.
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
  PERFORM fcat USING : '1'  'KTOKD '                 'IT_FINAL'  'A/C Group'                        '18' ,
                       '2'  'KUNNR '                 'IT_FINAL'  'Customer Code'                    '18',
                       '3'  'BUKRS '                 'IT_FINAL'  'Company Code'                     '18' ,
                       '4'  'VKORG '                 'IT_FINAL'  'Sales Org.'                       '18' ,
                       '5'  'VTWEG '                 'IT_FINAL'  'Dist. Chan.'                      '10' ,
                       '6'  'SPART '                 'IT_FINAL'  'Division'                         '30' ,
                       '7'  'ANRED '                 'IT_FINAL'  'Title'                            '30' ,
                       '8'  'NAME1 '                 'IT_FINAL'  'Name 1'                           '10' ,
                       '9'  'NAME2 '                 'IT_FINAL'  'Name 2'                           '10' ,
                      '10'  'NAME3 '                 'IT_FINAL'  'Name 3'                           '10' ,
                      '11'  'SORT1 '                 'IT_FINAL'  'Search Term'                      '10' ,
                      '12'  'STREET    '             'IT_FINAL'  'Street'                           '30' ,
                      '13'  'STR_SUPPL1 '            'IT_FINAL'  'Street 2'                         '30' ,
                      '14'  'STR_SUPPL2'             'IT_FINAL'  'Street 3'                         '30' ,
                      '15'  'STR_SUPPL3'             'IT_FINAL'  'Street 4'                         '30' ,
                      '16'  'HOUSE_NUM1'             'IT_FINAL'  'House NO'                         '10' ,
                      '17'  'POST_CODE1'             'IT_FINAL'  'City postal code'                 '18' ,
                      '18'  'CITY2     '             'IT_FINAL'  'District'                         '18' ,
                      '19'  'CITY1   '               'IT_FINAL'  'City'                             '18' ,
                      '20'  'COUNTRY '               'IT_FINAL'  'Country Key'                      '18' ,
                      '21'  'LANDX '                 'IT_FINAL'  'Country'                          '18' ,
                      '22'  'REGION '                'IT_FINAL'  'Region Code'                      '18' ,
                      '23'  'BEZEI'                  'IT_FINAL'  'Region'                           '18' ,
                      '24'  'LANGU     '             'IT_FINAL'  'Language'                         '10' ,
                      '25'  'TEL_NUMBER'             'IT_FINAL'  'Telephone NO'                     '10' ,
                      '26'  'TELF2'                  'IT_FINAL'  'Mobile NO'                        '10' ,
                      '27'  'FAX_NUMBER'             'IT_FINAL'  'Fax no'                           '10' ,
                      '28'  'SMTP_ADDR '             'IT_FINAL'  'E-Mail'                           '18' ,
                      '29'  'AKONT '                 'IT_FINAL'  'Recon A/C'                        '18' ,
                      '30'  'ZUAWA '                 'IT_FINAL'  'Sort key '                        '18' ,
                      '31'  'TTEXT '                 'IT_FINAL'  'Des.Sort Key'                     '18' ,
                      '32'  'FI_ZTERM '              'IT_FINAL'  'Term Of Pay'                      '18' ,
                      '33'  'FI_VTEXT '              'IT_FINAL'  'Term Of Pay'                      '18' ,
                      '34'  'XVERR '                 'IT_FINAL'  'Clearing with vendor '            '18' ,
                      '35'  'ZWELS '                 'IT_FINAL'  'Pay. Method'                      '18' ,
                      '36'  'KNRZB '                 'IT_FINAL'  'Alter. Payer'                     '18' ,
                      '37'  'HBKID '                 'IT_FINAL'  'House Bank'                       '18' ,
                      '38'  'VKBUR '                 'IT_FINAL'  'Sales Office'                     '18' ,
                      '39'  'KDGRP '                 'IT_FINAL'  'Customer GRP'                     '18' ,
                      '40'  'WAERS '                 'IT_FINAL'  'Currency'                         '18' ,
                      '41'  'KALKS '                 'IT_FINAL'  'Cust pricing'                     '18' ,
                      '42'  'VERSG '                 'IT_FINAL'  'Cust.Stats.Grp'                   '18' ,
                      '43'  'KVGR1 '                 'IT_FINAL'  'Customer Grp1'                    '18' ,
                      '44'  'LPRIO '                 'IT_FINAL'  'Delivery Priority'                '18' ,
                      '45'  'VSBED '                 'IT_FINAL'  'Shipping Cond'                    '18' ,
                      '46'  'VWERK '                 'IT_FINAL'  'Delivering Plant'                 '18' ,
                      '47'  'INCO1 '                 'IT_FINAL'  'INCO1'                            '18' ,
                      '48'  'INCO_TEXT'              'IT_FINAL'  'Desc.INCO1'                       '18' ,
                      '49'  'INCO2 '                 'IT_FINAL'  'INCO2'                            '18' ,
                      '50'  'ZTERM '                 'IT_FINAL'  'Terms of Payment'                 '18' ,
                      '51'  'VTEXT'                 'IT_FINAL'   'Terms of Payment'                 '18' ,
                      '52'  'KTGRD '                 'IT_FINAL'  'Acct assgmt grp'                  '18' ,
                      '53'  'TAXKD '                 'IT_FINAL'  'TAX MWAS'                         '18' ,
*                      '54'  'J_1IEXCD  '             'IT_FINAL'  'ECC No.'                          '18' ,
*                      '55'  'J_1IEXRN  '             'IT_FINAL'  'Excise Reg. No.'                  '18' ,
*                      '56'  'J_1IEXRG  '             'IT_FINAL'  'Excise Range'                     '18' ,
*                      '57'  'J_1IEXDI  '             'IT_FINAL'  'Excise Division'                  '18' ,
*                      '58'  'J_1IEXCO  '             'IT_FINAL'  'Commissionerate'                  '18' ,
*                      '59'  'J_1IEXCICU'             'IT_FINAL'  'Exc.Ind.Cust.'                    '18' ,
*                      '60'  'J_1ICSTNO '             'IT_FINAL'  'CST no.'                          '18' ,
*                      '61'  'J_1ILSTNO '             'IT_FINAL'  'LST no.'                          '18' ,
*                      '62'  'J_1ISERN  '             'IT_FINAL'  'Ser.Reg.No'                       '18' ,
*                      '63'  'J_1IPANNO '             'IT_FINAL'  'PAN No.'                          '18' ,
*                      '64'  'J_1IPANREF'             'IT_FINAL'  'PAN Ref'                          '18' ,
                      '65'  'STCD3'                  'IT_FINAL'  'Vat.Reg.Code'                         '18' ,
                      '66'  'KUNN2_AG'               'IT_FINAL'  'Shift To Party'                         '18' ,
                      '67'  'KUNN2_RE'               'IT_FINAL'  'Sold To Part'                         '18' ,
                      '68'  'KUNN2_RG'               'IT_FINAL'  'Payer'                         '18' ,
                      '69'  'KUNN2_WE'               'IT_FINAL'  'Build To Party'                         '18' ,
                      '70'  'ERDAT'                  'IT_FINAL'  'Creation Date'                         '18' ,
                      '71'  'ALTKN'                 'IT_FINAL' 'Old Customer Code'                    '18',
*                     '24'  'SMTP_ADDR '     'IT_FINAL'  'E-Mail'                     '18' ,
*                     '18'  'REGION  '       'IT_FINAL'  'Region'                     '18' ,
*                     '19'  'BEZEI  '        'IT_FINAL'  'Reg.Desc'                   '18' ,
*                     '20'  'PO_BOX  '       'IT_FINAL'  'PO Box'                     '10' .
                     '72'    'LOCATION'             'IT_FINAL'   'STREET 5'      '18',
                     '73'    'UDATE'                'IT_FINAL'   'Last Changed Date'         '18'.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1203   text
*      -->P_1204   text
*      -->P_1205   text
*      -->P_1206   text
*      -->P_1207   text
*----------------------------------------------------------------------*
FORM fcat  USING     VALUE(p1)
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
*BREAK primus.
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
  lv_file = 'ZSU_CUST_MASTER.TXT'.

*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
*BREAK primus.
  WRITE: / 'ZSU_CUSTOMER MASTER started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1263 TYPE string.
DATA lv_crlf_1263 TYPE string.
lv_crlf_1263 = cl_abap_char_utilities=>cr_lf.
lv_string_1263 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1263 lv_crlf_1263 wa_csv INTO lv_string_1263.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1263 TO lv_fullfile.
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
  CONCATENATE 'A/C Group'
              'Customer Code'
              'Company Code'
              'Sales Org.'
              'Dist. Chan.'
              'Division'
              'Title'
              'Name 1'
              'Name 2'
              'Name 3'
              'Search Term'
              'Street'
              'Street 2'
              'Street 3'
              'Street 4'
              'House NO'
              'City postal code'
              'District'
              'City'
              'Country Key'
              'Country'
              'Region Code'
              'Region'
              'Language'
              'Telephone NO'
              'Mobile NO'
              'Fax no'
              'E-Mail'
              'Recon A/C'
              'Sort key '
              'Des.Sort Key'
              'Term Of Pay'
              'Term Of Pay'
              'Clearing with vendor '
              'Pay. Method'
              'Alter. Payer'
              'House Bank'
              'Sales Office'
              'Customer GRP'
              'Currency'
              'Cust pricing'
              'Cust.Stats.Grp'
              'Customer Grp1'
              'Delivery Priority'
              'Shipping Cond'
              'Delivering Plant'
              'INCO1'
              'Desc.INCO1'
              'INCO2'
              'Terms of Payment'
              'Terms of Payment'
              'Acct assgmt grp'
              'TAX MWAS'
*              'ECC No.'
*              'Excise Reg. No.'
*              'Excise Range'
*              'Excise Division'
*              'Commissionerate'
*              'Exc.Ind.Cust.'
*              'CST no.'
*              'LST no.'
*              'Ser.Reg.No'
*              'PAN No.'
*              'PAN Ref'
              'VAT.REG.Code'
              'Shift To Party'    " add subodh 19 feb 2018
              'Sold To Part'      " add subodh 19 feb 2018
              'Payer'             " add subodh 19 feb 2018
              'Build To Party'    " add subodh 19 feb 2018
              'Refresh Date'
              'Refresh Time'
              'Creation Date'
              'Old Customer Code'
              'Street 5'
              'Last Changed Date'
              INTO pd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
