"Name: \PR:SAPMM06I\FO:BUCHEN\SE:BEGIN\EI
ENHANCEMENT 0 ZIMP_MM06IF01_PL01_ENCH.
*BREAK-POINT.

IF eine IS  NOT INITIAL.
  if eine-werks = 'PL01'.
  IF  ( sy-ucomm = '' OR sy-ucomm = 'BU' OR sy-ucomm = 'EN' OR sy-ucomm = 'YES' OR sy-ucomm = 'KO' OR sy-ucomm = 'PICK' OR sy-ucomm = 'NEWD'OR sy-ucomm = 'NEWR')  .
   TYPES : BEGIN OF TY_LFA1,
          LIFNR TYPE LFA1-LIFNR ,
          STCD3 TYPE LFA1-STCD3,
          END OF TY_LFA1.
  DATA : LW_LFA1 TYPE TY_LFA1.
  DATA : LV_FLAG TYPE ABAP_BOOL.
  LV_FLAG = ABAP_FALSE.

  SELECT SINGLE LIFNR STCD3 FROM LFA1 INTO LW_LFA1
    WHERE LIFNR = EINA-LIFNR.
    IF LW_LFA1 IS NOT INITIAL.
      DATA: S_STR TYPE C LENGTH 2.
      S_STR = LW_LFA1-STCD3+0(2).

       IF LW_LFA1-STCD3  EQ 'URP'.
         CASE EINE-MWSKZ .
           WHEN 'MA' OR 'MB' OR 'MC' OR 'MD' OR 'ME' OR 'MF' OR 'MG' OR 'MH' OR 'MR' OR 'MQ' OR 'M0' OR 'M1'.
              LV_FLAG = ABAP_TRUE.
          ENDCASE.
*         ENDIF.
       ELSEIF S_STR EQ '27'.
           CASE EINE-MWSKZ .
             WHEN 'M0' OR 'M1' OR 'M2' OR 'M3' OR 'M4' OR 'M5' OR 'MO' OR 'MS' OR 'MN'.
               LV_FLAG = ABAP_TRUE.
           ENDCASE.
          ELSE.
           CASE EINE-MWSKZ .
             WHEN 'M0' OR 'M1' OR 'M6' OR 'M7' OR 'M8' OR 'M9' OR 'MP'.
              LV_FLAG = ABAP_TRUE.
           ENDCASE.
         ENDIF.
       ENDIF.
       IF LV_FLAG = ABAP_FALSE.
          MESSAGE 'Invalid Tax Code' TYPE 'E' ."DISPLAY LIKE 'I'.
       ENDIF.
    ENDIF.
  ENDIF.
ENDIF.

ENDENHANCEMENT.
