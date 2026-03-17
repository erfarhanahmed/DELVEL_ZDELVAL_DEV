
TYPES : BEGIN OF t_mat_lips,
          matnr TYPE matnr,
          lfimg TYPE lfimg,
          brgew TYPE brgew_15,
          ntgew TYPE ntgew_15,
        END OF t_mat_lips.

DATA : gs_it_gen1  TYPE le_t_dlv_it_gen.
DATA : wa_it_gen1  LIKE ledlv_it_gen,
       wa_mat_lips TYPE t_mat_lips.

*BREAK primus.
gs_it_gen1 = is_dlv_delnote-it_gen.

CLEAR : gv_anzpk, wa_lips , wa_mara, wa_mat_lips.
READ TABLE gs_it_gen1
INTO wa_it_gen1
WITH KEY item_categ = 'HUPM'
itm_number  = v_posnr.

IF sy-subrc = 0.
  gv_anzpk = wa_it_gen1-dlv_qty.
***************************************
  SELECT SINGLE vbeln posnr pstyv matnr matkl
          arktx
    FROM lips
    INTO CORRESPONDING FIELDS OF wa_lips
    WHERE vbeln = wa_vepo-vbeln
    AND   pstyv = 'HUPM'
    AND   posnr = v_posnr.

  IF sy-subrc = 0.
    SELECT SINGLE anzpk
    FROM likp
    INTO lv_anzpk
    WHERE vbeln = wa_lips-vbeln.

    SELECT SINGLE matnr groes
    FROM mara
    INTO CORRESPONDING FIELDS OF wa_mara
    WHERE matnr = wa_lips-matnr.
  ENDIF.
ENDIF.
v_posnr = v_posnr + 1.

CLEAR w_vekp.
SELECT SINGLE exidv vhilm vhilm_ku "BRGEW
  ntgew
FROM vekp
INTO w_vekp
WHERE venum = wa_vepo-venum.

IF w_vekp-vhilm_ku <> v_bx_dscr.
  v_bx_dscr = w_vekp-vhilm_ku.
ELSE.
  CLEAR w_vekp-vhilm_ku.
ENDIF.

SELECT SINGLE matnr lfimg brgew ntgew
FROM lips
INTO wa_mat_lips
WHERE vbeln = wa_vepo-vbeln
AND   posnr = wa_vepo-posnr.
IF sy-subrc = 0.
  v_matnr1 = wa_mat_lips-matnr.
ENDIF.

SELECT SINGLE * FROM MARA INTO GV_MARA
  WHERE MATNR = wa_mat_lips-matnr.



*****************************************************
IF sy-subrc = 0.
  SELECT SINGLE zsize
  FROM mara
  INTO gv_zsize
  WHERE matnr = v_matnr1.
****************************************************
  SELECT SINGLE matnr maktx
  FROM makt
  INTO CORRESPONDING FIELDS OF wa_makt1
  WHERE matnr = v_matnr1.
ENDIF.

SELECT SINGLE vbelv posnv
FROM vbfa
INTO (v_so1,v_posnv)
WHERE vbeln = wa_vepo-vbeln
AND   posnn = wa_vepo-posnr.

IF sy-subrc = 0.
  SELECT SINGLE kdmat
  FROM vbap
  INTO v_kdmat
  WHERE vbeln = v_so1
  AND posnr = v_posnv. "WA_VEPO-POSNR.

  SELECT SINGLE bstnk
  INTO v_bstnk
  FROM vbak
  WHERE vbeln = v_so1.

  "CONCATENATE v_so1 v_posnv INTO gv_sopotx.
  gv_sopotx = v_so1 .
ENDIF.
"BREAK DVBASIS.
SELECT SINGLE * FROM vbrp INTO wa_vbrp
   WHERE VGBEL = wa_vepo-vbeln
     AND VGPOS = wa_vepo-posnr.

CLEAR:gv_soline,gv_material.
CONCATENATE wa_vbrp-VBELV wa_vbrp-POSNV INTO gv_soline.
data lv_name1 type string.
*CLEAR: lv_lines,wa_lines, v_kdmat.
CLEAR: lv_lines,wa_lines.
      REFRESH lv_lines.
      lv_name = gv_soline.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0010'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
        TABLES
          lines                   = lv_lines
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
       DATA : LV_GV_SOPOTX  TYPE STRING.
       clear : LV_GV_SOPOTX.

      IF lv_lines IS NOT INITIAL.
        LOOP AT Lv_LINES INTO wa_lines.
           IF NOT wa_lines-TDLINE IS INITIAL.

              CONCATENATE LV_GV_SOPOTX wa_lines-TDLINE
                  INTO LV_GV_SOPOTX SEPARATED BY SPACE.

       ENDIF.
    ENDLOOP.
  ENDIF.


   IF lv_lines IS INITIAL.
    CLEAR LV_NAME1.
  ENDIF.

    lv_name1 =  LV_GV_SOPOTX  .


*  data : lv_final type string.
  clear : lv_final.

  CONCATENATE GV_MARA-WRKST lv_name1 into lv_final.
  "CONCATENATE GV_MARA-WRKST lv_final into lv_final.cmt by sakshi


if lv_final is not INITIAL.
   clear : v_kdmat.
  endif.

****      IF NOT lv_lines IS INITIAL.
*****       READ TABLE lv_lines INTO wa_lines INDEX 1.
****
****      LOOP AT lv_lines INTO wa_lines .
****IF IS_DLV_DELNOTE-HD_GEN-SOLD_TO_PARTY = '0000300000'.
****IF wa_lines-tdline IS NOT INITIAL. .
*****v_kdmat = wa_lines-tdline.
****CONCATENATE v_kdmat wa_lines-tdline INTO v_kdmat SEPARATED BY space.
****ELSE.
**** v_kdmat = GV_MARA-WRKST.
****ENDIF.
****ENDIF.
****ENDLOOP.
****ENDIF.
" Unit weight and Net Weight should be
" determined from the LIPS quantities
*v_wt = wa_mat_lips-brgew / wa_mat_lips-lfimg.
v_wt = wa_mat_lips-ntgew / wa_mat_lips-lfimg.
w_vekp-ntgew = v_wt * wa_vepo-vemng.
