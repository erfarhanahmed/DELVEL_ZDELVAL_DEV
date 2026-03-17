*&---------------------------------------------------------------------*
*& Report ZPENDING_SO_OFM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpending_so_ofm.

TABLES : vbak, vbap.


DATA: lt_vbak TYPE STANDARD TABLE OF vbak,
      ls_vbak TYPE vbak,
      lt_ofm  TYPE STANDARD TABLE OF zofm_booking WITH HEADER LINE,
      ls_ofm  TYPE  zofm_booking,
      lt_vbap TYPE STANDARD TABLE OF vbap,
      ls_vbap TYPE vbap.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.  "Selection Scrren for TMG
SELECT-OPTIONS: s_date    FOR vbak-audat.
PARAMETERS: s_werks   LIKE vbap-werks DEFAULT 'PL01'.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.


*  BREAK primus.

  SELECT * FROM vbak
    INTO TABLE lt_vbak
    WHERE audat IN s_date AND vkorg = '1000'.

  IF lt_vbak IS NOT INITIAL.
    SELECT * FROM zofm_booking
  INTO TABLE lt_ofm
  FOR ALL ENTRIES IN lt_vbak
WHERE zsoref = lt_vbak-vbeln.

    SELECT * FROM vbap INTO TABLE lt_vbap FOR ALL ENTRIES IN lt_vbak WHERE vbeln = lt_vbak-vbeln AND werks = s_werks.

  ENDIF.

*
*SELECT * FROM vbak
*  INTO TABLE @DATA(lt_vbak).
*
*SELECT *
*   FROM zofm_booking
*  INTO TABLE @DATA(lt_ofm)
*
*  FOR ALL ENTRIES IN @lt_vbak
*WHERE zsoref = @lt_vbak-vbeln.

  LOOP AT lt_vbak INTO ls_vbak.

    READ TABLE lt_ofm INTO ls_ofm WITH KEY zsoref = ls_vbak-vbeln.

    IF sy-subrc = 0.
      DELETE lt_vbak WHERE vbeln = ls_ofm-zsoref.
    ENDIF.

*    DELETE lt_vbap WHERE werks EQ s_werks .

  ENDLOOP.

  PERFORM get_fcat.
  PERFORM get_display.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .

  PERFORM fcat USING :      '1'   'VBELN'           'LT_VBAK'           'Sales Order'                           '18' .


ENDFORM.


FORM fcat  USING   VALUE(p1)
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
      i_callback_program = sy-repid
*     I_GRID_SETTINGS    =
*     is_layout          = ls_layout
      it_fieldcat        = it_fcat
      i_save             = 'X'
    TABLES
      t_outtab           = lt_vbak
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.




ENDFORM.
