REPORT zdev_as02_bdc.
*            NO STANDARD PAGE HEADING LINE-SIZE 255.




"CREATING STRUCTURE same as in excel file.
TYPES : BEGIN OF ty_as02,

          anln1     TYPE anla-anln1,                "Main Asset Number
          anln2     TYPE anla-anln2,                "SUB ASSET NUMBER
          bukrs     TYPE anla-bukrs,                "COMPANY CODE
          adatu(10) TYPE c,        " ANLZ-adatu,    "Date for beginning of validity
          msfak(4)  TYPE c,        "ANLZ-msfak,     "Multiple-shift factor for multiple shift operation
          aprop(8)  TYPE c,        "ANLB-aprop,     "Variable depreciation portion

        END OF ty_as02.


*          txt50   TYPE anla-txt50,    "string,
*          txa50   TYPE anla-txa50,    "string,
*          anlhtxt TYPE anlh-anlhtxt,  "string,

*          menge(18)   TYPE c,"anla-menge, "Quantity
*          meins   TYPE anla-meins,        "Base Unit of Measure
*          xhist   TYPE ra02s-xhist,       "Asset is managed historically
*          aktiv(10)   TYPE c,"anla-aktiv, "Asset capitalization date
*          werks   TYPE anlz-werks,        "Plant
*          stort   TYPE ANLZ-STORT,        "Asset location
*         invnr   TYPE anla-invnr,       "Inventory number
*          afasl   TYPE ANLB-afasl,         "Depreciation key
*          ndjar   TYPE ANLB-ndjar,         "Planned useful life in years
*          ndabp   TYPE ANLC-ndabp,         "Expired useful life in periods at start of fiscal year
*          afabg(10)   TYPE c,"ANLB-afabg,  "Depreciation calculation start date




***declaration********internal table*******
 data:  gt_sap TYPE STANDARD TABLE OF ty_as02,
        gt_bdcdata TYPE TABLE OF bdcdata,
        gt_message  TYPE TABLE OF bdcmsgcoll.

****declaration********work area************
data:  gs_sap type ty_as02,
      gs_bdcdata type bdcdata,
      gs_message type bdcmsgcoll.

********VARIABLE DECLARATION
DATA : GT_RAW type truxs_t_text_data.
DATA : ra_data(4096) type c occurs 0.

"ATSCREEN
*AT LINE-SELECTION.
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
      PARAMETERS : P_FILE  TYPE  RLGRAP-filename OBLIGATORY,
                   MODE_A TYPE  ctu_params-dismode default 'A' AS LISTBOX VISIBLE LENGTH 21.

SELECTION-SCREEN: END OF BLOCK B1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

  CALL FUNCTION 'F4_FILENAME'
   EXPORTING
     PROGRAM_NAME        = SYST-CPROG
     DYNPRO_NUMBER       = SYST-DYNNR
     FIELD_NAME          = 'X'
   IMPORTING
     FILE_NAME           = P_FILE.

*    CHECK P_FILE IS INITIAL.
*          MESSAGE 'PATH NOT STORE IN VARIABLE' TYPE 'W'.

START-OF-SELECTION.

*BREAK fujiabap.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
    I_LINE_HEADER               = 'X'
    i_tab_raw_data             = ra_data  "GT_RAW
    i_filename                 = P_FILE
  TABLES
    i_tab_converted_data       = GT_SAP[]
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
*IF sy- subrc = 0.
*     MESSAGE 'CONVERT SUCESSS' TYPE 'S'.
*  ELSE.
*     MESSAGE 'NOT CONVERT' TYPE 'W'.
** Implement suitable error handling here
*ENDIF.
**ENDFORM.

 PERFORM GET_BDC.            "PASS CONVERTED DATA .


*&---
*&---------------------------------------------------------------------*
*&      Form  GET_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_bdc .
  DATA : LV_TCODE TYPE CHAR4 VALUE 'AS02'.  " TCODE

   LOOP AT GT_SAP INTO GS_SAP.

"     PASS THE INTERNAL TABLE DATA
       PERFORM REC_ACTV.

 "    CALL TRANSACTION & PASS APPOPRIATE VALUE.
       PERFORM TCODE_AS02 USING LV_TCODE.

   ENDLOOP.

ENDFORM.

**&---------------------------------------------------------------------*
**&      Form  REC_ACTV
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
FORM rec_actv .

  REFRESH gt_bdcdata[].
  PERFORM bdc_dynpro      USING 'SAPLAIST' '0100'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLA-BUKRS'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
"1 main asset no ANLA-ANLN1
  PERFORM bdc_field       USING 'ANLA-ANLN1'
                                 "'400139'.
                                 GS_SAP-anln1.
"2 sub asset no. ANLA-ANLN2
  PERFORM bdc_field       USING 'ANLA-ANLN2'
                                 "'0'.
                                 GS_SAP-ANLN2.
"3 company code ANLA-BUKRS
  PERFORM bdc_field       USING 'ANLA-BUKRS'
                                 "'1000'.
                                 GS_SAP-BUKRS.

  PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=TAB02'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLA-TXT50'.

*  PERFORM bdc_field       USING 'ANLA-INVNR'
**                                'ARAMFSTELOWS1"'.
*                                 GS_SAP-invnr.
*
*
*  PERFORM bdc_field       USING 'ANLA-MENGE'
*                                 "'14'.
*                                 GS_SAP-MENGE.
*
*  PERFORM bdc_field       USING 'ANLA-MEINS'
*                                 "'EA'.
*                                 GS_SAP-meins.
*
*  PERFORM bdc_field       USING 'RA02S-XHIST'
*                                "'X'.
*                                 GS_sap-xhist.
*
*  PERFORM bdc_field       USING 'ANLA-AKTIV'
*                                "'21.03.2017'.
*                                 gs_sap-aktiv.

  PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=TIME'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLZ-KOSTL'.

*  PERFORM bdc_field       USING 'ANLZ-WERKS'
*                                "'PL01'.
*                                GS_SAP-WERKS.
*
*  PERFORM bdc_field       USING 'ANLZ-STORT'
*                                "'0001'.
*                                 GS_SAP-STORT.

  PERFORM bdc_dynpro      USING 'SAPLAIST' '3000'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLZ-KOSTL(01)'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=CINV'.
  PERFORM bdc_dynpro      USING 'SAPLAIST' '3010'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLZ-ADATU'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=ENTE'.
"4  Date for beginning of validity  ANLZ-ADATU
  PERFORM bdc_field       USING 'ANLZ-ADATU'
                                "'01.04.2017'.
                                GS_SAP-adatu.

  PERFORM bdc_dynpro      USING 'SAPLAIST' '3000'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLZ-MSFAK(01)'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=RW'.
 "5
 "REPEATED MSFAK
  PERFORM bdc_field       USING 'ANLZ-MSFAK(01)'
*                                 "'1.5'.
                                 GS_SAP-MSFAK.

  PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=TAB08'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLZ-KOSTL'.
*REPEATED
*  PERFORM bdc_field       USING 'ANLZ-WERKS'
*                                "'PL01'.
*                                 GS_SAP-werks.
*  PERFORM bdc_field       USING 'ANLZ-STORT'
*                                "'0001'.
*                                 GS_SAP-STORT.
* "REPEATED MSFAK                                                       " check this also
*  PERFORM bdc_field       USING 'ANLZ-MSFAK'
*                                 "'1.50'.
*                                 GS_SAP-MSFAK.

  PERFORM bdc_dynpro      USING 'SAPLAIST' '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=SELZ'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLB-AFASL(01)'.
  PERFORM bdc_dynpro      USING 'SAPLAIST' '0195'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=BUCH'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'ANLB-APROP'.

*  PERFORM bdc_field       USING 'ANLB-AFASL'
*                                "'IN15'.
*                                 GS_SAP-afasl.
*  PERFORM bdc_field       USING 'ANLB-NDJAR'
*                                 "'15'.
*                                 GS_SAP-ndjar.
*  PERFORM bdc_field       USING 'ANLC-NDABP'
*                                "'11'.
*                                 GS_SAP-NDABP.
*  PERFORM bdc_field       USING 'ANLB-AFABG'
*                                "'21.03.2017'.
*                                 GS_SAP-AFABG.
"6 Variable depreciation portion  ANLB-APROP
  PERFORM bdc_field       USING 'ANLB-APROP'
                                "'100'.
                                 GS_SAP-APROP.


ENDFORM.
*
*
**&---------------------------------------------------------------------*
**&      Form  TCODE_AS02
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
FORM tcode_as02 USING LV_TCODE .

   CALL TRANSACTION LV_TCODE USING gt_bdcdata
                             MODE MODE_A
                             UPDATE 'S'
                             MESSAGES INTO GT_MESSAGE.


ENDFORM.
*
*
*
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
*  CLEAR bdcdata.
  GS_bdcdata-program  = program.
  GS_bdcdata-dynpro   = dynpro.
  GS_bdcdata-dynbegin = 'X'.
  APPEND GS_bdcdata TO GT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval IS NOT INITIAL.   "<> nodata.
    CLEAR GS_bdcdata.
    GS_bdcdata-fnam = fnam.
    GS_bdcdata-fval = fval.
    APPEND GS_bdcdata TO GT_BDCDATA.
  ENDIF.

ENDFORM.
