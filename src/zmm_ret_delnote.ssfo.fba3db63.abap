data : wa_resb type t_resb,
       lv_meins1 type vtext,
      wa_ekpo type tt_ekpo.
clear : wa_ekpo, wa_resb.
CLEAR GS_IT_REF.
CLEAR GS_IT_REFORD.
CLEAR GS_IT_REFPURORD.
break sansari."*******
v_matnr_hd = gs_it_gen-material.

*SELECT SINGLE zeinr
*     FROM mara
*     INTO V_zeinr1
*     WHERE MATNR = v_matnr_hd.

read table it_resb into wa_resb
  with key "ebelp = GS_IT_GEN-ITM_NUMBER+1(5)
            MATNR = GS_IT_GEN-material.
if sy-subrc = 0.
  read table it_ekpo into wa_ekpo with key matnr = wa_resb-baugr.
  IF sy-subrc = 0.
    v_baugr = wa_resb-baugr.
    v_erfmg = wa_ekpo-menge.
    lv_meins = wa_ekpo-meins.
    lv_netpr = wa_ekpo-netpr.
*    concatenate lv_erfmg lv_meins1 into lv_erfmg separated by space.
*    condense lv_netpr.
  ENDIF.
*    lv_netpr = wa_ekpo-netpr.
    v_text6 = lv_netpr.
    condense : v_text6.
****************************************************
*Code for Qty and UOM of Processed Material
"----------------------------------------------------
Data: v_text2 TYPE vtext.
break sansari.
v_qty1 = v_erfmg.

v_text2 = lv_meins.
condense  v_qty1.
condense v_text2.
concatenate v_qty1  v_text2 into v_qty1 SEPARATED BY space.

"--------------------------------------------------------
*Code for Drawing No for processed material:
"---------------------------------------------------------
SELECT SINGLE zeinr
     FROM mara
     INTO V_zeinr
     WHERE MATNR =  V_Baugr.
*---------------------------------------------
*  Code for Material Description
*----------------------------------------------
  IF SY-SUBRC = 0.
      SELECT SINGLE MAKTX
     FROM MAKT
     INTO V_MAKTX
     WHERE MATNR = V_Baugr.
    ENDIF.
*  ENDIF.
*-------------------------------------------
endif.

IF NOT IS_DLV_DELNOTE-IT_REFORD[] IS INITIAL.
* read order data
 IF IS_DLV_DELNOTE-HD_REF-ORDER_NUMB IS INITIAL.
* multiple order numbers exist

  READ TABLE IS_DLV_DELNOTE-IT_REFORD INTO GS_IT_REFORD
             WITH KEY DELIV_NUMB = GS_IT_GEN-DELIV_NUMB
                      ITM_NUMBER = GS_IT_GEN-ITM_NUMBER BINARY SEARCH.
  IF SY-SUBRC NE 0.
    CLEAR GS_IT_REFORD.
  ENDIF.
 ENDIF.
ELSEIF NOT IS_DLV_DELNOTE-IT_REF[] IS INITIAL.
* read stock transfer data
    IF IS_DLV_DELNOTE-HD_REF-REF_DOC IS INITIAL.
*      multiple stock transfer orders
       READ TABLE IS_DLV_DELNOTE-IT_REF INTO GS_IT_REF
              WITH KEY DELIV_NUMB = GS_IT_GEN-DELIV_NUMB
                       ITM_NUMBER = GS_IT_GEN-ITM_NUMBER BINARY SEARCH.
       IF SY-SUBRC NE 0.
          CLEAR GS_IT_REF.
       ENDIF.
    ENDIF.
ENDIF.

* read purchase order data
READ TABLE IS_DLV_DELNOTE-IT_REFPURORD INTO GS_IT_REFPURORD
           WITH KEY DELIV_NUMB = GS_IT_GEN-DELIV_NUMB
                    ITM_NUMBER = GS_IT_GEN-ITM_NUMBER BINARY SEARCH.

*select single baugr
*   from resb
*  into V_baugr
*  where MATNR = v_matnr_hd
*  and ebeln =  GS_IT_GEN-DELIV_NUMB.

IF SY-SUBRC = 0.
  IF ( GS_IT_REFPURORD-PO_ITM_NO IS INITIAL ) AND
     ( NOT IS_DLV_DELNOTE-HD_REF-PURCH_NO_C IS INITIAL ).
*      po item number is initial
*      po number is written on delivery header level (unique)
*      -> no additional reference info, clear po cust number
       CLEAR GS_IT_REFPURORD-PURCH_NO_C.
   ENDIF.
  IF ( GS_IT_REFPURORD-PO_ITM_NO_S IS INITIAL ) AND
     ( NOT IS_DLV_DELNOTE-HD_REF-PURCH_NO_S IS INITIAL ).
*      po item number is initial
*      po number is written on delivery header level (unique)
*      -> no additional reference info, clear po ship to number
       CLEAR GS_IT_REFPURORD-PURCH_NO_S.
   ENDIF.
ENDIF.
