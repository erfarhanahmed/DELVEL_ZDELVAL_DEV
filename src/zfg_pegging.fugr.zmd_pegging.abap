* Include LM61BU01
*----------------------------------------------------------------------*
*  MD_PEGGING                                                          *
*                                                                      *
*  Hauptroutine zur Ermittlung des Bedarfsverursachers:                *
*  (1) Initialisierung der internen Tabellen                           *
*  (2) Das Ausgangsmaterial wird in die int.Tabelle der Stücklisten-   *
*      struktur aufgenommen. Diese wird benötigt um die beteiligten    *
*      Materialien später nach der Stücklistenstufe zu sortieren, um   *
*      die Netzplangraphik der Verursacherbeziehungen aufzubauen und   *
*      um zu protokollieren für welche Materialien die Bestands- und   *
*      Bedarfssituation ermittelt wurde.                               *
*  (3) Suchen des Verursachers zum angegebenen Dispo-Element           *
*----------------------------------------------------------------------*
FUNCTION ZMD_PEGGING.
*"----------------------------------------------------------------------
*"*"Global Interface:
*"  IMPORTING
*"     VALUE(EDELET) LIKE  MDPS-DELET DEFAULT 0000
*"     VALUE(EDELKZ) LIKE  MDPS-DELKZ
*"     VALUE(EDELNR) LIKE  MDPS-DEL12
*"     VALUE(EDELPS) LIKE  MDPS-DELPS DEFAULT 000000
*"     VALUE(EPLSCN) LIKE  MDKP-PLSCN DEFAULT 000
*"     VALUE(EMATNR) LIKE  MT61D-MATNR
*"     VALUE(EWERKS) LIKE  MT61D-WERKS
*"     VALUE(EBERID) LIKE  MT61D-BERID DEFAULT SPACE
*"     VALUE(EPLWRK) LIKE  PLAF-PLWRK DEFAULT SPACE
*"     VALUE(EPLAAB) LIKE  MDPS-PLAAB DEFAULT SPACE
*"     VALUE(EPLANR) LIKE  MDPS-PLANR DEFAULT SPACE
*"     VALUE(EVERTO) LIKE  MDPS-VERTO DEFAULT SPACE
*"     VALUE(DISPLAY_ONLY) LIKE  RM61M-BOOLEAN DEFAULT SPACE
*"     VALUE(EDELVR) LIKE  MDPS-DELVR DEFAULT SPACE
*"     VALUE(EDAT00) LIKE  MDPS-DAT00 DEFAULT 00000000
*"  TABLES
*"      IT_MDRQN STRUCTURE  MDRQ OPTIONAL
*"      EMDPSX STRUCTURE  MDPS OPTIONAL
*"  EXCEPTIONS
*"      ERROR
*"      NO_REQUIREMENTS_FOUND
*"      ORDER_NOT_FOUND
*"----------------------------------------------------------------------
  DATA: tfill TYPE i.
  DATA: lv_subrc LIKE sy-subrc,
        lv_werks LIKE mt61d-werks,
        lv_matnr LIKE mt61d-matnr,
        lv_berid LIKE mt61d-berid.
  DATA: lv_md09_no_alv TYPE c.

  "--------- interne Tabellen initialisieren ----------------------
  PERFORM z_initialize.
  gl_read_database = space.
  gl_entry_element = el_receipt.
  gl_display_only  = display_only.
  PERFORM z_init_mrparea.                                     "new SA 46a

  "--------- Protokollieren, daß Material bearbeitet --------------
*ENHANCEMENT-POINT MD_PEGGING_01 SPOTS ES_SAPLM61B.
  PERFORM z_root_bom_hirarchy USING ematnr ewerks eberid.

*--> authority check for initial element (note 620966)
  IF ewerks NE space.
    PERFORM z_check_authority_plant USING ewerks.
  ENDIF.

  "--------- Verursacher Suchen -----------------------------------
*ENHANCEMENT-SECTION     MD_PEGGING_02 SPOTS ES_SAPLM61B.
  IF edelkz = arbed.         "Wenn Auftragsreservierung
*    PERFORM read_reservation USING edelnr edelps ematnr ewerks eberid.
  ELSEIF edelkz = brbed.     "Bereitstellungsbedarf
*    PERFORM read_consignment_rqmt
*            USING edelnr edelps ematnr ewerks eberid.
  ELSEIF edelkz = skbed.     "Wenn Sekundärbedarf
*    PERFORM read_dep_rqmt USING edelnr edelps ematnr ewerks eberid.
  ELSEIF edelkz = smbed.     "Wenn Simulationsbedarf
*    PERFORM read_sim_rqmt USING edelnr edelps ematnr ewerks eberid.
* elseif edelkz = subed.     "Wenn Summensekundaerbedarf
*   perform read_sum_rqmt using edelnr edelps ematnr ewerks.
  ELSEIF edelkz = upabr.     "Wenn Simulations-Umlagerungsbedarf
*    PERFORM read_sim_trans_rqmt
*            USING edelnr edelps ematnr ewerks eberid.
  ELSEIF edelkz = uaabr.     "Wenn Banf-Abruf
*    PERFORM read_trans_rqmt_a
*            USING edelnr edelps edelet ematnr ewerks eberid.
  ELSEIF edelkz = ubabr.     "oder BestellAbruf
*    PERFORM read_trans_rqmt_b
*            USING edelnr edelps edelet ematnr ewerks eberid.
  ELSEIF edelkz = ulabr.     "oder LieferplanAbruf
*    PERFORM read_trans_rqmt_b
*            USING edelnr edelps edelet ematnr ewerks eberid.
  ELSEIF edelkz = prbed      "Wenn Prognosebedarf
  OR     edelkz = unbed.     "oder ungeplanter Bedarf
    MESSAGE e320(mf) RAISING error.
  ELSEIF edelkz = kdbed      "Wenn Kundenprimaerbedarf
  OR     edelkz = vbeda      "oder KundenAnfrage
  OR     edelkz = vbedb      "oder Angebot
  OR     edelkz = vbedc      "oder KundenAuftrag
  OR     edelkz = vbede      "oder Lieferplan
  OR     edelkz = vbedf      "oder Lieferplan ext. DL
  OR     edelkz = vbedg      "oder Kontrakt
  OR     edelkz = vbedi      "oder Kostenlose Lieferung
  OR     edelkz = vbedj      "oder Lieferung
  OR     edelkz = vbedz      "oder ungeprüfte Lieferung -AIP-
  OR     edelkz = vbedw.     "oder externer Kundenauftrag
    PERFORM z_read_sales_order
            USING edelnr edelps edelet ematnr ewerks eberid edelkz.
*  ELSEIF EDELKZ = BSANF.     "Direktbanf              "del SA46a DIB
*    PERFORM CHECK_DIRECT_PROCUREMENT_REQ
*            USING EDELNR EDELPS EMATNR EWERKS EBERID.
*  ELSEIF EDELKZ = BSEIN.     "Direktbestellung
*    PERFORM CHECK_DIRECT_PROCUREMENT_ORD
*            USING EDELNR EDELPS EDELET EMATNR EWERKS EBERID.
*  ELSEIF EDELKZ = LPEIN.     "Direktlieferplaneinteilung
*    PERFORM CHECK_DIRECT_PROCUREMENT_ORD
*            USING EDELNR EDELPS EDELET EMATNR EWERKS EBERID.
  ELSEIF edelkz = plauf      "Pauf mit Prod. in anderm Werk
  OR     edelkz = saauf
  OR     edelkz = feauf      "Fert mit Prod. in anderm Werk
  OR     edelkz = neauf
  OR     edelkz = ihauf
  OR     edelkz = barez.
    IF eplwrk <> ewerks AND eplwrk <> space.
      ewerks = eplwrk.
*      PERFORM zfind_receiving_plant_and_mat                  "note 406446
*              USING    edelnr edelps 0 edelkz               "
*              CHANGING lv_werks lv_berid lv_matnr lv_subrc. "
      IF lv_subrc EQ 0.                                    "
        eberid = lv_berid.                                 "
      ENDIF.                                               "note 406446
      gl_read_database = 'X'.
    ENDIF.
    IF NOT everto IS INITIAL.
      gl_read_database = 'X'.
    ENDIF.
  ELSEIF edelkz = mrbed.     "oder Umlagerungsreservierung
    IF edelvr = umres.                                      "SA 45A
*      PERFORM read_trans_reservation                        "SA 45A
*              USING edelnr edelps ematnr ewerks eberid.     "SA 45A
    ELSE.                                                   "SA 45A
      gl_entry_element = el_requirement.
    ENDIF.                                                  "SA 45A
  ELSEIF edelkz = ppbed.     "Planprimaerbedarf
    gl_entry_element = el_requirement.
    MESSAGE s320(mf).
  ENDIF.
*END-ENHANCEMENT-SECTION.

  IF gl_entry_element = el_receipt.
    PERFORM z_requirements_4_receipt
            USING ematnr ewerks eberid edelnr edelps edelet edelkz
                  eplaab eplanr edat00.
  ENDIF.

REFRESH it_mdrqn[].
it_mdrqn[] = MDRQX[].

DELETE it_mdrqn WHERE DELKZ <>  'VC' .

  DESCRIBE TABLE mdrqx LINES tfill.






ENDFUNCTION.
