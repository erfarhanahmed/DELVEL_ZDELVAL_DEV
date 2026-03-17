DATA: l_werks   TYPE werks_d,
      lv_branch TYPE j_1bbranch-branch,
      l_adrnr   TYPE adrnr,
      l_country TYPE land1,
      l_fkimg   TYPE fkimg.

CLEAR : gv_matnr,  gv_arktx, gv_fkimg.

SELECT SINGLE werks  matnr arktx  fkimg
              ntgew  brgew
         FROM vbrp
         INTO (l_werks,  gv_matnr,
               gv_arktx, l_fkimg,
               gv_ntgew, gv_brgew)
WHERE vbeln = is_bil_invoice-hd_gen-bil_number.

IF sy-subrc = 0.
  SELECT SINGLE adrnr INTO l_adrnr
  FROM t001w
  WHERE werks = l_werks.
  IF sy-subrc = 0.
    SELECT SINGLE * FROM adrc INTO gs_pl_adrc
        WHERE addrnumber = l_adrnr.

      SELECT SINGLE j_1bbranch
            FROM  t001w
            INTO lv_branch
            WHERE werks = l_werks.

    SELECT SINGLE gstin
            FROM  j_1bbranch
            INTO  gv_gst_p
            WHERE bukrs = is_bil_invoice-hd_org-comp_code
             AND  branch = lv_branch.
    IF gv_gst_p IS INITIAL.
      gv_gst_p = '27AACCD2898L1Z4'.
    ENDIF.


    IF sy-subrc = 0.
      SELECT SINGLE landx FROM t005t INTO gv_pl_landx
      WHERE land1 = gs_pl_adrc-country
        AND spras = 'EN'.

      SELECT SINGLE * FROM t005u INTO gs_pl_t005u
        WHERE spras = sy-langu
          AND land1 = gs_pl_adrc-country
          AND bland = gs_pl_adrc-region.
    ENDIF.

    SELECT SINGLE * FROM adrct
      INTO gs_pl_adrct
      WHERE addrnumber = l_adrnr.

  ENDIF.

  SELECT SINGLE j_1iexcd FROM j_1imocomp INTO gv_j_1iexcd
      WHERE werks = l_werks.

ENDIF.
