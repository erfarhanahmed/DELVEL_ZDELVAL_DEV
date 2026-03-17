FORM get_head_mat_info
          USING v_matnr TYPE matnr
                v_werks TYPE werks_d
          CHANGING v_hdmat TYPE t_hdmat.

  SELECT SINGLE matnr werks
    FROM marc  INTO v_hdmat
    WHERE matnr = v_matnr
      AND werks = v_werks.

  IF sy-subrc = 0.

    SELECT SINGLE zeinr maktx zeivr MTART
      INTO (v_hdmat-zeinr, v_hdmat-maktx, v_hdmat-zeivr,v_hdmat-MTART)
      FROM mara
      JOIN makt ON makt~matnr = mara~matnr
      WHERE mara~matnr = v_hdmat-matnr
        AND spras = sy-langu.
  ELSE.
    MESSAGE 'Invalid input data.' TYPE 'E'.
    EXIT.
  ENDIF.
ENDFORM.
FORM get_components TABLES vt_stpox TYPE tb_stpox
                           vt_mat   TYPE tb_cscmat
                      USING v_matnr TYPE matnr
                          v_werks TYPE werks_d
                          v_validity_dt TYPE sy-datum
                          ps_cstmat TYPE cstmat
                          p_stlan   TYPE stzu-stlan
                          v_ind type c.

  DATA : str            TYPE string,
         lv_validity_dt TYPE sy-datum,
         lv_mdmps type c.

  IF v_validity_dt IS INITIAL.
    lv_validity_dt = sy-datum.
  ELSE.
    lv_validity_dt = v_validity_dt.
  ENDIF.

IF v_ind = 'S'.
 lv_mdmps = '1'.

  ENDIF.
  CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
    EXPORTING
      capid                 = 'PP01'
      datuv                 = lv_validity_dt
      mehrs                 = 'X'
      mtnrv                 = v_matnr
*     stlal                 = '01'
      werks                 = v_werks
      stlan                 = p_stlan
      mdmps                 = lv_mdmps
    IMPORTING
      topmat                = ps_cstmat
    TABLES
      stb                   = vt_stpox
      matcat                = vt_mat
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
  IF sy-subrc <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    CONCATENATE 'BOM could not be extracted for material'
      v_matnr INTO str SEPARATED BY space.
    MESSAGE str TYPE 'I'.
    LEAVE TO TRANSACTION sy-tcode.
  ENDIF.
  CLEAR str.
ENDFORM.
