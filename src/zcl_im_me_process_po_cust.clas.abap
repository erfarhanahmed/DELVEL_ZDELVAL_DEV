class ZCL_IM_ME_PROCESS_PO_CUST definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_ME_PROCESS_PO_CUST .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ME_PROCESS_PO_CUST IMPLEMENTATION.


METHOD if_ex_me_process_po_cust~check.
"break primus.
*******************************************Start Of MRP Lock Enhancement By Swati Patil***********************************************
  INCLUDE mm_messages_mac.

  TYPES :BEGIN OF ty_mard,
           matnr TYPE matnr,
           werks TYPE werks_d,
           lgort TYPE lgort_d,
           labst TYPE labst,
           insme TYPE insme,
           speme TYPE speme,
         END OF ty_mard,

         BEGIN OF ty_mska,
           matnr TYPE matnr,
           werks TYPE werks_d,
           lgort TYPE lgort_d,
           kalab TYPE labst,
           kains TYPE insme,
           kaspe TYPE speme,
         END OF ty_mska,

         BEGIN OF ty_eine,
           infnr TYPE infnr,
           esokz TYPE esokz,
           werks TYPE werks,
           minbm TYPE minbm,
           norbm TYPE norbm,
           bstma TYPE bstma,
         END OF ty_eine,

         BEGIN OF ty_mepoitem,
           matnr TYPE matnr,
           ebeln TYPE ebeln,
           ebelp TYPE ebelp,
           loekz TYPE loekz,
           txz01 TYPE txz01,
           ematn TYPE ematnr,
           werks TYPE ewerk,
           lgort TYPE lgort_d,
           infnr TYPE infnr,
           menge TYPE bstmg,
           meins TYPE meins,
           netpr TYPE bprei,
           elikz TYPE elikz,
           pstyp TYPE pstyp,
           banfn TYPE banfn,
           bnfpo TYPE bnfpo,
         END OF ty_mepoitem ,

         BEGIN OF ty_message,
           message1 TYPE string,
           message2 TYPE string,
           message3 TYPE string,
         END OF ty_message,

         BEGIN OF ty_ekpo,
           ebeln TYPE ebeln,
           ebelp TYPE ebelp,
           menge TYPE menge_d,
         END OF ty_ekpo,

         BEGIN OF ty_marc,
           matnr TYPE matnr,
           werks TYPE werks_d,
           eisbe TYPE eisbe,
         END OF ty_marc,

**********************Added By Ni;lay B*************************
         BEGIN OF ty_ekes,
           ebeln TYPE ebeln,
           ebelp TYPE ebelp,
           ebtyp TYPE ebtyp,
           menge TYPE BBMNG,
         END OF ty_ekes.



  DATA : lt_items      TYPE  purchase_order_items,
         ls_item       TYPE  purchase_order_item,
         lt_mepoitem   TYPE TABLE OF mepoitem,
         lt_mepoitem_d TYPE TABLE OF mepoitem,
         ls_mepoitem   TYPE mepoitem,
          ls_mepoitem1 type mepoitem,
         ls_mepoitem_d TYPE mepoitem,
         ls_mepoheader TYPE mepoheader,
         lt_mepoitem_t TYPE TABLE OF ty_mepoitem,
         ls_mepoitem_t TYPE ty_mepoitem,
         lt_ekpo       TYPE TABLE OF ty_ekpo,
         ls_ekpo       TYPE ty_ekpo,
*         lt_ekpo       TYPE TABLE OF ty_ekes,
*         ls_ekpo       TYPE ty_ekes,
         lt_message    TYPE TABLE OF ty_message,
         ls_message    TYPE ty_message,
         lt_marc       TYPE TABLE OF ty_marc,
         ls_marc       TYPE ty_marc.
  DATA : lt_mdps           TYPE STANDARD TABLE OF mdps,
         ls_mdps           TYPE mdps,
         lt_mdez           TYPE STANDARD TABLE OF mdez,
         ls_mdez           TYPE mdez,
         lt_mdsu           TYPE STANDARD TABLE OF mdsu,
         ls_mdsu           TYPE mdsu,
         lv_tot_req        TYPE mng01,
         lv_unr_stk        TYPE mng01,
         lv_stock          TYPE mng01,
         lv_open_po        TYPE mng01,
         lv_qlty_stk       TYPE mng01,
         lv_open_prodo     TYPE mng01,
         lv_open_asnqty     TYPE mng01,
         lv_open_orders    TYPE mng01,
         lv_net_indent     TYPE mng01,
         lv_po_qty_allowed TYPE mng01,
         lv_moq            TYPE minbm,
         lv_message        TYPE string,
         lv_po_qty         TYPE mng01,
         lv_INFO_QTY       TYPE norbm,
         lt_mard           TYPE TABLE OF ty_mard,
         ls_mard           TYPE ty_mard,
         lt_mska           TYPE TABLE OF ty_mska,
         ls_mska           TYPE ty_mska,
         lt_eine           TYPE TABLE OF ty_eine,
         ls_eine           TYPE ty_eine,
         lv_net_indent1    TYPE string,
         lv_moq1           TYPE string,
         lv_flag           TYPE c.

  IF sy-tcode = 'ME21N' OR sy-tcode = 'ME22N' OR sy-tcode = 'ME23N'.
    CALL METHOD im_header->get_data
      RECEIVING
        re_data = ls_mepoheader.

    CALL METHOD im_header->get_items
      RECEIVING
        re_items = lt_items.
*    BREAK primusABAP.
* ************************ADDED BY JYOTI ON 12.06.2024****************************************
    IF ls_mepoheader-bsart = 'UIDV' OR ls_mepoheader-bsart = 'SUID'.
      LOOP AT lt_items INTO ls_item.
         CALL METHOD ls_item-item->get_data
          RECEIVING
            re_data = ls_mepoitem.
      SELECT SINGLE * FROM MARC
      INTO @DATA(wa_marc)
      WHERE MATNR = @ls_mepoitem-matnr
      AND WERKS = 'PL01'.
      if wa_marc-LVORM = 'X'.
     CONCATENATE 'Material' ls_mepoitem-matnr 'Flagged for deletion at' wa_marc-werks into data(gv_String) SEPARATED BY space.
     MESSAGE gv_string TYPE 'E'.
     endif.
     endloop.
    ENDIF.
*    BREAK primusABAP.
*  ************************ADDED BY JYOTI ON 17.06.2024****************************************
CALL METHOD im_header->get_items
      RECEIVING
        re_items = lt_items.

  LOOP AT lt_items INTO ls_item.

        CALL METHOD ls_item-item->get_data
          RECEIVING
            re_data = ls_mepoitem.
        DATA: SL TYPE c LENGTH 1.
  IF ls_mepoitem-WERKS = 'PL01'.
    if ls_mepoitem-EBELP = '00010'.
      DAta(gv_lgort) = ls_mepoitem-lgort.
      SL = gv_lgort+0(1).
    endif.
    if ls_mepoitem-EBELP NE '00010'.

    IF SL eq 'K'.
      if gv_lgort NE ls_mepoitem-lgort .
       if ls_mepoitem-lgort+0(1) NE  SL .
      MESSAGE 'Storage Location Mismatch' TYPE 'E'.
*     elseif gv_lgort+0(1) = 'K'.
**        CONCATENATE 'Storage Location Mismatch' gv_lgort into gv_msg SEPARATED BY space.
*        MESSAGE 'Storage Location Mismatch' TYPE 'E'.
        endif.
      ELSEIF gv_lgort+0(1) EQ ls_mepoitem-lgort+0(1).
        CONTINUE .
    endif.
    else.
       if gv_lgort NE ls_mepoitem-lgort.
         if ls_mepoitem-lgort+0(1) = 'K' .
            MESSAGE 'Storage Location Mismatch' TYPE 'E'.
         endif.
       endif.
    endif.
    endif.
   ENDIF.
         CLEAR : ls_mepoitem.
      ENDLOOP.
""""""""""""""""""""""""""""""""""""""Added by Pranit 24.10.2024
*BREAK PRIMUSABAP.
*   IF ls_mepoheader-EKORG = '1000'.
*     if ls_mepoheader-AEDAT GE '20250208'.
*    LOOP AT lt_items INTO ls_item.
*
*      if sy-tabix NE '1'.                                          "added by sonu
*        data(gv_index) = sy-tabix.
*      else.
*        data(gv_index1) = sy-tabix.
*      endif.
*
*
*        CALL METHOD ls_item-item->get_data
*          RECEIVING
*            re_data = ls_mepoitem.
*
*          if ls_mepoitem-EBELP = '00010'.
* if sy-tabix = gv_index1.
*               DAta(gv_zgreen_fld) = ls_mepoitem-zgreen_fld.
*          endif.
*          endif.
*       if ls_mepoitem-EBELP NE '00010'.
*           if gv_index1 NE '1'.
*         if gv_zgreen_fld eq 'YES'.
*          IF gv_zgreen_fld NE ls_mepoitem-zgreen_fld.
*             MESSAGE 'Only select Green Channel Item Code' TYPE 'E'.
*          ENDIF.
*          ELSE.
*            IF gv_zgreen_fld NE ls_mepoitem-zgreen_fld.
*             MESSAGE 'Only select without Green Channel Item Code' TYPE 'E'.
*          ENDIF.
*          ENDIF.
*       ENDIF.
*       endif.
*    ENDLOOP.
*    ENDIF.
*   ENDIF.


 IF ls_mepoheader-EKORG = '1000'.
     if ls_mepoheader-AEDAT GE '20250208'.
    read table lt_items into data(ls_item1) INDEX 1.
     CALL METHOD ls_item1-item->get_data
          RECEIVING
            re_data = ls_mepoitem1.

    LOOP AT lt_items INTO ls_item.

        CALL METHOD ls_item-item->get_data
          RECEIVING
            re_data = ls_mepoitem.



          if ls_mepoitem-EBELP = ls_mepoitem1-EBELP.
               DAta(gv_zgreen_fld) = ls_mepoitem-zgreen_fld.
          endif.

          if ls_mepoitem-EBELP ne ls_mepoitem1-EBELP.
         if gv_zgreen_fld eq 'YES'.
          IF gv_zgreen_fld NE ls_mepoitem-zgreen_fld.
             MESSAGE 'Only select Green Channel Item Code' TYPE 'E'.
          ENDIF.
          ELSE.
            IF gv_zgreen_fld NE ls_mepoitem-zgreen_fld.
             MESSAGE 'Only select without Green Channel Item Code' TYPE 'E'.
          ENDIF.
          ENDIF.
       ENDIF.
    ENDLOOP.
    ENDIF.
   ENDIF.


****************************************************ENded by pranit 24.10.2024
    IF ls_mepoheader-bsart = 'ZRP'.

    ELSE.
      LOOP AT lt_items INTO ls_item.
        CALL METHOD ls_item-item->get_data
          RECEIVING
            re_data = ls_mepoitem.
        IF ls_mepoitem-loekz =  'L' OR ls_mepoitem-elikz = 'X'.
          APPEND ls_mepoitem TO lt_mepoitem_d.
        ENDIF.

        IF ls_mepoitem-banfn IS INITIAL AND ls_mepoitem-werks = 'PL01' AND ls_mepoitem-matnr IS NOT INITIAL AND ls_mepoitem-loekz <> 'L' AND ls_mepoitem-elikz <> 'X'.
          CASE sy-tcode.
            WHEN 'ME21N'.
              APPEND ls_mepoitem TO lt_mepoitem.
            WHEN 'ME22N' OR 'ME23N'.
              SELECT SINGLE ebeln ebelp menge
                     FROM ekpo
                     INTO  ls_ekpo
                     WHERE ebeln = ls_mepoitem-ebeln
                     AND ebelp = ls_mepoitem-ebelp.
              IF sy-subrc = 0.
                IF ls_ekpo-menge <> ls_mepoitem-menge.
                  APPEND ls_mepoitem TO lt_mepoitem.
                ENDIF.
                APPEND ls_ekpo TO lt_ekpo.
              ELSE.
                APPEND ls_mepoitem TO lt_mepoitem.

              ENDIF.

*            ENDIF.
          ENDCASE.

        ENDIF.

        CLEAR : ls_mepoitem,ls_ekpo.
      ENDLOOP.

      IF lt_mepoitem IS NOT INITIAL.
        MOVE-CORRESPONDING lt_mepoitem TO lt_mepoitem_t.

        SELECT matnr werks lgort
               labst insme  speme
               FROM mard
               INTO  TABLE lt_mard
               FOR ALL ENTRIES IN lt_mepoitem
               WHERE matnr = lt_mepoitem-matnr
               AND werks = lt_mepoitem-werks
               AND lgort NOT IN ('RJ01', 'SCR1', 'SRN1', 'SPC1', 'KRJ0', 'KSCR', 'KSRN', 'KSPC')."SPC1 added by jyoti on 12.06.2024, KRJ0, KSCR, KSRN, KSPC added by jyoti on 15.11.2024

        SELECT matnr werks lgort
               kalab  kains kaspe
               FROM mska
               INTO TABLE lt_mska
               FOR ALL ENTRIES IN lt_mepoitem
               WHERE matnr = lt_mepoitem-matnr
               AND werks = lt_mepoitem-werks
               AND lgort NOT IN ('RJ01' , 'SCR1', 'SPC1', 'KRJ0', 'KSCR',  'KSPC')."SPC1 added by jyoti on 12.06.2024 KRJ0, KSCR, KSPC added by jyoti on 15.11.2024

        SELECT infnr esokz werks
               minbm norbm bstma
               FROM eine
               INTO TABLE lt_eine
               FOR ALL ENTRIES IN lt_mepoitem
               WHERE infnr = lt_mepoitem-infnr
               AND werks = lt_mepoitem-werks.

*      IF sy-tcode = 'ME22N'.
*        SELECT ebeln ebelp menge
*               FROM ekpo
*               INTO TABLE lt_ekpo
*               FOR ALL ENTRIES IN lt_mepoitem
*               WHERE ebeln = lt_mepoitem-ebeln
*               AND ebelp = lt_mepoitem-ebelp.
*
*
*      ENDIF.
        SELECT matnr werks eisbe
               FROM marc
               INTO TABLE lt_marc
               FOR ALL ENTRIES IN lt_mepoitem
               WHERE matnr = lt_mepoitem-matnr
               AND werks = lt_mepoitem-werks.

      ENDIF.
      SORT lt_mepoitem_t BY matnr.
*    BREAK primus.
      LOOP AT lt_mepoitem_t ASSIGNING FIELD-SYMBOL(<fs_mepoitem_t>).    " WHERE loekz <> 'X' AND elikz <> 'X' .
        IF <fs_mepoitem_t> IS ASSIGNED.

*        IF <fs_mepoitem_t>-banfn IS INITIAL AND <fs_mepoitem_t>-werks = 'PL01' AND <fs_mepoitem_t>-matnr IS NOT INITIAL AND lv_flag = 'X'.
          CASE sy-tcode.
            WHEN 'ME21N'.
              lv_po_qty = lv_po_qty + <fs_mepoitem_t>-menge.
            WHEN 'ME22N' OR 'ME23N'.
              READ TABLE lt_ekpo INTO ls_ekpo WITH  KEY ebeln = <fs_mepoitem_t>-ebeln  ebelp = <fs_mepoitem_t>-ebelp.
              IF sy-subrc = 0.
                lv_po_qty = lv_po_qty + ( <fs_mepoitem_t>-menge - ls_ekpo-menge   ).
              ELSE.
                lv_po_qty = lv_po_qty + <fs_mepoitem_t>-menge.
              ENDIF.


           ENDCASE.
          AT NEW matnr.
*
*****************MOQ CALCULATION only for ME21N*****************************************
            IF sy-tcode = 'ME21N'.
              IF <fs_mepoitem_t>-pstyp = '3' .
                READ TABLE lt_eine INTO ls_eine WITH  KEY infnr = <fs_mepoitem_t>-infnr esokz = '3'.
*                 LV_INFO_QTY = ls_eine-NORBM.
              ELSE.
                READ TABLE lt_eine INTO ls_eine WITH  KEY infnr = <fs_mepoitem_t>-infnr esokz = '0'.
*                 LV_INFO_QTY = ls_eine-NORBM.
              ENDIF.
              lv_moq = ls_eine-minbm.
            ENDIF.
*     DATA: LV_NET_INDENT_1 TYPE string.
*
*               LV_NET_INDENT_1 =  lv_po_qty - ls_eine-NORBM.

**********************************TOTAL REQUIREMENT & OPEN PO CALCULATION **************************************************
            CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
              EXPORTING
                matnr                    = <fs_mepoitem_t>-matnr
                werks                    = <fs_mepoitem_t>-werks
              TABLES
                mdpsx                    = lt_mdps
                mdezx                    = lt_mdez
                mdsux                    = lt_mdsu
              EXCEPTIONS
                material_plant_not_found = 1
                plant_not_found          = 2
                OTHERS                   = 3.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.


            LOOP AT lt_mdps INTO ls_mdps.
              IF  ls_mdps-delkz = 'VC'
                OR ls_mdps-delkz = 'SB'
                OR ( ls_mdps-delkz = 'BB' AND ls_mdps-plaab <> 26 )
                OR ls_mdps-delkz = 'U1'
                OR ls_mdps-delkz = 'U2'
                OR ( ls_mdps-delkz = 'AR').       "AND ls_mdps-plumi <> '+' ).
                IF ls_mdps-delkz = 'AR' AND ls_mdps-plumi = '+'.
                  lv_tot_req          =  lv_tot_req   - ls_mdps-mng01.
                ELSE.
                  lv_tot_req          =  lv_tot_req   + ls_mdps-mng01.
                ENDIF.


              ENDIF.
              IF    ls_mdps-delkz = 'BE'.
                lv_open_po  = lv_open_po + ls_mdps-mng01.
              ENDIF.
              IF    ls_mdps-delkz = 'FE' . "WA_MDPS-DELKZ = 'FE' ).
                lv_open_prodo  = lv_open_prodo + ls_mdps-mng01.
              ENDIF.
*              CLEAR :ls_mdps.

* **********************Added By Nilay B on 28.08.2023******************************

              IF    ls_mdps-delkz = 'LA' . "WA_MDPS-DELKZ = 'FE' ).
                LV_OPEN_ASNQTY  = LV_OPEN_ASNQTY + ls_mdps-mng01.
              ENDIF.
              CLEAR :ls_mdps.

            ENDLOOP.
*****************************************Added on 13.06.2019 for safety quantity by swati****************************************
            READ TABLE lt_marc INTO ls_marc WITH  KEY matnr = <fs_mepoitem_t>-matnr werks = <fs_mepoitem_t>-werks.
            IF sy-subrc IS INITIAL.
              lv_tot_req = lv_tot_req + ls_marc-eisbe.
            ENDIF.
            CLEAR ls_marc.
**********************************End**********************************************            *
*            IF lv_tot_req <= 0 AND sy-tcode = 'ME21N'.
*              CONCATENATE 'Material Requirement For' <fs_mepoitem_t>-matnr 'Is 0' INTO ls_message-message SEPARATED BY ' ' .
*              APPEND ls_message TO lt_message.
*            ELSE.
            lv_open_orders = lv_open_po + lv_open_prodo.

***************************************Stock Calculation*************************************
            LOOP AT lt_mard INTO ls_mard WHERE matnr = <fs_mepoitem_t>-matnr AND werks = <fs_mepoitem_t>-werks.
              lv_unr_stk = lv_unr_stk + ls_mard-labst.
              lv_qlty_stk      = lv_qlty_stk + ls_mard-insme.
              CLEAR ls_mard.
            ENDLOOP.

            LOOP AT lt_mska INTO ls_mska WHERE matnr = <fs_mepoitem_t>-matnr AND werks = <fs_mepoitem_t>-werks.
              lv_unr_stk = lv_unr_stk + ls_mska-kalab.
              lv_qlty_stk = lv_qlty_stk + ls_mska-kains.
              CLEAR ls_mska.
            ENDLOOP.

            lv_stock = lv_unr_stk + lv_qlty_stk.
*****************************************Net Indent Calculation***************************
            IF sy-tcode = 'ME22N' OR sy-tcode = 'ME23N'.
              READ TABLE lt_mepoitem_d INTO ls_mepoitem_d WITH  KEY ebeln = <fs_mepoitem_t>-ebeln  matnr = <fs_mepoitem_t>-matnr.
              IF sy-subrc = 0.
                lv_open_orders = lv_open_orders - ls_mepoitem_d-menge.
              ENDIF.
            ENDIF.
            lv_net_indent = lv_tot_req - ( lv_stock + lv_open_orders + LV_OPEN_ASNQTY ).
************************************************PO Allowed Qty Calculation**************************************
            IF lv_net_indent < 0.
              CLEAR lv_net_indent.
            ENDIF.
            IF lv_net_indent > 0 AND sy-tcode = 'ME21N'.
              IF lv_net_indent >= lv_moq.
                lv_po_qty_allowed  = lv_net_indent.
              ELSE.
                lv_po_qty_allowed  = lv_moq.
              ENDIF.
*              ELSE..
*                CONCATENATE 'Net Indent For' <fs_mepoitem_t>-matnr 'Is 0' INTO ls_message-message SEPARATED BY ' ' .
*              APPEND ls_message TO lt_message.
            ELSEIF sy-tcode = 'ME23N' OR sy-tcode = 'ME22N'.
              lv_po_qty_allowed  = lv_net_indent.
            ENDIF.

*            ENDIF.
          ENDAT.

          AT END OF matnr.
            IF sy-tcode = 'ME21N' AND  lv_net_indent <= 0 .
*              IF lv_po_qty >  lv_po_qty_allowed .
              lv_net_indent1 = lv_net_indent.
              lv_moq1 = lv_moq .
*              CONCATENATE <fs_mepoitem_t>-matnr 'Have Net Indent' lv_net_indent1 'And MOQ' lv_moq1 INTO  ls_message-message SEPARATED BY ' '.         "lv_message.
              ls_message-message1 = <fs_mepoitem_t>-matnr.
              ls_message-message2 = lv_net_indent1.
              ls_message-message3 = lv_moq1.
              APPEND ls_message TO lt_message.
              CLEAR :ls_message.
*              MESSAGE lv_message TYPE 'E'.
*              ENDIF.
            ELSEIF sy-tcode = 'ME22N' OR sy-tcode = 'ME23N' OR lv_net_indent > 0  .
              IF lv_po_qty >  lv_po_qty_allowed .
                lv_net_indent1 = lv_net_indent.
                lv_moq1 = lv_moq .
*                CONCATENATE <fs_mepoitem_t>-matnr 'Have Net Indent' lv_net_indent1 'And MOQ' lv_moq1 INTO  ls_message-message SEPARATED BY ' '.         "lv_message.
                ls_message-message1 = <fs_mepoitem_t>-matnr.
                ls_message-message2 = lv_net_indent1.                     "LV_NET_INDENT_1.                       "lv_net_indent1.
                ls_message-message3 = lv_moq1.
                APPEND ls_message TO lt_message.
                CLEAR :ls_message.
              ENDIF.
            ENDIF.
            CLEAR : lv_tot_req,lv_po_qty,lv_moq,lv_tot_req,lv_open_po,lv_open_prodo,lv_open_orders,lv_stock,lv_net_indent,lv_po_qty_allowed,lv_po_qty,
                    ls_message,lv_unr_stk,lv_qlty_stk,ls_mepoitem_d,LV_OPEN_ASNQTY.
          ENDAT.
*        ENDIF.

          CLEAR :lt_mdps,lt_mdez,lt_mdsu.
        ENDIF.

      ENDLOOP.
      LOOP AT lt_message INTO ls_message.
        IF sy-tcode = 'ME21N'.
          mmpur_message_forced 'E' 'ZME' '001' ls_message-message1 ls_message-message2 ls_message-message3 ' '.
        ELSE.
          mmpur_message_forced 'E' 'ZME' '003' ls_message-message1 ls_message-message2 ' ' ' '.
        ENDIF.
        ch_failed = 'X'.
      ENDLOOP.
    ENDIF.

  ENDIF.

************************************************End Of MRP Lock****************************************

*---------------------------------------------------------------------------------------------------*PO Release

 DATA : lv_ebeln TYPE ekko-ebeln,
        lv_ebeln1 TYPE ekpo-ebeln.
 DATA : lt_zmm_bhuvi_po TYPE TABLE OF zmm_bhuvi_po,
        ls_zmm_bhuvi_po TYPE zmm_bhuvi_po.

  IF sy-tcode = 'ME29N' or sy-tcode = 'ME28N'.

    CALL METHOD im_header->get_data
      RECEIVING
        re_data = ls_mepoheader.

    SELECT SINGLE ebeln
                  INTO lv_ebeln
                  FROM ekko
                  WHERE ebeln = ls_mepoheader-ebeln
                  AND   frgke = '2'.

    IF sy-subrc = 0.
    SELECT SINGLE ebeln
                  INTO lv_ebeln1
                  FROM ekpo
                  WHERE ebeln = lv_ebeln
                  AND   bstae = '0004'.

    IF sy-subrc = 0.
    SELECT * FROM zmm_bhuvi_po
             INTO TABLE lt_zmm_bhuvi_po
             WHERE ebeln = lv_ebeln1.
    ENDIF.

    LOOP AT lt_zmm_bhuvi_po INTO ls_zmm_bhuvi_po.
      ls_zmm_bhuvi_po-transfer_2_bhuvi = ''.
      MODIFY lt_zmm_bhuvi_po FROM ls_zmm_bhuvi_po TRANSPORTING transfer_2_bhuvi.

    ENDLOOP.

    MODIFY zmm_bhuvi_po FROM TABLE lt_zmm_bhuvi_po.

    ENDIF.

  ENDIF.
*---------------------------------------------------------------------------------------------------*PO Release

ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~CLOSE.
*    BREAK-POINT.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM.

*    *    Commented on 02.04.2021 by swati this code is replaced in method OPEN of same BADI implementation

*    INCLUDE MM_MESSAGES_MAC.


* CONSTANTS : cv_val_date TYPE sy-datum VALUE '20210401'.
* DATA : ls_ch_fieldselection TYPE MMPUR_FS,
*        ls_mepoheader TYPE mepoheader.
* IF sy-tcode = 'ME22N' or sy-tcode = 'ME23N'.
*   CALL METHOD im_header->get_data
*      RECEIVING
*        re_data = ls_mepoheader.
*
*   IF ls_mepoheader-bsart <> 'ZRP' AND ls_mepoheader-aedat <  cv_val_date  .
*     EXPORT ls_mepoheader = ls_mepoheader TO MEMORY ID 'ZMRP'.
*    ENDIF.
* ENDIF.
****************************************End Of Comment by swati******************
*    IF ls_mepoheader-aedat < sy-datum AND ls_mepoheader-bsart <> 'ZRP' .
*      mmpur_metafield mmmfd_quantity.
*      read table ch_fieldselection assigning FIELD-SYMBOL(<fs>)
*      with table key metafield = mmmfd_quantity.
*      ls_ch_fieldselection-metafield = mmmfd_quantity.
*      ls_ch_fieldselection-fieldstatus = '-'.
*      INSERT ls_ch_fieldselection INTO TABLE CH_FIELDSELECTION.
*    ENDIF.
*


  endmethod.


  METHOD if_ex_me_process_po_cust~fieldselection_item_refkeys.
******************Start Of MRP Lock Enhancement By Swati Patil********************
    DATA : ls_mepoheader TYPE mepoheader.


    CONSTANTS :   cv_val_date TYPE sy-datum VALUE '20210101'.

    IF sy-tcode = 'ME22N' OR sy-tcode = 'ME23N'.

      IMPORT ls_mepoheader = ls_mepoheader FROM MEMORY ID 'ZMRP'.  "Exported from method  OPEN of same BADI implementation
      IF ls_mepoheader IS NOT INITIAL AND ls_mepoheader-bsart <> 'ZRP'.
        IF ls_mepoheader-aedat < cv_val_date.
*          ch_key2 = 'ZNBF'.
          ch_key6 = 'ZNBF'.
        ENDIF.
      ENDIF.
    ENDIF.
*************************************End**************************************
  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~INITIALIZE.

  endmethod.


  METHOD if_ex_me_process_po_cust~open.

************Start of MRP Lock Enhancement By Swati Patil*********************


    CONSTANTS : cv_val_date TYPE sy-datum VALUE '20210101'.

    DATA: ls_mepoheader TYPE mepoheader,
          lv_date       TYPE rvari_val_255,
          lv_dt         TYPE sy-datum.


    IF sy-tcode = 'ME22N' OR sy-tcode = 'ME23N'.
      CALL METHOD im_header->get_data
        RECEIVING
          re_data = ls_mepoheader.
*      SELECT SINGLE low FROM tvarvc INTO lv_date WHERE name  = 'ZME_PROCESS_PO_CUST' AND type = 'P'.
*      CHECK sy-subrc = 0.
*      WRITE lv_date TO lv_dt.
      IF ls_mepoheader-bsart <> 'ZRP' AND ls_mepoheader-aedat <  cv_val_date  .
        " To be importes in method FIELDSELECTION_ITEM_REFKEYS of same BADI implementation
        EXPORT ls_mepoheader = ls_mepoheader TO MEMORY ID 'ZMRP'.
      ENDIF.
    ENDIF.

*********************End**********************************************

  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~post.
   " BREAK primus.
     DATA : lt_items      TYPE  purchase_order_items,
         ls_item       TYPE  purchase_order_item,
         lt_mepoitem   TYPE TABLE OF mepoitem,
         lt_mepoitem_d TYPE TABLE OF mepoitem,
         ls_mepoitem   TYPE mepoitem,
         ls_mepoitem_d TYPE mepoitem,
         ls_mepoheader TYPE mepoheader.
*         lt_mepoitem_t TYPE TABLE OF ty_mepoitem,
*         ls_mepoitem_t TYPE ty_mepoitem,
*         lt_ekpo       TYPE TABLE OF ty_ekpo,
*         ls_ekpo       TYPE ty_ekpo,
*         lt_message    TYPE TABLE OF ty_message,
*         ls_message    TYPE ty_message,
*         lt_marc       TYPE TABLE OF ty_marc,
*         ls_marc       TYPE ty_marc.
  DATA : lt_mdps           TYPE STANDARD TABLE OF mdps,
         ls_mdps           TYPE mdps,
         lt_mdez           TYPE STANDARD TABLE OF mdez,
         ls_mdez           TYPE mdez,
         lt_mdsu           TYPE STANDARD TABLE OF mdsu,
         ls_mdsu           TYPE mdsu,
         lv_tot_req        TYPE mng01,
         lv_unr_stk        TYPE mng01,
         lv_stock          TYPE mng01,
         lv_open_po        TYPE mng01,
         lv_qlty_stk       TYPE mng01,
         lv_open_prodo     TYPE mng01,
         lv_open_orders    TYPE mng01,
         lv_net_indent     TYPE mng01,
         lv_po_qty_allowed TYPE mng01,
         lv_moq            TYPE minbm,
         lv_message        TYPE string,
         lv_po_qty         TYPE mng01,
**         lt_mard           TYPE TABLE OF ty_mard,
**         ls_mard           TYPE ty_mard,
**         lt_mska           TYPE TABLE OF ty_mska,
**         ls_mska           TYPE ty_mska,
**         lt_eine           TYPE TABLE OF ty_eine,
*         ls_eine           TYPE ty_eine,
         lv_net_indent1    TYPE string,
         lv_moq1           TYPE string,
         lv_flag           TYPE c.
      IF sy-tcode = 'ME21N' OR sy-tcode = 'ME22N' OR sy-tcode = 'ME23N'.
    CALL METHOD im_header->get_data
      RECEIVING
        re_data = ls_mepoheader.

    CALL METHOD im_header->get_items
      RECEIVING
        re_items = lt_items.
      MESSAGE 'ffff' type 'E'.

*      data : lw_head TYPE thead,
*             LT_LINES TYPE STANDARD TABLE OF TLINE.
*
*          CALL FUNCTION 'SAVE_TEXT'
*
*            EXPORTING
**             CLIENT                = SY-MANDT
*              header                = lw_head
**             INSERT                = ' '
**             SAVEMODE_DIRECT       = ' '
**             OWNER_SPECIFIED       = ' '
**             LOCAL_CAT             = ' '
**           IMPORTING
**             FUNCTION              =
**             NEWHEADER             =
*            tables
*              lines                 = LT_LINES
**           EXCEPTIONS
**             ID                    = 1
**             LANGUAGE              = 2
**             NAME                  = 3
**             OBJECT                = 4
**             OTHERS                = 5
*                    .
**          IF sy-subrc <> 0.
*** Implement suitable error handling here
**          ENDIF.
*        IF SY-subrc IS INITIAL.
*          CALL FUNCTION 'COMMIT_TEXT'.
*         ENDIF.
   endif.


  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_ACCOUNT.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_HEADER.
"BREAK primus.


DATA: LT_TEXTLINES    TYPE MMPUR_T_TEXTLINES,
           LS_TEXTLINES    TYPE MMPUR_TEXTLINES,
           LS_SUPERFIELD TYPE STRING,
           LW_NAME4          TYPE LFA1-NAME4,
           HEADER_DATA   TYPE MEPOHEADER,
           BSART TYPE EKKO-BSART."ADDED BY JYOTI ON 12.06.2024

CLEAR: LS_TEXTLINES,
             LS_SUPERFIELD,
             LW_NAME4,
             HEADER_DATA.

REFRESH: LT_TEXTLINES.

HEADER_DATA = IM_HEADER->GET_DATA( ).
EXPORT LIFNR FROM HEADER_DATA-lifnr TO MEMORY ID 'LF'.
EXPORT BSART FROM HEADER_DATA-bsart TO MEMORY ID 'TD'."ADDED BY JYOTI ON 12.06.2024
if HEADER_DATA-bsart = 'UIDV'.

* When Logon SAP R/3 with language-B (Here assume the language-B is Japanese)





*   CONCATENATE ‘Vendor:’
*                               HEADER_DATA-LIFNR
*                               LW_NAME4
*                     INTO L_SUPERFIELD SEPARATED BY SPACE.

   MOVE 'EKKO'                   TO  LS_TEXTLINES-TDOBJECT.
   MOVE 'F06'                         TO  LS_TEXTLINES-TDID.
   MOVE 'BY SEA'  TO LS_TEXTLINES-TDLINE.
   MOVE '*'                             TO  LS_TEXTLINES-TDFORMAT.
  " MOVE L_SUPERFIELD      TO  LS_TEXTLINES-TDFORMAT.
   APPEND LS_TEXTLINES  TO  LT_TEXTLINES.

* Set Venor’s language-B(Japanese) description text into Purchase Order ‘Texts’ —> ‘Header Texts
   CALL METHOD IM_HEADER->IF_LONGTEXTS_MM~SET_TEXT(
            EXPORTING
                IM_TDID           = 'F06'
                IM_TEXTLINES  = LT_TEXTLINES ).


*    DATA: ls_mepoheader TYPE mepoheader.
*    DATA : PO_RP TYPE BSART,
*          PO_EBELN TYPE EBELN.
*
*    ls_mepoheader = im_header->get_data( ).
*
*    PO_RP = ls_mepoheader-BSART.
*    PO_EBELN = ls_mepoheader-EBELN.
*
*    EXPORT PO_RP FROM PO_RP TO MEMORY ID 'ZPO_RP'.
*
*    EXPORT PO_EBELN FROM PO_EBELN TO MEMORY ID 'ZPO_EBELN'.
*
**     BREAK PRIMUS.
ENDIF.
  endmethod.


  METHOD if_ex_me_process_po_cust~process_item.
"break primus .
*******************Start Of MRP Lock Enhancement By Swati Patil********************

    INCLUDE mm_messages_mac.

    DATA:ls_mepoitem TYPE mepoitem,
*         HEADER_DATA   TYPE MEPOHEADER,
         lv_moq      TYPE minbm,
         lv_msg      TYPE string,
         lv_moq1     TYPE string,
         BSART       TYPE EKKO-BSART,
         LIFNR TYPE EKKO-LIFNR.

  .

    ls_mepoitem = im_item->get_data( ).

*****************ADDED BY JYOTI ON 12.06.2024*************8888
**BREAK-POINT.
**   CALL METHOD im_item->get_data
**        RECEIVING
**          re_items = it_items.
*
*     IF sy-tcode = 'ME21N' AND ls_mepoitem-matnr IS NOT INITIAL.
*       IMPORT BSART TO BSART FROM MEMORY ID 'TD'.
*    IF BSART = 'UIDV' OR BSART = 'SUID'.
*
*
*    SELECT SINGLE * FROM MARC
*      INTO @DATA(wa_marc)
*      WHERE MATNR = @ls_mepoitem-matnr
*      AND WERKS = 'PL01'.
*      if wa_marc-LVORM = 'X'.
*     CONCATENATE 'Material' ls_mepoitem-matnr 'Flagged for deletion at' wa_marc-werks into data(gv_String) SEPARATED BY space.
*     MESSAGE gv_string TYPE 'E'.
*     endif.
**     endloop.
*    ENDIF.
*    ENDIF.
***********************************************************

    IF sy-tcode = 'ME21N' AND ls_mepoitem-matnr IS NOT INITIAL.
    EXPORT MATNR FROM ls_mepoitem-matnr TO MEMORY ID 'MAT'.
      IF ls_mepoitem-pstyp = '3'.

        SELECT SINGLE
        minbm
        FROM eine
        INTO  lv_moq
        WHERE infnr = ls_mepoitem-infnr
        AND werks = ls_mepoitem-werks
        AND esokz = '3'.

      ELSE.

        SELECT SINGLE
        minbm
        FROM eine
        INTO  lv_moq
        WHERE infnr = ls_mepoitem-infnr
        AND werks = ls_mepoitem-werks
        AND esokz = '0'.

      ENDIF.

      IF lv_moq > 0.

        lv_moq1 = lv_moq.
        CONCATENATE 'MOQ For' ls_mepoitem-matnr 'Is' lv_moq1  INTO lv_msg SEPARATED BY ' ' .
        mmpur_message_forced 'W' 'ZME' '002' ls_mepoitem-matnr lv_moq1 ' ' ' '.

      ENDIF.

    ENDIF.


******************************************End Of MRP Lock****************************
**    BREAK-POINT.
**    METHOD if_ex_me_process_req_cust~process_item.
***************************************Changes By Avinash Bhagat 23.08.2018 ****************************************************************
***to check PR Number file is initial or not initial that we Entered in Tcode me21n
*data:ls_mepoitem TYPE mepoitem,
*       ls_mepoitem_prev TYPE mepoitem.
*DATA :  pr_no TYPE banfn,
*      pr_menge type menge.
*
*    ls_mepoitem = im_item->get_data( ).
*
**pr_menge = ls_mepoitem-menge.
* pr_no =  ls_mepoitem-BANFN.
*
*
* EXPORT PR_NO FROM PR_NO TO MEMORY ID 'ZPR'.
* EXPORT pr_menge from pr_menge to memory id 'zmenge'.
**************************************************************************************************************************************************

  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_SCHEDULE.
  endmethod.
ENDCLASS.
