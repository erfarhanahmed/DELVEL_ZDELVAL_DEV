*&---------------------------------------------------------------------*
*& Report ZUS_SHORTFALL_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_SHORTFALL_REPORT.

TABLES:VBAK.


TYPES: BEGIN OF TY_VBAK,
       VBELN    TYPE VBAK-VBELN,
       ERDAT    TYPE VBAK-ERDAT,
       AUDAT    TYPE VBAK-AUDAT,
       VBTYP    TYPE VBAK-VBTYP,
       AUART    TYPE VBAK-AUART,
       VKORG    TYPE VBAK-VKORG,
       KUNNR    TYPE VBAK-KUNNR,
       POSNR    TYPE VBAP-POSNR,
       MATNR    TYPE VBAP-MATNR,
       KWMENG   TYPE VBAP-KWMENG,
       WERKS    TYPE VBAP-WERKS,
       END OF TY_VBAK,

       BEGIN OF TY_VBAP,
       VBELN    TYPE VBAP-VBELN,
       POSNR    TYPE VBAP-POSNR,
       MATNR    TYPE VBAP-MATNR,
       KWMENG   TYPE VBAP-KWMENG,
       DELDATE  TYPE VBAP-DELDATE,
       END OF TY_VBAP,

       BEGIN OF TY_VBKD,
       VBELN    TYPE VBKD-VBELN,
       POSNR    TYPE VBKD-POSNR,
       BSTKD    TYPE VBKD-BSTKD,
       BSTDK    TYPE VBKD-BSTDK,
       END OF TY_VBKD,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         LABST TYPE mard-LABST,
         INSME TYPE mard-INSME,
       END OF ty_mard,

       BEGIN OF ty_lips,
       vbeln TYPE lips-vbeln,
       posnr TYPE lips-posnr,
       WERKS TYPE lips-WERKS,
       LFIMG TYPE lips-LFIMG,
       VGBEL TYPE lips-VGBEL,
       VGPOS TYPE lips-VGPOS,
       END OF ty_lips,

       BEGIN OF TY_FINAL,
       KUNNR    TYPE VBAK-KUNNR,
       BSTKD    TYPE VBKD-BSTKD,
       BSTDK    TYPE VBKD-BSTDK,
       VBELN    TYPE VBAP-VBELN,
       POSNR    TYPE VBAP-POSNR,
       AUDAT    TYPE VBAK-AUDAT,
       MATNR    TYPE VBAP-MATNR,
       WRKST    TYPE MARA-WRKST,
       MAKTX    TYPE MAKT-MAKTX,
       DELDATE  TYPE VBAP-DELDATE,
       KWMENG   TYPE VBAP-KWMENG,
       PND_SO   TYPE VBAP-KWMENG,
       SO_SRT   TYPE VBAP-KWMENG,
       TRNST    TYPE VBAP-KWMENG,
       lfimg    TYPE lips-lfimg,
       END OF TY_FINAL,

       BEGIN OF ty_down,
       KUNNR    TYPE VBAK-KUNNR,
       BSTKD    TYPE VBKD-BSTKD,
       BSTDK    TYPE char15,
       VBELN    TYPE VBAP-VBELN,
       POSNR    TYPE VBAP-POSNR,
       AUDAT    TYPE char15,
       MATNR    TYPE VBAP-MATNR,
       WRKST    TYPE MARA-WRKST,
       MAKTX    TYPE MAKT-MAKTX,
       DELDATE  TYPE char15,
       KWMENG   TYPE char15,
       SO_SRT   TYPE char15,
       PND_SO   TYPE char15,
       ref      TYPE char15,
       END OF ty_down.



DATA : IT_VBAK TYPE TABLE OF TY_VBAK,
       WA_VBAK TYPE          TY_VBAK,

       IT_VBAP TYPE TABLE OF TY_VBAP,
       WA_VBAP TYPE          TY_VBAP,

       IT_VBKD TYPE TABLE OF TY_VBKD,
       WA_VBKD TYPE          TY_VBKD,

       it_mard TYPE TABLE OF ty_mard,
       wa_mard TYPE          ty_mard,

       it_lips TYPE TABLE OF ty_lips,
       wa_lips TYPE          ty_lips,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.

DATA : lt_fcat TYPE slis_t_fieldcat_alv,
       ls_fcat TYPE slis_fieldcat_alv.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_VBELN FOR VBAK-VBELN,
                   S_DATE  FOR VBAK-AUDAT.
  PARAMETERS :     P_VKORG TYPE VBAK-VKORG OBLIGATORY DEFAULT 'US00'.
SELECTION-SCREEN: END OF BLOCK B1 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT   '/Delval/USA'."USA'."usa'.        "'/delval/usa'.
SELECTION-SCREEN END OF BLOCK b2.


START-OF-SELECTION .

PERFORM GET_DATA.
PERFORM SORT_DATA.
PERFORM get_fcat.
PERFORM display.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  BREAK primus.
SELECT a~VBELN
       a~ERDAT
       a~AUDAT
       a~VBTYP
       a~AUART
       a~VKORG
       a~KUNNR
       b~posnr
       b~matnr
       b~kwmeng
       b~WERKS FROM VBAK AS a
       JOIN vbap AS b ON a~vbeln = b~vbeln
       JOIN vbup as c ON ( a~vbeln = c~vbeln and b~posnr = c~posnr ) INTO TABLE IT_VBAK
       WHERE a~VBELN IN S_VBELN
         AND a~AUDAT IN S_DATE
         AND a~VKORG = P_VKORG
         AND c~LFSTA  NE 'C'
         AND c~LFGSA  NE 'C'
         AND c~FKSTA  NE 'C'
         AND c~GBSTA  NE 'C'.




IF IT_VBAK IS NOT INITIAL.
SELECT VBELN
       POSNR
       MATNR
       KWMENG
       DELDATE FROM VBAP INTO TABLE IT_VBAP
       FOR ALL ENTRIES IN IT_VBAK
       WHERE VBELN = IT_VBAK-VBELN.


SELECT VBELN
       POSNR
       BSTKD
       BSTDK FROM VBKD INTO TABLE IT_VBKD
       FOR ALL ENTRIES IN IT_VBAK
       WHERE VBELN = IT_VBAK-VBELN.

SELECT matnr
       werks
       lgort
       LABST
       INSME FROM mard INTO TABLE it_mard
       FOR ALL ENTRIES IN it_vbak
       WHERE matnr = it_vbak-matnr
        AND  werks = it_vbak-werks.

SELECT vbeln
       posnr
       WERKS
       LFIMG
       VGBEL
       VGPOS FROM lips INTO TABLE it_lips
       FOR ALL ENTRIES IN it_vbak
       WHERE vgbel = it_vbak-vbeln
         AND vgpos = it_vbak-posnr.

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
DATA:STOCK TYPE MARD-LABST.
SORT it_vbak BY matnr audat DESCENDING.

LOOP AT IT_VBAK INTO WA_VBAK.

  WA_FINAL-VBELN    =  WA_VBAK-VBELN  .
  WA_FINAL-POSNR    =  WA_VBAK-POSNR  .
  WA_FINAL-MATNR    =  WA_VBAK-MATNR  .
  WA_FINAL-KWMENG   =  WA_VBAK-KWMENG .
  WA_FINAL-KUNNR    =  WA_VBAK-KUNNR .
  WA_FINAL-AUDAT    =  WA_VBAK-AUDAT .




ON CHANGE OF WA_VBAK-MATNR.
CLEAR  STOCK.
LOOP AT IT_MARD INTO WA_MARD WHERE MATNR = WA_VBAK-MATNR.
STOCK = STOCK + WA_MARD-LABST.
STOCK = STOCK + WA_MARD-INSME.
ENDLOOP.
ENDON.

LOOP AT it_lips INTO wa_lips WHERE vgbel = wa_vbak-vbeln AND vgpos = wa_vbak-posnr.
wa_final-lfimg = wa_final-lfimg + wa_lips-lfimg .
ENDLOOP.
  WA_final-pnd_so = WA_VBAK-KWMENG - wa_final-lfimg.
  WA_VBAK-KWMENG = WA_final-pnd_so.
  WA_FINAL-SO_SRT = STOCK - WA_VBAK-KWMENG.
  STOCK = WA_FINAL-SO_SRT.





 READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_VBAK-VBELN POSNR = WA_VBAK-POSNR.
 IF SY-SUBRC = 0.
  WA_FINAL-DELDATE  =  WA_VBAP-DELDATE.
 ENDIF.

 READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_VBAK-VBELN.
  IF SY-SUBRC = 0.
    WA_FINAL-BSTKD  =  WA_VBKD-BSTKD .
    WA_FINAL-BSTDK  =  WA_VBKD-BSTDK .
  ENDIF.


SELECT SINGLE MAKTX INTO WA_FINAL-MAKTX FROM MAKT WHERE MATNR = WA_VBAK-MATNR.
SELECT SINGLE WRKST INTO WA_FINAL-WRKST FROM MARA WHERE MATNR = WA_VBAK-MATNR.


 APPEND WA_FINAL TO IT_FINAL.
 CLEAR: WA_FINAL.
ENDLOOP.

SORT IT_FINAL BY VBELN POSNR.

IF p_down = 'X'.
  LOOP AT IT_FINAL INTO WA_FINAL.
    WA_DOWN-KUNNR   = WA_FINAL-KUNNR  .
    WA_DOWN-BSTKD   = WA_FINAL-BSTKD  .
*    WA_DOWN-BSTDK   = WA_FINAL-BSTDK  .

    IF WA_FINAL-BSTDK IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BSTDK
        IMPORTING
          OUTPUT = WA_DOWN-BSTDK.

      CONCATENATE WA_DOWN-BSTDK+0(2) WA_DOWN-BSTDK+2(3) WA_DOWN-BSTDK+5(4)
                      INTO WA_DOWN-BSTDK SEPARATED BY '-'.

    ENDIF.




    WA_DOWN-VBELN   = WA_FINAL-VBELN  .
    WA_DOWN-POSNR   = WA_FINAL-POSNR  .
*    WA_DOWN-AUDAT   = WA_FINAL-AUDAT  .

    IF WA_FINAL-AUDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-AUDAT
        IMPORTING
          OUTPUT = WA_DOWN-AUDAT.

      CONCATENATE WA_DOWN-AUDAT+0(2) WA_DOWN-AUDAT+2(3) WA_DOWN-AUDAT+5(4)
                      INTO WA_DOWN-AUDAT SEPARATED BY '-'.

    ENDIF.


    WA_DOWN-MATNR   = WA_FINAL-MATNR  .
    WA_DOWN-WRKST   = WA_FINAL-WRKST  .
    WA_DOWN-MAKTX   = WA_FINAL-MAKTX  .
*    WA_DOWN-DELDATE = WA_FINAL-DELDATE.

    IF WA_FINAL-DELDATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-DELDATE
        IMPORTING
          OUTPUT = WA_DOWN-DELDATE.

      CONCATENATE WA_DOWN-DELDATE+0(2) WA_DOWN-DELDATE+2(3) WA_DOWN-DELDATE+5(4)
                      INTO WA_DOWN-DELDATE SEPARATED BY '-'.

    ENDIF.

    WA_DOWN-KWMENG  = ABS( WA_FINAL-KWMENG ) .
    WA_DOWN-SO_SRT  = ABS( WA_FINAL-SO_SRT ).
    WA_DOWN-PND_SO  = ABS( WA_FINAL-PND_SO ).

   IF WA_FINAL-KWMENG < 0.
     CONDENSE WA_DOWN-KWMENG.
     CONCATENATE '-' WA_DOWN-KWMENG INTO WA_DOWN-KWMENG.
   ENDIF.

   IF WA_FINAL-SO_SRT < 0.
     CONDENSE WA_DOWN-SO_SRT.
     CONCATENATE '-' WA_DOWN-SO_SRT INTO WA_DOWN-SO_SRT.
   ENDIF.

   IF WA_FINAL-PND_SO < 0.
     CONDENSE WA_DOWN-PND_SO.
     CONCATENATE '-' WA_DOWN-PND_SO INTO WA_DOWN-PND_SO.
   ENDIF.

   CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

   APPEND WA_DOWN TO IT_DOWN.
   CLEAR WA_DOWN.
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
PERFORM fcat USING : '1'   'KUNNR'           'IT_FINAL'      'Customer'                 '15',
                     '2'   'BSTKD'           'IT_FINAL'      'Customer Po'                      '15' ,
                     '3'   'BSTDK'           'IT_FINAL'      'Cust.Po.Dt'                      '15' ,
                     '4'   'VBELN'           'IT_FINAL'      'Sales Order'                      '15' ,
                     '5'   'POSNR'           'IT_FINAL'      'SO Line Item'                      '15' ,
                     '6'   'AUDAT'           'IT_FINAL'      'SO Date'                      '15' ,
                     '7'   'MATNR'           'IT_FINAL'      'Material'                      '20' ,
                     '8'   'WRKST'           'IT_FINAL'      'USA Code'                      '15' ,
                     '9'   'MAKTX'           'IT_FINAL'      'Material Desc'                      '15' ,
                    '10'   'DELDATE'         'IT_FINAL'      'CDD'                      '15' ,
                    '11'   'KWMENG'          'IT_FINAL'      'SO Quantity'                      '15' ,
                    '12'   'SO_SRT'          'IT_FINAL'      'Shortfall Quantity'                      '15' ,
                    '13'   'PND_SO'          'IT_FINAL'      'Pend So Qty'                      '15' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0380   text
*      -->P_0381   text
*      -->P_0382   text
*      -->P_0383   text
*      -->P_0384   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                 VALUE(p2)
                 VALUE(p3)
                 VALUE(p4)
                 VALUE(p5).
*                 VALUE(p6).

  ls_fcat-col_pos       = p1.
  ls_fcat-fieldname     = p2.
  ls_fcat-tabname       = p3.
  ls_fcat-seltext_l     = p4.
  ls_fcat-outputlen     = p5.
*  ls_fcat-ref_fieldname = p6.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.
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
      it_fieldcat        = lt_fcat
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
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



IF p_down = 'X'.

    PERFORM download.

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


    lv_file = 'ZUS_SHORTFALL.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_SHORTFALL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_528 TYPE string.
DATA lv_crlf_528 TYPE string.
lv_crlf_528 = cl_abap_char_utilities=>cr_lf.
lv_string_528 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_528 lv_crlf_528 wa_csv INTO lv_string_528.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_528 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
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


    lv_file = 'ZUS_SHORTFALL.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_SHORTFALL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_565 TYPE string.
DATA lv_crlf_565 TYPE string.
lv_crlf_565 = cl_abap_char_utilities=>cr_lf.
lv_string_565 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_565 lv_crlf_565 wa_csv INTO lv_string_565.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_565 TO lv_fullfile.
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
FORM cvs_header  USING    PD_CSV.         "p_hd_csv.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Customer'
              'Customer Po'
              'Cust.Po.Dt'
              'Sales Order'
              'SO Line Item'
              'SO Date'
              'Material'
              'USA Code'
              'Material Desc'
              'CDD'
              'SO Quantity'
              'Shortfall Quantity'
              'Pend So Qty'
              'Refreshable Date'
              INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
