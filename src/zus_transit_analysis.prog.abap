*&---------------------------------------------------------------------*
*& Report ZUS_TRANSIT_ANALYSIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_transit_analysis.

TABLES : mseg , bkpf, bseg.
***********************STRUCTURES**************************************
TYPES : BEGIN OF ty_mseg,
          mblnr(16),"mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          line_id    TYPE mseg-line_id,
          bwart      TYPE mseg-bwart,
          xauto      TYPE mseg-xauto,
          matnr      TYPE mseg-matnr,
          werks      TYPE mseg-werks,
          lgort      TYPE mseg-lgort,
          kdauf      TYPE mseg-kdauf,
          kdpos      TYPE mseg-kdpos,
          dmbtr      TYPE mseg-dmbtr,
          menge      TYPE mseg-menge,
          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,
          smbln      TYPE mseg-smbln,
          smblp      TYPE mseg-smblp,
          bukrs      TYPE mseg-bukrs,
          belnr      TYPE mseg-belnr,
          budat_mkpf TYPE mseg-budat_mkpf,
          xblnr_mkpf TYPE mseg-xblnr_mkpf,
          vbeln_im   TYPE mseg-vbeln_im,
          vbelp_im   TYPE mseg-vbelp_im,
          lfbnr      TYPE mseg-lfbnr,
          cpudt_mkpf TYPE mseg-cpudt_mkpf,
          cputm_mkpf TYPE mseg-cputm_mkpf,
          flag1      TYPE char1,
        END OF ty_mseg.

TYPES : BEGIN OF ty_bkpf,
          belnr TYPE bkpf-belnr,
          blart TYPE bkpf-blart,
          xblnr TYPE bkpf-xblnr,
          stblg TYPE bkpf-stblg,
          bktxt TYPE bkpf-bktxt,
        END OF ty_bkpf.

TYPES : BEGIN OF ty_bseg,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          buzei TYPE bseg-buzei,
          shkzg TYPE bseg-shkzg,
          dmbtr TYPE bseg-dmbtr,
        END OF ty_bseg.

TYPES : BEGIN OF ty_data,
          mblnr      TYPE mseg-mblnr,
          smbln      TYPE mseg-smbln,
          bwart      TYPE mseg-bwart,
          budat_mkpf TYPE mseg-budat_mkpf,
          cpudt_mkpf TYPE mseg-cpudt_mkpf,
          cputm_mkpf TYPE mseg-cputm_mkpf,
        END OF ty_data.

TYPES : BEGIN OF ty_vbrp,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          fkimg TYPE vbrp-fkimg,
          vgbel TYPE vbrp-vgbel,
*            matnr     type vbrp-matnr,          "added by aakashk 24.09.2024
        END OF ty_vbrp.

TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkdat TYPE vbrk-fkdat,
        END OF ty_vbrk.

******************final alv output structure*************************************
TYPES : BEGIN OF ty_final,
*          ebeln       TYPE mseg-ebeln,
*          ebelp       TYPE mseg-ebelp,
*          matnr       TYPE mseg-matnr,
          vbeln_im    TYPE mseg-vbeln_im,
          103_date    TYPE mseg-cpudt_mkpf,
          103_POST_date    TYPE mseg-BudAt_mkpf,
          103_migo_no TYPE mseg-mblnr,
          103_migo_tm TYPE string,
          inv_no      TYPE vbrp-vbeln, "bkpf-bktxt,
          fkdat       TYPE vbrk-fkdat, "
          103_amt     TYPE string, "bseg-dmbtr,
          103_jv_no   TYPE bkpf-belnr,
          104_date    TYPE mseg-cpudt_mkpf,"budat_mkpf,
          104_POST_date    TYPE mseg-BudAt_mkpf,
          104_migo_no TYPE mseg-mblnr,
          104_migo_tm TYPE string,
          105_date    TYPE mseg-cpudt_mkpf,"budat_mkpf,
          105_POST_date    TYPE mseg-BudAt_mkpf,
          105_migo_no TYPE mseg-mblnr,
          105_migo_tm TYPE string,
          105_amt     TYPE string, "bseg-dmbtr,
          105_jv_no   TYPE bkpf-belnr,
          106_date    TYPE mseg-cpudt_mkpf,"budat_mkpf,                         "added by aakaskk 26.09.2024
          106_POST_date    TYPE mseg-BudAt_mkpf,
          106_migo_no TYPE mseg-mblnr,
          106_migo_tm TYPE string,
          flag1       TYPE char1,
        END OF ty_final.
********************refreshable file structure*********************************
TYPES : BEGIN OF ty_down,
*          ebeln       TYPE mseg-ebeln,
*          ebelp       TYPE mseg-ebelp,
*          matnr       TYPE mseg-matnr,
          vbeln_im    TYPE mseg-vbeln_im,
          inv_no      TYPE vbrp-vbeln, "bkpf-bktxt,
          fkdat       TYPE char11,
          103_date    TYPE char11,
          103_post_date    TYPE char11,
          103_migo_no TYPE mseg-mblnr,
          103_migo_tm TYPE string,
          103_jv_no   TYPE bkpf-belnr,
          103_amt     TYPE string,
          104_date    TYPE string, "mseg-budat_mkpf,                         "added by aakaskk 26.09.2024
          104_post_date    TYPE char11,
          104_migo_no TYPE mseg-mblnr,                                       "added by aakaskk 26.09.2024
          104_migo_tm TYPE string,                                           "added by aakaskk 26.09.2024
          105_date    TYPE char11,
          105_post_date    TYPE char11,
          105_migo_no TYPE mseg-mblnr,
          105_migo_tm TYPE string,
          105_jv_no   TYPE bkpf-belnr,
          105_amt     TYPE string,
          106_date    TYPE string, "mseg-budat_mkpf,                         "added by aakaskk 26.09.2024
          106_post_date    TYPE char11,
          106_migo_no TYPE mseg-mblnr,                                       "added by aakaskk 26.09.2024
          106_migo_tm TYPE string,                                       "added by aakaskk 26.09.2024
          ref         TYPE char11,
          ref_time    TYPE char15,
        END OF ty_down.
*****************************************************************************
*********************INTERNAL TABLE AND WORK AREA******************************
DATA: it_mseg     TYPE TABLE OF ty_mseg,
      wa_mseg     TYPE          ty_mseg,

      it_data     TYPE TABLE OF ty_data,
      wa_data     TYPE          ty_data,

      it_mseg_104 TYPE TABLE OF ty_mseg,
      wa_mseg_104 TYPE          ty_mseg,

      it_mseg1    TYPE TABLE OF ty_mseg,
      wa_mseg1    TYPE          ty_mseg,

      it_mseg_106 TYPE TABLE OF ty_mseg,
      wa_mseg_106 TYPE          ty_mseg,

      it_vbrp     TYPE TABLE OF ty_vbrp,
      wa_vbrp     TYPE          ty_vbrp,

      it_vbrk     TYPE TABLE OF ty_vbrk,
      wa_vbrk     TYPE          ty_vbrk,

      it_bkpf     TYPE TABLE OF ty_bkpf,
      wa_bkpf     TYPE          ty_bkpf,

      it_bkpf_n   TYPE TABLE OF ty_bkpf,
      wa_bkpf_n   TYPE          ty_bkpf,

      it_bkpf1    TYPE TABLE OF ty_bkpf,
      wa_bkpf1    TYPE          ty_bkpf,


      it_bseg     TYPE TABLE OF ty_bseg,
      wa_bseg     TYPE          ty_bseg,

      it_bseg1    TYPE TABLE OF ty_bseg,
      wa_bseg1    TYPE          ty_bseg,

      it_final    TYPE TABLE OF ty_final,
      wa_final    TYPE          ty_final,

      it_down     TYPE TABLE OF ty_down,
      wa_down     TYPE          ty_down.

DATA : gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gs_fieldcat TYPE slis_fieldcat_alv.
********************Selection Screen**************************************************
SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_plant FOR mseg-werks MODIF ID bu, "OBLIGATORY DEFAULT 'US01',
*                 s_date FOR mseg-budat_mkpf OBLIGATORY .
                 s_date FOR mseg-cpudt_mkpf OBLIGATORY .
SELECTION-SCREEN:END OF BLOCK b1.
***************file download for selection screen***********************************
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-004 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT   '/Delval/USA'.  "'/DELVAL/USA'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
SELECTION-SCREEN  COMMENT /1(60) TEXT-003.
SELECTION-SCREEN: END OF BLOCK b3.
****************************************************************************************
INITIALIZATION.

  s_plant-sign = 'I'.
  s_plant-option = 'BT'.
  s_plant-low = 'US01'.
  s_plant-high = 'US03'.

  APPEND s_plant.

  CLEAR s_plant.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM process_data.
  PERFORM fill_fieldcat.
  PERFORM display_data.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT mblnr
         mjahr
         zeile
         line_id
         bwart
         xauto
         matnr
         werks
         lgort
         kdauf
         kdpos
         dmbtr
         menge
         ebeln
         ebelp
         smbln
         smblp
         bukrs
         belnr
         budat_mkpf
         xblnr_mkpf
         vbeln_im
         vbelp_im
         lfbnr
         cpudt_mkpf
         cputm_mkpf
         FROM mseg
         INTO TABLE it_mseg
         WHERE werks IN s_plant
*         AND budat_mkpf IN s_date
         AND cpudt_mkpf IN s_date
         AND bwart = '103'.
*         AND ZEILE = '1'.
    sort it_mseg by mblnr.
delete ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr.
*
*  SELECT mblnr
*     mjahr
*     zeile
*     line_id
*     bwart
*     xauto
*     matnr
*     werks
*     lgort
*     kdauf
*     kdpos
*     dmbtr
*     menge
*     ebeln
*     ebelp
*     smbln
*     smblp
*     bukrs
*     belnr
*     budat_mkpf
*     xblnr_mkpf
*     vbeln_im
*     vbelp_im
*     lfbnr
*     FROM mseg
*     INTO TABLE it_mseg_104
*     WHERE werks IN s_plant
*     AND budat_mkpf IN s_date
*     AND bwart = '104'.

  IF it_mseg IS NOT INITIAL.
    SELECT mblnr
     mjahr
     zeile
     line_id
     bwart
     xauto
     matnr
     werks
     lgort
     kdauf
     kdpos
     dmbtr
     menge
     ebeln
     ebelp
     smbln
     smblp
     bukrs
     belnr
     budat_mkpf
     xblnr_mkpf
     vbeln_im
     vbelp_im
     lfbnr
     cpudt_mkpf
     cputm_mkpf
     FROM mseg
     INTO TABLE it_mseg1
     FOR ALL ENTRIES IN it_mseg
     WHERE lfbnr = it_mseg-mblnr+0(10)
      AND werks IN s_plant
     AND bwart = '105'.
*      AND ZEILE = '1'.

    sort it_mseg1 by mblnr.
delete ADJACENT DUPLICATES FROM it_mseg1 COMPARING mblnr.


    SELECT mblnr
       mjahr
       zeile
       line_id
       bwart
       xauto
       matnr
       werks
       lgort
       kdauf
       kdpos
       dmbtr
       menge
       ebeln
       ebelp
       smbln
       smblp
       bukrs
       belnr
       budat_mkpf
       xblnr_mkpf
       vbeln_im
       vbelp_im
       lfbnr
      cpudt_mkpf
       cputm_mkpf
       FROM mseg
       INTO TABLE it_mseg_104
       FOR ALL ENTRIES IN it_mseg "budat_mkpf IN s_date
        WHERE werks IN s_plant
      AND lfbnr = it_mseg-mblnr+0(10)
       AND bwart = '104'.

    SELECT mblnr
           mjahr
           zeile
           line_id
           bwart
           xauto
           matnr
           werks
           lgort
           kdauf
           kdpos
           dmbtr
           menge
           ebeln
           ebelp
           smbln
           smblp
           bukrs
           belnr
           budat_mkpf
           xblnr_mkpf
           vbeln_im
           vbelp_im
           lfbnr
           cpudt_mkpf
           cputm_mkpf
           FROM mseg
           INTO TABLE it_mseg_106
           FOR ALL ENTRIES IN it_mseg1
           WHERE lfbnr = it_mseg1-mblnr+0(10)
           AND werks IN s_plant
           AND bwart = '106'.

    SELECT mblnr
           smbln
           bwart
           budat_mkpf
           cpudt_mkpf
           cputm_mkpf
           FROM mseg
      INTO TABLE it_data
      FOR ALL ENTRIES IN it_mseg1
      WHERE vbeln_im = it_mseg1-vbeln_im
      AND bwart EQ '106'.

    LOOP AT it_mseg INTO wa_mseg.
      DATA : lv_vbeln(10) TYPE c.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_mseg-xblnr_mkpf
        IMPORTING
          output = lv_vbeln.
      wa_mseg-xblnr_mkpf = lv_vbeln.
      MODIFY it_mseg FROM wa_mseg.
    ENDLOOP.

    SELECT vbeln
           posnr
           fkimg
           vgbel
*        matnr                          "added by aakashk 24.09.2024
           FROM vbrp
           INTO TABLE it_vbrp
           FOR ALL ENTRIES IN it_mseg
*         where matnr = it_mseg-matnr.
            WHERE vgbel = it_mseg-xblnr_mkpf+0(10).
    SELECT vbeln
           fkdat
       FROM vbrk
       INTO TABLE it_vbrk
       FOR ALL ENTRIES IN it_vbrp
       WHERE vbeln = it_vbrp-vbeln.

    SELECT belnr
           blart
           xblnr
           stblg
           bktxt
          FROM bkpf
          INTO TABLE it_bkpf
          FOR ALL ENTRIES IN it_mseg
          WHERE xblnr = it_mseg-mblnr
       AND blart = 'TR'.

*         SELECT belnr
*           blart
*           xblnr
*           stblg
*           bktxt
*          FROM bkpf
*          INTO TABLE it_bkpf_N
*          FOR ALL ENTRIES IN it_mseg
*          WHERE xblnr = it_mseg-mblnr
*          AND BLART = 'RT'.

  ENDIF.
  IF it_bkpf IS NOT INITIAL.
    SELECT bukrs
         belnr
         gjahr
         buzei
         shkzg
         dmbtr
         FROM bseg
         INTO TABLE it_bseg
         FOR ALL ENTRIES IN it_bkpf
         WHERE belnr = it_bkpf-belnr
         AND shkzg = 'H'.

* endif.
* if it_mseg1 is NOT INITIAL.

    SELECT belnr
         blart
         xblnr
         stblg
         bktxt
        FROM bkpf
        INTO TABLE it_bkpf1
        FOR ALL ENTRIES IN  it_mseg
*        FOR ALL ENTRIES IN it_bkpf
           WHERE xblnr = it_mseg-mblnr
*         WHERE stblg = it_bkpf-belnr
      AND blart = 'RT'.

  ENDIF.
  IF it_bkpf1 IS NOT INITIAL.
    SELECT bukrs
           belnr
           gjahr
           buzei
           shkzg
           dmbtr
           FROM bseg
           INTO TABLE it_bseg1
           FOR ALL ENTRIES IN it_bkpf1
           WHERE belnr = it_bkpf1-belnr
           AND shkzg = 'H'.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_data .

  LOOP AT it_mseg INTO wa_mseg.
    """""""""po po line item material inbound delivery and migo no and date
    wa_final-vbeln_im     =  wa_mseg-vbeln_im .
    wa_final-103_post_date    =  wa_mseg-budat_mkpf  .
    wa_final-103_date     =  wa_mseg-cpudt_mkpf  .
    wa_final-103_migo_no  =  wa_mseg-mblnr.
*    wa_final-103_migo_tm  =  wa_mseg-cputm_mkpf.
    CONCATENATE wa_mseg-cputm_mkpf+0(2) wa_mseg-cputm_mkpf+2(2) wa_mseg-cputm_mkpf+4(2) INTO wa_final-103_migo_tm SEPARATED BY ':'.
    """"invoice no
    READ TABLE it_vbrp INTO wa_vbrp WITH KEY vgbel = wa_mseg-xblnr_mkpf+0(10).
*    READ TABLE it_vbrp INTO wa_vbrp with key matnr = wa_mseg-matnr.                          "added by aakashk 24.09.2024
    IF sy-subrc IS INITIAL.
      wa_final-inv_no = wa_vbrp-vbeln.
    ENDIF.

    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
    IF sy-subrc IS INITIAL.
      wa_final-fkdat = wa_vbrk-fkdat.
    ENDIF.
    """""""""103 mov type jv no
    READ TABLE it_bkpf INTO wa_bkpf WITH KEY xblnr = wa_mseg-mblnr.
    IF sy-subrc IS INITIAL.
      wa_final-103_jv_no = wa_bkpf-belnr.
    ENDIF.
    """""""""103 mov type jv amt
    READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_final-103_jv_no.
    IF sy-subrc IS INITIAL.
      wa_final-103_amt = wa_bseg-dmbtr.
    ENDIF.
    """"""""""""""""104 mov type migo no
    READ TABLE it_mseg_104 INTO wa_mseg_104 WITH KEY lfbnr = wa_mseg-mblnr.
    IF sy-subrc IS INITIAL.
      wa_final-104_post_date    = wa_mseg_104-budat_mkpf  .                                                 "added by aakashk 26.09.2024
      wa_final-104_date    = wa_mseg_104-cpudt_mkpf  .                                                 "added by aakashk 26.09.2024
      wa_final-104_migo_no = wa_mseg_104-mblnr.
      CONCATENATE wa_mseg_104-cputm_mkpf+0(2) wa_mseg_104-cputm_mkpf+2(2) wa_mseg_104-cputm_mkpf+4(2) INTO wa_final-104_migo_tm SEPARATED BY ':'.
    ENDIF.
    """""""""105 mov type migo no and date

    READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY lfbnr = wa_final-103_migo_no.
*    LOOP AT it_mseg1 INTO wa_mseg1 WHERE lfbnr = wa_final-103_migo_no
*                                           AND flag1 ne 'X'."wa_mseg-mblnr.
*                                              ebeln =  wa_mseg-ebeln
*                                              ebelp =  wa_mseg-ebelp.
    IF sy-subrc IS INITIAL.
      IF wa_mseg1-flag1 NE 'X'.
        wa_final-105_post_date    = wa_mseg1-budat_mkpf  .
        wa_final-105_date    = wa_mseg1-cpudt_mkpf .
        wa_final-105_migo_no = wa_mseg1-mblnr.
        CONCATENATE wa_mseg1-cputm_mkpf+0(2) wa_mseg1-cputm_mkpf+2(2) wa_mseg1-cputm_mkpf+4(2) INTO wa_final-105_migo_tm SEPARATED BY ':'.
        wa_mseg1-flag1 = 'X'.
        wa_final-flag1 = 'X'.
*    delete it_mseg1 where mblnr = wa_final-105_migo_no.
        MODIFY it_mseg1 FROM wa_mseg1 TRANSPORTING flag1 WHERE mblnr = wa_final-105_migo_no
                                                           AND lfbnr = wa_final-103_migo_no.
      ENDIF.
      CLEAR :wa_mseg1 .
*        ENDLOOP.
    ENDIF.
     delete it_mseg1 where FLAG1 eq 'X'.
    """""""""105 mov type jv no
    READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY  xblnr = wa_final-103_migo_no. "stblg =  wa_final-103_jv_no."wa_bkpf-belnr.
*    READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY xblnr  = wa_mseg-mblnr.
    IF sy-subrc IS INITIAL.
      wa_final-105_jv_no = wa_bkpf1-belnr.
    ENDIF.

    """""""""105 mov type jv amt
    READ TABLE it_bseg1 INTO wa_bseg1 WITH KEY belnr = wa_final-105_jv_no.
    IF sy-subrc IS INITIAL.
      wa_final-105_amt = wa_bseg1-dmbtr.
    ENDIF.

    """""""""106 mov
    READ TABLE it_data INTO wa_data WITH KEY smbln = wa_final-105_migo_no.
* READ TABLE it_mseg_106 INTO wa_mseg_106 WITH KEY lfbnr = wa_mseg-mblnr.
    IF sy-subrc IS INITIAL.
      wa_final-106_post_date    = wa_data-budat_mkpf.                                                      "added by aakashk 26.09.2024
      wa_final-106_date    = wa_data-cpudt_mkpf.                                                      "added by aakashk 26.09.2024
      wa_final-106_migo_no = wa_data-mblnr.
      CONCATENATE wa_data-cputm_mkpf+0(2) wa_data-cputm_mkpf+2(2) wa_data-cputm_mkpf+4(2) INTO wa_final-106_migo_tm SEPARATED BY ':'.
    ENDIF.

*    ON CHANGE OF wa_final-vbeln_im.
*      IF wa_final-104_migo_no IS  INITIAL AND wa_final-106_migo_no IS  INITIAL.
*          DATA(flag_NEW) = 'X'.
*      ENDIF.
*    ENDON.

*    IF flag_NEW NE 'X'.
         APPEND wa_final TO it_final.
*    ENDIF.

    CLEAR :wa_final, wa_mseg, wa_mseg1,
           wa_bseg, wa_bseg1, wa_data, wa_mseg_104,
           wa_bkpf, wa_bkpf1, wa_vbrp, wa_vbrk .",flag_NEW." wa_vbrp.                           "added by aakashk 25.09.2024
  ENDLOOP.

  LOOP AT IT_MSEG1 INTO WA_MSEG1 .
    READ TABLE IT_FINAL INTO WA_FINAL WITH KEY 103_MIGO_NO = WA_MSEG1-LFBNR.
    IF WA_FINAL-FLAG1 = 'X'.
      DATA(WA_FINAL1) = WA_FINAL.
    ENDIF.
    WA_FINAL1-105_migo_no = WA_MSEG1-MBLNR.
    WA_FINAL1-105_post_date = WA_MSEG1-budat_mkpf.
    WA_FINAL1-105_date = WA_MSEG1-cpudt_mkpf.
     CONCATENATE wa_mseg1-cputm_mkpf+0(2) wa_mseg1-cputm_mkpf+2(2) wa_mseg1-cputm_mkpf+4(2) INTO wa_final1-105_migo_tm SEPARATED BY ':'.

      READ TABLE it_data INTO wa_data WITH KEY smbln = wa_final1-105_migo_no.
* READ TABLE it_mseg_106 INTO wa_mseg_106 WITH KEY lfbnr = wa_mseg-mblnr.
    IF sy-subrc IS INITIAL.
      wa_final1-106_post_date    = wa_data-budat_mkpf.                                                      "added by aakashk 26.09.2024
      wa_final1-106_date    = wa_data-cpudt_mkpf.                                                      "added by aakashk 26.09.2024
      wa_final1-106_migo_no = wa_data-mblnr.
      CONCATENATE wa_data-cputm_mkpf+0(2) wa_data-cputm_mkpf+2(2) wa_data-cputm_mkpf+4(2) INTO wa_final1-106_migo_tm SEPARATED BY ':'.
    else.
      clear :   wa_final1-106_migo_no, wa_final1-106_date, wa_final1-106_migo_tm, wa_final1-106_post_date.
    ENDIF.


    APPEND WA_FINAL1 TO IT_FINAL.
    CLEAR :  WA_FINAL ,WA_FINAL1, WA_MSEG1.
  ENDLOOP.
  SORT IT_FINAL." BY 103_MIGO_NO.


  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS .
*  DELETE ADJACENT DUPLICATES FROM it_final COMPARING vbeln_im inv_no fkdat 103_date
*                                                     103_migo_no 103_jv_no 103_amt
*                                                     104_date 104_migo_no 103_migo_tm
*                                                     104_migo_tm 105_migo_no 105_migo_tm.


*  delete it_final WHERE  104_migo_no is INITIAL and
*                        105_migo_no IS INITIAL and 106_MIGO_NO is INITIAL and flag1 is INITIAL.

  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.

      wa_down-vbeln_im     =  wa_final-vbeln_im  .
      wa_down-inv_no      =  wa_final-inv_no.
*      wa_down-fkdat      =  wa_final-fkdat.
      IF wa_final-fkdat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-fkdat
          IMPORTING
            output = wa_down-fkdat.
        CONCATENATE wa_down-fkdat+0(2) wa_down-fkdat+2(3) wa_down-fkdat+5(4)
                         INTO wa_down-fkdat SEPARATED BY '-'.
      ENDIF.
*  wa_down-103_date     =  wa_final-103_date  .
      IF wa_final-103_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-103_date
          IMPORTING
            output = wa_down-103_date.
        CONCATENATE wa_down-103_date+0(2) wa_down-103_date+2(3) wa_down-103_date+5(4)
                         INTO wa_down-103_date SEPARATED BY '-'.
      ENDIF.

       IF wa_final-103_post_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-103_post_date
          IMPORTING
            output = wa_down-103_post_date.
        CONCATENATE wa_down-103_post_date+0(2) wa_down-103_post_date+2(3) wa_down-103_post_date+5(4)
                         INTO wa_down-103_post_date SEPARATED BY '-'.
      ENDIF.

      wa_down-103_migo_no  =  wa_final-103_migo_no  .
      wa_down-103_amt =   wa_final-103_amt.
      wa_down-103_jv_no =   wa_final-103_jv_no.

      "added by aakashk 26.09.2024
      IF wa_final-104_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-104_date
          IMPORTING
            output = wa_down-104_date.
        CONCATENATE wa_down-104_date+0(2) wa_down-104_date+2(3) wa_down-104_date+5(4)
                         INTO wa_down-104_date SEPARATED BY '-'.

      ENDIF.

      IF wa_final-104_post_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-104_post_date
          IMPORTING
            output = wa_down-104_post_date.
        CONCATENATE wa_down-104_post_date+0(2) wa_down-104_post_date+2(3) wa_down-104_post_date+5(4)
                         INTO wa_down-104_post_date SEPARATED BY '-'.

      ENDIF.

      wa_down-104_migo_no  =  wa_final-104_migo_no  .
*  wa_down-105_date     = wa_final-105_date .
      IF wa_final-105_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-105_date
          IMPORTING
            output = wa_down-105_date.
        CONCATENATE wa_down-105_date+0(2) wa_down-105_date+2(3) wa_down-105_date+5(4)
                         INTO wa_down-105_date SEPARATED BY '-'.
      ENDIF.

       IF wa_final-105_post_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-105_post_date
          IMPORTING
            output = wa_down-105_post_date.
        CONCATENATE wa_down-105_post_date+0(2) wa_down-105_post_date+2(3) wa_down-105_post_date+5(4)
                         INTO wa_down-105_post_date SEPARATED BY '-'.
      ENDIF.

      wa_down-105_migo_no  = wa_final-105_migo_no.

      wa_down-105_amt =     wa_final-105_amt.
      wa_down-105_jv_no =   wa_final-105_jv_no.

      "added by aakashk 26.09.2024

      IF wa_final-106_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-106_date
          IMPORTING
            output = wa_down-106_date.
        CONCATENATE wa_down-106_date+0(2) wa_down-106_date+2(3) wa_down-106_date+5(4)
                         INTO wa_down-106_date SEPARATED BY '-'.
      ENDIF.

      IF wa_final-106_post_date IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-106_post_date
          IMPORTING
            output = wa_down-106_post_date.
        CONCATENATE wa_down-106_post_date+0(2) wa_down-106_post_date+2(3) wa_down-106_post_date+5(4)
                         INTO wa_down-106_post_date SEPARATED BY '-'.
      ENDIF.

      wa_down-106_migo_no  = wa_final-106_migo_no.

      "endadd by aakashk 26.09.024


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

      wa_down-ref_time = sy-uzeit.
      CONCATENATE  wa_down-ref_time+0(2) ':'  wa_down-ref_time+2(2)  INTO  wa_down-ref_time.

      wa_down-103_migo_tm = wa_final-103_migo_tm.
      wa_down-104_migo_tm = wa_final-104_migo_tm.
      wa_down-105_migo_tm = wa_final-105_migo_tm.
      wa_down-106_migo_tm = wa_final-106_migo_tm.

      APPEND wa_down TO it_down.
      CLEAR :wa_final, wa_down.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_fieldcat .
  REFRESH gt_fieldcat.
  PERFORM gt_fieldcatlog USING :

       'VBELN_IM'      'IT_FINAL'   'Inbound Delivery '             '1'  '10',
       'INV_NO'        'IT_FINAL'   'Invoice No'                    '2'  '8',
       'FKDAT'         'IT_FINAL'   'Invoice Date'                  '3'  '8',
       '103_DATE'      'IT_FINAL'   '103 Entry Date'                '4'  '11',
       '103_POST_DATE' 'IT_FINAL'   '103 Posting Date'              '5'  '11',
       '103_MIGO_NO'   'IT_FINAL'   '103 Migo No'                   '6'  '10',
       '103_MIGO_TM'   'IT_FINAL'   '103 Migo Time'                 '7'  '10',
       '103_JV_NO'     'IT_FINAL'   '103 JV No'                     '8'  '13',
       '103_AMT'       'IT_FINAL'   '103 Amount'                    '9'  '13',
       '104_DATE'      'IT_FINAL'   '104 Entry Date'                '10'  '11',             "added by aakaskk 26.09.2024
       '104_POST_DATE' 'IT_FINAL'   '104 Posting Date'              '11'  '11',
       '104_MIGO_NO'   'IT_FINAL'   '104 Migo No'                   '12' '13',
       '104_MIGO_TM'  'IT_FINAL'   '104 Migo Time'                  '13' '13',
       '105_DATE'     'IT_FINAL'   '105 Entry Date'                 '14' '11',
       '105_POST_DATE' 'IT_FINAL'   '105 Posting Date'              '15'  '11',
       '105_MIGO_NO'  'IT_FINAL'   '105 Migo No'                    '16' '10',
       '105_MIGO_TM'  'IT_FINAL'   '105 Migo Time'                  '17' '10',
       '105_JV_NO'    'IT_FINAL'   '105 JV No'                      '18' '13',
       '105_AMT'      'IT_FINAL'   '105 Amount'                     '19' '13',
       '106_DATE'     'IT_FINAL'   '106 Entry Date'                 '20' '11',             "added by aakaskk 26.09.2024
       '106_POST_DATE' 'IT_FINAL'   '106 Posting Date'              '21'  '11',
       '106_MIGO_NO'  'IT_FINAL'   '106 Migo No'                   '22' '10',
       '106_MIGO_TM'  'IT_FINAL'   '106 Migo Time'                 '23' '10'.

ENDFORM.

FORM gt_fieldcatlog  USING    v1 v2 v3 v4 v5.

  gs_fieldcat-fieldname   = v1.
  gs_fieldcat-tabname     = v2.
  gs_fieldcat-seltext_l   = v3.
  gs_fieldcat-col_pos     = v4.
  gs_fieldcat-outputlen   = v5.
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR  gs_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = gt_fieldcat[]
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  IF p_down = 'X'.

    PERFORM download1.
  ENDIF.


ENDFORM.


FORM download1 .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: LV_FOLDER(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).


*   PERFORM NEW_FILE.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

  PERFORM cvs_header USING hd_csv. " add by supriya on 21.08.2024

  lv_file = 'ZUS_TRANSIT_ANALYSIS.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_TRANSIT_ANALYSIS.TXT DOWNLOAD STARTED ON', sy-datum, 'AT', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_929 TYPE string.
DATA lv_crlf_929 TYPE string.
lv_crlf_929 = cl_abap_char_utilities=>cr_lf.
lv_string_929 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_929 lv_crlf_929 wa_csv INTO lv_string_929.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_939 TO lv_fullfile.
TRANSFER lv_string_929 TO lv_fullfile.
    CLOSE DATASET lv_fullfile.
    CONCATENATE 'FILE' lv_fullfile 'DOWNLOADED' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

ENDFORM.

FORM cvs_header  USING    p_hd_csv.   " ADD BY SUPRIYA ON 21.08.2024
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE 'Inbound Delivery'
              'Invoice No'
              'Invoice Date'
              '103 Entry Date'
              '103 Posting Date'
              '103 Migo No'
              '103 Migo Time'
              '103 JV No'
              '103 Amount'
              '104 Entry Date'              "added by aakaskk 26.09.2024
              '104 Posting Date'
              '104 Migo No'           "added by aakaskk 26.09.2024
              '104 Migo Time'           "added by aakaskk 26.09.2024
              '105 Entry Date'
              '105 Posting Date'
              '105 Migo No'
              '105 Migo Time'
              '105 JV No'
              '105 Amount'
              '106 Entry Date'                "added by aakaskk 26.09.2024
              '106 Posting Date'
              '106 Migo No'             "added by aakaskk 26.09.2024
              '106 Migo Time'
              'Refreshable Date'
              'Refreshed Time'
              INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
