*&---------------------------------------------------------------------*
*&  Include           ZXV50U07
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*
* OBJECT ID              :
* FUNCTIONAL ANALYST     :  ABHINAY GANDHE
* PROGRAMMER             :  RAUT SUNITA
* START DATE             :  12/04/2011
* INITIAL TRANSPORT NO   :
* DESCRIPTION            :  TO CHECK THE PO DELIVERY DATE FOR SUBCONTRACTING MATERIAL.
*----------------------------------------------------------------------*
* INCLUDES               :
* FUNCTION MODULES       :
*
* LOGICAL DATABASE       :
* TRANSACTION CODE       :
* EXTERNAL REFERENCES    :
*----------------------------------------------------------------------*
*                    MODIFICATION LOG
*----------------------------------------------------------------------*
* DATE      | MODIFIED BY   | CTS NUMBER   | COMMENTS
*----------------------------------------------------------------------*

TYPES:BEGIN OF t_ekko,
        ebeln TYPE ekko-ebeln,
        lifnr TYPE ekko-lifnr,
        frgke TYPE ekko-frgke,
      END OF t_ekko.

TYPES:BEGIN OF t_ekpo,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        pstyp TYPE ekpo-pstyp,
      END OF t_ekpo.

TYPES: BEGIN OF t_eket,
         ebeln LIKE eket-ebeln,
         ebelp LIKE eket-ebelp,
         eindt LIKE eket-eindt,
       END OF t_eket,

       BEGIN OF ty_zenhns_act,
         title     LIKE zenhns_act-title,
         werks     LIKE zenhns_act-werks,
         exit_desc LIKE zenhns_act-exit_desc,
         vldtl     LIKE zenhns_act-vldtl,
         activ     LIKE zenhns_act-activ,
       END OF ty_zenhns_act.

DATA:it_ekko TYPE STANDARD TABLE OF t_ekko,
     wa_ekko TYPE t_ekko.

DATA:it_likp TYPE STANDARD TABLE OF likp,
     wa_likp TYPE likp.

DATA:it_ekpo TYPE STANDARD TABLE OF t_ekpo,
     wa_ekpo TYPE t_ekpo.

DATA:it_eket TYPE STANDARD TABLE OF t_eket,
     wa_eket TYPE t_eket.

DATA:it_zenhns_act TYPE STANDARD TABLE OF ty_zenhns_act,
     wa_zenhns_act TYPE ty_zenhns_act.

DATA:v_tolerance TYPE i ."NUMERIC LIKE EKET-EINDT.

IF NOT is_likp-lifnr IS INITIAL.
  SELECT
  ebeln
  lifnr
  frgke
  FROM ekko
  INTO TABLE it_ekko
  WHERE lifnr = is_likp-lifnr.
  SORT it_ekko BY ebeln.
ENDIF.


****CHECKING ENHANCEMENT IS ACTIVE OR NOT.
SELECT
title
werks
exit_desc
vldtl
activ
FROM zenhns_act
INTO TABLE it_zenhns_act
WHERE title = 'ZSUB_PO_DEL'.


READ TABLE it_zenhns_act INTO wa_zenhns_act WITH KEY werks = is_lips-werks.

IF wa_zenhns_act-activ  = 'X'.


  IF NOT it_ekko[] IS INITIAL.
    SELECT
    ebeln
    ebelp
    pstyp
    FROM ekpo
    INTO TABLE it_ekpo
    FOR ALL ENTRIES IN it_ekko
    WHERE ebeln = it_ekko-ebeln
    AND pstyp = '3'
    AND elikz <> 'X'.
****SELECTING DATE FROM LIKP.
    IF NOT it_ekpo[] IS INITIAL.
      SELECT vbeln lfdat
      INTO CORRESPONDING FIELDS OF TABLE  it_likp
      FROM likp FOR ALL ENTRIES IN it_ekpo
      WHERE zebeln = it_ekpo-ebeln.
    ENDIF.
  ENDIF.
*  ENDIF.

  LOOP AT it_likp INTO wa_likp.
    v_tolerance = sy-datum - wa_likp-lfdat.
****COMPARING THE LFDAT WITH SY-DATUM.
    IF v_tolerance > wa_zenhns_act-vldtl.
      MESSAGE e005(zdel) WITH  wa_zenhns_act-vldtl.
    ENDIF.
    CLEAR wa_zenhns_act.
  ENDLOOP.
ENDIF.
***********************************************************************
