*&---------------------------------------------------------------------*
*& Report ZMM_VENDOR_UPLOAD_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_VENDOR_UPLOAD_REPORT.

TYPE-POOLS: SLIS.
TABLES: LFB1.


TYPES: BEGIN OF TY_LFA1,
         LIFNR     TYPE LFA1-LIFNR,
         KTOKK     TYPE LFA1-KTOKK,
         KUNNR     TYPE LFA1-KUNNR,
         ADRNR     TYPE LFA1-ADRNR,
         NAME1     TYPE LFA1-NAME1,
         NAME2     TYPE LFA1-NAME2,
         SORTL     TYPE LFA1-SORTL,
         ANRED     TYPE LFA1-ANRED,
         STCD3     TYPE LFA1-STCD3,
         ERDAT     TYPE LFA1-ERDAT,
         LOEVM     TYPE LFA1-LOEVM,
         J_1KFTBUS TYPE LFA1-J_1KFTBUS,
         J_1KFTIND TYPE LFA1-J_1KFTIND,
         SPERM     TYPE LFA1-SPERM,
       END OF TY_LFA1,

***********************************************ADDED BY DH 08.09.22
       BEGIN OF TY_LFA12,
*         lifnr     TYPE lfa1-lifnr,
         LIFNR     TYPE CDHDR-OBJECTID,
         KTOKK     TYPE LFA1-KTOKK,
         KUNNR     TYPE LFA1-KUNNR,
         ADRNR     TYPE LFA1-ADRNR,
         NAME1     TYPE LFA1-NAME1,
         NAME2     TYPE LFA1-NAME2,
         SORTL     TYPE LFA1-SORTL,
         ANRED     TYPE LFA1-ANRED,
         STCD3     TYPE LFA1-STCD3,
         ERDAT     TYPE LFA1-ERDAT,
         LOEVM     TYPE LFA1-LOEVM,
         J_1KFTBUS TYPE LFA1-J_1KFTBUS,
         J_1KFTIND TYPE LFA1-J_1KFTIND,
         SPERM     TYPE LFA1-SPERM,
       END OF TY_LFA12,

       BEGIN OF TY_CDHDR,
         OBJECTID TYPE STRING,
         UDATE    TYPE CDHDR-UDATE,
       END OF TY_CDHDR,

****************************************************************************

       BEGIN OF TY_ADRC,
         ADDRNUMBER TYPE ADRC-ADDRNUMBER,
         STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
         STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
         STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
         STREET     TYPE ADRC-STREET,
         COUNTRY    TYPE ADRC-COUNTRY,
         HOUSE_NUM1 TYPE ADRC-HOUSE_NUM1,
         CITY1      TYPE ADRC-CITY1,
         CITY2      TYPE ADRC-CITY2,
         POST_CODE1 TYPE ADRC-POST_CODE1,
         REGION     TYPE ADRC-REGION,
         PO_BOX     TYPE ADRC-PO_BOX,
         LANGU      TYPE ADRC-LANGU,
         TEL_NUMBER TYPE ADRC-TEL_NUMBER,
         FAX_NUMBER TYPE ADRC-FAX_NUMBER,
       END OF TY_ADRC,

       BEGIN OF TY_ADR6,
         ADDRNUMBER TYPE ADR6-ADDRNUMBER,
         CONSNUMBER TYPE ADR6-CONSNUMBER,
         SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
       END OF TY_ADR6,

       BEGIN OF TY_LFBK,
         LIFNR TYPE LFBK-LIFNR,
         BANKS TYPE LFBK-BANKS,
         BANKL TYPE LFBK-BANKL,
         BANKN TYPE LFBK-BANKN,
         KOINH TYPE LFBK-KOINH,
       END OF TY_LFBK,

       BEGIN OF TY_BNKA,
         BANKS TYPE BNKA-BANKS,
         BANKL TYPE BNKA-BANKL,
         BANKA TYPE BNKA-BANKA,
         ADRNR TYPE BNKA-ADRNR,
         BRNCH TYPE BNKA-BRNCH,
         PROVZ TYPE BNKA-PROVZ,
         STRAS TYPE BNKA-STRAS,
         ORT01 TYPE BNKA-ORT01,
         SWIFT TYPE BNKA-SWIFT,
       END OF TY_BNKA,


       BEGIN OF TY_LFB1,
         LIFNR TYPE LFB1-LIFNR,
         BUKRS TYPE LFB1-BUKRS,
         ERDAT TYPE LFB1-ERDAT,
         ZUAWA TYPE LFB1-ZUAWA,
         AKONT TYPE LFB1-AKONT,
         ZTERM TYPE LFB1-ZTERM,
         REPRF TYPE LFB1-REPRF,

       END OF TY_LFB1,

       BEGIN OF TY_LFM1,
         LIFNR TYPE LFM1-LIFNR,
         EKORG TYPE LFM1-EKORG,
         WAERS TYPE LFM1-WAERS,
         ZTERM TYPE LFM1-ZTERM,
         INCO1 TYPE LFM1-INCO1,
         INCO2 TYPE LFM1-INCO2,
         WEBRE TYPE LFM1-WEBRE,
         LEBRE TYPE LFM1-LEBRE,
         KZABS TYPE LFM1-KZABS,
         VERKF TYPE LFM1-VERKF,
         TELF1 TYPE LFM1-TELF1,
         XERSY TYPE LFM1-XERSY,
         XERSR TYPE LFM1-XERSR,
       END OF TY_LFM1,

       BEGIN OF TY_J_1IMOVEND,
         LIFNR     TYPE J_1IMOVEND-LIFNR,
         J_1ICSTNO TYPE J_1IMOVEND-J_1ICSTNO,
         J_1ILSTNO TYPE J_1IMOVEND-J_1ILSTNO,
         J_1ISERN  TYPE J_1IMOVEND-J_1ISERN,
         J_1IEXCD  TYPE J_1IMOVEND-J_1IEXCD,
         J_1IEXRN  TYPE J_1IMOVEND-J_1IEXRN,
         J_1IEXRG  TYPE J_1IMOVEND-J_1IEXRG,
         J_1IEXDI  TYPE J_1IMOVEND-J_1IEXDI,
         J_1IEXCO  TYPE J_1IMOVEND-J_1IEXCO,
         J_1IVTYP  TYPE J_1IMOVEND-J_1IVTYP,
         J_1IPANNO TYPE J_1IMOVEND-J_1IPANNO,
         J_1ISSIST TYPE J_1IMOVEND-J_1ISSIST,
         VEN_CLASS TYPE J_1IMOVEND-VEN_CLASS,
       END OF TY_J_1IMOVEND,

       BEGIN OF TY_LFBW,
         LIFNR     TYPE LFBW-LIFNR,
         WT_WITHCD TYPE LFBW-WT_WITHCD,
         WT_SUBJCT TYPE LFBW-WT_SUBJCT,
       END OF TY_LFBW,

       BEGIN OF TY_T005U,
         SPRAS TYPE T005U-SPRAS,
         LAND1 TYPE T005U-LAND1,
         BLAND TYPE T005U-BLAND,
         BEZEI TYPE T005U-BEZEI,
       END OF TY_T005U,

       BEGIN OF TY_TINCT,
         SPRAS TYPE TINCT-SPRAS,
         INCO1 TYPE TINCT-INCO1,
         BEZEI TYPE TINCT-BEZEI,
       END OF TY_TINCT,

       BEGIN OF TY_TVZBT,
         SPRAS TYPE TVZBT-SPRAS,
         ZTERM TYPE TVZBT-ZTERM,
         VTEXT TYPE TVZBT-VTEXT,
       END OF TY_TVZBT,

       BEGIN OF TY_T059U,
         SPRAS  TYPE T059U-SPRAS,
         LAND1  TYPE T059U-LAND1,
         WITHT  TYPE T059U-WITHT,
         TEXT40 TYPE T059U-TEXT40,
       END OF TY_T059U,


       BEGIN OF TY_FINAL,
         LIFNR      TYPE LFA1-LIFNR,
         BUKRS      TYPE LFB1-BUKRS,
         EKORG      TYPE LFM1-EKORG,
         KTOKK      TYPE LFA1-KTOKK,
         ANRED      TYPE LFA1-ANRED,
         NAME1      TYPE LFA1-NAME1,
         NAME2      TYPE LFA1-NAME2,
         SORTL      TYPE LFA1-SORTL,
         STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
         STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
         STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
         STREET     TYPE ADRC-STREET,
         HOUSE_NUM1 TYPE ADRC-HOUSE_NUM1,
         CITY2      TYPE ADRC-CITY2,
         POST_CODE1 TYPE ADRC-POST_CODE1,
         CITY1      TYPE ADRC-CITY1,
         COUNTRY    TYPE ADRC-COUNTRY,
         REGION     TYPE ADRC-REGION,
         BEZEI      TYPE T005U-BEZEI,
         PO_BOX     TYPE ADRC-PO_BOX,
         LANGU      TYPE ADRC-LANGU,
         TEL_NUMBER TYPE ADRC-TEL_NUMBER,
         FAX_NUMBER TYPE ADRC-FAX_NUMBER,
         SMTP_ADDR1 TYPE ADR6-SMTP_ADDR,                   "ADDED BY SNEHAL RAJALE ON 5 MARCH 2021
         SMTP_ADDR2 TYPE ADR6-SMTP_ADDR,                   "ADDED BY SNEHAL RAJALE ON 5 MARCH 2021
         SMTP_ADDR3 TYPE ADR6-SMTP_ADDR,                   "ADDED BY SNEHAL RAJALE ON 5 MARCH 2021
         BANKS      TYPE LFBK-BANKS,
         BANKL      TYPE LFBK-BANKL,
         BANKN      TYPE LFBK-BANKN,
         KOINH      TYPE LFBK-KOINH,
         BANKA      TYPE BNKA-BANKA,
         BRNCH      TYPE BNKA-BRNCH,
         PROVZ      TYPE BNKA-PROVZ,
         STRAS      TYPE BNKA-STRAS,
         ORT01      TYPE BNKA-ORT01,
         SWIFT      TYPE BNKA-SWIFT,
         AKONT      TYPE LFB1-AKONT,
         ZUAWA      TYPE LFB1-ZUAWA,
         ZTERM1     TYPE LFB1-ZTERM,
         VTEXT1     TYPE TVZBT-VTEXT,
         REPRF      TYPE LFB1-REPRF,
         WAERS      TYPE LFM1-WAERS,
         ZTERM      TYPE LFM1-ZTERM,
         VTEXT      TYPE TVZBT-VTEXT,
         INCO1      TYPE LFM1-INCO1,
         INCO_TEXT  TYPE TINCT-BEZEI,
         INCO2      TYPE LFM1-INCO2,
         WEBRE      TYPE LFM1-WEBRE,
         LEBRE      TYPE LFM1-LEBRE,
         KZABS      TYPE LFM1-KZABS,
         KUNNR      TYPE LFA1-KUNNR,
         J_1ICSTNO  TYPE J_1IMOVEND-J_1ICSTNO,
         J_1ILSTNO  TYPE J_1IMOVEND-J_1ILSTNO,
         J_1ISERN   TYPE J_1IMOVEND-J_1ISERN,
         J_1IEXCD   TYPE J_1IMOVEND-J_1IEXCD,
         J_1IEXRN   TYPE J_1IMOVEND-J_1IEXRN,
         J_1IEXRG   TYPE J_1IMOVEND-J_1IEXRG,
         J_1IEXDI   TYPE J_1IMOVEND-J_1IEXDI,
         J_1IEXCO   TYPE J_1IMOVEND-J_1IEXCO,
         J_1IVTYP   TYPE J_1IMOVEND-J_1IVTYP,
         J_1IPANNO  TYPE J_1IMOVEND-J_1IPANNO,
         WT_WITHCD  TYPE LFBW-WT_WITHCD,
         TEXT40     TYPE T059U-TEXT40,
         WT_SUBJCT  TYPE LFBW-WT_SUBJCT,
         STCD3      TYPE LFA1-STCD3,
         ERDAT      TYPE LFA1-ERDAT,
         STATUS     TYPE STRING,
         LOEVM      TYPE LFA1-LOEVM,
         VEN_CLASS  TYPE CHAR100,
         VERKF      TYPE LFM1-VERKF,
         TELF1      TYPE LFM1-TELF1,
         TXT1       TYPE CHAR255,
         TXT2       TYPE CHAR255,
         TXT3       TYPE CHAR255,
         TXT4       TYPE CHAR255,
         TXT5       TYPE CHAR255,
         TXT6       TYPE CHAR255,
         TXT7       TYPE CHAR255,
         TXT8       TYPE CHAR255,
         TXT9       TYPE CHAR255,
         TXT10      TYPE CHAR255,
         TXT11      TYPE CHAR255,
         TXT12      TYPE CHAR255,
         TXT13      TYPE CHAR255,
         TXT14      TYPE CHAR255,
         TXT15      TYPE CHAR255,
         TXT16      TYPE CHAR255,
         TXT17      TYPE CHAR255,
         TXT18      TYPE CHAR255,
         TXT19      TYPE CHAR255,
         TXT20      TYPE CHAR255,
         J_1KFTBUS  TYPE LFA1-J_1KFTBUS,
         J_1KFTIND  TYPE LFA1-J_1KFTIND,
         SPERM      TYPE LFA1-SPERM,

***********************************************************
         OBJECTID   TYPE STRING,                      "DH 08.09.22
         UDATE      TYPE CHAR15,    "cdhdr-udate,
***********************************************************
         XERSY      TYPE CHAR5, "ADDED BY sonu
         XERSR      TYPE CHAR5, "ADDED BY sonu

       END OF TY_FINAL.

********************************************Structure For Download file************************************
TYPES : BEGIN OF ITAB,
          LIFNR      TYPE CHAR15,
          BUKRS      TYPE CHAR10,
          EKORG      TYPE CHAR10,
          KTOKK      TYPE CHAR10,
          ANRED      TYPE CHAR15,
          NAME1      TYPE CHAR50,
          NAME2      TYPE CHAR50,
          SORTL      TYPE CHAR15,
          STR_SUPPL1 TYPE CHAR50,
          STR_SUPPL2 TYPE CHAR50,
          STR_SUPPL3 TYPE CHAR50,
          STREET     TYPE CHAR70,
          HOUSE_NUM1 TYPE CHAR15,
          CITY2      TYPE CHAR50,
          POST_CODE1 TYPE CHAR15,
          CITY1      TYPE CHAR50,
          COUNTRY    TYPE CHAR10,
          REGION     TYPE CHAR10,
          BEZEI      TYPE CHAR20,
          PO_BOX     TYPE CHAR15,
          LANGU      TYPE CHAR5,
          TEL_NUMBER TYPE CHAR50,
          FAX_NUMBER TYPE CHAR50,
          SMTP_ADDR1 TYPE CHAR250,
          SMTP_ADDR2 TYPE CHAR250,
          SMTP_ADDR3 TYPE CHAR250,
          BANKS      TYPE CHAR10,
          BANKL      TYPE CHAR15,
          BANKN      TYPE CHAR20,
          KOINH      TYPE CHAR100,
          BANKA      TYPE CHAR100,
          BRNCH      TYPE CHAR50,
          PROVZ      TYPE CHAR10,
          STRAS      TYPE CHAR50,
          ORT01      TYPE CHAR50,
          SWIFT      TYPE CHAR15,
          AKONT      TYPE CHAR15,
          ZUAWA      TYPE CHAR10,
          ZTERM1     TYPE CHAR10,
          VTEXT1     TYPE CHAR50,
          REPRF      TYPE CHAR10,
          WAERS      TYPE CHAR10,
          ZTERM      TYPE CHAR10,
          VTEXT      TYPE CHAR50,
          INCO1      TYPE CHAR10,
          INCO_TEXT  TYPE CHAR50,
          INCO2      TYPE CHAR50,
          WEBRE      TYPE CHAR10,
          LEBRE      TYPE CHAR10,
          KZABS      TYPE CHAR10,
          KUNNR      TYPE CHAR20,
          J_1ICSTNO  TYPE CHAR80,
          J_1ILSTNO  TYPE CHAR50,
          J_1ISERN   TYPE CHAR50,
          J_1IEXCD   TYPE CHAR50,
          J_1IEXRN   TYPE CHAR50,
          J_1IEXRG   TYPE CHAR80,
          J_1IEXDI   TYPE CHAR80,
          J_1IEXCO   TYPE CHAR80,
          J_1IVTYP   TYPE CHAR10,
          J_1IPANNO  TYPE CHAR50,
          WT_WITHCD  TYPE CHAR10,
          TEXT40     TYPE CHAR50,
          WT_SUBJCT  TYPE CHAR10,
          STCD3      TYPE CHAR20,
          REF        TYPE CHAR15,
          ERDAT      TYPE CHAR15,
          STATUS     TYPE STRING,
          LOEVM      TYPE LFA1-LOEVM,
          VEN_CLASS  TYPE CHAR100,
          VERKF      TYPE CHAR50,
          TELF1      TYPE CHAR20,
          TXT1       TYPE CHAR255,
          TXT2       TYPE CHAR255,
          TXT3       TYPE CHAR255,
          TXT4       TYPE CHAR255,
          TXT5       TYPE CHAR255,
          TXT6       TYPE CHAR255,
          TXT7       TYPE CHAR255,
          TXT8       TYPE CHAR255,
          TXT9       TYPE CHAR255,
          TXT10      TYPE CHAR255,
          TXT11      TYPE CHAR255,
          TXT12      TYPE CHAR255,
          TXT13      TYPE CHAR255,
          TXT14      TYPE CHAR255,
          TXT15      TYPE CHAR255,
          TXT16      TYPE CHAR255,
          TXT17      TYPE CHAR255,
          TXT18      TYPE CHAR255,
          TXT19      TYPE CHAR255,
          TXT20      TYPE CHAR255,
          J_1KFTBUS  TYPE CHAR50,
          J_1KFTIND  TYPE CHAR50,
          UDATE      TYPE CHAR18, "cdhdr-udate,      "DH 08.09.22
          SPERM      TYPE LFA1-SPERM,
          XERSY      TYPE CHAR5, "ADDED BY sonu
          XERSR      TYPE CHAR5, "ADDED BY sonu
        END OF ITAB.

DATA : LT_FINAL TYPE TABLE OF ITAB,
       LS_FINAL TYPE          ITAB.
********************************************************************************************************************


DATA : IT_LFA1       TYPE TABLE OF TY_LFA1,
       WA_LFA1       TYPE          TY_LFA1,

       IT_LFA12      TYPE TABLE OF TY_LFA12,
       WA_LFA12      TYPE          TY_LFA12,

       IT_LFB1       TYPE TABLE OF TY_LFB1,
       WA_LFB1       TYPE          TY_LFB1,

       IT_LFM1       TYPE TABLE OF TY_LFM1,
       WA_LFM1       TYPE          TY_LFM1,

       IT_ADRC       TYPE TABLE OF TY_ADRC,
       WA_ADRC       TYPE          TY_ADRC,

       IT_ADR6       TYPE TABLE OF TY_ADR6,
       WA_ADR6       TYPE          TY_ADR6,

       IT_LFBK       TYPE TABLE OF TY_LFBK,
       WA_LFBK       TYPE          TY_LFBK,

       IT_LFBW       TYPE TABLE OF TY_LFBW,
       WA_LFBW       TYPE          TY_LFBW,

       IT_BNKA       TYPE TABLE OF TY_BNKA,
       WA_BNKA       TYPE          TY_BNKA,

       IT_T005U      TYPE TABLE OF TY_T005U,
       WA_T005U      TYPE          TY_T005U,

       IT_TINCT      TYPE TABLE OF TY_TINCT,
       WA_TINCT      TYPE          TY_TINCT,

       IT_MM_TVZBT   TYPE TABLE OF TY_TVZBT,
       WA_MM_TVZBT   TYPE          TY_TVZBT,

       IT_FI_TVZBT   TYPE TABLE OF TY_TVZBT,
       WA_FI_TVZBT   TYPE          TY_TVZBT,

       IT_T059U      TYPE TABLE OF TY_T059U,
       WA_T059U      TYPE          TY_T059U,

       IT_J_1IMOVEND TYPE TABLE OF TY_J_1IMOVEND,
       WA_J_1IMOVEND TYPE          TY_J_1IMOVEND,

       IT_FINAL      TYPE TABLE OF TY_FINAL,
       WA_FINAL      TYPE          TY_FINAL,

*****************************************************************"DH 08.09.22
       IT_CDHDR      TYPE TABLE OF TY_CDHDR,
       WA_CDHDR      TYPE          TY_CDHDR,

       LV_LIFNR      TYPE CDHDR-OBJECTID,
       LV_LIFNR1     TYPE LFA1-LIFNR.
****************************************************************

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_LIFNR FOR LFB1-LIFNR,
                  S_BUKRS FOR LFB1-BUKRS DEFAULT '1000' NO INTERVALS MODIF ID BU ," ADDED BY MD
                  S_ERDAT FOR LFB1-ERDAT.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETER :  P_FILE AS CHECKBOX.  " commented by sonu
*  p_file TYPE rlgrap-filename .
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
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
  SELECT LIFNR
         BUKRS
         ERDAT
         ZUAWA
         AKONT
         ZTERM
         REPRF FROM LFB1 INTO TABLE IT_LFB1
         WHERE LIFNR IN S_LIFNR
         AND   BUKRS IN S_BUKRS
         AND   ERDAT IN S_ERDAT.

  IF  IT_LFB1 IS NOT INITIAL.
    SELECT LIFNR
           KTOKK
           KUNNR
           ADRNR
           NAME1
           NAME2
           SORTL
           ANRED
           STCD3
           ERDAT
           LOEVM
           J_1KFTBUS
           J_1KFTIND
           SPERM
           FROM LFA1 INTO TABLE IT_LFA1
           FOR ALL ENTRIES IN IT_LFB1
           WHERE LIFNR = IT_LFB1-LIFNR.


  ENDIF.

********************************************************ADDED BY DH 08.09.22
  IF IT_LFA1 IS NOT INITIAL.
    LOOP AT IT_LFA1 INTO WA_LFA1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = WA_LFA1-LIFNR
        IMPORTING
          OUTPUT = LV_LIFNR.

      MOVE-CORRESPONDING WA_LFA1 TO WA_LFA12.
      WA_LFA12-LIFNR = LV_LIFNR.
      APPEND WA_LFA12 TO IT_LFA12.

    ENDLOOP.

*    CLEAR: lv_lifnr, wa_lfa1, wa_lfa12.
  ENDIF.

  LOOP AT IT_LFA12 INTO WA_LFA12.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = WA_LFA12-LIFNR
      IMPORTING
        OUTPUT = LV_LIFNR1.

    WA_LFA12-LIFNR = LV_LIFNR1.
    MODIFY IT_LFA12 FROM WA_LFA12.
  ENDLOOP.

  IF IT_LFA12 IS NOT INITIAL.
    SELECT *
         FROM  CDHDR
         INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
         FOR ALL ENTRIES IN IT_LFA12
         WHERE OBJECTID = IT_LFA12-LIFNR.

  ENDIF.

**************************************************END OF ADDITION BY DH

  IF IT_LFA1 IS NOT INITIAL.



    SELECT ADDRNUMBER
           STR_SUPPL1
           STR_SUPPL2
           STR_SUPPL3
           STREET
           COUNTRY
           HOUSE_NUM1
           CITY1
           CITY2
           POST_CODE1
           REGION
           PO_BOX
           LANGU
           TEL_NUMBER
           FAX_NUMBER  FROM ADRC INTO TABLE IT_ADRC
           FOR ALL ENTRIES IN IT_LFA1
           WHERE ADDRNUMBER = IT_LFA1-ADRNR.

    SELECT LIFNR
           BANKS
           BANKL
           BANKN
           KOINH FROM LFBK INTO TABLE IT_LFBK
           FOR ALL ENTRIES IN IT_LFA1
           WHERE LIFNR = IT_LFA1-LIFNR.

    SELECT LIFNR
           EKORG
           WAERS
           ZTERM
           INCO1
           INCO2
           WEBRE
           LEBRE
           KZABS
           VERKF
           TELF1
           XERSY
           XERSR FROM LFM1 INTO TABLE IT_LFM1
           FOR ALL ENTRIES IN IT_LFA1
           WHERE LIFNR = IT_LFA1-LIFNR.

*    SELECT LIFNR
*           J_1ICSTNO
*           J_1ILSTNO
*           J_1ISERN
*           J_1IEXCD
*           J_1IEXRN
*           J_1IEXRG
*           J_1IEXDI
*           J_1IEXCO
*           J_1IVTYP
*           J_1IPANNO
*           J_1ISSIST
*           VEN_CLASS FROM J_1IMOVEND INTO TABLE IT_J_1IMOVEND
*           FOR ALL ENTRIES IN IT_LFA1
*           WHERE LIFNR = IT_LFA1-LIFNR.

"Replacement of table J_1IMOVEND with LFA1

    SELECT LIFNR
           J_1ICSTNO
           J_1ILSTNO
           J_1ISERN
           J_1IEXCD
           J_1IEXRN
           J_1IEXRG
           J_1IEXDI
           J_1IEXCO
           J_1IVTYP
           J_1IPANNO
           J_1ISSIST
           VEN_CLASS FROM LFA1 INTO TABLE IT_J_1IMOVEND
           FOR ALL ENTRIES IN IT_LFA1
           WHERE LIFNR = IT_LFA1-LIFNR.

    SELECT LIFNR
           WT_WITHCD
           WT_SUBJCT FROM LFBW INTO TABLE IT_LFBW
           FOR ALL ENTRIES IN IT_LFA1
           WHERE LIFNR = IT_LFA1-LIFNR.


  ENDIF.

  IF IT_LFBK IS NOT INITIAL .
    SELECT BANKS
           BANKL
           BANKA
           ADRNR
           BRNCH
           PROVZ
           STRAS
           ORT01
           SWIFT FROM BNKA INTO TABLE IT_BNKA
           FOR ALL ENTRIES IN IT_LFBK
           WHERE BANKS = IT_LFBK-BANKS
           AND   BANKL = IT_LFBK-BANKL.
  ENDIF.
  IF IT_ADRC IS NOT INITIAL.

    SELECT ADDRNUMBER
           CONSNUMBER
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
  ENDIF.

  IF IT_LFM1 IS NOT INITIAL .

    SELECT SPRAS
           INCO1
           BEZEI FROM TINCT INTO TABLE IT_TINCT
           FOR ALL ENTRIES IN IT_LFM1
           WHERE INCO1 = IT_LFM1-INCO1
           AND   SPRAS = 'E'.

    SELECT SPRAS
           ZTERM
           VTEXT FROM TVZBT INTO TABLE IT_MM_TVZBT
           FOR ALL ENTRIES IN IT_LFM1
           WHERE ZTERM = IT_LFM1-ZTERM
           AND   SPRAS = 'E'.

  ENDIF.

  IF IT_LFB1 IS NOT INITIAL .
    SELECT SPRAS
           ZTERM
           VTEXT FROM TVZBT INTO TABLE IT_FI_TVZBT
           FOR ALL ENTRIES IN IT_LFB1
           WHERE ZTERM = IT_LFB1-ZTERM
           AND   SPRAS = 'E'.

  ENDIF.

  IF IT_LFBW IS NOT INITIAL .

    SELECT SPRAS
           LAND1
           WITHT
           TEXT40 FROM T059U INTO TABLE IT_T059U
           FOR ALL ENTRIES IN IT_LFBW
           WHERE WITHT = IT_LFBW-WT_WITHCD
           AND   SPRAS = 'E'
           AND   LAND1 = 'IN'.

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
  LOOP AT IT_LFA1 INTO WA_LFA1.
    WA_FINAL-LIFNR  = WA_LFA1-LIFNR .
    WA_FINAL-KTOKK  = WA_LFA1-KTOKK .
    WA_FINAL-ANRED  = WA_LFA1-ANRED .
    WA_FINAL-NAME1  = WA_LFA1-NAME1 .
    WA_FINAL-NAME2  = WA_LFA1-NAME2 .
    WA_FINAL-SORTL  = WA_LFA1-SORTL .
    WA_FINAL-KUNNR  = WA_LFA1-KUNNR .
    WA_FINAL-STCD3  = WA_LFA1-STCD3 .
    WA_FINAL-ERDAT  = WA_LFA1-ERDAT.
    WA_FINAL-LOEVM  = WA_LFA1-LOEVM.
    WA_FINAL-J_1KFTBUS  = WA_LFA1-J_1KFTBUS.
    WA_FINAL-J_1KFTIND  = WA_LFA1-J_1KFTIND.
    WA_FINAL-SPERM = WA_LFA1-SPERM.

****************************************************************ADDED BY DH 08.09.22
    READ TABLE IT_LFA12 INTO WA_LFA12 WITH KEY LIFNR = WA_LFA1-LIFNR.

    READ TABLE IT_CDHDR INTO WA_CDHDR WITH KEY OBJECTID = WA_LFA12-LIFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-OBJECTID = WA_CDHDR-OBJECTID.
      WA_FINAL-UDATE = WA_CDHDR-UDATE.
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

***********************************************************************************

    READ TABLE IT_LFB1 INTO WA_LFB1 WITH KEY LIFNR = WA_LFA1-LIFNR.
    IF  SY-SUBRC = 0.
      WA_FINAL-BUKRS = WA_LFB1-BUKRS.
      WA_FINAL-AKONT = WA_LFB1-AKONT.
      WA_FINAL-ZUAWA = WA_LFB1-ZUAWA.
      WA_FINAL-REPRF = WA_LFB1-REPRF.
      WA_FINAL-ZTERM1 = WA_LFB1-ZTERM.
    ENDIF.

    READ TABLE IT_ADRC INTO WA_ADRC WITH KEY ADDRNUMBER = WA_LFA1-ADRNR.
    IF SY-SUBRC = 0.
      WA_FINAL-STR_SUPPL1   = WA_ADRC-STR_SUPPL1 .
      WA_FINAL-STR_SUPPL2   = WA_ADRC-STR_SUPPL2 .
      WA_FINAL-STR_SUPPL3   = WA_ADRC-STR_SUPPL3 .
      WA_FINAL-STREET       = WA_ADRC-STREET     .
      WA_FINAL-HOUSE_NUM1   = WA_ADRC-HOUSE_NUM1 .
      WA_FINAL-CITY2        = WA_ADRC-CITY2      .
      WA_FINAL-POST_CODE1   = WA_ADRC-POST_CODE1 .
      WA_FINAL-CITY1        = WA_ADRC-CITY1      .
      WA_FINAL-COUNTRY      = WA_ADRC-COUNTRY    .
      WA_FINAL-REGION       = WA_ADRC-REGION     .
      WA_FINAL-PO_BOX       = WA_ADRC-PO_BOX     .
      WA_FINAL-LANGU        = WA_ADRC-LANGU      .
      WA_FINAL-TEL_NUMBER   = WA_ADRC-TEL_NUMBER .
      WA_FINAL-FAX_NUMBER   = WA_ADRC-FAX_NUMBER .
    ENDIF.
    READ TABLE IT_LFBK INTO WA_LFBK WITH KEY LIFNR = WA_LFA1-LIFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-BANKS = WA_LFBK-BANKS.
      WA_FINAL-BANKL = WA_LFBK-BANKL.
      WA_FINAL-BANKN = WA_LFBK-BANKN.
      WA_FINAL-KOINH = WA_LFBK-KOINH.

    ENDIF.
    READ TABLE IT_LFM1 INTO WA_LFM1 WITH KEY LIFNR = WA_LFA1-LIFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-EKORG = WA_LFM1-EKORG.
      WA_FINAL-WAERS = WA_LFM1-WAERS.
      WA_FINAL-ZTERM = WA_LFM1-ZTERM.
      WA_FINAL-INCO1 = WA_LFM1-INCO1.
      WA_FINAL-INCO2 = WA_LFM1-INCO2.
      WA_FINAL-WEBRE = WA_LFM1-WEBRE.
      WA_FINAL-LEBRE = WA_LFM1-LEBRE.
      WA_FINAL-KZABS = WA_LFM1-KZABS.
      WA_FINAL-VERKF = WA_LFM1-VERKF.
      WA_FINAL-TELF1 = WA_LFM1-TELF1.
***********added by sonu***************************
      IF WA_LFM1-XERSR = 'X'.
        WA_FINAL-XERSR = 'YES'.
      ELSE.
        WA_FINAL-XERSR = 'NO'.
      ENDIF.
      IF WA_LFM1-XERSY = 'X'.
        WA_FINAL-XERSY = 'YES'.
      ELSE.
        WA_FINAL-XERSY = 'NO'.
      ENDIF.
    ENDIF.
***************************************************

    READ TABLE IT_J_1IMOVEND INTO WA_J_1IMOVEND WITH KEY LIFNR = WA_LFA1-LIFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-J_1ICSTNO = WA_J_1IMOVEND-J_1ICSTNO.
      WA_FINAL-J_1ILSTNO = WA_J_1IMOVEND-J_1ILSTNO.
      WA_FINAL-J_1ISERN  = WA_J_1IMOVEND-J_1ISERN .
      WA_FINAL-J_1IEXCD  = WA_J_1IMOVEND-J_1IEXCD .
      WA_FINAL-J_1IEXRN  = WA_J_1IMOVEND-J_1IEXRN .
      WA_FINAL-J_1IEXRG  = WA_J_1IMOVEND-J_1IEXRG .
      WA_FINAL-J_1IEXDI  = WA_J_1IMOVEND-J_1IEXDI .
      WA_FINAL-J_1IEXCO  = WA_J_1IMOVEND-J_1IEXCO .
      WA_FINAL-J_1IVTYP  = WA_J_1IMOVEND-J_1IVTYP .
      WA_FINAL-J_1IPANNO = WA_J_1IMOVEND-J_1IPANNO.

      IF WA_J_1IMOVEND-J_1ISSIST = '1'.
        WA_FINAL-STATUS = 'Micro'.
      ELSEIF WA_J_1IMOVEND-J_1ISSIST = '2'.
        WA_FINAL-STATUS = 'Small'.
      ELSEIF WA_J_1IMOVEND-J_1ISSIST = '3'.
        WA_FINAL-STATUS = 'Medium'.
      ELSEIF WA_J_1IMOVEND-J_1ISSIST = '4'.
        WA_FINAL-STATUS = 'NA'.
      ENDIF.

      IF WA_J_1IMOVEND-VEN_CLASS = ' '.
        WA_FINAL-VEN_CLASS = 'Registered'.
      ELSEIF WA_J_1IMOVEND-VEN_CLASS = '0'.
        WA_FINAL-VEN_CLASS = 'Not Registered'.
      ELSEIF WA_J_1IMOVEND-VEN_CLASS = '1'.
        WA_FINAL-VEN_CLASS = 'Compounding Scheme'.
      ENDIF.


    ENDIF.

    READ TABLE IT_LFBW INTO WA_LFBW WITH KEY LIFNR = WA_LFA1-LIFNR.
    IF  SY-SUBRC = 0.
      WA_FINAL-WT_WITHCD = WA_LFBW-WT_WITHCD.
      WA_FINAL-WT_SUBJCT = WA_LFBW-WT_SUBJCT.

    ENDIF.

    READ TABLE IT_BNKA INTO WA_BNKA WITH KEY BANKS = WA_LFBK-BANKS
                                             BANKL = WA_LFBK-BANKL.
    IF SY-SUBRC = 0.
      WA_FINAL-BANKA  = WA_BNKA-BANKA.
      WA_FINAL-BRNCH  = WA_BNKA-BRNCH.
      WA_FINAL-PROVZ  = WA_BNKA-PROVZ.
      WA_FINAL-STRAS  = WA_BNKA-STRAS.
      WA_FINAL-ORT01  = WA_BNKA-ORT01.
      WA_FINAL-SWIFT  = WA_BNKA-SWIFT.

    ENDIF.

*    READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_ADRC-ADDRNUMBER.
*    IF SY-SUBRC = 0.
*      WA_FINAL-SMTP_ADDR = WA_ADR6-SMTP_ADDR.
*
*    ENDIF.

*******ADDED BY SNEHAL RAJALE ON 5 MARCH 2021********
    LOOP AT IT_ADR6 INTO WA_ADR6 WHERE ADDRNUMBER = WA_ADRC-ADDRNUMBER.
      IF WA_ADR6-CONSNUMBER = '1'.
        WA_FINAL-SMTP_ADDR1 = WA_ADR6-SMTP_ADDR.
      ELSEIF WA_ADR6-CONSNUMBER = '2'.
        WA_FINAL-SMTP_ADDR2 = WA_ADR6-SMTP_ADDR.
      ELSEIF WA_ADR6-CONSNUMBER = '3'.
        WA_FINAL-SMTP_ADDR3 = WA_ADR6-SMTP_ADDR.
      ENDIF.

    ENDLOOP.

    READ TABLE IT_T005U INTO WA_T005U WITH KEY SPRAS = WA_ADRC-LANGU
                                               LAND1 = WA_ADRC-COUNTRY
                                               BLAND = WA_ADRC-REGION.
    IF SY-SUBRC = 0.
      WA_FINAL-BEZEI   =  WA_T005U-BEZEI.

    ENDIF.

    READ TABLE IT_TINCT INTO WA_TINCT WITH KEY INCO1 = WA_LFM1-INCO1
                                               SPRAS = 'E'.
    IF SY-SUBRC = 0.
      WA_FINAL-INCO_TEXT  =   WA_TINCT-BEZEI.

    ENDIF.

    READ TABLE IT_MM_TVZBT INTO WA_MM_TVZBT WITH KEY ZTERM = WA_LFM1-ZTERM
                                                     SPRAS = 'E'.

    IF SY-SUBRC = 0.
      WA_FINAL-VTEXT   = WA_MM_TVZBT-VTEXT.

    ENDIF.


    READ TABLE IT_FI_TVZBT INTO WA_FI_TVZBT WITH KEY ZTERM = WA_LFB1-ZTERM
                                                     SPRAS = 'E'.

    IF SY-SUBRC = 0.
      WA_FINAL-VTEXT1   = WA_FI_TVZBT-VTEXT.

    ENDIF.

    READ TABLE IT_T059U INTO WA_T059U WITH KEY WITHT = WA_LFBW-WT_WITHCD
                                               SPRAS = 'E'
                                               LAND1 = 'IN'.
    IF SY-SUBRC = 0.
      WA_FINAL-TEXT40    =    WA_T059U-TEXT40.

    ENDIF.

**************************************************Vendor Text ************************************************
    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0001'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT1 WA_LINES-TDLINE INTO WA_FINAL-TXT1 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT1.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0002'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT2 WA_LINES-TDLINE INTO WA_FINAL-TXT2 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT2.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0003'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT3 WA_LINES-TDLINE INTO WA_FINAL-TXT3 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT3.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0004'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT4 WA_LINES-TDLINE INTO WA_FINAL-TXT4 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT4.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0005'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT5 WA_LINES-TDLINE INTO WA_FINAL-TXT5 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT5.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0006'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT6 WA_LINES-TDLINE INTO WA_FINAL-TXT6 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT6.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0007'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT7 WA_LINES-TDLINE INTO WA_FINAL-TXT7 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT7.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0008'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT8 WA_LINES-TDLINE INTO WA_FINAL-TXT8 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT8.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0009'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT9 WA_LINES-TDLINE INTO WA_FINAL-TXT9 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT9.
    ENDIF.



    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0010'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT10 WA_LINES-TDLINE INTO WA_FINAL-TXT10 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT10.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0011'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT11 WA_LINES-TDLINE INTO WA_FINAL-TXT11 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT11.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0012'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT12 WA_LINES-TDLINE INTO WA_FINAL-TXT12 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT12.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0013'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT13 WA_LINES-TDLINE INTO WA_FINAL-TXT13 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT1.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0014'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT14 WA_LINES-TDLINE INTO WA_FINAL-TXT14 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT1.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0015'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT15 WA_LINES-TDLINE INTO WA_FINAL-TXT15 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT1.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0016'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT16 WA_LINES-TDLINE INTO WA_FINAL-TXT16 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT1.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0017'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT17 WA_LINES-TDLINE INTO WA_FINAL-TXT17 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT17.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0018'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT18 WA_LINES-TDLINE INTO WA_FINAL-TXT18 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT18.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0019'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT19 WA_LINES-TDLINE INTO WA_FINAL-TXT19 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT1.
    ENDIF.


    CLEAR: LV_LINES, LS_MATTXT,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-LIFNR.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = '0020'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'LFA1'
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
          CONCATENATE WA_FINAL-TXT20 WA_LINES-TDLINE INTO WA_FINAL-TXT20 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TXT20.
    ENDIF.
***********************************************Dowanload Data*********************************************
    LS_FINAL-LIFNR                 =                    WA_FINAL-LIFNR    .
    LS_FINAL-KTOKK                 =                    WA_FINAL-KTOKK .
    LS_FINAL-ANRED                 =                    WA_FINAL-ANRED .
    LS_FINAL-NAME1                 =                    WA_FINAL-NAME1 .
    LS_FINAL-NAME2                 =                    WA_FINAL-NAME2 .
    LS_FINAL-SORTL                 =                    WA_FINAL-SORTL .
    LS_FINAL-KUNNR                 =                    WA_FINAL-KUNNR .
    LS_FINAL-BUKRS                 =                    WA_FINAL-BUKRS.
    LS_FINAL-AKONT                 =                    WA_FINAL-AKONT.
    LS_FINAL-ZUAWA                 =                    WA_FINAL-ZUAWA.
    LS_FINAL-REPRF                 =                    WA_FINAL-REPRF.
    LS_FINAL-ZTERM1                =                    WA_FINAL-ZTERM1.
    LS_FINAL-STR_SUPPL1            =                    WA_FINAL-STR_SUPPL1.
    LS_FINAL-STR_SUPPL2            =                    WA_FINAL-STR_SUPPL2.
    LS_FINAL-STR_SUPPL3            =                    WA_FINAL-STR_SUPPL3.
    LS_FINAL-STREET                =                    WA_FINAL-STREET    .
    LS_FINAL-HOUSE_NUM1            =                    WA_FINAL-HOUSE_NUM1.
    LS_FINAL-CITY2                 =                    WA_FINAL-CITY2     .
    LS_FINAL-POST_CODE1            =                    WA_FINAL-POST_CODE1.
    LS_FINAL-CITY1                 =                    WA_FINAL-CITY1     .
    LS_FINAL-COUNTRY               =                    WA_FINAL-COUNTRY   .
    LS_FINAL-REGION                =                    WA_FINAL-REGION    .
    LS_FINAL-PO_BOX                =                    WA_FINAL-PO_BOX    .
    LS_FINAL-LANGU                 =                    WA_FINAL-LANGU     .
    LS_FINAL-TEL_NUMBER            =                    WA_FINAL-TEL_NUMBER.
    LS_FINAL-FAX_NUMBER            =                    WA_FINAL-FAX_NUMBER.
    LS_FINAL-BANKS                 =                    WA_FINAL-BANKS.
    LS_FINAL-BANKL                 =                    WA_FINAL-BANKL.
    LS_FINAL-BANKN                 =                    WA_FINAL-BANKN.
    LS_FINAL-KOINH                 =                    WA_FINAL-KOINH.
    LS_FINAL-EKORG                 =                    WA_FINAL-EKORG.
    LS_FINAL-WAERS                 =                    WA_FINAL-WAERS.
    LS_FINAL-ZTERM                 =                    WA_FINAL-ZTERM.
    LS_FINAL-INCO1                 =                    WA_FINAL-INCO1.
    LS_FINAL-INCO2                 =                    WA_FINAL-INCO2.
    LS_FINAL-WEBRE                 =                    WA_FINAL-WEBRE.
    LS_FINAL-LEBRE                 =                    WA_FINAL-LEBRE.
    LS_FINAL-KZABS                 =                    WA_FINAL-KZABS.
    LS_FINAL-J_1ICSTNO             =                    WA_FINAL-J_1ICSTNO.
    LS_FINAL-J_1ILSTNO             =                    WA_FINAL-J_1ILSTNO.
    LS_FINAL-J_1ISERN              =                    WA_FINAL-J_1ISERN .
    LS_FINAL-J_1IEXCD              =                    WA_FINAL-J_1IEXCD .
    LS_FINAL-J_1IEXRN              =                    WA_FINAL-J_1IEXRN .
    LS_FINAL-J_1IEXRG              =                    WA_FINAL-J_1IEXRG .
    LS_FINAL-J_1IEXDI              =                    WA_FINAL-J_1IEXDI .
    LS_FINAL-J_1IEXCO              =                    WA_FINAL-J_1IEXCO .
    LS_FINAL-J_1IVTYP              =                    WA_FINAL-J_1IVTYP .
    LS_FINAL-J_1IPANNO             =                    WA_FINAL-J_1IPANNO.
    LS_FINAL-WT_WITHCD             =                    WA_FINAL-WT_WITHCD.
    LS_FINAL-WT_SUBJCT             =                    WA_FINAL-WT_SUBJCT.
    LS_FINAL-BANKA                 =                    WA_FINAL-BANKA.
    LS_FINAL-BRNCH                 =                    WA_FINAL-BRNCH.
    LS_FINAL-PROVZ                 =                    WA_FINAL-PROVZ.
    LS_FINAL-STRAS                 =                     WA_FINAL-STRAS.
    LS_FINAL-ORT01                 =                    WA_FINAL-ORT01.
    LS_FINAL-SWIFT                 =                    WA_FINAL-SWIFT.
*    LS_FINAL-SMTP_ADDR             =                    WA_FINAL-SMTP_ADDR.
    LS_FINAL-STCD3                 =                    WA_FINAL-STCD3.
    LS_FINAL-BEZEI                 =                    WA_T005U-BEZEI.
    LS_FINAL-INCO_TEXT             =                    WA_FINAL-INCO_TEXT.
    LS_FINAL-VTEXT                 =                    WA_FINAL-VTEXT.
    LS_FINAL-VTEXT1                =                    WA_FINAL-VTEXT1.
    LS_FINAL-TEXT40                =                    WA_FINAL-TEXT40.
    LS_FINAL-ERDAT                 =                    WA_FINAL-ERDAT.
    LS_FINAL-STATUS                =                    WA_FINAL-STATUS.
    LS_FINAL-LOEVM                 =                    WA_FINAL-LOEVM.
    LS_FINAL-VEN_CLASS             =                    WA_FINAL-VEN_CLASS.
    LS_FINAL-VERKF                 =                    WA_FINAL-VERKF.
    LS_FINAL-TELF1                 =                    WA_FINAL-TELF1.
    LS_FINAL-J_1KFTBUS             =                    WA_FINAL-J_1KFTBUS.
    LS_FINAL-J_1KFTIND             =                    WA_FINAL-J_1KFTIND.

    LS_FINAL-TXT1                   =                    WA_FINAL-TXT1 .
    LS_FINAL-TXT2                   =                    WA_FINAL-TXT2 .
    LS_FINAL-TXT3                   =                    WA_FINAL-TXT3 .
    LS_FINAL-TXT4                   =                    WA_FINAL-TXT4 .
    LS_FINAL-TXT5                   =                    WA_FINAL-TXT5 .
    LS_FINAL-TXT6                   =                    WA_FINAL-TXT6 .
    LS_FINAL-TXT7                   =                    WA_FINAL-TXT7 .
    LS_FINAL-TXT8                   =                    WA_FINAL-TXT8 .
    LS_FINAL-TXT9                   =                    WA_FINAL-TXT9 .
    LS_FINAL-TXT10                  =                    WA_FINAL-TXT10.
    LS_FINAL-TXT11                  =                    WA_FINAL-TXT11.
    LS_FINAL-TXT12                  =                    WA_FINAL-TXT12.
    LS_FINAL-TXT13                  =                    WA_FINAL-TXT13.
    LS_FINAL-TXT14                  =                    WA_FINAL-TXT14.
    LS_FINAL-TXT15                  =                    WA_FINAL-TXT15.
    LS_FINAL-TXT16                  =                    WA_FINAL-TXT16.
    LS_FINAL-TXT17                  =                    WA_FINAL-TXT17.
    LS_FINAL-TXT18                  =                    WA_FINAL-TXT18.
    LS_FINAL-TXT19                  =                    WA_FINAL-TXT19.
    LS_FINAL-TXT20                  =                    WA_FINAL-TXT20.
    LS_FINAL-SMTP_ADDR1             =                    WA_FINAL-SMTP_ADDR1.
    LS_FINAL-SMTP_ADDR2             =                    WA_FINAL-SMTP_ADDR2.
    LS_FINAL-SMTP_ADDR3             =                    WA_FINAL-SMTP_ADDR3.
    LS_FINAL-UDATE                  =                    WA_FINAL-UDATE.           "ADDED BY DH 08.09.22
    LS_FINAL-SPERM                 =                    WA_FINAL-SPERM.           "ADDED BY DH 08.09.22
    LS_FINAL-XERSY                 =                    WA_FINAL-XERSY.     " added by sonu
    LS_FINAL-XERSR                =                    WA_FINAL-XERSR.      " added by sonu

*BREAK PRIMUS.
    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'                 "ADDED BY SNEHAL RAJALE ON 02 APRIL 2021 ( REFRESHABLE FILE ISSUE ).
      EXPORTING
        INTEXT  = LS_FINAL-STREET
      IMPORTING
        OUTTEXT = LS_FINAL-STREET.

    REPLACE ALL OCCURRENCES OF '.' IN LS_FINAL-STREET WITH ' '.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        INTEXT  = LS_FINAL-STR_SUPPL3
      IMPORTING
        OUTTEXT = LS_FINAL-STR_SUPPL3.

    REPLACE ALL OCCURRENCES OF '.' IN LS_FINAL-STR_SUPPL3 WITH ' '.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        INTEXT  = LS_FINAL-STR_SUPPL2
      IMPORTING
        OUTTEXT = LS_FINAL-STR_SUPPL2.

    REPLACE ALL OCCURRENCES OF '.' IN LS_FINAL-STR_SUPPL2 WITH ' '.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        INTEXT  = LS_FINAL-STR_SUPPL1
      IMPORTING
        OUTTEXT = LS_FINAL-STR_SUPPL1.

    REPLACE ALL OCCURRENCES OF '.' IN LS_FINAL-STR_SUPPL1 WITH ' '.

    LS_FINAL-REF = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-REF
      IMPORTING
        OUTPUT = LS_FINAL-REF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-ERDAT
      IMPORTING
        OUTPUT = LS_FINAL-ERDAT.

    CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                    INTO LS_FINAL-REF SEPARATED BY '-'.

    CONCATENATE LS_FINAL-ERDAT+0(2) LS_FINAL-ERDAT+2(3) LS_FINAL-ERDAT+5(4)
                    INTO LS_FINAL-ERDAT SEPARATED BY '-'.

******************
*    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*      EXPORTING
*        input  = ls_final-udate
*      IMPORTING
*        output = ls_final-udate.
*
*    CONCATENATE ls_final-udate+0(2) ls_final-udate+2(3) ls_final-udate+5(4)
*                    INTO ls_final-udate SEPARATED BY '-'.

**********************

    APPEND LS_FINAL TO LT_FINAL.
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR:WA_FINAL,WA_T059U,WA_LFA1,WA_LFB1,WA_LFM1,WA_ADRC,WA_ADR6,WA_LFBK,WA_LFBW,WA_BNKA,WA_T005U,WA_TINCT,WA_MM_TVZBT,WA_FI_TVZBT,WA_J_1IMOVEND .
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
  PERFORM FCAT USING : '1'  'LIFNR '          'IT_FINAL'  'Number of Vendor'           '18' ,
                       '2'  'BUKRS '          'IT_FINAL'  'Company Code'               '18',
                       '3'  'EKORG '          'IT_FINAL'  'Pur.Org'                    '18' ,
                       '4'  'KTOKK '          'IT_FINAL'  'Ven.ac.group'               '18' ,
                       '5'  'ANRED '          'IT_FINAL'  'Title'                      '10' ,
                       '6'  'NAME1 '          'IT_FINAL'  'Name 1'                     '30' ,
                       '7'  'NAME2 '          'IT_FINAL'  'Name 2'                     '30' ,
                       '8'  'SORTL '          'IT_FINAL'  'Sort field'                 '10' ,
                       '9'  'STR_SUPPL1'      'IT_FINAL'  'Street 1'                   '30' ,
                       '10'  'STR_SUPPL2'     'IT_FINAL'  'Street 2'                   '30' ,
                       '11'  'STR_SUPPL3'     'IT_FINAL'  'Street 4'                   '30' ,
                       '12'  'STREET    '     'IT_FINAL'  'Street'                     '30' ,
                       '13'  'HOUSE_NUM1'     'IT_FINAL'  'House NO'                   '10' ,
                       '14'  'CITY2     '     'IT_FINAL'  'District'                   '18' ,
                       '15'  'POST_CODE1'     'IT_FINAL'  'City postal code'           '18' ,
                       '16'  'CITY1   '       'IT_FINAL'  'City'                       '18' ,
                       '17'  'COUNTRY '       'IT_FINAL'  'Country Key'                '18' ,
                       '18'  'REGION  '       'IT_FINAL'  'Region'                     '18' ,
                       '19'  'BEZEI  '        'IT_FINAL'  'Reg.Desc'                   '18' ,
                       '20'  'PO_BOX  '       'IT_FINAL'  'PO Box'                     '10' ,
                       '21'  'LANGU     '     'IT_FINAL'  'Language'                   '10' ,
                       '22'  'TEL_NUMBER'     'IT_FINAL'  'Telephone NO'               '10' ,
                       '23'  'FAX_NUMBER'     'IT_FINAL'  'Fax no'                     '10' ,
                       '24'  'SMTP_ADDR1'     'IT_FINAL'  'E-Mail 1'                   '18' ,
                       '25'  'SMTP_ADDR2'     'IT_FINAL'  'E-Mail 2'                   '18' ,
                       '26'  'SMTP_ADDR3'     'IT_FINAL'  'E-Mail 3'                   '18' ,

                       '27'  'BANKS     '     'IT_FINAL'  'Bank '                      '18' ,
                       '28'  'BANKL     '     'IT_FINAL'  'Bank Keys'                  '18' ,
                       '29'  'BANKN'          'IT_FINAL'  'Bank A/C.No'                '18' ,
                       '30'  'KOINH'          'IT_FINAL'  'A/C Holder Name'            '18' ,
                       '31'  'BANKA'          'IT_FINAL'  'Name of bank'               '18' ,
                       '32'  'BRNCH'          'IT_FINAL'  'Bank Branch'                '18' ,
                       '33'  'PROVZ'          'IT_FINAL'  'Region'                     '18' ,
                       '34'  'STRAS'          'IT_FINAL'  'House Number'               '18' ,
                       '35'  'ORT01'          'IT_FINAL'  'City'                       '18' ,
                       '36'  'SWIFT'          'IT_FINAL'  'International Payment'      '18' ,
                       '37'  'AKONT '         'IT_FINAL'  'Recon.AC Gen.Ledger'        '18' ,
                       '38'  'ZUAWA '         'IT_FINAL'  'Assig. No'                  '18' ,
                       '39'  'ZTERM1'         'IT_FINAL'  'FI Terms of Payment'        '18' ,
                       '40'  'VTEXT1'         'IT_FINAL'  'Desc.Terms of Payment'      '30' ,
                       '41'  'REPRF '         'IT_FINAL'  'Invoices Flag'              '18' ,
                       '42'  'WAERS '         'IT_FINAL'  'Pur.order Curren'           '18' ,
                       '43'  'ZTERM'          'IT_FINAL'  'MM Terms of Payment'        '18' ,
                       '44'  'VTEXT'          'IT_FINAL'  'Desc.Terms of Payment'        '30' ,
                       '45'  'INCO1'          'IT_FINAL'  'Incoterms1'                 '18' ,
                       '46'  'INCO_TEXT'      'IT_FINAL'  'INCO1 TEXT'                 '20' ,
                       '47'  'INCO2'          'IT_FINAL'  'Incoterms2'                 '18' ,
                       '48'  'WEBRE'          'IT_FINAL'  'GR-Based Inv'               '18' ,
                       '49'  'LEBRE'          'IT_FINAL'  'Service-Based Inv'          '18' ,
                       '50'  'KZABS'          'IT_FINAL'  'Ackn.Req'                   '18' ,
                       '51'  'KUNNR'          'IT_FINAL'  'Customer No'                '18' ,
                       '52'  'J_1ICSTNO'      'IT_FINAL'  'Central Sales Tax No'       '18' ,
                       '53'  'J_1ILSTNO'      'IT_FINAL'  'Local Sales Tax No'         '18' ,
                       '54'  'J_1ISERN '      'IT_FINAL'  'Serv.Tax Regi No'           '18' ,
                       '55'  'J_1IEXCD '      'IT_FINAL'  'ECC No'                     '18' ,
                       '56'  'J_1IEXRN '      'IT_FINAL'  'Excise Regi.No'             '18' ,
                       '57'  'J_1IEXRG '      'IT_FINAL'  'Excise Range'               '18' ,
                       '58'  'J_1IEXDI '      'IT_FINAL'  'Excise Divi'                '18' ,
                       '59'  'J_1IEXCO '      'IT_FINAL'  'Excise Commis.rate'         '18' ,
                       '60'  'J_1IVTYP '      'IT_FINAL'  'Type of Vendor'             '18' ,
                       '61'  'J_1IPANNO'      'IT_FINAL'  'PAN No'                     '18' ,
                       '62'  'WT_WITHCD'      'IT_FINAL'  'Withholding tax code'       '18' ,
                       '63'  'TEXT40'         'IT_FINAL'  'Desc.WitH.tax code'         '20' ,
                       '64'  'WT_SUBJCT'      'IT_FINAL'  'withholding tax indi'       '18' ,
                       '65'  'STCD3'          'IT_FINAL'  'GSTIN No'                   '18' ,
                       '66'  'ERDAT'          'IT_FINAL'  'Creation Date'              '18' ,
                       '67'  'STATUS'         'IT_FINAL'  'MSME Status'                '18' ,
                       '68'  'LOEVM'          'IT_FINAL'  'Deletion Ind.'              '18' ,
                       '69'  'VEN_CLASS'      'IT_FINAL'  'GST Class'                  '18' ,
                       '70'  'VERKF'          'IT_FINAL'  'Sales Person'               '18' ,
                       '71'  'TELF1'          'IT_FINAL'  'Sale person Telephone'      '18' ,

                       '72'  'TXT1'           'IT_FINAL'  'Scope of Approval'                      '30' ,
                       '73'  'TXT2'           'IT_FINAL'  'QMS/Other Certificate Due Dt'           '30' ,
                       '74'  'TXT3'           'IT_FINAL'  'HT Fur 1 Annual Survey Due Dt'          '30' ,
                       '75'  'TXT4'           'IT_FINAL'  'HT Fur 2 Annual Survey Due Dt'          '30' ,
                       '76'  'TXT5'           'IT_FINAL'  'HT Fur 3 Annual Survey Due Dt'          '30' ,
                       '77'  'TXT6'           'IT_FINAL'  'HT Fur 4 Annual Survey Due Dt'          '30' ,
                       '78'  'TXT7'           'IT_FINAL'  'HT Fur 5 Annual Survey Due Dt'          '30' ,
                       '79'  'TXT8'           'IT_FINAL'  'HT Fur 1 Qtr TC-Calbtn Due Dt'          '30' ,
                       '80'  'TXT9'           'IT_FINAL'  'HT Fur 2 Qtr TC-Calbtn Due Dt'          '30' ,
                       '81'  'TXT10'          'IT_FINAL'  'HT Fur 3 Qtr TC-Calbtn Due Dt'          '30' ,
                       '82'  'TXT11'          'IT_FINAL'  'HT Fur 4 Qtr TC-Calbtn Due Dt'          '30' ,
                       '83'  'TXT12'          'IT_FINAL'  'HT Fur 5 Qtr TC-Calbtn Due Dt'          '30' ,
                       '84'  'TXT13'          'IT_FINAL'  'HT Fur 1 Qtr TR-Calbtn Due Dt'          '30' ,
                       '85'  'TXT14'          'IT_FINAL'  'HT Fur 2 Qtr TR-Calbtn Due Dt'          '30' ,
                       '86'  'TXT15'          'IT_FINAL'  'HT Fur 3 Qtr TR-Calbtn Due Dt'          '30' ,
                       '87'  'TXT16'          'IT_FINAL'  'HT Fur 4 Qtr TR-Calbtn Due Dt'          '30' ,
                       '88'  'TXT17'          'IT_FINAL'  'HT Fur 5 Qtr TR-Calbtn Due Dt'          '30' ,
                       '89'  'TXT18'          'IT_FINAL'  'Initial Evaluation dt'                  '30' ,
                       '90'  'TXT19'          'IT_FINAL'  'Last Evaluation Dt'                     '30' ,
                       '91'  'TXT20'          'IT_FINAL'  'Re-Evaluation Dt'                       '30' ,
                       '92'  'J_1KFTBUS'      'IT_FINAL'  'Critical Status'                        '20' ,
                       '93'  'J_1KFTIND'      'IT_FINAL'  'Type of supply'                         '20' ,
                       '94'  'UDATE'          'IT_FINAL'  'Last Updated Date'                      '18',    "DH 08.09.22
                       '95'  'SPERM'          'IT_FINAL'  'Blocked Indicator'                      '18',    "DH 08.09.22
                       '96'  'XERSY'          'IT_FINAL'  'AutoEvalSetmt Del'                      '05',    "added by sonu
                       '97'  'XERSR'          'IT_FINAL'  'AutoEvalSetmt Ret'                      '05'.    "added by sonu



*                     '59'  'REF'            'IT_FINAL'  'Refresh Date'               '18' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1013   text
*      -->P_1014   text
*      -->P_1015   text
*      -->P_1016   text
*      -->P_1017   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
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
*  call function 'REUSE_ALV_GRID_DISPLAY'
*    exporting
**     I_INTERFACE_CHECK  = ' '
**     I_BYPASSING_BUFFER = ' '
**     I_BUFFER_ACTIVE    = ' '
*      i_callback_program = sy-repid
**     I_CALLBACK_PF_STATUS_SET          = ' '
**     I_CALLBACK_USER_COMMAND           = ' '
**     I_CALLBACK_TOP_OF_PAGE            = ' '
**     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**     I_CALLBACK_HTML_END_OF_LIST       = ' '
**     I_STRUCTURE_NAME   =
**     I_BACKGROUND_ID    = ' '
**     I_GRID_TITLE       =
**     I_GRID_SETTINGS    =
**     IS_LAYOUT          =
*      it_fieldcat        = it_fcat
**     IT_EXCLUDING       =
**     IT_SPECIAL_GROUPS  =
**     IT_SORT            =
**     IT_FILTER          =
**     IS_SEL_HIDE        =
*      i_default          = 'X'
*      i_save             = 'X'
**     IS_VARIANT         =
**     IT_EVENTS          =
**     IT_EVENT_EXIT      =
**     IS_PRINT           =
**     IS_REPREP_ID       =
**     I_SCREEN_START_COLUMN             = 0
**     I_SCREEN_START_LINE               = 0
**     I_SCREEN_END_COLUMN               = 0
**     I_SCREEN_END_LINE  = 0
**     I_HTML_HEIGHT_TOP  = 0
**     I_HTML_HEIGHT_END  = 0
**     IT_ALV_GRAPHICS    =
**     IT_HYPERLINK       =
**     IT_ADD_FIELDCAT    =
**     IT_EXCEPT_QINFO    =
**     IR_SALV_FULLSCREEN_ADAPTER        =
**   IMPORTING
**     E_EXIT_CAUSED_BY_CALLER           =
**     ES_EXIT_CAUSED_BY_USER            =
*    tables
*      t_outtab           = it_final
**   EXCEPTIONS
**     PROGRAM_ERROR      = 1
**     OTHERS             = 2
*    .
*  if sy-subrc <> 0.
** Implement suitable error handling here
*  endif.




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
      I_DEFAULT          = 'X'      " added by sonu
      I_SAVE             = 'X'      " added by sonu
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
*     O_PREVIOUS_SRAL_HANDLER           =
*     O_COMMON_HUB       =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = IT_FINAL
* EXCEPTIONS
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
**        wa_csv1 TYPE LINE OF truxs_t_text_data,   "commented by sonu
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
*        lv_dat(10),
        LV_DAT(18),
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
  LV_FILE = 'ZVENDOR_MASTER.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.
  DATA: LV_NEWLINE TYPE STRING VALUE CL_ABAP_CHAR_UTILITIES=>NEWLINE.   "commented by sonu
**
  DATA: LV_MSG_TEMP TYPE CHAR250.                                       "commented by sonu
*BREAK primus.
  WRITE: / 'ZVENDOR_MASTER started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
*    for output in text mode encoding default MESSAGE LV_MSG_temp  .  "NON-UNICODE.
   FOR OUTPUT IN TEXT MODE ENCODING DEFAULT MESSAGE LV_MSG_TEMP. "commented by sonu
*  DATA:LV_CRLF TYPE STRING.                                      "commented by sonu
*  LV_CRLF = CL_ABAP_CHAR_UTILITIES=>CR_LF.                       "commented by sonu
***********************************
*  DATA LV_STRING TYPE STRING.                                     "commented by sonu
*  LV_STRING = HD_CSV .                                            "commented by sonu
*  IF SY-SUBRC = 0.
**    transfer hd_csv to lv_fullfile.
*    LOOP AT IT_CSV INTO WA_CSV.                                      "commented by sonu
*      CONCATENATE LV_STRING LV_CRLF WA_CSV INTO LV_STRING.             "commented by sonu
*      CLEAR: WA_CSV.                                                 "commented by sonu
*    ENDLOOP.                                                         "commented by sonu
*
**    loop at it_csv into wa_csv.
**      if sy-subrc = 0.
**        transfer wa_csv to lv_fullfile.
**
**      endif.
**    endloop.
*    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
*    MESSAGE LV_MSG TYPE 'S'.
*  ENDIF.
**TRANSFER lv_string_1922 TO lv_fullfile.
**TRANSFER lv_string_676 TO lv_fullfile.
**TRANSFER lv_string_1292 TO lv_fullfile.
*  TRANSFER LV_STRING TO LV_FULLFILE.                           "commented by sonu
****************************
  IF SY-SUBRC = 0.                                              "commented by sonu
    DATA LV_STRING_2114 TYPE STRING.                                "commented by sonu
    DATA LV_CRLF_2114 TYPE STRING.                                  "commented by sonu
    LV_CRLF_2114 = CL_ABAP_CHAR_UTILITIES=>CR_LF.                   "commented by sonu
    LV_STRING_2114 = HD_CSV.                                        "commented by sonu
    LOOP AT IT_CSV INTO WA_CSV.                                     "commented by sonu
      CONCATENATE LV_STRING_2114 LV_CRLF_2114 WA_CSV INTO LV_STRING_2114. "commented by sonu
      CLEAR: WA_CSV.                                                    "commented by sonu
    ENDLOOP.                                                            "commented by sonu
***TRANSFER lv_string_1922 TO lv_fullfile.
***TRANSFER lv_string_676 TO lv_fullfile.
    TRANSFER LV_STRING_2114 TO LV_FULLFILE.                             "commented by sonu
**
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.       "commented by sonu
    MESSAGE LV_MSG TYPE 'S'.                                                          "commented by sonu
  ENDIF.                                                                              "commented by sonu
  DATA : WA_INF     TYPE STRING.                                                      "commented by sonu

  IF  P_FILE = 'X'.                                                                   "commented by sonu

**
**
    CALL FUNCTION 'GUI_DOWNLOAD'                                                      "commented by sonu
      EXPORTING                                                                       "commented by sonu
*       BIN_FILESIZE            = C:\Users\john.doe\Desktop\ZVENDOR_MASTER.TXT
        FILENAME                = 'D:\ZVENDOR_MASTER.TXT'                             "commented by sonu
        FILETYPE                = 'ASC'                                               "commented by sonu
*       APPEND                  = ' '
*       WRITE_FIELD_SEPARATOR   = ' X'
*       HEADER                  = '00'
*       TRUNC_TRAILING_BLANKS   = 'X '
*       WRITE_LF                = 'X'
*       COL_SELECT              = ' '
*       COL_SELECT_MASK         = ' '
*       DAT_MODE                = ' '
*       CONFIRM_OVERWRITE       = ' '
*       NO_AUTH_CHECK           = ' '
*       CODEPAGE                = ' '
*       IGNORE_CERR             = ABAP_TRUE
*       REPLACEMENT             = '#'
*       WRITE_BOM               = ' '
*       TRUNC_TRAILING_BLANKS_EOL       = 'X'
*       WK1_N_FORMAT            = ' '
*       WK1_N_SIZE              = ' '
*       WK1_T_FORMAT            = ' '
*       WK1_T_SIZE              = ' '
*       WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*       SHOW_TRANSFER_STATUS    = ABAP_TRUE
*       VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
*     IMPORTING
*       FILELENGTH              =
      TABLES                                                                           "commented by sonu
        DATA_TAB                = IT_FINAL                                             "commented by sonu
*       FIELDNAMES              =
      EXCEPTIONS                                                                       "commented by sonu
        FILE_WRITE_ERROR        = 1
        NO_BATCH                = 2
        GUI_REFUSE_FILETRANSFER = 3
        INVALID_TYPE            = 4
        NO_AUTHORITY            = 5
        UNKNOWN_ERROR           = 6
        HEADER_NOT_ALLOWED      = 7
        SEPARATOR_NOT_ALLOWED   = 8
        FILESIZE_NOT_ALLOWED    = 9
        HEADER_TOO_LONG         = 10
        DP_ERROR_CREATE         = 11
        DP_ERROR_SEND           = 12
        DP_ERROR_WRITE          = 13
        UNKNOWN_DP_ERROR        = 14
        ACCESS_DENIED           = 15
        DP_OUT_OF_MEMORY        = 16
        DISK_FULL               = 17
        DP_TIMEOUT              = 18
        FILE_NOT_FOUND          = 19
        DATAPROVIDER_EXCEPTION  = 20
        CONTROL_FLUSH_ERROR     = 21
        OTHERS                  = 22.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.


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
  DATA:LV_ENT TYPE STRING.                                                   "commented by sonu
  LV_ENT = CL_ABAP_CHAR_UTILITIES=>CR_LF.                                    "commented by sonu
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.


*   l_field_seperator = cl_abap_char_utilities=>newline.

  CONCATENATE 'Number of Vendor'
              'Company Code'
              'Pur.Org'
              'Ven.ac.group'
              'Title'
              'Name 1'
              'Name 2'
              'Sort field'
              'Street 1'
              'Street 2'
              'Street 4'
              'Street'
              'House NO'
              'District'
              'City postal code'
              'City'
              'Country Key'
              'Region'
              'Reg.Desc'
              'PO Box'
              'Language'
              'Telephone NO'
              'Fax no'
              'E-Mail 1'
              'E-Mail 2'
              'E-Mail 3'
              'Bank '
              'Bank Keys'
              'Bank A/C.No'
              'A/C Holder Name'
              'Name of bank'
              'Bank Branch'
              'Region'
              'House Number'
              'City'
              'International Payment'
              'Recon.AC Gen.Ledger'
              'Assig. No'
              'FI Terms of Payment'
              'Desc.Terms of Payment'
              'Invoices Flag'
              'Pur.order Curren'
              'MM Terms of Payment'
              'Desc.Terms of Payment'
              'Incoterms1'
              'INCO1 TEXT'
              'Incoterms2'
              'GR-Based Inv'
              'Service-Based Inv'
              'Ackn.Req'
              'Customer No'
              'Central Sales Tax No'
              'Local Sales Tax No'
              'Serv.Tax Regi No'
              'ECC No'
              'Excise Regi.No'
              'Excise Range'
              'Excise Divi'
              'Excise Commis.rate'
              'Type of Vendor'
              'PAN No'
              'Withholding tax code'
              'Desc.WitH.tax code'
              'withholding tax indi'
              'GSTIN No'
              'Refresh Date'
              'Creation Date'
              'MSME Status'
              'Deletion Ind.'
              'GST Class'
              'Sales Person'
              'Sale person Telephone'
              'Scope of Approval'
              'QMS/Other Certificate Due Dt'
              'HT Fur 1 Annual Survey Due Dt'
              'HT Fur 2 Annual Survey Due Dt'
              'HT Fur 3 Annual Survey Due Dt'
              'HT Fur 4 Annual Survey Due Dt'
              'HT Fur 5 Annual Survey Due Dt'
              'HT Fur 1 Qtr TC-Calbtn Due Dt'
              'HT Fur 2 Qtr TC-Calbtn Due Dt'
              'HT Fur 3 Qtr TC-Calbtn Due Dt'
              'HT Fur 4 Qtr TC-Calbtn Due Dt'
              'HT Fur 5 Qtr TC-Calbtn Due Dt'
              'HT Fur 1 Qtr TR-Calbtn Due Dt'
              'HT Fur 2 Qtr TR-Calbtn Due Dt'
              'HT Fur 3 Qtr TR-Calbtn Due Dt'
              'HT Fur 4 Qtr TR-Calbtn Due Dt'
              'HT Fur 5 Qtr TR-Calbtn Due Dt'
              'Initial Evaluation dt'
              'Last Evaluation Dt'
              'Re-Evaluation Dt'
              'Critical Status'
              'Type of supply'
              'Last updated Date'
              'Blocked Indicator'
              'AutoEvalSetmt Del'
              'AutoEvalSetmt Ret'
*             CL_ABAP_CHAR_UTILITIES=>CR_LF
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
