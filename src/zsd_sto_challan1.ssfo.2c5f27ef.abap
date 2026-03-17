data : objname TYPE tdobname.
DATA:
  lt_j_1ig_subcon TYPE tt_j_1ig_subcon,
  ls_j_1ig_subcon TYPE t_j_1ig_subcon.

SELECT bukrs
       mblnr
       mjahr
       zeile
       chln_inv
       bwart     "added by pankaj 12.10.2021
       item
       menge
       meins
       matnr
  FROM j_1ig_subcon
  INTO TABLE gt_j_1ig_subcon
  FOR ALL ENTRIES IN gt_item
  WHERE chln_inv = gt_item-vbeln.


  IF NOT gt_j_1ig_subcon is INITIAL.
    SELECT mblnr
           mjahr
           zeile
           bwart    "added by pankaj 12.10.2021
           matnr    "added by pankaj 12.10.2021
           ebeln
           ebelp
      FROM mseg
      INTO TABLE gt_mat_doc
      FOR ALL ENTRIES IN gt_j_1ig_subcon
      WHERE mblnr = gt_j_1ig_subcon-mblnr
      AND   mjahr = gt_j_1ig_subcon-mjahr
      AND   zeile = gt_j_1ig_subcon-zeile
      "code added by panka 12.10.2021
      AND   bwart = '541'  "Commented by Pankaj 10.11.21 '543'   "gt_j_1ig_subcon-bwart
      AND   matnr = gt_j_1ig_subcon-matnr.

" added by pankaj 13.10.2021
SORT gt_mat_doc by mblnr DESCENDING.
SORT gt_mat_doc by zeile DESCENDING.
SORT gt_mat_doc by ebeln ASCENDING.

  SELECT ebeln
         ebelp
         TXZ01
         matnr
         menge
         meins
         mwskz
         werks
         netwr
    FROM ekpo
    INTO TABLE gt_purchasing
    FOR ALL ENTRIES IN gt_mat_doc
    WHERE ebeln = gt_mat_doc-ebeln
    AND   ebelp = gt_mat_doc-ebelp.

"commented by pankaj 11.11.2021
*    IF sy-subrc is INITIAL.
*     SELECT matnr
*         maktx
*    FROM makt
*    INTO TABLE GT_MAT_DESC
*    FOR ALL ENTRIES IN gt_purchasing
*    WHERE matnr = gt_purchasing-matnr
*      AND spras = sy-langu.
*
*    ENDIF.
  ENDIF.


READ TABLE it_final INTO wa_final INDEX 1.



"Added BY Snehal Rajale on 31.12.2020

LOOP AT gt_purchasing INTO gs_purchasing.

  SELECT SINGLE ebeln
  ebelp
  knttp
  FROM ekpo
  INTO ls_ekpo
  WHERE ebeln = gs_purchasing-ebeln AND
  ebelp = gs_purchasing-ebelp AND
  knttp = 'E'.
  IF SY-SUBRC = 0 .
    GV_KNTTP = LS_EKPO-KNTTP.
    SELECT SINGLE matnr
                  spras
                  maktx
                  FROM makt
                  INTO ls_makt
                  WHERE matnr = GS_PURCHASING-matnr.

    SELECT SINGLE EBELN
                  EBELP
                  ZEKKN
                  VBELN
                  VBELP
              FROM ekkn
              INTO ls_ekkn
              WHERE ebeln = gs_purchasing-ebeln  AND
              ebelp = gs_purchasing-ebelp.

      SELECT SINGLE  vkbur FROM vbak INTO @DATA(lv_vkbur)
        WHERE vbeln = @ls_ekkn-vbeln.

SELECT SINGLE bezei FROM tvkbt INTO lv_branch
  WHERE vkbur = lv_vkbur.

      SELECT SINGLE MATNR
      WERKS
      dispo
      FROM marc
      INTO ls_marc
      WHERE matnr = GS_PURCHASING-matnr AND
      werks = GS_PURCHASING-werks.

    SELECT SINGLE WRKST
    INTO GV_WRKST
    FROM MARA
    WHERE MATNR = GS_PURCHASING-matnr .
*
    SELECT SINGLE vbeln
    posnr
    zce
    zgad
    FROM vbap
    INTO ls_vbap
    WHERE vbeln = ls_ekkn-vbeln.
    IF ls_vbap-zce = 'X'.
      gv_pc = 'CE'.
    ENDIF.
*
    IF ls_vbap-zgad = '1'.
      gv_zgad = 'Reference'.
  ELSEIF ls_vbap-zgad = '2'.
      gv_zgad = 'Approved'.
  ELSEIF ls_vbap-zgad = '3'.
      gv_zgad = 'Standard'.
    ENDIF.


    CLEAR objname.
    objname = ls_ekkn-vbeln.
    PERFORM get_text USING objname 'VBBK' 'Z038' 'E' CHANGING gv_text_LD.
*
    CLEAR objname.
    objname = ls_ekkn-vbeln.
    PERFORM get_text USING objname 'VBBK' 'Z039' 'E' CHANGING gv_text_tag.


    CLEAR objname.
    objname = ls_ekkn-vbeln.
    PERFORM get_text USING objname 'VBBK' 'Z999' 'E' CHANGING gv_text_tpi.

    CLEAR objname.
    objname = GS_PURCHASING-MATNR.
    PERFORM get_text USING objname 'MATERIAL' 'GRUN' 'S' CHANGING gv_text_NOTE.


  ENDIF.
ENDLOOP.
