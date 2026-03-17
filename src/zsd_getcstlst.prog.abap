*&---------------------------------------------------------------------*
*& Report ZSD_GETCSTLST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsd_getcstlst.

TABLES : stxh.

*----------------------------------------------------------------------*
FORM get_cstlst TABLES in_tab STRUCTURE itcsy
              out_tab STRUCTURE itcsy  .

  TYPES: BEGIN OF ty_konv,
           knumv TYPE vbak-knumv,
           kposn TYPE prcd_elements-kposn,
           stunr TYPE prcd_elements-stunr,
           zaehk TYPE prcd_elements-zaehk,
           kschl TYPE prcd_elements-kschl,
           kwert TYPE kwert,
         END OF ty_konv.

  DATA: v_custname    TYPE vbak-kunnr,
        v_cst         TYPE j_1icstno,
        v_lst         TYPE j_1ilstno,
        v_exc         TYPE j_1iexcd, "  j_1iexrn,
        v_cdd         TYPE vbak-vdatu,
        v_cdd1        TYPE text10,
        dt            TYPE text10,
        v_salesorder  TYPE thead-tdname,     "PASSING DATA FROM SCRIPT
        v_salesorder1 TYPE vbak-vbeln,
        v_knumv       TYPE vbak-knumv,     "VARIABLE TO PASS NEW VALUE
        sum_kwert     TYPE kwert,
        sum_pf        TYPE kwert,
        sum_sales     TYPE kwert,
        v_sorder      TYPE thead-tdname. "VBELN,.



  DATA: it_konv TYPE STANDARD TABLE OF ty_konv,
        wa_konv TYPE ty_konv,
        v_ofm   TYPE char20.
  DATA: it_line_header TYPE STANDARD TABLE OF tline,
        wa_line_header TYPE tline.

****READING CUSTOMER NAME FROM IN_TAB
  READ TABLE in_tab INDEX 1 .
  v_custname = in_tab-value.

****READING SALES ORDER NO FROM IN_TAB
  READ TABLE in_tab INDEX 2 .
  v_salesorder = in_tab-value.

*****CONVERSION FOR CUSTOMER NO.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_custname
    IMPORTING
      output = v_custname.

*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    INPUT         = V_SALESORDER
* IMPORTING
*   OUTPUT        = V_SALESORDER
  .


****SELECTING EXCISE DETAILS FROM J_1IMOCUST
  SELECT    kunnr
            j_1iexcd
            j_1icstno
            j_1ilstno
      FROM  j_1imocust
      INTO (v_custname,
            v_exc,
            v_cst,
            v_lst)
      WHERE kunnr = v_custname .

  ENDSELECT.

*****SELECTING REQUIRED DELIVERY DATE FORM VBAK.
  SELECT vbeln
         vdatu
         knumv
    FROM vbak
    INTO (v_salesorder1,
          v_cdd,
          v_knumv)
    WHERE vbeln = v_salesorder.
  ENDSELECT.
******SELECTING DATA FROM KONV.
**    SELECT KNUMV
**           KPOSN
**           STUNR
**           ZAEHK
**           KSCHL
**           KWERT
**      FROM KONV
**      INTO CORRESPONDING FIELDS OF TABLE IT_KONV
**      WHERE KNUMV = V_KNUMV AND ( KSCHL = 'ZPFO' OR KSCHL = 'ZPR0').
**
**      LOOP AT IT_KONV INTO WA_KONV.
**        SUM_KWERT = SUM_KWERT + WA_KONV-KWERT.
**
**        IF WA_KONV-KSCHL = 'ZPFO'.
**          SUM_PF = SUM_PF + WA_KONV-KWERT.
**          ELSE.
**          SUM_SALES = SUM_SALES + WA_KONV-KWERT.
**        ENDIF.
***
**        ENDLOOP.
***        CLEAR: SUM_KWERT,
***               SUM_PF,
***               SUM_SALES.

*OFM DATE

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_salesorder1
    IMPORTING
      output = v_salesorder1.
  v_sorder = v_salesorder1.
  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
     WHERE mandt    = sy-mandt
       AND tdobject = 'VBBK'
       AND tdname   = v_salesorder1
       AND tdid     = 'Z016'
       AND tdspras  = 'E'.
  IF sy-subrc = 0.
*READING INSURANCE-HEADER TEXT FROM SALESORDER  (V_SALESORDER).
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'Z016'
        language = 'E'
        name     = v_sorder
        object   = 'VBBK'
      TABLES
        lines    = it_line_header.

    CLEAR  v_ofm .
    LOOP AT it_line_header INTO wa_line_header WHERE tdline IS NOT INITIAL.
      v_ofm = wa_line_header-tdline.
    ENDLOOP.
  ENDIF.



****CONVERSION OF DATE FORMAT TO DD.MM.YYYY.
  v_cdd1 = v_cdd.
  CONCATENATE v_cdd1+6(2) '.' v_cdd1+4(2) '.' v_cdd1+0(4) INTO dt.
  CLEAR v_cdd1.
****PASSING EXCISE DETAILS TO OUT_TAB------------------------*
  READ TABLE out_tab INDEX 4 . "WA_LINE_ITEM.
  out_tab-value = v_exc.
  MODIFY out_tab INDEX 4.

  READ TABLE out_tab INDEX 3 .
  out_tab-value = v_lst.
  MODIFY out_tab INDEX 3.
*
  READ TABLE out_tab INDEX 2 .
  out_tab-value = v_cst.
  MODIFY out_tab INDEX 2.

  READ TABLE out_tab INDEX 5 .
  out_tab-value = dt."DT  replaced to get date format mm/dd/yyyy.
  MODIFY out_tab INDEX 5 .

  READ TABLE out_tab INDEX 6 .
  out_tab-value = v_ofm.
  MODIFY out_tab INDEX 6 .


ENDFORM.                    "GET_CUST_NAME

*&---------------------------------------------------------------------*
*&      Form  GET_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_value TABLES in_tab STRUCTURE itcsy
              out_tab STRUCTURE itcsy  .

* THIS NEEDS TO BE CALLED UNDER THE ELEMENT 'ITEM LINE' UNDER WINDOW MAIN.
* THE READ LINE DEPENDS ON THE USING CHANGING LINES IN THE CALLING PROG OF SAP SCRIPT.

  TYPES: BEGIN OF ty_konv,
           knumv TYPE vbak-knumv,  "NUMBER OF THE DOCUMENT CONDITION
           kposn TYPE prcd_elements-kposn,  "CONDITION ITEM NUMBER
           stunr TYPE prcd_elements-stunr,  "STEP NUMBER
           zaehk TYPE prcd_elements-zaehk,  "CONDITION COUNTER
           kschl TYPE prcd_elements-kschl,  "CONDITION TYPE
           kwert TYPE kwert,       "CONDITION VALUE
           kbetr TYPE kbetr,       "RATE (CONDITION AMOUNT OR PERCENTAGE)
         END OF ty_konv.

  TYPES: BEGIN OF ty_vbap,
           vbeln  TYPE vbap-vbeln,
           posnr  TYPE vbap-posnr,
           kwmeng TYPE vbap-kwmeng,
           vrkme  TYPE vbap-vrkme,
         END OF ty_vbap.

  DATA: v_custname    TYPE vbak-kunnr,
        v_cst         TYPE j_1icstno,
        v_lst         TYPE j_1ilstno,
        v_exc         TYPE j_1iexrn,
        v_cdd         TYPE vbak-vdatu,
        v_cdd1        TYPE text10,
        dt            TYPE text10,
        v_salesorder  TYPE thead-tdname,     "PASSING DATA FROM SCRIPT
        v_salesorder1 TYPE vbak-vbeln,
        v_knumv       TYPE vbak-knumv,     "VARIABLE TO PASS NEW VALUE
        sum_kwert     TYPE kwert,
        sum_pf        TYPE kwert,
        sum_sales     TYPE kwert,
        v_price1      TYPE char18,
        v_value1      TYPE char18,
        v_item        TYPE prcd_elements-kposn,
        v_price       TYPE prcd_elements-kbetr,
        v_value       TYPE prcd_elements-kwert,
        v_qty         TYPE lips-lfimg,
        v_decoy       TYPE n LENGTH 17.                             " saumitra "

  DATA: it_konv TYPE STANDARD TABLE OF ty_konv,
        wa_konv TYPE ty_konv.

****READING SALES ORDER NO FROM IN_TAB
  READ TABLE in_tab INDEX 1 .
  v_salesorder = in_tab-value.
****READING ITEM NO FROM IN_TAB
  READ TABLE in_tab INDEX 2 .
  v_item = in_tab-value.

  READ TABLE in_tab INDEX 3 .
  " changes by saumitra "
  v_decoy = in_tab-value.

  v_qty = v_decoy.
*  V_QTY = IN_TAB-VALUE.

***CONVERSION FOR SALES ORDER ITEM NUMBERS.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_item
    IMPORTING
      output = v_item.

***CONVERSION FOR KNUMV NUMBERS.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_knumv
    IMPORTING
      output = v_knumv.

*****SELECTING REQUIRED DELIVERY DATE FORM VBAK.
  SELECT  SINGLE vbeln vdatu knumv
    FROM vbak
    INTO (v_salesorder1, v_cdd,v_knumv)
    WHERE vbeln = v_salesorder.
*  ENDSELECT.
******SELECTING DATA FROM KONV.
  SELECT knumv kposn stunr
         zaehk kschl kwert kbetr
   from PRCD_ELEMENTS "FROM konv
    INTO CORRESPONDING FIELDS OF TABLE it_konv
    WHERE knumv = v_knumv AND ( kschl = 'ZPFO' OR kschl = 'ZPR0')
    AND kposn = v_item.

  LOOP AT it_konv INTO wa_konv.
    sum_kwert = sum_kwert + wa_konv-kwert.

    IF wa_konv-kschl = 'ZPFO'.
      sum_pf = sum_pf + wa_konv-kwert.
    ELSE.  " WA_KONV-KSCHL = 'ZPR0'
      sum_sales = sum_sales + wa_konv-kwert.

      v_price = ( wa_konv-kwert / v_qty ).
      v_value = wa_konv-kwert.
*      CLEAR V_QTY.
    ENDIF.
*          CLEAR V_QTY.
  ENDLOOP.

  v_price1 = v_price.
  v_value1 = v_value.

  CONDENSE : v_price1 , v_value1.
*****************************new variable to convert V_Value1 to integer.
  DATA: v_value2(16) TYPE p DECIMALS 2.

*  v_value2 = v_value1.
* CONDENSE :  V_VALUE2.
****PASSING EXCISE DETAILS TO OUT_TAB------------------------*
*  READ TABLE OUT_TAB INDEX 1. "TOTAL AMOUNT.
*  OUT_TAB-VALUE = SUM_KWERT.
*  MODIFY OUT_TAB INDEX 1.

*  READ TABLE OUT_TAB INDEX 2 . "PACKING & FORWARDING.
*  OUT_TAB-VALUE = SUM_PF.
*  MODIFY OUT_TAB INDEX 2.
*
*  READ TABLE OUT_TAB INDEX 3 . "SALES TOTAL.
*  OUT_TAB-VALUE = SUM_SALES.
*  MODIFY OUT_TAB INDEX 3.

  READ TABLE out_tab INDEX 1 . "NET PRICE.
  out_tab-value = v_price1.
  MODIFY out_tab INDEX 1.

  READ TABLE out_tab INDEX 2 . "NET VALUE.
  WRITE v_value1 TO out_tab-value .
*  OUT_TAB-VALUE = V_VALUE1.
  MODIFY out_tab INDEX 2.



ENDFORM.                    "GET_VALUE

*&---------------------------------------------------------------------*
*&      Form  GET_VALUE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_value1 TABLES in_tab STRUCTURE itcsy
            out_tab STRUCTURE itcsy  .

* THIS NEEDS TO BE CALLED UNDER THE ELEMENT 'ITEM LINE' UNDER WINDOW MAIN.
* THE READ LINE DEPENDS ON THE USING CHANGING LINES IN THE CALLING PROG OF SAP SCRIPT.

  TYPES: BEGIN OF ty_konv,
           knumv TYPE vbak-knumv,  "NUMBER OF THE DOCUMENT CONDITION
           kposn TYPE prcd_elements-kposn,  "CONDITION ITEM NUMBER
           stunr TYPE prcd_elements-stunr,  "STEP NUMBER
           zaehk TYPE prcd_elements-zaehk,  "CONDITION COUNTER
           kschl TYPE prcd_elements-kschl,  "CONDITION TYPE
           kwert TYPE kwert,       "CONDITION VALUE
           kbetr TYPE kbetr,       "RATE (CONDITION AMOUNT OR PERCENTAGE)
         END OF ty_konv.

  TYPES: BEGIN OF ty_vbap,
           vbeln  TYPE vbap-vbeln,
           posnr  TYPE vbap-posnr,
           kwmeng TYPE vbap-kwmeng,
           vrkme  TYPE vbap-vrkme,
         END OF ty_vbap.




  DATA: v_custname    TYPE vbak-kunnr,
        v_cst         TYPE j_1icstno,
        v_lst         TYPE j_1ilstno,
        v_exc         TYPE j_1iexrn,
        v_cdd         TYPE vbak-vdatu,
        v_cdd1        TYPE text10,
        dt            TYPE text10,
        v_salesorder  TYPE thead-tdname,     "PASSING DATA FROM SCRIPT
        v_salesorder1 TYPE vbak-vbeln,
        v_knumv       TYPE vbak-knumv,     "VARIABLE TO PASS NEW VALUE
        sum_kwert     TYPE kwert,
        sum_pf        TYPE kwert,
        sum_sales     TYPE kwert,
        sum_pf1       TYPE char18,
        sum_sales1    TYPE char18,
        v_item        TYPE prcd_elements-kposn,
        v_price       TYPE prcd_elements-kbetr,
        v_value       TYPE prcd_elements-kwert.
*        F_VALUE       TYPE N.          " FINAL VALUES



  .
  DATA: it_konv TYPE STANDARD TABLE OF ty_konv,
        wa_konv TYPE ty_konv.

****READING SALES ORDER NO FROM IN_TAB
  READ TABLE in_tab INDEX 1 .
  v_salesorder = in_tab-value.
****READING ITEM NO FROM IN_TAB
  READ TABLE in_tab INDEX 2 .
  v_item = in_tab-value.


***CONVERSION FOR SALES ORDER ITEM NUMBERS.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_item
    IMPORTING
      output = v_item.

***CONVERSION FOR KNUMV NUMBERS.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_knumv
    IMPORTING
      output = v_knumv.



*****SELECTING REQUIRED DELIVERY DATE FORM VBAK.
  SELECT vbeln
         vdatu
         knumv
    FROM vbak
    INTO (v_salesorder1,
          v_cdd,
          v_knumv)
    WHERE vbeln = v_salesorder.
  ENDSELECT.
******SELECTING DATA FROM KONV.
  SELECT knumv
         kposn
         stunr
         zaehk
         kschl
         kwert
         kbetr
   from PRCD_ELEMENTS "FROM konv
    INTO CORRESPONDING FIELDS OF TABLE it_konv
    WHERE knumv = v_knumv AND ( kschl = 'ZPFO' OR kschl = 'ZPR0').
*      AND KPOSN = V_ITEM.

  LOOP AT it_konv INTO wa_konv.
    sum_kwert = sum_kwert + wa_konv-kwert.

    IF wa_konv-kschl = 'ZPFO'.
      IF sum_pf IS INITIAL.
        sum_pf = wa_konv-kbetr / 10.
      ENDIF.
*      SUM_PF = SUM_PF + WA_KONV-KWERT.
    ELSE.  " WA_KONV-KSCHL = 'ZPR0'
      sum_sales = sum_sales + wa_konv-kwert.
    ENDIF.
    v_price = wa_konv-kbetr.
    v_value = wa_konv-kwert.
  ENDLOOP.


  sum_pf1 = sum_pf.
  sum_sales1 = sum_sales.

  CONDENSE : sum_pf1 , sum_sales1 .
****PASSING EXCISE DETAILS TO OUT_TAB------------------------*

  READ TABLE out_tab INDEX 1 . "PACKING & FORWARDING.
  out_tab-value = sum_pf1.
  MODIFY out_tab INDEX 1.

  READ TABLE out_tab INDEX 2 . "SALES TOTAL.
  out_tab-value = sum_sales1.
  MODIFY out_tab INDEX 2.




ENDFORM.                                                    "GET_VALUE1

*&---------------------------------------------------------------------*
*&      Form  GET_INS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_ins TABLES in_tab STRUCTURE itcsy
              out_tab STRUCTURE itcsy  .
  DATA: v_salesorder_script TYPE vbak-vbeln,
        v_salesorder        TYPE thead-tdname, "VBELN,
        v_so_conv           TYPE char20,
        v_so_item           TYPE thead-tdname, "POSNR
        it_line_header      TYPE STANDARD TABLE OF tline,
        wa_line_header      TYPE tline,
        v_insurance_temp    TYPE char50,
        v_insurance         TYPE char50,
        v_mod               TYPE char50,
        v_mod_temp          TYPE char50,
        v_doc               TYPE char50,
        v_doc_temp          TYPE char50,
        v_spcl              TYPE char50,
        v_spcl_temp         TYPE char50.


****READING CUSTOMER NAME FROM IN_TAB
*  READ TABLE IN_TAB INDEX 1 .
*  V_CUSTNAME = IN_TAB-VALUE.

****READING SALES ORDER NO FROM IN_TAB
  READ TABLE in_tab INDEX 1 .
  v_salesorder_script = in_tab-value.


* V_SALESORDER_SCRIPT = V_SALESORDER.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_salesorder_script
    IMPORTING
      output = v_salesorder_script.

  v_salesorder = v_salesorder_script.

  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
     WHERE mandt    = sy-mandt
       AND tdobject = 'VBBK'
       AND tdname   =  v_salesorder
       AND tdid     = 'Z017'
       AND tdspras  = 'E'.
  IF sy-subrc = 0.
*READING INSURANCE-HEADER TEXT FROM SALESORDER  (V_SALESORDER).
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'Z017'
        language = 'E'
        name     = v_salesorder
        object   = 'VBBK'
      TABLES
        lines    = it_line_header.
    .
*    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.

    CLEAR  v_insurance_temp .
    LOOP AT it_line_header INTO wa_line_header.
      v_insurance = wa_line_header-tdline.
    ENDLOOP.

    v_insurance_temp = v_insurance.

    READ TABLE out_tab INDEX 1 .
    out_tab-value = v_insurance_temp. "WA_LINE_HEADER.
    MODIFY out_tab INDEX 1.
  ENDIF.
*==========================================
  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
     WHERE mandt    = sy-mandt
       AND tdobject = 'VBBK'
       AND tdname   =  v_salesorder
       AND tdid     = 'Z018'
       AND tdspras  = 'E'.
  IF sy-subrc = 0.
*READING MODE OF DESPATCH- HEADER TEXT FROM SALESORDER  (V_SALESORDER).
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'Z018'
        language = 'E'
        name     = v_salesorder
        object   = 'VBBK'
      TABLES
        lines    = it_line_header.
    .
*    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.

    CLEAR  v_spcl_temp.
    LOOP AT it_line_header INTO wa_line_header.
      v_mod_temp = wa_line_header-tdline.
    ENDLOOP.

*  V_MOD_TEMP = V_MOD.

    READ TABLE out_tab INDEX 2 .
    out_tab-value = v_mod_temp. "WA_LINE_HEADER.
    MODIFY out_tab INDEX 2.
  ENDIF.
*==========================================
  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
     WHERE mandt    = sy-mandt
       AND tdobject = 'VBBK'
       AND tdname   =  v_salesorder
       AND tdid     = 'Z019'
       AND tdspras  = 'E'.
  IF sy-subrc = 0.
*READING DOCUMENTS THROUGH- HEADER TEXT FROM SALESORDER  (V_SALESORDER).
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'Z019'
        language = 'E'
        name     = v_salesorder
        object   = 'VBBK'
      TABLES
        lines    = it_line_header.
    .
*    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.

    CLEAR  v_doc_temp.
    LOOP AT it_line_header INTO wa_line_header.
      v_doc_temp = wa_line_header-tdline.
    ENDLOOP.

*  V_DOC_TEMP = V_DOC.

    READ TABLE out_tab INDEX 3 .
    out_tab-value = v_doc_temp. "WA_LINE_HEADER.
    MODIFY out_tab INDEX 3.
  ENDIF.
*==========================================
  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
     WHERE mandt    = sy-mandt
       AND tdobject = 'VBBK'
       AND tdname   =  v_salesorder
       AND tdid     = 'Z020'
       AND tdspras  = 'E'.
  IF sy-subrc = 0.
*READING SPECIAL INSTRUCTIONS- HEADER TEXT FROM SALESORDER  (V_SALESORDER).
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'Z020'
        language = 'E'
        name     = v_salesorder
        object   = 'VBBK'
      TABLES
        lines    = it_line_header.
    .
*    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.

    CLEAR  v_spcl_temp.
    LOOP AT it_line_header INTO wa_line_header.
      v_spcl_temp = wa_line_header-tdline.
    ENDLOOP.

*  V_SPCL_TEMP = V_SPCL.

    READ TABLE out_tab INDEX 4 .
    out_tab-value = v_spcl_temp. "WA_LINE_HEADER.
    MODIFY out_tab INDEX 4.
  ENDIF.
ENDFORM.                    " GET_INS


FORM get_ofmemo TABLES in_tab STRUCTURE itcsy
              out_tab STRUCTURE itcsy  .
  DATA: v_salesorder   TYPE vbak-vbeln,
        v_so           TYPE thead-tdname,
        v_ofmemo       TYPE char50,
        it_line_header TYPE STANDARD TABLE OF tline,
        wa_line_header TYPE tline. "POSNR

  READ TABLE in_tab INDEX 1 .
  v_salesorder = in_tab-value.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_salesorder
    IMPORTING
      output = v_salesorder.

  v_so = v_salesorder.
  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
     WHERE mandt    = sy-mandt
       AND tdobject = 'VBBK'
       AND tdname   =  v_so
       AND tdid     = 'Z015'
       AND tdspras  = 'E'.
  IF sy-subrc = 0.
*READING DOCUMENTS THROUGH- HEADER TEXT FROM SALESORDER  (V_SALESORDER).
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'Z015'
        language = 'E'
        name     = v_so
        object   = 'VBBK'
      TABLES
        lines    = it_line_header.
  ENDIF.

  CLEAR  v_ofmemo.
  LOOP AT it_line_header INTO wa_line_header.
    v_ofmemo = wa_line_header-tdline.
  ENDLOOP.
  READ TABLE out_tab INDEX 1.
  out_tab-value = v_ofmemo. "WA_LINE_HEADER.
  MODIFY out_tab INDEX 1.

ENDFORM.    .
