*&---------------------------------------------------------------------*
*& Report ZASN_GRN
*&---------------------------------------------------------------------*
*&Report: ZASN_GRN
*&Transaction: ZASN_DETAILS
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Diksha Halve
*&TR: DEVK910869
*&Date: 03.02.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
report zasn_grn.

tables : ekes, mseg, mkpf,LFA1.
type-pools : slis.
types : begin of ty_ekes,
          ebeln type ekes-ebeln,
          erdat type ekes-erdat,
          vbeln type ekes-vbeln,
          xblnr TYPE ekes-xblnr,
        end of ty_ekes.

types : begin of ty_mseg,
          mblnr type mseg-mblnr,
          bwart type mseg-bwart,
          werks TYPE mseg-werks,
          lifnr type mseg-lifnr,
          ebeln type mseg-ebeln,
          vbeln_im TYPE mseg-vbeln_im,
        end of ty_mseg.

types : begin of ty_mkpf,
          mblnr type mkpf-mblnr,
          bldat type mkpf-bldat,
          budat type mkpf-budat,
          xblnr type mkpf-xblnr,
          frbnr type mkpf-frbnr,
        end of ty_mkpf.

types : begin of ty_lfa1,
          lifnr type lfa1-lifnr,
          name1 type lfa1-name1,
        end of ty_lfa1.

types : begin of ty_final,
          mblnr    type mseg-mblnr,
          erdat type char15,
          xblnr    type mkpf-xblnr,
          frbnr    type mkpf-frbnr,
          lifnr    type mseg-lifnr,
          name1    type lfa1-name1,
          vbeln    type ekes-vbeln,
          vbeln_im TYPE mseg-vbeln_im,
          ebeln    TYPE EKES-EBELN,
          bwart    TYPE mseg-bwart,
        end of ty_final.

types : begin of ty_down,
          mblnr    type mseg-mblnr,
          erdat type char15,
          xblnr    type mkpf-xblnr,
          frbnr    type mkpf-frbnr,
          lifnr    type mseg-lifnr,
          name1    type lfa1-name1,
          vbeln    type ekes-vbeln,
          bwart    TYPE mseg-bwart,
          ref_date type char15,
          ref_time type char15,
        end of ty_down.

data : it_ekes  type standard table of ty_ekes,
       wa_ekes  type ty_ekes,
       it_mseg  type standard table of ty_mseg,
       wa_mseg  type ty_mseg,
       it_mkpf  type standard table of ty_mkpf,
       wa_mkpf  type ty_mkpf,
       it_lfa1  type standard table of ty_lfa1,
       wa_lfa1  type ty_lfa1,
       it_final type standard table of ty_final,
       wa_final type ty_final,
       it_down  type standard table of ty_down,
       wa_down  type ty_down,
       it_fcat  type slis_t_fieldcat_alv,
       wa_fcat  like line of it_fcat.

selection-screen : begin of block b1 with frame.
select-options : s_vbeln for ekes-vbeln,
                 s_erdat for ekes-erdat,
                 s_lifnr for mseg-lifnr.
selection-screen : end of block b1.

selection-screen begin of block b2 with frame.   "TITLE TEXT-002 .
parameters p_down as checkbox.
parameters p_folder like rlgrap-filename default '/Delval/India'."India'."temp'.
selection-screen end of block b2.

selection-screen :begin of block b3 with frame title text-003.
selection-screen  comment /1(60) text-004.
selection-screen: end of block b3.

start-of-selection.

  perform fetch_data.
  perform get_data.
  perform display.

*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fetch_data .
  select ebeln
         erdat
         vbeln
         xblnr
    from ekes into table it_ekes
    where vbeln in s_vbeln
    and erdat in s_erdat.

  if it_ekes is not initial.
    select mblnr
           bwart
           werks
           lifnr
           ebeln
           vbeln_im
      from mseg into table it_mseg
      for all entries in it_ekes
      where ebeln = it_ekes-ebeln
      and lifnr in s_lifnr
      and bwart = '101'
      and werks = 'PL01'
      AND vbeln_im IN s_vbeln.
      .
DELETE ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr.


    if it_mseg is not initial.
      select mblnr
             bldat
             budat
             xblnr
             frbnr
        from mkpf into table it_mkpf
        for all entries in it_mseg
        where mblnr = it_mseg-mblnr.

      select lifnr
             name1
        from lfa1 into table it_lfa1
        for all entries in it_mseg
        where lifnr = it_mseg-lifnr.

    endif.

  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data .

LOOP AT it_mseg INTO wa_mseg WHERE vbeln_im IN s_vbeln AND bwart = '101' AND werks = 'PL01'.
      wa_final-ebeln = wa_mseg-ebeln.
      wa_final-mblnr = wa_mseg-mblnr.
      wa_final-lifnr = wa_mseg-lifnr.
      wa_final-bwart = wa_mseg-bwart.
      wa_final-vbeln_im = wa_mseg-vbeln_im.

 READ TABLE IT_ekes INTO wa_ekes WITH KEY ebeln = wa_mseg-ebeln.
 if sy-subrc = 0.
      wa_final-vbeln = wa_ekes-vbeln.
      wa_final-ebeln = wa_ekes-ebeln.
      wa_final-xblnr = wa_ekes-xblnr.
      wa_final-erdat = wa_ekes-erdat.
      call function 'CONVERSION_EXIT_IDATE_OUTPUT'
      exporting
        input  = wa_final-erdat
      importing
        output = wa_final-erdat.
    concatenate wa_final-erdat+0(2) wa_final-erdat+2(3) wa_final-erdat+5(4)
    into wa_final-erdat separated by '-'.
ENDIF.
    read table it_lfa1 into wa_lfa1 with key lifnr = wa_mseg-lifnr.
    if sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    endif.

  READ TABLE  it_mkpf into wa_mkpf WITH  KEY MBLNR = wa_mseg-mblnr.
  if sy-subrc = 0.
    wa_final-mblnr = wa_mseg-mblnr.
    wa_final-xblnr = wa_mkpf-xblnr.
    wa_final-frbnr = wa_mkpf-frbnr.
  ENDIF.

    append wa_final to it_final.
    clear : wa_final,wa_mseg,wa_mkpf,wa_lfa1,wa_ekes.

ENDLOOP.
CLEAR:wa_mseg.
DELETE ADJACENT DUPLICATES FROM IT_FINal COMPARING MBLNR.
SORT IT_FINAL ASCENDING BY VBELN ERDAT.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display .

  wa_fcat-col_pos = '1'.
  wa_fcat-fieldname = 'MBLNR'.
  wa_fcat-seltext_m = 'GRN/Material Document'.
  wa_fcat-outputlen = 40.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '2'.
  wa_fcat-fieldname = 'ERDAT'.
  wa_fcat-seltext_m = 'Inbound Date'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '3'.
  wa_fcat-fieldname = 'XBLNR'.
  wa_fcat-seltext_m = 'Reference Document'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '4'.
  wa_fcat-fieldname = 'FRBNR'.
  wa_fcat-seltext_m = 'Bill of Lading'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '5'.
  wa_fcat-fieldname = 'LIFNR'.
  wa_fcat-seltext_m = 'Vendor'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '6'.
  wa_fcat-fieldname = 'NAME1'.
  wa_fcat-seltext_m = 'Vendor Name'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '7'.
  wa_fcat-fieldname = 'VBELN'.
  wa_fcat-seltext_m = 'Inbound Delivery'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '8'.
  wa_fcat-fieldname = 'BWART'.
  wa_fcat-seltext_m = 'Movement Type'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
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
      it_fieldcat        = it_fcat[]
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
    tables
      t_outtab           = it_final[]
* EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

  if p_down = 'X'.

    perform download.
    perform download_file.
  endif.


endform.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form download .
   LOOP AT it_final INTO wa_final.

    wa_down-mblnr = wa_final-mblnr.
    wa_down-erdat = wa_final-erdat.
    wa_down-xblnr = wa_final-xblnr.
    wa_down-frbnr = wa_final-frbnr.
    wa_down-lifnr = wa_final-lifnr.
    wa_down-name1 = wa_final-name1.
    wa_down-vbeln = wa_final-vbeln.
    wa_down-bwart = wa_final-bwart.

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

  DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING MBLNR.
  SORT IT_FINAL ASCENDING BY VBELN.
*  CLEAR:WA_FINAL.
endform.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form download_file .
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
  lv_file = 'ZASN_GRN.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZASN GRN Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_429 TYPE string.
DATA lv_crlf_429 TYPE string.
lv_crlf_429 = cl_abap_char_utilities=>cr_lf.
lv_string_429 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_429 lv_crlf_429 wa_csv INTO lv_string_429.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_429 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
endform.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
form cvs_header  using    p_hd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'GRN/MAterial Document'
              'Inbound Delivery Creation Date'
              'Reference Documnet'
              'Bill Of Lading'
              'Vendor'
              'Vendor Name'
              'Inbound Delivery'
              'Movement Type'
              'Refresh Date'
              'Refresh Time'

              INTO p_hd_csv
 SEPARATED BY l_field_seperator.

endform.
