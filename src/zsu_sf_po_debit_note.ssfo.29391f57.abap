*******************For Long Discription******************************
*BREAK-POINT.
CLEAR lv_longtxt.

 DATA:
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline,
    LV_material_doc-wrbtr TYPE dmbtr.

   lv_id = LS_MSEG01-matnr.
    CLEAR: lt_lines,ls_lines.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
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
          REPLACE ALL OCCURRENCES OF '<&>' IN ls_lines-tdline WITH '&'.
          CONCATENATE lv_longtxt ls_lines-tdline INTO lv_longtxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE lv_longtxt.
    ENDIF.
***********************************************************

IF P_WAERS = 'SAR'.
  LV_material_doc-wrbtr = LS_MSEG01-dmbtr.
ELSEIF P_WAERS <> 'SAR'.
  LV_material_doc-wrbtr = LS_MSEG01-BUALT.
ENDIF.

gv_qty = LS_MSEG01-menge.
gv_rate = LV_material_doc-wrbtr / LS_MSEG01-menge.
gv_amt  = LV_material_doc-wrbtr.

IF gs_material_doc-kschl IS INITIAL.
  gv_tot_amt = gv_tot_amt + LV_material_doc-wrbtr.
  gv_tot_qty = gv_tot_qty + LS_MSEG01-menge.
ENDIF.

SELECT SINGLE STEUC FROM MARC INTO LV_STEUC
                    WHERE MATNR = LS_MSEG01-matnr.

GV_SR = GV_SR + 1.
