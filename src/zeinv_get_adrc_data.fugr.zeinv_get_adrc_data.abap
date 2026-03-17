FUNCTION zeinv_get_adrc_data.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_VBRP) TYPE  ZEINV_VBRP
*"     REFERENCE(I_LIKP) TYPE  ZEINV_LIKP
*"     REFERENCE(I_INVTYP) TYPE  CHAR3
*"  EXPORTING
*"     REFERENCE(E_SEL_ADDR) TYPE  ZEINV_ADRC
*"     REFERENCE(E_DIS_ADDR) TYPE  ZEINV_ADRC
*"     REFERENCE(E_BUY_ADDR) TYPE  ZEINV_ADRC
*"     REFERENCE(E_SHP_ADDR) TYPE  ZEINV_ADRC
*"----------------------------------------------------------------------
  DATA :lv_gstin TYPE kna1-stcd3.
  DATA: lv_kunag TYPE vbrk-kunag.
  SELECT SINGLE adrnr
    FROM t001w
    INTO @DATA(lv_adrnr)
    WHERE werks = @i_vbrp-werks.

  IF NOT lv_adrnr IS INITIAL.
    SELECT SINGLE addrnumber
           name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
           location
           country
           region
           sort1
           mc_city1
           tel_number
      FROM adrc
      INTO e_sel_addr
      WHERE addrnumber EQ lv_adrnr.

    SELECT SINGLE bezei FROM t005u INTO e_sel_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ e_sel_addr-region.
    SELECT SINGLE legal_state_code FROM j_1istatecdm INTO e_sel_addr-region WHERE std_state_code EQ e_sel_addr-region .

  ENDIF.

  CLEAR: lv_adrnr, lv_gstin.
IF i_invtyp = 'SER'.
 SELECT SINGLE kunag INTO lv_kunag FROM vbrk WHERE vbeln = i_vbrp-vbeln.

 SELECT SINGLE adrnr stcd3
    FROM kna1
    INTO ( lv_adrnr, lv_gstin )
    WHERE kunnr = lv_kunag.

  IF NOT lv_adrnr IS INITIAL.
    SELECT SINGLE addrnumber
           name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
           location
           country
           region
           sort1
           mc_city1
           tel_number
      FROM adrc
      INTO e_buy_addr
      WHERE addrnumber EQ lv_adrnr.

    SELECT SINGLE bezei FROM t005u INTO e_buy_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ e_buy_addr-region .
    SELECT SINGLE legal_state_code FROM j_1istatecdm INTO e_buy_addr-region WHERE std_state_code EQ e_buy_addr-region .

    e_buy_addr-gstin = lv_gstin.
   ENDIF.
ELSE.
  SELECT SINGLE adrnr stcd3
    FROM kna1
    INTO ( lv_adrnr, lv_gstin )
    WHERE kunnr = i_likp-kunag.

  IF NOT lv_adrnr IS INITIAL.
    SELECT SINGLE addrnumber
           name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
           location
           country
           region
           sort1
           mc_city1
           tel_number
      FROM adrc
      INTO e_buy_addr
      WHERE addrnumber EQ lv_adrnr.

    SELECT SINGLE bezei FROM t005u INTO e_buy_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ e_buy_addr-region .
    SELECT SINGLE legal_state_code FROM j_1istatecdm INTO e_buy_addr-region WHERE std_state_code EQ e_buy_addr-region .

    e_buy_addr-gstin = lv_gstin.
  ENDIF.

ENDIF.
  CLEAR lv_adrnr.

  CASE i_invtyp.
    WHEN 'DIS'.
      SELECT SINGLE adrnr
        FROM t001w
        INTO lv_adrnr
        WHERE werks = i_likp-vstel.

      IF NOT lv_adrnr IS INITIAL.
        SELECT SINGLE addrnumber
            name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
           location
           country
           region
           sort1
           mc_city1
           tel_number
          FROM adrc
          INTO e_dis_addr
          WHERE addrnumber EQ lv_adrnr.

          SELECT SINGLE bezei FROM t005u INTO e_dis_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ e_dis_addr-region .
          SELECT SINGLE legal_state_code FROM j_1istatecdm INTO e_dis_addr-region WHERE std_state_code EQ e_dis_addr-region .

      ENDIF.

    WHEN 'SHP'.
      SELECT SINGLE adrnr stcd3
        FROM kna1
        INTO ( lv_adrnr, lv_gstin )
        WHERE kunnr = i_likp-kunnr.

      IF NOT lv_adrnr IS INITIAL.
        SELECT SINGLE addrnumber
            name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
           location
           country
           region
           sort1
           mc_city1
           tel_number
          FROM adrc
          INTO e_shp_addr
          WHERE addrnumber EQ lv_adrnr.

        SELECT SINGLE bezei FROM t005u INTO e_shp_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ e_shp_addr-region .
        SELECT SINGLE legal_state_code FROM j_1istatecdm INTO e_shp_addr-region WHERE std_state_code EQ e_shp_addr-region .

        e_shp_addr-gstin = lv_gstin.
      ENDIF.

    WHEN 'CMB'.
      SELECT SINGLE adrnr
        FROM t001w
        INTO lv_adrnr
        WHERE werks = i_likp-vstel.

      IF NOT lv_adrnr IS INITIAL.
        SELECT SINGLE addrnumber
           name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
           location
           country
           region
           sort1
           mc_city1
           tel_number
          FROM adrc
          INTO e_dis_addr
          WHERE addrnumber EQ lv_adrnr.

        SELECT SINGLE legal_state_code FROM j_1istatecdm INTO e_sel_addr-region WHERE std_state_code EQ e_sel_addr-region .
        SELECT SINGLE bezei FROM t005u INTO e_sel_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ e_sel_addr-region .
      ENDIF.

      CLEAR lv_adrnr.

      SELECT SINGLE adrnr
        FROM kna1
        INTO lv_adrnr
        WHERE kunnr = i_likp-kunnr.

      IF NOT lv_adrnr IS INITIAL.
        SELECT SINGLE addrnumber
           name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
           location
           country
           region
           sort1
           mc_city1
           tel_number
          FROM adrc
          INTO e_shp_addr
          WHERE addrnumber EQ lv_adrnr.

        SELECT SINGLE legal_state_code FROM j_1istatecdm INTO e_sel_addr-region WHERE std_state_code EQ e_sel_addr-region .
        SELECT SINGLE bezei FROM t005u INTO e_sel_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ e_sel_addr-region .

      ENDIF.
  ENDCASE.
  CLEAR: lv_adrnr, lv_gstin.
























ENDFUNCTION.
