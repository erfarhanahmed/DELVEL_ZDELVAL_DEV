DATA: l_adrnr TYPE ad_addrnum.
DATA: l_adrnr1 TYPE ad_addrnum.
**
**SELECT SINGLE adrnr FROM kna1
**  INTO l_adrnr
**  WHERE kunnr = is_dlv_delnote-hd_gen-ship_to_party.
**
**IF sy-subrc IS INITIAL.
**  SELECT SINGLE *
**    FROM adrc
**    INTO wa_adrc
**    WHERE addrnumber = l_adrnr.
**ENDIF.
**
**SELECT SINGLE landx
**  FROM t005t
**  INTO g_landx1
**  WHERE land1 = wa_adrc-country
**    AND spras = sy-langu.
**************************************************
SELECT SINGLE kunnr FROM vbpa INTO l_kunnr
                      WHERE vbeln = v_so
                        AND parvw = 'WE'.

  SELECT SINGLE adrnr
    FROM kna1
    INTO l_adrnr1
    WHERE kunnr = l_kunnr.

  IF l_adrnr1 IS NOT INITIAL.
    SELECT SINGLE *
      FROM adrc
      INTO wa_adrc1
      WHERE addrnumber = l_adrnr1.

      SELECT SINGLE *
  FROM t005t
  INTO wa_t005t
  WHERE land1 = wa_adrc1-country
  AND   spras = 'EN'.

SELECT SINGLE *
  FROM t005u
  INTO wa_t005u
  WHERE land1 = wa_adrc1-country
  AND   bland = wa_adrc1-region
  AND   spras = 'EN'.
  ENDIF.
  IF wa_adrc1-fax_number IS NOT INITIAL.
    CONCATENATE 'FAX : ' wa_adrc1-fax_number INTO lv_fax SEPARATED BY ' '..
  ENDIF.

  SELECT SINGLE landx
    FROM t005t
    INTO g_landx1_1
    WHERE land1 = wa_adrc1-country
      AND spras = sy-langu.








