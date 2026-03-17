*&---------------------------------------------------------------------*
*& Report ZMM_GET_DCS_NO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_get_dcs_no.



*&---------------------------------------------------------------------*
*&      FORM  GET_DCS_NO
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->IN_TAB     TEXT
*      -->OUT_TAB    TEXT
*----------------------------------------------------------------------*
FORM get_dcs_no TABLES in_tab STRUCTURE itcsy
out_tab STRUCTURE itcsy.


  DATA:v_challan    TYPE j_1iexchdr-exnum,
       v_docyr      TYPE j_1iexchdr-docyr,
       v_docno      TYPE j_1iexchdr-docno,
       v_rdoc       TYPE j_1iexchdr-rdoc,
       v_dcs_no     TYPE mkpf-xblnr,
       v_dcs_no1    TYPE char20,
       v_zeblen     TYPE likp-zebeln,
       v_matnr      TYPE ekpo-matnr,
       v_maktx      TYPE makt-maktx,
       v_exbas      TYPE j_1iexcdtl-exbas,
       v_new_maktx  TYPE makt-maktx,
       v_exbas_char TYPE char13,
       v_date       TYPE ekko-aedat,
       v_verpr      TYPE mbew-verpr,
       v_verpr_char TYPE char13,
       v_qty        TYPE char13,
       v_matnr1     TYPE mara-matnr.

  READ TABLE in_tab INDEX 1.
  v_challan = in_tab-value.

  READ TABLE in_tab INDEX 2.
  v_docyr = in_tab-value.

  READ TABLE in_tab INDEX 3.
  v_docno = in_tab-value.

*  READ TABLE IN_TAB INDEX 4.
*  REPLACE ALL OCCURRENCES OF ','  IN IN_TAB-VALUE WITH ' '.
*  V_EXBAS = IN_TAB-VALUE.
*  V_EXBAS_CHAR = V_EXBAS.
*  CONDENSE V_EXBAS_CHAR.

  READ TABLE in_tab INDEX 5.
  REPLACE ALL OCCURRENCES OF ',,'  IN in_tab-value WITH ' '.
  v_new_maktx = in_tab-value.
  CONDENSE v_new_maktx.

  READ TABLE in_tab INDEX 6.
  CONDENSE  in_tab-value.
  v_qty = in_tab-value.

  READ TABLE in_tab INDEX 7.
  v_matnr1 = in_tab-value.

  SELECT SINGLE
  rdoc
  FROM j_1iexchdr
  INTO v_rdoc
  WHERE trntyp = '57FC'
    AND docyr = v_docyr
    AND docno = v_docno
    AND exnum = v_challan.

  SELECT SINGLE xblnr
  FROM mkpf
  INTO v_dcs_no
  WHERE mblnr = v_rdoc.

  v_dcs_no1 = v_dcs_no.

  SHIFT v_dcs_no1 LEFT DELETING LEADING '0'.

  SELECT SINGLE zebeln
  FROM likp
  INTO v_zeblen
  WHERE vbeln = v_dcs_no.

  IF sy-subrc = 0.
    SELECT SINGLE aedat
      FROM ekko INTO v_date
      WHERE ebeln = v_zeblen.

    IF sy-subrc = 0.
      SELECT SINGLE verpr
        FROM mbew INTO v_verpr
        WHERE matnr = v_matnr1.

      " If asset : determine price in following way
      "{

      PERFORM determine_asset_price USING v_zeblen v_matnr1 v_docyr v_dcs_no
                                    CHANGING v_verpr.
      "} " ekpo-matnr is nat matching with challan-matnr

      SELECT SINGLE maktx
        FROM makt
        INTO v_maktx
        WHERE matnr = v_matnr1.
    ENDIF.
  ENDIF.

  v_verpr_char = v_verpr.
  v_exbas = v_verpr * v_qty.
  v_exbas_char = v_exbas.
  CONDENSE v_exbas_char.

  READ TABLE out_tab INDEX 1.
  out_tab-value = v_dcs_no1.
  MODIFY out_tab INDEX 1.

  READ TABLE out_tab INDEX 2.
  out_tab-value = v_matnr.
  MODIFY out_tab INDEX 2.

  READ TABLE out_tab INDEX 3.
  out_tab-value = v_maktx.
  MODIFY out_tab INDEX 3.

  READ TABLE out_tab INDEX 4.
  out_tab-value = v_exbas_char.
  MODIFY out_tab INDEX 4.

  READ TABLE out_tab INDEX 5.
  out_tab-value = v_new_maktx.
  MODIFY out_tab INDEX 5.

  READ TABLE out_tab INDEX 6.
  out_tab-value = v_zeblen.
  MODIFY out_tab INDEX 6.

  READ TABLE out_tab INDEX 7.
  out_tab-value = v_date.
  MODIFY out_tab INDEX 7.

  CLEAR:v_challan,v_rdoc,v_dcs_no,v_dcs_no1,v_zeblen,v_matnr,v_maktx,v_docyr,v_docno,v_exbas_char,
        v_exbas,v_new_maktx,v_date.

ENDFORM.                    "GET_DCS_NO
*&---------------------------------------------------------------------*
*&      Form  DETERMINE_ASSET_PRICE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_ZEBELN  text
*      -->P_V_MATNR1  text
*----------------------------------------------------------------------*
FORM determine_asset_price  USING    v_ebeln
                                     v_matnr
                                     v_docyr
                                     v_vbeln
                            CHANGING v_verpr.
  TYPES : BEGIN OF t_anlc,
            anln1 TYPE anln1,     " Main Asset Number
            anln2 TYPE anln2,     " Asset Subnumber
            "urwrt TYPE urwrt,     " Original acquisition value
            "menge TYPE am_menge,  " Quantity
            kansw	TYPE kansw,     "	Cumulative acquisition and production costs
            answl	TYPE answl,     "	Transactions for the year affecting asset values
          END OF t_anlc.

  DATA : lv_ebelp TYPE ebelp,
         lv_bukrs TYPE bukrs,
         lv_knttp	TYPE knttp,     "	Account Assignment Category
         lv_anln1 TYPE anln1,     " Main Asset Number
         lv_anln2 TYPE anln2,     " Asset Subnumber

         wa_anlc  TYPE t_anlc,
         it_lines TYPE TABLE OF tline,
         wa_line  TYPE tline,
         obj_name TYPE tdobname,
         str      TYPE string,
         str1     TYPE string
*         wa_anla_tmp  TYPE t_anla,
*         it_anlc      TYPE TABLE OF t_anlc,

*         asst_rate      TYPE verpr,
*         asst_val       TYPE salk3
         .

  CLEAR : lv_ebelp, lv_anln1, lv_anln2, v_verpr.
  SELECT SINGLE ebelp bukrs knttp
    INTO (lv_ebelp, lv_bukrs, lv_knttp)
    FROM ekpo
    WHERE ebeln = v_ebeln
      AND matnr = v_matnr.
  IF sy-subrc = 0.
    IF lv_knttp	= 'A'.
      SELECT SINGLE anln1 anln2
          INTO (lv_anln1, lv_anln2)
          FROM ekkn
          WHERE ebeln = v_ebeln
            AND ebelp = lv_ebelp
            AND zekkn = '1'.
      IF sy-subrc = 0.
        IF lv_anln2 IS INITIAL.
          lv_anln2 = '0000'.
        ENDIF.
        SELECT SINGLE
               anln1
               anln2
               kansw
               answl
          INTO wa_anlc
          FROM anlc
          WHERE bukrs = lv_bukrs
            AND anln1 = lv_anln1
            AND anln2 = lv_anln2
            AND gjahr = v_docyr
            AND afabe = '1'.
        IF sy-subrc = 0.
          v_verpr = wa_anlc-kansw + wa_anlc-answl.
          CLEAR : wa_anlc.
        ENDIF.
      ENDIF.
    ELSEIF lv_knttp = 'K'.
      CLEAR obj_name.
      obj_name = v_vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          id                      = '0002'
          language                = sy-langu
          name                    = obj_name
          object                  = 'VBBK'
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*       IMPORTING
*         HEADER                  =
        TABLES
          lines                   = it_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc = 0.
        str1 = '([0-9|,]+[/.][0-9]{2})'.
        LOOP AT it_lines INTO wa_line WHERE tdline IS NOT INITIAL.
          CLEAR str.
          FIND REGEX str1 IN wa_line-tdline SUBMATCHES str.
          IF str IS INITIAL.
            FIND REGEX '([0-9|,]+)' IN wa_line-tdline SUBMATCHES str.
            IF str IS NOT INITIAL.
              CONCATENATE str '.00' INTO str.
            ENDIF.
          ENDIF.
          IF str IS NOT INITIAL.
            v_verpr = str.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
  CLEAR : lv_anln1, lv_anln2.
ENDFORM.                    " DETERMINE_ASSET_PRICE
