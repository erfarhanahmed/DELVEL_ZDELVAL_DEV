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
REPORT zasn_inbound_delivery.

TABLES : ekes, ekko, ekpo,lfa1.
TYPE-POOLS : slis.
TYPES : BEGIN OF ty_ekes,
          ebeln TYPE ekes-ebeln,
          ebelp TYPE ekes-ebelp,
          erdat TYPE ekes-erdat,
          vbeln TYPE ekes-vbeln,
          xblnr TYPE ekes-xblnr,
        END OF ty_ekes.

TYPES : BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,
          lifnr TYPE ekko-lifnr,
        END OF ty_ekko.

TYPES : BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,
          werks TYPE ekpo-werks,

        END OF ty_ekpo.

TYPES : BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          name1 TYPE lfa1-name1,
        END OF ty_lfa1.

TYPES : BEGIN OF ty_final,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekes-ebelp,
          erdat TYPE char15,
          xblnr TYPE ekes-xblnr,
          vbeln TYPE ekes-vbeln,
          vbelp TYPE ekes-vbelp,
          lifnr TYPE ekko-lifnr,
          name1 TYPE lfa1-name1,
        END OF ty_final.

TYPES : BEGIN OF ty_down,
          vbeln    TYPE ekes-vbeln,
          ebeln    TYPE ekes-ebeln,
          ebelp    TYPE ekes-ebelp,
          erdat    TYPE char15,     "mkpf-bldat,
          lifnr    TYPE mseg-lifnr,
          name1    TYPE lfa1-name1,
          xblnr TYPE ekes-xblnr,
          ref_date TYPE char15,
          ref_time TYPE char15,
        END OF ty_down.

DATA : it_ekes  TYPE STANDARD TABLE OF ty_ekes,
       wa_ekes  TYPE ty_ekes,
       it_ekko  TYPE STANDARD TABLE OF ty_ekko,
       wa_ekko  TYPE ty_ekko,
       it_ekpo  TYPE STANDARD TABLE OF ty_ekpo,
       wa_ekpo  TYPE ty_ekpo,
       it_lfa1  TYPE STANDARD TABLE OF ty_lfa1,
       wa_lfa1  TYPE ty_lfa1,
       it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final,
       it_down  TYPE STANDARD TABLE OF ty_down,
       wa_down  TYPE ty_down,
       it_fcat  TYPE slis_t_fieldcat_alv,
       wa_fcat  LIKE LINE OF it_fcat.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS : s_vbeln FOR ekes-vbeln,
                 s_erdat FOR ekes-erdat OBLIGATORY  ,
                 s_lifnr FOR ekko-lifnr.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.   "TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM get_data.
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
  SELECT ebeln
         ebelp
         erdat
         vbeln
         xblnr
    FROM ekes INTO TABLE it_ekes
    WHERE vbeln IN s_vbeln
    AND erdat IN s_erdat.
DELETE ADJACENT DUPLICATES FROM IT_EKES COMPARING EBELN VBELN xblnr.

IF  it_ekes[] IS NOT INITIAL.
    SELECT ebeln
           werks
 FROM ekpo INTO TABLE it_ekpo
          FOR ALL ENTRIES IN it_ekes
          WHERE ebeln = it_ekes-ebeln
          AND   werks = 'PL01'.
ENDIF.

*DELETE ADJACENT DUPLICATES FROM IT_EKPO COMPARING EBELN .
IF it_ekpo[] IS NOT INITIAL.
  SELECT ebeln
         lifnr
         FROM ekko INTO TABLE it_ekko
         FOR ALL ENTRIES IN it_ekpo
         WHERE ebeln = it_ekpo-ebeln
         AND   lifnr IN s_lifnr.

ENDIF.


IF it_ekko[] IS NOT INITIAL.
 SELECT lifnr
        name1
        FROM lfa1 INTO TABLE it_lfa1
        FOR ALL ENTRIES IN it_ekko
        WHERE lifnr = it_ekko-lifnr.
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
   LOOP AT it_ekes INTO wa_ekes    .
      wa_final-vbeln = wa_ekes-vbeln.
      wa_final-ebeln = wa_ekes-ebeln.
      wa_final-ebelp = wa_ekes-ebelp.
      wa_final-xblnr = wa_ekes-xblnr.
      wa_final-erdat = wa_ekes-erdat.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-erdat
      IMPORTING
        output = wa_final-erdat.
    CONCATENATE wa_final-erdat+0(2) wa_final-erdat+2(3) wa_final-erdat+5(4)
    INTO wa_final-erdat SEPARATED BY '-'.
  LooP AT  it_ekpo INTO wa_ekpo WHERE  ebeln = wa_ekes-ebeln.
         wa_final-ebeln = wa_ekes-ebeln.

  READ TABLE it_ekko INTO wa_ekko WITH  KEY ebeln = wa_ekpo-ebeln.
     wa_final-lifnr = wa_ekko-lifnr.

  READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_ekko-lifnr.
     wa_final-lifnr = wa_lfa1-lifnr.
     wa_final-name1 = wa_lfa1-name1.

    APPEND wa_final TO it_final.
    CLEAR : wa_final.
    CLEAR: wa_ekko,wa_lfa1.
    ENDLOOP.
    CLEAR:wa_ekpo.
 ENDLOOP.


CLEAR:wa_ekes.
*DELETE ADJACENT DUPLICATES FROM it_final COMPARING ebeln   .
 SORT it_final ASCENDING BY ebeln EBELP vbeln .
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

  wa_fcat-col_pos = '1'.
  wa_fcat-fieldname = 'VBELN'.
  wa_fcat-seltext_m = 'Inbound Delivery'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '2'.
  wa_fcat-fieldname = 'EBELN'.
  wa_fcat-seltext_m = 'PO No.'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '3'.
  wa_fcat-fieldname = 'EBELP'.
  wa_fcat-seltext_m = 'PO Line Item.'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '4'.
  wa_fcat-fieldname = 'ERDAT'.
  wa_fcat-seltext_m = 'Creation Date'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '5'.
  wa_fcat-fieldname = 'LIFNR'.
  wa_fcat-seltext_m = 'Vendor'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '6'.
  wa_fcat-fieldname = 'NAME1'.
  wa_fcat-seltext_m = 'Vendor Name'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  wa_fcat-col_pos = '7'.
  wa_fcat-fieldname = 'XBLNR'.
  wa_fcat-seltext_m = 'Invoice Receipt'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
* EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
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

    wa_down-vbeln = wa_final-vbeln.
    wa_down-ebeln = wa_final-ebeln.
    wa_down-ebelp = wa_final-ebelp.
    wa_down-erdat = wa_final-erdat.
    wa_down-lifnr = wa_final-lifnr.
    wa_down-name1 = wa_final-name1.
    wa_down-xblnr = wa_final-xblnr.

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
  lv_file = 'ZASN_INBOUND.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZASN INBOUND Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_396 TYPE string.
DATA lv_crlf_396 TYPE string.
lv_crlf_396 = cl_abap_char_utilities=>cr_lf.
lv_string_396 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_396 lv_crlf_396 wa_csv INTO lv_string_396.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_396 TO lv_fullfile.
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
  CONCATENATE 'Inbound Delivery'
              'Purchase Document'
              'Line Item'
              'Inbound Delivery Creation Date'
              'Vendor'
              'Vendor Name'
              'Invoice Receipt'
              'Refresh Date'
              'Refresh Time'
              INTO p_hd_csv
 SEPARATED BY l_field_seperator.

ENDFORM.
