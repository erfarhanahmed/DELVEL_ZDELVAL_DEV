
    gv_gst_p = '27AACCD2898L1Z4'.
    SELECT *
      FROM rseg
      INTO TABLE it_rseg
      WHERE belnr EQ belnr
      AND   gjahr EQ gjahr.
    DATA:
       lv_awkey TYPE bkpf-awkey.
    CONCATENATE belnr gjahr INTO lv_awkey.

    SELECT SINGLE bukrs
                  belnr
                  gjahr
                  bldat
                  budat
                  blart
                  xblnr
                  bktxt
                  waers
                  kursf
                  xblnr_alt
             FROM bkpf
             INTO gs_accounting_doc_hdr
             WHERE awkey = lv_awkey.

    SHIFT gs_accounting_doc_hdr-xblnr_alt LEFT DELETING LEADING '0'.
*BREAK-POINT.
    SELECT bukrs
           belnr
           gjahr
           buzei
           dmbtr
           sgtxt
           kunnr
           lifnr
      FROM bseg
      INTO TABLE gt_accounting_doc_item
      WHERE belnr = gs_accounting_doc_hdr-belnr
      AND   gjahr = gs_accounting_doc_hdr-gjahr
      AND   ktosl EQ space.


*BREAK-POINT.
    IF NOT it_rseg IS INITIAL.
      SELECT matnr
             maktx
        FROM makt
        INTO TABLE gt_makt
        FOR ALL ENTRIES IN it_rseg
        WHERE matnr = it_rseg-matnr
        AND   spras = sy-langu.

      SELECT ebeln
             ebelp
             netpr
        FROM ekpo
        INTO TABLE gt_ekpo
        FOR ALL ENTRIES IN it_rseg
        WHERE ebeln = it_rseg-ebeln
        AND   ebelp = it_rseg-ebelp.

    ENDIF.
    data:
      ls_ekpo type t_ekpo.

    READ TABLE gt_ekpo INTO ls_ekpo INDEX 1.
    gv_ebeln = ls_ekpo-ebeln.
    SELECT SINGLE aedat
             FROM ekko
             INTO gv_dt
             WHERE ebeln = gv_ebeln.
