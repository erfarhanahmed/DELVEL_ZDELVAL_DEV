*DATA lv_cons_adrnr TYPE adrc-addrnumber.
DATA ls_hd_adr TYPE lbbil_hd_adr.
DATA ls_adr TYPE ty_adr.
CLEAR LV_CONS_ADRNR .
* get consignee adress number
READ TABLE is_bil_invoice-hd_adr INTO ls_hd_adr
           WITH KEY bil_number = is_bil_invoice-hd_gen-bil_number
                    partn_role = 'RE'.
*                    partn_role = 'WE'.
lv_cons_adrnr = ls_hd_adr-addr_no.
*break primus.
*BREAK-POINT. .
IF lv_cons_adrnr ne l_adrnr .
  v_flag = 'X'.
SELECT SINGLE * FROM adrc INTO gs_ku_adrc
  WHERE addrnumber = lv_cons_adrnr.

SELECT SINGLE * FROM t005u INTO gs_ku_t005u
  WHERE spras = sy-langu
    AND land1 = gs_ku_adrc-country
    AND bland = gs_ku_adrc-region.

SELECT SINGLE landx FROM t005t INTO gv_ku_landx
  WHERE spras = sy-langu
    AND land1 = gs_ku_adrc-country.

CLEAR ls_adr-line.
ls_adr-line = gs_ku_adrc-name1 .
APPEND ls_adr TO gt_adr.

ls_adr-line = gs_ku_adrc-name2. "Added By Nilay B. on 18.01.2024
APPEND ls_adr TO gt_adr.

IF gs_ku_adrc-str_suppl1 IS NOT INITIAL.
  CLEAR ls_adr-line.
  ls_adr-line = gs_ku_adrc-str_suppl1.
  APPEND ls_adr TO gt_adr.
ENDIF.

IF gs_ku_adrc-str_suppl2 IS NOT INITIAL.
  CLEAR ls_adr-line.
  ls_adr-line = gs_ku_adrc-str_suppl2.
  APPEND ls_adr TO gt_adr.
ENDIF.

IF gs_ku_adrc-street IS NOT INITIAL.
  CLEAR ls_adr-line.
  ls_adr-line = gs_ku_adrc-street.
  APPEND ls_adr TO gt_adr.
ENDIF.

IF gs_ku_adrc-str_suppl3 IS NOT INITIAL.
  CLEAR ls_adr-line.
  ls_adr-line = gs_ku_adrc-str_suppl3.
  APPEND ls_adr TO gt_adr.
ENDIF.
IF gs_ku_adrc-location IS NOT INITIAL.
  CLEAR ls_adr-line.
  ls_adr-line = gs_ku_adrc-location.
  APPEND ls_adr TO gt_adr.
ENDIF.
IF gs_ku_adrc-city2 IS NOT INITIAL.
  CLEAR ls_adr-line.
  CONCATENATE 'District' gs_ku_adrc-city2
    INTO ls_adr-line SEPARATED BY space.
  APPEND ls_adr TO gt_adr.
ENDIF.


CLEAR ls_adr-line.
*&GS_KU_ADRC-CITY1& &'- 'GS_KU_ADRC-POST_CODE1& &GS_KU_T005U-BEZEI&  &GV_KU_LANDX&
*	&'Tel :'GS_KU_ADRC-TEL_NUMBER& &'Fax :'GS_KU_ADRC-FAX_NUMBER&

CONCATENATE gs_ku_adrc-city1 gs_ku_adrc-post_code1
  gs_ku_t005u-bezei gv_ku_landx
  INTO ls_adr-line SEPARATED BY space.
APPEND ls_adr TO gt_adr.

CLEAR ls_adr-line.
CONCATENATE 'Tel :' gs_ku_adrc-tel_number
            'Fax :' gs_ku_adrc-fax_number
  INTO ls_adr-line SEPARATED BY space.
APPEND ls_adr TO gt_adr.

ENDIF.

IF  LS_HD_ADR-PARTN_NUMB EQ '0000300000'.
  IF GS_LIKP-KUNNR NE GS_LIKP-KUNAG.
  IF  GS_LIKP-ERDAT GE '20240812'.
    gs_ku_adrc-street = '6535, Industrial Dr, Ste 103'.
  ENDIF.
  ENDIF.
ENDIF.


