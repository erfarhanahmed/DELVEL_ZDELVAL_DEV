*&---------------------------------------------------------------------*
*& Report ZPROFARMA_DRIVER_PGM1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPROFARMA_DRIVER_PGM1.

*


*&---------------------------------------------------------------------*
*& Report ZORDER_CONFIRM_PROG                                                *
*&*&* 1.PROGRAM OWNER       : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : SMARTFROM DEVLOPMENT
* 3.PROGRAM NAME            :                         *
* 4.TRANS CODE              :                                    *
* 5.MODULE NAME             : SD.                                 *
* 6.REQUEST NO              :                                *
* 7.CREATION DATE           :                               *
* 8.CREATED BY              :                           *
* 9.FUNCTIONAL CONSULTANT   :                                    *
* 10.BUSINESS OWNER         : DELVAL.                                *
*&---------------------------------------------------------------------*

TABLES: NAST,                          "Messages
        *NAST,                         "Messages
        TNAPR,                         "Programs & Forms
        ITCPO,                         "Communicationarea for Spool
        ARC_PARAMS,                    "Archive parameters
        TOA_DARA,                      "Archive parameters
        ADDR_KEY,                      "Adressnumber for ADDRESS
        VBAK.

INCLUDE ZPROFARMA_INVC.
*INCLUDE zorder_confirm.

DATA : SO_CODE LIKE VBAK-VBELN.
DATA : BASIC_AMT TYPE P DECIMALS 2.
DATA : TOTAL TYPE P DECIMALS 2.
DATA : ZKBETR TYPE PRCD_ELEMENTS-KBETR.
DATA : HTEXT(40) TYPE C.
DATA : LV_LINES1 TYPE TLINE.
DATA : LV_MEMO TYPE TLINE.
DATA : LV_INSURANCE TYPE TLINE.
DATA : LV_MOD TYPE TLINE.
DATA : LV_DOCT TYPE TLINE.           " DOCUMENTS THROUGH
DATA : LV_SINST TYPE TLINE.          " SPECIAL INSTRUCTION
DATA : LV_LDDATE TYPE TLINE.
DATA : V_AMT TYPE CHAR100.
DATA : GRAND_TOTAL  TYPE P DECIMALS 2.
DATA : JOIG TYPE STRING.
DATA : TOT_QTY TYPE VBAP-KWMENG.
DATA : JOCG_AMT TYPE P DECIMALS 2.
DATA : JOSG_AMT TYPE P DECIMALS 2.
data: LV_AMT_IN_WORD TYPE char255.
data: IN_WORDS TYPE SPELL.
data: GVPODT1 TYPE string.
Data : gv_tot_lines          TYPE i.
DATA : GS_CTRLOP  TYPE SSFCTRLOP,
       GS_OUTOPT  TYPE SSFCOMPOP,
       GS_OTFDATA TYPE SSFCRESCL.
DATA: LS_JOB_INFO  TYPE SSFCRESCL.
DATA: LV_VAR TYPE STRING.

DATA : CONTROL         TYPE SSFCTRLOP.
DATA : OUTPUT_OPTIONS  TYPE SSFCOMPOP.
DATA:   RETCODE   LIKE SY-SUBRC.         "Returncode
DATA:   XSCREEN(1) TYPE C.               "Output on printer or screen
DATA:   REPEAT(1) TYPE C.
DATA: NAST_ANZAL LIKE NAST-ANZAL.      "Number of outputs (Orig. + Cop.)
DATA: NAST_TDARMOD LIKE NAST-TDARMOD.  "Archiving only one time

DATA: GF_LANGUAGE LIKE SY-LANGU.
DATA: SO_DOC_EXP    LIKE     VBCO3.
data:  gs_con_settings       TYPE ssfctrlop.

DATA: LS_CONTROL_PARAM      TYPE SSFCTRLOP.
DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.


 DATA AMT_IN_NUM   TYPE PC207-BETRG.
DATA AMT_WORDS(100) TYPE C.
DATA : ls_word TYPE spell.
DATA : DECWORD TYPE spell.
DATA: AMT_WORD TYPE CHAR255.





*data: gs_con_settings       TYPE ssfctrlop.
FORM ENTRY  USING RETURN_CODE US_SCREEN.
*  break primus.
  CLEAR RETCODE.
  XSCREEN = US_SCREEN.

  PERFORM PROCESSING USING US_SCREEN.
  CASE RETCODE.
    WHEN 0.
      RETURN_CODE = 0.
    WHEN 3.
      RETURN_CODE = 3.
    WHEN OTHERS.
      RETURN_CODE = 1.
  ENDCASE.
ENDFORM.

FORM PROCESSING USING US_SCREEN.

  SO_DOC_EXP-SPRAS = 'E'.
  SO_DOC_EXP-VBELN = NAST-OBJKY.

  SO_CODE = NAST-OBJKY.
  PERFORM CLEAR.
  PERFORM GET_DATA.         "SELECT QUERIES
  PERFORM PROCESS_DATA.
  PERFORM GRANDWORDS.
  PERFORM GET_OFMDATE.
  PERFORM GET_MEMO.
  PERFORM GET_INSURANCE.
  PERFORM GET_MOD.
  PERFORM GET_DOCT.
  PERFORM GET_SINST.
  PERFORM GET_LDDATE.
  PERFORM SMARTFROM_DATA.

ENDFORM.

FORM GET_DATA .


  SELECT VBELN
         KNUMV
         KUNRG
         BSTNK_VF
         FKDAT
     FROM VBRK
     INTO TABLE IT_VBRK
     WHERE VBELN = SO_CODE .

  IF IT_VBRK IS NOT INITIAL.
    SELECT KUNNR
           NAME1
           TELF1
           PSTLZ
           STRAS
           ORT01
           STCD3
      FROM KNA1
      INTO TABLE IT_KNA12
      FOR ALL ENTRIES IN IT_VBRK
   WHERE KUNNR  = IT_VBRK-KUNRG.

*
*    SELECT
*      vbeln
*      bstkd
*      bstdk
*      INCO1
*      FROM vbkd
*      INTO  TABLE it_vbkd
*      FOR ALL ENTRIES IN it_vbrk
*      WHERE vbeln EQ it_vbrk-vbeln.

    SELECT KUNNR
           KNUMV
           KPOSN
           KSCHL
           KBETR
           KNTYP
           KWERT
           KAWRT
*         kwert1
        FROM PRCD_ELEMENTS
        INTO TABLE IT_KONV
        FOR ALL ENTRIES IN IT_VBRK
        WHERE KNUMV EQ IT_VBRK-KNUMV.

    SELECT VBELN
           posnr
           ARKTX
           FKIMG
           MATNR
           AUBEL
      FROM VBRP INTO TABLE IT_VBRP
      FOR ALL ENTRIES IN IT_VBRK
      WHERE VBELN = IT_VBRK-VBELN.

  ENDIF.

  IF IT_VBRP IS NOT INITIAL.
    SELECT VBELN
           BSTKD
           BSTDK
           INCO1
           ZTERM
      FROM VBKD INTO  TABLE IT_VBKD
    FOR ALL ENTRIES IN IT_VBRP
    WHERE VBELN = IT_VBRP-AUBEL.


    SELECT MATNR
           STEUC
      FROM MARC INTO TABLE IT_MARC
      FOR ALL ENTRIES IN IT_VBRP
      WHERE  MATNR = IT_VBRP-MATNR.
  ENDIF.
  IF IT_VBKD IS NOT INITIAL.
    SELECT ZTERM
           VTEXT
           SPRAS
      FROM TVZBT
      INTO TABLE IT_TVZBT
      FOR ALL ENTRIES IN IT_VBKD
      WHERE ZTERM EQ IT_VBKD-ZTERM AND
      SPRAS = 'E'.
  ENDIF.

ENDFORM.

FORM PROCESS_DATA .


*  LOOP AT it_vbrk INTO wa_vbrk.
  LOOP AT IT_VBRP INTO WA_VBRP.
    WA_FINAL-VBELN   = WA_VBRP-VBELN.
    wa_final-SR_NO =   SY-TABIX.
    WA_FINAL-ARKTX   = WA_VBRP-ARKTX .
    WA_FINAL-AUBEL   = WA_VBRP-AUBEL .
    WA_FINAL-FKIMG = WA_VBRP-FKIMG.
    WA_FINAL-matnr = WA_VBRP-matnr.
*
*    READ TABLE it_vbkd INTO wa_vbkd WITH  KEY vbeln = wa_final-vbeln BINARY SEARCH.
*    IF sy-subrc EQ 0 .
*      wa_final-vbeln = wa_vbkd-vbeln.
*      wa_final-bstkd = wa_vbkd-bstkd.
*      wa_final-bstdk = wa_vbkd-bstdk.
*    ENDIF.

    READ TABLE IT_VBRK INTO WA_VBRK WITH  KEY VBELN = WA_FINAL-VBELN BINARY SEARCH.
* LOOP AT IT_VBAP INTO WA_VBAP.
    IF SY-SUBRC EQ 0.
      WA_FINAL-VBELN2 = WA_VBRK-VBELN.
      WA_FINAL-FKDAT = WA_VBRK-FKDAT.
      WA_FINAL-BSTNK = WA_VBRK-BSTNK_VF.
      WA_FINAL-BASIC_AMT = WA_FINAL-BASIC_AMT + WA_FINAL-NETWR .
    ENDIF.
    READ TABLE IT_KNA12 INTO WA_KNA12 WITH KEY KUNNR = WA_VBRK-KUNRG BINARY SEARCH.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_KNA12-KUNNR.
      WA_FINAL-NAME12 = WA_KNA12-NAME1.
      WA_FINAL-TELF12 = WA_KNA12-TELF1.
      WA_FINAL-PSTLZ1 = WA_KNA12-PSTLZ.
      WA_FINAL-STRAS1 = WA_KNA12-STRAS.
      WA_FINAL-ORT012 = WA_KNA12-ORT01.
      WA_FINAL-STCD31 = WA_KNA12-STCD3.
    ENDIF.

    READ TABLE IT_KNA12 INTO WA_KNA12 WITH KEY KUNNR = WA_FINAL-KUNNR.
    IF SY-SUBRC EQ 0 .
      WA_FINAL-KUNNR = WA_KNA1-KUNNR.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
      WA_FINAL-NAME2 = WA_KNA1-NAME2.
      WA_FINAL-TELF1 = WA_KNA1-TELF1.
      WA_FINAL-PSTLZ = WA_KNA1-PSTLZ.
      WA_FINAL-STRAS = WA_KNA1-STRAS.
      WA_FINAL-ORT01 = WA_KNA1-ORT01.
      WA_FINAL-STCD3 = WA_KNA1-STCD3.
    ENDIF.

    READ TABLE IT_VBFA INTO WA_VBFA WITH KEY VBELV = WA_FINAL-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELV = WA_VBFA-VBELV.
      WA_FINAL-VBELN1 = WA_VBFA-VBELN1.
      WA_FINAL-VBTYP_N = WA_VBFA-VBTYP_N.
    ENDIF.



    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_FINAL-AUBEL BINARY SEARCH.
    IF SY-SUBRC = 0.
*      wa_final-vbeln = wa_vbkd-vbeln.
      WA_FINAL-ZTERM = WA_VBKD-ZTERM.
      WA_FINAL-INCO1 = WA_VBKD-INCO1.
      WA_FINAL-BSTKD = WA_VBKD-BSTKD.
      WA_FINAL-BSTDK = WA_VBKD-BSTDK.


      DATA : VDT(2) TYPE C,VMN(2) TYPE C,VYR(4) TYPE C.


 VDT = WA_FINAL-BSTDK+6(2).
 VMN = WA_FINAL-BSTDK+4(2).
 VYR = WA_FINAL-BSTDK+0(4).

 CONCATENATE VYR '-' VMN '-' VDT INTO GVPODT1.

    ENDIF.

    READ TABLE IT_TVZBT INTO WA_TVZBT WITH KEY ZTERM = WA_FINAL-ZTERM.
    IF SY-SUBRC = 0.
      WA_FINAL-ZTERM = WA_TVZBT-ZTERM.
      WA_FINAL-VTEXT = WA_TVZBT-VTEXT.
    ENDIF.

*    READ TABLE IT_VBRP INTO WA_VBRP WITH  KEY ARKTX = WA_FINAL-ARKTX.
*    READ TABLE IT_VBRP INTO WA_VBRP WITH  KEY matnr = WA_FINAL-matnr."added by jyoti
*    IF SY-SUBRC = 0 .
*      WA_FINAL-ARKTX = WA_VBRP-ARKTX.
*
*
*    ENDIF.

*    READ TABLE IT_MARC INTO WA_MARC WITH  KEY STEUC = WA_FINAL-STEUC.
    READ TABLE IT_MARC INTO WA_MARC WITH  KEY matnr = WA_FINAL-matnr. "added by jyoti
    IF SY-SUBRC = 0.
      WA_FINAL-STEUC   = WA_MARC-STEUC.
    ENDIF.
     ON CHANGE OF WA_VBRK-KNUMV.

        LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBRK-KNUMV.
*                                   AND KPOSN = WA_VBAP-POSNR .
        CASE  WA_KONV-KSCHL.

     WHEN 'ZADV' .
          WA_FINAL-KWERT  =  WA_KONV-KWERT.

*     WHEN 'ZPR0'.
*          WA_FINAL-NETPR1  =  WA_KONV-KWERT  + WA_FINAL-KWERT2.


        WHEN  'ZPFO'.
          WA_FINAL-KBETR = WA_KONV-KBETR / 10.
          WA_FINAL-zKBETR_new = WA_KONV-KBETR.
          WA_FINAL-KWERT1 = WA_KONV-KWERT.
*
*      WHEN 'ZPR0'.   "" NEXT PAGE
*        WA_FINAL-NETPR   = WA_KONV-KBETR.

      WHEN 'MWAS' .
        WA_FINAL-ZKBETR1 =   WA_KONV-KBETR / 10.
*        WA_FINAL-KWERT2 =  WA_KONV-KWERT.
         WA_FINAL-KWERT2 = WA_FINAL-KWERT2 + WA_KONV-KWERT.

        WHEN 'ZPR0'.
          WA_FINAL-NETPR1 = WA_FINAL-NETPR1 + WA_KONV-KWERT.
          WA_FINAL-netpr2 = WA_FINAL-NETPR1 + WA_FINAL-KWERT2.

*          WA_FINAL-NETPR1  = WA_FINAL-NETPR1 + WA_KONV-KWERT + WA_FINAL-KWERT2.
*          WA_FINAL-NETPR1  = WA_FINAL-NETPR1 +  WA_FINAL-KWERT2.
*          WA_FINAL-NETPR1  = WA_KONV-KWERT +  WA_FINAL-KWERT2.





*      ELSEIF WA_KONV-KSCHL = 'MWAS' AND WA_KONV-KNTYP = 'D'.
*        wa_final-knumv = wa_konv-knumv.
*        wa_final-kbetr6 = wa_konv-kbetr / 10 .
*        WA_FINAL-KNUMV = WA_KONV-KNUMV.
*        WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kbetr6 =  wa_konv-kbetr. "WA_KONV-KBETR.
        WA_FINAL-KBETR6 = WA_KONV-KBETR / 10 .
        WA_FINAL-ZSATAXAMT =  WA_KONV-KWERT.

ENDCASE.
    ENDLOOP.
    ENDON.

     LOOP AT IT_KONV INTO WA_KONV where  KNUMV = WA_VBRK-KNUMV
                                   AND KPOSN = WA_VBrp-POSNR .
         CASE  WA_KONV-KSCHL.
        WHEN 'ZPR0'.   "" NEXT PAGE
        WA_FINAL-NETPR   = WA_KONV-KBETR.
        ENDCASE.
    ENDLOOP.

       wA_FINAL-TOT_AMT = WA_FINAL-NETPR * WA_FINAL-FKIMG.
       wA_FINAL-TOT_AMT1 =  wA_FINAL-TOT_AMT1 +  wA_FINAL-TOT_AMT.
       wA_FINAL-TOT_qty_1 =  wA_FINAL-TOT_qty_1 +  WA_FINAL-FKIMG.
*       WA_FINAL-NETPR_TOT =   WA_FINAL-NETPR_TOT +  WA_FINAL-NETPR.

*       wA_FINAL-NET_AMT = WA_FINAL-KWERT + WA_FINAL-KWERT1 +  WA_FINAL-KWERT2 .

       wA_FINAL-NET_AMT = WA_FINAL-netpr2 + WA_FINAL-KWERT1 . "+  WA_FINAL-KWERT2 .


AMT_IN_NUM = wA_FINAL-NET_AMT.

*DATA IN_WORDS TYPE SPELL.



     CALL FUNCTION 'SPELL_AMOUNT'
      EXPORTING
        AMOUNT          = AMT_IN_NUM
        CURRENCY        = 'INR'
*        FILLER          = ' '
        LANGUAGE        = SY-LANGU
      IMPORTING
        IN_WORDS        = IN_WORDS
      EXCEPTIONS
        NOT_FOUND       = 1
        TOO_LARGE       = 2
*        OTHERS          = 3
               .
     IF SY-SUBRC <> 0.
* Implement suitable error handling here
     ENDIF.
     IF IN_WORDS-DECWORD = 'ZERO'.
     CONCATENATE 'SAUDI RIYAL' IN_WORDS-WORD 'ONLY' INTO WA_FINAL-AMT_WORD SEPARATED BY SPACE.
*     ENDIF.
*     IF IN_WORDS-DECWORD IS NOT INITIAL.
     ELSE.
     CONCATENATE 'SAUDI RIYAL' IN_WORDS-WORD 'AND' IN_WORDS-DECWORD 'HALLALS ONLY' INTO WA_FINAL-AMT_WORD SEPARATED BY SPACE.
     ENDIF.

    APPEND WA_FINAL TO IT_FINAL.



  ENDLOOP.
 CLEAR WA_FINAL.



ENDFORM.

FORM GRANDWORDS.
  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
    EXPORTING
      AMT_IN_NUM         = GRAND_TOTAL
    IMPORTING
      AMT_IN_WORDS       = V_AMT
    EXCEPTIONS
      DATA_TYPE_MISMATCH = 1
      OTHERS             = 2.

  CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
    EXPORTING
      INPUT_STRING  = V_AMT
      SEPARATORS    = ' '
    IMPORTING
      OUTPUT_STRING = V_AMT.

ENDFORM.

FORM GET_OFMDATE.

  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z016'
        LANGUAGE                = 'E'
        NAME                    = VBELN_1
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = GT_LINES
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    LOOP AT GT_LINES INTO LS_LINES.
      LV_LINES1 = LS_LINES-TDLINE.
      WA_FINAL-LV_LINES1 = LV_LINES1 .

    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_LINES1.
    CLEAR : LV_LINES1 ,WA_FINAL.
  ENDLOOP.
ENDFORM.

FORM GET_MEMO.

  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z015'
        LANGUAGE                = 'E'
        NAME                    = VBELN_1
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = GT_LINES
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    LOOP AT GT_LINES INTO LS_LINES.
      LV_MEMO = LS_LINES-TDLINE.
      WA_FINAL-LV_MEMO  = LV_MEMO  .

    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_MEMO .
    CLEAR: LV_MEMO ,WA_FINAL .
  ENDLOOP.
ENDFORM.

FORM GET_INSURANCE.

  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z017'
        LANGUAGE                = 'E'
        NAME                    = VBELN_1
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = GT_LINES
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    LOOP AT GT_LINES INTO LS_LINES.
      LV_INSURANCE = LS_LINES-TDLINE.
      WA_FINAL-LV_INSURANCE  = LV_INSURANCE  .

    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_INSURANCE .
    CLEAR : LV_INSURANCE ,WA_FINAL .
  ENDLOOP.

ENDFORM.

FORM GET_MOD.


  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z018'
        LANGUAGE                = 'E'
        NAME                    = VBELN_1
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = GT_LINES
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    LOOP AT GT_LINES INTO LS_LINES.
      LV_MOD = LS_LINES-TDLINE.
      WA_FINAL-LV_MOD  = LV_MOD  .

    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_MOD .
    CLEAR: LV_MOD ,WA_FINAL .
  ENDLOOP.

ENDFORM.

FORM GET_DOCT.

  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z019'
        LANGUAGE                = 'E'
        NAME                    = VBELN_1
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = GT_LINES
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    LOOP AT GT_LINES INTO LS_LINES.
      LV_DOCT = LS_LINES-TDLINE.
      WA_FINAL-LV_DOCT  = LV_DOCT  .

    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_DOCT .
    CLEAR: LV_DOCT ,WA_FINAL .
  ENDLOOP.

ENDFORM.

FORM GET_SINST.

  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z020'
        LANGUAGE                = 'E'
        NAME                    = VBELN_1
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = GT_LINES
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    LOOP AT GT_LINES INTO LS_LINES.
      LV_SINST = LS_LINES-TDLINE.
      REPLACE ALL OCCURRENCES OF '<(>&<)>' IN LV_SINST WITH '&'.
      WA_FINAL-LV_SINST  = LV_SINST  .

    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_SINST .
    CLEAR: LV_SINST ,WA_FINAL .
  ENDLOOP.

ENDFORM.
FORM GET_LDDATE.

  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z038'
        LANGUAGE                = 'E'
        NAME                    = VBELN_1
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = GT_LINES
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    LOOP AT GT_LINES INTO LS_LINES.
      LV_LDDATE = LS_LINES-TDLINE.
      WA_FINAL-LV_LDDATE  = LV_LDDATE  .
    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_LDDATE .
    CLEAR WA_FINAL.
    CLEAR LV_LDDATE  .
  ENDLOOP.

ENDFORM.
FORM SMARTFROM_DATA .

  GS_CTRLOP-GETOTF = 'X'.
  GS_CTRLOP-DEVICE = 'PRINTER'.
  GS_CTRLOP-PREVIEW = ''.
  GS_CTRLOP-NO_DIALOG = 'X'.
  GS_OUTOPT-TDDEST = 'LOCL1'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME = 'ZSD_PROFARMA_INVC'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      FM_NAME  = FM_NAME
* EXCEPTIONS
*     NO_FORM  = 1
*     NO_FUNCTION_MODULE       = 2
*     OTHERS   = 3
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  DATA : LS_DLV-LAND LIKE VBRK-LAND1 VALUE 'IN'.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
  PERFORM SET_PRINT_PARAM USING    "ls_addr_key
                                   LS_DLV-LAND
                          CHANGING GS_CTRLOP
                                   GS_OUTOPT.





loop at it_final into wa_final.

*  BREAK primus.

**  READ TABLE lt_t003t INTO ls_t003t WITH KEY blart = wa_final-blart.
**  IF SY-SUBRC = 0.
**     lv_text = ls_t003t-ltext.
**  ENDIF.
 IF sy-tabix = 1.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_false.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_false.
* CLOSE SPOOL AT THE LAST LOOP ONLY
      gs_con_settings-no_close  = abap_true.
    ELSE.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_true.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_true.
    ENDIF.

    IF sy-tabix = gv_tot_lines.
* CLOSE SPOOL
      gs_con_settings-no_close  = abap_false.
    ENDIF.
ENDLOOP.


  CALL FUNCTION FM_NAME " '/1BCDWB/SF00000201'
    EXPORTING
*     ARCHIVE_INDEX      = ARCHIVE_INDEX
*     ARCHIVE_INDEX_TAB  = ARCHIVE_INDEX_TAB
*     ARCHIVE_PARAMETERS = ARCHIVE_PARAMETERS
      CONTROL_PARAMETERS = GS_CTRLOP
*     MAIL_APPL_OBJ      = MAIL_APPL_OBJ
*     MAIL_RECIPIENT     = MAIL_RECIPIENT
*     MAIL_SENDER        = MAIL_SENDER
      OUTPUT_OPTIONS     = GS_OUTOPT
*     USER_SETTINGS      = 'X'
*   IMPORTING
*     DOCUMENT_OUTPUT_INFO       = DOCUMENT_OUTPUT_INFO
      JOB_OUTPUT_INFO    = LS_JOB_INFO
      WA_FINAL           = WA_FINAL
      LV_WORD              = LV_AMT_IN_WORD
      GVPODT               = GVPODT1
*     JOB_OUTPUT_OPTIONS = JOB_OUTPUT_OPTIONS
    TABLES
      IT_FINAL           = IT_FINAL
*   EXCEPTIONS
*     FORMATTING_ERROR   = 1
*     INTERNAL_ERROR     = 2
*     SEND_ERROR         = 3
*     USER_CANCELED      = 4
*     OTHERS             = 5
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


















*CALL FUNCTION                      fm_name"'/1BCDWB/SF00000090'
*  EXPORTING
**   ARCHIVE_INDEX              =
**   ARCHIVE_INDEX_TAB          =
**   ARCHIVE_PARAMETERS         =
*   control_parameters         = gs_ctrlop
**   MAIL_APPL_OBJ              =
**   MAIL_RECIPIENT             =
**   MAIL_SENDER                =
*   output_options             = gs_outopt
*   user_settings              = space"'X'
*    lv_vbeln                   = so_code
*    v_amt                      = v_amt
* IMPORTING
**   DOCUMENT_OUTPUT_INFO       =
*   job_output_info            = gs_otfdata
**   JOB_OUTPUT_OPTIONS         =
*  TABLES
*    it_final                   = it_final
*    it_lines                   = gt_lines
* EXCEPTIONS
*   formatting_error           = 1
*   internal_error             = 2
*   send_error                 = 3
*   user_canceled              = 4
*   OTHERS                     = 5.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

*  CALL FUNCTION fm_name
*    EXPORTING
*      lv_vbeln           = so_code
*      v_amt              = v_amt
*      control_parameters = gs_ctrlop
*      output_options     = gs_outopt
*      user_settings      = space
*    IMPORTING
*      job_output_info    = gs_otfdata
*    TABLES
*      it_final           = it_final
**     it_lines           = GT_LINES
*    EXCEPTIONS
*      formatting_error   = 1
*      internal_error     = 2
*      send_error         = 3
*      user_canceled      = 4
*      OTHERS             = 5.
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.

  REFRESH IT_FINAL.
  CLEAR WA_FINAL.
ENDFORM.


FORM SET_PRINT_PARAM USING    "IS_ADDR_KEY LIKE ADDR_KEY
                              IS_DLV-LAND LIKE VBRK-LAND1
                     CHANGING GS_CTRLOP TYPE SSFCTRLOP
                              GS_OUTOPT TYPE SSFCOMPOP.

  DATA: LS_ITCPO     TYPE ITCPO.
  DATA: LF_REPID     TYPE SY-REPID.
  DATA: LF_DEVICE    TYPE TDDEVICE.
  DATA: LS_RECIPIENT TYPE SWOTOBJID.
  DATA: LS_SENDER    TYPE SWOTOBJID.

  LF_REPID = SY-REPID.

  CALL FUNCTION 'WFMC_PREPARE_SMART_FORM'
    EXPORTING
      PI_NAST    = NAST
      PI_COUNTRY = IS_DLV-LAND
*     PI_ADDR_KEY   = IS_ADDR_KEY
      PI_REPID   = LF_REPID
      PI_SCREEN  = XSCREEN
    IMPORTING
*     PE_RETURNCODE = CF_RETCODE
      PE_ITCPO   = LS_ITCPO
      PE_DEVICE  = LF_DEVICE.
*            PE_RECIPIENT  = CS_RECIPIENT
*            PE_SENDER     = CS_SENDER.

  MOVE-CORRESPONDING LS_ITCPO TO GS_OUTOPT.
  GS_CTRLOP-DEVICE      = LF_DEVICE.
  GS_CTRLOP-NO_DIALOG   = 'X'.
  GS_CTRLOP-PREVIEW     = XSCREEN.
  GS_CTRLOP-GETOTF      = LS_ITCPO-TDGETOTF.
  GS_CTRLOP-LANGU       = NAST-SPRAS.
ENDFORM.                               " SET_PRINT_PARAM
*&---------------------------------------------------------------------*
*&      Form  CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLEAR .
*  REFRESH it_vbak.
*  REFRESH it_vbpa.
  REFRESH IT_KNA1.
  REFRESH IT_VBKD.
  REFRESH IT_VBAP.
  REFRESH IT_TVZBT.
  REFRESH IT_VBFA.
  REFRESH IT_KONV.
ENDFORM.
