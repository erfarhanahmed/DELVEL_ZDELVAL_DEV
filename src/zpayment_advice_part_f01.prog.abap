*&---------------------------------------------------------------------*
*&  Include           ZPAYMENT_ADVICE_F01
*&---------------------------------------------------------------------*

FORM GET_VENDOR_DATA.
  SELECT LF~LIFNR
         LF~NAME1
         AD~STREET
        AD~CITY1
        AD~POST_CODE1
    FROM LFA1 AS LF
    JOIN ADRC AS AD ON LF~ADRNR = AD~ADDRNUMBER
    INTO  WA_LFA1 UP TO 1 ROWS
    WHERE LF~LIFNR = P_LIFNR .
  ENDSELECT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BANK_DETAILS
*&---------------------------------------------------------------------*

FORM GET_BANK_DETAILS .
  SELECT SINGLE BUKRS
         BUTXT
    FROM T001
    INTO WA_T001
    WHERE BUKRS = P_BUKRS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COMBINE_HEADER_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM COMBINE_HEADER_DETAILS .

  WA_HEADER_DETAILS-LIFNR  = WA_LFA1-LIFNR.
  WA_HEADER_DETAILS-NAME1 = WA_LFA1-NAME1.
  WA_HEADER_DETAILS-STREET = WA_LFA1-STREET.
  WA_HEADER_DETAILS-CITY1 = WA_LFA1-CITY1.
  WA_HEADER_DETAILS-POST_CODE1 = WA_LFA1-POST_CODE1.
  WA_HEADER_DETAILS-BUTXT = WA_T001-BUTXT.
  WA_HEADER_DETAILS-AUGBL = P_AUGBL.

  READ TABLE IT_BKPF INTO DATA(WA_BKPF) INDEX 1.
  WA_HEADER_DETAILS-AUGDT = WA_BKPF-AUGDT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ACC_HEADER_DATA
*&---------------------------------------------------------------------*

FORM GET_ACC_HEADER_DATA .
  SELECT BK~BELNR,BK~BUKRS, BK~GJAHR, BK~AUGBL, BK~AUGDT,BK~BLART, BG~XBLNR, BG~BUDAT, BG~BLDAT
    FROM  BSAK AS BK
    JOIN BKPF AS BG ON BK~BELNR = BG~BELNR AND BK~BUKRS = BG~BUKRS AND BK~GJAHR = BG~GJAHR
    INTO TABLE  @IT_BKPF
    WHERE BK~AUGBL = @P_AUGBL AND BK~GJAHR IN @S_GJAHR AND BK~BUKRS = @P_BUKRS    """= @P_GJAHR added by sp in @s_gjahr 04.12.2023
    AND BK~BLART IN ( 'KR' , 'RE' , 'KG' , 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' )  " ADD SP 'RL' , 'RX' , 'ZA' , 'AB' , 'SA' ON 15.01.2024
    and bk~lifnr = @P_LIFNR. "ADDED BY PRIMUS JYOTI ON 08.03.2024

*     DELETE IT_BKPF INDEX 1.
*    delete ADJACENT DUPLICATES FROM it_bkpf COMPARING AUGBL."ADDED BY PRIMUS JYOTI ON 08.03.2024
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_GROSS_DETAILS
*&---------------------------------------------------------------------*

FORM GET_GROSS_DETAILS .
  SELECT BUKRS, GJAHR, BELNR, BUZEI, DMBTR, BSCHL, KOART, augbl, KTOSL
            FROM  BSEG
            INTO TABLE @IT_GROSS
            FOR ALL ENTRIES IN @IT_BKPF
            WHERE BELNR = @IT_BKPF-BELNR AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
*            WHERE augbl = @IT_BKPF-augbl AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
            AND KOART IN ( 'S' , 'A' )                     "#EC CI_NO_TRANSFORM """"K ADDED BY SP ON 16.01.2024(S)
            AND BSCHL IN ( '86' , '40' , '37','96' , '70' ) .    " ADDED BY SP ON 16.01.2024

************added by primus jyoti on 08.03.2024*****************************
 SELECT BUKRS, GJAHR, BELNR, BUZEI, DMBTR, BSCHL, KOART, augbl, KTOSL
            FROM  BSEG
            INTO TABLE @IT_GROSS_rej
            FOR ALL ENTRIES IN @IT_BKPF
*            WHERE BELNR = @IT_BKPF-BELNR AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
            WHERE augbl = @IT_BKPF-augbl AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
            AND KOART = 'K'
            AND BSCHL IN ( '21' ) .

***************************************************************************


    " ADDED BY SP ON .01.02.2024
    SELECT BUKRS, GJAHR, BELNR, BUZEI, DMBTR, BSCHL, KOART , augbl , KTOSL
            FROM  BSEG
            INTO TABLE @IT_GROSS3
            FOR ALL ENTRIES IN @IT_BKPF
            WHERE BELNR = @IT_BKPF-BELNR AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
*           WHERE augbl = @IT_BKPF-augbl AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
            AND KOART = 'S'                       "#EC CI_NO_TRANSFORM """"K ADDED BY SP ON 16.01.2024(S)
            AND BSCHL IN ( '96' , '40' ) .    " ADDED BY SP ON 16.01.2024
" ADDED BY SP ON 01.02.2024



"ADD SP ON 16.01.2024"
    SELECT BUKRS, GJAHR, BELNR, BUZEI, DMBTR, BSCHL, KOART, augbl, KTOSL
            FROM  BSEG
            INTO TABLE @IT_GROSS1
            FOR ALL ENTRIES IN @IT_BKPF
            WHERE BELNR = @IT_BKPF-BELNR AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
*           WHERE augbl = @IT_BKPF-augbl AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
            AND KOART = 'K'                       "#EC CI_NO_TRANSFORM """"K ADDED BY SP ON 16.01.2024(S)
            AND BSCHL = '37'  .    " ADDED BY SP ON 16.01.2024
"ADD SP ON 16.01.2024"



      IT_GROSS2[] = IT_GROSS[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TDS_DETAILS
*&---------------------------------------------------------------------*
FORM GET_TDS_DETAILS .
                  "#EC CI_NO_TRANSFORM
  SELECT BUKRS, GJAHR, BELNR, BUZEI, DMBTR, BSCHL, KOART , augbl,KTOSL
            FROM  BSEG
            INTO TABLE @IT_TDS
            FOR ALL ENTRIES IN @IT_BKPF
            WHERE BELNR = @IT_BKPF-BELNR AND BUKRS = @IT_BKPF-BUKRS AND GJAHR = @IT_BKPF-GJAHR
            AND KTOSL = 'WIT' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FINAL_DATA
*&---------------------------------------------------------------------*

FORM FINAL_DATA .
  DATA WA_FINAL TYPE ZPAYMENT_ADVICE_STR.
  SORT IT_BKPF ASCENDING BY BELNR.
  SORT IT_GROSS ASCENDING BY BELNR BSCHL.
  SORT IT_TDS ASCENDING BY BELNR.
Data(it_bkpf_kg) = IT_BKPF.
delete it_bkpf_kg WHERE blart NE 'KG'.
  LOOP AT IT_BKPF ASSIGNING FIELD-SYMBOL(<FS_BKPF>).
    WA_FINAL-XBLNR = <FS_BKPF>-XBLNR.
    WA_FINAL-BUDAT = <FS_BKPF>-BUDAT.
    WA_FINAL-BELNR = <FS_BKPF>-BELNR.
    WA_FINAL-BLDAT = <FS_BKPF>-BLDAT.
    WA_FINAL-BLART = <FS_BKPF>-BLART."ADDED BY PRIMUS JYOTI ON 08.03.2024

"""""""""COMMENTED BY SP ON 16.01.2024""""""""""""""""""""""
****      READ TABLE IT_GROSS ASSIGNING FIELD-SYMBOL(<FS_GROSS>) WITH  KEY BELNR = <FS_BKPF>-BELNR BSCHL = TEXT-T02  BINARY SEARCH  . " get gross amnt
****      IF  <FS_GROSS> IS ASSIGNED.
****        WA_FINAL-GROSS_DMBTR = <FS_GROSS>-DMBTR.
****        UNASSIGN <FS_GROSS>.
****      ENDIF.
****
****"""""""""ADDED BY SP 15.01.2024"""""""""""""""
      READ TABLE IT_GROSS1 ASSIGNING FIELD-SYMBOL(<FS_GROSS1>) WITH  KEY BELNR = <FS_BKPF>-BELNR BSCHL = TEXT-T04 BINARY SEARCH  . " get gross amnt
      IF  <FS_GROSS1> IS ASSIGNED.
        WA_FINAL-GROSS_DMBTR = <FS_GROSS1>-DMBTR * -1.
*        WA_FINAL-BSCHL       = <FS_GROSS1>-BSCHL. "ADD SP ON 15.01.2024
        UNASSIGN <FS_GROSS1>.
      ENDIF.
****"""""""""ADDED BY SP 15.01.2024"""""""""""""""
"""""""""COMMENTED BY SP ON 16.01.2024""""""""""""""""""""""

****"""""""""ADDED BY SP 16.01.2024"""""""""""""""
LOOP AT IT_GROSS ASSIGNING FIELD-SYMBOL(<FS_GROSS>) WHERE BELNR = WA_FINAL-BELNR.

WA_FINAL-BSCHL   = <FS_GROSS>-BSCHL.


IF WA_FINAL-BSCHL NE '96'.                     "ADDED AS 24/01/2024

WA_FINAL-GROSS_DMBTR = WA_FINAL-GROSS_DMBTR + <FS_GROSS>-DMBTR.




"""""""""""""""""""""""""ADDED BY SP ON 01.02.2024
ELSEIF IT_GROSS3 IS NOT INITIAL.

  WA_FINAL-GROSS_DMBTR = ' '.
*
ENDIF.
*"""""""""""""""""""""""""ADDED BY SP ON 01.02.2024


**ENDIF.


ENDLOOP.
****"""""""""ADDED BY SP 16.01.2024"""""""""""""""


*READ TABLE it_bkpf_kg INTO data(wa_bkpf_kg) with key augbl = WA_bkpf-augbl.
*if sy-subrc is INITIAL.
*    READ TABLE IT_GROSS ASSIGNING FIELD-SYMBOL(<FS_REJECTION>) WITH  KEY BELNR = <FS_BKPF>-BELNR BSCHL = TEXT-T03 BINARY SEARCH. " get rejection DN amnt
* if WA_FINAL-xblnr = wa_bkpf_kg-xblnr.
if WA_FINAL-BLART = 'KG'.
    READ TABLE IT_GROSS_rej ASSIGNING FIELD-SYMBOL(<FS_REJECTION>)
             WITH  KEY augbl = <FS_BKPF>-augbl BSCHL = TEXT-T03 BINARY SEARCH. " get rejection DN amnt   "ADDED BY PRIMUS JYOTI ON 08.03.2024
    IF  <FS_REJECTION> IS ASSIGNED.
      WA_FINAL-REJECTION_DMBTR = <FS_REJECTION>-DMBTR .
      UNASSIGN <FS_REJECTION>.
    ENDIF.


*    READ TABLE IT_GROSS2 ASSIGNING FIELD-SYMBOL(<FS_REJECTION2>) WITH  KEY BELNR = <FS_BKPF>-BELNR BSCHL = TEXT-T05 ."BINARY SEARCH. " get rejection DN amnt  "23/01/2024
    READ TABLE IT_GROSS_rej ASSIGNING FIELD-SYMBOL(<FS_REJECTION2>)
             WITH  KEY augbl = <FS_BKPF>-augbl BSCHL = TEXT-T05 ."BINARY SEARCH. " get rejection DN amnt  "ADDED BY PRIMUS JYOTI ON 08.03.2024
    IF  <FS_REJECTION2> IS ASSIGNED.
      WA_FINAL-REJECTION_DMBTR = <FS_REJECTION2>-DMBTR * -1. " ADDED BY SP ON 01.02.2024* -1
      UNASSIGN <FS_REJECTION2>.
    ENDIF.

endif.

*    READ TABLE IT_TDS ASSIGNING FIELD-SYMBOL(<FS_TDS>) WITH KEY BELNR = <FS_BKPF>-BELNR BINARY SEARCH. " get TDS amnt
LOOP AT IT_TDS ASSIGNING FIELD-SYMBOL(<FS_TDS>) WHERE BELNR = <FS_BKPF>-BELNR  AND KTOSL = 'WIT'.
*    IF  <FS_TDS> IS ASSIGNED.
        WA_FINAL-TDS_DMBTR =  WA_FINAL-TDS_DMBTR + <FS_TDS>-DMBTR.
*      UNASSIGN <FS_TDS>.
*    ENDIF.
ENDLOOP.
"C

WA_FINAL-NET_DMBTR = WA_FINAL-GROSS_DMBTR - WA_FINAL-TDS_DMBTR - WA_FINAL-REJECTION_DMBTR.   "WA_FINAL-REJECTION_DMBTR ADDED BY SP ON 01.02.2024

"ADDED BY SP ON 16.01.2024""""

*    IF WA_FINAL-BLART = 'KR' OR WA_FINAL-BLART = 'RX' OR  WA_FINAL-BLART = 'RE' OR WA_FINAL-BLART = 'RL'
*      OR  WA_FINAL-BLART = 'AB' OR  WA_FINAL-BLART = 'SA' OR  WA_FINAL-BLART = 'ZA' .
    APPEND WA_FINAL TO IT_FINAL.

    "Generate excel file data
    WA_EXCEL-LINE1 = WA_FINAL-XBLNR.
    WA_EXCEL-LINE2 =  WA_FINAL-BUDAT.
    WA_EXCEL-LINE3 =  WA_FINAL-BELNR.
    WA_EXCEL-LINE4 =  WA_FINAL-BLDAT.
    WA_EXCEL-LINE5 =  WA_FINAL-BLART.
    WA_EXCEL-LINE6 =  WA_FINAL-GROSS_DMBTR.
    WA_EXCEL-LINE7 =  WA_FINAL-REJECTION_DMBTR.
    WA_EXCEL-LINE8 =  WA_FINAL-TDS_DMBTR.
    WA_EXCEL-LINE9 =  WA_FINAL-NET_DMBTR.
    APPEND WA_EXCEL TO IT_EXCEL.

*   ENDIF.
    CLEAR: WA_FINAL, WA_EXCEL.
  ENDLOOP.
    FREE: IT_BKPF, IT_GROSS, IT_TDS.
  DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING ALL FIELDS.
  DELETE ADJACENT DUPLICATES FROM IT_EXCEL COMPARING ALL FIELDS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_SMARTFORM
*&---------------------------------------------------------------------*

FORM DISPLAY_SMARTFORM .

  PERFORM GET_SF_FM.

  CALL FUNCTION FM_NAME
    EXPORTING
      WA_HEADER_DETAILS = WA_HEADER_DETAILS
    TABLES
      IT_FINAL          = IT_FINAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT_EXCEL
*&---------------------------------------------------------------------*

FORM PRINT_EXCEL .
  DATA:V_FULLPATH TYPE STRING.

  CALL FUNCTION 'GUI_FILE_SAVE_DIALOG'
    EXPORTING
      WINDOW_TITLE      = 'STATUS RECORD FILE(.XLS OR .TXT)'
      DEFAULT_EXTENSION = '.xls'
    IMPORTING
      FULLPATH          = V_FULLPATH.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      FILENAME              = V_FULLPATH
      FILETYPE              = 'ASC'
      WRITE_FIELD_SEPARATOR = 'X'
    TABLES
      DATA_TAB              = IT_EXCEL
    EXCEPTIONS
      OTHERS                = 22.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    MESSAGE TEXT-E02 TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_SF_FM
*&---------------------------------------------------------------------*

FORM GET_SF_FM .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME           = 'ZPAYMENT_ADVICE'
    IMPORTING
      FM_NAME            = FM_NAME
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.
  IF SY-SUBRC <> 0.
    MESSAGE TEXT-E01 TYPE TEXT-T01.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_HEADER
*&---------------------------------------------------------------------*

FORM GET_HEADER .

  WA_EXCEL-LINE1 = TEXT-014.
  WA_EXCEL-LINE2 =  WA_HEADER_DETAILS-LIFNR.
  APPEND WA_EXCEL TO IT_EXCEL.
  CLEAR WA_EXCEL.

  WA_EXCEL-LINE1 = TEXT-015.
  WA_EXCEL-LINE2 =  WA_HEADER_DETAILS-NAME1.
  APPEND WA_EXCEL TO IT_EXCEL.
  CLEAR WA_EXCEL.

  WA_EXCEL-LINE1 = TEXT-013.
  WA_EXCEL-LINE2 =  |{ WA_HEADER_DETAILS-AUGBL } { 'DT' } { WA_HEADER_DETAILS-AUGDT } |.
  APPEND WA_EXCEL TO IT_EXCEL.
  CLEAR WA_EXCEL.

  APPEND WA_EXCEL TO IT_EXCEL. "Empty row

  WA_EXCEL-LINE1 = TEXT-004.
  WA_EXCEL-LINE2 =  TEXT-005.
  WA_EXCEL-LINE3 =  TEXT-006.
  WA_EXCEL-LINE4 =  TEXT-007.
  WA_EXCEL-LINE5 =  TEXT-020.
  WA_EXCEL-LINE6 =  TEXT-008.
  WA_EXCEL-LINE7 =  TEXT-009.
  WA_EXCEL-LINE8 =  TEXT-010.
  WA_EXCEL-LINE9 =  TEXT-011.
  APPEND WA_EXCEL TO IT_EXCEL.
  CLEAR WA_EXCEL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT_PDF
*&---------------------------------------------------------------------*

FORM PRINT_PDF .

  PERFORM GET_SF_FM .

  LS_CTRLOP-GETOTF = 'X'.
  LS_CTRLOP-NO_DIALOG = 'X'.
  LS_CTRLOP-PREVIEW = 'X' . "space.
*
*      "Output Options
  LS_OUTOPT-TDNOPREV = 'X'.
  LS_OUTOPT-TDDEST = 'LP01'.
  LS_OUTOPT-TDNOPRINT = 'X'.


  CALL FUNCTION FM_NAME
    EXPORTING
      CONTROL_PARAMETERS = LS_CTRLOP
      OUTPUT_OPTIONS     = LS_OUTOPT
      USER_SETTINGS      = 'X'
      WA_HEADER_DETAILS  = WA_HEADER_DETAILS
    IMPORTING
      JOB_OUTPUT_INFO    = GV_JOB_OUTPUT
    TABLES
      IT_FINAL           = IT_FINAL
    EXCEPTIONS
      FORMATTING_ERROR   = 1
      INTERNAL_ERROR     = 2
      SEND_ERROR         = 3
      USER_CANCELED      = 4
      OTHERS             = 5.
  IF SY-SUBRC <> 0.
    MESSAGE TEXT-E01 TYPE TEXT-T01.
  ENDIF.
*
  CALL FUNCTION 'HR_IT_DISPLAY_WITH_PDF'
*     EXPORTING
*       IV_PDF          =
    TABLES
      OTF_TABLE = GV_JOB_OUTPUT-OTFDATA.
ENDFORM.
