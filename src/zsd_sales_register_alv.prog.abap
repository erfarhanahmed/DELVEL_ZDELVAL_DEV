*&---------------------------------------------------------------------*
*&      FORM  BUILD_FIELD_CAT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM  build_field_cat.

*Build  SALES DATA field cat
  wa_sale_cat-col_pos = 1.
  wa_sale_cat-fieldname = 'FKDAT'.
  wa_sale_cat-no_zero = 'X'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 10.
  wa_sale_cat-seltext_l   = 'Vhr Date'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 2.
  wa_sale_cat-fieldname = 'ACC_DOC'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 11.
  wa_sale_cat-seltext_l   = 'Acc Doc No.'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 3.
  wa_sale_cat-fieldname = 'TAX_INV_NO'.
*WA_SALE_CAT-NO_ZERO = 'X'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 10.
  wa_sale_cat-seltext_l   = 'Tax Inv No.'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 4.
  wa_sale_cat-fieldname = 'INV_DT'.
  wa_sale_cat-no_zero = 'X'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 10.
  wa_sale_cat-seltext_l   = 'Inv Date'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 5.
  wa_sale_cat-fieldname = 'SALE_ORD'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 10.
  wa_sale_cat-seltext_l   = 'Sales Order'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 6.
  wa_sale_cat-fieldname = 'LEDGER'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 20.
  wa_sale_cat-seltext_l   = 'Sales Ledger Head'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 7.
  wa_sale_cat-fieldname = 'NAME1'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 20.
  wa_sale_cat-seltext_l   = 'Cust Name'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 8.
  wa_sale_cat-fieldname = 'CUST_ADD'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 50.
  wa_sale_cat-seltext_l   = 'Address'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 9.
  wa_sale_cat-fieldname = 'VAT_NO'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 11.
  wa_sale_cat-seltext_l   = 'VAT TIN No.'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 10.
  wa_sale_cat-fieldname = 'VAT_WEF'.
  wa_sale_cat-no_zero = 'X'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 10.
  wa_sale_cat-seltext_l   = 'TIN NO W.E.F'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 11.
  wa_sale_cat-fieldname = 'BASIC'.
*WA_SALE_CAT-DO_SUM = 'X'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Basic'.
  wa_sale_cat-datatype = 'CURR' .
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 12.
  wa_sale_cat-fieldname = 'P_F'.
*WA_SALE_CAT-DO_SUM = 'X'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'P&F Charges'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 13.
  wa_sale_cat-fieldname = 'ASS_VALUE'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Assessable Value'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 14.
  wa_sale_cat-fieldname = 'EXCISE'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Excise Duty'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 15.
  wa_sale_cat-fieldname = 'E_CESS'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'E Cess'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 16.
  wa_sale_cat-fieldname = 'HE_CESS'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'HE Cess'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 17.
  wa_sale_cat-fieldname = 'FRIGHT'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
*  WA_SALE_CAT-OUTPUTLEN   = 21.
  wa_sale_cat-seltext_l   = 'Fright'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 18.
  wa_sale_cat-fieldname = 'SUB_TOT'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Sub Total'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 19.
  wa_sale_cat-fieldname = 'VAT_CST'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'VAT/CST %'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 20.
  wa_sale_cat-fieldname = 'TAX_AMT'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Tax Amount'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 21.
  wa_sale_cat-fieldname = 'TAX_TYP'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 8.
  wa_sale_cat-seltext_l   = 'Tax Type'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 22.
  wa_sale_cat-fieldname = 'INSURANCE'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Insurance'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

*WA_SALE_CAT-COL_POS = 24.
*WA_SALE_CAT-FIELDNAME = 'N_TAX_FRT'.
*WA_SALE_CAT-REF_TABNAME = 'IT_2SALE_DATA'.
*WA_SALE_CAT-OUTPUTLEN   = 21.
*WA_SALE_CAT-SELTEXT_L   = 'Non Taxable Freight'.
*APPEND WA_SALE_CAT TO IT_SALE_FIELD.
*CLEAR WA_SALE_CAT.

  wa_sale_cat-col_pos = 23.
  wa_sale_cat-fieldname = 'DISCOUNT'.
*WA_SALE_CAT-DO_SUM = 'X'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Discount'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 24.
  wa_sale_cat-fieldname = 'TCS'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'TCS'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 25.
  wa_sale_cat-fieldname = 'TST_CHR'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 23.
  wa_sale_cat-seltext_l   = 'Testing & Certification'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_sale_cat-col_pos = 26.
  wa_sale_cat-fieldname = 'GROSS_AMT'.
  wa_sale_cat-ref_tabname = 'IT_2SALE_DATA'.
  wa_sale_cat-outputlen   = 18.
  wa_sale_cat-seltext_l   = 'Gross'.
  APPEND wa_sale_cat TO it_sale_field.
  CLEAR wa_sale_cat.

  wa_events-form = 'TOP_PAGE'.
  wa_events-name = 'TOP_OF_PAGE'.
  APPEND wa_events TO it_events1.
  CLEAR wa_events.

*layout for total
*CLEAR WA_LAYOUT.
*REFRESH V_LAYOUT1.
*WA_LAYOUT-totals_only = 'X'.
*V_LAYOUT1-totals_only = 'X'.
*APPEND WA_LAYOUT TO V_LAYOUT1.
*CLEAR WA_LAYOUT.

*test sort sequence
*CLEAR WA_SORT.
*REFRESH IT_SORT.
*WA_SORT-spos  = 02.
*APPEND WA_SORT TO IT_SORT.
*CLEAR WA_SORT.

************ SALES DATA SUMMARY BASED ON LEDGER*************
  wa_sale_summary_cat-col_pos = 1.
  wa_sale_summary_cat-fieldname = 'POS'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 150.
  wa_sale_summary_cat-seltext_l   = space .
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 2.
  wa_sale_summary_cat-fieldname = 'LEDGER'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 20.
  wa_sale_summary_cat-seltext_l   = 'Sales Ledger Head'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 3.
  wa_sale_summary_cat-fieldname = 'BASIC'.
  wa_sale_cat-do_sum = 'X'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Basic'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 4.
  wa_sale_summary_cat-fieldname = 'P_F'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'P&F Charges'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 5.
  wa_sale_summary_cat-fieldname = 'ASS_VALUE'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Assessable Value'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 6.
  wa_sale_summary_cat-fieldname = 'EXCISE'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Excise Duty'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 7.
  wa_sale_summary_cat-fieldname = 'E_CESS'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'E Cess'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 8.
  wa_sale_summary_cat-fieldname = 'HE_CESS'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'HE Cess'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 9.
  wa_sale_summary_cat-fieldname = 'FRIGHT'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Fright'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 10.
  wa_sale_summary_cat-fieldname = 'SUB_TOT'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Sub Total'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 11.
  wa_sale_summary_cat-fieldname = 'VAT_CST'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'VAT/CST %'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 12.
  wa_sale_summary_cat-fieldname = 'TAX_AMT'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Tax Amount'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 13.
  wa_sale_summary_cat-fieldname = 'TAX_TYP'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 8.
  wa_sale_summary_cat-seltext_l   = 'Tax Type'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 14.
  wa_sale_summary_cat-fieldname = 'INSURANCE'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Insurane'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 15.
  wa_sale_summary_cat-fieldname = 'DISCOUNT'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Discount'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 16.
  wa_sale_summary_cat-fieldname = 'TCS'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'TCS'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 17.
  wa_sale_summary_cat-fieldname = 'TST_CHARG'.
  wa_sale_summary_cat-ref_tabname = 'IT_SPACE_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 23.
  wa_sale_summary_cat-seltext_l   = 'Testing & Certification'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_sale_summary_cat-col_pos = 18.
  wa_sale_summary_cat-fieldname = 'GROSS_AMT'.
  wa_sale_summary_cat-ref_tabname = 'IT_SUMMARY'.
  wa_sale_summary_cat-outputlen   = 18.
  wa_sale_summary_cat-seltext_l   = 'Gross'.
  APPEND wa_sale_summary_cat TO it_sale_summary_field.
  CLEAR wa_sale_summary_cat.

  wa_events-form = 'TOP_PAGE_4'.
  wa_events-name = 'TOP_OF_PAGE'.
  APPEND wa_events TO it_events5.
  CLEAR wa_events.

************ DEBIT DATA FIELDCAT*************

  wa_debit_data_cat-col_pos = 1.
  wa_debit_data_cat-fieldname = 'FKDAT'.
  wa_debit_data_cat-no_zero = 'X'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 10.
  wa_debit_data_cat-seltext_l   = 'Vhr Date'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 2.
  wa_debit_data_cat-fieldname = 'VBELN'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 11.
  wa_debit_data_cat-seltext_l   = 'Debit Note No.'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 3.
  wa_debit_data_cat-fieldname = 'SALE_ORD'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 10.
  wa_debit_data_cat-seltext_l   = 'Ref. No.'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 4.
  wa_debit_data_cat-fieldname = 'TAX_INV_NO'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 10.
  wa_debit_data_cat-seltext_l   = 'Tax Inv No.'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 5.
  wa_debit_data_cat-fieldname = 'INV_DT'.
  wa_debit_data_cat-no_zero = 'X'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 10.
  wa_debit_data_cat-seltext_l   = 'Inv Date'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 6.
  wa_debit_data_cat-fieldname = 'LEDGER'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 20.
  wa_debit_data_cat-seltext_l   = 'Sales Ledger Head'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 7.
  wa_debit_data_cat-fieldname = 'NAME1'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 20.
  wa_debit_data_cat-seltext_l   = 'Cust Name'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 8.
  wa_debit_data_cat-fieldname = 'CUST_ADD'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 50.
  wa_debit_data_cat-seltext_l   = 'Address'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 9.
  wa_debit_data_cat-fieldname = 'VAT_NO'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 11.
  wa_debit_data_cat-seltext_l   = 'VAT TIN No.'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 10.
  wa_debit_data_cat-fieldname = 'VAT_WEF'.
  wa_debit_data_cat-no_zero = 'X'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 10.
  wa_debit_data_cat-seltext_l   = 'TIN NO W.E.F'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 11.
  wa_debit_data_cat-fieldname = 'BASIC'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Basic'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 12.
  wa_debit_data_cat-fieldname = 'P_F'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'P&F Charges'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 13.
  wa_debit_data_cat-fieldname = 'ASS_VALUE'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Assessable Value'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 14.
  wa_debit_data_cat-fieldname = 'EXCISE'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Excise Duty'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 15.
  wa_debit_data_cat-fieldname = 'E_CESS'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'E Cess'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 16.
  wa_debit_data_cat-fieldname = 'HE_CESS'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'HE Cess'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 17.
  wa_debit_data_cat-fieldname = 'FRIGHT'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Fright'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 18.
  wa_debit_data_cat-fieldname = 'SUB_TOT'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Sub Total'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 19.
  wa_debit_data_cat-fieldname = 'VAT_CST'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'VAT/CST %'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 20.
  wa_debit_data_cat-fieldname = 'TAX_AMT'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Tax Amount'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 21.
  wa_debit_data_cat-fieldname = 'TAX_TYP'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 8.
  wa_debit_data_cat-seltext_l   = 'Tax Type'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 22.
  wa_debit_data_cat-fieldname = 'INSURANCE'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Insurance'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 23.
  wa_debit_data_cat-fieldname = 'DISCOUNT'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Discount'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 24.
  wa_debit_data_cat-fieldname = 'TCS'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'TCS'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 25.
  wa_debit_data_cat-fieldname = 'TST_CHR'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 23.
  wa_debit_data_cat-seltext_l   = 'Testing & Certification'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_debit_data_cat-col_pos = 26.
  wa_debit_data_cat-fieldname = 'GROSS_AMT'.
  wa_debit_data_cat-ref_tabname = 'IT_2SALE_DEBIT'.
  wa_debit_data_cat-outputlen   = 18.
  wa_debit_data_cat-seltext_l   = 'Gross'.
  APPEND wa_debit_data_cat TO it_debit_field.
  CLEAR wa_debit_data_cat.

  wa_events-form = 'TOP_PAGE_1'.
  wa_events-name = 'TOP_OF_PAGE'.
  APPEND wa_events TO it_events2.
  CLEAR wa_events.

************ DEBIT SUMMARY DATA FIELDCAT*************

  wa_debit_summary_cat-col_pos = 1.
  wa_debit_summary_cat-fieldname = 'POS'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 150.
  wa_debit_summary_cat-seltext_l   = space.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 2.
  wa_debit_summary_cat-fieldname = 'LEDGER'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 20.
  wa_debit_summary_cat-seltext_l   = 'Sales Ledger Head'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 3.
  wa_debit_summary_cat-fieldname = 'BASIC'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Basic'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 4.
  wa_debit_summary_cat-fieldname = 'P_F'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'P&F Charges'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 5.
  wa_debit_summary_cat-fieldname = 'ASS_VALUE'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Assessable Value'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 6.
  wa_debit_summary_cat-fieldname = 'EXCISE'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Excise Duty'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 7.
  wa_debit_summary_cat-fieldname = 'E_CESS'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'E Cess'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 8.
  wa_debit_summary_cat-fieldname = 'HE_CESS'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'HE Cess'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 9.
  wa_debit_summary_cat-fieldname = 'FRIGHT'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Fright'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 10.
  wa_debit_summary_cat-fieldname = 'SUB_TOT'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Sub Total'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 11.
  wa_debit_summary_cat-fieldname = 'VAT_CST'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'VAT/CST %'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 12.
  wa_debit_summary_cat-fieldname = 'TAX_AMT'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Tax Amount'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 13.
  wa_debit_summary_cat-fieldname = 'TAX_TYP'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 8.
  wa_debit_summary_cat-seltext_l   = 'Tax Type'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 14.
  wa_debit_summary_cat-fieldname = 'INSURANCE'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Insurance'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 15.
  wa_debit_summary_cat-fieldname = 'DISCOUNT'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Discount'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 16.
  wa_debit_summary_cat-fieldname = 'TCS'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'TCS'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 17.
  wa_debit_summary_cat-fieldname = 'TST_CHARG'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 23.
  wa_debit_summary_cat-seltext_l   = 'Testing & Certification'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_debit_summary_cat-col_pos = 18.
  wa_debit_summary_cat-fieldname = 'GROSS_AMT'.
  wa_debit_summary_cat-ref_tabname = 'IT_SPACE_DB_SUMMARY'.
  wa_debit_summary_cat-outputlen   = 18.
  wa_debit_summary_cat-seltext_l   = 'Gross'.
  APPEND wa_debit_summary_cat TO it_debit_summary_field.
  CLEAR wa_debit_summary_cat.

  wa_events-form = 'TOP_PAGE_5'.
  wa_events-name = 'TOP_OF_PAGE'.
  APPEND wa_events TO it_events6.
  CLEAR wa_events.

************ CREDIT DATA FIELDCAT*************
  wa_credit_data_cat-col_pos = 1.
  wa_credit_data_cat-fieldname = 'FKDAT'.
  wa_credit_data_cat-no_zero = 'X'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 10.
  wa_credit_data_cat-seltext_l   = 'Vhr Date'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 2.
  wa_credit_data_cat-fieldname = 'VBELN'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 11.
  wa_credit_data_cat-seltext_l   = 'Credit Note No.'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 3.
  wa_credit_data_cat-fieldname = 'SALE_ORD'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 10.
  wa_credit_data_cat-seltext_l   = 'Ref. No.'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 4.
  wa_credit_data_cat-fieldname = 'TAX_INV_NO'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 10.
  wa_credit_data_cat-seltext_l   = 'Tax Inv No.'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 5.
  wa_credit_data_cat-fieldname = 'INV_DT'.
  wa_credit_data_cat-no_zero = 'X'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 10.
  wa_credit_data_cat-seltext_l   = 'Inv Date'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 6.
  wa_credit_data_cat-fieldname = 'LEDGER'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 20.
  wa_credit_data_cat-seltext_l   = 'Sales Ledger Head'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 7.
  wa_credit_data_cat-fieldname = 'NAME1'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 20.
  wa_credit_data_cat-seltext_l   = 'Cust Name'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 8.
  wa_credit_data_cat-fieldname = 'CUST_ADD'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 50.
  wa_credit_data_cat-seltext_l   = 'Address'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 9.
  wa_credit_data_cat-fieldname = 'VAT_NO'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 11.
  wa_credit_data_cat-seltext_l   = 'VAT TIN No.'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 10.
  wa_credit_data_cat-fieldname = 'VAT_WEF'.
  wa_credit_data_cat-no_zero = 'X'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 10.
  wa_credit_data_cat-seltext_l   = 'TIN NO W.E.F'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 11.
  wa_credit_data_cat-fieldname = 'BASIC'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Basic'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 12.
  wa_credit_data_cat-fieldname = 'P_F'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'P&F Charges'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 13.
  wa_credit_data_cat-fieldname = 'ASS_VALUE'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Assessable Value'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 14.
  wa_credit_data_cat-fieldname = 'EXCISE'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Excise Duty'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 15.
  wa_credit_data_cat-fieldname = 'E_CESS'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'E Cess'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 16.
  wa_credit_data_cat-fieldname = 'HE_CESS'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'HE Cess'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 17.
  wa_credit_data_cat-fieldname = 'FRIGHT'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Fright'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 18.
  wa_credit_data_cat-fieldname = 'SUB_TOT'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Sub Total'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 19.
  wa_credit_data_cat-fieldname = 'VAT_CST'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'VAT/CST %'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 20.
  wa_credit_data_cat-fieldname = 'TAX_AMT'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Tax Amount'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 21.
  wa_credit_data_cat-fieldname = 'TAX_TYP'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 8.
  wa_credit_data_cat-seltext_l   = 'Tax Type'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 22.
  wa_credit_data_cat-fieldname = 'INSURANCE'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Insurance'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 23.
  wa_credit_data_cat-fieldname = 'DISCOUNT'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Discount'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 24.
  wa_credit_data_cat-fieldname = 'TCS'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'TCS'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 25.
  wa_credit_data_cat-fieldname = 'TST_CHR'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 23.
  wa_credit_data_cat-seltext_l   = 'Testing & Certification'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_credit_data_cat-col_pos = 26.
  wa_credit_data_cat-fieldname = 'GROSS_AMT'.
  wa_credit_data_cat-ref_tabname = 'IT_2SALE_CREDIT'.
  wa_credit_data_cat-outputlen   = 18.
  wa_credit_data_cat-seltext_l   = 'Gross'.
  APPEND wa_credit_data_cat TO it_credit_field.
  CLEAR wa_credit_data_cat.

  wa_events-form = 'TOP_PAGE_2'.
  wa_events-name = 'TOP_OF_PAGE'.
  APPEND wa_events TO it_events3.
  CLEAR wa_events.

*******CREDIT SUMMARY FIELD CAT*******************

  wa_credit_summary_cat-col_pos = 1.
  wa_credit_summary_cat-fieldname = 'POS'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 150.
  wa_credit_summary_cat-seltext_l   = space.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 2.
  wa_credit_summary_cat-fieldname = 'LEDGER'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 20.
  wa_credit_summary_cat-seltext_l   = 'Sales Ledger Head'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 3.
  wa_credit_summary_cat-fieldname = 'BASIC'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Basic'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 4.
  wa_credit_summary_cat-fieldname = 'P_F'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'P&F Charges'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.


  wa_credit_summary_cat-col_pos = 5.
  wa_credit_summary_cat-fieldname = 'ASS_VALUE'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Assessable Value'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 6.
  wa_credit_summary_cat-fieldname = 'EXCISE'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Excise Duty'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 7.
  wa_credit_summary_cat-fieldname = 'E_CESS'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'E Cess'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 8.
  wa_credit_summary_cat-fieldname = 'HE_CESS'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'HE Cess'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 9.
  wa_credit_summary_cat-fieldname = 'FRIGHT'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Fright'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 10.
  wa_credit_summary_cat-fieldname = 'SUB_TOT'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Sub Total'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 11.
  wa_credit_summary_cat-fieldname = 'VAT_CST'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'VAT/CST %'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 12.
  wa_credit_summary_cat-fieldname = 'TAX_AMT'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Tax Amount'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 13.
  wa_credit_summary_cat-fieldname = 'TAX_TYP'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 8.
  wa_credit_summary_cat-seltext_l   = 'Tax Type'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 14.
  wa_credit_summary_cat-fieldname = 'INSURANCE'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Insurance'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 15.
  wa_credit_summary_cat-fieldname = 'DISCOUNT'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Discount'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 16.
  wa_credit_summary_cat-fieldname = 'TCS'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'TCS'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 17.
  wa_credit_summary_cat-fieldname = 'TST_CHARG'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 23.
  wa_credit_summary_cat-seltext_l   = 'Testing & Certification'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_credit_summary_cat-col_pos = 18.
  wa_credit_summary_cat-fieldname = 'GROSS_AMT'.
  wa_credit_summary_cat-ref_tabname = 'IT_SPACE_CR_SUMMARY'.
  wa_credit_summary_cat-outputlen   = 18.
  wa_credit_summary_cat-seltext_l   = 'Gross'.
  APPEND wa_credit_summary_cat TO it_credit_summary_field.
  CLEAR wa_credit_summary_cat.

  wa_events-form = 'TOP_PAGE_6'.
  wa_events-name = 'TOP_OF_PAGE'.
  APPEND wa_events TO it_events7.
  CLEAR wa_events.

*********FINAL SUMMARY FIELD CAT********
  wa_final_summary_cat-col_pos = 1.
  wa_final_summary_cat-fieldname = 'POS'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 150.
  wa_final_summary_cat-seltext_l   = space.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 2.
  wa_final_summary_cat-fieldname = 'LEDGER'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 20.
  wa_final_summary_cat-seltext_l   = 'Sales Ledger Head'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 3.
  wa_final_summary_cat-fieldname = 'BASIC'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Basic'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 4.
  wa_final_summary_cat-fieldname = 'P_F'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'P&F Charges'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 5.
  wa_final_summary_cat-fieldname = 'ASS_VALUE'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Assessable Value'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 6.
  wa_final_summary_cat-fieldname = 'EXCISE'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Excise Duty'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 7.
  wa_final_summary_cat-fieldname = 'E_CESS'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'E Cess'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 8.
  wa_final_summary_cat-fieldname = 'HE_CESS'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'HE Cess'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 9.
  wa_final_summary_cat-fieldname = 'FRIGHT'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Fright'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 10.
  wa_final_summary_cat-fieldname = 'SUB_TOT'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Sub Total'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 11.
  wa_final_summary_cat-fieldname = 'VAT_CST'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'VAT/CST %'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 12.
  wa_final_summary_cat-fieldname = 'TAX_AMT'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Tax Amount'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 13.
  wa_final_summary_cat-fieldname = 'TAX_TYP'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 8.
  wa_final_summary_cat-seltext_l   = 'Tax Type'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 14.
  wa_final_summary_cat-fieldname = 'INSURANCE'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Insurance'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 15.
  wa_final_summary_cat-fieldname = 'DISCOUNT'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Discount'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.


  wa_final_summary_cat-col_pos = 16.
  wa_final_summary_cat-fieldname = 'TCS'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'TCS'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 17.
  wa_final_summary_cat-fieldname = 'TST_CHARG'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 23.
  wa_final_summary_cat-seltext_l   = 'Testing & Certification'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_final_summary_cat-col_pos = 18.
  wa_final_summary_cat-fieldname = 'GROSS_AMT'.
  wa_final_summary_cat-ref_tabname = 'IT_SPACE_FINAL_SUMMARY'.
  wa_final_summary_cat-outputlen   = 18.
  wa_final_summary_cat-seltext_l   = 'Gross'.
  APPEND wa_final_summary_cat TO it_final_summary_field.
  CLEAR wa_final_summary_cat.

  wa_events-form = 'TOP_PAGE_3'.
  wa_events-name = 'TOP_OF_PAGE'.
  APPEND wa_events TO it_events4.
  CLEAR wa_events.

ENDFORM.                    "BUILD_FIELD_CAT
