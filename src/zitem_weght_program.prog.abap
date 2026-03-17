*&---------------------------------------------------------------------*
*& Report ZITEM_WEGHT_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zitem_weght_program.


TYPE-POOLS:slis.

TABLES : vbap, vbak, vbfa, kna1, likp.
TYPES:BEGIN OF ty_vbak,
        vbeln TYPE vbak-vbeln,
        erdat TYPE vbak-erdat,
        auart TYPE vbak-auart,
        vkorg TYPE vbak-vkorg,
        knumv TYPE vbak-knumv,
        kunnr TYPE vbak-kunnr,

      END OF ty_vbak,

      BEGIN OF ty_vbap,
        vbeln  TYPE vbak-vbeln,
        posnr  TYPE vbap-posnr,
        matnr  TYPE vbap-matnr,
        arktx  TYPE vbap-arktx,
        ntgew  TYPE vbap-ntgew,
        werks  TYPE vbap-werks,
        kwmeng TYPE vbap-kwmeng,
        brgew  TYPE vbap-brgew,
      END OF ty_vbap,

      BEGIN OF ty_vbfa,
        vbelv   TYPE vbfa-vbelv,
        posnv   TYPE vbfa-posnv,
        vbeln   TYPE vbfa-vbeln,
        posnn   TYPE vbfa-posnn,
        vbtyp_n TYPE vbfa-vbtyp_n,
        rfmng   TYPE vbfa-rfmng,

      END OF ty_vbfa,

      BEGIN OF ty_lips,
        vbeln TYPE lips-vbeln,
        posnr TYPE lips-posnr,
        brgew TYPE lips-brgew,

      END OF ty_lips,

      BEGIN OF ty_vekp ,
        venum TYPE vekp-venum,
      END OF ty_vekp,

      BEGIN OF ty_kna1,
        kunnr TYPE kna1-kunnr,
        name1 TYPE kna1-name1,
      END OF ty_kna1,

      BEGIN OF ty_final,
        vbeln  TYPE vbak-vbeln,
        erdat  TYPE vbak-erdat,
        auart  TYPE vbak-auart,
        vkorg  TYPE vbak-vkorg,
        knumv  TYPE vbak-knumv,
        kunnr  TYPE vbak-kunnr,
        posnv  TYPE vbfa-posnv,
        matnr  TYPE vbap-matnr,
        arktx  TYPE vbap-arktx,
        ntgew  TYPE vbap-ntgew,
*        brgew  TYPE lips-brgew,
        vbeln1 TYPE vbfa-vbeln,
        werks  TYPE vbap-werks,
        name1  TYPE kna1-name1,
        brgew  TYPE vbap-brgew,   "vbap-brgew,
      END OF ty_final,


      BEGIN OF ty_down,
        vbeln    TYPE vbak-vbeln,
        posnv    TYPE vbap-posnr,
        matnr    TYPE vbap-matnr,
        arktx    TYPE vbap-arktx,
        ntgew    TYPE char20,
        werks    TYPE char20,
        kunnr    TYPE char20,
        name1    TYPE char40,
        ref_dat  TYPE char15,                         "Refresh Date
        ref_time TYPE char15,                         "Refresh Time
        brgew    TYPE char20,  "vbap-brgew,
      END OF ty_down.



DATA: it_vbak  TYPE TABLE OF ty_vbak,
      wa_vbak  TYPE          ty_vbak,

      it_vbap  TYPE TABLE OF ty_vbap,
      wa_vbap  TYPE          ty_vbap,

      it_vbfa  TYPE TABLE OF ty_vbfa,
      wa_vbfa  TYPE          ty_vbfa,

      it_lips  TYPE TABLE OF ty_lips,
      wa_lips  TYPE          ty_lips,

      it_vekp  TYPE TABLE OF ty_vekp,
      wa_vekp  TYPE          ty_vekp,

      it_kna1  TYPE TABLE OF ty_kna1,
      wa_kna1  TYPE          ty_kna1,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS        : s_werks TYPE vbap-werks OBLIGATORY DEFAULT 'PL01'.
SELECT-OPTIONS    : s_matnr FOR vbap-matnr,
                    s_period FOR vbak-erdat OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.



SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'S_WERKS'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM display_data.
  PERFORM create_feildcat.
  PERFORM display.
*"""""""""""""""""""""""""""""""""""""
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
         erdat
         auart
         vkorg
         knumv
         kunnr
         FROM vbak
         INTO TABLE it_vbak
         WHERE erdat IN s_period.

  IF it_vbak IS NOT INITIAL.

    SELECT vbeln
           posnr
           matnr
           arktx
           ntgew
           werks
           kwmeng
           brgew
           FROM vbap
           INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbak
           WHERE werks = s_werks
           AND vbeln = it_vbak-vbeln
           and matnr in s_matnr.


    SELECT kunnr
           name1
           FROM kna1
           INTO TABLE it_kna1
           FOR ALL ENTRIES IN it_vbak
           WHERE kunnr = it_vbak-kunnr.


  ENDIF.

*  IF it_vbap IS NOT INITIAL.
*    SELECT  vbelv
*            posnv
*            vbeln
*            posnn
*            vbtyp_n
*            FROM vbfa
*            INTO TABLE it_vbfa
*            FOR ALL ENTRIES IN it_vbap
*            WHERE vbelv = it_vbap-vbeln
*            AND vbtyp_n = 'J'.
*
*
*
*    IF it_vbfa IS NOT INITIAL.
*      SELECT  vbeln
*              posnr
*              brgew
*           FROM lips
*           INTO TABLE it_lips
*        FOR ALL ENTRIES IN it_vbfa
*        WHERE   vbeln = it_vbfa-vbeln.
*    ENDIF.
*  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .


  LOOP AT it_vbap INTO wa_vbap.


*    LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_vbap-vbeln AND posnv = wa_vbap-posnr.


*      wa_final-vbeln1 = wa_vbfa-vbeln.
*      wa_final-posnv = wa_vbfa-posnv.


      wa_final-posnv = wa_vbap-posnr.

      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln.

      IF sy-subrc = '0'.
        wa_final-vbeln = wa_vbak-vbeln.
        wa_final-kunnr = wa_vbak-kunnr.
      ENDIF.


*      READ TABLE it_lips INTO wa_lips WITH KEY vbeln = wa_vbfa-vbeln posnr = wa_vbfa-posnn.
*      IF sy-subrc = '0'.
*        wa_final-brgew = wa_lips-brgew.
*      ENDIF.

      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.
      IF sy-subrc = '0'.
        wa_final-name1 = wa_kna1-name1.
      ENDIF.



      wa_final-matnr = wa_vbap-matnr.
      wa_final-arktx = wa_vbap-arktx.

      IF wa_vbap-kwmeng IS NOT INITIAL.
        wa_final-ntgew = wa_vbap-ntgew / wa_vbap-kwmeng.
      ELSE.
        wa_final-ntgew = wa_vbap-ntgew.
      ENDIF.

      wa_final-werks = wa_vbap-werks.

      IF wa_vbap-kwmeng IS NOT INITIAL.
        wa_final-brgew = wa_vbap-brgew / wa_vbap-kwmeng.
      ELSE.
        wa_final-brgew = wa_vbap-brgew.
      ENDIF.

    " IF WA_FINAL-BRGEW IS NOT INITIAL.
    "  REPLACE ALL OCCURRENCES OF ',' in wa_final-brgew with ''.
    " ENDIF.

      APPEND wa_final TO it_final.
      CLEAR : wa_final.


*    ENDLOOP.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FEILDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_feildcat .

  PERFORM fcat USING : '1'   'VBELN'           'IT_FINAL'      'Sales Order NO'                             '10' ,
                       '2'   'POSNV'           'IT_FINAL'      'Sales Order Line Item No'                   '10' ,
                       '3'   'MATNR'           'IT_FINAL'      'Material No'                                '15' ,
                       '4'   'ARKTX'           'IT_FINAL'      'Material Description'                       '20' ,
                       '5'   'WERKS'           'IT_FINAL'      'Plant'                                      '06' ,
                       '6'   'NTGEW'           'IT_FINAL'      'Net Weight/KG'                                 '10' ,
                       '7'   'KUNNR'           'IT_FINAL'      'Customer No'                                '10' ,
                       '8'   'NAME1'           'IT_FINAL'      'Customer Name'                              '20' ,
                       '9'   'BRGEW'           'IT_FINAL'      'Gross Weight'                              '10' .









ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0447   text
*      -->P_0448   text
*      -->P_0449   text
*      -->P_0450   text
*      -->P_0451   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).

  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
  wa_fcat-outputlen   = p5.

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
    ls_down-vbeln = wa_final-vbeln.
    ls_down-posnv = wa_final-posnv.
    ls_down-matnr = wa_final-matnr.
    ls_down-arktx = wa_final-arktx.
    ls_down-ntgew = wa_final-ntgew.
    ls_down-werks = wa_final-werks.
    ls_down-kunnr = wa_final-kunnr.
    ls_down-name1 = wa_final-name1.
    ls_down-brgew = wa_final-brgew.




    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref_dat.
    CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
   INTO ls_down-ref_dat SEPARATED BY '-'.

    ls_down-ref_time = sy-uzeit.
    CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.


    APPEND ls_down TO lt_down.
    CLEAR: ls_down.     "wa_final.

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
      i_tab_sap_data       = lt_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZITEM_WEIGHT.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZITEM_WEIGHT_PROGRAM Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_521 TYPE string.
DATA lv_crlf_521 TYPE string.
lv_crlf_521 = cl_abap_char_utilities=>cr_lf.
lv_string_521 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_521 lv_crlf_521 wa_csv INTO lv_string_521.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_521 TO lv_fullfile.
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

  CONCATENATE           'Sales Order NO'
                        'Sales Order Line Item No'
                        'Material No'
                        'Material Description'
                        'Net Weight/KG'
                        'Plant'
                        'Customer No'
                        'Customer Name'
                        'Refresh date'
                        'Refresh time'
                        'Gross Weight'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.


ENDFORM.
