LVSHIPTO  = ':ـِل ةنيفس نتم ىلع رفاس'.
*BREAK-POINT.

*LVSHIPTO = REVERSE( LVSHIPTO1 ).

gv_address1  = 'عنوان:'.

gv_address = REVERSE( GV_ADDRESS1 ).

gv_VAT1  = 'رقم ضريبة القيمة المضافة:'.

gv_VAT = REVERSE( GV_VAT1 ).

DATA:
  lv_kunnrc TYPE kna1-kunnr,
  lv_adrnrc TYPE kna1-adrnr.
*
*
*
****lv_kunnr = ls_bil_invoice-hd_gen-ship_to_party.
****IF lv_kunnr IS INITIAL.
****  lv_kunnr = ls_bil_invoice-hd_gen-sold_to_party.
****ENDIF.
SELECT SINGLE adrnr
       FROM   vbpa
       INTO   lv_adrnrc
       WHERE vbeln = LS_BIL_INVOICE-hd_ref-order_numb
       AND   parvw = 'WE'.
*
******Consignee
SELECT SINGLE kunnr
              stcd3
        FROM  kna1
        INTO (lv_kunnrc,gv_gst_c)
        WHERE adrnr = lv_adrnrc.

SELECT SINGLE *
       FROM adrc
       INTO gs_adrc_c
       WHERE addrnumber = lv_adrnrc.

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
        WHERE addrnumber = lv_adrnrc.


CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    INPUT         = gv_gst_reg
 IMPORTING
   OUTPUT         = gv_gst_reg
          .
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    INPUT         = gv_gst_reg_c
 IMPORTING
   OUTPUT         = gv_gst_reg_c
          .

gv_gst_reg_c = gv_gst_reg_c+1(2).

gv_gst_reg = gv_gst_reg+1(2).

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
