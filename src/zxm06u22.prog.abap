*&---------------------------------------------------------------------*
*&  Include           ZXM06U22
*&---------------------------------------------------------------------
*BREAK-POINT.
*commented by gj 31-10-2017
**MOVE-CORRESPONDING i_cekko TO e_cekko.
***--This logic only working for ME29N OR ME28N only
***break pmg-abap02.
**IF sy-tcode EQ 'ME21N' OR sy-tcode EQ 'ME22N' OR sy-tcode EQ 'ME23N'
**    OR sy-tcode EQ 'ME28' OR sy-tcode EQ 'ME29N'
**    OR sy-tcode EQ 'ME31L' OR sy-tcode EQ 'ME35L'
**    OR sy-tcode EQ 'ME31K' OR sy-tcode EQ 'ME35K'.
***--Checking  Purchasing Document Category 'F' or not
**  IF i_cekko-bstyp EQ 'F'."Chek Purchasing Document Category 'F' or not
**  BREAK FUJIABAP.
**
**    DATA : wa_bekpo LIKE LINE OF it_bekpo,
**           lv_tot   LIKE bekpo-netwr,
**           lv_sub   LIKE bekpo-netwr,
**           v_knumv  LIKE ekko-knumv,
**           v_dptyp  LIKE ekko-dptyp,
**           v_kwert  LIKE konv-kwert.
**
**    DATA v_usrc1 TYPE cekko-usrc1.
**
**    MOVE-CORRESPONDING i_cekko TO e_cekko.
**    IF sy-tcode = 'ME22N' OR sy-tcode = 'ME23N' OR sy-tcode = 'ME29N' .
***--Any changes in Pricing condition added or chanhed
****      Changed by Prakash J on 16.05.2011
**
**
***      if sy-ucomm = 'TABHDT3'."added on 25.6.2012
**
********  code commented on 28.06.2012 based on discussion with amarnath
***      LOOP AT  it_bekpo INTO wa_bekpo .
***        IF wa_bekpo-loekz  IS INITIAL.
***            lv_tot  =  lv_tot  +
****                   wa_bekpo-kzwi1 +
****                   wa_bekpo-kzwi2 +
****                   wa_bekpo-kzwi3 +
***                       wa_bekpo-effwr +
****                   wa_bekpo-kzwi4 +
****                   wa_bekpo-kzwi5 +
****                   wa_bekpo-kzwi6 +
***                       v_kwert.
***
***        ENDIF.
****      Changed by Prakash J on 16.05.2011
***      ENDLOOP.
***
***      e_cekko-gnetw  = lv_tot.
********code commented on 28.06.2012 based on discussion with amarnath
**    ENDIF.
**
***    ELSE.
**IF sy-tcode EQ 'ME21N' OR sy-tcode EQ 'ME22N' OR sy-tcode EQ 'ME23N'
**    OR sy-tcode = 'ME29N' OR sy-tcode EQ 'ME31L' OR sy-tcode EQ 'ME35L'
**    OR sy-tcode EQ 'ME31K' OR sy-tcode EQ 'ME35K'.
***--Updating DP Category TO communication structure CEKKO
********code commented on 28.06.2012 based on discussion with amarnath
**      FIELD-SYMBOLS: <dptyp> TYPE ekko-dptyp.
**
**      ASSIGN  ('(SAPLMEPO)EKKO-DPTYP') TO <dptyp>.
**
**
**      IF <dptyp> EQ ''.
**        IF sy-ucomm NE 'MERELEASE'.
**          v_dptyp = 'Z'.
**
**          i_cekko-usrc1 =  v_dptyp.
**
**          e_cekko-usrc1 =  v_dptyp.
**
**        ELSE.
**
**          i_cekko-usrc1 = <dptyp>.
**
**          e_cekko-usrc1 = <dptyp>.
**
**        ENDIF.
**      ELSE.
**        i_cekko-usrc1 = <dptyp>.
**
**        e_cekko-usrc1 = <dptyp>.
**      ENDIF.
**    ENDIF.
********code commented on 28.06.2012 based on discussion with amarnath
**  ENDIF."Checking Transaction only ME21N OR ME22N OR ME29N OR ME28N
**ENDIF."CHECKING Purchasing Document Category 'F' or not
**
**"Addition of code for Re-trigering the PO Release Strategy by Rishiraj on 10/8/2016
**e_cekko = i_cekko .
**
**CLEAR wa_bekpo.
**
**TYPES : BEGIN OF gs_ekko,
**          ebeln TYPE ebeln,
**          knumv TYPE knumv,
**        END OF gs_ekko,
**
**        BEGIN OF gs_konv,
**          knumv TYPE knumv,
**          kposn TYPE kposn,
**          kschl TYPE kscha,
**          kbetr TYPE kbetr,
**        END OF gs_konv.
**
**DATA : gw_ekko TYPE gs_ekko,
**
**       gt_konv TYPE TABLE OF gs_konv,
**       gt_konv1 TYPE TABLE OF gs_konv,
**       gw_konv TYPE gs_konv,
**
**       wa_ekpo TYPE ekpo,
**       wa_cekko TYPE cekko,
**       w_reset(1) TYPE c VALUE 'X',
**       gv_tax TYPE konv-kbetr.
**
**IF sy-tcode EQ 'ME22N' OR sy-tcode EQ 'ME22'.
**  wa_cekko = i_cekko .
**  IMPORT wa_cekko = wa_cekko FROM MEMORY ID 'ZREL_COST'.
**  IF sy-subrc NE 0.
**    EXPORT wa_cekko = wa_cekko TO MEMORY ID 'ZREL_COST'.
**  ENDIF.
**ENDIF.
**
**
**IF ( sy-tcode EQ 'ME22N' OR sy-tcode EQ 'ME22' )
**  AND sy-ucomm EQ 'MESAVE' OR sy-ucomm EQ 'MECHECKDOC'.
**
***Import/Export the origninal values.
**
***Check if the limit is passed.
**  LOOP AT it_bekpo INTO wa_bekpo.
**
**    SELECT SINGLE netwr
**      FROM ekpo
**      INTO wa_ekpo-netwr
**      WHERE ebeln EQ wa_bekpo-ebeln
**        AND ebelp EQ wa_bekpo-ebelp.
**
**    IF sy-subrc EQ 0.
**
**      SELECT SINGLE ebeln knumv
**        FROM ekko
**        INTO gw_ekko
**        WHERE ebeln = wa_bekpo-ebeln.
**
**      IF sy-subrc = 0.
**
**        SELECT knumv kposn kschl kbetr
**          FROM konv
**          INTO TABLE gt_konv
**          WHERE knumv = gw_ekko-knumv
**            AND kschl = 'JEXS'.
**
**        LOOP AT gt_konv INTO gw_konv.
**
**          gv_tax = gv_tax + gw_konv-kbetr.
**
**        ENDLOOP.
**
**      ENDIF.
**      IF wa_bekpo-netwr < wa_ekpo-netwr.
**        w_reset = 'X'.
**      ENDIF.
**    ENDIF.
**
**  ENDLOOP.
**
***IF limit passed - reset the value to high limit beyond tolerance.
**  IF w_reset = 'X'.
**    e_cekko-gnetw = wa_cekko-gnetw + 10000.
**  ENDIF.
**
**ENDIF.



*$*$-Start:--------------------------ADDED BY GJ ON 31-10-2017-----------------------$*$*

*$*$   EXPORT PO ITEM CONDITION TABLE FOR ENHANCEMENT IMPLEMENTATION OF TRIGGER RELEASE
*$*$   STRATEGE FOR PO ITEM WHEN FREIGHT CONDITION CHANGE OR ADDED.
*$*$---------------------------------------------------------------------------------$*$*

DATA : wa_bekpo        LIKE LINE OF it_bekpo,
       lv_ekko         TYPE ekko,
       lv_ekpo         TYPE ekpo,
       it_ekpo         TYPE TABLE OF ekpo,
       wa_ekpo         TYPE ekpo,
       ls_ekpo         TYPE ekpo,
       lt_konv         TYPE TABLE OF prcd_elements,
       ls_konv         TYPE prcd_elements,
       wa_konv         TYPE prcd_elements,
       old_tot_freight TYPE  prcd_elements-kwert,
       new_tot_freight TYPE  prcd_elements-kwert,
       tkomv           TYPE TABLE OF komv WITH HEADER LINE,
       ekko            TYPE ekko.

*$*$---------------------------------------------------------------------------------$*$*

*$*$  FOR BELOW IMPORT VALUE EXPORT FROM ENHANCEMENT-ZMM_POITEM_REL.
*$*$  IMPORT VALUE OF CODITION TABLE FROM EXPORTED MEMORY ID 'GJ'.
*$*$---------------------------------------------------------------------------------$*$*

IMPORT tkomv TO tkomv[] FROM  MEMORY ID 'GJ' ." Exported from include LMEPOF29 ZMM_POITEM_REL
IMPORT ekko TO ekko FROM  MEMORY ID 'VG' . " Exported from include LMEPOF2F  ZMM_POHEADER_REL BY VG

FREE MEMORY ID 'GJ'.

MOVE-CORRESPONDING i_cekko TO e_cekko.
IF ( sy-tcode EQ 'ME22N' OR sy-tcode EQ 'ME22' OR sy-tcode EQ 'ME23N' )
  AND sy-ucomm EQ 'MESAVE'." OR sy-ucomm EQ 'MECHECKDOC'."VG
  LOOP AT it_bekpo INTO wa_bekpo.
*BREAK-POINT.
    DATA: sub_tot TYPE dmbtr,
          tot     TYPE dmbtr,
          val     TYPE dmbtr,
          val_tot TYPE dmbtr.
    "******************************************
    SELECT SINGLE * FROM ekpo INTO wa_ekpo WHERE ebeln = wa_bekpo-ebeln
                                             AND ebelp =  wa_bekpo-ebelp.
    IF sy-subrc = 0.
      IF wa_ekpo-menge > wa_bekpo-menge.
        sub_tot = wa_ekpo-menge - wa_bekpo-menge.
        tot = sub_tot * wa_ekpo-netpr.
        e_cekko-gnetw = e_cekko-gnetw + ( tot + 1 )."wa_ekpo-brtwr + 1. "e_cekko-gnetw + 1.
      ENDIF.
    ENDIF.
    "*************************************************
    SELECT SINGLE * FROM ekko INTO lv_ekko WHERE ebeln = wa_bekpo-ebeln.
    IF sy-subrc = 0.
********************************added By VG for PAYMENT TERM change\
      IF ekko-zterm NE lv_ekko-zterm.
        e_cekko-gnetw = e_cekko-gnetw + 1.
      ENDIF.
********************************added By VG for Tax code change
      SELECT SINGLE * FROM ekpo INTO lv_ekpo WHERE ebeln = wa_bekpo-ebeln AND ebelp EQ wa_bekpo-ebelp.
      IF lv_ekpo-mwskz NE wa_bekpo-mwskz.
        e_cekko-gnetw = e_cekko-gnetw + 1.
      ENDIF.
********************************/added By VG

*$*$--ONLY FOR FREIGHT CONDITION/VALUE-----------------------------------------------$*$*
      DATA : lt_zcondtion_type TYPE TABLE OF zcondtion_type,
             ls_zcondtion_type TYPE zcondtion_type.
      BREAK fujiabap.
      SELECT kschl
      FROM zcondtion_type
      INTO CORRESPONDING FIELDS OF TABLE lt_zcondtion_type
      WHERE kschl NE ''.
      IF lt_zcondtion_type IS NOT INITIAL.
        SELECT * FROM prcd_elements INTO CORRESPONDING FIELDS OF TABLE lt_konv
              FOR ALL ENTRIES IN lt_zcondtion_type
              WHERE knumv = lv_ekko-knumv
              AND   kschl = lt_zcondtion_type-kschl.
      ENDIF.

      LOOP AT lt_konv INTO ls_konv.
        old_tot_freight = old_tot_freight +  ls_konv-kwert.

      ENDLOOP.
    ENDIF.

  ENDLOOP.

  LOOP AT tkomv." WHERE kschl = 'FRA1' .
    READ TABLE lt_zcondtion_type INTO ls_zcondtion_type WITH KEY kschl = ls_konv-kschl.
    IF ls_zcondtion_type IS NOT INITIAL.
      new_tot_freight = new_tot_freight + tkomv-kwert.
    ENDIF.

    "*****************vaishali ghule**********************
    SELECT SINGLE * FROM ekpo INTO ls_ekpo WHERE ebeln = wa_bekpo-ebeln
                                              AND ebelp =  wa_bekpo-ebelp.

*    BREAK-POINT.
    READ TABLE lt_konv INTO wa_konv WITH KEY knumv = tkomv-knumv
                                             kposn = tkomv-kposn
                                             kschl = tkomv-kschl.
    IF sy-subrc = 0.
      IF wa_konv-kbetr > tkomv-kbetr.
        val_tot = wa_konv-kbetr - tkomv-kbetr.
        val = val_tot * wa_bekpo-menge.    "wa_ekpo-netpr.
        e_cekko-gnetw = e_cekko-gnetw + ( val + 1 ).
      ENDIF.
    ENDIF.
    "**************************************
  ENDLOOP.
  IF old_tot_freight NE new_tot_freight.
    e_cekko-gnetw = e_cekko-gnetw + new_tot_freight.
  ENDIF.

  CLEAR   :old_tot_freight,new_tot_freight.
  REFRESH :tkomv,lt_konv.

  "************************************************
ENDIF.

*$*$-End:-------------------------END ADDED BY GJ ON 31-10-2017--------------------------$*$*

*----------------------------------------------------------------------------------------------*PO Release
DATA : ls_bekpo LIKE LINE OF it_bekpo.

DATA : lv_ebeln  TYPE ekko-ebeln,
       lv_ebeln1 TYPE ekpo-ebeln.

DATA : lt_zmm_bhuvi_po TYPE TABLE OF zmm_bhuvi_po,
       ls_zmm_bhuvi_po TYPE zmm_bhuvi_po.

IF sy-tcode = 'ME28'.

  LOOP AT it_bekpo INTO ls_bekpo.

    SELECT SINGLE ebeln
                  INTO lv_ebeln
                  FROM ekko
                  WHERE ebeln = ls_bekpo-ebeln.
*                  AND   frgke = '2'.

    IF sy-subrc = 0.
      SELECT SINGLE ebeln
                    INTO lv_ebeln1
                    FROM ekpo
                    WHERE ebeln = lv_ebeln
                    AND   bstae = '0004'.

      IF sy-subrc = 0.
        SELECT * FROM zmm_bhuvi_po
                 INTO TABLE lt_zmm_bhuvi_po
                 WHERE ebeln = lv_ebeln1.
      ENDIF.

      LOOP AT lt_zmm_bhuvi_po INTO ls_zmm_bhuvi_po.
        ls_zmm_bhuvi_po-transfer_2_bhuvi = ''.
        MODIFY zmm_bhuvi_po FROM ls_zmm_bhuvi_po.
      ENDLOOP.

    ENDIF.

  ENDLOOP.

ENDIF.


*----------------------------------------------------------------------------------------------*PO Release
