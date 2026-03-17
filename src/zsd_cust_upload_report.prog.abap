*&---------------------------------------------------------------------*
*& Report ZSD_CUST_UPLOAD_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSD_CUST_UPLOAD_REPORT.



TABLES: KNB1.

TYPES: BEGIN OF TY_KNA1,
         KUNNR     TYPE KNA1-KUNNR,
         KTOKD     TYPE KNA1-KTOKD,
         ANRED     TYPE KNA1-ANRED,
         NAME1     TYPE KNA1-NAME1,
         NAME2     TYPE KNA1-NAME2,
         LAND1     TYPE KNA1-LAND1,
         REGIO     TYPE KNA1-REGIO,
         TELF2     TYPE KNA1-TELF2,
         ADRNR     TYPE KNA1-ADRNR,
         STCD3     TYPE KNA1-STCD3,
         ERDAT     TYPE KNA1-ERDAT,
         J_1IPANNO TYPE KNA1-J_1IPANNO,
       END OF TY_KNA1,

       BEGIN OF TY_KNA12,
         KUNNR TYPE CDHDR-OBJECTID,   "kna1-kunnr,
         KTOKD TYPE KNA1-KTOKD,
         ANRED TYPE KNA1-ANRED,
         NAME1 TYPE KNA1-NAME1,
         NAME2 TYPE KNA1-NAME2,
         LAND1 TYPE KNA1-LAND1,
         REGIO TYPE KNA1-REGIO,
         TELF2 TYPE KNA1-TELF2,
         ADRNR TYPE KNA1-ADRNR,
         STCD3 TYPE KNA1-STCD3,
         ERDAT TYPE KNA1-ERDAT,
       END OF TY_KNA12,

       BEGIN OF TY_KNB1,
         KUNNR TYPE KNB1-KUNNR,
         BUKRS TYPE KNB1-BUKRS,
         AKONT TYPE KNB1-AKONT,
         ZUAWA TYPE KNB1-ZUAWA,
         ZTERM TYPE KNB1-ZTERM,
         XVERR TYPE KNB1-XVERR,
         ZWELS TYPE KNB1-ZWELS,
         KNRZB TYPE KNB1-KNRZB,
         HBKID TYPE KNB1-HBKID,
         ALTKN TYPE KNB1-ALTKN,
       END OF TY_KNB1,

       BEGIN OF TY_KNVV,
         KUNNR TYPE KNVV-KUNNR,
         VKORG TYPE KNVV-VKORG,
         VTWEG TYPE KNVV-VTWEG,
         SPART TYPE KNVV-SPART,
         VKBUR TYPE KNVV-VKBUR,
         KDGRP TYPE KNVV-KDGRP,
         WAERS TYPE KNVV-WAERS,
         KALKS TYPE KNVV-KALKS,
         VERSG TYPE KNVV-VERSG,
         KVGR1 TYPE KNVV-KVGR1,
         LPRIO TYPE KNVV-LPRIO,
         VSBED TYPE KNVV-VSBED,
         VWERK TYPE KNVV-VWERK,
         INCO1 TYPE KNVV-INCO1,
         INCO2 TYPE KNVV-INCO2,
         ZTERM TYPE KNVV-ZTERM,
         KTGRD TYPE KNVV-KTGRD,
         KURST TYPE KNVV-KURST,                                                       ""ADDED BY MA ON 14.03.2024 FOR EXCHANGE RATE
       END OF TY_KNVV,


       BEGIN OF TY_KNVT,
*         kunnr TYPE knvt-kunnr,
         KUNNR TYPE KNVV-KUNNR,
         VKORG TYPE KNVV-VKORG,
*         vkorg TYPE knvt-vkorg,
*         vtweg TYPE knvt-vtweg,
         VTWEG TYPE KNVV-VTWEG,
*         spart TYPE knvt-spart,
         SPART TYPE KNVV-SPART,
       END OF TY_KNVT,

       BEGIN OF TY_TINCT,
         SPRAS TYPE TINCT-SPRAS,
         INCO1 TYPE TINCT-INCO1,
         BEZEI TYPE TINCT-BEZEI,
       END OF TY_TINCT,


       BEGIN OF TY_ADRC,
         ADDRNUMBER TYPE ADRC-ADDRNUMBER,
         NAME1      TYPE ADRC-NAME1,
         NAME2      TYPE ADRC-NAME2,
         NAME3      TYPE ADRC-NAME3,
         SORT1      TYPE ADRC-SORT1,
         STREET     TYPE ADRC-STREET,
         HOUSE_NUM1 TYPE ADRC-HOUSE_NUM1,
         POST_CODE1 TYPE ADRC-POST_CODE1,
         CITY1      TYPE ADRC-CITY1,
         CITY2      TYPE ADRC-CITY2,
         COUNTRY    TYPE ADRC-COUNTRY,
         REGION     TYPE ADRC-REGION,
         LANGU      TYPE ADRC-LANGU,
         TEL_NUMBER TYPE ADRC-TEL_NUMBER,
         FAX_NUMBER TYPE ADRC-FAX_NUMBER,
         STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
         STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
         STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
         LOCATION   TYPE ADRC-LOCATION,
       END OF TY_ADRC,

       BEGIN OF TY_ADR6,
         ADDRNUMBER TYPE ADR6-ADDRNUMBER,
         SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
       END OF TY_ADR6,

       BEGIN OF TY_KNVI,
         KUNNR TYPE KNVI-KUNNR,
         TATYP TYPE KNVI-TATYP,
         TAXKD TYPE KNVI-TAXKD,
       END OF TY_KNVI,

*       BEGIN OF TY_KNVP,
*       KUNNR TYPE KNVP-KUNNR,
*       PARVW TYPE KNVP-PARVW,
*       END OF TY_KNVP,

       BEGIN OF TY_KNVP,               " Add subodh 19 feb 2018
         KUNNR TYPE KNVP-KUNNR,
         VKORG TYPE KNVP-VKORG,
         VTWEG TYPE KNVP-VTWEG,
         SPART TYPE KNVP-SPART,
         PARVW TYPE KNVP-PARVW,
         PARZA TYPE KNVP-PARZA,
         KUNN2 TYPE KNVP-KUNN2,
       END OF TY_KNVP,



       BEGIN OF TY_T005U,
         SPRAS TYPE T005U-SPRAS,
         LAND1 TYPE T005U-LAND1,
         BLAND TYPE T005U-BLAND,
         BEZEI TYPE T005U-BEZEI,
       END OF TY_T005U,

       BEGIN OF TY_TZUNT,
         ZUAWA TYPE TZUNT-ZUAWA,
         TTEXT TYPE TZUNT-TTEXT,
       END OF TY_TZUNT,

       BEGIN OF TY_TVZBT,
         SPRAS TYPE TVZBT-SPRAS,
         ZTERM TYPE TVZBT-ZTERM,
         VTEXT TYPE TVZBT-VTEXT,
       END OF TY_TVZBT,


       BEGIN OF TY_T005T,
         SPRAS TYPE T005T-SPRAS,
         LAND1 TYPE T005T-LAND1,
         LANDX TYPE T005T-LANDX,
       END OF TY_T005T,


       BEGIN OF TY_J_1IMOCUST,
         KUNNR      TYPE J_1IMOCUST-KUNNR,
         J_1IEXCD   TYPE J_1IMOCUST-J_1IEXCD,
         J_1IEXRN   TYPE J_1IMOCUST-J_1IEXRN,
         J_1IEXRG   TYPE J_1IMOCUST-J_1IEXRG,
         J_1IEXDI   TYPE J_1IMOCUST-J_1IEXDI,
         J_1IEXCO   TYPE J_1IMOCUST-J_1IEXCO,
         J_1IEXCICU TYPE J_1IMOCUST-J_1IEXCICU,
         J_1ICSTNO  TYPE J_1IMOCUST-J_1ICSTNO,
         J_1ISERN   TYPE J_1IMOCUST-J_1ISERN,
         J_1ILSTNO  TYPE J_1IMOCUST-J_1ILSTNO,
         J_1IPANNO  TYPE J_1IMOCUST-J_1IPANNO,
         J_1IPANREF TYPE J_1IMOCUST-J_1IPANREF,

       END OF TY_J_1IMOCUST,

       BEGIN OF TY_CDHDR,
         OBJECTID TYPE CDHDR-OBJECTID,
         UDATE    TYPE CDHDR-UDATE,
         TCODE    TYPE CDTCODE,
       END OF TY_CDHDR,


       BEGIN OF TY_FINAL,
         KTOKD      TYPE KNA1-KTOKD,
         KUNNR      TYPE KNA1-KUNNR,
         BUKRS      TYPE KNB1-BUKRS,
*         vkorg      TYPE knvt-vkorg,
         VKORG      TYPE KNVV-VKORG,
*         vtweg      TYPE knvt-vtweg,
         VTWEG      TYPE KNVV-VTWEG,
*         spart      TYPE knvt-spart,
         SPART      TYPE KNVV-SPART,
         ANRED      TYPE KNA1-ANRED,
         NAME1      TYPE ADRC-NAME1,
         NAME2      TYPE ADRC-NAME2,
         NAME3      TYPE ADRC-NAME3,
         SORT1      TYPE ADRC-SORT1,
         STREET     TYPE ADRC-STREET,
         HOUSE_NUM1 TYPE ADRC-HOUSE_NUM1,
         STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
         STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
         STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
         POST_CODE1 TYPE ADRC-POST_CODE1,
         CITY1      TYPE ADRC-CITY1,
         CITY2      TYPE ADRC-CITY2,
         COUNTRY    TYPE ADRC-COUNTRY,
         LANDX      TYPE T005T-LANDX,
         REGIO      TYPE KNA1-REGIO,
         REGION     TYPE ADRC-REGION,
         BEZEI      TYPE T005U-BEZEI,
         LANGU      TYPE ADRC-LANGU,
         TEL_NUMBER TYPE ADRC-TEL_NUMBER,
         TELF2      TYPE KNA1-TELF1,
         FAX_NUMBER TYPE ADRC-FAX_NUMBER,
         SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
         AKONT      TYPE KNB1-AKONT,
         ZUAWA      TYPE KNB1-ZUAWA,
         TTEXT      TYPE TZUNT-TTEXT,
         FI_ZTERM   TYPE KNB1-ZTERM,
         FI_VTEXT   TYPE TVZBT-VTEXT,
         XVERR      TYPE KNB1-XVERR,
         ZWELS      TYPE KNB1-ZWELS,
         KNRZB      TYPE KNB1-KNRZB,
         HBKID      TYPE KNB1-HBKID,
         VKBUR      TYPE KNVV-VKBUR,
         KDGRP      TYPE KNVV-KDGRP,
         WAERS      TYPE KNVV-WAERS,
         KALKS      TYPE KNVV-KALKS,
         VERSG      TYPE KNVV-VERSG,
         KVGR1      TYPE KNVV-KVGR1,
         LPRIO      TYPE KNVV-LPRIO,
         VSBED      TYPE KNVV-VSBED,
         VWERK      TYPE KNVV-VWERK,
         INCO1      TYPE KNVV-INCO1,
         INCO_TEXT  TYPE TINCT-BEZEI,
         INCO2      TYPE KNVV-INCO2,
         ZTERM      TYPE KNVV-ZTERM,
         VTEXT      TYPE TVZBT-VTEXT,
         KTGRD      TYPE KNVV-KTGRD,
         JOCG       TYPE KNVI-TAXKD,
         JOSG       TYPE KNVI-TAXKD,
         JOIG       TYPE KNVI-TAXKD,
         JOUG       TYPE KNVI-TAXKD,
********************************************************** Add subodh 19 feb 2018 ****************************
*       kunnr        TYPE knvp-kunnr,
*       vkorg        TYPE knvp-vkorg,
*       vtweg        TYPE knvp-vtweg,
*       spart        TYPE knvp-spart,
         PARVW      TYPE KNVP-PARVW,
         PARZA      TYPE KNVP-PARZA,
         KUNN2      TYPE KNVP-KUNN2,
****************************************************************************************************************
*       PARVW        TYPE KNVP-PARVW,
         J_1IEXCD   TYPE J_1IMOCUST-J_1IEXCD,
         J_1IEXRN   TYPE J_1IMOCUST-J_1IEXRN,
         J_1IEXRG   TYPE J_1IMOCUST-J_1IEXRG,
         J_1IEXDI   TYPE J_1IMOCUST-J_1IEXDI,
         J_1IEXCO   TYPE J_1IMOCUST-J_1IEXCO,
         J_1IEXCICU TYPE J_1IMOCUST-J_1IEXCICU,
         J_1ICSTNO  TYPE J_1IMOCUST-J_1ICSTNO,
         J_1ISERN   TYPE J_1IMOCUST-J_1ISERN,
         J_1ILSTNO  TYPE J_1IMOCUST-J_1ILSTNO,
         J_1IPANNO  TYPE J_1IMOCUST-J_1IPANNO,
         J_1IPANREF TYPE J_1IMOCUST-J_1IPANREF,
         STCD3      TYPE KNA1-STCD3,
         KUNN2_AG   TYPE KNVP-KUNN2,
         KUNN2_RE   TYPE KNVP-KUNN2,
         KUNN2_RG   TYPE KNVP-KUNN2,
         KUNN2_WE   TYPE KNVP-KUNN2,
         ERDAT      TYPE KNA1-ERDAT,
         ALTKN      TYPE KNB1-ALTKN,
         TCS        TYPE KNVI-TAXKD,
         ADRNR      TYPE KNA1-ADRNR,
         LOCATION   TYPE ADRC-LOCATION,

         OBJECTID   TYPE CDHDR-OBJECTID,
         UDATE      TYPE CHAR15,                          "cdhdr-udate,
         TCODE      TYPE CDTCODE,
         KURST      TYPE KNVV-KURST,                      ""EXCHANGE RATE

       END OF TY_FINAL.

************************************************Dowanlod Str***************
TYPES : BEGIN OF ITAB,
          KTOKD      TYPE CHAR10,
          KUNNR      TYPE CHAR15,
          BUKRS      TYPE CHAR10,
          VKORG      TYPE CHAR10,
          VTWEG      TYPE CHAR10,
          SPART      TYPE CHAR10,
          ANRED      TYPE CHAR20,
          NAME1      TYPE CHAR50,
          NAME2      TYPE CHAR50,
          NAME3      TYPE CHAR50,
          SORT1      TYPE CHAR30,
          STREET     TYPE CHAR50,
          STR_SUPPL1 TYPE CHAR50,
          STR_SUPPL2 TYPE CHAR50,
          STR_SUPPL3 TYPE CHAR50,
          HOUSE_NUM1 TYPE CHAR15,
          POST_CODE1 TYPE CHAR15,
          CITY2      TYPE CHAR50,
          CITY1      TYPE CHAR50,
          COUNTRY    TYPE CHAR20,
          LANDX      TYPE CHAR30,
          REGION     TYPE CHAR20,
          BEZEI      TYPE CHAR30,
          LANGU      TYPE CHAR30,
          TEL_NUMBER TYPE CHAR30,
          TELF2      TYPE CHAR20,
          FAX_NUMBER TYPE CHAR30,
          SMTP_ADDR  TYPE CHAR128,
          AKONT      TYPE CHAR30,
          ZUAWA      TYPE CHAR20,
          TTEXT      TYPE CHAR50,
          FI_ZTERM   TYPE CHAR50,
          FI_VTEXT   TYPE CHAR50,
          XVERR      TYPE CHAR30,
          ZWELS      TYPE CHAR30,
          KNRZB      TYPE CHAR30,
          HBKID      TYPE CHAR30,
          VKBUR      TYPE CHAR30,
          KDGRP      TYPE CHAR30,
          WAERS      TYPE CHAR20,
          KALKS      TYPE CHAR20,
          VERSG      TYPE CHAR20,
          KVGR1      TYPE CHAR20,
          LPRIO      TYPE CHAR20,
          VSBED      TYPE CHAR20,
          VWERK      TYPE CHAR20,
          INCO1      TYPE CHAR20,
          INCO_TEXT  TYPE CHAR50,
          INCO2      TYPE CHAR20,
          ZTERM      TYPE CHAR50,
          VTEXT      TYPE CHAR50,
          KTGRD      TYPE CHAR20,
          JOCG       TYPE CHAR10,
          JOSG       TYPE CHAR10,
          JOIG       TYPE CHAR10,
          JOUG       TYPE CHAR10,
*          PARVW             TYPE CHAR20,               commetn subodh 19 feb 2018
          J_1IEXCD   TYPE CHAR30,
          J_1IEXRN   TYPE CHAR30,
          J_1IEXRG   TYPE CHAR30,
          J_1IEXDI   TYPE CHAR30,
          J_1IEXCO   TYPE CHAR30,
          J_1IEXCICU TYPE CHAR30,
          J_1ICSTNO  TYPE CHAR30,
          J_1ILSTNO  TYPE CHAR30,
          J_1ISERN   TYPE CHAR30,
          J_1IPANNO  TYPE CHAR30,
          J_1IPANREF TYPE CHAR30,
          STCD3      TYPE CHAR20,
************************************************************* add subodh 19 feb 2018 *******************************
*         kunnr type char10,
*         vkorg type char4,
*         vtweg type char2,
*         spart type char2,
*         parvw type char2,
*         parza type char3,
          KUNN2_AG   TYPE CHAR10,
          KUNN2_RE   TYPE CHAR10,
          KUNN2_RG   TYPE CHAR10,
          KUNN2_WE   TYPE CHAR10,

          ERDAT      TYPE CHAR15,
          ALTKN      TYPE CHAR10,
          TCS        TYPE CHAR10,
          LOCATION   TYPE CHAR30,
          KURST      TYPE KNVV-KURST,

          UDATE      TYPE CHAR15,     "cdhdr-udate,              "DH
          TIME       TYPE CHAR15,
          REF        TYPE CHAR15,
        END OF ITAB.

DATA : LT_FINAL TYPE TABLE OF ITAB,
       LS_FINAL TYPE          ITAB.
************************************************end itab*******************************************
DATA : IT_KNA1       TYPE TABLE OF TY_KNA1,
       WA_KNA1       TYPE          TY_KNA1,

       IT_KNA12      TYPE TABLE OF TY_KNA12,
       WA_KNA12      TYPE          TY_KNA12,

       IT_KNB1       TYPE TABLE OF TY_KNB1,
       WA_KNB1       TYPE          TY_KNB1,

       IT_KNVV       TYPE TABLE OF TY_KNVV,
       WA_KNVV       TYPE          TY_KNVV,

       IT_KNVT       TYPE TABLE OF TY_KNVT,
       WA_KNVT       TYPE          TY_KNVT,

       IT_ADRC       TYPE TABLE OF TY_ADRC,
       WA_ADRC       TYPE          TY_ADRC,

       IT_ADR6       TYPE TABLE OF TY_ADR6,
       WA_ADR6       TYPE          TY_ADR6,

       IT_TINCT      TYPE TABLE OF TY_TINCT,
       WA_TINCT      TYPE          TY_TINCT,

       IT_KNVP       TYPE TABLE OF TY_KNVP,
       WA_KNVP       TYPE          TY_KNVP,

       IT_KNVI       TYPE TABLE OF TY_KNVI,
       WA_KNVI       TYPE          TY_KNVI,

       IT_T005U      TYPE TABLE OF TY_T005U,
       WA_T005U      TYPE          TY_T005U,

       IT_T005T      TYPE TABLE OF TY_T005T,
       WA_T005T      TYPE          TY_T005T,

       IT_FI_TVZBT   TYPE TABLE OF TY_TVZBT,
       WA_FI_TVZBT   TYPE          TY_TVZBT,

       IT_TVZBT      TYPE TABLE OF TY_TVZBT,
       WA_TVZBT      TYPE          TY_TVZBT,

       IT_TZUNT      TYPE TABLE OF TY_TZUNT,
       WA_TZUNT      TYPE          TY_TZUNT,

       IT_J_1IMOCUST TYPE TABLE OF TY_J_1IMOCUST,
       WA_J_1IMOCUST TYPE          TY_J_1IMOCUST,

       IT_CDHDR      TYPE TABLE OF TY_CDHDR,
       WA_CDHDR      TYPE TY_CDHDR,

       IT_FINAL      TYPE TABLE OF TY_FINAL,
       WA_FINAL      TYPE          TY_FINAL,

       LV_KUNNR      TYPE CDHDR-OBJECTID,
       LV_KUNNR1     TYPE KNA1-KUNNR.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_KUNNR FOR KNB1-KUNNR,
                  S_BUKRS FOR KNB1-BUKRS NO INTERVALS.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

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
  SELECT KUNNR
         BUKRS
         AKONT
         ZUAWA
         ZTERM
         XVERR
         ZWELS
         KNRZB
         HBKID
         ALTKN FROM KNB1 INTO TABLE IT_KNB1
         WHERE KUNNR IN S_KUNNR
         AND   BUKRS IN S_BUKRS.

  IF IT_KNB1 IS NOT INITIAL.
    SELECT KUNNR
           KTOKD
           ANRED
           NAME1
           NAME2
           LAND1
           REGIO
           TELF2
           ADRNR
           STCD3
           J_1IPANNO
           ERDAT FROM KNA1 INTO CORRESPONDING FIELDS OF TABLE IT_KNA1
           FOR ALL ENTRIES IN IT_KNB1
           WHERE KUNNR = IT_KNB1-KUNNR.


    SELECT ZUAWA
           TTEXT FROM TZUNT INTO TABLE IT_TZUNT
           FOR ALL ENTRIES IN IT_KNB1
           WHERE ZUAWA = IT_KNB1-ZUAWA.

    SELECT SPRAS
           ZTERM
           VTEXT FROM TVZBT INTO TABLE IT_FI_TVZBT
           FOR ALL ENTRIES IN IT_KNB1
           WHERE ZTERM = IT_KNB1-ZTERM
           AND   SPRAS = 'E'.
  ENDIF.

  IF IT_KNA1 IS NOT INITIAL.
    LOOP AT IT_KNA1 INTO WA_KNA1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = WA_KNA1-KUNNR
        IMPORTING
          OUTPUT = LV_KUNNR.

      MOVE-CORRESPONDING WA_KNA1 TO WA_KNA12.
      WA_KNA12-KUNNR = LV_KUNNR.
      APPEND WA_KNA12 TO IT_KNA12.

    ENDLOOP.


*    MOVE-CORRESPONDING wa_kna1 TO wa_kna12.
*    wa_kna12-kunnr = lv_kunnr.
*    APPEND wa_kna12 TO it_kna12.
*    CLEAR: lv_kunnr, wa_kna1, wa_kna12.

  ENDIF.

  LOOP AT IT_KNA12 INTO WA_KNA12.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = WA_KNA12-KUNNR
      IMPORTING
        OUTPUT = LV_KUNNR1.

    WA_KNA12-KUNNR = LV_KUNNR1.
    MODIFY IT_KNA12 FROM WA_KNA12.
  ENDLOOP.

  IF IT_KNA12 IS NOT INITIAL.
*    SELECT *
*      FROM cdhdr
*      INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
*      FOR ALL ENTRIES IN it_kna12
*      WHERE objectid = it_kna12-kunnr
*      AND tcode = 'XD02'.

    SELECT OBJECTID UDATE TCODE
      FROM CDHDR
      INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
      FOR ALL ENTRIES IN IT_KNA12
      WHERE OBJECTID = IT_KNA12-KUNNR
      AND TCODE = 'XD02'.

  ENDIF.

  SORT IT_CDHDR BY UDATE DESCENDING.

  IF IT_KNA1 IS NOT INITIAL.
    SELECT KUNNR
           VKORG
           VTWEG
           SPART
           VKBUR
           KDGRP
           WAERS
           KALKS
           VERSG
           KVGR1
           LPRIO
           VSBED
           VWERK
           INCO1
           INCO2
           ZTERM
           KTGRD
           KURST FROM KNVV INTO CORRESPONDING FIELDS OF TABLE IT_KNVV
           FOR ALL ENTRIES IN IT_KNA1
           WHERE KUNNR = IT_KNA1-KUNNR.

    SELECT KUNNR
           VKORG
           VTWEG
*           spart FROM knvt INTO TABLE it_knvt
           SPART FROM KNVV INTO TABLE IT_KNVT
           FOR ALL ENTRIES IN IT_KNA1
           WHERE KUNNR = IT_KNA1-KUNNR.

    SELECT ADDRNUMBER
           NAME1
           NAME2
           NAME3
           SORT1
           STREET
           HOUSE_NUM1
           POST_CODE1
           CITY1
           CITY2
           COUNTRY
           REGION
           LANGU
           TEL_NUMBER
           FAX_NUMBER
           STR_SUPPL1
           STR_SUPPL2
           STR_SUPPL3
           LOCATION
       FROM ADRC INTO TABLE IT_ADRC
           FOR ALL ENTRIES IN IT_KNA1
           WHERE ADDRNUMBER = IT_KNA1-ADRNR.


    SELECT KUNNR
           TATYP
           TAXKD FROM KNVI INTO TABLE IT_KNVI
           FOR ALL ENTRIES IN IT_KNA1
           WHERE KUNNR = IT_KNA1-KUNNR.

    SELECT KUNNR
           VKORG
           VTWEG
           SPART
           PARVW
           PARZA
           KUNN2
           FROM KNVP INTO TABLE IT_KNVP
           FOR ALL ENTRIES IN IT_KNA1
           WHERE KUNNR = IT_KNA1-KUNNR.

    SELECT KUNNR
           J_1IEXCD
           J_1IEXRN
           J_1IEXRG
           J_1IEXDI
           J_1IEXCO
           J_1IEXCICU
           J_1ICSTNO
           J_1ISERN
           J_1ILSTNO
           J_1IPANNO
           J_1IPANREF  FROM KNA1 INTO TABLE IT_J_1IMOCUST
*           J_1IPANREF  FROM J_1IMOCUST INTO TABLE IT_J_1IMOCUST
           FOR ALL ENTRIES IN IT_KNA1
           WHERE KUNNR = IT_KNA1-KUNNR.



  ENDIF.

  IF IT_KNVV IS NOT INITIAL.
    SELECT SPRAS
             INCO1
             BEZEI FROM TINCT INTO TABLE IT_TINCT
             FOR ALL ENTRIES IN IT_KNVV
             WHERE INCO1 = IT_KNVV-INCO1
             AND   SPRAS = 'E'.

    SELECT SPRAS
            ZTERM
            VTEXT FROM TVZBT INTO TABLE IT_TVZBT
            FOR ALL ENTRIES IN IT_KNVV
            WHERE ZTERM = IT_KNVV-ZTERM
            AND   SPRAS = 'E'.



  ENDIF.

  IF IT_ADRC IS NOT INITIAL.

    SELECT ADDRNUMBER
           SMTP_ADDR  FROM ADR6 INTO TABLE IT_ADR6
           FOR ALL ENTRIES IN IT_ADRC
           WHERE ADDRNUMBER = IT_ADRC-ADDRNUMBER.


    SELECT SPRAS
             LAND1
             BLAND
             BEZEI FROM T005U INTO TABLE IT_T005U
             FOR ALL ENTRIES IN IT_ADRC
             WHERE SPRAS = IT_ADRC-LANGU
             AND   LAND1 = IT_ADRC-COUNTRY
             AND   BLAND = IT_ADRC-REGION.

    SELECT SPRAS
           LAND1
           LANDX FROM T005T INTO TABLE IT_T005T
           FOR ALL ENTRIES IN IT_ADRC
           WHERE SPRAS = IT_ADRC-LANGU
           AND   LAND1 = IT_ADRC-COUNTRY.


  ENDIF.




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
*  BREAK PRIMUS.
  LOOP AT IT_KNA1 INTO WA_KNA1.
    WA_FINAL-KUNNR   =   WA_KNA1-KUNNR.
    WA_FINAL-KTOKD   =   WA_KNA1-KTOKD.
    WA_FINAL-ANRED   =   WA_KNA1-ANRED.
*  WA_FINAL-LAND1   =   WA_KNA1-LAND1.
    WA_FINAL-REGIO   =   WA_KNA1-REGIO.
    WA_FINAL-TELF2   =   WA_KNA1-TELF2.
    WA_FINAL-STCD3   =   WA_KNA1-STCD3.
    WA_FINAL-ERDAT   =   WA_KNA1-ERDAT.
    WA_FINAL-ADRNR   =   WA_FINAL-ADRNR.

*    LOOP AT it_kna12 INTO wa_kna12.
    READ TABLE IT_KNA12 INTO WA_KNA12 WITH KEY KUNNR = WA_KNA1-KUNNR.

    READ TABLE IT_CDHDR INTO WA_CDHDR WITH KEY OBJECTID = WA_KNA12-KUNNR TCODE = 'XD02'.
    IF SY-SUBRC = 0.
      WA_FINAL-OBJECTID = WA_CDHDR-OBJECTID.
      WA_FINAL-UDATE = WA_CDHDR-UDATE.
      WA_FINAL-TCODE = WA_CDHDR-TCODE.
    ENDIF.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-UDATE
      IMPORTING
        OUTPUT = WA_FINAL-UDATE.

    CONCATENATE WA_FINAL-UDATE+0(2) WA_FINAL-UDATE+2(3) WA_FINAL-UDATE+5(4)
                    INTO WA_FINAL-UDATE SEPARATED BY '-'.

    IF WA_FINAL-UDATE = '--'.
      REPLACE ALL OCCURRENCES OF '--' IN WA_FINAL-UDATE WITH ' '.
    ENDIF.

*    ENDLOOP.

    READ TABLE IT_KNB1 INTO WA_KNB1 WITH KEY KUNNR = WA_KNA1-KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-BUKRS   = WA_KNB1-BUKRS.
      WA_FINAL-AKONT   = WA_KNB1-AKONT.
      WA_FINAL-ZUAWA   = WA_KNB1-ZUAWA.
      WA_FINAL-FI_ZTERM   = WA_KNB1-ZTERM.
      WA_FINAL-XVERR   = WA_KNB1-XVERR.
      WA_FINAL-ZWELS   = WA_KNB1-ZWELS.
      WA_FINAL-KNRZB   = WA_KNB1-KNRZB.
      WA_FINAL-HBKID   = WA_KNB1-HBKID.
      WA_FINAL-ALTKN   = WA_KNB1-ALTKN.

    ENDIF.

    READ TABLE IT_TZUNT INTO WA_TZUNT WITH KEY ZUAWA = WA_KNB1-ZUAWA.
    IF SY-SUBRC = 0.
      WA_FINAL-TTEXT = WA_TZUNT-TTEXT.

    ENDIF.

    READ TABLE IT_KNVV INTO WA_KNVV WITH KEY KUNNR = WA_KNA1-KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-VKBUR   = WA_KNVV-VKBUR.
      WA_FINAL-VKORG   = WA_KNVV-VKORG.
      WA_FINAL-VTWEG   = WA_KNVV-VTWEG.
      WA_FINAL-SPART   = WA_KNVV-SPART.
      WA_FINAL-KDGRP   = WA_KNVV-KDGRP.
      WA_FINAL-WAERS   = WA_KNVV-WAERS.
      WA_FINAL-KALKS   = WA_KNVV-KALKS.
      WA_FINAL-VERSG   = WA_KNVV-VERSG.
      WA_FINAL-KVGR1   = WA_KNVV-KVGR1.
      WA_FINAL-LPRIO   = WA_KNVV-LPRIO.
      WA_FINAL-VSBED   = WA_KNVV-VSBED.
      WA_FINAL-VWERK   = WA_KNVV-VWERK.
      WA_FINAL-INCO1   = WA_KNVV-INCO1.
      WA_FINAL-INCO2   = WA_KNVV-INCO2.
      WA_FINAL-ZTERM   = WA_KNVV-ZTERM.
      WA_FINAL-KTGRD   = WA_KNVV-KTGRD.
      WA_FINAL-KURST   = WA_KNVV-KURST.                                           ""ADDED BY MA 0N 14.03.2024


    ENDIF.

    READ TABLE IT_TINCT INTO WA_TINCT WITH KEY INCO1 = WA_KNVV-INCO1
                                               SPRAS = 'E'.
    IF SY-SUBRC = 0.
      WA_FINAL-INCO_TEXT  =   WA_TINCT-BEZEI.

    ENDIF.


    READ TABLE IT_ADRC INTO WA_ADRC WITH KEY ADDRNUMBER = WA_KNA1-ADRNR.
    IF SY-SUBRC = 0.
      WA_FINAL-NAME1       = WA_ADRC-NAME1     .
      WA_FINAL-NAME2       = WA_ADRC-NAME2     .
      WA_FINAL-NAME3       = WA_ADRC-NAME3     .
      WA_FINAL-SORT1       = WA_ADRC-SORT1     .
      WA_FINAL-STREET      = WA_ADRC-STREET    .
      WA_FINAL-HOUSE_NUM1  = WA_ADRC-HOUSE_NUM1.
      WA_FINAL-POST_CODE1  = WA_ADRC-POST_CODE1.
      WA_FINAL-CITY1       = WA_ADRC-CITY1     .
      WA_FINAL-CITY2       = WA_ADRC-CITY2     .
      WA_FINAL-COUNTRY     = WA_ADRC-COUNTRY   .
      WA_FINAL-REGION      = WA_ADRC-REGION    .
      WA_FINAL-LANGU       = WA_ADRC-LANGU     .
      WA_FINAL-TEL_NUMBER  = WA_ADRC-TEL_NUMBER.
      WA_FINAL-FAX_NUMBER  = WA_ADRC-FAX_NUMBER.
      WA_FINAL-STR_SUPPL1  = WA_ADRC-STR_SUPPL1.
      WA_FINAL-STR_SUPPL2  = WA_ADRC-STR_SUPPL2.
      WA_FINAL-STR_SUPPL3  = WA_ADRC-STR_SUPPL3.
      WA_FINAL-LOCATION    = WA_ADRC-LOCATION.
    ENDIF.

    LOOP AT IT_KNVI INTO WA_KNVI WHERE KUNNR = WA_KNA1-KUNNR.
      CASE WA_KNVI-TATYP.
        WHEN 'JOCG'.
          WA_FINAL-JOCG = WA_KNVI-TAXKD.
        WHEN 'JOSG'.
          WA_FINAL-JOSG = WA_KNVI-TAXKD.
        WHEN 'JOIG'.
          WA_FINAL-JOIG = WA_KNVI-TAXKD.
        WHEN 'JOUG'.
          WA_FINAL-JOUG = WA_KNVI-TAXKD.
        WHEN 'JTC1'.
          WA_FINAL-TCS = WA_KNVI-TAXKD.
      ENDCASE.

    ENDLOOP.

*READ TABLE it_knvp INTO wa_knvp WITH KEY KUNNR = wa_KNA1-KUNNR.              " add subodh 19 feb 2018
*if wa_knvp-parvw = 'AG'.
*wa_final-kunn2_ag = wa_knvp-kunn2.
*ELSEIF wa_knvp-parvw = 'RE'.
*wa_final-kunn2_re = wa_knvp-kunn2.
*ELSEIF wa_knvp-parvw = 'RG'.
*wa_final-kunn2_rg = wa_knvp-kunn2.
*ELSEIF wa_knvp-parvw = 'WE'.
*wa_final-kunn2_we = wa_knvp-kunn2.
*ENDIF.

    LOOP AT IT_KNVP INTO WA_KNVP WHERE KUNNR = WA_KNA1-KUNNR.

      CASE WA_KNVP-PARVW.
        WHEN 'AG'.
          WA_FINAL-KUNN2_AG = WA_KNVP-KUNN2.
        WHEN 'RE'.
          WA_FINAL-KUNN2_RE = WA_KNVP-KUNN2.
        WHEN 'RG'.
          WA_FINAL-KUNN2_RG = WA_KNVP-KUNN2.
        WHEN 'WE'.
          WA_FINAL-KUNN2_WE = WA_KNVP-KUNN2.
      ENDCASE.
    ENDLOOP.



    READ TABLE IT_T005U INTO WA_T005U WITH KEY SPRAS = WA_ADRC-LANGU
                                               LAND1 = WA_ADRC-COUNTRY
                                               BLAND = WA_ADRC-REGION.
    IF SY-SUBRC = 0.
      WA_FINAL-BEZEI   =  WA_T005U-BEZEI.

    ENDIF.

    READ TABLE IT_T005T INTO WA_T005T WITH KEY SPRAS = WA_ADRC-LANGU
                                               LAND1 = WA_ADRC-COUNTRY.
    IF SY-SUBRC = 0.
      WA_FINAL-LANDX  =    WA_T005T-LANDX.

    ENDIF.

    READ TABLE IT_FI_TVZBT INTO WA_FI_TVZBT WITH KEY ZTERM = WA_KNB1-ZTERM
                                                     SPRAS = 'E'.
    IF SY-SUBRC = 0.
      WA_FINAL-FI_VTEXT   = WA_FI_TVZBT-VTEXT.

    ENDIF.


    READ TABLE IT_TVZBT INTO WA_TVZBT WITH KEY ZTERM = WA_KNVV-ZTERM
                                                     SPRAS = 'E'.
    IF SY-SUBRC = 0.
      WA_FINAL-VTEXT   = WA_TVZBT-VTEXT.

    ENDIF.




    READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_ADRC-ADDRNUMBER.
    IF SY-SUBRC = 0.
      WA_FINAL-SMTP_ADDR  =  WA_ADR6-SMTP_ADDR.

    ENDIF.

    WA_FINAL-J_1IPANNO   =  WA_KNA1-J_1IPANNO  .   """"""""" ++ nc

    READ TABLE IT_J_1IMOCUST INTO WA_J_1IMOCUST WITH KEY KUNNR = WA_KNA1-KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-J_1IEXCD    =  WA_J_1IMOCUST-J_1IEXCD   .
      WA_FINAL-J_1IEXRN    =  WA_J_1IMOCUST-J_1IEXRN   .
      WA_FINAL-J_1IEXRG    =  WA_J_1IMOCUST-J_1IEXRG   .
      WA_FINAL-J_1IEXDI    =  WA_J_1IMOCUST-J_1IEXDI   .
      WA_FINAL-J_1IEXCO    =  WA_J_1IMOCUST-J_1IEXCO   .
      WA_FINAL-J_1IEXCICU  =  WA_J_1IMOCUST-J_1IEXCICU .
      WA_FINAL-J_1ICSTNO   =  WA_J_1IMOCUST-J_1ICSTNO  .
      WA_FINAL-J_1ISERN    =  WA_J_1IMOCUST-J_1ISERN   .
      WA_FINAL-J_1ILSTNO   =  WA_J_1IMOCUST-J_1ILSTNO  .
*      WA_FINAL-J_1IPANNO   =  WA_J_1IMOCUST-J_1IPANNO  .

      WA_FINAL-J_1IPANREF  =  WA_J_1IMOCUST-J_1IPANREF .

    ENDIF.


***********************************************8SORT DATA FOR DOWANLOAD FILE***********************************
    LS_FINAL-KTOKD                 =          WA_FINAL-KTOKD     .
    LS_FINAL-KUNNR                 =          WA_FINAL-KUNNR     .
    LS_FINAL-BUKRS                 =          WA_FINAL-BUKRS     .
    LS_FINAL-VKORG                 =          WA_FINAL-VKORG     .
    LS_FINAL-VTWEG                 =          WA_FINAL-VTWEG     .
    LS_FINAL-SPART                 =          WA_FINAL-SPART     .
    LS_FINAL-ANRED                 =          WA_FINAL-ANRED     .
    LS_FINAL-NAME1                 =          WA_FINAL-NAME1     .
    LS_FINAL-NAME2                 =          WA_FINAL-NAME2     .
    LS_FINAL-NAME3                 =          WA_FINAL-NAME3     .
    LS_FINAL-SORT1                 =          WA_FINAL-SORT1     .
    LS_FINAL-STREET                =          WA_FINAL-STREET    .
    LS_FINAL-STR_SUPPL1            =          WA_FINAL-STR_SUPPL1.
    LS_FINAL-STR_SUPPL2            =          WA_FINAL-STR_SUPPL2.
    LS_FINAL-STR_SUPPL3            =          WA_FINAL-STR_SUPPL3.
    LS_FINAL-HOUSE_NUM1            =          WA_FINAL-HOUSE_NUM1.
    LS_FINAL-POST_CODE1            =          WA_FINAL-POST_CODE1.
    LS_FINAL-CITY2                 =          WA_FINAL-CITY2     .
    LS_FINAL-CITY1                 =          WA_FINAL-CITY1     .
    LS_FINAL-COUNTRY               =          WA_FINAL-COUNTRY   .
    LS_FINAL-LANDX                 =          WA_FINAL-LANDX     .
    LS_FINAL-REGION                =          WA_FINAL-REGION    .
    LS_FINAL-BEZEI                 =          WA_FINAL-BEZEI     .
    LS_FINAL-LANGU                 =          WA_FINAL-LANGU     .
    LS_FINAL-TEL_NUMBER            =          WA_FINAL-TEL_NUMBER.
    LS_FINAL-TELF2                 =          WA_FINAL-TELF2     .
    LS_FINAL-FAX_NUMBER            =          WA_FINAL-FAX_NUMBER.
    LS_FINAL-SMTP_ADDR             =          WA_FINAL-SMTP_ADDR .
    LS_FINAL-AKONT                 =          WA_FINAL-AKONT     .
    LS_FINAL-ZUAWA                 =          WA_FINAL-ZUAWA     .
    LS_FINAL-TTEXT                 =          WA_FINAL-TTEXT     .
    LS_FINAL-FI_ZTERM              =          WA_FINAL-FI_ZTERM  .
    LS_FINAL-FI_VTEXT              =          WA_FINAL-FI_VTEXT  .
    LS_FINAL-XVERR                 =          WA_FINAL-XVERR     .
    LS_FINAL-ZWELS                 =          WA_FINAL-ZWELS     .
    LS_FINAL-KNRZB                 =          WA_FINAL-KNRZB     .
    LS_FINAL-HBKID                 =          WA_FINAL-HBKID     .
    LS_FINAL-VKBUR                 =          WA_FINAL-VKBUR     .
    LS_FINAL-KDGRP                 =          WA_FINAL-KDGRP     .
    LS_FINAL-WAERS                 =          WA_FINAL-WAERS     .
    LS_FINAL-KALKS                 =          WA_FINAL-KALKS     .
    LS_FINAL-VERSG                 =          WA_FINAL-VERSG     .
    LS_FINAL-KVGR1                 =          WA_FINAL-KVGR1     .
    LS_FINAL-LPRIO                 =          WA_FINAL-LPRIO     .
    LS_FINAL-VSBED                 =          WA_FINAL-VSBED     .
    LS_FINAL-VWERK                 =          WA_FINAL-VWERK     .
    LS_FINAL-INCO1                 =          WA_FINAL-INCO1     .
    LS_FINAL-INCO_TEXT             =          WA_FINAL-INCO_TEXT .
    LS_FINAL-INCO2                 =          WA_FINAL-INCO2     .
    LS_FINAL-ZTERM                 =          WA_FINAL-ZTERM     .
    LS_FINAL-VTEXT                 =          WA_FINAL-VTEXT     .
    LS_FINAL-KTGRD                 =          WA_FINAL-KTGRD     .
    LS_FINAL-JOCG                  =          WA_FINAL-JOCG      .
    LS_FINAL-JOSG                  =          WA_FINAL-JOSG      .
    LS_FINAL-JOIG                  =          WA_FINAL-JOIG      .
    LS_FINAL-JOUG                  =          WA_FINAL-JOUG      .
    LS_FINAL-TCS                   =          WA_FINAL-TCS      .
*LS_FINAL-PARVW                  =          WA_FINAL-PARVW           .
    LS_FINAL-J_1IEXCD               =          WA_FINAL-J_1IEXCD        .
    LS_FINAL-J_1IEXRN               =          WA_FINAL-J_1IEXRN        .
    LS_FINAL-J_1IEXRG               =          WA_FINAL-J_1IEXRG        .
    LS_FINAL-J_1IEXDI               =          WA_FINAL-J_1IEXDI        .
    LS_FINAL-J_1IEXCO               =          WA_FINAL-J_1IEXCO        .
    LS_FINAL-J_1IEXCICU             =          WA_FINAL-J_1IEXCICU      .
    LS_FINAL-J_1ICSTNO              =          WA_FINAL-J_1ICSTNO       .
    LS_FINAL-J_1ILSTNO              =          WA_FINAL-J_1ILSTNO       .
    LS_FINAL-J_1ISERN               =          WA_FINAL-J_1ISERN        .
    LS_FINAL-J_1IPANNO              =          WA_FINAL-J_1IPANNO       .
    LS_FINAL-J_1IPANREF             =          WA_FINAL-J_1IPANREF      .
    LS_FINAL-KUNN2_AG                  =          WA_FINAL-KUNN2_AG      .                  " Add subodh 19 feb 2018
    LS_FINAL-KUNN2_RE                  =          WA_FINAL-KUNN2_RE      .                  "" Add subodh 19 feb 2018
    LS_FINAL-KUNN2_RG                =            WA_FINAL-KUNN2_RG      .                   " Add subodh 19 feb 2018
    LS_FINAL-KUNN2_WE                =            WA_FINAL-KUNN2_WE      .                   " Add subodh 19 feb 2018
    LS_FINAL-ERDAT                   =           WA_FINAL-ERDAT.
    LS_FINAL-STCD3                   =           WA_FINAL-STCD3.
    LS_FINAL-ALTKN                  =            WA_FINAL-ALTKN.
    LS_FINAL-LOCATION               =            WA_FINAL-LOCATION.
    LS_FINAL-KURST               =            WA_FINAL-KURST.                                 ""EXCHANGE RATE
    LS_FINAL-UDATE                  =            WA_FINAL-UDATE.
*************************************************************************************************************








***************************************************************************************************************
    LS_FINAL-REF = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-REF
      IMPORTING
        OUTPUT = LS_FINAL-REF.

    CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                    INTO LS_FINAL-REF SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-ERDAT
      IMPORTING
        OUTPUT = LS_FINAL-ERDAT.

    CONCATENATE LS_FINAL-ERDAT+0(2) LS_FINAL-ERDAT+2(3) LS_FINAL-ERDAT+5(4)
                    INTO LS_FINAL-ERDAT SEPARATED BY '-'.

    LS_FINAL-TIME = SY-UZEIT.
    CONCATENATE LS_FINAL-TIME+0(2) ':' LS_FINAL-TIME+2(2)  INTO LS_FINAL-TIME.


********************************************************END ********************************


    APPEND LS_FINAL TO LT_FINAL.
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
    CLEAR : WA_FINAL-FI_ZTERM,WA_FINAL-FI_VTEXT,WA_FINAL-INCO_TEXT,WA_FINAL-JOCG,WA_FINAL-JOSG,WA_FINAL-JOIG,WA_FINAL-JOUG.
  ENDLOOP.
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
  PERFORM FCAT USING : '1'  'KTOKD '                 'IT_FINAL'  'A/C Group'                        '18' ,
                       '2'  'KUNNR '                 'IT_FINAL'  'Customer Code'                    '18',
                       '3'  'BUKRS '                 'IT_FINAL'  'Company Code'                     '18' ,
                       '4'  'VKORG '                 'IT_FINAL'  'Sales Org.'                       '18' ,
                       '5'  'VTWEG '                 'IT_FINAL'  'Dist. Chan.'                      '10' ,
                       '6'  'SPART '                 'IT_FINAL'  'Division'                         '30' ,
                       '7'  'ANRED '                 'IT_FINAL'  'Title'                            '30' ,
                       '8'  'NAME1 '                 'IT_FINAL'  'Name 1'                           '10' ,
                       '9'  'NAME2 '                 'IT_FINAL'  'Name 2'                           '10' ,
                      '10'  'NAME3 '                 'IT_FINAL'  'Name 3'                           '10' ,
                      '11'  'SORT1 '                 'IT_FINAL'  'Search Term'                      '10' ,
                      '12'  'STREET    '             'IT_FINAL'  'Street'                           '30' ,
                      '13'  'STR_SUPPL1 '            'IT_FINAL'  'Street 2'                         '30' ,
                      '14'  'STR_SUPPL2'             'IT_FINAL'  'Street 3'                         '30' ,
                      '15'  'STR_SUPPL3'             'IT_FINAL'  'Street 4'                         '30' ,
                      '16'  'HOUSE_NUM1'             'IT_FINAL'  'House NO'                         '10' ,
                      '17'  'POST_CODE1'             'IT_FINAL'  'City postal code'                 '18' ,
                      '18'  'CITY2     '             'IT_FINAL'  'District'                         '18' ,
                      '19'  'CITY1   '               'IT_FINAL'  'City'                             '18' ,
                      '20'  'COUNTRY '               'IT_FINAL'  'Country Key'                      '18' ,
                      '21'  'LANDX '                 'IT_FINAL'  'Country'                          '18' ,
                      '22'  'REGION '                'IT_FINAL'  'Region Code'                      '18' ,
                      '23'  'BEZEI'                  'IT_FINAL'  'Region'                           '18' ,
                      '24'  'LANGU     '             'IT_FINAL'  'Language'                         '10' ,
                      '25'  'TEL_NUMBER'             'IT_FINAL'  'Telephone NO'                     '10' ,
                      '26'  'TELF2'                  'IT_FINAL'  'Mobile NO'                        '10' ,
                      '27'  'FAX_NUMBER'             'IT_FINAL'  'Fax no'                           '10' ,
                      '28'  'SMTP_ADDR '             'IT_FINAL'  'E-Mail'                           '18' ,
                      '29'  'AKONT '                 'IT_FINAL'  'Recon A/C'                        '18' ,
                      '30'  'ZUAWA '                 'IT_FINAL'  'Sort key '                        '18' ,
                      '31'  'TTEXT '                 'IT_FINAL'  'Des.Sort Key'                     '18' ,
                      '32'  'FI_ZTERM '              'IT_FINAL'  'Term Of Pay'                      '18' ,
                      '33'  'FI_VTEXT '              'IT_FINAL'  'Term Of Pay'                      '18' ,
                      '34'  'XVERR '                 'IT_FINAL'  'Clearing with vendor '            '18' ,
                      '35'  'ZWELS '                 'IT_FINAL'  'Pay. Method'                      '18' ,
                      '36'  'KNRZB '                 'IT_FINAL'  'Alter. Payer'                     '18' ,
                      '37'  'HBKID '                 'IT_FINAL'  'House Bank'                       '18' ,
                      '38'  'VKBUR '                 'IT_FINAL'  'Sales Office'                     '18' ,
                      '39'  'KDGRP '                 'IT_FINAL'  'Customer GRP'                     '18' ,
                      '40'  'WAERS '                 'IT_FINAL'  'Currency'                         '18' ,
                      '41'  'KALKS '                 'IT_FINAL'  'Cust pricing'                     '18' ,
                      '42'  'VERSG '                 'IT_FINAL'  'Cust.Stats.Grp'                   '18' ,
                      '43'  'KVGR1 '                 'IT_FINAL'  'Customer Grp1'                    '18' ,
                      '44'  'LPRIO '                 'IT_FINAL'  'Delivery Priority'                '18' ,
                      '45'  'VSBED '                 'IT_FINAL'  'Shipping Cond'                    '18' ,
                      '46'  'VWERK '                 'IT_FINAL'  'Delivering Plant'                 '18' ,
                      '47'  'INCO1 '                 'IT_FINAL'  'INCO1'                            '18' ,
                      '48'  'INCO_TEXT'              'IT_FINAL'  'Desc.INCO1'                       '18' ,
                      '49'  'INCO2 '                 'IT_FINAL'  'INCO2'                            '18' ,
                      '50'  'ZTERM '                 'IT_FINAL'  'Terms of Payment'                 '18' ,
                      '51'  'VTEXT'                 'IT_FINAL'   'Terms of Payment'                 '18' ,
                      '52'  'KTGRD '                 'IT_FINAL'  'Acct assgmt grp'                  '18' ,
                      '53'  'JOCG '                  'IT_FINAL'  'TAX JOCG'                         '18' ,
                      '54'  'JOSG '                  'IT_FINAL'  'TAX JOSG'                         '18' ,
                      '55'  'JOIG '                  'IT_FINAL'  'TAX JOIG'                         '18' ,
                      '56'  'JOUG '                  'IT_FINAL'  'TAX JOUG'                         '18' ,
                      '57'  'J_1IEXCD  '             'IT_FINAL'  'ECC No.'                          '18' ,
                      '58'  'J_1IEXRN  '             'IT_FINAL'  'Excise Reg. No.'                  '18' ,
                      '59'  'J_1IEXRG  '             'IT_FINAL'  'Excise Range'                     '18' ,
                      '60'  'J_1IEXDI  '             'IT_FINAL'  'Excise Division'                  '18' ,
                      '61'  'J_1IEXCO  '             'IT_FINAL'  'Commissionerate'                  '18' ,
                      '62'  'J_1IEXCICU'             'IT_FINAL'  'Exc.Ind.Cust.'                    '18' ,
                      '63'  'J_1ICSTNO '             'IT_FINAL'  'CST no.'                          '18' ,
                      '64'  'J_1ILSTNO '             'IT_FINAL'  'LST no.'                          '18' ,
                      '65'  'J_1ISERN  '             'IT_FINAL'  'Ser.Reg.No'                       '18' ,
                      '66'  'J_1IPANNO '             'IT_FINAL'  'PAN No.'                          '18' ,
                      '67'  'J_1IPANREF'             'IT_FINAL'  'PAN Ref'                          '18' ,
                      '68'  'STCD3'                  'IT_FINAL'  'GSTIN No'                         '18' ,
                      '69'  'KUNN2_AG'               'IT_FINAL'  'Shift To Party'                         '18' ,
                      '70'  'KUNN2_RE'               'IT_FINAL'  'Sold To Part'                         '18' ,
                      '71'  'KUNN2_RG'               'IT_FINAL'  'Payer'                         '18' ,
                      '72'  'KUNN2_WE'               'IT_FINAL'  'Build To Party'                         '18' ,
                      '73'  'ERDAT'               'IT_FINAL'  'Creation Date'                         '18' ,
                      '74'  'ALTKN'                 'IT_FINAL' 'Old Customer Code'                    '18',
                      '75'  'TCS'                  'IT_FINAL'  'Tax TCS'                    '18',
*
*                     '24'  'SMTP_ADDR '     'IT_FINAL'  'E-Mail'                     '18' ,
*                     '18'  'REGION  '       'IT_FINAL'  'Region'                     '18' ,
*                     '19'  'BEZEI  '        'IT_FINAL'  'Reg.Desc'                   '18' ,
*                     '20'  'PO_BOX  '       'IT_FINAL'  'PO Box'                     '10' .
                     '76'    'LOCATION'             'IT_FINAL'   'STREET 5'      '18',
                     '76'    'KURST'             'IT_FINAL'   'Exchange Rate Type'      '18',
                     '77'    'UDATE'                'IT_FINAL'   'Last Changed Date'         '18'.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1203   text
*      -->P_1204   text
*      -->P_1205   text
*      -->P_1206   text
*      -->P_1207   text
*----------------------------------------------------------------------*
FORM FCAT  USING     VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

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
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = LT_FINAL
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
  LV_FILE = 'ZCUST_MASTER.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.
*BREAK primus.
  WRITE: / 'ZCUSTOMER MASTER started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1292 TYPE STRING.
    DATA LV_CRLF_1292 TYPE STRING.
    LV_CRLF_1292 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1292 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
*CONCATENATE lv_string_676 lv_crlf_676 wa_csv INTO lv_string_676.
      CONCATENATE LV_STRING_1292 LV_CRLF_1292 WA_CSV INTO LV_STRING_1292.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_1292 TO LV_FULLFILE.
*TRANSFER lv_string_1292 TO lv_fullfile.
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
  CONCATENATE 'A/C Group'
              'Customer Code'
              'Company Code'
              'Sales Org.'
              'Dist. Chan.'
              'Division'
              'Title'
              'Name 1'
              'Name 2'
              'Name 3'
              'Search Term'
              'Street'
              'Street 2'
              'Street 3'
              'Street 4'
              'House NO'
              'City postal code'
              'District'
              'City'
              'Country Key'
              'Country'
              'Region Code'
              'Region'
              'Language'
              'Telephone NO'
              'Mobile NO'
              'Fax no'
              'E-Mail'
              'Recon A/C'
              'Sort key '
              'Des.Sort Key'
              'Term Of Pay'
              'Term Of Pay'
              'Clearing with vendor '
              'Pay. Method'
              'Alter. Payer'
              'House Bank'
              'Sales Office'
              'Customer GRP'
              'Currency'
              'Cust pricing'
              'Cust.Stats.Grp'
              'Customer Grp1'
              'Delivery Priority'
              'Shipping Cond'
              'Delivering Plant'
              'INCO1'
              'Desc.INCO1'
              'INCO2'
              'Terms of Payment'
              'Terms of Payment'
              'Acct assgmt grp'
              'TAX JOCG'
              'TAX JOSG'
              'TAX JOIG'
              'TAX JOUG'
              'ECC No.'
              'Excise Reg. No.'
              'Excise Range'
              'Excise Division'
              'Commissionerate'
              'Exc.Ind.Cust.'
              'CST no.'
              'LST no.'
              'Ser.Reg.No'
              'PAN No.'
              'PAN Ref'
              'GSTIN No'
              'Shift To Party'    " add subodh 19 feb 2018
              'Sold To Part'      " add subodh 19 feb 2018
              'Payer'             " add subodh 19 feb 2018
              'Build To Party'    " add subodh 19 feb 2018
              'Creation Date'
              'Old Customer Code'
              'Tax TCS'
              'Street 5'
              'Exchange Rate Type'
              'Last Changed Date'
              'Refresh File Time'
               'Refresh Date'
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
