DATA:
  lv_adrnr  TYPE adrc-addrnumber,
  ls_item   TYPE t_item,
  lv_branch TYPE t001w-j_1bbranch.

READ TABLE gt_item INTO ls_item INDEX 1.

SELECT SINGLE adrnr
              j_1bbranch
        FROM  t001w
        INTO  (lv_adrnr,lv_branch)
        WHERE werks = ls_item-werks.

SELECT SINGLE gstin
        FROM  j_1bbranch
        INTO  gv_p_gst
        WHERE bukrs = ls_bil_invoice-hd_org-comp_code
         AND  branch = lv_branch.
IF gv_p_gst is INITIAL.
  gv_p_gst = '27AACCD2898L1Z4'.
ENDIF.
SELECT SINGLE *
         FROM adrc
         INTO gs_p_adrc
         WHERE addrnumber = lv_adrnr.

SELECT SINGLE landx
         FROM t005t
         INTO gv_p_country
         WHERE spras = sy-langu
           AND land1 = gs_p_adrc-country.

SELECT SINGLE smtp_addr
         FROM adr6
         INTO gv_email
         WHERE  addrnumber = lv_adrnr
         AND    CONSNUMBER = '2'.         "ADDED BY GANGA

SELECT SINGLE bezei
         FROM t005u
         INTO gv_p_state
         WHERE spras = sy-langu
           AND land1 = gs_p_adrc-country
           AND bland = gs_p_adrc-region.

IF NOT gv_p_state IS INITIAL.
  SELECT SINGLE gst_region
          FROM  zgst_region
          INTO  gv_gst_reg
          WHERE region = gs_p_adrc-region.
ENDIF.

SELECT SINGLE remark FROM adrct
    INTO gv_cin
    WHERE addrnumber = gs_p_adrc-addrnumber.






