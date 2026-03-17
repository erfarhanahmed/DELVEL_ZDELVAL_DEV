*&---------------------------------------------------------------------*
*& Report ZINVOICE_DETAILS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinvoice_details.

TABLES : vbap,vbak,vbfa,afru,afpo,kna1,qals,qave,mara.

TYPE-POOLS : slis,
             ole2.

TYPES : BEGIN OF ty_join,
          vbelv       TYPE vbfa-vbelv,
          posnv       TYPE vbfa-posnv,
          vbeln       TYPE vbap-vbeln,
          posnn       TYPE vbfa-posnn,
          vbtyp_n     TYPE vbfa-vbtyp_n,
          posnr       TYPE vbap-posnr,
          matnr       TYPE vbap-matnr,
          werks       TYPE vbap-werks,
          custdeldate TYPE vbap-custdeldate,
          netpr       TYPE vbap-netpr,
          netwr       TYPE vbap-netwr,
          kunnr       TYPE vbak-kunnr,
          aufnr       TYPE afpo-aufnr,
          kdauf       TYPE afpo-kdauf,
          kdpos       TYPE afpo-kdpos,
        END OF ty_join.

TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          audat TYPE vbak-audat,
          vkbur TYPE vbak-vkbur,
        END OF ty_vbak.

TYPES : BEGIN OF ty_vbrp,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          vbelv TYPE vbrp-vbelv,
          posnv TYPE vbrp-posnv,
          erdat TYPE vbrp-erdat,
          arktx TYPE vbrp-arktx,
          fkimg TYPE vbrp-fkimg,
          kursk TYPE vbrp-kursk,
        END OF ty_vbrp.

TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
          fktyp TYPE vbrk-fktyp,
          vbtyp TYPE vbrk-vbtyp,
          vkorg TYPE vbrk-vkorg,
          vtweg TYPE vbrk-vtweg,
          waerk TYPE vbrk-waerk,
          ktgrd TYPE vbrk-ktgrd,
        END OF ty_vbrk.

TYPES : BEGIN OF ty_vbpa,
        vbeln TYPE vbpa-vbeln,
        kunnr TYPE vbpa-kunnr ,
        parvw TYPE vbpa-parvw ,
        END OF ty_vbpa.


TYPES : BEGIN OF ty_afpo,
          aufnr TYPE afpo-aufnr,
          posnr TYPE afpo-posnr,
          kdauf TYPE afpo-kdauf,
          kdpos TYPE afpo-kdpos,
        END OF ty_afpo.

TYPES : BEGIN OF ty_afru,
          rueck TYPE afru-rueck,
          rmzhl TYPE afru-rmzhl,
          budat TYPE afru-budat,
          werks TYPE afru-werks,
          aufnr TYPE afru-aufnr,
        END OF ty_afru.

TYPES : BEGIN OF ty_qals,
          prueflos TYPE qals-prueflos,
          werk     TYPE qals-werk,
          selmatnr TYPE qals-selmatnr,
          aufnr    TYPE qals-aufnr,
        END OF ty_qals.

TYPES : BEGIN OF ty_qave,
          prueflos TYPE qave-prueflos,
          kzart    TYPE qave-kzart,
          zaehler  TYPE qave-zaehler,
          vdatum   TYPE qave-vdatum,
        END OF ty_qave.

TYPES : BEGIN OF ty_mara,
          matnr   TYPE mara-matnr,
          zseries TYPE mara-zseries,
          zsize   TYPE mara-zsize,
          brand   TYPE mara-brand,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
        END OF ty_mara,


        BEGIN OF ty_vbep,
          vbeln TYPE vbep-vbeln,
          posnr TYPE vbep-posnr,
          etenr TYPE vbep-etenr,
          ettyp TYPE vbep-ettyp,
          edatu TYPE vbep-edatu,
        END OF ty_vbep.


TYPES : BEGIN OF ty_final,
          vbelv       TYPE vbap-vbeln,
          posnv       TYPE vbap-posnr,
          matnr       TYPE vbap-matnr,
          werks       TYPE vbap-werks,
          custdeldate TYPE vbap-custdeldate,
          kunnr       TYPE vbak-kunnr,
          vbtyp_n     TYPE vbfa-vbtyp_n,
          name1       TYPE kna1-name1,
          vbeln1      TYPE vbrp-vbeln,
          erdat       TYPE vbrp-erdat,
          edatu       TYPE vbep-edatu,
          mrp_dt      TYPE vbep-edatu,
          aufnr       TYPE afpo-aufnr,
          budat       TYPE afru-budat,
          prueflos    TYPE qals-prueflos,
          vdatum      TYPE qave-vdatum,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          brand       TYPE mara-brand,
          moc         TYPE mara-moc,
          type        TYPE mara-type,
          vkbur       TYPE vbak-vkbur,
          audat       TYPE vbak-audat,
          arktx       TYPE vbrp-arktx,
          fkimg       TYPE vbrp-fkimg,
          waerk       TYPE vbrk-waerk,
          kursk       TYPE vbrp-kursk,
          vtext       TYPE tvktt-vtext,
*          ld_tg       TYPE char20,
          ship        TYPE kna1-kunnr,
          ship_nm     TYPE kna1-name1,
          gbstk       TYPE vbuk-gbstk,
          bstkd       TYPE vbkd-bstkd,
          netpr       TYPE vbap-netpr,
          netwr       TYPE vbap-netwr,
        END OF ty_final.

TYPES : BEGIN OF ty_ref,
          vbelv       TYPE vbap-vbeln,
          name1       TYPE kna1-name1,
          posnv       TYPE vbap-posnr,
          matnr       TYPE vbap-matnr,
          vbeln1      TYPE vbrp-vbeln,
          erdat       TYPE char15,
          aufnr       TYPE afpo-aufnr,
          budat       TYPE char15,
          vdatum      TYPE char15,
          custdeldate TYPE char15,
          edatu       TYPE char15,
          mrp_dt      TYPE char15,
          brand       TYPE mara-brand,
          zseries     TYPE mara-zseries,
          zsize       TYPE mara-zsize,
          moc         TYPE mara-moc,
          type        TYPE mara-type,
          vkbur       TYPE vbak-vkbur,
          audat       TYPE char15,
          arktx       TYPE vbrp-arktx,
          fkimg       TYPE char15,
          waerk       TYPE vbrk-waerk,
          kursk       TYPE char15,
          vtext       TYPE tvktt-vtext,
          ship        TYPE kna1-kunnr,
          ship_nm     TYPE kna1-name1,
          gbstk       TYPE vbuk-gbstk,
          bstkd       TYPE vbkd-bstkd,
          netpr       TYPE char15,
          netwr       TYPE char15,
          sdate       TYPE char15,
        END OF ty_ref.

DATA:
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline.

DATA : lt_join  TYPE STANDARD TABLE OF ty_join,
       ls_join  TYPE                   ty_join,
       lt_vbak  TYPE TABLE OF          ty_vbak,
       ls_vbak  TYPE                   ty_vbak,
       lt_vbrk  TYPE TABLE OF          ty_vbrk,
       ls_vbrk  TYPE                   ty_vbrk,
       lt_vbpa  TYPE TABLE OF          ty_vbpa,
       ls_vbpa  TYPE                   ty_vbpa,
       lt_kna1  TYPE STANDARD TABLE OF ty_kna1,
       ls_kna1  TYPE                   ty_kna1,
       lt_vbrp  TYPE STANDARD TABLE OF ty_vbrp,
       ls_vbrp  TYPE                   ty_vbrp,
       lt_afpo  TYPE STANDARD TABLE OF ty_afpo,
       ls_afpo  TYPE                   ty_afpo,
       lt_afru  TYPE STANDARD TABLE OF ty_afru,
       ls_afru  TYPE                   ty_afru,
       lt_qals  TYPE STANDARD TABLE OF ty_qals,
       ls_qals  TYPE                   ty_qals,
       lt_qave  TYPE STANDARD TABLE OF ty_qave,
       ls_qave  TYPE                   ty_qave,
       lt_mara  TYPE STANDARD TABLE OF ty_mara,
       ls_mara  TYPE                   ty_mara,
       lt_final TYPE STANDARD TABLE OF ty_final,
       ls_final TYPE                   ty_final,
       lt_ref   TYPE STANDARD TABLE OF ty_ref,
       ls_ref   TYPE                   ty_ref,
       it_vbep  TYPE TABLE OF ty_vbep,
       wa_vbep  TYPE ty_vbep,
       lt_vbep  TYPE TABLE OF ty_vbep,
       ls_vbep  TYPE ty_vbep,

       it_cdhdr TYPE STANDARD TABLE OF cdhdr,
       wa_cdhdr TYPE cdhdr,
       it_cdpos TYPE STANDARD TABLE OF cdpos,
       wa_cdpos TYPE cdpos.

DATA : lt_fcat TYPE slis_t_fieldcat_alv,
       ls_fcat TYPE slis_fieldcat_alv.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
SELECT-OPTIONS : svbeln    FOR vbap-vbeln,
                 skunnr    FOR vbak-kunnr.
PARAMETERS     : p_werks   TYPE vbap-werks OBLIGATORY DEFAULT 'PL01'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE abc .
PARAMETERS : p_down   AS CHECKBOX,
             p_folder TYPE rlgrap-filename DEFAULT   '/delval/temp'.         "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_folder.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
    IMPORTING
      file_name     = p_folder.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM sort_data.
  PERFORM fieldcat.

END-OF-SELECTION.

  PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .


  SELECT a~vbelv
         a~posnv
         a~vbeln
         a~posnn
         a~vbtyp_n
         b~posnr
         b~matnr
         b~werks
         b~custdeldate
         b~netpr
         b~netwr
         c~kunnr
         d~aufnr
         d~kdauf
         d~kdpos
         FROM vbfa AS a
         JOIN vbap AS b ON ( b~vbeln = a~vbelv AND b~posnr = a~posnv )
         JOIN vbak AS c ON c~vbeln = a~vbelv
         JOIN afpo AS d ON ( d~kdauf = a~vbelv AND d~kdpos = a~posnv AND d~matnr = b~matnr )
         INTO TABLE lt_join
         WHERE a~vbelv IN svbeln AND
               b~werks = p_werks AND
               c~kunnr IN skunnr AND
               a~vbtyp_n = 'M'.

  IF lt_join IS NOT INITIAL.

    SELECT vbeln
           audat
           vkbur FROM vbak INTO TABLE lt_vbak
           FOR ALL ENTRIES IN lt_join
           WHERE vbeln = lt_join-vbelv.

    SELECT vbeln
           kunnr
           parvw
        FROM vbpa
        INTO TABLE lt_vbpa
        FOR ALL ENTRIES IN lt_join
        WHERE vbeln = lt_join-vbelv
        AND   parvw IN ('SH','WE').


    SELECT kunnr
           name1
           FROM kna1
           INTO TABLE lt_kna1
           FOR ALL ENTRIES IN lt_join
           WHERE kunnr = lt_join-kunnr.


    SELECT vbeln
           posnr
           vbelv
           posnv
           erdat
           arktx
           fkimg
           kursk
           FROM vbrp
           INTO TABLE lt_vbrp
           FOR ALL ENTRIES IN lt_join
           WHERE vbelv = lt_join-vbelv AND
                 posnv = lt_join-posnv.



    SELECT rueck
           rmzhl
           budat
           werks
           aufnr
           FROM afru
           INTO TABLE lt_afru
           FOR ALL ENTRIES IN lt_join
           WHERE aufnr = lt_join-aufnr.


    SELECT vbeln
           posnr
           etenr
           ettyp
           edatu
           FROM vbep INTO TABLE it_vbep
           FOR ALL ENTRIES IN lt_join WHERE vbeln = lt_join-vbelv
                                       AND  posnr = lt_join-posnv.

    SORT it_vbep BY vbeln posnr etenr.

    SELECT vbeln
           posnr
           etenr
           ettyp
           edatu
           FROM vbep INTO TABLE lt_vbep
           FOR ALL ENTRIES IN lt_join WHERE vbeln = lt_join-vbelv
                                       AND  posnr = lt_join-posnv
                                       AND  etenr = '0001'
                                       AND  ettyp = 'CP'.

    SORT lt_vbep BY vbeln posnr etenr.


*    SELECT aufnr
*           posnr
*           kdauf
*           kdpos
*           FROM afpo
*           INTO TABLE lt_afpo
*           FOR ALL ENTRIES IN lt_join
*           WHERE kdauf = lt_join-vbelv AND
*                 kdpos = lt_join-posnv.
  ENDIF.

*  IF lt_afpo IS NOT INITIAL.
*
*  ENDIF.

  IF lt_vbrp IS NOT INITIAL.
    SELECT vbeln
           fkart
           fktyp
           vbtyp
           vkorg
           vtweg
           waerk
           ktgrd FROM vbrk INTO TABLE lt_vbrk
           FOR ALL ENTRIES IN lt_vbrp
           WHERE vbeln = lt_vbrp-vbeln.



  ENDIF.

  IF lt_afru IS NOT INITIAL.

    SELECT prueflos
           werk
           selmatnr
           aufnr
           FROM qals
           INTO TABLE lt_qals
           FOR ALL ENTRIES IN lt_afru
           WHERE werk = lt_afru-werks AND
                 aufnr = lt_afru-aufnr.

  ENDIF.

  IF lt_qals IS NOT INITIAL.

    SELECT prueflos
           kzart
           zaehler
           vdatum
           FROM qave
           INTO TABLE lt_qave
           FOR ALL ENTRIES IN lt_qals
           WHERE prueflos = lt_qals-prueflos.

    SELECT matnr
           zseries
           zsize
           brand
           moc
           type
           FROM mara
           INTO TABLE lt_mara
           FOR ALL ENTRIES IN lt_qals
           WHERE matnr = lt_qals-selmatnr.

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


  LOOP AT lt_join INTO ls_join.
    ls_final-vbelv       = ls_join-vbelv.
    ls_final-posnv       = ls_join-posnv.
    ls_final-matnr       = ls_join-matnr.
    ls_final-custdeldate = ls_join-custdeldate.
    ls_final-aufnr       = ls_join-aufnr.
    ls_final-kunnr       = ls_join-kunnr.
    ls_final-netpr       = ls_join-netpr.
    ls_final-netwr       = ls_join-netwr.

  SELECT SINGLE bstkd INTO ls_final-bstkd FROM vbkd WHERE vbeln = ls_final-vbelv.
  SELECT SINGLE gbstk INTO ls_final-gbstk FROM vbuk WHERE vbeln = ls_final-vbelv.

    READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = ls_final-vbelv
                                             posnr = ls_final-posnv
                                               etenr = '0001'.

    IF sy-subrc = 0.

      ls_final-edatu = wa_vbep-edatu.           "delivary Date

      CLEAR wa_cdpos.
      DATA tabkey TYPE cdpos-tabkey.
      CONCATENATE sy-mandt wa_vbep-vbeln wa_vbep-posnr wa_vbep-etenr INTO tabkey.
      SELECT * FROM cdpos INTO TABLE it_cdpos WHERE tabkey = tabkey

**                                               AND value_new = 'CP'
**                                               AND value_old = 'CN'
                                               AND tabname = 'VBEP' AND fname = 'ETTYP'.
      SORT it_cdpos BY changenr DESCENDING.
      READ TABLE it_cdpos INTO wa_cdpos INDEX 1.
      IF wa_cdpos-value_new = 'CP' .
        SELECT SINGLE * FROM cdhdr INTO wa_cdhdr WHERE changenr = wa_cdpos-changenr.
        ls_final-mrp_dt      = wa_cdhdr-udate.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar
      ENDIF.
      CLEAR wa_cdhdr.
    ENDIF.


    READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_join-vbelv.
    IF sy-subrc = 0.
      ls_final-vkbur = ls_vbak-vkbur.
      ls_final-audat = ls_vbak-audat.
    ENDIF.
    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_join-kunnr.
    IF sy-subrc  = 0 .
      ls_final-name1 = ls_kna1-name1.
    ENDIF.

    READ TABLE lt_vbrp INTO ls_vbrp WITH KEY vbelv = ls_final-vbelv
                                             posnv = ls_final-posnv.
    IF sy-subrc = 0 .
      ls_final-vbeln1 = ls_vbrp-vbeln.
      ls_final-erdat = ls_vbrp-erdat.
      ls_final-arktx = ls_vbrp-arktx.
      ls_final-fkimg = ls_vbrp-fkimg.
      ls_final-kursk = ls_vbrp-kursk.
    ENDIF.

    READ TABLE lt_vbrk INTO ls_vbrk WITH KEY vbeln = ls_vbrp-vbeln.
    IF sy-subrc = 0.
      ls_final-waerk = ls_vbrk-waerk.
    ENDIF.

    SELECT SINGLE vtext INTO ls_final-vtext FROM tvktt WHERE ktgrd = ls_vbrk-ktgrd AND spras = sy-langu.
*    READ TABLE lt_afpo INTO ls_afpo WITH KEY kdauf = ls_final-vbelv
*                                             kdpos = ls_final-posnv.
*    IF sy-subrc = 0.
*      ls_final-aufnr = ls_afpo-aufnr.
*    ENDIF.

    READ TABLE lt_afru INTO ls_afru WITH KEY aufnr = ls_final-aufnr.
    IF sy-subrc = 0.
      ls_final-budat = ls_afru-budat.
    ENDIF.

    READ TABLE lt_qals INTO ls_qals WITH KEY werk = ls_afru-werks
                                             aufnr = ls_afru-aufnr.
    IF sy-subrc = 0.
      ls_final-prueflos = ls_qals-prueflos .
    ENDIF.

    READ TABLE lt_qave INTO ls_qave WITH KEY prueflos = ls_final-prueflos.
    IF sy-subrc = 0.
      ls_final-vdatum = ls_qave-vdatum.
    ENDIF.

    READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_qals-selmatnr.
    IF sy-subrc = 0.
      ls_final-zseries =  ls_mara-zseries.
      ls_final-zsize   =  ls_mara-zsize.
      ls_final-brand   =  ls_mara-brand.
      ls_final-moc     =  ls_mara-moc.
      ls_final-type    =  ls_mara-type.

    ENDIF.

    READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = ls_final-vbelv.
    IF sy-subrc = 0.
      ls_final-ship = ls_vbpa-kunnr.
    ENDIF.

    SELECT SINGLE name1 INTO ls_final-ship_nm FROM kna1 WHERE kunnr = ls_final-ship.


*    "LD Tag.
*      CLEAR: lt_lines[],ls_lines.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z038'
*          language                = sy-langu
*          name                    = lv_id
*          object                  = 'VBBK'
*        TABLES
*          lines                   = lt_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*      IF NOT lt_lines IS INITIAL.
*        LOOP AT lt_lines INTO ls_lines.
*          IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE ls_final-ld_tg ls_lines-tdline INTO ls_final-ld_tg SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE ls_final-ld_tg.
*      ELSE.
*        lv_id = ls_final-aubel.
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            client                  = sy-mandt
*            id                      = 'Z038'
*            language                = sy-langu
*            name                    = lv_id
*            object                  = 'VBBK'
*          TABLES
*            lines                   = lt_lines
*          EXCEPTIONS
*            id                      = 1
*            language                = 2
*            name                    = 3
*            not_found               = 4
*            object                  = 5
*            reference_check         = 6
*            wrong_access_to_archive = 7
*            OTHERS                  = 8.
*        IF sy-subrc <> 0.
** Implement suitable error handling here
*        ENDIF.
*        IF NOT lt_lines IS INITIAL.
*          LOOP AT lt_lines INTO ls_lines.
*            IF NOT ls_lines-tdline IS INITIAL.
*              CONCATENATE ls_final-ld_tg ls_lines-tdline INTO ls_final-ld_tg SEPARATED BY space.
*            ENDIF.
*          ENDLOOP.
*          CONDENSE ls_final-ld_tg.
*        ENDIF.
*      ENDIF.





    APPEND ls_final TO lt_final.
    CLEAR : ls_final,ls_join,ls_kna1,ls_vbrp,ls_afpo,ls_afru,ls_qals,ls_qave,ls_mara.

  ENDLOOP.

  IF p_down = 'X'.
    LOOP AT lt_final INTO ls_final.
      ls_ref-vbelv        = ls_final-vbelv.
      ls_ref-posnv        = ls_final-posnv.
      ls_ref-matnr        = ls_final-matnr.
      ls_ref-aufnr        = ls_final-aufnr.

      IF ls_final-custdeldate IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-custdeldate
          IMPORTING
            output = ls_ref-custdeldate.

        CONCATENATE ls_ref-custdeldate+0(2) ls_ref-custdeldate+2(3) ls_ref-custdeldate+5(4)
        INTO ls_ref-custdeldate SEPARATED BY '-'.
      ENDIF.

      IF ls_final-edatu IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-edatu
          IMPORTING
            output = ls_ref-edatu.

        CONCATENATE ls_ref-edatu+0(2) ls_ref-edatu+2(3) ls_ref-edatu+5(4)
        INTO ls_ref-edatu SEPARATED BY '-'.
      ENDIF.

      IF ls_final-mrp_dt IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-mrp_dt
          IMPORTING
            output = ls_ref-mrp_dt.

        CONCATENATE ls_ref-mrp_dt+0(2) ls_ref-mrp_dt+2(3) ls_ref-mrp_dt+5(4)
        INTO ls_ref-mrp_dt SEPARATED BY '-'.
      ENDIF.

      ls_ref-name1        = ls_final-name1.
      ls_ref-vbeln1       = ls_final-vbeln1.

      IF ls_final-erdat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-erdat
          IMPORTING
            output = ls_ref-erdat.

        CONCATENATE ls_ref-erdat+0(2) ls_ref-erdat+2(3) ls_ref-erdat+5(4)
        INTO ls_ref-erdat SEPARATED BY '-'.
      ENDIF.

      IF ls_final-budat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-budat
          IMPORTING
            output = ls_ref-budat.

        CONCATENATE ls_ref-budat+0(2) ls_ref-budat+2(3) ls_ref-budat+5(4)
        INTO ls_ref-budat SEPARATED BY '-'.
      ENDIF.

      IF ls_final-vdatum IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-vdatum
          IMPORTING
            output = ls_ref-vdatum.

        CONCATENATE ls_ref-vdatum+0(2) ls_ref-vdatum+2(3) ls_ref-vdatum+5(4)
        INTO ls_ref-vdatum SEPARATED BY '-'.
      ENDIF.

      ls_ref-zseries      = ls_final-zseries.
      ls_ref-zsize        = ls_final-zsize.
      ls_ref-brand        = ls_final-brand.
      ls_ref-moc          = ls_final-moc.
      ls_ref-type         = ls_final-type.

      ls_ref-vkbur       = ls_final-vkbur     .


      IF ls_final-audat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_final-audat
          IMPORTING
            output = ls_ref-audat.

        CONCATENATE ls_ref-audat+0(2) ls_ref-audat+2(3) ls_ref-audat+5(4)
        INTO ls_ref-audat SEPARATED BY '-'.
      ENDIF.

      ls_ref-arktx       = ls_final-arktx     .
      ls_ref-fkimg       = ls_final-fkimg     .
      ls_ref-waerk       = ls_final-waerk     .
      ls_ref-kursk       = ls_final-kursk     .
      ls_ref-vtext       = ls_final-vtext     .
      ls_ref-ship        = ls_final-ship      .
      ls_ref-ship_nm     = ls_final-ship_nm   .
      ls_ref-gbstk       = ls_final-gbstk     .
      ls_ref-bstkd       = ls_final-bstkd     .
      ls_ref-netpr       = ls_final-netpr     .
      ls_ref-netwr       = ls_final-netwr     .



      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = ls_ref-sdate.

      APPEND ls_ref TO lt_ref.
      CLEAR : ls_final,ls_ref.
    ENDLOOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat .

  PERFORM fcat USING : '1'   'VBELV'           'LT_FINAL'      'Sales order no.'                 '15',
                       '2'   'NAME1'           'LT_FINAL'      'Customer name'                   '15' ,
                       '3'   'POSNV'           'LT_FINAL'      'Line Item no.'                   '15' ,
                       '4'   'MATNR'           'LT_FINAL'      'Item code'                       '15' ,
                       '5'   'VBELN1'          'LT_FINAL'      'Invoice no.'                     '15' ,
                       '6'   'ERDAT'           'LT_FINAL'      'Invoice Date'                    '15' ,
                       '7'   'AUFNR'           'LT_FINAL'      'Prod. order no.'                 '15' ,
                       '8'   'BUDAT'           'LT_FINAL'      'Prod. ord. conf date'            '15' ,
                       '9'   'VDATUM'          'LT_FINAL'      'Inspection Date'                 '15'  ,
                       '10'  'CUSTDELDATE'     'LT_FINAL'      'CDD'                             '15' ,
                       '11'  'EDATU'           'LT_FINAL'      'Internal Prod. Date'             '15' ,
                       '12'  'MRP_DT'          'LT_FINAL'      'MRP Inclusion Date'              '15' ,
                       '13'  'BRAND'           'LT_FINAL'      'BRAND'                           '15' ,
                       '14'  'ZSERIES'         'LT_FINAL'      'Series'                          '15' ,
                       '15'  'ZSIZE'           'LT_FINAL'      'Size'                            '15' ,
                       '16'  'MOC'             'LT_FINAL'      'Moc'                             '15' ,
                       '17'  'TYPE'            'LT_FINAL'      'TYPE'                            '15' ,
                       '18'  'VKBUR'           'LT_FINAL'      'Sales Office'                    '15' ,
                       '19'  'AUDAT'           'LT_FINAL'      'SO Date'                         '15' ,
                       '20'  'ARKTX'           'LT_FINAL'      'Sales Text'                      '15' ,
                       '21'  'FKIMG'           'LT_FINAL'      'Invoice Qty'                     '15' ,
                       '22'  'WAERK'           'LT_FINAL'      'Currency'                        '15' ,
                       '23'  'KURSK'           'LT_FINAL'      'Exchange Rate'                   '15' ,
                       '24'  'VTEXT'           'LT_FINAL'      'Sales Type'                      '15' ,
                       '25'  'SHIP'            'LT_FINAL'      'Ship to Party'                   '15' ,
                       '26'  'SHIP_NM'         'LT_FINAL'      'Ship to Party Name'              '15' ,
                       '27'  'GBSTK'           'LT_FINAL'      'Status'                          '15' ,
                       '28'  'BSTKD'           'LT_FINAL'      'Customer Po No'                  '15' ,
                       '29'  'NETPR'           'LT_FINAL'      'Rate'                            '15' ,
                       '30'  'NETWR'           'LT_FINAL'      'Amount'                          '15' .



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ENDFORM  text
*----------------------------------------------------------------------*
FORM fcat  USING VALUE(p1)
                 VALUE(p2)
                 VALUE(p3)
                 VALUE(p4)
                 VALUE(p5).
*                 VALUE(p6).

  ls_fcat-col_pos       = p1.
  ls_fcat-fieldname     = p2.
  ls_fcat-tabname       = p3.
  ls_fcat-seltext_l     = p4.
  ls_fcat-outputlen     = p5.
*  ls_fcat-ref_fieldname = p6.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
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
      it_fieldcat        = lt_fcat
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
    TABLES
      t_outtab           = lt_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
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
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_ref
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
  lv_file = 'ZInvoice_Details.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
  INTO lv_fullfile.

  WRITE: / 'ZInvoice_Details REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_930 TYPE string.
DATA lv_crlf_930 TYPE string.
lv_crlf_930 = cl_abap_char_utilities=>cr_lf.
lv_string_930 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_930 lv_crlf_930 wa_csv INTO lv_string_930.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_930 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*************************************************SECOND FILE ***************************************

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_ref
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
  lv_file = 'Invoice_Details.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.

  WRITE: / 'Invoice_Details REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_965 TYPE string.
DATA lv_crlf_965 TYPE string.
lv_crlf_965 = cl_abap_char_utilities=>cr_lf.
lv_string_965 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_965 lv_crlf_965 wa_csv INTO lv_string_965.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_965 TO lv_fullfile.
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

  CONCATENATE 'Sales order no.'
              'Customer name'
              'Line Item no.'
              'Item code'
              'Invoice no.'
              'Invoice Date'
              'Prod. order no.'
              'Prod. ord. conf date'
              'Inspection Date'
              'CDD'
              'Internal Prod. Date'
              'MRP Inclusion Date'
              'BRAND'
              'Series'
              'Size'
              'Moc'
              'TYPE'
              'Sales Office'
              'SO Date'
              'Sales Text'
              'Invoice Qty'
              'Currency'
              'Exchange Rate'
              'Sales Type'
              'Ship to Party'
              'Ship to Party Name'
              'Status'
              'Customer Po No'
              'Rate'
              'Amount'
              'Refresh Date'
              INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
