*&---------------------------------------------------------------------*
*&Report: ZSU_CONSIGNMENT_REPORT
*&Transaction: ZSU_CONSIGNMENT
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZUS_CONSIGNMENT_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_CONSIGN_REPORT.
"MATNR KUNNR VBELN ERDAT

TABLES:VBAK,VBAP.
TYPES: BEGIN OF TY_CONSIGN,
         VBELN    TYPE VBAK-VBELN,
         POSNR_I  TYPE VBAP-POSNR,
         ERDAT    TYPE VBAP-ERDAT,
         AUART    TYPE VBAK-AUART,
         KUNNR    TYPE VBAK-KUNNR,
         MATNR_I  TYPE VBAP-MATNR,
         ARKTX_I  TYPE VBAP-ARKTX,
         KWMENG_I TYPE VBAP-KWMENG,
         WERKS_I  TYPE VBAP-WERKS,
         NETPR_I  TYPE VBAP-NETPR,
         NETWR_I  TYPE VBAP-NETWR,
       END OF TY_CONSIGN,

       BEGIN OF TY_LIPS,
         VBELN   TYPE LIPS-VBELN,
         POSNR_I TYPE LIPS-POSNR,
         MATNR_I   TYPE LIPS-MATNR,
         VGBEL_I TYPE LIPS-VGBEL,
         VGPOS_I TYPE LIPS-VGPOS,
         LFIMG_I TYPE LIPS-LFIMG,
         WERKS   TYPE LIPS-WERKS,
         PSTYV_I TYPE LIPS-PSTYV,
       END OF TY_LIPS,

       BEGIN OF TY_KNA1,
         KUNNR TYPE KNA1-KUNNR,
         NAME1 TYPE KNA1-NAME1,
       END OF TY_KNA1,

       BEGIN OF TY_MARA,
         MATNR   TYPE MARA-MATNR,
         MTART   TYPE MARA-MTART,
         WRKST   TYPE MARA-WRKST,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         BRAND   TYPE MARA-BRAND,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
       END OF TY_MARA,

       BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         LBKUM TYPE MBEW-LBKUM,
         SALK3 TYPE MBEW-SALK3,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
       END OF TY_MBEW,

       BEGIN OF TY_LIKP1, "Modified on 06-08-21 by PJ
         VBELN TYPE LIKP-VBELN,
         KUNNR TYPE LIKP-KUNNR,
       END OF TY_LIKP1,

       BEGIN OF TY_KNA11,
         KUNNR TYPE KNA1-KUNNR,
         LAND1 TYPE KNA1-LAND1,
         ORT01 TYPE KNA1-ORT01,
         REGIO TYPE KNA1-REGIO,
       END OF TY_KNA11,
*********************         END
         BEGIN OF TY_MSKU,
         MATNR TYPE MSKU-MATNR,
         WERKS TYPE MSKU-WERKS,
         CHARG TYPE MSKU-CHARG,
         SOBKZ TYPE MSKU-SOBKZ,
         KUNNR TYPE MSKU-KUNNR,
         LFGJA TYPE MSKU-LFGJA,
         KULAB TYPE MSKU-KULAB,
       END OF TY_MSKU,


       BEGIN OF TY_FINAL,
         VBELN    TYPE VBAP-VBELN,
         KUNNR    TYPE KNA1-KUNNR,
         NAME1    TYPE KNA1-NAME1,
         MATNR    TYPE VBAP-MATNR,
         TEXT     TYPE CHAR255,
         WRKST    TYPE MARA-WRKST,
         ARKTX    TYPE VBAP-ARKTX,
         ERDAT    TYPE VBAP-ERDAT,
         KWMENG   TYPE VBAP-KWMENG,
         LFIMG    TYPE LIPS-LFIMG,
         LFIMG1    TYPE LIPS-LFIMG,
         OPEN_QTY TYPE VBAP-KWMENG,
         PIC_QTY  TYPE LIPS-LFIMG,
         CON_QTY  TYPE LIPS-LFIMG,
         CON_RET  TYPE LIPS-LFIMG,
         CON_ISU  TYPE LIPS-LFIMG,
         NETPR    TYPE VBAP-NETPR,
         NETWR    TYPE VBAK-NETWR,
         BRAND    TYPE MARA-BRAND,
         ZSERIES  TYPE MARA-ZSERIES,
         ZSIZE    TYPE MARA-ZSIZE,
         MOC      TYPE MARA-MOC,
         TYPE     TYPE MARA-TYPE,
         WERKS    TYPE VBAP-WERKS,
         KBN      TYPE LIPS-LFIMG,
         KEN      TYPE LIPS-LFIMG,
         KAN      TYPE LIPS-LFIMG,
         KRN      TYPE LIPS-LFIMG,
         CON_VAL  TYPE VBAP-NETPR,
         LAND1    TYPE KNA1-LAND1, "Modified on 06-08-21 by PJ
         ORT01    TYPE KNA1-ORT01, "Modified on 06-08-21 by PJ
         REGIO    TYPE KNA1-REGIO, "Modified on 06-08-21 by PJ
*         REF_TIME TYPE CHAR15,
       END OF TY_FINAL,

       BEGIN OF TY_DOWN,
         KUNNR    TYPE CHAR15,
         NAME1    TYPE CHAR40,
         MATNR    TYPE CHAR20,
         TEXT     TYPE CHAR255,
         VBELN    TYPE CHAR15,
         ERDAT    TYPE CHAR15,
         KWMENG   TYPE CHAR15,
         LFIMG    TYPE CHAR15,
         PIC_QTY  TYPE CHAR15,
         CON_QTY  TYPE CHAR15,
         CON_RET  TYPE CHAR15,
         CON_ISU  TYPE CHAR15,
         OPEN_QTY TYPE CHAR15,
         NETPR    TYPE CHAR15,
         NETWR    TYPE CHAR15,
         BRAND    TYPE CHAR15,
         ZSERIES  TYPE CHAR15,
         ZSIZE    TYPE CHAR15,
         MOC      TYPE CHAR15,
         TYPE     TYPE CHAR15,
         WERKS    TYPE VBAP-WERKS,
         CON_VAL  TYPE CHAR20,
         LAND1    TYPE KNA1-LAND1, "Modified on 06-08-21 by PJ
         ORT01    TYPE KNA1-ORT01, "Modified on 06-08-21 by PJ
         REGIO    TYPE KNA1-REGIO, "Modified on 06-08-21 by PJ
         REF      TYPE CHAR15,
         REF_TIME TYPE CHAR15,
       END OF TY_DOWN.

DATA: IT_CONSIGN   TYPE TABLE OF TY_CONSIGN,
      WA_CONSIGN   TYPE            TY_CONSIGN,

      IT_RETURN    TYPE TABLE OF TY_CONSIGN,
      WA_RETURN    TYPE          TY_CONSIGN,

      IT_US12      TYPE TABLE OF TY_CONSIGN,
      WA_US12      TYPE          TY_CONSIGN,

      IT_US10      TYPE TABLE OF TY_CONSIGN,
      WA_US10      TYPE          TY_CONSIGN,

      IT_LIPS      TYPE TABLE OF TY_LIPS,
      WA_LIPS      TYPE          TY_LIPS,

      IT_LIPS_RET  TYPE TABLE OF TY_LIPS,
      WA_LIPS_RET  TYPE          TY_LIPS,

      IT_LIPS_US12 TYPE TABLE OF TY_LIPS,
      WA_LIPS_US12 TYPE          TY_LIPS,

      IT_LIPS_US10 TYPE TABLE OF TY_LIPS,
      WA_LIPS_US10 TYPE          TY_LIPS,

      IT_MARA      TYPE TABLE OF TY_MARA,
      WA_MARA      TYPE          TY_MARA,

      IT_MBEW      TYPE TABLE OF TY_MBEW,
      WA_MBEW      TYPE          TY_MBEW,

      IT_KNA1      TYPE TABLE OF TY_KNA1,
      WA_KNA1      TYPE          TY_KNA1,

      IT_FINAL     TYPE TABLE OF TY_FINAL,
      WA_FINAL     TYPE          TY_FINAL,

      IT_DOWN      TYPE TABLE OF TY_DOWN,
      WA_DOWN      TYPE          TY_DOWN,
      "Modified on 06-08-21 by PJ.
      IT_LIKP1     TYPE TABLE OF TY_LIKP1,
      WA_LIKP1     TYPE TY_LIKP1,

     IT_MSKU  TYPE TABLE OF TY_MSKU,
       WA_MSKU  TYPE          TY_MSKU,

      IT_KNA11     TYPE TABLE OF TY_KNA11,
      WA_KNA11     TYPE          TY_KNA11.


DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.
DATA : I_SORT  TYPE SLIS_T_SORTINFO_ALV,
       WA_SORT LIKE LINE OF I_SORT.


DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.
DATA :  gv_KBN      TYPE LIPS-LFIMG,
         gv_KEN      TYPE LIPS-LFIMG,
         gv_KAN      TYPE LIPS-LFIMG,
         gv_KRN      TYPE LIPS-LFIMG.



DATA:DATA TYPE STRING.
SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_VBELN FOR VBAP-VBELN,
                S_MATNR FOR VBAP-MATNR,
                S_KUNNR FOR VBAK-KUNNR,
                S_ERDAT FOR VBAP-ERDAT,
                S_WERKS FOR VBAP-WERKS OBLIGATORY DEFAULT 'SU01' NO INTERVALS MODIF ID BU.
*PARAMETERS :    p_werks TYPE vbap-werks DEFAULT 'US01'.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'. " 'E:\delval\Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM SORT_DATA.
  PERFORM GET_FCAT.
  PERFORM GET_DISPLAY.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
  SELECT VBELN
         POSNR_I
         ERDAT
         AUART
         KUNNR
         MATNR_I
         ARKTX_I
         KWMENG_I
         WERKS_I
         NETPR_I
         NETWR_I  FROM WB2_V_VBAK_VBAP2 INTO TABLE IT_CONSIGN
         WHERE VBELN IN S_VBELN
           AND MATNR_I IN S_MATNR
           AND KUNNR IN S_KUNNR
           AND ERDAT IN S_ERDAT
           AND WERKS_I IN S_WERKS
           AND AUART IN ( 'SU18', 'SU19','SU20','SU21' ).

  DELETE IT_CONSIGN WHERE WERKS_I = 'PL01'.
  DELETE IT_CONSIGN WHERE WERKS_I = 'US01'.
  IF IT_CONSIGN IS NOT INITIAL.

    SELECT MATNR
         WERKS
         CHARG
         SOBKZ
         KUNNR
         LFGJA
         KULAB FROM MSKU INTO TABLE IT_MSKU
        FOR ALL ENTRIES IN IT_CONSIGN
         WHERE matnr = IT_CONSIGN-MATNR_I
         and KUNNR = it_consign-kunnr
      and  werks = it_consign-WERKS_I.
*
*  SELECT vbeln
*         posnr_i
*         erdat
*         auart
*         kunnr
*         matnr_i
*         arktx_i
*         kwmeng_i
*         werks_i
*         netpr_i
*         netwr_i  FROM wb2_v_vbak_vbap2 INTO TABLE it_us10
*         FOR ALL ENTRIES IN it_consign
*         WHERE kunnr = it_consign-kunnr
*           AND matnr_i = it_consign-matnr_i
*           AND auart = 'US10'.
*
*   SELECT vbeln
*         posnr_i
*         erdat
*         auart
*         kunnr
*         matnr_i
*         arktx_i
*         kwmeng_i
*         werks_i
*         netpr_i
*         netwr_i  FROM wb2_v_vbak_vbap2 INTO TABLE it_return
*         FOR ALL ENTRIES IN it_consign
*         WHERE kunnr = it_consign-kunnr
*           AND matnr_i = it_consign-matnr_i
*           AND auart = 'US11'.
*
*     SELECT vbeln
*         posnr_i
*         erdat
*         auart
*         kunnr
*         matnr_i
*         arktx_i
*         kwmeng_i
*         werks_i
*         netpr_i
*         netwr_i  FROM wb2_v_vbak_vbap2 INTO TABLE it_us12
*         FOR ALL ENTRIES IN it_consign
*         WHERE kunnr = it_consign-kunnr
*           AND matnr_i = it_consign-matnr_i
*           AND auart = 'US12'.
************   MODIFIED BY PJ ON 06-08-21
*    SELECT VBELN
*           KUNNR FROM LIKP
*      INTO TABLE IT_LIKP1
*      FOR ALL ENTRIES IN it_consign
*      WHERE vbeln = it_consign-vbeln.
*
*      IF IT_LIKP1 IS NOT INITIAL.
    SELECT KUNNR LAND1 ORT01 REGIO FROM KNA1
      INTO TABLE IT_KNA11
      FOR ALL ENTRIES IN IT_CONSIGN
      WHERE KUNNR = IT_CONSIGN-KUNNR.

*      ENDIF.

*********END OF SELECTION*******
    SELECT VBELN
           POSNR_I
           MATNR_I
           VGBEL_I
           VGPOS_I
           LFIMG_I
           WERKS
           PSTYV_I  FROM WB2_V_LIKP_LIPS2 INTO TABLE IT_LIPS
           FOR ALL ENTRIES IN IT_CONSIGN
           WHERE VGBEL_I = IT_CONSIGN-VBELN
             AND VGPOS_I = IT_CONSIGN-POSNR_I.

    SELECT MATNR
           MTART
           WRKST
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE    FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_CONSIGN
           WHERE MATNR = IT_CONSIGN-MATNR_I.

    SELECT MATNR
           BWKEY
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS FROM MBEW INTO TABLE IT_MBEW
           FOR ALL ENTRIES IN IT_CONSIGN
           WHERE MATNR = IT_CONSIGN-MATNR_I
             AND BWKEY = IT_CONSIGN-WERKS_I.





    SELECT KUNNR
           NAME1 FROM KNA1 INTO TABLE IT_KNA1
           FOR ALL ENTRIES IN IT_CONSIGN
           WHERE KUNNR = IT_CONSIGN-KUNNR.

  ENDIF.
*IF it_return IS NOT INITIAL.
*    SELECT vbeln
*           posnr_i
*           vgbel_i
*           vgpos_i
*           lfimg_i
*           werks
*           pstyv_i  FROM wb2_v_likp_lips2 INTO TABLE it_lips_ret
*           FOR ALL ENTRIES IN it_return
*           WHERE vgbel_i = it_return-vbeln
*             AND vgpos_i = it_return-posnr_i.
*ENDIF.
*
*IF it_us12 IS NOT INITIAL.
*    SELECT vbeln
*           posnr_i
*           vgbel_i
*           vgpos_i
*           lfimg_i
*           werks
*           pstyv_i FROM wb2_v_likp_lips2 INTO TABLE it_lips_us12
*           FOR ALL ENTRIES IN it_us12
*           WHERE vgbel_i = it_us12-vbeln
*             AND vgpos_i = it_us12-posnr_i.
*ENDIF.
*
*IF it_us10 IS NOT INITIAL.
*    SELECT vbeln
*           posnr_i
*           vgbel_i
*           vgpos_i
*           lfimg_i
*           werks
*           pstyv_i  FROM wb2_v_likp_lips2 INTO TABLE it_lips_us10
*           FOR ALL ENTRIES IN it_us10
*           WHERE vgbel_i = it_us10-vbeln
*             AND vgpos_i = it_us10-posnr_i.
*ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_DATA .
  SORT IT_CONSIGN BY KUNNR MATNR_I.
*  BREAK PRIMUS.
  DATA :VALUE TYPE P DECIMALS 8.
  SORT IT_CONSIGN BY VBELN.
  LOOP AT IT_CONSIGN INTO WA_CONSIGN.
    WA_FINAL-VBELN = WA_CONSIGN-VBELN.
    WA_FINAL-KUNNR = WA_CONSIGN-KUNNR.
    WA_FINAL-MATNR = WA_CONSIGN-MATNR_I.
    WA_FINAL-NETPR = WA_CONSIGN-NETPR_I.
    WA_FINAL-NETWR = WA_CONSIGN-NETWR_I.
    WA_FINAL-ARKTX = WA_CONSIGN-ARKTX_I.
    WA_FINAL-ERDAT = WA_CONSIGN-ERDAT.

    WA_FINAL-WERKS  = WA_CONSIGN-WERKS_I.
    IF WA_CONSIGN-AUART = 'SU18'.
      WA_FINAL-KWMENG = WA_CONSIGN-KWMENG_I.
    ENDIF.
*    READ TABLE it_lips INTO wa_lips WITH KEY vgbel_i = wa_consign-vbeln vgpos_i = wa_consign-posnr_i.
*    IF sy-subrc = 0.
*      wa_final-lfimg = wa_lips-lfimg_i.
*    ENDIF.

*    READ TABLE IT_MSKU INTO WA_MSKU with KEY MATNR = WA_CONSIGN-MATNR_I.
**                                         and KUNNR = WA_CONSIGN-KUNNR.
*    if sy-subrc is INITIAL.
*       WA_FINAL-CON_QTY = WA_MSKU-KULAB.
*    endif.


    LOOP AT IT_LIPS INTO WA_LIPS WHERE VGBEL_I = WA_CONSIGN-VBELN AND VGPOS_I = WA_CONSIGN-POSNR_I.

      IF WA_CONSIGN-AUART = 'SU18'..
        WA_FINAL-LFIMG = WA_FINAL-LFIMG + WA_LIPS-LFIMG_I.

      ENDIF.

      IF WA_CONSIGN-AUART = 'SU20'.
        WA_FINAL-PIC_QTY = WA_FINAL-PIC_QTY + WA_LIPS-LFIMG_I.
*         WA_FINAL-OPEN_QTY = WA_FINAL-KWMENG - WA_FINAL-LFIMG.
      ENDIF.
      IF WA_CONSIGN-AUART = 'SU21  '..
        WA_FINAL-CON_RET = WA_FINAL-CON_RET + WA_LIPS-LFIMG_I.
      ENDIF.

      IF WA_CONSIGN-AUART = 'SU19'.
        WA_FINAL-CON_ISU = WA_FINAL-CON_ISU + WA_LIPS-LFIMG_I.
      ENDIF.
        WA_FINAL-LFIMG1 = WA_FINAL-LFIMG1 + WA_LIPS-LFIMG_I.


*      CASE WA_LIPS-PSTYV_I.
*        WHEN 'KBN'.
*          WA_FINAL-KBN = WA_FINAL-KBN + WA_LIPS-LFIMG_I.
*          gv_kbn = WA_FINAL-KBN.
*        WHEN 'KAN' .
*          WA_FINAL-KAN = WA_FINAL-KAN + WA_LIPS-LFIMG_I.
*           gv_kan = WA_FINAL-KaN.
*        WHEN 'KEN'.
*          WA_FINAL-KEN = WA_FINAL-KEN + WA_LIPS-LFIMG_I.
*           gv_ken = WA_FINAL-KeN.
*        WHEN 'KRN'.
*          WA_FINAL-KRN = WA_FINAL-KRN + WA_LIPS-LFIMG_I.
*           gv_krn = WA_FINAL-KrN.
*      ENDCASE.



    ENDLOOP.
    LOOP AT IT_LIPS INTO WA_LIPS WHERE matnr_i = WA_CONSIGN-MATNR_I.

         CASE WA_LIPS-PSTYV_I.
        WHEN 'KBN'.
          WA_FINAL-KBN = WA_FINAL-KBN + WA_LIPS-LFIMG_I.
          gv_kbn = WA_FINAL-KBN.
        WHEN 'KAN' .
          WA_FINAL-KAN = WA_FINAL-KAN + WA_LIPS-LFIMG_I.
           gv_kan = WA_FINAL-KaN.
        WHEN 'KEN'.
          WA_FINAL-KEN = WA_FINAL-KEN + WA_LIPS-LFIMG_I.
           gv_ken = WA_FINAL-KeN.
        WHEN 'KRN'.
          WA_FINAL-KRN = WA_FINAL-KRN + WA_LIPS-LFIMG_I.
           gv_krn = WA_FINAL-KrN.
      ENDCASE.
   endloop.

 WA_FINAL-OPEN_QTY = WA_CONSIGN-KWMENG_I - WA_FINAL-LFIMG1.
     IF WA_CONSIGN-AUART = 'SU18'.
        WA_FINAL-CON_QTY = WA_FINAL-KBN.
    ENDIF.
    IF WA_CONSIGN-AUART = 'SU19'.
     WA_FINAL-CON_QTY = gv_kbn - WA_FINAL-KEN .
     ENDIF.

      IF WA_CONSIGN-AUART = 'SU20'.
      WA_FINAL-CON_QTY = gv_kbn - gv_ken + WA_FINAL-KRN .
      ENDIF.
       IF WA_CONSIGN-AUART = 'SU21  '..
          WA_FINAL-CON_QTY = gv_kbn - gv_ken + gv_krn - WA_FINAL-KAN.
      ENDIF.


* WA_FINAL-CON_QTY = WA_FINAL-LFIMG1.
*    WA_FINAL-OPEN_QTY = WA_FINAL-KWMENG - WA_FINAL-LFIMG.
    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_CONSIGN-MATNR_I.
    IF SY-SUBRC = 0.
      WA_FINAL-WRKST   = WA_MARA-WRKST.
      WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
      WA_FINAL-ZSIZE   = WA_MARA-ZSIZE.
      WA_FINAL-BRAND   = WA_MARA-BRAND.
      WA_FINAL-MOC     = WA_MARA-MOC.
      WA_FINAL-TYPE    = WA_MARA-TYPE   .

    ENDIF.

    READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_CONSIGN-KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,WA_LINES,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LV_LINES
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-TEXT WA_LINES-TDLINE INTO WA_FINAL-TEXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.

    ENDIF.

*    LOOP AT it_return INTO wa_return WHERE kunnr = wa_consign-kunnr AND matnr_i = wa_consign-matnr_i.
*      READ TABLE it_lips_ret INTO wa_lips_ret WITH KEY vgbel_i = wa_return-vbeln vgpos_i = wa_return-posnr_i.
*        IF sy-subrc = 0.
*
*
*          CASE wa_lips_ret-pstyv_i.
*           WHEN 'KBN'.
*            wa_final-kbn = wa_final-kbn + wa_lips_ret-lfimg_i.
*           WHEN 'KAN' .
*            wa_final-kan = wa_final-kan + wa_lips_ret-lfimg_i.
*           WHEN 'KEN'.
*            wa_final-ken = wa_final-ken + wa_lips_ret-lfimg_i.
*          ENDCASE.
*
*        ENDIF.
*    ENDLOOP.

*    wa_final-con_qty = wa_final-lfimg + wa_final-pic_qty.

*    LOOP AT it_us12 INTO wa_us12 WHERE kunnr = wa_consign-kunnr AND matnr_i = wa_consign-matnr_i.
*      READ TABLE it_lips_us12 INTO wa_lips_us12 WITH KEY vgbel_i = wa_us12-vbeln vgpos_i = wa_us12-posnr_i.
*        IF sy-subrc = 0.
*
*
*          CASE wa_lips_us12-pstyv_i.
*           WHEN 'KBN'.
*            wa_final-kbn = wa_final-kbn + wa_lips_us12-lfimg_i.
*           WHEN 'KAN' .
*            wa_final-kan = wa_final-kan + wa_lips_us12-lfimg_i.
*           WHEN 'KEN'.
*            wa_final-ken = wa_final-ken + wa_lips_us12-lfimg_i.
*          ENDCASE.
*
*
*        ENDIF.
*    ENDLOOP.
*    wa_final-con_qty = wa_final-con_qty - wa_final-con_ret.

*CONCATENATE wa_consign-kunnr wa_consign-matnr_i INTO data.
*ON CHANGE OF data.
*    LOOP AT it_us10 INTO wa_us10 WHERE kunnr = wa_consign-kunnr AND matnr_i = wa_consign-matnr_i.
*      READ TABLE it_lips_us10 INTO wa_lips_us10 WITH KEY vgbel_i = wa_us10-vbeln vgpos_i = wa_us10-posnr_i.
*        IF sy-subrc = 0.
*
*
*          CASE wa_lips_us10-pstyv_i.
*           WHEN 'KBN'.
*            wa_final-kbn = wa_final-kbn + wa_lips_us10-lfimg_i.
*           WHEN 'KAN' .
*            wa_final-kan = wa_final-kan + wa_lips_us10-lfimg_i.
*           WHEN 'KEN'.
*            wa_final-ken = wa_final-ken + wa_lips_us10-lfimg_i.
*          ENDCASE.
*
*        ENDIF.
*    ENDLOOP.
*endon.
*    wa_final-con_qty = wa_final-con_qty - wa_final-con_isu.
*    WA_FINAL-CON_QTY = WA_FINAL-KBN - WA_FINAL-KAN - WA_FINAL-KEN + WA_FINAL-CON_RET.

    CLEAR VALUE.
    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_FINAL-MATNR BWKEY = WA_FINAL-WERKS.
    IF SY-SUBRC = 0.
      VALUE = WA_MBEW-SALK3 / WA_MBEW-LBKUM.
    ENDIF.

    WA_FINAL-CON_VAL = ( WA_FINAL-CON_QTY * VALUE ) + ( WA_FINAL-PIC_QTY * VALUE ).

*    IF wa_final-con_qty < 0.
*      wa_final-con_qty = 0.
*    ENDIF.
*    READ TABLE it_likp1 INTO wa_likp1 WITH KEY vbeln = wa_consign-vbeln.
*
*    IF sy-subrc = 0.
    READ TABLE IT_KNA11 INTO WA_KNA11 WITH KEY KUNNR = WA_CONSIGN-KUNNR.

    IF SY-SUBRC  = 0.
      WA_FINAL-LAND1 = WA_KNA11-LAND1.
      WA_FINAL-ORT01 = WA_KNA11-ORT01.
      WA_FINAL-REGIO = WA_KNA11-REGIO.




    ENDIF.

*    ENDIF.
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR :WA_FINAL,VALUE.
  ENDLOOP.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-KUNNR     = WA_FINAL-KUNNR   .
      WA_DOWN-NAME1     = WA_FINAL-NAME1   .
      WA_DOWN-MATNR     = WA_FINAL-MATNR   .
      WA_DOWN-TEXT      = WA_FINAL-TEXT    .
      WA_DOWN-VBELN     = WA_FINAL-VBELN   .
      WA_DOWN-WERKS     = WA_FINAL-WERKS   .
*    wa_down-ERDAT     = wa_final-ERDAT   .

      IF WA_FINAL-ERDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-ERDAT
          IMPORTING
            OUTPUT = WA_DOWN-ERDAT.

        CONCATENATE WA_DOWN-ERDAT+0(2) WA_DOWN-ERDAT+2(3) WA_DOWN-ERDAT+5(4)
                        INTO WA_DOWN-ERDAT SEPARATED BY '-'.
      ENDIF.




      WA_DOWN-KWMENG    = WA_FINAL-KWMENG  .
      WA_DOWN-LFIMG     = WA_FINAL-LFIMG   .
      WA_DOWN-PIC_QTY   = ABS( WA_FINAL-PIC_QTY ).
      WA_DOWN-CON_QTY   = ABS( WA_FINAL-CON_QTY ).
      WA_DOWN-CON_RET   = ABS( WA_FINAL-CON_RET ) .
      WA_DOWN-CON_ISU   = ABS( WA_FINAL-CON_ISU ).
      WA_DOWN-OPEN_QTY  = ABS( WA_FINAL-OPEN_QTY ).

*    wa_down-MATNR    = wa_final-MATNR  .
      WA_DOWN-NETPR    = WA_FINAL-NETPR  .
      WA_DOWN-NETWR    = ABS( WA_FINAL-NETWR )  .
      WA_DOWN-BRAND    = WA_FINAL-BRAND  .
      WA_DOWN-ZSERIES  = WA_FINAL-ZSERIES.
      WA_DOWN-ZSIZE    = WA_FINAL-ZSIZE  .
      WA_DOWN-MOC      = WA_FINAL-MOC    .
      WA_DOWN-TYPE     = WA_FINAL-TYPE   .
      WA_DOWN-CON_VAL     = ABS( WA_FINAL-CON_VAL ) .


      IF WA_FINAL-CON_VAL < 0.
        CONDENSE WA_DOWN-CON_VAL.
        CONCATENATE '-' WA_DOWN-CON_VAL INTO WA_DOWN-CON_VAL.
      ENDIF.

      IF WA_FINAL-NETWR < 0.
        CONDENSE WA_DOWN-NETWR.
        CONCATENATE '-' WA_DOWN-NETWR INTO WA_DOWN-NETWR.
      ENDIF.


      IF WA_FINAL-CON_RET < 0.
        CONDENSE WA_DOWN-CON_RET.
        CONCATENATE '-' WA_DOWN-CON_RET INTO WA_DOWN-CON_RET.
      ENDIF.

      IF WA_FINAL-CON_ISU < 0.
        CONDENSE WA_DOWN-CON_ISU.
        CONCATENATE '-' WA_DOWN-CON_ISU INTO WA_DOWN-CON_ISU.
      ENDIF.


      IF WA_FINAL-PIC_QTY < 0.
        CONDENSE WA_DOWN-PIC_QTY.
        CONCATENATE '-' WA_DOWN-PIC_QTY INTO WA_DOWN-PIC_QTY.
      ENDIF.

      IF WA_FINAL-CON_QTY < 0.
        CONDENSE WA_DOWN-CON_QTY.
        CONCATENATE '-' WA_DOWN-CON_QTY INTO WA_DOWN-CON_QTY.
      ENDIF.

      IF WA_FINAL-OPEN_QTY < 0.
        CONDENSE WA_DOWN-OPEN_QTY.
        CONCATENATE '-' WA_DOWN-OPEN_QTY INTO WA_DOWN-OPEN_QTY.
      ENDIF.
      WA_DOWN-LAND1    = WA_FINAL-LAND1.
      WA_DOWN-ORT01    = WA_FINAL-ORT01.
      WA_DOWN-REGIO    = WA_FINAL-REGIO.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.
      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.


      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
  PERFORM FCAT USING :   '1'   'KUNNR'           'IT_FINAL'      'Customer'                 ' '      '20' ,
                         '2'   'NAME1'           'IT_FINAL'      'Customer Name '           ' '        '20' ,
                         '3'   'MATNR'           'IT_FINAL'      'Material'                 ' '      '20',
                         '4'   'TEXT'            'IT_FINAL'      'Long Description'         ' '         '20' ,
                         '5'   'VBELN'           'IT_FINAL'      'Document No'              ' '       '10',
                         '6'   'ERDAT'           'IT_FINAL'      'Document Date'            ' '     '20' ,
                         '7'   'KWMENG'          'IT_FINAL'      'Unrestricted SO Qty'      'X'    '20',
                         '8'   'LFIMG'           'IT_FINAL'      'Fill Up Qty'              'X'        '20',
                         '9'  'CON_ISU'         'IT_FINAL'      'Cons Issue Qty'           'X'           '20',
                         '10'   'PIC_QTY'         'IT_FINAL'      'Con Return Qty'              'X'        '20',
                          '11'  'CON_RET'         'IT_FINAL'      'Con Pick Up Qty'          'X'            '20',
                         '12'  'CON_QTY'         'IT_FINAL'      'Consignment Qty'          'X'            '20',
                         '13'  'OPEN_QTY'        'IT_FINAL'      'Open Qty'                 'X' '20',
*                         '14'  'MATNR'           'IT_FINAL'      'Item Code'                    '20',
                         '14'  'NETPR'           'IT_FINAL'      'Unit Rate'                'X' '20',
                         '15'  'NETWR'           'IT_FINAL'      'Total Value'              'X'  '20',
                         '16'  'BRAND'           'IT_FINAL'      'BRAND'                    ' '    '10',
                         '17'  'ZSERIES'         'IT_FINAL'      'SERIES'                   ' '    '10',
                         '18'  'ZSIZE'           'IT_FINAL'      'SIZE'                     ' '    '10',
                         '19'  'MOC'             'IT_FINAL'      'MOC'                      ' '   '10',
                         '20'  'TYPE'            'IT_FINAL'      'TYPE'                     ' '    '10',
                         '21'  'WERKS'            'IT_FINAL'      'Plant'                   ' '    '10',
                         '22'  'CON_VAL'          'IT_FINAL'      'Consignment Value'       ' '    '20',
                         '23'   'LAND1'           'IT_FINAL'      'Country'                 ' '    '15' , "Modifies by PJ on 06-08-21
                         '24'   'ORT01'           'IT_FINAL'      'City'                    ' '    '15' , "Modifies by PJ on 06-08-21
                         '25'   'REGIO'           'IT_FINAL'      'Region'                  ' '    '15'. "Modifies by PJ on 06-08-21
*                         '26'   'REF_TIME'           'IT_FINAL'      'Refresh Time'                  ' '    '15'.  "Modifies by PJ on 06-08-21.





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0563   text
*      -->P_0564   text
*      -->P_0565   text
*      -->P_0566   text
*      -->P_0567   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5)
                    VALUE(P6).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-DO_SUM     = P5.
  WA_FCAT-OUTPUTLEN   = P6.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
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
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
      IT_SORT            = I_SORT
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
      I_SAVE             = 'X'
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
      T_OUTTAB           = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.

  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .


  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZSU_CONSMNT.TXT'.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_CONSIGNMENT REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1005 TYPE string.
DATA lv_crlf_1005 TYPE string.
lv_crlf_1005 = cl_abap_char_utilities=>cr_lf.
lv_string_1005 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1005 lv_crlf_1005 wa_csv INTO lv_string_1005.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
TRANSFER lv_string_1005 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

********************************************************************************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZUS_CONSMNT.TXT'.


  CONCATENATE P_FOLDER '/'  LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUS_CONSIGNMENT REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1043 TYPE string.
DATA lv_crlf_1043 TYPE string.
lv_crlf_1043 = cl_abap_char_utilities=>cr_lf.
lv_string_1043 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1043 lv_crlf_1043 wa_csv INTO lv_string_1043.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
TRANSFER lv_string_1043 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Customer'
              'Customer Name '
              'Material'
              'Long Description'
              'Document No'
              'Document Date'
              'Unrestricted SO Qty'
              'Fill Up Qty'
              'Con Return Qty'
              'Consignment Qty'
              'Con Pick Up Qty'
              'Cons Issue Qty'
              'Open Qty'
              'Unit Rate'
              'Total Value'
              'BRAND'
              'SERIES'
              'SIZE'
              'MOC'
              'TYPE'
              'Plant'
              'Consignment Value'
              'Country'
              'City'
              'Region'
              'Refresh Date'
              'Refresh Time'
               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
