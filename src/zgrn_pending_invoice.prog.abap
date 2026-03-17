*&---------------------------------------------------------------------*
*& Report ZGRN_PENDING_INVOICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgrn_pending_invoice.

TYPE-POOLS : slis.

TABLES : bkpf,rseg,lfa1,mseg.

TYPES : BEGIN OF ty_mseg,
          bwart      TYPE mseg-bwart,
          matnr      TYPE mseg-matnr,
          erfmg      TYPE mseg-erfmg,
          meins      TYPE mseg-meins,
          lsmng      TYPE mseg-lsmng,
          mblnr      TYPE mseg-mblnr,
          lifnr      TYPE mseg-lifnr,
          dmbtr      TYPE mseg-dmbtr,
          bnbtr      TYPE mseg-bnbtr,
          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,
          lfbnr      TYPE mseg-lfbnr,
          bukrs      TYPE mseg-bukrs,
          werks      TYPE mseg-werks,
          shkzg      TYPE mseg-shkzg,
          smbln      TYPE mseg-smbln,
          mjahr      TYPE mseg-mjahr,
          budat_mkpf TYPE mseg-budat_mkpf,
          gjahr      TYPE mseg-gjahr,
          lfpos      TYPE mseg-lfpos,
          zeile      TYPE mseg-zeile,
          zekkn      TYPE mseg-zekkn,
          usnam_mkpf TYPE mseg-usnam_mkpf,
          ps_psp_pnr TYPE mseg-ps_psp_pnr,
          con1       TYPE bkpf-awkey,
        END OF ty_mseg.

DATA : it_mseg TYPE STANDARD TABLE OF ty_mseg,
       wa_mseg TYPE ty_mseg.

TYPES : BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          name1 TYPE lfa1-name1,
        END OF ty_lfa1.

DATA : it_lfa1 TYPE STANDARD TABLE OF ty_lfa1,
       wa_lfa1 TYPE ty_lfa1.

TYPES : BEGIN OF ty_bkpf,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          bldat TYPE bkpf-bldat,
          budat TYPE bkpf-budat,
          awkey TYPE bkpf-awkey,
          xblnr TYPE bkpf-xblnr,
        END OF ty_bkpf.

DATA : it_bkpf TYPE STANDARD TABLE OF ty_bkpf,
       wa_bkpf TYPE ty_bkpf.

DATA : it_bkpf1 TYPE STANDARD TABLE OF ty_bkpf,
       wa_bkpf1 TYPE ty_bkpf.

TYPES : BEGIN OF ty_ekbe,
          ebeln TYPE ekbe-ebeln,
          ebelp TYPE ekbe-ebelp,
          vgabe TYPE ekbe-vgabe,
          gjahr TYPE ekbe-gjahr,
          belnr TYPE ekbe-belnr,
          shkzg TYPE ekbe-shkzg,
          werks TYPE ekbe-werks,
          lfbnr TYPE ekbe-lfbnr,
*          con   type bkpf-awkey,
        END OF ty_ekbe.

DATA : it_ekbe TYPE STANDARD TABLE OF ty_ekbe,
       wa_ekbe TYPE ty_ekbe.

TYPES : BEGIN OF ty_rbkp,
          belnr TYPE rbkp-belnr,
          gjahr TYPE rbkp-gjahr,
          stblg TYPE rbkp-stblg,
          con   TYPE bkpf-awkey,
        END OF ty_rbkp.

DATA : it_rbkp TYPE STANDARD TABLE OF ty_rbkp,
       wa_rbkp TYPE ty_rbkp.

TYPES : BEGIN OF ty_bseg,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          dmbtr TYPE bseg-dmbtr,
          hwbas TYPE bseg-hwbas,
          mwart TYPE bseg-mwart,
          txgrp TYPE bseg-txgrp,
          ktosl TYPE bseg-ktosl,
          ebeln TYPE bseg-ebeln,
          ebelp TYPE bseg-ebelp,
        END OF ty_bseg.

DATA : it_bseg TYPE STANDARD TABLE OF ty_bseg,
       wa_bseg TYPE ty_bseg.

TYPES : BEGIN OF ty_bseg1,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          dmbtr TYPE bseg-dmbtr,
          hwbas TYPE bseg-hwbas,
          mwart TYPE bseg-mwart,
          txgrp TYPE bseg-txgrp,
          ktosl TYPE bseg-ktosl,
          ebeln TYPE bseg-ebeln,
          ebelp TYPE bseg-ebelp,
        END OF ty_bseg1.

DATA : it_bseg1 TYPE STANDARD TABLE OF ty_bseg1,
       wa_bseg1 TYPE ty_bseg1.

TYPES : BEGIN OF ty_mseg1,
          mblnr TYPE mseg-mblnr,
          smbln TYPE mseg-smbln,
        END OF ty_mseg1.

DATA : it_mseg1 TYPE STANDARD TABLE OF ty_mseg1,
       wa_mseg1 TYPE ty_mseg1.

TYPES : BEGIN OF ty_rseg,
          belnr TYPE rseg-belnr,
          gjahr TYPE rseg-gjahr,
          ebeln TYPE rseg-ebeln,
          ebelp TYPE rseg-ebelp,
          lfbnr TYPE rseg-lfbnr,
        END OF ty_rseg.

DATA : it_rseg TYPE STANDARD TABLE OF ty_rseg,
       wa_rseg TYPE ty_rseg.

TYPES : BEGIN OF ty_final,

          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          budat_mkpf TYPE mseg-budat_mkpf,

          belnr      TYPE bkpf-belnr,
          lifnr      TYPE lfa1-lifnr,
          name1      TYPE lfa1-name1,

          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,

          belnr1     TYPE bkpf-belnr,
          budat      TYPE bkpf-budat,
          xblnr      TYPE bkpf-xblnr,
          bldat      TYPE bkpf-bldat,

          xblnr1     TYPE  mkpf-xblnr,
          bill_type  TYPE  char12,
* tax_amt     type bseg-dmbtr,
* gross_amt   type bseg-dmbtr,

        END OF ty_final.

TYPES : BEGIN OF ty_final1,

          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          budat_mkpf TYPE char15,

          belnr      TYPE bkpf-belnr,
          lifnr      TYPE lfa1-lifnr,
          name1      TYPE lfa1-name1,

          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,

          belnr1     TYPE bkpf-belnr,
          budat      TYPE char15,
          xblnr      TYPE bkpf-xblnr,
          bldat      TYPE char15,

          xblnr1     TYPE  mkpf-xblnr,
          bill_type  TYPE  char12,
* hwbas       type string,
* tax_amt     type string,
* gross_amt   type string,

        END OF ty_final1.

DATA : it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final.

DATA: it_down TYPE TABLE OF ty_final1,
      wa_down TYPE          ty_final1.

DATA : gt_listheader   TYPE slis_t_listheader   WITH HEADER LINE,
       gt_fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gt_event        TYPE slis_t_event        WITH HEADER LINE,
       gt_layout       TYPE slis_layout_alv,
       gt_sort         TYPE slis_t_sortinfo_alv WITH HEADER LINE.

DATA : wa_ekpo  TYPE  ekpo.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : s_budat FOR mseg-budat_mkpf OBLIGATORY,
                   s_werks FOR mseg-werks OBLIGATORY DEFAULT 'PL01' MODIF ID wer," ADDED BY MD
                   s_lifnr FOR mseg-lifnr,
                   s_mblnr FOR mseg-mblnr .
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.


AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF screen-group1 = 'WER'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM get_data.

FORM get_data .
*  BREAK PRIMUS.
  SELECT a~bwart
         a~matnr
         a~erfmg
         a~meins
         a~lsmng
         a~mblnr      " GRN No
         a~lifnr      " Vendor Cd
         a~dmbtr      " Amount
         a~bnbtr      "freight amt
         a~ebeln      " PO No
         a~ebelp
         a~lfbnr
         a~bukrs      " CoCd
         a~werks
         a~shkzg
         a~smbln
         a~mjahr
         a~budat_mkpf
         a~gjahr
         a~lfpos
         a~zeile
         a~zekkn
         a~usnam_mkpf
         a~ps_psp_pnr
    FROM  mseg AS a INTO CORRESPONDING FIELDS OF TABLE  it_mseg
*    UP TO 1 ROWS
*    FOR ALL ENTRIES IN it_mkpf
    WHERE " mblnr = it_mkpf-mblnr AND
*    a~bukrs = p_bukrs
      a~werks IN s_werks
    AND   a~vgart_mkpf = 'WE'
    AND   a~tcode2_mkpf = 'ML81N'
    AND   a~budat_mkpf IN s_budat
    AND   a~lifnr IN s_lifnr
*    AND   a~ebeln IN p_ebeln
    AND   a~mblnr IN s_mblnr
*    AND   a~matnr IN s_matnr
*   AND   bwart Not in ( '543', '544' )
    AND  a~bwart IN ( '101','103' ) AND a~lfbnr IN ( SELECT lblni FROM essr WHERE kzabn = 'X'  )
    AND a~mblnr = ( SELECT MAX( b~belnr ) FROM ekbe AS b WHERE a~ebeln =  b~ebeln AND a~ebelp = b~ebelp AND a~lfbnr = b~lfbnr
   AND b~bwart = '101' AND b~vgabe = 1 ).


  SELECT  a~bwart
          a~matnr
          a~erfmg
          a~meins
          a~lsmng
          a~mblnr      " GRN No
          a~lifnr      " Vendor Cd
          a~dmbtr      " Amount
          a~bnbtr      "freight amt
          a~ebeln      " PO No
          a~ebelp
          a~lfbnr
          a~bukrs      " CoCd
          a~werks
          a~shkzg
          a~smbln
          a~mjahr
          a~budat_mkpf
          a~gjahr
          a~lfpos
          a~zeile
          a~zekkn
          a~usnam_mkpf
          a~ps_psp_pnr
     FROM  mseg AS a APPENDING TABLE it_mseg
*    FOR ALL ENTRIES IN it_mkpf
     WHERE "mblnr = it_mkpf-mblnr AND
*    a~bukrs = p_bukrs
       a~werks IN s_werks
     AND   a~vgart_mkpf = 'WE'
     AND a~tcode2_mkpf = 'MIGO_GR'
     AND   a~budat_mkpf IN s_budat
     AND   a~lifnr IN s_lifnr
*    AND   a~ebeln IN p_ebeln
     AND   a~mblnr IN s_mblnr
*    AND   a~matnr IN s_matnr
*    AND   bwart Not in ( '543', '544' )
     AND  a~bwart IN ( '101','103', '123' ) AND a~mblnr NOT IN ( SELECT b~smbln FROM mseg AS b WHERE b~bwart IN ( '104', '102', '122' ) AND
    a~ebeln = b~ebeln AND a~ebelp = b~ebelp ).
*    And
*   a~ebeln = b~ebeln and a~ebelp = b~ebelp ).

*    SELECT  a~bwart
*         a~matnr
*         a~erfmg
*         a~meins
*         a~lsmng
*         a~mblnr      " GRN No
*         a~lifnr      " Vendor Cd
*         a~dmbtr      " Amount
*         a~bnbtr      "freight amt
*         a~ebeln      " PO No
*         a~ebelp
*         a~lfbnr
*         a~bukrs      " CoCd
*         a~werks
*         a~shkzg
*         a~smbln
*         a~mjahr
*         a~budat_mkpf
*         a~GJAHR
*         a~lfpos
*         a~zeile
*         a~ZEKKN
*         a~USNAM_MKPF
*         a~PS_PSP_PNR
*    FROM  mseg as a APPENDING TABLE it_mseg
**    FOR ALL ENTRIES IN it_mkpf
*    WHERE "mblnr = it_mkpf-mblnr AND
**    a~bukrs = p_bukrs
*      a~werks IN s_werks
*    AND   a~vgart_mkpf = 'WE'
*    AND a~TCode2_MKPF = 'MIGO_GR'
*    AND   a~budat_mkpf IN S_budat
*    AND   a~lifnr IN S_lifnr
**    AND   a~ebeln IN p_ebeln
*    AND   a~mblnr IN S_mblnr
**    AND   a~matnr IN s_matnr
**    AND   bwart Not in ( '543', '544' )
*    AND  a~bwart in ( '101','103', '123' ) and a~mblnr not in ( Select b~smbln from mseg as b where b~bwart in ( '104', '102' ) And
*   a~ebeln = b~ebeln and a~ebelp = b~ebelp )
*   and a~mblnr not in ( Select c~lfbnr from mseg as c where c~bwart EQ '122' And
*   a~ebeln = c~ebeln and a~ebelp = c~ebelp ).
*  select mblnr
*         mjahr
*         ZEILE
*         bwart
*         werks
*         lifnr
*         ebeln
*         ebelp
*         lfbnr
*         budat_mkpf
*         VGART_MKPF from mseg
*    into table it_mseg
*    where mblnr in s_mblnr and
*          werks in s_werks and
*          lifnr in s_lifnr and
*          bwart in ('101', '103') and
*          budat_mkpf in s_budat and
*          VGART_MKPF = 'WE'.

*select mblnr
*  smbln from mseg
*  into TABLE it_mseg1
*  for ALL ENTRIES IN it_mseg
*  where smbln = it_mseg-mblnr.
*
*break primus.
*  loop at it_mseg into wa_mseg.
*
*    READ TABLE it_mseg1 INTO wa_mseg1 with key smbln = wa_mseg-mblnr.
*    if sy-subrc = 0.
**        if wa_mseg1-smbln is NOT INITIAL.
*      DELETE it_mseg where mblnr = wa_mseg-mblnr.
**      endif.
*      ENDIF.
*      CLEAR wa_mseg.
*    ENDloop.

  IF it_mseg IS NOT INITIAL.
    SELECT lifnr
           name1 FROM lfa1
      INTO TABLE it_lfa1
      FOR ALL ENTRIES IN it_mseg
      WHERE lifnr = it_mseg-lifnr.
  ENDIF.


  LOOP AT it_mseg INTO wa_mseg.
    CONCATENATE wa_mseg-mblnr wa_mseg-mjahr INTO wa_mseg-con1.
    MODIFY it_mseg FROM wa_mseg TRANSPORTING con1.
    CLEAR wa_mseg.
  ENDLOOP.

  IF it_mseg IS NOT INITIAL.
    SELECT belnr
           gjahr
           bldat
           budat
           awkey
           xblnr FROM bkpf
      INTO TABLE it_bkpf
      FOR ALL ENTRIES IN it_mseg
      WHERE awkey = it_mseg-con1.
  ENDIF.

  IF it_mseg IS NOT INITIAL.
*            select belnr
*                   GJAHR
*                   ebeln
*                   ebelp
*                   werks
*                   lfbnr from rseg
*              into TABLE it_rseg
*
*              FOR ALL ENTRIES IN it_mseg
*              where ebeln = it_mseg-ebeln and
*                    ebelp = it_mseg-ebelp and
*                    werks = it_mseg-werks and
*                    lfbnr = it_mseg-lfbnr
*               %_HINTS ORACLE 'INDEX("RSEG" "RSEG~ZPI")'.
    SELECT ebeln
           ebelp
           vgabe
           gjahr
           belnr
           shkzg
           werks
           lfbnr FROM ekbe
      INTO TABLE it_ekbe
     FOR ALL ENTRIES IN it_mseg
      WHERE ebeln = it_mseg-ebeln AND
            ebelp = it_mseg-ebelp AND
            gjahr = it_mseg-gjahr AND
            lfbnr = it_mseg-lfbnr AND
            shkzg = 'S' AND vgabe = 2.
  ENDIF.


  IF it_ekbe IS NOT INITIAL.
    SELECT belnr
           gjahr
           stblg
      FROM rbkp INTO TABLE it_rbkp
      FOR ALL ENTRIES IN it_ekbe
      WHERE belnr = it_ekbe-belnr
            AND gjahr = it_ekbe-gjahr
      AND stblg = space.
  ENDIF.

  LOOP AT it_rbkp INTO wa_rbkp.
    CONCATENATE wa_rbkp-belnr wa_rbkp-gjahr INTO wa_rbkp-con.
    MODIFY it_rbkp FROM wa_rbkp TRANSPORTING con.
    CLEAR wa_rbkp.
  ENDLOOP.

  SELECT    belnr
            gjahr
            ebeln
            ebelp
*                   werks
            lfbnr FROM rseg
       INTO TABLE it_rseg

       FOR ALL ENTRIES IN it_rbkp
       WHERE belnr = it_rbkp-belnr AND
             gjahr = it_rbkp-gjahr
          %_HINTS ORACLE 'INDEX("RSEG" "RSEG~ZPI")'.
*                    werks = it_mseg-werks and
*                    lfbnr = it_mseg-lfbnr


  IF it_rbkp IS NOT INITIAL.
    SELECT belnr
           gjahr
           bldat
           budat
           awkey
           xblnr FROM bkpf
      INTO TABLE it_bkpf1
      FOR ALL ENTRIES IN it_rbkp
      WHERE awkey = it_rbkp-con.
  ENDIF.



*      if it_bkpf1 is NOT INITIAL.
*        select
*          BELNR
*          GJAHR
*          DMBTR
*          HWBAS
*          MWART
*          TXGRP
*          KTOSL
*          EBELN
*          EBELP
*          from bseg
*          into TABLE it_bseg
*          FOR ALL ENTRIES IN it_bkpf1
*          where belnr = it_bkpf1-belnr
*          and   gjahr = it_bkpf1-gjahr.
*
*        endif.

  LOOP AT it_mseg INTO wa_mseg.
    wa_final-mblnr = wa_mseg-mblnr.
    wa_final-mjahr = wa_mseg-mjahr.
    wa_final-zeile = wa_mseg-zeile.
    wa_final-budat_mkpf = wa_mseg-budat_mkpf.
    wa_final-lifnr = wa_mseg-lifnr.
    wa_final-ebeln = wa_mseg-ebeln.
    wa_final-ebelp = wa_mseg-ebelp.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_mseg-lifnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    ENDIF.

    READ TABLE it_bkpf INTO wa_bkpf WITH KEY awkey = wa_mseg-con1.
    IF sy-subrc = 0.
      wa_final-belnr = wa_bkpf-belnr.
    ENDIF.

*      ebeln = it_mseg-ebeln and
*                    ebelp = it_mseg-ebelp and
*                    GJAHR = it_mseg-mjahr and
*                    LFBNR = it_mseg-MBLNR and
*                    SHKZG = 'S' and VGABE = 2.
*      read TABLE it_ekbe into wa_ekbe with key ebeln = wa_mseg-ebeln ebelp = wa_mseg-ebelp GJAHR = wa_mseg-mjahr lfbnr = wa_mseg-MBLNR shkzg = 'S' vgabe = 2."BINARY SEARCH.
*      if sy-subrc = 0.
    LOOP AT it_ekbe INTO wa_ekbe WHERE lfbnr = wa_mseg-lfbnr.
      LOOP AT it_rbkp INTO wa_rbkp WHERE belnr = wa_ekbe-belnr AND gjahr = wa_ekbe-gjahr AND stblg = space.
*      read TABLE it_rbkp into wa_rbkp INDEX 1."WITH key belnr = wa_ekbe-belnr gjahr = wa_ekbe-gjahr stblg = space.
        READ TABLE it_ekbe INTO wa_ekbe WITH KEY belnr = wa_rbkp-belnr."BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE it_rseg INTO wa_rseg WITH KEY belnr = wa_rbkp-belnr lfbnr = wa_mseg-lfbnr.
          IF sy-subrc = 0.
            READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY awkey = wa_rbkp-con.
            IF sy-subrc = 0.
              wa_final-belnr1 = wa_bkpf1-belnr.
              wa_final-budat = wa_bkpf1-budat.
              wa_final-xblnr = wa_bkpf1-xblnr.
              wa_final-bldat = wa_bkpf1-bldat.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
*endif.
*ENDIF.

*READ TABLE it_bseg into wa_bseg with key belnr = wa_final-belnr1  gjahr = wa_bkpf1-gjahr  ebeln = wa_final-ebeln  ebelp = wa_final-ebelp  txgrp = wa_final-ZEILE mwart = space.
*if sy-subrc = 0.
*  wa_final-hwbas = wa_bseg-DMBTR.
*  endif.
*
*  loop at it_bseg into wa_bseg where belnr = wa_final-belnr1 and gjahr = wa_bkpf1-gjahr and mwart = 'V' and txgrp = wa_final-ZEILE.
*     if wa_bseg-ktosl = 'JII' OR wa_bseg-ktosl = 'JIC' OR wa_bseg-ktosl = 'JIS' OR wa_bseg-ktosl = 'JIU' ."and wa_bseg-mwart = 'V'."and wa_bseg-kotsl = 'JII' and
*      wa_final-tax_amt = wa_final-tax_amt + wa_bseg-dmbtr.
*            endif.
*    endloop.
*
*  wa_final-gross_amt =  wa_final-hwbas + wa_final-tax_amt.
*
    SELECT SINGLE xblnr FROM mkpf INTO wa_final-xblnr1 WHERE mblnr = wa_final-mblnr.
    SELECT SINGLE * FROM ekpo INTO wa_ekpo WHERE ebeln = wa_final-ebeln AND ebelp = wa_final-ebelp.

    IF wa_ekpo-netpr <> 0.
      wa_final-bill_type = 'BILLABLE'.
    ELSE.
      wa_final-bill_type = 'NON BILLABLE'.
    ENDIF.


    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.

  SORT it_final.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS.

  LOOP AT it_final INTO wa_final.
    wa_down-mblnr      = wa_final-mblnr.
    wa_down-mjahr      = wa_final-mjahr .
    wa_down-zeile      = wa_final-zeile .
    IF wa_final-budat_mkpf IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-budat_mkpf
        IMPORTING
          output = wa_down-budat_mkpf.
      IF wa_down-budat_mkpf NE '00000000' .
        CONCATENATE wa_down-budat_mkpf+0(2) wa_down-budat_mkpf+2(3) wa_down-budat_mkpf+5(4)
                        INTO wa_down-budat_mkpf SEPARATED BY '-'.
      ENDIF.
    ELSE.
      wa_down-budat_mkpf = space.
    ENDIF.

*  wa_down-budat_mkpf = wa_final-budat_mkpf .
    wa_down-belnr      = wa_final-belnr     .
    wa_down-lifnr      = wa_final-lifnr     .
    wa_down-name1      = wa_final-name1     .
    wa_down-ebeln      = wa_final-ebeln     .
    wa_down-ebelp     = wa_final-ebelp    .
    wa_down-belnr1     = wa_final-belnr1   .
    IF wa_final-budat IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-budat
        IMPORTING
          output = wa_down-budat.
      IF wa_down-budat NE '00000000'.
        CONCATENATE wa_down-budat+0(2) wa_down-budat+2(3) wa_down-budat+5(4)
                        INTO wa_down-budat SEPARATED BY '-'.
      ENDIF.
    ELSE.
      wa_down-budat = space.
    ENDIF.
*  wa_down-budat      = wa_final-budat     .
    wa_down-xblnr      = wa_final-xblnr  .
    IF wa_final-budat IS NOT INITIAL   .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-bldat
        IMPORTING
          output = wa_down-bldat.
      IF wa_down-bldat NE '00000000'.
        CONCATENATE wa_down-bldat+0(2) wa_down-bldat+2(3) wa_down-bldat+5(4)
                        INTO wa_down-bldat SEPARATED BY '-'.
      ENDIF.
    ELSE.
      wa_down-bldat = space.
    ENDIF.
    wa_down-xblnr     = wa_final-xblnr    .
*    if wa_final-hwbas ne '0.00'.
*  wa_down-hwbas      = wa_final-hwbas    .
*  else.
*    wa_down-hwbas      = space    .
*    endif.
*       if wa_final-tax_amt ne '0.00'.
*  wa_down-tax_amt    = wa_final-tax_amt   .
*  else.
*     wa_down-tax_amt    = space .
*     ENDIF.
*      if wa_final-gross_amt ne '0.00'.
*  wa_down-gross_amt  = wa_final-gross_amt .
*  else.
*    wa_down-gross_amt  = space .
*    endif.



    APPEND wa_down TO it_down.
    CLEAR wa_final.
  ENDLOOP.
  PERFORM f_listheader.
  PERFORM f_fieldcatalog.
  PERFORM f_layout.
  PERFORM f_displaygrid.
ENDFORM.

FORM f_listheader .

  DATA : frmdt(10) TYPE c,
         todt(10)  TYPE c,
         v_str     TYPE string,
         line      TYPE string.


  gt_listheader-typ = 'H'.
  gt_listheader-key = ' '.
  gt_listheader-info = 'GRN Pending Invoice'.
  APPEND gt_listheader.

  DESCRIBE TABLE it_final LINES line.
  gt_listheader-typ = 'S'.
  gt_listheader-key  = 'TOTAL NO.OF RECORDS:'(108).
  gt_listheader-info = line.
  APPEND gt_listheader.
*  CLEAR: ls_line.
ENDFORM.

FORM f_fieldcatalog .

  gt_fieldcatalog-fieldname = 'MBLNR'.
  gt_fieldcatalog-seltext_l = 'GRN Number'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'MJAHR'.
  gt_fieldcatalog-seltext_l = 'Material Doc. Year'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


  gt_fieldcatalog-fieldname = 'ZEILE'.
  gt_fieldcatalog-seltext_l = 'Material Doc. Item'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'BUDAT_MKPF'.
  gt_fieldcatalog-seltext_l = 'GRN date'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'BELNR'.
  gt_fieldcatalog-seltext_l = 'GRN FI Document'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'LIFNR'.
  gt_fieldcatalog-seltext_l = 'Vendor Code'.
  gt_fieldcatalog-no_zero   = 'X'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'NAME1'.
  gt_fieldcatalog-seltext_l = 'Vendor Name'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'EBELN'.
  gt_fieldcatalog-seltext_l = 'PO Number'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'EBELP'.
  gt_fieldcatalog-seltext_l = 'PO Line Item'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'BELNR1'.
  gt_fieldcatalog-seltext_l = 'Posting number'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'BUDAT'.
  gt_fieldcatalog-seltext_l = 'Posting Date'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'XBLNR'.
  gt_fieldcatalog-seltext_l = 'Invoice Number'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'BLDAT'.
  gt_fieldcatalog-seltext_l = 'Invoice date'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

  gt_fieldcatalog-fieldname = 'XBLNR1'.
  gt_fieldcatalog-seltext_l = 'Vendor Invoice'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.


  gt_fieldcatalog-fieldname = 'BILL_TYPE'.
  gt_fieldcatalog-seltext_l = 'Bill Type'.
  APPEND gt_fieldcatalog.
  CLEAR gt_fieldcatalog.

*       gt_fieldcatalog-fieldname = 'TAX_AMT'.
*  gt_fieldcatalog-seltext_l = 'Tax Amount'.
*  APPEND gt_fieldcatalog.
*  CLEAR gt_fieldcatalog.
*
*       gt_fieldcatalog-fieldname = 'GROSS_AMT'.
*  gt_fieldcatalog-seltext_l = 'Gross Amount'.
*  APPEND gt_fieldcatalog.
*  CLEAR gt_fieldcatalog.
ENDFORM.

FORM f_layout .
  gt_event-name = slis_ev_top_of_page.
  gt_event-form = 'TOP_OF_PAGE'.
  APPEND gt_event.
  gt_layout-colwidth_optimize = 'X'.
ENDFORM.

FORM f_displaygrid .


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
**        i_callback_user_command = 'USER_CMDs'
      i_callback_top_of_page = 'TOP_OF_PAGE'
      is_layout              = gt_layout
      it_fieldcat            = gt_fieldcatalog[]
      it_sort                = gt_sort[]
      it_events              = gt_event[]
      i_save                 = 'A'
    TABLES
      t_outtab               = it_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.

* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  IF p_down = 'X'.
    PERFORM download.
  ENDIF.
ENDFORM.

FORM top_of_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = gt_listheader[].

ENDFORM. "top_of_page

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
*  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down "gt_final
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
  lv_file = 'ZGRN_PENDING_INVOICE.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZGRN_PENDING_INVOICE Download started on', sy-datum, 'at', sy-uzeit.
  WRITE: / 'Dest. File:', lv_fullfile.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*  CLOSE DATASET lv_fullfile.
*  CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*  MESSAGE lv_msg TYPE 'S'.

  IF sy-subrc = 0.
    DATA lv_string_263 TYPE string.
    DATA lv_crlf_263 TYPE string.

*    TRANSFER hd_csv TO lv_fullfile.

    lv_crlf_263   = cl_abap_char_utilities=>cr_lf.
    lv_string_263 = hd_csv.

    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_263  lv_crlf_263   wa_csv INTO lv_string_263 .
      CLEAR: wa_csv.
    ENDLOOP.

    TRANSFER lv_string_263 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

ENDFORM.


FORM cvs_header  USING     pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'GRN Number'
'Material Doc. Year'
'Material Doc. Item'
'GRN date'
'GRN FI Document'
'Vendor Code'
'Vendor Name'
'PO Number'
'PO Line Item'
'Posting number'
'Posting Date'
'Invoice Number'
'Invoice date'
'Vendor Invoice'
'Bill Type'
*'Tax Amount'
*'Gross Amount'
              INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
