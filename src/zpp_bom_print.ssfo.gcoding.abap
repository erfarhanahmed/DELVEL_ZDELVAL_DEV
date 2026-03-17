
*BREAK-POINT.


CLEAR wa_hdmat.

REFRESH it_stpox.
DATA:
  lt_stpo  TYPE tb_stpox,
  ls_stpo  TYPE stpox,
  ls_stpo1 TYPE stpox,
  ls_mat   TYPE cscmat.
PERFORM get_head_mat_info USING p_matnr p_werks
                          CHANGING wa_hdmat.

*break primus.
p_ind = gv_indicator.

PERFORM get_components TABLES it_stpox
                              gt_mat
                       USING p_matnr p_werks
                             p_validity_dt
                             gs_cstmat
                             p_stlan
                             p_ind.

IF NOT gt_mat IS INITIAL.
  LOOP AT gt_mat INTO ls_mat.
    CLEAR: lt_stpo,ls_stpo.
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'PP01'
        datuv                 = sy-datum
        mehrs                 = 'X'
        mtnrv                 = ls_mat-matnr
*       stlal                 = '01'
        werks                 = p_werks
        stlan                 = p_stlan
      TABLES
        stb                   = lt_stpo
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.

    IF NOT lt_stpo IS INITIAL.
      LOOP AT lt_stpo INTO ls_stpo.
        READ TABLE it_stpox INTO ls_stpo1
                            WITH KEY idnrk = ls_mat-matnr.
        IF sy-subrc IS INITIAL.
          gs_stpo-matnr = ls_mat-matnr.
          gs_stpo-idnrk = ls_stpo-idnrk.
          gs_stpo-rekrs = ls_stpo-rekrs.

          APPEND gs_stpo TO gt_stpo.
          CLEAR gs_stpo.
        ENDIF.

      ENDLOOP.

    ENDIF.
  ENDLOOP.
ENDIF.
*BREAK PRIMUS.
mat_dec = wa_hdmat-maktx.
