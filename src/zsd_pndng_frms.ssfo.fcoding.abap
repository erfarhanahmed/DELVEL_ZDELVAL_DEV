*FORM SET_CONDITION USING V_KUNNR TYPE KUNNR
*                          V_QURTR TYPE CHAR3
*                    CHANGING V_CNDTN TYPE CHAR100.
*   DATA :  CNDTN TYPE T_CNDTN,
*           CNDTNS TYPE TABLE OF T_CNDTN.
*
*   CLEAR : V_CNDTN, CNDTN.
*   REFRESH CNDTNS.
*
*   IF NOT V_KUNNR IS INITIAL.
*     CNDTN-STR = 'KUNAG = P_KUNNR'.
*     APPEND CNDTN TO CNDTNS.
*   ENDIF.
*
*   IF NOT V_QURTR IS INITIAL.
*
**     DESIGN THE CONDITION LIKE FKDATE BETWEEN QRTR_B QRTR_E/
**     "JVA_LAST_DATE_OF_MONTH " LAST DAY OF MONTH
**     CNDTN-STR = ' = P_KUNNR'.
**     APPEND CNDTN TO CNDTNS.
*   ENDIF.
*
*   IF NOT CNDTNS IS INITIAL.
*     CONCATENATE LINES OF CNDTNS INTO V_CNDTN SEPARATED BY ' AND '.
*   ELSE.
*     V_CNDTN = ' 1 = 1 '. " TO AVOIDE ERRORS
*   ENDIF.
*   CONDENSE V_CNDTN.
* ENDFORM.

 FORM GET_PENDINGFORMS TABLES V_RES TYPE TT_RES
                              V_QURTR TYPE TT_QURTR
                       USING V_KUNNR TYPE KUNNR
                             V_TAXK1 TYPE TAXK1.

   DATA : WA_VBRK TYPE T_VBRK,
         IT_VBRK TYPE TABLE OF T_VBRK,

         WA_VBRP TYPE T_VBRP,
         IT_VBRP TYPE TABLE OF T_VBRP,

         WA_VBAK TYPE T_VBAK,
         IT_VBAK TYPE TABLE OF T_VBAK,

         WA_KONV TYPE T_KONV,
         IT_KONV TYPE TABLE OF T_KONV,

         WA_FRMC TYPE T_ZFRMC,
         IT_FRMC TYPE TABLE OF T_ZFRMC,

         wa_J_1IEXCHDR type J_1IEXCHDR,

         WA_RES TYPE T_RES.

   IF NOT V_KUNNR IS INITIAL.
     SELECT VBELN
            KNUMV
            FKDAT
*            rfbsk
            NETWR
            MWSBK
            FKSTO
       FROM VBRK
       INTO TABLE IT_VBRK
       WHERE KUNAG = V_KUNNR AND TAXK1 = V_TAXK1.

       IF NOT it_vbrk is initial.
         " remove cancelled docs from the list
*         delete it_vbrk where RFBSK = 'E'.
         delete it_vbrk where FKSTO = 'X'.
         " Fetch the Invoice Amount Details
         SELECT KNUMV
                KPOSN
                KWERT
                WAERS
           INTO TABLE IT_KONV
           FROM KONV
           FOR ALL ENTRIES IN IT_VBRK
           WHERE KNUMV = IT_VBRK-KNUMV
             AND KSCHL = 'ZCST'.

           " Fetch the form value details
           SELECT VBELN
                FRCVD
                FRDAT
                FRVAL
                CRUNT
           INTO TABLE IT_FRMC
           FROM ZFRMC
           FOR ALL ENTRIES IN IT_VBRK
           WHERE VBELN = IT_VBRK-VBELN.

           " Fetch the Sales Document No.s for the respective billing docs.
           SELECT VBELN
                  AUBEL
             FROM VBRP
             INTO TABLE IT_VBRP
             FOR ALL ENTRIES IN IT_VBRK
             WHERE VBELN = IT_VBRK-VBELN.

           " Get the POs linked with the respective billing Docs.
           SELECT VBELN
                  BSTNK
                  BSTDK
             FROM VBAK
             INTO TABLE IT_VBAK
             FOR ALL ENTRIES IN IT_VBRP
             WHERE VBELN = IT_VBRP-AUBEL.


         REFRESH V_RES.
         CLEAR : WA_RES, WA_VBRK, WA_VBRP, WA_VBAK, WA_KONV, WA_FRMC.


         LOOP AT IT_VBRK INTO WA_VBRK.

******Start of changes by Hasan
           SELECT SINGLE * from J_1IEXCHDR
           into wa_J_1IEXCHDR
           WHERE RDOC = WA_VBRK-VBELN
             and TRNTYP = 'DLFC'
           AND ( STATUS = 'C' OR STATUS = 'P'
           OR STATUS = SPACE ).
******End of changes by Hasan

            READ TABLE IT_FRMC INTO WA_FRMC WITH KEY VBELN = WA_VBRK-VBELN.
            IF SY-SUBRC EQ 0.
              IF WA_FRMC-FRCVD = 'X'.
                CONTINUE.
              ENDIF.
              WA_RES-FRVAL = WA_FRMC-FRVAL.
              WA_RES-FRDAT = WA_FRMC-FRDAT.
              WA_RES-CRUNT = WA_FRMC-CRUNT.
            ENDIF.
******Start of changes by Hasan
             WA_RES-VBELN = wa_J_1IEXCHDR-EXNUM.
             WA_RES-fkdat = wa_J_1IEXCHDR-EXDAT.
*            WA_RES-VBELN = WA_VBRK-VBELN.
*            WA_RES-FKDAT = WA_VBRK-FKDAT.
******end of changes by Hasan
            LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBRK-KNUMV.
              IF WA_RES-CRUNT IS INITIAL.
                WA_RES-CRUNT = WA_KONV-WAERS.
              ENDIF.
*              WA_RES-KWERT = WA_RES-KWERT + WA_KONV-KWERT.
              CLEAR WA_KONV.
            ENDLOOP.

            WA_RES-KWERT = WA_VBRK-NETWR + WA_VBRK-MWSBK.

            " Determine Quarter
            PERFORM DTRMN_QURTR TABLES V_QURTR USING WA_VBRK-FKDAT CHANGING WA_RES-QURTR.

            "IDWT_READ_MONTH_TEXT

            READ TABLE IT_VBRP INTO WA_VBRP WITH KEY VBELN = WA_VBRK-VBELN.
            IF SY-SUBRC EQ 0.
              READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_VBRP-AUBEL.
              IF SY-SUBRC EQ 0.
                WA_RES-PONUM = WA_VBAK-BSTNK.
                WA_RES-PODAT = WA_VBAK-BSTDK.
              ENDIF.
            ENDIF.

            APPEND WA_RES TO V_RES.

******Start of changes by Hasan
            delete  V_RES where vbeln = ' '.
******End of changes by Hasan
            CLEAR : WA_RES, WA_VBRK, WA_VBRP, WA_VBAK, WA_KONV, WA_FRMC,wa_J_1IEXCHDR.
         ENDLOOP.
*         IF NOT V_RES[] IS INITIAL.
*           DATA OP_TAB TYPE REF TO CL_SALV_TABLE.
*
*           TRY.
*           CALL METHOD CL_SALV_TABLE=>FACTORY
*             IMPORTING
*               R_SALV_TABLE   = OP_TAB
*             CHANGING
*               T_TABLE        = V_RES[].
*            CATCH CX_SALV_MSG .
*           ENDTRY.
*           OP_TAB->DISPLAY( ).
*         ENDIF.
       ENDIF.
   ELSE.
     MESSAGE 'Invalid conditions to extract the data.' TYPE 'E'.
   ENDIF.
 ENDFORM.



 FORM SET_QRTRS TABLES V_QURTR TYPE TT_QURTR.
   DATA W_QURTR TYPE T_QURTR.
   REFRESH V_QURTR.

   CLEAR W_QURTR.
   W_QURTR-ID = 'I'.
   W_QURTR-B = '04'.
   W_QURTR-e = '06'.
   APPEND W_QURTR TO V_QURTR.

   CLEAR W_QURTR.
   W_QURTR-ID = 'II'.
   W_QURTR-B = '07'.
   W_QURTR-e = '09'.
   APPEND W_QURTR TO V_QURTR.

   CLEAR W_QURTR.
   W_QURTR-ID = 'III'.
   W_QURTR-B = '10'.
   W_QURTR-e = '12'.
   APPEND W_QURTR TO V_QURTR.

   CLEAR W_QURTR.
   W_QURTR-ID = 'IV'.
   W_QURTR-B = '01'.
   W_QURTR-e = '03'.
   APPEND W_QURTR TO V_QURTR.
 ENDFORM.

 FORM DTRMN_QURTR TABLES V_QURTR TYPE TT_QURTR
                  USING V_DAT TYPE SY-DATUM
                  CHANGING STR TYPE CHAR9.

   DATA : WA_QURTR TYPE T_QURTR,
          M TYPE INT2,
          M1 TYPE CHAR3,
          M2 TYPE CHAR3.

   M = V_DAT+4(2).

   LOOP AT V_QURTR INTO WA_QURTR.
     IF M BETWEEN WA_QURTR-B AND WA_QURTR-E.
       CLEAR STR.
       PERFORM GET_MONTH USING WA_QURTR-B CHANGING M1.
       PERFORM GET_MONTH USING WA_QURTR-E CHANGING M2.
       CONCATENATE M1 M2 INTO STR SEPARATED BY ' - '.
     ENDIF.
   ENDLOOP.
 ENDFORM.

 FORM GET_MONTH USING M TYPE NUM2
                CHANGING STR TYPE CHAR3.
   SELECT SINGLE KTX
     FROM T247
     INTO STR
     WHERE MNR = M
         AND SPRAS = SY-LANGU.
   IF SY-SUBRC NE 0.
     STR = 'INV'.
   ENDIF.
 ENDFORM.

 FORM GET_KUNNR_INFO USING V_KUNNR TYPE KUNNR
                     CHANGING V_RESULT TYPE T_RESULT.
   DATA : STR TYPE STRING.

   SELECT SINGLE KUNNR NAME1 ADRNR
     INTO V_RESULT
     FROM KNA1
     WHERE KUNNR = V_KUNNR.

   SELECT SINGLE J_1ICSTNO J_1ILSTNO
     INTO (V_RESULT-CST, V_RESULT-LST)
     FROM J_1IMOCOMP.

   FIND REGEX '([\d]{2}[\-|/][\d]{2}[\-|/][\d]{4})' IN V_RESULT-CST SUBMATCHES STR.
   REPLACE STR IN V_RESULT-CST WITH ''.
   REPLACE '/' IN V_RESULT-CST WITH ''.

   FIND REGEX '([\d]{2}[\-|/][\d]{2}[\-|/][\d]{4})' IN V_RESULT-LST SUBMATCHES STR.
   REPLACE STR IN V_RESULT-LST WITH ''.
   REPLACE '/' IN V_RESULT-LST WITH ''.
 ENDFORM.
