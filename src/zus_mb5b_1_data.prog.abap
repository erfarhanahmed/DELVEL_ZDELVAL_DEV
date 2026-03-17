*&---------------------------------------------------------------------*
*&  Include           ZUS_MB5B_1_DATA
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
  DATA: LV_BUDAT_LOW  TYPE  MSEG-BUDAT_MKPF,
        LV_BUDAT_HIGH TYPE  MSEG-BUDAT_MKPF.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      DATE      = S_BUDAT-LOW
      DAYS      = 01
      MONTHS    = 00
      SIGNUM    = '-'
      YEARS     = 00
    IMPORTING
      CALC_DATE = LV_BUDAT_HIGH.

  LV_BUDAT_LOW = '20000101'.

  SELECT MATNR,
         BWKEY,
         BELNR,
         GJAHR,
         SHKZG,
         DMBTR,
         MENGE,
         BUDAT
     FROM BSIM
     INTO TABLE @DATA(IT_BSIM)
     WHERE BUDAT BETWEEN @LV_BUDAT_LOW  AND @LV_BUDAT_HIGH
     AND MATNR IN @S_MATNR
     AND SHKZG EQ 'S'
     AND BWKEY IN @S_WERKS.

DELETE IT_BSIM WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
  SELECT MATNR,
     WERKS,
     BELNR,
     GJAHR,
     SHKZG,
     DMBTR,
     MENGE,
     BUDAT_MKPF
 FROM MSEG
 INTO TABLE @DATA(IT_IS)
 WHERE BUDAT_MKPF BETWEEN @LV_BUDAT_LOW  AND @LV_BUDAT_HIGH
 AND MATNR IN @S_MATNR
 AND WERKS IN @S_WERKS
  AND   BUSTW NE ''.   .
DELETE IT_IS WHERE ( WERKS = 'PL01' OR WERKS = 'SU01').
  LOOP AT IT_IS ASSIGNING FIELD-SYMBOL(<FS_IS>).
    ON CHANGE OF <FS_IS>-MATNR.
      LOOP AT IT_IS INTO <FS_IS> WHERE MATNR = <FS_IS>-MATNR.
        IF <FS_IS>-SHKZG EQ 'S' .
          WA_IS1-MENGE = WA_IS1-MENGE + <FS_IS>-MENGE.
        ELSEIF  <FS_IS>-SHKZG EQ 'H' .
          WA_IS1-MENGE1 = WA_IS1-MENGE1 + <FS_IS>-MENGE.
        ENDIF.
      ENDLOOP.
      WA_IS1-MATNR = <FS_IS>-MATNR.
      APPEND WA_IS1 TO IT_IS1.
      CLEAR WA_IS1.
    ENDON.
  ENDLOOP.

  SELECT MATNR,
     BWKEY,
     BELNR,
     GJAHR,
     SHKZG,
     DMBTR,
     MENGE,
     BUDAT
 FROM BSIM
 INTO TABLE @DATA(IT_BSIM1)
 WHERE BUDAT BETWEEN @LV_BUDAT_LOW  AND @LV_BUDAT_HIGH
 AND MATNR IN @S_MATNR
 AND SHKZG EQ 'H'
 AND BWKEY IN @S_WERKS.
DELETE IT_BSIM1 WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
  IF S_BUDAT IS INITIAL.
    SELECT MATNR,
           BWKEY,
           BELNR,
           GJAHR,
           SHKZG,
           DMBTR,
           MENGE,
           BUDAT
      FROM BSIM
      INTO TABLE @IT_BSIM
      WHERE  MATNR IN @S_MATNR
      AND SHKZG EQ 'S'
      AND BWKEY IN @S_WERKS
      AND BUDAT IN @S_BUDAT.
DELETE IT_BSIM WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
    SELECT MATNR,
           BWKEY,
           BELNR,
           GJAHR,
           SHKZG,
           DMBTR,
           MENGE,
           BUDAT
      FROM BSIM
      INTO TABLE @IT_BSIM1
      WHERE MATNR IN @S_MATNR
      AND SHKZG EQ 'H'
      AND BWKEY IN @S_WERKS
      AND BUDAT IN @S_BUDAT.
  ENDIF.
DELETE IT_BSIM1 WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
  """"""""""""""""""""""""""""""""""""""""""""""""""""""NEW LOGIC ADDED
  LOOP AT IT_BSIM ASSIGNING FIELD-SYMBOL(<FS_BSIM>).
    ON CHANGE OF <FS_BSIM>-MATNR. " comment by supriya
      LOOP AT IT_BSIM INTO <FS_BSIM> WHERE MATNR = <FS_BSIM>-MATNR.
        WA_SUM_NEW1-MENGE = WA_SUM_NEW1-MENGE + <FS_BSIM>-MENGE.
        WA_SUM_NEW1-DMBTR = WA_SUM_NEW1-DMBTR + <FS_BSIM>-DMBTR.
      ENDLOOP.
      WA_SUM_NEW1-MATNR = <FS_BSIM>-MATNR.
      WA_SUM_NEW1-SHKZG = <FS_BSIM>-SHKZG.
      APPEND WA_SUM_NEW1 TO IT_SUM_NEW1.
      CLEAR WA_SUM_NEW1.
    ENDON.
  ENDLOOP.

  LOOP AT IT_BSIM1 ASSIGNING FIELD-SYMBOL(<FS_BSIM1>).
    ON CHANGE OF <FS_BSIM1>-MATNR.
      LOOP AT IT_BSIM1 INTO <FS_BSIM1> WHERE MATNR = <FS_BSIM1>-MATNR.
        WA_SUM_NEW1-MENGE = WA_SUM_NEW1-MENGE + <FS_BSIM1>-MENGE.
        WA_SUM_NEW1-DMBTR = WA_SUM_NEW1-DMBTR + <FS_BSIM1>-DMBTR.
      ENDLOOP.
      WA_SUM_NEW1-MATNR = <FS_BSIM1>-MATNR.
      WA_SUM_NEW1-SHKZG = <FS_BSIM1>-SHKZG.
      APPEND WA_SUM_NEW1 TO IT_SUM_NEW1.
      CLEAR WA_SUM_NEW1.
    ENDON.
  ENDLOOP.

  SELECT MATNR,
         BWKEY,
         MENGE,
         DMBTR,
         SHKZG
    FROM BSIM
    INTO TABLE @DATA(IT_BSIM_NEW)
    WHERE MATNR IN @S_MATNR
    AND BUDAT EQ @S_BUDAT-LOW
    AND SHKZG EQ 'S'
    AND BWKEY IN @S_WERKS.
DELETE IT_BSIM_NEW WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
  LOOP AT IT_BSIM_NEW ASSIGNING FIELD-SYMBOL(<FS_BSIM_NEW>).
    ON CHANGE OF <FS_BSIM_NEW>-MATNR.
      LOOP AT IT_BSIM_NEW INTO <FS_BSIM_NEW> WHERE MATNR = <FS_BSIM_NEW>-MATNR.
        WA_SUM_NEW2-MENGE = WA_SUM_NEW2-MENGE + <FS_BSIM_NEW>-MENGE.
        WA_SUM_NEW2-DMBTR = WA_SUM_NEW2-DMBTR + <FS_BSIM_NEW>-DMBTR.
      ENDLOOP.
      WA_SUM_NEW2-MATNR = <FS_BSIM_NEW>-MATNR.
      WA_SUM_NEW2-SHKZG = <FS_BSIM_NEW>-SHKZG.
      APPEND WA_SUM_NEW2 TO IT_SUM_NEW2.
      CLEAR WA_SUM_NEW2.
    ENDON.
  ENDLOOP.

  IF S_BUDAT-LOW IS NOT INITIAL AND S_BUDAT-HIGH IS NOT INITIAL.
    SELECT MATNR,
           BWKEY,
           MENGE,
           DMBTR,
           SHKZG
     FROM BSIM
     INTO TABLE @DATA(IT_BSIM_NEW1)
     WHERE MATNR IN @S_MATNR
     AND BUDAT EQ @S_BUDAT-LOW
     AND SHKZG EQ 'H'
     AND BWKEY IN @S_WERKS.
DELETE IT_BSIM_NEW1 WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
    LOOP AT IT_BSIM_NEW1 ASSIGNING FIELD-SYMBOL(<FS_BSIM_NEW1>).
      ON CHANGE OF <FS_BSIM_NEW1>-MATNR.
        LOOP AT IT_BSIM_NEW1 INTO <FS_BSIM_NEW1> WHERE MATNR = <FS_BSIM_NEW1>-MATNR.
          WA_SUM_NEW2-MENGE = WA_SUM_NEW2-MENGE + <FS_BSIM_NEW1>-MENGE.
          WA_SUM_NEW2-DMBTR = WA_SUM_NEW2-DMBTR + <FS_BSIM_NEW1>-DMBTR.
        ENDLOOP.
        WA_SUM_NEW2-MATNR = <FS_BSIM_NEW1>-MATNR.
        WA_SUM_NEW2-SHKZG = <FS_BSIM_NEW1>-SHKZG.
        APPEND WA_SUM_NEW2 TO IT_SUM_NEW2.
        CLEAR WA_SUM_NEW2.
      ENDON.
    ENDLOOP.

    SELECT MATNR,""""
           WERKS,
           MENGE,
           SHKZG,
           MBLNR,
           ZEILE
      FROM MSEG
      INTO TABLE @DATA(IT_MULT)
      WHERE MATNR IN @S_MATNR
      AND   WERKS IN @S_WERKS
      AND   BUDAT_MKPF IN @S_BUDAT
      AND   BUSTW NE ''.
DELETE IT_MULT WHERE ( WERKS = 'PL01' OR WERKS = 'SU01').
    LOOP AT IT_MULT ASSIGNING FIELD-SYMBOL(<FS_MUIL>).
      ON CHANGE OF <FS_MUIL>-MATNR.
        LOOP AT IT_MULT INTO <FS_MUIL> WHERE MATNR = <FS_MUIL>-MATNR.
          IF <FS_MUIL>-SHKZG EQ 'S' .
            WA_QTY_NEW-MENGE = WA_QTY_NEW-MENGE + <FS_MUIL>-MENGE.
          ELSEIF  <FS_MUIL>-SHKZG EQ 'H' .
            WA_QTY_NEW-MENGE1 = WA_QTY_NEW-MENGE1 + <FS_MUIL>-MENGE.
          ENDIF.
        ENDLOOP.
        WA_QTY_NEW-MATNR = <FS_MUIL>-MATNR.
        APPEND WA_QTY_NEW TO IT_QTY_NEW.
        CLEAR WA_QTY_NEW.
      ENDON.
    ENDLOOP.

  ENDIF.

  SELECT MATNR,
             BWKEY,
             MENGE,
             DMBTR,
             SHKZG
        FROM BSIM
        INTO TABLE @DATA(IT_MSEG)
        WHERE MATNR IN @S_MATNR
        AND BUDAT IN @S_BUDAT
        AND SHKZG = 'S'
        AND BWKEY IN @S_WERKS.
DELETE IT_MSEG WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
  LOOP AT IT_MSEG ASSIGNING FIELD-SYMBOL(<FS_MSEG>).
    ON CHANGE OF <FS_MSEG>-MATNR.
      LOOP AT IT_MSEG INTO <FS_MSEG> WHERE MATNR = <FS_MSEG>-MATNR.
        WA_SUM_NEW3-MENGE = WA_SUM_NEW3-MENGE + <FS_MSEG>-MENGE.
        WA_SUM_NEW3-DMBTR = WA_SUM_NEW3-DMBTR + <FS_MSEG>-DMBTR.
      ENDLOOP.
      WA_SUM_NEW3-MATNR = <FS_MSEG>-MATNR.
      WA_SUM_NEW3-SHKZG = <FS_MSEG>-SHKZG.
      APPEND WA_SUM_NEW3 TO IT_SUM_NEW3.
      CLEAR WA_SUM_NEW3.
    ENDON.
  ENDLOOP.

  SELECT MATNR,
         BWKEY,
         MENGE,
         DMBTR,
         SHKZG
   FROM BSIM
   INTO TABLE @DATA(IT_MSEG1)
   WHERE MATNR IN @S_MATNR
   AND BUDAT IN @S_BUDAT
   AND SHKZG = 'H'
   AND BWKEY IN @S_WERKS.
DELETE IT_MSEG1 WHERE ( BWKEY = 'PL01' OR BWKEY = 'SU01').
  LOOP AT IT_MSEG1 ASSIGNING FIELD-SYMBOL(<FS_MSEG1>).
    ON CHANGE OF <FS_MSEG1>-MATNR.
      LOOP AT IT_MSEG1 INTO <FS_MSEG1> WHERE MATNR = <FS_MSEG1>-MATNR.
        WA_SUM_NEW3-MENGE = WA_SUM_NEW3-MENGE + <FS_MSEG1>-MENGE.
        WA_SUM_NEW3-DMBTR = WA_SUM_NEW3-DMBTR + <FS_MSEG1>-DMBTR.
      ENDLOOP.
      WA_SUM_NEW3-MATNR = <FS_MSEG1>-MATNR.
      WA_SUM_NEW3-SHKZG = <FS_MSEG1>-SHKZG.
      APPEND WA_SUM_NEW3 TO IT_SUM_NEW3.
      CLEAR WA_SUM_NEW3.
    ENDON.
  ENDLOOP.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""LOGIC FOR QTY
  SELECT MATNR,
         WERKS,
         MENGE,
         SHKZG,
         MBLNR,
         ZEILE
    FROM MSEG
    INTO TABLE @DATA(IT_QTY1)
    WHERE MATNR IN @S_MATNR
    AND   WERKS IN @S_WERKS
    AND   BUSTW NE ''.
DELETE IT_QTY1 WHERE ( WERKS = 'PL01' OR WERKS = 'SU01').
  LOOP AT IT_QTY1 ASSIGNING FIELD-SYMBOL(<FS_QTY>).
    ON CHANGE OF <FS_QTY>-MATNR.
      LOOP AT IT_QTY1 INTO <FS_QTY> WHERE MATNR = <FS_QTY>-MATNR.
        IF <FS_QTY>-SHKZG EQ 'S' .
          WA_QTY-MENGE = WA_QTY-MENGE + <FS_QTY>-MENGE.
        ELSEIF  <FS_QTY>-SHKZG EQ 'H' .
          WA_QTY-MENGE1 = WA_QTY-MENGE1 + <FS_QTY>-MENGE.
        ENDIF.
      ENDLOOP.
      WA_QTY-MATNR = <FS_QTY>-MATNR.
      WA_QTY-SHKZG = <FS_QTY>-SHKZG.
      APPEND WA_QTY TO IT_QTY.
      CLEAR WA_QTY.
    ENDON.
  ENDLOOP.

  SELECT MATNR,""""
           WERKS,
           MENGE,
           SHKZG,
           MBLNR,
           ZEILE
      FROM MSEG
      INTO TABLE @DATA(IT_ISS)
      WHERE MATNR IN @S_MATNR
      AND   WERKS IN @S_WERKS
      AND   BUDAT_MKPF EQ @S_BUDAT-LOW
      AND   BUSTW NE ''.
DELETE IT_ISS WHERE ( WERKS = 'PL01' OR WERKS = 'SU01').
  LOOP AT IT_ISS ASSIGNING FIELD-SYMBOL(<FS_ISS>).
    ON CHANGE OF <FS_ISS>-MATNR.
      LOOP AT IT_ISS INTO <FS_ISS> WHERE MATNR = <FS_ISS>-MATNR.
        IF <FS_ISS>-SHKZG EQ 'S' .
          WA_ISS1-MENGE = WA_ISS1-MENGE + <FS_ISS>-MENGE.
        ELSEIF  <FS_ISS>-SHKZG EQ 'H' .
          WA_ISS1-MENGE1 = WA_ISS1-MENGE1 + <FS_ISS>-MENGE.
        ENDIF.
      ENDLOOP.
      WA_ISS1-MATNR = <FS_ISS>-MATNR.
      APPEND WA_ISS1 TO IT_ISS1.
      CLEAR WA_ISS1.
    ENDON.
  ENDLOOP.

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  BREAK-POINT.
    SELECT FROM MSEG AS A INNER JOIN MARA AS B
         ON A~MATNR EQ B~MATNR
       FIELDS A~MATNR,
              A~MBLNR,
              A~MJAHR,
              A~ZEILE,
              A~BWART,
              A~LGORT,
              A~WERKS,
              A~CPUDT_MKPF,
              A~CPUTM_MKPF,
              A~BUKRS,
              A~BUDAT_MKPF,
              A~SHKZG,
              A~MENGE,
              A~DMBTR,
              B~MTART,
              B~MATKL,
              B~BRAND,
              B~ZSERIES,
              B~ZSIZE
     WHERE A~MATNR IN @S_MATNR
     AND   A~WERKS IN @S_WERKS
*     AND   B~MTART IN @S_MTART  "AND  A~BWART NE 'UNBW'  " ON 06.09.2024
*      AND   B~MTART NE 'UNBW'
     INTO TABLE @DATA(IT_DATA).
DELETE IT_DATA WHERE ( WERKS = 'PL01' OR WERKS = 'SU01').
      IF IT_DATA IS INITIAL .
        SELECT FROM MSEG AS A INNER JOIN MARA AS B
    ON A~MATNR EQ B~MATNR
    FIELDS A~MATNR,
           A~MBLNR,
           A~MJAHR,
           A~ZEILE,
           A~BWART,
           A~LGORT,
           A~WERKS,
           A~CPUDT_MKPF,
           A~CPUTM_MKPF,
           A~BUKRS,
           A~BUDAT_MKPF,
           A~SHKZG,
           A~MENGE,
           A~DMBTR,
           B~MTART,
           B~MATKL,
           B~BRAND,
           B~ZSERIES,
           B~ZSIZE
    WHERE A~MATNR IN @S_MATNR
    AND   A~WERKS IN @S_WERKS
*    AND   B~MTART IN @S_MTART
*      AND   B~MTART  NE 'UNBW'
    AND   A~BUDAT_MKPF IN @S_BUDAT "AND A~BWART NE 'UNBW'
    INTO TABLE @IT_DATA.
      ENDIF.
DELETE IT_DATA WHERE ( WERKS = 'PL01' OR WERKS = 'SU01').
  SORT IT_DATA BY MATNR DESCENDING CPUDT_MKPF DESCENDING CPUTM_MKPF DESCENDING.
  DELETE ADJACENT DUPLICATES FROM IT_DATA COMPARING MATNR .
  SORT IT_DATA BY MATNR .
  DELETE ADJACENT DUPLICATES FROM IT_DATA COMPARING MATNR .

  SELECT WAERS,
         BUKRS
    FROM T001
    FOR ALL ENTRIES IN @IT_DATA
    WHERE BUKRS = @IT_DATA-BUKRS
    INTO TABLE @DATA(IT_T001).

  SELECT BWART,
         BTEXT
    FROM T156HT
    FOR ALL ENTRIES IN @IT_DATA
    WHERE BWART = @IT_DATA-BWART
    AND   SPRAS EQ 'E'
    INTO TABLE @DATA(IT_T156HT).

  SELECT MATNR,
         BWKEY,
         SALK3,
         LBKUM
    FROM MBEW
    FOR ALL ENTRIES IN @IT_DATA
    WHERE MATNR = @IT_DATA-MATNR
    AND   BWKEY = @IT_DATA-WERKS
    INTO TABLE @DATA(IT_MBEW).

  LOOP AT IT_DATA ASSIGNING FIELD-SYMBOL(<FS_DATA>).

    WA_FINAL-MATNR        =    <FS_DATA>-MATNR.
    WA_FINAL-WERKS        =    <FS_DATA>-WERKS.
    WA_FINAL-LGORT        =    <FS_DATA>-LGORT.
    WA_FINAL-MBLNR        =    <FS_DATA>-MBLNR.
    WA_FINAL-ZEILE        =    <FS_DATA>-ZEILE.
    WA_FINAL-BWART        =    <FS_DATA>-BWART.
    WA_FINAL-MTART        =    <FS_DATA>-MTART.
    IF WA_FINAL-MTART NE 'UNBW'.
    WA_FINAL-MATKL        =    <FS_DATA>-MATKL.
    WA_FINAL-BUDAT_MKPF   =    <FS_DATA>-BUDAT_MKPF.
************************************************  ADD BY SUPRIYA ON 09.09.2024
    DATA LV_BUDAT_MKPF TYPE  MSEG-BUDAT_MKPF.

    LV_BUDAT_MKPF  = <FS_DATA>-BUDAT_MKPF.
         CONCATENATE WA_FINAL-BUDAT_MKPF+4(2) WA_FINAL-BUDAT_MKPF+6(2)  WA_FINAL-BUDAT_MKPF+0(4)
                      INTO WA_FINAL-BUDAT_MKPF  SEPARATED BY '.'.

*************************************************
    WA_FINAL-BRAND        =    <FS_DATA>-BRAND.
    WA_FINAL-ZSERIES      =    <FS_DATA>-ZSERIES.
    WA_FINAL-ZSIZE        =    <FS_DATA>-ZSIZE.

    CLEAR :LV_YEAR,GV_YEAR,GV_YEAR1.
    CALL FUNCTION 'HR_SGPBS_YRS_MTHS_DAYS'
      EXPORTING
        BEG_DA     = LV_BUDAT_MKPF  "WA_FINAL-BUDAT_MKPF
        END_DA     = SY-DATUM
      IMPORTING
        NO_CAL_DAY = LV_DAYS
        NO_YEAR    = GV_YEAR.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.
    IF  SY-SUBRC = 0.
      LV_YEAR = GV_YEAR.
      WA_FINAL-AGEING =   LV_DAYS.
      GV_YEAR1 =   GV_YEAR + 1.
      CONCATENATE LV_YEAR ' Years to ' GV_YEAR1 INTO WA_FINAL-AGEING_DESC  .
    ENDIF.
******************************************************
          WA_FINAL-DT_BUDAT_LOW = S_BUDAT-LOW. " add by supriya on 05.09.2024

      CONCATENATE WA_FINAL-DT_BUDAT_LOW+4(2) WA_FINAL-DT_BUDAT_LOW+6(2)  WA_FINAL-DT_BUDAT_LOW+0(4)
                      INTO WA_FINAL-DT_BUDAT_LOW  SEPARATED BY '.'.

*         LV_BUDAT_LOW  TYPE MSEG-BUDAT_MKPF, " add by supriya on 05.09.2024
*          WA_FINAL-DT_BUDAT_HIGH = S_BUDAT[1]-HIGH.  " add by supriya on 05.09.2024
          WA_FINAL-DT_BUDAT_HIGH = S_BUDAT-HIGH.
       CONCATENATE WA_FINAL-DT_BUDAT_HIGH+4(2) WA_FINAL-DT_BUDAT_HIGH+6(2)  WA_FINAL-DT_BUDAT_HIGH+0(4)
                      INTO WA_FINAL-DT_BUDAT_HIGH  SEPARATED BY '.'.


***************************************************
    READ TABLE IT_T001 ASSIGNING FIELD-SYMBOL(<FS_T001>) INDEX 1 .
    IF  SY-SUBRC = 0.
      WA_FINAL-WAERS = <FS_T001>-WAERS.
    ENDIF.

    READ TABLE IT_T156HT ASSIGNING FIELD-SYMBOL(<FS_T156HT>) WITH KEY BWART = <FS_DATA>-BWART.
    IF SY-SUBRC = 0.
      WA_FINAL-BTEXT = <FS_T156HT>-BTEXT.
    ENDIF.

    IF LINE_EXISTS( IT_SUM_NEW[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ] ) .
      DATA(LV_SS) = IT_SUM_NEW[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ]-DMBTR.
    ENDIF.

    IF LINE_EXISTS( IT_SUM_NEW[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
      DATA(LV_HH) = IT_SUM_NEW[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-DMBTR.
    ENDIF.

    WA_FINAL-OP_VALUE = LV_SS - LV_HH.

    IF NOT S_BUDAT-LOW IS INITIAL AND S_BUDAT-HIGH IS INITIAL.                                """"""""""""""""""""""SINGLE DATE INSERTED

      READ TABLE IT_ISS1 INTO WA_ISS1 WITH KEY MATNR = <FS_DATA>-MATNR.
      IF SY-SUBRC = 0.
        WA_FINAL-MENGE1 = WA_ISS1-MENGE1.
        WA_FINAL-MENGE = WA_ISS1-MENGE.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW3[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
        WA_FINAL-ISS_VAL = IT_SUM_NEW3[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-DMBTR.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ] ) .
        DATA(LV_S) = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ]-MENGE.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
        DATA(LV_H) = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-MENGE.
      ENDIF.

      WA_FINAL-OP_STOCK =  LV_S - LV_H .

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ] ) .
        DATA(LV_S1) = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ]-DMBTR.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
        DATA(LV_H1) = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-DMBTR.
      ENDIF.

      WA_FINAL-OP_VALUE = LV_S1 - LV_H1.

      IF LINE_EXISTS( IT_SUM_NEW2[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ] ) .
        WA_FINAL-REC_VAL = IT_SUM_NEW2[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ]-DMBTR.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW2[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
        WA_FINAL-ISS_VAL = IT_SUM_NEW2[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-DMBTR.
      ENDIF.

      WA_FINAL-CL_VALUE =   WA_FINAL-OP_VALUE + WA_FINAL-REC_VAL - WA_FINAL-ISS_VAL.

      WA_FINAL-CL_STOCK = WA_FINAL-OP_STOCK + WA_FINAL-MENGE - WA_FINAL-MENGE1 .

    ELSEIF S_BUDAT-LOW IS NOT INITIAL AND S_BUDAT-HIGH IS NOT INITIAL.      """"""""""""""""""""""""BOTH DATES ENTERED

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ] ) .
        DATA(LV_1) = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ]-DMBTR.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
        DATA(LV_2) = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-DMBTR.
      ENDIF.

      WA_FINAL-OP_VALUE = LV_1 - LV_2.

      READ TABLE IT_SUM2 INTO WA_SUM2 WITH KEY MATNR = <FS_DATA>-MATNR SHKZG = 'H'.
      IF  SY-SUBRC = 0.
        WA_FINAL-MENGE1  = WA_SUM2-MENGE1.
        WA_FINAL-ISS_VAL = WA_SUM2-DMBTR.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW3[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ] ) .
        WA_FINAL-REC_VAL = IT_SUM_NEW3[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ]-DMBTR.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW3[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
        WA_FINAL-ISS_VAL = IT_SUM_NEW3[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-DMBTR.
      ENDIF.

      WA_FINAL-CL_VALUE = WA_FINAL-OP_VALUE + WA_FINAL-REC_VAL - WA_FINAL-ISS_VAL.

      READ TABLE IT_QTY_NEW INTO WA_QTY_NEW WITH KEY MATNR = <FS_DATA>-MATNR.
      IF SY-SUBRC = 0.
        WA_FINAL-MENGE  = WA_QTY_NEW-MENGE.
        WA_FINAL-MENGE1 = WA_QTY_NEW-MENGE1.
      ENDIF.

      READ TABLE IT_IS1 INTO WA_IS1 WITH KEY MATNR = <FS_DATA>-MATNR.
      IF SY-SUBRC = 0.
        DATA(LV_IS1) = WA_IS1-MENGE.
        DATA(LV_IS2) = WA_IS1-MENGE1.
      ENDIF.

      WA_FINAL-OP_STOCK = LV_IS1 - LV_IS2.

      WA_FINAL-CL_STOCK = WA_FINAL-OP_STOCK + WA_FINAL-MENGE - WA_FINAL-MENGE1 .

    ELSEIF S_BUDAT IS INITIAL.

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ] ) .
        WA_FINAL-REC_VAL = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'S' ]-DMBTR.
      ENDIF.

      IF LINE_EXISTS( IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ] ) .
        WA_FINAL-ISS_VAL = IT_SUM_NEW1[ MATNR = <FS_DATA>-MATNR SHKZG = 'H' ]-DMBTR.
      ENDIF.

      WA_FINAL-CL_VALUE = WA_FINAL-REC_VAL - WA_FINAL-ISS_VAL.

      READ TABLE IT_QTY INTO WA_QTY WITH KEY MATNR = <FS_DATA>-MATNR.
      IF SY-SUBRC = 0.
        WA_FINAL-MENGE  = WA_QTY-MENGE.
        WA_FINAL-MENGE1 = WA_QTY-MENGE1.
      ENDIF.

      WA_FINAL-CL_STOCK = WA_FINAL-MENGE - WA_FINAL-MENGE1.

    ENDIF.
******************************************************
*          WA_FINAL-DT_BUDAT_LOW = S_BUDAT-LOW. " add by supriya on 05.09.2024
**         LV_BUDAT_LOW  TYPE MSEG-BUDAT_MKPF, " add by supriya on 05.09.2024
**          WA_FINAL-DT_BUDAT_HIGH = S_BUDAT[1]-HIGH.  " add by supriya on 05.09.2024
*          WA_FINAL-DT_BUDAT_HIGH = S_BUDAT-HIGH.
****************************************************
    APPEND WA_FINAL TO IT_FINAL.

    CLEAR :WA_FINAL,LV_S,LV_H,LV_S1,LV_H1,LV_IS1,LV_IS2,LV_1,LV_2,LV_YEAR,GV_YEAR1. "add by supriya on 05 09 2024
  ENDIF.
  ENDLOOP.
*BREAK-POINT.
  PERFORM FCAT.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = FS_LAYOUT
      IT_FIELDCAT        = GT_FIELDCAT[]
    TABLES
      T_OUTTAB           = IT_FINAL.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN EQ 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF_DATE.
      IF WA_DOWN-REF_DATE IS NOT INITIAL.
        CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
                        INTO WA_DOWN-REF_DATE SEPARATED BY '-'.
       ENDIF.
      WA_DOWN-MATNR        =  WA_FINAL-MATNR  .
      WA_DOWN-WERKS        =  WA_FINAL-WERKS  .
      WA_DOWN-LGORT        =  WA_FINAL-LGORT  .
      WA_DOWN-MBLNR        =  WA_FINAL-MBLNR  .
      WA_DOWN-ZEILE        =  WA_FINAL-ZEILE  .
      WA_DOWN-BWART        =  WA_FINAL-BWART  .
      WA_DOWN-MTART        =  WA_FINAL-MTART  .
      WA_DOWN-MATKL        =  WA_FINAL-MATKL  .
      WA_DOWN-WAERS        =  WA_FINAL-WAERS.
****************************************************************
*      WA_DOWN-BUDAT_MKPF   =  WA_FINAL-BUDAT_MKPF.
     WA_DOWN-BUDAT_MKPF   = LV_BUDAT_MKPF.
     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LV_BUDAT_MKPF
        IMPORTING
          OUTPUT = WA_DOWN-BUDAT_MKPF .

      IF WA_DOWN-BUDAT_MKPF IS NOT INITIAL.
        CONCATENATE WA_DOWN-BUDAT_MKPF+0(2) WA_DOWN-BUDAT_MKPF+2(3) WA_DOWN-BUDAT_MKPF+5(4)
                        INTO WA_DOWN-BUDAT_MKPF SEPARATED BY '-'.
      ENDIF.
*************************************************************
      WA_DOWN-BRAND        =  WA_FINAL-BRAND  .
      WA_DOWN-ZSERIES      =  WA_FINAL-ZSERIES.
      WA_DOWN-ZSIZE        =  WA_FINAL-ZSIZE  .
      WA_DOWN-BTEXT        =  WA_FINAL-BTEXT.
      WA_DOWN-AGEING       =  WA_FINAL-AGEING  .
      WA_DOWN-AGEING_DESC  =  WA_FINAL-AGEING_DESC  .
************************************************* ADD BY SUPRIYA ON 05.09.2024
      WA_DOWN-DT_BUDAT_LOW =  S_BUDAT-LOW. "WA_FINAL-DT_BUDAT_LOW. "S_BUDAT-LOW.

       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = S_BUDAT-LOW
        IMPORTING
          OUTPUT = WA_DOWN-DT_BUDAT_LOW .

      IF WA_DOWN-DT_BUDAT_LOW IS NOT INITIAL.
        CONCATENATE WA_DOWN-DT_BUDAT_LOW+0(2) WA_DOWN-DT_BUDAT_LOW+2(3) WA_DOWN-DT_BUDAT_LOW+5(4)
                        INTO WA_DOWN-DT_BUDAT_LOW SEPARATED BY '-'.
      ENDIF.
***********************************************************
      WA_DOWN-DT_BUDAT_HIGH = S_BUDAT-HIGH .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = S_BUDAT-HIGH
        IMPORTING
          OUTPUT = WA_DOWN-DT_BUDAT_HIGH .

IF WA_DOWN-DT_BUDAT_HIGH IS NOT INITIAL.
        CONCATENATE WA_DOWN-DT_BUDAT_HIGH+0(2) WA_DOWN-DT_BUDAT_HIGH+2(3) WA_DOWN-DT_BUDAT_HIGH+5(4)
                        INTO WA_DOWN-DT_BUDAT_HIGH SEPARATED BY '-'.
ENDIF.

*************************************************
      WA_DOWN-OP_STOCK  = WA_FINAL-OP_STOCK.
      WA_DOWN-MENGE     = WA_FINAL-MENGE    .

DATA : GV_DOWN-MENGE TYPE string.
*          GV_DOWN-MENGE = WA_DOWN-MENGE .
*          GV_DOWN-MENGE  = REPLACE( val =   GV_DOWN-MENGE  sub = ',' with = '' ).
*          WA_DOWN-MENGE  = GV_DOWN-MENGE .

*  REPLACE ',' WITH ' ' INTO WA_DOWN-MENGE.
*          CONDENSE WA_DOWN-MENGE.


      WA_DOWN-MENGE1    = WA_FINAL-MENGE1   .

*DATA : GV_DOWN-MENGE1 TYPE string.
*          GV_DOWN-MENGE1 = WA_DOWN-MENGE1 .
*          GV_DOWN-MENGE1  = REPLACE( val =   GV_DOWN-MENGE1  sub = ',' with = '' ).
*          WA_DOWN-MENGE1  = GV_DOWN-MENGE1 .





      WA_DOWN-CL_STOCK  = WA_FINAL-CL_STOCK .

*DATA : GV_DOWN-CL_STOCK TYPE string.
*          GV_DOWN-CL_STOCK = WA_DOWN-CL_STOCK .
*          GV_DOWN-CL_STOCK  = REPLACE( val =   GV_DOWN-CL_STOCK  sub = ',' with = '' ).
*          WA_DOWN-CL_STOCK  = GV_DOWN-CL_STOCK .

*      WA_DOWN-OP_STOCK  = WA_FINAL-OP_STOCK .
      WA_DOWN-OP_VALUE  = WA_FINAL-OP_VALUE .
*      DATA : GV_DOWN-OP_VALUE TYPE string.
*          GV_DOWN-OP_VALUE = WA_DOWN-OP_VALUE .
*          GV_DOWN-OP_VALUE  = REPLACE( val =   GV_DOWN-OP_VALUE  sub = ',' with = '' ).
*          WA_DOWN-OP_VALUE  = GV_DOWN-OP_VALUE .

************************************************
      WA_DOWN-REC_VAL   = WA_FINAL-REC_VAL  .

*     DATA : GV_DOWN-REC_VAL TYPE string.
*          GV_DOWN-REC_VAL = WA_DOWN-REC_VAL .
*          GV_DOWN-REC_VAL  = REPLACE( val =   GV_DOWN-REC_VAL  sub = ',' with = '' ).
*          WA_DOWN-REC_VAL  = GV_DOWN-REC_VAL .

**********************************************************
      WA_DOWN-ISS_VAL   = WA_FINAL-ISS_VAL  .

*      DATA : GV_DOWN-ISS_VAL TYPE string.
*          GV_DOWN-ISS_VAL = WA_DOWN-ISS_VAL .
*          GV_DOWN-ISS_VAL  = REPLACE( val =   GV_DOWN-ISS_VAL  sub = ',' with = '' ).
*          WA_DOWN-ISS_VAL  = GV_DOWN-ISS_VAL .

*****************************************************

      WA_DOWN-CL_VALUE  = WA_FINAL-CL_VALUE .

*      DATA : GV_DOWN-CL_VALUE TYPE string.
*          GV_DOWN-CL_VALUE = WA_DOWN-CL_VALUE .
*          GV_DOWN-CL_VALUE  = REPLACE( val =   GV_DOWN-CL_VALUE  sub = ',' with = '' ).
*          WA_DOWN-CL_VALUE  = GV_DOWN-CL_VALUE .







*      WA_DOWN-STOCK     = WA_DOWN-STOCK    .
*      WA_DOWN-REC_QTY   = WA_DOWN-REC_QTY  .
*      WA_DOWN-ISS_QTY   = WA_DOWN-ISS_QTY  .



* *************************************************

*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = SY-DATUM
*        IMPORTING
*          OUTPUT = WA_DOWN-REF_DATE.
*      IF WA_DOWN-REF_DATE IS NOT INITIAL.
*        CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
*                        INTO WA_DOWN-REF_DATE SEPARATED BY '-'.
        WA_DOWN-REF_TIME = SY-UZEIT.
*      ENDIF.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      APPEND WA_DOWN TO IT_DOWN.

    ENDLOOP.

  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD1 .
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FCAT .

  REFRESH GT_FIELDCAT.
  PERFORM GT_FIELDCATLOG USING :
*         'MATNR'        'IT_FINAL'   'Material No.'          '1'  '15',
*         'WERKS'        'IT_FINAL'   'Plant'                 '2'  '5',
*         'LGORT'        'IT_FINAL'   'Storage Location'      '3'  '5',
*         'MBLNR'        'IT_FINAL'   'Material Doc.'         '4'  '8',
*         'ZEILE'        'IT_FINAL'   'Mat. Doc.Item'         '5'  '5',
*         'BWART'        'IT_FINAL'   'Mov Type'              '6'  '5',
*         'MTART'        'IT_FINAL'   'Material Type'         '7'  '8',
*         'MATKL'        'IT_FINAL'   'Material Group'        '8'  '8',
*         'WAERS'        'IT_FINAL'   'Currency'              '9'  '5',
*         'BUDAT_MKPF'   'IT_FINAL'   'Posting Date'          '10' '10',
*         'BRAND'        'IT_FINAL'   'Brand'                 '11' '4',
*         'ZSERIES'      'IT_FINAL'   'Series'                '12' '5',
*         'ZSIZE'        'IT_FINAL'   'Size'                  '13' '5',
*         'BTEXT'        'IT_FINAL'   'Mov type Desc'         '14' '15',
*         'AGEING'       'IT_FINAL'   'Ageing'                '15' '4',
*         'AGEING_DESC'  'IT_FINAL'   'Ageing Description'    '16' '10',
*         'MENGE'        'IT_FINAL'   'Total Receipt Qty'     '17' '10',
*         'MENGE1'       'IT_FINAL'   'Total Issue Qty'       '18' '10',
*         'CL_STOCK'     'IT_FINAL'   'Closing Stock'         '19' '10',
*         'OP_STOCK'     'IT_FINAL'   'Opening Stock'         '19' '10',
*         'OP_VALUE'     'IT_FINAL'   'Opening Value'         '19' '10',
*         'REC_VAL'      'IT_FINAL'   'Total Receipt Values'  '19' '10',
*         'ISS_VAL'      'IT_FINAL'   'Total Issue Values'    '19' '10',
*         'CL_VALUE'     'IT_FINAL'   'Closing Value'         '19' '10'.
***********************************************************************
         'MATNR'        'IT_FINAL'   'Material No.'          '1'  '15',
         'WERKS'        'IT_FINAL'   'Plant'                 '2'  '5',
         'LGORT'        'IT_FINAL'   'Storage Location'      '3'  '5',
         'MBLNR'        'IT_FINAL'   'Material Doc.'         '4'  '8',
         'ZEILE'        'IT_FINAL'   'Mat. Doc.Item'         '5'  '5',
         'BWART'        'IT_FINAL'   'Mov Type'              '6'  '5',
         'MTART'        'IT_FINAL'   'Material Type'         '7'  '8',
         'MATKL'        'IT_FINAL'   'Material Group'        '8'  '8',
         'WAERS'        'IT_FINAL'   'Currency'              '9'  '5',
         'BUDAT_MKPF'   'IT_FINAL'   'Posting Date'          '10' '10',
         'BRAND'        'IT_FINAL'   'Brand'                 '11' '4',
         'ZSERIES'      'IT_FINAL'   'Series'                '12' '5',
         'ZSIZE'        'IT_FINAL'   'Size'                  '13' '5',
         'BTEXT'        'IT_FINAL'   'Mov type Desc'         '14' '15',
         'AGEING'       'IT_FINAL'   'Ageing'                '15' '4',
         'AGEING_DESC'  'IT_FINAL'   'Ageing Description'    '16' '10',
         'DT_BUDAT_LOW' 'IT_FINAL'   'From Date'             '17' '10', "add by supriya on 05.09.2024
         'DT_BUDAT_HIGH' 'IT_FINAL'  'To Date'               '18' '10',"add by supriya on 05.09.2024
         'MENGE'        'IT_FINAL'   'Total Receipt Qty'     '19' '10',
         'MENGE1'       'IT_FINAL'   'Total Issue Qty'       '20' '10',
         'CL_STOCK'     'IT_FINAL'   'Closing Stock'         '21' '10',
         'OP_STOCK'     'IT_FINAL'   'Opening Stock'         '22' '10',
         'OP_VALUE'     'IT_FINAL'   'Opening Value'         '23' '10',
         'REC_VAL'      'IT_FINAL'   'Total Receipt Values'  '24' '10',
         'ISS_VAL'      'IT_FINAL'   'Total Issue Values'    '25' '10',
         'CL_VALUE'     'IT_FINAL'   'Closing Value'         '26' '10'.
ENDFORM.


FORM GT_FIELDCATLOG  USING    V1 V2 V3 V4 V5.

  GS_FIELDCAT-FIELDNAME   = V1.
  GS_FIELDCAT-TABNAME     = V2.
  GS_FIELDCAT-SELTEXT_L   = V3.
  GS_FIELDCAT-COL_POS     = V4.
  GS_FIELDCAT-OUTPUTLEN   = V5.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR  GS_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD1 .
TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: LV_FOLDER(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).


*   PERFORM NEW_FILE.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'

    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV. " add by supriya on 21.08.2024

  LV_FILE = 'ZUS_MB5B.TXT'.

  CONCATENATE P_FOLDER '\' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUS_MB5B.TXT DOWNLOAD STARTED ON', SY-DATUM, 'AT', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
    CLOSE DATASET LV_FULLFILE.
    CONCATENATE 'FILE' LV_FULLFILE 'DOWNLOADED' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.

FORM CVS_HEADER  USING    P_HD_CSV.   " ADD BY SUPRIYA ON 21.08.2024
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.


CONCATENATE  'Refreshed Date'
'Material No.'
'Plant'
'Storage Location'
'Material Doc.'
'Mat. Doc.Item'
'Mov Type'
'Material Type'
'Material Group'
'Currancy'
'Posting Date'
'Brand'
'Series'
'Size'
'Mov type Desc'
'Ageing'
'Ageing Description'
'From Date'  " add by supriya on 05.09.2024
'To Date'    " add by supriya on 05.09.2024
'Opening Stock'
'Total Receipt Qty'
'Total Issue Qty'
'Closing Stock'
*'Opening Stock'
'Opening Value'
'Total Receipt Values'
'Total Issue Values'
'Closing Value'
*'Refreshable Date'
'Refreshed Time'
              INTO P_HD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
