*&---------------------------------------------------------------------*
*& Report ZUS_TRANSIT_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsa_transit_report_new.

TABLES:ekko,vbrk.

TYPES:BEGIN OF ty_mara,
        matnr   TYPE mara-matnr,
        wrkst   TYPE mara-wrkst,
        zseries TYPE mara-zseries,
        zsize   TYPE mara-zsize,
        brand   TYPE mara-brand,
        moc     TYPE mara-moc,
        type    TYPE mara-type,
      END OF ty_mara,

      BEGIN OF ty_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF ty_makt,

      BEGIN OF ty_ekpo,
        ebeln TYPE vbak-bstnk, "ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        werks TYPE ekpo-werks,
        menge TYPE ekpo-menge,
        matnr TYPE ekpo-matnr,
      END OF ty_ekpo,

      BEGIN OF ty_ekko,
        ebeln TYPE vbak-bstnk, "ekko-ebeln,
        bukrs TYPE ekko-bukrs,
        aedat TYPE ekko-aedat,
        bedat TYPE ekko-bedat,
        lifnr TYPE ekko-lifnr,
      END OF ty_ekko,


      BEGIN OF ty_vbak,
        vbeln TYPE vbak-vbeln,
        bstnk TYPE vbak-bstnk,
      END OF ty_vbak,

      BEGIN OF ty_vbap,
        vbeln  TYPE vbap-vbeln,
        posnr  TYPE vbap-posnr,
        matnr  TYPE vbap-matnr,
        kwmeng TYPE vbap-kwmeng,
        POSEX  TYPE vbap-POSEX,
      END OF ty_vbap,

      BEGIN OF ty_vbrp,
        vbeln TYPE vbrp-vbeln,
        posnr TYPE vbrp-posnr,
        fkimg TYPE vbrp-fkimg,
        VGBEL(16),
        VGPOS TYPE vbrp-vgpos,
        aubel TYPE vbrp-aubel,
        aupos TYPE vbrp-aupos,
        matnr TYPE vbrp-matnr,
        werks TYPE vbrp-werks,
      END OF ty_vbrp,

      BEGIN OF ty_vbrk,
        vbeln TYPE vbrk-vbeln,
        FKART TYPE vbrk-FKART,
        fkdat TYPE vbrk-fkdat,
        knumv TYPE vbrk-knumv,
        rfbsk TYPE vbrk-rfbsk,
        kunag TYPE vbrk-kunag,
        exnum TYPE vbrk-exnum,
        xblnr TYPE vbrk-xblnr,
        logsys TYPE vbrk-logsys,
        fksto TYPE vbrk-fksto,
      END OF ty_vbrk,

      BEGIN OF ty_vapma,
        matnr TYPE vapma-matnr,
        vkorg TYPE vapma-vkorg,
        bstnk TYPE vapma-bstnk,
        vbeln TYPE vapma-vbeln,
        posnr TYPE vapma-posnr,
        werks TYPE vapma-werks,
      END OF ty_vapma,




      BEGIN OF ty_eikp,
        exnum TYPE eikp-exnum,
        iever TYPE eikp-iever,
      END OF ty_eikp,

      BEGIN OF ty_mode,
        expvz TYPE ztransit-expvz,
        bezei TYPE ztransit-bezei,
        zdays TYPE ztransit-zdays,
      END OF ty_mode,

      BEGIN OF ty_konv,
        knumv TYPE prcd_elements-knumv,
        kposn TYPE prcd_elements-kposn,
        kschl TYPE prcd_elements-kschl,
        kbetr TYPE prcd_elements-kbetr,
        kwert TYPE prcd_elements-kwert,
      END OF ty_konv,

      BEGIN OF ty_kna1,
        kunnr TYPE kna1-kunnr,
        land1 TYPE kna1-land1,
        ort01 TYPE kna1-ort01,
        pstlz TYPE kna1-pstlz,
      END OF ty_kna1,

      BEGIN OF ty_t005t,
        spras TYPE t005t-spras,
        land1 TYPE t005t-land1,
        landx TYPE t005t-landx,
      END OF ty_t005t,

      BEGIN OF ty_mard,
        matnr TYPE mard-matnr,
        werks TYPE mard-werks,
        lgort TYPE mard-lgort,
        labst TYPE mard-labst,
      END OF ty_mard,


      BEGIN OF ty_lips,
        vgbel TYPE lips-vgbel,
        vgpos TYPE lips-vgpos,
        lfimg TYPE lips-lfimg,
      END OF ty_lips,

      BEGIN OF ty_likp,
        vbeln TYPE likp-vbeln,
        verur TYPE likp-verur,
        TRSPG type likp-TRSPG,
      END OF ty_likp,


      BEGIN OF ty_t618t,
        spras TYPE t618t-spras,
        land1 TYPE t618t-land1,
        expvz TYPE t618t-expvz,
        bezei TYPE t618t-bezei,
      END OF ty_t618t,

      BEGIN OF ty_mseg,
        mblnr(16)," TYPE mseg-mblnr,
        mjahr TYPE mseg-mjahr,
        bwart TYPE mseg-bwart,
        matnr TYPE mseg-matnr,
        werks TYPE mseg-werks,
        smbln TYPE mseg-smbln,
        XBLNR_MKPF TYPE mseg-XBLNR_MKPF,
        VBELN_IM   TYPE mseg-VBELN_IM,
        VBELP_IM   TYPE mseg-VBELP_IM,
      END OF ty_mseg,

      BEGIN OF ty_bkpf,
      belnr TYPE bkpf-belnr,
      blart TYPE bkpf-blart,
      xblnr TYPE bkpf-xblnr,
      stblg TYPE bkpf-stblg,
      END OF ty_bkpf,



      BEGIN OF ty_final,
        matnr    TYPE mara-matnr,
        wrkst    TYPE mara-wrkst,
        zseries  TYPE mara-zseries,
        zsize    TYPE mara-zsize,
        brand    TYPE mara-brand,
        moc      TYPE mara-moc,
        type     TYPE mara-type,
*      maktx       TYPE makt-maktx,
        desc     TYPE char100,
        ebeln    TYPE ekpo-ebeln,
        ebelp    TYPE ekpo-ebelp,
        menge    TYPE ekpo-menge,
        lifnr    TYPE lfa1-lifnr,
        name1    TYPE lfa1-name1,
        vbeln    TYPE vbap-vbeln,
        posnr    TYPE vbap-posnr,
        kwmeng   TYPE vbap-kwmeng,
        inv_no   TYPE vbrp-vbeln,
        inv_line TYPE vbrp-posnr,
        fkimg    TYPE vbrp-fkimg,
        fkdat    TYPE vbrk-fkdat,
        xblnr    TYPE vbrk-xblnr,
        kbetr    TYPE prcd_elements-kbetr,
        kwert    TYPE prcd_elements-kwert,
        pono     TYPE char15,
        bezei    TYPE ztransit-bezei,
        arrival  TYPE sy-datum,
        due      TYPE sy-datum,
        port     TYPE char100,
        place    TYPE string,
        stock    TYPE mard-labst,
        pend     TYPE vbrp-fkimg,
        mblnr    TYPE mseg-mblnr,
        VBELN_IM TYPE mseg-VBELN_IM,
        belnr    TYPE bkpf-belnr,
        werks    TYPE ekpo-werks,
      END OF ty_final,

      BEGIN OF ty_str,
      ebeln    TYPE ekpo-ebeln,
      ebelp    TYPE ekpo-ebelp,
      matnr    TYPE mara-matnr,
      wrkst    TYPE mara-wrkst,
      desc     TYPE char100,
      menge    TYPE char15,
      zseries  TYPE mara-zseries,
      zsize    TYPE mara-zsize,
      brand    TYPE mara-brand,
      moc      TYPE mara-moc,
      type     TYPE mara-type,
      vbeln    TYPE vbap-vbeln,
      posnr    TYPE vbap-posnr,
      kwmeng   TYPE char15,
      inv_no   TYPE vbrp-vbeln,
      inv_line TYPE vbrp-posnr,
      xblnr    TYPE vbrk-xblnr,
      fkimg    TYPE char15,
      fkdat    TYPE char15,
      kbetr    TYPE char15,
      kwert    TYPE char15,
      bezei    TYPE ztransit-bezei,
      arrival  TYPE char15,
      port     TYPE char100,
      place    TYPE string,
      VBELN_IM TYPE mseg-VBELN_IM,
      mblnr    TYPE mseg-mblnr,
      belnr    TYPE bkpf-belnr,
      ref      TYPE char15,
      werks    TYPE char10,
      END OF ty_str.




DATA :day TYPE i.

DATA: it_mara  TYPE TABLE OF ty_mara,
      wa_mara  TYPE          ty_mara,

      it_mard  TYPE TABLE OF ty_mard,
      wa_mard  TYPE          ty_mard,

      it_makt  TYPE TABLE OF ty_makt,
      wa_makt  TYPE          ty_makt,

      it_ekko  TYPE TABLE OF ty_ekko,
      wa_ekko  TYPE          ty_ekko,

      it_ekpo  TYPE TABLE OF ty_ekpo,
      wa_ekpo  TYPE          ty_ekpo,

      it_likp  TYPE TABLE OF ty_likp,
      wa_likp  TYPE          ty_likp,


      it_vbap  TYPE TABLE OF ty_vbap,
      wa_vbap  TYPE          ty_vbap,

      it_vbak  TYPE TABLE OF ty_vbak,
      wa_vbak  TYPE          ty_vbak,

      it_vbrp  TYPE TABLE OF ty_vbrp,
      wa_vbrp  TYPE          ty_vbrp,

      it_vbrk  TYPE TABLE OF ty_vbrk,
      wa_vbrk  TYPE          ty_vbrk,

      it_vapma TYPE TABLE OF ty_vapma,
      wa_vapma TYPE          ty_vapma,

      it_eikp  TYPE TABLE OF ty_eikp,
      wa_eikp  TYPE          ty_eikp,

      it_t618t TYPE TABLE OF ty_t618t,
      wa_t618t TYPE          ty_t618t,

      it_mode  TYPE TABLE OF ty_mode,
      wa_mode  TYPE          ty_mode,

      it_mseg  TYPE TABLE OF ty_mseg,
      wa_mseg  TYPE          ty_mseg,

      it_mseg1  TYPE TABLE OF ty_mseg,
      wa_mseg1  TYPE          ty_mseg,

      it_bkpf  TYPE TABLE OF ty_bkpf,
      wa_bkpf  TYPE          ty_bkpf,

      it_bkpf1  TYPE TABLE OF ty_bkpf,
      wa_bkpf1  TYPE          ty_bkpf,

      it_rev   TYPE TABLE OF TY_mseg,
      wa_rev   TYPE          ty_mseg,

      it_konv  TYPE TABLE OF ty_konv,
      wa_konv  TYPE          ty_konv,

      it_kna1  TYPE TABLE OF ty_kna1,
      wa_kna1  TYPE          ty_kna1,

      it_t005t TYPE TABLE OF ty_t005t,
      wa_t005t TYPE          ty_t005t,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final,

      it_down  TYPE TABLE OF ty_str,
      wa_down  TYPE          ty_str.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.


SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS: po FOR ekko-ebeln,
*                date FOR ekko-bedat OBLIGATORY.

PARAMETERS: cust TYPE vbrk-kunag DEFAULT '0000300315' .
SELECT-OPTIONS: inv FOR vbrk-vbeln,
                date FOR vbrk-fkdat.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\saudi'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.


START-OF-SELECTION.
IF cust = '0000300315'.
  PERFORM get_data.
  PERFORM sort_data.
ELSE.
  MESSAGE 'This Report valid For Saudi Customer' TYPE 'S'.

ENDIF.

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

SELECT vbeln
       FKART
       fkdat
       knumv
       rfbsk
       kunag
       exnum
       xblnr
       logsys
       fksto FROM vbrk INTO TABLE it_vbrk
       WHERE vbeln IN inv
         AND fkdat IN date
         AND kunag = '0000300315'
         AND fksto NE 'X'
         AND FKART NE 'ZS1'  AND FKART NE 'ZF5'
         AND logsys NE ' '.


IF it_vbrk IS NOT INITIAL.
SELECT vbeln
       posnr
       fkimg
       VGBEL
       VGPOS
       aubel
       aupos
       matnr
       werks FROM vbrp INTO TABLE it_vbrp
       FOR ALL ENTRIES IN it_vbrk
       WHERE vbeln = it_vbrk-vbeln.


SELECT knumv
       kposn
       kschl
       kbetr
       kwert
   from PRCD_ELEMENTS      "FROM konv
        INTO TABLE it_konv
       FOR ALL ENTRIES IN it_vbrk
       WHERE knumv = it_vbrk-knumv
         AND kschl = 'ZPR0'.


SELECT exnum
       iever FROM eikp INTO TABLE it_eikp
       FOR ALL ENTRIES IN it_vbrk
       WHERE exnum = it_vbrk-exnum.


SELECT kunnr
       land1
       ort01
       pstlz FROM kna1 INTO TABLE it_kna1
       FOR ALL ENTRIES IN it_vbrk
       WHERE kunnr = it_vbrk-kunag.

ENDIF.


IF it_eikp IS NOT INITIAL.

  SELECT spras
         land1
         expvz
         bezei FROM t618t INTO TABLE it_t618t
         FOR ALL ENTRIES IN it_eikp
         WHERE expvz = it_eikp-iever
          AND  spras = 'EN'
          AND  land1 = 'IN'.


  SELECT expvz
         bezei
         zdays FROM ztransit INTO TABLE it_mode
         FOR ALL ENTRIES IN it_eikp
         WHERE expvz = it_eikp-iever.

ENDIF.

IF it_vbrp IS NOT INITIAL.

  SELECT matnr
         vkorg
         bstnk
         vbeln
         posnr
         werks FROM vapma INTO TABLE it_vapma
         FOR ALL ENTRIES IN it_vbrp
         WHERE vbeln = it_vbrp-aubel
           AND posnr = it_vbrp-aupos.

*  SELECT vbeln
*         verur FROM likp INTO TABLE it_likp
*         FOR ALL ENTRIES IN it_vbrp
*         WHERE VERUR = it_vbrp-VGBEL.




SELECT mblnr
       mjahr
       bwart
       matnr
       werks
       smbln
       XBLNR_MKPF
       VBELN_IM
       VBELP_IM FROM mseg INTO TABLE it_mseg
       FOR ALL ENTRIES IN it_vbrp
       WHERE XBLNR_MKPF = it_vbrp-VGBEL
*         AND VBELP_IM = it_vbrp-posnr
         AND bwart = '103'.


SELECT mblnr
       mjahr
       bwart
       matnr
       werks
       smbln
       XBLNR_MKPF
       VBELN_IM
       VBELP_IM FROM mseg INTO TABLE it_rev
       FOR ALL ENTRIES IN it_vbrp
       WHERE XBLNR_MKPF = it_vbrp-VGBEL
*       AND VBELP_IM = it_vbrp-posnr
       AND bwart = '105' .







ENDIF.
IF it_vapma IS NOT INITIAL.
  SELECT vbeln
         posnr
         matnr
         kwmeng
         POSEX FROM vbap INTO TABLE it_vbap
         FOR ALL ENTRIES IN it_vapma
         WHERE vbeln = it_vapma-vbeln
           AND posnr = it_vapma-posnr.


  SELECT ebeln
         ebelp
         werks
         menge
         matnr FROM ekpo INTO TABLE it_ekpo
         FOR ALL ENTRIES IN it_vapma
         WHERE ebeln = it_vapma-bstnk+0(10).



ENDIF.

IF it_kna1 IS NOT INITIAL.
  SELECT spras
         land1
         landx FROM t005t INTO TABLE it_t005t
         FOR ALL ENTRIES IN it_kna1
         WHERE spras = 'EN'
          AND  land1 = it_kna1-land1.


ENDIF.

IF it_ekpo IS NOT INITIAL.
  SELECT matnr
         wrkst
         zseries
         zsize
         brand
         moc
         type   FROM mara INTO TABLE it_mara
         FOR ALL ENTRIES IN it_ekpo
         WHERE matnr = it_ekpo-matnr.

ENDIF.

IF it_mseg IS NOT INITIAL.
*  BREAK PRIMUSUSA.
SELECT belnr
       blart
       xblnr
       stblg FROM bkpf INTO TABLE it_bkpf
       FOR ALL ENTRIES IN it_mseg
       WHERE xblnr = it_mseg-mblnr
         AND blart = 'TR'.



SELECT mblnr
       mjahr
       bwart
       matnr
       werks
       smbln
       XBLNR_MKPF
       VBELN_IM
       VBELP_IM FROM mseg INTO TABLE it_mseg1
       FOR ALL ENTRIES IN it_mseg
       WHERE smbln = it_mseg-mblnr+0(10).


ENDIF.

IF it_bkpf IS NOT INITIAL.

SELECT belnr
       blart
       xblnr
       stblg FROM bkpf INTO TABLE it_bkpf1
       FOR ALL ENTRIES IN it_bkpf
       WHERE stblg = it_bkpf-belnr.
*         AND blart = 'TR'.





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
LOOP AT it_vbrp INTO wa_vbrp WHERE vgbel NE space.

wa_final-inv_no = wa_vbrp-vbeln.
wa_final-inv_line = wa_vbrp-posnr.
wa_final-fkimg = wa_vbrp-fkimg.

*SELECT SINGLE vbeln INTO wa_final-VBELN_IM FROM likp WHERE verur = wa_vbrp-vgbel.

  SELECT vbeln
         verur
    TRSPG FROM likp INTO TABLE it_likp
         WHERE VERUR = wa_vbrp-VGBEL.


SORT it_likp DESCENDING BY vbeln.

READ TABLE it_likp INTO wa_likp INDEX 1.
IF sy-subrc = 0.

  wa_final-VBELN_IM = wa_likp-vbeln.

ENDIF.

READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
IF sy-subrc = 0.
   wa_final-fkdat = wa_vbrk-fkdat.
   wa_final-xblnr = wa_vbrk-xblnr.

ENDIF.

READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr.
IF sy-subrc = 0.

  wa_final-kbetr = wa_konv-kbetr.
  wa_final-kwert = wa_konv-kwert.

ENDIF.


READ TABLE it_vapma INTO wa_vapma WITH KEY vbeln = wa_vbrp-aubel posnr = wa_vbrp-aupos.
IF sy-subrc = 0.
wa_final-vbeln = wa_vapma-vbeln.
wa_final-posnr = wa_vapma-posnr.

ENDIF.


READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_vapma-vbeln posnr = wa_vapma-posnr.
IF sy-subrc = 0.
wa_final-kwmeng = wa_vbap-kwmeng.
ENDIF.

READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_vapma-bstnk  matnr = wa_vapma-matnr ebelp = wa_vbap-POSEX.
IF sy-subrc = 0.
  wa_final-ebeln = wa_ekpo-ebeln.
  wa_final-ebelp = wa_ekpo-ebelp.
  wa_final-matnr = wa_ekpo-matnr.
  wa_final-menge = wa_ekpo-menge.
  wa_final-werks = wa_ekpo-werks.

ENDIF.

READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_ekpo-matnr.
IF sy-subrc = 0.
  wa_final-wrkst     = wa_mara-wrkst.
  wa_final-zseries   = wa_mara-zseries.
  wa_final-zsize     = wa_mara-zsize.
  wa_final-brand     = wa_mara-brand.
  wa_final-moc       = wa_mara-moc.
  wa_final-type      = wa_mara-type   .

ENDIF.





READ TABLE it_eikp INTO wa_eikp WITH KEY exnum = wa_vbrk-exnum.
IF sy-subrc = 0.

ENDIF.
READ TABLE it_t618t INTO wa_t618t WITH KEY expvz = wa_eikp-iever.
IF sy-subrc = 0.
  wa_final-bezei = wa_t618t-bezei.

ENDIF.

READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbrk-kunag.
IF sy-subrc = 0.
  READ TABLE it_t005t INTO wa_t005t WITH KEY spras = 'EN' land1 = wa_kna1-land1.
  IF sy-subrc = 0.
    CONCATENATE wa_kna1-ort01 wa_kna1-pstlz wa_t005t-landx INTO wa_final-place SEPARATED BY ','.

  ENDIF.

ENDIF.

    READ TABLE it_mode INTO wa_mode WITH KEY expvz = wa_eikp-iever.
    IF sy-subrc = 0.
      day = wa_mode-zdays.
      CALL FUNCTION 'BKK_ADD_WORKINGDAY'
        EXPORTING
          i_date = wa_final-fkdat
          i_days = day
*         I_CALENDAR1       =
*         I_CALENDAR2       =
        IMPORTING
          e_date = wa_final-arrival
*         E_RETURN          =
        .

    ENDIF.

    CLEAR: lv_lines, ls_mattxt,wa_lines.
    REFRESH lv_lines.
    lv_name = wa_final-inv_no.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'Z010'
        language                = sy-langu
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-port wa_lines-tdline INTO wa_final-port SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-port.
    ENDIF.

    CLEAR: lv_lines, ls_mattxt.
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-desc wa_lines-tdline INTO wa_final-desc SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-desc.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '<(>' IN wa_final-desc WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN wa_final-desc WITH SPACE.

READ TABLE it_mseg INTO wa_mseg WITH KEY XBLNR_MKPF = wa_vbrp-VGBEL." VBELP_IM = wa_vbrp-posnr.
IF sy-subrc = 0.

  READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY smbln = wa_mseg-mblnr.
  IF sy-subrc = 4.
    wa_final-mblnr = wa_mseg-mblnr.
  ENDIF.


ENDIF.
*BREAK PRIMUSUSA.
LOOP AT it_bkpf INTO wa_bkpf WHERE xblnr = wa_mseg-mblnr.
*IF sy-subrc = 0.
  READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
  IF sy-subrc = 4.
    wa_final-belnr = wa_bkpf-belnr.
  ENDIF.

*ENDIF.
ENDLOOP.

READ TABLE it_rev INTO wa_rev WITH KEY XBLNR_MKPF = wa_vbrp-VGBEL." VBELP_IM = wa_vbrp-posnr.
IF sy-subrc = 4.
  IF WA_LIKP-TRSPG NE '03'.
APPEND wa_final TO it_final.
ENDIF.
ENDIF.


CLEAR:wa_final,wa_mseg,wa_rev,wa_bkpf,wa_mseg1,wa_vbrp,wa_eikp,wa_mode,wa_kna1,wa_t005t,wa_vbrk,wa_t618t,wa_mara,wa_ekpo,
      wa_vbap,wa_vapma,wa_konv,wa_mseg1,wa_rev,WA_LIKP.
DELETE it_final WHERE ebeln  = ' '.
DELETE it_final WHERE VBELN_IM  = ' '.
ENDLOOP.


IF p_down = 'X'.
  LOOP AT it_final INTO wa_final .
    wa_down-ebeln    = wa_final-ebeln   .
    wa_down-ebelp    = wa_final-ebelp   .
    wa_down-matnr    = wa_final-matnr   .
    wa_down-wrkst    = wa_final-wrkst   .
    wa_down-desc     = wa_final-desc    .
    wa_down-menge    = wa_final-menge   .
    wa_down-zseries  = wa_final-zseries .
    wa_down-zsize    = wa_final-zsize   .
    wa_down-brand    = wa_final-brand   .
    wa_down-moc      = wa_final-moc     .
    wa_down-type     = wa_final-type    .
    wa_down-vbeln    = wa_final-vbeln   .
    wa_down-posnr    = wa_final-posnr   .
    wa_down-kwmeng   = wa_final-kwmeng  .
    wa_down-inv_no   = wa_final-inv_no  .
    wa_down-inv_line = wa_final-inv_line.
    wa_down-xblnr    = wa_final-xblnr   .
    wa_down-fkimg    = wa_final-fkimg   .
    wa_down-werks    = wa_final-werks   .
*    wa_down-fkdat    = wa_final-fkdat   .
IF wa_final-fkdat IS NOT INITIAL.
CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-fkdat
      IMPORTING
        output = wa_down-fkdat.

    CONCATENATE wa_down-fkdat+0(2) wa_down-fkdat+2(3) wa_down-fkdat+5(4)
                    INTO wa_down-fkdat SEPARATED BY '-'.
ENDIF.


    wa_down-kbetr    = wa_final-kbetr   .
    wa_down-kwert    = wa_final-kwert   .
    wa_down-bezei    = wa_final-bezei   .
*    wa_down-arrival  = wa_final-arrival .

IF wa_final-arrival IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-arrival
      IMPORTING
        output = wa_down-arrival.

    CONCATENATE wa_down-arrival+0(2) wa_down-arrival+2(3) wa_down-arrival+5(4)
                    INTO wa_down-arrival SEPARATED BY '-'.
ENDIF.

    wa_down-port     = wa_final-port     .
    wa_down-place    = wa_final-place    .
    wa_down-VBELN_IM = wa_final-VBELN_IM .
    wa_down-mblnr    = wa_final-mblnr    .
    wa_down-belnr    = wa_final-belnr    .
    wa_down-ref = sy-datum.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_down-ref
      IMPORTING
        output = wa_down-ref.

    CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                    INTO wa_down-ref SEPARATED BY '-'.


    APPEND wa_down TO it_down.
    CLEAR wa_down.

  ENDLOOP.


ENDIF.


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
  PERFORM fcat USING :  '1'  'EBELN '           'IT_FINAL'  'Purchase Order No'         '18' ,
                        '2'  'EBELP '           'IT_FINAL'  'Purchase Order Line'         '18' ,
                        '3'  'MATNR '           'IT_FINAL'  'Material Number'           '18' ,
                        '4'  'WRKST '           'IT_FINAL'  'USA Material Code'         '18' ,
                        '5'  'DESC  '           'IT_FINAL'  'Material Desc.'            '18' ,
                        '6'  'MENGE '           'IT_FINAL'  'Purchase Order Quantity'         '18' ,
                        '7'  'ZSERIES'          'IT_FINAL'  'Series code'               '18' ,
                        '8'  'ZSIZE '           'IT_FINAL'  'Size'                      '18' ,
                        '9'  'BRAND '           'IT_FINAL'  'Brand'                     '18' ,
                       '10'  'MOC '             'IT_FINAL'  'Moc'                       '18' ,
                       '11'  'TYPE '            'IT_FINAL'  'Type'                      '18' ,

                      '12'  'VBELN '          'IT_FINAL'  'Sale Order No'             '18' ,
                      '13'  'POSNR '          'IT_FINAL'  'Sale Ord.Item'             '18' ,
                      '14'  'KWMENG '         'IT_FINAL'  'Sale Ord.Qty'             '18' ,
                      '15'  'INV_NO'          'IT_FINAL'  'Billing Doc No'                '18' ,
                      '16'  'INV_LINE'        'IT_FINAL'  'Billing Item'              '18' ,
                      '17'  'XBLNR'           'IT_FINAL'  'Invoice No'              '18' ,
                      '18'  'FKIMG'           'IT_FINAL'  'Invoice Qty'               '18' ,
                      '19'  'FKDAT'           'IT_FINAL'  'Invoice Date'              '18' ,
                      '20'  'KBETR'           'IT_FINAL'  'Invoice Rate'                '18' ,
                      '21'  'KWERT'           'IT_FINAL'  'Net Value'                 '18' ,
                      '22'  'BEZEI'           'IT_FINAL'  'Mode of Transp'            '18' ,
                      '23'  'ARRIVAL'         'IT_FINAL'  'Expected arrival date'     '18' ,
                      '24'  'PORT'            'IT_FINAL'  'Port Of Discharge'            '18' ,
                      '25'  'PLACE'           'IT_FINAL'  'Place Of Delivery'            '18' ,
                      '26'  'VBELN_IM'        'IT_FINAL'  'Inbound Delivery'            '18',
                      '27'  'MBLNR'           'IT_FINAL'  'Material Document No'            '18',
                      '28'  'BELNR'           'IT_FINAL'  'FI Document No'            '18',
                      '29'  'WERKS'           'IT_FINAL'  'Plant'                    '18'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0729   text
*      -->P_0730   text
*      -->P_0731   text
*      -->P_0732   text
*      -->P_0733   text
*----------------------------------------------------------------------*
FORM fcat   USING    VALUE(p1)
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
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
     I_CALLBACK_USER_COMMAND = 'USER_CMD'
      i_callback_top_of_page = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = wa_layout
      it_fieldcat            = it_fcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
     IT_SORT                 = t_sort[]
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
     I_SAVE                 = 'X'
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
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
  ls_header-info = 'Transit Report'.
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
ENDFORM.                    " TOP-OF-PAGE


*
*FORM sort_list.
*  t_sort-spos      = '1'.
*  t_sort-fieldname = 'SR'.
*  t_sort-tabname   = 'IT_FINAL'.
*  t_sort-up        = 'X'.
*  t_sort-subtot    = 'X'.
*  APPEND t_sort.
*  endform.

 FORM user_cmd USING r_ucomm LIKE sy-ucomm
                     rs_selfield TYPE slis_selfield.
   IF r_ucomm = '&IC1'.
*     IF rs_selfield-fieldname = 'BELNR'.
*       READ TABLE itab WITH KEY belnr = rs_selfield-value.
*       SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
*       SET PARAMETER ID 'BUK' FIELD plant.
*       SET PARAMETER ID 'GJR' FIELD itab-gjahr.
*       CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
*     ENDIF.
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


    lv_file = 'ZUS_TRANSIT_NEW.TXT'.


  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_TRANSIT REPORT started on', sy-datum, 'at', sy-uzeit.
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
*********************************************SQL UPLOAD FILE *****************************************
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


    lv_file = 'ZUS_TRANSIT_NEW.TXT'.


  CONCATENATE p_folder '\' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_TRANSIT REPORT started on', sy-datum, 'at', sy-uzeit.
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
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
CONCATENATE 'Purchase Order No'
            'Purchase Order Line'
            'Material Number'
            'USA Material Code'
            'Material Desc.'
            'Purchase Order Quantity'
            'Series code'
            'Size'
            'Brand'
            'Moc'
            'Type'
            'Sale Order No'
            'Sale Ord.Item'
            'Sale Ord.Qty'
            'Billing Doc No'
            'Billing Item'
            'Invoice No'
            'Invoice Qty'
            'Invoice Date'
            'Invoice Rate'
            'Net Value'
            'Mode of Transp'
            'Expected arrival date'
            'Port Of Discharge'
            'Place Of Delivery'
            'Inbound Delivery'
            'Material Document No'
            'FI Document No'
            'Refresh File Date'
            'Plant'
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
