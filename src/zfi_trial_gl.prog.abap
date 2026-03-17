*&---------------------------------------------------------------------*
*& PRIMUSTECHSYS PVT LTD
*&---------------------------------------------------------------------*
*& Project Name : ZFI_TRIAL_GL
*& Functional Consultant : Priyanka Shelke
*& Devloped by : jYOTI maHAJAN
*& Created on :
*& Tcode : ZFI_TRIAL_GL
*&---------------------------------------------------------------------*

REPORT ZFI_TRIAL_GL.

TABLES : t001,bkpf,skb1,faglflexa.

TYPES: BEGIN OF ts_zfi_trial_gl,
         bukrs TYPE skb1-bukrs,
         saknr TYPE skb1-saknr,
       END OF ts_zfi_trial_gl.

TYPES: BEGIN OF ts_skb1,
         bukrs TYPE skb1-bukrs,
         saknr TYPE skb1-saknr,
       END OF ts_skb1.

TYPES : BEGIN OF ts_ska1,
          saknr          TYPE ska1-saknr,
          xbilk TYPE ska1-xbilk,
          gvtyp TYPE ska1-gvtyp,
*          glaccount_type TYPE ska1-saknr,
        END OF ts_ska1.

TYPES : BEGIN OF ts_faglflexa,
          prctr  TYPE faglflexa-prctr,
          rbukrs TYPE faglflexa-rbukrs,
          hsl    TYPE faglflexa-hsl,
          racct  TYPE faglflexa-racct,
           budat  TYPE faglflexa-budat,
        END OF ts_faglflexa.

tYPES : BEGIN OF TS_FAGLFLEXT,
        prctr TYPE faglflext-prctr,
        rbukrs TYPE faglflext-rbukrs,
        HSLVT TYPE faglflext-HSLVT,
        racct TYPE faglflext-racct,
        END OF TS_FAGLFLEXT.

TYPES : BEGIN OF gty_final,
          bukrs    TYPE skb1-bukrs,
          saknr    TYPE skb1-saknr,
          txt50    TYPE skat-txt50,
          prctr    TYPE faglflexa-prctr,
          0301_rp  TYPE faglflexa-hsl,
          0301_cp  TYPE faglflexa-hsl,
          0302_rp  TYPE faglflexa-hsl,
          0302_cp  TYPE faglflexa-hsl,
          0401_rp  TYPE faglflexa-hsl,
          0401_cp  TYPE faglflexa-hsl,
          0501_rp  TYPE faglflexa-hsl,
          0501_cp  TYPE faglflexa-hsl,
          0601_rp  TYPE faglflexa-hsl,
          0601_cp  TYPE faglflexa-hsl,
          0602_rp  TYPE faglflexa-hsl,
          0602_cp  TYPE faglflexa-hsl,
          0603_rp  TYPE faglflexa-hsl,
          0603_cp  TYPE faglflexa-hsl,
          0701_rp  TYPE faglflexa-hsl,
          0701_cp  TYPE faglflexa-hsl,
          0702_rp  TYPE faglflexa-hsl,
          0702_cp  TYPE faglflexa-hsl,
          0703_rp  TYPE faglflexa-hsl,
          0703_cp  TYPE faglflexa-hsl,
          0704_rp  TYPE faglflexa-hsl,
          0704_cp  TYPE faglflexa-hsl,
          0801_rp  TYPE faglflexa-hsl,
          0801_cp  TYPE faglflexa-hsl,
          0802_rp  TYPE faglflexa-hsl,
          0802_cp  TYPE faglflexa-hsl,
          0803_rp  TYPE faglflexa-hsl,
          0803_cp  TYPE faglflexa-hsl,
          0901_rp  TYPE faglflexa-hsl,
          0901_cp  TYPE faglflexa-hsl,
          0902_rp  TYPE faglflexa-hsl,
          0902_cp  TYPE faglflexa-hsl,
          0903_rp  TYPE faglflexa-hsl,
          0903_cp  TYPE faglflexa-hsl,
          0904_rp  TYPE faglflexa-hsl,
          0904_cp  TYPE faglflexa-hsl,
          0905_rp  TYPE faglflexa-hsl,
          0905_cp  TYPE faglflexa-hsl,
          1801_rp  TYPE faglflexa-hsl,
          1801_cp  TYPE faglflexa-hsl,
          1901_rp  TYPE faglflexa-hsl,
          1901_cp  TYPE faglflexa-hsl,
          1902_rp  TYPE faglflexa-hsl,
          1902_cp  TYPE faglflexa-hsl,
          2101_rp  TYPE faglflexa-hsl,
          2101_cp  TYPE faglflexa-hsl,
          2102_rp  TYPE faglflexa-hsl,
          2102_cp  TYPE faglflexa-hsl,
          2201_rp  TYPE faglflexa-hsl,
          2201_cp  TYPE faglflexa-hsl,
          2202_rp  TYPE faglflexa-hsl,
          2202_cp  TYPE faglflexa-hsl,
          2301_rp  TYPE faglflexa-hsl,
          2301_cp  TYPE faglflexa-hsl,
          2302_rp  TYPE faglflexa-hsl,
          2302_cp  TYPE faglflexa-hsl,
          2303_rp  TYPE faglflexa-hsl,
          2303_cp  TYPE faglflexa-hsl,
          2304_rp  TYPE faglflexa-hsl,
          2304_cp  TYPE faglflexa-hsl,
          2351_rp  TYPE faglflexa-hsl,
          2351_cp  TYPE faglflexa-hsl,
          2401_rp  TYPE faglflexa-hsl,
          2401_cp  TYPE faglflexa-hsl,
          2402_rp  TYPE faglflexa-hsl,
          2402_cp  TYPE faglflexa-hsl,
          2403_rp  TYPE faglflexa-hsl,
          2403_cp  TYPE faglflexa-hsl,
          2404_rp  TYPE faglflexa-hsl,
          2404_cp  TYPE faglflexa-hsl,
          2405_rp  TYPE faglflexa-hsl,
          2405_cp  TYPE faglflexa-hsl,
          2406_rp  TYPE faglflexa-hsl,
          2406_cp  TYPE faglflexa-hsl,
          2407_rp  TYPE faglflexa-hsl,
          2407_cp  TYPE faglflexa-hsl,
          2408_rp  TYPE faglflexa-hsl,
          2408_cp  TYPE faglflexa-hsl,
          2451_rp  TYPE faglflexa-hsl,
          2451_cp  TYPE faglflexa-hsl,
          2452_rp  TYPE faglflexa-hsl,
          2452_cp  TYPE faglflexa-hsl,
          2453_rp  TYPE faglflexa-hsl,
          2453_cp  TYPE faglflexa-hsl,
          2454_rp  TYPE faglflexa-hsl,
          2454_cp  TYPE faglflexa-hsl,
          2455_rp  TYPE faglflexa-hsl,
          2455_cp  TYPE faglflexa-hsl,
          2456_rp  TYPE faglflexa-hsl,
          2456_cp  TYPE faglflexa-hsl,
          2457_rp  TYPE faglflexa-hsl,
          2457_cp  TYPE faglflexa-hsl,
          2458_rp  TYPE faglflexa-hsl,
          2458_cp  TYPE faglflexa-hsl,
          2459_rp  TYPE faglflexa-hsl,
          2459_cp  TYPE faglflexa-hsl,
          2701_rp  TYPE faglflexa-hsl,
          2701_cp  TYPE faglflexa-hsl,
          2702_rp  TYPE faglflexa-hsl,
          2702_cp  TYPE faglflexa-hsl,
          2703_rp  TYPE faglflexa-hsl,
          2703_cp  TYPE faglflexa-hsl,
          2704_rp  TYPE faglflexa-hsl,
          2704_cp  TYPE faglflexa-hsl,
          2705_rp  TYPE faglflexa-hsl,
          2705_cp  TYPE faglflexa-hsl,
          2706_rp  TYPE faglflexa-hsl,
          2706_cp  TYPE faglflexa-hsl,
          2707_rp  TYPE faglflexa-hsl,
          2707_cp  TYPE faglflexa-hsl,
          2711_rp  TYPE faglflexa-hsl,
          2711_cp  TYPE faglflexa-hsl,
          2712_rp  TYPE faglflexa-hsl,
          2712_cp  TYPE faglflexa-hsl,
          2713_rp  TYPE faglflexa-hsl,
          2713_cp  TYPE faglflexa-hsl,
          2714_rp  TYPE faglflexa-hsl,
          2714_cp  TYPE faglflexa-hsl,
          2715_rp  TYPE faglflexa-hsl,
          2715_cp  TYPE faglflexa-hsl,
          2716_rp  TYPE faglflexa-hsl,
          2716_cp  TYPE faglflexa-hsl,
          2717_rp  TYPE faglflexa-hsl,
          2717_cp  TYPE faglflexa-hsl,
          2718_rp  TYPE faglflexa-hsl,
          2718_cp  TYPE faglflexa-hsl,
          2719_rp  TYPE faglflexa-hsl,
          2719_cp  TYPE faglflexa-hsl,
          2720_rp  TYPE faglflexa-hsl,
          2720_cp  TYPE faglflexa-hsl,
          2721_rp  TYPE faglflexa-hsl,
          2721_cp  TYPE faglflexa-hsl,
          2722_rp  TYPE faglflexa-hsl,
          2722_cp  TYPE faglflexa-hsl,
          2723_rp  TYPE faglflexa-hsl,
          2723_cp  TYPE faglflexa-hsl,
          2724_rp  TYPE faglflexa-hsl,
          2724_cp  TYPE faglflexa-hsl,
          2725_rp  TYPE faglflexa-hsl,
          2725_cp  TYPE faglflexa-hsl,
          2726_rp  TYPE faglflexa-hsl,
          2726_cp  TYPE faglflexa-hsl,
          2727_rp  TYPE faglflexa-hsl,
          2727_cp  TYPE faglflexa-hsl,
          2728_rp  TYPE faglflexa-hsl,
          2728_cp  TYPE faglflexa-hsl,
          2729_rp  TYPE faglflexa-hsl,
          2729_cp  TYPE faglflexa-hsl,
          2730_rp  TYPE faglflexa-hsl,
          2730_cp  TYPE faglflexa-hsl,
          2731_rp  TYPE faglflexa-hsl,
          2731_cp  TYPE faglflexa-hsl,
          2751_rp  TYPE faglflexa-hsl,
          2751_cp  TYPE faglflexa-hsl,
          2752_rp  TYPE faglflexa-hsl,
          2752_cp  TYPE faglflexa-hsl,
          2753_rp  TYPE faglflexa-hsl,
          2753_cp  TYPE faglflexa-hsl,
          2754_rp  TYPE faglflexa-hsl,
          2754_cp  TYPE faglflexa-hsl,
          2755_rp  TYPE faglflexa-hsl,
          2755_cp  TYPE faglflexa-hsl,
          2756_rp  TYPE faglflexa-hsl,
          2756_cp  TYPE faglflexa-hsl,
          2757_rp  TYPE faglflexa-hsl,
          2757_cp  TYPE faglflexa-hsl,
          2758_rp  TYPE faglflexa-hsl,
          2758_cp  TYPE faglflexa-hsl,
          2759_rp  TYPE faglflexa-hsl,
          2759_cp  TYPE faglflexa-hsl,
          2760_rp  TYPE faglflexa-hsl,
          2760_cp  TYPE faglflexa-hsl,
          2901_rp  TYPE faglflexa-hsl,
          2901_cp  TYPE faglflexa-hsl,
          2902_rp  TYPE faglflexa-hsl,
          2902_cp  TYPE faglflexa-hsl,
          2903_rp  TYPE faglflexa-hsl,
          2903_cp  TYPE faglflexa-hsl,
          2904_rp  TYPE faglflexa-hsl,
          2904_cp  TYPE faglflexa-hsl,
          2905_rp  TYPE faglflexa-hsl,
          2905_cp  TYPE faglflexa-hsl,
          2906_rp  TYPE faglflexa-hsl,
          2906_cp  TYPE faglflexa-hsl,
          2951_rp  TYPE faglflexa-hsl,
          2951_cp  TYPE faglflexa-hsl,
          2952_rp  TYPE faglflexa-hsl,
          2952_cp  TYPE faglflexa-hsl,
          2953_rp  TYPE faglflexa-hsl,
          2953_cp  TYPE faglflexa-hsl,
          2954_rp  TYPE faglflexa-hsl,
          2954_cp  TYPE faglflexa-hsl,
          2955_rp  TYPE faglflexa-hsl,
          2955_cp  TYPE faglflexa-hsl,
          2956_rp  TYPE faglflexa-hsl,
          2956_cp  TYPE faglflexa-hsl,
          2957_rp  TYPE faglflexa-hsl,
          2957_cp  TYPE faglflexa-hsl,
          2958_rp  TYPE faglflexa-hsl,
          2958_cp  TYPE faglflexa-hsl,
          2959_rp  TYPE faglflexa-hsl,
          2959_cp  TYPE faglflexa-hsl,
          2960_rp  TYPE faglflexa-hsl,
          2960_cp  TYPE faglflexa-hsl,
          2961_rp  TYPE faglflexa-hsl,
          2961_cp  TYPE faglflexa-hsl,
          2962_rp  TYPE faglflexa-hsl,
          2962_cp  TYPE faglflexa-hsl,
          2963_rp  TYPE faglflexa-hsl,
          2963_cp  TYPE faglflexa-hsl,
          2964_rp  TYPE faglflexa-hsl,
          2964_cp  TYPE faglflexa-hsl,
          3001_rp  TYPE faglflexa-hsl,
          3001_cp  TYPE faglflexa-hsl,
          1903_cp  TYPE faglflexa-hsl,
          3002_rp  TYPE faglflexa-hsl,
          3002_cp  TYPE faglflexa-hsl,
          3201_rp  TYPE faglflexa-hsl,
          3201_cp  TYPE faglflexa-hsl,
          3202_rp  TYPE faglflexa-hsl,
          3202_cp  TYPE faglflexa-hsl,
          3203_rp  TYPE faglflexa-hsl,
          3203_cp  TYPE faglflexa-hsl,
          3204_rp  TYPE faglflexa-hsl,
          3204_cp  TYPE faglflexa-hsl,
          3205_rp  TYPE faglflexa-hsl,
          3205_cp  TYPE faglflexa-hsl,
          3251_rp  TYPE faglflexa-hsl,
          3251_cp  TYPE faglflexa-hsl,
          3252_rp  TYPE faglflexa-hsl,
          3252_cp  TYPE faglflexa-hsl,
          3301_rp  TYPE faglflexa-hsl,
          3301_cp  TYPE faglflexa-hsl,
          3302_rp  TYPE faglflexa-hsl,
          3302_cp  TYPE faglflexa-hsl,
          3303_rp  TYPE faglflexa-hsl,
          3303_cp  TYPE faglflexa-hsl,
          3304_rp  TYPE faglflexa-hsl,
          3304_cp  TYPE faglflexa-hsl,
          3351_rp  TYPE faglflexa-hsl,
          3351_cp  TYPE faglflexa-hsl,
          3352_rp  TYPE faglflexa-hsl,
          3352_cp  TYPE faglflexa-hsl,
          3353_rp  TYPE faglflexa-hsl,
          3353_cp  TYPE faglflexa-hsl,
          3354_rp  TYPE faglflexa-hsl,
          3354_cp  TYPE faglflexa-hsl,
          3355_rp  TYPE faglflexa-hsl,
          3355_cp  TYPE faglflexa-hsl,
          3356_rp  TYPE faglflexa-hsl,
          3356_cp  TYPE faglflexa-hsl,
          3357_rp  TYPE faglflexa-hsl,
          3357_cp  TYPE faglflexa-hsl,
          3358_rp  TYPE faglflexa-hsl,
          3358_cp  TYPE faglflexa-hsl,
          3359_rp  TYPE faglflexa-hsl,
          3359_cp  TYPE faglflexa-hsl,
          3360_rp  TYPE faglflexa-hsl,
          3360_cp  TYPE faglflexa-hsl,
          3361_rp  TYPE faglflexa-hsl,
          3361_cp  TYPE faglflexa-hsl,
          3400_rp  TYPE faglflexa-hsl,
          3400_cp  TYPE faglflexa-hsl,
          3451_rp  TYPE faglflexa-hsl,
          3451_cp  TYPE faglflexa-hsl,
          3601_rp  TYPE faglflexa-hsl,
          3601_cp  TYPE faglflexa-hsl,
          3602_rp  TYPE faglflexa-hsl,
          3602_cp  TYPE faglflexa-hsl,
          3603_rp  TYPE faglflexa-hsl,
          3603_cp  TYPE faglflexa-hsl,
          3604_rp  TYPE faglflexa-hsl,
          3604_cp  TYPE faglflexa-hsl,
          3605_rp  TYPE faglflexa-hsl,
          3605_cp  TYPE faglflexa-hsl,
          3651_rp  TYPE faglflexa-hsl,
          3651_cp  TYPE faglflexa-hsl,
          3652_rp  TYPE faglflexa-hsl,
          3652_cp  TYPE faglflexa-hsl,
          3653_rp  TYPE faglflexa-hsl,
          3653_cp  TYPE faglflexa-hsl,
          3701_rp  TYPE faglflexa-hsl,
          3701_cp  TYPE faglflexa-hsl,
          3702_rp  TYPE faglflexa-hsl,
          3702_cp  TYPE faglflexa-hsl,
          3703_rp  TYPE faglflexa-hsl,
          3703_cp  TYPE faglflexa-hsl,
          3704_rp  TYPE faglflexa-hsl,
          3704_cp  TYPE faglflexa-hsl,
          3705_rp  TYPE faglflexa-hsl,
          3705_cp  TYPE faglflexa-hsl,
          3706_rp  TYPE faglflexa-hsl,
          3706_cp  TYPE faglflexa-hsl,
          3707_rp  TYPE faglflexa-hsl,
          3707_cp  TYPE faglflexa-hsl,
          3751_rp  TYPE faglflexa-hsl,
          3751_cp  TYPE faglflexa-hsl,
          total_rp TYPE faglflexa-hsl,
          total_cp TYPE faglflexa-hsl,
        END OF gty_final.

DATA : it_fieldcat     TYPE slis_t_fieldcat_alv,
       wa_fieldcat     TYPE slis_fieldcat_alv,
       ls_layout       TYPE slis_layout_alv,
       lt_final        TYPE TABLE OF gty_final,
       lt_final_1      TYPE TABLE OF gty_final,
       ls_final        TYPE gty_final,
       ls_final_1      TYPE gty_final,
       lt_zfi_trial_gl TYPE TABLE OF ts_zfi_trial_gl,
       ls_zfi_trial_gl TYPE ts_zfi_trial_gl,
       lt_skb1         TYPE TABLE OF ts_skb1,
       ls_skb1         TYPE ts_skb1,
       lt_skat         TYPE TABLE OF skat,
       ls_skat         TYPE skat,
       lt_rp           TYPE TABLE OF ts_faglflexa,
       ls_rp           TYPE ts_faglflexa,
       lt_cp           TYPE TABLE OF ts_faglflexa,
       ls_cp           TYPE ts_faglflexa,
       lt_rp1          TYPE TABLE OF ts_faglflexa,
       ls_rp1          TYPE ts_faglflexa,
       lt_cp1          TYPE TABLE OF ts_faglflexa,
       ls_cp1          TYPE ts_faglflexa,
       lt_rp2          TYPE TABLE OF ts_faglflexa,
       ls_rp2          TYPE ts_faglflexa,
       lt_rp2_1          TYPE TABLE OF ts_FAGLFLEXT,
       ls_rp2_1          TYPE ts_FAGLFLEXT,
       lt_cp2          TYPE TABLE OF ts_faglflexa,
       ls_cp2          TYPE ts_faglflexa,
         lt_cp2_1          TYPE TABLE OF ts_FAGLFLEXT,
       ls_cp2_1          TYPE ts_FAGLFLEXT,
       lt_t001         TYPE TABLE OF t001,
       ls_t001         TYPE t001,
       lt_ska1         TYPE TABLE OF ts_ska1,
       ls_ska1         TYPE ts_ska1,
       lt_ska1_1       TYPE TABLE OF ts_ska1,
       ls_ska1_1       TYPE ts_ska1.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_ccode FOR t001-bukrs OBLIGATORY,
                 s_prctr FOR faglflexa-prctr,
                 s_date  FOR bkpf-budat,
                 s_date1 FOR bkpf-budat,
                 s_gl    FOR skb1-saknr.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM display_alv.
  PERFORM top-of-page.
*&---------------------------------------------------------------------*
*& Form FETCH_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fetch_data .

*  SELECT * FROM zfi_trial_gl
*            INTO CORRESPONDING FIELDS OF TABLE lt_zfi_trial_gl.
*break primusabap.
  SELECT bukrs
         saknr
         FROM skb1
         INTO CORRESPONDING FIELDS OF TABLE lt_skb1
         WHERE bukrs IN s_ccode
         AND saknr IN s_gl.

  SELECT saknr
         xbilk
         gvtyp
*        glaccount_type
    FROM ska1
    INTO TABLE lt_ska1
    FOR ALL ENTRIES IN lt_skb1
    WHERE saknr = lt_skb1-saknr
    AND xbilk = 'X'.
*    AND glaccount_type = 'X'.

  SELECT saknr
       xbilk
       gvtyp
*    glaccount_type
    FROM ska1
    INTO TABLE lt_ska1_1
    FOR ALL ENTRIES IN lt_skb1
     WHERE saknr = lt_skb1-saknr.
.


  LOOP AT lt_ska1 INTO ls_ska1.

    DELETE lt_skb1 WHERE saknr = ls_ska1-saknr .
  ENDLOOP.
*  LOOP AT lt_skb1 INTO ls_skb1.
*    DELETE lt_ska1 WHERE saknr = ls_skb1-saknr .
*  ENDLOOP.

*
  DELETE lt_ska1 WHERE saknr = '0000200040' .""or saknr = '0000240040' .
  DELETE lt_ska1_1 WHERE saknr NE '0000200040'. " and saknr NE '0000240040' ).


  IF s_date IS NOT INITIAL.
    IF lt_skb1 IS NOT INITIAL .
      SELECT *
           FROM faglflexa
           INTO CORRESPONDING FIELDS OF TABLE lt_rp
           FOR ALL ENTRIES IN lt_skb1
           WHERE racct EQ lt_skb1-saknr
           AND rbukrs IN s_ccode
           AND prctr IN s_prctr
           AND budat IN s_date.
    ENDIF.


    IF lt_ska1 IS NOT INITIAL.
      SELECT *
        FROM faglflexa
         INTO CORRESPONDING FIELDS OF TABLE lt_rp1
         FOR ALL ENTRIES IN lt_ska1
         WHERE racct EQ lt_ska1-saknr
         AND rbukrs IN s_ccode
         AND prctr IN s_prctr
         AND budat <= s_date-high.

      DELETE lt_rp1 WHERE budat = '00000000'.
    ENDIF.

    IF lt_ska1_1 IS NOT INITIAL.
      DATA : year TYPE faglflexa-ryear.
      year = s_date-low+00(04).

      SELECT *
        FROM faglflexa
         INTO CORRESPONDING FIELDS OF TABLE lt_rp2
         FOR ALL ENTRIES IN lt_ska1_1
         WHERE racct EQ lt_ska1_1-saknr
         AND rbukrs IN s_ccode
         AND prctr IN s_prctr
         AND ryear = year.
        if lt_rp2 is INITIAL.

       select *
         from FAGLFLEXT
          INTO CORRESPONDING FIELDS OF TABLE lt_rp2_1
         FOR ALL ENTRIES IN lt_ska1_1
           WHERE racct EQ lt_ska1_1-saknr
         AND rbukrs IN s_ccode
         AND prctr IN s_prctr
         AND ryear = year.


        endif.
    ENDIF.
  ENDIF.

  IF s_date1 IS NOT INITIAL.
    IF lt_skb1 IS NOT INITIAL.
      SELECT *
          FROM faglflexa
          INTO CORRESPONDING FIELDS OF TABLE lt_cp
          FOR ALL ENTRIES IN lt_skb1
          WHERE racct EQ lt_skb1-saknr
          AND rbukrs IN s_ccode
          AND prctr IN s_prctr
          AND budat IN s_date1.
    ENDIF.

    IF lt_ska1 IS NOT INITIAL.
      SELECT *
               FROM faglflexa
                INTO CORRESPONDING FIELDS OF TABLE lt_cp1
                FOR ALL ENTRIES IN lt_ska1
                WHERE racct EQ lt_ska1-saknr
                AND rbukrs IN s_ccode
                AND prctr IN s_prctr
                AND budat <= s_date1-high.

      DELETE lt_cp1 WHERE budat = '00000000'.
    ENDIF.

    IF lt_ska1_1 IS NOT INITIAL.

      DATA : year1 TYPE faglflexa-ryear.
      year1 = s_date1-low+00(04).

      SELECT *
        FROM faglflexa
         INTO CORRESPONDING FIELDS OF TABLE lt_cp2
         FOR ALL ENTRIES IN lt_ska1_1
         WHERE racct EQ lt_ska1_1-saknr
         AND rbukrs IN s_ccode
         AND prctr IN s_prctr
         AND ryear = year1.

         if lt_cp2 is INITIAL.

       select *
         from FAGLFLEXT
          INTO CORRESPONDING FIELDS OF TABLE lt_cp2_1
         FOR ALL ENTRIES IN lt_ska1_1
           WHERE racct EQ lt_ska1_1-saknr
         AND rbukrs IN s_ccode
         AND prctr IN s_prctr
         AND ryear = year1.


        endif.

    ENDIF.

  ENDIF.


  SELECT *
    FROM t001
      INTO TABLE lt_t001
      WHERE bukrs IN s_ccode.


  IF lt_t001[] IS NOT INITIAL.

    SELECT *
      FROM skat
      INTO TABLE lt_skat
      FOR ALL ENTRIES IN lt_t001
      WHERE ktopl EQ lt_t001-ktopl
      AND saknr  IN s_gl.

  ENDIF.

  IF lt_skb1 IS NOT INITIAL.
    LOOP AT lt_skb1 INTO ls_skb1.
      ls_final-saknr  = ls_skb1-saknr.
      ls_final-bukrs  = ls_skb1-bukrs.

      READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_final-saknr.
      ls_final-txt50  = ls_skat-txt50.
*break primusabap.
      LOOP AT lt_rp INTO ls_rp WHERE racct = ls_final-saknr.
        DATA : lv_prctr TYPE char10.
*        DATA : lv_prctr TYPE char10.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_rp-prctr
          IMPORTING
            output = lv_prctr.
*        ls_final-prctr = lv_prctr.
*        lv_prctr = ls_rp-prctr.
         SHIFT lv_prctr LEFT DELETING LEADING '0'.
        ls_final-prctr = lv_prctr.

        IF lv_prctr = '101010'.
          ls_final-0301_rp = ls_final-0301_rp + ls_rp-hsl.
        ELSEIF lv_prctr = '101020'.
          ls_final-0302_rp = ls_final-0302_rp + ls_rp-hsl.
        ELSEIF lv_prctr = '102010'.
          ls_final-0401_rp = ls_final-0401_rp + ls_rp-hsl.
        ELSEIF lv_prctr = '102020'.
          ls_final-0501_rp = ls_final-0501_rp + ls_rp-hsl.
        ELSEIF lv_prctr = '103010'.
          ls_final-0601_rp = ls_final-0601_rp + ls_rp-hsl.
        ELSEIF lv_prctr = '200010'.
          ls_final-0602_rp = ls_final-0602_rp + ls_rp-hsl.
        ELSEIF lv_prctr = '200020'.
          ls_final-0603_rp = ls_final-0603_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'DUMMY_DELV'.
          ls_final-0701_rp = ls_final-0701_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'HU01-DUMMY'.
          ls_final-0702_rp = ls_final-0702_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_01'.
          ls_final-0703_rp = ls_final-0703_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_02'.
          ls_final-0704_rp = ls_final-0704_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_03'.
          ls_final-0801_rp = ls_final-0801_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_04'.
          ls_final-0802_rp = ls_final-0802_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_05'.
          ls_final-0803_rp = ls_final-0803_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_06'.
          ls_final-0901_rp = ls_final-0901_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_07'.
          ls_final-0902_rp = ls_final-0902_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_08'.
          ls_final-0903_rp = ls_final-0903_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_09'.
          ls_final-0904_rp = ls_final-0904_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_10'.
          ls_final-0905_rp = ls_final-0905_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS01_11'.
          ls_final-1801_rp = ls_final-1801_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_01'.
          ls_final-1901_rp = ls_final-1901_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_02'.
          ls_final-1902_rp = ls_final-1902_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_03'.
          ls_final-2101_rp = ls_final-2101_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_04'.
          ls_final-2102_rp = ls_final-2102_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_05'.
          ls_final-2201_rp = ls_final-2201_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_06'.
          ls_final-2202_rp = ls_final-2202_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_07'.
          ls_final-2301_rp = ls_final-2301_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_08'.
          ls_final-2302_rp = ls_final-2302_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_09'.
          ls_final-2303_rp = ls_final-2303_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_10'.
          ls_final-2304_rp = ls_final-2304_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS02_11'.
          ls_final-2351_rp = ls_final-2351_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_01'.
          ls_final-2401_rp = ls_final-2401_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_02'.
          ls_final-2402_rp = ls_final-2402_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_03'.
          ls_final-2403_rp = ls_final-2403_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_04'.
          ls_final-2404_rp = ls_final-2404_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_05'.
          ls_final-2405_rp = ls_final-2405_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_06'.
          ls_final-2406_rp = ls_final-2406_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_07'.
          ls_final-2407_rp = ls_final-2407_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_08'.
          ls_final-2408_rp = ls_final-2408_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_09'.
          ls_final-2451_rp = ls_final-2451_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_10'.
          ls_final-2452_rp = ls_final-2452_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'PRUS03_11'.
          ls_final-2453_rp = ls_final-2453_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'RECO-DUMMY'.
          ls_final-2454_rp = ls_final-2454_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SAP-DUMMY'.
          ls_final-2455_rp = ls_final-2455_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SU1010'.
          ls_final-2456_rp = ls_final-2456_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SU1020'.
          ls_final-2457_rp = ls_final-2457_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SU2010'.
          ls_final-2458_rp = ls_final-2458_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SU2020'.
          ls_final-2459_rp = ls_final-2459_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SU3010'.
          ls_final-2701_rp = ls_final-2701_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SU4000'.
          ls_final-2702_rp = ls_final-2702_rp + ls_rp-hsl.
        ELSEIF lv_prctr = 'SU5000'.
          ls_final-2703_rp = ls_final-2703_rp + ls_rp-hsl.
        ENDIF.

        ls_final-total_rp =  ls_final-0301_rp +  ls_final-0401_rp +  ls_final-0601_rp +  ls_final-0602_rp +  ls_final-0701_rp +  ls_final-0702_rp +  ls_final-0703_rp +  ls_final-0801_rp +  ls_final-0802_rp + ls_final-0803_rp
        +  ls_final-0901_rp +  ls_final-0902_rp +  ls_final-0903_rp +  ls_final-0904_rp +  ls_final-0905_rp +  ls_final-1801_rp + ls_final-1901_rp +  ls_final-1902_rp +  ls_final-2101_rp +  ls_final-2201_rp +  ls_final-2301_rp
        +  ls_final-2302_rp +  ls_final-2303_rp +  ls_final-2304_rp +  ls_final-2351_rp +  ls_final-2401_rp +  ls_final-2402_rp +  ls_final-2403_rp +  ls_final-2404_rp +  ls_final-2405_rp +  ls_final-2406_rp +  ls_final-2407_rp
        +  ls_final-2408_rp +  ls_final-2451_rp +  ls_final-2452_rp +  ls_final-2453_rp +  ls_final-2454_rp +  ls_final-2455_rp +  ls_final-2456_rp +  ls_final-2457_rp +  ls_final-2458_rp +  ls_final-2459_rp +  ls_final-2701_rp
        +  ls_final-2702_rp +  ls_final-2703_rp +  ls_final-2704_rp +  ls_final-2705_rp +  ls_final-2706_rp +  ls_final-2707_rp +  ls_final-2711_rp +  ls_final-2712_rp +  ls_final-2713_rp +  ls_final-2714_rp +  ls_final-2715_rp
        +  ls_final-2716_rp +  ls_final-2717_rp +  ls_final-2718_rp +  ls_final-2719_rp +  ls_final-2720_rp +  ls_final-2721_rp + ls_final-2722_rp +  ls_final-2723_rp +  ls_final-2724_rp +  ls_final-2725_rp +  ls_final-2726_rp
        +  ls_final-2727_rp +  ls_final-2728_rp +  ls_final-2729_rp +  ls_final-2730_rp +  ls_final-2731_rp +  ls_final-2751_rp +  ls_final-2752_rp +  ls_final-2753_rp +  ls_final-2754_rp +  ls_final-2755_rp + ls_final-2756_rp
        +  ls_final-2757_rp +  ls_final-2758_rp +  ls_final-2759_rp +  ls_final-2760_rp +  ls_final-2901_rp +  ls_final-2902_rp + ls_final-2903_rp +  ls_final-2904_rp +  ls_final-2905_rp +  ls_final-2906_rp +  ls_final-2951_rp
        +  ls_final-2952_rp +  ls_final-2953_rp +  ls_final-2954_rp +  ls_final-2955_rp +  ls_final-2956_rp + ls_final-2957_rp +  ls_final-2958_rp + ls_final-2959_rp + ls_final-2960_rp + ls_final-2961_rp + ls_final-2962_rp +
         ls_final-2963_rp +  ls_final-2964_rp + ls_final-3001_rp + ls_final-3002_rp + ls_final-3201_rp + ls_final-3202_rp + ls_final-3203_rp + ls_final-3204_rp +  ls_final-3205_rp + ls_final-3251_rp + ls_final-3252_rp +
          ls_final-3301_rp + ls_final-3302_rp + ls_final-3303_rp + ls_final-3304_rp + ls_final-3351_rp + ls_final-3352_rp + ls_final-3353_rp + ls_final-3354_rp + ls_final-3355_rp + ls_final-3356_rp + ls_final-3357_rp +  ls_final-3358_rp
        + ls_final-3359_rp +  ls_final-3451_rp + ls_final-3601_rp + ls_final-3602_rp + ls_final-3603_rp + ls_final-3604_rp + ls_final-3651_rp + ls_final-3652_rp + ls_final-3653_rp + ls_final-3701_rp + ls_final-3702_rp + ls_final-3703_rp
        +  ls_final-3704_rp + ls_final-3705_rp + ls_final-3751_rp + ls_final-0302_rp + ls_final-0501_rp + ls_final-0603_rp + ls_final-0704_rp + ls_final-2102_rp + ls_final-2202_rp + ls_final-3360_rp + ls_final-3361_rp + ls_final-3400_rp
        + ls_final-3605_rp + ls_final-3706_rp + ls_final-3707_rp.

        CLEAR : lv_prctr,ls_rp-hsl.
      ENDLOOP.


      LOOP AT lt_cp INTO ls_cp WHERE racct = ls_final-saknr.
        DATA : l_prctr(10) TYPE c.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_cp-prctr
          IMPORTING
            output = l_prctr.
         SHIFT l_prctr LEFT DELETING LEADING '0'.
*          l_prctr = ls_cp-prctr.
        IF  l_prctr = '101010'.
          ls_final-0301_cp = ls_final-0301_cp + ls_cp-hsl.
        ELSEIF  l_prctr = '101020'.
          ls_final-0302_cp = ls_final-0302_cp + ls_cp-hsl.
        ELSEIF l_prctr = '102010'.
          ls_final-0401_cp = ls_final-0401_cp + ls_cp-hsl.
        ELSEIF l_prctr = '102020'.
          ls_final-0501_cp = ls_final-0501_cp + ls_cp-hsl.
        ELSEIF l_prctr = '103010'.
          ls_final-0601_cp = ls_final-0601_cp + ls_cp-hsl.
        ELSEIF l_prctr = '200010'.
          ls_final-0602_cp = ls_final-0602_cp + ls_cp-hsl.
        ELSEIF l_prctr = '200020'.
          ls_final-0603_cp = ls_final-0603_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'DUMMY_DELV'.
          ls_final-0701_cp = ls_final-0701_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'HU01-DUMMY'.
          ls_final-0702_cp = ls_final-0702_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_01'.
          ls_final-0703_cp = ls_final-0703_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_02'.
          ls_final-0704_cp = ls_final-0704_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_03'.
          ls_final-0801_cp = ls_final-0801_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_04'.
          ls_final-0802_cp = ls_final-0802_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_05'.
          ls_final-0803_cp = ls_final-0803_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_06'.
          ls_final-0901_cp = ls_final-0901_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_07'.
          ls_final-0902_cp = ls_final-0902_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_08'.
          ls_final-0903_cp = ls_final-0903_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_09'.
          ls_final-0904_cp = ls_final-0904_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_10'.
          ls_final-0905_cp = ls_final-0905_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS01_11'.
          ls_final-1801_cp = ls_final-1801_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_01'.
          ls_final-1901_cp = ls_final-1901_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_02'.
          ls_final-1902_cp = ls_final-1902_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_03'.
          ls_final-2101_cp = ls_final-2101_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_04'.
          ls_final-2102_cp = ls_final-2102_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_05'.
          ls_final-2201_cp = ls_final-2201_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_06'.
          ls_final-2202_cp = ls_final-2202_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_07'.
          ls_final-2301_cp = ls_final-2301_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_08'.
          ls_final-2302_cp = ls_final-2302_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_09'.
          ls_final-2303_cp = ls_final-2303_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_10'.
          ls_final-2304_cp = ls_final-2304_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS02_11'.
          ls_final-2351_cp = ls_final-2351_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_01'.
          ls_final-2401_cp = ls_final-2401_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_02'.
          ls_final-2402_cp = ls_final-2402_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_03'.
          ls_final-2403_cp = ls_final-2403_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_04'.
          ls_final-2404_cp = ls_final-2404_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_05'.
          ls_final-2405_cp = ls_final-2405_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_06'.
          ls_final-2406_cp = ls_final-2406_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_07'.
          ls_final-2407_cp = ls_final-2407_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_08'.
          ls_final-2408_cp = ls_final-2408_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_09'.
          ls_final-2451_cp = ls_final-2451_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_10'.
          ls_final-2452_cp = ls_final-2452_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'PRUS03_11'.
          ls_final-2453_cp = ls_final-2453_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'RECO-DUMMY'.
          ls_final-2454_cp = ls_final-2454_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SAP-DUMMY'.
          ls_final-2455_cp = ls_final-2455_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SU1010'.
          ls_final-2456_cp = ls_final-2456_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SU1020'.
          ls_final-2457_cp = ls_final-2457_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SU2010'.
          ls_final-2458_cp = ls_final-2458_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SU2020'.
          ls_final-2459_cp = ls_final-2459_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SU3010'.
          ls_final-2701_cp = ls_final-2701_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SU4000'.
          ls_final-2702_cp = ls_final-2702_cp + ls_cp-hsl.
        ELSEIF l_prctr = 'SU5000'.
          ls_final-2703_cp = ls_final-2703_cp + ls_cp-hsl.

        ENDIF.


        ls_final-total_cp =  ls_final-0301_cp +  ls_final-0401_cp +  ls_final-0601_cp +  ls_final-0602_cp +  ls_final-0701_cp +  ls_final-0702_cp +  ls_final-0703_cp +  ls_final-0801_cp +  ls_final-0802_cp + ls_final-0803_cp
              +  ls_final-0901_cp +  ls_final-0902_cp +  ls_final-0903_cp +  ls_final-0904_cp +  ls_final-0905_cp +  ls_final-1801_cp + ls_final-1901_cp +  ls_final-1902_cp +  ls_final-2101_cp +  ls_final-2201_cp +  ls_final-2301_cp
              +  ls_final-2302_cp +  ls_final-2303_cp +  ls_final-2304_cp +  ls_final-2351_cp +  ls_final-2401_cp +  ls_final-2402_cp +  ls_final-2403_cp +  ls_final-2404_cp +  ls_final-2405_cp +  ls_final-2406_cp +  ls_final-2407_cp
              +  ls_final-2408_cp +  ls_final-2451_cp +  ls_final-2452_cp +  ls_final-2453_cp +  ls_final-2454_cp +  ls_final-2455_cp +  ls_final-2456_cp +  ls_final-2457_cp +  ls_final-2458_cp +  ls_final-2459_cp +  ls_final-2701_cp
              +  ls_final-2702_cp +  ls_final-2703_cp +  ls_final-2704_cp +  ls_final-2705_cp +  ls_final-2706_cp +  ls_final-2707_cp +  ls_final-2711_cp +  ls_final-2712_cp +  ls_final-2713_cp +  ls_final-2714_cp +  ls_final-2715_cp
              +  ls_final-2716_cp +  ls_final-2717_cp +  ls_final-2718_cp +  ls_final-2719_cp +  ls_final-2720_cp +  ls_final-2721_cp + ls_final-2722_cp +  ls_final-2723_cp +  ls_final-2724_cp +  ls_final-2725_cp +  ls_final-2726_cp
              +  ls_final-2727_cp +  ls_final-2728_cp +  ls_final-2729_cp +  ls_final-2730_cp +  ls_final-2731_cp +  ls_final-2751_cp +  ls_final-2752_cp +  ls_final-2753_cp +  ls_final-2754_cp +  ls_final-2755_cp + ls_final-2756_cp
              +  ls_final-2757_cp +  ls_final-2758_cp +  ls_final-2759_cp +  ls_final-2760_cp +  ls_final-2901_cp +  ls_final-2902_cp + ls_final-2903_cp +  ls_final-2904_cp +  ls_final-2905_cp +  ls_final-2906_cp +  ls_final-2951_cp
              +  ls_final-2952_cp +  ls_final-2953_cp +  ls_final-2954_cp +  ls_final-2955_cp +  ls_final-2956_cp + ls_final-2957_cp +  ls_final-2958_cp + ls_final-2959_cp + ls_final-2960_cp + ls_final-2961_cp + ls_final-2962_cp +
               ls_final-2963_cp +  ls_final-2964_cp + ls_final-3001_cp + ls_final-3002_cp + ls_final-3201_cp + ls_final-3202_cp + ls_final-3203_cp + ls_final-3204_cp +  ls_final-3205_cp + ls_final-3251_cp + ls_final-3252_cp +
                ls_final-3301_cp + ls_final-3302_cp + ls_final-3303_cp + ls_final-3304_cp + ls_final-3351_cp + ls_final-3352_cp + ls_final-3353_cp + ls_final-3354_cp + ls_final-3355_cp + ls_final-3356_cp + ls_final-3357_cp +  ls_final-3358_cp
              + ls_final-3359_cp +  ls_final-3451_cp + ls_final-3601_cp + ls_final-3602_cp + ls_final-3603_cp + ls_final-3604_cp + ls_final-3651_cp + ls_final-3652_cp + ls_final-3653_cp + ls_final-3701_cp + ls_final-3702_cp + ls_final-3703_cp
              +  ls_final-3704_cp + ls_final-3705_cp + ls_final-3751_cp + ls_final-0302_cp + ls_final-0501_cp + ls_final-0603_cp + ls_final-0704_cp + ls_final-2102_cp + ls_final-2202_cp + ls_final-3360_cp + ls_final-3361_cp + ls_final-3400_cp
              + ls_final-3605_cp + ls_final-3706_cp + ls_final-3707_cp.

        CLEAR: l_prctr , ls_cp-hsl.
      ENDLOOP.

      APPEND : ls_final TO lt_final.
      CLEAR : ls_final.
    ENDLOOP.
  ENDIF.

  IF lt_ska1 IS NOT INITIAL.
    LOOP AT lt_ska1 INTO ls_ska1.
      ls_final-saknr  = ls_ska1-saknr.

      SELECT SINGLE * FROM skb1 INTO CORRESPONDING FIELDS OF ls_skb1 WHERE saknr = ls_final-saknr.

      READ TABLE lt_skb1 INTO ls_skb1 WITH KEY saknr = ls_final-saknr.
      ls_final-bukrs  = ls_skb1-bukrs.

      READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_final-saknr.
      ls_final-txt50  = ls_skat-txt50.

      LOOP AT lt_rp1 INTO ls_rp1 WHERE racct = ls_final-saknr.
*        DATA : lv_prctr(10) TYPE c.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_rp1-prctr
          IMPORTING
            output = lv_prctr.
*        lv_prctr = ls_rp1-prctr.
         SHIFT lv_prctr LEFT DELETING LEADING '0'.
        ls_final-prctr = lv_prctr.

       IF lv_prctr = '101010'.
          ls_final-0301_rp = ls_final-0301_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = '101020'.
          ls_final-0302_rp = ls_final-0302_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = '102010'.
          ls_final-0401_rp = ls_final-0401_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = '102020'.
          ls_final-0501_rp = ls_final-0501_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = '103010'.
          ls_final-0601_rp = ls_final-0601_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = '200010'.
          ls_final-0602_rp = ls_final-0602_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = '200020'.
          ls_final-0603_rp = ls_final-0603_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'DUMMY_DELV'.
          ls_final-0701_rp = ls_final-0701_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'HU01-DUMMY'.
          ls_final-0702_rp = ls_final-0702_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_01'.
          ls_final-0703_rp = ls_final-0703_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_02'.
          ls_final-0704_rp = ls_final-0704_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_03'.
          ls_final-0801_rp = ls_final-0801_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_04'.
          ls_final-0802_rp = ls_final-0802_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_05'.
          ls_final-0803_rp = ls_final-0803_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_06'.
          ls_final-0901_rp = ls_final-0901_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_07'.
          ls_final-0902_rp = ls_final-0902_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_08'.
          ls_final-0903_rp = ls_final-0903_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_09'.
          ls_final-0904_rp = ls_final-0904_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_10'.
          ls_final-0905_rp = ls_final-0905_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS01_11'.
          ls_final-1801_rp = ls_final-1801_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_01'.
          ls_final-1901_rp = ls_final-1901_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_02'.
          ls_final-1902_rp = ls_final-1902_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_03'.
          ls_final-2101_rp = ls_final-2101_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_04'.
          ls_final-2102_rp = ls_final-2102_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_05'.
          ls_final-2201_rp = ls_final-2201_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_06'.
          ls_final-2202_rp = ls_final-2202_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_07'.
          ls_final-2301_rp = ls_final-2301_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_08'.
          ls_final-2302_rp = ls_final-2302_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_09'.
          ls_final-2303_rp = ls_final-2303_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_10'.
          ls_final-2304_rp = ls_final-2304_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS02_11'.
          ls_final-2351_rp = ls_final-2351_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_01'.
          ls_final-2401_rp = ls_final-2401_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_02'.
          ls_final-2402_rp = ls_final-2402_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_03'.
          ls_final-2403_rp = ls_final-2403_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_04'.
          ls_final-2404_rp = ls_final-2404_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_05'.
          ls_final-2405_rp = ls_final-2405_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_06'.
          ls_final-2406_rp = ls_final-2406_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_07'.
          ls_final-2407_rp = ls_final-2407_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_08'.
          ls_final-2408_rp = ls_final-2408_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_09'.
          ls_final-2451_rp = ls_final-2451_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_10'.
          ls_final-2452_rp = ls_final-2452_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'PRUS03_11'.
          ls_final-2453_rp = ls_final-2453_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'RECO-DUMMY'.
          ls_final-2454_rp = ls_final-2454_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SAP-DUMMY'.
          ls_final-2455_rp = ls_final-2455_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SU1010'.
          ls_final-2456_rp = ls_final-2456_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SU1020'.
          ls_final-2457_rp = ls_final-2457_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SU2010'.
          ls_final-2458_rp = ls_final-2458_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SU2020'.
          ls_final-2459_rp = ls_final-2459_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SU3010'.
          ls_final-2701_rp = ls_final-2701_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SU4000'.
          ls_final-2702_rp = ls_final-2702_rp + ls_rp1-hsl.
        ELSEIF lv_prctr = 'SU5000'.
          ls_final-2703_rp = ls_final-2703_rp + ls_rp1-hsl.

        ENDIF.

        ls_final-total_rp =  ls_final-0301_rp +  ls_final-0401_rp +  ls_final-0601_rp +  ls_final-0602_rp +  ls_final-0701_rp +  ls_final-0702_rp +  ls_final-0703_rp +  ls_final-0801_rp +  ls_final-0802_rp + ls_final-0803_rp
        +  ls_final-0901_rp +  ls_final-0902_rp +  ls_final-0903_rp +  ls_final-0904_rp +  ls_final-0905_rp +  ls_final-1801_rp + ls_final-1901_rp +  ls_final-1902_rp +  ls_final-2101_rp +  ls_final-2201_rp +  ls_final-2301_rp
        +  ls_final-2302_rp +  ls_final-2303_rp +  ls_final-2304_rp +  ls_final-2351_rp +  ls_final-2401_rp +  ls_final-2402_rp +  ls_final-2403_rp +  ls_final-2404_rp +  ls_final-2405_rp +  ls_final-2406_rp +  ls_final-2407_rp
        +  ls_final-2408_rp +  ls_final-2451_rp +  ls_final-2452_rp +  ls_final-2453_rp +  ls_final-2454_rp +  ls_final-2455_rp +  ls_final-2456_rp +  ls_final-2457_rp +  ls_final-2458_rp +  ls_final-2459_rp +  ls_final-2701_rp
        +  ls_final-2702_rp +  ls_final-2703_rp +  ls_final-2704_rp +  ls_final-2705_rp +  ls_final-2706_rp +  ls_final-2707_rp +  ls_final-2711_rp +  ls_final-2712_rp +  ls_final-2713_rp +  ls_final-2714_rp +  ls_final-2715_rp
        +  ls_final-2716_rp +  ls_final-2717_rp +  ls_final-2718_rp +  ls_final-2719_rp +  ls_final-2720_rp +  ls_final-2721_rp + ls_final-2722_rp +  ls_final-2723_rp +  ls_final-2724_rp +  ls_final-2725_rp +  ls_final-2726_rp
        +  ls_final-2727_rp +  ls_final-2728_rp +  ls_final-2729_rp +  ls_final-2730_rp +  ls_final-2731_rp +  ls_final-2751_rp +  ls_final-2752_rp +  ls_final-2753_rp +  ls_final-2754_rp +  ls_final-2755_rp + ls_final-2756_rp
        +  ls_final-2757_rp +  ls_final-2758_rp +  ls_final-2759_rp +  ls_final-2760_rp +  ls_final-2901_rp +  ls_final-2902_rp + ls_final-2903_rp +  ls_final-2904_rp +  ls_final-2905_rp +  ls_final-2906_rp +  ls_final-2951_rp
        +  ls_final-2952_rp +  ls_final-2953_rp +  ls_final-2954_rp +  ls_final-2955_rp +  ls_final-2956_rp + ls_final-2957_rp +  ls_final-2958_rp + ls_final-2959_rp + ls_final-2960_rp + ls_final-2961_rp + ls_final-2962_rp +
         ls_final-2963_rp +  ls_final-2964_rp + ls_final-3001_rp + ls_final-3002_rp + ls_final-3201_rp + ls_final-3202_rp + ls_final-3203_rp + ls_final-3204_rp +  ls_final-3205_rp + ls_final-3251_rp + ls_final-3252_rp +
          ls_final-3301_rp + ls_final-3302_rp + ls_final-3303_rp + ls_final-3304_rp + ls_final-3351_rp + ls_final-3352_rp + ls_final-3353_rp + ls_final-3354_rp + ls_final-3355_rp + ls_final-3356_rp + ls_final-3357_rp +  ls_final-3358_rp
        + ls_final-3359_rp +  ls_final-3451_rp + ls_final-3601_rp + ls_final-3602_rp + ls_final-3603_rp + ls_final-3604_rp + ls_final-3651_rp + ls_final-3652_rp + ls_final-3653_rp + ls_final-3701_rp + ls_final-3702_rp + ls_final-3703_rp
        +  ls_final-3704_rp + ls_final-3705_rp + ls_final-3751_rp + ls_final-0302_rp + ls_final-0501_rp + ls_final-0603_rp + ls_final-0704_rp + ls_final-2102_rp + ls_final-2202_rp + ls_final-3360_rp + ls_final-3361_rp + ls_final-3400_rp
        + ls_final-3605_rp + ls_final-3706_rp + ls_final-3707_rp.

        CLEAR : lv_prctr,ls_rp1-hsl.
      ENDLOOP.


      LOOP AT lt_cp1 INTO ls_cp1 WHERE racct = ls_final-saknr.
*        DATA : l_prctr(10) TYPE c.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_cp1-prctr
          IMPORTING
            output = l_prctr.
*         l_prctr =  ls_cp1-prctr.
   SHIFT l_prctr LEFT DELETING LEADING '0'.
       IF  l_prctr = '101010'.
          ls_final-0301_cp = ls_final-0301_cp + ls_cp1-hsl.
        ELSEIF  l_prctr = '101020'.
          ls_final-0302_cp = ls_final-0302_cp + ls_cp1-hsl.
        ELSEIF l_prctr = '102010'.
          ls_final-0401_cp = ls_final-0401_cp + ls_cp1-hsl.
        ELSEIF l_prctr = '102020'.
          ls_final-0501_cp = ls_final-0501_cp + ls_cp1-hsl.
        ELSEIF l_prctr = '103010'.
          ls_final-0601_cp = ls_final-0601_cp + ls_cp1-hsl.
        ELSEIF l_prctr = '200010'.
          ls_final-0602_cp = ls_final-0602_cp + ls_cp1-hsl.
        ELSEIF l_prctr = '200020'.
          ls_final-0603_cp = ls_final-0603_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'DUMMY_DELV'.
          ls_final-0701_cp = ls_final-0701_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'HU01-DUMMY'.
          ls_final-0702_cp = ls_final-0702_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_01'.
          ls_final-0703_cp = ls_final-0703_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_02'.
          ls_final-0704_cp = ls_final-0704_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_03'.
          ls_final-0801_cp = ls_final-0801_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_04'.
          ls_final-0802_cp = ls_final-0802_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_05'.
          ls_final-0803_cp = ls_final-0803_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_06'.
          ls_final-0901_cp = ls_final-0901_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_07'.
          ls_final-0902_cp = ls_final-0902_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_08'.
          ls_final-0903_cp = ls_final-0903_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_09'.
          ls_final-0904_cp = ls_final-0904_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_10'.
          ls_final-0905_cp = ls_final-0905_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS01_11'.
          ls_final-1801_cp = ls_final-1801_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_01'.
          ls_final-1901_cp = ls_final-1901_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_02'.
          ls_final-1902_cp = ls_final-1902_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_03'.
          ls_final-2101_cp = ls_final-2101_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_04'.
          ls_final-2102_cp = ls_final-2102_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_05'.
          ls_final-2201_cp = ls_final-2201_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_06'.
          ls_final-2202_cp = ls_final-2202_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_07'.
          ls_final-2301_cp = ls_final-2301_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_08'.
          ls_final-2302_cp = ls_final-2302_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_09'.
          ls_final-2303_cp = ls_final-2303_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_10'.
          ls_final-2304_cp = ls_final-2304_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS02_11'.
          ls_final-2351_cp = ls_final-2351_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_01'.
          ls_final-2401_cp = ls_final-2401_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_02'.
          ls_final-2402_cp = ls_final-2402_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_03'.
          ls_final-2403_cp = ls_final-2403_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_04'.
          ls_final-2404_cp = ls_final-2404_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_05'.
          ls_final-2405_cp = ls_final-2405_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_06'.
          ls_final-2406_cp = ls_final-2406_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_07'.
          ls_final-2407_cp = ls_final-2407_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_08'.
          ls_final-2408_cp = ls_final-2408_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_09'.
          ls_final-2451_cp = ls_final-2451_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_10'.
          ls_final-2452_cp = ls_final-2452_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'PRUS03_11'.
          ls_final-2453_cp = ls_final-2453_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'RECO-DUMMY'.
          ls_final-2454_cp = ls_final-2454_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SAP-DUMMY'.
          ls_final-2455_cp = ls_final-2455_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SU1010'.
          ls_final-2456_cp = ls_final-2456_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SU1020'.
          ls_final-2457_cp = ls_final-2457_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SU2010'.
          ls_final-2458_cp = ls_final-2458_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SU2020'.
          ls_final-2459_cp = ls_final-2459_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SU3010'.
          ls_final-2701_cp = ls_final-2701_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SU4000'.
          ls_final-2702_cp = ls_final-2702_cp + ls_cp1-hsl.
        ELSEIF l_prctr = 'SU5000'.
          ls_final-2703_cp = ls_final-2703_cp + ls_cp1-hsl.
*        ELSEIF lv_prctr = '2704'.
*          ls_final-2704_rp = ls_final-2704_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2705'.
*          ls_final-2705_rp = ls_final-2705_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2706'.
*          ls_final-2706_rp = ls_final-2706_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2707'.
*          ls_final-2707_rp = ls_final-2707_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2711'.
*          ls_final-2711_rp = ls_final-2711_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2712'.
*          ls_final-2712_rp = ls_final-2712_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2713'.
*          ls_final-2713_rp = ls_final-2713_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2714'.
*          ls_final-2714_rp = ls_final-2714_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2715'.
*          ls_final-2715_rp = ls_final-2715_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2716'.
*          ls_final-2716_rp = ls_final-2716_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2717'.
*          ls_final-2717_rp = ls_final-2717_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2718'.
*          ls_final-2718_rp = ls_final-2718_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2719'.
*          ls_final-2719_rp = ls_final-2719_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2720'.
*          ls_final-2720_rp = ls_final-2720_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2721'.
*          ls_final-2721_rp = ls_final-2721_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2722'.
*          ls_final-2722_rp = ls_final-2722_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2723'.
*          ls_final-2723_rp = ls_final-2723_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2724'.
*          ls_final-2724_rp = ls_final-2724_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2725'.
*          ls_final-2725_rp = ls_final-2725_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2726'.
*          ls_final-2726_rp = ls_final-2726_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2727'.
*          ls_final-2727_rp = ls_final-2727_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2728'.
*          ls_final-2728_rp = ls_final-2728_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2729'.
*          ls_final-2729_rp = ls_final-2729_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2730'.
*          ls_final-2730_rp = ls_final-2730_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2731'.
*          ls_final-2731_rp = ls_final-2731_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2751'.
*          ls_final-2751_rp = ls_final-2751_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2752'.
*          ls_final-2752_rp = ls_final-2752_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2753'.
*          ls_final-2753_rp = ls_final-2753_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2754'.
*          ls_final-2754_rp = ls_final-2754_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2755'.
*          ls_final-2755_rp = ls_final-2755_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2756'.
*          ls_final-2756_rp = ls_final-2756_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2757'.
*          ls_final-2757_rp = ls_final-2757_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2758'.
*          ls_final-2758_rp = ls_final-2758_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2759'.
*          ls_final-2759_rp = ls_final-2759_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2760'.
*          ls_final-2760_rp = ls_final-2760_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2901'.
*          ls_final-2901_rp = ls_final-2901_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2902'.
*          ls_final-2902_rp = ls_final-2902_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2903'.
*          ls_final-2903_rp = ls_final-2903_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2904'.
*          ls_final-2904_rp = ls_final-2904_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2905'.
*          ls_final-2905_rp = ls_final-2905_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2906'.
*          ls_final-2906_rp = ls_final-2906_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2951'.
*          ls_final-2951_rp = ls_final-2951_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2952'.
*          ls_final-2952_rp = ls_final-2952_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2953'.
*          ls_final-2953_rp = ls_final-2953_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2954'.
*          ls_final-2954_rp = ls_final-2954_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2955'.
*          ls_final-2955_rp = ls_final-2955_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2956'.
*          ls_final-2956_rp = ls_final-2956_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2957'.
*          ls_final-2957_rp = ls_final-2957_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2958'.
*          ls_final-2958_rp = ls_final-2958_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2959'.
*          ls_final-2959_rp = ls_final-2959_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2960'.
*          ls_final-2960_rp = ls_final-2960_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2961'.
*          ls_final-2961_rp = ls_final-2961_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2962'.
*          ls_final-2962_rp = ls_final-2962_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2963'.
*          ls_final-2963_rp = ls_final-2963_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2964'.
*          ls_final-2964_rp = ls_final-2964_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3001'.
*          ls_final-3001_rp = ls_final-3001_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3002'.
*          ls_final-3002_rp = ls_final-3002_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3201'.
*          ls_final-3201_rp = ls_final-3201_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3202'.
*          ls_final-3202_rp = ls_final-3202_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3203'.
*          ls_final-3203_rp = ls_final-3203_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3204'.
*          ls_final-3204_rp = ls_final-3204_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3205'.
*          ls_final-3205_rp = ls_final-3205_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3251'.
*          ls_final-3251_rp = ls_final-3251_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3252'.
*          ls_final-3252_rp = ls_final-3252_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3301'.
*          ls_final-3301_rp = ls_final-3301_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3302'.
*          ls_final-3302_rp = ls_final-3302_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3303'.
*          ls_final-3303_rp = ls_final-3303_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3304'.
*          ls_final-3304_rp = ls_final-3304_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3351'.
*          ls_final-3351_rp = ls_final-3351_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3352'.
*          ls_final-3352_rp = ls_final-3352_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3353'.
*          ls_final-3353_rp = ls_final-3353_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3354'.
*          ls_final-3354_rp = ls_final-3354_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3355'.
*          ls_final-3355_rp = ls_final-3355_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3356'.
*          ls_final-3356_rp = ls_final-3356_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3357'.
*          ls_final-3357_rp = ls_final-3357_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3358'.
*          ls_final-3358_rp = ls_final-3358_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3359'.
*          ls_final-3359_rp = ls_final-3359_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3360'.
*          ls_final-3360_rp = ls_final-3360_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3361'.
*          ls_final-3361_rp = ls_final-3361_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3400'.
*          ls_final-3400_rp = ls_final-3400_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3451'.
*          ls_final-3451_rp = ls_final-3451_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3601'.
*          ls_final-3601_rp = ls_final-3601_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3602'.
*          ls_final-3602_rp = ls_final-3602_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3603'.
*          ls_final-3603_rp = ls_final-3603_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3604'.
*          ls_final-3604_rp = ls_final-3604_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3605'.
*          ls_final-3605_rp = ls_final-3605_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3651'.
*          ls_final-3651_rp = ls_final-3651_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3652'.
*          ls_final-3652_rp = ls_final-3652_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3653'.
*          ls_final-3653_rp = ls_final-3653_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3701'.
*          ls_final-3701_rp = ls_final-3701_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3702'.
*          ls_final-3702_rp = ls_final-3702_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3703'.
*          ls_final-3703_rp = ls_final-3703_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3704'.
*          ls_final-3704_rp = ls_final-3704_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3705'.
*          ls_final-3705_rp = ls_final-3705_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3706'.
*          ls_final-3706_rp = ls_final-3706_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3707'.
*          ls_final-3707_rp = ls_final-3707_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3751'.
*          ls_final-3751_rp = ls_final-3751_rp + ls_rp-hsl.
        ENDIF.

        ls_final-total_cp =  ls_final-0301_cp +  ls_final-0401_cp +  ls_final-0601_cp +  ls_final-0602_cp +  ls_final-0701_cp +  ls_final-0702_cp +  ls_final-0703_cp +  ls_final-0801_cp +  ls_final-0802_cp + ls_final-0803_cp
              +  ls_final-0901_cp +  ls_final-0902_cp +  ls_final-0903_cp +  ls_final-0904_cp +  ls_final-0905_cp +  ls_final-1801_cp + ls_final-1901_cp +  ls_final-1902_cp +  ls_final-2101_cp +  ls_final-2201_cp +  ls_final-2301_cp
              +  ls_final-2302_cp +  ls_final-2303_cp +  ls_final-2304_cp +  ls_final-2351_cp +  ls_final-2401_cp +  ls_final-2402_cp +  ls_final-2403_cp +  ls_final-2404_cp +  ls_final-2405_cp +  ls_final-2406_cp +  ls_final-2407_cp
              +  ls_final-2408_cp +  ls_final-2451_cp +  ls_final-2452_cp +  ls_final-2453_cp +  ls_final-2454_cp +  ls_final-2455_cp +  ls_final-2456_cp +  ls_final-2457_cp +  ls_final-2458_cp +  ls_final-2459_cp +  ls_final-2701_cp
              +  ls_final-2702_cp +  ls_final-2703_cp +  ls_final-2704_cp +  ls_final-2705_cp +  ls_final-2706_cp +  ls_final-2707_cp +  ls_final-2711_cp +  ls_final-2712_cp +  ls_final-2713_cp +  ls_final-2714_cp +  ls_final-2715_cp
              +  ls_final-2716_cp +  ls_final-2717_cp +  ls_final-2718_cp +  ls_final-2719_cp +  ls_final-2720_cp +  ls_final-2721_cp + ls_final-2722_cp +  ls_final-2723_cp +  ls_final-2724_cp +  ls_final-2725_cp +  ls_final-2726_cp
              +  ls_final-2727_cp +  ls_final-2728_cp +  ls_final-2729_cp +  ls_final-2730_cp +  ls_final-2731_cp +  ls_final-2751_cp +  ls_final-2752_cp +  ls_final-2753_cp +  ls_final-2754_cp +  ls_final-2755_cp + ls_final-2756_cp
              +  ls_final-2757_cp +  ls_final-2758_cp +  ls_final-2759_cp +  ls_final-2760_cp +  ls_final-2901_cp +  ls_final-2902_cp + ls_final-2903_cp +  ls_final-2904_cp +  ls_final-2905_cp +  ls_final-2906_cp +  ls_final-2951_cp
              +  ls_final-2952_cp +  ls_final-2953_cp +  ls_final-2954_cp +  ls_final-2955_cp +  ls_final-2956_cp + ls_final-2957_cp +  ls_final-2958_cp + ls_final-2959_cp + ls_final-2960_cp + ls_final-2961_cp + ls_final-2962_cp +
               ls_final-2963_cp +  ls_final-2964_cp + ls_final-3001_cp + ls_final-3002_cp + ls_final-3201_cp + ls_final-3202_cp + ls_final-3203_cp + ls_final-3204_cp +  ls_final-3205_cp + ls_final-3251_cp + ls_final-3252_cp +
                ls_final-3301_cp + ls_final-3302_cp + ls_final-3303_cp + ls_final-3304_cp + ls_final-3351_cp + ls_final-3352_cp + ls_final-3353_cp + ls_final-3354_cp + ls_final-3355_cp + ls_final-3356_cp + ls_final-3357_cp +  ls_final-3358_cp
              + ls_final-3359_cp +  ls_final-3451_cp + ls_final-3601_cp + ls_final-3602_cp + ls_final-3603_cp + ls_final-3604_cp + ls_final-3651_cp + ls_final-3652_cp + ls_final-3653_cp + ls_final-3701_cp + ls_final-3702_cp + ls_final-3703_cp
              +  ls_final-3704_cp + ls_final-3705_cp + ls_final-3751_cp + ls_final-0302_cp + ls_final-0501_cp + ls_final-0603_cp + ls_final-0704_cp + ls_final-2102_cp + ls_final-2202_cp + ls_final-3360_cp + ls_final-3361_cp + ls_final-3400_cp
              + ls_final-3605_cp + ls_final-3706_cp + ls_final-3707_cp.

        CLEAR: l_prctr , ls_cp1-hsl.
      ENDLOOP.

      APPEND : ls_final TO lt_final.
      CLEAR : ls_final, ls_skb1, ls_ska1.
    ENDLOOP.
  ENDIF.

  IF lt_ska1_1 IS NOT INITIAL.
    LOOP AT lt_ska1_1 INTO ls_ska1_1.
      ls_final-saknr  = ls_ska1_1-saknr.

      SELECT SINGLE * FROM skb1 INTO CORRESPONDING FIELDS OF ls_skb1 WHERE saknr = ls_final-saknr.

      READ TABLE lt_skb1 INTO ls_skb1 WITH KEY saknr = ls_final-saknr.
      ls_final-bukrs  = ls_skb1-bukrs.

      READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_final-saknr.
      ls_final-txt50  = ls_skat-txt50.
      if lt_rp2 is NOT INITIAL.
      LOOP AT lt_rp2 INTO ls_rp2 WHERE racct = ls_final-saknr.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_rp2-prctr
          IMPORTING
            output = lv_prctr.
*        lv_prctr = ls_rp2-prctr.
         SHIFT lv_prctr LEFT DELETING LEADING '0'.
        ls_final-prctr = lv_prctr.


        IF lv_prctr = '101010'.
          ls_final-0301_rp = ls_final-0301_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = '101020'.
          ls_final-0302_rp = ls_final-0302_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = '102010'.
          ls_final-0401_rp = ls_final-0401_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = '102020'.
          ls_final-0501_rp = ls_final-0501_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = '103010'.
          ls_final-0601_rp = ls_final-0601_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = '200010'.
          ls_final-0602_rp = ls_final-0602_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = '200020'.
          ls_final-0603_rp = ls_final-0603_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'DUMMY_DELV'.
          ls_final-0701_rp = ls_final-0701_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'HU01-DUMMY'.
          ls_final-0702_rp = ls_final-0702_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_01'.
          ls_final-0703_rp = ls_final-0703_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_02'.
          ls_final-0704_rp = ls_final-0704_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_03'.
          ls_final-0801_rp = ls_final-0801_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_04'.
          ls_final-0802_rp = ls_final-0802_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_05'.
          ls_final-0803_rp = ls_final-0803_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_06'.
          ls_final-0901_rp = ls_final-0901_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_07'.
          ls_final-0902_rp = ls_final-0902_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_08'.
          ls_final-0903_rp = ls_final-0903_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_09'.
          ls_final-0904_rp = ls_final-0904_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_10'.
          ls_final-0905_rp = ls_final-0905_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS01_11'.
          ls_final-1801_rp = ls_final-1801_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_01'.
          ls_final-1901_rp = ls_final-1901_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_02'.
          ls_final-1902_rp = ls_final-1902_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_03'.
          ls_final-2101_rp = ls_final-2101_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_04'.
          ls_final-2102_rp = ls_final-2102_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_05'.
          ls_final-2201_rp = ls_final-2201_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_06'.
          ls_final-2202_rp = ls_final-2202_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_07'.
          ls_final-2301_rp = ls_final-2301_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_08'.
          ls_final-2302_rp = ls_final-2302_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_09'.
          ls_final-2303_rp = ls_final-2303_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_10'.
          ls_final-2304_rp = ls_final-2304_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS02_11'.
          ls_final-2351_rp = ls_final-2351_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_01'.
          ls_final-2401_rp = ls_final-2401_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_02'.
          ls_final-2402_rp = ls_final-2402_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_03'.
          ls_final-2403_rp = ls_final-2403_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_04'.
          ls_final-2404_rp = ls_final-2404_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_05'.
          ls_final-2405_rp = ls_final-2405_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_06'.
          ls_final-2406_rp = ls_final-2406_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_07'.
          ls_final-2407_rp = ls_final-2407_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_08'.
          ls_final-2408_rp = ls_final-2408_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_09'.
          ls_final-2451_rp = ls_final-2451_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_10'.
          ls_final-2452_rp = ls_final-2452_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'PRUS03_11'.
          ls_final-2453_rp = ls_final-2453_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'RECO-DUMMY'.
          ls_final-2454_rp = ls_final-2454_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SAP-DUMMY'.
          ls_final-2455_rp = ls_final-2455_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SU1010'.
          ls_final-2456_rp = ls_final-2456_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SU1020'.
          ls_final-2457_rp = ls_final-2457_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SU2010'.
          ls_final-2458_rp = ls_final-2458_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SU2020'.
          ls_final-2459_rp = ls_final-2459_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SU3010'.
          ls_final-2701_rp = ls_final-2701_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SU4000'.
          ls_final-2702_rp = ls_final-2702_rp + ls_rp2-hsl.
        ELSEIF lv_prctr = 'SU5000'.
          ls_final-2703_rp = ls_final-2703_rp + ls_rp2-hsl.
*        ELSEIF lv_prctr = '2704'.
*          ls_final-2704_rp = ls_final-2704_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2705'.
*          ls_final-2705_rp = ls_final-2705_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2706'.
*          ls_final-2706_rp = ls_final-2706_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2707'.
*          ls_final-2707_rp = ls_final-2707_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2711'.
*          ls_final-2711_rp = ls_final-2711_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2712'.
*          ls_final-2712_rp = ls_final-2712_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2713'.
*          ls_final-2713_rp = ls_final-2713_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2714'.
*          ls_final-2714_rp = ls_final-2714_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2715'.
*          ls_final-2715_rp = ls_final-2715_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2716'.
*          ls_final-2716_rp = ls_final-2716_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2717'.
*          ls_final-2717_rp = ls_final-2717_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2718'.
*          ls_final-2718_rp = ls_final-2718_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2719'.
*          ls_final-2719_rp = ls_final-2719_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2720'.
*          ls_final-2720_rp = ls_final-2720_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2721'.
*          ls_final-2721_rp = ls_final-2721_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2722'.
*          ls_final-2722_rp = ls_final-2722_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2723'.
*          ls_final-2723_rp = ls_final-2723_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2724'.
*          ls_final-2724_rp = ls_final-2724_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2725'.
*          ls_final-2725_rp = ls_final-2725_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2726'.
*          ls_final-2726_rp = ls_final-2726_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2727'.
*          ls_final-2727_rp = ls_final-2727_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2728'.
*          ls_final-2728_rp = ls_final-2728_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2729'.
*          ls_final-2729_rp = ls_final-2729_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2730'.
*          ls_final-2730_rp = ls_final-2730_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2731'.
*          ls_final-2731_rp = ls_final-2731_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2751'.
*          ls_final-2751_rp = ls_final-2751_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2752'.
*          ls_final-2752_rp = ls_final-2752_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2753'.
*          ls_final-2753_rp = ls_final-2753_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2754'.
*          ls_final-2754_rp = ls_final-2754_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2755'.
*          ls_final-2755_rp = ls_final-2755_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2756'.
*          ls_final-2756_rp = ls_final-2756_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2757'.
*          ls_final-2757_rp = ls_final-2757_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2758'.
*          ls_final-2758_rp = ls_final-2758_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2759'.
*          ls_final-2759_rp = ls_final-2759_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2760'.
*          ls_final-2760_rp = ls_final-2760_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2901'.
*          ls_final-2901_rp = ls_final-2901_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2902'.
*          ls_final-2902_rp = ls_final-2902_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2903'.
*          ls_final-2903_rp = ls_final-2903_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2904'.
*          ls_final-2904_rp = ls_final-2904_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2905'.
*          ls_final-2905_rp = ls_final-2905_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2906'.
*          ls_final-2906_rp = ls_final-2906_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2951'.
*          ls_final-2951_rp = ls_final-2951_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2952'.
*          ls_final-2952_rp = ls_final-2952_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2953'.
*          ls_final-2953_rp = ls_final-2953_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2954'.
*          ls_final-2954_rp = ls_final-2954_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2955'.
*          ls_final-2955_rp = ls_final-2955_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2956'.
*          ls_final-2956_rp = ls_final-2956_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2957'.
*          ls_final-2957_rp = ls_final-2957_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2958'.
*          ls_final-2958_rp = ls_final-2958_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2959'.
*          ls_final-2959_rp = ls_final-2959_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2960'.
*          ls_final-2960_rp = ls_final-2960_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2961'.
*          ls_final-2961_rp = ls_final-2961_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2962'.
*          ls_final-2962_rp = ls_final-2962_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2963'.
*          ls_final-2963_rp = ls_final-2963_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '2964'.
*          ls_final-2964_rp = ls_final-2964_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3001'.
*          ls_final-3001_rp = ls_final-3001_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3002'.
*          ls_final-3002_rp = ls_final-3002_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3201'.
*          ls_final-3201_rp = ls_final-3201_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3202'.
*          ls_final-3202_rp = ls_final-3202_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3203'.
*          ls_final-3203_rp = ls_final-3203_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3204'.
*          ls_final-3204_rp = ls_final-3204_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3205'.
*          ls_final-3205_rp = ls_final-3205_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3251'.
*          ls_final-3251_rp = ls_final-3251_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3252'.
*          ls_final-3252_rp = ls_final-3252_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3301'.
*          ls_final-3301_rp = ls_final-3301_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3302'.
*          ls_final-3302_rp = ls_final-3302_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3303'.
*          ls_final-3303_rp = ls_final-3303_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3304'.
*          ls_final-3304_rp = ls_final-3304_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3351'.
*          ls_final-3351_rp = ls_final-3351_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3352'.
*          ls_final-3352_rp = ls_final-3352_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3353'.
*          ls_final-3353_rp = ls_final-3353_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3354'.
*          ls_final-3354_rp = ls_final-3354_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3355'.
*          ls_final-3355_rp = ls_final-3355_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3356'.
*          ls_final-3356_rp = ls_final-3356_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3357'.
*          ls_final-3357_rp = ls_final-3357_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3358'.
*          ls_final-3358_rp = ls_final-3358_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3359'.
*          ls_final-3359_rp = ls_final-3359_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3360'.
*          ls_final-3360_rp = ls_final-3360_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3361'.
*          ls_final-3361_rp = ls_final-3361_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3400'.
*          ls_final-3400_rp = ls_final-3400_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3451'.
*          ls_final-3451_rp = ls_final-3451_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3601'.
*          ls_final-3601_rp = ls_final-3601_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3602'.
*          ls_final-3602_rp = ls_final-3602_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3603'.
*          ls_final-3603_rp = ls_final-3603_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3604'.
*          ls_final-3604_rp = ls_final-3604_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3605'.
*          ls_final-3605_rp = ls_final-3605_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3651'.
*          ls_final-3651_rp = ls_final-3651_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3652'.
*          ls_final-3652_rp = ls_final-3652_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3653'.
*          ls_final-3653_rp = ls_final-3653_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3701'.
*          ls_final-3701_rp = ls_final-3701_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3702'.
*          ls_final-3702_rp = ls_final-3702_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3703'.
*          ls_final-3703_rp = ls_final-3703_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3704'.
*          ls_final-3704_rp = ls_final-3704_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3705'.
*          ls_final-3705_rp = ls_final-3705_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3706'.
*          ls_final-3706_rp = ls_final-3706_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3707'.
*          ls_final-3707_rp = ls_final-3707_rp + ls_rp-hsl.
*        ELSEIF lv_prctr = '3751'.
*          ls_final-3751_rp = ls_final-3751_rp + ls_rp-hsl.
        ENDIF.

        ls_final-total_rp =  ls_final-0301_rp +  ls_final-0401_rp +  ls_final-0601_rp +  ls_final-0602_rp +  ls_final-0701_rp +  ls_final-0702_rp +  ls_final-0703_rp +  ls_final-0801_rp +  ls_final-0802_rp + ls_final-0803_rp
        +  ls_final-0901_rp +  ls_final-0902_rp +  ls_final-0903_rp +  ls_final-0904_rp +  ls_final-0905_rp +  ls_final-1801_rp + ls_final-1901_rp +  ls_final-1902_rp +  ls_final-2101_rp +  ls_final-2201_rp +  ls_final-2301_rp
        +  ls_final-2302_rp +  ls_final-2303_rp +  ls_final-2304_rp +  ls_final-2351_rp +  ls_final-2401_rp +  ls_final-2402_rp +  ls_final-2403_rp +  ls_final-2404_rp +  ls_final-2405_rp +  ls_final-2406_rp +  ls_final-2407_rp
        +  ls_final-2408_rp +  ls_final-2451_rp +  ls_final-2452_rp +  ls_final-2453_rp +  ls_final-2454_rp +  ls_final-2455_rp +  ls_final-2456_rp +  ls_final-2457_rp +  ls_final-2458_rp +  ls_final-2459_rp +  ls_final-2701_rp
        +  ls_final-2702_rp +  ls_final-2703_rp +  ls_final-2704_rp +  ls_final-2705_rp +  ls_final-2706_rp +  ls_final-2707_rp +  ls_final-2711_rp +  ls_final-2712_rp +  ls_final-2713_rp +  ls_final-2714_rp +  ls_final-2715_rp
        +  ls_final-2716_rp +  ls_final-2717_rp +  ls_final-2718_rp +  ls_final-2719_rp +  ls_final-2720_rp +  ls_final-2721_rp + ls_final-2722_rp +  ls_final-2723_rp +  ls_final-2724_rp +  ls_final-2725_rp +  ls_final-2726_rp
        +  ls_final-2727_rp +  ls_final-2728_rp +  ls_final-2729_rp +  ls_final-2730_rp +  ls_final-2731_rp +  ls_final-2751_rp +  ls_final-2752_rp +  ls_final-2753_rp +  ls_final-2754_rp +  ls_final-2755_rp + ls_final-2756_rp
        +  ls_final-2757_rp +  ls_final-2758_rp +  ls_final-2759_rp +  ls_final-2760_rp +  ls_final-2901_rp +  ls_final-2902_rp + ls_final-2903_rp +  ls_final-2904_rp +  ls_final-2905_rp +  ls_final-2906_rp +  ls_final-2951_rp
        +  ls_final-2952_rp +  ls_final-2953_rp +  ls_final-2954_rp +  ls_final-2955_rp +  ls_final-2956_rp + ls_final-2957_rp +  ls_final-2958_rp + ls_final-2959_rp + ls_final-2960_rp + ls_final-2961_rp + ls_final-2962_rp +
         ls_final-2963_rp +  ls_final-2964_rp + ls_final-3001_rp + ls_final-3002_rp + ls_final-3201_rp + ls_final-3202_rp + ls_final-3203_rp + ls_final-3204_rp +  ls_final-3205_rp + ls_final-3251_rp + ls_final-3252_rp +
          ls_final-3301_rp + ls_final-3302_rp + ls_final-3303_rp + ls_final-3304_rp + ls_final-3351_rp + ls_final-3352_rp + ls_final-3353_rp + ls_final-3354_rp + ls_final-3355_rp + ls_final-3356_rp + ls_final-3357_rp +  ls_final-3358_rp
        + ls_final-3359_rp +  ls_final-3451_rp + ls_final-3601_rp + ls_final-3602_rp + ls_final-3603_rp + ls_final-3604_rp + ls_final-3651_rp + ls_final-3652_rp + ls_final-3653_rp + ls_final-3701_rp + ls_final-3702_rp + ls_final-3703_rp
        +  ls_final-3704_rp + ls_final-3705_rp + ls_final-3751_rp + ls_final-0302_rp + ls_final-0501_rp + ls_final-0603_rp + ls_final-0704_rp + ls_final-2102_rp + ls_final-2202_rp + ls_final-3360_rp + ls_final-3361_rp + ls_final-3400_rp
        + ls_final-3605_rp + ls_final-3706_rp + ls_final-3707_rp.

        CLEAR : lv_prctr,ls_rp2-hsl.
      ENDLOOP.
      else.
         LOOP AT lt_rp2_1 INTO ls_rp2_1 WHERE racct = ls_final-saknr.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_rp2_1-prctr
          IMPORTING
            output = lv_prctr.
*        lv_prctr = ls_rp2-prctr.
         SHIFT lv_prctr LEFT DELETING LEADING '0'.
        ls_final-prctr = lv_prctr.


        IF lv_prctr = '101010'.
          ls_final-0301_rp = ls_final-0301_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = '101020'.
          ls_final-0302_rp = ls_final-0302_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = '102010'.
          ls_final-0401_rp = ls_final-0401_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = '102020'.
          ls_final-0501_rp = ls_final-0501_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = '103010'.
          ls_final-0601_rp = ls_final-0601_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = '200010'.
          ls_final-0602_rp = ls_final-0602_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = '200020'.
          ls_final-0603_rp = ls_final-0603_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'DUMMY_DELV'.
          ls_final-0701_rp = ls_final-0701_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'HU01-DUMMY'.
          ls_final-0702_rp = ls_final-0702_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_01'.
          ls_final-0703_rp = ls_final-0703_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_02'.
          ls_final-0704_rp = ls_final-0704_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_03'.
          ls_final-0801_rp = ls_final-0801_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_04'.
          ls_final-0802_rp = ls_final-0802_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_05'.
          ls_final-0803_rp = ls_final-0803_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_06'.
          ls_final-0901_rp = ls_final-0901_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_07'.
          ls_final-0902_rp = ls_final-0902_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_08'.
          ls_final-0903_rp = ls_final-0903_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_09'.
          ls_final-0904_rp = ls_final-0904_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_10'.
          ls_final-0905_rp = ls_final-0905_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS01_11'.
          ls_final-1801_rp = ls_final-1801_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_01'.
          ls_final-1901_rp = ls_final-1901_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_02'.
          ls_final-1902_rp = ls_final-1902_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_03'.
          ls_final-2101_rp = ls_final-2101_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_04'.
          ls_final-2102_rp = ls_final-2102_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_05'.
          ls_final-2201_rp = ls_final-2201_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_06'.
          ls_final-2202_rp = ls_final-2202_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_07'.
          ls_final-2301_rp = ls_final-2301_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_08'.
          ls_final-2302_rp = ls_final-2302_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_09'.
          ls_final-2303_rp = ls_final-2303_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_10'.
          ls_final-2304_rp = ls_final-2304_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS02_11'.
          ls_final-2351_rp = ls_final-2351_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_01'.
          ls_final-2401_rp = ls_final-2401_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_02'.
          ls_final-2402_rp = ls_final-2402_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_03'.
          ls_final-2403_rp = ls_final-2403_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_04'.
          ls_final-2404_rp = ls_final-2404_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_05'.
          ls_final-2405_rp = ls_final-2405_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_06'.
          ls_final-2406_rp = ls_final-2406_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_07'.
          ls_final-2407_rp = ls_final-2407_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_08'.
          ls_final-2408_rp = ls_final-2408_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_09'.
          ls_final-2451_rp = ls_final-2451_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_10'.
          ls_final-2452_rp = ls_final-2452_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'PRUS03_11'.
          ls_final-2453_rp = ls_final-2453_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'RECO-DUMMY'.
          ls_final-2454_rp = ls_final-2454_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SAP-DUMMY'.
          ls_final-2455_rp = ls_final-2455_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SU1010'.
          ls_final-2456_rp = ls_final-2456_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SU1020'.
          ls_final-2457_rp = ls_final-2457_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SU2010'.
          ls_final-2458_rp = ls_final-2458_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SU2020'.
          ls_final-2459_rp = ls_final-2459_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SU3010'.
          ls_final-2701_rp = ls_final-2701_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SU4000'.
          ls_final-2702_rp = ls_final-2702_rp + ls_rp2_1-hslvt.
        ELSEIF lv_prctr = 'SU5000'.
          ls_final-2703_rp = ls_final-2703_rp + ls_rp2_1-hslvt.
      endif.
       ls_final-total_rp =  ls_final-0301_rp +  ls_final-0401_rp +  ls_final-0601_rp +  ls_final-0602_rp +  ls_final-0701_rp +  ls_final-0702_rp +  ls_final-0703_rp +  ls_final-0801_rp +  ls_final-0802_rp + ls_final-0803_rp
        +  ls_final-0901_rp +  ls_final-0902_rp +  ls_final-0903_rp +  ls_final-0904_rp +  ls_final-0905_rp +  ls_final-1801_rp + ls_final-1901_rp +  ls_final-1902_rp +  ls_final-2101_rp +  ls_final-2201_rp +  ls_final-2301_rp
        +  ls_final-2302_rp +  ls_final-2303_rp +  ls_final-2304_rp +  ls_final-2351_rp +  ls_final-2401_rp +  ls_final-2402_rp +  ls_final-2403_rp +  ls_final-2404_rp +  ls_final-2405_rp +  ls_final-2406_rp +  ls_final-2407_rp
        +  ls_final-2408_rp +  ls_final-2451_rp +  ls_final-2452_rp +  ls_final-2453_rp +  ls_final-2454_rp +  ls_final-2455_rp +  ls_final-2456_rp +  ls_final-2457_rp +  ls_final-2458_rp +  ls_final-2459_rp +  ls_final-2701_rp
        +  ls_final-2702_rp +  ls_final-2703_rp +  ls_final-2704_rp +  ls_final-2705_rp +  ls_final-2706_rp +  ls_final-2707_rp +  ls_final-2711_rp +  ls_final-2712_rp +  ls_final-2713_rp +  ls_final-2714_rp +  ls_final-2715_rp
        +  ls_final-2716_rp +  ls_final-2717_rp +  ls_final-2718_rp +  ls_final-2719_rp +  ls_final-2720_rp +  ls_final-2721_rp + ls_final-2722_rp +  ls_final-2723_rp +  ls_final-2724_rp +  ls_final-2725_rp +  ls_final-2726_rp
        +  ls_final-2727_rp +  ls_final-2728_rp +  ls_final-2729_rp +  ls_final-2730_rp +  ls_final-2731_rp +  ls_final-2751_rp +  ls_final-2752_rp +  ls_final-2753_rp +  ls_final-2754_rp +  ls_final-2755_rp + ls_final-2756_rp
        +  ls_final-2757_rp +  ls_final-2758_rp +  ls_final-2759_rp +  ls_final-2760_rp +  ls_final-2901_rp +  ls_final-2902_rp + ls_final-2903_rp +  ls_final-2904_rp +  ls_final-2905_rp +  ls_final-2906_rp +  ls_final-2951_rp
        +  ls_final-2952_rp +  ls_final-2953_rp +  ls_final-2954_rp +  ls_final-2955_rp +  ls_final-2956_rp + ls_final-2957_rp +  ls_final-2958_rp + ls_final-2959_rp + ls_final-2960_rp + ls_final-2961_rp + ls_final-2962_rp +
         ls_final-2963_rp +  ls_final-2964_rp + ls_final-3001_rp + ls_final-3002_rp + ls_final-3201_rp + ls_final-3202_rp + ls_final-3203_rp + ls_final-3204_rp +  ls_final-3205_rp + ls_final-3251_rp + ls_final-3252_rp +
          ls_final-3301_rp + ls_final-3302_rp + ls_final-3303_rp + ls_final-3304_rp + ls_final-3351_rp + ls_final-3352_rp + ls_final-3353_rp + ls_final-3354_rp + ls_final-3355_rp + ls_final-3356_rp + ls_final-3357_rp +  ls_final-3358_rp
        + ls_final-3359_rp +  ls_final-3451_rp + ls_final-3601_rp + ls_final-3602_rp + ls_final-3603_rp + ls_final-3604_rp + ls_final-3651_rp + ls_final-3652_rp + ls_final-3653_rp + ls_final-3701_rp + ls_final-3702_rp + ls_final-3703_rp
        +  ls_final-3704_rp + ls_final-3705_rp + ls_final-3751_rp + ls_final-0302_rp + ls_final-0501_rp + ls_final-0603_rp + ls_final-0704_rp + ls_final-2102_rp + ls_final-2202_rp + ls_final-3360_rp + ls_final-3361_rp + ls_final-3400_rp
        + ls_final-3605_rp + ls_final-3706_rp + ls_final-3707_rp.

        CLEAR : lv_prctr,ls_rp2_1-hslvt.
        endloop.
     endif.

       if lt_cp2 is NOT INITIAL.
      LOOP AT lt_cp2 INTO ls_cp2 WHERE racct = ls_final-saknr.
*        DATA : l_prctr(4) TYPE c.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_cp2-prctr
          IMPORTING
            output = l_prctr.
*        l_prctr = ls_cp2-prctr.
 SHIFT l_prctr LEFT DELETING LEADING '0'.
         IF  l_prctr = '101010'.
          ls_final-0301_cp = ls_final-0301_cp + ls_cp2-hsl.
        ELSEIF  l_prctr = '101020'.
          ls_final-0302_cp = ls_final-0302_cp + ls_cp2-hsl.
        ELSEIF l_prctr = '102010'.
          ls_final-0401_cp = ls_final-0401_cp + ls_cp2-hsl.
        ELSEIF l_prctr = '102020'.
          ls_final-0501_cp = ls_final-0501_cp + ls_cp2-hsl.
        ELSEIF l_prctr = '103010'.
          ls_final-0601_cp = ls_final-0601_cp + ls_cp2-hsl.
        ELSEIF l_prctr = '200010'.
          ls_final-0602_cp = ls_final-0602_cp + ls_cp2-hsl.
        ELSEIF l_prctr = '200020'.
          ls_final-0603_cp = ls_final-0603_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'DUMMY_DELV'.
          ls_final-0701_cp = ls_final-0701_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'HU01-DUMMY'.
          ls_final-0702_cp = ls_final-0702_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_01'.
          ls_final-0703_cp = ls_final-0703_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_02'.
          ls_final-0704_cp = ls_final-0704_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_03'.
          ls_final-0801_cp = ls_final-0801_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_04'.
          ls_final-0802_cp = ls_final-0802_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_05'.
          ls_final-0803_cp = ls_final-0803_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_06'.
          ls_final-0901_cp = ls_final-0901_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_07'.
          ls_final-0902_cp = ls_final-0902_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_08'.
          ls_final-0903_cp = ls_final-0903_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_09'.
          ls_final-0904_cp = ls_final-0904_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_10'.
          ls_final-0905_cp = ls_final-0905_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS01_11'.
          ls_final-1801_cp = ls_final-1801_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_01'.
          ls_final-1901_cp = ls_final-1901_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_02'.
          ls_final-1902_cp = ls_final-1902_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_03'.
          ls_final-2101_cp = ls_final-2101_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_04'.
          ls_final-2102_cp = ls_final-2102_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_05'.
          ls_final-2201_cp = ls_final-2201_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_06'.
          ls_final-2202_cp = ls_final-2202_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_07'.
          ls_final-2301_cp = ls_final-2301_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_08'.
          ls_final-2302_cp = ls_final-2302_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_09'.
          ls_final-2303_cp = ls_final-2303_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_10'.
          ls_final-2304_cp = ls_final-2304_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS02_11'.
          ls_final-2351_cp = ls_final-2351_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_01'.
          ls_final-2401_cp = ls_final-2401_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_02'.
          ls_final-2402_cp = ls_final-2402_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_03'.
          ls_final-2403_cp = ls_final-2403_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_04'.
          ls_final-2404_cp = ls_final-2404_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_05'.
          ls_final-2405_cp = ls_final-2405_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_06'.
          ls_final-2406_cp = ls_final-2406_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_07'.
          ls_final-2407_cp = ls_final-2407_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_08'.
          ls_final-2408_cp = ls_final-2408_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_09'.
          ls_final-2451_cp = ls_final-2451_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_10'.
          ls_final-2452_cp = ls_final-2452_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'PRUS03_11'.
          ls_final-2453_cp = ls_final-2453_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'RECO-DUMMY'.
          ls_final-2454_cp = ls_final-2454_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SAP-DUMMY'.
          ls_final-2455_cp = ls_final-2455_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SU1010'.
          ls_final-2456_cp = ls_final-2456_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SU1020'.
          ls_final-2457_cp = ls_final-2457_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SU2010'.
          ls_final-2458_cp = ls_final-2458_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SU2020'.
          ls_final-2459_cp = ls_final-2459_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SU3010'.
          ls_final-2701_cp = ls_final-2701_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SU4000'.
          ls_final-2702_cp = ls_final-2702_cp + ls_cp2-hsl.
        ELSEIF l_prctr = 'SU5000'.
          ls_final-2703_cp = ls_final-2703_cp + ls_cp2-hsl.

        ENDIF.

        ls_final-total_cp =  ls_final-0301_cp +  ls_final-0401_cp +  ls_final-0601_cp +  ls_final-0602_cp +  ls_final-0701_cp +  ls_final-0702_cp +  ls_final-0703_cp +  ls_final-0801_cp +  ls_final-0802_cp + ls_final-0803_cp
              +  ls_final-0901_cp +  ls_final-0902_cp +  ls_final-0903_cp +  ls_final-0904_cp +  ls_final-0905_cp +  ls_final-1801_cp + ls_final-1901_cp +  ls_final-1902_cp +  ls_final-2101_cp +  ls_final-2201_cp +  ls_final-2301_cp
              +  ls_final-2302_cp +  ls_final-2303_cp +  ls_final-2304_cp +  ls_final-2351_cp +  ls_final-2401_cp +  ls_final-2402_cp +  ls_final-2403_cp +  ls_final-2404_cp +  ls_final-2405_cp +  ls_final-2406_cp +  ls_final-2407_cp
              +  ls_final-2408_cp +  ls_final-2451_cp +  ls_final-2452_cp +  ls_final-2453_cp +  ls_final-2454_cp +  ls_final-2455_cp +  ls_final-2456_cp +  ls_final-2457_cp +  ls_final-2458_cp +  ls_final-2459_cp +  ls_final-2701_cp
              +  ls_final-2702_cp +  ls_final-2703_cp +  ls_final-2704_cp +  ls_final-2705_cp +  ls_final-2706_cp +  ls_final-2707_cp +  ls_final-2711_cp +  ls_final-2712_cp +  ls_final-2713_cp +  ls_final-2714_cp +  ls_final-2715_cp
              +  ls_final-2716_cp +  ls_final-2717_cp +  ls_final-2718_cp +  ls_final-2719_cp +  ls_final-2720_cp +  ls_final-2721_cp + ls_final-2722_cp +  ls_final-2723_cp +  ls_final-2724_cp +  ls_final-2725_cp +  ls_final-2726_cp
              +  ls_final-2727_cp +  ls_final-2728_cp +  ls_final-2729_cp +  ls_final-2730_cp +  ls_final-2731_cp +  ls_final-2751_cp +  ls_final-2752_cp +  ls_final-2753_cp +  ls_final-2754_cp +  ls_final-2755_cp + ls_final-2756_cp
              +  ls_final-2757_cp +  ls_final-2758_cp +  ls_final-2759_cp +  ls_final-2760_cp +  ls_final-2901_cp +  ls_final-2902_cp + ls_final-2903_cp +  ls_final-2904_cp +  ls_final-2905_cp +  ls_final-2906_cp +  ls_final-2951_cp
              +  ls_final-2952_cp +  ls_final-2953_cp +  ls_final-2954_cp +  ls_final-2955_cp +  ls_final-2956_cp + ls_final-2957_cp +  ls_final-2958_cp + ls_final-2959_cp + ls_final-2960_cp + ls_final-2961_cp + ls_final-2962_cp +
               ls_final-2963_cp +  ls_final-2964_cp + ls_final-3001_cp + ls_final-3002_cp + ls_final-3201_cp + ls_final-3202_cp + ls_final-3203_cp + ls_final-3204_cp +  ls_final-3205_cp + ls_final-3251_cp + ls_final-3252_cp +
                ls_final-3301_cp + ls_final-3302_cp + ls_final-3303_cp + ls_final-3304_cp + ls_final-3351_cp + ls_final-3352_cp + ls_final-3353_cp + ls_final-3354_cp + ls_final-3355_cp + ls_final-3356_cp + ls_final-3357_cp +  ls_final-3358_cp
              + ls_final-3359_cp +  ls_final-3451_cp + ls_final-3601_cp + ls_final-3602_cp + ls_final-3603_cp + ls_final-3604_cp + ls_final-3651_cp + ls_final-3652_cp + ls_final-3653_cp + ls_final-3701_cp + ls_final-3702_cp + ls_final-3703_cp
              +  ls_final-3704_cp + ls_final-3705_cp + ls_final-3751_cp + ls_final-0302_cp + ls_final-0501_cp + ls_final-0603_cp + ls_final-0704_cp + ls_final-2102_cp + ls_final-2202_cp + ls_final-3360_cp + ls_final-3361_cp + ls_final-3400_cp
              + ls_final-3605_cp + ls_final-3706_cp + ls_final-3707_cp.

        CLEAR: l_prctr , ls_cp2-hsl.
      ENDLOOP.
      else.
           LOOP AT lt_cp2_1 INTO ls_cp2_1 WHERE racct = ls_final-saknr.
*        DATA : l_prctr(4) TYPE c.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_cp2_1-prctr
          IMPORTING
            output = l_prctr.
*        l_prctr = ls_cp2-prctr.
      SHIFT l_prctr LEFT DELETING LEADING '0'.
         IF  l_prctr = '101010'.
          ls_final-0301_cp = ls_final-0301_cp + ls_cp2_1-hslvt.
        ELSEIF  l_prctr = '101020'.
          ls_final-0302_cp = ls_final-0302_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = '102010'.
          ls_final-0401_cp = ls_final-0401_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = '102020'.
          ls_final-0501_cp = ls_final-0501_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = '103010'.
          ls_final-0601_cp = ls_final-0601_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = '200010'.
          ls_final-0602_cp = ls_final-0602_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = '200020'.
          ls_final-0603_cp = ls_final-0603_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'DUMMY_DELV'.
          ls_final-0701_cp = ls_final-0701_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'HU01-DUMMY'.
          ls_final-0702_cp = ls_final-0702_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_01'.
          ls_final-0703_cp = ls_final-0703_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_02'.
          ls_final-0704_cp = ls_final-0704_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_03'.
          ls_final-0801_cp = ls_final-0801_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_04'.
          ls_final-0802_cp = ls_final-0802_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_05'.
          ls_final-0803_cp = ls_final-0803_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_06'.
          ls_final-0901_cp = ls_final-0901_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_07'.
          ls_final-0902_cp = ls_final-0902_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_08'.
          ls_final-0903_cp = ls_final-0903_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_09'.
          ls_final-0904_cp = ls_final-0904_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_10'.
          ls_final-0905_cp = ls_final-0905_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS01_11'.
          ls_final-1801_cp = ls_final-1801_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_01'.
          ls_final-1901_cp = ls_final-1901_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_02'.
          ls_final-1902_cp = ls_final-1902_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_03'.
          ls_final-2101_cp = ls_final-2101_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_04'.
          ls_final-2102_cp = ls_final-2102_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_05'.
          ls_final-2201_cp = ls_final-2201_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_06'.
          ls_final-2202_cp = ls_final-2202_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_07'.
          ls_final-2301_cp = ls_final-2301_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_08'.
          ls_final-2302_cp = ls_final-2302_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_09'.
          ls_final-2303_cp = ls_final-2303_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_10'.
          ls_final-2304_cp = ls_final-2304_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS02_11'.
          ls_final-2351_cp = ls_final-2351_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_01'.
          ls_final-2401_cp = ls_final-2401_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_02'.
          ls_final-2402_cp = ls_final-2402_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_03'.
          ls_final-2403_cp = ls_final-2403_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_04'.
          ls_final-2404_cp = ls_final-2404_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_05'.
          ls_final-2405_cp = ls_final-2405_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_06'.
          ls_final-2406_cp = ls_final-2406_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_07'.
          ls_final-2407_cp = ls_final-2407_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_08'.
          ls_final-2408_cp = ls_final-2408_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_09'.
          ls_final-2451_cp = ls_final-2451_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_10'.
          ls_final-2452_cp = ls_final-2452_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'PRUS03_11'.
          ls_final-2453_cp = ls_final-2453_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'RECO-DUMMY'.
          ls_final-2454_cp = ls_final-2454_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SAP-DUMMY'.
          ls_final-2455_cp = ls_final-2455_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SU1010'.
          ls_final-2456_cp = ls_final-2456_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SU1020'.
          ls_final-2457_cp = ls_final-2457_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SU2010'.
          ls_final-2458_cp = ls_final-2458_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SU2020'.
          ls_final-2459_cp = ls_final-2459_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SU3010'.
          ls_final-2701_cp = ls_final-2701_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SU4000'.
          ls_final-2702_cp = ls_final-2702_cp + ls_cp2_1-hslvt.
        ELSEIF l_prctr = 'SU5000'.
          ls_final-2703_cp = ls_final-2703_cp + ls_cp2_1-hslvt.
      endif.


         ls_final-total_cp =  ls_final-0301_cp +  ls_final-0401_cp +  ls_final-0601_cp +  ls_final-0602_cp +  ls_final-0701_cp +  ls_final-0702_cp +  ls_final-0703_cp +  ls_final-0801_cp +  ls_final-0802_cp + ls_final-0803_cp
              +  ls_final-0901_cp +  ls_final-0902_cp +  ls_final-0903_cp +  ls_final-0904_cp +  ls_final-0905_cp +  ls_final-1801_cp + ls_final-1901_cp +  ls_final-1902_cp +  ls_final-2101_cp +  ls_final-2201_cp +  ls_final-2301_cp
              +  ls_final-2302_cp +  ls_final-2303_cp +  ls_final-2304_cp +  ls_final-2351_cp +  ls_final-2401_cp +  ls_final-2402_cp +  ls_final-2403_cp +  ls_final-2404_cp +  ls_final-2405_cp +  ls_final-2406_cp +  ls_final-2407_cp
              +  ls_final-2408_cp +  ls_final-2451_cp +  ls_final-2452_cp +  ls_final-2453_cp +  ls_final-2454_cp +  ls_final-2455_cp +  ls_final-2456_cp +  ls_final-2457_cp +  ls_final-2458_cp +  ls_final-2459_cp +  ls_final-2701_cp
              +  ls_final-2702_cp +  ls_final-2703_cp +  ls_final-2704_cp +  ls_final-2705_cp +  ls_final-2706_cp +  ls_final-2707_cp +  ls_final-2711_cp +  ls_final-2712_cp +  ls_final-2713_cp +  ls_final-2714_cp +  ls_final-2715_cp
              +  ls_final-2716_cp +  ls_final-2717_cp +  ls_final-2718_cp +  ls_final-2719_cp +  ls_final-2720_cp +  ls_final-2721_cp + ls_final-2722_cp +  ls_final-2723_cp +  ls_final-2724_cp +  ls_final-2725_cp +  ls_final-2726_cp
              +  ls_final-2727_cp +  ls_final-2728_cp +  ls_final-2729_cp +  ls_final-2730_cp +  ls_final-2731_cp +  ls_final-2751_cp +  ls_final-2752_cp +  ls_final-2753_cp +  ls_final-2754_cp +  ls_final-2755_cp + ls_final-2756_cp
              +  ls_final-2757_cp +  ls_final-2758_cp +  ls_final-2759_cp +  ls_final-2760_cp +  ls_final-2901_cp +  ls_final-2902_cp + ls_final-2903_cp +  ls_final-2904_cp +  ls_final-2905_cp +  ls_final-2906_cp +  ls_final-2951_cp
              +  ls_final-2952_cp +  ls_final-2953_cp +  ls_final-2954_cp +  ls_final-2955_cp +  ls_final-2956_cp + ls_final-2957_cp +  ls_final-2958_cp + ls_final-2959_cp + ls_final-2960_cp + ls_final-2961_cp + ls_final-2962_cp +
               ls_final-2963_cp +  ls_final-2964_cp + ls_final-3001_cp + ls_final-3002_cp + ls_final-3201_cp + ls_final-3202_cp + ls_final-3203_cp + ls_final-3204_cp +  ls_final-3205_cp + ls_final-3251_cp + ls_final-3252_cp +
                ls_final-3301_cp + ls_final-3302_cp + ls_final-3303_cp + ls_final-3304_cp + ls_final-3351_cp + ls_final-3352_cp + ls_final-3353_cp + ls_final-3354_cp + ls_final-3355_cp + ls_final-3356_cp + ls_final-3357_cp +  ls_final-3358_cp
              + ls_final-3359_cp +  ls_final-3451_cp + ls_final-3601_cp + ls_final-3602_cp + ls_final-3603_cp + ls_final-3604_cp + ls_final-3651_cp + ls_final-3652_cp + ls_final-3653_cp + ls_final-3701_cp + ls_final-3702_cp + ls_final-3703_cp
              +  ls_final-3704_cp + ls_final-3705_cp + ls_final-3751_cp + ls_final-0302_cp + ls_final-0501_cp + ls_final-0603_cp + ls_final-0704_cp + ls_final-2102_cp + ls_final-2202_cp + ls_final-3360_cp + ls_final-3361_cp + ls_final-3400_cp
              + ls_final-3605_cp + ls_final-3706_cp + ls_final-3707_cp.

        CLEAR: l_prctr , ls_cp2_1-hslvt.
        endloop.
          ENDIF.
      APPEND : ls_final TO lt_final.
      CLEAR : ls_final, ls_skb1, ls_ska1_1.

    ENDLOOP.
    endif.




  DELETE lt_final WHERE 0301_rp IS INITIAL AND
  0301_cp IS INITIAL AND
  0302_rp IS INITIAL AND
  0302_cp IS INITIAL AND
  0401_rp IS INITIAL AND
  0401_cp IS INITIAL AND
  0501_rp IS INITIAL AND
  0501_cp IS INITIAL AND
  0601_rp IS INITIAL AND
  0601_cp IS INITIAL AND
  0602_rp IS INITIAL AND
  0602_cp IS INITIAL AND
  0603_rp IS INITIAL AND
  0603_cp IS INITIAL AND
  0701_rp IS INITIAL AND
  0701_cp IS INITIAL AND
  0702_rp IS INITIAL AND
  0702_cp IS INITIAL AND
  0703_rp IS INITIAL AND
  0703_cp IS INITIAL AND
  0704_rp IS INITIAL AND
  0704_cp IS INITIAL AND
  0801_rp IS INITIAL AND
  0801_cp IS INITIAL AND
  0802_rp IS INITIAL AND
  0802_cp IS INITIAL AND
  0803_rp IS INITIAL AND
  0803_cp IS INITIAL AND
  0901_rp IS INITIAL AND
  0901_cp IS INITIAL AND
  0902_rp IS INITIAL AND
  0902_cp IS INITIAL AND
  0903_rp IS INITIAL AND
  0903_cp IS INITIAL AND
  0904_rp IS INITIAL AND
  0904_cp IS INITIAL AND
  0905_rp IS INITIAL AND
  0905_cp IS INITIAL AND
  1801_rp IS INITIAL AND
  1801_cp IS INITIAL AND
  1901_rp IS INITIAL AND
  1901_cp IS INITIAL AND
  1902_rp IS INITIAL AND
  1902_cp IS INITIAL AND
  2101_rp IS INITIAL AND
  2101_cp IS INITIAL AND
  2102_rp IS INITIAL AND
  2102_cp IS INITIAL AND
  2201_rp IS INITIAL AND
  2201_cp IS INITIAL AND
  2202_rp IS INITIAL AND
  2202_cp IS INITIAL AND
  2301_rp IS INITIAL AND
  2301_cp IS INITIAL AND
  2302_rp IS INITIAL AND
  2302_cp IS INITIAL AND
  2303_rp IS INITIAL AND
  2303_cp IS INITIAL AND
  2304_rp IS INITIAL AND
  2304_cp IS INITIAL AND
  2351_rp IS INITIAL AND
  2351_cp IS INITIAL AND
  2401_rp IS INITIAL AND
  2401_cp IS INITIAL AND
  2402_rp IS INITIAL AND
  2402_cp IS INITIAL AND
  2403_rp IS INITIAL AND
  2403_cp IS INITIAL AND
  2404_rp IS INITIAL AND
  2404_cp IS INITIAL AND
  2405_rp IS INITIAL AND
  2405_cp IS INITIAL AND
  2406_rp IS INITIAL AND
  2406_cp IS INITIAL AND
  2407_rp IS INITIAL AND
  2407_cp IS INITIAL AND
  2408_rp IS INITIAL AND
  2408_cp IS INITIAL AND
  2451_rp IS INITIAL AND
  2451_cp IS INITIAL AND
  2452_rp IS INITIAL AND
  2452_cp IS INITIAL AND
  2453_rp IS INITIAL AND
  2453_cp IS INITIAL AND
  2454_rp IS INITIAL AND
  2454_cp IS INITIAL AND
  2455_rp IS INITIAL AND
  2455_cp IS INITIAL AND
  2456_rp IS INITIAL AND
  2456_cp IS INITIAL AND
  2457_rp IS INITIAL AND
  2457_cp IS INITIAL AND
  2458_rp IS INITIAL AND
  2458_cp IS INITIAL AND
  2459_rp IS INITIAL AND
  2459_cp IS INITIAL AND
  2701_rp IS INITIAL AND
  2701_cp IS INITIAL AND
  2702_rp IS INITIAL AND
  2702_cp IS INITIAL AND
  2703_rp IS INITIAL AND
  2703_cp IS INITIAL AND
  2704_rp IS INITIAL AND
  2704_cp IS INITIAL AND
  2705_rp IS INITIAL AND
  2705_cp IS INITIAL AND
  2706_rp IS INITIAL AND
  2706_cp IS INITIAL AND
  2707_rp IS INITIAL AND
  2707_cp IS INITIAL AND
  2711_rp IS INITIAL AND
  2711_cp IS INITIAL AND
  2712_rp IS INITIAL AND
  2712_cp IS INITIAL AND
  2713_rp IS INITIAL AND
  2713_cp IS INITIAL AND
  2714_rp IS INITIAL AND
  2714_cp IS INITIAL AND
  2715_rp IS INITIAL AND
  2715_cp IS INITIAL AND
  2716_rp IS INITIAL AND
  2716_cp IS INITIAL AND
  2717_rp IS INITIAL AND
  2717_cp IS INITIAL AND
  2718_rp IS INITIAL AND
  2718_cp IS INITIAL AND
  2719_rp IS INITIAL AND
  2719_cp IS INITIAL AND
  2720_rp IS INITIAL AND
  2720_cp IS INITIAL AND
  2721_rp IS INITIAL AND
  2721_cp IS INITIAL AND
  2722_rp IS INITIAL AND
  2722_cp IS INITIAL AND
  2723_rp IS INITIAL AND
  2723_cp IS INITIAL AND
  2724_rp IS INITIAL AND
  2724_cp IS INITIAL AND
  2725_rp IS INITIAL AND
  2725_cp IS INITIAL AND
  2726_rp IS INITIAL AND
  2726_cp IS INITIAL AND
  2727_rp IS INITIAL AND
  2727_cp IS INITIAL AND
  2728_rp IS INITIAL AND
  2728_cp IS INITIAL AND
  2729_rp IS INITIAL AND
  2729_cp IS INITIAL AND
  2730_rp IS INITIAL AND
  2730_cp IS INITIAL AND
  2731_rp IS INITIAL AND
  2731_cp IS INITIAL AND
  2751_rp IS INITIAL AND
  2751_cp IS INITIAL AND
  2752_rp IS INITIAL AND
  2752_cp IS INITIAL AND
  2753_rp IS INITIAL AND
  2753_cp IS INITIAL AND
  2754_rp IS INITIAL AND
  2754_cp IS INITIAL AND
  2755_rp IS INITIAL AND
  2755_cp IS INITIAL AND
  2756_rp IS INITIAL AND
  2756_cp IS INITIAL AND
  2757_rp IS INITIAL AND
  2757_cp IS INITIAL AND
  2758_rp IS INITIAL AND
  2758_cp IS INITIAL AND
  2759_rp IS INITIAL AND
  2759_cp IS INITIAL AND
  2760_rp IS INITIAL AND
  2760_cp IS INITIAL AND
  2901_rp IS INITIAL AND
  2901_cp IS INITIAL AND
  2902_rp IS INITIAL AND
  2902_cp IS INITIAL AND
  2903_rp IS INITIAL AND
  2903_cp IS INITIAL AND
  2904_rp IS INITIAL AND
  2904_cp IS INITIAL AND
  2905_rp IS INITIAL AND
  2905_cp IS INITIAL AND
  2906_rp IS INITIAL AND
  2906_cp IS INITIAL AND
  2951_rp IS INITIAL AND
  2951_cp IS INITIAL AND
  2952_rp IS INITIAL AND
  2952_cp IS INITIAL AND
  2953_rp IS INITIAL AND
  2953_cp IS INITIAL AND
  2954_rp IS INITIAL AND
  2954_cp IS INITIAL AND
  2955_rp IS INITIAL AND
  2955_cp IS INITIAL AND
  2956_rp IS INITIAL AND
  2956_cp IS INITIAL AND
  2957_rp IS INITIAL AND
  2957_cp IS INITIAL AND
  2958_rp IS INITIAL AND
  2958_cp IS INITIAL AND
  2959_rp IS INITIAL AND
  2959_cp IS INITIAL AND
  2960_rp IS INITIAL AND
  2960_cp IS INITIAL AND
  2961_rp IS INITIAL AND
  2961_cp IS INITIAL AND
  2962_rp IS INITIAL AND
  2962_cp IS INITIAL AND
  2963_rp IS INITIAL AND
  2963_cp IS INITIAL AND
  2964_rp IS INITIAL AND
  2964_cp IS INITIAL AND
  3001_rp IS INITIAL AND
  3001_cp IS INITIAL AND
  1903_cp IS INITIAL AND
  3002_rp IS INITIAL AND
  3002_cp IS INITIAL AND
  3201_rp IS INITIAL AND
  3201_cp IS INITIAL AND
  3202_rp IS INITIAL AND
  3202_cp IS INITIAL AND
  3203_rp IS INITIAL AND
  3203_cp IS INITIAL AND
  3204_rp IS INITIAL AND
  3204_cp IS INITIAL AND
  3205_rp IS INITIAL AND
  3205_cp IS INITIAL AND
  3251_rp IS INITIAL AND
  3251_cp IS INITIAL AND
  3252_rp IS INITIAL AND
  3252_cp IS INITIAL AND
  3301_rp IS INITIAL AND
  3301_cp IS INITIAL AND
  3302_rp IS INITIAL AND
  3302_cp IS INITIAL AND
  3303_rp IS INITIAL AND
  3303_cp IS INITIAL AND
  3304_rp IS INITIAL AND
  3304_cp IS INITIAL AND
  3351_rp IS INITIAL AND
  3351_cp IS INITIAL AND
  3352_rp IS INITIAL AND
  3352_cp IS INITIAL AND
  3353_rp IS INITIAL AND
  3353_cp IS INITIAL AND
  3354_rp IS INITIAL AND
  3354_cp IS INITIAL AND
  3355_rp IS INITIAL AND
  3355_cp IS INITIAL AND
  3356_rp IS INITIAL AND
  3356_cp IS INITIAL AND
  3357_rp IS INITIAL AND
  3357_cp IS INITIAL AND
  3358_rp IS INITIAL AND
  3358_cp IS INITIAL AND
  3359_rp IS INITIAL AND
  3359_cp IS INITIAL AND
  3360_rp IS INITIAL AND
  3360_cp IS INITIAL AND
  3361_rp IS INITIAL AND
  3361_cp IS INITIAL AND
  3400_rp IS INITIAL AND
  3400_cp IS INITIAL AND
  3451_rp IS INITIAL AND
  3451_cp IS INITIAL AND
  3601_rp IS INITIAL AND
  3601_cp IS INITIAL AND
  3602_rp IS INITIAL AND
  3602_cp IS INITIAL AND
  3603_rp IS INITIAL AND
  3603_cp IS INITIAL AND
  3604_rp IS INITIAL AND
  3604_cp IS INITIAL AND
  3605_rp IS INITIAL AND
  3605_cp IS INITIAL AND
  3651_rp IS INITIAL AND
  3651_cp IS INITIAL AND
  3652_rp IS INITIAL AND
  3652_cp IS INITIAL AND
  3653_rp IS INITIAL AND
  3653_cp IS INITIAL AND
  3701_rp IS INITIAL AND
  3701_cp IS INITIAL AND
  3702_rp IS INITIAL AND
  3702_cp IS INITIAL AND
  3703_rp IS INITIAL AND
  3703_cp IS INITIAL AND
  3704_rp IS INITIAL AND
  3704_cp IS INITIAL AND
  3705_rp IS INITIAL AND
  3705_cp IS INITIAL AND
  3706_rp IS INITIAL AND
  3706_cp IS INITIAL AND
  3707_rp IS INITIAL AND
  3707_cp IS INITIAL AND
  3751_rp IS INITIAL AND
  3751_cp IS INITIAL AND
  total_rp IS INITIAL AND
  total_cp IS INITIAL .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .

*  DATA : cnt TYPE sy-index.
*  CLEAR: cnt.
*  cnt = 0.

  lt_final_1[] = lt_final[].
*LOOP AT LT_FINAL INTO LS_FINAL.

*  ADD 1 TO cnt.
  wa_fieldcat-col_pos   = '1'.
  wa_fieldcat-fieldname = 'BUKRS'.
  wa_fieldcat-seltext_l = 'Comapany Code'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  ADD 1 TO cnt.
  wa_fieldcat-col_pos   = '2'.
  wa_fieldcat-fieldname = 'SAKNR'.
  wa_fieldcat-seltext_l = 'G/L Account'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  ADD 1 TO cnt.
  wa_fieldcat-col_pos   = '3'.
  wa_fieldcat-fieldname = 'TXT50'.
  wa_fieldcat-seltext_l = 'G/L Acct Long Text'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  LOOP AT lt_final INTO ls_final.
    READ TABLE lt_final_1 INTO ls_final_1 WITH KEY saknr = ls_final-saknr.

    IF ls_final-0301_rp IS NOT INITIAL .

      wa_fieldcat-col_pos   = '4'.
      wa_fieldcat-fieldname = '0301_RP '.
      wa_fieldcat-seltext_l = '101010 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0301_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '5'.
      wa_fieldcat-fieldname = '0301_CP '.
      wa_fieldcat-seltext_l = '101010 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0302_rp IS NOT INITIAL .

      wa_fieldcat-col_pos   = '6'.
      wa_fieldcat-fieldname = '0302_RP '.
      wa_fieldcat-seltext_l = '101020 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0302_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '7'.
      wa_fieldcat-fieldname = '0302_CP '.
      wa_fieldcat-seltext_l = '101020 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0401_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '8'.
      wa_fieldcat-fieldname = '0401_RP '.
      wa_fieldcat-seltext_l = '102010 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0401_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '9'.
      wa_fieldcat-fieldname = '0401_CP '.
      wa_fieldcat-seltext_l = '102010 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0501_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '10'.
      wa_fieldcat-fieldname = '0501_RP '.
      wa_fieldcat-seltext_l = '102020 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0501_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '11'.
      wa_fieldcat-fieldname = '0501_CP '.
      wa_fieldcat-seltext_l = '102020 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0601_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '12'.
      wa_fieldcat-fieldname = '0601_RP '.
      wa_fieldcat-seltext_l = '103010 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0601_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '13'.
      wa_fieldcat-fieldname = '0601_CP '.
      wa_fieldcat-seltext_l = '103010 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0602_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '14'.
      wa_fieldcat-fieldname = '0602_RP '.
      wa_fieldcat-seltext_l = '200010 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0602_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '15'.
      wa_fieldcat-fieldname = '0602_CP '.
      wa_fieldcat-seltext_l = '200010 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0603_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '16'.
      wa_fieldcat-fieldname = '0603_RP '.
      wa_fieldcat-seltext_l = '200020 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0603_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '17'.
      wa_fieldcat-fieldname = '0603_CP '.
      wa_fieldcat-seltext_l = '200020 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0701_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '18'.
      wa_fieldcat-fieldname = '0701_RP '.
      wa_fieldcat-seltext_l = 'DUMMY_DELV Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0701_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '19'.
      wa_fieldcat-fieldname = '0701_CP '.
      wa_fieldcat-seltext_l = 'DUMMY_DELV Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0702_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '20'.
      wa_fieldcat-fieldname = '0702_RP '.
      wa_fieldcat-seltext_l = 'HU01-DUMMY Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0702_cp IS NOT INITIAL.

      wa_fieldcat-col_pos   = '21'.
      wa_fieldcat-fieldname = '0702_CP '.
      wa_fieldcat-seltext_l = 'HU01-DUMMY Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0703_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '22'.
      wa_fieldcat-fieldname = '0703_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_01 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0703_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '23'.
      wa_fieldcat-fieldname = '0703_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_01 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0704_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '24'.
      wa_fieldcat-fieldname = '0704_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_02 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0704_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '25'.
      wa_fieldcat-fieldname = '0704_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_02 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0801_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '26'.
      wa_fieldcat-fieldname = '0801_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_03 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0801_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '27'.
      wa_fieldcat-fieldname = '0801_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_03 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0802_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '28'.
      wa_fieldcat-fieldname = '0802_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_04 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0802_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '29'.
      wa_fieldcat-fieldname = '0802_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_04 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0803_rp IS NOT INITIAL.

      wa_fieldcat-col_pos   = '30'.
      wa_fieldcat-fieldname = '0803_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_05 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0803_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '31'.
      wa_fieldcat-fieldname = '0803_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_05 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0901_rp IS NOT INITIAL .

      wa_fieldcat-col_pos   = '32'.
      wa_fieldcat-fieldname = '0901_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_06 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0901_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '33'.
      wa_fieldcat-fieldname = '0901_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_06 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0902_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '34'.
      wa_fieldcat-fieldname = '0902_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_07 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0902_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '35'.
      wa_fieldcat-fieldname = '0902_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_07 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0903_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '36'.
      wa_fieldcat-fieldname = '0903_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_08 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0903_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '37'.
      wa_fieldcat-fieldname = '0903_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_08 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0904_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '38'.
      wa_fieldcat-fieldname = '0904_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_09 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0904_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '39'.
      wa_fieldcat-fieldname = '0904_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_09 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-0905_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '40'.
      wa_fieldcat-fieldname = '0905_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_10 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-0905_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '41'.
      wa_fieldcat-fieldname = '0905_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_10 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-1801_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '42'.
      wa_fieldcat-fieldname = '1801_RP '.
      wa_fieldcat-seltext_l = 'PRUS01_11 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-1801_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '43'.
      wa_fieldcat-fieldname = '1801_CP '.
      wa_fieldcat-seltext_l = 'PRUS01_11 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-1901_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '44'.
      wa_fieldcat-fieldname = '1901_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_01 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-1901_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '45'.
      wa_fieldcat-fieldname = '1901_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_01 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-1902_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '46'.
      wa_fieldcat-fieldname = '1902_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_02 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-1902_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '47'.
      wa_fieldcat-fieldname = '1902_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_02 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2101_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '48'.
      wa_fieldcat-fieldname = '2101_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_03 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2101_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '49'.
      wa_fieldcat-fieldname = '2101_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_03 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2102_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '50'.
      wa_fieldcat-fieldname = '2102_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_04 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2102_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '51'.
      wa_fieldcat-fieldname = '2102_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_04 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2201_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '52'.
      wa_fieldcat-fieldname = '2201_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_05 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF  ls_final-2201_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '53'.
      wa_fieldcat-fieldname = '2201_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_05 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2202_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '54'.
      wa_fieldcat-fieldname = '2202_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_06 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF  ls_final-2202_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '55'.
      wa_fieldcat-fieldname = '2202_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_06 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2301_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '56'.
      wa_fieldcat-fieldname = '2301_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_07 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2301_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '57'.
      wa_fieldcat-fieldname = '2301_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_07 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2302_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '58'.
      wa_fieldcat-fieldname = '2302_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_08 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2302_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '59'.
      wa_fieldcat-fieldname = '2302_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_08 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2303_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '60'.
      wa_fieldcat-fieldname = '2303_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_09 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2303_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '61'.
      wa_fieldcat-fieldname = '2303_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_09 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2303_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '62'.
      wa_fieldcat-fieldname = '2304_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_10 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2303_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '63'.
      wa_fieldcat-fieldname = '2304_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_10 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2351_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '64'.
      wa_fieldcat-fieldname = '2351_RP '.
      wa_fieldcat-seltext_l = 'PRUS02_11 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2351_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '65'.
      wa_fieldcat-fieldname = '2351_CP '.
      wa_fieldcat-seltext_l = 'PRUS02_11 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2401_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '66'.
      wa_fieldcat-fieldname = '2401_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_01 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2401_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '67'.
      wa_fieldcat-fieldname = '2401_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_01 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2402_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '68'.
      wa_fieldcat-fieldname = '2402_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_02 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2402_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '69'.
      wa_fieldcat-fieldname = '2402_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_02 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2403_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '70'.
      wa_fieldcat-fieldname = '2403_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_03 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2403_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '71'.
      wa_fieldcat-fieldname = '2403_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_03 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2404_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '72'.
      wa_fieldcat-fieldname = '2404_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_04 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2404_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '73'.
      wa_fieldcat-fieldname = '2404_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_04 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2405_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '74'.
      wa_fieldcat-fieldname = '2405_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_05 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2405_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '75'.
      wa_fieldcat-fieldname = '2405_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_05 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2406_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '76'.
      wa_fieldcat-fieldname = '2406_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_06  Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2406_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '77'.
      wa_fieldcat-fieldname = '2406_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_06 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2407_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '78'.
      wa_fieldcat-fieldname = '2407_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_07 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2407_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '79'.
      wa_fieldcat-fieldname = '2407_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_07 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2408_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '80'.
      wa_fieldcat-fieldname = '2408_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_08 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

    ENDIF.
    IF ls_final-2408_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '81'.
      wa_fieldcat-fieldname = '2408_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_08 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2451_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '82'.
      wa_fieldcat-fieldname = '2451_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_09 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2451_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '83'.
      wa_fieldcat-fieldname = '2451_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_09 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2452_rp IS NOT INITIAL.

      wa_fieldcat-col_pos   = '84'.
      wa_fieldcat-fieldname = '2452_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_10 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2452_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '85'.
      wa_fieldcat-fieldname = '2452_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_10 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2453_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '86'.
      wa_fieldcat-fieldname = '2453_RP '.
      wa_fieldcat-seltext_l = 'PRUS03_11 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2453_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '87'.
      wa_fieldcat-fieldname = '2453_CP '.
      wa_fieldcat-seltext_l = 'PRUS03_11 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2454_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '88'.
      wa_fieldcat-fieldname = '2454_RP '.
      wa_fieldcat-seltext_l = 'RECO-DUMMY Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2454_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '89'.
      wa_fieldcat-fieldname = '2454_CP '.
      wa_fieldcat-seltext_l = 'RECO-DUMMY Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2455_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '90'.
      wa_fieldcat-fieldname = '2455_RP '.
      wa_fieldcat-seltext_l = 'SAP-DUMMY Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2455_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '91'.
      wa_fieldcat-fieldname = '2455_CP '.
      wa_fieldcat-seltext_l = 'SAP-DUMMY Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2456_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '92'.
      wa_fieldcat-fieldname = '2456_RP '.
      wa_fieldcat-seltext_l = 'SU1010 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2456_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '93'.
      wa_fieldcat-fieldname = '2456_CP '.
      wa_fieldcat-seltext_l = 'SU1010 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2457_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '94'.
      wa_fieldcat-fieldname = '2457_RP '.
      wa_fieldcat-seltext_l = 'SU1020 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2457_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '95'.
      wa_fieldcat-fieldname = '2457_CP '.
      wa_fieldcat-seltext_l = 'SU1020 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2458_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '96'.
      wa_fieldcat-fieldname = '2458_RP '.
      wa_fieldcat-seltext_l = 'SU2010 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2458_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '97'.
      wa_fieldcat-fieldname = '2458_CP '.
      wa_fieldcat-seltext_l = 'SU2010 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2459_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '98'.
      wa_fieldcat-fieldname = '2459_RP '.
      wa_fieldcat-seltext_l = 'SU2020 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2459_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '99'.
      wa_fieldcat-fieldname = '2459_CP '.
      wa_fieldcat-seltext_l = 'SU2020 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2701_rp IS NOT INITIAL .
      wa_fieldcat-col_pos   = '100'.
      wa_fieldcat-fieldname = '2701_RP '.
      wa_fieldcat-seltext_l = 'SU3010 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2701_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '101'.
      wa_fieldcat-fieldname = '2701_CP '.
      wa_fieldcat-seltext_l = 'SU3010 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2702_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '102'.
      wa_fieldcat-fieldname = '2702_RP '.
      wa_fieldcat-seltext_l = 'SU4000 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2702_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '103'.
      wa_fieldcat-fieldname = '2702_CP '.
      wa_fieldcat-seltext_l = 'SU4000 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

    IF ls_final-2703_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '104'.
      wa_fieldcat-fieldname = '2703_RP '.
      wa_fieldcat-seltext_l = 'SU5000 Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.
    IF ls_final-2703_cp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '105'.
      wa_fieldcat-fieldname = '2703_CP '.
      wa_fieldcat-seltext_l = 'SU5000 Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
    ENDIF.

*    IF ls_final-2704_rp IS NOT INITIAL .
*      wa_fieldcat-col_pos   = '106'.
*      wa_fieldcat-fieldname = '2704_RP '.
*      wa_fieldcat-seltext_l = '2704 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF  ls_final-2704_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '107'.
*      wa_fieldcat-fieldname = '2704_CP '.
*      wa_fieldcat-seltext_l = '2704 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2705_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '108'.
*      wa_fieldcat-fieldname = '2705_RP '.
*      wa_fieldcat-seltext_l = '2705 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2705_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '109'.
*      wa_fieldcat-fieldname = '2705_CP '.
*      wa_fieldcat-seltext_l = '2705 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2706_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '110'.
*      wa_fieldcat-fieldname = '2706_RP '.
*      wa_fieldcat-seltext_l = '2706 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2706_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '111'.
*      wa_fieldcat-fieldname = '2706_CP '.
*      wa_fieldcat-seltext_l = '2706 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2707_rp IS NOT INITIAL .
*      wa_fieldcat-col_pos   = '112'.
*      wa_fieldcat-fieldname = '2707_RP '.
*      wa_fieldcat-seltext_l = '2707 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2707_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '113'.
*      wa_fieldcat-fieldname = '2707_CP '.
*      wa_fieldcat-seltext_l = '2707 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2711_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '114'.
*      wa_fieldcat-fieldname = '2711_RP '.
*      wa_fieldcat-seltext_l = '2711 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2711_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '115'.
*      wa_fieldcat-fieldname = '2711_CP '.
*      wa_fieldcat-seltext_l = '2711 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2712_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '116'.
*      wa_fieldcat-fieldname = '2712_RP '.
*      wa_fieldcat-seltext_l = '2712 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2712_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '117'.
*      wa_fieldcat-fieldname = '2712_CP '.
*      wa_fieldcat-seltext_l = '2712 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2713_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '118'.
*      wa_fieldcat-fieldname = '2713_RP '.
*      wa_fieldcat-seltext_l = '2713 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2713_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '119'.
*      wa_fieldcat-fieldname = '2713_CP '.
*      wa_fieldcat-seltext_l = '2713 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2714_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '120'.
*      wa_fieldcat-fieldname = '2714_RP '.
*      wa_fieldcat-seltext_l = '2714 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2714_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '121'.
*      wa_fieldcat-fieldname = '2714_CP '.
*      wa_fieldcat-seltext_l = '2714 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2715_rp IS NOT INITIAL.
*
*      wa_fieldcat-col_pos   = '122'.
*      wa_fieldcat-fieldname = '2715_RP '.
*      wa_fieldcat-seltext_l = '2715 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2715_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '123'.
*      wa_fieldcat-fieldname = '2715_CP '.
*      wa_fieldcat-seltext_l = '2715 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2716_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '124'.
*      wa_fieldcat-fieldname = '2716_RP '.
*      wa_fieldcat-seltext_l = '2716 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2716_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '125'.
*      wa_fieldcat-fieldname = '2716_CP '.
*      wa_fieldcat-seltext_l = '2716 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2717_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '126'.
*      wa_fieldcat-fieldname = '2717_RP '.
*      wa_fieldcat-seltext_l = '2717 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2717_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '127'.
*      wa_fieldcat-fieldname = '2717_CP '.
*      wa_fieldcat-seltext_l = '2717 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2718_rp IS NOT INITIAL .
*      wa_fieldcat-col_pos   = '128'.
*      wa_fieldcat-fieldname = '2718_RP '.
*      wa_fieldcat-seltext_l = '2718 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2718_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '129'.
*      wa_fieldcat-fieldname = '2718_CP '.
*      wa_fieldcat-seltext_l = '2718 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2719_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '130'.
*      wa_fieldcat-fieldname = '2719_RP '.
*      wa_fieldcat-seltext_l = '2719 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2719_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '131'.
*      wa_fieldcat-fieldname = '2719_CP '.
*      wa_fieldcat-seltext_l = '2719 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2720_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '132'.
*      wa_fieldcat-fieldname = '2720_RP '.
*      wa_fieldcat-seltext_l = '2720 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2720_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '133'.
*      wa_fieldcat-fieldname = '2720_CP '.
*      wa_fieldcat-seltext_l = '2720 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2721_rp IS NOT INITIAL .
*      wa_fieldcat-col_pos   = '134'.
*      wa_fieldcat-fieldname = '2721_RP '.
*      wa_fieldcat-seltext_l = '2721 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2721_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '135'.
*      wa_fieldcat-fieldname = '2721_CP '.
*      wa_fieldcat-seltext_l = '2721 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2722_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '136'.
*      wa_fieldcat-fieldname = '2722_RP '.
*      wa_fieldcat-seltext_l = '2722 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2722_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '137'.
*      wa_fieldcat-fieldname = '2722_CP '.
*      wa_fieldcat-seltext_l = '2722 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2723_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '138'.
*      wa_fieldcat-fieldname = '2723_RP '.
*      wa_fieldcat-seltext_l = '2723 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2723_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '139'.
*      wa_fieldcat-fieldname = '2723_CP '.
*      wa_fieldcat-seltext_l = '2723 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2724_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '140'.
*      wa_fieldcat-fieldname = '2724_RP '.
*      wa_fieldcat-seltext_l = '2724 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2724_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '141'.
*      wa_fieldcat-fieldname = '2724_CP '.
*      wa_fieldcat-seltext_l = '2724 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2725_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '142'.
*      wa_fieldcat-fieldname = '2725_RP '.
*      wa_fieldcat-seltext_l = '2725 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2725_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '143'.
*      wa_fieldcat-fieldname = '2725_CP '.
*      wa_fieldcat-seltext_l = '2725 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2726_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '144'.
*      wa_fieldcat-fieldname = '2726_RP '.
*      wa_fieldcat-seltext_l = '2726 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2726_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '145'.
*      wa_fieldcat-fieldname = '2726_CP '.
*      wa_fieldcat-seltext_l = '2726 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2727_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '146'.
*      wa_fieldcat-fieldname = '2727_RP '.
*      wa_fieldcat-seltext_l = '2727 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2727_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '147'.
*      wa_fieldcat-fieldname = '2727_CP '.
*      wa_fieldcat-seltext_l = '2727 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2728_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '148'.
*      wa_fieldcat-fieldname = '2728_RP '.
*      wa_fieldcat-seltext_l = '2728 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2728_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '149'.
*      wa_fieldcat-fieldname = '2728_CP '.
*      wa_fieldcat-seltext_l = '2728 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2729_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '150'.
*      wa_fieldcat-fieldname = '2729_RP '.
*      wa_fieldcat-seltext_l = '2729 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2729_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '151'.
*      wa_fieldcat-fieldname = '2729_CP '.
*      wa_fieldcat-seltext_l = '2729 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2730_rp IS NOT INITIAL .
*      wa_fieldcat-col_pos   = '152'.
*      wa_fieldcat-fieldname = '2730_RP '.
*      wa_fieldcat-seltext_l = '2730 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2730_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '153'.
*      wa_fieldcat-fieldname = '2730_CP '.
*      wa_fieldcat-seltext_l = '2730 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2731_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '154'.
*      wa_fieldcat-fieldname = '2731_RP '.
*      wa_fieldcat-seltext_l = '2731 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2731_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '155'.
*      wa_fieldcat-fieldname = '2731_CP '.
*      wa_fieldcat-seltext_l = '2731 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2751_rp IS NOT INITIAL .
*      wa_fieldcat-col_pos   = '156'.
*      wa_fieldcat-fieldname = '2751_RP '.
*      wa_fieldcat-seltext_l = '2751 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2751_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '157'.
*      wa_fieldcat-fieldname = '2751_CP '.
*      wa_fieldcat-seltext_l = '2751 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2752_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '158'.
*      wa_fieldcat-fieldname = '2752_RP '.
*      wa_fieldcat-seltext_l = '2752 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2752_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '159'.
*      wa_fieldcat-fieldname = '2752_CP '.
*      wa_fieldcat-seltext_l = '2752 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2753_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '160'.
*      wa_fieldcat-fieldname = '2753_RP '.
*      wa_fieldcat-seltext_l = '2753 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2753_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '161'.
*      wa_fieldcat-fieldname = '2753_CP '.
*      wa_fieldcat-seltext_l = '2753 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2754_rp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '162'.
*      wa_fieldcat-fieldname = '2754_RP '.
*      wa_fieldcat-seltext_l = '2754 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2754_cp IS NOT INITIAL.
*      wa_fieldcat-col_pos   = '163'.
*      wa_fieldcat-fieldname = '2754_CP '.
*      wa_fieldcat-seltext_l = '2754 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2755_rp IS NOT INITIAL .
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '164'.
*      wa_fieldcat-fieldname = '2755_RP '.
*      wa_fieldcat-seltext_l = '2755 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF  ls_final-2755_cp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '165'.
*      wa_fieldcat-fieldname = '2755_CP '.
*      wa_fieldcat-seltext_l = '2755 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2756_rp IS NOT INITIAL .
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '166'.
*      wa_fieldcat-fieldname = '2756_RP '.
*      wa_fieldcat-seltext_l = '2756 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2756_cp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '167'.
*      wa_fieldcat-fieldname = '2756_CP '.
*      wa_fieldcat-seltext_l = '2756 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2757_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '168'.
*      wa_fieldcat-fieldname = '2757_RP '.
*      wa_fieldcat-seltext_l = '2757 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2757_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '169'.
*      wa_fieldcat-fieldname = '2757_CP '.
*      wa_fieldcat-seltext_l = '2757 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2758_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '170'.
*      wa_fieldcat-fieldname = '2758_RP '.
*      wa_fieldcat-seltext_l = '2758 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2758_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '171'.
*      wa_fieldcat-fieldname = '2758_CP '.
*      wa_fieldcat-seltext_l = '2758 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2759_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '172'.
*      wa_fieldcat-fieldname = '2759_RP '.
*      wa_fieldcat-seltext_l = '2759 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2759_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '173'.
*      wa_fieldcat-fieldname = '2759_CP '.
*      wa_fieldcat-seltext_l = '2759 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2760_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '174'.
*      wa_fieldcat-fieldname = '2760_RP '.
*      wa_fieldcat-seltext_l = '2760 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2760_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '175'.
*      wa_fieldcat-fieldname = '2760_CP '.
*      wa_fieldcat-seltext_l = '2760 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2901_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '176'.
*      wa_fieldcat-fieldname = '2901_RP '.
*      wa_fieldcat-seltext_l = '2901 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2901_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '177'.
*      wa_fieldcat-fieldname = '2901_CP '.
*      wa_fieldcat-seltext_l = '2901 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2902_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '178'.
*      wa_fieldcat-fieldname = '2902_RP '.
*      wa_fieldcat-seltext_l = '2902 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2902_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '179'.
*      wa_fieldcat-fieldname = '2902_CP '.
*      wa_fieldcat-seltext_l = '2902 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2903_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '180'.
*      wa_fieldcat-fieldname = '2903_RP '.
*      wa_fieldcat-seltext_l = '2903 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2903_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '181'.
*      wa_fieldcat-fieldname = '2903_CP '.
*      wa_fieldcat-seltext_l = '2903 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2904_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '182'.
*      wa_fieldcat-fieldname = '2904_RP '.
*      wa_fieldcat-seltext_l = '2904 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2904_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '183'.
*      wa_fieldcat-fieldname = '2904_CP '.
*      wa_fieldcat-seltext_l = '2904 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2905_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '184'.
*      wa_fieldcat-fieldname = '2905_RP '.
*      wa_fieldcat-seltext_l = '2905 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2905_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '185'.
*      wa_fieldcat-fieldname = '2905_CP '.
*      wa_fieldcat-seltext_l = '2905 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2906_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '186'.
*      wa_fieldcat-fieldname = '2906_RP '.
*      wa_fieldcat-seltext_l = '2906 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2906_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '187'.
*      wa_fieldcat-fieldname = '2906_CP '.
*      wa_fieldcat-seltext_l = '2906 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2951_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '188'.
*      wa_fieldcat-fieldname = '2951_RP '.
*      wa_fieldcat-seltext_l = '2951 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2951_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '189'.
*      wa_fieldcat-fieldname = '2951_CP '.
*      wa_fieldcat-seltext_l = '2951 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2952_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '190'.
*      wa_fieldcat-fieldname = '2952_RP '.
*      wa_fieldcat-seltext_l = '2952 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2951_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '191'.
*      wa_fieldcat-fieldname = '2952_CP '.
*      wa_fieldcat-seltext_l = '2952 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2953_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '192'.
*      wa_fieldcat-fieldname = '2953_RP '.
*      wa_fieldcat-seltext_l = '2953 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2953_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '193'.
*      wa_fieldcat-fieldname = '2953_CP '.
*      wa_fieldcat-seltext_l = '2953 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2954_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '194'.
*      wa_fieldcat-fieldname = '2954_RP '.
*      wa_fieldcat-seltext_l = '2954 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2954_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '195'.
*      wa_fieldcat-fieldname = '2954_CP '.
*      wa_fieldcat-seltext_l = '2954 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2955_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '196'.
*      wa_fieldcat-fieldname = '2955_RP '.
*      wa_fieldcat-seltext_l = '2955 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2955_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '197'.
*      wa_fieldcat-fieldname = '2955_CP '.
*      wa_fieldcat-seltext_l = '2955 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2956_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '198'.
*      wa_fieldcat-fieldname = '2956_RP '.
*      wa_fieldcat-seltext_l = '2956 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2956_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '199'.
*      wa_fieldcat-fieldname = '2956_CP '.
*      wa_fieldcat-seltext_l = '2956 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2957_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '200'.
*      wa_fieldcat-fieldname = '2957_RP '.
*      wa_fieldcat-seltext_l = '2957 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2957_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '201'.
*      wa_fieldcat-fieldname = '2957_CP '.
*      wa_fieldcat-seltext_l = '2957 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2958_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '202'.
*      wa_fieldcat-fieldname = '2958_RP '.
*      wa_fieldcat-seltext_l = '2958 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2958_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '203'.
*      wa_fieldcat-fieldname = '2958_CP '.
*      wa_fieldcat-seltext_l = '2958 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2959_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '204'.
*      wa_fieldcat-fieldname = '2959_RP '.
*      wa_fieldcat-seltext_l = '2959 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2959_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '205'.
*      wa_fieldcat-fieldname = '2959_CP '.
*      wa_fieldcat-seltext_l = '2959 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2960_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '206'.
*      wa_fieldcat-fieldname = '2960_RP '.
*      wa_fieldcat-seltext_l = '2960 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2960_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '207'.
*      wa_fieldcat-fieldname = '2960_CP '.
*      wa_fieldcat-seltext_l = '2960 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2961_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '208'.
*      wa_fieldcat-fieldname = '2961_RP '.
*      wa_fieldcat-seltext_l = '2961 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2961_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '209'.
*      wa_fieldcat-fieldname = '2961_CP '.
*      wa_fieldcat-seltext_l = '2961 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2962_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '210'.
*      wa_fieldcat-fieldname = '2962_RP '.
*      wa_fieldcat-seltext_l = '2962 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2962_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '211'.
*      wa_fieldcat-fieldname = '2962_CP '.
*      wa_fieldcat-seltext_l = '2962 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2963_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '212'.
*      wa_fieldcat-fieldname = '2963_RP '.
*      wa_fieldcat-seltext_l = '2963 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2963_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '213'.
*      wa_fieldcat-fieldname = '2963_CP '.
*      wa_fieldcat-seltext_l = '2963 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-2964_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '214'.
*      wa_fieldcat-fieldname = '2964_RP '.
*      wa_fieldcat-seltext_l = '2964 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-2963_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '215'.
*      wa_fieldcat-fieldname = '2964_CP '.
*      wa_fieldcat-seltext_l = '2964 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3001_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '216'.
*      wa_fieldcat-fieldname = '3001_RP '.
*      wa_fieldcat-seltext_l = '3001 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3001_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '217'.
*      wa_fieldcat-fieldname = '3001_CP '.
*      wa_fieldcat-seltext_l = '3001 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3002_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '218'.
*      wa_fieldcat-fieldname = '3002_RP '.
*      wa_fieldcat-seltext_l = '3002 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3002_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '219'.
*      wa_fieldcat-fieldname = '3002_CP '.
*      wa_fieldcat-seltext_l = '3002 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3201_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '220'.
*      wa_fieldcat-fieldname = '3201_RP '.
*      wa_fieldcat-seltext_l = '3201 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3201_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '221'.
*      wa_fieldcat-fieldname = '3201_CP '.
*      wa_fieldcat-seltext_l = '3201 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3202_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '222'.
*      wa_fieldcat-fieldname = '3202_RP '.
*      wa_fieldcat-seltext_l = '3202 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3202_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '223'.
*      wa_fieldcat-fieldname = '3202_CP '.
*      wa_fieldcat-seltext_l = '3202 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3203_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '224'.
*      wa_fieldcat-fieldname = '3203_RP '.
*      wa_fieldcat-seltext_l = '3203 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3203_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '225'.
*      wa_fieldcat-fieldname = '3203_CP '.
*      wa_fieldcat-seltext_l = '3203 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3204_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '226'.
*      wa_fieldcat-fieldname = '3204_RP '.
*      wa_fieldcat-seltext_l = '3204 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3204_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '227'.
*      wa_fieldcat-fieldname = '3204_CP '.
*      wa_fieldcat-seltext_l = '3204 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3205_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '228'.
*      wa_fieldcat-fieldname = '3205_RP '.
*      wa_fieldcat-seltext_l = '3205 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3205_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '229'.
*      wa_fieldcat-fieldname = '3205_CP '.
*      wa_fieldcat-seltext_l = '3205 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3251_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '230'.
*      wa_fieldcat-fieldname = '3251_RP '.
*      wa_fieldcat-seltext_l = '3251 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3251_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '231'.
*      wa_fieldcat-fieldname = '3251_CP '.
*      wa_fieldcat-seltext_l = '3251 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3252_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '232'.
*      wa_fieldcat-fieldname = '3252_RP '.
*      wa_fieldcat-seltext_l = '3252 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3252_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '233'.
*      wa_fieldcat-fieldname = '3252_CP '.
*      wa_fieldcat-seltext_l = '3252 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3301_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '234'.
*      wa_fieldcat-fieldname = '3301_RP '.
*      wa_fieldcat-seltext_l = '3301 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3301_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '235'.
*      wa_fieldcat-fieldname = '3301_CP '.
*      wa_fieldcat-seltext_l = '3301 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3302_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '236'.
*      wa_fieldcat-fieldname = '3302_RP '.
*      wa_fieldcat-seltext_l = '3302 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3302_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '237'.
*      wa_fieldcat-fieldname = '3302_CP '.
*      wa_fieldcat-seltext_l = '3302 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3303_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '238'.
*      wa_fieldcat-fieldname = '3303_RP '.
*      wa_fieldcat-seltext_l = '3303 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3303_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '239'.
*      wa_fieldcat-fieldname = '3303_CP '.
*      wa_fieldcat-seltext_l = '3303 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3304_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '240'.
*      wa_fieldcat-fieldname = '3304_RP '.
*      wa_fieldcat-seltext_l = '3304 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3304_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '241'.
*      wa_fieldcat-fieldname = '3304_CP '.
*      wa_fieldcat-seltext_l = '3304 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3351_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '242'.
*      wa_fieldcat-fieldname = '3351_RP '.
*      wa_fieldcat-seltext_l = '3351 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3351_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '243'.
*      wa_fieldcat-fieldname = '3351_CP '.
*      wa_fieldcat-seltext_l = '3351 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3352_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '244'.
*      wa_fieldcat-fieldname = '3352_RP '.
*      wa_fieldcat-seltext_l = '3352 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3352_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '245'.
*      wa_fieldcat-fieldname = '3352_CP '.
*      wa_fieldcat-seltext_l = '3352 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3353_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '246'.
*      wa_fieldcat-fieldname = '3353_RP '.
*      wa_fieldcat-seltext_l = '3353 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3353_cp IS NOT INITIAL.
*
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '247'.
*      wa_fieldcat-fieldname = '3353_CP '.
*      wa_fieldcat-seltext_l = '3353 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3354_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '248'.
*      wa_fieldcat-fieldname = '3354_RP '.
*      wa_fieldcat-seltext_l = '3354 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3354_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '249'.
*      wa_fieldcat-fieldname = '3354_CP '.
*      wa_fieldcat-seltext_l = '3354 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3355_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '250'.
*      wa_fieldcat-fieldname = '3355_RP '.
*      wa_fieldcat-seltext_l = '3355 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3355_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '251'.
*      wa_fieldcat-fieldname = '3355_CP '.
*      wa_fieldcat-seltext_l = '3355 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3356_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '252'.
*      wa_fieldcat-fieldname = '3356_RP '.
*      wa_fieldcat-seltext_l = '3356 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3356_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '253'.
*      wa_fieldcat-fieldname = '3356_CP '.
*      wa_fieldcat-seltext_l = '3356 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3357_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '254'.
*      wa_fieldcat-fieldname = '3357_RP '.
*      wa_fieldcat-seltext_l = '3357 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3357_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '255'.
*      wa_fieldcat-fieldname = '3357_CP '.
*      wa_fieldcat-seltext_l = '3357 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3358_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '256'.
*      wa_fieldcat-fieldname = '3358_RP '.
*      wa_fieldcat-seltext_l = '3358 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3358_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '257'.
*      wa_fieldcat-fieldname = '3358_CP '.
*      wa_fieldcat-seltext_l = '3358 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3359_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '258'.
*      wa_fieldcat-fieldname = '3359_RP '.
*      wa_fieldcat-seltext_l = '3359 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3359_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '259'.
*      wa_fieldcat-fieldname = '3359_CP '.
*      wa_fieldcat-seltext_l = '3359 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3360_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '260'.
*      wa_fieldcat-fieldname = '3360_RP '.
*      wa_fieldcat-seltext_l = '3360 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3360_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '261'.
*      wa_fieldcat-fieldname = '3360_CP '.
*      wa_fieldcat-seltext_l = '3360 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3361_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '262'.
*      wa_fieldcat-fieldname = '3361_RP '.
*      wa_fieldcat-seltext_l = '3361 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3361_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '263'.
*      wa_fieldcat-fieldname = '3361_CP '.
*      wa_fieldcat-seltext_l = '3361 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3400_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '264'.
*      wa_fieldcat-fieldname = '3400_RP '.
*      wa_fieldcat-seltext_l = '3400 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3400_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '265'.
*      wa_fieldcat-fieldname = '3400_CP '.
*      wa_fieldcat-seltext_l = '3400 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3451_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '266'.
*      wa_fieldcat-fieldname = '3451_RP '.
*      wa_fieldcat-seltext_l = '3451 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3451_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '267'.
*      wa_fieldcat-fieldname = '3451_CP '.
*      wa_fieldcat-seltext_l = '3451 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3601_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '268'.
*      wa_fieldcat-fieldname = '3601_RP '.
*      wa_fieldcat-seltext_l = '3601 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3601_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '269'.
*      wa_fieldcat-fieldname = '3601_CP '.
*      wa_fieldcat-seltext_l = '3601 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3602_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '270'.
*      wa_fieldcat-fieldname = '3602_RP '.
*      wa_fieldcat-seltext_l = '3602 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3602_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '271'.
*      wa_fieldcat-fieldname = '3602_CP '.
*      wa_fieldcat-seltext_l = '3602 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3603_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '272'.
*      wa_fieldcat-fieldname = '3603_RP '.
*      wa_fieldcat-seltext_l = '3603 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3603_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '273'.
*      wa_fieldcat-fieldname = '3603_CP '.
*      wa_fieldcat-seltext_l = '3603 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3604_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '274'.
*      wa_fieldcat-fieldname = '3604_RP '.
*      wa_fieldcat-seltext_l = '3604 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3604_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '275'.
*      wa_fieldcat-fieldname = '3604_CP '.
*      wa_fieldcat-seltext_l = '3604 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3605_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '276'.
*      wa_fieldcat-fieldname = '3605_RP '.
*      wa_fieldcat-seltext_l = '3605 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3605_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '277'.
*      wa_fieldcat-fieldname = '3605_CP '.
*      wa_fieldcat-seltext_l = '3605 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3651_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '278'.
*      wa_fieldcat-fieldname = '3651_RP '.
*      wa_fieldcat-seltext_l = '3651 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3651_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '279'.
*      wa_fieldcat-fieldname = '3651_CP '.
*      wa_fieldcat-seltext_l = '3651 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3652_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '280'.
*      wa_fieldcat-fieldname = '3652_RP '.
*      wa_fieldcat-seltext_l = '3652 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3652_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '281'.
*      wa_fieldcat-fieldname = '3652_CP '.
*      wa_fieldcat-seltext_l = '3652 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3653_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '282'.
*      wa_fieldcat-fieldname = '3653_RP '.
*      wa_fieldcat-seltext_l = '3653 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3653_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '283'.
*      wa_fieldcat-fieldname = '3653_CP '.
*      wa_fieldcat-seltext_l = '3653 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3701_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '284'.
*      wa_fieldcat-fieldname = '3701_RP '.
*      wa_fieldcat-seltext_l = '3701 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3701_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '285'.
*      wa_fieldcat-fieldname = '3701_CP '.
*      wa_fieldcat-seltext_l = '3701 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3702_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '286'.
*      wa_fieldcat-fieldname = '3702_RP '.
*      wa_fieldcat-seltext_l = '3702 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3702_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '287'.
*      wa_fieldcat-fieldname = '3702_CP '.
*      wa_fieldcat-seltext_l = '3702 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3703_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '288'.
*      wa_fieldcat-fieldname = '3703_RP '.
*      wa_fieldcat-seltext_l = '3703 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3703_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '289'.
*      wa_fieldcat-fieldname = '3703_CP '.
*      wa_fieldcat-seltext_l = '3703 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3704_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '290'.
*      wa_fieldcat-fieldname = '3704_RP '.
*      wa_fieldcat-seltext_l = '3704 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3704_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '291'.
*      wa_fieldcat-fieldname = '3704_CP '.
*      wa_fieldcat-seltext_l = '3704 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3705_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '292'.
*      wa_fieldcat-fieldname = '3705_RP '.
*      wa_fieldcat-seltext_l = '3705 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3705_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '293'.
*      wa_fieldcat-fieldname = '3705_CP '.
*      wa_fieldcat-seltext_l = '3705 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.

*    IF ls_final-3706_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '294'.
*      wa_fieldcat-fieldname = '3706_RP '.
*      wa_fieldcat-seltext_l = '3706 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3706_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '295'.
*      wa_fieldcat-fieldname = '3706_CP '.
*      wa_fieldcat-seltext_l = '3706 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*        IF ls_final-3707_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '296'.
*      wa_fieldcat-fieldname = '3707_RP '.
*      wa_fieldcat-seltext_l = '3707 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3707_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '297'.
*      wa_fieldcat-fieldname = '3707_CP '.
*      wa_fieldcat-seltext_l = '3707 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*
*    IF ls_final-3751_rp IS NOT INITIAL.
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '298'.
*      wa_fieldcat-fieldname = '3751_RP '.
*      wa_fieldcat-seltext_l = '3751 Reporting Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
*    IF ls_final-3751_cp IS NOT INITIAL.
*
**      ADD 1 TO cnt.
*      wa_fieldcat-col_pos   = '299'.
*      wa_fieldcat-fieldname = '3751_CP '.
*      wa_fieldcat-seltext_l = '3751 Comparision Period'.
*      APPEND wa_fieldcat TO it_fieldcat.
*      CLEAR wa_fieldcat.
*    ENDIF.
 ENDLOOP.
*    IF ls_final-total_rp IS NOT INITIAL.
      wa_fieldcat-col_pos   = '300'.
      wa_fieldcat-fieldname = 'TOTAL_RP '.
      wa_fieldcat-seltext_l = 'Total Reporting Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
*    ENDIF.

*    IF ls_final-total_cp IS NOT INITIAL.
*  ADD 1 TO cnt.
      wa_fieldcat-col_pos   = '301'.
      wa_fieldcat-fieldname = 'TOTAL_CP '.
      wa_fieldcat-seltext_l = 'Total Comparision Period'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
*    ENDIF.

  SORT it_fieldcat BY fieldname.
  DELETE ADJACENT DUPLICATES FROM it_fieldcat COMPARING fieldname.
  SORT  it_fieldcat ASCENDING BY col_pos.

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      i_callback_top_of_page = 'TOP-OF-PAGE '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = ls_layout
      it_fieldcat            = it_fieldcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = ' '
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = lt_final
* EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM top-of-page.

  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c,
        lv_from(10)   TYPE c,
        l_from(10)    TYPE c,
        lv_to(10)     TYPE c,
        l_to(10)      TYPE c,
        lc_stop       TYPE c VALUE '.',
        v_text(70)    TYPE c.

  IF s_ccode IS NOT INITIAL.
    DATA : lv_adrnr TYPE t001-adrnr,
          lwa_name TYPE ADRC.
    SELECT SINGLE adrnr
      FROM t001
      INTO lv_adrnr "@DATA(lv_adrnr)
      WHERE bukrs IN s_ccode.
    IF sy-subrc IS INITIAL.
      SELECT SINGLE * FROM adrc INTO lwa_name"@DATA(lwa_name)
        WHERE addrnumber EQ lv_adrnr.
      IF sy-subrc IS NOT INITIAL.
        CLEAR lwa_name.
      ENDIF.

    ENDIF.
  ENDIF.

  wa_header-typ  = 'H'.
  wa_header-info = lwa_name-name1.
  APPEND wa_header TO t_header.
  CLEAR wa_header.

  CONCATENATE  s_date-low+6(2) lc_stop
               s_date-low+4(2) lc_stop
               s_date-low(4) INTO lv_from.

  CONCATENATE  s_date-high+6(2) lc_stop
               s_date-high+4(2) lc_stop
               s_date-high(4) INTO lv_to.

  CONCATENATE  s_date1-low+6(2) lc_stop
               s_date1-low+4(2) lc_stop
               s_date1-low(4) INTO l_from.

  CONCATENATE  s_date1-high+6(2) lc_stop
              s_date1-high+4(2) lc_stop
              s_date1-high(4) INTO l_to.

  wa_header-typ  = 'S'.
  CONCATENATE 'Trial Balance For the Period ' lv_from 'to' lv_to INTO v_text SEPARATED BY space.
  wa_header-info = v_text.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

  wa_header-typ  = 'A'.
  wa_header-key = 'Run Date'.
  CONCATENATE 'Run Date :'  sy-datum+6(2) lc_stop
             sy-datum+4(2) lc_stop
             sy-datum(4) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.

ENDFORM.
