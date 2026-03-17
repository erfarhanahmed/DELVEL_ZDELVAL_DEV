BREAK jbondale.

break primus.
* set textnames for header, adress and footer
PERFORM get_textname
  USING is_bil_invoice-hd_gen-bil_number
        is_bil_invoice-hd_org-salesorg
  CHANGING gf_txnam_adr   gf_txnam_kop
           gf_txnam_fus   gf_txnam_gru  gf_txnam_sdb.

SELECT vhilm FROM vekp
  INTO gs_pack-vhilm
  WHERE vpobj = '01'
    AND vpobjkey = is_bil_invoice-hd_ref-deliv_numb.
                                                            "0080000087
  gs_pack-pkcnt = 1.
  COLLECT gs_pack INTO gt_pack.

ENDSELECT.
DATA ls_mara TYPE mara.
CLEAR gv_tot_pk.
LOOP AT gt_pack INTO gs_pack.
  CLEAR ls_mara.
  SELECT SINGLE groes FROM mara
    INTO gs_pack-groes
    WHERE matnr = gs_pack-vhilm.
  SELECT SINGLE maktx FROM makt
    INTO gs_pack-maktx
    WHERE matnr = gs_pack-vhilm
      AND spras = sy-langu.
  gv_tot_pk = gv_tot_pk + gs_pack-pkcnt.
  MODIFY gt_pack FROM gs_pack.
ENDLOOP.


DATA: lv_cnt    TYPE i,
      lv_txt(5).

gt_it_gen[] = is_bil_invoice-it_gen[].

DESCRIBE TABLE gt_it_gen LINES lv_cnt.
CASE lv_cnt.
  WHEN 1.
    APPEND INITIAL LINE TO gt_it_gen.
    APPEND INITIAL LINE TO gt_it_gen.
  WHEN 2.
    APPEND INITIAL LINE TO gt_it_gen.
  WHEN OTHERS.
ENDCASE.

WRITE gv_tot_pk TO lv_txt LEFT-JUSTIFIED.

CONCATENATE '1 of' lv_txt
  INTO gs_it_gen-disp_type_descr
  SEPARATED BY space.
MODIFY gt_it_gen FROM gs_it_gen
  INDEX 1 TRANSPORTING disp_type_descr.

gs_it_gen-disp_type_descr = 'TO'.
MODIFY gt_it_gen FROM gs_it_gen
  INDEX 2 TRANSPORTING disp_type_descr.

CONCATENATE lv_txt 'of' lv_txt
  INTO gs_it_gen-disp_type_descr
  SEPARATED BY space.
MODIFY gt_it_gen FROM gs_it_gen
  INDEX 3 TRANSPORTING disp_type_descr.

SELECT SINGLE knumv
         FROM vbrk
         INTO l_knumv
        WHERE vbeln = is_bil_invoice-hd_gen-bil_number.
SELECT SINGLE xblnr
         FROM vbrk
         INTO l_xblnr
        WHERE vbeln = is_bil_invoice-hd_gen-bil_number.

REFRESH : it_konv , it_konv[] .
CLEAR   : wa_konv .

IF l_knumv IS NOT INITIAL.

  SELECT knumv
         kschl
         kawrt
         waers
         kwert
         kinak
         kstat
          FROM konv
               INTO TABLE it_konv
                  WHERE knumv = l_knumv .
*
*  DELETE it_konv WHERE kstat = 'X'
*              OR NOT kinak IS INITIAL.

  DELETE it_konv WHERE kwert IS INITIAL .

  FIELD-SYMBOLS : <fs_taxs> TYPE ty_total.

  LOOP AT it_konv INTO wa_konv.

    CHECK NOT ( wa_konv-kschl = 'ZPR1'
*               OR wa_konv-kschl = 'ZPR0'
               OR wa_konv-kschl = 'ZCIF'
               OR wa_konv-kschl = 'VPRS' ).
    CHECK wa_konv-kinak IS INITIAL.

    gs_total-kschl = wa_konv-kschl.
    gs_total-kwert = wa_konv-kwert.

    COLLECT gs_total INTO gt_total.
  ENDLOOP.


  LOOP AT gt_total ASSIGNING <fs_taxs>.
    CASE <fs_taxs>-kschl.
      WHEN 'ZPR0'.
        <fs_taxs>-srno = 1.
        <fs_taxs>-text = 'Total'.
      WHEN 'ZPFO'.
        <fs_taxs>-srno = 2.
        <fs_taxs>-text = 'P & F'.
      WHEN 'ZDIS'.
        <fs_taxs>-srno = 3.
        <fs_taxs>-text = 'Discount'.
      WHEN 'ZEXP'.
        <fs_taxs>-srno = 4. """ 14
        <fs_taxs>-text = 'Excise Duty Collected '.
      WHEN 'ZIN1'.
        <fs_taxs>-srno = 6.
        <fs_taxs>-text = 'Insurance Taxable'.
      WHEN 'ZFR1'.
        <fs_taxs>-srno = 7.
        <fs_taxs>-text = 'Freight Taxable'.
      WHEN 'ZOC1'.
        <fs_taxs>-srno = 8.
        <fs_taxs>-text = 'Octroi Taxable'.
      WHEN 'ZTE1'.
        <fs_taxs>-srno = 9.
        <fs_taxs>-text = 'Testing Taxable'.
      WHEN 'ZTC1'.
        <fs_taxs>-srno = 10.
        <fs_taxs>-text = 'Testing & Certificate Taxable'.
      WHEN 'ZLST'.
        <fs_taxs>-srno = 11.
        <fs_taxs>-text = 'VAT'.
      WHEN 'ZCST'.
        <fs_taxs>-srno = 12.
        <fs_taxs>-text = 'CST'.
      WHEN 'ZIN2'.
        <fs_taxs>-srno = 13.
        <fs_taxs>-text = 'Insurance Non Taxable'.
      WHEN 'ZFR2'.
        <fs_taxs>-srno = 14.
        <fs_taxs>-text = 'Freight Non Taxable'.
      WHEN 'ZOC2'.
        <fs_taxs>-srno = 15.
        <fs_taxs>-text = 'Octroi Non Taxable'.
      WHEN 'ZTE2'.
        <fs_taxs>-srno = 16.
        <fs_taxs>-text = 'Testing Non Taxable'.
      WHEN 'ZTC2'.
        <fs_taxs>-srno = 17.
        <fs_taxs>-text = 'Testing & Certificate Non Taxable'.
      WHEN 'JWTS'.
        <fs_taxs>-srno = 18.
        <fs_taxs>-text = 'TCS Collected @ 1%'.
      WHEN 'ZFCM'.
        <fs_taxs>-srno = 19.
        <fs_taxs>-text = 'Customer Free Material'.
      WHEN 'ZFM2'.
        <fs_taxs>-srno = 20.
        <fs_taxs>-text = 'Customer Free Mat Minus'.
      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.

BREAK kdeshmukh .
*BREAK primus.
  DATA : v_tax TYPE konv-kwert,
         v_gt  TYPE konv-kwert.
  CLEAR : v_tax , gs_total , v_gt.

  DELETE gt_total WHERE srno IS INITIAL.

  LOOP AT gt_total INTO gs_total .

    IF gs_total-kschl = 'ZPR0' OR
       gs_total-kschl = 'ZPFO' OR
       gs_total-kschl = 'ZEXP'.

      v_tax = v_tax + gs_total-kwert .
    ELSEIF  gs_total-srno GT 5.
      v_gt = v_gt + gs_total-kwert  .
*      v_tax = v_tax + gs_total-kwert.
    ENDIF.

  ENDLOOP.

  CLEAR gs_total .
  gs_total-srno = 5 .
  gs_total-text = 'Sub Total' .
  gs_total-kwert = v_tax .
  APPEND gs_total TO gt_total .

  CLEAR gs_total .
  gs_total-srno = 21 .
  gs_total-text = 'Grand Total' .
  gs_total-kwert = ( v_tax + v_gt ).
  APPEND gs_total TO gt_total .

ENDIF.
clear gs_total.
SORT gt_total BY srno .

*SELECT SUM( kbetr ) FROM konv INTO lv_fright
*                  WHERE knumv = l_knumv
*                    AND kschl IN ( 'ZFR1' , 'ZFR2' ) .
*
*DATA : lv_kschl TYPE konv-kschl .
*CLEAR : lv_kschl .
*SELECT SINGLE kschl FROM konv INTO lv_kschl
*                       WHERE knumv = l_knumv
*                    AND kschl IN ( 'ZFR1' , 'ZFR2' ) .
*
*SELECT SINGLE vtext FROM t685t INTO gv_ftxt
*                       WHERE spras = 'EN'
*                         AND kschl = lv_kschl .
