*&---------------------------------------------------------------------*
*&  Include           ZTMP2_DM_SUBROUTINES
*&---------------------------------------------------------------------*

FORM bdc_transaction USING tcode.
  REFRESH messtab.
  CALL TRANSACTION tcode USING bdcdata
                   MODE   w_mode
                   UPDATE w_update
                   MESSAGES INTO messtab.
  IF sy-subrc EQ 0.
*    Uploaded into the database
    CLEAR : wa_info.
    LOOP AT messtab INTO w_msg.
      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = w_msg-msgid
          msgnr               = w_msg-msgnr
          msgv1               = w_msg-msgv1
          msgv2               = w_msg-msgv2
          msgv3               = w_msg-msgv3
          msgv4               = w_msg-msgv4
        IMPORTING
          message_text_output = w_msg1.
      wa_info-info_msg  = w_msg1.
      APPEND wa_info-info_msg TO t_info.
      CLEAR wa_info.
    ENDLOOP.
  ELSE.
*    Error Found
    LOOP AT messtab INTO w_msg." WHERE msgtyp EQ 'E'.
*     Format Message
      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = w_msg-msgid
          msgnr               = w_msg-msgnr
          msgv1               = w_msg-msgv1
          msgv2               = w_msg-msgv2
          msgv3               = w_msg-msgv3
          msgv4               = w_msg-msgv4
        IMPORTING
          message_text_output = w_msg1.
      wa_output-msg_err = w_msg1.
*Error message in downloaded file
      CONCATENATE wa_output-msg_err '.'  INTO wa_output-msg_err SEPARATED BY space.
      APPEND wa_output-msg_err TO it_output.
      CLEAR wa_output.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM bdc_field USING fnam fval.
  IF fval <> ' '.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.

FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

FORM zdemrgr_cust_open_items_inv.

  CLEAR : fs_field.
  LOOP AT t_field INTO fs_field.
    REFRESH : bdcdata.
    CLEAR wa_info.
    CLEAR : temp_bldat ,
           temp_budat  ,
           temp_wrbtr_1,
           temp_wrbtr_2,
           temp_dmbtr_1,
           temp_dmbtr_2,
           temp_zfbdt,
           temp_valut.
    CONCATENATE fs_field-bldat+6(2) fs_field-bldat+4(2) fs_field-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field-budat+6(2) fs_field-budat+4(2) fs_field-budat(4) INTO temp_budat." SEPARATED BY '.'.
*    CONCATENATE fs_field-valut+6(2) fs_field-valut+4(2) fs_field-valut(4) INTO temp_valut.
    CONCATENATE fs_field-zfbdt+6(2) fs_field-zfbdt+4(2) fs_field-zfbdt(4) INTO temp_zfbdt.
    temp_wrbtr_1 = fs_field-wrbtr_1.
    temp_wrbtr_2 = fs_field-wrbtr_2.
    temp_dmbtr_1 = fs_field-dmbtr_1.
    temp_dmbtr_2 = fs_field-dmbtr_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A'         '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'       'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'       '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'       temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'       fs_field-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'       fs_field-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'       temp_budat .
*perform bdc_field       using 'BKPF-MONAT'       record-MONAT_005.
    PERFORM bdc_field       USING 'BKPF-WAERS'       fs_field-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'        fs_field-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'       fs_field-bktxt.
*perform bdc_field       using 'FS006-DOCID'      record-DOCID_008.
    PERFORM bdc_field       USING 'RF05A-NEWBS'      fs_field-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'      fs_field-newko_1.
    PERFORM bdc_dynpro      USING 'SAPMF05A'         '0301'.
    PERFORM bdc_field       USING 'BDC_CURSOR'       'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'       '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'       temp_wrbtr_1.
    IF fs_field-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'       temp_dmbtr_1.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-MWSKZ'           fs_field-mwskz.
    PERFORM bdc_field       USING 'BSEG-BUPLA'           fs_field-bupla.
    PERFORM bdc_field       USING 'BSEG-SECCO'           fs_field-secco.
    PERFORM bdc_field       USING 'BSEG-GSBER'       fs_field-gsber_1.
    PERFORM bdc_field       USING 'BSEG-ZTERM'      fs_field-zterm_1.
*perform bdc_field       using 'BSEG-ZBD1T'      record-ZBD1T_015.
    PERFORM bdc_field       USING 'BSEG-ZFBDT'       temp_zfbdt.
*perform bdc_field       using 'BSEG-ZLSCH'       record-ZLSCH_017.
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'       fs_field-sgtxt_1.
    PERFORM bdc_field       USING 'RF05A-NEWBS'      fs_field-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'      fs_field-newko_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A'         '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'       'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'       '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'       temp_wrbtr_2.
    IF fs_field-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'       temp_dmbtr_2.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-ZTERM'      fs_field-zterm_2.
*    PERFORM bdc_field       USING 'BSEG-VALUT'       temp_valut.
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'       fs_field-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'      record-FMORE_024.
    PERFORM bdc_dynpro      USING 'SAPLKACB'         '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'       'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'       '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'       fs_field-gsber_2.
    PERFORM bdc_transaction USING 'F-02'.
  ENDLOOP.
ENDFORM.


FORM zdemrgr_vend_open_items_inv.

  CLEAR : fs_field1.
  LOOP AT t_field1 INTO fs_field1.
    REFRESH : bdcdata.
    CLEAR wa_info.
    CLEAR : temp_bldat  ,
           temp_budat  ,
           temp_wrbtr_1,
           temp_wrbtr_2,
           temp_dmbtr_1,
           temp_dmbtr_2,
           temp_zfbdt,
           temp_valut.
    CONCATENATE fs_field1-bldat+6(2) fs_field1-bldat+4(2) fs_field1-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field1-budat+6(2) fs_field1-budat+4(2) fs_field1-budat(4) INTO temp_budat." SEPARATED BY '.'.
*    CONCATENATE fs_field1-valut+6(2) fs_field1-valut+4(2) fs_field1-valut(4) INTO temp_valut.
    CONCATENATE fs_field1-zfbdt+6(2) fs_field1-zfbdt+4(2) fs_field1-zfbdt(4) INTO temp_zfbdt.
    temp_wrbtr_1 = fs_field1-wrbtr_1.
    temp_wrbtr_2 = fs_field1-wrbtr_2.
    temp_dmbtr_1 = fs_field1-dmbtr_1.
    temp_dmbtr_2 = fs_field1-dmbtr_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A'       '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'     temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'     fs_field1-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'     fs_field1-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'     temp_budat.
*perform bdc_field       using 'BKPF-MONAT'     record-MONAT_005.
    PERFORM bdc_field       USING 'BKPF-WAERS'     fs_field1-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'        fs_field1-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'     fs_field1-bktxt.
*perform bdc_field       using 'FS006-DOCID'    record-DOCID_008.
    PERFORM bdc_field       USING 'RF05A-NEWBS'    fs_field1-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'    fs_field1-newko_1.
    PERFORM bdc_dynpro      USING 'SAPMF05A'       '0302'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'     temp_wrbtr_1.
    IF fs_field1-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'       temp_dmbtr_1.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-MWSKZ'           fs_field1-mwskz.
    PERFORM bdc_field       USING 'BSEG-BUPLA'           fs_field1-bupla.
    PERFORM bdc_field       USING 'BSEG-SECCO'           fs_field1-secco.
    PERFORM bdc_field       USING 'BSEG-GSBER'     fs_field1-gsber_1.
    PERFORM bdc_field       USING 'BSEG-ZTERM'     fs_field1-zterm_1.
    PERFORM bdc_field       USING 'BSEG-ZFBDT'     temp_zfbdt.
*perform bdc_field       using 'BSEG-ZLSCH'     record-ZLSCH_016.
    PERFORM bdc_field       USING 'BSEG-ZUONR'     fs_field1-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'     fs_field1-sgtxt_1.
    PERFORM bdc_field       USING 'RF05A-NEWBS'    fs_field1-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'    fs_field1-newko_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A'       '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'     temp_wrbtr_2.
    IF fs_field1-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'       temp_dmbtr_2.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-ZTERM'      fs_field1-zterm_2.
*    PERFORM bdc_field       USING 'BSEG-VALUT'     temp_valut.
    PERFORM bdc_field       USING 'BSEG-ZUONR'     fs_field1-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'     fs_field1-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'    record-FMORE_023.
    PERFORM bdc_dynpro      USING 'SAPLKACB'       '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'     fs_field1-gsber_2.
    PERFORM bdc_transaction USING 'F-02'.
  ENDLOOP.

ENDFORM.

FORM zdemrgr_cust_open_items_dwn.
  CLEAR : fs_field2.
  LOOP AT t_field2 INTO fs_field2.
    REFRESH : bdcdata.
    CLEAR : wa_info.
    CLEAR  : temp_bldat,
           temp_budat  ,
           temp_duedate,
           temp_wrbtr_1,
           temp_wrbtr_2,
           temp_dmbtr_1,
           temp_dmbtr_2.
    CONCATENATE fs_field2-bldat+6(2) fs_field2-bldat+4(2) fs_field2-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field2-budat+6(2) fs_field2-budat+4(2) fs_field2-budat(4) INTO temp_budat." SEPARATED BY '.'.
    CONCATENATE fs_field2-zfbdt+6(2) fs_field2-zfbdt+4(2) fs_field2-zfbdt(4) INTO temp_duedate.
    temp_wrbtr_1 = fs_field2-wrbtr_1.
    temp_wrbtr_2 = fs_field2-wrbtr_2.
    temp_dmbtr_1 = fs_field2-dmbtr_1.
    temp_dmbtr_2 = fs_field2-dmbtr_2.

    PERFORM bdc_dynpro      USING 'SAPMF05A'        '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'RF05A-NEWUM'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'      temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'      fs_field2-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'      fs_field2-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'      temp_budat.
*perform bdc_field       using 'BKPF-MONAT'      record-MONAT_005.
    PERFORM bdc_field       USING 'BKPF-WAERS'      fs_field2-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'      fs_field2-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'      fs_field2-bktxt.
*perform bdc_field       using 'FS006-DOCID'     record-DOCID_008.
    PERFORM bdc_field       USING 'RF05A-NEWBS'     fs_field2-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'     fs_field2-newko_1.
    PERFORM bdc_field       USING 'RF05A-NEWUM'     fs_field2-newum.

    IF fs_field2-newum EQ 'V' OR fs_field2-newum EQ 'Z'.
      PERFORM bdc_dynpro      USING 'SAPMF05A' '0303'.
    ELSE.
      PERFORM bdc_dynpro      USING 'SAPMF05A'        '0304'.
    ENDIF.

    PERFORM bdc_field       USING 'BDC_CURSOR'      'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'      temp_wrbtr_1.  " dmbtr bupla secco
    IF fs_field2-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'   temp_dmbtr_1.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-BUPLA'    fs_field2-bupla.
    PERFORM bdc_field       USING 'BSEG-SECCO'    fs_field2-secco.
    PERFORM bdc_field       USING 'BSEG-GSBER'      fs_field2-gsber_1.
    PERFORM bdc_field       USING 'BSEG-ZFBDT'    temp_duedate.
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field2-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'      fs_field2-sgtxt_1.
    PERFORM bdc_field       USING 'RF05A-NEWBS'     fs_field2-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'     fs_field2-newko_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A'        '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'      temp_wrbtr_2. " dmbtr
    IF fs_field2-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'   temp_dmbtr_2.
    ENDIF.
*perform bdc_field       using 'BSEG-VALUT'      record-VALUT_018.
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field2-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'      fs_field2-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'     record-FMORE_020.
    PERFORM bdc_dynpro      USING 'SAPLKACB'        '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'      fs_field2-gsber_2.
    PERFORM bdc_transaction USING 'F-02'.

  ENDLOOP.
ENDFORM.

FORM zdemrgr_vend_open_items_dwn.
  CLEAR : fs_field3.
  LOOP AT t_field3 INTO fs_field3.

    REFRESH: bdcdata.
    CLEAR : wa_info.
    CLEAR  : temp_bldat,
           temp_budat  ,
           temp_duedate,
           temp_wrbtr_1,
           temp_wrbtr_2,
           temp_dmbtr_1,
           temp_dmbtr_2.
    CONCATENATE fs_field3-bldat+6(2) fs_field3-bldat+4(2) fs_field3-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field3-budat+6(2) fs_field3-budat+4(2) fs_field3-budat(4) INTO temp_budat." SEPARATED BY '.'.
    CONCATENATE fs_field3-zfbdt+6(2) fs_field3-zfbdt+4(2) fs_field3-zfbdt(4) INTO temp_duedate."
    temp_wrbtr_1 = fs_field3-wrbtr_1.
    temp_wrbtr_2 = fs_field3-wrbtr_2.
    temp_dmbtr_1 = fs_field3-dmbtr_1.
    temp_dmbtr_2 = fs_field3-dmbtr_2.

    PERFORM bdc_dynpro      USING 'SAPMF05A'          '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'        'RF05A-NEWUM'.
    PERFORM bdc_field       USING 'BDC_OKCODE'        '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'        temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'        fs_field3-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'        fs_field3-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'        temp_budat.
*perform bdc_field       using 'BKPF-MONAT'        record-MONAT_005.
    PERFORM bdc_field       USING 'BKPF-WAERS'        fs_field3-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'        fs_field3-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'        fs_field3-bktxt.
*perform bdc_field       using 'FS006-DOCID'       record-DOCID_008.
    PERFORM bdc_field       USING 'RF05A-NEWBS'       fs_field3-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'       fs_field3-newko_1.
    PERFORM bdc_field       USING 'RF05A-NEWUM'       fs_field3-newum.
    IF fs_field3-newum EQ 'C' OR fs_field3-newum EQ 'E' OR fs_field3-newum EQ 'G'.
      PERFORM bdc_dynpro      USING 'SAPMF05A'          '0303'.
    ELSE.
      PERFORM bdc_dynpro      USING 'SAPMF05A'          '0304'.
    ENDIF.
    PERFORM bdc_field       USING 'BDC_CURSOR'        'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'        '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'        temp_wrbtr_1.
    IF fs_field3-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'      temp_dmbtr_1.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-BUPLA'        fs_field3-bupla.
    PERFORM bdc_field       USING 'BSEG-SECCO'        fs_field3-secco.
    PERFORM bdc_field       USING 'BSEG-GSBER'        fs_field3-gsber_1.
    PERFORM bdc_field       USING 'BSEG-ZFBDT'        temp_duedate. "due date
    PERFORM bdc_field       USING 'BSEG-ZUONR'        fs_field3-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'        fs_field3-sgtxt_1.
    PERFORM bdc_field       USING 'RF05A-NEWBS'       fs_field3-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'       fs_field3-newko_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A'          '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'        'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'        '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'        temp_wrbtr_2.
    IF fs_field3-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'   temp_dmbtr_2.
    ENDIF.
*    perform bdc_field       using 'BSEG-BUPLA'        fs_field3-bupla_2.
*perform bdc_field       using 'BSEG-VALUT'        record-VALUT_018.
    PERFORM bdc_field       USING 'BSEG-ZUONR'        fs_field3-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'        fs_field3-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'       record-FMORE_020.
    PERFORM bdc_dynpro      USING 'SAPLKACB'          '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'        'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'        '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'        fs_field3-gsber_2.
    PERFORM bdc_transaction USING 'F-02'.

  ENDLOOP.

ENDFORM.

FORM zdemrgr_internal_order.
  CLEAR: fs_field4.
  LOOP AT t_field4 INTO fs_field4.
    REFRESH: bdcdata.
    PERFORM bdc_dynpro      USING 'SAPMKAUF'      '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'COAS-AUART'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '/00'.
    PERFORM bdc_field       USING 'COAS-AUART'    fs_field4-auart.
    PERFORM bdc_field       USING 'COAS-REFNR'    fs_field4-refnr.
    PERFORM bdc_dynpro      USING 'SAPMKAUF'      '0600'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '=BUT4'.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'COAS-AUFEX'.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'COAS-BUKRS'.
    PERFORM bdc_field       USING 'COAS-BUKRS'    fs_field4-bukrs.
    PERFORM bdc_field       USING 'COAS-AUFEX'    fs_field4-aufex.
    PERFORM bdc_dynpro      USING 'SAPMKAUF'      '0600'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '=SICH'.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'COAS-USER2'.
    PERFORM bdc_field       USING 'COAS-USER0'    fs_field4-user0.
    PERFORM bdc_field       USING 'COAS-USER2'    fs_field4-user2.
    PERFORM bdc_transaction USING 'KO01'.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_COST_CENTER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_cost_center .

  CLEAR fs_field5.
  LOOP AT t_field5 INTO fs_field5.

    REFRESH: bdcdata.
    CLEAR : wa_info.
    CLEAR :temp_datab.
    CONCATENATE fs_field5-datab+6 fs_field5-datab+4(2) fs_field5-datab(4) INTO temp_datab.

    PERFORM bdc_dynpro      USING 'SAPLKMA1'        '0200'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'CSKSZ-KOSTL'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '/00'.
*  PERFORM bdc_field       USING 'CSKSZ-KOKRS'     record-kokrs_001.
    PERFORM bdc_field       USING 'CSKSZ-KOSTL'     fs_field5-kostl.
    PERFORM bdc_dynpro      USING 'SAPLKMA1'        '0299'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '=NLST'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'CSKSZ-KTEXT'.
*  PERFORM bdc_field       USING 'CSKSZ-KTEXT'     record-ktext_003.
*  PERFORM bdc_field       USING 'CSKSZ-LTEXT'     record-ltext_004.
*  PERFORM bdc_field       USING 'CSKSZ-VERAK'     record-verak_005.
*  PERFORM bdc_field       USING 'CSKSZ-ABTEI'     record-abtei_006.
*  PERFORM bdc_field       USING 'CSKSZ-KOSAR'     record-kosar_007.
*  PERFORM bdc_field       USING 'CSKSZ-KHINR'     record-khinr_008.
*  PERFORM bdc_field       USING 'CSKSZ-BUKRS'     record-bukrs_009.
*  PERFORM bdc_field       USING 'CSKSZ-GSBER'     record-gsber_010.
    PERFORM bdc_dynpro      USING 'SAPLRKMA'        '0200'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'RKMA2-OBADT(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '=ITVL'.
    PERFORM bdc_dynpro      USING 'SAPLRKMA'        '0201'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'RKMA2-DATAB'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '=WEIT'.
    PERFORM bdc_field       USING 'RKMA2-DATAB'     temp_datab.
*  PERFORM bdc_field       USING 'RKMA2-DATBI'     record-datbi_012.
    PERFORM bdc_dynpro      USING 'SAPLKMA1'        '0299'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '=BU'.
    PERFORM bdc_field       USING 'BDC_CURSOR'      'CSKSZ-BUKRS'.
*  PERFORM bdc_field       USING 'CSKSZ-KTEXT'     record-ktext_013.
*  PERFORM bdc_field       USING 'CSKSZ-LTEXT'     record-ltext_014.
*  PERFORM bdc_field       USING 'CSKSZ-VERAK'     record-verak_015.
*  PERFORM bdc_field       USING 'CSKSZ-ABTEI'     record-abtei_016.
*  PERFORM bdc_field       USING 'CSKSZ-KOSAR'     record-kosar_017.
*  PERFORM bdc_field       USING 'CSKSZ-KHINR'     record-khinr_018.
    PERFORM bdc_field       USING 'CSKSZ-BUKRS'     fs_field5-bukrs.
*  PERFORM bdc_field       USING 'CSKSZ-GSBER'     record-gsber_020.
    PERFORM bdc_dynpro      USING 'SAPLSPO1'        '0300'.
    PERFORM bdc_field       USING 'BDC_OKCODE'      '=YES'.
    PERFORM bdc_transaction USING 'KS02'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_GL_BANK_OPEN_ITEMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_gl_bank_open_items .

  CLEAR fs_field6.
  LOOP AT t_field6 INTO fs_field6.

    REFRESH: bdcdata.

    CLEAR : wa_info.
    CLEAR  : temp_bldat,
           temp_budat  ,
           temp_wrbtr_1,
           temp_wrbtr_2,
*           temp_valut_1,
*           temp_valut_2,
           temp_dmbtr_1,
           temp_dmbtr_2.
    CONCATENATE fs_field6-bldat+6(2) fs_field6-bldat+4(2) fs_field6-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field6-budat+6(2) fs_field6-budat+4(2) fs_field6-budat(4) INTO temp_budat." SEPARATED BY '.'.
*    CONCATENATE fs_field6-valut_1+6(2) fs_field6-valut_1+4(2) fs_field6-valut_1(4) INTO temp_valut_1." SEPARATED BY '.'.
*    CONCATENATE fs_field6-valut_2+6(2) fs_field6-valut_2+4(2) fs_field6-valut_2(4) INTO temp_valut_2.
    temp_wrbtr_1 = fs_field6-wrbtr_1.
    temp_wrbtr_2 = fs_field6-wrbtr_2.
    temp_dmbtr_1 = fs_field6-dmbtr_1.
    temp_dmbtr_2 = fs_field6-dmbtr_2.


    PERFORM bdc_dynpro      USING 'SAPMF05A'       '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'RF05A-NEWUM'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'     temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'     fs_field6-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'     fs_field6-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'     temp_budat.
*perform bdc_field       using 'BKPF-MONAT'     record-MONAT_005.
    PERFORM bdc_field       USING 'BKPF-WAERS'     fs_field6-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'     fs_field6-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'     fs_field6-bktxt.
*perform bdc_field       using 'FS006-DOCID'    record-DOCID_008.
    PERFORM bdc_field       USING 'RF05A-NEWBS'    fs_field6-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'    fs_field6-newko_1.
    PERFORM bdc_dynpro      USING 'SAPMF05A'       '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'     temp_wrbtr_1.
    IF fs_field6-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'      temp_dmbtr_1.
    ENDIF.
*    PERFORM bdc_field       USING 'BSEG-VALUT'     temp_valut_1.
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field6-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'     fs_field6-sgtxt_1.
    PERFORM bdc_field       USING 'RF05A-NEWBS'    fs_field6-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'    fs_field6-newko_2.
*perform bdc_field       using 'DKACB-FMORE'    record-FMORE_016.
    PERFORM bdc_dynpro      USING 'SAPLKACB'       '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'     fs_field6-gsber_1.
    PERFORM bdc_dynpro      USING 'SAPMF05A'       '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'     temp_wrbtr_2.
    IF fs_field6-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'      temp_dmbtr_2.
    ENDIF.
*    PERFORM bdc_field       USING 'BSEG-VALUT'     temp_valut_2.
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field6-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'     fs_field6-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'    record-FMORE_021.
    PERFORM bdc_dynpro      USING 'SAPLKACB'       '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'     'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'     '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'     fs_field6-gsber_2.
*    PERFORM bdc_dynpro      USING 'SAPMF05A'       '0300'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'     'BSEG-WRBTR'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'     '=BU'.
**    PERFORM bdc_field       USING 'BSEG-WRBTR'     fs_field6-wrbtr_3.
**perform bdc_field       using 'BSEG-VALUT'     record-VALUT_024.
**    PERFORM bdc_field       USING 'BSEG-SGTXT'     fs_field6-sgtxt_2.
**perform bdc_field       using 'DKACB-FMORE'    record-FMORE_026.
*    PERFORM bdc_dynpro      USING 'SAPLKACB'       '0002'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'     'COBL-GSBER'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'     '=ENTE'.
**    PERFORM bdc_field       USING 'COBL-GSBER'     fs_field6-gsber_3.
    PERFORM bdc_transaction USING 'F-02'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_ROLE_EXTENSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_role_extension .

  CLEAR: fs_field10.
  LOOP AT t_field10 INTO fs_field10.
    CLEAR: wa_info.
    REFRESH: bdcdata.

    PERFORM bdc_dynpro      USING 'SAPLPRGN_TREE'      '0121'.
    PERFORM bdc_field       USING 'BDC_CURSOR'         'AGR_NAME_NEU'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=AEND'.
    PERFORM bdc_field       USING 'AGR_NAME_NEU'       fs_field10-agr_name.
    PERFORM bdc_dynpro      USING 'SAPLPRGN_TREE'      '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'         'S_AGR_TEXTS-TEXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=TAB5'.
*perform bdc_field       using 'S_AGR_TEXTS-TEXT'   record-TEXT_002.
    PERFORM bdc_dynpro      USING 'SAPLPRGN_TREE'      '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'         'S_AGR_TEXTS-TEXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=GEN1'.
*perform bdc_field       using 'S_AGR_TEXTS-TEXT'   record-TEXT_003.
    PERFORM bdc_dynpro      USING 'SAPMSSY0'           '0120'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=DBAC'.
    PERFORM bdc_dynpro      USING 'SAPMSSY0'           '0120'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=ORGP'.
    PERFORM bdc_dynpro      USING 'SAPLSUPRN'          '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'         'T_STORG-BUTTON(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=P001'.
    PERFORM bdc_dynpro      USING 'SAPLSUPRN'          '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'         'T_STORG-LOW(02)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=SAVO'.
    PERFORM bdc_field       USING 'T_STORG-LOW(02)'    fs_field10-bukrs.
    PERFORM bdc_dynpro      USING 'SAPMSSY0'           '0120'.
    PERFORM bdc_field       USING 'BDC_OKCODE'         '=GEN1'.
    PERFORM bdc_transaction USING 'PFCG'.

*DATA ACTIVITY_GROUP              TYPE AGR_DEFINE-AGR_NAME.
*DATA PROFILE_NAME                TYPE AGR_1016-PROFILE.
*DATA PROFILE_TEXT                TYPE AGR_PROF-PTEXT.
*DATA NO_DIALOG                   TYPE SMENSAPNEW-CUSTOMIZED.
*DATA REBUILD_AUTH_DATA           TYPE SMENSAPNEW-CUSTOMIZED.
*DATA ORG_LEVELS_WITH_STAR        TYPE SMENSAPNEW-CUSTOMIZED.
*DATA FILL_EMPTY_FIELDS_WITH_STAR TYPE SMENSAPNEW-CUSTOMIZED.
*DATA TEMPLATE                    TYPE TPRVORT-PATTERN.
*DATA CHECK_PROFGEN_TABLES        TYPE SMENSAPNEW-CUSTOMIZED.
*DATA GENERATE_PROFILE            TYPE SMENSAPNEW-CUSTOMIZED.
*DATA AUTHORITY_CHECK_PFCG        TYPE SMENSAPNEW-CUSTOMIZED.

    CLEAR:activity_group.
    activity_group = fs_field10-agr_name.

    CALL FUNCTION 'PRGN_AUTO_GENERATE_PROFILE_NEW'
      EXPORTING
        activity_group                = activity_group
*       PROFILE_NAME                  = PROFILE_NAME
*       PROFILE_TEXT                  = PROFILE_TEXT
*       NO_DIALOG                     = ' '
*       REBUILD_AUTH_DATA             = 'X'
*       ORG_LEVELS_WITH_STAR          = ' '
*       FILL_EMPTY_FIELDS_WITH_STAR   = 'X'
*       TEMPLATE                      = ' '
        check_profgen_tables          = ' '
        generate_profile              = 'X'
*       AUTHORITY_CHECK_PFCG          = 'X'
      EXCEPTIONS
        activity_group_does_not_exist = 1
        activity_group_enqueued       = 2
        profile_name_exists           = 3
        profile_not_in_namespace      = 4
        no_auth_for_prof_creation     = 5
        no_auth_for_role_change       = 6
        no_auth_for_auth_maint        = 7
        no_auth_for_gen               = 8
        no_auths                      = 9
        open_auths                    = 10
        too_many_auths                = 11
        profgen_tables_not_updated    = 12
        error_when_generating_profile = 13.

    IF sy-subrc EQ 0.
*DATA WAIT   TYPE BAPITA-WAIT.
*DATA RETURN TYPE BAPIRET2.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'
*       IMPORTING
*         RETURN        = RETURN
        .
      IF sy-subrc <> 0.
*DATA RETURN TYPE BAPIRET2.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
*         IMPORTING
*           RETURN        = RETURN
          .
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_CUST_OPEN_ITEMS_DWN_S
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_cust_open_items_dwn_s .

  CLEAR:fs_field11.
  LOOP AT t_field11 INTO fs_field11.
    REFRESH: bdcdata.
    CLEAR:  wa_info.
    CLEAR  : temp_bldat,
               temp_budat  ,
               temp_wrbtr_1,
               temp_wrbtr_2,
               temp_duedate,
               temp_dmbtr_1,
               temp_dmbtr_2.
    CONCATENATE fs_field11-bldat+6(2) fs_field11-bldat+4(2) fs_field11-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field11-budat+6(2) fs_field11-budat+4(2) fs_field11-budat(4) INTO temp_budat." SEPARATED BY '.'.
    CONCATENATE fs_field11-zfbdt+6(2) fs_field11-zfbdt+4(2) fs_field11-zfbdt(4) INTO temp_duedate." SEPARATED BY '.'.
    temp_wrbtr_1 = fs_field11-wrbtr_1.
    temp_wrbtr_2 = fs_field11-wrbtr_2.
    temp_dmbtr_1 = fs_field11-dmbtr_1.
    temp_dmbtr_2 = fs_field11-dmbtr_2.

    PERFORM bdc_dynpro      USING 'SAPMF05A'      '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'RF05A-NEWUM'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'    temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'    fs_field11-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'    fs_field11-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'    temp_budat.
*perform bdc_field       using 'BKPF-MONAT'    record-MONAT_005.
    PERFORM bdc_field       USING 'BKPF-WAERS'    fs_field11-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'    fs_field11-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'    fs_field11-bktxt.
*perform bdc_field       using 'FS006-DOCID'   record-DOCID_007.
    PERFORM bdc_field       USING 'RF05A-NEWBS'   fs_field11-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'   fs_field11-newko_1.
    PERFORM bdc_field       USING 'RF05A-NEWUM'   fs_field11-newum.
    IF fs_field11-newum EQ 'V' OR fs_field11-newum = 'Z'.
      PERFORM bdc_dynpro      USING 'SAPMF05A' '0303'.
    ELSE.
      PERFORM bdc_dynpro      USING 'SAPMF05A'        '0304'.
    ENDIF.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'    temp_wrbtr_1.
    IF fs_field11-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'      temp_dmbtr_1.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-BUPLA'    fs_field11-bupla.
    PERFORM bdc_field       USING 'BSEG-SECCO'    fs_field11-secco.
    PERFORM bdc_field       USING 'BSEG-GSBER'    fs_field11-gsber_1.
    PERFORM bdc_field       USING 'BSEG-ZFBDT'    temp_duedate.       "due date
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field11-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'    fs_field11-sgtxt_1.
    PERFORM bdc_field       USING 'RF05A-NEWBS'   fs_field11-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'   fs_field11-newko_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A'      '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'    temp_wrbtr_2.
    IF fs_field11-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'      temp_dmbtr_2.
    ENDIF.
*    perform bdc_field       using 'BSEG-BUPLA'    fs_field11-BUPLA_2.
*perform bdc_field       using 'BSEG-VALUT'    record-VALUT_019.
    PERFORM bdc_field       USING 'BSEG-ZUONR'    fs_field11-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'    fs_field11-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'   record-FMORE_022.
    PERFORM bdc_dynpro      USING 'SAPLKACB'      '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'    'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'    fs_field11-gsber_2.
    PERFORM bdc_transaction USING 'F-02'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_VEND_OPEN_ITEMS_DWN_S
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_vend_open_items_dwn_s .

  CLEAR:fs_field12.
  LOOP AT t_field12 INTO fs_field12.
    REFRESH: bdcdata.
    CLEAR:  wa_info.
    CLEAR  : temp_bldat,
               temp_budat,
               temp_wrbtr_1,
               temp_wrbtr_2,
               temp_duedate,
               temp_dmbtr_1,
               temp_dmbtr_2.
    CONCATENATE fs_field12-bldat+6(2) fs_field12-bldat+4(2) fs_field12-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field12-budat+6(2) fs_field12-budat+4(2) fs_field12-budat(4) INTO temp_budat." SEPARATED BY '.'.
    CONCATENATE fs_field12-zfbdt+6(2) fs_field12-zfbdt+4(2) fs_field12-zfbdt(4) INTO temp_duedate." SEPARATED BY '.'.
    temp_wrbtr_1 = fs_field12-wrbtr_1.
    temp_wrbtr_2 = fs_field12-wrbtr_2.
    temp_dmbtr_1 = fs_field12-dmbtr_1.
    temp_dmbtr_2 = fs_field12-dmbtr_2.

    PERFORM bdc_dynpro      USING 'SAPMF05A' '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'
                                  temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'
                                  fs_field12-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'
                                  fs_field12-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'
                                  temp_budat.
    PERFORM bdc_field       USING 'BKPF-WAERS'
                                  fs_field12-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'
                                  fs_field12-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'
                                  fs_field12-bktxt.
*perform bdc_field       using 'FS006-DOCID'
*                              record-DOCID_007.
    PERFORM bdc_field       USING 'RF05A-NEWBS'
                                  fs_field12-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'
                                  fs_field12-newko_1.
    PERFORM bdc_field       USING 'RF05A-NEWUM'
                                  fs_field12-newum.
    IF fs_field12-newum EQ 'C' OR fs_field12-newum EQ 'E' OR fs_field12-newum EQ 'G'.
      PERFORM bdc_dynpro      USING 'SAPMF05A'          '0303'.
    ELSE.
      PERFORM bdc_dynpro      USING 'SAPMF05A'          '0304'.
    ENDIF.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'
                                  temp_wrbtr_1.
    IF fs_field12-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'      temp_dmbtr_1.
    ENDIF.

    PERFORM bdc_field       USING 'BSEG-BUPLA'
                                  fs_field12-bupla.
    PERFORM bdc_field       USING 'BSEG-SECCO'
                                  fs_field12-secco.
    PERFORM bdc_field       USING 'BSEG-GSBER'
                                  fs_field12-gsber_1.
    PERFORM bdc_field       USING 'BSEG-ZFBDT'
                                  temp_duedate. "due date
    PERFORM bdc_field       USING 'BSEG-ZUONR'
                                  fs_field12-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'
                                  fs_field12-sgtxt_1.
    PERFORM bdc_field       USING 'RF05A-NEWBS'
                                  fs_field12-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'
                                  fs_field12-newko_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A' '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'
                                   temp_wrbtr_2.
    IF fs_field12-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'      temp_dmbtr_2.
    ENDIF.
*    perform bdc_field       using 'BSEG-BUPLA'
*                                  fs_field12-bupla_2.
*perform bdc_field       using 'BSEG-VALUT'
*                              record-VALUT_019.
    PERFORM bdc_field       USING 'BSEG-ZUONR'
                                  fs_field12-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'
                                  fs_field12-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_022.
    PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'
                                  fs_field12-gsber_2.
    PERFORM bdc_transaction USING 'F-02'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_ASSET_EXTENSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_asset_extension .

  CLEAR: fs_field14.
  LOOP AT t_field14 INTO fs_field14.
    CLEAR: wa_info,
           temp_afabg,
           temp_menge.
    REFRESH: bdcdata.

    CONCATENATE fs_field14-afabg+6(2) fs_field14-afabg+4(2) fs_field14-afabg(4) INTO temp_afabg.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = fs_field14-ranl1
      IMPORTING
        output = fs_field14-ranl1.

    MOVE fs_field14-menge TO temp_menge.
    SET PARAMETER ID 'ANK' FIELD space.

    PERFORM bdc_dynpro      USING 'SAPLAIST' '0105'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RA02S-RBUKR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'ANLA-ANLKL'
                                  ' '.
    PERFORM bdc_field       USING 'ANLA-BUKRS'
                                  fs_field14-bukrs.
*perform bdc_field       using 'RA02S-NASSETS'
*                              record-NASSETS_003.
    PERFORM bdc_field       USING 'RA02S-RANL1'
                                  fs_field14-ranl1.
    PERFORM bdc_field       USING 'RA02S-RBUKR'
                                  fs_field14-rbukr.
    PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=TAB02'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'ANLA-SERNR'.
*perform bdc_field       using 'ANLA-TXT50'
*                              record-TXT50_006.
*perform bdc_field       using 'ANLA-TXA50'
*                              record-TXA50_007.
*perform bdc_field       using 'ANLH-ANLHTXT'
*                              record-ANLHTXT_008.
    PERFORM bdc_field       USING 'ANLA-INVNR'
                              fs_field14-invnr.
*    PERFORM bdc_field       USING 'ANLA-SERNR'
*                                 fs_field14-sernr.
    PERFORM bdc_field       USING 'ANLA-MENGE'
                                  temp_menge.
    PERFORM bdc_field       USING 'ANLA-MEINS'
                                  fs_field14-meins.
*perform bdc_field       using 'ANLA-AKTIV'
*                              record-AKTIV_012.
    PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=TAB08'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'ANLZ-WERKS'.
*    PERFORM bdc_field       USING 'ANLZ-GSBER'
*                                  fs_field14-gsber.
    PERFORM bdc_field       USING 'ANLZ-KOSTL'
                                  fs_field14-kostl.
    PERFORM bdc_field       USING 'ANLZ-WERKS'
                                  fs_field14-werks.
    PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BUCH'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'ANLB-AFABG(02)'.

    PERFORM bdc_field       USING 'ANLB-AFABG(02)'
                                  temp_afabg.
    PERFORM bdc_transaction USING 'AS01'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_MOD_WHLDING_TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_mod_whlding_tax_v .

  " Conversion routine
  LOOP AT t_field16 ASSIGNING <fs_field16>.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = <fs_field16>-lifnr
      IMPORTING
        output = <fs_field16>-lifnr.
  ENDLOOP.
  REFRESH : it_lfbw.
  SELECT * FROM lfbw INTO TABLE it_lfbw
    FOR ALL ENTRIES IN t_field16
    WHERE lifnr EQ t_field16-lifnr
    AND bukrs EQ t_field16-bukrs.
  IF sy-subrc EQ 0.
    SORT it_lfbw.
    LOOP AT it_lfbw ASSIGNING <fs_lfbw>.
      <fs_lfbw>-wt_subjct = ''.
    ENDLOOP.

    MODIFY lfbw FROM TABLE it_lfbw.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      IF sy-subrc EQ 0.
        MESSAGE TEXT-005 TYPE 'I'.
      ELSE.
        ROLLBACK WORK .
        MESSAGE TEXT-001 TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.
*  ENDIF.
*  CLEAR: fs_field16.
*  LOOP AT t_field16 INTO fs_field16.
*    CLEAR: wa_info.
*    REFRESH: bdcdata.
*
*    PERFORM bdc_dynpro      USING 'SAPMF02K' '0101'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'RF02K-D0610'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '/00'.
*    PERFORM bdc_field       USING 'RF02K-LIFNR'
*                                  fs_field16-lifnr.
*    PERFORM bdc_field       USING 'RF02K-BUKRS'
*                                  fs_field16-bukrs.
*    PERFORM bdc_field       USING 'RF02K-D0610'
*                                  'X'.
*    PERFORM bdc_dynpro      USING 'SAPMF02K' '0610'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '=UPDA'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'LFBW-WT_SUBJCT(01)'.
*    PERFORM bdc_field       USING 'LFB1-QLAND'
*                                  'IN'.
**    perform bdc_field       using 'LFBW-WT_SUBJCT(01)'
**                                  ''.
**    perform bdc_field       using 'LFBW-WT_SUBJCT(02)'
**                                  ''.
**    perform bdc_field       using 'LFBW-WT_SUBJCT(03)'
**                                  ''.
*    CLEAR : idx.
*    MOVE 1 TO idx.
*    LOOP AT it_lfbw TRANSPORTING NO FIELDS WHERE lifnr = fs_field16-lifnr
*                                  AND bukrs = fs_field16-bukrs.
*      CONCATENATE 'LFBW-WT_SUBJCT(' idx ')' INTO fnam.
*      PERFORM bdc_field       USING fnam      ''.
*      idx = idx + 1.
*    ENDLOOP.
*
*    PERFORM bdc_transaction USING 'XK02'.
*
*
*  ENDLOOP.
*

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_ASSET_INTRCMPNY_TRNSFR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM zdemrgr_asset_intrcmpny_trnsfr.

  CLEAR: fs_field15.
  LOOP AT t_field15 INTO fs_field15.
    CLEAR: wa_info,
           temp_bldat,
           temp_budat,
           temp_bzdat.

    REFRESH: bdcdata.

    CONCATENATE fs_field15-bldat+6(2) fs_field15-bldat+4(2) fs_field15-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field15-budat+6(2) fs_field15-budat+4(2) fs_field15-budat(4) INTO temp_budat." SEPARATED BY '.'.
    CONCATENATE fs_field15-bzdat+6(2) fs_field15-bzdat+4(2) fs_field15-bzdat(4) INTO temp_bzdat.

*perform bdc_dynpro      using 'SAPLAMDP' '0100'.
*perform bdc_field       using 'BDC_OKCODE'
*                              '=TAB02'.
*perform bdc_field       using 'RAIFP2-ANLN1'
*                              fs_field15-ANLN1_1.
*perform bdc_field       using 'RAIFP2-ANLN2'
*                              fs_field15-ANLN2_1.
*perform bdc_field       using 'RAIFP1-BLDAT'
*                              temp_bldat.
*perform bdc_field       using 'RAIFP1-BUDAT'
*                              temp_budat.
*perform bdc_field       using 'RAIFP1-BZDAT'
*                              temp_bzdat.
*perform bdc_field       using 'RAIFP2-SGTXT'
*                              fs_field15-SGTXT.
*perform bdc_field       using 'RAIFP2-XNOER'
*                              fs_field15-XNOER.
*perform bdc_field       using 'BDC_CURSOR'
*                              'RAIFP3-ANLN2'.
**perform bdc_field       using 'RAIFP3-XBANL'
**                              record-XBANL_008.
*perform bdc_field       using 'RAIFP3-ANLN1'
*                              fs_field15-ANLN1_2.
*perform bdc_field       using 'RAIFP3-ANLN2'
*                              fs_field15-ANLN2_2.
*perform bdc_field       using 'RAIFP3-BUKRS'
*                              fs_field15-BUKRS.
*perform bdc_dynpro      using 'SAPLAMDP' '0100'.
*perform bdc_field       using 'BDC_OKCODE'
*                              '=SAVE'.
**perform bdc_field       using 'RAIFP2-ANLN1'
**                              record-ANLN1_012.
**perform bdc_field       using 'RAIFP2-ANLN2'
**                              record-ANLN2_013.
*perform bdc_field       using 'BDC_CURSOR'
*                              'RAIFP1-BLART'.
*perform bdc_field       using 'RAIFP1-BLART'
*                              fs_field15-BLART.
**perform bdc_field       using 'RAIFP1-TRAVA'
**                              record-TRAVA_015.
*perform bdc_transaction using 'ABT1N'.

*    PERFORM bdc_dynpro      USING 'SAPLSPO4' '0300'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'SVALD-VALUE(01)'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '=FURT'.
*    PERFORM bdc_field       USING 'SVALD-VALUE(01)'
*                                  fs_field15-value.
    PERFORM bdc_dynpro      USING 'SAPLAMDP' '0100'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=TAB02'.
    PERFORM bdc_field       USING 'RAIFP2-ANLN1'
                                  fs_field15-anln1_1.
    PERFORM bdc_field       USING 'RAIFP2-ANLN2'
                                  fs_field15-anln2_1.
    PERFORM bdc_field       USING 'RAIFP1-BLDAT'
                                  temp_bldat.
    PERFORM bdc_field       USING 'RAIFP1-BUDAT'
                                  temp_budat.
    PERFORM bdc_field       USING 'RAIFP1-BZDAT'
                                  temp_bzdat.
    PERFORM bdc_field       USING 'RAIFP2-SGTXT'
                                  fs_field15-sgtxt.
    PERFORM bdc_field       USING 'RAIFP2-XNOER'
                                  fs_field15-xnoer.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RAIFP3-ANLN2'.
    PERFORM bdc_field       USING 'RAIFP3-XBANL'
                                  'X'.
    PERFORM bdc_field       USING 'RAIFP3-ANLN1'
                                  fs_field15-anln1_2.
    PERFORM bdc_field       USING 'RAIFP3-ANLN2'
                                  fs_field15-anln2_2.
    PERFORM bdc_field       USING 'RAIFP3-BUKRS'
                                  fs_field15-bukrs.
    PERFORM bdc_dynpro      USING 'SAPLAMDP' '0100'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=SAVE'.
*perform bdc_field       using 'RAIFP2-ANLN1'
*                              '1100048'.
*perform bdc_field       using 'RAIFP2-ANLN2'
*                              '1'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RAIFP1-BLART'.
    PERFORM bdc_field       USING 'RAIFP1-BLART'
                                  fs_field15-blart.
*perform bdc_field       using 'RAIFP1-TRAVA'
*                              '1'.
    PERFORM bdc_transaction USING 'ABT1N'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_MOD_WHLDING_TAX_C
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_mod_whlding_tax_c .

  " Conversion routine
  LOOP AT t_field17 ASSIGNING <fs_field17>.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = <fs_field17>-kunnr
      IMPORTING
        output = <fs_field17>-kunnr.
  ENDLOOP.

  REFRESH : it_knbw.
  SELECT * FROM knbw INTO TABLE it_knbw
    FOR ALL ENTRIES IN t_field17
    WHERE kunnr EQ t_field17-kunnr
    AND bukrs EQ t_field17-bukrs.
  IF sy-subrc EQ 0.
    SORT it_knbw.
    LOOP AT it_knbw ASSIGNING <fs_knbw>.
      <fs_knbw>-wt_agent = ''.
    ENDLOOP.

    MODIFY knbw FROM TABLE it_knbw.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      IF sy-subrc EQ 0.
        MESSAGE TEXT-005 TYPE 'I'.
      ELSE.
        ROLLBACK WORK .
        MESSAGE TEXT-002 TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.


*  ENDIF.
*  CLEAR: fs_field17.
*  LOOP AT t_field17 INTO fs_field17.
*    CLEAR: wa_info.
*    REFRESH: bdcdata.
*
*    PERFORM bdc_dynpro      USING 'SAPMF02D' '0101'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'RF02D-BUKRS'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '/00'.
*    PERFORM bdc_field       USING 'RF02D-KUNNR'
*                                  fs_field17-kunnr.
*    PERFORM bdc_field       USING 'RF02D-BUKRS'
*                                  fs_field17-bukrs.
*    PERFORM bdc_field       USING 'RF02D-D0610'
*                                  'X'.
*    PERFORM bdc_dynpro      USING 'SAPMF02D' '0610'.
*    PERFORM bdc_field       USING 'BDC_OKCODE'
*                                  '=UPDA'.
*    PERFORM bdc_field       USING 'BDC_CURSOR'
*                                  'KNBW-WT_AGENT(01)'.
*    CLEAR : idx.
*    MOVE 1 TO idx.
*    LOOP AT it_knbw TRANSPORTING NO FIELDS WHERE kunnr = fs_field17-kunnr
*                                  AND bukrs = fs_field17-bukrs.
*      CONCATENATE 'KNBW-WT_AGENT(' idx ')' INTO fnam.
*      PERFORM bdc_field       USING fnam      ''.
*      idx = idx + 1.
*    ENDLOOP.
**perform bdc_field       using 'KNBW-WT_AGENT(01)'     ''.
*    PERFORM bdc_transaction USING 'XD02'.
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_INTERNAL_ORDER_TECH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_internal_order_tech .

  CLEAR: fs_field18.
  LOOP AT t_field18 INTO fs_field18.
    CLEAR: wa_info.
    REFRESH: bdcdata.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = fs_field18-aufnr
      IMPORTING
        output = fs_field18-aufnr.

    PERFORM bdc_dynpro      USING 'SAPMKAUF' '0110'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COAS-AUFNR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'COAS-AUFNR'
                                  fs_field18-aufnr.
    PERFORM bdc_dynpro      USING 'SAPMKAUF' '0600'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COAS-KTEXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=PHS2'.
*perform bdc_field       using 'COAS-KTEXT'
*                              'PM/OTDR/SOTR/001/ANRTISU MOD. MW9076C'.
*perform bdc_field       using 'COAS-WERKS'
*                              '1300'.
*perform bdc_field       using 'COAS-KOSTV'
*                              'QAC1320'.
*perform bdc_field       using 'COAS-AKSTL'
*                              'QAC1320'.
    PERFORM bdc_dynpro      USING 'SAPMKAUF' '0600'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COAS-KTEXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BUT4'.
*perform bdc_field       using 'COAS-KTEXT'
*                              'PM/OTDR/SOTR/001/ANRTISU MOD. MW9076C'.
*perform bdc_field       using 'COAS-WERKS'
*                              '1300'.
*perform bdc_field       using 'COAS-KOSTV'
*                              'QAC1320'.
*perform bdc_field       using 'COAS-AKSTL'
*                              'QAC1320'.
    PERFORM bdc_dynpro      USING 'SAPMKAUF' '0600'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=SICH'.
*perform bdc_field       using 'COAS-KTEXT'
*                              'PM/OTDR/SOTR/001/ANRTISU MOD. MW9076C'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COAS-USER2'.
    PERFORM bdc_field       USING 'COAS-USER0'
                                  fs_field18-user0.
    PERFORM bdc_field       USING 'COAS-USER2'
                                  fs_field18-user2.
    PERFORM bdc_transaction USING 'KO02'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_CREATE_ASSET_GRP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_create_asset_grp .

  CLEAR : fs_field21.
  LOOP AT t_field21 INTO fs_field21.
    CLEAR: wa_info.
    REFRESH: bdcdata.
    SET PARAMETER ID 'ANK' FIELD space.
    PERFORM bdc_dynpro      USING 'SAPLAIST' '0106'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RA02S-RBUKGR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'ANLA-ANLKL'
                                  fs_field21-anlkl.
    PERFORM bdc_field       USING 'ANLA-BUKRS'
                                  fs_field21-bukrs.
    PERFORM bdc_field       USING 'RA02S-RANLGR'
                                  fs_field21-ranlgr.
    PERFORM bdc_field       USING 'RA02S-RBUKGR'
                                  fs_field21-rbukgr.
    PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  'TAB02'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'ANLA-ANLN1'.
    PERFORM bdc_field       USING 'ANLA-ANLN1'
                                  fs_field21-anln1.
*    PERFORM bdc_field       USING 'ANLA-ANLN2'
*                                  '0'.
*    PERFORM bdc_field       USING 'ANLA-TXT50'
*                                  'LAB EQUIPMENTS 35% & 15%'.
*    PERFORM bdc_field       USING 'ANLA-TXA50'
*                                  'LAB EQUIPMENTS 35% & 15%'.
*    PERFORM bdc_field       USING 'ANLA-AKTIV'
*                                  '01.04.1995'.
    PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BUCH'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'ANLZ-KOSTL'.
    PERFORM bdc_field       USING 'ANLZ-GSBER'
                                  fs_field21-gsber.
    PERFORM bdc_field       USING 'ANLZ-KOSTL'
                                  fs_field21-kostl.
    SET PARAMETER ID 'ANK' FIELD space.
    PERFORM bdc_transaction USING 'AS21'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_CREATE_ASSET_SUB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_create_asset_sub .

  CLEAR: fs_field24.
  LOOP AT t_field24 INTO fs_field24.
    CLEAR: wa_info.
    REFRESH: bdcdata.

    MOVE fs_field24-menge TO temp_menge.
*temp_menge = fs_field24-menge.
*condense temp_menge.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = fs_field24-anln1
      IMPORTING
        output = fs_field24-anln1.

    PERFORM bdc_dynpro      USING 'SAPLAIST' '0110'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'ANLA-BUKRS'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'ANLA-ANLN1'
                                  fs_field24-anln1.
    PERFORM bdc_field       USING 'ANLA-BUKRS'
                                  fs_field24-bukrs.
    PERFORM bdc_field       USING 'RA02S-NASSETS'
                                  fs_field24-nassets.
    PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BUCH'.
*perform bdc_field       using 'ANLA-TXT50'
*                              record-TXT50_004.
    PERFORM bdc_field       USING 'ANLA-INVNR'
                                  fs_field24-invnr.
    PERFORM bdc_field       USING 'ANLA-MENGE'
                                  temp_menge.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'ANLA-INVZU'.
*perform bdc_field       using 'ANLA-INKEN'
*                              record-INKEN_007.
    PERFORM bdc_field       USING 'ANLA-INVZU'
                                  fs_field24-invzu.
    PERFORM bdc_transaction USING 'AS11'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZDEMRGR_VEND_OPEN_ITEMS_DWN_X
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zdemrgr_vend_open_items_dwn_x .

  CLEAR: fs_field31.
  LOOP AT t_field31 INTO fs_field31.
    CLEAR: wa_info.
    REFRESH : bdcdata.
    CLEAR  : temp_bldat,
                   temp_budat,
                   temp_wrbtr_1,
                   temp_wrbtr_2,
                   temp_duedate,
                   temp_dmbtr_1,
                   temp_dmbtr_2.
    CONCATENATE fs_field31-bldat+6(2) fs_field31-bldat+4(2) fs_field31-bldat(4) INTO temp_bldat." SEPARATED BY '.'.
    CONCATENATE fs_field31-budat+6(2) fs_field31-budat+4(2) fs_field31-budat(4) INTO temp_budat." SEPARATED BY '.'.
    CONCATENATE fs_field31-zfbdt+6(2) fs_field31-zfbdt+4(2) fs_field31-zfbdt(4) INTO temp_duedate." SEPARATED BY '.'.
    temp_wrbtr_1 = fs_field31-wrbtr_1.
    temp_wrbtr_2 = fs_field31-wrbtr_2.
    temp_dmbtr_1 = fs_field31-dmbtr_1.
    temp_dmbtr_2 = fs_field31-dmbtr_2.

    PERFORM bdc_dynpro      USING 'SAPMF05A' '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF05A-NEWUM'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'BKPF-BLDAT'
                                  temp_bldat.
    PERFORM bdc_field       USING 'BKPF-BLART'
                                  fs_field31-blart.
    PERFORM bdc_field       USING 'BKPF-BUKRS'
                                  fs_field31-bukrs.
    PERFORM bdc_field       USING 'BKPF-BUDAT'
                                  temp_budat.
    PERFORM bdc_field       USING 'BKPF-WAERS'
                                  fs_field31-waers.
    PERFORM bdc_field       USING 'BKPF-XBLNR'
                                  fs_field31-xblnr.
    PERFORM bdc_field       USING 'BKPF-BKTXT'
                                  fs_field31-bktxt.
*perform bdc_field       using 'FS006-DOCID'
*                              record-DOCID_007.
    PERFORM bdc_field       USING 'RF05A-NEWBS'
                                  fs_field31-newbs_1.
    PERFORM bdc_field       USING 'RF05A-NEWKO'
                                  fs_field31-newko_1.
    PERFORM bdc_field       USING 'RF05A-NEWUM'
                                  fs_field31-newum.
    PERFORM bdc_dynpro      USING 'SAPMF05A' '0320'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF05A-NEWKO'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'
                                  temp_wrbtr_1.
    IF fs_field31-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'
                                    temp_dmbtr_1.
    ENDIF.
    PERFORM bdc_field       USING 'BSEG-ZUONR'
                                  fs_field31-zuonr_1.
    PERFORM bdc_field       USING 'BSEG-GSBER'
                                  fs_field31-gsber_1.
    PERFORM bdc_field       USING 'BSEG-SGTXT'
                                  fs_field31-sgtxt_1.
    PERFORM bdc_field       USING 'BSEG-BUPLA'
                                  fs_field31-bupla.
    PERFORM bdc_field       USING 'BSEG-ZFBDT'
                                  temp_duedate.
*perform bdc_field       using 'BSED-WNAME'
*                              record-WNAME_018.
*perform bdc_field       using 'BSED-WORT1'
*                              record-WORT1_019.
*perform bdc_field       using 'BSED-REGIO'
*                              record-REGIO_020.
*perform bdc_field       using 'BSED-WBZOG'
*                              record-WBZOG_021.
*perform bdc_field       using 'BSED-WORT2'
*                              record-WORT2_022.
    PERFORM bdc_field       USING 'RF05A-NEWBS'
                                  fs_field31-newbs_2.
    PERFORM bdc_field       USING 'RF05A-NEWKO'
                                  fs_field31-newko_2.
    PERFORM bdc_dynpro      USING 'SAPMF05A' '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'BSEG-SGTXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
    PERFORM bdc_field       USING 'BSEG-WRBTR'
                                  temp_wrbtr_2.
    IF fs_field31-waers NE 'INR'.
      PERFORM bdc_field       USING 'BSEG-DMBTR'
                                    temp_dmbtr_2.
    ENDIF.
*perform bdc_field       using 'BSEG-VALUT'
*                              record-VALUT_027.
    PERFORM bdc_field       USING 'BSEG-ZUONR'
                                  fs_field31-zuonr_2.
    PERFORM bdc_field       USING 'BSEG-SGTXT'
                                  fs_field31-sgtxt_2.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_030.
    PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'COBL-GSBER'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTE'.
    PERFORM bdc_field       USING 'COBL-GSBER'
                                  fs_field31-gsber_2.
    PERFORM bdc_transaction USING 'F-02'.

  ENDLOOP.

ENDFORM.
