*&---------------------------------------------------------------------*
*& Report ZPO_TYPE_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPO_TYPE_YEAR_REPORT.


TABLES:MARA,EKPO.

TYPES: BEGIN OF TY_MARA,
         MATNR TYPE MARA-MATNR,
         MTART TYPE MARA-MTART,
         WERKS TYPE MARC-WERKS,
       END OF TY_MARA,



       BEGIN OF TY_DATA,
         EBELN TYPE EKKO-EBELN,
         LIFNR TYPE EKKO-LIFNR,
         AEDAT TYPE EKKO-AEDAT,
         BUKRS TYPE EKKO-BUKRS,
         FRGKE TYPE EKKO-FRGKE,
         EBELP TYPE EKPO-EBELP,
         MATNR TYPE EKPO-MATNR,
         WERKS TYPE EKPO-WERKS,
         ELIKZ TYPE EKPO-ELIKZ,
         LOEKZ TYPE EKPO-LOEKZ,
         PSTYP TYPE EKPO-PSTYP,
         RETPO TYPE EKPO-RETPO,
       END OF TY_DATA,


       BEGIN OF TY_FINAL,
         MATNR     TYPE MARA-MATNR,
         MTART     TYPE MARA-MTART,
         SUBCON_17 TYPE CHAR5,
         OTHER_17  TYPE CHAR5,
         SUBCON_18 TYPE CHAR5,
         OTHER_18  TYPE CHAR5,
         SUBCON_19 TYPE CHAR5,
         OTHER_19  TYPE CHAR5,
         SUBCON_20 TYPE CHAR5,
         OTHER_20  TYPE CHAR5,
          SUBCON_21 TYPE CHAR5,
         OTHER_21  TYPE CHAR5,
         SUBCON_22 TYPE CHAR5,
         OTHER_22  TYPE CHAR5,
         SUBCON_23 TYPE CHAR5,
         OTHER_23  TYPE CHAR5,
         SUBCON_24 TYPE CHAR5,
         OTHER_24  TYPE CHAR5,
         SUBCON_25 TYPE CHAR5,
         OTHER_25  TYPE CHAR5,
       END OF TY_FINAL,

       BEGIN OF TY_DOWN,
         MATNR  TYPE MARA-MATNR,
         MTART  TYPE MARA-MTART,
         SUBCON_17 TYPE CHAR5,
         OTHER_17  TYPE CHAR5,
         SUBCON_18 TYPE CHAR5,
         OTHER_18  TYPE CHAR5,
         SUBCON_19 TYPE CHAR5,
         OTHER_19  TYPE CHAR5,
         SUBCON_20 TYPE CHAR5,
         OTHER_20  TYPE CHAR5,
        REF    TYPE CHAR11,
        SUBCON_21 TYPE CHAR5,
         OTHER_21  TYPE CHAR5,
         SUBCON_22 TYPE CHAR5,
         OTHER_22  TYPE CHAR5,
         SUBCON_23 TYPE CHAR5,
         OTHER_23  TYPE CHAR5,
         SUBCON_24 TYPE CHAR5,
         OTHER_24  TYPE CHAR5,
         SUBCON_25 TYPE CHAR5,
         OTHER_25  TYPE CHAR5,
       END OF TY_DOWN.

TYPES : BEGIN OF ty_date,
          sign(1) ,
          option(2),
          low(08),
          high(08),
        END OF ty_date.
DATA:  it_2017     TYPE TABLE OF ty_date,
       wa_2017     TYPE          ty_date.

DATA:  it_2018     TYPE TABLE OF ty_date,
       wa_2018     TYPE          ty_date.

DATA:  it_2019     TYPE TABLE OF ty_date,
       wa_2019     TYPE          ty_date.

DATA:  it_2020     TYPE TABLE OF ty_date,
       wa_2020     TYPE          ty_date.
**************added by jyotio on15.01.2025**************

DATA:  it_2021     TYPE TABLE OF ty_date,
       wa_2021     TYPE          ty_date.

DATA:  it_2022     TYPE TABLE OF ty_date,
       wa_2022     TYPE          ty_date.

DATA:  it_2023     TYPE TABLE OF ty_date,
       wa_2023     TYPE          ty_date.

DATA:  it_2024     TYPE TABLE OF ty_date,
       wa_2024     TYPE          ty_date.

DATA:  it_2025     TYPE TABLE OF ty_date,
       wa_2025     TYPE          ty_date.

******************************************************

  wa_2017-low =  '20170101'.
  wa_2017-high = '20171231'.
  wa_2017-sign = 'I'.
  wa_2017-option = 'BT'.
  APPEND wa_2017 TO it_2017.
  CLEAR wa_2017.

  wa_2018-low =  '20180101'.
  wa_2018-high = '20181231'.
  wa_2018-sign = 'I'.
  wa_2018-option = 'BT'.
  APPEND wa_2018 TO it_2018.
  CLEAR wa_2018.

  wa_2019-low =  '20190101'.
  wa_2019-high = '20191231'.
  wa_2019-sign = 'I'.
  wa_2019-option = 'BT'.
  APPEND wa_2019 TO it_2019.
  CLEAR wa_2019.

  wa_2020-low =  '20200101'.
  wa_2020-high = '20201231'.
  wa_2020-sign = 'I'.
  wa_2020-option = 'BT'.
  APPEND wa_2020 TO it_2020.
  CLEAR wa_2020.

***********added by jyoti on 15.01.2024***********
  wa_2021-low =  '20210101'.
  wa_2021-high = '20211231'.
  wa_2021-sign = 'I'.
  wa_2021-option = 'BT'.
  APPEND wa_2021 TO it_2021.
  CLEAR wa_2021.

  wa_2022-low =  '20220101'.
  wa_2022-high = '20221231'.
  wa_2022-sign = 'I'.
  wa_2022-option = 'BT'.
  APPEND wa_2022 TO it_2022.
  CLEAR wa_2022.

  wa_2023-low =  '20230101'.
  wa_2023-high = '20231231'.
  wa_2023-sign = 'I'.
  wa_2023-option = 'BT'.
  APPEND wa_2023 TO it_2023.
  CLEAR wa_2023.

  wa_2024-low =  '20240101'.
  wa_2024-high = '20241231'.
  wa_2024-sign = 'I'.
  wa_2024-option = 'BT'.
  APPEND wa_2024 TO it_2024.
  CLEAR wa_2024.

  wa_2025-low =  '20250101'.
  wa_2025-high = '20251231'.
  wa_2025-sign = 'I'.
  wa_2025-option = 'BT'.
  APPEND wa_2025 TO it_2025.
  CLEAR wa_2025.

********************************************

DATA : IT_MARA  TYPE TABLE OF TY_MARA,
       WA_MARA  TYPE          TY_MARA,

       IT_DATA  TYPE TABLE OF TY_DATA,
       WA_DATA  TYPE          TY_DATA,

       IT_SUBCON_17  TYPE TABLE OF TY_DATA,
       WA_SUBCON_17  TYPE          TY_DATA,

       IT_OTHER_17  TYPE TABLE OF TY_DATA,
       WA_OTHER_17  TYPE          TY_DATA,

       IT_SUBCON_18  TYPE TABLE OF TY_DATA,
       WA_SUBCON_18  TYPE          TY_DATA,

       IT_OTHER_18   TYPE TABLE OF TY_DATA,
       WA_OTHER_18   TYPE          TY_DATA,

       IT_SUBCON_19  TYPE TABLE OF TY_DATA,
       WA_SUBCON_19  TYPE          TY_DATA,

       IT_OTHER_19  TYPE TABLE OF TY_DATA,
       WA_OTHER_19  TYPE          TY_DATA,

       IT_SUBCON_20  TYPE TABLE OF TY_DATA,
       WA_SUBCON_20  TYPE          TY_DATA,

       IT_OTHER_20  TYPE TABLE OF TY_DATA,
       WA_OTHER_20  TYPE          TY_DATA,

****************** ADDED BY JYOTI ON 15.01.2024*******************
       IT_SUBCON_21  TYPE TABLE OF TY_DATA,
       WA_SUBCON_21  TYPE          TY_DATA,

       IT_OTHER_21  TYPE TABLE OF TY_DATA,
       WA_OTHER_21  TYPE          TY_DATA,

       IT_SUBCON_22  TYPE TABLE OF TY_DATA,
       WA_SUBCON_22  TYPE          TY_DATA,

       IT_OTHER_22   TYPE TABLE OF TY_DATA,
       WA_OTHER_22   TYPE          TY_DATA,

       IT_SUBCON_23  TYPE TABLE OF TY_DATA,
       WA_SUBCON_23  TYPE          TY_DATA,

       IT_OTHER_23  TYPE TABLE OF TY_DATA,
       WA_OTHER_23  TYPE          TY_DATA,

       IT_SUBCON_24  TYPE TABLE OF TY_DATA,
       WA_SUBCON_24  TYPE          TY_DATA,

       IT_OTHER_24  TYPE TABLE OF TY_DATA,
       WA_OTHER_24  TYPE          TY_DATA,

       IT_SUBCON_25  TYPE TABLE OF TY_DATA,
       WA_SUBCON_25  TYPE          TY_DATA,

       IT_OTHER_25  TYPE TABLE OF TY_DATA,
       WA_OTHER_25  TYPE          TY_DATA,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,

       IT_DOWN  TYPE TABLE OF TY_DOWN,
       WA_DOWN  TYPE          TY_DOWN.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MARA-MATNR,
                S_WERKS FOR EKPO-WERKS OBLIGATORY DEFAULT 'PL01',
                S_MTART FOR MARA-MTART.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/India'."India'."India'."India'."temp'."'/Delval/India'."temp'  "'/Delval/India'."temp_'.         "'E:/delval/temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
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

  SELECT A~MATNR
         A~MTART
         B~WERKS INTO TABLE IT_MARA FROM MARA AS A
         INNER JOIN MARC AS B ON B~MATNR = A~MATNR
         WHERE A~MATNR IN S_MATNR
           AND A~MTART IN S_MTART
           AND B~WERKS IN S_WERKS.

  IF IT_MARA IS NOT INITIAL .
***************YEAR 2017
      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_17
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2017 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_17
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2017 .


***************YEAR 2018

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_18
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2018 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_18
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2018 .

***************YEAR 2019

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_19
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2019 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_19
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2019 .

***************YEAR 2020
      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_20
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2020 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_20
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2020 .

**************YEAR 2021
      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_21
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2021 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_21
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2021 .

**************YEAR 2022
      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_22
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2022 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_22
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2022 .

**************YEAR 2023
      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_23
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2023 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_23
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2023.

**************YEAR 2020
      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_24
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2024 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_24
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2024.

**************YEAR 2020
      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_SUBCON_25
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP EQ '3'
             AND   A~AEDAT IN IT_2025 .

      SELECT A~EBELN
             A~LIFNR
             A~AEDAT
             A~BUKRS
             A~FRGKE
             B~EBELP
             B~MATNR
             B~WERKS
             B~ELIKZ
             B~LOEKZ
             B~PSTYP
             B~RETPO
             INTO TABLE IT_OTHER_25
             FROM EKKO AS A INNER JOIN  EKPO AS B
             ON A~EBELN = B~EBELN
             FOR ALL ENTRIES IN IT_MARA
             WHERE B~MATNR = IT_MARA-MATNR
             AND   B~WERKS = IT_MARA-WERKS " s_werks
             AND   B~LOEKZ NE 'L'
             AND   A~FRGKE = '2'
             AND   B~PSTYP NE '3'
             AND   B~RETPO NE 'X'
             AND   A~AEDAT IN IT_2025 .
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
  LOOP AT IT_MARA INTO WA_MARA.
    WA_FINAL-MATNR = WA_MARA-MATNR.
    WA_FINAL-MTART = WA_MARA-MTART.

    READ TABLE IT_SUBCON_17 INTO WA_SUBCON_17 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_17 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_17 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_17 INTO WA_OTHER_17 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_17 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_17 = 'NO'.
    ENDIF.

******************YEAR 2018
    READ TABLE IT_SUBCON_18 INTO WA_SUBCON_18 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_18 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_18 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_18 INTO WA_OTHER_18 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_18 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_18 = 'NO'.
    ENDIF.

******************YEAR 2019
    READ TABLE IT_SUBCON_19 INTO WA_SUBCON_19 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_19 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_19 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_19 INTO WA_OTHER_19 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_19 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_19 = 'NO'.
    ENDIF.

******************YEAR 2020
    READ TABLE IT_SUBCON_20 INTO WA_SUBCON_20 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_20 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_20 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_20 INTO WA_OTHER_20 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_20 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_20 = 'NO'.
    ENDIF.

******************YEAR 2021
    READ TABLE IT_SUBCON_21 INTO WA_SUBCON_21 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_21 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_21 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_21 INTO WA_OTHER_21 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_21 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_21 = 'NO'.
    ENDIF.

******************YEAR 2022
    READ TABLE IT_SUBCON_22 INTO WA_SUBCON_22 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_22 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_22 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_22 INTO WA_OTHER_22 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_22 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_22 = 'NO'.
    ENDIF.

******************YEAR 2023
    READ TABLE IT_SUBCON_23 INTO WA_SUBCON_23 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_23 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_23 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_23 INTO WA_OTHER_23 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_23 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_23 = 'NO'.
    ENDIF.

******************YEAR 2024
    READ TABLE IT_SUBCON_24 INTO WA_SUBCON_24 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_24 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_24 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_24 INTO WA_OTHER_24 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_24 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_24 = 'NO'.
    ENDIF.

*    ******************YEAR 2025
    READ TABLE IT_SUBCON_25 INTO WA_SUBCON_25 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-SUBCON_25 = 'YES'.
    ELSE.
      WA_FINAL-SUBCON_25 = 'NO'.
    ENDIF.
    CLEAR:WA_DATA.
    READ TABLE IT_OTHER_25 INTO WA_OTHER_25 WITH KEY MATNR = WA_MARA-MATNR .
    IF SY-SUBRC = 0.
        WA_FINAL-OTHER_25 = 'YES'.
    ELSE.
      WA_FINAL-OTHER_25 = 'NO'.
    ENDIF.



    APPEND WA_FINAL TO IT_FINAL.
    CLEAR:WA_FINAL,WA_MARA,WA_DATA.
  ENDLOOP.


  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MATNR = WA_FINAL-MATNR.
      WA_DOWN-MTART = WA_FINAL-MTART.
      WA_DOWN-SUBCON_17 = WA_FINAL-SUBCON_17.
      WA_DOWN-OTHER_17  = WA_FINAL-OTHER_17.
      WA_DOWN-SUBCON_18 = WA_FINAL-SUBCON_18.
      WA_DOWN-OTHER_18  = WA_FINAL-OTHER_18.
      WA_DOWN-SUBCON_19 = WA_FINAL-SUBCON_19.
      WA_DOWN-OTHER_19  = WA_FINAL-OTHER_19.
      WA_DOWN-SUBCON_20 = WA_FINAL-SUBCON_20.
      WA_DOWN-OTHER_20  = WA_FINAL-OTHER_20.
      WA_DOWN-SUBCON_21 = WA_FINAL-SUBCON_21.
      WA_DOWN-OTHER_21  = WA_FINAL-OTHER_21.
       WA_DOWN-SUBCON_22 = WA_FINAL-SUBCON_22.
      WA_DOWN-OTHER_22  = WA_FINAL-OTHER_22.
       WA_DOWN-SUBCON_23 = WA_FINAL-SUBCON_23.
      WA_DOWN-OTHER_23  = WA_FINAL-OTHER_23.
       WA_DOWN-SUBCON_24 = WA_FINAL-SUBCON_24.
      WA_DOWN-OTHER_24  = WA_FINAL-OTHER_24.
       WA_DOWN-SUBCON_25 = WA_FINAL-SUBCON_25.
      WA_DOWN-OTHER_25  = WA_FINAL-OTHER_25.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.


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
  PERFORM FCAT USING : '1'   'MATNR'           'IT_FINAL'      'Material'                     '20' ,
                       '2'   'MTART'           'IT_FINAL'      'Material Type'                '10' ,
                       '3'   'SUBCON_17'          'IT_FINAL'      '2017 Subcon Purchase'      '20' ,
                       '4'   'OTHER_17'           'IT_FINAL'      '2017 Other Purchase'       '20' ,
                       '5'   'SUBCON_18'          'IT_FINAL'      '2018 Subcon Purchase'      '20' ,
                       '6'   'OTHER_18'           'IT_FINAL'      '2018 Other Purchase'       '20' ,
                       '7'   'SUBCON_19'          'IT_FINAL'      '2019 Subcon Purchase'      '20' ,
                       '8'   'OTHER_19'           'IT_FINAL'      '2019 Other Purchase'       '20' ,
                       '9'   'SUBCON_20'          'IT_FINAL'      '2020 Subcon Purchase'      '20' ,
                      '10'   'OTHER_20'           'IT_FINAL'      '2020 Other Purchase'       '20' ,
                      '11'   'SUBCON_21'          'IT_FINAL'      '2021 Subcon Purchase'      '20' ,
                      '12'   'OTHER_21'           'IT_FINAL'      '2021 Other Purchase'       '20' ,
                      '13'   'SUBCON_22'          'IT_FINAL'      '2022 Subcon Purchase'      '20' ,
                      '14'   'OTHER_22'           'IT_FINAL'      '2022 Other Purchase'       '20',
                      '15'   'SUBCON_23'          'IT_FINAL'      '2023 Subcon Purchase'      '20' ,
                      '16'   'OTHER_23'           'IT_FINAL'      '2023 Other Purchase'       '20',
                      '17'   'SUBCON_24'          'IT_FINAL'      '2024 Subcon Purchase'      '20' ,
                      '18'   'OTHER_24'           'IT_FINAL'      '2024 Other Purchase'       '20',
                      '19'   'SUBCON_25'          'IT_FINAL'      '2025 Subcon Purchase'      '20' ,
                      '20'   'OTHER_25'           'IT_FINAL'      '2025 Other Purchase'       '20'    .


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0432   text
*      -->P_0433   text
*      -->P_0434   text
*      -->P_0435   text
*      -->P_0436   text
*----------------------------------------------------------------------*
FORM FCAT USING    VALUE(P1)
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


  LV_FILE = 'ZPO_TYPE_YEAR.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPO_TYPE_YEAR REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1113 TYPE string.
DATA lv_crlf_1113 TYPE string.
lv_crlf_1113 = cl_abap_char_utilities=>cr_lf.
lv_string_1113 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1113 lv_crlf_1113 wa_csv INTO lv_string_1113.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_805 TO lv_fullfile.
*TRANSFER lv_string_1521 TO lv_fullfile.
TRANSFER lv_string_1113 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

*********************************************SQL UPLOAD FILE *****************************************
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


  LV_FILE = 'ZPO_TYPE_YEAR.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPO_TYPE REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1151 TYPE string.
DATA lv_crlf_1151 TYPE string.
lv_crlf_1151 = cl_abap_char_utilities=>cr_lf.
lv_string_1151 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1151 lv_crlf_1151 wa_csv INTO lv_string_1151.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_805 TO lv_fullfile.
*TRANSFER lv_string_1521 TO lv_fullfile.
TRANSFER lv_string_1151 TO lv_fullfile.
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
  CONCATENATE 'Material'
              'Material Type'
              '2017 Subcon Purchase'
              '2017 Other Purchase'
              '2018 Subcon Purchase'
              '2018 Other Purchase'
              '2019 Subcon Purchase'
              '2019 Other Purchase'
              '2020 Subcon Purchase'
              '2020 Other Purchase'
              'Refresh Date'
              '2021 Subcon Purchase'
              '2021 Other Purchase'
              '2022 Subcon Purchase'
              '2022 Other Purchase'
              '2023 Subcon Purchase'
              '2023 Other Purchase'
              '2024 Subcon Purchase'
              '2024 Other Purchase'
              '2025 Subcon Purchase'
              '2025 Other Purchase'
         INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
