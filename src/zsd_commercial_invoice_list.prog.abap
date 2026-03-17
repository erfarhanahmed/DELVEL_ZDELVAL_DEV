*----------------------------------------------------------------------*
*              Print of an invoice list by SAPscript                   *
*----------------------------------------------------------------------*
REPORT ZSD_COMMERCIAL_INVOICE_LIST LINE-COUNT 100 MESSAGE-ID VN.

TABLES: KNA1,                          "Customer master record
        *KNA1,                         "Customer master record
        KOMK,                          "Communicationarea for conditions
        KOMP,                          "Communicationarea for conditions
        KOMVD,                         "Communicationarea for conditions
        VBDKIL,                        "Communicationarea for SAPscript
        VBPA,                          "Partner
        VBRK,                          "Header invoice list
        VBRL,                          "Item invoice list
        SADR,                          "Addresses
        TVKO,                          "Sales organisation
        T052.                          "Terms of payment
INCLUDE RVADTABL.

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DATA: RETCODE   LIKE SY-SUBRC.         "Returncode
DATA: XSCREEN(1)  TYPE C.              "Output on printer or screen
DATA: REPEAT(1) TYPE C.

DATA: BEGIN OF TVBRL OCCURS 100.       "Internal table for items
        INCLUDE STRUCTURE VBRL.
DATA: END OF TVBRL.

DATA: BEGIN OF TKOMV OCCURS 50.
        INCLUDE STRUCTURE KOMV.
DATA: END OF TKOMV.

DATA: BEGIN OF TKOMVD OCCURS 50.
        INCLUDE STRUCTURE KOMVD.
DATA: END OF TKOMVD.

DATA : BEGIN OF ZTERM OCCURS 3.
        INCLUDE STRUCTURE VTOPIS.
DATA : END OF ZTERM.

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DATA: PR_KAPPL(01)  TYPE C VALUE 'V' . "Application for pricing
DATA: PAYER(02)     TYPE C VALUE 'RG'. "Application for pricing

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

* data for access to central address maintenance
INCLUDE SDZAVDAT.

*---------------------------------------------------------------------*
*       FORM ENTRY                                                    *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  RETURN_CODE                                                   *
*  -->  US_SCREEN                                                     *
*---------------------------------------------------------------------*
FORM ENTRY USING RETURN_CODE US_SCREEN.

  CLEAR RETCODE.
  XSCREEN = US_SCREEN.
  PERFORM PROCESSING USING US_SCREEN.
  PERFORM PROCESSING1 USING US_SCREEN changing retcode.
  CASE RETCODE.
    WHEN 0.
      RETURN_CODE = 0.
    WHEN 3.
      RETURN_CODE = 3.
    WHEN OTHERS.
      RETURN_CODE = 1.
  ENDCASE.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PROC_SCREEN                                                   *
*---------------------------------------------------------------------*
FORM PROCESSING USING PROC_SCREEN.

 PERFORM GET_DATA.
*  CHECK RETCODE = 0.
*  PERFORM FORM_OPEN USING PROC_SCREEN KNA1-LAND1.
*  CHECK RETCODE = 0.
  PERFORM CHECK_REPEAT.
*  PERFORM HEADER_DATA_PRINT.
*  CHECK RETCODE = 0.
*  PERFORM HEADER_TEXT_PRINT.
*  CHECK RETCODE = 0.
*  PERFORM ITEM_PRINT.
*  CHECK RETCODE = 0.
*  PERFORM END_PRINT.
*  CHECK RETCODE = 0.
*  PERFORM FORM_CLOSE.
*  CHECK RETCODE = 0.

ENDFORM.

***********************************************************************
*       S U B R O U T I N E S                                         *
***********************************************************************

*---------------------------------------------------------------------*
*       FORM CHECK_REPEAT                                             *
*---------------------------------------------------------------------*
*       A text is printed, if it is a repeat print for the document.  *
*---------------------------------------------------------------------*

FORM CHECK_REPEAT.
*BREAK-POINT.
  CLEAR REPEAT.
  SELECT * INTO *NAST FROM NAST WHERE KAPPL = NAST-KAPPL
                                AND   OBJKY = NAST-OBJKY
                                AND   KSCHL = NAST-KSCHL
                                AND   SPRAS = NAST-SPRAS
                                AND   PARNR = NAST-PARNR
                                AND   PARVW = NAST-PARVW
                                AND   NACHA BETWEEN '1' AND '4'.
    CHECK *NAST-VSTAT = '1'.
    REPEAT = 'X'.
    EXIT.
  ENDSELECT.
*  IF REPEAT NE SPACE.
*    CALL FUNCTION 'WRITE_FORM'
*         EXPORTING
*              ELEMENT = 'REPEAT'
*              WINDOW  = 'REPEAT'
*         EXCEPTIONS
*              ELEMENT = 1
*              WINDOW  = 2.
*    IF SY-SUBRC NE 0.
*      PERFORM PROTOCOL_UPDATE.
*    ENDIF.
*  ENDIF.

ENDFORM.

FORM processing1 USING proc_screen
                CHANGING cf_retcode.

  DATA: ls_print_data_to_read TYPE lbbil_print_data_to_read.
  DATA: ls_bil_invoice TYPE lbbil_invoice.
  DATA: lf_fm_name            TYPE rs38l_fnam.
  DATA: ls_control_param      TYPE ssfctrlop.
  DATA: ls_composer_param     TYPE ssfcompop.
  DATA: ls_recipient          TYPE swotobjid.
  DATA: ls_sender             TYPE swotobjid.
  DATA: lf_formname           TYPE tdsfname.
  DATA: ls_addr_key           LIKE addr_key.
  DATA: ls_dlv_land           LIKE vbrk-land1.
  DATA: ls_job_info           TYPE ssfcrescl.

* SmartForm from customizing table TNAPR
  lf_formname = tnapr-sform.

* BEGIN: Country specific extension for Hungary
  DATA: lv_ccnum TYPE IDHUCCNUM,
        lv_error TYPE c.

* If a valid entry exists for the form in customizing view
* IDHUBILLINGOUT then the localized output shall be used.
  SELECT SINGLE ccnum INTO lv_ccnum FROM IDHUBILLINGOUT WHERE
    kschl = nast-kschl.

  IF sy-subrc EQ 0.
    IF lv_ccnum IS INITIAL.
      lv_ccnum = 1.
    ENDIF.

    IF ( nast-delet IS INITIAL OR nast-dimme IS INITIAL ).

      nast-delet = 'X'.
      nast-dimme = 'X'.

      sy-msgid = 'IDFIHU'.
      sy-msgty = 'W'.
      sy-msgno = 201.
      sy-msgv1 = nast-objky.

      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
        MSG_ARBGB = sy-msgid
        MSG_NR    = sy-msgno
        MSG_TY    = sy-msgty
        MSG_V1    = sy-msgv1
        MSG_V2    = ''
        MSG_V3    = ''
        MSG_V4    = ''
      EXCEPTIONS
        OTHERS    = 1.
    ENDIF.
  ELSE.
    CLEAR lv_ccnum.
  ENDIF.
* END: Country specific extension for Hungary

* determine print data
*  PERFORM set_print_data_to_read USING    lf_formname
*                                 CHANGING ls_print_data_to_read
*                                 cf_retcode.

  IF cf_retcode = 0.
* select print data
    PERFORM get_data." USING    ls_print_data_to_read
*                     CHANGING ls_addr_key
*                              ls_dlv-land
*                              ls_bil_invoice
*                              cf_retcode.
  ENDIF.

  IF cf_retcode = 0.
*    PERFORM set_print_param USING    ls_addr_key
*                                     ls_dlv-land
*                            CHANGING ls_control_param
*                                     ls_composer_param
*                                     ls_recipient
*                                     ls_sender
*                                     cf_retcode.
  ENDIF.

  IF cf_retcode = 0.
* determine smartform function module for invoice
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
         EXPORTING  formname           = lf_formname
*                 variant            = ' '
*                 direct_call        = ' '
         IMPORTING  fm_name            = lf_fm_name
         EXCEPTIONS no_form            = 1
                    no_function_module = 2
                    OTHERS             = 3.
    IF sy-subrc <> 0.
*   error handling
      cf_retcode = sy-subrc.
      PERFORM protocol_update.
    ENDIF.
  ENDIF.

  IF cf_retcode = 0.
    PERFORM check_repeat.
    IF ls_composer_param-tdcopies EQ 0.
      nast-anzal = 1.
    ELSE.
      nast-anzal = ls_composer_param-tdcopies.
    ENDIF.
    ls_composer_param-tdcopies = 1.

    DO nast-anzal TIMES.
* In case of repetition only one time archiving
      IF sy-index > 1 AND nast-tdarmod = 3.
        nast-tdarmod = nast-tdarmod.
        nast-tdarmod = 1.
        ls_composer_param-tdarmod = 1.
      ENDIF.
      IF sy-index NE 1 AND repeat IS INITIAL.
        repeat = 'X'.
      ENDIF.
* BEGIN: Country specific extension for Hungary
    IF lv_ccnum IS NOT INITIAL.
      IF nast-repid IS INITIAL.
        nast-repid = 1.
      ELSE.
        nast-repid = nast-repid + 1.
      ENDIF.
      nast-pfld1 = lv_ccnum.
    ENDIF.
* END: Country specific extension for Hungary
* call smartform invoice


  CALL FUNCTION lf_fm_name
      EXPORTING
        archive_index        = toa_dara
          archive_parameters   = arc_params
         control_parameters   = ls_control_param
*          mail_appl_obj        =
         mail_recipient       = ls_recipient
          mail_sender          = ls_sender
          output_options       = ls_composer_param
        user_settings        = space
*       MAIL_APPL_OBJ              =
*       MAIL_RECIPIENT             =
*       MAIL_SENDER                =
*       OUTPUT_OPTIONS             =
*       USER_SETTINGS              = 'X'
        IT_VBRK                    =  vbrk
       is_nast               =   nast
        is_repeat            = repeat
*     IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO            =
*       JOB_OUTPUT_OPTIONS         =
      TABLES
        IT_VBRL                    = tvbrl
*     EXCEPTIONS
*       FORMATTING_ERROR           = 1
*       INTERNAL_ERROR             = 2
*       SEND_ERROR                 = 3
*       USER_CANCELED              = 4
*       OTHERS                     = 5
              .
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


*          CALL FUNCTION
*           EXPORTING
*
**
*                      is_bil_invoice       = vbrk
**                      is_bil_invoice       = ls_bil_invoice
*
*           importing  job_output_info      = ls_job_info
**                     document_output_info =
**                     job_output_options   =
*           EXCEPTIONS formatting_error     = 1
*                      internal_error       = 2
*                      send_error           = 3
*                      user_canceled        = 4
*                      OTHERS               = 5.
*      IF sy-subrc <> 0.
*   error handling
*        cf_retcode = sy-subrc.
*        PERFORM protocol_update.
** get SmartForm protocoll and store it in the NAST protocoll
**        PERFORM add_smfrm_prot.
*      ENDIF.
    ENDDO.
* get SmartForm spoolid and store it in the NAST protocoll
    DATA ls_spoolid LIKE LINE OF ls_job_info-spoolids.
    LOOP AT ls_job_info-spoolids INTO ls_spoolid.
      IF ls_spoolid NE space.
*        PERFORM protocol_update_spool USING '342' ls_spoolid
*                                            space space space.
      ENDIF.
    ENDLOOP.
    ls_composer_param-tdcopies = nast-anzal.
    IF NOT nast-tdarmod IS INITIAL.
      nast-tdarmod = nast-tdarmod.
      CLEAR nast-tdarmod.
    ENDIF.

  ENDIF.

* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.

ENDFORM.                    "PROCESSING
*---------------------------------------------------------------------*
*       FORM CUSTOMER_READ                                            *
*---------------------------------------------------------------------*
*       Read customer master record for item                          *
*---------------------------------------------------------------------*

FORM CUSTOMER_READ USING US_KUNNR.

  IF US_KUNNR IS INITIAL.
    CLEAR *KNA1.
  ENDIF.
  CHECK *KNA1-KUNNR NE US_KUNNR.
  SELECT SINGLE * FROM KNA1 INTO *KNA1 WHERE KUNNR = US_KUNNR.
  IF SY-SUBRC NE 0.
    SYST-MSGID = 'VN'.
    SYST-MSGNO = '203'.
    SYST-MSGTY = 'E'.
    SYST-MSGV1 = 'KNA1'.
    SYST-MSGV2 = SYST-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM END_PRINT                                                *
*---------------------------------------------------------------------*
*                                                                     *
*---------------------------------------------------------------------*

FORM END_PRINT.
*
*  PERFORM GET_HEADER_PRICES.
*  PERFORM GET_VALUE_EURO.
*  CALL FUNCTION 'CONTROL_FORM'
*       EXPORTING
*            COMMAND = 'PROTECT'.
*  PERFORM HEADER_PRICE_PRINT.
*  CALL FUNCTION 'WRITE_FORM'
*       EXPORTING
*            ELEMENT = 'END_VALUES'.
*  CALL FUNCTION 'CONTROL_FORM'
*       EXPORTING
*            COMMAND = 'ENDPROTECT'.
*  CALL FUNCTION 'WRITE_FORM'
*       EXPORTING
*            ELEMENT = 'SUPPLEMENT_TEXT'
*       EXCEPTIONS
*            ELEMENT = 1
*            WINDOW  = 2.
*  IF SY-SUBRC NE 0.
*    PERFORM PROTOCOL_UPDATE.
*  ENDIF.
*
ENDFORM.

*---------------------------------------------------------------------*
*       FORM FORM_CLOSE                                               *
*---------------------------------------------------------------------*
*       End of printing the form                                      *
*---------------------------------------------------------------------*

FORM FORM_CLOSE.
*
*  CALL FUNCTION 'CLOSE_FORM'
*       EXCEPTIONS
*            OTHERS = 1.
*  IF SY-SUBRC NE 0.
*    RETCODE = SY-SUBRC.
*    PERFORM PROTOCOL_UPDATE.
*  ENDIF.
*  SET COUNTRY SPACE.
*
ENDFORM.

*---------------------------------------------------------------------*
*       FORM FORM_OPEN                                                *
*---------------------------------------------------------------------*
*       Start of printing the form                                    *
*---------------------------------------------------------------------*
*  -->  US_SCREEN  Output on screen                                   *
*                  ' ' = Printer                                      *
*                  'X' = Screen                                       *
*  -->  US_COUNTRY County for telecommunication and SET COUNTRY       *
*---------------------------------------------------------------------*

FORM FORM_OPEN USING US_SCREEN US_COUNTRY.
*
*  INCLUDE RVADOPFO.
*
ENDFORM.

*---------------------------------------------------------------------*
*       FORM GET_DATA                                                 *
*---------------------------------------------------------------------*
*       General provision of data for the form                        *
*---------------------------------------------------------------------*

FORM GET_DATA.

  DATA: XFKDAT LIKE VBRK-FKDAT.

  CLEAR VBDKIL.
  CALL FUNCTION 'RV_PRICE_PRINT_REFRESH'
       TABLES
            TKOMV = TKOMV.
  CLEAR KOMK.
  CLEAR KOMP.
*break-point.
  SELECT SINGLE * FROM VBRK WHERE VBELN = NAST-OBJKY.
  RETCODE = SY-SUBRC.
  IF SY-SUBRC NE 0.
    SYST-MSGID = 'VN'.
    SYST-MSGNO = '203'.
    SYST-MSGTY = 'E'.
    SYST-MSGV1 = 'VBRK'.
    SYST-MSGV2 = SYST-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.
  CHECK RETCODE = 0.
  SELECT * FROM VBRL INTO TABLE TVBRL WHERE VBELN = NAST-OBJKY
           ORDER BY POSNR.
  RETCODE = SY-SUBRC.
  IF SY-SUBRC NE 0.
    SYST-MSGID = 'VN'.
    SYST-MSGNO = '203'.
    SYST-MSGTY = 'E'.
    SYST-MSGV1 = 'VBRL'.
    SYST-MSGV2 = SYST-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.
  CHECK RETCODE = 0.
  SELECT SINGLE * FROM VBPA WHERE VBELN = NAST-OBJKY
                            AND   POSNR = 0
                            AND   PARVW = PAYER.
  RETCODE = SY-SUBRC.
  IF SY-SUBRC NE 0.
    SYST-MSGID = 'VN'.
    SYST-MSGNO = '203'.
    SYST-MSGTY = 'E'.
    SYST-MSGV1 = 'VBPA'.
    SYST-MSGV2 = SYST-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.
  CHECK RETCODE = 0.
  SELECT SINGLE * FROM KNA1 WHERE KUNNR = VBPA-KUNNR.
  RETCODE = SY-SUBRC.
  IF SY-SUBRC NE 0.
    SYST-MSGID = 'VN'.
    SYST-MSGNO = '203'.
    SYST-MSGTY = 'E'.
    SYST-MSGV1 = 'KNA1'.
    SYST-MSGV2 = SYST-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.
  CHECK RETCODE = 0.
  XFKDAT = VBRK-FKDAT + VBRK-VALTG.
  IF VBRK-VALDT NE 0.
    XFKDAT = VBRK-VALDT.
  ENDIF.
  CALL FUNCTION 'SD_PRINT_TERMS_OF_PAYMENT'
       EXPORTING
            TERMS_OF_PAYMENT             = VBRK-ZTERM
            BLDAT                        = XFKDAT
            BUDAT                        = XFKDAT
            CPUDT                        = XFKDAT
            COUNTRY                      = KNA1-LAND1
            LANGUAGE                     = NAST-SPRAS
       TABLES
            TOP_TEXT                     = ZTERM
       EXCEPTIONS
            TERMS_OF_PAYMENT_NOT_IN_T052 = 1.

  CHECK SY-SUBRC = 0.
  LOOP AT ZTERM.
    CASE SY-TABIX.
      WHEN 1.
        MOVE ZTERM-LINE TO VBDKIL-ZTERM_TX1.
      WHEN 2.
        MOVE ZTERM-LINE TO VBDKIL-ZTERM_TX2.
      WHEN 3.
        MOVE ZTERM-LINE TO VBDKIL-ZTERM_TX3.
    ENDCASE.
  ENDLOOP.

  PERFORM SENDER.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM GET_ITEM_PRICES                                          *
*---------------------------------------------------------------------*
*       In this routine the price data for the item is fetched from   *
*       the database.                                                 *
*---------------------------------------------------------------------*

FORM GET_ITEM_PRICES.

  CLEAR: KOMP,
         TKOMV.

  IF KOMK-KNUMV NE VBRK-KNUMV.
    CLEAR KOMK.
    KOMK-MANDT = SY-MANDT.
    KOMK-KALSM = VBRK-KALSM.
    KOMK-KAPPL = PR_KAPPL.
    KOMK-WAERK = VBRK-WAERK.
    KOMK-KNUMV = VBRK-KNUMV.
    KOMK-VBTYP = VBRK-VBTYP.
  ENDIF.
  KOMP-KPOSN = VBRL-POSNR.

  CALL FUNCTION 'RV_PRICE_PRINT_ITEM'
       EXPORTING
            COMM_HEAD_I = KOMK
            COMM_ITEM_I = KOMP
            LANGUAGE    = NAST-SPRAS
       IMPORTING
            COMM_HEAD_E = KOMK
            COMM_ITEM_E = KOMP
       TABLES
            TKOMV       = TKOMV
            TKOMVD      = TKOMVD.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  HEADER_DATA_PRINT
*&---------------------------------------------------------------------*
*       Printing of header data like terms                             *
*----------------------------------------------------------------------*

FORM HEADER_DATA_PRINT.
*
*  CALL FUNCTION 'WRITE_FORM'
*       EXPORTING
*            ELEMENT = 'HEADER_DATA'
*       EXCEPTIONS
*            ELEMENT = 1
*            WINDOW  = 2.
**ENHANCEMENT-SECTION     HEADER_DATA_PRINT_01 SPOTS ES_RVADIL01.
*  IF SY-SUBRC NE 0.
*    PERFORM PROTOCOL_UPDATE.
*  ENDIF.
**END-ENHANCEMENT-SECTION.
*
ENDFORM.                               " HEADER_DATA_PRINT

*---------------------------------------------------------------------*
*       FORM GET_HEADER_PRICES                                        *
*---------------------------------------------------------------------*
*       In this routine the price data for the header is fetched from *
*       the database.                                                 *
*---------------------------------------------------------------------*

FORM GET_HEADER_PRICES.

  CALL FUNCTION 'RV_PRICE_PRINT_HEAD'
       EXPORTING
            COMM_HEAD_I = KOMK
            LANGUAGE    = NAST-SPRAS
       IMPORTING
            COMM_HEAD_E = KOMK
       TABLES
            TKOMV       = TKOMV
            TKOMVD      = TKOMVD.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM HEADER_PRICE_PRINT                                       *
*---------------------------------------------------------------------*
*       Printout of the header prices                                 *
*---------------------------------------------------------------------*

*FORM HEADER_PRICE_PRINT.
*
*  CALL FUNCTION 'WRITE_FORM'
*       EXPORTING
*            ELEMENT = 'ITEM_SUM'.
*
*  VBDKIL-FKWRT = VBDKIL-BRTSU.
*  LOOP AT TKOMVD.
*    KOMVD = TKOMVD.
*    ADD KOMVD-KWERT TO VBDKIL-FKWRT.
*    IF KOMVD-KOAID = 'D'.
*      CALL FUNCTION 'WRITE_FORM'
*           EXPORTING
*                ELEMENT = 'TAX_LINE'.
*    ELSE.
*      CALL FUNCTION 'WRITE_FORM'
*           EXPORTING
*                ELEMENT = 'SUM_LINE'.
*    ENDIF.
*  ENDLOOP.
*  DESCRIBE TABLE TKOMVD LINES SY-TFILL.
*  IF SY-TFILL = 0.
*    CALL FUNCTION 'WRITE_FORM'
*         EXPORTING
*              ELEMENT = 'SPACE_LINE'
*         EXCEPTIONS
*              ELEMENT = 1
*              WINDOW  = 2.
*    IF SY-SUBRC NE 0.
*      PERFORM PROTOCOL_UPDATE.
*    ENDIF.
*  ENDIF.
*
*ENDFORM.

*---------------------------------------------------------------------*
*       FORM HEADER_TEXT_PRINT                                        *
*---------------------------------------------------------------------*
*       Printout of the headertexts                                   *
*---------------------------------------------------------------------*

FORM HEADER_TEXT_PRINT.
*
*  VBDKIL-TDNAME = VBRK-VBELN.
*  CALL FUNCTION 'WRITE_FORM'
*       EXPORTING
*            ELEMENT = 'HEADER_TEXT'
*       EXCEPTIONS
*            ELEMENT = 1
*            WINDOW  = 2.
*  IF SY-SUBRC NE 0.
*    PERFORM PROTOCOL_UPDATE.
*  ENDIF.
*
ENDFORM.

*---------------------------------------------------------------------*
*       FORM ITEM_PRINT                                               *
*---------------------------------------------------------------------*
*       Printout of the items                                         *
*---------------------------------------------------------------------*

FORM ITEM_PRINT.
*
*  CALL FUNCTION 'WRITE_FORM'           "First header
*       EXPORTING  ELEMENT = 'ITEM_HEADER'
*       EXCEPTIONS OTHERS  = 1.
*  IF SY-SUBRC NE 0.
*    PERFORM PROTOCOL_UPDATE.
*  ENDIF.
*  CALL FUNCTION 'WRITE_FORM'           "Activate header
*       EXPORTING  ELEMENT = 'ITEM_HEADER'
*                  TYPE    = 'TOP'
*       EXCEPTIONS OTHERS  = 1.
*  IF SY-SUBRC NE 0.
*    PERFORM PROTOCOL_UPDATE.
*  ENDIF.
*
*  LOOP AT TVBRL.
*    VBRL = TVBRL.
*    PERFORM GET_ITEM_PRICES.
*    CALL FUNCTION 'CONTROL_FORM'
*         EXPORTING
*              COMMAND = 'PROTECT'.
*    VBDKIL-BRTWR = VBRL-NETWR + VBRL-MWSBP.
*    VBDKIL-DKWRT = VBRL-KWERT_RL + VBRL-MWSBP_RL.
*    ADD VBRL-NETWR    TO VBDKIL-NETSU.
*    ADD VBRL-MWSBP    TO VBDKIL-MWSSU.
*    ADD VBDKIL-DKWRT  TO VBDKIL-DKSUM.
*    ADD VBRL-MWSBP_RL TO VBDKIL-DKMWS.
*    ADD VBDKIL-BRTWR TO VBDKIL-BRTSU.
*    PERFORM CUSTOMER_READ USING VBRL-KUNAG.
*    CALL FUNCTION 'WRITE_FORM'
*         EXPORTING
*              ELEMENT = 'ITEM_LINE'.
*    CALL FUNCTION 'CONTROL_FORM'
*         EXPORTING
*              COMMAND = 'ENDPROTECT'.
*  ENDLOOP.
*
*  CALL FUNCTION 'WRITE_FORM'           "Deactivate Header
*       EXPORTING  ELEMENT  = 'ITEM_HEADER'
*                  FUNCTION = 'DELETE'
*                  TYPE     = 'TOP'
*       EXCEPTIONS OTHERS   = 1.
*  IF SY-SUBRC NE 0.
*    PERFORM PROTOCOL_UPDATE.
*  ENDIF.
*
ENDFORM.

*---------------------------------------------------------------------*
*       FORM PROTOCOL_UPDATE                                          *
*---------------------------------------------------------------------*
*       The messages are collected for the processing protocol.       *
*---------------------------------------------------------------------*

FORM PROTOCOL_UPDATE.

  CHECK XSCREEN = SPACE.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
       EXPORTING
            MSG_ARBGB = SYST-MSGID
            MSG_NR    = SYST-MSGNO
            MSG_TY    = SYST-MSGTY
            MSG_V1    = SYST-MSGV1
            MSG_V2    = SYST-MSGV2
            MSG_V3    = SYST-MSGV3
            MSG_V4    = SYST-MSGV4
       EXCEPTIONS
            OTHERS    = 1.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM SENDER                                                   *
*---------------------------------------------------------------------*
*       This routine determines the address of the sender (Table VKO) *
*---------------------------------------------------------------------*

FORM SENDER.

  SELECT SINGLE * FROM TVKO  WHERE VKORG = VBRK-VKORG.
  IF SY-SUBRC NE 0.
    SYST-MSGID = 'VN'.
    SYST-MSGNO = '203'.
    SYST-MSGTY = 'E'.
    SYST-MSGV1 = 'TVKO'.
    SYST-MSGV2 = SYST-SUBRC.
    PERFORM PROTOCOL_UPDATE.
    EXIT.
  ENDIF.
  CLEAR GV_FB_ADDR_GET_SELECTION.
  GV_FB_ADDR_GET_SELECTION-ADDRNUMBER = TVKO-ADRNR.
  CALL FUNCTION 'ADDR_GET'
       EXPORTING
            ADDRESS_SELECTION = GV_FB_ADDR_GET_SELECTION
            ADDRESS_GROUP     = 'CA01'
       IMPORTING
            SADR              = SADR
       EXCEPTIONS
            OTHERS            = 01.    "SADR40A
  IF SY-SUBRC NE 0.
    CLEAR SADR.
  ENDIF.

  VBDKIL-SLAND     = SADR-LAND1.
  VBDKIL-SPRAS_VKO = SADR-SPRAS.
  IF SY-SUBRC NE 0.
    SYST-MSGID = 'VN'.
    SYST-MSGNO = '203'.
    SYST-MSGTY = 'E'.
    SYST-MSGV1 = 'SADR'.
    SYST-MSGV2 = SYST-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_VALUE_EURO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM GET_VALUE_EURO.

  IF NOT KOMK-WAERK_EURO IS INITIAL.
    CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
         EXPORTING
              DATE             = SY-DATUM
              FOREIGN_AMOUNT   = VBDKIL-BRTSU
              FOREIGN_CURRENCY = KOMK-WAERK
              LOCAL_CURRENCY   = KOMK-WAERK_EURO
         IMPORTING
              LOCAL_AMOUNT     = KOMK-FKWRT_EURO
         EXCEPTIONS
              NO_RATE_FOUND    = 1
              OVERFLOW         = 2
              NO_FACTORS_FOUND = 3
              NO_SPREAD_FOUND  = 4
              OTHERS           = 5.
  ENDIF.

ENDFORM.                               " GET_VALUE_EURO
