"Name: \PR:SAPLMLSR\FO:SAVE\SE:BEGIN\EI
ENHANCEMENT 0 ZCHECK_ML81N.
*---------Added By Snehal Rajale On 29 jan 2021---------*
*BREAK PRIMUS.

    DATA : LS_USER TYPE ZUSER_CHECK .

    "CHECK USER GRANTED FOR DUPLICATE SERVICE ENTRY
    SELECT SINGLE zuname
    FROM ZUSER_CHECK
    INTO ls_user
    WHERE zuname = sy-uname.

   IF SY-SUBRC ne 0.

    TYPES: BEGIN OF TY_EKKO,
             EBELN TYPE EKKO-EBELN,
             BUKRS TYPE EKKO-BUKRS,
             LIFNR TYPE EKKO-LIFNR,
           END OF TY_EKKO.
    DATA : LS_EKKO TYPE TY_EKKO.

    DATA: gd_fiscalyr         TYPE bapi0002_4-fiscal_year,
          gd_fiscalp          TYPE bapi0002_4-fiscal_period,
          fiscal_year_variant TYPE t001-periv,
          t001_data           TYPE t001,
          st_date             TYPE sy-datum,
          ed_date             TYPE sy-datum,
          it_data             TYPE TABLE OF wb2_v_mkpf_mseg2.

    SEARCH rm11r-kzabn_txt FOR 'Acceptance revoked'.
    if sy-subrc ne 0 and ESSR-LOEKZ ne 'X'.

   " TO GET Company CODE And Vendor Code
    SELECT SINGLE EBELN
                  BUKRS
                  LIFNR
            FROM EKKO
            INTO LS_EKKO
            WHERE EBELN EQ RM11R-BSTNR.


   " TO GET the fiscal year OF the current DATE
    CALL FUNCTION 'BAPI_COMPANYCODE_GET_PERIOD'
    EXPORTING
      companycodeid = LS_EKKO-BUKRS
      posting_date  = sy-datum
    IMPORTING
      fiscal_year   = gd_fiscalyr
      fiscal_period = gd_fiscalp.

    " Get fiscal year variant for company code

    CALL FUNCTION 'FI_COMPANY_CODE_DATA'
    EXPORTING
      i_bukrs      =  LS_EKKO-BUKRS
    IMPORTING
      e_t001       = t001_data
    EXCEPTIONS
      system_error = 1
      OTHERS       = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF sy-subrc = 0.

    fiscal_year_variant = t001_data-periv.

    ENDIF.

    " Get first and last calendar date for a fiscal year
    CALL FUNCTION 'FIRST_AND_LAST_DAY_IN_YEAR_GET'
    EXPORTING
      i_gjahr        = gd_fiscalyr
      i_periv        = fiscal_year_variant
    IMPORTING
      e_first_day    = st_date
      e_last_day     = ed_date
    EXCEPTIONS
      input_false    = 1
      t009_notfound  = 2
      t009b_notfound = 3
      OTHERS         = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

      " Logic TO Check the duplicate reference number
    SELECT *
    FROM wb2_v_mkpf_mseg2
    INTO CORRESPONDING FIELDS OF TABLE it_data
    WHERE lifnr_i = ls_ekko-lifnr
    AND xblnr = essr-xblnr
    AND budat >= st_date
    AND budat <= ed_date.

    IF it_data[] IS NOT INITIAL.
      IF sy-subrc EQ 0 .
        MESSAGE 'Delivery Note/Invoice Number Already exists' TYPE 'E'.
      ENDIF.
    ENDIF.

    endif.

   ELSE.
     MESSAGE 'Delivery Note/Invoice Number Already exists' TYPE 'I'.
  ENDIF.
*---------Ended By Snehal Rajale On 29 jan 2021---------*
ENDENHANCEMENT.
