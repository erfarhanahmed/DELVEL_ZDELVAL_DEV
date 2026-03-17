*&---------------------------------------------------------------------*
*&  Include           ZPAYMENT_ADVICE_F01
*&---------------------------------------------------------------------*

FORM get_vendor_data.
  SELECT lf~lifnr
         lf~name1
         lf~adrnr
         ad~street
        ad~city1
        ad~post_code1
    FROM lfa1 AS lf
    JOIN adrc AS ad ON lf~adrnr = ad~addrnumber
    INTO CORRESPONDING FIELDS OF wa_lfa1 UP TO 1 ROWS
    WHERE lf~lifnr = p_lifnr .

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_lfa1-adrnr
      IMPORTING
        output = wa_lfa1-adrnr.

    SELECT SINGLE * FROM adrc INTO @DATA(ls_adrc)  WHERE addrnumber  = @wa_lfa1-adrnr.

    CONCATENATE ls_adrc-street ls_adrc-str_suppl3 ls_adrc-location INTO lv_street SEPARATED BY space.

    lv_timezone = ls_adrc-time_zone.

  ENDSELECT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BANK_DETAILS
*&---------------------------------------------------------------------*

FORM get_bank_details .
  SELECT SINGLE bukrs
         butxt
    FROM t001
    INTO wa_t001
    WHERE bukrs = p_bukrs.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COMBINE_HEADER_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM combine_header_details .

  wa_header_details-lifnr  = wa_lfa1-lifnr.
  wa_header_details-name1 = wa_lfa1-name1.
*  WA_HEADER_DETAILS-STREET = WA_LFA1-STREET.
  wa_header_details-street = lv_street.
  wa_header_details-city1 = wa_lfa1-city1.
  wa_header_details-post_code1 = wa_lfa1-post_code1.
  wa_header_details-butxt = wa_t001-butxt.
*  wa_header_details-augbl = s_augbl.
  wa_header_details-time_zone = lv_timezone.

  READ TABLE it_bkpf INTO DATA(wa_bkpf) INDEX 1.
  wa_header_details-augdt = wa_bkpf-augdt.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ACC_HEADER_DATA
*&---------------------------------------------------------------------*

FORM get_acc_header_data .
*  BREAK primus.
  SELECT * FROM bkpf INTO TABLE @DATA(gt_bkpf)
    WHERE belnr IN @s_augbl
    AND gjahr EQ @p_gjahr
    AND bukrs = @p_bukrs.


  SELECT bk~belnr,bk~bukrs, bk~gjahr, bk~augbl, bk~augdt,bk~blart, bk~lifnr ,bk~budat, bk~bldat, bg~xblnr
    FROM  bsak AS bk
*    JOIN bkpf AS bg ON bk~belnr = bg~belnr AND bk~bukrs = bg~bukrs AND bk~gjahr = bg~gjahr
    JOIN bkpf AS bg ON bk~augbl = bg~belnr AND bk~bukrs = bg~bukrs AND bk~gjahr = bg~gjahr
    INTO CORRESPONDING FIELDS OF TABLE  @it_bkpf
    FOR ALL ENTRIES IN @gt_bkpf
*     WHERE bk~augbl eq @GT_BKPF-BELNR AND bk~gjahr = @P_gjahr AND bk~bukrs = @p_bukrs    """= @P_GJAHR added by sp in @s_gjahr 04.12.2023
     WHERE bk~augbl EQ @gt_bkpf-belnr  AND bk~augdt EQ @gt_bkpf-budat AND bk~bukrs = @p_bukrs    """= @P_GJAHR added by sp in @s_gjahr 04.12.2023
    AND bk~blart IN ( 'KR' , 'RE' , 'KG' , 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' )  " ADD SP 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' ON 15.01.2024
    AND bk~lifnr = @p_lifnr. "ADDED BY PRIMUS JYOTI ON 08.03.2024

  IF it_bkpf IS NOT INITIAL.
    SELECT belnr xblnr
      FROM bkpf
      INTO  TABLE lt_bkpf01
      FOR ALL ENTRIES IN it_bkpf
       WHERE bukrs = it_bkpf-bukrs AND belnr = it_bkpf-belnr AND gjahr = it_bkpf-gjahr.
  ENDIF.
*  BREAK-POINT.
  SELECT bukrs, belnr ,gjahr, augbl, dmbtr,REBZG                      ""ADDED BY MA ON 25.04.2024
    FROM bsak INTO CORRESPONDING FIELDS OF TABLE @it_bsak
    WHERE bukrs = @p_bukrs
    AND gjahr = @p_gjahr
    AND augbl IN @s_augbl
    AND augbl <> bsak~belnr
    AND blart = 'KZ'.


*     DELETE IT_BKPF INDEX 1.
*    delete ADJACENT DUPLICATES FROM it_bkpf COMPARING AUGBL."ADDED BY PRIMUS JYOTI ON 08.03.2024
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_GROSS_DETAILS
*&---------------------------------------------------------------------*

FORM get_gross_details .
  SELECT bukrs, gjahr, belnr, buzei, dmbtr, bschl, koart, augbl, ktosl
            FROM  bseg
            INTO TABLE @it_gross
            FOR ALL ENTRIES IN @it_bkpf
            WHERE belnr = @it_bkpf-belnr AND bukrs = @it_bkpf-bukrs AND gjahr = @it_bkpf-gjahr
*            WHERE augbl = @IT_BKPF-augbl AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
            AND koart IN ( 'S' , 'A' ) "#EC CI_NO_TRANSFORM """"K ADDED BY SP ON 16.01.2024(S)
            AND bschl IN ( '86' , '40' , '37','96' , '70' ) .    " ADDED BY SP ON 16.01.2024

************added by primus jyoti on 08.03.2024*****************************
  SELECT bukrs, gjahr, belnr, buzei, dmbtr, bschl, koart, augbl, ktosl
             FROM  bseg
             INTO TABLE @it_gross_rej
             FOR ALL ENTRIES IN @it_bkpf
*            WHERE BELNR = @IT_BKPF-BELNR AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
             WHERE augbl = @it_bkpf-augbl AND bukrs = @it_bkpf-bukrs AND gjahr = @it_bkpf-gjahr
             AND koart = 'K'
             AND bschl IN ( '21' ) .

***************************************************************************


  " ADDED BY SP ON .01.02.2024
  SELECT bukrs, gjahr, belnr, buzei, dmbtr, bschl, koart , augbl , ktosl
          FROM  bseg
          INTO TABLE @it_gross3
          FOR ALL ENTRIES IN @it_bkpf
          WHERE belnr = @it_bkpf-belnr AND bukrs = @it_bkpf-bukrs AND gjahr = @it_bkpf-gjahr
*           WHERE augbl = @IT_BKPF-augbl AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
          AND koart = 'S' "#EC CI_NO_TRANSFORM """"K ADDED BY SP ON 16.01.2024(S)
          AND bschl IN ( '96' , '40' ) .    " ADDED BY SP ON 16.01.2024
  " ADDED BY SP ON 01.02.2024



  "ADD SP ON 16.01.2024"
  SELECT bukrs, gjahr, belnr, buzei, dmbtr, bschl, koart, augbl, ktosl
          FROM  bseg
          INTO TABLE @it_gross1
          FOR ALL ENTRIES IN @it_bkpf
          WHERE belnr = @it_bkpf-belnr AND bukrs = @it_bkpf-bukrs AND gjahr = @it_bkpf-gjahr
*           WHERE augbl = @IT_BKPF-augbl AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
          AND koart = 'K' "#EC CI_NO_TRANSFORM """"K ADDED BY SP ON 16.01.2024(S)
          AND bschl = '37'  .    " ADDED BY SP ON 16.01.2024
  "ADD SP ON 16.01.2024"



  it_gross2[] = it_gross[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TDS_DETAILS
*&---------------------------------------------------------------------*
FORM get_tds_details .
                                                   "#EC CI_NO_TRANSFORM
  SELECT bukrs, gjahr, belnr, buzei, dmbtr, bschl, koart , augbl,ktosl
            FROM  bseg
            INTO TABLE @it_tds
            FOR ALL ENTRIES IN @it_bkpf
            WHERE belnr = @it_bkpf-belnr AND bukrs = @it_bkpf-bukrs AND gjahr = @it_bkpf-gjahr
            AND ktosl = 'WIT' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FINAL_DATA
*&---------------------------------------------------------------------*

FORM final_data .
  DATA wa_final TYPE zpayment_advice_str.
  SORT it_bkpf ASCENDING BY belnr  .
*  SORT it_bkpf DESCENDING BY belnr  .
  SORT it_gross ASCENDING BY belnr bschl.
  SORT it_tds ASCENDING BY belnr.
  DATA(it_bkpf_kg) = it_bkpf.
  DELETE it_bkpf_kg WHERE blart NE 'KG'.
  LOOP AT it_bkpf ASSIGNING FIELD-SYMBOL(<fs_bkpf>).
*    wa_final-xblnr = <fs_bkpf>-xblnr.
    wa_final-budat = <fs_bkpf>-budat.
    wa_final-belnr = <fs_bkpf>-belnr.
    wa_final-bldat = <fs_bkpf>-bldat.
    wa_final-blart = <fs_bkpf>-blart."ADDED BY PRIMUS JYOTI ON 08.03.2024
    wa_final-augbl = <fs_bkpf>-augbl.

    READ TABLE lt_bkpf01 INTO ls_bkpf01 WITH KEY belnr = wa_final-belnr.
    wa_final-xblnr = ls_bkpf01-xblnr.

    READ TABLE it_gross1 ASSIGNING FIELD-SYMBOL(<fs_gross1>) WITH  KEY belnr = <fs_bkpf>-belnr bschl = TEXT-t04 BINARY SEARCH  . " get gross amnt
    IF  <fs_gross1> IS ASSIGNED.
      wa_final-gross_dmbtr = <fs_gross1>-dmbtr * -1.
*        WA_FINAL-BSCHL       = <FS_GROSS1>-BSCHL. "ADD SP ON 15.01.2024
      UNASSIGN <fs_gross1>.
    ENDIF.

    LOOP AT it_bsak INTO wa_bsak WHERE REBZG = wa_final-belnr .
      wa_final-partamt = wa_final-partamt + wa_bsak-dmbtr.
      CLEAR wa_bsak-dmbtr.
    ENDLOOP.

    LOOP AT it_gross ASSIGNING FIELD-SYMBOL(<fs_gross>) WHERE belnr = wa_final-belnr.
      wa_final-bschl   = <fs_gross>-bschl.
      IF wa_final-bschl NE '96'.                     "ADDED AS 24/01/2024
        wa_final-gross_dmbtr = wa_final-gross_dmbtr + <fs_gross>-dmbtr.
      ELSEIF it_gross3 IS NOT INITIAL.
        wa_final-gross_dmbtr = ' '.
      ENDIF.
      CLEAR:<fs_gross>.
    ENDLOOP.

    IF wa_final-blart = 'KG'.
      READ TABLE it_gross_rej ASSIGNING FIELD-SYMBOL(<fs_rejection>)
               WITH  KEY augbl = <fs_bkpf>-augbl belnr = wa_final-belnr bschl = TEXT-t03 BINARY SEARCH. " get rejection DN amnt   "ADDED BY PRIMUS JYOTI ON 08.03.2024
      IF  <fs_rejection> IS ASSIGNED.
        wa_final-rejection_dmbtr = <fs_rejection>-dmbtr .
        UNASSIGN <fs_rejection>.
      ENDIF.


*    READ TABLE IT_GROSS2 ASSIGNING FIELD-SYMBOL(<FS_REJECTION2>) WITH  KEY BELNR = <FS_BKPF>-BELNR BSCHL = TEXT-T05 ."BINARY SEARCH. " get rejection DN amnt  "23/01/2024
      READ TABLE it_gross_rej ASSIGNING FIELD-SYMBOL(<fs_rejection2>)
               WITH  KEY augbl = <fs_bkpf>-augbl belnr = wa_final-belnr bschl = TEXT-t05 ."BINARY SEARCH. " get rejection DN amnt  "ADDED BY PRIMUS JYOTI ON 08.03.2024
      IF  <fs_rejection2> IS ASSIGNED.
        wa_final-rejection_dmbtr = <fs_rejection2>-dmbtr * -1. " ADDED BY SP ON 01.02.2024* -1
        UNASSIGN <fs_rejection2>.
      ENDIF.

    ENDIF.

*    READ TABLE IT_TDS ASSIGNING FIELD-SYMBOL(<FS_TDS>) WITH KEY BELNR = <FS_BKPF>-BELNR BINARY SEARCH. " get TDS amnt
    LOOP AT it_tds ASSIGNING FIELD-SYMBOL(<fs_tds>) WHERE belnr = <fs_bkpf>-belnr  AND ktosl = 'WIT'.
*    IF  <FS_TDS> IS ASSIGNED.
      wa_final-tds_dmbtr =  wa_final-tds_dmbtr + <fs_tds>-dmbtr.
*      UNASSIGN <FS_TDS>.
      CLEAR <fs_tds>.
*    ENDIF.
    ENDLOOP.
    "C

    wa_final-net_dmbtr = wa_final-gross_dmbtr - wa_final-tds_dmbtr - wa_final-rejection_dmbtr - wa_final-partamt.   "WA_FINAL-REJECTION_DMBTR ADDED BY SP ON 01.02.2024

    "ADDED BY SP ON 16.01.2024""""

*    IF WA_FINAL-BLART = 'KR' OR WA_FINAL-BLART = 'RX' OR  WA_FINAL-BLART = 'RE' OR WA_FINAL-BLART = 'RL'
*      OR  WA_FINAL-BLART = 'AB' OR  WA_FINAL-BLART = 'SA' OR  WA_FINAL-BLART = 'ZA' .
    APPEND wa_final TO it_final.

    CLEAR: wa_final, wa_excel,ls_bkpf01.
  ENDLOOP.
  lt_final  = it_final.
  SORT lt_final BY augbl.
  SORT it_final ASCENDING BY augbl.
  FREE:  it_gross, it_tds.     ""it_bkpf,
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS.
*  DELETE ADJACENT DUPLICATES FROM it_final COMPARING BELNR BUDAT.
  DELETE ADJACENT DUPLICATES FROM lt_final COMPARING augbl.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_SMARTFORM
*&---------------------------------------------------------------------*

FORM display_smartform .

*  PERFORM get_sf_fm.

  DATA control_parameters   TYPE ssfctrlop.
  DATA output_options       TYPE ssfcompop.
  DATA job_output_info      TYPE ssfcrescl.

  DATA : ls_bil_invoice TYPE lbbil_invoice.
  DATA : gv_tot_lines      TYPE i,
         gs_con_settings   TYPE ssfctrlop,
         ls_composer_param TYPE ssfcompop,
         fm_name type FUNCNAME.

lwa_OUTPUTPARAMS-DEVICE = 'PRINTER'.
lwa_OUTPUTPARAMS-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
lwa_OUTPUTPARAMS-NODIALOG = 'X'.
lwa_OUTPUTPARAMS-PREVIEW = ''.
lwa_OUTPUTPARAMS-REQIMM = 'X'.
ELSE.
lwa_OUTPUTPARAMS-NODIALOG = ''.
lwa_OUTPUTPARAMS-PREVIEW = 'X'.
ENDIF.


CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS       = lwa_OUTPUTPARAMS
   EXCEPTIONS
     CANCEL                = 1
     USAGE_ERROR           = 2
     SYSTEM_ERROR          = 3
     INTERNAL_ERROR        = 4
     OTHERS                = 5
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    I_NAME                     = 'ZF_PAYMENT_ADVICE_SFP'
 IMPORTING
   E_FUNCNAME                 = fm_name
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =
          .

  DESCRIBE TABLE lt_final LINES gv_tot_lines.

  LOOP AT lt_final INTO ls_final.

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

*    CALL FUNCTION fm_name      ""'/1BCDWB/SF00000172'
*      EXPORTING
**       ARCHIVE_INDEX      = ARCHIVE_INDEX
**       ARCHIVE_INDEX_TAB  = ARCHIVE_INDEX_TAB
**       ARCHIVE_PARAMETERS = ARCHIVE_PARAMETERS
*        control_parameters = gs_con_settings
**       MAIL_APPL_OBJ      = MAIL_APPL_OBJ
**       MAIL_RECIPIENT     = MAIL_RECIPIENT
**       MAIL_SENDER        = MAIL_SENDER
*        output_options     = ls_composer_param
**       USER_SETTINGS      = 'X'
*        wa_header_details  = wa_header_details
*        augbl              = ls_final-augbl
**     IMPORTING
**       DOCUMENT_OUTPUT_INFO       = DOCUMENT_OUTPUT_INFO
**       JOB_OUTPUT_INFO    = JOB_OUTPUT_INFO
**       JOB_OUTPUT_OPTIONS = JOB_OUTPUT_OPTIONS
*      TABLES
*        it_final           = it_final
**     EXCEPTIONS
**       FORMATTING_ERROR   = 1
**       INTERNAL_ERROR     = 2
**       SEND_ERROR         = 3
**       USER_CANCELED      = 4
**       OTHERS             = 5
*      .
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

CALL FUNCTION  fm_name  "'/1BCDWB/SM00000048'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    AUGBL                    = LS_FINAL-augbl
    IT_FINAL                 = it_final
    WA_HEADER_DETAILS        = wa_header_details
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
 EXCEPTIONS
   USAGE_ERROR              = 1
   SYSTEM_ERROR             = 2
   INTERNAL_ERROR           = 3
   OTHERS                   = 4
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

  ENDLOOP.

   CALL FUNCTION 'FP_JOB_CLOSE'
   IMPORTING
     E_RESULT             = lwa_result
   EXCEPTIONS
     USAGE_ERROR          = 1
     SYSTEM_ERROR         = 2
     INTERNAL_ERROR       = 3
     OTHERS               = 4
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_SF_FM
*&---------------------------------------------------------------------*

*FORM get_sf_fm .
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = 'ZPAYMENT_ADVICE'
*    IMPORTING
*      fm_name            = fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
*    MESSAGE TEXT-e01 TYPE TEXT-t01.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_HEADER
*&---------------------------------------------------------------------*


*FORM print_pdf .
*
*  PERFORM get_sf_fm .
*
*  ls_ctrlop-getotf = 'X'.
*  ls_ctrlop-no_dialog = 'X'.
*  ls_ctrlop-preview = 'X' . "space.
**
**      "Output Options
*  ls_outopt-tdnoprev = 'X'.
*  ls_outopt-tddest = 'LP01'.
*  ls_outopt-tdnoprint = 'X'.
*
*  LOOP AT lt_final INTO ls_final.
*
*    CALL FUNCTION fm_name
*      EXPORTING
*        control_parameters = ls_ctrlop
*        output_options     = ls_outopt
*        user_settings      = 'X'
*        wa_header_details  = wa_header_details
*        augbl              = ls_final-augbl
*      IMPORTING
*        job_output_info    = gv_job_output
*      TABLES
*        it_final           = it_final
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
*      MESSAGE TEXT-e01 TYPE TEXT-t01.
*    ENDIF.
**
*    CALL FUNCTION 'HR_IT_DISPLAY_WITH_PDF'
**     EXPORTING
**       IV_PDF          =
*      TABLES
*        otf_table = gv_job_output-otfdata.
*  ENDLOOP.
*ENDFORM.
