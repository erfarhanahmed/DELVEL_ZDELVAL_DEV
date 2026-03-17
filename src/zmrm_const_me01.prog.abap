*&---------------------------------------------------------------------*
*&  Include           ZMRM_CONST_ME01
*&---------------------------------------------------------------------*


SET EXTENDED CHECK OFF.


CONSTANTS:

*----- Einkaufsbeleg

* Typ
  c_bstyp_best LIKE ekko-bstyp VALUE 'F',
  c_bstyp_lief LIKE ekko-bstyp VALUE 'L',

* Status to identify TM purchase orders                     "TM EhP5e
  c_statu_tm   TYPE ekko-statu VALUE 'T',

* Preisfindungsdatum
  c_meprf_wedatum LIKE ekpo-meprf VALUE '5',    " WE-Datum

* Unterpositionstypen
  c_uptyp_kein    LIKE ekpo-uptyp VALUE ' ',   "keine Unterposition
  c_uptyp_var     LIKE ekpo-uptyp VALUE '1',   "Variante (Sammelartikel)
  c_uptyp_natdrau LIKE ekpo-uptyp VALUE '2',   "NatRabatt, Draufgabe
  c_uptyp_leerg   LIKE ekpo-uptyp VALUE '3',   "Leergut
  c_uptyp_natdrei LIKE ekpo-uptyp VALUE '4',   "NatRabatt, Dreingabe
  c_uptyp_mpn     LIKE ekpo-uptyp VALUE '8',   "Herstellerteil 'A&D_MPN'

* Positionstypen in EKPO
  c_pstyp_0 LIKE ekpo-pstyp VALUE '0',          "Kundeneinzelbestellung
  c_pstyp_1 LIKE ekpo-pstyp VALUE '1',          "Blanket PO
  c_pstyp_5 LIKE ekpo-pstyp VALUE '5',          "Strecke
  c_pstyp_9 LIKE ekpo-pstyp VALUE '9',          "Dienstleistung
  c_pstyp_7 LIKE ekpo-pstyp VALUE '7',          "Umlagerung Nebenkosten

* Positionsnummer, Referenzbelegsfelder... initial
  ebelp_null LIKE ekpo-ebelp VALUE '00000',
  lfbnr_null LIKE ekbe-lfbnr VALUE  space ,
  lfgja_null LIKE ekbe-lfgja VALUE '0000',
  lfpos_null LIKE ekbe-lfpos VALUE '0000',


*----- Bestellentwicklung

* Typ
  c_bewtp_m LIKE ekbe-bewtp VALUE 'M',  " MR1M-Nebenkosten
  c_bewtp_n LIKE ekbe-bewtp VALUE 'N',  " MR1M-Nachbelastung
  c_bewtp_p LIKE ekbe-bewtp VALUE 'P',  " MR1M-Nebenkost.Nachbelastung
  c_bewtp_q LIKE ekbe-bewtp VALUE 'Q',  " MR1M-Rechnung
  c_bewtp_t LIKE ekbe-bewtp VALUE 'T',  " MR1M-Rechnung vorerfasst

* Vorgangsart
  c_vgabe_we LIKE ekbe-vgabe VALUE '1',  " Wareneingang
  c_vgabe_re LIKE ekbe-vgabe VALUE '2',  " Rechnung
  c_vgabe_na LIKE ekbe-vgabe VALUE '3',  " Nachbelastung
  c_vgabe_li LIKE ekbe-vgabe VALUE 'R',  " Lieferung
  c_vgabe_le LIKE ekbe-vgabe VALUE '9',  " Leistungserfassung
  c_vgabe_pa LIKE ekbe-vgabe VALUE 'P',  " vorerfaßte Rechnung
  c_vgabe_cl LIKE ekbe-vgabe VALUE 'L',  " parked invoice for contract  "EhP5 Contracts
  c_vgabe_ck LIKE ekbe-vgabe VALUE 'K',  " posted invoice for contract
  c_vgabe_cd LIKE ekbe-vgabe VALUE 'M',  " posted subsequent debit for contract
  c_vgabe_ld LIKE ekbe-vgabe VALUE 'N',  " posted subsequent debit for contract with limit PO
  c_vgabe_lo LIKE ekbe-vgabe VALUE 'O',  " posted invoice for contract with limit PO
  c_vgabe_lk LIKE ekbe-vgabe VALUE 'G',  " parked invoice for contract with limit PO

* Unplanned account assignment                                          "EhP5 Contracts
  c_zekkn_99 TYPE ekbe-zekkn VALUE '99', " counter for unplanned account assignment
*----- Einkaufsinfosatz

* Typ
  c_esokz_norm LIKE eine-esokz  VALUE '0', "Normal
  c_esokz_kons LIKE eine-esokz  VALUE '2', "Konsignation
" c_esokz_lohn LIKE eine-esokz  VALUE '3', "Lohnbearbeitung
  c_esokz_pipe LIKE eine-esokz  VALUE 'P'. "Pipeline


SET EXTENDED CHECK ON.
