  DATA:
    lv_branch TYPE j_1bbranch-branch,
    ls_item   TYPE t_item.
*BREAK-POINT.
  SELECT SINGLE xblnr
          FROM  vbrk
          INTO  gv_xblnr
          WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.

  SHIFT gv_xblnr LEFT DELETING LEADING '0'.

  gv_com = 'Industrial Valve/Actuator/Accessories'.
  CONDENSE gv_com.

  SELECT vbeln
         posnr
         fkimg
         vrkme
         netwr
         matnr
         arktx
         werks
         aubel
         aupos
    FROM vbrp
    INTO TABLE gt_item
    WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.

  IF sy-subrc IS INITIAL.
    READ TABLE gt_item INTO ls_item INDEX 1.

*break fujiabap.
    SELECT SINGLE j_1bbranch
            FROM  t001w
            INTO lv_branch
            WHERE werks = ls_item-werks.

    SELECT SINGLE gstin
            FROM  j_1bbranch
            INTO  gv_gst_p
            WHERE bukrs = ls_bil_invoice-hd_org-comp_code
             AND  branch = lv_branch.
    IF gv_gst_p IS INITIAL.
      gv_gst_p = '27AACCD2898L1Z4'.
    ENDIF.

    SELECT knumv
           kposn
           kschl
           kbetr
           waers
           kwert
           kstat
      FROM konv
      INTO TABLE gt_conditions
      WHERE knumv = ls_bil_invoice-hd_gen-kond_numb.

    SELECT matnr
           maktx
      FROM makt
      INTO TABLE gt_mat_desc
      FOR ALL ENTRIES IN gt_item
      WHERE matnr = gt_item-matnr
      AND   spras = sy-langu.
  ENDIF.
  DATA:
    lv_vkbur TYPE vbak-vkbur.

  SELECT SINGLE vkbur
           FROM vbak
           INTO lv_vkbur
           WHERE vbeln = ls_bil_invoice-hd_ref-order_numb.

  SELECT SINGLE bezei
           FROM tvkbt
           INTO gv_office
           WHERE vkbur = lv_vkbur
           AND   spras = sy-langu.


  DATA:
    objname      TYPE tdobname.

  objname = ls_bil_invoice-hd_gen-bil_number.
* Ftech info for Mode Of Transport
  PERFORM get_text USING objname 'VBBK' 'Z013' 'E'
                      CHANGING gv_trnsprt_mode.
  CONDENSE gv_trnsprt_mode.

* Ftech info for exemption notification
  PERFORM get_text USING objname 'VBBK' 'Z035' 'E'
                   CHANGING gv_exm.
  CONDENSE gv_exm.

* Get name of Transporter
  PERFORM get_text USING objname 'VBBK' 'Z002' 'E'
                   CHANGING gv_trnsprtr_name.
  CONDENSE gv_trnsprtr_name.

* Get Transporter
  PERFORM get_text USING objname 'VBBK' 'Z012' 'E'
                   CHANGING gv_lr_dt.
  CONDENSE gv_lr_dt.

* Get name of L.R.No.
  PERFORM get_text USING objname 'VBBK' 'Z026' 'E'
                   CHANGING gv_l_r_no.
  CONDENSE gv_l_r_no.

* Get name of Delivery basis.
  PERFORM get_text USING objname 'VBBK' 'Z029' 'E'
                   CHANGING gv_del.
  CONDENSE gv_del.

* Get name of Consignee copy.
  PERFORM get_text USING objname 'VBBK' 'Z028' 'E'
                   CHANGING gv_con.
  CONDENSE gv_con.
* Get Vehicle No.
  PERFORM get_text USING objname 'VBBK' 'Z004' 'E'
                   CHANGING gv_vhicl.
  CONDENSE gv_vhicl.

* Get Freight.
  PERFORM get_text USING objname 'VBBK' 'Z005' 'E'
                   CHANGING gv_freight.
  CONDENSE gv_freight.

"Added by Snehal Rajale on 26.12.2020

SELECT SINGLE *
FROM j_1ig_invrefnum
INTO gs_zeinv_response
WHERE docno = ls_bil_invoice-hd_gen-bil_number AND
bukrs = ls_bil_invoice-hd_org-comp_code .

IF SY-SUBRC = 0.
  gv_irn_no = gs_zeinv_response-irn.

  gv_qrcode2 = gs_zeinv_response-signed_qrcode.
ENDIF.

SELECT SINGLE mwsbk
FROM  vbrk
INTO  gv_mwsbk
WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.
