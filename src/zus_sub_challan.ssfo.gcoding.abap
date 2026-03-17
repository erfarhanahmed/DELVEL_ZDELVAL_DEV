select SINGLE lifnr
  FROM mseg INTO wa_mseg WHERE mblnr = mblnr.

  SELECT SINGLE bldat ,bktxt
    FROM mkpf INTO @DATA(wa_mkpf) WHERE mblnr = @mblnr.

    CONCATENATE  WA_MKPF+4(2) '/' WA_MKPF+6(2)  '/' WA_MKPF+0(4)
     INTO LV_BLDAT.

   CONCATENATE  SY-DATUM+4(2) '/' SY-DATUM+6(2)  '/' SY-DATUM+0(4)
     INTO GV_PRICING.

*BREAK PRIMUSABAP.
    SELECT SINGLE name1 stras pstlz ort01 FROM lfa1
      INTO wa_lfa1 WHERE lifnr = wa_mseg.

select * from mseg
  INTO TABLE @data(it_mseg)
  where mblnr = @mblnr
  and bukrs = 'US00'
  and xauto = 'X'.

  select * from ZSUB_CHALLAN
    into TABLE @data(it_ZSUB_CHALLAN)
    where zmblnr = @mblnr.

 select * FROM makt
   INTO TABLE @data(it_makt)
   FOR ALL ENTRIES IN @it_mseg
   WHERE matnr = @it_mseg-matnr
   and spras = 'E'.

loop at it_mseg INTO Data(wa_mseg1).
  gv_count = gv_count + 1.

     wa_line_item-count = gv_count.
     wa_line_item-matnr = wa_mseg1-matnr.
*     data :gv_menge TYPE p decimals  2.
     wa_line_item-menge = wa_mseg1-menge.
*     gv_menge  = wa_mseg1-menge.
*     wa_line_item-menge = gv_menge .
*     SHIFT  wa_line_item-menge LEFT DELETING LEADING '0'.
     wa_line_item-zeile = wa_mseg1-zeile.
     wa_line_item-mblnr = wa_mseg1-mblnr.
     SHIFT wa_line_item-zeile LEFT DELETING LEADING '0'.

  read TABLE it_makt INTO data(wa_makt) with key matnr =  wa_line_item-matnr.
     if sy-subrc is INITIAL.
       wa_line_item-maktx = wa_makt-maktx.
     endif.
 read TABLE it_zsub_challan INTO Data(wa_zsub_challan) with key
                          zmblnr = wa_mseg1-mblnr
                          zmatnr =  wa_line_item-matnr.
 if sy-subrc is INITIAL.
    wa_line_item-zrate = wa_zsub_challan-zrate.
    wa_line_item-ZSHIP_DATE = wa_zsub_challan-ZSHIP_DATE.
*     SHIFT  wa_line_item-zrate LEFT DELETING LEADING '0'.
     wa_line_item-ZREMARKS = wa_zsub_challan-ZREMARKS.
 endif.
* data :gv_value type p decimals 2.
*    gv_value  = wa_line_item-menge * wa_line_item-zrate.
*    wa_line_item-value = gv_value.
wa_line_item-value = wa_line_item-menge * wa_line_item-zrate.
append wa_line_item to it_line_item.
clear :  wa_line_item, wa_mseg1, wa_makt, wa_zsub_challan.
endloop.

SELECT SINGLE zterm , Inco1 INTO (@gv_zterm ,@gv_Inco1 )
  FROM lfm1 WHERE LIFNR = @wa_mseg.

  SELECT SINGLE TEXT1 FROM T052U INTO @desc
    WHERE ZTERM = @gv_zterm AND SPRAS eq 'E' .

*    SELECT SINGLE BEZEI FROM TINCT INTO @gv_BEZEI
*      WHERE INCO1 = @gv_Inco1.

 SELECT SINGLE INCO2 FROM LFM1 INTO @gv_BEZEI
      WHERE INCO1 = @gv_Inco1
       AND LIFNR = @WA_MSEG.

      SELECT SINGLE ZSHIP_METHOD FROM ZSUB_REMARK
  INto GV_SHIP_METHOD WHERE MBLNR = mblnr.
*BREAK PRIMUSABAP.
   SELECT SINGLE ZDISCOUNT zfreight zterm_cond FROM ZSUB_REMARK
  INto ( GV_disc , gv_freight ,zterm_cond ) WHERE MBLNR = mblnr.
  gv_freight1 = gv_freight.
     SHIFT GV_disc LEFT DELETING LEADING '0'.
*  gv_disc1 = gv_disc.
