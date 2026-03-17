*&---------------------------------------------------------------------*
*& Report ZMM_STOCK_AGEING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_PERIOD_STOCK_AGEING.
**&--------------------------------------------------------------------------------------*
*& PROGRAM OWNER     : PRIMUS TECHSYSTEMS PVT. LTD.                                     *
*&--------------------------------------------------------------------------------------*
*&  BUSINESS OWNER   : WELMADE LOCKS PVT. LTD.                                          *
*&  PROJECT          : EUROPA S4/HANA IMPLEMENTATION                                    *
*&  MODULE NAME      : SD                                                               *
*&  CREATED BY       : PARAG NAKHATE - PRIMUS TECHSYSTEMS PVT. LTD.                     *
*&  REQUESTER        : SAMEER ANGRE                                                     *
*&  TRANSACTION CODE :                                                         *
*&  PROGRAM          : ZMM_PERIOD_STOCK_AGEING                                     *
*&  DESCRIPTION      : PERIOD WISE STOCK AGEING                                         *
*&  CREATED ON       : 01/07/2019                                                       *
*&  WORKBENC REQUEST : SEDK900485                                                       *                                                          *
*****************************************************************************************


TABLES :mard,mseg,mara,t001w,mbew,mardh.
TYPE-POOLS : slis.

*INTERNAL TABLE FOR FIELD CATALOG
DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       t_sort     TYPE slis_t_sortinfo_alv WITH HEADER LINE,
       w_tabname  TYPE slis_tabname,
       idx        TYPE sy-tabix,
       flag       TYPE i,
       fs_layout  TYPE slis_layout_alv, plant TYPE t001w-name1,
       date       LIKE  p0001-begda,
       days       LIKE  t5a4a-dlydy,
       months     LIKE  t5a4a-dlymo,
       signum     LIKE  t5a4a-split,
       years      LIKE  t5a4a-dlyyr.

TYPES :BEGIN OF str,
         matnr      TYPE mseg-matnr,
         werks      TYPE mseg-werks,
         budat_mkpf TYPE mseg-budat_mkpf,
         erfmg      TYPE mseg-erfmg,
         meins      TYPE mseg-meins,
         mtart      TYPE mara-mtart,
         maktx      TYPE makt-maktx,
         dmbtr      TYPE mseg-dmbtr,
         dmbtr1     TYPE mseg-dmbtr,
         waers      TYPE mseg-waers,
         erfmg1     TYPE mseg-erfmg,
         erfmg2     TYPE mseg-erfmg,
         days       TYPE i,
         cellcolor  TYPE lvc_t_scol,
         day30      TYPE mseg-erfmg,
         value30    TYPE mseg-erfmg,  " code added by sj
         day30_ton  TYPE mseg-erfmg,
         day60      TYPE mseg-erfmg,
         value60    TYPE mseg-erfmg,  " code added by sj
         day60_ton  TYPE mseg-erfmg,
         day90      TYPE mseg-erfmg,
         value90    TYPE mseg-erfmg,  " code added by sj
         day90_ton  TYPE mseg-erfmg,
         day120     TYPE mseg-erfmg,
         value120   TYPE mseg-erfmg,  " code added by sj
         day120_ton TYPE mseg-erfmg,
         day150     TYPE mseg-erfmg,
         value150   TYPE mseg-erfmg,  " code added by sj
         day150_ton TYPE mseg-erfmg,
         day180     TYPE mseg-erfmg,
         value180   TYPE mseg-erfmg,  " code added by sj
         day180_ton TYPE mseg-erfmg,
         day365     TYPE mseg-erfmg,
         value365   TYPE mseg-erfmg,  " code added by sj
         day365_p   TYPE mseg-erfmg,
         value365_p TYPE mseg-erfmg,
         day365_ton TYPE mseg-erfmg,
         day360     TYPE mseg-erfmg,
         value360   TYPE mseg-erfmg,  " code added by sj
         day360_p   TYPE mseg-erfmg,
         value360_p TYPE mseg-erfmg,
         day360_ton TYPE p LENGTH 16 DECIMALS 3,
         day730     TYPE mseg-erfmg,
         value730   TYPE mseg-erfmg,  " code added by sj
         day1095    TYPE mseg-erfmg,
         value1095  TYPE mseg-erfmg,  " code added by sj
         day1095_p  TYPE mseg-erfmg,
         value1095_p   TYPE mseg-erfmg,  " code added by sj
         brgew      TYPE mara-brgew, "PER UNIT WEIGHT
         prdha      TYPE mara-prdha, "PRODUCT HIERARCHY
         groes      TYPE mara-groes, "NO OF LEAVES
         bismt      TYPE mara-bismt, "OLD MAT NO
         blanz      TYPE mara-blanz, "NO OF PARA ENDS
         ton        TYPE mara-brgew, "TONNAGE
         matkl      TYPE mara-matkl, "MATERIAL GROUP
         bklas      TYPE mbew-bklas,
         hkont      TYPE bsis-hkont, " GL ACCOUNT
         belnr      TYPE bsis-belnr, "DOCUMENT NUMBER (JV)
         gjahr      TYPE bsis-gjahr, "FISCAL YEAR
         cnt        TYPE p DECIMALS 1, "COUNTER
         extwg      TYPE mara-extwg,
         lifnr      TYPE lfa1-lifnr,
         lgort      TYPE mard-lgort,
       END OF str.

TYPES :BEGIN OF str1,
         mblnr      TYPE mseg-mblnr,
         zeile      TYPE mseg-zeile,
         mjahr      TYPE mseg-mjahr,
         matnr      TYPE mseg-matnr,
         menge      TYPE mseg-menge,
         erfmg      TYPE mseg-erfmg,
         dmbtr      TYPE mseg-dmbtr,
         budat_mkpf TYPE mseg-budat_mkpf,
         erfme      TYPE mseg-meins,
         waers      TYPE mseg-waers,
         werks      TYPE mseg-werks,
         smbln      TYPE mseg-smbln,
         lifnr      TYPE mseg-lifnr,
         lgort      TYPE mard-lgort,

       END OF str1,

       BEGIN OF s_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         meins TYPE mara-meins,
         brgew TYPE mara-brgew, "PER UNIT WEIGHT
         prdha TYPE mara-prdha, "PRODUCT HIERARCHY
         groes TYPE mara-groes, "NO OF LEAVES
         bismt TYPE mara-bismt, "OLD MAT NO
         blanz TYPE mara-blanz, "NO OF PARA ENDS
         matkl TYPE mara-matkl, "MATERIAL GROUP
         extwg TYPE mara-extwg,
       END OF s_mara.



DATA :r_stock   TYPE STANDARD TABLE OF str1 WITH HEADER LINE,
      r_stock1   TYPE STANDARD TABLE OF str1 WITH HEADER LINE,
      wr_stock  TYPE str1,
      wr_stock1  TYPE str1,
*      r_stock1  TYPE STANDARD TABLE OF str1,
*      wr_stock1 TYPE str1,
      it_final  TYPE STANDARD TABLE OF str,
      it_final2 TYPE STANDARD TABLE OF str WITH HEADER LINE,
      w_final   TYPE str,
      w_final1  TYPE str,
      i_mara    TYPE STANDARD TABLE OF s_mara WITH HEADER LINE,
      i_mseg    TYPE STANDARD TABLE OF str1 WITH HEADER LINE,
      i_mseg1    TYPE STANDARD TABLE OF str1 WITH HEADER LINE,
      it_bsis   TYPE STANDARD TABLE OF bsis WITH HEADER LINE,
      i_t030    TYPE TABLE OF t030 WITH HEADER LINE,
      dum_bsis  TYPE STANDARD TABLE OF bsis WITH HEADER LINE,
      i_makt    TYPE STANDARD TABLE OF makt WITH HEADER LINE.


DATA :i_mbew TYPE STANDARD TABLE OF mbewh WITH HEADER LINE,
      d_mbew TYPE STANDARD TABLE OF mbewh WITH HEADER LINE.

DATA :BEGIN OF per_val OCCURS 0,
        vprsv TYPE mbew-vprsv,
        verpr TYPE mbew-verpr,
        stprs TYPE mbew-stprs,
      END  OF per_val.

DATA :menge   TYPE mseg-menge,
      busarea TYPE gsber,
      var     TYPE mseg-erfmg,
      var1    TYPE mseg-erfmg,
      var4    TYPE mseg-erfmg,
      div  TYPE mseg-erfmg.

TYPES :BEGIN OF mat,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
       END OF mat.

DATA :mat_tab    TYPE STANDARD TABLE OF mat, " WITH HEADER LINE,
      w_mat      TYPE mat,
      saknr      TYPE ska1-saknr,start_date TYPE sy-datum,end_date TYPE sy-datum, year(4) TYPE c.

TYPES: BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         LFGJA TYPE mard-LFGJA,
         LFMON TYPE mard-LFMON,
         labst TYPE mard-labst,
         speme TYPE mard-speme,
         insme TYPE mard-insme,
       END OF ty_mard.

DATA :it_mard  TYPE STANDARD TABLE OF ty_mard, " WITH HEADER LINE.
      wa_mard TYPE ty_mard.

TYPES: BEGIN OF ty_mslb,
       matnr TYPE mslb-matnr,
       werks TYPE mslb-werks,
       charg TYPE mslb-charg,
       sobkz TYPE mslb-sobkz,
       lifnr TYPE mslb-lifnr,
       LFGJA TYPE mslb-LFGJA,
       LFMON TYPE mslb-LFMON,
       lblab TYPE mslb-lblab,
       END OF ty_mslb.

DATA : it_mslb TYPE TABLE OF ty_mslb,
       wa_mslb TYPE          ty_mslb.


TYPES : BEGIN OF ty_mbew,
        matnr TYPE mbew-matnr,
        bwkey TYPE mbew-bwkey,
        lbkum TYPE mbew-lbkum,
        VPRSV TYPE mbew-VPRSV,
        VERPR TYPE mbew-VERPR,
        STPRS TYPE mbew-STPRS,
        bwtar TYPE mbew-bwtar,
        LFGJA TYPE mbew-LFGJA,
        LFMON TYPE mbew-LFMON,
        bklas TYPE mbew-bklas,
        peinh TYPE mbew-peinh,
        END OF ty_mbew.

DATA: it_mbew TYPE TABLE OF ty_mbew,
      wa_mbew TYPE          ty_mbew.
DATA: wa_mara TYPE mara,
      wa_makt TYPE makt.

DATA : m_m    TYPE mard-matnr,
       total  TYPE mard-labst,
       total1 TYPE mard-labst.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-001.
*PARAMETERS: werks TYPE mard-werks OBLIGATORY.
SELECT-OPTIONS : werks FOR mseg-werks OBLIGATORY DEFAULT 'PL01'.
SELECT-OPTIONS : matnr FOR mseg-matnr." MODIF ID M.
SELECT-OPTIONS : mtart FOR mara-mtart OBLIGATORY." MODIF ID M.
SELECT-OPTIONS : matkl FOR mara-matkl." MODIF ID M.
*SELECT-OPTIONS : bklas FOR mbew-bklas ."MODIF ID M.
PARAMETERS: fiscal TYPE mardh-LFGJA OBLIGATORY,
            period TYPE mardh-LFMON OBLIGATORY.
*SELECT-OPTIONS : s_date  FOR mseg-budat_mkpf.
SELECTION-SCREEN END OF BLOCK b3.

INITIALIZATION.

START-OF-SELECTION.
  IF werks IS INITIAL.
    MESSAGE 'ENTER PLANT' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  IF mtart[] IS INITIAL AND matnr[] IS INITIAL.
    MESSAGE 'ENTER MATERIAL TYPES' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

DATA: I_POPER TYPE T009B-POPER,
      I_GJAHR TYPE T009B-BDATJ,
      I_PERIV TYPE T009B-PERIV VALUE 'V3',
      p_date TYPE SY-DATUM.



i_poper = period.
I_GJAHR = fiscal.


CALL FUNCTION 'LAST_DAY_IN_PERIOD_GET'
  EXPORTING
    i_gjahr              = i_gjahr
*   I_MONMIT             = 00
    i_periv              = i_periv
    i_poper              = i_poper
 IMPORTING
   E_DATE               = p_date
* EXCEPTIONS
*   INPUT_FALSE          = 1
*   T009_NOTFOUND        = 2
*   T009B_NOTFOUND       = 3
*   OTHERS               = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
*BREAK primusabap.
  date = end_date = p_date.
*END_DATE = START_DATE+3(1) - 1.
*  months = 11.
  months = 36.
*  days = 25.
  days = 0.
  CLEAR: years.
  " CALCULATE 360 DAYS FROM CURRENT DATE AS WE HAVE TO LAST CATOGORY AS 360 DAYS IN REPORT.
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = date
      days      = days
      months    = months
      signum    = '-'
      years     = years
    IMPORTING
      calc_date = start_date.





  PERFORM data_selection.
**  IF F EQ 'X'.
**    PERFORM GL_TALLY.
**  ENDIF.

  PERFORM sort_list.
  PERFORM form_heading.
  PERFORM fill_layout.
  PERFORM set_cell_colours.
  PERFORM grid_display.
*&---------------------------------------------------------------------*
*&      FORM  DATA_SELECTION
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM data_selection.
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<GET CLOSING STOCK DETAILS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  DATA :mm TYPE mslb-lfmon,
        yy TYPE mslb-lfgja.
  yy = sy-datum+0(4).
  mm = sy-datum+4(2).

TYPES: BEGIN OF ty_mmyy,
       year  TYPE mardh-LFGJA,
       month TYPE mardh-LFMON,
       END OF ty_mmyy.
DATA : it_mmyy TYPE TABLE OF ty_mmyy,
       wa_mmyy TYPE          ty_mmyy.
* GETING MATERIAL TYPE WISE MATERIAL.

wa_mmyy-year = fiscal.
wa_mmyy-month = period.
APPEND wa_mmyy TO it_mmyy.
BREAK primusabap.

DO 36 TIMES.
wa_mmyy-month = wa_mmyy-month - 1.
IF wa_mmyy-month = 0 .
wa_mmyy-month = 12.
wa_mmyy-year = wa_mmyy-year - 1.
ENDIF.
wa_mmyy-year = wa_mmyy-year.


APPEND wa_mmyy TO it_mmyy.
ENDDO.


  SELECT mara~matnr mara~mtart  FROM mara INTO TABLE mat_tab
                                    WHERE mara~matnr IN matnr
                                      AND mara~mtart IN mtart
  AND mara~matkl IN matkl.


  IF mat_tab[] IS INITIAL.
    MESSAGE 'NO DATA EXIST FOR SELECTED CRITERIA' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE  LIST-PROCESSING.
  ENDIF.
***********************************GETTING CLOSING STOCK OF MATERIAL**************************
DELETE mat_tab WHERE mtart = 'UNBW'.
  IF mat_tab IS NOT INITIAL.
    SELECT matnr
           bwkey
           lbkum
           VPRSV
           VERPR
           STPRS
           bwtar
           LFGJA
           LFMON
           bklas
           peinh  FROM mbewh INTO TABLE it_mbew
           FOR ALL ENTRIES IN  mat_tab
           WHERE matnr = mat_tab-matnr
           AND bwkey IN werks
*           AND lbkum <> 0
*           AND bwtar EQ space    "VALUATION TYPE
           AND LFGJA = fiscal
           AND LFMON = period.
*                                         AND LVORM EQ SPACE
*                                                                       AND bklas IN bklas.   "VALUATION CLASS
  SELECT matnr
           werks
           lgort
           LFGJA
           LFMON
           labst
           speme
           insme FROM mardh INTO TABLE it_mard
           FOR ALL ENTRIES IN  mat_tab WHERE matnr EQ mat_tab-matnr
             AND werks IN werks
             AND LFGJA = fiscal
             AND LFMON = period.
    SELECT matnr
           werks
           charg
           sobkz
           lifnr
           LFGJA
           LFMON
           lblab FROM mslbh INTO TABLE it_mslb
           FOR ALL ENTRIES IN  mat_tab WHERE matnr EQ mat_tab-matnr
             AND werks IN werks
             AND LFGJA = fiscal
             AND LFMON = period.

  ENDIF.
  d_mbew[] = i_mbew[].

*  IF it_mbew[] IS NOT INITIAL.
*    SELECT matnr
*           mtart
*           meins
*           brgew
*           prdha
*           groes
*           bismt
*           blanz
*           matkl
*           extwg FROM mara INTO TABLE i_mara FOR ALL ENTRIES IN it_mbew WHERE matnr EQ it_mbew-matnr.
*
*
*
*
*  ENDIF.
*  IF i_mara[] IS NOT INITIAL.
*    SELECT * FROM makt INTO TABLE i_makt FOR ALL ENTRIES IN i_mara WHERE matnr = i_mara-matnr AND spras EQ sy-langu.
*  ENDIF.
*********  SELECT CANCELED ENTRIES ******************
  IF mat_tab[] IS NOT INITIAL.
    SELECT  mblnr zeile mjahr  matnr  menge erfmg dmbtr budat_mkpf erfme waers werks smbln lifnr lgort FROM mseg
                     INTO CORRESPONDING FIELDS OF TABLE i_mseg
                         FOR ALL ENTRIES IN  mat_tab WHERE matnr EQ mat_tab-matnr
                                          AND shkzg = 'H'
                                          AND bwart IN ('102','106','310','502','504','506','522','562','312','551','532','546',
                                                        '702','601','641','261','302','311','122','161','309','541','654','941',
                                                         '543','951','321','121','604','201','322')
                                          AND kzvbr <> 'V'
                                          AND smbln <> space
                                          AND werks IN werks
                                          AND budat_mkpf BETWEEN start_date AND end_date.
  ENDIF.

  IF mat_tab[] IS NOT INITIAL.
    SELECT  mblnr zeile mjahr matnr  menge erfmg dmbtr budat_mkpf erfme waers werks lifnr lgort  FROM mseg
                    INTO CORRESPONDING FIELDS OF TABLE r_stock
                       FOR ALL ENTRIES IN  mat_tab WHERE matnr EQ mat_tab-matnr
                                        AND shkzg = 'S'
                                        AND bwart IN ('101','105','309','501','503','505','521','561','311','552','531','545',
                                                      '701','602','642','262','301','123','162','309','542','653','942','544',
                                                      '952','321','121','603','202','322')
                                        AND kzvbr <> 'V'
                                        AND werks IN werks
                                        AND budat_mkpf BETWEEN start_date AND end_date.
  ENDIF.

****************************************Subcontracting Stock**************************************
    IF mat_tab[] IS NOT INITIAL.
    SELECT  mblnr zeile mjahr  matnr  menge erfmg dmbtr budat_mkpf erfme waers werks smbln lifnr lgort FROM mseg
                     INTO CORRESPONDING FIELDS OF TABLE i_mseg1
                         FOR ALL ENTRIES IN  mat_tab WHERE matnr EQ mat_tab-matnr
                                          AND shkzg = 'H'
                                          AND bwart IN ('542','544')
                                          AND kzvbr <> 'V'
                                          AND smbln <> space
                                          AND werks IN werks
                                          AND budat_mkpf BETWEEN start_date AND end_date.
  ENDIF.

  IF mat_tab[] IS NOT INITIAL.
    SELECT  mblnr zeile mjahr matnr  menge erfmg dmbtr budat_mkpf erfme waers werks lifnr lgort  FROM mseg
      INTO CORRESPONDING FIELDS OF TABLE r_stock1
                       FOR ALL ENTRIES IN  mat_tab WHERE matnr EQ mat_tab-matnr
                                        AND shkzg = 'S'
                                        AND bwart IN ('541','543')
                                        AND kzvbr <> 'V'
                                        AND werks IN werks
                                        AND budat_mkpf BETWEEN start_date AND end_date.
  ENDIF.






  LOOP AT i_mseg.
    LOOP AT r_stock WHERE matnr EQ i_mseg-matnr AND mblnr EQ i_mseg-smbln
                                                AND mjahr EQ i_mseg-mjahr.
      DELETE  r_stock ."FROM WR_STOCK.
      CLEAR : wr_stock.
    ENDLOOP.

  ENDLOOP.
  LOOP AT i_mseg1.
    LOOP AT r_stock1 WHERE matnr EQ i_mseg1-matnr AND mblnr EQ i_mseg1-smbln
                                                AND mjahr EQ i_mseg1-mjahr.
      DELETE  r_stock1 ."FROM WR_STOCK.
      CLEAR : wr_stock1.
    ENDLOOP.

  ENDLOOP.
*************************** ISSUE STOCK **********
  SORT r_stock BY matnr budat_mkpf DESCENDING.
  SORT r_stock1 BY matnr budat_mkpf DESCENDING.
********************************LAYOUT DAY WISE*********************************************
  BREAK primusabap.
* DATA : month TYPE mardh-LFMON.
  LOOP AT it_mard  INTO wa_mard.
*    CLEAR month.
*    month = period.
    flag = 0.
    total1          =  wa_mard-labst + wa_mard-insme. "STOCK AGING CALCULATION
    w_final-erfmg   = wa_mard-labst + wa_mard-insme.  "STOCK CALCULATION
    w_final-matnr = wa_mard-matnr.
    w_final-werks = wa_mard-werks.
    w_final-lgort = wa_mard-lgort.

    LOOP AT it_mmyy INTO wa_mmyy.
      SELECT SINGLE * FROM mbewh INTO CORRESPONDING FIELDS OF wa_mbew
           WHERE matnr = wa_mard-matnr
           AND bwkey = wa_mard-werks
           AND LFGJA = wa_mmyy-year
           AND LFMON = wa_mmyy-month .
    IF wa_mbew IS NOT INITIAL.
      EXIT.
    ENDIF.

    ENDLOOP.

*    READ TABLE it_mbew INTO wa_mbew WITH KEY  matnr = wa_mard-matnr bwkey = wa_mard-werks." LGORT = '75' .
*    IF wa_mbew IS INITIAL.
*    month = month - 1.
*    SELECT SINGLE * FROM mbewh INTO CORRESPONDING FIELDS OF wa_mbew
*           WHERE matnr = wa_mard-matnr
*           AND bwkey = wa_mard-werks
*           AND LFGJA = fiscal
*           AND LFMON = month .
*    IF wa_mbew IS INITIAL.
*     month = month - 1.
*      SELECT SINGLE * FROM mbewh INTO CORRESPONDING FIELDS OF wa_mbew
*           WHERE matnr = wa_mard-matnr
*           AND bwkey = wa_mard-werks
*           AND LFGJA = fiscal
*           AND LFMON = month .
*    IF wa_mbew IS INITIAL.
*     month = month - 1.
*     SELECT SINGLE * FROM mbewh INTO CORRESPONDING FIELDS OF wa_mbew
*           WHERE matnr = wa_mard-matnr
*           AND bwkey = wa_mard-werks
*           AND LFGJA = fiscal
*           AND LFMON = month .
*    ENDIF.
*    ENDIF.
*
*    ENDIF.

    IF wa_mbew IS NOT INITIAL.

    IF wa_mbew-vprsv = 'S'.
      w_final-dmbtr   = ( total1 * ( wa_mbew-stprs / wa_mbew-peinh ) ). "PER_VAL-VERPR * W_FINAL-ERFMG
    ENDIF.
    IF wa_mbew-vprsv = 'V'.
      w_final-dmbtr   = ( total1 * ( wa_mbew-verpr / wa_mbew-peinh ) ). "PER_VAL-VERPR * W_FINAL-ERFMG
    ENDIF.

    ENDIF.
    var = total1.
    SELECT SINGLE * FROM makt INTO wa_makt WHERE matnr = wa_mard-matnr.
*    READ TABLE i_makt WITH KEY  matnr = wa_mard-matnr.
    IF sy-subrc = 0 .
      w_final-maktx = wa_makt-maktx.
    ENDIF.

*    READ TABLE i_mara  WITH KEY matnr = wa_mard-matnr.
    SELECT SINGLE * FROM mara INTO wa_mara WHERE matnr = wa_mard-matnr.
    IF sy-subrc = 0.


    w_final-mtart = wa_mara-mtart.
    w_final-meins = wa_mara-meins.
    w_final-brgew = wa_mara-brgew.
    w_final-prdha = wa_mara-prdha.
    w_final-groes = wa_mara-groes.
    w_final-bismt = wa_mara-bismt.
    w_final-blanz = wa_mara-blanz.
    w_final-matkl = wa_mara-matkl.
    w_final-extwg = wa_mara-extwg.
    ENDIF.

    READ TABLE i_t030 WITH KEY bklas = wa_mbew-bklas.
    IF sy-subrc = 0.
    w_final-hkont = i_t030-konts.
    ENDIF.

    LOOP AT r_stock INTO wr_stock WHERE matnr EQ wa_mard-matnr AND lgort EQ wa_mard-lgort AND werks EQ wa_mard-werks.
*      flag = 1.
      IF var EQ 0. " WHEN STOCK EXACTLY MATCHES
        EXIT.
      ELSEIF wr_stock-menge GE var. " IF GRN IS GREATER
        wr_stock-menge     = var.
*        w_final-budat_mkpf = wr_stock-budat_mkpf.
        var = var - var.
      ELSE. " IF GRN IS LESS.
*        w_final-erfmg1     = wr_stock-menge.
        var = var - wr_stock-menge.
*        wr_stock-menge = var.
*        w_final-budat_mkpf = wr_stock-budat_mkpf.
      ENDIF.
      w_final-budat_mkpf = wr_stock-budat_mkpf.
      w_final-waers = wr_stock-waers.
*      w_final-werks = wa_mbew-bwkey.
*      w_final-matnr = wa_mbew-matnr.
      w_final-bklas = wa_mbew-bklas.

      CALL FUNCTION 'HR_SGPBS_YRS_MTHS_DAYS'
        EXPORTING
          beg_da     = w_final-budat_mkpf
          end_da     = end_date
        IMPORTING
          no_cal_day = w_final-days.

*      IF w_final-days LE 30.
*        w_final-day30      =   w_final-day30 + wr_stock-menge.
*
*      ELSEIF w_final-days LE 60.
*        w_final-day60      =    w_final-day60 + wr_stock-menge.

      IF w_final-days <= 90.
        w_final-day90      =    w_final-day90 + wr_stock-menge.

*      ELSEIF w_final-days LE 120.
*        w_final-day120     =    w_final-day120 + wr_stock-menge.

*      ELSEIF w_final-days LE 150.
*        w_final-day150     =    w_final-day150 + wr_stock-menge.

      ELSEIF w_final-days BETWEEN 91 AND 180.
        w_final-day180     =    w_final-day180 + wr_stock-menge.

      ELSEIF w_final-days BETWEEN 181 AND 365.
        w_final-day365     =    w_final-day365 + wr_stock-menge.

*      ELSEIF w_final-days > 365.
*        w_final-day365_p     =    w_final-day365_p + wr_stock-menge.

*    ELSEIF w_final-days LE 730.
*        w_final-day730     =    w_final-day730 + wr_stock-menge.
*
*    ELSEIF w_final-days LE 1095.
*        w_final-day1095     =    w_final-day1095 + wr_stock-menge.
*
*    ELSEIF w_final-days > 1095.
*        w_final-day1095_p     =    w_final-day1095_p + wr_stock-menge.

   ENDIF.

    ENDLOOP.
    APPEND  w_final TO it_final.
      CLEAR : w_final.
      CLEAR : wa_mard ,total ,wa_mbew.
    CLEAR var.
  ENDLOOP.
*  DELETE  it_final WHERE erfmg IS INITIAL.
**************************************Subcontracting Stock*************************
*  LOOP AT it_mslb  INTO wa_mslb.
*    CLEAR month.
*    month = period.
*    flag = 0.
*    total1          =  wa_mslb-lblab.
*    w_final-erfmg   = wa_mslb-lblab.
*    w_final-matnr = wa_mslb-matnr.
*    w_final-werks = wa_mslb-werks.
*    w_final-lgort = 'SUBC'.
*
*    READ TABLE it_mbew INTO wa_mbew WITH KEY  matnr = wa_mslb-matnr bwkey = wa_mslb-werks." LGORT = '75' .
*    IF wa_mbew IS INITIAL.
*    month = month - 1.
*    SELECT SINGLE * FROM mbewh INTO CORRESPONDING FIELDS OF wa_mbew
*           WHERE matnr = wa_mslb-matnr
*           AND bwkey = wa_mslb-werks
*           AND LFGJA = fiscal
*           AND LFMON = month .
*    IF wa_mbew IS INITIAL.
*     month = month - 1.
*      SELECT SINGLE * FROM mbewh INTO CORRESPONDING FIELDS OF wa_mbew
*           WHERE matnr = wa_mslb-matnr
*           AND bwkey = wa_mslb-werks
*           AND LFGJA = fiscal
*           AND LFMON = month .
*    IF wa_mbew IS INITIAL.
*     month = month - 1.
*     SELECT SINGLE * FROM mbewh INTO CORRESPONDING FIELDS OF wa_mbew
*           WHERE matnr = wa_mslb-matnr
*           AND bwkey = wa_mslb-werks
*           AND LFGJA = fiscal
*           AND LFMON = month .
*    ENDIF.
*    ENDIF.
*
*    ENDIF.
*
*    IF wa_mbew IS NOT INITIAL.
*
*    IF wa_mbew-vprsv = 'S'.
*      w_final-dmbtr   = ( total1 * ( wa_mbew-stprs / wa_mbew-peinh ) ). "PER_VAL-VERPR * W_FINAL-ERFMG
*    ENDIF.
*    IF wa_mbew-vprsv = 'V'.
*      w_final-dmbtr   = ( total1 * ( wa_mbew-verpr / wa_mbew-peinh ) ). "PER_VAL-VERPR * W_FINAL-ERFMG
*    ENDIF.
*
*    ENDIF.
*
*    var = total1.
*
*    CLEAR: wa_makt,wa_mara.
*    SELECT SINGLE * FROM makt INTO wa_makt WHERE matnr = wa_mslb-matnr.
**    READ TABLE i_makt WITH KEY  matnr = wa_mslb-matnr.
*    IF sy-subrc = 0 .
*      w_final-maktx = wa_makt-maktx.
*    ENDIF.
*
*    SELECT SINGLE * FROM mara INTO wa_mara WHERE matnr = wa_mslb-matnr.
**    READ TABLE i_mara  WITH KEY matnr = wa_mslb-matnr.
*    IF sy-subrc = 0.
*
*
*    w_final-mtart = wa_mara-mtart.
*    w_final-meins = wa_mara-meins.
*    w_final-brgew = wa_mara-brgew.
*    w_final-prdha = wa_mara-prdha.
*    w_final-groes = wa_mara-groes.
*    w_final-bismt = wa_mara-bismt.
*    w_final-blanz = wa_mara-blanz.
*    w_final-matkl = wa_mara-matkl.
*    w_final-extwg = wa_mara-extwg.
*    ENDIF.
*
*    READ TABLE i_t030 WITH KEY bklas = wa_mbew-bklas.
*    IF sy-subrc = 0.
*    w_final-hkont = i_t030-konts.
*    ENDIF.
*
*    LOOP AT r_stock1 INTO wr_stock1 WHERE matnr EQ wa_mslb-matnr AND lifnr EQ wa_mslb-lifnr.
**      flag = 1.
*      IF var EQ 0. " WHEN STOCK EXACTLY MATCHES
*        EXIT.
*      ELSEIF wr_stock1-menge GE var. " IF GRN IS GREATER
*        wr_stock1-menge     = var.
**        w_final-budat_mkpf = wr_stock-budat_mkpf.
*        var = var - var.
*      ELSE. " IF GRN IS LESS.
**        w_final-erfmg1     = wr_stock-menge.
*        var = var - wr_stock1-menge.
**        wr_stock-menge = var.
**        w_final-budat_mkpf = wr_stock-budat_mkpf.
*      ENDIF.
*      w_final-budat_mkpf = wr_stock1-budat_mkpf.
*      w_final-waers = wr_stock1-waers.
**      w_final-werks = wa_mbew-bwkey.
**      w_final-matnr = wa_mbew-matnr.
*      w_final-bklas = wa_mbew-bklas.
*
*      CALL FUNCTION 'HR_SGPBS_YRS_MTHS_DAYS'
*        EXPORTING
*          beg_da     = w_final-budat_mkpf
*          end_da     = end_date
*        IMPORTING
*          no_cal_day = w_final-days.
*
*      IF w_final-days LE 30.
*        w_final-day30      =   w_final-day30 + wr_stock1-menge.
*
*      ELSEIF w_final-days LE 60.
*        w_final-day60      =    w_final-day60 + wr_stock1-menge.
*
*      ELSEIF w_final-days LE 90.
*        w_final-day90      =    w_final-day90 + wr_stock1-menge.
*
*      ELSEIF w_final-days LE 120.
*        w_final-day120     =    w_final-day120 + wr_stock1-menge.
*
*      ELSEIF w_final-days LE 150.
*        w_final-day150     =    w_final-day150 + wr_stock1-menge.
*
*      ELSEIF w_final-days LE 180.
*        w_final-day180     =    w_final-day180 + wr_stock1-menge.
*
*      ELSEIF w_final-days LE 365.
*        w_final-day365     =    w_final-day365 + wr_stock1-menge.
*
*      ELSEIF w_final-days > 365.
*        w_final-day365_p     =    w_final-day365_p + wr_stock1-menge.
*
**    ELSEIF w_final-days LE 730.
**        w_final-day730     =    w_final-day730 + wr_stock1-menge.
**
**    ELSEIF w_final-days LE 1095.
**        w_final-day1095     =    w_final-day1095 + wr_stock1-menge.
**
**    ELSEIF w_final-days > 1095.
**        w_final-day1095_p     =    w_final-day1095_p + wr_stock1-menge.
*
*   ENDIF.
*
*
*
*
*    ENDLOOP.
*    APPEND  w_final TO it_final.
*      CLEAR : w_final.
*      CLEAR : wa_mslb ,total .
*    CLEAR var.
*  ENDLOOP.

DELETE  it_final WHERE erfmg IS INITIAL.
  loop at it_final into w_final.

     if w_final-dmbtr is NOT INITIAL.

      div = w_final-dmbtr / w_final-ERFMG.

    endif.

    w_final-value30       =   w_final-day30     * div.
    w_final-value60       =   w_final-day60     * div.
    w_final-value90       =   w_final-day90     * div.
    w_final-value120      =   w_final-day120    * div.
    w_final-value150      =   w_final-day150    * div.
    w_final-value180      =   w_final-day180    * div.
    w_final-value365      =   w_final-day365    * div.
    w_final-value365_p    =   w_final-day365_p  * div.
*    w_final-value730      =   w_final-day730    * div.
*    w_final-value1095     =   w_final-day1095   * div.
*    w_final-value1095_p   =   w_final-day1095_p * div.

     MODIFY it_final FROM w_final."
    CLEAR : w_final,div.
    endloop.
***************************************************

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  SORT_LIST
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM sort_list.
  t_sort-spos      = '1'.
  t_sort-fieldname = 'MATNR'.
  t_sort-tabname   = 'IT_FINAL'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.
ENDFORM.                    "SORT_LIST

*&---------------------------------------------------------------------*
*&      FORM  FORM_HEADING
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM form_heading .

  REFRESH t_fieldcat.
  PERFORM t_fieldcatlog USING  '1'   'MATNR'       'Material'.
  PERFORM t_fieldcatlog USING  '2'   'MTART'       'Material Type'.
  PERFORM T_FIELDCATLOG USING  '3'   'WERKS'       'PLANT'.
  PERFORM t_fieldcatlog USING  '4'   'MAKTX'       'Mat Desc'.
  PERFORM t_fieldcatlog USING  '5'   'BRGEW'       'Per Unit Weight'.
  PERFORM t_fieldcatlog USING  '6'   'BISMT'       'Old Mat No'.
  PERFORM t_fieldcatlog USING  '7'   'MATKL'       'Mat Grp'.
  PERFORM t_fieldcatlog USING  '8'   'LGORT'       'Stor.loc'.
  PERFORM t_fieldcatlog USING  '9'   'ERFMG'       'Stock'  .
  PERFORM t_fieldcatlog USING  '10'   'MEINS'       'Mat Unit'.
  PERFORM t_fieldcatlog USING  '11'   'DMBTR'       'Stock Value'.
  PERFORM t_fieldcatlog USING  '12'   'WAERS'       'Currency'.
*  PERFORM t_fieldcatlog USING  '13'   'DAY30'       '30 Days'.
*  PERFORM t_fieldcatlog USING  '14'   'VALUE30'     '30 Days Stk. Value'.
*  PERFORM t_fieldcatlog USING  '15'   'DAY60'       '60 Days'.
*  PERFORM t_fieldcatlog USING  '16'   'VALUE60'     '60 Days Stk. Value'.
  PERFORM t_fieldcatlog USING  '13'   'DAY90'       'Upto 90 Days'.
  PERFORM t_fieldcatlog USING  '14'   'VALUE90'     '90 Days Stk. Value'.
*  PERFORM t_fieldcatlog USING  '19'   'DAY120'      '120 Days'.
*  PERFORM t_fieldcatlog USING  '20'   'VALUE120'    '120 Days Stk. Value'.
*  PERFORM t_fieldcatlog USING  '21'   'DAY150'      '150 Days'.
*  PERFORM t_fieldcatlog USING  '22'   'VALUE150'    '150 Days Stk. Value'.
  PERFORM t_fieldcatlog USING  '15'   'DAY180'      '91-180 Days'.
  PERFORM t_fieldcatlog USING  '16'   'VALUE180'    '91-180 Days Stk. Value'.
  PERFORM t_fieldcatlog USING  '17'   'DAY365'      '181-365 Days'.
  PERFORM t_fieldcatlog USING  '18'   'VALUE365'    '181-365 Days Stk. Value'.
*  PERFORM t_fieldcatlog USING  '27'   'DAY365_P'    '365 + Days'.
*  PERFORM t_fieldcatlog USING  '28'   'VALUE365_P'  '365 + Days Stk. Value'.
*  PERFORM t_fieldcatlog USING  '27'   'DAY730 '     '730 Days'. """""""""
*  PERFORM t_fieldcatlog USING  '28'   'VALUE730 '   '730 Days Stk. Value'.
*
*  PERFORM t_fieldcatlog USING  '29'   'DAY1095 '     '1095  Days'."""""""'
*  PERFORM t_fieldcatlog USING  '30'   'VALUE1095 '   '1095  Days Stk. Value'.
*
*  PERFORM t_fieldcatlog USING  '31'   'DAY1095_P '     '1095 + Days'.
*  PERFORM t_fieldcatlog USING  '32'   'DAY1095_P '     '1095 + Days Stk. Value'.
  PERFORM t_fieldcatlog USING  '19'   'BKLAS'       'Valuation Class'.
*  PERFORM t_fieldcatlog USING  '30'   'EXTWG'       'External Material group'.
ENDFORM.                    "FORM_HEADING

*&---------------------------------------------------------------------*
*&      FORM  FILL_LAYOUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM fill_layout.
  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra             = 'X'.
  fs_layout-detail_popup      = 'X'.
  fs_layout-subtotals_text    = 'TOTAL'.
  fs_layout-coltab_fieldname  = 'CELLCOLOR'.

ENDFORM.                    "FILL_LAYOUT

*&---------------------------------------------------------------------*
*&      FORM  GRID_DISPLAY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM grid_display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      is_layout               = fs_layout
      i_callback_top_of_page  = 'TOP-OF-PAGE'
      it_fieldcat             = t_fieldcat[]
      it_sort                 = t_sort[]
      i_save                  = 'X'
    TABLES
      t_outtab                = it_final[]
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    "GRID_DISPLAY


*&---------------------------------------------------------------------*
*&      FORM  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->VALUE(X)   TEXT
*      -->VALUE(F1)  TEXT
*      -->VALUE(F2)  TEXT
*----------------------------------------------------------------------*
FORM t_fieldcatlog  USING    VALUE(x)
                             VALUE(f1)
                             VALUE(f2).
  t_fieldcat-col_pos   = x.
  t_fieldcat-fieldname = f1.
  t_fieldcat-seltext_l = f2.
*  T_FIELDCAT-NO_ZERO = 'X'.
*  IF F1 = 'ERFMG1'.
*    T_FIELDCAT-DO_SUM = 'X'.
*  ENDIF.
  APPEND t_fieldcat.
  CLEAR  t_fieldcat.
ENDFORM.                    " T_FIELDCATLOG

*&---------------------------------------------------------------------*
*&      FORM  TOP-OF-PAGE

*-----------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM top-of-page.
*      ALV HEADER DECLARATIONS
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.
*TITLE
  wa_header-typ  = 'H'.
  wa_header-info = 'STOCK AGEING REPORT'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.

*       TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'TOTAL NO. OF RECORDS  SELECTED : ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  SELECT SINGLE name1 FROM t001w INTO plant WHERE werks EQ werks AND spras EQ sy-langu.

  CONCATENATE 'PLANT : ' plant
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'H'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header
      i_logo             = 'NEW_LOGO'.
ENDFORM.                    "TOP-OF-PAGE

*&---------------------------------------------------------------------*
*&      FORM  SET_CELL_COLOURS
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM set_cell_colours .
  DATA: wa_cellcolor TYPE lvc_s_scol.
  DATA: ld_index     TYPE sy-tabix.

  LOOP AT it_final INTO w_final.
    ld_index = sy-tabix.
    IF w_final-days          > '30'.
      wa_cellcolor-fname     = 'DAYS'.
      wa_cellcolor-color-col = 6.  "COLOR CODE 1-7, IF OUTSIDE RAGE DEFAULTS TO 7
      wa_cellcolor-color-int = '0'.  "1 = INTENSIFIED ON, 0 = INTENSIFIED OFF
      wa_cellcolor-color-inv = '0'.  "1 = TEXT COLOUR, 0 = BACKGROUND COLOUR
      APPEND wa_cellcolor TO w_final-cellcolor.
      MODIFY it_final FROM w_final INDEX ld_index TRANSPORTING cellcolor.
      CLEAR: wa_cellcolor.
*
*      WA_CELLCOLOR-FNAME = 'ERFMG1'.
*      WA_CELLCOLOR-COLOR-COL = 5.  "COLOR CODE 1-7, IF OUTSIDE RAGE DEFAULTS TO 7
*      WA_CELLCOLOR-COLOR-INT = 1.  "1 = INTENSIFIED ON, 0 = INTENSIFIED OFF
*      WA_CELLCOLOR-COLOR-INV = '0'.  "1 = TEXT COLOUR, 0 = BACKGROUND COLOUR
*      APPEND WA_CELLCOLOR TO W_FINAL-CELLCOLOR.
*      MODIFY IT_FINAL FROM W_FINAL INDEX LD_INDEX TRANSPORTING CELLCOLOR.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " SET_CELL_COLOURS
*&---------------------------------------------------------------------*
*&      FORM  GL_TALLY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*

FORM user_command USING p_ucomm LIKE sy-ucomm
      ps_selfield TYPE slis_selfield .


  CASE p_ucomm.
    WHEN '&IC1'.

      SET PARAMETER ID 'BLN'  FIELD ps_selfield-value .
      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

  ENDCASE.
ENDFORM.
