class ZCL_IM_ME52N_PRCHANGE definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_PROCESS_REQ_CUST .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ME52N_PRCHANGE IMPLEMENTATION.


  METHOD IF_EX_ME_PROCESS_REQ_CUST~CHECK.
*Added By Nilay B. on 10.01.2024**********************

    DATA: L_FAILED TYPE MMPUR_BOOL,
          LT_ITEMS TYPE MMPUR_REQUISITION_ITEMS,
          L_ITEMS  TYPE MMPUR_REQUISITION_ITEM,
          L_ITEM   TYPE REF TO IF_PURCHASE_REQUISITION_ITEM,
          LT_ITEM TYPE MEREQ_ITEM.
    DATA: l_item2 TYPE exkn.

    IMPORT l_item2 TO l_item2  FROM MEMORY id 'ZPUR1'.

    CALL METHOD IM_HEADER->GET_ITEMS
      RECEIVING
        RE_ITEMS = LT_ITEMS.

    IF SY-TCODE = 'ME51N' OR SY-TCODE = 'ME52N' OR SY-TCODE = 'ME53N'.
*      BREAK-POINT.

      LOOP AT LT_ITEMS INTO L_ITEMS.
        L_ITEM = L_ITEMS-ITEM.
        IMPORT L_ITEM TO LT_ITEM  FROM MEMORY ID 'ZPUR'.

        IF LT_ITEM-WERKS = 'PL01' AND LT_ITEM-KNTTP = 'A'.

          SELECT SINGLE ANLN1 FROM EBKN INTO @DATA(LV_ASSET) WHERE ANLN1 = @L_ITEM2-ANLN1.
          SELECT SINGLE ANLN2 FROM EBKN INTO @DATA(LV_ASSET1) WHERE ANLN1 = @L_ITEM2-ANLN1
                                                                AND ANLN2 = @L_ITEM2-ANLN2. "Addeed By Nilay B. On 09.01.2024

          IF SY-SUBRC IS INITIAL.
            SELECT SINGLE BANFN FROM EBKN INTO @DATA(LV_BANFN) WHERE ANLN1 = @L_ITEM2-ANLN1 OR ANLN2 = @L_ITEM2-ANLN2.  "ANLN2 added By Nilay B.
            SELECT SINGLE LOEKZ FROM EBAN INTO @DATA(LV_LOEKZ) WHERE BANFN = @LV_BANFN.

            IF LV_LOEKZ = ''  .
              MESSAGE 'Asset already exists' TYPE 'E'.
            ENDIF. .
          ENDIF.

        ENDIF.


      ENDLOOP.
    ENDIF.


*Added By Nilay B. on 10.01.2024**********************
  ENDMETHOD.


  method IF_EX_ME_PROCESS_REQ_CUST~CLOSE.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_HEADER_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_ITEM.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_ITEM_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~INITIALIZE.

  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~OPEN.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~POST.
*Added By Nilaty on 10.01.2024***************
DATA: L_FAILED TYPE MMPUR_BOOL,
          LT_ITEMS TYPE MMPUR_REQUISITION_ITEMS,
          L_ITEMS  TYPE MMPUR_REQUISITION_ITEM,
          L_ITEM   TYPE REF TO IF_PURCHASE_REQUISITION_ITEM,
          LT_ITEM TYPE MEREQ_ITEM.
    DATA: l_item2 TYPE exkn.

    IMPORT l_item2 TO l_item2  FROM MEMORY id 'ZPUR1'.

    CALL METHOD IM_HEADER->GET_ITEMS
      RECEIVING
        RE_ITEMS = LT_ITEMS.

    IF SY-TCODE = 'ME51N' OR SY-TCODE = 'ME52N' OR SY-TCODE = 'ME53N'.
*      BREAK primus.

      LOOP AT LT_ITEMS INTO L_ITEMS.
        L_ITEM = L_ITEMS-ITEM.
        IMPORT L_ITEM TO LT_ITEM  FROM MEMORY ID 'ZPUR'.

        IF LT_ITEM-WERKS = 'PL01' AND LT_ITEM-KNTTP = 'A'.

          SELECT SINGLE ANLN1 FROM EBKN INTO @DATA(LV_ASSET) WHERE ANLN1 = @L_ITEM2-ANLN1.
          SELECT SINGLE ANLN2 FROM EBKN INTO @DATA(LV_ASSET1) WHERE ANLN1 = @L_ITEM2-ANLN1
                                                              AND ANLN2 = @L_ITEM2-ANLN2. "Addeed By Nilay B. On 09.01.2024

          IF SY-SUBRC IS INITIAL.
            SELECT SINGLE BANFN FROM EBKN INTO @DATA(LV_BANFN) WHERE ANLN1 = @L_ITEM2-ANLN1 OR ANLN2 = @L_ITEM2-ANLN2.  "ANLN2 added By Nilay B.
            SELECT SINGLE LOEKZ FROM EBAN INTO @DATA(LV_LOEKZ) WHERE BANFN = @LV_BANFN.

            IF LV_LOEKZ NE ''.
              MESSAGE 'Asset already exists' TYPE 'E'.
            ENDIF. .
          ENDIF.

        ENDIF.


      ENDLOOP.
    ENDIF.
*Ended By Nilaty on 10.01.2024***************
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~PROCESS_ACCOUNT.
DATA: l_item2 TYPE exkn,
      LT_ITEM TYPE MEREQ_ITEM.

CALL METHOD im_account->GET_EXKN

receiving

RE_EXKN = l_item2.

export l_item2 FROM L_ITEM2 to MEMORY id 'ZPUR1'.
IMPORT l_item TO LT_ITEM  FROM MEMORY id 'ZPUR'.


 IF sy-tcode = 'ME51N'.

IF LT_ITEM-WERKS = 'PL01' AND LT_ITEM-KNTTP = 'A'.

   SELECT single ANLN1 from EBKN into @DATA(LV_ASSET) WHERE ANLN1 = @L_ITEM2-ANLN1.
    SELECT single ANLN2 from EBKN into @DATA(LV_ASSET1) WHERE ANLN2 = @L_ITEM2-ANLN2. "Addeed By Nilay B. On 09.01.2024
*     BREAK-POINT.
     IF SY-SUBRC = 0.
       SELECT SINGLE BANFN FROM ebkn INTO @DATA(lv_banfn) WHERE ANLN1 = @L_ITEM2-ANLN1 OR ANLN2 = @L_ITEM2-ANLN2.  "ANLN2 added By Nilay B.
       SELECT SINGLE loekz FROM eban INTO @DATA(lv_loekz) WHERE banfn = @lv_banfn.
         IF lv_loekz = '' .
       MESSAGE 'Asset already exists' type 'E'.
         ENDIF. .
     ENDIF.

ENDIF.
endif.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~PROCESS_HEADER.



  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~PROCESS_ITEM.

*DATA:
*ld_IM_COUNT TYPE I ,
*ld_IM_ITEM TYPE REF TO IF_PURCHASE_REQUISITION_ITEM.
*
*" ld_IM_COUNT = "
*" ld_IM_ITEM = "
*
*DATA: lo_CUST TYPE REF TO IF_EX_ME_PROCESS_REQ_CUST .
**CALL METHOD lo_CUST->PROCESS_ITEM(
**EXPORTING
**IM_COUNT = ld_IM_COUNT
**IM_ITEM = ld_IM_ITEM ).
*DATA: v_WERKS TYPE EBAN-WERKS,
*      v_KNTTP type EBAN-KNTTP.


data : l_item type MEREQ_ITEM.
break primus.
CALL METHOD im_item->get_data

receiving

re_data = l_item.

  IF sy-tcode = 'ME51N'.
*   v_WERKS = LS_DATA_NEW-WERKS.
*   v_KNTTP = LS_DATA_NEW-KNTTP.

export l_item FROM l_item to MEMORY id 'ZPUR'.
*    TYPES :BEGIN OF ty_ebkn,
*           ANLN1 TYPE ebkn-ANLN1,
*      END OF ty_ebkn.
*      DATA: lt_EBKN TYPE TABLE OF ty_ebkn,
*            ls_ebkn TYPE ty_ebkn.
**      BREAK-POINT.
*    SELECT ANLN1 from EBKN into TABLE lt_EBKN.
*IF lt_EBKN[] is NOT INITIAL.
*  MESSAGE 'Asset number exists.' TYPE 'E'.
ENDIF.
*  ENDIF.
  endmethod.
ENDCLASS.
