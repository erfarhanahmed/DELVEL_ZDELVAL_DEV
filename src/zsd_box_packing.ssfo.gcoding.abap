DATA ls_vbfa TYPE vbfa.

*BREAK PRIMUS.

*SELECT POSNR
*       BOX_NO
*       LOOSE_ITEM
*       QUANTITY
*      FROM LIPS INTO  TABLE IT_DATA
*  WHERE VBELN =  is_dlv_delnote-hd_gen-deliv_numb.
*DATA :WA_DATA TYPE IT_DATA.
SELECT SINGLE * FROM vbfa INTO ls_vbfa
  WHERE vbelv = is_dlv_delnote-hd_gen-deliv_numb
    AND vbtyp_n = 'M'.
*BREAK primus.
SELECT SINGLE * FROM vbrk INTO gs_vbrk
  WHERE vbeln = ls_vbfa-vbeln.


* set textnames for header, adress and footer
PERFORM get_textname USING    is_dlv_delnote
  CHANGING gf_txnam_adr gf_txnam_kop gf_txnam_fus
    gf_txnam_gru  gf_txnam_sdb  gf_txnam_ala.

* object text name header
gf_tdname = is_dlv_delnote-hd_gen-deliv_numb.

* get customer adress number
READ TABLE is_dlv_delnote-hd_adr INTO gs_hd_adr
WITH KEY deliv_numb   = is_dlv_delnote-hd_gen-deliv_numb
output_partn = 'X'.
IF sy-subrc NE 0.
  READ TABLE is_dlv_delnote-hd_adr INTO gs_hd_adr
  WITH KEY deliv_numb = is_dlv_delnote-hd_gen-deliv_numb
  partn_role = 'WE'.
  IF sy-subrc NE 0.
    CLEAR gs_hd_adr.
  ENDIF.
ENDIF.


"""""""   Changed by KD on 26.04.2017    """"""
*SELECT vbeln  posnr venum vemng
*  INTO CORRESPONDING FIELDS OF TABLE it_vepo
*  FROM vepo
*  FOR ALL ENTRIES IN is_dlv_delnote-it_gen
*  WHERE vbeln = is_dlv_delnote-it_gen-deliv_numb
*    AND posnr = is_dlv_delnote-it_gen-itm_number.

*SELECT vbeln  posnr venum vemng
*INTO CORRESPONDING FIELDS OF TABLE it_vepo
*FROM vepo
*WHERE vbeln = is_dlv_delnote-hd_gen-deliv_numb.
*"""""""""""""""" END   26.04.2017    """""""""""""""""
**BREAK PRIMUS.
*SELECT  VBELN
*        POSNR
*       BOX_NO
*       LOOSE_ITEM
*       QUANTITY
*      FROM LIPS INTO  TABLE IT_DATA
*      FOR ALL ENTRIES IN IT_VEPO
*  WHERE VBELN = IT_VEPO-VBELN AND
*  POSNR = IT_VEPO-POSNR.
*
*SORT it_vepo BY venum.
*
*SELECT vhilm FROM vekp
*  INTO gs_pack-vhilm
*  WHERE vpobj = '01'
*    AND vpobjkey = is_dlv_delnote-hd_gen-deliv_numb.
*                                                            "0080000087
*  gs_pack-pkcnt = 1.
*  COLLECT gs_pack INTO gt_pack.
*ENDSELECT.
*
*DATA ls_mara TYPE mara.
*CLEAR gv_tot_pk.
*LOOP AT gt_pack INTO gs_pack.
*  CLEAR ls_mara.
*  SELECT SINGLE groes FROM mara
*    INTO gs_pack-groes
*    WHERE matnr = gs_pack-vhilm.
*  SELECT SINGLE maktx FROM makt
*    INTO gs_pack-maktx
*    WHERE matnr = gs_pack-vhilm
*      AND spras = sy-langu.
*  gv_tot_pk = gv_tot_pk + gs_pack-pkcnt.
*  MODIFY gt_pack FROM gs_pack.
*ENDLOOP.


SELECT VHILM_KU
       VBELN
       ZLMAT
       ZMATQN FROM ZMATQUAN INTO TABLE it_mat
       WHERE VBELN = is_dlv_delnote-hd_gen-deliv_numb .

IF sy-subrc = 0.

ENDIF.
