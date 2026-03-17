*&---------------------------------------------------------------------*
*& Report ZMATERIAL_STORAGE_BIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmaterial_storage_bin.

TABLES:mard,mara.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
       END OF ty_mara,

       BEGIN OF ty_mara_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         lgpbe TYPE mard-lgpbe,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
       END OF ty_mara_mard,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         labst TYPE mard-labst,
         umlme TYPE mard-umlme,
         insme TYPE mard-insme,
         einme TYPE mard-einme,
         speme TYPE mard-speme,
         retme TYPE mard-retme,
         vmlab TYPE mard-vmlab,
         vmuml TYPE mard-vmuml,
         vmins TYPE mard-vmins,
         vmein TYPE mard-vmein,
         vmspe TYPE mard-vmspe,
         vmret TYPE mard-vmret,
       END OF ty_mard,




       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_mbew,
         matnr TYPE mbew-matnr,
         bwkey TYPE mbew-bwkey,
         lbkum TYPE mbew-lbkum,
         salk3 TYPE mbew-salk3,
         vprsv TYPE mbew-vprsv,
         verpr TYPE mbew-verpr,
         stprs TYPE mbew-stprs,
       END OF ty_mbew,

       BEGIN OF ty_ebew,
         matnr TYPE ebew-matnr,
         bwkey TYPE ebew-bwkey,
         vbeln TYPE ebew-vbeln,
         posnr TYPE ebew-posnr,
         lbkum TYPE ebew-lbkum,
         salk3 TYPE ebew-salk3,
         vprsv TYPE ebew-vprsv,
         verpr TYPE ebew-verpr,
         stprs TYPE ebew-stprs,
       END OF ty_ebew,



       BEGIN OF ty_mska,
         matnr TYPE mska-matnr,
         werks TYPE mska-werks,
         lgort TYPE mska-lgort,
         sobkz TYPE mska-sobkz,
         vbeln TYPE mska-vbeln,
         posnr TYPE mska-posnr,
         kalab TYPE mska-kalab,
         kains TYPE mska-kains,
         kaspe TYPE mska-kaspe,
         kavla TYPE mska-kavla,
         kavin TYPE mska-kavin,
         kavsp TYPE mska-kavsp,
         kavei TYPE mska-kavei,
       END OF ty_mska,

       BEGIN OF ty_mslb,
         matnr TYPE mslb-matnr,
         werks TYPE mslb-werks,
         charg TYPE mslb-charg,
         sobkz TYPE mslb-sobkz,
         lifnr TYPE mslb-lifnr,
         lblab TYPE mslb-lblab,
         lbins TYPE mslb-lbins,
         lbvla TYPE mslb-lbvla,
         lbvei TYPE mslb-lbvei,
         lbuml TYPE mslb-lbuml,
       END OF ty_mslb,



       BEGIN OF ty_final,
         matnr    TYPE mard-matnr,
         werks    TYPE mard-werks,
         lgort    TYPE mard-lgort,
         labst    TYPE mard-labst,
         umlme    TYPE mard-umlme,
         insme    TYPE mard-insme,
         einme    TYPE mard-einme,
         speme    TYPE mard-speme,
         retme    TYPE mard-retme,
         vmlab    TYPE mard-vmlab,
         vmuml    TYPE mard-vmuml,
         vmins    TYPE mard-vmins,
         vmein    TYPE mard-vmein,
         vmspe    TYPE mard-vmspe,
         vmret    TYPE mard-vmret,
         lgpbe    TYPE mard-lgpbe,
         mtart    TYPE mara-mtart,
         matkl    TYPE mara-matkl,
         mattxt   TYPE text100,
         lbkum    TYPE mbew-lbkum,
         salk3    TYPE mbew-salk3,
         price    TYPE mbew-stprs,"p DECIMALS 2,"mbew-salk3,    "string,"
         un_val   TYPE prcd_elements-kwert,
         rate     TYPE F,   "p LENGTH 15 DECIMALS 14, " mbew-salk3,  " string,
         vbeln    TYPE mska-vbeln,
         posnr    TYPE mska-posnr,
         kalab    TYPE mska-kalab,
         lblab    TYPE mslb-lblab,
         stock_no TYPE char100,
         ql_val   TYPE mbew-salk3,
         lifnr    TYPE mslb-lifnr,
       END OF ty_final,

       BEGIN OF final,
         matnr    TYPE mard-matnr,
         mtart    TYPE mara-mtart,
         matkl    TYPE mara-matkl,
         werks    TYPE mard-werks,
         lgort    TYPE mard-lgort,
         labst    TYPE char15,
         umlme    TYPE char15,
         insme    TYPE char15,
         einme    TYPE char15,
         speme    TYPE char15,
         retme    TYPE char15,
         vmlab    TYPE char15,
         vmuml    TYPE char15,
         vmins    TYPE char15,
         vmein    TYPE char15,
         vmspe    TYPE char15,
         vmret    TYPE char15,
         lgpbe    TYPE char15,
         lbkum    TYPE char15,
         salk3    TYPE char15,
         price    TYPE char15,
         un_val   TYPE char15,
         stock_no TYPE char100,
         vbeln    TYPE char10,
         ref      TYPE char15,
         ql_val   TYPE char15,
         lifnr    TYPE mslb-lifnr,
         TIME     TYPE CHAR10,
       END OF final.



DATA:it_mara      TYPE TABLE OF ty_mara,
     wa_mara      TYPE          ty_mara,

     it_makt      TYPE TABLE OF ty_makt,
     wa_makt      TYPE          ty_makt,

     it_mard      TYPE TABLE OF ty_mard,
     wa_mard      TYPE          ty_mard,

     it_mara_mard TYPE TABLE OF ty_mara_mard,
     wa_mara_mard TYPE          ty_mara_mard,

     it_mbew      TYPE TABLE OF ty_mbew,
     wa_mbew      TYPE          ty_mbew,

     it_ebew      TYPE TABLE OF ty_ebew,
     wa_ebew      TYPE          ty_ebew,

     it_mska      TYPE TABLE OF ty_mska,
     wa_mska      TYPE          ty_mska,

     it_mslb      TYPE TABLE OF ty_mslb,
     wa_mslb      TYPE          ty_mslb,

     it_final     TYPE TABLE OF ty_final,
     wa_final     TYPE          ty_final,

     lt_final     TYPE TABLE OF final,
     ls_final     TYPE          final.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.

****************************added by jyoti on 29.07.2024*******************
INITIALIZATION.
MESSAGE 'This Tcode is discontinued. Kindly use ZMB52_1 Tcode' TYPE 'E'.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_matnr FOR mard-matnr,
                s_lgort FOR mard-lgort,
                s_lgpbe FOR mard-lgpbe,
                s_mtart FOR mara-mtart.
PARAMETERS :    p_werks TYPE mard-werks OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp' . " '/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM det_fcat.
  PERFORM get_display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT a~matnr
         a~werks
         a~lgort
         a~lgpbe
         b~mtart
         b~matkl
         INTO TABLE it_mara_mard FROM mard AS a
         INNER JOIN mara AS b ON b~matnr = a~matnr
         WHERE a~matnr IN s_matnr
          AND  a~lgort IN s_lgort
          AND  a~lgpbe IN s_lgpbe
          AND  a~werks = p_werks
          AND  b~mtart IN s_mtart.


  IF  it_mara_mard IS NOT INITIAL .
    SELECT matnr
           werks
           lgort
           labst
           umlme
           insme
           einme
           speme
           retme
           vmlab
           vmuml
           vmins
           vmein
           vmspe
           vmret FROM mard INTO TABLE it_mard
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   lgort = it_mara_mard-lgort
           AND   werks = it_mara_mard-werks.


    SELECT matnr
           werks
           lgort
           sobkz
           vbeln
           posnr
           kalab
           kains
           kaspe
           kavla
           kavin
           kavsp
           kavei FROM mska INTO TABLE it_mska
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
*           AND   lgort = it_mara_mard-lgort
           AND   werks = it_mara_mard-werks.
*           AND   SOBKZ = 'E'.

    SELECT matnr
           werks
           charg
           sobkz
           lifnr
           lblab
           lbins
           lbvla
           lbvei
           lbuml FROM mslb INTO TABLE it_mslb
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   werks = it_mara_mard-werks.


    SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr.

    SELECT matnr
           bwkey
           lbkum
           salk3
           vprsv
           verpr
           stprs FROM mbew INTO TABLE it_mbew
           FOR ALL ENTRIES IN it_mara_mard
           WHERE matnr = it_mara_mard-matnr
           AND   bwkey = it_mara_mard-werks.

*   SELECT matnr
*           bwkey
*           lbkum
*           salk3
*           vprsv
*           verpr
*           stprs FROM ebew INTO TABLE it_ebew
*           FOR ALL ENTRIES IN it_mara_mard
*           WHERE matnr = it_mara_mard-matnr
*           AND   bwkey = it_mara_mard-werks.

  ENDIF.

  IF it_mska IS NOT INITIAL.
    SELECT matnr
           bwkey
           vbeln
           posnr
           lbkum
           salk3
           vprsv
           verpr
           stprs FROM ebew INTO TABLE it_ebew
           FOR ALL ENTRIES IN it_mska
           WHERE matnr = it_mska-matnr
           AND   bwkey = it_mska-werks
           AND   vbeln = it_mska-vbeln
           AND   posnr = it_mska-posnr.

  ENDIF.





**************************************Logic for Store Stock********************************
  LOOP AT it_mara_mard INTO wa_mara_mard.
    wa_final-matnr = wa_mara_mard-matnr.
    wa_final-werks = wa_mara_mard-werks.
    wa_final-lgort = wa_mara_mard-lgort.
    wa_final-lgpbe = wa_mara_mard-lgpbe.
    wa_final-mtart = wa_mara_mard-mtart.
    wa_final-matkl = wa_mara_mard-matkl.

*    READ TABLE IT_MSKA INTO wa_mska WITH KEY matnr = wa_mara_mard-matnr werks = wa_mara_mard-werks lgort = wa_mara_mard-lgort.
*    IF sy-subrc = 0.
*      wa_final-vbeln = wa_mska-vbeln.
*      wa_final-posnr = wa_mska-posnr.
*      wa_final-kalab = wa_mska-kalab.
*
*    ENDIF.

*    READ TABLE it_mslb INTO wa_mslb WITH KEY matnr = wa_mara_mard-matnr werks = wa_mara_mard-werks.
*    IF sy-subrc = 0.
*      wa_final-lblab = wa_mslb-lblab.
*
*    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara_mard-matnr.
    IF  sy-subrc = 0.
*      wa_final-maktx = wa_makt-maktx.

    ENDIF.

    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mara_mard-matnr bwkey = wa_mara_mard-werks..
    IF  sy-subrc = 0.
      wa_final-lbkum = wa_mbew-lbkum.
      wa_final-salk3 = wa_mbew-salk3.                      "commented by Ganga 17.10.2018

      IF wa_mbew-vprsv = 'S'.
        wa_final-price = wa_mbew-stprs.
      ELSEIF wa_mbew-vprsv = 'V'..
        wa_final-price = wa_mbew-verpr.

      ENDIF.

    ENDIF.

    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_mara_mard-matnr lgort = wa_mara_mard-lgort werks = wa_mara_mard-werks.
    IF sy-subrc = 0.
      wa_final-labst = wa_mard-labst.
      wa_final-umlme = wa_mard-umlme.
      wa_final-insme = wa_mard-insme.
      wa_final-einme = wa_mard-einme.
      wa_final-speme = wa_mard-speme.
      wa_final-retme = wa_mard-retme.
      wa_final-vmlab = wa_mard-vmlab.
      wa_final-vmuml = wa_mard-vmuml.
      wa_final-vmins = wa_mard-vmins.
      wa_final-vmein = wa_mard-vmein.
      wa_final-vmspe = wa_mard-vmspe.
      wa_final-vmret = wa_mard-vmret.


    ENDIF.

*BREAK PRIMUS..
    IF wa_final-lbkum NE 0.
      wa_final-rate  = wa_final-salk3 / wa_final-lbkum.
      wa_final-un_val = wa_final-labst * wa_final-rate.
      wa_final-salk3  =  wa_final-labst * wa_final-rate.
    ELSE.
      wa_final-rate  = wa_final-price.      "wa_final-salk3 / wa_final-lbkum.
      wa_final-un_val = wa_final-labst * wa_final-rate.
      wa_final-salk3  =  wa_final-labst * wa_final-rate.
    ENDIF.

    IF wa_final-insme NE 0.
      wa_final-ql_val = wa_final-insme * wa_final-rate.
    ENDIF.



    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_final-matnr.
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-mattxt wa_lines-tdline INTO wa_final-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-mattxt.
    ENDIF.
*
*      IF wa_final-vbeln IS NOT INITIAL.
*        CONCATENATE wa_final-vbeln wa_final-posnr  INTO wa_final-stock_no SEPARATED BY '/'.
*      ENDIF.






    APPEND wa_final TO it_final.

    CLEAR: wa_final,ls_final.
  ENDLOOP.
***************************************************Logic for Sales Order Stock*****************
  LOOP AT it_mska INTO wa_mska.
    wa_final-matnr = wa_mska-matnr.
    wa_final-werks = wa_mska-werks.
    wa_final-lgort = wa_mska-lgort.
    wa_final-vbeln = wa_mska-vbeln.
    wa_final-posnr = wa_mska-posnr.
    wa_final-labst = wa_mska-kalab.
    wa_final-insme = wa_mska-kains.
    wa_final-speme = wa_mska-kaspe.
    wa_final-vmlab = wa_mska-kavla.
    wa_final-vmins = wa_mska-kavin.
    wa_final-vmein = wa_mska-kavei.
    wa_final-vmspe = wa_mska-kavsp.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = wa_final-vbeln
      IMPORTING
        output = wa_final-vbeln.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = wa_final-posnr
      IMPORTING
        output = wa_final-posnr.


    IF wa_final-vbeln IS NOT INITIAL.
      CONCATENATE wa_final-vbeln wa_final-posnr  INTO wa_final-stock_no SEPARATED BY '/'.
    ENDIF.
    READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_mska-matnr werks = wa_mska-werks lgort = wa_mska-lgort.
    IF sy-subrc = 0.
      wa_final-mtart = wa_mara_mard-mtart..
      wa_final-matkl = wa_mara_mard-matkl.
    ENDIF.
    SELECT SINGLE mtart INTO wa_final-mtart FROM mara WHERE matnr = wa_mska-matnr.
    READ TABLE it_ebew INTO wa_ebew WITH KEY matnr = wa_mska-matnr bwkey = wa_mska-werks vbeln = wa_mska-vbeln posnr = wa_mska-posnr.
    IF  sy-subrc = 0.
      wa_final-lbkum = wa_ebew-lbkum.
      wa_final-salk3 = wa_ebew-salk3.

      IF wa_ebew-vprsv = 'S'.
        wa_final-price = wa_ebew-stprs.
      ELSEIF wa_ebew-vprsv = 'V'..
        wa_final-price = wa_ebew-verpr.

      ENDIF.

    ENDIF.
    IF wa_final-lbkum NE 0.
      wa_final-rate  = wa_final-salk3 / wa_final-lbkum.
      wa_final-salk3  =  wa_final-labst * wa_final-rate .
    ELSE.
      wa_final-rate  = wa_final-price.      "wa_final-salk3 / wa_final-lbkum.
      wa_final-salk3  =  wa_final-labst * wa_final-rate.

    ENDIF.

    IF wa_final-insme NE 0.
      wa_final-ql_val = wa_final-insme * wa_final-rate.
    ENDIF.


    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_final-matnr.
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-mattxt wa_lines-tdline INTO wa_final-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-mattxt.
    ENDIF.


    APPEND wa_final TO it_final.
    CLEAR: wa_final,ls_final.
  ENDLOOP.


*****************************************Logic for Stock At Vendor*************************************
  LOOP AT it_mslb INTO wa_mslb.

    wa_final-matnr = wa_mslb-matnr.
    wa_final-werks = wa_mslb-werks.
    wa_final-labst = wa_mslb-lblab.
    wa_final-umlme = wa_mslb-lbuml.
    wa_final-insme = wa_mslb-lbins.
    wa_final-vmlab = wa_mslb-lbvla.
    wa_final-vmein = wa_mslb-lbvei.
    wa_final-lifnr = wa_mslb-lifnr.

    READ TABLE it_mara_mard INTO wa_mara_mard WITH KEY matnr = wa_mslb-matnr werks = wa_mslb-werks .
    IF sy-subrc = 0.
      wa_final-mtart = wa_mara_mard-mtart..
      wa_final-matkl = wa_mara_mard-matkl.
    ENDIF.


    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mslb-matnr bwkey = wa_mslb-werks.
    IF  sy-subrc = 0.
      wa_final-lbkum = wa_mbew-lbkum.
      wa_final-salk3 = wa_mbew-salk3.

      IF wa_mbew-vprsv = 'S'.
        wa_final-price = wa_mbew-stprs.
      ELSEIF wa_mbew-vprsv = 'V'..
        wa_final-price = wa_mbew-verpr.

      ENDIF.

    ENDIF.

    IF wa_final-lbkum NE 0.
      wa_final-rate  = wa_final-salk3 / wa_final-lbkum.
      wa_final-salk3  =  wa_final-labst * wa_final-rate.
    ELSE.
      wa_final-rate  = wa_final-price.      "wa_final-salk3 / wa_final-lbkum.
      wa_final-salk3  =  wa_final-labst * wa_final-rate.
    ENDIF.

    IF wa_final-insme NE 0.
      wa_final-ql_val = wa_final-insme * wa_final-rate.
    ENDIF.

    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_final-matnr.
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
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-mattxt wa_lines-tdline INTO wa_final-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-mattxt.
    ENDIF.



    APPEND wa_final TO it_final.
    CLEAR: wa_final,ls_final.
  ENDLOOP.


*********************************Downlaod File****************************

  LOOP AT it_final INTO wa_final.


    ls_final-matnr = wa_final-matnr.
    ls_final-werks = wa_final-werks.
    ls_final-lgort = wa_final-lgort.
    ls_final-lgpbe = wa_final-lgpbe.
    ls_final-mtart = wa_final-mtart.
    ls_final-matkl = wa_final-matkl.
    ls_final-lbkum = wa_final-lbkum.
    ls_final-salk3 = wa_final-salk3.
    ls_final-price = wa_final-price.
    ls_final-labst = wa_final-labst.
    ls_final-umlme = wa_final-umlme.
    ls_final-insme = wa_final-insme.
    ls_final-einme = wa_final-einme.
    ls_final-speme = wa_final-speme.
    ls_final-retme = wa_final-retme.
    ls_final-vmlab = wa_final-vmlab.
    ls_final-vmuml = wa_final-vmuml.
    ls_final-vmins = wa_final-vmins.
    ls_final-vmein = wa_final-vmein.
    ls_final-vmspe = wa_final-vmspe.
    ls_final-vmret = wa_final-vmret.
    ls_final-un_val = wa_final-un_val.
    ls_final-stock_no = wa_final-stock_no.
    ls_final-vbeln = wa_final-vbeln.
    ls_final-ref = sy-datum.
    ls_final-ql_val = wa_final-ql_val.
    ls_final-lifnr = wa_final-lifnr.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-ref
      IMPORTING
        output = ls_final-ref.

    CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                    INTO ls_final-ref SEPARATED BY '-'.

     CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO ls_final-TIME SEPARATED BY ':'.


    APPEND ls_final TO lt_final.
    CLEAR ls_final.
  ENDLOOP.
  SORT it_final BY matnr.
  SORT lt_final BY matnr.
*  BREAK primus.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM det_fcat .
  PERFORM fcat USING : "mara table.
                        '1'  'MATNR'         'IT_FINAL'  'Material'                                        '18',
                        '2'  'MATTXT'        'IT_FINAL'  'Material Description'                            '18',
                        '3'  'MTART'         'IT_FINAL'  'Material Type'                                   '18',
                        '4'  'MATKL'         'IT_FINAL'  'Material Group'                                  '18',
                        '5'  'WERKS'         'IT_FINAL'  'Plant'                                           '10',
                        '6'  'LGORT'         'IT_FINAL'  'Storage location'                                '10',
                        '7'  'LABST'         'IT_FINAL'  'Unrestricted'                                    '18',
                        '8'  'UMLME'         'IT_FINAL'  'Stock in transfer '                              '18',
                        '9'  'INSME'         'IT_FINAL'  'Stock in Quality Inspection'                     '18',
                       '10'  'EINME'         'IT_FINAL'  'Total Stock'                                     '18',
                       '11'  'SPEME'         'IT_FINAL'  'Blocked Stock'                                   '18',
                       '12'  'RETME'         'IT_FINAL'  'Blocked Stock Returns'                           '18',
                       '13'  'VMLAB'         'IT_FINAL'  'Valuated unrestricted-use stock'                 '18',
                       '14'  'VMUML'         'IT_FINAL'  'Stock in Transfer in Previous Period'            '18',
                       '15'  'VMINS'         'IT_FINAL'  'Stock in Quality Inspection in Previous Period'  '18',
                       '16'  'VMEIN'         'IT_FINAL'  'Restricted-Use Stock in Previous Period'         '18',
                       '17'  'VMSPE'         'IT_FINAL'  'Blocked stock of previous period'                '18',
                       '18'  'VMRET'         'IT_FINAL'  'Blocked Stock Returns in Previous Period'        '18',
                       '19'  'LGPBE'         'IT_FINAL'  'Storage Bin'                                     '18',
                       '20'  'LBKUM'         'IT_FINAL'  'Total Valuated Stock'                            '18',
                       '21'  'SALK3'         'IT_FINAL'  'Value of Total Valuated Stock'                   '18',
                       '22'  'QL_VAL'        'IT_FINAL'  'Value Of Quality Stock'                          '18',
                       '23'  'PRICE'         'IT_FINAL'  'Price'                                           '18',
                       '24'  'UN_VAL'        'IT_FINAL'  'value Unresticted'                               '18',
                       '25'  'STOCK_NO'      'IT_FINAL'  'Special stock number'                            '20',
                       '26'  'VBELN'         'IT_FINAL'  'Sales Document'                                  '15',
                       '27'  'LIFNR'         'IT_FINAL'  'Subcon Vendor'                                   '15'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*BREAK primusabap.
  IF p_down = 'X'.
    PERFORM download.
*    PERFORM gui_download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0542   text
*      -->P_0543   text
*      -->P_0544   text
*      -->P_0545   text
*      -->P_0546   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*  wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
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

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.

  IF p_werks = 'PL01'.
    lv_file = 'ZMB52_PL01.TXT'.
  ELSEIF p_werks = 'US01'.
    lv_file = 'ZMB52_US01.TXT'.
  ELSEIF p_werks = 'US02'.
    lv_file = 'ZMB52_US02.TXT'.
  ENDIF.
*  lv_file = 'ZMB52.TXT'.
*BREAK primus.
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMATERIAL STORAGE BIN REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_931 TYPE string.
DATA lv_crlf_931 TYPE string.
lv_crlf_931 = cl_abap_char_utilities=>cr_lf.
lv_string_931 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_931 lv_crlf_931 wa_csv INTO lv_string_931.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_676 TO lv_fullfile.
TRANSFER lv_string_931 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
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
  CONCATENATE  'Material'
               'Material Type'
               'Material Group'
               'Plant'
               'Storage location'
               'Unrestricted'
               'Stock in transfer '
               'Stock in Quality Inspection'
               'Total Stock'
               'Blocked Stock'
               'Blocked Stock Returns'
               'Valuated unrestricted-use stock'
               'Stock in Transfer in Previous Period'
               'Stock in Quality Inspection in Previous Period'
               'Restricted-Use Stock in Previous Period'
               'Blocked stock of previous period'
               'Blocked Stock Returns in Previous Period'
               'Storage Bin'
               'Total Valuated Stock'
               'Value of Total Valuated Stock'
               'Price'
               'value Unresticted'
               'Special stock number'
               'Sales Document'
               'Refresh File Date'
               'Value Of Quality Stock'
               'Subcon Vendor'
               'Refresh Time'
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.

*-----------------------------------------------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM gui_download .
*  TYPES : BEGIN OF ls_fieldname,
*            field_name(25),
*          END OF ls_fieldname.
*
*  DATA : it_fieldname TYPE TABLE OF ls_fieldname.
*  DATA : wa_fieldname TYPE ls_fieldname.
**----------------Fieldnames---------------------------------------------------------
*  wa_fieldname-field_name = 'Material.No.'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Material Desc'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Material Type'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Plant'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Storage loc'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Unrestricted-Use Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Stock in transfer '.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Stock in Quality Inspection'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Total Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked Stock Returns'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Valuated unrestricted-use stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Stock in Transfer in Previous Period'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Stock in Quality Inspection in Previous Period' .
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Restricted-Use Stock in Previous Period'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked stock of previous period'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked Stock Returns in Previous Period'.
*  APPEND wa_fieldname TO it_fieldname.
***--------------------------------------------------------------------*
*  wa_fieldname-field_name = 'Storage Bin'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Total Valuated Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Value of Total Valuated Stock'.             " 25/05/2018
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Price'.                   " 25/05/2018
*  APPEND wa_fieldname TO it_fieldname.
**--------------------------------------------------------------------*
*  wa_fieldname-field_name = 'Unresticted value'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Refresh File Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*
**--------------------------------------------------------------------*
*  DATA file TYPE string." VALUE 'F:\Zmb52.TXT'.
**BREAK primusabap.
*  IF p_werks = 'PL01'.
*    file = 'D:\ZMB52_PL01.TXT'.
*  ELSEIF p_werks = 'US01'.
*    file = 'D:\ZMB52_US01.TXT'.
*  ELSEIF p_werks = 'US02'.
*    file = 'D:\ZMB52_US02.TXT'.
*  ENDIF.
*
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
**     BIN_FILESIZE            =
*      filename                = file
*      filetype                = 'ASC'
**     APPEND                  = ' '
*      write_field_separator   = 'X'
**     HEADER                  = '00'
**     TRUNC_TRAILING_BLANKS   = ' '
**     WRITE_LF                = 'X'
**     COL_SELECT              = ' '
**     COL_SELECT_MASK         = ' '
**     DAT_MODE                = ' '
**     CONFIRM_OVERWRITE       = ' '
**     NO_AUTH_CHECK           = ' '
**     CODEPAGE                = ' '
**     IGNORE_CERR             = ABAP_TRUE
**     REPLACEMENT             = '#'
**     WRITE_BOM               = ' '
**     TRUNC_TRAILING_BLANKS_EOL       = 'X'
**     WK1_N_FORMAT            = ' '
**     WK1_N_SIZE              = ' '
**     WK1_T_FORMAT            = ' '
**     WK1_T_SIZE              = ' '
**     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
**     SHOW_TRANSFER_STATUS    = ABAP_TRUE
**     VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
** IMPORTING
**     FILELENGTH              =
*    TABLES
*      data_tab                = lt_final
*      fieldnames              = it_fieldname
*    EXCEPTIONS
*      file_write_error        = 1
*      no_batch                = 2
*      gui_refuse_filetransfer = 3
*      invalid_type            = 4
*      no_authority            = 5
*      unknown_error           = 6
*      header_not_allowed      = 7
*      separator_not_allowed   = 8
*      filesize_not_allowed    = 9
*      header_too_long         = 10
*      dp_error_create         = 11
*      dp_error_send           = 12
*      dp_error_write          = 13
*      unknown_dp_error        = 14
*      access_denied           = 15
*      dp_out_of_memory        = 16
*      disk_full               = 17
*      dp_timeout              = 18
*      file_not_found          = 19
*      dataprovider_exception  = 20
*      control_flush_error     = 21
*      OTHERS                  = 22.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*ENDFORM.
