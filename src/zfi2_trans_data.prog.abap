*&---------------------------------------------------------------------*
*& Report ZFI2_TRANS_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi2_trans_data.

*REPORT zdemrgr_trans_data.
INCLUDE zfi2_dm_top.
*INCLUDE ZTMP_DM_TOP.
INCLUDE zfi2_dm_subroutines.
*INCLUDE ZTMP_DM_SUBROUTINES.

DATA error_file TYPE rlgrap-filename.
**  Internal table declaration
DATA: lt_glacct   TYPE TABLE OF bapiacgl09,
      lt_vendact  TYPE TABLE OF bapiacap09,
      lt_curramt  TYPE TABLE OF bapiaccr09,
      lt_return   TYPE TABLE OF bapiret2,
      x_return    TYPE bapiret2,
      lt_acctgl   TYPE TABLE OF  bapiacgl09,
      lt_cust_inv TYPE TABLE OF bapiacar09,
      lt_vend_inv TYPE TABLE OF bapiacap09.
*      lt_curramt TYPE TABLE OF BAPIACCR09.

** Workarea and variable declaration
DATA: lv_objtyp    TYPE bapiache09-obj_type,
      lv_objkey    TYPE bapiache09-obj_key,
      lv_objsys    TYPE bapiache09-obj_sys,
      wa_docheader TYPE bapiache09,
      wa_glacct    LIKE LINE OF lt_glacct,
      wa_curramt   LIKE LINE OF lt_curramt,
      wa_vendact   LIKE LINE OF lt_vendact,
      wa_return    LIKE LINE OF lt_return,
      wa_acctgl    TYPE bapiacgl09,
      wa_cust_inv  TYPE bapiacar09,
      wa_vend_inv  TYPE bapiacap09.
*      wa_cust_dwn TYPE  BAPIACAR09.
*      wa_curramt   TYPE BAPIACCR09.

DATA : temp_item_no_1 TYPE bapiacgl09-itemno_acc,
       temp_item_no_2 TYPE bapiacgl09-itemno_acc,
       obj_key        TYPE bapiache09-obj_key.


SELECTION-SCREEN BEGIN OF BLOCK blck.
PARAMETERS:
  p_file TYPE rlgrap-filename OBLIGATORY MODIF ID sp1,       " File Path
  e_file TYPE rlgrap-filename OBLIGATORY MODIF ID sp1,       " Error File Path
  i_file TYPE rlgrap-filename OBLIGATORY MODIF ID sp1.       " Information file path
*  p_mode TYPE c OBLIGATORY DEFAULT 'N' MODIF ID sp1.         " Mode
SELECTION-SCREEN END OF BLOCK blck.

SELECTION-SCREEN BEGIN OF BLOCK b1.
PARAMETERS : p_gl     TYPE c RADIOBUTTON GROUP r1 DEFAULT 'X' USER-COMMAND fcode,
             p_c      TYPE c RADIOBUTTON GROUP r1,
             p_v      TYPE c RADIOBUTTON GROUP r1,
             p_c_dwn  TYPE c RADIOBUTTON GROUP r1,
             p_v_dwn  TYPE c RADIOBUTTON GROUP r1,
             p_c_dwn1 TYPE c RADIOBUTTON GROUP r1, "customer downpay for 1000 cc
             p_v_dwn1 TYPE c RADIOBUTTON GROUP r1. "vendor downpay for 1000 cc

SELECTION-SCREEN END OF BLOCK b1.


AT SELECTION-SCREEN OUTPUT.
  CLEAR : p_file, e_file, i_file.

* Opening window for path selection
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

*Opening window for Error file download
AT SELECTION-SCREEN ON VALUE-REQUEST FOR e_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = e_file.

*Opening window for Information file download
AT SELECTION-SCREEN ON VALUE-REQUEST FOR i_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = i_file.

START-OF-SELECTION.
  REFRESH : t_info, it_output, t_field6, t_field, t_field1, t_field2, t_field3, t_field11, t_field12.
  CLEAR: temp_item_no_1, temp_item_no_2, fs_field6, fs_field, fs_field1, fs_field2, fs_field3, fs_field11, fs_field12.

  IF p_gl IS NOT INITIAL.
    PERFORM gl_transfer.

  ELSEIF p_c IS NOT INITIAL.
    PERFORM customer_open_item_invoice.

  ELSEIF p_v IS NOT INITIAL.
    PERFORM vendor_open_item_invoice.

  ELSEIF p_c_dwn IS NOT INITIAL.
    PERFORM customer_open_item_down_pamt.

  ELSEIF p_v_dwn IS NOT INITIAL.
    PERFORM vendor_open_item_down_pamt.

  ELSEIF p_c_dwn1 IS NOT INITIAL.
    PERFORM customer_open_item_down_pamt_s.

  ELSEIF p_v_dwn1 IS NOT INITIAL.
    PERFORM vendor_open_item_down_pamt_s.

  ENDIF.

  PERFORM download_info_file.
  PERFORM download_error_file.

**************  End of Code *******************************


*----------------------------------------------------------
FORM download_info_file.
  IF t_info[] IS NOT INITIAL.
    CONCATENATE i_file '.xls' INTO wa_inf.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
*       BIN_FILESIZE          =
        filename              = wa_inf
        filetype              = 'ASC'
*       APPEND                = ' '
        write_field_separator = 'X'
      TABLES
        data_tab              = t_info
*
      .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.                           " IF sy-subrc <> 0.
  ENDIF.

ENDFORM.

FORM download_error_file.
  IF it_output[] IS NOT INITIAL.
    CONCATENATE e_file '.xls' INTO wa_error.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
*       BIN_FILESIZE          =
        filename              = wa_error
        filetype              = 'ASC'
*       APPEND                = ' '
        write_field_separator = 'X'
      TABLES
        data_tab              = it_output
*
      .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.                           " IF sy-subrc <> 0.

  ENDIF.
ENDFORM.

FORM convert_data_to_itab TABLES field TYPE STANDARD TABLE.

  DATA i_field_seperator    TYPE char01 VALUE 'X'.
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = i_field_seperator
*     I_LINE_HEADER        =
      i_tab_raw_data       = w_struct
      i_filename           = p_file
    TABLES
      i_tab_converted_data = field
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM .
*&---------------------------------------------------------------------*
*&      Form  GL_TRANSFER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM gl_transfer .

  DATA : temp_text TYPE string.
  PERFORM convert_data_to_itab TABLES t_field6 .

  MOVE 1 TO temp_item_no_1.
  MOVE 2 TO temp_item_no_2.
  LOOP AT t_field6 INTO fs_field6.

    CLEAR: wa_acctgl, wa_curramt, wa_docheader, wa_return.
    REFRESH: lt_acctgl, lt_curramt, lt_return.

    wa_docheader-username = sy-uname.
    wa_docheader-header_txt = fs_field6-bktxt.
    wa_docheader-comp_code =  fs_field6-bukrs.
*      CONCATENATE fs_field6-bldat+6(2) fs_field6-bldat+4(2) fs_field6-bldat(4) INTO wa_docheader-doc_date.
    wa_docheader-doc_date =   fs_field6-bldat.
*      CONCATENATE fs_field6-budat+6(2) fs_field6-budat+4(2) fs_field6-budat(4) INTO wa_docheader-pstng_date .
    wa_docheader-pstng_date = fs_field6-budat.
    wa_docheader-ref_doc_no = fs_field6-xblnr.
    wa_docheader-doc_type = fs_field6-blart.

    " GL line item 1
    CLEAR wa_acctgl.
    wa_acctgl-itemno_acc = temp_item_no_1.
*      wa_acctgl-gl_account = fs_field6-newbs_1.
    wa_acctgl-gl_account = fs_field6-newko_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_acctgl-gl_account
      IMPORTING
        output = wa_acctgl-gl_account.
    wa_acctgl-item_text = fs_field6-sgtxt_1.
    wa_acctgl-comp_code  = fs_field6-bukrs.
    wa_acctgl-bus_area =  fs_field6-gsber_1.
*      CONCATENATE fs_field6-valut+6(2) fs_field6-valut+4(2) fs_field6-valut(4) INTO wa_acctgl-value_date .
    wa_acctgl-value_date = fs_field6-valut.
    wa_acctgl-alloc_nmbr = fs_field6-zuonr_1.
*      wa_acctgl-tax_code = fs_field6-zterm_1.
    wa_acctgl-costcenter = fs_field6-kostl.
    APPEND wa_acctgl TO lt_acctgl.

    " GL line item 2
    CLEAR wa_acctgl.
    wa_acctgl-itemno_acc = temp_item_no_2.
    wa_acctgl-gl_account = fs_field6-newko_2.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_acctgl-gl_account
      IMPORTING
        output = wa_acctgl-gl_account.
    wa_acctgl-item_text = fs_field6-sgtxt_2.
    wa_acctgl-comp_code = fs_field6-bukrs.
    wa_acctgl-bus_area = fs_field6-gsber_2.
    wa_acctgl-value_date = fs_field6-valut.
    wa_acctgl-alloc_nmbr = fs_field6-zuonr_2.
*    wa_acctgl-costcenter = fs_field6-kostl.
    APPEND wa_acctgl TO lt_acctgl.

    " GL line item 1
    IF fs_field6-newbs_1 EQ '40'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '00'.
      wa_curramt-currency = fs_field6-waers.
      wa_curramt-amt_doccur = fs_field6-wrbtr_1.
*      wa_curramt-amt_base = fs_field6-wrbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
      IF wa_curramt-currency NE 'INR'.
        CLEAR wa_curramt.
        wa_curramt-itemno_acc = temp_item_no_1.
        wa_curramt-curr_type = '10'.
        wa_curramt-currency = 'INR'. "fs_field6-waers.
        wa_curramt-amt_doccur = fs_field6-dmbtr_1.
*      wa_curramt-amt_base = fs_field6-dmbtr_1.  " Ask Anantha
        APPEND wa_curramt TO lt_curramt.
      ENDIF.
    ELSE.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '00'.
      wa_curramt-currency = fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field6-wrbtr_1.
*      wa_curramt-amt_base = fs_field6-wrbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
      IF wa_curramt-currency NE 'INR'.
        CLEAR wa_curramt.
        wa_curramt-itemno_acc = temp_item_no_1.
        wa_curramt-curr_type = '10'.
        wa_curramt-currency = 'INR'. "fs_field6-waers.
        wa_curramt-amt_doccur = - fs_field6-dmbtr_1.
*      wa_curramt-amt_base = fs_field6-dmbtr_1.  " Ask Anantha
        APPEND wa_curramt TO lt_curramt.
      ENDIF.
    ENDIF.

    " GL line item 2
    IF fs_field6-newbs_2 EQ '40'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '00'.
      wa_curramt-currency = fs_field6-waers.
      wa_curramt-amt_doccur = fs_field6-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
      IF wa_curramt-currency NE 'INR'.
        CLEAR wa_curramt.
        wa_curramt-itemno_acc = temp_item_no_2.
        wa_curramt-curr_type = '10'.
        wa_curramt-currency = 'INR'. "fs_field6-waers.
        wa_curramt-amt_doccur = fs_field6-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
        APPEND wa_curramt TO lt_curramt.
      ENDIF.
    ELSE.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '00'.
      wa_curramt-currency = fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field6-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
      IF wa_curramt-currency NE 'INR'.
        CLEAR wa_curramt.
        wa_curramt-itemno_acc = temp_item_no_2.
        wa_curramt-curr_type = '10'.
        wa_curramt-currency = 'INR'. "fs_field6-waers.
        wa_curramt-amt_doccur = - fs_field6-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
        APPEND wa_curramt TO lt_curramt.
      ENDIF.
    ENDIF.


    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader = wa_docheader
      TABLES
        accountgl      = lt_acctgl
        currencyamount = lt_curramt
        return         = lt_return.
    IF sy-subrc = 0.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF  sy-subrc EQ 0.
        LOOP AT lt_return INTO x_return.
          CLEAR : wa_output, temp_text.
*Error message in downloaded file
          MOVE fs_field6-wrbtr_1 TO temp_text .
          CONCATENATE fs_field6-bktxt temp_text x_return-message  INTO wa_output-msg_err SEPARATED BY space.
          APPEND wa_output-msg_err TO it_output.
          CLEAR wa_output.
        ENDLOOP.

      ELSE.
        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader = wa_docheader
*           CUSTOMERCPD    = CUSTOMERCPD
*           CONTRACTHEADER = CONTRACTHEADER
          IMPORTING
*           OBJ_TYPE       = OBJ_TYPE
            obj_key        = obj_key
*           OBJ_SYS        = OBJ_SYS
          TABLES
            accountgl      = lt_acctgl
*           ACCOUNTRECEIVABLE       = ACCOUNTRECEIVABLE
*           ACCOUNTPAYABLE = ACCOUNTPAYABLE
*           ACCOUNTTAX     = ACCOUNTTAX
            currencyamount = lt_curramt
*           CRITERIA       = CRITERIA
*           VALUEFIELD     = VALUEFIELD
*           EXTENSION1     = EXTENSION1
            return         = lt_return
*           PAYMENTCARD    = PAYMENTCARD
*           CONTRACTITEM   = CONTRACTITEM
*           EXTENSION2     = EXTENSION2
*           REALESTATE     = REALESTATE
*           ACCOUNTWT      = ACCOUNTWT
          .
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          IF sy-subrc EQ 0.
            LOOP AT lt_return INTO x_return.
              CLEAR wa_info.
              wa_info-info_msg  = x_return-message.
              APPEND wa_info-info_msg TO t_info.
              CLEAR wa_info.
*              WRITE :/1 x_return-message.
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            CLEAR wa_output.
*Error message in downloaded file
            CONCATENATE 'G/L-'
                        fs_field6-newko_1
                        'with Doc head txt/Ref./Text-'
                        fs_field6-bktxt '/'
                        fs_field6-xblnr '/'
                        fs_field6-sgtxt_1
            INTO wa_output-msg_err SEPARATED BY space.
            APPEND wa_output-msg_err TO it_output.
            CLEAR wa_output.
          ENDIF.
        ENDIF.
*        ELSE.
*          LOOP AT lt_return INTO x_return.
*            CLEAR wa_output.
**Error message in downloaded file
*            CONCATENATE x_return-message '.' INTO wa_output-msg_err SEPARATED BY space.
*            APPEND wa_output-msg_err TO it_output.
*            CLEAR wa_output.
*          ENDLOOP.
      ENDIF.
    ENDIF.
    CLEAR : fs_field6.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CUSTOMER_OPEN_ITEM_INVOICE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM customer_open_item_invoice .



*  All necessary fields for Customer invoices will be considerd.
* Populate header data of document

  CLEAR: temp_item_no_1, temp_item_no_2.
  PERFORM convert_data_to_itab TABLES t_field .
  MOVE 1 TO temp_item_no_1.
  MOVE 2 TO temp_item_no_2.
  LOOP AT t_field INTO fs_field.

    CLEAR: wa_cust_inv, wa_curramt, wa_docheader, wa_return.
    REFRESH: lt_cust_inv, lt_curramt, lt_return.

    wa_docheader-username = sy-uname.
    wa_docheader-header_txt = fs_field-bktxt.
    wa_docheader-comp_code = fs_field-bukrs.
*      CONCATENATE fs_field-bldat+6(2) fs_field-bldat+4(2) fs_field-bldat(4) INTO wa_docheader-doc_date.
    wa_docheader-doc_date = fs_field-bldat.
*      CONCATENATE fs_field-budat+6(2) fs_field-budat+4(2) fs_field-budat(4) INTO wa_docheader-pstng_date.
    wa_docheader-pstng_date = fs_field-budat.
    wa_docheader-ref_doc_no = fs_field-xblnr.
    wa_docheader-doc_type = fs_field-blart.

    " Cust line item invoice 1
    wa_cust_inv-itemno_acc = temp_item_no_1.
    wa_cust_inv-customer = fs_field-newko_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_cust_inv-customer
      IMPORTING
        output = wa_cust_inv-customer.
    wa_cust_inv-bline_date = fs_field-zfbdt.
*      CONCATENATE fs_field-zfbdt+6(2) fs_field-zfbdt+4(2) fs_field-zfbdt(4) INTO wa_cust_inv-bline_date .
    wa_cust_inv-bus_area =  fs_field-gsber_1.
    wa_cust_inv-businessplace = fs_field-bupla.
    wa_cust_inv-sectioncode = fs_field-secco.
    wa_cust_inv-comp_code = fs_field-bukrs.
    wa_cust_inv-alloc_nmbr = fs_field-zuonr_1.
    wa_cust_inv-item_text = fs_field-sgtxt_1.
    wa_cust_inv-pmnttrms = fs_field-zterm_1.
    APPEND wa_cust_inv TO lt_cust_inv.

    "Cust line item invoice 2
    CLEAR wa_cust_inv.
    wa_cust_inv-itemno_acc = temp_item_no_2.
    wa_cust_inv-gl_account = fs_field-newko_2.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_cust_inv-gl_account
      IMPORTING
        output = wa_cust_inv-gl_account.
    wa_cust_inv-comp_code = fs_field-bukrs.
    wa_cust_inv-bus_area = fs_field-gsber_2.
*      wa_cust_inv-pmnttrms = fs_field-zterm_2.
    wa_cust_inv-alloc_nmbr = fs_field-zuonr_2.
    wa_cust_inv-item_text = fs_field-sgtxt_2.
    APPEND wa_cust_inv TO lt_cust_inv.

    "Cust G/L line item 1
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_1.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field-waers.
    wa_curramt-amt_doccur = fs_field-wrbtr_1.
*      wa_curramt-amt_base = fs_field-wrbtr_1.  " Ask Anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field-waers.
      wa_curramt-amt_doccur = fs_field-dmbtr_1.
*      wa_curramt-amt_base = fs_field-dmbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    "Cust G/L line item 2
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_2.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field-waers.
    wa_curramt-amt_doccur = - fs_field-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader    = wa_docheader
*       CUSTOMERCPD       = CUSTOMERCPD
*       CONTRACTHEADER    = CONTRACTHEADER
      TABLES
*       accountgl         = lt_acctgl
        accountreceivable = lt_cust_inv
*       ACCOUNTPAYABLE    = ACCOUNTPAYABLE
*       ACCOUNTTAX        = ACCOUNTTAX
        currencyamount    = lt_curramt
*       CRITERIA          = CRITERIA
*       VALUEFIELD        = VALUEFIELD
*       EXTENSION1        = EXTENSION1
        return            = lt_return
*       PAYMENTCARD       = PAYMENTCARD
*       CONTRACTITEM      = CONTRACTITEM
*       EXTENSION2        = EXTENSION2
*       REALESTATE        = REALESTATE
*       ACCOUNTWT         = ACCOUNTWT
      .
    IF sy-subrc = 0.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF  sy-subrc EQ 0.
        LOOP AT lt_return INTO x_return.
          CLEAR wa_output.
*Error message in downloaded file
          CONCATENATE x_return-message '.' INTO wa_output-msg_err SEPARATED BY space.
          APPEND wa_output-msg_err TO it_output.
          CLEAR wa_output.
        ENDLOOP.

      ELSE.
        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader    = wa_docheader
*           CUSTOMERCPD       = CUSTOMERCPD
*           CONTRACTHEADER    = CONTRACTHEADER
          IMPORTING
*           OBJ_TYPE          = OBJ_TYPE
            obj_key           = obj_key
*           OBJ_SYS           = OBJ_SYS
          TABLES
*           accountgl         = lt_acctgl
            accountreceivable = lt_cust_inv
*           ACCOUNTPAYABLE    = ACCOUNTPAYABLE
*           ACCOUNTTAX        = ACCOUNTTAX
            currencyamount    = lt_curramt
*           CRITERIA          = CRITERIA
*           VALUEFIELD        = VALUEFIELD
*           EXTENSION1        = EXTENSION1
            return            = lt_return
*           PAYMENTCARD       = PAYMENTCARD
*           CONTRACTITEM      = CONTRACTITEM
*           EXTENSION2        = EXTENSION2
*           REALESTATE        = REALESTATE
*           ACCOUNTWT         = ACCOUNTWT
          .
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          IF sy-subrc EQ 0.
            LOOP AT lt_return INTO x_return.
              CLEAR wa_info.
              wa_info-info_msg  = x_return-message.
              APPEND wa_info-info_msg TO t_info.
              CLEAR wa_info.
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            CLEAR wa_output.
*Error message in downloaded file
            CONCATENATE 'Customer-'
                        fs_field-newko_1
                        'with Doc head txt/Ref./Text-'
                        fs_field-bktxt '/'
                        fs_field-xblnr '/'
                        fs_field-sgtxt_1
            INTO wa_output-msg_err SEPARATED BY space.
            APPEND wa_output-msg_err TO it_output.
            CLEAR wa_output.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: fs_field.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VENDOR_OPEN_ITEM_INVOICE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM vendor_open_item_invoice .


  CLEAR: temp_item_no_1, temp_item_no_2.
  PERFORM convert_data_to_itab TABLES t_field1 .
*  All necessary fields for vendor invoices will be considerd.
* Populate header data of document
  MOVE 1 TO temp_item_no_1.
  MOVE 2 TO temp_item_no_2.
  LOOP AT t_field1 INTO fs_field1.

    CLEAR: wa_vend_inv, wa_curramt, wa_docheader, wa_return.
    REFRESH: lt_vend_inv, lt_curramt, lt_return.

    wa_docheader-username = sy-uname.
    wa_docheader-header_txt = fs_field1-bktxt.
    wa_docheader-comp_code = fs_field1-bukrs.
*      CONCATENATE fs_field1-bldat+6(2) fs_field1-bldat+4(2) fs_field1-bldat(4) INTO wa_docheader-doc_date.
    wa_docheader-doc_date = fs_field1-bldat.
*      CONCATENATE fs_field1-budat+6(2) fs_field1-budat+4(2) fs_field1-budat(4) INTO wa_docheader-pstng_date.
    wa_docheader-pstng_date = fs_field1-budat.
    wa_docheader-ref_doc_no = fs_field1-xblnr.
    wa_docheader-doc_type = fs_field1-blart.

    " Vend line item invoice 1
    wa_vend_inv-itemno_acc = temp_item_no_1.
    wa_vend_inv-vendor_no = fs_field1-newko_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_vend_inv-vendor_no
      IMPORTING
        output = wa_vend_inv-vendor_no.

*      CONCATENATE fs_field1-zfbdt+6(2) fs_field1-zfbdt+4(2) fs_field1-zfbdt(4) INTO wa_vend_inv-bline_date.
    wa_vend_inv-bline_date = fs_field1-zfbdt.
    wa_vend_inv-bus_area =  fs_field1-gsber_1.
    wa_vend_inv-businessplace = fs_field1-bupla.
    wa_vend_inv-sectioncode = fs_field1-secco.
    wa_vend_inv-comp_code = fs_field1-bukrs.
    wa_vend_inv-alloc_nmbr = fs_field1-zuonr_1.
    wa_vend_inv-item_text = fs_field1-sgtxt_1.
    wa_vend_inv-pmnttrms = fs_field1-zterm_1.
    APPEND wa_vend_inv TO lt_vend_inv.


    "Vend line item invoice 2
    CLEAR wa_vend_inv.
    wa_vend_inv-itemno_acc = temp_item_no_2.
    wa_vend_inv-gl_account = fs_field1-newko_2.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_vend_inv-gl_account
      IMPORTING
        output = wa_vend_inv-gl_account.
    wa_vend_inv-comp_code = fs_field1-bukrs.
    wa_vend_inv-bus_area =  fs_field1-gsber_2.
*      wa_vend_inv-pmnttrms = fs_field1-zterm_2.
    wa_vend_inv-alloc_nmbr = fs_field1-zuonr_2.
    wa_vend_inv-item_text = fs_field1-sgtxt_2.
    APPEND wa_vend_inv TO lt_vend_inv.

    "Vend G/L line item 1
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_1.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field1-waers.
    wa_curramt-amt_doccur = fs_field1-wrbtr_1.
*      wa_curramt-amt_base = fs_field-wrbtr_1.  " Ask Anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field-waers.
      wa_curramt-amt_doccur = fs_field1-dmbtr_1.
*      wa_curramt-amt_base = fs_field-dmbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    "Vend G/L line item 2
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_2.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field1-waers.
    wa_curramt-amt_doccur = - fs_field1-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field1-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader = wa_docheader
*       CUSTOMERCPD    = CUSTOMERCPD
*       CONTRACTHEADER = CONTRACTHEADER
      TABLES
*       accountgl      = lt_acctgl
*       accountreceivable = lt_vend_inv
        accountpayable = lt_vend_inv
*       ACCOUNTTAX     = ACCOUNTTAX
        currencyamount = lt_curramt
*       CRITERIA       = CRITERIA
*       VALUEFIELD     = VALUEFIELD
*       EXTENSION1     = EXTENSION1
        return         = lt_return
*       PAYMENTCARD    = PAYMENTCARD
*       CONTRACTITEM   = CONTRACTITEM
*       EXTENSION2     = EXTENSION2
*       REALESTATE     = REALESTATE
*       ACCOUNTWT      = ACCOUNTWT
      .
    IF sy-subrc = 0.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF  sy-subrc EQ 0.
        LOOP AT lt_return INTO x_return.
          CLEAR wa_output.
*Error message in downloaded file
          CONCATENATE x_return-message '.' INTO wa_output-msg_err SEPARATED BY space.
          APPEND wa_output-msg_err TO it_output.
          CLEAR wa_output.
        ENDLOOP.
      ELSE.
        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader = wa_docheader
*           CUSTOMERCPD    = CUSTOMERCPD
*           CONTRACTHEADER = CONTRACTHEADER
          IMPORTING
*           OBJ_TYPE       = OBJ_TYPE
            obj_key        = obj_key
*           OBJ_SYS        = OBJ_SYS
          TABLES
*           accountgl      = lt_acctgl
*           accountreceivable = lt_vend_inv
            accountpayable = lt_vend_inv
*           ACCOUNTTAX     = ACCOUNTTAX
            currencyamount = lt_curramt
*           CRITERIA       = CRITERIA
*           VALUEFIELD     = VALUEFIELD
*           EXTENSION1     = EXTENSION1
            return         = lt_return
*           PAYMENTCARD    = PAYMENTCARD
*           CONTRACTITEM   = CONTRACTITEM
*           EXTENSION2     = EXTENSION2
*           REALESTATE     = REALESTATE
*           ACCOUNTWT      = ACCOUNTWT
          .
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          IF sy-subrc EQ 0.
            LOOP AT lt_return INTO x_return.
              CLEAR wa_info.
              wa_info-info_msg  = x_return-message.
              APPEND wa_info-info_msg TO t_info.
              CLEAR wa_info.
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            CLEAR wa_output.
*Error message in downloaded file
            CONCATENATE 'Vendor-'
                        fs_field1-newko_1
                        'with Doc head txt/Ref./Text-'
                        fs_field1-bktxt '/'
                        fs_field1-xblnr '/'
                        fs_field1-sgtxt_1
            INTO wa_output-msg_err SEPARATED BY space.
            APPEND wa_output-msg_err TO it_output.
            CLEAR wa_output.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: fs_field1.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CUSTOMER_OPEN_ITEM_DOWN_PAMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM customer_open_item_down_pamt .

*  All necessary fields for Customer Open Item Downpay for target Company Code will be considerd.
* Populate header data of document
  CLEAR: temp_item_no_1, temp_item_no_2.
  PERFORM convert_data_to_itab TABLES t_field2 .
  MOVE 1 TO temp_item_no_1.
  MOVE 2 TO temp_item_no_2.
  LOOP AT t_field2 INTO fs_field2.

    CLEAR: wa_vend_inv, wa_curramt, wa_docheader, wa_return.
    REFRESH: lt_vend_inv, lt_curramt, lt_return.

    "Customer Downpay Header data
    wa_docheader-username = sy-uname.
    wa_docheader-header_txt = fs_field2-bktxt.
    wa_docheader-comp_code = fs_field2-bukrs.
*      CONCATENATE fs_field1-bldat+6(2) fs_field1-bldat+4(2) fs_field1-bldat(4) INTO wa_docheader-doc_date.
    wa_docheader-doc_date = fs_field2-bldat.
*      CONCATENATE fs_field1-budat+6(2) fs_field1-budat+4(2) fs_field1-budat(4) INTO wa_docheader-pstng_date.
    wa_docheader-pstng_date = fs_field2-budat.
    wa_docheader-ref_doc_no = fs_field2-xblnr.
    wa_docheader-doc_type = fs_field2-blart.

    "Cust open item downpay line item 1
    wa_cust_inv-itemno_acc = temp_item_no_1.
    wa_cust_inv-customer = fs_field2-newko_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_cust_inv-customer
      IMPORTING
        output = wa_cust_inv-customer.
    wa_cust_inv-sp_gl_ind = fs_field2-newum.
*      wa_cust_inv-bline_date = fs_field2-zfbdt.
*      CONCATENATE fs_field-zfbdt+6(2) fs_field-zfbdt+4(2) fs_field-zfbdt(4) INTO wa_cust_inv-bline_date .
    wa_cust_inv-bus_area =  fs_field2-gsber_1.
    wa_cust_inv-businessplace = fs_field2-bupla.
    wa_cust_inv-sectioncode = fs_field2-secco.
    wa_cust_inv-comp_code = fs_field2-bukrs.
    wa_cust_inv-alloc_nmbr = fs_field2-zuonr_1.
    wa_cust_inv-item_text = fs_field2-sgtxt_1.
*      wa_cust_inv-pmnttrms = fs_field2-zterm_1.
    APPEND wa_cust_inv TO lt_cust_inv.

    "Cust Open item downpa line item 2
    CLEAR wa_cust_inv.
    wa_cust_inv-itemno_acc = temp_item_no_2.
    wa_cust_inv-gl_account = fs_field2-newko_2.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_cust_inv-gl_account
      IMPORTING
        output = wa_cust_inv-gl_account.
    wa_cust_inv-comp_code = fs_field2-bukrs.
    wa_cust_inv-bus_area = fs_field2-gsber_2.
*      wa_cust_inv-pmnttrms = fs_field-zterm_2.
    wa_cust_inv-alloc_nmbr = fs_field2-zuonr_2.
    wa_cust_inv-item_text = fs_field2-sgtxt_2.
    APPEND wa_cust_inv TO lt_cust_inv.

    "Cust G/L line open item downpay 1
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_1.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field2-waers.
    wa_curramt-amt_doccur = fs_field2-wrbtr_1.
*      wa_curramt-amt_base = fs_field-wrbtr_1.  " Ask Anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field-waers.
      wa_curramt-amt_doccur = fs_field2-dmbtr_1.
*      wa_curramt-amt_base = fs_field-dmbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    "Cust G/L line Open Item downpay 2
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_2.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field2-waers.
    wa_curramt-amt_doccur = - fs_field2-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field2-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader    = wa_docheader
*       CUSTOMERCPD       = CUSTOMERCPD
*       CONTRACTHEADER    = CONTRACTHEADER
      TABLES
*       accountgl         = lt_acctgl
        accountreceivable = lt_cust_inv
*       ACCOUNTPAYABLE    = ACCOUNTPAYABLE
*       ACCOUNTTAX        = ACCOUNTTAX
        currencyamount    = lt_curramt
*       CRITERIA          = CRITERIA
*       VALUEFIELD        = VALUEFIELD
*       EXTENSION1        = EXTENSION1
        return            = lt_return
*       PAYMENTCARD       = PAYMENTCARD
*       CONTRACTITEM      = CONTRACTITEM
*       EXTENSION2        = EXTENSION2
*       REALESTATE        = REALESTATE
*       ACCOUNTWT         = ACCOUNTWT
      .
    IF sy-subrc = 0.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF  sy-subrc EQ 0.
        LOOP AT lt_return INTO x_return.
          CLEAR wa_output.
*Error message in downloaded file
          CONCATENATE x_return-message '.' INTO wa_output-msg_err SEPARATED BY space.
          APPEND wa_output-msg_err TO it_output.
          CLEAR wa_output.
        ENDLOOP.

      ELSE.
        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader    = wa_docheader
*           CUSTOMERCPD       = CUSTOMERCPD
*           CONTRACTHEADER    = CONTRACTHEADER
          IMPORTING
*           OBJ_TYPE          = OBJ_TYPE
            obj_key           = obj_key
*           OBJ_SYS           = OBJ_SYS
          TABLES
*           accountgl         = lt_acctgl
            accountreceivable = lt_cust_inv
*           ACCOUNTPAYABLE    = ACCOUNTPAYABLE
*           ACCOUNTTAX        = ACCOUNTTAX
            currencyamount    = lt_curramt
*           CRITERIA          = CRITERIA
*           VALUEFIELD        = VALUEFIELD
*           EXTENSION1        = EXTENSION1
            return            = lt_return
*           PAYMENTCARD       = PAYMENTCARD
*           CONTRACTITEM      = CONTRACTITEM
*           EXTENSION2        = EXTENSION2
*           REALESTATE        = REALESTATE
*           ACCOUNTWT         = ACCOUNTWT
          .
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          IF sy-subrc EQ 0.
            LOOP AT lt_return INTO x_return.
              CLEAR wa_info.
              wa_info-info_msg  = x_return-message.
              APPEND wa_info-info_msg TO t_info.
              CLEAR wa_info.
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            CLEAR wa_output.
*Error message in downloaded file
            CONCATENATE 'Customer-'
                        fs_field2-newko_1
                        'with Doc head txt/Ref./Text-'
                        fs_field2-bktxt '/'
                        fs_field2-xblnr '/'
                        fs_field2-sgtxt_1
            INTO wa_output-msg_err SEPARATED BY space.
            APPEND wa_output-msg_err TO it_output.
            CLEAR wa_output.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: fs_field2.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VENDOR_OPEN_ITEM_DOWN_PAMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM vendor_open_item_down_pamt .

  CLEAR: temp_item_no_1, temp_item_no_2.
  PERFORM convert_data_to_itab TABLES t_field3 .
*  All necessary fields for vendor invoices will be considerd.
* Populate header data of document
  MOVE 1 TO temp_item_no_1.
  MOVE 2 TO temp_item_no_2.
  LOOP AT t_field3 INTO fs_field3.

    CLEAR: wa_vend_inv, wa_curramt, wa_docheader, wa_return.
    REFRESH: lt_vend_inv, lt_curramt, lt_return.

    wa_docheader-username = sy-uname.
    wa_docheader-header_txt = fs_field3-bktxt.
    wa_docheader-comp_code = fs_field3-bukrs.
*      CONCATENATE fs_field1-bldat+6(2) fs_field1-bldat+4(2) fs_field1-bldat(4) INTO wa_docheader-doc_date.
    wa_docheader-doc_date = fs_field3-bldat.
*      CONCATENATE fs_field1-budat+6(2) fs_field1-budat+4(2) fs_field1-budat(4) INTO wa_docheader-pstng_date.
    wa_docheader-pstng_date = fs_field3-budat.
    wa_docheader-ref_doc_no = fs_field3-xblnr.
    wa_docheader-doc_type = fs_field3-blart.

    " Vend line item invoice 1
    wa_vend_inv-itemno_acc = temp_item_no_1.
    wa_vend_inv-vendor_no = fs_field3-newko_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_vend_inv-vendor_no
      IMPORTING
        output = wa_vend_inv-vendor_no.
*      CONCATENATE fs_field1-zfbdt+6(2) fs_field1-zfbdt+4(2) fs_field1-zfbdt(4) INTO wa_vend_inv-bline_date.
*      wa_vend_inv-bline_date = fs_field3-zfbdt.
    wa_vend_inv-sp_gl_ind = fs_field3-newum.
    wa_vend_inv-bus_area =  fs_field3-gsber_1.
    wa_vend_inv-businessplace = fs_field3-bupla.
    wa_vend_inv-sectioncode = fs_field3-secco.
    wa_vend_inv-comp_code = fs_field3-bukrs.
    wa_vend_inv-alloc_nmbr = fs_field3-zuonr_1.
    wa_vend_inv-item_text = fs_field3-sgtxt_1.
*      wa_vend_inv-pmnttrms = fs_field3-zterm_1.
    APPEND wa_vend_inv TO lt_vend_inv.


    "Vend line item invoice 2
    CLEAR wa_vend_inv.
    wa_vend_inv-itemno_acc = temp_item_no_2.
    wa_vend_inv-gl_account = fs_field3-newko_2.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_vend_inv-gl_account
      IMPORTING
        output = wa_vend_inv-gl_account.
    wa_vend_inv-comp_code = fs_field3-bukrs.
    wa_vend_inv-bus_area =  fs_field3-gsber_2.
*      wa_vend_inv-pmnttrms = fs_field1-zterm_2.
    wa_vend_inv-alloc_nmbr = fs_field3-zuonr_2.
    wa_vend_inv-item_text = fs_field3-sgtxt_2.
    APPEND wa_vend_inv TO lt_vend_inv.

    "Vend G/L line item 1
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_1.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field3-waers.
    wa_curramt-amt_doccur = fs_field3-wrbtr_1.
*      wa_curramt-amt_base = fs_field-wrbtr_1.  " Ask Anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field-waers.
      wa_curramt-amt_doccur = fs_field3-dmbtr_1.
*      wa_curramt-amt_base = fs_field-dmbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    "Vend G/L line item 2
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_2.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field3-waers.
    wa_curramt-amt_doccur = - fs_field3-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field3-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader = wa_docheader
*       CUSTOMERCPD    = CUSTOMERCPD
*       CONTRACTHEADER = CONTRACTHEADER
      TABLES
*       accountgl      = lt_acctgl
*       accountreceivable = lt_vend_inv
        accountpayable = lt_vend_inv
*       ACCOUNTTAX     = ACCOUNTTAX
        currencyamount = lt_curramt
*       CRITERIA       = CRITERIA
*       VALUEFIELD     = VALUEFIELD
*       EXTENSION1     = EXTENSION1
        return         = lt_return
*       PAYMENTCARD    = PAYMENTCARD
*       CONTRACTITEM   = CONTRACTITEM
*       EXTENSION2     = EXTENSION2
*       REALESTATE     = REALESTATE
*       ACCOUNTWT      = ACCOUNTWT
      .
    IF sy-subrc = 0.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF  sy-subrc EQ 0.
        LOOP AT lt_return INTO x_return.
          CLEAR wa_output.
*Error message in downloaded file
          CONCATENATE x_return-message '.' INTO wa_output-msg_err SEPARATED BY space.
          APPEND wa_output-msg_err TO it_output.
          CLEAR wa_output.
        ENDLOOP.
      ELSE.
        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader = wa_docheader
*           CUSTOMERCPD    = CUSTOMERCPD
*           CONTRACTHEADER = CONTRACTHEADER
          IMPORTING
*           OBJ_TYPE       = OBJ_TYPE
            obj_key        = obj_key
*           OBJ_SYS        = OBJ_SYS
          TABLES
*           accountgl      = lt_acctgl
*           accountreceivable = lt_vend_inv
            accountpayable = lt_vend_inv
*           ACCOUNTTAX     = ACCOUNTTAX
            currencyamount = lt_curramt
*           CRITERIA       = CRITERIA
*           VALUEFIELD     = VALUEFIELD
*           EXTENSION1     = EXTENSION1
            return         = lt_return
*           PAYMENTCARD    = PAYMENTCARD
*           CONTRACTITEM   = CONTRACTITEM
*           EXTENSION2     = EXTENSION2
*           REALESTATE     = REALESTATE
*           ACCOUNTWT      = ACCOUNTWT
          .
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          IF sy-subrc EQ 0.
            LOOP AT lt_return INTO x_return.
              CLEAR wa_info.
              wa_info-info_msg  = x_return-message.
              APPEND wa_info-info_msg TO t_info.
              CLEAR wa_info.
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            CLEAR wa_output.
*Error message in downloaded file
            CONCATENATE 'Vendor-'
                        fs_field3-newko_1
                        'with Doc head txt/Ref./Text-'
                        fs_field3-bktxt '/'
                        fs_field3-xblnr '/'
                        fs_field3-sgtxt_1
            INTO wa_output-msg_err SEPARATED BY space.
            APPEND wa_output-msg_err TO it_output.
            CLEAR wa_output.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: fs_field3.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CUSTOMER_OPEN_ITEM_DOWN_PAMT_S
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM customer_open_item_down_pamt_s .

*  All necessary fields for Customer open item downpay source F-02 will be considerd.
* Populate header data of document
  CLEAR: temp_item_no_1, temp_item_no_2.
  PERFORM convert_data_to_itab TABLES t_field11 .
  MOVE 1 TO temp_item_no_1.
  MOVE 2 TO temp_item_no_2.
  LOOP AT t_field11 INTO fs_field11.

    CLEAR: wa_cust_inv, wa_curramt, wa_docheader, wa_return.
    REFRESH: lt_cust_inv, lt_curramt, lt_return.

    wa_docheader-username = sy-uname.
    wa_docheader-header_txt = fs_field11-bktxt.
    wa_docheader-comp_code = fs_field11-bukrs.
*      CONCATENATE fs_field-bldat+6(2) fs_field-bldat+4(2) fs_field-bldat(4) INTO wa_docheader-doc_date.
    wa_docheader-doc_date = fs_field11-bldat.
*      CONCATENATE fs_field-budat+6(2) fs_field-budat+4(2) fs_field-budat(4) INTO wa_docheader-pstng_date.
    wa_docheader-pstng_date = fs_field11-budat.
    wa_docheader-ref_doc_no = fs_field11-xblnr.
    wa_docheader-doc_type = fs_field11-blart.

    " Cust line item invoice 1
    wa_cust_inv-itemno_acc = temp_item_no_1.
    wa_cust_inv-customer = fs_field11-newko_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_cust_inv-customer
      IMPORTING
        output = wa_cust_inv-customer.
    wa_cust_inv-sp_gl_ind = fs_field11-newum.
*      wa_cust_inv-bline_date = fs_field11-zfbdt.
*      CONCATENATE fs_field-zfbdt+6(2) fs_field-zfbdt+4(2) fs_field-zfbdt(4) INTO wa_cust_inv-bline_date .
    wa_cust_inv-bus_area =  fs_field11-gsber_1.
    wa_cust_inv-businessplace = fs_field11-bupla.
    wa_cust_inv-sectioncode = fs_field11-secco.
    wa_cust_inv-comp_code = fs_field11-bukrs.
    wa_cust_inv-alloc_nmbr = fs_field11-zuonr_1.
    wa_cust_inv-item_text = fs_field11-sgtxt_1.
*      wa_cust_inv-pmnttrms = fs_field11-zterm_1.
    APPEND wa_cust_inv TO lt_cust_inv.


    "Cust line item invoice 2
    CLEAR wa_cust_inv.
    wa_cust_inv-itemno_acc = temp_item_no_2.
    wa_cust_inv-gl_account = fs_field11-newko_2.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_cust_inv-gl_account
      IMPORTING
        output = wa_cust_inv-gl_account.
    wa_cust_inv-comp_code = fs_field11-bukrs.
    wa_cust_inv-bus_area = fs_field11-gsber_2.
*      wa_cust_inv-pmnttrms = fs_field-zterm_2.
    wa_cust_inv-alloc_nmbr = fs_field11-zuonr_2.
    wa_cust_inv-item_text = fs_field11-sgtxt_2.
    APPEND wa_cust_inv TO lt_cust_inv.

    "Cust G/L line item 1
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_1.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field11-waers.
    wa_curramt-amt_doccur = fs_field11-wrbtr_1.
*      wa_curramt-amt_base = fs_field-wrbtr_1.  " Ask Anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field-waers.
      wa_curramt-amt_doccur = fs_field11-dmbtr_1.
*      wa_curramt-amt_base = fs_field-dmbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    "Cust G/L line item 2
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_2.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field11-waers.
    wa_curramt-amt_doccur = - fs_field11-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field11-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader    = wa_docheader
*       CUSTOMERCPD       = CUSTOMERCPD
*       CONTRACTHEADER    = CONTRACTHEADER
      TABLES
*       accountgl         = lt_acctgl
        accountreceivable = lt_cust_inv
*       ACCOUNTPAYABLE    = ACCOUNTPAYABLE
*       ACCOUNTTAX        = ACCOUNTTAX
        currencyamount    = lt_curramt
*       CRITERIA          = CRITERIA
*       VALUEFIELD        = VALUEFIELD
*       EXTENSION1        = EXTENSION1
        return            = lt_return
*       PAYMENTCARD       = PAYMENTCARD
*       CONTRACTITEM      = CONTRACTITEM
*       EXTENSION2        = EXTENSION2
*       REALESTATE        = REALESTATE
*       ACCOUNTWT         = ACCOUNTWT
      .
    IF sy-subrc = 0.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF  sy-subrc EQ 0.
        LOOP AT lt_return INTO x_return.
          CLEAR wa_output.
*Error message in downloaded file
          CONCATENATE x_return-message '.' INTO wa_output-msg_err SEPARATED BY space.
          APPEND wa_output-msg_err TO it_output.
          CLEAR wa_output.
        ENDLOOP.

      ELSE.
        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader    = wa_docheader
*           CUSTOMERCPD       = CUSTOMERCPD
*           CONTRACTHEADER    = CONTRACTHEADER
          IMPORTING
*           OBJ_TYPE          = OBJ_TYPE
            obj_key           = obj_key
*           OBJ_SYS           = OBJ_SYS
          TABLES
*           accountgl         = lt_acctgl
            accountreceivable = lt_cust_inv
*           ACCOUNTPAYABLE    = ACCOUNTPAYABLE
*           ACCOUNTTAX        = ACCOUNTTAX
            currencyamount    = lt_curramt
*           CRITERIA          = CRITERIA
*           VALUEFIELD        = VALUEFIELD
*           EXTENSION1        = EXTENSION1
            return            = lt_return
*           PAYMENTCARD       = PAYMENTCARD
*           CONTRACTITEM      = CONTRACTITEM
*           EXTENSION2        = EXTENSION2
*           REALESTATE        = REALESTATE
*           ACCOUNTWT         = ACCOUNTWT
          .
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          IF sy-subrc EQ 0.
            LOOP AT lt_return INTO x_return.
              CLEAR wa_info.
              wa_info-info_msg  = x_return-message.
              APPEND wa_info-info_msg TO t_info.
              CLEAR wa_info.
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            CLEAR wa_output.
*Error message in downloaded file
            CONCATENATE 'Customer-'
                        fs_field11-newko_1
                        'with Doc head txt/Ref./Text-'
                        fs_field11-bktxt '/'
                        fs_field11-xblnr '/'
                        fs_field11-sgtxt_1
            INTO wa_output-msg_err SEPARATED BY space.
            APPEND wa_output-msg_err TO it_output.
            CLEAR wa_output.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: fs_field11.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VENDOR_OPEN_ITEM_DOWN_PAMT_S
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM vendor_open_item_down_pamt_s .

*  All necessary fields for vendor open item invoices downpay source F-02 will be considerd.
* Populate header data of document
  CLEAR: temp_item_no_1, temp_item_no_2.
  PERFORM convert_data_to_itab TABLES t_field12 .
  MOVE 1 TO temp_item_no_1.
  MOVE 2 TO temp_item_no_2.
  LOOP AT t_field12 INTO fs_field12.

    CLEAR: wa_vend_inv, wa_curramt, wa_docheader, wa_return.
    REFRESH: lt_vend_inv, lt_curramt, lt_return.

    wa_docheader-username = sy-uname.
    wa_docheader-header_txt = fs_field12-bktxt.
    wa_docheader-comp_code = fs_field12-bukrs.
*      CONCATENATE fs_field1-bldat+6(2) fs_field1-bldat+4(2) fs_field1-bldat(4) INTO wa_docheader-doc_date.
    wa_docheader-doc_date = fs_field12-bldat.
*      CONCATENATE fs_field1-budat+6(2) fs_field1-budat+4(2) fs_field1-budat(4) INTO wa_docheader-pstng_date.
    wa_docheader-pstng_date = fs_field12-budat.
    wa_docheader-ref_doc_no = fs_field12-xblnr.
    wa_docheader-doc_type = fs_field12-blart.

    " Vend line item invoice 1
    wa_vend_inv-itemno_acc = temp_item_no_1.
    wa_vend_inv-vendor_no = fs_field12-newko_1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_vend_inv-vendor_no
      IMPORTING
        output = wa_vend_inv-vendor_no.
*      CONCATENATE fs_field1-zfbdt+6(2) fs_field1-zfbdt+4(2) fs_field1-zfbdt(4) INTO wa_vend_inv-bline_date.
    wa_vend_inv-sp_gl_ind = fs_field12-newum.
*      wa_vend_inv-bline_date = fs_field12-zfbdt.
    wa_vend_inv-bus_area =  fs_field12-gsber_1.
    wa_vend_inv-businessplace = fs_field12-bupla.
    wa_vend_inv-sectioncode = fs_field12-secco.
    wa_vend_inv-comp_code = fs_field12-bukrs.
    wa_vend_inv-alloc_nmbr = fs_field12-zuonr_1.
    wa_vend_inv-item_text = fs_field12-sgtxt_1.
*      wa_vend_inv-pmnttrms = fs_field3-zterm_1.
    APPEND wa_vend_inv TO lt_vend_inv.


    "Vend line item invoice 2
    CLEAR wa_vend_inv.
    wa_vend_inv-itemno_acc = temp_item_no_2.
    wa_vend_inv-gl_account = fs_field12-newko_2.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_vend_inv-gl_account
      IMPORTING
        output = wa_vend_inv-gl_account.
    wa_vend_inv-comp_code = fs_field12-bukrs.
    wa_vend_inv-bus_area =  fs_field12-gsber_2.
*      wa_vend_inv-pmnttrms = fs_field1-zterm_2.
    wa_vend_inv-alloc_nmbr = fs_field12-zuonr_2.
    wa_vend_inv-item_text = fs_field12-sgtxt_2.
    APPEND wa_vend_inv TO lt_vend_inv.

    "Vend G/L line item 1
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_1.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field12-waers.
    wa_curramt-amt_doccur = fs_field12-wrbtr_1.
*      wa_curramt-amt_base = fs_field-wrbtr_1.  " Ask Anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_1.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field-waers.
      wa_curramt-amt_doccur = fs_field12-dmbtr_1.
*      wa_curramt-amt_base = fs_field-dmbtr_1.  " Ask Anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    "Vend G/L line item 2
    CLEAR wa_curramt.
    wa_curramt-itemno_acc = temp_item_no_2.
    wa_curramt-curr_type = '00'.
    wa_curramt-currency = fs_field12-waers.
    wa_curramt-amt_doccur = - fs_field12-wrbtr_2.
*      wa_curramt-amt_base = fs_field6-wrbtr_2. " ask anantha
    APPEND wa_curramt TO lt_curramt.

    IF wa_curramt-currency NE 'INR'.
      CLEAR wa_curramt.
      wa_curramt-itemno_acc = temp_item_no_2.
      wa_curramt-curr_type = '10'.
      wa_curramt-currency = 'INR'. "fs_field6-waers.
      wa_curramt-amt_doccur = - fs_field12-dmbtr_2.
*      wa_curramt-amt_base = fs_field6-dmbtr_2. " ask anantha
      APPEND wa_curramt TO lt_curramt.
    ENDIF.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader = wa_docheader
*       CUSTOMERCPD    = CUSTOMERCPD
*       CONTRACTHEADER = CONTRACTHEADER
      TABLES
*       accountgl      = lt_acctgl
*       accountreceivable = lt_vend_inv
        accountpayable = lt_vend_inv
*       ACCOUNTTAX     = ACCOUNTTAX
        currencyamount = lt_curramt
*       CRITERIA       = CRITERIA
*       VALUEFIELD     = VALUEFIELD
*       EXTENSION1     = EXTENSION1
        return         = lt_return
*       PAYMENTCARD    = PAYMENTCARD
*       CONTRACTITEM   = CONTRACTITEM
*       EXTENSION2     = EXTENSION2
*       REALESTATE     = REALESTATE
*       ACCOUNTWT      = ACCOUNTWT
      .
    IF sy-subrc = 0.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF  sy-subrc EQ 0.
        LOOP AT lt_return INTO x_return.
          CLEAR wa_output.
*Error message in downloaded file
          CONCATENATE x_return-message '.' INTO wa_output-msg_err SEPARATED BY space.
          APPEND wa_output-msg_err TO it_output.
          CLEAR wa_output.
        ENDLOOP.
      ELSE.
        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader = wa_docheader
*           CUSTOMERCPD    = CUSTOMERCPD
*           CONTRACTHEADER = CONTRACTHEADER
          IMPORTING
*           OBJ_TYPE       = OBJ_TYPE
            obj_key        = obj_key
*           OBJ_SYS        = OBJ_SYS
          TABLES
*           accountgl      = lt_acctgl
*           accountreceivable = lt_vend_inv
            accountpayable = lt_vend_inv
*           ACCOUNTTAX     = ACCOUNTTAX
            currencyamount = lt_curramt
*           CRITERIA       = CRITERIA
*           VALUEFIELD     = VALUEFIELD
*           EXTENSION1     = EXTENSION1
            return         = lt_return
*           PAYMENTCARD    = PAYMENTCARD
*           CONTRACTITEM   = CONTRACTITEM
*           EXTENSION2     = EXTENSION2
*           REALESTATE     = REALESTATE
*           ACCOUNTWT      = ACCOUNTWT
          .
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          IF sy-subrc EQ 0.
            LOOP AT lt_return INTO x_return.
              CLEAR wa_info.
              wa_info-info_msg  = x_return-message.
              APPEND wa_info-info_msg TO t_info.
              CLEAR wa_info.
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            CLEAR wa_output.
*Error message in downloaded file
            CONCATENATE 'Vendor-'
                        fs_field12-newko_1
                        'with Doc head txt/Ref./Text-'
                        fs_field12-bktxt '/'
                        fs_field12-xblnr '/'
                        fs_field12-sgtxt_1
            INTO wa_output-msg_err SEPARATED BY space.
            APPEND wa_output-msg_err TO it_output.
            CLEAR wa_output.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: fs_field12.
  ENDLOOP.

ENDFORM.
