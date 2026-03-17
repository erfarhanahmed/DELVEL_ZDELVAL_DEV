*&---------------------------------------------------------------------*
*& REPORT ZPAYTERM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpayterm_new.

TABLES : t052u, t052s, knb1, knvv, lfb1, lfm1.

TYPES : BEGIN OF ty_t052u,         "2
          text1 TYPE t052u-text1,
          zterm TYPE t052u-zterm,
          spras TYPE t052u-spras,
        END OF ty_t052u.

TYPES : BEGIN OF ty_t052s,         "3
          zterm TYPE t052s-zterm,
*        RATNR TYPE T052S-RATNR,
          ratzt TYPE t052s-ratzt,
        END OF ty_t052s.

TYPES : BEGIN OF ty_t052,
          zterm TYPE t052-zterm,
          ztag1 TYPE t052-ztag1,
         XSPLT  TYPE t052-xsplt,
*         text1  TYPE t052-text1,
        END OF ty_t052.


TYPES : BEGIN OF ty_final,
          zterm TYPE t052u-zterm,
          text1 TYPE t052u-text1,
          ratzt TYPE t052s-ratzt,
          text2 TYPE t052u-text1,
          ztag1 TYPE t052-ztag1,
          ztag2 TYPE t052-ztag1,
        END OF ty_final.

TYPES : BEGIN OF ty_down,
          zterm    TYPE t052u-zterm,
          text1    TYPE t052u-text1,
          ratzt    TYPE t052s-ratzt,
          text2    TYPE t052u-text1,
          ref_date TYPE char11,
          ref_time TYPE char15,
          ztag1    TYPE char10,
          ztag2    TYPE char10,
        END OF ty_down.

DATA : it_t052u    TYPE TABLE OF ty_t052u,
       wa_t052u    TYPE ty_t052u,
       it_t052u_sub    TYPE TABLE OF ty_t052u,
       wa_t052u_sub    TYPE ty_t052u,
       it_t052      TYPE TABLE OF ty_t052,
       wa_t052     TYPE ty_t052,
        it_t052_main      TYPE TABLE OF ty_t052,
       wa_t052_main     TYPE ty_t052,
       it_t052u1   TYPE TABLE OF ty_t052u,
       wa_t052u1   TYPE ty_t052u,
       it_t052s1   TYPE TABLE OF ty_t052s,
       wa_t052s1   TYPE ty_t052s,

       it_t052s    TYPE TABLE OF ty_t052s,
       wa_t052s    TYPE ty_t052s,
*       IT_KNB1     TYPE TABLE OF TY_KNB1,
*       WA_KNB1     TYPE TY_KNB1,
*       IT_KNVV     TYPE TABLE OF TY_KNVV,
*       WA_KNVV     TYPE TY_KNVV,
*       IT_LFB1     TYPE TABLE OF TY_LFB1,
*       WA_LFB1     TYPE TY_LFB1,
*       IT_LFM1     TYPE TABLE OF TY_LFM1,
*       WA_LFM1     TYPE TY_LFM1,
       it_final    TYPE TABLE OF ty_final,
       wa_final    TYPE ty_final,
       lt_fieldcat TYPE slis_t_fieldcat_alv,
       ls_fieldcat TYPE slis_fieldcat_alv,
       it_down     TYPE TABLE OF ty_down,
       wa_down     TYPE ty_down.

DATA : wa_layout          TYPE  slis_layout_alv,
       i_list_top_of_page TYPE slis_t_listheader.   " TOP-OF-PAGE

*DATA : EKORG TYPE  LFM1-EKORG,
*       VKORG TYPE KNVV-VKORG.
SELECTION-SCREEN BEGIN OF BLOCK b1.
SELECT-OPTIONS : p_zterm FOR knvv-zterm." OBLIGATORY,
*             P_EKORG TYPE LFM1-EKORG,
*             P_VKORG TYPE KNVV-VKORG.
SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002.
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp'.
      "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
*SELECTION-SCREEN  COMMENT /1(60) TEXT-005.
*SELECTION-SCREEN  COMMENT /1(60) TEXT-006.
SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.
  if P_Zterm is NOT INITIAL.
    select SINGLE zterm from t052 INTO @data(gv_term)
      where zterm IN  @p_zterm
       and xsplt EQ 'X'.
      IF SY-SUBRC IS not INITIAL.
         MESSAGE e001(ZDELVAL_MESAGE).
      endif.
  endif.

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
*
  SELECT text1
           zterm
      FROM t052u INTO TABLE it_t052u
      WHERE zterm IN p_zterm
       AND spras = 'EN'.
*      ENDIF.

  IF it_t052u IS NOT INITIAL.
   SELECT zterm
        ratzt
   FROM t052s INTO TABLE it_t052s FOR ALL ENTRIES IN it_t052u
   WHERE zterm = it_t052u-zterm.

       SELECT ZTERM
           ztag1
           XSPLT
    FROM t052 INTO TABLE it_t052_main FOR ALL ENTRIES IN it_t052u
    WHERE zterm = it_t052u-zterm.

  endif.
   loop at it_t052s INTO DATA(wa).
    delete it_t052u where zterm = wa-ratzt.
  endloop.

 if it_t052s is NOT INITIAL.
    SELECT ZTERM
           ztag1
           XSPLT
    FROM t052 INTO TABLE it_t052 FOR ALL ENTRIES IN it_t052s
    WHERE zterm = it_t052s-ratzt.

    SELECT text1
           zterm
      FROM t052u INTO TABLE it_t052u_sub
      FOR ALL ENTRIES IN it_t052s
      WHERE zterm = it_t052s-ratzt
       AND spras = 'EN'.

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


*  LOOP AT IT_T052S INTO WA_T052S." WHERE ZTERM = WA_KNVV-ZTERM..                                  "ADDED BY AAKASHK 30.08.2024

  LOOP AT it_t052u INTO wa_t052u." WHERE ZTERM =  WA_T052S-ZTERM.

    wa_final-zterm = wa_t052u-zterm.
    wa_final-text1 = wa_t052u-text1.

   READ TABLE it_t052_main INTO wa_t052_main WITH KEY zterm = wa_t052u-zterm.
       IF SY-SUBRC IS INITIAL.
         wa_final-ztag2 = wa_t052_main-ztag1.
*          wa_final-text1 = wa_t052-text1.
       ENDIF.

*   ON CHANGE OF WA_FINAL-ZTERM.
    LOOP AT it_t052s INTO wa_t052s WHERE zterm = wa_t052u-zterm..
      wa_final-ratzt = wa_t052s-ratzt.


      READ TABLE it_t052 INTO wa_t052 WITH KEY zterm = wa_t052s-ratzt.
       IF SY-SUBRC IS INITIAL.
         wa_final-ztag1 = wa_t052-ztag1.
*          wa_final-text1 = wa_t052-text1.
       ENDIF.
       READ TABLE it_t052u INTO wa_t052u WITH KEY zterm = wa_t052u-zterm.
       IF SY-SUBRC IS  INITIAL.
           wa_final-zterm = wa_t052u-zterm.
           wa_final-text1 = wa_t052u-text1.
       ENDIF.

      READ TABLE it_t052u_sub INTO wa_t052u_sub WITH KEY zterm = wa_t052s-ratzt.
       IF SY-SUBRC IS  INITIAL.
*      wa_final-zterm = wa_t052u-zterm.
      wa_final-text2 = wa_t052u_sub-text1.
      ENDIF.

*      READ TABLE it_t052u INTO wa_t052u WITH KEY zterm =  wa_t052s-ratzt.
*       IF SY-SUBRC IS  INITIAL.
*      wa_final-text2 = wa_t052u-text1.
*      ENDIF.
*

        APPEND wa_final TO it_final.
          CLEAR : wa_final.
    ENDLOOP.
*  ENDON.
*    ENDIF.
    APPEND wa_final TO it_final.
    CLEAR : wa_final.
  ENDLOOP.
*
  DELETE it_final WHERE zterm IS INITIAL AND text1 IS INITIAL AND ratzt IS INITIAL and
  text2 is initial .

  SORT it_final BY zterm ratzt.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS.
*
***************************************************************************
  IF p_down EQ 'X'.

    LOOP AT it_final INTO wa_final.

*   CONCATENATE SY-DATUM+4(2)  SY-DATUM+6(2) SY-DATUM+0(4)
*      INTO  WA_DOWN-REF_ON SEPARATED BY '.'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.
      IF wa_down-ref_date IS NOT INITIAL.
        CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                        INTO wa_down-ref_date SEPARATED BY '-'.
        wa_down-ref_time = sy-uzeit.
      ENDIF.

*      WA_DOWN-BUKRS   =  WA_FINAL-BUKRS    .
*      WA_DOWN-VKORG   =  WA_FINAL-VKORG    .
*      WA_DOWN-EKORG   =  WA_FINAL-EKORG    .
      wa_down-zterm   =  wa_final-zterm    .
      wa_down-ratzt   =  wa_final-ratzt  .
      wa_down-text1   =  wa_final-text1    .
      wa_down-text2   =  wa_final-text2   .
      wa_down-ztag1   =  wa_final-ztag1   .
      wa_down-ztag2   =  wa_final-ztag2   .

      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.
      APPEND wa_down TO it_down.  "ENDADD.
    ENDLOOP.
  ENDIF.

ENDFORM.
***************************************************************************************************

*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .


  ls_fieldcat-col_pos = 1.
  ls_fieldcat-fieldname = 'ZTERM'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Payment term'.
  ls_fieldcat-outputlen = '04'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 2.
  ls_fieldcat-fieldname = 'TEXT1'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Payment term details'.
  ls_fieldcat-outputlen = '50'.
  APPEND ls_fieldcat TO lt_fieldcat.


  ls_fieldcat-col_pos = 3.
  ls_fieldcat-fieldname = 'RATZT'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Sub Payment term'.
  ls_fieldcat-outputlen = '04'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 4.
  ls_fieldcat-fieldname = 'TEXT2'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'SubPayment term details'.
  ls_fieldcat-outputlen = '50'.
  APPEND ls_fieldcat TO lt_fieldcat.

   ls_fieldcat-col_pos = 5.
  ls_fieldcat-fieldname = 'ZTAG1'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Subpayment Term No of Days'.
  ls_fieldcat-outputlen = '30'.
   APPEND ls_fieldcat TO lt_fieldcat.

   ls_fieldcat-col_pos = 6.
  ls_fieldcat-fieldname = 'ZTAG2'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_l = 'Payment Term No Of Days'.
  ls_fieldcat-outputlen = '30'.
  APPEND ls_fieldcat TO lt_fieldcat.
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
      i_callback_program = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          = wa_layout
      it_fieldcat        = lt_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
      i_save             = 'X'
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

*&---------------------------------------------------------------------*           "ADDED BY AAKASHK 19.08.2024
*&      FORM  DOWNLOAD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: LV_FOLDER(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZPAYTERM.TXT'.
*

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPAYTERM.TXT DOWNLOAD STARTED ON', sy-datum, 'AT', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_436 TYPE string.
DATA lv_crlf_436 TYPE string.
lv_crlf_436 = cl_abap_char_utilities=>cr_lf.
lv_string_436 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_436 lv_crlf_436 wa_csv INTO lv_string_436.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1008 TO lv_fullfile.
TRANSFER lv_string_436 TO lv_fullfile.
    CLOSE DATASET lv_fullfile.
    CONCATENATE 'FILE' lv_fullfile 'DOWNLOADED' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  CVS_HEADER
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_HD_CSV  TEXT
*----------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE
              'Payment term'
              'Payment term details'
              'Sub Payment term'
              'SubPayment term details'
              'Refreshable Date'
              'Refreshable Time'
              'No. of Days(Subpayment Term)'
              'No. of Days(Payment Term)'
    INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
