  DATA:
    ls_faede_i TYPE faede,
    ls_faede_e TYPE faede.
DATA: itab  TYPE idata OCCURS 0 WITH HEADER LINE.


   SELECT bsid~bukrs
         bsid~kunnr
         augbl
         auggj
         augdt
         gjahr
         belnr
         buzei
         budat
         bldat
         waers
         shkzg
         dmbtr
         wrbtr
         rebzg
         rebzj
         rebzz
         umskz
         bsid~zterm
         zbd1t
         xblnr
         blart
*     kna1~name1
*     kna1~ktokd
    knb1~akont
    bsid~zfbdt
    bsid~zbd1t
    bsid~zbd2t
    bsid~zbd3t
    bsid~vbeln
INTO CORRESPONDING FIELDS OF TABLE itab
FROM bsid INNER JOIN knb1 ON bsid~kunnr = knb1~kunnr AND knb1~bukrs = bsid~bukrs
WHERE  bsid~kunnr = ls_bil_invoice-hd_gen-sold_to_party.


  SELECT bsad~bukrs,
         bsad~kunnr,
         bsad~augbl,
         bsad~auggj,
         bsad~augdt,
         bsad~gjahr,
         bsad~belnr,
         bsad~buzei,
         bsad~budat,
         bsad~bldat,
         bsad~waers,
         bsad~shkzg,
         bsad~dmbtr,
         bsad~wrbtr,
         bsad~rebzg,
         bsad~rebzj,
         bsad~rebzz,
         bsad~umskz,
         bsad~zterm,
*         bsad~zbd1t,
         bsad~blart,
         bsad~xblnr,
    knb1~akont,
    bsad~zfbdt,
    bsad~zbd1t,
    bsad~zbd2t,
    bsad~zbd3t,
    bsad~vbeln
*INTO CORRESPONDING FIELDS OF TABLE itab
APPENDING CORRESPONDING FIELDS OF TABLE @itab
FROM bsad INNER JOIN knb1 ON knb1~kunnr = bsad~kunnr
AND knb1~bukrs = bsad~bukrs
AND  bsad~kunnr = @ls_bil_invoice-hd_gen-sold_to_party
AND   umskz <> 'F'.

*BREAK-POINT.
 LOOP AT itab WHERE VBELN  = LS_BIL_INVOICE-HD_GEN-BIL_NUMBER.

    ls_faede_i-koart = 'D'.
    ls_faede_i-zfbdt = itab-zfbdt.
    ls_faede_i-zbd1t = itab-zbd1t.
    ls_faede_i-zbd2t = itab-zbd2t.
    ls_faede_i-zbd3t = itab-zbd3t.

    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        i_faede                    = ls_faede_i
*       I_GL_FAEDE                 =
      IMPORTING
        e_faede                    = ls_faede_e
      EXCEPTIONS
        account_type_not_supported = 1
        OTHERS                     = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    itab-duedate = ls_faede_e-netdt.
 ENDLOOP.

 DATA : VDT(2) TYPE C,VMN(2) TYPE C,VYR(4) TYPE C.

 VDT = itab-duedate+6(2).
 VMN = itab-duedate+4(2).
 VYR = itab-duedate+0(4).

 CONCATENATE VYR '-' VMN '-' VDT INTO GVDUEDT.

















