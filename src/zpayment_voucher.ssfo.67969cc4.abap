
*"""""" CGST/IGST/SGST/CESS """""""""""""""""""""""""""""""""

  CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
  EXPORTING
    i_bukrs                 = '1000'
    i_mwskz                 = LS_BSEG-mwskz
*   I_TXJCD                 = ' '
    i_waers                 = 'INR'
    i_wrbtr                 = SUBTOTAL
*   I_ZBD1P                 = 0
*   I_PRSDT                 =
*   I_PROTOKOLL             =
*   I_TAXPS                 =
*   I_ACCNT_EXT             =
*   I_ACCDATA               =
 IMPORTING
*   E_FWNAV                =
*   E_FWNVV                =
   E_FWSTE                 = FWSTE
   E_FWAST                 = FWAST
  tables
    t_mwdat                = T_MWDAT
 EXCEPTIONS
   BUKRS_NOT_FOUND         = 1
   COUNTRY_NOT_FOUND       = 2
   MWSKZ_NOT_DEFINED       = 3
   MWSKZ_NOT_VALID         = 4
   KTOSL_NOT_FOUND         = 5
   KALSM_NOT_FOUND         = 6
   PARAMETER_ERROR         = 7
   KNUMH_NOT_FOUND         = 8
   KSCHL_NOT_FOUND         = 9
   UNKNOWN_ERROR           = 10
   ACCOUNT_NOT_FOUND       = 11
   TXJCD_NOT_VALID         = 12
   OTHERS                  = 13
          .
IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSG  V2 SY-MSGV3 SY-MSGV4.
ENDIF.
*BREAK X770204.

LOOP AT T_MWDAT INTO LS_MWDAT.
    CASE LS_MWDAT-KSCHL.
     WHEN 'JICG'.
       CGST_AMT       = LS_MWDAT-WMWST.
       CGST_RATE      = LS_MWDAT-KBETR / 10.
       CGST_AMT_TOTAL = CGST_AMT_TOTAL + CGST_AMT.
     WHEN 'JISG'.
       SGST_AMT       = LS_MWDAT-WMWST.
       SGST_RATE      = LS_MWDAT-KBETR / 10.
       SGST_AMT_TOTAL = SGST_AMT_TOTAL + SGST_AMT.
     WHEN 'JIIG'.
       IGST_AMT       = LS_MWDAT-WMWST.
       IGST_RATE      = LS_MWDAT-KBETR / 10.
       IGST_AMT_TOTAL = IGST_AMT_TOTAL + IGST_AMT .
    ENDCASE.
ENDLOOP.


TOTAL = TOTAL + SUBTOTAL + CGST_AMT  + SGST_AMT  + IGST_AMT .














