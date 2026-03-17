***break fujiabap.
***loop at gt_final INTO wa_final.
***
*******GV_TOTAL = GV_TOTAL + wa_final-KWERT.
***
***endloop.

data : gv_per(7) TYPE c.

if gv_acc IS NOT INITIAL.

CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
  EXPORTING
    i_bukrs                    = wa_final-bukrs
    i_mwskz                    = wa_final-mwskz
*   I_TXJCD                    = ' '
    i_waers                    = wa_final-waers
    i_wrbtr                    = gv_acc
*   I_ZBD1P                    = 0
*   I_PRSDT                    =
*   I_PROTOKOLL                =
*   I_TAXPS                    =
*   I_ACCNT_EXT                =
*   I_ACCDATA                  =
*   I_PRICING_REFRESH_TX       = ' '
* IMPORTING
*   E_FWNAV                    =
*   E_FWNVV                    =
*   E_FWSTE                    =
*   E_FWAST                    =
  TABLES
    t_mwdat                    = t_mwdat
* EXCEPTIONS
*   BUKRS_NOT_FOUND            = 1
*   COUNTRY_NOT_FOUND          = 2
*   MWSKZ_NOT_DEFINED          = 3
*   MWSKZ_NOT_VALID            = 4
*   KTOSL_NOT_FOUND            = 5
*   KALSM_NOT_FOUND            = 6
*   PARAMETER_ERROR            = 7
*   KNUMH_NOT_FOUND            = 8
*   KSCHL_NOT_FOUND            = 9
*   UNKNOWN_ERROR              = 10
*   ACCOUNT_NOT_FOUND          = 11
*   TXJCD_NOT_VALID            = 12
*   OTHERS                     = 13
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

else.

  CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
  EXPORTING
    i_bukrs                    = wa_final-bukrs
    i_mwskz                    = wa_final-mwskz
*   I_TXJCD                    = ' '
    i_waers                    = wa_final-waers
    i_wrbtr                    = gv_total
*   I_ZBD1P                    = 0
*   I_PRSDT                    =
*   I_PROTOKOLL                =
*   I_TAXPS                    =
*   I_ACCNT_EXT                =
*   I_ACCDATA                  =
*   I_PRICING_REFRESH_TX       = ' '
* IMPORTING
*   E_FWNAV                    =
*   E_FWNVV                    =
*   E_FWSTE                    =
*   E_FWAST                    =
  TABLES
    t_mwdat                    = t_mwdat
* EXCEPTIONS
*   BUKRS_NOT_FOUND            = 1
*   COUNTRY_NOT_FOUND          = 2
*   MWSKZ_NOT_DEFINED          = 3
*   MWSKZ_NOT_VALID            = 4
*   KTOSL_NOT_FOUND            = 5
*   KALSM_NOT_FOUND            = 6
*   PARAMETER_ERROR            = 7
*   KNUMH_NOT_FOUND            = 8
*   KSCHL_NOT_FOUND            = 9
*   UNKNOWN_ERROR              = 10
*   ACCOUNT_NOT_FOUND          = 11
*   TXJCD_NOT_VALID            = 12
*   OTHERS                     = 13
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
endif.

break fujiabap.
loop at t_mwdat INTO wa_mwdat.
if wa_mwdat-kschl = 'JMOP' or wa_mwdat-kschl = 'JMIP'.
  CLEAR gv_per.
  gv_per = wa_mwdat-msatz.

  shift gv_per RIGHT DELETING TRAILING '0'.

  wa_final-cenvat = wa_mwdat-wmwst.
  wa_final-cen_per = gv_per.

endif.

if wa_mwdat-kschl = 'JVRD' or wa_mwdat-kschl = 'JVRN'.

   CLEAR gv_per.
  gv_per = wa_mwdat-msatz.

  shift gv_per RIGHT DELETING TRAILING '0'.

  wa_final-vat = wa_mwdat-wmwst.
  wa_final-vat_per = gv_per.

endif.

if wa_mwdat-kschl = 'JVCS' .

   CLEAR gv_per.
  gv_per = wa_mwdat-msatz.

  shift gv_per RIGHT DELETING TRAILING '0'.

  wa_final-cst = wa_mwdat-wmwst.
  wa_final-cst_per = gv_per.

endif.

endloop.
****
****data : gv_amt TYPE konv-kbetr.
****data : gv_amt1 TYPE konv-kbetr.
****clear gv_amt.
****gv_amt = wa_final-cenvat / 100.
****
****
****CALL FUNCTION 'SPELL_AMOUNT'
**** EXPORTING
****   AMOUNT          = gv_amt
****   CURRENCY        = ' '
****   FILLER          = ' '
****   LANGUAGE        = SY-LANGU
**** IMPORTING
****   IN_WORDS        = v_text
****
**** EXCEPTIONS
****   NOT_FOUND       = 1
****   TOO_LARGE       = 2
****   OTHERS          = 3
****          .
****IF sy-subrc <> 0.
***** Implement suitable error handling here
****ENDIF.
****
