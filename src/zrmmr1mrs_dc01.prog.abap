*&---------------------------------------------------------------------*
*&  Include           ZRMMR1MRS_DC01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  ekrsdc_read                                              *
*&---------------------------------------------------------------------*
*  read table EKRSDC according to the entered data on the selection    *
*  screen and fill internal table pto_ekrsdc                           *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->PTO_EKRSDC  internal table of type TYP_EKRSDC                *
*      -->PTO_EKBEL   internal table of structure EKBEL                *
*      -->PTO_EKKO_KEY  internal table of structure EKKO_KEY           *
*----------------------------------------------------------------------*
FORM ekrsdc_read  TABLES pto_ekrsdc TYPE typ_tekrsdc
                         pto_ekbel STRUCTURE ekbel
                         pto_ekko_key STRUCTURE ekko_key.

  DATA: h_ebeln LIKE ekko-ebeln.
  DATA: s_ekrsdc TYPE ekrsdc,
        s_ekbel TYPE ekbel,
        s_ekko_key TYPE ekko_key.

  SELECT * FROM ekrsdc INTO TABLE pto_ekrsdc            "#EC CI_NOFIELD
     WHERE bukrs IN b_bukrs
     AND   werks IN b_werks
     AND   lifnr IN b_lifnr
     AND   ebeln IN b_ebeln
     AND   ebelp IN b_ebelp
    and    belnr in b_mblnr   "added by primus jyoti on 07.03.2024
    and    gjahr in b_mjahr. "added by primus jyoti on 07.03.2024
  IF sy-subrc IS INITIAL.
    CLEAR h_ebeln.
    LOOP AT pto_ekrsdc INTO s_ekrsdc.
      IF NOT s_ekrsdc-ebeln EQ h_ebeln.
        h_ebeln = s_ekrsdc-ebeln.
        READ TABLE pto_ekbel INTO s_ekbel
         WITH TABLE KEY ebeln = s_ekrsdc-ebeln
                        ebelp = s_ekrsdc-ebelp.
        IF NOT sy-subrc IS INITIAL.
          MOVE s_ekrsdc-ebeln TO s_ekbel-ebeln.
          MOVE s_ekrsdc-ebelp TO s_ekbel-ebelp.
          APPEND s_ekbel TO pto_ekbel.
        ENDIF.
        READ TABLE pto_ekko_key INTO s_ekko_key
         WITH KEY ebeln = s_ekrsdc-ebeln.
        IF NOT sy-subrc IS INITIAL.
          MOVE s_ekrsdc-ebeln TO s_ekko_key-ebeln.
          APPEND s_ekko_key TO pto_ekko_key.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " ekrsdc_read
*&---------------------------------------------------------------------*
*&      Form  ekrsdc_data_collect                                      *
*&---------------------------------------------------------------------*
*  collect selected EKRSDC data and create a total line per condition  *
*  type for an purchase order item                                     *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->PTI_EKRSDC  internal table of type TYP_EKRSDC                *
*      <--PTO_PODATA  internal table of type TYP_PODATA                *
*----------------------------------------------------------------------*
FORM ekrsdc_data_collect  TABLES   pti_ekrsdc TYPE typ_tekrsdc
                                  pto_podata TYPE typ_tpodata.

  DATA: s_ekrsdc TYPE ekrsdc,
        s_podata TYPE typ_podata.
  DATA : WA_XERW_EKRS  TYPE t_erw_ekrs."'ADDED BY JYOTI ON 18.04.2024
* pti_ekrs TYPE tab_erw_ekrs
  xerw_ekrs_NEW = xerw_ekrs[].
LOOP AT xerw_ekrs_NEW INTO WA_XERW_EKRS .
*  LOOP AT pti_ekrsdc INTO s_ekrsdc WHERE BELNR = WA_XERW_EKRS-BELNR
*                                         AND EBELN = WA_XERW_EKRS-EBELN.
     LOOP AT pti_ekrsdc INTO s_ekrsdc WHERE BELNR = WA_XERW_EKRS-BELNR
                                         AND EBELN = WA_XERW_EKRS-EBELN.
    s_podata-lifnr = s_ekrsdc-lifnr. " line per vendor
    s_podata-lFBNR = s_ekrsdc-BELNR. " line perMIGO "ADDED BY JYOTI ON 18.04.2024
    s_podata-ebeln = s_ekrsdc-ebeln. " line per PO
    s_podata-ebelp = s_ekrsdc-ebelp. " line per PO item
    s_podata-stunr = s_ekrsdc-stunr. " line per stunr,
    s_podata-zaehk = s_ekrsdc-zaehk. " line per zaehl
    s_podata-kschl = s_ekrsdc-kschl. " line per kschl
    COLLECT s_podata INTO pto_podata.
*    APPEND s_podata TO pto_podata.
  ENDLOOP.
  ENDLOOP.
  SORT pto_podata.

ENDFORM.                    " ekrsdc_data_collect
*&---------------------------------------------------------------------*
*&      Form  podata_read                                              *
*&---------------------------------------------------------------------*
*  read PO data for the PO items in internal table pti_ekbel and fill  *
*  internal table  PTO_SEGTAB_DC                                       *
*    - prefetch PO item data                                           *
*    - single read of PO header data                                   *
*    - read vendor data to determine payment terms and currency (when  *
*      freight vendor is different to the vendor of the PO             *
*    - single read of PO item data                                     *
*    - read PO history for planned delivery costs                      *
*----------------------------------------------------------------------*
*  Parameter:                                                          *
*      -->PTI_PODATA  internal table of type TYP_PODATA                *
*      -->PTI_EKBEL  internal table of structure EKBEL                 *
*      -->PTI_EKKO_KEY  internal table of structure EKKO_KEY           *
*      <--PTO_SEGTAB_DC  internal table of type MMERS_SEGTAB           *
*----------------------------------------------------------------------*
FORM podata_read  TABLES  pti_podata TYPE typ_tpodata
                          pti_ekbel STRUCTURE ekbel
                          pti_ekko_key STRUCTURE ekko_key
                          pto_segtab_dc TYPE mmers_tsegtab.


  DATA: BEGIN OF h_ekko.
          INCLUDE STRUCTURE ekko.
  DATA: END OF h_ekko.

  DATA: pe_ekpo TYPE ekpo,
        l_lfm1 TYPE lfm1.

  DATA: yek08bn TYPE ek08bn OCCURS 0.

  DATA: s_ekko_key TYPE ekko,
        s_podata TYPE typ_podata,
        s_segtab_dc TYPE mmers_segtab,
        s_vf_kred LIKE vf_kred,
        s_yek08bn TYPE ek08bn.

  DATA: last_ebeln LIKE ekko-ebeln,
        last_ebelp LIKE ekpo-ebelp,
        last_lifnr LIKE ekko-lifnr,
        h_ekko_ebeln LIKE ekko-ebeln.

  DATA: f_ekko_rc TYPE i,
        count TYPE i.

  DATA: lt_ek08bn_item TYPE STANDARD TABLE OF ek08bn_item.
  FIELD-SYMBOLS: <ls_ek08bn_item> TYPE ek08bn_item.

*---------------prefetch PO item data-----------------------------------*
  CALL FUNCTION 'ME_EKPO_ARRAY_READ'
    EXPORTING
      pi_refresh_buffer = 'X'
    TABLES
      pti_ekpo_key      = pti_ekbel
    EXCEPTIONS
      OTHERS            = 2.

  LOOP AT pti_podata INTO s_podata.
    CLEAR s_segtab_dc.
    s_segtab_dc-LFBNR = s_podata-LFBNR."ADDED BY JYOTI ON 18.10.2024
    s_segtab_dc-abrechenbar = 'X'.
    MOVE-CORRESPONDING s_podata TO s_segtab_dc.
    MOVE 'X' TO s_segtab_dc-xekbz.
*    MOVE s_podata-lifnr TO s_segtab_dc-lifre.
*------ read PO header data, if PO number changed------------------------*
    IF NOT s_podata-ebeln EQ h_ekko_ebeln.
      h_ekko_ebeln = s_podata-ebeln.
      PERFORM po_header_read USING h_ekko_ebeln
                             CHANGING h_ekko
                                      f_ekko_rc.

    ENDIF.
    IF NOT f_ekko_rc = 0.
*---if no PO header is found item can not be settled---------------------*
      s_segtab_dc-abrechenbar = space.
      s_segtab_dc-arbgb = 'XX'.
      s_segtab_dc-txtnr = '001'.      "Bestellung nicht vorhanden
      s_segtab_dc-text  = text-e01.

    ELSE.
*------determine payment terms from the vendor data-----------------------*
      CALL FUNCTION 'FI_VENDOR_DATA'
        EXPORTING
          i_bukrs        = h_ekko-bukrs
          i_lifnr        = s_podata-lifnr
        IMPORTING
          e_kred         = s_vf_kred
        EXCEPTIONS
          vendor_missing = 1.
      IF sy-subrc IS INITIAL.
        MOVE s_vf_kred-zterm TO s_segtab_dc-zterm.
      ENDIF.
*----read vendor data to determine the curreny, if the freight-------------*
*----vendor is different to the vendor defined in the PO-------------------*
      IF NOT s_podata-lifnr EQ h_ekko-lifnr.
        IF NOT s_podata-lifnr EQ l_lfm1-lifnr.
          CALL FUNCTION 'VENDOR_MASTER_DATA_SELECT_12'
            EXPORTING
              pi_lifnr       = s_podata-lifnr
              pi_ekorg       = h_ekko-ekorg
            IMPORTING
              pe_lfm1        = l_lfm1
*             PE_EKORZ       =
            EXCEPTIONS
              no_entry_found = 1
              OTHERS         = 2.
        ENDIF.
        IF sy-subrc IS INITIAL.
          IF NOT l_lfm1-waers IS INITIAL.
            MOVE l_lfm1-waers TO s_segtab_dc-waers.
          ELSE.
            MOVE h_ekko-waers TO s_segtab_dc-waers.
          ENDIF.
        ENDIF.
      ELSE.
        MOVE h_ekko-waers TO s_segtab_dc-waers.
      ENDIF.
*-----read PO item data, if PO number or PO item changed-------------------*
      IF NOT s_podata-ebeln EQ pe_ekpo-ebeln
       OR NOT s_podata-ebelp EQ pe_ekpo-ebelp.

        CALL FUNCTION 'ME_EKPO_SINGLE_READ'
          EXPORTING
            pi_ebeln         = s_podata-ebeln
            pi_ebelp         = s_podata-ebelp
          IMPORTING
            po_ekpo          = pe_ekpo
          EXCEPTIONS
            no_records_found = 1.

      ENDIF.
*-----if no PO item is found item can not be settled-------------------------*
      IF pe_ekpo IS INITIAL.
        s_segtab_dc-abrechenbar = space.
        s_segtab_dc-arbgb = 'XX'.
        s_segtab_dc-txtnr = '001'.
        s_segtab_dc-text = text-e01.  "PO item not found
      ELSE.
*-----tax code and jurisdiction code are taken from the PO item data---------*
*-----this can be changed within the BAdI MRM_ERS_IDAT_MODIFY----------------*
        MOVE pe_ekpo-mwskz TO s_segtab_dc-mwskz.
        MOVE pe_ekpo-txjcd TO s_segtab_dc-txjcd.
      ENDIF.
      IF NOT s_podata-ebeln EQ last_ebeln
      OR NOT s_podata-ebelp EQ last_ebelp
      OR NOT s_podata-lifnr EQ last_lifnr.
        CLEAR yek08bn.
        REFRESH yek08bn.
        last_ebeln = s_podata-ebeln.
        last_ebelp = s_podata-ebelp.
        last_lifnr = s_podata-lifnr.

*---read PO history for delivery costs----------------------------------------*
        CALL FUNCTION 'ME_READ_COND_INVOICE'
          EXPORTING
            i_ebeln      = s_podata-ebeln
            i_ebelp      = s_podata-ebelp
            i_lifnr      = s_podata-lifnr
            i_display    = 'X'
          TABLES
            xek08bn_item = lt_ek08bn_item
            xek08bn      = yek08bn.
      ENDIF.
      DESCRIBE TABLE yek08bn LINES count.
      IF count = 0.
        s_segtab_dc-abrechenbar = space.
        s_segtab_dc-arbgb = 'XX'.
        s_segtab_dc-txtnr = '001'.
        s_segtab_dc-text = text-e01.  "Error in PO history - EKBZ
      ELSE.
        READ TABLE yek08bn INTO s_yek08bn
              WITH KEY stunr = s_podata-stunr
                       zaehk = s_podata-zaehk
                       kschl = s_podata-kschl.
        IF sy-subrc IS INITIAL.
          IF s_yek08bn-vrtkz IS INITIAL.
            IF s_yek08bn-wemng NE s_yek08bn-remng.
              IF s_yek08bn-wemng > s_yek08bn-remng.
                MOVE 'X' TO s_segtab_dc-xrech.
              ELSE.
                MOVE space TO s_segtab_dc-xrech.
              ENDIF.
            ELSE.
              MOVE 'X' TO s_segtab_dc-xrech.
              MOVE 'X' TO s_segtab_dc-nullpos.
            ENDIF.
          ELSE.
            READ TABLE lt_ek08bn_item ASSIGNING <ls_ek08bn_item>
                                      WITH KEY ebeln = s_yek08bn-ebeln
                                               ebelp = s_yek08bn-ebelp
                                               stunr = s_yek08bn-stunr
                                               zaehk = s_yek08bn-zaehk.
            IF <ls_ek08bn_item>-wemng NE <ls_ek08bn_item>-remng.
              IF <ls_ek08bn_item>-wemng > <ls_ek08bn_item>-remng.
                MOVE 'X' TO s_segtab_dc-xrech.
              ELSE.
                MOVE space TO s_segtab_dc-xrech.
              ENDIF.
            ELSE.
              MOVE 'X' TO s_segtab_dc-xrech.
              MOVE 'X' TO s_segtab_dc-nullpos.
            ENDIF.
          ENDIF.
        ELSE.
          s_segtab_dc-abrechenbar = space.
          s_segtab_dc-arbgb = 'XX'.
          s_segtab_dc-txtnr = '001'.
          s_segtab_dc-text = text-e01.  "Error in PO history - EKBZ
        ENDIF.
        IF s_yek08bn-bukrs NE space.
          MOVE s_yek08bn-bukrs TO s_segtab_dc-bukrs.
        ELSE.
          MOVE h_ekko-bukrs TO s_segtab_dc-bukrs.
        ENDIF.
      ENDIF.
    ENDIF.
    APPEND s_segtab_dc TO pto_segtab_dc.
  ENDLOOP.

ENDFORM.                    " podata_read
*&---------------------------------------------------------------------*
*&      Form  po_header_read                                           *
*&---------------------------------------------------------------------*
*        read PO header data                                           *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->PI_EBELN  PO number                                          *
*      <--PE_EKKO  PO header data                                      *
*      <--PE_EKKO_RC  returncode                                       *
*----------------------------------------------------------------------*
FORM po_header_read  USING   pi_ebeln LIKE ekko-ebeln
                     CHANGING pe_ekko STRUCTURE ekko
                              pe_ekko_rc TYPE i.

  CLEAR: pe_ekko.

  CALL FUNCTION 'ME_EKKO_SINGLE_READ'
    EXPORTING
      pi_ebeln         = pi_ebeln
    IMPORTING
      po_ekko          = pe_ekko
    EXCEPTIONS
      no_records_found = 1
      OTHERS           = 2.
  IF NOT sy-subrc IS INITIAL.
    pe_ekko_rc = 1.
  ENDIF.

ENDFORM.                    " po_header_read
*&---------------------------------------------------------------------*
*&      Form  segtab_dc_modify                                         *
*&---------------------------------------------------------------------*
*    within BAdI MRM_ERS_IDAT_MODIFY the following item data can       *
*    be changed:                                                       *
*    - tax code                                                        *
*    - jurisdiction code                                               *
*    - currency                                                        *
*   Thereafter check for expiration currency                           *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->T_SEGTAB_DC  internal table of type MMERS_SEGTAB             *
*----------------------------------------------------------------------*
FORM segtab_dc_modify  TABLES t_segtab_dc TYPE mmers_tsegtab.

  PERFORM item_data_modify TABLES t_segtab_dc.
  PERFORM currency_check TABLES t_segtab_dc.

ENDFORM.                    " segtab_dc_modify
*&---------------------------------------------------------------------*
*&      Form  item_data_modify                                         *
*&---------------------------------------------------------------------*
* calls auxiliary function module MRMBADI_ERS_IDAT_MODIFY              *
*  within the BAdI the following item data (delivery cost) can be      *
*  changed:                                                            *
*    - tax code                                                        *
*    - jurisdiction code                                               *
*    - currency                                                        *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->T_SEGTAB_DC  internal table of type MMERS_SEGTAB             *
*----------------------------------------------------------------------*
FORM item_data_modify  TABLES t_segtab_dc TYPE mmers_tsegtab.

  CALL FUNCTION 'MRMBADI_ERS_IDAT_MODIFY'
    EXPORTING
      ti_segtab  = t_segtab_dc[]
    IMPORTING
      te_segtab  = t_segtab_dc[]
    EXCEPTIONS
      badi_error = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " item_data_modify
*&---------------------------------------------------------------------*
*  &      Form  currency_check                                         *
*&---------------------------------------------------------------------*
*  after calling BAdI MRM_ERS_IDAT_MODIFY, check for                   *
*  expiration currency                                                 *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->PX_SEGTAB_DC  internal table of type MMERS_SEGTAB            *
*----------------------------------------------------------------------*
FORM currency_check  TABLES  px_segtab_dc TYPE mmers_tsegtab.

  DATA: f_object TYPE object_curro,
         f_waers TYPE waers.
  DATA: s_segtab_dc TYPE mmers_segtab.

  STATICS: BEGIN OF h_last_mesg.
          INCLUDE STRUCTURE mesg.
  STATICS: END OF h_last_mesg.

*--- PO currency expired --> use new currency -----------------------*
  f_object = c_objtyp_bus2081.
  LOOP AT px_segtab_dc INTO s_segtab_dc WHERE abrechenbar = 'X'.
    CALL FUNCTION 'CURRENCY_EXPIRATION_CHECK'
      EXPORTING
        currency      = s_segtab_dc-waers
        date          = sy-datlo
        object        = f_object
      IMPORTING
        currency_new  = f_waers
      EXCEPTIONS
        error_message = 4.
    IF sy-subrc = 0.
    ELSEIF f_waers IS INITIAL.
      CLEAR h_last_mesg.
      MOVE syst-msgty TO h_last_mesg-msgty.
      MOVE syst-msgid TO h_last_mesg-arbgb.
      MOVE syst-msgno TO h_last_mesg-txtnr.
      MOVE syst-msgv1 TO h_last_mesg-msgv1.
      MOVE syst-msgv2 TO h_last_mesg-msgv2.
      MOVE syst-msgv3 TO h_last_mesg-msgv3.
      MOVE syst-msgv4 TO h_last_mesg-msgv4.
      PERFORM aufbereitung_fehlermeldung CHANGING h_last_mesg.
      MOVE-CORRESPONDING h_last_mesg TO s_segtab_dc.
      MOVE space TO s_segtab_dc-abrechenbar.
      MODIFY px_segtab_dc FROM s_segtab_dc.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " currency_check
*&---------------------------------------------------------------------*
*&      Form  segtab_complete                                          *
*&---------------------------------------------------------------------*
*   append delivery cost items from internal table T_SEGTAB_DC to      *
*   internal table T_SEGTAB                                            *
*   until now T_SEGTAB contains only goods items                       *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->T_SEGTAB_DC  internal table of type MMERS_SEGTAB             *
*      -->T_SEGTAB   internal table of type MMERS_SEGTAB               *
*      -->ERSBA document selection                                     *
*----------------------------------------------------------------------*
FORM segtab_complete  TABLES   t_segtab_dc TYPE mmers_tsegtab
                               t_segtab TYPE mmers_tsegtab
                      USING  ersba LIKE rm08e-ersba.

  DATA: t_segtab_mat TYPE mmers_tsegtab.
  DATA: s_segtab_dc TYPE mmers_segtab,
       s_segtab TYPE mmers_segtab.

  t_segtab_mat[] = t_segtab[].

  SORT t_segtab_mat BY lifnr LFBNR ebeln ebelp waers xrech retpo."ADDED LFBNR BY JYOTI ON 18.04.2024
  SORT t_segtab_dc BY lifnr LFBNR ebeln ebelp waers xrech."ADDED LFBNR BY JYOTI ON 18.04.2024
  LOOP AT t_segtab_dc INTO s_segtab_dc.
    CASE ersba.
      WHEN ersba_1 OR ersba_2.
        READ TABLE t_segtab_mat INTO s_segtab
          WITH KEY lifnr = s_segtab_dc-lifnr
                   lFBNR = s_segtab_dc-lFBNR "ADDED LFBNR BY JYOTI ON 18.04.2024
                   ebeln = s_segtab_dc-ebeln
                   waers = s_segtab_dc-waers
                   xrech = s_segtab_dc-xrech
                   retpo = ' '
        BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          MOVE s_segtab-zterm TO s_segtab_dc-zterm.
          MOVE s_segtab-kufix TO s_segtab_dc-kufix.
          MOVE s_segtab-wkurs TO s_segtab_dc-wkurs.
          APPEND s_segtab_dc TO t_segtab.
        ELSE.
          APPEND s_segtab_dc TO t_segtab.
        ENDIF.
      WHEN ersba_3.
        READ TABLE t_segtab_mat INTO s_segtab
         WITH KEY lifnr = s_segtab_dc-lifnr
                  lFBNR = s_segtab_dc-lFBNR "ADDED LFBNR BY JYOTI ON 18.04.2024
                  ebeln = s_segtab_dc-ebeln
                  ebelp = s_segtab_dc-ebelp
                  waers = s_segtab_dc-waers
                  xrech = s_segtab_dc-xrech
                  retpo = ' '
        BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          MOVE s_segtab-zterm TO s_segtab_dc-zterm.
          MOVE s_segtab-kufix TO s_segtab_dc-kufix.
          MOVE s_segtab-wkurs TO s_segtab_dc-wkurs.
          APPEND s_segtab_dc TO t_segtab.
        ELSE.
          APPEND s_segtab_dc TO t_segtab.
        ENDIF.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    " segtab_complete
*&---------------------------------------------------------------------*
*&      Form  ekrsdc_update                                            *
*&---------------------------------------------------------------------*
*  call function module ME_UPDATA_EKRSDC in UPDATE TASK to delete the  *
*  processed EKRSDC entries                                            *
*----------------------------------------------------------------------*
*    Parameter:                                                        *
*      -->PTI_EKRSDC_DEL internal table of structure EKRSDC            *
*----------------------------------------------------------------------*
FORM ekrsdc_update  TABLES   pti_ekrsdc_del STRUCTURE ekrsdc.

  CALL FUNCTION 'ME_UPDATE_EKRSDC' IN UPDATE TASK
    EXPORTING
      i_delete = 'X'
    TABLES
      t_ekrsdc = pti_ekrsdc_del.


ENDFORM.                    " ekrsdc_update
*&---------------------------------------------------------------------*
*&      Form  ekrsdc_del_fill                                          *
*&---------------------------------------------------------------------*
*  fill internal table t_ekrsdc_del with EKRSDC entries to be deleted  *
*----------------------------------------------------------------------*
*   Parameter:                                                         *
*      -->PTI_EKRSDC  internal table of structure EKRSDC               *
*      -->PTX_EKRSDC_DEL internal table of structure EKRSDC            *
*      -->PI_SEGTAB  structure of type MMERS_SEGTAB                    *
*----------------------------------------------------------------------*
FORM ekrsdc_del_fill  TABLES  pti_ekrsdc STRUCTURE ekrsdc
                              ptx_ekrsdc_del STRUCTURE ekrsdc
                      USING   pi_segtab TYPE mmers_segtab.

  DATA: s_ekrsdc TYPE ekrsdc,
        s_ekrsdc_del TYPE ekrsdc.

  LOOP AT pti_ekrsdc INTO s_ekrsdc
    WHERE ebeln = pi_segtab-ebeln
    AND   ebelp = pi_segtab-ebelp
    AND   lifnr = pi_segtab-lifnr                             "N1908804
    AND   stunr = pi_segtab-stunr                             "N1908804
    AND   zaehk = pi_segtab-zaehk.                            "N1908804

    MOVE-CORRESPONDING s_ekrsdc TO s_ekrsdc_del.
    APPEND s_ekrsdc_del TO ptx_ekrsdc_del.
  ENDLOOP.

ENDFORM.                    " ekrsdc_del_fill
