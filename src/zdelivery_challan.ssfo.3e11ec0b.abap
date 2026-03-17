**data:
**  lS_MAT_DOC  TYPE  T_MAT_DOC.
**BREAK-POINT.
data : temp_ekpo TYPE ekpo,
       temp_vbrk TYPE vbrk.

CLEAR:
  gs_mat_desc,gs_j_1ig_subcon.

READ TABLE gt_mat_doc INTO gs_mat_doc
            WITH KEY ebeln = gs_purchasing-ebeln
                     ebelp = gs_purchasing-ebelp.

READ TABLE gt_j_1ig_subcon INTO gs_j_1ig_subcon
            WITH KEY mblnr  = gs_mat_doc-mblnr
                     zeile  = gs_mat_doc-zeile.


gv_rate = gs_purchasing-netwr / gs_purchasing-menge.
SELECT SINGLE zeinr
        FROM mara
        INTO gv_zeinr_r
        WHERE matnr = gs_purchasing-matnr.

IF sy-subrc IS INITIAL.
  READ TABLE gt_mat_desc INTO gs_mat_desc
             WITH KEY matnr = gs_purchasing-matnr.

ENDIF.


CLEAR gv_menge.
DATA:
  lt_stb TYPE STANDARD TABLE OF stpox,
  ls_stb TYPE stpox.

CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
  EXPORTING
    capid                 = 'PP01'
    datuv                 = sy-datum
    mktls                 = 'X'
    mtnrv                 = gs_purchasing-matnr
    stlal                 = '01'
    stlan                 = '1'
    stpst                 = '0'
    svwvo                 = 'X'
    werks                 = gs_purchasing-werks
    vrsvo                 = 'X'
  TABLES
    stb                   = lt_stb
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
* Implement suitable error handling here
ENDIF.

data:
  lv_menge TYPE resb-erfmg.
*BREAK primus.
*LOOP AT lt_stb INTO ls_stb.
*  READ TABLE gt_j_1ig_subcon INTO gs_j_1ig_subcon
*                         WITH KEY matnr = ls_stb-idnrk.
*  IF sy-subrc IS INITIAL.
*    READ TABLE gt_j_1ig_subcon INTO temp_subcon
*    WITH KEY matnr = ls_stb-idnrk..
*      IF sy-subrc = 0.
*      SELECT SINGLE * from vbrk INTO temp_vbrk
*        WHERE vbeln = temp_subcon-chln_inv.
*        IF temp_vbrk-fkart = 'ZSN'.
*        SELECT SINGLE * from ekpo INTO temp_ekpo
*         WHERE ebeln = GS_PURCHASING-ebeln and
*          ebelp = GS_PURCHASING-ebelp.
*          IF sy-subrc = 0.
*        gv_menge = temp_ekpo-menge.
*        else.
*          gv_menge = gs_j_1ig_subcon-menge / ls_stb-menge.
*          ENDIF.
*        ENDIF.
*      ENDIF.
**    gv_menge = gs_j_1ig_subcon-menge / ls_stb-menge.
*
***  ELSE.
****    BREAK-POINT.
***    SELECT SINGLE erfmg
***            FROM  resb
***            INTO  lv_menge
***            WHERE ebeln = gs_purchasing-ebeln
***            AND   ebelp = gs_purchasing-ebelp.
***
*  ENDIF.
*ENDLOOP.
*  IF gv_menge is INITIAL.
*   gv_menge = gs_purchasing-menge.
*
*  ENDIF.

data : resb type resb,
*       ekpo TYPE table of ekpo,
       mseg TYPE mseg,
       calc_1 type String .
SELECT single * from resb into resb
  where ebeln = gs_purchasing-ebeln.
  IF resb is not initial.
   calc_1 = resb-bdmng / gs_purchasing-menge.
  select single * from mseg into mseg
    where ebeln = gs_purchasing-ebeln
    and ebelp = gs_purchasing-ebelp
    and BWART = '541' "25.04.2019
    AND xauto = 'X'.
    if sy-subrc = 0.
    gv_menge = mseg-menge / calc_1.
    endif.
  ENDIF.

gv_menge1 = gv_menge1 + gv_menge. "25.04.2019
