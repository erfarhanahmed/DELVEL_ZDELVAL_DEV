"Name: \PR:SAPMV45A\FO:USEREXIT_SAVE_DOCUMENT_PREPARE\SE:BEGIN\EI
ENHANCEMENT 0 ZENH_VALIDATE_DOC_DT_CUST_REF.
  " beign of code added by Sagar Darade on 17/03/2026 to validate dcoument date and customer refernce date

  IF sy-tcode = 'VA01'.
    IF vbak-vkorg = '1000'. " This validation will work only for India

      " 1. Sales Order Date Validation
      IF vbak-audat <> sy-datum.
        MESSAGE 'Sales Order Date must be today (No past/future allowed)' TYPE 'E'.
      ENDIF.

      " 2. Customer Reference Date Validation

      IF vbak-bstdk > sy-datum.
        MESSAGE 'Future date not allowed in Customer Reference Date' TYPE 'E'.
      ENDIF.

    ENDIF.

  ENDIF.
  " end of code added by Sagar Darade on 17/03/2026 to validate dcoument date and customer refernce date


ENDENHANCEMENT.
