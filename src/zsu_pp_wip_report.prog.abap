*&---------------------------------------------------------------------*
*&Report: ZSU_PP_WIP_REPORT
*&Transaction: ZSU_PP_WIP
*&Functional Cosultant: Subhashish Pande
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZPP_WIP_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsu_pp_wip_report.

TABLES : afpo,resb.
TYPES: BEGIN OF ty_afpo_resb,
         aufnr TYPE afpo-aufnr,
         kdauf TYPE afpo-kdauf,
         kdpos TYPE afpo-kdpos,
         dauat TYPE afpo-dauat,
         matnr TYPE afpo-matnr,
         psmng TYPE afpo-psmng,
         amein TYPE afpo-amein,
         wemng TYPE afpo-wemng,
         dwerk TYPE afpo-dwerk,
         elikz TYPE afpo-elikz,
         meins TYPE afpo-meins,
         erdat TYPE caufv-erdat,
         enmng TYPE resb-enmng,
         bdmng TYPE resb-bdmng,
         shkzg TYPE resb-shkzg,
         xloek TYPE resb-xloek,
         rsnum TYPE resb-rsnum,
         rspos TYPE resb-rspos,
       END OF ty_afpo_resb,

       BEGIN OF ty_resb,
         aufnr TYPE resb-aufnr,
         rsnum TYPE resb-rsnum,
         matnr TYPE resb-matnr,
         meins TYPE resb-meins,
         rspos TYPE resb-rspos,
       END OF ty_resb,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_mbew,
         matnr TYPE mbew-matnr,
         bwkey TYPE mbew-bwkey,
         vprsv TYPE mbew-vprsv,
         verpr TYPE mbew-verpr,
         stprs TYPE mbew-stprs,
       END OF ty_mbew,

       BEGIN OF ty_mseg,
         mblnr      TYPE mseg-mblnr,
         mjahr      TYPE mseg-mjahr,
         zeile      TYPE mseg-zeile,
         bwart      TYPE mseg-bwart,
         matnr      TYPE mseg-matnr,
         aufnr      TYPE mseg-aufnr,
         budat_mkpf TYPE mseg-budat_mkpf,
       END OF ty_mseg,

       BEGIN OF ty_final,
         aufnr      TYPE afpo-aufnr,
         psmng      TYPE afpo-psmng,
         amein      TYPE afpo-amein,
         wemng      TYPE afpo-wemng,
         meins      TYPE afpo-meins,
         matnr      TYPE afpo-matnr,
         maktx      TYPE makt-maktx,
         dwerk      TYPE afpo-dwerk,
         dauat      TYPE afpo-dauat,
         kdauf      TYPE afpo-kdauf,
         kdpos      TYPE afpo-kdpos,
         elikz      TYPE afpo-elikz,
         rsnum      TYPE resb-rsnum,
         bdmng      TYPE resb-bdmng,
         enmng      TYPE resb-enmng,
         rspos      TYPE resb-rspos,
         shkzg      TYPE resb-shkzg,
         xloek      TYPE resb-xloek,
         matnr1     TYPE resb-matnr,
         meins1     TYPE resb-meins,
         maktx1     TYPE makt-maktx,
         price      TYPE mbew-stprs,
         shortage   TYPE resb-enmng,
         map        TYPE mbew-verpr,
         wipqty     TYPE resb-enmng,
         wipvalue   TYPE mbew-verpr,
         ratio      TYPE resb-enmng,
         qty        TYPE resb-enmng,
         erdat      TYPE caufv-erdat,
         kunnr      TYPE kna1-kunnr,
         name       TYPE kna1-name1,
         verpr      TYPE mbew-verpr,
         budat_mkpf TYPE mseg-budat_mkpf,
       END OF ty_final,

       BEGIN OF ty_down,
         erdat      TYPE string,
         dauat      TYPE afpo-dauat,
         kdauf      TYPE afpo-kdauf,
         kdpos      TYPE afpo-kdpos,
         aufnr      TYPE afpo-aufnr,
         kunnr      TYPE kna1-kunnr,
         name       TYPE char100,
         matnr      TYPE mara-matnr,
         maktx      TYPE char50,
         matnr1     TYPE mara-matnr,
         maktx1     TYPE char50,
         bdmng      TYPE char15,
         enmng      TYPE char15,
         shortage   TYPE char15,
         wipqty     TYPE char15,
         psmng      TYPE char15,
         wemng      TYPE char15,
         map        TYPE char15,
         verpr      TYPE char15,
         wipvalue   TYPE char15,
         ref        TYPE char15,
         time       TYPE sy-uzeit,
         budat_mkpf TYPE char15,
       END OF ty_down.
DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE          ty_down.
DATA confirmed(001) TYPE c .


DATA : it_afpo_resb TYPE TABLE OF ty_afpo_resb,
       wa_afpo_resb TYPE          ty_afpo_resb,

       it_resb      TYPE TABLE OF ty_resb,
       wa_resb      TYPE          ty_resb,

       it_makt      TYPE TABLE OF ty_makt,
       wa_makt      TYPE          ty_makt,

       it_mbew      TYPE TABLE OF ty_mbew,
       wa_mbew      TYPE          mbew,

       it_mseg      TYPE TABLE OF ty_mseg,
       wa_mseg      TYPE          ty_mseg,

       it_final     TYPE TABLE OF ty_final,
       wa_final     TYPE          ty_final.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.



SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_order FOR afpo-aufnr,
                 s_matnr FOR afpo-matnr,
                 s_type  FOR afpo-dauat,
                 s_deliv FOR afpo-elikz ,
*                   CONF    FOR CONFIRMED LOWER CASE,
                 s_shkzg FOR resb-shkzg ,
                 s_xloek FOR resb-xloek ,
                 s_wemng FOR afpo-wemng.

PARAMETERS  :    p_plant TYPE afpo-dwerk DEFAULT 'SU01'  MODIF ID BU.


SELECTION-SCREEN: END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/Saudi'."Saudi'."Saudi'. " 'E:/delval/Saudi'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM sort_data.
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
  " BREAK primus.


  SELECT afpo~aufnr afpo~kdauf afpo~kdpos afpo~dauat afpo~matnr afpo~psmng afpo~amein afpo~wemng afpo~dwerk afpo~elikz afpo~meins
         caufv~erdat resb~enmng resb~bdmng resb~shkzg resb~xloek resb~rsnum resb~rspos
              INTO TABLE it_afpo_resb
      FROM ( afpo
             INNER JOIN caufv
             ON  caufv~aufnr = afpo~aufnr
             INNER JOIN resb
             ON  resb~aufnr = afpo~aufnr )
           WHERE afpo~aufnr IN s_order
             AND afpo~dauat IN s_type
             AND afpo~dwerk = p_plant
             AND afpo~elikz IN s_deliv
             AND afpo~matnr IN s_matnr
             AND resb~shkzg IN s_shkzg
             AND resb~xloek IN s_xloek
             AND afpo~wemng IN s_wemng.

*IF it_afpo_resb IS NOT INITIAL.
*SELECT aufnr
*       RSNUM
*       MATNR
*       MEINS
*       RSPOS FROM resb INTO TABLE it_resb
*       FOR ALL ENTRIES IN it_afpo_resb
*       WHERE aufnr = it_afpo_resb-aufnr.
******************added by snehal on 24.09.2020****************
  IF it_afpo_resb IS NOT INITIAL.

*    SELECT mblnr
*           mjahr
*           zeile
*           bwart
*           matnr
*           aufnr
*           budat_mkpf
*      FROM mseg
*      INTO TABLE it_mseg
*      FOR ALL ENTRIES IN it_afpo_resb
*      WHERE  aufnr = it_afpo_resb-aufnr.
*
  ENDIF.
********************************************************************
  IF it_resb IS NOT INITIAL.
    SELECT matnr
           bwkey
           vprsv
           verpr
           stprs FROM mbew INTO TABLE it_mbew
           FOR ALL ENTRIES IN it_resb
           WHERE matnr = it_resb-matnr
             AND bwkey = p_plant.


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
  LOOP AT it_afpo_resb INTO wa_afpo_resb.
    IF wa_afpo_resb-psmng = wa_afpo_resb-wemng.
      confirmed = 'X'.
    ENDIF.

    wa_final-shortage = wa_afpo_resb-bdmng - wa_afpo_resb-enmng .
*** additional coding:

    wa_final-ratio = wa_afpo_resb-bdmng / wa_afpo_resb-psmng.
    wa_final-qty = wa_afpo_resb-enmng - ( wa_afpo_resb-wemng * wa_final-ratio ).
    IF wa_final-qty < 0.
      wa_final-wipqty = 0.
    ELSE.
      wa_final-wipqty = wa_final-qty.
    ENDIF.
    wa_final-erdat = wa_afpo_resb-erdat.
    wa_final-aufnr = wa_afpo_resb-aufnr.
    wa_final-psmng = wa_afpo_resb-psmng.
    wa_final-amein = wa_afpo_resb-amein.
    wa_final-wemng = wa_afpo_resb-wemng.
    wa_final-meins = wa_afpo_resb-meins.
    wa_final-matnr = wa_afpo_resb-matnr.
    wa_final-dwerk = wa_afpo_resb-dwerk.
    wa_final-dauat = wa_afpo_resb-dauat.
    wa_final-kdauf = wa_afpo_resb-kdauf.
    wa_final-kdpos = wa_afpo_resb-kdpos.
    wa_final-elikz = wa_afpo_resb-elikz.
    wa_final-rsnum = wa_afpo_resb-rsnum.
    wa_final-bdmng = wa_afpo_resb-bdmng.
    wa_final-enmng = wa_afpo_resb-enmng.
    wa_final-rspos = wa_afpo_resb-rspos.
    wa_final-shkzg = wa_afpo_resb-shkzg.
    wa_final-xloek = wa_afpo_resb-xloek.


    SELECT SINGLE matnr INTO wa_final-matnr1 FROM resb WHERE aufnr = wa_final-aufnr AND rsnum = wa_final-rsnum AND
                                                             rspos = wa_final-rspos.
*READ TABLE it_resb INTO wa_resb WITH KEY aufnr = wa_final-aufnr.
*IF sy-subrc = 0.
*  wa_final-matnr1 = wa_resb-matnr.
*  wa_final-MEINS1 = wa_resb-MEINS.
*
*ENDIF.
*****************added by snehal on 24.09.2020************
*    SELECT SINGLE * FROM mseg into wa_mseg WHERE aufnr = wa_final-aufnr.
    READ TABLE it_mseg INTO wa_mseg WITH KEY aufnr = wa_final-aufnr.
    IF sy-subrc = 0.
      IF wa_mseg-bwart = '261'.
        wa_final-budat_mkpf = wa_mseg-budat_mkpf.
      ENDIF.
    ENDIF.
*************************************************************
    SELECT SINGLE * FROM mbew INTO wa_mbew WHERE matnr = wa_final-matnr1 AND bwkey = wa_afpo_resb-dwerk.
*READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_final-matnr1.
    IF sy-subrc = 0.
      IF wa_mbew-vprsv = 'S'.
        wa_final-map = wa_mbew-stprs.
      ELSEIF wa_mbew-vprsv = 'V'.
        wa_final-map = wa_mbew-verpr.
      ENDIF.
      wa_final-verpr = wa_mbew-verpr.
    ENDIF.

    wa_final-wipvalue = wa_final-wipqty * wa_final-map.


    DATA : v_name1 TYPE kna1-name1,
           v_name2 TYPE kna1-name2.
    CLEAR : v_name1 , v_name2 .
    SELECT SINGLE kunnr FROM vbak INTO wa_final-kunnr
                        WHERE vbeln = wa_final-kdauf.
    IF wa_final-kunnr IS NOT INITIAL.
      SELECT SINGLE name1 name2 FROM kna1 INTO (v_name1,v_name2)
                            WHERE kunnr = wa_final-kunnr.
      IF  v_name2 IS NOT INITIAL.
        CONCATENATE v_name1 v_name2 INTO wa_final-name SEPARATED BY ' '.
      ELSE.
        wa_final-name =  v_name1 .
      ENDIF.
    ENDIF.

    SELECT SINGLE maktx INTO wa_final-maktx FROM makt WHERE matnr = wa_final-matnr.
    SELECT SINGLE maktx INTO wa_final-maktx1 FROM makt WHERE matnr = wa_final-matnr1.

    IF wa_final-shortage < 0.
      wa_final-shortage = 0.
    ENDIF.


    APPEND wa_final TO it_final.
    CLEAR wa_final.
*DELETE it_final WHERE WIPVALUE IS INITIAL.
  ENDLOOP.

  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
*  wa_down-ERDAT  = wa_final-ERDAT .
      wa_down-dauat  = wa_final-dauat .
      wa_down-kdauf  = wa_final-kdauf .
      wa_down-kdpos  = wa_final-kdpos .
      wa_down-aufnr  = wa_final-aufnr .
      wa_down-kunnr  = wa_final-kunnr .
      wa_down-name   = wa_final-name  .
      wa_down-matnr  = wa_final-matnr .
      wa_down-maktx  = wa_final-maktx .
      wa_down-matnr1 = wa_final-matnr1.
      wa_down-maktx1 = wa_final-maktx1.
      wa_down-bdmng  = wa_final-bdmng .
      wa_down-enmng  = wa_final-enmng .

      wa_down-shortage = wa_final-shortage.
      wa_down-wipqty  = wa_final-wipqty  .
      wa_down-psmng   = wa_final-psmng   .
      wa_down-wemng   = wa_final-wemng   .
      wa_down-map     = wa_final-map     .
      wa_down-verpr    = wa_final-verpr   .
      wa_down-wipvalue = wa_final-wipvalue.
*  wa_down-budat_mkpf = wa_final-budat_mkpf.
      wa_down-time     = sy-uzeit.

      IF wa_final-erdat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-erdat
          IMPORTING
            output = wa_down-erdat.

        CONCATENATE wa_down-erdat+0(2) wa_down-erdat+2(3) wa_down-erdat+5(4)
                        INTO wa_down-erdat SEPARATED BY '-'.
      ENDIF.

      IF wa_final-budat_mkpf IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-budat_mkpf
          IMPORTING
            output = wa_down-budat_mkpf.

        CONCATENATE wa_down-budat_mkpf+0(2) wa_down-budat_mkpf+2(3) wa_down-budat_mkpf+5(4)
                        INTO wa_down-budat_mkpf SEPARATED BY '-'.
      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
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
  PERFORM fcat USING :
                          '1'  'ERDAT'         'IT_FINAL'  'Start Date'                                        '18',
                          '2'  'DAUAT'         'IT_FINAL'  'Order Type'                   '18',
                          '3'  'KDAUF'         'IT_FINAL'  'Sales Order No'                   '18',
                          '4'  'KDPOS'         'IT_FINAL'  'Sales Order Item'                   '18',
                          '5'  'AUFNR'         'IT_FINAL'  'Order'                                        '18',
                          '6'  'KUNNR'         'IT_FINAL'  'Customer Code'                                        '18',
                          '7'  'NAME'         'IT_FINAL'  'Customer Name'                                        '18',
                          '8'  'MATNR'         'IT_FINAL'  'Material'                   '18',
                          '9'  'MAKTX'         'IT_FINAL'  'Material Description'                   '18',
                         '10'  'MATNR1'         'IT_FINAL'  'Component'                   '18',
                         '11'  'MAKTX1'        'IT_FINAL'  'Component Description'                   '18',
                         '12'  'BDMNG'         'IT_FINAL'  'Reqmt Qty'                   '18',
                         '13'  'ENMNG'         'IT_FINAL'  'Issue Qty.'                   '18',
                         '14'  'SHORTAGE'      'IT_FINAL'  'Shortage Qty.'                   '18',
                         '14'  'WIPQTY'        'IT_FINAL'  'WIP Qty.'                   '18',
                         '16'  'PSMNG'         'IT_FINAL'  'Order Quantity'                                        '18',
                         '17'  'WEMNG'         'IT_FINAL'  'Confirmation Qty.'                   '18',
                         '18'  'MAP'           'IT_FINAL'  'Price'                   '18',
                         '19'  'VERPR'         'IT_FINAL'  'MovAvgPrice'                   '18',
                         '20'  'WIPVALUE'      'IT_FINAL'  'WIP Value'                   '18',
                         '21'  'BUDAT_MKPF'    'IT_FINAL'  'Issued Date'                   '18'.


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
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*BREAK primusabap.
*  IF p_down = 'X'.
*    PERFORM download.
**    PERFORM gui_download.
*  ENDIF.
  IF p_down = 'X'.
    PERFORM download.
*    PERFORM gui_download.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0593   text
*      -->P_0594   text
*      -->P_0595   text
*      -->P_0596   text
*      -->P_0597   text
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
*  wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

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


  lv_file = 'ZSU_PP_WIP.TXT'.


*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSU_PPWIP REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_617 TYPE string.
DATA lv_crlf_617 TYPE string.
lv_crlf_617 = cl_abap_char_utilities=>cr_lf.
lv_string_617 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_617 lv_crlf_617 wa_csv INTO lv_string_617.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_617 TO lv_fullfile.
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
  CONCATENATE 'Start Date'
              'Order Type'
              'Sales Order No'
              'Sales Order Item'
              'Order'
              'Customer Code'
              'Customer Name'
              'Material'
              'Material Description'
               'Component'
              'Component Description'
              'Reqmt Qty'
               'Issue Qty.'
              'Shortage Qty.'
              'WIP Qty.'
              'Order Quantity'
              'Confirmation Qty.'
              'Price'
              'MovAvgPrice'
              'WIP Value'
              'Refreshable Date'
              'Refreshable Time'
              'Issued Date'
              INTO pd_csv
                SEPARATED BY l_field_seperator.

ENDFORM.
