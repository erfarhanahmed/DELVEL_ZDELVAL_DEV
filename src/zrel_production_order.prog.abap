**-----------------------------------------------*
REPORT zrel_production_order.
TABLES : afko , caufv , mseg ,vbap .

**&---------------------------------------------------------------------*
**& Types / structure
**&---------------------------------------------------------------------*
TYPES : BEGIN OF str_caufv,
          aufnr TYPE caufv-aufnr,
          erdat TYPE caufv-erdat,
        END OF str_caufv.

TYPES : BEGIN OF tY_cust,
          vbeln TYPE vbak-vbeln,
          kunnr TYPE vbak-kunnr,
          name1 TYPE kna1-name1,
        END OF tY_cust.

TYPES : BEGIN OF str_gt,
*          vbeln  TYPE  vbeln,
*          posnr  TYPE  posnr,
*          matnr  TYPE  matnr,
*          werks  TYPE  werks,
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
        END OF str_resb.

TYPES : BEGIN OF str_resb1,
          aufnr TYPE resb-aufnr,
          bdmng TYPE resb-bdmng,
          enmng TYPE resb-enmng,
        END OF str_resb1.

DATA : it_caufv1 TYPE TABLE OF str_resb1,
       wa_caufv1 TYPE str_resb1.

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
        END OF str_data.

TYPES : BEGIN OF str_down,
          aufnr            TYPE caufv-aufnr,
          erdat            TYPE string,                                "caufv-erdat,
          gamng            TYPE string,
          ftrmi            TYPE string,                                 "afko-ftrmi,
          first_issue_date TYPE string,                                     "mseg-budat_mkpf,
          bdmng            TYPE string,                                    "resb-bdmng,
          enmng            TYPE string,                                            "resb-enmng,
          status           TYPE char20,
          last_issue_date  TYPE string,                                       "mseg-budat_mkpf,
          txt04            TYPE string,
          kdauf            TYPE aufk-kdauf,
          kdpos            TYPE aufk-kdpos,
*          kwmeng           TYPE string,
          name1            TYPE string,
          matnr            TYPE string,
          mat_desc1        TYPE string,
          stlbez           TYPE string,
          mat_desc         TYPE string,
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

DATA : it_cUST TYPE TABLE OF tY_cust,
       wa_cUST TYPE tY_cust.

DATA : it_afko TYPE TABLE OF str_afko,
       wa_afko TYPE str_afko.

DATA : it_aufk_n TYPE TABLE OF str_aufk_n,
       wa_aufk_n TYPE str_aufk_n.

DATA : it_mseg TYPE TABLE OF str_mseg,
       wa_mseg TYPE str_mseg.

DATA : it_resb TYPE TABLE OF str_resb,
       wa_resb TYPE str_resb.

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
  PARAMETERS p_folder TYPE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp' .   "'/Delval/India'."temp'.
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

  SELECT a~vbeln
         a~posnr
         a~matnr
         a~werks
         d~edatu
         d~wmeng
         d~etenr
         c~lfsta
         f~aufnr
         a~kwmeng
          INTO TABLE gt_main
          FROM vbap AS a
*          JOIN vbup AS c ON c~vbeln = a~vbeln
          JOIN vbap AS c ON c~vbeln = a~vbeln
                        AND c~posnr = a~posnr
          JOIN vbep AS d ON a~vbeln = d~vbeln
                        AND a~posnr = d~posnr
          JOIN afpo AS f ON a~vbeln = f~kdauf
                        AND a~posnr = f~kdpos
          WHERE a~vbeln IN s_vbeln
            AND a~werks =  p_werks
            AND c~lfsta NE 'C'
            AND c~gbsta NE 'C'
*            AND c~fksta NE 'C'
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
         enmng FROM resb
         INTO TABLE it_resb
         FOR ALL ENTRIES IN gt_main
         WHERE aufnr = gt_main-aufnr
         AND bwart = '261'
         AND xloek NE 'X' ." added by sagar darade on 16/03/2026 to remove record

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


  LOOP AT gt_main INTO wa_main .
    wa_data-aufnr  = wa_main-aufnr.
    wa_data-kdauf  = wa_main-vbeln.
    wa_data-kdpos  = wa_main-posnr.
    wa_data-kwmeng = wa_main-kwmeng.
    wa_data-matnr  = wa_main-matnr.

    """"""""""""""""""""""""""""""""""""""""""""
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
          CONCATENATE wa_data-mat_desc1 wa_lines-tdline INTO wa_data-mat_desc1 SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_data-mat_desc1.
    ENDIF.
    """"""""""""""""""""""""""""""""""""""""""""
    READ TABLE it_aufk_n INTO wa_aufk_n WITH KEY aufnr = wa_main-aufnr .
    IF sy-subrc = 0.
      wa_data-erdat = wa_aufk_n-erdat.
    ENDIF.

    READ TABLE it_caufv1 INTO wa_caufv1 WITH KEY aufnr = wa_main-aufnr .
    IF sy-subrc = 0.
      wa_caufv1-bdmng = wa_caufv1-bdmng + wa_resb-bdmng.
    ENDIF.

    READ TABLE it_caufv1 INTO wa_caufv1 WITH KEY aufnr = wa_main-aufnr .
    IF sy-subrc = 0.
      wa_caufv1-enmng = wa_caufv1-enmng + wa_resb-enmng.
    ENDIF.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    LOOP AT it_resb INTO wa_resb WHERE aufnr =  wa_main-aufnr .
      wa_caufv1-bdmng = wa_caufv1-bdmng + wa_resb-bdmng.
      wa_caufv1-enmng = wa_caufv1-enmng + wa_resb-enmng.
    ENDLOOP.

    IF wa_caufv1-enmng = 0.
      wa_data-status = 'NOT ISSUED'.
    ELSEIF wa_caufv1-bdmng - wa_caufv1-enmng NE 0.
      wa_data-status = 'PARTIAL ISSUED'.
    ELSEIF wa_caufv1-bdmng - wa_caufv1-enmng = 0.
      wa_data-status = 'COMPLETE ISSUED'.
    ENDIF.

    IF wa_caufv1-enmng GE wa_caufv1-bdmng.
      CLEAR : wa_data-status.
      wa_data-status = 'COMPLETE ISSUED'.
    ENDIF.

    wa_data-bdmng = wa_caufv1-bdmng.
    wa_data-enmng = wa_caufv1-enmng.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_main-aufnr .
    IF sy-subrc = 0.
      wa_data-ftrmi  = wa_afko-ftrmi.
      wa_data-gamng  = wa_afko-gamng.
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

    READ TABLE it_mseg INTO wa_mseg WITH KEY aufnr = wa_main-aufnr .
    IF sy-subrc = 0.
      wa_data-budat_mkpf = wa_mseg-budat_mkpf.
    ENDIF.

    IF wa_data-status NE 'NOT ISSUED'.
      READ TABLE  it_mseg_temp INTO DATA(ls_mseg_temp) WITH KEY aufnr = wa_main-aufnr .
      IF sy-subrc = 0.
        wa_data-first_issue_date = ls_mseg_temp-budat_mkpf.
      ENDIF.

      READ TABLE  it_mseg_temp1 INTO DATA(ls_mseg_temp1) WITH KEY aufnr = wa_main-aufnr .
      IF sy-subrc = 0.
        wa_data-last_issue_date = ls_mseg_temp1-budat_mkpf.
      ENDIF.
    ENDIF.
    READ TABLE it_caufv_new INTO DATA(wa_caufv_new) WITH KEY aufnr = wa_main-aufnr .
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

    READ TABLE it_caufv1 INTO wa_caufv1 WITH KEY aufnr = wa_main-aufnr.
    IF  sy-subrc = 0.
      wa_data-bdmng = wa_caufv1-bdmng.
      wa_data-enmng = wa_caufv1-enmng.
    ENDIF.

    wa_data-aufnr = wa_data-aufnr+4(8).
    wa_data-kdauf = wa_data-kdauf+2(8).

    READ TABLE it_cust INTO wa_cust WITH KEY vbeln = wa_main-vbeln.
    IF sy-subrc = 0.
      wa_data-name1 = wa_cust-name1.
    ENDIF.

    IF  wa_data-enmng EQ 0.
      READ TABLE it_jest INTO DATA(wa_jest) WITH KEY objnr = wa_main-objnr.
      IF sy-subrc = 0.
        DATA(flag) = 'X'.
      ENDIF.
    ENDIF.

    IF flag NE 'X'.
      APPEND wa_data TO it_data.
    ENDIF.

    CLEAR :wa_data,wa_caufv1,flag.
  ENDLOOP.
  SORT it_data.
  DELETE ADJACENT DUPLICATES FROM it_data COMPARING aufnr kdauf kdpos.
  DELETE ADJACENT DUPLICATES FROM it_data COMPARING ALL FIELDS.

  IF p_down = 'X'.

    LOOP AT it_data INTO wa_data.
      wa_down-aufnr               =    wa_data-aufnr                 .
      wa_down-erdat               =    wa_data-erdat                 .
*      wa_down-kwmeng              =    wa_data-kwmeng                 .
      wa_down-gamng               =    wa_data-gamng                 .

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

  wa_fieldcat-fieldname = 'BDMNG' .
  wa_fieldcat-seltext_m = 'Req Quantity' .
  wa_fieldcat-col_pos = '6'.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ENMNG' .
  wa_fieldcat-seltext_m = 'Issued Qty' .
  wa_fieldcat-col_pos = '7'.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'STATUS' .
  wa_fieldcat-seltext_m = 'Status' .
  wa_fieldcat-col_pos = '8'.
  wa_fieldcat-outputlen = 15.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'LAST_ISSUE_DATE' .
  wa_fieldcat-seltext_m = 'Last Issue Date' .
  wa_fieldcat-col_pos = '9'.
  wa_fieldcat-outputlen = 12.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname = 'TXT04' .
  wa_fieldcat-seltext_m = 'System Status' .
  wa_fieldcat-col_pos = '10'.
  wa_fieldcat-outputlen = 25.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'KDAUF' .
  wa_fieldcat-seltext_m = 'SO No' .
  wa_fieldcat-col_pos = '11'.
  wa_fieldcat-outputlen = 8.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'KDPOS' .
  wa_fieldcat-seltext_m = 'SO Item' .
  wa_fieldcat-col_pos = '12'.
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
  wa_fieldcat-col_pos = '13'.
  wa_fieldcat-outputlen = 25.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR' .
  wa_fieldcat-seltext_m = 'SO Material' .
  wa_fieldcat-col_pos = '14'.
  wa_fieldcat-outputlen = 20.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MAT_DESC1' .
  wa_fieldcat-seltext_l = 'SO Material Description' .
  wa_fieldcat-col_pos = '15'.
  wa_fieldcat-outputlen = 100.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'STLBEZ' .
  wa_fieldcat-seltext_m = 'Prod Material Code'.
  wa_fieldcat-col_pos = '16'.
  wa_fieldcat-outputlen = 20.
  APPEND wa_fieldcat TO it_fieldcat .
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MAT_DESC' .
  wa_fieldcat-seltext_L = 'Prod Material Description' .
  wa_fieldcat-col_pos = '17'.
  wa_fieldcat-outputlen = 100.
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

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = 'sy-repid'
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_data.
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

  lv_file = 'ZREL_PROD.TXT'.

  CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

  WRITE: / 'ZREL_PROD.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_830 TYPE string.
    DATA lv_crlf_830 TYPE string.
    lv_crlf_830 = cl_abap_char_utilities=>cr_lf.
    lv_string_830 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_830 lv_crlf_830 wa_csv INTO lv_string_830.
      CLEAR: wa_csv.
    ENDLOOP.
*TRANSFER lv_string_2199 TO lv_fullfile.
    TRANSFER lv_string_830 TO lv_fullfile.
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
                'Status'
                'Last Issue Date'
                'System Status'
                'Sales Order No'
                'SO Item'
*                'SO Qty'
                'Customer'
                'SO Material'
                'SO Material Description'
                'Prod Material'
                'Prod Material Description'
                'Refreshable Date'
                'Refreshable Time'

               INTO p_hd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
