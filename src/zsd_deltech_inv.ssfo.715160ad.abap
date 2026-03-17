*DATA:  l_country TYPE land1.
*DATA: lv_adrnr TYPE kna1-adrnr,
*      lv_kunnr TYPE kna1-kunnr.
*
*SELECT SINGLE kunnr FROM likp
*  INTO lv_kunnr
*  WHERE vbeln = is_bil_invoice-hd_ref-deliv_numb.
*
*IF sy-subrc = 0.
*  SELECT SINGLE adrnr FROM kna1
*  INTO lv_adrnr
*  WHERE kunnr = lv_kunnr.
*ENDIF.
*
*IF sy-subrc = 0.
*  SELECT SINGLE * FROM adrc INTO gs_ku_adrc
*    WHERE addrnumber = lv_adrnr.
*
*  SELECT SINGLE
*          name1
*          street
*          sort1
*          city1
*          post_code1
*          tel_number
*          fax_number
*          country
*     FROM adrc
*     INTO  (g_name,
*            g_street,
*            g_sort1,
*            g_city,
*            g_post_code,
*            g_tel_number,
*            g_fax_number,
*            l_country)
*  WHERE addrnumber = lv_adrnr.
*ENDIF.
*IF sy-subrc = 0.
*  SELECT SINGLE landx FROM t005t INTO gv_ku_landx
*    WHERE land1 = gs_ku_adrc-country
*      AND spras = 'EN'.
*ENDIF.
