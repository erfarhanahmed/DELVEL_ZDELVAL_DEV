*f*&---------------------------------------------------------------------*
*& Report  ZRMMR1MRS01
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zrmmr1mrs01 MESSAGE-ID m8 LINE-SIZE 130 .


**************Report created for tcode zmrrl by RANI E. *****************************



*REPORT  rmmr1mrs  MESSAGE-ID m8 LINE-SIZE 130 .
*ENHANCEMENT-POINT rmmr1mrs_01 SPOTS es_rmmr1mrs STATIC.
**$*$-Start: RMMR1MRS_01-------------------------------------------------------------------------$*$*
*ENHANCEMENT 1  OIA_SI_RMMR1MRS.    "active version
*INCLUDE OI_RMMR1TOI.
*ENDENHANCEMENT.
*$*$-End:   RMMR1MRS_01-------------------------------------------------------------------------$*$*
*&---------------------------------------------------------------------*
*& Report  RMMR1MRS                                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*& ERS-Verfahren: - Selektion der abzurechnenden Warenbewegungen       *
*&                - Abrechnung durch Log. Reprü über Funktionsbaustein *
*&                - Druckausgabe über Nachrichtenfindung               *
*&                - Protokoll mit ALV Tools                            *
*& Voraussetzung: WE-bezogene Rechnungsprüfung aktiv                   *
*&---------------------------------------------------------------------*
*& By setting flag 'P_ERSDC', planned delivery costs can be settled    *
*& automatically with goods items. Prerequisite is that the freight    *
*& vendor is activated in the customizing for ERS procedure. Then a    *
*& record per condition type will be created during goods receipt.     *
*& For several goods receipts to a PO item a total line per condition  *
*& type will be generated during automatic settlement. GR-based        *
*& invoice verification is not possible for planned delivery costs.    *
*&---------------------------------------------------------------------*

TABLES: ekbe,
        ekrs,
        /sappspro/eadd,
        rm08e.                         "ERS-Verfahren: Belegabgrenzung
TABLES: ekbz,
        ekrsdc,
        erptm_iv_data.

TABLES: mkpf, mseg, ekpo, essr, lfa1, lfbw, t059zt, t059p.           "ADDED BY RANI E.


DATA : lv_gst TYPE i.
DATA : wa_konp1 TYPE p DECIMALS 2.

* Rahmen "Belegauswahl"  -----------------------------------------------
SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK auswahl WITH FRAME TITLE TEXT-050.
SELECT-OPTIONS:
      b_bukrs FOR ekrs-bukrs DEFAULT '1000' MEMORY ID buk,
      b_werks FOR ekbe-werks DEFAULT 'PL01' MEMORY ID wrk,
*      B_BUDAT FOR EKRS-BUDAT,
      p_budat FOR ekrs-budat,
      b_mblnr FOR ekrs-belnr," OBLIGATORY,ADDED BY PRIMUS JYOTI ON 16.01.2024
      b_mjahr FOR ekrs-gjahr DEFAULT sy-datum+(4),
      b_lifnr FOR ekrs-lifnr MATCHCODE OBJECT kred MEMORY ID lif,
      r_longn FOR /sappspro/eadd-longnum_uc
                   MATCHCODE OBJECT /sappspro/mekk,
      b_ebeln FOR ekrs-ebeln,
      b_ebelp FOR ekrs-ebelp,
*      B_LBLNI FOR ESSR-LBLNI,
      budat1 FOR mkpf-budat OBLIGATORY default sy-datum no-extension no intervals..
*ENHANCEMENT-POINT rmmr1mrs_02 SPOTS es_rmmr1mrs STATIC.
SELECTION-SCREEN END OF BLOCK auswahl.

*ENHANCEMENT-POINT rmmr1mrs_03 SPOTS es_rmmr1mrs STATIC.
*---------------------------------------------------------------------*
* ERSBA = 1        Ein Beleg pro Lieferant                            *
* ERSBA = 2        Ein Beleg pro Bestellung                           *
* ERSBA = 3        Ein Beleg pro Bestellposition                      *
* ERSBA = 4        Ein Beleg pro Materialbeleg                        *
*---------------------------------------------------------------------*

* Rahmen "Verarbeitung" ------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK verarbeitung WITH FRAME TITLE TEXT-051.
*ENHANCEMENT-POINT rmmr1mrs_04 SPOTS es_rmmr1mrs STATIC.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(25) FOR FIELD ersba.
SELECTION-SCREEN POSITION 33.
* Art Belegabgrenzung
PARAMETERS: ersba LIKE rm08e-ersba OBLIGATORY "VALUE CHECK
                                              MEMORY ID  ersba.
SELECTION-SCREEN COMMENT 37(60) ersba_tx FOR FIELD ersba.
SELECTION-SCREEN END OF LINE.
* Protokoll der Nachrichtenfindung
PARAMETERS: pa_prot LIKE boole-boole NO-DISPLAY.
* Testlauf
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(30) FOR FIELD b_xtest.
PARAMETERS:  b_xtest LIKE rm08e-ers_xtest VALUE CHECK DEFAULT 'X'.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_ersdc TYPE xfeld AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN COMMENT (79) TEXT-011 FOR FIELD p_ersdc.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK verarbeitung.

* Rahmen "Anzeigen" ----------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK anzeigen WITH FRAME TITLE TEXT-052.
PARAMETERS:
* Anzeigevariante
  pa_varia LIKE disvariant-variant.
SELECTION-SCREEN END OF BLOCK anzeigen.

* TM "Anzeigen"---------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK tm WITH FRAME TITLE TEXT-053. "Ehp5e TM
PARAMETERS: pa_tm TYPE xtm AS CHECKBOX
                  USER-COMMAND ivtm.
SELECTION-SCREEN SKIP.
SELECT-OPTIONS: b_tspid  FOR erptm_iv_data-tsp_id MATCHCODE OBJECT kred MODIF ID tm.
SELECTION-SCREEN SKIP.
SELECT-OPTIONS: b_torid  FOR erptm_iv_data-tor_id MODIF ID tm,    "1
                b_bolid  FOR erptm_iv_data-bol_id MODIF ID tm,    "3
                b_awbid  FOR erptm_iv_data-awb_id MODIF ID tm,    "4
                b_flight  FOR erptm_iv_data-flight_id MODIF ID tm,"5
                b_voyid  FOR erptm_iv_data-voyage_id MODIF ID tm. "6

SELECTION-SCREEN END OF BLOCK tm.

*---------------------------------------------------------------------*
*        Typen                                                        *
*---------------------------------------------------------------------*

TYPES: BEGIN OF t_erw_ekrs.
    INCLUDE STRUCTURE ekrs.
TYPES: END OF t_erw_ekrs.
**********ADDED BY JYOTI ON 18.04.2024
TYPES: BEGIN OF t_ek08ersdc,
     LFBNR TYPE MSEG-LFBNR,
     LIFNR TYPE LIFNR,
     EBELN type EBELN,
     EBELP type EBELP,
     STUNR type STUNR,
     ZAEHK type DZAEHK,
     KSCHL type KSCHL,
     MWSKZ type MWSKZ,
     TXJCD type TXJCD,
     FRBNR type FRBNR1,
 END OF t_ek08ersdc.
TYPES: ty_settle_dc TYPE t_ek08ersdc OCCURS 1.
****************************************
TYPES: tab_erw_ekrs TYPE t_erw_ekrs OCCURS 1.

TYPES: BEGIN OF t_bestab,
         lifnr LIKE ekko-lifnr,
         ebeln LIKE ekko-ebeln,
         ebelp LIKE ekpo-ebelp,
         lfbnr LIKE ekbe-lfbnr,
         lfgja LIKE ekbe-lfgja,
         lfpos LIKE ekbe-lfpos,
       END OF t_bestab.

TYPES: tab_bestab TYPE t_bestab OCCURS 1.

*---------------------------------------------------------------------*
* Types for planned delivery costs                                    *
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*        Types                                                        *
*---------------------------------------------------------------------*
TYPES: BEGIN OF typ_ekrsdc.
*         lifnr LIKE ekko-lifnr,
*         ebeln LIKE ekko-ebeln,
*         ebelp LIKE ekpo-ebelp,
*         stunr LIKE ekbz-stunr,
*         zaehk LIKE ekbz-zaehk,
*         kschl LIKE ekbz-kschl,
*         MWSKZ type MWSKZ,
*         TXJCD type TXJCD,
*         FRBNR type FRBNR1,
*         LFBNR TYPE MSEG-LFBNR,"ADDED BY JYOTI ON 18.04.2024
            INCLUDE STRUCTURE ekrsdc.
 types:   END OF typ_ekrsdc.
TYPES typ_tekrsdc TYPE typ_ekrsdc OCCURS 1.

TYPES: BEGIN OF typ_podata,
         lifnr LIKE ekko-lifnr,
         ebeln LIKE ekko-ebeln,
         ebelp LIKE ekpo-ebelp,
         stunr LIKE ekbz-stunr,
         zaehk LIKE ekbz-zaehk,
         kschl LIKE ekbz-kschl,
         xekbz LIKE boole-boole,
         LFBNR TYPE MSEG-LFBNR,"ADDED BY JYOTI ON 18.04.2024
*         xblnr TYPE ekbe-xblnr,"ADDED BY JYOTI ON 22.04.2024
       END OF typ_podata.
TYPES: typ_tpodata TYPE typ_podata OCCURS 1.

INCLUDE zmrm_types_nast01.                                                "mrm_types_nast.

INCLUDE:zmrm_const_common01,                                                "mrm_const_common,
        zmrm_const_mrm01,                                                "mrm_const_mrm,
        zmrm_const_nast01,                                                "mrm_const_nast,
        zmrm_const_me01.                                                "mrm_const_me.

TYPE-POOLS: mrm, mmers, shlp, slis.

DATA: lv_tm_invoice_clerk TYPE char2.

*---------------------------------------------------------------------*
*        Interne Tabellen                                             *
*---------------------------------------------------------------------*

*------- Bestellpositionen -------------------------------------------*
DATA: bestab TYPE tab_bestab WITH HEADER LINE.

*------- Tabelle mit allen gelesenen EKRS-Einträgen, erweitert -------*
*------- um den Referenzbeleg zur korrekten Identifizierung beim -----*
*------- Aufbau von LEKRS (enthält die zu löschenden Sätze)    -------*
DATA: xerw_ekrs TYPE tab_erw_ekrs WITH HEADER LINE.

*----- Tabelle mit allen abzurechnenden Positionen; Positionen, die --*
*----- gemeinsam abgerechnet werden, haben die gleiche Blocknummer. --*
DATA: segtab TYPE mmers_tsegtab WITH HEADER LINE.

***********ADDED BY RANI E.******************************


DATA: gt_segtab TYPE mmers_tsegtab WITH HEADER LINE.

TYPES: BEGIN OF ty_podata,
         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
         netwr TYPE netwr,
         brtwr TYPE brtwr,
         mwskz TYPE mwskz,
         bukrs TYPE bukrs,
         kolif TYPE kolif,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         netpr TYPE ekpo-netpr,
         elikz TYPE ekpo-elikz,
       END OF ty_podata.

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
         knumv TYPE ekko-knumv,
         bsart TYPE ekko-bsart,
       END OF ty_ekko.


TYPES: BEGIN OF ty_mseg,
         mblnr      TYPE mseg-mblnr,
         mjahr      TYPE mseg-mjahr,
         budat_mkpf TYPE mseg-budat_mkpf,
         bwart      TYPE mseg-bwart,
         lifnr      TYPE mseg-lifnr,
         dmbtr      TYPE mseg-dmbtr,
         ebeln      TYPE mseg-ebeln,
         ebelp      TYPE mseg-ebelp,
         lfbnr      TYPE mseg-lfbnr,
         menge      TYPE mseg-menge,
         bnbtr      TYPE mseg-bnbtr,
       END OF ty_mseg.

TYPES: BEGIN OF ty_mseg1,
         mblnr TYPE mseg-mblnr,
         mjahr TYPE mseg-mjahr,
         bwart TYPE mseg-bwart,
         lifnr TYPE mseg-lifnr,
         dmbtr TYPE mseg-dmbtr,
         ebeln TYPE mseg-ebeln,
         ebelp TYPE mseg-ebelp,
         lfbnr TYPE mseg-lfbnr,
         menge TYPE mseg-menge,
         bnbtr TYPE mseg-bnbtr,
       END OF ty_mseg1.

TYPES: BEGIN OF ty_mkpf,
         mblnr TYPE mkpf-mblnr,
         mjahr TYPE mkpf-mjahr,
         bldat TYPE mkpf-bldat,
       END OF ty_mkpf.

TYPES: BEGIN OF ty_essr,
         lblni TYPE essr-lblni,
         ebeln TYPE essr-ebeln,
         ebelp TYPE essr-ebelp,
       END OF ty_essr.

TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
       END OF ty_lfa1.

TYPES: BEGIN OF ty_ekbe,
         ebeln TYPE ekbe-ebeln,
         ebelp TYPE ekbe-ebelp,
         gjahr TYPE ekbe-gjahr,
         belnr TYPE ekbe-belnr,
         dmbtr TYPE ekbe-dmbtr,
         menge TYPE ekbe-menge,
         wrbtr TYPE ekbe-wrbtr,
         mwskz TYPE ekbe-mwskz,
       END OF ty_ekbe.

TYPES : BEGIN OF ty_konv,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          kawrt TYPE prcd_elements-kawrt,
          kbetr TYPE prcd_elements-kbetr,
          lifnr TYPE prcd_elements-lifnr,
          kwert TYPE prcd_elements-kwert,
        END OF ty_konv.

TYPES : BEGIN OF ty_bkpf,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          awkey TYPE bkpf-awkey,
        END OF ty_bkpf.

TYPES : BEGIN OF ty_a003,
          kappl TYPE a003-kappl,
          kschl TYPE a003-kschl,
          aland TYPE a003-aland,
          mwskz TYPE a003-mwskz,
          knumh TYPE a003-knumh,
        END OF ty_a003.
***********88added by primus jyoti on 13.02.2024
TYPES : BEGIN OF ty_a991,
          kappl TYPE a991-kappl,
          kschl TYPE a991-kschl,
          mwskz TYPE a991-mwskz,
          knumh TYPE a991-knumh,
        END OF ty_a991.

DATA : it_a991 TYPE TABLE OF ty_a991,
       wa_a991 TYPE ty_a991.
*****************************************************
DATA : it_a003 TYPE TABLE OF ty_a003,
       wa_a003 TYPE ty_a003.


TYPES : BEGIN OF ty_konp,
          knumh TYPE konp-knumh,
          kopos TYPE konp-kopos,
          kbetr TYPE konp-kbetr,
          kschl TYPE konp-kschl,
          mwsk1 TYPE konp-mwsk1,
        END OF ty_konp.


TYPES : BEGIN OF ty_eslh,
          packno TYPE eslh-packno,
          ebeln  TYPE eslh-ebeln,
          ebelp  TYPE eslh-ebelp,
        END OF ty_eslh.



TYPES : BEGIN OF ty_eskl,
          packno TYPE eskl-packno,
          introw TYPE eskl-introw,
          numkn  TYPE eskl-numkn,
          netwr  TYPE eskl-netwr,
        END OF ty_eskl.


TYPES : BEGIN OF ty_ekpo1,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          knttp TYPE ekpo-knttp,
          pstyp TYPE ekpo-pstyp,
          elikz TYPE ekpo-elikz,
        END OF ty_ekpo1.

DATA : it_eslh TYPE TABLE OF ty_eslh,
       wa_eslh TYPE ty_eslh,

       it_eskl TYPE TABLE OF ty_eskl,
       wa_eskl TYPE ty_eskl.

DATA : it_konp TYPE TABLE OF ty_konp,
       wa_konp TYPE ty_konp.



DATA: gt_po_data TYPE TABLE OF ty_podata,
      gs_po_data TYPE ty_podata,
      gt_ekko    TYPE TABLE OF ty_ekko,
      gs_ekko    TYPE ty_ekko,
      gt_lfbw    TYPE TABLE OF lfbw,
      gs_lfbw    TYPE lfbw,
      gt_t059zt  TYPE TABLE OF t059zt,
*      GT_T059P  TYPE TABLE OF T059P,
*      GS_T059P  TYPE T059P,
      gs_t059zt  TYPE t059zt, "Commented by Nilay B. On 25.08.2023
      gt_mseg    TYPE TABLE OF ty_mseg,
      gs_mseg    TYPE ty_mseg,

      gt_mseg1   TYPE TABLE OF ty_mseg1,
      gs_mseg1   TYPE ty_mseg1,

      gt_mkpf    TYPE TABLE OF ty_mkpf,
      gs_mkpf    TYPE ty_mkpf,
      gt_essr    TYPE TABLE OF ty_essr,
      gs_essr    TYPE ty_essr,
      gt_lfa1    TYPE TABLE OF ty_lfa1,
      gs_lfa1    TYPE ty_lfa1,
      gt_ekbe    TYPE TABLE OF ty_ekbe,
      gs_ekbe    TYPE ty_ekbe,
      gt_konv    TYPE TABLE OF ty_konv,
      gs_konv    TYPE ty_konv,
      gt_bkpf    TYPE TABLE OF ty_bkpf,
      gs_bkpf    TYPE ty_bkpf,
      gt_ekpo1   TYPE TABLE OF ty_ekpo1,
      gs_ekpo1   TYPE ty_ekpo1.


DATA: zzvar  TYPE zzgstamt,
      zawkey TYPE awkey.           "GST AMOUNT

************ENDED BY RANI E.*********************

*--- Tabelle mit Einkaufsbelegkopf und -positionen, für Prefetch    ---*
DATA: BEGIN OF xekbel OCCURS 1.
    INCLUDE STRUCTURE ekbel.
DATA: END OF xekbel.

*--- Tabelle für Prefetch auf Einkaufsbelegköpfe                   ---*
DATA: BEGIN OF xekko_key OCCURS 1.
    INCLUDE STRUCTURE ekko_key.
DATA: END OF xekko_key.
DATA:lt_ekrs TYPE ekrs OCCURS 100,
     lt_eadd TYPE /sappspro/eadd OCCURS 100,
     BEGIN OF lt_ekrs_eadd_join OCCURS 100,
       ekrs TYPE ekrs,
       eadd TYPE /sappspro/eadd,
     END OF lt_ekrs_eadd_join,
     ls_ekrs           LIKE LINE OF lt_ekrs,
     ls_eadd           LIKE LINE OF lt_eadd,
     ls_ekrs_eadd_join LIKE LINE OF lt_ekrs_eadd_join.

*---------------------------------------------------------------------*
* internal tables for planned delivery costs                          *
*---------------------------------------------------------------------*
DATA: tab_ekrsdc    TYPE TABLE OF ekrsdc,
      tab_podata    TYPE TABLE OF typ_podata,
      tab_segtab_dc TYPE mmers_tsegtab WITH HEADER LINE.
*---------------------------------------------------------------------*
*        Strukturen                                                   *
*---------------------------------------------------------------------*
DATA: s_variant LIKE  disvariant,
      s_var_usr LIKE  disvariant.

DATA: lv_msg TYPE boole-boole.

*---------------------------------------------------------------------**
* Konstanten
*---------------------------------------------------------------------**
CONSTANTS:
  c_save(1)     TYPE  c               VALUE  'A',
  c_repid       TYPE  sy-repid        VALUE  'ZRMMR1MRS01',            "CHANGED BY RANI E.
  c_top_of_list TYPE  slis_formname   VALUE  'TOP_OF_LIST',
  c_segtab      TYPE  slis_tabname    VALUE  'SEGTAB',
  c_dokclass_na TYPE  dsysh-dokclass  VALUE  'NA'.


CONSTANTS: ersba_1 LIKE rm08e-ersba VALUE '1 ',   " Beleg pro Lieferant
           ersba_2 LIKE rm08e-ersba VALUE '2 ',   " ... pro Bestellung
           ersba_3 LIKE rm08e-ersba VALUE '3 ',   " ... pro Bestellpos
           ersba_4 LIKE rm08e-ersba VALUE '4 ',   "  ... pro Lieferbeleg
           ersba_5 LIKE rm08e-ersba VALUE '6 ',   " Beleg pro transport service provider
           ersba_6 LIKE rm08e-ersba VALUE '7 '.   " Beleg pro TM beleg


*---------------------------------------------------------------------**
* Initialization.
*---------------------------------------------------------------------**
INITIALIZATION.

*ENHANCEMENT-POINT rmmr1mrs_18 SPOTS es_rmmr1mrs STATIC .

*ENHANCEMENT-POINT rmmr1mrs_06 SPOTS es_rmmr1mrs.
* Schalter Varianten benutzerspezifisch/allgemein speicherbar setzen
  PERFORM variant_init.
* Get default variant
  s_var_usr = s_variant.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = c_save
    CHANGING
      cs_variant = s_var_usr
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 0.
    pa_varia =  s_var_usr-variant.
  ENDIF.

*---------------------------------------------------------------------**
* at selection-screen output.
*---------------------------------------------------------------------**
AT SELECTION-SCREEN OUTPUT.

  IF /sappspro/cl_numbers=>is_active( ) EQ space.
    LOOP AT SCREEN.
      SEARCH screen-name FOR 'R_LONGN'.
      IF sy-subrc EQ 0.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      SEARCH screen-name FOR 'b_ebeln'.
      IF sy-subrc EQ 0.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ENDIF.

  IF ersba IS INITIAL.                                            "ERP Ehp5e TM
    GET PARAMETER ID 'ERSBA' FIELD ersba.
  ENDIF.
  IF ersba IS INITIAL.
    ersba = '3'.
  ELSE.
    IF pa_tm EQ abap_true.
      IF ersba NE '6' AND ersba NE '7'.
        ersba = '7'.
      ENDIF.
    ELSE.
      IF ersba EQ '6' OR ersba EQ '7'.
        ersba = '3'.
      ENDIF.
    ENDIF.
  ENDIF.

  PERFORM tm_selection_screen.                                    "ERP Ehp5e TM

  PERFORM get_ersba_text USING    ersba
                         CHANGING ersba_tx.

*ENHANCEMENT-POINT rmmr1mrs_07 SPOTS es_rmmr1mrs.
*---------------------------------------------------------------------**
* at selection-screen
*---------------------------------------------------------------------**
AT SELECTION-SCREEN ON VALUE-REQUEST FOR ersba.
  PERFORM f4_ersba.                    " changing ersba.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_varia.
  PERFORM f4_varia CHANGING pa_varia.

* PAI
AT SELECTION-SCREEN.
  IF NOT pa_varia IS INITIAL.
    MOVE s_variant TO s_var_usr.
    MOVE pa_varia TO s_var_usr-variant.
    CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
      EXPORTING
        i_save     = c_save
      CHANGING
        cs_variant = s_var_usr.
    s_variant = s_var_usr.
  ELSE.
    PERFORM variant_init.
  ENDIF.
**************Added by jyoti on 22.10.2024
*  BREAK-POINT.


* if flag 'Goods Items + Planned Delivery Costs' is set it's not possible
* to enter GR based data

  " ---------- COMMENT BY ANISH ON 02.06.2023 ----------------
*  IF ( NOT B_BUDAT[] IS INITIAL OR NOT B_MBLNR[] IS INITIAL
*       OR NOT B_MJAHR[] IS INITIAL OR ERSBA EQ ERSBA_4 )
*       AND NOT P_ERSDC IS INITIAL.
*    MESSAGE TEXT-012 TYPE 'E'.
*    EXIT.
*  ENDIF.
  "--------------- END OF COMMENT SECTION -------------------


*---------------------------------------------------------------------*
*        Reportablauf                                                 *
*---------------------------------------------------------------------*
START-OF-SELECTION.

  if budat1 is NOT INITIAL.
  if budat1-low GT sy-datum.
  MESSAGE 'Posting date should not be later than the system date.' type 'E'.
 endif.
 endif.

*ENHANCEMENT-POINT rmmr1mrs_08 SPOTS es_rmmr1mrs.
* initialization/refresh of internal tables
*BREAK primus.
  PERFORM report_init TABLES bestab
                             xerw_ekrs
                             xekbel
                             segtab
                             xekko_key
                             tab_ekrsdc
                             tab_podata
                             tab_segtab_dc.
* read ekrs
  PERFORM lesen_tab_ekrs TABLES xerw_ekrs
                                xekbel
                                xekko_key.
* settle planned delivery costs
  IF NOT p_ersdc IS INITIAL.
* read ekrsdc
    PERFORM ekrsdc_read TABLES tab_ekrsdc
                               xekbel
                               xekko_key.
  ENDIF.

* Filter TM documeter aus ERS process. pa_tm as 'X', ERS processes only TM document,
* pa_tm as '', ERS processes only standard ERP document.
  cl_mrm_tm_services=>filter_tm_document_ers(               "Ehp5e TM
  EXPORTING
    iv_tmflag = pa_tm
    it_tor_id = b_torid[]
    it_tsp_id  = b_tspid[]
    it_bol_id = b_bolid[]
    it_awb_id = b_awbid[]
    it_voyage_id = b_voyid[]
    it_flight_id = b_flight[]
  CHANGING
    ct_ekrs = xerw_ekrs[] ).
sort  tab_ekrsdc[] by belnr.
  IF xerw_ekrs[] IS INITIAL AND tab_ekrsdc[] IS INITIAL.
*    MESSAGE 'Document already posted' TYPE 'I' DISPLAY LIKE 'S'."added by Jyoti MAhajan 15.01.2024

    MESSAGE s702.
*    EXIT.
*    SUPPRESS DIALOG.
*    LEAVE TO SCREEN 1000.
    RETURN.
  ENDIF.

*ENHANCEMENT-POINT rmmr1mrs_09 SPOTS es_rmmr1mrs.
* build internal table with ekrs-entries which have to be processed
  PERFORM ermittlung_referenz_belege TABLES xerw_ekrs
                                            xekbel.
* build internal table
  PERFORM sammlung_bestellpositionen TABLES xerw_ekrs
                                            bestab.

  IF NOT tab_ekrsdc[] IS INITIAL.
* collect entries in table tab_ekrsdc
    DATA :  xerw_ekrs_NEW TYPE TABLE OF t_erw_ekrs.
*    LOOP at xerw_ekrs.
    xerw_ekrs_NEW = xerw_ekrs[].
*    LOOP AT xerw_ekrs.
*    on CHANGE OF xerw_ekrs-lfbnr.
    PERFORM ekrsdc_data_collect TABLES tab_ekrsdc
                                       tab_podata.
*    endon.
*    endloop.
  ENDIF.

* build internal table with work-positions
  PERFORM aufbereitung_bestelldaten TABLES bestab
                                          xekko_key
                                          segtab.

* If TM switch is on, segtab[] collect tm special data.
  IF cl_ops_switch_check=>mm_sfws_tm( ) = abap_true
    AND pa_tm EQ abap_true.

    CALL METHOD cl_mrm_tm_services=>merge_tm_data_ers
      CHANGING
        ct_segtab = segtab[].
  ENDIF.

*ENHANCEMENT-POINT rmmr1mrs_10 SPOTS es_rmmr1mrs.
* delete wrong entries in SEGTAB for service pos
* bearbeitung_dienstleistung has become obsolete.
* PERFORM bearbeitung_dienstleistung TABLES xerw_ekrs
*                                            segtab.
*BREAK PRIMUS.
  IF NOT tab_podata[] IS INITIAL.
* read corresponding PO data for delivery cost items
    PERFORM podata_read TABLES tab_podata
                               xekbel
                               xekko_key
                               tab_segtab_dc.
* call BAdI MRM_ERS_IDAT_MODIFY to modify item data and check currency
    PERFORM segtab_dc_modify TABLES tab_segtab_dc.

  ENDIF.
* append internal table with delivery cost items to
* segtab (until now internal table segtab contains only goods items)
  PERFORM segtab_complete TABLES tab_segtab_dc
                                 segtab
                           USING ersba.
* MRM_SPLIT_DATA_ERS
  PERFORM bearbeitung_daten TABLES segtab
                            USING  ersba.
*ENHANCEMENT-POINT rmmr1mrs_11 SPOTS es_rmmr1mrs.
* create invoice
*  BREAK PRIMUS.
*************ADDED BY RANI E.*************
  IF sy-tcode = 'ZMRRL'.
    SORT SEGTAB BY LFBNR.
    PERFORM protokollausgabe TABLES segtab.
  ENDIF.
***************ENDED BY RANI E.*************
*  PERFORM rechnungspruefung_daten TABLES segtab
*                                         xerw_ekrs
*                                         tab_ekrsdc.
*
** create ALV list
*  PERFORM protokollausgabe TABLES segtab.


*---------------------------------------------------------------------*
*       Formroutinen                                                  *
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       FORM ANSTOSSEN_REPRUE                                         *
*---------------------------------------------------------------------*
*  wird nur im Echtmodus ausgeführt.                                  *
*  Ablauf:                                                            *
*  1. Falls der Block abrechenbar ist (erkennbar an dem Input-Parame- *
*     ter PI_ABRECHENBAR):                                            *
*     a) Aufruf Reprü-Funktionsbaustein                               *
*     b) Löschen der verarbeiteten ekrs-sätze (stehen in PTI_EKRS)    *
*     c) Erzeugung einer Nachricht für den Druck                      *
*     d) Übernahme der Rechnungsbelegnummer und des Rechnungsbeleg-   *
*        jahres in alle Sätze mit der aktuellen Blocknummer (in der   *
*        Tabelle PTX_SEGTAB)                                          *
*     Wenn bei einem der Schritte ein Fehler auftritt, dann wird die  *
*     die entsprechende Fehlermeldung in alle Sätze mit der aktuellen *
*     Blocknummer übernommen (in der Tabelle PTX_SEGTAB). Zusätzlich  *
*     Zusätzlich erhält das Feld ABRECHENBAR in all diesen Sätzen den *
*     Wert SPACE.                                                     *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-> PTX_SEGTAB: Tabelle des Typs MMERS_TSEGTAB                      *
* --> PTI_EKRS: Tabelle der Struktur EKRS                             *
* --> PTI_SELWENR: Tabelle der Struktur EK08ERSWE                     *
* --> PI_ABRECHENBAR: Typ C                                           *
* --> PI_AKT_BLOCKNR: Typ I                                           *
* --> PI_XRECH: Kennzeichen, ob Rechnung                              *
* <-> PX_FIRST_ERSSATZ: Struktur vom Typ MMERS_SEGTAB; enthält ersten *
*                       zu der aktuellen Blocknummer                  *
*---------------------------------------------------------------------*
FORM anstossen_reprue TABLES   ptx_segtab TYPE mmers_tsegtab
                               pti_ekrs STRUCTURE ekrs
                               pti_selwenr STRUCTURE ek08erswe
                               pti_ekrsdc_del STRUCTURE ekrsdc
                               pti_settle_dc STRUCTURE ek08ersdc
                      USING    pi_abrechenbar TYPE c
                               pi_akt_blocknr TYPE i
                               pi_xrech TYPE mrm_rbkpv-xrech
                               i_simulation LIKE boole-boole
                      CHANGING px_first_erssatz TYPE mmers_segtab.

  DATA: lf_update   LIKE  boole-boole.

data : segtab_1 TYPE mmers_tsegtab.
  DATA: reprue_rc  TYPE i,
        h_rbkpv    TYPE mrm_rbkpv,
        ls_komkbmr LIKE  komkbmr.

  DATA: BEGIN OF h_mesg.
      INCLUDE STRUCTURE mesg.
  DATA: END OF h_mesg.

  DATA: t_accdn LIKE accdn OCCURS 0 WITH HEADER LINE,
        t_logdn LIKE logdn OCCURS 0 WITH HEADER LINE.

Data :   pti_ekrs1 TYPE TABLE OF ekrs,
         pti_ekrsdc_del1 TYPE TABLE OF ekrsdc,
         wa_ekrs type ekrs,
         wa_ekrs1 type ekrs,
          wa_ekrsdc_del TYPE ekrsdc,
          wa_ekrsdc_del1 TYPE ekrsdc.


  CHECK pi_abrechenbar = 'X'.

  CLEAR: reprue_rc, h_rbkpv, h_mesg.
* Begin of "N971293
***********ADDED BY RANI E.*****************************
  BREAK primusabap.
  IF sy-tcode = 'ZMRRL'.
    b_xtest = ''.
    sy-tcode = 'MRRL'.


  ENDIF.
  if  sy-tcode = 'MRRL'.
     SELECT SINGLE budat,bldat,XBLNR FROM MKPF INTO @data(LS_mkpf1)
      WHERE MBLNR = @px_first_erssatz-LFBNR.
****************added by jyoti on 23.10.2024**********************
*************logic for posting date********************************
    if budat1-low gt sy-datum.
        h_mesg-msgty = 'E'.
        h_mesg-msgv3 = 'Posting date should not be later than the system date.'.
*        MESSAGE 'Posting Date is not in Future' TYPE 'E'.
    elseif budat1-low lt ls_mkpf1-budat.
      h_mesg-msgty = 'E'.
      h_mesg-msgv3 = 'Back dated Posting date is not allowed.'.
*        MESSAGE 'Posting Date is not in Back Dated' TYPE 'E'.
    endif.
  endif.
************ENDED BY RANI E.******************************

  IF b_xtest IS INITIAL.    "lock entries in case of update modus
    LOOP AT pti_ekrs.
      CALL FUNCTION 'ENQUEUE_E_EKRS'
        EXPORTING
          mandt          = sy-mandt
          budat          = pti_ekrs-budat
          lifnr          = pti_ekrs-lifnr
          belnr          = pti_ekrs-belnr
          buzei          = pti_ekrs-buzei
          gjahr          = pti_ekrs-gjahr
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        h_mesg-msgty = 'E'.
        h_mesg-arbgb = sy-msgid.
        h_mesg-txtnr = sy-msgno.
        h_mesg-msgv1 = sy-msgv1.
        h_mesg-msgv2 = sy-msgv2.
        h_mesg-msgv3 = sy-msgv3.
        h_mesg-msgv4 = sy-msgv4.                                      :
        PERFORM aufbereitung_fehlermeldung CHANGING h_mesg.
        reprue_rc    = '1'.
      ENDIF.

    ENDLOOP.

    LOOP AT pti_ekrsdc_del.
      CALL FUNCTION 'ENQUEUE_E_EKRSDC'
        EXPORTING
          mandt          = sy-mandt
          belnr          = pti_ekrsdc_del-belnr
          buzei          = pti_ekrsdc_del-buzei
          gjahr          = pti_ekrsdc_del-gjahr
          stunr          = pti_ekrsdc_del-stunr
          zaehk          = pti_ekrsdc_del-zaehk
          kschl          = pti_ekrsdc_del-kschl
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        h_mesg-msgty = 'E'.
        h_mesg-arbgb = sy-msgid.
        h_mesg-txtnr = sy-msgno.
        h_mesg-msgv1 = sy-msgv1.
        h_mesg-msgv2 = sy-msgv2.
        h_mesg-msgv3 = sy-msgv3.
        h_mesg-msgv4 = sy-msgv4.                                      :
        PERFORM aufbereitung_fehlermeldung CHANGING h_mesg.
        reprue_rc    = '1'.
      ENDIF.

    ENDLOOP.

  ENDIF.
* End of "N971293
   BREAK PRIMUSABAP.
  IF h_mesg-msgty NE 'E'.                                   "N971293
* create invoice
**************added by primus jyoti on 12.04.2024************************
 SORT pti_selwenr[] ."DESCENDING.
  DELETE ADJACENT DUPLICATES FROM pti_selwenr[] COMPARING ALL FIELDS.
  SORT pti_settle_dc[] ."DESCENDING.
  DELETE ADJACENT DUPLICATES FROM pti_settle_dc[] COMPARING ALL FIELDS.
***************************************************************************
 DATA : pti_selwenr_1      TYPE TABLE OF ek08erswe,
       pti_selwenr_2      TYPE TABLE OF ek08erswe,
         gs_pti_selwenr_1   TYPE ek08erswe,
        pti_settle_dc_1     TYPE TABLE OF ek08ersdc,
        pti_SD              TYPE ek08ersdc,
        gs_pti_settle_dc_1     TYPE  ek08ersdc.

* delete ADJACENT DUPLICATES FROM pti_selwenr[] COMPARING ebeln lfbnr.
     SORT pti_selwenr[] by ebeln lfbnr.
*    DELETE PTI_SELWENR[] WHERE ebeln NE px_first_erssatz-ebeln
*                             and lfbnr NE px_first_erssatz-lfbnr.
*     DELETE PTI_SELWENR[] WHERE "ebeln NE px_first_erssatz-ebeln "commet fo testing on 14.10.2024
*                             lfbnr NE px_first_erssatz-lfbnr."commet fo testing on 14.10.2024

     SORT PTI_SETTLE_DC[] by ebeln lfbnr..
*    DELETE PTI_SETTLE_DC[] WHERE ebeln NE px_first_erssatz-ebeln
*                          and lfbnr NE px_first_erssatz-lfbnr.
*    DELETE PTI_SETTLE_DC[] WHERE" ebeln NE px_first_erssatz-ebeln "commet fo testing on 14.10.2024
*                          lfbnr NE px_first_erssatz-lfbnr. "commet fo testing on 14.10.2024

*BREAK primusabap.
" --------------- ADDED BY jyoti ON 03.09.2024 FOR WITH HOLDING TAX --------------".
**READ TABLE ptx_segtab with key lifnr =  px_first_erssatz-lifnr.
*READ TABLE segtab with key lifnr =  px_first_erssatz-lifnr.
*          IF segtab-zzwitht IS NOT INITIAL.
*            EXPORT segtab-zzwitht TO MEMORY ID 'ZMRRL_TAX'.
*          ENDIF.
" ----------------------------------------------------

*****************************ADDED BY JYOTI ON 23.07.2024**********************
    DATA :LV_COUNT TYPE CHAR3.
loop at pti_selwenr INTO DATA(data_1) WHERE lfbnr EQ px_first_erssatz-lfbnr.
  LV_COUNT = LV_COUNT + 1.
ENDLOOP.
**********************************************************************************
IF LV_COUNT eq 1.
loop at pti_selwenr INTO DATA(data).
  gs_pti_selwenr_1 = data.
    append gs_pti_selwenr_1 to pti_selwenr_1.
***********************************************************************************

*  SORT pti_settle_dc_1[].
  loop at pti_settle_dc into data(data_dc) where ebeln eq data-ebeln
                                            and lfbnr Eq data-lfbnr.
     gs_pti_settle_dc_1 = data_dc.
       append gs_pti_settle_dc_1 to pti_settle_dc_1.
   endloop.
*DELETE PTI_SETTLE_DC_1 WHERE ebeln EQ data-ebeln
*                          and lfbnr NE data-lfbnr.
*    IF sy-tcode = 'ZMRRL'.
                                        "ADDED BY RANI E.
      PERFORM aufruf_reprue TABLES  pti_selwenr_1 " pti_selwenr
                                    pti_settle_dc_1
                            USING    px_first_erssatz
                                     i_simulation
                            CHANGING h_rbkpv
                                     h_mesg
                                     reprue_rc.
*    endloop.
***************ADDED BY RANI E.************
*    ELSE.
*      PERFORM aufruf_reprue TABLES   pti_selwenr
*                                   pti_settle_dc
*                          USING    px_first_erssatz
*                                   i_simulation
*                          CHANGING h_rbkpv
*                                   h_mesg
*                                   reprue_rc.
************************************************
*    ENDIF.                                                    "ENDED BY RANI E.
    IF reprue_rc = 0.
* delete ekrs
      READ TABLE pti_ekrs INDEX 1.
      IF sy-subrc = 0.                   "Sätze zum Löschen vorhanden:
        PERFORM fortschreibung_ekrs TABLES pti_ekrs.
      ENDIF.
* delete ekrsdc
      READ TABLE pti_ekrsdc_del INDEX 1.
      IF sy-subrc = 0.
        PERFORM ekrsdc_update TABLES pti_ekrsdc_del.
      ENDIF.
*      ENDLOOP.
    ENDIF.

* create messages
    IF reprue_rc = 0 OR reprue_rc = 2.
      IF b_xtest IS INITIAL.
        lf_update = 'X'.
      ENDIF.
      IF NOT sy-batch IS INITIAL.
        CLEAR pa_prot.
      ENDIF.



*   Kommunikationsstruktur füllen
      CLEAR ls_komkbmr.
      ls_komkbmr-bukrs = h_rbkpv-bukrs.
      ls_komkbmr-belnr = h_rbkpv-belnr.
      ls_komkbmr-blart = h_rbkpv-blart.
      ls_komkbmr-usnam = h_rbkpv-usnam.
      ls_komkbmr-lifnr = px_first_erssatz-lifnr.     " Partner LF
      ls_komkbmr-lifre = h_rbkpv-lifnr.  ".            Partner RS
      ls_komkbmr-ivtyp = h_rbkpv-ivtyp.
      ls_komkbmr-ident = c_ident_ers.    ".            ERS: 'E'

      CALL FUNCTION 'MRM_HEAD_MESSAGE_CREATE'
        EXPORTING
          if_kappl      = c_kappl_mr
          if_kalsm      = c_kalsm_0004
          is_rbkpv      = h_rbkpv
          is_komkbmr    = ls_komkbmr
          if_update     = lf_update
          if_protocol   = pa_prot
        EXCEPTIONS
*DELETE wegen Fehler bei der erweiterten Programmprüfung
*         no_message_found = 1      " note 420739 MB
          error_message = 2
          OTHERS        = 3.

      IF sy-subrc <> 0.
        IF i_simulation EQ space.
          reprue_rc = 1.
        ELSEIF i_simulation EQ 'X'.
          reprue_rc = 3.
        ENDIF.
        IF sy-msgty = 'A'.   "Ausgabe der A-Meldung als E-Meldung:
          h_mesg-msgty = 'E'.
        ELSE.
          h_mesg-msgty = sy-msgty.
        ENDIF.
        h_mesg-arbgb = sy-msgid.
        h_mesg-txtnr = sy-msgno.
        h_mesg-msgv1 = sy-msgv1.
        h_mesg-msgv2 = sy-msgv2.
        h_mesg-msgv3 = sy-msgv3.
        h_mesg-msgv4 = sy-msgv4.                                      :
        PERFORM aufbereitung_fehlermeldung CHANGING h_mesg.
      ELSEIF sy-subrc EQ 0.
        IF i_simulation EQ 'X'.
          reprue_rc = 2.
        ENDIF.
      ENDIF.
    ENDIF.
*    CLEAR :data,gs_pti_selwenr_1.
*    REFRESH pti_selwenr_1 .
*     endloop."added by primus jyoti on 12.04.2024
*  ENDIF.                                                    "N971293
** preparation for next release ***************************************

* create receipt-flow between order and invoice
*  if reprue_rc = 0.
*    ls_role_b-objkey  = h_rbkpv-belnr. " Nummer des Rech.-Belegs
*    ls_role_b-objtype = 'BUS2081'.     " Eingangsrechnung
*    loop at pti_selwenr.
*      call function 'ME_EKKO_SINGLE_READ'
*           exporting
*                pi_ebeln         = pti_selwenr-ebeln
*           importing
*                po_ekko          = ls_ekko
*           exceptions
*                no_records_found = 1
*                others           = 2.

*      if sy-subrc eq 0.
*        ls_role_a-objkey  = pti_selwenr-ebeln. " Nummer des EK-Belegs
*        case ls_ekko-bstyp.
*          when 'F'.
*            ls_role_a-objtype = 'BUS2012'.   " Bestellung
*          when 'L'.
*            ls_role_a-objtype = 'BUS2013'.   " Lieferplan
*          when others.
*            exit.
*        endcase.

*        call function 'QMLR_CREATE_DOCUMENT_FLOW'
*             exporting
*                  role_a             = ls_role_a
*                  role_b             = ls_role_b
*                  reltype            = 'VONA'
*             exceptions
*                  no_logical_system  = 1
*                  no_relation_create = 2
*                  others             = 3.

*        if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        endif.
*      endif.
*    endloop.
*  endif.

* posting

  CASE reprue_rc.
    WHEN '0'.
      COMMIT WORK AND WAIT.
      IF sy-subrc NE 0.
        MOVE 'XX' TO h_mesg-arbgb.
        MOVE  '005' TO h_mesg-txtnr.   "Verbuchungsabbruch
        h_mesg-text = TEXT-e05.
        MOVE 1 TO reprue_rc.
      ENDIF.
    WHEN '1'.
      ROLLBACK WORK.
  ENDCASE.

  CASE reprue_rc.
    WHEN '0'.                          "Echtmodus, abrechenbar
* get fi document number from program memory
      CLEAR:   t_accdn, t_logdn.
      REFRESH: t_accdn, t_logdn.
      t_accdn-awtyp = 'RMRP'.
      t_accdn-awref = h_rbkpv-belnr.
      t_accdn-aworg = h_rbkpv-gjahr.
      t_accdn-awsys = h_rbkpv-logsys.
*      t_accdn-awsys = t000-logsys.
      APPEND t_accdn.

* In the ERS-process system can create both ERS and ERS-zero invoices.
* but there should exist only a FI document for ERS-invoice, not for
* ERS-zero invoice.

      IF h_rbkpv-ivtyp = c_ivtyp_ers.
        CALL FUNCTION 'FI_DOCUMENT_NUMBER_GET'
          TABLES
            t_accdn = t_accdn
            t_logdn = t_logdn.
      ENDIF.

* more than one FI document number possible, read document(s) from
* leading company code
      READ TABLE t_logdn WITH KEY bukrs = h_rbkpv-bukrs
                                   logvo = 'MAIN'
                                  gjahr = h_rbkpv-gjahr.

      IF sy-subrc = 0.
        MOVE t_logdn-belnr TO px_first_erssatz-fibel.
      ENDIF.
      MOVE h_rbkpv-belnr  TO px_first_erssatz-rbelnr.
      MOVE h_rbkpv-gjahr  TO px_first_erssatz-rgjahr.
      MOVE 'M8'           TO px_first_erssatz-arbgb.
      IF pi_xrech = 'X'.
        MOVE '327' TO px_first_erssatz-txtnr.   "Rechnung gebucht.
      ELSE.
        MOVE '327' TO px_first_erssatz-txtnr.   "Gutschrift gebucht.
      ENDIF.
*      BREAK-POINT.
      MODIFY ptx_segtab FROM px_first_erssatz
                        TRANSPORTING rbelnr rgjahr arbgb txtnr fibel
                        WHERE blocknr = pi_akt_blocknr
                        and lfbnr = data-LFBNR"added by jyoti on 17.04.2024
                        AND EBELN = data-EBELN."added by jyoti on 17.04.2024
    WHEN '1'.                          "Echtmodus, nicht abrechenbar
      MOVE-CORRESPONDING h_mesg TO px_first_erssatz.
      MOVE space TO px_first_erssatz-abrechenbar.
      MODIFY ptx_segtab FROM px_first_erssatz
                       TRANSPORTING abrechenbar msgty text arbgb
                                    txtnr msgv1 msgv2 msgv3 msgv4
                       WHERE blocknr = pi_akt_blocknr.
*ENHANCEMENT-POINT anstossen_reprue_01 SPOTS es_rmmr1mrs.
    WHEN '2'.                          "Testmodus, buchbar
    WHEN '3'.                          "Testmodus, nicht buchbar
      MOVE-CORRESPONDING h_mesg TO px_first_erssatz.
      MOVE space TO px_first_erssatz-abrechenbar.
      MODIFY ptx_segtab FROM px_first_erssatz
                       TRANSPORTING abrechenbar msgty text arbgb
                                    txtnr msgv1 msgv2 msgv3 msgv4
                       WHERE blocknr = pi_akt_blocknr.
  ENDCASE.
*   delete ADJACENT DUPLICATES FROM pti_selwenr[] COMPARING ebeln lfbnr.
   CLEAR :data,gs_pti_selwenr_1, gs_pti_settle_dc_1."added by primus jyoti on 17.04.2024
    REFRESH :  pti_settle_dc_1 ."added by primus jyoti on 17.04.2024
     endloop."added by primus jyoti on 17.04.2024
*************ADDED BY JYOTI ON 23.07.2024 AT 23.51 ********************
 ELSE.
*   break primusabap.
*READ TABLE pti_selwenr INDEX 1."commented by jyoti on 12.09.2024
   sort  pti_selwenr[] by ebeln ebelp ASCENDING.
READ TABLE pti_selwenr with key ebeln = px_first_erssatz-ebeln lfbnr = px_first_erssatz-lfbnr.
if pti_selwenr-ebelp = px_first_erssatz-ebelp.
loop at pti_selwenr INTO data where lfbnr eq px_first_erssatz-lfbnr"ebeln eq px_first_erssatz-ebeln
                                    and ebelp eq pti_selwenr-ebelp."'00010'."added by jyoti on 09.08.2024
       loop at pti_selwenr into data(data_2) where "ebeln eq data-ebeln
                             lfbnr Eq data-lfbnr.
    gs_pti_selwenr_1 = data_2.
       append gs_pti_selwenr_1 to pti_selwenr_1.

     endloop.

*
*     LOOP at pti_selwenr_1 into gs_pti_selwenr_1.
     READ TABLE  pti_selwenr_1 INTO  gs_pti_selwenr_1 WITH KEY lfbnr = gs_pti_selwenr_1-lfbnr.
     loop at pti_settle_dc into data(data_dc_1) where "ebeln eq gs_pti_selwenr_1-ebeln "commented by jyoti on 23.08.2024
                          lfbnr Eq gs_pti_selwenr_1-lfbnr.
     gs_pti_settle_dc_1 = data_dc_1.
       append gs_pti_settle_dc_1 to pti_settle_dc_1.

     endloop.

      sort pti_ekrs[] by lfbnr lfpos.
       DELETE ADJACENT DUPLICATES FROM pti_ekrs[] COMPARING ALL FIELDS .
*       sort pti_ekrsdc_del[] by belnr buzei.
       sort pti_ekrsdc_del[] .
       DELETE ADJACENT DUPLICATES FROM pti_ekrsdc_del[] COMPARING ALL FIELDS .
     loop at pti_ekrs INTO wa_ekrs WHERE  "ebeln eq gs_pti_selwenr_1-ebeln  "commented by jyoti on 23.08.2024
                           lfbnr Eq gs_pti_selwenr_1-lfbnr.
       wa_ekrs1 = wa_ekrs .
       append  wa_ekrs1 to pti_ekrs1.
     endloop.

     loop at pti_ekrsdc_del INTO wa_ekrsdc_del WHERE " ebeln eq gs_pti_selwenr_1-ebeln "commented by jyoti on 23.08.2024
                          belnr Eq gs_pti_selwenr_1-lfbnr.
       wa_ekrsdc_del1 = wa_ekrsdc_del .
       append  wa_ekrsdc_del1 to pti_ekrsdc_del1.
     endloop.



*  if  px_first_erssatz-EBELN  EQ DATA-EBELN AND px_first_erssatz-ebelp eq '00010'."added by jyoti on 09.08.2024
* READ TABLE pti_selwenr with key lfbnr = px_first_erssatz-lfbnr."added by jyoti on 26.08.2024
   IF px_first_erssatz-ebelp eq pti_selwenr-ebelp."'00010'.
      PERFORM aufruf_reprue TABLES  pti_selwenr_1"pti_selwenr " pti_selwenr
                                    pti_settle_dc_1"pti_settle_dc
                            USING    px_first_erssatz
                                     i_simulation
                            CHANGING h_rbkpv
                                     h_mesg
                                     reprue_rc.

  endif.

       if H_RBKPV-RMWWR is NOT INITIAL.
        IF reprue_rc = 0.
* delete ekrs
*      READ TABLE pti_ekrs INDEX 1.
      READ TABLE pti_ekrs1 into wa_ekrs INDEX 1."with key belnr = data-lfbnr
                                  " ebeln = data-ebeln.

      IF sy-subrc = 0.                   "Sätze zum Löschen vorhanden:
        PERFORM fortschreibung_ekrs TABLES pti_ekrs1[].
      ENDIF.

* delete ekrsdc
*      READ TABLE pti_ekrsdc_del INDEX 1.
*      READ TABLE pti_ekrsdc_del with key belnr = data-lfbnr
*                                   ebeln = data-ebeln.

    READ TABLE pti_ekrsdc_del1 into wa_ekrsdc_del index 1.
      IF sy-subrc = 0.
        PERFORM ekrsdc_update TABLES pti_ekrsdc_del1[].
      ENDIF.

    ENDIF.


* create messages
    IF reprue_rc = 0 OR reprue_rc = 2.
      IF b_xtest IS INITIAL.
        lf_update = 'X'.
      ENDIF.
      IF NOT sy-batch IS INITIAL.
        CLEAR pa_prot.
      ENDIF.



*   Kommunikationsstruktur füllen
      CLEAR ls_komkbmr.
      ls_komkbmr-bukrs = h_rbkpv-bukrs.
      ls_komkbmr-belnr = h_rbkpv-belnr.
      ls_komkbmr-blart = h_rbkpv-blart.
      ls_komkbmr-usnam = h_rbkpv-usnam.
      ls_komkbmr-lifnr = px_first_erssatz-lifnr.     " Partner LF
      ls_komkbmr-lifre = h_rbkpv-lifnr.  ".            Partner RS
      ls_komkbmr-ivtyp = h_rbkpv-ivtyp.
      ls_komkbmr-ident = c_ident_ers.    ".            ERS: 'E'

      CALL FUNCTION 'MRM_HEAD_MESSAGE_CREATE'
        EXPORTING
          if_kappl      = c_kappl_mr
          if_kalsm      = c_kalsm_0004
          is_rbkpv      = h_rbkpv
          is_komkbmr    = ls_komkbmr
          if_update     = lf_update
          if_protocol   = pa_prot
        EXCEPTIONS
*DELETE wegen Fehler bei der erweiterten Programmprüfung
*         no_message_found = 1      " note 420739 MB
          error_message = 2
          OTHERS        = 3.

      IF sy-subrc <> 0.
        IF i_simulation EQ space.
          reprue_rc = 1.
        ELSEIF i_simulation EQ 'X'.
          reprue_rc = 3.
        ENDIF.
        IF sy-msgty = 'A'.   "Ausgabe der A-Meldung als E-Meldung:
          h_mesg-msgty = 'E'.
        ELSE.
          h_mesg-msgty = sy-msgty.
        ENDIF.
        h_mesg-arbgb = sy-msgid.
        h_mesg-txtnr = sy-msgno.
        h_mesg-msgv1 = sy-msgv1.
        h_mesg-msgv2 = sy-msgv2.
        h_mesg-msgv3 = sy-msgv3.
        h_mesg-msgv4 = sy-msgv4.                                      :
        PERFORM aufbereitung_fehlermeldung CHANGING h_mesg.
      ELSEIF sy-subrc EQ 0.
        IF i_simulation EQ 'X'.
          reprue_rc = 2.
        ENDIF.
      ENDIF.
    ENDIF.

  CASE reprue_rc.
    WHEN '0'.
      COMMIT WORK AND WAIT.
      IF sy-subrc NE 0.
        MOVE 'XX' TO h_mesg-arbgb.
        MOVE  '005' TO h_mesg-txtnr.   "Verbuchungsabbruch
        h_mesg-text = TEXT-e05.
        MOVE 1 TO reprue_rc.
      ENDIF.
    WHEN '1'.
      ROLLBACK WORK.
  ENDCASE.

  CASE reprue_rc.
    WHEN '0'.                          "Echtmodus, abrechenbar
* get fi document number from program memory
      CLEAR:   t_accdn, t_logdn.
      REFRESH: t_accdn, t_logdn.
      t_accdn-awtyp = 'RMRP'.
      t_accdn-awref = h_rbkpv-belnr.
      t_accdn-aworg = h_rbkpv-gjahr.
      t_accdn-awsys = h_rbkpv-logsys.
*      t_accdn-awsys = t000-logsys.
      APPEND t_accdn.

* In the ERS-process system can create both ERS and ERS-zero invoices.
* but there should exist only a FI document for ERS-invoice, not for
* ERS-zero invoice.

      IF h_rbkpv-ivtyp = c_ivtyp_ers.
        CALL FUNCTION 'FI_DOCUMENT_NUMBER_GET'
          TABLES
            t_accdn = t_accdn
            t_logdn = t_logdn.
      ENDIF.

* more than one FI document number possible, read document(s) from
* leading company code
      READ TABLE t_logdn WITH KEY bukrs = h_rbkpv-bukrs
                                   logvo = 'MAIN'
                                  gjahr = h_rbkpv-gjahr.

      IF sy-subrc = 0.
        MOVE t_logdn-belnr TO px_first_erssatz-fibel.
      ENDIF.
      MOVE h_rbkpv-belnr  TO px_first_erssatz-rbelnr.
      MOVE h_rbkpv-gjahr  TO px_first_erssatz-rgjahr.
      MOVE 'M8'           TO px_first_erssatz-arbgb.
      IF pi_xrech = 'X'.
        MOVE '327' TO px_first_erssatz-txtnr.   "Rechnung gebucht.
      ELSE.
        MOVE '327' TO px_first_erssatz-txtnr.   "Gutschrift gebucht.
      ENDIF.
*      BREAK-POINT.
*      if H_RBKPV-RMWWR is NOT INITIAL.
      MODIFY ptx_segtab FROM px_first_erssatz
                        TRANSPORTING rbelnr rgjahr arbgb txtnr fibel
                        WHERE" blocknr = pi_akt_blocknr
                       " EBELN = data-EBELN "comment by jyoti on 2308.2024
                       lfbnr = data-lfbnr.
*     endif.
    WHEN '1'.                          "Echtmodus, nicht abrechenbar
      MOVE-CORRESPONDING h_mesg TO px_first_erssatz.
      MOVE space TO px_first_erssatz-abrechenbar.
      MODIFY ptx_segtab FROM px_first_erssatz
                       TRANSPORTING abrechenbar msgty text arbgb
                                    txtnr msgv1 msgv2 msgv3 msgv4
                       WHERE "blocknr = pi_akt_blocknr.
                       "EBELN = data-EBELN"comment by jyoti on 23.08.2024
                        lfbnr = data-lfbnr.
*ENHANCEMENT-POINT anstossen_reprue_01 SPOTS es_rmmr1mrs.
    WHEN '2'.                          "Testmodus, buchbar
    WHEN '3'.                          "Testmodus, nicht buchbar
      MOVE-CORRESPONDING h_mesg TO px_first_erssatz.
      MOVE space TO px_first_erssatz-abrechenbar.
      MODIFY ptx_segtab FROM px_first_erssatz
                       TRANSPORTING abrechenbar msgty text arbgb
                                    txtnr msgv1 msgv2 msgv3 msgv4
                       WHERE "blocknr = pi_akt_blocknr.
*                       EBELN = data-EBELN  "comment by jyoti on 23.08.2024
                        lfbnr = data-lfbnr.
  ENDCASE.
  endif.

  endloop.
 ENDIF.
 ENDIF.
  ENDIF.

ENDFORM.                               "ANSTOSSEN_REPRUE

*---------------------------------------------------------------------*
*       FORM AUFBAU_REPRUE                                            *
*---------------------------------------------------------------------*
*  wird nur im Echtmodus ausgeführt!                                  *
*   Ablauf:                                                           *
*     a) Falls der Satz buchbar ist (PI_ABRECHENBAR = 'X'):           *
*        - Anlegen der WE-Position in der Tabelle PTX_SELWENR, wobei  *
*          die Daten aus der Struktur PI_SEGTAB entnommen werden.     *
*        - Anlegen einer Kopie der zugehörigen Sätze aus PTI_ERW_EKRS *
*          in der Tabelle PTX_EKRS (enthält die EKRS-Sätze, die bei   *
*          erfolgreicher Abrechnung gelöscht werden).                 *
*     b) Falls der Satz nicht buchbar ist: keine Bearbeitung          *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> PTI_ERW_EKRS: Tabelle vom Typ TAB_ERW_EKRS                      *
* <-> PTX_SELWENR: Tabelle der Struktur EK08ERSWE                     *
* <-> PTX_EKRS: Tabelle der Struktur EKRS                             *
* --> PI_SEGTAB: Struktur vom Typ MMERS_SEGTAB                        *
* --> PI_ABRECHBAR: Typ C                                             *
*---------------------------------------------------------------------*
FORM aufbau_reprue TABLES pti_erw_ekrs TYPE tab_erw_ekrs
                          ptx_selwenr STRUCTURE ek08erswe
                          ptx_ekrs STRUCTURE ekrs
                          pti_ekrsdc TYPE typ_tekrsdc
                          ptx_settle_dc STRUCTURE ek08ersdc
                          ptx_ekrsdc_del STRUCTURE ekrsdc
                   USING  pi_segtab TYPE mmers_segtab
                          pi_abrechbar TYPE c.

  DATA: s_settle_dc TYPE ek08ersdc.

  CHECK pi_abrechbar = 'X'.
  IF pi_segtab-xekbz IS INITIAL.
    MOVE-CORRESPONDING pi_segtab TO ptx_selwenr.
    APPEND ptx_selwenr.
  ELSE.
    MOVE-CORRESPONDING pi_segtab TO s_settle_dc.
    APPEND s_settle_dc TO ptx_settle_dc.
  ENDIF.

*ENHANCEMENT-SECTION     aufbau_reprue_01 SPOTS es_rmmr1mrs.
  PERFORM aufbau_zu_loeschende_pos TABLES pti_erw_ekrs
                                          ptx_ekrs
                                   USING pi_segtab-lfbnr
                                         pi_segtab-lfgja
                                         pi_segtab-lfpos
                                         pi_segtab-ebeln
                                         pi_segtab-ebelp.
*END-ENHANCEMENT-SECTION.

  PERFORM ekrsdc_del_fill TABLES pti_ekrsdc
                           ptx_ekrsdc_del
                    USING  pi_segtab.

ENDFORM.                               "AUFBAU_REPRUE


*---------------------------------------------------------------------*
*       FORM AUFBAU_ZU_LOESCHENDE_POS                                 *
*---------------------------------------------------------------------*
*   übernimmt die zu löschenden EKRS-Sätze aus der internen Tabelle   *
*   XEKRS in die interne Tabelle LEKRS:                               *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> pti_xekrs: Tabelle v. Typ TYPE_ERW_EKRS (EKRS erw. um Ref.Beleg)*
* <-> ptx_ekrs: Tabelle der Struktur EKRS (wird sukzessive aufgebaut) *
* --> pi_lfbnr: Referenzbeleg                                         *
* --> pi_lfgja: Geschäftsjahr des Referenzbeleges                     *
* --> pi_lfpos: Position des Referenzbeleges                          *
* --> pi_ebeln: Bestellnummer                                         *
* --> pi_ebelp: Bestellpositionsnummer                                *
*---------------------------------------------------------------------*
FORM aufbau_zu_loeschende_pos TABLES pti_erw_ekrs TYPE tab_erw_ekrs
                                     ptx_ekrs  STRUCTURE ekrs
                              USING pi_lfbnr LIKE ekbe-lfbnr
                                    pi_lfgja LIKE ekbe-lfgja
                                    pi_lfpos LIKE ekbe-lfpos
                                    pi_ebeln LIKE ekbe-ebeln
                                    pi_ebelp LIKE ekbe-ebelp.

  IF NOT pi_lfbnr IS INITIAL.
    LOOP AT pti_erw_ekrs WHERE lfgja = pi_lfgja
                         AND   lfbnr = pi_lfbnr
                         AND   lfpos = pi_lfpos.
      MOVE-CORRESPONDING pti_erw_ekrs TO ptx_ekrs.
*ENHANCEMENT-POINT aufbau_zu_loeschende_pos_01 SPOTS es_rmmr1mrs.
      APPEND ptx_ekrs.
    ENDLOOP.
  ELSE.
*--- PO items without GR-based flag
    LOOP AT pti_erw_ekrs WHERE ebeln = pi_ebeln
                         AND   ebelp = pi_ebelp
                         AND   lfbnr = space.
      MOVE-CORRESPONDING pti_erw_ekrs TO ptx_ekrs.
*ENHANCEMENT-POINT aufbau_zu_loeschende_pos_02 SPOTS es_rmmr1mrs.
      APPEND ptx_ekrs.
    ENDLOOP.
  ENDIF.


ENDFORM.                               "AUFBAU_ZU_LOESCHENDE_POSITION

*---------------------------------------------------------------------*
*       FORM AUFBEREITUNG_BESTELLDATEN                                *
*---------------------------------------------------------------------*
*       Zu den in PTI_BESTAB abgelegten Bestellpositionen werden      *
*       weitere Bestelldaten ermittelt:                               *
*       - Prefetch auf die Bestellkopfdaten                           *
*       - Lesen des Bestellkopfes mit ME_READ_HEADER_SINGLE           *
*       - Lesen der Bestellentw. mit ME_READ_ITEM_INVOICE             *
*       Die zurückgelieferten Daten werden in PTO_SEGTAB abgelegt.    *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> PTI_BESTAB: Tabelle des Typs TAB_BESTAB                         *
* --> PTI_EKKO_KEY: Tabelle der Struktur EKKO_KEY                     *
* <-- PTO_SEGTAB: Tabelle des Typs MMERS_TSEGTAB                      *
*---------------------------------------------------------------------*
FORM aufbereitung_bestelldaten TABLES pti_bestab TYPE tab_bestab
                                      pti_ekko_key STRUCTURE ekko_key
                                      pto_segtab TYPE mmers_tsegtab.

*---- Deklaration lokaler Hilfsfelder und lokaler Strukturen:
  DATA: h_ebeln LIKE ekko-ebeln,       "zuletzt bearbeitete Best.
        ekko_rc TYPE i,                "Returncode
        xreset  TYPE c.

  DATA: BEGIN OF hekko.                "Bestellkopf
      INCLUDE STRUCTURE ekko.
  DATA: END OF hekko.

  CLEAR: h_ebeln, ekko_rc.
  MOVE 'X' TO xreset.

*--- Prefetch auf die Bestellkopfdaten:                            ---*
*----- keine Fehlerbehandlung erforderlich: wenn pti_ekko_key leer ---*
*----- ist, dann ist auch pti_bestab leer und pto_segtab wird eh   ---*
*----- nicht aufgebaut.
  CALL FUNCTION 'ME_EKKO_ARRAY_READ'
*      EXPORTING
*           REFRESH_BUFFER           =
    TABLES
      pti_ekko_keytab          = pti_ekko_key
*     PTO_EKKO                 =
    EXCEPTIONS
      err_no_records_requested = 1
      err_no_records_found     = 2
      OTHERS                   = 3.

  IF sy-subrc EQ 0.
    LOOP AT pti_bestab.
      CLEAR pto_segtab.
      pto_segtab-abrechenbar = 'X'.
      IF pti_bestab-ebeln NE h_ebeln.  "neue Bestellung:
        CLEAR hekko.
        ekko_rc = 0.
        h_ebeln = pti_bestab-ebeln.
        PERFORM lesen_bestellkopf USING    pti_bestab-ebeln
                                  CHANGING hekko
                                           ekko_rc.
      ENDIF.
      MOVE-CORRESPONDING pti_bestab TO pto_segtab.
      IF ekko_rc = 0.
*---- Übernahme Kopfinformationen:
        MOVE hekko-lifnr TO pto_segtab-lifnr.
        MOVE hekko-zterm TO pto_segtab-zterm.
        MOVE hekko-wkurs TO pto_segtab-wkurs.
        MOVE hekko-lifre TO pto_segtab-lifre.
        MOVE hekko-kufix TO pto_segtab-kufix.
        DATA: lv_active TYPE boolean.
        DATA:
*      LV_LONGNUM TYPE MMERS_SEGTAB-LONGNUM,
              lv_ebeln TYPE mmers_segtab-ebeln.
*SPIIN active?
        lv_active = /sappspro/cl_numbers=>is_active( ).

        IF lv_active = 'X'.

*convert EBELN to longnumber.
          lv_ebeln = hekko-ebeln.
          TRY.
*    LV_LONGNUM = /SAPPSPRO/CL_NUMBERS=>LOOKUP( IV_EBELN = LV_EBELN ).
*      CATCH /SAPPSPRO/CX_NUMBER_NOT_FOUND.
          ENDTRY.
*MOVE LV_LONGNUM TO PTO_SEGTAB-LONGNUM.
          CLEAR:
*       LV_LONGNUM,
                 lv_ebeln.
        ENDIF.

*---- Ermittlung der kumulierten Bestellentwicklungsdaten; weiterer ---*
*---- Aufbau des aktuellen Satzes in PTO_SEGTAB:                    ---*
        PERFORM lesen_bestellpos_daten USING  hekko
                                              pti_bestab-ebelp
                                              pti_bestab-lfbnr
                                              pti_bestab-lfpos
                                              pti_bestab-lfgja
                                              sy-datlo
                                              xreset
                                     CHANGING pto_segtab.
*ENHANCEMENT-POINT aufbereitung_bestelldaten_01 SPOTS es_rmmr1mrs.
      ELSE.                            "ekko_rc <> 0:
*----- kein Bestellkopf gefunden; Position nicht ERS-buchbar: --------*
        IF cl_ops_switch_check=>mm_sfws_tm( ) EQ abap_on.

          pto_segtab-abrechenbar = space.
          pto_segtab-arbgb = 'XX'.
          pto_segtab-txtnr = '001'.      "TM document nicht vorhanden
          pto_segtab-text  = TEXT-e07.
        ELSE.
          pto_segtab-abrechenbar = space.
          pto_segtab-arbgb = 'XX'.
          pto_segtab-txtnr = '001'.      "Bestellung nicht vorhanden
          pto_segtab-text  = TEXT-e01.
        ENDIF.
      ENDIF.
      APPEND pto_segtab.
    ENDLOOP.
  ENDIF.


ENDFORM.                               "AUFBEREITUNG_BESTELLDATEN

*---------------------------------------------------------------------*
*       FORM AUFBEREITUNG_FEHLERMELDUNG                               *
*---------------------------------------------------------------------*
*  ermittelt den Text zu einer von einem Funktionsbaustein zurückge-  *
*  lieferten Fehlermeldung                                            *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-> px_mesg: Struktur MESG; enthält die aufzubereitende Fehlermel-  *
*              dung; im Fehlerfall wird eine Default-Meldung abgelegt *
*---------------------------------------------------------------------*
FORM aufbereitung_fehlermeldung CHANGING i_mesg STRUCTURE mesg.

  DATA: h_mtext LIKE sy-lisel,
        h_msgno LIKE sy-msgno.

  MOVE i_mesg-txtnr TO h_msgno.

  CALL FUNCTION 'RPY_MESSAGE_COMPOSE'
    EXPORTING
      message_id        = i_mesg-arbgb
      message_number    = h_msgno
      message_var1      = i_mesg-msgv1
      message_var2      = i_mesg-msgv2
      message_var3      = i_mesg-msgv3
      message_var4      = i_mesg-msgv4
    IMPORTING
      message_text      = h_mtext
    EXCEPTIONS
      message_not_found = 1
      OTHERS            = 2.

  IF sy-subrc = 0.
    MOVE h_mtext(73) TO i_mesg-text.
  ELSE.
    CALL FUNCTION 'RPY_MESSAGE_COMPOSE'
      EXPORTING
        message_id        = sy-msgid
        message_number    = sy-msgno
        message_var1      = sy-msgv1
        message_var2      = sy-msgv2
        message_var3      = sy-msgv3
        message_var4      = sy-msgv4
      IMPORTING
        message_text      = h_mtext
      EXCEPTIONS
        message_not_found = 1
        OTHERS            = 2.
    IF sy-subrc EQ 0.
      i_mesg-text = h_mtext(73).
    ELSE.
* Ooops, no text!.
*   message x062 with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4. ?
      CLEAR i_mesg-text .
    ENDIF.
  ENDIF.

ENDFORM.                               "AUFBEREITUNG_FEHLERMELDUNG
*---------------------------------------------------------------------*
*       FORM AUFRUF_REPRUE                                            *
*---------------------------------------------------------------------*
*  wird nur im Echtmodus ausgeführt.                                  *
*     Aufruf der Schnittstelle zur Log. Reprü                         *
*                                                                     *
* Bemerkung:                                                          *
* Die an den Baustein übergebenen Felder aus der Struktur PI_SEGTAB   *
* sind für alle Sätze in der globalen Tabelle SEGTAB mit gleicher     *
* Blocknummer identisch, da es sich um Splittungskriterien handelt!   *
* Wenn der Kurs nicht fixiert ist, dann wird Kurs 0.0000 übergeben.   *
* In dem Fall wird der aktuelle Tageskurs in MRM_INVOICE_CREATE ermit-*
* telt.                                                               *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> PTI_SELWENR: Tabelle der Struktur EK08ERSWE                     *
* --> PI_SEGTAB: Struktur vom Typ MMERS_SEGTAB; enthält ersten Satz   *
*                des aktuellen Blockes                                *
* <-- PE_RBKPV: Eingangsrechnungsbeleg                                *
* <-- PE_MESG: Struktur MESG; enthält im Fehlerfall eine Meldung      *
* <-- PE_RC: Returncode                                               *
*---------------------------------------------------------------------*
FORM aufruf_reprue TABLES  pti_selwenr STRUCTURE ek08erswe
                            pti_settle_dc STRUCTURE ek08ersdc
                   USING    pi_segtab TYPE mmers_segtab
                            i_simulation LIKE boole-boole
                   CHANGING po_rbkpv  TYPE mrm_rbkpv
                            po_mesg STRUCTURE mesg
                            po_rc TYPE i.

  DATA: h_wkurs LIKE ekko-wkurs.

  DATA ls_isi_mrm_invoice_verif_e TYPE
                            isi_mrm_invoice_verification_e. "IS2ERP

  IF pi_segtab-kufix = 'X'.            "Kurs fixiert
    MOVE pi_segtab-wkurs TO h_wkurs.
  ELSE.
    CLEAR h_wkurs.
  ENDIF.


*************************************************
* IMPORT budat1 FROM MEMORY ID 'BUDAT '.
*  BREAK primusabap.
*  SORT pti_selwenr[] ."DESCENDING.
*  DELETE ADJACENT DUPLICATES FROM pti_selwenr[] COMPARING ALL FIELDS.
*  SORT pti_settle_dc[] ."DESCENDING.
*  DELETE ADJACENT DUPLICATES FROM pti_settle_dc[] COMPARING ALL FIELDS.
TYPES: BEGIN OF t_sd,
         ebeln LIKE ekko-ebeln,
         lfbnr LIKE ekbe-lfbnr,
       END OF t_sd.

  DATA : tab_SD TYPE TABLE OF t_SD,
         WA_SD  TYPE T_SD.


  DATA : gv_budat TYPE rbkp-budat.
  DATA : gv_lfbnr TYPE ekbe-lfbnr.
  DATA : gv_EBELN TYPE ekko-ebeln.
  gv_budat = budat1-low .
  gv_lfbnr = pi_segtab-lfbnr.
  EXPORT gv_budat TO MEMORY ID 'BUDAT'.
  EXPORT gv_lfbnr TO MEMORY ID 'LFBNR'.
*  BREAK PRIMUSABAP.
   gv_ebeln = pi_segtab-ebeln .
  EXPORT gv_ebeln TO MEMORY ID 'EBELN'.

*ENHANCEMENT-POINT aufruf_reprue_01 SPOTS es_rmmr1mrs.
*BREAK-POINT.
*ENHANCEMENT-POINT aufruf_reprue_02 SPOTS es_rmmr1mrs.


    CALL FUNCTION 'MRM_INVOICE_VERIFICATION_ERS'
      EXPORTING
        i_lifnr        = pi_segtab-lifnr
        i_bukrs        = pi_segtab-bukrs
        i_lifre        = pi_segtab-lifre
        i_waers        = pi_segtab-waers
        i_wkurs        = h_wkurs
        i_zterm        = pi_segtab-zterm
        i_xrech        = pi_segtab-xrech
        i_retpo        = pi_segtab-retpo
        i_simulation   = i_simulation
        is_enhancement = ls_isi_mrm_invoice_verif_e
        i_xtm          = pa_tm
      IMPORTING
        e_rbkpv        = po_rbkpv
      TABLES
        ti_selwenr     =  PTI_SELWENR
        ti_settle_dc   = PTI_SETTLE_DC  "pti_settle_dc_1                " PTI_SETTLE_DC
      EXCEPTIONS
        error_message  = 1
        OTHERS         = 2.

********************added by sagar dev****************
    LOOP AT PTI_SELWENR.
        WA_sd-ebeln = PTI_SELWENR-ebeln.
        wa_Sd-lfbnr = PTI_SELWENR-lfbnr.
        APPEND wa_Sd to tab_sd.
        clear: wa_sd.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM tab_sd COMPARING all FIELDS.
    EXPORT tab_sd TO MEMORY ID 'SAGAR'.

    REFRESH PTI_SELWENR.
    REFRESH PTI_SETTLE_DC.

    IF sy-subrc NE 0.
      IF i_simulation EQ space.
        MOVE 1 TO po_rc.
      ELSEIF i_simulation EQ 'X'.
        MOVE 3 TO po_rc.
      ENDIF.
      CLEAR: po_rbkpv.
      IF sy-msgty = 'A'.   "Ausgabe der A-Meldung als E-Meldung:
        MOVE 'E' TO po_mesg-msgty.
      ELSE.
        MOVE sy-msgty TO po_mesg-msgty.
      ENDIF.
      MOVE sy-msgid TO po_mesg-arbgb.
      MOVE sy-msgno TO po_mesg-txtnr.
      MOVE sy-msgv1 TO po_mesg-msgv1.
      MOVE sy-msgv2 TO po_mesg-msgv2.
      MOVE sy-msgv3 TO po_mesg-msgv3.
      MOVE sy-msgv4 TO po_mesg-msgv4.
      PERFORM aufbereitung_fehlermeldung CHANGING po_mesg.
    ELSEIF sy-subrc EQ 0.
      IF i_simulation EQ 'X'.
        MOVE 2 TO po_rc.
      ENDIF.
    ENDIF.
*    MOVE-CORRESPONDING pti_selwenr_1 TO pti_selwenr_NEW.
*    MOVE-CORRESPONDING pti_settle_dc_1 TO pti_settle_dc_NEW.
*    endon.
*    CLEAR :data,gs_pti_selwenr_1.
*    REFRESH pti_selwenr_1 .
*    endloop.

ENDFORM.                               "AUFRUF_REPRUE
*eject
*---------------------------------------------------------------------*
*       FORM BEARBEITUNG_DATEN                                        *
*---------------------------------------------------------------------*
*       Alle zu bearbeitenden Positionen sind in PTX_SEGTAB abgelegt. *
*       Folgende Schritte werden durchlaufen:                         *
*       2. Aufruf des Funktionsbausteins MRM_SPLIT_DATA_ERS. Dieser   *
*          Baustein liefert die Tabelle modifiziert zurück. Alle Po-  *
*          sitionen, die gemeinsam abgerechnet werden können haben    *
*          dann eine identische Blocknummer.                          *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-> PTX_SEGTAB: Tabelle vom Typ MMERS_TSEGTAB                       *
* --> PI_ERSBA: gewählte Belegabgrenzung                              *
*---------------------------------------------------------------------*
FORM bearbeitung_daten TABLES ptx_segtab TYPE mmers_tsegtab
                       USING pi_ersba LIKE rm08e-ersba.

  CALL FUNCTION 'MRM_SPLIT_DATA_ERS'
    EXPORTING
      i_ersba  = pi_ersba
    TABLES
      t_segtab = ptx_segtab
    EXCEPTIONS
      OTHERS   = 0. "Baustein löst keine exceptions aus!

ENDFORM.                               "BEARBEITUNG_DATEN
*eject
*---------------------------------------------------------------------*
*       FORM CHECKBOX_FILL                                            *
*---------------------------------------------------------------------*
* Das Feld Box in der Tabelle SEGTAB mit - oder Space füllen          *
* Ist SEGTAB-BOX = - dann wird der Markierbox in der Protokollzeile   *
* nicht angezeigt.                                                    *
* Im Testmodus Segtab-Box wird gleich Space gesetzt falls die         *
* Positionien nicht buchbar sind und sollen aus dem ERS               *
* ausgeschlossen werden können                                        *
*---------------------------------------------------------------------*
FORM checkbox_fill TABLES ptx_segtab TYPE mmers_tsegtab.

  LOOP AT ptx_segtab.
    ptx_segtab-box = '-'.              " checkbox not shown
    MODIFY ptx_segtab.
  ENDLOOP.

*-- bei nicht abrechenbaren Positionen Markierbox einblenden um die --*
*-- Position aus ERS auszuschliessen ---------------------------------*
*-- bei Leergut UPVOR = 3 hat nur die Hauptposition Markierbox, die --*
*-- Unterpositionen nicht                                            -*
  CHECK b_xtest = 'X'.
  LOOP AT ptx_segtab WHERE abrechenbar = space.
    IF NOT ptx_segtab-upvor IS INITIAL AND       " Unterpos. vorhanden
           ptx_segtab-uebpo IS INITIAL.
      CLEAR ptx_segtab-box.
      CLEAR ptx_segtab-ZZCHECK_B. "added by primus jyoti on28.03.2024
      MODIFY ptx_segtab.
    ELSEIF ptx_segtab-upvor IS INITIAL AND       " normalle Position
           ptx_segtab-uptyp IS INITIAL AND       " oder Unterpos. bei
           ptx_segtab-uebpo IS INITIAL." Sammelartikel
      CLEAR ptx_segtab-box.
      CLEAR ptx_segtab-ZZCHECK_B. "added by primus jyoti on28.03.2024
      MODIFY ptx_segtab.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "checkbox_fill
*eject
*---------------------------------------------------------------------*
*       FORM EKRS_LOESCHEN                                            *
*---------------------------------------------------------------------*
* Zu den vom Anwender als zu löschen markierten Artikel (stehen in    *
* der Tabelle PTI_SEGTAB) werden die in der internen Tabelle          *
* PTI_ERW_EKRS abgelegten EKRS-Sätze ermittelt und in einer internen  *
* Tabelle gesammelt. Anschließend werden sie von der Datenbank ge-    *
* löscht.                                                             *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> PTI_SEGTAB: Tabelle vom Typ MMERS_TSEGTAB                       *
* --> PTI_ERW_EKRS: Tabelle vom Typ TAB_ERW_EKRS                      *
*---------------------------------------------------------------------*
FORM ekrs_loeschen TABLES pti_segtab TYPE mmers_tsegtab
                          pti_erw_ekrs TYPE tab_erw_ekrs
                          pti_ekrsdc TYPE typ_tekrsdc.

*------- Tabelle mit den zu löschenden EKRS-Sätzen -------------------*
  DATA: BEGIN OF lekrs OCCURS 1.
      INCLUDE STRUCTURE ekrs.
  DATA: END OF lekrs.

*-------internal table containing EKRSDC entries to delete------------*
  DATA: BEGIN OF tab_ekrsdc_del OCCURS 1.
      INCLUDE STRUCTURE ekrsdc.
  DATA: END OF tab_ekrsdc_del.
  DATA: s_ekrsdc_del TYPE ekrsdc.

  REFRESH: lekrs, tab_ekrsdc_del.
  CLEAR:   lekrs, tab_ekrsdc_del.

  LOOP AT pti_segtab WHERE xdele = 'X'
                      AND xekbz IS INITIAL.
    PERFORM aufbau_zu_loeschende_pos TABLES pti_erw_ekrs
                                            lekrs
                                     USING pti_segtab-lfbnr
                                           pti_segtab-lfgja
                                           pti_segtab-lfpos
                                           pti_segtab-ebeln
                                           pti_segtab-ebelp.

  ENDLOOP.
  LOOP AT pti_segtab WHERE xdele = 'X'
                      AND xekbz = 'X'.
    PERFORM ekrsdc_del_fill TABLES pti_ekrsdc
                            tab_ekrsdc_del
                     USING  pti_segtab.

  ENDLOOP.
  READ TABLE lekrs INDEX 1.
  IF sy-subrc = 0.
    PERFORM fortschreibung_ekrs TABLES lekrs.
  ENDIF.
  READ TABLE tab_ekrsdc INTO s_ekrsdc_del INDEX 1.
  IF sy-subrc = 0.
    PERFORM ekrsdc_update TABLES tab_ekrsdc_del.
  ENDIF.
  IF NOT lekrs[] IS INITIAL OR NOT tab_ekrsdc_del[] IS INITIAL.
    COMMIT WORK AND WAIT.
  ENDIF.

ENDFORM.                               "EKRS_LOESCHEN
*eject
*---------------------------------------------------------------------*
*       FORM ERMITTLUNG_REFERENZ_BELEGE                               *
*---------------------------------------------------------------------*
*       Zu den in der internen Tabelle PTX_EKRS abgelegten EKRS-Sätzen*
*       werden die Referenzbelege aus der Bestellentwicklung ermit-   *
*       telt. Gleichzeitig wird auch das Selektionskriterium 'Werk'   *
*       prüft.                                                        *
*       Die Tabelle PTI_EKBEL wird nur für den Prefetch benötigt.     *
*  zu beachten: Wenn zu einem EKRS-Satz der Referenzbeleg nicht ermit-*
*               telt werden kann, dann bleiben die entsprechenden Fel-*
*               der in PTX_EKRS leer. Eine entsprechende Fehlermel-   *
*               dung wird erst bei der Aufbereitung der Bestelldaten  *
*               ausgegeben.                                           *
*  zu beachten: Wenn als Selektionskriterium ein Buchungszeitraum an- *
*               gegeben wurde, dann wird wie bisher zu dem gefundenen *
*               EKRS-Satz der Referenzbeleg ermittelt. Zu diesem Re-  *
*               ferenzbeleg müssen dann alle Folgebelege ermittelt    *
*               und in die Tabelle PTX_EKRS übernommen werden auch    *
*               wenn ihr Buchungsdatum nicht in den Buchungszeitraum  *
*               paßt. Sie werden nämlich bei der Abrechnung mit be-   *
*               rücksichtigt (da ME_READ_ITEM_INVOICE kumulierte Wer- *
*               zu einem Referenzbeleg zurückliefert).                *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-> PTX_EKRS: Tabelle vom Typ TAB_ERW_EKRS                          *
* --> PTI_EKBEL: Tabelle mit Struktur EKBEL                           *
*---------------------------------------------------------------------*
FORM ermittlung_referenz_belege TABLES ptx_ekrs TYPE tab_erw_ekrs
                                       pti_ekbel STRUCTURE ekbel.

*---- Deklaration lokaler Hilfsfelder und lokaler Strukturen:
  DATA: h_ebeln    LIKE  ekko-ebeln,
        h_ebelp    LIKE  ekpo-ebelp,
        idx        LIKE  sy-tabix,
        save_lfbnr LIKE  ekbe-lfbnr,
        save_lfpos LIKE  ekbe-lfpos,
        save_lfgja LIKE  ekbe-lfgja.

  DATA: t_ekbe         LIKE ekbe         OCCURS 0 WITH HEADER LINE,
        h_tab_erw_ekrs TYPE tab_erw_ekrs          WITH HEADER LINE.

*--- Lesen der Bestellentwicklung zu den in XEKBEL abgelegten Einkaufs-
*--- belegköpfen und -positionen in lokales Gedächtnis:
  CALL FUNCTION 'MMPUR_EKBE_ARRAY_READ'
*      exporting
*           PI_REFRESH_BUFFER    =
    TABLES
      pti_ekbe_key         = pti_ekbel
*     PTO_EKBE             =
    EXCEPTIONS
      no_records_requested = 1
      OTHERS               = 2.

  sy-subrc = 0.
*  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.

  CLEAR:   h_ebeln, h_ebelp, idx.
  REFRESH: h_tab_erw_ekrs.

  LOOP AT ptx_ekrs.
    idx = sy-tabix.

*ENHANCEMENT-POINT ermittlung_referenz_belege_01 SPOTS es_rmmr1mrs.
    IF ptx_ekrs-ebeln NE h_ebeln OR
       ptx_ekrs-ebelp NE h_ebelp.
      REFRESH t_ekbe.
      CLEAR t_ekbe.
      MOVE ptx_ekrs-ebeln TO h_ebeln.
      MOVE ptx_ekrs-ebelp TO h_ebelp.
*---- Lesen der Bestellentwicklung zur akt. Bestellung:
      CALL FUNCTION 'MMPUR_EKBE_READ_EBELN_EBELP'
        EXPORTING
          pi_ebeln             = ptx_ekrs-ebeln
          pi_ebelp             = ptx_ekrs-ebelp
*         PI_BYPASSING_BUFFER  =
*         PI_REFRESH_BUFFER    =
        TABLES
          pto_ekbe_po          = t_ekbe
        EXCEPTIONS
          no_records_requested = 1
          OTHERS               = 2.

      IF sy-subrc NE 0.
        REFRESH t_ekbe.
      ENDIF.
    ENDIF.

* Ermittlung Org-WE
    READ TABLE t_ekbe WITH KEY  ebeln = ptx_ekrs-ebeln
                                ebelp = ptx_ekrs-ebelp
                                gjahr = ptx_ekrs-gjahr
                                belnr = ptx_ekrs-belnr
                                buzei = ptx_ekrs-buzei.

    IF sy-subrc = 0.          "Satz gefunden; Werte stehen in t_ekbe
*---- Org-WE schon in Löschtabelle drin?
      READ TABLE h_tab_erw_ekrs WITH KEY lfbnr = t_ekbe-lfbnr
                                         lfpos = t_ekbe-lfpos
                                         lfgja = t_ekbe-lfgja
                                         ebeln = t_ekbe-ebeln
                                         ebelp = t_ekbe-ebelp.
      IF sy-subrc EQ 0.
        DELETE ptx_ekrs INDEX idx.
      ELSE.
        MOVE t_ekbe-lfbnr TO save_lfbnr.
        MOVE t_ekbe-lfpos TO save_lfpos.
        MOVE t_ekbe-lfgja TO save_lfgja.

        LOOP AT t_ekbe WHERE lfbnr = save_lfbnr
                         AND lfpos = save_lfpos
                         AND lfgja = save_lfgja
                         AND vgabe = '1'.    "Wareneingang

*ENHANCEMENT-POINT ermittlung_referenz_belege_02 SPOTS es_rmmr1mrs.
          MOVE-CORRESPONDING t_ekbe TO h_tab_erw_ekrs.
          h_tab_erw_ekrs-lifnr = ptx_ekrs-lifnr.
          h_tab_erw_ekrs-bukrs = ptx_ekrs-bukrs.
          h_tab_erw_ekrs-lfbnr = save_lfbnr.
          h_tab_erw_ekrs-lfpos = save_lfpos.
          h_tab_erw_ekrs-lfgja = save_lfgja.
          COLLECT h_tab_erw_ekrs.
        ENDLOOP.                       " t_ekbe             "977217
      ENDIF.
    ENDIF.
  ENDLOOP.                             " ptx_ekrs

  REFRESH: ptx_ekrs.
  ptx_ekrs[] = h_tab_erw_ekrs[].

ENDFORM.                               "ERMITTLUNG_REFERENZ_BELEGE
*eject
*---------------------------------------------------------------------*
*       FORM EVENTTAB_BUILD                                           *
*---------------------------------------------------------------------*
* Dem ALV-Baustein bekannt geben, daß es zwei Routinen für die        *
* Ausgabe der Listüberschriften:                                      *
* TOP_OF_LIST Überschrift wird einmal am Anfang der Liste ausgegeben  *
*---------------------------------------------------------------------*
FORM eventtab_build USING it_events TYPE slis_t_event.

  DATA: l_event TYPE slis_alv_event.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type = 0
    IMPORTING
      et_events   = it_events.

  READ TABLE it_events WITH KEY name =  slis_ev_top_of_list
                           INTO l_event.
  IF sy-subrc = 0.
    MOVE c_top_of_list TO l_event-form.
    APPEND l_event TO it_events.
  ENDIF.
ENDFORM.                    "eventtab_build
*eject
*---------------------------------------------------------------------*
*       FORM FIELD_CATALOG_BUILD                                      *
*---------------------------------------------------------------------*
*   FELDKATALOG FÜR AUSGABE DER LISTE AUFBAUEN                        *
*   HIER WIRD DEM ALV-BAUSTEIN BEKANNT GEGEBEN WIE DIE SPALTEN DER    *
*   LISTE AUSSEHEN SOLLEN                                             *
*---------------------------------------------------------------------*
FORM field_catalog_build TABLES
                            t_fieldcat TYPE slis_t_fieldcat_alv.

*-- Fieldcatalog create automatically --------------------------------*

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = c_repid
      i_internal_tabname = c_segtab
      i_structure_name   = 'ERSALV'
    CHANGING
      ct_fieldcat        = t_fieldcat[].
*************COMMENTED BY RANI E.*****************
*  LOOP AT t_fieldcat.
*    CASE t_fieldcat-fieldname.
*
*      WHEN 'ABRECHENBAR'.
*        t_fieldcat-seltext_l = text-004.
*        t_fieldcat-seltext_m = text-006.
*        t_fieldcat-seltext_s = text-006.
*        t_fieldcat-just      = 'R'.
*
*      WHEN 'TEXT'.
*        t_fieldcat-seltext_l = text-007.
*        t_fieldcat-seltext_m = text-008.
*        t_fieldcat-seltext_s = text-008.
*        t_fieldcat-reptext_ddic = text-008.
*
*      WHEN 'FIBEL'.
*        t_fieldcat-seltext_l = text-009.
*        t_fieldcat-seltext_m = text-010.
*        t_fieldcat-seltext_s = text-010.
*        t_fieldcat-reptext_ddic = text-010.
*        t_fieldcat-hotspot = 'X'.
*
*      WHEN 'RBELNR'.
*        t_fieldcat-hotspot = 'X'.
*
*      WHEN 'LFBNR'.
*        t_fieldcat-hotspot = 'X'.
*
*      WHEN 'EBELN'.
*        t_fieldcat-hotspot = 'X'.
*
*      WHEN 'ZZBLDAT'.
*        t_fieldcat-seltext_m = 'Document Date'.
*
*
*
*    ENDCASE.
*    MODIFY t_fieldcat.
*
*  ENDLOOP.
**************************COMMENT ENDED BY RANI E.***********************

*******************ADDED BY RANI E.*******************************

  IF sy-tcode = 'ZMRRL'.




    LOOP AT t_fieldcat.
      CASE t_fieldcat-fieldname.

*       WHEN 'ABRECHENBAR'.
*          t_fieldcat-seltext_l = TEXT-004.
*          t_fieldcat-seltext_m = TEXT-006.
*          t_fieldcat-seltext_s = TEXT-006.
*          t_fieldcat-just      = 'R'.

*        WHEN 'TEXT'.
*          t_fieldcat-seltext_l = TEXT-007.
*          t_fieldcat-seltext_m = TEXT-008.
*          t_fieldcat-seltext_s = TEXT-008.
*          t_fieldcat-reptext_ddic = TEXT-008.

*        WHEN 'FIBEL'.
*          t_fieldcat-seltext_l = TEXT-009.
*          t_fieldcat-seltext_m = TEXT-010.
*          t_fieldcat-seltext_s = TEXT-010.
*          t_fieldcat-reptext_ddic = TEXT-010.
*          t_fieldcat-hotspot = 'X'.

*        WHEN 'ZSELECT'.
**          T_FIELDCAT-HOTSPOT = 'X'.
*          T_FIELDCAT-SELTEXT_L = 'Select'.   "ADDED BY PRIMUS JYOTI ON 13.02.2024
*          T_FIELDCAT-SELTEXT_M = 'Select'.
*          T_FIELDCAT-SELTEXT_S = 'Select'.
*          T_FIELDCAT-checkbox = 'X'.
*          T_FIELDCAT-edit         = 'X'.
*          T_FIELDCAT-COL_POS   = 33.

        WHEN 'RBELNR'.
          t_fieldcat-hotspot = 'X'.
        WHEN 'XBLNR'.
          t_fieldcat-hotspot = 'X'.
          t_fieldcat-seltext_l = 'Invoice No'.   "ADDED BY PRIMUS JYOTI ON 13.02.2024
          t_fieldcat-seltext_m = 'Invoice No'.
          t_fieldcat-seltext_s = 'Invoice No'.

        WHEN 'LFBNR'.
          t_fieldcat-hotspot = 'X'.
          t_fieldcat-seltext_l = 'MIGO Doc No'.   "ADDED BY PRIMUS JYOTI ON 13.02.2024
          t_fieldcat-seltext_m = 'MIGO Doc No'.
          t_fieldcat-seltext_s = 'MIGO Doc No'.

        WHEN 'XEBKZ'.
          t_fieldcat-hotspot = 'X'.
          t_fieldcat-seltext_l = 'Delivery Cost Ind'.   "ADDED BY PRIMUS JYOTI ON 13.02.2024
          t_fieldcat-seltext_m = 'Delivery Cost Ind.'.
          t_fieldcat-seltext_s = 'Delivery Cost Ind.'.

        WHEN 'EBELN'.
          t_fieldcat-hotspot = 'X'.

        WHEN 'ZZMENGE'."ADDED BY PRIMUS JYOTI ON 13.02.2024
          t_fieldcat-seltext_l = 'GRN Qty'.
          t_fieldcat-seltext_m = 'GRN Qty'.
          t_fieldcat-seltext_s = 'GRN Qty'.
          t_fieldcat-col_pos   = 26.

        WHEN 'ZZBLDAT'.
          t_fieldcat-seltext_l = 'Document Date'.
          t_fieldcat-seltext_m = 'Document Date'.
          t_fieldcat-seltext_s = 'Document Date'.
          t_fieldcat-col_pos   = 18.

        WHEN 'ZZBWART'.
          t_fieldcat-seltext_l = 'Movement Type (Inventory Management)'.
          t_fieldcat-seltext_m = 'Movement Type (Inventory Management)'.
          t_fieldcat-seltext_s = 'Movement Type (Inventory Management)'.
          t_fieldcat-col_pos   = 19.

        WHEN 'ZZLBLNI'.
          t_fieldcat-seltext_l = 'Entry Sheet Number'.
          t_fieldcat-seltext_m = 'Entry Sheet Number'.
          t_fieldcat-seltext_s = 'Entry Sheet Number'.
          t_fieldcat-col_pos   = 20.

        WHEN 'ZZLIFNR'.
          t_fieldcat-seltext_l = 'Vendor Account Number'.
          t_fieldcat-seltext_m = 'Vendor Account Number'.
          t_fieldcat-seltext_s = 'Vendor Account Number'.
          t_fieldcat-col_pos   = 21.

        WHEN 'ZZNAME1'.
          t_fieldcat-seltext_l = 'Vendor Name'.
          t_fieldcat-seltext_m = 'Vendor Name'.
          t_fieldcat-seltext_s = 'Vendor Name'.
          t_fieldcat-col_pos   = 22.

        WHEN 'ZZQUANTITY'.
          t_fieldcat-seltext_l = 'PO Quantity'.
          t_fieldcat-seltext_m = 'PO Quantity'.
          t_fieldcat-seltext_s = 'PO Quantity'.
          t_fieldcat-col_pos   = 23.

        WHEN 'ZZMEINS'.
          t_fieldcat-seltext_l = 'UOM'.
          t_fieldcat-seltext_m = 'UOM'.
          t_fieldcat-seltext_s = 'UOM'.
          t_fieldcat-col_pos   = 24.

        WHEN 'ZZBASIC_AM'.                                         "'ZZDMBTR'.
          t_fieldcat-seltext_l = 'Basic Amount'.
          t_fieldcat-seltext_m = 'Basic Amount'.
          t_fieldcat-seltext_s = 'Basic Amount'.
          t_fieldcat-col_pos   = 25.

        WHEN 'ZZGROSS_AM'.                                         "'ZZBRTWR'.
          t_fieldcat-seltext_l = 'Gross Amount'.
          t_fieldcat-seltext_m = 'Gross Amount'.
          t_fieldcat-seltext_s = 'Gross Amount'.
          t_fieldcat-col_pos   = 26.


*        WHEN 'ZZMWSKZ'.
*          t_fieldcat-seltext_l = 'Tax Code'.
*          t_fieldcat-seltext_m = 'Tax Code'.
*          t_fieldcat-seltext_s = 'Tax Code'.
*          t_fieldcat-col_pos   = 30.

        WHEN 'ZZCGST_N'.
          t_fieldcat-seltext_l = 'CGST Amount'.
          t_fieldcat-seltext_m = 'CGST Amount'.
          t_fieldcat-seltext_s = 'CGST Amount'.
          t_fieldcat-col_pos   = 27.

        WHEN 'ZZSGST_N'.
          t_fieldcat-seltext_l = 'SGST Amount'.
          t_fieldcat-seltext_m = 'SGST Amount'.
          t_fieldcat-seltext_s = 'SGST Amount'.
          t_fieldcat-col_pos   = 28.

        WHEN 'ZZIGST_N'.
          t_fieldcat-seltext_l = 'IGST Amount'.
          t_fieldcat-seltext_m = 'IGST Amount'.
          t_fieldcat-seltext_s = 'IGST Amount'.
          t_fieldcat-col_pos   = 29.

        WHEN 'ZZWITHT'.
          t_fieldcat-seltext_l = 'TDS'.
          t_fieldcat-seltext_m = 'TDS'.
          t_fieldcat-seltext_s = 'TDS'.
          t_fieldcat-edit      = 'X'.
          t_fieldcat-col_pos   = 30.

        WHEN 'ZZTEXT40'.
          t_fieldcat-seltext_l = 'Name'.
          t_fieldcat-seltext_m = 'Name'.
          t_fieldcat-seltext_s = 'Name'.
          t_fieldcat-col_pos   = 31.

        WHEN 'FIBEL'.
          t_fieldcat-seltext_l = 'FI Document No'.
          t_fieldcat-seltext_m = 'FI Document No'.
          t_fieldcat-seltext_s = 'FI Document No'.
          t_fieldcat-col_pos   = 32.


        WHEN 'ZZCHECK_B'.
          t_fieldcat-seltext_l = 'Check Box'.
          t_fieldcat-seltext_m = 'Check Box'.
          t_fieldcat-seltext_s = 'Check Box'.
          t_fieldcat-input     = 'X'.
          t_fieldcat-edit      = 'X'.
          t_fieldcat-checkbox = 'X'.
*            t_fieldcat-col_pos   = 1.




      ENDCASE.
      MODIFY t_fieldcat.

    ENDLOOP.
  ENDIF.
**************************ENDED BY RANI E.**************************

***********************ADDEED BY PRIMUS JYOTI ON 15.01.2024***************
  LOOP AT t_fieldcat WHERE fieldname = 'BELNR'
                     OR    fieldname = 'GJAHR'
                     OR    fieldname = 'BUZEI'
                     OR    fieldname = 'ZZLBLNI'
                     OR    fieldname = 'LONGNUM'
                     OR    fieldname = 'FRBNR'
                     OR     fieldname = 'ZZKAWRT'.
    DELETE t_fieldcat.
  ENDLOOP.
************************************************************************
ENDFORM.                    "field_catalog_build
*eject
*---------------------------------------------------------------------*
*       FORM FORTSCHREIBUNG_EKRS                                      *
*---------------------------------------------------------------------*
*  Fortschreibung (exakt: Löschen) von EKRS-Sätzen                    *
*  Bemerkung: das notwendige COMMIT muß nach Aufruf dieser Form-Rou-  *
*             tine durchgeführt werden.                               *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> pti_ekrs: Tabelle mit den zu löschenden Sätzen                  *
*---------------------------------------------------------------------*
FORM fortschreibung_ekrs TABLES pti_ekrs STRUCTURE ekrs.

  CALL FUNCTION 'ME_UPDATE_EKRS' IN UPDATE TASK
    EXPORTING
      i_delete = 'X'
    TABLES
      t_ekrs   = pti_ekrs.

ENDFORM.                               "FORTSCHREIBUNG_EKRS
*eject
*---------------------------------------------------------------------*
*       FORM INITIALISIERUNG_REPRUE                                   *
*---------------------------------------------------------------------*
*     - Initialisieren von Variablen und internen Tabellen;           *
*     - Speichern des ersten Satzes mit der aktuellen Blocknummer     *
* Bemerkung: - alle Sätze mit gleicher Blocknummer haben in SEGTAB in *
*              dem Feld ABRECHENBAR den gleichen Wert!                *
*            - B_XTEST ist ein Report-Parameter !                     *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-- PTO_EKRS: Tabelle der Struktur EKRS                             *
* <-- PTO_SELWENR: Tabelle der Struktur EK08ERSWE                     *
* --> PI_SEGTAB: Struktur vom Typ MMERS_SEGTAB                        *
* <-- PO_ABRECHBAR: Typ C                                             *
* <-- PO_BLOCKNR: Typ I                                               *
* <-- PO_FIRST_ERSSATZ: Struktur vom Typ MMERS_SEGTAB                 *
*---------------------------------------------------------------------*
FORM initialisierung_reprue
                        TABLES    pto_ekrs STRUCTURE ekrs
                                  pto_selwenr STRUCTURE ek08erswe
                                  pto_ekrsdc_del STRUCTURE ekrsdc
                                  pto_settle_dc STRUCTURE ek08ersdc
                         USING    pi_segtab TYPE mmers_segtab
                         CHANGING po_abrechenbar TYPE c
                                  po_blocknr TYPE i
                                  po_first_erssatz TYPE mmers_segtab.

  CLEAR: po_abrechenbar, pto_ekrs, pto_selwenr, po_first_erssatz.
  CLEAR: pto_ekrsdc_del, pto_settle_dc.

  REFRESH: pto_ekrs,          "Tabelle mit zu löschenden EKRS-Sätzen
           pto_selwenr.       "Tabelle mit den zu verarbeit. Pos.
  REFRESH: pto_ekrsdc_del,
           pto_settle_dc.

*ENHANCEMENT-POINT initialisierung_reprue_01 SPOTS es_rmmr1mrs.
  MOVE pi_segtab-blocknr TO po_blocknr.
  MOVE pi_segtab-abrechenbar TO po_abrechenbar.
  MOVE pi_segtab         TO po_first_erssatz.

ENDFORM.                               "INITIALISIERUNG_REPRUE
*eject
*---------------------------------------------------------------------*
*       FORM LESEN_BESTELLKOPF                                        *
*---------------------------------------------------------------------*
*       Lesen des Bestellkopfes                                       *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> pi_ebeln: Nummer des Einkaufsbeleges                            *
* <-- pe_ekko : Bestellkopf                                           *
* <-- pe_rc:    Returncode                                            *
*---------------------------------------------------------------------*
FORM lesen_bestellkopf USING    pi_ebeln LIKE ekko-ebeln
                       CHANGING pe_ekko  STRUCTURE ekko
                                pe_rc    TYPE i.

  CLEAR: pe_ekko, pe_rc.

  CALL FUNCTION 'ME_EKKO_SINGLE_READ'
    EXPORTING
      pi_ebeln         = pi_ebeln
    IMPORTING
      po_ekko          = pe_ekko
    EXCEPTIONS
      no_records_found = 1
      OTHERS           = 2.
  IF sy-subrc NE 0.
    pe_rc = 1.
  ENDIF.

ENDFORM.                               "LESEN_BESTELLKOPF
*eject
*---------------------------------------------------------------------*
*       FORM LESEN_BESTELLPOS_DATEN                                   *
*---------------------------------------------------------------------*
*    1. Lesen der kumulierten Bestellentwicklung zu einer Bestellpos. *
*       mit Hilfe des Funktionsbausteins ME_READ_ITEM_INVOICE         *
*    2. Durchführen einiger Tests auf ERS-Abrechenbarkeit:            *
*       - Steuerkennzeichen muß gesetzt sein                          *
*       - Das Kennzeichen WE-bezogene Reprü muß gesetzt sein          *
*    3. Aussondern der zuviel zurückgelieferten Positionsinformatio-  *
*       nen (der Baustein liefert zu der Bestellposition bei WE-bezo- *
*       gener Rechnungsprüfung für jeden WE wenigstens einen Satz zu- *
*       rück).                                                        *
*    4. Verdichtung der zurückgelieferten Positionsinformationen,     *
*       falls eine kontierte Position vorliegt.                       *
*    5. Bestimmung, ob die Position eine Rechnungsposition (Buchung   *
*       im Soll) oder eine Gutschriftsposition ist (Buchung im Haben) *
*       und Übernahme der Daten in die Ergebnisstruktur               *
*                                                                     *
* Bemerkung: einige Variablen werden 'Static' deklariert, da die Wer- *
*            te über den Aufruf der Routine hinaus gehalten werden    *
*            sollen. Es ist nämlich nicht notwendig pro Wareneingang  *
*            zu einer Position die Bestellentwicklung aufzurufen,     *
*            sondern man ermittelt die Daten zu einer Position einmal *
*            und filtert dann die Daten heraus, die zu dem Warenein-  *
*            gang gehören.                                            *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> pi_ekko:  Einkaufsbelegkopf                                     *
* --> pi_ebelp: Positionsnummer des Einkaufsbeleg                     *
* --> pi_lfbnr: Belegnummer eines Referenzbeleges                     *
* --> pi_lfpos: Position eines Referenzbeleges                        *
* --> pi_lfgja: Geschäftsjahr eines Referenzbeleges                   *
* --> pi_date:  Umrechnungsdatum                                      *
* --> pi_reset: Rücksetzungskennzeichen                               *
* <-> px_segtab: Typ MMERS_SEGTAB, wird verändert, darf nicht initia- *
*                lisiert werden.                                      *
*---------------------------------------------------------------------*
FORM lesen_bestellpos_daten USING   pi_ekko STRUCTURE ekko
                                    pi_ebelp LIKE ekpo-ebelp
                                    pi_lfbnr LIKE ekbe-lfbnr
                                    pi_lfpos LIKE ekbe-lfpos
                                    pi_lfgja LIKE ekbe-lfgja
                                    pi_date  LIKE bkpf-wwert
                                    pi_reset TYPE c
                           CHANGING px_segtab  TYPE mmers_segtab.

*--- Deklaration lokaler Variablen:
  DATA: h_anzahl    LIKE sy-tfill,
        h_wemng_kum LIKE ek08rn-wemng, "WE-Menge kumuliert wg. Kont.
        h_remng_kum LIKE ek08rn-remng, "RE-Menge kumuliert wg. Kont.
        lf_kursf    LIKE bkpf-kursf.

  STATICS: h_last_ebeln LIKE ekko-ebeln, "zuletzt bearbeiteter Beleg
           h_last_ebelp LIKE ekpo-ebelp, "zuletzt bearbeitete Position
           ekbe_rc      TYPE i.             "Returncode
************************************************************************
***** Bedeutung von ekbe_rc:                                          **
*****   0: kein Fehler                                                **
*****   1: Fehler bezieht sich auf Bestellposition unabhängig vom WE; **
*****      der Returncode darf beim Verlassen der Routine nicht ini-  **
*****      tialisiert werden.                                         **
*****   2: Fehler bezieht sich auf einen bestimmten Wareneingang der  **
*****      Bestellposition; der Returncode wird beim Verlassen der    **
*****      Routine initialisiert.                                     **
************************************************************************

*------- zuletzt erhaltene Fehlermeldung:     ------------------------*
  STATICS: BEGIN OF h_last_mesg.
      INCLUDE STRUCTURE mesg.
  STATICS: END OF h_last_mesg.

*------- Ergebnisstruktur von ME_READ_ITEM_INVOICE:       ------------*
  STATICS: BEGIN OF yek08rn OCCURS 100.
      INCLUDE STRUCTURE ek08rn.
  STATICS: END OF yek08rn.

  STATICS: lt_ek08rn_item TYPE STANDARD TABLE OF ek08rn_item.

*------- Struktur; enthält die Sätze aus yek08rn, die sich auf -------*
*------- einen bestimmten Wareneingang beziehen;               -------*
*------- damit kann die Tabelle nur bei einer kontierten Position ----*
*------- mehrere Sätze enthalten.                                 ----*
  DATA: BEGIN OF xek08rn OCCURS 1.
      INCLUDE STRUCTURE ek08rn.
  DATA: END OF xek08rn.
  DATA: tab_index LIKE sy-tabix.
  DATA: wa_yek08rn LIKE yek08rn.
  DATA: f_waers  TYPE waers,
        f_object TYPE object_curro.

  FIELD-SYMBOLS: <ls_ek08rn_item> TYPE ek08rn_item.         "EhP4_MAA

  DATA: lv_subrc LIKE sy-subrc.                             "Ehp5e TM

*ENHANCEMENT-POINT lesen_bestellpos_daten_01 SPOTS es_rmmr1mrs.
  IF h_last_ebeln NE pi_ekko-ebeln OR  "Wechsel der Bestellnr oder
     h_last_ebelp NE pi_ebelp.         "der Bestellposition
    CLEAR: ekbe_rc, yek08rn.
    REFRESH: yek08rn.
    MOVE pi_ekko-ebeln TO h_last_ebeln.
    MOVE pi_ebelp TO h_last_ebelp.

*--- PO currency expired --> use new currency -----------------------*
    f_object = c_objtyp_bus2081.
    CALL FUNCTION 'CURRENCY_EXPIRATION_CHECK'
      EXPORTING
        currency      = pi_ekko-waers
        date          = sy-datlo
        object        = f_object
      IMPORTING
        currency_new  = f_waers
      EXCEPTIONS
        error_message = 4.
    IF sy-subrc = 0.
      f_waers = pi_ekko-waers.
    ELSEIF f_waers IS INITIAL.
      MOVE 1 TO ekbe_rc.
      CLEAR h_last_mesg.
      MOVE syst-msgty TO h_last_mesg-msgty.
      MOVE syst-msgid TO h_last_mesg-arbgb.
      MOVE syst-msgno TO h_last_mesg-txtnr.
      MOVE syst-msgv1 TO h_last_mesg-msgv1.
      MOVE syst-msgv2 TO h_last_mesg-msgv2.
      MOVE syst-msgv3 TO h_last_mesg-msgv3.
      MOVE syst-msgv4 TO h_last_mesg-msgv4.
      PERFORM aufbereitung_fehlermeldung CHANGING h_last_mesg.
    ENDIF.

    lf_kursf = pi_ekko-wkurs.

*-- Bucht man mehrere Storno's BewArt 102 zu einem Referenzbeleg ----*
*-- liefert FB Werte zu diesem Beleg kummuliert, die Info zu den ----*
*-- Belegen selbst liefert er nicht ---------------------------------*

*ENHANCEMENT-SECTION     lesen_bestellpos_daten_04 SPOTS es_rmmr1mrs.
    CALL FUNCTION 'ME_READ_ITEM_INVOICE'
      EXPORTING
        display       = 'X'      "Sätze werden nicht gesperrt
        ebelp         = pi_ebelp
        iekko         = pi_ekko
        re_kursf      = lf_kursf
        re_waers      = f_waers
        re_wwert      = pi_date
        xek08r_flag   = pi_reset
      TABLES
        xek08rn_item  = lt_ek08rn_item
        xek08rn       = yek08rn
      EXCEPTIONS
        not_found_any = 1
        not_found_one = 2
        not_valid_any = 3
        not_valid_one = 4
        OTHERS        = 5.
*END-ENHANCEMENT-SECTION.

    IF sy-subrc NE 0.
      MOVE 1 TO ekbe_rc.
      CLEAR h_last_mesg.
      lv_subrc = sy-subrc.
*---- Fehlermeldung aus dem Funktionsbaustein wird weitergegeben:   --*
      IF cl_ops_switch_check=>mm_sfws_tm( ) = abap_on       "Ehp5e TM
      AND pa_tm = abap_true.
        cl_mrm_tm_services=>translate_error_msg(
          EXPORTING
            iv_subrc   = lv_subrc
            iv_po_id   = pi_ekko-ebeln
            iv_po_item = pi_ebelp
          EXCEPTIONS
            OTHERS     = 0 ).
      ENDIF.
      MOVE syst-msgty TO h_last_mesg-msgty.
      MOVE syst-msgid TO h_last_mesg-arbgb.
      MOVE syst-msgno TO h_last_mesg-txtnr.
      MOVE syst-msgv1 TO h_last_mesg-msgv1.
      MOVE syst-msgv2 TO h_last_mesg-msgv2.
      MOVE syst-msgv3 TO h_last_mesg-msgv3.
      MOVE syst-msgv4 TO h_last_mesg-msgv4.
      PERFORM aufbereitung_fehlermeldung CHANGING h_last_mesg.
    ENDIF.

    SORT yek08rn BY lfbnr lfpos lfgja.
  ENDIF.

  IF ekbe_rc = 0.
*---- Überprüfung Steuerkennz., Kennz. für WE-bez. Reprü und      ---*
*---- Kennzeichen für Schätzpreis:                                ---*
    READ TABLE yek08rn INDEX 1.        "Tabelle kann nicht leer sein.

*---- For service PO the tax indicator (MWSKZ) in                 ---*
*---- ME_READ_ITEM_INVOICE is taken from ESKN or EKPO. Therefore  ---*
*---- table yek08rn has to be checked per LFBNR, LFPOS and LFGJA. ---*
    IF yek08rn-pstyp = c_pstyp_9.
      READ TABLE yek08rn WITH KEY lfbnr = pi_lfbnr
                                  lfpos = pi_lfpos
                                  lfgja = pi_lfgja          "1548862
                         BINARY SEARCH.                     "1548862
    ENDIF.

    IF yek08rn-mwskz = space.
      CLEAR h_last_mesg.
      MOVE 1 TO ekbe_rc.
      h_last_mesg-arbgb = 'XX'.
      h_last_mesg-txtnr = '003'.  "Bestellpos. hat kein Steuerkennz.
      h_last_mesg-text  = TEXT-e03.
    ENDIF.
    IF ekbe_rc = 0 AND
       yek08rn-webre = space.
      CLEAR h_last_mesg.
      MOVE 1 TO ekbe_rc.
      h_last_mesg-arbgb = 'XX'.
      h_last_mesg-txtnr = '004'.       "WE-bez. Reprü nicht aktiv.
      h_last_mesg-text  = TEXT-e04.
    ENDIF.
    IF ekbe_rc = 0 AND
       yek08rn-schpr = 'X'.
      CLEAR h_last_mesg.
      MOVE 1 TO ekbe_rc.
      h_last_mesg-arbgb = 'XX'.
      h_last_mesg-txtnr = '006'.       "Material enthält Schätzpreis
      h_last_mesg-text  = TEXT-e06.
    ENDIF.
  ENDIF.

  IF ekbe_rc = 0.
    REFRESH: xek08rn.
    CLEAR: xek08rn, h_anzahl.
*--- Herausfiltern der Sätze, die zu einem bestimmten WE gehören:
    READ TABLE yek08rn INTO wa_yek08rn
                   WITH KEY lfbnr = pi_lfbnr
                            lfpos = pi_lfpos
                            lfgja = pi_lfgja
                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING wa_yek08rn TO xek08rn.
      tab_index = sy-tabix + 1.
      APPEND xek08rn.

      DO.
        READ TABLE yek08rn INTO wa_yek08rn INDEX tab_index.
        IF sy-subrc <> 0.              "Tabellenende
          EXIT.
        ENDIF.
        IF wa_yek08rn-lfbnr   <> pi_lfbnr
          OR wa_yek08rn-lfpos <> pi_lfpos
          OR wa_yek08rn-lfgja <> pi_lfgja.
          EXIT.
        ENDIF.
        MOVE-CORRESPONDING wa_yek08rn TO xek08rn.
        APPEND xek08rn.
        tab_index = tab_index + 1.
      ENDDO.
    ENDIF.

    DESCRIBE TABLE xek08rn LINES h_anzahl.
    IF h_anzahl = 0.
      CLEAR h_last_mesg.
      MOVE 2 TO ekbe_rc.
      h_last_mesg-arbgb = 'XX'.
      h_last_mesg-txtnr = '002'.       "Referenzbeleg nicht gefunden
      h_last_mesg-text  = TEXT-e02.
    ENDIF.
  ENDIF.

  IF ekbe_rc = 0.
*--- Kumulierung der WE-Menge und der RE-Menge bei kontierten Pos:
    READ TABLE xek08rn INDEX 1.        "Tabelle kann nicht leer sein.

    IF xek08rn-vrtkz = space.          "Position nicht kontiert:
      MOVE xek08rn-remng TO h_remng_kum.
      MOVE xek08rn-wemng TO h_wemng_kum.
    ELSE.
      IF cl_ops_switch_check=>mm_sfws_maa( ) IS INITIAL OR
         xek08rn-xhistma IS INITIAL.
* Old MAA cumulate REMNG/WEMNG, new MAA uses item table ek08rn_item
        CLEAR: h_remng_kum, h_wemng_kum.
        LOOP AT xek08rn.
          h_remng_kum = h_remng_kum + xek08rn-remng.
          h_wemng_kum = h_wemng_kum + xek08rn-wemng.
        ENDLOOP.
        READ TABLE xek08rn INDEX 1.
      ENDIF.
    ENDIF.

    IF ekbe_rc = 0.
*--- Übernahme der Daten in die Ergebnisstruktur:
*ENHANCEMENT-POINT lesen_bestellpos_daten_02 SPOTS es_rmmr1mrs.
      MOVE xek08rn-lfbnr TO px_segtab-lfbnr.
      MOVE xek08rn-lfpos TO px_segtab-lfpos.
      MOVE xek08rn-lfgja TO px_segtab-lfgja.
      MOVE xek08rn-ebeln TO px_segtab-ebeln.
      MOVE xek08rn-ebelp TO px_segtab-ebelp.
      MOVE xek08rn-matnr TO px_segtab-matnr.
      IF xek08rn-bukrs NE space.
        MOVE xek08rn-bukrs TO px_segtab-bukrs.
      ELSE.
        MOVE pi_ekko-bukrs TO px_segtab-bukrs.
      ENDIF.
      MOVE xek08rn-mwskz TO px_segtab-mwskz.
      MOVE xek08rn-txjcd TO px_segtab-txjcd.
      MOVE xek08rn-pstyp TO px_segtab-pstyp.
      MOVE xek08rn-waers TO px_segtab-waers.
      MOVE xek08rn-webre TO px_segtab-webre.
      MOVE xek08rn-xblnr TO px_segtab-xblnr.
      MOVE xek08rn-txz01 TO px_segtab-txz01.
      MOVE xek08rn-retpo TO px_segtab-retpo.
      MOVE xek08rn-upvor TO px_segtab-upvor.
      MOVE xek08rn-uptyp TO px_segtab-uptyp.
      MOVE xek08rn-uebpo TO px_segtab-uebpo.
      MOVE xek08rn-budat TO px_segtab-budat.
      IF cl_ops_switch_check=>mm_sfws_maa( ) IS INITIAL OR
         xek08rn-xhistma IS INITIAL.
        MOVE h_wemng_kum   TO px_segtab-wemng.
        MOVE h_remng_kum   TO px_segtab-remng.
      ELSE.
        READ TABLE lt_ek08rn_item ASSIGNING <ls_ek08rn_item>
                                  WITH KEY ebeln = xek08rn-ebeln
                                           ebelp = xek08rn-ebelp
                                           lfgja = xek08rn-lfgja
                                           lfbnr = xek08rn-lfbnr
                                           lfpos = xek08rn-lfpos.
        MOVE <ls_ek08rn_item>-wemng TO px_segtab-wemng.
        MOVE <ls_ek08rn_item>-remng TO px_segtab-remng.
      ENDIF.
    ENDIF.
*------- Sammelartikel Unterposition wird als Hauptpos. behandelt ---*
* -- MPN-Unterposition wird als normale Pos. behandelt 'A&D_MPN' ----*
    IF ( xek08rn-uptyp = '1' AND NOT xek08rn-uebpo IS INITIAL ) OR
       ( xek08rn-uptyp = '8' AND NOT xek08rn-uebpo IS INITIAL ).
      CLEAR px_segtab-uebpo.
      CLEAR px_segtab-uptyp.
    ENDIF.

    PERFORM weitere_segtab_daten USING px_segtab
                              CHANGING px_segtab
                                       ekbe_rc.
*ENHANCEMENT-POINT lesen_bestellpos_daten_03 SPOTS es_rmmr1mrs.
  ENDIF.

  IF ekbe_rc NE 0.
*---- Fehler liegt vor:                                          -----*
    MOVE-CORRESPONDING h_last_mesg TO px_segtab.
    MOVE space TO px_segtab-abrechenbar.
    IF ekbe_rc = 2.     "Fehler bezog sich nur auf akt. WE
      MOVE 0 TO ekbe_rc.
    ENDIF.
  ENDIF.

ENDFORM.                               "LESEN_BESTELLPOS_DATEN
*eject
*---------------------------------------------------------------------*
*       FORM LESEN_TAB_EKRS                                           *
*---------------------------------------------------------------------*
*       Lesen Tab. EKRS; Füllen interne Tabelle PTO_EKRS (soweit mög- *
*       lich) und interne Tabelle PTO_EKBEL.                          *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-- PTO_EKRS: Tabelle vom Typ TAB_ERW_EKRS                          *
* <-- PTO_EKBEL: Tabelle mit der Struktur EKBEL                       *
* <-- PTO_EKKO_KEY: Tabelle der Struktur EKKO_KEY                     *
*---------------------------------------------------------------------*
FORM lesen_tab_ekrs TABLES pto_ekrs TYPE tab_erw_ekrs
                           pto_ekbel STRUCTURE ekbel
                           pto_ekko_key STRUCTURE ekko_key.

  DATA: li_restrict_badi    TYPE REF TO /spe/restrict_ers1.

*ENHANCEMENT-SECTION     lesen_tab_ekrs_01 SPOTS es_rmmr1mrs.
*SPIIN is active?
  IF /sappspro/cl_numbers=>is_active( ) EQ space.
*}   INSERT
    SELECT * FROM ekrs INTO TABLE pto_ekrs
      WHERE  budat IN p_budat "B_BUDAT
        AND  lifnr IN b_lifnr
        AND  belnr IN b_mblnr
        AND  gjahr IN b_mjahr
        AND  ebeln IN b_ebeln
        AND  ebelp IN b_ebelp
      AND  werks IN b_werks                                 "977217
      AND  bukrs IN b_bukrs.
*{   INSERT         KX1K000095                                        2
  ELSE.
    SELECT * INTO TABLE lt_ekrs_eadd_join
     FROM ekrs AS s INNER JOIN /sappspro/eadd AS p ON s~ebeln = p~ebeln
            WHERE s~ebeln      IN b_ebeln
            AND   p~longnum_uc IN r_longn
            AND  lifnr IN b_lifnr
            AND  belnr IN b_mblnr
            AND  gjahr IN b_mjahr
            AND  budat IN p_budat"B_BUDAT
            AND  ebelp IN b_ebelp
            AND  werks IN b_werks                           "977217
            AND  bukrs IN b_bukrs.
    LOOP AT lt_ekrs_eadd_join INTO ls_ekrs_eadd_join.
      ls_ekrs = ls_ekrs_eadd_join-ekrs.
      ls_eadd = ls_ekrs_eadd_join-eadd.
      APPEND ls_ekrs TO pto_ekrs.
      APPEND ls_eadd TO lt_eadd.
    ENDLOOP.

  ENDIF.
*END-ENHANCEMENT-SECTION.

* BADI to restrict EKRS-Entries by CRM rules
* used in SPM szenario
  GET BADI li_restrict_badi.

  CALL BADI li_restrict_badi->restrict_ekrs
    CHANGING
      t_ekrs = pto_ekrs[].

  LOOP AT pto_ekrs.
*ENHANCEMENT-POINT lesen_tab_ekrs_02 SPOTS es_rmmr1mrs.
    MOVE-CORRESPONDING pto_ekrs TO pto_ekbel.
    COLLECT pto_ekbel.
    MOVE-CORRESPONDING pto_ekrs TO pto_ekko_key.
    COLLECT pto_ekko_key.
  ENDLOOP.
  SORT pto_ekrs BY lifnr ebeln ebelp gjahr belnr buzei.

ENDFORM.                               "LESEN_TAB_EKRS
*eject
*---------------------------------------------------------------------*
*       FORM LONG_MESSAGE_SHOW                                        *
*---------------------------------------------------------------------*
*   Langtext der Meldungen in der Ausgabeliste anzeigen               *
*---------------------------------------------------------------------*
FORM long_text_message_show USING i_segtab TYPE mmers_segtab.

  DATA: t_dummy LIKE tline OCCURS 1,
        dokname LIKE dokil-object,                       "CHAR60
        title   LIKE dsyst-doktitle,
        dynnr   LIKE help_info-dynpro,
        pfkey   LIKE help_info-pfkey.

* System-Felder kopieren/konvertieren
  title = sy-title.
  dynnr = sy-dynnr.
  pfkey = sy-pfkey.

* Dokumentname konstuieren
  CALL FUNCTION 'DOCU_OBJECT_NAME_CONCATENATE'
    EXPORTING
      docu_id  = c_dokclass_na
      element  = i_segtab-arbgb
      addition = i_segtab-txtnr
    IMPORTING
      object   = dokname.

* Aufruf Popup mit dem Langtext der Meldung
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass          = c_dokclass_na
      dokname           = dokname
      doktitle          = title
      called_by_program = c_repid
      called_by_dynp    = dynnr
      msg_var_1         = i_segtab-msgv1
      msg_var_2         = i_segtab-msgv2
      msg_var_3         = i_segtab-msgv3
      msg_var_4         = i_segtab-msgv4
      called_by_cuaprog = c_repid
      called_by_cuastat = pfkey
    TABLES
      links             = t_dummy.

ENDFORM.                    "long_text_message_show
*---------------------------------------------------------------------*
*       FORM PF_STATUS_SET                                            *
*---------------------------------------------------------------------*
*  Status der Liste setzen                                            *
*---------------------------------------------------------------------*
FORM pf_status_set USING rt_extab TYPE slis_t_extab.        "#EC CALLED

  SET PF-STATUS '0001'. "EXCLUDING rt_extab.

  IF cl_ops_switch_check=>mm_sfws_tm( ) = abap_true         "Ehp5e TM
  AND pa_tm EQ abap_true.
    SET TITLEBAR '1000_TM'.
  ENDIF.

ENDFORM.                    "pf_status_set
*---------------------------------------------------------------------*
*       FORM PROTOKOLLAUSGABE                                         *
*---------------------------------------------------------------------*
*   Zuerst Ausgabe der nicht abrechenbaren Positionen; dann Ausgabe   *
*   der abrechenbaren bzw. abgerechneten Positionen.                  *
*   zusammengesetzte Artikel werden gemeinsam ausgegeben              *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-> PTI_SEGTAB: Tabelle vom Typ MMERS_TSEGTAB; enthält alle Pos.    *
* --> PI_ERSBA: gewählte Belegabgrenzung                              *
*---------------------------------------------------------------------*
FORM protokollausgabe TABLES ptx_segtab TYPE mmers_tsegtab.

  DATA: tab_fieldcat TYPE  slis_t_fieldcat_alv,     " Feldkatalog
        tab_sort     TYPE  slis_t_sortinfo_alv,
        s_layout     TYPE  slis_layout_alv,
        tab_events   TYPE  slis_t_event,
        s_mesg       LIKE  mesg.


  CONSTANTS:
    c_pf_status_set TYPE slis_formname VALUE 'PF_STATUS_SET',
    c_user_command  TYPE slis_formname VALUE 'USER_COMMAND'.

  s_layout-colwidth_optimize = 'X'.
  s_layout-zebra             = 'X'.
  s_layout-box_fieldname     = 'BOX'.
*  s_layout-box_fieldname     = 'ZZCHECK'.
  s_layout-group_change_edit = 'X'.

  IF pa_tm EQ abap_false.                              "Ehp5e TM Beginn
    PERFORM field_catalog_build TABLES tab_fieldcat.
  ELSE.
    cl_mrm_tm_services=>tm_field_catelag_ers(
    IMPORTING
      et_fieldcat = tab_fieldcat[]
    ).                                                "Ehp5e TM Ende
  ENDIF.
  PERFORM sorttab_build TABLES tab_sort.
  PERFORM eventtab_build USING tab_events.

*- nicht abrechenb. Positionen im Testmodus mit Markierfeld ausgeben -*
  PERFORM checkbox_fill TABLES ptx_segtab.

  segtab = ptx_segtab.
*******************ADDED BY RANI E.****************************
*DELETE SEGTAB[] WHERE LFBNR IS INITIAL.
*  break primus.
  IF segtab[] IS NOT INITIAL.
*BREAK-POINT.
    SELECT ebeln ebelp netwr brtwr mwskz bukrs kolif menge meins netpr elikz
        FROM ekpo
     INTO TABLE gt_po_data
      FOR ALL ENTRIES IN segtab[]
      WHERE ebeln = segtab-ebeln
        AND   ebelp = segtab-ebelp.



    SELECT ebeln ebelp knttp pstyp elikz
       FROM ekpo
    INTO TABLE gt_ekpo1
     FOR ALL ENTRIES IN segtab[]
     WHERE ebeln = segtab-ebeln
       AND   ebelp = segtab-ebelp.


    SELECT packno
           ebeln
           ebelp
           FROM eslh
           INTO TABLE it_eslh
           FOR ALL ENTRIES IN segtab
           WHERE ebeln = segtab-ebeln
           AND ebelp = segtab-ebelp.


    IF it_eslh IS NOT INITIAL.
      SELECT packno
             introw
             numkn
             netwr
        FROM eskl
        INTO TABLE it_eskl
        FOR ALL ENTRIES IN it_eslh
        WHERE packno = it_eslh-packno.

    ENDIF.



*    SELECT KAPPL
*          KSCHL
*          ALAND
*          MWSKZ
*          KNUMH
*     FROM A003
*     INTO TABLE IT_A003
*     FOR ALL ENTRIES IN GT_PO_DATA
*     WHERE MWSKZ = GT_PO_DATA-MWSKZ.
    SELECT  kappl
         kschl
         mwskz
         knumh
       FROM a991
         INTO TABLE it_a991
         FOR ALL ENTRIES IN gt_po_data
         WHERE mwskz = gt_po_data-mwskz.

*     SELECT KNUMH
*           KOPOS
*           KBETR
*           KSCHL
*           MWSK1
*       FROM KONP
*       INTO TABLE IT_KONP
*       FOR ALL ENTRIES IN IT_A003
*       WHERE KNUMH = IT_A003-KNUMH.


    SELECT knumh
           kopos
           kbetr
           kschl
           mwsk1
       FROM konp
       INTO TABLE it_konp
       FOR ALL ENTRIES IN it_a991
       WHERE knumh = it_a991-knumh.

    SELECT mblnr mjahr budat_mkpf bwart lifnr dmbtr ebeln ebelp lfbnr menge bnbtr
        FROM mseg
     INTO TABLE gt_mseg
        FOR ALL ENTRIES IN segtab[]
        WHERE lfbnr = segtab-lfbnr
       AND ebeln = segtab-ebeln
     AND   ebelp = segtab-ebelp
      AND mblnr = segtab-lfbnr
      and bwart = '101'.
*      AND MJAHR = SEGTAB-GJAHR.


    SELECT mblnr mjahr bwart lifnr dmbtr ebeln ebelp lfbnr menge bnbtr
      FROM mseg
   INTO TABLE gt_mseg1
      FOR ALL ENTRIES IN segtab[]
      WHERE lfbnr = segtab-lfbnr
      AND ebeln = segtab-ebeln
   AND   ebelp = segtab-ebelp
   AND mblnr = segtab-lfbnr.
*      AND MJAHR = SEGTAB-GJAHR.
***************************ADDED BY PRIMUS JYOTI ON 26.03.2024
    IF gt_mseg1 IS NOT INITIAL.
      DATA :   it_mseg_102 TYPE TABLE OF mseg.
      SELECT *
        FROM mseg
        INTO TABLE it_mseg_102
        FOR ALL ENTRIES IN gt_mseg1
        WHERE ebeln = gt_mseg1-ebeln
        AND smbln = gt_mseg1-mblnr.
    ENDIF.
*************************************************************

    IF gt_mseg IS NOT INITIAL.

      SELECT mblnr mjahr bldat
          FROM mkpf
       INTO TABLE gt_mkpf
       FOR ALL ENTRIES IN gt_mseg
       WHERE mblnr = gt_mseg-mblnr
             AND mjahr = gt_mseg-mjahr.

      SELECT bukrs belnr gjahr awkey
       FROM bkpf
       INTO TABLE gt_bkpf
       FOR ALL ENTRIES IN gt_mseg[]
       WHERE belnr = gt_mseg-mblnr.


    ENDIF.
* IF gt_PO_DATA is not initial.
    SELECT ebeln bukrs lifnr knumv bsart
      FROM ekko
      INTO TABLE gt_ekko
      FOR ALL ENTRIES IN segtab[]
      WHERE ebeln = segtab-ebeln
           AND bukrs = segtab-bukrs
           AND bsart IN ( 'NB' , 'ZSUB' ).

  ENDIF.
******aDDED BY PRIMUS JYOTI ON 21.03.2024
  EXPORT gt_ekko TO MEMORY ID 'ZMRRL_EKKO'.

  "-------- ADDED BY ANISH ON 15.06.2023 ----------"

*  DATA : LV_TAX(5) TYPE C.
*  CLEAR LV_TAX.
*  IMPORT SEGTAB-ZZWITHT TO LV_TAX FROM MEMORY ID 'ZMRRL_TAX'.
*  FREE MEMORY ID 'ZMRRL_TAX'.

  IF gt_ekko IS NOT INITIAL.
    SELECT * FROM lfbw
     INTO TABLE gt_lfbw
     FOR ALL ENTRIES IN gt_ekko[]
     WHERE lifnr = gt_ekko-lifnr
      AND bukrs = '1000'.
    " AND   WITHT EQ LV_TAX.                           " ADDED BY ANISH

    "-----------------------------------------------"

    SELECT lifnr name1
   FROM lfa1
   INTO TABLE gt_lfa1
   FOR ALL ENTRIES IN gt_ekko[]
   WHERE lifnr = gt_ekko-lifnr.

    SELECT knumv kposn kschl kawrt kbetr lifnr kwert
    FROM prcd_elements  "konv
    INTO TABLE gt_konv
    FOR ALL ENTRIES IN gt_ekko[]
    WHERE knumv = gt_ekko-knumv AND
          lifnr = gt_ekko-lifnr  AND
          ( kschl = 'JEXS' OR kschl = 'ZFRB' OR kschl = 'ZFRC' ). " AND


  ENDIF.


  IF gt_lfbw IS NOT INITIAL.
    SELECT * FROM t059zt
    INTO TABLE gt_t059zt
    FOR ALL ENTRIES IN gt_lfbw
    WHERE witht = gt_lfbw-witht
    AND   wt_withcd = gt_lfbw-wt_withcd.



  ENDIF.

  SELECT lblni ebeln ebelp
  FROM essr
  INTO TABLE gt_essr
  FOR ALL ENTRIES IN segtab[]
  WHERE  ebeln = segtab-ebeln
 AND   ebelp = segtab-ebelp.

  SELECT ebeln ebelp gjahr belnr dmbtr menge wrbtr mwskz
  FROM ekbe
  INTO TABLE gt_ekbe
  FOR ALL ENTRIES IN segtab[]
  WHERE  belnr = segtab-lfbnr.
*        ebeln = segtab-ebeln
*  AND   ebelp = segtab-ebelp.

*  ENDIF.



**************************************

***************************************
  DATA : ls_ekrs       TYPE ekrs,
         ls_essr       TYPE essr,
         ls_esll       TYPE esll,
         ls_esll1      TYPE esll,
         lv_extrow(10) TYPE c.

*BREAK primusabap.
SORT SEGTAB BY LFBNR ebeln ebelp xekbz.
*delete segtab where lfbnr is INITIAL.
  LOOP AT segtab.

   SELECT SINGLE budat,bldat,XBLNR FROM MKPF INTO @DATA(LS_mkpf)
      WHERE MBLNR = @segtab-LFBNR.
****************added by jyoti on 23.10.2024**********************
*************logic for posting date********************************
    if budat1-low gt sy-datum.
        segtab-msgty = 'E'.
        segtab-text = 'Posting date should not be later than the system date.'.
*        MESSAGE 'Posting Date is not in Future' TYPE 'E'.
    elseif budat1-low lt ls_mkpf-budat.
      segtab-msgty = 'E'.
      segtab-text = 'Back dated Posting date is not allowed.'.
*        MESSAGE 'Posting Date is not in Back Dated' TYPE 'E'.
    endif.

    READ TABLE gt_po_data INTO gs_po_data WITH KEY ebeln = segtab-ebeln ebelp = segtab-ebelp.
    IF sy-subrc = 0.
*    SEGTAB-ZZBRTWR = GS_PO_DATA-BRTWR.
      segtab-zznetwr = gs_po_data-netwr.
      segtab-zzmwskz = gs_po_data-mwskz.
      segtab-zzmeins = gs_po_data-meins.
      segtab-zzelikz  = gs_po_data-elikz.
      segtab-zzquantity = gs_po_data-menge."ADDED BY PRIMUS JYOTI ON 13.02.2024

      READ TABLE gt_essr INTO gs_essr WITH KEY ebeln = segtab-ebeln
                                                   ebelp = segtab-ebelp.
      segtab-zzlblni = gs_essr-lblni.


      READ TABLE gt_mseg INTO gs_mseg WITH  KEY lfbnr = segtab-lfbnr ebeln = segtab-ebeln
                                                                  ebelp = segtab-ebelp
                                                                  menge = segtab-wemng
                                                                      bwart = '101'.
      IF GS_MSEG-LFBNR IS NOT INITIAL.
      segtab-lfbnr = gs_mseg-lfbnr.
      ENDIF.
      IF gs_po_data-menge EQ segtab-wemng. "added by jyoti on 14.02.2024
        segtab-zzdmbtr = gs_mseg-dmbtr.

        segtab-zzbnbtr = gs_mseg-bnbtr.
      ELSE.
        segtab-zzdmbtr = gs_mseg-dmbtr.

        segtab-zzbnbtr = gs_mseg-bnbtr.

*          SEGTAB-ZZDMBTR = GS_MSEG-DMBTR * SEGTAB-WEMNG.
*
*      SEGTAB-ZZBNBTR = GS_MSEG-BNBTR * SEGTAB-WEMNG.

      ENDIF.
*      SEGTAB-ZZMENGE = GS_MSEG-MENGE.

**********added by shreya **************

      READ TABLE gt_mseg1 INTO gs_mseg1 WITH  KEY lfbnr = segtab-lfbnr ebeln = segtab-ebeln
                                                                     ebelp = segtab-ebelp
                                                                     bwart = '101'.
      segtab-zzbwart = gs_mseg1-bwart.



**********added by shreya **************

      READ TABLE gt_ekpo1 INTO gs_ekpo1 WITH  KEY ebeln = segtab-ebeln
                                                  ebelp = segtab-ebelp.


      segtab-zzknttp = gs_ekpo1-knttp.
      segtab-zzpstyp = gs_ekpo1-pstyp.
      segtab-zzelikz  = gs_ekpo1-elikz.

      READ TABLE gt_ekko INTO gs_ekko WITH  KEY ebeln = segtab-ebeln.
*                                                  EBELP = SEGTAB-EBELP.
*      READ TABLE GT_LFBW INTO GS_LFBW WITH KEY LIFNR = SEGTAB-LIFNR.
      LOOP AT  gt_lfbw INTO gs_lfbw WHERE lifnr = segtab-lifnr.
*      IF SY-SUBRC = 0.
        "addon_zmrrl-ZZWITHT = GS_LFBW-WITHT.

        IF gs_lfbw-witht IS NOT INITIAL AND gs_lfbw-wt_withcd IS NOT INITIAL AND
            gs_lfbw-wt_subjct IS NOT INITIAL.
          DATA : gv_witht TYPE lfbw-witht.
          DATA : gv_witht2 TYPE lfbw-witht.
          gv_witht = '4Q'.
*         GV_WITHT2 = '5Q'.
          IF gs_ekko-bsart = 'NB'.
*             SEGTAB-ZZWITHT =  GS_LFBW-WITHT.
            IF gv_witht = gs_lfbw-witht.
              segtab-zzwitht =  gs_lfbw-witht.
*             ELSEIF GV_WITHT2 = GS_LFBW-WITHT.
*               SEGTAB-ZZWITHT =  GS_LFBW-WITHT.
            ENDIF.

*             SEGTAB-ZZWITHT
          ELSEIF gs_ekko-bsart = 'ZSUB'.
            DATA(gv_witht1) = 'T1'.
*             IF GS_LFBW-WITHT = 'T1'.
*             IF GS_LFBW-WITHT = '4Q'.
*            SEGTAB-ZZWITHT =  GS_LFBW-WITHT.
*            ENDIF.
            IF gv_witht1 = gs_lfbw-witht.
              segtab-zzwitht =  gs_lfbw-witht.

            ENDIF.
          ENDIF.

        ENDIF.
*      ENDIF.
      ENDLOOP.

      READ TABLE gt_t059zt INTO gs_t059zt WITH  KEY witht = segtab-zzwitht .
      segtab-zztext40 = gs_t059zt-text40.


*      IF SEGTAB-ZZKNTTP = ' ' OR SEGTAB-ZZKNTTP = 'A' OR SEGTAB-ZZKNTTP = 'F' AND SEGTAB-ZZPSTYP = ' '.
*        SEGTAB-ZZWITHT = '4Q'.
*      ELSEIF  SEGTAB-ZZKNTTP = ' ' OR SEGTAB-ZZKNTTP = 'A' OR SEGTAB-ZZKNTTP = 'F' OR SEGTAB-ZZKNTTP = 'K'  AND SEGTAB-ZZPSTYP = 'L'.
*        SEGTAB-ZZWITHT =  'T1'.
*
*      ELSE.
*        SEGTAB-ZZWITHT =  GS_LFBW-WITHT.
*      ENDIF.

**************added by primus jyoti*************************************
*   if SEGTAB-ZZTEXT40 is INITIAL.
**   SELECT * FROM T059ZT
**    INTO TABLE GT_T059ZT
**    WHERE WITHT = GS_LFBW-WITHT.
*
*     SELECT SINGLE TEXT40 FROM T059ZT INTO @SEGTAB-ZZTEXT40 WHERE LAND1     EQ 'IN'
*                                                             AND   WITHT     EQ @SEGTAB-ZZWITHT
*                                                             AND   WT_WITHCD EQ @SEGTAB-ZZWITHT.
*
**    AND   WT_WITHCD = GT_LFBW-WT_WITHCD.
*
**       READ TABLE GT_T059ZT INTO GS_T059ZT WITH  KEY WITHT = GS_LFBW-WITHT .
**        SEGTAB-ZZTEXT40 = GS_T059ZT-TEXT40.
*   endif.
******************************************************************************
      LOOP AT it_eslh INTO wa_eslh WHERE ebeln = segtab-ebeln AND ebelp = segtab-ebelp.

        READ TABLE it_eskl INTO wa_eskl WITH KEY packno = wa_eslh-packno.


        segtab-zzbasic_am = wa_eskl-netwr.
      ENDLOOP.



      IF segtab-zzlblni IS INITIAL.

*        SEGTAB-ZZBASIC_AM = GS_PO_DATA-NETPR * GS_MSEG-MENGE.
        IF gs_po_data-menge EQ segtab-wemng.
          segtab-zzbasic_am = gs_po_data-netpr * gs_mseg-menge.
        ELSE.

          segtab-zzbasic_am = gs_po_data-netpr * segtab-wemng.
        ENDIF.

      ENDIF.

      segtab-zzassesable = segtab-zzbasic_am + segtab-zzbnbtr.


*      READ TABLE IT_A003 INTO WA_A003 WITH KEY MWSKZ = GS_PO_DATA-MWSKZ.
*      READ TABLE IT_A991 INTO WA_A991 WITH KEY MWSKZ = GS_PO_DATA-MWSKZ.
      LOOP AT it_a991 INTO wa_a991 WHERE mwskz = gs_po_data-mwskz.
*********** loop for GST added by shreya ***********


*      LOOP AT IT_KONP INTO WA_KONP WHERE MWSK1 = GS_PO_DATA-MWSKZ.
        LOOP AT it_konp INTO wa_konp WHERE knumh = wa_a991-knumh.
*        read table it_konp into wa_konp with key knumh = wa_a003-knumh.

          lv_gst  =   lv_gst + wa_konp-kbetr.

***********added by shreya ***************

          IF wa_konp-kschl = 'JICG'.
            segtab-zzcgst_n = segtab-zzassesable * ( wa_konp-kbetr / 10 ) / 100.
          ELSEIF wa_konp-kschl = 'JISG'.
            segtab-zzsgst_n = segtab-zzassesable * ( wa_konp-kbetr / 10 ) / 100.
          ELSEIF wa_konp-kschl = 'JIIG'.
            segtab-zzigst_n = segtab-zzassesable * ( wa_konp-kbetr / 10 ) / 100.
          ENDIF.

        ENDLOOP.
      ENDLOOP.




      segtab-zzgst =   segtab-zzassesable * ( lv_gst / 10 ) / 100.

      segtab-zzgross_am = segtab-zzbasic_am + segtab-zzbnbtr + segtab-zzgst .


      SELECT SINGLE awkey FROM bkpf INTO zawkey WHERE belnr = gs_mseg-mblnr.

      IF zawkey = ' '.
        READ TABLE gt_mkpf INTO gs_mkpf WITH  KEY mblnr = gs_mseg-mblnr
                                                      mjahr = gs_mseg-mjahr.
        segtab-zzbldat = gs_mkpf-bldat.

        DATA : gv_budat1 TYPE mkpf-bldat.
        gv_budat1 = gs_mkpf-bldat . "added by primus jyoti
        EXPORT gv_budat1 TO MEMORY ID 'BUDAT1'.


        READ TABLE gt_ekbe INTO gs_ekbe WITH KEY belnr = segtab-lfbnr.               "EBELN = SEGTAB-EBELN
        "EBELP = SEGTAB-EBELP.
*        SEGTAB-ZZMENGE = GS_EKBE-MENGE.       "QUANTITY
        segtab-zzmenge = segtab-wemng.       "QUANTITY
*        SEGTAB-ZZQUANTITY =  SEGTAB-ZZMENGE.
        segtab-zzbrtwr = gs_ekbe-dmbtr.       "GROSS AMT
*    SEGTAB-ZZWRBTR = GS_EKBE-WRBTR.       "NET AMT

**=============================CGST SGST IGST================================================
        IF segtab-zzmwskz = 'GA'.
          segtab-zzigst = ( gs_ekbe-dmbtr * 5 ) / 100.
        ENDIF.

        IF segtab-zzmwskz = 'GB'.
          segtab-zzcgst = ( ( gs_ekbe-dmbtr * 5 )  / 100 ) / 2.
          segtab-zzsgst = ( ( gs_ekbe-dmbtr * 5 ) / 100 ) / 2.
        ENDIF.

        IF segtab-zzmwskz = 'GE'.
          segtab-zzigst = ( gs_ekbe-dmbtr * 12 ) / 100.
        ENDIF.

        IF segtab-zzmwskz = 'GF'.
          segtab-zzigst = ( gs_ekbe-dmbtr * 18 ) / 100.
        ENDIF.

        IF segtab-zzmwskz = 'GG'.
          segtab-zzigst = ( gs_ekbe-dmbtr * 28 ) / 100.
        ENDIF.

        IF segtab-zzmwskz = 'GH'.
          segtab-zzcgst = ( gs_ekbe-dmbtr * 6 ) / 100.
          segtab-zzsgst = ( gs_ekbe-dmbtr * 6 ) / 100.
        ENDIF.

        IF segtab-zzmwskz = 'GI'.
          segtab-zzcgst = ( gs_ekbe-dmbtr * 9 ) / 100.
          segtab-zzsgst = ( gs_ekbe-dmbtr * 9 ) / 100.
        ENDIF.

        IF segtab-zzmwskz = 'GJ'.
          segtab-zzcgst = ( gs_ekbe-dmbtr * 14 ) / 100.
          segtab-zzsgst = ( gs_ekbe-dmbtr * 14 ) / 100.
        ENDIF.

        IF segtab-zzmwskz = 'XC'.
          segtab-zzcgst = ( gs_ekbe-dmbtr * 9 ) / 100.
          segtab-zzsgst = ( gs_ekbe-dmbtr * 9 ) / 100.
        ENDIF.
**=============================CGST SGST IGST================================================

        LOOP AT gt_ekko INTO gs_ekko.
          READ TABLE gt_ekko INTO gs_ekko WITH KEY ebeln = segtab-ebeln bukrs = segtab-bukrs.
          segtab-zzknumv = gs_ekko-knumv.

        ENDLOOP.

        LOOP AT gt_lfa1 INTO gs_lfa1.
          READ TABLE gt_lfa1 INTO gs_lfa1 WITH KEY lifnr = gs_ekko-lifnr.
          segtab-zzlifnr = gs_lfa1-lifnr.
          segtab-zzname1 = gs_lfa1-name1.
        ENDLOOP.


**  LOOP AT GT_KONV INTO GS_KONV.
***    IF GS_KONV-KPOSN = SEGTAB-EBELP.
**    IF GS_KONV-KNUMV = SEGTAB-ZZKNUMV.
        READ TABLE gt_konv INTO gs_konv WITH KEY knumv = segtab-zzknumv.      "GS_EKKO-KNUMV.
*        SEGTAB-ZZGSTAMT = GS_KONV-KBETR.
        IF gs_konv-kschl = 'ZFRB'.
          segtab-zzkawrt = gs_konv-kwert.         "value base
        ELSEIF gs_konv-kschl = 'ZFRC'.
          segtab-zzkbetr = gs_konv-kwert.         "quantity base
        ENDIF.

*     ENDIF.
*  ENDLOOP.

        LOOP AT gt_bkpf[] INTO gs_bkpf.
          READ TABLE gt_bkpf INTO gs_bkpf WITH KEY belnr = gs_bkpf-belnr.
          segtab-fibel = gs_bkpf-belnr.
        ENDLOOP.
      ENDIF.
    ENDIF.


    MODIFY segtab.
    " delete segtab where zzelikz = 'X'.
    CLEAR: gs_lfbw, gs_t059zt, gs_mseg, gs_mkpf, gs_po_data, gs_essr, gs_lfa1, gs_ekbe, lv_gst, wa_eskl, wa_eslh .
  ENDLOOP.
********************ADDED BY PRIMUS JYOTI ON 26.03.2024*************
  LOOP AT it_mseg_102 INTO DATA(wa_mseg_102) .
    IF wa_mseg_102-bwart = '102'.
      DELETE segtab WHERE lfbnr = wa_mseg_102-smbln.

    ENDIF.

  ENDLOOP.
*****************************************************************
*
  DELETE segtab WHERE zzbwart is INITIAL.

********************ENDED BY RANI E.*********************
***************added by shreya 101977****************
  IF NOT segtab[] IS INITIAL.

*    IF B_LBLNI IS NOT INITIAL.
*      DELETE SEGTAB WHERE ZZLBLNI .

    IF segtab[] IS INITIAL.
      MESSAGE 'No Data Found' TYPE 'E'.
    ENDIF.
  ENDIF.
*  ENDIF.
***************added end by shreya 101977****************

*****************************commeted by jyoti pon 16.01.2024*****************
  " ---------------- added by anish on 26.05.2023 ----------------"
*Deleivery complete po should not display in report.

*  IF SEGTAB[] IS NOT INITIAL.
*
**    SELECT FROM EKPO
**           FIELDS EBELN,EBELP,ELIKZ
**    FOR ALL ENTRIES IN @SEGTAB
**    WHERE EBELN EQ @SEGTAB-EBELN
**    AND   EBELP EQ @SEGTAB-EBELP
**    AND   ELIKZ EQ @ABAP_TRUE
**    INTO TABLE @DATA(LT_EKPO).
*
*  SELECT FROM EKPO AS A INNER JOIN EKBE AS B
*                   ON A~EBELN EQ B~EBELN AND A~EBELP EQ B~EBELP
*  FIELDS A~EBELN,A~EBELP,A~MENGE,
*         B~MENGE AS EKBE_MENGE
*  FOR ALL ENTRIES IN @SEGTAB
*  WHERE A~EBELN EQ @SEGTAB-EBELN
*  AND   A~EBELP EQ @SEGTAB-EBELP
*  AND   B~BEWTP EQ 'Q'
*  INTO TABLE @DATA(LT_EKPO_EKBE).
*
*  IF LT_EKPO_EKBE[] IS NOT INITIAL.
*    SORT LT_EKPO_EKBE[] BY EBELN EBELP ASCENDING.
*    DELETE ADJACENT DUPLICATES FROM LT_EKPO_EKBE[] COMPARING ALL FIELDS.
*
*    LOOP AT LT_EKPO_EKBE ASSIGNING FIELD-SYMBOL(<FS_EKBE>).
*      IF <FS_EKBE>-MENGE EQ <FS_EKBE>-EKBE_MENGE.
*        DELETE SEGTAB[] WHERE EBELN EQ <FS_EKBE>-EBELN AND EBELP = <FS_EKBE>-EBELP.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
**
**
*  IF SEGTAB[] IS INITIAL.
*    MESSAGE 'No Data Found' TYPE 'E'.
*    LEAVE TO SCREEN 0.
*  ENDIF.
*
*  REFRESH LT_EKPO_EKBE.

*****************************commeted by jyoti pon 16.01.2024
  "----------------------------------------------------------------"

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_buffer_active          = space
      i_callback_program       = c_repid
      i_callback_pf_status_set = c_pf_status_set
      i_callback_user_command  = c_user_command
      i_structure_name         = 'SEGTAB'
      it_fieldcat              = tab_fieldcat[]
      it_sort                  = tab_sort[]
      is_layout                = s_layout
      i_save                   = c_save
      is_variant               = s_variant
      it_events                = tab_events[]
    TABLES
      t_outtab                 = segtab.


  CALL TRANSACTION 'ZMRRL' .

ENDFORM.                               "PROTOKOLLAUSGABE
*eject
*---------------------------------------------------------------------*
*       FORM RECHNUNGSPRUEFUNG_DATEN                                  *
*---------------------------------------------------------------------*
*   Die Tabelle PTX_SEGTAB, die die gemeinsam abzurechnenden Po-      *
*   sitionen enthält, wird bearbeitet. Gemeinsam abzurechnende Posi-  *
*   tionen haben die gleiche Blocknummer.                             *
*   Mit Hilfe der Tabelle PTI_ERW_EKRS können die zu löschenden EKRS- *
*   Sätze aufgebaut werden.                                           *
*  Bemerkung: Eine Bearbeitung ist nur im Echtmodus erforderlich!     *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-> PTX_SEGTAB: Tabelle des Typs MMERS_TSEGTAB                      *
* --> PTI_ERW_EKRS: Tabelle des Typs TAB_ERW_EKRS                     *
*---------------------------------------------------------------------*
FORM rechnungspruefung_daten TABLES ptx_segtab TYPE mmers_tsegtab
                                    pti_erw_ekrs TYPE tab_erw_ekrs
                                    pti_ekrsdc TYPE typ_tekrsdc.

*---- lokale Hilfsfelder:
  DATA: erste_schleife       TYPE c,         "erstes Betreten?
        schleife_durchlaufen TYPE c,   "Schleife durchlaufen?
        last_blocknr         TYPE i,           "zuletzt bearbeitete Blocknr.
        akt_blocknr          TYPE i,            "aktuelle Blocknr.
        xrech                TYPE mrm_rbkpv-xrech,    "Kezi, ob Rechnung gebucht wird
        abrechenbar          TYPE c.

*----- erster Satz mit der aktuell zu bearbeitenden Blocknr: ---------*
  DATA: first_segtab_satz TYPE mmers_segtab.

*--- Tabelle mit den WE's, die gemeinsam abgerechnet werden:       ---*
  DATA: BEGIN OF selwenr OCCURS 1.
      INCLUDE STRUCTURE ek08erswe.
  DATA: END OF selwenr.

*------- Tabelle mit den zu löschenden EKRS-Sätzen -------------------*
  DATA: BEGIN OF lekrs OCCURS 1.
      INCLUDE STRUCTURE ekrs.
  DATA: END OF lekrs.

*------- Tabelle mit den zu löschenden EKRSDC-Sätzen -----------------*
  DATA: BEGIN OF t_ekrsdc_del OCCURS 1.
      INCLUDE STRUCTURE ekrsdc.
  DATA: END OF t_ekrsdc_del.

*--- Tabelle mit den WE's, die gemeinsam abgerechnet werden:       ---*
  DATA: BEGIN OF t_settle_dc OCCURS 1.
      INCLUDE STRUCTURE ek08ersdc.
  DATA: END OF t_settle_dc.
  DATA: s_settle_dc TYPE ek08ersdc.

  DATA: gv_zzpost TYPE mmers_segtab OCCURS 0.

*--- Initialisierung der Hilfsfelder:
  CLEAR: schleife_durchlaufen, last_blocknr, xrech.
  REFRESH: lekrs, selwenr.
  REFRESH: t_ekrsdc_del, t_settle_dc.
  MOVE 'X' TO erste_schleife.

  SORT ptx_segtab BY blocknr ebeln ebelp xekbz lfgja lfbnr lfpos.
  gv_zzpost[] = ptx_segtab[].
  EXPORT gv_zzpost  FROM ptx_segtab TO MEMORY ID 'ZZPO'.

  DATA(lt_segtab) = ptx_segtab[]. "added by PW on 07-09-23
*  SORT ptx_segtab BY lfbnr.
*  DELETE ADJACENT DUPLICATES FROM ptx_segtab COMPARING lfbnr.

*BREAK primusabap.
  LOOP AT ptx_segtab.
    IF ptx_segtab-blocknr NE last_blocknr. "Wechselkrit. erfüllt:
      IF erste_schleife = 'X'.         "Sonderfall erster Durchlauf:
         DELETE ADJACENT DUPLICATES FROM t_ekrsdc_del[] COMPARING ALL FIELDS.
        DELETE ADJACENT DUPLICATES FROM lekrs[] COMPARING ALL FIELDS.
        PERFORM initialisierung_reprue TABLES   lekrs
                                                selwenr
                                                t_ekrsdc_del
                                                t_settle_dc
                                       USING    ptx_segtab   "Struktur !
                                       CHANGING abrechenbar
                                                akt_blocknr
                                                first_segtab_satz.
        MOVE space TO erste_schleife.
        MOVE 'X' TO schleife_durchlaufen.
        MOVE ptx_segtab-blocknr TO last_blocknr.
        MOVE ptx_segtab-xrech TO xrech."Wert ist in einem Block ident.
      ELSE.                            "zumindest zweiter Durchlauf:
*---------- zuerst: Abschlußarbeiten:
        DELETE ADJACENT DUPLICATES FROM t_ekrsdc_del[] COMPARING ALL FIELDS.
        DELETE ADJACENT DUPLICATES FROM lekrs[] COMPARING ALL FIELDS.
        PERFORM anstossen_reprue TABLES   ptx_segtab
                                          lekrs
                                          selwenr
                                          t_ekrsdc_del
                                          t_settle_dc
                                 USING    abrechenbar
                                          akt_blocknr
                                          xrech
                                          b_xtest
                                 CHANGING first_segtab_satz.
*---------- anschließend: Initialisierung:
        PERFORM initialisierung_reprue TABLES   lekrs
                                                selwenr
                                                t_ekrsdc_del
                                                t_settle_dc
                                       USING    ptx_segtab  "Struktur !
                                       CHANGING abrechenbar
                                                akt_blocknr
                                                first_segtab_satz.
        MOVE ptx_segtab-blocknr TO last_blocknr.
        MOVE ptx_segtab-xrech TO xrech."Wert ist in einem Block ident.
      ENDIF.
    ENDIF.
*    BREAK PRIMUSABAP.
    LOOP AT lt_segtab INTO DATA(ls_segtab). "added by PW on 07-09-2023
*    LOOP AT lt_segtab INTO DATA(ls_segtab) ."WHERE LFBNR EQ first_segtab_satz-LFBNR."WHERE EBELN EQ first_segtab_satz-EBELN
*                                           AND LFBNR EQ first_segtab_satz-LFBNR. "added by PW on 07-09-2023
*      On CHANGE OF first_segtab_satz-LFBNR.
      ptx_segtab = ls_segtab.
      PERFORM aufbau_reprue TABLES pti_erw_ekrs
                                   selwenr
                                   lekrs
                                   pti_ekrsdc
                                   t_settle_dc
                                   t_ekrsdc_del
                            USING ptx_segtab "Struktur !
                                  abrechenbar.

      CLEAR: ls_segtab .
*      endon.

    ENDLOOP.

  ENDLOOP.
  IF schleife_durchlaufen = 'X'.
    PERFORM anstossen_reprue TABLES   ptx_segtab
                                      lekrs
                                      selwenr
                                      t_ekrsdc_del
                                      t_settle_dc
                             USING    abrechenbar
                                      akt_blocknr
                                      xrech
                                      b_xtest
                             CHANGING first_segtab_satz.
  ENDIF.

ENDFORM.                               "RECHNUNGSPRUEFUNG_DATEN
*eject
*---------------------------------------------------------------------*
*       FORM REPORT_INIT                                              *
*---------------------------------------------------------------------*
*       Initialisieren der Variablen und internen Tabellen            *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* <-- PTO_BESTAB: Tabelle vom Typ TAB_BESTAB                          *
* <-- PTO_EKRS: Tabelle vom Typ TAB_ERW_EKRS                          *
* <-- PTO_EKBEL: Tabelle der Struktur EKBEL                           *
* <-- PTO_SEGTAB: Tabelle vom Typ MMERS_TSEGTAB                       *
* <-- PTO_EKKO_KEY: Tabelle der Struktur EKKO_KEY                     *
*---------------------------------------------------------------------*
FORM report_init TABLES pto_bestab TYPE tab_bestab
                        pto_ekrs TYPE tab_erw_ekrs
                        pto_ekbel STRUCTURE ekbel
                        pto_segtab TYPE mmers_tsegtab
                        pto_ekko_key STRUCTURE ekko_key
                        pto_ekrsdc TYPE typ_tekrsdc
                        pto_podata TYPE  typ_tpodata
                        pto_segtab_dc TYPE mmers_tsegtab.

  CLEAR: pto_bestab,
         pto_ekrs,
         pto_ekbel,
         pto_segtab,
         pto_ekko_key,
         pto_ekrsdc,
         pto_podata,
         pto_segtab_dc.
  REFRESH: pto_bestab,
           pto_ekrs,
           pto_ekbel,
           pto_segtab,
           pto_ekko_key,
           pto_ekrsdc,
           pto_podata,
           pto_segtab_dc.

  PERFORM get_ersba_text USING    ersba
                         CHANGING ersba_tx.

ENDFORM.                               "REPORT_INIT
*eject
*---------------------------------------------------------------------*
*       FORM SAMMLUNG_BESTELLPOSITIONEN                               *
*---------------------------------------------------------------------*
*  Sammlung der Bestellpositionen; da die WE-bezogene Rechnungsprü-   *
*  fung aktiv ist, wird pro Wareneingang eine Zeile erzeugt.          *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> PTI_EKRS: Tabelle vom Typ TAB_ERW_EKRS                          *
* <-- PTO_BESTAB: Tabelle vom Typ TAB_BESTAB                          *
*---------------------------------------------------------------------*
FORM sammlung_bestellpositionen TABLES pti_ekrs TYPE tab_erw_ekrs
                                       pto_bestab TYPE tab_bestab.

  LOOP AT pti_ekrs.
    pto_bestab-lifnr = pti_ekrs-lifnr. " eine Zeile pro Lieferant
    pto_bestab-ebeln = pti_ekrs-ebeln. " eine Zeile pro Bestellung
    pto_bestab-ebelp = pti_ekrs-ebelp. " eine Zeile pro Bestellpos.
    pto_bestab-lfbnr = pti_ekrs-lfbnr. " eine Zeile pro Referenzbeleg,
    pto_bestab-lfpos = pti_ekrs-lfpos. " d.h. pro Wareneingang
    pto_bestab-lfgja = pti_ekrs-lfgja.
    COLLECT pto_bestab.
  ENDLOOP.
  SORT pto_bestab.

ENDFORM.                               "SAMMLUNG_BESTELLPOSITIONEN
*---------------------------------------------------------------------*
*      Form  SORTTAB_BUILD
*---------------------------------------------------------------------*
* Liste in berechnebare und nicht berechenbare Bereiche teilen        *
*---------------------------------------------------------------------*
FORM sorttab_build TABLES tx_sort TYPE slis_t_sortinfo_alv.

  CLEAR tx_sort.
  tx_sort-fieldname = 'ABRECHENBAR'.
  tx_sort-up        = 'X'.
  tx_sort-subtot    = 'X'.
  APPEND tx_sort.

ENDFORM.                    "sorttab_build
*---------------------------------------------------------------------*
*       FORM TOP_OF_LIST                                              *
*---------------------------------------------------------------------*
* Listüberschriften am Anfang der Gesamtliste                         *
*---------------------------------------------------------------------*
FORM top_of_list.                                           "#EC CALLED

  DATA: tab_list_of_list TYPE slis_t_listheader, "Überschriftstabelle
        s_line           TYPE slis_listheader.

  CLEAR: tab_list_of_list, s_line.
  REFRESH: tab_list_of_list.

  s_line-typ  = 'S'.
  s_line-info = TEXT-001.              " Protokoll
  IF b_xtest = 'X'.
    s_line-key = TEXT-003.             " testmodus
  ENDIF.
  APPEND s_line TO tab_list_of_list.

  CLEAR s_line.
  s_line-typ  = 'H'.

*ENHANCEMENT-SECTION     top_of_list_01 SPOTS es_rmmr1mrs.
  CASE ersba.
    WHEN c_ersba_1.
      s_line-info = TEXT-v01.          "  ein Beleg pro Lieferant
    WHEN c_ersba_2.
      s_line-info = TEXT-v02.          "  ein Beleg pro Bestellung
    WHEN c_ersba_3.
      s_line-info = TEXT-v03.          " ein Beleg pro Bestellposition
    WHEN c_ersba_4.
      s_line-info = TEXT-v04.          " ein Beleg pro Materialbeleg
  ENDCASE.
*END-ENHANCEMENT-SECTION.
  APPEND s_line TO tab_list_of_list.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = tab_list_of_list.
ENDFORM.                    "top_of_list
*eject
*---------------------------------------------------------------------*
*       FORM UMSETZEN_XDELE_UPOS                                      *
*---------------------------------------------------------------------*
* REKURSIV genutzte Form-Routine !                                    *
* Aufgabe: Umsetzen des Feldes XDELE bei Positionen, die direkt oder  *
*          indirekt zu einer Hauptposition gehören.                   *
*          Eine Hauptposition ist dabei eine Position, zu der unter-  *
*          geordnete Positionen gehören, die aber selbst keine unter- *
*          geordnete Position ist.                                    *
*          Eine übergeordnete Position ist eine Position zu der un-   *
*          tergeordnete Positionen gehören und die selbst eine unter- *
*          geordnete Position ist.                                    *
* Bemerkung: man beachte, wie SEGTAB vor Aufruf dieser Form-Routine   *
*            sortiert wurde.                                          *
*                                                                     *
*---------------------------------------------------------------------*
*   Parameter:                                                        *
* <-> ptx_segtab: Tabelle vom Type MMERS_TSEGTAB                      *
* --> pi_ABRECHENBAR: Kennzeichen, ob abrechenbar                     *
* --> pi_blocknr: intern vergebene Blocknummer                        *
* --> pi_ebeln: Nummer eines Einkaufsbeleges                          *
* --> pi_uebpo: Positionsnummer der übergeordneten Position, deren    *
*               untergeordnete Positionen geändert werden             *
* --> pi_lfgja: Geschäftsjahr eines Referenzbeleges                   *
* --> pi_lfbnr: Belegnummer eines Referenzbeleges                     *
* --> pi_xdele: Wert, den das zu ändernde Feld erhält                 *
* --> pi_pr_segtab: Struktur vom Typ MMERS_SEGTAB; zur Druckausgabe   *
*---------------------------------------------------------------------*
FORM umsetzen_xdele_upos TABLES t_segtab TYPE mmers_tsegtab
                         USING  i_segtab TYPE mmers_segtab.

  LOOP AT t_segtab WHERE abrechenbar = i_segtab-abrechenbar
                   AND   blocknr     = i_segtab-blocknr
                   AND   ebeln       = i_segtab-ebeln
                   AND   uptyp       = i_segtab-upvor
                   AND   lfgja       = i_segtab-lfgja
                   AND   lfbnr       = i_segtab-lfbnr.
    t_segtab-xdele = 'X'.
    MODIFY t_segtab.

    IF t_segtab-upvor NE space.
*--- Untergeordnete Position hat ebenfalls Unterpositionen:
      PERFORM umsetzen_xdele_upos TABLES t_segtab  "Rekursion !
                                  USING  t_segtab.
    ENDIF.
  ENDLOOP.

ENDFORM.                               "UMSETZEN_XDELE_UPOS
*eject
*---------------------------------------------------------------------*
*       Form  USER_COMMAND                                            *
*---------------------------------------------------------------------*
*   Reaktion auf Funktionscodes:                                      *
*    Bestellung anzeigen                                              *
*    Rechnungsbeleg anzeigen                                          *
*    Zeilen aus dem ERS ausschließen                                  *
*    Langtext der Meldungen anzeigen                                  *
*---------------------------------------------------------------------*
FORM user_command USING f_ucomm LIKE sy-ucomm
                  i_selfield TYPE slis_selfield.            "#EC CALLED

  DATA: f_answer,
        s_segtab TYPE mmers_segtab.
*BREAK-POINT.
  READ TABLE segtab INDEX i_selfield-tabindex INTO s_segtab.
  IF sy-subrc IS INITIAL.

    CASE f_ucomm.
      WHEN 'MB03'.
        CHECK NOT s_segtab-lfbnr IS INITIAL.
        IF s_segtab-pstyp = '9'.         " Leistungsbaltt
          SET PARAMETER ID 'BES' FIELD s_segtab-ebeln.
          SET PARAMETER ID 'LBL' FIELD s_segtab-lfbnr.
          SET PARAMETER ID 'LBD' FIELD 'X'.
*       CALL TRANSACTION 'ML82' AND SKIP FIRST SCREEN.
          CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
            EXPORTING
              tcode  = 'ML81N'
            EXCEPTIONS
              ok     = 1
              not_ok = 2
              OTHERS = 3.

          IF sy-subrc <> 1.
            MESSAGE e172(00) WITH 'ML81N'.
          ELSE.
            CALL TRANSACTION 'ML81N'.
          ENDIF.
        ELSE.
          SET PARAMETER ID 'MBN' FIELD s_segtab-lfbnr.
          SET PARAMETER ID 'MJA' FIELD s_segtab-lfgja.

          CALL FUNCTION 'MIGO_DIALOG'
            EXPORTING
              i_action            = 'A04'
              i_refdoc            = 'R02'
              i_notree            = 'X'
              i_skip_first_screen = 'X'
              i_deadend           = 'X'
              i_mblnr             = s_segtab-lfbnr
              i_mjahr             = s_segtab-lfgja.
        ENDIF.

      WHEN 'MELD'.
        PERFORM long_text_message_show USING s_segtab.

      WHEN 'ME23'.
        CALL FUNCTION 'MR_PO_DISPLAY'
          EXPORTING
            i_ebeln = s_segtab-ebeln.

      WHEN 'MR3M'.
        CHECK NOT s_segtab-rbelnr IS INITIAL.
        SET PARAMETER ID 'RBN' FIELD s_segtab-rbelnr.
        SET PARAMETER ID 'GJR' FIELD s_segtab-rgjahr.
        CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
          EXPORTING
            tcode  = tcode_mir4
          EXCEPTIONS
            ok     = 1
            not_ok = 2
            OTHERS = 3.

        IF sy-subrc <> 1.
          MESSAGE e172(00) WITH tcode_mir4.
        ELSE.
          CALL TRANSACTION tcode_mir4 AND SKIP FIRST SCREEN.
        ENDIF.

      WHEN 'FB03'.
        CHECK NOT s_segtab-fibel IS INITIAL.
        SET PARAMETER ID 'BLN' FIELD s_segtab-fibel.
        SET PARAMETER ID 'BUK' FIELD s_segtab-bukrs.
        SET PARAMETER ID 'GJR' FIELD s_segtab-rgjahr.
        CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
          EXPORTING
            tcode  = 'FB03'
          EXCEPTIONS
            ok     = 1
            not_ok = 2
            OTHERS = 3.

        IF sy-subrc <> 1.
          MESSAGE e172(00) WITH 'FB03'.
        ELSE.
          CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
        ENDIF.

      WHEN '&F03'.
        LEAVE SCREEN.

      WHEN 'STRG-S'.
*      LOOP AT segtab WHERE box = 'X' AND abrechenbar = space.
*        EXIT.
*      ENDLOOP.
*      IF sy-subrc = 0.
*        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'             "#EC FB_OLDED
*          EXPORTING
*            textline1 = text-p10
*            textline2 = text-p11
*            titel     = text-p01
*          IMPORTING
*            answer    = f_answer.
*
*        CASE f_answer.
*          WHEN 'A'.
*          WHEN 'J'.
*            LOOP AT segtab WHERE box = 'X' AND abrechenbar = space.
*              segtab-xdele = 'X'.
*              MODIFY segtab.
**---- Falls Hauptposition eines zusammengesetzten Artikels: Über-  --*
**---- nahme von XDELE auf die untergeordneten Positionen:          --*
*              IF segtab-upvor EQ '3' AND                " Leergut
*                 segtab-uebpo IS INITIAL.               " Hauptposition
*                PERFORM umsetzen_xdele_upos TABLES segtab
*                                            USING  segtab.
*
*              ENDIF.
*            ENDLOOP.
*
*            PERFORM ekrs_loeschen TABLES segtab
*                                         xerw_ekrs
*                                         tab_ekrsdc.
*            LEAVE LIST-PROCESSING.
*          WHEN 'N'.
*            LOOP AT segtab WHERE box = 'X'.
*              CLEAR segtab-box.
*              MODIFY segtab.
*            ENDLOOP.
*            i_selfield-refresh = 'X'.  " output of the List again
*        ENDCASE.
*      ENDIF.


*********ADDED BY RANI E 02082022************************
*          data lv_witht TYPE witht.
********************************************************
*BREAK primusabap.
        IF sy-tcode = 'ZMRRL'.
          DATA ref1 TYPE REF TO cl_gui_alv_grid.
          DATA : lv_index  TYPE sy-tabix,
                 lv_index1 TYPE sy-tabix,
                 lv_msg    TYPE string,
                 lv_msg1   TYPE string.
          CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
            IMPORTING
              e_grid = ref1.
          CALL METHOD ref1->check_changed_data.
          gt_segtab[] = segtab[].
*          DELETE SEGTAB[] WHERE BOX EQ SPACE.
          DELETE segtab[] WHERE zzcheck_b EQ space.
*          LOOP AT SEGTAB.
*            SEGTAB-BUDAT = BUDAT1-LOW.
*            MODIFY SEGTAB.
*          ENDLOOP. "Commented by PW on 16-05-2023

*          " --------------- ADDED BY ANISH ON 15.06.2023 FOR WITH HOLDING TAX --------------".
*          IF segtab-zzwitht IS NOT INITIAL.
*            EXPORT segtab-zzwitht TO MEMORY ID 'ZMRRL_TAX'.
*          ENDIF.
*          " -------------------------------------------------------------------------------"
          LOOP AT segtab.
            segtab-zzwitht = segtab-zzwitht.
            t059p-witht = segtab-zzwitht.
            lfbw-witht = segtab-zzwitht.
            MODIFY : segtab, t059p, lfbw.

          ENDLOOP.
*BREAK primusabap.
          PERFORM rechnungspruefung_daten TABLES segtab
                                               xerw_ekrs
                                               tab_ekrsdc.
* create ALV list

          PERFORM protokollausgabe TABLES segtab.
**************************************************************

*          LOOP AT SEGTAB WHERE BOX = 'X' AND ABRECHENBAR = SPACE.
          LOOP AT segtab WHERE zzcheck_b = 'X' AND abrechenbar = space."ADDED BY PRIMUS JYOTI ON27.03.2024
            EXIT.
          ENDLOOP.
          IF sy-subrc = 0.
            CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'             "#EC FB_OLDED
              EXPORTING
                textline1 = TEXT-p10
                textline2 = TEXT-p11
                titel     = TEXT-p01
              IMPORTING
                answer    = f_answer.

            CASE f_answer.
              WHEN 'A'.
              WHEN 'J'.
*                LOOP AT SEGTAB WHERE BOX = 'X' AND ABRECHENBAR = SPACE.
                LOOP AT segtab WHERE zzcheck_b = 'X' AND abrechenbar = space."ADDED BY PRIMUS JYOTI ON 27.03.2024
                  segtab-xdele = 'X'.
                  MODIFY segtab.
*---- Falls Hauptposition eines zusammengesetzten Artikels: Über-  --*
*---- nahme von XDELE auf die untergeordneten Positionen:          --*
                  IF segtab-upvor EQ '3' AND                " Leergut
                     segtab-uebpo IS INITIAL.               " Hauptposition
                    PERFORM umsetzen_xdele_upos TABLES segtab
                                                USING  segtab.

                  ENDIF.
                ENDLOOP.

                PERFORM ekrs_loeschen TABLES segtab
                                             xerw_ekrs
                                             tab_ekrsdc.
                LEAVE LIST-PROCESSING.
              WHEN 'N'.
*                LOOP AT SEGTAB WHERE BOX = 'X'.
                LOOP AT segtab WHERE zzcheck_b = 'X'.
*                  CLEAR SEGTAB-BOX.
                  CLEAR segtab-zzcheck_b.
                  MODIFY segtab.
                ENDLOOP.
                i_selfield-refresh = 'X'.  " output of the List again
            ENDCASE.
          ENDIF.
        ENDIF.
      WHEN '&SAL1'.
        IF SY-TCODE = 'ZMRRL'.
          LOOP AT SEGTAB.
            segtab-zzcheck_b = 'X'.
            MODIFY SEGTAB.
          ENDLOOP.
          i_selfield-refresh = 'X'.

        ENDIF.
       WHEN '&SAL2'.
        IF SY-TCODE = 'ZMRRL'.
          LOOP AT SEGTAB.
           CLEAR  segtab-zzcheck_b .
            MODIFY SEGTAB.
          ENDLOOP.
          i_selfield-refresh = 'X'.

        ENDIF.


      WHEN 'DISPLAY'.                    " Auf Doppelklick reagierien

        CASE i_selfield-sel_tab_field.

          WHEN 'SEGTAB-EBELN'.
            CALL FUNCTION 'MR_PO_DISPLAY'
              EXPORTING
                i_ebeln = s_segtab-ebeln.
          WHEN 'SEGTAB-LONGNUM'.

            CALL FUNCTION 'MR_PO_DISPLAY'
              EXPORTING
                i_ebeln = s_segtab-ebeln.


          WHEN 'SEGTAB-LFBNR'.
            CHECK NOT s_segtab-lfbnr IS INITIAL.
            IF s_segtab-pstyp = '9'.     " Leistungsbaltt
              SET PARAMETER ID 'BES' FIELD s_segtab-ebeln.
              SET PARAMETER ID 'LBL' FIELD s_segtab-lfbnr.
              SET PARAMETER ID 'LBD' FIELD 'X'.
              CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
                EXPORTING
                  tcode  = 'ML81N'
                EXCEPTIONS
                  ok     = 1
                  not_ok = 2
                  OTHERS = 3.

              IF sy-subrc <> 1.
                MESSAGE e172(00) WITH 'ML81N'.
              ELSE.
                CALL TRANSACTION 'ML81N'.
              ENDIF.
            ELSE.
              SET PARAMETER ID 'MBN' FIELD s_segtab-lfbnr.
              SET PARAMETER ID 'MJA' FIELD s_segtab-lfgja.

              CALL FUNCTION 'MIGO_DIALOG'
                EXPORTING
                  i_action            = 'A04'
                  i_refdoc            = 'R02'
                  i_notree            = 'X'
                  i_skip_first_screen = 'X'
                  i_deadend           = 'X'
                  i_mblnr             = s_segtab-lfbnr
                  i_mjahr             = s_segtab-lfgja.
            ENDIF.

          WHEN 'SEGTAB-LIFNR'.
            SET PARAMETER ID 'LIF' FIELD s_segtab-lifnr.
            SET PARAMETER ID 'KDY' FIELD '/110'.
            CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
              EXPORTING
                tcode  = 'MK03'
              EXCEPTIONS
                ok     = 1
                not_ok = 2
                OTHERS = 3.

            IF sy-subrc <> 1.
              MESSAGE e172(00) WITH 'MK03'.
            ELSE.
              CALL TRANSACTION 'MK03' AND SKIP FIRST SCREEN.
            ENDIF.

          WHEN 'SEGTAB-RBELNR'.
            CHECK NOT s_segtab-rbelnr IS INITIAL.
            SET PARAMETER ID 'RBN' FIELD s_segtab-rbelnr.
            SET PARAMETER ID 'GJR' FIELD s_segtab-rgjahr.
            CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
              EXPORTING
                tcode  = tcode_mir4
              EXCEPTIONS
                ok     = 1
                not_ok = 2
                OTHERS = 3.

            IF sy-subrc <> 1.
              MESSAGE e172(00) WITH tcode_mir4.
            ELSE.
              CALL TRANSACTION tcode_mir4 AND SKIP FIRST SCREEN.
            ENDIF.

          WHEN 'SEGTAB-TEXT'.
            PERFORM long_text_message_show USING s_segtab.

          WHEN 'SEGTAB-FIBEL'.
            CHECK NOT s_segtab-fibel IS INITIAL.
            SET PARAMETER ID 'BLN' FIELD s_segtab-fibel.
            SET PARAMETER ID 'BUK' FIELD s_segtab-bukrs.
            SET PARAMETER ID 'GJR' FIELD s_segtab-rgjahr.



            CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
              EXPORTING
                tcode  = 'FB03'
              EXCEPTIONS
                ok     = 1
                not_ok = 2
                OTHERS = 3.

            IF sy-subrc <> 1.
              MESSAGE e172(00) WITH 'FB03'.
            ELSE.
              CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
            ENDIF.

        ENDCASE.
************************ADDED BY PRIMUS JYOTI ON 28.03.2024******************************************
      WHEN '&IC1'.
*        BREAK primusabap.
*        READ TABLE SEGTAB[] INDEX I_SELFIELD-TABINDEX INTO DATA(S_SEGTAB_NEW).
        LOOP AT segtab[]  INTO DATA(s_segtab_new) WHERE zzcheck_b = 'X'.
          ON CHANGE OF s_segtab_new-lfbnr.
*            LOOP AT segtab[] ASSIGNING FIELD-SYMBOL(<lfs_segtab>) WHERE ebeln = s_segtab_new-ebeln
*                                                                  AND LFBNR = s_segtab_new-LFBNR
************************added by jyoti on  23.08.2024
           LOOP AT segtab[] ASSIGNING FIELD-SYMBOL(<lfs_segtab>) WHERE LFBNR = s_segtab_new-LFBNR .
*               ON CHANGE OF s_segtab_new-lfbnr.
              <lfs_segtab>-zzcheck_b = 'X'.
*               ENDON.
            ENDLOOP.
            CLEAR s_segtab_new.
            i_selfield-refresh = 'X'.


          ENDON.
**             --------------- ADDED BY ANISH ON 15.06.2023 FOR WITH HOLDING TAX --------------".
*          IF segtab-zzwitht IS NOT INITIAL.
*            EXPORT segtab-zzwitht TO MEMORY ID 'ZMRRL_TAX'.
*          ENDIF.
*          " -------------------------------------------------------------------------------"
        ENDLOOP.

       CASE i_selfield-sel_tab_field.

              WHEN 'SEGTAB-EBELN'.
                CALL FUNCTION 'MR_PO_DISPLAY'
                  EXPORTING
                    i_ebeln = s_segtab-ebeln.
              WHEN 'SEGTAB-LONGNUM'.

                CALL FUNCTION 'MR_PO_DISPLAY'
                  EXPORTING
                    i_ebeln = s_segtab-ebeln.


              WHEN 'SEGTAB-LFBNR'.
                CHECK NOT s_segtab-lfbnr IS INITIAL.
                IF s_segtab-pstyp = '9'.     " Leistungsbaltt
                  SET PARAMETER ID 'BES' FIELD s_segtab-ebeln.
                  SET PARAMETER ID 'LBL' FIELD s_segtab-lfbnr.
                  SET PARAMETER ID 'LBD' FIELD 'X'.
                  CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
                    EXPORTING
                      tcode  = 'ML81N'
                    EXCEPTIONS
                      ok     = 1                    not_ok = 2
                      OTHERS = 3.

                  IF sy-subrc <> 1.
                    MESSAGE e172(00) WITH 'ML81N'.
                  ELSE.
                    CALL TRANSACTION 'ML81N'.
                  ENDIF.
                ELSE.
                  SET PARAMETER ID 'MBN' FIELD s_segtab-lfbnr.
                  SET PARAMETER ID 'MJA' FIELD s_segtab-lfgja.

                  CALL FUNCTION 'MIGO_DIALOG'
                    EXPORTING
                      i_action            = 'A04'
                      i_refdoc            = 'R02'
                      i_notree            = 'X'
                      i_skip_first_screen = 'X'
                      i_deadend           = 'X'
                      i_mblnr             = s_segtab-lfbnr
                      i_mjahr             = s_segtab-lfgja.
                ENDIF.

              WHEN 'SEGTAB-LIFNR'.
                SET PARAMETER ID 'LIF' FIELD s_segtab-lifnr.
                SET PARAMETER ID 'KDY' FIELD '/110'.
                CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
                  EXPORTING
                    tcode  = 'MK03'
                  EXCEPTIONS
                    ok     = 1
                    not_ok = 2
                    OTHERS = 3.

                IF sy-subrc <> 1.
                  MESSAGE e172(00) WITH 'MK03'.
                ELSE.
                  CALL TRANSACTION 'MK03' AND SKIP FIRST SCREEN.
                ENDIF.

              WHEN 'SEGTAB-RBELNR'.
                CHECK NOT s_segtab-rbelnr IS INITIAL.
                SET PARAMETER ID 'RBN' FIELD s_segtab-rbelnr.
                SET PARAMETER ID 'GJR' FIELD s_segtab-rgjahr.
                CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
                  EXPORTING
                    tcode  = tcode_mir4
                  EXCEPTIONS
                    ok     = 1
                    not_ok = 2
                    OTHERS = 3.

                IF sy-subrc <> 1.
                  MESSAGE e172(00) WITH tcode_mir4.
                ELSE.
                  CALL TRANSACTION tcode_mir4 AND SKIP FIRST SCREEN.
                ENDIF.

              WHEN 'SEGTAB-TEXT'.
                PERFORM long_text_message_show USING s_segtab.

              WHEN 'SEGTAB-FIBEL'.
                CHECK NOT s_segtab-fibel IS INITIAL.
                SET PARAMETER ID 'BLN' FIELD s_segtab-fibel.
                SET PARAMETER ID 'BUK' FIELD s_segtab-bukrs.
                SET PARAMETER ID 'GJR' FIELD s_segtab-rgjahr.



                CALL FUNCTION 'AUTHORITY_CHECK_TCODE'             "2334943
                  EXPORTING
                    tcode  = 'FB03'
                  EXCEPTIONS
                    ok     = 1
                    not_ok = 2
                    OTHERS = 3.

                IF sy-subrc <> 1.
                  MESSAGE e172(00) WITH 'FB03'.
                ELSE.
                  CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
                ENDIF.



            ENDCASE.

    ENDCASE.

  ENDIF.
ENDFORM.                               "USER_COMMAND
*eject
*---------------------------------------------------------------------*
*       FORM WEITERE_SEGTAB_DATEN                                     *
*---------------------------------------------------------------------*
*       Ermittlung einiger Daten für Feld vom Typ T_SEGTAB:           *
*       Dabei gilt:                                                   *
*       a) keine Dienstleistungsposition, Lieferungsposition:         *
*          wemng > remng: xrech = 'X'                                 *
*          wemng < remng: xrech = space                               *
*          wemng = remng: xrech = 'X', Nullposition liegt vor         *
*       b) keine Dienstleistungsposition, Retoureposition:            *
*          wemng > remng: xrech = space                               *
*          wemng < remng: xrech = 'X'                                 *
*          wemng = remng: xrech = space, Nullposition liegt vor       *
*       c) Dienstleistungsposition:                                   *
*          xrech = 'X', falls Lieferungspos.                          *
*          xrech = space, falls Retourepos.                           *
*---------------------------------------------------------------------*
* Parameter:                                                          *
* --> pi_segtab: Typ MMERS_SEGTAB                                     *
* <-- pe_segtab: Typ MMERS_SEGTAB                                     *
*---------------------------------------------------------------------*
FORM weitere_segtab_daten USING pi_segtab TYPE mmers_segtab
                       CHANGING pe_segtab TYPE mmers_segtab
                                e_ekbe_rc TYPE i.

  DATA: BEGIN OF tab_belnr_lfbnr,
          belnr LIKE ekrs-belnr,       " GR document number
          lfbnr LIKE ekbe-lfbnr,       " Service Entry Sheet number
          lfgja LIKE ekbe-lfgja.       " Year of Service Entry Sheet
  DATA: END OF tab_belnr_lfbnr.

  DATA: t_goodsreceipts LIKE tab_belnr_lfbnr
                             OCCURS 0 WITH HEADER LINE,
        t_different_gr  LIKE tab_belnr_lfbnr
                             OCCURS 0 WITH HEADER LINE,
        f_count         TYPE i.

  DATA: s_essr LIKE essr.

  REFRESH: t_goodsreceipts,
           t_different_gr.

  IF pi_segtab-pstyp NE c_pstyp_9.     "keine Dienstleistung
    IF pi_segtab-retpo = space.        "Lieferungsposition
      IF pi_segtab-wemng NE pi_segtab-remng.
        IF pi_segtab-wemng > pi_segtab-remng.
          MOVE 'X' TO pe_segtab-xrech.
        ELSE.
          MOVE space TO pe_segtab-xrech.
        ENDIF.
      ELSE.                  "beiden Mengen gleich: Nullposition
        MOVE 'X' TO pe_segtab-xrech.
        MOVE 'X' TO pe_segtab-nullpos.
      ENDIF.
    ELSE.                              "Retoureposition
      IF pi_segtab-wemng NE pi_segtab-remng.
        IF pi_segtab-wemng > pi_segtab-remng.
          MOVE space TO pe_segtab-xrech.
        ELSE.
          MOVE 'X' TO pe_segtab-xrech.
        ENDIF.
      ELSE.                  "beiden Mengen gleich: Nullposition
        MOVE space TO pe_segtab-xrech.
        MOVE 'X' TO pe_segtab-nullpos.
      ENDIF.
    ENDIF.
  ELSE.                                "Dienstleistung
    CALL FUNCTION 'MS_READ_ENTRY_SHEET'
      EXPORTING
        i_lblni            = pe_segtab-lfbnr
        i_with_accounts    = ' '
        i_with_esll        = ' '
      IMPORTING
        e_essr             = s_essr
      EXCEPTIONS
        sheet_not_found    = 1
        account_not_found  = 2
        sheet_not_buffered = 3.
    IF sy-subrc = 0 .
      SELECT * FROM ekbe
        APPENDING CORRESPONDING FIELDS OF TABLE t_goodsreceipts
               WHERE  ebeln  = pe_segtab-ebeln
                 AND  ebelp  = pe_segtab-ebelp
                 AND  vgabe  = '1'
                 AND  lfbnr  = pe_segtab-lfbnr
                 AND  lfgja  = pe_segtab-lfgja.
      LOOP AT t_goodsreceipts.
        MOVE-CORRESPONDING t_goodsreceipts TO t_different_gr.
        COLLECT t_different_gr.
      ENDLOOP.
      DESCRIBE TABLE t_different_gr LINES f_count.
      f_count = f_count MOD 2.
      IF f_count IS INITIAL.
        IF s_essr-lemin = space.
          MOVE space TO pe_segtab-xrech.
        ELSE.
          MOVE 'X' TO pe_segtab-xrech.
        ENDIF.
      ELSE.
        IF s_essr-lemin = space.
          MOVE 'X' TO pe_segtab-xrech.
        ELSE.
          MOVE space TO pe_segtab-xrech.
        ENDIF.
      ENDIF.
    ELSE.
      MOVE 3 TO e_ekbe_rc.
    ENDIF.
  ENDIF.

ENDFORM.                               "WEITERE_SEGTAB_DATEN
*---------------------------------------------------------------------*
*      Form  GET_ERSBA_TEXT
*---------------------------------------------------------------------*
*       Datenelement-Text holen
*----------------------------------------------------------------------*
FORM get_ersba_text USING    if_ersba
                    CHANGING cf_ersba_tx.

  DATA: lf_value LIKE dd07v-domvalue_l,
        lf_text  LIKE dd07v-ddtext.

  lf_value = if_ersba.

  CALL FUNCTION 'GET_TEXT_DOMVALUE'
    EXPORTING
      domname   = 'ERSBA'
      domvalue  = lf_value
      langu     = sy-langu
    IMPORTING
      txt       = lf_text
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc EQ 0.
    cf_ersba_tx = lf_text.
  ENDIF.


ENDFORM.                               " GET_ERSBA_TEXT
*---------------------------------------------------------------------*
*      Form  F4_ERSBA
*---------------------------------------------------------------------*
FORM f4_ersba.
  DATA: lf_dynumb LIKE  sy-dynnr,
        lt_value  LIKE  ddshretval OCCURS 0 WITH HEADER LINE.

  lf_dynumb = sy-dynnr.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname           = 'RM08E'
      fieldname         = 'ERSBA'
      dynpprog          = c_repid
      dynpnr            = lf_dynumb
      dynprofield       = 'ERSBA'
      stepl             = 0
      callback_program  = c_repid
      callback_form     = 'F4CALLBACK_ERSBA'
    TABLES
      return_tab        = lt_value
    EXCEPTIONS
      field_not_found   = 1
      no_help_for_field = 2
      inconsistent_help = 3
      no_values_found   = 4
      OTHERS            = 5.

ENDFORM.                                                    " F4_ERSBA
*eject
*---------------------------------------------------------------------*
*      Form  f4callback_ersba
*---------------------------------------------------------------------*
FORM f4callback_ersba
        TABLES    record_tab   STRUCTURE  seahlpres
        CHANGING  shlp         TYPE       shlp_descr_t
                  callcontrol  LIKE       ddshf4ctrl.       "#EC *

  DATA: interface LIKE LINE OF shlp-interface.
  DATA: fieldprop LIKE LINE OF shlp-fieldprop.
  DATA: selopt LIKE LINE OF shlp-selopt.

  interface-valfield = 'ERSBA_TX'.
  MODIFY shlp-interface FROM interface
         TRANSPORTING valtabname valfield
         WHERE shlpfield = '_TEXT'.
  fieldprop-shlpoutput = 'X'.
  MODIFY shlp-fieldprop FROM fieldprop
         TRANSPORTING shlpoutput
         WHERE fieldname = '_TEXT'.
  selopt-shlpname = '_HIGH'.
  APPEND selopt TO shlp-selopt.

  IF pa_tm NE abap_true.                   " ERP Ehp5e TM
    selopt-shlpname  = 'ERSBA'.
    selopt-shlpfield = '_LOW'.
    selopt-sign      = 'I'.
    selopt-option    = 'BT'.
    selopt-low       = '1'.
    selopt-high      = '5'.
    APPEND selopt TO shlp-selopt.
  ELSE.
    selopt-shlpname  = 'ERSBA'.
    selopt-shlpfield = '_LOW'.
    selopt-sign      = 'I'.
    selopt-option    = 'BT'.
    selopt-low       = '6'.
    selopt-high      = '7'.
    APPEND selopt TO shlp-selopt.
  ENDIF.


ENDFORM.                               " f4callback_ERSBA

*&---------------------------------------------------------------------*
*&      Form  VARIANT_INIT
*&---------------------------------------------------------------------*
FORM variant_init.

  CLEAR s_variant.
  s_variant-report = c_repid.

ENDFORM.                               " VARIANT_INIT
*&---------------------------------------------------------------------*
*&      Form  F4_VARIA
*&---------------------------------------------------------------------*
FORM f4_varia CHANGING cf_varia LIKE disvariant-variant.

  DATA: f_exit(1)   TYPE c.

  PERFORM variant_init.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = s_variant
      i_save     = c_save
*     it_default_fieldcat =
    IMPORTING
      e_exit     = f_exit
      es_variant = s_var_usr
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 2.
    MESSAGE ID sy-msgid TYPE 'S'      NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    IF f_exit = space.
      cf_varia = s_var_usr-variant.
    ENDIF.
  ENDIF.

ENDFORM.                                                    " F4_VARIA

*&---------------------------------------------------------------------*
*&      Form  tm_selection_screen
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM tm_selection_screen.
*  STATICS: lv_pa_tm       LIKE pa_tm.
  DATA: lv_pa_tm TYPE abap_bool.

  IF cl_ops_switch_check=>mm_sfws_tm( ) = abap_false.
    LOOP AT SCREEN.
      SEARCH screen-name FOR 'pa_tm'.
      IF sy-subrc EQ 0.
        screen-active = 0.
        screen-input  = 0.
        MODIFY SCREEN.
      ENDIF.
      SEARCH screen-group1 FOR 'TM'.
      IF sy-subrc EQ 0.
        screen-active = 0.
        screen-input  = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    CLEAR: b_tspid[],b_torid[], b_awbid[], b_bolid[], b_voyid[],b_flight[].
  ELSE.
    IF pa_tm = abap_true.                "ERP Ehp5e TM
      LOOP AT SCREEN.
        SEARCH screen-name FOR 'b_ebeln'.  "PO number
        IF sy-subrc EQ 0.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.
        SEARCH screen-name FOR 'b_ebelp'.  "PO item number
        IF sy-subrc EQ 0.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.
        SEARCH screen-name FOR 'b_budat'.  "Goods Receipt Posting Date
        IF sy-subrc EQ 0.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.
        SEARCH screen-name FOR 'b_mblnr'.  "Goods Receipt Document
        IF sy-subrc EQ 0.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.
        SEARCH screen-name FOR 'b_mjahr'.  "Fiscal Year of Goods Receipt
        IF sy-subrc EQ 0.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.


        SEARCH screen-name FOR 'p_ersdc'.  "Settle Good Items + Planned Delivery Costs
        IF sy-subrc EQ 0.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.
        SEARCH screen-name FOR 'b_lifnr'.  "Lieferant
        IF sy-subrc EQ 0.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
      CLEAR: b_ebeln[], b_ebelp[],  p_budat[], b_mblnr[], b_mjahr[], p_ersdc, b_lifnr[].
      "B_BUDAT[], B_MBLNR[], B_MJAHR[], P_ERSDC, B_LIFNR[].
    ELSE.
      LOOP AT SCREEN.
        SEARCH screen-group1 FOR 'TM'.
        IF sy-subrc EQ 0.
          screen-active = '0'.
          screen-input     = abap_false.
          screen-invisible = abap_true.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
      CLEAR: b_tspid[],b_torid[], b_awbid[], b_bolid[], b_voyid[],b_flight[].
    ENDIF.
  ENDIF.

  IMPORT lv_pa_tm FROM MEMORY ID 'ERS_TM_FLAG '.

  IF lv_pa_tm <> pa_tm.
    CLEAR: pa_varia.
    MESSAGE s107(m8_2).
    lv_pa_tm = pa_tm.
    EXPORT lv_pa_tm TO MEMORY ID 'ERS_TM_FLAG'.
  ENDIF.
ENDFORM.                    "tm_selection_screen

*---------------------------------------------------------------------*
*       FORM BEARBEITUNG_DIENSTLEISTUNG                               *
*---------------------------------------------------------------------*
*  Falls eine Dienstleistungsbestellung im Spiel ist, muss überprüft  *
*  werden, ob eine Abnahme zur Abrechnung vorliegt. Wenn für das Feld *
*  LFBNR der Tabelle XERW_EKRS mehrere Einträge vorliegen, dann       *
*  bedeutet jedes Pärchen von verschiedenen WE's eine Abnahme und     *
*  Rücknahme.                                                         *
*-- translation ------------------------------------------------------*
*  In case of a service PO we have to check wether we have an         *
*  acceptance. If the field LFBNR of table XERW_EKRS has multiple     *
*  entries, then a pair of different GR's means one accecptance and   *
*  one reset.
*---------------------------------------------------------------------*
* parameter:                                                          *
* -->  PTI_ERW_EKRS: table of type TAB_ERW_EKRS                       *
* <--> PTX_SEGTAB:   table of type MMERS_TSEGTAB                      *
*---------------------------------------------------------------------*
FORM bearbeitung_dienstleistung TABLES pti_erw_ekrs TYPE tab_erw_ekrs
                                       ptx_segtab   TYPE mmers_tsegtab.

  DATA: BEGIN OF tab_belnr_lfbnr,
          belnr LIKE ekrs-belnr,      " GR document number
          lfbnr LIKE ekbe-lfbnr.       " Service Entry Sheet number
  DATA: END OF tab_belnr_lfbnr.

  DATA: t_erw_ekrs_different_gr LIKE tab_belnr_lfbnr
                                     OCCURS 0 WITH HEADER LINE,
        t_invoices              LIKE tab_belnr_lfbnr
                                     OCCURS 0 WITH HEADER LINE,
        t_different_invoices    LIKE tab_belnr_lfbnr
                                     OCCURS 0 WITH HEADER LINE,
        f_identic               TYPE i,
        f_count                 TYPE i.

* delete same GR-numbers for the same Service Entry Sheet number
* (multiple GR line items for different account assignments are possible
*  within one Acceptance or one Reset)
  LOOP AT pti_erw_ekrs.
    MOVE-CORRESPONDING pti_erw_ekrs TO t_erw_ekrs_different_gr.
    COLLECT t_erw_ekrs_different_gr.
  ENDLOOP.

* even or odd number of GR's of the same Service Entry Sheet number
  LOOP AT ptx_segtab.
    IF ptx_segtab-pstyp = c_pstyp_9.
      CLEAR: f_identic,
             f_count.
      REFRESH: t_invoices,
               t_different_invoices.
      LOOP AT t_erw_ekrs_different_gr.
        IF t_erw_ekrs_different_gr-lfbnr = ptx_segtab-lfbnr.
          f_identic = f_identic + 1.
        ENDIF.
      ENDLOOP.

      SELECT belnr lfbnr FROM ekbe APPENDING TABLE t_invoices "V_776437
               WHERE  ebeln  = ptx_segtab-ebeln
                 AND  ebelp  = ptx_segtab-ebelp
                 AND  vgabe  = '2'
                 AND  lfbnr  = ptx_segtab-lfbnr
                 AND  lfgja  = ptx_segtab-lfgja.            "^_776437

      LOOP AT t_invoices.
        MOVE-CORRESPONDING t_invoices TO t_different_invoices.
        COLLECT t_different_invoices.
      ENDLOOP.
      DESCRIBE TABLE t_different_invoices LINES f_count.
      f_identic = f_identic - f_count.
*     ptx_segtab must not be deleted if there is no invoice available,
*     otherwise a revoked acceptance remains in table ekrs
      IF NOT f_count IS INITIAL.                            "<_776437
        f_identic = f_identic MOD 2.
        IF f_identic IS INITIAL.
          DELETE ptx_segtab.
        ENDIF.
      ENDIF.                                                "<_776437
    ENDIF.
  ENDLOOP.

ENDFORM.                               "BEARBEITUNG_DIENSTLEISTUNG
*ENHANCEMENT-POINT rmmr1mrs_12 SPOTS es_rmmr1mrs STATIC.

INCLUDE zrmmr1mrs_dc01.
