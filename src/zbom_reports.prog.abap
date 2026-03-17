*&---------------------------------------------------------------------*
*& Report ZBOM_COMPO_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBOM_COMPO_REPORT.
*IF SY-TCODE = 'ZBOM'.
*IF sy-repid = 'ZBOM_COMPO_REPORT' .
*MESSAGE 'This Tcode is discontinued. Kindly use ZBOM1 Tcode' TYPE 'E'.
*ENDIF.
*ENDIF.
************************************************************************
*Table Declarations.
************************************************************************
TABLES : MAST, STKO, STPO.

************************************************************************
*Data Declarations
************************************************************************
TYPE-POOLS : SLIS.

*Internal Table for field catalog
DATA : T_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.
DATA : FS_LAYOUT TYPE SLIS_LAYOUT_ALV.

*Internal Table for sorting
DATA : T_SORT TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.


***** Changes By Amit 23-12-11 ***********************************************************************************

DATA : BEGIN OF I_MAST_MAKT OCCURS 0,
         MATNR TYPE MAST-MATNR,
         MAKTX TYPE MAKT-MAKTX,
         WERKS TYPE MAST-WERKS,
         STLAN TYPE MAST-STLAN,
         STLNR TYPE MAST-STLNR,
         STLAL TYPE MAST-STLAL,
         COMPD TYPE MAKT-MAKTX,
         STLST TYPE STKO-STLST,
       END OF I_MAST_MAKT.

DATA : BEGIN OF I_STKO OCCURS 0,
         STLNR TYPE STKO-STLNR,
         STLTY TYPE STKO-STLTY,
         BMEIN TYPE STKO-BMEIN,
         BMENG TYPE STKO-BMENG,
         STLST TYPE STKO-STLST,
         STLAL TYPE STKO-STLAL,
*         andat TYPE stko-andat,"Commednted By Nilay on 03.03.2023
         ANNAM TYPE STKO-ANNAM,
       END OF I_STKO.

DATA : BEGIN OF I_STAS OCCURS 0,
         STLTY TYPE STAS-STLTY,
         STLNR TYPE STAS-STLNR,
         STLAL TYPE STAS-STLAL,
         STLKN TYPE STAS-STLKN,
*        LKENZ type stas-LKENZ,          "added by pankaj 20.01.2022  Deletion indicator
         STASZ TYPE STAS-STASZ,
       END OF I_STAS.

DATA : BEGIN OF I_STPO OCCURS 0,
         STLNR TYPE STPO-STLNR,
         STLKN TYPE STPO-STLKN,
*        LKENZ type stpo-LKENZ,          "added by pankaj 20.01.2022  Deletion indicator
         ANDAT TYPE STPO-ANDAT,
         AEDAT TYPE STPO-AEDAT,
         AENAM TYPE STPO-AENAM,
         STPOZ TYPE STPO-STPOZ,
         AENNR TYPE STPO-AENNR,
         VGKNT TYPE STPO-VGKNT,
         VGPZL TYPE STPO-VGPZL,
         IDNRK TYPE STPO-IDNRK,
         MEINS TYPE STPO-MEINS,
         MENGE TYPE STPO-MENGE,
         DATUV TYPE STPO-DATUV,
         POSTP TYPE STPO-POSTP,
         POSNR TYPE STPO-POSNR,
       END OF I_STPO.
************************************************************************************************************

DATA : BEGIN OF ITAB OCCURS 0,
         MATNR     TYPE MAST-MATNR,
         LONG_TXT  TYPE CHAR100,
         WERKS     TYPE MAST-WERKS,
         STLAN     TYPE MAST-STLAN,
         STLAL     TYPE MAST-STLAL,
         BMENG     TYPE CHAR15,
         BMEIN     TYPE STKO-BMEIN,
         IDNRK     TYPE STPO-IDNRK,
         LONG_TXT1 TYPE CHAR100,
         MENGE     TYPE CHAR15,
         MEINS     TYPE STPO-MEINS,
         STLST     TYPE STKO-STLST,
         ANDAT     TYPE CHAR11,
         ANNAM     TYPE STKO-ANNAM,
         REF       TYPE CHAR15,

         MAKTX     TYPE MAKT-MAKTX,
         STLNR     TYPE MAST-STLNR,
         STLTY     TYPE STKO-STLTY,
         STLKN     TYPE STPO-STLKN,
         COMPD     TYPE MAKT-MAKTX,



         DATUV     TYPE CHAR15, "<----------Added by Amit 23.12.11
         POSTP     TYPE STPO-POSTP,
         POSNR     TYPE STPO-POSNR,
*        LKENZ TYPE stpo-LKENZ ,     "added by pankaj 20.01.2022
         AEDAT     TYPE CHAR15, "stpo-aedat,
         AENAM     TYPE STPO-AENAM,

       END OF ITAB.

TYPES  : BEGIN OF TY_MARC,
           MATNR TYPE MARC-MATNR,
           LVORM TYPE MARC-LVORM,
         END OF TY_MARC.


DATA: BEGIN OF IT_FINAL OCCURS 0,
        MATNR     TYPE MAST-MATNR,
        LONG_TXT  TYPE CHAR100,
        WERKS     TYPE MAST-WERKS,
        STLAN     TYPE MAST-STLAN,
        STLAL     TYPE MAST-STLAL,
        BMENG     TYPE CHAR15,
        BMEIN     TYPE STKO-BMEIN,
        POSNR     TYPE STPO-POSNR,
        IDNRK     TYPE STPO-IDNRK,
        LONG_TXT1 TYPE CHAR100,
        MENGE     TYPE CHAR15,
        MEINS     TYPE STPO-MEINS,
        STLST     TYPE STKO-STLST,
        ANDAT     TYPE CHAR11,
        ANNAM     TYPE STKO-ANNAM,
        DATUV     TYPE CHAR15,
        REF       TYPE CHAR15,
        AENAM     TYPE STPO-AENAM,
        AEDAT     TYPE CHAR15,
        LVORM     TYPE MARC-LVORM,
*      LKENZ TYPE stpo-LKENZ ,     "added by pankaj 20.01.2022
      END OF IT_FINAL.

DATA : GV_COUNT TYPE CHAR15.

DATA : IT_MARC TYPE TABLE OF TY_MARC,
       WA_MARC TYPE TY_MARC.

DATA:
  LV_ID    TYPE THEAD-TDNAME,
  LT_LINES TYPE STANDARD TABLE OF TLINE,
  LS_LINES TYPE TLINE.

DATA : WA_STPO TYPE STPO.
**********************SELECTION-SCREEN**************************
SELECTION-SCREEN: BEGIN OF BLOCK B1  WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS  : S_WERKS FOR MAST-WERKS DEFAULT 'PL01' OBLIGATORY MODIF ID WER,
                    S_STLAN FOR MAST-STLAN,
                    S_STLST FOR STKO-STLST,
                    S_MATNR FOR MAST-MATNR.
SELECTION-SCREEN: END OF BLOCK B1.
*********************END-OF-SELECTION**************************
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


"MESSAGE 'This Tcode is discontinued. Kindly use ZBOM1 Tcode' TYPE 'E'.



"ENDIF.

******************************************************COMMENTED BY DIKSHA HALVE 16.12.2022
*AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
*  LOOP AT SCREEN.
*    IF screen-group1 = 'WER'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.
*MESSAGE 'This Tcode is discontinued. Kindly use ZBOM1 Tcode' TYPE 'E'.
********************************************************************************************

START-OF-SELECTION.

  PERFORM DATA_SELECT.
  PERFORM DATA_COLLECT.
  PERFORM SORT_LIST.

  EXPORT IT_FINAL TO MEMORY ID 'ZBOM1'.
  PERFORM FORM_HEADING.

FORM DATA_SELECT.

* select mast~matnr
*        mast~werks
*        mast~stlan
*        mast~stlnr
*        mast~stlal
*        stko~stlty
*        stko~bmein
*        stko~bmeng
*        stko~stlst
*        stpo~stlkn
*        stpo~idnrk
*        stpo~meins
*        stpo~menge
*        stpo~datuv
*        stpo~postp
*        stpo~posnr
*  into CORRESPONDING FIELDS OF TABLE itab
*  from mast
*  INNER JOIN stko on mast~stlnr = stko~stlnr and mast~stlal = stko~stlal
*  INNER JOIN stpo on stko~stlty = stpo~stlty and stko~stlnr = stpo~stlnr
*  where werks in s_werks
*  and   stlan in s_stlan
*  and   stlst in s_stlst.


  " BREAK primus.

  SELECT MAST~MATNR
         MAKT~MAKTX
         MAST~WERKS
         MAST~STLAN
         MAST~STLNR
         MAST~STLAL
         STKO~STLST
*       makt~compd
    INTO CORRESPONDING FIELDS OF TABLE I_MAST_MAKT
    FROM MAST
    INNER JOIN MAKT ON MAST~MATNR = MAKT~MATNR
    INNER JOIN STKO ON MAST~STLNR = STKO~STLNR
    WHERE WERKS IN S_WERKS
    AND   STLAN IN S_STLAN
    AND   MAST~MATNR IN S_MATNR
    AND   STLST IN S_STLST.

  SORT I_MAST_MAKT BY STLNR.
  IF SY-SUBRC IS INITIAL.
    SELECT STLNR
           STLTY
           BMEIN
           BMENG
           STLST
           STLAL
           ANNAM
      INTO CORRESPONDING FIELDS OF TABLE I_STKO
      FROM STKO
      FOR ALL ENTRIES IN I_MAST_MAKT
      WHERE STLNR = I_MAST_MAKT-STLNR AND STLAL = I_MAST_MAKT-STLAL AND STLST = I_MAST_MAKT-STLST.  "  OR lkenz = 'X'." or stlst = s_stlst.

    SORT I_STKO BY STLNR.

    SELECT STLTY
           STLNR
           STLAL
           STLKN
           STASZ
    "  LKENZ                "added by pankaj
      FROM STAS
      INTO CORRESPONDING FIELDS OF TABLE I_STAS
      FOR ALL ENTRIES IN I_STKO
      WHERE STLNR = I_STKO-STLNR." AND lkenz = 'X'.      "added by pankaj 20.01.2022 LKENZ logic

*DELETE i_stas WHERE lkenz = 'X'.

    SELECT STLNR
           STLKN
           STPOZ
           ANDAT   "Added  By Nilay B. on 03.03.2023
           AENNR
           AEDAT
           AENAM
           VGKNT
           VGPZL
           IDNRK
           MEINS
           MENGE
           DATUV
           POSTP
           POSNR
      INTO CORRESPONDING FIELDS OF TABLE I_STPO
      FROM STPO
      FOR ALL ENTRIES IN I_STKO
      WHERE STLNR = I_STKO-STLNR AND STLTY = I_STKO-STLTY
        AND VGKNT = ' '
        AND VGPZL = ' '.
  ELSE.
    MESSAGE 'Data Not Found' TYPE 'E'.
  ENDIF.



  SELECT MATNR
         LVORM
         FROM MARC
         INTO TABLE IT_MARC
         FOR ALL ENTRIES IN I_STPO
         WHERE MATNR = I_STPO-IDNRK.




************************************************************************************************************

ENDFORM.


FORM DATA_COLLECT.
*  if not itab[] is initial.
*    loop at itab.
*      select single maktx into itab-maktx
*        from makt
*        where matnr = itab-matnr.
*
*      select single maktx into itab-compd
*        from makt
*        where matnr = itab-idnrk.
*
*      modify itab.
*      clear  itab.
*    endloop.
*  endif.

***** Changes By Amit 23-12-11 *******************************************************************************************
  SORT I_STPO BY STLNR POSNR DATUV DESCENDING.
*DELETE ADJACENT DUPLICATES FROM i_stpo COMPARING stlnr posnr.


  "BREAK primus.

  LOOP AT I_STPO.

    SELECT SINGLE * FROM STPO INTO WA_STPO WHERE STLNR = I_STPO-STLNR AND VGKNT = I_STPO-STLKN AND VGPZL = I_STPO-STPOZ.
    IF SY-SUBRC = 0.
      ITAB-IDNRK = WA_STPO-IDNRK.
*      itab-andat = wa_stpo-andat.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = I_STPO-ANDAT
        IMPORTING
          OUTPUT = ITAB-ANDAT.

      CONCATENATE ITAB-ANDAT+0(2) ITAB-ANDAT+2(3) ITAB-ANDAT+5(4)
                      INTO ITAB-ANDAT SEPARATED BY '-'.

      ITAB-MEINS = WA_STPO-MEINS.
      ITAB-MENGE = WA_STPO-MENGE.
      ITAB-DATUV = WA_STPO-DATUV.
      ITAB-POSTP = WA_STPO-POSTP.
      ITAB-POSNR = WA_STPO-POSNR.
      ITAB-STLNR = WA_STPO-STLNR.
      ITAB-STLKN = WA_STPO-STLKN.
*   itab-lkenz = wa_stpo-lkenz.                          "added by pankaj 20.01.2022
    ELSE.
      ITAB-IDNRK = I_STPO-IDNRK.
      ITAB-MEINS = I_STPO-MEINS.
      ITAB-MENGE = I_STPO-MENGE.
      ITAB-DATUV = I_STPO-DATUV.
      ITAB-POSTP = I_STPO-POSTP.
      ITAB-POSNR = I_STPO-POSNR.
      ITAB-STLNR = I_STPO-STLNR.
      ITAB-STLKN = I_STPO-STLKN.
      ITAB-ANDAT = I_STPO-ANDAT.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = I_STPO-ANDAT
        IMPORTING
          OUTPUT = ITAB-ANDAT.

      CONCATENATE ITAB-ANDAT+0(2) ITAB-ANDAT+2(3) ITAB-ANDAT+5(4)
                      INTO ITAB-ANDAT SEPARATED BY '-'.

      ITAB-AENAM = I_STPO-AENAM.


      ITAB-AEDAT = I_STPO-AEDAT.
      CLEAR: ITAB-AEDAT.
      IF I_STPO-AEDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = I_STPO-AEDAT
          IMPORTING
            OUTPUT = ITAB-AEDAT.

        CONCATENATE ITAB-AEDAT+0(2) ITAB-AEDAT+2(3) ITAB-AEDAT+5(4)
                        INTO ITAB-AEDAT SEPARATED BY '-'.

      ENDIF.

*   itab-lkenz = i_stpo-lkenz.                "added by pankaj 20.01.2022
    ENDIF.


    LV_ID = ITAB-IDNRK.

    CLEAR: LT_LINES,LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LT_LINES
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
* Implement suitable error handling here
    ENDIF.
    IF NOT LT_LINES IS INITIAL.
      LOOP AT LT_LINES INTO LS_LINES.
        IF NOT LS_LINES-TDLINE IS INITIAL.
          CONCATENATE ITAB-LONG_TXT1 LS_LINES-TDLINE INTO ITAB-LONG_TXT1 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE ITAB-LONG_TXT1.
    ENDIF.
    CLEAR LV_ID.


    READ TABLE I_STKO WITH KEY STLNR = ITAB-STLNR.

    ITAB-BMEIN = I_STKO-BMEIN.
    ITAB-BMENG = I_STKO-BMENG.
    ITAB-STLST = I_STKO-STLST.
*    itab-andat = i_stko-andat.
    ITAB-ANNAM = I_STKO-ANNAM.

*    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*      EXPORTING
*        input  = i_stko-andat
*      IMPORTING
*        output = itab-andat.
*
*    CONCATENATE itab-andat+0(2) itab-andat+2(3) itab-andat+5(4)
*                    INTO itab-andat SEPARATED BY '-'.



    ITAB-REF = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = ITAB-REF
      IMPORTING
        OUTPUT = ITAB-REF.

    CONCATENATE ITAB-REF+0(2) ITAB-REF+2(3) ITAB-REF+5(4)
                    INTO ITAB-REF SEPARATED BY '-'.



    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = ITAB-DATUV
      IMPORTING
        OUTPUT = ITAB-DATUV.

    CONCATENATE ITAB-DATUV+0(2) ITAB-DATUV+2(3) ITAB-DATUV+5(4)
                    INTO ITAB-DATUV SEPARATED BY '-'.







    READ TABLE I_STAS WITH KEY STLKN = ITAB-STLKN STLNR = ITAB-STLNR.

    ITAB-STLAL = I_STAS-STLAL.
*    itab-lkenz = i_stas-lkenz.              "added by pankaj
    LOOP AT I_STAS WHERE STLKN = ITAB-STLKN AND STLNR = ITAB-STLNR..
      GV_COUNT = GV_COUNT + 1.
    ENDLOOP.

    READ TABLE I_MAST_MAKT WITH KEY STLNR = ITAB-STLNR STLAL = I_STKO-STLAL.

    ITAB-WERKS = I_MAST_MAKT-WERKS.
    ITAB-MATNR = I_MAST_MAKT-MATNR.




    LV_ID = I_MAST_MAKT-MATNR.


    CLEAR: LT_LINES,LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LT_LINES
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
* Implement suitable error handling here
    ENDIF.
    IF NOT LT_LINES IS INITIAL.
      LOOP AT LT_LINES INTO LS_LINES.
        IF NOT LS_LINES-TDLINE IS INITIAL.
          CONCATENATE ITAB-LONG_TXT LS_LINES-TDLINE INTO ITAB-LONG_TXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE ITAB-LONG_TXT.
    ENDIF.



*    itab-maktx = i_mast_makt-maktx.

    SELECT SINGLE MAKTX INTO ITAB-COMPD
      FROM MAKT WHERE MATNR = ITAB-IDNRK.

*    itab-compd = maktx1.
    ITAB-STLAN = I_MAST_MAKT-STLAN.
    ITAB-STLNR = I_MAST_MAKT-STLNR.


    IT_FINAL-MATNR = ITAB-MATNR.
    IT_FINAL-LONG_TXT = ITAB-LONG_TXT.
    IT_FINAL-WERKS = ITAB-WERKS.
    IT_FINAL-STLAN = ITAB-STLAN.
    IT_FINAL-STLAL = ITAB-STLAL.
    IT_FINAL-BMENG = ITAB-BMENG.
    IT_FINAL-BMEIN = ITAB-BMEIN.
    IT_FINAL-POSNR = ITAB-POSNR.
    IT_FINAL-IDNRK = ITAB-IDNRK.
    IT_FINAL-LONG_TXT1 = ITAB-LONG_TXT1.
    IT_FINAL-MENGE = ITAB-MENGE.
    IT_FINAL-MEINS = ITAB-MEINS.
    IT_FINAL-STLST = ITAB-STLST.
    IT_FINAL-ANDAT = ITAB-ANDAT.
    IT_FINAL-ANNAM = ITAB-ANNAM.
    IT_FINAL-DATUV = ITAB-DATUV.
    IT_FINAL-REF   = SY-DATUM.



    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = IT_FINAL-REF
      IMPORTING
        OUTPUT = IT_FINAL-REF.

    CONCATENATE IT_FINAL-REF+0(2) IT_FINAL-REF+2(3) IT_FINAL-REF+5(4)
                    INTO IT_FINAL-REF SEPARATED BY '-'.

    IT_FINAL-AENAM = ITAB-AENAM.
    IT_FINAL-AEdat = ITAB-AEDAT.




    READ TABLE IT_MARC INTO WA_MARC WITH KEY MATNR = IT_FINAL-IDNRK LVORM = 'X'.
    IF SY-SUBRC = 0.
      " CONTINUE.
    ENDIF.

    IF GV_COUNT   < 2.

      APPEND ITAB.
      APPEND IT_FINAL.
    ENDIF.
*APPEND it_final.
    CLEAR: LV_ID,ITAB-LONG_TXT,ITAB-LONG_TXT1,WA_STPO, GV_COUNT.
  ENDLOOP.
  CLEAR : GV_COUNT.

************************************************************************************************************

ENDFORM.

FORM FORM_HEADING .

  REFRESH T_FIELDCAT.

  PERFORM T_FIELDCATLOG USING  '1'  'MATNR'         'Material Code' '18'.
  PERFORM T_FIELDCATLOG USING  '2'  'LONG_TXT'         'Description' '50'.
  PERFORM T_FIELDCATLOG USING  '3'  'WERKS'         'Plant' '5'.
  PERFORM T_FIELDCATLOG USING  '4' 'STLAN'         'BOM Usage'   '10'.
  PERFORM T_FIELDCATLOG USING  '5' 'STLAL'         'Alt BOM' '10'. "<----------Added by nupur 10.12.11
  PERFORM T_FIELDCATLOG USING  '6'  'BMENG'         'Base Qty' '10'.
  PERFORM T_FIELDCATLOG USING  '7'  'BMEIN'         'UOM'  '5'.

  PERFORM T_FIELDCATLOG USING  '8'  'POSNR'         'Line Item' '15'.

  PERFORM T_FIELDCATLOG USING  '9'  'IDNRK'         'Component' '18'.
  PERFORM T_FIELDCATLOG USING  '10'  'LONG_TXT1'         'Component Description' '50'.
  PERFORM T_FIELDCATLOG USING  '11'  'MENGE'         'Qty' '10'.
  PERFORM T_FIELDCATLOG USING  '12'  'MEINS'         'UOM' '5'.
  PERFORM T_FIELDCATLOG USING  '13' 'STLST'         'BOM Status' '10'.
  PERFORM T_FIELDCATLOG USING  '14' 'ANDAT'         'Created Date' '15'.
  PERFORM T_FIELDCATLOG USING  '15' 'ANNAM'         'Created By' '15'.
  PERFORM T_FIELDCATLOG USING  '16' 'DATUV'         'Valid From' '15'.
  PERFORM T_FIELDCATLOG USING  '17' 'REF'         'Refresh Date' '15'.
  PERFORM T_FIELDCATLOG USING  '19' 'AEDAT'         'Changed  Date' '15'.
  PERFORM T_FIELDCATLOG USING  '18' 'AENAM'         'Changed By' '15'.


*   perform t_fieldcatlog using  '14' 'DATUV'         'Valid From'. "<----------Added by Amit 23.12.11
*   perform t_fieldcatlog using  '15' 'POSTP'         'Item Category'.
*   perform t_fieldcatlog using  '16' 'STLNR'         'Bill of Material'.

  PERFORM G_DISPLAY_GRID.
ENDFORM.                    " FORM_HEADING

FORM SORT_LIST .
  T_SORT-SPOS      = '1'.
  T_SORT-FIELDNAME = 'WERKS'.
  T_SORT-TABNAME   = 'ITAB[]'.
  T_SORT-UP        = 'X'.
  T_SORT-SUBTOT    = 'X'.
  APPEND T_SORT.

  T_SORT-SPOS      = '2'.
  T_SORT-FIELDNAME = 'MATNR'.
  T_SORT-TABNAME   = 'ITAB[]'.
  T_SORT-UP        = 'X'.
  T_SORT-SUBTOT    = 'X'.
  APPEND T_SORT.

  T_SORT-SPOS      = '3'.
  T_SORT-FIELDNAME = 'LONG_TXT'.
  T_SORT-TABNAME   = 'ITAB[]'.
  T_SORT-UP        = 'X'.
  T_SORT-SUBTOT    = 'X'.
  APPEND T_SORT.

  T_SORT-SPOS      = '12'.
  T_SORT-FIELDNAME = 'STLAL'.
  T_SORT-TABNAME   = 'ITAB[]'.
  T_SORT-UP        = 'X'.
*  t_sort-subtot    = 'X'.
  APPEND T_SORT.
ENDFORM.                    " SOR


**&---------------------------------------------------------------------*
**&      Form  G_DISPLAY_GRID
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*



FORM G_DISPLAY_GRID .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID
      IS_LAYOUT              = FS_LAYOUT
      I_CALLBACK_TOP_OF_PAGE = 'TOP-OF-PAGE'
      IT_FIELDCAT            = T_FIELDCAT[]
      IT_SORT                = T_SORT[]
      I_SAVE                 = 'X'
    TABLES
      T_OUTTAB               = ITAB
    EXCEPTIONS
      PROGRAM_ERROR          = 1
      OTHERS                 = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  IF P_DOWN = 'X'.
   PERFORM download TABLES it_final USING p_folder.
  ENDIF.


ENDFORM.                    " G_DISPLAY_GRID
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0800   text
*      -->P_0801   text
*      -->P_0802   text
*----------------------------------------------------------------------*
FORM T_FIELDCATLOG  USING    VALUE(X)
                             VALUE(F1)
                             VALUE(F2)
                             VALUE(P5).
  T_FIELDCAT-COL_POS = X.
  T_FIELDCAT-FIELDNAME = F1.
  T_FIELDCAT-SELTEXT_L = F2.
*  t_fieldcat-decimals_out = '2'.
  T_FIELDCAT-OUTPUTLEN   = P5.

*if f1 = 'MENGE'    or f1 = 'EXBAS'    or f1 = 'DR_EXBED' or f1 = 'DR_ECS'       or f1 = 'DR_EXADDTAX1' or
*   f1 = 'DR_EXAED' or f1 = 'CR_EXBED' or f1 = 'CR_ECS '  or f1 = 'CR_EXADDTAX1' or f1 = 'CR_EXAED'.
**   f1 = 'CL_EXBED' or f1 = 'CL_ECS'   or f1 = 'CL_EXAED' or f1 = 'CL_EXADDTAX1'.
*   t_fieldcat-do_sum = 'X'.
*  endif.
*
  APPEND T_FIELDCAT.
  CLEAR T_FIELDCAT.


ENDFORM.                    " T_FIELDCATLOG

FORM TOP-OF-PAGE.

*ALV Header declarations
  DATA: T_HEADER      TYPE SLIS_T_LISTHEADER,
        WA_HEADER     TYPE SLIS_LISTHEADER,
        T_LINE        LIKE WA_HEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

* Title
  WA_HEADER-TYP  = 'H'.
  WA_HEADER-INFO = 'BOM Component Details'.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR WA_HEADER.

* Date
*  wa_header-typ  = 'S'.
*  wa_header-key = 'From: '.
*  concatenate wa_header-info cpudt1+6(2) '.' cpudt1+4(2) '.' cpudt1(4) into wa_header-info.
*  concatenate wa_header-info ' To' cpudt-high+6(2) into wa_header-info separated by space.
*  concatenate wa_header-info  '.' cpudt-high+4(2) '.' cpudt-high(4) into wa_header-info. " separated by space.
*  append wa_header to t_header.
*  clear: wa_header.

*  CONCATENATE  sy-datum+6(2) '.'
*               sy-datum+4(2) '.'
*   sy-datum(4) INTO wa_header-info."todays date
*  CONCATENATE  into wa_header-info separated by space.

* Total No. of Records Selected
  DESCRIBE TABLE ITAB LINES LD_LINES.
  LD_LINESC = LD_LINES.

  CONCATENATE 'Total No. of Records Selected: ' LD_LINESC
     INTO T_LINE SEPARATED BY SPACE.

  WA_HEADER-TYP  = 'A'.
  WA_HEADER-INFO = T_LINE.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER, T_LINE.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER.
*       i_logo             = 'GANESH_LOGO'.
ENDFORM.                    " top-of-page
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download TABLES it_final USING p_folder.
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
      I_TAB_SAP_DATA       = IT_FINAL
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
  LV_FILE = 'ZBOM1.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZBOM_REPORTS', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_830 TYPE STRING.
    DATA LV_CRLF_830 TYPE STRING.
    LV_CRLF_830 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_830 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_830 LV_CRLF_830 WA_CSV INTO LV_STRING_830.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_830 TO LV_FULLFILE.
*TRANSFER lv_string_830 TO lv_fullfile.
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

  CONCATENATE 'Material Code'
              'Description'
              'Plant'
              'BOM Usage'
              'ALT BOM'
              'Base qty'
              'UOM'
              'Line Item No'
              'Component'
              'Component Description'
              'QTY'
              'UOM'
              'BOM Status'
              'Created Date'
              'Created By'
              'Valid From'
              'Refresh Date'
              'Changed By'
              'Changed Date'

              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
"ENDIF.
