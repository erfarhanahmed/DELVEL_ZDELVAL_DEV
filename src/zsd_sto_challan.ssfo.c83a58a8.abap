
DATA: lt_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  TYPE tline.
*CONSTANTS: c_id TYPE thead-tdid VALUE  'Z888',
*                      c_object TYPE thead-tdobject VALUE 'VBBP'.
DATA: lv_name TYPE tdobname.
DATA: ld_text(1000) TYPE c.
*DATA: gv_text(1300) TYPE c.

CONCATENATE wa_final-vbeln wa_final-posnr into lv_name.
*CONCATENATE
CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id        = 'Z888'
      language  = 'E'
      name      = lv_name
      object    = 'VBBP'
*  IMPORTING
*    header    = ld_header
    TABLES
      lines     = lt_lines
    EXCEPTIONS
      id        = 1
      language  = 2
      name      = 3
      not_found = 4
      object    = 5.
    IF sy-subrc <> 0.
    ELSE.
      LOOP AT lt_lines INTO wa_lines.
        CONCATENATE ld_text wa_lines-tdline INTO ld_text.
      ENDLOOP.
    ENDIF.
gv_text = ld_text.





















