
data : ls_final TYPE zmm_tax_final.
data : ls_taxs TYPE zmm_tax_final.



read TABLE gt_final INTO wa_final INDEX 1.
****
****CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
****  EXPORTING
****    i_bukrs                    =
****    i_mwskz                    =
*****   I_TXJCD                    = ' '
****    i_waers                    =
****    i_wrbtr                    =
*****   I_ZBD1P                    = 0
*****   I_PRSDT                    =
*****   I_PROTOKOLL                =
*****   I_TAXPS                    =
*****   I_ACCNT_EXT                =
*****   I_ACCDATA                  =
*****   I_PRICING_REFRESH_TX       = ' '
***** IMPORTING
*****   E_FWNAV                    =
*****   E_FWNVV                    =
*****   E_FWSTE                    =
*****   E_FWAST                    =
****  TABLES
****    t_mwdat                    = t_mwdat
***** EXCEPTIONS
*****   BUKRS_NOT_FOUND            = 1
*****   COUNTRY_NOT_FOUND          = 2
*****   MWSKZ_NOT_DEFINED          = 3
*****   MWSKZ_NOT_VALID            = 4
*****   KTOSL_NOT_FOUND            = 5
*****   KALSM_NOT_FOUND            = 6
*****   PARAMETER_ERROR            = 7
*****   KNUMH_NOT_FOUND            = 8
*****   KSCHL_NOT_FOUND            = 9
*****   UNKNOWN_ERROR              = 10
*****   ACCOUNT_NOT_FOUND          = 11
*****   TXJCD_NOT_VALID            = 12
*****   OTHERS                     = 13
****          .
****IF sy-subrc <> 0.
***** Implement suitable error handling here
****ENDIF.













