*BREAK-POINT.

DATA : OBJNAME TYPE TDOBNAME.
*DATA:
*  LT_J_1IG_SUBCON TYPE TT_J_1IG_SUBCON,
*  LS_J_1IG_SUBCON TYPE T_J_1IG_SUBCON.

*SELECT BUKRS
*       MBLNR
*       MJAHR
*       ZEILE
*       CHLN_INV
*       BWART     "added by pankaj 12.10.2021
*       ITEM
*       MENGE
*       MEINS
*       MATNR
*  FROM J_1IG_SUBCON
*  INTO TABLE GT_J_1IG_SUBCON
*  FOR ALL ENTRIES IN GT_ITEM
*  WHERE CHLN_INV = GT_ITEM-VBELN.


*IF NOT GT_J_1IG_SUBCON IS INITIAL.
*  SELECT MBLNR
*         MJAHR
*         ZEILE
*         BWART    "added by pankaj 12.10.2021
*         MATNR    "added by pankaj 12.10.2021
*         EBELN
*         EBELP
*    FROM MSEG
*    INTO TABLE GT_MAT_DOC
*    FOR ALL ENTRIES IN GT_J_1IG_SUBCON
*    WHERE MBLNR = GT_J_1IG_SUBCON-MBLNR
*    AND   MJAHR = GT_J_1IG_SUBCON-MJAHR
*    AND   ZEILE = GT_J_1IG_SUBCON-ZEILE
*    "code added by panka 12.10.2021
*    AND   BWART = '541'  "Commented by Pankaj 10.11.21 '543'   "gt_j_1ig_subcon-bwart
*    AND   MATNR = GT_J_1IG_SUBCON-MATNR.
*
*  " added by pankaj 13.10.2021
*  SORT GT_MAT_DOC BY MBLNR DESCENDING.
*  SORT GT_MAT_DOC BY ZEILE DESCENDING.
*  SORT GT_MAT_DOC BY EBELN ASCENDING.

**  SELECT ebeln
**         ebelp
**         TXZ01
**         matnr
**         menge
**         meins
**         mwskz
**         werks
**         netwr
**    FROM ekpo
**    INTO TABLE gt_purchasing
**    FOR ALL ENTRIES IN gt_mat_doc
**    WHERE ebeln = gt_mat_doc-ebeln
**    AND   ebelp = gt_mat_doc-ebelp.
.
  SELECT EBELN
         EBELP
         TXZ01
         MATNR
         MENGE
         MEINS
         MWSKZ
         WERKS
         NETWR
    FROM EKPO
    INTO TABLE GT_PURCHASING
    FOR ALL ENTRIES IN GT_MSEG
    WHERE EBELN = GT_MSEG-EBELN
    AND   EBELP = GT_MSEG-EBELP.

*BREAK-POINT.
LOOP AT GT_PURCHASING INTO GS_PURCHASING.
wa_final-meins   = GS_PURCHASING-MEINS.
  SELECT SINGLE MATNR
  WERKS
  STEUC
  DISPO
  FROM MARC
    INTO LS_MARC
  WHERE MATNR = GS_PURCHASING-MATNR AND
  WERKS = GS_PURCHASING-WERKS.

  SELECT SINGLE EBELN
  EBELP
  KNTTP
  FROM EKPO
  INTO LS_EKPO
  WHERE EBELN = GS_PURCHASING-EBELN AND
  EBELP = GS_PURCHASING-EBELP .
    "AND KNTTP = 'E'.

*  IF SY-SUBRC = 0 .
    GV_KNTTP = LS_EKPO-KNTTP.
    SELECT SINGLE MATNR
                  SPRAS
                  MAKTX
                  FROM MAKT
                  INTO LS_MAKT
                  WHERE MATNR = GS_PURCHASING-MATNR.

    SELECT SINGLE EBELN
                  EBELP
                  ZEKKN
                  VBELN
                  VBELP
              FROM EKKN
              INTO LS_EKKN
              WHERE EBELN = GS_PURCHASING-EBELN  AND
              EBELP = GS_PURCHASING-EBELP.

    SELECT SINGLE  VKBUR FROM VBAK INTO @DATA(LV_VKBUR)
      WHERE VBELN = @LS_EKKN-VBELN.

    SELECT SINGLE BEZEI FROM TVKBT INTO LV_BRANCH
      WHERE VKBUR = LV_VKBUR.

**      SELECT SINGLE MATNR
**      WERKS
**      dispo
**      FROM marc
**      INTO ls_marc
**      WHERE matnr = GS_PURCHASING-matnr AND
**      werks = GS_PURCHASING-werks.

    SELECT SINGLE WRKST
    INTO GV_WRKST
    FROM MARA
    WHERE MATNR = GS_PURCHASING-MATNR .
*
    SELECT SINGLE VBELN
    POSNR
    ZCE
    ZGAD
    FROM VBAP
    INTO LS_VBAP
    WHERE VBELN = LS_EKKN-VBELN.
    IF LS_VBAP-ZCE = 'X'.
      GV_PC = 'CE'.
    ENDIF.
*BREAK-POINT.
    gv_rate = gs_purchasing-netwr / gs_purchasing-menge.
*
    IF LS_VBAP-ZGAD = '1'.
      GV_ZGAD = 'Reference'.
    ELSEIF LS_VBAP-ZGAD = '2'.
      GV_ZGAD = 'Approved'.
    ELSEIF LS_VBAP-ZGAD = '3'.
      GV_ZGAD = 'Standard'.
    ENDIF.


    CLEAR OBJNAME.
    OBJNAME = LS_EKKN-VBELN.
    PERFORM GET_TEXT USING OBJNAME 'VBBK' 'Z038' 'E' CHANGING GV_TEXT_LD.
*
    CLEAR OBJNAME.
    OBJNAME = LS_EKKN-VBELN.
    PERFORM GET_TEXT USING OBJNAME 'VBBK' 'Z039' 'E' CHANGING GV_TEXT_TAG.


    CLEAR OBJNAME.
    OBJNAME = LS_EKKN-VBELN.
    PERFORM GET_TEXT USING OBJNAME 'VBBK' 'Z999' 'E' CHANGING GV_TEXT_TPI.

    CLEAR OBJNAME.
    OBJNAME = GS_PURCHASING-MATNR.
    PERFORM GET_TEXT USING OBJNAME 'MATERIAL' 'GRUN' 'S' CHANGING GV_TEXT_NOTE.


*  ENDIF.
ENDLOOP.
