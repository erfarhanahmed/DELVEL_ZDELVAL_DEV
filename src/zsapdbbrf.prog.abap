*&---------------------------------------------------------------------*
*& Report ZSAPDBBRF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSAPDBBRF DEFINING DATABASE brf MESSAGE-ID fr.
*-----------------------------------------------------------------------
*        Datenbankstruktur
*-----------------------------------------------------------------------

* WARNING: DATA STRUCTURES OF INDICES HAVE BEEN APPENDED !
* MANUALLY CHANGED DATA STRUCTURES MAY BE FALSE !!!!!!!!!!

TABLES: b0sg, bosg,
          bkdf,
          bkpf, vbkpf,
          bseg,bsegh,bsega,bsec,bsed,
          vbsegk, vbsegd, vbsegs, vbsega, vbsec,
           bset, vbset,
          kna1,
            knbk,bnka,
            knb1,
              knb4,
              knb5,
              knkk,
              knc1,
              knc3,
          lfa1,
            lfbk,                      "(BNKA)
            lfb1,
              lfb5,
              lfc1,
              lfc3,
          ska1,skat,
            skb1,
              skc1a,glt0,
              skc1c.

TABLES: *bseg.
TABLES: faglfreesel.

*-----------------------------------------------------------------------
*        Tabellen
*-----------------------------------------------------------------------
TABLES: t001,                          "Buchungskreise
        t004,                          "Kontenplaene
        tr01,                          "Archivierung
        t070,                          "FI Belegarch. - Beleglaufzeiten
        t071,                          "FI Belegarch. - Kontolaufzeiten
        dd03l,
        dd03p.                         "Technische Felddaten
TABLES: sscrfields.
TABLES: taltwar.                       "<<<< euro

*-----------------------------------------------------------------------
*        Unicode Utitilities
*-----------------------------------------------------------------------
CLASS cl_abap_char_utilities DEFINITION LOAD.

*---------------------------------------------------------------------
*        Flex GL
*---------------------------------------------------------------------
* fields
DATA: g_glflex_active TYPE boole_d.
DATA: g_glflex_act_cc TYPE boole_d.
DATA: g_rldnr         TYPE rldnr.
DATA: g_rldnr_exp     TYPE rldnr.
DATA: g_lead_rldnr    TYPE rldnr.
DATA: g_rec_entry_docs TYPE boole_d.
DATA: g_act_bukrs     LIKE t001-bukrs.
DATA: g_act_bukrs_req TYPE boole_d.
* tables
DATA: gt_ldgrp        LIKE fagl_tldgrp OCCURS 0 WITH HEADER LINE.
DATA: gt_glt0         LIKE glt0        OCCURS 0.
DATA: gt_act_bukrs    TYPE fagl_bukrs_tab.
* Ranges
RANGES:
      gr_rldnr        FOR  bkpf-rldnr,
      gr_ldgrp        FOR  bkpf-ldgrp,
      gr_act_bukrs    FOR  t001-bukrs,
      gr_budat        FOR  bkpf-budat.
* Constants
CONSTANTS:
      fagl_bhdgd_rldnr(16) TYPE c VALUE 'FAGL_BHDGD_RLDNR'.

*---------------------------------------------------------------------
*        Tabellen fuer interne Selektionen
*---------------------------------------------------------------------
RANGES: br_bstat FOR bkpf-bstat,
        zw_bstat FOR bkpf-bstat,
        xx_ktopl FOR ska1-ktopl,
        xx_bukrs FOR skb1-bukrs.

*-----------------------------------------------------------------------
* Alle notwendigen Datendeklarationen zum Lesen eines Beleges aus der
* Archivdatei
*-----------------------------------------------------------------------
DATA:   sys_object       LIKE arch_obj-object  VALUE  'FI_DOCUMNT'.

DATA:   archive_handle   LIKE sy-tabix,              "Archiv-Handle
        arch_obj_id      LIKE bkpf_key,              "ID im Archivfile
        arch_obj_offset  LIKE abkpf-offst,           "Offset im Archfile
        group_xread      LIKE farc_xread,            "table selection
        readarchparms    LIKE  rfcu_fidoc,           "Parms to read arch
        xreadcust        LIKE  datatype-boolean      "do not read parms
                         VALUE space,                "   from cust
        flag             TYPE c.                     "Beleg übernehmen?

* ======> Interne Daten zur Ablage einer Archivgruppe <=================
DATA: yarch LIKE archivinfo.      "Akt. Archiv
DATA: BEGIN OF yarchset OCCURS 0.
        INCLUDE STRUCTURE yarch.
DATA: END OF yarchset.
DATA: yarchset_cnt TYPE p.
* ======> Interne Daten zur Ablage einer Archivgruppe END<==============

DATA: yabkpf    TYPE TABLE OF abkpf,
      ybseg     TYPE TABLE OF bseg,
      ybsec     TYPE TABLE OF bsec,
      ybsed     TYPE TABLE OF bsed,
      ybset     TYPE TABLE OF bset,
      wa_ybkpf  TYPE bkpf,
      wa_yabkpf TYPE bkpf,
      wa_ybseg  TYPE bseg,
      wa_ybset  TYPE bset.

DATA: ybseg_add    TYPE TABLE OF bseg_add,
      wa_ybseg_add TYPE bseg_add.

DATA: yfaglflexa    TYPE REF TO data,
      ybseg_flex    TYPE fagl_t_bseg_ext,
      wa_ybseg_flex TYPE fagl_bseg_ext.
*-----------------------------------------------------------------------
* End der notwendige Datendeklarationen zum Lesen eines Beleges aus
* der Archivdatei
*-----------------------------------------------------------------------

*
* Definitionen fuer Belege sequentiell lesen
*
DATA:   BEGIN OF xbkpf OCCURS 1000.
        INCLUDE STRUCTURE bkpf.
DATA:   END OF xbkpf.

DATA:   BEGIN OF xbseg OCCURS 10.
        INCLUDE STRUCTURE bseg.
DATA:   END OF xbseg.

DATA:   BEGIN OF xbsec OCCURS 10.
        INCLUDE STRUCTURE bsec.
DATA:   END OF xbsec.

DATA:   BEGIN OF xbsed OCCURS 10.
        INCLUDE STRUCTURE bsed.
DATA:   END OF xbsed.

DATA:    BEGIN OF xbset OCCURS 10.
        INCLUDE STRUCTURE bset.
DATA:    END OF xbset.

DATA:    BEGIN OF bkpf_where OCCURS 10.
        INCLUDE STRUCTURE rsdswhere.
DATA:    END OF bkpf_where.

DATA:    faglfreesel_where LIKE rsdswhere OCCURS 10.

DATA:    test_fields LIKE rsfs_struc OCCURS 10 WITH HEADER LINE.
DATA:    bkpf_fields LIKE rsfs_struc OCCURS 10,
         bseg_fields LIKE rsfs_struc OCCURS 10 WITH HEADER LINE,
         lfa1_fields LIKE rsfs_struc OCCURS 10,
         lfb1_fields LIKE rsfs_struc OCCURS 10,
         kna1_fields LIKE rsfs_struc OCCURS 10,
         knb1_fields LIKE rsfs_struc OCCURS 10,
         ska1_fields LIKE rsfs_struc OCCURS 10,
         skb1_fields LIKE rsfs_struc OCCURS 10.

*----------------------------------------------------------------------
*        Sonstige Datendeklaration zur Verarbeitung von Belegdaten
*----------------------------------------------------------------------

*------- SAVE-FELDER für KEY-Begriffe --------------------------------*
DATA:    save_bankl LIKE knbk-bankl,
         save_banks LIKE knbk-banks,
         save_belnr LIKE bkpf-belnr,
         save_bukrs LIKE bkpf-bukrs,
         save_bstat LIKE bkpf-bstat,
         save_buzei LIKE bseg-buzei,
         save_gjahr LIKE bkpf-gjahr,
         save_ktopl LIKE ska1-ktopl,
         save_kunnr LIKE KNA1-KUNNR, " brdkunnr,
         save_lifnr LIKE LFA1-LIFNR , "brklifnr,
         save_saknr LIKE SKA1-SAKNR,  "brssaknr,
         save_subrc LIKE sy-subrc,
         save_waers LIKE skb1-waers,
         vorbel.

*------- Selektierte Buchungskreise mit ihren Kontenplaenen ----------*
DATA:    BEGIN OF buktab OCCURS 10,
           bukrs LIKE t001-bukrs,
           ktopl LIKE t001-ktopl,
         END OF buktab.

*------- Selektierte Kontenplaene ------------------------------------*
DATA:    BEGIN OF kpltab OCCURS 10,
           ktopl LIKE t001-ktopl,
         END OF kpltab.

*------- XSKAT  - Tabelle zur Bereitstellung der Sachkonten- ---------*
*                 bezeichnung pro Kontenplan
DATA:    BEGIN OF xskat OCCURS 100.
        INCLUDE STRUCTURE skat.
DATA:    END OF xskat.

*------- XSKC1A - Tabelle zu Sammeln der Verkehrszahlen pro ----------*
*                 Konto, Buchungskreis, Jahr alle Gesch.Bereiche in HW
DATA:    BEGIN OF xskc1a OCCURS 50.
        INCLUDE STRUCTURE skc1a.
DATA:    END   OF xskc1a.

*------- XSKC1C - Tabelle zu Sammeln der Verkehrszahlen pro ----------*
*                 Konto, Buchungskreis, Jahr alle Gesch.Bereiche
DATA:    BEGIN OF xskc1c OCCURS 50.
        INCLUDE STRUCTURE skc1c.
DATA:    END   OF xskc1c.

*------- Key-Aufbau zum Lesen GLT0 -----------------------------------*
DATA: BEGIN OF glkey,
        rldnr LIKE glt0-rldnr,         " Ledger-Nr  fix '00'
        rrcty LIKE glt0-rrcty,         " Satztyp    fix '0'
        rvers LIKE glt0-rvers,         " Version    fix '001'
        bukrs LIKE glt0-bukrs,         " Bukreis    aus Eingabe
        racct LIKE glt0-racct,         " Konto      aus Eingabe
        rtcur LIKE glt0-rtcur,         " Waehrung   aus SKB1-WAERS
        drcrk LIKE glt0-drcrk,         " S/H-Kennz  fix 'S'
        rpmax LIKE glt0-rpmax,         " Bis-Perioe fix '16'
      END   OF glkey.

* Felder fuer Hilfsberechnungen
* -----------------------------
*data:   brarkey_lc(2) type c value '0',    "Line-Count Tab. BRARKEY
DATA:  "  brarkey_lc(3) TYPE c VALUE '0',    "<<<< note 72200
         database(1)   TYPE c VALUE 'B',
         csr_xbkpf     LIKE sy-tabix,
         cursor_t      LIKE sy-tabix,
         eof_xbkpf(1)  TYPE c,
         i             LIKE sy-tabix,
         koart         LIKE bseg-koart,
         refe1         LIKE skc1a-um01k,
         refe2         LIKE skc1a-um01k,
         refe3         LIKE skc1a-um01k,
         retcode       LIKE sy-subrc VALUE '0',
         sel_bset(1)   TYPE c,
         skip_bseg(1)  TYPE c,
         wert          VALUE '1'.

* Maximalwert
*------------
DATA: highval(20) TYPE c.
DATA: BEGIN OF hexff,
        hex(20) TYPE x VALUE 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF',
      END OF  hexff.
DATA: BEGIN OF l_ldgrp,
            ldgrp LIKE fagl_tldgrp-ldgrp,
      END OF l_ldgrp.
DATA: lt_ldgrp LIKE l_ldgrp OCCURS 0 WITH HEADER LINE.
DATA: lt_rldnr TYPE fagl_rldnr_tab.
DATA: BEGIN OF l_ledger,
            rldnr TYPE rldnr,
      END OF l_ledger.
DATA: lt_ledger LIKE l_ledger OCCURS 0 WITH HEADER LINE.
DATA: ld_bukrs LIKE bkpf-bukrs.
*------ Hilfsfelder fuer Statistik
DATA:    k(8)         TYPE p,
         l(8)         TYPE p,
         cnt_bkpf     LIKE sy-tabix,
         cnt_bseg     LIKE sy-tabix,
         cnt_bsegsel  LIKE sy-tabix,
         time1        LIKE sy-uzeit,
         time2        LIKE sy-uzeit.

DATA: g_balv TYPE boolean VALUE 'X'. "usa BALV for message log

*------ expiring currencies:
DATA: gd_waers_save   TYPE waers,
      gd_expcur_flag  TYPE c.

*------- Buffer table for authority checks F_BKPF_BED/K/S:
DATA: BEGIN OF gs_auth_bkpf_bex,
        acct_type      LIKE rfpos-koart,
        acct_id        LIKE rfpos-konto,
        comp_code      LIKE rfpos-bukrs,
        rcode          LIKE sy-subrc,
      END OF gs_auth_bkpf_bex.
DATA: gt_auth_bkpf_bex LIKE HASHED TABLE OF gs_auth_bkpf_bex
        WITH UNIQUE KEY acct_type acct_id comp_code.

*------- Counter for failed authority checks on line items:
DATA: cnt_no_auth(7) TYPE n.

*------- Hana Specifics
DATA: gv_in_memory TYPE abap_bool,
      gv_cursor    TYPE i,
      gt_fin_glpos TYPE TABLE OF fin_s_glpos,
      go_ldb       TYPE REF TO cl_fin_ldb_brf.

*------- Makrodefinitionen
DEFINE sel_vbseg.
  if vbkpf-koars ca '&1'.
    select * from vbseg&1 where
                         ausbk =  save_bukrs
                     and belnr =  save_belnr
                     and gjahr =  save_gjahr.
      clear xbseg.
      move-corresponding vbseg&1 to xbseg.
      if '&1' = 'S'.
        xbseg-hkont = vbsegs-saknr.
        xbseg-projk = vbsegs-ps_psp_pnr.
      elseif '&1' = 'A'.
        xbseg-projk = vbsega-ps_psp_pnr.
      endif.
      xbseg-koart = '&1'.
      cnt_bseg = cnt_bseg + 1.
      append xbseg.
    endselect.
  endif.
END-OF-DEFINITION.

DEFINE build_dyn_range.
  data begin of range_&1 occurs 10.
          include structure rsdsselopt.
  data end   of range_&1.
  field-symbols <f_&1>.
END-OF-DEFINITION.

DEFINE asgn_dyn_range.
  describe table l_ds_frange-selopt_t lines n_range.
  if n_range > 0.
    copy l_ds_frange-selopt_t to range_&1.
    assign table field (varname) to <f_&1>.
    range_cnt = &1.
    cnt = cnt + 1.
  endif.
END-OF-DEFINITION.

DEFINE check_dyn_range.
  check <f_&1> in range_&1.
END-OF-DEFINITION.

*------ Felder und Tabellen fuer dynamische Selektion
DATA l_ds_range   TYPE rsds_range.

build_dyn_range: 01, 02, 03, 04, 05, 06, 07, 08, 09, 10.

DATA range_cnt TYPE i.

DATA BEGIN OF my_range OCCURS 10.
        INCLUDE STRUCTURE rsdsselopt.
DATA END   OF my_range.

FIELD-SYMBOLS <f>.

* tpc
DATA: gd_tpc_check     TYPE char1 VALUE space.
DATA: gd_tpc_check_sel TYPE char1 VALUE space.
DATA: gd_tpc_log       TYPE char1 VALUE space.

* Switch Check for EHP4
DATA: gd_ehp4_switch_on TYPE boole_d.

INCLUDE Zrfdbexpc.
INCLUDE Zrfdbinclud1.                                        "40C
INCLUDE Zrfdbeuro.                      "<<<< euro
INCLUDE Zrfdb_brf_add_auth_bkpf.

types: s_fields LIKE rsfs_struc,         "130514 -> note 2017063
       t_fields type table of s_fields.  "130514 -> note 2017063
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*                                                                      *
*                    Datenbank - FORM - Routinen                       *
*                                                                      *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*    FORM INIT                                                         *
*----------------------------------------------------------------------*

FORM init.

* tpc
  DATA ld_return TYPE char1.

* Belegselektion ?           'X' = JA , ' ' = NEIN
  b0sg-xldbr = 'X'.
* Debitorenstammselektion ?
  b0sg-xldds = ' '.
* Kreditorenstammselektion ?
  b0sg-xldks = ' '.
* Sachkontenstammselektion ?
  b0sg-xldss = ' '.
* CPD-Daten ?
  b0sg-xbsec = 'X'.
* Wechseldaten ?
  b0sg-xbsed = 'X'.
* normale Belege ?
  b0sg-xstan = 'X'.
* Musterbelege   ?
  b0sg-xstam = ' '.
* Dauerbuchungsurbelege ?
  b0sg-xstad = ' '.
* Statistische Belege ?
  b0sg-xstas = ' '.
* Vorab erfasste Belege ?
  b0sg-xstav = ' '.
* Ausgleichbelege ?                                          "<<<< 40A
  b0sg-xstaa = ' '.                                         "<<<< 40A
* zurückgenommene Ausgleichbelege ?                          "<<<< 40A
  b0sg-xstab = ' '.                                         "<<<< 40A

* Maximalwert in Abhaengigkeit von ASCII oder EBCDIC
  highval = cl_abap_char_utilities=>maxchar.

  sscrfields-functxt_05 = text-src.                         "997117
  xusedb   = 'X'.                                           "997117
  xusear   = ' '.                                           "997117
  xemucnv  = 'X'.                                           "997117
  archobj  = 'FI_DOCUMNT'.                                  "997117

  CALL FUNCTION 'AS_DATASOURCE_INIT'                        "997117
    EXPORTING                                               "997117
      i_report       = sy-cprog                             "997117
      i_reporttype   = space                                "997117
    IMPORTING                                               "997117
      e_use_database = xusedb                               "997117
      e_use_archive  = xusear                               "997117
      e_use_infosys  = xuseas.                              "997117

* -- what data to read
  group_xread-xbkpf    = 'X'.
  group_xread-xbseg    = 'X'.
  group_xread-xbsegc   = 'X'.
  group_xread-xbset    = 'X'.
  group_xread-xttxi    = 'X'.
  group_xread-xttxy    = 'X'.
  group_xread-xetxdch  = 'X'.
  group_xread-xetxdci  = 'X'.
  group_xread-xetxdcj  = 'X'.
  group_xread-xbvor    = 'X'.
  group_xread-xbsec    = 'X'.
  group_xread-xbsed    = 'X'.
  group_xread-xbse_clr = 'X'.
  group_xread-xagko    = 'X'.
  group_xread-xstxh    = 'X'.
  group_xread-xstxl    = 'X'.
  group_xread-xthead   = 'X'.
  group_xread-xtline   = 'X'.
  group_xread-xcdhdr   = ' '.
  group_xread-xcdpos   = ' '.
  group_xread-xcdshw   = ' '.

* -- preset special customizing for archive access
  readarchparms-xaskarch   = ' '.           "no popups
  readarchparms-srchstrats = 4.             "full archive scan
  readarchparms-srchstratm = 4.             "full archive scan
  readarchparms-history    = 99.            "read all old docs
  readarchparms-xeuroconv  = xemucnv.       "emu conversion from DTIN

* check date(tpc)
  CALL FUNCTION 'FI_CHECK_DATE'
    EXPORTING
      i_bukrs           = space
      i_user            = sy-uname
      i_program         = 'SAPDBBRF'
    IMPORTING
      e_return          = ld_return
    EXCEPTIONS
      no_authority_prog = 1
      no_authority_date = 2
      wrong_parameter   = 3
      OTHERS            = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF ld_return = 1.
    gd_tpc_check = 'X'.
*   log function installed: due to ABA support package
    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = 'CA_WRITE_LOG'
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.
    IF sy-subrc EQ 0.
*       user is tax auditor and ca_write_log is activ
      gd_tpc_log = 'X'.
    ENDIF.
  ELSE.
    gd_tpc_check = space.
  ENDIF.

* expiring currencies relevant for this process?
  CALL FUNCTION 'CURRENCY_CHECK_FOR_PROCESS'
    EXPORTING
      process                = 'SAPDBBRF'
    EXCEPTIONS
      process_not_maintained = 1
      OTHERS                 = 2.
  IF sy-subrc = 0.
    gd_expcur_flag = 'X'.
  ENDIF.

* Default value for exchange date at selection screen.
  IF excdt IS INITIAL.
    excdt = sy-datlo.
  ENDIF.

* flex gl active ?
  CALL FUNCTION 'FAGL_CHECK_GLFLEX_ACTIVE'
    IMPORTING
      e_glflex_active = g_glflex_active
    EXCEPTIONS
      error_in_setup  = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
    MESSAGE ID   sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* ccodes active ?
  IF g_glflex_active IS INITIAL.
    CALL FUNCTION 'FAGL_BUKRS_ACTIVE_IN_CLIENT'
      IMPORTING
        e_glflex_active = g_glflex_act_cc.

    IF NOT ( g_glflex_act_cc IS INITIAL ).
*.... get the active ccodes
      CALL FUNCTION 'FAGL_GET_ACT_BUKRS_FOR_GLFLEX'
        IMPORTING
          et_act_bukrs = gt_act_bukrs.
*.... fill active ccodes into range tab
      gr_act_bukrs-sign   = 'I'.
      gr_act_bukrs-option = 'EQ'.
      LOOP AT gt_act_bukrs INTO gr_act_bukrs-low.
        APPEND gr_act_bukrs.
      ENDLOOP.
    ENDIF.
  ENDIF.

* Begin of note 1109919
  IF NOT g_glflex_active IS INITIAL.
    DATA: l_lead_rldnr TYPE rldnr.
    CALL FUNCTION 'FAGL_GET_LEADING_LEDGER'
      IMPORTING
        e_rldnr   = l_lead_rldnr
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc = 0.
      br_rldnr-sign   = 'I'.
      br_rldnr-option = 'EQ'.
      br_rldnr-low    = l_lead_rldnr.
      APPEND br_rldnr.
    ENDIF.
  ENDIF.
* End of note 1109919

* Check if the switch is FAGL_FIN_GL_2_RS on

  CALL METHOD cl_fagl_switch_check=>fagl_fin_gl_2_rs
    RECEIVING
      rv_active = gd_ehp4_switch_on.

  PERFORM set_in_memory_mode.

* initial set of field xhana
  PERFORM set_ldb_mode USING abap_true.

ENDFORM.                    "INIT


*----------------------------------------------------------------------*
*    FORM PBO - Selection Screen: Process before output
*
*    Funktion neu implementiert im Rahmen ADK Umstellung  FOH K11K113040
*    - Abspeicherung der BRARKEY in separater Tabelle nicht mehr
*      notwendig
*----------------------------------------------------------------------*
FORM pbo.
*  DESCRIBE TABLE brarkey LINES brarkey_lc.
*  IF brarkey_lc > 0.
*    MOVE text-006 TO brarmssg.
*  ELSE.
*    CLEAR brarmssg.
*  ENDIF.

  IF g_glflex_active IS INITIAL.
*   FlexGL is not active - make RLDNR invisible
    LOOP AT SCREEN.
      IF screen-group1 = 'LDG'.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
*   FlexGL is active - make BR_SEQ invisible
    LOOP AT SCREEN.
      IF screen-group1 = 'SEQ'.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  LOOP AT SCREEN.
    IF screen-group1 = '_BR'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

*************EHP4
**** No Switch because this field should be depressed in all reports
* make LDGRP invisible
  LOOP AT SCREEN.
    IF screen-group1 = 'GRP'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
*************EHP4

  PERFORM auth_check_for_blart_gsber CHANGING au_blart au_gsber. "<<<au40
  PERFORM modify_screen_for_euro USING sy-cprog.                 "<<<euro

* " -- DTIN: prepare selection screen         "DTIN            "997117
* perform data_input_screen.                  "DTIN            "997117
ENDFORM.                    "PBO

*----------------------------------------------------------------------*
*    FORM PAI - Selection Screen: Process after input
*----------------------------------------------------------------------*
FORM pai USING fname mark.
  DATA: ld_progname TYPE progname,                          "997117
        lt_objects TYPE as_t_archobj.                       "997117
  DATA: ld_ledger LIKE bkpf-ldgrp.
  DATA: ld_count TYPE i.

  CHECK mark = space.

  IF NOT ( g_glflex_active IS INITIAL )
  OR NOT ( g_glflex_act_cc IS INITIAL ).
*.. flexGL is active or partly active
*.. clear BR_SEQ; it could be marked in old variants
    CLEAR br_seq.              " note 932146
  ENDIF.

*  " -- do DTIN selection                        "DTIN         "997117
*  perform change_datainput.                     "DTIN         "997117
  readarchparms-xeuroconv  = xemucnv.       "emu conversion from DTIN

  IF    sscrfields-ucomm = 'ONLI'          " Online submit     "997117
     OR sscrfields-ucomm = 'PRIN'          " Online submit and print
     OR sscrfields-ucomm = 'SJOB'          " Submit as background job
     OR sscrfields-ucomm = 'SPOS'          " Save as Variant
     OR sscrfields-ucomm = 'SAVE'          " Variant maintanance
     OR sscrfields-ucomm = 'EXEX'          " Application execute
     OR sscrfields-ucomm = space           " ENTER
     OR sy-ucomm = 'EXEX'                  " Application execute
     or SSCRFIELDS-UCOMM = 'CXSP'.         " search help (note 1605999)

*------- reset archive message status --------------------------------*
    IF  fname = 'BR_BUKRS'
     OR fname = 'BR_GJAHR'
     OR fname = 'BRARCHIV'.
      CLEAR arch_mssg_sent.
    ENDIF.
*    CASE fname.
*      WHEN: 'BR_BUKRS',  'BR_GJAHR' , 'BRARCHIV'.
*        CLEAR arch_mssg_sent.
*    ENDCASE.

    CASE fname.
*------- Buchungskreis -----------------------------------------------*
      WHEN 'BR_BUKRS'.
        IF auth_buk IS INITIAL.                             "<<< 31H
          CALL FUNCTION 'BUKRS_AUTHORITY_CHECK'
            EXPORTING
              xdatabase = database
            TABLES
              xbukreis  = br_bukrs.
        ENDIF.                                              "<<< 31H

      WHEN '*'.
*-------check date (tpc)---------------------------------------------
        IF gd_tpc_check = 'X'.
          PERFORM check_date.
        ENDIF.


*------- Berechtigungsprüfung für Kontoarten K/S/D.
        retcode = 0.
        PERFORM authority_check_koart.
        IF retcode <> 0.
          MESSAGE e813.
        ENDIF.

*------- Belege sequentiell nicht im Online
        IF sy-batch IS INITIAL.
          IF sy-ucomm = 'ONLI' OR sy-ucomm = 'PRIN'.
            DESCRIBE TABLE br_belnr LINES i.
            IF i = 0
            AND br_seq NE space.
              MESSAGE e820.
            ENDIF.
          ENDIF.
        ENDIF.


        IF NOT ( g_glflex_active IS INITIAL )
        OR NOT ( g_glflex_act_cc IS INITIAL ).

*
*---------------------------------------------------------*
*    Switch Section 1 EHP4                                *
*---------------------------------------------------------*

* get leading ledger
          CALL FUNCTION 'FAGL_GET_LEADING_LEDGER'
            IMPORTING
              e_rldnr   = g_lead_rldnr
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.

          IF sy-subrc <> 0.
            MESSAGE ID   sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.

          IF NOT br_rldnr[] IS INITIAL.                        "1506335
            IF br_rldnr-low IS INITIAL.                        "1506335
              MESSAGE e598.                                    "1506335
            ENDIF.                                             "1506335
            CALL FUNCTION 'FAGL_CHECK_IF_LEDGER_IS_GLFLEX'     "1506335
              EXPORTING                                        "1506335
                i_rldnr   = br_rldnr-low                       "1506335
              EXCEPTIONS                                       "1506335
                not_found                     = 1              "1506335
                no_glflex_ledger              = 2.             "1506335
            IF sy-subrc <> 0.                                  "1506335
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno"1506335
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4."1506335
            ENDIF.                                             "1506335
          ENDIF.                                               "1506335
********Select-Criterion with Leger Group not active
          IF NOT b0sg-xldgrp = 'X'.
*...... flexGL is active or partly active
            IF br_rldnr[] IS INITIAL.
*........ set Ledger
              REFRESH gr_rldnr.
              gr_rldnr-sign   = 'I'.
              gr_rldnr-option = 'EQ'.
*........ set leading ledger
              gr_rldnr-low = g_lead_rldnr.
              g_rldnr_exp = g_lead_rldnr.                      "1967139
              APPEND: gr_rldnr.
*........ set ledger space always
              CLEAR:  gr_rldnr-low.
              APPEND: gr_rldnr.
*........ save leading ledger
              g_rldnr = g_lead_rldnr.
            ELSE.
              IF br_rldnr-low IS INITIAL.                   "1109919
                MESSAGE e598.                               "1109919
              ENDIF.                                        "1109919
              IF ( br_rldnr-sign   NE 'I'                   "1109919
                   OR br_rldnr-option NE 'EQ' )             "1109919
                 AND NOT br_rldnr-low IS INITIAL.           "1109919
                MESSAGE e599.                               "1109919
              ENDIF.                                        "1109919
              g_rldnr_exp = br_rldnr-low.
              gr_rldnr = br_rldnr.
              APPEND gr_rldnr.
*........ set ledger space always
              CLEAR:  gr_rldnr-low.
              APPEND: gr_rldnr.
*........ save selected ledger
              g_rldnr = br_rldnr-low.
*........ check whether CC, RLDNR and FY_Variant make sense
              PERFORM fisc_year_variant_check TABLES gr_budat
                                              USING  g_rldnr.
            ENDIF.
*Select-Criterion Ledger Group is active
          ELSE.
            IF NOT br_rldnr[] IS INITIAL AND br_ldgrp[] IS INITIAL.
              REFRESH gr_rldnr.
              IF br_rldnr-low IS INITIAL.
                MESSAGE e598.
              ENDIF.
              IF ( br_rldnr-sign   NE 'I'
                OR br_rldnr-option NE 'EQ' )
                AND NOT br_rldnr-low IS INITIAL.
                MESSAGE e599.
              ENDIF.
              g_rldnr_exp = br_rldnr-low.
              gr_rldnr = br_rldnr.
              APPEND gr_rldnr.
*........ .....set ledger space always
              CLEAR:  gr_rldnr-low.
              APPEND: gr_rldnr.
*........      save selected ledger
              g_rldnr = br_rldnr-low.
*........      check whether CC, RLDNR and FY_Variant make sense
              PERFORM fisc_year_variant_check TABLES gr_budat
                                              USING  g_rldnr.

            ELSEIF NOT br_rldnr[] IS INITIAL AND NOT br_ldgrp[] IS INITIAL.
              MESSAGE e611.

            ELSEIF NOT br_ldgrp[] IS INITIAL.
              SELECT * FROM fagl_tldgrp
              INTO CORRESPONDING FIELDS OF TABLE lt_ldgrp
              WHERE ldgrp IN br_ldgrp.
              LOOP AT lt_ldgrp.
*...........select all ledgers in Ledger Group
                CALL FUNCTION 'FAGL_GET_LEDGER_FROM_GROUP'
                  EXPORTING
                    i_ldgrp              = lt_ldgrp-ldgrp
                  IMPORTING
                    et_ledger            = lt_rldnr
                  EXCEPTIONS
                    error_in_ledgergroup = 1
                    OTHERS               = 2.
                LOOP AT lt_rldnr INTO lt_ledger-rldnr.
                  APPEND  lt_ledger.
                ENDLOOP.
              ENDLOOP.
            ENDIF.
          ENDIF.


*------ SWITCH EHP4 Option 2 ------------------------------------------------*
*       Check assignment between Company Code and Ledger                     *
*       Rebuild br_bukrs                                                     *
*----------------------------------------------------------------------------*
          IF gd_ehp4_switch_on = 'X'. "Do only if BF for EHP4 is active
            LOOP AT br_rldnr WHERE low <> g_lead_rldnr AND low <> ' '.
              ld_ledger = br_rldnr-low.
            ENDLOOP.
            IF NOT ld_ledger IS INITIAL.
              REFRESH buktab.
              IF NOT br_bukrs[] IS INITIAL.
                SELECT bukrs FROM t001 INTO buktab-bukrs
                             WHERE bukrs IN br_bukrs.
                  APPEND buktab.
                ENDSELECT.
*** delete the company code which are not assigned to the given ledger from
*** selection option br_bukrs.
                LOOP AT buktab.
                  CLEAR ld_count.
                  SELECT COUNT(*) FROM t882g INTO ld_count
                       WHERE rldnr = ld_ledger
                       AND   rbukrs = buktab-bukrs.
                  IF ld_count < 1.
                    DELETE buktab.
                  ENDIF.
                ENDLOOP.
*              rebuild br_bukrs:
                IF buktab[] IS INITIAL.                        "1918696
                  MESSAGE E597.                                "1918696
                ELSE.                                          "1918696
                  REFRESH br_bukrs[].                          "1918696
                  LOOP AT buktab.                              "1918696
                    br_bukrs-sign = 'I'.                       "1918696
                    br_bukrs-option = 'EQ'.                    "1918696
                    br_bukrs-low = buktab-bukrs.               "1918696
                    APPEND br_bukrs.                           "1918696
                  ENDLOOP.                                     "1918696
                ENDIF.                                         "1918696
              ELSE.
                SELECT rbukrs FROM t882g INTO ld_bukrs
                              WHERE rldnr = ld_ledger.
* build up selection option br-bukrs according to the given ledger
                  br_bukrs-sign = 'I'.
                  br_bukrs-option = 'EQ'.
                  br_bukrs-low = ld_bukrs.
                  APPEND br_bukrs.
                ENDSELECT.
              ENDIF.
            ENDIF.
          ENDIF.

*-------END SWITCH OPTION 2 EHP4 --------------------------------------------*

*...... authority check for rldnr
          REFRESH buktab.
          SELECT bukrs FROM t001 INTO buktab-bukrs
                                WHERE bukrs IN br_bukrs.
            APPEND buktab.
          ENDSELECT.
          IF b0sg-xadoc IS INITIAL AND auth_ldr IS INITIAL. "1035181
            LOOP AT buktab.
*****************************************************************************
*              EHP4 Switch Section Begin                                    *
*****************************************************************************

              IF gd_ehp4_switch_on = 'X'. "BF for EHP4 active
                IF NOT g_rldnr IS INITIAL.
                  CALL FUNCTION 'FAGL_AUTHORITY_LEDGER'
                    EXPORTING
                      i_bukrs = buktab-bukrs
                      i_rldnr = g_rldnr
                      i_actvt = '03'.
                ELSE.
                  LOOP AT lt_ledger.
                    CALL FUNCTION 'FAGL_AUTHORITY_LEDGER'
                      EXPORTING
                        i_bukrs = buktab-bukrs
                        i_rldnr = lt_ledger-rldnr
                        i_actvt = '03'.
                  ENDLOOP.
                ENDIF.
              ELSE.
                CALL FUNCTION 'FAGL_AUTHORITY_LEDGER'
                  EXPORTING
                    i_bukrs = buktab-bukrs
                    i_rldnr = g_rldnr
                    i_actvt = '03'.
              ENDIF.

*****************************************************************************
*              EHP4 Switch Section End                                      *
*****************************************************************************
            ENDLOOP.
          ENDIF.

          IF NOT ( g_glflex_act_cc IS INITIAL ).
*........ there are active cc's
            LOOP AT gt_act_bukrs INTO g_act_bukrs.
              IF g_act_bukrs IN br_bukrs.
*............ active cc's are required
                g_act_bukrs_req = 'X'.
                EXIT.    ">>>>>>>  E X I T  >>>>>>>>>
              ENDIF.
            ENDLOOP.

            IF g_act_bukrs_req IS INITIAL.
*.......... required cc's are not active
              CLEAR: g_glflex_act_cc.
              CLEAR: g_rldnr.
              REFRESH gr_rldnr.
            ENDIF.
          ENDIF.
        ENDIF.

* ------ ARCHIVDATEN lesen.

        IF NOT arch_sel[] IS INITIAL."brarkey
          CALL FUNCTION 'FI_EMU_CONVERSION_GROUPS'
            EXPORTING
              xdbuse                      = xusedb    "xdbuse
              xaruse                      = xusear    "'X'
            TABLES
*             I_ARKEYS                    =
              i_arkey_sel                 = arch_sel "brarkey
              i_bukrs_sel                 = br_bukrs
              i_gjahr_sel                 = br_gjahr
            EXCEPTIONS
              different_conversion_states = 1
              OTHERS                      = 2.
          IF sy-subrc > 0 AND arch_mssg_sent IS INITIAL.
            arch_mssg_sent = 'X'.
            MESSAGE ID sy-msgid TYPE 'W' NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
        ENDIF.

*------- Fehlermeldung wenn nur Archivdaten gewünscht aber kein
*        Zugriffspfad vorhanden ist.
*      IF braronly <> space.
*        DESCRIBE TABLE arch_sel LINES sy-tfill."brarkey
*        IF sy-tfill EQ 0.
*          braronly = space.
*          SET CURSOR FIELD 'BRARCHIV'.
*          sy-ucomm = space.
*          MESSAGE e819.
*        ENDIF.
*      ENDIF.

      WHEN OTHERS.
    ENDCASE.
  ELSEIF sscrfields-ucomm = 'FC05'.                         "997117
    ld_progname = sy-cprog.                                 "997117
    APPEND 'FI_DOCUMNT' TO lt_objects.                      "997117

    CALL FUNCTION 'AS_DATASOURCE_SELECT'                    "997117
      EXPORTING                                             "997117
        i_db_and_arc       = 'X'                            "997117
        i_no_source_select = space                          "997117
        i_infosys_possible = 'X'                            "997117
        i_documentation    = 'DEFAULT'                      "997117
        i_report           = ld_progname                    "997117
        i_reporttype       = space                          "997117
        it_objects         = lt_objects[]                   "997117
      CHANGING                                              "997117
        c_use_database     = xusedb                         "997117
        c_use_archive      = xusear                         "997117
        c_use_infosys      = xuseas                         "997117
        c_archobj          = sys_object                     "997117
        ct_arch_sel        = arch_sel[].                    "997117

    CLEAR : sscrfields-ucomm.                               "997117

  ENDIF.                                                    "997117
ENDFORM.                    "PAI

*----------------------------------------------------------------------*
*    FORM PUT_BOSG                                                     *
*    Dummy Segment - Flag-Verwaltung -> Lesen Datenbanken additiv      *
*----------------------------------------------------------------------*
FORM put_bosg.

  DATA: l_ds_clauses TYPE rsds_where,
        l_tab_fields TYPE rsfs_tab_fields.

  CALL FUNCTION 'INIT_T001'
    TABLES
      xbukreis = br_bukrs.

* expiring currencies:
  IF NOT b0sg-xcurr IS INITIAL.
    CLEAR gd_expcur_flag.
  ENDIF.
* use ALV for DB Messages
  IF NOT b0sg-xnbal IS INITIAL.
    CLEAR g_balv.
  ENDIF.

* Special case if called over LDB_PROCESS                      "1358937
  if selnewgl = 'X'.                                        "1358937
    b0sg-xdocc = 'X'.                                       "1358937
  endif.                                                    "1358937

*  Exact One Ledger should be selected for G/L view.
  IF NOT b0sg-xldgrp = 'X' AND b0sg-xdocc = 'X'
                AND NOT g_glflex_active IS INITIAL.         "1388736
    IF br_rldnr[] IS INITIAL.
      MESSAGE e612.
    ENDIF.
  ENDIF.

  IF alcur EQ 'X'.
    PERFORM read_teurb TABLES br_bukrs.
  ENDIF. "<<<<euro

  IF NOT ( g_rldnr IS INITIAL ).
*.. export ledger to memory for standard page header
*.. in program RSBTCHH0.
    EXPORT fagl_bhdgd_rldnr FROM g_rldnr_exp
        TO MEMORY ID fagl_bhdgd_rldnr.
*.. get ledger groups containing the selected ledger
    CALL FUNCTION 'FAGL_GET_GROUPS_WITH_LEDGER'
      EXPORTING
        i_rldnr  = g_rldnr
      TABLES
        et_ldgrp = gt_ldgrp.

*.. fill ledger groups to ranges table
    gr_ldgrp-sign   = 'I'.
    gr_ldgrp-option = 'EQ'.
    LOOP AT gt_ldgrp.
      gr_ldgrp-low = gt_ldgrp-ldgrp.
      APPEND gr_ldgrp.
    ENDLOOP.
*.. set ledger group space always
    CLEAR: gr_ldgrp-low.
    APPEND gr_ldgrp.
*.Begin of new part with note 1320519
*.Called over LDB process, so PAI was not executed
  else.
*.. LDB called over LDB process, so PAI was not executed
    if NOT br_rldnr[] is initial.
      if br_rldnr-low is INITIAL.
        message E598.
      endif.
      if ( br_rldnr-sign   ne 'I'
           or br_rldnr-option ne 'EQ' )
         and not br_rldnr-low is initial.
        message E599.
      endif.
      gr_rldnr = br_rldnr.
      append gr_rldnr.
*.....set ledger space always
      clear:  gr_rldnr-low.
      append: gr_rldnr.
*.....save selected ledger
      g_rldnr = br_rldnr-low.

*.....export ledger to memory for standard page header
*.....in program RSBTCHH0.
      export fagl_bhdgd_rldnr from g_rldnr
          to memory id fagl_bhdgd_rldnr.
*.....get ledger groups containing the selected ledger
      CALL FUNCTION 'FAGL_GET_GROUPS_WITH_LEDGER'
        EXPORTING
          i_rldnr  = g_rldnr
        TABLES
          et_ldgrp = gt_ldgrp.
*.....fill ledger groups to ranges table
      gr_ldgrp-sign   = 'I'.
      gr_ldgrp-option = 'EQ'.
      loop at gt_ldgrp.
        gr_ldgrp-low = gt_ldgrp-ldgrp.
        append gr_ldgrp.
      endloop.
*.....set ledger group space always
      clear: gr_ldgrp-low.
      append gr_ldgrp.

*.....Should only be done if NewG/L is active                  "1715625
      IF NOT g_glflex_active IS INITIAL.                       "1715625
*.......Check the fiscal year and period, as PAI was not processed
        perform fisc_year_variant_check tables gr_budat        "1581699
                                        using  g_rldnr.        "1581699
      ENDIF.                                                   "1715625
    endif.
*.End of new part with note 1320519
  endif.

  IF NOT b0sg-xldgrp IS INITIAL AND g_rldnr IS INITIAL.
    gr_ldgrp[] = br_ldgrp[].
  ENDIF.


*** B0SG-XADOC is set by calling report to selection all data  "1509247
*** from all ledgers. But if the ledger(group) is a selection  "1509247
*** criteria and the user removes the restriction(s), also ALL "1509247
*** ledger(group)s should be selected                          "1509247
  if ( not b0sg-xadoc is initial )                             "1509247
    or ( br_rldnr is initial and br_ldgrp is initial ).        "1509247
*.. documents of all ledgers are required
*.. refresh ledger and ledger group selections
    REFRESH gr_rldnr.
    REFRESH gr_ldgrp.
*.. set BR_SEQ off
    CLEAR: br_seq.
  ENDIF.

* take over posting date selections for ledgers
* with differing fiscal year variants
  IF NOT ( gr_budat[] IS INITIAL ).
    if br_budat[] is initial.                                  "1620679
      br_budat[] = gr_budat[].                                 "1620679
    else.                                                      "1620679
      loop at gr_budat.                                        "1620679
        insert gr_budat into table br_budat.                   "1620679
      endloop.                                                 "1620679
    endif.                                                     "1620679
*.. delete selection for fiscal year
    CLEAR:   br_gjahr.
    REFRESH: br_gjahr.
  ENDIF.

* adapt field xhana in special cases
  PERFORM set_ldb_mode USING abap_false.

*
  IF xhana <> space.
    CLEAR br_seq.
  ENDIF.

  PERFORM bstat_fuellen.
  gr_bstat[] = br_bstat[]. "Externalize data stored in br_bstat

* Dynamische Select-Options und Felder
  init_where:  bkpf, faglfreesel.
  init_fields: bkpf, bseg, lfa1, lfb1, kna1, knb1, ska1, skb1.
* If over the LDB_PROCESS a period restriction was given, this
* has to possibly be removed, as form fisc_year_variant_check
* was not able to delete this. Logic how BKPF_WHERE is created
* is different in the LDB_PROCESS case.
  if not ( gr_budat[] is initial ).                            "1581699
    loop at bkpf_where.                                        "1581699
      if bkpf_where CS 'MONAT'.                                "1581699
        delete bkpf_where index sy-tabix.                      "1581699
        if sy-tabix = 1.                                       "1716140
          read table bkpf_where index 1.                       "1716140
          if bkpf_where(3) = 'AND'.                            "1716140
            bkpf_where = bkpf_where+4.                         "1716140
            modify bkpf_where index 1.                         "1716140
          endif.                                               "1716140
        endif.                                                 "1716140
      endif.                                                   "1581699
      if bkpf_where CS 'GJAHR'.                                "1965562
        delete bkpf_where index sy-tabix.                      "1965562
        if sy-tabix = 1.                                       "1965562
          read table bkpf_where index 1.                       "1965562
          if bkpf_where(3) = 'AND'.                            "1965562
            bkpf_where = bkpf_where+4.                         "1965562
            modify bkpf_where index 1.                         "1965562
          endif.                                               "1965562
        endif.                                                 "1965562
      endif.                                                   "1965562
    endloop.                                                   "1581699
    clear bkpf_where.                                          "1581699
  endif.                                                       "1581699

* die Felder für Berechtigungsprüfung LFA1, LFB1 hinzufügen        "45A
  DESCRIBE TABLE lfa1_fields LINES sy-tfill.
  IF sy-tfill > 0.
    PERFORM add_field_to_table TABLES lfa1_fields USING 'BEGRU'.
* IAV International Addess Version
    perform ADD_ADRNR_TO_TABLE TABLES lfa1_fields.
  ENDIF.
  DESCRIBE TABLE lfb1_fields LINES sy-tfill.
  IF sy-tfill > 0.
    PERFORM add_field_to_table TABLES lfb1_fields USING 'BEGRU'.
  ENDIF.
  DESCRIBE TABLE kna1_fields LINES sy-tfill.
  IF sy-tfill > 0.
    PERFORM add_field_to_table TABLES kna1_fields USING 'BEGRU'.
* IAV International Addess Version
    perform ADD_ADRNR_TO_TABLE TABLES kna1_fields.
  ENDIF.
  DESCRIBE TABLE knb1_fields LINES sy-tfill.
  IF sy-tfill > 0.
    PERFORM add_field_to_table TABLES knb1_fields USING 'BEGRU'.
  ENDIF.
  DESCRIBE TABLE skb1_fields LINES sy-tfill.
  IF sy-tfill > 0.
    PERFORM add_field_to_table TABLES skb1_fields USING 'BEGRU'.
  ENDIF.

  DESCRIBE TABLE bkpf_fields LINES sy-tfill.
  IF sy-tfill > 0.
    PERFORM add_auth_check_fields TABLES bkpf_fields USING 'BKPF'.
  ENDIF.

* Die Felder zur Berechnung von BSEGA hinzufügen
  DESCRIBE TABLE bseg_fields LINES sy-tfill.
  IF sy-tfill > 0.
    PERFORM add_auth_check_fields TABLES bseg_fields USING 'BSEG'.
    PERFORM add_bsega_fields TABLES bseg_fields USING 'BSEG'.
*   Check field list for BSEG -> note 2017063:
    perform check_authority_fields changing bseg_fields[].
  ENDIF.

* Für die Felder, die nicht in VBKPF vorhanden sind, wird eine
* Nachrichte ausgegeben.
  IF b0sg-xstav = 'X' OR b0sg-xstav = 'Z'.
    PERFORM exclud_dyn_sel_not_in_table USING 'BKPF' 'VBKPF'.
  ENDIF.

  READ TABLE get_events WITH KEY node = 'BSEG'.
  IF br_seq NE space
  AND get_events-kind EQ ' '.
** and %_get+2(1) eq ' '.         "nur Belegkoepfe lesen
    br_seq = space.
  ENDIF.
  CLEAR bseg.                                               "<-- 3.0F
  PUT bosg.
  CLEAR bseg.

* clear highval (hex) from br_belnr due to problems with spool
  READ TABLE br_belnr INDEX 1.
  IF sy-subrc EQ 0 AND br_belnr-high EQ highval(10).
    REFRESH br_belnr.
  ENDIF.
*  perform bal_disp_msg. "do this at event end of selection
ENDFORM.                    "PUT_BOSG

*----------------------------------------------------------------------*
*    FORM PUT_BKPF                                                     *
*    Belegkopf                                                         *
*----------------------------------------------------------------------*
FORM put_bkpf.

  TABLES: admi_fidoc.                       "archive content
  DATA:   mssg_typ(1),                      "I-Mssg or S-Mssg
          idx_arch    LIKE sy-tabix.        "itab pointer

  IF xusear IS INITIAL AND xusedb IS INITIAL.               "1087453
    xusedb = 'X'.                                           "1087453
  ENDIF.                                                    "1087453

*----- Check if sequential Read and Archive is flagged together ------*
*----- If true, take out the sequential Flag, it does not make sense -*

  IF xusear <> space.
    IF br_seq = 'X' AND xusedb <> space.
      br_seq = ' '.
    ENDIF.
  ENDIF.

*------ archive check deleted because of AS connection---------"997117*

  IF b0sg-xldbr = ' '.
    EXIT.
  ENDIF.

  GET RUN TIME FIELD k.
  GET TIME FIELD time1.

*------- Belegresidenz lesen -----------------------------------------*
  IF xusedb <> space. "braronly EQ space.

    IF xhana = 'I'.
      DATA: ld_xvor TYPE abap_bool,
            ld_xnor TYPE abap_bool.
      CLEAR: ld_xvor, ld_xnor.
      IF b0sg-xstav = 'X' OR b0sg-xstav = 'Z'.
        ld_xvor = abap_true.
        ld_xnor = abap_false.
        PERFORM read_bkpf_hana USING ld_xnor ld_xvor.
      ENDIF.
      IF b0sg-xstan = 'X'  " normal documents
      OR b0sg-xstas = 'X'. " statistical documents
        ld_xnor = abap_true.
        ld_xvor = abap_false.
        PERFORM read_bkpf_hana USING ld_xnor ld_xvor.
      ENDIF.

    ENDIF.


    "Es sind auch Datenbankbelege gewünscht.

    vorbel = ' '.

    DESCRIBE TABLE br_bstat LINES sy-tfill.
    READ TABLE br_bstat INDEX sy-tfill.

*------- Nur Dauerbuchungsbelege -------------------------------------*
    IF sy-tfill EQ 3                                        "969691
    AND br_bstat-low EQ 'D'
    and b0sg-xstan <> 'X'                                      "1568640
    and b0sg-xstam <> 'X'                                      "1568640
    and b0sg-xstas <> 'X'                                      "1568640
    AND b0sg-xstav <> 'X'.
*.... only recurring entry documents required
      g_rec_entry_docs = 'X'.

      SELECT * FROM bkdf
        WHERE bukrs IN br_bukrs
        AND   belnr IN br_belnr
        AND   gjahr IN br_gjahr
        ORDER BY PRIMARY KEY.                               "942527

        SELECT SINGLE (bkpf_fields) FROM bkpf
          INTO CORRESPONDING FIELDS OF bkpf
          WHERE bukrs = bkdf-bukrs
          AND   belnr = bkdf-belnr
          AND   gjahr = bkdf-gjahr
          AND (bkpf_where) .

        IF sy-subrc NE 0 OR bkpf-bstat <> 'D'.
          DESCRIBE TABLE bkpf_where LINES sy-tabix.
          IF sy-tabix EQ 0 .
            MESSAGE s805 WITH bkdf-bukrs bkdf-belnr bkdf-gjahr.
          ENDIF.
        ELSE.
          IF bkpf-blart IN br_blart
          AND bkpf-budat IN br_budat
          AND bkpf-cpudt IN br_cpudt                        "<-- 3.0F
          AND bkpf-usnam IN br_usnam                        "<-- 3.0F
          AND bkpf-xblnr IN br_xblnr
          AND bkpf-awtyp IN br_awtyp
          AND bkpf-awkey IN br_awkey
          AND bkpf-awsys IN br_awsys.
            save_bukrs = bkpf-bukrs.
            save_belnr = bkpf-belnr.
            save_gjahr = bkpf-gjahr.
            save_bstat = bkpf-bstat.
            b0sg-xarbl = space.
            PERFORM t001_read.
*           expiring currencies:
            gd_waers_save = bkpf-waers.
            IF NOT gd_expcur_flag IS INITIAL.
              PERFORM item_curr_convert_bkpf USING    'SAPDBBRF'
                                                      sy-datlo
                                             CHANGING bkpf.
            ENDIF.

            IF bkpf-rldnr IS INITIAL.
              bkpf-rldnr = g_rldnr.
            ENDIF.

            PUT bkpf.
          ENDIF.
        ENDIF.
      ENDSELECT.

    ELSEIF xhana = space.
* Enthält BKPF-BSTAT mehr als den Eintrag 'D' wird zuerst der Belegkopf
* und bei Bedarf Dauerbuchungsinformationen gelesen.
* Belege sequentiell lesen: Tabelle XBKPF fuellen und BSEG lesen
      IF br_seq = 'X'.
        SELECT (bkpf_fields) FROM bkpf APPENDING
          CORRESPONDING FIELDS OF TABLE xbkpf
          WHERE belnr IN br_belnr
          AND   bukrs IN br_bukrs
          AND   gjahr IN br_gjahr
          AND   blart IN br_blart
          AND   xblnr IN br_xblnr
          AND   budat IN br_budat
          AND   bstat IN br_bstat
          AND   awtyp IN br_awtyp
          AND   awkey IN br_awkey
          AND   awsys IN br_awsys
          AND   cpudt IN br_cpudt
          AND   bldat IN br_bldat
          AND   usnam IN br_usnam
          AND   ( ldgrp IN gr_ldgrp OR ldgrp IS NULL )      "976164
          and   ( rldnr in gr_rldnr OR rldnr IS NULL )      "1320519
          AND   ( vatdate IN br_vatdt OR vatdate IS NULL )  "1023317
          AND   (bkpf_where)
          ORDER BY PRIMARY KEY.
        csr_xbkpf = 1.
        READ TABLE xbkpf INDEX 1.
        cnt_bkpf = cnt_bkpf + 1.
        bkpf = xbkpf.
        IF sy-subrc NE 0.
          eof_xbkpf = 'X'.
          EXIT.                        " nichts gefunden
        ENDIF.

        SELECT (bseg_fields) FROM bseg INTO
          CORRESPONDING FIELDS OF *bseg
          WHERE belnr IN br_belnr
          AND   bukrs IN br_bukrs
          AND   gjahr IN br_gjahr
          ORDER BY PRIMARY KEY.

          IF eof_xbkpf = 'X'.
            EXIT.
          ENDIF.
          cnt_bseg = cnt_bseg + 1.

*------- Key BKPF < Key BSEG ------------------------------------------*
          IF bkpf-bukrs < *bseg-bukrs
          OR ( bkpf-bukrs = *bseg-bukrs
             AND bkpf-belnr < *bseg-belnr )
          OR ( bkpf-bukrs = *bseg-bukrs
             AND bkpf-belnr = *bseg-belnr
             AND bkpf-gjahr < *bseg-gjahr ).
            IF bkpf-bstat EQ 'D'.
              SELECT SINGLE * FROM bkdf
                WHERE bukrs EQ bkpf-bukrs
                AND   belnr EQ bkpf-belnr
                AND   gjahr EQ bkpf-gjahr.
            ENDIF.
            save_bukrs = bkpf-bukrs.
            PERFORM t001_read.
*           expiring currencies:
            gd_waers_save = bkpf-waers.
            IF NOT gd_expcur_flag IS INITIAL.
              PERFORM item_curr_convert_bkpf USING    'SAPDBBRF'
                                                      sy-datlo
                                             CHANGING bkpf.
            ENDIF.

            IF bkpf-rldnr IS INITIAL.
              bkpf-rldnr = g_rldnr.
            ENDIF.

            PUT bkpf.
            REFRESH xbseg.
            REFRESH xbsec.
            REFRESH xbsed.
            REFRESH xbset.
            sel_bset = space.
            DO.
              csr_xbkpf = csr_xbkpf + 1.
              READ TABLE xbkpf INDEX csr_xbkpf.
              bkpf = xbkpf.
              cnt_bkpf = cnt_bkpf + 1.
              IF sy-subrc NE 0.
                eof_xbkpf = 'X'.
                EXIT.
              ENDIF.
              IF bkpf-bukrs < *bseg-bukrs
              OR ( bkpf-bukrs = *bseg-bukrs
                 AND bkpf-belnr < *bseg-belnr )
              OR ( bkpf-bukrs = *bseg-bukrs
                 AND bkpf-belnr = *bseg-belnr
                 AND bkpf-gjahr < *bseg-gjahr ).
*          Belegkopf ohne Zeilen
                MESSAGE s806 WITH bkpf-bukrs bkpf-belnr bkpf-gjahr.
              ELSE.
                EXIT.
              ENDIF.
            ENDDO.
          ENDIF.

*------- Key BKPF = Key BSEG ------------------------------------------*
          IF bkpf-bukrs = *bseg-bukrs
          AND bkpf-belnr = *bseg-belnr
          AND bkpf-gjahr = *bseg-gjahr.
            xbseg = *bseg.
            APPEND xbseg.
            IF sel_bset = space.
              SELECT * FROM bset INTO xbset
                WHERE bukrs = *bseg-bukrs
                AND   belnr = *bseg-belnr
                AND   gjahr = *bseg-gjahr
                     ORDER BY PRIMARY KEY.                     "2318258
                APPEND xbset.
              ENDSELECT.
              sel_bset = 'X'.
            ENDIF.
            IF *BSEG-XCPDD EQ 'X'                           "1175505
            AND b0sg-xbsec NE ' '.
              CALL FUNCTION 'CVP_READ_SINGLE_BSEC'
                EXPORTING
                  IV_BUKRS      = *bseg-bukrs
                  IV_BELNR      = *bseg-belnr
                  IV_GJAHR      = *bseg-gjahr
                  IV_BUZEI      = *bseg-buzei
                  IV_KOART      = *bseg-koart
                  IV_NO_MASKING = 'X'
                IMPORTING
                  ES_BSEC       = xbsec
                EXCEPTIONS
                  NOT_FOUND     = 1
                  NO_AUTHORITY  = 2.
              IF sy-subrc NE 0.
                CLEAR xbsec.
              ELSE.
                APPEND xbsec.
              ENDIF.
            ENDIF.
            IF *BSEG-UMSKS NE 'A'                           "1175505
            AND *BSEG-UMSKS NE SPACE                        "1175505
            AND b0sg-xbsed NE ' '.
              SELECT SINGLE * FROM bsed INTO xbsed
                WHERE bukrs = *bseg-bukrs
                AND   belnr = *bseg-belnr
                AND   buzei = *bseg-buzei
                AND   gjahr = *bseg-gjahr.
              IF sy-subrc = 0.
                APPEND xbsed.
              ENDIF.
            ENDIF.
          ENDIF.

*------- Key BKPF > Key BSEG ------------------------------------------*
          IF bkpf-bukrs > *bseg-bukrs
          OR ( bkpf-bukrs = *bseg-bukrs
             AND bkpf-belnr > *bseg-belnr )
          OR ( bkpf-bukrs = *bseg-bukrs
             AND bkpf-belnr = *bseg-belnr
             AND bkpf-gjahr > *bseg-gjahr ).
*      Zeile nicht selektiert.
          ENDIF.

        ENDSELECT.

        DESCRIBE TABLE xbseg LINES i.
        IF i > 0.
          b0sg-xarbl = space.
          IF bkpf-bstat EQ 'D'.
            SELECT SINGLE * FROM bkdf
              WHERE bukrs EQ bkpf-bukrs
              AND   belnr EQ bkpf-belnr
              AND   gjahr EQ bkpf-gjahr.
          ENDIF.
          save_bukrs = bkpf-bukrs.
          PERFORM t001_read.
*         expiring currencies:
          gd_waers_save = bkpf-waers.
          IF NOT gd_expcur_flag IS INITIAL.
            PERFORM item_curr_convert_bkpf USING    'SAPDBBRF'
                                                    sy-datlo
                                           CHANGING bkpf.
          ENDIF.

          IF bkpf-rldnr IS INITIAL.
            bkpf-rldnr = g_rldnr.
          ENDIF.

          PUT bkpf.
        ENDIF.

*------- Belegkoepfe lesen, Positionen einzeln dazu ------------------*
      ELSE.
        SELECT (bkpf_fields) FROM bkpf INTO
         CORRESPONDING FIELDS OF bkpf
          WHERE bukrs IN br_bukrs
          AND   blart IN br_blart
          AND   budat IN br_budat
          AND   xblnr IN br_xblnr
          AND   belnr IN br_belnr
          AND   gjahr IN br_gjahr
          AND   bstat IN br_bstat
          AND   awtyp IN br_awtyp
          AND   awkey IN br_awkey
          AND   awsys IN br_awsys
          AND   cpudt IN br_cpudt
          AND   bldat IN br_bldat
          AND   usnam IN br_usnam
          AND   ( ldgrp IN gr_ldgrp OR ldgrp IS NULL )      "976164
          and   ( rldnr in gr_rldnr OR rldnr IS NULL )      "1320519
          AND   ( vatdate IN br_vatdt OR vatdate IS NULL )  "1023317
          AND   (bkpf_where)
          ORDER BY PRIMARY KEY.

          IF NOT ( g_glflex_active IS INITIAL )
         AND NOT ( b0sg-xadoc      IS INITIAL ).
            CALL FUNCTION 'FAGL_AUTHORITY_LEDGER'
              EXPORTING
                i_bukrs      = bkpf-bukrs
                i_rldnr      = bkpf-rldnr
                i_ldgrp      = bkpf-ldgrp
                i_actvt      = '03'
              EXCEPTIONS
                no_authority = 4.

            IF sy-subrc <> 0.
              CONTINUE.
            ENDIF.
          ENDIF.
          IF b0sg-xstaj IS INITIAL AND bkpf-glvor = 'GLYC'.    "2159068
            CONTINUE.                                          "1943241
          ENDIF.                                               "1943241

          IF bkpf-bstat EQ 'D'.
            SELECT SINGLE * FROM bkdf
              WHERE bukrs EQ bkpf-bukrs
              AND   belnr EQ bkpf-belnr
              AND   gjahr EQ bkpf-gjahr.
          ENDIF.
          save_bukrs = bkpf-bukrs.
          save_belnr = bkpf-belnr.
          save_gjahr = bkpf-gjahr.
          save_bstat = bkpf-bstat.
          cnt_bkpf = cnt_bkpf + 1.
          b0sg-xarbl = space.
          PERFORM t001_read.
*         expiring currencies:
          gd_waers_save = bkpf-waers.
          IF NOT gd_expcur_flag IS INITIAL.
            PERFORM item_curr_convert_bkpf USING    'SAPDBBRF'
                                                    sy-datlo
                                           CHANGING bkpf.
          ENDIF.

          IF bkpf-rldnr IS INITIAL.
            bkpf-rldnr = g_rldnr.
          ENDIF.

          PUT bkpf.
        ENDSELECT.

      ENDIF.                           "alte Lesetechnik
*     vorerfasste Belege
      IF b0sg-xstav = 'X' OR b0sg-xstav = 'Z'.
        vorbel = 'X'.
        SELECT * FROM vbkpf
          WHERE bukrs IN br_bukrs
          AND   ausbk IN br_bukrs
          AND   blart IN br_blart
          AND   budat IN br_budat
          AND   xblnr IN br_xblnr
          AND   belnr IN br_belnr
          AND   gjahr IN br_gjahr
*         AND   BSTAT IN BR_BSTAT
*         AND   AWTYP IN BR_AWTYP
*         AND   AWKEY IN BR_AWKEY
          AND   cpudt IN br_cpudt
          AND   bldat IN br_bldat
          AND   usnam IN br_usnam
          AND   ( vatdate IN br_vatdt OR vatdate IS NULL )  "1023317
          AND   (bkpf_where)
          ORDER BY PRIMARY KEY.

          CHECK vbkpf-ausbk = vbkpf-bukrs.

          CLEAR bkpf.
          MOVE-CORRESPONDING vbkpf TO bkpf.

          save_bukrs = bkpf-bukrs.
          save_belnr = bkpf-belnr.
          save_gjahr = bkpf-gjahr.
          save_bstat = bkpf-bstat.

          cnt_bkpf = cnt_bkpf + 1.
          b0sg-xarbl = space.
          PERFORM t001_read.
*         expiring currencies:
          gd_waers_save = bkpf-waers.
          IF NOT gd_expcur_flag IS INITIAL.
            PERFORM item_curr_convert_bkpf USING    'SAPDBBRF'
                                                     sy-datlo
                                           CHANGING bkpf.
          ENDIF.

          IF bkpf-rldnr IS INITIAL.
            bkpf-rldnr = g_rldnr.
          ENDIF.

          PUT bkpf.

        ENDSELECT.

      ENDIF.
*     geloeschte vorerfasste Belege
      IF b0sg-xstav = 'Z'.
        vorbel = 'Z'.
        SELECT (bkpf_fields) FROM bkpf INTO CORRESPONDING FIELDS OF bkpf
           WHERE bukrs IN br_bukrs
           AND   blart IN br_blart
           AND   budat IN br_budat
           AND   xblnr IN br_xblnr
           AND   belnr IN br_belnr
           AND   gjahr IN br_gjahr
           AND   bstat IN zw_bstat      " 'W' oder 'Z'
*         AND   AWTYP IN BR_AWTYP
*         AND   AWKEY IN BR_AWKEY
*         AND   AWSYS IN BR_AWSYS
           AND   cpudt IN br_cpudt
           AND   bldat IN br_bldat
           AND   usnam IN br_usnam
           AND   ( ldgrp IN gr_ldgrp OR ldgrp IS NULL )     "976164
          and   ( rldnr in gr_rldnr OR rldnr IS NULL )      "1320519
            AND   ( vatdate IN br_vatdt OR vatdate IS NULL ) "1023317
            AND   (bkpf_where)
           ORDER BY PRIMARY KEY.

          save_bukrs = bkpf-bukrs.
          save_belnr = bkpf-belnr.
          save_gjahr = bkpf-gjahr.
          save_bstat = bkpf-bstat.

          cnt_bkpf = cnt_bkpf + 1.
          b0sg-xarbl = space.
          PERFORM t001_read.
*         expiring currencies:
          gd_waers_save = bkpf-waers.
          IF NOT gd_expcur_flag IS INITIAL.
            PERFORM item_curr_convert_bkpf USING    'SAPDBBRF'
                                                    sy-datlo
                                           CHANGING bkpf.
          ENDIF.

          IF bkpf-rldnr IS INITIAL.
            bkpf-rldnr = g_rldnr.
          ENDIF.

          PUT bkpf.
        ENDSELECT.

      ENDIF.

    ENDIF.                   "IF SY-TFILL EQ 2 and BR_BSTAT-low eq 'D'.
  ENDIF.                               "IF BRARONLY EQ SPACE.

*----------------------------------------------------------------------*
*    Sequentielles Lesen der Archivdatei                               *
*    über Archivschlüssel                                              *
*----------------------------------------------------------------------*

  IF xusear <> space. "and yarchset_cnt > 0.                   "997117

    PERFORM init_dyn_range.
    PERFORM read_archiv_data.     "New archiv connection for FLEXGL

  ENDIF.                               "IF BRARKEY_LC > 0.

  GET RUN TIME FIELD k.
  GET TIME FIELD time2.
  PERFORM statistik.
  IF cnt_no_auth > 0.
    DATA:ldummy.
    IF g_balv = 'X'.
      MESSAGE s600 WITH text-200
                        cnt_no_auth
                        text-201
                   INTO ldummy.
      CALL FUNCTION 'LDB_LOG_WRITE'.
    ELSE.
      WRITE: / text-200.
      WRITE: / cnt_no_auth NO-ZERO COLOR 6, text-201.
    ENDIF.
  ENDIF.

ENDFORM.                    "PUT_BKPF

*----------------------------------------------------------------------*
*    FORM PUT_BSEG                                                     *
*    Belegposition                                                     *
*----------------------------------------------------------------------*
FORM put_bseg.

  IF ( b0sg-xarbl = space ) AND
     ( xhana      = 'I' ).
    IF g_rec_entry_docs = ' '.
      PERFORM read_bseg_hana.
    ENDIF.
  ENDIF.
*
  IF ( b0sg-xarbl = space ).
    IF ( xhana = space ) OR                   "not optimized for hana
       ( ( g_rec_entry_docs = 'X' ) AND       "exceptionally do for recurring documents
         ( xhana = 'I' ) ).                   "as they are not part of the HANA views
      IF vorbel = ' '.
        IF br_seq = 'X'.
          LOOP AT xbseg.
            bseg = xbseg.
*         expiring currencies:
            IF NOT gd_expcur_flag IS INITIAL.
              PERFORM item_curr_convert_bseg USING    'SAPDBBRF'
                                                      t001-waers
                                                      gd_waers_save
                                                      sy-datlo
                                             CHANGING bseg.
            ENDIF.
            MOVE-CORRESPONDING bseg TO bsegh.
            PERFORM got_bsega(sapbsega).
            CLEAR bsec.
            IF bseg-xcpdd EQ 'X'
            AND b0sg-xbsec NE ' '.
              LOOP AT xbsec
                WHERE buzei = bseg-buzei.
                EXIT.
              ENDLOOP.
              IF sy-subrc = 0.
                bsec = xbsec.
              ENDIF.
            ENDIF.
            CLEAR bsed.
            IF bseg-umsks NE 'A'
            AND bseg-umsks NE space
            AND b0sg-xbsed NE ' '.
              LOOP AT xbsed
                WHERE buzei = bseg-buzei.
                EXIT.
              ENDLOOP.
              IF sy-subrc = 0.
                bsed = xbsed.
              ENDIF.
            ENDIF.
            IF alcur EQ 'X'.
              PERFORM convert_alt        "euro
              USING 'BSEG' bkpf-waers.
            ENDIF.                       "euro

            cnt_bsegsel = cnt_bsegsel + 1.

            PUT bseg.
          ENDLOOP.

*======= alte Lesetechnik ============================================*
        ELSE.
          DATA:    lt_bseg TYPE fagl_t_bseg.
          REFRESH: lt_bseg.

          IF NOT ( g_rec_entry_docs IS INITIAL ).
*........ nur Dauerbuchunbgsurbelege
            SELECT (bseg_fields) FROM bseg
                   INTO CORRESPONDING FIELDS OF TABLE lt_bseg
               WHERE bukrs = save_bukrs
               AND   belnr = save_belnr
               AND   gjahr = save_gjahr.

          ELSEIF ( NOT b0sg-xdocc      IS INITIAL AND
                   NOT g_glflex_active IS INITIAL )
              OR ( NOT b0sg-xdocc      IS INITIAL AND
                   NOT g_glflex_act_cc IS INITIAL AND
                   save_bukrs IN gr_act_bukrs ).
*........ Hauptbuchsicht
            CALL FUNCTION 'FAGL_GET_GL_DOCUMENT'
              EXPORTING
                i_rldnr           = g_rldnr
                i_bukrs           = save_bukrs
                i_belnr           = save_belnr
                i_gjahr           = save_gjahr
                it_fieldlist      = bseg_fields[]
                it_where_clause   = faglfreesel_where
                i_authority_check = 'X'                       "ERP05
              IMPORTING
                et_bseg           = lt_bseg
              EXCEPTIONS
                not_found         = 1
                OTHERS            = 2.
          ELSE.
*........ Erfassungssicht
            CALL FUNCTION 'FAGL_GET_BSEG'
              EXPORTING
                i_bukrs           = save_bukrs
                i_belnr           = save_belnr
                i_gjahr           = save_gjahr
                i_bstat           = save_bstat
                it_fieldlist      = bseg_fields[]
                it_where_clause   = faglfreesel_where
                i_authority_check = 'X'                       "ERP05
              IMPORTING
                et_bseg           = lt_bseg
              EXCEPTIONS
                not_found         = 1
                OTHERS            = 2.
          ENDIF.

          LOOP AT lt_bseg INTO bseg.
            save_buzei = bseg-buzei.
            cnt_bseg = cnt_bseg + 1.
*         expiring currencies:
            IF NOT gd_expcur_flag IS INITIAL.
              PERFORM item_curr_convert_bseg USING    'SAPDBBRF'
                                                      t001-waers
                                                      gd_waers_save
                                                      sy-datlo
                                             CHANGING bseg.
            ENDIF.
            MOVE-CORRESPONDING bseg TO bsegh.
            PERFORM got_bsega(sapbsega).
*        CPD-DATEN
            IF bseg-xcpdd EQ 'X'
            AND b0sg-xbsec NE ' '.
              CALL FUNCTION 'CVP_READ_SINGLE_BSEC'
                EXPORTING
                  IV_BUKRS      = save_bukrs
                  IV_BELNR      = save_belnr
                  IV_GJAHR      = save_gjahr
                  IV_BUZEI      = save_buzei
                  IV_KOART      = bseg-koart
                  IV_NO_MASKING = 'X'
                IMPORTING
                  ES_BSEC       = bsec
                EXCEPTIONS
                  NOT_FOUND     = 1
                  NO_AUTHORITY  = 2.
              IF sy-subrc NE 0.
                CLEAR bsec.
              ENDIF.
            ELSE.
              CLEAR bsec.
            ENDIF.
*        WECHSELDATEN
            CLEAR bsed.
            IF bseg-umsks NE 'A'
            AND bseg-umsks NE space
            AND b0sg-xbsed NE ' '.
              SELECT SINGLE * FROM bsed
                WHERE bukrs = save_bukrs
                AND   belnr = save_belnr
                AND   buzei = save_buzei
                AND   gjahr = save_gjahr.
            ENDIF.
            cnt_bsegsel = cnt_bsegsel + 1.
            IF alcur EQ 'X'.
              PERFORM convert_alt        "euro
              USING 'BSEG' bkpf-waers.
            ENDIF.                       "euro

            PUT bseg.
            CLEAR bseg.
*        ENDSELECT.
          ENDLOOP.
        ENDIF.
*   vorerfasste Belege
      ELSEIF vorbel = 'X'.
        REFRESH xbseg.
        sel_vbseg: k, d, s, a.
        SORT xbseg BY buzei.
        LOOP AT xbseg.
          bseg = xbseg.
          IF bseg-koart = 'K' OR bseg-koart = 'D'.
            IF b0sg-xbsec NE ' ' AND bseg-xcpdd EQ 'X'.
              SELECT SINGLE * FROM vbsec
                WHERE ausbk = bseg-bukrs
                AND   belnr = bseg-belnr
                AND   gjahr = bseg-gjahr
                AND   buzei = bseg-buzei.
            ELSE.
              CLEAR bsec.
            ENDIF.
          ENDIF.
*       expiring currencies:
          IF NOT gd_expcur_flag IS INITIAL.
            PERFORM item_curr_convert_bseg USING    'SAPDBBRF'
                                                    t001-waers
                                                    gd_waers_save
                                                    sy-datlo
                                           CHANGING bseg.
          ENDIF.
          MOVE-CORRESPONDING bseg TO bsegh.
          PERFORM got_bsega(sapbsega).
          IF alcur EQ 'X'.
            PERFORM convert_alt          "euro
            USING 'BSEG' bkpf-waers.
          ENDIF.                         "euro

          PUT bseg.
        ENDLOOP.
*   geloeschte vorerfasste Belege
      ELSE.
        "keine Selektion
      ENDIF.
    ENDIF.
  ELSE.
*----------------------------------------------------------------------*
*    Lesen Reorganisationsfile                                         *
*----------------------------------------------------------------------*

    LOOP AT ybseg INTO wa_ybseg.
      bseg = wa_ybseg.
      save_buzei = bseg-buzei.
*     expiring currencies:
      IF NOT gd_expcur_flag IS INITIAL.
        PERFORM item_curr_convert_bseg USING    'SAPDBBRF'
                                                t001-waers
                                                gd_waers_save
                                                sy-datlo
                                       CHANGING bseg.
      ENDIF.
      MOVE-CORRESPONDING bseg TO bsegh.
      PERFORM got_bsega(sapbsega).
* CPD-DATEN
* ---------
      IF bseg-xcpdd EQ 'X' AND
         b0sg-xbsec NE ' '.
        READ TABLE ybsec INDEX 1 INTO bsec.
      ELSE.
        CLEAR bsec.
      ENDIF.

* WECHSELDATEN
* ------------
      IF bseg-umsks NE 'A'
         AND bseg-umsks NE space
         AND b0sg-xbsed NE ' '.
        READ TABLE ybsed INDEX 1 INTO bsed.
        IF sy-subrc <> 0.
          CLEAR bsed.
        ENDIF.
      ELSE.
        CLEAR bsed.
      ENDIF.
      IF alcur EQ 'X'.
        PERFORM convert_alt            "euro
        USING 'BSEG' bkpf-waers.
      ENDIF.                           "euro

      clear flag.                                              "1672938
      perform check_arch_faglfreesel changing flag.            "1672938
      if flag is initial.                                      "1672938
        put bseg.
      endif.                                                   "1672938
    ENDLOOP.
  ENDIF.
ENDFORM.                    "PUT_BSEG


*----------------------------------------------------------------------*
*    FORM PUT_BSET
*    Steuerdaten
*----------------------------------------------------------------------*
FORM put_bset.

  IF b0sg-xarbl = space.
    ASSERT ( xhana = space ) OR ( xhana = 'I' ).  "BSET is not optimized inside BRF
    IF xusedb <> space.  "braronly EQ space.
      "Es sind auch Datenbankbelege gewünscht.
      IF br_seq = 'X'.
        LOOP AT xbset.
          bset = xbset.
          IF alcur EQ 'X'.
            PERFORM convert_alt        "euro
            USING 'BSET' bkpf-waers.
          ENDIF.                       "euro
*         expiring currencies:
          IF NOT gd_expcur_flag IS INITIAL.
            PERFORM item_curr_convert_bset USING    'SAPDBBRF'
                                                    t001-waers
                                                    gd_waers_save
                                                    sy-datlo
                                           CHANGING bset.
          ENDIF.

          PUT bset.
        ENDLOOP.
      ELSE.
        SELECT * FROM bset
          WHERE bukrs = save_bukrs
          AND   belnr = save_belnr
          AND   gjahr = save_gjahr
              ORDER BY PRIMARY KEY.                            "2318258
          IF alcur EQ 'X'.
            PERFORM convert_alt        "euro
            USING 'BSET' bkpf-waers.
          ENDIF.                       "euro
*         expiring currencies:
          IF NOT gd_expcur_flag IS INITIAL.
            PERFORM item_curr_convert_bset USING    'SAPDBBRF'
                                                    t001-waers
                                                    gd_waers_save
                                                    sy-datlo
                                           CHANGING bset.
          ENDIF.

          PUT bset.
        ENDSELECT.
      ENDIF.
    ENDIF.                             "IF BRARONLY EQ SPACE.
    IF vorbel = 'X' AND vbkpf-xbset = 'X'.
      SELECT * FROM vbset
          WHERE ausbk = save_bukrs
          AND   belnr = save_belnr
          AND   gjahr = save_gjahr
              ORDER BY PRIMARY KEY.                            "2318258
        CLEAR bset.
        MOVE-CORRESPONDING vbset TO bset.
        IF alcur EQ 'X'.
          PERFORM convert_alt          "euro
          USING 'BSET' bkpf-waers.
        ENDIF.                         "euro
*       expiring currencies:
        IF NOT gd_expcur_flag IS INITIAL.
          PERFORM item_curr_convert_bset USING    'SAPDBBRF'
                                                  t001-waers
                                                  gd_waers_save
                                                  sy-datlo
                                         CHANGING bset.
        ENDIF.

        PUT bset.
      ENDSELECT.
    ENDIF.
  ELSE.
*----------------------------------------------------------------------*
*    Lesen vom Reorganisationsfile                                     *
*----------------------------------------------------------------------*
    LOOP AT ybset INTO wa_ybset.
      bset = wa_ybset.
      IF alcur EQ 'X'.
        PERFORM convert_alt            "euro
        USING 'BSET' bkpf-waers.
      ENDIF.                           "euro
*     expiring currencies:
      IF NOT gd_expcur_flag IS INITIAL.
        PERFORM item_curr_convert_bset USING    'SAPDBBRF'
                                                t001-waers
                                                gd_waers_save
                                                sy-datlo
                                       CHANGING bset.
      ENDIF.

      PUT bset.
    ENDLOOP.
  ENDIF.
ENDFORM.                    "PUT_BSET

*&--------------------------------------------------------------------*
*&      Form  PUT_faglfreesel
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM put_faglfreesel.
  PUT faglfreesel.
ENDFORM.                               "PUT_FAGLFREESEL

*----------------------------------------------------------------------*
* FORM PUT_KNA1                                                        *
* Debitorendaten pro Mandant                                           *
*----------------------------------------------------------------------*
FORM put_kna1.

  IF b0sg-xldds = 'X'.
    SELECT (kna1_fields) FROM kna1 INTO CORRESPONDING FIELDS OF kna1
       WHERE kunnr IN brdkunnr.
      save_kunnr = kna1-kunnr.
* IAV Intenational Address Version
      CALL METHOD cl_iav_mapping_util=>get_address_as_kna1
        EXPORTING
          iv_adrnr                 = kna1-adrnr
          iv_application_component = 'FI_AR'
        CHANGING
          cs_kna1                  = kna1.

      PUT kna1.
    ENDSELECT.
  ENDIF.
ENDFORM.                                                    "PUT_KNA1

*----------------------------------------------------------------------*
* FORM PUT_KNBK                                                        *
* Bankverbindung                                                       *
*----------------------------------------------------------------------*
FORM put_knbk.
  SELECT * FROM knbk
           WHERE kunnr = save_kunnr.
    save_banks = knbk-banks.
    save_bankl = knbk-bankl.
  ENDSELECT.
*----------------------------------------------------------------------*
* Bankdaten                                                            *
*----------------------------------------------------------------------*
  SELECT * FROM bnka
           WHERE banks = save_banks
           AND   bankl = save_bankl.
  ENDSELECT.
  PUT knbk.
ENDFORM.                    "PUT_KNBK

*----------------------------------------------------------------------*
* FORM PUT_KNB1                                                        *
* Daten pro Buchungskreis                                              *
*----------------------------------------------------------------------*
FORM put_knb1.
  SELECT (knb1_fields) FROM knb1 INTO CORRESPONDING FIELDS OF knb1
    WHERE kunnr = save_kunnr
    AND   bukrs IN br_bukrs.
    save_bukrs = knb1-bukrs.
    PERFORM t001_read.
    PUT knb1.
  ENDSELECT.
ENDFORM.                                                    "PUT_KNB1

*----------------------------------------------------------------------*
* FORM PUT_KNB4                                                        *
* Zahlungsverhalten                                                    *
*----------------------------------------------------------------------*
FORM put_knb4.
  SELECT * FROM knb4
    WHERE kunnr = save_kunnr
    AND   bukrs = save_bukrs.
    PUT knb4.
  ENDSELECT.
ENDFORM.                                                    "PUT_KNB4

*----------------------------------------------------------------------*
* FORM PUT_KNB5                                                        *
* Mahnsteuerung                                                        *
*----------------------------------------------------------------------*
FORM put_knb5.
  SELECT * FROM knb5
    WHERE kunnr = save_kunnr
    AND   bukrs = save_bukrs.
    PUT knb5.
  ENDSELECT.
ENDFORM.                                                    "PUT_KNB5

*----------------------------------------------------------------------*
* FORM PUT_KNKK                                                        *
* Kundenkreditkontrolle                                                *
*----------------------------------------------------------------------*
FORM put_knkk.
  SELECT * FROM knkk
    WHERE kunnr = save_kunnr
    AND   kkber = t001-kkber.
    PUT knkk.
  ENDSELECT.
ENDFORM.                    "PUT_KNKK

*----------------------------------------------------------------------*
* FORM PUT_KNC1                                                        *
* Monatsverkehrszahlen                                                 *
*----------------------------------------------------------------------*
FORM put_knc1.
  SELECT * FROM knc1
    WHERE kunnr = save_kunnr
    AND   bukrs = save_bukrs
    AND   gjahr IN brdgjahr.
    PUT knc1.
  ENDSELECT.
ENDFORM.                                                    "PUT_KNC1

*----------------------------------------------------------------------*
* FORM PUT_KNC3                                                        *
* Sonderumsaetze                                                       *
*----------------------------------------------------------------------*
FORM put_knc3.
  SELECT * FROM knc3
    WHERE kunnr = save_kunnr
    AND   bukrs = save_bukrs
    AND   gjahr IN brdgjahr.
    PUT knc3.
  ENDSELECT.
ENDFORM.                                                    "PUT_KNC3

*----------------------------------------------------------------------*
*    FORM PUT_LFA1                                                     *
*    Kreditorendaten pro Mandant                                       *
*----------------------------------------------------------------------*
FORM put_lfa1.

  IF b0sg-xldks EQ 'X'.
    SELECT (lfa1_fields) FROM lfa1 INTO CORRESPONDING FIELDS OF lfa1
        WHERE  lifnr IN brklifnr.
      save_lifnr = lfa1-lifnr.
* IAV Intenational Address Version
      CALL METHOD cl_iav_mapping_util=>get_address_as_lfa1
        EXPORTING
          iv_adrnr                 = lfa1-adrnr
          iv_application_component = 'FI_AP'
        CHANGING
          cs_lfa1                  = lfa1.

      PUT lfa1.
    ENDSELECT.
  ENDIF.
ENDFORM.                                                    "PUT_LFA1

*----------------------------------------------------------------------*
*    FORM PUT_LFBK                                                     *
*    Bankverbindung                                                    *
*----------------------------------------------------------------------*
FORM put_lfbk.
  SELECT * FROM lfbk
          WHERE  lifnr = save_lifnr.
    save_banks = lfbk-banks.
    save_bankl = lfbk-bankl.
  ENDSELECT.
*----------------------------------------------------------------------*
*  Bankdaten                                                           *
*----------------------------------------------------------------------*
  SELECT * FROM bnka
             WHERE  banks = save_banks
             AND    bankl = save_bankl.
  ENDSELECT.
  PUT lfbk.
ENDFORM.                    "PUT_LFBK

*----------------------------------------------------------------------*
*    FORM PUT_LFB1                                                     *
*    Daten pro Buchungskreis                                           *
*----------------------------------------------------------------------*
FORM put_lfb1.
  SELECT (lfb1_fields) FROM lfb1 INTO CORRESPONDING FIELDS OF lfb1
         WHERE  lifnr = save_lifnr
         AND    bukrs IN br_bukrs.
    save_bukrs = lfb1-bukrs.
    PERFORM t001_read.
    PUT lfb1.
  ENDSELECT.
ENDFORM.                                                    "PUT_LFB1

*----------------------------------------------------------------------*
*    FORM PUT_LFB5                                                     *
*    Mahnsteuerung                                                     *
*----------------------------------------------------------------------*
FORM put_lfb5.
  SELECT * FROM lfb5 WHERE lifnr = save_lifnr
                     AND   bukrs = save_bukrs.
    PUT lfb5.
  ENDSELECT.
ENDFORM.                                                    "PUT_LFB5

*----------------------------------------------------------------------*
*    FORM PUT_LFC1                                                     *
*    Monatsverkehrszahlen                                              *
*----------------------------------------------------------------------*
FORM put_lfc1.
  SELECT * FROM lfc1 WHERE lifnr  = save_lifnr
                     AND   bukrs  = save_bukrs
                     AND   gjahr IN brkgjahr.

    save_gjahr = lfc1-gjahr.
    PUT lfc1.
  ENDSELECT.
ENDFORM.                                                    "PUT_LFC1

*----------------------------------------------------------------------*
*    FORM PUT_LFC3                                                     *
*    Somderumsaetze                                                    *
*----------------------------------------------------------------------*
FORM put_lfc3.
  SELECT * FROM lfc3 WHERE lifnr EQ save_lifnr
                     AND   bukrs EQ save_bukrs
                     AND   gjahr IN brkgjahr.
    PUT lfc3.
  ENDSELECT.
ENDFORM.                                                    "PUT_LFC3


*--------------------------------------------------------------------*
*        FORM PUT_SKA1                                               *
*        Sachkontendaten pro Mandant                                 *
*--------------------------------------------------------------------*
FORM put_ska1.
  IF b0sg-xldss = 'X'.

*------- Beteiligte Kontenplaene ermitteln ---------------------------*
    REFRESH xx_ktopl.
    REFRESH buktab.
    SELECT * FROM t001
      WHERE bukrs IN br_bukrs.
      buktab-bukrs = t001-bukrs.
      buktab-ktopl = t001-ktopl.
      APPEND buktab.
      kpltab = t001-ktopl.
      COLLECT kpltab.
    ENDSELECT.
    LOOP AT kpltab.
      xx_ktopl-low    = kpltab-ktopl.
      xx_ktopl-sign   = 'I'.
      xx_ktopl-option = 'EQ'.
      APPEND xx_ktopl.
    ENDLOOP.

*------- SKA1 lesen --------------------------------------------------*
    SELECT (ska1_fields) FROM ska1 INTO CORRESPONDING FIELDS OF ska1
      WHERE ktopl IN xx_ktopl
      AND   saknr IN brssaknr
      ORDER BY PRIMARY KEY.

*        Kontenplanwechsel
      IF save_ktopl NE ska1-ktopl.
        REFRESH xx_bukrs.
        LOOP AT buktab WHERE ktopl = ska1-ktopl.
          xx_bukrs-low    = buktab-bukrs.
          xx_bukrs-sign   = 'I'.
          xx_bukrs-option = 'EQ'.
          APPEND xx_bukrs.
        ENDLOOP.
        save_ktopl = ska1-ktopl.
        SELECT  * FROM skat
          APPENDING TABLE xskat
          WHERE spras =  sy-langu
          AND   ktopl =  save_ktopl
          AND   saknr IN brssaknr
          ORDER BY mandt saknr.
        cursor_t = 1.
      ENDIF.
      save_saknr = ska1-saknr.

*        Sachkontenbezeichnung dazulesen
      PERFORM skat_lesen.

      PUT ska1.
    ENDSELECT.
  ENDIF.
ENDFORM.                                                    "PUT_SKA1

*--------------------------------------------------------------------*
*        FORM PUT_SKB1                                               *
*--------------------------------------------------------------------*
FORM put_skb1.
  SELECT (skb1_fields) FROM skb1 INTO CORRESPONDING FIELDS OF skb1
    WHERE saknr =  save_saknr
    AND   bukrs IN xx_bukrs
    ORDER BY mandt saknr bukrs.

*        KEY-Felder sichern
    save_bukrs = skb1-bukrs.
    save_waers = skb1-waers.

*        Hauswaehrungsschluessel besorgen
    PERFORM t001_read.

    PUT skb1.
  ENDSELECT.
ENDFORM.                                                    "PUT_SKB1

*--------------------------------------------------------------------*
*        FORM PUT_SKC1A  - Verarbeitung Hauswährung -                *
*--------------------------------------------------------------------*
FORM put_skc1a.
  REFRESH: xskc1a.
* Schluessel zum Lesen GLT0 aufbauen
  PERFORM glkey_aufbauen.

* Soll + Habenbuchungen  (UM01S - UM16S) / UM01H - UM16H)
  PERFORM glt0_lesen USING 'SKC1A'.

* Saldo des Monats  (UM01O - UM16O)
  PERFORM saldo_des_monats_skc1a.

* Saldo zum GM-Ende (UM01K - UM16K)
  PERFORM saldo_zum_gm_ende_skc1a.

* Segmente an den Report uebergeben
  LOOP AT xskc1a.
    skc1a = xskc1a.
    PUT skc1a.
  ENDLOOP.
ENDFORM.                                                    "PUT_SKC1A


*--------------------------------------------------------------------*
*        FORM PUT_SKC1C  - Verarbeitung Verkehrszahlen je Währung -  *
*--------------------------------------------------------------------*
FORM put_skc1c.
  REFRESH: xskc1c.
* Schluessel zum Lesen GLT0 aufbauen
  PERFORM glkey_aufbauen.

* Sollbuchungen  (UM01S - UM16S) (WM01S - WM16S)
* Habenbuchungen (UM01H - UM16H) (WM01H - WM16H)
  PERFORM glt0_lesen USING 'SKC1C'.

* Saldo des Monats  (UM01O - UM16O) (WM01O - WM16O)
  PERFORM saldo_des_monats_skc1c.

* Saldo zum GM-Ende (UM01K - UM16K) (WM01K - WM16K)
  PERFORM saldo_zum_gm_ende_skc1c.

* Segmente an den Report uebergeben
  LOOP AT xskc1c.
    skc1c = xskc1c.
    PUT skc1c.
  ENDLOOP.
ENDFORM.                                                    "PUT_SKC1C

*eject
***********************************************************************
*        Interne Form Routinen
***********************************************************************

*----------------------------------------------------------------------*
* FORM T001_READ                                                       *
* Buchungskreisdaten                                                   *
*----------------------------------------------------------------------*
FORM t001_read.
* IF T001-BUKRS NE SAVE_BUKRS.
*   SELECT SINGLE * FROM T001
*     WHERE BUKRS = SAVE_BUKRS.
* ENDIF.
  CALL FUNCTION 'READ_T001'
    EXPORTING
      xbukrs = save_bukrs
    IMPORTING
      struct = t001.
  IF alcur EQ 'X'. PERFORM read_taltwar.  ENDIF.            "<<<< euro
  sp_waers = t001-waers.               "<<<< euro
ENDFORM.                                                    "T001_READ

*--------------------------------------------------------------------*
*        FORM GLKEY_AUFBAUEN                                         *
*--------------------------------------------------------------------*
FORM glkey_aufbauen.
  glkey-rldnr =  '00'.                 " Ledger-Nr  fix '00'
  glkey-rrcty =  '0'.                  " Satztyp    fix '0'
  glkey-rvers =  '001'.                " Version    fix '001'
  glkey-bukrs =  save_bukrs.           " Bukreis    aus SKB1-BUKRS
  glkey-racct =  save_saknr.           " Konto      aus SKA1-SAKNR
* GLKEY-RTCUR =  SAVE_WAERS.                " Waehrung   aus SKB1-WAERS
* GLKEY-DRCRK =  'S'.                       " S/H-Kennz  fix 'S'
* GLKEY-RPMAX =  '016'.                     " Bis-Perioe fix '16'
ENDFORM.                    "GLKEY_AUFBAUEN

*EJECT
*--------------------------------------------------------------------*
*        FORM GLT0_LESEN                                             *
*--------------------------------------------------------------------*
FORM glt0_lesen USING table.
  IF g_glflex_active IS INITIAL.
    SELECT * FROM glt0 INTO TABLE gt_glt0
      WHERE rldnr =  glkey-rldnr         " Ledger-Nr  fix '00'
        AND rrcty =  glkey-rrcty         " Satztyp    fix '0'
        AND rvers =  glkey-rvers         " Version    fix '001'
        AND bukrs =  glkey-bukrs         " Bukreis    aus SKB1-BUKRS
        AND ryear IN brsgjahr            " Ges.Jahr   aus Eingabe
        AND racct =  glkey-racct         " Konto      aus SKA1-SAKNR
        AND rbusa IN brsgsber.           " Gesch.Ber  aus Eingabe
*     AND DRCRK =  GLKEY-DRCRK              " S/H-Kennz  fix 'S'
*     AND RPMAX =  GLKEY-RPMAX.             " Bis-Perioe fix '16'
  ELSE.
*   Check whether special balances have to be displayed         1878575
    IF NOT b0sg-xstaj IS INITIAL.
      RANGES: lr_stype FOR glt0-rrcty.
      CLEAR   lr_stype.
      REFRESH lr_stype.
      lr_stype-sign   = 'I'.
      lr_stype-option = 'EQ'.
      lr_stype-low    = '0'.
      append lr_stype.
      lr_stype-low    = '5'.
      append lr_stype.
      CALL FUNCTION 'FAGL_GET_GLT0'
        EXPORTING
          i_glt0_rldnr      = glkey-rldnr
          i_rldnr           = g_rldnr
*          i_rrcty           = glkey-rrcty
          i_rvers           = glkey-rvers
          i_bukrs           = glkey-bukrs
          i_racct           = glkey-racct
          i_range_rrcty     = lr_stype[]
          i_range_ryear     = brsgjahr[]
          i_range_rbusa     = brsgsber[]
          it_where_clause   = faglfreesel_where
          i_authority_check = 'X'
        IMPORTING
          et_glt0             = gt_glt0[].
*   Check whether special balances have to be displayed         1878575
    ELSE.
      CALL FUNCTION 'FAGL_GET_GLT0'
        EXPORTING
          i_glt0_rldnr      = glkey-rldnr
          i_rldnr           = g_rldnr
          i_rrcty           = glkey-rrcty
          i_rvers           = glkey-rvers
          i_bukrs           = glkey-bukrs
*         I_RYEAR           =
          i_racct           = glkey-racct
*         I_RBUSA           =
*         I_RTCUR           =
*         I_DRCRK           =
*         I_RPMAX           =
*         I_RANGE_RRCTY     =
*         I_RANGE_RVERS     =
*         I_RANGE_BUKRS     =
          i_range_ryear     = brsgjahr[]
          i_range_rbusa     = brsgsber[]
*         I_RANGE_RACCT     =
*         I_RANGE_RTCUR     =
*         I_RANGE_DRCRK     =
*         I_RANGE_RPMAX     =
          it_where_clause   = faglfreesel_where
          i_authority_check = 'X'                             "ERP05
      IMPORTING
        et_glt0           = gt_glt0[].
      ENDIF.
  ENDIF.

  LOOP AT gt_glt0 INTO glt0.
    IF table EQ 'SKC1A'.
*   Tabelle XSKC1A mit Verkehrszahlen pro Gesch.Ber in HW aufbauen
*   --------------------------------------------------------
      PERFORM xskc1a_aufbauen USING glt0-drcrk.
    ELSE.
*   Tabelle XSKC1C mit Verkehrszahlen pro Gesch.Ber pro HW/FW aufbauen
*   --------------------------------------------------------
      PERFORM xskc1c_aufbauen USING glt0-drcrk.
    ENDIF.
  ENDLOOP.
ENDFORM.                                                    "GLT0_LESEN

*--------------------------------------------------------------------*
*        FORM XSKC1A_AUFBAUEN                                        *
*        Soll- und Haben-Verkehrszahlen pro Gesch-Ber.               *
*--------------------------------------------------------------------*
FORM xskc1a_aufbauen USING xskc1a_drcrk.
  CASE xskc1a_drcrk.
    WHEN 'S'.
*   Soll-Buchungen
*   --------------
      CLEAR: xskc1a.
      xskc1a-mandt = glt0-rclnt.
      xskc1a-bukrs = glt0-bukrs.
      xskc1a-saknr = glt0-racct.
      xskc1a-gjahr = glt0-ryear.
      xskc1a-gsber = glt0-rbusa.
*   XSKC1A-HWAER = GLT0-RTCUR.
      xskc1a-hwaer = t001-waers.
      xskc1a-rrcty = glt0-rrcty.
      xskc1a-rvers = glt0-rvers.

*   Hauswaehrung uebertragen
*   ------------------------
      xskc1a-umsav = glt0-hslvt.
      DO 16 TIMES
        VARYING refe1 FROM glt0-hsl01   NEXT glt0-hsl02
        VARYING refe2 FROM xskc1a-um01s NEXT xskc1a-um02s.
        refe2 = refe1.
      ENDDO.

      COLLECT xskc1a.

    WHEN 'H'.
*   Haben-Buchungen
*   ---------------
      CLEAR: xskc1a.
      xskc1a-mandt = glt0-rclnt.
      xskc1a-bukrs = glt0-bukrs.
      xskc1a-saknr = glt0-racct.
      xskc1a-gjahr = glt0-ryear.
      xskc1a-gsber = glt0-rbusa.
*   XSKC1A-HWAER = GLT0-RTCUR.
      xskc1a-hwaer = t001-waers.
      xskc1a-rrcty = glt0-rrcty.
      xskc1a-rvers = glt0-rvers.

*   Hauswaehrung uebertragen
*   ------------------------
      xskc1a-umsav = glt0-hslvt.
      DO 16 TIMES
        VARYING refe1 FROM glt0-hsl01   NEXT glt0-hsl02
        VARYING refe2 FROM xskc1a-um01h NEXT xskc1a-um02h.
        refe2 = refe1 * -1.
      ENDDO.


      COLLECT xskc1a.

  ENDCASE.
ENDFORM.                    "XSKC1A_AUFBAUEN

*--------------------------------------------------------------------*
*        FORM XSKC1C_AUFBAUEN                                        *
*        Soll- und Haben-Verkehrszahlen pro Gesch-Ber und Währung    *
*--------------------------------------------------------------------*
FORM xskc1c_aufbauen USING xskc1c_drcrk.
  CASE xskc1c_drcrk.
    WHEN 'S'.
*   Soll-Buchungen
*   --------------
      CLEAR: xskc1c.
      xskc1c-mandt = glt0-rclnt.
      xskc1c-bukrs = glt0-bukrs.
      xskc1c-saknr = glt0-racct.
      xskc1c-gjahr = glt0-ryear.
      xskc1c-gsber = glt0-rbusa.
*   XSKC1C-HWAER = GLT0-RTCUR.
      xskc1c-hwaer = t001-waers.
      xskc1c-fwaer = glt0-rtcur.
      xskc1c-rrcty = glt0-rrcty.
      xskc1c-rvers = glt0-rvers.

*   Hauswaehrung uebertragen
*   ------------------------
      xskc1c-umsav = glt0-hslvt.
      DO 16 TIMES
        VARYING refe1 FROM glt0-hsl01   NEXT glt0-hsl02
        VARYING refe2 FROM xskc1c-um01s NEXT xskc1c-um02s.
        refe2 = refe1.
      ENDDO.

*   Fremdwaehrung uebertragen
*   -------------------------
*   IF SAVE_WAERS NE T001-WAERS.
*   Übertragung der Beträge für das Währungskennzeichen aus B-Segment.
*   IF SAVE_WAERS EQ GLT0-RTCUR.
      xskc1c-slvfw = glt0-tslvt.
      DO 16 TIMES
        VARYING refe1 FROM glt0-tsl01   NEXT glt0-tsl02
        VARYING refe2 FROM xskc1c-wm01s NEXT xskc1c-wm02s.
        refe2 = refe1.
      ENDDO.
*   ENDIF.

      COLLECT xskc1c.

    WHEN 'H'.
*   Haben-Buchungen
*   ---------------
      CLEAR: xskc1c.
      xskc1c-mandt = glt0-rclnt.
      xskc1c-bukrs = glt0-bukrs.
      xskc1c-saknr = glt0-racct.
      xskc1c-gjahr = glt0-ryear.
      xskc1c-gsber = glt0-rbusa.
*   XSKC1C-HWAER = GLT0-RTCUR.
      xskc1c-hwaer = t001-waers.
      xskc1c-fwaer = glt0-rtcur.
      xskc1c-rrcty = glt0-rrcty.
      xskc1c-rvers = glt0-rvers.

*   Hauswaehrung uebertragen
*   ------------------------
      xskc1c-umsav = glt0-hslvt.
      DO 16 TIMES
        VARYING refe1 FROM glt0-hsl01   NEXT glt0-hsl02
        VARYING refe2 FROM xskc1c-um01h NEXT xskc1c-um02h.
        refe2 = refe1 * -1.
      ENDDO.

*   Fremdwaehrung uebertragen
*   -------------------------
*   IF SAVE_WAERS NE T001-WAERS.
*   Übertragung der Beträge für das Währungskennzeichen aus B-Segment.
*   IF SAVE_WAERS EQ GLT0-RTCUR.
      xskc1c-slvfw = glt0-tslvt.
      DO 16 TIMES
        VARYING refe1 FROM glt0-tsl01   NEXT glt0-tsl02
        VARYING refe2 FROM xskc1c-wm01h NEXT xskc1c-wm02h.
        refe2 = refe1 * -1.
      ENDDO.
*   ENDIF.

      COLLECT xskc1c.

  ENDCASE.
ENDFORM.                    "XSKC1C_AUFBAUEN

*--------------------------------------------------------------------*
*        FORM SALDO_DES_MONATS_SKC1A                                 *
*        Saldo des Monats  (UM01O - UM16O)                           *
*--------------------------------------------------------------------*
FORM saldo_des_monats_skc1a.
  LOOP AT xskc1a.
*   Hauswaehrungs-Salden
*   --------------------
    DO 16 TIMES
      VARYING refe1 FROM xskc1a-um01s NEXT xskc1a-um02s
      VARYING refe2 FROM xskc1a-um01h NEXT xskc1a-um02h
      VARYING refe3 FROM xskc1a-um01o NEXT xskc1a-um02o.
      refe3 = refe1 - refe2.
    ENDDO.


    MODIFY xskc1a INDEX sy-tabix.
  ENDLOOP.
ENDFORM.                    "SALDO_DES_MONATS_SKC1A

*--------------------------------------------------------------------*
*        FORM SALDO_DES_MONATS_SKC1C                                 *
*        Saldo des Monats  (UM01O - UM16O)  (WM01O - WM16O)          *
*--------------------------------------------------------------------*
FORM saldo_des_monats_skc1c.
  LOOP AT xskc1c.
*   Hauswaehrungs-Salden
*   --------------------
    DO 16 TIMES
      VARYING refe1 FROM xskc1c-um01s NEXT xskc1c-um02s
      VARYING refe2 FROM xskc1c-um01h NEXT xskc1c-um02h
      VARYING refe3 FROM xskc1c-um01o NEXT xskc1c-um02o.
      refe3 = refe1 - refe2.
    ENDDO.

*   Fremdwaehrungs-Salden
*   ---------------------
    DO 16 TIMES
      VARYING refe1 FROM xskc1c-wm01s NEXT xskc1c-wm02s
      VARYING refe2 FROM xskc1c-wm01h NEXT xskc1c-wm02h
      VARYING refe3 FROM xskc1c-wm01o NEXT xskc1c-wm02o.
      refe3 = refe1 - refe2.
    ENDDO.

    MODIFY xskc1c INDEX sy-tabix.
  ENDLOOP.
ENDFORM.                    "SALDO_DES_MONATS_SKC1C

*EJECT
*--------------------------------------------------------------------*
*        FORM SALDO_ZUM_GM_ENDE_SKC1A                                *
*        Saldo zum GM-Ende (UM01K - UM16K)                           *
*--------------------------------------------------------------------*
FORM saldo_zum_gm_ende_skc1a.
* local data declaration
  DATA: l_umo LIKE skc1a-um01o.
  DATA: l_slk LIKE skc1a-um01k.
  DATA: l_umk LIKE skc1a-um01k.

  LOOP AT xskc1a.
*   Hauswaehrungs-Salden
*   --------------------
    CLEAR: l_slk.
    DO 16 TIMES
      VARYING l_umo FROM xskc1a-um01o NEXT xskc1a-um02o
      VARYING l_umk FROM xskc1a-um01k NEXT xskc1a-um02k.
      l_slk = l_slk + l_umo.
      l_umk = l_slk + xskc1a-umsav.
    ENDDO.

    MODIFY xskc1a INDEX sy-tabix.
  ENDLOOP.
ENDFORM.                    "SALDO_ZUM_GM_ENDE_SKC1A

*--------------------------------------------------------------------*
*        FORM SALDO_ZUM_GM_ENDE_SKC1C                                *
*        Saldo zum GM-Ende (UM01K - UM16K)  (WM01K - WM16K)          *
*--------------------------------------------------------------------*
FORM saldo_zum_gm_ende_skc1c.
* local data declaration
  DATA: l_umo LIKE skc1c-um01o.
  DATA: l_slk LIKE skc1c-um01k.
  DATA: l_umk LIKE skc1c-um01k.

  LOOP AT xskc1c.
*   Hauswaehrungs-Salden
*   --------------------
    CLEAR: l_slk.
    DO 16 TIMES
      VARYING l_umo FROM xskc1c-um01o NEXT xskc1c-um02o
      VARYING l_umk FROM xskc1c-um01k NEXT xskc1c-um02k.
      l_slk = l_slk + l_umo.
      l_umk = l_slk + xskc1c-umsav.
    ENDDO.

*   Fremdwaehrungs-Salden
*   ---------------------
    CLEAR: l_slk.
    DO 16 TIMES
      VARYING l_umo FROM xskc1c-wm01o NEXT xskc1c-wm02o
      VARYING l_umk FROM xskc1c-wm01k NEXT xskc1c-wm02k.
      l_slk = l_slk + l_umo.
      l_umk = l_slk + xskc1c-slvfw.
    ENDDO.

    MODIFY xskc1c INDEX sy-tabix.
  ENDLOOP.
ENDFORM.                    "SALDO_ZUM_GM_ENDE_SKC1C


*----------------------------------------------------------------------*
*        FORM SKAT_LESEN
*             Lesen der Sachkontentexte
*----------------------------------------------------------------------*
FORM skat_lesen.
  DO.
    READ TABLE xskat INDEX cursor_t.
    IF sy-subrc = 0.
      skat = xskat.
    ELSE.
      CLEAR skat.
      EXIT.
    ENDIF.
    IF skat-saknr < save_saknr.
      cursor_t = cursor_t + 1.
    ENDIF.
    IF skat-saknr > save_saknr.
      EXIT.
    ENDIF.
    IF skat-saknr = save_saknr.
      cursor_t = cursor_t + 1.
      EXIT.
    ENDIF.
  ENDDO.

*        In der Anmeldesprache ist keine Sachkontenbezeichung vorhanden
*        Es werden die Texte der Pflegesprache gelesen.
  IF skat-saknr NE save_saknr.
    IF save_ktopl NE t004-ktopl.
      SELECT SINGLE * FROM t004 WHERE ktopl = save_ktopl.
    ENDIF.
    SELECT SINGLE * FROM skat
      WHERE spras = t004-dspra
      AND   ktopl = save_ktopl
      AND   saknr = save_saknr.
  ENDIF.
ENDFORM.                    "SKAT_LESEN


*--------------------------------------------------------------------*
* Die ROUTINE BSTAT_FUELLEN dient dazu die Selektion auf Belege mit  *
* einem bestimmten Belegstatus einzuschränken. Dazu sind im Selek-   *
* tionsreport zum Zeitpunkt START-OF-SELECTION die diversen Schalter *
* der Tabelle B0SG zu setzen. In Abhängigkeit vom Wert wird zum      *
* Zeitpunkt FORM B0SG die interne Tabelle BR_BSTAT  gefüllt.         *
*--------------------------------------------------------------------*


FORM bstat_fuellen.

*     Normale Belege ?
  IF b0sg-xstan = 'X'.
    br_bstat-sign   = 'I'.
    br_bstat-low    = space.
    br_bstat-option = 'EQ'.
    APPEND br_bstat.
  ELSE.
*       unmoegliches Kennzeichen um leere BR_BSTAT zu vermeiden
    br_bstat-low    = '?'.
    br_bstat-sign   = 'I'.
    br_bstat-option = 'EQ'.
    APPEND br_bstat.
  ENDIF.

* select documents which are not posted to leading ledger
  IF b0sg-xstam ne 'X'.                                     "1548599
    br_bstat-sign   = 'I'.                                  "969691
    br_bstat-option = 'EQ'.                                 "969691
    br_bstat-low    = 'L'.                                  "969691
    APPEND br_bstat.                                        "969691
  ENDIF.                                                    "1548599
*     Dauerbuchungsurbelege ?
  IF b0sg-xstad = 'X'.
    br_bstat-sign   = 'I'.
    br_bstat-low    = 'D'.
    br_bstat-option = 'EQ'.
    APPEND br_bstat.
  ENDIF.

*     MUSTERBELEGE   ?
  IF b0sg-xstam = 'X'.
    READ TABLE br_bstat INDEX 1.
    IF br_bstat-low = '?'.
      DELETE br_bstat INDEX 1.
    ENDIF.
    br_bstat-sign   = 'I'.
    br_bstat-low    = 'M'.
    br_bstat-option = 'EQ'.
    APPEND br_bstat.
  ENDIF.

*     Statistische Belege ?
  IF b0sg-xstas = 'X'.
    br_bstat-sign   = 'I'.
    br_bstat-low    = 'S'.
    br_bstat-option = 'EQ'.
    APPEND br_bstat.
  ENDIF.

*     AusgleichBelege ?                                      "<<<< 40A
  IF b0sg-xstaa = 'X'.                                      "<<<< 40A
    br_bstat-sign   = 'I'.                                  "<<<< 40A
    br_bstat-low    = 'A'.                                  "<<<< 40A
    br_bstat-option = 'EQ'.                                 "<<<< 40A
    APPEND br_bstat.                                        "<<<< 40A
  ENDIF.                                                    "<<<< 40A

*     zurückgenommene AusgleichBelege ?                      "<<<< 40A
  IF b0sg-xstab = 'X'.                                      "<<<< 40A
    br_bstat-sign   = 'I'.                                  "<<<< 40A
    br_bstat-low    = 'B'.                                  "<<<< 40A
    br_bstat-option = 'EQ'.                                 "<<<< 40A
    APPEND br_bstat.                                        "<<<< 40A
  ENDIF.                                                    "<<<< 40A

*     jahresabschlussBelege ?
  IF b0sg-xstaj = 'X'.                                      "<<<< EHP4
    br_bstat-sign   = 'I'.                                  "<<<< EHP4
    br_bstat-low    = 'J'.                                  "<<<< EHP4
    br_bstat-option = 'EQ'.                                 "<<<< EHP4
    APPEND br_bstat.                                        "<<<< EHP4
    br_bstat-sign   = 'I'.
    br_bstat-low    = 'O'.
    br_bstat-option = 'EQ'.
    APPEND br_bstat.
  ENDIF.

*     fuer Zugriff auf geloeschte voererfasste Belege
  zw_bstat-sign = 'I'.
  zw_bstat-option = 'EQ'.

  zw_bstat-low = 'Z'.
  APPEND zw_bstat.

  zw_bstat-low = 'W'.
  APPEND zw_bstat.

* select documents which are not posted to leading ledger
*  br_bstat-sign   = 'I'.                                        "969691
*  br_bstat-option = 'EQ'.                                       "969691
*  br_bstat-low    = 'L'.                                        "969691
*  append br_bstat.                                              "969691

*        Optimierungsroutinen fuer ORACLE
*        Bei Belegintervall richtigen Index verwenden
  DESCRIBE TABLE br_bstat LINES i.
  READ TABLE br_bstat INDEX 1.
  IF i = 1
  AND br_bstat-option = 'EQ'
  AND br_bstat-low = space.
    READ TABLE br_belnr INDEX 1.
    IF sy-subrc = 0.
      READ TABLE br_bukrs INDEX 1.
      IF sy-subrc = 0.
        READ TABLE br_blart INDEX 1.
        IF sy-subrc NE 0.
          READ TABLE br_xblnr INDEX 1.
          IF sy-subrc NE 0.
            READ TABLE br_budat INDEX 1.
            IF sy-subrc NE 0.
              br_bstat-option = 'BT'.
              br_bstat-high   = br_bstat-low.
              MODIFY br_bstat INDEX 1. "lesen ueber index__0.
*                 REFRESH BR_BSTAT.       "lesen ueber Index__0
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*        BR_Belnr und BR_Gjahr mit Dummy Intervall fuellen
*        wegen Order By
    READ TABLE br_awtyp INDEX 1.
    IF sy-subrc NE 0.
      READ TABLE br_blart INDEX 1.
      IF sy-subrc NE 0.
        READ TABLE br_xblnr INDEX 1.
        IF sy-subrc NE 0.
          READ TABLE br_budat INDEX 1.
          IF sy-subrc NE 0.
            br_bstat-option = 'BT'.
            br_bstat-high   = br_bstat-low.
            MODIFY br_bstat INDEX 1.
            READ TABLE br_belnr INDEX 1.
            IF sy-subrc NE 0.
              READ TABLE br_cpudt INDEX 1.  "<-- 3.0F für CPU Datum
              IF sy-subrc NE 0.        "<-- 3.0F für CPU Datum
                br_belnr-low    = space.
                br_belnr-high   = highval.
                br_belnr-sign   = 'I'.
                br_belnr-option = 'BT'.
                APPEND br_belnr.       "lesen ueber index__0.
              ENDIF.                   "<-- 3.0F für CPU Datum
            ENDIF.
            READ TABLE br_gjahr INDEX 1.
            IF sy-subrc NE 0.
              br_gjahr-low    = space.
              br_gjahr-high   = '9999'.
              br_gjahr-sign   = 'I'.
              br_gjahr-option = 'BT'.
              APPEND br_gjahr.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.                               "nur normale Belege

ENDFORM.                    "BSTAT_FUELLEN

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_BKPF                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_bkpf.
  DATA: zrc1 TYPE n.
  zrc1 = 0.
  AUTHORITY-CHECK OBJECT 'F_BKPF_BUK'
              ID 'BUKRS' FIELD save_bukrs
              ID 'ACTVT' FIELD '03'.
  IF sy-subrc EQ 0.
    IF au_blart EQ 'X'.
      PERFORM auth_blart USING bkpf-blart CHANGING zrc1.
      IF zrc1 EQ 0.
        sy-subrc = 0.
      ELSE.
        sy-subrc = 4.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

* tpc
  IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X'.

*   Stichtagsliste
    CALL FUNCTION 'FI_CHECK_DATE'
      EXPORTING
        i_bukrs           = bkpf-bukrs
        i_user            = sy-uname
        i_program         = 'SAPDBBRF'
        i_from_date       = bkpf-budat
      EXCEPTIONS
        no_authority_prog = 1
        no_authority_date = 2
        wrong_parameter   = 3
        OTHERS            = 4.

    CASE sy-subrc.
      WHEN 0.
      WHEN 2.
        sy-subrc = 4.
      WHEN OTHERS.
        sy-subrc = 4.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.

ENDFORM.                    "AUTHORITYCHECK_BKPF

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_BSEG                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_bseg.
  DATA : zrc2 TYPE n.
  STATICS: sd_auth_flag TYPE c,
           sd_first     TYPE c.
  zrc2 = 0.
  IF au_gsber EQ 'X'.
    PERFORM auth_gsber USING bseg-gsber CHANGING zrc2.
    IF zrc2 EQ 0.
      sy-subrc = 0.
    ELSE.
      sy-subrc = 4.
    ENDIF.
  ENDIF.
  IF sy-subrc = 0.
    IF sd_first IS INITIAL.
      sd_first = 'X'.
      PERFORM switch_auth_f_bkpf_bex USING sd_auth_flag.
    ENDIF.
    IF NOT sd_auth_flag IS INITIAL AND autbexno IS INITIAL.
      PERFORM auth_check_bkpf_bex CHANGING zrc2.
      sy-subrc = zrc2.
    ENDIF.
  ENDIF.
  IF sy-subrc NE 0.
    ADD 1 TO cnt_no_auth.
  ENDIF.
ENDFORM.                    "AUTHORITYCHECK_BSEG

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_KNA1                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_kna1.
  IF NOT ( kna1-begru IS INITIAL ).
    AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                  ID 'BRGRU' FIELD kna1-begru
                  ID 'ACTVT' FIELD '03'.
  ENDIF.
ENDFORM.                    "AUTHORITYCHECK_KNA1

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_KNB1                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_knb1.
  IF NOT ( knb1-begru IS INITIAL ).
    AUTHORITY-CHECK OBJECT 'F_KNA1_BED'
                  ID 'BRGRU' FIELD knb1-begru
                  ID 'ACTVT' FIELD '03'.
  ENDIF.
ENDFORM.                    "AUTHORITYCHECK_KNB1

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_KNC1                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_knc1.

* tpc
  IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X'.
    CALL FUNCTION 'FI_CHECK_DATE'
      EXPORTING
        i_bukrs           = knc1-bukrs
        i_user            = sy-uname
        i_program         = 'SAPDBBRF'
        i_from_year       = knc1-gjahr
      EXCEPTIONS
        no_authority_prog = 1
        no_authority_date = 2
        wrong_parameter   = 3
        OTHERS            = 4.

    CASE sy-subrc.
      WHEN 0.
      WHEN 2.
        sy-subrc = 4.
      WHEN OTHERS.
        sy-subrc = 4.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.

ENDFORM.                    "AUTHORITYCHECK_KNC1

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_KNC3                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_knc3.

* tpc
  IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X'.
    CALL FUNCTION 'FI_CHECK_DATE'
      EXPORTING
        i_bukrs           = knc3-bukrs
        i_user            = sy-uname
        i_program         = 'SAPDBBRF'
        i_from_year       = knc3-gjahr
      EXCEPTIONS
        no_authority_prog = 1
        no_authority_date = 2
        wrong_parameter   = 3
        OTHERS            = 4.

    CASE sy-subrc.
      WHEN 0.
      WHEN 2.
        sy-subrc = 4.
      WHEN OTHERS.
        sy-subrc = 4.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.

ENDFORM.                    "AUTHORITYCHECK_KNC3

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_LFA1                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_lfa1.
  IF NOT ( lfa1-begru IS INITIAL ).
    AUTHORITY-CHECK OBJECT 'F_LFA1_BEK'
                ID 'BRGRU' FIELD lfa1-begru
                ID 'ACTVT' FIELD '03'.
  ENDIF.
ENDFORM.                    "AUTHORITYCHECK_LFA1

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_LFB1                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_lfb1.
  IF NOT ( lfb1-begru IS INITIAL ).
    AUTHORITY-CHECK OBJECT 'F_LFA1_BEK'
                ID 'BRGRU' FIELD lfb1-begru
                ID 'ACTVT' FIELD '03'.
  ENDIF.
ENDFORM.                    "AUTHORITYCHECK_LFB1

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_LFC1                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_lfc1.

* tpc
  IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X'.
    CALL FUNCTION 'FI_CHECK_DATE'
      EXPORTING
        i_bukrs           = lfc1-bukrs
        i_user            = sy-uname
        i_program         = 'SAPDBBRF'
        i_from_year       = lfc1-gjahr
      EXCEPTIONS
        no_authority_prog = 1
        no_authority_date = 2
        wrong_parameter   = 3
        OTHERS            = 4.

    CASE sy-subrc.
      WHEN 0.
      WHEN 2.
        sy-subrc = 4.
      WHEN OTHERS.
        sy-subrc = 4.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.

ENDFORM.                    "AUTHORITYCHECK_LFC1


*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_LFC3                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_lfc3.

* tpc
  IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X'.
    CALL FUNCTION 'FI_CHECK_DATE'
      EXPORTING
        i_bukrs           = lfc3-bukrs
        i_user            = sy-uname
        i_program         = 'SAPDBBRF'
        i_from_year       = lfc3-gjahr
      EXCEPTIONS
        no_authority_prog = 1
        no_authority_date = 2
        wrong_parameter   = 3
        OTHERS            = 4.

    CASE sy-subrc.
      WHEN 0.
      WHEN 2.
        sy-subrc = 4.
      WHEN OTHERS.
        sy-subrc = 4.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.

ENDFORM.                    "AUTHORITYCHECK_LFC3

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_SKB1                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_skb1.
  IF NOT ( skb1-begru IS INITIAL ).
    AUTHORITY-CHECK OBJECT 'F_SKA1_BES'
                ID 'BRGRU' FIELD skb1-begru
                ID 'ACTVT' FIELD '03'.
  ENDIF.
ENDFORM.                    "AUTHORITYCHECK_SKB1

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_SKC1A                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_skc1a.                                  "<<<< au40
  DATA: zrc1 TYPE n.
  zrc1 = 0.
  IF au_gsber = 'X'.
    PERFORM auth_gsber USING skc1a-gsber CHANGING zrc1.
  ENDIF.
  IF zrc1 NE 0.
    sy-subrc = 4.
    EXIT.
  ELSE.
    sy-subrc = 0.
  ENDIF.

* tpc
  IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X'.
    CALL FUNCTION 'FI_CHECK_DATE'
      EXPORTING
        i_bukrs           = skc1a-bukrs
        i_user            = sy-uname
        i_program         = 'SAPDBBRF'
        i_from_year       = skc1a-gjahr
      EXCEPTIONS
        no_authority_prog = 1
        no_authority_date = 2
        wrong_parameter   = 3
        OTHERS            = 4.

    CASE sy-subrc.
      WHEN 0.
      WHEN 2.
        sy-subrc = 4.
      WHEN OTHERS.
        sy-subrc = 4.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.

ENDFORM.                    "AUTHORITYCHECK_SKC1A

*---------------------------------------------------------------------*
*       FORM AUTHORITYCHECK_SKC1C                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authoritycheck_skc1c.                                  "<<<< au40
  DATA: zrc1 TYPE n.
  zrc1 = 0.
  IF au_gsber = 'X'.
    PERFORM auth_gsber USING skc1c-gsber CHANGING zrc1.
  ENDIF.
  IF zrc1 NE 0.
    sy-subrc = 4.
    EXIT.
  ELSE.
    sy-subrc = 0.
  ENDIF.

* tpc
  IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X'.
    CALL FUNCTION 'FI_CHECK_DATE'
      EXPORTING
        i_bukrs           = skc1c-bukrs
        i_user            = sy-uname
        i_program         = 'SAPDBBRF'
        i_from_year       = skc1c-gjahr
      EXCEPTIONS
        no_authority_prog = 1
        no_authority_date = 2
        wrong_parameter   = 3
        OTHERS            = 4.

    CASE sy-subrc.
      WHEN 0.
      WHEN 2.
        sy-subrc = 4.
      WHEN OTHERS.
        sy-subrc = 4.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.

ENDFORM.                    "AUTHORITYCHECK_SKC1C

*---------------------------------------------------------------------*
*       FORM AUTHORITY_CHECK_KOART                                    *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM authority_check_koart.
  DO 3 TIMES.
    CASE sy-index.
      WHEN '1'.
        MOVE 'K' TO koart.
      WHEN '2'.
        MOVE 'D' TO koart.
      WHEN '3'.
        MOVE 'S' TO koart.
    ENDCASE.

    AUTHORITY-CHECK OBJECT 'F_BKPF_KOA'
                ID 'KOART' FIELD koart
                ID 'ACTVT' FIELD '03'.
    IF sy-subrc <> 0.
      MOVE '4' TO retcode.
    ENDIF.
  ENDDO.
ENDFORM.                    "AUTHORITY_CHECK_KOART

*---------------------------------------------------------------------*
*       FORM READ_ARCHIV_DATA                                         *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM read_archiv_data.

  TYPES: BEGIN OF gs_ledger,
           rldnr TYPE fagl_rldnr,
         END OF gs_ledger.

  DATA: lt_files      TYPE TABLE OF admi_files,
        wa_files      TYPE admi_files,
        lv_cnt_tot    TYPE sy-tabix.

  TYPES: BEGIN OF lty_result,
           archivekey  TYPE arkey,
           archiveofs  TYPE admi_offst.
          INCLUDE STRUCTURE bkpf_key.
  TYPES  END OF lty_result.
  TYPES: lty_t_result TYPE STANDARD TABLE OF lty_result.

  DATA: lt_obligatory_fields TYPE STANDARD TABLE OF aind_dstf,
        lt_selections_as     TYPE rsds_frange_t,
        lw_result            TYPE lty_result,
        lt_result            TYPE lty_t_result,
        lt_fieldcat          TYPE STANDARD TABLE OF aind_str1-archindex,
        ld_fieldcat          TYPE aind_str1-archindex.

  data: ld_no_infostr type boolean.                         "1164669

  data: mssg_typ(1),                      "I-Mssg or S-Mssg
        idx_arch    like sy-tabix.        "itab pointer

*---Changes with the note 997117--------------------------------------*
*---The archive dialog has been changed from the DTIN logic to the----*
*---new AS logic with a 'Datasource' button. Also the connection to---*
*---Infosystem has been implemented with the note---------------------*

  IF xuseas IS INITIAL.                                     "997117
*---Archive Files are selected----------------------------------------*

    CALL FUNCTION 'ARCH_GET_INFO'
      EXPORTING
        archive_obj       = archobj
      IMPORTING
        archive_count     = yarchset_cnt
      TABLES
        select_options    = arch_sel
        archives_info_set = yarchset.

    if sy-batch <> 'X'.
      mssg_typ = 'I'.
    else.
      mssg_typ = 'S'.
    endif.
*     filter archives by admi_fidoc
    loop at yarchset.
      idx_arch = sy-tabix.
      select * from admi_fidoc
               where archiv_key = yarchset-archiv_key.
        exit.
      endselect.
      if sy-subrc = 0. "=> ADMI_FIDOC is filled
        select * from admi_fidoc
                 where archiv_key =  yarchset-archiv_key
                 and   bukrs      in br_bukrs
                 and   gjahr      in br_gjahr.
          exit.
        endselect.
        if sy-subrc > 0."=> no selected data in archive
          message id 'F9' type mssg_typ number '403'
                          with  yarchset-archiv_key.
          read table arch_sel
                     with key low = yarchset-archiv_key.
          delete arch_sel index sy-tabix.
          delete yarchset index idx_arch.
        endif.
      endif.
    endloop.

    describe table arch_sel lines yarchset_cnt.
    if yarchset_cnt = 0.
      message id 'F9' type mssg_typ number '402'.
    else.
      CALL FUNCTION 'ARCHIVE_OPEN_FOR_READ'
        EXPORTING
          object         = sys_object
        IMPORTING
          archive_handle = archive_handle
        TABLES
          archive_files  = arch_sel   "brarkey
          selected_files = lt_files.

      LOOP AT lt_files INTO wa_files.
        ADD wa_files-obj_count TO lv_cnt_tot.
      ENDLOOP.

      DO.
        CALL FUNCTION 'ARCHIVE_GET_NEXT_OBJECT'
          EXPORTING
            archive_handle = archive_handle
          EXCEPTIONS
            end_of_file    = 1.
        IF sy-subrc = 1.
          EXIT.
        ELSE.
          PERFORM process_archive_files
                              USING lv_cnt_tot.
        ENDIF.
      ENDDO.

      CALL FUNCTION 'ARCHIVE_CLOSE_FILE'
        EXPORTING
          archive_handle = archive_handle
        EXCEPTIONS
          OTHERS         = 01.
    endif.
  ELSE.
*---Infosystem is used for the selection-----------------------"997117*

    REFRESH arch_sel.
*   find AS infostructure
    APPEND 'BUKRS' TO lt_obligatory_fields.
    APPEND 'BELNR' TO lt_obligatory_fields.
    APPEND 'GJAHR' TO lt_obligatory_fields.
    APPEND 'BUDAT' TO lt_obligatory_fields.
    APPEND 'BLART' TO lt_obligatory_fields.
    APPEND 'XBLNR' TO lt_obligatory_fields.
    APPEND 'AWTYP' TO lt_obligatory_fields.
    APPEND 'AWKEY' TO lt_obligatory_fields.
    APPEND 'AWSYS' TO lt_obligatory_fields.

    PERFORM selection_for_as_create
                               CHANGING lt_selections_as.

    SELECT archindex FROM aind_str1 INTO TABLE lt_fieldcat
                         WHERE itype     = 'S'
                           AND archindex LIKE 'SAP%'
                           AND object    = 'FI_DOCUMNT'.

    ld_no_infostr = 'X'.                                    "1164669
    LOOP AT lt_fieldcat INTO ld_fieldcat.
      CALL FUNCTION 'AS_API_READ'
        EXPORTING
          i_fieldcat                = ld_fieldcat
          i_selections              = lt_selections_as
          i_obligatory_fields       = lt_obligatory_fields[]
        IMPORTING
          e_result                  = lt_result
        EXCEPTIONS
          no_infostruc_found        = 2
          field_missing_in_fieldcat = 3.
      IF sy-subrc = 0.                                      "1096036
        clear ld_no_infostr.                                "1164669
        SORT lt_result BY bukrs belnr                       "1096036
                          gjahr archivekey DESCENDING.      "1096036
        DELETE ADJACENT DUPLICATES FROM lt_result           "1096036
                          COMPARING bukrs belnr gjahr.      "1096036
        SORT lt_result BY archivekey archiveofs.            "1096036
      ENDIF.                                                "1096036
    ENDLOOP.
    if not ld_no_infostr is initial.                        "1164669
      message I601(FR).                                     "1164669
    endif.                                                  "1164669
    DESCRIBE TABLE lt_result LINES lv_cnt_tot.
    IF LINES( lt_result ) = 0.
      EXIT.
    ENDIF.

    LOOP AT lt_result INTO lw_result.
      CALL FUNCTION 'ARCHIVE_GET_OBJECT_BY_OFFSET'
        EXPORTING
          archivkey      = lw_result-archivekey
          offset         = lw_result-archiveofs
        IMPORTING
          archive_handle = archive_handle.

      PERFORM process_archive_files
                           USING lv_cnt_tot.

      CALL FUNCTION 'ARCHIVE_CLOSE_FILE'
        EXPORTING
          archive_handle = archive_handle.
    ENDLOOP.
  ENDIF.

ENDFORM.                    "READ_ARCHIV_DATA

*---------------------------------------------------------------------*
*       FORM BELEG_CHECK                                              *
*---------------------------------------------------------------------*
*       Die Belegkopfdaten werden mit den Eingaben verprobt           *
*---------------------------------------------------------------------*
FORM beleg_check
     CHANGING flag.
*
  flag = 'X'.
  CHECK: br_bukrs, br_blart, br_budat,
         br_xblnr, br_belnr, br_gjahr,
         br_awtyp, br_awkey, br_awsys,
         br_bldat, br_usnam, br_cpudt.                      "989207
  CHECK bkpf-rldnr IN gr_rldnr.
  CHECK bkpf-ldgrp IN gr_ldgrp.
*...Begin of Note 989207.............................................*
  IF b0sg-xstan = 'X'.
    IF bkpf-bstat = ' '.
      flag = space.
    ENDIF.
  ENDIF.
  IF b0sg-xstad = 'X'.
    IF bkpf-bstat = 'D'.
      flag = space.
    ENDIF.
  ENDIF.
  IF b0sg-xstam = 'X'.
    IF bkpf-bstat =  'M'.
      flag = space.
    ENDIF.
  ENDIF.
  IF b0sg-xstas = 'X'.
    IF bkpf-bstat = 'S'.
      flag = space.
    ENDIF.
  ENDIF.
  IF b0sg-xstaa = 'X'.
    IF bkpf-bstat =  'A'.
      flag = space.
    ENDIF.
  ENDIF.
  IF b0sg-xstab = 'X'.
    IF bkpf-bstat = 'B'.
      flag = space.
    ENDIF.
  ENDIF.
  IF b0sg-xstav = 'X' OR b0sg-xstav = 'Z'.
    IF bkpf-bstat = 'W' OR bkpf-bstat = 'Z'.
      flag = space.
    ENDIF.
  ENDIF.
  IF bkpf-bstat = 'L'.
    flag = space.
  ENDIF.

*  if b0sg-xstav <> 'Z'.
*    check not ( bkpf-bstat in zw_bstat ).
*  endif.
*  flag = space.
*...End of Note 989207................................................*
ENDFORM.                    "BELEG_CHECK

*---------------------------------------------------------------------*
*       FORM BELEG_DYN_CHECK                                          *
*---------------------------------------------------------------------*
*       Die Belegkopfdaten werden mit dynamischen Eingaben verprobt   *
*---------------------------------------------------------------------*
FORM beleg_dyn_check
     CHANGING flag.

  DATA l_ds_frange  TYPE rsds_frange.
  DATA varname(20).
  DATA no_sel.

  IF flag <> space.
    EXIT.
  ENDIF.

  flag = 'X'.
  no_sel = space.

  CASE range_cnt.
    WHEN 0.
    WHEN 1.
      check_dyn_range 01.
    WHEN 2.
      check_dyn_range: 01, 02.
    WHEN 3.
      check_dyn_range: 01, 02, 03.
    WHEN 4.
      check_dyn_range: 01, 02, 03, 04.
    WHEN 5.
      check_dyn_range: 01, 02, 03, 04, 05.
    WHEN 6.
      check_dyn_range: 01, 02, 03, 04, 05, 06.
    WHEN 7.
      check_dyn_range: 01, 02, 03, 04, 05, 06, 07.
    WHEN 8.
      check_dyn_range: 01, 02, 03, 04, 05, 06, 07, 08.
    WHEN 9.
      check_dyn_range: 01, 02, 03, 04, 05, 06, 07, 08, 09.
    WHEN 10.
      check_dyn_range: 01, 02, 03, 04, 05, 06, 07, 08, 09, 10.
    WHEN OTHERS.
      check_dyn_range: 01, 02, 03, 04, 05, 06, 07, 08, 09, 10.

      varname = 'BKPF-'.
*    L_DS_RANGE-FRANGE_T wurde in INIT_DYN_RANGE modifiziert
      LOOP AT l_ds_range-frange_t INTO l_ds_frange.
        varname+5 = l_ds_frange-fieldname.
        copy l_ds_frange-selopt_t to my_range.
        ASSIGN TABLE FIELD (varname) TO <f>.
        IF NOT <f> IN my_range.
          no_sel = 'X'.
          EXIT.
        ENDIF.
      ENDLOOP.
  ENDCASE.

  flag = no_sel.

ENDFORM.                    "BELEG_DYN_CHECK

*---------------------------------------------------------------------*
*       FORM INIT_DYN_RANGE                                           *
*---------------------------------------------------------------------*
*       Initialisierung fuer dynamische Selektion                     *
*---------------------------------------------------------------------*
FORM init_dyn_range.

  DATA l_ds_frange  TYPE rsds_frange.
  DATA varname(20).
  DATA cnt TYPE i.
  DATA n_range TYPE i.

  varname = 'BKPF-'.
  l_ds_range-tablename = 'BKPF'.
  READ TABLE dyn_sel-trange WITH KEY l_ds_range-tablename
                            INTO l_ds_range.
  IF sy-subrc = 0.
    cnt = 1.
    LOOP AT l_ds_range-frange_t INTO l_ds_frange.
      varname+5 = l_ds_frange-fieldname.
      CASE cnt.
        WHEN 0.
        WHEN 1.
          asgn_dyn_range 01.
          DELETE l_ds_range-frange_t.
        WHEN 2.
          asgn_dyn_range 02.
          DELETE l_ds_range-frange_t.
        WHEN 3.
          asgn_dyn_range 03.
          DELETE l_ds_range-frange_t.
        WHEN 4.
          asgn_dyn_range 04.
          DELETE l_ds_range-frange_t.
        WHEN 5.
          asgn_dyn_range 05.
          DELETE l_ds_range-frange_t.
        WHEN 6.
          asgn_dyn_range 06.
          DELETE l_ds_range-frange_t.
        WHEN 7.
          asgn_dyn_range 07.
          DELETE l_ds_range-frange_t.
        WHEN 8.
          asgn_dyn_range 08.
          DELETE l_ds_range-frange_t.
        WHEN 9.
          asgn_dyn_range 09.
          DELETE l_ds_range-frange_t.
        WHEN 10.
          asgn_dyn_range 10.
          DELETE l_ds_range-frange_t.
        WHEN OTHERS.
          range_cnt = 1000.
          EXIT.
      ENDCASE.
    ENDLOOP.
  ENDIF.

*** New part for the check of the FAGLFREESEL in archive case  "1672938
  l_ds_range-tablename = 'FAGLFREESEL'.
  read table dyn_sel-trange with key l_ds_range-tablename
                            into l_ds_range.

  loop at l_ds_range-frange_t INTO l_ds_frange.
    call function 'FAGL_TRANSFORM_GLFLEX_TO_BSEG'
      exporting
        id_glflex_fieldname = l_ds_frange-fieldname
        id_tot_table        = 'FAGLFLEXT'
      importing
        ed_bseg_fieldname   = l_ds_frange-fieldname
      exceptions
        not_found           = 1
        OTHERS              = 2.
    modify l_ds_range-frange_t FROM l_ds_frange.
  endloop.

ENDFORM.                    "INIT_DYN_RANGE

*------- Rahmentexte ------------------------------------------------*
FORM get_frame_title USING nr text.
  CASE nr.
    WHEN  0. text = text-000.
    WHEN  1. text = text-101.
    WHEN  2. text = text-102.
    WHEN  3. text = text-103.
    WHEN  4. text = text-104.
    WHEN  5. text = text-105.
    WHEN  6. text = text-106.
    WHEN  7. text = text-107.
    WHEN  8. text = text-108.
    WHEN 99. text = text-100.
    WHEN OTHERS. text = space.
  ENDCASE.
ENDFORM.                    "GET_FRAME_TITLE

*------- Statistik --------------------------------------------------*
FORM statistik.
  DATA:ldummy.
  CHECK statistk = 'X'.
  IF g_balv = 'X'.
    MESSAGE s600 WITH text-800 INTO ldummy.
    CALL FUNCTION 'LDB_LOG_WRITE'.
    MESSAGE s600 WITH text-801 cnt_bkpf INTO ldummy.
    CALL FUNCTION 'LDB_LOG_WRITE'.
    MESSAGE s600 WITH text-802 cnt_bseg INTO ldummy.
    CALL FUNCTION 'LDB_LOG_WRITE'.
    MESSAGE s600 WITH text-803 cnt_bsegsel INTO ldummy.
    CALL FUNCTION 'LDB_LOG_WRITE'.
    MESSAGE s600 WITH text-804 time1 INTO ldummy.
    CALL FUNCTION 'LDB_LOG_WRITE'.
    MESSAGE s600 WITH text-805 time2 INTO ldummy.
    CALL FUNCTION 'LDB_LOG_WRITE'.
    MESSAGE s600 WITH text-806 k INTO ldummy.
    CALL FUNCTION 'LDB_LOG_WRITE'.


  ELSE.
    SKIP 1.
    WRITE: /(25) text-800.
    WRITE: /(25) text-801, cnt_bkpf.
    WRITE: /(25) text-802, cnt_bseg.
    WRITE: /(25) text-803, cnt_bsegsel.
    WRITE: /(25) text-804, time1.
    WRITE: /(25) text-805, time2.
    WRITE: /(25) text-806, k.
  ENDIF.
ENDFORM.                    "STATISTIK

*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Die folgenden FORM-Routinen werden extern bei der Pflege von         *
* Varianten mit Variablen bezüglich Geschäftsjahr oder Periode         *
* aufgerufen                                                           *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       FORM HELP_F4_PERIV                                             *
*----------------------------------------------------------------------*
*       F4-Hilfe für Geschäftsjahresvariante                           *
*----------------------------------------------------------------------*
*  <--  PERIV     Geschaeftsjahresvariante                             *
*----------------------------------------------------------------------*
FORM help_f4_periv USING periv.

  TABLES: t009, t009t.
  DATA: BEGIN OF fldtab OCCURS 2.
          INCLUDE STRUCTURE help_value.
  DATA: END OF fldtab.

  DATA: BEGIN OF valtab OCCURS 10,
          ltext LIKE t009t-ltext,
        END OF valtab.

*------- FLDTAB füllen -------------------------------------------------
  REFRESH fldtab.
  CLEAR fldtab.
  fldtab-tabname    = 'T009'.
  fldtab-fieldname  = 'PERIV'.
  fldtab-selectflag = 'X'.
  APPEND fldtab.
  CLEAR fldtab.
  fldtab-tabname    = 'T009T'.
  fldtab-fieldname  = 'LTEXT'.
  APPEND fldtab.
*------- VALTAB füllen -------------------------------------------------
  SELECT * FROM t009.
    valtab-ltext = t009-periv.
    APPEND valtab.
    SELECT SINGLE * FROM t009t WHERE spras = sy-langu
                                 AND periv = t009-periv.
    valtab-ltext = t009t-ltext.
    APPEND valtab.
  ENDSELECT.

  CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
    EXPORTING
      fieldname    = 'CURTP'
      tabname      = 'T001A'
    IMPORTING
      select_value = periv
    TABLES
      fields       = fldtab
      valuetab     = valtab.
ENDFORM.                    "HELP_F4_PERIV

*----------------------------------------------------------------------*
*       FORM DETERMINE_DATE                                            *
*----------------------------------------------------------------------*
*       Bestimme ersten oder letzten Tag des Geschäftsjahres           *
*----------------------------------------------------------------------*
*  -->  PERIV     Geschaeftsjahresvariante                             *
*  -->  MSG       Nachricht ( 'FIRST' oder 'LAST' )                    *
*  <--  DATE      Datum                                                *
*----------------------------------------------------------------------*
FORM determine_date USING periv LIKE t001-periv
                          msg
                          date  LIKE sy-datum.
  PERFORM check_bukrs USING periv.
  CASE msg.
    WHEN 'FIRST'.
      CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
        EXPORTING
          i_gjahr = sy-datum(4)
          i_periv = periv
          i_poper = 01
        IMPORTING
          e_date  = date.
    WHEN 'LAST'.
      CALL FUNCTION 'LAST_DAY_IN_YEAR_GET'
        EXPORTING
          i_date  = sy-datum
          i_periv = periv
        IMPORTING
          e_date  = date.
  ENDCASE.
ENDFORM.                    "DETERMINE_DATE

*----------------------------------------------------------------------*
*       FORM DETERMINE_PERIOD                                          *
*----------------------------------------------------------------------*
*       Bestimme aktuelle Period ggf. mit Offset                       *
*----------------------------------------------------------------------*
*  -->  PERIV     Geschaeftsjahresvariante                             *
*  -->  MSG       Nachricht ( ADD0, ADD1, SUB1, SUB2 )                 *
*  <--  PERIOD    Periode                                              *
*  <--  YEAR      Geschaeftsjahr                                       *
*----------------------------------------------------------------------*
FORM determine_period USING periv  LIKE t001-periv
                            msg
                            period LIKE t009b-poper
                            year   LIKE t009b-bdatj.
  DATA date LIKE sy-datum.
  DATA ms(4).
  IF msg = space.
    msg = 'ADD0'.
  ENDIF.
  ms = msg.
* Aktuelle Periode in PERIOD
  CALL FUNCTION 'FI_PERIOD_DETERMINE'
    EXPORTING
      i_budat = sy-datum
      i_periv = periv
    IMPORTING
      e_gjahr = year
      e_poper = period.
  IF msg = 'ADD0'.
    EXIT.
  ELSEIF msg = 'ADD1'.
*   Letzter Tag in aktueller Periode
    CALL FUNCTION 'LAST_DAY_IN_PERIOD_GET'
      EXPORTING
        i_gjahr = year
        i_periv = periv
        i_poper = period
      IMPORTING
        e_date  = date.
*   Folgetag
    date = date + 1.
*   Bestimme Periode
    CALL FUNCTION 'FI_PERIOD_DETERMINE'
      EXPORTING
        i_budat = date
        i_periv = periv
      IMPORTING
        e_gjahr = year
        e_poper = period.
    EXIT.
  ELSEIF ms(3) = 'SUB'.
*   Erster Tag in aktueller Periode
    CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
      EXPORTING
        i_gjahr = year
        i_periv = periv
        i_poper = period
      IMPORTING
        e_date  = date.
*   vorheriger Tag
    date = date - 1.
*   Bestimme Periode
    CALL FUNCTION 'FI_PERIOD_DETERMINE'
      EXPORTING
        i_budat = date
        i_periv = periv
      IMPORTING
        e_gjahr = year
        e_poper = period.
    ms = ms+3(1).
    IF ms = '1'.
      EXIT.
    ENDIF.
*   Erster Tag in Vorperiode
    CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
      EXPORTING
        i_gjahr = year
        i_periv = periv
        i_poper = period
      IMPORTING
        e_date  = date.
*   vorheriger Tag
    date = date - 1.
*   Bestimme Periode
    CALL FUNCTION 'FI_PERIOD_DETERMINE'
      EXPORTING
        i_budat = date
        i_periv = periv
      IMPORTING
        e_gjahr = year
        e_poper = period.
  ENDIF.
ENDFORM.                    "DETERMINE_PERIOD

*---------------------------------------------------------------------*
*       FORM CHECK_BUKRS                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PERIV                                                         *
*---------------------------------------------------------------------*
FORM check_bukrs USING periv LIKE t001-periv.
  SELECT * FROM t001 WHERE bukrs IN br_bukrs.
    IF t001-periv <> periv.
      MESSAGE e823 WITH periv t001-bukrs.
    ENDIF.
  ENDSELECT.
ENDFORM.                    "CHECK_BUKRS

*---------------------------------------------------------------------*
*       FORM EXCLUD_DYN_SEL_NOT_IN_TABLE                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  TAB_SEL                                                       *
*  -->  TAB_CHECK                                                     *
*---------------------------------------------------------------------*
FORM exclud_dyn_sel_not_in_table USING tab_sel tab_check.
  DATA l_ds_frange  TYPE rsds_frange.
  DATA fieldnam(20).

  l_ds_range-tablename = tab_sel.
  READ TABLE dyn_sel-trange WITH KEY l_ds_range-tablename
                      INTO l_ds_range.
  IF sy-subrc = 0.
    LOOP AT l_ds_range-frange_t INTO l_ds_frange.
      fieldnam = l_ds_frange-fieldname.
      DESCRIBE TABLE l_ds_frange-selopt_t  LINES sy-tfill.
      IF sy-tfill > 0.
        SELECT  SINGLE  * FROM  dd03l
             WHERE  tabname     = tab_check
             AND    fieldname   = fieldnam
             AND    as4local    = 'A'
             AND    as4vers     = '0000'          .
        IF sy-subrc NE 0.
          MESSAGE i856 WITH fieldnam.
          STOP.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDIF.
ENDFORM.                    "EXCLUD_DYN_SEL_NOT_IN_TABLE

*---------------------------------------------------------------------*
*       FORM CONVERT_ALT                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  TABNAME                                                       *
*  -->  BL_WAERS                                                      *
*---------------------------------------------------------------------*
FORM convert_alt USING tabname bl_waers.                          "euro
  CASE tabname.
    WHEN 'BSEG'.
      READ TABLE int_teurb WITH KEY bukrs = bseg-bukrs cprog = sy-cprog
                BINARY SEARCH.
      IF int_teurb-waers NE sp_waers.
        IF int_teurb-waers EQ bl_waers.
          bseg-dmbtr = bseg-wrbtr.
          bseg-mwsts = bseg-wmwst.
          bseg-hwbas = bseg-fwbas.
          bsega-dmsol = bsega-wrsol.
          bsega-dmhab = bsega-wrhab.
          bsega-dmshb = bsega-wrshb.
        ELSE.
          PERFORM conv_to_alt_curr USING    bseg-bukrs excdt sp_waers
                             CHANGING bseg-dmbtr.
          PERFORM conv_to_alt_curr USING    bseg-bukrs excdt sp_waers
                             CHANGING bseg-mwsts.
          PERFORM conv_to_alt_curr USING    bseg-bukrs excdt sp_waers
                             CHANGING bseg-hwbas.
          PERFORM conv_to_alt_curr USING    bseg-bukrs excdt sp_waers
                             CHANGING bsega-dmsol.
          PERFORM conv_to_alt_curr USING    bseg-bukrs excdt sp_waers
                             CHANGING bsega-dmhab.
          PERFORM conv_to_alt_curr USING    bseg-bukrs excdt sp_waers
                             CHANGING bsega-dmshb.
        ENDIF.
      ENDIF.
    WHEN 'BSET'.
      READ TABLE int_teurb WITH KEY bukrs = bset-bukrs cprog = sy-cprog
                BINARY SEARCH.
      IF int_teurb-waers NE sp_waers.
        IF int_teurb-waers EQ bl_waers.
          bset-hwste = bset-fwste.
          bset-hwbas = bset-fwbas.
        ELSE.
          PERFORM conv_to_alt_curr USING    bset-bukrs excdt sp_waers
                             CHANGING bset-hwste.
          PERFORM conv_to_alt_curr USING    bset-bukrs excdt sp_waers
                             CHANGING bset-hwbas.
        ENDIF.
      ENDIF.
      IF xwia EQ 'X' AND NOT g_waers IS INITIAL.
        IF int_teurb-waers NE g_waers. "LW wurde umgesetzt
          IF int_teurb-waers EQ bl_waers.
            bset-lwste = bset-fwste.
            bset-lwbas = bset-fwbas.
          ELSE.
            PERFORM conv_to_alt_curr_wia USING bset-bukrs excdt
                             CHANGING bset-lwste.
            PERFORM conv_to_alt_curr_wia USING bset-bukrs excdt
                             CHANGING bset-lwbas.
          ENDIF.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDFORM.                    "CONVERT_ALT

*---------------------------------------------------------------------*
*       FORM WIA_TAX_DECL_COUNTRY                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  ZLAND                                                         *
*---------------------------------------------------------------------*
FORM wia_tax_decl_country USING zland.
  g_land = zland.
  SELECT SINGLE * FROM t005 WHERE land1 = g_land.
  IF sy-subrc NE 0.
    IF sy-batch <> space.
      MESSAGE s223(f7) WITH g_land.
      MESSAGE s207(f7) WITH sy-repid.
      STOP.
    ELSE.
      MESSAGE a223(f7) WITH g_land.
    ENDIF.
  ELSE.
    g_waers =  t005-waers.
  ENDIF.
ENDFORM.                    "WIA_TAX_DECL_COUNTRY

*include dtinpsub.                                             "997117
*---------------------------------------------------------------------*
*       FORM AUTH_CHECK_BKPF_BEX                                      *
*---------------------------------------------------------------------*
*       Check authorizations F_BKPF_BED/K/S using buffer              *
*---------------------------------------------------------------------*
FORM auth_check_bkpf_bex CHANGING pd_rcode.
  DATA: ld_acct_id     LIKE rfpos-konto,
        ld_subrc       LIKE sy-subrc.
  CLEAR pd_rcode.
  CASE bseg-koart.
    WHEN 'D'.
      ld_acct_id = bseg-kunnr.
    WHEN 'K'.
      ld_acct_id = bseg-lifnr.
    WHEN 'S' OR 'A' OR 'M'.
      ld_acct_id = bseg-hkont.
    WHEN OTHERS.
      EXIT.
  ENDCASE.
  IF bseg-koart EQ 'D' OR
     bseg-koart EQ 'K'.
    READ TABLE gt_auth_bkpf_bex
         WITH TABLE KEY acct_type = bseg-koart
                        acct_id   = ld_acct_id
                        comp_code = space
         INTO gs_auth_bkpf_bex.
    IF sy-subrc = 0.
      pd_rcode = gs_auth_bkpf_bex-rcode.
    ELSE.
      PERFORM auth_bkpf_bex_new_entry USING bseg-koart
                                            ld_acct_id
                                            space
                                   CHANGING ld_subrc.
      gs_auth_bkpf_bex-acct_type = bseg-koart.
      gs_auth_bkpf_bex-acct_id   = ld_acct_id.
      gs_auth_bkpf_bex-comp_code = space.
      gs_auth_bkpf_bex-rcode     = ld_subrc.
      INSERT gs_auth_bkpf_bex INTO TABLE gt_auth_bkpf_bex.
      pd_rcode = ld_subrc.
    ENDIF.
  ENDIF.
  CHECK pd_rcode = 0.
  READ TABLE gt_auth_bkpf_bex
       WITH TABLE KEY acct_type = bseg-koart
                      acct_id   = ld_acct_id
                      comp_code = bseg-bukrs
       INTO gs_auth_bkpf_bex.
  IF sy-subrc = 0.
    pd_rcode = gs_auth_bkpf_bex-rcode.
  ELSE.
    PERFORM auth_bkpf_bex_new_entry USING bseg-koart
                                          ld_acct_id
                                          bseg-bukrs
                                 CHANGING ld_subrc.
    gs_auth_bkpf_bex-acct_type = bseg-koart.
    gs_auth_bkpf_bex-acct_id   = ld_acct_id.
    gs_auth_bkpf_bex-comp_code = bseg-bukrs.
    gs_auth_bkpf_bex-rcode     = ld_subrc.
    INSERT gs_auth_bkpf_bex INTO TABLE gt_auth_bkpf_bex.
    pd_rcode = ld_subrc.
  ENDIF.

ENDFORM.              " AUTH_CHECK_BKPF_BEX


*---------------------------------------------------------------------*
*       FORM AUTH_BKPF_BEX_NEW_ENTRY                                  *
*---------------------------------------------------------------------*
*       New buffer entry for authorization F_BKPF_BED/K/S             *
*---------------------------------------------------------------------*
FORM auth_bkpf_bex_new_entry USING pd_acct_type LIKE rfpos-koart
                                   pd_acct_id   LIKE rfpos-konto
                                   pd_comp_code LIKE rfpos-bukrs
                          CHANGING pd_subrc     LIKE sy-subrc.
  DATA: ld_begru        LIKE kna1-begru,
        ld_auth_object  LIKE tobj-objct.

  CASE pd_acct_type.
    WHEN 'D'.
      ld_auth_object = 'F_BKPF_BED'.
      IF pd_comp_code IS INITIAL.
        SELECT SINGLE begru FROM kna1 INTO ld_begru
                            WHERE kunnr = pd_acct_id.
      ELSE.
        SELECT SINGLE begru FROM knb1 INTO ld_begru
                            WHERE kunnr = pd_acct_id
                              AND bukrs = pd_comp_code.
      ENDIF.
    WHEN 'K'.
      ld_auth_object = 'F_BKPF_BEK'.
      IF pd_comp_code IS INITIAL.
        SELECT SINGLE begru FROM lfa1 INTO ld_begru
                            WHERE lifnr = pd_acct_id.
      ELSE.
        SELECT SINGLE begru FROM lfb1 INTO ld_begru
                            WHERE lifnr = pd_acct_id
                              AND bukrs = pd_comp_code.
      ENDIF.
    WHEN 'S' OR 'M' OR 'A'.
      ld_auth_object = 'F_BKPF_BES'.
      SELECT SINGLE begru FROM skb1 INTO ld_begru
                          WHERE bukrs = pd_comp_code
                            AND saknr = pd_acct_id.
  ENDCASE.
  pd_subrc = 4.
  if sy-subrc = 0.                                             "1701784
  pd_subrc = 0.
  CHECK NOT ld_begru IS INITIAL.
  AUTHORITY-CHECK OBJECT ld_auth_object
           ID 'BRGRU' FIELD ld_begru
           ID 'ACTVT' FIELD '03'.
  pd_subrc = sy-subrc.
  else.                                                        "1701784
*  master data seams to be archived                            "1701784
    pd_subrc = 0.                                              "1701784
  endif.                                                       "1701784

ENDFORM.              " AUTH_BKPF_BEX_NEW_ENTRY
*&---------------------------------------------------------------------*
*&      Form  check_date
*&---------------------------------------------------------------------*
*       check gjahr and bukrs to avoid check on item level
*       if flag gd_tpc_check_sel = 'X': no further check necessary
*----------------------------------------------------------------------*
FORM check_date .

  DATA: it001 TYPE t001 OCCURS 0 WITH HEADER LINE.

* bukrs specified?
  READ TABLE br_bukrs INDEX 1.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  SELECT * FROM t001 INTO TABLE it001
                     WHERE bukrs IN br_bukrs.

*   check gjahr and bukrs to avoid check on item level
  LOOP AT it001.
    LOOP AT br_gjahr.
      IF br_gjahr-sign = 'I' AND
        ( br_gjahr-option = 'BT' OR br_gjahr-option = 'EQ' ).
        gd_tpc_check_sel = 'X'.
        CALL FUNCTION 'FI_CHECK_DATE'
          EXPORTING
            i_bukrs           = it001-bukrs
            i_user            = sy-uname
            i_program         = 'SAPDBBRF'
            i_from_year       = br_gjahr-low
            i_to_year         = br_gjahr-high
          EXCEPTIONS
            no_authority_prog = 1
            no_authority_date = 2
            wrong_parameter   = 3
            OTHERS            = 4.
        IF sy-subrc <> 0.
          gd_tpc_check_sel = space.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

ENDFORM.                    " check_date
*----------------------------------------------------------------------*
* FORM BEFORE_EVENT                                                    *
* Will be called before event 'event'                                  *
*----------------------------------------------------------------------*
FORM before_event USING event.
  TYPE-POOLS: slis.

  CASE event.
    WHEN 'START-OF-SELECTION'.
      IF gd_tpc_log NE space.
        CALL FUNCTION 'CA_WRITE_LOG'                        "#EC EXISTS
          EXPORTING
            i_program   = sy-cprog
          EXCEPTIONS
            write_error = 1
            OTHERS      = 2.
        IF sy-subrc <> 0.
          MESSAGE e006(ca_check_date).
        ENDIF.
      ENDIF.
*   initial
      CALL FUNCTION 'LDB_LOG_INIT'.

  ENDCASE.
ENDFORM.                    "before_event
**********************************************************************
* !!! PLEASE DO NOT CHANGE MANUALLY (BEGIN OF BLOCK) !!!!!!!!!!!!!!! *
*----------------------------------------------------------------------*
* Data structures for search pattern selection                         *
* !!! PLEASE DO NOT CHANGE MANUALLY (END OF BLOCK) !!!!!!!!!!!!!!!!! *
**********************************************************************
*

*&--------------------------------------------------------------------*
*&      Form  after_event
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->EVENT      text
*---------------------------------------------------------------------*
FORM after_event USING event.
  CASE event.
    WHEN 'END-OF-SELECTION'.
      CALL FUNCTION 'LDB_LOG_DISPLAY'.
  ENDCASE.

ENDFORM.                    "BEFORE_EVENT

*&--------------------------------------------------------------------*
*&      Form  move_arch_to_tab
*&--------------------------------------------------------------------*
*       link data from arch to Y-tables
*---------------------------------------------------------------------*
*      -->EVENT      text
*---------------------------------------------------------------------*
FORM move_arch_to_tab
         USING
           iv_tabname   TYPE tabname
           it_data_obj  TYPE astablebuffer
          CHANGING
            et_records  TYPE STANDARD TABLE.

  FIELD-SYMBOLS: <lt_records>  TYPE data.

  CLEAR et_records.

  ASSIGN it_data_obj-tabref->* TO <lt_records>.
  IF sy-subrc = 0.
    et_records = <lt_records>.
  ENDIF.

ENDFORM.                    "move_archdata_to_tables
*&---------------------------------------------------------------------*
*&      Form  fisc_year_variant_check
*&---------------------------------------------------------------------*
FORM fisc_year_variant_check  TABLES pr_budat
                              USING  p_rldnr.
* local data declaration
  DATA: l_leading_ledger   TYPE rldnr.
  DATA: l_xbudat           TYPE boole.
  DATA: l_report           LIKE sy-repid.

  DATA: ls_t001            LIKE t001.
  DATA: ls_orginfo         LIKE glx_org_info.
* tables for dynamic selections
  DATA: lt_dynsel           TYPE rsds_trange.
  DATA: ls_trange_tab_line  TYPE rsds_range.
  DATA: ls_frange_tab_line  TYPE rsds_frange.
* tables for where clauses
  DATA: ls_dyns             TYPE rsds_type.
  DATA: ls_clauses_tab_line TYPE rsds_where.
  DATA: ls_texpr_tab_line   TYPE rsds_expr.

  DATA: ls_selopt           TYPE rsdsselopt.
  DATA: ls_selopt_t         TYPE rsds_selopt_t.

  DATA: lt_periv   LIKE t001-periv OCCURS 0 WITH HEADER LINE.


  RANGES: lr_period FOR  t009b-poper.
  RANGES: lr_budat  FOR  bkpf-budat.

* get leading ledger
  CALL FUNCTION 'FAGL_GET_LEADING_LEDGER'
    IMPORTING
      e_rldnr   = l_leading_ledger
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
    MESSAGE ID   sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF l_leading_ledger = p_rldnr.
*.. leading ledger >>> nothing to do
    EXIT.          " >>>>>>>>>> E X I T >>>>>>>>>>>>>
  ENDIF.

* check fiscal year variant
  SELECT bukrs periv FROM t001 INTO CORRESPONDING FIELDS OF ls_t001
                    WHERE bukrs IN br_bukrs.
*.. get periv of p_rldnr
    CALL FUNCTION 'G_GET_ORGANIZATIONAL_DATA'
      EXPORTING
        i_rldnr             = p_rldnr
        i_orgunit           = ls_t001-bukrs
      IMPORTING
        organizational_info = ls_orginfo
      EXCEPTIONS
        no_info_found       = 1
        error_in_setup      = 2
        error_in_depld      = 3
        OTHERS              = 4.
    IF sy-subrc = 0
   AND NOT ( ls_orginfo-periv IS INITIAL ).

      IF ls_t001-periv <> ls_orginfo-periv.
*...... set flag for selection with posting date
        l_xbudat = 'X'.
      ENDIF.
*.... collect fisc. year variants
      lt_periv = ls_orginfo-periv.
      COLLECT lt_periv.
    ENDIF.

  ENDSELECT.

  IF l_xbudat IS INITIAL.
*.. selection with fy and period is ok
    EXIT.    " >>>>>>>>>  E X I T  >>>>>>>>>>
  ENDIF.

* Moved this IF Block here, as the pr_budat(outside gr_budat)  "1797718
* will later delete the Year and Period restriction            "1797718
* But this of course only needs to be done, if the related     "1797718
* FJV is different in the ledger compared to the leading ledger"1797718
  if not ( br_budat[] is initial ).
*.. posting date is specified >>> nothing to do
*.. year has to be refreshed, as the combination of year
*.. and posting date can lead to issue with the non leading
*.. ledger -> Therefore gr_budat is set, so it will get refreshed
    pr_budat[] = br_budat[].                                   "1405931
    exit.   " >>>>>>>>>>>  E X I T  >>>>>>>>>>>>>>>
  endif.

  DESCRIBE TABLE lt_periv LINES sy-tfill.
  IF sy-tfill <> 1.
    MESSAGE e199.
  ENDIF.

* check fiscal year
  DESCRIBE TABLE br_gjahr LINES sy-tfill.
  IF sy-tfill GT 1.
    LOOP AT br_gjahr.
      IF sy-tabix > 1.
        DELETE br_gjahr.
      ENDIF.
    ENDLOOP.
    READ TABLE br_gjahr INDEX 1.
    br_gjahr-high = space.
    br_gjahr-option = 'EQ'.
    br_gjahr-sign = 'I'.
    MODIFY br_gjahr INDEX 1.
    MESSAGE w515 WITH br_gjahr-low.                         "994258
  ELSE.
    READ TABLE br_gjahr INDEX 1.
    IF sy-subrc EQ 0.
      IF br_gjahr-option NE 'EQ'
      OR br_gjahr-sign   NE 'I'.
        br_gjahr-high = space.
        br_gjahr-option = 'EQ'.
        br_gjahr-sign = 'I'.
        MODIFY br_gjahr INDEX 1.
        MESSAGE w515 WITH br_gjahr-low.                     "994258
      ENDIF.
    ELSE.
*.... get first ccode
      SELECT bukrs periv FROM t001 INTO CORRESPONDING FIELDS OF ls_t001
                  WHERE bukrs IN br_bukrs
                    AND periv NE space.
        EXIT.    " >>>>>>>>>>>>>>>>>>  E X I T  >>>>>>>>>>>>>>>>>>>>
      ENDSELECT.
      IF sy-subrc = 0.
        CALL FUNCTION 'GET_CURRENT_YEAR'
          EXPORTING
            bukrs = ls_t001-bukrs
            date  = sy-datum
          IMPORTING
            curry = br_gjahr-low.

        br_gjahr-high = space.
        br_gjahr-option = 'EQ'.
        br_gjahr-sign = 'I'.
        APPEND br_gjahr.
        MESSAGE w515 WITH br_gjahr-low.                     "994258
      ENDIF.
    ENDIF.
  ENDIF.

* get dynamic selections
  l_report = sy-repid.
  CALL FUNCTION 'RS_REFRESH_FROM_DYNAMICAL_SEL'
    EXPORTING
      curr_report        = l_report
      mode_write_or_move = 'M'
    IMPORTING
      p_trange           = lt_dynsel
    EXCEPTIONS
      not_found          = 1
      wrong_type         = 2
      OTHERS             = 3.

  LOOP AT lt_dynsel INTO ls_trange_tab_line
                   WHERE tablename = 'BKPF'.
    LOOP AT ls_trange_tab_line-frange_t INTO ls_frange_tab_line
                     WHERE fieldname = 'MONAT'.
      ls_selopt_t[] = ls_frange_tab_line-selopt_t[].
      DESCRIBE TABLE ls_selopt_t LINES sy-tfill.
      IF sy-tfill = 1.
        LOOP AT ls_selopt_t INTO ls_selopt.
          IF ( ls_selopt-sign = 'I' AND  ls_selopt-option = 'EQ' )
          OR ( ls_selopt-sign = 'I' AND  ls_selopt-option = 'BT' ).
*.......... save the posting periods
            MOVE-CORRESPONDING ls_selopt TO lr_period.
            APPEND lr_period.
*.......... delete period from dynamic selections
            DELETE ls_trange_tab_line-frange_t.
            MODIFY lt_dynsel FROM ls_trange_tab_line.

*.......... rebuild WHERE-CLAUSES for LDB
            ls_dyns-trange = lt_dynsel.
            CALL FUNCTION 'FREE_SELECTIONS_RANGE_2_EX'
              EXPORTING
                field_ranges = ls_dyns-trange
              IMPORTING
                expressions  = ls_dyns-texpr.

            CALL FUNCTION 'FREE_SELECTIONS_RANGE_2_WHERE'
              EXPORTING
                field_ranges  = ls_dyns-trange
              IMPORTING
                where_clauses = ls_dyns-clauses.

            dyn_sel-clauses[] = ls_dyns-clauses[].
          ELSE.
            MESSAGE e140.
          ENDIF.
        ENDLOOP.
      ELSE.
        MESSAGE e140.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

* build selection for posting date
  READ TABLE lt_periv  INDEX 1.
  READ TABLE lr_period INDEX 1.
  if lr_period-option = 'EQ' and lr_period-high is initial. "1362621
    lr_period-high = lr_period-low.                         "1362621
    lr_period-option = 'BT'.                                "1362621
  endif.                                                    "1362621
  READ TABLE br_gjahr  INDEX 1.

  IF NOT ( lr_period-low IS INITIAL ).
*.. get posting date of from-period
    CALL FUNCTION 'G_POSTING_DATE_OF_PERIOD_GET'
      EXPORTING
        period              = lr_period-low
        variant             = lt_periv
        year                = br_gjahr-low
      IMPORTING
        from_date           = lr_budat-low
      EXCEPTIONS
        period_not_defined  = 1
        variant_not_defined = 2
        OTHERS              = 3.

    IF NOT ( lr_period-high IS INITIAL ).
*.... get posting date of to-period
      CALL FUNCTION 'G_POSTING_DATE_OF_PERIOD_GET'
        EXPORTING
          period              = lr_period-high
          variant             = lt_periv
          year                = br_gjahr-low
        IMPORTING
          to_date             = lr_budat-high
        EXCEPTIONS
          period_not_defined  = 1
          variant_not_defined = 2
          OTHERS              = 3.
    ENDIF.

    lr_budat-sign   = lr_period-sign.
    lr_budat-option = lr_period-option.
    APPEND lr_budat.

  ELSE.
*.. get first and last posting date of year
    CALL FUNCTION 'G_POSTING_DATE_OF_YEAR_GET'
      EXPORTING
        variant             = lt_periv
        year                = br_gjahr-low
      IMPORTING
        from_date           = lr_budat-low
        to_date             = lr_budat-high
      EXCEPTIONS
        variant_not_defined = 1
        year_not_defined    = 2
        OTHERS              = 3.

    lr_budat-sign   = 'I'.
    lr_budat-option = 'BT'.
    APPEND lr_budat.
  ENDIF.

  pr_budat[] = lr_budat[].
ENDFORM.                    " fisc_year_variant_check

*&--------------------------------------------------------------------*
*&      Form  Selection_for_as_create                          "997117
*&--------------------------------------------------------------------*
FORM selection_for_as_create CHANGING
                               pt_selections_as TYPE rsds_frange_t.
  DATA:  ld_selopt    LIKE rsdsselopt,
         lt_selopt    TYPE rsds_selopt_t,
         ld_frange    TYPE rsds_frange,
         lt_frange    TYPE rsds_frange_t,
         ld_trange    TYPE rsds_range,
         lt_trange    TYPE rsds_trange.

  REFRESH: lt_frange.
  ld_trange-tablename = 'BKPF'.

  IF NOT br_bukrs[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'BUKRS'.
    LOOP AT br_bukrs.
      MOVE-CORRESPONDING br_bukrs TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_belnr[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'BELNR'.
    LOOP AT br_belnr.
      move-corresponding br_belnr to ld_selopt.             "1164669
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_gjahr[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'GJAHR'.
    LOOP AT br_gjahr.
      MOVE-CORRESPONDING br_gjahr TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_budat[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'BUDAT'.
    LOOP AT br_budat.
      MOVE-CORRESPONDING br_budat TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_blart[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'BLART'.
    LOOP AT br_blart.
      MOVE-CORRESPONDING br_blart TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_xblnr[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'XBLNR'.
    LOOP AT br_xblnr.
      MOVE-CORRESPONDING br_xblnr TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_awtyp[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'AWTYP'.
    LOOP AT br_awtyp.
      MOVE-CORRESPONDING br_awtyp TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_awkey[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'AWKEY'.
    LOOP AT br_awkey.
      MOVE-CORRESPONDING br_awkey TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.
  IF NOT br_awsys[] IS INITIAL.
    REFRESH:lt_selopt.
    ld_frange-fieldname = 'AWSYS'.
    LOOP AT br_awsys.
      MOVE-CORRESPONDING br_awsys TO ld_selopt.
      APPEND ld_selopt TO lt_selopt.
    ENDLOOP.
    ld_frange-selopt_t = lt_selopt[].
    APPEND ld_frange TO lt_frange.
  ENDIF.

  IF NOT lt_frange[] IS INITIAL.
    ld_trange-frange_t = lt_frange[].
    APPEND ld_trange TO lt_trange.
  ENDIF.

  LOOP AT lt_trange INTO ld_trange.
    APPEND LINES OF ld_trange-frange_t TO pt_selections_as.
  ENDLOOP.


ENDFORM.                    " selection_for_as_create          "997117

*&--------------------------------------------------------------------*
*&      Form  arch_tables_to_select                            "997117
*&--------------------------------------------------------------------*
FORM arch_tables_for_selection CHANGING
                                 ps_fagl_names TYPE fagl_tabnames
                                 pt_arch_data  TYPE as_t_tablebuffer.

  DATA: wa_arch_data  TYPE astablebuffer.

  wa_arch_data-tabname = 'BKPF'.
  APPEND wa_arch_data TO pt_arch_data.
  wa_arch_data-tabname = 'BSEC'.
  APPEND wa_arch_data TO pt_arch_data.
  wa_arch_data-tabname = 'BSED'.
  APPEND wa_arch_data TO pt_arch_data.
  wa_arch_data-tabname = 'BSET'.
  APPEND wa_arch_data TO pt_arch_data.
  wa_arch_data-tabname = 'BSEG'.
  APPEND wa_arch_data TO pt_arch_data.
  IF NOT g_glflex_active IS INITIAL.
    IF b0sg-xdocc = 'X'.
      CALL FUNCTION 'FAGL_GET_TABLENAMES'
        EXPORTING
          i_ledger    = g_rldnr
        IMPORTING
          es_tabnames = ps_fagl_names.
      wa_arch_data-tabname = ps_fagl_names-si_table.
      APPEND wa_arch_data TO pt_arch_data.
    ELSE.
      wa_arch_data-tabname = 'BSEG_ADD'.
      APPEND wa_arch_data TO pt_arch_data.
    ENDIF.
  ENDIF.

ENDFORM.                    " arch_tables_to_select            "997117

*&--------------------------------------------------------------------*
*&      Form  process_archive_files                            "997117
*&--------------------------------------------------------------------*
FORM process_archive_files USING pv_cnt_tot.

  TYPES: BEGIN OF gs_ledger,
           rldnr TYPE fagl_rldnr,
         END OF gs_ledger.

  DATA: wa_arch_data  TYPE astablebuffer,
        lt_arch_data  TYPE as_t_tablebuffer,
        lv_cnt_read   TYPE sy-tabix,
        lv_cnt_read2  TYPE sy-tabix,
        l_prog_show   TYPE sy-tabix VALUE '100',
        ls_fagl_names TYPE fagl_tabnames,
        ls_ledger     TYPE gs_ledger,
        fagl_true     TYPE boolean.

  FIELD-SYMBOLS: <lt_doc_data> TYPE STANDARD TABLE,
                 <ls_table>    TYPE ANY,
                 <lt_si_table> TYPE STANDARD TABLE.

*--- Initialize structures Yxxxx
  REFRESH  yabkpf.
  REFRESH: ybseg, ybseg_add, ybseg_flex, ybsec, ybsed, ybset.
  REFRESH  lt_arch_data[].
  CLEAR    wa_arch_data.
  CLEAR:   ls_fagl_names.

*--- Read archived document into structures Yxxxx
  PERFORM arch_tables_for_selection CHANGING
                                     ls_fagl_names
                                     lt_arch_data.

  CALL FUNCTION 'FI_DOCUMNT_ARCH_READ_DATA_OBJH'
    EXPORTING
      iv_handle   = archive_handle
    CHANGING
      ct_doc_data = lt_arch_data[].

  LOOP AT lt_arch_data[] INTO wa_arch_data.
    CASE wa_arch_data-tabname.
      WHEN 'BKPF'.
        PERFORM move_arch_to_tab
                   USING 'BKPF'
                         wa_arch_data
                   CHANGING yabkpf[].

      WHEN 'BSEG'.
        PERFORM move_arch_to_tab
                  USING 'BSEG'
                        wa_arch_data
                  CHANGING ybseg[].

      WHEN 'BSEG_ADD'.
        PERFORM move_arch_to_tab
                   USING 'BSEG_ADD'
                         wa_arch_data
                   CHANGING ybseg_add[].

      WHEN ls_fagl_names-si_table.
        CREATE DATA yfaglflexa TYPE STANDARD TABLE OF
                                  (ls_fagl_names-si_table).
        ASSIGN yfaglflexa->* TO <lt_si_table>.
        IF sy-subrc = 0.
          ASSIGN wa_arch_data-tabref->* TO <lt_doc_data>.
          LOOP AT <lt_doc_data> ASSIGNING <ls_table>.
            MOVE-CORRESPONDING <ls_table> TO ls_ledger.
            IF ls_ledger = g_rldnr.
              APPEND <ls_table> TO <lt_si_table>.
              fagl_true = 'X'.
            ENDIF.
          ENDLOOP.
        ENDIF.

      WHEN 'BSEC'.
        PERFORM move_arch_to_tab
                   USING 'BSEC'
                         wa_arch_data
                   CHANGING ybsec[].

      WHEN 'BSED'.
        PERFORM move_arch_to_tab
                   USING 'BSED'
                         wa_arch_data
                   CHANGING ybsed[].

      WHEN 'BSET'.
        PERFORM move_arch_to_tab
                   USING 'BSET'
                         wa_arch_data
                   CHANGING ybset[].

    ENDCASE.
  ENDLOOP.

  READ TABLE yabkpf INDEX 1 INTO wa_yabkpf.
  MOVE-CORRESPONDING wa_yabkpf TO wa_ybkpf.

* Initialisation
  flag = space.
  bkpf = wa_ybkpf.

* Selections are checked -> flag changed to 'X' if not needed.
  PERFORM beleg_check
           CHANGING flag.

  PERFORM beleg_dyn_check
           CHANGING flag.

  IF NOT ybseg_add[] IS INITIAL AND bkpf-bstat = 'L'.
    LOOP AT ybseg_add INTO wa_ybseg_add.
      MOVE-CORRESPONDING wa_ybseg_add TO wa_ybseg.
      APPEND wa_ybseg TO ybseg.
    ENDLOOP.
  ENDIF.
  IF NOT fagl_true IS INITIAL.
    CALL FUNCTION 'FAGL_FLEXA_TO_DOC_TRANSFORM'
      EXPORTING
        it_bseg      = ybseg
        it_faglflexa = <lt_si_table>
      IMPORTING
        et_bseg_ext  = ybseg_flex.
    REFRESH ybseg[].
    LOOP AT ybseg_flex INTO wa_ybseg_flex.
      MOVE-CORRESPONDING wa_ybseg_flex TO wa_ybseg.
      APPEND wa_ybseg TO ybseg.
    ENDLOOP.
    CLEAR: <lt_si_table>, <ls_table>, <lt_doc_data>, fagl_true.
  ENDIF.

  IF flag EQ space.
    IF sy-batch IS INITIAL.
      lv_cnt_read = lv_cnt_read + 1.
      lv_cnt_read2 = lv_cnt_read.
      IF lv_cnt_read2 = l_prog_show.
*     Progress indicator
        CALL FUNCTION 'PROGRESS_INDICATOR'
          EXPORTING
            i_msgid              = 'F9'
            i_msgno              = '022'
            i_processed          = lv_cnt_read
            i_total              = pv_cnt_tot
            i_output_immediately = 'X'.
        CLEAR lv_cnt_read2.
      ENDIF.
    ENDIF.

*   document is OK
    b0sg-xarbl = 'X'.
    save_bukrs = bkpf-bukrs.
    PERFORM t001_read.
*   expiring currencies:
    gd_waers_save = bkpf-waers.
    IF NOT gd_expcur_flag IS INITIAL.
      PERFORM item_curr_convert_bkpf USING   'SAPDBBRF'
                                             sy-datlo
                                    CHANGING bkpf.
    ENDIF.
    IF bkpf-rldnr IS INITIAL.
      bkpf-rldnr = g_rldnr.
    ENDIF.
    PUT bkpf.
  ENDIF.

ENDFORM.                    " process_archive_files            "997117

*&---------------------------------------------------------------------*
*&      Form  ADD_ADRNR_TO_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->TAB_NAM    text
*----------------------------------------------------------------------*
FORM ADD_ADRNR_TO_TABLE tables TAB_NAM structure rsfs_struc .

* Check IAV is active.
  check CL_IAV_MAPPING_UTIL=>IS_IAV_ACTIVE( ) is not initial.
  loop at TAB_NAM TRANSPORTING NO FIELDS
       where line = 'NAME1' or
             line = 'NAME2' or
             line = 'NAME3' or
             line = 'NAME4' or
             line = 'ORT01' or
             line = 'ORT02' or
             line = 'SORTL' or
             line = 'STRAS'.

    perform ADD_FIELD_TO_TABLE tables TAB_NAM using 'ADRNR'.
    exit.
  endloop.
endform.                    "ADD_ADRNR_TO_TABLE
*&---------------------------------------------------------------------*
*&      Form check_arch_faglfreesel                            "1672938
*&---------------------------------------------------------------------*
form check_arch_faglfreesel changing flag.
  data l_ds_frange  type rsds_frange.
  field-symbols:
            <feld>  type any.

  loop at l_ds_range-frange_t into l_ds_frange.
    if not l_ds_frange-selopt_t is initial.
      assign component l_ds_frange-fieldname of structure bseg to <feld>.
      if sy-subrc = 0.
        if not <feld> in l_ds_frange-selopt_t.
          flag = 'X'.
        endif.
      endif.
    endif.
  endloop.

endform.                    " check_arch_faglfreesel

*&---------------------------------------------------------------------*
*&      Form  read_bkpf_hana
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM read_bkpf_hana USING p_xnor TYPE abap_bool
                          p_xvor TYPE abap_bool.
  DATA: c                   TYPE cursor,
        lv_exit             TYPE abap_bool,
        lv_skip             TYPE abap_bool.

  FIELD-SYMBOLS: <fin_glpos> LIKE LINE OF gt_fin_glpos.

  DATA: lt_orderby TYPE if_fin_selection_types=>tt_selection_fields.

  BREAK-POINT ID fin_ldb_brf.

  lt_orderby = cl_fin_ldb_brf=>convert_fields( 'MANDT BUKRS BELNR GJAHR BUZEI' ).

* create object for later select in BAdI
  PERFORM create_object_ldb_brf USING lt_orderby.

  IF p_xnor = abap_true.
* select normal documents with cursor c
    PERFORM call_badi_for_select  USING    abap_false
                                  CHANGING c.
  ENDIF.

  IF p_xvor = abap_true.
* select parked documents with cursor c
    PERFORM call_badi_for_select  USING    abap_true
                                  CHANGING c.
  ENDIF.
*** Loop over packages
  WHILE lv_exit = abap_false.

    FETCH NEXT CURSOR c INTO CORRESPONDING FIELDS OF TABLE gt_fin_glpos
                        PACKAGE SIZE 10000.

    IF sy-subrc <> 0.
      DATA: diff_time LIKE sy-uzeit.
      GET TIME FIELD time2.
      diff_time = time2 - time1.
      lv_exit = abap_true.
      EXIT.
    ENDIF.

***   Loop inside packages
    gv_cursor = 1.
    READ TABLE gt_fin_glpos INDEX gv_cursor ASSIGNING <fin_glpos>.
    WHILE sy-subrc = 0.

*       Move Data to correct structure as used in report
      MOVE-CORRESPONDING <fin_glpos> TO bkpf.

      PERFORM check_and_prepare_bkpf_hana.


*       get next and ensure that we get the next new bkpf
*       skipping should only occur when not selecting BSEG or authority check for BKPF failed
      lv_skip = abap_false.
      READ TABLE gt_fin_glpos INDEX gv_cursor ASSIGNING <fin_glpos>.
      IF sy-subrc = 0.
        IF ( <fin_glpos>-bukrs = save_bukrs ) AND
           ( <fin_glpos>-belnr = save_belnr ) AND
           ( <fin_glpos>-gjahr = save_gjahr ).
          lv_skip = abap_true.
        ENDIF.
      ELSE.
        EXIT.
      ENDIF.

      WHILE ( lv_skip = abap_true ).
        lv_skip = abap_false.
        gv_cursor = gv_cursor + 1.
        READ TABLE gt_fin_glpos INDEX gv_cursor ASSIGNING <fin_glpos>.
        IF sy-subrc = 0.
          IF ( <fin_glpos>-bukrs = save_bukrs ) AND
             ( <fin_glpos>-belnr = save_belnr ) AND
             ( <fin_glpos>-gjahr = save_gjahr ).
            lv_skip = abap_true.
          ENDIF.
        ENDIF.
      ENDWHILE.

    ENDWHILE.

  ENDWHILE.

  CLOSE CURSOR c.

  IF ( p_xnor = abap_true ) AND
     ( b0sg-xstaa = abap_true OR b0sg-xstab = abap_true ).
*----- handle clearing documents with bstat = 'A' and bstat 'B'
    PERFORM handle_bstat_ab_documents.
  ENDIF.

ENDFORM.                    "read_bkpf_hana

*
FORM call_badi_for_select  USING iv_parked TYPE abap_bool
                           CHANGING c      TYPE cursor.
  DATA: lr_badi_ldb_brf    TYPE REF TO fin_ldb_brf_dbsys_opt.

  BREAK-POINT ID fin_ldb_brf.
*   call BAdI

  TRY.
      GET BADI lr_badi_ldb_brf
        FILTERS
          dbsys_type = cl_db_sys=>dbsys_type.

      CALL BADI lr_badi_ldb_brf->select
        EXPORTING
          io_select = go_ldb
          iv_parked = iv_parked
        IMPORTING
          ev_cursor = c.
    CATCH cx_badi_not_implemented.

  ENDTRY.
ENDFORM.                    "call_badi_for_select

*
FORM create_object_ldb_brf USING lt_orderby TYPE if_fin_selection_types=>tt_selection_fields.
*** Apply Authority Checks prior to report execution
*   Authority Checks modify ranges for later selection
  BREAK-POINT ID fin_ldb_brf.
  CREATE OBJECT go_ldb
    EXPORTING
      iv_join           = abap_false
      it_range_bukrs    = br_bukrs[]
*     it_range_gsber    = br_gsber[] "no range w.r.t. GSBER is supplied by BRF
      it_range_blart    = br_blart[]
      it_range_gjahr    = br_gjahr[]
      it_range_rldnr    = br_rldnr[]
      it_range_ldgrp    = br_ldgrp[]
      it_range_belnr    = br_belnr[]
      it_range_budat    = br_budat[]
      it_range_cpudt    = br_cpudt[]
      it_range_xblnr    = br_xblnr[]
      it_range_awtyp    = br_awtyp[]
      it_range_awkey    = br_awkey[]
      it_range_awsys    = br_awsys[]
      it_range_bldat    = br_bldat[]
      it_range_usnam    = br_usnam[]
      it_range_vatdate  = br_vatdt[]
      it_range_bstat    = gr_bstat[]
*     it_range_generic  =
*     it_where          =
      is_b0sg           = b0sg
      it_bkpf_list      = bkpf_fields[]
      it_bseg_list      = bseg_fields[]
*     it_sum_fields     =
      it_orderby_fields = lt_orderby.


ENDFORM.                    "create_object_ldb_brf

*
FORM check_and_prepare_bkpf_hana.
  DATA: lv_authority_failed TYPE abap_bool.

  lv_authority_failed = abap_false.
  IF NOT  ( g_glflex_active IS INITIAL )
  AND NOT ( b0sg-xadoc      IS INITIAL ).
    CALL FUNCTION 'FAGL_AUTHORITY_LEDGER'
      EXPORTING
        i_bukrs      = bkpf-bukrs
        i_rldnr      = bkpf-rldnr
        i_ldgrp      = bkpf-ldgrp
        i_actvt      = '03'
      EXCEPTIONS
        no_authority = 4.

    IF sy-subrc <> 0.
      lv_authority_failed = abap_true.
    ENDIF.
  ENDIF.

  save_bukrs = bkpf-bukrs.
  save_belnr = bkpf-belnr.
  save_gjahr = bkpf-gjahr.
  save_bstat = bkpf-bstat.
  cnt_bkpf = cnt_bkpf + 1.

  IF lv_authority_failed = abap_false.

    IF bkpf-bstat EQ 'D'.
      SELECT SINGLE * FROM bkdf
        WHERE bukrs EQ bkpf-bukrs
        AND   belnr EQ bkpf-belnr
        AND   gjahr EQ bkpf-gjahr.
    ENDIF.
    b0sg-xarbl = space.
    PERFORM t001_read.
*         expiring currencies:
    gd_waers_save = bkpf-waers.
    IF NOT gd_expcur_flag IS INITIAL.
      PERFORM item_curr_convert_bkpf USING    'SAPDBBRF'
                                              sy-datlo
                                     CHANGING bkpf.
    ENDIF.

    IF bkpf-rldnr IS INITIAL.
      bkpf-rldnr = g_rldnr.
    ENDIF.

    PUT bkpf.

  ENDIF.
ENDFORM.                    "check_and_prepare_bkpf_hana

*&---------------------------------------------------------------------*
*&      Form  handle_bstat_ab_documents
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM handle_bstat_ab_documents.

  DATA: ls_bstat TYPE LINE OF if_fin_selection_types=>ty_range_bstat,
        lr_bstat TYPE if_fin_selection_types=>ty_range_bstat.

  REFRESH gt_fin_glpos[].

  IF b0sg-xstaa = 'X'.
    ls_bstat-sign = 'I'.
    ls_bstat-option = 'EQ'.
    ls_bstat-low = 'A'.
    APPEND ls_bstat TO lr_bstat.
  ENDIF.
  IF b0sg-xstab = 'X'.
    ls_bstat-sign = 'I'.
    ls_bstat-option = 'EQ'.
    ls_bstat-low = 'B'.
    APPEND ls_bstat TO lr_bstat.
  ENDIF.

  SELECT (bkpf_fields) FROM bkpf INTO CORRESPONDING FIELDS OF bkpf
         WHERE   bstat IN lr_bstat
           AND   bukrs IN br_bukrs
           AND   blart IN br_blart
           AND   budat IN br_budat
           AND   xblnr IN br_xblnr
           AND   belnr IN br_belnr
           AND   gjahr IN br_gjahr
           AND   awtyp IN br_awtyp
           AND   awkey IN br_awkey
           AND   awsys IN br_awsys
           AND   cpudt IN br_cpudt
           AND   bldat IN br_bldat
           AND   usnam IN br_usnam
           AND   ( ldgrp IN gr_ldgrp OR ldgrp IS NULL )     "976164
           AND   ( rldnr IN gr_rldnr OR rldnr IS NULL )     "1320519
           AND   ( vatdate IN br_vatdt OR vatdate IS NULL ) "1023317
           AND   (bkpf_where)
           ORDER BY PRIMARY KEY.
    PERFORM check_and_prepare_bkpf_hana.
  ENDSELECT.
ENDFORM.                    "handle_bstat_ab_documents
*
FORM set_in_memory_mode.
  DATA: lr_badi_ldb_brf    TYPE REF TO fin_ldb_brf_dbsys_opt.
  DATA: lv_zdm_running     TYPE s_zdm_running.

  BREAK-POINT ID fin_ldb_brf.
*   call BAdI

  TRY.
      GET BADI lr_badi_ldb_brf
        FILTERS
          dbsys_type = cl_db_sys=>dbsys_type.
    CATCH cx_badi_not_implemented.
  ENDTRY.

  IF lr_badi_ldb_brf IS NOT INITIAL.
    gv_in_memory = abap_true.
    CALL FUNCTION 'UPGRUNT_CHECK_ZDM_RUNNING'
     IMPORTING
       ev_zdm_running       = lv_zdm_running.
    IF lv_zdm_running IS NOT INITIAL.
      gv_in_memory = abap_false.
    ENDIF.
  ELSE.
    gv_in_memory = abap_false.
  ENDIF.

ENDFORM.                    "set_in_memory_mode
*
FORM set_ldb_mode USING ud_initial_setting TYPE abap_bool.
  CONSTANTS: xhana_default TYPE c VALUE ' '.
  DATA: lv_supplied TYPE abap_bool VALUE abap_false,
        lo_badi     TYPE REF TO if_ex_fi_authority_item.

  DATA: ls_range        TYPE rsdsselopt,
        lt_range_waerse TYPE rsdsselopt_t,
        ld_waerse       TYPE waers,
        lt_tcure        TYPE TABLE OF waers.

  BREAK-POINT ID fin_ldb_brf.
  IF ud_initial_setting = abap_true.
* initial setting of field xhana
    IF gv_in_memory = abap_true.
*      xhana = 'I'.
      xhana = xhana_default.
    ENDIF.
    EXIT.
  ELSE.
* adapt field xhana in special situations
*** Updata Mode for HANA Optimization
* If not on in-memory database reset flag (might be set by the calling report)
    IF gv_in_memory = abap_false.
      xhana = space.
    ENDIF.
* If not read from database --> reset external optimization to internal optimization (to prevent external read  from database)
    IF xusedb = space AND ( xhana = 'E' OR xhana = 'A' ).
*      xhana = 'I'.
      xhana = xhana_default.
    ENDIF.
* If Authority check w.r.t. date has to be done per line (see authority_bkpf)
* external optimization (which is used for aggregation) is not possible
    IF gd_tpc_check = 'X' AND gd_tpc_check_sel NE 'X' AND ( xhana = 'E' OR xhana = 'A' ).
*      xhana = 'I'.
      xhana = xhana_default.
    ENDIF.
* external optimization is not supported if documents with expired currency still exist
* (for example totals seclection via rfbelj10_nacc or rfbelj00)
    IF gd_expcur_flag = 'X' AND ( xhana = 'E' OR xhana = 'A' ).
*      xhana = 'I'.
      SELECT curc_old FROM tcure INTO TABLE lt_tcure.
      IF sy-subrc EQ 0.
        LOOP AT lt_tcure INTO ld_waerse.
          ls_range-sign   = 'I'.
          ls_range-option = 'EQ'.
          ls_range-low    = ld_waerse.
          ls_range-high   = ld_waerse.
          APPEND ls_range TO lt_range_waerse.
        ENDLOOP.
        SELECT COUNT(*) FROM bkpf WHERE bukrs IN br_bukrs
                                  AND   gjahr IN br_gjahr
                                  AND   waers IN lt_range_waerse.
        IF sy-dbcnt NE 0.
* there are really documents with expiring currencies
          xhana = xhana_default.
        ENDIF.
      ELSE.
* no expiring currencies maintained in the system
* do not change xhana
      ENDIF.
    ENDIF.
* Authority Check BadI FI_AUTHORITY_ITEM is implemented, but no field list is supplied by the BadI
*   --> Suppress external optimization as all fields of BSEG are read
    IF xhana = 'A'.
      CALL METHOD cl_exithandler=>get_instance
        EXPORTING
          exit_name              = 'FI_AUTHORITY_ITEM'
          null_instance_accepted = seex_true
        CHANGING
          instance               = lo_badi
        EXCEPTIONS
          OTHERS                 = 8. "technical exceptions.
      IF sy-subrc = 0. "No technical issues such as cast error etc.
        IF lo_badi IS NOT BOUND.
          lv_supplied = abap_true. "Authority Check BadI is not implemented
          "--> no need to supply corresponding fields
        ELSE.
          TRY.
              CALL METHOD lo_badi->get_fieldlist
                IMPORTING
                  ev_supplied = lv_supplied.
            CATCH cx_root.
              "Method not implemented, we must assume field list is not supplied
              lv_supplied = abap_false.
          ENDTRY.
        ENDIF.
      ENDIF.
*     No field list supplied --> reset to internal
      IF lv_supplied = abap_false.
*        xhana = 'I'.
        xhana = xhana_default.
      ENDIF.
    ENDIF.
    IF b0sg-xdocc = 'X'.
      xhana = space.
    ENDIF.

  ENDIF.

ENDFORM.                    "set_ldb_mode

*&---------------------------------------------------------------------*
*&      Form  read_bseg_hana
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM read_bseg_hana.
  DATA: lv_get_next TYPE abap_bool,
        lv_failed   TYPE abap_bool.
  FIELD-SYMBOLS: <fin_glpos> LIKE LINE OF  gt_fin_glpos.

  READ TABLE gt_fin_glpos INDEX gv_cursor ASSIGNING <fin_glpos>.
  IF sy-subrc = 0.
    lv_get_next = abap_true.
  ELSE.
    lv_get_next = abap_false.
  ENDIF.
  WHILE ( lv_get_next = abap_true ).

    MOVE-CORRESPONDING <fin_glpos> TO bseg.
    go_ldb->bseg( EXPORTING is_bkpf = bkpf
                  IMPORTING ev_failed = lv_failed
                  CHANGING  cs_bseg = bseg ).
    IF lv_failed = abap_false.

      save_buzei = bseg-buzei.
      cnt_bseg = cnt_bseg + 1.
*     expiring currencies:
      IF NOT gd_expcur_flag IS INITIAL.
        PERFORM item_curr_convert_bseg USING    'SAPDBBRF'
                                                t001-waers
                                                gd_waers_save
                                                sy-datlo
                                       CHANGING bseg.
      ENDIF.
      MOVE-CORRESPONDING bseg TO bsegh.
      PERFORM got_bsega(sapbsega).
*        CPD-DATEN
      IF bseg-xcpdd EQ 'X'
      AND b0sg-xbsec NE ' '.
        CALL FUNCTION 'CVP_READ_SINGLE_BSEC'
          EXPORTING
            IV_BUKRS      = save_bukrs
            IV_BELNR      = save_belnr
            IV_GJAHR      = save_gjahr
            IV_BUZEI      = save_buzei
            IV_KOART      = bseg-koart
            IV_NO_MASKING = 'X'
          IMPORTING
            ES_BSEC       = bsec
          EXCEPTIONS
            NOT_FOUND     = 1
            NO_AUTHORITY  = 2.
        IF sy-subrc NE 0.
          CLEAR bsec.
        ENDIF.
      ELSE.
        CLEAR bsec.
      ENDIF.
*        WECHSELDATEN
      CLEAR bsed.
      IF bseg-umsks NE 'A'
      AND bseg-umsks NE space
      AND b0sg-xbsed NE ' '.
        SELECT SINGLE * FROM bsed
          WHERE bukrs = save_bukrs
          AND   belnr = save_belnr
          AND   buzei = save_buzei
          AND   gjahr = save_gjahr.
      ENDIF.
      cnt_bsegsel = cnt_bsegsel + 1.
      IF alcur EQ 'X'.
        PERFORM convert_alt        "euro
        USING 'BSEG' bkpf-waers.
      ENDIF.                       "euro

      PUT bseg.
    ENDIF.
    CLEAR bseg.

*     Get next
    gv_cursor = gv_cursor + 1.
    READ TABLE gt_fin_glpos INDEX gv_cursor ASSIGNING <fin_glpos>.
    IF sy-subrc <> 0.
      lv_get_next = abap_false.
    ELSE.
      IF ( <fin_glpos>-bukrs <> save_bukrs ) OR
         ( <fin_glpos>-belnr <> save_belnr ) OR
         ( <fin_glpos>-gjahr <> save_gjahr ).
        lv_get_next = abap_false.
      ENDIF.
    ENDIF.
  ENDWHILE.

ENDFORM.                    "read_bseg_hana
*---------------------------------------------------------------------*
*   Form  check_authority_fields           -> note 2017063
*---------------------------------------------------------------------*
*    New form to check validity of field list for selection from BSEG
*---------------------------------------------------------------------*
FORM check_authority_fields changing BSEG_FIELDS type t_fields.

data:      lv_supplied  type abap_bool,
           lo_badi      TYPE REF TO if_ex_fi_authority_item,
           lt_fieldname type fieldname_tab,
           ld_fieldname type fieldname.


      CALL METHOD cl_exithandler=>get_instance
        EXPORTING
          exit_name              = 'FI_AUTHORITY_ITEM'
          null_instance_accepted = seex_true
        CHANGING
          instance               = lo_badi
        EXCEPTIONS
          OTHERS                 = 8. "technical exceptions.

      IF sy-subrc = 0. "No technical issues such as cast error etc.
        IF lo_badi IS NOT BOUND.
*         Authority Check BadI is not implemented
*         --> no need to enhance bseg-fields with further
*         customer fields used  for authority check
*         -> set of bseg fields can be used for selection
          exit.
        ELSE.
          TRY.
              CALL METHOD lo_badi->get_fieldlist
                IMPORTING
                  et_fieldname = lt_fieldname
                  ev_supplied  = lv_supplied.

            CATCH cx_root.
*             Method not implemented, we must assume that
*             special field list is not supplied:
*             => clear field list in order to select all
*                fields from bseg
              refresh bseg_fields.
              exit.
          ENDTRY.

          if lv_supplied = abap_true.
*            Enhance bseg field  list with provided customer fields
             loop at lt_fieldname into ld_fieldname.
                 read table bseg_fields transporting no fields
                            with key ld_fieldname.
                 if sy-subrc ne 0.
                    append ld_fieldname to bseg_fields.
                 endif.
             endloop.
          else.
*           clear bseg fields in order to select all fields from bseg
            refresh bseg_fields.
          endif.

        ENDIF.
      ENDIF.


endform.
*INCLUDE DBBRFSEL.
*INCLUDE zdbbrfsel.
