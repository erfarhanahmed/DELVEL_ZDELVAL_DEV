*&---------------------------------------------------------------------*
*& Report ZVOUCHERS.
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvouchers.

TABLES: bseg.
DATA: f_name TYPE rs38l_fnam. "function module name

DATA:
  lv_belnr          TYPE bkpf-belnr.
SELECTION-SCREEN BEGIN OF BLOCK blk WITH FRAME TITLE TEXT-t01.

PARAMETERS         : p_belnr TYPE bseg-belnr  OBLIGATORY.
PARAMETERS         : p_bukrs TYPE bseg-bukrs DEFAULT '1000' OBLIGATORY.
PARAMETERS         : p_gjahr TYPE bseg-gjahr OBLIGATORY.
SELECTION-SCREEN END OF BLOCK blk.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc,
            r3 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SELECT SINGLE belnr
           FROM bkpf
           INTO lv_belnr
           WHERE belnr = p_belnr
           AND   bukrs = p_bukrs
           AND   gjahr = p_gjahr
           AND   blart = 'DD'.

    IF NOT sy-subrc IS INITIAL.
      MESSAGE 'Please Check Input Values' TYPE 'E'.
    ENDIF.
  ELSEIF r2 = 'X'.
    SELECT SINGLE belnr
           FROM bkpf
           INTO lv_belnr
           WHERE belnr = p_belnr
           AND   bukrs = p_bukrs
           AND   gjahr = p_gjahr
           AND   blart = 'DP'.
    IF NOT sy-subrc IS INITIAL.
      MESSAGE 'Please Check Input Values' TYPE 'E'.
    ENDIF.
  ELSEIF r3 = 'X'.
    SELECT SINGLE belnr
           FROM bkpf
           INTO lv_belnr
           WHERE belnr = p_belnr
           AND   bukrs = p_bukrs
           AND   gjahr = p_gjahr
           AND   blart = 'KU'.
    IF NOT sy-subrc IS INITIAL.
      MESSAGE 'Please Check Input Values' TYPE 'E'.
    ENDIF.

  ENDIF.

START-OF-SELECTION.
  DATA:

    ls_composer_param TYPE ssfcompop.

  ls_composer_param-tdcopies = 2.
  IF r1 = 'X'.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZRECEIPT_VOUCHER'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = f_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION f_name
      EXPORTING
        output_options   = ls_composer_param
        user_settings    = space
        p_belnr          = p_belnr
        p_bukrs          = p_bukrs
        p_gjahr          = p_gjahr
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.




  ELSEIF r2 = 'X'.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZREFUND_VOUCHER'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = f_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    CALL FUNCTION f_name
      EXPORTING
        output_options   = ls_composer_param
        user_settings    = space
        p_belnr          = p_belnr
        p_bukrs          = p_bukrs
        p_gjahr          = p_gjahr
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ELSEIF r3 = 'X'.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZPAYMENT_VOUCHER'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = f_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    CALL FUNCTION f_name
      EXPORTING
        output_options   = ls_composer_param
        user_settings    = space
        p_belnr          = p_belnr
        p_bukrs          = p_bukrs
        p_gjahr          = p_gjahr
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
