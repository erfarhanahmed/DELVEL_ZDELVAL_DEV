**-----------------------------------------------*
REPORT zrel_prod_comp.
TABLES : afko , caufv , mseg ,vbap .

**&---------------------------------------------------------------------*
**& Types / structure
**&---------------------------------------------------------------------*

DATA: lv_kpr_quality TYPE mard-insme,
      shr_quality    TYPE mard-insme.

TYPES : BEGIN OF str_caufv,
          aufnr TYPE caufv-aufnr,
          erdat TYPE caufv-erdat,
        END OF str_caufv.

TYPES : BEGIN OF ty_cust,
          vbeln TYPE vbak-vbeln,
          kunnr TYPE vbak-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_cust.

TYPES : BEGIN OF str_gt,
          vbeln  TYPE  vbap-vbeln,
          posnr  TYPE  vbap-posnr,
          matnr  TYPE  vbap-matnr,
          werks  TYPE  vbap-werks,
          edatu  TYPE  edatu,
          wmeng  TYPE  wmeng,
          etenr  TYPE  etenr,
          lfsta  TYPE  lfsta,
          aufnr  TYPE  aufnr,
          kwmeng TYPE kwmeng,
          objnr  TYPE jest-objnr,
        END OF str_gt.

DATA : gt_main TYPE TABLE OF str_gt,
       wa_main TYPE str_gt.

TYPES : BEGIN OF str_afko,
          aufnr  TYPE afko-aufnr,
          ftrmi  TYPE afko-ftrmi,
          gamng  TYPE afko-gamng,
          stlbez TYPE afko-stlbez,
        END OF str_afko.

TYPES : BEGIN OF str_mseg,
          aufnr      TYPE mseg-aufnr,
          budat_mkpf TYPE mseg-budat_mkpf,
          bwart      TYPE mseg-bwart,
        END OF str_mseg.

TYPES : BEGIN OF str_resb,
          aufnr TYPE resb-aufnr,
          rsnum TYPE resb-rsnum,
          rspos TYPE resb-rspos,
          bdmng TYPE resb-bdmng,
          enmng TYPE resb-enmng,
          matnr TYPE resb-matnr,
          bwart TYPE resb-bwart,
        END OF str_resb.
************Added by jyoti on 11.10.2024**********
TYPES :BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         labst TYPE mard-labst,
         insme TYPE mard-insme,
         diskz TYPE mard-diskz,
       END OF ty_mard,

       BEGIN OF t_sl_col,
         lgort TYPE lgort_d,
         col   TYPE char4,
       END OF t_sl_col.
********************************************
TYPES : BEGIN OF str_resb1,
          aufnr TYPE resb-aufnr,
          bdmng TYPE resb-bdmng,
          enmng TYPE resb-enmng,
        END OF str_resb1.

DATA : it_caufv1 TYPE TABLE OF str_resb1,
       wa_caufv1 TYPE str_resb1.

*DATA: kpr_quality TYPE string,
*      shr_quality TYPE string.

TYPES : BEGIN OF str_aufk,
          aufnr TYPE aufk-aufnr,
          kdauf TYPE aufk-kdauf,
          kdpos TYPE aufk-kdpos,
        END OF str_aufk.

TYPES : BEGIN OF str_data1,
          vbeln TYPE  vbeln,
          posnr TYPE  posnr,
*        matnr  TYPE  matnr,
          erdat TYPE  erdat,
          lfsta TYPE  lfsta,
          lfgsa TYPE  lfgsa,
          fksta TYPE  fksta,
          absta TYPE  absta,
          gbsta TYPE  gbsta,
          aufnr TYPE  aufnr,
          kdauf TYPE  char15,
          kdpos TYPE  kdpos,
        END OF str_data1.

TYPES : BEGIN OF str_data,
          budat_mkpf       TYPE mseg-budat_mkpf,
          aufnr            TYPE char15,
          erdat            TYPE caufv-erdat,
          ftrmi            TYPE afko-ftrmi,
          first_issue_date TYPE mseg-budat_mkpf,
          bdmng            TYPE resb-bdmng,
          enmng            TYPE resb-enmng,
          status           TYPE char20,
          last_issue_date  TYPE mseg-budat_mkpf,
          txt04            TYPE string,
          kdauf            TYPE aufk-kdauf,
          kdpos            TYPE aufk-kdpos,
          kwmeng           TYPE vbap-kwmeng,
          gamng            TYPE afko-gamng,
          name1            TYPE kna1-name1,
          stlbez           TYPE afko-stlbez,
          mat_desc         TYPE string,
          matnr            TYPE matnr,
          mat_desc1        TYPE string,
          componenet       TYPE matnr,
          componenet_desc  TYPE string,
*******************added b yjyoti on 11.10.2024
          sl1              TYPE menge_d,
          sl2              TYPE menge_d,
          sl4              TYPE menge_d,
          sl5              TYPE menge_d,
          sl6              TYPE menge_d,
          sl8              TYPE menge_d,
          sl9              TYPE menge_d,
*          sl10             TYPE menge_d,
*          sl11             TYPE menge_d,
          sl12             TYPE menge_d,
*          sl13             TYPE menge_d,
*          sl14             TYPE menge_d,
          sl15             TYPE menge_d,
          sl16             TYPE menge_d,
          sl17             TYPE menge_d,
          sl18             TYPE menge_d,
          sl19             TYPE menge_d,
          sl20             TYPE menge_d,
          sl21             TYPE menge_d,
          sl22             TYPE menge_d,
          sl24             TYPE menge_d,
*          sl25             TYPE menge_d,
*          sl26             TYPE menge_d,
          sl28             TYPE menge_d,
*          sl29             TYPE menge_d,
          sl30             TYPE menge_d,
          sl31             TYPE menge_d, """"
          sl32             TYPE menge_d,
          sl33             TYPE menge_d,
          sl34             TYPE menge_d,
          sl35             TYPE menge_d,
          sl36             TYPE menge_d,
          sl37             TYPE menge_d,
          short_qty        TYPE resb-bdmng,
          kpr_quality      TYPE mard-insme,  " add by supriya on 07.11.2024
          shr_quality      TYPE mard-insme,  " add by supriya on 07.11.2024

        END OF str_data.

TYPES : BEGIN OF str_down,
          aufnr            TYPE caufv-aufnr,
          erdat            TYPE string,                                "caufv-erdat,
          gamng            TYPE string,
          ftrmi            TYPE string,                                 "afko-ftrmi,
          first_issue_date TYPE string,                                     "mseg-budat_mkpf,
          bdmng            TYPE string,                                    "resb-bdmng,
          enmng            TYPE string,
          short_qty        TYPE string,                                            "resb-enmng,
          status           TYPE char20,
          last_issue_date  TYPE string,                                       "mseg-budat_mkpf,
          txt04            TYPE string,
          kdauf            TYPE aufk-kdauf,
          kdpos            TYPE aufk-kdpos,
*         kwmeng           TYPE string,
          name1            TYPE string,
          matnr            TYPE string,
          mat_desc1        TYPE string,
          stlbez           TYPE string,
          mat_desc         TYPE string,
          componenet       TYPE string,
          componenet_desc  TYPE string,
          sl1              TYPE string,
          sl2              TYPE string,
          sl4              TYPE string,
          sl5              TYPE string,
          sl6              TYPE string,
          sl8              TYPE string,
          sl9              TYPE string,
*          sl10             TYPE string,
*          sl11             TYPE string,
          sl12             TYPE string,
*          sl13             TYPE string,
*          sl14             TYPE string,
          sl15             TYPE string,
          sl16             TYPE string,
          sl17             TYPE string,
          sl18             TYPE string,
          sl19             TYPE string,
          sl20             TYPE string,
          sl21             TYPE string,
          sl22             TYPE string,
          sl24             TYPE string,
*          sl25             TYPE string,
*          sl26             TYPE string,
          sl28             TYPE string,
*          sl29             TYPE string,
          sl30             TYPE string,
          sl31             TYPE string, """"
          sl32             TYPE string,
          sl33             TYPE string,
          sl34             TYPE string,
          sl35             TYPE string,
          sl36             TYPE string,
          sl37             TYPE string,
          kpr_quality      TYPE string,  " add by supriya on 07.11.2024
          shr_quality      TYPE string,  " add by supriya on 07.11.2024
          ref_date         TYPE string,
          ref_time         TYPE char15,
        END OF str_down.

TYPES : BEGIN OF str_aufk_n,
          aufnr TYPE caufv-aufnr,
          erdat TYPE caufv-erdat,
        END OF str_aufk_n.

**&---------------------------------------------------------------------*
**& Data declaration / variable /Internal Table and Work Area Declaration
**&---------------------------------------------------------------------*
DATA : it_caufv TYPE TABLE OF str_caufv,
       wa_caufv TYPE str_caufv.

DATA : it_cust TYPE TABLE OF ty_cust,
       wa_cust TYPE ty_cust.

DATA : it_afko TYPE TABLE OF str_afko,
       wa_afko TYPE str_afko.

DATA : it_aufk_n TYPE TABLE OF str_aufk_n,
       wa_aufk_n TYPE str_aufk_n,

       it_sl_col TYPE TABLE OF t_sl_col,
       wa_sl_col TYPE t_sl_col.

DATA : it_mseg TYPE TABLE OF str_mseg,
       wa_mseg TYPE str_mseg.

DATA : it_resb TYPE TABLE OF str_resb,
       wa_resb TYPE str_resb,

       it_mard TYPE TABLE OF ty_mard,
       wa_mard TYPE          ty_mard.

DATA : it_data TYPE TABLE OF str_data,
       wa_data TYPE str_data.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

DATA : lv_sum_bdmng TYPE bdmng.                     " Variable to store sum of BDMNG
DATA : lv_sum_enmng TYPE enmng.

DATA : it_down TYPE TABLE OF str_down,
       wa_down TYPE str_down.

DATA : it_aufk TYPE TABLE OF str_aufk,
       wa_aufk TYPE str_aufk.

DATA : it_data1 TYPE TABLE OF str_data1,
       wa_data1 TYPE str_data1.

DATA: lv_erdat            TYPE string,
      lv_ftrmi            TYPE string,
      lv_first_issue_date TYPE string,
      lv_last_issue_date  TYPE string.

DATA:
  lv_objnr        TYPE caufv-objnr,
  object_tab      TYPE bsvx,
  lv_total_issued TYPE mseg-menge.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.

*----------------------------------------------------------------------*
* Selection screen
*----------------------------------------------------------------------*
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS : s_vbeln FOR vbap-vbeln .
  PARAMETERS :    p_werks TYPE caufv-werks OBLIGATORY DEFAULT 'PL01' MODIF ID bu.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-004  .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder TYPE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp' .    "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-003.
*                     COMMENT 1(70) TEXT-004.
*SELECTION-SCREEN COMMENT /1(70) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

*&---------------------------------------------------------------------*
*& Start of Selection
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM get_data.
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

  SELECT a~vbeln,a~posnr, a~matnr,a~werks,d~edatu,d~wmeng,d~etenr,
         c~lfsta,f~aufnr,a~kwmeng
          INTO CORRESPONDING FIELDS OF TABLE @gt_main
          FROM vbap AS a
           JOIN vbup AS c ON c~vbeln = a~vbeln
                        AND c~posnr = a~posnr
           JOIN vbep AS d ON a~vbeln = d~vbeln
                        AND a~posnr = d~posnr
           JOIN afpo AS f ON a~vbeln = f~kdauf
                        AND a~posnr = f~kdpos
          WHERE a~vbeln IN @s_vbeln
            AND a~werks =  @p_werks
            AND c~lfsta NE 'C'
            AND c~gbsta NE 'C'
            AND c~fksta NE 'C'
            AND c~lfgsa NE 'C'
            AND d~ettyp = 'CP'.

  LOOP AT gt_main INTO wa_main.
    CONCATENATE 'OR' wa_main-aufnr INTO wa_main-objnr.
    MODIFY gt_main FROM wa_main TRANSPORTING objnr.
  ENDLOOP.

  SELECT objnr,
         stat,
         inact
    FROM jest INTO TABLE @DATA(it_jest)
    FOR ALL ENTRIES IN @gt_main
    WHERE objnr = @gt_main-objnr
      AND stat EQ 'I0045'
      AND inact NE 'X'.

  IF gt_main IS  INITIAL .
    MESSAGE |DATA NOT FOUND| TYPE 'E'.
  ENDIF.

  SELECT aufnr
         erdat
    FROM aufk
    INTO TABLE it_aufk_n
    FOR ALL ENTRIES IN gt_main
     WHERE aufnr = gt_main-aufnr.


  SELECT aufnr
         ftrmi
         gamng
         stlbez
    FROM afko
         INTO TABLE it_afko
         FOR ALL ENTRIES IN gt_main
         WHERE aufnr = gt_main-aufnr.

  SELECT aufnr
         budat_mkpf
         bwart      FROM mseg
         INTO TABLE it_mseg
         FOR ALL ENTRIES IN gt_main
         WHERE aufnr = gt_main-aufnr
         AND bwart = '261'.

  DATA(it_mseg_temp) = it_mseg[].

  DATA(it_mseg_temp1) = it_mseg[].

  SORT it_mseg_temp BY budat_mkpf  ASCENDING.

  SORT it_mseg_temp1 BY budat_mkpf DESCENDING.

  SELECT aufnr
         rsnum
         rspos
         bdmng
         enmng
         matnr
         bwart
         FROM resb
         INTO TABLE it_resb
         FOR ALL ENTRIES IN gt_main
         WHERE aufnr = gt_main-aufnr
         AND bwart = '261'
         AND xloek NE 'X'.                "Added by Sagar Darade on 16.03.2026

  DATA : lv_enmng TYPE resb-enmng,
         lv_bdmng TYPE resb-bdmng.
*  BREAK primusabap.

  LOOP AT it_resb INTO DATA(wa).
    ON CHANGE OF wa-aufnr.
      LOOP AT it_resb INTO wa WHERE aufnr = wa-aufnr.
        lv_bdmng = lv_bdmng + wa-bdmng.
        lv_enmng = lv_enmng + wa-enmng.
      ENDLOOP.
      IF lv_bdmng EQ lv_enmng.
        DELETE it_resb WHERE aufnr = wa-aufnr.
        CLEAR: lv_bdmng , lv_enmng.
      ENDIF.
    ENDON.
    CLEAR: lv_bdmng , lv_enmng.
  ENDLOOP.

  LOOP AT it_resb INTO wa.
    DELETE it_resb WHERE aufnr = wa-aufnr AND rspos = wa-rspos AND bdmng = wa-enmng.
    DELETE it_resb WHERE aufnr = wa-aufnr AND rspos = wa-rspos AND enmng GE wa-bdmng.
  ENDLOOP.
******************************************** ADD BY SUPRIYA ON 04.11.2024
*DATA : LV_ENMNG TYPE resb-enmng,
*       LV_bdmng TYPE resb-bdmng.
*
*
*" Aggregate values for the current enmng
*LOOP AT it_resb INTO DATA(wa) WHERE aufnr = WA_MAIN-aufnr ."AND bwart = '261'.
*
*   LV_ENMNG =  LV_ENMNG + wa_resb-enmng.
*   LV_bdmng = LV_bdmng + wa_resb-bdmng.
*ON CHANGE OF wa_resb-aufnr.
*  IF LV_ENMNG = LV_bdmng .
*   DELETE it_resb WHERE aufnr = wa-aufnr AND rspos = wa-rspos AND enmng = wa-bdmng.
*   APPEND wa_RESB TO it_RESB.
*   CLEAR WA_RESB.
*    ENDIF.
*    ENDON.
*ENDLOOP.


******************************************************************************************

**********************added by jyoti on 11.10.2024********************************
  SELECT matnr
         werks
         lgort
         labst
         insme
         diskz FROM mard
        INTO TABLE it_mard
        FOR ALL ENTRIES IN it_resb
         WHERE matnr = it_resb-matnr
*          AND lgort = p_lgort
           AND werks = p_werks
           AND diskz NE '1'.
**************************************************************************add by supriya on 07.11.2024
*if wa_sl_col-lgort+0(1)= 'K'.
*     SELECT matnr
*          werks
*          lgort
*          labst
*          insme
*          diskz FROM mard
*          INTO TABLE it_mard1
*          FOR ALL ENTRIES IN it_resb
*          WHERE matnr = it_resb-matnr
*          AND lgort in ('KFG0','KPRD','KRM0','KRWK', 'KSC0','KSFG','KSLR','KSPC',
*                      'KTPI', 'KPR1', 'KMCN','KNDT','KPLG','KVLD')
*           AND werks = p_werks
*           AND diskz NE '1'.
**************************************************************************
  LOOP AT it_mard INTO wa_mard.
    CLEAR wa_sl_col.
    wa_sl_col-lgort = wa_mard-lgort.
    APPEND wa_sl_col TO it_sl_col.
    CLEAR : wa_mard.
  ENDLOOP.

*****************************************  add by supriya on 07.11.2024
*   LOOP AT it_mard INTO DATA(wa1).
*    ON CHANGE OF wa_matnr.
*      LOOP AT it_mard INTO wa1 WHERE lgort = wa-lgort.
*       if wa_sl_col-lgort+0(1)= 'K'.
*        lv_KPR_Quality = lv_KPR_Quality + wa-insme.
*       ELSE.
*        lv_SHR_Quality = lv_SHR_Quality + wa-insme.
*       endif.
*      ENDLOOP.
*
*        CLEAR: lv_KPR_Quality , lv_KPR_Quality.
*
*    ENDON.
*    CLEAR: lv_bdmng , lv_enmng.
*  ENDLOOP.

**************************************************



  SELECT objnr, erdat, aufnr
         FROM caufv
         INTO TABLE @DATA(it_caufv_new)
         FOR ALL ENTRIES IN @it_caufv
         WHERE aufnr = @it_caufv-aufnr.

  SELECT a~vbeln
         a~kunnr
         c~name1
           FROM vbak AS a
           INNER JOIN kna1 AS c ON c~kunnr = a~kunnr
           INTO TABLE it_cust
           FOR ALL ENTRIES IN gt_main
           WHERE a~vbeln = gt_main-vbeln.

  SORT it_resb BY aufnr.
  LOOP AT it_resb INTO wa_resb .
    wa_data-aufnr       = wa_resb-aufnr.
    wa_data-componenet  = wa_resb-matnr.

*    *    """"""""""""""""""""""""""""""""""""""""""""
    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_data-componenet.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       client                  = sy-mandt
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
          REPLACE ALL OCCURRENCES OF '<(>' IN wa_lines-tdline WITH space.
          REPLACE ALL OCCURRENCES OF '<)>'   IN wa_lines-tdline WITH space.
          CONCATENATE wa_data-componenet_desc wa_lines-tdline INTO wa_data-componenet_desc SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_data-componenet_desc.
    ENDIF.
*    """"""""""""""""""""""""""""""""""""""""""""
    wa_data-bdmng       = wa_resb-bdmng.
    wa_data-enmng       = wa_resb-enmng.

    READ TABLE gt_main INTO wa_main WITH KEY aufnr =  wa_data-aufnr.
    IF  sy-subrc = 0.
      wa_data-kdauf  = wa_main-vbeln.
      wa_data-kdpos  = wa_main-posnr.
      wa_data-matnr  = wa_main-matnr.
    ENDIF.

*    wa_data-kwmeng = wa_main-kwmeng.

*    """"""""""""""""""""""""""""""""""""""""""""
    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_data-matnr.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       client                  = sy-mandt
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
          REPLACE ALL OCCURRENCES OF '<(>' IN wa_lines-tdline WITH space.
          REPLACE ALL OCCURRENCES OF '<)>'   IN wa_lines-tdline WITH space.
          CONCATENATE wa_data-mat_desc1 wa_lines-tdline INTO wa_data-mat_desc1 SEPARATED BY space.
*          REPLACE ALL OCCURRENCES OF '+'   IN wa_lines-tdline WITH space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_data-mat_desc1.
*      REPLACE ALL OCCURRENCES OF '+'   IN wa_lines-tdline WITH space.
    ENDIF.
*    """"""""""""""""""""""""""""""""""""""""""""
    READ TABLE it_aufk_n INTO wa_aufk_n WITH KEY aufnr = wa_data-aufnr .
    IF sy-subrc = 0.
      wa_data-erdat = wa_aufk_n-erdat.
    ENDIF.

    IF wa_data-enmng = 0.
      wa_data-status = 'NOT ISSUED'.
    ELSEIF wa_data-bdmng - wa_data-enmng NE 0.
      wa_data-status = 'PARTIAL ISSUED'.
    ELSEIF wa_data-bdmng - wa_data-enmng = 0.
      wa_data-status = 'COMPLETE ISSUED'.
    ENDIF.

    IF wa_data-enmng GE wa_data-bdmng.
      CLEAR : wa_data-status.
      wa_data-status = 'COMPLETE ISSUED'.
    ENDIF.

    wa_data-short_qty = wa_data-bdmng - wa_data-enmng."added by jyoti on 11.10.2024
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_data-aufnr .
    IF sy-subrc = 0.
      wa_data-ftrmi  = wa_afko-ftrmi.
************************************************** ADD BY SUPRIYA ON 04.11.2024

      wa_data-gamng  = wa_afko-gamng.
***************************************************
      wa_data-stlbez = wa_afko-stlbez.
    ENDIF.

    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_data-stlbez.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       client                  = sy-mandt
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
          CONCATENATE wa_data-mat_desc wa_lines-tdline INTO wa_data-mat_desc SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_data-mat_desc.
    ENDIF.
*********************addedby jyoti on 11.10.2024****************************
    LOOP AT it_mard INTO wa_mard WHERE matnr = wa_resb-matnr.

      READ TABLE it_sl_col INTO wa_sl_col WITH KEY lgort = wa_mard-lgort.

      IF wa_sl_col-lgort+0(1) = 'K'.

        IF wa_sl_col-lgort = 'KFG0'.           " Finished Goods
          wa_data-sl18 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KPRD'.       " Production
          wa_data-sl19 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KRM0'.      " Raw Materials
          wa_data-sl20 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KRWK'.      " Rework
          wa_data-sl21 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KSC0'.      " Subcon
          wa_data-sl22 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KSFG'.      " WIP assembled
          wa_data-sl24 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
*        ELSEIF wa_sl_col-lgort = 'KSLR'.      " FG Sales Return
*          wa_data-sl25 = wa_mard-labst.
*        ELSEIF wa_sl_col-lgort = 'KSPC'.      " Spares & Consum
*          wa_data-sl26 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'KTPI'.      " Third Party
          wa_data-sl28 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KPR1'.      " KPR1
          wa_data-sl30 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KMCN'.
          wa_data-sl31 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KNDT'.
          wa_data-sl32 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KPLG'.
          wa_data-sl33 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'KVLD'.
          wa_data-sl34 = wa_mard-labst.
          wa_data-kpr_quality =  wa_data-kpr_quality + wa_mard-insme.
        ENDIF.
      ELSE.
        IF wa_sl_col-lgort = 'FG01'.           " Finished Goods
          wa_data-sl1 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'PRD1'.       " Production
          wa_data-sl2 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'RM01'.      " Raw Materials
          wa_data-sl4 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'RWK1'.      " Rework
          wa_data-sl5 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'SC01'.      " Subcon
          wa_data-sl6 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'SFG1'.      " WIP assembled
          wa_data-sl8 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'STA1'.      "
          wa_data-sl9 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
*        ELSEIF wa_sl_col-lgort = 'SPC1'.      " Spares & Consum
*          wa_data-sl10 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'TPI1'.      " Third Party
          wa_data-sl12 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
*        ELSEIF wa_sl_col-lgort = 'TR01'.      " QA OK STOCK SL            " 25/05/2018
*          wa_data-sl14 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'PLG1'.      " Planning            " 25/05/2018
          wa_data-sl15 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'SAN1'.      " Planning            " 25/05/2018
          wa_data-sl16 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'MCN1'.      " Planning            " 25/05/2018
          wa_data-sl17 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'NDT1'.
          wa_data-sl35 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'PN01'.
          wa_data-sl36 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ELSEIF wa_sl_col-lgort = 'VLD1'.
          wa_data-sl37 = wa_mard-labst.
          wa_data-shr_quality = wa_data-shr_quality + wa_mard-insme.
        ENDIF.
*      ENDIF.
*      CLEAR : wa_mard,wa_sl_col .  " comment by supriya 07.11.2024
**************************************************************addby supriya on 07.11.2024

*        DATA :total_kpr_quality TYPE mard-insme,
*              total_shr_quality TYPE mard-insme,
*              lv_kpr_quality    TYPE mard-insme,
*              lv_shr_quality    TYPE mard-insme.
*        on CHANGE OF wa_resb-matnr.
*        IF wa_sl_col-lgort+0(1) = 'K'.
*          CASE wa_sl_col-lgort.
*            WHEN 'KFG0' OR 'KPRD' OR 'KRM0' OR 'KRWK' OR 'KSC0' OR 'KSFG' OR
*            'KTPI' OR 'KPR1' OR 'KMCN' OR 'KNDT' OR 'KPLG' OR 'KVLD'.
**       wa_data-KPR_Quality = wa_mard-insme.
*              lv_kpr_quality = wa_mard-insme.
*              " Accumulate the sum
**       total_KPR_Quality = total_KPR_Quality + wa_data-KPR_Quality.
*
*              total_kpr_quality = total_kpr_quality +  lv_kpr_quality.
*              wa_data-kpr_quality = total_kpr_quality .
*            WHEN OTHERS.
*          ENDCASE.
*        ELSE.
*          CASE wa_sl_col-lgort.
*            WHEN 'FG01' OR 'PRD1' OR 'RM01' OR 'RWK1' OR 'SC01' OR 'SFG1' OR
*             'STA1' OR 'TPI1' OR 'PLG1' OR 'SAN1' OR 'MCN1' OR 'NDT1' OR
*            'PN01' OR 'VLD1'.
**      wa_data-shr_Quality = wa_mard-insme.
*              lv_shr_quality = wa_mard-insme.
*              " Accumulate the sum
**       total_shr_Quality = total_KPR_Quality + wa_data-shr_Quality.
*
*              total_shr_quality = total_shr_quality + lv_shr_quality.
*              wa_data-shr_quality = total_shr_quality .
*            WHEN OTHERS.
*
*          ENDCASE.
*        ENDIF.
*        endon.
*   CLEAR: wa_mard, wa_sl_col.
*    CLEAR: wa_mard, wa_sl_col,total_shr_quality,total_kpr_quality.
**************************************************************************************
      ENDIF.
    ENDLOOP.
*******************************************************************************
    READ TABLE it_mseg INTO wa_mseg WITH KEY aufnr = wa_main-aufnr .
    IF sy-subrc = 0.
      wa_data-budat_mkpf = wa_mseg-budat_mkpf.
    ENDIF.

    IF wa_data-status NE 'NOT ISSUED'.
      READ TABLE  it_mseg_temp INTO DATA(ls_mseg_temp) WITH KEY aufnr = wa_data-aufnr .
      IF sy-subrc = 0.
        wa_data-first_issue_date = ls_mseg_temp-budat_mkpf.
      ENDIF.

      READ TABLE  it_mseg_temp1 INTO DATA(ls_mseg_temp1) WITH KEY aufnr = wa_data-aufnr .
      IF sy-subrc = 0.
        wa_data-last_issue_date = ls_mseg_temp1-budat_mkpf.
      ENDIF.
    ENDIF.
    READ TABLE it_caufv_new INTO DATA(wa_caufv_new) WITH KEY aufnr = wa_data-aufnr .
    IF  sy-subrc = 0.
      lv_objnr = wa_caufv_new-objnr.
    ENDIF.

    CALL FUNCTION 'STATUS_TEXT_EDIT'
      EXPORTING
        client           = sy-mandt
        flg_user_stat    = 'X'
        objnr            = lv_objnr
        only_active      = 'X'
        spras            = sy-langu
      IMPORTING
        line             = object_tab-sttxt
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    wa_data-txt04 = object_tab-sttxt.

    wa_data-aufnr = wa_data-aufnr+4(8).
    wa_data-kdauf = wa_data-kdauf+2(8).

    READ TABLE it_cust INTO wa_cust WITH KEY vbeln = wa_main-vbeln.
    IF sy-subrc = 0.
      wa_data-name1 = wa_cust-name1.
    ENDIF.

    IF wa_data-bdmng GT wa_data-enmng.
      READ TABLE it_jest INTO DATA(wa_jest) WITH KEY objnr = wa_main-objnr.
      IF sy-subrc = 0.
        DATA(flag) = 'X'.
      ENDIF.
    ENDIF.





    IF flag NE 'X'.
      APPEND wa_data TO it_data.
      CLEAR wa_data.
    ENDIF.


    CLEAR :wa_data,wa_caufv1,flag.
  ENDLOOP.
  SORT it_data.
*  DELETE ADJACENT DUPLICATES FROM it_data COMPARING aufnr kdauf kdpos.
*  DELETE ADJACENT DUPLICATES FROM it_data COMPARING ALL FIELDS.

  IF p_down = 'X'.

    LOOP AT it_data INTO wa_data.
      wa_down-aufnr               =    wa_data-aufnr                 .
      wa_down-erdat               =    wa_data-erdat                 .
*     wa_down-kwmeng              =    wa_data-kwmeng                .
      wa_down-gamng               =    wa_data-gamng                 .
      wa_down-componenet          =    wa_data-componenet            .
      wa_down-componenet_desc     =    wa_data-componenet_desc           .

      lv_erdat = wa_data-erdat.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = lv_erdat
        IMPORTING
          output = wa_down-erdat.

      IF wa_down-erdat IS NOT INITIAL.
        CONCATENATE wa_down-erdat+0(2) wa_down-erdat+2(3) wa_down-erdat+5(4)
                        INTO wa_down-erdat SEPARATED BY '-'.
      ENDIF.

      lv_ftrmi = wa_data-ftrmi.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = lv_ftrmi
        IMPORTING
          output = wa_down-ftrmi.

      IF wa_down-ftrmi   IS NOT INITIAL.
        CONCATENATE wa_down-ftrmi+0(2) wa_down-ftrmi+2(3) wa_down-ftrmi+5(4)
                        INTO wa_down-ftrmi   SEPARATED BY '-'.
      ENDIF.

      IF wa_data-first_issue_date  IS NOT  INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_data-first_issue_date
          IMPORTING
            output = wa_down-first_issue_date.

        CONCATENATE wa_down-first_issue_date+0(2) wa_down-first_issue_date+2(3) wa_down-first_issue_date+5(4)
                        INTO wa_down-first_issue_date SEPARATED BY '-'.
      ENDIF.

      wa_down-bdmng               =    wa_data-bdmng                 .
      wa_down-enmng               =    wa_data-enmng                 .
      wa_down-status              =    wa_data-status                .

      IF wa_data-last_issue_date  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_data-last_issue_date
          IMPORTING
            output = wa_down-last_issue_date.

        CONCATENATE wa_down-last_issue_date+0(2) wa_down-last_issue_date+2(3) wa_down-last_issue_date+5(4)
                        INTO wa_down-last_issue_date SEPARATED BY '-'.
      ENDIF.

      wa_down-txt04               =    wa_data-txt04                 .
      wa_down-kdauf               =    wa_data-kdauf                 .
      wa_down-kdpos               =    wa_data-kdpos                 .
      wa_down-name1               =    wa_data-name1                 .
      wa_down-matnr               =    wa_data-matnr                 .
      wa_down-mat_desc1           =    wa_data-mat_desc1             .
      wa_down-stlbez              =    wa_data-stlbez                .
      wa_down-mat_desc            =    wa_data-mat_desc              .
      wa_down-short_qty           =    wa_data-short_qty             .
      wa_down-sl1                 =    wa_data-sl1                   .
      wa_down-sl2                 =    wa_data-sl2                   .
      wa_down-sl4                 =    wa_data-sl4                   .
      wa_down-sl5                 =    wa_data-sl5                   .
      wa_down-sl6                 =    wa_data-sl6                   .
      wa_down-sl8                 =    wa_data-sl8                   .
      wa_down-sl9                 =    wa_data-sl9                   .
*      wa_down-sl10                =    wa_data-sl10                  .
*      wa_down-sl11                =    wa_data-sl11                  .
      wa_down-sl12                =    wa_data-sl12                  .
*      wa_down-sl13                =    wa_data-sl13                  .
*      wa_down-sl14                =    wa_data-sl14                  .
      wa_down-sl15                =    wa_data-sl15                  .
      wa_down-sl16                =    wa_data-sl16                  .
      wa_down-sl17                =    wa_data-sl17                  .
      wa_down-sl18                =    wa_data-sl18                  .
      wa_down-sl19                =    wa_data-sl19                  .
      wa_down-sl20                =    wa_data-sl20                  .
      wa_down-sl21                =    wa_data-sl21                  .
      wa_down-sl22                =    wa_data-sl22                  .
      wa_down-sl24                =    wa_data-sl24                  .
*      wa_down-sl25                =    wa_data-sl25                  .
*      wa_down-sl26                =    wa_data-sl26                  .
      wa_down-sl28                =    wa_data-sl28                  .
*      wa_down-sl29                =    wa_data-sl29                  .
      wa_down-sl30                =    wa_data-sl30                  .
      wa_down-sl31                =    wa_data-sl31                  .
      wa_down-sl32                =    wa_data-sl32                  .
      wa_down-sl33                =    wa_data-sl33                  .
      wa_down-sl34                =    wa_data-sl34                  .
      wa_down-sl35                =    wa_data-sl35                  .
      wa_down-sl36                =    wa_data-sl36                  .
      wa_down-sl37                =    wa_data-sl37                  .
      wa_down-kpr_quality     =    wa_data-kpr_quality . " add by supriya on 07.11.2024
      wa_down-shr_quality   =    wa_data-shr_quality.  " add by supriya on 07.11.2024

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.
      IF wa_down-ref_date IS NOT INITIAL.
        CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                        INTO wa_down-ref_date SEPARATED BY '-'.
        wa_down-ref_time = sy-uzeit.
      ENDIF.

      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.
      APPEND wa_down TO it_down.
      CLEAR wa_down.
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

  wa_fieldcat-fieldname = 'AUFNR' .
  wa_fieldcat-seltext_m = 'Prod Order' .
  wa_fieldcat-col_pos = '1'.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ERDAT' .
  wa_fieldcat-seltext_m = 'Prod Order Created Date' .
  wa_fieldcat-col_pos = '2'.
  wa_fieldcat-outputlen = 15.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname = 'GAMNG' .
  wa_fieldcat-seltext_m = 'Prod Order Qty' .
  wa_fieldcat-col_pos = '3'.
  wa_fieldcat-outputlen = 15.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'FTRMI' .
  wa_fieldcat-seltext_m = 'Release Date' .
  wa_fieldcat-col_pos = '4'.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'FIRST_ISSUE_DATE' .
  wa_fieldcat-seltext_m = '1st Issue Date' .
  wa_fieldcat-col_pos = '5'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'COMPONENET' .
  wa_fieldcat-seltext_l = 'COMPONENT' .
  wa_fieldcat-col_pos = '6'.
  wa_fieldcat-outputlen = 20.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'COMPONENET_DESC' .
  wa_fieldcat-seltext_l = 'Component Description' .
  wa_fieldcat-col_pos = '7'.
  wa_fieldcat-outputlen = 40.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'BDMNG' .
  wa_fieldcat-seltext_m = 'Req Quantity' .
  wa_fieldcat-col_pos = '8'.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ENMNG' .
  wa_fieldcat-seltext_m = 'Issued Qty' .
  wa_fieldcat-col_pos = '9'.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'STATUS' .
  wa_fieldcat-seltext_m = 'Status' .
  wa_fieldcat-col_pos = '10'.
  wa_fieldcat-outputlen = 15.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'LAST_ISSUE_DATE' .
  wa_fieldcat-seltext_m = 'Last Issue Date' .
  wa_fieldcat-col_pos = '11'.
  wa_fieldcat-outputlen = 12.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname = 'TXT04' .
  wa_fieldcat-seltext_m = 'System Status' .
  wa_fieldcat-col_pos = '12'.
  wa_fieldcat-outputlen = 25.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'KDAUF' .
  wa_fieldcat-seltext_m = 'SO No' .
  wa_fieldcat-col_pos = '13'.
  wa_fieldcat-outputlen = 8.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'KDPOS' .
  wa_fieldcat-seltext_m = 'SO Item' .
  wa_fieldcat-col_pos = '14'.
  wa_fieldcat-outputlen = 5.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname = 'KWMENG' .
*  wa_fieldcat-seltext_m = 'SO Qty' .
*  wa_fieldcat-col_pos = '13'.
*  wa_fieldcat-outputlen = 6.
*  APPEND wa_fieldcat TO it_fieldcat .
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1' .
  wa_fieldcat-seltext_m = 'Customer' .
  wa_fieldcat-col_pos = '15'.
  wa_fieldcat-outputlen = 25.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR' .
  wa_fieldcat-seltext_m = 'SO Material' .
  wa_fieldcat-col_pos = '16'.
  wa_fieldcat-outputlen = 20.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MAT_DESC1' .
  wa_fieldcat-seltext_l = 'SO Material Description' .
  wa_fieldcat-col_pos = '17'.
  wa_fieldcat-outputlen = 100.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'STLBEZ' .
  wa_fieldcat-seltext_m = 'Prod Material Code'.
  wa_fieldcat-col_pos = '18'.
  wa_fieldcat-outputlen = 20.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MAT_DESC' .
  wa_fieldcat-seltext_l = 'Prod Material Description' .
  wa_fieldcat-col_pos = '19'.
  wa_fieldcat-outputlen = 100.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.
*  *********************added by jyoti on 11.10.2024**
  wa_fieldcat-fieldname = 'SL1' .
  wa_fieldcat-seltext_l = 'FG01' .
  wa_fieldcat-col_pos = '20'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL2' .
  wa_fieldcat-seltext_l = 'PRD1' .
  wa_fieldcat-col_pos = '21'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL4' .
  wa_fieldcat-seltext_l = 'RM01' .
  wa_fieldcat-col_pos = '22'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL5' .
  wa_fieldcat-seltext_l = 'RWK1' .
  wa_fieldcat-col_pos = '23'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL6' .
  wa_fieldcat-seltext_l = 'SC01' .
  wa_fieldcat-col_pos = '24'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL8' .
  wa_fieldcat-seltext_l = 'SFG1' .
  wa_fieldcat-col_pos = '25'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL9' .
  wa_fieldcat-seltext_l = 'STA1' .
  wa_fieldcat-col_pos = '26'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname = 'SL10' .
*  wa_fieldcat-seltext_l = 'SPC1' .
*  wa_fieldcat-col_pos = '27'.
*  wa_fieldcat-outputlen = 10.
*  APPEND wa_fieldcat TO it_fieldcat .
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL12' .
  wa_fieldcat-seltext_l = 'TPI1' .
  wa_fieldcat-col_pos = '28'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname = 'SL14' .
*  wa_fieldcat-seltext_l = 'TR01' .
*  wa_fieldcat-col_pos = '29'.
*  wa_fieldcat-outputlen = 10.
*  APPEND wa_fieldcat TO it_fieldcat .
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL15' .
  wa_fieldcat-seltext_l = 'PLG1' .
  wa_fieldcat-col_pos = '30'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL16' .
  wa_fieldcat-seltext_l = 'SAN1' .
  wa_fieldcat-col_pos = '31'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL17' .
  wa_fieldcat-seltext_l = 'MCN1' .
  wa_fieldcat-col_pos = '32'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL18' .
  wa_fieldcat-seltext_l = 'KFG0' .
  wa_fieldcat-col_pos = '33'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL19' .
  wa_fieldcat-seltext_l = 'KPRD' .
  wa_fieldcat-col_pos = '34'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL20' .
  wa_fieldcat-seltext_l = 'KRM0' .
  wa_fieldcat-col_pos = '35'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL21' .
  wa_fieldcat-seltext_l = 'KRWK' .
  wa_fieldcat-col_pos = '36'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL22' .
  wa_fieldcat-seltext_l = 'KSC0' .
  wa_fieldcat-col_pos = '37'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = 'SL24' .
  wa_fieldcat-seltext_l = 'KSFG' .
  wa_fieldcat-col_pos = '38'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname = 'SL25' .
*  wa_fieldcat-seltext_l = 'KSLR' .
*  wa_fieldcat-col_pos = '39'.
*  wa_fieldcat-outputlen = 10.
*  APPEND wa_fieldcat TO it_fieldcat .
*  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname = 'SL26' .
*  wa_fieldcat-seltext_l = 'KSPC' .
*  wa_fieldcat-col_pos = '40'.
*  wa_fieldcat-outputlen = 10.
*  APPEND wa_fieldcat TO it_fieldcat .
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL28' .
  wa_fieldcat-seltext_l = 'KTPI' .
  wa_fieldcat-col_pos = '41'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL30' .
  wa_fieldcat-seltext_l = 'KPR1' .
  wa_fieldcat-col_pos = '42'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL31' .
  wa_fieldcat-seltext_l = 'KMCN' .
  wa_fieldcat-col_pos = '43'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL32' .
  wa_fieldcat-seltext_l = 'KNDT' .
  wa_fieldcat-col_pos = '44'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL33' .
  wa_fieldcat-seltext_l = 'KPLG' .
  wa_fieldcat-col_pos = '45'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL34' .
  wa_fieldcat-seltext_l = 'KVLD' .
  wa_fieldcat-col_pos = '46'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL35' .
  wa_fieldcat-seltext_l = 'NDT1' .
  wa_fieldcat-col_pos = '47'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL36' .
  wa_fieldcat-seltext_l = 'PN01' .
  wa_fieldcat-col_pos = '48'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SL37' .
  wa_fieldcat-seltext_l = 'VLD1' .
  wa_fieldcat-col_pos = '49'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname = 'SHORT_QTY' .
  wa_fieldcat-seltext_l = 'Shortage Qty' .
  wa_fieldcat-col_pos = '43'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'KPR_QUALITY' . " add by supriya on 07.11.2024
  wa_fieldcat-seltext_l = 'Kpr Quality' .
  wa_fieldcat-col_pos = '50'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SHR_QUALITY' . " add by supriya on 07.11.2024
  wa_fieldcat-seltext_l = 'Shr Quality' .
  wa_fieldcat-col_pos = '51'.
  wa_fieldcat-outputlen = 10.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.


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

*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program = 'sy-repid'
*      it_fieldcat        = it_fieldcat
*    TABLES
*      t_outtab           = it_data.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = it_fieldcat
      i_default          = 'X'
      i_save             = 'A'
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
    TABLES
      t_outtab           = it_data
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
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

  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
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

  lv_file = 'ZREL_PROD_COMP.TXT'.

  CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

  WRITE: / 'ZREL_PROD_COMP.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_1521 TYPE string.
    DATA lv_crlf_1521 TYPE string.
    lv_crlf_1521 = cl_abap_char_utilities=>cr_lf.
    lv_string_1521 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_1521 lv_crlf_1521 wa_csv INTO lv_string_1521.
      CLEAR: wa_csv.
    ENDLOOP.
*TRANSFER lv_string_939 TO lv_fullfile.
*TRANSFER lv_string_502 TO lv_fullfile.
    TRANSFER lv_string_1521 TO lv_fullfile.
    CLOSE DATASET lv_fullfile.
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
FORM cvs_header  USING    p_hd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE   'Prod Order'
                'Prod Order Created Date'
                'Prod Order Qty'
                'Release Date'
                '1st Issue Date'
                'Req Quantity'
                'Issued Qty'
                'Shortage Qty'
                'Status'
                'Last Issue Date'
                'System Status'
                'Sales Order No'
                'SO Item'
*               'SO Qty'
                'Customer'
                'SO Material'
                'SO Material Description'
                'Prod Material'
                'Prod Material Description'
                'Component'
                'Component Description'
                'FG01'
                'PRD1'
                'RM01'
                'RWK1'
                'SC01'
                'SFG1'
                'STA1'
*                'SPC1'
                'TPI1'
*                'TR01'
                'PLG1'
                'SAN1'
                'MCN1'
                'KFG0'
                'KPRD'
                'KRM0'
                'KRWK'
                'KSC0'
                'KSFG'
*                'KSLR'
*                'KSPC'
                'KTPI'
                'KPR1'
                'KMCN'
                'KNDT'
                'KPLG'
                'KVLD'
                'NDT1'
                'PN01'
                'VLD1'
                'Kpr Quality'  " ADD BY SUPRIYA ON 07.11.2024
                'Shr Quality'  " ADD BY SUPRIYA ON 07.11.2024
                'Refreshable Date'
                'Refreshable Time'

               INTO p_hd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
