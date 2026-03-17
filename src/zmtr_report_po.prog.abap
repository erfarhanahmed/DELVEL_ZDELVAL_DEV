*&---------------------------------------------------------------------*
*& Report ZMTR_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmtr_report_po.

TYPE-POOLS: slis.
TABLES: vbak,kna1,afpo,vbap,afko,afru.

TYPES : BEGIN OF ty_aufk,
          aufnr TYPE aufk-aufnr,
          auart TYPE aufk-auart,
          erdat TYPE aufk-erdat,
        END OF ty_aufk,

        BEGIN OF ty_afko,
          aufnr TYPE afko-aufnr,
          gamng TYPE afko-gamng,
          rmanr TYPE afko-rmanr,
          gltri TYPE afko-gltri,
        END OF ty_afko,

        BEGIN OF ty_afpo,
          aufnr TYPE afpo-aufnr,
          wemng TYPE afpo-wemng,
          kdauf TYPE afpo-kdauf,
          kdpos TYPE afpo-kdpos,
        END OF ty_afpo,

        BEGIN OF ty_afru,
          aufnr TYPE afru-aufnr,
          budat TYPE afru-budat,
          rmzhl TYPE afru-rmzhl,
        END OF ty_afru,

        BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          aufnr TYPE vbak-aufnr,
          auart TYPE vbak-auart,
          kunnr TYPE vbak-kunnr,
          audat TYPE vbak-audat,
          vkbur TYPE vbak-vkbur,
        END OF ty_vbak,

        BEGIN OF ty_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
        END OF ty_vbap,

        BEGIN OF ty_vbkd,
          vbeln TYPE vbkd-vbeln,
          bstkd TYPE vbkd-bstkd,
          bstdk TYPE vbkd-bstdk,
        END OF ty_vbkd,

        BEGIN OF ty_mara,
          matnr   TYPE mara-matnr,
          brand   TYPE mara-brand,
          zsize   TYPE mara-zsize,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
          zseries TYPE mara-zseries,
        END OF ty_mara,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1,

        BEGIN OF ty_knmt,
          matnr TYPE knmt-matnr,
          kunnr TYPE knmt-kunnr,
          kdmat TYPE knmt-kdmat,
        END OF ty_knmt,

        BEGIN OF ty_mseg,
          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          bwart      TYPE mseg-bwart,
          werks      TYPE mseg-werks,
          sobkz      TYPE mseg-sobkz,
          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,
          kdauf      TYPE mseg-kdauf,
          kdpos      TYPE mseg-kdpos,
          budat_mkpf TYPE mseg-budat_mkpf,
        END OF ty_mseg,

        BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,
          bsart TYPE ekko-bsart,
          aedat TYPE ekko-aedat,
        END OF ty_ekko,

        BEGIN OF ty_ekpo,
          ebeln TYPE ekbe-ebeln,
          ebelp TYPE ekbe-ebelp,
          menge TYPE ekbe-menge,
        END OF ty_ekpo,

        BEGIN OF ty_ekbe,
          ebeln TYPE ekbe-ebeln,
          ebelp TYPE ekbe-ebelp,
          zekkn TYPE ekbe-zekkn,
          vgabe TYPE ekbe-vgabe,
          gjahr TYPE ekbe-gjahr,
          belnr TYPE ekbe-belnr,
          buzei TYPE ekbe-buzei,
          bwart TYPE ekbe-bwart,
          menge TYPE ekbe-menge,
        END OF ty_ekbe,

        BEGIN OF ty_final,
          aufnr        TYPE aufk-aufnr,
          auart        TYPE aufk-auart,
          erdat        TYPE char15,
          gamng        TYPE afko-gamng,
          rmanr        TYPE afko-rmanr,
          gltri        TYPE afko-gltri,
          wemng        TYPE afpo-wemng,
          kdauf        TYPE afpo-kdauf,
          kdpos        TYPE afpo-kdpos,
          budat        TYPE char15,
          vbeln        TYPE vbak-vbeln,
*          AUFNR TYPE VBAK-AUFNR,
          auart1       TYPE vbak-auart,
          kunnr        TYPE vbak-kunnr,
          audat        TYPE char15,
          vkbur        TYPE vbak-vkbur,
          posnr        TYPE vbap-posnr,
          matnr        TYPE vbap-matnr,
          bstkd        TYPE vbkd-bstkd,
          bstdk        TYPE vbkd-bstdk,
          brand        TYPE mara-brand,
          zsize        TYPE mara-zsize,
          moc          TYPE mara-moc,
          name1        TYPE kna1-name1,
          type         TYPE mara-type,
          zseries      TYPE mara-zseries,
          kdmat        TYPE knmt-kdmat,
          mattxt       TYPE text100,
          so_date(11)  TYPE c,
          doc_date(11) TYPE c,
          ref          TYPE char15,
          ebeln        TYPE mseg-ebeln,
        END OF ty_final.

TYPES: BEGIN OF str_final,
         auart   TYPE aufk-auart,
         aufnr   TYPE aufk-aufnr,
         erdat   TYPE char15,
         gamng   TYPE char17, "AFKO-GAMNG,
         wemng   TYPE char17, "AFPO-WEMNG,
         kunnr   TYPE vbak-kunnr,
         name1   TYPE kna1-name1,
         vkbur   TYPE vbak-vkbur,
         vbeln   TYPE vbak-vbeln,
         audat   TYPE char15,
         bstkd   TYPE vbkd-bstkd,
         kdpos   TYPE afpo-kdpos,
         kdmat   TYPE knmt-kdmat,
         matnr   TYPE vbap-matnr,
         mattxt  TYPE text100,
         brand   TYPE mara-brand,
         zsize   TYPE mara-zsize,
         moc     TYPE mara-moc,
         type    TYPE mara-type,
         zseries TYPE mara-zseries,
         budat   TYPE char15,
         ref     TYPE char15,
       END OF str_final.

DATA: it_aufk  TYPE TABLE OF ty_aufk,
      wa_aufk  TYPE          ty_aufk,

      it_afko  TYPE TABLE OF ty_afko,
      wa_afko  TYPE          ty_afko,

      it_afpo  TYPE TABLE OF ty_afpo,
      wa_afpo  TYPE          ty_afpo,

      it_afru  TYPE TABLE OF ty_afru,
      wa_afru  TYPE          ty_afru,

      it_vbak  TYPE TABLE OF ty_vbak,
      wa_vbak  TYPE          ty_vbak,

      it_vbak1 TYPE TABLE OF ty_vbak,
      wa_vbak1 TYPE          ty_vbak,

      it_vbap  TYPE TABLE OF ty_vbap,
      wa_vbap  TYPE          ty_vbap,

      it_vbap1 TYPE TABLE OF ty_vbap,
      wa_vbap1 TYPE          ty_vbap,

      it_vbkd  TYPE TABLE OF ty_vbkd,
      wa_vbkd  TYPE          ty_vbkd,

      it_vbkd1 TYPE TABLE OF ty_vbkd,
      wa_vbkd1 TYPE          ty_vbkd,

      it_kna1  TYPE TABLE OF ty_kna1,
      wa_kna1  TYPE          ty_kna1,

      lt_kna1  TYPE TABLE OF ty_kna1,
      ls_kna1  TYPE          ty_kna1,

      it_mara  TYPE TABLE OF ty_mara,
      wa_mara  TYPE          ty_mara,

      it_mara1  TYPE TABLE OF ty_mara,
      wa_mara1  TYPE          ty_mara,

      it_knmt  TYPE TABLE OF ty_knmt,
      wa_knmt  TYPE          ty_knmt,

      it_knmt1  TYPE TABLE OF ty_knmt,
      wa_knmt1  TYPE          ty_knmt,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final,

      lt_final TYPE TABLE OF str_final,
      ls_final TYPE          str_final,

      lt_mseg  TYPE TABLE OF ty_mseg,
      ls_mseg  TYPE          ty_mseg,

      lt_mseg1 TYPE TABLE OF ty_mseg,
      ls_mseg1 TYPE          ty_mseg,

      lt_ekko  TYPE TABLE OF ty_ekko,
      ls_ekko  TYPE          ty_ekko,

      lt_ekpo  TYPE TABLE OF ty_ekpo,
      ls_ekpo  TYPE          ty_ekpo,

      lt_ekbe  TYPE TABLE OF ty_ekbe,
      ls_ekbe  TYPE          ty_ekbe.


DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.


SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: "S_KUNNR FOR KNA1-KUNNR,
                "S_NAME1 FOR KNA1-NAME1,
               s_gltri FOR afru-budat.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT       '/Delval/India'."India'."temp'.             "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK b2.


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
  BREAK primus.

  SELECT aufnr
         budat
         rmzhl FROM afru INTO TABLE it_afru
         WHERE budat IN s_gltri.
  IF it_afru IS NOT INITIAL.
    SELECT aufnr
         gamng
         rmanr
         gltri FROM afko INTO TABLE it_afko
         FOR ALL ENTRIES IN it_afru
         WHERE aufnr = it_afru-aufnr.
  ENDIF.


  IF it_afko IS NOT INITIAL .

    SELECT aufnr
           wemng
           kdauf
           kdpos FROM afpo INTO TABLE it_afpo
           FOR ALL ENTRIES IN it_afko
           WHERE aufnr = it_afko-aufnr.
*         FOR ALL ENTRIES IN IT_VBAP
*         WHERE KDAUF = IT_VBAP-VBELN
*         AND   KDPOS = IT_VBAP-POSNR.


  ENDIF.

  IF it_afpo IS NOT INITIAL.
    SELECT aufnr
           auart
           erdat FROM aufk INTO TABLE it_aufk
           FOR ALL ENTRIES IN it_afpo
           WHERE aufnr = it_afpo-aufnr.

    SELECT vbeln
           posnr
           matnr FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_afpo
           WHERE vbeln = it_afpo-kdauf
           AND   posnr = it_afpo-kdpos.



  ENDIF.

  IF it_vbap IS NOT INITIAL .

    SELECT vbeln
           aufnr
           auart
           kunnr
           audat
           vkbur FROM vbak INTO TABLE it_vbak
           FOR ALL ENTRIES IN it_vbap
           WHERE vbeln = it_vbap-vbeln.

    SELECT vbeln
       bstkd
       bstdk FROM vbkd INTO TABLE it_vbkd
       FOR ALL ENTRIES IN it_vbap
       WHERE vbeln = it_vbap-vbeln.




    SELECT matnr
           brand
           zsize
           moc
           type
           zseries FROM mara INTO TABLE it_mara
           FOR ALL ENTRIES IN it_vbap
           WHERE matnr = it_vbap-matnr.


  ENDIF.

  IF it_vbak IS NOT INITIAL .

    SELECT kunnr
           name1 FROM kna1 INTO TABLE it_kna1
           FOR ALL ENTRIES IN it_vbak
           WHERE kunnr = it_vbak-kunnr.


  ENDIF.


  IF it_kna1 IS NOT INITIAL.

    SELECT matnr
           kunnr
           kdmat FROM knmt INTO TABLE it_knmt
           FOR ALL ENTRIES IN it_kna1
           WHERE kunnr = it_kna1-kunnr.

  ENDIF.

  SELECT mblnr
         mjahr
         zeile
         bwart
         werks
         sobkz
         ebeln
         ebelp
         kdauf
         kdpos
         budat_mkpf
     FROM mseg
     INTO TABLE lt_mseg
     WHERE budat_mkpf IN s_gltri AND
     bwart = '101' AND
     sobkz = 'E'   AND
     ebeln <> ' '  AND
     werks = 'PL01'.

  IF lt_mseg IS NOT INITIAL.

    SELECT ebeln
           bsart
           aedat
      FROM ekko
      INTO TABLE lt_ekko
      FOR ALL ENTRIES IN lt_mseg
      WHERE ebeln = lt_mseg-ebeln.

    SELECT ebeln
           ebelp
           menge
      FROM ekpo
      INTO TABLE lt_ekpo
      FOR ALL ENTRIES IN lt_mseg
      WHERE ebeln = lt_mseg-ebeln AND
            ebelp = lt_mseg-ebelp.


    SELECT ebeln
           ebelp
           zekkn
           vgabe
           gjahr
           belnr
           buzei
           bwart
           menge
      FROM ekbe
      INTO TABLE lt_ekbe
    FOR ALL ENTRIES IN lt_mseg
    WHERE ebeln = lt_mseg-ebeln AND
          ebelp = lt_mseg-ebelp AND
          bwart = '101'.

    SELECT vbeln
           posnr
           matnr
      FROM vbap
      INTO TABLE it_vbap1
      FOR ALL ENTRIES IN lt_mseg
    WHERE vbeln = lt_mseg-kdauf
    AND   posnr = lt_mseg-kdpos.
  ENDIF.

  IF it_vbap1 IS NOT INITIAL .

    SELECT vbeln
           aufnr
           auart
           kunnr
           audat
           vkbur
      FROM vbak
      INTO TABLE it_vbak1
      FOR ALL ENTRIES IN it_vbap1
      WHERE vbeln = it_vbap1-vbeln.

    SELECT vbeln
           bstkd
           bstdk
      FROM vbkd
      INTO TABLE it_vbkd1
      FOR ALL ENTRIES IN it_vbap1
      WHERE vbeln = it_vbap1-vbeln.

    SELECT matnr
           brand
           zsize
           moc
           type
           zseries
      FROM mara
      INTO TABLE it_mara1
      FOR ALL ENTRIES IN it_vbap1
      WHERE matnr = it_vbap1-matnr.

  ENDIF.


  IF it_vbak1 IS NOT INITIAL .

    SELECT kunnr
           name1
      FROM kna1
      INTO TABLE lt_kna1
    FOR ALL ENTRIES IN it_vbak1
    WHERE kunnr = it_vbak1-kunnr.

  ENDIF.


  IF lt_kna1 IS NOT INITIAL.

    SELECT matnr
           kunnr
           kdmat
      FROM knmt
      INTO TABLE it_knmt1
    FOR ALL ENTRIES IN lt_kna1
    WHERE kunnr = lt_kna1-kunnr.

  ENDIF.






  LOOP AT it_afpo INTO wa_afpo.
    wa_final-aufnr = wa_afpo-aufnr.
    wa_final-wemng = wa_afpo-wemng.
    wa_final-kdauf = wa_afpo-kdauf.
    wa_final-kdpos = wa_afpo-kdpos.

    READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_afpo-kdauf
                                             posnr = wa_afpo-kdpos.
    IF sy-subrc = 0.
      wa_final-vbeln =  wa_vbap-vbeln.
      wa_final-posnr =  wa_vbap-posnr.
      wa_final-matnr =  wa_vbap-matnr.

    ENDIF.


    READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln.
    IF sy-subrc = 0.
      wa_final-auart1  = wa_vbak-auart .
      wa_final-kunnr  = wa_vbak-kunnr .
*  WA_FINAL-AUDAT = WA_VBAK-AUDAT.
      wa_final-vkbur = wa_vbak-vkbur.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_vbak-audat
        IMPORTING
          output = wa_final-audat.

      CONCATENATE wa_final-audat+0(2) wa_final-audat+2(3) wa_final-audat+5(4)
                      INTO wa_final-audat SEPARATED BY '-'.

    ENDIF.

    READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_vbap-vbeln.
    IF sy-subrc = 0.
      wa_final-bstkd = wa_vbkd-bstkd.
      wa_final-bstdk = wa_vbkd-bstdk.

    ENDIF.

    READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_afpo-aufnr.
    IF sy-subrc = 0.
      wa_final-gamng = wa_afko-gamng.
      wa_final-gltri = wa_afko-gltri.
    ENDIF.

    READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_afpo-aufnr.
    IF sy-subrc = 0.
      wa_final-auart = wa_aufk-auart.
*   WA_FINAL-ERDAT = WA_AUFK-ERDAT.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_aufk-erdat
        IMPORTING
          output = wa_final-erdat.

      CONCATENATE wa_final-erdat+0(2) wa_final-erdat+2(3) wa_final-erdat+5(4)
                      INTO wa_final-erdat SEPARATED BY '-'.


    ENDIF.
*BREAK PRIMUS.
    SORT it_afru BY rmzhl DESCENDING.
    DELETE ADJACENT DUPLICATES FROM it_afru COMPARING aufnr.
    READ TABLE it_afru INTO wa_afru WITH KEY aufnr = wa_afpo-aufnr.
    IF  sy-subrc = 0.

*  WA_FINAL-BUDAT = WA_AFRU-BUDAT.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_afru-budat
        IMPORTING
          output = wa_final-budat.

      CONCATENATE wa_final-budat+0(2) wa_final-budat+2(3) wa_final-budat+5(4)
                      INTO wa_final-budat SEPARATED BY '-'.


    ENDIF.

*READ TABLE LT_MSEG INTO LS_MSEG WITH KEY BUDAT_MKPF = WA_AFRU-BUDAT.
* IF SY-SUBRC = 0.
*   WA_FINAL-EBELN = LS_MSEG-EBELN.
* ENDIF.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_kna1-name1.

    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_vbap-matnr.
    IF sy-subrc = 0.
      wa_final-matnr   = wa_mara-matnr .
      wa_final-brand   = wa_mara-brand .
      wa_final-zsize   = wa_mara-zsize .
      wa_final-moc     = wa_mara-moc   .
      wa_final-type    = wa_mara-type  .
      wa_final-zseries = wa_mara-zseries.
    ENDIF.

    READ TABLE it_knmt INTO wa_knmt WITH KEY kunnr = wa_kna1-kunnr matnr = wa_vbap-matnr.
    IF sy-subrc = 0.
      wa_final-kdmat = wa_knmt-kdmat.

    ENDIF.

    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_vbap-matnr.
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
    READ TABLE lv_lines INTO ls_mattxt INDEX 1.

    wa_final-mattxt = ls_mattxt-tdline.
*BREAK PRIMUS.


    wa_final-ref = sy-datum.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-ref
      IMPORTING
        output = wa_final-ref.

    CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
                    INTO wa_final-ref SEPARATED BY '-'.


    ls_final-auart    = wa_final-auart   .
    ls_final-aufnr    = wa_final-aufnr   .
    ls_final-erdat    = wa_final-erdat   .
    ls_final-gamng    = wa_final-gamng   .
    ls_final-wemng    = wa_final-wemng   .
    ls_final-kunnr    = wa_final-kunnr   .
    ls_final-name1    = wa_final-name1   .
    ls_final-vkbur    = wa_final-vkbur   .
    ls_final-vbeln    = wa_final-vbeln   .
    ls_final-audat    = wa_final-audat   .
    ls_final-bstkd    = wa_final-bstkd   .
    ls_final-kdpos    = wa_final-kdpos   .
    ls_final-kdmat    = wa_final-kdmat   .
    ls_final-matnr    = wa_final-matnr   .
    ls_final-mattxt   = wa_final-mattxt  .
    ls_final-brand    = wa_final-brand   .
    ls_final-zsize    = wa_final-zsize   .
    ls_final-moc      = wa_final-moc     .
    ls_final-type     = wa_final-type    .
    ls_final-zseries  = wa_final-zseries .
    ls_final-budat    = wa_final-budat   .
    ls_final-ref      = wa_final-ref     .

    IF wa_final-wemng IS NOT INITIAL.
      APPEND wa_final TO it_final.
      APPEND ls_final TO lt_final.
    ELSE.
      CLEAR wa_final.
    ENDIF.
*APPEND WA_FINAL TO IT_FINAL.

    CLEAR wa_final.
  ENDLOOP.

  CLEAR : ls_mseg,wa_final,ls_ekko,ls_ekpo,ls_ekbe,wa_vbak,wa_kna1,wa_vbkd,wa_vbap,wa_knmt,wa_mara.
  LOOP AT lt_mseg INTO ls_mseg.
    wa_final-aufnr = ls_mseg-ebeln.
    wa_final-vbeln = ls_mseg-kdauf.
    wa_final-kdpos = ls_mseg-kdpos.

    READ TABLE lt_ekko INTO ls_ekko WITH KEY ebeln = wa_final-aufnr.
    IF sy-subrc = 0.
      wa_final-auart = ls_ekko-bsart.
*      wa_final-erdat = ls_ekko-aedat.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_ekko-aedat
        IMPORTING
          output = wa_final-erdat.

      CONCATENATE wa_final-erdat+0(2) wa_final-erdat+2(3) wa_final-erdat+5(4)
      INTO wa_final-erdat SEPARATED BY '-'.
    ENDIF.

    READ TABLE lt_ekpo INTO ls_ekpo WITH KEY ebeln = wa_final-aufnr
                                             ebelp = ls_mseg-ebelp.
    IF  sy-subrc = 0.
      wa_final-gamng = ls_ekpo-menge.
    ENDIF.

    LOOP AT lt_ekbe INTO ls_ekbe WHERE ebeln = ls_mseg-ebeln AND
                                       ebelp = ls_mseg-ebelp.
      IF sy-subrc = 0.

        wa_final-wemng = wa_final-wemng + ls_ekbe-menge.

      ENDIF.

    ENDLOOP.

    READ TABLE it_vbak1 INTO wa_vbak1 WITH KEY vbeln = ls_mseg-kdauf.
    IF sy-subrc = 0.
      wa_final-kunnr  = wa_vbak1-kunnr.
      wa_final-vkbur = wa_vbak1-vkbur.
*      wa_final-audat = wa_vbak-audat.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_vbak1-audat
        IMPORTING
          output = wa_final-audat.

      CONCATENATE wa_final-audat+0(2) wa_final-audat+2(3) wa_final-audat+5(4)
      INTO wa_final-audat SEPARATED BY '-'.
    ENDIF.

    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = wa_final-kunnr.
    IF sy-subrc = 0.
      wa_final-name1 = ls_kna1-name1.
    ENDIF.

    READ TABLE it_vbkd1 INTO wa_vbkd1 WITH KEY vbeln = wa_final-vbeln.
    IF sy-subrc = 0.
      wa_final-bstkd = wa_vbkd1-bstkd.
    ENDIF.

    READ TABLE it_vbap1 INTO wa_vbap1 WITH KEY vbeln = wa_final-vbeln
                                               posnr = wa_final-kdpos.
    IF sy-subrc = 0.
      wa_final-matnr =  wa_vbap1-matnr.
    ENDIF.

    READ TABLE it_knmt1 INTO wa_knmt1 WITH KEY kunnr = wa_final-kunnr matnr = wa_final-matnr.
    IF sy-subrc = 0.
      wa_final-kdmat = wa_knmt1-kdmat.

    ENDIF.

    READ TABLE it_mara1 INTO wa_mara1 WITH KEY matnr = wa_final-matnr.
    IF sy-subrc = 0.
*      wa_final-matnr   = wa_mara-matnr .
      wa_final-brand   = wa_mara1-brand .
      wa_final-zsize   = wa_mara1-zsize .
      wa_final-moc     = wa_mara1-moc   .
      wa_final-type    = wa_mara1-type  .
      wa_final-zseries = wa_mara1-zseries.
    ENDIF.

    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_vbap1-matnr.
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
    READ TABLE lv_lines INTO ls_mattxt INDEX 1.

    wa_final-mattxt = ls_mattxt-tdline.


    lt_mseg1[] = lt_mseg.
    SORT lt_mseg1 DESCENDING BY budat_mkpf.

    LOOP AT lt_mseg1 INTO ls_mseg1 WHERE kdauf = wa_final-vbeln AND
                                       kdpos = wa_final-kdpos AND
                                       ebeln = wa_final-aufnr AND
                                       ebelp = ls_mseg-ebelp.


      wa_final-budat = ls_mseg1-budat_mkpf.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-budat
      IMPORTING
        output = wa_final-budat.

    CONCATENATE wa_final-budat+0(2) wa_final-budat+2(3) wa_final-budat+5(4)
    INTO wa_final-budat SEPARATED BY '-'.

    ENDLOOP.

    wa_final-ref = sy-datum.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-ref
      IMPORTING
        output = wa_final-ref.

    CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
    INTO wa_final-ref SEPARATED BY '-'.

    ls_final-auart    = wa_final-auart   .
    ls_final-aufnr    = wa_final-aufnr   .
    ls_final-erdat    = wa_final-erdat   .
    ls_final-gamng    = wa_final-gamng   .
    ls_final-wemng    = wa_final-wemng   .
    ls_final-kunnr    = wa_final-kunnr   .
    ls_final-name1    = wa_final-name1   .
    ls_final-vkbur    = wa_final-vkbur   .
    ls_final-vbeln    = wa_final-vbeln   .
    ls_final-audat    = wa_final-audat   .
    ls_final-bstkd    = wa_final-bstkd   .
    ls_final-kdpos    = wa_final-kdpos   .
    ls_final-kdmat    = wa_final-kdmat   .
    ls_final-matnr    = wa_final-matnr   .
    ls_final-mattxt   = wa_final-mattxt  .
    ls_final-brand    = wa_final-brand   .
    ls_final-zsize    = wa_final-zsize   .
    ls_final-moc      = wa_final-moc     .
    ls_final-type     = wa_final-type    .
    ls_final-zseries  = wa_final-zseries .
    ls_final-budat    = wa_final-budat   .
    ls_final-ref      = wa_final-ref     .


    APPEND wa_final TO it_final.
    APPEND ls_final TO lt_final.
    CLEAR wa_final.
    CLEAR ls_final.
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



  PERFORM fcat USING : '1'  'AUART'   'IT_FINAL'  'DOC CODE'           '18' ,
                       '2'  'AUFNR'   'IT_FINAL'  'VW_APM_DOC_NO'      '18',
                       '3'  'ERDAT'   'IT_FINAL'  'VW_APM_DOC_DATE'    '18' ,
                       '4'  'GAMNG'   'IT_FINAL'  'VW_APM_QTY'         '18' ,
                       '5'  'WEMNG'   'IT_FINAL'  'VW_APM_DEL_QTY'     '18',
                       '6'  'KUNNR'   'IT_FINAL'  'VW_PARTY_CODE'      '18',
                       '7'  'NAME1'   'IT_FINAL'  'VW_PARTY_NAME'      '25',
                       '8'  'VKBUR'  'IT_FINAL'   'VW_SO_DOC_CODE'     '15',
                       '9'  'VBELN'   'IT_FINAL'  'VW_SO_DOC_NO'       '18',
                      '10'  'AUDAT'   'IT_FINAL'  'VW_SO_DOC_DATE'     '18',
                      '11'  'BSTKD'   'IT_FINAL'  'VW_REF_PO_NO'       '18',
                      '12'  'KDPOS'   'IT_FINAL'  'VW_SO_SR_NO'        '18',
                      '13'  'KDMAT'   'IT_FINAL'  'VW_USER_ITEM_DESC'  '25',
                      '14'  'MATNR'   'IT_FINAL'  'VW_ITEM_CODE'       '18',
                      '15'  'MATTXT'  'IT_FINAL'  'VW_ITEM_DESC'       '50',
                      '16'  'BRAND'   'IT_FINAL'  'VW_BRAND'           '18',
                      '17'  'ZSIZE'   'IT_FINAL'  'VW_SIZE'            '18',
                      '18'  'MOC'     'IT_FINAL'  'VW_MOC'             '15',
                      '19'  'TYPE'    'IT_FINAL'  'VW_TYPE'            '15',
                      '20'  'ZSERIES' 'IT_FINAL'  'VW_SERIES'          '15',
                      '21'  'BUDAT'   'IT_FINAL'  'CONFIRMATION DATE'  '15',
                      '22'  'REF'     'IT_FINAL'  'Refresh DATE'       '15'.
*                    '23'  'EBELN'   'IT_FINAL'  'Purchase Order'     '15'.





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
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0731   text
*      -->P_0732   text
*      -->P_0733   text
*      -->P_0734   text
*      -->P_0735   text
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
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
ENDFORM.

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
  BREAK primus.
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
  lv_file = 'ZMTR1.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZMTR1 Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1048 TYPE string.
DATA lv_crlf_1048 TYPE string.
lv_crlf_1048 = cl_abap_char_utilities=>cr_lf.
lv_string_1048 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1048 lv_crlf_1048 wa_csv INTO lv_string_1048.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1048 TO lv_fullfile.
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
  CONCATENATE 'DOC CODE'
              'VW_APM_DOC_NO'
              'VW_APM_DOC_DATE'
              'VW_APM_QTY'
              'VW_APM_DEL_QTY'
              'VW_PARTY_CODE'
              'VW_PARTY_NAME'
              'VW_SO_DOC_CODE'
              'VW_SO_DOC_NO'
              'VW_SO_DOC_DATE'
              'VW_REF_PO_NO'
              'VW_SO_SR_NO'
              'VW_USER_ITEM_DESC'
              'VW_ITEM_CODE'
              'VW_ITEM_DESC'
              'VW_BRAND'
              'VW_SIZE'
              'VW_MOC'
              'VW_TYPE'
              'VW_SERIES'
              'CONFIRMATION DATE'
              'Refresh DATE'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
