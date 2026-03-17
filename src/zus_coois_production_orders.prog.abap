*&---------------------------------------------------------------------*
*& REPORT ZUS_COOIS_PRODUCTION_ORDERS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_coois_production_orders NO STANDARD PAGE HEADING.
***************************************************

*&---------------------------------------------------------------------*
*&
* 1.PROGRAM OWNER           : PRIMUS TECHSYSTEMS PVT LTD.
* 2.PROJECT                 : PRODUCTION ORDERS REPORT DEVLOPMENT
* 3.PROGRAM NAME            : ZUS_COOIS_PRODUCTION_ORDERS
* 4.TRANS CODE              : ZUS_COOIS
* 5.MODULE NAME             : PP
* 6.REQUEST NO              :
* 7.CREATION DATE           : 18.09.2024
* 8.CREATED BY              : SUPRIYA JAGTAP
* 9.FUNCTIONAL CONSULTANT   : ASHISH KATHAR
* 10.BUSINESS OWNER         : DELVAL USA .
*&---------------------------------------------------------------------*
***************************************************
TYPE-POOLS : slis.

TABLES : afpo,
         mara,
         caufv,
         vbak,
         afko,
         tj48t,
         tj02t,
         makt,
         bsvx,
         coep.

TYPES : BEGIN OF ty_mara ,        "OCCURS 0,
          matnr   TYPE mara-matnr,
          ersda   TYPE mara-ersda,
          zseries TYPE mara-zseries,                         "ADDED BY AAKASHK
          zsize   TYPE mara-zsize,
          mtart   TYPE mara-mtart,
          brand   TYPE mara-brand,
        END OF ty_mara.

TYPES : BEGIN OF ty_caufv,
          aufnr  TYPE caufv-aufnr,
          erdat  TYPE caufv-erdat,                "CHAR11,
          plnbez TYPE caufv-plnbez,
          werks  TYPE caufv-werks,
          dispo  TYPE caufv-dispo,
          fevor  TYPE caufv-fevor,
          auart  TYPE caufv-auart,
          gamng  TYPE caufv-gamng,
          ernam  TYPE caufv-ernam,                 " ADDED BY SAURABH ON 4/9/2024
          objnr  TYPE caufv-objnr,
          gstrp  TYPE  caufv-gstrp,              "ADDED BY AAKASHK 19.08.2024
        END OF ty_caufv.

TYPES : BEGIN OF ty_afpo, ",
          aufnr  TYPE afpo-aufnr,
          projn  TYPE afpo-projn, " 8
          kdauf  TYPE afpo-kdauf, "12
          kdpos  TYPE afpo-kdpos, "13
          pwerk  TYPE afpo-pwerk, "37
          verid  TYPE afpo-verid, "44
          kunnr2 TYPE afpo-kunnr2, " 94
          dwerk  TYPE afpo-dwerk,
          matnr  TYPE afpo-matnr,                "ADDED BY AAKASHK
        END OF ty_afpo.

TYPES : BEGIN OF ty_afko ,
          aufnr    TYPE afko-aufnr,
          gltrp    TYPE afko-gltrp, "4
          gstrp    TYPE afko-gstrp, "5
          plnbez   TYPE afko-plnbez,
          aprio    TYPE afko-aprio, "51
          cy_seqnr TYPE afko-cy_seqnr, "110
          igmng    TYPE afko-igmng,                "ADDED BY AAKASHK
          getri    TYPE afko-getri,                 "ADDED BY AAKASHK
        END OF ty_afko.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          auart TYPE vbak-auart,
        END OF ty_vbak.

TYPES : BEGIN OF ty_tj48t,
          spras TYPE tj48t-spras,
          selid TYPE tj48t-selid,
        END OF ty_tj48t.

TYPES : BEGIN OF ty_tj02t,
          istat TYPE tj02t-istat,
          spras TYPE tj02t-spras,
        END OF ty_tj02t.

TYPES : BEGIN OF ty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
          spras TYPE makt-spras,
        END OF ty_makt.

TYPES : BEGIN OF ty_aufk,
          aufnr TYPE aufk-aufnr,
          loekz TYPE aufk-loekz,
          ktext TYPE aufk-ktext,
        END OF ty_aufk.

TYPES : BEGIN OF ty_coep,
          objnr  TYPE coep-objnr,
          wtgbtr TYPE coep-wtgbtr,
        END OF ty_coep.

TYPES : BEGIN OF ty_final,
          aufnr    TYPE afpo-aufnr, "1
          erdat    TYPE char15,
*          kdauf    TYPE afpo-kdauf, "3   " COMMENT BY SUPRIYA ON 05.11.2024
*          kdpos    TYPE afpo-kdpos, "4   " COMMENTED BY SUPRIYA ON 05.11.2024
          auart    TYPE caufv-auart, "5
          matnr    TYPE afpo-matnr, "6
          maktx    TYPE makt-maktx, "7
          gamng    TYPE caufv-gamng, "8
          igmng    TYPE afko-igmng,  "9
          getri    TYPE char15,                 "afko-getri, "12  "add bysupriya on 16.10.2024
          loekz    TYPE aufk-loekz, "13
          ktext    TYPE aufk-ktext, "14
          istat    TYPE tj02t-istat, "     "ADDED BY AAKASHK 19.08.2024
          sttxt    TYPE string,      "      "ADDED BY AAKASHK 19.08.2024
          projn    TYPE afpo-projn,
          pwerk    TYPE afpo-pwerk,
          verid    TYPE afpo-verid,
          kunnr2   TYPE afpo-kunnr2,
          dwerk    TYPE afpo-dwerk,
          gltrp    TYPE char11,
          zseries  TYPE mara-zseries,            "ADDED BY AAKASHK
          zsize    TYPE mara-zsize,
          mtart    TYPE mara-mtart,
          brand    TYPE mara-brand,
          plnbez   TYPE caufv-plnbez,
          werks    TYPE caufv-werks,
          dispo    TYPE caufv-dispo,
          fevor    TYPE caufv-fevor,
          aprio    TYPE afko-aprio,
          cy_seqnr TYPE afko-cy_seqnr,
          vbeln    TYPE vbak-vbeln,
          spras    TYPE tj48t-spras,
          selid    TYPE tj48t-selid,
          txt04    TYPE string,                     "ADD BY SUPRIYA ON 21.08.2024
          ernam    TYPE caufv-ernam,
          wtgbtr   TYPE char16, "coep-wtgbtr,                   "ADDED BY SAURABH ON 4/9/2024
          CSONO    TYPE char40,
        END OF ty_final.

TYPES : BEGIN OF ty_down,
          ref_on   TYPE char15,                     "ADDED BY AAKASHK 19.08.2024
          aufnr    TYPE afpo-aufnr, "1
          erdat    TYPE  string,
*          kdauf    TYPE afpo-kdauf, "3    " COMMENTED BY SUPRIYA ON 05.11.2024
*          kdpos    TYPE string, "4       " COMMENTED BY SUPRIYA ON 05.11.2024
          auart    TYPE caufv-auart, "5
          plnbez   TYPE caufv-plnbez,
          maktx    TYPE makt-maktx, "7
          gamng    TYPE string, "CAUFV-GAMNG, "8
          igmng    TYPE string, "AFKO-IGMNG,  "9
          getri    TYPE string, "char11,   "add by supriya on 16.10.2024             "AFKO-GETRI, "12
          loekz    TYPE aufk-loekz, "13
          zseries  TYPE mara-zseries,            "ADDED BY AAKASHK
          zsize    TYPE mara-zsize,
          mtart    TYPE mara-mtart,
          brand    TYPE mara-brand,
          dwerk    TYPE afpo-dwerk,  "ADD BY SUPRIYA ON 21.08.2024
          txt04    TYPE string,          "ADD BY SUPRIYA ON 23.08.2024
*          ref_time type char15,        "ADD BY SUPRIYA ON 23.08.2024
          ernam    TYPE caufv-ernam,      "ADDED BY SAURABH ON 4/9/2024
          wtgbtr   TYPE char16,         "coep-wtgbtr,
          CSONO    TYPE char40,
          ref_time TYPE char15,        "ADD BY SUPRIYA ON 23.08.2024
        END OF ty_down.

TYPES : BEGIN OF ty_down12,
          aufnr  TYPE caufv-aufnr,
          wtgbtr TYPE coep-wtgbtr,
        END OF ty_down12.

DATA : it_down12 TYPE TABLE OF ty_down12,
       wa_down12 TYPE ty_down12.

DATA : it_caufv    TYPE TABLE OF ty_caufv,
       wa_caufv    TYPE ty_caufv,
       it_afpo     TYPE TABLE OF ty_afpo,
       wa_afpo     TYPE ty_afpo,
       it_afko     TYPE TABLE OF ty_afko,
       wa_afko     TYPE  ty_afko,
       it_vbak     TYPE TABLE OF ty_vbak,
       wa_vbak     TYPE ty_vbak,
       it_tj02t    TYPE TABLE OF ty_tj02t,
       wa_tj02t    TYPE ty_tj02t,
       it_tj48t    TYPE TABLE OF ty_tj48t,
       wa_tj48t    TYPE ty_tj48t,
       it_mara     TYPE TABLE OF ty_mara,
       wa_mara     TYPE ty_mara,
       it_makt     TYPE TABLE OF ty_makt,
       wa_makt     TYPE ty_makt,
       it_aufk     TYPE TABLE OF ty_aufk,
       wa_aufk     TYPE ty_aufk,
       it_final    TYPE TABLE OF ty_final,
       wa_final    TYPE ty_final,
       lt_fieldcat TYPE slis_t_fieldcat_alv,
       ls_fieldcat TYPE slis_fieldcat_alv,
       it_coep     TYPE TABLE OF ty_coep,
       wa_coep     TYPE ty_coep.

DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE          ty_down.

DATA : it_data TYPE TABLE OF ty_final,
       wa_data TYPE ty_final.

DATA:
  lv_objnr        TYPE caufv-objnr,
  object_tab      TYPE bsvx,
  lv_total_issued TYPE mseg-menge.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline.

SELECTION-SCREEN :BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_aufnr FOR afpo-aufnr,
                 s_matnr FOR mara-matnr ,
                 s_werks FOR caufv-werks MODIF ID bu,
*                 s_auart for caufv-auart ,"DEFAULT'URAW',"no-display,
                 s_objnr FOR caufv-objnr NO-DISPLAY,
                 s_kdauf FOR afpo-kdauf NO-DISPLAY ,
                 s_kdpos FOR afpo-kdpos NO-DISPLAY ,
                 s_istat FOR tj02t-istat NO-DISPLAY,
*                 s_erdat FOR caufv-erdat,
                 s_gltrp FOR afko-gltrp NO-DISPLAY,
                 s_gstrp FOR caufv-gstrp.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002.
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/DELVAL/USA'.
        " 'E:\DELVAL\USA'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

INITIALIZATION.

  s_werks-sign = 'I'.
  s_werks-option = 'BT'.
  s_werks-low = 'US01'.
  s_werks-high = 'US03'.

  APPEND s_werks.

  CLEAR s_werks.

*at selection-screen.
*if s_werks = 'x'.
*   s_werks = '0'.
*    MODIFY SCREEN.
*  ENDIF.
*loop at s_erdat .
*if s_erdat-high is initial.
*message 'Posting Date is require' type 'E'.
*endif.
*endloop.

AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-name EQ 'S_WERKS'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.

  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


START-OF-SELECTION.

  PERFORM get_data1.
*&---------------------------------------------------------------------*
*&      FORM  GET_DATA1
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM get_data1.

  SELECT aufnr
         projn
         kdauf
         kdpos
         pwerk
         verid
         kunnr2
         matnr
         dwerk
*        GETRI                         "ADDED BY AAKASHK
*        IGMNG
    FROM afpo
         INTO CORRESPONDING FIELDS OF TABLE it_afpo
         WHERE aufnr IN s_aufnr
         AND dwerk IN s_werks
*        and dwerk ='US01'
         AND matnr IN s_matnr.
  DELETE it_afpo WHERE ( dwerk = 'PL01' OR dwerk = 'SU01').

  IF it_afpo IS NOT INITIAL.
    SELECT aufnr
           gltrp
           aprio
           plnbez
           igmng                         "ADDED BY AAKASHK
           getri                         "ADDED BY AAKASHK
           FROM afko
           INTO CORRESPONDING FIELDS OF TABLE it_afko
           FOR ALL ENTRIES IN it_afpo[]
           WHERE aufnr = it_afpo-aufnr AND
                 gltrp IN s_gltrp .                 " AND PLNBEZ = IT_AFPO-MATNR.           " AND SPRAS = SY-LANGU.
  ENDIF.

  SELECT aufnr
         erdat
         objnr            "ADDED BY AAKASHK 19.08.2024
         plnbez
         werks
         dispo
         fevor
         gamng                               "ADDED BY AAKASHK
         auart
         ernam
         gstrp FROM caufv                     ""ADDED BY SAURABH ON 4/9/2024
         INTO CORRESPONDING FIELDS OF TABLE it_caufv
         FOR ALL ENTRIES IN it_afpo[]
         WHERE aufnr = it_afpo-aufnr
              AND gstrp IN s_gstrp
*         AND erdat IN s_erdat
    AND auart = 'UREW'
    AND werks = it_afpo-dwerk.

  DELETE it_caufv WHERE ( werks = 'PL01' OR werks = 'SU01').

  DATA: lt_aufnr TYPE RANGE OF aufnr.

  lt_aufnr = VALUE #( BASE lt_aufnr FOR ls_caufv IN it_caufv ( sign   = 'I'
                                                               option = 'EQ'
                                                               low    = ls_caufv-aufnr ) ).
  SORT lt_aufnr BY low ASCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_aufnr COMPARING low.

  DELETE it_afpo WHERE aufnr NOT IN lt_aufnr.

  IF NOT it_afpo IS INITIAL.
    SELECT matnr
*     ersda
       zseries                                      "ADDED BY AAKASHK
       zsize
       mtart
       brand
  FROM mara INTO CORRESPONDING FIELDS OF TABLE it_mara
  FOR ALL ENTRIES IN it_afpo
  WHERE matnr = it_afpo-matnr.

    SELECT matnr
           spras
           maktx FROM makt
           INTO CORRESPONDING FIELDS OF TABLE it_makt
           FOR ALL ENTRIES IN it_afpo
           WHERE matnr = it_afpo-matnr AND spras = sy-langu.

    SELECT aufnr
           werks   " ADD BY SUPRIYA ON 11.09.2024
           loekz                                         "ADDED BY AAKASHK
           ktext
      FROM aufk INTO CORRESPONDING FIELDS OF TABLE it_aufk
      FOR ALL ENTRIES IN it_afpo[]
      WHERE aufnr = it_afpo-aufnr.   "AND werks in ('US01','US02','US03').
  ENDIF.
  IF it_caufv IS NOT INITIAL.

    SELECT vbeln
           auart
       FROM vbak INTO TABLE it_vbak
      FOR ALL ENTRIES IN it_caufv WHERE auart = it_caufv-auart.     "ADDED BY AAKASHK


    SELECT objnr, erdat, aufnr
           FROM caufv
           INTO TABLE @DATA(it_caufv_new)
           FOR ALL ENTRIES IN @it_caufv
           WHERE aufnr = @it_caufv-aufnr.

    SELECT caufv~aufnr,
           coep~objnr,
           coep~wtgbtr,
           coep~buzei,
           coep~belnr
      FROM caufv
      INNER JOIN coep
      ON caufv~objnr = coep~objnr
      FOR ALL ENTRIES IN @it_caufv
      WHERE caufv~aufnr = @it_caufv-aufnr
      INTO TABLE @DATA(it_result).

    LOOP AT it_result INTO DATA(wa_result).
      ON CHANGE OF wa_result-aufnr.
        LOOP AT it_result INTO wa_result WHERE aufnr = wa_result-aufnr.
          wa_down12-wtgbtr = wa_result-wtgbtr + wa_down12-wtgbtr.
        ENDLOOP.
        wa_down12-aufnr = wa_result-aufnr.
        APPEND wa_down12 TO it_down12.
        CLEAR wa_down12.
      ENDON.
    ENDLOOP.

  ENDIF.

  LOOP AT it_afpo INTO wa_afpo.
*    wa_final-aufnr = wa_afpo-aufnr.                                "ADDED BY AAKASHK
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = wa_afpo-aufnr
      IMPORTING
        output = wa_final-aufnr.

    wa_final-projn = wa_afpo-projn.
*    wa_final-kdauf = wa_afpo-kdauf.    " COMMENTED BY SUPRIYA ON 05.11.2024
*    wa_final-kdpos = wa_afpo-kdpos.   " COMMENTED BY SUPRIYA ON 05.11.2024
    wa_final-pwerk = wa_afpo-pwerk.
    wa_final-verid = wa_afpo-verid.
    wa_final-kunnr2 = wa_afpo-kunnr2.
    wa_final-matnr =  wa_afpo-matnr.
    wa_final-dwerk =  wa_afpo-dwerk.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_afpo-matnr.
*   WA_FINAL-MATNR  = WA_MARA-MATNR.
    IF sy-subrc = 0.
      wa_final-zseries = wa_mara-zseries.                                      "ADDED BY AAKASHK
      wa_final-zsize  = wa_mara-zsize.
      wa_final-mtart = wa_mara-mtart.
      wa_final-brand = wa_mara-brand.
    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_afpo-matnr.
    IF sy-subrc = 0.
      wa_final-spras = wa_makt-spras.
      wa_final-maktx = wa_makt-maktx.
    ENDIF.

    READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_afpo-aufnr.       "ADDED BY AAKASHK
    IF wa_afko-gltrp IS NOT INITIAL.
      DATA lv_gltrp TYPE char11.

      CONCATENATE wa_afko-gltrp+4(2) wa_afko-gltrp+6(2) wa_afko-gltrp+0(4)
                     INTO lv_gltrp SEPARATED BY '.'.

      wa_final-gltrp = lv_gltrp.
    ENDIF.

    wa_final-aprio = wa_afko-aprio.
    wa_final-plnbez = wa_afko-plnbez.
    wa_final-igmng = wa_afko-igmng.

    DATA lv_getri TYPE char11.
    IF wa_afko-getri IS NOT INITIAL.
      CONCATENATE wa_afko-getri+4(2) wa_afko-getri+6(2) wa_afko-getri+0(4)
      INTO lv_getri SEPARATED BY '.'.
****************************************
 ELSE.                                                                          "added by aakashk 16.10.2024
    CLEAR lv_getri.  " Set to empty if GETRI is not present                      "added by aakashk 16.10.2024
******************************************
    ENDIF.

    IF lv_getri = '..'.
      CLEAR lv_getri.
    ENDIF.

    wa_final-getri = lv_getri.
    READ TABLE it_caufv INTO wa_caufv WITH KEY aufnr = wa_afpo-aufnr.    "ADDED BY AAKASHK
    IF sy-subrc = 0.

      DATA lv_erdat TYPE caufv-erdat.
      wa_final-plnbez = wa_caufv-plnbez.
      wa_final-werks = wa_caufv-werks.
      wa_final-dispo = wa_caufv-dispo.
      wa_final-fevor = wa_caufv-fevor.
      wa_final-gamng = wa_caufv-gamng.
      wa_final-auart = wa_caufv-auart.
      wa_final-ernam = wa_caufv-ernam.
    ENDIF.
    READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_afpo-aufnr.      "ADDED BY AAKASHK
    IF sy-subrc = 0.
      wa_final-loekz = wa_aufk-loekz.
      wa_final-ktext = wa_aufk-ktext.
    ENDIF.

    READ TABLE it_vbak INTO wa_vbak WITH KEY auart = wa_caufv-auart.
    IF sy-subrc = 0.
      wa_final-vbeln = wa_vbak-vbeln.
    ENDIF.



    DATA: lv_objnr TYPE caufv-objnr.
    DATA :  object_tab-sttxt TYPE bsvx-sttxt.

    READ TABLE it_caufv_new INTO DATA(wa_caufv_new) WITH KEY aufnr = wa_afpo-aufnr.
    IF  sy-subrc = 0.
      lv_objnr = wa_caufv_new-objnr.
    ENDIF.

    CALL FUNCTION 'STATUS_TEXT_EDIT'
      EXPORTING
        client           = sy-mandt
*       FLG_USER_STAT    = 'X'
        objnr            = lv_objnr
        only_active      = 'X'
        spras            = sy-langu
      IMPORTING
        line             = object_tab-sttxt
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.
    wa_final-txt04 = object_tab-sttxt.


*     data lv_erdat type caufv-erdat.
    CONCATENATE wa_caufv-erdat+4(2) wa_caufv-erdat+6(2) wa_caufv-erdat+0(4)
                 INTO wa_final-erdat  SEPARATED BY '.'.

    READ TABLE it_down12 INTO wa_down12 WITH KEY aufnr = wa_afpo-aufnr.
    IF sy-subrc = 0.
      wa_final-wtgbtr = wa_down12-wtgbtr.
    ENDIF.

    """"""""""""""""""""""""""
          REFRESH lv_lines.
      CONCATENATE SY-MANDT wa_afpo-aufnr INTO LV_NAME.
*      lv_name = wa_final-aufnr.
*break primusabap.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'KOPF'
          language                = sy-langu
          name                    = lv_name
          object                  = 'AUFK'
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

      IF NOT lv_lines IS INITIAL.                  "added by supriya 26.06.2024
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE wa_final-CSONO wa_lines-tdline INTO wa_final-CSONO SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE wa_final-CSONO.
      ENDIF.
    """"""""""""""""""""""""""


*  MODIFY IT_FINAL FROM WA_FINAL .
    IF wa_caufv-erdat IS NOT INITIAL.
      APPEND wa_final TO it_final.
      CLEAR : wa_final, wa_afko."."wa_coep-wtgbtr.             "wa_afko added by aakashk 16.10.2024
    ENDIF.
  ENDLOOP.
*endif.
***************************************************************************
  IF p_down EQ 'X'.              " add by supriya on 23.08.2024

    LOOP AT it_final INTO wa_final.


      wa_down-ref_on = sy-datum.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_on.
      CONCATENATE wa_down-ref_on+0(2) wa_down-ref_on+2(3) wa_down-ref_on+5(4)
                      INTO wa_down-ref_on SEPARATED BY '-'.
      wa_down-aufnr   =  wa_final-aufnr    .

*      wa_down-erdat   =   lv_erdat "WA_FINAL-ERDAT  .

*  data lv_erdat type caufv-erdat.
      DATA lv_erdat1 TYPE string.
      lv_erdat1 = wa_final-erdat.

      CONCATENATE lv_erdat1+6(4) lv_erdat1+0(2) lv_erdat1+3(2)
                      INTO lv_erdat1." SEPARATED BY ''.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = lv_erdat1
        IMPORTING
          output = wa_down-erdat.

      IF wa_down-erdat IS NOT INITIAL.
        CONCATENATE wa_down-erdat+0(2) wa_down-erdat+2(3) wa_down-erdat+5(4)
                        INTO wa_down-erdat SEPARATED BY '-'.
      ENDIF.

*      wa_down-kdauf   =  wa_final-kdauf    .
*      IF  wa_down-kdpos IS NOT INITIAL.
*        wa_down-kdpos   =  wa_final-kdpos    .
*      ENDIF.
      wa_down-dwerk   =  wa_final-dwerk    .
      wa_down-zseries =  wa_final-zseries  .
      wa_down-zsize   =  wa_final-zsize    .
      wa_down-mtart   =  wa_final-mtart    .
      wa_down-brand   =  wa_final-brand    .
      wa_down-maktx   =  wa_final-maktx    .
*     WA_DOWN-GSTRP   =  WA_FINAL-GSTRP    .

      wa_down-plnbez  = wa_final-plnbez    .
      wa_down-igmng  = wa_final-igmng.
*     WA_DOWN-GETRI   = WA_FINAL-GETRI     .  "KDPOS
      wa_down-gamng   = wa_final-gamng     .

      wa_down-auart   = wa_final-auart     .
      wa_down-loekz   =  wa_final-loekz     .
*     WA_DOWN-KTEXT   =  WA_FINAL-KTEXT     .
      wa_down-txt04   =  wa_final-txt04   .
*      wa_down-ref_time = sy-uzeit.
      wa_down-ernam   = wa_final-ernam     .                                    "ADDED BY SAURABH ON 4/9/2024
      wa_down-csono   = wa_final-csono.
*      wa_down-getri = lv_getri.

*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = lv_getri
*        IMPORTING
*          output = wa_final-getri.
*
*      IF wa_final-getri IS  INITIAL.
*        CONCATENATE wa_down-getri+0(2) wa_down-getri+2(3) wa_down-getri+5(4)
*                        INTO wa_down-getri SEPARATED BY '-'.
************************************************************************
DATA lv_getri1 TYPE string.
DATA lv_length TYPE i.                                                          "added by by aakashk 16.10.2024

if wa_final-getri is not initial.
      lv_getri1 = wa_final-getri.
endif.

lv_length = STRLEN( lv_getri1 ).                                          "added by by aakashk 16.10.2024

IF lv_length >= 6.
  IF lv_length >= 10.                                                       "added by by aakashk 16.10.2024
* IF sy-subrc = 0.                                                            "commented  by aakashk 16.10.2024
CONCATENATE lv_getri1+6(4) lv_getri1+0(2) lv_getri1+3(2)
                      INTO lv_getri1.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT' " add by supriya on 16.10.2024
        EXPORTING
          input  = lv_getri1
        IMPORTING
          output = wa_down-getri.

      IF wa_down-getri IS NOT INITIAL.                                 "added by by aakashk 16.10.2024
    lv_length = STRLEN( wa_down-getri ).

IF lv_length >= 8.                                                         "added by by aakashk 16.10.2024

      IF wa_down-getri IS NOT INITIAL.
        CONCATENATE wa_down-getri+0(2) wa_down-getri+2(3) wa_down-getri+5(4)
                        INTO wa_down-getri SEPARATED BY '-'.

        ENDIF.                                                              "added by by aakashk 16.10.2024
  ENDIF.                                                                    "added by by aakashk 16.10.2024
ENDIF.                                                                        "added by by aakashk 16.10.2024
ENDIF.                                                                        "added by by aakashk 16.10.2024
**********************************************************************************

*       IF wa_down-getri = '--.'.
*      CLEAR wa_down-getri.
*    ENDIF.

endif.

*endloop.                      "added by aakashk 16.10.2024******************************************************comm

*      ENDIF.   ***********************************com


*data : value(5) type c.
      IF wa_final-wtgbtr < 0.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = wa_final-wtgbtr.
      ENDIF.
*      if wa_final-wtgbtr is not initial.
      wa_down-wtgbtr  = wa_final-wtgbtr.
*      endif.
      wa_down-ref_time = sy-uzeit.
      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

      APPEND wa_down TO it_down.  "ENDADD.
      CLEAR WA_DOWN.
    ENDLOOP.      "commented by aakashk 16.10.2024      **************************************************uncomm
  ENDIF.         "commented by aakashk 16.10.2024

*************** ADD BY SUPRIYA ON 21.08.2024

  ls_fieldcat-col_pos = 1.
  ls_fieldcat-fieldname = 'AUFNR'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'ORDER'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 2.
  ls_fieldcat-fieldname = 'ERDAT'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'CREATED ON'.
  APPEND ls_fieldcat TO lt_fieldcat.

*  ls_fieldcat-col_pos = 3.
*  ls_fieldcat-fieldname = 'KDAUF'.
*  ls_fieldcat-tabname = 'IT_FINAL'.
*  ls_fieldcat-seltext_m = 'SALES ORDER'.
*  APPEND ls_fieldcat TO lt_fieldcat.

*  ls_fieldcat-col_pos = 4.
*  ls_fieldcat-fieldname = 'KDPOS'.
*  ls_fieldcat-tabname = 'IT_FINAL'.
*  ls_fieldcat-seltext_m = 'SO ITEM'.
*  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 3.
  ls_fieldcat-fieldname = 'AUART'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'ORDER TYPE'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 4.
  ls_fieldcat-fieldname = 'PLNBEZ'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'MATERIAL NUMBER'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 5.   "ADD BY SUPRIYA ON 22-08-2024
  ls_fieldcat-fieldname = 'MAKTX'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'MATERIAL DESCRIPTION'.
  APPEND ls_fieldcat TO lt_fieldcat.

  " ADD BY SUPRIYA ON 22-08-2024
  ls_fieldcat-col_pos = 6.
  ls_fieldcat-fieldname = 'GAMNG'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'ORDER QUANTITY'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 7.
  ls_fieldcat-fieldname = 'IGMNG'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'CONFIRMED QUANTITY'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 8.
  ls_fieldcat-fieldname = 'GETRI'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'CONFIRMED FINISH DATE'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 9.
  ls_fieldcat-fieldname = 'LOEKZ'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'DELETION FLAG'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 10.
  ls_fieldcat-fieldname = 'ZSERIES'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'SERIES'.
  APPEND ls_fieldcat TO lt_fieldcat.


  ls_fieldcat-col_pos = 11.
  ls_fieldcat-fieldname = 'ZSIZE'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'SIZE'.
  APPEND ls_fieldcat TO lt_fieldcat.

*  CLEAR LS_FIELDCAT.
  ls_fieldcat-col_pos = 12.
  ls_fieldcat-fieldname = 'MTART'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'MATERIAL TYPE'.
  APPEND ls_fieldcat TO lt_fieldcat.

*  CLEAR LS_FIELDCAT.
  ls_fieldcat-col_pos = 13.
  ls_fieldcat-fieldname = 'BRAND'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'BRAND'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 14.
  ls_fieldcat-fieldname = 'DWERK'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'PLANT'.
*  LS_FIELDCAT-KEY = 'X'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 15.
  ls_fieldcat-fieldname = 'TXT04' .
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m =  'SYSTEM STATUS' .
*  LS_FIELDCAT-KEY = 'X'.
  APPEND ls_fieldcat TO lt_fieldcat.

**********ADDED BY SAURABH ON 4/9/2024*****************
  ls_fieldcat-col_pos = 16.
  ls_fieldcat-fieldname = 'ERNAM'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'CREATED BY'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-col_pos = 17.
  ls_fieldcat-fieldname = 'WTGBTR'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'TOTAL ACTUAL COSTS'.
  APPEND ls_fieldcat TO lt_fieldcat.

    ls_fieldcat-col_pos = 18.
  ls_fieldcat-fieldname = 'CSONO'.
  ls_fieldcat-tabname = 'IT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer SO NO./Name'.
  APPEND ls_fieldcat TO lt_fieldcat.

*******************************************************
  CLEAR ls_fieldcat .
**********************************************************


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = 'SY-REPID '
      it_fieldcat        = lt_fieldcat
*     I_CALLBACK_TOP_OF_PAGE           = 'TOP-OF-PAGE'
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
  ENDIF.
*endif.                                                                               "ADDED BY AAKASHK 16.10.2024
ENDFORM.
*************************************************************************************************
*&---------------------------------------------------------------------*           "ADDED BY AAKASHK 19.08.2024
*&      FORM  DOWNLOAD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: LV_FOLDER(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).


*   PERFORM NEW_FILE.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

  PERFORM cvs_header USING hd_csv. " add by supriya on 21.08.2024

  lv_file = 'ZUS_COOIS.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_COOIS.TXT DOWNLOAD STARTED ON', sy-datum, 'AT', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_939 TYPE string.
DATA lv_crlf_939 TYPE string.
lv_crlf_939 = cl_abap_char_utilities=>cr_lf.
lv_string_939 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_939 lv_crlf_939 wa_csv INTO lv_string_939.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_939 TO lv_fullfile.
    CLOSE DATASET lv_fullfile.
    CONCATENATE 'FILE' lv_fullfile 'DOWNLOADED' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  CVS_HEADER
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_HD_CSV  TEXT
*----------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.   " ADD BY SUPRIYA ON 21.08.2024
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'REFRESHED DATE'
              'ORDER'
              'CREATED ON'
*              'SALES ORDER'
*              'SO ITEM'
              'ORDER TYPE'
              'MATERIAL NUMBER'
              'MATERIAL DESCRIPTION'
              'ORDER QUANTITY'
              'CONFIRMED QUANTITY'
              'CONFIRMED FINISH DATE'
              'DELETION FLAG'
              'SERIES'
              'SIZE'
              'MATERIAL TYPE'
              'BRAND'
              'PLANT'
              'SYSTEM STATUS'
*              'REFRESHED.TIME'
              'CREATED BY'                                         "ADDED BY SAURABH ON 4.9.2024
              'TOTAL ACTUAL COSTS'
              'Customer SO NO./Name'
               'REFRESHED.TIME'
    INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  NEW_FILE
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM NEW_FILE .
* FORM TOP-OF-PAGE.
*
**  ALV Header declarations
*  DATA: T_HEADER      TYPE SLIS_T_LISTHEADER,
*        WA_HEADER     TYPE SLIS_LISTHEADER,
*        T_LINE        LIKE WA_HEADER-INFO,
*        LD_LINES      TYPE I,
*        LD_LINESC(10) TYPE C.
*
**  Title
*  WA_HEADER-TYP  = 'H'.
*  WA_HEADER-INFO = 'Production Orders Report'.
*  APPEND WA_HEADER TO T_HEADER.
*  CLEAR WA_HEADER.

*
**  Date
*  WA_HEADER-TYP  = 'S'.
*  WA_HEADER-KEY  = 'Run Date : '.
*  CONCATENATE WA_HEADER-INFO SY-DATUM+6(2) '.' SY-DATUM+4(2) '.'
*                      SY-DATUM(4) INTO WA_HEADER-INFO.
*  APPEND WA_HEADER TO T_HEADER.
*  CLEAR: WA_HEADER.
*
**  Time
*  WA_HEADER-TYP  = 'S'.
*  WA_HEADER-KEY  = 'Run Time: '.
*  CONCATENATE WA_HEADER-INFO SY-TIMLO(2) ':' SY-TIMLO+2(2) ':'
*                      SY-TIMLO+4(2) INTO WA_HEADER-INFO.
*  APPEND WA_HEADER TO T_HEADER.
*  CLEAR: WA_HEADER.
*
**   Total No. of Records Selected
*  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
*  LD_LINESC = LD_LINES.
*
*  CONCATENATE 'Total No. of Records Selected: ' LD_LINESC
*     INTO T_LINE SEPARATED BY SPACE.
*
*  WA_HEADER-TYP  = 'A'.
*  WA_HEADER-INFO = T_LINE.
*  APPEND WA_HEADER TO T_HEADER.
*  CLEAR: WA_HEADER, T_LINE.
*
*  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
*    EXPORTING
*      IT_LIST_COMMENTARY = T_HEADER.
*ENDFORM.                    " top-of-page
*
**ENDFORM.
