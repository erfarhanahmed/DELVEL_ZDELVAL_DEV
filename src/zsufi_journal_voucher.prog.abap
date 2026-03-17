*&---------------------------------------------------------------------*
*& Report ZSUFI_JOURNAL_VOUCHER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsufi_journal_voucher.

TABLES : bkpf,bseg.

DATA : it_final TYPE  zsu_fi_jv,
       wa_final TYPE zsu_fi.

DATA : fm_name           TYPE rs38l_fnam,
       formname          TYPE tdsfname,
       control           TYPE ssfctrlop,        "CONTROL PARAMETERS
       out_opt           TYPE ssfcompop,
       return1           TYPE ssfcrescl,
       ls_composer_param TYPE ssfcompop,
       gs_con_settings   TYPE ssfctrlop,
       length            TYPE i.

DATA : lt_t003 TYPE TABLE OF t003,
       ls_t003 TYPE t003.

DATA : lt_t003t TYPE TABLE OF t003t,
       ls_t003t TYPE t003t.

DATA : lv_text TYPE string.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS : p_bukrs   TYPE bkpf-bukrs DEFAULT 'SU00' MODIF ID bu.
  SELECT-OPTIONS :   p_gjahr   FOR bkpf-gjahr  NO INTERVALS NO-EXTENSION ,
                   p_belnr   FOR bkpf-belnr,
                   s_budat   FOR bkpf-budat,
*                   P_USNAME  FOR BKPF-SNAME  NO INTERVALS NO-EXTENSION ,
                   p_blart   FOR bkpf-blart  NO INTERVALS NO-EXTENSION .
  PARAMETERS : p_waers  TYPE bkpf-waers OBLIGATORY.
*                   P_hwaer TYPE BKPF-hwaer." DEFAULT 'SAR' MODIF ID HW.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
*      IF SCREEN-GROUP1 = 'HW'.
*      SCREEN-INPUT = '0'.
*      MODIFY SCREEN.
*    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM process_data.
  PERFORM display_data.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  IF p_waers NE 'SAR' .

    SELECT bukrs
            belnr
            gjahr
            budat
            usnam
            blart
            waers
            kursf
            hwaer
      FROM bkpf
      INTO TABLE it_final
      WHERE bukrs  EQ p_bukrs
      AND gjahr IN p_gjahr
      AND belnr IN p_belnr
      AND budat IN s_budat
*  and usnam in P_USNAME
    AND waers EQ  p_waers
*  OR HWAER EQ  P_waers
    AND blart IN p_blart.

  ELSE.
    SELECT bukrs
            belnr
            gjahr
            budat
            usnam
            blart
            waers
            kursf
            hwaer
      FROM bkpf
      INTO TABLE it_final
      WHERE bukrs  EQ p_bukrs
      AND gjahr IN p_gjahr
      AND belnr IN p_belnr
      AND budat IN s_budat
*  and usnam in P_USNAME
*  and waers EQ  P_waers
    AND hwaer EQ  p_waers
    AND blart IN p_blart.
*  ENDIF.
  ENDIF.
*IF it_final IS INITIAL.
*  IF P_waers IS INITIAL.
*    select bukrs
*        belnr
*        gjahr
*        budat
*        usnam
*        blart
*        waers
*        kursf
*        HWAER
*  from bkpf
*  into table it_final
*  where BUKRS  EQ P_BUKRS
*  AND gjahr in P_GJAHR
*  AND belnr in P_BELNR
*  AND budat in s_BUDAT
*    and blart in P_BLART.
*  ENDIF.
*  ENDIF.

  IF it_final IS NOT INITIAL.
    SELECT blart
      FROM t003
    INTO CORRESPONDING FIELDS OF TABLE lt_t003
    FOR ALL ENTRIES IN it_final
    WHERE blart = it_final-blart.

    IF lt_t003 IS NOT INITIAL.
      SELECT blart ltext
        FROM t003t
   INTO CORRESPONDING FIELDS OF TABLE lt_t003t
      FOR ALL ENTRIES IN lt_t003
      WHERE blart = lt_t003-blart
      AND spras = 'EN'.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_data .
  "loop at it_bkpf into wa_bkpf.


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

  ""**************************************************Adobe **********************************************

  DATA: lv_fm_name       TYPE funcname,
        lv_doc_params    TYPE sfpdocparams,
        lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
        ls_form_output   TYPE fpformoutput.
  DATA:       e_funcnm TYPE funcname .             " Name of the Function Module
  CONSTANTS : sf_name1 TYPE fpname VALUE 'ZSUFI_JOURNAL_VOUCHER_2_SFP'.



  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lv_output_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = sf_name1 "" 'ZADOBE_SAMPLE_FORM'  " Your Adobe form name
    IMPORTING
      e_funcname = e_funcnm.



  DATA : gv_tot_lines          TYPE i.
  DESCRIBE TABLE it_final LINES gv_tot_lines.

  LOOP AT it_final INTO wa_final.

*  BREAK primus.


    IF sy-tabix = 1.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_false.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_false.
* CLOSE SPOOL AT THE LAST LOOP ONLY
      gs_con_settings-no_close  = abap_true.
    ELSE.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_true.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_true.
    ENDIF.

    IF sy-tabix = gv_tot_lines.
* CLOSE SPOOL
      gs_con_settings-no_close  = abap_false.
    ENDIF.

    READ TABLE lt_t003t INTO ls_t003t WITH KEY blart = wa_final-blart.
    IF sy-subrc = 0.
      lv_text = ls_t003t-ltext.
    ENDIF.

    CALL FUNCTION e_funcnm " '/1BCDWB/SM00000068'
      EXPORTING
*       /1BCDWB/DOCPARAMS        =
        belnr     = wa_final-belnr
        gjahr     = wa_final-gjahr
        waers     = p_waers
        wa_final1 = wa_final
        ls_text   = lv_text
        it_final  = it_final
* IMPORTING
*       /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*       USAGE_ERROR              = 1
*       SYSTEM_ERROR             = 2
*       INTERNAL_ERROR           = 3
*       OTHERS    = 4
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.



*    CALL FUNCTION e_funcnm  "'/1BCDWB/SM00000068'
*      EXPORTING
**       /1BCDWB/DOCPARAMS  =
*        control_parameters = gs_con_settings
**       mail_appl_obj      =
**       mail_recipient     =
**       mail_sender        =
*        output_options     = ls_composer_param
**       user_settings      =
*        belnr              = wa_final-belnr
*        gjahr              = wa_final-gjahr
*        waers              = p_waers
*        wa_final1          = wa_final
*        ls_text            = lv_text
*        it_final           = it_final
** IMPORTING
**       /1BCDWB/FORMOUTPUT =
* EXCEPTIONS
*       USAGE_ERROR        = 1
*       SYSTEM_ERROR       = 2
*       INTERNAL_ERROR     = 3
*       OTHERS             = 4
*      .
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.



    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.

    IF sy-subrc <> 0.
      MESSAGE 'Error closing Adobe form job' TYPE 'E'.
    ENDIF.




    ""*********************************************************************Adobe close******************************************

*
*CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*  EXPORTING
*    FORMNAME                 = 'ZSUFI_JOURNAL_VOUCHER_2'
**   VARIANT                  = ' '
**   DIRECT_CALL              = ' '
* IMPORTING
*   FM_NAME                  = FM_NAME
** EXCEPTIONS
**   NO_FORM                  = 1
**   NO_FUNCTION_MODULE       = 2
**   OTHERS                   = 3
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.
*
*
*Data : gv_tot_lines          TYPE i.
*DESCRIBE TABLE IT_FINAL LINES gv_tot_lines.
*
*loop at it_final into wa_final.
*
**  BREAK primus.
*
*
* IF sy-tabix = 1.
** DIALOG AT FIRST LOOP ONLY
*      gs_con_settings-no_dialog = abap_false.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*      gs_con_settings-no_open   = abap_false.
** CLOSE SPOOL AT THE LAST LOOP ONLY
*      gs_con_settings-no_close  = abap_true.
*    ELSE.
** DIALOG AT FIRST LOOP ONLY
*      gs_con_settings-no_dialog = abap_true.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*      gs_con_settings-no_open   = abap_true.
*    ENDIF.
*
*    IF sy-tabix = gv_tot_lines.
** CLOSE SPOOL
*      gs_con_settings-no_close  = abap_false.
*    ENDIF.
*
* READ TABLE lt_t003t INTO ls_t003t WITH KEY blart = wa_final-blart.
*  IF SY-SUBRC = 0.
*     lv_text = ls_t003t-ltext.
*  ENDIF.
*
*
*CALL FUNCTION FM_NAME "'/1BCDWB/SF00000197'
*  EXPORTING
**   ARCHIVE_INDEX              = ARCHIVE_INDEX
**   ARCHIVE_INDEX_TAB          = ARCHIVE_INDEX_TAB
**   ARCHIVE_PARAMETERS         = ARCHIVE_PARAMETERS
*   CONTROL_PARAMETERS         = gs_con_settings
**   MAIL_APPL_OBJ              = MAIL_APPL_OBJ
**   MAIL_RECIPIENT             = MAIL_RECIPIENT
**   MAIL_SENDER                = MAIL_SENDER
*   OUTPUT_OPTIONS             = ls_composer_param
**   USER_SETTINGS              = 'X'
*    BELNR                      = WA_FINAL-BELNR
*    GJAHR                      = WA_FINAL-GJAHR
*    WAERS                      = P_waers
**    HWAER                      = P_waers
*    WA_FINAL1                  = WA_FINAL
*   LS_TEXT                    = LV_TEXT
** IMPORTING
**   DOCUMENT_OUTPUT_INFO       = DOCUMENT_OUTPUT_INFO
**   JOB_OUTPUT_INFO            = JOB_OUTPUT_INFO
**   JOB_OUTPUT_OPTIONS         = JOB_OUTPUT_OPTIONS
*  TABLES
*    IT_FINAL                   = IT_FINAL
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
*          .
*IF SY-SUBRC <> 0.
** I0mplement suitable error handling here
*ENDIF.
*
*
  ENDLOOP.

ENDFORM.
