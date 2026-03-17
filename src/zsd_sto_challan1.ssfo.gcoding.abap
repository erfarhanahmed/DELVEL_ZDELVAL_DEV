*BREAK fujiabap.
*BREAK-POINT.
SELECT vbeln
       posnr
       vgbel
       vgpos
       matnr
       arktx
       fkimg
       vrkme
       netwr
       werks
       wavwr
  FROM vbrp
  INTO TABLE gt_item
  WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.

*IF gt_item IS NOT INITIAL.
*SELECT mblnr
*       MJAHR
*       ZEILE
*       BWART
*       XAUTO
*       MATNR
*       WERKS
*       MENGE
*       MEINS
*       BUDAT_MKPF
*       EBELN
*       EBELP
*       LGORT
*  FROM mseg INTO TABLE IT_MSEG
*  where mblnr = gs_item-vgbel.

*BREAK-POINT.

*SELECT
*   VBELN
*   EWAY_BILL FROM ZEWAY_NUMBER
*   INTO TABLE IT_ZEWAY
*   FOR ALL ENTRIES IN GT_ITEM
*   WHERE VBELN = GT_ITEM-VBELN.
*
*   SELECT
*       VBELN
*       VEHICAL_NO
*       TRANS_NAME
*       VEHICAL_TYPE FROM ZEWAY_BILL
*       INTO TABLE IT_ZEWAY_BILL
*       FOR ALL ENTRIES IN IT_ZEWAY
*       WHERE VBELN = IT_ZEWAY-VBELN.
*
*ENDIF.
*


IF NOT gt_item IS INITIAL.
  SELECT vbeln
         knumv
         FKDAT
    FROM vbrk INTO TABLE it_vbrk
         FOR ALL ENTRIES IN gt_item
         WHERE vbeln = gt_item-vbeln.
  SELECT matnr
         werks
         steuc
         dispo
    FROM marc
    INTO TABLE gt_marc
    FOR ALL ENTRIES IN gt_item
    WHERE matnr = gt_item-matnr
      AND werks = gt_item-werks.
ENDIF.
IF it_vbrk IS NOT INITIAL.
SELECT knumv
       kposn
       kschl
       kawrt
       kbetr
       kwert FROM konv INTO TABLE it_konv
       FOR ALL ENTRIES IN it_vbrk
       WHERE knumv = it_vbrk-knumv.
********ADDED BY PRIMUS JYOTI ON 01.12.2023*******
   SELECT KSCHL
         KUNNR
         MATNR
         DATBI
         DATAB
         KNUMH
    FROM A005
    INTO TABLE tt_A005
    FOR ALL ENTRIES IN gt_item
    WHERE matnr = gt_item-matnr
    AND KSCHL = 'ZSTO'
    and DATBI = '99991231'.
ENDIF.
********ADDED BY PRIMUS JYOTI ON 01.12.2023*******
IF tt_A005 IS NOT INITIAL.

  SELECT KNUMH
         kopos
         KSCHL
         KBETR
    FROM KONP
    INTO TABLE TT_KONP
    FOR ALL ENTRIES IN tt_A005
    WHERE KNUMH = tt_A005-KNUMH.

ENDIF.
**************************************************


LOOP AT gt_item INTO GS_ITEM.
wa_final-vbeln   = gs_item-vbeln.
wa_final-posnr   = gs_item-posnr.
wa_final-vgbel   = gs_item-vgbel.
wa_final-vgpos   = gs_item-vgpos.
wa_final-matnr   = gs_item-matnr.
wa_final-arktx   = gs_item-arktx.
wa_final-fkimg   = gs_item-fkimg.
wa_final-vrkme   = gs_item-vrkme.
wa_final-netwr   = gs_item-netwr.
wa_final-werks   = gs_item-werks.
wa_final-WAVWR   = gs_item-WAVWR.
wa_final-RATE   =  gs_item-WAVWR / gs_item-fkimg.
wa_final-VALUE   = wa_final-RATE * gs_item-fkimg.

READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_final-vbeln.
*BREAK-POINT.
READ TABLE IT_MSEG INTO WA_MSEG WITH  KEY MBLNR = GS_ITEM-VGBEL.
IF sy-subrc = 0.
wa_final-mblnr = wa_mseg-mblnr.
wa_final-budat_mkpf = wa_mseg-budat_mkpf.
ENDIF.

READ TABLE IT_ZEWAY_BILL INTO WA_ZEWAY_BILL WITH KEY VBELN = GS_ITEM-VBELN.
IF sy-subrc = 0.
wa_final-TRANS_NAME = WA_ZEWAY_BILL-TRANS_NAME.
wa_final-VEHICAL_NO = WA_ZEWAY_BILL-VEHICAL_NO.
wa_final-VEHICAL_TYPE = WA_ZEWAY_BILL-VEHICAL_TYPE.
ENDIF.
READ TABLE IT_ZEWAY INTO WA_ZEWAY WITH KEY VBELN = WA_ZEWAY_BILL-VBELN.
IF sy-subrc = 0.
wa_final-EWAY_BILL = WA_ZEWAY-EWAY_BILL.

ENDIF.

LOOP AT it_konv INTO wa_konv WHERE knumv = wa_vbrk-knumv AND kposn = wa_final-posnr.
CASE wa_konv-kschl.
  WHEN 'JOCG'.
    wa_final-cgst = wa_konv-kbetr / 10.
    wa_final-cgst_amt = wa_konv-kwert.
  WHEN 'JOSG'.
    wa_final-sgst = wa_konv-kbetr / 10.
    wa_final-sgst_amt = wa_konv-kwert.
  WHEN 'JOIG'.
    wa_final-igst = wa_konv-kbetr / 10.
    wa_final-igst_amt = wa_konv-kwert.
  WHEN 'VPRS'.
   wa_final-kwert = wa_konv-kwert.
*   wa_final-tax_amt = wa_konv-kwert.
ENDCASE.
ENDLOOP.
**********ADDED BY PRIMUS JYOTI ON 01.12.2023***********************
READ TABLE TT_A005 INTO WA_A005 WITH KEY MATNR = wa_final-matnr.
*    IF WA_VBRK-FKDAT EQ WA_A005-DATAB.
      WA_FINAL-KNUMH = WA_A005-KNUMH.
*    ENDIF.

READ TABLE TT_KONP INTO WA_KONP WITH  KEY knumH =  WA_FINAL-KNUMH.
*                             AND kposn = wa_final-posnr.

  IF  wa_konp-kschl = 'ZSTO'.
    wa_final-RATE = WA_KONP-KBETR.
    wa_final-VALUE   =  wa_final-RATE  *  gs_item-fkimg.

  ENDIF.
********************************************************

DATA : lv_name1   TYPE thead-tdname,
        txt1      TYPE STRING.
lv_name1 = wa_final-matnr.
  CALL FUNCTION 'READ_TEXT'
  EXPORTING
*     CLIENT                  = SY-MANDT
    ID                      = 'GRUN'
    LANGUAGE                = SY-LANGU
    name                    = LV_NAME1
    object                  = 'MATERIAL'
*     ARCHIVE_HANDLE          = 0
*     LOCAL_CAT               = ' '
*   IMPORTING
*     HEADER                  =
  TABLES
    LINES                   = IT_LINES2
  EXCEPTIONS
    ID                      = 1
    LANGUAGE                = 2
    name                    = 3
    not_found               = 4
    object                  = 5
    reference_check         = 6
    wrong_access_to_archive = 7
    OTHERS                  = 8.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    IF sy-tfill <> 0.
      LOOP AT IT_LINES2 INTO WA_LINES2.
        CONCATENATE '' WA_LINES2-tdline INTO wa_final-arktx.
      ENDLOOP.
    ENDIF.
  ENDIF.
********************************************************


APPEND wa_final TO it_final.
CLEAR wa_final.
ENDLOOP.
