*ITMTXT*&---------------------------------------------------------------------*
* Include           ZSD_PENDING_SO_DATASEL.
*&---------------------------------------------------------------------*
* Modification History
*&---------------------------------------------------------------------*
* ID   | Breif
*&---------------------------------------------------------------------*
* 001
* 002
*&---------------------------------------------------------------------*
* 003  | Changes made to add custom material code per JIRa CAMS100-29732
*&---------------------------------------------------------------------*
DATA:
    ls_exch_rate TYPE bapi1093_0.
DATA: lv_msg(80).        " commented by sonu

START-OF-SELECTION.

  IF open_so = 'X'.
*    BREAK-POINT.
*    SELECT a~vbeln
*           a~posnr
*           a~matnr
*           a~lgort
*           b~lfsta
*           b~lfgsa
*           b~fksta
*           b~absta
*           b~gbsta
*    INTO TABLE it_data
*    FROM  vbap AS a
*    JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
**    JOIN  vbak AS C ON a~vbeln = c~vbeln
*    WHERE a~erdat  IN s_date
**    WHERE C~AUDAT  IN S_DATE
*    AND   a~matnr  IN s_matnr
*    AND   a~vbeln  IN s_vbeln         "SHREYAS
*    AND   b~lfsta  NE 'C'
*    AND   b~lfgsa  NE 'C'
*    AND   b~fksta  NE 'C'
*    AND   b~gbsta  NE 'C'.
**    AND   A~WERKS  = 'PLO1'.

    SELECT   a~vbeln
             a~posnr
             a~matnr
             a~lgort
             a~lfsta
             a~lfgsa
*             a~fksta
             a~fksaa
             a~absta
             a~gbsta
      INTO TABLE it_data
      FROM  vbap AS a
*    JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
*    JOIN  vbak AS C ON a~vbeln = c~vbeln
      WHERE a~erdat  IN s_date
*    WHERE C~AUDAT  IN S_DATE
      AND   a~matnr  IN s_matnr
      AND   a~vbeln  IN s_vbeln.       "SHREYAS
*      AND   a~lfsta  NE 'C'
*      AND   a~lfgsa  NE 'C'
**    AND   a~fksta  NE 'C'
*    AND   a~fksaa  NE 'C'
*      AND   a~gbsta  NE 'C'.

*******ADDED BY SNEHAL RAJALE ON 29 JAN 201************
    LOOP AT it_data INTO ls_data.
      IF ls_data-absta = 'C'.
        IF ls_data-lfsta = ' ' AND ls_data-lfgsa = ' ' AND ls_data-fksta = ' ' AND ls_data-gbsta = ' '.
          IF sy-subrc = 0.
*            delete it_data[] from ls_data.
            DELETE it_data[]  WHERE vbeln = ls_data-vbeln AND posnr = ls_data-posnr.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

*********************
*    lv_vbeln = ls_data-vbeln.
*
*    SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
**        FOR ALL ENTRIES IN it_data
*      WHERE objectclas = 'VERKBELEG'
*      AND objectid = lv_vbeln
*      AND tcode = 'VA02'.
*
*    SORT it_cdhdr BY udate DESCENDING.
***************************
    IF it_data IS NOT INITIAL .                                                 "commented by sonu
*******************        edited by PJ on 16-08-21
      SELECT matnr item_type bom zpen_item zre_pen_item FROM mara
        INTO TABLE it1_mara
        FOR ALL ENTRIES IN it_data WHERE matnr = it_data-matnr.

    ENDIF.                                                                       "commented by sonu

*****************        end

*******ENDED BY SNEHAL RAJALE ON 29 JAN 2021************
*        IF sy-subrc = 0.
    IF it_data[] IS NOT INITIAL.
      SELECT vbeln
             erdat
             auart
             vkorg "ADDED BY AAKASHK 19.08.2024
             vtweg  "ADDED BY AAKASHK 19.08.2024
             spart "ADDED BY AAKASHK 19.08.2024
             lifsk
             waerk
             vkbur
             knumv
             vdatu
             bstdk
             kunnr
             objnr              "added by pankaj 04.02.2022
             zldfromdate
             zldperweek
             zldmax
*             faksk
             FROM vbak INTO TABLE it_vbak
             FOR ALL ENTRIES IN it_data WHERE vbeln = it_data-vbeln AND
                                              kunnr IN s_kunnr.          " SHREYAS.
*      if it_vbak is not initial.
*        select spras
*               faksp
*               vtext
*          from tvfst into table it_tvfst
*          for all entries in it_vbak
*          where faksp = it_vbak-faksk
*          and spras = 'EN'.
*      endif.

      PERFORM fill_tables.
      PERFORM process_for_output.
      IF p_down IS INITIAL.
        PERFORM alv_for_output .

      ELSE.
        PERFORM down_set TABLES it_output USING p_folder..                                           "commented by sonu
      ENDIF.

    ENDIF.

  ELSEIF all_so = 'X'.
*******************************
*    lv_vbeln = ls_data-vbeln.
*
*    SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
**        FOR ALL ENTRIES IN it_data
*      WHERE objectclas = 'VERKBELEG'
*      AND objectid = lv_vbeln
*      AND tcode = 'VA02'.
*
*    SORT it_cdhdr BY udate DESCENDING.
*********************************
    SELECT vbeln
           erdat
           auart
           vkorg "ADDED BY AAKASHK 19.08.2024
           vtweg  "ADDED BY AAKASHK 19.08.2024
           spart "ADDED BY AAKASHK 19.08.2024
           lifsk
           waerk
           vkbur
           knumv
           vdatu
           bstdk
           kunnr
           objnr              "added by pankaj 04.02.2022
           zldfromdate
           zldperweek
           zldmax
*           faksk
           FROM vbak INTO TABLE it_vbak WHERE erdat IN s_date AND
                                                vbeln IN s_vbeln AND "shreyas
                                                kunnr IN s_kunnr . "shreyas.
*                                                bukrs_vf = 'PL01'.

*    if it_vbak is not initial.
*      select spras
*             faksp
*             vtext
*        from tvfst into table it_tvfst
*        for all entries in it_vbak
*        where faksp = it_vbak-faksk
*        and spras = 'EN'.
*    endif.

**************************************************************************************
*      select * from vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_vbak where vbeln = it_vbak-vbeln.
**************************************************************************************
    IF sy-subrc = 0.
      PERFORM fill_tables.
      PERFORM process_for_output.
      IF p_down IS   INITIAL.
        PERFORM alv_for_output .
      ELSE.
*        BREAK Primus.
        PERFORM down_set_all TABLES it_output USING p_folder..
      ENDIF.
    ENDIF.

*  ELSE.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

FORM fill_tables .

  IF open_so = 'X'.
    SELECT vbeln
           posnr
           matnr
           arktx
           abgru
           posex
           kdmat
           waerk
           kwmeng
           werks
           ntgew                  "added by pankaj 28.01.2022
           objnr
           holddate
           holdreldate
           canceldate
           deldate
           custdeldate
           zgad
           ctbg
           receipt_date            "added by pankaj 28.01.2022
           reason                   "added by pankaj 28.01.2022
           ofm_date               "added by pankaj 01.02.2022
           erdat
           zins_loc
           lgort        "added by jyoti on 11.06.2024
           zmrp_date    "added by jyoti on 02.07.2024
           zexp_mrp_date1   "added by jyoti on 02.07.2024
           zhold_reason_n1 "added by jyoti on 06.02.2025
           ZMENG " Added by sagar darade on 16/03/2026 to get target qty
           FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_data WHERE vbeln = it_data-vbeln
                                       AND posnr = it_data-posnr
                                       AND werks = 'PL01'.

***************************ADDED BY DH**************
    IF it_vbap IS NOT INITIAL.
      LOOP AT it_vbap INTO wa_vbap.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = wa_vbap-vbeln
          IMPORTING
            output = lv_vbeln.

        MOVE-CORRESPONDING wa_vbap TO wa_vbap2.
        wa_vbap2-vbeln = lv_vbeln.
        APPEND wa_vbap2 TO it_vbap2.

      ENDLOOP.

      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.      "UNCOMMENTED BY AAKASHK 03.10.2024
    ENDIF.

    LOOP AT it_vbap2 INTO wa_vbap2.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_vbap2-vbeln
        IMPORTING
          output = lv_vbeln2.

      wa_vbap2-vbeln = lv_vbeln2.
      MODIFY it_vbap2 FROM wa_vbap2.
    ENDLOOP.

    IF it_vbap2 IS NOT INITIAL.

      SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
       FOR ALL ENTRIES IN it_vbap2
     WHERE objectclas = 'VERKBELEG'
     AND objectid = it_vbap2-vbeln             "it_vbap-vbeln
      AND tcode = 'VA02'.
    ENDIF.

    SORT it_cdhdr BY udate DESCENDING.
*******************************************

*******************        edited by PJ on 16-08-21
    SELECT matnr item_type bom zpen_item zre_pen_item FROM mara
      INTO TABLE it1_mara
      FOR ALL ENTRIES IN it_vbap WHERE matnr = it_vbap-matnr.

*****************        end


**************** Reject Service Sale Order Remove From Pending So(Radio Button)
    LOOP AT it_vbak INTO wa_vbak WHERE auart = 'ZESS' OR auart = 'ZSER'.
      LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln AND abgru NE ' '.
        DELETE it_vbap WHERE vbeln = wa_vbap-vbeln AND posnr = wa_vbap-posnr.
      ENDLOOP.
    ENDLOOP.
**************************************************************************



  ELSE.
    SELECT vbeln
           posnr
           matnr
           arktx
           abgru
           posex
           kdmat
           waerk
           kwmeng
           werks
           ntgew                "added by pankaj 28.01.2022
           objnr
           holddate
           holdreldate
           canceldate
           deldate
           custdeldate
           zgad
           ctbg
           receipt_date            "added by pankaj 28.01.2022
           reason                   "added by pankaj 28.01.2022
           ofm_date
           erdat
           zins_loc
           lgort                "added by jyoti on 11.06.2024
           zmrp_date            "added b jyoti on 02.07.2024
           zexp_mrp_date1           "added b jyoti on 13.11.2024
            zhold_reason_n1 "added by jyoti on 06.02.2025
           Zmeng            " added b sagar darade on 16/03/2026 to get target qty
           FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_vbak WHERE vbeln = it_vbak-vbeln
                                        AND werks = 'PL01'.
  ENDIF.
  IF it_vbap[] IS NOT INITIAL.

*****************************ADDED BY DH************
*    lv_vbeln = wa_vbap-vbeln.
    IF it_vbap IS NOT INITIAL.
      LOOP AT it_vbap INTO wa_vbap.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = wa_vbap-vbeln
          IMPORTING
            output = lv_vbeln.

        MOVE-CORRESPONDING wa_vbap TO wa_vbap2.
        wa_vbap2-vbeln = lv_vbeln.
        APPEND wa_vbap2 TO it_vbap2.

      ENDLOOP.
*      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
    ENDIF.

    LOOP AT it_vbap2 INTO wa_vbap2.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_vbap2-vbeln
        IMPORTING
          output = lv_vbeln2.

      wa_vbap2-vbeln = lv_vbeln2.
      MODIFY it_vbap2 FROM wa_vbap2.
    ENDLOOP.

    IF it_vbap2 IS NOT INITIAL.

      SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
       FOR ALL ENTRIES IN it_vbap2
     WHERE objectclas = 'VERKBELEG'
     AND objectid = it_vbap2-vbeln             "it_vbap-vbeln
      AND tcode = 'VA02'.
    ENDIF.

    SORT it_cdhdr BY udate DESCENDING.

*********************************************
*******************        edited by PJ on 16-08-21
    SELECT matnr item_type bom zpen_item zre_pen_item FROM mara
      INTO TABLE it1_mara
      FOR ALL ENTRIES IN it_vbap WHERE matnr = it_vbap-matnr.

*****************        end
    SELECT vbeln
           posnr
           parvw
           kunnr
           adrnr
           land1
           FROM vbpa INTO TABLE lt_vbpa
           FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln.
*                                     AND  posnr = it_vbap-posnr.

    IF lt_vbpa IS NOT INITIAL.                                                  " added by sonu
      SELECT kunnr
             kurst
        FROM knvv INTO TABLE it_knvv
        FOR ALL ENTRIES IN lt_vbpa WHERE kunnr = lt_vbpa-kunnr.
    ENDIF.

    SELECT vbeln
           posnr
           etenr
           ettyp
           edatu
           FROM vbep INTO TABLE it_vbep
           FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln
                                       AND  posnr = it_vbap-posnr.

    SORT it_vbep BY vbeln posnr etenr.

    SELECT vbeln
           posnr
           etenr
           ettyp
           edatu
           FROM vbep INTO TABLE lt_vbep
           FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln
                                       AND  posnr = it_vbap-posnr
                                       AND  etenr = '0001'
                                       AND  ettyp = 'CP'.

    SORT lt_vbep BY vbeln posnr etenr.

    SELECT vbeln
           posnr     "ADDEDBY JYOTI ON 24.12.2024
           inco1
           inco2
           zterm
           ktgrd       "added by 04.02.2022
           kursk
           bstkd
           prsdt
           FROM vbkd INTO TABLE it_vbkd
           FOR ALL ENTRIES IN it_vbap
           WHERE vbeln = it_vbap-vbeln.

    IF it_vbkd IS NOT INITIAL.
      SELECT spras
             zterm
             text1
             FROM t052u INTO TABLE it_t052u
             FOR ALL ENTRIES IN it_vbkd
             WHERE spras = 'EN'
             AND zterm = it_vbkd-zterm.
    ENDIF.


*BREAK primus.
    SELECT matnr
           werks
           lgort
           vbeln
           posnr
           kalab
           kains
           FROM mska INTO TABLE it_mska
           FOR ALL ENTRIES IN it_vbap
           WHERE vbeln = it_vbap-vbeln
             AND posnr = it_vbap-posnr
             AND matnr = it_vbap-matnr
             AND werks = it_vbap-werks.

    IF it_vbak IS NOT INITIAL.

      SELECT knumv
             kposn
             kschl
             kbetr
             waers
             kwert
             FROM prcd_elements INTO TABLE it_konv
             FOR ALL ENTRIES IN it_vbak
             WHERE knumv = it_vbak-knumv
                AND kschl IN s_kschl
                AND kinak = space.

      SELECT knumv
             kposn
             kschl
             kbetr
             waers
             kwert
             FROM prcd_elements INTO TABLE it_konv1
             FOR ALL ENTRIES IN it_vbak
             WHERE knumv = it_vbak-knumv
               AND kinak = space.


      SELECT vbelv
             posnv
             vbeln
             vbtyp_n
             FROM vbfa INTO TABLE it_vbfa
             FOR ALL ENTRIES IN it_vbak
             WHERE vbelv = it_vbak-vbeln
               AND ( vbtyp_n = 'J' OR  vbtyp_n = 'M' ).
    ENDIF.

    IF it_vbfa IS NOT INITIAL.
      SELECT vbeln
*             VKORG    "ADDED BY AAKASHK 19.08.2024
*             VTWEG     "ADDED BY AAKASHK 19.08.2024
*             SPART      "ADDED BY AAKASHK 19.08.2024
             fkart
             fktyp
             vkorg
             vtweg
             fkdat
             fksto
             FROM vbrk INTO TABLE it_vbrk
             FOR ALL ENTRIES IN it_vbfa
             WHERE vbeln = it_vbfa-vbeln
               AND fksto NE 'X'.
    ENDIF.
    IF it_vbrk IS NOT INITIAL.
      SELECT vbeln
             posnr
             fkimg
             aubel
             aupos
             matnr
             werks
             FROM vbrp INTO TABLE it_vbrp
             FOR ALL ENTRIES IN it_vbrk
             WHERE vbeln = it_vbrk-vbeln.
    ENDIF.
    IF it_vbap IS NOT INITIAL.
      SELECT * FROM jest INTO TABLE it_jest FOR ALL ENTRIES IN it_vbap WHERE objnr = it_vbap-objnr
                                                                         AND stat IN s_stat
                                                                         AND inact NE 'X'.
    ENDIF.
    IF it_jest IS NOT INITIAL.
      SELECT * FROM tj30 INTO TABLE it_tj30t FOR ALL ENTRIES IN it_jest WHERE estat = it_jest-stat
                                                                         AND stsma  = 'OR_ITEM'.
    ENDIF.


    SELECT aufnr
           posnr
           kdauf
           kdpos
           matnr
           pgmng
           psmng
           wemng
      FROM afpo
      INTO TABLE it_afpo
      FOR ALL ENTRIES IN it_vbap
      WHERE kdauf = it_vbap-vbeln
        AND kdpos = it_vbap-posnr .
    IF sy-subrc = 0.

      SELECT aufnr
             objnr
             kdauf
             kdpos
             igmng
        FROM caufv
        INTO TABLE it_caufv
        FOR ALL ENTRIES IN it_afpo
        WHERE aufnr = it_afpo-aufnr
        AND   kdauf = it_afpo-kdauf
        AND   kdpos = it_afpo-kdpos
        AND   loekz = space.

    ENDIF.
    """""""""""""""   END 05.05.2017         """"""""""""""""""""""""""

    SELECT vbeln
           posnr
           zibr
           zul
           zsl
           zce
           zapi6d
           zapi60
           zatex
           ztrcu
           zcrn
           zmarine
      FROM vbap
      INTO TABLE it_vbap1
      FOR ALL ENTRIES IN it_vbap
      WHERE vbeln = it_vbap-vbeln AND
            posnr = it_vbap-posnr.

  ENDIF.

  IF lt_vbpa IS NOT INITIAL.

    SELECT * FROM adrc INTO TABLE lt_adrc FOR ALL ENTRIES IN lt_vbpa WHERE addrnumber = lt_vbpa-adrnr." AND country = 'IN'.
    IF lt_adrc IS NOT INITIAL.
      FIELD-SYMBOLS : <f1> TYPE zgst_region.

      SELECT * FROM zgst_region INTO TABLE lt_zgst_region ."FOR ALL ENTRIES IN lt_adrc WHERE region = lt_adrc-region.
      LOOP AT lt_zgst_region ASSIGNING <f1>.
        DATA(lv_str_l) =  strlen( <f1>-region ).
        IF lv_str_l = 1.
          CONCATENATE '0' <f1>-region INTO <f1>-region.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDIF.

  SELECT kunnr
         name1
         adrnr
         FROM kna1 INTO TABLE it_kna1
         FOR ALL ENTRIES IN it_vbak
         WHERE kunnr = it_vbak-kunnr.

  """"""""" code added by pankaj 04.02.2022""""""""""""""

  IF it_vbkd IS NOT INITIAL.

    SELECT ktgrd
           vtext FROM tvktt INTO TABLE it_tvktt FOR ALL ENTRIES IN it_vbkd WHERE ktgrd = it_vbkd-ktgrd
                                                                           AND spras = 'EN'.

  ENDIF.

*BREAK primus.
  IF  it_vbak IS NOT INITIAL.

    SELECT objnr
           stat
           inact FROM jest INTO TABLE it_jest3 FOR ALL ENTRIES IN it_vbak WHERE objnr = it_vbak-objnr AND inact = ' '.
  ENDIF.

  IF it_jest3 IS NOT INITIAL.

    SELECT stsma
           estat
           txt04 FROM tj30t INTO TABLE it_tj30 FOR ALL ENTRIES IN it_jest3 WHERE estat = it_jest3-stat AND stsma = 'OR_HEADR'.

  ENDIF.


  """""""""""""""""""""""""""""""" ended""""""""""""""""""""""""""""


ENDFORM.                    " FILL_TABLES
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM process_for_output .
  DATA:
    lv_ratio TYPE resb-enmng,
    lv_qty   TYPE resb-enmng,
    lv_index TYPE sy-tabix.

  IF it_vbap[] IS NOT INITIAL.
    CLEAR: wa_vbap, wa_vbak, wa_vbep, wa_mska,
           wa_vbrp, wa_konv, wa_kna1,wa_vbap1.
    SORT it_vbap BY vbeln posnr matnr werks.
    SORT it_mska BY vbeln posnr matnr werks.
    SORT it_afpo BY kdauf kdpos matnr.
    SORT lt_resb BY aufnr kdauf kdpos.

    LOOP AT it_vbap INTO wa_vbap.

      wa_output-lgort = wa_vbap-lgort.  "added by jyoti on 11.06.2024
*      wa_output-zmrp_date = wa_vbap-zmrp_date."added by jyoti on 02.07.2024
*      wa_output-zexp_mrp_date1 = wa_vbap-zexp_mrp_date1."added by jyoti on 13.11.2024

      PERFORM change_Date_format USING wa_vbap-zmrp_date CHANGING wa_output-zmrp_date.
      PERFORM change_Date_format USING wa_vbap-zexp_mrp_date1 CHANGING wa_output-zexp_mrp_date1.

      IF wa_vbap-zhold_reason_n1 IS NOT INITIAL.
        SELECT SINGLE zhold_reason_n1 FROM zhold_reason
          INTO wa_output-zhold_reason_n1 WHERE zhold_key = wa_vbap-zhold_reason_n1.
      ENDIF.
*      wa_output-zhold_reason_n1  = wa_vbap-zhold_reason_n1. "added by jyoti on 06.02.2025.
**********ADDED BY DH ****************

      READ TABLE it_vbap2 INTO wa_vbap2 WITH KEY vbeln = wa_vbap-vbeln.
      IF sy-subrc = 0.                                                        "added by aakashk 03.10.2024
        READ TABLE it_cdhdr INTO wa_cdhdr WITH KEY objectclas = 'VERKBELEG' objectid = wa_vbap2-vbeln tcode = 'VA02'.
        IF sy-subrc = 0.
          wa_output-udate = wa_cdhdr-udate.                                                       "added by aakashk 03.10.2024
        ENDIF.
      ENDIF.

      PERFORM change_Date_format USING wa_cdhdr-udate CHANGING wa_output-udate.

***************************************
*********************      modified by PJ on 16-08-21
      READ TABLE it1_mara INTO wa1_mara WITH KEY matnr = wa_vbap-matnr.
      IF sy-subrc = 0.

        wa_output-item_type    = wa1_mara-item_type.
        wa_output-bom    = wa1_mara-bom.
        wa_output-zpen_item    = wa1_mara-zpen_item.
        wa_output-zre_pen_item    = wa1_mara-zre_pen_item.

      ENDIF.
****************************      end

*      wa_output-holddate    = wa_vbap-holddate.        "Statsu
*      wa_output-reldate     = wa_vbap-holdreldate.     "Release date
*      wa_output-canceldate  = wa_vbap-canceldate.      "Cancel date
*      wa_output-deldate     = wa_vbap-deldate.         "delivary date
*      wa_output-custdeldate = wa_vbap-custdeldate.         "customer del. date
      PERFORM change_Date_format USING wa_vbap-holddate     CHANGING wa_output-holddate.
*      PERFORM change_Date_format USING wa_vbap-holdreldate  CHANGING wa_output-holdreldate.
      PERFORM change_Date_format USING wa_vbap-canceldate   CHANGING wa_output-canceldate.
      PERFORM change_Date_format USING wa_vbap-deldate      CHANGING wa_output-deldate.
      PERFORM change_Date_format USING wa_vbap-custdeldate  CHANGING wa_output-custdeldate.


      " added by sagar darade on 16/03/2026 to get the target qty
      READ TABLE it_vbak INTO DATA(ls_vbak) WITH KEY vbeln = wa_vbap-vbeln.
      IF sy-subrc = 0.
        IF ls_vbak-auart = 'ZESS' OR ls_vbak-auart = 'ZSER' .
          wa_output-kwmeng      = wa_vbap-zmeng.          "target order qty
        ELSE.
          wa_output-kwmeng      = wa_vbap-kwmeng.          "sales order qty
        ENDIF.
      ENDIF.

      " end of code added by sagar darade on 16/03/2026

      wa_output-posex       = wa_vbap-posex.
      wa_output-posex1       = wa_vbap-posex.
      wa_output-matnr       = wa_vbap-matnr.           "Material
      wa_output-posnr       = wa_vbap-posnr.           "item
      wa_output-arktx       = wa_vbap-arktx.           "item short description
*      wa_output-kwmeng      = wa_vbap-kwmeng.          "sales order qty " Commentedby sagar darade on 16/03/2026
      wa_output-werks       = wa_vbap-werks.           "PLANT
      wa_output-waerk       = wa_vbap-waerk.           "Currency
      wa_output-kdmat       = wa_vbap-kdmat.
      wa_output-vbeln       = wa_vbap-vbeln.           "Sales Order

      wa_output-zins_loc    = wa_vbap-zins_loc.        "Installation Location     ADDED BY MA ON 27.03.24
      IF  wa_vbap-custdeldate IS NOT INITIAL  .
*        wa_output-po_del_date = wa_vbap-custdeldate.
        PERFORM change_Date_format USING wa_vbap-custdeldate  CHANGING wa_output-po_del_date.
      ENDIF.
      IF wa_vbap-zgad = '1'.
        wa_output-gad = 'Reference'.
      ELSEIF wa_vbap-zgad = '2'.
        wa_output-gad = 'Approved'.
      ELSEIF wa_vbap-zgad = '3'.
        wa_output-gad = 'Standard'.
      ENDIF.

      wa_output-ctbg       = wa_vbap-ctbg.               " added by ajay

      """"""""" code added by pankaj 28.01.2022""""""""""""""""""
*      wa_output-receipt_date       = wa_vbap-receipt_date.               " added by pankaj 30.12.2021
      PERFORM change_Date_format USING wa_vbap-receipt_date CHANGING wa_output-receipt_date.
      IF wa_vbap-reason = '1' OR wa_vbap-reason = '01'.
        wa_output-reason = 'Hold'.
      ELSEIF
        wa_vbap-reason = '2' OR wa_vbap-reason = '02'.
        wa_output-reason = 'Cancel'.
      ELSEIF
        wa_vbap-reason = '3' OR wa_vbap-reason = '03'.
        wa_output-reason = 'QTY Change'.
      ELSEIF
        wa_vbap-reason = '4'OR wa_vbap-reason = '04'.
        wa_output-reason = 'Quality Change'.
      ELSEIF
        wa_vbap-reason = '5' OR wa_vbap-reason = '05'.
        wa_output-reason = 'Technical Changes'.
      ELSEIF
        wa_vbap-reason = '6' OR wa_vbap-reason = '06'.
        wa_output-reason = 'New Line'.
      ELSEIF
        wa_vbap-reason = '07'.
        wa_output-reason = 'Line added against BCR'.
      ELSEIF
        wa_vbap-reason = '08'.
        wa_output-reason = 'Line added against wrong code given by sales'.
      ELSEIF
        wa_vbap-reason = '09'.
        wa_output-reason = 'Line added for split scheduling'.
      ELSEIF
        wa_vbap-reason = '10'.
        wa_output-reason = 'Clubbed line'.
      ELSEIF
        wa_vbap-reason = '11'.
        wa_output-reason = 'Validation line doesn''t show on OA'.
      ENDIF.
*      ENDIF.

      wa_output-ntgew           = wa_vbap-ntgew.
*      wa_output-ofm_date1       = wa_vbap-ofm_date.
      PERFORM change_Date_format USING wa_vbap-ofm_date CHANGING wa_output-ofm_date1.
*      break primus.              "added by pankaj 01.02.2022
*      IF  wa_output-ofm_date1 NE '00000000'.
*        wa_output-ofm_date1 = wa_output-ofm_date1.
*      ELSE.
*        wa_output-ofm_date1 = space.
*      ENDIF.
*      wa_output-chang_so_date = wa_vbap-erdat.
      PERFORM change_Date_format USING wa_vbap-erdat CHANGING wa_output-chang_so_date.
      """""""" code ended""""""""""""""""""""""""""""""'

      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_output-vbeln.
      IF sy-subrc = 0.
        wa_output-auart        = wa_vbak-auart.           "ORDER TYPE
        wa_output-vkorg        = wa_vbak-vkorg.           "ADDED BY AAKASHK 19.08.2024
        wa_output-vtweg        = wa_vbak-vtweg.            "ADDED BY AAKASHK 19.08.2024
        wa_output-spart        = wa_vbak-spart.            "ADDED BY AAKASHK 19.08.2024
        wa_output-vkbur        = wa_vbak-vkbur.           "Sales Office
*        wa_output-erdat        = wa_vbak-erdat.           "Sales Order date
*        wa_output-vdatu        = wa_vbak-vdatu.           "Req del date
*        wa_output-bstdk        = wa_vbak-bstdk.
        wa_output-lifsk        = wa_vbak-lifsk.
        wa_output-zldperweek   = wa_vbak-zldperweek.  "LD per week
        wa_output-zldmax       = wa_vbak-zldmax.      "LD Max
*        wa_output-zldfromdate  = wa_vbak-zldfromdate. "LD from date
        PERFORM change_Date_format USING wa_vbak-erdat CHANGING wa_output-erdat.
        PERFORM change_Date_format USING wa_vbak-vdatu CHANGING wa_output-vdatu.
        PERFORM change_Date_format USING wa_vbak-bstdk CHANGING wa_output-bstdk.
        PERFORM change_Date_format USING wa_vbak-zldfromdate  CHANGING wa_output-zldfromdate.
        wa_output-kunnr        = wa_vbak-kunnr.
*        wa_output-faksk        = wa_vbak-faksk.

      ENDIF.

*      read table it_tvfst into wa_tvfst with key faksp = wa_vbak-faksk spras = 'EN'.
*      if sy-subrc = 0.
*        wa_output-vtext1 = wa_tvfst-vtext.
*      endif.

      """"""""" code added by pankaj 28.01.2021"""""""""""""""""""""""""

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'ZPR0'  kposn = wa_vbap-posnr.

      IF sy-subrc = 0.
        wa_output-zpr02 = wa_konv1-kbetr.
        wa_output-zpr0 = wa_output-zpr02.
      ENDIF.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'ZPF0' kposn = wa_vbap-posnr.

      IF sy-subrc = 0.
        wa_output-zpf0 = wa_konv1-kwert.
      ENDIF.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kschl = 'ZIN1' kposn = wa_vbap-posnr.

      IF sy-subrc = 0.
        wa_output-zin1 = wa_konv1-kwert.
      ENDIF.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kschl = 'ZIN2' kposn = wa_vbap-posnr.

      IF sy-subrc = 0.
        wa_output-zin2 = wa_konv1-kwert.
      ENDIF.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'JOIG' kposn = wa_vbap-posnr.

      IF sy-subrc = 0.
        wa_output-joig2 = wa_konv1-kwert.
        wa_output-joig = wa_output-joig2.
      ENDIF.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'JOCG' kposn = wa_vbap-posnr.

      IF sy-subrc = 0.
        wa_output-jocg = wa_konv1-kwert.
      ENDIF.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'JOSG' kposn = wa_vbap-posnr.

      IF sy-subrc = 0.
        wa_output-josg = wa_konv1-kwert.
      ENDIF.


      READ TABLE it_konv1 INTO DATA(wa_konv12) WITH KEY knumv = wa_vbak-knumv  kschl = 'ZDIS' kposn = wa_vbap-posnr. "ADDED BY MAHADEV HEMENT ON 10/12/2025

*      IF sy-subrc = 0.
*        WA_OUTPUT-JOSG = WA_KONV12-KWERT.
      wa_output-dis_rate2 = abs( wa_konv12-kbetr ).
      wa_output-dis_rate = wa_output-dis_rate2.
      gv_kbetr2 = wa_output-zpr0 * wa_konv12-kbetr / 100  . "ADDED BY MAHADEV SACHIN ON 08/12/2025
      gv_kbetr = gv_kbetr2 - ( - wa_output-zpr0 ). "ADDED BY MAHADEV SACHIN ON 08/12/2025

      gv_kwert = wa_konv12-kwert.
*        WA_OUTPUT-DIS_AMT  = WA_KONV12-KWERT.
      wa_output-dis_amt2  = abs( gv_kbetr2 ).
      wa_output-dis_amt = wa_output-dis_amt2.
*      ENDIF.
*      WA_OUTPUT-DIS_UNIT_RATE  = WA_OUTPUT-ZPR0 - ( - WA_KONV12-KWERT ).
      wa_output-dis_unit_rate2  = gv_kbetr.
      wa_output-dis_unit_rate = wa_output-dis_unit_rate2.

      """"""""""""" code ended""""""""""""""""""""""""""""""""""""

      READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_output-vbeln
                                               posnr = wa_output-posnr
                                               etenr = '0001'.
      IF sy-subrc = 0.
        wa_output-ettyp       = wa_vbep-ettyp.           "So Status
        PERFORM change_Date_format USING wa_vbep-edatu  CHANGING wa_output-edatu.
*        wa_output-edatu       = wa_vbep-edatu.           "delivary Date
        wa_output-etenr       = wa_vbep-etenr.           "Schedule line no.
        "wa_output-date        = wa_vbep-date.
      ENDIF.
      READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_output-vbeln
                                               posnr = wa_output-posnr
                                               etenr = '0001'.
      IF sy-subrc = 0.
*       PERFORM change_Date_format USING wa_vbep-edatu  CHANGING wa_output-date.
*        wa_output-date       = wa_vbep-edatu.
        PERFORM change_Date_format USING wa_vbep-edatu  CHANGING wa_output-date.

      ENDIF.
      READ TABLE lt_vbep INTO ls_vbep WITH KEY vbeln = wa_output-vbeln
                                               posnr = wa_output-posnr
                                               etenr = '0001'
                                               ettyp = 'CP'.

      READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_output-vbeln.

*                                               posnr = wa_vbap-posnr.
      IF sy-subrc = 0.
        wa_output-so_exc      = wa_vbkd-kursk.           "SO Exchange Rate
        wa_output-bstkd       = wa_vbkd-bstkd.           "Cust Ref No.
        wa_output-zterm       = wa_vbkd-zterm.           "payment terms
        wa_output-inco1       = wa_vbkd-inco1.           "inco terms
        wa_output-inco2       = wa_vbkd-inco2.           "inco terms description
*        wa_output-prsdt       = wa_vbkd-prsdt.
        PERFORM change_Date_format USING wa_vbkd-prsdt CHANGING wa_output-prsdt.
      ENDIF.

      CLEAR wa_kna1.
      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_output-kunnr.
      IF sy-subrc = 0.
        wa_output-name1       = wa_kna1-name1.           "Cust Name
      ENDIF.


      READ TABLE it_t052u INTO wa_t052u WITH KEY zterm = wa_output-zterm.
      IF sy-subrc = 0.
        wa_output-text1       = wa_t052u-text1.          "payment terms description
      ENDIF.
*      BREAK primus.
      READ TABLE it_vbap1 INTO wa_vbap1 WITH KEY vbeln = wa_output-vbeln
                                                 posnr = wa_output-posnr.
      IF sy-subrc = 0.

        IF wa_vbap1-zibr = 'X'.
          certif_zibr = 'IBR'.
*          CONCATENATE quote certif_zibr quote INTO certif_zibr.
          CONCATENATE wa_output-certif certif_zibr INTO wa_output-certif SEPARATED BY space.
        ENDIF.

        IF wa_vbap1-zul = 'X'.
          certif_zul = 'UL'.
*          CONCATENATE quote certif_zul quote INTO certif_zul.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zul INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zul INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-zsl = 'X'.
          certif_zsl = 'SIL3'.
*           CONCATENATE quote certif_zsl quote INTO certif_zsl.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zsl INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zsl INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-zce = 'X'.
          certif_zce = 'CE'.
*          CONCATENATE quote certif_zce quote INTO certif_zce.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zce INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zce INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-zapi6d = 'X'.
          certif_zapi6d = 'API 6D'.
*          CONCATENATE quote certif_zapi6d quote INTO certif_zapi6d.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zapi6d INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zapi6d INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-zapi60 = 'X'.
          certif_zapi60 = 'API 609'.
*          CONCATENATE quote certif_zapi60 quote INTO certif_zapi60.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zapi60 INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zapi60 INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-zatex = 'X'.
          certif_zatex = 'ATEX'.
*          CONCATENATE quote certif_zatex quote INTO certif_zatex.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zatex INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zatex INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-ztrcu = 'X'.
          certif_ztrcu = 'TRCU'.
*          CONCATENATE quote certif_ztrcu quote INTO certif_ztrcu.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_ztrcu INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_ztrcu INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-zcrn = 'X'.
          certif_zcrn = 'CRN'.
*          CONCATENATE quote certif_zcrn quote INTO certif_zcrn.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zcrn INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zcrn INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF wa_vbap1-zmarine = 'X'.
          certif_zmarine = 'MARINE'.
*          CONCATENATE quote certif_zmarine quote INTO certif_zmarine.
          IF wa_output-certif IS INITIAL.
            CONCATENATE wa_output-certif certif_zmarine INTO wa_output-certif SEPARATED BY space.
          ELSE.
            CONCATENATE wa_output-certif certif_zmarine INTO wa_output-certif SEPARATED BY ','.
          ENDIF.
        ENDIF.

        CLEAR : certif_zibr, certif_zul, certif_zsl, certif_zce, certif_zapi6d, certif_zapi60, certif_zatex , certif_ztrcu, certif_zcrn, certif_zmarine.

      ENDIF.

      READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_output-vbeln
                                               posnr = wa_output-posnr.
**TPI TEXT

      CLEAR: lv_lines, wa_lines.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z999'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO wa_lines INDEX 1.

*LD Req Text
      CLEAR: lv_lines, wa_ln_ld.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z038'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO wa_ln_ld INDEX 1.

**********
*Tag Required
      CLEAR: lv_lines, wa_tag_rq.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z039'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO wa_tag_rq INDEX 1.
**********
*Material text
      CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_output-matnr.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'GRUN'
            language                = sy-langu
            name                    = lv_name
            object                  = 'MATERIAL'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO ls_mattxt INDEX 1.

**********
*******************************ADDED BY JYOTI ON 04.12.2024
*************** CUSTOMER PROJECT NAME*********************
      CLEAR: lv_lines,  wa_cust_proj_name.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z063'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO  wa_cust_proj_name.
          IF  wa_cust_proj_name-tdline IS NOT INITIAL.
            CONCATENATE wa_output-zcust_proj_name  wa_cust_proj_name-tdline INTO wa_output-zcust_proj_name SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
*  *  *********************************ADDED BY JYOTI ON 20.01.2024**********************************
      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z064'
          language                = 'E'
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
      ENDIF.

      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-amendment_his ls_lines-tdline INTO wa_output-amendment_his SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.


      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z065'
          language                = 'E'
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
      ENDIF.

      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-po_dis ls_lines-tdline INTO wa_output-po_dis SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

**********************************************************

*********OFM SR. NO.
*      CLEAR: lv_lines, wa_ofm_no.
*      REFRESH lv_lines.
*      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
*
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z102'
*          language                = sy-langu
*          name                    = lv_name
*          object                  = 'VBBP'
*        TABLES
*          lines                   = lv_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*
*      READ TABLE lv_lines INTO wa_ofm_no INDEX 1.
*
*      IF lv_lines IS NOT INITIAL.
*        LOOP AT lv_lines INTO wa_ofm_no.
*          IF wa_ofm_no-tdline IS NOT INITIAL.
*            CLEAR wa_text.
*            wa_text = wa_ofm_no-tdline(20).     "ofm sr no
*            TRANSLATE wa_text TO UPPER CASE .
*            wa_output-ofm_no         = wa_text.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.

********************ADDED BY SHREYA*******************
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z102'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBP'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_ctbgi.
          IF ls_ctbgi-tdline IS NOT INITIAL.
            CONCATENATE wa_output-ofm_no ls_ctbgi-tdline INTO wa_output-ofm_no SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """"""""""""""""""""""
      """"""""""""""""""""""""SPECIAL COMMENTS
*      BREAK primusabap.
      CLEAR: lv_lines, wa_ln_ld.
      REFRESH lv_lines.
      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z888'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBP'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_ctbgi.
          IF ls_ctbgi-tdline IS NOT INITIAL.
            CONCATENATE wa_output-special_comm ls_ctbgi-tdline INTO wa_output-special_comm SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
      """"""""""""""""""""""""""""""""""""""""

      """"""""""""""""""""""

*************************changes by madhavi in (JOCG joig JTC1)
*konv data
      CLEAR: wa_konv1." WA_OUTPUT.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_output-posnr kschl = 'JOCG'.
      IF sy-subrc = 0.
        CLEAR : lv_cgst,lv_cgst_temp.
        lv_cgst =  wa_konv1-kbetr .
*        lv_cgst =  wa_konv1-kbetr / 10.
        lv_cgst_temp = lv_cgst.
        CONDENSE lv_cgst_temp.
        wa_output-cgst = lv_cgst_temp.

*        wa_output-cgst_val = wa_konv1-kwert.

        wa_output-sgst = lv_cgst_temp.
*        wa_output-sgst_val = wa_konv1-kwert.
      ENDIF.
      CLEAR: wa_konv1.
      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_output-posnr kschl = 'JOIG'.
      IF sy-subrc = 0.
        CLEAR : lv_cgst,lv_cgst_temp.
        lv_cgst =  wa_konv1-kbetr.  ""  ++ NC
*        lv_cgst =  wa_konv1-kbetr / 10.   """"" cmt by nc
        lv_cgst_temp = lv_cgst.
        wa_output-igst = lv_cgst_temp.
*        wa_output-igst_val = wa_konv1-kwert.
      ENDIF.

      CLEAR: wa_konv1.
      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_vbap-posnr kschl = 'JTC1'.
      IF sy-subrc = 0.
*        wa_output-tcs = wa_konv1-kbetr / 10.
        wa_output-tcs = wa_konv1-kbetr.
        wa_output-tcs_amt = wa_konv1-kwert.
      ENDIF.

      CLEAR: wa_konv.

      SELECT SINGLE knumv
                    kposn
                    kschl
                    kbetr
                    waers
                    kwert
                    FROM prcd_elements INTO wa_konv WHERE  knumv = wa_vbak-knumv
                                             AND   kposn = wa_output-posnr
                                             AND   kschl = 'ZPR0'
                                             AND kinak = space.
      wa_output-kbetr       = wa_konv-kbetr.           "Rate

*Commented by Dhanashree because this field shows in downloaded excel
**      wa_output-KWERT       = WA_KONV-kwert.  "ADDED BY SHREYA 12-04-2022

      CLEAR: wa_konv .
      SELECT SINGLE knumv
                    kposn
                    kschl
                    kbetr
                    waers
                    kwert
                    FROM prcd_elements INTO wa_konv WHERE knumv = wa_vbak-knumv
                                             AND   kposn = wa_output-posnr
                                             AND   kschl = 'VPRS'
                                             AND kinak = space.
      IF wa_vbap-waerk <> 'INR'.
        IF wa_konv-waers <> 'INR'.
          wa_konv-kbetr = wa_konv-kbetr * wa_vbkd-kursk.
        ENDIF.
      ENDIF.

      wa_output-in_price2    = wa_konv-kbetr.           "Internal Price
      wa_output-in_price = wa_output-in_price2.

      CLEAR: wa_konv .

      SELECT SINGLE knumv
                    kposn
                    kschl
                    kbetr
                    waers
                    kwert
                    FROM prcd_elements INTO wa_konv WHERE knumv = wa_vbak-knumv
                                             AND   kposn = wa_output-posnr
                                             AND  kschl = 'ZESC'
                                             AND kinak = space.
      IF wa_vbap-waerk <> 'INR'.
        IF wa_konv-waers <> 'INR'.
          wa_konv-kbetr = wa_konv-kbetr * wa_vbkd-kursk.
        ENDIF.
      ENDIF.

      wa_output-est_cost    = wa_konv-kbetr.           "Estimated cost


      CLEAR wa_jest1.
      READ TABLE it_jest INTO wa_jest1 WITH KEY objnr = wa_vbap-objnr.

      SELECT SINGLE * FROM tj30t INTO wa_tj30t  WHERE estat = wa_jest1-stat
                                                AND stsma  = 'OR_ITEM'
                                                AND spras  = 'EN'.
      IF sy-subrc = 0.
        wa_output-status      = wa_tj30t-txt30.          "Hold/Unhold
      ENDIF.

      CLEAR : wa_mska.


      LOOP AT it_mska INTO wa_mska WHERE vbeln = wa_output-vbeln AND
                                         posnr = wa_output-posnr AND
                                         matnr = wa_output-matnr AND
                                         werks = wa_output-werks.

        CASE wa_mska-lgort.
          WHEN 'FG01'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
*          WHEN 'TPI1'.
*            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.          "commented by sonu
          WHEN 'PRD1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'RM01'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'RWK1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SC01'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SFG1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'VLD1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KFG0'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KMCN'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KNDT'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KPLG'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KPR1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KPRD'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KRM0'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KRWK'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KSC0'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KSFG'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
*          WHEN 'KTPI'.                                                                                     " commented by sonu
*            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KVLD'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SUPT'.                                                      """ADDED BY PRANIT 16.01.2024
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KUPT'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.      """ENDED BY PRANIT 16.01.2024
          WHEN 'KTPI'.
            wa_output-stock_qty_ktpi = wa_output-stock_qty_ktpi + wa_mska-kalab.         " added by sonu
          WHEN 'TPI1'.
            wa_output-stock_qty_tpi1 = wa_output-stock_qty_tpi1 + wa_mska-kalab.         " added by sonu
        ENDCASE.

      ENDLOOP.

*DELIVARY QTY
      CLEAR: wa_vbfa, wa_lfimg, wa_lfimg_sum.
      LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_output-vbeln
                                   AND posnv = wa_output-posnr
                                   AND vbtyp_n = 'J'.

        CLEAR wa_lfimg.
        SELECT SINGLE lfimg FROM lips INTO  wa_lfimg  WHERE vbeln = wa_vbfa-vbeln
                                                      AND   pstyv = 'ZTAN'
                                                      AND   vgbel = wa_output-vbeln
                                                      AND   vgpos = wa_output-posnr.
        wa_lfimg_sum = wa_lfimg_sum + wa_lfimg .

      ENDLOOP.

*INVOICE QTY
      CLEAR: wa_vbfa, wa_fkimg, wa_fkimg_sum.
      LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_output-vbeln
                                     AND posnv = wa_output-posnr
                                     AND vbtyp_n = 'M'.

        CLEAR wa_vbrk.
        READ TABLE it_vbrk INTO wa_vbrk WITH KEY   vbeln = wa_vbfa-vbeln.

        CLEAR wa_fkimg.
        SELECT SINGLE fkimg FROM vbrp INTO  wa_fkimg  WHERE vbeln = wa_vbrk-vbeln
                                                      AND   aubel = wa_output-vbeln
                                                      AND   aupos = wa_output-posnr.
        wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
      ENDLOOP.

****
      CLEAR wa_mbew.
      SELECT SINGLE * FROM mbew INTO wa_mbew WHERE matnr = wa_output-matnr
                                               AND bwkey = wa_output-werks.

      CLEAR wa_mara.
      SELECT SINGLE * FROM mara INTO wa_mara WHERE matnr = wa_output-matnr.

      """"""""""     Added By KD on 04.05.2017    """""""""""
      SELECT SINGLE dispo FROM marc INTO wa_output-dispo WHERE matnr = wa_output-matnr.
      """""""""""""""""""""""""""""""""""""""""""""""""""
*currency conversion
      REFRESH ls_fr_curr.
      CLEAR ls_fr_curr.
      ls_fr_curr-sign   = 'I'.
      ls_fr_curr-option = 'EQ'.
      ls_fr_curr-low = wa_vbak-waerk.
      APPEND ls_fr_curr.
      CLEAR: ls_ex_rate,lv_ex_rate, ls_return.
      REFRESH: ls_ex_rate, ls_return.
      IF ls_to_curr-low <> ls_fr_curr-low.

        CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
          EXPORTING
            date             = sy-datum
            date_type        = 'V'
            rate_type        = 'B'
          TABLES
            from_curr_range  = ls_fr_curr
            to_currncy_range = ls_to_curr
            exch_rate_list   = ls_ex_rate
            return           = ls_return.

        CLEAR lv_ex_rate.
        READ TABLE ls_ex_rate INTO lv_ex_rate INDEX 1.
      ELSE.
        lv_ex_rate-exch_rate = 1.
      ENDIF.

*Latest Estimated cost
      REFRESH: it_konh.
      CLEAR:   it_konh.

* FOR ZESC
      SELECT * FROM konh INTO TABLE it_konh WHERE kotabnr = '508'
                                              AND kschl  = 'ZESC'
*                                              AND vakey = wa_output-matnr     ""commented by sonu
                                              AND knumh = wa_output-matnr
                                              AND datab <= sy-datum
                                              AND datbi >= sy-datum .


      SORT  it_konh DESCENDING BY knumh .
      CLEAR wa_konh.
      READ TABLE it_konh INTO wa_konh INDEX 1.

      CLEAR wa_konp.
      SELECT SINGLE * FROM konp INTO wa_konp WHERE knumh = wa_konh-knumh
                                              AND kschl  = 'ZESC'.
*
*   SELECT * from konh as a left outer JOIN konp as b on ( a~knumh = b~knumh ) WHERE a~kotabnr = '508'
*                                                                                  AND a~kschl  = 'ZESC'
*                                                                                  AND b~matnr = wa_output-matnr
*                                                                                  AND a~datab <= sy-datum
*                                                                                  AND a~datbi >= sy-datum

      CLEAR wa_cdpos.
      DATA tabkey TYPE cdpos-tabkey.
      CONCATENATE sy-mandt wa_vbep-vbeln wa_vbep-posnr wa_vbep-etenr INTO tabkey.
*--Original Code
********PJ on 01-10-21*********************************************

*     ******We dont want this code for PendinG so and all To reduce TimING OF EXECUTION OF THE PROGRAM
*            for MRP Date As disscussion with Parag and Joshi Sir.
      IF open_so NE'X' AND all_so NE 'X'. "Added By Nilay B. On 06.09.2023
*      IF .                     "commented by pankaj 05.10.2021
        SELECT * FROM cdpos INTO TABLE it_cdpos WHERE tabkey = tabkey

**                                               AND value_new = 'CP'
**                                               AND value_old = 'CN'
                                                 AND tabname = 'VBEP' AND fname = 'ETTYP'.
*--End Original
*--Start change by CRC
        DATA : r_objectclas TYPE RANGE OF cdpos-objectclas.

        SELECT *
      FROM cdpos INTO TABLE it_cdpos
      WHERE objectclas IN r_objectclas
      AND   tabkey  = tabkey
      AND   tabname = 'VBEP'
      AND   fname   = 'ETTYP'.
*-- End Change
        SORT it_cdpos BY changenr DESCENDING.
        READ TABLE it_cdpos INTO wa_cdpos INDEX 1.
        IF wa_cdpos-value_new = 'CP' .
          SELECT SINGLE * FROM cdhdr INTO wa_cdhdr WHERE changenr = wa_cdpos-changenr.

*          wa_output-mrp_dt      = wa_cdhdr-udate.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar
          PERFORM change_Date_format USING wa_cdhdr-udate CHANGING wa_output-mrp_dt.
        ENDIF.
        CLEAR: wa_cdhdr,wa_output.   " add by supriya

*      ENDIF.                      "commented by pankaj 05.10.2021
      ENDIF.                       "Added By Nilay B. On 06.09.2023
*     ******We dont want this code for Pendind so and all To reduce Timn for MRP Date As disscussion with Parag and Joshi Sir.
**********end****************************
      CLEAR wa_tvagt.
      SELECT SINGLE spras
                    abgru
                    bezei
                    FROM tvagt INTO  wa_tvagt
                    WHERE abgru = wa_vbap-abgru AND spras = 'E'.

*Sales text
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = '0001'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBP'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_itmtxt.
          IF ls_itmtxt-tdline IS NOT INITIAL.
            CONCATENATE wa_output-itmtxt ls_itmtxt-tdline INTO wa_output-itmtxt SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
*wa_output-itmtxt = ls_itmtxt-tdline.

*********CTBG Item Details     "added by SR on 03.05.2021

      CLEAR: lv_lines, ls_ctbgi,lv_name.
      REFRESH lv_lines.
      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z061'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBP'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_ctbgi.
          IF ls_ctbgi-tdline IS NOT INITIAL.
*            CONCATENATE wa_output-ctbgi ls_ctbgi-tdline INTO wa_output-ctbgi SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
*************
********Insurance
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z017'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_itmtxt.
          IF ls_itmtxt-tdline IS NOT INITIAL.
            CONCATENATE wa_output-insur ls_itmtxt-tdline INTO wa_output-insur SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      REFRESH lv_lines.
      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = '0001'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBP'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_ctbgi.
          IF ls_ctbgi-tdline IS NOT INITIAL.
            CONCATENATE wa_output-mat_text ls_ctbgi-tdline INTO wa_output-mat_text SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

********Insurance***********
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z047'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.
      ENDIF.
      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_itmtxt.
          IF ls_itmtxt-tdline IS NOT INITIAL.
            CONCATENATE wa_output-pardel ls_itmtxt-tdline INTO wa_output-pardel SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

*      BREAK primus.
      SELECT SINGLE vtext INTO wa_output-vtext FROM tvlst WHERE lifsp = wa_vbak-lifsk AND spras = 'EN'.
      CLEAR wa_text1.
*                                    wa_text = wa_tag_rq-tdline(20).
      wa_text1 = wa_tag_rq-tdline(50).     "CHANGED BY SR ON 03.05.2021
      TRANSLATE wa_text1 TO UPPER CASE .       "tag Required
*                                    wa_output-tag_req     = wa_text(1).
      wa_output-tag_req     = wa_text1.      "CHANGED BY SR ON 03.05.2021

      wa_output-lfimg       = wa_lfimg_sum.                "del qty
      wa_output-fkimg       = wa_fkimg_sum.                "inv qty
      wa_output-pnd_qty     = wa_output-kwmeng - wa_output-fkimg.  "Pending Qty

      IF wa_tvagt-abgru IS INITIAL.
*        wa_output-abgru           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        wa_output-abgru           =  wa_tvagt-abgru.   " avinash bhagat 20.12.2018
      ENDIF.
      IF wa_tvagt-bezei IS INITIAL.
*        wa_output-bezei           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        wa_output-bezei           =  wa_tvagt-bezei.   " avinash bhagat 20.12.2018
      ENDIF.
      CONCATENATE wa_output-vbeln wa_output-posnr wa_output-etenr
*        INTO WA_OUTPUT-SCHID(25).
          INTO wa_output-schid.                "added by aakashk 20.08.2024

      DATA lv_qmqty TYPE mska-kains.
      CLEAR lv_qmqty.

      READ TABLE it_mska INTO wa_mska WITH KEY vbeln = wa_vbap-vbeln
                                               posnr = wa_vbap-posnr
                                               matnr = wa_vbap-matnr
                                               werks = wa_vbap-werks.
      IF sy-subrc IS INITIAL.
        lv_index = sy-tabix.
        LOOP AT it_mska INTO wa_mska FROM lv_index.
          IF wa_mska-vbeln = wa_vbap-vbeln AND wa_mska-posnr = wa_vbap-posnr
           AND wa_mska-matnr = wa_vbap-matnr AND wa_mska-werks = wa_vbap-werks.
*            LV_QMQTY = WA_MSKA-KAINS - LV_QMQTY.
            lv_qmqty = wa_mska-kains + lv_qmqty.
          ELSE.
            CLEAR lv_index.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      wa_output-qmqty = lv_qmqty.
      wa_output-mattxt = ls_mattxt-tdline.

      CLEAR wa_text1.
*                                    wa_text = wa_lines-tdline(20).
      wa_text1 = wa_lines-tdline(50).            "added by sr 0n 03.05.2021
      TRANSLATE wa_text1 TO UPPER CASE .
      wa_output-tpi         = wa_text1.     "TPI Required

      CLEAR wa_text1.
*                                    wa_text = wa_ln_ld-tdline(20).     "wa_ln_ld ld_req
      wa_text1 = wa_ln_ld-tdline(50).     "added by sr 0n 03.05.2021
      TRANSLATE wa_text1 TO UPPER CASE .
      wa_output-ld_txt         = wa_text1.     "lD Required

*                                    CLEAR wa_text.
*                                    wa_text = wa_ofm_no-tdline(20).     "ofm sr no
*                                    TRANSLATE wa_text TO UPPER CASE .
*                                    wa_output-ofm_no         = wa_text(1).     "ofm sr no

      wa_output-curr_con     = lv_ex_rate-exch_rate.    "Currency conversion

*      CATCH SYSTEM-EXCEPTIONS conversion_errors = 1
*                                          arithmetic_errors = 5.
*      IF LV_EX_RATE-EXCH_RATE IS NOT INITIAL.
*        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-KBETR *
*                                LV_EX_RATE-EXCH_RATE.    "Amount
*        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-KBETR *
*                                LV_EX_RATE-EXCH_RATE.    "Ordr Amount
*      ELSEIF LV_EX_RATE-EXCH_RATE IS INITIAL.
*        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-KBETR .
*        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-KBETR .
*      ENDIF.
      IF lv_ex_rate-exch_rate IS NOT INITIAL.
        wa_output-amont       = wa_output-pnd_qty * wa_output-dis_unit_rate *  "added by mahadev hement on 11 /12/2025
                              lv_ex_rate-exch_rate.    "Amount
        wa_output-ordr_amt2    = wa_output-kwmeng * wa_output-dis_unit_rate *   "added by mahadev hement on 11 /12/2025
                               lv_ex_rate-exch_rate.    "Ordr Amount
        wa_output-ordr_amt = wa_output-ordr_amt2.
        CONDENSE wa_output-ordr_amt.
      ELSEIF lv_ex_rate-exch_rate IS INITIAL.
        wa_output-amont       = wa_output-pnd_qty * wa_output-dis_unit_rate .  "added by mahadev hement on 11 /12/2025
        wa_output-ordr_amt    = wa_output-kwmeng * wa_output-dis_unit_rate .    "added by mahadev hement on 11 /12/2025
        CONDENSE wa_output-ordr_amt.
      ENDIF.

*      ENDCATCH.
*      wa_output-in_pr_dt    = wa_mbew-laepr.           "Internal Price Date
      PERFORM change_Date_format USING wa_mbew-laepr CHANGING wa_output-in_pr_dt.
      wa_output-st_cost     = wa_mbew-stprs .          "Standard Cost
*      wa_output-latst_cost   =  wa_KONV-KBETR.                    "
      wa_output-latst_cost    = wa_konp-kbetr.        "LATEST EST COST
      wa_output-zseries     = wa_mara-zseries.         "series
      wa_output-zsize       = wa_mara-zsize.           "size
      wa_output-brand       = wa_mara-brand.           "Brand
      wa_output-moc         = wa_mara-moc.             "MOC
      wa_output-type        = wa_mara-type.            "TYPE
      wa_output-mtart        = wa_mara-mtart.          " Material TYPE        """" Addded by KD on 05.05.2017
      wa_output-wrkst        = wa_mara-wrkst.          "Basic Material(Usa Item Code)
*      wa_output-normt      = wa_mara-normt.


      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z015'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
* Implement suitable error handling here
        ENDIF.
      ENDIF .
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-ofm ls_lines-tdline INTO wa_output-ofm SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
*           CLIENT                  = SY-MANDT
            id                      = 'Z016'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
* Implement suitable error handling here
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-ofm_date ls_lines-tdline INTO wa_output-ofm_date SEPARATED BY space.
          ENDIF.
        ENDLOOP.

      ENDIF.
*
      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z020'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
* Implement suitable error handling here
        ENDIF.
      ENDIF .
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-spl ls_lines-tdline INTO wa_output-spl SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

*************USA CUSTOMER CODE
      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_output-bstkd.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'F22'
            language                = 'E'
            name                    = lv_name
            object                  = 'EKKO'
          TABLES
            lines                   = lv_lines
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
* Implement suitable error handling here
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-us_cust ls_lines-tdline INTO wa_output-us_cust SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """"""""""""" code added by pankaj 28.01.2022"""""""""""""""""

      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z102'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
* Implement suitable error handling here
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-proj ls_lines-tdline INTO wa_output-proj SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.


      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z103'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
* Implement suitable error handling here
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-cond ls_lines-tdline INTO wa_output-cond SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """""""""""""""" code ended"""""""""""""""""""""""""""""
      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z012'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF .
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-packing_type ls_lines-tdline INTO wa_output-packing_type SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """""""""""" code added by pankaj 31.01.2022""""""""""""""""

*           infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary TYPE char25

      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z104'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-infra ls_lines-tdline INTO wa_output-infra SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z105'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-validation ls_lines-tdline INTO wa_output-validation SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.


      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z106'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-review_date ls_lines-tdline INTO wa_output-review_date SEPARATED BY space.
          ENDIF.
        ENDLOOP.
*        Check review date
      ENDIF.


      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z107'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-diss_summary ls_lines-tdline INTO wa_output-diss_summary SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""

      REFRESH : it_jest2 , it_jest2[] .
      CLEAR : wa_afpo , wa_caufv.

      LOOP AT it_afpo INTO wa_afpo WHERE kdauf = wa_vbap-vbeln
                                     AND kdpos = wa_vbap-posnr
                                     AND matnr = wa_vbap-matnr.

        READ TABLE it_caufv INTO wa_caufv WITH KEY aufnr = wa_afpo-aufnr
                                                   kdauf = wa_afpo-kdauf
                                                   kdpos = wa_afpo-kdpos.
        IF sy-subrc = 0.
          SELECT objnr stat FROM jest INTO TABLE it_jest2
                                WHERE objnr = wa_caufv-objnr
                                  AND inact = ' '.
********************************Commented by SK(22.09.17)
          CLEAR wa_jest2 .
          READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0012'." BINARY SEARCH .
          IF sy-subrc NE 0.
            CLEAR wa_jest2 .
            READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0009'." BINARY SEARCH .
            IF sy-subrc NE 0.
              CLEAR wa_jest2 .
              READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0002'." BINARY SEARCH .
              IF sy-subrc = 0.
                wa_output-wip = wa_output-wip + wa_afpo-psmng - wa_caufv-igmng ."wa_afpo-pgmng
              ENDIF.
            ENDIF.
          ENDIF.


        ENDIF.

      ENDLOOP.

*      wa_output-ref_dt = sy-datum.
      PERFORM change_Date_format USING sy-datum CHANGING wa_output-ref_dt.
      """ Ship to party logic

      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln posnr = wa_vbap-posnr parvw = 'WE'.
      IF sy-subrc = 0.
        wa_output-ship_kunnr = ls_vbpa-kunnr.
        wa_output-ship_land = ls_vbpa-land1.
        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
        IF sy-subrc = 0.
          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
          IF sy-subrc = 0.
            wa_output-ship_reg_n = ls_zgst_region-bezei.
          ENDIF.
        ENDIF.
      ELSE.
        READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln posnr = ' '  parvw = 'WE'.
        wa_output-ship_kunnr = ls_vbpa-kunnr.
        wa_output-ship_land = ls_vbpa-land1.
        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
        IF sy-subrc = 0.
          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
          IF sy-subrc = 0.
            wa_output-ship_reg_n = ls_zgst_region-bezei.
          ENDIF.
        ENDIF.
      ENDIF.

      READ TABLE it_knvv INTO wa_knvv WITH KEY kunnr = ls_vbpa-kunnr.     " added by sonu
      IF sy-subrc IS INITIAL.                                               " added by sonu
        wa_output-kurst = wa_knvv-kurst.                                  " added by sonu
      ENDIF.

      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln parvw = 'AG'.
      IF sy-subrc = 0.
        wa_output-sold_land = ls_vbpa-land1.
        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
        IF sy-subrc = 0.
*          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
          IF sy-subrc = 0.
            wa_output-sold_reg_n = ls_zgst_region-bezei.
          ENDIF.
        ENDIF.
      ENDIF.

      SELECT SINGLE landx50 INTO wa_output-s_land_desc FROM t005t WHERE spras = 'EN' AND land1 = wa_output-ship_land.

      """"""" code added by pankaj 04.02.2022"""""""""""""""""""
* Commented by Dhanashree because this field shows in downloaded excel
**      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln parvw = 'PT'.
**      IF sy-subrc = 0.
**        wa_output-adrnr = ls_vbpa-adrnr.

      READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
      IF sy-subrc = 0.
        wa_output-port = ls_adrc-name1.

      ENDIF.
*      ENDIF.
      """"""""""""""""""""""""""""""""""""""""""""""""
************        edited by PJ on 08-09-21

      wa_output-ref_time = sy-uzeit.

*BREAK PRIMUS.
      CONCATENATE wa_output-ref_time+0(2) ':' wa_output-ref_time+2(2)  INTO wa_output-ref_time.

      """"""""""'''  code added by pankaj 04.02.2022""""""""""""""""""""""""

      CLEAR: lv_lines, ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z101'
            language                = 'E'
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF .
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-full_pmnt ls_lines-tdline INTO wa_output-full_pmnt SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      READ TABLE it_tvktt INTO wa_tvktt WITH  KEY ktgrd = wa_vbkd-ktgrd .     "wa_output-ktgrd.   "04.02
      IF sy-subrc = 0.

        wa_output-act_ass       = wa_tvktt-vtext.

      ENDIF.

*     CLEAR wa_jest1.
      READ TABLE it_jest3 INTO wa_jest3 WITH KEY objnr = wa_vbak-objnr.

      SELECT SINGLE * FROM tj30t INTO wa_tj30t  WHERE estat = wa_jest3-stat AND stsma  = 'OR_HEADR'.

      IF sy-subrc = 0.
*        wa_output-stsma      = wa_tj30-stsma.
        wa_output-txt04      = wa_tj30t-txt04.
      ENDIF.

      """""""""""" ended"""""""""""""""""""""""""""""""""""""
*********************ADDED BY SHREYA *********************
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z005'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_itmtxt.
          IF ls_itmtxt-tdline IS NOT INITIAL.
            CONCATENATE wa_output-freight ls_itmtxt-tdline INTO wa_output-freight SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
********************************ADDED BY JYOTI ON 19.06.2024****************
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name  IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z062'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.
      ENDIF.
      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_itmtxt.
          IF ls_itmtxt-tdline IS NOT INITIAL.
            CONCATENATE wa_output-quota_ref ls_itmtxt-tdline INTO wa_output-quota_ref SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
******************************************************************************


      REFRESH lv_lines.
      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
      IF lv_name IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z103'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBP'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
      ENDIF .
      READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO ls_ctbgi.
          IF ls_ctbgi-tdline IS NOT INITIAL.
            CONCATENATE wa_output-po_sr_no ls_ctbgi-tdline INTO wa_output-po_sr_no SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
**************************************** ADDED BY SHREYA**********************
      IF wa_vbap-vbeln IS NOT INITIAL.                                                          """Added by MA on 28.03.2024
        SELECT SINGLE matnr FROM vbap INTO @DATA(lv_matnr) WHERE vbeln = @wa_vbap-vbeln  AND werks = 'PL01'.
        SELECT SINGLE * FROM mast INTO @DATA(ls_mast) WHERE matnr = @lv_matnr AND werks = 'PL01' .
        IF ls_mast IS NOT INITIAL.
          wa_output-bom_exist = 'Yes'.
        ELSEIF ls_mast IS INITIAL.
          wa_output-bom_exist = 'No'.
        ENDIF.
      ENDIF.

************     end
      """""""""""""""""""""""""""""""""""""""""
      """""""""""""""""""LD REQUIRED CHANGES BY PRANIT 12.12.2024
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      lv_name = wa_output-vbeln.
      IF lv_name  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z038'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.

        IF lv_lines IS NOT INITIAL.
          LOOP AT lv_lines INTO ls_itmtxt.
            IF ls_itmtxt-tdline IS NOT INITIAL.
              CONCATENATE wa_output-ld_txt ls_itmtxt-tdline INTO wa_output-ld_txt SEPARATED BY space.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.


***********************************************************************************************************************************

      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name  IS NOT INITIAL .

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z066'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
        IF NOT lv_lines IS INITIAL.
          LOOP AT lv_lines INTO wa_lines.
            IF NOT wa_lines-tdline IS INITIAL.
              CONCATENATE wa_output-ofm_rec_date wa_lines-tdline INTO wa_output-ofm_rec_date SEPARATED BY space.
            ENDIF.
          ENDLOOP.
          CONDENSE wa_output-ofm_rec_date.
        ENDIF.
      ENDIF.
      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      IF lv_name  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'Z067'
            language                = sy-langu
            name                    = lv_name
            object                  = 'VBBK'
          TABLES
            lines                   = lv_lines
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
        ENDIF.
        IF NOT lv_lines IS INITIAL.
          LOOP AT lv_lines INTO wa_lines.
            IF NOT wa_lines-tdline IS INITIAL.
              CONCATENATE wa_output-oss_rec_date wa_lines-tdline INTO wa_output-oss_rec_date SEPARATED BY space.
            ENDIF.
          ENDLOOP.
          CONDENSE wa_output-oss_rec_date.
        ENDIF.
      ENDIF.

      """""""""""""""""""
      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z068'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-source_rest ls_lines-tdline INTO wa_output-source_rest SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE wa_output-source_rest.
      ENDIF.
      REFRESH :lv_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z069'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-suppl_rest ls_lines-tdline INTO wa_output-suppl_rest SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE wa_output-suppl_rest.
      ENDIF.
      REFRESH :lv_lines.
      CLEAR lv_name.
      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z110'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
        TABLES
          lines                   = lv_lines
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
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-cust_mat_desc ls_lines-tdline INTO wa_output-cust_mat_desc SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE wa_output-cust_mat_desc.
      ENDIF.

* For customer material code from text
      PERFORM read_item_text USING '0010' 'VBBP'  lv_name CHANGING wa_output-cust_mat_code.   "+++ 002

* Date format
      PERFORM change_Date_format USING wa_vbak-erdat        CHANGING wa_output-erdat.
      PERFORM change_Date_format USING wa_vbak-vdatu        CHANGING wa_output-vdatu.

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
      APPEND wa_output TO it_output.
      CLEAR ls_vbep.
      CLEAR:lv_matnr,ls_mast.
      CLEAR:wa_output-wip,wa_output-stock_qty .
      CLEAR: wa_output,wa_vbap, wa_konv12.
    ENDLOOP.

  ENDIF.


  """"""""""""""""""        Added By KD on 05.05.2017                 """""""""""""
  IF it_output[] IS NOT INITIAL.
    REFRESH : it_oauto , it_oauto[] , it_mast , it_mast[] , it_stko , it_stko[] ,
              it_stpo , it_stpo[] , it_mara , it_mara[] , it_makt , it_makt[] .

    it_oauto[] = it_output[] .
    DELETE it_oauto WHERE dispo NE 'AUT' .
    DELETE it_oauto WHERE mtart NE 'FERT'.
    IF it_oauto IS NOT  INITIAL .                                             " commented by sonu
      SELECT matnr werks stlan stlnr stlal FROM mast INTO TABLE it_mast
                                              FOR ALL ENTRIES IN it_oauto
                                                    WHERE matnr = it_oauto-matnr
                                                      AND stlan = 1.
    ENDIF.
    IF it_mast IS NOT INITIAL .                                              " commented by sonu
      SELECT stlty stlnr stlal stkoz FROM stko INTO TABLE it_stko
                                        FOR ALL ENTRIES IN it_mast
                                                    WHERE stlnr = it_mast-stlnr
                                                      AND stlal = it_mast-stlal.
    ENDIF.
    IF it_stko IS NOT INITIAL .                                               " commented by sonu
      SELECT stlty stlnr stlkn stpoz idnrk FROM stpo INTO TABLE it_stpo
                                              FOR ALL ENTRIES IN it_stko
                                                          WHERE stlnr = it_stko-stlnr
                                                            AND stpoz = it_stko-stkoz .
    ENDIF.
    IF it_stpo IS NOT INITIAL .                                                 " commented by sonu
      SELECT * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_stpo
                                                      WHERE matnr = it_stpo-idnrk
                                                        AND mtart = 'FERT' .
    ENDIF.
    IF it_mara IS NOT INITIAL .                                                    " commented by sonu
      SELECT * FROM makt INTO TABLE it_makt FOR ALL ENTRIES IN it_mara
                                                        WHERE matnr = it_mara-matnr
                                                          AND spras = 'EN'.
    ENDIF.
    CLEAR wa_output .
    LOOP AT it_makt INTO wa_makt .
      READ TABLE it_stpo INTO wa_stpo WITH KEY idnrk = wa_makt-matnr .
      IF sy-subrc = 0.
        READ TABLE it_stko INTO wa_stko WITH KEY stlnr = wa_stpo-stlnr stkoz = wa_stpo-stpoz .
        IF sy-subrc = 0.
          READ TABLE it_mast INTO wa_mast WITH KEY stlnr = wa_stko-stlnr stlal = wa_stko-stlal.
          IF sy-subrc = 0.
            wa_output-matnr = wa_mast-matnr.
*            wa_output-scmat = wa_makt-matnr.
            wa_output-arktx = wa_makt-maktx.
            CLEAR: lv_lines, ls_itmtxt.

*            BREAK primus.

*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z012'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-packing_type ls_lines-tdline INTO wa_output-packing_type SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.

*
*            """""""""""" code added by pankaj 31.01.2022""""""""""""""""
*
**           infra        TYPE char255,         "added by pankaj 31.01.2022
**          validation   TYPE char255,         "added by pankaj 31.01.2022
**          review_date  TYPE char255,         "added by pankaj 31.01.2022
**          diss_summary TYPE char25
*
*           CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z104'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-infra ls_lines-tdline INTO wa_output-infra SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z105'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-validation ls_lines-tdline INTO wa_output-validation SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z106'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-review_date ls_lines-tdline INTO wa_output-review_date SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*           lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z107'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-diss_summary ls_lines-tdline INTO wa_output-diss_summary SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*            """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""
            APPEND wa_output TO it_output.
            CLEAR wa_output .
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR : wa_mast , wa_stko , wa_stpo , wa_makt.
    ENDLOOP.

  ENDIF.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

ENDFORM.                    " PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM alv_for_output.

*  EXPORT IT_OUTPUT TO MEMORY ID 'ZPEND'.

*ADDING TOP OF PAGE FEATURE
  PERFORM stp3_eventtab_build   CHANGING gt_events[].
  IF p_hidden IS INITIAL.                                        "commented by sonu
    PERFORM comment_build         CHANGING i_list_top_of_page[].
    PERFORM top_of_page.
  ENDIF.

  PERFORM layout_build          CHANGING wa_layout.
****************************************************************************************

  PERFORM build_fieldcat USING 'WERKS'          'X' '1'   'Plant'(003)                    '15'.
  PERFORM build_fieldcat USING 'AUART'          'X' '2'   'Order Type'(004)               '15'.
  PERFORM build_fieldcat USING 'BSTKD'          'X' '3'   'Customer Reference No'(005)    '15'.
  PERFORM build_fieldcat USING 'NAME1'          'X' '4'   'Customer'(006)                 '15'.
  PERFORM build_fieldcat USING 'VKBUR'          'X' '5'   'Sales Office'(007)             '15'.
  PERFORM build_fieldcat USING 'VBELN'          'X' '6'   'Sales Doc No'(008)             '15'.
  PERFORM build_fieldcat USING 'ERDAT'          'X' '7'   'So Date'(009)                  '15'.
  PERFORM build_fieldcat USING 'VDATU'          'X' '8'   'Required Delivery Dt'          '15'."(010).
  PERFORM build_fieldcat USING 'STATUS'         'X' '9'   'HOLD/UNHOLD'(011)              '15'.
  PERFORM build_fieldcat USING 'HOLDDATE'       'X' '10'  'HOLD Date'(012)                '15'.
  PERFORM build_fieldcat USING 'RELDATE'        'X' '11'  'Release Date'(013)             '15'.
  PERFORM build_fieldcat USING 'CANCELDATE'     'X' '12'  'CANCELLED Date'(014)           '15'.



  PERFORM build_fieldcat USING 'DELDATE'        'X' '13'  'Delivery Date'                 '15'. "(015)
  PERFORM build_fieldcat USING 'TAG_REQ'        'X' '14'  'TAG Required'(049)             '50'.
  PERFORM build_fieldcat USING 'TPI'            'X' '15'  'TPI Required'(044)             '50'.
  PERFORM build_fieldcat USING 'LD_TXT'         'X' '16'  'LD Required'(050)              '50'.
  PERFORM build_fieldcat USING 'ZLDPERWEEK'     'X' '17' 'LD %Per Week'(046)              '15'.
  PERFORM build_fieldcat USING 'ZLDMAX'        'X' '18'  'LD % Max'(047)                  '15'.
  PERFORM build_fieldcat USING 'ZLDFROMDATE'    'X' '19' 'LD From Date'(048)              '15'.
*  PERFORM BUILD_FIELDCAT USING ''                'X' '18'  ''(0).
*  PERFORM BUILD_FIELDCAT USING ''                'X' '19'  ''(0).
  PERFORM build_fieldcat USING 'MATNR'          'X' '20'   'Item Code'(016)               '18'.
*  PERFORM build_fieldcat USING 'SCMAT'          'X' '21'   'Sub-Item Code'(053).
  PERFORM build_fieldcat USING 'POSNR'          'X' '21'   'Line Item'(017)               '15'.
  PERFORM build_fieldcat USING 'ARKTX'          'X' '22'   'Item Description'(018)        '20'.
  PERFORM build_fieldcat USING 'KWMENG'         'X' '23'   'SO QTY'(019)                  '15'.
*  PERFORM build_fieldcat USING 'KALAB'          'X' '25'   'Stock Qty'(020).
  PERFORM build_fieldcat USING 'STOCK_QTY'          'X' '24'   'Stock Qty'(020)           '15'.
  PERFORM build_fieldcat USING 'LFIMG'          'X' '25'   'Delivary Qty'(021)            '15'.
  PERFORM build_fieldcat USING 'FKIMG'          'X' '26'   'Invoice Quantity'(022)        '15'.
  PERFORM build_fieldcat USING 'PND_QTY'        'X' '27'   'Pending Qty'(023)             '15'.
  PERFORM build_fieldcat USING 'ETTYP'          'X' '28'   'SO Status'(024)               '15'.
  PERFORM build_fieldcat USING 'MRP_DT'         'X' '29'   'MRP Date'(045)                '15'.
  PERFORM build_fieldcat USING 'EDATU'          'X' '30'   'Production date'              '15'.   "'Posting Date'(025).
  PERFORM build_fieldcat USING 'KBETR'          'X' '31'   'Rate'(026)                    '15'.
  PERFORM build_fieldcat USING 'WAERK'          'X' '32'   'Currency Type'(027)           '15'.
  PERFORM build_fieldcat USING 'CURR_CON'       'X' '33'   'Currency Conv'(028)           '15'.
  PERFORM build_fieldcat USING 'SO_EXC'       'X' '34'   'SO Exchange Rate'(051)          '15'.
  PERFORM build_fieldcat USING 'AMONT'          'X' '35'   'Pending SO Amount'            '15'.
  PERFORM build_fieldcat USING 'ORDR_AMT'       'X' '36'   'Order Amount'(030)            '15'.
*  PERFORM BUILD_FIELDCAT USING 'KURSK'          'X' '34'   ''(031).
  PERFORM build_fieldcat USING 'IN_PRICE'        'X' '37'   'Internal Price'(032)         '15'.
  PERFORM build_fieldcat USING 'IN_PR_DT'        'X' '38'   'Internal Price Date'(033)    '15'.
  PERFORM build_fieldcat USING 'EST_COST'        'X' '39'   'Estimated Cost'(034)         '15'.
  PERFORM build_fieldcat USING 'LATST_COST'      'X' '40'   'Latest Estimated Cost'(035)  '15'.
  PERFORM build_fieldcat USING 'ST_COST'         'X' '41'   'Standard Cost'(036)          '15'.
  PERFORM build_fieldcat USING 'ZSERIES'         'X' '42'   'Series'(037)                 '15'.
  PERFORM build_fieldcat USING 'ZSIZE'           'X' '43'   'Size'(038)                   '15'.
  PERFORM build_fieldcat USING 'BRAND'           'X' '44'   'Brand'(039)                  '15'.
  PERFORM build_fieldcat USING 'MOC'             'X' '45'   'MOC'(040)                    '15'.
  PERFORM build_fieldcat USING 'TYPE'            'X' '46'   'Type'(041)                   '15'.
  """"""""""""'   Added By KD on 04.05.2017    """""""
  PERFORM build_fieldcat USING 'DISPO'            'X' '47'   'MRP Controller'(051)        '15'.
  PERFORM build_fieldcat USING 'WIP'              'X' '48'   'WIP'(052)                   '15'.
  PERFORM build_fieldcat USING 'MTART'            'X' '49'   'MAT TYPE'                   '15'.
  PERFORM build_fieldcat USING 'KDMAT'            'X' '50'   'CUST MAT NO'                '15'.
  PERFORM build_fieldcat USING 'KUNNR'            'X' '51'   'CUSTOMER CODE'              '15'.
  PERFORM build_fieldcat USING 'QMQTY'            'X' '52'   'QM QTY'                     '15'.
  PERFORM build_fieldcat USING 'MATTXT'           'X' '53'   'Material Text'              '20'.
  PERFORM build_fieldcat USING 'ITMTXT'           ' ' '54'   'Sales Text'                 '50'.
  PERFORM build_fieldcat USING 'ETENR'            'X' '55'   'Schedule_no'                '15'.
  PERFORM build_fieldcat USING 'SCHID'            'X' '56'   'Schedule_id'                'STRING'.
  PERFORM build_fieldcat USING 'ZTERM'            'X' '57'   'Payment Terms'              '15'.
  PERFORM build_fieldcat USING 'TEXT1'            'X' '58'   'Payment Terms Text'         '15'.
  PERFORM build_fieldcat USING 'INCO1'            'X' '59'   'Inco Terms'                 '15'.
  PERFORM build_fieldcat USING 'INCO2'            'X' '60'   'Inco Terms Descr'           '15'.
  PERFORM build_fieldcat USING 'OFM'              'X' '61'   'OFM No.'                    '15'.
  PERFORM build_fieldcat USING 'OFM_DATE'         'X' '62'   'OFM Date'                   '15'.
  PERFORM build_fieldcat USING 'SPL'              'X' '63'   'Special Instruction'        '15'.
  PERFORM build_fieldcat USING 'CUSTDELDATE'      'X' '64'  'Customer Delivery Dt'        '15'.   "(015).
  PERFORM build_fieldcat USING 'ABGRU'            'X' '65'  'Rejection Reason Code'       '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM build_fieldcat USING 'BEZEI'            'X' '66'  'Rejection Reason Description' '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM build_fieldcat USING 'WRKST'            'X' '67'  'USA Item Code'                '15'.
  PERFORM build_fieldcat USING 'CGST'             'X' '68'  'CGST%'                        '15'.
*  PERFORM build_fieldcat USING 'CGST_VAL'         'X' '69'  'CGST'.
  PERFORM build_fieldcat USING 'SGST'             'X' '70'  'SGST%'                        '15'.
*  PERFORM build_fieldcat USING 'SGST_VAL'         'X' '71'  'SGST'.
  PERFORM build_fieldcat USING 'IGST'              'X' '72'  'IGST%'                       '15'.
*  PERFORM build_fieldcat USING 'IGST_VAL'         'X' '73'  'IGST'.
  PERFORM build_fieldcat USING 'SHIP_KUNNR'         'X' '73'  'Ship To Party'              '15'.
  PERFORM build_fieldcat USING 'SHIP_KUNNR_N'       'X' '74'  'Ship To Party Description'  '15'.
  PERFORM build_fieldcat USING 'SHIP_REG_N'         'X' '75'  'Ship To Party State'        '15'.
  PERFORM build_fieldcat USING 'SOLD_REG_N'         'X' '76'  'Sold To Party State'        '15'.
  PERFORM build_fieldcat USING 'NORMT'              'X' '77'       'Industry Std Desc.'           '15'.
  PERFORM build_fieldcat USING 'SHIP_LAND'          'X' '78'   'Ship To Party Country Key'    '15'.
  PERFORM build_fieldcat USING 'S_LAND_DESC'        'X' '79'   'Ship To Party Country Desc'  '15'.
  PERFORM build_fieldcat USING 'SOLD_LAND'          'X' '80' 'Sold To Party Country Key'     '15'.
  PERFORM build_fieldcat USING 'POSEX'              'X' '81' 'Purchase Order Item'               '15'.
  PERFORM build_fieldcat USING 'BSTDK'              'X' '82' 'PO Date'                        '15'.
  PERFORM build_fieldcat USING 'LIFSK'              'X' '83' 'Delivery Block(Header Loc)'                     '15'.
  PERFORM build_fieldcat USING 'VTEXT'              'X' '84' 'Delivery Block Txt'               '15'.
  PERFORM build_fieldcat USING 'INSUR'              'X' '85' 'Insurance'               '15'.
  PERFORM build_fieldcat USING 'PARDEL'             'X' '86' 'Partial Delivery'               '15'.
  PERFORM build_fieldcat USING 'GAD'                'X' '87' 'GAD'               '15'.
  PERFORM build_fieldcat USING 'US_CUST'            'X' '88' 'USA Customer Name'               '15'.
  PERFORM build_fieldcat USING 'TCS'                'X' '89' 'TCS Rate'               '15'.
  PERFORM build_fieldcat USING 'TCS_AMT'            'X' '90' 'TCS Amount'               '15'.
  PERFORM build_fieldcat USING 'PO_DEL_DATE'        'X' '91' 'PO_Delivery_Date'               '15'.
  PERFORM build_fieldcat USING 'OFM_NO'             'X' '92' 'OFM SR. NO.'               '15'.
  PERFORM build_fieldcat USING 'CTBG'              'X' '93' 'CTBG Item Details'               '20'.
  PERFORM build_fieldcat USING 'CERTIF'             'X' '94' 'Certificate Details'             '20'.
  PERFORM build_fieldcat USING 'ITEM_TYPE'             'X' '95' 'Item Type'             '20'. "edited by PJ on16-08-21
  PERFORM build_fieldcat USING 'REF_TIME'             'X' '96' 'Ref. Time'             '15'. "edited by PJ on 08-09-21
  PERFORM build_fieldcat USING 'DIS_RATE'                'X' '147' 'Dis %'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
  PERFORM build_fieldcat USING 'DIS_AMT'                'X' '148' 'Discount Amount'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
  PERFORM build_fieldcat USING 'DIS_UNIT_RATE'                'X' '149' 'Discount Unit Rate'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025


*  PERFORM build_fieldcat USING 'CTBG'             'X' '94' 'CTBG Details'             '10'.

  """""""""""""""" "added by pankaj 28.01.2022""""""""""""""""

  PERFORM build_fieldcat USING 'PROJ'               'X' '97' 'Project Owner Details'             '15'. "added by pankaj 28.01.2022
  PERFORM build_fieldcat USING 'COND'               'X' '98' 'Condition Delivery Date'             '15'. "added by pankaj 28.01.2022
  PERFORM build_fieldcat USING 'RECEIPT_DATE'       'X' '99' 'Code Receipt Date'             '15'. "added by pankaj 28.01.2022
  PERFORM build_fieldcat USING 'REASON'             'X' '100' 'Reason'             '15'.               "added by pankaj 28.01.2022
  PERFORM build_fieldcat USING 'NTGEW'             'X' '101' 'New Weight'             '15'.               "added by pankaj 28.01.2022
  PERFORM build_fieldcat USING 'ZPR0'             'X' '102' 'Condition ZPR0'           '15'.
  PERFORM build_fieldcat USING 'ZPF0'             'X' '103' 'Condition ZPF0'           '15'.
  PERFORM build_fieldcat USING 'ZIN1'               'X' '104' 'Condition ZIN1'           '15'.
  PERFORM build_fieldcat USING 'ZIN2'               'X' '105' 'Condition ZIN2'           '15'.
  PERFORM build_fieldcat USING 'JOIG'               'X' '106' 'Condition JOIG'           '15'.
  PERFORM build_fieldcat USING 'JOCG'               'X' '107' 'Condition JOCG'           '15'.
  PERFORM build_fieldcat USING 'JOSG'               'X' '108' 'Condition JOSG'           '15'.
  PERFORM build_fieldcat USING 'DATE'               'X' '109' 'Schedule line del.Date'  '15'.
  PERFORM build_fieldcat USING 'PRSDT'               'X' '110' 'Pricing Date'            '15'.
  PERFORM build_fieldcat USING 'PACKING_TYPE'               'X' '111' 'Packing Type'            '15'.
  PERFORM build_fieldcat USING 'OFM_DATE1'               'X' '112' 'OFM Delivery Date'            '15'.
  PERFORM build_fieldcat USING 'MAT_TEXT'               'X' '113' 'Material Sales Text'            '15'.
  "PERFORM build_fieldcat USING 'ERDAT1'               'X' '113' 'SO Change Date '            '15'.

  """""""""""""""""""""""" ended """"""""""""""""""""""""""""""""""'
*infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary
  """"""""""""""""""""""""Coded added by pankaj 31.01.2022  """"""""""""""""""""""""""""

  PERFORM build_fieldcat USING 'INFRA'                      'X' '114' 'Infrastructure Required'            '15'.
  PERFORM build_fieldcat USING 'VALIDATION'                 'X' '115' 'Validation Plan Refrence'            '15'.
  PERFORM build_fieldcat USING 'REVIEW_DATE'                'X' '116' 'Review Date'            '15'.
  PERFORM build_fieldcat USING 'DISS_SUMMARY'                'X' '117' 'Discussion Summary'            '15'.
  PERFORM build_fieldcat USING 'CHANG_SO_DATE'                'X' '118' 'Changed SO Date'            '15'.

  """"""" added by pankaj 04.02.2022"""""""""""""""

  PERFORM build_fieldcat USING 'PORT'                      'X'       '119' 'Port'                         '15'.
  PERFORM build_fieldcat USING 'FULL_PMNT'                 'X'       '120' 'Full Payment Desc'            '15'.
  PERFORM build_fieldcat USING 'ACT_ASS'                   'X'       '121' 'Act Assignments'            '15'.
  PERFORM build_fieldcat USING 'TXT04'                     'X'       '122' 'User Status'            '15'.
*  PERFORM build_fieldcat USING 'KWERT'                     'X'       '123' 'Condition Value ZPR0'            '15'.
  PERFORM build_fieldcat USING 'FREIGHT'                     'X'       '124' 'Freight'            '15'.
  " PERFORM build_fieldcat USING 'OFM_SR_NO'                     'X'       '125' 'OFM SR NO'            '15'.
  PERFORM build_fieldcat USING 'PO_SR_NO'                     'X'       '126' 'PO SR NO TEXT'            '15'.

  PERFORM build_fieldcat USING 'UDATE'                      'X'         '127' 'Last changed date'        '15'.
  PERFORM build_fieldcat USING 'BOM'                      'X'         '128' 'BOM Status'        '15'.
  PERFORM build_fieldcat USING 'ZPEN_ITEM'                      'X'         '129' 'Pending Items'        '15'.
  PERFORM build_fieldcat USING 'ZRE_PEN_ITEM'                      'X'         '130' 'Reason for Pending Items'        '15'.
  PERFORM build_fieldcat USING 'ZINS_LOC'                      ''         '131' 'Installation Location'        '15'.
  PERFORM build_fieldcat USING 'BOM_EXIST'                      ''         '131' 'BOM EXISTS '        '15'.
  PERFORM build_fieldcat USING 'POSEX1'                      ''         '132' 'PO ITEM NO'        '15'.
  PERFORM build_fieldcat USING 'LGORT'              'X' '133' 'Storage Location'               '15'."added by jyoti on11.06.2024
  PERFORM build_fieldcat USING 'QUOTA_REF'              'X' '134' 'QT Reference No.'               '15'."added by jyoti on16.06.2024
  PERFORM build_fieldcat USING 'ZMRP_DATE'              'X' '135' 'DV_PLMRPDATE'               '15'."added by jyoti on16.06.2024
  PERFORM build_fieldcat USING 'VKORG'             'X' '136' 'Sales Organization'             '20'. "ADDED BY AAKASHK 19.08.2024
  PERFORM build_fieldcat USING 'VTWEG'             'X' '137' 'Distribution Channel'             '15'. "ADDED BY AAKASHK 19.08.2024
  PERFORM build_fieldcat USING 'SPART'             'X' '138' 'Division'             '15'. "ADDED BY AAKASHK 19.08.2024
  PERFORM build_fieldcat USING 'ZEXP_MRP_DATE1'             'X' '139' 'Expected MRP Date'             '15'. "ADDED BY AAKASHK 19.08.2024
*  perform build_fieldcat using 'VTEXT1'                      'X'         '131' 'Billing Block'        '15'.
  PERFORM build_fieldcat USING 'SPECIAL_COMM'                'X' '140' 'Special Comments'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'ZCUST_PROJ_NAME'                'X' '141' 'Customer Project NAme'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'AMENDMENT_HIS'                'X' '144' 'Amendment_history'                '20'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'PO_DIS'                'X' '145' 'Po Discrepancy'                '20'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'ZHOLD_REASON_N1'                'X' '146' 'Hold Reason'                '50'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'STOCK_QTY_KTPI'                'X' '147' 'Stock Qty KTPI'                '15'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'STOCK_QTY_TPI1'                'X' '148' 'Stock Qty TPI1'                '15'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'KURST'                         'X' '149' 'Exchange Rate Type'                '15'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'OFM_REC_DATE'  'X' '150' 'OFM Received date from pre-sales'      '15'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'OSS_REC_DATE'  'X' '151' 'OSS Received from Technical Cell'      '15'."ADDED BY jyoti ON 21.01.2025
  PERFORM build_fieldcat USING 'SOURCE_REST'               'X' '151' 'Sourcing restrictions'            '15'.
  PERFORM build_fieldcat USING 'SUPPL_REST'               'X' '152' 'Supplier restrictions'            '15'.
  PERFORM build_fieldcat USING 'CUST_MAT_DESC'               'X' '153' 'Customer Material Description'            '15'.
  PERFORM build_fieldcat USING 'CUST_MAT_CODE'               'X' '154' 'Customer Material Code'            '40'.

  """"""" ended """"""""""""""""""""""""""""

*          dispo       TYPE marc-dispo,
*          wip         TYPE i,
*          mtart       TYPE mara-mtart,
*          kdmat       TYPE vbap-kdmat,
*          etenr       type vbep-etenr,
*          kunnr       TYPE kna1-kunnr,

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
*     i_structure_name   = 'OUTPUT'
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
      it_sort            = i_sort
*     i_default          = 'A'
*     i_save             = 'A'
      i_save             = 'X'
      it_events          = gt_events[]
    TABLES
      t_outtab           = it_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  REFRESH it_output.
ENDFORM.                    " ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

FORM stp3_eventtab_build  CHANGING p_gt_events TYPE slis_t_event.

  DATA: lf_event TYPE slis_alv_event. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = p_gt_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_gt_events  FROM  lf_event INDEX 3 TRANSPORTING form."TO P_I_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM comment_build CHANGING i_list_top_of_page TYPE slis_t_listheader.
  DATA: lf_line       TYPE slis_listheader. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info =  ''(042).
  APPEND lf_line TO i_list_top_of_page.
*--HEAD INFO: TYPE S
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = TEXT-043.
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_list_top_of_page[]. "INTERNAL TABLE WITH


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.

*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  wa_layout-zebra          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  p_wa_layout-zebra          = 'X'.
  p_wa_layout-no_colhead        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM build_fieldcat  USING    v1  v2 v3 v4 v5.
*  WA_FCAT-DECIMALS_OUT = 9.
*  WA_FCAT-NO_SIGN = 'X'.

  wa_fcat-fieldname   = v1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_OUTPUT'.  "'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
  IF v3 < 4.
    wa_fcat-key         =  v2 ."  'X'.
  ENDIF.
  wa_fcat-seltext_l   =  v4.
  wa_fcat-outputlen   =  v5." 20.
*  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.
  wa_fcat-col_pos     =  v3.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down_set TABLES it_output USING p_folder. .   "commented by sonu
*  BREAK fujiabap.
  TYPE-POOLS truxs.
  DATA: it_csv     TYPE truxs_t_text_data,
        wa_csv     TYPE LINE OF truxs_t_text_data,
        hd_csv     TYPE LINE OF truxs_t_text_data,
        hd_csv_new TYPE LINE OF truxs_t_text_data.
*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).
*break primus.
  PERFORM new_file_1 TABLES it_output."added by jyoti on 26.04.2024
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_output_new
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  PERFORM cvs_header USING hd_csv."commented by jyoti on
*  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Task 1'.
*  IF P_HIDDEN IS INITIAL  .
  PERFORM cvs_header USING hd_csv.
*  ENDIF.
*  lv_folder = 'D:\usr\sap\DEV\D00\work'.                "added for check
  lv_file = 'ZDELPENDSO.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
  IF open_so IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.

*  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Task 1'.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.    "MESSAGE LV_MSG.  "NON-UNICODE.              "commented by sonu
  IF sy-subrc = 0.
    DATA lv_string_1362 TYPE string.
    DATA lv_crlf_1362 TYPE string.
    lv_crlf_1362 = cl_abap_char_utilities=>cr_lf.
    lv_string_1362 = hd_csv.                                                      " commented by sonu
*    TRANSFER hd_csv TO lv_fullfile.                                                " added by sonu
    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
      CONCATENATE lv_string_1362 lv_crlf_1362 wa_csv INTO lv_string_1362.         "commented by sonu
*        TRANSFER wa_csv TO lv_fullfile.
*        ENDIF.
      CLEAR: wa_csv.                                                              "commented by sonu
    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.      " added by sonu
*    MESSAGE lv_msg TYPE 'S'.                                                       " added by sonu
*  ENDIF.
    TRANSFER lv_string_1362 TO lv_fullfile.                                         "commented by sonu
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.      "commented by sonu
    MESSAGE lv_msg TYPE 'S'.                                                         "commented by sonu
  ENDIF.
*  ELSE.
*    DATA LV_STRING_1365 TYPE STRING.
*    DATA LV_CRLF_1365 TYPE STRING.
*
*    OPEN DATASET LV_FULLFILE
*     FOR APPENDING IN TEXT MODE ENCODING DEFAULT MESSAGE LV_MSG.
*
*    IF SY-SUBRC = 0.
*      LV_CRLF_1365 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
*      DESCRIBE TABLE IT_CSV LINES DATA(LV_LINETEM).
*      LOOP AT IT_CSV INTO WA_CSV.
*        IF LV_LINETEM > 1.
*          IF SY-TABIX = 1.
*            LV_STRING_1365 = WA_CSV.
*          ELSE.
*            CONCATENATE LV_STRING_1365 LV_CRLF_1365 WA_CSV INTO LV_STRING_1365.
*          ENDIF.
*
*        ELSE.
*          CONCATENATE  WA_CSV LV_CRLF_1365 INTO LV_STRING_1365.
*          LV_STRING_1365 =  WA_CSV.
*        ENDIF.
*        CLEAR: WA_CSV.
*      ENDLOOP.
*    ENDIF.
*    TRANSFER LV_STRING_1365 TO LV_FULLFILE.
**    CLOSE DATASET lv_fullfile.
*
*  ENDIF.
*  CLOSE DATASET LV_FULLFILE.


******************************************************new file zpendso **********************************

  PERFORM new_file TABLES it_output.
*  break primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Task 1'.
*  IF P_HIDDEN IS INITIAL  .
  PERFORM cvs_header USING hd_csv.
*  ENDIF.
*  lv_folder = 'D:\usr\sap\DEV\D00\work'.       "added for check
  lv_file = 'ZDELPENDSO.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPENDSO1 Download started on', sy-datum, 'at', sy-uzeit.


*  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Task 1'.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT MESSAGE lv_msg.  "NON-UNICODE.                    "commented by sonu
  IF sy-subrc = 0.
    DATA lv_string_1363 TYPE string.                                            "commented by sonu
    DATA lv_crlf_1363 TYPE string.
    lv_crlf_1363   = cl_abap_char_utilities=>cr_lf.
    lv_string_1363 = hd_csv.
*    TRANSFER hd_csv TO lv_fullfile.                                     "added by sonu
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_1363 lv_crlf_1363 wa_csv INTO lv_string_1363 .             " commented by sonu
*       IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.                         " added by sonu
*      ENDIF.
      CLEAR: wa_csv.
    ENDLOOP.


    TRANSFER lv_string_1363 TO lv_fullfile.                     "commented by sonu

*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*  ELSE.
*    DATA LV_STRING_1377 TYPE STRING.
*    DATA LV_CRLF_1377 TYPE STRING.
*
*    OPEN DATASET LV_FULLFILE
*   FOR APPENDING IN TEXT MODE ENCODING DEFAULT MESSAGE LV_MSG.
*    IF SY-SUBRC = 0.
*
*      LV_CRLF_1377 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
*      DESCRIBE TABLE IT_CSV LINES DATA(LV_LINETEM1).
*      LOOP AT IT_CSV INTO WA_CSV.
*        IF LV_LINETEM1 > 1.
*          IF SY-TABIX = 1.
*            LV_STRING_1377 = WA_CSV.
*          ELSE.
*            CONCATENATE LV_STRING_1377 LV_CRLF_1377 WA_CSV INTO LV_STRING_1377.
*          ENDIF.
*
*        ELSE.
*          CONCATENATE  WA_CSV LV_CRLF_1377 INTO LV_STRING_1377.
*          LV_STRING_1377 =  WA_CSV.
*        ENDIF.
*        CLEAR: WA_CSV.
*      ENDLOOP.
*    ENDIF.
*    TRANSFER LV_STRING_1377 TO LV_FULLFILE.

*  ENDIF.

*  CLOSE DATASET LV_FULLFILE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE
          'PLANT'
          'ORDER TYPE'
          'CUST REF NO'
          'CUSTOMER NAME'
          'SALES OFFICE'
          'SALES DOC NO'
          'SO DATE'
          'REQUIRED DELIVERY DATE'
          'HOLD/UNHOLD'
          'HOLD DATE'
          'REL DATE'
          'CANCEL DATE'
          'DELV DATE'
          'TAG_REQD'
          'TPI REQD'
          'LD REQD'
          'LD PER WEEK'
          'LD MAX'
          'LD FROM DATE'
          'MAT NR'
          'POS NR'
          'DESCRIPTION'
          'SO QTY'
          'STOCK QTY'
          'DELIVARY QTY'
          'INVOICE QUANTITY'
          'PENDING QTY'
          'SO STATUS'
          'MRP DATE'
          'PRODUCTION DATE'
          'RATE'
          'CURRENCY'
          'CURRENCY CONV'
*          'SO Exchange Rate'
          'PENDING SO AMOUNT'
          'ORDER AMOUNT'
          'INTERNAL PRICE'
          'INTERNAL PRICE DATE'
          'ESTIMATED COST'
          'LATEST ESTIMATED COST'
          'STANDARD COST'
          'SERIES'
          'SIZE'
          'BRAND'
          'MOC'
          'TYPE'
          'MRP CONTROLLER'
          'WIP'
          'MAT TYPE'
          'CUST MAT NO'
          'CUSTOMER'
          'QM QTY'
          'Description Long'
          'MATTXT'              "'Sales Text'
          'SCHD NO'
          'SCHEDULE_ID'
          'SO Exchange Rate'
          'Payment Terms'
          'Payment Terms Text'
          'Inco Terms'
          'Inco Terms Descr'
          'OFM No.'
          'OFM Date'
          'CUSTOMER DEL DATE'
          'File Created Date'
          'Rejection Reason Code'
          'Rejection Reason Description'
          'USA Item Code'
          'CGST%'
*          'CGST'
          'SGST%'
*          'SGST'
          'IGST%'
*          'IGST'
          'Ship To Party'
          'Ship To Party Description'
          'Ship To Party State'
          'Sold To Party State'
          'Industry Std Desc.'
          'Ship To Party Country Key'
          'Sold To Party Country Key'
          'Purchase Order Item'
          'Ship To Party Country Desc'
          'PO Date'
          'Delivery Block(Header Loc)'
          'Delivery Block Txt'
           'Insurance'
          'Partial Delivery'
          'GAD'
          'USA Customer Name'
          'TCS Rate'
          'TCS Amount'
          'Special Instruction'
          'PO_Delivery_Date'
          'OFM SR. NO.'
          'CTBG Item Details'
          'Certificate Details'
          'Item Type' "  edited by PJ on 16-08-21
          'Ref. Time' "  edited by PJ on 08-09-21
*          'CTBG Details'
          'Project Ownwer Name'            "added by pankaj 28.01.2022
          'Condition Delivery Date'        "added by pankaj 28.01.2022
          'Code Receipt Date'              "added by pankaj 28.01.2022
          'Reason'                         "added by pankaj 28.01.2022
          'Net Weight'                         "added by pankaj 28.01.2022
          'Condition ZPR0'
          'Condition ZPF0'
          'Condition ZIN1'
          'Condition ZIN2'
          'Condition JOIG'
          'Condition JOCG'
          'Condition JOSG'
          'Schedule line del.Dat'
          'Pricing Date'
          'Packing Type'
          'OFM Delivery Date'
          'Material Sales Text'
          'Infrastructure required'        "added by pankaj 31.01.2022
          'Validation Plan Refrence'          "added by pankaj 31.01.2022
          'Review Date'                      "added by pankaj 31.01.2022
          'Discussion Summary'                "added by pankaj 31.01.2022
          'Changed SO Date'
          'Port'                                   "added by pankaj 04.02.2022
          'Full Payment Desc'                     "added by pankaj 04.02.2022
          'Act Assignments'                       "added by pankaj 04.02.2022
          'User Status'                             "added by pankaj 04.02.2022
          'Freight'
          "'OFM SR NO'
          'PO SR NO Text'
          'Last changed date'
          'BOM Status'
          'Pending Items'
          'Reason for Pending Items'
          'Installation Location'
          'BOM EXISTS '
          'Po Item No.'
          'Storage Location'    "added by jyoti on 11.06.2024
          'QT Reference No.' "added by jyoti 19.06.2024
          'DV_PLMRPDATE'  "ADDED BY JYOTI ON 02.07.2024
          'Sales Organization'    "ADDED BY AAKASHK 19.08.2024
          'Distribution Channel'  "ADDED BY AAKASHK 19.08.2024
          'Division'               "ADDED BY AAKASHK 19.08.2024
          'Expected MRP Date'
          'Special Comments'
          'Customer Project Name'
           'Amendment_history'
          'Po Discrepancy'
          'Hold Reason'
           'Stock Qty KTPI'  "added byjyoti on 28.03.2025                   " added by sonu
          'Stock Qty TPI1' "added byjyotio n 28.03.2025                      "  added by sonu
          'Exchange Rate Type'                                              " added by sonu
          'OFM Received date from pre-sales'                                " added by sonu
          'OSS Received from Technical Cell'                                " added by sonu
          'Sourcing restrictions'                                           " added by sonu
          'Supplier restrictions'                                           " added by sonu
          'Customer Material Description'                                   " added by sonu
          'Dis %'               "added by mahadev 17.12.2025
          'Discount Amount'               "added by mahadev 17.12.2025
          'Discount Unit Rate'               "added by mahadev 17.12.2025
          'Customer Mat.Code'     "+++ 002
  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM new_file TABLES it_output.
  DATA:
    ls_final TYPE t_final.

  LOOP AT it_output INTO wa_output.
    ls_final-werks       = wa_output-werks.
    ls_final-auart       = wa_output-auart.
    ls_final-bstkd       = wa_output-bstkd.
    ls_final-name1       = wa_output-name1.
    ls_final-vkbur       = wa_output-vkbur.
    ls_final-vbeln       = wa_output-vbeln.
    ls_final-status      = wa_output-status.
    ls_final-tag_req     = wa_output-tag_req.
    ls_final-tpi         = wa_output-tpi.
    ls_final-ld_txt      = wa_output-ld_txt.
    ls_final-zldperweek  = wa_output-zldperweek.
    ls_final-zldmax      = wa_output-zldmax.
    ls_final-matnr       = wa_output-matnr.
    ls_final-posnr       = wa_output-posnr.
    ls_final-arktx       = wa_output-arktx.
    ls_final-kalab       = abs( wa_output-stock_qty ).
    ls_final-kwmeng      = abs( wa_output-kwmeng ).
    ls_final-lfimg       = abs( wa_output-lfimg ).
    ls_final-fkimg       = abs( wa_output-fkimg ).
    ls_final-pnd_qty     = abs( wa_output-pnd_qty ).
    ls_final-ettyp       = wa_output-ettyp.
    ls_final-kbetr       = wa_output-kbetr.
    ls_final-waerk       = wa_output-waerk.
    ls_final-curr_con    = wa_output-curr_con.
    ls_final-amont       = abs( wa_output-amont ).
    ls_final-ordr_amt    = abs( wa_output-ordr_amt ).
    ls_final-in_price    = abs( wa_output-in_price ).
    ls_final-est_cost    = abs( wa_output-est_cost ).
    ls_final-latst_cost  = abs( wa_output-latst_cost ).
    ls_final-st_cost     = abs( wa_output-st_cost ).
    ls_final-zseries     = wa_output-zseries.
    ls_final-zsize       = wa_output-zsize.
    ls_final-brand       = wa_output-brand.
    ls_final-moc         = wa_output-moc.
    ls_final-type        = wa_output-type.
    ls_final-dispo       = wa_output-dispo.
    ls_final-wip         = wa_output-wip.
    ls_final-mtart       = wa_output-mtart.
    ls_final-kdmat       = wa_output-kdmat.
    ls_final-kunnr       = wa_output-kunnr.
    ls_final-qmqty       = abs( wa_output-qmqty ).
    ls_final-mattxt      = wa_output-mattxt.
    ls_final-us_cust      = wa_output-us_cust.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-mattxt WITH ' & '.
    ls_final-itmtxt      = wa_output-itmtxt.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-itmtxt WITH ' & '.
    ls_final-etenr       = wa_output-etenr.
    ls_final-schid       = wa_output-schid.
    ls_final-so_exc      = wa_output-so_exc.
    ls_final-zterm       = wa_output-zterm.
    ls_final-text1       = wa_output-text1.
    ls_final-inco1       = wa_output-inco1.
    ls_final-inco2       = wa_output-inco2.
    ls_final-ofm         = wa_output-ofm.
    ls_final-ofm_date    = wa_output-ofm_date.
    ls_final-spl         = wa_output-spl.
    ls_final-wrkst       = wa_output-wrkst.
    ls_final-abgru       = wa_output-abgru.
    ls_final-bezei       = wa_output-bezei.
    ls_final-cgst        = wa_output-cgst.
    IF ls_final-cgst IS INITIAL .
      CONCATENATE  '0' ls_final-cgst INTO ls_final-cgst.
    ENDIF.
    ls_final-sgst        = wa_output-sgst.
    IF ls_final-sgst IS INITIAL .
      CONCATENATE  '0' ls_final-sgst INTO ls_final-sgst.
    ENDIF.
    ls_final-igst        = wa_output-igst.
    IF ls_final-igst IS INITIAL .
      CONCATENATE  '0' ls_final-igst INTO ls_final-igst.
    ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
    ls_final-ship_kunnr    = wa_output-ship_kunnr.
    ls_final-ship_kunnr_n  = wa_output-ship_kunnr_n.
    ls_final-ship_reg_n    = wa_output-ship_reg_n.
    ls_final-sold_reg_n    = wa_output-sold_reg_n.
    ls_final-ship_land     = wa_output-ship_land.
    ls_final-s_land_desc   = wa_output-s_land_desc.
    ls_final-sold_land     =  wa_output-sold_land.
*    ls_final-normt          = wa_output-normt.
    ls_final-posex          = wa_output-posex.

    ls_final-lifsk          = wa_output-lifsk.
    ls_final-vtext          = wa_output-vtext.
    ls_final-insur          = wa_output-insur .
    ls_final-pardel         = wa_output-pardel.
    ls_final-gad            = wa_output-gad.
    ls_final-tcs            = wa_output-tcs.
    ls_final-tcs_amt        = wa_output-tcs_amt.

    ls_final-ctbg          = wa_output-ctbg.
    ls_final-certif         = wa_output-certif.
    ls_final-vkorg          = wa_output-vkorg.         "ADDED BY AAKASHK 19.08.2024 EVNG
    ls_final-vtweg          = wa_output-vtweg.         "ADDED BY AAKASHK 19.08.2024 EVNG
    ls_final-spart         = wa_output-spart.         "ADDED BY AAKASHK 19.08.2024 EVNG
    ls_final-special_comm  = wa_output-special_comm.
    ls_final-kurst         = wa_output-kurst.           "ADDED BY jyoti 31.03.2025


*    ls_final-ctbg         = wa_output-ctbg.

    ls_final-bstdk  = wa_output-bstdk.
    ls_final-erdat  = wa_output-erdat.
    ls_final-vdatu  = wa_output-vdatu.
    ls_final-holddate  = wa_output-holddate.
    ls_final-reldate  = wa_output-reldate.
    ls_final-canceldate  = wa_output-canceldate.
    ls_final-deldate  = wa_output-deldate.
    ls_final-custdeldate  = wa_output-custdeldate.
    ls_final-po_del_date  = wa_output-po_del_date.
    ls_final-zldfromdate  = wa_output-zldfromdate.
    ls_final-mrp_dt  = wa_output-mrp_dt.
    ls_final-edatu  = wa_output-edatu.
    ls_final-in_pr_dt  = wa_output-in_pr_dt.
    ls_final-ref_dt  = wa_output-ref_dt.
    ls_final-zmrp_date  = wa_output-zmrp_date.
    ls_final-zexp_mrp_date1  = wa_output-zexp_mrp_date1.

*************************************************************************************
    ls_final-ofm_no = wa_output-ofm_no .

    CONDENSE ls_final-kwmeng.
    IF wa_output-kwmeng < 0.
      CONCATENATE '-' ls_final-kwmeng INTO ls_final-kwmeng.
    ENDIF.

    CONDENSE ls_final-lfimg.
    IF wa_output-lfimg < 0.
      CONCATENATE '-' ls_final-lfimg INTO ls_final-lfimg.
    ENDIF.

    CONDENSE ls_final-fkimg.
    IF wa_output-fkimg < 0.
      CONCATENATE '-' ls_final-fkimg INTO ls_final-fkimg.
    ENDIF.

    CONDENSE ls_final-pnd_qty.
    IF wa_output-pnd_qty < 0.
      CONCATENATE '-' ls_final-pnd_qty INTO ls_final-pnd_qty.
    ENDIF.

    CONDENSE ls_final-qmqty.
    IF wa_output-qmqty < 0.
      CONCATENATE '-' ls_final-qmqty INTO ls_final-qmqty.
    ENDIF.

*    CONDENSE LS_FINAL-KBETR.  """ --NC
    IF wa_output-kbetr < 0.
      CONCATENATE '-' ls_final-kbetr INTO ls_final-kbetr.
    ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

    CONDENSE ls_final-amont.
    IF wa_output-amont < 0.
      CONCATENATE '-' ls_final-amont INTO ls_final-amont.
    ENDIF.

    CONDENSE ls_final-ordr_amt.
    IF wa_output-ordr_amt < 0.
      CONCATENATE '-' ls_final-ordr_amt INTO ls_final-ordr_amt.
    ENDIF.


    CONDENSE ls_final-in_price.
    IF wa_output-in_price < 0.
      CONCATENATE '-' ls_final-in_price INTO ls_final-in_price.
    ENDIF.

    CONDENSE ls_final-est_cost.
    IF wa_output-est_cost < 0.
      CONCATENATE '-' ls_final-est_cost INTO ls_final-est_cost.
    ENDIF.

    CONDENSE ls_final-latst_cost.
    IF wa_output-latst_cost < 0.
      CONCATENATE '-' ls_final-latst_cost INTO ls_final-latst_cost.
    ENDIF.

    CONDENSE ls_final-st_cost.
    IF wa_output-st_cost < 0.
      CONCATENATE '-' ls_final-st_cost INTO ls_final-st_cost.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
    ls_final-item_type         = wa_output-item_type. "edited by PJ on 16-08-21
    ls_final-ref_time          = wa_output-ref_time. "edited by PJ on 08-09-21


    """""""""code added by pankaj 28.01.2022"""""""""""""""""""""""""""""""""""

    ls_final-proj          = wa_output-proj .

    ls_final-cond          = wa_output-cond .

    ls_final-receipt_date  = wa_output-receipt_date.

    ls_final-reason      = wa_output-reason.

    ls_final-ntgew      = wa_output-ntgew.

    ls_final-zpr0        = wa_output-zpr0.
    ls_final-zpf0        = wa_output-zpf0.
    ls_final-zin1        = wa_output-zin1.
    ls_final-zin2        = wa_output-zin2.
    ls_final-joig        = wa_output-joig.
    ls_final-jocg        = wa_output-jocg.
    ls_final-josg        = wa_output-josg.

    ls_final-date        = wa_output-date.
    ls_final-prsdt        = wa_output-prsdt.
    ls_final-packing_type = wa_output-packing_type.
    ls_final-ofm_date1 = wa_output-ofm_date1.
    ls_final-mat_text = wa_output-mat_text.

    """"""" code added by pankaj 31.01.2022"""""""""

    ls_final-infra        = wa_output-infra.
    ls_final-validation   = wa_output-validation.
    ls_final-review_date  = wa_output-review_date.
    ls_final-review_date  = wa_output-review_date.
    ls_final-diss_summary = wa_output-diss_summary .
    ls_final-chang_so_date = wa_output-chang_so_date .

    """""""""""""" code added by pankaj 04.02.2022
    ls_final-port      = wa_output-port .
    ls_final-full_pmnt = wa_output-full_pmnt .
    ls_final-act_ass   = wa_output-act_ass .
    ls_final-txt04     = wa_output-txt04 .
    ls_final-freight  = wa_output-freight.
    " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
    ls_final-po_sr_no = wa_output-po_sr_no.
    ls_final-udate = wa_output-udate.
    ls_final-bom = wa_output-bom.
    ls_final-zpen_item = wa_output-zpen_item.
    ls_final-zre_pen_item = wa_output-zre_pen_item.
    ls_final-zins_loc = wa_output-zins_loc. "ADDED BY PRIMUS MA
    ls_final-bom_exist = wa_output-bom_exist. "ADDED BY PRIMUS MA
    ls_final-posex1         = wa_output-posex.
    ls_final-lgort         = wa_output-lgort."added by jyoti on 11.06.2024
    ls_final-quota_ref         = wa_output-quota_ref."added by jyoti on 19.06.2024
    ls_final-zcust_proj_name = wa_output-zcust_proj_name."Added by jyoti
    ls_final-po_dis = wa_output-po_dis.    """ ADDED BY JYOTI ON 21.01.2025
    ls_final-amendment_his = wa_output-amendment_his.    """ ADDED BY JYOTI ON 221.01.2025
    ls_final-zhold_reason_n1 = wa_output-zhold_reason_n1.    """ ADDED BY JYOTI ON 221.01.2025
    ls_final-stock_qty_ktpi = wa_output-stock_qty_ktpi.    """ ADDED BY jyoti 19.08.2024
    ls_final-stock_qty_tpi1 = wa_output-stock_qty_tpi1.    """ ADDED BY jyoti 19.08.2024
    ls_final-ofm_rec_date = wa_output-ofm_rec_date.
    ls_final-oss_rec_date = wa_output-oss_rec_date.
    ls_final-source_rest = wa_output-source_rest.
    ls_final-suppl_rest =  wa_output-suppl_rest.
    ls_final-cust_mat_desc =  wa_output-cust_mat_desc.

*    ls_final-vtext1 = wa_output-vtext1.
    ls_final-dis_rate = wa_output-dis_rate.
    ls_final-dis_amt = wa_output-dis_amt.
    ls_final-dis_unit_rate = wa_output-dis_unit_rate.

    ls_final-cust_mat_code = wa_output-cust_mat_code.          "+++002
    """"""" endded """""""""""""""""""

    APPEND ls_final TO gt_final.
    CLEAR:
      ls_final,wa_output.     "ADDED BY AAKASHK 03.10.2024
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down_set_all TABLES it_output USING p_folder. .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).
  PERFORM new_file_1 TABLES it_output."ADDED BY JYOTI ON 26.04.2024
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_output_new "added by jyoti on 26.04.2024
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  IF p_hidden IS INITIAL OR p_hidden = 'Task 1'.
*  IF P_HIDDEN IS INITIAL .
  PERFORM cvs_header USING hd_csv.
*  ENDIF.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZDELPENDSOALL.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZDELPENDSO Download started on', sy-datum, 'at', sy-uzeit.
  IF open_so IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.


*  IF p_hidden IS INITIAL OR p_hidden = 'Task 1'.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. "MESSAGE LV_MSG.  "NON-UNICODE.
  IF sy-subrc = 0.
*    DATA LV_STRING_1364 TYPE STRING.
*    DATA LV_CRLF_1364 TYPE STRING.
*    LV_CRLF_1364 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
*    LV_STRING_1364 = HD_CSV.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT IT_CSV INTO WA_CSV.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.

*      CONCATENATE LV_STRING_1364 LV_CRLF_1364 WA_CSV INTO LV_STRING_1364.
*      CLEAR: WA_CSV.
*    ENDLOOP.
*  ENDIF.
*  TRANSFER LV_STRING_1364 TO LV_FULLFILE.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.
*
      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
***  ELSE.
***
***    DATA lv_string_1379 TYPE string.
***    DATA lv_crlf_1379 TYPE string.
***
***    OPEN DATASET lv_fullfile
***     FOR APPENDING IN TEXT MODE ENCODING DEFAULT MESSAGE lv_msg.
***
***    IF sy-subrc = 0.
***      lv_crlf_1379 = cl_abap_char_utilities=>cr_lf.
***      DESCRIBE TABLE it_csv LINES DATA(lv_linetem).
***      LOOP AT it_csv INTO wa_csv.
***        IF lv_linetem > 1.
***          IF sy-tabix = 1.
***            lv_string_1379 = wa_csv.
***          ELSE.
***            CONCATENATE lv_string_1379 lv_crlf_1379 wa_csv INTO lv_string_1379.
***          ENDIF.
***
***        ELSE.
***          CONCATENATE  wa_csv lv_crlf_1379 INTO lv_string_1379.
***          lv_string_1379 =  wa_csv.
***        ENDIF.
***        CLEAR: wa_csv.
***      ENDLOOP.
***    ENDIF.
***    TRANSFER lv_string_1379 TO lv_fullfile.

*  ENDIF.

*  CLOSE DATASET LV_FULLFILE.

******************************************************new file zpendso **********************************
  PERFORM new_file TABLES it_output.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


*  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Task 1'.
*  IF P_HIDDEN IS INITIAL  .
  PERFORM cvs_header USING hd_csv.
*  ENDIF.

**lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZDELPENDSOALL.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
*  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Task 1'.
*  DATA LV_STRING_1365 TYPE STRING.
*  DATA LV_CRLF_1365 TYPE STRING.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "MESSAGE LV_MSG.  "NON-UNICODE. "NON-UNICODE.
*  IF SY-SUBRC = 0.
**    CLEAR: LV_STRING_1365  ,LV_CRLF_1365  .
**    LV_CRLF_1365 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
**    LV_STRING_1365 = HD_CSV.
*    LOOP AT IT_CSV INTO WA_CSV.
*      CONCATENATE LV_STRING_1365 LV_CRLF_1365 WA_CSV INTO LV_STRING_1365.
*      CLEAR: WA_CSV.
*    ENDLOOP.
*  ENDIF.

*ELSE.
*  OPEN DATASET LV_FULLFILE
*  FOR APPENDING IN TEXT MODE ENCODING DEFAULT MESSAGE LV_MSG.
  IF sy-subrc = 0.
*    LV_CRLF_1365 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
*    DESCRIBE TABLE IT_CSV LINES DATA(LV_LINETEM22).
*    LOOP AT IT_CSV INTO WA_CSV.
*      IF LV_LINETEM22 > 1.
*        IF SY-TABIX = 1.
*          LV_STRING_1365 = WA_CSV.
*        ELSE.
*          CONCATENATE LV_STRING_1365 LV_CRLF_1365 WA_CSV INTO LV_STRING_1365.
*        ENDIF.
*
*      ELSE.
*        CONCATENATE  WA_CSV LV_CRLF_1365 INTO LV_STRING_1365.
*        LV_STRING_1365 =  WA_CSV.
*      ENDIF.
*      CLEAR: WA_CSV.
*    ENDLOOP.
*  ENDIF.
*  TRANSFER LV_STRING_1365 TO LV_FULLFILE.
*    CLOSE DATASET lv_fullfile.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.
*
      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*  CLOSE DATASET LV_FULLFILE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM new_file_1 TABLES it_output.
  "added by jyoti on 26.04.2024 for date refreshable file ****************************
  LOOP AT it_output INTO wa_output.
    wa_output_new-werks       = wa_output-werks.
    wa_output_new-auart       = wa_output-auart.
    wa_output_new-bstkd       = wa_output-bstkd.
    wa_output_new-name1       = wa_output-name1.
    wa_output_new-vkbur       = wa_output-vkbur.
    wa_output_new-vbeln       = wa_output-vbeln.
    wa_output_new-status      = wa_output-status.
    wa_output_new-tag_req     = wa_output-tag_req.
    wa_output_new-tpi         = wa_output-tpi.
    wa_output_new-ld_txt      = wa_output-ld_txt.
    wa_output_new-zldperweek  = wa_output-zldperweek.
    wa_output_new-zldmax      = wa_output-zldmax.
    wa_output_new-matnr       = wa_output-matnr.
    wa_output_new-posnr       = wa_output-posnr.
    wa_output_new-arktx       = wa_output-arktx.
    wa_output_new-stock_qty   = abs( wa_output-stock_qty ).
    wa_output_new-kwmeng      = abs( wa_output-kwmeng ).
    wa_output_new-lfimg       = abs( wa_output-lfimg ).
    wa_output_new-fkimg       = abs( wa_output-fkimg ).
    wa_output_new-pnd_qty     = abs( wa_output-pnd_qty ).
    wa_output_new-ettyp       = wa_output-ettyp.
    wa_output_new-kbetr       = wa_output-kbetr.
    wa_output_new-waerk       = wa_output-waerk.
    wa_output_new-curr_con    = wa_output-curr_con.
    wa_output_new-amont       = abs( wa_output-amont ).
    wa_output_new-ordr_amt    = abs( wa_output-ordr_amt ).
    wa_output_new-in_price    = abs( wa_output-in_price ).
    wa_output_new-est_cost    = abs( wa_output-est_cost ).
    wa_output_new-latst_cost  = abs( wa_output-latst_cost ).
    wa_output_new-st_cost     = abs( wa_output-st_cost ).
    wa_output_new-zseries     = wa_output-zseries.
    wa_output_new-zsize       = wa_output-zsize.
    wa_output_new-brand       = wa_output-brand.
    wa_output_new-moc         = wa_output-moc.
    wa_output_new-type        = wa_output-type.
    wa_output_new-dispo       = wa_output-dispo.
    wa_output_new-wip         = wa_output-wip.
    wa_output_new-mtart       = wa_output-mtart.
    wa_output_new-kdmat       = wa_output-kdmat.
    wa_output_new-kunnr       = wa_output-kunnr.
    wa_output_new-qmqty       = abs( wa_output-qmqty ).
    wa_output_new-mattxt      = wa_output-mattxt.
    wa_output_new-us_cust      = wa_output-us_cust.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN wa_output_new-mattxt WITH ' & '.
    wa_output_new-itmtxt      = wa_output-itmtxt.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN wa_output_new-itmtxt WITH ' & '.
    wa_output_new-etenr       = wa_output-etenr.
    wa_output_new-schid       = wa_output-schid.
    wa_output_new-so_exc      = wa_output-so_exc.
    wa_output_new-zterm       = wa_output-zterm.
    wa_output_new-text1       = wa_output-text1.
    wa_output_new-inco1       = wa_output-inco1.
    wa_output_new-inco2       = wa_output-inco2.
    wa_output_new-ofm         = wa_output-ofm.
    wa_output_new-ofm_date    = wa_output-ofm_date.
    wa_output_new-spl         = wa_output-spl.
    wa_output_new-wrkst       = wa_output-wrkst.
    wa_output_new-abgru       = wa_output-abgru.
    wa_output_new-bezei       = wa_output-bezei.
    wa_output_new-cgst        = wa_output-cgst.
    IF  wa_output_new-cgst IS INITIAL .
      CONCATENATE  '0'  wa_output_new-cgst INTO  wa_output_new-cgst.
    ENDIF.
    wa_output_new-sgst        = wa_output-sgst.
    IF  wa_output_new-sgst IS INITIAL .
      CONCATENATE  '0'  wa_output_new-sgst INTO  wa_output_new-sgst.
    ENDIF.
    wa_output_new-igst        = wa_output-igst.
    IF  wa_output_new-igst IS INITIAL .
      CONCATENATE  '0'  wa_output_new-igst INTO  wa_output_new-igst.
    ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
    wa_output_new-ship_kunnr    = wa_output-ship_kunnr.
    wa_output_new-ship_kunnr_n  = wa_output-ship_kunnr_n.
    wa_output_new-ship_reg_n    = wa_output-ship_reg_n.
    wa_output_new-sold_reg_n    = wa_output-sold_reg_n.
    wa_output_new-ship_land     = wa_output-ship_land.
    wa_output_new-s_land_desc   = wa_output-s_land_desc.
    wa_output_new-sold_land     =  wa_output-sold_land.
*    wa_output_new-normt          = wa_output-normt.
    wa_output_new-posex          = wa_output-posex.

    wa_output_new-lifsk          = wa_output-lifsk.
    wa_output_new-vtext          = wa_output-vtext.
    wa_output_new-insur          = wa_output-insur .
    wa_output_new-pardel         = wa_output-pardel.
    wa_output_new-gad            = wa_output-gad.
    wa_output_new-tcs            = wa_output-tcs.
    wa_output_new-tcs_amt        = wa_output-tcs_amt.
    wa_output_new-special_comm   = wa_output-special_comm.

    wa_output_new-ctbg          = wa_output-ctbg.
    wa_output_new-certif         = wa_output-certif.
    wa_output_new-vkorg         = wa_output-vkorg.           "ADDED BY AAKASHK 19.08.2024 EVNG
    wa_output_new-vtweg         = wa_output-vtweg.           "ADDED BY AAKASHK 19.08.2024 EVNG
    wa_output_new-spart         = wa_output-spart.           "ADDED BY AAKASHK 19.08.2024 EVNG
    wa_output_new-kurst         = wa_output-kurst.
*    ls_final-ctbg         = wa_output-ctbg.

    wa_output_new-bstdk     = wa_output-bstdk.
    wa_output_new-erdat     = wa_output-erdat.
    wa_output_new-vdatu     = wa_output-vdatu.
    wa_output_new-holddate  = wa_output-holddate.
    wa_output_new-reldate   = wa_output-reldate.
    wa_output_new-canceldate  = wa_output-canceldate.
    wa_output_new-deldate   = wa_output-deldate.
    wa_output_new-custdeldate = wa_output-custdeldate.
    wa_output_new-po_del_date  = wa_output-po_del_date.
    wa_output_new-zldfromdate = wa_output-zldfromdate.
    wa_output_new-mrp_dt    = wa_output-mrp_dt.
    wa_output_new-edatu     = wa_output-edatu.
    wa_output_new-in_pr_dt  = wa_output-in_pr_dt.
    wa_output_new-ref_dt    = wa_output-ref_dt.
    wa_output_new-zmrp_date = wa_output-zmrp_date.
    wa_output_new-zexp_mrp_date1 = wa_output-zexp_mrp_date1.

    wa_output_new-ofm_no = wa_output-ofm_no .

    CONDENSE  wa_output_new-kwmeng.
    IF wa_output-kwmeng < 0.
      CONCATENATE '-'  wa_output_new-kwmeng INTO  wa_output_new-kwmeng.
    ENDIF.

    CONDENSE  wa_output_new-lfimg.
    IF wa_output-lfimg < 0.
      CONCATENATE '-'  wa_output_new-lfimg INTO wa_output_new-lfimg.
    ENDIF.

    CONDENSE  wa_output_new-fkimg.
    IF wa_output-fkimg < 0.
      CONCATENATE '-'wa_output_new-fkimg INTO wa_output_new-fkimg.
    ENDIF.

    CONDENSE wa_output_new-pnd_qty.
    IF wa_output-pnd_qty < 0.
      CONCATENATE '-' wa_output_new-pnd_qty INTO wa_output_new-pnd_qty.
    ENDIF.

    CONDENSE wa_output_new-qmqty.
    IF wa_output-qmqty < 0.
      CONCATENATE '-' wa_output_new-qmqty INTO wa_output_new-qmqty.
    ENDIF.

    CONDENSE wa_output_new-kbetr.
    IF wa_output-kbetr < 0.
      CONCATENATE '-' wa_output_new-kbetr INTO wa_output_new-kbetr.
    ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

    CONDENSE wa_output_new-amont.
    IF wa_output-amont < 0.
      CONCATENATE '-' wa_output_new-amont INTO wa_output_new-amont.
    ENDIF.

    CONDENSE wa_output_new-ordr_amt.
    IF wa_output-ordr_amt < 0.
      CONCATENATE '-' wa_output_new-ordr_amt INTO wa_output_new-ordr_amt.
    ENDIF.


    CONDENSE wa_output_new-in_price.
    IF wa_output-in_price < 0.
      CONCATENATE '-' wa_output_new-in_price INTO wa_output_new-in_price.
    ENDIF.

    CONDENSE wa_output_new-est_cost.
    IF wa_output-est_cost < 0.
      CONCATENATE '-' wa_output_new-est_cost INTO wa_output_new-est_cost.
    ENDIF.

    CONDENSE wa_output_new-latst_cost.
    IF wa_output-latst_cost < 0.
      CONCATENATE '-' wa_output_new-latst_cost INTO wa_output_new-latst_cost.
    ENDIF.

    CONDENSE wa_output_new-st_cost.
    IF wa_output-st_cost < 0.
      CONCATENATE '-' wa_output_new-st_cost INTO wa_output_new-st_cost.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
    wa_output_new-item_type         = wa_output-item_type. "edited by PJ on 16-08-21
    wa_output_new-ref_time          = wa_output-ref_time. "edited by PJ on 08-09-21

    """""""""code added by pankaj 28.01.2022"""""""""""""""""""""""""""""""""""

    wa_output_new-proj          = wa_output-proj .
    wa_output_new-cond          = wa_output-cond .
    wa_output_new-receipt_date  = wa_output-receipt_date .

    wa_output_new-reason    = wa_output-reason.
    wa_output_new-ntgew     = wa_output-ntgew.
    wa_output_new-zpr0      = wa_output-zpr0.
    wa_output_new-zpf0      = wa_output-zpf0.
    wa_output_new-zin1      = wa_output-zin1.
    wa_output_new-zin2      = wa_output-zin2.
    wa_output_new-joig      = wa_output-joig.
    wa_output_new-jocg      = wa_output-jocg.
    wa_output_new-josg      = wa_output-josg.

    wa_output_new-date         = wa_output-date.
    wa_output_new-prsdt        = wa_output-prsdt.
    wa_output_new-packing_type = wa_output-packing_type.
    wa_output_new-ofm_date1 = wa_output-ofm_date1.

    wa_output_new-mat_text = wa_output-mat_text.

    """"""" code added by pankaj 31.01.2022"""""""""

    wa_output_new-infra        = wa_output-infra.
    wa_output_new-validation   = wa_output-validation.
    wa_output_new-review_date  = wa_output-review_date.

    wa_output_new-review_date   = wa_output-review_date.
    wa_output_new-diss_summary  = wa_output-diss_summary .
    wa_output_new-chang_so_date = wa_output-chang_so_date .

    """""""""""""" code added by pankaj 04.02.2022

    wa_output_new-port      = wa_output-port .
    wa_output_new-full_pmnt = wa_output-full_pmnt .
    wa_output_new-act_ass   = wa_output-act_ass .
    wa_output_new-txt04     = wa_output-txt04 .
    wa_output_new-freight  = wa_output-freight.
    " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
    wa_output_new-po_sr_no = wa_output-po_sr_no.
    wa_output_new-udate = wa_output-udate.
    wa_output_new-bom = wa_output-bom.
    wa_output_new-zpen_item = wa_output-zpen_item.
    wa_output_new-zre_pen_item = wa_output-zre_pen_item.
    wa_output_new-zins_loc = wa_output-zins_loc. "ADDED BY PRIMUS MA
    wa_output_new-bom_exist = wa_output-bom_exist. "ADDED BY PRIMUS MA
    wa_output_new-posex1         = wa_output-posex.
    wa_output_new-lgort        = wa_output-lgort."added by jyoti on 11.06.2024
    wa_output_new-quota_ref        = wa_output-quota_ref."added by jyoti on 19.06.2024
    wa_output_new-zcust_proj_name = wa_output-zcust_proj_name."Added by jyoti
*    ls_final-vtext1 = wa_output-vtext1.
    wa_output_new-po_dis = wa_output-po_dis.    """ ADDED BY SUPRIYA 19.08.2024
    wa_output_new-amendment_his = wa_output-amendment_his.    """ ADDED BY SUPRIYA 19.08.2024
    wa_output_new-zhold_reason_n1 = wa_output-zhold_reason_n1.    """ ADDED BY SUPRIYA 19.08.2024
    wa_output_new-stock_qty_ktpi = wa_output-stock_qty_ktpi.
    wa_output_new-stock_qty_tpi1 = wa_output-stock_qty_tpi1.
    wa_output_new-ofm_rec_date = wa_output-ofm_rec_date.
    wa_output_new-oss_rec_date = wa_output-oss_rec_date.
    wa_output_new-source_rest = wa_output-source_rest.
    wa_output_new-suppl_rest = wa_output-suppl_rest.
    wa_output_new-cust_mat_desc = wa_output-cust_mat_desc.
    IF wa_output-dis_rate < 0 .
      disamt2 =  wa_output-dis_rate * ( -1 ).
      CONCATENATE '-' disamt2 INTO wa_output_new-dis_rate .
    ELSE.
      wa_output_new-dis_rate = wa_output-dis_rate.
    ENDIF.
*    WA_OUTPUT_NEW-DIS_RATE = WA_OUTPUT-DIS_RATE.
    IF wa_output-dis_amt < 0.
      CONDENSE wa_output-dis_amt.
      CONCATENATE '-' wa_output-dis_amt INTO wa_output-dis_amt.
    ENDIF.
    wa_output_new-dis_amt = wa_output-dis_amt.
    wa_output_new-dis_unit_rate = wa_output-dis_unit_rate.

    wa_output_new-cust_mat_code = wa_output-cust_mat_code.          "+++002
    """"""" endded """""""""""""""""""

    APPEND wa_output_new TO it_output_new.
    CLEAR: wa_output_new,wa_output.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form read_item_text
*&---------------------------------------------------------------------*
*& Below routine was created part of Mod id 0002 JIRA CAMS100-29732
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM read_item_text USING VALUE(pu_id) TYPE tdid
                          VALUE(pu_obj)
                          VALUE(pu_name)
                    CHANGING pc_text.
  DATA: lv_id    TYPE tdid,
        lv_obj   TYPE tdobject,
        lv_name  TYPE tdobname,
        lt_lines TYPE STANDARD TABLE OF tline,
        lv_str   TYPE string.

  lv_id = pu_id.
  lv_obj = pu_obj.
  lv_name = pu_name.
  CLEAR: lv_str, lt_lines, pc_text.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
*     id                      = 'Z110'
      id                      = lv_id
      language                = sy-langu
      name                    = lv_name
*     object                  = 'VBBP'
      object                  = lv_obj
    TABLES
      lines                   = lt_lines
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
  ENDIF.
  IF NOT lt_lines IS INITIAL.
    LOOP AT lt_lines INTO DATA(ls_lines).
      IF NOT ls_lines-tdline IS INITIAL.
        CONCATENATE lv_str ls_lines-tdline INTO lv_str SEPARATED BY space.
      ENDIF.
    ENDLOOP.
    CONDENSE lv_str.
  ENDIF.
  pc_text = lv_str.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form change_Date_format
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <F1>_AEDAT1
*&      <-- <F1>_UDATE
*&---------------------------------------------------------------------*
FORM change_Date_format  USING    pu_date TYPE sy-datum
                         CHANGING pc_udate TYPE char11.
  DATA: lv_date TYPE sy-datum.

  lv_date = pu_date.
  CLEAR: pc_udate.
  IF lv_Date = '00000000' OR lv_date IS INITIAL.
    RETURN.
  ENDIF.

  CHECK lv_date IS NOT INITIAL.
* To get in DDMMMYY format
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input  = lv_date
    IMPORTING
      output = pc_udate.

* To get in DD-MMM-YYYY format
  CONCATENATE  pc_udate+0(2)  pc_udate+2(3)  pc_udate+5(4)
                 INTO  pc_udate SEPARATED BY '-'.

  IF pc_udate = '--'.
    REPLACE ALL OCCURRENCES OF '--' IN pc_udate WITH ' '.
  ENDIF.
ENDFORM.
