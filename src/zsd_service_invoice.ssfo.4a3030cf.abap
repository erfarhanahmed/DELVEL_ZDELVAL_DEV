
SELECT  vbeln
        werks
        fkimg
        FROM vbrp
        INTO CORRESPONDING FIELDS OF TABLE  it_vbrp
        WHERE vbeln     = is_bil_invoice-hd_gen-bil_number.

READ TABLE it_vbrp INTO wa_vbrp WITH KEY
              vbeln = is_bil_invoice-hd_gen-bil_number.

v_fkimg = wa_vbrp-fkimg.


SELECT werks
       adrnr
       FROM t001w
       INTO CORRESPONDING FIELDS OF TABLE it_t001w
       WHERE werks = wa_vbrp-werks.

READ TABLE it_t001w INTO wa_t001w WITH KEY
              werks = wa_vbrp-werks.

IF NOT it_t001w IS INITIAL.
*  SELECT ADDRNUMBER
*         NAME1
*         NAME_CO
*         CITY1
*         POST_CODE1
*         STREET
*         STR_SUPPL1
*         STR_SUPPL2
*         COUNTRY
*         TEL_NUMBER
*         FAX_NUMBER
  SELECT SINGLE * FROM adrc INTO wa_adrc
*         INTO CORRESPONDING FIELDS OF TABLE IT_ADRC
         WHERE addrnumber = wa_t001w-adrnr.

  SELECT SINGLE * FROM t005t
    INTO gs_t005t
    WHERE spras = sy-langu
      AND land1 = wa_adrc-country.

  SELECT SINGLE * FROM adr6
    INTO gs_adr6
    WHERE addrnumber = wa_t001w-adrnr.  "lv_adrnr.

  SELECT SINGLE * FROM adrct
    INTO gs_adrct
    WHERE addrnumber = wa_t001w-adrnr.

*  READ TABLE IT_ADRC INTO WA_ADRC WITH KEY
*            ADDRNUMBER = WA_T001W-ADRNR.

ENDIF.

IF NOT it_vbrp IS INITIAL.

  SELECT bukrs
         werks
         j_1ipanno
         j_1isern
         FROM j_1imocomp
         INTO CORRESPONDING FIELDS OF TABLE it_j_1imocomp
         WHERE bukrs = is_bil_invoice-hd_org-comp_code
         AND   werks = wa_vbrp-werks.
  READ TABLE it_j_1imocomp INTO    wa_j_1imocomp INDEX 1.
ENDIF.
