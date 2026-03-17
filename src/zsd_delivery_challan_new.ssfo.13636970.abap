
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
BREAK Primus.
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

data: lv_menge TYPE resb-erfmg.

data : resb type resb,
*       ekpo TYPE table of ekpo,
       mseg TYPE mseg,
       calc_1 type String .

select single menge from ekpo into gv_menge1 where ebeln = gs_purchasing-ebeln.
