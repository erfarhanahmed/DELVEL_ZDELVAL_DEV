*&---------------------------------------------------------------------*
*&      Form  Z_INITIALIZE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM z_initialize .
 CLEAR mdpsx. REFRESH mdpsx.
  CLEAR mdbom. REFRESH mdbom.
  CLEAR mdzux. REFRESH mdzux.
  CLEAR mdrqx. REFRESH mdrqx.
  CLEAR mdabx. REFRESH mdabx.
  CLEAR mdsbx. REFRESH mdsbx.
  CALL FUNCTION 'MD_CLEAR_MATERIALS'.
  CLEAR mt61d.                                              "HW 555256
  PERFORM z_init_message_store.
  gv_mrparea = gc_true.  "S4 always with MRP area
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_INIT_MESSAGE_STORE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM Z_INIT_MESSAGE_STORE .
CALL FUNCTION 'MESSAGES_INITIALIZE'
       EXPORTING
            COLLECT_AND_SEND = ' '
            RESET            = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_INIT_MRPAREA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM Z_INIT_MRPAREA .
gv_mrparea = gc_true.   "S4 always with MRP area
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_ROOT_BOM_HIRARCHY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_EMATNR  text
*      -->P_EWERKS  text
*      -->P_EBERID  text
*----------------------------------------------------------------------*
FORM Z_ROOT_BOM_HIRARCHY
  USING matnr LIKE mt61d-matnr
           werks LIKE mt61d-werks
           berid LIKE mt61d-berid.

  DATA: BEGIN OF bom.
      INCLUDE STRUCTURE mdbom.
  DATA: END OF bom.

  bom-this_matnr = matnr.
  bom-this_werks = werks.
  bom-this_berid = berid.
  bom-next_matnr = space.
  bom-next_werks = space.
* BOM-NEXT_BERID = BERID.                            "note 326280
  bom-next_berid = space.                            "note 326280
  bom-level      = 0.
  PERFORM z_collect_bom USING bom.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_COLLECT_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_BOM  text
*----------------------------------------------------------------------*
FORM Z_COLLECT_BOM  USING bom STRUCTURE mdbom.
DATA: BEGIN OF mdbomky,
          this_matnr LIKE marc-matnr,
          this_werks LIKE marc-werks,
          this_berid LIKE mt61d-berid,             "note 326280
          next_matnr LIKE marc-matnr,
          next_werks LIKE marc-werks,
          next_berid LIKE mt61d-berid,             "note 326280
        END OF mdbomky.
  DATA: level TYPE i.

  level  = bom-level.

  mdbomky-this_matnr = bom-this_matnr.
  mdbomky-this_werks = bom-this_werks.
  mdbomky-this_berid = bom-this_berid.             "note 326280
  mdbomky-next_matnr = bom-next_matnr.
  mdbomky-next_werks = bom-next_werks.
  mdbomky-next_berid = bom-next_berid.             "note 326280
  READ TABLE mdbom WITH KEY mdbomky BINARY SEARCH.
  CASE sy-subrc.
    WHEN '00'.
      IF level > mdbom-level.
        mdbom-level = level.
        MODIFY mdbom INDEX sy-tabix.
      ENDIF.
    WHEN '04'.
      mdbom = bom.
      INSERT mdbom INDEX sy-tabix.
    WHEN '08'.
      mdbom = bom.
      APPEND mdbom.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_CHECK_AUTHORITY_PLANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_EWERKS  text
*----------------------------------------------------------------------*
FORM Z_CHECK_AUTHORITY_PLANT  USING werks.
  AUTHORITY-CHECK OBJECT 'M_MTDI_ORG'
       ID 'MDAKT' FIELD 'A'
       ID 'WERKS' FIELD werks
       ID 'DISPO' DUMMY.
  IF sy-subrc > 0.
    MESSAGE e604(mf) WITH werks.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_READ_SALES_ORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_EDELNR  text
*      -->P_EDELPS  text
*      -->P_EDELET  text
*      -->P_EMATNR  text
*      -->P_EWERKS  text
*      -->P_EBERID  text
*      -->P_EDELKZ  text
*----------------------------------------------------------------------*
FORM Z_READ_SALES_ORDER
    USING delnr LIKE mdps-del12
           delps LIKE mdps-delps
           delet LIKE mdps-delet
           matnr LIKE mt61d-matnr
           werks LIKE mt61d-werks
           berid LIKE mt61d-berid
           delkz LIKE mdps-delkz.

  DATA: BEGIN OF mdrq.
      INCLUDE STRUCTURE mdrqx.
  DATA: END OF mdrq.
  DATA: BEGIN OF mdpsl.
      INCLUDE STRUCTURE mdps.
  DATA: END OF mdpsl.
  DATA: orderqty LIKE mdps-mng01.

  gl_entry_element = el_requirement.

  SELECT SINGLE * FROM vbep
         WHERE vbeln =    delnr
         AND   posnr =    delps
         AND   etenr =    delet.
  IF sy-subrc > 0.
    MESSAGE e320(mf) RAISING error.
  ENDIF.

  CALL FUNCTION 'MATERIAL_UNIT_CONVERSION'
    EXPORTING
      input                = vbep-cmeng       "Auftragsmenge
      kzmeinh              = 'X'              "Input in VRKME
      matnr                = matnr
      meinh                = vbep-vrkme
      meins                = vbep-meins
    IMPORTING
      output               = orderqty
    EXCEPTIONS
      conversion_not_found = 01
      input_invalid        = 02
      material_not_found   = 03
      meinh_not_found      = 04
      meins_missing        = 05
      no_meinh             = 06
      output_invalid       = 07
      overflow             = 08.
  IF sy-subrc > 0. orderqty = 0. ENDIF.

  CALL FUNCTION 'MD_READ_MATERIAL'
    EXPORTING
      ematnr = matnr
      ewerks = werks
      eberid = berid
    IMPORTING
      imt61d = mt61d
    EXCEPTIONS
      error  = 01.
  IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.

  CLEAR mdpsl.
  mdpsl-delkz = delkz.
  mdpsl-delnr = delnr.
  mdpsl-delps = delps.
  mdpsl-delet = delet.
  mdpsl-baugr = matnr.
  mdpsl-dat00 = vbep-mbdat.
  mdpsl-dat01 = vbep-mbdat.
  mdpsl-mng01 = orderqty.
  mdpsl-baart = vbep-bdart.
  PERFORM z_store_entry_requirement USING mdpsl matnr werks berid.

  CLEAR mdrq.
  mdrq-delnr = delnr.
  mdrq-delps = delps.
  mdrq-delkz = delkz.
  mdrq-matnr = matnr.
  mdrq-werks = werks.
  mdrq-berid = berid.
  mdrq-plaab = netpla.
  mdrq-baart = vbep-bdart.
  mdrq-dat00 = vbep-mbdat.
  mdrq-mng01 = orderqty.
  mdrq-rqmtx = 'X'.
  PERFORM z_collect_requirement USING mdrq.

  MESSAGE s320(mf).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_STORE_ENTRY_REQUIREMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MDPSL  text
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*----------------------------------------------------------------------*
FORM Z_STORE_ENTRY_REQUIREMENT
   USING mdps  STRUCTURE mdps
           matnr LIKE      mt61d-matnr
           werks LIKE      mt61d-werks
           berid LIKE      mt61d-berid.

  DATA: ls_dummy LIKE mdkp.

  CLEAR mdabx.
  mdabx-delnr = mdps-delnr.
  mdabx-delps = mdps-delps.
  mdabx-delet = mdps-delet.
  mdabx-delkz = mdps-delkz.
  mdabx-matnr = matnr.
  mdabx-werks = werks.
  mdabx-berid = berid.
  mdabx-dat00 = mdps-dat00.
  mdabx-mng01 = mdps-mng01.
  mdabx-baart = mdps-baart.
  IF mdps-delkz  <> savety_stock
  AND mdps-delkz <> transp_rqmt.
    CALL FUNCTION 'EXTRAKT_AUS_MDPSX_BILDEN'
      EXPORTING
        emdps     = mdps
        emdkp     = ls_dummy
        call_badi = xflag
      IMPORTING
        iextra    = mdabx-extra.
  ENDIF.
  APPEND mdabx.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_COLLECT_REQUIREMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MDRQ  text
*----------------------------------------------------------------------*
FORM Z_COLLECT_REQUIREMENT  USING VALUE(mdrq) STRUCTURE mdrqx.
DATA: BEGIN OF mdrqky,
          delnr LIKE mdzu-delnr,
          delps LIKE mdzu-delps,
          delet LIKE mdzu-delet,
          delkz LIKE mdzu-delkz,
          matnr LIKE mdzu-matnr,
          werks LIKE mdzu-werks,
          berid LIKE mdzu-berid,                     "note 326280
          plaab LIKE mdzu-plaab,
          planr LIKE mdzu-planr,
          dat00 LIKE mdzu-dat00,
          baart LIKE mdzu-baart,
          versb LIKE mdzu-versb.
  DATA: END OF mdrqky.

  "{ Begin ENHO /SAPMP/ORDCOMB_PP_SAPLM61B2 IS-MP-PP /SAPMP/ORDER_COMBINATION }
* mill 0001 jw 000810
  DATA: ty_fill(5) TYPE i.
   mdrqky-delnr = mdrq-delnr.
  mdrqky-delps = mdrq-delps.
  mdrqky-delet = mdrq-delet.
  mdrqky-delkz = mdrq-delkz.
  mdrqky-matnr = mdrq-matnr.
  mdrqky-werks = mdrq-werks.
  mdrqky-berid = mdrq-berid.                         "note 326280
  mdrqky-plaab = mdrq-plaab.
  mdrqky-planr = mdrq-planr.
  mdrqky-dat00 = mdrq-dat00.
  mdrqky-versb = mdrq-versb.
  mdrqky-baart = mdrq-baart.

  READ TABLE mdrqx WITH KEY mdrqky BINARY SEARCH.
  IF sy-subrc = 0.
    mdrqx-mng02 = mdrqx-mng02 + mdrq-mng02.
    MODIFY mdrqx INDEX sy-tabix.
  ELSEIF sy-subrc = 4.
    mdrqx = mdrq.
    INSERT mdrqx INDEX sy-tabix.
  ELSEIF sy-subrc = 8.
    mdrqx = mdrq.
    APPEND mdrqx.
  ENDIF.

IF hit_u = 'X'.
    DESCRIBE TABLE ct_mdrqx_u LINES ty_fill.
    IF ty_fill > 0.
      LOOP AT ct_mdrqx_u WHERE delkz IS INITIAL
                         AND   matnr IS INITIAL
                         AND   werks IS INITIAL.
        MOVE mdrq TO ct_mdrqx_u.
        MODIFY ct_mdrqx_u INDEX sy-tabix
                          TRANSPORTING delnr delps delet delkz
                                       matnr werks berid plaab
                                       planr plaab dat00 baart
                                       versb mng01 mng02 index
                                       alloc extra rqmtx.
      ENDLOOP.
      CLEAR ct_mdrqx_u.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_STORE_SY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM Z_STORE_SY_MESSAGE .
 DATA: MSGNO LIKE MESG-TXTNR.

  MSGNO = SY-MSGNO.

  CALL FUNCTION 'MESSAGE_STORE'
       EXPORTING
            ARBGB                   = SY-MSGID
            MSGTY                   = SY-MSGTY
            MSGV1                   = SY-MSGV1
            MSGV2                   = SY-MSGV2
            MSGV3                   = SY-MSGV3
            MSGV4                   = SY-MSGV4
*           TXTNR                   = MSGNO.               " note 810234
            TXTNR                   = MSGNO
        EXCEPTIONS
            MESSAGE_TYPE_NOT_VALID  = 0
            NOT_ACTIVE              = 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_REQUIREMENTS_4_RECEIPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_EMATNR  text
*      -->P_EWERKS  text
*      -->P_EBERID  text
*      -->P_EDELNR  text
*      -->P_EDELPS  text
*      -->P_EDELET  text
*      -->P_EDELKZ  text
*      -->P_EPLAAB  text
*      -->P_EPLANR  text
*      -->P_EDAT00  text
*----------------------------------------------------------------------*
FORM Z_REQUIREMENTS_4_RECEIPT
   USING matnr LIKE mt61d-matnr
           werks LIKE mt61d-werks
           berid LIKE mt61d-berid
           delnr LIKE mdps-del12
           delps LIKE mdps-delps
           delet LIKE mdps-delet
           delkz LIKE mdps-delkz
           plaab LIKE mdps-plaab
           planr LIKE mdps-planr
           dat00 LIKE mdps-dat00.

  DATA: index   LIKE sy-tabix,
        matnr1  LIKE mdzu-matnr,
        werks1  LIKE mdzu-werks,
        berid1  LIKE mdzu-berid,
        level0  TYPE i VALUE 0,
        qtyorig LIKE mdzu-mng01,
        qtyrest LIKE mdzu-mng01,
        subrc   LIKE sy-subrc.

DATA: BEGIN OF lt_afpo_u.
      INCLUDE STRUCTURE afpo.
  DATA: END OF lt_afpo_u.
  DATA: lv_qtyorig LIKE mdps-mng01,
        lv_delps   LIKE mdzu-delps,
        index_u    LIKE sy-tabix.
  PERFORM z_read_io_elements
          USING    matnr werks berid delnr delps delet delkz "879179
          CHANGING matnr1 werks1 berid1.

  "--------- Suchen Auftrag in Zu-/Abgängen -----------------------
  PERFORM z_read_receipt_ext
          USING    delnr delps delet delkz matnr werks berid
                   plaab planr dat00
          CHANGING mdzux subrc.
  IF subrc > 0.
    MESSAGE e527(61) RAISING order_not_found.
  ENDIF.

"{ Begin ENHO /SAPMP/ORDCOMB_PP_SAPLM61B2 IS-MP-PP /SAPMP/ORDER_COMBINATION }
* mill 0001 jw 000726
* Ursprungsauftrag bestimmen und Index an zusammengefassten
* Auftrag übergeben
  IF delkz = 'OM' OR delkz = 'MP'.
* zugehörigen Ursprungsauftrag lesen
    SELECT SINGLE * FROM afpo INTO lt_afpo_u
                    WHERE aufnr = delnr
                    AND   posnr = delps.
    READ TABLE mdzux WITH KEY delnr =  lt_afpo_u-mill_oc_aufnr_u
                              matnr =  lt_afpo_u-matnr.
    ct_mdzux_u = mdzux.
    ct_mdzux_u-level = level0.
    ct_mdzux_u-aufnr = delnr.
    ct_mdzux_u-posnr = delps.
    APPEND ct_mdzux_u.
* Index zu mdabx merken
    index = mdzux-index.
* Plannummer merken, da Einstiegselement
    IF mdzux-planr <> 0.
      eplanr = mdzux-planr.
      eplaab = mdzux-plaab.
    ENDIF.
* zusammengefassten Auftrag lesen und Index zufügen
    PERFORM z_read_receipt_ext
            USING    delnr delps delet delkz matnr werks berid
                     plaab planr dat00
            CHANGING mdzux subrc.
    index_u = sy-tabix.
    mdzux-index = index.
    mdzux-plaab = eplaab.
    mdzux-planr = eplanr.
    MODIFY mdzux INDEX index_u TRANSPORTING plaab planr index.
* Ursprungsauftag lesen
    READ TABLE mdzux WITH KEY delnr = ct_mdzux_u-delnr
                              delps = ct_mdzux_u-delps.
    CHECK subrc = 0.
* Index merken, um mdzux später nachzulesen
    index = sy-tabix.
    qtyorig = mdzux-mng01.

 PERFORM z_rqmts_4_receipts
            USING     mdzux-index qtyorig qtyorig level0
            CHANGING  qtyrest.

    IF qtyrest > 0.            "Teilmenge konnte nicht zugeordnet
* Ursprungsauftrag mit einlesen
* keine Überschußmenge auf dem Ursprungsauftrag
      qtyorig = 0.

      READ TABLE mdzux INDEX index.
      IF sy-subrc = 0.
* Ursprungsauftrag merken
        PERFORM z_store_excessive_order USING mdzux qtyorig.
* Ursprungsauftrag lesen
        READ TABLE ct_mdzux_u WITH KEY delnr = mdzux-delnr
                                       delps = mdzux-delps.
        IF sy-subrc = 0.
* zusammengefassten Auftrag aus mdzux lesen
          lv_delps =  ct_mdzux_u-posnr.
          READ TABLE mdzux WITH KEY delnr = ct_mdzux_u-aufnr
                                    delps = lv_delps.
* zusammengefassten Auftrag merken
          mdzux-mng01 = 0.
          PERFORM z_store_excessive_order USING mdzux qtyrest.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.
* bei zusammengefassten Aufträgen überspringen
  IF NOT ( delkz = 'OM' OR delkz = 'MP' ) .
    "{ End ENHO /SAPMP/ORDCOMB_PP_SAPLM61B2 IS-MP-PP /SAPMP/ORDER_COMBINATION }

    qtyorig = mdzux-mng01.
    index   = mdzux-index.

    "--------- Suchen Bedarfe zum Auftrag ---------------------------
    PERFORM z_rqmts_4_receipts
            USING    index qtyorig qtyorig level0
            CHANGING qtyrest.

    "--------- Weniger Bedarfe als Auftragsmenge: Rest merken -------
    IF qtyrest > 0.
      PERFORM z_read_receipt_ext
              USING    edelnr edelps edelet edelkz ematnr ewerks eberid
                       eplaab eplanr edat00
              CHANGING mdzux subrc.
      IF subrc = 0.
        PERFORM z_store_excessive_order USING mdzux qtyrest.
      ENDIF.
    ENDIF.
  ENDIF. "{ ENHO /SAPMP/ORDCOMB_PP_SAPLM61B2 IS-MP-PP /SAPMP/ORDER_COMBINATION }

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_READ_IO_ELEMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*      -->P_DELNR  text
*      -->P_DELPS  text
*      -->P_DELET  text
*      -->P_DELKZ  text
*      <--P_MATNR1  text
*      <--P_WERKS1  text
*      <--P_BERID1  text
*----------------------------------------------------------------------*
FORM Z_READ_IO_ELEMENTS
   USING    VALUE(matnr) LIKE mt61d-matnr
              VALUE(werks) LIKE mt61d-werks
              VALUE(berid) LIKE mt61d-berid
              VALUE(delnr) LIKE mdps-del12
              VALUE(delps) LIKE mdps-delps
              VALUE(delet) LIKE mdps-delet                  "note 879179
              VALUE(delkz) LIKE mdps-delkz
     CHANGING matnra       LIKE mt61d-matnr
              werksa       LIKE mt61d-werks
              berida       LIKE mt61d-berid.

  DATA: lv_subrc   TYPE i,
        lv_tfill   TYPE i,
        lv_rfcdest LIKE rfcdes-rfcdest,
        ls_cm61b   TYPE m61x_cm61b.

DATA: ls_pic_cm61m  LIKE cm61m.       "return structure for first part

 "---------- Vorraussetzungen pruefen ----------------------
  IF matnr IS INITIAL. EXIT. ENDIF.     "Verursacher = Netzauftrag

  "---------- Initialisierungen -----------------------------
  CLEAR mdpsx. REFRESH mdpsx.

  "---------- Meldung ausgeben ------------------------------
*  PERFORM progress_message USING '114' matnr werks lv_rfcdest.

"---------- Dispoparameter für Werk und Material lesen ----
  CALL FUNCTION 'MD_READ_PLANT'
    EXPORTING
      ewerks = werks
    IMPORTING
      icm61w = cm61w
      it399d = t399d
    EXCEPTIONS
      error  = 01.
  IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.

  CALL FUNCTION 'MD_READ_MATERIAL'
    EXPORTING
      ematnr = matnr
      ewerks = werks
      eberid = berid
    IMPORTING
      imt61d = mt61d
      icm61b = ls_cm61b
    EXCEPTIONS
      error  = 01.
  IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.
  "---------- Prüfen ob Dummymaterial ------------------------
  PERFORM z_check_if_dummy USING werks mt61d-sobsl CHANGING lv_subrc.
  IF lv_subrc = 0.
    matnra = matnr.
    werksa = werks.
    berida = berid.
  PERFORM z_find_receiving_plant_and_mat
            USING    delnr delps delet delkz                "note 879179
            CHANGING werks berid matnr lv_subrc.
 IF werks    IS INITIAL        "Im Auftrag steht fälschlicherweise
    OR matnr    IS INITIAL        "kein Material drin
    OR lv_subrc >  0.
      EXIT.
    ENDIF.
    IF matnr <> matnra        "Auftrag nicht fuer Dummy-
    OR werks <> werksa.       "baugruppe selbst
      PERFORM z_read_bom USING matnr werks berid CHANGING mdbom.
      IF sy-subrc = 0. EXIT. ENDIF.    "Schon vorhanden
      CALL FUNCTION 'MD_READ_MATERIAL'
        EXPORTING
          ematnr = matnr
          ewerks = werks
          eberid = berid
        IMPORTING
          imt61d = mt61d
          icm61b = ls_cm61b
        EXCEPTIONS
          error  = 01.
      IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.
    ENDIF.
  ENDIF.
  matnra = matnr.
  werksa = werks.
  berida = berid.
   "---------- authority check for plant (note 620966) ---------
  AUTHORITY-CHECK OBJECT 'M_MTDI_ORG'
       ID 'MDAKT' FIELD 'A'
       ID 'WERKS' FIELD werks
       ID 'DISPO' DUMMY.
  IF sy-subrc > 0.
    MESSAGE s604(mf) WITH werks . PERFORM z_store_sy_message.
    EXIT.
  ENDIF.

 "---------- Zu-/Abgaenge lesen -----------------------------
  DESCRIBE TABLE emdpsx LINES lv_tfill.
  IF  matnr  = ematnr
  AND werks  = ewerks
  AND berid  = eberid
  AND lv_tfill  > 0
  AND gl_read_database = space.
    LOOP AT emdpsx.
      mdpsx = emdpsx. APPEND mdpsx.
    ENDLOOP.
  ELSE.

    "{ Begin ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
*--> A&D 3.0 : check if material is mpn-mrp-set member -> if this is
*    true: switch to leading part first.
*--> PIC : new design in 4.6
    REFRESH gt_pic_parts.
    CLEAR : gv_pic_savmat, gv_pic_picid, gv_pic_lmatn.
*    IF NOT mt61d-picnum IS INITIAL OR NOT mt61d-imatn IS INITIAL.
      IF NOT gv_pic_picid IS INITIAL OR NOT gv_pic_lmatn IS INITIAL.
*      PERFORM pic_check_material USING    mt61d
*                                          ls_cm61b
*                                 CHANGING gv_pic_picid
*                                          gt_pic_parts
*                                          gv_pic_lmatn .

      IF gv_pic_lmatn <> matnr AND NOT gv_pic_picid IS INITIAL.
*--> reselect material data for leading part
        gv_pic_savmat = matnr.
        matnr = gv_pic_lmatn.
        CALL FUNCTION 'MD_READ_MATERIAL'
          EXPORTING
            ematnr = matnr
            ewerks = werks
            eberid = berid
          IMPORTING
            imt61d = mt61d
            icm61b = ls_cm61b
          EXCEPTIONS
            error  = 01.
        IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.
      ENDIF.
    ENDIF.
  CLEAR cm61x.
   IF eplscn <> '000'.
      cm61x-plauf = lfraz.     "Anzeige Langfristplanung
      cm61x-plscn = eplscn.
      cm61x-plobj = mdobjl.
      IF plsc-plscn = eplscn.
        cm61x-sbflg = plsc-sbflg.
      ELSE.
        SELECT SINGLE * FROM plsc WHERE plscn = eplscn.
        IF sy-subrc = 0.
          cm61x-sbflg = plsc-sbflg.
        ENDIF.
      ENDIF.
      CALL FUNCTION 'AUFBAUEN_MDPSX_ANZEIGEN_SIM'
        EXPORTING
          emt61d = mt61d        "Materialstamm Dispo-View
          ecm61x = cm61x        "Kennzeichen Dispolauf
          ecm61w = cm61w        "Planungswerk, Kalender
          ecm61b = ls_cm61b     "Dispobereich
          et399d = t399d        "Kennzeichen Werk
          eplsc  = plsc
          "{ Begin ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
        IMPORTING
          icm61m = ls_pic_cm61m " >>>> INSERT PIC 4.6a
          "{ End ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
        TABLES
          mdpsx  = mdpsx        "Dispo-Beleg
        EXCEPTIONS
          error  = 01.
      IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.
    ELSE.
      cm61x-plauf = peggo.     "Anzeige Bedarfs-/Bestandsliste
      cm61x-plobj = mdobjb.

      CALL FUNCTION 'AUFBAUEN_MDPSX_ANZEIGEN'
        EXPORTING
          emt61d = mt61d        "Materialstamm Dispo-View
          ecm61x = cm61x        "Kennzeichen Dispolauf
          ecm61w = cm61w        "Planungswerk, Kalender
          ecm61b = ls_cm61b     "Dispobereich
          et399d = t399d        "Kennzeichen Werk
          "{ Begin ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
        IMPORTING
          icm61m = ls_pic_cm61m " >>>> INSERT PIC 4.6a
          "{ End ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
        TABLES
          mdpsx  = mdpsx        "Dispo-Beleg
        EXCEPTIONS
          error  = 01.
      IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.
      "{ Begin ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
      "--> PIC : Get merged mdpsx for MPN MRP set and SUS Chain          "4.6a
*      IF ( ls_pic_cm61m-picid EQ '02'                               "Lpart
*      OR  ls_pic_cm61m-picid EQ '06' )                             "Seq_01
*      AND NOT gv_pic_picid IS INITIAL.      "original part is PIC relevant

      IF NOT gv_pic_picid IS INITIAL.      "original part is PIC relevant
*        PERFORM pic_merge_mdpsx_for_pegging CHANGING ls_pic_cm61m
*                                                     gt_pic_parts
*                                                     ls_cm61b
*                                                     sy-subrc.
        IF sy-subrc > 0. PERFORM z_store_sy_message. EXIT. ENDIF.
        IF NOT gv_pic_savmat IS INITIAL.
          matnr = gv_pic_savmat.
        ENDIF.
      ENDIF.
      "--> End of PIC 4.6a
      "{ End ENHO DIMP_GENERAL_SAPLM61B IS-AD-MPN-MRP AD_MPN_IC }
    ENDIF.
ENDIF.

  "----------- Sicherheitsbestand in MDPSX einfügen ---------
  IF  mt61d-eisbe > 0
  AND mt61d-mengu EQ xflag.                                 "note 503941
    IF eplscn = '000'.
      CLEAR mdpsx.
      mdpsx-plaab = netpla.       "Nettoplanungsabschnitt
      mdpsx-planr = space.        "Planungsabschnittsnummer
      mdpsx-delkz = savety_stock. "Sicherheitsbestand (LM61BTOP)
      mdpsx-vrfkz = 'X'.          "Bedarf berücksichtigen
      mdpsx-plumi = minus.        "Bedarf
      mdpsx-mng01 = mt61d-eisbe.  "Bedarfsmenge
      INSERT mdpsx INDEX 1.
    ELSE.
      IF eplscn <> plsc-plscn .
        SELECT SINGLE * FROM plsc WHERE plscn = eplscn.
        IF sy-subrc <> 0.
          CLEAR plsc.
        ENDIF.
      ENDIF.
*     Planning scenario with initial stock <> safety stock
*     Not to consider safety stock according to note 502408
      IF NOT ( NOT plsc-ltpls IS INITIAL AND
                   plsc-llskz = xflag    AND
                   plsc-sstck <> sstck-safety ) .
        CLEAR mdpsx.
        mdpsx-plaab = netpla.       "Nettoplanungsabschnitt
        mdpsx-planr = space.        "Planungsabschnittsnummer
        mdpsx-delkz = savety_stock. "Sicherheitsbestand (LM61BTOP)
        mdpsx-vrfkz = 'X'.          "Bedarf berücksichtigen
        mdpsx-plumi = minus.        "Bedarf
        mdpsx-mng01 = mt61d-eisbe.  "Bedarfsmenge
        INSERT mdpsx INDEX 1.
      ENDIF.
    ENDIF.
  ENDIF.

  "----------- Suchen Abgänge zu Zugängen -------------------
  PERFORM z_search_requirements_4_recipt
          USING matnr werks berid mt61d-disst.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_CHECK_IF_DUMMY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WERKS  text
*      -->P_MT61D_SOBSL  text
*      <--P_LV_SUBRC  text
*----------------------------------------------------------------------*
FORM Z_CHECK_IF_DUMMY  USING WERKS SOBSL CHANGING SUBRC.
  DATA: TABLE LIKE SY-TABID.

  IF SOBSL IS INITIAL.
    SUBRC = 1.
  ELSE.
    SELECT SINGLE * FROM T460A
           WHERE WERKS = WERKS
           AND   SOBSL = SOBSL.
    IF SY-SUBRC = 0.
      IF T460A-SOBES = SOBESV           "Vorplanung
      OR T460A-SOBES = SOBESD           "Dummy-Baugruppe
      OR T460A-SOBES = SOBESM           "Mehrstufige Fertigung
      OR T460A-CLCOR = 'X'              "Mehrstufige Fertigung neu
      OR T460A-DUMPS = 'X'.             "Dummy normal
        SUBRC = 0.
      ELSE.
        SUBRC = 1.
      ENDIF.
    ELSE.
      TABLE = 'T460A'.
      SET PARAMETER ID 'TAB' FIELD TABLE.
* Der Sonderbeschaffungsschlüssel '&1' ist im Werk &2 nicht definiert
*      MESSAGE e289 WITH SOBSL WERKS RAISING ERROR.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_FIND_RECEIVING_PLANT_AND_MAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_DELNR  text
*      -->P_DELPS  text
*      -->P_DELET  text
*      -->P_DELKZ  text
*      <--P_WERKS  text
*      <--P_BERID  text
*      <--P_MATNR  text
*      <--P_LV_SUBRC  text
*----------------------------------------------------------------------*
FORM Z_FIND_RECEIVING_PLANT_AND_MAT
   USING    delnr  LIKE mdps-del12
              delps  LIKE mdps-delps
              delet  LIKE mdps-delet
              delkz  LIKE mdps-delkz
     CHANGING werk2  LIKE mt61d-werks
              berid2 LIKE mt61d-berid
              matnr2 LIKE mt61d-matnr
              subrc  LIKE sy-subrc.

  DATA: ls_mdlv  LIKE mdlv,
        lv_lbear LIKE eban-emlif,
        lv_dbskz LIKE resb-dbskz.

  CLEAR: matnr2, werk2, berid2.
  subrc = 4.

  IF delnr EQ space.                              "note 550308
    EXIT.
  ENDIF.

CASE delkz.

    WHEN bsanf.          "Bestellanforderung
      SELECT SINGLE * FROM eban
             WHERE  banfn = delnr
             AND    bnfpo = delps.
      IF sy-subrc > 0.
        MESSAGE s017(mf) WITH delnr delps.  "Banf nicht vorhanden
        PERFORM z_store_sy_message. EXIT.
      ENDIF.
      werk2  = eban-werks.
      matnr2 = eban-matnr.
      IF gv_mrparea = gc_true.
*--> ggf. Lohnbearbeiter bei Strecken-Lohnb-Abwicklung ermittln
        IF NOT eban-lblkz IS INITIAL.
          MOVE eban-emlif TO lv_lbear.
        ELSE.
          CLEAR lv_lbear.
        ENDIF.
*--> Direktbeschaffungskennz. setzen
        IF NOT eban-arsnr IS INITIAL.
          MOVE xflag TO lv_dbskz.
        ELSE.
          CLEAR lv_dbskz.
        ENDIF.
        IF NOT eban-matnr IS INITIAL.               "note 202111
          CALL FUNCTION 'MD_MRP_AREA_GET'
            EXPORTING
              i_matnr   = eban-matnr
              i_werks   = eban-werks
              i_lgort   = eban-lgort
              i_sobkz   = eban-sobkz
              i_lbear   = lv_lbear
            IMPORTING
              e_db_mdlv = ls_mdlv.
          berid2 = ls_mdlv-berid.
        ENDIF.                                     "note 202111
      ENDIF.
      WHEN bsein.          "Bestellung
      SELECT SINGLE * FROM mdbs
             WHERE  ebeln = delnr
             AND    ebelp = delps
             AND    etenr = delet.
      IF sy-subrc > 0.
        MESSAGE s016(mf) WITH delnr delps.  "Bestellung nicht vorhanden
        PERFORM z_store_sy_message. EXIT.
      ENDIF.
 werk2  = mdbs-werks.
      matnr2 = mdbs-matnr.
      IF gv_mrparea = gc_true.
*--> ggf. Lohnbearbeiter bei Strecken-Lohnb-Abwicklung ermittln
        IF NOT mdbs-lblkz IS INITIAL.
          MOVE mdbs-emlif TO lv_lbear.
        ELSE.
          CLEAR lv_lbear.
        ENDIF.
*--> Direktbeschaffungskennz. setzen
        IF NOT mdbs-arsnr IS INITIAL.
          MOVE xflag TO lv_dbskz.
        ELSE.
          CLEAR lv_dbskz.
        ENDIF.
        IF  NOT mdbs-matnr IS INITIAL               "note 202111
        AND NOT mdbs-werks IS INITIAL.              "note 623890
          CALL FUNCTION 'MD_MRP_AREA_GET'
            EXPORTING
              i_matnr   = mdbs-matnr
              i_werks   = mdbs-werks
              i_lgort   = mdbs-lgort
              i_sobkz   = mdbs-sobkz
              i_lbear   = lv_lbear
            IMPORTING
              e_db_mdlv = ls_mdlv.
          berid2 = ls_mdlv-berid.
        ENDIF.                                     "note 202111
      ENDIF.
    WHEN lpein.          "Lieferplan
      SELECT SINGLE * FROM mdbs
             WHERE  ebeln = delnr
             AND    ebelp = delps
             AND    etenr = delet.
      IF sy-subrc > 0.
        MESSAGE s018(mf) WITH delnr delps.  "Lieferplan nicht vorhanden
        PERFORM z_store_sy_message. EXIT.
      ENDIF.
      werk2  = mdbs-werks.
      matnr2 = mdbs-matnr.
      IF gv_mrparea = gc_true.
*--> ggf. Lohnbearbeiter bei Strecken-Lohnb-Abwicklung ermittln
        IF NOT mdbs-lblkz IS INITIAL.
          MOVE mdbs-emlif TO lv_lbear.
        ELSE.
          CLEAR lv_lbear.
        ENDIF.
        IF NOT mdbs-matnr IS INITIAL.               "note 202111
          CALL FUNCTION 'MD_MRP_AREA_GET'
            EXPORTING
              i_matnr   = mdbs-matnr
              i_werks   = mdbs-werks
              i_lgort   = mdbs-lgort
              i_sobkz   = mdbs-sobkz
              i_lbear   = lv_lbear
            IMPORTING
              e_db_mdlv = ls_mdlv.
          berid2 = ls_mdlv-berid.
        ENDIF.                                     "note 202111
      ENDIF.
    WHEN feauf.          "Fertigungsauftrag
      SELECT SINGLE * FROM mdfa
             WHERE aufnr = delnr
             AND   posnr = 1.
      IF sy-subrc > 0.
        MESSAGE s015(mf) WITH delnr delps.  "Auftrag nicht vorhanden
        PERFORM z_store_sy_message. EXIT.
      ENDIF.
      IF mdfa-plwrk IS INITIAL.
        werk2 = mdfa-pwwrk.
      ELSE.
        werk2 = mdfa-plwrk.
      ENDIF.
      matnr2 = mdfa-matnr.
      IF gv_mrparea = gc_true.
*--> Auftragsnetzkennz. setzen
        IF NOT mdfa-arsnr IS INITIAL.
          MOVE xflag TO lv_dbskz.
        ELSE.
          CLEAR lv_dbskz.
        ENDIF.
        IF  NOT mdfa-matnr IS INITIAL
        AND NOT mdfa-plwrk IS INITIAL.                   "note 532098
          CALL FUNCTION 'MD_MRP_AREA_GET'
            EXPORTING
              i_matnr   = mdfa-matnr
              i_werks   = mdfa-plwrk
              i_lgort   = mdfa-lgort
              i_sobkz   = mdfa-sobkz
              i_dbskz   = lv_dbskz
            IMPORTING
              e_db_mdlv = ls_mdlv.
          berid2 = ls_mdlv-berid.
        ENDIF.                                            "new SA99a
      ENDIF.
WHEN plauf           "Planauftrag
    OR   saauf.          "Simulationsauftrag
      SELECT SINGLE * FROM plaf WHERE  plnum = delnr.
      IF sy-subrc > 0.
        MESSAGE s014(mf) WITH delnr.         "Planauftrag nicht da
        PERFORM z_store_sy_message. EXIT.
      ENDIF.
      werk2  = plaf-plwrk.
      matnr2 = plaf-matnr.
      berid2 = plaf-berid.
      IF  berid2    IS INITIAL
      AND gv_mrparea = gc_true.
*--> ggf. Lohnbearbeiter bei Strecken-Lohnb-Abwicklung ermittln
        IF NOT plaf-lblkz IS INITIAL.
          MOVE plaf-emlif TO lv_lbear.
        ELSE.
          CLEAR lv_lbear.
        ENDIF.
*--> Auftragsnetzkennz. setzen
        IF NOT plaf-arsnr IS INITIAL.
          MOVE xflag TO lv_dbskz.
        ELSE.
          CLEAR lv_dbskz.
        ENDIF.
        CALL FUNCTION 'MD_MRP_AREA_GET'
          EXPORTING
            i_matnr   = plaf-matnr
            i_werks   = plaf-plwrk
            i_lgort   = plaf-lgort
            i_sobkz   = plaf-sobkz
            i_vrpla   = plaf-vrpla
            i_lbear   = lv_lbear
            i_dbskz   = lv_dbskz
          IMPORTING
            e_db_mdlv = ls_mdlv.
        berid2 = ls_mdlv-berid.
      ENDIF.
    WHEN ulres.          "Umlagerungsreservierung
      SELECT SINGLE * FROM mdrs
             WHERE rsnum = delnr
             AND   rspos = delps
             AND   rsart = space.
      IF sy-subrc > 0.
        MESSAGE s028(mf) WITH delnr.         "Reservierung nicht da
        PERFORM z_store_sy_message. EXIT.
      ENDIF.
      IF      mdrs-shkzg =  shkzgh    "Wenn Abgang
      AND NOT mdrs-umwrk IS INITIAL.
        werk2  = mdrs-umwrk.          "Empfangendes Werk
        matnr2 = mdrs-matnr.
        IF gv_mrparea = gc_true.
          CALL FUNCTION 'MD_MRP_AREA_GET'
            EXPORTING
              i_matnr   = mdrs-matnr
              i_werks   = mdrs-umwrk
              i_lgort   = mdrs-umlgo
            IMPORTING
              e_db_mdlv = ls_mdlv.
          berid2 = ls_mdlv-berid.
        ENDIF.
      ENDIF.
    WHEN umres.                                                 "new
      SELECT SINGLE * FROM mdrs                                 "new
             WHERE rsnum = delnr                                "new
             AND   rspos = delps                                "new
             AND   rsart = space.                               "new
      IF sy-subrc > 0.                                          "new
        MESSAGE s028(mf) WITH delnr.         "Reservierung nicht da "new
        PERFORM z_store_sy_message. EXIT.                          "new
      ENDIF.                                                     "new
      IF      mdrs-shkzg =  shkzgh    "Wenn Abgang               "new
      AND NOT mdrs-umwrk IS INITIAL                              "new
      AND NOT mdrs-umlgo IS INITIAL.                             "new
        werk2  = mdrs-umwrk.                                     "new
        matnr2 = mdrs-matnr.                                     "new
        IF gv_mrparea = gc_true.                                 "new
          CALL FUNCTION 'MD_MRP_AREA_GET'                        "new
            EXPORTING
              i_matnr   = mdrs-matnr           "new
              i_werks   = mdrs-umwrk           "new
              i_lgort   = mdrs-umlgo           "new
            IMPORTING
              e_db_mdlv = ls_mdlv.             "new
          berid2 = ls_mdlv-berid.                               "new
        ENDIF.                                                  "new
      ENDIF.
    "{ Begin ENHO /SAPMP/ORDCOMB_PP_SAPLM61B IS-MP-PP /SAPMP/ORDER_COMBINATION }
* mill 0001 jw 000720
    WHEN omauf
      OR mpauf.           "Fertigungsauftrag
* entsprechend der Position einzulesen!
      SELECT SINGLE * FROM mdfa
             WHERE aufnr = delnr
             AND   posnr = delps.
      IF sy-subrc > 0.
        MESSAGE s015(mf) WITH delnr delps.    "Auftrag nicht vorhanden
        PERFORM z_store_sy_message. EXIT.
      ENDIF.
      IF mdfa-plwrk IS INITIAL.
        werk2 = mdfa-pwwrk.
      ELSE.
        werk2 = mdfa-plwrk.
      ENDIF.
      matnr2 = mdfa-matnr.
      IF gv_mrparea = gc_true.
*--> Auftragsnetzkennz. setzen
        IF NOT mdfa-arsnr IS INITIAL.
          MOVE xflag TO lv_dbskz.
        ELSE.
          CLEAR lv_dbskz.
        ENDIF.
        IF  NOT mdfa-matnr IS INITIAL
        AND NOT mdfa-plwrk IS INITIAL.                   "note 532098
          CALL FUNCTION 'MD_MRP_AREA_GET'
            EXPORTING
              i_matnr   = mdfa-matnr
              i_werks   = mdfa-plwrk
              i_lgort   = mdfa-lgort
              i_sobkz   = mdfa-sobkz
              i_dbskz   = lv_dbskz
            IMPORTING
              e_db_mdlv = ls_mdlv.
          berid2 = ls_mdlv-berid.
        ENDIF.                                            "new SA99a
      ENDIF.
      "{ End ENHO /SAPMP/ORDCOMB_PP_SAPLM61B IS-MP-PP /SAPMP/ORDER_COMBINATION }
    WHEN OTHERS.
      ENDCASE.
  subrc = 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_READ_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*      <--P_MDBOM  text
*----------------------------------------------------------------------*
FORM Z_READ_BOM
   USING    matnr  LIKE mt61d-matnr
              werks  LIKE mt61d-werks
              berid  LIKE mt61d-berid
     CHANGING mdbomx STRUCTURE mdbom.

  DATA: BEGIN OF mdbomky,
          matnr LIKE mdzu-matnr,
          werks LIKE mdzu-werks,
          berid LIKE mdzu-berid,       "new SA 46a
        END OF mdbomky.

  mdbomky-matnr = matnr.
  mdbomky-werks = werks.
  mdbomky-berid = berid.               "new SA 46a

  READ TABLE mdbom WITH KEY mdbomky BINARY SEARCH.
  mdbomx = mdbom.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_READ_RECEIPT_EXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_DELNR  text
*      -->P_DELPS  text
*      -->P_DELET  text
*      -->P_DELKZ  text
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*      -->P_PLAAB  text
*      -->P_PLANR  text
*      -->P_DAT00  text
*      <--P_MDZUX  text
*      <--P_SUBRC  text
*----------------------------------------------------------------------*
FORM Z_READ_RECEIPT_EXT
  USING    DELNR  LIKE MDPS-DEL12
              DELPS  LIKE MDPS-DELPS
              DELET  LIKE MDPS-DELET
              DELKZ  LIKE MDPS-DELKZ
              MATNR  LIKE MT61D-MATNR
              WERKS  LIKE MT61D-WERKS
              BERID  LIKE MT61D-BERID               "note 326280
              PLAAB  LIKE MDPS-PLAAB
              PLANR  LIKE MDPS-PLANR
              DAT00  LIKE MDPS-DAT00
     CHANGING MDZUXX STRUCTURE MDZU
              SUBRC  LIKE SY-SUBRC.

  DATA: BEGIN OF MDZUKY,
          DELNR LIKE MDZU-DELNR,
          DELPS LIKE MDZU-DELPS,
          DELET LIKE MDZU-DELET,
          DELKZ LIKE MDPS-DELKZ,
          MATNR LIKE MT61D-MATNR,
          WERKS LIKE MT61D-WERKS,
          BERID LIKE MT61D-BERID,                       "note 326280
          PLAAB LIKE MDPS-PLAAB,
          PLANR LIKE MDPS-PLANR,
        END OF MDZUKY.

  IF  DELKZ <> WKBST
  AND DELKZ <> LGBST
  AND DELKZ <> KDBST
  AND DELKZ <> PRBST
  AND DELKZ <> LBBST
  AND DELKZ <> KKBST.
    PERFORM Z_READ_RECEIPT
            USING DELNR DELPS DELET DAT00
            CHANGING MDZUXX SUBRC.
    EXIT.
  ENDIF.


 MDZUKY-DELNR = DELNR.
  MDZUKY-DELPS = DELPS.
  MDZUKY-DELET = DELET.
  MDZUKY-DELKZ = DELKZ.
  MDZUKY-MATNR = MATNR.
  MDZUKY-WERKS = WERKS.
  MDZUKY-BERID = BERID.
  MDZUKY-PLAAB = PLAAB.
  MDZUKY-PLANR = PLANR.
  READ TABLE MDZUX WITH KEY MDZUKY BINARY SEARCH.
  SUBRC  = SY-SUBRC.
  MDZUXX = MDZUX.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_READ_RECEIPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_DELNR  text
*      -->P_DELPS  text
*      -->P_DELET  text
*      -->P_DAT00  text
*      <--P_MDZUXX  text
*      <--P_SUBRC  text
*----------------------------------------------------------------------*
FORM Z_READ_RECEIPT
  USING    DELNR  LIKE MDPS-DEL12
              DELPS  LIKE MDPS-DELPS
              DELET  LIKE MDPS-DELET
              DAT00  LIKE MDPS-DAT00                       "note 549198
     CHANGING MDZUXX STRUCTURE MDZU
              SUBRC  LIKE SY-SUBRC.

  DATA: BEGIN OF MDZUKY,
          DELNR LIKE MDZU-DELNR,
          DELPS LIKE MDZU-DELPS,
          DELET LIKE MDZU-DELET,
        END OF MDZUKY.

  IF DAT00 IS INITIAL.                                     "note 549198
  MDZUKY-DELNR = DELNR.
  MDZUKY-DELPS = DELPS.
  MDZUKY-DELET = DELET.
  READ TABLE MDZUX WITH KEY MDZUKY BINARY SEARCH.
  ELSE.
     READ TABLE MDZUX WITH KEY DELNR = DELNR
                               DELPS = DELPS
                               DELET = DELET
                               DAT00 = DAT00 BINARY SEARCH.
  ENDIF.
  SUBRC  = SY-SUBRC.
  MDZUXX = MDZUX.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_RQMTS_4_RECEIPTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MDZUX_INDEX  text
*      -->P_QTYORIG  text
*      -->P_QTYORIG  text
*      -->P_LEVEL0  text
*      <--P_QTYREST  text
*----------------------------------------------------------------------*
FORM Z_RQMTS_4_RECEIPTS
  USING    VALUE(INDEX)   LIKE SY-TABIX
              VALUE(QTYRCPT) LIKE MDZU-MNG01
              VALUE(QTYORIG) LIKE MDZU-MNG01
              VALUE(LEVEL)   TYPE I
     CHANGING QTYREST        LIKE MDZU-MNG02.

  DATA: BEGIN OF MDRQ.
          INCLUDE STRUCTURE MDRQX.
  DATA: END OF MDRQ.
  DATA: QTYORIG2  LIKE MDZU-MNG01,
        LASTINDEX LIKE SY-TABIX,
        SUBRC     LIKE SY-SUBRC,
        SAVE      TYPE BOOL.

  QTYREST  = QTYRCPT.
  DO.
    IF INDEX  = 0. EXIT. ENDIF.

    READ TABLE MDABX INDEX INDEX.
    IF SY-SUBRC > 0. EXIT. ENDIF.

    LASTINDEX = INDEX.
    INDEX     = MDABX-INDEX.

    QTYORIG2 = ( QTYORIG * MDABX-MNG02 ) / QTYRCPT.

    QTYREST  = QTYREST - MDABX-MNG02.

    SAVE = 'X'.                        "Originäre Bedarfe sichern

    IF MDABX-DELKZ = SKBED             "Wenn Sekundärbedarf -> Rekursion
    OR MDABX-DELKZ = SMBED             "oder Simulationsbedarf
    OR MDABX-DELKZ = UPABR         "oder Simulations-Umlagerungsbedarf
    OR MDABX-DELKZ = ARBED             "oder Auftragsreservierung
    OR MDABX-DELKZ = BRBED             "oder Bereitstellungsbedarf
    OR MDABX-DELKZ = UAABR             "oder Banf-Abruf
    OR MDABX-DELKZ = UBABR             "oder Bestell-Abruf
    OR MDABX-DELKZ = ULABR             "oder Lieferplan-Abruf
    OR MDABX-DELKZ = TRANSP_RQMT.      "oder evtl. TransportReservierung
      PERFORM Z_ORDER_4_DEPENDENT_RQMT
              USING    MDABX-DELNR MDABX-DELPS MDABX-DELET MDABX-DELKZ
                       QTYORIG2 LEVEL
              CHANGING SUBRC.
      IF SUBRC = 0.                    "WENN Verursacher gefunden
        SAVE = SPACE.                  "DANN Bedarf nicht originär
      ELSE.
        READ TABLE MDABX INDEX LASTINDEX.
      ENDIF.
    ENDIF.

    IF SAVE = 'X'.
      MDRQ-DELNR = MDABX-DELNR.
      MDRQ-DELPS = MDABX-DELPS.
      MDRQ-DELET = MDABX-DELET.
      MDRQ-DELKZ = MDABX-DELKZ.
      MDRQ-MATNR = MDABX-MATNR.
      MDRQ-WERKS = MDABX-WERKS.
      MDRQ-BERID = MDABX-BERID.                       "note 326280
      MDRQ-PLAAB = MDABX-PLAAB.
      MDRQ-PLANR = MDABX-PLANR.
      MDRQ-BAART = MDABX-BAART.
      MDRQ-VERSB = MDABX-VERSB.
      MDRQ-DAT00 = MDABX-DAT00.
      MDRQ-MNG01 = MDABX-MNG01.
      MDRQ-EXTRA = MDABX-EXTRA.
      MDRQ-MNG02 = QTYORIG2.
      MDRQ-RQMTX = 'X'.
      PERFORM Z_COLLECT_REQUIREMENT USING MDRQ.
    ENDIF.

  ENDDO.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_ORDER_4_DEPENDENT_RQMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MDABX_DELNR  text
*      -->P_MDABX_DELPS  text
*      -->P_MDABX_DELET  text
*      -->P_MDABX_DELKZ  text
*      -->P_QTYORIG2  text
*      -->P_LEVEL  text
*      <--P_SUBRC  text
*----------------------------------------------------------------------*
FORM Z_ORDER_4_DEPENDENT_RQMT
  USING    VALUE(RSNUM)   LIKE MDPS-DEL12
              VALUE(RSPOS)   LIKE MDPS-DELPS
              VALUE(RSEIN)   LIKE MDPS-DELET
              VALUE(DELKZ)   LIKE MDPS-DELKZ
              VALUE(QTYORIG) LIKE MDPS-MNG01
              VALUE(LEVEL)   TYPE I
     CHANGING SUBRC          LIKE SY-SUBRC.

  DATA: BEGIN OF BOM.
          INCLUDE STRUCTURE MDBOM.
  DATA: END OF BOM.
  DATA: BEGIN OF MDSBL.
          INCLUDE STRUCTURE MDSBX.
  DATA: END OF MDSBL.
  DATA: QTYRCPT  LIKE MDZU-MNG01,
        QTYREST  LIKE MDZU-MNG01,
        INDEX    LIKE SY-TABIX,
        MATNR    LIKE MDZU-MATNR,
        WERKS    LIKE MDZU-WERKS,
        BERID    LIKE MDZU-BERID.
data:   lv_matnr   like  mdzu-matnr,
        lv_werks   like  mdzu-werks,
        lv_berid   like  mdzu-berid,
        lv_delps   like  mdzu-delps,
        lv_plaab   like  mdzux-plaab,
        lv_planr   like  mdzux-planr,
        lv_qtyorig like  mdps-mng01,
        tabix_u    like  sy-tabix,
        lv_level   type  i,
        lv_index_u type  i.

data: begin of lt_mdzux_u occurs   0,
        delnr like mdzu-delnr,
        delps like mdzu-delps,
        delet like mdzu-delet,
        delkz like mdzu-delkz,
        matnr like mdzu-matnr,
        werks like mdzu-werks,
        berid like mdzu-berid,
        plaab like mdzu-plaab,
        planr like mdzu-planr,
        dat00 like mdzu-dat00,
        baart like mdzu-baart,
        versb like mdzu-versb,
        mng01 like mdzu-mng01,
        mng02 like mdzu-mng02,
        index like mdzu-index,
        alloc like mdzu-alloc,
        extra like mdzu-extra,
        level type i,
        aufnr like afpo-aufnr,
        posnr like afpo-posnr,
      end of lt_mdzux_u.

  data: begin of lt_mdrqx_u occurs 0.
              include structure ct_mdrqx_u.
  data: end   of lt_mdrqx_u.
  data: begin of lt_mdrqx_a.
              include structure ct_mdrqx_u.
  data: end   of lt_mdrqx_a.
  data: begin of lt_mdrqx_b.
              include structure ct_mdrqx_u.
  data: end   of lt_mdrqx_b.

  data: ty_fill(5) type i,
        count_a(3) type i,
        count_b(3) type i,
        endhit_u   type bool value space.

  data: begin of lt_afpo_u.
              include structure afpo.
  data: end   of lt_afpo_u.

  data: lt_ord_pre_org like ord_pre occurs 0 with header line,
        subrc_u        like sy-subrc.

  DATA: LV_DAT00 LIKE MDPS-DAT00.                     "note 549198
  "------- Pruefen Rekursion -----------------------------------------
  IF QTYORIG = 0. EXIT. ENDIF.

  "------- Returncode auf Fehler -------------------------------------
  SUBRC = 4.

  "------- Zähler Rekursionsstufe ------------------------------------
  LEVEL = LEVEL + 1.

   "------- Sekundärbedarf lesen --------------------------------------
  PERFORM Z_READ_DEP_REQUIREMENT
          USING    RSNUM RSPOS RSEIN
          CHANGING MDSBL.
  CHECK SY-SUBRC = 0.

  "------- Wenn Material nicht gefunden wurde -> Raus ----------------
  IF MDSBL-BAUGR IS INITIAL
  OR MDSBL-WERK2 IS INITIAL.
    PERFORM Z_ORDER_WITHOUT_MATERIAL USING MDSBL-DELNR CHANGING MDZUX.
    IF SY-SUBRC = 0.
      PERFORM Z_STORE_EXCESSIVE_ORDER USING MDZUX QTYORIG.
      SUBRC = 0.                       "Returncode auf Null
    ENDIF.
    EXIT.
  ENDIF.

"------- Bestands-/Bedarfssituation für übergeordnetes Material ----
  PERFORM Z_READ_BOM USING MDSBL-BAUGR MDSBL-WERK2 MDSBL-BERID2
                   CHANGING MDBOM.
  IF SY-SUBRC > 0.
    PERFORM Z_READ_IO_ELEMENTS
            USING    MDSBL-BAUGR MDSBL-WERK2 MDSBL-BERID2
                     MDSBL-DELNR MDSBL-DELPS MDSBL-DELET    "note 879179
                     MDSBL-DELKZ
            CHANGING MATNR WERKS BERID.
  ELSE.
    MATNR = MDSBL-BAUGR.
    WERKS = MDSBL-WERK2.
    BERID = MDSBL-BERID2.
  ENDIF.
 "------- Protokollieren, daß Bestands-/Bedarfssituation gelesen ----
  BOM-THIS_MATNR = MATNR.              "Übergeordnete Baugruppe
  BOM-THIS_WERKS = WERKS.              "immer abspeichern
  BOM-THIS_BERID = BERID.                          "note 326280
  BOM-NEXT_MATNR = MDSBL-MATNR.
  BOM-NEXT_WERKS = MDSBL-WERKS.
  BOM-NEXT_BERID = MDSBL-BERID.                    "note 326280
  BOM-LEVEL      = LEVEL.
*  "Rekursive Path detected: Stop and exit                   "HW 706286
  IF BOM-LEVEL GT gv_maxlev.
    MESSAGE s331(mf) WITH mdsbl-delnr.
    PERFORM Z_STORE_SY_MESSAGE.          "Rekursion
    EXIT.
  ENDIF.

   PERFORM Z_COLLECT_BOM USING BOM.

  "------- Planauftrag zum Sekundärbedarf lesen ----------------------
  PERFORM Z_READ_RECEIPT
          USING    MDSBL-DELNR MDSBL-DELPS MDSBL-DELET LV_DAT00
          CHANGING MDZUX SUBRC.
  IF SUBRC <> 0 AND ( DELKZ = 'U1' OR DELKZ = 'BB' ).
    IF LV_DAT00 IS INITIAL.
      READ TABLE MDZUX WITH KEY DELNR = MDSBL-DELNR
                                DELPS = MDSBL-DELPS
                                BINARY SEARCH.
    ELSE.
      READ TABLE MDZUX WITH KEY DELNR = MDSBL-DELNR
                                DELPS = MDSBL-DELPS
                                DAT00 = LV_DAT00
                                BINARY SEARCH.
    ENDIF.
    IF SY-SUBRC = 0.
      SUBRC = 0.
    ELSE.
      SUBRC = 4.
    ENDIF.
  ENDIF.
 CHECK SUBRC = 0.
  INDEX = SY-TABIX.                    "RQMTS_4_RECEIPTS aendert MDZUX

IF MDSBL-REKUR = SPACE.              "Rekursion
    QTYRCPT = MDZUX-MNG01.
    PERFORM Z_RQMTS_4_RECEIPTS
            USING     MDZUX-INDEX QTYRCPT QTYORIG LEVEL
            CHANGING  QTYREST.
  ELSE.                                "Rekursion
    QTYREST = MDZUX-MNG01. QTYRCPT = MDZUX-MNG01.            "Rekursion
    MESSAGE S331(MF) WITH MDZUX-DELNR. "Rekursion
    PERFORM Z_STORE_SY_MESSAGE.          "Rekursion
  ENDIF.                               "Rekursion

  IF QTYREST > 0.               "Teilmenge konnte nicht zugeordnet
    QTYORIG = ( QTYREST / QTYRCPT ) * QTYORIG.
*   READ TABLE MDZUX INDEX INDEX.                          "note 339484
*--> index not valid anymore, because MDZUX could be changed     339484
    PERFORM Z_READ_RECEIPT                                   "note 339484
            USING    MDSBL-DELNR MDSBL-DELPS MDSBL-DELET   "note 339484
                     LV_DAT00
            CHANGING MDZUX SUBRC.                          "note 339484
    IF SY-SUBRC = 0.
      PERFORM Z_STORE_EXCESSIVE_ORDER USING MDZUX QTYORIG.
    ENDIF.
  ENDIF.

* mill 0001 jw 000724
* Zugang für zusammengefassten Auftrag nachlesen
  if mdzux-delkz = 'OM' or mdzux-delkz = 'MP'.
* mdbom nachlesen
        read table mdbom with key this_matnr = mdsbl-baugr
                                  this_werks = mdsbl-werk2.
* zusammengefassten Auftag zu dieser Reservierung schon gelesen?
        read table ct_mdzux_u with key aufnr = mdzux-delnr
                                       rsnum = mdsbl-rsnum
                                       rspos = mdsbl-rspos
                                       rsein = mdsbl-rsein.

        if sy-subrc > 2.
* alle U's stehen auf einer Stufe
        if mdbom-level = level.
          lv_level = level.
* Ursprungsaufträge lesen
          call function 'MILL_OC2_SEARCH_ORG_ORDER'
          exporting
                 i_aufnr            = mdzux-delnr
          tables
                 it_ord_pre_org     = lt_ord_pre_org
          exceptions
                 order_not_found    = 1
                 no_org_order_found = 2
                 not_a_comb_order   = 3
                 others             = 4.

          subrc_u = sy-subrc.

          loop at lt_ord_pre_org.

           select single * from afpo into lt_afpo_u
                           where aufnr = lt_ord_pre_org-aufnr
                           and   posnr = 1.

           read table mdbom with key this_matnr = lt_afpo_u-matnr
                                     this_werks = lt_afpo_u-dwerk.
           if sy-subrc > 2.
* Material nachlesen
             lv_delps = lt_afpo_u-posnr.

* H881521 the parameter DELET is not used in the underlying form routines for prod. orders
*         we add this parameter only to be syntactically correct
data: lv_dummy_delet type delet.                         "H881521
             perform z_read_io_elements
                     using    lt_afpo_u-matnr lt_afpo_u-dwerk
                              lt_afpo_u-berid lt_afpo_u-aufnr
                              lv_delps lv_dummy_delet    "H881521
                              feauf
                     changing lv_matnr lv_werks lv_berid.
* gelesenes Material speichern
             bom-this_matnr = lv_matnr.
             bom-this_werks = lv_werks.
             bom-this_berid = lv_berid.
             bom-next_matnr = mdsbl-matnr.
             bom-next_werks = mdsbl-werks.
             bom-next_berid = mdsbl-berid.
             bom-level      = level.
             perform z_collect_bom using bom.
           endif.
* Ursprungsauftrag aus mdzux lesen
           read table mdzux with key delnr = lt_afpo_u-aufnr
                                     delps = '000001'.
* Plaab und planr merken und übergeben
           lv_index_u = mdzux-index.
           lv_plaab   = mdzux-plaab.
           lv_planr   = mdzux-planr.
           move-corresponding mdzux to lt_mdzux_u.
           move level to lt_mdzux_u-level.
* zusammengefassten Auftrag lesen
           select single * from afpo into lt_afpo_u
                           where mill_oc_aufnr_u = lt_afpo_u-aufnr.
           lv_delps = lt_afpo_u-posnr.
           move lt_afpo_u-aufnr to lt_mdzux_u-aufnr.
           move lt_afpo_u-posnr to lt_mdzux_u-posnr.
           append lt_mdzux_u.
* zusammengefassten Auftrag zum U-Auftrag aus mdzux lesen
           read table mdzux with key delnr = lt_afpo_u-aufnr
                                     delps = lv_delps.
           if sy-subrc = 0.
             move lv_index_u to mdzux-index.
             move lv_plaab   to mdzux-plaab.
             move lv_planr   to mdzux-planr.
* Index an zusammengefassten Auftrag übergeben
             modify mdzux index sy-tabix
                          transporting plaab planr index.
* Daten in ct_mdzux_u schreiben
             move-corresponding lt_mdzux_u to ct_mdzux_u.
             move mdsbl-rsnum to ct_mdzux_u-rsnum.
             move mdsbl-rspos to ct_mdzux_u-rspos.
             move mdsbl-rsein to ct_mdzux_u-rsein.
             append ct_mdzux_u.
           endif.
         endloop.
       endif.                 " Ende mdbom-level
* alten Level zurückgeben
       level = lv_level.
* über Ursprungsaufträge loopen
    loop at ct_mdzux_u where aufnr = mdsbl-delnr
                       and   rsnum = mdsbl-rsnum
                       and   rspos = mdsbl-rspos
                       and   rsein = mdsbl-rsein.

      read table mdzux with key delnr = ct_mdzux_u-delnr
                                delps = ct_mdzux_u-delps.
      check subrc = 0.
* Index merken, um mdzux später nachzulesen
      index = sy-tabix.
* noch Level ermitteln!
      read table mdbom with key this_matnr = ct_mdzux_u-matnr
                                this_werks = ct_mdzux_u-werks.
      if sy-subrc = 0.
        level = mdbom-level.
      endif.

      if mdsbl-rekur = space.
* Kennzeichen setzen, mdrqx bei gleichem Verursacher nur einmal füllen
        hit_u = 'X'.
        clear ct_mdrqx_u.
* Reservierung merken
        ct_mdrqx_u-rsnum = mdsbl-rsnum.
        ct_mdrqx_u-rspos = mdsbl-rspos.
        ct_mdrqx_u-rsein = mdsbl-rsein.
        ct_mdrqx_u-aufnr = mdsbl-delnr.
        append ct_mdrqx_u.
        qtyrcpt = mdzux-mng01.

        perform z_rqmts_4_receipts
                using     mdzux-index qtyrcpt qtyorig level
                changing  qtyrest.
      else.
        qtyrest = mdzux-mng01.
        qtyrcpt = mdzux-mng01.
        message s331(mf) with mdzux-delnr.
        perform z_store_sy_message.
      endif.
* identische Einträge in mdrqx wieder löschen
      describe table ct_mdrqx_u lines ty_fill.
      if ty_fill > 1.
        loop at ct_mdrqx_u where rsnum = mdsbl-rsnum
                           and   rspos = mdsbl-rspos
                           and   rsein = mdsbl-rsein
                           and   aufnr = mdsbl-delnr.

          move ct_mdrqx_u to lt_mdrqx_u.
          append lt_mdrqx_u.
        endloop.
        describe table lt_mdrqx_u lines ty_fill.
        if ty_fill > 1.
          count_a = 1. count_b = 2.
* Tabelle sortieren
          sort lt_mdrqx_u by delnr delps delet delkz
                             matnr werks rqmtx.
          do.
            read table lt_mdrqx_u index count_a.
            lt_mdrqx_a = lt_mdrqx_u.
            do.
              read table lt_mdrqx_u index count_b.
              lt_mdrqx_b = lt_mdrqx_u.
              if lt_mdrqx_a = lt_mdrqx_b.
* doppelten Eintrag löschen in ct_mdrqx_u und in mdrqx
                read table ct_mdrqx_u from lt_mdrqx_b.
                delete ct_mdrqx_u index sy-tabix.
                read table mdrqx with key delnr = lt_mdrqx_b-delnr
                                          delps = lt_mdrqx_b-delps
                                          delet = lt_mdrqx_b-delet
                                          delkz = lt_mdrqx_b-delkz
                                          matnr = lt_mdrqx_b-matnr
                                          werks = lt_mdrqx_b-werks
                                          berid = lt_mdrqx_b-berid
                                          plaab = lt_mdrqx_b-plaab
                                          planr = lt_mdrqx_b-planr
                                          dat00 = lt_mdrqx_b-dat00
                                          baart = lt_mdrqx_b-baart
                                          versb = lt_mdrqx_b-versb
                                          mng01 = lt_mdrqx_b-mng01
                                          mng02 = lt_mdrqx_b-mng02
                                          index = lt_mdrqx_b-index
                                          alloc = lt_mdrqx_b-alloc
                                          extra = lt_mdrqx_b-extra
                                          rqmtx = lt_mdrqx_b-rqmtx.
                if sy-subrc = 0.
* bei identischen Einträgen
                  delete mdrqx index sy-tabix.
                else.
* bei Kumulierung der Einträge
                  read table mdrqx with key delnr = lt_mdrqx_b-delnr
                                            delps = lt_mdrqx_b-delps
                                            delet = lt_mdrqx_b-delet
                                            delkz = lt_mdrqx_b-delkz
                                            matnr = lt_mdrqx_b-matnr
                                            werks = lt_mdrqx_b-werks
                                            berid = lt_mdrqx_b-berid
                                            plaab = lt_mdrqx_b-plaab
                                            planr = lt_mdrqx_b-planr
                                            dat00 = lt_mdrqx_b-dat00
                                            baart = lt_mdrqx_b-baart
                                            versb = lt_mdrqx_b-versb
                                            rqmtx = lt_mdrqx_b-rqmtx.
                   if sy-subrc = 0.
                     if mdrqx-mng02 > lt_mdrqx_b-mng02.
                       mdrqx-mng02 = mdrqx-mng02 - lt_mdrqx_b-mng02.
                       modify mdrqx index sy-tabix
                                    transporting mng02.
                     endif.
                   endif.
                 endif.
                 endhit_u = 'X'.
                 exit.
              else.
* nächsten Eintrag
                exit.
              endif.
              if count_b >= ty_fill. exit. endif.
              count_b = count_b + 1.
            enddo.
            if endhit_u = 'X'. exit. endif.
            count_a = count_a + 1.
            if count_a >= ty_fill. exit. endif.
            count_b = count_a + 1.
          enddo.
        endif.
        clear lt_mdrqx_u. refresh lt_mdrqx_u.
        clear lt_mdrqx_a.
        clear lt_mdrqx_b.
      endif.
* Kennzeichen zurücksetzen
      hit_u = space.

      if qtyrest > 0.            "Teilmenge konnte nicht zugeordnet

        if mdsbl-delkz = 'OM' or mdsbl-delkz = 'MP'.
* keine Überschußmenge auf dem Ursprungsauftrag
          lv_qtyorig = qtyorig.
          qtyorig = 0.
        else.
          qtyorig = ( qtyrest / qtyrcpt ) * qtyorig.
        endif.

        read table mdzux index index.
        if sy-subrc = 0.
* Ursprungsauftrag merken
          perform z_store_excessive_order using mdzux qtyorig.
* Ursprungsauftrag lesen
          read table ct_mdzux_u with key delnr = mdzux-delnr
                                         delps = mdzux-delps.
          if sy-subrc <= 2.
* zusammengefassten Auftrag aus mdzux lesen
            lv_delps =  ct_mdzux_u-posnr.
            read table mdzux with key delnr = ct_mdzux_u-aufnr
                                      delps = lv_delps.
* zusammengefassten Auftrag merken
            qtyrcpt = mdzux-mng01.
            qtyorig = ( qtyrest / qtyrcpt ) * lv_qtyorig.
            mdzux-mng01 = 0.
            perform z_store_excessive_order using mdzux qtyorig.
          endif.
        endif.
        if qtyorig = 0.
          qtyorig = lv_qtyorig.
        endif.
      endif.
    endloop.

    endif.                   " Ende mdzux-delnr
  endif.                     " Ende mdzux-delkz

  "-------- Bedarfe zum Planauftrag suchen ----------

* bei zusammengefassten Aufträgen überspringen
*  if not ( mdsbl-delkz = 'OM' or mdsbl-delkz = 'MP' ) .
*
*
*
*
*  IF MDSBL-REKUR = SPACE.              "Rekursion
*    QTYRCPT = MDZUX-MNG01.
*    PERFORM Z_RQMTS_4_RECEIPTS
*            USING     MDZUX-INDEX QTYRCPT QTYORIG LEVEL
*            CHANGING  QTYREST.
*  ELSE.                                "Rekursion
*    QTYREST = MDZUX-MNG01. QTYRCPT = MDZUX-MNG01.            "Rekursion
*    MESSAGE S331(MF) WITH MDZUX-DELNR. "Rekursion
*    PERFORM Z_STORE_SY_MESSAGE.          "Rekursion
*  ENDIF.                               "Rekursion
*
*  IF QTYREST > 0.               "Teilmenge konnte nicht zugeordnet
*    QTYORIG = ( QTYREST / QTYRCPT ) * QTYORIG.
**   READ TABLE MDZUX INDEX INDEX.                          "note 339484
**--> index not valid anymore, because MDZUX could be changed     339484
*    PERFORM Z_READ_RECEIPT                                   "note 339484
*            USING    MDSBL-DELNR MDSBL-DELPS MDSBL-DELET   "note 339484
*                     LV_DAT00
*            CHANGING MDZUX SUBRC.                          "note 339484
*    IF SY-SUBRC = 0.
*      PERFORM Z_STORE_EXCESSIVE_ORDER USING MDZUX QTYORIG.
*    ENDIF.
*  ENDIF.
** mill 0001 jw 000807
*  endif.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_READ_DEP_REQUIREMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RSNUM  text
*      -->P_RSPOS  text
*      -->P_RSEIN  text
*      <--P_MDSBL  text
*----------------------------------------------------------------------*
FORM Z_READ_DEP_REQUIREMENT
  USING    RSNUM  LIKE MDPS-DEL12
              RSPOS  LIKE MDPS-DELPS
              RSEIN  LIKE MDPS-DELET
     CHANGING MDSBXX STRUCTURE MDSBX.

  DATA: BEGIN OF MDSBKY,
          RSNUM LIKE MDPS-DEL12,
          RSPOS LIKE MDPS-DELPS,
          RSEIN LIKE MDPS-DELET,
        END OF MDSBKY.

  MDSBKY-RSNUM = RSNUM.
  MDSBKY-RSPOS = RSPOS.
  MDSBKY-RSEIN = RSEIN.
  READ TABLE MDSBX WITH KEY MDSBKY BINARY SEARCH.
  MDSBXX = MDSBX.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_ORDER_WITHOUT_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MDSBL_DELNR  text
*      <--P_MDZUX  text
*----------------------------------------------------------------------*
FORM Z_ORDER_WITHOUT_MATERIAL
   USING    DELNR LIKE MDPS-DEL12
     CHANGING MDZU  STRUCTURE MDZUX.

  IF DELNR EQ SPACE.                             "note 550308
    SY-SUBRC = 4.
    EXIT.
  ENDIF.

*--> Pruefen Netzauftrag
  SELECT SINGLE * FROM MDFA
         WHERE AUFNR = DELNR
         AND   POSNR = 1.
  IF SY-SUBRC = 0.
    CLEAR MDZU.
    MDZU-DELNR = MDFA-AUFNR.       "Nummer Dispositionselement
    MDZU-DELPS = MDFA-POSNR.       "Position Dispositionselement
    CASE MDFA-AFTYP.
      WHEN AFTYPF. MDZU-DELKZ = FEAUF.
      WHEN AFTYPN. MDZU-DELKZ = NEAUF.
    ENDCASE.
*   mdzu-delkz = neauf.            "ID Dispoelement
    MDZU-WERKS = MDFA-PLWRK.       "Werk
    MDZU-DAT00 = MDFA-PEDTR.       "Zugangstermin (Tag)
    MDZU-INDEX = 0.                "Default falls RQMTFINI = 'X'
    EXIT.
  ENDIF.

*--> Pruefen IH-Auftrag
  SELECT SINGLE * FROM AFIH
         WHERE AUFNR = DELNR.
  IF SY-SUBRC = 0.
    CLEAR MDZU.
    MDZU-DELNR = AFIH-AUFNR.    "Nummer Dispositionsel
    MDZU-DELPS = 1.             "Position Dispositionse
    MDZU-DELKZ = PM_ORDER.      "ID Dispoelement
    MDZU-MATNR = AFIH-BAUTL.    "Bauteil
    MDZU-WERKS = AFIH-IWERK.    "Werk
    MDZU-DAT00 = AFIH-ANLVD.    "Anlage wieder verfuegbar
    MDZU-INDEX = 0.             "Default falls RQMTFINI = 'X'
    EXIT.
  ENDIF.

*--> Weder Netzauftrag noch IH-Auftrag gefunden
  MESSAGE S029(MF) WITH DELNR.         "Netzauftrag nicht da
  PERFORM Z_STORE_SY_MESSAGE.
  SY-SUBRC = 4.                                                "4.5A MW
  EXIT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_STORE_EXCESSIVE_ORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MDZUX  text
*      -->P_QTYORIG  text
*----------------------------------------------------------------------*
FORM Z_STORE_EXCESSIVE_ORDER
   USING MDZU    STRUCTURE MDZUX
           QTYORIG LIKE MDZU-MNG01.

  DATA: BEGIN OF MDRQ.
          INCLUDE STRUCTURE MDRQX.
  DATA: END OF MDRQ.

  MDRQ-DELNR = MDZU-DELNR.
  MDRQ-DELPS = MDZU-DELPS.
  MDRQ-DELET = MDZU-DELET.
  MDRQ-DELKZ = MDZU-DELKZ.
  MDRQ-MATNR = MDZU-MATNR.
  MDRQ-WERKS = MDZU-WERKS.
  MDRQ-BERID = MDZU-BERID.                         "note 326280
  MDRQ-PLAAB = MDZU-PLAAB.
  MDRQ-PLANR = MDZU-PLANR.
  MDRQ-BAART = MDZU-BAART.
  MDRQ-DAT00 = MDZU-DAT00.
  MDRQ-MNG01 = MDZU-MNG01.
  MDRQ-MNG02 = QTYORIG.
  MDRQ-RQMTX = SPACE.
  MDRQ-EXTRA = MDZU-EXTRA.
  PERFORM Z_COLLECT_REQUIREMENT USING MDRQ.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_SEARCH_REQUIREMENTS_4_RECIPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*      -->P_MT61D_DISST  text
*----------------------------------------------------------------------*
FORM Z_SEARCH_REQUIREMENTS_4_RECIPT
  USING VALUE(MATNR) LIKE MT61D-MATNR
           VALUE(WERKS) LIKE MT61D-WERKS
           VALUE(BERID) LIKE MT61D-BERID
           VALUE(DISST) LIKE MT61D-DISST.                    "Rekursion

  DATA: RECEIPTS  LIKE MDPS-MNG01,
        RQMTOPEN  LIKE MDPS-MNG01,  "Requirements not allocated to recei
        RQMTFINI  TYPE BOOL,        "Flag: No more requirements in sect.
        PLAAB     LIKE MDEL-PLAAB,
        PLANR     LIKE MDEL-PLANR,
        RQMTINDEX LIKE SY-TABIX,
        MDABINDEX LIKE SY-TABIX,
        INDEX     LIKE MDZU-INDEX,
        RSNUM     LIKE MDPS-DEL12,
        DELVR     LIKE MDPS-DEL12,
        SAVE      TYPE BOOL.
  DATA: LS_DUMMY  LIKE MDKP.
  DATA : LV_PIC_MATNR LIKE MT61D-MATNR.

  PLAAB = SPACE.
  PLANR = SPACE.
  LOOP AT MDPSX WHERE VRFKZ = 'X'. "Bedarfsmengen

    SAVE = SPACE.

    "---------- Wechsel Planungsabschnitt ---------------------------
    IF ( MDPSX-PLAAB <> PLAAB )        "Wird auch das erste mal
    OR ( MDPSX-PLANR <> PLANR ).       "ausgeführt

      PLAAB = MDPSX-PLAAB.
      PLANR = MDPSX-PLANR.

      RQMTOPEN  = 0.
      RQMTINDEX = SY-TABIX.
      RQMTFINI  = SPACE.

    ENDIF.

    "---------- DispoElememt einfuegen für Zugänge ------------------
    IF ( MDPSX-PLUMI = PLUSX )
    OR ( MDPSX-PLUMI = BESTX ).

      CLEAR MDZUX.
      IF MDPSX-DEL12 IS INITIAL.
        MDZUX-DELNR = MDPSX-DELNR.    "Nummer Dispositionselement
      ELSE.
        MDZUX-DELNR = MDPSX-DEL12.    "Nummer Dispositionselement
      ENDIF.
      MDZUX-DELPS = MDPSX-DELPS.      "Position Dispositionselement
      MDZUX-DELET = MDPSX-DELET.      "Einteilung Dispoelement
      MDZUX-DELKZ = MDPSX-DELKZ.      "ID Dispoelement
      MDZUX-MATNR = MATNR.            "Material-/PG-Nummer
      MDZUX-WERKS = WERKS.            "Werk
      MDZUX-BERID = BERID.            "Dispobereich
      MDZUX-PLAAB = MDPSX-PLAAB.      "KZ Planungsabschnitt
      MDZUX-PLANR = MDPSX-PLANR.      "Nummer Planungsabschnitt
      MDZUX-DAT00 = MDPSX-DAT00.      "Zugangstermin (Tag)
      MDZUX-MNG01 = MDPSX-MNG01.      "Zugangs-/Bestandsmenge
      MDZUX-BAART = MDPSX-BAART.      "Beschaffungsart
      MDZUX-INDEX = 0.                "Default falls RQMTFINI = 'X'
      CALL FUNCTION 'EXTRAKT_AUS_MDPSX_BILDEN'
           EXPORTING EMDPS  = MDPSX
                     EMDKP  = LS_DUMMY
                     CALL_BADI = xflag
           IMPORTING IEXTRA = MDZUX-EXTRA.
      SAVE = 'X'.
*--> Auftragsmenge um Ausschuß vermindern, wenn vorhanden HW 213249
      IF NOT MDPSX-MNG02 IS INITIAL.
        MDZUX-MNG01 = MDZUX-MNG01 - MDPSX-MNG02.
      ENDIF.

    ENDIF.

    "---------- bei Sekundärbedarf Planauftrag suchen ------------
    IF  MDPSX-DELKZ = SKBED          "Wenn Sekundärbedarf
    AND MDPSX-PLUMI = MINUS.         "Jedoch kein Kuppelprodukt
      RSNUM = MDPSX-DELNR.           "Type-Convert
      DELVR = MDPSX-AUFVR.           "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID
                    DISST PLAUF DELVR 0 0.
    ENDIF.

    "---------- bei Simulationsbedarf Simulationsauftrag suchen -----
    IF  MDPSX-DELKZ = SMBED          "Wenn Simulationsbedarf
    AND MDPSX-PLUMI = MINUS.         "Jedoch kein Kuppelprodukt
      RSNUM = MDPSX-DELNR.           "Type-Convert
      DELVR = MDPSX-AUFVR.           "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
                    SAAUF DELVR 0 0.
    ENDIF.

    "---------- bei SimTransportbedarf Simulationsauftrag suchen ----
    IF  MDPSX-DELKZ = UPABR     "Wenn SimTransportbedarf
    AND NOT EPLSCN  IS INITIAL.
      RSNUM = MDPSX-DELNR.      "Type-Convert
      DELVR = MDPSX-DELNR.      "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
                    SAAUF DELVR 0 0.
    ENDIF.

    "---------- bei Vorpl.Transportbedarf Vorpl.Planauftrag suchen --
    IF  MDPSX-DELKZ =  UPABR
    AND EPLSCN      IS INITIAL.
      RSNUM = MDPSX-DELNR.      "Type-Convert
      DELVR = MDPSX-DELNR.      "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
                    PLAUF DELVR 0 0.
    ENDIF.

*   "---------- Bei Summensekundaerbedarfen Planauftraege suchen
*   if mdpsx-delkz = subed.     "Wenn Summensekundaerbedarf
*     rsnum = mdpsx-delnr.
*     perform Z_STORE_DEPENDENT_RQMT
*             using rsnum mdpsx-delps 0 matnr werks disst
*                   plauf space 0 0.
*   endif.

    "---------- bei Reservierung Fertigungsauftrag suchen -----------
    IF      MDPSX-DELKZ = ARBED     "Wenn Auftrags-Reservierung
    AND     MDPSX-PLUMI = MINUS     "und  Abgangsreservierung
    AND NOT MDPSX-BAUGR IS INITIAL.
      RSNUM = MDPSX-DELNR.      "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
                    FEAUF MDPSX-DEL12 1 0.
    ENDIF.

    "---------- bei Banf-Abrufen TB-Banf suchen -----------------------
    IF  MDPSX-DELKZ = UAABR.    "oder BestellanforderungsAbruf
      RSNUM = MDPSX-DELNR.      "Type-Convert
      DELVR = MDPSX-DELNR.      "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS MDPSX-DELET MATNR WERKS BERID
                    DISST BSANF DELVR MDPSX-DELPS MDPSX-DELET.
    ENDIF.

    "---------- bei BestellAbrufen Bestellung suchen -----------------
    IF  MDPSX-DELKZ = UBABR.    "BestellAbruf
      RSNUM = MDPSX-DELNR.      "Type-Convert
      DELVR = MDPSX-DELNR.      "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS MDPSX-DELET MATNR WERKS BERID
                    DISST BSEIN DELVR MDPSX-DELPS MDPSX-DELET.
    ENDIF.

    "--------- Bei Lieferplanabrufen TB-Lieferplan such
    IF MDPSX-DELKZ = ULABR.     "Lieferplanabruf
      RSNUM = MDPSX-DELNR.      "Type-Convert
      DELVR = MDPSX-DELNR.      "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS MDPSX-DELET
                    MATNR WERKS BERID DISST LPEIN
                    DELVR MDPSX-DELPS MDPSX-DELET.
    ENDIF.

    "---------- bei Bereitstellungsbedarfen Lohnberabeiterbanf lesen --
    IF  MDPSX-DELKZ = BRBED.    "Wenn Bereitstellungsbedarf
      RSNUM = MDPSX-DELNR.      "Type-Convert
      DELVR = MDPSX-AUFVR.
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS MDPSX-DELET MATNR WERKS BERID
                    DISST MDPSX-DELVR DELVR MDPSX-POSVR MDPSX-EINVR.
    ENDIF.

    "---------- Bei Umlagerungsreservierung Empfänger lesen --------
    IF  MDPSX-DELKZ = MRBED     "Wenn Reservierung
    AND MDPSX-DELVR = ULRES.    "und  Empfänger auch Reservierung
      RSNUM = MDPSX-DELNR.      "Type-Convert
      DELVR = MDPSX-DELNR.      "Type-Convert
      PERFORM Z_STORE_DEPENDENT_RQMT
              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
                    ULRES DELVR MDPSX-DELPS 0.
    ENDIF.

    "---------- Bei Umlagerungsreservierung aus DB Empfänger lesen ----
    IF  MDPSX-DELKZ = MRBED     "Wenn Reservierung               "SA 45A
    AND MDPSX-DELVR = UMRES.    "und  Empfänger Reservierung aus DB "SA
      RSNUM = MDPSX-DELNR.      "Type-Convert                    "SA 45A
      DELVR = MDPSX-DELNR.      "Type-Convert                    "SA 45A
      PERFORM Z_STORE_DEPENDENT_RQMT                               "SA 45A
              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST  "SA 45A
                    UMRES DELVR MDPSX-DELPS 0.                   "SA 45A
    ENDIF.

    "---------- Bedarfsverursacher suchen ---------------------------
    IF  RQMTFINI    = SPACE    "Noch Abgänge vorhanden
    AND MDPSX-PLUMI = PLUSX    "Bedarfsverursacher nur für Zugänge
    OR  MDPSX-PLUMI = BESTX.

      IF MDPSX-PLUMI = PLUSX.
        RECEIPTS  = MDPSX-MNG01 - MDPSX-MNG02.
      ELSEIF MDPSX-PLUMI = BESTX.
        RECEIPTS  = MDPSX-MNG01.
      ENDIF.

      IF  ( RECEIPTS = RQMTOPEN )
      AND ( RECEIPTS > 0 ).

        READ TABLE MDPSX INDEX RQMTINDEX.
        IF SY-SUBRC = 0.
          PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
          MDABX-MNG02 = RECEIPTS.
          MDABX-INDEX = 0.
          APPEND MDABX.

          RECEIPTS = 0.
          RQMTOPEN = 0.
          RQMTINDEX = RQMTINDEX + 1.
          DESCRIBE TABLE MDABX LINES INDEX.      "Index MDABX
        ENDIF.

      ELSEIF ( RQMTOPEN = 0 )
      AND    ( RECEIPTS > 0 ).

        MDABINDEX = 0.
        PERFORM Z_ALLOCATE_REQUIREMENTS
                USING    MATNR WERKS BERID PLAAB PLANR
                         RECEIPTS RQMTINDEX MDABINDEX
                CHANGING RECEIPTS RQMTINDEX RQMTOPEN INDEX.

      ELSEIF ( RECEIPTS < RQMTOPEN )
      AND    ( RECEIPTS > 0        ).

        READ TABLE MDPSX INDEX RQMTINDEX.
        IF SY-SUBRC = 0.
          PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
          MDABX-MNG02 = RECEIPTS.
          MDABX-INDEX = 0.
          APPEND MDABX.

          RQMTOPEN = RQMTOPEN - RECEIPTS.
          RECEIPTS = 0.
          DESCRIBE TABLE MDABX LINES INDEX.      "Index MDABX
        ENDIF.

      ELSEIF ( RQMTOPEN < RECEIPTS )
      AND    ( RQMTOPEN > 0        ).

        READ TABLE MDPSX INDEX RQMTINDEX.
        IF SY-SUBRC = 0.
          PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
          MDABX-MNG02 = RQMTOPEN.
          MDABX-INDEX = 0.
          APPEND MDABX.
          DESCRIBE TABLE MDABX LINES MDABINDEX.

          RECEIPTS  = RECEIPTS - RQMTOPEN.
          RQMTINDEX = RQMTINDEX + 1.

          PERFORM Z_ALLOCATE_REQUIREMENTS
                  USING    MATNR WERKS BERID PLAAB PLANR
                           RECEIPTS RQMTINDEX MDABINDEX
                  CHANGING RECEIPTS RQMTINDEX RQMTOPEN INDEX.

        ENDIF.

      ENDIF.

      IF RECEIPTS > 0.
        RQMTFINI = 'X'.            "Keine weiteren Bedarfe gefunden
        RECEIPTS = 0.
      ENDIF.

      MDZUX-INDEX = INDEX.

    ENDIF.     "Zugänge
 "---------- DispoElememt einfuegen ------------------------------
    IF SAVE = 'X'.
      PERFORM Z_INSERT_SORTED_MDZUX.
    ENDIF.

  ENDLOOP.

* mill 0001 jw 000727
  data: lv_delkz  like mdps-delkz,
        lv_delps  like mdps-delps,
        lt_mdfa like mdfa occurs   0 with header line,
        lt_ord_pre_org like ord_pre occurs 0 with header line,
        subrc_u        like sy-subrc,
        mdfa_u_aufnr   like mdfa-aufnr,
        tfill          like sy-tabix.
  data: begin of planr_u,
          kdauf(10) type c,
          kdpos(6)  type n,
          fill1(4)  type c value '0000',
        end  of planr_u.
*
**  DATA: BEGIN OF lt_org_order_list OCCURS   0.
**              INCLUDE STRUCTURE mill_oc_org_order_list.
**  DATA: END OF lt_org_order_list.
*
** Initalisieren
*  clear:   lt_mdfa, lt_ord_pre_org, planr_u.
*  refresh: lt_mdfa, lt_ord_pre_org.
*  clear:   lv_delkz, lv_delps, subrc_u, tfill, mdfa_u_aufnr.
*
*  plaab = space.
*  planr = space.
*
*
**  loop at mdpsx where vrfkz = 'X'
**                or    atrkz = 'Z'.              "Bedarfsmengen
*    loop at mdpsx where vrfkz = 'X'.
*
*
*    SAVE = SPACE.
*
*    "---------- Wechsel Planungsabschnitt ---------------------------
*    IF ( MDPSX-PLAAB <> PLAAB )        "Wird auch das erste mal
*    OR ( MDPSX-PLANR <> PLANR ).       "ausgeführt
*
*      PLAAB = MDPSX-PLAAB.
*      PLANR = MDPSX-PLANR.
*
*      RQMTOPEN  = 0.
*      RQMTINDEX = SY-TABIX.
*      RQMTFINI  = SPACE.
*
*    ENDIF.
*
*    "---------- DispoElememt einfuegen für Zugänge ------------------
*    IF ( MDPSX-PLUMI = PLUSX )
*    OR ( MDPSX-PLUMI = BESTX ).
*
*      CLEAR MDZUX.
*      IF MDPSX-DEL12 IS INITIAL.
*        MDZUX-DELNR = MDPSX-DELNR.    "Nummer Dispositionselement
*      ELSE.
*        MDZUX-DELNR = MDPSX-DEL12.    "Nummer Dispositionselement
*      ENDIF.
*      MDZUX-DELPS = MDPSX-DELPS.      "Position Dispositionselement
*      MDZUX-DELET = MDPSX-DELET.      "Einteilung Dispoelement
*      MDZUX-DELKZ = MDPSX-DELKZ.      "ID Dispoelement
**      MDZUX-MATNR = MATNR.            "Material-/PG-Nummer
**--> PIC 4.6a : MPN/SUS , check for correct material number when Setmode
**      IF NOT MDPSX-MPNMT IS INITIAL.
**        MDZUX-MATNR = MDPSX-MPNMT.
**      ELSE.
**        MDZUX-MATNR = MATNR.            "Material-/PG-Nummer
**      ENDIF.
*      MDZUX-MATNR = MATNR.
**--> A&D 3.0 / PIC 4.6 End of Replace
*      MDZUX-WERKS = WERKS.            "Werk
*      MDZUX-BERID = BERID.            "Dispobereich
*      MDZUX-PLAAB = MDPSX-PLAAB.      "KZ Planungsabschnitt
*      MDZUX-PLANR = MDPSX-PLANR.      "Nummer Planungsabschnitt
*      MDZUX-DAT00 = MDPSX-DAT00.      "Zugangstermin (Tag)
*      MDZUX-MNG01 = MDPSX-MNG01.      "Zugangs-/Bestandsmenge
*      MDZUX-BAART = MDPSX-BAART.      "Beschaffungsart
*      MDZUX-INDEX = 0.                "Default falls RQMTFINI = 'X'
*      CALL FUNCTION 'EXTRAKT_AUS_MDPSX_BILDEN'
*           EXPORTING EMDPS  = MDPSX
*                     EMDKP  = LS_DUMMY
*                     CALL_BADI = xflag
*           IMPORTING IEXTRA = MDZUX-EXTRA.
*      SAVE = 'X'.
**--> Auftragsmenge um Ausschuß vermindern, wenn vorhanden HW 213249
*      IF NOT MDPSX-MNG02 IS INITIAL.
*        MDZUX-MNG01 = MDZUX-MNG01 - MDPSX-MNG02.
*      ENDIF.
*
*    ENDIF.
*
*    "---------- bei Sekundärbedarf Planauftrag suchen ------------
*    IF  MDPSX-DELKZ = SKBED          "Wenn Sekundärbedarf
*    AND MDPSX-PLUMI = MINUS.         "Jedoch kein Kuppelprodukt
*      RSNUM = MDPSX-DELNR.           "Type-Convert
*      DELVR = MDPSX-AUFVR.           "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID
*                    DISST PLAUF DELVR 0 0.
*    ENDIF.
*
*    "---------- bei Simulationsbedarf Simulationsauftrag suchen -----
*    IF  MDPSX-DELKZ = SMBED          "Wenn Simulationsbedarf
*    AND MDPSX-PLUMI = MINUS.         "Jedoch kein Kuppelprodukt
*      RSNUM = MDPSX-DELNR.           "Type-Convert
*      DELVR = MDPSX-AUFVR.           "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
*                    SAAUF DELVR 0 0.
*    ENDIF.
*
*    "---------- bei SimTransportbedarf Simulationsauftrag suchen ----
*    IF  MDPSX-DELKZ = UPABR     "Wenn SimTransportbedarf
*    AND NOT EPLSCN  IS INITIAL.
*      RSNUM = MDPSX-DELNR.      "Type-Convert
*      DELVR = MDPSX-DELNR.      "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
*                    SAAUF DELVR 0 0.
*    ENDIF.
*
*    "---------- bei Vorpl.Transportbedarf Vorpl.Planauftrag suchen --
*    IF  MDPSX-DELKZ =  UPABR
*    AND EPLSCN      IS INITIAL.
*      RSNUM = MDPSX-DELNR.      "Type-Convert
*      DELVR = MDPSX-DELNR.      "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
*                    PLAUF DELVR 0 0.
*    ENDIF.
*
**   "---------- Bei Summensekundaerbedarfen Planauftraege suchen
**   if mdpsx-delkz = subed.     "Wenn Summensekundaerbedarf
**     rsnum = mdpsx-delnr.
**     perform store_dependent_rqmt
**             using rsnum mdpsx-delps 0 matnr werks disst
**                   plauf space 0 0.
**   endif.
*
*    "---------- bei Reservierung Fertigungsauftrag suchen -----------
*    IF      MDPSX-DELKZ = ARBED     "Wenn Auftrags-Reservierung
*    AND     MDPSX-PLUMI = MINUS     "und  Abgangsreservierung
*    AND NOT MDPSX-BAUGR IS INITIAL.
*      RSNUM = MDPSX-DELNR.      "Type-Convert
**      PERFORM STORE_DEPENDENT_RQMT
**              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
**                    FEAUF MDPSX-DEL12 1 0.
** mill 0001 jw 000725
** bei zusammengefassten Aufträgen muss die Position und Delkz richtig
** übergeben werden. Wichtig: Baugruppe muss stimmen!
*      select * from mdfa into table lt_mdfa where aufnr = mdpsx-del12.
*      if sy-subrc > 0.
*         message s015(mf) with mdpsx-del12 1.
*         perform z_store_sy_message.
*         exit.
*      endif.
** Kundeneinzelfertigung Position merken
*      loop at lt_mdfa.
*          if lt_mdfa-matnr = mdpsx-baugr.
*             lv_delps = lt_mdfa-posnr.
*             exit.
*          endif.
*      endloop.
** Dispositionskennzeichen setzen
** IS2ERP XFO 17.8.2004 Viewfield MDFA-ATRKZ removed
*    data: lv_atrkz type atrkz.
*
*      select single atrkz from afko
*      into lv_atrkz
*      where aufnr = mdfa-aufnr.
*      if lv_atrkz = 'Z'.
*          if lt_mdfa-aftyp = '10'.
*             lv_delkz = omauf.
*          elseif lt_mdfa-aftyp = '40'.
*             lv_delkz = mpauf.
*          endif.
*
*          if lv_delps =  space. lv_delps = 1. endif.
*
*          perform Z_STORE_DEPENDENT_RQMT
*                  using rsnum mdpsx-delps 0 matnr werks berid disst
*                  lv_delkz mdpsx-del12 lv_delps 0.
*      else.
*          perform Z_STORE_DEPENDENT_RQMT
*                  using rsnum mdpsx-delps 0 matnr werks berid disst
*                        feauf mdpsx-del12 1 0.
*      endif.
*
*    ENDIF.
*
*    "---------- bei Banf-Abrufen TB-Banf suchen -----------------------
*    IF  MDPSX-DELKZ = UAABR.    "oder BestellanforderungsAbruf
*      RSNUM = MDPSX-DELNR.      "Type-Convert
*      DELVR = MDPSX-DELNR.      "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS MDPSX-DELET MATNR WERKS BERID
*                    DISST BSANF DELVR MDPSX-DELPS MDPSX-DELET.
*    ENDIF.
*
*    "---------- bei BestellAbrufen Bestellung suchen -----------------
*    IF  MDPSX-DELKZ = UBABR.    "BestellAbruf
*      RSNUM = MDPSX-DELNR.      "Type-Convert
*      DELVR = MDPSX-DELNR.      "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS MDPSX-DELET MATNR WERKS BERID
*                    DISST BSEIN DELVR MDPSX-DELPS MDPSX-DELET.
*    ENDIF.
*
*    "--------- Bei Lieferplanabrufen TB-Lieferplan such
*    IF MDPSX-DELKZ = ULABR.     "Lieferplanabruf
*      RSNUM = MDPSX-DELNR.      "Type-Convert
*      DELVR = MDPSX-DELNR.      "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS MDPSX-DELET
*                    MATNR WERKS BERID DISST LPEIN
*                    DELVR MDPSX-DELPS MDPSX-DELET.
*    ENDIF.
*
*    "---------- bei Bereitstellungsbedarfen Lohnberabeiterbanf lesen --
*    IF  MDPSX-DELKZ = BRBED.    "Wenn Bereitstellungsbedarf
*      RSNUM = MDPSX-DELNR.      "Type-Convert
*      DELVR = MDPSX-AUFVR.
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS MDPSX-DELET MATNR WERKS BERID
*                    DISST MDPSX-DELVR DELVR MDPSX-POSVR MDPSX-EINVR.
*    ENDIF.
*
*    "---------- Bei Umlagerungsreservierung Empfänger lesen --------
*    IF  MDPSX-DELKZ = MRBED     "Wenn Reservierung
*    AND MDPSX-DELVR = ULRES.    "und  Empfänger auch Reservierung
*      RSNUM = MDPSX-DELNR.      "Type-Convert
*      DELVR = MDPSX-DELNR.      "Type-Convert
*      PERFORM Z_STORE_DEPENDENT_RQMT
*              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST
*                    ULRES DELVR MDPSX-DELPS 0.
*    ENDIF.
*
*    "---------- Bei Umlagerungsreservierung aus DB Empfänger lesen ----
*    IF  MDPSX-DELKZ = MRBED     "Wenn Reservierung               "SA 45A
*    AND MDPSX-DELVR = UMRES.    "und  Empfänger Reservierung aus DB "SA
*      RSNUM = MDPSX-DELNR.      "Type-Convert                    "SA 45A
*      DELVR = MDPSX-DELNR.      "Type-Convert                    "SA 45A
*      PERFORM Z_STORE_DEPENDENT_RQMT                               "SA 45A
*              USING RSNUM MDPSX-DELPS 0 MATNR WERKS BERID DISST  "SA 45A
*                    UMRES DELVR MDPSX-DELPS 0.                   "SA 45A
*    ENDIF.                                                       "SA 45A
*
*    "---------- Bedarfsverursacher suchen ---------------------------
*    IF  RQMTFINI    = SPACE    "Noch Abgänge vorhanden
*    AND MDPSX-PLUMI = PLUSX    "Bedarfsverursacher nur für Zugänge
*    OR  MDPSX-PLUMI = BESTX.
**--> PIC : for receipts (not stock) : set original matnr
**      IF  NOT MDPSX-PLUMI = BESTX                             " PIC 4.6
**      AND NOT MDPSX-MPNMT IS INITIAL.
**         LV_PIC_MATNR = MDPSX-MPNMT.
**      ENDIF.
*
*
*      IF MDPSX-PLUMI = PLUSX.
**        RECEIPTS  = MDPSX-MNG01 - MDPSX-MNG02.
** mill 0001 jw 000726
** für zusammengefasste Aufträge Menge nicht berücksichtigen
*      if mdpsx-delkz = 'OM' or mdpsx-delkz = 'MP'.
*        receipts  = 0.
*      else.
*        receipts  = mdpsx-mng01 - mdpsx-mng02.
*      endif.
*      ELSEIF MDPSX-PLUMI = BESTX.
*        RECEIPTS  = MDPSX-MNG01.
*      ENDIF.
*
*      IF  ( RECEIPTS = RQMTOPEN )
*      AND ( RECEIPTS > 0 ).
*
*        READ TABLE MDPSX INDEX RQMTINDEX.
*        IF SY-SUBRC = 0.
*          PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
*          MDABX-MNG02 = RECEIPTS.
*          MDABX-INDEX = 0.
*          APPEND MDABX.
*
*          RECEIPTS = 0.
*          RQMTOPEN = 0.
*          RQMTINDEX = RQMTINDEX + 1.
*          DESCRIBE TABLE MDABX LINES INDEX.      "Index MDABX
*        ENDIF.
*
*      ELSEIF ( RQMTOPEN = 0 )
*      AND    ( RECEIPTS > 0 ).
*
*        MDABINDEX = 0.
*        PERFORM Z_ALLOCATE_REQUIREMENTS
*                USING    MATNR WERKS BERID PLAAB PLANR
*                         RECEIPTS RQMTINDEX MDABINDEX
*                CHANGING RECEIPTS RQMTINDEX RQMTOPEN INDEX.
*
*      ELSEIF ( RECEIPTS < RQMTOPEN )
*      AND    ( RECEIPTS > 0        ).
*
*        READ TABLE MDPSX INDEX RQMTINDEX.
*        IF SY-SUBRC = 0.
*          PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
*          MDABX-MNG02 = RECEIPTS.
*          MDABX-INDEX = 0.
*          APPEND MDABX.
*
*          RQMTOPEN = RQMTOPEN - RECEIPTS.
*          RECEIPTS = 0.
*          DESCRIBE TABLE MDABX LINES INDEX.      "Index MDABX
*        ENDIF.
*
*      ELSEIF ( RQMTOPEN < RECEIPTS )
*      AND    ( RQMTOPEN > 0        ).
*
*        READ TABLE MDPSX INDEX RQMTINDEX.
*        IF SY-SUBRC = 0.
*          PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
*          MDABX-MNG02 = RQMTOPEN.
*          MDABX-INDEX = 0.
*          APPEND MDABX.
*          DESCRIBE TABLE MDABX LINES MDABINDEX.
*
*          RECEIPTS  = RECEIPTS - RQMTOPEN.
*          RQMTINDEX = RQMTINDEX + 1.
*
*          PERFORM Z_ALLOCATE_REQUIREMENTS
*                  USING    MATNR WERKS BERID PLAAB PLANR
*                           RECEIPTS RQMTINDEX MDABINDEX
*                  CHANGING RECEIPTS RQMTINDEX RQMTOPEN INDEX.
*
*        ENDIF.
*
*      ENDIF.
*
*      IF RECEIPTS > 0.
*        RQMTFINI = 'X'.            "Keine weiteren Bedarfe gefunden
*        RECEIPTS = 0.
*      ENDIF.
*
**      MDZUX-INDEX = INDEX.
** mill 0001 jw 000726
** für zusammengefasste Aufträge Index nicht berücksichtigen
*      if mdpsx-delkz = 'OM' or mdpsx-delkz = 'MP'.
*         mdzux-index  = 0.
*      else.
*         mdzux-index = index.
*      endif.
*
*
*    ENDIF.     "Zugänge
*
*    "---------- DispoElememt einfuegen ------------------------------
*    IF SAVE = 'X'.
*      PERFORM Z_INSERT_SORTED_MDZUX.
*    ENDIF.
*
*  ENDLOOP.
* mill 0001 jw 000801
* globalle Tabelle ct_mdzux_u der selektierten Ursprungsaufträge
* aus mdzux füllen
  data: lv_tabix_u like sy-tabix,
        lv_tabix_z like sy-tabix,
        lv_aufnr_z like afpo-aufnr,
        lv_posnr_z like afpo-posnr,
        lv_planr_u like mdps-planr,
        lv_plaab_u like mdps-plaab.

  describe table ct_mdzux_u lines tfill.
  if tfill > 0.
    loop at ct_mdzux_u.
      if ct_mdzux_u-matnr = matnr      and
         ct_mdzux_u-mng01 = space      and
         ct_mdzux_u-index = space.

         lv_tabix_u = sy-tabix.
         lv_aufnr_z = ct_mdzux_u-aufnr.
         lv_posnr_z = ct_mdzux_u-posnr.
* Ursprungsauftrag in mdzux lesen
          read table mdzux with key delnr = ct_mdzux_u-delnr
                                    delps = ct_mdzux_u-delps
                                    delkz = ct_mdzux_u-delkz
                                    matnr = ct_mdzux_u-matnr
                                    werks = ct_mdzux_u-werks.
          if sy-subrc = 0.
             lv_planr_u = mdzux-planr.
             lv_plaab_u = mdzux-plaab.
* Tabelle ct_mdzux_u füllen
             ct_mdzux_u = mdzux.
             modify ct_mdzux_u index lv_tabix_u transporting
                         delet delkz berid plaab planr dat00
                         baart versb mng01 mng02 index alloc extra.
* Index im zusammengefassten Auftrag zufügen und Plannummer
             if mdzux-index <> space or lv_planr_u <> space.
               lv_tabix_u = mdzux-index.
               read table mdzux with key delnr = lv_aufnr_z
                                         delps = lv_posnr_z.
               lv_tabix_z = sy-tabix.
               mdzux-index = lv_tabix_u.
               mdzux-plaab = lv_plaab_u.
               mdzux-planr = lv_planr_u.
               modify mdzux index lv_tabix_z
                            transporting plaab planr index.

             endif.
           endif.
       endif.                 " Ende matnr
     endloop.
   endif.
  "------------ Speicher freigeben ----------------------------------
  CLEAR MDPSX. REFRESH MDPSX.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_STORE_DEPENDENT_RQMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RSNUM  text
*      -->P_MDPSX_DELPS  text
*      -->P_0      text
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*      -->P_DISST  text
*      -->P_PLAUF  text
*      -->P_DELVR  text
*      -->P_0      text
*      -->P_0      text
*----------------------------------------------------------------------*
FORM Z_STORE_DEPENDENT_RQMT
  USING RSNUM LIKE MDPS-DEL12
           RSPOS LIKE MDPS-DELPS
           RSEIN LIKE MDPS-DELET
           MATNR LIKE MT61D-MATNR
           WERKS LIKE MT61D-WERKS
           BERID LIKE MT61D-BERID
           DISST LIKE MT61D-DISST                            "Rekursion
           DELKZ LIKE MDPS-DELKZ
           DELNR LIKE MDPS-DEL12
           DELPS LIKE MDPS-DELPS
           DELET LIKE MDPS-DELET.

  DATA: BEGIN OF MT61DL.                                     "Rekursion
          INCLUDE STRUCTURE MT61D.                           "Rekursion
  DATA: END OF MT61DL.                                       "Rekursion
  DATA: BEGIN OF MDSBKY,
          RSNUM LIKE MDPS-DEL12,
          RSPOS LIKE MDPS-DELPS,
          RSEIN LIKE MDPS-DELET,
        END OF MDSBKY.

  DATA: BAUGR  LIKE MDSB-BAUGR,
        WERK2  LIKE MDSB-WERKS,
        BERID2 LIKE MT61D-BERID,
        SUBRC  TYPE I,
        TABIX  LIKE SY-TABIX.
   PERFORM Z_FIND_RECEIVING_PLANT_AND_MAT
          USING    DELNR DELPS DELET DELKZ
          CHANGING WERK2 BERID2 BAUGR SUBRC.

  MDSBKY-RSNUM = RSNUM.      "Sekundärbedarfsnummer
  MDSBKY-RSPOS = RSPOS.
  MDSBKY-RSEIN = RSEIN.

  READ TABLE MDSBX WITH KEY MDSBKY BINARY SEARCH. TABIX = SY-TABIX.

  MDSBX-RSNUM  = RSNUM.       "Sekundärbedarfsnummer
  MDSBX-RSPOS  = RSPOS.
  MDSBX-RSEIN  = RSEIN.
  MDSBX-MATNR  = MATNR.       "Dieses Material
*  IF NOT MDPSX-MPNMT IS INITIAL.
*    MDSBX-MATNR = MDPSX-MPNMT.
*  ELSE.
*    MDSBX-MATNR = MATNR.            "Material-/PG-Nummer
*  ENDIF.
  MDSBX-MATNR = MATNR.

MDSBX-WERKS  = WERKS.       "Dieses Werk
  MDSBX-BERID  = BERID.       "Dieser Dipsobereich
  MDSBX-BAUGR  = BAUGR.       "Uebergeordnete Baugruppe
  MDSBX-WERK2  = WERK2.       "Uebergeordnetes Werk
  MDSBX-BERID2 = BERID2.      "Uebergeordneter Dispobereich
  MDSBX-DELNR  = DELNR.       "Planauftragsnummer
  MDSBX-DELPS  = DELPS.
  MDSBX-DELET  = DELET.
  MDSBX-DELKZ  = DELKZ.       "Verursacher ist Plan-/Fertauftrag
  MDSBX-REKUR  = SPACE.

  IF  MATNR = BAUGR                                          "Rekursion
  AND WERKS = WERK2                                          "Rekursion
  AND BERID = BERID2.                                        "Rekursion
    MDSBX-REKUR = 'X'.                                       "Rekursion
  ELSEIF NOT BAUGR IS INITIAL.                               "Rekursion
    CALL FUNCTION 'MD_READ_MATERIAL'                         "Rekursion
         EXPORTING  EMATNR = BAUGR                           "Rekursion
                    EWERKS = WERK2                           "Rekursion
                    EBERID = BERID2                          "Rekursion
         IMPORTING  IMT61D = MT61DL                          "Rekursion
         EXCEPTIONS ERROR  = 01.                             "Rekursion
    IF SY-SUBRC > 0. PERFORM Z_STORE_SY_MESSAGE. EXIT. ENDIF.  "Rekursion
    IF  NOT MT61DL-DISST IS INITIAL                          "Rekursion
    AND NOT        DISST IS INITIAL                          "Rekursion
    AND     MT61DL-DISST >  DISST.                           "Rekursion
      MDSBX-REKUR = 'X'.                                     "Rekursion
    ENDIF.                                                   "Rekursion
  ENDIF.                                                     "Rekursion

  INSERT MDSBX INDEX TABIX.                                  "Rekursion
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_MDPSX_2_MDABX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*----------------------------------------------------------------------*
FORM Z_MDPSX_2_MDABX
  USING MATNR LIKE MT61D-MATNR
           WERKS LIKE MT61D-WERKS
           BERID LIKE MT61D-BERID.

  DATA: LS_DUMMY LIKE MDKP.

  CLEAR MDABX.
  MDABX-DELNR = MDPSX-DELNR.
  MDABX-DELPS = MDPSX-DELPS.
  MDABX-DELET = MDPSX-DELET.
  MDABX-DELKZ = MDPSX-DELKZ.
  MDABX-MATNR = MATNR.
*  IF NOT MDPSX-MPNMT IS INITIAL.
*    MDABX-MATNR = MDPSX-MPNMT.
*  ELSE.
*    MDABX-MATNR = MATNR.            "Material-/PG-Nummer
*  ENDIF.
   MDABX-MATNR = MATNR.
   MDABX-WERKS = WERKS.
  MDABX-BERID = BERID.
  MDABX-PLAAB = MDPSX-PLAAB.
  MDABX-PLANR = MDPSX-PLANR.
  MDABX-DAT00 = MDPSX-DAT00.
  MDABX-MNG01 = MDPSX-MNG01.
  MDABX-BAART = MDPSX-BAART.
  MDABX-VERSB = MDPSX-VERSB.
  IF MDPSX-DELKZ <> SAVETY_STOCK.
    CALL FUNCTION 'EXTRAKT_AUS_MDPSX_BILDEN'
         EXPORTING EMDPS  = MDPSX
                   EMDKP  = LS_DUMMY
                   CALL_BADI = xflag
         IMPORTING IEXTRA = MDABX-EXTRA.
  ENDIF.

  IF  MDPSX-DELKZ = MRBED            "Reservierung
  AND MDPSX-DELVR = ULRES.           "Transportreservierung
    MDABX-DELKZ = TRANSP_RQMT.
  ENDIF.
  IF MDPSX-DELKZ = MRBED
  AND MDPSX-DELVR = UMRES.
    MDABX-DELKZ = TRANSP_RQMT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_ALLOCATE_REQUIREMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR  text
*      -->P_WERKS  text
*      -->P_BERID  text
*      -->P_PLAAB  text
*      -->P_PLANR  text
*      -->P_RECEIPTS  text
*      -->P_RQMTINDEX  text
*      -->P_MDABINDEX  text
*      <--P_RECEIPTS  text
*      <--P_RQMTINDEX  text
*      <--P_RQMTOPEN  text
*      <--P_INDEX  text
*----------------------------------------------------------------------*
FORM Z_ALLOCATE_REQUIREMENTS
  USING          MATNR      LIKE MT61D-MATNR
                    WERKS      LIKE MT61D-WERKS
                    BERID      LIKE MT61D-BERID
                    PLAAB      LIKE MDPS-PLAAB
                    PLANR      LIKE MDPS-PLANR
              VALUE(RECEIPTS)  LIKE MDPS-MNG01
                    RQMTINDEX  LIKE SY-TABIX
              VALUE(MDABINDEX) LIKE SY-TABIX
     CHANGING       RECEIPTS2  LIKE MDPS-MNG01
                    RQMTINDEX2 LIKE SY-TABIX
                    RQMTOPEN2  LIKE MDPS-MNG01
                    NEXTINDEX  LIKE SY-TABIX.

  DATA: RQMTFOUND TYPE BOOL.    "Flag: Requirement found

  RQMTFOUND = SPACE.
  LOOP AT MDPSX
       FROM  RQMTINDEX
       WHERE VRFKZ = 'X'
       AND   PLUMI = MINUS.

    IF MDPSX-PLAAB <> PLAAB
    OR MDPSX-PLANR <> PLANR.
      RQMTINDEX2 = 0.
      RQMTOPEN2  = 0.
      EXIT.
    ENDIF.

    IF RECEIPTS = MDPSX-MNG01.
      RQMTINDEX2 = SY-TABIX + 1.
      PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
      MDABX-MNG02 = RECEIPTS.
      MDABX-INDEX = MDABINDEX.
      APPEND MDABX.
      RQMTOPEN2  = 0.
      RECEIPTS   = 0.
      RQMTFOUND  = 'X'.
      EXIT.
    ELSEIF RECEIPTS < MDPSX-MNG01.
      RQMTINDEX2 = SY-TABIX.
      PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
      MDABX-MNG02 = RECEIPTS.
      MDABX-INDEX = MDABINDEX.
      APPEND MDABX.
      RQMTOPEN2  = MDPSX-MNG01 - RECEIPTS.
      RECEIPTS   = 0.
      RQMTFOUND  = 'X'.
      EXIT.
    ELSEIF RECEIPTS > MDPSX-MNG01.
      PERFORM Z_MDPSX_2_MDABX USING MATNR WERKS BERID.
      MDABX-MNG02 = MDPSX-MNG01.
      MDABX-INDEX = MDABINDEX.
      APPEND MDABX.
      RQMTFOUND  = 'X'.
      RECEIPTS   = RECEIPTS - MDPSX-MNG01.
    ENDIF.

    DESCRIBE TABLE MDABX LINES MDABINDEX.

  ENDLOOP.

  IF RQMTFOUND = SPACE.       "Keine Bedarfe gefunden
    RQMTINDEX2 = 0.           "Keine weiteren Bedarfe
    RQMTOPEN2  = RECEIPTS.
    NEXTINDEX  = MDABINDEX.
  ELSE.
    RECEIPTS2 = RECEIPTS.
    DESCRIBE TABLE MDABX LINES NEXTINDEX.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Z_INSERT_SORTED_MDZUX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM Z_INSERT_SORTED_MDZUX .
DATA: BEGIN OF MDZU1.
          INCLUDE STRUCTURE MDZU.
  DATA: END OF MDZU1.
  DATA: SUBRC LIKE SY-SUBRC.

  MDZU1 = MDZUX.               "Kopfzeile in Puffer

  IF MDZU1-MNG01 = 0. EXIT. ENDIF.

  PERFORM Z_READ_RECEIPT_EXT
          USING    MDZUX-DELNR MDZUX-DELPS
                   MDZUX-DELET MDZUX-DELKZ
                   MDZUX-MATNR MDZUX-WERKS MDZUX-BERID
                   MDZUX-PLAAB MDZUX-PLANR MDZUX-DAT00
          CHANGING MDZUX SUBRC.

  MDZUX       = MDZU1.              "Puffer zurück
  IF SUBRC = 8.
    APPEND MDZUX.
  ELSE.
    INSERT MDZUX INDEX SY-TABIX.
  ENDIF.
ENDFORM.
