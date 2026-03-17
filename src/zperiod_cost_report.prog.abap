*&---------------------------------------------------------------------*
*& Report ZPERIOD_COST_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zperiod_cost_report." MESSAGE-ID 00 NO STANDARD PAGE HEADING
*             LINE-SIZE 132
*             LINE-COUNT 65.

TYPE-POOLS : slis.

TABLES : mara, marc, mbew, mbewh.

TYPES : BEGIN OF ty_mara,
          matnr    TYPE mara-matnr,
          mtart   TYPE mara-mtart,
          zseries TYPE mara-zseries,
          zsize   TYPE mara-zsize,
          brand   TYPE mara-brand,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
        END OF ty_mara.

DATA : it_mara TYPE STANDARD TABLE OF ty_mara,
       wa_mara TYPE ty_mara.

TYPES : BEGIN OF ty_marc,
          matnr TYPE marc-matnr,
          beskz TYPE marc-beskz,
          sobsl TYPE marc-sobsl,
          werks TYPE marc-werks,
        END OF ty_marc.

DATA : it_marc TYPE STANDARD TABLE OF ty_marc,
       wa_marc TYPE ty_marc.

TYPES : BEGIN OF ty_mbew,
          matnr TYPE mbew-matnr,
          vprsv TYPE mbew-vprsv,
          BWKEY TYPE mbew-BWKEY,
        END OF ty_mbew.

DATA : it_mbew TYPE STANDARD TABLE OF ty_mbew,
       wa_mbew TYPE ty_mbew.

TYPES : BEGIN OF ty_mbewh,
          matnr TYPE mbewh-matnr,
          stprs TYPE mbewh-stprs,
          lfmon TYPE mbewh-lfmon,
          VPRSV TYPE mbewh-VPRSV,
          BWKEY TYPE mbewh-BWKEY,
          lfgja TYPE mbewh-lfgja,
        END OF ty_mbewh.

DATA : it_mbewh TYPE STANDARD TABLE OF ty_mbewh,
       wa_mbewh TYPE ty_mbewh.

TYPES :BEGIN OF ty_final,
         matnr    TYPE  mara-matnr,
         maktx    TYPE  makt-maktx,
         mtart            TYPE mara-mtart,
         zseries          TYPE mara-zseries,
         zsize            TYPE mara-zsize,
         brand            TYPE mara-brand,
         moc              TYPE mara-moc,
         type             TYPE mara-type,

         beskz            TYPE marc-beskz,
         sobsl            TYPE marc-sobsl,

         vprsv            TYPE mbew-vprsv,

         april            TYPE mbew-stprs,
         may            TYPE mbew-stprs,
         june            TYPE mbew-stprs,
         july            TYPE mbew-stprs,
         august            TYPE mbew-stprs,
         sep            TYPE mbew-stprs,
         oct            TYPE mbew-stprs,
         nov            TYPE mbew-stprs,
         dec            TYPE mbew-stprs,
         jan            TYPE mbew-stprs,
         feb            TYPE mbew-stprs,
         march            TYPE mbew-stprs,
         year  type mbewh-lfgja,
*         lfmon            TYPE mbew-lfmon,
         END OF ty_final.

         data: it_final type STANDARD TABLE OF ty_final,
               wa_final type ty_final.

         TYPES :BEGIN OF ty_down,
         matnr    TYPE  mara-matnr,
         maktx    TYPE  makt-maktx,
         mtart            TYPE mara-mtart,
         zseries          TYPE mara-zseries,
         zsize            TYPE mara-zsize,
         brand            TYPE mara-brand,
         moc              TYPE mara-moc,
         type             TYPE mara-type,

         beskz            TYPE marc-beskz,
         sobsl            TYPE marc-sobsl,

         vprsv            TYPE mbew-vprsv,

         april          TYPE string,
         may            TYPE string,
         june           TYPE string,
         july           TYPE string,
         august         TYPE string,
         sep            TYPE string,
         oct            TYPE string,
         nov            TYPE string,
         dec            TYPE string,
         jan            TYPE string,
         feb            TYPE string,
         march          TYPE string,
         year type string,
         ref_dat   TYPE char15,                         "Refresh Date
          ref_time  TYPE char15,                        "Refresh Time

*         lfmon            TYPE mbew-lfmon,
         END OF ty_down.

         data: it_down type STANDARD TABLE OF ty_down,
               wa_down type ty_down.

DATA: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat.

DATA: lt_header        TYPE slis_t_listheader,
              ls_header       TYPE slis_listheader,
              lt_line             LIKE ls_header-info,
              lv_lines          TYPE i,
              lv_linesc(10) TYPE c.

data: E_MONTH(2) type n.
         selection-screen BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_matnr FOR mara-matnr ,
                 s_mtart for mara-mtart OBLIGATORY.
PARAMETERS:      s_werks type marc-werks OBLIGATORY," DEFAULT 'PL01' MODIF ID wer," ADDED BY MD
                 s_lfgja type mbewh-lfgja OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002.
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

start-of-selection.

PERFORM GET_DATA.
PERFORM SORT_DATA.
PERFORM GET_FCAT.
PERFORM GET_DISPLAY.

*----------------------------------------------------------------------*
FORM get_data .
  select matnr
         mtart
         zseries
         zsize
         brand
         moc
         type
    from mara into TABLE it_mara
    where matnr in s_matnr
    and mtart IN s_mtart.

    if it_mara is not INITIAL.

      select matnr
             beskz
             sobsl
             werks
        from marc into TABLE it_marc
        FOR ALL ENTRIES IN it_mara
        where matnr = it_mara-matnr
        and werks eq s_werks.

       endif.

       if it_mara is NOT INITIAL .
         select matnr
                vprsv
                BWKEY
           from mbew INTO TABLE it_mbew
           FOR ALL ENTRIES IN it_mara
           where matnr = it_mara-matnr
               and  BWKEY eq s_werks.
           endif.

           if it_mbew is not INITIAL.

             select matnr
                    stprs
                    lfmon
                    VPRSV
                    BWKEY
                    lfgja
             from MBEWH into TABLE it_MBEWH
               FOR ALL ENTRIES IN it_mbew
               where matnr = it_mbew-matnr
               and VPRSV = it_mbew-VPRSV
               and BWKEY eq s_werks
               and lfgja eq s_lfgja.

               endif.

ENDFORM.

FORM sort_data .

loop at it_mara into wa_mara.
  wa_final-matnr    =  wa_mara-matnr  .
  wa_final-mtart    =  wa_mara-mtart  .
  wa_final-zseries  =  wa_mara-zseries.
  wa_final-zsize    =  wa_mara-zsize  .
  wa_final-brand    =  wa_mara-brand  .
  wa_final-moc      =  wa_mara-moc    .
  wa_final-type     =  wa_mara-type   .

  read TABLE it_marc into wa_marc with key matnr = wa_final-matnr werks = s_werks.
  if sy-subrc = 0.
    wa_final-beskz =  wa_marc-beskz  .
    wa_final-sobsl =  wa_marc-sobsl  .
    endif.

    READ TABLE it_mbew into wa_mbew with key matnr = wa_final-matnr BWKEY = s_werks.
    if sy-subrc = 0.
      wa_final-vprsv = wa_mbew-vprsv.
      endif.

loop at it_mbewh into wa_mbewh where matnr = wa_final-matnr and VPRSV = wa_final-vprsv and BWKEY = s_werks and lfgja = s_lfgja.

*  wa_final-matnr    =  wa_final-matnr  .
*  wa_final-mtart    =  wa_final-mtart  .
*  wa_final-zseries  =  wa_final-zseries.
*  wa_final-zsize    =  wa_final-zsize  .
*  wa_final-brand    =  wa_final-brand  .
*  wa_final-moc      =  wa_final-moc    .
*  wa_final-type    =   wa_final-type   .
*  wa_final-beskz   =   wa_final-beskz.
*  wa_final-sobsl  =    wa_final-sobsl.
*  wa_final-vprsv  =    wa_final-vprsv.



  case wa_mbewh-LFMON.
     when 1.
      wa_final-april = wa_mbewh-STPRS.
      when 2.
      wa_final-may = wa_mbewh-STPRS.
      when 3.
      wa_final-june = wa_mbewh-STPRS.
      when 4.
      wa_final-july = wa_mbewh-STPRS.
      when 5.
      wa_final-august = wa_mbewh-STPRS.
      when 6.
      wa_final-sep = wa_mbewh-STPRS.
      when 7.
      wa_final-oct = wa_mbewh-STPRS.
      when 8.
      wa_final-nov = wa_mbewh-STPRS.
      when 9.
      wa_final-dec = wa_mbewh-STPRS.
      when 10.
      wa_final-jan = wa_mbewh-STPRS.
      when 11.
      wa_final-feb = wa_mbewh-STPRS.
      when 12.
      wa_final-march = wa_mbewh-STPRS.
      ENDCASE.

*E_MONTH = sy-datum+04(02).
*  case E_MONTH.
*     when 01.
**       CONCATENATE 'Current Period :-'
*       wa_final-jan = wa_mbewh-STPRS.
*      when 02.
*       wa_final-feb = wa_mbewh-STPRS.
*      when 03.
*      wa_final-march = wa_mbewh-STPRS.
*      when 04.
*      wa_final-april = wa_mbewh-STPRS.
*      when 05.
*      wa_final-may = wa_mbewh-STPRS.
*      when 06.
*      wa_final-june = wa_mbewh-STPRS.
*      when 07.
*       wa_final-july = wa_mbewh-STPRS.
*      when 08.
*      wa_final-august = wa_mbewh-STPRS.
*      when 09.
*       wa_final-sep = wa_mbewh-STPRS.
*      when 10.
*       wa_final-oct = wa_mbewh-STPRS.
*      when 11.
*        wa_final-nov = wa_mbewh-STPRS.
*      when 12.
*       wa_final-dec = wa_mbewh-STPRS.
*      ENDCASE.


  "append wa_final to it_final.
 "clear : wa_final-april,wa_final-may,wa_final-june,wa_final-july,wa_final-august,wa_final-sep,wa_final-oct,wa_final-nov,wa_final-dec,wa_final-jan,wa_final-feb,wa_final-march.
  ENDLOOP.
select single maktx into wa_final-maktx from makt where matnr = wa_final-matnr.
  wa_final-year = s_lfgja.
  append wa_final to it_final.
  clear : wa_final-april,wa_final-may,wa_final-june,wa_final-july,wa_final-august,wa_final-sep,wa_final-oct,wa_final-nov,wa_final-dec,wa_final-jan,wa_final-feb,wa_final-march.
   clear wa_final.
  endloop.

  IF p_down = 'X'.
    loop at it_final into wa_final.

      wa_down-matnr    = wa_final-matnr   .
      wa_down-maktx    = wa_final-maktx   .
      wa_down-mtart    = wa_final-mtart   .
      wa_down-zseries  = wa_final-zseries .
      wa_down-zsize    = wa_final-zsize   .
      wa_down-brand    = wa_final-brand   .
      wa_down-moc      = wa_final-moc     .
      wa_down-type     = wa_final-type     .
      wa_down-beskz    = wa_final-beskz   .
      wa_down-sobsl    = wa_final-sobsl    .
      wa_down-vprsv    = wa_final-vprsv     .
      wa_down-april    = wa_final-april     .
      wa_down-may      = wa_final-may     .
      wa_down-june     = wa_final-june    .
      wa_down-july     = wa_final-july    .
      wa_down-august   = wa_final-august  .
      wa_down-sep      = wa_final-sep     .
      wa_down-oct      = wa_final-oct     .
      wa_down-nov      = wa_final-nov     .
      wa_down-dec      = wa_final-dec     .
      wa_down-jan      = wa_final-jan     .
      wa_down-feb      = wa_final-feb     .
      wa_down-march    = wa_final-march   .
      wa_down-year    = wa_final-year   .

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_dat.
      CONCATENATE wa_down-ref_dat+0(2) wa_down-ref_dat+2(3) wa_down-ref_dat+5(4)
     INTO wa_down-ref_dat SEPARATED BY '-'.

      wa_down-ref_time = sy-uzeit.
      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

      append wa_down to it_down.
      clear wa_down.
      ENDLOOP.
    endif.
ENDFORM.

FORM get_fcat .

PERFORM FCAT USING :
                     '1'  'MATNR'                 'IT_FINAL'    'Material Code'                    '18',
                     '2'  'MAKTX'                 'IT_FINAL'    'Material Description'                     '20' ,
                     '3'  'MTART'                 'IT_FINAL'    'Material Type'                       '4' ,
                     '4'  'ZSERIES'                 'IT_FINAL'  'Series'                      '3' ,
                     '5'  'ZSIZE'                 'IT_FINAL'    'Size'                         '3' ,
                     '6'  'BRAND'                 'IT_FINAL'    'Brand'                        '3' ,
                     '7'  'MOC'                 'IT_FINAL'      'Moc'                            '3' ,
                     '8'  'TYPE'                 'IT_FINAL'     'Type'                           '3' ,
                     '9'  'BESKZ'                 'IT_FINAL'    'Procurment Key'                      '1' ,
                    '10'  'SOBSL'                 'IT_FINAL'    'Special Procurment Key'                           '2' ,
                    '11'  'VPRSV'                 'IT_FINAL'    'Price Control'                           '1' ,
                    '12'  'APRIL'             'IT_FINAL'        'APRIL'                           '11' ,
                    '13'  'MAY'                  'IT_FINAL'     'MAY'                           '11',
                    '14'  'JUNE'               'IT_FINAL'       'JUNE'                             '11' ,
                    '15'  'JULY'             'IT_FINAL'         'JULY'                     '11' ,
                    '16'  'AUGUST'             'IT_FINAL'       'AUGUST'                         '11' ,
                    '17'  'SEP'                  'IT_FINAL'     'SEP'                      '11',
                    '18'  'OCT'                  'IT_FINAL'     'OCT'                      '11',
                    '19'  'NOV'                 'IT_FINAL'      'NOV'                          '11' ,
                    '20'  'DEC'                  'IT_FINAL'     'DEC'                           '11' ,
                    '21'  'JAN'             'IT_FINAL'          'JAN'                         '11' ,
                    '22'  'FEB'             'IT_FINAL'          'FEB'                     '11' ,
                    '23'  'MARCH'             'IT_FINAL'        'MARCH'                           '11' ,
                    '24'  'YEAR'             'IT_FINAL'        'Current Fiscal Year'                           '4' .

ENDFORM.

FORM fcat  USING     VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
wa_fcat-col_pos   = p1.
wa_fcat-fieldname = p2.
wa_fcat-tabname   = p3.
wa_fcat-seltext_m = p4.
*wa_fcat-key       = .
wa_fcat-outputlen   = p5.

append wa_fcat to it_fcat.
CLEAR wa_fcat.

ENDFORM.

FORM get_display .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
     IT_FIELDCAT                       = it_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
      I_SAVE                            = 'X'
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
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
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
*    PERFORM gui_download.
  ENDIF.

ENDFORM.

*FORM top-of-page.
*
**&—– Alv report header —–*
** Title
*ls_header-typ = 'H'.
*ls_header-info = 'Costing Period report'.
*APPEND ls_header TO lt_header.
*CLEAR ls_header.
*
*** Date
**ls_header-typ = ‘S’.
**ls_header-key = ‘Date: ‘.
**CONCATENATE sy-datum+6(2) ‘.’
**sy-datum+4(2) ‘.’
**sy-datum(4) INTO ls_header-info. “todays date
**APPEND ls_header TO lt_header.
**CLEAR: ls_header.
**
*** Total No. of Records Selected
**DESCRIBE TABLE lt_sflight LINES lv_lines.
**lv_linesc = s_lfgja.
**CONCATENATE 'Current Period :- '  lv_linesc
**INTO lt_line SEPARATED BY space.
**ls_header-typ = 'H'.
**ls_header-info = lt_line.
**APPEND ls_header TO lt_header.
**CLEAR: ls_header, lt_line.
***&—– Pass data and field catalog to ALV function module —–*
*
*CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
*     EXPORTING
*          it_list_commentary = lt_header.
*
*ENDFORM.

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
*  break primus.

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
  lv_file =   'ZPERIOD_COST_REPORT.TXT'.
*BREAK primus.
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'Periodwise Cost REPORT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_553 TYPE string.
DATA lv_crlf_553 TYPE string.
lv_crlf_553 = cl_abap_char_utilities=>cr_lf.
lv_string_553 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_553 lv_crlf_553 wa_csv INTO lv_string_553.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_553 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.

FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Material Code'
              'Material Description'
              'Material Type'
              'Series'
              'Size'
              'Brand'
              'Moc'
              'Type'
              'Procurment Key'
              'Special Procurment Key'
              'Price Control'
              'APRIL'
              'MAY'
              'JUNE'
              'JULY'
              'AUGUST'
              'SEP'
              'OCT'
              'NOV'
              'DEC'
              'JAN'
              'FEB'
              'MARCH'
              'Current Fiscal Year'
              'Refresh date'
              'Refresh time'

              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
