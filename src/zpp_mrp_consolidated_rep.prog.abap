*&---------------------------------------------------------------------*
*& REPORT  ZPP_MRP_CONSOLIDATED_REP
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*                          PROGRAM DETAILS                             *
*----------------------------------------------------------------------*
* PROGRAM NAME         : ZPP_MRP_CONSOLIDATED_REP.                     *
* TITLE                :                                               *
* CREATED BY           : SANSARI                                       *
* STARTED ON           : 03 MARCH 2011                                 *
* TRANSACTION CODE     : ZPPMRP                                        *
* DESCRIPTION          :                                               *
*----------------------------------------------------------------------*

REPORT  ZPP_MRP_CONSOLIDATED_REP.
************************************************************************
*                                  TABLES                              *
************************************************************************
*TABLES:
*MARA, MARC, MAKT.
************************************************************************
*                             TYPE -POOLS                              *
************************************************************************
TYPE-POOLS : SLIS.
************************************************************************
*                             TYPE DECLARATIONS                        *
************************************************************************
TYPES: BEGIN OF TT_DATA,                                    "FINAL TABLE STRUCTURE
         MATNR   TYPE MARA-MATNR,          "MATERIAL NUMBER
         MAKTX   TYPE MAKT-MAKTX,          "MATERIAL DESCRIPTION
         WERKS   TYPE MARC-WERKS,          "PLANT
         BRAND   TYPE MARA-BRAND,
         EKGRP   TYPE MARC-EKGRP,          "Purchasing Group       "add
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
         MEINS   TYPE MARA-MEINS,
         DISPO   TYPE MARC-DISPO,
         SBDKZ   TYPE MARC-SBDKZ,
         EISBE   TYPE MARC-EISBE,
         BESKZ   TYPE MARC-BESKZ,
         VPRSV   TYPE MBEW-VPRSV,
         STPRS   TYPE MBEW-STPRS,
         VERPR   TYPE MBEW-VERPR,
         MTART   TYPE MARA-MTART,
         BISMT   TYPE MARA-BISMT,

       END OF TT_DATA,

       BEGIN OF TT_FINAL,
         MATNR            TYPE MARA-MATNR,
         MAKTX            TYPE MAKT-MAKTX,
         WERKS            TYPE MARC-WERKS,
         BRAND            TYPE MARA-BRAND,
         SERIES           TYPE MARA-ZSERIES,
         SIZE             TYPE MARA-ZSIZE,
         MOC              TYPE MARA-MOC,
         TYPE             TYPE MARA-TYPE,
         MTART            TYPE MARA-MTART,
         BISMT            TYPE MARA-BISMT,
         MRPCNT           TYPE MARC-DISPO,
         TOT_REQ          TYPE MNG01,
         IN_HAND_STOCK    TYPE MNG01,
         PLANNED_ORDERS   TYPE MNG01,   "PA
         PURCHASE_REQ     TYPE MNG01,   "BA
         SHORTAGES        TYPE MNG01,
         PROD_ORDERS      TYPE MNG01,
         PURCH_ORDERS     TYPE CHAR25, " MNG01,  """ NC
*=======CHANGES AS ON 10/05/2018==================================
         UNRESTRICTED_STK TYPE MNG01,           " STOCK
         VENDOR_STK       TYPE MNG01,           " STOCK
         BLOCKED_STK      TYPE MNG01,              " Blocked stk
         WIP_STK          TYPE MNG01,               "
         QUALITY_STK      TYPE MNG01,               "
         EISBE            TYPE MARC-EISBE,      " SAFETY STOCK
         BESKZ            TYPE MARC-BESKZ,      " PROCUREMENT TYPE
         VERPR            TYPE MBEW-VERPR,      " MOVING AVERAGE PRICE
         MEINS            TYPE MARA-MEINS,      " BASE UNIT OF MEASURE
         SUB_BALN         TYPE MNG01,           " SUBCONTRACTOR BALANCE
*         pr_val           TYPE mbew-verpr,      " MOVING AVERAGE PRICE
         PR_VAL           TYPE STRING,      " MOVING AVERAGE PRICE
         C_VALUE          TYPE MNG01,           " Consumption Value
         EXCESS_STK       TYPE MNG01,           " Excess Stock
         EXCESS_ORD       TYPE MNG01,           " Excess Order
         NET_INDENT       TYPE MNG01,           " Net Indent
*         ref_date         TYPE sy-datum,            " Added By Abhishek Pisolkar (12.03.2018)
         EKGRP            TYPE MARC-EKGRP,  "add
*=====================================================================
       END OF TT_FINAL,
*---------------------Added By Abhishek Pisolkar (13.03.2018)-------------------
       BEGIN OF TY_FINAL,
         MATNR            TYPE MARA-MATNR,
         MAKTX            TYPE MAKT-MAKTX,
         WERKS            TYPE MARC-WERKS,
         BRAND            TYPE MARA-BRAND,
         SERIES           TYPE MARA-ZSERIES,
         SIZE             TYPE MARA-ZSIZE,
         MOC              TYPE MARA-MOC,
         TYPE             TYPE MARA-TYPE,
         MTART            TYPE MARA-MTART,
         BISMT            TYPE MARA-BISMT,
         MRPCNT           TYPE MARC-DISPO,
         TOT_REQ          TYPE STRING,
         IN_HAND_STOCK    TYPE STRING,
         PLANNED_ORDERS   TYPE STRING,   "PA
         PURCHASE_REQ     TYPE STRING,   "BA
         SHORTAGES        TYPE STRING,
         PROD_ORDERS      TYPE STRING,
         PURCH_ORDERS     TYPE STRING,
*=======CHANGES AS ON 10/05/2018==================================
         UNRESTRICTED_STK TYPE STRING,           " STOCK
         VENDOR_STK       TYPE STRING,           " STOCK
         BLOCKED_STK      TYPE STRING,              " Blocked stk
         WIP_STK          TYPE STRING,               "
         QUALITY_STK      TYPE STRING,               "
         EISBE            TYPE MARC-EISBE,      " SAFETY STOCK
         BESKZ            TYPE MARC-BESKZ,      " PROCUREMENT TYPE
         VERPR            TYPE STRING,          "mbew-verpr,      " MOVING AVERAGE PRICE
         MEINS            TYPE MARA-MEINS,      " BASE UNIT OF MEASURE
         SUB_BALN         TYPE STRING,           " SUBCONTRACTOR BALANCE
         PR_VAL           TYPE STRING,          "mbew-verpr,      " MOVING AVERAGE PRICE
         C_VALUE          TYPE STRING,           " Consumption Value
         EXCESS_STK       TYPE STRING,           " Excess Stock
         EXCESS_ORD       TYPE STRING,           " Excess Order
         NET_INDENT       TYPE STRING,           " Net Indent
         REF_DATE         TYPE STRING,           "sy-datum,        " Refreshable Date
         EKGRP            TYPE MARC-EKGRP,  "add
*=====================================================================
       END OF TY_FINAL.
*--------------------------------------------------------------------*
TYPES: BEGIN OF TT_MARA,
         MATNR  TYPE MARA-MATNR,
         BRAND  TYPE MARA-BRAND,
         SERIES TYPE MARA-ZSERIES,
         SIZE   TYPE MARA-ZSIZE,
         MOC    TYPE MARA-MOC,
         TYPE   TYPE MARA-TYPE,
         MTART  TYPE MARA-MTART,
         BISMT  TYPE MARA-BISMT,
       END OF TT_MARA,

       BEGIN OF TT_MARC,
         MATNR  TYPE MATNR,         "MATERIAL NUMBER
         WERKS  TYPE MARC-WERKS,    "PLANT
         EKGRP  TYPE MARC-EKGRP,    "Purchasing Group    "add
         MRPCNT TYPE MARC-DISPO,    "MRP CONTROLLER (MATERIALS PLANNER)
       END OF TT_MARC,

       BEGIN OF TT_MARD,
         MATNR TYPE MATNR,
         WERKS TYPE WERKS_D,
         LGORT TYPE LGORT_D,
         LABST TYPE LABST,
         INSME TYPE INSME,
         SPEME TYPE SPEME,
       END OF TT_MARD,

       BEGIN OF TT_MSKA,
         MATNR TYPE MATNR,
         WERKS TYPE WERKS_D,
         LGORT TYPE LGORT_D,
         KALAB TYPE LABST,
         KAINS TYPE INSME,
         KASPE TYPE SPEME,
       END OF TT_MSKA,


       BEGIN OF TT_MAKT ,
         MATNR TYPE MARA-MATNR,
         MAKTX TYPE MAKT-MAKTX,
         SPRAS TYPE MAKT-SPRAS,
       END OF TT_MAKT,

       BEGIN OF TT_MAT,
         IDNRK TYPE STPOX-IDNRK,       "MATERIAL NUMBER
         MAKTX TYPE MAKT-MAKTX,        "MATERIAL DESCRIPTION
       END OF TT_MAT,

       BEGIN OF TT_RESB,               "Reservation/dependent requirements table type
         MATNR  TYPE MARA-MATNR,
         BDMNG  TYPE RESB-BDMNG,      "Requirement Quantity
         ENMNG  TYPE RESB-ENMNG,      "Quantity Withdrawn
         AUFNR  TYPE RESB-AUFNR,      "Order Number
         WIPQTY TYPE RESB-BDMNG,
         XLOEK  TYPE RESB-XLOEK,      "Item is Deleted
         SHKZG  TYPE RESB-SHKZG,      "Debit/Credit Indicator
       END OF TT_RESB,

       BEGIN OF TT_AFPO,
         AUFNR TYPE AFPO-AUFNR,
         PSMNG TYPE AFPO-PSMNG,
         WEMNG TYPE AFPO-WEMNG,
       END OF TT_AFPO.

************************************************************************
*                             DATA DECLARATIONS                        *
************************************************************************

DATA: IT_DATA     TYPE STANDARD TABLE OF TT_DATA,
      WA_DATA     TYPE TT_DATA,

      IT_MARA     TYPE STANDARD TABLE OF TT_MARA,
      WA_MARA     TYPE TT_MARA,

      IT_MARC     TYPE STANDARD TABLE OF TT_MARC,
      WA_MARC     TYPE TT_MARC,

      IT_MAKT     TYPE  STANDARD TABLE OF TT_MAKT,
      WA_MAKT     TYPE TT_MAKT,

      IT_MAT      TYPE STANDARD TABLE OF TT_MAT,
      WA_MAT      TYPE TT_MAT,

      IT_MDPS     TYPE STANDARD TABLE OF MDPS,
      WA_MDPS     TYPE MDPS,

      IT_MDEZ     TYPE STANDARD TABLE OF MDEZ,
      WA_MDEZ     TYPE MDEZ,

      IT_MDSU     TYPE STANDARD TABLE OF MDSU,
      WA_MDSU     TYPE MDSU,

      IT_FINAL    TYPE STANDARD TABLE OF TT_FINAL,
      WA_FINAL    TYPE TT_FINAL,

*----------Added By Abhishek Pisolkar (13.03.2018)------------
      GT_FINAL    TYPE STANDARD TABLE OF TY_FINAL,
      GS_FINAL    TYPE TY_FINAL,
*--------------------------------------------------------------------*

      IT_DISP     TYPE STANDARD TABLE OF TT_FINAL,
      WA_DISP     TYPE TT_FINAL,

      IT_RESB     TYPE STANDARD TABLE OF TT_RESB,
      WA_RESB     TYPE TT_RESB,

      IT_AFPO     TYPE STANDARD TABLE OF TT_AFPO,
      WA_AFPO     TYPE TT_AFPO,

      IT_MARD     TYPE STANDARD TABLE OF TT_MARD,
      WA_MARD     TYPE TT_MARD,

      IT_MSKA     TYPE STANDARD TABLE OF TT_MSKA,
      WA_MSKA     TYPE TT_MSKA,
      WA_EKKO     TYPE EKKO,
      WA_EKPO     TYPE EKPO,
      PO_QUANTITY TYPE BSTMG,  " UNRELEASED PO QTY FOR A MATERIAL
      I_REPID     TYPE SY-REPID.

DATA: TOT_REQ          TYPE MNG01,
      IN_HAND_STOCK    TYPE MNG01,
      PLANNED_ORDERS   TYPE MNG01,
      PURCHASE_REQ     TYPE MNG01,
      SHORTAGES1       TYPE MNG01,
      SHORTAGES        TYPE MNG01,
      REQMT            TYPE MNG01,
      PROD_ORDERS      TYPE MNG01,
      PURCH_ORDERS     TYPE MNG01,
      VEN_STOCK        TYPE MNG01,
      UNRESTRICTED_STK TYPE MNG01,
      VENDOR_STK       TYPE MNG01,
      QUALITY_STK      TYPE MNG01,
      SUB_BALN         TYPE MNG01,
*      pr_val           TYPE verpr,
      PR_VAL           TYPE STRING,
      BLOCKED_STK      TYPE MNG01,
      LV_STK           TYPE MNG01,
      PO_NUMBER        TYPE EKKO-EBELN,
      PO_ITEM          TYPE EKPO-EBELP.
*                  c_value          type verpr,


DATA: FIELDCATALOG TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
      FIELDLAYOUT  TYPE SLIS_LAYOUT_ALV,

      IT_FCAT      TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT      TYPE LINE OF SLIS_T_FIELDCAT_ALV.. " SLIS_T_FIELDCAT_ALV.

* ALV RELATED DATA
*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES AND CONSTANTS FOR ALV
*---------------------------------------------------------------------*
DATA:
  I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
  GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
  I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
  WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV..            " LAYOUT WORKAREA

DATA: LV_PURCH_ORDERS TYPE MNG01 .  """""""""""""" NC
************************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  C_FORMNAME_TOP_OF_PAGE   TYPE SLIS_FORMNAME
                                   VALUE 'TOP_OF_PAGE',
  C_FORMNAME_PF_STATUS_SET TYPE SLIS_FORMNAME
                                 VALUE 'PF_STATUS_SET',
  C_Z_ALV_DEMO             LIKE TRDIR-NAME   VALUE 'Z_ALV_DEMO',
  C_VBAK                   TYPE SLIS_TABNAME VALUE 'I_VBAK',
  C_S                      TYPE C VALUE 'S',
  C_H                      TYPE C VALUE 'H'.
************************************************************************
************************************************************************
*                               SELECTION-SCREEN                       *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS       :  PA_WERKS TYPE MARC-WERKS DEFAULT 'PL01' OBLIGATORY. " MEMORY ID MAT," ADDED BY MD

  SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002..
    SELECT-OPTIONS   :  S_MRPCNT FOR WA_MARC-MRPCNT, "OBLIGATORY  , "MEMORY ID WRK.
                        S_SERIES FOR WA_MARA-SERIES,
                        S_SIZE FOR WA_MARA-SIZE.
  SELECTION-SCREEN END OF BLOCK B2.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-077.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-078.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-079.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-NAME = 'PA_WERKS'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP. " ADDED BY MD

*>>
START-OF-SELECTION.
*BREAK primus.
  SELECT  A~MATNR A~BRAND A~ZSERIES A~ZSIZE A~MOC A~TYPE A~MEINS A~MTART A~BISMT
          B~MAKTX
          C~DISPO C~WERKS C~EKGRP C~SBDKZ C~EISBE C~BESKZ
          D~VERPR D~VPRSV D~STPRS
   INTO CORRESPONDING FIELDS OF WA_DATA
   FROM  MARA AS A
   JOIN  MAKT AS B ON ( B~MATNR = A~MATNR )
   JOIN  MARC AS C ON ( C~MATNR = B~MATNR AND C~WERKS = PA_WERKS  )
   JOIN  MBEW AS D ON ( D~MATNR = B~MATNR AND D~BWKEY = PA_WERKS )"AND C~MATNR = A~MATNR )
   WHERE C~WERKS = PA_WERKS
    AND  C~DISPO IN S_MRPCNT
    AND  A~ZSERIES  IN S_SERIES
    AND  A~ZSIZE IN S_SIZE.

*DATA APPENDED TO INTERNAL TABLE.
    APPEND WA_DATA TO IT_DATA.
  ENDSELECT.
*----DATA FETCHING FOR WIP_STK.
  IF NOT IT_DATA IS INITIAL.
    SELECT MATNR
              BDMNG
              ENMNG
              AUFNR
         FROM RESB
         INTO TABLE IT_RESB
         FOR ALL ENTRIES IN IT_DATA
         WHERE MATNR = IT_DATA-MATNR
           AND WERKS = PA_WERKS
           AND XLOEK <> 'X'
           AND ENMNG > 0
           AND SHKZG = 'H'.

    SELECT AUFNR
           PSMNG
           WEMNG
           "MATNR
      FROM AFPO
      INTO TABLE IT_AFPO
      FOR ALL ENTRIES IN IT_RESB
      WHERE AUFNR = IT_RESB-AUFNR
        AND ELIKZ <> 'X'.

  ENDIF.
*----Data fetching for MARD -------------*

  SELECT MATNR
         WERKS
         LGORT
         LABST
         INSME
         SPEME
    FROM MARD
    INTO CORRESPONDING FIELDS OF TABLE IT_MARD
    FOR ALL ENTRIES IN IT_DATA
    WHERE MATNR = IT_DATA-MATNR
    AND WERKS = PA_WERKS
    AND LGORT <> 'RJ01' AND LGORT <> 'SCR1'
    AND LGORT NE 'SRN1'. " AVINASH BHAGAT 20.12.2018


  SELECT MATNR
        WERKS
        LGORT
        KALAB
        KAINS
        KASPE
   FROM MSKA
   INTO CORRESPONDING FIELDS OF TABLE IT_MSKA
   FOR ALL ENTRIES IN IT_DATA
   WHERE MATNR = IT_DATA-MATNR
   AND WERKS = PA_WERKS
   AND LGORT <> 'RJ01' AND LGORT <> 'SCR1' AND LGORT <> 'SRN1'.

*PASSING MATERIAL NUMBER (WA_DATA-MATNR) TO FM.
  LOOP AT IT_DATA INTO WA_DATA.
*CALL FM TO CHECK STOCK REQUIREMENT STATUS.
    CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
      EXPORTING
        MATNR                    = WA_DATA-MATNR
        WERKS                    = PA_WERKS
      TABLES
        MDPSX                    = IT_MDPS
        MDEZX                    = IT_MDEZ
        MDSUX                    = IT_MDSU
      EXCEPTIONS
        MATERIAL_PLANT_NOT_FOUND = 1
        PLANT_NOT_FOUND          = 2
        OTHERS                   = 3.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
* DATA PASSED TO INTERNAL TABLE IT_MDPS FROM FM.
* CALCULATION TO BE DONE ON FIELD MRP ELEMENT (DELKZ) BASES ON THE CRITERIA.

*Stock Calculation--------------------*
    LOOP AT IT_MARD INTO WA_MARD WHERE MATNR = WA_DATA-MATNR.
      UNRESTRICTED_STK = UNRESTRICTED_STK + WA_MARD-LABST.
      BLOCKED_STK      = BLOCKED_STK + WA_MARD-SPEME.
      QUALITY_STK      = QUALITY_STK + WA_MARD-INSME.
    ENDLOOP.

    LOOP AT IT_MSKA INTO WA_MSKA WHERE MATNR = WA_DATA-MATNR.
      UNRESTRICTED_STK = UNRESTRICTED_STK + WA_MSKA-KALAB.
      BLOCKED_STK      = BLOCKED_STK + WA_MSKA-KASPE.
      QUALITY_STK      = QUALITY_STK + WA_MSKA-KAINS.
    ENDLOOP.
*-------------------------------------*

*logic for unreleased po
    CLEAR: PO_NUMBER, PO_QUANTITY.

    LOOP AT IT_MDEZ INTO WA_MDEZ.
      IF WA_MDEZ-DELKZ = 'BE'.
        IF WA_MDEZ-EXTRA(10) IS NOT INITIAL.
          PO_NUMBER = WA_MDEZ-EXTRA(10) .
          CLEAR WA_EKKO.
          SELECT SINGLE * FROM EKKO INTO WA_EKKO WHERE EBELN = PO_NUMBER.
          IF SY-SUBRC = 0.
            IF WA_EKKO-FRGKE = 'X'.
              PO_ITEM = WA_MDEZ-EXTRA+11(5).
              CLEAR: WA_EKPO.
              SELECT SINGLE * FROM EKPO INTO WA_EKPO WHERE EBELN = PO_NUMBER
                                                       AND EBELP =  PO_ITEM.
              IF SY-SUBRC = 0.
                PO_QUANTITY =  PO_QUANTITY + WA_EKPO-MENGE.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LOOP AT IT_MDPS INTO WA_MDPS.
*TOTAL REQUIREMENT:- ( OPEN REQUIREMENT)
*SUM ALL REQUIREMENT QUANTITIES AGAINST MRP ELEMENT VC OR SB.

      IF  WA_MDPS-DELKZ = 'VC'
        OR WA_MDPS-DELKZ = 'SB'
        OR ( WA_MDPS-DELKZ = 'BB' AND WA_MDPS-PLAAB <> 26 )
        OR WA_MDPS-DELKZ = 'U1'
        OR WA_MDPS-DELKZ = 'U2'
        OR ( WA_MDPS-DELKZ = 'AR' AND WA_MDPS-PLUMI <> '+' ).

        TOT_REQ          =  TOT_REQ   + WA_MDPS-MNG01.
      ENDIF.
*	IN-HAND STOCK: - ( STOCK SITUATIONS)
* SUM ALL TYPES OF STOCK QUANTITIES
* SALES ORDER STOCK – MRP ELEMENT KB
* QUALITY STOCK – MRP ELEMENT QM
* UNRESTRICTED STOCK –MRP ELEMENT WB
**      IF     (  ( WA_MDPS-DELKZ = 'KB'
**
**              OR ( WA_MDPS-DELKZ = 'WB' AND WA_DATA-SBDKZ <> 1 ) )
**
**               AND WA_MDPS-AUSSL <> 'U6') .
**        UNRESTRICTED_STK  = UNRESTRICTED_STK + WA_MDPS-MNG01.
**      ENDIF.
**
**       IF         WA_MDPS-DELKZ = 'LK'
**               AND WA_MDPS-AUSSL <> 'U6' .
**        VENDOR_STK  = VENDOR_STK + WA_MDPS-MNG01.
**      ENDIF.
**
**      IF         WA_MDPS-DELKZ = 'QM'
**                 AND WA_MDPS-AUSSL <> 'U6' .
**        QUALITY_STK  = QUALITY_STK + WA_MDPS-MNG01.
**      ENDIF.
*PROD. PROPOSALS: -
*SUM ALL QUANTITIES AGAINST MRP ELEMENTS PA AND FE.
      IF    WA_MDPS-DELKZ = 'PA' . "WA_MDPS-DELKZ = 'FE' ).
        PLANNED_ORDERS  = PLANNED_ORDERS + WA_MDPS-MNG01.
      ENDIF.

*      IF    WA_MDPS-DELKZ = 'KB' AND WA_MDPS-DELKZ = 'WB' ).
*        PLANNED_ORDERS  = PLANNED_ORDERS + WA_MDPS-MNG01.
*      ENDIF.

      IF    WA_MDPS-DELKZ = 'FE' . "WA_MDPS-DELKZ = 'FE' ).
        PROD_ORDERS  = PROD_ORDERS + WA_MDPS-MNG01.
      ENDIF.
* Uncommented as per new logic for Purchase requisition.
      IF    WA_MDPS-DELKZ = 'BA'. "OR WA_MDPS-DELKZ = 'BE' ).
        PURCHASE_REQ  = PURCHASE_REQ + WA_MDPS-MNG01.
      ENDIF.

      IF    WA_MDPS-DELKZ = 'BE'. "OR WA_MDPS-DELKZ = 'BE' ).
        PURCH_ORDERS  = PURCH_ORDERS + WA_MDPS-MNG01.
      ENDIF.

    ENDLOOP.

*    REQMT = ( IN_HAND_STOCK + PLANNED_ORDERS + PROD_ORDERS + PURCHASE_REQ + PURCH_ORDERS ).   "PROD_PROPOSALS + PROCUREMENT


***======SUBCONTRACTING BALANCE.
**    SUB_BALN = PURCH_ORDERS - VENDOR_STK.
***=========SB END
***======PR Valuation.
**    PR_VAL = PURCHASE_REQ * WA_DATA-VERPR.
***=========SB END
*===========lOGIC FOR WIP CALCULATION

    LOOP AT IT_RESB INTO WA_RESB WHERE MATNR = WA_DATA-MATNR.
      READ TABLE IT_AFPO INTO WA_AFPO WITH KEY AUFNR = WA_RESB-AUFNR.
      IF SY-SUBRC = 0.
        WA_RESB-WIPQTY = WA_RESB-ENMNG - ( WA_AFPO-WEMNG * ( WA_RESB-BDMNG / WA_AFPO-PSMNG ) ).
        IF WA_RESB-WIPQTY > 0.
          WA_FINAL-WIP_STK = WA_FINAL-WIP_STK + WA_RESB-WIPQTY.
        ENDIF.

      ENDIF.
      CLEAR : WA_RESB, WA_AFPO.
    ENDLOOP.

******************* shortages calculation ********************************
*    REQMT = ( UNRESTRICTED_STK + blocked_stk + QUALITY_STK + WA_FINAL-WIP_STK ).
*    reqmt = ( unrestricted_stk + blocked_stk + quality_stk ).
    REQMT = ( UNRESTRICTED_STK + QUALITY_STK ).                 "ADD
    SHORTAGES1 =  TOT_REQ  - REQMT.
*==========================================
    " DISPLAY ONLY IF GREATER THAN ZERO.
    IF SHORTAGES1 GT 0.
      SHORTAGES = SHORTAGES1.
    ENDIF.
*------------------------------------------------
* Commented as per new logic for Purchase requisition
    " Purchase requisition calculations
*    PURCHASE_REQ = SHORTAGES + PURCH_ORDERS.
*------------------------------------------------
    " THIS IS THE CALCULATION FOR WA_MDPS-DELKZ = 'LK' FROM MSLB TABLE.
*        SELECT SUM( LBLAB )
*          INTO VEN_STOCK
*          FROM MSLB
*          WHERE MATNR = WA_DATA-MATNR AND WERKS = PA_WERKS.

*          IF VEN_STOCK IS NOT INITIAL.
*            IN_HAND_STOCK  = IN_HAND_STOCK + VEN_STOCK.
*            CLEAR VEN_STOCK.
*          ENDIF.

    WA_FINAL-MATNR  = WA_DATA-MATNR.
    WA_FINAL-MAKTX  = WA_DATA-MAKTX.
    WA_FINAL-WERKS  = WA_DATA-WERKS.
    WA_FINAL-BRAND  = WA_DATA-BRAND.
    WA_FINAL-SERIES = WA_DATA-ZSERIES.
    WA_FINAL-SIZE   = WA_DATA-ZSIZE.
    WA_FINAL-MOC    = WA_DATA-MOC.
    WA_FINAL-TYPE   = WA_DATA-TYPE.
    WA_FINAL-MTART   = WA_DATA-MTART.
    WA_FINAL-BISMT   = WA_DATA-BISMT.
    WA_FINAL-MEINS   = WA_DATA-MEINS.
    WA_FINAL-MRPCNT = WA_DATA-DISPO.
    WA_FINAL-TOT_REQ = TOT_REQ.
    WA_FINAL-UNRESTRICTED_STK  = UNRESTRICTED_STK.
    WA_FINAL-VENDOR_STK = VENDOR_STK.
    WA_FINAL-BLOCKED_STK = BLOCKED_STK.
    WA_FINAL-QUALITY_STK = QUALITY_STK.
    WA_FINAL-PLANNED_ORDERS = PLANNED_ORDERS.
    WA_FINAL-PURCHASE_REQ   = PURCHASE_REQ.
    WA_FINAL-PROD_ORDERS    = PROD_ORDERS.

    CLEAR : LV_PURCH_ORDERS .
    IF PO_QUANTITY IS NOT INITIAL.
      LV_PURCH_ORDERS    = PURCH_ORDERS - PO_QUANTITY.  """" ++ NC
      WA_FINAL-PURCH_ORDERS =   LV_PURCH_ORDERS .
*      WA_FINAL-PURCH_ORDERS   = PURCH_ORDERS - PO_QUANTITY.   """ -- NC
    ELSEIF PO_QUANTITY IS INITIAL.
      LV_PURCH_ORDERS    =    PURCH_ORDERS.
      WA_FINAL-PURCH_ORDERS =   LV_PURCH_ORDERS .
    ENDIF.

    IF LV_PURCH_ORDERS < 0 .    """""""""" NC
      CONDENSE WA_FINAL-PURCH_ORDERS NO-GAPS  .
      REPLACE ALL OCCURRENCES OF '-' IN WA_FINAL-PURCH_ORDERS WITH SPACE .
      CONCATENATE '-' WA_FINAL-PURCH_ORDERS  INTO WA_FINAL-PURCH_ORDERS  .
    ENDIF.
    CONDENSE WA_FINAL-PURCH_ORDERS NO-GAPS  .

    WA_FINAL-SHORTAGES = SHORTAGES.
*net Indent
    CLEAR WA_FINAL-NET_INDENT.
    WA_FINAL-EKGRP  = WA_DATA-EKGRP.   "add

*      porder = wa_final-prod_orders + wa_final-purch_orders .
*    wa_final-net_indent = wa_final-shortages -  wa_final-purch_orders .
*    wa_final-net_indent = wa_final-shortages - ( wa_final-prod_orders + wa_final-purch_orders ).               "ADD
**
**    IF wa_final-net_indent < 0.
**      wa_final-net_indent = 0.
**    ENDIF.


    WA_FINAL-EISBE = WA_DATA-EISBE.    " Safety stock
    WA_FINAL-BESKZ =  WA_DATA-BESKZ.

    IF WA_DATA-VPRSV = 'V'.
      WA_FINAL-VERPR =  WA_DATA-VERPR.
    ELSE.
      WA_FINAL-VERPR =  WA_DATA-STPRS.
    ENDIF.

    WA_FINAL-SUB_BALN = SUB_BALN.

***======PR Valuation.================
    PR_VAL = PURCHASE_REQ * WA_FINAL-VERPR.
    WA_FINAL-PR_VAL  = PR_VAL.
***====================================

*=================Consumption value 12/10/2011
    LV_STK = REQMT - WA_DATA-EISBE.

    IF  TOT_REQ GT LV_STK.
      WA_FINAL-C_VALUE = TOT_REQ * WA_FINAL-VERPR.
    ELSE.
      WA_FINAL-C_VALUE =  LV_STK * WA_FINAL-VERPR .
    ENDIF.
    CLEAR LV_STK.
*=====Excess Stock calculation.

    LV_STK = REQMT - TOT_REQ.
    IF LV_STK  GT 0.
      WA_FINAL-EXCESS_STK = LV_STK.
    ELSE.
      WA_FINAL-EXCESS_STK = 0.
    ENDIF.
    CLEAR LV_STK.

*=======Excess Order calculation==========

**    lv_stk = purch_orders - shortages.
**    IF lv_stk  GT 0.
**      wa_final-excess_ord = lv_stk.
**    ELSE.
**      wa_final-excess_ord = 0.
**    ENDIF.
**    CLEAR lv_stk.

*********************** net indent calculation *************************************************
    WA_FINAL-NET_INDENT = WA_FINAL-SHORTAGES - ( WA_FINAL-PROD_ORDERS + WA_FINAL-PURCH_ORDERS ).               "ADD
    IF WA_FINAL-NET_INDENT < 0.
      WA_FINAL-NET_INDENT = 0.
    ENDIF.

*********************** excess order calculation *************************************************
    WA_FINAL-EXCESS_ORD = ( WA_FINAL-PROD_ORDERS + WA_FINAL-PURCH_ORDERS ) - WA_FINAL-SHORTAGES .    "ADD

    IF WA_FINAL-EXCESS_ORD < 0.
      WA_FINAL-EXCESS_ORD = 0.
    ENDIF.

*=========================================
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR: WA_DATA, WA_FINAL.
    IF NOT IT_FINAL IS INITIAL.
      DELETE IT_FINAL WHERE  TOT_REQ = 0
**start of chanage pankaj
                AND UNRESTRICTED_STK  = 0
                AND BLOCKED_STK = 0
*                AND WIP_STK  = 0
                AND QUALITY_STK  = 0
*end of change pankaj
                AND IN_HAND_STOCK = 0
                AND PLANNED_ORDERS = 0
                AND PURCHASE_REQ = 0
                AND PROD_ORDERS = 0
                AND PURCH_ORDERS = 0
                AND SHORTAGES = 0.

    ENDIF.

    CLEAR : WA_FINAL,
            TOT_REQ,
            IN_HAND_STOCK,
            PLANNED_ORDERS,
            PURCHASE_REQ,
            PROD_ORDERS,
            PURCH_ORDERS,
            SHORTAGES,
            SHORTAGES1,
            UNRESTRICTED_STK,
            VENDOR_STK,
            QUALITY_STK,
            SUB_BALN,
            BLOCKED_STK.


  ENDLOOP.
*---------------------------Added By abhishek Pisolkar (14.03.2018)----------
*  BREAK primus.
  LOOP AT IT_FINAL INTO WA_FINAL.
    MOVE-CORRESPONDING WA_FINAL TO GS_FINAL.
    GS_FINAL-REF_DATE = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = GS_FINAL-REF_DATE
      IMPORTING
        OUTPUT = GS_FINAL-REF_DATE.
    CONCATENATE GS_FINAL-REF_DATE+0(2) GS_FINAL-REF_DATE+2(3) GS_FINAL-REF_DATE+5(4)
     INTO GS_FINAL-REF_DATE SEPARATED BY '-'.

    APPEND GS_FINAL TO GT_FINAL.
    CLEAR : WA_FINAL , GS_FINAL.
  ENDLOOP.
*--------------------------------------------------------------------*

  " ENDLOOP.
  REFRESH IT_DATA.
*____________________________________________________________________________________________*
* * STORE REPORT NAME
  I_REPID = SY-REPID.
*
*  UNRESTRICTED_STK
*  VENDOR_STK
*  WIP_STK
*  QUALITY_STK
*  EISBE
*  BESKZ
*  VERPR
*  MEINS
*  SUB_BALN
*  PR_VAL

  IF P_DOWN IS   INITIAL.
****************************************************************************************
*ADDING TOP OF PAGE FEATURE
    PERFORM STP3_EVENTTAB_BUILD   CHANGING GT_EVENTS[].

    PERFORM COMMENT_BUILD         CHANGING I_LIST_TOP_OF_PAGE[].
    PERFORM TOP_OF_PAGE.
    PERFORM LAYOUT_BUILD          CHANGING WA_LAYOUT.
****************************************************************************************
    PERFORM BUILD_FIELDCAT USING 'MATNR'          'X' '1'   ''(003).
    PERFORM BUILD_FIELDCAT USING 'MAKTX'          ' ' '2'   ''(004).
    PERFORM BUILD_FIELDCAT USING 'BRAND'          ' ' '3'   ''(005).
    PERFORM BUILD_FIELDCAT USING 'SERIES'         ' ' '4'   ''(006).
    PERFORM BUILD_FIELDCAT USING 'SIZE'           ' ' '5'   ''(007).
    PERFORM BUILD_FIELDCAT USING 'MOC'            ' ' '6'   ''(008).
    PERFORM BUILD_FIELDCAT USING 'TYPE'           ' ' '7'   ''(009).
    PERFORM BUILD_FIELDCAT USING 'BESKZ'          ' ' '8'   ''(010).
    PERFORM BUILD_FIELDCAT USING 'MRPCNT'         ' ' '9'   ''(011).
    PERFORM BUILD_FIELDCAT USING 'MEINS'          ' ' '10'  ''(012).
    PERFORM BUILD_FIELDCAT USING 'TOT_REQ'        ' ' '11'  ''(013).
    PERFORM BUILD_FIELDCAT USING 'UNRESTRICTED_STK' ' ' '12' ''(014).
*  PERFORM BUILD_FIELDCAT USING 'VENDOR_STK'     ' ' '13'  ''(015).
    PERFORM BUILD_FIELDCAT USING 'BLOCKED_STK'    ' ' '13' ''(034).
    PERFORM BUILD_FIELDCAT USING 'WIP_STK'        ' ' '14'  ''(016).
    PERFORM BUILD_FIELDCAT USING 'QUALITY_STK'    ' ' '15'  ''(017).
    PERFORM BUILD_FIELDCAT USING 'EISBE'          ' ' '16'  ''(018).
    PERFORM BUILD_FIELDCAT USING 'PLANNED_ORDERS' ' ' '17'  ''(019).
    PERFORM BUILD_FIELDCAT USING 'PROD_ORDERS'    ' ' '18'  ''(020).
    PERFORM BUILD_FIELDCAT USING 'PURCHASE_REQ'   ' ' '19'  ''(021).
    PERFORM BUILD_FIELDCAT USING 'PURCH_ORDERS'   ' ' '20'  ''(022).
    PERFORM BUILD_FIELDCAT USING 'SUB_BALN'       ' ' '21'  ''(023).
    PERFORM BUILD_FIELDCAT USING 'VERPR'          ' ' '22'  ''(024).
    PERFORM BUILD_FIELDCAT USING 'PR_VAL'         ' ' '23'  ''(025).
    PERFORM BUILD_FIELDCAT USING 'SHORTAGES'      ' ' '24'  ''(026).
    PERFORM BUILD_FIELDCAT USING 'MTART'          ' ' '25'  ''(027).
    PERFORM BUILD_FIELDCAT USING 'BISMT'          ' ' '26'  ''(028).
    PERFORM BUILD_FIELDCAT USING 'C_VALUE'        ' ' '27'  ''(031).
    PERFORM BUILD_FIELDCAT USING 'EXCESS_STK'     ' ' '28'  ''(032).
    PERFORM BUILD_FIELDCAT USING 'EXCESS_ORD'     ' ' '29'  'Excess Order'(033).
    PERFORM BUILD_FIELDCAT USING 'NET_INDENT'     ' ' '30'  'Net Indent'(035).
    PERFORM BUILD_FIELDCAT USING 'EKGRP'          ' ' '31'  'Purchasing Group'(036).

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        I_CALLBACK_PROGRAM = SY-REPID
        I_STRUCTURE_NAME   = 'TT_FINAL'
        IS_LAYOUT          = WA_LAYOUT
        IT_FIELDCAT        = IT_FCAT
        IT_SORT            = I_SORT
        I_DEFAULT          = 'A'
        I_SAVE             = 'A'
        IT_EVENTS          = GT_EVENTS[]
*       IT_EVENT_EXIT      =
*       IS_PRINT           =
*       IS_REPREP_ID       =
*       I_SCREEN_START_COLUMN             = 0
*       I_SCREEN_START_LINE               = 0
*       I_SCREEN_END_COLUMN               = 0
*       I_SCREEN_END_LINE  = 0
*       I_HTML_HEIGHT_TOP  = 0
*       I_HTML_HEIGHT_END  = 0
*       IT_ALV_GRAPHICS    =
*       IT_HYPERLINK       =
*       IT_ADD_FIELDCAT    =
*       IT_EXCEPT_QINFO    =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER           =
*       ES_EXIT_CAUSED_BY_USER            =
      TABLES
        T_OUTTAB           = IT_FINAL
      EXCEPTIONS
        PROGRAM_ERROR      = 1
        OTHERS             = 2.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
  ELSE.
    PERFORM DOWN_SET.
*    PERFORM gui_download.
  ENDIF.


  REFRESH IT_FINAL.

*&---------------------------------------------------------------------*
*&      FORM  BUILD_FIELDCAT
*&---------------------------------------------------------------------*

FORM BUILD_FIELDCAT  USING    V1  V2 V3 V4.
  WA_FCAT-FIELDNAME   = V1 ." 'VBELN'.
  WA_FCAT-TABNAME     = 'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
  WA_FCAT-KEY         =  V2 ."  'X'.
  WA_FCAT-SELTEXT_M   =  V4.
  WA_FCAT-OUTPUTLEN   =  18.
  WA_FCAT-DDICTXT     =  'M'.
  WA_FCAT-COL_POS     =  V3.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      FORM  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_I_EVENTS[]  TEXT
*----------------------------------------------------------------------*
FORM STP3_EVENTTAB_BUILD  CHANGING P_I_EVENTS TYPE SLIS_T_EVENT..
  DATA: LF_EVENT TYPE SLIS_ALV_EVENT. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE     = 0
    IMPORTING
      ET_EVENTS       = P_I_EVENTS
    EXCEPTIONS
      LIST_TYPE_WRONG = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  MOVE C_FORMNAME_TOP_OF_PAGE TO LF_EVENT-FORM.
  MODIFY P_I_EVENTS  FROM  LF_EVENT INDEX 3 TRANSPORTING FORM."TO P_I_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      FORM  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = I_LIST_TOP_OF_PAGE[]. "INTERNAL TABLE WITH
*  DETAILS WHICH ARE REQUIRED AS HEADER FOR THE ALV.
*    I_LOGO                   =
*    I_END_OF_LIST_GRID       =
*    I_ALV_FORM               =
  .

ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      FORM  COMMENT_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_I_LIST_TOP_OF_PAGE[]  TEXT
*----------------------------------------------------------------------*

FORM COMMENT_BUILD  CHANGING I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER.
  DATA: LF_LINE       TYPE SLIS_LISTHEADER. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_H.
  LF_LINE-INFO =  ''(029).
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.
*--HEAD INFO: TYPE S
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_S.
  LF_LINE-KEY  = TEXT-030.
  LF_LINE-INFO = SY-DATUM.
  WRITE SY-DATUM TO LF_LINE-INFO USING EDIT MASK '__-__-____'.
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      FORM  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  TEXT
*----------------------------------------------------------------------*
FORM LAYOUT_BUILD  CHANGING P_WA_LAYOUT TYPE SLIS_LAYOUT_ALV.
*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  WA_LAYOUT-ZEBRA          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  P_WA_LAYOUT-ZEBRA          = 'X'.
  P_WA_LAYOUT-NO_COLHEAD        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWN_SET .
*BREAK primus.
  TYPE-POOLS TRUXS.
  DATA: IT_CSV     TYPE TRUXS_T_TEXT_DATA,
        WA_CSV     TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV     TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV_NEW TYPE LINE OF TRUXS_T_TEXT_DATA.        " Added By Abhishek Pisolkar (14.03.2018)

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE     TYPE STRING,
        LV_FULLFILE_NEW TYPE STRING,
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
  LV_FILE = 'ZPPMRP.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPPMRP Download started on', SY-DATUM, 'at', SY-UZEIT.
  WRITE: / 'Plant', PA_WERKS.
  WRITE: / 'MRP Controller  From', S_MRPCNT-LOW, 'To', S_MRPCNT-HIGH.
  WRITE: / 'Series          From', S_SERIES-LOW, 'To', S_SERIES-HIGH.
  WRITE: / 'Size            From', S_SIZE-LOW, 'To', S_SIZE-HIGH.
  WRITE: / 'Dest. File:', LV_FULLFILE.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_997 TYPE STRING.
    DATA LV_CRLF_997 TYPE STRING.
    LV_CRLF_997 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_997 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_997 LV_CRLF_997 WA_CSV INTO LV_STRING_997.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_997 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
  CLOSE DATASET LV_FULLFILE.
*----------------Added By abhishek Pisolkar (14.03.2018)--------------
  REFRESH : IT_DATA, IT_CSV.
  CLEAR WA_CSV.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      I_TAB_SAP_DATA       = GT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  PERFORM CVS_HEADER_NEW USING HD_CSV_NEW.
  LV_FILE = 'ZPPMRP.TXT'.
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE_NEW.
  WRITE: / 'ZPPMRP Download started on', SY-DATUM, 'at', SY-UZEIT.
  WRITE: / 'Plant', PA_WERKS.
  WRITE: / 'MRP Controller  From', S_MRPCNT-LOW, 'To', S_MRPCNT-HIGH.
  WRITE: / 'Series          From', S_SERIES-LOW, 'To', S_SERIES-HIGH.
  WRITE: / 'Size            From', S_SIZE-LOW, 'To', S_SIZE-HIGH.
  WRITE: / 'Dest. File:', LV_FULLFILE_NEW.
  OPEN DATASET LV_FULLFILE_NEW
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
*     TRANSFER hd_csv_new TO lv_fullfile_new.
    CLEAR : LV_CRLF_997,LV_STRING_997 .
    LV_CRLF_997   = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_997 = HD_CSV.

    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_997 LV_CRLF_997 WA_CSV INTO LV_STRING_997.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_997 TO lv_fullfile.
    TRANSFER LV_STRING_997 TO LV_FULLFILE_NEW.  """ NC
    CLOSE DATASET LV_FULLFILE_NEW.
    CONCATENATE 'File' LV_FULLFILE_NEW 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
*--------------------------------------------------------------------*
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.

*CLASS cl_abap_char_utilities DEFINITION LOAD.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE
        'MATNR'
        'DESCRIPTION'
        'PLANT'
        'BRAND'
        'SERIES'
        'SIZE'
        'MOC'
        'TYPE'
        'MTART'
        'BISMT'
        'MRP CNT'
        'TOT_REQ'
        'IN_HAND_STOCK'
        'PLANNED_ORDERS'
        'PURCHASE_REQ'
        'SHORTAGES'
        'PROD_ORDERS'
        'PURCH_ORDERS'
        'UNRESTRICTED_STK'
        'VENDOR_STK'
        'BLOCKED_STK'
        'WIP_STK'
        'QUALITY_STK'
        'SAFETY STOCK'
        'PROCUREMENT TYPE'
        'MOVING AVERAGE PRICE'
        'BASE UNIT OF MEASURE'
        'SUBCONTRACTOR BALANCE'
        'MOVING AVERAGE PRICE'
        'CONSUMPTION VALUE'
        'EXCESS STOCK'
        'EXCESS ORDER'
        'NET INDENT'
        'Purchasing Group'  "ADD
  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV_NEW  text
*----------------------------------------------------------------------*
FORM CVS_HEADER_NEW  USING    P_HD_CSV_NEW.
  DATA: FIELD_SEPERATOR.
  FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE
        'MATNR'
        'DESCRIPTION'
        'PLANT'
        'BRAND'
        'SERIES'
        'SIZE'
        'MOC'
        'TYPE'
        'MTART'
        'BISMT'
        'MRP CNT'
        'TOT_REQ'
        'IN_HAND_STOCK'
        'PLANNED_ORDERS'
        'PURCHASE_REQ'
        'SHORTAGES'
        'PROD_ORDERS'
        'PURCH_ORDERS'
        'UNRESTRICTED_STK'
        'VENDOR_STK'
        'BLOCKED_STK'
        'WIP_STK'
        'QUALITY_STK'
        'SAFETY STOCK'
        'PROCUREMENT TYPE'
        'MOVING AVERAGE PRICE'
        'BASE UNIT OF MEASURE'
        'SUBCONTRACTOR BALANCE'
        'MOVING AVERAGE PRICE'
        'CONSUMPTION VALUE'
        'EXCESS STOCK'
        'EXCESS ORDER'
        'NET INDENT'
        'REFRESHABLE DATE'
        'Purchasing Group' "ADD
  INTO P_HD_CSV_NEW
  SEPARATED BY FIELD_SEPERATOR.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM gui_download .
*  data : file TYPE string.
*  file = 'H:\ZPPMRP.TXT'.
*CALL FUNCTION 'GUI_DOWNLOAD'
*  EXPORTING
**   BIN_FILESIZE                    =
*    filename                        = file
*   FILETYPE                        = 'ASC'
**   APPEND                          = ' '
*   WRITE_FIELD_SEPARATOR           = 'X'
**   HEADER                          = '00'
**   TRUNC_TRAILING_BLANKS           = ' '
**   WRITE_LF                        = 'X'
**   COL_SELECT                      = ' '
**   COL_SELECT_MASK                 = ' '
**   DAT_MODE                        = ' '
**   CONFIRM_OVERWRITE               = ' '
**   NO_AUTH_CHECK                   = ' '
**   CODEPAGE                        = ' '
**   IGNORE_CERR                     = ABAP_TRUE
**   REPLACEMENT                     = '#'
**   WRITE_BOM                       = ' '
**   TRUNC_TRAILING_BLANKS_EOL       = 'X'
**   WK1_N_FORMAT                    = ' '
**   WK1_N_SIZE                      = ' '
**   WK1_T_FORMAT                    = ' '
**   WK1_T_SIZE                      = ' '
**   WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
**   SHOW_TRANSFER_STATUS            = ABAP_TRUE
**   VIRUS_SCAN_PROFILE              = '/SCET/GUI_DOWNLOAD'
** IMPORTING
**   FILELENGTH                      =
*  tables
*    data_tab                        = gt_final[]
**   FIELDNAMES                      =
* EXCEPTIONS
*   FILE_WRITE_ERROR                = 1
*   NO_BATCH                        = 2
*   GUI_REFUSE_FILETRANSFER         = 3
*   INVALID_TYPE                    = 4
*   NO_AUTHORITY                    = 5
*   UNKNOWN_ERROR                   = 6
*   HEADER_NOT_ALLOWED              = 7
*   SEPARATOR_NOT_ALLOWED           = 8
*   FILESIZE_NOT_ALLOWED            = 9
*   HEADER_TOO_LONG                 = 10
*   DP_ERROR_CREATE                 = 11
*   DP_ERROR_SEND                   = 12
*   DP_ERROR_WRITE                  = 13
*   UNKNOWN_DP_ERROR                = 14
*   ACCESS_DENIED                   = 15
*   DP_OUT_OF_MEMORY                = 16
*   DISK_FULL                       = 17
*   DP_TIMEOUT                      = 18
*   FILE_NOT_FOUND                  = 19
*   DATAPROVIDER_EXCEPTION          = 20
*   CONTROL_FLUSH_ERROR             = 21
*   OTHERS                          = 22
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*
*ENDFORM.
