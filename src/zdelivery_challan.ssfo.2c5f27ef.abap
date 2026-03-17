DATA:
  lt_j_1ig_subcon TYPE tt_j_1ig_subcon,
  ls_j_1ig_subcon TYPE t_j_1ig_subcon.

**BREAK-POINT.
SELECT bukrs
       mblnr
       mjahr
       zeile
       chln_inv
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
           ebeln
           ebelp
      FROM mseg
      INTO TABLE gt_mat_doc
      FOR ALL ENTRIES IN gt_j_1ig_subcon
      WHERE mblnr = gt_j_1ig_subcon-mblnr
      AND   mjahr = gt_j_1ig_subcon-mjahr
      AND   zeile = gt_j_1ig_subcon-zeile.

*BREAK-POINT.
  SELECT ebeln
         ebelp
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

    IF sy-subrc is INITIAL.
     SELECT matnr
         maktx
    FROM makt
    INTO TABLE GT_MAT_DESC
    FOR ALL ENTRIES IN gt_purchasing
    WHERE matnr = gt_purchasing-matnr
      AND spras = sy-langu.

    ENDIF.
  ENDIF.
