

*DATA: lt TYPE TABLE OF ty,
*     ls TYPE ty.
DATA:
    lv_id        TYPE thead-tdname.
*    lt_lines     TYPE STANDARD TABLE OF tline,
*    ls_lines     TYPE tline.

 lv_id = wa_final-matnr.

*CLEAR: lt_lines,ls_lines.
*BREAK-POINT.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = 'S'
        name                    = lv_id
        object                  = 'MATERIAL'
      TABLES
        lines                   = lt_lines
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

    IF NOT lt_lines IS INITIAL.
      LOOP AT lt_lines INTO ls_lines.
        IF NOT ls_lines-tdline IS INITIAL.

*                 CONCATENATE gv_all ls_lines-tdline INTO gv_all SEPARATED BY space.

        ENDIF.
      ENDLOOP.
*       gv_text = gv_all+0(255).
*       gv_text = gv_all+0(999).
*       gv_txt = gv_all+1000(9999).
*       gv_txt1 = gv_all+401(550).
*       gv_txt2 = gv_all+551(700).
*       gv_txt3 = gv_all+701(850).
*       gv_txt4 = gv_all+851(1000).

*      CONDENSE gv_text.
    ENDIF.













