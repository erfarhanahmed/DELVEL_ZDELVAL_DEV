*&---------------------------------------------------------------------*
*& Report  ZSD_PRINT_ARE1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*REPORT  ZSD_PRINT_ARE1.
*&---------------------------------------------------------------------*
*& Report  ZVRIN_J_1IPRNTARE                                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  zsd_print_are  MESSAGE-ID 8i.

****Tables
TABLES: j_1iexchdr,
        j_1iexcdtl,
        j_1iwrkcus,
        j_1iregset,
        j_1ibond,
        t001w,
        tnad7,
        tnapr,
        t005,
        kna1,
        j_1ilichdr.

DATA : BEGIN OF g_plant_addr,
         city2       TYPE ad_city2,    "  District
         post_code1 TYPE ad_pstcd1,   " City postal code
         str_suppl2 TYPE ad_strspp2,  " Street 2
       END OF g_plant_addr.


****Data Declaration
DATA: ls_exchdr LIKE j_1iexchdr.
DATA: lt_excdtl LIKE TABLE OF j_1iexcdtl WITH HEADER LINE.
DATA: g_addr_exc(120) TYPE c,
      g_addr_cus(120) TYPE c,
      l_j1iregid      TYPE j_1iregid,
      l_j1iexcrn      TYPE j_1iexrn,
      l_j1imocust     TYPE j_1imocust.


DATA : BEGIN OF gt_excdate OCCURS 0,
         exnum  LIKE j_1iexchdr-exnum,
         exyear LIKE j_1iexchdr-exyear,
         exdat  LIKE j_1iexchdr-exdat,
         rdoc   TYPE j_1irdoc1,
       END OF gt_excdate.

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

DATA : text_id(4) TYPE c,
       text_name  LIKE thead-tdname.

DATA: layout LIKE tnapr-fonam.

DATA: l_stpg TYPE c.

DATA: g_mode      LIKE tlines-tdline,
      g_exp       LIKE tlines-tdline,
      g_seal      LIKE tlines-tdline,
      g_cono      LIKE tlines-tdline,
      g_exdat     LIKE j_1iexchdr-exdat,
      g_norows    TYPE i,
      g_pages     TYPE c,
      g_tot_pages TYPE c,
      g_totpage   TYPE c,
      g_rows      TYPE c.

DATA: gs_t001w LIKE t001w.
DATA : g_tot_others TYPE j_1iexcdtl-exbas.
DATA : g_tot_r_others TYPE j_1iexcdtl-bedrate.
DATA : g_tot_duty TYPE j_1iexcdtl-exbas.
DATA : g_tot_bed TYPE j_1iexcdtl-exbas.
DATA : g_tot_ecs TYPE j_1iexcdtl-exbas.
DATA : g_tot_secs TYPE j_1iexcdtl-exbas.
DATA : g_tot_exbas TYPE j_1iexcdtl-exbas.
DATA : g_tot_menge        TYPE j_1iexcdtl-menge,
       g_tot_menge_str    TYPE string,
       g_tot_ntgew        TYPE ntgew_15,
       g_tot_ntgew_str    TYPE string,
       g_tot_brgew        TYPE brgew_15,
       g_tot_brgew_str    TYPE string,
       g_execcno          TYPE char20,
       g_excrnno          TYPE char20,
       g_item_duty        TYPE j_1iexecs,
       g_item_duty_str    TYPE string,
       adr_txt1(255)      TYPE c,
       adr_txt2(255)      TYPE c,
       comm_inv_dt        TYPE d,
       last_data_page     TYPE c,
       commaddstr         TYPE string,
       hdradd2_post_code1 TYPE ad_pstcd1,
       hdradd2_str_suppl1 TYPE ad_strspp1,
       g_rdoc2            TYPE j_1irdoc2,
       g_licname          TYPE j_1ilicname,     " License Type
       g_licnoex          TYPE j_1ilicnoex,     " Official License Number
       g_budat            TYPE j_1ilicbudat.    "	License Issue Date.

CONSTANTS : cnst_sup_add_no TYPE j_1iaddr_no VALUE '001',   " Superintendent
            cnst_com_add_no TYPE j_1iaddr_no VALUE '002',   " Commissionerate
            flg_true        TYPE i VALUE 1,
            flg_false       TYPE i VALUE 0,
            cnst_short      TYPE char4 VALUE 'SHOR'. " flag for Short Address
***Form Call Begin
FORM entry_are1
      TABLES lt_excdtl
      USING output_type
           l_form
           l_copies
           ls_exchdr LIKE j_1iexchdr.

****Code Begins
  PERFORM select_print_data USING output_type
                                  l_form
                                  l_copies
                                  ls_exchdr-werks
                                  ls_exchdr-srgrp
                                  ls_exchdr-trntyp
                         CHANGING options
                                  layout.

  PERFORM select_data
                      TABLES lt_excdtl
                      USING  ls_exchdr.

  PERFORM open_form USING options
                          layout
                    CHANGING result.

  PERFORM print_layout
                      TABLES lt_excdtl
                      USING  ls_exchdr
                             output_type
                             layout.

  PERFORM close_form.
****Code Ends

ENDFORM.                                                    "entry_are1
****Form Call End


****Sub-routines
*&---------------------------------------------------------------------*
*&      Form  select_print_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_OUTPUT_TYPE  text
*      -->P_L_copies  text
*      -->P_ls_exchdr_WERKS  text
*      <--P_OPTIONS  text
*      <--P_LAYOUT  text
*----------------------------------------------------------------------*
FORM select_print_data  USING    p_output_type
                                 p_l_form
                                 p_l_copies
                                 p_ls_exchdr_werks
                                 p_ls_exchdr_srgrp
                                 p_ls_exchdr_trntyp
                        CHANGING p_options LIKE itcpo
                                 p_layout.

  DATA wa_tnad7 LIKE tnad7.
  DATA wa_tnapr LIKE tnapr.
  DATA ls_are_attrb TYPE j_1iare_attrb.

*----number of copies
  SELECT SINGLE *
    INTO ls_are_attrb
    FROM j_1iare_attrb
    WHERE sergrp = p_ls_exchdr_srgrp
    AND   trntyp = p_ls_exchdr_trntyp.

  p_options-tdcopies = ls_are_attrb-no_of_copies.

  p_options-tdimmed = 'X'.
  p_options-tdnewid   = 'X' .
  p_options-tdprogram  = sy-repid.

  p_layout  = p_l_form.

ENDFORM.                    " select_print_data


*&---------------------------------------------------------------------*
*&      Form  select_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_lt_excdtl  text
*      -->P_ls_exchdr  text
*----------------------------------------------------------------------*
FORM select_data  TABLES   p_lt_excdtl
                  USING    p_ls_exchdr LIKE j_1iexchdr.


  DATA: lt_bond_entry TYPE STANDARD TABLE OF j_1ibond,
        ls_bond_entry TYPE j_1ibond,
        l_zeile       TYPE j_1ibond-zeile,
        ls_excdtl     TYPE j_1iexcdtl.



  IF p_lt_excdtl[] IS INITIAL.
    SELECT * FROM j_1iexcdtl INTO TABLE p_lt_excdtl
             WHERE trntyp = p_ls_exchdr-trntyp
             AND   docno  = p_ls_exchdr-docno
             AND   docyr  = p_ls_exchdr-docyr.
  ENDIF.


  LOOP AT p_lt_excdtl INTO j_1iexcdtl.
    SELECT SINGLE * FROM j_1ilichdr WHERE  licyr = j_1iexcdtl-licyr
                                  AND licno = j_1iexcdtl-licno.
    SELECT * FROM j_1iexchdr
           WHERE trntyp = 'DLFC'
           AND   exnum  = j_1iexcdtl-rdoc2
           AND   exyear = j_1iexcdtl-ryear2
           AND   lifnr NE ' ' .

      MOVE-CORRESPONDING j_1iexchdr TO gt_excdate.
      APPEND gt_excdate.
    ENDSELECT.

    " Perform rounding the anmount values
*    CALL FUNCTION 'J_1I6_ROUND_TO_NEAREST_AMT'
*    EXPORTING : I_AMOUNT = j_1iexcdtl-ECS       IMPORTING E_AMOUNT = j_1iexcdtl-ECS,
*                I_AMOUNT = j_1iexcdtl-EXADDTAX1 IMPORTING E_AMOUNT = j_1iexcdtl-EXADDTAX1,
*                I_AMOUNT = j_1iexcdtl-EXBED     IMPORTING E_AMOUNT = j_1iexcdtl-EXBED,
*                I_AMOUNT = j_1iexcdtl-EXBAS     IMPORTING E_AMOUNT = j_1iexcdtl-EXBAS.
*    MODIFY p_lt_excdtl FROM j_1iexcdtl.
  ENDLOOP.
  DELETE ADJACENT DUPLICATES FROM gt_excdate COMPARING exnum exyear.

  SELECT SINGLE * FROM t001w
                  WHERE werks = p_ls_exchdr-werks.

  SELECT SINGLE j_1iregid FROM        j_1iexgrps                          " Note 1270637
                          INTO        l_j1iregid
                          WHERE       j_1iwerks  = p_ls_exchdr-werks
                          AND         j_1iexcgrp = p_ls_exchdr-exgrp.
  IF sy-subrc = 0.
    SELECT SINGLE  j_1iexcrn FROM        j_1iregset
                             INTO        l_j1iexcrn
                             WHERE       j_1iregid = l_j1iregid.
  ENDIF.

  SELECT SINGLE * FROM j_1iwrkcus
                  WHERE j_1iwerks = p_ls_exchdr-werks.
  SELECT SINGLE * FROM j_1iregset
                  WHERE j_1iregid = j_1iwrkcus-j_1iregid.

  SELECT SINGLE post_code1 str_suppl1
    INTO (hdradd2_post_code1, hdradd2_str_suppl1) "COMMADDSTR
    FROM j_1iaddres
    JOIN adrc ON adrc~addrnumber = j_1iaddres~cam_handle
    WHERE address_no = cnst_com_add_no.

  commaddstr = hdradd2_str_suppl1.

  SELECT SINGLE * FROM kna1
                  WHERE kunnr = j_1iexchdr-kunag.
  IF sy-subrc = 0.
    SELECT SINGLE * FROM j_1imocust
                INTO l_j1imocust
                WHERE kunnr = j_1iexchdr-kunwe. "kna1-kunnr.
    IF sy-subrc = 0.
      REPLACE ALL OCCURRENCES OF '/' IN l_j1imocust-j_1iexcd WITH ' Valid upto  '.
    ENDIF.

  ENDIF.

  SELECT SINGLE * FROM t005
                  WHERE land1 = kna1-land1.


*---get the bond amount for the respective ARE doc
  SELECT *
  INTO TABLE lt_bond_entry
  FROM j_1ibond
  WHERE bondyr = p_ls_exchdr-bondyr
  AND  bondno = p_ls_exchdr-bondno.

  READ TABLE p_lt_excdtl
    INTO ls_excdtl
    INDEX 1.


  LOOP AT lt_bond_entry INTO ls_bond_entry.
    IF ls_bond_entry-are_docno = ls_excdtl-exnum
       AND ls_bond_entry-are_docyr = ls_excdtl-exyear
       AND ls_bond_entry-shkzg = 'S'.
      l_zeile = ls_bond_entry-zeile.
    ENDIF.
  ENDLOOP.

  CLEAR: ls_bond_entry.
  REFRESH: lt_bond_entry.

  SELECT *
  INTO TABLE lt_bond_entry
  FROM j_1ibond
  WHERE bondyr = p_ls_exchdr-bondyr
  AND  bondno = p_ls_exchdr-bondno
  AND zeile < l_zeile
  AND are_docno = '          '
  AND are_docyr = '    '.

  SORT lt_bond_entry BY zeile DESCENDING.
  READ TABLE lt_bond_entry INTO ls_bond_entry INDEX 1.
  j_1ibond-bondamt = ls_bond_entry-bondamt.

  SELECT SINGLE fkdat
    FROM vbrk
    INTO comm_inv_dt
    WHERE vbeln = j_1iexchdr-rdoc.



  PERFORM read_addr_data USING p_ls_exchdr-exc_address_no 'EXC'.

  PERFORM read_addr_data USING p_ls_exchdr-cus_address_no 'CUS'.

  DESCRIBE TABLE p_lt_excdtl LINES g_norows.

  MOVE-CORRESPONDING p_ls_exchdr TO j_1iexchdr.

  MOVE-CORRESPONDING t001w TO gs_t001w.

ENDFORM.                    " select_data

*&---------------------------------------------------------------------*
*&      Form  open_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_OPTIONS  text
*      -->P_LAYOUT  text
*      <--P_RESULT  text
*----------------------------------------------------------------------*
FORM open_form  USING    p_options
                         p_layout
                CHANGING p_result.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      application = 'TX'
*     ARCHIVE_INDEX                     =
*     ARCHIVE_PARAMS                    =
      device      = 'PRINTER'
      dialog      = 'X'
      form        = p_layout
      language    = sy-langu
      options     = options
*     MAIL_SENDER =
*     MAIL_RECIPIENT                    =
*     MAIL_APPL_OBJECT                  =
*     RAW_DATA_INTERFACE                = '*'
    IMPORTING
*     LANGUAGE    =
*     NEW_ARCHIVE_PARAMS                =
      result      = result
    EXCEPTIONS
      canceled    = 1
      device      = 2
      form        = 3
      options     = 4
      unclosed    = 5
*     MAIL_OPTIONS                      = 6
*     ARCHIVE_ERROR                     = 7
*     INVALID_FAX_NUMBER                = 8
*     MORE_PARAMS_NEEDED_IN_BATCH       = 9
      spool_error = 10
      codepage    = 11
      OTHERS      = 12.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " open_form

*&---------------------------------------------------------------------*
*&      Form  print_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_layout TABLES lt_excdtl
                  USING p_ls_exchdr STRUCTURE j_1iexchdr
                        p_output_type
                        p_layout.

  DATA: l_rem       TYPE i,
        l_pages     TYPE i,
        l_norows    TYPE i,
        l_one_over,
        g_rec       TYPE i,
        l_tot_bed   TYPE j_1iexcdtl-exbas,
        l_tot_exbas TYPE j_1iexcdtl-exbas,
        rplc        TYPE i.

  DATA : wa_exchdr TYPE j_1iexchdr.
  IF p_output_type = 'ARE1'.
    SELECT SINGLE * FROM j_1ibond WHERE bondno  = p_ls_exchdr-bondno
                                      AND  bondyr = p_ls_exchdr-bondyr.

    g_rows   = g_norows.
    l_norows = g_norows.

    IF l_norows > 3.
      l_pages = 1.
      l_norows = l_norows - 3.
      l_pages  = l_pages + ( l_norows DIV 4 ).
      l_rem    = l_norows MOD 4.
      IF l_rem <> 0.
        l_pages = l_pages + 1.
      ENDIF.
    ELSE.
      l_pages = 1.
    ENDIF.

    g_pages = l_pages.
    IF l_pages > 1.
      last_data_page = l_pages - 1.
    ELSE.
      last_data_page = 1.
    ENDIF.
    l_pages = l_pages + 2.
    g_tot_pages = l_pages.

*    IF g_norows <= 3.<<xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    PERFORM start_form USING p_layout 'PAGE1'.
    PERFORM write_form USING '' 'SET' 'HEADER1'.

    CONCATENATE p_ls_exchdr-trntyp p_ls_exchdr-docno p_ls_exchdr-docyr
     INTO thead-tdname.

    text_id = '0001'.
    PERFORM read_text.
    LOOP AT tlines.
      IF tlines-tdline NE space.
        g_mode = tlines-tdline.
        EXIT.
      ENDIF.
    ENDLOOP.

    text_id = '0002'.
    PERFORM read_text.
    LOOP AT tlines.
      IF tlines-tdline NE space.
        g_exp = tlines-tdline.
        EXIT.
      ENDIF.
    ENDLOOP.

    PERFORM write_form USING '' 'SET' 'HEADER2'.
    PERFORM write_form USING '' 'SET' 'HEADER3'.
    PERFORM write_form USING '' 'SET' 'SUBHEAD'.
    PERFORM write_form USING '' 'SET' 'TITHEAD'.

    CLEAR : g_tot_duty, g_tot_others, g_tot_bed, g_tot_ecs,
            g_tot_exbas, g_tot_menge, g_tot_ntgew, g_tot_brgew,
            g_item_duty.

    LOOP AT lt_excdtl INTO j_1iexcdtl.
      CLEAR g_tot_others.
      CLEAR g_tot_r_others.
      CLEAR  g_item_duty.
      g_tot_duty  = g_tot_duty +
             j_1iexcdtl-nccd +
             j_1iexcdtl-exaed +
             j_1iexcdtl-exsed +
             j_1iexcdtl-exbed +
             j_1iexcdtl-ecs   +
             j_1iexcdtl-exaddtax1.

      g_tot_others  = j_1iexcdtl-nccd + j_1iexcdtl-exaed + j_1iexcdtl-exsed.
      g_tot_bed  = g_tot_bed +  j_1iexcdtl-exbed .
      g_tot_ecs  = g_tot_ecs +  j_1iexcdtl-ecs  + j_1iexcdtl-exaddtax1 .
*          G_TOT_SECS  = G_TOT_SECS +  J_1IEXCDTL-EXADDTAX1  .
      g_tot_exbas  = g_tot_exbas +  j_1iexcdtl-exbas .
      g_tot_menge  = g_tot_menge +  j_1iexcdtl-menge .
      g_tot_ntgew = g_tot_ntgew + j_1iexcdtl-ntgew.
      g_tot_brgew = g_tot_brgew + j_1iexcdtl-brgew.
      g_item_duty = j_1iexcdtl-exbed + j_1iexcdtl-ecs  + j_1iexcdtl-exaddtax1 .

*         shift g_item_duty left deleting leading space.
*      G_TOT_R_OTHERS = J_1IEXCDTL-NCCDRATE + J_1IEXCDTL-SEDRATE + J_1IEXCDTL-AEDRATE .
      IF sy-tabix > 1.
        CLEAR t001w.
      ENDIF.

      " To avoid materisl description related errors
      DO 1000 TIMES.
        REPLACE ALL OCCURRENCES OF REGEX ',,|\s,' IN j_1iexcdtl-maktx
         WITH ',' REPLACEMENT COUNT rplc.
        IF rplc = 0.
          EXIT.
        ENDIF.
      ENDDO.

      LOOP AT gt_excdate WHERE exnum  = j_1iexcdtl-rdoc2
                         AND   exyear = j_1iexcdtl-ryear2.
        IF g_rec = 0.
          PERFORM write_form USING 'ITEMVALUES' 'APPEND' 'MAIN'.
          g_rec = 1.
        ELSE.
          PERFORM write_form USING 'ITEMDETAILS' 'APPEND' 'MAIN'.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    g_item_duty_str = g_item_duty.
    g_tot_ntgew_str = g_tot_ntgew.
    g_tot_brgew_str = g_tot_brgew.
    g_tot_menge_str = g_tot_menge.
    CONDENSE : g_tot_ntgew_str, g_tot_brgew_str,
               g_item_duty_str, j_1iexcdtl-gewei,
               g_tot_menge_str.
*      CONCATENATE G_TOT_BRGEW_STR
*         INTO G_TOT_BRGEW_STR SEPARATED BY ' '.
    REPLACE ALL OCCURRENCES OF SUBSTRING '.000'
       IN g_tot_ntgew_str WITH '.0'.
    REPLACE ALL OCCURRENCES OF SUBSTRING '.000'
       IN g_tot_brgew_str WITH '.0'.

    CLEAR g_rec.
    PERFORM write_form USING '' 'SET' 'FOOTER1'.
    PERFORM write_form USING '' 'SET' 'FOOTER2'.
    PERFORM write_form USING '' 'SET' 'FOOTER3'.
    PERFORM end_form.
*"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*    ELSE.   "g_norows <= 3.
*
**      PERFORM start_form USING p_layout 'PAGE4'.
**      PERFORM write_form USING '' 'SET' 'HEADER1'.
**
**      CONCATENATE p_ls_exchdr-trntyp p_ls_exchdr-docno p_ls_exchdr-docyr
**        INTO thead-tdname.
**
**      text_id = '0001'.
**      PERFORM read_text.
**      LOOP AT tlines.
**        IF tlines-tdline NE space.
**          g_mode = tlines-tdline.
**          EXIT.
**        ENDIF.
**      ENDLOOP.
**
**      text_id = '0002'.
**      PERFORM read_text.
**      LOOP AT tlines.
**        IF tlines-tdline NE space.
**          g_exp = tlines-tdline.
**          EXIT.
**        ENDIF.
**      ENDLOOP.
**
**      PERFORM write_form USING '' 'SET' 'HEADER2'.
**      PERFORM write_form USING '' 'SET' 'HEADER3'.
**      PERFORM write_form USING '' 'SET' 'SUBTIT'.
**      PERFORM write_form USING 'TITHEAD' 'SET' 'MAIN'.
**
**      LOOP AT lt_excdtl INTO j_1iexcdtl.
**        CLEAR G_TOT_OTHERS.
**        CLEAR G_TOT_R_OTHERS.
**        clear g_item_duty.
**        G_TOT_DUTY  = G_TOT_DUTY +
**                    J_1IEXCDTL-NCCD +
**                J_1IEXCDTL-EXAED +
**                J_1IEXCDTL-EXSED +
**                J_1IEXCDTL-EXBED +
**                J_1IEXCDTL-ECS   +
**                J_1IEXCDTL-EXADDTAX1.
**        G_TOT_OTHERS  = J_1IEXCDTL-NCCD + J_1IEXCDTL-EXAED + J_1IEXCDTL-EXSED.
**        G_TOT_bed  = G_TOT_BED +  J_1IEXCDTL-EXBED .
**        G_TOT_ECS  = G_TOT_ECS +  J_1IEXCDTL-ECS  + J_1IEXCDTL-EXADDTAX1.
***          G_TOT_SECS  = G_TOT_SECS +  J_1IEXCDTL-EXADDTAX1 .
**        G_TOT_EXBAS  = G_TOT_EXBAS +  J_1IEXCDTL-EXBAS .
**        G_TOT_menge  = G_TOT_menge +  J_1IEXCDTL-menge .
**        G_TOT_NTGEW  = G_TOT_NTGEW +  J_1IEXCDTL-NTGEW .
**        G_TOT_brgew  = G_TOT_brgew +  J_1IEXCDTL-brgew .
**        g_item_duty = J_1IEXCDTL-EXBED + J_1IEXCDTL-ECS  + J_1IEXCDTL-EXADDTAX1 .
**        g_item_duty_str = g_item_duty.
**        G_TOT_NTGEW_STR = G_TOT_NTGEW.
**        G_TOT_BRGEW_STR = G_TOT_BRGEW.
**         condense : G_TOT_NTGEW_STR, G_TOT_BRGEW_STR, g_item_duty_str.
**        IF sy-tabix > 1.
**          CLEAR t001w.
**        ENDIF.
**        LOOP AT gt_excdate WHERE exnum  = j_1iexcdtl-rdoc2
**                           AND   exyear = j_1iexcdtl-ryear2.
**          if g_rec = 0.
**            PERFORM write_form USING 'ITEMVALUES' 'APPEND' 'MAIN'.
**            g_rec = 1.
**          else.
**            PERFORM write_form USING 'ITEMDETAILS' 'APPEND' 'MAIN'.
**          endif.
**        ENDLOOP.
**      ENDLOOP.
**      clear g_rec.
**      PERFORM write_form USING '' 'SET' 'FOOTER1'.
**      PERFORM write_form USING '' 'SET' 'FOOTER2'.
**      PERFORM write_form USING '' 'SET' 'FOOTER3'.
**      PERFORM end_form.
*
*      PERFORM start_form USING p_layout 'PAGE5'.
*      PERFORM write_form USING '' 'SET' 'HEADER1'.
*
*      CONCATENATE p_ls_exchdr-trntyp p_ls_exchdr-docno p_ls_exchdr-docyr
*       INTO thead-tdname.
*
*      text_id = '0001'.
*      PERFORM read_text.
*      LOOP AT tlines.
*        IF tlines-tdline NE space.
*          g_mode = tlines-tdline.
*          EXIT.
*        ENDIF.
*      ENDLOOP.
*
*      text_id = '0002'.
*      PERFORM read_text.
*      LOOP AT tlines.
*        IF tlines-tdline NE space.
*          g_exp = tlines-tdline.
*          EXIT.
*        ENDIF.
*      ENDLOOP.
*
*      PERFORM write_form USING '' 'SET' 'HEADER2'.
*      PERFORM write_form USING '' 'SET' 'HEADER3'.
*      PERFORM write_form USING '' 'SET' 'SUBHEAD'.
*      PERFORM write_form USING '' 'SET' 'TITHEAD'.
*
*      CLEAR G_TOT_DUTY.
*
*       LOOP AT lt_excdtl INTO j_1iexcdtl.
*        CLEAR G_TOT_OTHERS.
*        CLEAR G_TOT_R_OTHERS.
*         clear  g_item_duty.
*        G_TOT_DUTY  = G_TOT_DUTY +
*               J_1IEXCDTL-NCCD +
*               J_1IEXCDTL-EXAED +
*               J_1IEXCDTL-EXSED +
*               J_1IEXCDTL-EXBED +
*               J_1IEXCDTL-ECS   +
*               J_1IEXCDTL-EXADDTAX1.
*
*        G_TOT_OTHERS  = J_1IEXCDTL-NCCD + J_1IEXCDTL-EXAED + J_1IEXCDTL-EXSED.
*        G_TOT_bed  = G_TOT_BED +  J_1IEXCDTL-EXBED .
*        G_TOT_ECS  = G_TOT_ECS +  J_1IEXCDTL-ECS  + J_1IEXCDTL-EXADDTAX1 .
**          G_TOT_SECS  = G_TOT_SECS +  J_1IEXCDTL-EXADDTAX1  .
*        G_TOT_EXBAS  = G_TOT_EXBAS +  J_1IEXCDTL-EXBAS .
*        G_TOT_menge  = G_TOT_menge +  J_1IEXCDTL-menge .
*        G_TOT_NTGEW = G_TOT_NTGEW + J_1IEXCDTL-NTGEW.
*        G_TOT_brgew = G_TOT_brgew + J_1IEXCDTL-brgew.
*        g_item_duty = J_1IEXCDTL-EXBED + J_1IEXCDTL-ECS  + J_1IEXCDTL-EXADDTAX1 .
*
**         shift g_item_duty left deleting leading space.
**      G_TOT_R_OTHERS = J_1IEXCDTL-NCCDRATE + J_1IEXCDTL-SEDRATE + J_1IEXCDTL-AEDRATE .
*        IF sy-tabix > 1.
*          CLEAR t001w.
*        ENDIF.
*
*        DO 1000 TIMES.
*          replace all occurrences of regex ',,|\s,' in J_1IEXCDTL-MAKTX
*           with ',' replacement count rplc.
*          IF rplc = 0.
*            exit.
*          ENDIF.
*        ENDDO.
*
*        LOOP AT gt_excdate WHERE exnum  = j_1iexcdtl-rdoc2
*                           AND   exyear = j_1iexcdtl-ryear2.
*          if g_rec = 0.
*            PERFORM write_form USING 'ITEMVALUES' 'APPEND' 'MAIN'.
*            g_rec = 1.
*          else.
*            PERFORM write_form USING 'ITEMDETAILS' 'APPEND' 'MAIN'.
*          endif.
*        ENDLOOP.
*      ENDLOOP.
*      g_item_duty_str = g_item_duty.
*      G_TOT_NTGEW_STR = G_TOT_NTGEW.
*      G_TOT_BRGEW_STR = G_TOT_BRGEW.
*      G_TOT_menge_str = G_TOT_menge.
*      condense : G_TOT_NTGEW_STR, G_TOT_BRGEW_STR,
*                 g_item_duty_str, J_1IEXCDTL-GEWEI,
*                 G_TOT_menge_str.
*      CONCATENATE G_TOT_BRGEW_STR J_1IEXCDTL-GEWEI
*         INTO G_TOT_BRGEW_STR SEPARATED BY ' '.
*      replace all occurrences of substring '.000'
*         in G_TOT_NTGEW_STR with '.0'.
*      replace all occurrences of substring '.000'
*         in G_TOT_BRGEW_STR with '.0'.
*
*      clear g_rec.
*      PERFORM write_form USING '' 'SET' 'FOOTER1'.
*      PERFORM write_form USING '' 'SET' 'FOOTER2'.
*      PERFORM write_form USING '' 'SET' 'FOOTER3'.
*      PERFORM end_form.
*
*    ENDIF.    "g_norows <= 3.
* "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    text_id = '0003'.
    PERFORM read_text.
    LOOP AT tlines.
      IF tlines-tdline NE space.
        g_seal = tlines-tdline.
        EXIT.
      ENDIF.
    ENDLOOP.

    text_id = '0004'.
    PERFORM read_text.
    LOOP AT tlines.
      IF tlines-tdline NE space.
        g_cono = tlines-tdline.
        EXIT.
      ENDIF.
    ENDLOOP.

**** Calling Page 2 - Section B
    PERFORM start_form USING p_layout 'PAGE2'.
    PERFORM write_form USING '' 'SET' 'PARTA'.
    PERFORM write_form USING '' 'SET' 'PARTB'.
    PERFORM write_form USING '' 'SET' 'PARTC'.
    PERFORM write_form USING '' 'SET' 'PARTD'.
    PERFORM end_form.

**** Calling Page 3 - Annexure A
*    IF g_norows > 1.
*      PERFORM start_form USING p_layout 'PAGE3'.
*      PERFORM write_form USING 'BOXITEM' 'SET' 'ANNEX'.
*
*      LOOP AT lt_excdtl INTO j_1iexcdtl.
*        CLEAR G_TOT_OTHERS.
*        CLEAR G_TOT_R_OTHERS.
*
**        G_TOT_DUTY  = G_TOT_DUTY + J_1IEXCDTL-NCCD +
**                J_1IEXCDTL-EXAED +
**                J_1IEXCDTL-EXSED +
**                J_1IEXCDTL-EXBED +
**                J_1IEXCDTL-ECS   +
**                J_1IEXCDTL-EXADDTAX1.
**        G_TOT_OTHERS  = J_1IEXCDTL-NCCD + J_1IEXCDTL-EXAED + J_1IEXCDTL-EXSED.
**        G_TOT_bed  = G_TOT_BED +  J_1IEXCDTL-EXBED +  J_1IEXCDTL-ECS  + J_1IEXCDTL-EXADDTAX1.
**        G_TOT_EXBAS  = G_TOT_EXBAS +  J_1IEXCDTL-EXBAS .
**        g_item_duty = J_1IEXCDTL-EXBED + J_1IEXCDTL-ECS  + J_1IEXCDTL-EXADDTAX1 .
**        g_item_duty_str = g_item_duty.
*       g_tot_duty  = g_tot_duty + j_1iexcdtl-nccd +
*                j_1iexcdtl-exaed +
*                j_1iexcdtl-exsed +
*                j_1iexcdtl-exbed +
*                j_1iexcdtl-ecs +
*                j_1iexcdtl-exaddtax1.
*        g_tot_others  = j_1iexcdtl-nccd + j_1iexcdtl-exaed + j_1iexcdtl-exsed.
*
*        IF sy-tabix = 1.
*          l_one_over = 'X'.
*        ENDIF.
*        PERFORM write_form USING 'ITEMS' 'APPEND' 'MAIN'.
*        IF l_one_over = 'X'.
*          CLEAR: g_cono, g_seal.
*        ENDIF.
*      ENDLOOP.
*      PERFORM end_form.
*    ENDIF.

    PERFORM clear_tab.

  ELSEIF p_output_type = 'ARE3'.
    CLEAR : g_tot_menge, g_tot_ntgew, g_tot_brgew, g_tot_bed, g_tot_exbas.
    g_rows   = g_norows.
    l_norows = g_norows.
    IF l_norows > 3.
      l_pages = 1.
      l_norows = l_norows - 3.
      l_pages  = l_pages + ( l_norows DIV 4 ).
      l_rem    = l_norows MOD 4.
      IF l_rem <> 0.
        l_pages = l_pages + 1.
      ENDIF.
    ELSE.
      l_pages = 1.
      g_totpage = 1.
    ENDIF.
    g_pages = l_pages.
    l_pages = l_pages + 1.
    g_tot_pages = l_pages .
    IF g_totpage IS INITIAL.
      g_totpage = l_pages + 1.
    ENDIF.

    SELECT SINGLE  j_1iexcd j_1iexrn INTO (g_execcno,g_excrnno) FROM
    j_1imocomp WHERE werks = j_1iexchdr-werks.

    " Plant Address Details
    SELECT SINGLE city1
                  post_code1
                  str_suppl2
    INTO g_plant_addr
    FROM adrc
    WHERE addrnumber = gs_t001w-adrnr.

    " CT Doc info
    READ TABLE lt_excdtl INTO j_1iexcdtl INDEX 1.
    IF sy-subrc = 0.
      g_rdoc2 = j_1iexcdtl-rdoc2.
      SELECT SINGLE licname
                    licnoex
                    budat
        FROM j_1ilichdr
        INTO (g_licname, g_licnoex, g_budat)
        WHERE licyr = j_1iexcdtl-licyr
          AND licno = j_1iexcdtl-licno.
      CLEAR j_1iexcdtl.
    ENDIF.
    BREAK mbhosale. " &COMMADDSTR& &J_1IREGSET-J_1IEXCCO&
    " &ADR_TXT1& &adr_txt2&   "  &J_1IREGSET-J_1IEXCDI&
    IF g_norows <= 3.

      PERFORM start_form USING p_layout 'PAGE1'.
      PERFORM write_form USING '' 'SET' 'HEADER1'.
      PERFORM write_form USING '' 'SET' 'HEADER2'.
      PERFORM write_form USING '' 'SET' 'HEADER3'.
      PERFORM write_form USING '' 'SET' 'SUBHEAD'.
      PERFORM write_form USING '' 'SET' 'TITHEAD'.

      CLEAR : g_tot_duty, g_tot_others, g_tot_bed, g_tot_ecs,
              g_tot_exbas, g_tot_menge, g_tot_ntgew, g_tot_brgew,
              g_item_duty.

      LOOP AT lt_excdtl INTO j_1iexcdtl.
        IF sy-tabix > 1.
          CLEAR t001w.
        ENDIF.

        " to avoid material description related errors
        DO 1000 TIMES.
          REPLACE ALL OCCURRENCES OF REGEX ',,|\s,' IN j_1iexcdtl-maktx
           WITH ',' REPLACEMENT COUNT rplc.
          IF rplc = 0.
            EXIT.
          ENDIF.
        ENDDO.

        CLEAR : l_tot_bed, l_tot_exbas.
        LOOP AT gt_excdate WHERE exnum  = j_1iexcdtl-rdoc2
                           AND   exyear = j_1iexcdtl-ryear2.
          CLEAR g_tot_others.
          CLEAR g_tot_r_others.
          CLEAR g_item_duty.
          g_tot_duty  = j_1iexcdtl-nccd +
                      j_1iexcdtl-exaed +
                      j_1iexcdtl-exsed +
                      j_1iexcdtl-exbed +
                      j_1iexcdtl-ecs   +
                      j_1iexcdtl-exaddtax1.
          g_tot_others  = j_1iexcdtl-nccd + j_1iexcdtl-exaed + j_1iexcdtl-exsed.
          l_tot_bed     = l_tot_bed + j_1iexcdtl-exbed + j_1iexcdtl-ecs + j_1iexcdtl-exaddtax1.
          l_tot_exbas   = l_tot_exbas +  j_1iexcdtl-exbas.
          g_item_duty   = j_1iexcdtl-exbed + j_1iexcdtl-ecs + j_1iexcdtl-exaddtax1.
          g_item_duty_str = g_item_duty.
          CONDENSE g_item_duty_str.
          IF g_rec = 0.
            PERFORM write_form USING 'ITEMVALUES' 'APPEND' 'MAIN'.
*            g_rec = 1.
*          else.
*            PERFORM write_form USING 'ITEMDETAILS' 'APPEND' 'MAIN'.
          ENDIF.
        ENDLOOP.
        g_tot_menge = g_tot_menge + j_1iexcdtl-menge.
        g_tot_ntgew = g_tot_ntgew + j_1iexcdtl-ntgew.
        g_tot_brgew = g_tot_brgew + j_1iexcdtl-brgew.

        g_tot_bed     = g_tot_bed     + l_tot_bed.
        g_tot_exbas   = g_tot_exbas   + l_tot_exbas.
        CLEAR j_1iexcdtl.
      ENDLOOP.
*      clear g_rec.
*      PERFORM write_form USING '' 'SET' 'FOOTER1'.
      PERFORM write_form USING '' 'SET' 'FOOTER2'.

      PERFORM end_form.

    ELSE.

      PERFORM start_form USING p_layout 'PAGE1'.

      PERFORM write_form USING '' 'SET' 'HEADER1'.
      PERFORM write_form USING '' 'SET' 'HEADER2'.
      PERFORM write_form USING '' 'SET' 'HEADER3'.
      PERFORM write_form USING '' 'SET' 'SUBHEAD'.
*      PERFORM write_form USING '' 'SET' 'SUBTIT'.
*      PERFORM write_form USING 'TITHEAD' 'SET' 'MAIN'.
      PERFORM write_form USING '' 'SET' 'FOOTER3'.
      PERFORM write_form USING '' 'SET' 'TITHEAD'.

      CLEAR : g_tot_duty, g_tot_others, g_tot_bed, g_tot_ecs,
              g_tot_exbas, g_tot_menge, g_tot_ntgew, g_tot_brgew,
              g_item_duty.

      LOOP AT lt_excdtl INTO j_1iexcdtl.
        IF sy-tabix > 1.
          CLEAR t001w.
        ENDIF.
        CLEAR : l_tot_bed, l_tot_exbas.
        LOOP AT gt_excdate WHERE exnum  = j_1iexcdtl-rdoc2
                           AND   exyear = j_1iexcdtl-ryear2.
          CLEAR g_tot_others.
          CLEAR g_tot_r_others.
          CLEAR g_item_duty.
          g_tot_duty  = j_1iexcdtl-nccd +
                      j_1iexcdtl-exaed +
                      j_1iexcdtl-exsed +
                      j_1iexcdtl-exbed +
                      j_1iexcdtl-ecs   +
                      j_1iexcdtl-exaddtax1.
          g_tot_others  = j_1iexcdtl-nccd + j_1iexcdtl-exaed + j_1iexcdtl-exsed.
          l_tot_bed     = l_tot_bed + j_1iexcdtl-exbed + j_1iexcdtl-ecs + j_1iexcdtl-exaddtax1.
          l_tot_exbas   = l_tot_exbas +  j_1iexcdtl-exbas.
          g_item_duty   = j_1iexcdtl-exbed + j_1iexcdtl-ecs + j_1iexcdtl-exaddtax1.
          g_item_duty_str = g_item_duty.
          CONDENSE g_item_duty_str.
          IF g_rec = 0.
            PERFORM write_form USING 'ITEMVALUES' 'APPEND' 'MAIN'.
*            g_rec = 1.
*          else.
*            PERFORM write_form USING 'ITEMDETAILS' 'APPEND' 'MAIN'.
          ENDIF.
        ENDLOOP.
        g_tot_menge = g_tot_menge + j_1iexcdtl-menge.
        g_tot_ntgew = g_tot_ntgew + j_1iexcdtl-ntgew.
        g_tot_brgew = g_tot_brgew + j_1iexcdtl-brgew.
        g_tot_bed   = g_tot_bed   + l_tot_bed.
        g_tot_exbas = g_tot_exbas + l_tot_exbas.
      ENDLOOP.
*      clear g_rec.
      PERFORM write_form USING '' 'SET' 'FOOTER1'.
      PERFORM write_form USING '' 'SET' 'FOOTER2'.

      PERFORM end_form.

    ENDIF.

**** Calling Page 3 - Certificate Printing
    PERFORM start_form USING p_layout 'PAGE3'.
    PERFORM write_form USING '' 'SET' 'HEADER4'.
    PERFORM write_form USING '' 'SET' 'SUBHEAD2'.
    PERFORM write_form USING '' 'SET' 'TITHEAD2'.
    PERFORM write_form USING '' 'SET' 'FOOTER1'.
*    PERFORM write_form USING '' 'SET' 'FOOTER2'.
    PERFORM write_form USING '' 'SET' 'FOOTER4'.
    PERFORM end_form.

    PERFORM clear_tab.

  ENDIF.   "p_output_type = 'ARE1'


ENDFORM.                    " print_layout

*&---------------------------------------------------------------------*
*&      Form  close_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM close_form .

  CALL FUNCTION 'CLOSE_FORM'
    IMPORTING
      result   = result
* TABLES
*     OTFDATA  =
    EXCEPTIONS
      unopened = 1
      OTHERS   = 6.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " close_form

*&---------------------------------------------------------------------*
*&      Form  READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_text .

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = text_id
      language                = sy-langu
      name                    = thead-tdname
      object                  = 'J1IARE1'
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
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    CLEAR tlines.
    REFRESH tlines.
  ENDIF.

ENDFORM.                    " READ_TEXT

*&---------------------------------------------------------------------*
*&      Form  WRITE_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0319   text
*      -->P_0320   text
*      -->P_0321   text
*----------------------------------------------------------------------*
FORM write_form  USING element fnction window.

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element                  = element
      function                 = fnction
      type                     = 'BODY'
      window                   = window
* IMPORTING
*     PENDING_LINES            =
    EXCEPTIONS
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      OTHERS                   = 10.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " WRITE_FORM
*&---------------------------------------------------------------------*
*&      Form  start_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM start_form USING l_layout l_stpg.

  CALL FUNCTION 'START_FORM'
    EXPORTING
*     ARCHIVE_INDEX          =
      form        = l_layout
*     LANGUAGE    = ''
      startpage   = l_stpg
      program     = sy-repid
*     MAIL_APPL_OBJECT       =
* IMPORTING
*     LANGUAGE    =
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " start_form
*&---------------------------------------------------------------------*
*&      Form  end_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM end_form .

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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " end_form
*&---------------------------------------------------------------------*
*&      Form  CLEAR_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_tab .

  CLEAR:j_1iexchdr,
        j_1iexcdtl,
        j_1iwrkcus,
        j_1iregset,
        j_1ibond,
        t001w,
        tnad7,
        tnapr,
        t005,
        kna1.

  CLEAR lt_excdtl.
  REFRESH lt_excdtl.

ENDFORM.                    " CLEAR_TAB
*&---------------------------------------------------------------------*
*&      Form  READ_ADDR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ADDRESS_NO  text
*      -->P_STR         text
*----------------------------------------------------------------------*
FORM read_addr_data  USING    p_address_no p_str.

  DATA: l_addr1_sel LIKE addr1_sel,
        l_sadr      LIKE sadr.
  DATA: l_cam_handle LIKE j_1iaddres-cam_handle.

  SELECT SINGLE cam_handle INTO  l_cam_handle
                           FROM  j_1iaddres
                           WHERE address_no = p_address_no.
  IF sy-subrc = 0.

    l_addr1_sel-addrnumber = l_cam_handle.

    CALL FUNCTION 'ADDR_GET'
      EXPORTING
        address_selection = l_addr1_sel
*       ADDRESS_GROUP     =
*       READ_SADR_ONLY    = ' '
*       READ_TEXTS        = ' '
      IMPORTING
*       ADDRESS_VALUE     =
*       ADDRESS_ADDITIONAL_INFO       =
*       RETURNCODE        =
*       ADDRESS_TEXT      =
        sadr              = l_sadr
* TABLES
*       ADDRESS_GROUPS    =
*       ERROR_TABLE       =
*       VERSIONS          =
* EXCEPTIONS
*       PARAMETER_ERROR   = 1
*       ADDRESS_NOT_EXIST = 2
*       VERSION_NOT_EXIST = 3
*       INTERNAL_ERROR    = 4
*       OTHERS            = 5
      .
    IF sy-subrc = 0.
      IF p_str = 'EXC'.
        CONCATENATE l_sadr-name1 l_sadr-name2 l_sadr-name3+0(20)
                    l_sadr-pstlz l_sadr-ort01+0(20) INTO g_addr_exc.
      ELSEIF p_str = 'CUS'.
        CONCATENATE l_sadr-name1 l_sadr-name2 l_sadr-name3+0(20)
                    l_sadr-pstlz l_sadr-ort01+0(20) INTO g_addr_cus.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.                    " READ_ADDR_DATA


*&---------------------------------------------------------------------*
*&      Form  GET_ADDRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_address TABLES in_tab STRUCTURE itcsy
                        out_tab STRUCTURE itcsy.

  TYPES : BEGIN OF t_adrc,
            city2      TYPE ad_city2,  "  District
            post_code1 TYPE ad_pstcd1, "  City postal code
            street     TYPE ad_street, " Street
            str_suppl1 TYPE ad_strspp1, " Street 2
            str_suppl2 TYPE ad_strspp2, " Street 3
          END OF t_adrc.

  DATA: lw_adrnr TYPE adrnr,
        lw_werks TYPE werks,
        lw_str1  TYPE string, " AD_STRSPP1,
        lw_str2  TYPE string, " AD_STRSPP2.
        wa_adrc  TYPE t_adrc.

  READ TABLE in_tab INDEX 1.
  lw_werks = in_tab-value.



  SELECT SINGLE adrnr
    INTO lw_adrnr
    FROM t001w
    WHERE werks = lw_werks.

  SELECT SINGLE city2
                post_code1
                street
                str_suppl1
                str_suppl2
    INTO wa_adrc "(LW_STR1, LW_STR2)
    FROM adrc
    WHERE addrnumber = lw_adrnr.




  IF NOT wa_adrc-str_suppl1 IS INITIAL.
    REPLACE 'Office & Work:' IN wa_adrc-str_suppl1 WITH ''.
  ENDIF.

  out_tab-name = 'GS_STR1'.
  CONCATENATE wa_adrc-str_suppl1 wa_adrc-str_suppl2
    INTO lw_str1 SEPARATED BY space.
  MOVE lw_str1 TO out_tab-value.
  MODIFY out_tab INDEX 1.

  out_tab-name = 'GS_STR2'.
  CONCATENATE wa_adrc-street wa_adrc-city2 wa_adrc-post_code1
    INTO lw_str2 SEPARATED BY space.
  MOVE lw_str2 TO out_tab-value.
  MODIFY out_tab INDEX 2.






ENDFORM.                    "GET_ADDRESS

*&---------------------------------------------------------------------*
*&      Form  GET_ADD_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_add_text TABLES in_tab STRUCTURE itcsy
                        out_tab STRUCTURE itcsy.

  DATA: lw_werks      TYPE werks,
        lv_sup(12)    TYPE c,
        lv_aco(12)    TYPE c,
        lw_kunag      TYPE kunag,
        lw_adrnrcust  TYPE adrnr,
        lw_name1      TYPE char30,
        lw_name2      TYPE char30,
        lw_city1      TYPE char15,
        lw_post_code1 TYPE char10,
        lw_str11      TYPE ad_strspp1,
        lw_str21      TYPE ad_strspp2,
        lw_name       TYPE char50,
        lw_city       TYPE char30,
        lw_street     TYPE char50.


  CONSTANTS: c_sup(8) TYPE c VALUE 'ZSUP_IN_',
             c_aco(8) TYPE c VALUE 'ZACO_IN_'.


  READ TABLE in_tab INDEX 1.
  lw_werks = in_tab-value.

  READ TABLE in_tab INDEX 2.
  lw_kunag = in_tab-value.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lw_kunag
    IMPORTING
      output = lw_kunag.
  .

  SELECT SINGLE adrnr
                INTO lw_adrnrcust
                FROM kna1
                WHERE kunnr = lw_kunag.

  SELECT SINGLE name1 name2 city1 post_code1 str_suppl1
                str_suppl2
                INTO (lw_name1, lw_name2, lw_city1, lw_post_code1, lw_str11, lw_str21)
                FROM adrc
                WHERE addrnumber = lw_adrnrcust.


  CONCATENATE lw_name1 lw_name2 INTO lw_name SEPARATED BY ' '.
  CONCATENATE lw_city1  lw_post_code1 INTO lw_city SEPARATED BY ' '.
  CONCATENATE lw_str11  lw_str21 INTO lw_street SEPARATED BY ' '.

  CONCATENATE c_sup lw_werks INTO lv_sup.
  CONCATENATE c_aco lw_werks INTO lv_aco.

  out_tab-name = 'SUP_TEXT'.
  MOVE lv_sup TO out_tab-value.
  MODIFY out_tab INDEX 1.

  out_tab-name = 'ACO_TEXT'.
  MOVE lv_aco TO out_tab-value.
  MODIFY out_tab INDEX 2.
  CONDENSE : lw_name, lw_city , lw_street.
  READ TABLE out_tab INDEX 3.
  MOVE lw_name TO out_tab-value.
  MODIFY out_tab INDEX 3.

  READ TABLE out_tab INDEX 4.
  MOVE lw_city TO out_tab-value.
  MODIFY out_tab INDEX 4.

  READ TABLE out_tab INDEX 5.
  MOVE lw_street TO out_tab-value.
  MODIFY out_tab INDEX 5.
ENDFORM.                    "GET_ADD_TEXT


TABLES : stxh.


*&---------------------------------------------------------------------*
*&      FORM  GET_EXC
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->IN_TAB     TEXT
*      -->OUT_TAB    TEXT
*----------------------------------------------------------------------*
FORM get_exc TABLES in_tab STRUCTURE itcsy
              out_tab STRUCTURE itcsy  .
  TYPES: BEGIN OF ty_j_1iexcdtl,
           trntyp  TYPE j_1itrntyp,
           docyr   TYPE j_1idocuyr,
           docno   TYPE j_1idocno,
           zeile    TYPE j_1izeile,
           v_exnum TYPE j_1iexcnum,
*            LICNO   TYPE J_1ILICNO,
*              LICYR   TYPE J_1ILICYR,
**            V_EXNUM1   TYPE J_1IEXCNUM,
           v_rdoc2 TYPE j_1irdoc2,
         END OF ty_j_1iexcdtl.

  DATA: it_j_1iexcdtl TYPE STANDARD TABLE OF ty_j_1iexcdtl,
        wa_j_1iexcdtl TYPE ty_j_1iexcdtl.

****DATA DECLARATION.
  DATA: v_exnum  TYPE  j_1iexcdtl-exnum,
        v_docyr  TYPE  j_1iexcdtl-docyr,
        v_docno  TYPE  thead-tdname,
        v_rdoc2  TYPE  j_1iexcdtl-rdoc2,
        v_trntyp TYPE  j_1itrntyp,
        v_licno  TYPE  j_1ilicno,
        v_licyr  TYPE  j_1ilicyr,
        v_zeile	 TYPE  j_1izeile.
****READING EXNUM FROM IN_TAB
  READ TABLE in_tab INDEX 1 .
  v_trntyp = in_tab-value.

****READING DOCYR FROM IN_TAB
  READ TABLE in_tab INDEX 2 .
  v_docyr = in_tab-value.

****READING DOCNO FROM IN_TAB
  READ TABLE in_tab INDEX 3 .
  v_docno = in_tab-value.

*****CONVERSION FOR EXCISE NO.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_exnum
    IMPORTING
      output = v_exnum.

******DATA FETCHING FOR EXCISE INVOICE NUMBER****

  SELECT  trntyp
          exnum
          docyr
          docno
          rdoc2
          licyr
          licno
          zeile
    FROM j_1iexcdtl
    INTO (v_trntyp,
           v_exnum,
           v_docyr,
           v_docno,
           v_rdoc2,
           v_licyr,   "TYPE J_1ILICNO,
           v_licno,   "TYPE J_1ILICYR,
           v_zeile)
    WHERE trntyp = v_trntyp
    AND   docno  = v_docno
    AND   docyr  = v_docyr.
  ENDSELECT.

****PASSING EXCISE DETAILS TO OUT_TAB------------------------*
*V_EXNUM1 = V_EXNUM.

  READ TABLE out_tab INDEX 1 . "WA_LINE_ITEM.
  out_tab-value = v_exnum.
  MODIFY out_tab INDEX 1.

  READ TABLE out_tab INDEX 2 .
  out_tab-value = v_rdoc2.
  MODIFY out_tab INDEX 2.

*    READ TABLE OUT_TAB INDEX 3 .
*    OUT_TAB-VALUE = V_LICNO.
*    MODIFY OUT_TAB INDEX 3.
*
*    READ TABLE OUT_TAB INDEX 4 .
*    OUT_TAB-VALUE = V_LICYR.
*    MODIFY OUT_TAB INDEX 4.

ENDFORM.                    "GET_EXC


*&---------------------------------------------------------------------*
*&      Form  GET_LIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_lic TABLES in_tab STRUCTURE itcsy
            out_tab STRUCTURE itcsy  .

  TYPES: BEGIN OF ty_j_1iexcdtl,
           trntyp  TYPE j_1itrntyp,
           docyr   TYPE j_1idocuyr,
           docno   TYPE j_1idocno,
           zeile   TYPE j_1izeile,
           v_exnum TYPE j_1iexcnum,
           v_rdoc2 TYPE j_1irdoc2,
         END OF ty_j_1iexcdtl.

  DATA: it_j_1iexcdtl TYPE STANDARD TABLE OF ty_j_1iexcdtl,
        wa_j_1iexcdtl TYPE ty_j_1iexcdtl.

****DATA DECLARATION.
  DATA: v_licno     TYPE  j_1iexcdtl-licno,
        v_licyr     TYPE  j_1iexcdtl-licyr,
        v_exnum     TYPE  j_1iexcnum,
        v_licname   TYPE  j_1ilicname,
        v_docyr     TYPE  j_1iexcdtl-docyr,
        v_docno     TYPE  thead-tdname,
        v_trntyp    TYPE  j_1itrntyp,
        v_licnoex   TYPE  j_1ilicnoex,
        v_addldata1 TYPE  j_1iaddata.

****READING EXNUM FROM IN_TAB
  READ TABLE in_tab INDEX 1 .
  v_trntyp = in_tab-value.

****READING DOCYR FROM IN_TAB
  READ TABLE in_tab INDEX 2 .
  v_docyr = in_tab-value.

****READING DOCNO FROM IN_TAB
  READ TABLE in_tab INDEX 3 .
  v_docno = in_tab-value.
*****CONVERSION FOR Excise NO.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_exnum
    IMPORTING
      output = v_exnum.
*****DATA FETCHING FOR LIC NUMBER****

  SELECT SINGLE addldata1
        FROM  j_1iexchdr
        INTO v_addldata1
        WHERE trntyp = v_trntyp
          AND   docno  = v_docno
          AND   docyr  = v_docyr.


*select single licno
*        from  J_1IEXCDTL
*        into V_licno
*        WHERE TRNTYP = V_TRNTYP
*          AND   DOCNO  = V_DOCNO
*          AND   DOCYR  = V_DOCYR.
*
*
*SELECT SINGLE LICNO
*              LICNAME
*              LICNOEX
*
*         FROM J_1ILICHDR
*         INTO (V_LICNO,
*               V_LICNAME,
*               V_LICNOEX )
*         WHERE  LICNO = V_LICNO.

*  ENDSELECT.

****PASSING lic DETAILS TO OUT_TAB------------------------*
  READ TABLE out_tab INDEX 1 . "WA_LINE_ITEM.
  out_tab-value = v_addldata1.
  MODIFY out_tab INDEX 1.

*    READ TABLE OUT_TAB INDEX 1 . "WA_LINE_ITEM.
*    OUT_TAB-VALUE = V_LICNO.
*    MODIFY OUT_TAB INDEX 1.

*    READ TABLE OUT_TAB INDEX 2 .
*    OUT_TAB-VALUE = V_LICNAME.
*    MODIFY OUT_TAB INDEX 2.
*
*    READ TABLE OUT_TAB INDEX 3 .
*    OUT_TAB-VALUE = V_LICNOEX.
*    MODIFY OUT_TAB INDEX 3.

ENDFORM.                    "GET_LIC

*&---------------------------------------------------------------------*
*&      Form  GET_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_value TABLES in_tab STRUCTURE itcsy
            out_tab STRUCTURE itcsy  .

  TYPES: BEGIN OF ty_j_1iexcdtl,
           trntyp TYPE j_1itrntyp,
           exnum  TYPE  j_1iexcnum,
           docyr  TYPE j_1idocuyr,
           docno  TYPE j_1idocno,
           zeile  TYPE j_1izeile,
           menge  TYPE j_1imenge,  "  Quantity mentioned in the excise invoice
           exbas  TYPE j_1iexcbas,   "  Excise Duty Base Amount
           exbed  TYPE j_1iexcbed,   "  Basic Excise Duty
         END OF ty_j_1iexcdtl.

  DATA: it_j_1iexcdtl TYPE STANDARD TABLE OF ty_j_1iexcdtl,
        wa_j_1iexcdtl TYPE ty_j_1iexcdtl.

****DATA DECLARATION.

  DATA: v_docyr   TYPE  j_1iexcdtl-docyr,
        v_docno   TYPE  thead-tdname,
        v_trntyp  TYPE  j_1itrntyp,
        v_zeile   TYPE  j_1izeile,
        v_menge   TYPE  char18,
        v_exbas   TYPE  char18,
        v_exbed   TYPE  char18,
        v_exnum   TYPE  j_1iexcnum,
        tot_menge TYPE  j_1imenge,
        tot_exbas TYPE  j_1iexcbas,
        tot_exbed TYPE  j_1iexcbed.
****READING TRNTYP FROM IN_TAB
  READ TABLE in_tab INDEX 1 .
  v_trntyp = in_tab-value.

****READING DOCYR FROM IN_TAB
  READ TABLE in_tab INDEX 2 .
  v_docyr = in_tab-value.

****READING DOCNO FROM IN_TAB
  READ TABLE in_tab INDEX 3 .
  v_docno = in_tab-value.
*****CONVERSION FOR Excise NO.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_exnum
    IMPORTING
      output = v_exnum.
*****DATA FETCHING FOR TOTAL VALUE****


  SELECT  trntyp
          exnum
          docyr
          docno
          zeile
          menge
          exbas
          exbed

  FROM j_1iexcdtl

  INTO CORRESPONDING FIELDS OF TABLE  it_j_1iexcdtl
*          (V_TRNTYP,
*           V_EXNUM,
*           V_DOCYR,
*           V_DOCNO,
*           V_ZEILE,
*           V_MENGE,
*           V_EXBAS,
*           V_EXBED)
  WHERE trntyp = v_trntyp
  AND   docno  = v_docno
  AND   docyr  = v_docyr.
*   ENDSELECT.

  LOOP AT it_j_1iexcdtl INTO wa_j_1iexcdtl.
* Total calc of Quantity of goods
    tot_menge = tot_menge + wa_j_1iexcdtl-menge.
* vALUE ASSIGNED TO A CHAR DATA TYPE VARIABLE TO DISPLAY IN OUT_TAB.
    v_menge = tot_menge.
* Total calc of Value
    tot_exbas = tot_exbas + wa_j_1iexcdtl-exbas.
    v_exbas  = tot_exbas.
* Total cal of Duty amount.
    tot_exbed = tot_exbed + wa_j_1iexcdtl-exbed.
    v_exbed = tot_exbed.
  ENDLOOP.
****PASSING TOT_QTY TO OUT_TAB------------------------*
  READ TABLE out_tab INDEX 1 . "TOTAL QUANTITY.
  out_tab-value = v_menge.
  MODIFY out_tab INDEX 1.

****PASSING TOT_QTY TO OUT_TAB------------------------*
  READ TABLE out_tab INDEX 2 . "TOTAL vALUE.
  out_tab-value = v_exbas.
  MODIFY out_tab INDEX 2.

****PASSING TOT_QTY TO OUT_TAB------------------------*
  READ TABLE out_tab INDEX 3 . "TOTAL DUTY AMOUNT.
  out_tab-value = v_exbed.
  MODIFY out_tab INDEX 3.

ENDFORM.                    "GET_VALUE

"..................
FORM get_excise_address TABLES in_tab  STRUCTURE itcsy
                               out_tab STRUCTURE itcsy.
  DATA : v_adrnr      TYPE j_1iaddr_key,
         v_add_no     TYPE j_1iaddr_no,
         v_name1       TYPE ad_name1    , " Name 1
         v_name2       TYPE ad_name2    , " Name 2
         v_city1       TYPE ad_city1    , " City
         v_post_code1 TYPE ad_pstcd1  , " City postal code
         v_street     TYPE ad_street  , " Street
         v_str_suppl1 TYPE ad_strspp1 , " Street 2
         v_str_suppl2 TYPE ad_strspp2 , " Street 3

         str          TYPE string.

  CLEAR : v_adrnr, v_name1, v_name2, v_city1, v_post_code1, v_street, v_str_suppl1, v_str_suppl2, str.

  READ TABLE in_tab INDEX 1.
  v_add_no = in_tab-value.

  IF NOT v_add_no IS INITIAL.
    SELECT SINGLE cam_handle
      FROM j_1iaddres
      INTO v_adrnr
      WHERE address_no = v_add_no.
    IF sy-subrc = 0.
      SELECT SINGLE name1
                    name2
                    city1
                    post_code1
                    street
                    str_suppl1
                    str_suppl2
        FROM adrc
        INTO (v_name1
            , v_name2
            , v_city1
            , v_post_code1
            , v_street
            , v_str_suppl1
            , v_str_suppl2  )
        WHERE addrnumber = v_adrnr.
      IF sy-subrc = 0.
        READ TABLE in_tab INDEX 2. " Flag to determine inclusion of name in the address-text
        IF in_tab-value = flg_false.
          CLEAR : v_name1, v_name2.
        ENDIF.

        CLEAR str.
        CONCATENATE v_name1 v_name2 v_str_suppl1 v_str_suppl2 INTO str SEPARATED BY ' '.
        CONDENSE str.
        READ TABLE out_tab INDEX 1.
        out_tab-value = str.
        MODIFY out_tab INDEX 1.

        READ TABLE in_tab INDEX 3.
        IF v_add_no = '002' AND in_tab-value = cnst_short.
          CLEAR str.
          str = v_post_code1.
*          CONCATENATE V_CITY1 V_POST_CODE1 INTO STR SEPARATED BY ' '.
          CONDENSE str.
          READ TABLE out_tab INDEX 2.
          out_tab-value = str.
          MODIFY out_tab INDEX 2.
        ELSE.
          CLEAR str.
*          CONCATENATE V_STREET V_CITY1 V_POST_CODE1 INTO STR SEPARATED BY ' '.
          CONCATENATE v_city1 v_post_code1 INTO str SEPARATED BY ' '.
          CONDENSE str.
          READ TABLE out_tab INDEX 2.
          out_tab-value = str.
          MODIFY out_tab INDEX 2.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

**"...................
**
**
***PERFORM GET_TOTAL_DUTY
***    USING v_EXBED
***    USING v_ECS&
***    USING v_EXADDTAX1 ty
***    CHANGING &ITEM_TOT_DUTY&
***ENDPERFORM
