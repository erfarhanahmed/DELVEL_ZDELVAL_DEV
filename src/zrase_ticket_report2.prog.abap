REPORT zrase_ticket_report2.
************************************************************************
* Developed by          : Primus Techsoftsoln
* PROGRAM TYPE          : Report
* PACKAGE               : ZPRIMUS
* PROGRAM TITLE         : Standard Costing Report
* PROGRAM NAME          : ZRASE_TICKET_REPORT2
* Technical Consultant  : Sagar dev
* Transaction Code      : ZSCR
* Transport Request     : DEVK904264
*----------------------------------------------------------------------*
******************************************************************************

TYPE-POOLS : slis.
TABLES : keko,keph,ckis,tckh2,tckh3.
TABLES : stpox, cscmat.

DATA: i_stpo TYPE STANDARD TABLE OF stpo INITIAL SIZE 10 WITH HEADER LINE.

DATA: i_stpox TYPE STANDARD TABLE OF stpox INITIAL SIZE 10 WITH HEADER LINE.
DATA: w_stpox TYPE stpox.
DATA: i_csxequi TYPE STANDARD TABLE OF csxequi INITIAL SIZE 10 WITH HEADER LINE.
DATA: i_csxtpl TYPE STANDARD TABLE OF csxtpl INITIAL SIZE 10 WITH HEADER LINE.
DATA: i_csxmat TYPE STANDARD TABLE OF csxmat INITIAL SIZE 10 WITH HEADER LINE.
DATA: i_csxdoc TYPE STANDARD TABLE OF csxdoc INITIAL SIZE 10 WITH HEADER LINE.
DATA: i_csxgen TYPE STANDARD TABLE OF csxgen INITIAL SIZE 10 WITH HEADER LINE.
DATA: i_csxkla TYPE STANDARD TABLE OF csxkla INITIAL SIZE 10 WITH HEADER LINE.

TYPES : BEGIN OF ty_keko,
          kalnr   TYPE keko-kalnr,
          kalka   TYPE keko-kalka,
          kadky   TYPE keko-kadky,
          tvers   TYPE keko-tvers,
          bwvar   TYPE keko-bwvar,
          matnr   TYPE keko-matnr,
          werks   TYPE keko-werks,
          bdatj   TYPE keko-bdatj,
          poper   TYPE keko-poper,
          bwkey   TYPE keko-bwkey,
          kokrs   TYPE keko-kokrs,
          kadat   TYPE keko-kadat,
          bidat   TYPE keko-bidat,
          bwdat   TYPE keko-bwdat,
          aldat   TYPE keko-aldat,
          stnum   TYPE keko-stnum,
          plnnr   TYPE keko-plnnr,
          loekz   TYPE keko-loekz,
          losgr   TYPE keko-losgr,
          erfnm   TYPE keko-erfnm,
          cpudt   TYPE keko-cpudt,
          feh_sta TYPE keko-feh_sta,
          freig   TYPE keko-freig,
          sobes   TYPE keko-sobes,
          kalsm   TYPE keko-kalsm,
          klvar   TYPE keko-klvar,
          beskz   TYPE keko-beskz,
        END OF ty_keko.

TYPES : BEGIN OF ty_keko2,
          kalnr   TYPE keko-kalnr,
          kalka   TYPE keko-kalka,
          kadky   TYPE keko-kadky,
          tvers   TYPE keko-tvers,
          bwvar   TYPE keko-bwvar,
          matnr   TYPE keko-matnr,
          werks   TYPE keko-werks,
          bdatj   TYPE keko-bdatj,
          poper   TYPE keko-poper,
          bwkey   TYPE keko-bwkey,
          kokrs   TYPE keko-kokrs,
          kadat   TYPE keko-kadat,
          bidat   TYPE keko-bidat,
          bwdat   TYPE keko-bwdat,
          aldat   TYPE keko-aldat,
          stnum   TYPE keko-stnum,
          plnnr   TYPE keko-plnnr,
          loekz   TYPE keko-loekz,
          losgr   TYPE keko-losgr,
          erfnm   TYPE keko-erfnm,
          cpudt   TYPE keko-cpudt,
          feh_sta TYPE keko-feh_sta,
          freig   TYPE keko-freig,
          sobes   TYPE keko-sobes,
          kalsm   TYPE keko-kalsm,
          klvar   TYPE keko-klvar,
          beskz   TYPE keko-beskz,
        END OF ty_keko2.

TYPES : BEGIN OF TY_KEPH,
        KALNR TYPE  KEPH-KALNR,
        KALKA TYPE  KEPH-KALKA,
        KADKY TYPE  KEPH-KADKY,
        TVERS TYPE  KEPH-TVERS,
        BWVAR TYPE  KEPH-BWVAR,
        KKZST TYPE  KEPH-KKZST,
        KST001 TYPE KEPH-KST001,
        KST003 TYPE KEPH-KST003,
        KST005 TYPE KEPH-KST005,
        KST007 TYPE KEPH-KST007,
        KST009 TYPE KEPH-KST009,
        KST011 TYPE KEPH-KST011,
        KST013 TYPE KEPH-KST013,
        KST015 TYPE KEPH-KST015,
        KST017 TYPE KEPH-KST017,
        END OF TY_KEPH.

TYPES : BEGIN OF ty_ckis,
          kalnr TYPE ckis-kalnr,
          kalka TYPE ckis-kalka,
          kadky TYPE ckis-kadky,
          typps TYPE ckis-typps,
          kstar TYPE ckis-kstar,
          werks TYPE ckis-werks,
          matnr TYPE ckis-matnr,
          pmeht TYPE ckis-pmeht,
          menge TYPE ckis-menge,
          meeht TYPE ckis-meeht,
          prctr TYPE ckis-prctr,
          wertn TYPE ckis-wertn,
        END OF ty_ckis.

TYPES : BEGIN OF ty_mbew,
          matnr TYPE mbew-matnr,
          bwkey TYPE mbew-bwkey,
          vprsv TYPE mbew-vprsv,
          verpr TYPE mbew-verpr,
          stprs TYPE mbew-stprs,
        END OF   ty_mbew.

TYPES : BEGIN OF ty_tckh2,
          elehk TYPE tckh2-elehk,
          kstav TYPE tckh2-kstav,
          kstab TYPE tckh2-kstab,
          elemt TYPE tckh2-elemt,
        END OF   ty_tckh2.

TYPES : BEGIN OF ty_tckh1,
          spras TYPE tckh1-spras,
          elehk TYPE tckh1-elehk,
          elemt TYPE tckh1-elemt,
          txele TYPE tckh1-txele,
        END OF   ty_tckh1.


TYPES : BEGIN OF ty_mara,
          matnr TYPE mara-matnr,
          mtart TYPE mara-mtart,
        END OF   ty_mara.

TYPES : BEGIN OF ty_final,
          kalnr    TYPE keko-kalnr,
          kalka    TYPE keko-kalka,
          kadky    TYPE keko-kadky,
          tvers    TYPE keko-tvers,
          bwvar    TYPE keko-bwvar,
          matnr    TYPE keko-matnr,
          werks    TYPE keko-werks,
          bwkey    TYPE keko-bwkey,
          kokrs    TYPE keko-kokrs,
          kadat    TYPE keko-kadat,
          bidat    TYPE keko-bidat,
          bwdat    TYPE keko-bwdat,
          aldat    TYPE keko-aldat,
          stnum    TYPE keko-stnum,
          plnnr    TYPE keko-plnnr,
          loekz    TYPE keko-loekz,
          losgr    TYPE keko-losgr,
          erfnm    TYPE keko-erfnm,
          cpudt    TYPE keko-cpudt,
          feh_sta  TYPE keko-feh_sta,
          freig    TYPE keko-freig,
          sobes    TYPE keko-sobes,
          kalsm    TYPE keko-kalsm,
          klvar    TYPE keko-klvar,
          poper    TYPE keko-poper,
          bdatj    TYPE keko-bdatj,
          beskz    TYPE keko-beskz,
          kkzst    TYPE keph-kkzst,
          kst001   TYPE keph-kst001,
          kst002   TYPE keph-kst002,
          kst003   TYPE keph-kst003,
          kst004   TYPE keph-kst004,
          kst005   TYPE keph-kst005,
          kst006   TYPE keph-kst006,
          kst007   TYPE keph-kst007,
          kst008   TYPE keph-kst008,
          kst009   TYPE keph-kst009,
          vprsv    TYPE mbew-vprsv,
          verpr    TYPE mbew-verpr,
          stprs    TYPE mbew-stprs,
          mtart    TYPE mara-mtart,
          tot_cost TYPE kbetr,
        END OF ty_final.

Data:  gv_bdatj   TYPE keko-bdatj,
       gv_poper   TYPE keko-poper.

DATA : lt_keko   TYPE TABLE OF ty_keko,
       ls_keko   TYPE          ty_keko,
       LT_KEPH   TYPE TABLE OF TY_KEPH,
       LS_KEPH   TYPE          TY_KEPH,
       lt_keko2  TYPE TABLE OF ty_keko2 WITH HEADER LINE,
       ls_keko2  TYPE          ty_keko2,
       lt_keko3  TYPE TABLE OF ty_keko2 WITH HEADER LINE,
       ls_keko3  TYPE          ty_keko2,
       lt_keko4  TYPE TABLE OF ty_keko2 WITH HEADER LINE,
       ls_keko4  TYPE          ty_keko2,
       lt_ckis   TYPE TABLE OF ty_ckis,
       ls_ckis   TYPE          ty_ckis,
       lt_tckh2  TYPE TABLE OF ty_tckh2 WITH HEADER LINE,
       ls_tckh2  TYPE          ty_tckh2,
       lt_tckh1  TYPE TABLE OF ty_tckh1,
       ls_tckh1  TYPE          ty_tckh1,
       lt_mbew   TYPE TABLE OF ty_mbew,
       ls_mbew   TYPE          ty_mbew,
       lt_mara   TYPE TABLE OF ty_mara,
       ls_mara   TYPE          ty_mara,
       lt_final  TYPE TABLE OF ty_final,
       ls_final  TYPE          ty_final.


DATA : kst015(13)  TYPE p DECIMALS 2.
DATA : kst014(13)  TYPE p DECIMALS 2.
"data declaration
DATA : BEGIN OF itab OCCURS 0.
    INCLUDE STRUCTURE i_stpox.
DATA : END OF itab.

DATA : BEGIN OF itab2 OCCURS 0.
    INCLUDE STRUCTURE i_stpox.
DATA : END OF itab2.
*INTERNAL TABLE FOR FIELC CATALOG
DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
*INTERNAL TABLE FOR SORTING
DATA : t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.
DATA : w_tabname TYPE slis_tabname,
       icx       TYPE sytabix.
DATA : fs_layout TYPE slis_layout_alv.
DATA it_matcat TYPE STANDARD TABLE OF cscmat WITH HEADER LINE.
DATA : it_header TYPE slis_t_listheader,
       wa_header LIKE LINE OF it_header.

DATA : it_event TYPE slis_t_event,
       wa_event LIKE LINE OF it_event.
""""""""""""""""""""SELECTION SCREEN"""""""""""""""""""""
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_matnr FOR keko-matnr,
                 s_werks FOR keko-werks,
                 s_poper FOR keko-poper,
                 s_bdatj FOR keko-bdatj,
                 s_feh   FOR keko-feh_sta,
                 s_freig FOR keko-freig.
SELECTION-SCREEN : END OF BLOCK b1.

"""""""""""""""""end of selection screen""""""""""""""""""""""""

PERFORM fetch_data.
PERFORM fieldcatlog.
PERFORM display.
PERFORM get_event.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .
  SELECT  kalnr
          kalka
          kadky
          tvers
          bwvar
          matnr
          werks
          bdatj
          poper
          bwkey
          kokrs
          kadat
          bidat
          bwdat
          aldat
          stnum
          plnnr
          loekz
          losgr
          erfnm
          cpudt
          feh_sta
          freig
          sobes
          kalsm
          klvar
          beskz
          FROM keko
          INTO TABLE lt_keko
          WHERE matnr IN s_matnr
          AND werks IN s_werks
          AND poper IN s_poper
          AND bdatj IN s_bdatj
          AND feh_sta IN s_feh
          AND freig IN s_freig.

  IF lt_keko IS NOT INITIAL.

  SELECT KALNR
         KALKA
         KADKY
         TVERS
         BWVAR
         KKZST
         KST001
         KST003
         KST005
         KST007
         KST009
         KST011
         KST013
         KST015
         KST017
         FROM KEPH
         INTO TABLE LT_KEPH
         FOR ALL ENTRIES IN LT_KEKO
         WHERE KALNR = LT_KEKO-KALNR
         AND KALKA = LT_KEKO-KALKA
         AND KADKY = LT_KEKO-KADKY
         AND TVERS = LT_KEKO-TVERS
         AND BWVAR = LT_KEKO-BWVAR
         AND KKZST = ''.

    SELECT matnr
           bwkey
           vprsv
           verpr
           stprs
           FROM mbew
           INTO TABLE lt_mbew
           FOR ALL ENTRIES IN lt_keko
           WHERE matnr = lt_keko-matnr
           AND bwkey = lt_keko-bwkey.

    SELECT matnr
           mtart
           FROM mara
           INTO TABLE lt_mara
           FOR ALL ENTRIES IN lt_keko
           WHERE matnr = lt_keko-matnr.

  ENDIF.

  LOOP AT lt_keko INTO ls_keko.

    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
*       FTREL  = ' '
*       ALEKZ  = ' '
*       ALTVO  = ' '
*       AUFSW  = ' '
*       AUMGB  = ' '
*       AUMNG  =
*       AUSKZ  = ' '
*       AMIND  = ' '
*       BAGRP  = ' '
*       BEIKZ  = ' '
*       BESSL  = ' '
*       BGIXO  = ' '
*       BREMS  = ' '
        capid  = ' '
*       CHLST  = ' '
*       COSPR  = ' '
*       CUOBJ  = 000000000000000
*       CUOVS  = 0
*       CUOLS  = ' '
        datuv  = ls_keko-kadky
*       DELNL  = ' '
*       DRLDT  = ' '
*       EHNDL  = ' '
*       EMENG  = REQ_QNT
*       ERSKZ  = ' '
*       ERSSL  = ' '
*       FBSTP  = ' '
*       KNFBA  = ' '
*       KSBVO  = ' '
*       MBWLS  = ' '
        mktls  = 'X'
*       MDMPS  = ' '
        mehrs  = '1'
*       MKMAT  = ' '
*       MMAPS  = ' '
*       SALWW  = ' '
*       SPLWW  = ' '
        mmory  = '1'
        mtnrv  = ls_keko-matnr
*       NLINK  = ' '
*       POSTP  = ' '
*       RNDKZ  = ' '
*       RVREL  = ' '
*       SANFR  = ' '
*       SANIN  = ' '
*       SANKA  = ' '
*       SANKO  = ' '
*       SANVS  = ' '
*       SCHGT  = ' '
*       STKKZ  = ' '
*       STLAL  = ' '
        stlan  = '1'
*       STPST  = 0
        svwvo  = 'X'
        werks  = ls_keko-werks
*       NORVL  = ' '
*       MDNOT  = ' '
*       PANOT  = ' '
*       QVERW  = ' '
*       VERID  = ' '
        vrsvo  = 'X'
* IMPORTING
*       TOPMAT = TOPMAT
*       DSTST  = DSTST
      TABLES
        stb    = i_stpox
        matcat = it_matcat
 EXCEPTIONS
   ALT_NOT_FOUND               = 1
   CALL_INVALID                = 2
   MATERIAL_NOT_FOUND          = 3
   MISSING_AUTHORIZATION       = 4
   NO_BOM_FOUND                = 5
   NO_PLANT_DATA               = 6
   NO_SUITABLE_BOM_FOUND       = 7
   CONVERSION_ERROR            = 8
          .

   IF SY-SUBRC = 0.
    LS_FINAL-KALNR  = LS_KEKO-KALNR .
    LS_FINAL-KALKA  = LS_KEKO-KALKA.
    LS_FINAL-KADKY  = LS_KEKO-KADKY .
    ls_final-matnr  = ls_keko-matnr.
    ls_final-werks  = ls_keko-werks .
    ls_final-bwkey  = ls_keko-bwkey  .
    ls_final-kokrs  = ls_keko-kokrs  .
    ls_final-kadat  = ls_keko-kadat  .
    ls_final-bidat  = ls_keko-bidat  .
    ls_final-bwdat  = ls_keko-bwdat  .
    ls_final-aldat  = ls_keko-aldat  .
    ls_final-stnum  = ls_keko-stnum  .
    ls_final-plnnr  = ls_keko-plnnr  .
    ls_final-loekz  = ls_keko-loekz  .
    ls_final-losgr  = ls_keko-losgr  .
    ls_final-erfnm  = ls_keko-erfnm  .
    ls_final-cpudt  = ls_keko-cpudt  .
    ls_final-feh_sta = ls_keko-feh_sta.
    ls_final-freig  = ls_keko-freig  .
    ls_final-sobes  = ls_keko-sobes  .
    ls_final-kalsm  = ls_keko-kalsm  .
    ls_final-klvar  = ls_keko-klvar  .
    ls_final-poper  = ls_keko-poper  .
    ls_final-bdatj  = ls_keko-bdatj  .
    ls_final-beskz  = ls_keko-beskz  .

    READ TABLE LT_KEPH INTO LS_KEPH WITH  KEY  KALNR = LS_FINAL-KALNR KALKA = LS_FINAL-KALKA KADKY = LS_FINAL-KADKY.
    IF SY-SUBRC = 0.
        LS_FINAL-KALNR  = LS_KEPH-KALNR .
        LS_FINAL-KALKA  = LS_KEPH-KALKA.
        LS_FINAL-KADKY  = LS_KEPH-KADKY .
        LS_FINAL-TVERS  = LS_KEPH-TVERS.
        LS_FINAL-BWVAR  = LS_KEPH-BWVAR.
        LS_FINAL-KKZST  = LS_KEPH-KKZST.
        LS_FINAL-kst002 = LS_KEPH-KST003 .
        LS_FINAL-KST003 = LS_KEPH-KST005 .
        LS_FINAL-KST004 = LS_KEPH-KST007 .
        LS_FINAL-KST005 = LS_KEPH-KST009 .
        LS_FINAL-KST006 = LS_KEPH-KST011 .
        LS_FINAL-KST007 = LS_KEPH-KST013 .
        LS_FINAL-KST008 = LS_KEPH-KST015.

    ENDIF.
    READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_final-matnr bwkey = ls_final-bwkey.
    ls_final-vprsv = ls_mbew-vprsv.
    ls_final-verpr = ls_mbew-verpr.
    ls_final-stprs = ls_mbew-stprs.

    READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_final-matnr.
    ls_final-mtart = ls_mara-mtart.



  SELECT  kalnr
          kalka
          kadky
          tvers
          bwvar
          matnr
          werks
          bdatj
          poper
          bwkey
          kokrs
          kadat
          bidat
          bwdat
          aldat
          stnum
          plnnr
          loekz
          losgr
          erfnm
          cpudt
          feh_sta
          freig
          sobes
          kalsm
          klvar
          beskz
          FROM keko
          INTO TABLE lt_keko2
          FOR ALL ENTRIES IN i_stpox
           WHERE matnr EQ  i_stpox-idnrk
           and poper eq ls_keko-poper
           and bdatj eq ls_keko-bdatj.


    gv_poper  = ls_keko-poper - 1.
    gv_bdatj  = ls_keko-bdatj .
    IF ls_keko-poper = '001'.
    gv_poper  = '012'.
    gv_bdatj  = ls_keko-bdatj - 1.
    ENDIF.

IF ls_keko-bdatj = gv_bdatj.
  SELECT  kalnr
          kalka
          kadky
          tvers
          bwvar
          matnr
          werks
          bdatj
          poper
          bwkey
          kokrs
          kadat
          bidat
          bwdat
          aldat
          stnum
          plnnr
          loekz
          losgr
          erfnm
          cpudt
          feh_sta
          freig
          sobes
          kalsm
          klvar
          beskz
          FROM keko
          INTO TABLE lt_keko4
          FOR ALL ENTRIES IN i_stpox
           WHERE matnr EQ  i_stpox-idnrk
           and poper eq gv_poper
           and bdatj eq gv_bdatj.
ENDIF.
  LOOP AT lt_keko4.
    MOVE-CORRESPONDING lt_keko4 TO lt_keko2.
    APPEND lt_keko2.
  ENDLOOP.

  SELECT  kalnr
          kalka
          kadky
          tvers
          bwvar
          matnr
          werks
          bdatj
          poper
          bwkey
          kokrs
          kadat
          bidat
          bwdat
          aldat
          stnum
          plnnr
          loekz
          losgr
          erfnm
          cpudt
          feh_sta
          freig
          sobes
          kalsm
          klvar
          beskz
          FROM keko
          INTO TABLE lt_keko3
           WHERE matnr EQ  ls_keko-MATNR
           and poper eq ls_keko-poper
           and bdatj eq ls_keko-bdatj.

  LOOP AT lt_keko3.
    MOVE-CORRESPONDING lt_keko3 TO lt_keko2.
    APPEND lt_keko2.
  ENDLOOP.



    SELECT kalnr kalka kadky typps kstar werks matnr pmeht menge meeht prctr wertn
           FROM ckis INTO CORRESPONDING FIELDS OF TABLE lt_ckis FOR ALL ENTRIES IN lt_keko2
           WHERE KALNR EQ  lt_keko2-KALNR
           AND kadky   EQ  lt_keko2-kadky.
*           AND TYPPS   NE 'M'.

    LOOP AT lt_ckis INTO ls_ckis.
      READ TABLE i_stpox INTO w_stpox WITH KEY idnrk = ls_ckis-matnr.
      IF sy-subrc = 0.
        SELECT elehk kstav kstab elemt FROM tckh2 INTO TABLE lt_tckh2 WHERE kstav <=  ls_ckis-kstar AND kstab >= ls_ckis-kstar
               AND elehk EQ 'D1'.
        IF sy-subrc = 0.
          LOOP AT lt_tckh2 INTO ls_tckh2.
            IF ls_tckh2-elemt = '001' . "Material Cost
              IF ls_ckis-typps = 'I'.
                kst015 = ls_ckis-wertn / ls_ckis-menge .
                kst014 = kst015 * w_stpox-mnglg.
                ls_final-kst001 = ls_final-kst001 + kst014.
              ELSE.
                IF ls_ckis-typps NE 'M'.
                  ls_final-kst001 =  ls_final-kst001 + ls_ckis-wertn.
                ENDIF.
              ENDIF.
            ENDIF.
*            IF ls_tckh2-elemt = '002' . "Machine Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst002 =  ls_final-kst002 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '003' . "Labour Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst003 =  ls_final-kst003 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '004' . "Power Consumption
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst004 =  ls_final-kst004 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '005' . "Process Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst005 =  ls_final-kst005 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '006' . "Dressing
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst006 =  ls_final-kst006 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '007' . "Fuel Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst007 =  ls_final-kst007 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '008' . "PRODUCTION OH
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst008 =  ls_final-kst008 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
            IF ls_tckh2-elemt = '009' . "Subcontracting Cost
              IF ls_ckis-typps NE 'M'.
                ls_final-kst009 =  ls_final-kst009 + ls_ckis-wertn.
              ENDIF.
            ENDIF.
            CLEAR:ls_tckh2.
          ENDLOOP.
        ENDIF.
      ELSE.
      SELECT elehk kstav kstab elemt FROM tckh2 INTO TABLE lt_tckh2 WHERE kstav <=  ls_ckis-kstar AND kstab >= ls_ckis-kstar
               AND elehk EQ 'D1'.
        IF sy-subrc = 0.
          LOOP AT lt_tckh2 INTO ls_tckh2.
            IF ls_tckh2-elemt = '001' . "Material Cost
              IF ls_ckis-typps = 'I'.
*                DATA: kst015  TYPE keph-kst001.
                kst015 = ls_ckis-wertn / ls_ckis-menge .
                kst014 = kst015 * w_stpox-menge.
                ls_final-kst001 = ls_final-kst001 + kst014.
              ELSE.
                IF ls_ckis-typps NE 'M'.
                  ls_final-kst001 =  ls_final-kst001 + ls_ckis-wertn.
                ENDIF.
              ENDIF.
            ENDIF.
*            IF ls_tckh2-elemt = '002' . "Machine Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst002 =  ls_final-kst002 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '003' . "Labour Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst003 =  ls_final-kst003 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '004' . "Power Consumption
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst004 =  ls_final-kst004 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '005' . "Process Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst005 =  ls_final-kst005 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '006' . "Dressing
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst006 =  ls_final-kst006 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '007' . "Fuel Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst007 =  ls_final-kst007 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '008' . "PRODUCTION OH
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst008 =  ls_final-kst008 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
            IF ls_tckh2-elemt = '009' . "Subcontracting Cost
              IF ls_ckis-typps NE 'M'.
                ls_final-kst009 =  ls_final-kst009 + ls_ckis-wertn.
              ENDIF.
            ENDIF.
            CLEAR:ls_tckh2.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDLOOP.
    LS_FINAL-tot_cost = LS_FINAL-KST001 + LS_FINAL-KST002 + LS_FINAL-KST003 + LS_FINAL-KST004 +
                        LS_FINAL-KST005 + LS_FINAL-KST006 + LS_FINAL-KST007 + LS_FINAL-KST008 + LS_FINAL-KST009.
    APPEND ls_final TO lt_final.
    CLEAR: ls_final,ls_mbew,ls_mara,ls_keko,w_stpox,ls_ckis,kst015,LS_KEPH,gv_poper,gv_bdatj.
    CLEAR: ls_keko.
   ELSE.
    LS_FINAL-KALNR  = LS_KEKO-KALNR .
    LS_FINAL-KALKA  = LS_KEKO-KALKA.
    LS_FINAL-KADKY  = LS_KEKO-KADKY .
    ls_final-matnr  = ls_keko-matnr.
    ls_final-werks  = ls_keko-werks .
    ls_final-bwkey  = ls_keko-bwkey  .
    ls_final-kokrs  = ls_keko-kokrs  .
    ls_final-kadat  = ls_keko-kadat  .
    ls_final-bidat  = ls_keko-bidat  .
    ls_final-bwdat  = ls_keko-bwdat  .
    ls_final-aldat  = ls_keko-aldat  .
    ls_final-stnum  = ls_keko-stnum  .
    ls_final-plnnr  = ls_keko-plnnr  .
    ls_final-loekz  = ls_keko-loekz  .
    ls_final-losgr  = ls_keko-losgr  .
    ls_final-erfnm  = ls_keko-erfnm  .
    ls_final-cpudt  = ls_keko-cpudt  .
    ls_final-feh_sta = ls_keko-feh_sta.
    ls_final-freig  = ls_keko-freig  .
    ls_final-sobes  = ls_keko-sobes  .
    ls_final-kalsm  = ls_keko-kalsm  .
    ls_final-klvar  = ls_keko-klvar  .
    ls_final-poper  = ls_keko-poper  .
    ls_final-bdatj  = ls_keko-bdatj  .
    ls_final-beskz  = ls_keko-beskz  .

    READ TABLE LT_KEPH INTO LS_KEPH WITH  KEY  KALNR = LS_FINAL-KALNR KALKA = LS_FINAL-KALKA KADKY = LS_FINAL-KADKY.
    IF SY-SUBRC = 0.
        LS_FINAL-KALNR  = LS_KEPH-KALNR .
        LS_FINAL-KALKA  = LS_KEPH-KALKA.
        LS_FINAL-KADKY  = LS_KEPH-KADKY .
        LS_FINAL-TVERS  = LS_KEPH-TVERS.
        LS_FINAL-BWVAR  = LS_KEPH-BWVAR.
        LS_FINAL-KKZST  = LS_KEPH-KKZST.
        LS_FINAL-kst002 = LS_KEPH-KST003 .
        LS_FINAL-KST003 = LS_KEPH-KST005 .
        LS_FINAL-KST004 = LS_KEPH-KST007 .
        LS_FINAL-KST005 = LS_KEPH-KST009 .
        LS_FINAL-KST006 = LS_KEPH-KST011 .
        LS_FINAL-KST007 = LS_KEPH-KST013 .
        LS_FINAL-KST008 = LS_KEPH-KST015.

    ENDIF.
    READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_final-matnr bwkey = ls_final-bwkey.
    ls_final-vprsv = ls_mbew-vprsv.
    ls_final-verpr = ls_mbew-verpr.
    ls_final-stprs = ls_mbew-stprs.

    READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_final-matnr.
    ls_final-mtart = ls_mara-mtart.

  SELECT  kalnr
          kalka
          kadky
          tvers
          bwvar
          matnr
          werks
          bdatj
          poper
          bwkey
          kokrs
          kadat
          bidat
          bwdat
          aldat
          stnum
          plnnr
          loekz
          losgr
          erfnm
          cpudt
          feh_sta
          freig
          sobes
          kalsm
          klvar
          beskz
          FROM keko
          INTO TABLE lt_keko2
          FOR ALL ENTRIES IN i_stpox
           WHERE matnr EQ  i_stpox-idnrk
           and poper eq ls_keko-poper
           and bdatj eq ls_keko-bdatj.

    gv_poper  = ls_keko-poper - 1.
    gv_bdatj  = ls_keko-bdatj .
    IF ls_keko-poper = '001'.
    gv_poper  = '012'.
    gv_bdatj  = ls_keko-bdatj - 1.
    ENDIF.

IF ls_keko-bdatj = gv_bdatj.
  SELECT  kalnr
          kalka
          kadky
          tvers
          bwvar
          matnr
          werks
          bdatj
          poper
          bwkey
          kokrs
          kadat
          bidat
          bwdat
          aldat
          stnum
          plnnr
          loekz
          losgr
          erfnm
          cpudt
          feh_sta
          freig
          sobes
          kalsm
          klvar
          beskz
          FROM keko
          INTO TABLE lt_keko4
          FOR ALL ENTRIES IN i_stpox
           WHERE matnr EQ  i_stpox-idnrk
           and poper eq gv_poper
           and bdatj eq gv_bdatj.
ENDIF.
  LOOP AT lt_keko4.
    MOVE-CORRESPONDING lt_keko4 TO lt_keko2.
    APPEND lt_keko2.
  ENDLOOP.

  SELECT  kalnr
          kalka
          kadky
          tvers
          bwvar
          matnr
          werks
          bdatj
          poper
          bwkey
          kokrs
          kadat
          bidat
          bwdat
          aldat
          stnum
          plnnr
          loekz
          losgr
          erfnm
          cpudt
          feh_sta
          freig
          sobes
          kalsm
          klvar
          beskz
          FROM keko
          INTO TABLE lt_keko3
           WHERE matnr EQ  ls_keko-MATNR
           and poper eq ls_keko-poper
           and bdatj eq ls_keko-bdatj.

  LOOP AT lt_keko3.
    MOVE-CORRESPONDING lt_keko3 TO lt_keko2.
    APPEND lt_keko2.
  ENDLOOP.


    SELECT kalnr kalka kadky typps kstar werks matnr pmeht menge meeht prctr wertn
           FROM ckis INTO CORRESPONDING FIELDS OF TABLE lt_ckis FOR ALL ENTRIES IN lt_keko2
           WHERE KALNR EQ  lt_keko2-KALNR
           AND kadky   EQ lt_keko2-kadky.
*           AND TYPPS   NE 'M'.

    LOOP AT lt_ckis INTO ls_ckis.
      READ TABLE i_stpox INTO w_stpox WITH KEY idnrk = ls_ckis-matnr.
      IF sy-subrc = 0.
        SELECT elehk kstav kstab elemt FROM tckh2 INTO TABLE lt_tckh2 WHERE kstav <=  ls_ckis-kstar AND kstab >= ls_ckis-kstar
               AND elehk EQ 'D1'.
        IF sy-subrc = 0.
          LOOP AT lt_tckh2 INTO ls_tckh2.
            IF ls_tckh2-elemt = '001' . "Material Cost
              IF ls_ckis-typps = 'I'.
                kst015 = ls_ckis-wertn / ls_ckis-menge .
                kst014 = kst015 * w_stpox-mnglg.
                ls_final-kst001 = ls_final-kst001 + kst014.
              ELSE.
                IF ls_ckis-typps NE 'M'.
                  ls_final-kst001 =  ls_final-kst001 + ls_ckis-wertn.
                ENDIF.
              ENDIF.
            ENDIF.
*            IF ls_tckh2-elemt = '002' . "Machine Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst002 =  ls_final-kst002 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '003' . "Labour Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst003 =  ls_final-kst003 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '004' . "Power Consumption
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst004 =  ls_final-kst004 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '005' . "Process Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst005 =  ls_final-kst005 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '006' . "Dressing
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst006 =  ls_final-kst006 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '007' . "Fuel Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst007 =  ls_final-kst007 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '008' . "PRODUCTION OH
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst008 =  ls_final-kst008 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
            IF ls_tckh2-elemt = '009' . "Subcontracting Cost
              IF ls_ckis-typps NE 'M'.
                ls_final-kst009 =  ls_final-kst009 + ls_ckis-wertn.
              ENDIF.
            ENDIF.
            CLEAR:ls_tckh2.
          ENDLOOP.
        ENDIF.
      ELSE.
      SELECT elehk kstav kstab elemt FROM tckh2 INTO TABLE lt_tckh2 WHERE kstav <=  ls_ckis-kstar AND kstab >= ls_ckis-kstar
               AND elehk EQ 'D1'.
        IF sy-subrc = 0.
          LOOP AT lt_tckh2 INTO ls_tckh2.
            IF ls_tckh2-elemt = '001' . "Material Cost
              IF ls_ckis-typps = 'I'.
*                DATA: kst015  TYPE keph-kst001.
                kst015 = ls_ckis-wertn / ls_ckis-menge .
                kst014 = kst015 * w_stpox-menge.
                ls_final-kst001 = ls_final-kst001 + kst014.
              ELSE.
                IF ls_ckis-typps NE 'M'.
                  ls_final-kst001 =  ls_final-kst001 + ls_ckis-wertn.
                ENDIF.
              ENDIF.
            ENDIF.
*            IF ls_tckh2-elemt = '002' . "Machine Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst002 =  ls_final-kst002 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '003' . "Labour Hours
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst003 =  ls_final-kst003 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '004' . "Power Consumption
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst004 =  ls_final-kst004 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '005' . "Process Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst005 =  ls_final-kst005 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '006' . "Dressing
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst006 =  ls_final-kst006 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '007' . "Fuel Cost
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst007 =  ls_final-kst007 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
*            IF ls_tckh2-elemt = '008' . "PRODUCTION OH
*              IF ls_ckis-typps NE 'M'.
*                ls_final-kst008 =  ls_final-kst008 + ls_ckis-wertn.
*              ENDIF.
*            ENDIF.
            IF ls_tckh2-elemt = '009' . "Subcontracting Cost
              IF ls_ckis-typps NE 'M'.
                ls_final-kst009 =  ls_final-kst009 + ls_ckis-wertn.
              ENDIF.
            ENDIF.
            CLEAR:ls_tckh2.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LS_FINAL-tot_cost = LS_FINAL-KST001 + LS_FINAL-KST002 + LS_FINAL-KST003 + LS_FINAL-KST004 +
                        LS_FINAL-KST005 + LS_FINAL-KST006 + LS_FINAL-KST007 + LS_FINAL-KST008 + LS_FINAL-KST009.
    APPEND ls_final TO lt_final.
    CLEAR: ls_final,ls_mbew,ls_mara,ls_keko,w_stpox,ls_ckis,kst015,LS_KEPH,gv_poper,gv_bdatj.
    CLEAR: ls_keko.
   ENDIF.


  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcatlog .
  REFRESH t_fieldcat.
  DATA(cnt) = 0.
  cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KALNR'       'Cost Estimate Number'. cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KALKA'       'Costing Type'.         cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KADKY'       'Costing Date'.         cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'TVERS'       'Costing Version'.      cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'BWVAR'       'Valuation Variant in Costing'.  cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'MATNR'       'Material Number'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'WERKS'       'Plant'.                         cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'BWKEY'       'Valuation Area'.                cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KOKRS'       'Controlling Area'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KADAT'       'Costing Date From'.             cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'BIDAT'       'Costing Date'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'BWDAT'       'PValuation Date of a Cost Estimate'.  cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'ALDAT'       'Quantity Structure Date for Costing'.  cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'STNUM'       'Bill of material'.                     cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'PLNNR'       'Key for Task List Group'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'LOEKZ'       'Deletion Indicator '.                  cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'LOSGR'       'Lot Size'.                             cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'ERFNM'       'Costed by User'.                       cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'CPUDT'       'Date on Which Cost Estimate Was Created'. cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'FEH_STA'     'Costing Status'.                         cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'FREIG'       'Release of Standard Cost Estimate'.      cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'SOBES'       'Special procurement type'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KALSM'       'Costing Sheet for Calculating Overhead'. cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KLVAR'       'Costing Variant'.           cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'POPER'       'Posting Period'.            cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'BDATJ'       'Posting Date'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'BESKZ'       'Procurement Type'.          cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KKZST'       'Indicator Lower Level'.     cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST001'      'Material Cost'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST002'      'Machine Hours'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST003'      'Labour Hours'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST004'      'Power Consumption'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST005'      'Process Cost'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST006'      'Dressing'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST007'      'Fuel Cost'.               cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST008'      'PRODUCTION OH'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'KST009'      'Subcontracting Cost'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'TOT_COST'    ' Total Cost'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'VPRSV'       'Price Control'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'VERPR'       'Present  Moving Average Price'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'STPRS'       'Standard Price'.              cnt = cnt + 1.
  PERFORM t_fieldcatlog USING  cnt   'MTART'       'Material Type'.              cnt = cnt + 1.




  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra = 'X'.
*  FS_LAYOUT-DETAIL_POPUP = 'X'.
*  FS_LAYOUT-SUBTOTALS_TEXT = 'TOTAL'.
ENDFORM.                    " FILL_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      is_layout              = fs_layout
      i_callback_top_of_page = 'TOP_OF_PAGE'
      it_fieldcat            = t_fieldcat[]
*     IT_SORT                = T_SORT[]
      i_save                 = 'X'
      it_events              = it_event
    TABLES
      t_outtab               = lt_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CNT  text
*      -->P_0438   text
*      -->P_0439   text
*----------------------------------------------------------------------*
FORM t_fieldcatlog  USING    p_cnt
                             VALUE(p_0438)
                             VALUE(p_0439).

  t_fieldcat-col_pos = p_cnt.
  t_fieldcat-fieldname = p_0438.
  t_fieldcat-seltext_l = p_0439.
  APPEND t_fieldcat.
  CLEAR t_fieldcat.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  GET_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_event .
  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = it_event
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



  READ TABLE it_event INTO wa_event WITH KEY name = 'TOP_OF_PAGE'.
  wa_event-form = 'TOP_OF_PAGE'.
  MODIFY it_event FROM wa_event INDEX sy-tabix.
ENDFORM.
FORM top_of_page.
  DATA : date1 TYPE string.

  wa_header-typ = 'H'.  "header
  wa_header-info = 'Standard Costing Report'.
  APPEND wa_header TO it_header.
  CLEAR wa_header.

  CONCATENATE sy-datum+6(2)
  ' : '
  sy-datum+4(2)
  ' : '
  sy-datum(4) INTO date1 SEPARATED BY space.

  wa_header-typ = 'S'. "selection
  wa_header-key = 'USER : '.
  wa_header-info = sy-uname.
  APPEND wa_header TO it_header.
  CLEAR wa_header.

  wa_header-typ = 'S'. "Action
  wa_header-key = 'Current Date : '.
  wa_header-info = date1.
  APPEND wa_header TO it_header.
  CLEAR: wa_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_header
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
  CLEAR it_header.
ENDFORM.
