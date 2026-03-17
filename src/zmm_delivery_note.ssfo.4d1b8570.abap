DATA: lv_adrnr TYPE adrnr.

SELECT SINGLE adrnr
        INTO lv_adrnr
        FROM t001w
        WHERE werks = gs_mseg1-werks.

IF sy-subrc = 0.
  SELECT SINGLE a~addrnumber
                a~name1
                a~str_suppl1
                a~str_suppl2
                a~street
                a~city1
                a~post_code1
                b~bezei
                a~country
                a~tel_number
                a~fax_number
                a~extension2
    INTO bf_adrc
    FROM adrc AS a JOIN t005u AS b
    ON ( b~land1 = a~country AND b~bland = a~region )
    WHERE addrnumber = lv_adrnr.

  SELECT SINGLE landx FROM t005t
    INTO bf_adrc-landx
    WHERE spras = sy-langu
      AND land1 = bf_adrc-country.

  SELECT SINGLE smtp_addr FROM adr6
    INTO bf_adrc-smtp_addr
    WHERE addrnumber = lv_adrnr.

ENDIF.














