*&---------------------------------------------------------------------*
*& Report ZORDER_CONFIRM_PROG                                                *
*&*&* 1.PROGRAM OWNER       : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : SMARTFROM DEVLOPMENT
* 3.PROGRAM NAME            : ZORDER_CONFIRM_PROG.                           *
* 4.TRANS CODE              : ZORDER                                   *
* 5.MODULE NAME             : SD.                                 *
* 6.REQUEST NO              : DEVK904851 PRIMUS:ABAP:AB:NEW SMARTFORM DEVELOPMENT:15/09/2018                               *
* 7.CREATION DATE           : 20.09.2018.                              *
* 8.CREATED BY              : AVINASH BHAGAT.                          *
* 9.FUNCTIONAL CONSULTANT   : ANUJ DESHPANDE.                                   *
* 10.BUSINESS OWNER         : DELVAL.                                *
*&---------------------------------------------------------------------*
REPORT zorder_confirm_prog.
TABLES: nast,                          "Messages
        *nast,                         "Messages
        tnapr,                         "Programs & Forms
        itcpo,                         "Communicationarea for Spool
        arc_params,                    "Archive parameters
        toa_dara,                      "Archive parameters
        addr_key,                      "Adressnumber for ADDRESS
        vbak.

INCLUDE zorder_confirm.

DATA : so_code LIKE vbak-vbeln.
DATA : basic_amt TYPE p DECIMALS 2.
DATA : total TYPE p DECIMALS 2.
DATA : zkbetr TYPE prcd_elements-kbetr.
DATA : htext(40) TYPE c.
DATA : lv_lines1 TYPE tline.
DATA : lv_memo TYPE tline.
DATA : lv_insurance TYPE tline.
DATA : lv_mod TYPE tline.
DATA : lv_doct TYPE tline.           " DOCUMENTS THROUGH
DATA : lv_sinst TYPE tline.          " SPECIAL INSTRUCTION
DATA : lv_lddate TYPE tline.
DATA : v_amt TYPE char100.
DATA : grand_total  TYPE p DECIMALS 2.
DATA : joig TYPE string.
DATA : tot_qty TYPE vbap-kwmeng.
DATA : jocg_amt TYPE p DECIMALS 2.
DATA : josg_amt TYPE p DECIMALS 2.

DATA : gs_ctrlop  TYPE ssfctrlop,
       gs_outopt  TYPE ssfcompop,
       gs_otfdata TYPE ssfcrescl.

DATA : control         TYPE ssfctrlop.
DATA : output_options  TYPE ssfcompop.
DATA:   retcode   LIKE sy-subrc.         "Returncode
DATA:   xscreen(1) TYPE c.               "Output on printer or screen
DATA:   repeat(1) TYPE c.
DATA: nast_anzal LIKE nast-anzal.      "Number of outputs (Orig. + Cop.)
DATA: nast_tdarmod LIKE nast-tdarmod.  "Archiving only one time

DATA: gf_language LIKE sy-langu.
DATA: so_doc_exp    LIKE     vbco3.
    DATA: LV_LENGTH     TYPE STRING.
    DATA: LV_LATRS      TYPE C.
    DATA: LV_LATRS1     TYPE C.
    DATA: LV_INDEX      TYPE SY-INDEX.
    DATA: LV_SAFE_LEN   TYPE SY-INDEX.
    DATA: LV_LINES      TYPE STRING.
    DATA: LV_SPACE      TYPE STRING.
    DATA: LV_SPACE1     TYPE STRING.
    DATA: LV_SPACE2     TYPE STRING.

FORM entry  USING return_code us_screen.
*  break primus.
  CLEAR retcode.
  xscreen = us_screen.

  PERFORM processing USING us_screen.
  CASE retcode.
    WHEN 0.
      return_code = 0.
    WHEN 3.
      return_code = 3.
    WHEN OTHERS.
      return_code = 1.
  ENDCASE.
ENDFORM.

FORM processing USING us_screen.

  so_doc_exp-spras = 'E'.
  so_doc_exp-vbeln = nast-objky.

  so_code = nast-objky.
  PERFORM clear.
  PERFORM get_data.         "SELECT QUERIES
  PERFORM process_data.
  PERFORM grandwords.
  PERFORM get_ofmdate.
  PERFORM get_memo.
  PERFORM get_insurance.
  PERFORM get_mod.
  PERFORM get_doct.
  PERFORM get_sinst.
  PERFORM get_lddate.
  PERFORM smartfrom_data.

ENDFORM.

FORM get_data .

  SELECT
    vbeln
    kunnr
    erdat
    vdatu
    waerk
    auart
    knumv
    zldfromdate
    FROM vbak
    INTO TABLE it_vbak
    WHERE vbeln = so_code.
*break primus.
*  IF it_vbak IS NOT INITIAL.
  SELECT
    vbeln
    kunnr
    parvw
    FROM vbpa
    INTO TABLE it_vbpa
    FOR ALL ENTRIES IN it_vbak
    WHERE vbeln EQ it_vbak-vbeln AND parvw = 'WE'.
*  ENDIF.
*BREAK PRIMUS.
*  IF it_vbak IS NOT INITIAL.
  SELECT
    vbeln
    kunnr
    parvw
    FROM vbpa
    INTO TABLE it_vbpa1
    FOR ALL ENTRIES IN it_vbak
    WHERE vbeln EQ it_vbak-vbeln AND parvw = 'AG'.
*  ENDIF.
*break primus.
  IF it_vbpa IS NOT INITIAL.
    SELECT
      kunnr
      name1
      pstlz
      ort01
      stcd3
      FROM kna1
      INTO TABLE it_kna12
      FOR ALL ENTRIES IN it_vbpa
      WHERE kunnr EQ it_vbpa-kunnr1.


  ENDIF.

  IF it_vbpa1 IS NOT INITIAL.

    SELECT
      kunnr
      name1
      name2
      pstlz
      ort01
      stcd3
      FROM kna1
      INTO TABLE it_kna1
*      FOR ALL ENTRIES IN it_vbak
*      WHERE kunnr EQ it_vbak-kunnr.
      FOR ALL ENTRIES IN it_vbpa1
      WHERE kunnr EQ it_vbpa1-kunnr3.
  ENDIF.

  IF it_kna1 IS NOT INITIAL.
    SELECT
      vbeln
      bstkd
      bstdk
      FROM vbkd
      INTO  TABLE it_vbkd
      FOR ALL ENTRIES IN it_vbak
      WHERE vbeln EQ it_vbak-vbeln.
  ENDIF.

  IF it_vbak IS NOT INITIAL.
    SELECT
      vbeln
      posnr
      matnr
      arktx
      meins
      kwmeng
      zmeng
      deldate
      netpr
      netwr
      abgru
      posex
      FROM vbap
      INTO TABLE it_vbap
      FOR ALL ENTRIES IN it_vbak
      WHERE vbeln EQ it_vbak-vbeln
      AND  ( REASON NE '02' AND REASON NE '11' ).
  ENDIF.

  SELECT
    vbeln
    zterm
    FROM vbkd
    INTO TABLE it_vbkd1
    FOR ALL ENTRIES IN it_vbap
    WHERE vbeln EQ it_vbap-vbeln.

  SELECT
    zterm
    vtext
    spras
    FROM tvzbt
    INTO TABLE it_tvzbt
    FOR ALL ENTRIES IN it_vbkd1
    WHERE zterm EQ it_vbkd1-zterm AND
    spras = 'E'.

  SELECT
    vbelv
    vbeln
    vbtyp_n
    FROM vbfa
    INTO TABLE it_vbfa
    FOR ALL ENTRIES IN it_vbak
    WHERE vbelv EQ it_vbak-vbeln AND vbtyp_n = 'M'.

  SELECT
    knumv
    kposn
    kschl
    kbetr
    kntyp
    kwert
*    FROM konv
    FROM prcd_elements
    INTO TABLE it_konv
    FOR ALL ENTRIES IN it_vbak
    WHERE knumv EQ it_vbak-knumv.

  SELECT
  knumv
*  kbetr
*    kschl
  kntyp
*  kwert
*  FROM konv
     FROM prcd_elements
  INTO TABLE it_konv1
  FOR ALL ENTRIES IN it_vbak
  WHERE knumv EQ it_vbak-knumv AND kntyp = 'D' .
ENDFORM.

FORM process_data .
  DATA(lo_text_reader) = NEW zcl_read_text( ).


  LOOP AT it_vbap INTO wa_vbap.
    wa_final-vbeln   = wa_vbap-vbeln.
    wa_final-posnr   = wa_vbap-posnr.
    wa_final-matnr   = wa_vbap-matnr.
    wa_final-arktx   = wa_vbap-arktx .
    wa_final-meins   = wa_vbap-meins  .
    wa_final-kwmeng  = wa_vbap-kwmeng .
    wa_final-zmeng  = wa_vbap-zmeng .
    wa_final-deldate = wa_vbap-deldate.
    wa_final-netpr   = wa_vbap-netpr  .
    wa_final-netwr   = wa_vbap-netwr  .

    wa_final-posex   = wa_vbap-posex.

    wa_final-abgru   = wa_vbap-abgru.
    IF wa_vbap-abgru IS NOT INITIAL.
      DELETE it_vbap WHERE abgru IS NOT INITIAL.
      CONTINUE.
      wa_final-abgru   = wa_vbap-abgru.
    ENDIF.

    READ TABLE it_vbpa1 INTO wa_vbpa1 WITH KEY vbeln = wa_final-vbeln." wa_final
    IF sy-subrc = 0.
      wa_final-kunnr = wa_vbpa1-kunnr3.
      CLEAR wa_vbpa1.
    ENDIF.
""""""added by md
    IF wa_final-kwmeng IS NOT INITIAL.
      wa_final-tot_qty =  wa_final-tot_qty +  wa_final-kwmeng.
    ELSE.
      wa_final-tot_qty =  wa_final-tot_qty +  wa_final-zmeng.
    ENDIF.

    READ TABLE it_vbpa INTO wa_vbpa WITH KEY vbeln = wa_final-vbeln.
    IF sy-subrc = 0.
      wa_final-vbeln = wa_vbpa-vbeln.
      wa_final-kunnr1 = wa_vbpa-kunnr1.
      wa_final-parvw = wa_vbpa-parvw.
    ENDIF.

    READ TABLE it_kna12 INTO wa_kna12 WITH KEY kunnr2 = wa_final-kunnr1 BINARY SEARCH.
    IF sy-subrc = 0.
      wa_final-kunnr2 = wa_kna12-kunnr2.
      wa_final-name12 = wa_kna12-name12.
      wa_final-pstlz1 = wa_kna12-pstlz1.
      wa_final-ort012 = wa_kna12-ort012.
      wa_final-stcd31 = wa_kna12-stcd31.
    ENDIF.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_final-kunnr.
    IF sy-subrc EQ 0 .
      wa_final-kunnr = wa_kna1-kunnr.
      wa_final-name1 = wa_kna1-name1.
      wa_final-name2 = wa_kna1-name2.
      wa_final-pstlz = wa_kna1-pstlz.
      wa_final-ort01 = wa_kna1-ort01.
      wa_final-stcd3 = wa_kna1-stcd3.
    ENDIF.

    READ TABLE it_vbkd INTO wa_vbkd WITH  KEY vbeln = wa_final-vbeln BINARY SEARCH.
    IF sy-subrc EQ 0 .
      wa_final-vbeln = wa_vbkd-vbeln.
      wa_final-bstkd = wa_vbkd-bstkd.
      wa_final-bstdk = wa_vbkd-bstdk.
    ENDIF.

    READ TABLE it_vbak INTO wa_vbak WITH  KEY vbeln = wa_final-vbeln BINARY SEARCH.
* LOOP AT IT_VBAP INTO WA_VBAP.
    IF sy-subrc EQ 0.
      wa_final-vbeln = wa_vbak-vbeln.
      wa_final-kunnr = wa_vbak-kunnr.
      wa_final-erdat = wa_vbak-erdat.
      wa_final-vdatu = wa_vbak-vdatu.
      wa_final-waerk = wa_vbak-waerk.
      wa_final-auart = wa_vbak-auart.
      wa_final-knumv = wa_vbak-knumv.
      wa_final-zldfromdate = wa_vbak-zldfromdate.

      wa_final-basic_amt = wa_final-basic_amt + wa_final-netwr .
    ENDIF.

    READ TABLE it_vbfa INTO wa_vbfa WITH KEY vbelv = wa_final-vbeln.
    IF sy-subrc = 0.
      wa_final-vbelv = wa_vbfa-vbelv.
      wa_final-vbeln1 = wa_vbfa-vbeln1.
      wa_final-vbtyp_n = wa_vbfa-vbtyp_n.
    ENDIF.

    LOOP AT it_konv INTO wa_konv WHERE knumv = wa_vbak-knumv AND kposn = wa_vbap-posnr .
      IF wa_konv-kschl = 'ZPR0'.

        wa_final-netpr   = wa_konv-kbetr.
        IF wa_final-kwmeng IS NOT INITIAL.
          wa_final-netwr   = wa_final-netpr * wa_final-kwmeng  .
        ELSE.
          wa_final-netwr   = wa_final-netpr * wa_final-zmeng  ." added by md
        ENDIF.
      ENDIF.

      IF wa_konv-kschl = 'ZPFO'.
        wa_final-knumv = wa_konv-knumv.
        wa_final-kschl = wa_konv-kschl.
        wa_final-kbetr =  wa_konv-kbetr.
        wa_final-kwert =  wa_konv-kwert.

      ELSEIF wa_konv-kschl = 'ZIN1' .
        wa_final-knumv = wa_konv-knumv.
        wa_final-kschl = wa_konv-kschl.
        wa_final-kbetr1 =  wa_konv-kbetr.

      ELSEIF wa_konv-kschl = 'ZFR1'  .
        wa_final-knumv = wa_konv-knumv.
        wa_final-kschl = wa_konv-kschl.
        wa_final-kbetr2 =  wa_konv-kbetr.

      ELSEIF wa_konv-kschl = 'ZTE1'  .
        wa_final-knumv = wa_konv-knumv.
        wa_final-kschl = wa_konv-kschl.
        wa_final-kbetr3 =  wa_konv-kbetr.

      ELSEIF wa_konv-kschl = 'ZTCS' .
        wa_final-knumv = wa_konv-knumv.
        wa_final-kschl = wa_konv-kschl.
        wa_final-kbetr4 =  wa_konv-kbetr. "WA_KONV-KBETR.
        wa_final-kbetr4 =  wa_konv-kwert.
*      ENDIF.
*endloop.
*******************       change added
        ELSEIF wa_konv-kschl = 'JTC2' .
        wa_final-knumv = wa_konv-knumv.
        wa_final-kschl = wa_konv-kschl.
        wa_final-kbetr01 =  wa_konv-kbetr. "WA_KONV-KBETR.
        wa_final-kbetr01 =  wa_konv-kwert.

*LOOP AT it_konv1 INTO wa_konv1. .
      ELSEIF wa_konv-kschl = 'JOIG' AND wa_konv-kntyp = 'D'.
        wa_final-knumv = wa_konv-knumv.
        wa_final-joig = wa_konv-kbetr." / 10 .

*  CONCATENATE 'IGST' WA_FINAL-JOIG '%' INTO JOIG SEPARATED BY ' '.

      ELSEIF wa_konv-kschl = 'JOCG' AND wa_konv-kntyp = 'D'.
        wa_final-knumv = wa_konv-knumv.
        wa_final-jocg = wa_konv-kbetr. " / 10 .

      ELSEIF wa_konv-kschl = 'JOSG' AND wa_konv-kntyp = 'D'.
        wa_final-knumv = wa_konv-knumv.
        wa_final-josg = wa_konv-kbetr. " / 10 .
      ENDIF.
*endloop.

    ENDLOOP.


*    ON CHANGE OF wa_vbap-vbeln .
*on CHANGE OF wa_vbak-vbeln.
IF wa_final-joig IS NOT INITIAL.
      LOOP AT it_konv1 INTO wa_konv1.
        wa_final-knumv = wa_konv1-knumv.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        wa_final-total1 = ( wa_final-basic_amt * wa_final-joig ) / 100.
   ENDLOOP.
   ENDIF.
"Added By Nilay B. on 21.02.2023
    IF wa_final-joig IS NOT INITIAL AND wa_final-auart = 'ZFRE' OR wa_final-auart = 'ZREP'.
      LOOP AT it_konv1 INTO wa_konv1.
        wa_final-knumv = wa_konv1-knumv.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
*        wa_final-total1 = ( wa_final-basic_amt * wa_final-joig ) / 100.
        wa_final-total1 = ( wa_final-netwr * wa_final-joig ) / 100.
      ENDLOOP.
    ENDIF.
"Ended By Nilay On 21.02.2023
    IF  wa_final-jocg IS NOT INITIAL AND wa_final-josg IS NOT INITIAL .
      LOOP AT it_konv1 INTO wa_konv1.
        wa_final-knumv = wa_konv1-knumv.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        wa_final-jocg_amt = ( wa_final-basic_amt * wa_final-jocg ) / 100 .
        wa_final-josg_amt = ( wa_final-basic_amt * wa_final-josg ) / 100 .
*wa_final-total1 = wa_final-jocg_amt + wa_final-josg_amt.

      ENDLOOP.
    ENDIF.
"Added By Nilay On 21.02.2023
    IF  wa_final-jocg IS NOT INITIAL AND wa_final-josg IS NOT INITIAL AND wa_final-auart = 'ZFRE' OR wa_final-auart = 'ZREP'. "Added By Nilay B. on 21.02.2023.
      LOOP AT it_konv1 INTO wa_konv1.
        wa_final-knumv = wa_konv1-knumv.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        wa_final-jocg_amt = ( wa_final-netwr * wa_final-jocg ) / 100 .
        wa_final-josg_amt = ( wa_final-netwr * wa_final-josg ) / 100 .
*wa_final-total1 = wa_final-jocg_amt + wa_final-josg_amt.

      ENDLOOP.
    ENDIF.
"Ended By Nilay On 21.02.2023
    wa_final-total =  wa_final-basic_amt + wa_final-kbetr + wa_final-kbetr1 + wa_final-kbetr2 + wa_final-kbetr3 + wa_final-kbetr4 + wa_final-kbetr01.
    IF wa_final-joig IS NOT INITIAL.
      wa_final-grand =  wa_final-total + wa_final-total1.
    ENDIF.
    IF  wa_final-jocg IS NOT INITIAL AND wa_final-josg IS NOT INITIAL.
      wa_final-grand =  wa_final-total + wa_final-jocg_amt + wa_final-josg_amt.
    ENDIF.
    IF wa_final-auart = 'ZDEX' OR wa_final-auart = 'ZEXP'.
      wa_final-grand =  wa_final-total.
    ENDIF.
    grand_total = wa_final-basic_amt.

    READ TABLE it_vbkd1 INTO wa_vbkd1 WITH KEY vbeln = wa_final-vbeln BINARY SEARCH.
    IF sy-subrc = 0.
      wa_final-vbeln = wa_vbkd1-vbeln.
      wa_final-zterm = wa_vbkd1-zterm.
    ENDIF.

    READ TABLE it_tvzbt INTO wa_tvzbt WITH KEY zterm = wa_final-zterm.
    IF sy-subrc = 0.
      wa_final-zterm = wa_tvzbt-zterm.
      wa_final-vtext = wa_tvzbt-vtext.
    ENDIF.

    APPEND wa_final TO it_final.
*delete it_final where abgru is NOT INITIAL.
    CLEAR wa_final.
  ENDLOOP.

*  clear wa_final-total1.
ENDFORM.

FORM grandwords.
  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
    EXPORTING
      amt_in_num         = grand_total
    IMPORTING
      amt_in_words       = v_amt
    EXCEPTIONS
      data_type_mismatch = 1
      OTHERS             = 2.

*  CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
*    EXPORTING
*      input_string  = v_amt
*      separators    = ' '
*    IMPORTING
*      output_string = v_amt.

ENDFORM.

FORM get_ofmdate.
DATA(lo_text_reader) = NEW zcl_read_text( ).

  DATA : vbeln_1  TYPE thead-tdname,
        lv_lines TYPE tline.

  LOOP AT it_final INTO wa_final.
    vbeln_1 = wa_final-vbeln. "'1023170052'.
*
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'Z016'
*        language                = 'E'
*        name                    = vbeln_1
*        object                  = 'VBBK'
*      TABLES
*        lines                   = gt_lines
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
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT gt_lines INTO ls_lines.
*      LV_LENGTH = STRLEN( ls_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = ls_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*        lv_lines1 = LV_LINES.
**      lv_lines1 = ls_lines-tdline.
*      wa_final-lv_lines1 = lv_lines1 .
*
*    ENDLOOP.
 lo_text_reader->read_text_string( EXPORTING id = 'Z016' name = vbeln_1 object = 'VBBK' IMPORTING lv_lines = DATA(lv_lines2) ).
 lv_lines1 = lv_lines2.
 wa_final-lv_lines1 = lv_lines1.
 clear lv_lines2.
    MODIFY it_final FROM wa_final TRANSPORTING lv_lines1.
   CLEAR : lv_lines1 ,wa_final ,lv_lines.
  ENDLOOP.
ENDFORM.

FORM get_memo.
DATA(lo_text_reader) = NEW zcl_read_text( ).

  DATA : vbeln_1  TYPE thead-tdname,
         lv_lines TYPE tline.
CLEAR: lv_LINES , gt_lines , ls_lines.
  LOOP AT it_final INTO wa_final.
    vbeln_1 = wa_final-vbeln. "'1023170052'.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'Z015'
*        language                = 'E'
*        name                    = vbeln_1
*        object                  = 'VBBK'
*      TABLES
*        lines                   = gt_lines
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
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT gt_lines INTO ls_lines.
*
*      LV_LENGTH = STRLEN( ls_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = ls_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
**      lv_memo = ls_lines-tdline.
*        lv_memo = LV_LINES.
*      wa_final-lv_memo  = lv_memo  .
*
*    ENDLOOP.
lo_text_reader->read_text_string( EXPORTING id = 'Z015' name = vbeln_1 object = 'VBBK' IMPORTING lv_lines = data(lv_lines2) ).
lv_memo = lv_lines2.
wa_final-lv_memo  = lv_memo .
clear lv_lines2.
    MODIFY it_final FROM wa_final TRANSPORTING lv_memo .
    CLEAR: lv_memo ,wa_final , lv_lines .
  ENDLOOP.
ENDFORM.

FORM get_insurance.
DATA(lo_text_reader) = NEW zcl_read_text( ).

  DATA : vbeln_1  TYPE thead-tdname,
         lv_lines TYPE tline.
clear : lv_lines , gt_lines ,ls_lines.
  LOOP AT it_final INTO wa_final.
    vbeln_1 = wa_final-vbeln. "'1023170052'.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'Z017'
*        language                = 'E'
*        name                    = vbeln_1
*        object                  = 'VBBK'
*      TABLES
*        lines                   = gt_lines
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
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT gt_lines INTO ls_lines.
*
*      LV_LENGTH = STRLEN( ls_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = ls_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*
**      lv_insurance = ls_lines-tdline.
*      lv_insurance = lv_lines.
*      wa_final-lv_insurance  = lv_insurance  .
*
*    ENDLOOP.
lo_text_reader->read_text_string( EXPORTING id = 'Z017' name = vbeln_1 object = 'VBBK' IMPORTING lv_lines = DATA(lv_lines2) ).
  lv_insurance = lv_lines2.
  wa_final-lv_insurance  = lv_insurance .
  clear lv_lines1.
    MODIFY it_final FROM wa_final TRANSPORTING lv_insurance .
    CLEAR : lv_insurance ,wa_final , lv_lines .
  ENDLOOP.

ENDFORM.

FORM get_mod.

DATA(lo_text_reader) = NEW zcl_read_text( ).

  DATA : vbeln_1  TYPE thead-tdname,
         lv_lines TYPE tline.

clear : lv_lines , gt_lines ,ls_lines.
  LOOP AT it_final INTO wa_final.
   vbeln_1 = wa_final-vbeln. "'1023170052'.
*
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'Z018'
*        language                = 'E'
*        name                    = vbeln_1
*        object                  = 'VBBK'
*      TABLES
*        lines                   = gt_lines
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
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT gt_lines INTO ls_lines.
*
*      LV_LENGTH = STRLEN( ls_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = ls_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*
**      lv_mod = ls_lines-tdline.
*       lv_mod = lv_lines.
*      wa_final-lv_mod  = lv_mod  .
*
*    ENDLOOP.
     lo_text_reader->read_text_string( EXPORTING id = 'Z018' name = vbeln_1 object = 'VBBK' IMPORTING lv_lines = DATA(lv_lines2) ).
    lv_mod = lv_lines2.
   wa_final-lv_mod  = lv_mod .
   clear lv_lines2.
    MODIFY it_final FROM wa_final TRANSPORTING lv_mod .
    CLEAR: lv_mod ,wa_final, lv_lines .
  ENDLOOP.

ENDFORM.

FORM get_doct.

  DATA : vbeln_1  TYPE thead-tdname,
         lv_lines TYPE tline.
clear : lv_lines , gt_lines ,ls_lines.
DATA(lo_text_reader) = NEW zcl_read_text( ).

  LOOP AT it_final INTO wa_final.
    vbeln_1 = wa_final-vbeln. "'1023170052'.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'Z019'
*        language                = 'E'
*        name                    = vbeln_1
*        object                  = 'VBBK'
*      TABLES
*        lines                   = gt_lines
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
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT gt_lines INTO ls_lines.
*      LV_LENGTH = STRLEN( ls_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = ls_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*
**      lv_doct = ls_lines-tdline.
*      lv_doct = LV_LINES.
*      wa_final-lv_doct  = lv_doct  .
*
*    ENDLOOP.
lo_text_reader->read_text_string( EXPORTING id = 'Z019' name = vbeln_1 object = 'VBBK' IMPORTING lv_lines = DATA(lv_lines2) ).
 lv_doct = lv_lines2.
 wa_final-lv_doct  = lv_doct.
 clear lv_lines2.
    MODIFY it_final FROM wa_final TRANSPORTING lv_doct .
    CLEAR: lv_doct ,wa_final , lv_lines.
  ENDLOOP.

ENDFORM.

FORM get_sinst.

  DATA : vbeln_1  TYPE thead-tdname,
         lv_lines TYPE tline.
DATA(lo_text_reader) = NEW zcl_read_text( ).

clear : lv_lines , gt_lines ,ls_lines.
  LOOP AT it_final INTO wa_final.
    vbeln_1 = wa_final-vbeln. "'1023170052'.
*
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'Z020'
*        language                = 'E'
*        name                    = vbeln_1
*        object                  = 'VBBK'
*      TABLES
*        lines                   = gt_lines
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
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT gt_lines INTO ls_lines.
*      LV_LENGTH = STRLEN( ls_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = ls_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*
**      lv_sinst = ls_lines-tdline.
*       lv_sinst = lv_lines.
*      REPLACE ALL OCCURRENCES OF '<(>&<)>' IN lv_sinst WITH '&'.
*      wa_final-lv_sinst  = lv_sinst  .
  lo_text_reader->read_text_string( EXPORTING id = 'Z020' name = vbeln_1 object = 'VBBK' IMPORTING lv_lines = DATA(lv_lines2) ).
 lv_sinst  = lv_lines2.
 wa_final-lv_sinst  = lv_sinst  .

 clear lv_lines2.

*    ENDLOOP.
    MODIFY it_final FROM wa_final TRANSPORTING lv_sinst .
    CLEAR: lv_sinst ,wa_final , lv_lines .
  ENDLOOP.

ENDFORM.
FORM get_lddate.

  DATA : vbeln_1  TYPE thead-tdname,
         lv_lines TYPE tline.
DATA(lo_text_reader) = NEW zcl_read_text( ).

 clear : lv_lines , gt_lines ,ls_lines.
  LOOP AT it_final INTO wa_final.
       vbeln_1 = wa_final-vbeln. "'1023170052'.
*
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        client                  = sy-mandt
*        id                      = 'Z038'
*        language                = 'E'
*        name                    = vbeln_1
*        object                  = 'VBBK'
*      TABLES
*        lines                   = gt_lines
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
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT gt_lines INTO ls_lines.
*      LV_LENGTH = STRLEN( ls_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = ls_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*
**      lv_lddate = ls_lines-tdline.
*      lv_lddate = LV_LINES.
*      wa_final-lv_lddate  = lv_lddate  .
*    ENDLOOP.
       lo_text_reader->read_text_string( EXPORTING id = 'Z038' name = vbeln_1 object = 'VBBK' IMPORTING lv_lines = DATA(lv_lines2) ).
 lv_lddate = lv_lines2.
 wa_final-lv_lddate  = lv_lddate  .
 clear lv_lines2.
    MODIFY it_final FROM wa_final TRANSPORTING lv_lddate .
    CLEAR wa_final.
   CLEAR :lv_lddate , lv_lines  .
  ENDLOOP.

ENDFORM.
FORM smartfrom_data .

  gs_ctrlop-getotf = 'X'.
  gs_ctrlop-device = 'PRINTER'.
  gs_ctrlop-preview = ''.
  gs_ctrlop-no_dialog = 'X'.
  gs_outopt-tddest = 'LOCL'.
********************************* Adobe By Vijay *****************************************************************
DATA: lv_fm_name TYPE funcname,
      lv_doc_params TYPE sfpdocparams,
      lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
      ls_form_output  TYPE fpformoutput.
DATA:       E_FUNCNM TYPE FUNCNAME .             " Name of the Function Module
CONSTANTS : sf_name1 TYPE FPNAME VALUE 'ZORDER_FORM_SFP'.


lv_output_params-DEVICE = 'PRINTER'.
lv_output_params-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.

lv_output_params-NODIALOG = 'X'.
lv_output_params-PREVIEW = ''.
lv_output_params-REQIMM = 'X'.

ELSE.
lv_output_params-NODIALOG = ''.
lv_output_params-PREVIEW = 'X'.

ENDIF.


CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lv_output_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = sf_name1 ""
    IMPORTING
      e_funcname = E_FUNCNM.

CALL FUNCTION E_FUNCNM "'/1BCDWB/SM00000093'
 EXPORTING
*   /1BCDWB/DOCPARAMS       =
   OUTPUT_OPTIONS           = gs_outopt
   USER_SETTINGS            = space
   LV_VBELN                 = so_code
   V_AMT                    = v_amt
   IT_FINAL                 = it_final
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   FORMATTING_ERROR         = 4
*   SEND_ERROR               = 5
*   USER_CANCELED            = 6
*   OTHERS                   = 7
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


*CALL FUNCTION E_FUNCNM  ""'/1BCDWB/SM00000009'
* EXPORTING
**   /1BCDWB/DOCPARAMS        =
**   ARCHIVE_INDEX            =
**   ARCHIVE_INDEX_TAB        =
**   ARCHIVE_PARAMETERS       =
**   CONTROL_PARAMETERS       =
**   MAIL_APPL_OBJ            =
**   MAIL_RECIPIENT           =
**   MAIL_SENDER              =
*   OUTPUT_OPTIONS           = gs_outopt
*   USER_SETTINGS            = space
*   LV_VBELN                 = so_code
*   V_AMT                    = v_amt
*   IT_FINAL                 = it_final
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
** EXCEPTIONS
**   USAGE_ERROR              = 1
**   SYSTEM_ERROR             = 2
**   INTERNAL_ERROR           = 3
**   OTHERS                   = 4
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.




  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  IF sy-subrc <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.





******************************ended*******************************************************************************
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname = sf_name
**     VARIANT  = ' '
**     DIRECT_CALL              = ' '
*    IMPORTING
*      fm_name  = fm_name
** EXCEPTIONS
**     NO_FORM  = 1
**     NO_FUNCTION_MODULE       = 2
**     OTHERS   = 3
*    .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  DATA : ls_dlv-land LIKE vbrk-land1 VALUE 'IN'.
*  DATA: ls_composer_param     TYPE ssfcompop.
*  PERFORM set_print_param USING    "ls_addr_key
*                                   ls_dlv-land
*                          CHANGING gs_ctrlop
*                                   gs_outopt.
*
*CALL FUNCTION                      fm_name"'/1BCDWB/SF00000090'
*  EXPORTING
**   ARCHIVE_INDEX              =
**   ARCHIVE_INDEX_TAB          =
**   ARCHIVE_PARAMETERS         =
*   control_parameters         = gs_ctrlop
**   MAIL_APPL_OBJ              =
**   MAIL_RECIPIENT             =
**   MAIL_SENDER                =
*   output_options             = gs_outopt
*   user_settings              = space"'X'
*    lv_vbeln                   = so_code
*    v_amt                      = v_amt
* IMPORTING
**   DOCUMENT_OUTPUT_INFO       =
*   job_output_info            = gs_otfdata
**   JOB_OUTPUT_OPTIONS         =
*  TABLES
*    it_final                   = it_final
*    it_lines                   = gt_lines
* EXCEPTIONS
*   formatting_error           = 1
*   internal_error             = 2
*   send_error                 = 3
*   user_canceled              = 4
*   OTHERS                     = 5.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

*  CALL FUNCTION fm_name
*    EXPORTING
*      lv_vbeln           = so_code
*      v_amt              = v_amt
*      control_parameters = gs_ctrlop
*      output_options     = gs_outopt
*      user_settings      = space
*    IMPORTING
*      job_output_info    = gs_otfdata
*    TABLES
*      it_final           = it_final
**     it_lines           = GT_LINES
*    EXCEPTIONS
*      formatting_error   = 1
*      internal_error     = 2
*      send_error         = 3
*      user_canceled      = 4
*      OTHERS             = 5.
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.

  REFRESH it_final.
  CLEAR wa_final.
ENDFORM.


FORM set_print_param USING    "IS_ADDR_KEY LIKE ADDR_KEY
                              is_dlv-land LIKE vbrk-land1
                     CHANGING gs_ctrlop TYPE ssfctrlop
                              gs_outopt TYPE ssfcompop.

  DATA: ls_itcpo     TYPE itcpo.
  DATA: lf_repid     TYPE sy-repid.
  DATA: lf_device    TYPE tddevice.
  DATA: ls_recipient TYPE swotobjid.
  DATA: ls_sender    TYPE swotobjid.

  lf_repid = sy-repid.

  CALL FUNCTION 'WFMC_PREPARE_SMART_FORM'
    EXPORTING
      pi_nast    = nast
      pi_country = is_dlv-land
*     PI_ADDR_KEY   = IS_ADDR_KEY
      pi_repid   = lf_repid
      pi_screen  = xscreen
    IMPORTING
*     PE_RETURNCODE = CF_RETCODE
      pe_itcpo   = ls_itcpo
      pe_device  = lf_device.
*            PE_RECIPIENT  = CS_RECIPIENT
*            PE_SENDER     = CS_SENDER.

  MOVE-CORRESPONDING ls_itcpo TO gs_outopt.
  gs_ctrlop-device      = lf_device.
  gs_ctrlop-no_dialog   = 'X'.
  gs_ctrlop-preview     = xscreen.
  gs_ctrlop-getotf      = ls_itcpo-tdgetotf.
  gs_ctrlop-langu       = nast-spras.
ENDFORM.                               " SET_PRINT_PARAM
*&---------------------------------------------------------------------*
*&      Form  CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear .
  REFRESH it_vbak.
  REFRESH it_vbpa.
  REFRESH it_kna1.
  REFRESH it_vbkd.
  REFRESH it_vbap.
  REFRESH it_tvzbt.
  REFRESH it_vbfa.
  REFRESH it_konv.
ENDFORM.
