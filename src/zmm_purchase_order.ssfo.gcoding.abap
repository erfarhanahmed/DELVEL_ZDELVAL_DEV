*BREAK fujiabap.
*READ TABLE xekpo INDEX 1.
*
*IF XEKPO-RETPO EQ 'X'.
*  RETURN_NO = 'X'.
* ELSE.
*    RETURN_NO = ''.
* ENDIF.


IF xekko-frgke = 'X'.
  bg_img = 'ZDRAFT_BG'.
  bg_typ = 'BCOL'.
ELSE.
  bg_img = 'ZBLANK_BG'.
  bg_typ = 'BMON'.
ENDIF.

**BREAK fujiabap.
CHECK XEKPO-RETPO EQ 'X' AND xekko-frgke = 'X'.
  IF SY-SUBRC = 0.
  bg_img = 'NEW_PO_REJ_PR'. "'ZAP_PO'.   "'PO161MT'.
  bg_typ = 'BCOL'.
ENDIF.


DATA : wa_ekpo      LIKE LINE OF xekpo,
       wa_eket      LIKE LINE OF xeket,
       wa_konv      LIKE LINE OF xtkomv,
       objname(70)  TYPE c,
       item_konv    TYPE ty_tab_item_konv,
       wa_item_konv TYPE komv,
       last_item    TYPE ty_item.

REFRESH : it_items,
          it_konv.

CLEAR : wa_ekpo,
        wa_eket,
        wa_konv,
        wa_item,
        last_item.

* set Form Title
form_title = 'PURCHASE ORDER'.

* set header data
wa_hdr-ebeln = xekko-ebeln.
wa_hdr-bsart = xekko-bsart.
wa_hdr-bukrs = xekko-bukrs.
wa_hdr-lifnr = xekko-lifnr.
wa_hdr-zterm = xekko-zterm.
wa_hdr-aedat = xekko-aedat.
wa_hdr-zbd1t = xekko-zbd1t.
wa_hdr-waers = xekko-waers.
wa_hdr-inco1 = xekko-inco1.
wa_hdr-inco2 = xekko-inco2.
wa_hdr-knumv = xekko-knumv.


* set list-items' details
LOOP AT xekpo INTO wa_ekpo.
  CLEAR wa_item.
  wa_item-ebelp = wa_ekpo-ebelp.
  wa_item-matnr = wa_ekpo-matnr.
  wa_item-txz01 = wa_ekpo-txz01.
  wa_item-werks = wa_ekpo-werks.
  wa_item-menge = wa_ekpo-menge.
  wa_item-meins = wa_ekpo-meins.
  wa_item-netpr = wa_ekpo-netpr.
  wa_item-netwr = wa_ekpo-netwr.
  wa_item-ntgew = wa_ekpo-ntgew.
  wa_item-gewei = wa_ekpo-gewei.
  wa_item-banfn = wa_ekpo-banfn.
  APPEND wa_item TO it_items.

ENDLOOP.


* SET the value for PO-plant
wa_hdr-werks  = wa_item-werks.
* Set the Purchase Requisition Number in the header data
wa_hdr-banfn  = wa_item-banfn.

* Fetch the excise/tax registration details
SELECT SINGLE j_1iexrn
              j_1iexrg
              j_1iexdi
              j_1iexco
              j_1isern
              j_1icstno
              j_1ilstno
FROM j_1imocomp
INTO CORRESPONDING FIELDS OF wa_hdr
WHERE werks = wa_hdr-werks.

* Ftech date of latest modification
SELECT SINGLE MAX( udate )
  FROM cdhdr
  INTO wa_hdr-udate
  WHERE objectid = wa_hdr-ebeln.


* fetch The Value of delivery date for each of the list-items
READ TABLE xeket INTO wa_eket INDEX 1.
IF sy-subrc = 0.
  wa_hdr-eindt  = wa_eket-eindt.
  wa_hdr-slfdt  = wa_eket-slfdt.
ELSEIF wa_hdr-ebeln IS NOT INITIAL.
  SELECT SINGLE eindt slfdt
    FROM eket
    INTO (wa_hdr-eindt,wa_hdr-slfdt)
    WHERE ebeln = wa_hdr-ebeln.
ENDIF.


SELECT SINGLE butxt
  FROM t001
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE bukrs = wa_hdr-bukrs.


SELECT SINGLE adrnr
  FROM t001w
  INTO wa_hdr-p_adrnr
  WHERE werks = wa_hdr-werks.

*SELECT SINGLE addrnumber
*              name_co
*              str_suppl1
*              str_suppl2
*              street
*              city1
*              post_code1
*              time_zone
*    FROM adrc
*    INTO wa_adrc
*  WHERE addrnumber = wa_hdr-p_adrnr.

IF sy-subrc = 0.
  SELECT SINGLE a~addrnumber
                a~name1
                a~str_suppl1
                a~str_suppl2
                a~street
                a~city1
                a~post_code1
                b~bezei
                a~country
                a~tel_number
                a~fax_number
                a~extension2
    INTO wa_adrc    "bf_adrc
    FROM adrc AS a JOIN t005u AS b
    ON ( b~land1 = a~country AND b~bland = a~region )
    WHERE addrnumber = wa_hdr-p_adrnr.  "lv_adrnr.

  SELECT SINGLE landx FROM t005t
    INTO wa_adrc-landx
    WHERE spras = sy-langu
      AND land1 = wa_adrc-country.

  SELECT SINGLE smtp_addr FROM adr6
    INTO wa_adrc-smtp_addr
    WHERE addrnumber = wa_hdr-p_adrnr.  "lv_adrnr.

  SELECT SINGLE remark FROM adrct
    INTO wa_adrc-cin
    WHERE addrnumber = wa_hdr-p_adrnr.


ENDIF.


SELECT SINGLE adrnr name1
  FROM lfa1
  INTO (wa_hdr-v_adrnr, wa_hdr-v_name1)
  WHERE lifnr = wa_hdr-lifnr.

*SELECT matnr
*  zeinr
*  ntgew
*  gewei
  select *
  FROM mara
  INTO CORRESPONDING FIELDS OF TABLE it_mara
  FOR ALL ENTRIES IN it_items
  WHERE matnr = it_items-matnr.

SORT it_items BY ebelp.
LOOP AT it_items INTO wa_item.

  READ TABLE it_mara INTO wa_mara
    WITH KEY matnr = wa_item-matnr.
  IF sy-subrc EQ 0.
    wa_item-zeinr =  wa_mara-zeinr.
    wa_item-ntgew =  wa_mara-ntgew.
    wa_item-gewei =  wa_mara-gewei.
    wa_item-zeivr =  wa_mara-zeivr.
  ENDIF.

*  wa_item-eindt = wa_hdr-eindt.
  SELECT SINGLE eindt bedat FROM eket
    INTO (wa_item-eindt, wa_item-slfdt)
    WHERE ebeln = wa_hdr-ebeln
      AND ebelp = wa_item-ebelp.

*  wa_item-slfdt = wa_hdr-slfdt.

  CLEAR objname.
  CONCATENATE wa_hdr-ebeln wa_item-ebelp INTO objname.
  PERFORM get_text USING objname 'EKPO' 'F01' 'E' CHANGING wa_item-itm_txt.
  CONDENSE wa_item-itm_txt.

  SELECT SINGLE vbeln vbelp
    FROM ekkn
    INTO (wa_item-vbeln, wa_item-vbelp)
    WHERE ebeln = wa_hdr-ebeln AND ebelp = wa_item-ebelp.
  IF sy-subrc EQ 0.
    CLEAR objname.
    objname = wa_item-vbeln.
    "PERFORM get_text USING OBJNAME 'EKPO' 'F04' 'E' CHANGING WA_ITEM-ADTXT.
    PERFORM get_text USING objname 'VBBK' 'Z999' 'E' CHANGING wa_item-adtxt.

    CLEAR objname.
    CONCATENATE wa_item-vbeln wa_item-vbelp INTO objname.
    PERFORM get_text USING objname 'VBBP' 'Z888' 'E' CHANGING wa_item-adtxt.
    CONDENSE wa_item-adtxt.
  ENDIF.

  MODIFY it_items FROM wa_item.
  CLEAR wa_item.
ENDLOOP.

* For Pricing conditions
DATA : lc TYPE i VALUE 0.

DESCRIBE TABLE xtkomv LINES lc.

IF lc EQ 0.
  SELECT * FROM konv INTO TABLE xtkomv
    WHERE knumv = wa_hdr-knumv
      AND kschl IN ('ZPFL', 'ZPFV', 'ZPC1','JEC1','FRA1','FRB1'
                    ,'FRC1','ZOC','ZOCQ','ZOCV','R000','R001'
                    ,'R002','RA01','JMOP','JSEP','ZINS', 'ZAMV'
                    ,'JSER', 'JSV2', 'JSSB', 'JKKP', 'ZSTV'
                    ,'JOCM','JMX1','JEX1','JHX1', 'NAVS').
ELSE.
  "if the condition type does not belong to the given list as mentioned above then it should not be included in the list
  DELETE xtkomv WHERE kschl NE 'ZPFL'
                        AND kschl NE 'ZPFV'
                        AND kschl NE 'ZPC1'
                        AND kschl NE 'JEC1'
                        AND kschl NE 'JVRD'
                        AND kschl NE 'FRA1'
                        AND kschl NE 'FRB1'
                        AND kschl NE 'FRC1'
                        AND kschl NE 'ZOC'
                        AND kschl NE 'ZOCQ'
                        AND kschl NE 'ZOCV'
                        AND kschl NE 'R000'
                        AND kschl NE 'R001'
                        AND kschl NE 'R002'
                        AND kschl NE 'RA01'
                        AND kschl NE 'JMOP'
                        AND kschl NE 'JSEP'
                        AND kschl NE 'ZINS'
                        AND kschl NE 'ZAMV'
*                        AND kschl NE 'ZINR'   "-Jayant9.3.17
                        AND kschl NE 'JSER'
                        AND kschl NE 'JSV2'
                        AND kschl NE 'JSSB'
                        AND kschl NE 'JKKP'
                        AND kschl NE 'JOCM'
                        AND kschl NE 'JMX1'
                        AND kschl NE 'JEX1'
                        AND kschl NE 'JHX1'
                        AND kschl NE 'ZSTV'
                        AND kschl NE 'NAVS'.
ENDIF.

LOOP AT it_items INTO wa_item.
  REFRESH item_konv.
  PERFORM calculate_item_tax USING wa_hdr-ebeln wa_item-ebelp item_konv.
  IF NOT item_konv IS INITIAL.
    DESCRIBE TABLE item_konv.
    IF sy-tfill <> 0.
      LOOP AT item_konv INTO wa_konv WHERE kposn = wa_item-ebelp.
        IF   wa_konv-kschl = 'JMOP'
          OR wa_konv-kschl = 'JEC1'
          OR wa_konv-kschl = 'JSEP'
          OR wa_konv-kschl = 'JMX1'
          OR wa_konv-kschl = 'JEX1'
          OR wa_konv-kschl = 'JHX1'
          OR wa_konv-kschl = 'JVRD'
          OR wa_konv-kschl = 'JVCS'
          OR wa_konv-kschl = 'JSER'
          OR wa_konv-kschl = 'JSV2'
          OR wa_konv-kschl = 'JSSB'
          OR wa_konv-kschl = 'JKKP'.

          IF wa_konv-kschl = 'JEX1' OR wa_konv-kschl = 'JHX1'.
            wa_konv-kschl = 'JMX1'. " To club them together under same Title - 'ModVAT'
          ENDIF.

          APPEND wa_konv TO xtkomv.
          CLEAR wa_konv.
        ENDIF.

      ENDLOOP.
      REFRESH item_konv.
    ENDIF.
  ENDIF.
ENDLOOP.

DESCRIBE TABLE xtkomv LINES lc.

IF lc > 0.
  DATA: v_index TYPE i.
  "..............................................
*  CLEAR wa_konv.
*  wa_konv-kschl ='FRA1'.
*  MODIFY xtkomv FROM wa_konv TRANSPORTING kschl WHERE kschl = 'FRB1'
*                                                   OR kschl = 'FRC1'.
*
*  CLEAR wa_konv.
*  wa_konv-kschl ='ZOC'.
*  MODIFY xtkomv FROM wa_konv TRANSPORTING kschl WHERE kschl = 'ZOCQ'
*                                                   OR kschl = 'ZOCV'.

  CLEAR wa_konv.
  wa_konv-kschl ='R000'.
  MODIFY xtkomv FROM wa_konv TRANSPORTING kschl
    WHERE kschl = 'R001'
       OR kschl = 'R002'
       OR kschl = 'RA01'.

  CLEAR wa_konv.
  wa_konv-kschl ='JMX1'.
  MODIFY xtkomv FROM wa_konv TRANSPORTING kschl
    WHERE kschl = 'JEX1'
       OR kschl = 'JHX1'.

  "..............................................
  SORT xtkomv BY kschl.

  CLEAR : wa_konv, bf_konv.

  LOOP AT xtkomv INTO wa_konv.
    IF bf_konv-kschl <> wa_konv-kschl.
      IF NOT bf_konv IS INITIAL.
        PERFORM append_condition TABLES it_konv CHANGING bf_konv.
      ENDIF.
      bf_konv-kschl = wa_konv-kschl.
      ".........................................
      bf_konv-kbetr = wa_konv-kbetr.
      bf_konv-waers = wa_konv-waers.
      IF ( NOT bf_konv-kbetr IS INITIAL ) AND bf_konv-waers IS INITIAL.
        bf_konv-waers = '%'.
        bf_konv-kbetr = bf_konv-kbetr / 10.
        REPLACE '.00' IN bf_konv-kbetr WITH ''.
      ENDIF.
      ".........................................
    ENDIF.
    bf_konv-kwert = bf_konv-kwert + wa_konv-kwert.
    CLEAR wa_konv.
  ENDLOOP.

  PERFORM append_condition TABLES it_konv CHANGING bf_konv.

  " CHANGE BY SAUMITRA START FOR REMOVING BOTH IF SQ_NO 7 HAS TW0 VALUES
  LOOP AT it_konv INTO bf_konv WHERE sq_no = 7.
    v_index = v_index + 1.
  ENDLOOP.

  IF v_index > 1.
    DELETE it_konv WHERE sq_no = 7.
  ENDIF.
  "----------- CHANGE BY SAUMITRA ENDED------------------------- "

  SORT it_konv BY sq_no.

ENDIF.
*BREAK JBONDALE.
*CSTNO/Date & LSTNO/Date
FIND REGEX '([\d]{2}[\-|/][\d]{2}[\-|/][\d]{4})' IN wa_hdr-j_1icstno SUBMATCHES wa_hdr-j_1icstdt.
REPLACE wa_hdr-j_1icstdt IN wa_hdr-j_1icstno WITH ''.
REPLACE '/' IN wa_hdr-j_1icstno WITH ''.

FIND REGEX '([\d]{2}[\-|/][\d]{2}[\-|/][\d]{4})' IN wa_hdr-j_1ilstno SUBMATCHES wa_hdr-j_1ilstdt.
REPLACE wa_hdr-j_1ilstdt IN wa_hdr-j_1ilstno WITH ''.
REPLACE '/' IN wa_hdr-j_1ilstno WITH ''.

* Payment Terms - Text
IF NOT wa_hdr-zterm IS INITIAL.
*  SELECT SINGLE vtext
*    FROM tvzbt
  SELECT SINGLE text1 from t052u
    INTO wa_hdr-zterm_txt
    WHERE zterm = wa_hdr-zterm AND spras = 'E'.
  IF sy-subrc EQ 0.
*    CONCATENATE wa_hdr-zterm '-' wa_hdr-zterm_txt INTO wa_hdr-zterm_txt.
*    CONCATENATE wa_hdr-zterm_txt INTO wa_hdr-zterm_txt.
    CONDENSE wa_hdr-zterm_txt.
  ENDIF.
ENDIF.
