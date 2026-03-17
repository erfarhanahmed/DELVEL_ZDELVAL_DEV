*&---------------------------------------------------------------------*
*& Report ZMM_EXCISE_RETURN_DRVR
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Driver Program for the Smartform 'ZMM_EXCISE_INV' designed for
*& Tax Invoice (Returns for Vendor)
*&---------------------------------------------------------------------*
REPORT zmm_excise_return_drvr.

TYPES : BEGIN OF ty_mseg,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          bukrs TYPE mseg-bukrs,
          zeile TYPE mseg-zeile,
          bwart TYPE mseg-bwart,
          matnr TYPE mseg-matnr,
          werks TYPE mseg-werks,
          lifnr TYPE mseg-lifnr,
          ebeln TYPE mseg-ebeln,
          ebelp TYPE mseg-ebelp,
          menge TYPE mseg-menge,
          meins TYPE mseg-meins,
        END OF ty_mseg.

DATA : gt_mseg TYPE TABLE OF ty_mseg,
       wa_mseg TYPE ty_mseg.

TYPES : BEGIN OF ty_mkpf,
          mblnr TYPE mkpf-mblnr,
          mjahr TYPE mkpf-mjahr,
          xblnr TYPE mkpf-xblnr,
          bktxt TYPE mkpf-bktxt,
          budat TYPE mkpf-budat,
          frbnr TYPE mkpf-frbnr,
          cputm TYPE mkpf-cputm,
        END OF ty_mkpf.

DATA : gt_mkpf TYPE TABLE OF ty_mkpf,
       wa_mkpf TYPE ty_mkpf.

TYPES : BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          name1 TYPE lfa1-name1,
          adrnr TYPE lfa1-adrnr,
          land1 TYPE lfa1-land1,
        END OF ty_lfa1.

DATA : gt_lfa1 TYPE TABLE OF ty_lfa1,
       wa_lfa1 TYPE ty_lfa1.

TYPES : BEGIN OF ty_adrc,
          addrnumber TYPE adrc-addrnumber,
          name1      TYPE adrc-name1,
          street     TYPE adrc-street,
          str_suppl3 TYPE adrc-str_suppl3,
          location   TYPE adrc-location,
          city2      TYPE adrc-city2,
          city1      TYPE adrc-city1,
          post_code1 TYPE adrc-post_code1,
          region     TYPE adrc-region,
          tel_number TYPE adrc-tel_number,
        END OF ty_adrc.

DATA : gt_adrc TYPE TABLE OF ty_adrc,
       wa_adrc TYPE ty_adrc.

TYPES : BEGIN OF ty_t005s,
          land1 TYPE t005u-land1,
          bland TYPE t005u-bland,
          bezei TYPE t005u-bezei,
        END OF ty_t005s.

DATA : gt_t005u TYPE TABLE OF ty_t005s,
       wa_t005u TYPE ty_t005s.

TYPES : BEGIN OF ty_t005t,
          land1 TYPE t005t-land1,
          landx TYPE t005t-landx,
        END OF ty_t005t.

DATA : gt_t005t TYPE TABLE OF ty_t005t,
       wa_t005t TYPE ty_t005t.

TYPES : BEGIN OF ty_j_1iexchdr,
          exnum   TYPE j_1iexchdr-exnum,
          rdoc    TYPE j_1iexchdr-rdoc,
          ryear   TYPE j_1iexchdr-ryear,
          budat   TYPE j_1iexchdr-budat,
          cputm   TYPE j_1iexchdr-cputm,
          remtime TYPE j_1iexchdr-remtime,
        END OF ty_j_1iexchdr.

DATA : gt_hdr TYPE TABLE OF ty_j_1iexchdr,
       wa_hdr TYPE ty_j_1iexchdr.

TYPES : BEGIN OF ty_ecc,
          lifnr     TYPE lfa1-lifnr,
          j_1iexcd  TYPE j_1iexcd,
          j_1ilstno TYPE j_1ilstno,
          j_1icstno TYPE j_1icstno,
        END OF ty_ecc.

DATA : gt_ecc TYPE TABLE OF ty_ecc,
       wa_ecc TYPE ty_ecc.

TYPES : BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,
          bukrs TYPE ekko-bukrs,
          bedat TYPE ekko-bedat,
          knumv TYPE ekko-knumv,
          inco1 TYPE ekko-inco1,
        END OF ty_ekko.

DATA : gt_ekko TYPE TABLE OF ty_ekko,
       wa_ekko TYPE ty_ekko.

DATA : gt_ekko1 TYPE TABLE OF ty_ekko,
       wa_ekko1 TYPE ty_ekko.

TYPES : BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          mwskz TYPE ekpo-mwskz,
        END OF ty_ekpo.

DATA : gt_ekpo TYPE TABLE OF ty_ekpo,
       wa_ekpo TYPE ty_ekpo.

TYPES : BEGIN OF ty_konv,
          knumv TYPE PRCD_ELEMENTS-knumv,
          kposn TYPE PRCD_ELEMENTS-kposn,
          kschl TYPE PRCD_ELEMENTS-kschl,
          kbetr TYPE PRCD_ELEMENTS-kbetr,
          kwert TYPE PRCD_ELEMENTS-kwert,
          waers TYPE PRCD_ELEMENTS-waers,
        END OF ty_konv.

DATA : gt_konv TYPE TABLE OF ty_konv,
       wa_konv TYPE ty_konv.

TYPES : BEGIN OF ty_makt,
          matnr TYPE matnr,
          maktx TYPE makt-maktx,
        END OF ty_makt.

DATA : gt_makt TYPE TABLE OF ty_makt,
       wa_makt TYPE ty_makt.

DATA : gt_final TYPE TABLE OF zmm_tax_final,
       wa_final TYPE zmm_tax_final.

DATA : lv_ebeln TYPE ekko-ebeln.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : i_vbeln TYPE mblnr OBLIGATORY.
PARAMETERS : p_mjahr TYPE mseg-mjahr OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR i_vbeln.
  PERFORM doc_no_help.

AT SELECTION-SCREEN ON i_vbeln.
  SELECT SINGLE mblnr FROM mseg INTO i_vbeln WHERE mblnr = i_vbeln AND ( bwart = '122' OR bwart = '161' ).
  IF sy-subrc <> 0.
    MESSAGE 'Invalid Input.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM sort_data.


FORM doc_no_help.
  TYPES : BEGIN OF t_doc,
            mblnr TYPE mblnr,
          END OF t_doc.
  DATA : hlp_tab TYPE TABLE OF t_doc.

  SELECT DISTINCT mblnr FROM mseg INTO TABLE hlp_tab WHERE bwart = '122' OR bwart = 161.

  IF sy-subrc EQ 0.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'MBLNR'
        value_org       = 'S'
        dynpprog        = 'ZMM_EXCISE_RETURN_DRVR'
        dynpnr          = '1000'
        dynprofield     = 'I_VBELN'
      TABLES
        value_tab       = hlp_tab
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .


  SELECT mblnr mjahr bukrs zeile bwart matnr werks lifnr ebeln ebelp menge meins
    FROM mseg INTO TABLE gt_mseg WHERE mblnr = i_vbeln
                                 AND   mjahr = p_mjahr
                                 AND  ( bwart = '122' OR bwart = '161' ).

  IF gt_mseg[] IS NOT INITIAL.

    SELECT ebeln ebelp mwskz FROM ekpo INTO TABLE gt_ekpo
      FOR ALL ENTRIES IN gt_mseg
      WHERE ebeln = gt_mseg-ebeln.

    SELECT  lifnr j_1iexcd j_1ilstno j_1icstno FROM j_1imovend INTO TABLE gt_ecc
        FOR ALL ENTRIES IN gt_mseg WHERE lifnr = gt_mseg-lifnr.

    SELECT matnr maktx FROM makt INTO TABLE gt_makt
          FOR ALL ENTRIES IN gt_mseg
          WHERE matnr = gt_mseg-matnr.

    SELECT mblnr mjahr xblnr bktxt budat frbnr cputm
      FROM mkpf INTO TABLE gt_mkpf
      FOR ALL ENTRIES IN gt_mseg
      WHERE mblnr = gt_mseg-mblnr
      AND   mjahr = gt_mseg-mjahr.

    SELECT lifnr name1 adrnr land1
     FROM lfa1 INTO TABLE gt_lfa1
     FOR ALL ENTRIES IN gt_mseg
     WHERE lifnr = gt_mseg-lifnr.

    IF sy-subrc = 0.

      SELECT addrnumber name1 street str_suppl3 location city2 city1 post_code1 region tel_number
        FROM adrc INTO TABLE gt_adrc
        FOR ALL ENTRIES IN gt_lfa1
        WHERE addrnumber = gt_lfa1-adrnr.

      IF sy-subrc = 0.

        SELECT land1 landx
          FROM t005t INTO TABLE gt_t005t
          FOR ALL ENTRIES IN gt_lfa1
          WHERE spras = 'EN'
           AND land1 = gt_lfa1-land1.



      ENDIF.
    ENDIF.
  ENDIF.


  IF gt_mkpf[] IS NOT INITIAL.

    SELECT exnum rdoc ryear budat cputm remtime
      FROM j_1iexchdr INTO TABLE gt_hdr
      FOR ALL ENTRIES IN gt_mkpf
      WHERE rdoc = gt_mkpf-mblnr.

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
  CLEAR lv_ebeln.
  LOOP AT gt_mseg INTO wa_mseg WHERE mblnr = i_vbeln
                               AND   mjahr = p_mjahr
                               AND  ( bwart = '122' OR bwart = '161' ).


    wa_final-bukrs = wa_mseg-bukrs.
    wa_final-mblnr = wa_mseg-mblnr.
    wa_final-mjahr = wa_mseg-mjahr.
    wa_final-zeile = wa_mseg-zeile.
    wa_final-bwart = wa_mseg-bwart.
    wa_final-matnr = wa_mseg-matnr.
    wa_final-werks = wa_mseg-werks.
    wa_final-lifnr = wa_mseg-lifnr.
    wa_final-ebeln = wa_mseg-ebeln.
    wa_final-ebelp = wa_mseg-ebelp.
    wa_final-menge = wa_mseg-menge.
    wa_final-meins = wa_mseg-meins.

    READ TABLE gt_ekpo INTO wa_ekpo WITH KEY ebeln = wa_mseg-ebeln.
    IF sy-subrc = 0.

      wa_final-mwskz = wa_ekpo-mwskz.

    ENDIF.


    READ TABLE gt_ecc INTO wa_ecc WITH KEY lifnr = wa_mseg-lifnr.
    IF sy-subrc = 0.  "j_1iexcd j_1ilstno j_1icstno

      wa_final-j_1iexcd = wa_ecc-j_1iexcd.
      wa_final-j_1ilstno = wa_ecc-j_1ilstno.
      wa_final-j_1icstno = wa_ecc-j_1icstno.

    ENDIF.


    READ TABLE gt_makt INTO wa_makt WITH KEY matnr = wa_mseg-matnr.
    IF sy-subrc = 0.

      wa_final-maktx = wa_makt-maktx.

    ENDIF.


    READ TABLE gt_mkpf INTO wa_mkpf WITH KEY mblnr = wa_mseg-mblnr mjahr = wa_mseg-mjahr.

    IF sy-subrc = 0.

      wa_final-xblnr = wa_mkpf-xblnr.
      wa_final-budat = wa_mkpf-budat.
      wa_final-bktxt = wa_mkpf-bktxt.
      wa_final-frbnr = wa_mkpf-frbnr.

      READ TABLE gt_hdr INTO wa_hdr WITH KEY rdoc = wa_mkpf-mblnr ryear = p_mjahr.

      IF sy-subrc = 0.  "exnum rdoc ryear budat cputm remtime

        wa_final-exnum = wa_hdr-exnum.
        wa_final-budat1 = wa_hdr-budat.
****  wa_final-ryear = wa_hdr-ryear.
        wa_final-cputm = wa_hdr-cputm.
        wa_final-remtime = wa_hdr-remtime.

      ELSE.

        wa_final-exnum = wa_mkpf-mblnr.
        wa_final-budat1 = wa_mkpf-budat.
        wa_final-cputm = wa_mkpf-cputm.

      ENDIF.

    ENDIF.

    READ TABLE gt_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_mseg-lifnr.

    IF sy-subrc = 0."lifnr name1 adrnr land1

      wa_final-lifnr = wa_lfa1-lifnr.
      wa_final-name1 = wa_lfa1-name1.
      wa_final-adrnr = wa_lfa1-adrnr.
      wa_final-land1 = wa_lfa1-land1.  "addrnumber name1 street str_suppl3 location city2 city1 post_code1 region tel_number


      READ TABLE gt_adrc INTO wa_adrc WITH KEY addrnumber = wa_lfa1-adrnr.

      IF sy-subrc = 0.

        wa_final-zname1_adr = wa_adrc-name1.
        wa_final-street = wa_adrc-street.
        wa_final-str_suppl3 = wa_adrc-str_suppl3.
        wa_final-location = wa_adrc-location.
        wa_final-city2 = wa_adrc-city2.
        wa_final-city1 = wa_adrc-city1.
        wa_final-post_code1 = wa_adrc-post_code1.
        wa_final-region = wa_adrc-region.
        wa_final-tel_number = wa_adrc-tel_number.

      ENDIF.

      READ TABLE gt_t005t INTO wa_t005t WITH KEY land1 = wa_lfa1-land1.

      IF sy-subrc = 0.

        wa_final-landx = wa_t005t-landx.

      ENDIF.

      SELECT SINGLE bezei FROM t005u INTO wa_final-bezei
           WHERE spras = 'E'
           AND   bland = wa_final-region
           AND   land1 = wa_lfa1-land1.


    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_final-bktxt
      IMPORTING
        output = lv_ebeln.


    APPEND wa_final TO gt_final.
  ENDLOOP.

  SELECT ebeln bukrs bedat knumv inco1 FROM ekko
    INTO TABLE gt_ekko
    FOR ALL ENTRIES IN gt_final
    WHERE ebeln = gt_final-ebeln.

  SELECT ebeln bukrs bedat knumv FROM ekko
    INTO TABLE gt_ekko1
    WHERE ebeln = lv_ebeln.

  IF gt_ekko[] IS NOT INITIAL.

    SELECT knumv kposn kschl kbetr kwert waers FROM PRCD_ELEMENTS
      INTO TABLE gt_konv
      FOR ALL ENTRIES IN gt_ekko
      WHERE knumv = gt_ekko-knumv .

  ENDIF.


  LOOP AT gt_final INTO wa_final.
    BREAK fujiabap.
    READ TABLE gt_ekko INTO wa_ekko WITH KEY ebeln = wa_final-ebeln.
    IF sy-subrc = 0.
      wa_final-budat_delpo = wa_ekko-bedat.
      wa_final-inco1 = wa_ekko-inco1.
      LOOP AT gt_konv INTO wa_konv WHERE knumv = wa_ekko-knumv  AND kposn = wa_final-ebelp. "( kschl = 'PBXX' OR kschl = 'PB00' )


        IF wa_konv-kschl = 'PBXX' OR wa_konv-kschl = 'PB00'.

          wa_final-kbetr = wa_konv-kbetr.
          wa_final-kwert = wa_konv-kbetr * wa_final-menge.

        ENDIF.

****        IF wa_konv-kschl = 'ZPFL' OR wa_konv-kschl = 'ZPC1' OR wa_konv-kschl = 'ZPFV' .
****
****          wa_final-zpnf = wa_konv-kbetr.
****
****        ENDIF.

****        IF wa_konv-kschl = 'ZINS'.
****
****          wa_final-zinsp = wa_konv-kbetr.
****
****        ENDIF.

        if wa_konv-kschl = 'ZAMV'.

           wa_final-zamv = wa_konv-kbetr.

         endif.

        wa_final-kschl = wa_konv-kschl.
        wa_final-waers = wa_konv-waers.
        wa_final-ztotal = wa_final-ztotal + wa_final-kwert.

        READ TABLE gt_ekko1 INTO wa_ekko1 INDEX 1.
        IF sy-subrc = 0.
          wa_final-budat_delpo = wa_ekko-bedat.
        ENDIF.
        MODIFY gt_final FROM wa_final.
****        clear wa_final.

      ENDLOOP.
    ENDIF.
  ENDLOOP.



  DATA : fm_name TYPE rs38l_fnam.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZMM_TAX_INVOICE'
    IMPORTING
      fm_name            = fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION fm_name
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
*     OUTPUT_OPTIONS             =
*     USER_SETTINGS              = 'X'
      i_vbeln  = i_vbeln
* IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
    TABLES
      gt_final = gt_final
* EXCEPTIONS
*     FORMATTING_ERROR           = 1
*     INTERNAL_ERROR             = 2
*     SEND_ERROR                 = 3
*     USER_CANCELED              = 4
*     OTHERS   = 5
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.












ENDFORM.
