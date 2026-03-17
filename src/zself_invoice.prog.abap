*&---------------------------------------------------------------------*
*& Report ZSELF_INVOICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zself_invoice.


SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc USER-COMMAND clk  DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE abc.
PARAMETERS: p_belnr TYPE bkpf-belnr MODIF ID a,
            p_gjahr TYPE bkpf-gjahr MODIF ID a.
SELECTION-SCREEN:END OF BLOCK b2.

*SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE def.
*PARAMETERS:p_rbelnr TYPE rseg-belnr MODIF ID b,
*           p_year   TYPE rbkp-gjahr MODIF ID b.
*SELECTION-SCREEN: END OF BLOCK b3.

***AT SELECTION-SCREEN OUTPUT.
***
***  LOOP AT SCREEN.
***    IF r1 = 'X'.
***      IF screen-group1 = 'B'.
***        screen-active = 0.
***      ENDIF.
***    ENDIF.
****
***
***    IF r2 = 'X'.
***
***      IF screen-group1 = 'A'.
***        screen-active = 0.
***      ENDIF.
***    ENDIF.
***    MODIFY SCREEN.
***
***
***  ENDLOOP.
***
AT SELECTION-SCREEN.
  DATA:
  lv_belnr TYPE bkpf-belnr.
  IF r1 = 'X'.
    IF NOT p_belnr IS INITIAL.
      SELECT SINGLE belnr
               FROM bkpf
               INTO lv_belnr
               WHERE belnr = p_belnr
               AND   gjahr = p_gjahr
               AND   blart IN ('RE','RL','RX')
      AND   xblnr_alt NE space.
      IF lv_belnr IS INITIAL.
        MESSAGE 'Please Check Input' TYPE 'E'.
      ENDIF.
    ENDIF.
  ELSEIF r2 = 'X'.
    SELECT SINGLE belnr
            FROM  bkpf
            INTO  lv_belnr
            WHERE  belnr = p_belnr
             AND   gjahr = p_gjahr
             AND   tcode in ('MIRO','MIR7').
  ENDIF.

INITIALIZATION.
  xyz = 'Select Self Invoice Type'(tt1).
*  abc = 'Self Invoice W/O PO'(tt2).
*  def = 'Self Invoice With PO'(tt3).

START-OF-SELECTION.
  DATA:
    f_name            TYPE rs38l_fnam,
    ls_composer_param TYPE ssfcompop.

  ls_composer_param-tdcopies = 5.
  IF r1 = 'X'.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSELF_INVOICE'
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
        belnr            = p_belnr
        gjahr            = p_gjahr
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
    data:
      lv_awkey TYPE bkpf-awkey,
      p_rbelnr TYPE rseg-belnr,
      p_year TYPE rseg-gjahr.

    SELECT SINGLE awkey
            FROM  bkpf
            INTO lv_awkey
            WHERE belnr = p_belnr
            AND   gjahr = p_gjahr.

     p_rbelnr = lv_awkey.
     p_year = lv_awkey+10(4).

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSELF_INVOICE_PO'
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
        belnr            = p_rbelnr
        gjahr            = p_year
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
