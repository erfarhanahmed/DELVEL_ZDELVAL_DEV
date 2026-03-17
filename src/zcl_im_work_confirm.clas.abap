class ZCL_IM_WORK_CONFIRM definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_WORKORDER_CONFIRM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_WORK_CONFIRM IMPLEMENTATION.


  method IF_EX_WORKORDER_CONFIRM~AT_CANCEL_CHECK.
  endmethod.


  METHOD if_ex_workorder_confirm~at_save.
*
    IF ( sy-tcode = 'CO11N' OR sy-tcode = 'CO15' ) AND is_confirmation-aueru = 'X'.

      DATA : lv_bdmng TYPE resb-bdmng,
             lv_enmng TYPE resb-enmng.

      SELECT SUM( bdmng ) FROM resb INTO lv_bdmng WHERE aufnr = is_confirmation-aufnr
                                                  AND xloek NE 'X' .


      SELECT SUM( enmng ) FROM resb INTO lv_enmng WHERE aufnr = is_confirmation-aufnr
                                                    AND xloek NE 'X' .

      IF lv_enmng LT lv_bdmng .
        MESSAGE 'Material Shortages exists or partial quantity confirmation' TYPE 'E' . "DISPLAY LIKE 'I'.
        SET SCREEN sy-dynnr.
        LEAVE SCREEN.
      ENDIF.


    ENDIF.
*    BREAK primus.

****************************************CODE****************************************
* ****************Below code
    IF sy-tcode = 'CO11N' OR sy-tcode = 'CO15'.
      TYPES:
        BEGIN OF t_resb,
          rsnum TYPE resb-rsnum,
          rspos TYPE resb-rspos,
          rsart TYPE resb-rsart,
          matnr TYPE resb-matnr,
          werks TYPE resb-werks,
          lgort TYPE resb-lgort,
          bdmng TYPE resb-bdmng,
          enmng TYPE resb-enmng,
          aufnr TYPE resb-aufnr,
          XLOEK TYPE resb-XLOEK,
        END OF t_resb.

      TYPES:
        BEGIN OF t_aufm,
          mblnr TYPE aufm-mblnr,
          mjahr TYPE aufm-mjahr,
          zeile TYPE aufm-zeile,
          bwart TYPE aufm-bwart,
          matnr TYPE aufm-matnr,
          werks TYPE aufm-werks,
          menge TYPE aufm-menge,
          aufnr TYPE aufm-aufnr,
        END OF t_aufm.

      DATA:
        lt_resb     TYPE STANDARD TABLE OF t_resb,
        ls_resb     TYPE t_resb,
        lt_aufm     TYPE STANDARD TABLE OF t_aufm,
        lt_aufm1    TYPE STANDARD TABLE OF t_aufm,
        ls_aufm     TYPE t_aufm,
        lv_qty      TYPE p decimals 6,"aufm-menge,           " For Ratio of component to header material
        lv_conf     TYPE aufm-menge,           " Total Confirmed qty of header material 101,102
        lv_menge    TYPE aufm-menge,           " Total component qty 261,262
        lv_req      TYPE aufm-menge,           " Total Required component qty for current yeild qty
        lv_consumed TYPE aufm-menge,        " Total component consumed for header confirmed material
        lv_av_qty   TYPE aufm-menge,          " Total Available Component Qty
        lv_index    TYPE sy-tabix.
*        lv_msg      TYPE char200.
*BREAK primus.
      SELECT rsnum
             rspos
             rsart
             matnr
             werks
             lgort
             bdmng
             enmng
             aufnr
             XLOEK
        FROM resb
        INTO TABLE lt_resb
        WHERE aufnr = is_confirmation-aufnr
          AND XLOEK NE 'X'.

      SELECT mblnr
             mjahr
             zeile
             bwart
             matnr
             werks
             menge
             aufnr
        FROM aufm
        INTO TABLE lt_aufm
        WHERE aufnr = is_confirmation-aufnr
        AND   bwart IN ('101','102','261','262','531','532').



      lt_aufm1[] = lt_aufm[].
      DELETE lt_aufm1 WHERE bwart = '101'.
      DELETE lt_aufm1 WHERE bwart = '102'.



*      IF lt_aufm1 IS INITIAL.
*        MESSAGE 'Component Material are not yet issued' TYPE 'E'.
*        SET SCREEN sy-dynnr.
*        LEAVE SCREEN.
*      ENDIF.

      LOOP AT lt_aufm INTO ls_aufm.
        IF ls_aufm-bwart = '101'.
          lv_conf = lv_conf + ls_aufm-menge.
        ELSEIF ls_aufm-bwart = '102'.
          lv_conf = lv_conf - ls_aufm-menge.
        ENDIF.
      ENDLOOP.

      SORT lt_resb BY matnr.
      SORT lt_aufm1 BY matnr.

      LOOP AT lt_resb INTO ls_resb.
        READ TABLE lt_aufm into ls_aufm WITH  KEY matnr = ls_resb-matnr.
*        if sy-subrc ne 0.
*          MESSAGE 'Component Material are not yet issued' TYPE 'E'.
*        SET SCREEN sy-dynnr.
*        LEAVE SCREEN.
*      ENDIF.

        READ TABLE lt_aufm1 INTO ls_aufm WITH KEY matnr = ls_resb-matnr.
        IF sy-subrc IS INITIAL.
          lv_index = sy-tabix.
          LOOP AT lt_aufm1 INTO ls_aufm FROM lv_index.
            IF ls_aufm-matnr = ls_resb-matnr.
              IF ls_aufm-bwart = '261'.
                lv_menge = lv_menge + ls_aufm-menge.
              ELSEIF ls_aufm-bwart = '262'.
                lv_menge = lv_menge - ls_aufm-menge.
              ELSEIF ls_aufm-bwart = '531'.
                lv_menge = lv_menge + ls_aufm-menge.
              ELSEIF ls_aufm-bwart = '532'.
                lv_menge = lv_menge - ls_aufm-menge.
              ENDIF.
            ELSE.
              EXIT.
            ENDIF.

          ENDLOOP.
        ENDIF.
          IF NOT lv_menge IS INITIAL.
            " Calculate ratio of component for 1 header material
            lv_qty  = ls_resb-bdmng / is_confirmation-smeng.
            " Total required component qty for current yeild qty.
            lv_req  = lv_qty * is_confirmation-lmnga.
            "Total Consumed component qty for header material uptill now
            lv_consumed = lv_conf * lv_qty.

            lv_av_qty = lv_menge - lv_consumed.

            IF lv_av_qty < lv_req.

*              CONCATENATE 'Required Qty for ' ls_resb-matnr 'is not issued'  INTO lv_msg SEPARATED BY space.
              MESSAGE 'Required Quantity of Component Materials is Not Issued ' TYPE 'E'.
              SET SCREEN sy-dynnr.
              LEAVE SCREEN.
            ENDIF.

          ELSE.
*            CONCATENATE ls_resb-matnr 'is not issued for above order' INTO lv_msg SEPARATED BY space.
            MESSAGE 'Component Material is Not Issued For Above Order' TYPE 'E'.
            SET SCREEN sy-dynnr.
            LEAVE SCREEN.
          ENDIF.

*        ENDIF.
        CLEAR: lv_qty,lv_menge,lv_req,lv_consumed,lv_av_qty,lv_index.
      ENDLOOP.
    ENDIF.

********************************************END CODE ***************************************
  ENDMETHOD.


  method IF_EX_WORKORDER_CONFIRM~BEFORE_UPDATE.
  endmethod.


  method IF_EX_WORKORDER_CONFIRM~INDIVIDUAL_CAPACITY.
  endmethod.


  method IF_EX_WORKORDER_CONFIRM~IN_UPDATE.
  endmethod.
ENDCLASS.
