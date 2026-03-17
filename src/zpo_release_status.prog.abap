*&---------------------------------------------------------------------*
*& Report ZPO_RELEASE_STATUS
*&---------------------------------------------------------------------*
*&REport: Report for PO release status
*&Tcode: ZPO_REL
*&Functional Cosultant: Devshree Kalamkar
*&Technical Consultant: Diksha Halve
*&Date: 07.02.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
report zpo_release_status.

tables : ekko, ekpo, t024.
types : begin of ty_ekko,
          ebeln type ekko-ebeln,
          bsart type ekko-bsart,
          aedat type ekko-aedat,
          ekgrp type ekko-ekgrp,
          bedat type ekko-bedat,
          frgke type ekko-frgke,
          frgzu type ekko-frgzu,
        end of ty_ekko.

types : begin of ty_ekpo,
          ebeln type ekpo-ebeln,
          werks type ekpo-werks,
          netwr type ekpo-netwr,
        end of ty_ekpo.

types : begin of ty_t024,
          ekgrp type t024-ekgrp,
          eknam type t024-eknam,
        end of ty_t024.

types : begin of ty_final,
          ebeln type ekko-ebeln,
          bsart type ekko-bsart,
          aedat type char15,   "ekko-aedat,
          ekgrp type ekko-ekgrp,
          bedat type ekko-bedat,
          frgke type ekko-frgke,
          frgzu type ekko-frgzu,
          werks type ekpo-werks,
          netwr type ekpo-netwr,
          eknam type t024-eknam,
          b1    type ekko-frgzu,
          b2    type ekko-frgzu,
          b3    type ekko-frgzu,
          b4    type ekko-frgzu,
        end of ty_final.

types : begin of ty_down,
          ekgrp    type ekko-ekgrp,
          eknam    type t024-eknam,
          bsart    type ekko-bsart,
          aedat    type char15,
          ebeln    type ekko-ebeln,
          netwr    type string,    "ekpo-netwr,
*          frgke type ekko-frgke,
          b1       type ekko-frgzu,
          b2       type ekko-frgzu,
          b3       type ekko-frgzu,
          b4       type ekko-frgzu,
          ref_date type char15,
          ref_time type char15,
        end of ty_down.

data : it_ekko  type standard table of ty_ekko,
       wa_ekko  type ty_ekko,
       it_ekpo  type standard table of ty_ekpo,
       wa_ekpo  type ty_ekpo,
       it_t024  type standard table of ty_t024,
       wa_t024  type ty_t024,
       it_final type standard table of ty_final,
       wa_final type ty_final,
       it_down  type standard table of ty_down,
       wa_down  type ty_down,
       it_fcat  type slis_t_fieldcat_alv,
       wa_fcat  type slis_fieldcat_alv.

selection-screen : begin of block b1 with frame.
select-options : s_werks for ekpo-werks default 'PL01',
                 s_bsart for ekko-bsart,
                 s_ebeln for ekko-ebeln,
                 s_bedat for ekko-bedat,
                 s_ekgrp for ekko-ekgrp.
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
  perform get_fcat.
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
*  BREAK-POINT.
  select ebeln
         bsart
         aedat
         ekgrp
         bedat
         frgke
         frgzu
    from ekko into table it_ekko
    where ebeln in s_ebeln
    and bsart in s_bsart
    and ekgrp in s_ekgrp
    and bedat in s_bedat
    AND frgke = 'X'.

  if it_ekko is not initial.
    select ebeln
           werks
           netwr
      from ekpo into table it_ekpo
      for all entries in it_ekko
      where ebeln = it_ekko-ebeln
      and werks in s_werks.

    select ekgrp
           eknam
      from t024 into table it_t024
      for all entries in it_ekko
      where ekgrp = it_ekko-ekgrp.
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
  SORT IT_EKPO BY EBELN.
  loop at it_ekpo into wa_ekpo.
*    wa_final-werks = wa_ekpo-werks.
    wa_final-netwr = wa_ekpo-netwr.

    read table it_ekko into wa_ekko with key ebeln = wa_ekpo-ebeln.
    if sy-subrc = 0.
      wa_final-ebeln = wa_ekko-ebeln.
      wa_final-bsart = wa_ekko-bsart.
      wa_final-aedat = wa_ekko-aedat.
      if wa_final-aedat is not initial.
        call function 'CONVERSION_EXIT_IDATE_OUTPUT'
          exporting
            input  = wa_final-aedat
          importing
            output = wa_final-aedat.
        concatenate wa_final-aedat+0(2) wa_final-aedat+2(3) wa_final-aedat+5(4)
         into wa_final-aedat separated by '-'.
      endif.

      wa_final-ekgrp = wa_ekko-ekgrp.
      wa_final-bedat = wa_ekko-bedat.
      wa_final-frgke = wa_ekko-frgke.
      wa_final-frgzu = wa_ekko-frgzu.


      if wa_final-frgzu = 'X'.
        wa_final-b1 = 'X'.
        wa_final-b2 = ''.
        wa_final-b3 = ''.
        wa_final-b4 = ''.

      elseif wa_final-frgzu = 'XX'.
        wa_final-b1 = 'X'.
        wa_final-b2 = 'XX'.
        wa_final-b3 = ''.
        wa_final-b4 = ''.

      elseif wa_final-frgzu = 'XXX'.
        wa_final-b1 = 'X'.
        wa_final-b2 = 'XX'.
        wa_final-b3 = 'XXX'.
        wa_final-b4 = ''.

      elseif wa_final-frgzu = 'XXXX'.
        wa_final-b1 = 'X'.
        wa_final-b2 = 'XX'.
        wa_final-b3 = 'XXX'.
        wa_final-b4 = 'XXXX'.
      endif.
    endif.

*    read table it_ekpo into wa_ekpo with key ebeln = wa_ekko-ebeln.
*    if sy-subrc = 0.
*      wa_final-netwr = wa_ekpo-netwr.
*    endif.

    read table it_t024 into wa_t024 with key ekgrp = wa_ekko-ekgrp.
    if sy-subrc = 0.
      wa_final-eknam = wa_t024-eknam.
    endif.

    append wa_final to it_final.
    clear wa_final.
  endloop.
  clear:wa_ekpo,wa_ekko.


endform.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_fcat .
  SORT IT_FINAL BY EBELN.
  wa_fcat-col_pos = '1'.
  wa_fcat-fieldname = 'EKGRP'.
  wa_fcat-seltext_l = 'Purchase Group'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '2'.
  wa_fcat-fieldname = 'EKNAM'.
  wa_fcat-seltext_l = 'Buyer Name'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '3'.
  wa_fcat-fieldname = 'BSART'.
  wa_fcat-seltext_l = 'PO Doc Type'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '4'.
  wa_fcat-fieldname = 'AEDAT'.
  wa_fcat-seltext_l = 'Created On Date'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '5'.
  wa_fcat-fieldname = 'EBELN'.
  wa_fcat-seltext_l = 'PO NO.'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.

  wa_fcat-col_pos = '6'.
  wa_fcat-fieldname = 'NETWR'.
  wa_fcat-seltext_l = 'PO Amount'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.

*IF wa_final-B1 IS  NOT INITIAL.
  wa_fcat-col_pos = '7'.
  wa_fcat-fieldname = 'B1'.
  wa_fcat-seltext_l = 'B1'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.
*ENDIF.


  wa_fcat-col_pos = '8'.
  wa_fcat-fieldname = 'B2'.
  wa_fcat-seltext_l = 'B2'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.


*IF wa_final-B3 IS  NOT INITIAL.
  wa_fcat-col_pos = '9'.
  wa_fcat-fieldname = 'B3'.
  wa_fcat-seltext_l = 'B3'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.
*ENDIF.

*IF wa_final-B4 IS  NOT INITIAL.
  wa_fcat-col_pos = '10'.
  wa_fcat-fieldname = 'B4'.
  wa_fcat-seltext_l = 'B4'.
  wa_fcat-outputlen = 20.
  append wa_fcat to it_fcat.
  clear wa_fcat.

*  wa_fcat-col_pos = '11'.
*  wa_fcat-fieldname = 'WERKS'.
*  wa_fcat-seltext_l = 'PLANT'.
*  wa_fcat-outputlen = 20.
*  append wa_fcat to it_fcat.
*  clear wa_fcat.
*ENDIF.

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

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    tables
      t_outtab    = it_final
* EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS      = 2
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
  loop at it_final into wa_final.
    wa_down-ekgrp = wa_final-ekgrp.
    wa_down-eknam = wa_final-eknam.
    wa_down-bsart = wa_final-bsart.
    wa_down-aedat = wa_final-aedat.
    wa_down-ebeln = wa_final-ebeln.
    wa_down-netwr = wa_final-netwr.
    if wa_down-netwr is not initial.
      replace all occurrences of ',' in wa_down-netwr with ''.
    endif.
    wa_down-b1 = wa_final-b1.
    wa_down-b2 = wa_final-b2.
    wa_down-b3 = wa_final-b3.
    wa_down-b4 = wa_final-b4.

    call function 'CONVERSION_EXIT_IDATE_OUTPUT'
      exporting
        input  = sy-datum
      importing
        output = wa_down-ref_date.
    concatenate wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
    into wa_down-ref_date separated by '-'.

    wa_down-ref_time = sy-uzeit.
    concatenate wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  into wa_down-ref_time.

    append wa_down to it_down.
    clear wa_down.
  endloop.
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

  type-pools truxs.
  data: it_csv type truxs_t_text_data,
        wa_csv type line of truxs_t_text_data,
        hd_csv type line of truxs_t_text_data.


  data: lv_file(30).
  data: lv_fullfile type string,
        lv_dat(10),
        lv_tim(4).
  data: lv_msg(80).

*BREAK-POINT.
  call function 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
    tables
      i_tab_sap_data       = it_down
    changing
      i_tab_converted_data = it_csv
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

  perform cvs_header using hd_csv.
  lv_file = 'ZPO_REL.TXT'.

*  concatenate p_folder '\' lv_file
  concatenate p_folder '/' lv_file
  into lv_fullfile.
* BREAK primus.
  write: / 'ZPO_RELEASE_STATUS PROGRAM Download started on', sy-datum, 'at', sy-uzeit.
  open dataset lv_fullfile
  for output in text mode encoding default.  "NON-UNICODE.
  if sy-subrc = 0.
DATA lv_string_478 TYPE string.
DATA lv_crlf_478 TYPE string.
lv_crlf_478 = cl_abap_char_utilities=>cr_lf.
lv_string_478 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_478 lv_crlf_478 wa_csv INTO lv_string_478.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_478 TO lv_fullfile.
    concatenate 'File' lv_fullfile 'downloaded' into lv_msg separated by space.
    message lv_msg type 'S'.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
form cvs_header  using    p_hd_csv.

  data: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  concatenate 'Purchase Group'
              'Buyer Name'
              'PO DOC Type'
              'Created on Date'
              'PO No.'
              'PO Amount'
              'B1'
              'B2'
              'B3'
              'B4'
              'Refresh Date'
              'Refresh Time'
              into p_hd_csv
  separated by l_field_seperator.

endform.
