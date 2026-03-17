*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Report ZASN_GRN_NEW                                                *
*&*&* 1.PROGRAM OWNER       : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : Report DEVLOPMENT
* 3.PROGRAM NAME            : ZASN_INBOUND_DELIVERY.                           *
* 4.TRANS CODE              :                                    *
* 5.MODULE NAME             : MM.                                 *
* 6.REQUEST NO              :                                *
* 7.CREATION DATE           : 21.02.2023.                              *
* 8.CREATED BY              : Nilay Brahme.                          *
* 9.FUNCTIONAL CONSULTANT   : Devshree Kalamkar.                                   *
* 10.BUSINESS OWNER         : DELVAL.                                *
*&---------------------------------------------------------------------*
REPORT zasn_invoicereceipt.

TABLES : mseg,bsik,bkpf, ekes, rseg,lfa1,bseg.
TYPE-POOLS : slis.


 TYPES:BEGIN OF ty_bseg,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          augbl TYPE bseg-augbl,
          koart TYPE bseg-koart,
          zlspr TYPE bseg-zlspr,
*          rebzg type bseg-rebzg,
          lifnr TYPE bseg-lifnr,
*          ebeln type bseg-ebeln,
*          ebelp type bseg-ebelp,
*          xref3 type bseg-xref3,
        END OF ty_bseg.

      TYPES:BEGIN OF ty_rseg,
          belnr TYPE rseg-belnr,
          gjahr TYPE rseg-gjahr,
          ebeln TYPE rseg-ebeln,
          ebelp TYPE rseg-ebelp,
         bukrs TYPE rseg-bukrs,
          lfbnr TYPE rseg-lfbnr,
        belnr1 TYPE char20,
        END OF ty_rseg.

       TYPES: BEGIN OF ty_mseg,
            mblnr TYPE mseg-mblnr,
            werks TYPE mseg-werks,
          lifnr TYPE mseg-lifnr,
          ebeln TYPE mseg-ebeln,
          ebelp TYPE mseg-ebelp,
          vbeln_im TYPE mseg-vbeln_im,
          vbelp_im TYPE mseg-vbelp_im,

        END OF ty_mseg.

        TYPES:BEGIN OF ty_ekes,
          erdat TYPE ekes-erdat,
          ebeln TYPE ekes-ebeln,
          ebelp TYPE ekes-ebelp,
          vbeln TYPE ekes-vbeln,
          vbelp TYPE ekes-vbelp,
        END OF ty_ekes.

         TYPES:BEGIN OF ty_bkpf,
        bukrs TYPE bkpf-bukrs,
        belnr TYPE bkpf-belnr,
        gjahr TYPE bkpf-gjahr,
        bldat TYPE bkpf-bldat,
        budat TYPE bkpf-budat,
        xblnr TYPE bkpf-xblnr,
        awkey  TYPE bkpf-awkey,
*        awkey1 TYPE char10,
*        awkey1  TYPE bkpf-awkey,
        END OF ty_bkpf.


        TYPES:BEGIN OF ty_lfm1,
          lifnr TYPE lfm1-lifnr,
          bstae TYPE lfm1-bstae,
        END OF ty_lfm1.

        TYPES:BEGIN OF ty_bsik,
          bukrs TYPE bsik-bukrs,
           gjahr TYPE bsik-gjahr,
           rebzg TYPE bsik-rebzg,
          dmbter TYPE bsik-dmbtr,
          END OF ty_bsik,

        BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          name1 TYPE lfa1-name1,
          END OF ty_lfa1,

        BEGIN OF ty_final,
          erdat TYPE ekes-erdat,
*          bukrs type bseg-bukrs,
          belnr TYPE rseg-belnr,
          gjahr TYPE bseg-gjahr,
          augbl TYPE bseg-augbl,
*          dmbtr type bseg-dmbtr,
          zlspr TYPE bseg-zlspr,
*          rebzg type bseg-rebzg,
          lifnr TYPE mseg-lifnr,
          belnr1 TYPE rseg-belnr,
          mblnr TYPE mseg-mblnr,
          ebeln TYPE ekes-ebeln,
          ebelp TYPE ekes-ebelp,
          vbeln TYPE ekes-vbeln,
          vbelp TYPE ekes-vbelp,
          bstae TYPE lfm1-bstae,
          dmbtr TYPE bsik-dmbtr,
          bldat TYPE char15,
        budat TYPE char15,
        xblnr TYPE bkpf-xblnr,
        awkey  TYPE bkpf-awkey,
          name1 TYPE lfa1-name1,
          payment_status TYPE string,
*          belnr TYPE rseg-belnr,
*          ebeln TYPE rseg-ebeln,
*          ebelp TYPE rseg-ebelp,
          rebzg          TYPE bseg-rebzg,
          lfbnr TYPE rseg-lfbnr,
          vbeln_im TYPE mseg-vbeln_im,
          vbelp_im TYPE mseg-vbelp_im,
        END OF ty_final,

        BEGIN OF ty_down,
          vbeln          TYPE ekes-vbeln,
          vbelp          TYPE ekes-vbelp,
          ebeln          TYPE ekes-ebeln,
          ebelp          TYPE ekes-ebeln,
          mblnr          TYPE mseg-mblnr,
          belnr1          TYPE rseg-belnr,
          belnr          TYPE bkpf-belnr,
          bldat          TYPE char15,
          budat          TYPE char15,
          xblnr          TYPE bkpf-xblnr,
          lifnr          TYPE bseg-lifnr,
          name1          TYPE lfa1-name1,
          zlspr          TYPE bseg-zlspr,
          payment_status TYPE string,
          ref_date       TYPE char15,
          ref_time       TYPE char15,
        END OF ty_down.

DATA : it_bkpf  TYPE STANDARD TABLE OF ty_bkpf,
       wa_bkpf  TYPE ty_bkpf,
       it_bseg  TYPE STANDARD TABLE OF ty_bseg,
       wa_bseg  TYPE ty_bseg,
       it_lfa1  TYPE STANDARD TABLE OF ty_lfa1,
       wa_lfa1  TYPE ty_lfa1,
       it_ekes  TYPE STANDARD TABLE OF ty_ekes,
       wa_ekes  TYPE ty_ekes,
       it_mseg  TYPE STANDARD TABLE OF ty_mseg,
       wa_mseg  TYPE ty_mseg,

       it_bsik  TYPE STANDARD TABLE OF ty_bsik,
       wa_bsik  TYPE ty_bsik,
       it_rseg  TYPE STANDARD TABLE OF ty_rseg,
       wa_rseg  TYPE ty_rseg,
       it_lfm1  TYPE STANDARD TABLE OF ty_lfm1,
       wa_lfm1  TYPE ty_lfm1,
       it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final,
       it_down  TYPE STANDARD TABLE OF ty_down,
       wa_down  TYPE ty_down,
       it_fcat  TYPE slis_t_fieldcat_alv,
       wa_fcat  TYPE slis_fieldcat_alv.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS : s_bukrs FOR bkpf-bukrs,
                 s_erdat FOR ekes-erdat,
*                 s_budat FOR bkpf-budat,
*                 s_belnr for bseg-belnr,
                 s_lifnr FOR bseg-lifnr,
                 s_vbeln FOR ekes-vbeln.


SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.   "TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/delval/temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM get_data.
  PERFORM build_fieldcat.
  PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .
SELECT erdat
       ebeln
       ebelp
       vbeln
       vbelp
  FROM ekes INTO TABLE it_ekes
  WHERE vbeln IN s_vbeln
  AND   erdat IN S_ERDAT.


IF it_ekes[] IS NOT INITIAL.
SELECT mblnr
       werks
       lifnr
       ebeln
       ebelp
       vbeln_im
       vbelp_im
       FROM mseg INTO TABLE it_mseg
      FOR ALL ENTRIES IN it_ekes
      WHERE ebeln = it_ekes-ebeln
      AND   ebelp = it_ekes-ebelp
      AND vbeln_im = it_ekes-vbeln
      AND   vbelp_im = it_ekes-vbelp
*      AND   lifnr in s_lifnr
      AND werks = 'PL01'.
ENDIF.
IF it_mseg[] IS NOT INITIAL.
    SELECT belnr
           gjahr
           ebeln
           ebelp
           bukrs
           lfbnr
      FROM rseg INTO TABLE it_rseg
      FOR ALL ENTRIES IN it_mseg
      WHERE lfbnr = it_mseg-mblnr
      AND   ebeln = it_mseg-ebeln
      AND   ebelp = it_mseg-ebelp.
ENDIF.

LOOP AT it_rseg INTO wa_rseg.
CONCATENATE wa_rseg-belnr wa_rseg-gjahr INTO wa_rseg-belnr1.

MODIFY it_rseg  FROM wa_rseg TRANSPORTING belnr1.
ENDLOOP.

IF it_rseg[] IS NOT INITIAL.
SELECT  bukrs
        belnr
        gjahr
        bldat
        budat
        xblnr
        awkey
        FROM bkpf INTO TABLE it_bkpf
        FOR ALL ENTRIES IN it_rseg
        WHERE awkey = it_rseg-belnr1
        AND   bukrs  IN s_bukrs.
ENDIF.

IF it_bkpf[] IS NOT INITIAL.
  SELECT bukrs
           belnr
           gjahr
           augbl
           koart
           zlspr
           lifnr
           FROM bseg INTO TABLE it_bseg
           FOR ALL ENTRIES IN it_bkpf
           WHERE bukrs IN s_bukrs
           AND   gjahr = it_bkpf-gjahr
           AND   belnr = it_bkpf-belnr
           AND   koart = 'K'.

ENDIF.


IF it_bseg[] IS NOT INITIAL.


   SELECT lifnr
          name1
          FROM lfa1 INTO TABLE it_lfa1
          FOR ALL ENTRIES IN it_bseg
          WHERE lifnr = it_bseg-lifnr.


     SELECT bukrs
           gjahr
           rebzg
           dmbtr
      FROM bsik INTO TABLE it_bsik
      FOR ALL ENTRIES IN it_bseg
      WHERE bukrs = it_bseg-bukrs
      AND gjahr = it_bseg-gjahr
      AND rebzg = it_bseg-belnr.
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

LOOP AT it_ekes INTO wa_ekes WHERE vbeln IN s_vbeln  AND erdat IN S_ERDAT..
    wa_final-erdat = wa_ekes-erdat.
    wa_final-vbeln = wa_ekes-vbeln.
    wa_final-vbelp = wa_ekes-vbelp.
    wa_final-ebeln = wa_ekes-ebeln.
    wa_final-ebelp = wa_ekes-ebelp.
*
*
     READ TABLE it_mseg INTO wa_mseg WITH KEY ebeln = wa_ekes-ebeln ebelp = wa_ekes-ebelp vbeln_im = wa_ekes-vbeln vbelp_im = wa_ekes-vbelp werks = 'PL01'.
      IF sy-subrc = 0.
        wa_final-mblnr = wa_mseg-mblnr.
        wa_final-lifnr = wa_mseg-lifnr.
        wa_final-vbeln_im = wa_mseg-vbeln_im.
        wa_final-vbelp_im = wa_mseg-vbelp_im.

      endif.
      READ TABLE it_rseg INTO wa_rseg WITH KEY lfbnr = wa_mseg-mblnr .
     if wa_mseg-mblnr is NOT INITIAL.

*      wa_final-ebeln = wa_rseg-ebeln.
*      wa_final-ebelp = wa_rseg-ebelp.
      wa_final-belnr = wa_rseg-belnr.
      wa_final-belnr1 = wa_rseg-belnr1.
      wa_final-lfbnr = wa_rseg-lfbnr.
    ENDIF.
    READ TABLE  it_bkpf INTO wa_bkpf WITH  KEY  awkey = wa_rseg-belnr1 .
    IF wa_rseg-belnr1 IS NOT INITIAL.

      wa_final-belnr = wa_bkpf-belnr.
      wa_final-bldat = wa_bkpf-bldat.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-bldat
        IMPORTING
          output = wa_final-bldat.
      CONCATENATE wa_final-bldat+0(2) wa_final-bldat+2(3) wa_final-bldat+5(4)
       INTO wa_final-bldat SEPARATED BY '-'.

      wa_final-budat = wa_bkpf-budat.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-budat
        IMPORTING
          output = wa_final-budat.
      CONCATENATE wa_final-budat+0(2) wa_final-budat+2(3) wa_final-budat+5(4)
       INTO wa_final-budat SEPARATED BY '-'.

      wa_final-xblnr = wa_bkpf-xblnr.
      wa_final-belnr1 = wa_bkpf-awkey.
     ENDIF.

    READ TABLE it_bseg INTO wa_bseg WITH KEY bukrs = wa_bkpf-bukrs belnr = wa_bkpf-belnr gjahr = wa_bkpf-gjahr koart = 'K'." lifnr = s_lifnr.

    IF wa_bkpf-belnr IS NOT INITIAL.
      wa_final-zlspr = wa_bseg-zlspr.
      wa_final-augbl = wa_bseg-augbl.
      wa_final-lifnr = wa_bseg-lifnr.

    IF wa_final-augbl IS NOT INITIAL.
      wa_final-payment_status = 'Y'.
    ELSEIF wa_final-augbl IS INITIAL.
      wa_final-payment_status = 'N'.
    ENDIF.
      ENDIF.
    READ TABLE it_bsik INTO wa_bsik WITH KEY bukrs = wa_bseg-bukrs gjahr = wa_bseg-gjahr rebzg = wa_bseg-belnr.
    IF wa_bseg-belnr IS NOT INITIAL.
      wa_final-rebzg = wa_bsik-rebzg.
    ENDIF.
*
    IF wa_final-rebzg IS NOT INITIAL.
      wa_final-payment_status = 'P'.
    ENDIF.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH  KEY lifnr = wa_mseg-lifnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    ENDIF.


    APPEND wa_final TO it_final.

    CLEAR: wa_final,wa_rseg,wa_bkpf,wa_mseg,wa_bseg,wa_lfa1,wa_bsik.
*ENDIF.

*LOOP AT IT_FINAL.
*  IF  WA_FINAL-mblnr is NOT INITIAL.
*
*  ENDIF.
ENDLOOP.
CLEAR:wa_ekes.
DELETE IT_FINAL WHERE vbeln is INITIAL.
 SORT IT_FINAL ASCENDING BY VBELN VBELP EBELP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat .
 SORT IT_FINAL ASCENDING BY VBELN.
  wa_fcat-col_pos = '1'.
  wa_fcat-fieldname = 'VBELN'.
  wa_fcat-seltext_m = 'Inbound Delivery.'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '2'.
  wa_fcat-fieldname = 'VBELP'.
  wa_fcat-seltext_m = 'Inbound Item No.'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '3'.
  wa_fcat-fieldname = 'EBELN'.
  wa_fcat-seltext_m = 'Purchasing Doc.'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '4'.
  wa_fcat-fieldname = 'EBELP'.
  wa_fcat-seltext_m = 'PO Item No.'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '5'.
  wa_fcat-fieldname = 'MBLNR'.
  wa_fcat-seltext_m = 'GRN No.(MIGO)'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '6'.
  wa_fcat-fieldname = 'BELNR1'.
  wa_fcat-seltext_m = 'Invoice No.(MIRO)'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '7'.
  wa_fcat-fieldname = 'BELNR'.
  wa_fcat-seltext_m = 'AC Document No.'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '8'.
  wa_fcat-fieldname = 'BLDAT'.
  wa_fcat-seltext_m = 'AC Document Date'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '9'.
  wa_fcat-fieldname = 'BUDAT'.
  wa_fcat-seltext_m = 'AC Posting Date'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '10'.
  wa_fcat-fieldname = 'XBLNR'.
  wa_fcat-seltext_m = 'Reference'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.


  wa_fcat-col_pos = '11'.
  wa_fcat-fieldname = 'LIFNR'.
  wa_fcat-seltext_m = 'Vendor Code'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '12'.
  wa_fcat-fieldname = 'NAME1'.
  wa_fcat-seltext_m = 'Vendor Name'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.


  wa_fcat-col_pos = '13'.
  wa_fcat-fieldname = 'ZLSPR'.
  wa_fcat-seltext_m = 'Invoice Blocking Status'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

   wa_fcat-col_pos = '14'.
  wa_fcat-fieldname = 'PAYMENT_STATUS'.
  wa_fcat-seltext_m = 'Payment Status'.
  wa_fcat-outputlen = '20'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

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
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
*     I_CALLBACK_PROGRAM                = ' '
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT   =
      it_fieldcat = it_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT     =
*     IT_FILTER   =
*     IS_SEL_HIDE =
*     I_DEFAULT   = 'X'
*     I_SAVE      = ' '
*     IS_VARIANT  =
*     IT_EVENTS   =
*     IT_EVENT_EXIT                     =
*     IS_PRINT    =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*  IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab    = it_final
*  EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS      = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
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

  LOOP AT it_final INTO wa_final.
    wa_down-VBELN = wa_final-vbeln.
    wa_down-vbelp = wa_final-vbelp.
    wa_down-ebeln = wa_final-ebeln.
    wa_down-ebelp = wa_final-ebelp.
    wa_down-mblnr = wa_final-mblnr.
    wa_down-belnr1 = wa_final-belnr1.
    wa_down-belnr = wa_final-belnr.
    wa_down-bldat = wa_final-bldat.
    wa_down-budat = wa_final-budat.
    wa_down-xblnr = wa_final-xblnr.
    wa_down-lifnr = wa_final-lifnr.
    wa_down-name1 = wa_final-name1.
    wa_down-ZLSPR = wa_final-ZLSPR.
    wa_down-payment_status = wa_final-payment_status.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_down-ref_date.
    CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
    INTO wa_down-ref_date SEPARATED BY '-'.

    wa_down-ref_time = sy-uzeit.
    CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

    APPEND wa_down TO it_down.
    CLEAR wa_down.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_file .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
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
  lv_file = 'ZASN_INVOICERECEIPT.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZASN INVOICE RECEIPT PROGRAM Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_688 TYPE string.
DATA lv_crlf_688 TYPE string.
lv_crlf_688 = cl_abap_char_utilities=>cr_lf.
lv_string_688 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_688 lv_crlf_688 wa_csv INTO lv_string_688.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_688 TO lv_fullfile.
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
  data: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  concatenate 'Inbound Delivery No.'
              'Inbound Item No.'
              'Purchasing Document'
              'PO Item No.'
              'GRN No.(MIGO)'
              'Invoice No.(MIRO)'
              'AC Document No.'
              'AC Document Date'
              'Posting Date'
              'Reference'
              'Vendor Code'
              'Vendor Name'
              'Invoice Blocking Status'
              'Payment Status'
              'Refresh Date'
              'Refresh Time'
              into p_hd_csv
 separated by l_field_seperator.

ENDFORM.
