*&---------------------------------------------------------------------*
*&  Include           ZXM06U41
*&---------------------------------------------------------------------*
DATA:req_qty       TYPE bstmg,
     v_reban_bsmng TYPE bstmg.

IF sy-tcode = 'ME21N'.

  """"""""""""""""   Added By KD on 03.05.2017   """""""""""""""""
*  DATA : w_ekpo TYPE ekpo .
*
*
*  TYPES : BEGIN OF ty_eine,
*            infnr TYPE eine-infnr,
*            werks TYPE eine-werks,
*            minbm TYPE eine-minbm,
*          END OF ty_eine.

*  TYPES : BEGIN OF ty_eban,
*            banfn TYPE eban-banfn,
*            bnfpo TYPE eban-bnfpo,
*            statu TYPE eban-statu,
*            matnr TYPE eban-matnr,
*            werks TYPE eban-werks,
*            menge TYPE eban-menge,
*            bedat TYPE eban-bedat,
*            bsmng TYPE eban-bsmng,
*          END OF ty_eban.
*
*  DATA : it_eine TYPE TABLE OF ty_eine,
*         wa_eine TYPE ty_eine,
*         it_eban TYPE TABLE OF ty_eban,
*         wa_eban TYPE ty_eban.
*
*  DATA : lv_rqty TYPE eban-menge,
*         lv_aqty TYPE eban-menge.
*
*  """"""""""""""   Refresh Table & Clear Work area    """"""""""""
*  REFRESH : it_eine , it_eine[] , it_eban  , it_eban[] .
*  CLEAR : w_ekpo , wa_eine , wa_eban , lv_rqty.
*
*  IF i_ekpo IS NOT INITIAL.
*
*    SELECT infnr
*           werks
*           minbm FROM eine INTO TABLE it_eine
*                              FOR ALL ENTRIES IN tekpo
*                              WHERE infnr = tekpo-infnr
*                                AND werks = tekpo-werks.
*
*    SELECT banfn
*           bnfpo
*           statu
*           matnr
*           werks
*           menge
*           bedat
*           bsmng FROM eban INTO TABLE it_eban
*                              FOR ALL ENTRIES IN tekpo
*                              WHERE matnr = tekpo-matnr
*                                AND werks = tekpo-werks
*                                AND statu = 'N'.
*
*
*    SELECT banfn
*           bnfpo
*           statu
*           matnr
*           werks
*           menge
*           bedat
*           bsmng FROM eban APPENDING TABLE it_eban
*                            FOR ALL ENTRIES IN tekpo
*                              WHERE matnr = tekpo-matnr
*                                AND werks = tekpo-werks
*                                AND statu = 'B'
*                                AND bedat = sy-datum .
*
*    LOOP AT tekpo INTO w_ekpo.
*
*      LOOP AT it_eban INTO wa_eban WHERE matnr = w_ekpo-matnr AND werks = w_ekpo-werks .
*
*        IF wa_eban-statu = 'N'.
*          lv_rqty = lv_rqty + wa_eban-menge .
*        ELSEIF wa_eban-statu = 'B' AND wa_eban-bedat = sy-datum.
*          lv_rqty = ( lv_rqty + wa_eban-menge ) - wa_eban-bsmng .
*        ENDIF.
*      ENDLOOP.
*      IF w_ekpo-ebeln = i_ekpo-ebeln.
*        lv_aqty = lv_aqty + i_ekpo-menge .
*      ELSE.
*        lv_aqty = lv_aqty + w_ekpo-menge .
*      ENDIF.
*    ENDLOOP.
*
*    IF lv_aqty > lv_rqty .
*      MESSAGE e027(zdel).
*    ENDIF.
*  ENDIF.
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  IMPORT i_reban-bsmng FROM MEMORY ID 'ZQNT'.
*  IF sy-subrc = 0.
*    v_reban_bsmng = i_reban-bsmng.
*  ELSE.
*    v_reban_bsmng = i_reban-bsmng.
*  ENDIF.
*
*  req_qty = i_ekpo-menge + v_reban_bsmng.
*
*  EXPORT i_reban-bsmng TO MEMORY ID 'ZQNT'.
*
*  IF i_eine-minbm IS INITIAL.
*    EXIT.
*  ENDIF.
*
*  IF i_reban-menge > i_eine-minbm .
*    if i_ekpo-menge > i_reban-menge.  "Abhay 05.04.2017
*      MESSAGE e027(zdel).
*    endif."Abhay
*     EXIT.
*  ENDIF.
*
**  IF REQ_QTY > I_EINE-MINBM.
*  IF i_ekpo-menge > i_eine-minbm.
*    MESSAGE e027(zdel).
*  ENDIF.
*
*  CLEAR :req_qty,i_ekpo-menge,i_eine-minbm.


  """"""""""""""      Added By KD on 04.05.2017    """""""""""""""""
  """""""""       Purchase Requisition Validation        """""""""""
  DATA : wa_eban TYPE eban .
  SELECT SINGLE * FROM eban INTO wa_eban
                      WHERE banfn = i_ekpo-banfn
                        AND bnfpo = i_ekpo-bnfpo
                        AND statu = 'B'.
  IF sy-subrc = 0 AND wa_eban-bsmng GE wa_eban-menge.
    MESSAGE e076(06) WITH i_ekpo-banfn i_ekpo-bnfpo .
  ENDIF.

*BREAK primusabap.
*IF I_EKKO-FRGZU NE 'XX'.
*  SELECT SINGLE ZGREEN_CHAN FROM qinf INTO @DATA(wa_qanf) WHERE matnr = @I_EKPO-matnr AND lieferant = @i_ekko-lifnr. ""Added by jyoti 11.12.2024
*
*    ekpo_ci-zgreen_fld = wa_qanf.""Added by jyoti 11.12.2024
*ENDIF.
**********
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ENDIF.
*BREAK primusabap.

*  SELECT SINGLE noinsp FROM qinf INTO @DATA(wa_qanf) WHERE matnr = @I_EKPO-matnr AND lieferant = @i_ekko-lifnr. ""Added by pranit 24.10.2024
*IF SY-TCODE = 'ME29N'.
* SELECT SINGLE ZGREEN_FLD
*   FROM EKPO
*   INTO @DATA(GV_ZGREEN_FLD)
*   WHERE EBELN = @I_EKPO-EBELN.
*
*   ekpo_ci-zgreen_fld = GV_ZGREEN_FLD.

  SELECT  SINGLE ZGREEN_CHAN
            FROM qinf
            INTO @DATA(wa_qanf)
            WHERE matnr     = @I_EKPO-matnr AND
                  lieferant = @i_ekko-lifnr AND
                  WERK      = @i_ekpo-WERKS. ""Added by jyoti 11.12.2024

    ekpo_ci-zgreen_fld = wa_qanf.""Added by jyoti 11.12.2024
*    ENDIF.

**************************************************

*  IF wa_qanf EQ 'X'.
*    ekpo_ci-zgreen_fld = 'YES'.
*  ELSE.
*    ekpo_ci-zgreen_fld = 'NO'.
*  ENDIF.
