*&---------------------------------------------------------------------*
*& Report ZMM_1I57FPN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_1i57fpn.
"Tcode : J1IF11

TABLES: t001w, j_1iwrkcus, j_1iregset, j_1iindcus, j_1iexcdtl, j_1iexchdr,
        lfa1.

" FOR ADDRESS CHANGE IN THE SCRIPT "
TYPES: BEGIN OF ty_adrc,
         addrnumber TYPE ad_addrnum,
         name1      TYPE ad_name1,
         str_suppl1 TYPE ad_strspp1,
         str_suppl2 TYPE ad_strspp2,
         street     TYPE ad_street,
         city1      TYPE ad_city1,
         post_code1 TYPE ad_pstcd1,
         country    TYPE land1,
         region     TYPE regio,
         bezei      TYPE bezei20,
       END OF ty_adrc.

" DATA DECLARATION FOR ADDRESS CHANGE " "
DATA : wa_adrc     TYPE ty_adrc, " work area fot ty_adrc "
       v_name1     TYPE string,
       v_strsuppl1 TYPE string,
       v_strsuppl2 TYPE string,
       v_street    TYPE string,
       v_city1     TYPE string,
       v_country   TYPE string,
       v_region    TYPE string,
       v_bezei     TYPE string.

TYPES : BEGIN OF t_exchdr.
    INCLUDE STRUCTURE j_1iexchdr.
TYPES : chk,
        END OF t_exchdr.

DATA: wa_exchdr TYPE t_exchdr, " like j_1iexchdr,
      BEGIN OF wa_exchdr1.
    INCLUDE STRUCTURE j_1iexchdr.
DATA:   chk,
      END OF wa_exchdr1.
DATA: wa1_exchdr TYPE t_exchdr ."like j_1iexchdr.
DATA : it_j_1iexchdr TYPE TABLE OF t_exchdr." TYPE TABLE OF j_1iexchdr.
DATA : itab_excdtl LIKE TABLE OF j_1iexcdtl WITH HEADER LINE.

TYPES: BEGIN OF ty_excdtl02,
         ebelp  TYPE ekpo-ebelp,
         recmtn TYPE matnr,
         issnum TYPE i.
    INCLUDE TYPE j_1iexcdtl.
TYPES: recmtx TYPE text100,
       issmtx TYPE text100,
       ekmng  TYPE ekpo-menge,
       ekmns  TYPE ekpo-meins,
       msmng  TYPE mseg-menge,
       msmns  TYPE mseg-meins,
       remng  TYPE resb-bdmng,
       remns  TYPE resb-meins,
       rpmng  TYPE ekpo-menge,
*       mns  TYPE ekpo-meins,
       END OF   ty_excdtl02.
DATA gt_excdtl02 TYPE TABLE OF ty_excdtl02.
DATA ls_excdtl02 TYPE ty_excdtl02.
DATA ls_excdtlxx TYPE ty_excdtl02.

DATA lv_srno TYPE i.

DATA : BEGIN OF options.
    INCLUDE STRUCTURE itcpo.
DATA : END OF options.

DATA : BEGIN OF result.
    INCLUDE STRUCTURE itcpp.
DATA : END OF result.

DATA : BEGIN OF thead OCCURS 10.
    INCLUDE STRUCTURE thead.
DATA : END OF thead.

DATA : BEGIN OF tlines OCCURS 10.
    INCLUDE STRUCTURE tline.
DATA : END OF tlines.

DATA : text_id(4) TYPE c.
DATA : doc_num  LIKE j_1iexchdr-exnum,
       m_length TYPE i.
DATA : doc_no     LIKE j_1iexchdr-exnum,
       doc_dt     LIKE j_1iexchdr-exdat,
       series     LIKE j_1iexchdr-srgrp,
       preprn     LIKE j_1iexchdr-preprn,
       m_selected,
       m_date(10) TYPE c,
       tabix      LIKE sy-tabix.
DATA : layout    LIKE tnapr-fonam,
       text_name LIKE thead-tdname.
DATA : wrk_rec TYPE i . " Identify the number of records.
DATA : wrk_pagno TYPE i. " Identify the page number
DATA : wrk_lines     TYPE i, " No of line items
       fld(35),
       val           TYPE string,
       select_flg,
       print_str(14) VALUE 'Print Selected'.
DATA: ls_ekko TYPE ekko,
      ls_ekpo TYPE ekpo,
      ls_mkpf TYPE mkpf,
      ls_mseg TYPE mseg,
      ls_mseg1 TYPE mseg.
DATA ls_resb TYPE resb.

DATA: lv_tdname1 TYPE thead-tdname,
      lt_lines   TYPE TABLE OF tline,
      ls_lines   TYPE tline,
      ls_desc1   TYPE tline-tdline,
      ls_desc2   TYPE tline-tdline.

DATA: ls_t005t TYPE t005t,
      ls_t005u TYPE t005u.

*>>
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : so_chlan FOR j_1iexchdr-exnum MATCHCODE OBJECT j_1iexc,
                 so_exdat FOR j_1iexchdr-exdat OBLIGATORY.
PARAMETERS      : p_docyr TYPE j_1iexchdr-exyear,
                  p_werks TYPE j_1iexchdr-werks OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

*>>
START-OF-SELECTION.
  PERFORM fetch_excise_challans.

*>>
AT LINE-SELECTION.
  GET CURSOR FIELD fld VALUE val.
  CASE fld.
    WHEN 'WA_EXCHDR1-EXNUM'.
      PERFORM preview_challan USING val.
    WHEN 'PRINT_STR'.
      CLEAR select_flg.
      DO.
        READ LINE sy-index FIELD VALUE wa_exchdr1-chk wa_exchdr1-exnum
                                       ." INTO wa.
        IF sy-subrc <> 0.
          EXIT.
        ELSEIF wa_exchdr1-exnum IS NOT INITIAL.
          READ TABLE it_j_1iexchdr INTO wa_exchdr
            WITH KEY exnum = wa_exchdr1-exnum.
          IF sy-subrc = 0.
            IF select_flg IS INITIAL
              AND wa_exchdr1-chk = 'X'.
              select_flg = 'X'.
            ENDIF.
            wa_exchdr-chk = wa_exchdr1-chk.
            MODIFY it_j_1iexchdr FROM wa_exchdr
              TRANSPORTING chk
              WHERE exnum = wa_exchdr1-exnum.
          ENDIF.
        ENDIF.
        CLEAR : wa_exchdr1, wa_exchdr.
      ENDDO.
      IF select_flg IS INITIAL.
        MESSAGE TEXT-013 TYPE 'I'.
        EXIT.
      ELSE.
        PERFORM print_challans.
      ENDIF.
  ENDCASE.

*>>
AT USER-COMMAND.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'PRNT'.
      .
    WHEN OTHERS.
  ENDCASE.

FORM preview_challan USING p_exnum.
  READ TABLE it_j_1iexchdr INTO wa_exchdr WITH KEY exnum = p_exnum.
  IF sy-subrc = 0.
    PERFORM select_print_data USING    'J1IF' p_werks 'X'
                              CHANGING options layout.
    PERFORM open_form USING    options layout
                      CHANGING result.
    PERFORM entry_57f4 USING 'J1IF' wa_exchdr.

    PERFORM close_form.
    CLEAR wa_exchdr.
  ENDIF.
ENDFORM.

FORM fetch_excise_challans.
  DATA condstr TYPE string VALUE 'exyear LIKE ''%'''.

  IF p_docyr IS NOT INITIAL.
    condstr = 'exyear = p_docyr'.
  ENDIF.

  SELECT *
    FROM j_1iexchdr
    INTO TABLE it_j_1iexchdr
    WHERE trntyp = '57FC'
      AND werks = p_werks
      AND exnum IN so_chlan
      AND exdat IN so_exdat
      AND (condstr).
  IF sy-subrc <> 0.
    MESSAGE TEXT-009 TYPE 'I'.
    EXIT.
  ELSE.
    SORT it_j_1iexchdr BY exnum exdat.
    WRITE : print_str HOTSPOT.
    ULINE.
    LOOP AT it_j_1iexchdr INTO wa_exchdr1.
      WRITE : / wa_exchdr1-chk AS CHECKBOX, space, wa_exchdr1-exnum HOTSPOT, space, wa_exchdr1-exdat.
      CLEAR wa_exchdr.
    ENDLOOP.
*     set pf-status 'Z_J_1I57FPN_STAT'.
  ENDIF.
ENDFORM.

FORM print_challans.
  PERFORM select_print_data USING 'J1IF' "output_type
                                  p_werks
                                  ''
                            CHANGING options
                                     layout.
  SORT it_j_1iexchdr BY exnum.
  PERFORM open_form USING options
                        layout
                  CHANGING result.

  LOOP AT it_j_1iexchdr INTO wa_exchdr WHERE chk = 'X'.
    CLEAR lv_srno.
    PERFORM entry_57f4
           USING 'J1IF' " output_type
                 wa_exchdr.
    CLEAR wa_exchdr.
  ENDLOOP.
  PERFORM close_form.
ENDFORM.

FORM entry_57f4
           USING output_type
                 wa_exchdr TYPE t_exchdr. "like j_1iexchdr.


*perform select_print_data using output_type
*                                WA_EXCHDR-WERKS
*                       CHANGING OPTIONS
*                                LAYOUT.

  PERFORM select_data
                      TABLES itab_excdtl
                      USING wa_exchdr
                      CHANGING wa1_exchdr.
  BREAK fujiabap.
  ls_mkpf-mblnr = wa_exchdr-rdoc.
  SELECT SINGLE * FROM mkpf INTO ls_mkpf
    WHERE mblnr = ls_mkpf-mblnr
      AND mjahr = wa1_exchdr-ryear.

*  ls_ekko-ebeln = ls_mkpf-bktxt.
      CLEAR: ls_mseg1.
      SELECT SINGLE * FROM mseg INTO ls_mseg1
      WHERE mblnr = ls_mkpf-mblnr
        AND mjahr = ls_mkpf-mjahr
*        AND parent_id = j_1iexcdtl-ritem2  "abhay
*        AND zeile = j_1iexcdtl-zeile
        AND xauto = 'X'.
   BREAK fujiabap.
   ls_ekko-ebeln = ls_mseg1-ebeln.

  SELECT SINGLE * FROM ekko INTO ls_ekko WHERE ebeln = ls_ekko-ebeln.

  SELECT SINGLE * FROM t005t INTO ls_t005t
    WHERE land1 = lfa1-land1
      AND spras = sy-langu.

  SELECT SINGLE * FROM t005u INTO ls_t005u
    WHERE land1 = lfa1-land1
      AND bland = lfa1-regio
      AND spras = sy-langu.

*perform open_form USING OPTIONS
*                        LAYOUT
*                  CHANGING RESULT.
  PERFORM start_form.
  PERFORM print_layout.
  PERFORM end_form.
*perform close_form.

ENDFORM.

FORM start_form.
  CALL FUNCTION 'START_FORM'
*   EXPORTING
*     ARCHIVE_INDEX          =
*     FORM                   = ' '
*     LANGUAGE               = ' '
*     STARTPAGE              = ' '
*     PROGRAM                = ' '
*     MAIL_APPL_OBJECT       =
*   IMPORTING
*     LANGUAGE               =
    EXCEPTIONS
      form        = 1
      format      = 2
      unended     = 3
      unopened    = 4
      unused      = 5
      spool_error = 6
      codepage    = 7
      OTHERS      = 8.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM end_form.
  CALL FUNCTION 'END_FORM'
    IMPORTING
      result                   = result
    EXCEPTIONS
      unopened                 = 1
      bad_pageformat_for_print = 2
      spool_error              = 3
      codepage                 = 4
      OTHERS                   = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM write_form USING  window element fnction.

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element   = element
      function  = fnction
      window    = window
*    IMPORTING
*     PENDING_LINES =
    EXCEPTIONS
      element   = 1
      function  = 2
      type      = 3
      unopened  = 4
      unstarted = 5
      window    = 6
      OTHERS    = 7.

ENDFORM.                               " WRITE_FORM

FORM read_text.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = text_id
      language                = sy-langu
      name                    = thead-tdname
      object                  = 'J1IF'
      archive_handle          = 0
    IMPORTING
      header                  = thead
    TABLES
      lines                   = tlines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
ENDFORM.                               " READ_TEXT

FORM select_print_data USING    p_output_type
                                p_werks
                                p_preview
                       CHANGING p_options LIKE itcpo
                                p_layout.
  DATA wa_tnad7 LIKE tnad7.
  DATA wa_tnapr LIKE tnapr.


  SELECT SINGLE * FROM tnad7 INTO wa_tnad7
    WHERE kschl = p_output_type
    AND werks = p_werks.

  CHECK sy-subrc EQ 0.

  p_options-tddest = wa_tnad7-ldest.
  p_options-tddataset = wa_tnad7-dsnam.
  p_options-tdsuffix1 = wa_tnad7-dsuf1.
  p_options-tdsuffix2 = wa_tnad7-dsuf2.
  IF p_preview = 'X'.
    p_options-tdpreview = 'X'.
    p_options-tdnoprint = ''.
    p_options-tdnewid = 'X'.
    " print Immidiately param setting
    p_options-tdimmed = ''.  " wa_tnad7-dimme. is set to 'X' currently
  ELSE.
    p_options-tdpreview = ''.
    p_options-tdnoprint = 'X'.
    p_options-tdnewid = 'X'.
    " print Immidiately param setting
    p_options-tdimmed = ''.
  ENDIF.

  p_options-tddelete = wa_tnad7-delet.
  p_options-tdcover = wa_tnad7-tdocover.
  p_options-tdcovtitle = wa_tnad7-tdcovtitle.
  p_options-tdreceiver = wa_tnad7-tdreceiver.
  p_options-tddivision = wa_tnad7-tddivision.
  p_options-tdautority = wa_tnad7-tdautority.
  p_options-tdcopies   = 1 .
* P_OPTIONS-TDNEWID   = 'X' .
  p_options-tdprogram  = sy-repid.
* P_OPTIONS-TDFINAL    = 'X'.

  SELECT SINGLE * FROM tnapr INTO wa_tnapr
        WHERE kschl = p_output_type.

  CHECK sy-subrc EQ 0.

  p_layout  = wa_tnapr-fonam.

ENDFORM.                    " SELECT_PRINT_DATA

FORM select_data
                 TABLES p_itab_excdtl
                 USING    p_wa_exchdr TYPE t_exchdr "like j_1iexchdr
                 CHANGING p_wa1_exchdr TYPE t_exchdr. "like j_1iexchdr.

  DATA : msgstr TYPE string.

  SELECT SINGLE * FROM j_1iexchdr INTO p_wa1_exchdr
                       WHERE  trntyp = p_wa_exchdr-trntyp
                       AND  docno = p_wa_exchdr-docno
                       AND  docyr = p_wa_exchdr-docyr.

  SELECT * FROM j_1iexcdtl INTO TABLE p_itab_excdtl
                       WHERE  trntyp = p_wa_exchdr-trntyp
                       AND  docno = p_wa_exchdr-docno
                       AND  docyr = p_wa_exchdr-docyr.


  MOVE-CORRESPONDING p_wa1_exchdr TO j_1iexchdr.

  CLEAR: t001w,j_1iwrkcus,j_1iregset,j_1iindcus.

  CONCATENATE j_1iexchdr-trntyp j_1iexchdr-docno j_1iexchdr-docyr
    INTO text_name
    SEPARATED BY '-'.

  SELECT SINGLE * FROM  t001w
        WHERE  werks       = j_1iexchdr-werks.


*SELECT SINGLE * FROM ADRC
*        WHERE ADDRNUMBER = T001W-ADRNR.
*
*SELECT SINGLE * FROM T005U
*  WHERE LAND1 = ADRC-COUNTRY
*  AND BLAND = ADRC-REGION.

  " ADDING ADDRESS FIELD INTO THE SMARTFORM" SAUMI
  SELECT SINGLE a~addrnumber
                a~name1
                a~str_suppl1
                a~str_suppl2
                a~street
                a~city1
                a~post_code1
                a~country
                a~region
                b~bezei
    INTO wa_adrc
    FROM adrc AS a JOIN t005u AS b
    ON ( b~land1 = a~country AND b~bland = a~region )
    WHERE addrnumber = t001w-adrnr.


*    " GETTING REGION DESCRIPTION "
*    SELECT SINGLE BEZEI
*      INTO W_T005U
*      FROM T005U
*      WHERE LAND1 = WA_ADRC-COUNTRY
*      AND   BLAND = WA_ADRC-REGION.


  SELECT SINGLE * FROM j_1iwrkcus
        WHERE  j_1iwerks   = j_1iexchdr-werks.
  IF sy-subrc <> 0.
    CLEAR : msgstr.
    CONCATENATE 'Plant customisation not found (' text_name ').'
      INTO msgstr.
    MESSAGE e000(8i) WITH msgstr.
  ENDIF.
  SELECT SINGLE * FROM j_1iregset
        WHERE  j_1iregid   = j_1iwrkcus-j_1iregid.
  IF sy-subrc <> 0.
    CLEAR : msgstr.
    CONCATENATE 'Register id customisation not found (' text_name ').'
      INTO msgstr.
    MESSAGE e000(8i) WITH msgstr.
  ENDIF.
  SELECT SINGLE * FROM j_1iindcus WHERE
         j_1ibukrs = j_1iexchdr-bukrs.
  IF sy-subrc <> 0.
    CLEAR : msgstr.
    CONCATENATE 'Customisation missing .. indcus (' text_name ').'
      INTO msgstr.
    MESSAGE e000(8i) WITH msgstr.
  ENDIF.
  SELECT SINGLE * FROM lfa1 WHERE
  lifnr = j_1iexchdr-lifnr.
  IF sy-subrc <> 0.
    CLEAR : msgstr.
    CONCATENATE 'Vendor record missing .... (' text_name ').'
      INTO msgstr.
    MESSAGE e000(8i) WITH msgstr.
  ENDIF.
ENDFORM.                    " SELECT_DATA

FORM close_form.
  DATA str TYPE string.
  CALL FUNCTION 'CLOSE_FORM'
    IMPORTING
      result   = result
*     TABLES
*     OTFDATA  =
    EXCEPTIONS
      unopened = 1
      OTHERS   = 2.
  IF sy-subrc = 0 AND result-tdspoolid IS NOT INITIAL.
    str = result-tdspoolid.
    CONCATENATE 'Spool Request Number'
                 str 'generated'
      INTO str SEPARATED BY space.
    MESSAGE str TYPE 'S'.
  ENDIF.

ENDFORM.                    " CLOSE_FORM

FORM open_form
          USING options
                layout
          CHANGING result.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      application = 'ME'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
      device      = 'PRINTER'
      dialog      = ' '
      form        = layout
      language    = sy-langu
      options     = options
*     MAIL_SENDER =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
    IMPORTING
*     LANGUAGE    =
*     NEW_ARCHIVE_PARAMS          =
      result      = result
    EXCEPTIONS
      canceled    = 1
      device      = 2
      form        = 3
      options     = 4
      unclosed    = 5
*     MAIL_OPTIONS                = 6
*     ARCHIVE_ERROR               = 7
*     INVALID_FAX_NUMBER          = 8
*     MORE_PARAMS_NEEDED_IN_BATCH = 9
      OTHERS      = 10.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " OPEN_FORM

*&---------------------------------------------------------------------*
*&      Form  PRINT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_layout.
  PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
  PERFORM write_form USING 'MAIN' 'ITEM_HEADER' 'SET'.
  PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
*LOOP AT ITAB_EXCDTL INTO J_1IEXCDTL.
*    PERFORM WRITE_FORM USING 'MAIN' 'ITEM_VALUES' 'SET'.
*ENDLOOP.
*  PERFORM write_form USING 'MAIN' 'DASH_LINE' 'SET'.
*
  PERFORM write_form USING 'REGS' ' ' ' '.
  PERFORM write_form USING 'HEADER' ' ' ' '.
  PERFORM write_form USING 'TITLE' 'DOC_TITLE_T' 'SET'.
  PERFORM write_form USING 'TITLE' 'DOC_TITLE_EXC_INFO' 'APPEND'.
*
  PERFORM write_form USING 'ADDRESS' 'ADDRESSEE' 'SET'.
  PERFORM write_form USING 'ADRESS_D' ' ' ' '.

  PERFORM write_form USING 'INFO'    'HEADER_DATA' 'SET'.

  DATA lv_cnt TYPE i.

  REFRESH gt_excdtl02.
  LOOP AT itab_excdtl INTO j_1iexcdtl.

    MOVE-CORRESPONDING j_1iexcdtl TO ls_excdtl02.

    CLEAR: ls_mseg, ls_resb.
     SELECT SINGLE * FROM mseg INTO ls_mseg
      WHERE mblnr = ls_mkpf-mblnr
        AND mjahr = ls_mkpf-mjahr
        AND parent_id = j_1iexcdtl-ritem2
*        AND zeile = j_1iexcdtl-zeile
        AND xauto = 'X'.

*    IF ls_mseg-wempf IS INITIAL.  "abhay
     IF ls_mseg-ebelp IS INITIAL.
      SELECT SINGLE * FROM resb INTO ls_resb
        WHERE ebeln = ls_ekko-ebeln
          AND matnr = ls_mseg-matnr.

    ELSE.
*      ls_resb-ebelp = ls_mseg-wempf.  "abhay
        ls_resb-ebelp = ls_mseg-ebelp.
      SELECT SINGLE * FROM resb INTO ls_resb
        WHERE ebeln = ls_ekko-ebeln
          AND ebelp = ls_resb-ebelp
          AND matnr = ls_mseg-matnr.
    ENDIF.
    ls_excdtl02-recmtn = ls_resb-baugr.

    SELECT SINGLE * FROM ekpo INTO ls_ekpo
      WHERE ebeln = ls_ekko-ebeln
        AND ebelp = ls_resb-ebelp.

    ls_excdtl02-ebelp  = ls_ekpo-ebelp.
    ls_excdtl02-ekmng  = ls_ekpo-menge.
    ls_excdtl02-ekmns  = ls_ekpo-meins.
    ls_excdtl02-msmng  = ls_mseg-menge.
    ls_excdtl02-msmns  = ls_mseg-meins.
    ls_excdtl02-remng  = ls_resb-bdmng.
    ls_excdtl02-remns  = ls_resb-meins.
    IF ls_excdtl02-remng > 0.
      ls_excdtl02-rpmng  = ls_excdtl02-ekmng * ( ls_excdtl02-msmng / ls_excdtl02-remng ).
    ENDIF.

    CLEAR lv_cnt.
    LOOP AT gt_excdtl02 INTO ls_excdtlxx WHERE ebelp = ls_excdtl02-ebelp.  "recmtn = ls_excdtl02-recmtn.
      lv_cnt = lv_cnt + 1.
    ENDLOOP.
    ls_excdtl02-issnum = lv_cnt + 1.

    CLEAR lv_tdname1.
    lv_tdname1 = j_1iexcdtl-matnr.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_tdname1
        object                  = 'MATERIAL'
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*     IMPORTING
*       HEADER                  =
*       OLD_LINE_COUNTER        =
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      READ TABLE lt_lines INTO ls_lines INDEX 1.
      ls_excdtl02-issmtx  = ls_lines-tdline.
    ENDIF.

    APPEND ls_excdtl02 TO gt_excdtl02.
  ENDLOOP.

  SORT gt_excdtl02 BY ebelp recmtn issnum.

  DESCRIBE TABLE gt_excdtl02 LINES wrk_lines.
  CLEAR: wrk_rec, lv_srno.
  LOOP AT gt_excdtl02 INTO ls_excdtl02.
    wrk_rec = wrk_rec + 1.
    ls_excdtlxx = ls_excdtl02.

    AT NEW ebelp.   "recmtn.

      lv_srno = lv_srno + 1.

      CLEAR lv_tdname1.
      lv_tdname1 = ls_excdtlxx-recmtn.
      REFRESH lt_lines.

      CLEAR ls_excdtl02-recmtx.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_tdname1
          object                  = 'MATERIAL'
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*     IMPORTING
*         HEADER                  =
*         OLD_LINE_COUNTER        =
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE.
        READ TABLE lt_lines INTO ls_lines INDEX 1.
        ls_excdtl02-recmtx  = ls_lines-tdline.
*      ls_desc2  = ls_lines-tdline.
      ENDIF.

      PERFORM write_form USING 'MAIN' 'REC_ITEM' 'SET'.
    ENDAT.
    PERFORM write_form USING 'MAIN' 'ISS_ITEM' 'SET'.

*    IF wrk_rec  = 7.
**      PERFORM WRITE_FORM USING 'MAIN' 'DASH_LINE'   'SET'.
*      PERFORM control_forms .
*      PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
*      PERFORM write_form USING 'MAIN' 'ITEM_HEADER' 'SET'.
*      PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
*      PERFORM write_form USING 'MAIN' 'ITEM_VALUES' 'SET'.
*      IF wrk_rec = wrk_lines.
*        PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
*      ENDIF.
*    ELSE.
*      PERFORM write_form USING 'MAIN' 'ITEM_VALUES' 'SET'.
*      IF ( ( wrk_rec = 6 ) OR ( wrk_rec = wrk_lines ) )      .
*        PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
*      ENDIF.
*    ENDIF.
  ENDLOOP.



* New code added on 26/06/2006-for adjusting the print on first page
****  DESCRIBE TABLE itab_excdtl LINES wrk_lines.
****  CLEAR wrk_rec.
****  LOOP AT itab_excdtl INTO j_1iexcdtl.
****    wrk_rec = wrk_rec + 1.

**    CLEAR: ls_mseg, ls_resb, ls_desc1, ls_desc2.
**    SELECT SINGLE * FROM mseg INTO ls_mseg
**      WHERE mblnr = ls_mkpf-mblnr
**        AND mjahr = ls_mkpf-mjahr
**        AND parent_id = j_1iexcdtl-ritem2
***        AND zeile = j_1iexcdtl-zeile
**        AND xauto = 'X'.
**
**    IF ls_mseg-wempf IS INITIAL.
**      SELECT SINGLE * FROM resb INTO ls_resb
**        WHERE ebeln = ls_ekko-ebeln
**          AND matnr = ls_mseg-matnr.
**
**    ELSE.
**      ls_resb-ebelp = ls_mseg-wempf.
**      SELECT SINGLE * FROM resb INTO ls_resb
**        WHERE ebeln = ls_ekko-ebeln
**          AND ebelp = ls_resb-ebelp
**          AND matnr = ls_mseg-matnr.
**    ENDIF.
**
**    lv_tdname1 = j_1iexcdtl-matnr.
**
**    CALL FUNCTION 'READ_TEXT'
**      EXPORTING
***       CLIENT                  = SY-MANDT
**        id                      = 'GRUN'
**        language                = sy-langu
**        name                    = lv_tdname1
**        object                  = 'MATERIAL'
***       ARCHIVE_HANDLE          = 0
***       LOCAL_CAT               = ' '
***     IMPORTING
***       HEADER                  =
***       OLD_LINE_COUNTER        =
**      TABLES
**        lines                   = lt_lines
**      EXCEPTIONS
**        id                      = 1
**        language                = 2
**        name                    = 3
**        not_found               = 4
**        object                  = 5
**        reference_check         = 6
**        wrong_access_to_archive = 7
**        OTHERS                  = 8.
**    IF sy-subrc <> 0.
*** Implement suitable error handling here
**    ELSE.
**      READ TABLE lt_lines INTO ls_lines INDEX 1.
**      ls_desc1  = ls_lines-tdline.
**    ENDIF.
**
**    CLEAR lv_tdname1.
**    lv_tdname1 = ls_resb-baugr.
**    REFRESH lt_lines.
**
**    CALL FUNCTION 'READ_TEXT'
**      EXPORTING
***       CLIENT                  = SY-MANDT
**        id                      = 'GRUN'
**        language                = sy-langu
**        name                    = lv_tdname1
**        object                  = 'MATERIAL'
***       ARCHIVE_HANDLE          = 0
***       LOCAL_CAT               = ' '
***     IMPORTING
***       HEADER                  =
***       OLD_LINE_COUNTER        =
**      TABLES
**        lines                   = lt_lines
**      EXCEPTIONS
**        id                      = 1
**        language                = 2
**        name                    = 3
**        not_found               = 4
**        object                  = 5
**        reference_check         = 6
**        wrong_access_to_archive = 7
**        OTHERS                  = 8.
**    IF sy-subrc <> 0.
*** Implement suitable error handling here
**    ELSE.
**      READ TABLE lt_lines INTO ls_lines INDEX 1.
**      ls_desc2  = ls_lines-tdline.
**    ENDIF.

****
****    IF wrk_rec  = 7.
*****      PERFORM WRITE_FORM USING 'MAIN' 'DASH_LINE'   'SET'.
****      PERFORM control_forms .
****      PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
****      PERFORM write_form USING 'MAIN' 'ITEM_HEADER' 'SET'.
****      PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
****      PERFORM write_form USING 'MAIN' 'ITEM_VALUES' 'SET'.
****      IF wrk_rec = wrk_lines.
****        PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
****      ENDIF.
****    ELSE.
****      PERFORM write_form USING 'MAIN' 'ITEM_VALUES' 'SET'.
****      IF ( ( wrk_rec = 6 ) OR ( wrk_rec = wrk_lines ) )      .
****        PERFORM write_form USING 'MAIN' 'DASH_LINE'   'SET'.
****      ENDIF.
****
****    ENDIF.
****  ENDLOOP.

  PERFORM write_form USING 'MAIN'    'RETURN_DATE' 'SET'.
  PERFORM write_form USING 'MAIN'    'SERIAL_NO_HDR' 'SET'.
  PERFORM write_form USING 'MAIN'    'REVERSAL_AMOUNT' 'SET'.
  PERFORM write_form USING 'MAIN'    'DASH_LINE' 'SET'.
  PERFORM write_form USING 'MAIN'    'IDENTIFICATION' 'SET'.
  PERFORM write_form USING 'MAIN'    'NATURE' 'SET'.


  PERFORM write_form USING 'MAIN'    'MAIN_SIGN' 'SET'.
  text_id = 'PROC'.
*concatenate j_1iexchdr-rdoc j_1iexchdr-ryear into thead-tdname.
  thead-tdname = '57FC'.
  PERFORM read_text.
  LOOP AT tlines.
    IF tlines-tdline NE space.
      j_1iregset-j_1irgdesc = tlines-tdline.
    ENDIF.
  ENDLOOP.
  PERFORM write_form USING 'MAIN'    'MAIN_FOOTER' 'SET'.
*  PERFORM write_form USING 'MAIN'    'MAIN_SIGN_B' 'SET'.
*  PERFORM write_form USING 'FOOTER' ' ' 'SET'.

ENDFORM.                    " PRINT_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  control_FORMs
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM control_forms .
  CALL FUNCTION 'CONTROL_FORM'
    EXPORTING
      command   = 'NEW-PAGE'
    EXCEPTIONS
      unopened  = 1
      unstarted = 2
      OTHERS    = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " control_FORMs
