*&---------------------------------------------------------------------*
*& Report ZUS_FI_BANK_RECON_REP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zindia_fi_bank_recon_rep.

TABLES:
  t012t,
  faglflexa,
  bsis.

*-----------------------------------------------------*
* types
TYPES : BEGIN OF t_skat,
          saknr TYPE skat-saknr,
          txt50 TYPE skat-txt50,
        END OF t_skat.

TYPES : BEGIN OF bseg_alv ,
          kobez TYPE bseg_alv-kobez,
          augbl TYPE bseg_alv-augbl,
        END OF bseg_alv.


TYPES: BEGIN OF t_bank,
         hbkid TYPE t012t-hbkid,
         text1 TYPE t012t-text1,
       END OF t_bank.

TYPES: BEGIN OF t_bsis,
         budat TYPE sydatum,
         zuonr TYPE bsis-zuonr,
         blart TYPE bsis-blart,
         dmbtr TYPE dmbtr,
         shkzg TYPE shkzg,
         belnr TYPE bsis-belnr,
         gjahr TYPE bsis-gjahr,
         augdt TYPE bsas-augdt,
         prctr TYPE bsis-prctr,
       END OF t_bsis.

TYPES: BEGIN OF t_code,
         butxt TYPE t001-butxt,
         bukrs TYPE t001-bukrs,
       END OF t_code.
TYPES: BEGIN OF t_final,
         srno(3),
         chq           TYPE bsis-zuonr,
         posting_dt    TYPE sydatum,
         vendor_nm(35),
         doc_no        TYPE bsis-belnr,
         doc_type      TYPE bsis-blart,
         debit_amt     TYPE bsis-dmbtr,
         credit_amt    TYPE bsis-dmbtr,
         txt50         TYPE skat-txt50,
         clear         TYPE bsas-augdt,
         prctr         TYPE bsis-prctr,

       END OF t_final.

*-----------------------------------------------------*
* internal tables & workarea

DATA : chk_no TYPE payr-chect.
DATA : chk_no1 TYPE payr-chect.

DATA : it_bseg TYPE  bseg_alv,
       wa_bseg TYPE TABLE OF bseg_alv.
DATA: w_bsis TYPE t_bsis,
      i_bsis TYPE TABLE OF t_bsis.
DATA: w_bsas TYPE t_bsis,
      i_bsas TYPE TABLE OF t_bsis.

*data: w_bsas1 type t_bsis,
*      i_bsas1 type table of t_bsis.

DATA : w_bsas1 TYPE bsas.

DATA: company_name   TYPE t001-butxt,
      house_bank(25)." TYPE t012k-text1.


DATA: i_bank TYPE TABLE OF t_bank,
      w_bank TYPE t_bank.
*DATA: dynpfields TYPE TABLE OF DYNPREAD,
*      w_dynpfields TYPE  DYNPREAD.
DATA: w_final TYPE t_final,
      i_final TYPE TABLE OF t_final.

DATA:w_code TYPE t_code,
     i_code TYPE TABLE OF t_code.
DATA: fiscal_variant(2),
      fiscal_year(4).
DATA: gl_acc  TYPE t012k-hkont,
      gl_acc1 TYPE t012k-hkont,
      gl_acc2 TYPE t012k-hkont.
DATA:balance_amount TYPE bsis-dmbtr,
     vendor         TYPE lifnr,
     kunnr          TYPE kunnr,
     hkont          TYPE hkont,
     name1          TYPE name1_gp,
     debit_amt      TYPE bsis-dmbtr,
     credit_amt     TYPE bsis-dmbtr,
     deb_cre        TYPE bsis-dmbtr,
     final_amt      TYPE bsis-dmbtr.
DATA:i_return_tab  TYPE ddshretval OCCURS 0 WITH HEADER LINE.

DATA: i_ret TYPE ddshretval OCCURS 0 WITH HEADER LINE.
*------------------------------------------------------*
*Selection screen

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: c_code  TYPE t001-bukrs OBLIGATORY,
              h_bank  TYPE t012t-hbkid OBLIGATORY, " MATCHCODE OBJECT BANK_ACCT.
              p_hktid TYPE t012k-hktid OBLIGATORY.
  PARAMETERS: date TYPE sy-datum .
*            p_prctr TYPE bsis-prctr.


*SELECT-OPTIONS: date FOR sy-datum.
SELECTION-SCREEN END OF BLOCK b1.

*------------------------------------------------------*
*AT SELECTION-SCREEN .
AT SELECTION-SCREEN ON VALUE-REQUEST FOR h_bank.
  PERFORM house_bank_help.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_hktid.
  PERFORM account_id_help.

*------------------------------------------------------*
*Top of page

*SELECT  hbkid text1  FROM t012t INTO TABLE i_bank
*                                 WHERE bukrs = c_code and
*                                       hbkid = H_bank.
*
*AT SELECTION-SCREEN on VALUE-REQUEST FOR c_code.
*  SELECT butxt bukrs  FROM t001 INTO TABLE i_code.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield    = 'X'
*      dynpprog    = sy-repid
*      dynpnr      = sy-dynnr
*      dynprofield = 'C_CODE'
*      value_org   = 'S'
*    TABLES
*      value_tab   = i_code
*      RETURN_TAB  = I_RETURN_TAB.
*
*  READ TABLE I_RETURN_TAB INDEX 1.
*  C_CODE = I_RETURN_TAB-FIELDVAL .
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR H_bank.
*  SELECT  text1 hbkid   FROM t012t INTO TABLE i_bank
*                                 WHERE bukrs = c_code ."and
**                                       hbkid = H_bank.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield    = 'X'
*      dynpprog    = sy-repid
*      dynpnr      = sy-dynnr
*      dynprofield = 'H_BANK'
*      value_org   = 'S'
*    TABLES
*      value_tab   = i_bank
*      RETURN_TAB  = I_RETURN_TAB.
*
*  READ TABLE I_RETURN_TAB INDEX 1.
*  H_bank = I_RETURN_TAB-FIELDVAL .
*
*AT SELECTION-SCREEN on VALUE-REQUEST FOR date.
*  TYPES:BEGIN OF t_date,
*        date TYPE sydatum,
*        END OF t_date.
*  DATA:i_date TYPE TABLE OF t_date.
*  SELECT budat FROM bsis INTO TABLE i_date
*                          WHERE bukrs = c_code.
*
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield    = 'X'
*      dynpprog    = sy-repid
*      dynpnr      = sy-dynnr
*      dynprofield = 'DATE'
*      value_org   = 'S'
*    TABLES
*      value_tab   = i_date
*      RETURN_TAB  = I_RETURN_TAB.
*
*  READ TABLE I_RETURN_TAB INDEX 1.
*  DATE = I_RETURN_TAB-FIELDVAL .
***  loop at i_bank INTO w_bank.
***    w_dynpfields-FIELDNAME = 'H_BANK'.
***    w_dynpfields-FIELDVALUE = w_bank-bankn.
***    APPEND  w_dynpfields to dynpfields.
***  endloop.
***  CALL FUNCTION 'DYNP_VALUES_UPDATE'
***    EXPORTING
***      DYNAME                     = 'ZFI_RECONCILIATION'
***      DYNUMB                     = '1000'
***    TABLES
***      DYNPFIELDS                 = dynpfields
****   EXCEPTIONS
****     INVALID_ABAPWORKAREA       = 1
****     INVALID_DYNPROFIELD        = 2
****     INVALID_DYNPRONAME         = 3
****     INVALID_DYNPRONUMMER       = 4
****     INVALID_REQUEST            = 5
****     NO_FIELDDESCRIPTION        = 6
****     UNDEFIND_ERROR             = 7
****     OTHERS                     = 8
***            .
***  IF SY-SUBRC <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***  ENDIF.



*TOP-OF-PAGE.
*  PERFORM header.
*------------------------------------------------------*
*Start-of-selection
START-OF-SELECTION.
  PERFORM header.
  PERFORM get_data.
  PERFORM write_data.
  PERFORM footer.
*&---------------------------------------------------------------------*
*&      Form  HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM header .
*BREAK primus.
  SELECT SINGLE butxt FROM t001 INTO company_name
  WHERE bukrs = c_code.

  SELECT SINGLE periv FROM t001 INTO fiscal_variant
  WHERE bukrs = c_code.
  CALL FUNCTION 'GM_GET_FISCAL_YEAR'
    EXPORTING
      i_date = sy-datum
      i_fyv  = fiscal_variant
    IMPORTING
      e_fy   = fiscal_year.


  SELECT SINGLE hkont FROM t012k INTO gl_acc
                           WHERE bukrs = c_code AND
                                 hbkid = h_bank AND
  hktid = p_hktid.
  gl_acc1 = gl_acc + 1.
  gl_acc2 = gl_acc + 2.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = gl_acc1
    IMPORTING
      output = gl_acc1.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = gl_acc2
    IMPORTING
      output = gl_acc2.
  DATA: a TYPE i.
  SELECT SUM( hsl ) INTO balance_amount FROM  faglflexa
                        WHERE "ryear = fiscal_year AND
                              rbukrs = c_code AND
                              budat LE date AND
  ( racct BETWEEN gl_acc AND gl_acc2 ) AND
    bstat NE 'C' AND
    rldnr = '0L'.
  .

*  SELECT SINGLE text1 FROM t012k INTO house_bank
*                             WHERE bankn = h_bank.
  SELECT  hbkid text1  FROM t012t INTO TABLE i_bank
                                   WHERE bukrs = c_code AND
  hbkid = h_bank.
  READ TABLE i_bank INTO w_bank INDEX 1.
  WRITE:/1 sy-uline(154).
  WRITE:/1 sy-vline ,40 'Bank Reconciliation Statement as on:-',date,154 sy-vline,sy-uline(154).
  WRITE:/1 sy-vline , 5 'Company Code     ',company_name,154 sy-vline.
  WRITE:/1 sy-vline , 5 'Name Of Bank     ',w_bank-text1,154 sy-vline.
  WRITE:/1 sy-vline, 154 sy-vline,sy-uline(154), 154 sy-vline.
*  skip 1.
  WRITE:1 sy-uline(139).
  DATA: balance_amount1 TYPE bsis-dmbtr.
  DATA : bala TYPE bsis-dmbtr.
  balance_amount1 = balance_amount.
  IF balance_amount1 GT 0.
    WRITE:/1 sy-vline, 10 'Balance As Per Company Bank Book ',120 balance_amount1 LEFT-JUSTIFIED,136 'DR', 154 sy-vline,sy-uline(154).
  ELSEIF balance_amount1 LT 0.
*    shift  balance_amount1 right deleting trailing '-'.

    balance_amount1 = balance_amount1 * -1.
    MOVE balance_amount1 TO bala.
    WRITE:/1 sy-vline, 10 'Balance As Per Company Bank Book ',120 balance_amount1 LEFT-JUSTIFIED ,136 'CR' ,154 sy-vline,sy-uline(154).
  ENDIF.
ENDFORM.                    " HEADER
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  DATA : date_cl TYPE bsas-augdt.
*selecting posting dt,chk no,doc type,amt in local curr,debit/credit indicator,doc no
* by putting com code,g/l acc & postin date
  SELECT budat zuonr blart dmbtr shkzg belnr gjahr augdt prctr FROM bsis INTO TABLE i_bsis
                                 WHERE bukrs EQ c_code AND
                                       ( hkont BETWEEN gl_acc1 AND gl_acc2 ) AND
                                       budat   LE date ."AND
*                                       prctr eq p_prctr.

  DATA:date1 TYPE sydatum.
  date1 = date + 1.
  SELECT budat zuonr blart dmbtr shkzg belnr gjahr augdt prctr FROM bsas INTO TABLE i_bsas
                                 WHERE bukrs EQ c_code AND
                                       ( hkont BETWEEN gl_acc1 AND gl_acc2 ) AND
                                        augdt GE date1 AND
                                        budat   LE date ."AND
*                                        prctr eq p_prctr.
* SELECT SINGLE lifnr FROM bseg INTO vendor
*                            WHERE gjahr = fiscal_year AND
*                                  belnr = i_bsis-belnr AND
*                                  koart = 'K' or
*                                  koart = 'D'.
*  SELECT dmbtr INTO (debit_amt,credit_amt) FROM bsis
*                           WHERE dmbtr
************************************************************************************************************
  LOOP AT i_bsis INTO w_bsis.
    IF ( w_bsis-belnr BETWEEN 7100001280 AND 7100001290 ) AND w_bsis-gjahr EQ 2015.
      DELETE i_bsis WHERE belnr EQ w_bsis-belnr.
    ENDIF.
    IF ( w_bsis-belnr EQ 7200004309 OR w_bsis-belnr EQ 7200004312
      OR w_bsis-belnr EQ 7200004314 OR w_bsis-belnr EQ 7200004315
      OR w_bsis-belnr EQ 7200004318 ) AND w_bsis-gjahr EQ 2014.
      DELETE i_bsis WHERE belnr EQ w_bsis-belnr.
    ENDIF.
  ENDLOOP.

  LOOP AT i_bsas INTO w_bsas.
    IF ( w_bsas-belnr BETWEEN 7100001280 AND 7100001290 ) AND w_bsis-gjahr EQ 2015.
      DELETE i_bsas WHERE belnr EQ w_bsas-belnr.
    ENDIF.
    IF ( w_bsas-belnr EQ 7200004309 OR w_bsas-belnr EQ 7200004312
      OR w_bsas-belnr EQ 7200004314 OR w_bsas-belnr EQ 7200004315
      OR w_bsas-belnr EQ 7200004318 ) AND w_bsis-gjahr EQ 2014.
      DELETE i_bsas WHERE belnr EQ w_bsas-belnr.
    ENDIF.
  ENDLOOP.
************************************************************************************************************
ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  WRITE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_data .
  WRITE:/1 sy-uline(154).
  WRITE:/1 sy-vline,
         2 'SR',
         5 sy-vline,
         6 'Posting date',19 sy-vline,
         20 '     Vendor/customer Name       ',60 sy-vline,
         61 'Cheque no',75 sy-vline,
         76 'Doc No',88 sy-vline,
         89 'Doc',93 sy-vline,
         94 'Profit Center', 109 sy-vline,
         110 'Deposits', 125 sy-vline,
         126 'Payments', 141 sy-vline,
         142 'Clearing Date',154 sy-vline.


  WRITE:/1 sy-vline,
           2 'NO.',
           5 sy-vline,
           19 sy-vline,
           60 sy-vline,
           75 sy-vline,
           88 sy-vline,
           89 'Type',
           93 sy-vline,
           109 sy-vline,
           125 sy-vline,
           141 sy-vline,
           154 sy-vline.

*          139 sy-vline.

  WRITE:/1 sy-uline(154).
  SORT i_bsis  ASCENDING BY   budat belnr.
  LOOP AT i_bsis INTO w_bsis.
*    READ TABLE i_bsis INTO w_bsis WITH KEY shkzg = 'S'.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = w_bsis-belnr
      IMPORTING
        output = w_bsis-belnr.

    SELECT SINGLE lifnr FROM bseg INTO vendor
                            WHERE gjahr = w_bsis-gjahr AND
                                  belnr = w_bsis-belnr AND
                                  bukrs = c_code AND
    koart = 'K' .

    SELECT SINGLE kunnr FROM bseg INTO kunnr
                            WHERE gjahr = w_bsis-gjahr AND
                                  belnr = w_bsis-belnr AND
                                  bukrs = c_code AND
    koart = 'D' .

    SELECT SINGLE hkont  FROM bseg INTO hkont
                             WHERE gjahr = w_bsis-gjahr AND
                                   belnr = w_bsis-belnr AND
    bukrs = c_code AND hkont NE gl_acc1 AND hkont NE gl_acc2.

    SELECT SINGLE name1 FROM lfa1 INTO name1
    WHERE lifnr = vendor.
    IF sy-subrc NE 0.
      SELECT SINGLE name1 FROM kna1 INTO name1
      WHERE kunnr = kunnr.
    ENDIF.
    IF sy-subrc NE 0.
      SELECT SINGLE txt20 FROM skat INTO name1
      WHERE saknr  = hkont AND ktopl = '1000'.
    ENDIF.
    w_final-srno = sy-tabix.
    SELECT SINGLE chect FROM payr INTO chk_no WHERE vblnr EQ w_bsis-belnr AND gjahr EQ w_bsis-gjahr.
    IF sy-subrc EQ 0.
      w_final-chq = chk_no.
    ELSE.
      w_final-chq = w_bsis-zuonr.
    ENDIF.
    w_final-posting_dt = w_bsis-budat.
    w_final-doc_no = w_bsis-belnr.
*    SELECT SINGLE * from bsas INTO w_bsas1  where bukrs = c_code and belnr = w_final-doc_no .
**    SELECT  SINGLE augdt  from bsas INTO clear
**                                        where bukrs = c_code and belnr = w_bsis-belnr ."and
**                                       ( hkont between gl_acc1 and gl_acc2 ).
*    w_final-clear  = w_bsas1-augdt.
    w_final-doc_type = w_bsis-blart.
    w_final-vendor_nm = name1.
    IF w_bsis-shkzg = 'S'." or w_bsis-shkzg = 'H'.
      w_final-debit_amt = w_bsis-dmbtr.
    ELSEIF w_bsis-shkzg = 'H'.
      w_final-credit_amt = w_bsis-dmbtr.
    ENDIF.

    IF w_bsis-prctr IS NOT INITIAL.
      w_final-prctr = w_bsis-prctr.
    ELSE.
*      SELECT SINGLE prctr FROM acdoca INTO w_final-prctr WHERE belnr = w_bsis-belnr AND gjahr = w_bsis-gjahr.
    ENDIF.


    APPEND w_final TO i_final.
    CLEAR:w_final,w_bsis,vendor,kunnr,name1, chk_no.
  ENDLOOP.

  SORT i_bsas  ASCENDING BY   budat belnr.
  LOOP AT i_bsas INTO w_bsas.
*    READ TABLE i_bsis INTO w_bsis WITH KEY shkzg = 'S'.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = w_bsas-belnr
      IMPORTING
        output = w_bsas-belnr.

    SELECT SINGLE lifnr FROM bseg INTO vendor
                            WHERE gjahr = w_bsas-gjahr AND
                                  belnr = w_bsas-belnr AND
                                  bukrs = c_code AND
    koart = 'K' .

    SELECT SINGLE kunnr FROM bseg INTO kunnr
                            WHERE gjahr = w_bsas-gjahr AND
                                  belnr = w_bsas-belnr AND
                                  bukrs = c_code AND
    koart = 'D' .
    SELECT SINGLE hkont  FROM bseg INTO hkont
                            WHERE gjahr = w_bsas-gjahr AND
                                  belnr = w_bsas-belnr AND
    bukrs = c_code AND hkont NE gl_acc1 AND hkont NE gl_acc2.


    SELECT SINGLE name1 FROM lfa1 INTO name1
    WHERE lifnr = vendor.
    IF sy-subrc NE 0.
      SELECT SINGLE name1 FROM kna1 INTO name1
      WHERE kunnr = kunnr.
    ENDIF.
    IF sy-subrc NE 0.
      SELECT SINGLE txt20 FROM skat INTO name1
      WHERE saknr  = hkont AND ktopl = '1000'.
    ENDIF.
    w_final-srno = sy-tabix.
    SELECT SINGLE chect FROM payr INTO chk_no1 WHERE vblnr EQ w_bsas-belnr AND gjahr EQ w_bsas-gjahr.
    IF sy-subrc EQ 0.
      w_final-chq = chk_no1.
    ELSE.
      w_final-chq = w_bsas-zuonr.
    ENDIF.
*    w_final-chq = w_bsas-zuonr.
    w_final-posting_dt = w_bsas-budat.
    w_final-doc_no = w_bsas-belnr.
    w_final-doc_type = w_bsas-blart.
    w_final-vendor_nm = name1.
    IF w_bsas-shkzg = 'S'." or w_bsis-shkzg = 'H'.
      w_final-debit_amt = w_bsas-dmbtr.
    ELSEIF w_bsas-shkzg = 'H'.
      w_final-credit_amt = w_bsas-dmbtr.
    ENDIF.
    SELECT SINGLE * FROM bsas INTO w_bsas1  WHERE bukrs = c_code AND belnr = w_final-doc_no AND gjahr = w_bsas-gjahr .
    w_final-clear  = w_bsas1-augdt.
    IF w_bsas-prctr IS NOT INITIAL.
      w_final-prctr = w_bsas-prctr.
    ELSE.
*      SELECT SINGLE prctr FROM acdoca INTO w_final-prctr WHERE belnr = w_bsas-belnr AND gjahr = w_bsas-gjahr.
    ENDIF.

    APPEND w_final TO i_final.
    CLEAR:w_final,w_bsas,vendor,kunnr,name1 , chk_no , chk_no1.
  ENDLOOP.
*  sort i_final ASCENDING by   posting_dt doc_no.
  LOOP AT i_final INTO w_final.
    w_final-srno = sy-tabix.
*  modify i_final FROM w_final TRANSPORTING srno.
    WRITE:/1 sy-vline,2 w_final-srno,5 sy-vline,
               6 w_final-posting_dt,19 sy-vline,
               20 w_final-vendor_nm,60 sy-vline,
               61 w_final-chq,75 sy-vline,
               76 w_final-doc_no, 88 sy-vline ,
               89 w_final-doc_type,93 sy-vline,
               94 w_final-prctr,109 sy-vline,
               110 w_final-debit_amt LEFT-JUSTIFIED,125 sy-vline,
               126 w_final-credit_amt LEFT-JUSTIFIED,141 sy-vline,
               142 w_final-clear, 154 sy-vline.
*            140 sy-vline.

*    WRITE:/1 sy-vline,2 w_final-srno,5 sy-vline,
*           6 w_final-posting_dt,19 sy-vline,
*           20 w_final-vendor_nm,60 sy-VLINE,
*           61 w_final-chq,75 sy-vline,
*           76 w_final-doc_type, 84 sy-vline ,
*           85 w_final-debit_amt,110 sy-vline,
*           111 w_final-credit_amt,
*           134 sy-vline,
*           135 w_final-doc_no.

    AT LAST.
      WRITE:/1 sy-uline(154).
      SUM.
      WRITE:/1 sy-vline, 30 'Amount Not Refelected in Bank', 110 w_final-debit_amt LEFT-JUSTIFIED ,
         126 w_final-credit_amt LEFT-JUSTIFIED,154 sy-vline.
      debit_amt = w_final-debit_amt.
      credit_amt = w_final-credit_amt.
      deb_cre = w_final-debit_amt - w_final-credit_amt.
      WRITE:/1 sy-uline(154).
*      final_amt = balance_amount - deb_cre.
*      WRITE:/30 'Balance As Per Bank Statement',85 deb_cre,134 sy-VLINE.
    ENDAT.
  ENDLOOP.
*  data:final_amt1 TYPE bsis-dmbtr.
*  final_amt1 = final_amt.
*  write:/1 sy-uline(125).
*  skip 1.
*  write:/1 sy-uline(125).
*  if final_amt gt 0.
*    write:/1 sy-vline, 30 'Balance As Per Bank Statement',105 final_amt1,121 'DR',125 sy-vline .
*  elseif final_amt lt 0.
**    shift  final_amt1 right deleting trailing '-'.
*    final_amt1 = final_amt1 * -1.
*    write:/1 sy-vline, 30 'Balance As Per Bank Statement',105 final_amt1,121 'CR',125 sy-vline .
*  endif.
*  write:/1 sy-uline(125).


ENDFORM.                    " WRITE_DATA

FORM footer.
  final_amt = balance_amount - deb_cre.
  DATA:final_amt1 TYPE bsis-dmbtr.
  final_amt1 = final_amt.
*  write:/1 sy-uline(125).
  SKIP 1.
  WRITE:/1 sy-uline(154).
  IF final_amt GT 0.
    WRITE:/1 sy-vline, 30 'Balance As Per Bank Statement',120 final_amt1 LEFT-JUSTIFIED,137 'CR',154 sy-vline .
  ELSEIF final_amt LT 0.
*    shift  final_amt1 right deleting trailing '-'.
    final_amt1 = final_amt1 * -1.
    WRITE:/1 sy-vline, 30 'Balance As Per Bank Statement',120 final_amt1 LEFT-JUSTIFIED,137 'DR',154 sy-vline .
  ENDIF.
  WRITE:/1 sy-uline(154).

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  HOUSE_BANK_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM house_bank_help .
  TYPES: BEGIN OF t_hb,
           bukrs TYPE t012-bukrs,
           hbkid TYPE t012-hbkid,
           text  TYPE t012t-text1,
         END OF t_hb.

  DATA: i_hb TYPE TABLE OF t_hb.
  DATA: bukrs TYPE bsis-bukrs.

  DATA i_dyn TYPE dynpread OCCURS 0 WITH HEADER LINE.

  i_dyn-fieldname = 'C_CODE'.
  APPEND i_dyn.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-repid
      dynumb     = sy-dynnr
    TABLES
      dynpfields = i_dyn.

  READ TABLE i_dyn INDEX 1.
  IF sy-subrc = 0.
    bukrs = i_dyn-fieldvalue.
  ENDIF.

*  select a~bukrs a~hbkid b~text1 into table i_hb from t012 as a inner join t012t as b on a~bukrs = b~bukrs
*  where a~bukrs = bukrs and b~spras = 'EN'.

**** Sujata
  SELECT bukrs hbkid text1 INTO TABLE i_hb FROM t012t " as a inner join t012t as b on a~bukrs = b~bukrs
  WHERE bukrs = bukrs.

  REFRESH : i_ret.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield    = 'HBKID'
*     PVALKEY     = ' '
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'H_BANK'
      value_org   = 'S'
    TABLES
      value_tab   = i_hb
      return_tab  = i_ret.

  READ TABLE i_ret INDEX 1.
  h_bank = i_ret-fieldval.

ENDFORM.                    " HOUSE_BANK_HELP

*&---------------------------------------------------------------------*
*&      Form  ACCOUNT_ID_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM account_id_help .
  TYPES: BEGIN OF t_accid,
           hbkid TYPE t012-hbkid,
           htkid TYPE t012k-hktid,
*    bankn  type t012k-bankn,
         END OF t_accid.

  DATA: i_accid TYPE TABLE OF t_accid.
  DATA: comp  TYPE bsis-bukrs,
        bank  TYPE t012-hbkid,
        hbank TYPE t012-hbkid.

  DATA i_dyn TYPE dynpread OCCURS 0 WITH HEADER LINE.

  i_dyn-fieldname = 'C_CODE'.
  APPEND i_dyn.

  i_dyn-fieldname = 'H_BANK'.
  APPEND i_dyn.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-repid
      dynumb     = sy-dynnr
    TABLES
      dynpfields = i_dyn.

  READ TABLE i_dyn INDEX 1.
  IF sy-subrc = 0.
    comp = i_dyn-fieldvalue.
  ENDIF.
  READ TABLE i_dyn INDEX 2.
  IF sy-subrc = 0.
    hbank = i_dyn-fieldvalue.
  ENDIF.

  SELECT a~hbkid b~hktid INTO TABLE i_accid FROM t012 AS a INNER JOIN t012k AS b
  ON a~bukrs = b~bukrs AND a~hbkid = b~hbkid
  WHERE a~bukrs = comp AND a~hbkid = hbank.
  REFRESH : i_ret.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield    = 'HKTID'
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'P_HKTID'
      value_org   = 'S'
    TABLES
      value_tab   = i_accid
      return_tab  = i_ret.

  READ TABLE i_ret INDEX 1.
  p_hktid = i_ret-fieldval.

ENDFORM.                    " ACCOUNT_ID_HELP
