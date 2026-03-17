
DATA:
  lv_kunnrc TYPE kna1-kunnr,
  lv_adrnrc TYPE kna1-adrnr.

*****Customer
*SELECT SINGLE adrnr
*              stcd3
*        FROM  kna1
*        INTO (lv_adrnr,gv_gst)
*        WHERE kunnr = ls_bil_invoice-hd_gen-sold_to_party.

SELECT SINGLE adrnr
       FROM   vbpa
       INTO   lv_adrnrc
       WHERE vbeln = LS_BIL_INVOICE-hd_ref-order_numb
       AND   parvw = 'WE'.

*break primus.
SELECT SINGLE *
       FROM adrc
       INTO GS_ADRC_AA
       WHERE addrnumber = lv_adrnrc AND NATION ='A'.
*BREAK-POINT.
DATA : avs_cname1 TYPE adrc-name1.

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = GS_ADRC_AA-NAME1
    LANG            = 'A'
 IMPORTING
   RSTRING         = avs_cname1
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
ARCNAMES = avs_cname1.

DATA : avs_cname2 TYPE adrc-name2.

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = GS_ADRC_AA-NAME2
    LANG            = 'A'
 IMPORTING
   RSTRING         = avs_cname2
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
ARBNUMBERS = avs_cname2.

DATA :  avs_street  TYPE adrc-street.

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = GS_ADRC_AA-STREET
    LANG            = 'A'
 IMPORTING
   RSTRING         = avs_street
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
ARBSTREETS = avs_street.

DATA :  avs_adnumber  TYPE adrc-ADDRNUMBER.

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = GS_ADRC_AA-ADDRNUMBER
    LANG            = 'A'
 IMPORTING
   RSTRING         = avs_adnumber
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
ARADDNUMBERS = avs_adnumber.


DATA :  avs_district  TYPE adrc-ADDRNUMBER.

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = GS_ADRC_AA-ADDRNUMBER
    LANG            = 'A'
 IMPORTING
   RSTRING         = avs_district
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
ARDISTRICTS = avs_adnumber.

DATA :  avs_city  TYPE adrc-CITY1.

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = GS_ADRC_AA-CITY1
    LANG            = 'A'
 IMPORTING
   RSTRING         = avs_city
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
ARCITYS = avs_city.

*DATA :  av_country  TYPE STRING.
*
*
*SELECT SINGLE landx
*         FROM t005t
*         INTO GV_COUNTRY_A
*         WHERE land1 = 'SA'
*          AND  spras = SY-LANGU.
*
*CALL FUNCTION 'STRING_REVERSE'
*  EXPORTING
*    STRING          = gs_adrc_a-CITY1
*    LANG            = 'A'
* IMPORTING
*   RSTRING         = av_country
** EXCEPTIONS
**   TOO_SMALL       = 1
**   OTHERS          = 2
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.
*ARCOUNTRY = av_country.

*SELECT SINGLE bezei
*         FROM t005u
*         INTO gv_reg
*         WHERE land1 = gs_adrc-country
*          AND  bland = gs_adrc-region
*          AND  spras = sy-langu.
*
**BREAK primus.
*SELECT SINGLE gst_region
*       FROM   zgst_region
*       INTO   gv_gst_reg
*       WHERE  bezei = gv_reg.
*
*SELECT SINGLE smtp_addr
*        FROM  adr6
*        INTO  gv_email
*        WHERE addrnumber = lv_adrnr.
*
*
****lv_kunnr = ls_bil_invoice-hd_gen-ship_to_party.
****IF lv_kunnr IS INITIAL.
****  lv_kunnr = ls_bil_invoice-hd_gen-sold_to_party.
****ENDIF.
*SELECT SINGLE adrnr
*       FROM   vbpa
*       INTO   lv_adrnr
*       WHERE vbeln = LS_BIL_INVOICE-hd_ref-order_numb
*       AND   parvw = 'WE'.
*
******Consignee
*SELECT SINGLE kunnr
*              stcd3
*        FROM  kna1
*        INTO (lv_kunnr,gv_gst_c)
*        WHERE adrnr = lv_adrnr.
*
*SELECT SINGLE *
*       FROM adrc
*       INTO gs_adrc_c
*       WHERE addrnumber = lv_adrnr.
*
*SELECT SINGLE landx
*         FROM t005t
*         INTO gv_country_c
*         WHERE land1 = gs_adrc_c-country
*          AND  spras = sy-langu.
*
*SELECT SINGLE bezei
*         FROM t005u
*         INTO gv_reg_c
*         WHERE land1 = gs_adrc_c-country
*          AND  bland = gs_adrc_c-region
*          AND  spras = sy-langu.
*
*SELECT SINGLE gst_region
*       FROM   zgst_region
*       INTO   gv_gst_reg_c
*       WHERE  bezei = gv_reg_c.
*
*
*
*SELECT SINGLE smtp_addr
*        FROM  adr6
*        INTO  gv_email_c
*        WHERE addrnumber = lv_adrnr.
*
*
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    INPUT         = gv_gst_reg
* IMPORTING
*   OUTPUT         = gv_gst_reg
*          .
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    INPUT         = gv_gst_reg_c
* IMPORTING
*   OUTPUT         = gv_gst_reg_c
*          .
*
*gv_gst_reg_c = gv_gst_reg_c+1(2).
*
*gv_gst_reg = gv_gst_reg+1(2).
*
*DATA: lv_name   TYPE thead-tdname.
*  CLEAR: lv_lines,LINES,lv_name.
*      REFRESH lv_lines.
*      lv_name = LS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z030'
*          language                = sy-langu
*          name                    = lv_name
*          object                  = 'VBBK'
*        TABLES
*          lines                   = lv_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*      READ TABLE lv_lines INTO LINES INDEX 1.
