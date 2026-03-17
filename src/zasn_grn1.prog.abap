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
report zasn_grn1.

tables : mseg, LFA1.
type-pools : slis.

types : begin of ty_mseg,
          mblnr type mseg-mblnr,
          bwart type mseg-bwart,
          werks TYPE mseg-werks,
          lifnr type mseg-lifnr,
          smbln TYPE mseg-smbln,
          vbeln_im TYPE mseg-vbeln_im,
          BUDAT_mkpf TYPE mseg-budat_mkpf,
          xblnr_mkpf TYPE mseg-xblnr_mkpf,
         end of ty_mseg.


types : begin of ty_lfa1,
          lifnr type lfa1-lifnr,
          name1 type lfa1-name1,
        end of ty_lfa1.

types : begin of ty_final,
          mblnr type mseg-mblnr,
          lv_grN type mseg-mblnr,
          bwart type mseg-bwart,
          werks TYPE mseg-werks,
          lifnr type mseg-lifnr,
          smbln type mseg-smbln,
          ebeln type mseg-ebeln,
          vbeln_im TYPE mseg-vbeln_im,
          BUDAT_mkpf TYPE char15,
          CPUTM_MKPF TYPE MSEG-CPUTM_MKPF,
          xblnr_mkpf TYPE mseg-xblnr_mkpf,
          name1 type lfa1-name1,

        end of ty_final.

types : begin of ty_down,
          mblnr    type mseg-mblnr,
          BUDAT_mkpf TYPE char15,
          xblnr_mkpf TYPE mseg-xblnr_mkpf,
          lifnr    type mseg-lifnr,
          name1    type lfa1-name1,
          vbeln_im TYPE mseg-vbeln_im,
          ref_date type char15,
          ref_time type char15,
        end of ty_down.

data : it_mseg  type standard table of ty_mseg,
       wa_mseg  type ty_mseg,
       it_mseg1  type standard table of ty_mseg,
       wa_mseg1  type ty_mseg,
       it_lfa1  type standard table of ty_lfa1,
       wa_lfa1  type ty_lfa1,
       it_final type standard table of ty_final,
       wa_final type ty_final,
       it_final1 type standard table of ty_final,
       wa_final1 type ty_final,
       it_down  type standard table of ty_down,
       wa_down  type ty_down,
       it_fcat  type slis_t_fieldcat_alv,
       wa_fcat  like line of it_fcat.

selection-screen : begin of block b1 with frame.
select-options : s_vbeln for mseg-vbeln_im,
                 s_erdat for mseg-budat_mkpf,
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


    select mblnr
           bwart
           werks
           lifnr
           smbln
           vbeln_im
           BUDAT_mkpf
           xblnr_mkpf
      from mseg into table it_mseg
      where lifnr in s_lifnr
      and bwart = '101'
      and werks = 'PL01'
      AND vbeln_im NE s_vbeln
      AND BUDAT_mkpf IN S_erdat
      .
      .
DELETE ADJACENT DUPLICATES FROM IT_MSEG COMPARING MBLNR VBELN_IM XBLNR_MKPF.
if it_mseg[] IS NOT INITIAL.

  SELECT   mblnr
           bwart
           werks
           lifnr
           smbln
           vbeln_im
           BUDAT_mkpf
           xblnr_mkpf
           from mseg INTO TABLE IT_mseg1
           FOR ALL ENTRIES IN IT_MSEG
           WHERE SMBLN = IT_MSEG-mblnr
           AND BWART = '102'.



      select lifnr
             name1
        from lfa1 into table it_lfa1
        for all entries in it_mseg
        where lifnr = it_mseg-lifnr.

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

LOOP AT it_mseg INTO wa_mseg .
     READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH  KEY smbln = wa_mseg-mblnr.
      IF sy-subrc = 4.
      wa_final-mblnr = wa_mseg-mblnr.
      wa_final-lifnr = wa_mseg-lifnr.
      wa_final-xblnr_mkpf = wa_mseg-xblnr_mkpf.
      wa_final-smbln = wa_mseg-smbln.
      wa_final-vbeln_im = wa_mseg-vbeln_im.
      wa_final-bwart = wa_mseg-bwart.
      wa_final-budat_mkpf = wa_mseg-budat_mkpf.

    call function 'CONVERSION_EXIT_IDATE_OUTPUT'
      exporting
        input  = wa_final-budat_mkpf
      importing
        output = wa_final-budat_mkpf.
    concatenate wa_final-budat_mkpf+0(2) wa_final-budat_mkpf+2(3) wa_final-budat_mkpf+5(4)
    into wa_final-budat_mkpf separated by '-'.


    read table it_lfa1 into wa_lfa1 with key lifnr = wa_mseg-lifnr.
    if sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    endif.
    DATA : LV_GRN TYPE mblnr.


*  CLEAR:WA_FINAL1,WA_FINAL.

    append wa_final to it_final.
    clear : wa_final,wa_mseg,wa_lfa1,LV_GRN,wa_mseg1.
 ENDIF.
ENDLOOP.
CLEAR:wa_mseg.
DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING  VBELN_IM XBLNR_MKPF.


*DELETE ADJACENT DUPLICATES FROM IT_FINal COMPARING ALL FIELDS.
SORT IT_FINAL ASCENDING BY VBELN_IM.

*
*IT_FINAL1[] = IT_FINAL[].



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
  wa_fcat-fieldname = 'BUDAT_MKPF'.
  wa_fcat-seltext_m = 'Entry Date'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '3'.
  wa_fcat-fieldname = 'XBLNR_MKPF'.
  wa_fcat-seltext_m = 'Reference Document'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '4'.
  wa_fcat-fieldname = 'LIFNR'.
  wa_fcat-seltext_m = 'Vendor'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '5'.
  wa_fcat-fieldname = 'NAME1'.
  wa_fcat-seltext_m = 'Vendor Name'.
  wa_fcat-outputlen = 30.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '6'.
  wa_fcat-fieldname = 'VBELN_IM'.
  wa_fcat-seltext_m = 'Inbound Delivery'.
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
    wa_down-BUDAT_mkpf = wa_final-BUDAT_mkpf.
    wa_down-xblnr_mkpf = wa_final-xblnr_mkpf.
    wa_down-lifnr = wa_final-lifnr.
    wa_down-name1 = wa_final-name1.
    wa_down-vbeln_im = wa_final-vbeln_im.


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

DELETE ADJACENT DUPLICATES FROM IT_DOWN COMPARING MBLNR VBELN_IM XBLNR_MKPF.
  SORT IT_FINAL ASCENDING BY VBELN_IM.
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
DATA lv_string_409 TYPE string.
DATA lv_crlf_409 TYPE string.
lv_crlf_409 = cl_abap_char_utilities=>cr_lf.
lv_string_409 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_409 lv_crlf_409 wa_csv INTO lv_string_409.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_409 TO lv_fullfile.
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
              'GRN Date'
              'Reference Documnet'
              'Vendor'
              'Vendor Name'
              'Inbound Delivery'
              'Refresh Date'
              'Refresh Time'

              INTO p_hd_csv
 SEPARATED BY l_field_seperator.

endform.
