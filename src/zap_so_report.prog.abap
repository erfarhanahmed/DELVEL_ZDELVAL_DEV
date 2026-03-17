*&---------------------------------------------------------------------*
*& Report ZAP_SO_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zap_so_report.
TYPE-POOLS slis.
TABLES : stpo, vbap,vbak,vbep.
TYPES : BEGIN OF ty_stpo,
          idnrk TYPE stpo-idnrk,
          stlty TYPE stpo-stlty,
          stlnr TYPE stpo-stlnr,
          stlkn TYPE stpo-stlkn,
        END OF ty_stpo,
        BEGIN OF ty_mast,
          matnr TYPE mast-matnr,
          werks TYPE mast-werks,
          stlan TYPE mast-stlan,
          stlnr TYPE mast-stlnr,
        END OF ty_mast,
        BEGIN OF ty_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
          werks TYPE vbap-werks,
        END OF ty_vbap,
        BEGIN OF ty_vbup,
          vbeln TYPE vbup-vbeln,
          posnr TYPE vbup-posnr,
          lfgsa TYPE vbup-lfgsa,
        END OF ty_vbup,
        BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          vkorg TYPE vbak-vkorg,
          vtweg TYPE vbak-vtweg,
          spart TYPE vbak-spart,
          auart TYPE vbak-auart,
        END OF ty_vbak,
        BEGIN OF ty_vbep,
          vbeln TYPE vbep-vbeln,
          posnr TYPE vbep-posnr,
          etenr TYPE vbep-etenr,
          edatu TYPE vbep-edatu,
          wepos TYPE vbep-wepos,
        END OF ty_vbep.
DATA : it_stpo TYPE TABLE OF ty_stpo,
       gt_stpo TYPE TABLE OF ty_stpo,
       gs_stpo TYPE ty_stpo,
       it_mast TYPE TABLE OF ty_mast,
       gt_mast TYPE TABLE OF ty_mast,
       gs_mast TYPE           ty_mast,
       it_vbak TYPE TABLE OF ty_vbak,
       it_vbap TYPE TABLE OF ty_vbap,
       it_vbup TYPE TABLE OF ty_vbup,
       it_vbep TYPE TABLE OF ty_vbep,
       wa_stpo TYPE ty_stpo,
       wa_mast TYPE ty_mast,
       wa_vbak TYPE ty_vbak,
       wa_vbap TYPE ty_vbap,
       wa_vbup TYPE ty_vbup,
       wa_vbep TYPE ty_vbep.

TYPES : BEGIN OF ty_final,
          vbeln TYPE vbak-vbeln,
          vkorg TYPE vbak-vkorg,
          vtweg TYPE vbak-vtweg,
          spart TYPE vbak-spart,
          posnr TYPE vbap-posnr,
          etenr TYPE vbep-etenr,
          edatu TYPE string, "vbep-edatu,
          matnr TYPE matnr,
        END OF ty_final.
DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.

DATA : it_fldcat TYPE slis_t_fieldcat_alv,
       wa_fldcat TYPE slis_fieldcat_alv,
       wa_layout TYPE slis_layout_alv.
*--------Extra tables-------------------------------
*data : temp_stpo TYPE TABLE OF ty_stpo,
*         temp_stpo_wa type ty_stpo,
*         temp_mast TYPE TABLE OF ty_mast,
*         temp_mast_wa type ty_mast,
*         it_final_mast TYPE TABLE OF ty_mast,
*         wa_final_mast TYPE ty_mast,
*         final_stpo TYPE TABLE OF ty_stpo,
*         final_stpo_wa type ty_stpo.
*--------------------------------------------------------------------*
*--------------Function module declaration-------------------------
DATA : stb    TYPE TABLE OF stpox WITH HEADER LINE,
       matcat TYPE TABLE OF cscmat WITH HEADER LINE,
       topmat TYPE TABLE OF cstmat WITH HEADER LINE.
*       dstst TYPE TABLE OF
*--------------------------------------------------------------------*
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS : idnrk FOR stpo-idnrk OBLIGATORY.
SELECTION-SCREEN : END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM : get_data,
            build_data,
            build_fldcat,
            display_data.

FORM get_data.
  CLEAR : it_vbak, it_vbap, it_mast, it_vbup, it_vbep.

  SELECT idnrk
         stlty
         stlnr
         stlkn FROM stpo INTO TABLE it_stpo WHERE idnrk IN idnrk.
  IF it_stpo IS INITIAL.
    MESSAGE 'No data found for selection parameters' TYPE 'E'.
  ENDIF.

*    SELECT matnr
*           werks
*           stlan
*           stlnr FROM mast INTO TABLE it_mast
*      FOR ALL ENTRIES IN it_stpo WHERE stlnr = it_stpo-stlnr.

*BREAK primus.
  SELECT vbeln
         posnr
         lfgsa FROM vbup INTO TABLE it_vbup
*           FOR ALL ENTRIES IN it_vbap
         WHERE lfgsa <> 'C'.

  SELECT vbeln
         posnr
         matnr
         werks FROM vbap INTO TABLE it_vbap
    FOR ALL ENTRIES IN it_vbup WHERE vbeln = it_vbup-vbeln AND posnr = it_vbup-posnr.
  SELECT vbeln
         vkorg
         vtweg
         spart
         auart FROM vbak INTO TABLE it_vbak
    FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln
     AND ( auart = 'ZASH'
     OR auart = 'ZDEX'
     OR auart = 'ZED'
     OR auart = 'ZEXP'
     OR auart = 'ZFEX'
     OR auart = 'ZFOC'
     OR auart = 'ZFRE'
     OR auart = 'ZOR'
     OR auart = 'ZSEZ' ).
  IF it_vbap IS NOT INITIAL.

    SELECT vbeln
           posnr
           etenr
           edatu
           wepos FROM vbep INTO TABLE it_vbep FOR ALL ENTRIES IN it_vbup
           WHERE vbeln = it_vbup-vbeln AND posnr = it_vbup-posnr.
  ENDIF.
*endif.
ENDFORM.
FORM build_data.
*  BREAK primus.
  LOOP AT it_vbup INTO wa_vbup .
    REFRESH stb[].
    wa_final-vbeln = wa_vbup-vbeln.
    wa_final-posnr = wa_vbup-posnr.
    READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_final-vbeln  posnr = wa_final-posnr.
    IF sy-subrc = 0.
      wa_final-matnr = wa_vbap-matnr.
    ENDIF.
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'PP01'
        datuv                 = sy-datum
        emeng                 = '1'
        mktls                 = 'X'
        mehrs                 = 'X'
        mmory                 = '1'
        mtnrv                 = wa_final-matnr
        stlan                 = '1'
        stpst                 = 0
        svwvo                 = 'X'
        werks                 = wa_vbap-werks
        vrsvo                 = 'X'
      IMPORTING
        topmat                = topmat
      TABLES
        stb                   = stb
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

      LOOP AT it_stpo INTO wa_stpo.
        DELETE stb[] WHERE idnrk <> wa_stpo-idnrk.
        CLEAR wa_stpo.
      ENDLOOP.
    IF stb[] IS NOT INITIAL.
      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_final-vbeln.
      IF sy-subrc = 0.
        wa_final-vkorg = wa_vbak-vkorg.
        wa_final-vtweg = wa_vbak-vtweg.
        wa_final-spart = wa_vbak-spart.
      ENDIF.
      READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_final-vbeln  posnr = wa_final-posnr.
      IF sy-subrc = 0.
*        if wa_vbep-edatu > sy-datum.
*          CONTINUE.
*          else.
        wa_final-etenr = wa_vbep-etenr.
        wa_final-edatu = wa_vbep-edatu.
*        CONCATENATE wa_vbep-edatu+6(2) '.' wa_vbep-edatu+4(2) '.' wa_vbep-edatu(4) INTO wa_final-edatu.
*      ENDIF.
*     endif.
    ENDIF.
      APPEND wa_final TO it_final.
      CLEAR   wa_final.
  ENDIF.
  ENDLOOP.
  BREAK primus.
  DELETE it_final WHERE edatu >= sy-datum.
  LOOP AT it_final INTO wa_final.
    if wa_final-edatu IS NOT INITIAL.
  CONCATENATE wa_final-edatu+6(2) '.' wa_final-edatu+4(2) '.' wa_final-edatu(4) INTO wa_final-edatu.
  ENDIF.
  MODIFY it_final FROM wa_final TRANSPORTING edatu.
  clear wa_final.
  ENDLOOP.

  DELETE it_final WHERE vkorg = '' AND vtweg = '' AND spart = ''.
ENDFORM.
FORM build_fldcat.
  PERFORM fldcat USING '1' 'X' 'Sales Order'      'IT_FINAL' 'VBELN'.
  PERFORM fldcat USING '2' '' 'Sales Org'         'IT_FINAL' 'VKORG'.
  PERFORM fldcat USING '3' '' 'Dist Channel'      'IT_FINAL' 'VTWEG'.
  PERFORM fldcat USING '4' '' 'Division'           'IT_FINAL' 'SPART'.
  PERFORM fldcat USING '5' '' 'Item No'            'IT_FINAL' 'POSNR'.
  PERFORM fldcat USING '6' '' 'Schedule Line No'   'IT_FINAL' 'ETENR'.
  PERFORM fldcat USING '7' '' 'First Date'         'IT_FINAL' 'EDATU'.
  PERFORM fldcat USING '8' '' 'Material No'         'IT_FINAL' 'MATNR'.
  wa_layout-colwidth_optimize = 'X'.
ENDFORM.
FORM display_data.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fldcat
      i_save             = 'X'
    TABLES
      t_outtab           = it_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FLDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0416   text
*      -->P_0417   text
*      -->P_0418   text
*      -->P_0419   text
*      -->P_0420   text
*----------------------------------------------------------------------*
FORM fldcat  USING    VALUE(p1)
                      VALUE(p2)
                      VALUE(p3)
                      VALUE(p4)
                      VALUE(p5).
  wa_fldcat-col_pos = p1.
  wa_fldcat-key = p2.
  wa_fldcat-seltext_m = p3.
  wa_fldcat-tabname = p4.
  wa_fldcat-fieldname = p5.
  APPEND wa_fldcat TO it_fldcat.
  CLEAR wa_fldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
