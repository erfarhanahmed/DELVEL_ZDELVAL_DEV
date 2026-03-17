DATA:
  lv_kunnr  TYPE kna1-kunnr,
  lv_adrnr  TYPE kna1-adrnr,
  ls_hd_adr TYPE lbbil_hd_adr.
*  lv_kunag type kna1-kunag.   "added by aakashk

*****Customer
SELECT SINGLE adrnr
              stcd3
        FROM  kna1
        INTO (lv_adrnr,gv_gst)
        WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.



SELECT SINGLE *
       FROM adrc
       INTO gs_adrc
       WHERE addrnumber = lv_adrnr.

SELECT SINGLE landx
         FROM t005t
         INTO gv_country
         WHERE land1 = gs_adrc-country
          AND  spras = sy-langu.

SELECT SINGLE bezei
         FROM t005u
         INTO gv_reg
         WHERE land1 = gs_adrc-country
          AND  bland = gs_adrc-region
          AND  spras = sy-langu.

*BREAK primus.
SELECT SINGLE gst_region
       FROM   zgst_region
       INTO   gv_gst_reg
       WHERE  bezei = gv_reg.

SELECT SINGLE smtp_addr
        FROM  adr6
        INTO  gv_email
        WHERE addrnumber = lv_adrnr.


**lv_kunnr = ls_bil_invoice-hd_gen-ship_to_party.
**IF lv_kunnr IS INITIAL.
**  lv_kunnr = ls_bil_invoice-hd_gen-sold_to_party.
**ENDIF.
* get customer adress number
SELECT SINGLE adrnr FROM vbpa INTO lv_adrnr
                      WHERE vbeln = LS_BIL_INVOICE-hd_ref-order_numb
                        AND parvw = 'WE'.
*****Consignee
SELECT SINGLE kunnr
              stcd3
        FROM  kna1
        INTO (lv_kunnr,gv_gst_c)
        WHERE adrnr = lv_adrnr.

SELECT SINGLE *
       FROM adrc
       INTO gs_adrc_c
       WHERE addrnumber = lv_adrnr.

SELECT SINGLE landx
         FROM t005t
         INTO gv_country_c
         WHERE land1 = gs_adrc_c-country
          AND  spras = sy-langu.

SELECT SINGLE bezei
         FROM t005u
         INTO gv_reg_c
         WHERE land1 = gs_adrc_c-country
          AND  bland = gs_adrc_c-region
          AND  spras = sy-langu.

SELECT SINGLE gst_region
       FROM   zgst_region
       INTO   gv_gst_reg_c
       WHERE  bezei = gv_reg_c.



SELECT SINGLE smtp_addr
        FROM  adr6
        INTO  gv_email_c
        WHERE addrnumber = lv_adrnr.

DATA: lv_name   TYPE thead-tdname.
  CLEAR: lv_lines,LINES,lv_name.
      REFRESH lv_lines.
      lv_name = LS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z030'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE lv_lines INTO LINES INDEX 1.

"added by aakashk 13.08.2024
data : lv_ship_to_party type vbrk-kunag.

select single kunag
from vbrk into lv_ship_to_party
WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.

*if LS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY = '0000300000'.
*IF LS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY = lv_ship_to_party AND
*   ls_bil_invoice-hd_gen-BIL_DATE GE '20240812'.


*   gs_adrc-street = '6535 Industrial Dr, Ste 103'.
**   GS_ADRC_C-STREET = '6535 Industrial Dr, Ste 103'.
*
* IF  ls_bil_invoice-hd_gen-BIL_DATE GE '20240812'.
*  SELECT SINGLE str_suppl1
*      INTO gs_adrc_C-STR_SUPPL1
*      FROM adrc
*      WHERE addrnumber = lv_ship_to_party.
*  ENDIF.
*   ELSE.
*       SELECT SINGLE str_suppl1
*      INTO gs_adrc_C-STR_SUPPL1
*      FROM adrc
*      WHERE addrnumber = lv_ship_to_party.
**     gs_adrc_c-street = 'WEST COUNTY ROAD 30'.
*  ENDIF.
*ENDIF.

*************************************************************
*BREAK PRIMUSABAP.
  SELECT SINGLE KUNNR
       FROM VBPA INTO @DATA(WA_VBPA)
       WHERE VBELN = @ls_bil_invoice-hd_gen-bil_number
       AND   PARVW = 'WE'.
if LS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY  = '0000300000'.
IF LS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY  = lv_ship_to_party AND
   ls_bil_invoice-hd_gen-BIL_DATE GE '20240812'.

   gs_adrc-street = '6535 Industrial Dr, Ste 103'.
   GS_ADRC_C-STREET = '6535 Industrial Dr, Ste 103'.
*   gs_adrc_C-STR_SUPPL1 = '6535 Industrial Dr, Ste 103'.
   ENDIF.

   IF WA_VBPA NE LS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY.
     GS_ADRC_C-STREET = ' '.
   ENDIF.

ENDIF.
**********************************************************

*ENDIF.
*endif.
"endadd.

*if LS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY = '0000300000'.
*IF LS_BIL_INVOICE-HD_GEN-SOLD_TO_PARTY = lv_ship_to_party AND
*   ls_bil_invoice-hd_gen-BIL_DATE GE '20240812'.
*
*   gs_adrc-street = '6535 Industrial Dr, Ste 103'.
*   gs_adrc-str_suppl1 = '6535 Industrial Dr, Ste 103'.
**   ELSE.
**     gs_adrc_str_suppl1 = 'WEST COUNTY ROAD 30'.
*  ENDIF.
*ENDIF.










