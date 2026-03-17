DATA: gt_konv TYPE TABLE OF konv,
      ls_konv type konv,
      ls_taxs TYPE konv.

PERFORM get_textname USING    is_bil_invoice-hd_gen-bil_number
                              is_bil_invoice-hd_org-salesorg
                     CHANGING gf_txnam_adr
                              gf_txnam_kop
                              gf_txnam_fus
                              gf_txnam_gru
                              gf_txnam_sdb.

SELECT SINGLE knumv FROM vbrk
  INTO gv_knumv
  WHERE vbeln = is_bil_invoice-hd_gen-bil_number.

SELECT * FROM konv INTO TABLE gt_konv
  WHERE knumv = gv_knumv.

DELETE gt_konv WHERE kstat = 'X'
                  OR NOT kinak IS INITIAL.


LOOP AT gt_konv INTO ls_konv.
  CHECK NOT ( ls_konv-kschl = 'ZPR0'
             OR ls_konv-kschl = 'VPRS'
             OR ls_konv-kschl = 'ZSET'
             OR ls_konv-kschl = 'ZSCT'
             OR ls_konv-kschl = 'ZSRT'
             OR ls_konv-kschl = 'ZSWB'
             OR ls_konv-kschl = 'ZKKT'
             ).
  CHECK ls_konv-kinak IS INITIAL.

  ls_taxs-kschl = ls_konv-kschl.
  ls_taxs-kwert = ls_konv-kwert.
*  ls_taxs-KRECH = ls_konv-KRECH.
  COLLECT ls_taxs INTO gt_taxs.
ENDLOOP.

FIELD-SYMBOLS <fs_taxs> TYPE konv.
DATA lv_vtext TYPE t685t-vtext.
LOOP AT gt_taxs ASSIGNING <fs_taxs>.
  CLEAR ls_konv.
  READ TABLE gt_konv INTO ls_konv
    WITH KEY kschl = <fs_taxs>-kschl.
  <fs_taxs>-kbetr = ls_konv-kbetr / 10.
  <fs_taxs>-krech = ls_konv-krech.
  <fs_taxs>-waers = ls_konv-waers.
  SELECT SINGLE vtext FROM t685t INTO lv_vtext
    WHERE kschl = <fs_taxs>-kschl
      AND spras = 'EN'.

  REPLACE '(%)' IN lv_vtext WITH ''.
  REPLACE '(%' IN lv_vtext WITH ''.
  REPLACE '%' IN lv_vtext WITH ''.

  <fs_taxs>-varcond = lv_vtext.

  CASE <fs_taxs>-kschl.
*    WHEN 'JCST'.
*      <fs_taxs>-stunr = 10.
*      <fs_taxs>-varcond = 'CST'.
*    WHEN 'ZCST'.
*      <fs_taxs>-stunr = 12.
*      <fs_taxs>-varcond = 'CST'.
*    WHEN 'JCSR'.<fs_taxs>-stunr = 14.
*    WHEN 'ZCSR'.<fs_taxs>-stunr = 16.
    WHEN 'JSER' OR 'ZSER'.
      <fs_taxs>-stunr = 20.
      <fs_taxs>-varcond = 'Service Tax'.
    WHEN 'ZSBC'.
      <fs_taxs>-stunr = 22.
      <fs_taxs>-varcond = 'Swachh Bharat Cess'.
    WHEN 'ZKKL'.
      <fs_taxs>-stunr = 24.
      <fs_taxs>-varcond = 'Krishi Kalyan Cess'.
*    WHEN 'ZGST'.<fs_taxs>-stunr = 26.
*    WHEN 'JTCS'.<fs_taxs>-stunr = 30.
*    WHEN 'ZFK1'.<fs_taxs>-stunr = 32.
*    WHEN 'ZTDS'.
*      <fs_taxs>-stunr = 34.
*      <fs_taxs>-varcond = 'TDS'.
*	WHEN 'JCST'.<fs_taxs>-STUNR = 34.
*	WHEN 'ZCST'.<fs_taxs>-STUNR = 36.
*	WHEN 'JCST'.<fs_taxs>-STUNR = 40.
*	WHEN 'ZCST'.<fs_taxs>-STUNR = 42.
    WHEN OTHERS.
  ENDCASE.
ENDLOOP.

DELETE gt_taxs WHERE kwert = 0.


















