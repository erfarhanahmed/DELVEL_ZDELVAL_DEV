*&---------------------------------------------------------------------*
*& Report ZFI_VOUCHER_PRINT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_voucher_print NO STANDARD PAGE HEADING
                            LINE-COUNT 65
                            LINE-SIZE 132
                            MESSAGE-ID zdel.

TABLES : payr,  tgsb, cskt, cepct, prps, vbkpf, bkpf,
         t001, vbsegs, bseg, skat, kna1, bsis, lfa1.

TYPES : BEGIN OF t_bkpf,
          bukrs      LIKE bkpf-bukrs,
          gjahr      LIKE bkpf-gjahr,
          belnr      LIKE bkpf-belnr,
          bldat      LIKE bkpf-bldat,
          budat      LIKE bkpf-budat,
          monat      LIKE bkpf-monat,
          tcode      LIKE bkpf-tcode,
          waers      LIKE bkpf-waers,
          xblnr      LIKE bkpf-xblnr,
          kursf      LIKE bkpf-kursf,
          hwaer      LIKE bkpf-hwaer,
          usnam      LIKE bkpf-usnam,
          cpudt      LIKE bkpf-cpudt,
          bktxt      LIKE bkpf-bktxt,    "Document Header Text
          blart      LIKE bkpf-blart,    "Document Type
          bvorg      LIKE bkpf-bvorg,    "Inter company number
          bstat      LIKE bkpf-bstat,
          flag001(2) TYPE c,
          kostl      LIKE bseg-kostl,
          gsber      LIKE bseg-gsber,
        END OF t_bkpf,

        BEGIN OF t_bseg,
          belnr     LIKE bseg-belnr,
          shkzg     LIKE bseg-shkzg,
          bschl(3)  TYPE c, "like bseg-bschl,
          hkont     LIKE bseg-hkont,
          gsber     LIKE bseg-gsber,
          wrbtr     LIKE bseg-wrbtr,
          pswsl     LIKE bseg-pswsl,
          dmbtr     LIKE bseg-dmbtr,
          sgtxt     LIKE bseg-sgtxt,
          prctr     LIKE bseg-prctr,
          projk     LIKE bseg-projk,
          kostl     LIKE bseg-kostl,
          aufnr     LIKE bseg-aufnr,
          koart     LIKE bseg-koart,
          lifnr     LIKE bseg-lifnr,
          kunnr     LIKE bseg-kunnr,
          zuonr     LIKE bseg-zuonr,
          txt50     LIKE skat-txt50,
          name1(70) TYPE c,
          pargb     LIKE bseg-pargb,
          bukrs     LIKE bseg-bukrs,
          gjahr     LIKE bseg-gjahr,
          umskz     LIKE bseg-umskz,
          mctxt     LIKE cskt-mctxt,
          pmctxt    LIKE cepct-mctxt,
          post1     LIKE prps-post1,
          pswbt     LIKE bseg-pswbt,
          matnr     LIKE bseg-matnr,
          ebeln     LIKE bseg-ebeln,
          buzei     LIKE bseg-buzei,
          zterm     LIKE bseg-zterm,
          werks     TYPE werks_d,
          tbtkz	    TYPE tbtkz,     "	Indicator: Subsequent Debit/Credit
        END OF t_bseg,


        BEGIN OF t_doc,
          belnr LIKE bseg-belnr,
        END OF t_doc.


DATA : bkpftab TYPE TABLE OF t_bkpf,   "internal table for bkpf data
       bsegtab TYPE TABLE OF t_bseg,   "internal table for bseg data
       doctab  TYPE TABLE OF t_doc.    "internal table for doc. nos.


DATA  :   w_mark      VALUE 'X'.
DATA : bkpfw       TYPE t_bkpf,
       bsegw       TYPE t_bseg,
       docw        TYPE t_doc,    "internal table for doc. nos.
       w_bkpf      LIKE bkpf,
       w_bseg      LIKE bseg,
       w_flag,
       w_bstat     LIKE bkpf-bstat,
       lv_doc_type TYPE char32.

DATA : dr_tot           LIKE glt0-tslvt, "total of debit amts in voucher
       cr_tot           LIKE glt0-tslvt, "total of credit amts in voucher
       signed_dmbtr(15),       "to store signed amounts(LC)
       signed_wrbtr(15),       "to store signed amounts(FC)
       valid_doc(5),           "flag to indicate valid doc. no.
       error_found(5).         "flag to indicate error in input

DATA : zdr_cr(2),
       zschemetext LIKE t001-butxt,
       zcheck_no   LIKE payr-chect,
       zcheck_date LIKE payr-zaldt.


DATA  : BEGIN OF t_adrc OCCURS 0,
          name1      LIKE adrc-name1,
          city1      LIKE adrc-city1,
          post_code1 LIKE adrc-post_code1,
          street     LIKE adrc-street,
          house_num1 LIKE adrc-house_num1,
          name2      LIKE adrc-name2,
        END OF t_adrc.

DATA  : w_str1(060),
        w_str2(060),
        w_str3(060),
        w_str4(060),
        w_str5(060).

CONSTANTS : posted  TYPE c VALUE 'X',
            parked  TYPE c VALUE 'X',
            deleted TYPE c VALUE 'X',
            c_x     TYPE c VALUE 'X'.

DATA  : gt_gltext TYPE TABLE OF zfi_gltext,
        gw_gltext TYPE zfi_gltext.

* controls for smartform printing multiple times
DATA:gs_con_settings  TYPE ssfctrlop.          "Control Settings for Smart forms

* Selection screen

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS :  rbukrs FOR  bkpf-bukrs    NO-EXTENSION NO INTERVALS OBLIGATORY,
                  rgsber FOR  w_bseg-gsber  NO-DISPLAY.
PARAMETERS     :  rgjahr LIKE bkpf-gjahr    OBLIGATORY .
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS:
*                rblart   FOR  bkpf-blart OBLIGATORY,
*                RBELNR   FOR  BKPF-BELNR MATCHCODE OBJECT YMSH OBLIGATORY,
                rbelnr   FOR  bkpf-belnr  OBLIGATORY,
                rbudat   FOR  bkpf-budat,
                rbktxt   FOR  bkpf-bktxt NO-DISPLAY,
                p_date   FOR  bkpf-budat NO-DISPLAY,
                e_date   FOR  bkpf-cpudt NO-DISPLAY,
                rusnam   FOR  bkpf-usnam . "NO-DISPLAY.
PARAMETERS: p_report AS CHECKBOX DEFAULT 'X'.

SELECTION-SCREEN : END OF BLOCK b2.

*SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
*PARAMETERS: pr_cr RADIOBUTTON GROUP g1,
*            pr_cp RADIOBUTTON GROUP g1,
*            pr_br RADIOBUTTON GROUP g1,
*            pr_bp RADIOBUTTON GROUP g1,
*            pr_dn RADIOBUTTON GROUP g1,
*            pr_cn RADIOBUTTON GROUP g1,
*            pr_jv RADIOBUTTON GROUP g1,
*            pr_ex RADIOBUTTON GROUP g1,
*            pr_as RADIOBUTTON GROUP g1.
*SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-003.
PARAMETERS pr_pdf AS CHECKBOX.
PARAMETERS:  p_input LIKE rlgrap-filename . "OBLIGATORY. " Input File

SELECTION-SCREEN END OF BLOCK b4.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_input.

  DATA: f_file LIKE ibipparms-path.

*  IF pr_pdf = 'X'.

  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = f_file.
  p_input = f_file.


AT SELECTION-SCREEN .
  IF rgsber-low NE ' '.
    LOOP AT rgsber.
      SELECT SINGLE * FROM tgsb WHERE gsber = rgsber-low.
      IF sy-subrc <> 0.
*        MESSAGE I013.
        MESSAGE i011 WITH 'Enter Valid Business Area'.
        STOP.
      ENDIF.
    ENDLOOP.
  ENDIF.

**Check For Valid Business  Area.
  IF rgsber-high NE ' '.
    LOOP AT rgsber.
      SELECT SINGLE * FROM tgsb WHERE gsber = rgsber-high.
      IF sy-subrc <> 0.
*        MESSAGE I013.
        MESSAGE i011 WITH 'Enter Valid Business Area'.
        STOP.
      ENDIF.
    ENDLOOP.
  ENDIF.

**Check For Valid Company Code.
  IF rbukrs-low NE ' '.
    LOOP AT rbukrs.
      SELECT SINGLE * FROM t001 WHERE bukrs = rbukrs-low.
      IF sy-subrc <> 0.
*        MESSAGE I013.
        MESSAGE i011 WITH 'Enter Valid Company Code'.
        STOP.
      ENDIF.
    ENDLOOP.
  ENDIF.
**Check For Valid Company Code.
  IF rbukrs-high NE ' '.
    LOOP AT rbukrs.
      SELECT SINGLE * FROM t001 WHERE bukrs = rbukrs-high.
      IF sy-subrc <> 0.
*        MESSAGE I013.
        MESSAGE i011 WITH 'Enter Valid Company Code'.
        STOP.
      ENDIF.
    ENDLOOP.
  ENDIF.
**Check For Valid Document number.
  IF rbelnr-low NE ' '.
    LOOP AT rbelnr.
      SELECT SINGLE * FROM bkpf WHERE belnr = rbelnr-low.   "#EC *
      IF sy-subrc <> 0.
*        MESSAGE I013.
        MESSAGE i011 WITH 'Enter Valid Document Number'.
        STOP.
      ENDIF.
    ENDLOOP.
  ENDIF.

**Check For Valid Document number.
  IF rbelnr-high NE ' '.
    LOOP AT rbelnr.
      SELECT SINGLE * FROM bkpf WHERE belnr = rbelnr-high.  "#EC *
      IF sy-subrc <> 0.
*        MESSAGE I013.
        MESSAGE i011 WITH 'Enter Valid Document Number'.
        STOP.
      ENDIF.
    ENDLOOP.
  ENDIF.


  IF posted = 'X' OR parked = 'X' OR deleted = 'X'.
    SELECT SINGLE bstat FROM bkpf INTO w_bstat
                  WHERE bukrs IN rbukrs AND belnr IN rbelnr. "#EC *
    IF ( w_bstat = ' ' AND posted <> 'X') OR ( w_bstat = 'Z' AND deleted <> 'X') OR ( w_bstat = 'V' AND parked <> 'X').
      MESSAGE e013.
    ENDIF.
  ENDIF.


**************************************************************************************************************
*  IF pr_cr = 'X'.
*
*    SELECT SINGLE * FROM bkpf INTO w_bkpf WHERE belnr IN rbelnr. "#EC *
*
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
*      SELECT SINGLE * FROM bseg INTO w_bseg
*             WHERE bukrs IN rbukrs AND belnr IN rbelnr .                         "#EC *
*
*      IF sy-subrc = 4.
*        MESSAGE e014.
*      ELSE.
*        w_flag = '1'.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*  IF pr_cp = 'X'.
*
*    SELECT SINGLE * FROM bkpf INTO w_bkpf WHERE  belnr IN rbelnr. "#EC *
*
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
*
*      SELECT SINGLE * FROM bseg INTO w_bseg
*                  WHERE bukrs IN rbukrs AND belnr IN rbelnr. "#EC *
*      IF sy-subrc = 4.
*        MESSAGE e014.
*      ELSE.
*        w_flag = '2'.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*  IF pr_br = 'X'.
*    SELECT SINGLE * FROM bkpf INTO w_bkpf WHERE  belnr IN rbelnr. "#EC *
*
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
*      SELECT SINGLE * FROM bseg INTO w_bseg
*              WHERE bukrs IN rbukrs AND belnr IN rbelnr .
*
*      IF sy-subrc = 0.
*        w_flag = '3'.
*
*      ELSE.
*        MESSAGE e014.
*        EXIT.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*  IF pr_bp = 'X'.
*    SELECT SINGLE * FROM bkpf INTO w_bkpf WHERE  belnr IN rbelnr .
*
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
*
*      IF parked NE 'X'.         "..............................................................
*
*        SELECT SINGLE * FROM bseg INTO w_bseg
*                WHERE bukrs IN rbukrs AND belnr IN rbelnr .
*      ENDIF.
*
*      IF sy-subrc = 0.
*        w_flag = '4'.
*      ELSE.
*        MESSAGE e014.
*      ENDIF.
*
*    ENDIF.
*  ENDIF.
*  IF pr_dn = 'X'.
*    SELECT SINGLE * FROM bkpf INTO w_bkpf
*              WHERE  belnr IN rbelnr .
*
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
*      w_flag = '5'.
*    ENDIF.
*  ENDIF.
*  IF pr_cn = 'X'.
*    SELECT SINGLE * FROM bkpf INTO w_bkpf
*                  WHERE  belnr IN rbelnr.
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
*      w_flag = '6'.
*    ENDIF.
*  ENDIF.
*  IF pr_jv = 'X'.
*    SELECT SINGLE * FROM bkpf INTO w_bkpf
*                    WHERE belnr IN rbelnr.
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
** Start of change by Teena Philip 28/12/2010*
*      SELECT SINGLE * FROM bseg INTO w_bseg
*             WHERE bukrs IN rbukrs
*                   AND belnr IN rbelnr .
*        IF sy-subrc = 4.
*        MESSAGE e014.
*      ELSE.
*       w_flag = '7'.
*      ENDIF.
** End of change by Teena Philip 28/12/2010*
*
*    ENDIF.
*  ENDIF.
*  IF pr_ex = 'X'.
*    SELECT SINGLE * FROM bkpf INTO w_bkpf
*                    WHERE belnr IN rbelnr.
*    IF sy-subrc = 4.
*      MESSAGE e014.
*      EXIT.
*    ELSE.
*      w_flag = '8'.
*    ENDIF.
*  ENDIF.

  CLEAR : w_bkpf, w_bseg, w_flag.
  SELECT SINGLE * FROM bkpf INTO w_bkpf WHERE  belnr IN rbelnr .
  IF sy-subrc = 4.
    MESSAGE e014.
  ELSE.

    IF parked NE 'X'.
      SELECT SINGLE * FROM bseg INTO w_bseg WHERE bukrs IN rbukrs AND belnr IN rbelnr .
      IF sy-subrc = 0.
*        CASE 'X'. " following block no more required.
*          WHEN pr_cr.    w_flag = '1'.
*          WHEN pr_cp.    w_flag = '2'.
*          WHEN pr_br.    w_flag = '3'.
*          WHEN pr_bp.    w_flag = '4'.
*          WHEN pr_dn.    w_flag = '5'.
*          WHEN pr_cn.    w_flag = '6'.
*          WHEN pr_jv.    w_flag = '7'.
*          WHEN pr_ex.    w_flag = '8'.
*          WHEN pr_as.    w_flag = '9'.
*        ENDCASE.
      ELSE.
        MESSAGE e014.
      ENDIF.
    ENDIF.
  ENDIF.
**********************************************************************************************
  SELECT name1
         city1
         post_code1
         street
         house_num1
         name2
  INTO TABLE t_adrc
  FROM adrc
  INNER JOIN t001 ON adrc~addrnumber = t001~adrnr
  WHERE bukrs = rbukrs-low.


AT USER-COMMAND.
  CASE sy-ucomm.
    WHEN 'SMARTFORM'.

      PERFORM display_smartform.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE SCREEN.
  ENDCASE.

START-OF-SELECTION.

*  SET PF-STATUS 'ZGUI'.
  READ TABLE t_adrc INDEX 1.
  MOVE: t_adrc-name1 TO w_str1.

  CASE w_bkpf-blart.
    WHEN 'KZ'.
      lv_doc_type = 'CASH PAYMENT'.
    WHEN 'DZ'.
      lv_doc_type = 'CASH RECEIPT'.
    WHEN 'BR'.
      lv_doc_type = 'BANK RECEIPT'. "'CONTRA VOUCHER'.
    WHEN 'BP'.
      lv_doc_type = 'BANK PAYMENT'.
*    WHEN 'DG'.
*      lv_doc_type = 'DEBIT NOTE'.
*    WHEN 'KG'.
*      lv_doc_type = 'CREDIT NOTE'.
    WHEN 'DG'.
      lv_doc_type = 'CREDIT NOTE'.
    WHEN 'DR'.
      lv_doc_type = 'DEBIT NOTE'.
    WHEN 'KG'.
      lv_doc_type = 'DEBIT NOTE'.
    WHEN 'KR'.
      lv_doc_type = 'CREDIT NOTE'.
*    WHEN 'JV'.
*      lv_doc_type = 'JOURNAL VOUCHER'.
    WHEN 'SA'.
      lv_doc_type = 'JOURNAL VOUCHER'.
    WHEN 'RE'.
      lv_doc_type = 'EXPENSE VOUCHER'.
    WHEN 'AA'.
      lv_doc_type = 'ASSET PURCHASES'.
  ENDCASE.


  error_found = 'true'.
  WHILE error_found = 'true'.
    PERFORM validate-input.
  ENDWHILE.

*if document no. is not specified, create voucher for posting date
  IF rbelnr-low = 0.
    PERFORM process-for-posting-date.
  ELSE.
*if document no. is mentioned, create voucher for document no.(or range)
    PERFORM process-for-document-no.
*subroutine for displaying voucher format in table form on screen
    PERFORM display-voucher-data.
*subroutine for displaying the signatures of requisite authorities
*PERFORM WRITE_SIGNATURE_BAR.
  ENDIF.


END-OF-SELECTION.

TOP-OF-PAGE.
  DATA: nxtfy(4).
  nxtfy = rgjahr + 1.

*  IF pr_cn EQ 'X'.
*    SKIP 10.
*  ELSE.

  READ TABLE t_adrc INDEX 1.

  MOVE: t_adrc-name1 TO w_str1,
        t_adrc-name2 TO w_str2.
  CONCATENATE 'April' rgjahr 'March'  nxtfy INTO w_str3
                                            SEPARATED BY space.
*
*  WRITE:/40 w_str1 CENTERED INTENSIFIED COLOR COL_HEADING ,
*        /40 w_str2 CENTERED INTENSIFIED COLOR COL_HEADING ,
*        /40 w_str3 CENTERED INTENSIFIED COLOR COL_HEADING ,
*
*         127 sy-pagno.
*
*  SKIP.
**  ENDIF.
*  ULINE.
*  WRITE : / .

**  WRITE : /5 'Doc. No.      : ', bkpftab-bukrs, '/',bkpftab-belnr,
**          95 'Posting Date  : ', bkpftab-budat. "ASDEVK900376
*  CASE w_mark.
*    WHEN pr_cr.
*      IF w_flag = '1'.
*        WRITE : 54 'CASH RECEIPT'.
*        lv_doc_type = 'CASH RECEIPT'.
*      ENDIF.
*    WHEN pr_cp.
*      IF w_flag = '2'.
*        WRITE : 54 'CASH PAYMENT'.
*        lv_doc_type = 'CASH PAYMENT'.
*      ENDIF.
*
*    WHEN pr_br.
*      IF w_flag = '3'.
*        WRITE : 54 'BANK RECEIPT'.  "'CONTRA VOUCHER'.
*        lv_doc_type = 'BANK RECEIPT'.  "'CONTRA VOUCHER'.
*      ENDIF.
*    WHEN pr_bp.
*      IF w_flag = '4'.
*        WRITE : 54 'BANK PAYMENT'.
*        lv_doc_type = 'BANK PAYMENT'.
*      ENDIF.
*    WHEN pr_dn.
*      IF w_flag = '5'.
*        WRITE : 54 'DEBIT NOTE'.
*        lv_doc_type = 'DEBIT NOTE'.
*      ENDIF.
*    WHEN pr_cn.
*      IF w_flag = '6'.
*        WRITE : 54 'CREDIT NOTE'.
*        lv_doc_type = 'CREDIT NOTE'.
*
*      ENDIF.
*    WHEN pr_jv.
*      IF w_flag = '7'.
*        WRITE : 54 'JOURNAL VOUCHER'.
*        lv_doc_type = 'JOURNAL VOUCHER'.
*
*      ENDIF.
*    WHEN pr_ex.
*      IF w_flag = '8'.
*        WRITE : 54 'PURCHASE / EXPENSE VOUCHER'.
*        lv_doc_type = 'PURCHASE / EXPENSE VOUCHER'.
*
*      ENDIF.
*
*  ENDCASE.
*  SKIP.
*  ULINE.
*  SKIP.



******************** End of Program ************************************



*validation subroutine for all the input field values
** INCLUDE ymp_fi_voucher_prin_inc3_val.
***Start of Include-2******************************************
*&---------------------------------------------------------------------*
*&  Include           YMP_FI_VOUCHER_PRINT_INC3_VAL
*&  Validation subroutine for user input
*&---------------------------------------------------------------------*


FORM validate-input.
  error_found = 'false'.      "added shanu
ENDFORM.                    "VALIDATE-INPUT

***End of Include-2********************************************




*subroutine for creating the format for a voucher given the document no.
** INCLUDE ymp_fi_voucher_print_inc2_for1.
***Start of Include-3******************************************
*&---------------------------------------------------------------------*
*&  Include           YMP_FI_VOUCHER_PRINT_INC2_FOR1
*&---------------------------------------------------------------------*
*&      Form  PROCESS-FOR-DOCUMENT-NO
*&---------------------------------------------------------------------*
*subroutine for creating the format for a voucher given the document no.

FORM process-for-document-no.
  DATA w_zuonr LIKE bseg-zuonr.
*selecting line item headers from bkpf according to user input
*and storing them in bkpftab
*  SELECT * FROM  bkpf
*         WHERE bukrs IN rbukrs
*         AND   belnr IN rbelnr
*         AND   gjahr EQ rgjahr
**         AND   blart IN rblart       "Added Shanu
*         AND   usnam IN rusnam
*         AND   budat IN p_date.
*    MOVE-CORRESPONDING bkpf TO bkpfw.
*    APPEND bkpfw TO bkpftab.
*  ENDSELECT.

  SELECT * FROM  bkpf
    INTO CORRESPONDING FIELDS OF TABLE bkpftab
         WHERE bukrs IN rbukrs
         AND   belnr IN rbelnr
         AND   gjahr EQ rgjahr
*         AND   blart IN rblart       "Added Shanu
         AND   usnam IN rusnam
         AND   budat IN p_date.




  IF sy-subrc = 0.     "if line item headers exist in bkpf
    LOOP AT bkpftab INTO bkpfw.   "for each such header, select all line items from
      CLEAR zcheck_no .
      IF bkpfw-bstat = 'V'.    "If Document parked
        SELECT *
          FROM vbkpf
          INTO CORRESPONDING FIELDS OF bkpfw
          WHERE bukrs = bkpfw-bukrs
            AND belnr = bkpfw-belnr
            AND gjahr = bkpfw-gjahr
            AND blart = bkpfw-blart
            AND usnam = bkpfw-usnam
            AND budat = bkpfw-budat.                        " 20/07/99

        ENDSELECT.
        IF sy-subrc EQ 0.
          MODIFY bkpftab FROM bkpfw.
        ENDIF.

        SELECT * FROM  vbsegs        "vbsegs for line item data
               WHERE belnr = bkpfw-belnr AND
                     gjahr = bkpfw-gjahr AND
                     bukrs = bkpfw-bukrs AND
                     gsber IN rgsber.
          MOVE-CORRESPONDING vbsegs TO bsegw.
          MOVE vbsegs-saknr TO bsegw-hkont.
          APPEND bsegw TO bsegtab.
        ENDSELECT.
        IF sy-subrc <> 0.
          IF bkpfw-bstat <> 'Z'.
            DELETE bkpftab FROM bkpfw.
            CONTINUE.
          ENDIF.
        ENDIF.
      ELSEIF
        bkpfw-bstat = 'Z'.    "Parked doc deleted.
        bkpfw-flag001 = 'X'.  "'x'
        MODIFY bkpftab FROM bkpfw.
      ELSE.
        SELECT * FROM  bseg              "bseg
               WHERE belnr = bkpfw-belnr AND
                     gjahr = bkpfw-gjahr AND
                     gsber IN rgsber AND          "+SM03091999
                     bukrs = bkpfw-bukrs .
          MOVE-CORRESPONDING bseg TO bsegw.
          APPEND bsegw TO bsegtab.
        ENDSELECT.
        IF sy-subrc <> 0.
          IF bkpfw-bstat <> 'Z'.
            DELETE bkpftab FROM bkpfw.
            CONTINUE.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

*for each account no. appearing in bsegtab, text explaining the nature
*of the account is picked up from skat, and stored in a separate field
    LOOP AT bsegtab INTO bsegw.
      CASE bsegw-koart.
        WHEN 'S'.
          SELECT SINGLE * FROM skat
                 WHERE saknr = bsegw-hkont
                   AND spras = 'EN'
                   AND ktopl = t001-ktopl.    "added by bhumika
*                   AND ktopl = 'IAS'.    "commented by HarishR
          bsegw-txt50 = skat-txt50.
          MODIFY bsegtab FROM bsegw.
        WHEN 'K'.
          SELECT SINGLE * FROM lfa1
                 WHERE lifnr = bsegw-lifnr.

          gw_gltext-lifnr = lfa1-lifnr.
          gw_gltext-adrnr = lfa1-adrnr.
          CONCATENATE  lfa1-name1 lfa1-name2
                       INTO gw_gltext-text70
                       SEPARATED BY space.    "added by bhumika
          APPEND gw_gltext TO gt_gltext.
          CLEAR gw_gltext.
*          bsegtab-name1 = lfa1-name1.
*          MODIFY bsegtab.
        WHEN 'A'.
          SELECT SINGLE * FROM skat
                 WHERE spras = 'E' AND
                       saknr = bsegw-hkont
                       AND ktopl = t001-ktopl. "added by bhumika
          bsegw-txt50 = skat-txt50.
          MODIFY bsegtab FROM bsegw.
        WHEN 'D'.
          SELECT SINGLE * FROM kna1
                 WHERE kunnr = bsegw-kunnr.
          gw_gltext-kunnr = kna1-kunnr.
          gw_gltext-adrnr = kna1-adrnr.
          CONCATENATE  kna1-name1 kna1-name2
                       INTO gw_gltext-text70
                       SEPARATED BY space.    "added by bhumika
          APPEND gw_gltext TO gt_gltext.
          CLEAR gw_gltext.
*          bsegtab-name1 = kna1-name1.
*          MODIFY bsegtab.
        WHEN 'M'.

          SELECT SINGLE * FROM skat
                 WHERE saknr = bsegw-hkont
                 AND ktopl = t001-ktopl.
          bsegw-txt50 = skat-txt50.         "added by bhumika
          MODIFY bsegtab FROM bsegw.

      ENDCASE.
      CLEAR  bsegw.
    ENDLOOP.
**To print the cheque no and date for Bank Receipt

*    IF pr_br = 'X' OR pr_bp = 'X'. " commented by bhumika
*                                     the Cheque/ Assignment number should come
    SELECT SINGLE zuonr INTO zcheck_no "w_zuonr
       FROM bseg
       WHERE        belnr = bkpfw-belnr AND
                    gjahr = bkpfw-gjahr AND
                    gsber IN rgsber AND
                    bukrs = bkpfw-bukrs AND
                    bschl = '50'.
    IF sy-subrc <> 0.
      SELECT SINGLE zuonr bldat INTO (zcheck_no,zcheck_date)
       FROM bsis
       WHERE belnr = bkpfw-belnr
        AND  gjahr = bkpfw-gjahr
        AND  gsber IN rgsber
        AND  bukrs = bkpfw-bukrs .

*    ELSE.
*      zcheck_no = w_zuonr.
    ENDIF.

*    ENDIF.
  ELSE.
    MESSAGE s011 WITH ' No records Found'. "Added by Bhumika
    LEAVE LIST-PROCESSING.
  ENDIF.


ENDFORM.                               " PROCESS-FOR-DOCUMENT-NO

***End of Include-3********************************************







*sting the format for a voucher given the posting date
** INCLUDE ymp_fi_voucher_print_inc4_for2.
***Start of Include-4******************************************
*&---------------------------------------------------------------------*
*&  Include           YMP_FI_VOUCHER_PRINT_INC4_FOR2
*&---------------------------------------------------------------------*
*&      Form  PROCESS-FOR-POSTING-DATE
*&---------------------------------------------------------------------*
*subroutine for creating the format for a voucher given the posting date

FORM process-for-posting-date.

*selecting line item headers from bkpf according to user input
*and storing them in bkpftab
  SELECT * FROM  bkpf
         WHERE bukrs IN rbukrs
         AND   budat IN rbudat
         AND   gjahr EQ rgjahr
         AND   usnam IN rusnam
*         AND   blart IN rblart
         AND   budat IN p_date.
    MOVE-CORRESPONDING bkpf TO bkpfw.
    APPEND bkpfw TO bkpftab.
  ENDSELECT.

  IF sy-subrc = 0.     "if line item headers exist in bkpf
    LOOP AT bkpftab INTO bkpfw.   "for each such header, select all line items from
      IF bkpfw-bstat = 'V'.  " IF document is parked
        SELECT * FROM vbkpf WHERE bukrs = bkpfw-bukrs
                       AND   belnr = bkpfw-belnr
                       AND   gjahr = bkpfw-gjahr
                       AND   blart = bkpfw-blart
                       AND   usnam = bkpfw-usnam
                       AND   budat = bkpfw-budat.
        ENDSELECT.
        MODIFY bkpftab FROM bkpfw.

        SELECT * FROM  vbsegs        "vbsegs line item for parked doc.
               WHERE belnr = bkpfw-belnr AND
                     gjahr = bkpfw-gjahr AND
                     bukrs = bkpfw-bukrs AND
                     gsber IN rgsber.
          MOVE-CORRESPONDING vbsegs TO bsegw.
          MOVE vbsegs-saknr TO bsegw-hkont.
          APPEND bsegw TO bsegtab.
        ENDSELECT.
        IF sy-subrc <> 0.
          IF bkpfw-bstat <> 'Z'.
            DELETE bkpftab FROM bkpfw.
            CONTINUE.
          ENDIF.
        ENDIF.
      ELSEIF
        bkpfw-bstat = 'Z'.    "Parked doc deleted.
        bkpfw-flag001 = 'x'.
        MODIFY bkpftab FROM bkpfw.
      ELSE.
        SELECT * FROM  bseg                                         "bseg
               WHERE belnr = bkpfw-belnr AND
                     gjahr = bkpfw-gjahr AND
                     bukrs = bkpfw-bukrs AND
                     gsber IN rgsber.
          MOVE-CORRESPONDING bseg TO bsegw.
          APPEND bsegw TO bsegtab.
        ENDSELECT.
        IF sy-subrc <> 0.
          IF bkpfw-bstat <> 'Z'.
            DELETE bkpftab FROM bkpfw.
            CONTINUE.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

*    IF rgsber-low <> '*' AND rgsber-low <> ' '.
*      LOOP AT bsegtab INTO bsegw.
*        IF bsegw-gsber <> rgsber.
*          docw-belnr = bsegw-belnr.
*          COLLECT docw INTO doctab.    "each doc. no. is stored only once
*        ENDIF.
*      ENDLOOP.

*sorting doc. nos. so that a binary search through doctab is facilitated
    SORT doctab BY belnr AS TEXT.

    LOOP AT bsegtab INTO bsegw.
      valid_doc = 'false'.
      READ TABLE doctab INTO docw WITH KEY belnr = bsegw-belnr BINARY SEARCH.
      IF sy-subrc = 0.
        valid_doc = 'true'.
      ENDIF.
      IF valid_doc = 'false'.
        DELETE bsegtab FROM bsegw.
      ENDIF.
    ENDLOOP.

*going through each record of bkpftab, and checking whether the doc. no.
*is present in doctab, otherwise the doc. is labelled 'invalid' and
*deleted from bkpftab
    LOOP AT bkpftab INTO bkpfw.
      valid_doc = 'false'.
      READ TABLE doctab INTO docw WITH KEY belnr = bkpfw-belnr BINARY SEARCH.
      IF sy-subrc = 0.
        valid_doc = 'true'.
      ENDIF.
      IF valid_doc = 'false'.
        DELETE bkpftab FROM bkpfw.
      ENDIF.
    ENDLOOP.
    FREE doctab.
  ENDIF.

*for each account no. appearing in bsegtab, text explaining the nature
*of the account is picked up from skat, and stored in a separate field
  LOOP AT bsegtab INTO bsegw.
    CASE bsegw-koart.
      WHEN 'S'.
        SELECT SINGLE * FROM skat
               WHERE saknr = bsegw-hkont
               AND ktopl = t001-ktopl.          "added by bhumika
        bsegw-txt50 = skat-txt50.
        MODIFY bsegtab FROM bsegw.
      WHEN 'K'.
        SELECT SINGLE * FROM lfa1
               WHERE lifnr = bsegw-lifnr.
        gw_gltext-lifnr = lfa1-lifnr.
        CONCATENATE  lfa1-name1 lfa1-name2
                     INTO gw_gltext-text70
                     SEPARATED BY space.         "added by bhumika
        APPEND gw_gltext TO gt_gltext.
        CLEAR gw_gltext.
*          bsegtab-name1 = lfa1-name1.
        MODIFY bsegtab FROM bsegw.
      WHEN 'A'.
        SELECT SINGLE * FROM skat
               WHERE spras = 'E' AND
                     saknr = bsegw-hkont
                     AND ktopl = t001-ktopl.    "added by bhumika.
        bsegw-txt50 = skat-txt50.
        MODIFY bsegtab FROM bsegw.
      WHEN 'D'.
        SELECT SINGLE * FROM kna1
               WHERE kunnr = bsegw-kunnr.

        bsegw-name1 = kna1-name1.
        MODIFY bsegtab FROM bsegw.
      WHEN 'M'.
        SELECT SINGLE * FROM skat
               WHERE saknr = bsegw-hkont
               AND ktopl = t001-ktopl.          "added by bhumika.
        bsegw-txt50 = skat-txt50.
        MODIFY bsegtab FROM bsegw.
    ENDCASE.
  ENDLOOP.
*voucher details as gathered above are displayed in table form on screen
  PERFORM display-voucher-data.

*  ELSE.            "if line item header as per user input is not in bkpf
*    MESSAGE I011 WITH ' No records Found'.
  MESSAGE s011 WITH ' No records Found'.
  LEAVE LIST-PROCESSING. "Added by Bhumika
*  ENDIF.
ENDFORM.                               " PROCESS-FOR-POSTING-DATE

***End of Include-4********************************************








*subroutine for displaying voucher format in table form on screen
** INCLUDE ymp_fi_voucher_print_inc5_dat1.
***Start of Include-5******************************************
*&---------------------------------------------------------------------*
*&  Include           YMP_FI_VOUCHER_PRINT_INC5_DAT1
*&---------------------------------------------------------------------*

*subroutine for displaying voucher format in table form on screen

FORM display-voucher-data.
  INCLUDE <line>.
  DATA : w_cnt TYPE n.
  DATA : zgsber LIKE bseg-gsber.
  DATA: it_word    LIKE spell  OCCURS 0 WITH HEADER LINE,
        l_dr_amt   TYPE string,
        l_dr_dec   TYPE string,
        l_cr_amt   TYPE string,
        l_cr_dec   TYPE string,
        l_doc_curr LIKE bkpfw-waers,
        l_loc_curr LIKE bkpfw-hwaer.

  DATA: w_tcurr           LIKE  tcurc-waers,
        w_amount_internal LIKE  wmto_s-amount,
        w_amount_external LIKE  wmto_s-amount,
        w_omr_amt         TYPE p DECIMALS 3.


  LOOP AT bkpftab INTO bkpfw.
    LOOP AT bsegtab INTO bsegw WHERE belnr = bkpfw-belnr AND
                          bukrs = bkpfw-bukrs AND
                          gjahr = bkpfw-gjahr.
      MOVE bsegw-gsber TO zgsber.
      MOVE bsegw-kostl TO bkpfw-kostl.
      bkpfw-gsber = zgsber.
      MODIFY bkpftab FROM bkpfw.
*----------------------------------------------------------------------*
*   INCLUDE ZFIDDATE                                                   *
*----------------------------------------------------------------------*

      EXIT.
    ENDLOOP.
  ENDLOOP.
  IF p_report EQ 'X'.
    PERFORM display_smartform.

  ELSE.
    SORT bkpftab BY bukrs gsber belnr.
    LOOP AT bkpftab INTO bkpfw.
      CASE bkpfw-bstat.
        WHEN  'V'.
          IF parked <> 'X'.
            DELETE bkpftab INDEX sy-tabix.
            CONTINUE.
          ENDIF.
        WHEN  'Z'.
          IF deleted <> 'X'.
            DELETE bkpftab INDEX sy-tabix.
            CONTINUE.
          ENDIF.
        WHEN OTHERS.
          IF posted <> 'X'.
            DELETE bkpftab INDEX sy-tabix.
            CONTINUE.
          ENDIF.
      ENDCASE.
      SELECT SINGLE butxt INTO zschemetext FROM t001 CLIENT SPECIFIED
        WHERE mandt = sy-mandt AND
              bukrs = bkpfw-bukrs.
      CLEAR:  dr_tot, cr_tot.
      ULINE.
      l_doc_curr = bkpfw-waers. "document Currency
      l_loc_curr = bkpfw-hwaer. "Local Currency

      WRITE : /1 sy-vline ,
               5 'Ref. Doc.       : ', bkpfw-xblnr,
              50 'Doc. Date       : ', bkpfw-bldat,
              95 'Doc. Type       : ', bkpfw-blart,
              132 sy-vline,
              /1 sy-vline ,
              5 'Doc. Header Text: ', bkpfw-bktxt,
              50 'Posting Period  : ', bkpfw-monat,
              95 'Doc. Currency   : ', bkpfw-waers,
              132 sy-vline,

              /1 sy-vline ,

              5 'Local Currency  : ', bkpfw-hwaer LEFT-JUSTIFIED.
      IF bkpfw-bstat = 'V'.
        WRITE : 50 'Doc. Status     :  Parked',
                132 sy-vline.
      ELSEIF
        bkpfw-bstat = 'Z'.
        WRITE : 50 'Doc. Status     :  Parked Document Deleted',
                132 sy-vline.
      ELSE.
        WRITE : 50 'Doc. Status     :  Posted',
                132 sy-vline.

      ENDIF.
      ULINE.
      WHILE w_cnt < 3.
        WRITE :/1 sy-vline,
                132 sy-vline.
        w_cnt = w_cnt + 1.
      ENDWHILE.
      ULINE.
* -------------Change ASDEVK900376-----------------------
*  WRITE : / SY-VLINE , 'PK',7 'A/c Code',18 'Description',50 'Cost Ctr'
*           65 'Profit Ctr',85 'Order',
*           106 'Amount',132
*SY-VLINE .

      WRITE : / sy-vline , 'PK',7 'A/c Code',18 'Description',
               65  'Order/Budget Head',
               85  'Amount in Doc. Curr.',
               106 'Amount in Loc. Curr.',132
    sy-vline .
* ----------End of Change ASDEVK900376---------------------
      WRITE:/ sy-vline,18 'Line Item Text',132 sy-vline.
      ULINE.
      SORT bsegtab BY bukrs gsber belnr.
      LOOP AT bsegtab INTO bsegw WHERE belnr = bkpfw-belnr
                     AND    bukrs = bkpfw-bukrs
                     AND    gjahr = bkpfw-gjahr.
        CONCATENATE bsegw-bschl bsegw-umskz INTO bsegw-bschl.
        WRITE :  / sy-vline , bsegw-bschl.  " GSBER.
        CASE bsegw-koart.
          WHEN 'S'.
            WRITE : bsegw-hkont,bsegw-txt50(48).
          WHEN 'K'.
            WRITE : bsegw-lifnr, bsegw-name1(20).
          WHEN 'A'.
            WRITE : bsegw-hkont, bsegw-txt50(48).
          WHEN 'D'.
            WRITE : bsegw-kunnr, bsegw-name1(20).
          WHEN 'M'.
            WRITE : bsegw-hkont, bsegw-txt50(48).

        ENDCASE.


        w_tcurr = l_doc_curr.
*      W_AMOUNT_INTERNAL = bsegtab-pswbt.
        w_amount_internal = bsegw-wrbtr.



        CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_DISPLAY'
          EXPORTING
            currency        = l_doc_curr
            amount_internal = w_amount_internal
          IMPORTING
            amount_display  = w_amount_external
          EXCEPTIONS
            internal_error  = 1
            OTHERS          = 2.
        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

*      bsegtab-pswbt = w_amount_eternal .
        bsegw-wrbtr = w_amount_external .


*Convert Local Currency
        CLEAR: w_amount_internal,
               w_amount_external.

        w_amount_internal = bsegw-dmbtr.

        CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_DISPLAY'
          EXPORTING
            currency        = l_loc_curr
            amount_internal = w_amount_internal
          IMPORTING
            amount_display  = w_amount_external
          EXCEPTIONS
            internal_error  = 1
            OTHERS          = 2.
        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        bsegw-dmbtr = w_amount_external .
        w_omr_amt = w_amount_external .

        IF l_loc_curr = 'OMR'.
          MOVE w_omr_amt TO signed_dmbtr.
        ELSE.
          MOVE bsegw-dmbtr TO signed_dmbtr.
        ENDIF.

        MOVE bsegw-wrbtr TO signed_wrbtr.
*      MOVE bsegtab-pswbt TO signed_wrbtr.
        IF bsegw-shkzg = 'S'.
*        dr_tot = dr_tot + bsegtab-dmbtr."-ASDEVK900376
          dr_tot = dr_tot + bsegw-wrbtr. "-ASDEVK900376
*        dr_tot = dr_tot + bsegtab-pswbt. "+ASDEVK900376
          CONCATENATE signed_dmbtr ' ' INTO signed_dmbtr.
          CONCATENATE signed_wrbtr ' ' INTO signed_wrbtr.
          zdr_cr = 'Dr'.
        ELSE.
*        cr_tot = cr_tot + bsegtab-dmbtr."-ASDEVK900376
          cr_tot = cr_tot + bsegw-wrbtr. "-ASDEVK900376
*        cr_tot = cr_tot + bsegtab-pswbt. "+ASDEVK900376
          CONCATENATE signed_dmbtr '-' INTO signed_dmbtr.
          CONCATENATE signed_wrbtr '-' INTO signed_wrbtr.
          zdr_cr = 'Cr'.
        ENDIF.

        WRITE: 65  bsegw-aufnr,
                85 signed_wrbtr,
                106 signed_dmbtr,
               132 sy-vline.
        SELECT SINGLE mctxt
        INTO bsegw-mctxt
        FROM cskt
        WHERE kostl = bsegw-kostl
        AND spras = 'E'.
        CLEAR cskt.

        SELECT SINGLE mctxt
        INTO bsegw-pmctxt
        FROM cepct
        WHERE prctr = bsegw-prctr
        AND spras = 'E'.
        CLEAR cepct.

        SELECT SINGLE post1
        INTO bsegw-post1
        FROM prps
        WHERE pspnr = bsegw-projk.
        CLEAR prps.


        WRITE :/ sy-vline,10 bsegw-sgtxt(38),50 bsegw-mctxt(15),
                98 bsegw-post1(15),
                132 sy-vline.
        ULINE.

      ENDLOOP.

      CALL FUNCTION 'SPELL_AMOUNT'
        EXPORTING
          amount    = dr_tot
          currency  = l_doc_curr
          language  = sy-langu
        IMPORTING
          in_words  = it_word
        EXCEPTIONS
          not_found = 1
          too_large = 2
          OTHERS    = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      l_dr_amt = it_word-word.
      l_dr_dec = it_word-decword.

      REFRESH it_word.

      CALL FUNCTION 'SPELL_AMOUNT'
        EXPORTING
          amount    = cr_tot
          currency  = l_doc_curr
          language  = sy-langu
        IMPORTING
          in_words  = it_word
        EXCEPTIONS
          not_found = 1
          too_large = 2
          OTHERS    = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      l_cr_amt = it_word-word.
      l_cr_dec = it_word-decword.

      DATA: w_ltext LIKE tcurt-ltext.

      SELECT SINGLE ltext INTO w_ltext
        FROM tcurt
        WHERE spras = 'EN'
          AND waers = l_doc_curr.

      ULINE.
      WRITE : / sy-vline NO-GAP,'Debit total  : ',
                                  dr_tot,               "#EC UOM_IN_MES

              '  ', w_ltext, 132 sy-vline.
      WRITE : / sy-vline NO-GAP,'Credit total : ',
                                cr_tot,                 "#EC UOM_IN_MES

              '  ', w_ltext, 132 sy-vline.
      PERFORM write_signature_bar.
      NEW-PAGE.
    ENDLOOP.
  ENDIF.
ENDFORM.                               "FORM DISPLAY-VOUCHER-DATA.

***End of Include-5********************************************










*subroutine for displaying the signatures of requisite authorities
** INCLUDE ymp_fi_voucher_print_inc6_sign.
***Start of Include-6******************************************
*&---------------------------------------------------------------------*
*&  Include           YMP_FI_VOUCHER_PRINT_INC6_SIGN
*&---------------------------------------------------------------------*
*&    Form  WRITE_SIGNATURE_BAR
*&---------------------------------------------------------------------*

*subroutine for displaying the signatures of requisite authorities

FORM write_signature_bar.
  DATA : w_cnt TYPE n.

  WHILE w_cnt < 6.
    WRITE :/1 sy-vline,
            132 sy-vline.
    w_cnt = w_cnt + 1.
  ENDWHILE.
  ULINE.
  WRITE : /1 '|',10 'Entered By' , bkpfw-usnam.
  WRITE : 40 '| Authorised By' , 70 '| Received By'.
  WRITE : 100 '| Cheque No.', 132 sy-vline.
  WRITE : /1 '|', 40 '|' , 70 '|', 100 '| / Assignment No. ', zcheck_no,
132 sy-vline.
  WRITE : /1 '|',40 '|' ,70 '|', 100 '|', 132 sy-vline.
  WRITE : /1 '|',40 '|' ,70 '|', 100 '|', 132 sy-vline.
  WRITE : /1 '|',40 '|' , 70 '|', 100 '|', 132 sy-vline.
*  WRITE : /1 '|',10 'Entry Date' , BKPFTAB-CPUDT , 40 '| Date' .
  WRITE : /1 '|',10 ' ' , ' ' , 40 '| Date' .
  WRITE : 70 '| Date', 100 '| Date' , zcheck_date NO-ZERO, 132 sy-vline.
  ULINE.
  WRITE : /1 ' -VE SIGN INDICATES CREDIT , NO SIGN INDICATES DEBIT '.
ENDFORM.                               " WRITE_SIGNATURE_BAR

***End of Include-6********************************************











*subroutines for displaying Smartform output.
** INCLUDE ymp_fi_voucher_print_inc7_sf.
***Start of Include-7******************************************
*&---------------------------------------------------------------------*
*&  Include           YMP_FI_VOUCHER_PRINT_INC7_SF
*&---------------------------------------------------------------------*

*            GLOBAL DATA FOR SMARTFORM

DATA: lv_formname           TYPE tdsfname.
DATA: lv_fm_name            TYPE rs38l_fnam.


*&---------------------------------------------------------------------*
*&      Form  display_smartform
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_smartform .

  IF pr_pdf = 'X'.
    IF p_input IS INITIAL.
*      MESSAGE 'Please Enter File name to Download PDF File' TYPE 'S'.
      MESSAGE s011(zdev) WITH 'Please Enter File name to Download PDF File'.
    ELSE.
      PERFORM create_sf_name.
      PERFORM call_fm.
    ENDIF.
  ELSE.
    PERFORM create_sf_name.
    PERFORM call_fm.
  ENDIF.

ENDFORM.                    " display_smartform
*&---------------------------------------------------------------------*
*&      Form  create_sf_name
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_sf_name .

  lv_formname = 'ZFISF_VOUCHER_PRINT'.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_formname
    IMPORTING
      fm_name            = lv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE e011 WITH ' Error calling Smartform'.
  ENDIF.

ENDFORM.                    " create_sf_name
*&---------------------------------------------------------------------*
*&      Form  call_fm
*&--------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_fm .
  TYPES: abap_bool        TYPE c LENGTH 1.
  DATA   wa_control_ssf   TYPE ssfctrlop.
  DATA   wa_print         TYPE ssfcompop.
  DATA   wa_bkpf          LIKE bkpf.
  DATA  gt_bseg           LIKE bseg OCCURS 0 WITH HEADER LINE.
  DATA : gv_tot_lines     TYPE i .
  DATA :ls_job_output     TYPE ssfcresop,
        gs_output_options TYPE ssfcompop.

  CONSTANTS:
    abap_true  TYPE abap_bool VALUE 'X',
    abap_false TYPE abap_bool VALUE ' '.

  DATA : job_output TYPE ssfcrescl.

*  wa_control_ssf-no_dialog = 'X'.
*  wa_control_ssf-preview = 'X'.

* for setting the parameters of controls
**  gs_con_settings-no_open   = c_x.
**  gs_con_settings-no_close  = c_x.
**
**  CLEAR gs_con_settings-no_close.
**  gs_con_settings-no_dialog = c_x.
**  gs_con_settings-preview   = c_x.

  IF pr_pdf EQ 'X'.
    gs_con_settings-getotf   = 'X'.
*    wa_print-tdnoprev = 'X'.
*    wa_print-tddest     = 'LOCL'.
  ENDIF.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      control_parameters = gs_con_settings
*    EXCEPTIONS
*      formatting_error   = 1
*      internal_error     = 2
*      send_error         = 3
*      user_canceled      = 4
*      OTHERS             = 5.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

  DESCRIBE TABLE  bkpftab LINES gv_tot_lines.

  LOOP AT bkpftab INTO bkpfw.

    MOVE-CORRESPONDING bkpfw TO wa_bkpf.

    LOOP AT bsegtab INTO bsegw WHERE belnr = bkpfw-belnr.
      IF bsegw-shkzg = 'S'.
*        dr_tot = dr_tot + bsegtab-dmbtr."-ASDEVK900376
        dr_tot = dr_tot + bsegw-wrbtr. "-ASDEVK900376
*        dr_tot = dr_tot + bsegtab-pswbt. "+ASDEVK900376
        CONCATENATE signed_dmbtr ' ' INTO signed_dmbtr.
        CONCATENATE signed_wrbtr ' ' INTO signed_wrbtr.
        zdr_cr = 'Dr'.
      ELSE.
*        cr_tot = cr_tot + bsegtab-dmbtr."-ASDEVK900376
        cr_tot = cr_tot + bsegw-wrbtr. "-ASDEVK900376
*        cr_tot = cr_tot + bsegtab-pswbt. "+ASDEVK900376
        CONCATENATE signed_dmbtr '-' INTO signed_dmbtr.
        CONCATENATE signed_wrbtr '-' INTO signed_wrbtr.
        zdr_cr = 'Cr'.
      ENDIF.
      MOVE-CORRESPONDING bsegw TO gt_bseg.

      IF bsegw-koart = 'D' OR bsegw-koart = 'K'.
        MOVE bsegw-name1 TO gt_bseg-kontl.
      ELSE.
        MOVE bsegw-txt50 TO gt_bseg-kontl.
      ENDIF.

      APPEND gt_bseg.
      CLEAR  gt_bseg.
    ENDLOOP.
*  ENDLOOP.
    SORT gt_bseg BY bschl.

    " specific Document type handling
    CLEAR : bsegw.
    READ TABLE bsegtab INTO bsegw WITH KEY belnr = wa_bkpf-belnr
                                           buzei = 1.
    IF wa_bkpf-blart = 'AB'.

      IF bsegw IS NOT INITIAL.
        IF bsegw-shkzg = 'H'.
          lv_doc_type = 'CASH PAYMENT'.
        ELSE.
          lv_doc_type = 'CASH RECEIPT'.
        ENDIF.
      ENDIF.
      CLEAR bsegw.
    ELSEIF wa_bkpf-blart = 'RE'.
      IF bsegw IS NOT INITIAL.
        IF bsegw-shkzg = 'H' AND bsegw-tbtkz = 'X'.
          lv_doc_type = 'CREDIT NOTE'.
        ELSEIF bsegw-shkzg = 'S'.
          lv_doc_type = 'DEBIT NOTE'.
        ELSE.
          lv_doc_type = 'EXPENSE VOUCHER'.
        ENDIF.
      ENDIF.
      CLEAR bsegw.
    ELSEIF wa_bkpf-blart = 'KR'.
      IF wa_bkpf-tcode = 'FB60'.
        lv_doc_type = 'EXPENSE VOUCHER'.
      ELSE.
        lv_doc_type = 'CREDIT NOTE'.
      ENDIF.
    ENDIF.

*&--------------------------------------------------------
*&--Added by Nikhiljith on 10/09/2010
*&--For printing continuos pages in case range is given
    IF sy-tabix = 1.
* Dialog at first loop only
      gs_con_settings-no_dialog = abap_false.
* Open the spool at the first loop only:
      gs_con_settings-no_open   = abap_false.
* Close spool at the last loop only
      gs_con_settings-no_close  = abap_true.
    ELSE.
* Dialog at first loop only
      gs_con_settings-no_dialog = abap_true.
* Open the spool at the first loop only:
      gs_con_settings-no_open   = abap_true.
    ENDIF.

    IF sy-tabix = gv_tot_lines.
* Close spool
      gs_con_settings-no_close  = abap_false.
    ENDIF.
*&--------------------------------------------------------
*  LOOP AT bkpftab INTO bkpfw. "sraut
**
*    MOVE-CORRESPONDING bkpfw TO wa_bkpf. "sraut

    CALL FUNCTION lv_fm_name
      EXPORTING
        control_parameters = gs_con_settings
        output_options     = gs_output_options
*       USER_SETTINGS      = 'X'
        w_str1             = w_str1
        w_str2             = w_str2
        w_str3             = w_str3
        w_doc_type         = lv_doc_type
        bkpftab            = wa_bkpf
        t001               = t001
*       IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       job_output_info    = job_output
*       job_output_options = ls_job_output
      TABLES
        bsegtab            = gt_bseg
        gltext             = gt_gltext
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc <> 0.
      "MESSAGE s010 WITH ' Formatting Error with the Smartform.'.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.





*&--Added by Nikhiljith on 10/09/2010
*&--For Printing Continuos pages if given ranges
*  the same output options for all:
    MOVE-CORRESPONDING ls_job_output TO gs_output_options.
    CLEAR wa_bkpf.
    REFRESH gt_bseg.
*******************************************************************
* PDF Conversion
*******************************************************************
    IF pr_pdf = 'X'.
*      refresh job_output-otfdata.
      DATA: i_otf LIKE itcoo OCCURS 100 WITH HEADER LINE,
            i_pdf LIKE tline OCCURS 100 WITH HEADER LINE.

      DATA: op_option TYPE ssfctrlop.
      DATA : bin_file LIKE sood-objlen,
             filename TYPE string,
             fname    TYPE string.

      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
*         archive_index         = ' '
*         copynumber            = 0
*         ascii_bidi_vis2log    = ' '
*         pdf_delete_otftab     = ' '
        IMPORTING
          bin_filesize          = bin_file
        TABLES
          otf                   = job_output-otfdata
          lines                 = i_pdf
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          err_bad_otf           = 4
          OTHERS                = 5.
      IF sy-subrc EQ 0.

        fname = p_input.
        CONCATENATE fname bkpfw-belnr INTO filename.

        CALL FUNCTION 'GUI_DOWNLOAD'
          EXPORTING
*           BIN_FILESIZE            =
            filename                = filename
            filetype                = 'BIN'
*
          TABLES
            data_tab                = i_pdf
*           FIELDNAMES              =
          EXCEPTIONS
            file_write_error        = 1
            no_batch                = 2
            gui_refuse_filetransfer = 3
            invalid_type            = 4
            no_authority            = 5
            unknown_error           = 6
            header_not_allowed      = 7
            separator_not_allowed   = 8
            filesize_not_allowed    = 9
            header_too_long         = 10
            dp_error_create         = 11
            dp_error_send           = 12
            dp_error_write          = 13
            unknown_dp_error        = 14
            access_denied           = 15
            dp_out_of_memory        = 16
            disk_full               = 17
            dp_timeout              = 18
            file_not_found          = 19
            dataprovider_exception  = 20
            control_flush_error     = 21
            OTHERS                  = 22.
        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.


*        DATA : STR TYPE STRING.
*        CONCATENATE 'File downloaded to' FILENAME INTO STR SEPARATED BY SPACE.
        MESSAGE s016(zdev) WITH filename.       "added by bhumika
*        MESSAGE STR TYPE 'S'.

        CLEAR fname.
        CLEAR i_pdf.
      ENDIF.
    ENDIF.
  ENDLOOP."sraut

*  CALL FUNCTION 'SSF_CLOSE'
*    EXCEPTIONS
*      formatting_error = 1
*      internal_error   = 2
*      send_error       = 3
*      OTHERS           = 4.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.


ENDFORM.                    " call_fm




***End of Include-7********************************************

*Text elements
*----------------------------------------------------------
* 004 PDF


*Selection texts
*----------------------------------------------------------
* PR_BP         Bank Payment
* PR_BR         Bank Reciept
* PR_CN         Credit Note
* PR_CP         Cash Payment
* PR_CR         Cash Reciept
* PR_DN         Debit Note
* PR_EX         Expense Voucher
* PR_JV         Journal Voucher
* PR_PDF        Generate PDF
* P_INPUT       Output File
* P_REPORT      SF Report
* RBELNR         Document No.
* RBUDAT         Posting Date
* RBUKRS         Company Code
* RGJAHR         Fiscal Year


*Messages
*----------------------------------------------------------
*
* Message class: Hard coded
*   Please Enter File name to Download PDF File
*
* Message class: ZMP
*001   & & & &
*003   Invalid Selection
*004   Please use the Document type KZ for bank payment
*YPE

*----------------------------------------------------------------------------------
*Extracted by Direct Download Enterprise version 1.3.1 - E.G.Mellodew. 1998-2005 UK. Sap Release 700
