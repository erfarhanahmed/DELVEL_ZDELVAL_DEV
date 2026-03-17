*BREAK primus.
IF ls_vbrk_j-fkart = 'ZEXP'.
  SELECT SINGLE * FROM kna1 INTO gv_kna1 WHERE kunnr = kunnr.
  SELECT SINGLE * FROM kna1 INTO to_kna1 WHERE kunnr = ls_vbrk_j-kunag.
  SELECT SINGLE * FROM adrc INTO to_adrc WHERE
                  addrnumber = to_kna1-adrnr.
  CONCATENATE to_adrc-str_suppl1 to_adrc-street INTO ls_final_eway-toaddr1
                          SEPARATED BY space.
  CONCATENATE to_adrc-str_suppl2 to_adrc-city2 INTO ls_final_eway-toaddr2
                      SEPARATED BY space.

  ls_final_eway-tostatecode = ' '.
  ls_final_eway-topincode = ' '.


ELSE.
  SELECT SINGLE * FROM kna1 INTO gv_kna1 WHERE kunnr = ship_to.
ENDIF.


SELECT SINGLE * FROM adrc INTO gv_adrc WHERE
                addrnumber = gv_kna1-adrnr.
CONCATENATE gv_adrc-str_suppl1 gv_adrc-street INTO gv_toaddr1
                        SEPARATED BY space.

CONCATENATE gv_adrc-str_suppl2 gv_adrc-city2 INTO gv_toaddr2
                    SEPARATED BY space.
SELECT SINGLE legal_state_code INTO gv_tostatecode FROM j_1istatecdm
  WHERE std_state_code = gv_kna1-regio.
*BREAK PRIMUSABAP.
SELECT SINGLE * FROM vbrp INTO @DATA(wa_vbrp_new)
  WHERE vbeln = @ls_vbrk_j-vbeln.
*SELECT SINGLE LGORT FROM MSEG INTO GV_LGORT WHERE MBLNR = Wa_vbrp_NEW-VGBEL
*
*  BREAK PRIMUSABAP.                                                 "AND XAUTO NE 'X'.
LOOP AT lt_vbrp INTO wa_vbrp.
*  SELECT SINGLE LGORT FROM MSEG INTO GV_LGORT WHERE MBLNR = Wa_vbrp-VGBEL
*                                                       AND XAUTO NE 'X'.
  IF ls_vbrk_j-fkart = 'ZDC'. "ADDED BY JYOTI ON 16.06.2024
    CLEAR : gv_kna1-regio , gv_tostatecode, gv_toaddr1,
    gv_toaddr2, gv_kna1-name1, gv_kna1-stcd3,gv_kna1-pstlz,gv_kna1-ort01.
*            IF GV_LGORT = 'SAN1'. "ADDED BY JYOTI ON 16.06.2024
    IF wa_vbrp-lgort = 'SAN1'. "ADDED BY JYOTI ON 16.06.2024
*            wa_final-location  = 'SANGVI'."wa_adrc-city1.
      ls_final_eway-totrdname      = 'DelVal Flow Controls Private Limited.'."wa_adrc-name1.
*            to_adrc-str_suppl1     = 'Gat No 351,MILKAT NO.733,733/1,'."wa_adrc-str_suppl1.
*            to_adrc-street = '733/2 SHIRVAL NAIGAON ROAD SANGVI'.
      ls_final_eway-tostatecode = '13'."wa_adrc-region.
      ls_final_eway-topincode = '412801'."wa_adrc-post_code1.
      CONCATENATE'Gat No 351,MILKAT NO.733,733/1,'
       '733/2 SHIRVAL NAIGAON ROAD SANGVI' INTO ls_final_eway-toaddr1
                       SEPARATED BY space.
*CONCATENATE to_adrc-str_suppl2 to_adrc-city2 INTO ls_final_eway-toaddr2
*                    SEPARATED BY space.
    ELSEIF wa_vbrp-lgort = 'RM01' OR wa_vbrp-lgort = 'FG01' OR wa_vbrp-lgort = 'MCN1' OR wa_vbrp-lgort = 'PLG1'
*        OR WA_VBRP-LGORT ='PN01'
     OR wa_vbrp-lgort = 'PRD1' OR wa_vbrp-lgort = 'RJ01'
          OR wa_vbrp-lgort = 'RWK1' OR wa_vbrp-lgort = 'TPI1' OR
          wa_vbrp-lgort = 'VLD1' OR WA_VBRP-LGORT = 'SC01' OR
      WA_VBRP-LGORT = 'SFG1'.
*          ELSEIF wa_vbrp-LGORT = 'RM01'.
      READ TABLE it_t001w INTO wa_t001w WITH KEY werks = wa_vbrp_new-werks.
      IF sy-subrc = 0.
        READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_t001w-adrnr.
        IF sy-subrc = 0.
*            wa_final-location = wa_adrc-city1.
          ls_final_eway-totrdname =   wa_adrc-name1.
          to_adrc-str_suppl1 = wa_adrc-str_suppl1.
          to_adrc-street = wa_adrc-str_suppl2.
          ls_final_eway-tostatecode = wa_adrc-region.
          ls_final_eway-topincode = wa_adrc-post_code1.
          CONCATENATE to_adrc-str_suppl1 to_adrc-street INTO ls_final_eway-toaddr1
                       SEPARATED BY space.
*CONCATENATE to_adrc-str_suppl2 to_adrc-city2 INTO ls_final_eway-toaddr2
*                    SEPARATED BY space.
        ENDIF.
      ENDIF.
    ELSEIF wa_vbrp-lgort+0(1) = 'K'.
      SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad)
      WHERE werks = @wa_vbrp-werks AND lgort = 'KPR1'.
      IF wa_twlad IS NOT INITIAL.
        SELECT SINGLE street, city1, post_code1 FROM adrc
            INTO @DATA(wa_adrc_t) WHERE addrnumber = @wa_twlad.
      ENDIF.
      IF wa_adrc_t IS NOT INITIAL.
*                  wa_final-location = WA_ADRC_T-CITY1.
        ls_final_eway-totrdname  = 'DelVal Flow Controls Private Limited.'.
        to_adrc-str_suppl1 = wa_adrc_t-street.
        to_adrc-street = wa_adrc_t-city1.
        ls_final_eway-tostatecode = '13'.
        ls_final_eway-topincode = wa_adrc_t-post_code1.
      ENDIF.
      CONCATENATE to_adrc-str_suppl1 to_adrc-street INTO ls_final_eway-toaddr1
            SEPARATED BY space.
*CONCATENATE to_adrc-str_suppl2 to_adrc-city2 INTO ls_final_eway-toaddr2
*                    SEPARATED BY space.
      BREAK PRIMUSABAP.
    ELSEIF wa_vbrp-lgort = 'PN01'.
      SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_1)
 WHERE werks = @wa_vbrp-werks AND lgort = 'PN01'.
      IF wa_twlad_1 IS NOT INITIAL.
        SELECT SINGLE street, city1, post_code1 FROM adrc
            INTO @DATA(wa_adrc_t_1) WHERE addrnumber = @wa_twlad_1.
      ENDIF.
      IF wa_adrc_t_1 IS NOT INITIAL.
*                  wa_final-location = WA_ADRC_T-CITY1.
        ls_final_eway-totrdname  = 'DelVal Flow Controls Private Limited.'.
        to_adrc-str_suppl1 = wa_adrc_t_1-street.
        to_adrc-street = wa_adrc_t_1-city1.
        ls_final_eway-tostatecode = '13'.
        ls_final_eway-topincode = wa_adrc_t_1-post_code1.
      ENDIF.
    ENDIF.
  ENDIF.

ENDLOOP.
