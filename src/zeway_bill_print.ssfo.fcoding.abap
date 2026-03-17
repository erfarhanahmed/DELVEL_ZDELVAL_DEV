*&---------------------------------------------------------------------*
*&      Form  SINGLE_READ
*&---------------------------------------------------------------------*
FORM SINGLE_READ USING wa_vbrp_vbeln
                       lv_value
              CHANGING result.

DATA: lv_id     TYPE thead-tdid,
      lv_name   TYPE thead-tdname,
      lv_object TYPE thead-tdobject.

DATA: lt_line TYPE TABLE OF tline,
      ls_line LIKE LINE OF lt_line.

  DATA: lv_text TYPE string,
        lv_lnth TYPE i,
        lv_v1   TYPE i.

CLEAR result.

lv_id     = lv_value.
lv_name   = wa_vbrp_vbeln.
lv_object = 'VBBK'.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
    client                 = sy-mandt
    id                     = lv_id
    language               = sy-langu
    NAME                   = lv_name
    OBJECT                 = lv_object
  TABLES
    lines                  = lt_line
 EXCEPTIONS
   id                      = 1
   language                = 2
   name                    = 3
   not_found               = 4
   object                  = 5
   reference_check         = 6
   wrong_access_to_archive = 7
   OTHERS                  = 8.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

LOOP AT lt_line INTO ls_line.

  IF ls_line-tdline IS NOT INITIAL.

    result = ls_line-tdline.
    CLEAR ls_line.
    EXIT.

  ENDIF."IF ls_line-tdline IS NOT INITIAL.

ENDLOOP."LOOP AT lt_line INTO ls_line.

ENDFORM.
