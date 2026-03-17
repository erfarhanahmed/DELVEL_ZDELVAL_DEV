*&---------------------------------------------------------------------*
*& Report ZVEND_DEBIT_NOTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsu_vend_debit_note.

DATA:
  tmp_belnr TYPE bkpf-belnr,
  tmp_budat TYPE bkpf-budat.



TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs   TYPE bkpf-bukrs,
    belnr   TYPE bkpf-belnr,
    gjahr   TYPE bkpf-gjahr,
    bldat   TYPE bkpf-bldat,
    budat   TYPE bkpf-budat,
    xblnr   TYPE bkpf-xblnr,
    bktxt   TYPE bkpf-bktxt,
    awkey   TYPE bkpf-awkey,
    belnr_r TYPE rseg-belnr,
  END OF t_accounting_doc_hdr,
  tt_accounting_doc_hdr TYPE STANDARD TABLE OF t_accounting_doc_hdr.

TYPES:
  BEGIN OF t_accounting_doc_item,
    bukrs TYPE bseg-bukrs,
    belnr TYPE bseg-belnr,
    gjahr TYPE bseg-gjahr,
    buzei TYPE bseg-buzei,
    dmbtr TYPE bseg-dmbtr,
    wrbtr TYPE bseg-wrbtr,
    sgtxt TYPE bseg-sgtxt,
    hkont TYPE bseg-hkont,
    lifnr TYPE bseg-lifnr,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

TYPES:
  BEGIN OF t_rbkp,
    belnr TYPE rbkp-belnr,
    gjahr TYPE rbkp-gjahr,
    lifnr TYPE rbkp-lifnr,
  END OF t_rbkp,
  tt_rbkp TYPE STANDARD TABLE OF t_rbkp.

TYPES:
  BEGIN OF t_rseg,
    belnr   TYPE rseg-belnr,
    gjahr   TYPE rseg-gjahr,
    buzei   TYPE rseg-buzei,
    ebeln   TYPE rseg-ebeln,
    ebelp   TYPE rseg-ebelp,
    matnr   TYPE rseg-matnr,
    werks   TYPE rseg-werks,
    wrbtr   TYPE rseg-wrbtr,
    mwskz   TYPE rseg-mwskz,
    menge   TYPE rseg-menge,
    meins   TYPE rseg-meins,
    kschl   TYPE rseg-kschl,
    lfbnr   TYPE rseg-lfbnr,
    lfgja   TYPE rseg-lfgja,
    lfpos   TYPE rseg-lfpos,
    lifnr   TYPE rseg-lifnr,
    hsn_sac TYPE rseg-hsn_sac,
  END OF t_rseg,
  tt_rseg TYPE STANDARD TABLE OF t_rseg.

TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.

TYPES:
  BEGIN OF t_mat_doc_hdr,
    mblnr TYPE mkpf-mblnr,
    mjahr TYPE mkpf-mjahr,
    xblnr TYPE mkpf-xblnr,
    bktxt TYPE mkpf-bktxt,
    frbnr TYPE mkpf-frbnr,
  END OF t_mat_doc_hdr,
  tt_mat_doc_hdr TYPE STANDARD TABLE OF t_mat_doc_hdr.

TYPES:
  BEGIN OF t_mat_doc,
    mblnr TYPE mseg-mblnr,
    mjahr TYPE mseg-mjahr,
    zeile TYPE mseg-zeile,
    matnr TYPE mseg-matnr,
    werks TYPE mseg-werks,
    sgtxt TYPE mseg-sgtxt,
    grund TYPE mseg-grund,
    wempf TYPE mseg-wempf,
  END OF t_mat_doc,
  tt_mat_doc TYPE STANDARD TABLE OF t_mat_doc.

DATA:
  gt_hdr  TYPE zt_material_doc_hdr,
  gt_item TYPE zt_material_doc,
  gt_rate TYPE zt_rate.

DATA:lwa_outputparams TYPE sfpoutputparams,
     lwa_result       TYPE sfpjoboutput.

DATA: lwa_outputparams1 TYPE sfpoutputparams,
      lwa_result1       TYPE sfpjoboutput.


SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
  PARAMETERS : p_bukrs   TYPE bkpf-bukrs DEFAULT 'SU00' MODIF ID bu.
  PARAMETERS : p_waers   TYPE bkpf-waers OBLIGATORY.
  SELECT-OPTIONS: so_belnr FOR tmp_belnr,
                  so_budat FOR tmp_budat.
  PARAMETERS: p_gjahr TYPE bkpf-gjahr DEFAULT '2023' OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE abc.
  PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
              r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN:END OF BLOCK b2.

INITIALIZATION.
  xyz = 'Select Options'(tt1).
  abc = 'Layout Options'(tt2).

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
*      IF SCREEN-GROUP1 = 'HW'.
*      SCREEN-INPUT = '0'.
*      MODIFY SCREEN.
*    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  IF r1 = 'X'.
    PERFORM get_data.

  ELSEIF r2 = 'X'.
    PERFORM fetch_data CHANGING gt_hdr
                                gt_item
                                gt_rate.

    PERFORM form_display USING gt_hdr
                               gt_item
                               gt_rate.

  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_HDR  text
*      <--P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM fetch_data  CHANGING ct_hdr  TYPE zt_material_doc_hdr
                          ct_item TYPE zt_material_doc
                          ct_rate TYPE zt_rate.
DATA(lo_text_reader) = NEW zcl_read_text( ).

  DATA: ls_rate               TYPE zgrate,
        lt_accounting_doc_hdr TYPE tt_accounting_doc_hdr,
        ls_accounting_doc_hdr TYPE t_accounting_doc_hdr,
        lt_rseg               TYPE tt_rseg,
        ls_rseg               TYPE t_rseg,
        lt_mat_doc_hdr        TYPE tt_mat_doc_hdr,
        ls_mat_doc_hdr        TYPE t_mat_doc_hdr,
        lt_mat_doc            TYPE tt_mat_doc,
        ls_mat_doc            TYPE t_mat_doc,
        ls_material_doc_hdr   TYPE zmaterial_doc_hdr,
        ls_material_doc       TYPE zmaterial_doc,
        lt_mat_desc           TYPE tt_mat_desc,
        ls_mat_desc           TYPE t_mat_desc,
        lt_rbkp               TYPE tt_rbkp,
        ls_rbkp               TYPE t_rbkp.

  DATA:
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline.

  SELECT bukrs
         belnr
         gjahr
         bldat
         budat
         xblnr
         bktxt
         awkey
    FROM bkpf
    INTO TABLE lt_accounting_doc_hdr
    WHERE bukrs = 'SU00'
    AND   belnr IN so_belnr
    AND   gjahr = p_gjahr
    AND   budat IN so_budat
    AND   blart = 'KG'  .                         ""'RE' .""IN ('KG','KR').              ADDED BY MA ON 11.03.2024.

  IF NOT sy-subrc IS INITIAL.
    MESSAGE 'Please Check The Input' TYPE 'E'.
  ENDIF.

  IF NOT lt_accounting_doc_hdr IS INITIAL.
    LOOP AT lt_accounting_doc_hdr INTO ls_accounting_doc_hdr.
      ls_accounting_doc_hdr-belnr_r = ls_accounting_doc_hdr-awkey.
      MODIFY lt_accounting_doc_hdr FROM ls_accounting_doc_hdr.
    ENDLOOP.

    SELECT belnr                                   "#EC CI_NO_TRANSFORM
           gjahr
           buzei
           ebeln
           ebelp
           matnr
           werks
           wrbtr
           mwskz
           menge
           meins
           kschl
           lfbnr
           lfgja
           lfpos
           lifnr
           hsn_sac
      FROM rseg
      INTO TABLE lt_rseg
      FOR ALL ENTRIES IN lt_accounting_doc_hdr
      WHERE belnr = lt_accounting_doc_hdr-belnr_r
      AND   gjahr = lt_accounting_doc_hdr-gjahr.

    SELECT belnr
           gjahr
           lifnr
      FROM rbkp
      INTO TABLE lt_rbkp
      FOR ALL ENTRIES IN lt_accounting_doc_hdr
      WHERE belnr = lt_accounting_doc_hdr-belnr_r
      AND   gjahr = lt_accounting_doc_hdr-gjahr.

    SELECT matnr                                   "#EC CI_NO_TRANSFORM
           maktx
    FROM makt
    INTO TABLE lt_mat_desc
    FOR ALL ENTRIES IN lt_rseg
    WHERE matnr = lt_rseg-matnr
    AND   spras = sy-langu.

    SELECT mblnr                                   "#EC CI_NO_TRANSFORM
           mjahr
           xblnr
           bktxt
           frbnr
      FROM mkpf
      INTO TABLE lt_mat_doc_hdr
      FOR ALL ENTRIES IN lt_rseg
      WHERE mblnr = lt_rseg-lfbnr
    AND   mjahr = lt_rseg-lfgja.

    SELECT mblnr                                   "#EC CI_NO_TRANSFORM
           mjahr
           zeile
           matnr
           werks
           sgtxt
           grund
           wempf
      FROM mseg
      INTO TABLE lt_mat_doc
      FOR ALL ENTRIES IN lt_rseg
      WHERE mblnr = lt_rseg-lfbnr
    AND   mjahr = lt_rseg-lfgja.


  ENDIF.

  DATA: lv_menge_string TYPE string.

  LOOP AT lt_rseg INTO ls_rseg.
    ls_material_doc-belnr       = ls_rseg-belnr.
    ls_material_doc-gjahr       = ls_rseg-gjahr.
    ls_material_doc-buzei       = ls_rseg-buzei.
  shift ls_material_doc-buzei  LEFT DELETING LEADING '0'.
    ls_material_doc-mblnr       = ls_rseg-lfbnr.
    ls_material_doc-mjahr       = ls_rseg-lfgja.
*    ls_material_doc-zeile = ls_rseg-zeile.
    ls_material_doc-ebeln       = ls_rseg-ebeln.
    ls_material_doc-ebelp       = ls_rseg-ebelp.
    ls_material_doc-matnr       = ls_rseg-matnr.
    ls_material_doc-menge       = ls_rseg-menge.
    ls_material_doc-meins       = ls_rseg-meins.
    ls_material_doc-steuc       = ls_rseg-hsn_sac.
    ls_material_doc-werks       = ls_rseg-werks.
    ls_material_doc-wrbtr       = ls_rseg-wrbtr.
    ls_material_doc-kschl       = ls_rseg-kschl.
    ls_material_doc_hdr-belnr_r = ls_rseg-belnr.
    ls_material_doc_hdr-mwskz   = ls_rseg-mwskz.
    ls_rate-rate = ls_rseg-wrbtr / ls_rseg-menge.
    ls_rate-ebeln = ls_rseg-ebeln.
    ls_rate-ebelp = ls_rseg-ebelp.
    ls_rate-belnr = ls_rseg-belnr.
    ls_rate-buzei = ls_rseg-buzei.

    lv_id = ls_rseg-matnr.
    CLEAR: lt_lines,ls_lines.
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'GRUN'
*        language                = sy-langu
*        name                    = lv_id
*        object                  = 'MATERIAL'
*      TABLES
*        lines                   = lt_lines
*      EXCEPTIONS
*        id                      = 1
*        language                = 2
*        name                    = 3
*        not_found               = 4
*        object                  = 5
*        reference_check         = 6
*        wrong_access_to_archive = 7
*        OTHERS                  = 8.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*    IF NOT lt_lines IS INITIAL.
*      LOOP AT lt_lines INTO ls_lines.
*        IF NOT ls_lines-tdline IS INITIAL.
*          REPLACE ALL OCCURRENCES OF '<&>' IN ls_lines-tdline WITH '&'.
*          CONCATENATE ls_material_doc-longtxt ls_lines-tdline INTO ls_material_doc-longtxt SEPARATED BY space.
*        ENDIF.
*      ENDLOOP.
*      CONDENSE ls_material_doc-longtxt.
*    ENDIF.
lo_text_reader->read_text_string( EXPORTING id = 'GRUN' name = lv_id object = 'MATERIAL' IMPORTING lv_lines = DATA(lv_lines1) ).
ls_material_doc-longtxt = lv_lines1.
CONDENSE ls_material_doc-longtxt.

    READ TABLE lt_rbkp INTO ls_rbkp WITH KEY belnr = ls_rseg-belnr
                                             gjahr = ls_rseg-gjahr.
    IF sy-subrc IS INITIAL.
      ls_material_doc_hdr-lifnr   = ls_rbkp-lifnr.
    ENDIF.
    READ TABLE lt_mat_desc INTO ls_mat_desc WITH KEY matnr = ls_rseg-matnr.
    IF sy-subrc IS INITIAL.
      ls_material_doc-maktx = ls_mat_desc-maktx.
    ENDIF.

    READ TABLE lt_accounting_doc_hdr INTO ls_accounting_doc_hdr WITH KEY belnr_r = ls_rseg-belnr.
    IF sy-subrc IS INITIAL.
      ls_material_doc_hdr-belnr = ls_accounting_doc_hdr-belnr.
      ls_material_doc_hdr-gjahr = ls_accounting_doc_hdr-gjahr.
      ls_material_doc_hdr-bukrs = ls_accounting_doc_hdr-bukrs.
      ls_material_doc-bukrs     = ls_accounting_doc_hdr-bukrs.
      ls_material_doc_hdr-bldat = ls_accounting_doc_hdr-bldat.
      ls_material_doc_hdr-budat = ls_accounting_doc_hdr-budat.

    ENDIF.

    READ TABLE lt_mat_doc INTO ls_mat_doc WITH KEY mblnr = ls_rseg-lfbnr
                                                   mjahr = ls_rseg-lfgja.
*                                                   zeile = ls_rseg-lfpos.
    IF sy-subrc IS INITIAL.
      ls_material_doc_hdr-mblnr = ls_mat_doc-mblnr.
      ls_material_doc_hdr-mjahr = ls_mat_doc-mjahr.
      ls_material_doc_hdr-grund = ls_mat_doc-grund.
      ls_material_doc_hdr-sgtxt = ls_mat_doc-sgtxt.
      ls_material_doc_hdr-wempf = ls_mat_doc-wempf.
    ENDIF.

    READ TABLE lt_mat_doc_hdr INTO ls_mat_doc_hdr WITH KEY mblnr = ls_rseg-lfbnr
                                                           mjahr = ls_rseg-lfgja.
    IF sy-subrc IS INITIAL.
      ls_material_doc_hdr-xblnr = ls_mat_doc_hdr-xblnr.
      ls_material_doc_hdr-bktxt = ls_mat_doc_hdr-bktxt.
      ls_material_doc_hdr-frbnr = ls_mat_doc_hdr-frbnr.
    ENDIF.
    APPEND ls_material_doc_hdr TO ct_hdr.
    APPEND ls_material_doc TO ct_item.
    APPEND ls_rate TO ct_rate.

    CLEAR: ls_material_doc,ls_material_doc_hdr,ls_accounting_doc_hdr,ls_rseg,ls_mat_doc_hdr,
           ls_mat_doc,ls_material_doc,ls_mat_desc, ls_rate.
  ENDLOOP.

*  SORT ct_hdr BY belnr.
*  SORT ct_item BY belnr.
*  SORT ct_rate BY belnr.

* sort ct_item by buzei.
* sort ct_rate by buzei.
  DELETE ADJACENT DUPLICATES FROM ct_hdr COMPARING belnr .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_HDR  text
*      -->P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM form_display  USING    ct_hdr  TYPE zt_material_doc_hdr
                            ct_item TYPE zt_material_doc
                            ct_rate TYPE zt_rate.



* DATA control_parameters   TYPE ssfctrlop.
*  DATA output_options       TYPE ssfcompop.
  DATA job_output_info      TYPE ssfcrescl.
  DATA: lv_name           TYPE funcname,
*    LV_FNAME          TYPE TDSFNAME VALUE 'ZSU_SF_PO_DEBIT_NOTE',

*    LV_FORM           TYPE RS38L_FNAM,
        ls_composer_param TYPE ssfcompop,
        gs_con_settings   TYPE ssfctrlop.          "CONTROL SETTINGS FOR SMART FORMS

  DATA: lt_rate             TYPE zt_rate,
        ls_material_doc_hdr TYPE zmaterial_doc_hdr,
        ls_material_doc     TYPE zmaterial_doc,
        ls_rate             TYPE zgrate,
        lt_hdr              TYPE zt_material_doc_hdr,
        lt_item             TYPE zt_material_doc,
        gv_tot_lines        TYPE i,
        lv_index            TYPE sy-tabix.


  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lwa_outputparams1
* EXCEPTIONS
*     CANCEL          = 1
*     USAGE_ERROR     = 2
*     SYSTEM_ERROR    = 3
*     INTERNAL_ERROR  = 4
*     OTHERS          = 5
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZSU_SF_PO_DEBIT_NOTE_F'
    IMPORTING
      e_funcname = lv_name
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
    .






*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      FORMNAME           = LV_FNAME
*     VARIANT            = ' '
**     DIRECT_CALL        = ' '
*    IMPORTING
*      FM_NAME            = LV_FORM
*    EXCEPTIONS
*      NO_FORM            = 1
*      NO_FUNCTION_MODULE = 2
*      OTHERS             = 3.
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.

  ls_composer_param-tdcopies = '5'.

  DESCRIBE TABLE ct_hdr LINES gv_tot_lines.

  LOOP AT ct_hdr INTO ls_material_doc_hdr.
    lv_index = sy-tabix.
    CLEAR lt_hdr[].
    APPEND ls_material_doc_hdr TO lt_hdr.

    lt_item = ct_item.
    lt_rate = ct_rate.
   " Begin of change by Prathmesh Haldankar Date: 31-07-2025
    SORT lt_item by EBELP ASCENDING.
   "End of Change By Prathmesh Haldankar Date: 31_07_2025
    DELETE lt_item WHERE belnr NE ls_material_doc_hdr-belnr_r.
    " Delete lt_rate where belnr NE ls_material_doc_hdr-belnr_r.
****  *&--FOR PRINTING CONTINUOS PAGES IN CASE RANGE IS GIVEN
    IF lv_index = 1.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_false.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_false.
* CLOSE SPOOL AT THE LAST LOOP ONLY
      gs_con_settings-no_close  = abap_true.
    ELSE.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_true.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_true.
    ENDIF.

    IF lv_index = gv_tot_lines.
* CLOSE SPOOL
      gs_con_settings-no_close  = abap_false.
    ENDIF.



    CALL FUNCTION  lv_name     "'/1BCDWB/SM00000098'
      EXPORTING
*       /1BCDWB/DOCPARAMS   =
        p_waers             = p_waers
        gt_material_doc_hdr = lt_hdr
        gt_material_doc     = lt_item
        gt_rate             = lt_rate
* IMPORTING
*       /1BCDWB/FORMOUTPUT  =
      EXCEPTIONS
        usage_error         = 1
        system_error        = 2
        internal_erpror     = 3
        OTHERS              = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.



*    CALL FUNCTION lv_name                  "'/1BCDWB/SM00000098'
*      EXPORTING
**       /1BCDWB/DOCPARAMS   =
*        p_waers             = p_waers
*        gt_material_doc_hdr = lt_hdr
*        gt_material_doc     = lt_item
**     IMPORTING
**       /1BCDWB/FORMOUTPUT  =
*      EXCEPTIONS
*        usage_error         = 1
*        system_error        = 2
*        internal_error      = 3
*        OTHERS              = 4.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.






*    CALL FUNCTION LV_FORM               "   '/1BCDWB/SF00000251'
*      EXPORTING
*        CONTROL_PARAMETERS  = GS_CON_SETTINGS
*        OUTPUT_OPTIONS      = LS_COMPOSER_PARAM
*        USER_SETTINGS       = SPACE
*        P_WAERS             = P_WAERS
*      TABLES
*        GT_MATERIAL_DOC_HDR = LT_HDR
*        GT_MATERIAL_DOC     = LT_ITEM
*      EXCEPTIONS
*        FORMATTING_ERROR    = 1
*        INTERNAL_ERROR      = 2
*        SEND_ERROR          = 3
*        USER_CANCELED       = 4
*        OTHERS              = 5.
*    IF SY-SUBRC <> 0.
** Implement suitable error handling here
*    ENDIF.
    CLEAR ls_material_doc_hdr.

  ENDLOOP.

  CALL FUNCTION 'FP_JOB_CLOSE'
    IMPORTING
      e_result       = lwa_result1
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_HDR  text
*      <--P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM get_data .
  DATA:
    lt_accounting_doc_hdr  TYPE tt_accounting_doc_hdr.


  SELECT bukrs
         belnr
         gjahr
         bldat
         budat
         xblnr
         bktxt
         awkey
    FROM bkpf
    INTO TABLE lt_accounting_doc_hdr
    WHERE bukrs = 'SU00'
    AND belnr IN so_belnr
    AND   gjahr = p_gjahr
    AND   budat IN so_budat
    AND   blart IN ('KG','KR','DV').

  IF NOT sy-subrc IS INITIAL.
    MESSAGE 'Please Check Input Data' TYPE 'E'.
  ENDIF.

  PERFORM layout_display USING lt_accounting_doc_hdr.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_HDR  text
*      -->P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM layout_display USING ct_accounting_doc_hdr TYPE tt_accounting_doc_hdr.
  DATA:
     ls_accounting_doc_hdr TYPE t_accounting_doc_hdr.
*    LV_FNAME              TYPE TDSFNAME VALUE 'ZSU_VEN_DEBIT_NOTE',
*    GV_TOT_LINES          TYPE I,
*    LV_FORM               TYPE RS38L_FNAM,
*    LS_COMPOSER_PARAM     TYPE SSFCOMPOP,
*    GS_CON_SETTINGS       TYPE SSFCTRLOP.          "CONTROL SETTINGS FOR SMART FORMS

  DATA control_parameters   TYPE ssfctrlop.
  DATA output_options       TYPE ssfcompop.
  DATA job_output_info      TYPE ssfcrescl.

  DATA : ls_bil_invoice TYPE lbbil_invoice.
  DATA : gv_tot_lines      TYPE i,
         gs_con_settings   TYPE ssfctrlop,
         ls_composer_param TYPE ssfcompop.
  DATA: lv_fname TYPE funcname.


  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lwa_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZSU_VEN_DEBIT_NOTE'
    IMPORTING
      e_funcname = lv_fname
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
    .






*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      FORMNAME           = LV_FNAME
**     VARIANT            = ' '
**     DIRECT_CALL        = ' '
*    IMPORTING
*      FM_NAME            = LV_FORM
*    EXCEPTIONS
*      NO_FORM            = 1
*      NO_FUNCTION_MODULE = 2
*      OTHERS             = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  ls_composer_param-tdcopies = '5'.

  DESCRIBE TABLE ct_accounting_doc_hdr LINES gv_tot_lines.

  LOOP AT ct_accounting_doc_hdr INTO ls_accounting_doc_hdr.

    IF sy-tabix = 1.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_false.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_false.
* CLOSE SPOOL AT THE LAST LOOP ONLY
      gs_con_settings-no_close  = abap_true.
    ELSE.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_true.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_true.
    ENDIF.

    IF sy-tabix = gv_tot_lines.
* CLOSE SPOOL
      gs_con_settings-no_close  = abap_false.
    ENDIF.





    CALL FUNCTION lv_fname                "'/1BCDWB/SM00000087'
      EXPORTING
*       /1BCDWB/DOCPARAMS        =
        belnr          = ls_accounting_doc_hdr-belnr
        gjahr          = ls_accounting_doc_hdr-gjahr
        p_waers        = p_waers
*     IMPORTING
*       /1BCDWB/FORMOUTPUT       =
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


*    CALL FUNCTION LV_FORM "'/1BCDWB/SF00000058'
*      EXPORTING
*        CONTROL_PARAMETERS = GS_CON_SETTINGS
*        OUTPUT_OPTIONS     = LS_COMPOSER_PARAM
*        USER_SETTINGS      = SPACE
*        BELNR              = LS_ACCOUNTING_DOC_HDR-BELNR
*        GJAHR              = LS_ACCOUNTING_DOC_HDR-GJAHR
*        P_WAERS            = P_WAERS
** IMPORTING
**       DOCUMENT_OUTPUT_INFO       =
**       JOB_OUTPUT_INFO    =
**       JOB_OUTPUT_OPTIONS =
*      EXCEPTIONS
*        FORMATTING_ERROR   = 1
*        INTERNAL_ERROR     = 2
*        SEND_ERROR         = 3
*        USER_CANCELED      = 4
*        OTHERS             = 5.
*    IF SY-SUBRC <> 0.
* Implement suitable error handling here
*    ENDIF.

  ENDLOOP.

  CALL FUNCTION 'FP_JOB_CLOSE'
    IMPORTING
      e_result       = lwa_result
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
