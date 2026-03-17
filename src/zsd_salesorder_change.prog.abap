REPORT zsd_salesorder_change  NO STANDARD PAGE HEADING.
*----------------------------------------------------------------------*
* OBJECT ID              :  ZMM_CODE_RULE_CREATE
* FUNCTIONAL CONSULTANT  :  KUNDAN SHINDE
* TECHNICAL CONSULTANT   :  BHASKER REDDY
* START DATE             :  1/06/2011
*  MODULE                :  SD.
* INITIAL TRANSPORT NO   :
* DESCRIPTION            :   TO CHANGE SALES ORDER HEADER STATUS AND
*                             SCHEDULE LINE ITEM CATEGORY FROM CN TO CP.
*----------------------------------------------------------------------*
* INCLUDES               :
* FUNCTION MODULES       :
* LOGICAL DATABASE       :
* TRANSACTION CODE       :  ZUNLOCKMRP
* EXTERNAL REFERENCES    :
*----------------------------------------------------------------------*
*                    MODIFICATION LOG
*----------------------------------------------------------------------*
* DATE      | MODIFIED BY   | CTS NUMBER   | COMMENTS
*----------------------------------------------------------------------*

*Data Declaration

*INCLUDE zdata_declaration.
INCLUDE zsd_salesorder_change_data.

*Data Fetch
START-OF-SELECTION.
  PERFORM get_data.
  PERFORM headerstatus_change.
  PERFORM schedullinecat_change.


*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  SELECT * FROM vbak INTO TABLE it_vbak WHERE vbeln = p_vbeln.
  IF NOT it_vbak[] IS INITIAL.
    SELECT * FROM vbep INTO TABLE it_vbep FOR ALL ENTRIES IN it_vbak
      WHERE vbeln = it_vbak-vbeln.
  ENDIF.
ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  HEADERSTATUS_CHANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*To change Header status to ULCK ( Unlock for MRP)
FORM headerstatus_change .
  PERFORM bdc_dynpro      USING 'SAPMV45A' '0102'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VBAK-VBELN'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'VBAK-VBELN'
                                p_vbeln.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '4001'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=HEAD'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                              'RV45A-MABNR(02)'.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '4002'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=T\10'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VBAK-AUDAT'.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '4002'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=T\11'.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '4002'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=KSTC'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RV45A-TXT_VBELN'.
  PERFORM bdc_dynpro      USING 'SAPLBSVA' '0300'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'J_STMAINT-ANWS(04)'.
  PERFORM bdc_field       USING 'J_STMAINT-ANWS(03)'
                                ''.
  PERFORM bdc_field       USING 'J_STMAINT-ANWS(04)'
                                'X'.
  PERFORM bdc_dynpro      USING 'SAPLBSVA' '0300'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=BACK'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'JOSTD-OBJNR'.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '4002'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=SICH'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RV45A-TXT_VBELN'.
  PERFORM bdc_transaction USING 'VA02'.

ENDFORM.                    " HEADERSTATUS_CHANGE
*&---------------------------------------------------------------------*
*&      Form  SCHEDULLINECAT_CHANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*To change schedule line category from CN to CP

FORM schedullinecat_change .


  LOOP AT it_vbak INTO wa_vbak.

    order_headerx_in-updateflag =   'U'.
    LOOP AT it_vbep INTO wa_vbep WHERE vbeln = wa_vbak-vbeln.
      wa_sch-itm_number = wa_vbep-posnr .                   "'000010'.
      wa_sch-sched_line = wa_vbep-etenr ."posnr  '0001'.
      wa_sch-sched_type = 'CP'.
      APPEND wa_sch TO it_sch.

      wa_schx-itm_number = wa_vbep-posnr .                  "'000010'..
      wa_schx-sched_type = 'X'.
      wa_schx-sched_line = wa_vbep-etenr .                  "'0001'.
      wa_schx-updateflag = 'U'.
      APPEND wa_schx TO it_schx.



*CLEAR IORDER_ITEM_IN.
*wa_IORDER_ITEM_IN-ITM_NUMBER = '000010' ."VBAP-POSNR.
*wa_IORDER_ITEM_IN-ITEM_CATEG = 'ZTAN '.
*APPEND wa_IORDER_ITEM_IN to IORDER_ITEM_IN .
*
*CLEAR IORDER_ITEM_INX.
*wa_IORDER_ITEM_INX-ITM_NUMBER = '000010' .
*wa_IORDER_ITEM_INX-UPDATEFLAG = 'U'.
*wa_IORDER_ITEM_IN-ITEM_CATEG = 'X'.
*wa_IORDER_ITEM_INX-UPDATEFLAG = 'U'.
*APPEND wa_IORDER_ITEM_INX to IORDER_ITEM_INX  .



      AT END OF vbeln..

        CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
          EXPORTING
            salesdocument    = p_vbeln " '0000000559' "p_vbeln.
*           ORDER_HEADER_IN  = order_header_in
            order_header_inx = order_headerx_in
          TABLES
            return           = return
*           ORDER_ITEM_IN    = IORDER_ITEM_IN
*           ORDER_ITEM_INX   = IORDER_ITEM_INx
            schedule_lines   = it_sch
            schedule_linesx  = it_schx.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

        LOOP AT return.
          WRITE : return-message.
        ENDLOOP.

      ENDAT.
    ENDLOOP.
  ENDLOOP.
ENDFORM.                    " SCHEDULLINECAT_CHANGE


*&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PROGRAM    text
*      -->DYNPRO     text
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
*  ENDIF.
ENDFORM.                    "BDC_FIELD

*&---------------------------------------------------------------------*
*&      Form  BDC_TRANSACTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->TCODE      text
*----------------------------------------------------------------------*
FORM bdc_transaction USING tcode.
  DATA: l_mstring(480).
  DATA: l_subrc LIKE sy-subrc.

  CALL TRANSACTION tcode USING bdcdata
                   MODE   ctumode
                   UPDATE cupdate.
*                     MESSAGES INTO MESSTAB.

  REFRESH bdcdata.
ENDFORM.                    "BDC_TRANSACTI
